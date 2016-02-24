# NGPlus
Free Pascal implementation of various modern Delphi classes and records.
New Delphi is Unicode-only and even more, nextgen mode (for mobile devices) is not support old string types like AnsiString at all. But Free Pascal still have it, so many methods of this library will be overloaded to support old string types.
This library is still an alpha. Methods, units, way of compilation can be changed unpredictable. :) Feel free to test it but you shall not use it until first public beta.

## System.Helpers
New Delphi it's not only new modules but also new methods in old classes and new classes in old units. Since there no way to transparently include class into foreign namespace, all of them will be combined in System.Helpers unit. Add this unit to uses list and enjoy new classes and new shiny methods of old classes. :)

### TGuidHelper
This helper extends System.TGUID class. Unfortunately type inference does not allows to append old TGuid method like `TGuid.Create(const Data; BigEndian: Boolean = False): TGUID` but you can use new TEncoding based methods instead.

### *StringHelper
A new options which allows you to search substrings, change case and vice versa using string type methods instead of calling old string functions. Here this helpers implemented for `ShortString`, `AnsiString`, `RawByteString`, `UTF8String`, `WideString` and `UnicodeString` types.
 - Sometimes there no way to properly implement of some methods. For example `ToLowerInvariant()` is nonsence for AnsiString or event more for RawByteString which codepage is unknown. Be noticed that method is good only for Unicode data in `UTF8String`, `WideString` or `UnicodeString` variables.

## System.Hash
TODO...

## Old records, will be changed

  - Define WITH_UNICODE if you want to compile this units in DELPHIUNICODE mode.
  - Windows API is always preferred in Windows. If you want pure pascal implementation of various functions, define WITHOUT_WINAPI.
  - Define CLOSER_TO_DELPHI if you want to get as close to Delphi behaviour as possible (array size limited to Integer, etc.). Note that modern Delphi uses Unicode strings, so for the maximum similarity you should also define WITH_UNICODE.

In Windows THashSHA2 required at leaset Windows XP SP3 or higher. Define WITHOUT_WINAPI otherwise.
WITHOUT_FALLBACK?
