{**********************************************************************
    Copyright(c) 2016 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit System.Helpers;

{$I ngplus.inc}

interface

uses
  {$IFDEF WINDOWS}
  Windows,
  {$ENDIF}
  Types, SysUtils;

type
  {$IF (FPC_VERSION = 3) AND (FPC_RELEASE = 0)}
  TEndian = (Big, Little);
  {$IFEND}

  TGuidHelper = record helper for System.TGUID
  public
    class function Create(const S: AnsiString): TGUID; overload; static;
    class function Create(const S: UnicodeString): TGUID; overload; static;
    class function Create(const Data; DataEndian: TEndian = {$IFDEF ENDIAN_BIG}TEndian.Big{$ELSE}TEndian.Little{$ENDIF}): TGUID; overload; static;
    class function Create(const B: TBytes; DataEndian: TEndian = {$IFDEF ENDIAN_BIG}TEndian.Big{$ELSE}TEndian.Little{$ENDIF}): TGUID; overload; static;
    class function Create(const B: TBytes; AStartIndex: Cardinal; DataEndian: TEndian = {$IFDEF ENDIAN_BIG}TEndian.Big{$ELSE}TEndian.Little{$ENDIF}): TGUID; overload; static;
    class function Create(A: Integer; B: SmallInt; C: SmallInt; const D: TBytes): TGUID; overload; static;
    class function Create(A: Integer; B: SmallInt; C: SmallInt; D, E, F, G, H, I, J, K: Byte): TGUID; overload; static;
    class function Create(A: Cardinal; B: Word; C: Word; D, E, F, G, H, I, J, K: Byte): TGUID; overload; static;
    class function Empty: TGUID; static;
    class function NewGuid: TGUID; static;
    function ToByteArray(DataEndian: TEndian = {$IFDEF ENDIAN_BIG}TEndian.Big{$ELSE}TEndian.Little{$ENDIF}): TBytes;
    function ToString: string;
  end;

  TLocaleID = {$IFDEF WINDOWS}LCID{$ELSE}DWord{$ENDIF};
  TLocaleOptions = (loInvariantLocale, loUserLocale);
  TStringSplitOptions = (None, ExcludeEmpty);

  TShortStringHelper = record helper for ShortString
  public

    class function ToInteger(const S: ShortString): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    //class function ToInt64(const S: ShortString): Int64; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}

    function ToInteger: Integer; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    //function ToInt64: Int64; overload; {$IFNDEF _TEST}inline;{$ENDIF}

    function ToLower: ShortString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToLower(LocaleID: TLocaleID): ShortString; overload;
    function ToLowerInvariant: ShortString;

  end;

  TAnsiStringHelper = record helper for AnsiString
  public

    class function ToInteger(const S: AnsiString): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    //class function ToInt64(const S: AnsiString): Int64; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}

    function ToInteger: Integer; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    //function ToInt64: Int64; overload; {$IFNDEF _TEST}inline;{$ENDIF}

    function ToLower: string; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToLower(LocaleID: TLocaleID): AnsiString; overload;
    function ToLowerInvariant: AnsiString;

  end;

  TRawByteStringHelper = record helper for RawByteString
  public

    class function ToInteger(const S: RawByteString): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    //class function ToInt64(const S: RawByteString): Int64; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}

    function ToInteger: Integer; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    //function ToInt64: Int64; overload; {$IFNDEF _TEST}inline;{$ENDIF}

    function ToLower: RawByteString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToLower(LocaleID: TLocaleID): RawByteString; overload;
    function ToLowerInvariant: RawByteString;

  end;

  TUTF8StringHelper = record helper for UTF8String
  public

    class function ToInteger(const S: UTF8String): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    //class function ToInt64(const S: UTF8String): Int64; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}

    function ToInteger: Integer; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    //function ToInt64: Int64; overload; {$IFNDEF _TEST}inline;{$ENDIF}

    function ToLower: UTF8String; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToLower(LocaleID: TLocaleID): UTF8String; overload;
    function ToLowerInvariant: UTF8String;

  end;

  TWideStringHelper = record helper for WideString
  public

    class function ToInteger(const S: WideString): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    //class function ToInt64(const S: WideString): Int64; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}

    function ToInteger: Integer; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    //function ToInt64: Int64; overload; {$IFNDEF _TEST}inline;{$ENDIF}

    function ToLower: WideString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToLower(LocaleID: TLocaleID): WideString; overload;
    function ToLowerInvariant: WideString;

  end;

  TUnicodeStringHelper = record helper for UnicodeString
  public

    class function ToInteger(const S: UnicodeString): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    //class function ToInt64(const S: UnicodeString): Int64; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}

    function ToInteger: Integer; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    //function ToInt64: Int64; overload; {$IFNDEF _TEST}inline;{$ENDIF}

    function ToLower: UnicodeString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToLower(LocaleID: TLocaleID): UnicodeString; overload;
    function ToLowerInvariant: UnicodeString;

  end;


implementation

uses
  System.Helpers.Strings;

{ TGuidHelper }

class function TGuidHelper.Create(const S: AnsiString): TGUID;
begin
  Result := StringToGUID(S);
end;

class function TGuidHelper.Create(const S: UnicodeString): TGUID;
begin
  Result := StringToGUID(AnsiString(S));
end;

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

class function TGuidHelper.Create(const B: TBytes; AStartIndex: Cardinal; DataEndian: TEndian): TGUID;
var
  MaxIndex: TDynArrayIndex;
begin
  MaxIndex := TDynArrayIndex(AStartIndex + SizeOf(TGUID));
  if MaxIndex < 0 then
    OutOfMemoryError;

  if Length(B) >= MaxIndex then
    Result := Create(B[AStartIndex], DataEndian)
  else
    raise EArgumentException.CreateResFmt(@SInvalidGuidArray, [SizeOf(TGUID)]);
end;

class function TGuidHelper.Create(A: Integer; B: SmallInt; C: SmallInt; const D: TBytes): TGUID;
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

class function TGuidHelper.Create(A: Integer; B: SmallInt; C: SmallInt; D, E, F, G, H, I, J, K: Byte): TGUID;
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

class function TGuidHelper.Create(A: Cardinal; B: Word; C: Word; D, E, F, G, H, I, J, K: Byte): TGUID;
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

{ TShortStringHelper }

class function TShortStringHelper.ToInteger(const S: ShortString): Integer;
begin
  Result := SysUtils.StrToInt(S);
end;

//class function TShortStringHelper.ToInt64(const S: ShortString): Int64;
//begin

//end;

function TShortStringHelper.ToInteger: Integer;
begin
  Result := Self.ToInteger(Self);
end;

//function TShortStringHelper.ToInt64: Int64;
//begin

//end;


function TShortStringHelper.ToLower: ShortString;
begin

end;

function TShortStringHelper.ToLower(LocaleID: TLocaleID): ShortString;
begin

end;

function TShortStringHelper.ToLowerInvariant: ShortString;
begin

end;


{ TAnsiStringHelper }

class function TAnsiStringHelper.ToInteger(const S: AnsiString): Integer;
begin
  Result := SysUtils.StrToInt(S);
end;

//class function TAnsiStringHelper.ToInt64(const S: AnsiString): Int64;
//begin

//end;

function TAnsiStringHelper.ToInteger: Integer;
begin
  Result := Self.ToInteger(Self);
end;

//function TAnsiStringHelper.ToInt64: Int64;
//begin

//end;


function TAnsiStringHelper.ToLower: AnsiString;
begin

end;

function TAnsiStringHelper.ToLower(LocaleID: TLocaleID): AnsiString;
begin

end;

function TAnsiStringHelper.ToLowerInvariant: AnsiString;
begin

end;


{ TRawByteStringHelper }

class function TRawByteStringHelper.ToInteger(const S: RawByteString): Integer;
begin
  Result := SysUtils.StrToInt(S);
end;

//class function TRawByteStringHelper.ToInt64(const S: RawByteString): Int64;
//begin

//end;

function TRawByteStringHelper.ToInteger: Integer;
begin
  Result := Self.ToInteger(Self);
end;

//function TRawByteStringHelper.ToInt64: Int64;
//begin

//end;


function TRawByteStringHelper.ToLower: RawByteString;
begin

end;

function TRawByteStringHelper.ToLower(LocaleID: TLocaleID): RawByteString;
begin

end;

function TRawByteStringHelper.ToLowerInvariant: RawByteString;
begin

end;


{ TUTF8StringHelper }

class function TUTF8StringHelper.ToInteger(const S: UTF8String): Integer;
begin
  Result := SysUtils.StrToInt(S);
end;

//class function TUTF8StringHelper.ToInt64(const S: UTF8String): Int64;
//begin

//end;

function TUTF8StringHelper.ToInteger: Integer;
begin
  Result := Self.ToInteger(Self);
end;

//function TUTF8StringHelper.ToInt64: Int64;
//begin

//end;


function TUTF8StringHelper.ToLower: UTF8String;
begin

end;

function TUTF8StringHelper.ToLower(LocaleID: TLocaleID): UTF8String;
begin

end;

function TUTF8StringHelper.ToLowerInvariant: UTF8String;
begin

end;


{ TWideStringHelper }

class function TWideStringHelper.ToInteger(const S: WideString): Integer;
begin
  Result := SysUtils.StrToInt(S);
end;

//class function TWideStringHelper.ToInt64(const S: WideString): Int64;
//begin

//end;

function TWideStringHelper.ToInteger: Integer;
begin
  Result := Self.ToInteger(Self);
end;

//function TWideStringHelper.ToInt64: Int64;
//begin

//end;


function TWideStringHelper.ToLower: WideString;
begin

end;

function TWideStringHelper.ToLower(LocaleID: TLocaleID): WideString;
begin

end;

function TWideStringHelper.ToLowerInvariant: WideString;
begin

end;


{ TUnicodeStringHelper }

class function TUnicodeStringHelper.ToInteger(const S: UnicodeString): Integer;
begin
  Result := SysUtils.StrToInt(S);
end;

//class function TUnicodeStringHelper.ToInt64(const S: UnicodeString): Int64;
//begin

//end;

function TUnicodeStringHelper.ToInteger: Integer;
begin
  Result := Self.ToInteger(Self);
end;

//function TUnicodeStringHelper.ToInt64: Int64;
//begin

//end;


function TUnicodeStringHelper.ToLower: UnicodeString;
begin

end;

function TUnicodeStringHelper.ToLower(LocaleID: TLocaleID): UnicodeString;
begin

end;

function TUnicodeStringHelper.ToLowerInvariant: UnicodeString;
begin

end;



end.

