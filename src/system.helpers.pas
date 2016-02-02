{**********************************************************************
    Copyright(c) 2016 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit System.Helpers;

{$IFDEF ENABLE_UNICODE}{$MODE DELPHIUNICODE}{$ELSE}{$MODE DELPHI}{$ENDIF}{$H+}
{$CODEPAGE UTF8}
{$MODESWITCH ADVANCEDRECORDS}
{$MODESWITCH TYPEHELPERS}

interface

uses
  Types, SysUtils;

type
  {$IF (FPC_VERSION = 3) AND (FPC_RELEASE = 0)}
  TEndian = (Big, Little);
  {$IFEND}

  TGuidHelper = record helper for System.TGUID
  public
    {$IFDEF CLOSER_TO_DELPHI}
    class function Create(const S: string): TGUID; overload; static;
    {$ELSE}
    class function Create(const S: AnsiString): TGUID; overload; static;
    class function Create(const S: UnicodeString): TGUID; overload; static;
    {$ENDIF CLOSER_TO_DELPHI}
    class function Create(const Data; DataEndian: TEndian =
      {$IFDEF ENDIAN_BIG}TEndian.Big{$ELSE}TEndian.Little{$ENDIF}): TGUID;
      overload; static;
    class function Create(const B: TBytes; DataEndian: TEndian =
      {$IFDEF ENDIAN_BIG}TEndian.Big{$ELSE}TEndian.Little{$ENDIF}): TGUID;
      overload; static;
    class function Create(const B: TBytes; AStartIndex: Cardinal; DataEndian:
      TEndian = {$IFDEF ENDIAN_BIG}TEndian.Big{$ELSE}TEndian.Little{$ENDIF}):
      TGUID; overload; static;
    class function Create(A: Integer; B: SmallInt; C: SmallInt;
      const D: TBytes): TGUID; overload; static;
    class function Create(A: Integer; B: SmallInt; C: SmallInt; D, E, F, G, H,
      I, J, K: Byte): TGUID; overload; static;
    class function Create(A: Cardinal; B: Word; C: Word; D, E, F, G, H, I, J,
      K: Byte): TGUID; overload; static;
    class function Empty: TGUID; static;
    class function NewGuid: TGUID; static;
    function ToByteArray(DataEndian: TEndian =
     {$IFDEF ENDIAN_BIG}TEndian.Big{$ELSE}TEndian.Little{$ENDIF}): TBytes;
    function ToString: string;
  end;

implementation

uses
  System.Helpers.Strings;

{ TGuidHelper }

{$IFDEF CLOSER_TO_DELPHI}
class function TGuidHelper.Create(const S: string): TGUID;
{$ELSE}
class function TGuidHelper.Create(const S: AnsiString): TGUID;
{$ENDIF CLOSER_TO_DELPHI}
begin
  Result := StringToGUID(S);
end;

{$IFNDEF CLOSER_TO_DELPHI}
class function TGuidHelper.Create(const S: UnicodeString): TGUID;
begin
  Result := StringToGUID(AnsiString(S));
end;
{$ENDIF !CLOSER_TO_DELPHI}

class function TGuidHelper.Create(const Data; DataEndian: TEndian): TGUID;
begin
  Result := TGUID(Data);
  if DataEndian = {$IFDEF ENDIAN_BIG}TEndian.Little{$ELSE}TEndian.Big{$ENDIF} then
  begin
    Result.D1 := SwapEndian(Result.D1);
    Result.D2 := SwapEndian(Result.D2);
    Result.D3 := SwapEndian(Result.D3);
  end;
end;

class function TGuidHelper.Create(const B: TBytes; DataEndian: TEndian): TGUID;
begin
  Result := Create(B, 0, DataEndian);
end;

class function TGuidHelper.Create(const B: TBytes; AStartIndex: Cardinal;
  DataEndian: TEndian): TGUID;
var
  MaxIndex: TDynArrayIndex;
begin
  MaxIndex := TDynArrayIndex(AStartIndex + SizeOf(TGUID));
  if MaxIndex < 0 then
    OutOfMemoryError;

  if Length(B) >= MaxIndex then
    Result := Create(B[AStartIndex], DataEndian)
  else
    raise EArgumentException.CreateFmt(SInvalidGuidArray, [SizeOf(TGUID)]);
end;

class function TGuidHelper.Create(A: Integer; B: SmallInt; C: SmallInt;
  const D: TBytes): TGUID;
begin
  if Length(D) = Length(Result.D4) then
  begin
    Result.D1 := DWord(A);
    Result.D2 := Word(B);
    Result.D3 := Word(C);
    Move(D[0], Result.D4[0], SizeOf(Result.D4));
  end
  else
    raise EArgumentException.CreateFmt(SInvalidGuidArray, [8]);
end;

class function TGuidHelper.Create(A: Integer; B: SmallInt; C: SmallInt; D, E, F,
  G, H, I, J, K: Byte): TGUID;
begin
  Result.D1 := DWord(A);
  Result.D2 := Word(B);
  Result.D3 := Word(C);
  Result.D4[0] := D;
  Result.D4[1] := E;
  Result.D4[2] := F;
  Result.D4[3] := G;
  Result.D4[4] := H;
  Result.D4[5] := I;
  Result.D4[6] := J;
  Result.D4[7] := K;
end;

class function TGuidHelper.Create(A: Cardinal; B: Word; C: Word; D, E, F, G, H,
  I, J, K: Byte): TGUID;
begin
  Result.D1 := A;
  Result.D2 := B;
  Result.D3 := C;
  Result.D4[0] := D;
  Result.D4[1] := E;
  Result.D4[2] := F;
  Result.D4[3] := G;
  Result.D4[4] := H;
  Result.D4[5] := I;
  Result.D4[6] := J;
  Result.D4[7] := K;
end;

class function TGuidHelper.Empty: TGUID;
begin
  Result := GUID_NULL;
end;

class function TGuidHelper.NewGuid: TGUID;
begin
  if CreateGUID(Result) <> S_OK then
    RaiseLastOSError;
end;

function TGuidHelper.ToByteArray(DataEndian: TEndian): TBytes;
var
  PResult: PGUID;
begin
  SetLength(Result, SizeOf(TGuid));
  PResult := @Result[0];
  case DataEndian of
    TEndian.Big:
      begin
        {$IFDEF ENDIAN_BIG}
        PResult^ := Self;
        {$ELSE}
        PResult^.D1 := SwapEndian(Self.D1);
        PResult^.D2 := SwapEndian(Self.D2);
        PResult^.D3 := SwapEndian(Self.D3);
        Move(Self.D4[0], PResult^.D4[0], SizeOf(Self.D4[0]));
        {$ENDIF}
      end;
    TEndian.Little:
      begin
        {$IFDEF ENDIAN_BIG}
        PResult^.D1 := SwapEndian(Self.D1);
        PResult^.D2 := SwapEndian(Self.D2);
        PResult^.D3 := SwapEndian(Self.D3);
        Move(Self.D4[0], PResult^.D4[0], SizeOf(Self.D4[0]));
        {$ELSE}
        PResult^ := Self;
        {$ENDIF}
      end;
  end;
end;

function TGuidHelper.ToString: string;
begin
  {$IF SIZEOF(Char) = 2}
  Result := UnicodeString(GuidToString(Self));
  {$ELSE}
  Result := GuidToString(Self);
  {$IFEND}
end;

end.

