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

unit helloworlddockingforms;

{$IFDEF FPC}{$mode delphi}{$ENDIF}

interface

uses
  Messages, SysUtils, Variants, Classes, NppDockingForms, NppPlugin,
{$IFNDEF FPC}
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls
{$ELSE}
  Graphics, Controls, Forms, Dialogs, StdCtrls, LCLIntf, LCLType
{$ENDIF};

type
  THelloWorldDockingForm = class(TNppDockingForm)
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormHide(Sender: TObject);
    procedure FormFloat(Sender: TObject);
    procedure FormDock(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    procedure ToggleDarkMode; override;
  end;

var
  HelloWorldDockingForm: THelloWorldDockingForm;

implementation

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}

procedure THelloWorldDockingForm.FormCreate(Sender: TObject);
begin
  // e.g. for a console input window:
  // self.NppDefaultDockingMask := DWS_DF_CONT_BOTTOM;
  self.NppDefaultDockingMask := DWS_DF_CONT_RIGHT;
  self.KeyPreview := true; // special hack for input forms
  self.OnFloat := self.FormFloat;
  self.OnDock := self.FormDock;
  inherited;
end;

procedure THelloWorldDockingForm.Button1Click(Sender: TObject);
begin
  inherited;
  self.UpdateDisplayInfo('test');
end;

procedure THelloWorldDockingForm.Button2Click(Sender: TObject);
begin
  inherited;
  self.Hide;
end;

// special hack for input forms
// This is the best possible hack I could came up for
// memo boxes that don't process enter keys for reasons
// too complicated... Has something to do with Dialog Messages
// I sends a Ctrl+Enter in place of Enter
procedure THelloWorldDockingForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if (Key = #13) and (self.Memo1.Focused) then
    self.Memo1.Perform(WM_CHAR, 10, 0);
end;

// Docking code calls this when the form is hidden by either "x" or self.Hide
procedure THelloWorldDockingForm.FormHide(Sender: TObject);
begin
  inherited;
  SafeSendMessage(self.Npp.NppData.NppHandle, NPPM_SETMENUITEMCHECK, self.CmdID, 0);
end;

procedure THelloWorldDockingForm.FormDock(Sender: TObject);
begin
  SafeSendMessage(self.Npp.NppData.NppHandle, NPPM_SETMENUITEMCHECK, self.CmdID, 1);
end;

procedure THelloWorldDockingForm.FormFloat(Sender: TObject);
begin
  SafeSendMessage(self.Npp.NppData.NppHandle, NPPM_SETMENUITEMCHECK, self.CmdID, 1);
end;

procedure THelloWorldDockingForm.FormShow(Sender: TObject);
begin
  inherited;
  SafeSendMessage(self.Npp.NppData.NppHandle, NPPM_SETMENUITEMCHECK, self.CmdID, 1);
end;

procedure THelloWorldDockingForm.ToggleDarkMode;
var
  DarkModeColors: NppPlugin.TDarkModeColors;
begin
  self.ParentBackground := (not self.Npp.IsDarkModeEnabled);
  Memo1.ParentColor := self.ParentBackground;
  if (not self.ParentBackground) then begin
    DarkModeColors := Default(NppPlugin.TDarkModeColors);
    self.Npp.GetDarkModeColors(@DarkModeColors);
    self.Color := TColor(DarkModeColors.Background);
    Memo1.Color := TColor(DarkModeColors.SofterBackground);
    Memo1.Font.Color := TColor(DarkModeColors.Text);
  end else begin
    self.Color := clBtnFace;
    Memo1.Color := clWhite;
    Memo1.Font.Color := clWindowText;
  end;
end;
end.
