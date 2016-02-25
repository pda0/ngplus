{**********************************************************************
    Copyright(c) 2016 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit System.Helpers;

{$I ngplus.inc}

interface

uses
  {$IFDEF WINDOWS}
  Windows,
  {$ENDIF}
  Types, SysUtils;

type
  TArray<T> = array of T;

  {$IF (FPC_VERSION = 3) AND (FPC_RELEASE = 0)}
  TEndian = (Big, Little);
  {$IFEND}

  TGuidHelper = record helper for System.TGUID
  public
    class function Create(const S: AnsiString): TGUID; overload; static;
    class function Create(const S: UnicodeString): TGUID; overload; static;
    class function Create(const Data; DataEndian: TEndian = {$IFDEF ENDIAN_BIG}TEndian.Big{$ELSE}TEndian.Little{$ENDIF}): TGUID; overload; static;
    class function Create(const B: TBytes; DataEndian: TEndian = {$IFDEF ENDIAN_BIG}TEndian.Big{$ELSE}TEndian.Little{$ENDIF}): TGUID; overload; static;
    class function Create(const B: TBytes; AStartIndex: Cardinal; DataEndian: TEndian = {$IFDEF ENDIAN_BIG}TEndian.Big{$ELSE}TEndian.Little{$ENDIF}): TGUID; overload; static;
    class function Create(A: Integer; B: SmallInt; C: SmallInt; const D: TBytes): TGUID; overload; static;
    class function Create(A: Integer; B: SmallInt; C: SmallInt; D, E, F, G, H, I, J, K: Byte): TGUID; overload; static;
    class function Create(A: Cardinal; B: Word; C: Word; D, E, F, G, H, I, J, K: Byte): TGUID; overload; static;
    class function Empty: TGUID; static;
    class function NewGuid: TGUID; static;
    function ToByteArray(DataEndian: TEndian = {$IFDEF ENDIAN_BIG}TEndian.Big{$ELSE}TEndian.Little{$ENDIF}): TBytes;
    function ToString: string;
  end;

  TLocaleID = {$IFDEF WINDOWS}LCID{$ELSE}DWord{$ENDIF};
  TLocaleOptions = (loInvariantLocale, loUserLocale);
  TStringSplitOptions = (None, ExcludeEmpty);

  TShortStringHelper = record helper for ShortString
  private
    function GetChars(Index: Integer): AnsiChar; {$IFDEF HAS_INLINE}inline;{$ENDIF}
    function GetLength: Integer; {$IFDEF HAS_INLINE}inline;{$ENDIF}
  public
    const Empty: ShortString = '';
    class function Create(C: AnsiChar; Count: Integer): ShortString; overload; {$IFNDEF _TEST}inline;{$ENDIF} static;
    class function Create(const Value: array of AnsiChar; StartIndex: Integer; Length: Integer): ShortString; overload; static;
    class function Create(const Value: array of AnsiChar): ShortString; overload; static;
    class function Compare(const StrA: ShortString; const StrB: ShortString): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: ShortString; const StrB: ShortString; LocaleID: TLocaleID): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: ShortString; const StrB: ShortString; IgnoreCase: Boolean): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: ShortString; const StrB: ShortString; IgnoreCase: Boolean; LocaleID: TLocaleID): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: ShortString; IndexA: Integer; const StrB: ShortString; IndexB: Integer; Length: Integer): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: ShortString; IndexA: Integer; const StrB: ShortString; IndexB: Integer; Length: Integer; LocaleID: TLocaleID): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: ShortString; IndexA: Integer; const StrB: ShortString; IndexB: Integer; Length: Integer; IgnoreCase: Boolean): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: ShortString; IndexA: Integer; const StrB: ShortString; IndexB: Integer; Length: Integer; IgnoreCase: Boolean; LocaleID: TLocaleID): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function CompareOrdinal(const StrA: ShortString; const StrB: ShortString): Integer; overload; static;
    class function CompareOrdinal(const StrA: ShortString; IndexA: Integer; const StrB: ShortString; IndexB: Integer; Length: Integer): Integer; overload; static;
    class function CompareText(const StrA: ShortString; const StrB: ShortString): Integer; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function CompareTo(const strB: ShortString): Integer;
    function Contains(const Value: ShortString): Boolean;
    class function Copy(const Str: ShortString): ShortString; static; {$IFNDEF _TEST}inline;{$ENDIF}
    procedure CopyTo(SourceIndex: Integer; var Destination: array of AnsiChar; DestinationIndex: Integer; Count: Integer);
    function CountChar(const C: AnsiChar): Integer;
    function DeQuotedString: ShortString; overload;
    function DeQuotedString(const QuoteChar: AnsiChar): ShortString; overload;
    class function EndsText(const ASubText, AText: ShortString): Boolean; static;
    function EndsWith(const Value: ShortString): Boolean; overload;
    function EndsWith(const Value: ShortString; IgnoreCase: Boolean): Boolean; overload;
    function Equals(const Value: ShortString): Boolean; overload;
    class function Equals(const Left: ShortString; const Right: ShortString): Boolean; overload; static;
    class function Format(const Format: ShortString; const Args: array of const): ShortString; overload; static;
    function IndexOf(value: AnsiChar): Integer; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function IndexOf(const Value: ShortString): Integer; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function IndexOf(Value: AnsiChar; StartIndex: Integer): Integer; overload;
    function IndexOf(const Value: ShortString; StartIndex: Integer): Integer; overload;
    function IndexOf(Value: AnsiChar; StartIndex: Integer; Count: Integer): Integer; overload;
    function IndexOf(const Value: ShortString; StartIndex: Integer; Count: Integer): Integer; overload;
    function IndexOfAny(const AnyOf: array of AnsiChar): Integer; overload;
    function IndexOfAny(const AnyOf: array of AnsiChar; StartIndex: Integer): Integer; overload;
    function IndexOfAny(const AnyOf: array of AnsiChar; StartIndex: Integer; Count: Integer): Integer; overload;
    function IndexOfAnyUnquoted(const AnyOf: array of AnsiChar; StartQuote, EndQuote: AnsiChar): Integer; overload;
    function IndexOfAnyUnquoted(const AnyOf: array of AnsiChar; StartQuote, EndQuote: AnsiChar; StartIndex: Integer): Integer; overload;
    function IndexOfAnyUnquoted(const AnyOf: array of AnsiChar; StartQuote, EndQuote: AnsiChar; StartIndex: Integer; Count: Integer): Integer; overload;
    function Insert(StartIndex: Integer; const Value: ShortString): ShortString;
    function IsDelimiter(const Delimiters: ShortString; Index: Integer): Boolean;
    function IsEmpty: Boolean;
    class function IsNullOrEmpty(const Value: ShortString): Boolean; static;
    class function IsNullOrWhiteSpace(const Value: ShortString): Boolean; static;
    class function Join(const Separator: ShortString; const Values: array of const): ShortString; overload; static;
    class function Join(const Separator: ShortString; const Values: array of ShortString): ShortString; overload; static;
    class function Join(const Separator: ShortString; const Values: IEnumerator<ShortString>): ShortString; overload; static;
    class function Join(const Separator: ShortString; const Values: IEnumerable<ShortString>): ShortString; overload; static;
    class function Join(const Separator: ShortString; const Value: array of ShortString; StartIndex: Integer; Count: Integer): ShortString; overload; static;
    function LastDelimiter(const Delims: ShortString): Integer;
    function LastIndexOf(Value: AnsiChar): Integer; overload;
    function LastIndexOf(const Value: ShortString): Integer; overload;
    function LastIndexOf(Value: AnsiChar; StartIndex: Integer): Integer; overload;
    function LastIndexOf(const Value: ShortString; StartIndex: Integer): Integer; overload;
    function LastIndexOf(Value: AnsiChar; StartIndex: Integer; Count: Integer): Integer; overload;
    function LastIndexOf(const Value: ShortString; StartIndex: Integer; Count: Integer): Integer; overload;
    function LastIndexOfAny(const AnyOf: array of AnsiChar): Integer; overload;
    function LastIndexOfAny(const AnyOf: array of AnsiChar; StartIndex: Integer): Integer; overload;
    function LastIndexOfAny(const AnyOf: array of AnsiChar; StartIndex: Integer; Count: Integer): Integer; overload;
    class function LowerCase(const S: ShortString): ShortString; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function LowerCase(const S: ShortString; LocaleOptions: TLocaleOptions): ShortString; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function PadLeft(TotalWidth: Integer): ShortString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function PadLeft(TotalWidth: Integer; PaddingChar: AnsiChar): ShortString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function PadRight(TotalWidth: Integer): ShortString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function PadRight(TotalWidth: Integer; PaddingChar: AnsiChar): ShortString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Parse(const Value: Integer): ShortString; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Parse(const Value: Int64): ShortString; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Parse(const Value: Boolean): ShortString; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Parse(const Value: Extended): ShortString; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function QuotedString: ShortString; overload;
    function QuotedString(const QuoteChar: AnsiChar): ShortString; overload;
    function Remove(StartIndex: Integer): ShortString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function Remove(StartIndex: Integer; Count: Integer): ShortString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function Replace(OldChar: AnsiChar; NewChar: AnsiChar): ShortString; overload;
    function Replace(OldChar: AnsiChar; NewChar: AnsiChar; ReplaceFlags: TReplaceFlags): ShortString; overload;
    function Replace(const OldValue: ShortString; const NewValue: ShortString): ShortString; overload;
    function Replace(const OldValue: ShortString; const NewValue: ShortString; ReplaceFlags: TReplaceFlags): ShortString; overload;
    function Split(const Separator: array of AnsiChar): TArray<ShortString>; overload;
    function Split(const Separator: array of AnsiChar; Count: Integer): TArray<ShortString>; overload;
    function Split(const Separator: array of AnsiChar; Options: TStringSplitOptions): TArray<ShortString>; overload;
    function Split(const Separator: array of ShortString; Options: TStringSplitOptions): TArray<ShortString>; overload;
    function Split(const Separator: array of AnsiChar; Count: Integer; Options: TStringSplitOptions): TArray<ShortString>; overload;
    function Split(const Separator: array of ShortString; Count: Integer; Options: TStringSplitOptions): TArray<ShortString>; overload;
    function StartsWith(const Value: ShortString): Boolean; overload;
    function StartsWith(const Value: ShortString; IgnoreCase: Boolean): Boolean; overload;
    function Substring(StartIndex: Integer): ShortString; overload;
    function Substring(StartIndex: Integer; Length: Integer): ShortString; overload;
    class function ToBoolean(const S: ShortString): Boolean; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToBoolean: Boolean; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToCharArray: TArray<AnsiChar>; overload;
    function ToCharArray(StartIndex: Integer; Length: Integer): TArray<AnsiChar>; overload;
    class function ToDouble(const S: ShortString): Double; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToDouble: Double; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    class function ToExtended(const S: ShortString): Extended; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToExtended: Extended; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    class function ToInt64(const S: ShortString): Int64; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToInt64: Int64; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    class function ToInteger(const S: ShortString): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToInteger: Integer; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToLower: ShortString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToLower(LocaleID: TLocaleID): ShortString; overload;
    function ToLowerInvariant: ShortString;
    class function ToSingle(const S: ShortString): Single; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToSingle: Single; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToUpper: ShortString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToUpper(LocaleID: TLocaleID): ShortString; overload;
    function ToUpperInvariant: ShortString;
    function Trim: ShortString; overload;
    function Trim(const TrimChars: array of AnsiChar): ShortString; overload;
    function TrimEnd(const TrimChars: array of AnsiChar): ShortString; {not yet supported inline;} deprecated 'Use TrimRight';
    function TrimLeft: ShortString; overload;
    function TrimLeft(const TrimChars: array of AnsiChar): ShortString; overload;
    function TrimRight: ShortString; overload;
    function TrimRight(const TrimChars: array of AnsiChar): ShortString; overload;
    function TrimStart(const TrimChars: array of AnsiChar): ShortString; {not yet supported inline;} deprecated 'Use TrimLeft';
    class function UpperCase(const S: ShortString): ShortString; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function UpperCase(const S: ShortString; LocaleOptions: TLocaleOptions): ShortString; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    property Chars[Index: Integer]: AnsiChar read GetChars;
    property Length: Integer read GetLength;
  end;

  TAnsiStringHelper = record helper for AnsiString
  private
    function GetChars(Index: Integer): AnsiChar; {$IFDEF HAS_INLINE}inline;{$ENDIF}
    function GetLength: Integer; {$IFDEF HAS_INLINE}inline;{$ENDIF}
  public
    const Empty: AnsiString = '';
    class function Create(C: AnsiChar; Count: Integer): AnsiString; overload; {$IFNDEF _TEST}inline;{$ENDIF} static;
    class function Create(const Value: array of AnsiChar; StartIndex: Integer; Length: Integer): AnsiString; overload; static;
    class function Create(const Value: array of AnsiChar): AnsiString; overload; static;
    class function Compare(const StrA: AnsiString; const StrB: AnsiString): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: AnsiString; const StrB: AnsiString; LocaleID: TLocaleID): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: AnsiString; const StrB: AnsiString; IgnoreCase: Boolean): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: AnsiString; const StrB: AnsiString; IgnoreCase: Boolean; LocaleID: TLocaleID): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: AnsiString; IndexA: Integer; const StrB: AnsiString; IndexB: Integer; Length: Integer): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: AnsiString; IndexA: Integer; const StrB: AnsiString; IndexB: Integer; Length: Integer; LocaleID: TLocaleID): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: AnsiString; IndexA: Integer; const StrB: AnsiString; IndexB: Integer; Length: Integer; IgnoreCase: Boolean): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: AnsiString; IndexA: Integer; const StrB: AnsiString; IndexB: Integer; Length: Integer; IgnoreCase: Boolean; LocaleID: TLocaleID): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function CompareOrdinal(const StrA: AnsiString; const StrB: AnsiString): Integer; overload; static;
    class function CompareOrdinal(const StrA: AnsiString; IndexA: Integer; const StrB: AnsiString; IndexB: Integer; Length: Integer): Integer; overload; static;
    class function CompareText(const StrA: AnsiString; const StrB: AnsiString): Integer; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function CompareTo(const strB: AnsiString): Integer;
    function Contains(const Value: AnsiString): Boolean;
    class function Copy(const Str: AnsiString): AnsiString; static; {$IFNDEF _TEST}inline;{$ENDIF}
    procedure CopyTo(SourceIndex: Integer; var Destination: array of AnsiChar; DestinationIndex: Integer; Count: Integer);
    function CountChar(const C: AnsiChar): Integer;
    function DeQuotedString: AnsiString; overload;
    function DeQuotedString(const QuoteChar: AnsiChar): AnsiString; overload;
    class function EndsText(const ASubText, AText: AnsiString): Boolean; static;
    function EndsWith(const Value: AnsiString): Boolean; overload;
    function EndsWith(const Value: AnsiString; IgnoreCase: Boolean): Boolean; overload;
    function Equals(const Value: AnsiString): Boolean; overload;
    class function Equals(const Left: AnsiString; const Right: AnsiString): Boolean; overload; static;
    class function Format(const Format: AnsiString; const Args: array of const): AnsiString; overload; static;
    function IndexOf(value: AnsiChar): Integer; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function IndexOf(const Value: AnsiString): Integer; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function IndexOf(Value: AnsiChar; StartIndex: Integer): Integer; overload;
    function IndexOf(const Value: AnsiString; StartIndex: Integer): Integer; overload;
    function IndexOf(Value: AnsiChar; StartIndex: Integer; Count: Integer): Integer; overload;
    function IndexOf(const Value: AnsiString; StartIndex: Integer; Count: Integer): Integer; overload;
    function IndexOfAny(const AnyOf: array of AnsiChar): Integer; overload;
    function IndexOfAny(const AnyOf: array of AnsiChar; StartIndex: Integer): Integer; overload;
    function IndexOfAny(const AnyOf: array of AnsiChar; StartIndex: Integer; Count: Integer): Integer; overload;
    function IndexOfAnyUnquoted(const AnyOf: array of AnsiChar; StartQuote, EndQuote: AnsiChar): Integer; overload;
    function IndexOfAnyUnquoted(const AnyOf: array of AnsiChar; StartQuote, EndQuote: AnsiChar; StartIndex: Integer): Integer; overload;
    function IndexOfAnyUnquoted(const AnyOf: array of AnsiChar; StartQuote, EndQuote: AnsiChar; StartIndex: Integer; Count: Integer): Integer; overload;
    function Insert(StartIndex: Integer; const Value: AnsiString): AnsiString;
    function IsDelimiter(const Delimiters: AnsiString; Index: Integer): Boolean;
    function IsEmpty: Boolean;
    class function IsNullOrEmpty(const Value: AnsiString): Boolean; static;
    class function IsNullOrWhiteSpace(const Value: AnsiString): Boolean; static;
    class function Join(const Separator: AnsiString; const Values: array of const): AnsiString; overload; static;
    class function Join(const Separator: AnsiString; const Values: array of AnsiString): AnsiString; overload; static;
    class function Join(const Separator: AnsiString; const Values: IEnumerator<AnsiString>): AnsiString; overload; static;
    class function Join(const Separator: AnsiString; const Values: IEnumerable<AnsiString>): AnsiString; overload; static;
    class function Join(const Separator: AnsiString; const Value: array of AnsiString; StartIndex: Integer; Count: Integer): AnsiString; overload; static;
    function LastDelimiter(const Delims: AnsiString): Integer;
    function LastIndexOf(Value: AnsiChar): Integer; overload;
    function LastIndexOf(const Value: AnsiString): Integer; overload;
    function LastIndexOf(Value: AnsiChar; StartIndex: Integer): Integer; overload;
    function LastIndexOf(const Value: AnsiString; StartIndex: Integer): Integer; overload;
    function LastIndexOf(Value: AnsiChar; StartIndex: Integer; Count: Integer): Integer; overload;
    function LastIndexOf(const Value: AnsiString; StartIndex: Integer; Count: Integer): Integer; overload;
    function LastIndexOfAny(const AnyOf: array of AnsiChar): Integer; overload;
    function LastIndexOfAny(const AnyOf: array of AnsiChar; StartIndex: Integer): Integer; overload;
    function LastIndexOfAny(const AnyOf: array of AnsiChar; StartIndex: Integer; Count: Integer): Integer; overload;
    class function LowerCase(const S: AnsiString): AnsiString; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function LowerCase(const S: AnsiString; LocaleOptions: TLocaleOptions): AnsiString; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function PadLeft(TotalWidth: Integer): AnsiString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function PadLeft(TotalWidth: Integer; PaddingChar: AnsiChar): AnsiString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function PadRight(TotalWidth: Integer): AnsiString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function PadRight(TotalWidth: Integer; PaddingChar: AnsiChar): AnsiString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Parse(const Value: Integer): AnsiString; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Parse(const Value: Int64): AnsiString; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Parse(const Value: Boolean): AnsiString; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Parse(const Value: Extended): AnsiString; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function QuotedString: AnsiString; overload;
    function QuotedString(const QuoteChar: AnsiChar): AnsiString; overload;
    function Remove(StartIndex: Integer): AnsiString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function Remove(StartIndex: Integer; Count: Integer): AnsiString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function Replace(OldChar: AnsiChar; NewChar: AnsiChar): AnsiString; overload;
    function Replace(OldChar: AnsiChar; NewChar: AnsiChar; ReplaceFlags: TReplaceFlags): AnsiString; overload;
    function Replace(const OldValue: AnsiString; const NewValue: AnsiString): AnsiString; overload;
    function Replace(const OldValue: AnsiString; const NewValue: AnsiString; ReplaceFlags: TReplaceFlags): AnsiString; overload;
    function Split(const Separator: array of AnsiChar): TArray<AnsiString>; overload;
    function Split(const Separator: array of AnsiChar; Count: Integer): TArray<AnsiString>; overload;
    function Split(const Separator: array of AnsiChar; Options: TStringSplitOptions): TArray<AnsiString>; overload;
    function Split(const Separator: array of AnsiString; Options: TStringSplitOptions): TArray<AnsiString>; overload;
    function Split(const Separator: array of AnsiChar; Count: Integer; Options: TStringSplitOptions): TArray<AnsiString>; overload;
    function Split(const Separator: array of AnsiString; Count: Integer; Options: TStringSplitOptions): TArray<AnsiString>; overload;
    function StartsWith(const Value: AnsiString): Boolean; overload;
    function StartsWith(const Value: AnsiString; IgnoreCase: Boolean): Boolean; overload;
    function Substring(StartIndex: Integer): AnsiString; overload;
    function Substring(StartIndex: Integer; Length: Integer): AnsiString; overload;
    class function ToBoolean(const S: AnsiString): Boolean; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToBoolean: Boolean; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToCharArray: TArray<AnsiChar>; overload;
    function ToCharArray(StartIndex: Integer; Length: Integer): TArray<AnsiChar>; overload;
    class function ToDouble(const S: AnsiString): Double; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToDouble: Double; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    class function ToExtended(const S: AnsiString): Extended; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToExtended: Extended; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    class function ToInt64(const S: AnsiString): Int64; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToInt64: Int64; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    class function ToInteger(const S: AnsiString): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToInteger: Integer; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToLower: AnsiString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToLower(LocaleID: TLocaleID): AnsiString; overload;
    function ToLowerInvariant: AnsiString;
    class function ToSingle(const S: AnsiString): Single; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToSingle: Single; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToUpper: AnsiString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToUpper(LocaleID: TLocaleID): AnsiString; overload;
    function ToUpperInvariant: AnsiString;
    function Trim: AnsiString; overload;
    function Trim(const TrimChars: array of AnsiChar): AnsiString; overload;
    function TrimEnd(const TrimChars: array of AnsiChar): AnsiString; {not yet supported inline;} deprecated 'Use TrimRight';
    function TrimLeft: AnsiString; overload;
    function TrimLeft(const TrimChars: array of AnsiChar): AnsiString; overload;
    function TrimRight: AnsiString; overload;
    function TrimRight(const TrimChars: array of AnsiChar): AnsiString; overload;
    function TrimStart(const TrimChars: array of AnsiChar): AnsiString; {not yet supported inline;} deprecated 'Use TrimLeft';
    class function UpperCase(const S: AnsiString): AnsiString; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function UpperCase(const S: AnsiString; LocaleOptions: TLocaleOptions): AnsiString; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    property Chars[Index: Integer]: AnsiChar read GetChars;
    property Length: Integer read GetLength;
  end;

  TRawByteStringHelper = record helper for RawByteString
  private
    function GetChars(Index: Integer): AnsiChar; {$IFDEF HAS_INLINE}inline;{$ENDIF}
    function GetLength: Integer; {$IFDEF HAS_INLINE}inline;{$ENDIF}
  public
    const Empty: RawByteString = '';
    class function Create(C: AnsiChar; Count: Integer): RawByteString; overload; {$IFNDEF _TEST}inline;{$ENDIF} static;
    class function Create(const Value: array of AnsiChar; StartIndex: Integer; Length: Integer): RawByteString; overload; static;
    class function Create(const Value: array of AnsiChar): RawByteString; overload; static;
    class function Compare(const StrA: RawByteString; const StrB: RawByteString): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: RawByteString; const StrB: RawByteString; LocaleID: TLocaleID): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: RawByteString; const StrB: RawByteString; IgnoreCase: Boolean): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: RawByteString; const StrB: RawByteString; IgnoreCase: Boolean; LocaleID: TLocaleID): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: RawByteString; IndexA: Integer; const StrB: RawByteString; IndexB: Integer; Length: Integer): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: RawByteString; IndexA: Integer; const StrB: RawByteString; IndexB: Integer; Length: Integer; LocaleID: TLocaleID): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: RawByteString; IndexA: Integer; const StrB: RawByteString; IndexB: Integer; Length: Integer; IgnoreCase: Boolean): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: RawByteString; IndexA: Integer; const StrB: RawByteString; IndexB: Integer; Length: Integer; IgnoreCase: Boolean; LocaleID: TLocaleID): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function CompareOrdinal(const StrA: RawByteString; const StrB: RawByteString): Integer; overload; static;
    class function CompareOrdinal(const StrA: RawByteString; IndexA: Integer; const StrB: RawByteString; IndexB: Integer; Length: Integer): Integer; overload; static;
    class function CompareText(const StrA: RawByteString; const StrB: RawByteString): Integer; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function CompareTo(const strB: RawByteString): Integer;
    function Contains(const Value: RawByteString): Boolean;
    class function Copy(const Str: RawByteString): RawByteString; static; {$IFNDEF _TEST}inline;{$ENDIF}
    procedure CopyTo(SourceIndex: Integer; var Destination: array of AnsiChar; DestinationIndex: Integer; Count: Integer);
    function CountChar(const C: AnsiChar): Integer;
    function DeQuotedString: RawByteString; overload;
    function DeQuotedString(const QuoteChar: AnsiChar): RawByteString; overload;
    class function EndsText(const ASubText, AText: RawByteString): Boolean; static;
    function EndsWith(const Value: RawByteString): Boolean; overload;
    function EndsWith(const Value: RawByteString; IgnoreCase: Boolean): Boolean; overload;
    function Equals(const Value: RawByteString): Boolean; overload;
    class function Equals(const Left: RawByteString; const Right: RawByteString): Boolean; overload; static;
    class function Format(const Format: RawByteString; const Args: array of const): RawByteString; overload; static;
    function IndexOf(value: AnsiChar): Integer; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function IndexOf(const Value: RawByteString): Integer; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function IndexOf(Value: AnsiChar; StartIndex: Integer): Integer; overload;
    function IndexOf(const Value: RawByteString; StartIndex: Integer): Integer; overload;
    function IndexOf(Value: AnsiChar; StartIndex: Integer; Count: Integer): Integer; overload;
    function IndexOf(const Value: RawByteString; StartIndex: Integer; Count: Integer): Integer; overload;
    function IndexOfAny(const AnyOf: array of AnsiChar): Integer; overload;
    function IndexOfAny(const AnyOf: array of AnsiChar; StartIndex: Integer): Integer; overload;
    function IndexOfAny(const AnyOf: array of AnsiChar; StartIndex: Integer; Count: Integer): Integer; overload;
    function IndexOfAnyUnquoted(const AnyOf: array of AnsiChar; StartQuote, EndQuote: AnsiChar): Integer; overload;
    function IndexOfAnyUnquoted(const AnyOf: array of AnsiChar; StartQuote, EndQuote: AnsiChar; StartIndex: Integer): Integer; overload;
    function IndexOfAnyUnquoted(const AnyOf: array of AnsiChar; StartQuote, EndQuote: AnsiChar; StartIndex: Integer; Count: Integer): Integer; overload;
    function Insert(StartIndex: Integer; const Value: RawByteString): RawByteString;
    function IsDelimiter(const Delimiters: RawByteString; Index: Integer): Boolean;
    function IsEmpty: Boolean;
    class function IsNullOrEmpty(const Value: RawByteString): Boolean; static;
    class function IsNullOrWhiteSpace(const Value: RawByteString): Boolean; static;
    class function Join(const Separator: RawByteString; const Values: array of const): RawByteString; overload; static;
    class function Join(const Separator: RawByteString; const Values: array of RawByteString): RawByteString; overload; static;
    class function Join(const Separator: RawByteString; const Values: IEnumerator<RawByteString>): RawByteString; overload; static;
    class function Join(const Separator: RawByteString; const Values: IEnumerable<RawByteString>): RawByteString; overload; static;
    class function Join(const Separator: RawByteString; const Value: array of RawByteString; StartIndex: Integer; Count: Integer): RawByteString; overload; static;
    function LastDelimiter(const Delims: RawByteString): Integer;
    function LastIndexOf(Value: AnsiChar): Integer; overload;
    function LastIndexOf(const Value: RawByteString): Integer; overload;
    function LastIndexOf(Value: AnsiChar; StartIndex: Integer): Integer; overload;
    function LastIndexOf(const Value: RawByteString; StartIndex: Integer): Integer; overload;
    function LastIndexOf(Value: AnsiChar; StartIndex: Integer; Count: Integer): Integer; overload;
    function LastIndexOf(const Value: RawByteString; StartIndex: Integer; Count: Integer): Integer; overload;
    function LastIndexOfAny(const AnyOf: array of AnsiChar): Integer; overload;
    function LastIndexOfAny(const AnyOf: array of AnsiChar; StartIndex: Integer): Integer; overload;
    function LastIndexOfAny(const AnyOf: array of AnsiChar; StartIndex: Integer; Count: Integer): Integer; overload;
    class function LowerCase(const S: RawByteString): RawByteString; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function LowerCase(const S: RawByteString; LocaleOptions: TLocaleOptions): RawByteString; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function PadLeft(TotalWidth: Integer): RawByteString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function PadLeft(TotalWidth: Integer; PaddingChar: AnsiChar): RawByteString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function PadRight(TotalWidth: Integer): RawByteString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function PadRight(TotalWidth: Integer; PaddingChar: AnsiChar): RawByteString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Parse(const Value: Integer): RawByteString; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Parse(const Value: Int64): RawByteString; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Parse(const Value: Boolean): RawByteString; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Parse(const Value: Extended): RawByteString; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function QuotedString: RawByteString; overload;
    function QuotedString(const QuoteChar: AnsiChar): RawByteString; overload;
    function Remove(StartIndex: Integer): RawByteString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function Remove(StartIndex: Integer; Count: Integer): RawByteString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function Replace(OldChar: AnsiChar; NewChar: AnsiChar): RawByteString; overload;
    function Replace(OldChar: AnsiChar; NewChar: AnsiChar; ReplaceFlags: TReplaceFlags): RawByteString; overload;
    function Replace(const OldValue: RawByteString; const NewValue: RawByteString): RawByteString; overload;
    function Replace(const OldValue: RawByteString; const NewValue: RawByteString; ReplaceFlags: TReplaceFlags): RawByteString; overload;
    function Split(const Separator: array of AnsiChar): TArray<RawByteString>; overload;
    function Split(const Separator: array of AnsiChar; Count: Integer): TArray<RawByteString>; overload;
    function Split(const Separator: array of AnsiChar; Options: TStringSplitOptions): TArray<RawByteString>; overload;
    function Split(const Separator: array of RawByteString; Options: TStringSplitOptions): TArray<RawByteString>; overload;
    function Split(const Separator: array of AnsiChar; Count: Integer; Options: TStringSplitOptions): TArray<RawByteString>; overload;
    function Split(const Separator: array of RawByteString; Count: Integer; Options: TStringSplitOptions): TArray<RawByteString>; overload;
    function StartsWith(const Value: RawByteString): Boolean; overload;
    function StartsWith(const Value: RawByteString; IgnoreCase: Boolean): Boolean; overload;
    function Substring(StartIndex: Integer): RawByteString; overload;
    function Substring(StartIndex: Integer; Length: Integer): RawByteString; overload;
    class function ToBoolean(const S: RawByteString): Boolean; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToBoolean: Boolean; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToCharArray: TArray<AnsiChar>; overload;
    function ToCharArray(StartIndex: Integer; Length: Integer): TArray<AnsiChar>; overload;
    class function ToDouble(const S: RawByteString): Double; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToDouble: Double; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    class function ToExtended(const S: RawByteString): Extended; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToExtended: Extended; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    class function ToInt64(const S: RawByteString): Int64; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToInt64: Int64; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    class function ToInteger(const S: RawByteString): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToInteger: Integer; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToLower: RawByteString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToLower(LocaleID: TLocaleID): RawByteString; overload;
    function ToLowerInvariant: RawByteString;
    class function ToSingle(const S: RawByteString): Single; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToSingle: Single; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToUpper: RawByteString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToUpper(LocaleID: TLocaleID): RawByteString; overload;
    function ToUpperInvariant: RawByteString;
    function Trim: RawByteString; overload;
    function Trim(const TrimChars: array of AnsiChar): RawByteString; overload;
    function TrimEnd(const TrimChars: array of AnsiChar): RawByteString; {not yet supported inline;} deprecated 'Use TrimRight';
    function TrimLeft: RawByteString; overload;
    function TrimLeft(const TrimChars: array of AnsiChar): RawByteString; overload;
    function TrimRight: RawByteString; overload;
    function TrimRight(const TrimChars: array of AnsiChar): RawByteString; overload;
    function TrimStart(const TrimChars: array of AnsiChar): RawByteString; {not yet supported inline;} deprecated 'Use TrimLeft';
    class function UpperCase(const S: RawByteString): RawByteString; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function UpperCase(const S: RawByteString; LocaleOptions: TLocaleOptions): RawByteString; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    property Chars[Index: Integer]: AnsiChar read GetChars;
    property Length: Integer read GetLength;
  end;

  TUTF8StringHelper = record helper for UTF8String
  private
    function GetChars(Index: Integer): AnsiChar; {$IFDEF HAS_INLINE}inline;{$ENDIF}
    function GetLength: Integer; {$IFDEF HAS_INLINE}inline;{$ENDIF}
  public
    const Empty: UTF8String = '';
    class function Create(C: AnsiChar; Count: Integer): UTF8String; overload; {$IFNDEF _TEST}inline;{$ENDIF} static;
    class function Create(const Value: array of AnsiChar; StartIndex: Integer; Length: Integer): UTF8String; overload; static;
    class function Create(const Value: array of AnsiChar): UTF8String; overload; static;
    class function Compare(const StrA: UTF8String; const StrB: UTF8String): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: UTF8String; const StrB: UTF8String; LocaleID: TLocaleID): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: UTF8String; const StrB: UTF8String; IgnoreCase: Boolean): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: UTF8String; const StrB: UTF8String; IgnoreCase: Boolean; LocaleID: TLocaleID): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: UTF8String; IndexA: Integer; const StrB: UTF8String; IndexB: Integer; Length: Integer): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: UTF8String; IndexA: Integer; const StrB: UTF8String; IndexB: Integer; Length: Integer; LocaleID: TLocaleID): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: UTF8String; IndexA: Integer; const StrB: UTF8String; IndexB: Integer; Length: Integer; IgnoreCase: Boolean): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: UTF8String; IndexA: Integer; const StrB: UTF8String; IndexB: Integer; Length: Integer; IgnoreCase: Boolean; LocaleID: TLocaleID): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function CompareOrdinal(const StrA: UTF8String; const StrB: UTF8String): Integer; overload; static;
    class function CompareOrdinal(const StrA: UTF8String; IndexA: Integer; const StrB: UTF8String; IndexB: Integer; Length: Integer): Integer; overload; static;
    class function CompareText(const StrA: UTF8String; const StrB: UTF8String): Integer; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function CompareTo(const strB: UTF8String): Integer;
    function Contains(const Value: UTF8String): Boolean;
    class function Copy(const Str: UTF8String): UTF8String; static; {$IFNDEF _TEST}inline;{$ENDIF}
    procedure CopyTo(SourceIndex: Integer; var Destination: array of AnsiChar; DestinationIndex: Integer; Count: Integer);
    function CountChar(const C: AnsiChar): Integer;
    function DeQuotedString: UTF8String; overload;
    function DeQuotedString(const QuoteChar: AnsiChar): UTF8String; overload;
    class function EndsText(const ASubText, AText: UTF8String): Boolean; static;
    function EndsWith(const Value: UTF8String): Boolean; overload;
    function EndsWith(const Value: UTF8String; IgnoreCase: Boolean): Boolean; overload;
    function Equals(const Value: UTF8String): Boolean; overload;
    class function Equals(const Left: UTF8String; const Right: UTF8String): Boolean; overload; static;
    class function Format(const Format: UTF8String; const Args: array of const): UTF8String; overload; static;
    function IndexOf(value: AnsiChar): Integer; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function IndexOf(const Value: UTF8String): Integer; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function IndexOf(Value: AnsiChar; StartIndex: Integer): Integer; overload;
    function IndexOf(const Value: UTF8String; StartIndex: Integer): Integer; overload;
    function IndexOf(Value: AnsiChar; StartIndex: Integer; Count: Integer): Integer; overload;
    function IndexOf(const Value: UTF8String; StartIndex: Integer; Count: Integer): Integer; overload;
    function IndexOfAny(const AnyOf: array of AnsiChar): Integer; overload;
    function IndexOfAny(const AnyOf: array of AnsiChar; StartIndex: Integer): Integer; overload;
    function IndexOfAny(const AnyOf: array of AnsiChar; StartIndex: Integer; Count: Integer): Integer; overload;
    function IndexOfAnyUnquoted(const AnyOf: array of AnsiChar; StartQuote, EndQuote: AnsiChar): Integer; overload;
    function IndexOfAnyUnquoted(const AnyOf: array of AnsiChar; StartQuote, EndQuote: AnsiChar; StartIndex: Integer): Integer; overload;
    function IndexOfAnyUnquoted(const AnyOf: array of AnsiChar; StartQuote, EndQuote: AnsiChar; StartIndex: Integer; Count: Integer): Integer; overload;
    function Insert(StartIndex: Integer; const Value: UTF8String): UTF8String;
    function IsDelimiter(const Delimiters: UTF8String; Index: Integer): Boolean;
    function IsEmpty: Boolean;
    class function IsNullOrEmpty(const Value: UTF8String): Boolean; static;
    class function IsNullOrWhiteSpace(const Value: UTF8String): Boolean; static;
    class function Join(const Separator: UTF8String; const Values: array of const): UTF8String; overload; static;
    class function Join(const Separator: UTF8String; const Values: array of UTF8String): UTF8String; overload; static;
    class function Join(const Separator: UTF8String; const Values: IEnumerator<UTF8String>): UTF8String; overload; static;
    class function Join(const Separator: UTF8String; const Values: IEnumerable<UTF8String>): UTF8String; overload; static;
    class function Join(const Separator: UTF8String; const Value: array of UTF8String; StartIndex: Integer; Count: Integer): UTF8String; overload; static;
    function LastDelimiter(const Delims: UTF8String): Integer;
    function LastIndexOf(Value: AnsiChar): Integer; overload;
    function LastIndexOf(const Value: UTF8String): Integer; overload;
    function LastIndexOf(Value: AnsiChar; StartIndex: Integer): Integer; overload;
    function LastIndexOf(const Value: UTF8String; StartIndex: Integer): Integer; overload;
    function LastIndexOf(Value: AnsiChar; StartIndex: Integer; Count: Integer): Integer; overload;
    function LastIndexOf(const Value: UTF8String; StartIndex: Integer; Count: Integer): Integer; overload;
    function LastIndexOfAny(const AnyOf: array of AnsiChar): Integer; overload;
    function LastIndexOfAny(const AnyOf: array of AnsiChar; StartIndex: Integer): Integer; overload;
    function LastIndexOfAny(const AnyOf: array of AnsiChar; StartIndex: Integer; Count: Integer): Integer; overload;
    class function LowerCase(const S: UTF8String): UTF8String; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function LowerCase(const S: UTF8String; LocaleOptions: TLocaleOptions): UTF8String; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function PadLeft(TotalWidth: Integer): UTF8String; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function PadLeft(TotalWidth: Integer; PaddingChar: AnsiChar): UTF8String; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function PadRight(TotalWidth: Integer): UTF8String; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function PadRight(TotalWidth: Integer; PaddingChar: AnsiChar): UTF8String; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Parse(const Value: Integer): UTF8String; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Parse(const Value: Int64): UTF8String; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Parse(const Value: Boolean): UTF8String; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Parse(const Value: Extended): UTF8String; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function QuotedString: UTF8String; overload;
    function QuotedString(const QuoteChar: AnsiChar): UTF8String; overload;
    function Remove(StartIndex: Integer): UTF8String; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function Remove(StartIndex: Integer; Count: Integer): UTF8String; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function Replace(OldChar: AnsiChar; NewChar: AnsiChar): UTF8String; overload;
    function Replace(OldChar: AnsiChar; NewChar: AnsiChar; ReplaceFlags: TReplaceFlags): UTF8String; overload;
    function Replace(const OldValue: UTF8String; const NewValue: UTF8String): UTF8String; overload;
    function Replace(const OldValue: UTF8String; const NewValue: UTF8String; ReplaceFlags: TReplaceFlags): UTF8String; overload;
    function Split(const Separator: array of AnsiChar): TArray<UTF8String>; overload;
    function Split(const Separator: array of AnsiChar; Count: Integer): TArray<UTF8String>; overload;
    function Split(const Separator: array of AnsiChar; Options: TStringSplitOptions): TArray<UTF8String>; overload;
    function Split(const Separator: array of UTF8String; Options: TStringSplitOptions): TArray<UTF8String>; overload;
    function Split(const Separator: array of AnsiChar; Count: Integer; Options: TStringSplitOptions): TArray<UTF8String>; overload;
    function Split(const Separator: array of UTF8String; Count: Integer; Options: TStringSplitOptions): TArray<UTF8String>; overload;
    function StartsWith(const Value: UTF8String): Boolean; overload;
    function StartsWith(const Value: UTF8String; IgnoreCase: Boolean): Boolean; overload;
    function Substring(StartIndex: Integer): UTF8String; overload;
    function Substring(StartIndex: Integer; Length: Integer): UTF8String; overload;
    class function ToBoolean(const S: UTF8String): Boolean; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToBoolean: Boolean; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToCharArray: TArray<AnsiChar>; overload;
    function ToCharArray(StartIndex: Integer; Length: Integer): TArray<AnsiChar>; overload;
    class function ToDouble(const S: UTF8String): Double; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToDouble: Double; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    class function ToExtended(const S: UTF8String): Extended; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToExtended: Extended; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    class function ToInt64(const S: UTF8String): Int64; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToInt64: Int64; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    class function ToInteger(const S: UTF8String): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToInteger: Integer; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToLower: UTF8String; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToLower(LocaleID: TLocaleID): UTF8String; overload;
    function ToLowerInvariant: UTF8String;
    class function ToSingle(const S: UTF8String): Single; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToSingle: Single; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToUpper: UTF8String; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToUpper(LocaleID: TLocaleID): UTF8String; overload;
    function ToUpperInvariant: UTF8String;
    function Trim: UTF8String; overload;
    function Trim(const TrimChars: array of AnsiChar): UTF8String; overload;
    function TrimEnd(const TrimChars: array of AnsiChar): UTF8String; {not yet supported inline;} deprecated 'Use TrimRight';
    function TrimLeft: UTF8String; overload;
    function TrimLeft(const TrimChars: array of AnsiChar): UTF8String; overload;
    function TrimRight: UTF8String; overload;
    function TrimRight(const TrimChars: array of AnsiChar): UTF8String; overload;
    function TrimStart(const TrimChars: array of AnsiChar): UTF8String; {not yet supported inline;} deprecated 'Use TrimLeft';
    class function UpperCase(const S: UTF8String): UTF8String; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function UpperCase(const S: UTF8String; LocaleOptions: TLocaleOptions): UTF8String; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    property Chars[Index: Integer]: AnsiChar read GetChars;
    property Length: Integer read GetLength;
  end;

  TWideStringHelper = record helper for WideString
  private
    function GetChars(Index: Integer): WideChar; {$IFDEF HAS_INLINE}inline;{$ENDIF}
    function GetLength: Integer; {$IFDEF HAS_INLINE}inline;{$ENDIF}
  public
    const Empty: WideString = '';
    class function Create(C: WideChar; Count: Integer): WideString; overload; {$IFNDEF _TEST}inline;{$ENDIF} static;
    class function Create(const Value: array of WideChar; StartIndex: Integer; Length: Integer): WideString; overload; static;
    class function Create(const Value: array of WideChar): WideString; overload; static;
    class function Compare(const StrA: WideString; const StrB: WideString): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: WideString; const StrB: WideString; LocaleID: TLocaleID): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: WideString; const StrB: WideString; IgnoreCase: Boolean): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: WideString; const StrB: WideString; IgnoreCase: Boolean; LocaleID: TLocaleID): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: WideString; IndexA: Integer; const StrB: WideString; IndexB: Integer; Length: Integer): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: WideString; IndexA: Integer; const StrB: WideString; IndexB: Integer; Length: Integer; LocaleID: TLocaleID): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: WideString; IndexA: Integer; const StrB: WideString; IndexB: Integer; Length: Integer; IgnoreCase: Boolean): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: WideString; IndexA: Integer; const StrB: WideString; IndexB: Integer; Length: Integer; IgnoreCase: Boolean; LocaleID: TLocaleID): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function CompareOrdinal(const StrA: WideString; const StrB: WideString): Integer; overload; static;
    class function CompareOrdinal(const StrA: WideString; IndexA: Integer; const StrB: WideString; IndexB: Integer; Length: Integer): Integer; overload; static;
    class function CompareText(const StrA: WideString; const StrB: WideString): Integer; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function CompareTo(const strB: WideString): Integer;
    function Contains(const Value: WideString): Boolean;
    class function Copy(const Str: WideString): WideString; static; {$IFNDEF _TEST}inline;{$ENDIF}
    procedure CopyTo(SourceIndex: Integer; var Destination: array of WideChar; DestinationIndex: Integer; Count: Integer);
    function CountChar(const C: WideChar): Integer;
    function DeQuotedString: WideString; overload;
    function DeQuotedString(const QuoteChar: WideChar): WideString; overload;
    class function EndsText(const ASubText, AText: WideString): Boolean; static;
    function EndsWith(const Value: WideString): Boolean; overload;
    function EndsWith(const Value: WideString; IgnoreCase: Boolean): Boolean; overload;
    function Equals(const Value: WideString): Boolean; overload;
    class function Equals(const Left: WideString; const Right: WideString): Boolean; overload; static;
    class function Format(const Format: WideString; const Args: array of const): WideString; overload; static;
    function IndexOf(value: WideChar): Integer; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function IndexOf(const Value: WideString): Integer; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function IndexOf(Value: WideChar; StartIndex: Integer): Integer; overload;
    function IndexOf(const Value: WideString; StartIndex: Integer): Integer; overload;
    function IndexOf(Value: WideChar; StartIndex: Integer; Count: Integer): Integer; overload;
    function IndexOf(const Value: WideString; StartIndex: Integer; Count: Integer): Integer; overload;
    function IndexOfAny(const AnyOf: array of WideChar): Integer; overload;
    function IndexOfAny(const AnyOf: array of WideChar; StartIndex: Integer): Integer; overload;
    function IndexOfAny(const AnyOf: array of WideChar; StartIndex: Integer; Count: Integer): Integer; overload;
    function IndexOfAnyUnquoted(const AnyOf: array of WideChar; StartQuote, EndQuote: WideChar): Integer; overload;
    function IndexOfAnyUnquoted(const AnyOf: array of WideChar; StartQuote, EndQuote: WideChar; StartIndex: Integer): Integer; overload;
    function IndexOfAnyUnquoted(const AnyOf: array of WideChar; StartQuote, EndQuote: WideChar; StartIndex: Integer; Count: Integer): Integer; overload;
    function Insert(StartIndex: Integer; const Value: WideString): WideString;
    function IsDelimiter(const Delimiters: WideString; Index: Integer): Boolean;
    function IsEmpty: Boolean;
    class function IsNullOrEmpty(const Value: WideString): Boolean; static;
    class function IsNullOrWhiteSpace(const Value: WideString): Boolean; static;
    class function Join(const Separator: WideString; const Values: array of const): WideString; overload; static;
    class function Join(const Separator: WideString; const Values: array of WideString): WideString; overload; static;
    class function Join(const Separator: WideString; const Values: IEnumerator<WideString>): WideString; overload; static;
    class function Join(const Separator: WideString; const Values: IEnumerable<WideString>): WideString; overload; static;
    class function Join(const Separator: WideString; const Value: array of WideString; StartIndex: Integer; Count: Integer): WideString; overload; static;
    function LastDelimiter(const Delims: WideString): Integer;
    function LastIndexOf(Value: WideChar): Integer; overload;
    function LastIndexOf(const Value: WideString): Integer; overload;
    function LastIndexOf(Value: WideChar; StartIndex: Integer): Integer; overload;
    function LastIndexOf(const Value: WideString; StartIndex: Integer): Integer; overload;
    function LastIndexOf(Value: WideChar; StartIndex: Integer; Count: Integer): Integer; overload;
    function LastIndexOf(const Value: WideString; StartIndex: Integer; Count: Integer): Integer; overload;
    function LastIndexOfAny(const AnyOf: array of WideChar): Integer; overload;
    function LastIndexOfAny(const AnyOf: array of WideChar; StartIndex: Integer): Integer; overload;
    function LastIndexOfAny(const AnyOf: array of WideChar; StartIndex: Integer; Count: Integer): Integer; overload;
    class function LowerCase(const S: WideString): WideString; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function LowerCase(const S: WideString; LocaleOptions: TLocaleOptions): WideString; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function PadLeft(TotalWidth: Integer): WideString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function PadLeft(TotalWidth: Integer; PaddingChar: WideChar): WideString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function PadRight(TotalWidth: Integer): WideString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function PadRight(TotalWidth: Integer; PaddingChar: WideChar): WideString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Parse(const Value: Integer): WideString; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Parse(const Value: Int64): WideString; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Parse(const Value: Boolean): WideString; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Parse(const Value: Extended): WideString; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function QuotedString: WideString; overload;
    function QuotedString(const QuoteChar: WideChar): WideString; overload;
    function Remove(StartIndex: Integer): WideString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function Remove(StartIndex: Integer; Count: Integer): WideString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function Replace(OldChar: WideChar; NewChar: WideChar): WideString; overload;
    function Replace(OldChar: WideChar; NewChar: WideChar; ReplaceFlags: TReplaceFlags): WideString; overload;
    function Replace(const OldValue: WideString; const NewValue: WideString): WideString; overload;
    function Replace(const OldValue: WideString; const NewValue: WideString; ReplaceFlags: TReplaceFlags): WideString; overload;
    function Split(const Separator: array of WideChar): TArray<WideString>; overload;
    function Split(const Separator: array of WideChar; Count: Integer): TArray<WideString>; overload;
    function Split(const Separator: array of WideChar; Options: TStringSplitOptions): TArray<WideString>; overload;
    function Split(const Separator: array of WideString; Options: TStringSplitOptions): TArray<WideString>; overload;
    function Split(const Separator: array of WideChar; Count: Integer; Options: TStringSplitOptions): TArray<WideString>; overload;
    function Split(const Separator: array of WideString; Count: Integer; Options: TStringSplitOptions): TArray<WideString>; overload;
    function StartsWith(const Value: WideString): Boolean; overload;
    function StartsWith(const Value: WideString; IgnoreCase: Boolean): Boolean; overload;
    function Substring(StartIndex: Integer): WideString; overload;
    function Substring(StartIndex: Integer; Length: Integer): WideString; overload;
    class function ToBoolean(const S: WideString): Boolean; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToBoolean: Boolean; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToCharArray: TArray<WideChar>; overload;
    function ToCharArray(StartIndex: Integer; Length: Integer): TArray<WideChar>; overload;
    class function ToDouble(const S: WideString): Double; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToDouble: Double; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    class function ToExtended(const S: WideString): Extended; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToExtended: Extended; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    class function ToInt64(const S: WideString): Int64; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToInt64: Int64; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    class function ToInteger(const S: WideString): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToInteger: Integer; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToLower: WideString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToLower(LocaleID: TLocaleID): WideString; overload;
    function ToLowerInvariant: WideString;
    class function ToSingle(const S: WideString): Single; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToSingle: Single; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToUpper: WideString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToUpper(LocaleID: TLocaleID): WideString; overload;
    function ToUpperInvariant: WideString;
    function Trim: WideString; overload;
    function Trim(const TrimChars: array of WideChar): WideString; overload;
    function TrimEnd(const TrimChars: array of WideChar): WideString; {not yet supported inline;} deprecated 'Use TrimRight';
    function TrimLeft: WideString; overload;
    function TrimLeft(const TrimChars: array of WideChar): WideString; overload;
    function TrimRight: WideString; overload;
    function TrimRight(const TrimChars: array of WideChar): WideString; overload;
    function TrimStart(const TrimChars: array of WideChar): WideString; {not yet supported inline;} deprecated 'Use TrimLeft';
    class function UpperCase(const S: WideString): WideString; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function UpperCase(const S: WideString; LocaleOptions: TLocaleOptions): WideString; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    property Chars[Index: Integer]: WideChar read GetChars;
    property Length: Integer read GetLength;
  end;

  TUnicodeStringHelper = record helper for UnicodeString
  private
    function GetChars(Index: Integer): UnicodeChar; {$IFDEF HAS_INLINE}inline;{$ENDIF}
    function GetLength: Integer; {$IFDEF HAS_INLINE}inline;{$ENDIF}
  public
    const Empty: UnicodeString = '';
    class function Create(C: UnicodeChar; Count: Integer): UnicodeString; overload; {$IFNDEF _TEST}inline;{$ENDIF} static;
    class function Create(const Value: array of UnicodeChar; StartIndex: Integer; Length: Integer): UnicodeString; overload; static;
    class function Create(const Value: array of UnicodeChar): UnicodeString; overload; static;
    class function Compare(const StrA: UnicodeString; const StrB: UnicodeString): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: UnicodeString; const StrB: UnicodeString; LocaleID: TLocaleID): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: UnicodeString; const StrB: UnicodeString; IgnoreCase: Boolean): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: UnicodeString; const StrB: UnicodeString; IgnoreCase: Boolean; LocaleID: TLocaleID): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: UnicodeString; IndexA: Integer; const StrB: UnicodeString; IndexB: Integer; Length: Integer): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: UnicodeString; IndexA: Integer; const StrB: UnicodeString; IndexB: Integer; Length: Integer; LocaleID: TLocaleID): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: UnicodeString; IndexA: Integer; const StrB: UnicodeString; IndexB: Integer; Length: Integer; IgnoreCase: Boolean): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Compare(const StrA: UnicodeString; IndexA: Integer; const StrB: UnicodeString; IndexB: Integer; Length: Integer; IgnoreCase: Boolean; LocaleID: TLocaleID): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function CompareOrdinal(const StrA: UnicodeString; const StrB: UnicodeString): Integer; overload; static;
    class function CompareOrdinal(const StrA: UnicodeString; IndexA: Integer; const StrB: UnicodeString; IndexB: Integer; Length: Integer): Integer; overload; static;
    class function CompareText(const StrA: UnicodeString; const StrB: UnicodeString): Integer; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function CompareTo(const strB: UnicodeString): Integer;
    function Contains(const Value: UnicodeString): Boolean;
    class function Copy(const Str: UnicodeString): UnicodeString; static; {$IFNDEF _TEST}inline;{$ENDIF}
    procedure CopyTo(SourceIndex: Integer; var Destination: array of UnicodeChar; DestinationIndex: Integer; Count: Integer);
    function CountChar(const C: UnicodeChar): Integer;
    function DeQuotedString: UnicodeString; overload;
    function DeQuotedString(const QuoteChar: UnicodeChar): UnicodeString; overload;
    class function EndsText(const ASubText, AText: UnicodeString): Boolean; static;
    function EndsWith(const Value: UnicodeString): Boolean; overload;
    function EndsWith(const Value: UnicodeString; IgnoreCase: Boolean): Boolean; overload;
    function Equals(const Value: UnicodeString): Boolean; overload;
    class function Equals(const Left: UnicodeString; const Right: UnicodeString): Boolean; overload; static;
    class function Format(const Format: UnicodeString; const Args: array of const): UnicodeString; overload; static;
    function IndexOf(value: UnicodeChar): Integer; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function IndexOf(const Value: UnicodeString): Integer; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function IndexOf(Value: UnicodeChar; StartIndex: Integer): Integer; overload;
    function IndexOf(const Value: UnicodeString; StartIndex: Integer): Integer; overload;
    function IndexOf(Value: UnicodeChar; StartIndex: Integer; Count: Integer): Integer; overload;
    function IndexOf(const Value: UnicodeString; StartIndex: Integer; Count: Integer): Integer; overload;
    function IndexOfAny(const AnyOf: array of UnicodeChar): Integer; overload;
    function IndexOfAny(const AnyOf: array of UnicodeChar; StartIndex: Integer): Integer; overload;
    function IndexOfAny(const AnyOf: array of UnicodeChar; StartIndex: Integer; Count: Integer): Integer; overload;
    function IndexOfAnyUnquoted(const AnyOf: array of UnicodeChar; StartQuote, EndQuote: UnicodeChar): Integer; overload;
    function IndexOfAnyUnquoted(const AnyOf: array of UnicodeChar; StartQuote, EndQuote: UnicodeChar; StartIndex: Integer): Integer; overload;
    function IndexOfAnyUnquoted(const AnyOf: array of UnicodeChar; StartQuote, EndQuote: UnicodeChar; StartIndex: Integer; Count: Integer): Integer; overload;
    function Insert(StartIndex: Integer; const Value: UnicodeString): UnicodeString;
    function IsDelimiter(const Delimiters: UnicodeString; Index: Integer): Boolean;
    function IsEmpty: Boolean;
    class function IsNullOrEmpty(const Value: UnicodeString): Boolean; static;
    class function IsNullOrWhiteSpace(const Value: UnicodeString): Boolean; static;
    class function Join(const Separator: UnicodeString; const Values: array of const): UnicodeString; overload; static;
    class function Join(const Separator: UnicodeString; const Values: array of UnicodeString): UnicodeString; overload; static;
    class function Join(const Separator: UnicodeString; const Values: IEnumerator<UnicodeString>): UnicodeString; overload; static;
    class function Join(const Separator: UnicodeString; const Values: IEnumerable<UnicodeString>): UnicodeString; overload; static;
    class function Join(const Separator: UnicodeString; const Value: array of UnicodeString; StartIndex: Integer; Count: Integer): UnicodeString; overload; static;
    function LastDelimiter(const Delims: UnicodeString): Integer;
    function LastIndexOf(Value: UnicodeChar): Integer; overload;
    function LastIndexOf(const Value: UnicodeString): Integer; overload;
    function LastIndexOf(Value: UnicodeChar; StartIndex: Integer): Integer; overload;
    function LastIndexOf(const Value: UnicodeString; StartIndex: Integer): Integer; overload;
    function LastIndexOf(Value: UnicodeChar; StartIndex: Integer; Count: Integer): Integer; overload;
    function LastIndexOf(const Value: UnicodeString; StartIndex: Integer; Count: Integer): Integer; overload;
    function LastIndexOfAny(const AnyOf: array of UnicodeChar): Integer; overload;
    function LastIndexOfAny(const AnyOf: array of UnicodeChar; StartIndex: Integer): Integer; overload;
    function LastIndexOfAny(const AnyOf: array of UnicodeChar; StartIndex: Integer; Count: Integer): Integer; overload;
    class function LowerCase(const S: UnicodeString): UnicodeString; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function LowerCase(const S: UnicodeString; LocaleOptions: TLocaleOptions): UnicodeString; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function PadLeft(TotalWidth: Integer): UnicodeString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function PadLeft(TotalWidth: Integer; PaddingChar: UnicodeChar): UnicodeString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function PadRight(TotalWidth: Integer): UnicodeString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function PadRight(TotalWidth: Integer; PaddingChar: UnicodeChar): UnicodeString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Parse(const Value: Integer): UnicodeString; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Parse(const Value: Int64): UnicodeString; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Parse(const Value: Boolean): UnicodeString; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function Parse(const Value: Extended): UnicodeString; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function QuotedString: UnicodeString; overload;
    function QuotedString(const QuoteChar: UnicodeChar): UnicodeString; overload;
    function Remove(StartIndex: Integer): UnicodeString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function Remove(StartIndex: Integer; Count: Integer): UnicodeString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function Replace(OldChar: UnicodeChar; NewChar: UnicodeChar): UnicodeString; overload;
    function Replace(OldChar: UnicodeChar; NewChar: UnicodeChar; ReplaceFlags: TReplaceFlags): UnicodeString; overload;
    function Replace(const OldValue: UnicodeString; const NewValue: UnicodeString): UnicodeString; overload;
    function Replace(const OldValue: UnicodeString; const NewValue: UnicodeString; ReplaceFlags: TReplaceFlags): UnicodeString; overload;
    function Split(const Separator: array of UnicodeChar): TArray<UnicodeString>; overload;
    function Split(const Separator: array of UnicodeChar; Count: Integer): TArray<UnicodeString>; overload;
    function Split(const Separator: array of UnicodeChar; Options: TStringSplitOptions): TArray<UnicodeString>; overload;
    function Split(const Separator: array of UnicodeString; Options: TStringSplitOptions): TArray<UnicodeString>; overload;
    function Split(const Separator: array of UnicodeChar; Count: Integer; Options: TStringSplitOptions): TArray<UnicodeString>; overload;
    function Split(const Separator: array of UnicodeString; Count: Integer; Options: TStringSplitOptions): TArray<UnicodeString>; overload;
    function StartsWith(const Value: UnicodeString): Boolean; overload;
    function StartsWith(const Value: UnicodeString; IgnoreCase: Boolean): Boolean; overload;
    function Substring(StartIndex: Integer): UnicodeString; overload;
    function Substring(StartIndex: Integer; Length: Integer): UnicodeString; overload;
    class function ToBoolean(const S: UnicodeString): Boolean; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToBoolean: Boolean; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToCharArray: TArray<UnicodeChar>; overload;
    function ToCharArray(StartIndex: Integer; Length: Integer): TArray<UnicodeChar>; overload;
    class function ToDouble(const S: UnicodeString): Double; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToDouble: Double; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    class function ToExtended(const S: UnicodeString): Extended; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToExtended: Extended; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    class function ToInt64(const S: UnicodeString): Int64; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToInt64: Int64; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    class function ToInteger(const S: UnicodeString): Integer; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToInteger: Integer; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToLower: UnicodeString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToLower(LocaleID: TLocaleID): UnicodeString; overload;
    function ToLowerInvariant: UnicodeString;
    class function ToSingle(const S: UnicodeString): Single; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToSingle: Single; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToUpper: UnicodeString; overload; {$IFNDEF _TEST}inline;{$ENDIF}
    function ToUpper(LocaleID: TLocaleID): UnicodeString; overload;
    function ToUpperInvariant: UnicodeString;
    function Trim: UnicodeString; overload;
    function Trim(const TrimChars: array of UnicodeChar): UnicodeString; overload;
    function TrimEnd(const TrimChars: array of UnicodeChar): UnicodeString; {not yet supported inline;} deprecated 'Use TrimRight';
    function TrimLeft: UnicodeString; overload;
    function TrimLeft(const TrimChars: array of UnicodeChar): UnicodeString; overload;
    function TrimRight: UnicodeString; overload;
    function TrimRight(const TrimChars: array of UnicodeChar): UnicodeString; overload;
    function TrimStart(const TrimChars: array of UnicodeChar): UnicodeString; {not yet supported inline;} deprecated 'Use TrimLeft';
    class function UpperCase(const S: UnicodeString): UnicodeString; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    class function UpperCase(const S: UnicodeString; LocaleOptions: TLocaleOptions): UnicodeString; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    property Chars[Index: Integer]: UnicodeChar read GetChars;
    property Length: Integer read GetLength;
  end;


implementation

uses
  System.Helpers.Strings;

{ TGuidHelper }

class function TGuidHelper.Create(const S: AnsiString): TGUID;
begin
  Result := StringToGUID(S);
end;

class function TGuidHelper.Create(const S: UnicodeString): TGUID;
begin
  Result := StringToGUID(AnsiString(S));
end;

class function TGuidHelper.Create(const Data; DataEndian: TEndian): TGUID;
begin
  Result := TGUID(Data);
  if DataEndian = {$IFDEF ENDIAN_BIG}TEndian.Little{$ELSE}TEndian.Big{$ENDIF} then
  begin
    Result.D1 := SwapEndian(Result.D1);
    Result.D2 := SwapEndian(Result.D2);
    Result.D3 := SwapEndian(Result.D3);
  end;
end;

class function TGuidHelper.Create(const B: TBytes; DataEndian: TEndian): TGUID;
begin
  Result := Create(B, 0, DataEndian);
end;

class function TGuidHelper.Create(const B: TBytes; AStartIndex: Cardinal; DataEndian: TEndian): TGUID;
var
  MaxIndex: TDynArrayIndex;
begin
  MaxIndex := TDynArrayIndex(AStartIndex + SizeOf(TGUID));
  if MaxIndex < 0 then
    OutOfMemoryError;

  if Length(B) >= MaxIndex then
    Result := Create(B[AStartIndex], DataEndian)
  else
    raise EArgumentException.CreateResFmt(@SInvalidGuidArray, [SizeOf(TGUID)]);
end;

class function TGuidHelper.Create(A: Integer; B: SmallInt; C: SmallInt; const D: TBytes): TGUID;
begin
  if Length(D) = Length(Result.D4) then
  begin
    Result.D1 := DWord(A);
    Result.D2 := Word(B);
    Result.D3 := Word(C);
    Move(D[0], Result.D4[0], SizeOf(Result.D4));
  end
  else
    raise EArgumentException.CreateFmt(SInvalidGuidArray, [8]);
end;

class function TGuidHelper.Create(A: Integer; B: SmallInt; C: SmallInt; D, E, F, G, H, I, J, K: Byte): TGUID;
begin
  Result.D1 := DWord(A);
  Result.D2 := Word(B);
  Result.D3 := Word(C);
  Result.D4[0] := D;
  Result.D4[1] := E;
  Result.D4[2] := F;
  Result.D4[3] := G;
  Result.D4[4] := H;
  Result.D4[5] := I;
  Result.D4[6] := J;
  Result.D4[7] := K;
end;

class function TGuidHelper.Create(A: Cardinal; B: Word; C: Word; D, E, F, G, H, I, J, K: Byte): TGUID;
begin
  Result.D1 := A;
  Result.D2 := B;
  Result.D3 := C;
  Result.D4[0] := D;
  Result.D4[1] := E;
  Result.D4[2] := F;
  Result.D4[3] := G;
  Result.D4[4] := H;
  Result.D4[5] := I;
  Result.D4[6] := J;
  Result.D4[7] := K;
end;

class function TGuidHelper.Empty: TGUID;
begin
  Result := GUID_NULL;
end;

class function TGuidHelper.NewGuid: TGUID;
begin
  if CreateGUID(Result) <> S_OK then
    RaiseLastOSError;
end;

function TGuidHelper.ToByteArray(DataEndian: TEndian): TBytes;
var
  PResult: PGUID;
begin
  SetLength(Result, SizeOf(TGuid));
  PResult := @Result[0];
  case DataEndian of
    TEndian.Big:
      begin
        {$IFDEF ENDIAN_BIG}
        PResult^ := Self;
        {$ELSE}
        PResult^.D1 := SwapEndian(Self.D1);
        PResult^.D2 := SwapEndian(Self.D2);
        PResult^.D3 := SwapEndian(Self.D3);
        Move(Self.D4[0], PResult^.D4[0], SizeOf(Self.D4[0]));
        {$ENDIF}
      end;
    TEndian.Little:
      begin
        {$IFDEF ENDIAN_BIG}
        PResult^.D1 := SwapEndian(Self.D1);
        PResult^.D2 := SwapEndian(Self.D2);
        PResult^.D3 := SwapEndian(Self.D3);
        Move(Self.D4[0], PResult^.D4[0], SizeOf(Self.D4[0]));
        {$ELSE}
        PResult^ := Self;
        {$ENDIF}
      end;
  end;
end;

function TGuidHelper.ToString: string;
begin
  {$IF SIZEOF(Char) = 2}
  Result := UnicodeString(GuidToString(Self));
  {$ELSE}
  Result := GuidToString(Self);
  {$IFEND}
end;

{ TShortStringHelper, TAnsiStringHelper, TRawByteStringHelper,
  TUTF8StringHelper, TWideStringHelper, TUnicodeStringHelper }

{$I system.helpers.tstringhelper.inc}

end.

