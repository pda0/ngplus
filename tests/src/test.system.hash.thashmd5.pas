{**********************************************************************
    Copyright(c) 2016 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit Test.System.Hash.THashMD5;

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
  TTestTHashMD5 = class(TTestCase)
  strict private
    FHash: THashMD5;
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
{ TTestTHashMD5 }

const
  HASH_MD5_SIZE = 16;
  HASH_MD5_BLOCK_SIZE = 64;
  HASH_MD5_EMPTY = 'd41d8cd98f00b204e9800998ecf8427e';
  {$IFDEF FPC}
  TEST_STR_ANSI: AnsiString = 'The quick brown fox jumps over the lazy dog';
  {$ENDIF FPC}
  TEST_STR_UNICODE: UnicodeString = '支持楼主，不怕当小白鼠';
  TEST_BYTES_RESULT: array [0..HASH_MD5_SIZE - 1] of Byte = (
    $b4, $3e, $68, $65, $16, $0e, $59, $b4,
    $24, $36, $f4, $1b, $63, $8f, $f2, $a3
  );

procedure TTestTHashMD5.SetUp;
begin
  FHash := THashMD5.Create;
end;

procedure TTestTHashMD5.TearDown;
begin
  {$IFDEF FPC}
  { We have to finalize record manually because fpcunit never frees TTestCase
    so our record never never runs out of scope. }
  Finalize(FHash);
  {$ENDIF FPC}
end;

procedure TTestTHashMD5.TestGetBlockSize;
begin
  CheckEquals(HASH_MD5_BLOCK_SIZE, FHash.GetBlockSize);
end;

procedure TTestTHashMD5.TestGetHashSize;
begin
  CheckEquals(HASH_MD5_SIZE, FHash.GetHashSize);
end;

procedure TTestTHashMD5.TestReset;
begin
  CheckEquals(HASH_MD5_EMPTY, FHash.HashAsString);

  FHash.Reset;
  CheckEquals(HASH_MD5_EMPTY, FHash.HashAsString);

  FHash.Reset;
  CheckEquals(HASH_MD5_EMPTY, FHash.HashAsString);
end;

procedure TTestTHashMD5.FailResetRaw;
const
  TEST_VAL: Cardinal = $01020304;
begin
  FHash.Update(TEST_VAL, SizeOf(TEST_VAL));
end;

procedure TTestTHashMD5.TestResetRaw;
const
  TEST_VAL: Cardinal = $01020304;
begin
  FHash.Update(TEST_VAL, SizeOf(TEST_VAL));
  FHash.Reset;
  CheckEquals(HASH_MD5_EMPTY, FHash.HashAsString);

  CheckException(FailResetRaw, EHashException);
end;

procedure TTestTHashMD5.FailResetTBytes;
var
  TestBytes: TBytes;
begin
  SetLength(TestBytes, 0);
  FHash.Update(TestBytes);
end;

procedure TTestTHashMD5.TestResetTBytes;
var
  TestBytes: TBytes;
begin
  SetLength(TestBytes, 2);
  TestBytes[0] := 5; TestBytes[1] := 6;
  FHash.Update(TestBytes);
  FHash.Reset;
  CheckEquals(HASH_MD5_EMPTY, FHash.HashAsString);

  CheckException(FailResetTBytes, EHashException);
end;

procedure TTestTHashMD5.FailResetString;
begin
  FHash.Update('BlahBlahBlah');
end;

procedure TTestTHashMD5.TestResetString;
begin
  FHash.Update('BlahBlahBlah');
  FHash.Reset;
  CheckEquals(HASH_MD5_EMPTY, FHash.HashAsString);

  CheckException(FailResetString, EHashException);
end;

procedure TTestTHashMD5.TestHashAsString;
begin
  FHash.Update(TEST_STR_UNICODE);
  CheckEquals('b43e6865160e59b42436f41b638ff2a3', FHash.HashAsString);
  { Ready hash value must be available more than once }
  CheckEquals('b43e6865160e59b42436f41b638ff2a3', FHash.HashAsString);
end;

procedure TTestTHashMD5.TestHashAsBytes;
var
  Result: TBytes;
  i: Integer;
begin
  FHash.Update(TEST_STR_UNICODE);
  Result := FHash.HashAsBytes;
  CheckEquals(HASH_MD5_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT) do
    CheckEquals(TEST_BYTES_RESULT[i], Result[i]);
end;

{$IFDEF FPC}
procedure TTestTHashMD5.TestGetHashStringAnsi;
begin
  CheckEquals('9e107d9d372bb6826bd81d3542a419d6', FHash.GetHashString(TEST_STR_ANSI));
end;
{$ENDIF FPC}

procedure TTestTHashMD5.TestGetHashStringUnicode;
begin
  CheckEquals('b43e6865160e59b42436f41b638ff2a3', FHash.GetHashString(TEST_STR_UNICODE));
end;

procedure TTestTHashMD5.TestGetHashBytes;
var
  Result: TBytes;
  i: Integer;
begin
  Result := FHash.GetHashBytes(TEST_STR_UNICODE);
  CheckEquals(HASH_MD5_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT) do
    CheckEquals(TEST_BYTES_RESULT[i], Result[i]);
end;

procedure TTestTHashMD5.TestUpdateRaw;
var
  TestVal1, TestVal2: Cardinal;
begin
  TestVal1 := THash.ToBigEndian(Cardinal($01020304));
  TestVal2 := THash.ToBigEndian(Cardinal($05060708));

  FHash.Update(TestVal1, SizeOf(TestVal1));
  FHash.Update(TestVal2, SizeOf(TestVal2));
  CheckEquals('0ee0646c1c77d8131cc8f4ee65c7673b', FHash.HashAsString);
end;

procedure TTestTHashMD5.TestUpdateRawZero;
const
  TEST_VAL: Cardinal = $01020304;
begin
  FHash.Update(TEST_VAL, 0);
  CheckEquals(HASH_MD5_EMPTY, FHash.HashAsString);
end;

procedure TTestTHashMD5.TestUpdateTBytes;
var
  TestBytes1, TestBytes2: TBytes;
begin
  SetLength(TestBytes1, 2);
  TestBytes1[0] := $10; TestBytes1[1] := $11;
  SetLength(TestBytes2, 2);
  TestBytes2[0] := $12; TestBytes2[1] := $13;

  FHash.Update(TestBytes1);
  FHash.Update(TestBytes2);
  CheckEquals('227fd3068bf6ad85497eed1cad11b16e', FHash.HashAsString);
end;

procedure TTestTHashMD5.TestUpdateTBytesHalf;
var
  TestBytes: TBytes;
begin
  SetLength(TestBytes, 4);
  TestBytes[0] := $10; TestBytes[1] := $11; TestBytes[2] := $12; TestBytes[3] := $13;

  FHash.Update(TestBytes, 2);
  CheckEquals('f3fb9ce693579c43261298432f4d6272', FHash.HashAsString);
end;

procedure TTestTHashMD5.TestUpdateTBytesZero;
var
  TestBytes: TBytes;
begin
  SetLength(TestBytes, 4);
  TestBytes[0] := $10; TestBytes[1] := $11; TestBytes[2] := $12; TestBytes[3] := $13;

  FHash.Update(TestBytes, 0);
  CheckEquals('227fd3068bf6ad85497eed1cad11b16e', FHash.HashAsString);
end;

{$IFDEF FPC}
procedure TTestTHashMD5.TestUpdateAnsiString;
begin
  FHash.Update(AnsiString('The quick brown fox '));
  FHash.Update(AnsiString('jumps over the lazy dog'));
  CheckEquals('9e107d9d372bb6826bd81d3542a419d6', FHash.HashAsString);
end;
{$ENDIF FPC}

procedure TTestTHashMD5.TestUpdateUnicodeString;
begin
  FHash.Update(UnicodeString('支持楼主，'));
  FHash.Update(UnicodeString('不怕当小白鼠'));
  CheckEquals('b43e6865160e59b42436f41b638ff2a3', FHash.HashAsString);
end;

{$IFDEF FPC}
procedure TTestTHashMD5.TestGetHMACAnsi;
begin
  CheckEquals('74e6f7298a9c2d168935f58c001bad88', FHash.GetHMAC(AnsiString(''), AnsiString('')));
  CheckEquals('80070713463e7749b90c2dc24911e275', FHash.GetHMAC(TEST_STR_ANSI, AnsiString('key')));
  CheckEquals('ce036760727d2a7e44c91d47e82e1076', FHash.GetHMAC(
    TEST_STR_ANSI,
    AnsiString('very____________________________________________________________long__________________________________________________________________key')
  ));
end;
{$ENDIF FPC}

procedure TTestTHashMD5.TestGetHMACUnicode;
begin
  CheckEquals('74e6f7298a9c2d168935f58c001bad88', FHash.GetHMAC(UnicodeString(''), UnicodeString('')));
  CheckEquals('f6c8835ada31ab6871c89d2b70d61345', FHash.GetHMAC(TEST_STR_UNICODE, UnicodeString('key')));
end;

const
  TEST_BYTES_RESULT_1: array [0..HASH_MD5_SIZE - 1] of Byte = (
    $82, $7c, $b3, $17, $c7, $b8, $e2, $69,
    $69, $a9, $17, $3b, $18, $2f, $22, $77
  );
  TEST_BYTES_RESULT_2: array [0..HASH_MD5_SIZE - 1] of Byte = (
    $08, $f8, $3d, $b3, $3a, $94, $e0, $28,
    $54, $de, $45, $a0, $92, $52, $c8, $27
  );
  TEST_BYTES_RESULT_3: array [0..HASH_MD5_SIZE - 1] of Byte = (
    $b5, $44, $c6, $9c, $53, $47, $28, $9f,
    $77, $55, $3e, $88, $9c, $b1, $55, $59
  );
  TEST_BYTES_RESULT_4: array [0..HASH_MD5_SIZE - 1] of Byte = (
    $bd, $79, $4b, $17, $22, $68, $9c, $15,
    $0c, $d8, $90, $65, $b9, $11, $0d, $1f
  );
  TEST_BYTES_RESULT_5: array [0..HASH_MD5_SIZE - 1] of Byte = (
    $58, $f4, $13, $bf, $87, $bc, $a6, $7e,
    $0a, $02, $d5, $96, $bb, $f7, $b2, $24
  );

{$IFDEF FPC}
procedure TTestTHashMD5.TestGetHMACAsBytesAnsi;
var
  TestBytes, Result: TBytes;
  i: Integer;
begin
  SetLength(TestBytes, 4);
  TestBytes[0] := $10; TestBytes[1] := $11; TestBytes[2] := $12; TestBytes[3] := $13;

  Result := FHash.GetHMACAsBytes(AnsiString('data'), AnsiString('data'));
  CheckEquals(HASH_MD5_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_1) do
    CheckEquals(TEST_BYTES_RESULT_1[i], Result[i]);

  Result := FHash.GetHMACAsBytes(TestBytes, AnsiString('data'));
  CheckEquals(HASH_MD5_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_2) do
    CheckEquals(TEST_BYTES_RESULT_2[i], Result[i]);

  Result := FHash.GetHMACAsBytes(AnsiString('data'), TestBytes);
  CheckEquals(HASH_MD5_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_3) do
    CheckEquals(TEST_BYTES_RESULT_3[i], Result[i]);

  Result := FHash.GetHMACAsBytes(TestBytes, TestBytes);
  CheckEquals(HASH_MD5_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_4) do
    CheckEquals(TEST_BYTES_RESULT_4[i], Result[i]);
end;
{$ENDIF FPC}

procedure TTestTHashMD5.TestGetHMACAsBytesUnicode;
var
  TestBytes, Result: TBytes;
  i: Integer;
begin
  SetLength(TestBytes, 4);
  TestBytes[0] := $10; TestBytes[1] := $11; TestBytes[2] := $12; TestBytes[3] := $13;

  Result := FHash.GetHMACAsBytes(UnicodeString('data'), UnicodeString('data'));
  CheckEquals(HASH_MD5_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_1) do
    CheckEquals(TEST_BYTES_RESULT_1[i], Result[i]);

  Result := FHash.GetHMACAsBytes(TestBytes, UnicodeString('data'));
  CheckEquals(HASH_MD5_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_2) do
    CheckEquals(TEST_BYTES_RESULT_2[i], Result[i]);

  Result := FHash.GetHMACAsBytes(UnicodeString('data'), TestBytes);
  CheckEquals(HASH_MD5_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_3) do
    CheckEquals(TEST_BYTES_RESULT_3[i], Result[i]);

  Result := FHash.GetHMACAsBytes(TestBytes, TestBytes);
  CheckEquals(HASH_MD5_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_4) do
    CheckEquals(TEST_BYTES_RESULT_4[i], Result[i]);

  { big }
  SetLength(TestBytes, 4096);
  for i := Low(TestBytes) to High(TestBytes) do
    TestBytes[i] := (i + 1) mod $ff;
  Result := FHash.GetHMACAsBytes(TestBytes, TestBytes);
  CheckEquals(HASH_MD5_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_5) do
    CheckEquals(TEST_BYTES_RESULT_5[i], Result[i]);
end;

initialization
  RegisterTest('System.Hash', TTestTHashMD5.Suite);
{$IFEND}

end.

