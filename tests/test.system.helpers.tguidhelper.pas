{**********************************************************************
    Copyright(c) 2016 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit Test.System.Helpers.TGuidHelper;

{$IFDEF ENABLE_UNICODE}{$MODE DELPHIUNICODE}{$ELSE}{$MODE DELPHI}{$ENDIF}{$H+}
{$CODEPAGE UTF8}

interface

uses
  Classes, SysUtils, Types, System.Helpers, fpcunit, testregistry;

type
  TTestTGuidHelper = class(TTestCase)
  strict private
    FGuid: TGUID;
  private
    {$IFDEF CLOSER_TO_DELPHI}
    procedure FailCreate1;
    {$ELSE}
    procedure FailCreate1A;
    procedure FailCreate1U;
    {$ENDIF CLOSER_TO_DELPHI}
    procedure FailCreate4;
    procedure FailCreate5;
  published
    {$IFDEF CLOSER_TO_DELPHI}
    procedure TestCreate1;
    {$ELSE}
    procedure TestCreate1A;
    procedure TestCreate1U;
    {$ENDIF CLOSER_TO_DELPHI}
    procedure TestCreate2;
    procedure TestCreate3;
    procedure TestCreate4;
    procedure TestCreate5;
    procedure TestCreate6;
    procedure TestCreate7;
    procedure TestEmpty;
    procedure TestNewGuid;
    procedure TestToByteArray;
    procedure TestToString;
  end;

implementation

const
  TEST_GUID: TGUID = (
    D1: $00010203; D2: $0405; D3: $0607; D4:($08, $09, $0a, $0b, $0c, $0d, $0e, $0f)
  );
  TEST_GUID_GOOD: TGUID = (
    D1: $ec7e5bd7; D2: $3846; D3: $41e3; D4:($a6, $af, $12, $bb, $e7, $00, $8e, $03)
  );
  TEST_GUID_EMPTY: TGUID = (
    D1: 0; D2: 0; D3: 0; D4:(0, 0, 0, 0, 0, 0, 0, 0)
  );
  TEST_LONG_ARRAY: array [0..17] of Byte = (
    $fe, $ff, $00, $01, $02, $03, $04, $05, $06,
    $07, $08, $09, $0a, $0b, $0c, $0d, $0e, $0f
  );
  TEST_GUID_LONG_DIRECT: TGUID = (
    D1: $feff0001; D2: $0203; D3: $0405; D4:($06, $07, $08, $09, $0a, $0b, $0c, $0d)
  );
  TEST_GUID_LONG_SWAPPED: TGUID = (
    D1: $0100fffe; D2: $0302; D3: $0504; D4:($06, $07, $08, $09, $0a, $0b, $0c, $0d)
  );

{ TTestTGuidHelper }

{$IFDEF CLOSER_TO_DELPHI}
procedure TTestTGuidHelper.FailCreate1;
const
  BAD_GUID: string = '***';
begin
  TGUID.Create(BAD_GUID);
end;

procedure TTestTGuidHelper.TestCreate1;
const
  GOOD_GUID: string = '{EC7E5BD7-3846-41E3-A6AF-12BBE7008E03}';
begin
  CheckTrue(IsEqualGUID(TEST_GUID_GOOD, TGUID.Create(GOOD_GUID)));
  CheckException(FailCreate1, EConvertError, '''***'' is not a valid GUID value');
end;

{$ELSE}
procedure TTestTGuidHelper.FailCreate1A;
const
  BAD_GUID: AnsiString = '***';
begin
  TGUID.Create(BAD_GUID);
end;

procedure TTestTGuidHelper.TestCreate1A;
const
  GOOD_GUID: AnsiString = '{EC7E5BD7-3846-41E3-A6AF-12BBE7008E03}';
begin
  CheckTrue(IsEqualGUID(TEST_GUID_GOOD, TGUID.Create(GOOD_GUID)));
  CheckException(FailCreate1A, EConvertError, '''***'' is not a valid GUID value');
end;

procedure TTestTGuidHelper.FailCreate1U;
const
  BAD_GUID: UnicodeString = '***';
begin
  TGUID.Create(BAD_GUID);
end;

procedure TTestTGuidHelper.TestCreate1U;
const
  GOOD_GUID: UnicodeString = '{EC7E5BD7-3846-41E3-A6AF-12BBE7008E03}';
begin
  CheckTrue(IsEqualGUID(TEST_GUID_GOOD, TGUID.Create(GOOD_GUID)));
  CheckException(FailCreate1U, EConvertError, '''***'' is not a valid GUID value');
end;
{$ENDIF CLOSER_TO_DELPHI}

procedure TTestTGuidHelper.TestCreate2;
begin
  CheckTrue(IsEqualGUID(TEST_GUID_LONG_DIRECT, TGUID.Create(TEST_LONG_ARRAY, TEndian.Big)));
  CheckTrue(IsEqualGUID(TEST_GUID_LONG_SWAPPED, TGUID.Create(TEST_LONG_ARRAY, TEndian.Little)));
end;

procedure TTestTGuidHelper.TestCreate3;
var
  Bytes: TBytes;
  i: Integer;
begin
  SetLength(Bytes, Length(TEST_LONG_ARRAY));
  for i := 0 to High(Bytes) do
    Bytes[i] := TEST_LONG_ARRAY[i];

  CheckTrue(IsEqualGUID(TEST_GUID_LONG_DIRECT, TGUID.Create(Bytes, TEndian.Big)));
  CheckTrue(IsEqualGUID(TEST_GUID_LONG_SWAPPED, TGUID.Create(Bytes, TEndian.Little)));
end;

procedure TTestTGuidHelper.FailCreate4;
var
  Bytes: TBytes;
begin
  SetLength(Bytes, 0);
  FGuid := TGuid.Create(Bytes, 0);
end;

procedure TTestTGuidHelper.TestCreate4;
const
  RES_1_D1: Cardinal = $00010203;
  RES_1_D2: Word = $0405;
  RES_1_D3: Word = $0607;
  RES_2_D1: Cardinal = $feff0001;
  RES_2_D2: Word = $0203;
  RES_2_D3: Word = $0405;
var
  Bytes: TBytes;
  i: Integer;
begin
  SetLength(Bytes, Length(TEST_LONG_ARRAY));
  for i := 0 to High(Bytes) do
    Bytes[i] := TEST_LONG_ARRAY[i];

  FGuid := TGuid.Create(Bytes, 2, TEndian.Big);
  CheckEquals(RES_1_D1, FGuid.D1);
  CheckEquals(RES_1_D2, FGuid.D2);
  CheckEquals(RES_1_D3, FGuid.D3);
  for i := 0 to 7 do
    CheckEquals(Bytes[i + 10], FGuid.D4[i]);

  FGuid := TGuid.Create(Bytes, 0, TEndian.Big);
  CheckEquals(RES_2_D1, FGuid.D1);
  CheckEquals(RES_2_D2, FGuid.D2);
  CheckEquals(RES_2_D3, FGuid.D3);
  for i := 0 to 7 do
    CheckEquals(Bytes[i + 8], FGuid.D4[i]);

  CheckException(FailCreate4, EArgumentException, 'Byte array for GUID must be exactly 16 bytes long');
end;

{$PUSH}
{$WARNINGS OFF}
procedure TTestTGuidHelper.FailCreate5;
var
  A: Integer;
  B, C: SmallInt;
  D: TBytes;
begin
  SetLength(D, 7);
  TGUID.Create(A, B, C, D);
end;
{$POP}

procedure TTestTGuidHelper.TestCreate5;
var
  A: Integer;
  B, C: SmallInt;
  D: TBytes;
begin
  A := $00010203;
  B := $0405;
  C := $0607;
  SetLength(D, 8);
  D[0] := $08; D[1] := $09; D[2] := $0a; D[3] := $0b;
  D[4] := $0c; D[5] := $0d; D[6] := $0e; D[7] := $0f;

  CheckTrue(IsEqualGUID(
    TEST_GUID,
    TGUID.Create(A, B, C, D)
  ));

  CheckException(FailCreate5, EArgumentException, 'Byte array for GUID must be exactly 8 bytes long');
end;

procedure TTestTGuidHelper.TestCreate6;
var
  A: Integer;
  B, C: SmallInt;
  D, E, F, G, H, I, J, K: Byte;
begin
  A := $00010203;
  B := $0405;
  C := $0607;
  D := $08; E := $09; F := $0a; G := $0b; H := $0c; I := $0d; J := $0e; K := $0f;

  CheckTrue(IsEqualGUID(
    TEST_GUID,
    TGUID.Create(A, B, C, D, E, F, G, H, I, J, K)
  ));
end;

procedure TTestTGuidHelper.TestCreate7;
var
  A: Cardinal;
  B, C: Word;
  D, E, F, G, H, I, J, K: Byte;
begin
  A := $00010203;
  B := $0405;
  C := $0607;
  D := $08; E := $09; F := $0a; G := $0b; H := $0c; I := $0d; J := $0e; K := $0f;

  CheckTrue(IsEqualGUID(
    TEST_GUID,
    TGUID.Create(A, B, C, D, E, F, G, H, I, J, K)
  ));
end;

procedure TTestTGuidHelper.TestNewGuid;
begin
  CheckFalse(IsEqualGUID(
    GUID_NULL,
    TGUID.NewGuid
  ));
end;

procedure TTestTGuidHelper.TestToByteArray;
const
  RES_SWAPPED: array [0..15] of Byte = (
    $03, $02, $01, $00, $05, $04, $07, $06, $08, $09, $0a, $0b, $0c, $0d, $0e, $0f
  );
var
  ResBytes: TBytes;
  i: Integer;
begin
  ResBytes := TEST_GUID.ToByteArray;
  for i := 0 to High(ResBytes) do
    {$IFDEF ENDIAN_BIG}
    CheckEquals(i, ResBytes[i]);
    {$ELSE}
    CheckEquals(RES_SWAPPED[i], ResBytes[i]);
    {$ENDIF}

  ResBytes := TEST_GUID.ToByteArray(TEndian.Little);
  for i := 0 to High(ResBytes) do
    CheckEquals(RES_SWAPPED[i], ResBytes[i]);

  ResBytes := TEST_GUID.ToByteArray(TEndian.Big);
  for i := 0 to High(ResBytes) do
    CheckEquals(i, ResBytes[i]);
end;

procedure TTestTGuidHelper.TestToString;
begin
  CheckEquals('{00010203-0405-0607-0809-0A0B0C0D0E0F}', TEST_GUID.ToString);
end;

procedure TTestTGuidHelper.TestEmpty;
begin
  CheckTrue(IsEqualGUID(TEST_GUID_EMPTY, TGUID.Empty));
end;

initialization
  RegisterTest('System.Helpers', TTestTGuidHelper);

end.

