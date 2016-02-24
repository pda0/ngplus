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
  SysUtils, System.Hash.Helpers;

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
    class function ToBigEndian(AValue: Cardinal): Cardinal; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function ToBigEndian(AValue: UInt64): UInt64; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
  end;

  THashMD5 = record
  private
    FHash: IHashEngine;
    FFinalized: Boolean;
    procedure CheckFinalized; {$IFNDEF _TEST}inline;{$ENDIF}
    class function InternalGetHMAC(constref AData, AKey: PByte; DataLen, KeyLen: PtrUInt): TBytes; static;
    class function Create(ForHmac: Boolean): THashMD5; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
  public
    class function Create: THashMD5; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    procedure Reset; {$IFNDEF _TEST}inline;{$ENDIF}
    procedure Update(constref AData; ALength: HashLen); overload;
    procedure Update(constref AData: TBytes; ALength: HashLen = 0); overload; {$IFNDEF _TEST}inline;{$ENDIF}
    procedure Update(constref Input: AnsiString); overload;
    procedure Update(constref Input: UnicodeString); overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function GetBlockSize: Integer; {$IFNDEF _TEST}inline;{$ENDIF}
    function GetHashSize: Integer; {$IFNDEF _TEST}inline;{$ENDIF}
    function HashAsBytes: TBytes; {$IFNDEF _TEST}inline;{$ENDIF}
    function HashAsString: string; {$IFNDEF _TEST}inline;{$ENDIF}
    class function GetHashBytes(constref AData: AnsiString): TBytes; overload; static;
    class function GetHashBytes(constref AData: UnicodeString): TBytes; overload; static;
    class function GetHashString(constref AString: AnsiString): string; overload; static;
    class function GetHashString(constref AString: UnicodeString): string; overload; static;
    class function GetHMAC(constref AData, AKey: AnsiString): string; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function GetHMAC(constref AData, AKey: UnicodeString): string; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function GetHMACAsBytes(constref AData, AKey: AnsiString): TBytes; overload; static;
    class function GetHMACAsBytes(constref AData, AKey: UnicodeString): TBytes; overload; static;
    class function GetHMACAsBytes(constref AData: AnsiString; constref AKey: TBytes): TBytes; overload; static;
    class function GetHMACAsBytes(constref AData: UnicodeString; constref AKey: TBytes): TBytes; overload; static;
    class function GetHMACAsBytes(constref AData: TBytes; constref AKey: AnsiString): TBytes; overload; static;
    class function GetHMACAsBytes(constref AData: TBytes; constref AKey: UnicodeString): TBytes; overload; static;
    class function GetHMACAsBytes(constref AData, AKey: TBytes): TBytes; overload; static;
  end;

  THashSHA1 = record
  private
    FHash: IHashEngine;
    FFinalized: Boolean;
    procedure CheckFinalized; {$IFNDEF _TEST}inline;{$ENDIF}
    class function InternalGetHMAC(constref AData, AKey: PByte; DataLen, KeyLen: PtrUInt): TBytes; static;
    class function Create(ForHmac: Boolean): THashSHA1; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
  public
    class function Create: THashSHA1; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    procedure Reset; {$IFNDEF _TEST}inline;{$ENDIF}
    procedure Update(constref AData; ALength: HashLen); overload;
    procedure Update(constref AData: TBytes; ALength: HashLen = 0); overload; {$IFNDEF _TEST}inline;{$ENDIF}
    procedure Update(constref Input: AnsiString); overload; {$IFNDEF _TEST}inline;{$ENDIF}
    procedure Update(constref Input: UnicodeString); overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function GetBlockSize: Integer; {$IFNDEF _TEST}inline;{$ENDIF}
    function GetHashSize: Integer; {$IFNDEF _TEST}inline;{$ENDIF}
    function HashAsBytes: TBytes; {$IFNDEF _TEST}inline;{$ENDIF}
    function HashAsString: string; {$IFNDEF _TEST}inline;{$ENDIF}
    class function GetHashBytes(constref AData: AnsiString): TBytes; overload; static;
    class function GetHashBytes(constref AData: UnicodeString): TBytes; overload; static;
    class function GetHashString(constref AString: AnsiString): string; overload; static;
    class function GetHashString(constref AString: UnicodeString): string; overload; static;
    class function GetHMAC(constref AData, AKey: AnsiString): string; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function GetHMAC(constref AData, AKey: UnicodeString): string; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function GetHMACAsBytes(constref AData, AKey: AnsiString): TBytes; overload; static;
    class function GetHMACAsBytes(constref AData, AKey: UnicodeString): TBytes; overload; static;
    class function GetHMACAsBytes(constref AData: AnsiString; constref AKey: TBytes): TBytes; overload; static;
    class function GetHMACAsBytes(constref AData: UnicodeString; constref AKey: TBytes): TBytes; overload; static;
    class function GetHMACAsBytes(constref AData: TBytes; constref AKey: AnsiString): TBytes; overload; static;
    class function GetHMACAsBytes(constref AData: TBytes; constref AKey: UnicodeString): TBytes; overload; static;
    class function GetHMACAsBytes(constref AData, AKey: TBytes): TBytes; overload; static;
  end;

  THashSHA2 = record
  public type
    TSHA2Version = (SHA224, SHA256, SHA384, SHA512, SHA512_224, SHA512_256);
  private
    FHash: IHashEngine;
    FFinalized: Boolean;
    procedure CheckFinalized; {$IFNDEF _TEST}inline;{$ENDIF}
    class function InternalGetHMAC(constref AData, AKey: PByte; DataLen, KeyLen: PtrUInt; AHashVersion: TSHA2Version = TSHA2Version.SHA256): TBytes; static;
    class function Create(AHashVersion: TSHA2Version; ForHmac: Boolean): THashSHA2; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
  {$IFDEF CLOSER_TO_DELPHI}
  public
  {$ELSE}
  private
  {$ENDIF CLOSER_TO_DELPHI}
    FVersion: TSHA2Version;
  public
    class function Create(AHashVersion: TSHA2Version = TSHA2Version.SHA256): THashSHA2; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    procedure Reset; {$IFNDEF _TEST}inline;{$ENDIF}
    procedure Update(constref AData; ALength: HashLen); overload;
    procedure Update(constref AData: TBytes; ALength: HashLen = 0); overload; {$IFNDEF _TEST}inline;{$ENDIF}
    procedure Update(constref Input: AnsiString); overload; {$IFNDEF _TEST}inline;{$ENDIF}
    procedure Update(constref Input: UnicodeString); overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function GetBlockSize: Integer; {$IFNDEF _TEST}inline;{$ENDIF}
    function GetHashSize: Integer; {$IFNDEF _TEST}inline;{$ENDIF}
    function HashAsBytes: TBytes; {$IFNDEF _TEST}inline;{$ENDIF}
    function HashAsString: string; {$IFNDEF _TEST}inline;{$ENDIF}
    class function GetHashBytes(constref AData: AnsiString; AHashVersion: TSHA2Version = TSHA2Version.SHA256): TBytes; overload; static;
    class function GetHashBytes(constref AData: UnicodeString; AHashVersion: TSHA2Version = TSHA2Version.SHA256): TBytes; overload; static;
    class function GetHashString(constref AString: AnsiString; AHashVersion: TSHA2Version = TSHA2Version.SHA256): string; overload; static;
    class function GetHashString(constref AString: UnicodeString; AHashVersion: TSHA2Version = TSHA2Version.SHA256): string; overload; static;
    class function GetHMAC(constref AData, AKey: AnsiString; AHashVersion: TSHA2Version = TSHA2Version.SHA256): string; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function GetHMAC(constref AData, AKey: UnicodeString; AHashVersion: TSHA2Version = TSHA2Version.SHA256): string; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function GetHMACAsBytes(constref AData, AKey: AnsiString; AHashVersion: TSHA2Version = TSHA2Version.SHA256): TBytes; overload; static;
    class function GetHMACAsBytes(constref AData, AKey: UnicodeString; AHashVersion: TSHA2Version = TSHA2Version.SHA256): TBytes; overload; static;
    class function GetHMACAsBytes(constref AData: AnsiString; constref AKey: TBytes; AHashVersion: TSHA2Version = TSHA2Version.SHA256): TBytes; overload; static;
    class function GetHMACAsBytes(constref AData: UnicodeString; constref AKey: TBytes; AHashVersion: TSHA2Version = TSHA2Version.SHA256): TBytes; overload; static;
    class function GetHMACAsBytes(constref AData: TBytes; constref AKey: AnsiString; AHashVersion: TSHA2Version = TSHA2Version.SHA256): TBytes; overload; static;
    class function GetHMACAsBytes(constref AData: TBytes; constref AKey: UnicodeString; AHashVersion: TSHA2Version = TSHA2Version.SHA256): TBytes; overload; static;
    class function GetHMACAsBytes(constref AData, AKey: TBytes; AHashVersion: TSHA2Version = TSHA2Version.SHA256): TBytes; overload; static;
  end;

  THashBobJenkins = record
  private
  public
    class function Create: THashBobJenkins; static;
    procedure Reset(AInitialValue: Integer = 0);
    procedure Update(constref AData; ALength: HashLen); overload; {$IFNDEF _TEST}inline;{$ENDIF}
    procedure Update(constref AData: TBytes; ALength: HashLen = 0); overload; {$IFNDEF _TEST}inline;{$ENDIF}
    procedure Update(constref Input: AnsiString); overload; {$IFNDEF _TEST}inline;{$ENDIF}
    procedure Update(constref Input: UnicodeString); overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function HashAsBytes: TBytes;
    function HashAsInteger: Integer;
    function HashAsString: string;
    class function GetHashBytes(constref AData: AnsiString): TBytes; overload; static;
    class function GetHashBytes(constref AData: UnicodeString): TBytes; overload; static;
    class function GetHashString(constref AString: AnsiString): string; overload; static;
    class function GetHashString(constref AString: UnicodeString): string; overload; static;
    class function GetHashValue(constref AData: AnsiString): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function GetHashValue(constref AData: UnicodeString): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function GetHashValue(constref AData; ALength: Integer; AInitialValue: Integer = 0): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
  end;

implementation

uses
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

{ THashMD5 }

// packages/hash/src/md5.pp

class function THashMD5.Create: THashMD5;
begin
  Result := Create(False);
end;

class function THashMD5.Create(ForHmac: Boolean): THashMD5;
begin
  Result.FFinalized := False;
  Result.FHash := System.Hash.Helpers.CreateHash(TAvailableHashes.MD5, ForHmac);
end;

procedure THashMD5.CheckFinalized;
begin
  if FFinalized then
    raise EHashException.CreateRes(@SHashCanNotUpdateMD5);
end;

procedure THashMD5.Reset;
begin
  FHash.Reset;
  FFinalized := False;
end;

procedure THashMD5.Update(constref AData; ALength: HashLen);
begin
  CheckFinalized;

  FHash.Update(@AData, ALength);
end;

procedure THashMD5.Update(constref AData: TBytes; ALength: HashLen);
var
  DataLen: PtrUInt;
begin
  CheckFinalized;
  if ALength = 0 then
    DataLen := Length(AData)
  else
    DataLen := ALength;

  if DataLen > 0 then
    FHash.Update(@AData[Low(AData)], DataLen);
end;

procedure THashMD5.Update(constref Input: AnsiString);
begin
  CheckFinalized;

  if Length(Input) > 0 then
    FHash.Update(@Input[Low(Input)], Length(Input));
end;

procedure THashMD5.Update(constref Input: UnicodeString);
var
  TmpStr: UTF8String;
begin
  CheckFinalized;

  if Length(Input) > 0 then
  begin
    TmpStr := UTF8Encode(Input);
    FHash.Update(@TmpStr[Low(TmpStr)], Length(TmpStr));
  end;
end;

function THashMD5.GetBlockSize: Integer;
begin
  Result := FHash.GetBlockSize;
end;

function THashMD5.GetHashSize: Integer;
begin
  Result := FHash.GetHashSize;
end;

function THashMD5.HashAsBytes: TBytes;
begin
  if not FFinalized then
    FFinalized := True;

  SetLength(Result, GetHashSize);
  FHash.GetValue(@Result[Low(Result)]);
end;

function THashMD5.HashAsString: string;
begin
  Result := THash.DigestAsString(HashAsBytes);
end;

class function THashMD5.InternalGetHMAC(constref AData, AKey: PByte; DataLen,
  KeyLen: PtrUInt): TBytes;
var
  TmpHash: THashMD5;
begin
  TmpHash := THashMD5.Create(True);
  SetLength(Result, TmpHash.GetHashSize);

  TmpHash.FHash.GetHMAC(AData, AKey, @Result[Low(Result)], DataLen, KeyLen);
end;

class function THashMD5.GetHashBytes(constref AData: AnsiString): TBytes;
var
  TmpHash: THashMD5;
begin
  TmpHash := THashMD5.Create;
  TmpHash.Update(AData);
  Result := TmpHash.HashAsBytes;
end;

class function THashMD5.GetHashBytes(constref AData: UnicodeString): TBytes;
var
  TmpHash: THashMD5;
begin
  TmpHash := THashMD5.Create;
  TmpHash.Update(AData);
  Result := TmpHash.HashAsBytes;
end;

class function THashMD5.GetHashString(constref AString: AnsiString): string;
var
  TmpHash: THashMD5;
begin
  TmpHash := THashMD5.Create;
  TmpHash.Update(AString);
  Result := TmpHash.HashAsString;
end;

class function THashMD5.GetHashString(constref AString: UnicodeString): string;
var
  TmpHash: THashMD5;
begin
  TmpHash := THashMD5.Create;
  TmpHash.Update(AString);
  Result := TmpHash.HashAsString;
end;

class function THashMD5.GetHMAC(constref AData, AKey: AnsiString): string;
begin
  Result := THash.DigestAsString(THashMD5.GetHMACAsBytes(AData, AKey));
end;

class function THashMD5.GetHMAC(constref AData, AKey: UnicodeString): string;
begin
  Result := THash.DigestAsString(THashMD5.GetHMACAsBytes(AData, AKey));
end;

class function THashMD5.GetHMACAsBytes(constref AData, AKey: AnsiString): TBytes;
var
  MappedData: PByte absolute AData;
  MappedKey: PByte absolute AKey;
begin
  Result := THashMD5.InternalGetHMAC(MappedData, MappedKey,
    Length(AData), Length(AKey));
end;

class function THashMD5.GetHMACAsBytes(constref AData, AKey: UnicodeString): TBytes;
var
  TmpData, TmpKey: UTF8String;
  DataPtr, KeyPtr: PByte;
begin
  TmpData := UTF8Encode(AData);
  TmpKey := UTF8Encode(AKey);

  if Length(TmpData) > 0 then
    DataPtr := @TmpData[Low(TmpData)]
  else
    DataPtr := nil;

  if Length(TmpKey) > 0 then
    KeyPtr := @TmpKey[Low(TmpKey)]
  else
    KeyPtr := nil;

  Result := THashMD5.InternalGetHMAC(DataPtr, KeyPtr,
    Length(TmpData), Length(TmpKey));
end;

class function THashMD5.GetHMACAsBytes(constref AData: AnsiString;
  constref AKey: TBytes): TBytes;
var
  MappedData: PByte absolute AData;
  KeyPtr: PByte;
begin
  if Length(AKey) > 0 then
    KeyPtr := @AKey[Low(AKey)]
  else
    KeyPtr := nil;

  Result := THashMD5.InternalGetHMAC(MappedData, KeyPtr,
    Length(AData), Length(AKey));
end;

class function THashMD5.GetHMACAsBytes(constref AData: UnicodeString;
  constref AKey: TBytes): TBytes;
var
  TmpData: UTF8String;
  DataPtr, KeyPtr: PByte;
begin
  TmpData := UTF8Encode(AData);

  if Length(TmpData) > 0 then
    DataPtr := @TmpData[Low(TmpData)]
  else
    DataPtr := nil;

  if Length(AKey) > 0 then
    KeyPtr := @AKey[Low(AKey)]
  else
    KeyPtr := nil;

  Result := THashMD5.InternalGetHMAC(DataPtr, KeyPtr,
    Length(TmpData), Length(AKey));
end;

class function THashMD5.GetHMACAsBytes(constref AData: TBytes;
  constref AKey: AnsiString): TBytes;
var
  MappedKey: PByte absolute AKey;
  DataPtr: PByte;
begin
  if Length(AData) > 0 then
    DataPtr := @AData[Low(AData)]
  else
    DataPtr := nil;

  Result := THashMD5.InternalGetHMAC(DataPtr, MappedKey,
    Length(AData), Length(AKey));
end;

class function THashMD5.GetHMACAsBytes(constref AData: TBytes;
  constref AKey: UnicodeString): TBytes;
var
  TmpKey: UTF8String;
  DataPtr, KeyPtr: PByte;
begin
  TmpKey := UTF8Encode(AKey);

  if Length(AData) > 0 then
    DataPtr := @AData[Low(AData)]
  else
    DataPtr := nil;

  if Length(TmpKey) > 0 then
    KeyPtr := @TmpKey[Low(TmpKey)]
  else
    KeyPtr := nil;

  Result := THashMD5.InternalGetHMAC(DataPtr, KeyPtr,
    Length(AData), Length(TmpKey));
end;

class function THashMD5.GetHMACAsBytes(constref AData, AKey: TBytes): TBytes;
var
  DataPtr, KeyPtr: PByte;
begin
  if Length(AData) > 0 then
    DataPtr := @AData[Low(AData)]
  else
    DataPtr := nil;

  if Length(AKey) > 0 then
    KeyPtr := @AKey[Low(AKey)]
  else
    KeyPtr := nil;

  Result := THashMD5.InternalGetHMAC(DataPtr, KeyPtr,
    Length(AData), Length(AKey));
end;

{ THashSHA1 }

class function THashSHA1.Create: THashSHA1;
begin
  Result := Create(False);
end;

class function THashSHA1.Create(ForHmac: Boolean): THashSHA1;
begin
  Result.FFinalized := False;
  Result.FHash := System.Hash.Helpers.CreateHash(TAvailableHashes.SHA1, ForHmac);
end;

procedure THashSHA1.CheckFinalized;
begin
  if FFinalized then
    raise EHashException.CreateRes(@SHashCanNotUpdateSHA1);
end;

procedure THashSHA1.Reset;
begin
  FHash.Reset;
  FFinalized := False;
end;

procedure THashSHA1.Update(constref AData; ALength: HashLen);
begin
  CheckFinalized;

  FHash.Update(@AData, ALength);
end;

procedure THashSHA1.Update(constref AData: TBytes; ALength: HashLen);
var
  DataLen: PtrUInt;
begin
  CheckFinalized;
  if ALength = 0 then
    DataLen := Length(AData)
  else
    DataLen := ALength;

  if DataLen > 0 then
    FHash.Update(@AData[Low(AData)], DataLen);
end;

procedure THashSHA1.Update(constref Input: AnsiString);
begin
  CheckFinalized;

  if Length(Input) > 0 then
    FHash.Update(@Input[Low(Input)], Length(Input));
end;

procedure THashSHA1.Update(constref Input: UnicodeString);
var
  TmpStr: UTF8String;
begin
  CheckFinalized;

  if Length(Input) > 0 then
  begin
    TmpStr := UTF8Encode(Input);
    FHash.Update(@TmpStr[Low(TmpStr)], Length(TmpStr));
  end;
end;

function THashSHA1.GetBlockSize: Integer;
begin
  Result := FHash.GetBlockSize;
end;

function THashSHA1.GetHashSize: Integer;
begin
  Result := FHash.GetHashSize;
end;

function THashSHA1.HashAsBytes: TBytes;
begin
  if not FFinalized then
    FFinalized := True;

  SetLength(Result, GetHashSize);
  FHash.GetValue(@Result[Low(Result)]);
end;

function THashSHA1.HashAsString: string;
begin
  Result := THash.DigestAsString(HashAsBytes);
end;

class function THashSHA1.InternalGetHMAC(constref AData, AKey: PByte; DataLen,
  KeyLen: PtrUInt): TBytes;
var
  TmpHash: THashSHA1;
begin
  TmpHash := THashSHA1.Create(True);
  SetLength(Result, TmpHash.GetHashSize);

  TmpHash.FHash.GetHMAC(AData, AKey, @Result[Low(Result)], DataLen, KeyLen);
end;

class function THashSHA1.GetHashBytes(constref AData: AnsiString): TBytes;
var
  TmpHash: THashSHA1;
begin
  TmpHash := THashSHA1.Create;
  TmpHash.Update(AData);
  Result := TmpHash.HashAsBytes;
end;

class function THashSHA1.GetHashBytes(constref AData: UnicodeString): TBytes;
var
  TmpHash: THashSHA1;
begin
  TmpHash := THashSHA1.Create;
  TmpHash.Update(AData);
  Result := TmpHash.HashAsBytes;
end;

class function THashSHA1.GetHashString(constref AString: AnsiString): string;
var
  TmpHash: THashSHA1;
begin
  TmpHash := THashSHA1.Create;
  TmpHash.Update(AString);
  Result := TmpHash.HashAsString;
end;

class function THashSHA1.GetHashString(constref AString: UnicodeString): string;
var
  TmpHash: THashSHA1;
begin
  TmpHash := THashSHA1.Create;
  TmpHash.Update(AString);
  Result := TmpHash.HashAsString;
end;

class function THashSHA1.GetHMAC(constref AData, AKey: AnsiString): string;
begin
  Result := THash.DigestAsString(THashSHA1.GetHMACAsBytes(AData, AKey));
end;

class function THashSHA1.GetHMAC(constref AData, AKey: UnicodeString): string;
begin
  Result := THash.DigestAsString(THashSHA1.GetHMACAsBytes(AData, AKey));
end;

class function THashSHA1.GetHMACAsBytes(constref AData, AKey: AnsiString): TBytes;
var
  MappedData: PByte absolute AData;
  MappedKey: PByte absolute AKey;
begin
  Result := THashSHA1.InternalGetHMAC(MappedData, MappedKey,
    Length(AData), Length(AKey));
end;

class function THashSHA1.GetHMACAsBytes(constref AData, AKey: UnicodeString): TBytes;
var
  TmpData, TmpKey: UTF8String;
  DataPtr, KeyPtr: PByte;
begin
  TmpData := UTF8Encode(AData);
  TmpKey := UTF8Encode(AKey);

  if Length(TmpData) > 0 then
    DataPtr := @TmpData[Low(TmpData)]
  else
    DataPtr := nil;

  if Length(TmpKey) > 0 then
    KeyPtr := @TmpKey[Low(TmpKey)]
  else
    KeyPtr := nil;

  Result := THashSHA1.InternalGetHMAC(DataPtr, KeyPtr,
    Length(TmpData), Length(TmpKey));
end;

class function THashSHA1.GetHMACAsBytes(constref AData: AnsiString;
  constref AKey: TBytes): TBytes;
var
  MappedData: PByte absolute AData;
  KeyPtr: PByte;
begin
  if Length(AKey) > 0 then
    KeyPtr := @AKey[Low(AKey)]
  else
    KeyPtr := nil;

  Result := THashSHA1.InternalGetHMAC(MappedData, KeyPtr,
    Length(AData), Length(AKey));
end;

class function THashSHA1.GetHMACAsBytes(constref AData: UnicodeString;
  constref AKey: TBytes): TBytes;
var
  TmpData: UTF8String;
  DataPtr, KeyPtr: PByte;
begin
  TmpData := UTF8Encode(AData);

  if Length(TmpData) > 0 then
    DataPtr := @TmpData[Low(TmpData)]
  else
    DataPtr := nil;

  if Length(AKey) > 0 then
    KeyPtr := @AKey[Low(AKey)]
  else
    KeyPtr := nil;

  Result := THashSHA1.InternalGetHMAC(DataPtr, KeyPtr,
    Length(TmpData), Length(AKey));
end;

class function THashSHA1.GetHMACAsBytes(constref AData: TBytes;
  constref AKey: AnsiString): TBytes;
var
  MappedKey: PByte absolute AKey;
  DataPtr: PByte;
begin
  if Length(AData) > 0 then
    DataPtr := @AData[Low(AData)]
  else
    DataPtr := nil;

  Result := THashSHA1.InternalGetHMAC(DataPtr, MappedKey,
    Length(AData), Length(AKey));
end;

class function THashSHA1.GetHMACAsBytes(constref AData: TBytes;
  constref AKey: UnicodeString): TBytes;
var
  TmpKey: UTF8String;
  DataPtr, KeyPtr: PByte;
begin
  TmpKey := UTF8Encode(AKey);

  if Length(AData) > 0 then
    DataPtr := @AData[Low(AData)]
  else
    DataPtr := nil;

  if Length(TmpKey) > 0 then
    KeyPtr := @TmpKey[Low(TmpKey)]
  else
    KeyPtr := nil;

  Result := THashSHA1.InternalGetHMAC(DataPtr, KeyPtr,
    Length(AData), Length(TmpKey));
end;

class function THashSHA1.GetHMACAsBytes(constref AData, AKey: TBytes): TBytes;
var
  DataPtr, KeyPtr: PByte;
begin
  if Length(AData) > 0 then
    DataPtr := @AData[Low(AData)]
  else
    DataPtr := nil;

  if Length(AKey) > 0 then
    KeyPtr := @AKey[Low(AKey)]
  else
    KeyPtr := nil;

  Result := THashSHA1.InternalGetHMAC(DataPtr, KeyPtr,
    Length(AData), Length(AKey));
end;

{ THashSHA2 }

class function THashSHA2.Create(AHashVersion: TSHA2Version): THashSHA2;
begin
  Result := Create(AHashVersion, False);
end;

class function THashSHA2.Create(AHashVersion: TSHA2Version; ForHmac: Boolean):
  THashSHA2;
const
  SHA2_MAP: array [TSHA2Version] of TAvailableHashes = (
    SHA2_224, SHA2_256, SHA2_384, SHA2_512, SHA2_512_224, SHA2_512_256
  );
begin
  Result.FVersion := AHashVersion;
  Result.FFinalized := False;
  Result.FHash := System.Hash.Helpers.CreateHash(SHA2_MAP[AHashVersion], ForHmac);
end;

procedure THashSHA2.CheckFinalized;
begin
  if FFinalized then
    raise EHashException.CreateRes(@SHashCanNotUpdateSHA2);
end;

procedure THashSHA2.Reset;
begin
  FHash.Reset;
  FFinalized := False;
end;

procedure THashSHA2.Update(constref AData; ALength: HashLen);
begin
  CheckFinalized;

  FHash.Update(@AData, ALength);
end;

procedure THashSHA2.Update(constref AData: TBytes; ALength: HashLen);
var
  DataLen: PtrUInt;
begin
  CheckFinalized;
  if ALength = 0 then
    DataLen := Length(AData)
  else
    DataLen := ALength;

  if DataLen > 0 then
    FHash.Update(@AData[Low(AData)], DataLen);
end;

procedure THashSHA2.Update(constref Input: AnsiString);
begin
  CheckFinalized;

  if Length(Input) > 0 then
    FHash.Update(@Input[Low(Input)], Length(Input));
end;

procedure THashSHA2.Update(constref Input: UnicodeString);
var
  TmpStr: UTF8String;
begin
  CheckFinalized;

  if Length(Input) > 0 then
  begin
    TmpStr := UTF8Encode(Input);
    FHash.Update(@TmpStr[Low(TmpStr)], Length(TmpStr));
  end;
end;

function THashSHA2.GetBlockSize: Integer;
begin
  Result := FHash.GetBlockSize;
end;

function THashSHA2.GetHashSize: Integer;
begin
  Result := FHash.GetHashSize;
end;

function THashSHA2.HashAsBytes: TBytes;
begin
  if not FFinalized then
    FFinalized := True;

  SetLength(Result, GetHashSize);
  FHash.GetValue(@Result[Low(Result)]);
end;

function THashSHA2.HashAsString: string;
begin
  Result := THash.DigestAsString(HashAsBytes);
end;

class function THashSHA2.InternalGetHMAC(constref AData, AKey: PByte; DataLen,
  KeyLen: PtrUInt; AHashVersion: TSHA2Version): TBytes;
var
  TmpHash: THashSHA2;
begin
  TmpHash := THashSHA2.Create(AHashVersion, True);
  SetLength(Result, TmpHash.GetHashSize);

  TmpHash.FHash.GetHMAC(AData, AKey, @Result[Low(Result)], DataLen, KeyLen);
end;

class function THashSHA2.GetHashBytes(constref AData: AnsiString;
  AHashVersion: TSHA2Version): TBytes;
var
  TmpHash: THashSHA2;
begin
  TmpHash := THashSHA2.Create(AHashVersion);
  TmpHash.Update(AData);
  Result := TmpHash.HashAsBytes;
end;

class function THashSHA2.GetHashBytes(constref AData: UnicodeString;
  AHashVersion: TSHA2Version): TBytes;
var
  TmpHash: THashSHA2;
begin
  TmpHash := THashSHA2.Create(AHashVersion);
  TmpHash.Update(AData);
  Result := TmpHash.HashAsBytes;
end;

class function THashSHA2.GetHashString(constref AString: AnsiString;
  AHashVersion: TSHA2Version): string;
var
  TmpHash: THashSHA2;
begin
  TmpHash := THashSHA2.Create(AHashVersion);
  TmpHash.Update(AString);
  Result := TmpHash.HashAsString;
end;

class function THashSHA2.GetHashString(constref AString: UnicodeString;
  AHashVersion: TSHA2Version): string;
var
  TmpHash: THashSHA2;
begin
  TmpHash := THashSHA2.Create(AHashVersion);
  TmpHash.Update(AString);
  Result := TmpHash.HashAsString;
end;

class function THashSHA2.GetHMAC(constref AData, AKey: AnsiString;
  AHashVersion: TSHA2Version): string;
begin
  Result := THash.DigestAsString(THashSHA2.GetHMACAsBytes(AData, AKey,
    AHashVersion));
end;

class function THashSHA2.GetHMAC(constref AData, AKey: UnicodeString;
  AHashVersion: TSHA2Version): string;
begin
  Result := THash.DigestAsString(THashSHA2.GetHMACAsBytes(AData, AKey,
    AHashVersion));
end;

class function THashSHA2.GetHMACAsBytes(constref AData, AKey: AnsiString;
  AHashVersion: TSHA2Version): TBytes;
var
  MappedData: PByte absolute AData;
  MappedKey: PByte absolute AKey;
begin
  Result := THashSHA2.InternalGetHMAC(MappedData, MappedKey,
    Length(AData), Length(AKey), AHashVersion);
end;

class function THashSHA2.GetHMACAsBytes(constref AData, AKey: UnicodeString;
  AHashVersion: TSHA2Version): TBytes;
var
  TmpData, TmpKey: UTF8String;
  DataPtr, KeyPtr: PByte;
begin
  TmpData := UTF8Encode(AData);
  TmpKey := UTF8Encode(AKey);

  if Length(TmpData) > 0 then
    DataPtr := @TmpData[Low(TmpData)]
  else
    DataPtr := nil;

  if Length(TmpKey) > 0 then
    KeyPtr := @TmpKey[Low(TmpKey)]
  else
    KeyPtr := nil;

  Result := THashSHA2.InternalGetHMAC(DataPtr, KeyPtr,
    Length(TmpData), Length(TmpKey), AHashVersion);
end;

class function THashSHA2.GetHMACAsBytes(constref AData: AnsiString;
  constref AKey: TBytes; AHashVersion: TSHA2Version): TBytes;
var
  MappedData: PByte absolute AData;
  KeyPtr: PByte;
begin
  if Length(AKey) > 0 then
    KeyPtr := @AKey[Low(AKey)]
  else
    KeyPtr := nil;

  Result := THashSHA2.InternalGetHMAC(MappedData, KeyPtr,
    Length(AData), Length(AKey), AHashVersion);
end;

class function THashSHA2.GetHMACAsBytes(constref AData: UnicodeString;
  constref AKey: TBytes; AHashVersion: TSHA2Version): TBytes;
var
  TmpData: UTF8String;
  DataPtr, KeyPtr: PByte;
begin
  TmpData := UTF8Encode(AData);

  if Length(TmpData) > 0 then
    DataPtr := @TmpData[Low(TmpData)]
  else
    DataPtr := nil;

  if Length(AKey) > 0 then
    KeyPtr := @AKey[Low(AKey)]
  else
    KeyPtr := nil;

  Result := THashSHA2.InternalGetHMAC(DataPtr, KeyPtr,
    Length(TmpData), Length(AKey), AHashVersion);
end;

class function THashSHA2.GetHMACAsBytes(constref AData: TBytes;
  constref AKey: AnsiString; AHashVersion: TSHA2Version): TBytes;
var
  MappedKey: PByte absolute AKey;
  DataPtr: PByte;
begin
  if Length(AData) > 0 then
    DataPtr := @AData[Low(AData)]
  else
    DataPtr := nil;

  Result := THashSHA2.InternalGetHMAC(DataPtr, MappedKey,
    Length(AData), Length(AKey), AHashVersion);
end;

class function THashSHA2.GetHMACAsBytes(constref AData: TBytes;
  constref AKey: UnicodeString; AHashVersion: TSHA2Version): TBytes;
var
  TmpKey: UTF8String;
  DataPtr, KeyPtr: PByte;
begin
  TmpKey := UTF8Encode(AKey);

  if Length(AData) > 0 then
    DataPtr := @AData[Low(AData)]
  else
    DataPtr := nil;

  if Length(TmpKey) > 0 then
    KeyPtr := @TmpKey[Low(TmpKey)]
  else
    KeyPtr := nil;

  Result := THashSHA2.InternalGetHMAC(DataPtr, KeyPtr,
    Length(AData), Length(TmpKey), AHashVersion);
end;

class function THashSHA2.GetHMACAsBytes(constref AData, AKey: TBytes;
  AHashVersion: TSHA2Version): TBytes;
var
  DataPtr, KeyPtr: PByte;
begin
  if Length(AData) > 0 then
    DataPtr := @AData[Low(AData)]
  else
    DataPtr := nil;

  if Length(AKey) > 0 then
    KeyPtr := @AKey[Low(AKey)]
  else
    KeyPtr := nil;

  Result := THashSHA2.InternalGetHMAC(DataPtr, KeyPtr,
    Length(AData), Length(AKey), AHashVersion);
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

procedure THashBobJenkins.Update(constref Input: AnsiString);
begin

end;

procedure THashBobJenkins.Update(constref Input: UnicodeString);
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

class function THashBobJenkins.GetHashBytes(constref AData: AnsiString): TBytes;
begin

end;

class function THashBobJenkins.GetHashBytes(constref AData: UnicodeString): TBytes;
begin

end;

class function THashBobJenkins.GetHashString(constref AString: AnsiString): string;
begin

end;

class function THashBobJenkins.GetHashString(constref AString: UnicodeString): string;
begin

end;

class function THashBobJenkins.GetHashValue(constref AData: AnsiString): Integer;
begin

end;

class function THashBobJenkins.GetHashValue(constref AData: UnicodeString): Integer;
begin

end;

class function THashBobJenkins.GetHashValue(constref AData; ALength: Integer;
  AInitialValue: Integer): Integer;
begin

end;

end.

