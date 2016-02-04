{**********************************************************************
    Copyright(c) 2016 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit Test.System.Hash.THashSHA2_512;

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
  TTestTHashSHA2_512 = class(TTestCase)
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

{ TTestTHashSHA2_512 }

const
  HASH_SHA512_SIZE = 64;
  HASH_SHA512_BLOCK_SIZE = 128;
  HASH_SHA512_EMPTY = 'cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e';
  {$IFDEF FPC}
  TEST_STR_ANSI: AnsiString = 'The quick brown fox jumps over the lazy dog';
  {$ENDIF FPC}
  TEST_STR_UNICODE: UnicodeString = '支持楼主，不怕当小白鼠';
  TEST_BYTES_RESULT: array [0..HASH_SHA512_SIZE - 1] of Byte = (
    $ee, $9f, $74, $bd, $e6, $5c, $b4, $96, $68, $e1, $10, $90, $f4, $c3, $93, $ba,
    $8d, $8e, $2e, $eb, $c7, $ca, $63, $6c, $0c, $17, $b6, $96, $03, $39, $b8, $22,
    $65, $b5, $7e, $4a, $a4, $10, $54, $b5, $7e, $61, $8f, $46, $6d, $ba, $30, $8b,
    $56, $68, $70, $a3, $83, $2d, $ae, $2d, $dd, $27, $b5, $ea, $ec, $ee, $fb, $b3
  );

procedure TTestTHashSHA2_512.SetUp;
begin
  FHash := THashSHA2.Create(SHA512);
end;

procedure TTestTHashSHA2_512.TearDown;
begin
  { We have to finalize record manually because fpcunit never frees TTestCase
    so our record never never runs out of scope. }
  Finalize(FHash);
end;

{$IFDEF CLOSER_TO_DELPHI}
procedure TTestTHashSHA2_512.TestCreate;
begin
  CheckTrue(FHash.FVersion = SHA512);
end;
{$ENDIF CLOSER_TO_DELPHI}

procedure TTestTHashSHA2_512.TestGetBlockSize;
begin
  CheckEquals(HASH_SHA512_BLOCK_SIZE, FHash.GetBlockSize);
end;

procedure TTestTHashSHA2_512.TestGetHashSize;
begin
  CheckEquals(HASH_SHA512_SIZE, FHash.GetHashSize);
end;

procedure TTestTHashSHA2_512.TestReset;
begin
  CheckEquals(HASH_SHA512_EMPTY, FHash.HashAsString);

  FHash.Reset;
  CheckEquals(HASH_SHA512_EMPTY, FHash.HashAsString);

  FHash.Reset;
  CheckEquals(HASH_SHA512_EMPTY, FHash.HashAsString);
end;

procedure TTestTHashSHA2_512.FailResetRaw;
const
  TEST_VAL: Cardinal = $01020304;
begin
  FHash.Update(TEST_VAL, SizeOf(TEST_VAL));
end;

procedure TTestTHashSHA2_512.TestResetRaw;
const
  TEST_VAL: Cardinal = $01020304;
begin
  FHash.Update(TEST_VAL, SizeOf(TEST_VAL));
  FHash.Reset;
  CheckEquals(HASH_SHA512_EMPTY, FHash.HashAsString);

  CheckException(FailResetRaw, EHashException);
end;

procedure TTestTHashSHA2_512.FailResetTBytes;
var
  TestBytes: TBytes;
begin
  SetLength(TestBytes, 0);
  FHash.Update(TestBytes);
end;

procedure TTestTHashSHA2_512.TestResetTBytes;
var
  TestBytes: TBytes;
begin
  SetLength(TestBytes, 2);
  TestBytes[0] := 5; TestBytes[1] := 6;
  FHash.Update(TestBytes);
  FHash.Reset;
  CheckEquals(HASH_SHA512_EMPTY, FHash.HashAsString);

  CheckException(FailResetTBytes, EHashException);
end;

procedure TTestTHashSHA2_512.FailResetString;
begin
  FHash.Update('BlahBlahBlah');
end;

procedure TTestTHashSHA2_512.TestResetString;
begin
  FHash.Update('BlahBlahBlah');
  FHash.Reset;
  CheckEquals(HASH_SHA512_EMPTY, FHash.HashAsString);

  CheckException(FailResetString, EHashException);
end;

procedure TTestTHashSHA2_512.TestHashAsString;
begin
  FHash.Update(TEST_STR_UNICODE);
  CheckEquals(
    'ee9f74bde65cb49668e11090f4c393ba8d8e2eebc7ca636c0c17b6960339b82265b57e4aa41054b57e618f466dba308b566870a3832dae2ddd27b5eaeceefbb3',
    FHash.HashAsString
  );
  { Ready hash value must be available more than once }
  CheckEquals(
    'ee9f74bde65cb49668e11090f4c393ba8d8e2eebc7ca636c0c17b6960339b82265b57e4aa41054b57e618f466dba308b566870a3832dae2ddd27b5eaeceefbb3',
    FHash.HashAsString
  );
end;

procedure TTestTHashSHA2_512.TestHashAsBytes;
var
  Result: TBytes;
  i: Integer;
begin
  FHash.Update(TEST_STR_UNICODE);
  Result := FHash.HashAsBytes;
  CheckEquals(HASH_SHA512_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT) do
    CheckEquals(TEST_BYTES_RESULT[i], Result[i]);
end;

{$IFDEF FPC}
procedure TTestTHashSHA2_512.TestGetHashStringAnsi;
begin
  CheckEquals(
    '07e547d9586f6a73f73fbac0435ed76951218fb7d0c8d788a309d785436bbb642e93a252a954f23912547d1e8a3b5ed6e1bfd7097821233fa0538f3db854fee6',
    FHash.GetHashString(TEST_STR_ANSI, SHA512)
  );
end;
{$ENDIF FPC}

procedure TTestTHashSHA2_512.TestGetHashStringUnicode;
begin
  CheckEquals(
    'ee9f74bde65cb49668e11090f4c393ba8d8e2eebc7ca636c0c17b6960339b82265b57e4aa41054b57e618f466dba308b566870a3832dae2ddd27b5eaeceefbb3',
    FHash.GetHashString(TEST_STR_UNICODE, SHA512)
  );
end;

procedure TTestTHashSHA2_512.TestGetHashBytes;
var
  Result: TBytes;
  i: Integer;
begin
  Result := FHash.GetHashBytes(TEST_STR_UNICODE, SHA512);
  CheckEquals(HASH_SHA512_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT) do
    CheckEquals(TEST_BYTES_RESULT[i], Result[i]);
end;

procedure TTestTHashSHA2_512.TestUpdateRaw;
var
  TestVal1, TestVal2: Cardinal;
begin
  TestVal1 := THash.ToBigEndian(Cardinal($01020304));
  TestVal2 := THash.ToBigEndian(Cardinal($05060708));

  FHash.Update(TestVal1, SizeOf(TestVal1));
  FHash.Update(TestVal2, SizeOf(TestVal2));
  CheckEquals(
    '1818cc2acd207880a07afc360fd0da87e51ccf17e7c604c4eb16be5788322724c298e1fcc66eb293926993141ef0863c09eda383188cf5df49b910aacac17ec5',
    FHash.HashAsString
  );
end;

procedure TTestTHashSHA2_512.TestUpdateRawZero;
const
  TEST_VAL: Cardinal = $01020304;
begin
  FHash.Update(TEST_VAL, 0);
  CheckEquals(HASH_SHA512_EMPTY, FHash.HashAsString);
end;

procedure TTestTHashSHA2_512.TestUpdateTBytes;
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
    'f1f419fe52dc41a8d4c9d3c69340b283bdff0076e4d0628e995750b2438fc2ee862b3e2e76396cd670e5e785511f9183c14401581c288c8e3d07e45432b24c38',
    FHash.HashAsString
  );
end;

procedure TTestTHashSHA2_512.TestUpdateTBytesHalf;
var
  TestBytes: TBytes;
begin
  SetLength(TestBytes, 4);
  TestBytes[0] := $10; TestBytes[1] := $11; TestBytes[2] := $12; TestBytes[3] := $13;

  FHash.Update(TestBytes, 2);
  CheckEquals(
    '4e4a3fbfc0ed4108e3a0ea3665687a6b8cc101486c0866569b0af2a4f9ea6ab703eb0074b20690664a25f32aa243a6b9287d9e6396a41bfa0119015af5fd9cd5',
    FHash.HashAsString
  );
end;

procedure TTestTHashSHA2_512.TestUpdateTBytesZero;
var
  TestBytes: TBytes;
begin
  SetLength(TestBytes, 4);
  TestBytes[0] := $10; TestBytes[1] := $11; TestBytes[2] := $12; TestBytes[3] := $13;

  FHash.Update(TestBytes, 0);
  CheckEquals(
    'f1f419fe52dc41a8d4c9d3c69340b283bdff0076e4d0628e995750b2438fc2ee862b3e2e76396cd670e5e785511f9183c14401581c288c8e3d07e45432b24c38',
    FHash.HashAsString
  );
end;


{$IFDEF FPC}
procedure TTestTHashSHA2_512.TestUpdateAnsiString;
begin
  FHash.Update(AnsiString('The quick brown fox '));
  FHash.Update(AnsiString('jumps over the lazy dog'));
  CheckEquals(
    '07e547d9586f6a73f73fbac0435ed76951218fb7d0c8d788a309d785436bbb642e93a252a954f23912547d1e8a3b5ed6e1bfd7097821233fa0538f3db854fee6',
    FHash.HashAsString
  );
end;
{$ENDIF FPC}

procedure TTestTHashSHA2_512.TestUpdateUnicodeString;
begin
  FHash.Update(UnicodeString('支持楼主，'));
  FHash.Update(UnicodeString('不怕当小白鼠'));
  CheckEquals(
    'ee9f74bde65cb49668e11090f4c393ba8d8e2eebc7ca636c0c17b6960339b82265b57e4aa41054b57e618f466dba308b566870a3832dae2ddd27b5eaeceefbb3',
    FHash.HashAsString
  );
end;

(* procedure TTestTHashSHA2_512.TestGetHMAC;
begin
  CheckEquals(
    '239b9209e9e19d2dd35e33af90b63e3e6c156436238393c7d2a58adb754fa7d727eba0517cff4b62074cd27523a42c56c067b8047b3bd9b09940e94fcea7f960',
    FHash.GetHMAC('password', 'key', SHA512)
  );
  CheckEquals(
    'b936cee86c9f87aa5d3c6f2e84cb5a4239a5fe50480a6ec66b70ab5b1f4ac6730c6c515421b327ec1d69402e53dfb49ad7381eb067b338fd7b0cb22247225d47',
    FHash.GetHMAC('', '', SHA512)
  );
end;

procedure TTestTHashSHA2_512.TestGetHMACAsBytes;
const
  TEST_BYTES_RESULT_1: array [0..HASH_SHA512_SIZE - 1] of Byte = (
    $68, $be, $72, $14, $90, $96, $11, $82, $d3, $db, $26, $44, $09, $08, $a9, $1c,
    $1b, $23, $24, $53, $b4, $88, $64, $60, $84, $34, $6e, $a8, $c2, $7d, $c5, $f1,
    $79, $c4, $9f, $72, $e5, $78, $37, $23, $4c, $3e, $1f, $86, $56, $b3, $65, $cf,
    $ee, $a4, $51, $01, $90, $72, $f6, $30, $a2, $f1, $56, $d6, $ab, $a1, $3c, $b5
  );
  TEST_BYTES_RESULT_2: array [0..HASH_SHA512_SIZE - 1] of Byte = (
    $2f, $dc, $66, $63, $ba, $3c, $2d, $c1, $4c, $2f, $42, $3a, $59, $d3, $c3, $ac,
    $c7, $ae, $c9, $1a, $20, $9a, $51, $27, $31, $50, $8b, $37, $ce, $a1, $39, $2d,
    $b0, $33, $f2, $a6, $c6, $8c, $25, $15, $3d, $f6, $c0, $69, $24, $f2, $32, $87,
    $05, $f3, $6a, $dd, $ac, $57, $94, $fb, $e5, $45, $86, $83, $78, $5f, $e8, $e9
  );
  TEST_BYTES_RESULT_3: array [0..HASH_SHA512_SIZE - 1] of Byte = (
    $a3, $f6, $77, $80, $5f, $c6, $ca, $9b, $5f, $36, $5e, $6b, $64, $ff, $0b, $cf,
    $5b, $dc, $71, $a3, $92, $50, $3e, $e3, $31, $00, $72, $ae, $4d, $69, $6a, $4d,
    $04, $9f, $d8, $8d, $24, $38, $95, $59, $81, $39, $e5, $92, $f0, $3a, $a9, $0b,
    $18, $7d, $f2, $0a, $89, $59, $2c, $14, $57, $83, $2a, $03, $02, $b0, $9c, $f3
  );
  TEST_BYTES_RESULT_4: array [0..HASH_SHA512_SIZE - 1] of Byte = (
    $e2, $97, $ed, $ca, $c0, $69, $f1, $f2, $af, $90, $f5, $83, $53, $5c, $5b, $1a,
    $88, $0d, $24, $a5, $b9, $a6, $4d, $8f, $5f, $e7, $2b, $74, $2d, $28, $cb, $4a,
    $ef, $db, $35, $f4, $30, $89, $51, $bd, $a8, $d1, $7d, $b6, $67, $14, $12, $36,
    $fd, $81, $5b, $11, $8b, $d4, $19, $9c, $36, $27, $c9, $42, $f2, $24, $6a, $c5
  );
  TEST_BYTES_RESULT_5: array [0..HASH_SHA512_SIZE - 1] of Byte = (
    $33, $2f, $a0, $bc, $9e, $77, $39, $93, $ec, $fe, $a4, $ae, $59, $ea, $45, $11,
    $95, $6d, $3f, $09, $5f, $f6, $a3, $b4, $51, $41, $58, $60, $cc, $c3, $cf, $4c,
    $91, $de, $ac, $19, $9c, $cf, $cc, $fb, $73, $36, $76, $9d, $ae, $62, $9e, $c3,
    $f5, $db, $84, $b5, $a9, $02, $11, $0d, $ad, $8b, $2b, $79, $0d, $7b, $d5, $43
  );
var
  TestBytes, Result: TBytes;
  i: Integer;
begin
  SetLength(TestBytes, 4);
  TestBytes[0] := $10; TestBytes[1] := $11; TestBytes[2] := $12; TestBytes[3] := $13;

  Result := FHash.GetHMACAsBytes('data', 'data', SHA512);
  CheckEquals(HASH_SHA512_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_1) do
    CheckEquals(TEST_BYTES_RESULT_1[i], Result[i]);

  Result := FHash.GetHMACAsBytes(TestBytes, 'data', SHA512);
  CheckEquals(HASH_SHA512_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_2) do
    CheckEquals(TEST_BYTES_RESULT_2[i], Result[i]);

  Result := FHash.GetHMACAsBytes('data', TestBytes, SHA512);
  CheckEquals(HASH_SHA512_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_3) do
    CheckEquals(TEST_BYTES_RESULT_3[i], Result[i]);

  Result := FHash.GetHMACAsBytes(TestBytes, TestBytes, SHA512);
  CheckEquals(HASH_SHA512_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_4) do
    CheckEquals(TEST_BYTES_RESULT_4[i], Result[i]);

  { big }
  SetLength(TestBytes, 4096);
  for i := Low(TestBytes) to High(TestBytes) do
    TestBytes[i] := i + 1;
  Result := FHash.GetHMACAsBytes(TestBytes, TestBytes, SHA512);
  CheckEquals(HASH_SHA512_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_5) do
    CheckEquals(TEST_BYTES_RESULT_5[i], Result[i]);
end; *)

initialization
  RegisterTest('System.Hash', TTestTHashSHA2_512.Suite);

end.

