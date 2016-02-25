{**********************************************************************
    Copyright(c) 2016 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit Test.System.Hash.THashSHA1;

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

{$IF DEFINED(FPC) OR DEFINED(DELPHI_XE8_PLUS)}
type
  TTestTHashSHA1 = class(TTestCase)
  strict private
    FHash: THashSHA1;
  private
    procedure FailResetRaw;
    procedure FailResetTBytes;
    procedure FailResetString;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
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

{$IF DEFINED(FPC) OR DEFINED(DELPHI_XE8_PLUS)}
{ TTestTHashSHA1 }

const
  HASH_SHA1_SIZE = 20;
  HASH_SHA1_BLOCK_SIZE = 64;
  HASH_SHA1_EMPTY = 'da39a3ee5e6b4b0d3255bfef95601890afd80709';
  {$IFDEF FPC}
  TEST_STR_ANSI: AnsiString = 'The quick brown fox jumps over the lazy dog';
  {$ENDIF FPC}
  TEST_STR_UNICODE: UnicodeString = '支持楼主，不怕当小白鼠';
  TEST_BYTES_RESULT: array [0..HASH_SHA1_SIZE - 1] of Byte = (
    $33, $a1, $58, $f3, $46, $a1, $92, $91, $65, $c4,
    $a3, $56, $1e, $9f, $a9, $a5, $9d, $16, $db, $bd
  );

procedure TTestTHashSHA1.SetUp;
begin
  FHash := THashSHA1.Create;
end;

procedure TTestTHashSHA1.TearDown;
begin
  {$IFDEF FPC}
  { We have to finalize record manually because fpcunit never frees TTestCase
    so our record never never runs out of scope. }
  Finalize(FHash);
  {$ENDIF FPC}
end;

procedure TTestTHashSHA1.TestGetBlockSize;
begin
  CheckEquals(HASH_SHA1_BLOCK_SIZE, FHash.GetBlockSize);
end;

procedure TTestTHashSHA1.TestGetHashSize;
begin
  CheckEquals(HASH_SHA1_SIZE, FHash.GetHashSize);
end;

procedure TTestTHashSHA1.TestReset;
begin
  CheckEquals(HASH_SHA1_EMPTY, FHash.HashAsString);

  FHash.Reset;
  CheckEquals(HASH_SHA1_EMPTY, FHash.HashAsString);

  FHash.Reset;
  CheckEquals(HASH_SHA1_EMPTY, FHash.HashAsString);
end;

procedure TTestTHashSHA1.FailResetRaw;
const
  TEST_VAL: Cardinal = $01020304;
begin
  FHash.Update(TEST_VAL, SizeOf(TEST_VAL));
end;

procedure TTestTHashSHA1.TestResetRaw;
const
  TEST_VAL: Cardinal = $01020304;
begin
  FHash.Update(TEST_VAL, SizeOf(TEST_VAL));
  FHash.Reset;
  CheckEquals(HASH_SHA1_EMPTY, FHash.HashAsString);

  CheckException(FailResetRaw, EHashException);
end;

procedure TTestTHashSHA1.FailResetTBytes;
var
  TestBytes: TBytes;
begin
  SetLength(TestBytes, 0);
  FHash.Update(TestBytes);
end;

procedure TTestTHashSHA1.TestResetTBytes;
var
  TestBytes: TBytes;
begin
  SetLength(TestBytes, 2);
  TestBytes[0] := 5; TestBytes[1] := 6;
  FHash.Update(TestBytes);
  FHash.Reset;
  CheckEquals(HASH_SHA1_EMPTY, FHash.HashAsString);

  CheckException(FailResetTBytes, EHashException);
end;

procedure TTestTHashSHA1.FailResetString;
begin
  FHash.Update('BlahBlahBlah');
end;

procedure TTestTHashSHA1.TestResetString;
begin
  FHash.Update('BlahBlahBlah');
  FHash.Reset;
  CheckEquals(HASH_SHA1_EMPTY, FHash.HashAsString);

  CheckException(FailResetString, EHashException);
end;

procedure TTestTHashSHA1.TestHashAsString;
begin
  FHash.Update(TEST_STR_UNICODE);
  CheckEquals('33a158f346a1929165c4a3561e9fa9a59d16dbbd', FHash.HashAsString);
  { Ready hash value must be available more than once }
  CheckEquals('33a158f346a1929165c4a3561e9fa9a59d16dbbd', FHash.HashAsString);
end;

procedure TTestTHashSHA1.TestHashAsBytes;
var
  Result: TBytes;
  i: Integer;
begin
  FHash.Update(TEST_STR_UNICODE);
  Result := FHash.HashAsBytes;
  CheckEquals(HASH_SHA1_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT) do
    CheckEquals(TEST_BYTES_RESULT[i], Result[i]);
end;

{$IFDEF FPC}
procedure TTestTHashSHA1.TestGetHashStringAnsi;
begin
  CheckEquals('2fd4e1c67a2d28fced849ee1bb76e7391b93eb12', FHash.GetHashString(TEST_STR_ANSI));
end;
{$ENDIF FPC}

procedure TTestTHashSHA1.TestGetHashStringUnicode;
begin
  CheckEquals('33a158f346a1929165c4a3561e9fa9a59d16dbbd', FHash.GetHashString(TEST_STR_UNICODE));
end;

procedure TTestTHashSHA1.TestGetHashBytes;
var
  Result: TBytes;
  i: Integer;
begin
  Result := FHash.GetHashBytes(TEST_STR_UNICODE);
  CheckEquals(HASH_SHA1_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT) do
    CheckEquals(TEST_BYTES_RESULT[i], Result[i]);
end;

procedure TTestTHashSHA1.TestUpdateRaw;
var
  TestVal1, TestVal2: Cardinal;
begin
  TestVal1 := THash.ToBigEndian(Cardinal($01020304));
  TestVal2 := THash.ToBigEndian(Cardinal($05060708));

  FHash.Update(TestVal1, SizeOf(TestVal1));
  FHash.Update(TestVal2, SizeOf(TestVal2));
  CheckEquals('dd5783bcf1e9002bc00ad5b83a95ed6e4ebb4ad5', FHash.HashAsString);
end;

procedure TTestTHashSHA1.TestUpdateRawZero;
const
  TEST_VAL: Cardinal = $01020304;
begin
  FHash.Update(TEST_VAL, 0);
  CheckEquals(HASH_SHA1_EMPTY, FHash.HashAsString);
end;

procedure TTestTHashSHA1.TestUpdateTBytes;
var
  TestBytes1, TestBytes2: TBytes;
begin
  SetLength(TestBytes1, 2);
  TestBytes1[0] := $10; TestBytes1[1] := $11;
  SetLength(TestBytes2, 2);
  TestBytes2[0] := $12; TestBytes2[1] := $13;

  FHash.Update(TestBytes1);
  FHash.Update(TestBytes2);
  CheckEquals('59caae0c86d6c437cb4115ccb359111e903214a5', FHash.HashAsString);
end;

procedure TTestTHashSHA1.TestUpdateTBytesHalf;
var
  TestBytes: TBytes;
begin
  SetLength(TestBytes, 4);
  TestBytes[0] := $10; TestBytes[1] := $11; TestBytes[2] := $12; TestBytes[3] := $13;

  FHash.Update(TestBytes, 2);
  CheckEquals('93cdc93f7933f0879b1b6e02881eb544af0506d7', FHash.HashAsString);
end;

procedure TTestTHashSHA1.TestUpdateTBytesZero;
var
  TestBytes: TBytes;
begin
  SetLength(TestBytes, 4);
  TestBytes[0] := $10; TestBytes[1] := $11; TestBytes[2] := $12; TestBytes[3] := $13;

  FHash.Update(TestBytes, 0);
  CheckEquals('59caae0c86d6c437cb4115ccb359111e903214a5', FHash.HashAsString);
end;

{$IFDEF FPC}
procedure TTestTHashSHA1.TestUpdateAnsiString;
begin
  FHash.Update(AnsiString('The quick brown fox '));
  FHash.Update(AnsiString('jumps over the lazy dog'));
  CheckEquals('2fd4e1c67a2d28fced849ee1bb76e7391b93eb12', FHash.HashAsString);
end;
{$ENDIF FPC}

procedure TTestTHashSHA1.TestUpdateUnicodeString;
begin
  FHash.Update(UnicodeString('支持楼主，'));
  FHash.Update(UnicodeString('不怕当小白鼠'));
  CheckEquals('33a158f346a1929165c4a3561e9fa9a59d16dbbd', FHash.HashAsString);
end;

{$IFDEF FPC}
procedure TTestTHashSHA1.TestGetHMACAnsi;
begin
  CheckEquals('fbdb1d1b18aa6c08324b7d64b71fb76370690e1d', FHash.GetHMAC(AnsiString(''), AnsiString('')));
  CheckEquals('de7c9b85b8b78aa6bc8a7a36f70a90701c9db4d9', FHash.GetHMAC(TEST_STR_ANSI, AnsiString('key')));
  CheckEquals('8bf981ea4d34b73571a36a1d8419bafb65f752be', FHash.GetHMAC(
    TEST_STR_ANSI,
    AnsiString('very____________________________________________________________long__________________________________________________________________key')
  ));
end;
{$ENDIF FPC}

procedure TTestTHashSHA1.TestGetHMACUnicode;
begin
  CheckEquals('fbdb1d1b18aa6c08324b7d64b71fb76370690e1d', FHash.GetHMAC(UnicodeString(''), UnicodeString('')));
  CheckEquals('8792dbada9e3cc9c34baefdad1c2150b2820a1b2', FHash.GetHMAC(TEST_STR_UNICODE, UnicodeString('key')));
end;

const
  TEST_BYTES_RESULT_1: array [0..HASH_SHA1_SIZE - 1] of Byte = (
    $15, $c7, $93, $07, $5e, $e7, $3b, $16, $e8, $1a,
    $78, $38, $a1, $20, $e0, $9e, $4e, $a1, $09, $9b
  );
  TEST_BYTES_RESULT_2: array [0..HASH_SHA1_SIZE - 1] of Byte = (
    $e7, $bd, $bd, $81, $4c, $c2, $7b, $a4, $f1, $29,
    $61, $51, $d3, $90, $af, $1e, $71, $d1, $95, $b7
  );
  TEST_BYTES_RESULT_3: array [0..HASH_SHA1_SIZE - 1] of Byte = (
    $1e, $af, $f9, $c2, $59, $27, $6f, $0e, $de, $50,
    $6d, $9a, $bd, $05, $83, $d9, $2d, $67, $62, $6c
  );
  TEST_BYTES_RESULT_4: array [0..HASH_SHA1_SIZE - 1] of Byte = (
    $c3, $61, $47, $e6, $8e, $72, $48, $e8, $b8, $fc,
    $ea, $98, $e8, $1a, $e0, $c4, $e5, $e5, $f6, $27
  );
  TEST_BYTES_RESULT_5: array [0..HASH_SHA1_SIZE - 1] of Byte = (
    $c2, $0a, $02, $c7, $fd, $ab, $ab, $2e, $e5, $d9,
    $34, $6e, $22, $92, $42, $4f, $f4, $a0, $07, $50
  );

{$IFDEF FPC}
procedure TTestTHashSHA1.TestGetHMACAsBytesAnsi;
var
  TestBytes, Result: TBytes;
  i: Integer;
begin
  SetLength(TestBytes, 4);
  TestBytes[0] := $10; TestBytes[1] := $11; TestBytes[2] := $12; TestBytes[3] := $13;

  Result := FHash.GetHMACAsBytes(AnsiString('data'), AnsiString('data'));
  CheckEquals(HASH_SHA1_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_1) do
    CheckEquals(TEST_BYTES_RESULT_1[i], Result[i]);

  Result := FHash.GetHMACAsBytes(TestBytes, AnsiString('data'));
  CheckEquals(HASH_SHA1_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_2) do
    CheckEquals(TEST_BYTES_RESULT_2[i], Result[i]);

  Result := FHash.GetHMACAsBytes(AnsiString('data'), TestBytes);
  CheckEquals(HASH_SHA1_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_3) do
    CheckEquals(TEST_BYTES_RESULT_3[i], Result[i]);

  Result := FHash.GetHMACAsBytes(TestBytes, TestBytes);
  CheckEquals(HASH_SHA1_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_4) do
    CheckEquals(TEST_BYTES_RESULT_4[i], Result[i]);
end;
{$ENDIF FPC}

procedure TTestTHashSHA1.TestGetHMACAsBytesUnicode;
var
  TestBytes, Result: TBytes;
  i: Integer;
begin
  SetLength(TestBytes, 4);
  TestBytes[0] := $10; TestBytes[1] := $11; TestBytes[2] := $12; TestBytes[3] := $13;

  Result := FHash.GetHMACAsBytes(UnicodeString('data'), UnicodeString('data'));
  CheckEquals(HASH_SHA1_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_1) do
    CheckEquals(TEST_BYTES_RESULT_1[i], Result[i]);

  Result := FHash.GetHMACAsBytes(TestBytes, UnicodeString('data'));
  CheckEquals(HASH_SHA1_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_2) do
    CheckEquals(TEST_BYTES_RESULT_2[i], Result[i]);

  Result := FHash.GetHMACAsBytes(UnicodeString('data'), TestBytes);
  CheckEquals(HASH_SHA1_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_3) do
    CheckEquals(TEST_BYTES_RESULT_3[i], Result[i]);

  Result := FHash.GetHMACAsBytes(TestBytes, TestBytes);
  CheckEquals(HASH_SHA1_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_4) do
    CheckEquals(TEST_BYTES_RESULT_4[i], Result[i]);

  { big }
  SetLength(TestBytes, 4096);
  for i := Low(TestBytes) to High(TestBytes) do
    TestBytes[i] := (i + 1) mod $ff;
  Result := FHash.GetHMACAsBytes(TestBytes, TestBytes);
  CheckEquals(HASH_SHA1_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_5) do
    CheckEquals(TEST_BYTES_RESULT_5[i], Result[i]);
end;

initialization
  RegisterTest('System.Hash', TTestTHashSHA1.Suite);
{$IFEND}

end.

