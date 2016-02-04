{**********************************************************************
    Copyright(c) 2016 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit Test.System.Hash.THashSHA2_384;

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
  TTestTHashSHA2_384 = class(TTestCase)
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
  end;

implementation

{ TTestTHashSHA2_384 }

const
  HASH_SHA384_SIZE = 48;
  HASH_SHA384_BLOCK_SIZE = 128;
  HASH_SHA384_EMPTY = '38b060a751ac96384cd9327eb1b1e36a21fdb71114be07434c0cc7bf63f6e1da274edebfe76f65fbd51ad2f14898b95b';
  {$IFDEF FPC}
  TEST_STR_ANSI: AnsiString = 'The quick brown fox jumps over the lazy dog';
  {$ENDIF FPC}
  TEST_STR_UNICODE: UnicodeString = '支持楼主，不怕当小白鼠';
  TEST_BYTES_RESULT: array [0..HASH_SHA384_SIZE - 1] of Byte = (
    $a0, $01, $2c, $59, $2d, $53, $04, $28, $e4, $46, $fb, $ee, $88, $9c, $b7, $ee,
    $a0, $44, $5f, $25, $86, $21, $ae, $18, $54, $11, $63, $da, $99, $73, $35, $0c,
    $90, $87, $99, $ea, $73, $e2, $d4, $3b, $50, $46, $36, $92, $5c, $16, $ea, $f2
  );

procedure TTestTHashSHA2_384.SetUp;
begin
  FHash := THashSHA2.Create(SHA384);
end;

procedure TTestTHashSHA2_384.TearDown;
begin
  { We have to finalize record manually because fpcunit never frees TTestCase
    so our record never never runs out of scope. }
  Finalize(FHash);
end;

{$IFDEF CLOSER_TO_DELPHI}
procedure TTestTHashSHA2_384.TestCreate;
begin
  CheckTrue(FHash.FVersion = SHA384);
end;
{$ENDIF CLOSER_TO_DELPHI}

procedure TTestTHashSHA2_384.TestGetBlockSize;
begin
  CheckEquals(HASH_SHA384_BLOCK_SIZE, FHash.GetBlockSize);
end;

procedure TTestTHashSHA2_384.TestGetHashSize;
begin
  CheckEquals(HASH_SHA384_SIZE, FHash.GetHashSize);
end;

procedure TTestTHashSHA2_384.TestReset;
begin
  CheckEquals(HASH_SHA384_EMPTY, FHash.HashAsString);

  FHash.Reset;
  CheckEquals(HASH_SHA384_EMPTY, FHash.HashAsString);

  FHash.Reset;
  CheckEquals(HASH_SHA384_EMPTY, FHash.HashAsString);
end;

procedure TTestTHashSHA2_384.FailResetRaw;
const
  TEST_VAL: Cardinal = $01020304;
begin
  FHash.Update(TEST_VAL, SizeOf(TEST_VAL));
end;

procedure TTestTHashSHA2_384.TestResetRaw;
const
  TEST_VAL: Cardinal = $01020304;
begin
  FHash.Update(TEST_VAL, SizeOf(TEST_VAL));
  FHash.Reset;
  CheckEquals(HASH_SHA384_EMPTY, FHash.HashAsString);

  CheckException(FailResetRaw, EHashException);
end;

procedure TTestTHashSHA2_384.FailResetTBytes;
var
  TestBytes: TBytes;
begin
  SetLength(TestBytes, 0);
  FHash.Update(TestBytes);
end;

procedure TTestTHashSHA2_384.TestResetTBytes;
var
  TestBytes: TBytes;
begin
  SetLength(TestBytes, 2);
  TestBytes[0] := 5; TestBytes[1] := 6;
  FHash.Update(TestBytes);
  FHash.Reset;
  CheckEquals(HASH_SHA384_EMPTY, FHash.HashAsString);

  CheckException(FailResetTBytes, EHashException);
end;

procedure TTestTHashSHA2_384.FailResetString;
begin
  FHash.Update('BlahBlahBlah');
end;

procedure TTestTHashSHA2_384.TestResetString;
begin
  FHash.Update('BlahBlahBlah');
  FHash.Reset;
  CheckEquals(HASH_SHA384_EMPTY, FHash.HashAsString);

  CheckException(FailResetString, EHashException);
end;

procedure TTestTHashSHA2_384.TestHashAsString;
begin
  FHash.Update(TEST_STR_UNICODE);
  CheckEquals(
    'a0012c592d530428e446fbee889cb7eea0445f258621ae18541163da9973350c908799ea73e2d43b504636925c16eaf2',
    FHash.HashAsString
  );
  { Ready hash value must be available more than once }
  CheckEquals(
    'a0012c592d530428e446fbee889cb7eea0445f258621ae18541163da9973350c908799ea73e2d43b504636925c16eaf2',
    FHash.HashAsString
  );
end;

procedure TTestTHashSHA2_384.TestHashAsBytes;
var
  Result: TBytes;
  i: Integer;
begin
  FHash.Update(TEST_STR_UNICODE);
  Result := FHash.HashAsBytes;
  CheckEquals(HASH_SHA384_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT) do
    CheckEquals(TEST_BYTES_RESULT[i], Result[i]);
end;

{$IFDEF FPC}
procedure TTestTHashSHA2_384.TestGetHashStringAnsi;
begin
  CheckEquals(
    'ca737f1014a48f4c0b6dd43cb177b0afd9e5169367544c494011e3317dbf9a509cb1e5dc1e85a941bbee3d7f2afbc9b1',
    FHash.GetHashString(TEST_STR_ANSI, SHA384)
  );
end;
{$ENDIF FPC}

procedure TTestTHashSHA2_384.TestGetHashStringUnicode;
begin
  CheckEquals(
    'a0012c592d530428e446fbee889cb7eea0445f258621ae18541163da9973350c908799ea73e2d43b504636925c16eaf2',
    FHash.GetHashString(TEST_STR_UNICODE, SHA384)
  );
end;

procedure TTestTHashSHA2_384.TestGetHashBytes;
var
  Result: TBytes;
  i: Integer;
begin
  Result := FHash.GetHashBytes(TEST_STR_UNICODE, SHA384);
  CheckEquals(HASH_SHA384_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT) do
    CheckEquals(TEST_BYTES_RESULT[i], Result[i]);
end;

procedure TTestTHashSHA2_384.TestUpdateRaw;
var
  TestVal1, TestVal2: Cardinal;
begin
  TestVal1 := THash.ToBigEndian(Cardinal($01020304));
  TestVal2 := THash.ToBigEndian(Cardinal($05060708));

  FHash.Update(TestVal1, SizeOf(TestVal1));
  FHash.Update(TestVal2, SizeOf(TestVal2));
  CheckEquals(
    '9b110bbc741bb66ac09ed8e066e348990c5dbdb7406a2bdf8d77167364820e06b5c78b53f82015a7887786628374e6ae',
    FHash.HashAsString
  );
end;

procedure TTestTHashSHA2_384.TestUpdateRawZero;
const
  TEST_VAL: Cardinal = $01020304;
begin
  FHash.Update(TEST_VAL, 0);
  CheckEquals(HASH_SHA384_EMPTY, FHash.HashAsString);
end;

procedure TTestTHashSHA2_384.TestUpdateTBytes;
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
    '6fa3ca277e8f568528c5cda4621b542531eb8d6148866f2748ca1d77810a7460ac7ba4417fc3595a2ff0dd98e5eb18bd',
    FHash.HashAsString
  );
end;

procedure TTestTHashSHA2_384.TestUpdateTBytesHalf;
var
  TestBytes: TBytes;
begin
  SetLength(TestBytes, 4);
  TestBytes[0] := $10; TestBytes[1] := $11; TestBytes[2] := $12; TestBytes[3] := $13;

  FHash.Update(TestBytes, 2);
  CheckEquals(
    'd389ea1554548643255a174177fad762f7483e3703e34cdda0b8d30ebb3744da8a8751ea70739da69370c10e459e21a7',
    FHash.HashAsString
  );
end;

procedure TTestTHashSHA2_384.TestUpdateTBytesZero;
var
  TestBytes: TBytes;
begin
  SetLength(TestBytes, 4);
  TestBytes[0] := $10; TestBytes[1] := $11; TestBytes[2] := $12; TestBytes[3] := $13;

  FHash.Update(TestBytes, 0);
  CheckEquals(
    '6fa3ca277e8f568528c5cda4621b542531eb8d6148866f2748ca1d77810a7460ac7ba4417fc3595a2ff0dd98e5eb18bd',
    FHash.HashAsString
  );
end;

{$IFDEF FPC}
procedure TTestTHashSHA2_384.TestUpdateAnsiString;
begin
  FHash.Update(AnsiString('The quick brown fox '));
  FHash.Update(AnsiString('jumps over the lazy dog'));
  CheckEquals(
    'ca737f1014a48f4c0b6dd43cb177b0afd9e5169367544c494011e3317dbf9a509cb1e5dc1e85a941bbee3d7f2afbc9b1',
    FHash.HashAsString
  );
end;
{$ENDIF FPC}

procedure TTestTHashSHA2_384.TestUpdateUnicodeString;
begin
  FHash.Update(UnicodeString('支持楼主，'));
  FHash.Update(UnicodeString('不怕当小白鼠'));
  CheckEquals(
    'a0012c592d530428e446fbee889cb7eea0445f258621ae18541163da9973350c908799ea73e2d43b504636925c16eaf2',
    FHash.HashAsString
  );
end;

(* procedure TTestTHashSHA2_384.TestGetHMAC;
begin
  CheckEquals(
    '2080378aab16d0fbb96fac09c4a676339b35318e6d17c79d6b5e46e641f6071794cfc93d024a2f4279b441b785c286bd',
    FHash.GetHMAC('password', 'key', SHA384)
  );
  CheckEquals(
    '6c1f2ee938fad2e24bd91298474382ca218c75db3d83e114b3d4367776d14d3551289e75e8209cd4b792302840234adc',
    FHash.GetHMAC('', '', SHA384)
  );
end;

procedure TTestTHashSHA2_384.TestGetHMACAsBytes;
const
  TEST_BYTES_RESULT_1: array [0..HASH_SHA384_SIZE - 1] of Byte = (
    $a9, $a1, $bc, $1a, $b8, $4c, $40, $9d, $48, $f2, $3f, $82, $28, $aa, $1c, $b1,
    $62, $fb, $1e, $a2, $50, $6b, $71, $08, $1d, $7c, $34, $c9, $70, $03, $f8, $f7,
    $a7, $b1, $bd, $ba, $19, $17, $b1, $6a, $44, $21, $a3, $db, $2d, $38, $0e, $e5
  );
  TEST_BYTES_RESULT_2: array [0..HASH_SHA384_SIZE - 1] of Byte = (
    $15, $cc, $39, $05, $63, $33, $b4, $1f, $dd, $b3, $75, $8f, $ee, $1c, $a8, $c2,
    $7e, $e3, $2a, $a4, $d7, $b7, $7c, $22, $9c, $04, $22, $b3, $9b, $18, $f3, $ab,
    $5b, $32, $34, $73, $8f, $c9, $8d, $4e, $f2, $6d, $9a, $4d, $21, $ad, $3c, $0c
  );
  TEST_BYTES_RESULT_3: array [0..HASH_SHA384_SIZE - 1] of Byte = (
    $9d, $3e, $1a, $6f, $f7, $68, $fd, $f7, $a2, $51, $cd, $9a, $77, $fc, $a6, $e4,
    $bc, $92, $5e, $f8, $10, $0d, $35, $ee, $e4, $2b, $0b, $39, $b2, $a4, $30, $e1,
    $9f, $65, $8b, $30, $96, $2e, $7f, $75, $62, $1e, $4d, $b0, $12, $fc, $8f, $95
  );
  TEST_BYTES_RESULT_4: array [0..HASH_SHA384_SIZE - 1] of Byte = (
    $28, $dc, $07, $ea, $e7, $d4, $e7, $af, $56, $fa, $5b, $e8, $43, $24, $de, $45,
    $ff, $3e, $9d, $81, $ce, $5e, $33, $89, $61, $b6, $db, $b1, $6b, $21, $39, $e3,
    $66, $17, $35, $d0, $3f, $c4, $14, $da, $99, $cc, $2f, $c0, $68, $ac, $2e, $94
  );
  TEST_BYTES_RESULT_5: array [0..HASH_SHA384_SIZE - 1] of Byte = (
    $2c, $f9, $63, $f9, $56, $94, $46, $a0, $74, $40, $82, $cf, $71, $a8, $4d, $4e,
    $6c, $cb, $09, $64, $25, $52, $3e, $e2, $c6, $1c, $79, $d8, $e8, $1c, $d4, $9a,
    $0e, $88, $ad, $5a, $01, $f6, $01, $8e, $b9, $3b, $cb, $75, $13, $e8, $57, $2d
  );
var
  TestBytes, Result: TBytes;
  i: Integer;
begin
  SetLength(TestBytes, 4);
  TestBytes[0] := $10; TestBytes[1] := $11; TestBytes[2] := $12; TestBytes[3] := $13;

  Result := FHash.GetHMACAsBytes('data', 'data', SHA384);
  CheckEquals(HASH_SHA384_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_1) do
    CheckEquals(TEST_BYTES_RESULT_1[i], Result[i]);

  Result := FHash.GetHMACAsBytes(TestBytes, 'data', SHA384);
  CheckEquals(HASH_SHA384_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_2) do
    CheckEquals(TEST_BYTES_RESULT_2[i], Result[i]);

  Result := FHash.GetHMACAsBytes('data', TestBytes, SHA384);
  CheckEquals(HASH_SHA384_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_3) do
    CheckEquals(TEST_BYTES_RESULT_3[i], Result[i]);

  Result := FHash.GetHMACAsBytes(TestBytes, TestBytes, SHA384);
  CheckEquals(HASH_SHA384_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_4) do
    CheckEquals(TEST_BYTES_RESULT_4[i], Result[i]);

  { big }
  SetLength(TestBytes, 4096);
  for i := Low(TestBytes) to High(TestBytes) do
    TestBytes[i] := i + 1;
  Result := FHash.GetHMACAsBytes(TestBytes, TestBytes, SHA384);
  CheckEquals(HASH_SHA384_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_5) do
    CheckEquals(TEST_BYTES_RESULT_5[i], Result[i]);
end; *)

initialization
//  RegisterTest('System.Hash', TTestTHashSHA2_384.Suite);

end.

