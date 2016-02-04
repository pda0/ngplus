# NGPlus
Free Pascal implementation of various modern Delphi classes and records.

  - Define WITH_UNICODE if you want to compile this units in DELPHIUNICODE mode.
  - Windows API is always preferred in Windows. If you want pure pascal implementation of various functions, define WITHOUT_WINAPI.
  - Define CLOSER_TO_DELPHI if you want to get as close to Delphi behaviour as possible (array size limited to Integer, etc.). Note that modern Delphi uses Unicode strings, so for the maximum similarity you should also define WITH_UNICODE.

In Windows THashSHA2 required at leaset Windows XP SP3 or higher. Define WITHOUT_WINAPI otherwise.
WITHOUT_FALLBACK?

WARNING: This library is still alpha. Everything can change.
