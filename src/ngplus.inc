{**********************************************************************
    Copyright(c) 2016 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

{$IFDEF FPC}
  {$IFDEF WITH_UNICODE}{$MODE DELPHIUNICODE}{$ELSE}{$MODE DELPHI}{$ENDIF}{$H+}
  {$CODEPAGE UTF8}
  {$MODESWITCH ADVANCEDRECORDS}
  {$MODESWITCH TYPEHELPERS}
{$ENDIF FPC}

{$IF DEFINED(WINDOWS) AND (NOT DEFINED(WITHOUT_WINAPI))}
  {$DEFINE WITH_WINAPI}
{$IFEND}

