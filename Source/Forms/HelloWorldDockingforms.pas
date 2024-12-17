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

  This file incorporates work covered by the following copyright and permission notice:

  The `TreeViewAdvCustomDrawItemForDarkMode` and `DrawExpander` methods are adapted from a
  Stack Overflow answer posted Jun 7, 2012 to https://stackoverflow.com/a/10936108

  SPDX-FileCopyrightText: (c) 2012 "Andrew" <https://stackoverflow.com/users/337473>
  SPDX-License-Identifier: CC-BY-SA-3.0
}

unit helloworlddockingforms;

{$IFDEF FPC}{$mode delphi}{$ENDIF}

interface

uses
  Messages, SysUtils, Variants, Classes, NppDockingForms, NppPlugin,
{$IFNDEF FPC}
  System.Types, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls
{$ELSE}
  Graphics, Controls, Forms, Dialogs, StdCtrls, LCLIntf, LCLType, ComCtrls
{$ENDIF};

type
  THelloWorldDockingForm = class(TNppDockingForm)
    Button1: TButton;
    Button2: TButton;
    TreeView1: TTreeview;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormFloat(Sender: TObject);
    procedure FormDock(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure TreeViewAdvCustomDrawItemForDarkMode(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage;
      var {%H-}PaintImages, DefaultDraw: boolean);
    procedure DrawExpander(ACanvas: TCanvas; ATextRect: TRect;
      AExpanded: boolean; AHot: boolean);
  public
    procedure ToggleDarkMode; override;
    procedure SubclassAndTheme(DmfMask: Cardinal); override;
  end;

var
  HelloWorldDockingForm: THelloWorldDockingForm;

implementation

uses
  Windows, UxTheme, Themes;

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
  self.OnFloat := self.FormFloat;
  self.OnDock := self.FormDock;
  inherited;
end;

procedure THelloWorldDockingForm.Button1Click(Sender: TObject);
var
  Root, Node: TTreeNode;
  I: integer;
begin
  with TreeView1.Items do
  begin
    Clear;
    Root := Add(nil, 'Section');
    AddChild(Root,'Article1');
    Node := AddChild(Root,'Article2');
    AddChild(Node, 'Part1');
    Node := AddChild(Node, 'Part2');
    AddChild(Node, 'SubPart');
    Node := AddChild(Node, 'Part3');
    for I:=1 to 4 do
        AddChild(Node, 'SubPart'+IntToStr(I));
  end;
  self.UpdateDisplayInfo(Format('showing %d items', [TreeView1.Items.Count]));
  TreeView1.FullExpand;
end;

procedure THelloWorldDockingForm.Button2Click(Sender: TObject);
begin
  inherited;
  self.Hide;
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
  inherited;
  self.ParentBackground := (not self.Npp.IsDarkModeEnabled);
  TreeView1.ParentColor := self.ParentBackground;
  if (not self.ParentBackground) then begin
    DarkModeColors := Default(NppPlugin.TDarkModeColors);
    self.Npp.GetDarkModeColors(@DarkModeColors);
    self.Color := TColor(DarkModeColors.Background);
    {
      FIXME: the background of FPC node items is drawn separately from
      the parent TreeView's background, revealing a sharp edge when
      the collapsed tree is shorter than the bevel
    }
    TreeView1.Color := TColor(DarkModeColors.Background);
  end else begin
    self.Color := clBtnFace;
    TreeView1.Color := clWindow;
  end;
end;

procedure THelloWorldDockingForm.SubclassAndTheme(DmfMask: cardinal);
var
  ThemeName: PWChar;
begin
  inherited SubclassAndTheme(DmfMask);
  SafeSendMessage(Npp.NppData.NppHandle, NPPM_DARKMODESUBCLASSANDTHEME, DmfMask,TreeView1.Handle);
  ThemeName := nil;
  if Npp.IsDarkModeEnabled then begin
    ThemeName := 'DarkMode_Explorer';
    TreeView1.OnAdvancedCustomDrawItem := TreeViewAdvCustomDrawItemForDarkMode;
  end else begin
    TreeView1.OnAdvancedCustomDrawItem := nil;
  end;
  SetWindowTheme(TreeView1.Handle, ThemeName, nil);
end;

// See https://stackoverflow.com/a/10936108
procedure THelloWorldDockingForm.TreeViewAdvCustomDrawItemForDarkMode(
  Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
  Stage: TCustomDrawStage; var PaintImages, DefaultDraw: boolean);
var
{$IFDEF FPC}
  TextStyle: TTextStyle;
{$ELSE}
  NodeText: string;
{$ENDIF}
  DarkModeColors: TDarkModeColors;
  NodeRect: TRect;
  NodeTextRect: TRect;
  ThemeData: HTHEME;
  TreeItemState: integer;
begin
  if Stage = cdPrePaint then begin
    NodeRect := Node.DisplayRect(False);
    NodeTextRect := Node.DisplayRect(True);

    // Drawing background for (in/a)ctive or selected node items
    if (cdsSelected in State) and Sender.Focused then
      TreeItemState := TREIS_SELECTED
    else
    if (cdsSelected in State) and (cdsHot in State) then
      TreeItemState := TREIS_HOTSELECTED
    else
    if cdsSelected in State then
      TreeItemState := TREIS_SELECTEDNOTFOCUS
    else
    if cdsHot in State then
      TreeItemState := TREIS_HOT
    else
      TreeItemState := TREIS_NORMAL;

    if TreeItemState <> TREIS_NORMAL then
    begin
      ThemeData := OpenThemeData(Sender.Handle, VSCLASS_TREEVIEW);
      DrawThemeBackground(ThemeData, Sender.Canvas.Handle, TVP_TREEITEM, TreeItemState,
        NodeRect, nil);
      CloseThemeData(ThemeData);
    end;

    // Drawing expander
    if Node.HasChildren then
      DrawExpander(Sender.Canvas, NodeTextRect, Node.Expanded, cdsHot in State);

    // Drawing item text
    SetBkMode(Sender.Canvas.Handle, Windows.TRANSPARENT);
    if Npp.IsDarkModeEnabled then begin
      DarkModeColors := Default(TDarkModeColors);
      Npp.GetDarkModeColors(@DarkModeColors);
      SetTextColor(Sender.Canvas.Handle, ColorToRGB(DarkModeColors.Text));
    end else begin
      SetTextColor(Sender.Canvas.Handle, ColorToRGB(clWindowText));
    end;
{$IFNDEF FPC}
    NodeText := Node.Text;
    Sender.Canvas.TextRect(NodeTextRect, NodeText,
      [tfVerticalCenter, tfSingleLine, tfEndEllipsis, tfLeft]);
{$ELSE}
    TextStyle := Default(TTextStyle);
    with TextStyle do
    begin
      Alignment := taCenter;
      Layout := tlCenter;
      SingleLine := True;
      EndEllipsis := True;
    end;
    Sender.Canvas.TextRect(NodeTextRect, 0, 0, Node.Text, TextStyle);
{$ENDIF}
  end{Stage = cdPrePaint};

  PaintImages := False;
  DefaultDraw := False;
end;

// See https://stackoverflow.com/a/10936108
procedure THelloWorldDockingForm.DrawExpander(ACanvas: TCanvas;
  ATextRect: TRect; AExpanded: boolean; AHot: boolean);
var
  ExpanderRect: TRect;
  ThemeData: HTHEME;
  ElementPart: integer;
  ElementState: integer;
  ExpanderSize: TSize;
begin
  ExpanderSize := Default(TSize);
  if
{$IFNDEF FPC}
  StyleServices.Enabled
{$ELSE}
  ThemeServices.ThemesEnabled
{$ENDIF}
  then
  begin
    if AHot then
      ElementPart := TVP_HOTGLYPH
    else
      ElementPart := TVP_GLYPH;

    if AExpanded then
      ElementState := HGLPS_OPENED
    else
      ElementState := HGLPS_CLOSED;

    ThemeData := OpenThemeData(TreeView1.Handle, VSCLASS_TREEVIEW);
    GetThemePartSize(ThemeData, ACanvas.Handle, ElementPart, ElementState, nil,
      TS_TRUE, ExpanderSize);
    ExpanderRect.Left := ATextRect.Left - ExpanderSize.cx;
    ExpanderRect.Right := ExpanderRect.Left + ExpanderSize.cx;
    ExpanderRect.Top := ATextRect.Top + (ATextRect.Bottom - ATextRect.Top -
      ExpanderSize.cy) div 2;
    ExpanderRect.Bottom := ExpanderRect.Top + ExpanderSize.cy;
    DrawThemeBackground(ThemeData, ACanvas.Handle, ElementPart,
      ElementState, ExpanderRect, nil);
    CloseThemeData(ThemeData);
  end;
end;

end.
