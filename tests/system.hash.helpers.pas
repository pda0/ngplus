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
  jwawincrypt;
  {$IFEND}

type
  IExtHash = interface
    function GetHashSize: Integer;
    function GetBlockSize: Integer;
    procedure Update(Data: PByte; Size: PtrUInt);
    procedure Reset;
    procedure GetValue(constref Data: PByte);
  end;

  {$IF DEFINED(WITH_OPENSSL)}

  {$ELSEIF DEFINED(WITH_WINAPI)}
  { Good old Windows CryptoAPI }
  TWinHash = class(TInterfacedObject, IExtHash)
  private
    class var FHashCounter: {$IFDEF CPU64}QWord{$ELSE}Cardinal{$ENDIF};
    class var FHashingProvider: HCRYPTPROV;
    FHashHandle: HCRYPTHASH;
    FAlgId: ALG_ID;
    FHashSize: Integer;
    class procedure Init;
    class procedure Done;
    class function GetHashingProvider: HCRYPTPROV;
    class procedure ReleaseHashingProvider;
    procedure CreateHashObject;
    procedure DestroyHashObject;
  public
    constructor Create(AlgId: ALG_ID);
    destructor Destroy; override;
    function GetHashSize: Integer;
    function GetBlockSize: Integer;
    procedure Update(Data: PByte; Size: PtrUInt);
    procedure Reset;
    procedure GetValue(constref Data: PByte);
  end;
{$IFEND}

implementation
{$IF DEFINED(WITH_OPENSSL)}

{$ELSEIF DEFINED(WITH_WINAPI)}
uses
  SysUtils, Math;

{ TWinHash }

class procedure TWinHash.Init;
begin
  FHashingProvider := 0;
  FHashCounter := 0;
end;

class procedure TWinHash.Done;
begin
  { We can only release crypto provider if no other hash is holding it.
    Otherwise it can be some leak in program or global variable still
    in scope. }
  if (FHashCounter = 0) and (FHashingProvider <> 0) then
    CryptReleaseContext(FHashingProvider, 0);
end;

class function TWinHash.GetHashingProvider: HCRYPTPROV;
const
  PROV_RSA_AES = 24; { WinXP SP3+ }
var
  HashingCryptoProvider: DWord;
  HashingProvider: HCRYPTPROV;
begin
  if FHashingProvider = 0 then
  begin
    HashingCryptoProvider := PROV_RSA_AES;
    {$PUSH}
    {$HINTS OFF} { HashingProvider will initialized in this call }
    if not CryptAcquireContext(HashingProvider, nil, nil, HashingCryptoProvider,
      CRYPT_VERIFYCONTEXT) then
    {$POP}
    begin
      HashingCryptoProvider := PROV_RSA_FULL;
      if not CryptAcquireContext(HashingProvider, nil, nil,
        HashingCryptoProvider, CRYPT_VERIFYCONTEXT) then
        RaiseLastOSError;
    end;

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

class procedure TWinHash.ReleaseHashingProvider;
begin
  Assert(FHashCounter <> 0);

  {$IFDEF CPU64}
  InterlockedDecrement64(FHashCounter);
  {$ELSE}
  InterlockedDecrement(FHashCounter);
  {$ENDIF}
end;

constructor TWinHash.Create(AlgId: ALG_ID);
var
  SizeLen: DWord;
begin
  FAlgId := AlgId;
  CreateHashObject;

  SizeLen := SizeOf(FHashSize);
  Assert(SizeLen = SizeOf(DWord));
  if not CryptGetHashParam(FHashHandle, HP_HASHSIZE, @FHashSize, SizeLen, 0) then
    RaiseLastOSError;
end;

destructor TWinHash.Destroy;
begin
  DestroyHashObject;
  inherited;
end;

procedure TWinHash.CreateHashObject;
var
  LastError: Integer;
begin
  if not CryptCreateHash(GetHashingProvider, FAlgId, 0, 0, FHashHandle) then
  begin
    LastError := GetLastOSError;
    ReleaseHashingProvider;
    FHashHandle := 0;
    RaiseLastOSError(LastError);
  end;

  Assert(FHashHandle <> 0);
end;

procedure TWinHash.DestroyHashObject;
begin
  if FHashHandle <> 0 then
  begin
    ReleaseHashingProvider;
    if not CryptDestroyHash(FHashHandle) then
      RaiseLastOSError;
  end;

  FHashHandle := 0;
end;

function TWinHash.GetHashSize: Integer;
begin
  Result := FHashSize;
end;

function TWinHash.GetBlockSize: Integer;
begin
  Result := -1;
end;

procedure TWinHash.Update(Data: PByte; Size: PtrUInt);
var
  Count: DWord;
begin
  Assert(FHashHandle <> 0);

  while Size <> 0 do
  begin
    Count := Min(High(DWord), Size);
    if not CryptHashData(FHashHandle, Data, Count, 0) then
      RaiseLastOSError;

    Size := Size - Count;
    Data := Data + Count;
  end;
end;

procedure TWinHash.Reset;
begin
  DestroyHashObject;
  CreateHashObject;
end;

procedure TWinHash.GetValue(constref Data: PByte);
var
  HashSize: DWord;
begin
  HashSize := FHashSize;
  if not CryptGetHashParam(FHashHandle, HP_HASHVAL, Data, HashSize, 0) then
    RaiseLastOSError;

  Assert(HashSize = FHashSize);
end;
{$IFEND}

{$IF DEFINED(WITH_WINAPI)}
initialization
  TWinHash.Init;

finalization
  TWinHash.Done;

{$IFEND}
end.

