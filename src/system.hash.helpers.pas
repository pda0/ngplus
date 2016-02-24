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

interface

uses
  {$IFDEF WITH_OPENSSL}openssl, cTypes, dynlibs,{$ENDIF}
  {$IFDEF WITH_WINAPI}Windows, JwaWinType, JwaWinCrypt, dynlibs,{$ENDIF}
  SysUtils;

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

{$IFDEF WITH_OPENSSL}
const
  HMAC_MAX_MD_CBLOCK = 128;

type
  {$PACKRECORDS C}
  PHMAC_CTX = ^HMAC_CTX;
  HMAC_CTX = record
    md: PEVP_MD;
    md_ctx, i_ctx, o_ctx: EVP_MD_CTX;
    key_length: cuint;
    key: array [0 .. HMAC_MAX_MD_CBLOCK - 1] of Byte;
  end;

  {$IFDEF CPU64}{$PACKRECORDS 8}{$ELSE}{$PACKRECORDS 4}{$ENDIF}
  TOpensslHash = class(TBaseHashEngine)
  private type
    THMAC_Init_ex = function(ctx: PHMAC_CTX; const key: PByte; len: cint; md: PEVP_MD; impl: PENGINE): cint; cdecl;
    THMAC_Update = function(ctx: PHMAC_CTX; const data: PByte; len: csize_t): cint; cdecl;
    THMAC_Final = function(ctx: PHMAC_CTX; md: PByte; var len: cuint): cint; cdecl;
  private class var
    _HMAC_Init_ex: THMAC_Init_ex;
    _HMAC_Update: THMAC_Update;
    _HMAC_Final: THMAC_Final;
  private
    FContext: EVP_MD_CTX;
    FDigest: TBytes;
    FMd: PEVP_MD;
    FHashing: Boolean;
    class procedure Wipe;
    class procedure OpensslCheck(RetVal: cInt); static;
    class function HMAC_Init_ex(ctx: PHMAC_CTX; const key: PByte; len: cint; md: PEVP_MD; impl: PENGINE): cint;
    class function HMAC_Update(ctx: PHMAC_CTX; const data: PByte; len: csize_t): cint;
    class function HMAC_Final(ctx: PHMAC_CTX; md: PByte; var len: cuint): cint;
  public
    class function Probe(const DigestName: PAnsiChar; out Md: PEVP_MD): Boolean; static;
    constructor Create(Md: PEVP_MD; HashSize, BlockSize: Integer);
    procedure Update(Data: PByte; Size: PtrUInt); override;
    procedure Reset; override;
    procedure GetValue(Data: PByte); override;
    procedure GetHMAC(Data, Key, Result: PByte; DataSize, KeySize: PtrUInt); override;
  end;
  {$PACKRECORDS DEFAULT}
{$ENDIF WITH_OPENSSL}

{$IFDEF WITH_WINAPI}
const
  CALG_SHA_256 = $0000800C; { WinXP SP3+ }
  CALG_SHA_384 = $0000800D; { WinXP SP3+ }
  CALG_SHA_512 = $0000800E; { WinXP SP3+ }

type
  {$IFDEF CPU64}{$PACKRECORDS 8}{$ELSE}{$PACKRECORDS 4}{$ENDIF}
  TAbstractWinHash = class(TBaseHashEngine)
  protected
    class procedure WinCheck(RetVal: BOOL); static;
  end;

  TWinCryptoAPIHash = class(TAbstractWinHash)
  private class var
    FHashCounter: {$IFDEF CPU64}QWord{$ELSE}Cardinal{$ENDIF};
    FHashingProvider: HCRYPTPROV;
  private
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
    class function Probe(AlgId: ALG_ID; out HashHandle: HCRYPTHASH{$IFDEF _TEST};HashSize: Integer{$ENDIF}): Boolean; static;
    constructor Create(AlgId: ALG_ID; HashHandle: HCRYPTHASH; HashSize, BlockSize: Integer);
    destructor Destroy; override;
    procedure Update(Data: PByte; Size: PtrUInt); override;
    procedure Reset; override;
    procedure GetValue(Data: PByte); override;
    procedure GetHMAC(Data, Key, Result: PByte; DataSize, KeySize: PtrUInt); override;
  end;

  TWinCNGHash = class(TAbstractWinHash)
  private const
    {$IFDEF _TEST}
    BCRYPT_OBJECT_LENGTH: LPCWSTR = 'KeyObjectLength';
    {$ENDIF}
    BCRYPT_HASH_LENGTH: LPCWSTR = 'HashDigestLength';
    BCRYPT_ALG_HANDLE_HMAC_FLAG: DWord = $00000008;
    BCRYPT_HASH_REUSABLE_FLAG: DWord = $00000020;
  private type
    BCRYPT_ALG_HANDLE = THandle;
    BCRYPT_HANDLE = THandle;
    BCRYPT_HASH_HANDLE = THandle;
    TBCryptOpenAlgorithmProvider = function(out phAlgorithm: BCRYPT_ALG_HANDLE; pszAlgId, pszImplementation: LPCWSTR; dwFlags: ULONG): NTSTATUS; stdcall;
    TBCryptCloseAlgorithmProvider = function(hAlgorithm: BCRYPT_ALG_HANDLE; dwFlags: ULONG): NTSTATUS; stdcall;
    TBCryptGetProperty = function(hObject: BCRYPT_HANDLE; pszProperty: LPCWSTR; pbOutput: PUCHAR; cbOutput: ULONG; out pcbResult: ULONG; dwFlags: ULONG): NTSTATUS; stdcall;
    TBCryptCreateHash = function(hAlgorithm: BCRYPT_ALG_HANDLE; out phHash: BCRYPT_HASH_HANDLE; pbHashObject: PUCHAR; cbHashObject: ULONG; pbSecret: PUCHAR; cbSecret: ULONG; dwFlags: ULONG): NTSTATUS; stdcall;
    TBCryptDestroyHash = function(hHash: BCRYPT_HASH_HANDLE): NTSTATUS; stdcall;
    TBCryptHashData = function(hHash: BCRYPT_HASH_HANDLE; pbInput: PUCHAR; cbInput, dwFlags: ULONG): NTSTATUS; stdcall;
    TBCryptFinishHash = function(hHash: BCRYPT_HASH_HANDLE; pbOutput: PUCHAR; cbOutput, dwFlags: ULONG): NTSTATUS; stdcall;
  private class var
    FUsageCounter: {$IFDEF CPU64}QWord{$ELSE}LongInt{$ENDIF};
    FBCryphHandle: TLibHandle;
    _BCryptOpenAlgorithmProvider, _BCryptCloseAlgorithmProvider,
    _BCryptGetProperty, _BCryptCreateHash, _BCryptDestroyHash, _BCryptHashData,
    _BCryptFinishHash: Pointer;
  private
    FAlgId: LPCWSTR;
    FAlgHandle: BCRYPT_ALG_HANDLE;
    FHashHandle: BCRYPT_HASH_HANDLE;
    FHashBlock, FHashResult: PByte;
    FFinished: Boolean;
    class procedure Init;
    class procedure Done;
    class procedure Wipe;
    class procedure NtCheck(RetVal: NTSTATUS); static;
    class function BCryptLoaded: Boolean;
    class function BCryptOpenAlgorithmProvider(out phAlgorithm: BCRYPT_ALG_HANDLE; pszAlgId, pszImplementation: LPCWSTR; dwFlags: ULONG): NTSTATUS;
    class function BCryptCloseAlgorithmProvider(hAlgorithm: BCRYPT_ALG_HANDLE; dwFlags: ULONG): NTSTATUS;
    class function BCryptGetProperty(hObject: BCRYPT_HANDLE; pszProperty: LPCWSTR; pbOutput: PUCHAR; cbOutput: ULONG; out pcbResult: ULONG; dwFlags: ULONG): NTSTATUS;
    class function BCryptCreateHash(hAlgorithm: BCRYPT_ALG_HANDLE; out phHash: BCRYPT_HASH_HANDLE; pbHashObject: PUCHAR; cbHashObject: ULONG; pbSecret: PUCHAR; cbSecret: ULONG; dwFlags: ULONG): NTSTATUS;
    class function BCryptDestroyHash(hHash: BCRYPT_HASH_HANDLE): NTSTATUS;
    class function BCryptHashData(hHash: BCRYPT_HASH_HANDLE; pbInput: PUCHAR; cbInput, dwFlags: ULONG): NTSTATUS;
    class function BCryptFinishHash(hHash: BCRYPT_HASH_HANDLE; pbOutput: PUCHAR; cbOutput, dwFlags: ULONG): NTSTATUS;
    class function Probe(AlgId: LPCWSTR; ForHmac: Boolean; out AlgHandle: BCRYPT_ALG_HANDLE{$IFDEF _TEST};HashSize: Integer{$ENDIF}): Boolean; static;
    procedure CreateHashObject(Key: PByte; KeyLen: PtrUInt);
    procedure DestroyHashObject;
  public
    constructor Create(AlgId: LPCWSTR; AlgHandle: BCRYPT_ALG_HANDLE; HashSize, BlockSize: Integer);
    destructor Destroy; override;
    procedure Update(Data: PByte; Size: PtrUInt); override;
    procedure Reset; override;
    procedure GetValue(Data: PByte); override;
    procedure GetHMAC(Data, Key, Result: PByte; DataSize, KeySize: PtrUInt); override;
  end;
  {$PACKRECORDS DEFAULT}
{$ENDIF WITH_WINAPI}

function CreateHash(AHash: TAvailableHashes; ForHmac: Boolean = False): IHashEngine;

implementation

uses
  {$IFDEF WITH_WINAPI}
  JwaWinBase, JwaNtStatus, {$IFDEF _TEST}JwaWinError,{$ENDIF} Math,
  {$ENDIF}
  System.Hash, System.Helpers.Strings;

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

{$IFDEF WITH_OPENSSL}
{ TOpensslHash }

class procedure TOpensslHash.Wipe;
begin
  _HMAC_Init_ex := nil;
  _HMAC_Update := nil;
  _HMAC_Final := nil;
end;

class function TOpensslHash.Probe(const DigestName: PAnsiChar; out Md: PEVP_MD):
  Boolean;
begin
  Md := EVP_get_digestbyname(DigestName);
  Result := Assigned(Md);
end;

class procedure TOpensslHash.OpensslCheck(RetVal: cInt);
var
  ErrorString: AnsiString;
  ErrorCode: cInt;
begin
  if RetVal = 0 then
  begin
    ErrorCode := ErrGetError;
    SetLength(ErrorString, 256);
    ErrErrorString(ErrorCode, ErrorString, Length(ErrorString));
    SetLength(ErrorString, Pos(#0, ErrorString) - Low(ErrorString));
    raise EHashException.Create(ErrorString);
  end;
end;

class function TOpensslHash.HMAC_Init_ex(ctx: PHMAC_CTX; const key: PByte;
  len: cint; md: PEVP_MD; impl: PENGINE): cint;
const
  HMAC_Init_ex_Name: PAnsiChar = 'HMAC_Init_ex';
begin
  if (SSLUtilHandle <> 0) and IsSSLloaded then
  begin
    if not Assigned(_HMAC_Init_ex) then
      _HMAC_Init_ex := GetProcAddress(SSLUtilHandle, HMAC_Init_ex_Name);

    if Assigned(_HMAC_Init_ex) then
      Exit(_HMAC_Init_ex(ctx, key, len, md, impl));
  end;

  Result := 0;
end;

class function TOpensslHash.HMAC_Update(ctx: PHMAC_CTX; const data: PByte;
  len: csize_t): cint;
const
  HMAC_Update_Name: PAnsiChar = 'HMAC_Update';
begin
  if (SSLUtilHandle <> 0) and IsSSLloaded then
  begin
    if not Assigned(_HMAC_Update) then
      _HMAC_Update := GetProcAddress(SSLUtilHandle, HMAC_Update_Name);

    if Assigned(_HMAC_Update) then
      Exit(_HMAC_Update(ctx, data, len));
  end;

  Result := 0;
end;

class function TOpensslHash.HMAC_Final(ctx: PHMAC_CTX; md: PByte; var len:
  cuint): cint;
const
  HMAC_Final_Name: PAnsiChar = 'HMAC_Final';
begin
  if (SSLUtilHandle <> 0) and IsSSLloaded then
  begin
    if not Assigned(_HMAC_Final) then
      _HMAC_Final := GetProcAddress(SSLUtilHandle, HMAC_Final_Name);

    if Assigned(_HMAC_Final) then
      Exit(_HMAC_Final(ctx, md, len));
  end;

  Result := 0;
end;

constructor TOpensslHash.Create(Md: PEVP_MD; HashSize, BlockSize: Integer);
begin
  FMd := Md;
  OpensslCheck(EVP_DigestInit(@FContext, FMd));
  SetLength(FDigest, HashSize);
  FHashing := True;

  inherited Create(HashSize, BlockSize);
end;

procedure TOpensslHash.Update(Data: PByte; Size: PtrUInt);
begin
  OpensslCheck(EVP_DigestUpdate(@FContext, Data, Size));
end;

procedure TOpensslHash.Reset;
begin
  OpensslCheck(EVP_DigestInit(@FContext, FMd));
  FHashing := True;
end;

procedure TOpensslHash.GetValue(Data: PByte);
var
  DigestLen: cuint;
begin
  if FHashing then
  begin
    DigestLen := Length(FDigest);
    OpensslCheck(EVP_DigestFinal(@FContext, @FDigest[Low(FDigest)], @DigestLen));
    FHashing := False;
  end;

  Move(FDigest[Low(FDigest)], Data^, GetHashSize);
end;

procedure TOpensslHash.GetHMAC(Data, Key, Result: PByte; DataSize, KeySize:
  PtrUInt);
const
  DummyKey: AnsiChar = #0;
var
  ctx: HMAC_CTX;
  KeyLen: cint;
  ResLen: cuint;
begin
  Assert(KeySize < High(KeyLen));
  KeyLen := cint(KeySize);

  if KeyLen = 0 then
    Key := @DummyKey;

  {$PUSH}
  {$HINTS OFF}
  FillChar(ctx, SizeOf(ctx), 0);
  {$POP}
  OpensslCheck(HMAC_Init_ex(@ctx, Key, KeyLen, FMd, nil));

  OpensslCheck(HMAC_Update(@ctx, Data, DataSize));

  ResLen := GetHashSize;
  OpensslCheck(HMAC_Final(@ctx, Result, ResLen));
end;
{$ENDIF WITH_OPENSSL}

{$IFDEF WITH_WINAPI}
{ TAbstractWinHash }

class procedure TAbstractWinHash.WinCheck(RetVal: BOOL);
begin
  if not RetVal then
    RaiseLastOSError;
end;

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
  MS_ENH_RSA_AES_PROV: PChar = 'Microsoft Enhanced RSA and AES Cryptographic Provider'; { Windows Server 2003+ }
  MS_ENH_RSA_AES_PROV_XP: PChar = 'Microsoft Enhanced RSA and AES Cryptographic Provider (Prototype)'; { Windows XP SP3 }
var
  HashingProvider: HCRYPTPROV;
  ProvName: PChar;
begin
  if FHashingProvider = 0 then
  begin
    if CheckWin32Version(5, 2) then
      ProvName := MS_ENH_RSA_AES_PROV
    else
      ProvName := MS_ENH_RSA_AES_PROV_XP;

    {$PUSH}
    {$HINTS OFF} { HashingProvider will initialized in this call }
    if not CryptAcquireContext(HashingProvider, nil, ProvName,
      PROV_RSA_AES, CRYPT_VERIFYCONTEXT or CRYPT_NEWKEYSET) then
    {$POP}
      WinCheck(CryptAcquireContext(HashingProvider, nil, MS_ENHANCED_PROV,
        PROV_RSA_FULL, CRYPT_VERIFYCONTEXT or CRYPT_NEWKEYSET));

    {$IFDEF CPU64}
    if System.InterlockedCompareExchange64(FHashingProvider, HashingProvider, 0) <> 0 then
    {$ELSE}
    if System.InterlockedCompareExchange(LongInt(FHashingProvider), HashingProvider, 0) <> 0 then
    {$ENDIF}
      { Oops, some other thread is already initialized this class before us... }
      CryptReleaseContext(HashingProvider, 0);
  end;

  Result := FHashingProvider;
  {$IFDEF CPU64}
  System.InterlockedIncrement64(FHashCounter);
  {$ELSE}
  System.InterlockedIncrement(FHashCounter);
  {$ENDIF}

  Assert(Result <> 0);
end;

class procedure TWinCryptoAPIHash.ReleaseHashingProvider;
begin
  Assert(FHashCounter <> 0);

  {$IFDEF CPU64}
  System.InterlockedDecrement64(FHashCounter);
  {$ELSE}
  System.InterlockedDecrement(FHashCounter);
  {$ENDIF}
end;

class function TWinCryptoAPIHash.Probe(AlgId: ALG_ID; out HashHandle: HCRYPTHASH{$IFDEF _TEST};HashSize: Integer{$ENDIF}): Boolean;
var
  {$IFDEF _TEST}
  SizeLen: DWord;
  ActualHashSize: Integer;
  {$ENDIF _TEST}
  LastError: Integer;
begin
  {$IFDEF _TEST}
  SizeLen := SizeOf(ActualHashSize);
  Assert(SizeLen = SizeOf(DWord));
  {$ENDIF _TEST}

  HashHandle := GetHashObject(AlgId, LastError);
  Result := HashHandle <> 0;

  {$IFDEF _TEST}
  if Result then
  begin
    WinCheck(CryptGetHashParam(HashHandle, HP_HASHSIZE, @ActualHashSize, SizeLen, 0));
    Assert(ActualHashSize = HashSize);
  end
  else
    if (LastError <> 0) and (LastError <> NTE_BAD_ALGID) then
      RaiseLastOSError(LastError);
  {$ENDIF _TEST}
end;

constructor TWinCryptoAPIHash.Create(AlgId: ALG_ID; HashHandle: HCRYPTHASH; HashSize, BlockSize: Integer);
begin
  inherited Create(HashSize, BlockSize);
  FAlgId := AlgId;
  FHashHandle := HashHandle;

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
    WinCheck(CryptDestroyHash(FHashHandle));
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
    WinCheck(CryptHashData(FHashHandle, Data, Count, 0));

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
  WinCheck(CryptGetHashParam(FHashHandle, HP_HASHVAL, Data, HashSize, 0));

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
  {$IFDEF _TEST}HMACSize, HMACSizeLen,{$ENDIF}
  HmacKeyLen, HashSize, Count: DWord;

  procedure Cleanup(LastError: Integer = 0);
  begin
    if HmacHash <> 0 then
      {$IFDEF _TEST}WinCheck({$ENDIF}CryptDestroyHash(HmacHash){$IFDEF _TEST}){$ENDIF};

    if HashKey <> 0 then
      {$IFDEF _TEST}WinCheck({$ENDIF}CryptDestroyKey(HashKey){$IFDEF _TEST}){$ENDIF};

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

  HmacKeyLen := DWord(SizeOf(THMACKey) + KeySize);
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
  {$IFDEF _TEST}
  HMACSizeLen := SizeOf(HMACSize);
  Assert(HMACSizeLen = SizeOf(DWord));
  if not CryptGetHashParam(HmacHash, HP_HASHSIZE, @HMACSize, HMACSizeLen, 0) then
    Cleanup(GetLastOSError);

  Assert(HMACSize = HashSize);
  {$ENDIF _TEST}

  if not CryptGetHashParam(HmacHash, HP_HASHVAL, Result, HashSize, 0) then
    Cleanup(GetLastOSError);

  Cleanup;
end;

{ TWinCNGHash }

class procedure TWinCNGHash.Init;
begin
  FUsageCounter := 0;
  FBCryphHandle := 0;
  Wipe;
end;

class procedure TWinCNGHash.Done;
begin
  Wipe;
  if (FBCryphHandle <> 0) and (FUsageCounter = 0) then
  begin
    UnloadLibrary(FBCryphHandle);
    FBCryphHandle := 0;
  end;
end;

class procedure TWinCNGHash.Wipe;
begin
  _BCryptOpenAlgorithmProvider := nil;
  _BCryptCloseAlgorithmProvider := nil;
  _BCryptGetProperty := nil;
  _BCryptCreateHash := nil;
  _BCryptDestroyHash := nil;
  _BCryptHashData := nil;
  _BCryptFinishHash := nil;
end;

class procedure TWinCNGHash.NtCheck(RetVal: NTSTATUS);
const
  NTDLL: RawByteString = 'ntdll.dll';
var
  ErrorText: string;
  NtLibHandle: TLibHandle;
begin
  {$IFDEF _TEST}
  if not NT_SUCCESS(RetVal) then
  {$ELSE}
  if NT_ERROR(RetVal) then
  {$ENDIF}
  begin
    NtLibHandle := 0;
    if not GetModuleHandleEx(0, LPCSTR(NTDLL), NtLibHandle) then
      NtLibHandle := SafeLoadLibrary(NTDLL);

    SetLength(ErrorText, $ffff);
    {$PUSH}
    {$HINTS OFF}
    {$RANGECHECKS OFF}
    SetLength(
      ErrorText,
      Windows.FormatMessage(
        FORMAT_MESSAGE_FROM_SYSTEM or FORMAT_MESSAGE_FROM_HMODULE or
        FORMAT_MESSAGE_IGNORE_INSERTS, LPCVOID(NtLibHandle), RetVal,
        MakeLangId(LANG_ENGLISH, SUBLANG_DEFAULT), PChar(ErrorText),
        Length(ErrorText) - 1, nil
      )
    );
    {$POP}
    UnloadLibrary(NtLibHandle);

    raise EHashException.CreateResFmt(@SNTError, [RetVal, ErrorText]);
  end;
end;

class function TWinCNGHash.BCryptLoaded: Boolean;
const
  LIBBCRYPT: RawByteString = 'bcrypt.dll';
  BC_OPEN_ALG_PROV_NAME: AnsiString = 'BCryptOpenAlgorithmProvider';
  BC_CLOSE_ALG_PROV_NAME: AnsiString = 'BCryptCloseAlgorithmProvider';
  BC_GET_PROP_NAME: AnsiString = 'BCryptGetProperty';
  BC_CREATE_HASH_NAME: AnsiString = 'BCryptCreateHash';
  BC_DESTROY_HASH_NAME: AnsiString = 'BCryptDestroyHash';
  BC_HASH_DATA_NAME: AnsiString = 'BCryptHashData';
  BC_HASH_FINISH_NAME: AnsiString = 'BCryptFinishHash';
var
  LibHandle: TLibHandle;

  function FailGetProc(var Proc: Pointer; ProcName: AnsiString): Boolean;
  var
    TmpAddr: Pointer;
  begin
    if not Assigned(Proc) then
    begin
      TmpAddr := GetProcedureAddress(FBCryphHandle, ProcName);
      {$PUSH}
      {$HINTS OFF}
      {$IFDEF CPU64}
      System.InterlockedCompareExchange64(QWord(Proc), QWord(TmpAddr), 0);
      {$ELSE}
      System.InterlockedCompareExchange(LongInt(Proc), LongInt(TmpAddr), 0);
      {$ENDIF}
      {$POP}
    end;
    Result := not Assigned(Proc);
  end;
begin
  Result := False;
  if FBCryphHandle = 0 then
  begin
    if not CheckWin32Version(6, 0) then
      Exit;

    LibHandle := 0;
    if not GetModuleHandleEx(0, LPCSTR(LIBBCRYPT), LibHandle) then
      LibHandle := SafeLoadLibrary(LIBBCRYPT);
    if (LibHandle <> 0) and
      {$IFDEF CPU64}
      (System.InterlockedCompareExchange64(FBCryphHandle, LibHandle, 0) <> 0) then
      {$ELSE}
      (System.InterlockedCompareExchange(LongInt(FBCryphHandle), LibHandle, 0) <> 0) then
      {$ENDIF}
      { Another thread is already load this library }
      UnloadLibrary(FBCryphHandle);

    if FBCryphHandle = 0 then
      Exit;
  end;

  if FailGetProc(_BCryptOpenAlgorithmProvider, BC_OPEN_ALG_PROV_NAME) then Exit;
  if FailGetProc(_BCryptCloseAlgorithmProvider, BC_CLOSE_ALG_PROV_NAME) then Exit;
  if FailGetProc(_BCryptGetProperty, BC_GET_PROP_NAME) then Exit;
  if FailGetProc(_BCryptCreateHash, BC_CREATE_HASH_NAME) then Exit;
  if FailGetProc(_BCryptDestroyHash, BC_DESTROY_HASH_NAME) then Exit;
  if FailGetProc(_BCryptHashData, BC_HASH_DATA_NAME) then Exit;
  if FailGetProc(_BCryptFinishHash, BC_HASH_FINISH_NAME) then Exit;
  Result := True;
end;

class function TWinCNGHash.BCryptOpenAlgorithmProvider(out phAlgorithm:
  BCRYPT_ALG_HANDLE; pszAlgId, pszImplementation: LPCWSTR; dwFlags: ULONG):
  NTSTATUS;
begin
  {$IFDEF CPU64}
  System.InterlockedIncrement64(FUsageCounter);
  {$ELSE}
  System.InterlockedIncrement(FUsageCounter);
  {$ENDIF}

  if Assigned(_BCryptOpenAlgorithmProvider) or BCryptLoaded then
    Result := TBCryptOpenAlgorithmProvider
      (_BCryptOpenAlgorithmProvider)(phAlgorithm, pszAlgId, pszImplementation, dwFlags)
  else
    Result := STATUS_NOT_SUPPORTED;

  if NT_ERROR(Result) then
  begin
    {$IFDEF CPU64}
    System.InterlockedDecrement64(FUsageCounter);
    {$ELSE}
    System.InterlockedDecrement(LongInt(FUsageCounter));
    {$ENDIF}
  end;
end;

class function TWinCNGHash.BCryptCloseAlgorithmProvider(hAlgorithm:
  BCRYPT_ALG_HANDLE; dwFlags: ULONG): NTSTATUS;
begin
  if Assigned(_BCryptCloseAlgorithmProvider) or BCryptLoaded then
  begin
    Result := TBCryptCloseAlgorithmProvider(_BCryptCloseAlgorithmProvider)
      (hAlgorithm, dwFlags);

    {$IFDEF CPU64}
    System.InterlockedDecrement64(FUsageCounter);
    {$ELSE}
    System.InterlockedDecrement(LongInt(FUsageCounter));
    {$ENDIF}
  end
  else
    Result := STATUS_NOT_SUPPORTED;
end;

class function TWinCNGHash.BCryptGetProperty(hObject: BCRYPT_HANDLE;
  pszProperty: LPCWSTR; pbOutput: PUCHAR; cbOutput: ULONG; out pcbResult: ULONG;
  dwFlags: ULONG): NTSTATUS;
begin
  if Assigned(_BCryptGetProperty) or BCryptLoaded then
    Result := TBCryptGetProperty(_BCryptGetProperty)
      (hObject, pszProperty, pbOutput, cbOutput, pcbResult,dwFlags)
  else
    Result := STATUS_NOT_SUPPORTED;

  {$IFDEF CPU64}
  System.InterlockedDecrement64(FUsageCounter);
  {$ELSE}
  System.InterlockedDecrement(LongInt(FUsageCounter));
  {$ENDIF}
end;

class function TWinCNGHash.BCryptCreateHash(hAlgorithm: BCRYPT_ALG_HANDLE;
  out phHash: BCRYPT_HASH_HANDLE; pbHashObject: PUCHAR; cbHashObject: ULONG;
  pbSecret: PUCHAR; cbSecret: ULONG; dwFlags: ULONG): NTSTATUS;
begin
  if Assigned(_BCryptCreateHash) or BCryptLoaded then
    Result := TBCryptCreateHash(_BCryptCreateHash)
      (hAlgorithm, phHash, pbHashObject, cbHashObject, pbSecret, cbSecret, dwFlags)
  else
    Result := STATUS_NOT_SUPPORTED;
end;

class function TWinCNGHash.BCryptDestroyHash(hHash: BCRYPT_HASH_HANDLE):
  NTSTATUS;
begin
  if Assigned(_BCryptDestroyHash) or BCryptLoaded then
    Result := TBCryptDestroyHash(_BCryptDestroyHash)(hHash)
  else
    Result := STATUS_NOT_SUPPORTED;
end;

class function TWinCNGHash.BCryptHashData(hHash: BCRYPT_HASH_HANDLE; pbInput:
  PUCHAR; cbInput, dwFlags: ULONG): NTSTATUS;
begin
  if Assigned(_BCryptHashData) or BCryptLoaded then
    Result := TBCryptHashData(_BCryptHashData)(hHash, pbInput, cbInput, dwFlags)
  else
    Result := STATUS_NOT_SUPPORTED;
end;

class function TWinCNGHash.BCryptFinishHash(hHash: BCRYPT_HASH_HANDLE;
  pbOutput: PUCHAR; cbOutput, dwFlags: ULONG): NTSTATUS;
begin
  if Assigned(_BCryptFinishHash) or BCryptLoaded then
    Result := TBCryptFinishHash(_BCryptFinishHash)
      (hHash, pbOutput, cbOutput, dwFlags)
  else
    Result := STATUS_NOT_SUPPORTED;
end;

class function TWinCNGHash.Probe(AlgId: LPCWSTR; ForHmac: Boolean;
  out AlgHandle: BCRYPT_ALG_HANDLE{$IFDEF _TEST};HashSize: Integer{$ENDIF}):
  Boolean;
const
  MS_PRIMITIVE_PROVIDER: LPCWSTR = 'Microsoft Primitive Provider';
var
  {$IFDEF _TEST}
  ActualHashSize, ResLen,
  {$ENDIF}
  Flags: DWord;
begin
  if ForHmac then
    Flags := BCRYPT_ALG_HANDLE_HMAC_FLAG
  else
    Flags := 0;

  Result := not NT_ERROR(BCryptOpenAlgorithmProvider(AlgHandle, AlgId,
    MS_PRIMITIVE_PROVIDER, Flags));

  if Result then
  begin
    Result := not NT_ERROR(BCryptGetProperty(AlgHandle, BCRYPT_HASH_LENGTH,
      @ActualHashSize, SizeOf(ActualHashSize), ResLen, 0));
    if Result then
    begin
      Assert(ActualHashSize = HashSize);
      Result := Result and (ActualHashSize = HashSize);
    end;
  end;
end;

procedure TWinCNGHash.CreateHashObject(Key: PByte; KeyLen: PtrUInt);
var
  HBlockSize, Flags: DWord;
begin
  Assert(KeyLen >= 0);

  if Assigned(FHashBlock) then
    HBlockSize := DWord(GetBlockSize)
  else
    HBlockSize := 0;

  if CheckWin32Version(6, 2) then
    { Only Windows 8+ have reusable hash objects support }
    Flags := BCRYPT_HASH_REUSABLE_FLAG
  else
    Flags := 0;

  NtCheck(BCryptCreateHash(FAlgHandle, FHashHandle, FHashBlock, HBlockSize,
    Key, DWord(KeyLen), Flags));
end;

procedure TWinCNGHash.DestroyHashObject;
begin
  if FHashHandle <> 0 then
  begin
    NtCheck(BCryptDestroyHash(FHashHandle));
    FHashHandle := 0;
  end;
end;

constructor TWinCNGHash.Create(AlgId: LPCWSTR; AlgHandle: BCRYPT_ALG_HANDLE;
  HashSize, BlockSize: Integer);
var
  HBlockSize, ResLen: DWord;
begin
  inherited Create(HashSize, BlockSize);
  FAlgId := AlgId;
  FAlgHandle := AlgHandle;
  FHashHandle := 0;
  GetMem(FHashResult, HashSize);
  FHashBlock := nil;
  if not CheckWin32Version(6, 1) then
  begin
    { Only Windows 7+ have its own memory management }
    NtCheck(BCryptGetProperty(FAlgHandle, BCRYPT_OBJECT_LENGTH, @HBlockSize,
      SizeOf(HBlockSize), ResLen, 0));
    Assert(BlockSize = HBlockSize);
    GetMem(FHashBlock, HBlockSize);
  end;
  FFinished := False;
  CreateHashObject(nil, 0);

  Assert(FHashHandle <> 0);
end;

destructor TWinCNGHash.Destroy;
begin
  DestroyHashObject;

  FreeMem(FHashResult);
  if Assigned(FHashBlock) then
    FreeMem(FHashBlock);

  NtCheck(BCryptCloseAlgorithmProvider(FAlgHandle, 0));

  inherited;
end;

procedure TWinCNGHash.Update(Data: PByte; Size: PtrUInt);
begin
  NtCheck(BCryptHashData(FHashHandle, Data, Size, 0));
end;

procedure TWinCNGHash.Reset;
begin
  if not (FFinished and CheckWin32Version(6, 2)) then
  begin
    { Windows 8+ have reusable hash objects support }
    DestroyHashObject;
    CreateHashObject(nil, 0);
  end;

  FFinished := False;
end;

procedure TWinCNGHash.GetValue(Data: PByte);
begin
  if not FFinished then
  begin
    NtCheck(BCryptFinishHash(FHashHandle, FHashResult, GetHashSize, 0));
    FFinished := True;
  end;

  Move(FHashResult^, Data^, GetHashSize);
end;

procedure TWinCNGHash.GetHMAC(Data, Key, Result: PByte; DataSize, KeySize: PtrUInt);
begin
  DestroyHashObject;
  CreateHashObject(Key, KeySize);
  Update(Data, DataSize);
  GetValue(Result);
end;
{$ENDIF}

function CreateHash(AHash: TAvailableHashes; ForHmac: Boolean): IHashEngine;
const
  {$IFDEF WITH_OPENSSL}
  OPENSSL_MAP: array [TAvailableHashes] of PAnsiChar = (
    'MD5', 'SHA1', 'SHA224', 'SHA256', 'SHA384', 'SHA512',
    {SHA2_512_224}nil, {SHA2_512_256}nil
  );
  {$ENDIF WITH_OPENSSL}
  {$IFDEF WITH_WINAPI}
  CRYPTO_MAP: array [TAvailableHashes] of ALG_ID = (
    CALG_MD5, CALG_SHA1, {SHA2_224}0, CALG_SHA_256, CALG_SHA_384, CALG_SHA_512,
    {SHA2_512_224}0, {SHA2_512_256}0
  );
  CNG_MAP: array [TAvailableHashes] of LPCWSTR = (
    'MD5', 'SHA1', {SHA224}nil, 'SHA256', 'SHA384', 'SHA512',
    {SHA2_512_224}nil, {SHA2_512_256}nil
  );
  {$ENDIF WITH_WINAPI}
var
  {$IFDEF WITH_OPENSSL}
  Md: PEVP_MD;
  {$ENDIF WITH_OPENSSL}
  {$IFDEF WITH_WINAPI}
  CngAlgId: LPCWSTR;
  CaAlgId: ALG_ID;
  CngAlgHandle: TWinCNGHash.BCRYPT_ALG_HANDLE;
  CaHashHandle: HCRYPTHASH;
  {$IFDEF _TEST}HashSize: Integer;{$ENDIF}
  {$ENDIF WITH_WINAPI}
begin
  {$IFDEF WITH_OPENSSL}
  if IsSSLloaded and TOpensslHash.Probe(OPENSSL_MAP[AHash], Md) then
    Exit(TOpensslHash.Create(Md,
      HASH_PARAMS[AHash].HashSize, HASH_PARAMS[AHash].BlockSize)
    );
  {$ENDIF WITH_OPENSSL}

  {$IFDEF WITH_WINAPI}
  { Vista+ CNG }
(*  if CheckWin32Version(6, 0) then
  begin
    CngAlgId := CNG_MAP[AHash];
    {$IFDEF _TEST}
    HashSize := HASH_PARAMS[AHash].HashSize;
    if Assigned(CngAlgId) and TWinCNGHash.Probe(CngAlgId, ForHmac, CngAlgHandle, HashSize) then
    {$ELSE}
    if Assigned(CngAlgId) and TWinCNGHash.Probe(CngAlgId, ForHmac, CngAlgHandle) then
    {$ENDIF}
      Exit(TWinCNGHash.Create(CngAlgId, CngAlgHandle,
        HASH_PARAMS[AHash].HashSize, HASH_PARAMS[AHash].BlockSize)
      );
  end; *)

  { CryptoAPI }
  { Looks like Windows prior Vista have a bug in HMAC computation code, causing
    wrong result if Data is empty }
  if (not ForHmac) or CheckWin32Version(6, 0) then
  begin
    CaAlgId := CRYPTO_MAP[AHash];
    {$IFDEF _TEST}
    HashSize := HASH_PARAMS[AHash].HashSize;
    if (CaAlgId <> 0) and TWinCryptoAPIHash.Probe(CaAlgId, CaHashHandle, HashSize) then
    {$ELSE}
    if (CaAlgId <> 0) and TWinCryptoAPIHash.Probe(CaAlgId, CaHashHandle) then
    {$ENDIF}
      Exit(TWinCryptoAPIHash.Create(CaAlgId, CaHashHandle,
        HASH_PARAMS[AHash].HashSize, HASH_PARAMS[AHash].BlockSize)
      );
    {$ENDIF WITH_WINAPI}
  end;

  raise Exception.Create('TODO: Not implemented yet');
end;

initialization
  {$IFDEF WITH_OPENSSL}
  TOpensslHash.Wipe;
  {$ENDIF}
  {$IFDEF WITH_WINAPI}
  TWinCNGHash.Init;
  TWinCryptoAPIHash.Init;
  {$ENDIF}

finalization
  {$IFDEF WITH_OPENSSL}
  TOpensslHash.Wipe;
  {$ENDIF}
  {$IFDEF WITH_WINAPI}
  TWinCNGHash.Done;
  TWinCryptoAPIHash.Done;
  {$ENDIF}

end.

