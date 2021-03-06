{**********************************************************************
    Copyright(c) 2016 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit Test.System.Helpers.ShortStringHelper;

{$I ngplus.inc}

interface

uses
  fpcunit, testregistry, System.Helpers,
  Classes, SysUtils;

type
  TTestShortStringHelper = class(TTestCase)
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
    procedure TestCopyTo;
    procedure TestCountChar;
    procedure TestDeQuotedString;

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
  end;

implementation

const
  TEST_STR: ShortString = 'This is a string.';
  TEST_INT64: Int64 = 3000000000;

{ TTestShortStringHelper }

procedure TTestShortStringHelper.TestCreate;
var
  Str: ShortString;
begin
  Str := ShortString.Create(WideChar('a'), 10);
  CheckEquals(ShortString('aaaaaaaaaa'), Str);

  Str := ShortString.Create([]);
  CheckEquals(ShortString(''), Str);

  Str := ShortString.Create(['1', '2', '3', '4', '5']);
  CheckEquals(ShortString('12345'), Str);

  Str := ShortString.Create(['1', '2', '3', '4', '5'], 1, 2);
  CheckEquals(ShortString('23'), Str);
end;

procedure TTestShortStringHelper.TestContains;
var
  Str: ShortString;
begin
  Str := TEST_STR;

  CheckTrue(Str.Contains('This'));
  CheckTrue(Str.Contains('str'));
  CheckFalse(Str.Contains('suxx'));
  CheckFalse(Str.Contains(''));

  Str := '';
  CheckFalse(Str.Contains(''));
end;

procedure TTestShortStringHelper.TestCopy;
begin
  CheckEquals(TEST_STR, ShortString.Copy(TEST_STR));
end;

procedure TTestShortStringHelper.TestCopyTo;
var
  Str1, Str2: ShortString;
begin
  Str1 := TEST_STR;
  Str2 := 'S';
  Str2.CopyTo(0, Str1[10 + 1{Low(Str1)}], 0, Str2.Length);

  CheckEquals(ShortString('This is a String.'), Str1);
end;

procedure TTestShortStringHelper.TestCountChar;
var
  Str: ShortString;
begin
  Str := 'This string contains 5 occurrences of s';

  CheckEquals(5, Str.CountChar('s'));
end;

procedure TTestShortStringHelper.TestDeQuotedString;
var
  Str1, Str2, Str3: ShortString;
begin
  Str1 := 'This function illustrates the functionality of the QuotedString method.';
  Str2 := '''This function illustrates the functionality of the QuotedString method.''';
  Str3 := 'fThis ffunction illustrates the ffunctionality off the QuotedString method.f';
  CheckEquals(Str1, Str2.DeQuotedString);
  CheckEquals(Str1, Str3.DeQuotedString('f'));
end;

procedure TTestShortStringHelper.TestEquals;
var
  Str1, Str2: ShortString;
begin
  Str1 := 'A';
  Str2 := 'A';

  CheckTrue(ShortString.Equals(Str1, Str1));
  CheckTrue(ShortString.Equals('B', 'B'));
  CheckFalse(ShortString.Equals('B', 'C'));
  CheckTrue(Str1.Equals(Str1));
  CheckTrue(Str1 = Str2);
  CheckFalse(Str1 <> Str2);
  CheckTrue(Str1 = 'A');
  CheckTrue('A' = Str1);
end;

procedure TTestShortStringHelper.TestFormat;
var
  Str1, Str2: ShortString;
begin
  Str1 := 'This is a %s';
  Str2 := 'string.';

  CheckEquals(TEST_STR, ShortString.Format(Str1, ['string.']));
  CheckEquals(TEST_STR, ShortString.Format(Str1, [ShortString(Str2)]));
end;

procedure TTestShortStringHelper.TestEmpty;
var
  Str: ShortString;
begin
  Str := '';
  CheckTrue(Str.IsEmpty);
  CheckTrue(ShortString.IsNullOrEmpty(Str));
  CheckTrue(ShortString.IsNullOrWhiteSpace(Str));

  Str := #0;
  CheckFalse(Str.IsEmpty);
  CheckFalse(ShortString.IsNullOrEmpty(Str));
  CheckTrue(ShortString.IsNullOrWhiteSpace(Str));

  Str := TEST_STR;
  CheckFalse(Str.IsEmpty);
  CheckFalse(ShortString.IsNullOrEmpty(Str));
  CheckFalse(ShortString.IsNullOrWhiteSpace(Str));

  Str := #$00#$01#$02#$03#$04#$05#$06#$07#$08#$09#$0a#$0b#$0c#$0d#$0e#$0f#$10+
    #$11#$12#$13#$14#$5#$6#$7#$8#$9#$1a#$1b#$1c#$1d#$1e#$1f#$20;
  CheckTrue(ShortString.IsNullOrWhiteSpace(Str));
end;

procedure TTestShortStringHelper.JoinOffRange;
begin
  ShortString.Join(',', ['String1', 'String2', 'String3'], 3, 2);
end;

procedure TTestShortStringHelper.TestJoin;
var
  AStr: ShortString;
begin
  CheckEquals(ShortString(''),
    ShortString.Join(',', [], 0, 0));
  CheckEquals(ShortString('String1,String2,String3'),
    ShortString.Join(',', ['String1', 'String2', 'String3']));
  CheckEquals(ShortString('String1String2String3'),
    ShortString.Join('', ['String1', 'String2', 'String3']));
  CheckEquals(ShortString('String1->String2->String3'),
    ShortString.Join('->', ['String1', 'String2', 'String3']));
  CheckEquals(ShortString('String2,String3'),
    ShortString.Join(',', ['String1', 'String2', 'String3'], 1, 2));
  CheckException(@JoinOffRange, ERangeError);
  CheckEquals(ShortString('String1'),
    ShortString.Join(',', ['String1', 'String2', 'String3'], 0, 1));
  CheckEquals(ShortString(''),
    ShortString.Join(',', ['String1', 'String2', 'String3'], 0, 0));

  AStr := ShortString('Строка');
  CheckEquals(
    ShortString('String,Строка,True,10,') + ShortString(SysUtils.FloatToStr(3.14)) + ShortString(',TTestShortStringHelper'),
    ShortString.Join(',', ['String', AStr, True, 10, 3.14, Self])
  );
end;

procedure TTestShortStringHelper.ToBooleanEmpty;
begin
  ShortString.ToBoolean('');
end;

procedure TTestShortStringHelper.TestToBoolean;
var
  Str: ShortString;
begin
  Str := '0';
  CheckFalse(Str.ToBoolean);

  CheckFalse(ShortString.ToBoolean('0'));
  CheckFalse(ShortString.ToBoolean('000'));
  CheckFalse(ShortString.ToBoolean('0' + AnsiChar(FormatSettings.DecimalSeparator) + '0'));
  CheckFalse(ShortString.ToBoolean('-00' + AnsiChar(FormatSettings.DecimalSeparator) + '00'));
  CheckFalse(ShortString.ToBoolean('+00' + AnsiChar(FormatSettings.DecimalSeparator) + '00'));
  CheckFalse(ShortString.ToBoolean('00' + AnsiChar(FormatSettings.DecimalSeparator) + '00'));
  CheckTrue(ShortString.ToBoolean('-1'));
  CheckTrue(ShortString.ToBoolean('1'));
  CheckTrue(ShortString.ToBoolean('123'));
  CheckTrue(ShortString.ToBoolean('11' + AnsiChar(FormatSettings.DecimalSeparator) + '12'));
  CheckTrue(ShortString.ToBoolean(ShortString(SysUtils.TrueBoolStrs[0])));
  CheckFalse(ShortString.ToBoolean(ShortString(SysUtils.FalseBoolStrs[0])));
  CheckTrue(ShortString.ToBoolean('TRUE'));
  CheckException(@ToBooleanEmpty, EConvertError);
end;

{$IFNDEF FPUNONE}
{$IFDEF FPC_HAS_TYPE_DOUBLE}
procedure TTestShortStringHelper.TDoubleEmpty;
begin
  ShortString.ToDouble('');
end;

procedure TTestShortStringHelper.TestToDouble;
var
  Str, StrVal: ShortString;
begin
  Str := '1';
  CheckEquals(StrToFloat('1'), Str.ToDouble);

  StrVal := '1' + AnsiChar(FormatSettings.DecimalSeparator) + '5';
  CheckEquals(StrToFloat(StrVal), ShortString.ToDouble(StrVal));
  StrVal := '-0' + AnsiChar(FormatSettings.DecimalSeparator) + '5';
  CheckEquals(StrToFloat(StrVal), ShortString.ToDouble(StrVal));
  CheckException(@TDoubleEmpty, EConvertError);
end;
{$ELSE}
procedure TTestShortStringHelper.TestToDouble;
begin
  Ignore('Double type is not supported.')
end;
{$ENDIF !FPC_HAS_TYPE_DOUBLE}
{$IF DEFINED(FPC_HAS_TYPE_EXTENDED) OR DEFINED(FPC_HAS_TYPE_DOUBLE)}
procedure TTestShortStringHelper.TExtendedEmpty;
begin
  ShortString.ToExtended('');
end;

procedure TTestShortStringHelper.TestToExtended;
var
  Str, StrVal: ShortString;
begin
  Str := '1';
  CheckEquals(StrToFloat('1'), Str.ToExtended);

  StrVal := '1' + AnsiChar(FormatSettings.DecimalSeparator) + '5';
  CheckEquals(StrToFloat(StrVal), ShortString.ToExtended(StrVal));
  StrVal := '-0' + AnsiChar(FormatSettings.DecimalSeparator) + '5';
  CheckEquals(StrToFloat(StrVal), ShortString.ToExtended(StrVal));
  CheckException(@TExtendedEmpty, EConvertError);
end;
{$ELSE}
procedure TTestShortStringHelper.TestToExtended;
begin
  Ignore('Extended type is not supported.');
end;
{$IFEND !FPC_HAS_TYPE_EXTENDED FPC_HAS_TYPE_DOUBLE}
{$IFDEF FPC_HAS_TYPE_SINGLE}
procedure TTestShortStringHelper.TSingleEmpty;
begin
  ShortString.ToSingle('');
end;

procedure TTestShortStringHelper.TestToSingle;
var
  Str, StrVal: ShortString;
begin
  Str := '1';
  CheckEquals(StrToFloat('1'), Str.ToSingle);

  StrVal := '1' + AnsiChar(FormatSettings.DecimalSeparator) + '5';
  CheckEquals(StrToFloat(StrVal), ShortString.ToSingle(StrVal));
  StrVal := '-0' + AnsiChar(FormatSettings.DecimalSeparator) + '5';
  CheckEquals(StrToFloat(StrVal), ShortString.ToSingle(StrVal));
  CheckException(@TSingleEmpty, EConvertError);
end;
{$ELSE}
procedure TTestShortStringHelper.TestToSingle;
begin
  Ignore('Single type is not supported.');
end;
{$ENDIF !FPC_HAS_TYPE_SINGLE}
{$ENDIF !~FPUNONE}

procedure TTestShortStringHelper.TIntegerEmpty;
begin
  ShortString.ToInteger('');
end;

procedure TTestShortStringHelper.TIntegerToBig;
begin
  ShortString.ToInteger('3000000000');
end;

procedure TTestShortStringHelper.TestToInteger;
var
  Str: ShortString;
begin
  Str := '1';
  CheckEquals(StrToInt('1'), Str.ToInteger);

  CheckEquals(StrToInt('2'), ShortString.ToInteger('2'));
  CheckEquals(StrToInt('-1'), ShortString.ToInteger('-1'));
  CheckException(@TIntegerEmpty, EConvertError);
  CheckException(@TIntegerToBig, EConvertError);
end;

procedure TTestShortStringHelper.TestToLower;
begin

end;

procedure TTestShortStringHelper.TestToLowerInvariant;
var
  Str: ShortString;
begin
  if DefaultSystemCodePage = CP_UTF8 then
  begin
    Str := 'HeLlo ПрИвЕт aLlÔ 您好 123';
    CheckEquals(ShortString('hello привет allô 您好 123'), Str.ToLowerInvariant);
  end
  else begin
    Str := 'HeLlo 123';
    CheckEquals(ShortString('hello 123'), Str.ToLowerInvariant);
  end;
end;

procedure TTestShortStringHelper.TestToUpperInvariant;
var
  Str: ShortString;
begin
  if DefaultSystemCodePage = CP_UTF8 then
  begin
    Str := 'HeLlo ПрИвЕт aLlÔ 您好 123';
    CheckEquals(ShortString('HELLO ПРИВЕТ ALLÔ 您好 123'), Str.ToUpperInvariant);
  end
  else begin
    Str := 'HeLlo 123';
    CheckEquals(ShortString('HELLO 123'), Str.ToUpperInvariant);
  end;
end;

procedure TTestShortStringHelper.TestTrim;
var
  Str1, Str2, Str3: ShortString;
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

procedure TTestShortStringHelper.TestTrimLeft;
var
  Str1, Str2, Str3: ShortString;
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

procedure TTestShortStringHelper.TestTrimRight;
var
  Str1, Str2, Str3: ShortString;
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

procedure TTestShortStringHelper.TestChars;
var
  Str: ShortString;
begin
  Str := 'hello';

  CheckEquals(AnsiChar('h'), Str.Chars[0]);
  CheckEquals(AnsiChar('e'), Str.Chars[1]);
  CheckEquals(AnsiChar('l'), Str.Chars[2]);
  CheckEquals(AnsiChar('l'), Str.Chars[3]);
  CheckEquals(AnsiChar('o'), Str.Chars[4]);
end;

procedure TTestShortStringHelper.TestLength;
var
  Str: ShortString;
begin
  Str := 'привет';

  CheckEquals(6, Str.Length);
end;

procedure TTestShortStringHelper.TestParse;
begin
  CheckEquals('-1', ShortString.Parse(Integer(-1)));
  CheckEquals('3000000000', ShortString.Parse(TEST_INT64));
  CheckEquals('-1', ShortString.Parse(True));
  CheckEquals('0', ShortString.Parse(False));
  {$IF NOT DEFINED(FPUNONE) AND (DEFINED(FPC_HAS_TYPE_EXTENDED) OR DEFINED(FPC_HAS_TYPE_DOUBLE))}
  CheckEquals(FloatToStr(1.5), ShortString.Parse(1.5));
  {$ELSE}
  Ignore('Extended/Double type is not supported.');
  {$IFEND !~FPUNONE FPC_HAS_TYPE_EXTENDED FPC_HAS_TYPE_DOUBLE}
end;

procedure TTestShortStringHelper.TInt64Empty;
begin
  ShortString.ToInt64('');
end;

procedure TTestShortStringHelper.TInt64ToBig;
begin
  ShortString.ToInt64('9223372036854775808');
end;

procedure TTestShortStringHelper.TestToInt64;
var
  Str: ShortString;
begin
  Str := '3000000000';
  CheckTrue(TEST_INT64 = Str.ToInt64);

  CheckTrue(TEST_INT64 = ShortString.ToInt64('3000000000'));
  CheckTrue(-TEST_INT64 = ShortString.ToInt64('-3000000000'));
  CheckException(@TInt64Empty, EConvertError);
  CheckException(@TInt64ToBig, EConvertError);
end;

{ Non Delphi }

procedure TTestShortStringHelper.TestByteLength;
var
  Str: ShortString;
begin
  Str := 'привет';

  if DefaultSystemCodePage = CP_UTF8 then
    CheckEquals(12, Str.ByteLength)
  else
    CheckEquals(6, Str.ByteLength);
end;

procedure TTestShortStringHelper.TestCPLength;
var
  AnsiStr: ShortString;
begin
  AnsiStr := 'hello';

  CheckEquals(5, AnsiStr.Length);
end;

procedure TTestShortStringHelper.TestCodePoints;
var
  Str: ShortString;
begin
  Str := 'привет';

  if DefaultSystemCodePage = CP_UTF8 then
  begin
    CheckEquals(AnsiString(AnsiChar(#$d0) + AnsiChar(#$bf)), Str.CodePoints[0]); { п }
    CheckEquals(AnsiString(AnsiChar(#$d1) + AnsiChar(#$80)), Str.CodePoints[1]); { р }
    CheckEquals(AnsiString(AnsiChar(#$d0) + AnsiChar(#$b8)), Str.CodePoints[2]); { и }
    CheckEquals(AnsiString(AnsiChar(#$d0) + AnsiChar(#$b2)), Str.CodePoints[3]); { в }
    CheckEquals(AnsiString(AnsiChar(#$d0) + AnsiChar(#$b5)), Str.CodePoints[4]); { е }
    CheckEquals(AnsiString(AnsiChar(#$d1) + AnsiChar(#$82)), Str.CodePoints[5]); { т }
  end
  else begin
    CheckEquals(AnsiString(AnsiChar(#$ef)), Str.CodePoints[0]); { п }
    CheckEquals(AnsiString(AnsiChar(#$f0)), Str.CodePoints[1]); { р }
    CheckEquals(AnsiString(AnsiChar(#$e8)), Str.CodePoints[2]); { и }
    CheckEquals(AnsiString(AnsiChar(#$e2)), Str.CodePoints[3]); { в }
    CheckEquals(AnsiString(AnsiChar(#$e5)), Str.CodePoints[4]); { е }
    CheckEquals(AnsiString(AnsiChar(#$f2)), Str.CodePoints[5]); { т }
  end;
end;

initialization
  RegisterTest('System.Helpers', TTestShortStringHelper.Suite);

end.

