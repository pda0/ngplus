{**********************************************************************
    Copyright(c) 2016 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit System.Helpers;

{$I fpc.inc}

interface

uses
  {$IFDEF WINDOWS}
  Windows,
  {$ENDIF}
  {Types,} SysUtils;

type
// del?  TArray<T> = array of T;

  TLocaleID = {$IFDEF WINDOWS}LCID{$ELSE}DWord{$ENDIF};

  TShortStringHelper = record helper for ShortString
  private
    function GetChars(Index: Integer): AnsiChar; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function GetLength: Integer; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function GetByteLength: Integer; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function GetCPLength: Integer;
    function GetCodePoints(Index: Integer): ShortString;
  public
    const Empty: ShortString = '';
    class function Create(C: AnsiChar; Count: Integer): ShortString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF} static;
    class function Create(const Value: array of AnsiChar; StartIndex: Integer; Length: Integer): ShortString; overload; static;
    class function Create(const Value: array of AnsiChar): ShortString; overload; static;
    class function Compare(const StrA: ShortString; const StrB: ShortString): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: ShortString; const StrB: ShortString; LocaleID: TLocaleID): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: ShortString; const StrB: ShortString; IgnoreCase: Boolean): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: ShortString; const StrB: ShortString; IgnoreCase: Boolean; LocaleID: TLocaleID): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: ShortString; IndexA: Integer; const StrB: ShortString; IndexB: Integer; Length: Integer): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: ShortString; IndexA: Integer; const StrB: ShortString; IndexB: Integer; Length: Integer; LocaleID: TLocaleID): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: ShortString; IndexA: Integer; const StrB: ShortString; IndexB: Integer; Length: Integer; IgnoreCase: Boolean): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: ShortString; IndexA: Integer; const StrB: ShortString; IndexB: Integer; Length: Integer; IgnoreCase: Boolean; LocaleID: TLocaleID): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function CompareOrdinal(const StrA: ShortString; const StrB: ShortString): Integer; overload; static;
    class function CompareOrdinal(const StrA: ShortString; IndexA: Integer; const StrB: ShortString; IndexB: Integer; Length: Integer): Integer; overload; static;
    class function CompareText(const StrA: ShortString; const StrB: ShortString): Integer; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function CompareTo(const strB: ShortString): Integer;
    function Contains(const Value: ShortString): Boolean;
    class function Copy(const Str: ShortString): ShortString; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    procedure CopyTo(SourceIndex: Integer; var Destination: array of AnsiChar; DestinationIndex: Integer; Count: Integer);
    function CountChar(const C: AnsiChar): Integer;
    function DeQuotedString: ShortString; overload;
    function DeQuotedString(const QuoteChar: AnsiChar): ShortString; overload;
    class function EndsText(const ASubText, AText: ShortString): Boolean; static;
    function EndsWith(const Value: ShortString): Boolean; overload;
    function EndsWith(const Value: ShortString; IgnoreCase: Boolean): Boolean; overload;
    function Equals(const Value: ShortString): Boolean; overload;
    class function Equals(const Left: ShortString; const Right: ShortString): Boolean; overload; static;
    class function Format(const FormatStr: ShortString; const Args: array of const): ShortString; overload; static;
    function IndexOf(value: AnsiChar): Integer; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function IndexOf(const Value: ShortString): Integer; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
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
    class function Join(const Separator: ShortString; const Values: specialize IEnumerator<ShortString>): ShortString; overload; static;
    class function Join(const Separator: ShortString; const Values: specialize IEnumerable<ShortString>): ShortString; overload; static;
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
    class function LowerCase(const S: ShortString): ShortString; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function LowerCase(const S: ShortString; LocaleOptions: TLocaleOptions): ShortString; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function PadLeft(TotalWidth: Integer): ShortString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function PadLeft(TotalWidth: Integer; PaddingChar: AnsiChar): ShortString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function PadRight(TotalWidth: Integer): ShortString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function PadRight(TotalWidth: Integer; PaddingChar: AnsiChar): ShortString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Parse(const Value: Integer): ShortString; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Parse(const Value: Int64): ShortString; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Parse(const Value: Boolean): ShortString; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    {$IF NOT DEFINED(FPUNONE) AND (DEFINED(FPC_HAS_TYPE_EXTENDED) OR DEFINED(FPC_HAS_TYPE_DOUBLE))}
    class function Parse(const Value: Extended): ShortString; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    {$IFEND !~FPUNONE FPC_HAS_TYPE_EXTENDED FPC_HAS_TYPE_DOUBLE}
    function QuotedString: ShortString; overload;
    function QuotedString(const QuoteChar: AnsiChar): ShortString; overload;
    function Remove(StartIndex: Integer): ShortString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function Remove(StartIndex: Integer; Count: Integer): ShortString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function Replace(OldChar: AnsiChar; NewChar: AnsiChar): ShortString; overload;
    function Replace(OldChar: AnsiChar; NewChar: AnsiChar; ReplaceFlags: TReplaceFlags): ShortString; overload;
    function Replace(const OldValue: ShortString; const NewValue: ShortString): ShortString; overload;
    function Replace(const OldValue: ShortString; const NewValue: ShortString; ReplaceFlags: TReplaceFlags): ShortString; overload;
    function Split(const Separator: array of AnsiChar): specialize TArray<ShortString>; overload;
    function Split(const Separator: array of AnsiChar; Count: Integer): specialize TArray<ShortString>; overload;
    function Split(const Separator: array of AnsiChar; Options: TStringSplitOptions): specialize TArray<ShortString>; overload;
    function Split(const Separator: array of ShortString; Options: TStringSplitOptions): specialize TArray<ShortString>; overload;
    function Split(const Separator: array of AnsiChar; Count: Integer; Options: TStringSplitOptions): specialize TArray<ShortString>; overload;
    function Split(const Separator: array of ShortString; Count: Integer; Options: TStringSplitOptions): specialize TArray<ShortString>; overload;
    function StartsWith(const Value: ShortString): Boolean; overload;
    function StartsWith(const Value: ShortString; IgnoreCase: Boolean): Boolean; overload;
    function Substring(StartIndex: Integer): ShortString; overload;
    function Substring(StartIndex: Integer; Length: Integer): ShortString; overload;
    class function ToBoolean(const S: ShortString): Boolean; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToBoolean: Boolean; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToCharArray: specialize TArray<AnsiChar>; overload;
    function ToCharArray(StartIndex: Integer; Length: Integer): specialize TArray<AnsiChar>; overload;
    {$IFNDEF FPUNONE}
    {$IFDEF FPC_HAS_TYPE_DOUBLE}
    class function ToDouble(const S: ShortString): Double; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToDouble: Double; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    {$ENDIF !FPC_HAS_TYPE_DOUBLE}
    {$IF DEFINED(FPC_HAS_TYPE_EXTENDED) OR DEFINED(FPC_HAS_TYPE_DOUBLE)}
    class function ToExtended(const S: ShortString): Extended; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToExtended: Extended; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    {$IFEND !FPC_HAS_TYPE_EXTENDED FPC_HAS_TYPE_DOUBLE}
    {$ENDIF !~FPUNONE}
    class function ToInt64(const S: ShortString): Int64; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToInt64: Int64; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function ToInteger(const S: ShortString): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToInteger: Integer; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToLower: ShortString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToLower(LocaleID: TLocaleID): ShortString; overload;
    function ToLowerInvariant: ShortString;
    {$IF NOT DEFINED(FPUNONE) AND DEFINED(FPC_HAS_TYPE_SINGLE)}
    class function ToSingle(const S: ShortString): Single; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToSingle: Single; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    {$IFEND !~FPUNONE FPC_HAS_TYPE_SINGLE}
    function ToUpper: ShortString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
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
    class function UpperCase(const S: ShortString): ShortString; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function UpperCase(const S: ShortString; LocaleOptions: TLocaleOptions): ShortString; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    property Chars[Index: Integer]: AnsiChar read GetChars;
    property Length: Integer read GetLength;
    { Non Delphi }
    property ByteLength: Integer read GetByteLength;
    property CPLength: Integer read GetCPLength;
    property CodePoints[Index: Integer]: ShortString read GetCodePoints;
  end;

  {$IFDEF FPC_HAS_FEATURE_ANSISTRINGS}
  TAnsiStringHelper = record helper for AnsiString
  private
    function GetChars(Index: Integer): AnsiChar; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function GetLength: Integer; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function GetByteLength: Integer; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function GetCPLength: Integer;
    function GetCodePoints(Index: Integer): AnsiString;
  public
    const Empty: AnsiString = '';
    class function Create(C: AnsiChar; Count: Integer): AnsiString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF} static;
    class function Create(const Value: array of AnsiChar; StartIndex: Integer; Length: Integer): AnsiString; overload; static;
    class function Create(const Value: array of AnsiChar): AnsiString; overload; static;
    class function Compare(const StrA: AnsiString; const StrB: AnsiString): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: AnsiString; const StrB: AnsiString; LocaleID: TLocaleID): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: AnsiString; const StrB: AnsiString; IgnoreCase: Boolean): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: AnsiString; const StrB: AnsiString; IgnoreCase: Boolean; LocaleID: TLocaleID): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: AnsiString; IndexA: Integer; const StrB: AnsiString; IndexB: Integer; Length: Integer): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: AnsiString; IndexA: Integer; const StrB: AnsiString; IndexB: Integer; Length: Integer; LocaleID: TLocaleID): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: AnsiString; IndexA: Integer; const StrB: AnsiString; IndexB: Integer; Length: Integer; IgnoreCase: Boolean): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: AnsiString; IndexA: Integer; const StrB: AnsiString; IndexB: Integer; Length: Integer; IgnoreCase: Boolean; LocaleID: TLocaleID): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function CompareOrdinal(const StrA: AnsiString; const StrB: AnsiString): Integer; overload; static;
    class function CompareOrdinal(const StrA: AnsiString; IndexA: Integer; const StrB: AnsiString; IndexB: Integer; Length: Integer): Integer; overload; static;
    class function CompareText(const StrA: AnsiString; const StrB: AnsiString): Integer; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function CompareTo(const strB: AnsiString): Integer;
    function Contains(const Value: AnsiString): Boolean;
    class function Copy(const Str: AnsiString): AnsiString; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    procedure CopyTo(SourceIndex: Integer; var Destination: array of AnsiChar; DestinationIndex: Integer; Count: Integer);
    function CountChar(const C: AnsiChar): Integer;
    function DeQuotedString: AnsiString; overload;
    function DeQuotedString(const QuoteChar: AnsiChar): AnsiString; overload;
    class function EndsText(const ASubText, AText: AnsiString): Boolean; static;
    function EndsWith(const Value: AnsiString): Boolean; overload;
    function EndsWith(const Value: AnsiString; IgnoreCase: Boolean): Boolean; overload;
    function Equals(const Value: AnsiString): Boolean; overload;
    class function Equals(const Left: AnsiString; const Right: AnsiString): Boolean; overload; static;
    class function Format(const FormatStr: AnsiString; const Args: array of const): AnsiString; overload; static;
    function IndexOf(value: AnsiChar): Integer; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function IndexOf(const Value: AnsiString): Integer; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
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
    class function Join(const Separator: AnsiString; const Values: specialize IEnumerator<AnsiString>): AnsiString; overload; static;
    class function Join(const Separator: AnsiString; const Values: specialize IEnumerable<AnsiString>): AnsiString; overload; static;
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
    class function LowerCase(const S: AnsiString): AnsiString; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function LowerCase(const S: AnsiString; LocaleOptions: TLocaleOptions): AnsiString; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function PadLeft(TotalWidth: Integer): AnsiString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function PadLeft(TotalWidth: Integer; PaddingChar: AnsiChar): AnsiString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function PadRight(TotalWidth: Integer): AnsiString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function PadRight(TotalWidth: Integer; PaddingChar: AnsiChar): AnsiString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Parse(const Value: Integer): AnsiString; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Parse(const Value: Int64): AnsiString; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Parse(const Value: Boolean): AnsiString; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    {$IF NOT DEFINED(FPUNONE) AND (DEFINED(FPC_HAS_TYPE_EXTENDED) OR DEFINED(FPC_HAS_TYPE_DOUBLE))}
    class function Parse(const Value: Extended): AnsiString; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    {$IFEND !~FPUNONE FPC_HAS_TYPE_EXTENDED FPC_HAS_TYPE_DOUBLE}
    function QuotedString: AnsiString; overload;
    function QuotedString(const QuoteChar: AnsiChar): AnsiString; overload;
    function Remove(StartIndex: Integer): AnsiString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function Remove(StartIndex: Integer; Count: Integer): AnsiString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function Replace(OldChar: AnsiChar; NewChar: AnsiChar): AnsiString; overload;
    function Replace(OldChar: AnsiChar; NewChar: AnsiChar; ReplaceFlags: TReplaceFlags): AnsiString; overload;
    function Replace(const OldValue: AnsiString; const NewValue: AnsiString): AnsiString; overload;
    function Replace(const OldValue: AnsiString; const NewValue: AnsiString; ReplaceFlags: TReplaceFlags): AnsiString; overload;
    function Split(const Separator: array of AnsiChar): specialize TArray<AnsiString>; overload;
    function Split(const Separator: array of AnsiChar; Count: Integer): specialize TArray<AnsiString>; overload;
    function Split(const Separator: array of AnsiChar; Options: TStringSplitOptions): specialize TArray<AnsiString>; overload;
    function Split(const Separator: array of AnsiString; Options: TStringSplitOptions): specialize TArray<AnsiString>; overload;
    function Split(const Separator: array of AnsiChar; Count: Integer; Options: TStringSplitOptions): specialize TArray<AnsiString>; overload;
    function Split(const Separator: array of AnsiString; Count: Integer; Options: TStringSplitOptions): specialize TArray<AnsiString>; overload;
    function StartsWith(const Value: AnsiString): Boolean; overload;
    function StartsWith(const Value: AnsiString; IgnoreCase: Boolean): Boolean; overload;
    function Substring(StartIndex: Integer): AnsiString; overload;
    function Substring(StartIndex: Integer; Length: Integer): AnsiString; overload;
    class function ToBoolean(const S: AnsiString): Boolean; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToBoolean: Boolean; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToCharArray: specialize TArray<AnsiChar>; overload;
    function ToCharArray(StartIndex: Integer; Length: Integer): specialize TArray<AnsiChar>; overload;
    {$IFNDEF FPUNONE}
    {$IFDEF FPC_HAS_TYPE_DOUBLE}
    class function ToDouble(const S: AnsiString): Double; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToDouble: Double; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    {$ENDIF !FPC_HAS_TYPE_DOUBLE}
    {$IF DEFINED(FPC_HAS_TYPE_EXTENDED) OR DEFINED(FPC_HAS_TYPE_DOUBLE)}
    class function ToExtended(const S: AnsiString): Extended; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToExtended: Extended; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    {$IFEND !FPC_HAS_TYPE_EXTENDED FPC_HAS_TYPE_DOUBLE}
    {$ENDIF !~FPUNONE}
    class function ToInt64(const S: AnsiString): Int64; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToInt64: Int64; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function ToInteger(const S: AnsiString): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToInteger: Integer; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToLower: AnsiString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToLower(LocaleID: TLocaleID): AnsiString; overload;
    function ToLowerInvariant: AnsiString;
    {$IF NOT DEFINED(FPUNONE) AND DEFINED(FPC_HAS_TYPE_SINGLE)}
    class function ToSingle(const S: AnsiString): Single; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToSingle: Single; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    {$IFEND !~FPUNONE FPC_HAS_TYPE_SINGLE}
    function ToUpper: AnsiString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
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
    class function UpperCase(const S: AnsiString): AnsiString; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function UpperCase(const S: AnsiString; LocaleOptions: TLocaleOptions): AnsiString; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    property Chars[Index: Integer]: AnsiChar read GetChars;
    property Length: Integer read GetLength;
    { Non Delphi }
    property ByteLength: Integer read GetByteLength;
    property CPLength: Integer read GetCPLength;
    property CodePoints[Index: Integer]: AnsiString read GetCodePoints;
  end;

  TRawByteStringHelper = record helper for RawByteString
  private
    function GetChars(Index: Integer): AnsiChar; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function GetLength: Integer; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function GetByteLength: Integer; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function GetCPLength: Integer;
    function GetCodePoints(Index: Integer): RawByteString;
  public
    const Empty: RawByteString = '';
    class function Create(C: AnsiChar; Count: Integer): RawByteString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF} static;
    class function Create(const Value: array of AnsiChar; StartIndex: Integer; Length: Integer): RawByteString; overload; static;
    class function Create(const Value: array of AnsiChar): RawByteString; overload; static;
    class function Compare(const StrA: RawByteString; const StrB: RawByteString): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: RawByteString; const StrB: RawByteString; LocaleID: TLocaleID): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: RawByteString; const StrB: RawByteString; IgnoreCase: Boolean): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: RawByteString; const StrB: RawByteString; IgnoreCase: Boolean; LocaleID: TLocaleID): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: RawByteString; IndexA: Integer; const StrB: RawByteString; IndexB: Integer; Length: Integer): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: RawByteString; IndexA: Integer; const StrB: RawByteString; IndexB: Integer; Length: Integer; LocaleID: TLocaleID): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: RawByteString; IndexA: Integer; const StrB: RawByteString; IndexB: Integer; Length: Integer; IgnoreCase: Boolean): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: RawByteString; IndexA: Integer; const StrB: RawByteString; IndexB: Integer; Length: Integer; IgnoreCase: Boolean; LocaleID: TLocaleID): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function CompareOrdinal(const StrA: RawByteString; const StrB: RawByteString): Integer; overload; static;
    class function CompareOrdinal(const StrA: RawByteString; IndexA: Integer; const StrB: RawByteString; IndexB: Integer; Length: Integer): Integer; overload; static;
    class function CompareText(const StrA: RawByteString; const StrB: RawByteString): Integer; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function CompareTo(const strB: RawByteString): Integer;
    function Contains(const Value: RawByteString): Boolean;
    class function Copy(const Str: RawByteString): RawByteString; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    procedure CopyTo(SourceIndex: Integer; var Destination: array of AnsiChar; DestinationIndex: Integer; Count: Integer);
    function CountChar(const C: AnsiChar): Integer;
    function DeQuotedString: RawByteString; overload;
    function DeQuotedString(const QuoteChar: AnsiChar): RawByteString; overload;
    class function EndsText(const ASubText, AText: RawByteString): Boolean; static;
    function EndsWith(const Value: RawByteString): Boolean; overload;
    function EndsWith(const Value: RawByteString; IgnoreCase: Boolean): Boolean; overload;
    function Equals(const Value: RawByteString): Boolean; overload;
    class function Equals(const Left: RawByteString; const Right: RawByteString): Boolean; overload; static;
    class function Format(const FormatStr: RawByteString; const Args: array of const): RawByteString; overload; static;
    function IndexOf(value: AnsiChar): Integer; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function IndexOf(const Value: RawByteString): Integer; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
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
    class function Join(const Separator: RawByteString; const Values: specialize IEnumerator<RawByteString>): RawByteString; overload; static;
    class function Join(const Separator: RawByteString; const Values: specialize IEnumerable<RawByteString>): RawByteString; overload; static;
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
    class function LowerCase(const S: RawByteString): RawByteString; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function LowerCase(const S: RawByteString; LocaleOptions: TLocaleOptions): RawByteString; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function PadLeft(TotalWidth: Integer): RawByteString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function PadLeft(TotalWidth: Integer; PaddingChar: AnsiChar): RawByteString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function PadRight(TotalWidth: Integer): RawByteString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function PadRight(TotalWidth: Integer; PaddingChar: AnsiChar): RawByteString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Parse(const Value: Integer): RawByteString; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Parse(const Value: Int64): RawByteString; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Parse(const Value: Boolean): RawByteString; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    {$IF NOT DEFINED(FPUNONE) AND (DEFINED(FPC_HAS_TYPE_EXTENDED) OR DEFINED(FPC_HAS_TYPE_DOUBLE))}
    class function Parse(const Value: Extended): RawByteString; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    {$IFEND !~FPUNONE FPC_HAS_TYPE_EXTENDED FPC_HAS_TYPE_DOUBLE}
    function QuotedString: RawByteString; overload;
    function QuotedString(const QuoteChar: AnsiChar): RawByteString; overload;
    function Remove(StartIndex: Integer): RawByteString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function Remove(StartIndex: Integer; Count: Integer): RawByteString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function Replace(OldChar: AnsiChar; NewChar: AnsiChar): RawByteString; overload;
    function Replace(OldChar: AnsiChar; NewChar: AnsiChar; ReplaceFlags: TReplaceFlags): RawByteString; overload;
    function Replace(const OldValue: RawByteString; const NewValue: RawByteString): RawByteString; overload;
    function Replace(const OldValue: RawByteString; const NewValue: RawByteString; ReplaceFlags: TReplaceFlags): RawByteString; overload;
    function Split(const Separator: array of AnsiChar): specialize TArray<RawByteString>; overload;
    function Split(const Separator: array of AnsiChar; Count: Integer): specialize TArray<RawByteString>; overload;
    function Split(const Separator: array of AnsiChar; Options: TStringSplitOptions): specialize TArray<RawByteString>; overload;
    function Split(const Separator: array of RawByteString; Options: TStringSplitOptions): specialize TArray<RawByteString>; overload;
    function Split(const Separator: array of AnsiChar; Count: Integer; Options: TStringSplitOptions): specialize TArray<RawByteString>; overload;
    function Split(const Separator: array of RawByteString; Count: Integer; Options: TStringSplitOptions): specialize TArray<RawByteString>; overload;
    function StartsWith(const Value: RawByteString): Boolean; overload;
    function StartsWith(const Value: RawByteString; IgnoreCase: Boolean): Boolean; overload;
    function Substring(StartIndex: Integer): RawByteString; overload;
    function Substring(StartIndex: Integer; Length: Integer): RawByteString; overload;
    class function ToBoolean(const S: RawByteString): Boolean; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToBoolean: Boolean; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToCharArray: specialize TArray<AnsiChar>; overload;
    function ToCharArray(StartIndex: Integer; Length: Integer): specialize TArray<AnsiChar>; overload;
    {$IFNDEF FPUNONE}
    {$IFDEF FPC_HAS_TYPE_DOUBLE}
    class function ToDouble(const S: RawByteString): Double; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToDouble: Double; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    {$ENDIF !FPC_HAS_TYPE_DOUBLE}
    {$IF DEFINED(FPC_HAS_TYPE_EXTENDED) OR DEFINED(FPC_HAS_TYPE_DOUBLE)}
    class function ToExtended(const S: RawByteString): Extended; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToExtended: Extended; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    {$IFEND !FPC_HAS_TYPE_EXTENDED FPC_HAS_TYPE_DOUBLE}
    {$ENDIF !~FPUNONE}
    class function ToInt64(const S: RawByteString): Int64; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToInt64: Int64; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function ToInteger(const S: RawByteString): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToInteger: Integer; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToLower: RawByteString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToLower(LocaleID: TLocaleID): RawByteString; overload;
    function ToLowerInvariant: RawByteString;
    {$IF NOT DEFINED(FPUNONE) AND DEFINED(FPC_HAS_TYPE_SINGLE)}
    class function ToSingle(const S: RawByteString): Single; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToSingle: Single; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    {$IFEND !~FPUNONE FPC_HAS_TYPE_SINGLE}
    function ToUpper: RawByteString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
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
    class function UpperCase(const S: RawByteString): RawByteString; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function UpperCase(const S: RawByteString; LocaleOptions: TLocaleOptions): RawByteString; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    property Chars[Index: Integer]: AnsiChar read GetChars;
    property Length: Integer read GetLength;
    { Non Delphi }
    property ByteLength: Integer read GetByteLength;
    property CPLength: Integer read GetCPLength;
    property CodePoints[Index: Integer]: RawByteString read GetCodePoints;
  end;

  TUTF8StringHelper = record helper for UTF8String
  private
    function GetChars(Index: Integer): AnsiChar; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function GetLength: Integer; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function GetByteLength: Integer; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function GetCPLength: Integer;
    function GetCodePoints(Index: Integer): UTF8String;
  public
    const Empty: UTF8String = '';
    class function Create(C: AnsiChar; Count: Integer): UTF8String; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF} static;
    class function Create(const Value: array of AnsiChar; StartIndex: Integer; Length: Integer): UTF8String; overload; static;
    class function Create(const Value: array of AnsiChar): UTF8String; overload; static;
    class function Compare(const StrA: UTF8String; const StrB: UTF8String): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: UTF8String; const StrB: UTF8String; LocaleID: TLocaleID): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: UTF8String; const StrB: UTF8String; IgnoreCase: Boolean): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: UTF8String; const StrB: UTF8String; IgnoreCase: Boolean; LocaleID: TLocaleID): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: UTF8String; IndexA: Integer; const StrB: UTF8String; IndexB: Integer; Length: Integer): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: UTF8String; IndexA: Integer; const StrB: UTF8String; IndexB: Integer; Length: Integer; LocaleID: TLocaleID): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: UTF8String; IndexA: Integer; const StrB: UTF8String; IndexB: Integer; Length: Integer; IgnoreCase: Boolean): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: UTF8String; IndexA: Integer; const StrB: UTF8String; IndexB: Integer; Length: Integer; IgnoreCase: Boolean; LocaleID: TLocaleID): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function CompareOrdinal(const StrA: UTF8String; const StrB: UTF8String): Integer; overload; static;
    class function CompareOrdinal(const StrA: UTF8String; IndexA: Integer; const StrB: UTF8String; IndexB: Integer; Length: Integer): Integer; overload; static;
    class function CompareText(const StrA: UTF8String; const StrB: UTF8String): Integer; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function CompareTo(const strB: UTF8String): Integer;
    function Contains(const Value: UTF8String): Boolean;
    class function Copy(const Str: UTF8String): UTF8String; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    procedure CopyTo(SourceIndex: Integer; var Destination: array of AnsiChar; DestinationIndex: Integer; Count: Integer);
    function CountChar(const C: AnsiChar): Integer;
    function DeQuotedString: UTF8String; overload;
    function DeQuotedString(const QuoteChar: AnsiChar): UTF8String; overload;
    class function EndsText(const ASubText, AText: UTF8String): Boolean; static;
    function EndsWith(const Value: UTF8String): Boolean; overload;
    function EndsWith(const Value: UTF8String; IgnoreCase: Boolean): Boolean; overload;
    function Equals(const Value: UTF8String): Boolean; overload;
    class function Equals(const Left: UTF8String; const Right: UTF8String): Boolean; overload; static;
    class function Format(const FormatStr: UTF8String; const Args: array of const): UTF8String; overload; static;
    function IndexOf(value: AnsiChar): Integer; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function IndexOf(const Value: UTF8String): Integer; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
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
    class function Join(const Separator: UTF8String; const Values: specialize IEnumerator<UTF8String>): UTF8String; overload; static;
    class function Join(const Separator: UTF8String; const Values: specialize IEnumerable<UTF8String>): UTF8String; overload; static;
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
    class function LowerCase(const S: UTF8String): UTF8String; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function LowerCase(const S: UTF8String; LocaleOptions: TLocaleOptions): UTF8String; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function PadLeft(TotalWidth: Integer): UTF8String; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function PadLeft(TotalWidth: Integer; PaddingChar: AnsiChar): UTF8String; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function PadRight(TotalWidth: Integer): UTF8String; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function PadRight(TotalWidth: Integer; PaddingChar: AnsiChar): UTF8String; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Parse(const Value: Integer): UTF8String; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Parse(const Value: Int64): UTF8String; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Parse(const Value: Boolean): UTF8String; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    {$IF NOT DEFINED(FPUNONE) AND (DEFINED(FPC_HAS_TYPE_EXTENDED) OR DEFINED(FPC_HAS_TYPE_DOUBLE))}
    class function Parse(const Value: Extended): UTF8String; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    {$IFEND !~FPUNONE FPC_HAS_TYPE_EXTENDED FPC_HAS_TYPE_DOUBLE}
    function QuotedString: UTF8String; overload;
    function QuotedString(const QuoteChar: AnsiChar): UTF8String; overload;
    function Remove(StartIndex: Integer): UTF8String; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function Remove(StartIndex: Integer; Count: Integer): UTF8String; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function Replace(OldChar: AnsiChar; NewChar: AnsiChar): UTF8String; overload;
    function Replace(OldChar: AnsiChar; NewChar: AnsiChar; ReplaceFlags: TReplaceFlags): UTF8String; overload;
    function Replace(const OldValue: UTF8String; const NewValue: UTF8String): UTF8String; overload;
    function Replace(const OldValue: UTF8String; const NewValue: UTF8String; ReplaceFlags: TReplaceFlags): UTF8String; overload;
    function Split(const Separator: array of AnsiChar): specialize TArray<UTF8String>; overload;
    function Split(const Separator: array of AnsiChar; Count: Integer): specialize TArray<UTF8String>; overload;
    function Split(const Separator: array of AnsiChar; Options: TStringSplitOptions): specialize TArray<UTF8String>; overload;
    function Split(const Separator: array of UTF8String; Options: TStringSplitOptions): specialize TArray<UTF8String>; overload;
    function Split(const Separator: array of AnsiChar; Count: Integer; Options: TStringSplitOptions): specialize TArray<UTF8String>; overload;
    function Split(const Separator: array of UTF8String; Count: Integer; Options: TStringSplitOptions): specialize TArray<UTF8String>; overload;
    function StartsWith(const Value: UTF8String): Boolean; overload;
    function StartsWith(const Value: UTF8String; IgnoreCase: Boolean): Boolean; overload;
    function Substring(StartIndex: Integer): UTF8String; overload;
    function Substring(StartIndex: Integer; Length: Integer): UTF8String; overload;
    class function ToBoolean(const S: UTF8String): Boolean; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToBoolean: Boolean; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToCharArray: specialize TArray<AnsiChar>; overload;
    function ToCharArray(StartIndex: Integer; Length: Integer): specialize TArray<AnsiChar>; overload;
    {$IFNDEF FPUNONE}
    {$IFDEF FPC_HAS_TYPE_DOUBLE}
    class function ToDouble(const S: UTF8String): Double; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToDouble: Double; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    {$ENDIF !FPC_HAS_TYPE_DOUBLE}
    {$IF DEFINED(FPC_HAS_TYPE_EXTENDED) OR DEFINED(FPC_HAS_TYPE_DOUBLE)}
    class function ToExtended(const S: UTF8String): Extended; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToExtended: Extended; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    {$IFEND !FPC_HAS_TYPE_EXTENDED FPC_HAS_TYPE_DOUBLE}
    {$ENDIF !~FPUNONE}
    class function ToInt64(const S: UTF8String): Int64; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToInt64: Int64; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function ToInteger(const S: UTF8String): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToInteger: Integer; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToLower: UTF8String; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToLower(LocaleID: TLocaleID): UTF8String; overload;
    function ToLowerInvariant: UTF8String;
    {$IF NOT DEFINED(FPUNONE) AND DEFINED(FPC_HAS_TYPE_SINGLE)}
    class function ToSingle(const S: UTF8String): Single; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToSingle: Single; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    {$IFEND !~FPUNONE FPC_HAS_TYPE_SINGLE}
    function ToUpper: UTF8String; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
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
    class function UpperCase(const S: UTF8String): UTF8String; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function UpperCase(const S: UTF8String; LocaleOptions: TLocaleOptions): UTF8String; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    property Chars[Index: Integer]: AnsiChar read GetChars;
    property Length: Integer read GetLength;
    { Non Delphi }
    property ByteLength: Integer read GetByteLength;
    property CPLength: Integer read GetCPLength;
    property CodePoints[Index: Integer]: UTF8String read GetCodePoints;
  end;
  {$ENDIF !FPC_HAS_FEATURE_ANSISTRINGS}

  {$IFDEF FPC_HAS_FEATURE_WIDESTRINGS}
  TWideStringHelper = record helper for WideString
  private
    class function HaveChar(AChar: WideChar; const AList: array of WideChar): Boolean; static;
    function GetChars(Index: Integer): WideChar; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function GetLength: Integer; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function GetByteLength: Integer; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function GetCPLength: Integer; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function GetCodePoints(Index: Integer): WideString; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
  public
    const Empty: WideString = '';
    class function Create(C: WideChar; Count: Integer): WideString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF} static;
    class function Create(const Value: array of WideChar; StartIndex: Integer; Length: Integer): WideString; overload; static;
    class function Create(const Value: array of WideChar): WideString; overload; static;
    class function Compare(const StrA: WideString; const StrB: WideString): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: WideString; const StrB: WideString; LocaleID: TLocaleID): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: WideString; const StrB: WideString; IgnoreCase: Boolean): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: WideString; const StrB: WideString; IgnoreCase: Boolean; LocaleID: TLocaleID): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: WideString; IndexA: Integer; const StrB: WideString; IndexB: Integer; Length: Integer): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: WideString; IndexA: Integer; const StrB: WideString; IndexB: Integer; Length: Integer; LocaleID: TLocaleID): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: WideString; IndexA: Integer; const StrB: WideString; IndexB: Integer; Length: Integer; IgnoreCase: Boolean): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: WideString; IndexA: Integer; const StrB: WideString; IndexB: Integer; Length: Integer; IgnoreCase: Boolean; LocaleID: TLocaleID): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function CompareOrdinal(const StrA: WideString; const StrB: WideString): Integer; overload; static;
    class function CompareOrdinal(const StrA: WideString; IndexA: Integer; const StrB: WideString; IndexB: Integer; Length: Integer): Integer; overload; static;
    class function CompareText(const StrA: WideString; const StrB: WideString): Integer; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function CompareTo(const strB: WideString): Integer;
    function Contains(const Value: WideString): Boolean;
    class function Copy(const Str: WideString): WideString; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    procedure CopyTo(SourceIndex: Integer; var Destination: array of WideChar; DestinationIndex: Integer; Count: Integer);
    function CountChar(const C: WideChar): Integer;
    function DeQuotedString: WideString; overload;
    function DeQuotedString(const QuoteChar: WideChar): WideString; overload;
    class function EndsText(const ASubText, AText: WideString): Boolean; static;
    function EndsWith(const Value: WideString): Boolean; overload;
    function EndsWith(const Value: WideString; IgnoreCase: Boolean): Boolean; overload;
    function Equals(const Value: WideString): Boolean; overload;
    class function Equals(const Left: WideString; const Right: WideString): Boolean; overload; static;
    class function Format(const FormatStr: WideString; const Args: array of const): WideString; overload; static;
    function IndexOf(value: WideChar): Integer; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function IndexOf(const Value: WideString): Integer; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
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
    class function Join(const Separator: WideString; const Values: specialize IEnumerator<WideString>): WideString; overload; static;
    class function Join(const Separator: WideString; const Values: specialize IEnumerable<WideString>): WideString; overload; static;
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
    class function LowerCase(const S: WideString): WideString; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function LowerCase(const S: WideString; LocaleOptions: TLocaleOptions): WideString; overload; static; {$IFNDEF _TEST}inline;{$ENDIF}
    function PadLeft(TotalWidth: Integer): WideString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function PadLeft(TotalWidth: Integer; PaddingChar: WideChar): WideString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function PadRight(TotalWidth: Integer): WideString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function PadRight(TotalWidth: Integer; PaddingChar: WideChar): WideString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Parse(const Value: Integer): WideString; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Parse(const Value: Int64): WideString; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Parse(const Value: Boolean): WideString; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    {$IF NOT DEFINED(FPUNONE) AND (DEFINED(FPC_HAS_TYPE_EXTENDED) OR DEFINED(FPC_HAS_TYPE_DOUBLE))}
    class function Parse(const Value: Extended): WideString; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    {$IFEND !~FPUNONE FPC_HAS_TYPE_EXTENDED FPC_HAS_TYPE_DOUBLE}
    function QuotedString: WideString; overload;
    function QuotedString(const QuoteChar: WideChar): WideString; overload;
    function Remove(StartIndex: Integer): WideString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function Remove(StartIndex: Integer; Count: Integer): WideString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function Replace(OldChar: WideChar; NewChar: WideChar): WideString; overload;
    function Replace(OldChar: WideChar; NewChar: WideChar; ReplaceFlags: TReplaceFlags): WideString; overload;
    function Replace(const OldValue: WideString; const NewValue: WideString): WideString; overload;
    function Replace(const OldValue: WideString; const NewValue: WideString; ReplaceFlags: TReplaceFlags): WideString; overload;
    function Split(const Separator: array of WideChar): specialize TArray<WideString>; overload;
    function Split(const Separator: array of WideChar; Count: Integer): specialize TArray<WideString>; overload;
    function Split(const Separator: array of WideChar; Options: TStringSplitOptions): specialize TArray<WideString>; overload;
    function Split(const Separator: array of WideString; Options: TStringSplitOptions): specialize TArray<WideString>; overload;
    function Split(const Separator: array of WideChar; Count: Integer; Options: TStringSplitOptions): specialize TArray<WideString>; overload;
    function Split(const Separator: array of WideString; Count: Integer; Options: TStringSplitOptions): specialize TArray<WideString>; overload;
    function StartsWith(const Value: WideString): Boolean; overload;
    function StartsWith(const Value: WideString; IgnoreCase: Boolean): Boolean; overload;
    function Substring(StartIndex: Integer): WideString; overload;
    function Substring(StartIndex: Integer; Length: Integer): WideString; overload;
    class function ToBoolean(const S: WideString): Boolean; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToBoolean: Boolean; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToCharArray: specialize TArray<WideChar>; overload;
    function ToCharArray(StartIndex: Integer; Length: Integer): specialize TArray<WideChar>; overload;
    {$IFNDEF FPUNONE}
    {$IFDEF FPC_HAS_TYPE_DOUBLE}
    class function ToDouble(const S: WideString): Double; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToDouble: Double; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    {$ENDIF !FPC_HAS_TYPE_DOUBLE}
    {$IF DEFINED(FPC_HAS_TYPE_EXTENDED) OR DEFINED(FPC_HAS_TYPE_DOUBLE)}
    class function ToExtended(const S: WideString): Extended; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToExtended: Extended; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    {$IFEND !FPC_HAS_TYPE_EXTENDED FPC_HAS_TYPE_DOUBLE}
    {$ENDIF !~FPUNONE}
    class function ToInt64(const S: WideString): Int64; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToInt64: Int64; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function ToInteger(const S: WideString): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToInteger: Integer; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToLower: WideString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToLower(LocaleID: TLocaleID): WideString; overload;
    function ToLowerInvariant: WideString;
    {$IF NOT DEFINED(FPUNONE) AND DEFINED(FPC_HAS_TYPE_SINGLE)}
    class function ToSingle(const S: WideString): Single; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToSingle: Single; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    {$IFEND !~FPUNONE FPC_HAS_TYPE_SINGLE}
    function ToUpper: WideString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
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
    class function UpperCase(const S: WideString): WideString; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function UpperCase(const S: WideString; LocaleOptions: TLocaleOptions): WideString; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    property Chars[Index: Integer]: WideChar read GetChars;
    property Length: Integer read GetLength;
    { Non Delphi }
    property ByteLength: Integer read GetByteLength;
    property CPLength: Integer read GetCPLength;
    property CodePoints[Index: Integer]: WideString read GetCodePoints;
  end;
  {$ENDIF !FPC_HAS_FEATURE_WIDESTRINGS}

  {$IFDEF FPC_HAS_FEATURE_UNICODESTRINGS}
  TUnicodeStringHelper = record helper for UnicodeString
  private
    class function HaveChar(AChar: UnicodeChar; const AList: array of UnicodeChar): Boolean; static;
    function GetChars(Index: Integer): UnicodeChar; {$IFDEF HAS_INLINE}inline;{$ENDIF}
    function GetLength: Integer; {$IFDEF HAS_INLINE}inline;{$ENDIF}
    function GetByteLength: Integer; {$IFDEF HAS_INLINE}inline;{$ENDIF}
    function GetCPLength: Integer; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function GetCodePoints(Index: Integer): UnicodeString; {$IFDEF HAS_INLINE}inline;{$ENDIF}
  public
    const Empty: UnicodeString = '';
    class function Create(C: UnicodeChar; Count: Integer): UnicodeString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF} static;
    class function Create(const Value: array of UnicodeChar; StartIndex: Integer; Length: Integer): UnicodeString; overload; static;
    class function Create(const Value: array of UnicodeChar): UnicodeString; overload; static;
    class function Compare(const StrA: UnicodeString; const StrB: UnicodeString): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: UnicodeString; const StrB: UnicodeString; LocaleID: TLocaleID): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: UnicodeString; const StrB: UnicodeString; IgnoreCase: Boolean): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: UnicodeString; const StrB: UnicodeString; IgnoreCase: Boolean; LocaleID: TLocaleID): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: UnicodeString; IndexA: Integer; const StrB: UnicodeString; IndexB: Integer; Length: Integer): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: UnicodeString; IndexA: Integer; const StrB: UnicodeString; IndexB: Integer; Length: Integer; LocaleID: TLocaleID): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: UnicodeString; IndexA: Integer; const StrB: UnicodeString; IndexB: Integer; Length: Integer; IgnoreCase: Boolean): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Compare(const StrA: UnicodeString; IndexA: Integer; const StrB: UnicodeString; IndexB: Integer; Length: Integer; IgnoreCase: Boolean; LocaleID: TLocaleID): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function CompareOrdinal(const StrA: UnicodeString; const StrB: UnicodeString): Integer; overload; static;
    class function CompareOrdinal(const StrA: UnicodeString; IndexA: Integer; const StrB: UnicodeString; IndexB: Integer; Length: Integer): Integer; overload; static;
    class function CompareText(const StrA: UnicodeString; const StrB: UnicodeString): Integer; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function CompareTo(const strB: UnicodeString): Integer;
    function Contains(const Value: UnicodeString): Boolean;
    class function Copy(const Str: UnicodeString): UnicodeString; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    procedure CopyTo(SourceIndex: Integer; var Destination: array of UnicodeChar; DestinationIndex: Integer; Count: Integer);
    function CountChar(const C: UnicodeChar): Integer;
    function DeQuotedString: UnicodeString; overload;
    function DeQuotedString(const QuoteChar: UnicodeChar): UnicodeString; overload;
    class function EndsText(const ASubText, AText: UnicodeString): Boolean; static;
    function EndsWith(const Value: UnicodeString): Boolean; overload;
    function EndsWith(const Value: UnicodeString; IgnoreCase: Boolean): Boolean; overload;
    function Equals(const Value: UnicodeString): Boolean; overload;
    class function Equals(const Left: UnicodeString; const Right: UnicodeString): Boolean; overload; static;
    class function Format(const FormatStr: UnicodeString; const Args: array of const): UnicodeString; overload; static;
    function IndexOf(value: UnicodeChar): Integer; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function IndexOf(const Value: UnicodeString): Integer; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
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
    class function Join(const Separator: UnicodeString; const Values: specialize IEnumerator<UnicodeString>): UnicodeString; overload; static;
    class function Join(const Separator: UnicodeString; const Values: specialize IEnumerable<UnicodeString>): UnicodeString; overload; static;
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
    class function LowerCase(const S: UnicodeString): UnicodeString; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function LowerCase(const S: UnicodeString; LocaleOptions: TLocaleOptions): UnicodeString; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function PadLeft(TotalWidth: Integer): UnicodeString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function PadLeft(TotalWidth: Integer; PaddingChar: UnicodeChar): UnicodeString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function PadRight(TotalWidth: Integer): UnicodeString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function PadRight(TotalWidth: Integer; PaddingChar: UnicodeChar): UnicodeString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Parse(const Value: Integer): UnicodeString; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Parse(const Value: Int64): UnicodeString; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function Parse(const Value: Boolean): UnicodeString; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    {$IF NOT DEFINED(FPUNONE) AND (DEFINED(FPC_HAS_TYPE_EXTENDED) OR DEFINED(FPC_HAS_TYPE_DOUBLE))}
    class function Parse(const Value: Extended): UnicodeString; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    {$IFEND !~FPUNONE FPC_HAS_TYPE_EXTENDED FPC_HAS_TYPE_DOUBLE}
    function QuotedString: UnicodeString; overload;
    function QuotedString(const QuoteChar: UnicodeChar): UnicodeString; overload;
    function Remove(StartIndex: Integer): UnicodeString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function Remove(StartIndex: Integer; Count: Integer): UnicodeString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function Replace(OldChar: UnicodeChar; NewChar: UnicodeChar): UnicodeString; overload;
    function Replace(OldChar: UnicodeChar; NewChar: UnicodeChar; ReplaceFlags: TReplaceFlags): UnicodeString; overload;
    function Replace(const OldValue: UnicodeString; const NewValue: UnicodeString): UnicodeString; overload;
    function Replace(const OldValue: UnicodeString; const NewValue: UnicodeString; ReplaceFlags: TReplaceFlags): UnicodeString; overload;
    function Split(const Separator: array of UnicodeChar): specialize TArray<UnicodeString>; overload;
    function Split(const Separator: array of UnicodeChar; Count: Integer): specialize TArray<UnicodeString>; overload;
    function Split(const Separator: array of UnicodeChar; Options: TStringSplitOptions): specialize TArray<UnicodeString>; overload;
    function Split(const Separator: array of UnicodeString; Options: TStringSplitOptions): specialize TArray<UnicodeString>; overload;
    function Split(const Separator: array of UnicodeChar; Count: Integer; Options: TStringSplitOptions): specialize TArray<UnicodeString>; overload;
    function Split(const Separator: array of UnicodeString; Count: Integer; Options: TStringSplitOptions): specialize TArray<UnicodeString>; overload;
    function StartsWith(const Value: UnicodeString): Boolean; overload;
    function StartsWith(const Value: UnicodeString; IgnoreCase: Boolean): Boolean; overload;
    function Substring(StartIndex: Integer): UnicodeString; overload;
    function Substring(StartIndex: Integer; Length: Integer): UnicodeString; overload;
    class function ToBoolean(const S: UnicodeString): Boolean; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToBoolean: Boolean; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToCharArray: specialize TArray<UnicodeChar>; overload;
    function ToCharArray(StartIndex: Integer; Length: Integer): specialize TArray<UnicodeChar>; overload;
    {$IFNDEF FPUNONE}
    {$IFDEF FPC_HAS_TYPE_DOUBLE}
    class function ToDouble(const S: UnicodeString): Double; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToDouble: Double; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    {$ENDIF !FPC_HAS_TYPE_DOUBLE}
    {$IF DEFINED(FPC_HAS_TYPE_EXTENDED) OR DEFINED(FPC_HAS_TYPE_DOUBLE)}
    class function ToExtended(const S: UnicodeString): Extended; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToExtended: Extended; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    {$IFEND !FPC_HAS_TYPE_EXTENDED FPC_HAS_TYPE_DOUBLE}
    {$ENDIF !~FPUNONE}
    class function ToInt64(const S: UnicodeString): Int64; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToInt64: Int64; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function ToInteger(const S: UnicodeString): Integer; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToInteger: Integer; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToLower: UnicodeString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToLower(LocaleID: TLocaleID): UnicodeString; overload;
    function ToLowerInvariant: UnicodeString;
    {$IF NOT DEFINED(FPUNONE) AND DEFINED(FPC_HAS_TYPE_SINGLE)}
    class function ToSingle(const S: UnicodeString): Single; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    function ToSingle: Single; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    {$IFEND !~FPUNONE FPC_HAS_TYPE_SINGLE}
    function ToUpper: UnicodeString; overload; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
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
    class function UpperCase(const S: UnicodeString): UnicodeString; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    class function UpperCase(const S: UnicodeString; LocaleOptions: TLocaleOptions): UnicodeString; overload; static; {$IFDEF SYSUTILSINLINE}inline;{$ENDIF}
    property Chars[Index: Integer]: UnicodeChar read GetChars;
    property Length: Integer read GetLength;
    { Non Delphi }
    property ByteLength: Integer read GetByteLength;
    property CPLength: Integer read GetCPLength;
    property CodePoints[Index: Integer]: UnicodeString read GetCodePoints;
  end;
  {$ENDIF !FPC_HAS_FEATURE_UNICODESTRINGS}

implementation

uses
  {$IFDEF CPU64}
  sysconst,
  {$ENDIF}
  {$IFDEF _WITH_LAZARUS}
  LazUTF8,
  {$ENDIF}
  Math, System.Helpers.Strings;

{$IFDEF _WITH_LAZARUS}

function UTF8CharacterLength(p: PAnsiChar): Integer;
begin
  if p <> nil then
  begin
    if Ord(p^) < $c0 then
    begin
      { regular single byte character (#0 is a character, this is pascal ;) }
      Result := 1;
    end
    else begin
      { multi byte }
      if (Ord(p^) and $e0) = $c0 then
      begin
        { could be 2 byte character }
        if (Ord(p[1]) and $c0) = $80 then
          Result := 2
        else
          Result := 1;
      end
      else if (Ord(p^) and $f0) = $e0 then
      begin
        { could be 3 byte character }
        if ((Ord(p[1]) and $c0) = $80)
        and ((ord(p[2]) and $c0) = $80) then
          Result := 3
        else
          Result := 1;
      end
      else if ((ord(p^) and $f8) = $f0) then
      begin
        { could be 4 byte character }
        if ((Ord(p[1]) and $c0) = $80) and ((Ord(p[2]) and $c0) = $80) and
          ((Ord(p[3]) and $c0) = $80) then
          Result := 4
        else
          Result := 1;
      end
      else
        Result := 1;
    end;
  end
  else
    Result := 0;
end;

function UTF8Length(p: PAnsiChar; ByteCount: Integer): Integer;
var
  CharLen: LongInt;
begin
  Result := 0;
  while ByteCount > 0 do
  begin
    Inc(Result);
    CharLen := UTF8CharacterLength(p);
    Inc(p, CharLen);
    Dec(ByteCount, CharLen);
  end;
end;

{$ENDIF !_WITH_LAZARUS}

{ TShortStringHelper, TAnsiStringHelper, TRawByteStringHelper,
  TUTF8StringHelper, TWideStringHelper, TUnicodeStringHelper }

{$I system.helpers.tstringhelper.inc}

end.

