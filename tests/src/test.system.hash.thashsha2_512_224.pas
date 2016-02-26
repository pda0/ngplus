{**********************************************************************
    Copyright(c) 2016 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit Test.System.Hash.THashSHA2_512_224;

{$I delphi.inc}
{$IFDEF DELPHI_XE4_PLUS}{$LEGACYIFEND ON}{$ENDIF}
{$I ngplus.inc}

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
  TTestTHashSHA2_512_224 = class(TTestCase)
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
{ TTestTHashSHA2_512_224 }

const
  HASH_SHA512_224_SIZE = 28;
  HASH_SHA512_224_BLOCK_SIZE = 128;
  HASH_SHA512_224_EMPTY = '6ed0dd02806fa89e25de060c19d3ac86cabb87d6a0ddd05c333b84f4';
  {$IFDEF FPC}
  TEST_STR_ANSI: AnsiString = 'The quick brown fox jumps over the lazy dog';
  {$ENDIF FPC}
  TEST_STR_UNICODE: UnicodeString = '支持楼主，不怕当小白鼠';
  TEST_BYTES_RESULT: array [0..HASH_SHA512_224_SIZE - 1] of Byte = (
    $39, $5d, $5a, $64, $08, $e4, $eb, $e5, $69, $6e, $5c, $ed, $2c, $11,
    $fa, $eb, $f9, $05, $99, $aa, $52, $db, $81, $1c, $64, $c9, $fd, $a6
  );

procedure TTestTHashSHA2_512_224.SetUp;
begin
  FHash := THashSHA2.Create(SHA512_224);
end;

procedure TTestTHashSHA2_512_224.TearDown;
begin
  {$IFDEF FPC}
  { We have to finalize record manually because fpcunit never frees TTestCase
    so our record never never runs out of scope. }
  Finalize(FHash);
  {$ENDIF FPC}
end;

{$IFDEF CLOSER_TO_DELPHI}
procedure TTestTHashSHA2_512_224.TestCreate;
begin
  CheckTrue(FHash.FVersion = SHA512_224);
end;
{$ENDIF CLOSER_TO_DELPHI}

procedure TTestTHashSHA2_512_224.TestGetBlockSize;
begin
  CheckEquals(HASH_SHA512_224_BLOCK_SIZE, FHash.GetBlockSize);
end;

procedure TTestTHashSHA2_512_224.TestGetHashSize;
begin
  CheckEquals(HASH_SHA512_224_SIZE, FHash.GetHashSize);
end;

procedure TTestTHashSHA2_512_224.TestReset;
begin
  CheckEquals(HASH_SHA512_224_EMPTY, FHash.HashAsString);

  FHash.Reset;
  CheckEquals(HASH_SHA512_224_EMPTY, FHash.HashAsString);

  FHash.Reset;
  CheckEquals(HASH_SHA512_224_EMPTY, FHash.HashAsString);
end;

procedure TTestTHashSHA2_512_224.FailResetRaw;
const
  TEST_VAL: Cardinal = $01020304;
begin
  FHash.Update(TEST_VAL, SizeOf(TEST_VAL));
end;

procedure TTestTHashSHA2_512_224.TestResetRaw;
const
  TEST_VAL: Cardinal = $01020304;
begin
  FHash.Update(TEST_VAL, SizeOf(TEST_VAL));
  FHash.Reset;
  CheckEquals(HASH_SHA512_224_EMPTY, FHash.HashAsString);

  CheckException(FailResetRaw, EHashException);
end;

procedure TTestTHashSHA2_512_224.FailResetTBytes;
var
  TestBytes: TBytes;
begin
  SetLength(TestBytes, 0);
  FHash.Update(TestBytes);
end;

procedure TTestTHashSHA2_512_224.TestResetTBytes;
var
  TestBytes: TBytes;
begin
  SetLength(TestBytes, 2);
  TestBytes[0] := 5; TestBytes[1] := 6;
  FHash.Update(TestBytes);
  FHash.Reset;
  CheckEquals(HASH_SHA512_224_EMPTY, FHash.HashAsString);

  CheckException(FailResetTBytes, EHashException);
end;

procedure TTestTHashSHA2_512_224.FailResetString;
begin
  FHash.Update('BlahBlahBlah');
end;

procedure TTestTHashSHA2_512_224.TestResetString;
begin
  FHash.Update('BlahBlahBlah');
  FHash.Reset;
  CheckEquals(HASH_SHA512_224_EMPTY, FHash.HashAsString);

  CheckException(FailResetString, EHashException);
end;

procedure TTestTHashSHA2_512_224.TestHashAsString;
begin
  FHash.Update(TEST_STR_UNICODE);
  CheckEquals(
    '395d5a6408e4ebe5696e5ced2c11faebf90599aa52db811c64c9fda6',
    FHash.HashAsString
  );
  { Ready hash value must be available more than once }
  CheckEquals(
    '395d5a6408e4ebe5696e5ced2c11faebf90599aa52db811c64c9fda6',
    FHash.HashAsString
  );
end;

procedure TTestTHashSHA2_512_224.TestHashAsBytes;
var
  Result: TBytes;
  i: Integer;
begin
  FHash.Update(TEST_STR_UNICODE);
  Result := FHash.HashAsBytes;
  CheckEquals(HASH_SHA512_224_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT) do
    CheckEquals(TEST_BYTES_RESULT[i], Result[i]);
end;

{$IFDEF FPC}
procedure TTestTHashSHA2_512_224.TestGetHashStringAnsi;
begin
  CheckEquals(
    '944cd2847fb54558d4775db0485a50003111c8e5daa63fe722c6aa37',
    FHash.GetHashString(TEST_STR_ANSI, SHA512_224)
  );
end;
{$ENDIF FPC}

procedure TTestTHashSHA2_512_224.TestGetHashStringUnicode;
begin
  CheckEquals(
    '395d5a6408e4ebe5696e5ced2c11faebf90599aa52db811c64c9fda6',
    FHash.GetHashString(TEST_STR_UNICODE, SHA512_224)
  );
end;

procedure TTestTHashSHA2_512_224.TestGetHashBytes;
var
  Result: TBytes;
  i: Integer;
begin
  Result := FHash.GetHashBytes(TEST_STR_UNICODE, SHA512_224);
  CheckEquals(HASH_SHA512_224_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT) do
    CheckEquals(TEST_BYTES_RESULT[i], Result[i]);
end;

procedure TTestTHashSHA2_512_224.TestUpdateRaw;
var
  TestVal1, TestVal2: Cardinal;
begin
  TestVal1 := THash.ToBigEndian(Cardinal($01020304));
  TestVal2 := THash.ToBigEndian(Cardinal($05060708));

  FHash.Update(TestVal1, SizeOf(TestVal1));
  FHash.Update(TestVal2, SizeOf(TestVal2));
  CheckEquals(
    '3459b5c5dce30de31b55a6095eed9486d74402d6f36a2129701dac60',
    FHash.HashAsString
  );
end;

procedure TTestTHashSHA2_512_224.TestUpdateRawZero;
const
  TEST_VAL: Cardinal = $01020304;
begin
  FHash.Update(TEST_VAL, 0);
  CheckEquals(HASH_SHA512_224_EMPTY, FHash.HashAsString);
end;

procedure TTestTHashSHA2_512_224.TestUpdateTBytes;
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
    '1e7edb760d065e727f4c93c363e5e81f700d7ae7d28e2cecc4fa9690',
    FHash.HashAsString
  );
end;

procedure TTestTHashSHA2_512_224.TestUpdateTBytesHalf;
var
  TestBytes: TBytes;
begin
  SetLength(TestBytes, 4);
  TestBytes[0] := $10; TestBytes[1] := $11; TestBytes[2] := $12; TestBytes[3] := $13;

  FHash.Update(TestBytes, 2);
  CheckEquals(
    'e13bf9337fb0636b4a00668e4e4532f87f41e54b88779e76c136c52b',
    FHash.HashAsString
  );
end;

procedure TTestTHashSHA2_512_224.TestUpdateTBytesZero;
var
  TestBytes: TBytes;
begin
  SetLength(TestBytes, 4);
  TestBytes[0] := $10; TestBytes[1] := $11; TestBytes[2] := $12; TestBytes[3] := $13;

  FHash.Update(TestBytes, 0);
  CheckEquals(
    '1e7edb760d065e727f4c93c363e5e81f700d7ae7d28e2cecc4fa9690',
    FHash.HashAsString
  );
end;

{$IFDEF FPC}
procedure TTestTHashSHA2_512_224.TestUpdateAnsiString;
begin
  FHash.Update(AnsiString('The quick brown fox '));
  FHash.Update(AnsiString('jumps over the lazy dog'));
  CheckEquals(
    '944cd2847fb54558d4775db0485a50003111c8e5daa63fe722c6aa37',
    FHash.HashAsString
  );
end;
{$ENDIF FPC}

procedure TTestTHashSHA2_512_224.TestUpdateUnicodeString;
begin
  FHash.Update(UnicodeString('支持楼主，'));
  FHash.Update(UnicodeString('不怕当小白鼠'));
  CheckEquals(
    '395d5a6408e4ebe5696e5ced2c11faebf90599aa52db811c64c9fda6',
    FHash.HashAsString
  );
end;

{$IFDEF FPC}
procedure TTestTHashSHA2_512_224.TestGetHMACAnsi;
begin
  CheckEquals(
    'de43f6b96f2d08cebe1ee9c02c53d96b68c1e55b6c15d6843b410d4c',
    FHash.GetHMAC(AnsiString(''), AnsiString(''), SHA512_224)
  );
  CheckEquals(
    'a1afb4f708cb63570639195121785ada3dc615989cc3c73f38e306a3',
    FHash.GetHMAC(TEST_STR_ANSI, AnsiString('key'), SHA512_224)
  );
  CheckEquals(
    '647fafb162e1d5fed2064f54b7f34f27361df4efe6c61d34c46d20f8',
    FHash.GetHMAC(
      TEST_STR_ANSI,
      AnsiString('very____________________________________________________________long__________________________________________________________________key'),
      SHA512_224
    )
  );
end;
{$ENDIF FPC}

procedure TTestTHashSHA2_512_224.TestGetHMACUnicode;
begin
  CheckEquals(
    'de43f6b96f2d08cebe1ee9c02c53d96b68c1e55b6c15d6843b410d4c',
    FHash.GetHMAC(UnicodeString(''), UnicodeString(''), SHA512_224)
  );
  CheckEquals(
    '6a5866b62097d4b813d646f42fc8f256f88fc5c0b5d8d7aae30db8a1',
    FHash.GetHMAC(TEST_STR_UNICODE, UnicodeString('key'), SHA512_224)
  );
end;

const
  TEST_BYTES_RESULT_1: array [0..HASH_SHA512_224_SIZE - 1] of Byte = (
    $94, $bd, $07, $d4, $7c, $c1, $76, $47, $45, $51, $6b, $77, $00, $12,
    $bb, $8b, $51, $e8, $f6, $b8, $f6, $d9, $50, $47, $52, $14, $7d, $46
  );
  TEST_BYTES_RESULT_2: array [0..HASH_SHA512_224_SIZE - 1] of Byte = (
    $4b, $f4, $55, $b8, $13, $a1, $fe, $53, $ed, $1d, $f0, $77, $5f, $14,
    $6e, $44, $35, $ed, $d1, $b0, $66, $43, $8d, $bb, $d1, $81, $6d, $02
  );
  TEST_BYTES_RESULT_3: array [0..HASH_SHA512_224_SIZE - 1] of Byte = (
    $b8, $c3, $26, $a0, $2d, $ff, $01, $c2, $40, $44, $86, $32, $39, $20,
    $7f, $81, $57, $11, $e6, $81, $3a, $66, $5e, $db, $fd, $96, $fb, $e3
  );
  TEST_BYTES_RESULT_4: array [0..HASH_SHA512_224_SIZE - 1] of Byte = (
    $fb, $67, $ca, $05, $66, $65, $40, $5f, $93, $38, $8b, $a1, $2f, $66,
    $6b, $8e, $b4, $43, $e2, $5c, $d5, $43, $2e, $d6, $2e, $98, $58, $76
  );
  TEST_BYTES_RESULT_5: array [0..HASH_SHA512_224_SIZE - 1] of Byte = (
    $14, $10, $f7, $d0, $21, $e0, $3c, $06, $d3, $43, $27, $d5, $38, $ad,
    $bf, $1c, $cb, $93, $0b, $93, $91, $27, $eb, $b4, $aa, $01, $35, $a8
  );

{$IFDEF FPC}
procedure TTestTHashSHA2_512_224.TestGetHMACAsBytesAnsi;
var
  TestBytes, Result: TBytes;
  i: Integer;
begin
  SetLength(TestBytes, 4);
  TestBytes[0] := $10; TestBytes[1] := $11; TestBytes[2] := $12; TestBytes[3] := $13;

  Result := FHash.GetHMACAsBytes(AnsiString('data'), AnsiString('data'), SHA512_224);
  CheckEquals(HASH_SHA512_224_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_1) do
    CheckEquals(TEST_BYTES_RESULT_1[i], Result[i]);

  Result := FHash.GetHMACAsBytes(TestBytes, AnsiString('data'), SHA512_224);
  CheckEquals(HASH_SHA512_224_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_2) do
    CheckEquals(TEST_BYTES_RESULT_2[i], Result[i]);

  Result := FHash.GetHMACAsBytes(AnsiString('data'), TestBytes, SHA512_224);
  CheckEquals(HASH_SHA512_224_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_3) do
    CheckEquals(TEST_BYTES_RESULT_3[i], Result[i]);

  Result := FHash.GetHMACAsBytes(TestBytes, TestBytes, SHA512_224);
  CheckEquals(HASH_SHA512_224_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_4) do
    CheckEquals(TEST_BYTES_RESULT_4[i], Result[i]);
end;
{$ENDIF FPC}

procedure TTestTHashSHA2_512_224.TestGetHMACAsBytesUnicode;
var
  TestBytes, Result: TBytes;
  i: Integer;
begin
  SetLength(TestBytes, 4);
  TestBytes[0] := $10; TestBytes[1] := $11; TestBytes[2] := $12; TestBytes[3] := $13;

  Result := FHash.GetHMACAsBytes(UnicodeString('data'), UnicodeString('data'), SHA512_224);
  CheckEquals(HASH_SHA512_224_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_1) do
    CheckEquals(TEST_BYTES_RESULT_1[i], Result[i]);

  Result := FHash.GetHMACAsBytes(TestBytes, UnicodeString('data'), SHA512_224);
  CheckEquals(HASH_SHA512_224_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_2) do
    CheckEquals(TEST_BYTES_RESULT_2[i], Result[i]);

  Result := FHash.GetHMACAsBytes(UnicodeString('data'), TestBytes, SHA512_224);
  CheckEquals(HASH_SHA512_224_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_3) do
    CheckEquals(TEST_BYTES_RESULT_3[i], Result[i]);

  Result := FHash.GetHMACAsBytes(TestBytes, TestBytes, SHA512_224);
  CheckEquals(HASH_SHA512_224_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_4) do
    CheckEquals(TEST_BYTES_RESULT_4[i], Result[i]);

  { big }
  SetLength(TestBytes, 4096);
  for i := Low(TestBytes) to High(TestBytes) do
    TestBytes[i] := (i + 1) mod $ff;
  Result := FHash.GetHMACAsBytes(TestBytes, TestBytes, SHA512_224);
  CheckEquals(HASH_SHA512_224_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_5) do
    CheckEquals(TEST_BYTES_RESULT_5[i], Result[i]);
end;

initialization
  //RegisterTest('System.Hash', TTestTHashSHA2_512_224.Suite);
{$IFEND}

end.

