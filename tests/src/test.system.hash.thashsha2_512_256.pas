{**********************************************************************
    Copyright(c) 2016 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit Test.System.Hash.THashSHA2_512_256;

{$I ../src/delphi.inc}
{$IFDEF DELPHI_XE4_PLUS}{$LEGACYIFEND ON}{$ENDIF}
{$I ../src/ngplus.inc}

interface

uses
  {$IFDEF FPC}
  fpcunit, testregistry,
  {$ELSE}
  TestFramework,
  {$ENDIF FPC}
  Classes, SysUtils, System.Hash;

{$IF DEFINED(FPC) OR DEFINED(DELPHI_SEATTLE_PLUS)}
type
  TTestTHashSHA2_512_256 = class(TTestCase)
  strict private
    FHash: THashSHA2;
  private
    procedure FailResetRaw;
    procedure FailResetTBytes;
    procedure FailResetString;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    {$IFDEF CLOSER_TO_DELPHI}
    procedure TestCreate;
    {$ENDIF CLOSER_TO_DELPHI}
    procedure TestGetBlockSize;
    procedure TestGetHashSize;
    procedure TestReset;
    procedure TestResetRaw;
    procedure TestResetTBytes;
    procedure TestResetString;
    procedure TestHashAsString;
    procedure TestHashAsBytes;
    {$IFDEF FPC}
    procedure TestGetHashStringAnsi;
    {$ENDIF FPC}
    procedure TestGetHashStringUnicode;
    procedure TestGetHashBytes;
    procedure TestUpdateRaw;
    procedure TestUpdateRawZero;
    procedure TestUpdateTBytes;
    procedure TestUpdateTBytesHalf;
    procedure TestUpdateTBytesZero;
    {$IFDEF FPC}
    procedure TestUpdateAnsiString;
    procedure TestGetHMACAnsi;
    procedure TestGetHMACAsBytesAnsi;
    {$ENDIF FPC}
    procedure TestUpdateUnicodeString;
    procedure TestGetHMACUnicode;
    procedure TestGetHMACAsBytesUnicode;
  end;
{$IFEND}

implementation

{$IF DEFINED(FPC) OR DEFINED(DELPHI_SEATTLE_PLUS)}
{ TTestTHashSHA2_512_256 }

const
  HASH_SHA512_256_SIZE = 32;
  HASH_SHA512_256_BLOCK_SIZE = 128;
  HASH_SHA512_256_EMPTY = 'c672b8d1ef56ed28ab87c3622c5114069bdd3ad7b8f9737498d0c01ecef0967a';
  {$IFDEF FPC}
  TEST_STR_ANSI: AnsiString = 'The quick brown fox jumps over the lazy dog';
  {$ENDIF FPC}
  TEST_STR_UNICODE: UnicodeString = '支持楼主，不怕当小白鼠';
  TEST_BYTES_RESULT: array [0..HASH_SHA512_256_SIZE - 1] of Byte = (
    $99, $96, $d3, $16, $c8, $74, $a3, $00, $ab, $c4, $9f, $7e, $33, $26, $5d, $31,
    $2b, $e0, $32, $36, $64, $5c, $87, $68, $03, $87, $77, $2f, $81, $4a, $ee, $48
  );

procedure TTestTHashSHA2_512_256.SetUp;
begin
  FHash := THashSHA2.Create(SHA512_256);
end;

procedure TTestTHashSHA2_512_256.TearDown;
begin
  {$IFDEF FPC}
  { We have to finalize record manually because fpcunit never frees TTestCase
    so our record never never runs out of scope. }
  Finalize(FHash);
  {$ENDIF FPC}
end;

{$IFDEF CLOSER_TO_DELPHI}
procedure TTestTHashSHA2_512_256.TestCreate;
begin
  CheckTrue(FHash.FVersion = SHA512_256);
end;
{$ENDIF CLOSER_TO_DELPHI}

procedure TTestTHashSHA2_512_256.TestGetBlockSize;
begin
  CheckEquals(HASH_SHA512_256_BLOCK_SIZE, FHash.GetBlockSize);
end;

procedure TTestTHashSHA2_512_256.TestGetHashSize;
begin
  CheckEquals(HASH_SHA512_256_SIZE, FHash.GetHashSize);
end;

procedure TTestTHashSHA2_512_256.TestReset;
begin
  CheckEquals(HASH_SHA512_256_EMPTY, FHash.HashAsString);

  FHash.Reset;
  CheckEquals(HASH_SHA512_256_EMPTY, FHash.HashAsString);

  FHash.Reset;
  CheckEquals(HASH_SHA512_256_EMPTY, FHash.HashAsString);
end;

procedure TTestTHashSHA2_512_256.FailResetRaw;
const
  TEST_VAL: Cardinal = $01020304;
begin
  FHash.Update(TEST_VAL, SizeOf(TEST_VAL));
end;

procedure TTestTHashSHA2_512_256.TestResetRaw;
const
  TEST_VAL: Cardinal = $01020304;
begin
  FHash.Update(TEST_VAL, SizeOf(TEST_VAL));
  FHash.Reset;
  CheckEquals(HASH_SHA512_256_EMPTY, FHash.HashAsString);

  CheckException(FailResetRaw, EHashException);
end;

procedure TTestTHashSHA2_512_256.FailResetTBytes;
var
  TestBytes: TBytes;
begin
  SetLength(TestBytes, 0);
  FHash.Update(TestBytes);
end;

procedure TTestTHashSHA2_512_256.TestResetTBytes;
var
  TestBytes: TBytes;
begin
  SetLength(TestBytes, 2);
  TestBytes[0] := 5; TestBytes[1] := 6;
  FHash.Update(TestBytes);
  FHash.Reset;
  CheckEquals(HASH_SHA512_256_EMPTY, FHash.HashAsString);

  CheckException(FailResetTBytes, EHashException);
end;

procedure TTestTHashSHA2_512_256.FailResetString;
begin
  FHash.Update('BlahBlahBlah');
end;

procedure TTestTHashSHA2_512_256.TestResetString;
begin
  FHash.Update('BlahBlahBlah');
  FHash.Reset;
  CheckEquals(HASH_SHA512_256_EMPTY, FHash.HashAsString);

  CheckException(FailResetString, EHashException);
end;

procedure TTestTHashSHA2_512_256.TestHashAsString;
begin
  FHash.Update(TEST_STR_UNICODE);
  CheckEquals(
    '9996d316c874a300abc49f7e33265d312be03236645c87680387772f814aee48',
    FHash.HashAsString
  );
  { Ready hash value must be available more than once }
  CheckEquals(
    '9996d316c874a300abc49f7e33265d312be03236645c87680387772f814aee48',
    FHash.HashAsString
  );
end;

procedure TTestTHashSHA2_512_256.TestHashAsBytes;
var
  Result: TBytes;
  i: Integer;
begin
  FHash.Update(TEST_STR_UNICODE);
  Result := FHash.HashAsBytes;
  CheckEquals(HASH_SHA512_256_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT) do
    CheckEquals(TEST_BYTES_RESULT[i], Result[i]);
end;

{$IFDEF FPC}
procedure TTestTHashSHA2_512_256.TestGetHashStringAnsi;
begin
  CheckEquals(
    'dd9d67b371519c339ed8dbd25af90e976a1eeefd4ad3d889005e532fc5bef04d',
    FHash.GetHashString(TEST_STR_ANSI, SHA512_256)
  );
end;
{$ENDIF FPC}

procedure TTestTHashSHA2_512_256.TestGetHashStringUnicode;
begin
  CheckEquals(
    '9996d316c874a300abc49f7e33265d312be03236645c87680387772f814aee48',
    FHash.GetHashString(TEST_STR_UNICODE, SHA512_256)
  );
end;

procedure TTestTHashSHA2_512_256.TestGetHashBytes;
var
  Result: TBytes;
  i: Integer;
begin
  Result := FHash.GetHashBytes(TEST_STR_UNICODE, SHA512_256);
  CheckEquals(HASH_SHA512_256_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT) do
    CheckEquals(TEST_BYTES_RESULT[i], Result[i]);
end;

procedure TTestTHashSHA2_512_256.TestUpdateRaw;
var
  TestVal1, TestVal2: Cardinal;
begin
  TestVal1 := THash.ToBigEndian(Cardinal($01020304));
  TestVal2 := THash.ToBigEndian(Cardinal($05060708));

  FHash.Update(TestVal1, SizeOf(TestVal1));
  FHash.Update(TestVal2, SizeOf(TestVal2));
  CheckEquals(
    '70b3dde776118752e2c2947233caf442a9d6dcb8c1619c6faebab6a17e577191',
    FHash.HashAsString
  );
end;

procedure TTestTHashSHA2_512_256.TestUpdateRawZero;
const
  TEST_VAL: Cardinal = $01020304;
begin
  FHash.Update(TEST_VAL, 0);
  CheckEquals(HASH_SHA512_256_EMPTY, FHash.HashAsString);
end;

procedure TTestTHashSHA2_512_256.TestUpdateTBytes;
var
  TestBytes1, TestBytes2: TBytes;
begin
  SetLength(TestBytes1, 2);
  TestBytes1[0] := $10; TestBytes1[1] := $11;
  SetLength(TestBytes2, 2);
  TestBytes2[0] := $12; TestBytes2[1] := $13;

  FHash.Update(TestBytes1);
  FHash.Update(TestBytes2);
  CheckEquals(
    '3ebb2c7460262cb3f46b4984de10e66d17eacd7aa833b72eaa63fb1366a59a3c',
    FHash.HashAsString
  );
end;

procedure TTestTHashSHA2_512_256.TestUpdateTBytesHalf;
var
  TestBytes: TBytes;
begin
  SetLength(TestBytes, 4);
  TestBytes[0] := $10; TestBytes[1] := $11; TestBytes[2] := $12; TestBytes[3] := $13;

  FHash.Update(TestBytes, 2);
  CheckEquals(
    '68ad8ac49bed7257c830ee96440fd4a10a25b20c69f4d6cdc774303a8ea54703',
    FHash.HashAsString
  );
end;

procedure TTestTHashSHA2_512_256.TestUpdateTBytesZero;
var
  TestBytes: TBytes;
begin
  SetLength(TestBytes, 4);
  TestBytes[0] := $10; TestBytes[1] := $11; TestBytes[2] := $12; TestBytes[3] := $13;

  FHash.Update(TestBytes, 0);
  CheckEquals(
    '3ebb2c7460262cb3f46b4984de10e66d17eacd7aa833b72eaa63fb1366a59a3c',
    FHash.HashAsString
  );
end;


{$IFDEF FPC}
procedure TTestTHashSHA2_512_256.TestUpdateAnsiString;
begin
  FHash.Update(AnsiString('The quick brown fox '));
  FHash.Update(AnsiString('jumps over the lazy dog'));
  CheckEquals(
    'dd9d67b371519c339ed8dbd25af90e976a1eeefd4ad3d889005e532fc5bef04d',
    FHash.HashAsString
  );
end;
{$ENDIF FPC}

procedure TTestTHashSHA2_512_256.TestUpdateUnicodeString;
begin
  FHash.Update(UnicodeString('支持楼主，'));
  FHash.Update(UnicodeString('不怕当小白鼠'));
  CheckEquals(
    '9996d316c874a300abc49f7e33265d312be03236645c87680387772f814aee48',
    FHash.HashAsString
  );
end;

{$IFDEF FPC}
procedure TTestTHashSHA2_512_256.TestGetHMACAnsi;
begin
  CheckEquals(
    'b79c9951df595274582dc094a1ba46c33e4a36878b2d83cb8553f0fe467dcdcf',
    FHash.GetHMAC(AnsiString(''), AnsiString(''), SHA512_256)
  );
  CheckEquals(
    '7fb65e03577da9151a1016e9c2e514d4d48842857f13927f348588173dca6d89',
    FHash.GetHMAC(TEST_STR_ANSI, AnsiString('key'), SHA512_256)
  );
  CheckEquals(
    'e8ded9c9e74072a8f1f8d668d5723944d03c96667906618acc0f888f198587ef',
    FHash.GetHMAC(
      TEST_STR_ANSI,
      AnsiString('very____________________________________________________________long__________________________________________________________________key'),
      SHA512_256
    )
  );
end;
{$ENDIF FPC}

procedure TTestTHashSHA2_512_256.TestGetHMACUnicode;
begin
  CheckEquals(
    'b79c9951df595274582dc094a1ba46c33e4a36878b2d83cb8553f0fe467dcdcf',
    FHash.GetHMAC(UnicodeString(''), UnicodeString(''), SHA512_256)
  );
  CheckEquals(
    'ff79c0f0c0d1bf9f36e4d8aec36e8cf22e6e0cfdd4ee7bcedfa380edf7aee316',
    FHash.GetHMAC(TEST_STR_UNICODE, UnicodeString('key'), SHA512_256)
  );
end;

const
  TEST_BYTES_RESULT_1: array [0..HASH_SHA512_256_SIZE - 1] of Byte = (
    $b4, $a2, $8f, $46, $3d, $a2, $6e, $b5, $59, $5c, $fe, $a8, $c4, $91, $16, $b7,
    $92, $bf, $7e, $b5, $80, $00, $41, $ce, $5d, $7e, $4c, $eb, $c1, $80, $74, $c8
  );
  TEST_BYTES_RESULT_2: array [0..HASH_SHA512_256_SIZE - 1] of Byte = (
    $11, $b6, $48, $a2, $fc, $b4, $5d, $2a, $1e, $84, $e8, $d3, $c3, $51, $b9, $30,
    $dd, $57, $ff, $5d, $5f, $5a, $5e, $00, $95, $38, $ff, $d9, $ab, $31, $77, $2d
  );
  TEST_BYTES_RESULT_3: array [0..HASH_SHA512_256_SIZE - 1] of Byte = (
    $07, $92, $96, $24, $47, $3f, $17, $81, $1c, $f9, $fc, $b2, $21, $53, $9f, $6d,
    $0d, $2a, $25, $b6, $19, $28, $60, $f7, $f5, $ae, $4b, $bf, $4b, $ab, $ed, $b8
  );
  TEST_BYTES_RESULT_4: array [0..HASH_SHA512_256_SIZE - 1] of Byte = (
    $d9, $5d, $40, $26, $92, $00, $8a, $37, $e4, $fe, $5c, $e0, $8b, $01, $76, $84,
    $e4, $0b, $5a, $b0, $3b, $88, $6f, $22, $a8, $94, $4f, $f0, $d0, $8d, $4d, $ca
  );
  TEST_BYTES_RESULT_5: array [0..HASH_SHA512_256_SIZE - 1] of Byte = (
    $c9, $95, $a4, $a9, $03, $1e, $9c, $19, $95, $03, $02, $32, $3b, $1c, $db, $32,
    $83, $ba, $73, $2d, $a8, $ab, $c1, $48, $30, $63, $31, $97, $09, $aa, $89, $9e
  );

{$IFDEF FPC}
procedure TTestTHashSHA2_512_256.TestGetHMACAsBytesAnsi;
var
  TestBytes, Result: TBytes;
  i: Integer;
begin
  SetLength(TestBytes, 4);
  TestBytes[0] := $10; TestBytes[1] := $11; TestBytes[2] := $12; TestBytes[3] := $13;

  Result := FHash.GetHMACAsBytes(AnsiString('data'), AnsiString('data'), SHA512_256);
  CheckEquals(HASH_SHA512_256_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_1) do
    CheckEquals(TEST_BYTES_RESULT_1[i], Result[i]);

  Result := FHash.GetHMACAsBytes(TestBytes, AnsiString('data'), SHA512_256);
  CheckEquals(HASH_SHA512_256_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_2) do
    CheckEquals(TEST_BYTES_RESULT_2[i], Result[i]);

  Result := FHash.GetHMACAsBytes(AnsiString('data'), TestBytes, SHA512_256);
  CheckEquals(HASH_SHA512_256_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_3) do
    CheckEquals(TEST_BYTES_RESULT_3[i], Result[i]);

  Result := FHash.GetHMACAsBytes(TestBytes, TestBytes, SHA512_256);
  CheckEquals(HASH_SHA512_256_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_4) do
    CheckEquals(TEST_BYTES_RESULT_4[i], Result[i]);
end;
{$ENDIF FPC}

procedure TTestTHashSHA2_512_256.TestGetHMACAsBytesUnicode;
var
  TestBytes, Result: TBytes;
  i: Integer;
begin
  SetLength(TestBytes, 4);
  TestBytes[0] := $10; TestBytes[1] := $11; TestBytes[2] := $12; TestBytes[3] := $13;

  Result := FHash.GetHMACAsBytes(UnicodeString('data'), UnicodeString('data'), SHA512_256);
  CheckEquals(HASH_SHA512_256_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_1) do
    CheckEquals(TEST_BYTES_RESULT_1[i], Result[i]);

  Result := FHash.GetHMACAsBytes(TestBytes, UnicodeString('data'), SHA512_256);
  CheckEquals(HASH_SHA512_256_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_2) do
    CheckEquals(TEST_BYTES_RESULT_2[i], Result[i]);

  Result := FHash.GetHMACAsBytes(UnicodeString('data'), TestBytes, SHA512_256);
  CheckEquals(HASH_SHA512_256_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_3) do
    CheckEquals(TEST_BYTES_RESULT_3[i], Result[i]);

  Result := FHash.GetHMACAsBytes(TestBytes, TestBytes, SHA512_256);
  CheckEquals(HASH_SHA512_256_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_4) do
    CheckEquals(TEST_BYTES_RESULT_4[i], Result[i]);

  { big }
  SetLength(TestBytes, 4096);
  for i := Low(TestBytes) to High(TestBytes) do
    TestBytes[i] := (i + 1) mod $ff;
  Result := FHash.GetHMACAsBytes(TestBytes, TestBytes, SHA512_256);
  CheckEquals(HASH_SHA512_256_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_5) do
    CheckEquals(TEST_BYTES_RESULT_5[i], Result[i]);
end;

initialization
  //RegisterTest('System.Hash', TTestTHashSHA2_512_256.Suite);
{$IFEND}

end.

