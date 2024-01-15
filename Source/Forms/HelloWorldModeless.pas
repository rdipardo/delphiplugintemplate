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
  Classes, Windows, ShellApi, NppForms, NppPlugin,
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
end;

procedure TModelessForm.Button1Click(Sender: TObject);
begin
  ShellExecuteW(0, 'Open',
    PWChar('https://npp-user-manual.org/docs/plugin-communication/#2036-nppm-modelessdialog'),
    nil, nil, SW_SHOWNORMAL);
  self.Close;
end;

procedure TModelessForm.ToggleDarkMode;
var
  DarkModeColors: NppPlugin.TDarkModeColors;
begin
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
end.
