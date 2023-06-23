{$IFNDEF NPP_DARKMODE_INC}
{$DEFINE NPP_DARKMODE_INC}
// This file is part of Notepad++ project
// Copyright (c) 2021 adzm / Adam D. Walling

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// at your option any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.
const
  /// Standard flag for main parent after its children are initialized.
  dmfInit: Cardinal = $0000000B;
  /// Standard flag for main parent usually used in NPPN_DARKMODECHANGED.
  dmfHandleChange: Cardinal = $0000000C;

type
  TDarkModeColors = packed record
    Background: Cardinal;
    SofterBackground: Cardinal;
    HotBackground: Cardinal;
    PureBackground: Cardinal;
    ErrorBackground: Cardinal;
    Text: Cardinal;
    DarkerText: Cardinal;
    DisabledText: Cardinal;
    LinkText: Cardinal;
    Edge: Cardinal;
    HotEdge: Cardinal;
    DisabledEdge: Cardinal;
  end;
  PDarkModeColors = ^TDarkModeColors;

{$ENDIF ~NPP_DARKMODE_INC}
