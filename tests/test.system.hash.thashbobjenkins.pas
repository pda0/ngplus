{**********************************************************************
    Copyright(c) 2016 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit Test.System.Hash.THashBobJenkins;

{$IFNDEF FPC}{$LEGACYIFEND ON}{$ENDIF FPC}
{$I ../src/ngplus.inc}

interface

uses
  {$IFDEF FPC}
  fpcunit, testregistry,
  {$ELSE}
  TestFramework,
  {$ENDIF FPC}
  Classes, SysUtils, System.Hash;

type
  TTestTHashBobJenkins = class(TTestCase)
  strict private
    FHash: THashBobJenkins;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestReset;
    procedure TestResetRaw;
    procedure TestResetTBytes;
    procedure TestResetString;
    //TODO: Reset with different seed
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
    //TODO: Ext tests
  end;

implementation

{ TTestTHashBobJenkins }

const
  HASH_BJ_SIZE = 4;
  HASH_BJ_UNINIT = '00000000';
  HASH_BJ_EMPTY = 'DEADBEEF';
  {$IFDEF FPC}
  TEST_STR_ANSI: AnsiString = 'The quick brown fox jumps over the lazy dog';
  {$ENDIF FPC}
  TEST_STR_UNICODE: UnicodeString = '支持楼主，不怕当小白鼠';
  TEST_BYTES_RESULT: array [0..HASH_BJ_SIZE - 1] of Byte = (
    147, 123, 11, 175
  );

procedure TTestTHashBobJenkins.SetUp;
begin
  FHash := THashBobJenkins.Create;
end;

procedure TTestTHashBobJenkins.TearDown;
begin
  {$IFDEF FPC}
  //TODO: Check implementation!
  { We have to finalize record manually because fpcunit never frees TTestCase
    so our record never never runs out of scope. }
  Finalize(FHash);
  {$ENDIF FPC}
end;

procedure TTestTHashBobJenkins.TestReset;
begin
  CheckEquals(HASH_BJ_UNINIT, FHash.HashAsString);

  FHash.Reset;
  CheckEquals(HASH_BJ_UNINIT, FHash.HashAsString);

  FHash.Reset;
  CheckEquals(HASH_BJ_UNINIT, FHash.HashAsString);
end;

procedure TTestTHashBobJenkins.TestResetRaw;
const
  TEST_VAL: Cardinal = $01020304;
begin
  FHash.Update(TEST_VAL, SizeOf(TEST_VAL));
  FHash.Reset;
  CheckEquals(HASH_BJ_UNINIT, FHash.HashAsString);

  FHash.Update(TEST_VAL, 0);
  FHash.Reset;
  CheckEquals(HASH_BJ_UNINIT, FHash.HashAsString);
end;

procedure TTestTHashBobJenkins.TestResetTBytes;
var
  TestBytes: TBytes;
begin
  SetLength(TestBytes, 2);
  TestBytes[0] := 5; TestBytes[1] := 6;
  FHash.Update(TestBytes);
  FHash.Reset;
  CheckEquals(HASH_BJ_UNINIT, FHash.HashAsString);

  SetLength(TestBytes, 0);
  FHash.Update(TestBytes);
  CheckEquals(HASH_BJ_EMPTY, FHash.HashAsString);
end;

procedure TTestTHashBobJenkins.TestResetString;
begin
  FHash.Update('BlahBlahBlah');
  FHash.Reset;
  CheckEquals(HASH_BJ_UNINIT, FHash.HashAsString);

  FHash.Update('');
  FHash.Reset;
  CheckEquals(HASH_BJ_UNINIT, FHash.HashAsString);
end;

procedure TTestTHashBobJenkins.TestHashAsString;
begin
  FHash.Update(TEST_STR_UNICODE);
  CheckEquals('937B0BAF', FHash.HashAsString);
  { Ready hash value must be available more than once }
  CheckEquals('937B0BAF', FHash.HashAsString);
end;

procedure TTestTHashBobJenkins.TestHashAsBytes;
var
  Result: TBytes;
  i: Integer;
begin
  FHash.Update(TEST_STR_UNICODE);
  Result := FHash.HashAsBytes;
  CheckEquals(HASH_BJ_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT) do
    CheckEquals(TEST_BYTES_RESULT[i], Result[i]);
end;

{$IFDEF FPC}
procedure TTestTHashBobJenkins.TestGetHashStringAnsi;
begin
  CheckEquals('7D92DC8F', FHash.GetHashString(TEST_STR_ANSI));
end;
{$ENDIF FPC}

procedure TTestTHashBobJenkins.TestGetHashStringUnicode;
begin
  CheckEquals('937B0BAF', FHash.GetHashString(TEST_STR_UNICODE));
end;

procedure TTestTHashBobJenkins.TestGetHashBytes;
var
  Result: TBytes;
  i: Integer;
begin
  Result := FHash.GetHashBytes(TEST_STR_UNICODE);
  CheckEquals(HASH_BJ_SIZE, Length(Result));
  for i := 0 to High(TEST_BYTES_RESULT) do
    CheckEquals(TEST_BYTES_RESULT[i], Result[i]);
end;

procedure TTestTHashBobJenkins.TestUpdateRaw;
var
  TestVal1, TestVal2: Cardinal;
begin
  TestVal1 := THash.ToBigEndian(Cardinal($01020304));
  TestVal2 := THash.ToBigEndian(Cardinal($05060708));

  FHash.Update(TestVal1, SizeOf(TestVal1));
  FHash.Update(TestVal2, SizeOf(TestVal2));
  CheckEquals('56557629', FHash.HashAsString);
end;

procedure TTestTHashBobJenkins.TestUpdateRawZero;
const
  TEST_VAL: Cardinal = $01020304;
begin
  FHash.Update(TEST_VAL, 0);
  CheckEquals(HASH_BJ_EMPTY, FHash.HashAsString);
end;

procedure TTestTHashBobJenkins.TestUpdateTBytes;
var
  TestBytes1, TestBytes2: TBytes;
begin
  SetLength(TestBytes1, 2);
  TestBytes1[0] := $10; TestBytes1[1] := $11;
  SetLength(TestBytes2, 2);
  TestBytes2[0] := $12; TestBytes2[1] := $13;

  FHash.Update(TestBytes1);
  FHash.Update(TestBytes2);
  CheckEquals('E8E93340', FHash.HashAsString);
end;

procedure TTestTHashBobJenkins.TestUpdateTBytesHalf;
var
  TestBytes: TBytes;
begin
  SetLength(TestBytes, 4);
  TestBytes[0] := $10; TestBytes[1] := $11; TestBytes[2] := $12; TestBytes[3] := $13;

  FHash.Update(TestBytes, 2);
  CheckEquals('BA378C41', FHash.HashAsString);
end;

procedure TTestTHashBobJenkins.TestUpdateTBytesZero;
var
  TestBytes: TBytes;
begin
  SetLength(TestBytes, 4);
  TestBytes[0] := $10; TestBytes[1] := $11; TestBytes[2] := $12; TestBytes[3] := $13;

  FHash.Update(TestBytes, 0);
  CheckEquals('094C7D94', FHash.HashAsString);
end;


{$IFDEF FPC}
procedure TTestTHashBobJenkins.TestUpdateAnsiString;
begin
  FHash.Update(AnsiString('The quick brown fox '));
  FHash.Update(AnsiString('jumps over the lazy dog'));
  CheckEquals('7D92DC8F', FHash.HashAsString);
end;
{$ENDIF FPC}

procedure TTestTHashBobJenkins.TestUpdateUnicodeString;
begin
  FHash.Update(UnicodeString('支持楼主，'));
  FHash.Update(UnicodeString('不怕当小白鼠'));
  CheckEquals('937B0BAF', FHash.HashAsString);
end;

initialization
//  RegisterTest('System.Hash', TTestTHashBobJenkins.Suite);

end.

