{$IFNDEF DOCKING_INC}
{$DEFINE DOCKING_INC}
// This file is part of Notepad++ project
// Copyright (C)2024 Don HO <don.h@free.fr>

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
// styles for containers
  CAPTION_TOP     = TRUE;
  CAPTION_BOTTOM  = FALSE;

//   defines for docking manager
  CONT_LEFT    = 0;
  CONT_RIGHT   = 1;
  CONT_TOP     = 2;
  CONT_BOTTOM  = 3;
  DOCKCONT_MAX = 4;

// mask params for plugins of internal dialogs
  DWS_ICONTAB     = $00000001;     //! Display an icon on the docking tab (i.e., when this dialog loses focus in a dock group)
  DWS_ICONBAR     = $00000002;     //! Display an icon in the title bar (currently not supported)
  DWS_ADDINFO     = $00000004;     //! Display a string of additional information in the title bar
  DWS_USEOWNDARKMODE = $00000008;  //! Use plugin's own dark mode (i.e., prevent automatic subclassing; see @link(NPPM_DARKMODESUBCLASSANDTHEME))
  DWS_PARAMSALL   = (DWS_ICONTAB or DWS_ICONBAR or DWS_ADDINFO);

// default docking values for first call of plugin
  DWS_DF_CONT_LEFT   = (CONT_LEFT  shl 28);  //! Default docking on left
  DWS_DF_CONT_RIGHT  = (CONT_RIGHT shl 28);  //! Default docking on right
  DWS_DF_CONT_TOP    = (CONT_TOP shl 28);  //! Default docking on top
  DWS_DF_CONT_BOTTOM = (CONT_BOTTOM shl 28); //! Default docking on bottom
  DWS_DF_FLOATING    = $80000000;     //! Default state is floating



  HIT_TEST_THICKNESS  = 20;
  SPLITTER_WIDTH      = 4;

type
  TDockMgr = record
    DockMgrHandle: HWND;  //! The Docking Manager window
    RcRegion: array [0..DOCKCONT_MAX-1] of TRect; //! Position of docked dialogs
  end;

{$ENDIF ~DOCKING_INC}
