{**********************************************************************
    Copyright(c) 2016 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit Test.System.Hash.THashSHA2_256;

{$IFNDEF FPC}{$LEGACYIFEND ON}{$ENDIF FPC}
{$I ngplus.inc}

interface

uses
  {$IFDEF FPC}
  fpcunit, testregistry,
  {$ELSE}
  TestFramework,
  {$ENDIF FPC}
  Classes, SysUtils, System.Hash;

type
  TTestTHashSHA2_256 = class(TTestCase)
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
    {$ENDIF FPC}
    procedure TestUpdateUnicodeString;
//    procedure TestGetHMAC;
//    procedure TestGetHMACAsBytes;
//    procedure TestDefaults;
  end;

implementation

{ TTestTHashSHA2_256 }

const
  HASH_SHA256_SIZE = 32;
  HASH_SHA256_BLOCK_SIZE = 64;
  HASH_SHA256_EMPTY = 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855';
  {$IFDEF FPC}
  TEST_STR_ANSI: AnsiString = 'The quick brown fox jumps over the lazy dog';
  {$ENDIF FPC}
  TEST_STR_UNICODE: UnicodeString = '支持楼主，不怕当小白鼠';
  TEST_BYTES_RESULT: array [0..HASH_SHA256_SIZE - 1] of Byte = (
    $da, $00, $b1, $61, $3c, $2c, $df, $79, $cd, $47, $dd, $c2, $f3, $6f, $c5, $e9,
    $80, $49, $79, $b8, $31, $5a, $c3, $fa, $0d, $89, $9d, $35, $ef, $5e, $1a, $fd
  );

procedure TTestTHashSHA2_256.SetUp;
begin
  FHash := THashSHA2.Create(SHA256);
end;

procedure TTestTHashSHA2_256.TearDown;
begin
  { We have to finalize record manually because fpcunit never frees TTestCase
    so our record never never runs out of scope. }
  Finalize(FHash);
end;

{$IFDEF CLOSER_TO_DELPHI}
procedure TTestTHashSHA2_256.TestCreate;
begin
  CheckTrue(FHash.FVersion = SHA256);
end;
{$ENDIF CLOSER_TO_DELPHI}

procedure TTestTHashSHA2_256.TestGetBlockSize;
begin
  CheckEquals(HASH_SHA256_BLOCK_SIZE, FHash.GetBlockSize);
end;

procedure TTestTHashSHA2_256.TestGetHashSize;
begin
  CheckEquals(HASH_SHA256_SIZE, FHash.GetHashSize);
end;

procedure TTestTHashSHA2_256.TestReset;
begin
  CheckEquals(HASH_SHA256_EMPTY, FHash.HashAsString);

  FHash.Reset;
  CheckEquals(HASH_SHA256_EMPTY, FHash.HashAsString);

  FHash.Reset;
  CheckEquals(HASH_SHA256_EMPTY, FHash.HashAsString);
end;

procedure TTestTHashSHA2_256.FailResetRaw;
const
  TEST_VAL: Cardinal = $01020304;
begin
  FHash.Update(TEST_VAL, SizeOf(TEST_VAL));
end;

procedure TTestTHashSHA2_256.TestResetRaw;
const
  TEST_VAL: Cardinal = $01020304;
begin
  FHash.Update(TEST_VAL, SizeOf(TEST_VAL));
  FHash.Reset;
  CheckEquals(HASH_SHA256_EMPTY, FHash.HashAsString);

  CheckException(FailResetRaw, EHashException);
end;

procedure TTestTHashSHA2_256.FailResetTBytes;
var
  TestBytes: TBytes;
begin
  SetLength(TestBytes, 0);
  FHash.Update(TestBytes);
end;

procedure TTestTHashSHA2_256.TestResetTBytes;
var
  TestBytes: TBytes;
begin
  SetLength(TestBytes, 2);
  TestBytes[0] := 5; TestBytes[1] := 6;
  FHash.Update(TestBytes);
  FHash.Reset;
  CheckEquals(HASH_SHA256_EMPTY, FHash.HashAsString);

  CheckException(FailResetTBytes, EHashException);
end;

procedure TTestTHashSHA2_256.FailResetString;
begin
  FHash.Update('BlahBlahBlah');
end;

procedure TTestTHashSHA2_256.TestResetString;
begin
  FHash.Update('BlahBlahBlah');
  FHash.Reset;
  CheckEquals(HASH_SHA256_EMPTY, FHash.HashAsString);

  CheckException(FailResetString, EHashException);
end;

procedure TTestTHashSHA2_256.TestHashAsString;
begin
  FHash.Update(TEST_STR_UNICODE);
  CheckEquals(
    'da00b1613c2cdf79cd47ddc2f36fc5e9804979b8315ac3fa0d899d35ef5e1afd',
    FHash.HashAsString
  );
  { Ready hash value must be available more than once }
  CheckEquals(
    'da00b1613c2cdf79cd47ddc2f36fc5e9804979b8315ac3fa0d899d35ef5e1afd',
    FHash.HashAsString
  );
end;

procedure TTestTHashSHA2_256.TestHashAsBytes;
var
  Result: TBytes;
  i: Integer;
begin
  FHash.Update(TEST_STR_UNICODE);
  Result := FHash.HashAsBytes;
  CheckEquals(HASH_SHA256_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT) do
    CheckEquals(TEST_BYTES_RESULT[i], Result[i]);
end;

{$IFDEF FPC}
procedure TTestTHashSHA2_256.TestGetHashStringAnsi;
begin
  CheckEquals(
    'd7a8fbb307d7809469ca9abcb0082e4f8d5651e46d3cdb762d02d0bf37c9e592',
    FHash.GetHashString(TEST_STR_ANSI, SHA256)
  );
end;
{$ENDIF FPC}

procedure TTestTHashSHA2_256.TestGetHashStringUnicode;
begin
  CheckEquals(
    'da00b1613c2cdf79cd47ddc2f36fc5e9804979b8315ac3fa0d899d35ef5e1afd',
    FHash.GetHashString(TEST_STR_UNICODE, SHA256)
  );
end;

procedure TTestTHashSHA2_256.TestGetHashBytes;
var
  Result: TBytes;
  i: Integer;
begin
  Result := FHash.GetHashBytes(TEST_STR_UNICODE, SHA256);
  CheckEquals(HASH_SHA256_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT) do
    CheckEquals(TEST_BYTES_RESULT[i], Result[i]);
end;

procedure TTestTHashSHA2_256.TestUpdateRaw;
var
  TestVal1, TestVal2: Cardinal;
begin
  TestVal1 := THash.ToBigEndian(Cardinal($01020304));
  TestVal2 := THash.ToBigEndian(Cardinal($05060708));

  FHash.Update(TestVal1, SizeOf(TestVal1));
  FHash.Update(TestVal2, SizeOf(TestVal2));
  CheckEquals(
    '66840dda154e8a113c31dd0ad32f7f3a366a80e8136979d8f5a101d3d29d6f72',
    FHash.HashAsString
  );
end;

procedure TTestTHashSHA2_256.TestUpdateRawZero;
const
  TEST_VAL: Cardinal = $01020304;
begin
  FHash.Update(TEST_VAL, 0);
  CheckEquals(HASH_SHA256_EMPTY, FHash.HashAsString);
end;

procedure TTestTHashSHA2_256.TestUpdateTBytes;
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
    'a00291e8229d191815f2cbd2aa49d3b783585deae8012ca5941f011ceb9eb119',
    FHash.HashAsString
  );
end;

procedure TTestTHashSHA2_256.TestUpdateTBytesHalf;
var
  TestBytes: TBytes;
begin
  SetLength(TestBytes, 4);
  TestBytes[0] := $10; TestBytes[1] := $11; TestBytes[2] := $12; TestBytes[3] := $13;

  FHash.Update(TestBytes, 2);
  CheckEquals(
    '3a393a862889fd2bcc4a2939b02eab350625a27342e6a8257769839cbd458e5b',
    FHash.HashAsString
  );
end;

procedure TTestTHashSHA2_256.TestUpdateTBytesZero;
var
  TestBytes: TBytes;
begin
  SetLength(TestBytes, 4);
  TestBytes[0] := $10; TestBytes[1] := $11; TestBytes[2] := $12; TestBytes[3] := $13;

  FHash.Update(TestBytes, 0);
  CheckEquals(
    'a00291e8229d191815f2cbd2aa49d3b783585deae8012ca5941f011ceb9eb119',
    FHash.HashAsString
  );
end;

{$IFDEF FPC}
procedure TTestTHashSHA2_256.TestUpdateAnsiString;
begin
  FHash.Update(AnsiString('The quick brown fox '));
  FHash.Update(AnsiString('jumps over the lazy dog'));
  CheckEquals(
    'd7a8fbb307d7809469ca9abcb0082e4f8d5651e46d3cdb762d02d0bf37c9e592',
    FHash.HashAsString
  );
end;
{$ENDIF FPC}

procedure TTestTHashSHA2_256.TestUpdateUnicodeString;
begin
  FHash.Update(UnicodeString('支持楼主，'));
  FHash.Update(UnicodeString('不怕当小白鼠'));
  CheckEquals(
    'da00b1613c2cdf79cd47ddc2f36fc5e9804979b8315ac3fa0d899d35ef5e1afd',
    FHash.HashAsString
  );
end;

(* procedure TTestTHashSHA2_256.TestGetHMAC;
begin
  CheckEquals(
    '4d42fb9ffc8d7d0a245429438b4bc73db1007a167026a0a0c6a74fa58e8e86ca',
    FHash.GetHMAC('password', 'key', SHA256)
  );
  CheckEquals(
    'b613679a0814d9ec772f95d778c35fc5ff1697c493715653c6c712144292c5ad',
    FHash.GetHMAC('', '', SHA256)
  );
end;

const
  TEST_BYTES_RESULT_1: array [0..HASH_SHA256_SIZE - 1] of Byte = (
    $98, $e6, $52, $9e, $43, $21, $5a, $cd, $d5, $91, $11, $97, $33, $41, $6d, $bf,
    $ab, $8d, $54, $91, $e7, $f4, $fb, $be, $dc, $76, $7d, $92, $b8, $6c, $7a, $f1
  );
  TEST_BYTES_RESULT_2: array [0..HASH_SHA256_SIZE - 1] of Byte = (
    $64, $42, $65, $30, $ed, $5b, $48, $d7, $f4, $f9, $84, $39, $aa, $0f, $fe, $34,
    $4f, $f0, $26, $af, $bb, $1e, $99, $82, $fe, $9c, $50, $a8, $20, $ef, $f7, $2d
  );
  TEST_BYTES_RESULT_3: array [0..HASH_SHA256_SIZE - 1] of Byte = (
    $c0, $a5, $8c, $d8, $bc, $3c, $26, $5c, $cf, $59, $b5, $96, $37, $f4, $52, $d9,
    $e3, $0a, $b8, $bd, $24, $4f, $d9, $57, $fe, $76, $2a, $03, $03, $76, $83, $24
  );
  TEST_BYTES_RESULT_4: array [0..HASH_SHA256_SIZE - 1] of Byte = (
    $e0, $61, $73, $db, $40, $95, $03, $29, $18, $a5, $f8, $aa, $c8, $e7, $51, $ba,
    $20, $ca, $66, $57, $37, $e9, $46, $34, $a5, $00, $b5, $cf, $9d, $1c, $9d, $a1
  );
  TEST_BYTES_RESULT_5: array [0..HASH_SHA256_SIZE - 1] of Byte = (
    $d2, $e1, $1b, $2d, $08, $22, $91, $7a, $12, $9a, $b8, $26, $a3, $06, $9d, $ed,
    $4f, $9f, $35, $37, $04, $ca, $8a, $5e, $e6, $c8, $75, $13, $97, $09, $75, $11
  );

procedure TTestTHashSHA2_256.TestGetHMACAsBytes;
var
  TestBytes, Result: TBytes;
  i: Integer;
begin
  SetLength(TestBytes, 4);
  TestBytes[0] := $10; TestBytes[1] := $11; TestBytes[2] := $12; TestBytes[3] := $13;

  Result := FHash.GetHMACAsBytes('data', 'data', SHA256);
  CheckEquals(HASH_SHA256_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_1) do
    CheckEquals(TEST_BYTES_RESULT_1[i], Result[i]);

  Result := FHash.GetHMACAsBytes(TestBytes, 'data', SHA256);
  CheckEquals(HASH_SHA256_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_2) do
    CheckEquals(TEST_BYTES_RESULT_2[i], Result[i]);

  Result := FHash.GetHMACAsBytes('data', TestBytes, SHA256);
  CheckEquals(HASH_SHA256_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_3) do
    CheckEquals(TEST_BYTES_RESULT_3[i], Result[i]);

  Result := FHash.GetHMACAsBytes(TestBytes, TestBytes, SHA256);
  CheckEquals(HASH_SHA256_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_4) do
    CheckEquals(TEST_BYTES_RESULT_4[i], Result[i]);

  { big }
  SetLength(TestBytes, 4096);
  for i := Low(TestBytes) to High(TestBytes) do
    TestBytes[i] := i + 1;
  Result := FHash.GetHMACAsBytes(TestBytes, TestBytes, SHA256);
  CheckEquals(HASH_SHA256_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_5) do
    CheckEquals(TEST_BYTES_RESULT_5[i], Result[i]);
end;

procedure TTestTHashSHA2_256.TestDefaults;
var
  Hash: THashSHA2;
  TestBytes, Result: TBytes;
  i: Integer;
begin
  Hash := THashSHA2.Create;
  CheckTrue(Hash.FVersion = SHA256);

  CheckEquals(
    'da00b1613c2cdf79cd47ddc2f36fc5e9804979b8315ac3fa0d899d35ef5e1afd',
    FHash.GetHashString(TEST_STR_UNICODE)
  );

  Result := FHash.GetHashBytes(TEST_STR_UNICODE);
  CheckEquals(HASH_SHA256_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT) do
    CheckEquals(TEST_BYTES_RESULT[i], Result[i]);

  CheckEquals(
    'b613679a0814d9ec772f95d778c35fc5ff1697c493715653c6c712144292c5ad',
    FHash.GetHMAC('', '')
  );


  SetLength(TestBytes, 4);
  TestBytes[0] := $10; TestBytes[1] := $11; TestBytes[2] := $12; TestBytes[3] := $13;

  Result := FHash.GetHMACAsBytes('data', 'data');
  CheckEquals(HASH_SHA256_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_1) do
    CheckEquals(TEST_BYTES_RESULT_1[i], Result[i]);

  Result := FHash.GetHMACAsBytes(TestBytes, 'data');
  CheckEquals(HASH_SHA256_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_2) do
    CheckEquals(TEST_BYTES_RESULT_2[i], Result[i]);

  Result := FHash.GetHMACAsBytes('data', TestBytes);
  CheckEquals(HASH_SHA256_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_3) do
    CheckEquals(TEST_BYTES_RESULT_3[i], Result[i]);

  Result := FHash.GetHMACAsBytes(TestBytes, TestBytes);
  CheckEquals(HASH_SHA256_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_4) do
    CheckEquals(TEST_BYTES_RESULT_4[i], Result[i]);
end; *)

initialization
//  RegisterTest('System.Hash', TTestTHashSHA2_256.Suite);

end.

