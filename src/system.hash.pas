{**********************************************************************
    Based on headers from documentation:
    http://docwiki.embarcadero.com/Libraries/Seattle/en/System.Hash

    Copyright(c) 2016 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit System.Hash;

{$I ngplus.inc}

interface

uses
  {$IF DEFINED(WITH_OPENSSL) OR DEFINED(WITH_WINAPI)}
  System.Hash.Helpers,
  {$ELSE}
  {$IFEND}
  SysUtils;

type
  EHashException = class(Exception);

  {$IFDEF CLOSER_TO_DELPHI}
  HashLen = Cardinal;
  {$ELSE}
  HashLen = PtrUInt;
  {$ENDIF}

  THash = record
    class function DigestAsInteger(const ADigest: TBytes): Integer; static;
    class function DigestAsString(const ADigest: TBytes): string;
      overload; static;
    class function DigestAsStringGUID(const ADigest: TBytes): string; static;
    class function GetRandomString(const ALen: Integer = 10): string; static;
    class function ToBigEndian(AValue: Cardinal): Cardinal; overload; static; {$IFNDEF TEST}inline;{$ENDIF}
    class function ToBigEndian(AValue: UInt64): UInt64; overload; static; {$IFNDEF TEST}inline;{$ENDIF}
  end;

  THashMD5 = record
  private const
    {$IFNDEF WITH_OPENSSL}
    {$IFNDEF WITH_WINAPI}HASH_SIZE = 16;{$ENDIF !WITH_WINAPI}
    BLOCK_SIZE = 64;
    {$ENDIF !WITH_OPENSSL}
  private
    {$IF DEFINED(WITH_OPENSSL)}
    {$ELSEIF  DEFINED(WITH_WINAPI)}
    FHash: IExtHash;
    {$ELSE}
    {$IFEND}
    FFinalized: Boolean;
    procedure CheckFinalized; {$IFNDEF TEST}inline;{$ENDIF}
  public
    class function Create: THashMD5; static; {$IFNDEF TEST}inline;{$ENDIF}
    procedure Reset; {$IFNDEF TEST}inline;{$ENDIF}
    procedure Update(constref AData; ALength: HashLen); overload;
    procedure Update(const AData: TBytes; ALength: HashLen = 0); overload; {$IFNDEF TEST}inline;{$ENDIF}
    procedure Update(const Input: AnsiString); overload;
    procedure Update(const Input: UnicodeString); overload; {$IFNDEF TEST}inline;{$ENDIF}
    function GetBlockSize: Integer; {$IFNDEF TEST}inline;{$ENDIF}
    function GetHashSize: Integer; {$IFNDEF TEST}inline;{$ENDIF}
    function HashAsBytes: TBytes; {$IFNDEF TEST}inline;{$ENDIF}
    function HashAsString: string; {$IFNDEF TEST}inline;{$ENDIF}
    class function GetHashBytes(const AData: AnsiString): TBytes; overload; static;
    class function GetHashBytes(const AData: UnicodeString): TBytes; overload; static;
    class function GetHashString(const AString: AnsiString): string; overload; static;
    class function GetHashString(const AString: UnicodeString): string; overload; static;
    (* class function GetHMAC(const AData, AKey: string): string; static; {$IFNDEF TEST}inline;{$ENDIF}
    class function GetHMACAsBytes(const AData, AKey: string): TBytes; overload; static;
    class function GetHMACAsBytes(const AData: string; const AKey: TBytes): TBytes; overload; static;
    class function GetHMACAsBytes(const AData: TBytes; const AKey: string): TBytes; overload; static;
    class function GetHMACAsBytes(const AData, AKey: TBytes): TBytes; overload; static; *)
  end;

  THashSHA1 = record
  private const
    {$IFNDEF WITH_OPENSSL}
    {$IFNDEF WITH_WINAPI}HASH_SIZE = 20;{$ENDIF !WITH_WINAPI}
    BLOCK_SIZE = 64;
    {$ENDIF !WITH_OPENSSL}
  private
    {$IF DEFINED(WITH_OPENSSL)}
    {$ELSEIF  DEFINED(WITH_WINAPI)}
    FHash: IExtHash;
    {$ELSE}
    {$IFEND}
    FFinalized: Boolean;
    procedure CheckFinalized; {$IFNDEF TEST}inline;{$ENDIF}
  public
    class function Create: THashSHA1; static; {$IFNDEF TEST}inline;{$ENDIF}
    procedure Reset; {$IFNDEF TEST}inline;{$ENDIF}
    procedure Update(constref AData; ALength: HashLen); overload;
    procedure Update(constref AData: TBytes; ALength: HashLen = 0); overload; {$IFNDEF TEST}inline;{$ENDIF}
    procedure Update(const Input: AnsiString); overload; {$IFNDEF TEST}inline;{$ENDIF}
    procedure Update(const Input: UnicodeString); overload; {$IFNDEF TEST}inline;{$ENDIF}
    function GetBlockSize: Integer; {$IFNDEF TEST}inline;{$ENDIF}
    function GetHashSize: Integer; {$IFNDEF TEST}inline;{$ENDIF}
    function HashAsBytes: TBytes; {$IFNDEF TEST}inline;{$ENDIF}
    function HashAsString: string; {$IFNDEF TEST}inline;{$ENDIF}
    class function GetHashBytes(const AData: AnsiString): TBytes; overload; static;
    class function GetHashBytes(const AData: UnicodeString): TBytes; overload; static;
    class function GetHashString(const AString: AnsiString): string; overload; static;
    class function GetHashString(const AString: UnicodeString): string; overload; static;
    (* class function GetHMAC(const AData, AKey: string): string; static; {$IFNDEF TEST}inline;{$ENDIF}
    class function GetHMACAsBytes(const AData, AKey: string): TBytes; overload;  static;
    class function GetHMACAsBytes(const AData: string; const AKey: TBytes): TBytes; overload; static;
    class function GetHMACAsBytes(const AData: TBytes; const AKey: string): TBytes; overload; static;
    class function GetHMACAsBytes(const AData, AKey: TBytes): TBytes; overload; static; *)
  end;

  THashSHA2 = record
  public type
    TSHA2Version = (SHA224, SHA256, SHA384, SHA512, SHA512_224, SHA512_256);
  private const
    {$IFNDEF WITH_OPENSSL}
      {$IFNDEF WITH_WINAPI}
    HASH_SIZE = array [TSHA2Version] of Integer = (28, 32,  48,  64,  28,  32);
      {$ENDIF !WITH_WINAPI}
    BLOCK_SIZE: array [TSHA2Version] of Integer = (64, 64, 128, 128, 128, 128);
    {$ENDIF !WITH_OPENSSL}
  private
    {$IF DEFINED(WITH_OPENSSL)}
    {$ELSEIF  DEFINED(WITH_WINAPI)}
    FHash: IExtHash;
    {$ELSE}
    {$IFEND}
    FFinalized: Boolean;
    procedure CheckFinalized; {$IFNDEF TEST}inline;{$ENDIF}
  {$IFDEF CLOSER_TO_DELPHI}
  public
  {$ELSE}
  private
  {$ENDIF CLOSER_TO_DELPHI}
    FVersion: TSHA2Version;
  public
    class function Create(AHashVersion: TSHA2Version = TSHA2Version.SHA256): THashSHA2; static; {$IFNDEF TEST}inline;{$ENDIF}
    procedure Reset; {$IFNDEF TEST}inline;{$ENDIF}
    procedure Update(constref AData; ALength: HashLen); overload;
    procedure Update(constref AData: TBytes; ALength: HashLen = 0); overload; {$IFNDEF TEST}inline;{$ENDIF}
    procedure Update(const Input: AnsiString); overload; {$IFNDEF TEST}inline;{$ENDIF}
    procedure Update(const Input: UnicodeString); overload; {$IFNDEF TEST}inline;{$ENDIF}
    function GetBlockSize: Integer; {$IFNDEF TEST}inline;{$ENDIF}
    function GetHashSize: Integer; {$IFNDEF TEST}inline;{$ENDIF}
    function HashAsBytes: TBytes; {$IFNDEF TEST}inline;{$ENDIF}
    function HashAsString: string; {$IFNDEF TEST}inline;{$ENDIF}
    class function GetHashBytes(const AData: AnsiString; AHashVersion: TSHA2Version = TSHA2Version.SHA256): TBytes; overload; static;
    class function GetHashBytes(const AData: UnicodeString; AHashVersion: TSHA2Version = TSHA2Version.SHA256): TBytes; overload; static;
    class function GetHashString(const AString: AnsiString; AHashVersion: TSHA2Version = TSHA2Version.SHA256): string; overload; static;
    class function GetHashString(const AString: UnicodeString; AHashVersion: TSHA2Version = TSHA2Version.SHA256): string; overload; static;
    (* class function GetHMAC(const AData, AKey: string; AHashVersion: TSHA2Version = TSHA2Version.SHA256): string; static; {$IFNDEF TEST}inline;{$ENDIF}
    class function GetHMACAsBytes(const AData, AKey: string; AHashVersion: TSHA2Version = TSHA2Version.SHA256): TBytes; overload;  static;
    class function GetHMACAsBytes(const AData: string; const AKey: TBytes; AHashVersion: TSHA2Version = TSHA2Version.SHA256): TBytes; overload; static;
    class function GetHMACAsBytes(const AData: TBytes; const AKey: string; AHashVersion: TSHA2Version = TSHA2Version.SHA256): TBytes; overload; static;
    class function GetHMACAsBytes(const AData, AKey: TBytes; AHashVersion: TSHA2Version = TSHA2Version.SHA256): TBytes; overload; static; *)
  end;

  THashBobJenkins = record
  private
  public
    class function Create: THashBobJenkins; static;
    procedure Reset(AInitialValue: Integer = 0);
    procedure Update(constref AData; ALength: HashLen); overload; {$IFNDEF TEST}inline;{$ENDIF}
    procedure Update(constref AData: TBytes; ALength: HashLen = 0); overload; {$IFNDEF TEST}inline;{$ENDIF}
    procedure Update(const Input: AnsiString); overload; {$IFNDEF TEST}inline;{$ENDIF}
    procedure Update(const Input: UnicodeString); overload; {$IFNDEF TEST}inline;{$ENDIF}
    function HashAsBytes: TBytes;
    function HashAsInteger: Integer;
    function HashAsString: string;
    class function GetHashBytes(const AData: AnsiString): TBytes; overload; static;
    class function GetHashBytes(const AData: UnicodeString): TBytes; overload; static;
    class function GetHashString(const AString: AnsiString): string; overload; static;
    class function GetHashString(const AString: UnicodeString): string; overload; static;
    class function GetHashValue(const AData: AnsiString): Integer; overload; static; {$IFNDEF TEST}inline;{$ENDIF}
    class function GetHashValue(const AData: UnicodeString): Integer; overload; static; {$IFNDEF TEST}inline;{$ENDIF}
    class function GetHashValue(constref AData; ALength: Integer; AInitialValue: Integer = 0): Integer; overload; static; {$IFNDEF TEST}inline;{$ENDIF}
  end;

implementation

uses
  {$IF DEFINED(WITH_OPENSSL)}
  {$ELSEIF DEFINED(WITH_WINAPI)}
  jwawincrypt,
  {$IFEND}
  Types, System.Helpers, System.Helpers.Strings;

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

(*{$IF DEFINED(WITH_OPENSSL)}
  {$ELSEIF DEFINED(WITH_WINAPI)}
  {$ELSE}
  {$IFEND} *)

{ THashMD5 }

// packages/hash/src/md5.pp
// packages/openssl/src/openssl.pas

class function THashMD5.Create: THashMD5;
begin
  Result.FFinalized := False;
  {$IF DEFINED(WITH_OPENSSL)}
  {$ELSEIF DEFINED(WITH_WINAPI)}
  Result.FHash := TWinHash.Create(CALG_MD5);
  {$ELSE}
  {$IFEND}
end;

procedure THashMD5.CheckFinalized;
begin
  if FFinalized then
    raise EHashException.CreateRes(@SHashCanNotUpdateMD5);
end;

procedure THashMD5.Reset;
begin
  {$IF DEFINED(WITH_OPENSSL)}
  {$ELSEIF DEFINED(WITH_WINAPI)}
  FHash.Reset;
  {$ELSE}
  {$IFEND}
  FFinalized := False;
end;

procedure THashMD5.Update(constref AData; ALength: HashLen);
begin
  CheckFinalized;
  {$IF DEFINED(WITH_OPENSSL)}
  {$ELSEIF DEFINED(WITH_WINAPI)}
  FHash.Update(@AData, ALength);
  {$ELSE}
  {$IFEND}
end;

procedure THashMD5.Update(const AData: TBytes; ALength: HashLen);
begin
  CheckFinalized;
  if ALength = 0 then
    ALength := Length(AData);

  {$IF DEFINED(WITH_OPENSSL)}
  {$ELSEIF DEFINED(WITH_WINAPI)}
  FHash.Update(@AData[Low(AData)], ALength);
  {$ELSE}
  {$IFEND}
end;

procedure THashMD5.Update(const Input: AnsiString);
begin
  CheckFinalized;
  {$IF DEFINED(WITH_OPENSSL)}
  {$ELSEIF DEFINED(WITH_WINAPI)}
  if Length(Input) > 0 then
    FHash.Update(@Input[Low(Input)], Length(Input));
  {$ELSE}
  {$IFEND}
end;

procedure THashMD5.Update(const Input: UnicodeString);
var
  TmpStr: UTF8String;
begin
  CheckFinalized;
  {$IF DEFINED(WITH_OPENSSL)}
  {$ELSEIF DEFINED(WITH_WINAPI)}
  if Length(Input) > 0 then
  begin
    TmpStr := UTF8Encode(Input);
    FHash.Update(@TmpStr[Low(TmpStr)], Length(TmpStr));
  end;
  {$ELSE}
  {$IFEND}
end;

function THashMD5.GetBlockSize: Integer;
begin
  {$IFDEF WITH_OPENSSL}
  Result :=
  {$ELSE}
  Result := THashMD5.BLOCK_SIZE;
  {$ENDIF WITH_OPENSSL}
end;

function THashMD5.GetHashSize: Integer;
begin
  {$IF DEFINED(WITH_OPENSSL)}
  Result :=
  {$ELSEIF DEFINED(WITH_WINAPI)}
  Result := FHash.GetHashSize;
  {$ELSE}
  Result := THashMD5.HASH_SIZE;
  {$IFEND}
end;

function THashMD5.HashAsBytes: TBytes;
begin
  if not FFinalized then
    FFinalized := True;

  SetLength(Result, GetHashSize);
  {$IF DEFINED(WITH_OPENSSL)}
  {$ELSEIF DEFINED(WITH_WINAPI)}
  FHash.GetValue(@Result[Low(Result)]);
  {$ELSE}
  {$IFEND}
end;

function THashMD5.HashAsString: string;
begin
  Result := THash.DigestAsString(HashAsBytes);
end;

class function THashMD5.GetHashBytes(const AData: AnsiString): TBytes;
var
  TmpHash: THashMD5;
begin
  TmpHash := THashMD5.Create;
  TmpHash.Update(AData);
  Result := TmpHash.HashAsBytes;
end;

class function THashMD5.GetHashBytes(const AData: UnicodeString): TBytes;
var
  TmpHash: THashMD5;
begin
  TmpHash := THashMD5.Create;
  TmpHash.Update(AData);
  Result := TmpHash.HashAsBytes;
end;

class function THashMD5.GetHashString(const AString: AnsiString): string;
var
  TmpHash: THashMD5;
begin
  TmpHash := THashMD5.Create;
  TmpHash.Update(AString);
  Result := TmpHash.HashAsString;
end;

class function THashMD5.GetHashString(const AString: UnicodeString): string;
var
  TmpHash: THashMD5;
begin
  TmpHash := THashMD5.Create;
  TmpHash.Update(AString);
  Result := TmpHash.HashAsString;
end;

(* class function THashMD5.GetHMAC(const AData, AKey: string): string;
begin

end;

class function THashMD5.GetHMACAsBytes(const AData, AKey: string): TBytes;
begin

end;

class function THashMD5.GetHMACAsBytes(const AData: string; const AKey: TBytes):
  TBytes;
begin

end;

class function THashMD5.GetHMACAsBytes(const AData: TBytes; const AKey: string):
  TBytes;
begin

end;

class function THashMD5.GetHMACAsBytes(const AData, AKey: TBytes): TBytes;
begin

end; *)

{ THashSHA1 }

class function THashSHA1.Create: THashSHA1;
begin
  Result.FFinalized := False;
  {$IF DEFINED(WITH_OPENSSL)}
  {$ELSEIF DEFINED(WITH_WINAPI)}
  Result.FHash := TWinHash.Create(CALG_SHA1);
  {$ELSE}
  {$IFEND}
end;

procedure THashSHA1.CheckFinalized;
begin
  if FFinalized then
    raise EHashException.CreateRes(@SHashCanNotUpdateSHA1);
end;

procedure THashSHA1.Reset;
begin
  {$IF DEFINED(WITH_OPENSSL)}
  {$ELSEIF DEFINED(WITH_WINAPI)}
  FHash.Reset;
  {$ELSE}
  {$IFEND}
  FFinalized := False;
end;

procedure THashSHA1.Update(constref AData; ALength: HashLen);
begin
  CheckFinalized;
  {$IF DEFINED(WITH_OPENSSL)}
  {$ELSEIF DEFINED(WITH_WINAPI)}
  FHash.Update(@AData, ALength);
  {$ELSE}
  {$IFEND}
end;

procedure THashSHA1.Update(constref AData: TBytes; ALength: HashLen);
begin
  CheckFinalized;
  if ALength = 0 then
    ALength := Length(AData);

  {$IF DEFINED(WITH_OPENSSL)}
  {$ELSEIF DEFINED(WITH_WINAPI)}
  FHash.Update(@AData[Low(AData)], ALength);
  {$ELSE}
  {$IFEND}
end;

procedure THashSHA1.Update(const Input: AnsiString);
begin
  CheckFinalized;
  {$IF DEFINED(WITH_OPENSSL)}
  {$ELSEIF DEFINED(WITH_WINAPI)}
  if Length(Input) > 0 then
    FHash.Update(@Input[Low(Input)], Length(Input));
  {$ELSE}
  {$IFEND}
end;

procedure THashSHA1.Update(const Input: UnicodeString);
var
  TmpStr: UTF8String;
begin
  CheckFinalized;
  {$IF DEFINED(WITH_OPENSSL)}
  {$ELSEIF DEFINED(WITH_WINAPI)}
  if Length(Input) > 0 then
  begin
    TmpStr := UTF8Encode(Input);
    FHash.Update(@TmpStr[Low(TmpStr)], Length(TmpStr));
  end;
  {$ELSE}
  {$IFEND}
end;

function THashSHA1.GetBlockSize: Integer;
begin
  {$IFDEF WITH_OPENSSL}
  Result :=
  {$ELSE}
  Result := THashSHA1.BLOCK_SIZE;
  {$ENDIF WITH_OPENSSL}
end;

function THashSHA1.GetHashSize: Integer;
begin
  {$IF DEFINED(WITH_OPENSSL)}
  Result :=
  {$ELSEIF DEFINED(WITH_WINAPI)}
  Result := FHash.GetHashSize;
  {$ELSE}
  Result := THashSHA1.HASH_SIZE;
  {$IFEND}
end;

function THashSHA1.HashAsBytes: TBytes;
begin
  if not FFinalized then
    FFinalized := True;

  SetLength(Result, GetHashSize);
  {$IF DEFINED(WITH_OPENSSL)}
  {$ELSEIF DEFINED(WITH_WINAPI)}
  FHash.GetValue(@Result[Low(Result)]);
  {$ELSE}
  {$IFEND}
end;

function THashSHA1.HashAsString: string;
begin
  Result := THash.DigestAsString(HashAsBytes);
end;

class function THashSHA1.GetHashBytes(const AData: AnsiString): TBytes;
var
  TmpHash: THashSHA1;
begin
  TmpHash := THashSHA1.Create;
  TmpHash.Update(AData);
  Result := TmpHash.HashAsBytes;
end;

class function THashSHA1.GetHashBytes(const AData: UnicodeString): TBytes;
var
  TmpHash: THashSHA1;
begin
  TmpHash := THashSHA1.Create;
  TmpHash.Update(AData);
  Result := TmpHash.HashAsBytes;
end;

class function THashSHA1.GetHashString(const AString: AnsiString): string;
var
  TmpHash: THashSHA1;
begin
  TmpHash := THashSHA1.Create;
  TmpHash.Update(AString);
  Result := TmpHash.HashAsString;
end;

class function THashSHA1.GetHashString(const AString: UnicodeString): string;
var
  TmpHash: THashSHA1;
begin
  TmpHash := THashSHA1.Create;
  TmpHash.Update(AString);
  Result := TmpHash.HashAsString;
end;

{ THashSHA2 }

class function THashSHA2.Create(AHashVersion: TSHA2Version): THashSHA2;
begin
  Result.FVersion := AHashVersion;
  Result.FFinalized := False;
  {$IF DEFINED(WITH_OPENSSL)}
  {$ELSEIF DEFINED(WITH_WINAPI)}
  Result.FHash := TWinHash.Create(0);
  {$ELSE}
  {$IFEND}
end;

procedure THashSHA2.CheckFinalized;
begin
  if FFinalized then
    raise EHashException.CreateRes(@SHashCanNotUpdateSHA1);
end;

procedure THashSHA2.Reset;
begin
  {$IF DEFINED(WITH_OPENSSL)}
  {$ELSEIF DEFINED(WITH_WINAPI)}
  FHash.Reset;
  {$ELSE}
  {$IFEND}
  FFinalized := False;
end;

procedure THashSHA2.Update(constref AData; ALength: HashLen);
begin
  CheckFinalized;
  {$IF DEFINED(WITH_OPENSSL)}
  {$ELSEIF DEFINED(WITH_WINAPI)}
  FHash.Update(@AData, ALength);
  {$ELSE}
  {$IFEND}
end;

procedure THashSHA2.Update(constref AData: TBytes; ALength: HashLen);
begin
  CheckFinalized;
  if ALength = 0 then
    ALength := Length(AData);

  {$IF DEFINED(WITH_OPENSSL)}
  {$ELSEIF DEFINED(WITH_WINAPI)}
  FHash.Update(@AData[Low(AData)], ALength);
  {$ELSE}
  {$IFEND}
end;

procedure THashSHA2.Update(const Input: AnsiString);
begin
  CheckFinalized;
  {$IF DEFINED(WITH_OPENSSL)}
  {$ELSEIF DEFINED(WITH_WINAPI)}
  if Length(Input) > 0 then
    FHash.Update(@Input[Low(Input)], Length(Input));
  {$ELSE}
  {$IFEND}
end;

procedure THashSHA2.Update(const Input: UnicodeString);
var
  TmpStr: UTF8String;
begin
  CheckFinalized;
  {$IF DEFINED(WITH_OPENSSL)}
  {$ELSEIF DEFINED(WITH_WINAPI)}
  if Length(Input) > 0 then
  begin
    TmpStr := UTF8Encode(Input);
    FHash.Update(@TmpStr[Low(TmpStr)], Length(TmpStr));
  end;
  {$ELSE}
  {$IFEND}
end;

function THashSHA2.GetBlockSize: Integer;
begin
  {$IFDEF WITH_OPENSSL}
  Result :=
  {$ELSE}
  Result := THashSHA2.BLOCK_SIZE[FVersion];
  {$ENDIF WITH_OPENSSL}
end;

function THashSHA2.GetHashSize: Integer;
begin
  {$IF DEFINED(WITH_OPENSSL)}
  Result :=
  {$ELSEIF DEFINED(WITH_WINAPI)}
  Result := FHash.GetHashSize;
  {$ELSE}
  Result := THashSHA2.HASH_SIZE[FVersion];
  {$IFEND}
end;

function THashSHA2.HashAsBytes: TBytes;
begin
  if not FFinalized then
    FFinalized := True;

  SetLength(Result, GetHashSize);
  {$IF DEFINED(WITH_OPENSSL)}
  {$ELSEIF DEFINED(WITH_WINAPI)}
  FHash.GetValue(@Result[Low(Result)]);
  {$ELSE}
  {$IFEND}
end;

function THashSHA2.HashAsString: string;
begin
  Result := THash.DigestAsString(HashAsBytes);
end;

class function THashSHA2.GetHashBytes(const AData: AnsiString; AHashVersion: TSHA2Version): TBytes;
var
  TmpHash: THashSHA2;
begin
  TmpHash := THashSHA2.Create;
  TmpHash.Update(AData);
  Result := TmpHash.HashAsBytes;
end;

class function THashSHA2.GetHashBytes(const AData: UnicodeString; AHashVersion: TSHA2Version): TBytes;
var
  TmpHash: THashSHA2;
begin
  TmpHash := THashSHA2.Create;
  TmpHash.Update(AData);
  Result := TmpHash.HashAsBytes;
end;

class function THashSHA2.GetHashString(const AString: AnsiString; AHashVersion: TSHA2Version): string;
var
  TmpHash: THashSHA2;
begin
  TmpHash := THashSHA2.Create;
  TmpHash.Update(AString);
  Result := TmpHash.HashAsString;
end;

class function THashSHA2.GetHashString(const AString: UnicodeString; AHashVersion: TSHA2Version): string;
var
  TmpHash: THashSHA2;
begin
  TmpHash := THashSHA2.Create;
  TmpHash.Update(AString);
  Result := TmpHash.HashAsString;
end;

{ THashBobJenkins }

class function THashBobJenkins.Create: THashBobJenkins;
begin

end;

procedure THashBobJenkins.Reset(AInitialValue: Integer);
begin

end;

procedure THashBobJenkins.Update(constref AData; ALength: HashLen);
begin

end;

procedure THashBobJenkins.Update(constref AData: TBytes; ALength: HashLen);
begin

end;

procedure THashBobJenkins.Update(const Input: AnsiString);
begin

end;

procedure THashBobJenkins.Update(const Input: UnicodeString);
begin

end;

function THashBobJenkins.HashAsBytes: TBytes;
begin

end;

function THashBobJenkins.HashAsInteger: Integer;
begin

end;

function THashBobJenkins.HashAsString: string;
begin

end;

class function THashBobJenkins.GetHashBytes(const AData: AnsiString): TBytes;
begin

end;

class function THashBobJenkins.GetHashBytes(const AData: UnicodeString): TBytes;
begin

end;

class function THashBobJenkins.GetHashString(const AString: AnsiString): string;
begin

end;

class function THashBobJenkins.GetHashString(const AString: UnicodeString): string;
begin

end;

class function THashBobJenkins.GetHashValue(const AData: AnsiString): Integer;
begin

end;

class function THashBobJenkins.GetHashValue(const AData: UnicodeString): Integer;
begin

end;

class function THashBobJenkins.GetHashValue(constref AData; ALength: Integer; AInitialValue: Integer): Integer;
begin

end;

end.

