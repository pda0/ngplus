{**********************************************************************
    Copyright(c) 2016 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit Test.System.Hash.THash;

{$IFDEF ENABLE_UNICODE}{$MODE DELPHIUNICODE}{$ELSE}{$MODE DELPHI}{$ENDIF}{$H+}
{$CODEPAGE UTF8}

interface

uses
  Classes, SysUtils, System.Hash,
  fpcunit, {testutils,} testregistry;

type
  TTestTHash = class(TTestCase)
  strict private
    FBadDigest: TBytes;
    procedure FailDigestInteger;
    procedure FailDigestGuid;
  public
    procedure SetUp; override;
  published
    procedure TestDigestAsInteger;
    procedure TestDigestAsString;
    procedure TestDigestAsStringGUID;
    procedure TestGetRandomString;
    procedure TestToBigEndianCardinal;
    procedure TestToBigEndianUInt64;
  end;

implementation

{ TTestTHash }

procedure TTestTHash.SetUp;
begin
  SetLength(FBadDigest, 0);
end;

procedure TTestTHash.FailDigestInteger;
begin
  THash.DigestAsInteger(FBadDigest);
end;

procedure TTestTHash.TestDigestAsInteger;
const
  TEST_VAL: Integer = $01020304;
var
  Digest: TBytes;
begin
  Assert(SizeOf(Integer) = 4);
  SetLength(Digest, 4);
  Move(TEST_VAL, Digest[0], SizeOf(Integer));
  CheckEquals(TEST_VAL, THash.DigestAsInteger(Digest));

  CheckException(FailDigestInteger, EHashException, 'Digest size must be 4 to Generate a Integer');

  SetLength(FBadDigest, 3);
  CheckException(FailDigestInteger, EHashException, 'Digest size must be 4 to Generate a Integer');

  SetLength(FBadDigest, 5);
  CheckException(FailDigestInteger, EHashException, 'Digest size must be 4 to Generate a Integer');
end;

procedure TTestTHash.TestDigestAsString;
const
  TEST_VAL: array [0..7] of Byte = ($01, $02, $03, $04, $0a, $0b, $ab, $ff);
var
  Digest: TBytes;
begin
  SetLength(Digest, Length(TEST_VAL));
  Move(TEST_VAL[0], Digest[0], Length(TEST_VAL));
  CheckEquals('010203040a0babff', THash.DigestAsString(Digest));

  CheckEquals('', THash.DigestAsString(FBadDigest));
end;

procedure TTestTHash.FailDigestGuid;
begin
  THash.DigestAsStringGUID(FBadDigest);
end;

procedure TTestTHash.TestDigestAsStringGUID;
const
  TEST_VAL: array [0..15] of Byte = (
    $01, $02, $03, $04, $05, $06, $07, $08,
    $09, $0a, $0b, $0c, $0d, $0e, $0f, $10
  );
var
  Digest: TBytes;
begin
  SetLength(Digest, Length(TEST_VAL));
  Move(TEST_VAL[0], Digest[0], Length(TEST_VAL));
  CheckEquals('{01020304-0506-0708-090A-0B0C0D0E0F10}', THash.DigestAsStringGUID(Digest));

  CheckException(FailDigestGuid, EArgumentException, 'Byte array for GUID must be exactly 16 bytes long');
end;

procedure TTestTHash.TestGetRandomString;
const
  VAILD_CHARS: TSysCharSet = ['0'..'9', 'a'..'z', 'A'..'Z', '*', '+', '-', '/', '_'];
var
  i: Integer;
  Result0, Result1, Result2: string;
begin
  Result0 := THash.GetRandomString;
  Result1 := THash.GetRandomString(1000);
  Result2 := THash.GetRandomString(1000);

  CheckEquals(10, Length(Result0));
  CheckEquals(1000, Length(Result1));
  CheckEquals(1000, Length(Result2));

  CheckNotEquals(Result1, Result2);

  for i := 1 to Length(Result0) do
    CheckTrue(CharInSet(Result0[i], VAILD_CHARS));

  for i := 1 to Length(Result1) do
    CheckTrue(CharInSet(Result1[i], VAILD_CHARS));

  for i := 1 to Length(Result2) do
    CheckTrue(CharInSet(Result2[i], VAILD_CHARS));

  CheckEquals('', THash.GetRandomString(0));
  CheckEquals('', THash.GetRandomString(-1));
end;

procedure TTestTHash.TestToBigEndianCardinal;
const
  TEST_VAL: array [0..3] of Byte = ($01, $02, $03, $04);
var
  Val: Cardinal absolute TEST_VAL;
begin
  CheckEquals($01020304, THash.ToBigEndian(Val));
end;

procedure TTestTHash.TestToBigEndianUInt64;
const
  TEST_VAL: array [0..7] of Byte = ($01, $02, $03, $04, $05, $06, $07, $08);
  TEST_RESULT: UInt64 = $0102030405060708;
var
  Val: UInt64 absolute TEST_VAL;
begin
  CheckEquals(TEST_RESULT, THash.ToBigEndian(Val));
end;


initialization
  RegisterTest('System.Hash', TTestTHash);

end.

