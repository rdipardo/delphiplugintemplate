{
  Copyright 2008 Damjan Zobo Cvetko

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License along
  with this program; if not, write to the Free Software Foundation, Inc.,
  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
}

unit DLLExports;

interface

uses
  Windows, Messages, SysUtils, NppPlugin, HelloWorldPlugin;

/// *NOTE*
/// exported function names must be EXACTLY these: Pascal is case insensitive, not C++
function isUnicode: BOOL; cdecl; export;
function getName: NppPChar; cdecl; export;
function getFuncsArray(var nFuncs: integer): Pointer; cdecl; export;
function messageProc(Msg: integer; _wParam: WPARAM; _lParam: LPARAM): LRESULT;
  cdecl; export;
procedure setInfo(NppData: TNppData); cdecl; export;
procedure beNotified(Msg: PSciNotification); cdecl; export;
procedure DLLEntryPoint(dwReason: DWord);

implementation

procedure DLLEntryPoint(dwReason: DWord);
begin
  case dwReason of
    DLL_PROCESS_ATTACH:
      begin
        // create the main 'Npp' object
        Npp := THelloWorldPlugin.Create;
      end;
    DLL_PROCESS_DETACH:
      begin
        // free the main 'Npp' object
        if (Assigned(Npp)) then
          FreeAndNil(Npp);
      end;
    // DLL_THREAD_ATTACH: MessageBeep(0);
    // DLL_THREAD_DETACH: MessageBeep(0);
  end;
end;

procedure setInfo(NppData: TNppData); cdecl; export;
begin
  Npp.setInfo(NppData);
end;

function getName: NppPChar; cdecl; export;
begin
  Result := Npp.getName;
end;

function getFuncsArray(var nFuncs: integer): Pointer; cdecl; export;
begin
  Result := Npp.getFuncsArray(nFuncs);
end;

procedure beNotified(Msg: PSciNotification); cdecl; export;
begin
  Npp.beNotified(Msg);
end;

function messageProc(Msg: integer; _wParam: WPARAM; _lParam: LPARAM): LRESULT;
  cdecl; export;
var
  xmsg: TMessage;
begin
  xmsg.Msg := Msg;
  xmsg.WPARAM := _wParam;
  xmsg.LPARAM := _lParam;
  xmsg.Result := 0;
  Npp.messageProc(xmsg);
  Result := xmsg.Result;
end;

function isUnicode: BOOL; cdecl; export;
begin
  Result := true;
end;

end.
