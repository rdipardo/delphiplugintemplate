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

//! @abstract Pascal wrappers around the core Notepad++ plugin APIs
//! @note(Since Notepad++ [8.4](https://community.notepad-plus-plus.org/post/76117),
//! plugins can provide external lexers by implementing the [Lexilla protocol](https://www.scintilla.org/LexillaDoc.html).
//! At minimum, a lexer plugin must export a Pascal wrapper for each of the following:
//! @unorderedList(
//!  @item `ILexer5 *CreateLexer(const char *name)`
//!  @item `void GetLexerName(unsigned int index, char *name, int buflength)`
//!  @item `int GetLexerCount()`)
//! There is a working example [here](https://github.com/rdipardo/nppFSIPlugin/blob/master/Source/Plugin/Src/ILexerExports.pas).)
unit DLLExports;

interface

uses
  Windows, Messages, SysUtils, NppPlugin, HelloWorldPlugin;

/// *NOTE*
/// exported function names must be EXACTLY these: Pascal is case insensitive, not C++
//! Always returns @true
function isUnicode: BOOL; cdecl;
//! Returns this plugin's @link(TNppPlugin.PluginName) member as a pointer to a UTF-16 string
function getName: NppPChar; cdecl;
//! Sets `nFuncs` to the size of this plugin's @link(TNppPlugin.FuncArray) member and returns a pointer to it
function getFuncsArray(var nFuncs: integer): Pointer; cdecl;
//! Handles Win32 window messages, and some editor notifications as well
function messageProc(Msg: integer; _wParam: WPARAM; _lParam: LPARAM): LRESULT; cdecl;
//! Handles all setup logic that needs a valid handle to the Notepad++ application window
procedure setInfo(NppData: TNppData); cdecl;
//! Handles editor events and notifications from Notepad++
procedure beNotified(Msg: PSciNotification); cdecl;
//! Initializes and (on shutdown) destroys the main instance of this plugin
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

procedure setInfo(NppData: TNppData); cdecl;
begin
  Npp.setInfo(NppData);
end;

function getName: NppPChar; cdecl;
begin
  Result := Npp.getName;
end;

function getFuncsArray(var nFuncs: integer): Pointer; cdecl;
begin
  Result := Npp.getFuncsArray(nFuncs);
end;

procedure beNotified(Msg: PSciNotification); cdecl;
begin
  Npp.beNotified(Msg);
end;

function messageProc(Msg: integer; _wParam: WPARAM; _lParam: LPARAM): LRESULT; cdecl;
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

function isUnicode: BOOL; cdecl;
begin
  Result := true;
end;

end.
