{
  Original unit (c) 2008 Damjan Zobo Cvetko
  Revisions (c) 2022 Robert Di Pardo <dipardo.r@gmail.com>

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

unit HelloWorldPlugin;

interface

uses
  SysUtils, Windows, NppPlugin, HelloWorldDockingForms, HelloWorldModeless, AboutForms;

const
  /// menu index of the dockable form
  DlgMenuId = 2;

type
  THelloWorldPlugin = class(TNppPlugin)
  public
    constructor Create;
    procedure FuncHelloWorld;
    procedure FuncHolaMundo;
    procedure FuncHelloWorldDocking;
    procedure FuncHelloWorldModeless;
    procedure FuncAbout;
    procedure DoNppnToolbarModification; override;
    procedure BeNotified(sn: PSciNotification); override;
  end;

procedure _FuncHelloWorld; cdecl;
procedure _FuncHolaMundo; cdecl;
procedure _FuncHelloWorldDocking; cdecl;
procedure _FuncHelloWorldModeless; cdecl;
procedure _FuncAbout; cdecl;

/// a global instance of the main plugin object
var
  Npp: THelloWorldPlugin;

implementation

{$IFDEF FPC}
uses
  Forms;
{$ENDIF}

{ THelloWorldPlugin }

constructor THelloWorldPlugin.Create;
var
  PSk: PShortcutKey;
begin
  inherited;
  self.PluginName := 'Hello &World';

  PSk := MakeShortcutKey(true, false, true, $48); // CTRL + SHIFT + H
  self.AddFuncItem('&Insert "Hello, World!"', _FuncHelloWorld, PSk);

  PSk := MakeShortcutKey(false, true, true, $48); // ALT + SHIFT + H
  self.AddFuncItem('&Replace "Hello, World!"', _FuncHolaMundo, PSk);

  self.AddFuncItem('Load Docking &Form', _FuncHelloWorldDocking);
  self.AddFuncItem('Show a &Modeless Form', _FuncHelloWorldModeless);
  self.AddFuncItem('-', nil); // create a separator
  self.AddFuncItem('&About', _FuncAbout);
end;

procedure _FuncHelloWorld; cdecl;
begin
  Npp.FuncHelloWorld;
end;

procedure _FuncHolaMundo; cdecl;
const
  Msg = 'This function requires %s!'#13#10'It has been disabled to prevent a crash.';
begin
{$IFDEF CPUx64}
{$IFNDEF NPP_NO_HUGE_FILES}
  if not Npp.SupportsBigFiles then
  begin
    MessageBoxW(Npp.NppData.NppHandle, PWChar(WideFormat(Msg,['Notepad++ 8.3 or newer'])),
      PWChar('Unsupported N++ Version'), MB_ICONWARNING);
    Exit;
  end;
{$ELSE}
  if Npp.SupportsBigFiles then
  begin
    MessageBoxW(Npp.NppData.NppHandle, PWChar(WideFormat(Msg,['Notepad++ 8.2.1 or older'])),
      PWChar('Unsupported N++ Version'), MB_ICONWARNING);
    Exit;
  end;
{$ENDIF}
{$ENDIF}
    Npp.FuncHolaMundo;
end;

procedure _FuncAbout; cdecl;
begin
  Npp.FuncAbout;
end;

procedure _FuncHelloWorldDocking; cdecl;
begin
  Npp.FuncHelloWorldDocking;
end;

procedure _FuncHelloWorldModeless; cdecl;
begin
  Npp.FuncHelloWorldModeless;
end;

procedure THelloWorldPlugin.FuncHelloWorld;
var
  Editor: HWND;
begin
  Editor := Self.CurrentScintilla;
  SendMessageW(Editor, SCI_REPLACESEL, 0, LPARAM(PAnsiChar('Hello, World!'#13#10)));

  if SendMessageW(Editor, SCI_GETCODEPAGE, 0, 0) = SC_CP_UTF8
  then
    SendMessageW(Editor, SCI_REPLACESEL, 0, LPARAM(PAnsiChar('こにちは、皆さん‼'#13#10)));
end;

procedure THelloWorldPlugin.FuncHolaMundo;
const
  OldTxt = 'Hello, World!';
  NewTxt = '¡Hola, mundo!';
  NewTxtA: ShortString = #161'Hola, mundo!';
var
  Editor: HWND;
  HelloTxt: TSciTextToFind;
  HelloTxtFull: TSciTextToFindFull;
  StartPos: Sci_Position;
  SciMsg, LenNewTxt: Cardinal;
begin
  Editor := Self.CurrentScintilla;
  SciMsg := SCI_FINDTEXT;
  HelloTxt := Default (TSciTextToFind);
  with HelloTxt do begin
    chrg.cpMin := 0;
    chrg.cpMax := SendMessageW(Editor, SCI_GETLENGTH, 0, 0);
    chrgText := chrg;
    lpstrText := PAnsiChar(OldTxt);
  end;
  if Npp.HasFullRangeApis then begin
    SciMsg := SCI_FINDTEXTFULL;
    HelloTxtFull := Default (TSciTextToFindFull);
    with HelloTxtFull do begin
      chrg.cpMin := 0;
      chrg.cpMax := SendMessageW(Editor, SCI_GETLENGTH, 0, 0);
      chrgText := chrg;
      lpstrText := PAnsiChar(OldTxt);
    end;
    StartPos := SendMessageW(Editor, SciMsg, 0, LPARAM(@HelloTxtFull));
  end else
    StartPos := SendMessageW(Editor, SciMsg, 0, LPARAM(@HelloTxt));
  if StartPos <> INVALID_POSITION then
  begin
    SendMessageW(Editor, SCI_SETTARGETSTART, StartPos, 0);
    SendMessageW(Editor, SCI_SETTARGETEND,
      StartPos + Length(OldTxt), 0);
    if SendMessageW(Editor, SCI_GETCODEPAGE, 0, 0) = SC_CP_UTF8 then
    begin
      LenNewTxt := Length(NewTxt);
      SendMessageW(Editor, SCI_REPLACETARGET, LenNewTxt, LPARAM(PAnsiChar(NewTxt)));
    end
    else
    begin
      LenNewTxt := Length(NewTxtA);
      SendMessageW(Editor, SCI_REPLACETARGET, LenNewTxt, LPARAM(@(NewTxtA)[1]));
    end;
    SendMessageW(Editor, SCI_SETSELECTIONSTART, StartPos, 0);
    SendMessageW(Editor, SCI_SETSELECTIONEND, LenNewTxt, 0);
  end;
end;

procedure THelloWorldPlugin.FuncAbout;
begin
  try
    try
      if (not Assigned(AboutForm)) then begin
      {$IFDEF FPC}
          Application.CreateForm(TAboutForm, AboutForm);
          AboutForm.Npp := Self;
      {$ELSE}
          AboutForm := TAboutForm.Create(Self);
      {$ENDIF}
      end;
      AboutForm.ShowModal;
    finally
      FreeAndNil(AboutForm);
    end;
  except
  on E: Exception do
  {$IFDEF FPC}
    MessageBox(Npp.NppData.NppHandle, PChar(E.Message), PChar(E.Message), MB_ICONERROR);
  {$ELSE}
    MessageBoxW(Npp.NppData.NppHandle, PWChar(E.Message), PWChar(E.Message), MB_ICONERROR);
  {$ENDIF}
  end;
end;

procedure THelloWorldPlugin.FuncHelloWorldDocking;
begin
  if (not Assigned(HelloWorldDockingForm)) then
  begin
    HelloWorldDockingForm := THelloWorldDockingForm.Create(self);
    HelloWorldDockingForm.Show(self, DlgMenuId);
  end else
    HelloWorldDockingForm.Show;
end;

procedure THelloWorldPlugin.FuncHelloWorldModeless;
begin
  if (not Assigned(HelloWorldModelessForm)) then
    HelloWorldModelessForm := TModelessForm.Create(self);

  HelloWorldModelessForm.Show;
end;

procedure THelloWorldPlugin.DoNppnToolbarModification;
var
  tb: TToolbarIcons;
  tbDark: TTbIconsDarkMode;
  HTbBmp: HBITMAP;
  HTIcon: HICON;
  hHDC: HDC;
  bmpX, bmpY, icoX, icoY: Integer;
begin
  tb := Default (TToolbarIcons);
  tbDark := Default (TTbIconsDarkMode);
  hHDC := 0;
  try
    hHDC := GetDC(THandle(Nil));
    bmpX := MulDiv(16, GetDeviceCaps(hHDC, LOGPIXELSX), 96);
    bmpY := MulDiv(16, GetDeviceCaps(hHDC, LOGPIXELSY), 96);
    icoX := MulDiv(32, GetDeviceCaps(hHDC, LOGPIXELSX), 96);
    icoY := MulDiv(32, GetDeviceCaps(hHDC, LOGPIXELSY), 96);
  finally
    ReleaseDC(THandle(Nil), hHDC);
  end;
  HTbBmp := LoadImage(Hinstance, 'TB_BMP', IMAGE_BITMAP, bmpX, bmpY, 0);
  HTIcon := LoadImage(Hinstance, 'TB_ICON', IMAGE_ICON, icoX, icoY,
    (LR_DEFAULTSIZE or LR_LOADMAP3DCOLORS));
  tb.ToolbarBmp := HTbBmp;
  tb.ToolbarIcon := HTIcon;
  tbDark.ToolbarBmp := HTbBmp;
  tbDark.ToolbarIcon := HTIcon;

  if self.SupportsDarkMode then
  begin
    tbDark.ToolbarIconDarkMode := LoadImage(Hinstance, 'TB_DM_ICON', IMAGE_ICON,
      icoX, icoY, (LR_DEFAULTSIZE or LR_LOADMAP3DCOLORS));
    SendNppMessage(NPPM_ADDTOOLBARICON_FORDARKMODE, CmdIdFromDlgId(DlgMenuId), @tbDark);
  end
  else
    SendNppMessage(NPPM_ADDTOOLBARICON_DEPRECATED, CmdIdFromDlgId(DlgMenuId), @tb);
end;

procedure THelloWorldPlugin.BeNotified(sn: PSciNotification);
begin
  inherited BeNotified(sn);
  if HWND(sn^.nmhdr.hwndFrom) = self.NppData.NppHandle then begin
    case sn.nmhdr.code of
      NPPN_DARKMODECHANGED: begin
        if Assigned(HelloWorldDockingForm) then begin
          HelloWorldDockingForm.ToggleDarkMode;
        end;
        if Assigned(HelloWorldModelessForm) then begin
          HelloWorldModelessForm.ToggleDarkMode;
        end;
      end;
    end;
  end;
end;

initialization
  { . . . }
finalization
  { NOTE: do not attempt to free docking forms; the application manages them }
  if Assigned(HelloWorldModelessForm) then
    FreeAndNil(HelloWorldModelessForm);
end.
