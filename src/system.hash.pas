{**********************************************************************
    Copyright(c) 2016 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit System.Hash;

{$IFDEF ENABLE_UNICODE}{$MODE DELPHIUNICODE}{$ELSE}{$MODE DELPHI}{$ENDIF}{$H+}
{$CODEPAGE UTF8}
{$MODESWITCH ADVANCEDRECORDS}

interface

uses
  SysUtils;

type
  EHashException = class(Exception);

  THash = record
    class function DigestAsInteger(const ADigest: TBytes): Integer; static;
    class function DigestAsString(const ADigest: TBytes): string;
      overload; static;
    class function DigestAsStringGUID(const ADigest: TBytes): string; static;
    class function GetRandomString(const ALen: Integer = 10): string; static;
    class function ToBigEndian(AValue: Cardinal): Cardinal; overload; static;
      {$IFNDEF TEST}inline;{$ENDIF}
    class function ToBigEndian(AValue: UInt64): UInt64; overload; static;
      {$IFNDEF TEST}inline;{$ENDIF}
  end;

implementation

uses
  Types, System.Helpers;

const
  HC: array [0..66] of Char = (
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e',
    'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't',
    'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I',
    'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
    'Y', 'Z', '*', '+', '-', '/', '_'
  );

{ THash }
class function THash.DigestAsInteger(const ADigest: TBytes): Integer;
var
  MappedInt: PInteger absolute ADigest;
begin
  if Length(ADigest) <> 4 then
    raise EHashException.Create('Digest size must be 4 to Generate a Integer');

  Result := MappedInt^;
end;

class function THash.DigestAsString(const ADigest: TBytes): string;
var
  i: Integer;
begin
  Result := '';
  for i := Low(ADigest) to High(ADigest) do
    Result := Result + HC[(ADigest[i] shr 4)] + HC[ADigest[i] and $0f];
end;

class function THash.DigestAsStringGUID(const ADigest: TBytes): string;
var
  TempGuid: TGUID;
begin
  TempGuid := TempGuid.Create(ADigest, TEndian.Big);
  Result := TempGuid.ToString;
end;

class function THash.GetRandomString(const ALen: Integer): string;
var
  i: Integer;
begin
  if ALen > 0 then
  begin
    SetLength(Result, ALen);
    for i := 1 to ALen do
      Result[i] := HC[Random(Length(HC))];
  end
  else
    Result := '';
end;

class function THash.ToBigEndian(AValue: Cardinal): Cardinal;
begin
  Result := NtoBE(AValue);
end;

class function THash.ToBigEndian(AValue: UInt64): UInt64;
begin
  Result := NtoBE(AValue);
end;

end.

