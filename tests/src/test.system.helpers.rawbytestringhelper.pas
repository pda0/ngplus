{**********************************************************************
    Copyright(c) 2016 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit Test.System.Helpers.RawByteStringHelper;

{$I ngplus.inc}

interface

uses
  fpcunit, testregistry, System.Helpers,
  Classes, SysUtils;

type
  TTestRawByteStringHelper = class(TTestCase)
  {$IFDEF FPC_HAS_FEATURE_ANSISTRINGS}
  private
    procedure JoinOffRange;
    procedure ToBooleanEmpty;
    {$IFNDEF FPUNONE}
    {$IFDEF FPC_HAS_TYPE_DOUBLE}
    procedure TDoubleEmpty;
    {$ENDIF !FPC_HAS_TYPE_DOUBLE}
    {$IF DEFINED(FPC_HAS_TYPE_EXTENDED) OR DEFINED(FPC_HAS_TYPE_DOUBLE)}
    procedure TExtendedEmpty;
    {$IFEND !FPC_HAS_TYPE_EXTENDED FPC_HAS_TYPE_DOUBLE}
    {$IFDEF FPC_HAS_TYPE_SINGLE}
    procedure TSingleEmpty;
    {$ENDIF !FPC_HAS_TYPE_SINGLE}
    {$ENDIF !~FPUNONE}
    procedure TIntegerEmpty;
    procedure TIntegerToBig;
    procedure TInt64Empty;
    procedure TInt64ToBig;
  public
    procedure TestJoin;
    procedure TestToLower;
  published
    procedure TestCreate;

    procedure TestContains;
    procedure TestCopy;

    procedure TestEquals;
    procedure TestFormat;

    procedure TestEmpty;
    //procedure TestJoin;

    procedure TestToBoolean;

    procedure TestToDouble;
    procedure TestToExtended;
    procedure TestToSingle;
    procedure TestToInteger;

    procedure TestToLowerInvariant;

    procedure TestToUpperInvariant;
    procedure TestTrim;
    procedure TestTrimLeft;
    procedure TestTrimRight;

    procedure TestChars;
    procedure TestLength;
    procedure TestParse;
    procedure TestToInt64;

    { Non Delphi }
    procedure TestByteLength;
    procedure TestCPLength;
    procedure TestCodePoints;
  {$ELSE}
  public
    procedure NotSupported;
  {$ENDIF !FPC_HAS_FEATURE_ANSISTRINGS}
  end;

implementation

{$IFDEF FPC_HAS_FEATURE_ANSISTRINGS}
const
  TEST_STR: RawByteString = 'This is a string.';
  TEST_INT64: Int64 = 3000000000;

{ TTestRawByteStringHelper }

procedure TTestRawByteStringHelper.TestCreate;
var
  Str: RawByteString;
begin
  Str := RawByteString.Create(WideChar('a'), 10);
  CheckEquals(RawByteString('aaaaaaaaaa'), Str);

  Str := RawByteString.Create([]);
  CheckEquals(RawByteString(''), Str);

  Str := RawByteString.Create(['1', '2', '3', '4', '5']);
  CheckEquals(RawByteString('12345'), Str);

  Str := RawByteString.Create(['1', '2', '3', '4', '5'], 1, 2);
  CheckEquals(RawByteString('23'), Str);
end;

procedure TTestRawByteStringHelper.TestContains;
var
  Str: RawByteString;
begin
  Str := TEST_STR;
  SetCodePage(Str, CP_NONE, False);

  CheckTrue(Str.Contains('This'));
  CheckTrue(Str.Contains('str'));
  CheckFalse(Str.Contains('suxx'));
  CheckFalse(Str.Contains(''));

  Str := '';
  SetCodePage(Str, CP_NONE, False);
  CheckFalse(Str.Contains(''));
end;

procedure TTestRawByteStringHelper.TestCopy;
begin
  CheckEquals(TEST_STR, RawByteString.Copy(TEST_STR));
end;

procedure TTestRawByteStringHelper.TestEquals;
var
  Str1, Str2: RawByteString;
begin
  Str1 := 'A';
  Str2 := 'A';
  SetCodePage(Str1, CP_NONE, False);
  SetCodePage(Str2, CP_NONE, False);

  CheckTrue(RawByteString.Equals(Str1, Str1));
  CheckTrue(RawByteString.Equals('B', 'B'));
  CheckFalse(RawByteString.Equals('B', 'C'));
  CheckTrue(Str1.Equals(Str1));
  CheckTrue(Str1 = Str2);
  CheckFalse(Str1 <> Str2);
  CheckTrue(Str1 = 'A');
  CheckTrue('A' = Str1);
end;

procedure TTestRawByteStringHelper.TestFormat;
var
  Str1, Str2: RawByteString;
begin
  Str1 := 'This is a %s';
  Str2 := 'string.';
  { http://bugs.freepascal.org/view.php?id=29770
  SetCodePage(Str1, CP_NONE, False);
  SetCodePage(Str2, CP_NONE, False); }

  CheckEquals(TEST_STR, RawByteString.Format(Str1, ['string.']));
  CheckEquals(TEST_STR, RawByteString.Format(Str1, [RawByteString(Str2)]));
end;

procedure TTestRawByteStringHelper.TestEmpty;
var
  Str: RawByteString;
begin
  Str := '';
  SetCodePage(Str, CP_NONE, False);
  CheckTrue(Str.IsEmpty);
  CheckTrue(RawByteString.IsNullOrEmpty(Str));
  CheckTrue(RawByteString.IsNullOrWhiteSpace(Str));

  Str := #0;
  SetCodePage(Str, CP_NONE, False);
  CheckFalse(Str.IsEmpty);
  CheckFalse(RawByteString.IsNullOrEmpty(Str));
  CheckTrue(RawByteString.IsNullOrWhiteSpace(Str));

  Str := TEST_STR;
  SetCodePage(Str, CP_NONE, False);
  CheckFalse(Str.IsEmpty);
  CheckFalse(RawByteString.IsNullOrEmpty(Str));
  CheckFalse(RawByteString.IsNullOrWhiteSpace(Str));

  Str := #$00#$01#$02#$03#$04#$05#$06#$07#$08#$09#$0a#$0b#$0c#$0d#$0e#$0f#$10+
    #$11#$12#$13#$14#$5#$6#$7#$8#$9#$1a#$1b#$1c#$1d#$1e#$1f#$20;
  SetCodePage(Str, CP_NONE, False);
  CheckTrue(RawByteString.IsNullOrWhiteSpace(Str));
end;

procedure TTestRawByteStringHelper.JoinOffRange;
begin
  RawByteString.Join(',', ['String1', 'String2', 'String3'], 3, 2);
end;

procedure TTestRawByteStringHelper.TestJoin;
var
  AStr: RawByteString;
begin
  CheckEquals(RawByteString(''),
    RawByteString.Join(',', [], 0, 0));
  CheckEquals(RawByteString('String1,String2,String3'),
    RawByteString.Join(',', ['String1', 'String2', 'String3']));
  CheckEquals(RawByteString('String1String2String3'),
    RawByteString.Join('', ['String1', 'String2', 'String3']));
  CheckEquals(RawByteString('String1->String2->String3'),
    RawByteString.Join('->', ['String1', 'String2', 'String3']));
  CheckEquals(RawByteString('String2,String3'),
    RawByteString.Join(',', ['String1', 'String2', 'String3'], 1, 2));
  CheckException(@JoinOffRange, ERangeError);
  CheckEquals(RawByteString('String1'),
    RawByteString.Join(',', ['String1', 'String2', 'String3'], 0, 1));
  CheckEquals(RawByteString(''),
    RawByteString.Join(',', ['String1', 'String2', 'String3'], 0, 0));

  AStr := RawByteString('Строка');
  CheckEquals(
    RawByteString('String,Строка,True,10,') + RawByteString(SysUtils.FloatToStr(3.14)) + RawByteString(',TTestRawByteStringHelper'),
    RawByteString.Join(',', ['String', AStr, True, 10, 3.14, Self])
  );
end;

procedure TTestRawByteStringHelper.ToBooleanEmpty;
begin
  RawByteString.ToBoolean('');
end;

procedure TTestRawByteStringHelper.TestToBoolean;
var
  Str: RawByteString;
begin
  Str := '0';
  CheckFalse(Str.ToBoolean);

  CheckFalse(RawByteString.ToBoolean('0'));
  CheckFalse(RawByteString.ToBoolean('000'));
  CheckFalse(RawByteString.ToBoolean('0' + AnsiChar(FormatSettings.DecimalSeparator) + '0'));
  CheckFalse(RawByteString.ToBoolean('-00' + AnsiChar(FormatSettings.DecimalSeparator) + '00'));
  CheckFalse(RawByteString.ToBoolean('+00' + AnsiChar(FormatSettings.DecimalSeparator) + '00'));
  CheckFalse(RawByteString.ToBoolean('00' + AnsiChar(FormatSettings.DecimalSeparator) + '00'));
  CheckTrue(RawByteString.ToBoolean('-1'));
  CheckTrue(RawByteString.ToBoolean('1'));
  CheckTrue(RawByteString.ToBoolean('123'));
  CheckTrue(RawByteString.ToBoolean('11' + AnsiChar(FormatSettings.DecimalSeparator) + '12'));
  CheckTrue(RawByteString.ToBoolean(RawByteString(SysUtils.TrueBoolStrs[0])));
  CheckFalse(RawByteString.ToBoolean(RawByteString(SysUtils.FalseBoolStrs[0])));
  CheckTrue(RawByteString.ToBoolean('TRUE'));
  CheckException(@ToBooleanEmpty, EConvertError);
end;

{$IFNDEF FPUNONE}
{$IFDEF FPC_HAS_TYPE_DOUBLE}
procedure TTestRawByteStringHelper.TDoubleEmpty;
begin
  RawByteString.ToDouble('');
end;

procedure TTestRawByteStringHelper.TestToDouble;
var
  Str, StrVal: RawByteString;
begin
  Str := '1';
  CheckEquals(StrToFloat('1'), Str.ToDouble);

  StrVal := '1' + AnsiChar(FormatSettings.DecimalSeparator) + '5';
  CheckEquals(StrToFloat(StrVal), RawByteString.ToDouble(StrVal));
  StrVal := '-0' + AnsiChar(FormatSettings.DecimalSeparator) + '5';
  CheckEquals(StrToFloat(StrVal), RawByteString.ToDouble(StrVal));
  CheckException(@TDoubleEmpty, EConvertError);
end;
{$ELSE}
procedure TTestRawByteStringHelper.TestToDouble;
begin
  Ignore('Double type is not supported.')
end;
{$ENDIF !FPC_HAS_TYPE_DOUBLE}
{$IF DEFINED(FPC_HAS_TYPE_EXTENDED) OR DEFINED(FPC_HAS_TYPE_DOUBLE)}
procedure TTestRawByteStringHelper.TExtendedEmpty;
begin
  RawByteString.ToExtended('');
end;

procedure TTestRawByteStringHelper.TestToExtended;
var
  Str, StrVal: RawByteString;
begin
  Str := '1';
  CheckEquals(StrToFloat('1'), Str.ToExtended);

  StrVal := '1' + AnsiChar(FormatSettings.DecimalSeparator) + '5';
  CheckEquals(StrToFloat(StrVal), RawByteString.ToExtended(StrVal));
  StrVal := '-0' + AnsiChar(FormatSettings.DecimalSeparator) + '5';
  CheckEquals(StrToFloat(StrVal), RawByteString.ToExtended(StrVal));
  CheckException(@TExtendedEmpty, EConvertError);
end;
{$ELSE}
procedure TTestRawByteStringHelper.TestToExtended;
begin
  Ignore('Extended type is not supported.');
end;
{$IFEND !FPC_HAS_TYPE_EXTENDED FPC_HAS_TYPE_DOUBLE}
{$IFDEF FPC_HAS_TYPE_SINGLE}
procedure TTestRawByteStringHelper.TSingleEmpty;
begin
  RawByteString.ToSingle('');
end;

procedure TTestRawByteStringHelper.TestToSingle;
var
  Str, StrVal: RawByteString;
begin
  Str := '1';
  CheckEquals(StrToFloat('1'), Str.ToSingle);

  StrVal := '1' + AnsiChar(FormatSettings.DecimalSeparator) + '5';
  CheckEquals(StrToFloat(StrVal), RawByteString.ToSingle(StrVal));
  StrVal := '-0' + AnsiChar(FormatSettings.DecimalSeparator) + '5';
  CheckEquals(StrToFloat(StrVal), RawByteString.ToSingle(StrVal));
  CheckException(@TSingleEmpty, EConvertError);
end;
{$ELSE}
procedure TTestRawByteStringHelper.TestToSingle;
begin
  Ignore('Single type is not supported.');
end;
{$ENDIF !FPC_HAS_TYPE_SINGLE}
{$ENDIF !~FPUNONE}

procedure TTestRawByteStringHelper.TIntegerEmpty;
begin
  RawByteString.ToInteger('');
end;

procedure TTestRawByteStringHelper.TIntegerToBig;
begin
  RawByteString.ToInteger('3000000000');
end;

procedure TTestRawByteStringHelper.TestToInteger;
var
  Str: RawByteString;
begin
  Str := '1';
  SetCodePage(Str, CP_NONE, False);
  CheckEquals(StrToInt('1'), Str.ToInteger);

  CheckEquals(StrToInt('2'), RawByteString.ToInteger('2'));
  CheckEquals(StrToInt('-1'), RawByteString.ToInteger('-1'));
  CheckException(@TIntegerEmpty, EConvertError);
  CheckException(@TIntegerToBig, EConvertError);
end;

procedure TTestRawByteStringHelper.TestToLower;
begin

end;

procedure TTestRawByteStringHelper.TestToLowerInvariant;
var
  Str, StrRes: RawByteString;
begin
  Str := 'HeLlo ПрИвЕт aLlÔ 您好 123';
  StrRes := 'hello ПрИвЕт allÔ 您好 123';
  SetCodePage(Str, CP_NONE, False);
  SetCodePage(StrRes, CP_NONE, False);

  CheckEquals(StrRes, Str.ToLowerInvariant);
end;

procedure TTestRawByteStringHelper.TestToUpperInvariant;
var
  Str, StrRes: RawByteString;
begin
  Str := 'HeLlo ПрИвЕт aLlÔ 您好 123';
  StrRes := 'HELLO ПрИвЕт ALLÔ 您好 123';
  SetCodePage(Str, CP_NONE, False);
  SetCodePage(StrRes, CP_NONE, False);

  CheckEquals(StrRes, Str.ToUpperInvariant);
end;

procedure TTestRawByteStringHelper.TestTrim;
var
  Str1, Str2, Str3: RawByteString;
begin
  Str1 := '';
  Str2 := 'test';
  Str3 := '  test  ';

  CheckEquals('', Str1.Trim);
  CheckEquals('test', Str2.Trim);
  CheckEquals('test', Str3.Trim);
  CheckEquals('es', Str2.Trim(['t']));
  CheckEquals('s', Str2.Trim(['t', 'e']));
  CheckEquals('', Str2.Trim(['t', 'e', 's', '@']));
  CheckEquals('  test  ', Str3.Trim(['t', 'e', 's', '@']));
end;

procedure TTestRawByteStringHelper.TestTrimLeft;
var
  Str1, Str2, Str3: RawByteString;
begin
  Str1 := '';
  Str2 := 'test';
  Str3 := '  test  ';

  CheckEquals('', Str1.TrimLeft);
  CheckEquals('test', Str2.TrimLeft);
  CheckEquals('test  ', Str3.TrimLeft);
  CheckEquals('est', Str2.TrimLeft(['t']));
  CheckEquals('st', Str2.TrimLeft(['t', 'e']));
  CheckEquals('', Str2.TrimLeft(['t', 'e', 's', '@']));
  CheckEquals('  test  ', Str3.TrimLeft(['t', 'e', 's', '@']));
end;

procedure TTestRawByteStringHelper.TestTrimRight;
var
  Str1, Str2, Str3: RawByteString;
begin
  Str1 := '';
  Str2 := 'test';
  Str3 := '  test  ';

  CheckEquals('', Str1.TrimRight);
  CheckEquals('test', Str2.TrimRight);
  CheckEquals('  test', Str3.TrimRight);
  CheckEquals('tes', Str2.TrimRight(['t']));
  CheckEquals('te', Str2.TrimRight(['t', 's']));
  CheckEquals('', Str2.TrimRight(['t', 'e', 's', '@']));
  CheckEquals('  test  ', Str3.TrimRight(['t', 'e', 's', '@']));
end;

procedure TTestRawByteStringHelper.TestChars;
var
  Str: RawByteString;
begin
  Str := 'hello';
  SetCodePage(Str, CP_NONE, False);

  CheckEquals(AnsiChar('h'), Str.Chars[0]);
  CheckEquals(AnsiChar('e'), Str.Chars[1]);
  CheckEquals(AnsiChar('l'), Str.Chars[2]);
  CheckEquals(AnsiChar('l'), Str.Chars[3]);
  CheckEquals(AnsiChar('o'), Str.Chars[4]);
end;

procedure TTestRawByteStringHelper.TestLength;
var
  AnsiStr: RawByteString;
begin
  AnsiStr := 'hello';
  SetCodePage(AnsiStr, CP_NONE, False);

  CheckEquals(5, AnsiStr.Length);
end;

procedure TTestRawByteStringHelper.TestParse;
begin
  CheckEquals('-1', RawByteString.Parse(Integer(-1)));
  CheckEquals('3000000000', RawByteString.Parse(TEST_INT64));
  CheckEquals('-1', RawByteString.Parse(True));
  CheckEquals('0', RawByteString.Parse(False));
  {$IF NOT DEFINED(FPUNONE) AND (DEFINED(FPC_HAS_TYPE_EXTENDED) OR DEFINED(FPC_HAS_TYPE_DOUBLE))}
  CheckEquals(FloatToStr(1.5), RawByteString.Parse(1.5));
  {$ELSE}
  Ignore('Extended/Double type is not supported.');
  {$IFEND !~FPUNONE FPC_HAS_TYPE_EXTENDED FPC_HAS_TYPE_DOUBLE}
end;

procedure TTestRawByteStringHelper.TInt64Empty;
begin
  RawByteString.ToInt64('');
end;

procedure TTestRawByteStringHelper.TInt64ToBig;
begin
  RawByteString.ToInt64('9223372036854775808');
end;

procedure TTestRawByteStringHelper.TestToInt64;
var
  Str: RawByteString;
begin
  Str := '3000000000';
  SetCodePage(Str, CP_NONE, False);
  CheckTrue(TEST_INT64 = Str.ToInt64);

  CheckTrue(TEST_INT64 = RawByteString.ToInt64('3000000000'));
  CheckTrue(-TEST_INT64 = RawByteString.ToInt64('-3000000000'));
  CheckException(@TInt64Empty, EConvertError);
  CheckException(@TInt64ToBig, EConvertError);
end;

{ Non Delphi }

procedure TTestRawByteStringHelper.TestByteLength;
var
  Str: RawByteString;
begin
  Str := 'hello';
  SetCodePage(Str, CP_NONE, False);

  CheckEquals(5, Str.ByteLength);
end;

procedure TTestRawByteStringHelper.TestCPLength;
var
  Str: RawByteString;
begin
  Str := 'hello';
  SetCodePage(Str, CP_NONE, False);

  CheckEquals(5, Str.CPLength);
end;

procedure TTestRawByteStringHelper.TestCodePoints;
var
  Str: RawByteString;
begin
  Str := 'hello';
  SetCodePage(Str, CP_NONE, False);

  CheckEquals(RawByteString('h'), Str.CodePoints[0]);
  CheckEquals(RawByteString('e'), Str.CodePoints[1]);
  CheckEquals(RawByteString('l'), Str.CodePoints[2]);
  CheckEquals(RawByteString('l'), Str.CodePoints[3]);
  CheckEquals(RawByteString('o'), Str.CodePoints[4]);
end;

{$ELSE}
procedure TTestRawByteStringHelper.NotSupported;
begin
  Ignore('AnsiString is not supported.');
end;
{$ENDIF !FPC_HAS_FEATURE_ANSISTRINGS}

initialization
  RegisterTest('System.Helpers', TTestRawByteStringHelper.Suite);

end.

