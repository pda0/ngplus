{**********************************************************************
    Copyright(c) 2016 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

{$IFDEF FPC}{$I fpc.inc}{$ELSE}{$I delphi.inc}{$ENDIF}

{ Define this if you want to disable all of OpenSSL related code }
{.$DEFINE _WITHOUT_OPENSSL}

{ Define this if you want to disable all Windows API related code }
{.$DEFINE _WITHOUT_WINAPI}

{$IF DEFINED(_WITHOUT_WINAPI) AND (NOT DEFINED(WINDOWS))}
  {$DEFINE _WITHOUT_WINAPI}
{$IFEND}

