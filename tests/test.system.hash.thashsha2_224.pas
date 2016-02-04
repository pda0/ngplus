{**********************************************************************
    Copyright(c) 2016 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit Test.System.Hash.THashSHA2_224;

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
  TTestTHashSHA2_224 = class(TTestCase)
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

{ TTestTHashSHA2_224 }

const
  HASH_SHA224_SIZE = 28;
  HASH_SHA224_BLOCK_SIZE = 64;
  HASH_SHA224_EMPTY = 'd14a028c2a3a2bc9476102bb288234c415a2b01f828ea62ac5b3e42f';
  {$IFDEF FPC}
  TEST_STR_ANSI: AnsiString = 'The quick brown fox jumps over the lazy dog';
  {$ENDIF FPC}
  TEST_STR_UNICODE: UnicodeString = '支持楼主，不怕当小白鼠';
  TEST_BYTES_RESULT: array [0..HASH_SHA224_SIZE - 1] of Byte = (
    $ed, $df, $11, $40, $e2, $72, $6f, $5f, $fe, $f2, $47, $69, $4d, $eb,
    $9d, $88, $f4, $27, $56, $c6, $90, $06, $df, $0c, $e7, $4f, $68, $e4
  );

procedure TTestTHashSHA2_224.SetUp;
begin
  FHash := THashSHA2.Create(SHA224);
end;

procedure TTestTHashSHA2_224.TearDown;
begin
  { We have to finalize record manually because fpcunit never frees TTestCase
    so our record never never runs out of scope. }
  Finalize(FHash);
end;

{$IFDEF CLOSER_TO_DELPHI}
procedure TTestTHashSHA2_224.TestCreate;
begin
  CheckTrue(FHash.FVersion = SHA224);
end;
{$ENDIF CLOSER_TO_DELPHI}

procedure TTestTHashSHA2_224.TestGetBlockSize;
begin
  CheckEquals(HASH_SHA224_BLOCK_SIZE, FHash.GetBlockSize);
end;

procedure TTestTHashSHA2_224.TestGetHashSize;
begin
  CheckEquals(HASH_SHA224_SIZE, FHash.GetHashSize);
end;

procedure TTestTHashSHA2_224.TestReset;
begin
  CheckEquals(HASH_SHA224_EMPTY, FHash.HashAsString);

  FHash.Reset;
  CheckEquals(HASH_SHA224_EMPTY, FHash.HashAsString);

  FHash.Reset;
  CheckEquals(HASH_SHA224_EMPTY, FHash.HashAsString);
end;

procedure TTestTHashSHA2_224.FailResetRaw;
const
  TEST_VAL: Cardinal = $01020304;
begin
  FHash.Update(TEST_VAL, SizeOf(TEST_VAL));
end;

procedure TTestTHashSHA2_224.TestResetRaw;
const
  TEST_VAL: Cardinal = $01020304;
begin
  FHash.Update(TEST_VAL, SizeOf(TEST_VAL));
  FHash.Reset;
  CheckEquals(HASH_SHA224_EMPTY, FHash.HashAsString);

  CheckException(FailResetRaw, EHashException);
end;

procedure TTestTHashSHA2_224.FailResetTBytes;
var
  TestBytes: TBytes;
begin
  SetLength(TestBytes, 0);
  FHash.Update(TestBytes);
end;

procedure TTestTHashSHA2_224.TestResetTBytes;
var
  TestBytes: TBytes;
begin
  SetLength(TestBytes, 2);
  TestBytes[0] := 5; TestBytes[1] := 6;
  FHash.Update(TestBytes);
  FHash.Reset;
  CheckEquals(HASH_SHA224_EMPTY, FHash.HashAsString);

  CheckException(FailResetTBytes, EHashException);
end;

procedure TTestTHashSHA2_224.FailResetString;
begin
  FHash.Update('BlahBlahBlah');
end;

procedure TTestTHashSHA2_224.TestResetString;
begin
  FHash.Update('BlahBlahBlah');
  FHash.Reset;
  CheckEquals(HASH_SHA224_EMPTY, FHash.HashAsString);

  CheckException(FailResetString, EHashException);
end;

procedure TTestTHashSHA2_224.TestHashAsString;
begin
  FHash.Update(TEST_STR_UNICODE);
  CheckEquals('eddf1140e2726f5ffef247694deb9d88f42756c69006df0ce74f68e4', FHash.HashAsString);
  { Ready hash value must be available more than once }
  CheckEquals('eddf1140e2726f5ffef247694deb9d88f42756c69006df0ce74f68e4', FHash.HashAsString);
end;

procedure TTestTHashSHA2_224.TestHashAsBytes;
var
  Result: TBytes;
  i: Integer;
begin
  FHash.Update(TEST_STR_UNICODE);
  Result := FHash.HashAsBytes;
  CheckEquals(HASH_SHA224_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT) do
    CheckEquals(TEST_BYTES_RESULT[i], Result[i]);
end;

{$IFDEF FPC}
procedure TTestTHashSHA2_224.TestGetHashStringAnsi;
begin
  CheckEquals('730e109bd7a8a32b1cb9d9a09aa2325d2430587ddbc0c38bad911525', FHash.GetHashString(TEST_STR_ANSI));
end;
{$ENDIF FPC}

procedure TTestTHashSHA2_224.TestGetHashStringUnicode;
begin
  CheckEquals('eddf1140e2726f5ffef247694deb9d88f42756c69006df0ce74f68e4', FHash.GetHashString(TEST_STR_UNICODE, SHA224));
end;

procedure TTestTHashSHA2_224.TestGetHashBytes;
var
  Result: TBytes;
  i: Integer;
begin
  Result := FHash.GetHashBytes(TEST_STR_UNICODE, SHA224);
  CheckEquals(HASH_SHA224_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT) do
    CheckEquals(TEST_BYTES_RESULT[i], Result[i]);
end;

procedure TTestTHashSHA2_224.TestUpdateRaw;
var
  TestVal1, TestVal2: Cardinal;
begin
  TestVal1 := THash.ToBigEndian(Cardinal($01020304));
  TestVal2 := THash.ToBigEndian(Cardinal($05060708));

  FHash.Update(TestVal1, SizeOf(TestVal1));
  FHash.Update(TestVal2, SizeOf(TestVal2));
  CheckEquals('b7f8f7caf78b0783e0588667fabb17d2df71ff4d6120fb59f87f7c61', FHash.HashAsString);
end;

procedure TTestTHashSHA2_224.TestUpdateRawZero;
const
  TEST_VAL: Cardinal = $01020304;
begin
  FHash.Update(TEST_VAL, 0);
  CheckEquals(HASH_SHA224_EMPTY, FHash.HashAsString);
end;

procedure TTestTHashSHA2_224.TestUpdateTBytes;
var
  TestBytes1, TestBytes2: TBytes;
begin
  SetLength(TestBytes1, 2);
  TestBytes1[0] := $10; TestBytes1[1] := $11;
  SetLength(TestBytes2, 2);
  TestBytes2[0] := $12; TestBytes2[1] := $13;

  FHash.Update(TestBytes1);
  FHash.Update(TestBytes2);
  CheckEquals('14a91753bcd620836c933840ea4589a198ffe753f3a2cf7de2a0067b', FHash.HashAsString);
end;

procedure TTestTHashSHA2_224.TestUpdateTBytesHalf;
var
  TestBytes: TBytes;
begin
  SetLength(TestBytes, 4);
  TestBytes[0] := $10; TestBytes[1] := $11; TestBytes[2] := $12; TestBytes[3] := $13;

  FHash.Update(TestBytes, 2);
  CheckEquals('f61462b4065d8fbf8410c40c84b0e94a07f1e4f209ac4d319bac8859', FHash.HashAsString);
end;

procedure TTestTHashSHA2_224.TestUpdateTBytesZero;
var
  TestBytes: TBytes;
begin
  SetLength(TestBytes, 4);
  TestBytes[0] := $10; TestBytes[1] := $11; TestBytes[2] := $12; TestBytes[3] := $13;

  FHash.Update(TestBytes, 0);
  CheckEquals('14a91753bcd620836c933840ea4589a198ffe753f3a2cf7de2a0067b', FHash.HashAsString);
end;

{$IFDEF FPC}
procedure TTestTHashSHA2_224.TestUpdateAnsiString;
begin
  FHash.Update(AnsiString('The quick brown fox '));
  FHash.Update(AnsiString('jumps over the lazy dog'));
  CheckEquals('730e109bd7a8a32b1cb9d9a09aa2325d2430587ddbc0c38bad911525', FHash.HashAsString);
end;
{$ENDIF FPC}

procedure TTestTHashSHA2_224.TestUpdateUnicodeString;
begin
  FHash.Update(UnicodeString('支持楼主，'));
  FHash.Update(UnicodeString('不怕当小白鼠'));
  CheckEquals('eddf1140e2726f5ffef247694deb9d88f42756c69006df0ce74f68e4', FHash.HashAsString);
end;

(* procedure TTestTHashSHA2_224.TestGetHMAC;
begin
  CheckEquals('ab26f331d48f1e08922c229bf742bc43b8ad7230d7e581ce08e5a700', FHash.GetHMAC('password', 'key', SHA224));
  CheckEquals('5ce14f72894662213e2748d2a6ba234b74263910cedde2f5a9271524', FHash.GetHMAC('', '', SHA224));
end;

procedure TTestTHashSHA2_224.TestGetHMACAsBytes;
const
  TEST_BYTES_RESULT_1: array [0..HASH_SHA224_SIZE - 1] of Byte = (
    $98, $01, $ae, $43, $4a, $3b, $1e, $a6, $24, $c3, $cc, $20, $dd, $c8,
    $96, $e6, $a0, $87, $9b, $88, $b2, $21, $6f, $9e, $5c, $f1, $84, $e0
  );
  TEST_BYTES_RESULT_2: array [0..HASH_SHA224_SIZE - 1] of Byte = (
    $1c, $f5, $31, $3e, $24, $dd, $97, $5c, $33, $11, $79, $4d, $df, $75,
    $8f, $63, $06, $16, $0f, $9c, $a9, $50, $f5, $5d, $95, $27, $d9, $60
  );
  TEST_BYTES_RESULT_3: array [0..HASH_SHA224_SIZE - 1] of Byte = (
    $57, $d7, $aa, $a6, $71, $eb, $6f, $5b, $9f, $cb, $b1, $e1, $16, $fb,
    $76, $f0, $01, $8d, $3d, $e4, $91, $f0, $87, $e1, $a0, $83, $1a, $3a
  );
  TEST_BYTES_RESULT_4: array [0..HASH_SHA224_SIZE - 1] of Byte = (
    $95, $44, $c0, $d0, $42, $5f, $f9, $0d, $e6, $15, $34, $0a, $73, $ca,
    $61, $71, $50, $41, $10, $83, $84, $d0, $ba, $f6, $8e, $0d, $ba, $d8
  );
  TEST_BYTES_RESULT_5: array [0..HASH_SHA224_SIZE - 1] of Byte = (
    $8b, $9b, $47, $6f, $50, $05, $07, $69, $6e, $19, $49, $c5, $21, $b2,
    $45, $86, $f5, $f8, $be, $56, $93, $19, $d2, $77, $24, $a7, $f5, $b2
  );
var
  TestBytes, Result: TBytes;
  i: Integer;
begin
  SetLength(TestBytes, 4);
  TestBytes[0] := $10; TestBytes[1] := $11; TestBytes[2] := $12; TestBytes[3] := $13;

  Result := FHash.GetHMACAsBytes('data', 'data', SHA224);
  CheckEquals(HASH_SHA224_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_1) do
    CheckEquals(TEST_BYTES_RESULT_1[i], Result[i]);

  Result := FHash.GetHMACAsBytes(TestBytes, 'data', SHA224);
  CheckEquals(HASH_SHA224_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_2) do
    CheckEquals(TEST_BYTES_RESULT_2[i], Result[i]);

  Result := FHash.GetHMACAsBytes('data', TestBytes, SHA224);
  CheckEquals(HASH_SHA224_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_3) do
    CheckEquals(TEST_BYTES_RESULT_3[i], Result[i]);

  Result := FHash.GetHMACAsBytes(TestBytes, TestBytes, SHA224);
  CheckEquals(HASH_SHA224_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_4) do
    CheckEquals(TEST_BYTES_RESULT_4[i], Result[i]);

  { big }
  SetLength(TestBytes, 4096);
  for i := Low(TestBytes) to High(TestBytes) do
    TestBytes[i] := i + 1;
  Result := FHash.GetHMACAsBytes(TestBytes, TestBytes, SHA224);
  CheckEquals(HASH_SHA224_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT_5) do
    CheckEquals(TEST_BYTES_RESULT_5[i], Result[i]);
end; *)

initialization
//  RegisterTest('System.Hash', TTestTHashSHA2_224.Suite);

end.

