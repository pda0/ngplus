{**********************************************************************
    Helpers for System.Hash. Do not use this unit directly.

    Copyright(c) 2016 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit System.Hash.Helpers;

{$I ngplus.inc}
{$POINTERMATH ON}
{$IFDEF CPU64}
  {$ALIGN 8}
  {$CODEALIGN VARMIN=8}
  {$CODEALIGN LOCALMIN=8}
{$ELSE}
  {$ALIGN 4}
  {$CODEALIGN VARMIN=4}
  {$CODEALIGN LOCALMIN=4}
{$ENDIF}

interface

uses
  {$IF DEFINED(WITH_OPENSSL)}
  openssl;
  {$ELSEIF DEFINED(WITH_WINAPI)}
  JwaWinCrypt;
  {$IFEND}

type
  IHashEngine = interface
    function GetHashSize: Integer;
    function GetBlockSize: Integer;
    procedure Update(Data: PByte; Size: PtrUInt);
    procedure Reset;
    procedure GetValue(Data: PByte);
    procedure GetHMAC(Data, Key, Result: PByte; DataSize, KeySize: PtrUInt);
  end;

  TAvailableHashes = (
    MD5, SHA1, SHA2_224, SHA2_256, SHA2_384, SHA2_512, SHA2_512_224,
    SHA2_512_256
  );

  TBaseHashEngine = class(TInterfacedObject, IHashEngine)
  private
    FHashSize, FBlockSize: Integer;
  public
    constructor Create(HashSize, BlockSize: Integer);
    function GetHashSize: Integer;
    function GetBlockSize: Integer;
    procedure Update(Data: PByte; Size: PtrUInt); virtual; abstract;
    procedure Reset; virtual; abstract;
    procedure GetValue(Data: PByte); virtual; abstract;
    procedure GetHMAC(Data, Key, Result: PByte; DataSize, KeySize: PtrUInt); virtual; abstract;
  end;

  {$IF DEFINED(WITH_OPENSSL)}

  {$ELSEIF DEFINED(WITH_WINAPI)}
const
  CALG_SHA_256 = $0000800C; { WinXP SP3+ }
  CALG_SHA_384 = $0000800D; { WinXP SP3+ }
  CALG_SHA_512 = $0000800E; { WinXP SP3+ }

type
  TWinCryptoAPIHash = class(TBaseHashEngine)
  private
    class var FHashCounter: {$IFDEF CPU64}QWord{$ELSE}Cardinal{$ENDIF};
    class var FHashingProvider: HCRYPTPROV;
    FHashHandle: HCRYPTHASH;
    FAlgId: ALG_ID;
    class procedure Init;
    class procedure Done;
    class function GetHashingProvider: HCRYPTPROV;
    class procedure ReleaseHashingProvider;
    class function GetHashObject(AlgId: ALG_ID; out LastError: Integer): HCRYPTHASH;
    procedure CreateHashObject;
    procedure DestroyHashObject;
  public
    class function Probe(AlgId: ALG_ID; out HashHandle: HCRYPTHASH{$IFDEF TEST};HashSize: Integer{$ENDIF}): Boolean; static;
    constructor Create(AlgId: ALG_ID; HashHandle: HCRYPTHASH; HashSize, BlockSize: Integer);
    destructor Destroy; override;
    procedure Update(Data: PByte; Size: PtrUInt); override;
    procedure Reset; override;
    procedure GetValue(Data: PByte); override;
    procedure GetHMAC(Data, Key, Result: PByte; DataSize, KeySize: PtrUInt); override;
  end;
{$IFEND}

function CreateHash(AHash: TAvailableHashes): IHashEngine;

implementation
uses
  {$IF DEFINED(WITH_OPENSSL)}
  {$ELSEIF DEFINED(WITH_WINAPI)}
    JwaWinType, {$IFDEF TEST}JwaWinError,{$ENDIF}
  {$IFEND}
  SysUtils, Math;

type
  THashParam = record
    HashSize, BlockSize: Integer;
  end;

const
  HASH_PARAMS: array [TAvailableHashes] of THashParam = (
    {MD5}(HashSize: 16; BlockSize: 64), {SHA1}(HashSize: 20; BlockSize: 64),
    {SHA2_224}(HashSize: 28; BlockSize: 64), {SHA2_256}(HashSize: 32; BlockSize: 64),
    {SHA2_384}(HashSize: 48; BlockSize: 128), {SHA2_512}(HashSize: 64; BlockSize: 128),
    {SHA2_512_224}(HashSize: 28; BlockSize: 128), {SHA2_512_256}(HashSize: 32; BlockSize: 128)
  );

{ TBaseHashEngine }

constructor TBaseHashEngine.Create(HashSize, BlockSize: Integer);
begin
  Assert(HashSize > 0);
  Assert(BlockSize > 0);

  FHashSize := HashSize;
  FBlockSize := BlockSize;
end;

function TBaseHashEngine.GetHashSize: Integer;
begin
  Result := FHashSize;
end;

function TBaseHashEngine.GetBlockSize: Integer;
begin
  Result := FBlockSize;
end;

{$IF DEFINED(WITH_OPENSSL)}

{$ELSEIF DEFINED(WITH_WINAPI)}
{ TWinCryptoAPIHash }

class procedure TWinCryptoAPIHash.Init;
begin
  FHashingProvider := 0;
  FHashCounter := 0;
end;

class procedure TWinCryptoAPIHash.Done;
begin
  { We can only release crypto provider if no other hash is holding it.
    Otherwise it can be some leak in program or global variable still
    in scope. }
  if (FHashCounter = 0) and (FHashingProvider <> 0) then
    CryptReleaseContext(FHashingProvider, 0);
end;

class function TWinCryptoAPIHash.GetHashingProvider: HCRYPTPROV;
const
  PROV_RSA_AES = 24; { WinXP SP3+ }
  MS_ENH_RSA_AES_PROV = 'Microsoft Enhanced RSA and AES Cryptographic Provider'; { WinXP SP3+ }
var
  HashingProvider: HCRYPTPROV;
begin
  if FHashingProvider = 0 then
  begin
    {$PUSH}
    {$HINTS OFF} { HashingProvider will initialized in this call }
    if not CryptAcquireContext(HashingProvider, nil, MS_ENH_RSA_AES_PROV,
      PROV_RSA_AES, CRYPT_VERIFYCONTEXT or CRYPT_NEWKEYSET) then
    {$POP}
      Win32Check(CryptAcquireContext(HashingProvider, nil, MS_ENHANCED_PROV,
        PROV_RSA_FULL, CRYPT_VERIFYCONTEXT or CRYPT_NEWKEYSET));

    {$IFDEF CPU64}
    if InterlockedCompareExchange64(FHashingProvider, HashingProvider, 0) <> 0 then
    {$ELSE}
    if InterlockedCompareExchange(FHashingProvider, HashingProvider, 0) <> 0 then
    {$ENDIF}
      { Oops, some other thread is already initialized this class before us... }
      CryptReleaseContext(HashingProvider, 0);
  end;

  Result := FHashingProvider;
  {$IFDEF CPU64}
  InterlockedIncrement64(FHashCounter);
  {$ELSE}
  InterlockedIncrement(FHashCounter);
  {$ENDIF}

  Assert(Result <> 0);
end;

class procedure TWinCryptoAPIHash.ReleaseHashingProvider;
begin
  Assert(FHashCounter <> 0);

  {$IFDEF CPU64}
  InterlockedDecrement64(FHashCounter);
  {$ELSE}
  InterlockedDecrement(FHashCounter);
  {$ENDIF}
end;

class function TWinCryptoAPIHash.Probe(AlgId: ALG_ID; out HashHandle: HCRYPTHASH{$IFDEF TEST};HashSize: Integer{$ENDIF}): Boolean;
var
  {$IFDEF TEST}
  SizeLen: DWord;
  ActualHashSize: Integer;
  {$ENDIF TEST}
  LastError: Integer;
begin
  {$IFDEF TEST}
  SizeLen := SizeOf(ActualHashSize);
  Assert(SizeLen = SizeOf(DWord));
  {$ENDIF TEST}

  HashHandle := GetHashObject(AlgId, LastError);
  Result := HashHandle <> 0;

  {$IFDEF TEST}
  if Result then
  begin
    Win32Check(CryptGetHashParam(HashHandle, HP_HASHSIZE, @ActualHashSize, SizeLen, 0));
    Assert(ActualHashSize = HashSize);
  end
  else
    if (LastError <> 0) and (LastError <> NTE_BAD_ALGID) then
      RaiseLastOSError(LastError);
  {$ENDIF TEST}
end;

constructor TWinCryptoAPIHash.Create(AlgId: ALG_ID; HashHandle: HCRYPTHASH; HashSize, BlockSize: Integer);
begin
  FAlgId := AlgId;
  FHashHandle := HashHandle;
  inherited Create(HashSize, BlockSize);

  Assert(FHashHandle <> 0);
end;

destructor TWinCryptoAPIHash.Destroy;
begin
  DestroyHashObject;
  inherited;
end;

class function TWinCryptoAPIHash.GetHashObject(AlgId: ALG_ID; out LastError: Integer): HCRYPTHASH;
begin
  {$PUSH}
  {$HINTS OFF}
  if CryptCreateHash(GetHashingProvider, AlgId, 0, 0, Result) then
  {$POP}
    LastError := 0
  else begin
    LastError := GetLastOSError;
    ReleaseHashingProvider;
    Result := 0;
  end;
end;

procedure TWinCryptoAPIHash.CreateHashObject;
var
  LastError: Integer;
begin
  FHashHandle := GetHashObject(FAlgId, LastError);
  if FHashHandle = 0 then
    RaiseLastOSError(LastError);
end;

procedure TWinCryptoAPIHash.DestroyHashObject;
begin
  if FHashHandle <> 0 then
  begin
    ReleaseHashingProvider;
    Win32Check(CryptDestroyHash(FHashHandle));
  end;

  FHashHandle := 0;
end;

procedure TWinCryptoAPIHash.Update(Data: PByte; Size: PtrUInt);
var
  Count: DWord;
begin
  Assert(FHashHandle <> 0);

  while Size <> 0 do
  begin
    Count := Min(High(DWord), Size);
    Win32Check(CryptHashData(FHashHandle, Data, Count, 0));

    Size := Size - Count;
    Data := Data + Count;
  end;
end;

procedure TWinCryptoAPIHash.Reset;
begin
  DestroyHashObject;
  CreateHashObject;
end;

procedure TWinCryptoAPIHash.GetValue(Data: PByte);
var
  HashSize: DWord;
begin
  HashSize := FHashSize;
  Win32Check(CryptGetHashParam(FHashHandle, HP_HASHVAL, Data, HashSize, 0));

  Assert(HashSize = FHashSize);
end;

procedure TWinCryptoAPIHash.GetHMAC(Data, Key, Result: PByte; DataSize, KeySize: PtrUInt);
const
  CRYPT_IPSEC_HMAC_KEY = $00000100;

type
  PHMACKey = ^THMACKey;
  THMACKey = packed record
    Header: PUBLICKEYSTRUC;
    KeyLen: DWord;
    Key: array [0..0] of Byte;
  end;

var
  HmacInfo: HMAC_Info;
  HmacKey: PHMACKey;
  HashKey: HCRYPTKEY;
  HmacHash: HCRYPTHASH;
  {$IFDEF TEST}HMACSize, HMACSizeLen,{$ENDIF}
  HmacKeyLen, HashSize, Count: DWord;

  procedure Cleanup(LastError: Integer = 0);
  begin
    if HmacHash <> 0 then
      {$IFDEF TEST}Win32Check({$ENDIF}CryptDestroyHash(HmacHash){$IFDEF TEST}){$ENDIF};

    if HashKey <> 0 then
      {$IFDEF TEST}Win32Check({$ENDIF}CryptDestroyKey(HashKey){$IFDEF TEST}){$ENDIF};

    if Assigned(HmacKey) then
      FreeMem(HmacKey);

    if LastError <> 0 then
      RaiseLastOSError(LastError);
  end;
begin
  { There can be a problem if Key is reeeeaaaaally big. But it's Ok since 64 bit
    Windows is almost everything is a Vista+ so we will use CNG there. }
  Assert(KeySize < High(THMACKey.KeyLen));

  HmacKey := nil;
  HashKey := 0;
  HmacHash := 0;
  {$PUSH}
  {$HINTS OFF}
  FillChar(HmacInfo, SizeOf(HmacInfo), 0);
  {$POP}
  HmacInfo.HashAlgid := FAlgId;

  HmacKeyLen := DWord(SizeOf(HmacKey) + KeySize);
  GetMem(HmacKey, HmacKeyLen);
  HmacKey^.Header.bType := PLAINTEXTKEYBLOB;
  HmacKey^.Header.bVersion := CUR_BLOB_VERSION;
  HmacKey^.Header.reserved := 0;
  HmacKey^.Header.aiKeyAlg := CALG_RC2;
  HmacKey^.KeyLen := DWord(KeySize);
  Move(Key^, HmacKey^.Key, HmacKey^.KeyLen);

  if not CryptImportKey(FHashingProvider, LPBYTE(HmacKey), HmacKeyLen, 0,
    CRYPT_IPSEC_HMAC_KEY, HashKey) then
    Cleanup(GetLastOSError);

  if not CryptCreateHash(FHashingProvider, CALG_HMAC, HashKey, 0, HmacHash) then
    Cleanup(GetLastOSError);

  if not CryptSetHashParam(HmacHash, HP_HMAC_INFO, @HmacInfo, 0) then
    Cleanup(GetLastOSError);

  while DataSize <> 0 do
  begin
    Count := Min(High(DWord), DataSize);
    if not CryptHashData(HmacHash, Data, Count, 0) then
      Cleanup(GetLastOSError);

    DataSize := DataSize - Count;
    Data := Data + Count;
  end;

  HashSize := FHashSize;
  {$IFDEF TEST}
  HMACSizeLen := SizeOf(HMACSize);
  Assert(HMACSizeLen = SizeOf(DWord));
  if not CryptGetHashParam(HmacHash, HP_HASHSIZE, @HMACSize, HMACSizeLen, 0) then
    Cleanup(GetLastOSError);

  Assert(HMACSize = HashSize);
  {$ENDIF TEST}

  if not CryptGetHashParam(HmacHash, HP_HASHVAL, Result, HashSize, 0) then
    Cleanup(GetLastOSError);

  Cleanup;
end;
{$IFEND}

function CreateHash(AHash: TAvailableHashes): IHashEngine;
{$IFDEF WITH_WINAPI}
const
  CRYPTO_MAP: array [TAvailableHashes] of ALG_ID = (
    CALG_MD5, CALG_SHA1, {SHA2_224}0, CALG_SHA_256, CALG_SHA_384, CALG_SHA_512,
    {SHA2_512_224}0, {SHA2_512_256}0
  );
var
  AlgId: ALG_ID;
  HashHandle: HCRYPTHASH;
  {$IFDEF TEST}
  HashSize: Integer;
  {$ENDIF TEST}
{$ENDIF WITH_WINAPI}
begin
  {$IF DEFINED(WITH_OPENSSL)}
  {$ELSEIF DEFINED(WITH_WINAPI)}
  //TODO: Vista+ CNG }

  { CryptoAPI }
  AlgId := CRYPTO_MAP[AHash];
  {$IFDEF TEST}
  HashSize := HASH_PARAMS[AHash].HashSize;
  if (AlgId <> 0) and TWinCryptoAPIHash.Probe(AlgId, HashHandle, HashSize) then
  {$ELSE}
  if (AlgId <> 0) and TWinCryptoAPIHash.Probe(AlgId, HashHandle) then
  {$ENDIF}
    Exit(TWinCryptoAPIHash.Create(AlgId, HashHandle,
      HASH_PARAMS[AHash].HashSize, HASH_PARAMS[AHash].BlockSize));

  raise Exception.Create('TODO: Not implemented yet');
  {$ELSE}
  {$IFEND}
end;

{$IF DEFINED(WITH_WINAPI)}
initialization
  TWinCryptoAPIHash.Init;

finalization
  TWinCryptoAPIHash.Done;

{$IFEND}
end.

