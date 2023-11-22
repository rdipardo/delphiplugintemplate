{
  Copyright 2023 Robert Di Pardo

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

unit AboutForms;

{$IFDEF FPC}{$mode delphi}{$ENDIF}

interface

uses
  SysUtils, Variants, Classes, NppForms,
{$IFNDEF FPC}
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls
{$ELSE}
  Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls, LCLIntf, LCLType
{$ENDIF};

type

  { TAboutForm }

  TAboutForm = class(TNppForm)
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    constructor Create(AOwner: TComponent); override;
  end;

var
  AboutForm: TAboutForm;

implementation

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}

uses
  ModulePath, VersionInfo;

function ToTTranslateString(const Msg: UnicodeString): String;
begin
  Result := {$ifdef FPC}UTF8Encode{$endif}(Msg);
end;

constructor TAboutForm.Create(AOwner: TComponent);
var
  Info: TFileVersionInfo;
begin
  inherited Create(AOwner);
  try
    Info := TFileVersionInfo.Create(TModulePath.DLLFullName);
    self.Caption := ToTTranslateString(Info.ProductName);
    self.Label1.Caption := ToTTranslateString(Info.LegalCopyright);
    self.Label2.Caption := ToTTranslateString(Info.Comments);
    self.Label3.Caption := ToTTranslateString(Info.LegalTrademarks);
  finally
    FreeAndNil(Info);
  end;
end;

end.
