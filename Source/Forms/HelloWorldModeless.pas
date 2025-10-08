{
  Copyright 2024 Robert Di Pardo

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

unit helloworldmodeless;

{$IFDEF FPC}{$mode delphi}{$ENDIF}

interface

uses
  Messages, Classes, Windows, ShellApi, NppForms, NppPlugin,
{$IFNDEF FPC}
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls
{$ELSE}
  Graphics, Controls, Forms, Dialogs, StdCtrls, LCLIntf, LCLType
{$ENDIF};

type
  TModelessForm = class(TNppForm)
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ToggleDarkMode; override;
{$IFNDEF FPC}
    procedure FormKeyPress(Sender: TObject; var Key: char);
{$ENDIF}
  end;

var
  HelloWorldModelessForm: TModelessForm;

implementation

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}

procedure TModelessForm.FormCreate(Sender: TObject);
begin
  inherited;
  RegisterForm; // sends NPPM_MODELESSDIALOG
  self.KeyPreview := true; // special hack for input forms
end;

procedure TModelessForm.Button1Click(Sender: TObject);
begin
  ShellExecuteW(0, 'Open',
    PWChar('https://npp-user-manual.org/docs/plugin-communication/#2036nppm_modelessdialog'),
    nil, nil, SW_SHOWNORMAL);
  self.Close;
end;

procedure TModelessForm.ToggleDarkMode;
var
  DarkModeColors: NppPlugin.TDarkModeColors;
begin
  if (self.Npp.CanSubclass) then begin
    inherited;
    Exit;
  end;
  if (self.Npp.IsDarkModeEnabled) then begin
    DarkModeColors := Default(NppPlugin.TDarkModeColors);
    self.Npp.GetDarkModeColors(@DarkModeColors);
    self.Color := TColor(DarkModeColors.Background);
    self.Font.Color := TColor(DarkModeColors.Text);
    Memo1.Color := TColor(DarkModeColors.SofterBackground);
  end else begin
    self.Color := clBtnFace;
    self.Font.Color := clWindowText;
    Memo1.Color := clWhite;
  end;
end;

{$IFNDEF FPC}
// special hack for input forms
// This is the best possible hack I could came up for
// memo boxes that don't process enter keys for reasons
// too complicated... Has something to do with Dialog Messages
// I sends a Ctrl+Enter in place of Enter
procedure TModelessForm.FormKeyPress(Sender: TObject; var Key: char);
begin
  inherited;
  if (Key = #13) and (self.Memo1.Focused) then
    self.Memo1.Perform(WM_CHAR, 10, 0);
end;
{$ENDIF}
end.
