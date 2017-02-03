{**********************************************************************
    Copyright(c) 2016 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit Test.System.Helpers.WideStringHelper;

{$I ngplus.inc}

interface

uses
  fpcunit, testregistry, System.Helpers,
  Classes, SysUtils;

type
  TTestWideStringHelper = class(TTestCase)
  {$IFDEF FPC_HAS_FEATURE_WIDESTRINGS}
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
    procedure TestCompare;
    procedure TestCompareOrdinal;
    procedure TestCompareText;
    procedure TestCompareTo;
    //procedure TestContains;
    //procedure TestCopy;
    //procedure TestCopyTo;
    //procedure TestCountChar;
    //procedure TestDeQuotedString;
    procedure TestEnds;
    //procedure TestEquals;
    //procedure TestFormat;
    procedure TestIndexOf;
    procedure TestIndexOfAny;
    procedure TestInsert;
    procedure TestIsDelimiter;
    //procedure TestEmpty;
    procedure TestJoin;
    procedure TestLastDelimiter;
    procedure TestLastIndexOf;
    procedure TestLastIndexOfAny;
    procedure TestLowerCase;
    procedure TestPadding;
    procedure TestQuotedString;
    procedure TestRemove;
    procedure TestReplace;
    procedure TestSplit;
    procedure TestStartsWith;
    procedure TestSubstring;
    //procedure TestToBoolean;
    procedure TestToCharArray;
    //procedure TestToDouble;
    //procedure TestToExtended;
    //procedure TestToSingle;
    //procedure TestToInteger;
    procedure TestToLower;
    //procedure TestToLowerInvariant;
    procedure TestToUpper;
    //procedure TestToUpperInvariant;
    //procedure TestTrim;
    //procedure TestTrimLeft;
    //procedure TestTrimRight;
    procedure TestUpperCase;
    //procedure TestChars;
    //procedure TestLength;
    //procedure TestParse;
    //procedure TestToInt64;
    procedure TestIndexOfAnyUnquoted;
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
  {$ELSE}
  public
    procedure NotSupported;
  {$ENDIF !FPC_HAS_FEATURE_WIDESTRINGS}
  end;

implementation

{$IFDEF FPC_HAS_FEATURE_WIDESTRINGS}
const
  TEST_STR: WideString = 'This is a string.';
  TEST_INT64: Int64 = 3000000000;

  TEST_CP_LATIN_SMALL_LETTER_S = WideChar($0073);
  TEST_CP_COMBINING_DOT_BELOW = WideChar($0323);
  TEST_CP_COMBINING_DOT_ABOVE = WideChar($0307);
  TEST_CP_LATIN_SMALL_LETTER_S_WITH_DOT_BELOW_AND_DOT_ABOVE = WideChar($1e69);

  TEST_CPS: WideString = TEST_CP_LATIN_SMALL_LETTER_S +
    TEST_CP_COMBINING_DOT_BELOW + TEST_CP_COMBINING_DOT_ABOVE +
    TEST_CP_LATIN_SMALL_LETTER_S_WITH_DOT_BELOW_AND_DOT_ABOVE;

{ TTestWideStringHelper }

procedure TTestWideStringHelper.TestCreate;
var
  Str: WideString;
begin
  Str := WideString.Create(WideChar('a'), 10);
  CheckEquals(WideString('aaaaaaaaaa'), Str);

  Str := WideString.Create([]);
  CheckEquals(WideString(''), Str);

  Str := WideString.Create(['1', '2', '3', '4', '5']);
  CheckEquals(WideString('12345'), Str);

  Str := WideString.Create(['1', '2', '3', '4', '5'], 1, 2);
  CheckEquals(WideString('23'), Str);
end;

procedure TTestWideStringHelper.TestCompare;
var
  Str1, Str2: WideString;
begin
  Str1 := 'String A';
  Str2 := 'String B';
  CheckTrue(WideString.Compare(Str1, Str2) < 0);
  CheckEquals(0, WideString.Compare('String B', Str2));
  CheckFalse(WideString.Compare('String B', 'String A') < 0);

  Str2 := 'String a';
  CheckNotEquals(0, WideString.Compare(Str1, Str2));
  CheckEquals(0, WideString.Compare(Str1, Str2, True));
  CheckNotEquals(0, WideString.Compare(Str1, Str2, False));
end;

procedure TTestWideStringHelper.TestCompareOrdinal;
var
  Str1, Str2: WideString;
begin
  Str1 := 'String A';
  Str2 := 'String B';
  CheckEquals(0, WideString.CompareOrdinal('String B', Str2));
  CheckEquals(-1, WideString.CompareOrdinal(Str1, Str2));
  CheckEquals(1, WideString.CompareOrdinal(Str2, Str1));

  CheckEquals(0, WideString.CompareOrdinal(Str1, 0, Str2, 0, 7));
  CheckEquals(-1, WideString.CompareOrdinal(Str1, 0, Str2, 0, 8));
  CheckEquals(-1, WideString.CompareOrdinal(Str1, 6 + Low(Str1), Str2, 6 + Low(Str2), 1));
  CheckEquals(0, WideString.CompareOrdinal(Str1, 6 + Low(Str1), Str2, 6 + Low(Str2), 0));

  CheckEquals(-1, WideString.CompareOrdinal(Str1, 6 + Low(Str1), Str2, 6 + Low(Str2), 2));
  CheckEquals(0, WideString.CompareOrdinal(Str1, 7 + Low(Str1), Str2, 7 + Low(Str2), 1));
  CheckEquals(0, WideString.CompareOrdinal('', ''));
end;

procedure TTestWideStringHelper.TestCompareText;
begin
  CheckEquals(0, WideString.CompareText('', ''));
  CheckEquals(-1, WideString.CompareText('1', '2'));
  CheckEquals(1, WideString.CompareText('2', '1'));
  CheckEquals(0, WideString.CompareText(
    WideString('HeLlo 123'),
    WideString('hello 123')
  ));
  CheckFalse(0 = WideString.CompareText(
    WideString('HeLlo ПрИвЕт aLlÔ 您好 123'),
    WideString('hello привет allô 您好 123')
  ));
end;

procedure TTestWideStringHelper.TestCompareTo;
var
  Str: WideString;
begin
  Str := 'String A';
  CheckEquals(0, Str.CompareTo('String A'));
  CheckEquals(-1, Str.CompareTo('String B'));
  CheckEquals(-32, Str.CompareTo('String a'));
end;

procedure TTestWideStringHelper.TestContains;
var
  Str: WideString;
begin
  Str := TEST_STR;

  CheckTrue(Str.Contains('This'));
  CheckTrue(Str.Contains('str'));
  CheckFalse(Str.Contains('suxx'));
  CheckFalse(Str.Contains(''));

  Str := '';
  CheckFalse(Str.Contains(''));
end;

procedure TTestWideStringHelper.TestCopy;
begin
  CheckEquals(TEST_STR, WideString.Copy(TEST_STR));
end;

procedure TTestWideStringHelper.TestCopyTo;
var
  Str1, Str2: WideString;
begin
  Str1 := TEST_STR;
  Str2 := 'S';
  Str2.CopyTo(0, Str1[10 + Low(Str1)], 0, Str2.Length);

  CheckEquals(WideString('This is a String.'), Str1);
end;

procedure TTestWideStringHelper.TestCountChar;
var
  Str: WideString;
begin
  Str := 'This string contains 5 occurrences of s';

  CheckEquals(5, Str.CountChar('s'));
end;

procedure TTestWideStringHelper.TestDeQuotedString;
var
  Str1, Str2, Str3: WideString;
begin
  Str1 := 'This function illustrates the functionality of the QuotedString method.';
  Str2 := '''This function illustrates the functionality of the QuotedString method.''';
  Str3 := 'fThis ffunction illustrates the ffunctionality off the QuotedString method.f';
  CheckEquals(Str1, Str2.DeQuotedString);
  CheckEquals(Str1, Str3.DeQuotedString('f'));
end;

procedure TTestWideStringHelper.TestEnds;
var
  Str: WideString;
begin
  Str := TEST_STR;

  CheckTrue(WideString.EndsText('string.', Str));
  CheckTrue(Str.EndsWith('String.', True));
  CheckFalse(Str.EndsWith('String.', False));
  CheckTrue(Str.EndsWith('string.'));
  CheckFalse(Str.EndsWith('String.'));
  CheckFalse(Str.EndsWith('This is a string!!'));
end;

procedure TTestWideStringHelper.TestEquals;
var
  Str1, Str2: WideString;
begin
  Str1 := 'A';
  Str2 := 'A';

  CheckTrue(WideString.Equals(Str1, Str1));
  CheckTrue(WideString.Equals('B', 'B'));
  CheckFalse(WideString.Equals('B', 'C'));
  CheckTrue(Str1.Equals(Str1));
  CheckTrue(Str1 = Str2);
  CheckFalse(Str1 <> Str2);
  CheckTrue(Str1 = 'A');
  CheckTrue('A' = Str1);
end;

procedure TTestWideStringHelper.TestFormat;
var
  Str1, Str2: WideString;
begin
  Str1 := 'This is a %s';
  Str2 := 'string.';

  CheckEquals(TEST_STR, WideString.Format(Str1, ['string.']));
  CheckEquals(TEST_STR, WideString.Format(Str1, [WideString(Str2)]));
end;

procedure TTestWideStringHelper.TestIndexOf;
var
  Str: WideString;
begin
  Str := TEST_STR;

  CheckEquals(3, Str.IndexOf('s', 0, 5));
  CheckEquals(2, Str.IndexOf('is', 0));
  CheckEquals(16, Str.IndexOf('.'));
  CheckEquals(-1, Str.IndexOf('?'));
  CheckEquals(-1, Str.IndexOf(''));
  CheckEquals(-1, Str.IndexOf('s', 8, 2));
  CheckEquals(10, Str.IndexOf('s', 8, 3));
  CheckEquals(-1, Str.IndexOf('s', 8, 1));

  Str := '';
  CheckEquals(-1, Str.IndexOf('s'));
  CheckEquals(-1, Str.IndexOf('s', 0, 0));

  { Unicode combining test }
  Str := TEST_CPS + TEST_STR;
  CheckEquals(14, Str.IndexOf('s', 12, 3));
end;

procedure TTestWideStringHelper.TestIndexOfAny;
var
  Str: WideString;
begin
  Str := TEST_STR;

  CheckEquals(3, Str.IndexOfAny(['w', 's', 'a']));
  CheckEquals(6, Str.IndexOfAny(['w', 's', 'a'], 4));
  CheckEquals(-1, Str.IndexOfAny(['w', 's', 'a'], 4, 2));
  CheckEquals(6, Str.IndexOfAny(['w', 's', 'a'], 4, 3));
  CheckEquals(-1, Str.IndexOfAny([]));

  Str := '';
  CheckEquals(-1, Str.IndexOfAny(['w', 's', 'a']));
  CheckEquals(-1, Str.IndexOfAny(['T'], 0, 0));

  { Unicode combining test }
  Str := TEST_CPS + TEST_STR;
  CheckEquals(10, Str.IndexOfAny(['w', 's', 'a'], 8, 3));
end;

procedure TTestWideStringHelper.TestInsert;
var
  Str1, Str2: WideString;
begin
  Str1 := 'This a string.';
  Str2 := '';

  CheckEquals(TEST_STR, Str1.Insert(5, 'is '));
  CheckEquals(WideString('Yes. This is a string.'), Str1.Insert(0, 'Yes. '));
  CheckEquals(WideString('Yes. This is a string.!'), Str1.Insert(22, '!'));
  CheckEquals(WideString('Yes. This is a string.!!'), Str1.Insert(100, '!'));

  CheckEquals(WideString('@'), Str2.Insert(0, '@'));

  { Unicode combining test }
  Str1 := TEST_CPS + 'This a string.';
  CheckEquals(TEST_CPS + TEST_STR, Str1.Insert(9, 'is '));
end;

procedure TTestWideStringHelper.TestIsDelimiter;
var
  Str: WideString;
begin
  Str := '';
  CheckFalse(Str.IsDelimiter('is', 0));

  Str := TEST_STR;

  CheckTrue(Str.IsDelimiter('is', 5));
  CheckTrue(Str.IsDelimiter('is', 6));
  CheckFalse(Str.IsDelimiter('is', 7));
  CheckFalse(Str.IsDelimiter('is', 20));

  { Unicode combining test }
  Str := TEST_CPS + TEST_STR;
  CheckTrue(Str.IsDelimiter('is', 10));
end;

procedure TTestWideStringHelper.TestEmpty;
var
  Str: WideString;
begin
  Str := '';
  CheckTrue(Str.IsEmpty);
  CheckTrue(WideString.IsNullOrEmpty(Str));
  CheckTrue(WideString.IsNullOrWhiteSpace(Str));

  Str := #0;
  CheckFalse(Str.IsEmpty);
  CheckFalse(WideString.IsNullOrEmpty(Str));
  CheckTrue(WideString.IsNullOrWhiteSpace(Str));

  Str := TEST_STR;
  CheckFalse(Str.IsEmpty);
  CheckFalse(WideString.IsNullOrEmpty(Str));
  CheckFalse(WideString.IsNullOrWhiteSpace(Str));

  Str := #$00#$01#$02#$03#$04#$05#$06#$07#$08#$09#$0a#$0b#$0c#$0d#$0e#$0f#$10+
    #$11#$12#$13#$14#$5#$6#$7#$8#$9#$1a#$1b#$1c#$1d#$1e#$1f#$20;
  CheckTrue(WideString.IsNullOrWhiteSpace(Str));
end;

procedure TTestWideStringHelper.JoinOffRange;
begin
  WideString.Join(',', ['String1', 'String2', 'String3'], 3, 2);
end;

procedure TTestWideStringHelper.TestJoin;
var
  UStr: WideString;
begin
  CheckEquals(WideString(''),
    WideString.Join(',', [], 0, 0));
  CheckEquals(WideString('String1,String2,String3'),
    WideString.Join(',', ['String1', 'String2', 'String3']));
  CheckEquals(WideString('String1String2String3'),
    WideString.Join('', ['String1', 'String2', 'String3']));
  CheckEquals(WideString('String1->String2->String3'),
    WideString.Join('->', ['String1', 'String2', 'String3']));
  CheckEquals(WideString('String2,String3'),
    WideString.Join(',', ['String1', 'String2', 'String3'], 1, 2));
  CheckException(@JoinOffRange, ERangeError);
  CheckEquals(WideString('String1'),
    WideString.Join(',', ['String1', 'String2', 'String3'], 0, 1));
  CheckEquals(WideString(''),
    WideString.Join(',', ['String1', 'String2', 'String3'], 0, 0));

  UStr := WideString('Строка');
  CheckEquals(
    WideString('String,Строка,True,10,') + WideString(SysUtils.FloatToStr(3.14)) + WideString(',TTestWideStringHelper'),
    WideString.Join(',', ['String', UStr, True, 10, 3.14, Self])
  );
end;

procedure TTestWideStringHelper.TestLastDelimiter;
var
  Str: WideString;
begin
  Str := '';
  CheckEquals(-1, Str.LastDelimiter('is'));

  Str := TEST_STR;
  CheckEquals(13, Str.LastDelimiter('is'));

  { Unicode combining test }
  Str := TEST_CPS + TEST_STR;
  CheckEquals(17, Str.LastDelimiter('is'));
end;

procedure TTestWideStringHelper.TestLastIndexOf;
var
  Str: WideString;
begin
  Str := TEST_STR;

  CheckEquals(-1, Str.LastIndexOf(WideChar('s'), 16, 5));
  CheckEquals(16, Str.LastIndexOf(WideChar('.')));
  CheckEquals(-1, Str.LastIndexOf(WideChar('?')));
  CheckEquals(-1, Str.LastIndexOf(WideChar('s'), 8, 2));
  CheckEquals(6, Str.LastIndexOf(WideChar('s'), 8, 3));
  CheckEquals(-1, Str.LastIndexOf(WideChar('s'), 8, 1));

  CheckEquals(-1, Str.LastIndexOf(WideString('s'), 16, 5));
  CheckEquals(5, Str.LastIndexOf(WideString('is'), 16));
  CheckEquals(16, Str.LastIndexOf(WideString('.')));
  CheckEquals(-1, Str.LastIndexOf(WideString('?')));
  CheckEquals(-1, Str.LastIndexOf(WideString('')));
  CheckEquals(-1, Str.LastIndexOf(WideString('s'), 8, 2));
  CheckEquals(6, Str.LastIndexOf(WideString('s'), 8, 3));
  CheckEquals(-1, Str.LastIndexOf(WideString('s'), 8, 1));

  Str := '';
  CheckEquals(-1, Str.LastIndexOf(WideChar('s')));
  CheckEquals(-1, Str.LastIndexOf(WideChar('s'), 0, 0));

  CheckEquals(-1, Str.LastIndexOf(WideString('s')));
  CheckEquals(-1, Str.LastIndexOf(WideString('s'), 0, 0));

  { Unicode combining test }
  Str := TEST_CPS + TEST_STR;
  CheckEquals(3, Str.LastIndexOf(TEST_CP_LATIN_SMALL_LETTER_S_WITH_DOT_BELOW_AND_DOT_ABOVE));
  CheckEquals(10, Str.LastIndexOf(WideChar('s'), 12, 3));
end;

procedure TTestWideStringHelper.TestLastIndexOfAny;
var
  Str: WideString;
begin
  Str := TEST_STR;

  CheckEquals(0, Str.LastIndexOfAny(['T'], 0));
  CheckEquals(-1, Str.LastIndexOfAny(['T'], 0, 0));
  CheckEquals(0, Str.LastIndexOfAny(['T'], 0, 1));
  CheckEquals(10, Str.LastIndexOfAny(['w', 's', 'a']));
  CheckEquals(10, Str.LastIndexOfAny(['w', 's', 'a'], 11));
  CheckEquals(10, Str.LastIndexOfAny(['w', 's', 'a'], 11, 2));
  CheckEquals(-1, Str.LastIndexOfAny(['w', 's', 'a'], 11, 1));
  CheckEquals(3, Str.LastIndexOfAny(['w', 's', 'a'], 4, 2));
  CheckEquals(-1, Str.LastIndexOfAny(['w', 's', 'a'], 4, 1));
  CheckEquals(-1, Str.LastIndexOfAny(['w', 's', 'a'], 4, 0));
  CheckEquals(-1, Str.LastIndexOfAny([]));

  Str := '';
  CheckEquals(-1, Str.LastIndexOfAny(['w', 's', 'a']));
  CheckEquals(-1, Str.LastIndexOfAny(['T'], 0, 0));

  { Unicode combining test }
  Str := TEST_STR + TEST_CPS;
  CheckEquals(10, Str.LastIndexOfAny([TEST_CP_LATIN_SMALL_LETTER_S], 11));
end;

procedure TTestWideStringHelper.TestLowerCase;
begin
  CheckEquals('testАБВГ', WideString.LowerCase('TESTАБВГ', loInvariantLocale));
  CheckEquals('testабвг', WideString.LowerCase('TESTАБВГ', loUserLocale));
end;

procedure TTestWideStringHelper.TestPadding;
var
  Str1, Str2: WideString;
begin
  Str1 := '';
  Str2 := '';
  CheckEquals(WideString(''), Str1.PadLeft(0));
  CheckEquals(WideString('  '), Str1.PadLeft(2));
  CheckEquals(WideString(''), Str2.PadRight(0));
  CheckEquals(WideString('  '), Str2.PadRight(2));

  Str1 := '12345';
  Str2 := '123';

  CheckEquals(WideString('12345'), Str1.PadLeft(5));
  CheckEquals(WideString('  123'), Str2.PadLeft(5));
  CheckEquals(WideString('123'), Str2.PadLeft(0));

  CheckEquals(WideString('12345'), Str1.PadRight(5));
  CheckEquals(WideString('123  '), Str2.PadRight(5));
  CheckEquals(WideString('123'), Str2.PadRight(0));
end;

procedure TTestWideStringHelper.TestQuotedString;
var
  Str1: WideString;
begin
  Str1 := 'This function illustrates the functionality of the QuotedString method.';
  CheckEquals(WideString('''This function illustrates the functionality of the QuotedString method.'''), Str1.QuotedString);
  CheckEquals(WideString('fThis ffunction illustrates the ffunctionality off the QuotedString method.f'), Str1.QuotedString(WideChar('f')));
end;

procedure TTestWideStringHelper.TestRemove;
var
  Str: WideString;
begin
  Str := TEST_STR;

  CheckEquals(WideString('This'), Str.Remove(4));
  CheckEquals(WideString('This string.'), Str.Remove(5, 5));

  { Unicode combining test }
  Str := 'This is ' + TEST_CPS + ' string.';
  CheckEquals(UnicodeString('This is string.'), Str.Remove(8, 5));
end;

procedure TTestWideStringHelper.TestReplace;
var
  Str: WideString;
begin
  Str := TEST_STR;

  CheckEquals(WideString('This is one string.'), Str.Replace('a', 'one'));
  CheckEquals(WideString('This is 1 string.'), Str.Replace(
    WideChar('a'),
    WideChar('1'))
  );
end;

procedure TTestWideStringHelper.TestSplit;
var
  Str1: WideString;
  ResList: specialize TArray<WideString>;
begin
  Str1 := 'one, two, and three., four';

  ResList := Str1.Split([#$2c{','}]);
  CheckEquals(4, Length(ResList));
  CheckEquals(WideString('one'), ResList[0]);
  CheckEquals(WideString(' two'), ResList[1]);
  CheckEquals(WideString(' and three.'), ResList[2]);
  CheckEquals(WideString(' four'), ResList[3]);

  ResList := Str1.Split([',']);
  CheckEquals(4, Length(ResList));
  CheckEquals(WideString('one'), ResList[0]);
  CheckEquals(WideString(' two'), ResList[1]);
  CheckEquals(WideString(' and three.'), ResList[2]);
  CheckEquals(WideString(' four'), ResList[3]);

  ResList := Str1.Split([#$2c{','}], 2);
  CheckEquals(2, Length(ResList));
  CheckEquals(WideString('one'), ResList[0]);
  CheckEquals(WideString(' two'), ResList[1]);

  ResList := Str1.Split([','], 2);
  CheckEquals(2, Length(ResList));
  CheckEquals(WideString('one'), ResList[0]);
  CheckEquals(WideString(' two'), ResList[1]);

  ResList := Str1.Split([#$2c{','}, #$2e{'.'}]);
  CheckEquals(5, Length(ResList));
  CheckEquals(WideString('one'), ResList[0]);
  CheckEquals(WideString(' two'), ResList[1]);
  CheckEquals(WideString(' and three'), ResList[2]);
  CheckEquals(WideString(''), ResList[3]);
  CheckEquals(WideString(' four'), ResList[4]);

  ResList := Str1.Split([WideChar(#$2c){','}, WideChar(#$2e){'.'}], TStringSplitOptions.None);
  CheckEquals(5, Length(ResList));
  CheckEquals(WideString('one'), ResList[0]);
  CheckEquals(WideString(' two'), ResList[1]);
  CheckEquals(WideString(' and three'), ResList[2]);
  CheckEquals(WideString(''), ResList[3]);
  CheckEquals(WideString(' four'), ResList[4]);

  ResList := Str1.Split([WideChar(#$2c){','}, WideChar(#$2e){'.'}], TStringSplitOptions.ExcludeEmpty);
  CheckEquals(4, Length(ResList));
  CheckEquals(WideString('one'), ResList[0]);
  CheckEquals(WideString(' two'), ResList[1]);
  CheckEquals(WideString(' and three'), ResList[2]);
  CheckEquals(WideString(' four'), ResList[3]);

  ResList := Str1.Split([WideString(','), WideString('.'), 'and'], TStringSplitOptions.ExcludeEmpty);
  CheckEquals(5, Length(ResList));
  CheckEquals(WideString('one'), ResList[0]);
  CheckEquals(WideString(' two'), ResList[1]);
  CheckEquals(WideString(' '), ResList[2]);
  CheckEquals(WideString(' three'), ResList[3]);
  CheckEquals(WideString(' four'), ResList[4]);

  ResList := Str1.Split([WideString(','), WideString('.'), 'and'], 5, TStringSplitOptions.None);
  CheckEquals(5, Length(ResList));
  CheckEquals(WideString('one'), ResList[0]);
  CheckEquals(WideString(' two'), ResList[1]);
  CheckEquals(WideString(' '), ResList[2]);
  CheckEquals(WideString(' three'), ResList[3]);
  CheckEquals(WideString(''), ResList[4]);

  Str1 := ',one, two, and three., four,';
  ResList := Str1.Split([#$2c{','}]);
  CheckEquals(5, Length(ResList));
  CheckEquals(WideString(''), ResList[0]);
  CheckEquals(WideString('one'), ResList[1]);
  CheckEquals(WideString(' two'), ResList[2]);
  CheckEquals(WideString(' and three.'), ResList[3]);
  CheckEquals(WideString(' four'), ResList[4]);

  Str1 := '不one不 two不 and three.不 four不';
  ResList := Str1.Split([WideChar('不')]);
  CheckEquals(5, Length(ResList));
  CheckEquals(WideString(''), ResList[0]);
  CheckEquals(WideString('one'), ResList[1]);
  CheckEquals(WideString(' two'), ResList[2]);
  CheckEquals(WideString(' and three.'), ResList[3]);
  CheckEquals(WideString(' four'), ResList[4]);
end;

procedure TTestWideStringHelper.TestStartsWith;
var
  Str1: WideString;
begin
  Str1 := TEST_STR;

  CheckTrue(Str1.StartsWith('This'));
  CheckFalse(Str1.StartsWith('THIS', False));
  CheckTrue(Str1.StartsWith('THIS', True));
end;

procedure TTestWideStringHelper.TestSubstring;
var
  Str: WideString;
begin
  Str := 'This is a string.';

  CheckEquals(WideString('is a string.'), Str.Substring(5));
  CheckEquals(WideString('is'), Str.Substring(5, 2));
  CheckEquals(WideString('.'), Str.Substring(16));
  CheckEquals(WideString(''), Str.Substring(17));
  CheckEquals(WideString(''), Str.Substring(17, 10));
  CheckEquals(WideString('This is a string.'), Str.Substring(0));

  { Unicode combining test }
  Str := 'This ' + TEST_CPS + 'is a string.';
  CheckEquals(UnicodeString('is a string.'), Str.Substring(9));
end;

procedure TTestWideStringHelper.ToBooleanEmpty;
begin
  WideString.ToBoolean('');
end;

procedure TTestWideStringHelper.TestToBoolean;
var
  Str: WideString;
begin
  Str := '0';
  CheckFalse(Str.ToBoolean);

  CheckFalse(WideString.ToBoolean('0'));
  CheckFalse(WideString.ToBoolean('000'));
  CheckFalse(WideString.ToBoolean('0' + WideChar(FormatSettings.DecimalSeparator) + '0'));
  CheckFalse(WideString.ToBoolean('-00' + WideChar(FormatSettings.DecimalSeparator) + '00'));
  CheckFalse(WideString.ToBoolean('+00' + WideChar(FormatSettings.DecimalSeparator) + '00'));
  CheckFalse(WideString.ToBoolean('00' + WideChar(FormatSettings.DecimalSeparator) + '00'));
  CheckTrue(WideString.ToBoolean('-1'));
  CheckTrue(WideString.ToBoolean('1'));
  CheckTrue(WideString.ToBoolean('123'));
  CheckTrue(WideString.ToBoolean('11' + WideChar(FormatSettings.DecimalSeparator) + '12'));
  CheckTrue(WideString.ToBoolean(WideString(SysUtils.TrueBoolStrs[0])));
  CheckFalse(WideString.ToBoolean(WideString(SysUtils.FalseBoolStrs[0])));
  CheckTrue(WideString.ToBoolean('TRUE'));
  CheckException(@ToBooleanEmpty, EConvertError);
end;

procedure TTestWideStringHelper.TestToCharArray;
var
  Str: WideString;
  CharList: specialize TArray<WideChar>;
begin
  Str := '123';

  CharList := Str.ToCharArray;
  CheckEquals(3, Length(CharList));
  CheckEquals(WideChar('1'), CharList[0]);
  CheckEquals(WideChar('2'), CharList[1]);
  CheckEquals(WideChar('3'), CharList[2]);

  CharList := Str.ToCharArray(1, 2);
  CheckEquals(2, Length(CharList));
  CheckEquals(WideChar('2'), CharList[0]);
  CheckEquals(WideChar('3'), CharList[1]);

  CharList := Str.ToCharArray(0, 0);
  CheckEquals(0, Length(CharList));

  { Unicode combining test }
  CharList := TEST_CPS.ToCharArray;
  CheckEquals(TEST_CP_LATIN_SMALL_LETTER_S, CharList[0]);
  CheckEquals(TEST_CP_COMBINING_DOT_BELOW, CharList[1]);
  CheckEquals(TEST_CP_COMBINING_DOT_ABOVE, CharList[2]);
  CheckEquals(TEST_CP_LATIN_SMALL_LETTER_S_WITH_DOT_BELOW_AND_DOT_ABOVE, CharList[3]);
end;

{$IFNDEF FPUNONE}
{$IFDEF FPC_HAS_TYPE_DOUBLE}
procedure TTestWideStringHelper.TDoubleEmpty;
begin
  WideString.ToDouble('');
end;

procedure TTestWideStringHelper.TestToDouble;
var
  Str, StrVal: WideString;
begin
  Str := '1';
  CheckEquals(StrToFloat('1'), Str.ToDouble);

  StrVal := '1' + WideChar(FormatSettings.DecimalSeparator) + '5';
  CheckEquals(StrToFloat(AnsiString(StrVal)), WideString.ToDouble(StrVal));
  StrVal := '-0' + WideChar(FormatSettings.DecimalSeparator) + '5';
  CheckEquals(StrToFloat(AnsiString(StrVal)), WideString.ToDouble(StrVal));
  CheckException(@TDoubleEmpty, EConvertError);
end;
{$ELSE}
procedure TTestWideStringHelper.TestToDouble;
begin
  Ignore('Double type is not supported.')
end;
{$ENDIF !FPC_HAS_TYPE_DOUBLE}
{$IF DEFINED(FPC_HAS_TYPE_EXTENDED) OR DEFINED(FPC_HAS_TYPE_DOUBLE)}
procedure TTestWideStringHelper.TExtendedEmpty;
begin
  WideString.ToExtended('');
end;

procedure TTestWideStringHelper.TestToExtended;
var
  Str, StrVal: WideString;
begin
  Str := '1';
  CheckEquals(StrToFloat('1'), Str.ToExtended);

  StrVal := '1' + WideChar(FormatSettings.DecimalSeparator) + '5';
  CheckEquals(StrToFloat(AnsiString(StrVal)), WideString.ToExtended(StrVal));
  StrVal := '-0' + WideChar(FormatSettings.DecimalSeparator) + '5';
  CheckEquals(StrToFloat(AnsiString(StrVal)), WideString.ToExtended(StrVal));
  CheckException(@TExtendedEmpty, EConvertError);
end;
{$ELSE}
procedure TTestWideStringHelper.TestToExtended;
begin
  Ignore('Extended type is not supported.');
end;
{$IFEND !FPC_HAS_TYPE_EXTENDED FPC_HAS_TYPE_DOUBLE}
{$IFDEF FPC_HAS_TYPE_SINGLE}
procedure TTestWideStringHelper.TSingleEmpty;
begin
  WideString.ToSingle('');
end;

procedure TTestWideStringHelper.TestToSingle;
var
  Str, StrVal: WideString;
begin
  Str := '1';
  CheckEquals(StrToFloat('1'), Str.ToSingle);

  StrVal := '1' + WideChar(FormatSettings.DecimalSeparator) + '5';
  CheckEquals(StrToFloat(AnsiString(StrVal)), WideString.ToSingle(StrVal));
  StrVal := '-0' + WideChar(FormatSettings.DecimalSeparator) + '5';
  CheckEquals(StrToFloat(AnsiString(StrVal)), WideString.ToSingle(StrVal));
  CheckException(@TSingleEmpty, EConvertError);
end;
{$ELSE}
procedure TTestWideStringHelper.TestToSingle;
begin
  Ignore('Single type is not supported.');
end;
{$ENDIF !FPC_HAS_TYPE_SINGLE}
{$ENDIF !~FPUNONE}

procedure TTestWideStringHelper.TIntegerEmpty;
begin
  WideString.ToInteger('');
end;

procedure TTestWideStringHelper.TIntegerToBig;
begin
  WideString.ToInteger('3000000000');
end;

procedure TTestWideStringHelper.TestToInteger;
var
  Str: WideString;
begin
  Str := '1';
  CheckEquals(1, Str.ToInteger);

  CheckEquals(2, WideString.ToInteger('2'));
  CheckEquals(-1, WideString.ToInteger('-1'));
  CheckException(@TIntegerEmpty, EConvertError);
  CheckException(@TIntegerToBig, EConvertError);
end;

procedure TTestWideStringHelper.TestToLower;
var
  Str: WideString;
begin
  Str := '123ONE';
  CheckEquals(WideString('123one'), Str.ToLower);

  {$IFDEF WINDOWS}
  Str := 'ONEОДИН不怕当小白鼠';
  CheckEquals(WideString('oneодин不怕当小白鼠'), Str.ToLower($0409)); { English - United States }
  CheckEquals(WideString('oneодин不怕当小白鼠'), Str.ToLower($0419)); { Russian }

  { See http://lotusnotus.com/lotusnotus_en.nsf/dx/dotless-i-tolowercase-and-touppercase-functions-use-responsibly.htm }
  Str := 'TITLE';
  CheckEquals(WideString('tıtle'), Str.ToLower($041f)); { Turkish }
  Str := 'TİTLE';
  CheckEquals(WideString('title'), Str.ToLower($041f)); { Turkish }
  {$ENDIF}
end;

procedure TTestWideStringHelper.TestToLowerInvariant;
var
  Str: WideString;
begin
  Str := 'HeLlo ПрИвЕт aLlÔ 您好 123';
  CheckEquals(WideString('hello привет allô 您好 123'), Str.ToLowerInvariant);
end;

procedure TTestWideStringHelper.TestToUpper;
var
  Str: WideString;
begin
  Str := '123one';
  CheckEquals(WideString('123ONE'), Str.ToUpper);

  {$IFDEF WINDOWS}
  Str := 'oneодин不怕当小白鼠';
  {$HINTS OFF}
  CheckEquals('ONEОДИН不怕当小白鼠', Str.ToUpper($0409)); { English - United States }
  CheckEquals('ONEОДИН不怕当小白鼠', Str.ToUpper($0419)); { Russian }

  { See http://lotusnotus.com/lotusnotus_en.nsf/dx/dotless-i-tolowercase-and-touppercase-functions-use-responsibly.htm }
  Str := 'tıtle';
  CheckEquals(WideString('TITLE'), Str.ToUpper($041f)); { Turkish }
  Str := 'title';
  CheckEquals(WideString('TİTLE'), Str.ToUpper($041f)); { Turkish }
  {$HINTS ON}
  {$ENDIF}
end;

procedure TTestWideStringHelper.TestToUpperInvariant;
var
  Str: WideString;
begin
  Str := 'HeLlo ПрИвЕт aLlÔ 您好 123';
  CheckEquals(WideString('HELLO ПРИВЕТ ALLÔ 您好 123'), Str.ToUpperInvariant);
end;

procedure TTestWideStringHelper.TestTrim;
var
  Str1, Str2, Str3: WideString;
begin
  Str1 := '';
  Str2 := 'test';
  Str3 := '  test  ';

  CheckEquals(WideString(''), Str1.Trim);
  CheckEquals(WideString('test'), Str2.Trim);
  CheckEquals(WideString('test'), Str3.Trim);
  CheckEquals(WideString('es'), Str2.Trim(['t']));
  CheckEquals(WideString('s'), Str2.Trim(['t', 'e']));
  CheckEquals(WideString(''), Str2.Trim(['t', 'e', 's', '@']));
  CheckEquals(WideString('  test  '), Str3.Trim(['t', 'e', 's', '@']));
end;

procedure TTestWideStringHelper.TestTrimLeft;
var
  Str1, Str2, Str3: WideString;
begin
  Str1 := '';
  Str2 := 'test';
  Str3 := '  test  ';

  CheckEquals(WideString(''), Str1.TrimLeft);
  CheckEquals(WideString('test'), Str2.TrimLeft);
  CheckEquals(WideString('test  '), Str3.TrimLeft);
  CheckEquals(WideString('est'), Str2.TrimLeft(['t']));
  CheckEquals(WideString('st'), Str2.TrimLeft(['t', 'e']));
  CheckEquals(WideString(''), Str2.TrimLeft(['t', 'e', 's', '@']));
  CheckEquals(WideString('  test  '), Str3.TrimLeft(['t', 'e', 's', '@']));
end;

procedure TTestWideStringHelper.TestTrimRight;
var
  Str1, Str2, Str3: WideString;
begin
  Str1 := '';
  Str2 := 'test';
  Str3 := '  test  ';

  CheckEquals(WideString(''), Str1.TrimRight);
  CheckEquals(WideString('test'), Str2.TrimRight);
  CheckEquals(WideString('  test'), Str3.TrimRight);
  CheckEquals(WideString('tes'), Str2.TrimRight(['t']));
  CheckEquals(WideString('te'), Str2.TrimRight(['t', 's']));
  CheckEquals(WideString(''), Str2.TrimRight(['t', 'e', 's', '@']));
  CheckEquals(WideString('  test  '), Str3.TrimRight(['t', 'e', 's', '@']));
end;

procedure TTestWideStringHelper.TestUpperCase;
begin
  CheckEquals('TESTабвг', WideString.UpperCase('testабвг', loInvariantLocale));
  CheckEquals('TESTАБВГ', WideString.UpperCase('testабвг', loUserLocale));
end;

procedure TTestWideStringHelper.TestChars;
var
  Str: WideString;
begin
  Str := '不怕当小白鼠';

  CheckEquals(WideChar('不'), Str.Chars[0]);
  CheckEquals(WideChar('怕'), Str.Chars[1]);
  CheckEquals(WideChar('当'), Str.Chars[2]);
  CheckEquals(WideChar('小'), Str.Chars[3]);
  CheckEquals(WideChar('白'), Str.Chars[4]);
  CheckEquals(WideChar('鼠'), Str.Chars[5]);

  { Unicode combining test }
  CheckEquals(TEST_CP_LATIN_SMALL_LETTER_S, TEST_CPS.Chars[0]);
  CheckEquals(TEST_CP_COMBINING_DOT_BELOW, TEST_CPS.Chars[1]);
  CheckEquals(TEST_CP_COMBINING_DOT_ABOVE, TEST_CPS.Chars[2]);
  CheckEquals(TEST_CP_LATIN_SMALL_LETTER_S_WITH_DOT_BELOW_AND_DOT_ABOVE, TEST_CPS.Chars[3]);
end;

procedure TTestWideStringHelper.TestLength;
var
  AnsiStr: AnsiString;
  Str: WideString;
begin
  AnsiStr := 'hello';
  CheckEquals(5, AnsiStr.Length);

  Str := '不怕当小白鼠';
  CheckEquals(6, Str.Length);

  { Unicode combining test }
  CheckEquals(4, TEST_CPS.Length);
end;

procedure TTestWideStringHelper.TestParse;
begin
  CheckEquals(WideString('-1'), WideString.Parse(Integer(-1)));
  CheckEquals(WideString('3000000000'), WideString.Parse(TEST_INT64));
  CheckEquals(WideString('-1'), WideString.Parse(True));
  CheckEquals(WideString('0'), WideString.Parse(False));
  {$IF NOT DEFINED(FPUNONE) AND (DEFINED(FPC_HAS_TYPE_EXTENDED) OR DEFINED(FPC_HAS_TYPE_DOUBLE))}
  CheckEquals(WideString(FloatToStr(1.5)), WideString.Parse(1.5));
  {$ELSE}
  Ignore('Extended/Double type is not supported.');
  {$IFEND !~FPUNONE FPC_HAS_TYPE_EXTENDED FPC_HAS_TYPE_DOUBLE}
end;

procedure TTestWideStringHelper.TInt64Empty;
begin
  WideString.ToInt64('');
end;

procedure TTestWideStringHelper.TInt64ToBig;
begin
  WideString.ToInt64('9223372036854775808');
end;

procedure TTestWideStringHelper.TestToInt64;
var
  Str: WideString;
begin
  Str := '3000000000';
  CheckTrue(TEST_INT64 = Str.ToInt64);

  CheckTrue(TEST_INT64 = WideString.ToInt64('3000000000'));
  CheckTrue(-TEST_INT64 = WideString.ToInt64('-3000000000'));
  CheckException(@TInt64Empty, EConvertError);
  CheckException(@TInt64ToBig, EConvertError);
end;

procedure TTestWideStringHelper.TestIndexOfAnyUnquoted;
var
  Str: WideString;
begin
  Str := '"This" is it';
  CheckEquals(7, Str.IndexOfAnyUnquoted(['i'], '"', '"'));

  Str := '"This is it';
  CheckEquals(-1, Str.IndexOfAnyUnquoted(['i'], '"', '"'));

  Str := '"This" "is" "it"';
  CheckEquals(-1, Str.IndexOfAnyUnquoted(['i'], '"', '"'));

  Str := '<This <is>> it';
  CheckEquals(12, Str.IndexOfAnyUnquoted(['i'], '<', '>'));

  Str := '"This" is it';
  CheckEquals(3, Str.IndexOfAnyUnquoted(['i'], '"', '"', 1)); //!!! 2 in http://docwiki.embarcadero.com/Libraries/Seattle/en/System.SysUtils.TStringHelper.IndexOfAnyUnquoted

  Str := 'This" "is" "it';
  CheckEquals(-1, Str.IndexOfAnyUnquoted(['i'], '"', '"', 5));

  CheckEquals(-1, Str.IndexOfAnyUnquoted([], '"', '"'));

  Str := '';
  CheckEquals(-1, Str.IndexOfAnyUnquoted([], '"', '"'));
  CheckEquals(-1, Str.IndexOfAnyUnquoted(['w', 's', 'a'], '"', '"'));
  CheckEquals(-1, Str.IndexOfAnyUnquoted(['T'], '"', '"', 0, 0));

  { Unicode combining test }
  Str := '"This" ' + TEST_CPS + ' is it';
  CheckEquals(12, Str.IndexOfAnyUnquoted(['i'], '"', '"'));
end;

{ Non Delphi }

procedure TTestWideStringHelper.TestByteLength;
var
  Str: WideString;
begin
  Str := '不怕当小白鼠';

  CheckEquals(12, Str.ByteLength);
end;

procedure TTestWideStringHelper.TestCPLength;
var
  Str: WideString;
begin
  Str := '不怕当小白鼠';

  CheckEquals(6, Str.CPLength);

  { Unicode combining test }
  CheckEquals(4, TEST_CPS.CPLength);
end;

procedure TTestWideStringHelper.TestCodePoints;
var
  Str: WideString;
begin
  Str := '不怕当小白鼠';

  CheckEquals(WideChar('不'), Str.CodePoints[0]);
  CheckEquals(WideChar('怕'), Str.CodePoints[1]);
  CheckEquals(WideChar('当'), Str.CodePoints[2]);
  CheckEquals(WideChar('小'), Str.CodePoints[3]);
  CheckEquals(WideChar('白'), Str.CodePoints[4]);
  CheckEquals(WideChar('鼠'), Str.CodePoints[5]);

  { Unicode combining test }
  CheckEquals(TEST_CP_LATIN_SMALL_LETTER_S, TEST_CPS.CodePoints[0]);
  CheckEquals(TEST_CP_COMBINING_DOT_BELOW, TEST_CPS.CodePoints[1]);
  CheckEquals(TEST_CP_COMBINING_DOT_ABOVE, TEST_CPS.CodePoints[2]);
  CheckEquals(TEST_CP_LATIN_SMALL_LETTER_S_WITH_DOT_BELOW_AND_DOT_ABOVE, TEST_CPS.CodePoints[3]);
end;
{$ELSE}
procedure TTestWideStringHelper.NotSupported;
begin
  Ignore('WideString is not supported.');
end;
{$ENDIF !FPC_HAS_FEATURE_WIDESTRINGS}

initialization
  { Initialization of TrueBoolStrs/FalseBoolStrs arrays }
  SysUtils.BoolToStr(True, True);
  RegisterTest('System.Helpers', TTestWideStringHelper.Suite);

end.

