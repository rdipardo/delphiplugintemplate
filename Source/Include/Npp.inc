{$IFNDEF NPP_INC}
{$DEFINE NPP_INC}
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
{$MINENUMSIZE 4}

const
  NPPMSG = (WM_USER + 1000);
  //! `BOOL NPPM_GETCURRENTSCINTILLA(0, int* iScintillaView)`
  //! @br Get the index of the currently active Scintilla view.
  //! @param wParam 0 (not used)
  //! @param iScintillaView [out] either @link(MAIN_VIEW) or (@link(SUB_VIEW)
  //! @br@br Returns @true.
  NPPM_GETCURRENTSCINTILLA = (NPPMSG + 4);
  //! `BOOL NPPM_GETCURRENTLANGTYPE(0, int* langType)`
  //! @br Get the @link(TNppLang) associated with the current document.
  //! @param wParam 0 (not used)
  //! @param langType [out] see @link(TNppLang) for all valid values
  //! @br@br Returns @true.
  NPPM_GETCURRENTLANGTYPE = (NPPMSG + 5);
  //! `BOOL NPPM_SETCURRENTLANGTYPE(0, int langType)`
  //! @br Set the @link(TNppLang) associated with the current document.
  //! @param wParam 0 (not used)
  //! @param langType [out] see @link(TNppLang) for all valid values
  //! @br@br Returns @true.
  NPPM_SETCURRENTLANGTYPE = (NPPMSG + 6);
  //! `int NPPM_GETNBOPENFILES(0, int iViewType)`
  //! @br Get the number of files currently open in the given view.
  //! @param wParam 0 (not used)
  //! @param lPiViewType [in] can be @link(PRIMARY_VIEW), @link(SECOND_VIEW) or @link(ALL_OPEN_FILES)
  //! @br@br Returns the number of opened files.
  NPPM_GETNBOPENFILES = (NPPMSG + 7);
  ALL_OPEN_FILES = 0;
  PRIMARY_VIEW = 1;
  SECOND_VIEW = 2;
  //! `BOOL NPPM_GETOPENFILENAMES(wchar_t** fileNames, int nbFileNames)`
  //! @br Get the full path names of all files currently open in both views. The user must allocate a big enough `fileNames` array using @link(NPPM_GETNBOPENFILES).
  //! @param fileNames [out] pre-allocated array of file paths
  //! @param nbFileNames [in] the number of file paths in `fileNames`
  //! @br@br Returns the number of files copied to the `fileNames` array.
  NPPM_GETOPENFILENAMES = (NPPMSG + 8);
  //! `HWND NPPM_MODELESSDIALOG(int action, HWND hDlg)`
  //! @br Register (or unregister) the plugin dialog with the given handle.
  //! @param action [in] either @link(MODELESSDIALOGADD) (to register) or @link(MODELESSDIALOGREMOVE) (to unregister)
  //! @param hDlg [in] the handle of the dialog to register/unregister
  //! @br@br Returns `hDlg` (`HWND`) on success, @nil on failure.
  //! @note(For each dialog created by your plugin, you should use this API to register it (and unregister it on destruction).
  //! If this message is ignored, dialog edit controls will not receive key stroke messages such as TAB, Ctrl-C or Ctrl-V key.)
  NPPM_MODELESSDIALOG = (NPPMSG + 12);
  MODELESSDIALOGADD = 0;
  MODELESSDIALOGREMOVE = 1;
  //! `int NPPM_GETNBSESSIONFILES (BOOL* pbIsValidXML, wchar_t* sessionFileName)`
  //! @br Get the number of files listed in the session file with the given `sessionFileName`.
  //! @param(pbIsValidXML [out] *Since [8.6](https://github.com/notepad-plus-plus/notepad-plus-plus/commit/72c5175):*
  //!       @true if `sessionFileName` is valid XML, otherwise @false. If `sessionFileName` is a @nil pointer, this parameter is ignored)
  //! @param sessionFileName [in] the XML session file's full path
  //! @br@br On success, returns the number of files listed in the XML session file
  NPPM_GETNBSESSIONFILES = (NPPMSG + 13);
  //! `BOOL NPPM_GETSESSIONFILES (wchar_t** sessionFileArray, wchar_t* sessionFileName)`
  //! @br Get the full path names of all files listed in the session file with the given `sessionFileName`.
  //! @param(sessionFileArray [out] pre-allocated array of file paths.To allocate the array with the proper size, first send @link(NPPM_GETNBSESSIONFILES))
  //! @param sessionFileName [in] the XML session file's full path
  //! @br@br Returns @false on failure, @true on success.
  NPPM_GETSESSIONFILES = (NPPMSG + 14);
  //! `wchar_t* NPPM_SAVESESSION(0, sessionInfo* si)`
  //! @br Save a given set of file paths to a new session file.
  //! @param wParam 0 (not used)
  //! @param si [in] a pointer to a @link(TSessionInfo) structure
  //! @br@br Returns a pointer to the session file name buffer on success, @nil otherwise.
  //! @note Unlike @link(NPPM_SAVECURRENTSESSION), which saves the currently open files, this API can be used to add any file to a session.
  NPPM_SAVESESSION = (NPPMSG + 15);
  //! `wchar_t* NPPM_SAVECURRENTSESSION(0, wchar_t* sessionFileName)`
  //! @br Save all files currently open in Notepad++ to an XML session file.
  //! @param wParam 0 (not used)
  //! @param sessionFileName [in] the XML session file's full path
  //! @br@br Returns a pointer to the `sessionFileName` buffer on success, @nil otherwise.
  NPPM_SAVECURRENTSESSION = (NPPMSG + 16);
  //! `BOOL NPPM_GETOPENFILENAMESPRIMARY(wchar_t** fileNames, int nbFileNames)`
  //! @br Get the full path names of all files currently open in the main view. The user must allocate a big enough `fileNames` array using @link(NPPM_GETNBOPENFILES).
  //! @param fileNames [out] pre-allocated array of file paths
  //! @param nbFileNames [in] the number of file paths in `fileNames`
  //! @br@br Returns the number of files copied to the `fileNames` array.
  NPPM_GETOPENFILENAMESPRIMARY = (NPPMSG + 17);
  //! `BOOL NPPM_GETOPENFILENAMESSECOND(wchar_t** fileNames, int nbFileNames)`
  //! @br Get the full path names of all files currently open in the sub-view. The user must allocate a big enough `fileNames` array using @link(NPPM_GETNBOPENFILES).
  //! @param fileNames [out] pre-allocated array of file paths
  //! @param nbFileNames [in] the number of file paths in `fileNames`
  //! @br@br Returns the number of files copied to the `fileNames` array.
  NPPM_GETOPENFILENAMESSECOND = (NPPMSG + 18);
  //! `HWND NPPM_CREATESCINTILLAHANDLE(0, HWND hParent)`
  //! @br Get a handle to the active Scintilla control.
  //! @param wParam 0 (not used)
  //! @param hParent[in] if set (i.e., not @nil), it will be the parent window of this created Scintilla handle, otherwise the parent window is Notepad++
  //! @br@br Returns the created Scintilla handle.
  NPPM_CREATESCINTILLAHANDLE = (NPPMSG + 20);
  //! `BOOL NPPM_DESTROYSCINTILLAHANDLE_DEPRECATED(0, HWND hScintilla)`
  //! @br Does nothing and always returns @true. Notepad++ will deallocate every created Scintilla control on exit.
  //! @param wParam 0 (not used)
  //! @param hScintilla [in] Scintilla handle
  //! @note This message exists for backward compatibility only.
  NPPM_DESTROYSCINTILLAHANDLE_DEPRECATED = (NPPMSG + 21);
  //! See @link(NPPM_DESTROYSCINTILLAHANDLE_DEPRECATED)
  NPPM_DESTROYSCINTILLAHANDLE = NPPM_DESTROYSCINTILLAHANDLE_DEPRECATED deprecated;
  //! `int NPPM_GETNBUSERLANG(0, int* udlID)`
  //! @br Get the number of user-defined languages and, optionally, the starting menu id.
  //! @param wParam 0 (not used)
  //! @param udlID [optional] 0, if not used; otherwise an integer pointer to retrieve the starting menu id
  //! @br@br Returns the number of user-defined languages identified.
  NPPM_GETNBUSERLANG = (NPPMSG + 22);
  //! `int NPPM_GETCURRENTDOCINDEX(0, int inView)`
  //! @br Get the index of the document currently open in the given view.
  //! @param wParam 0 (not used)
  //! @param inView [in] either @link(MAIN_VIEW) or @link(SUB_VIEW)
  //! @br@br Returns -1 if the view is invisible (hidden), otherwise the current document's index.
  NPPM_GETCURRENTDOCINDEX = (NPPMSG + 23);
  MAIN_VIEW = 0;
  SUB_VIEW = 1;
  //! `BOOL NPPM_SETSTATUSBAR(int whichPart, wchar_t* str2set)`
  //! @br Change the text in a field of the status bar.
  //! @param whichPart [in] a value between @link(STATUSBAR_DOC_TYPE) - @link(STATUSBAR_TYPING_MODE) indicating the status bar section to set
  //! @param str2set [in] the string to be shown in the given status bar section
  //! @br@br Returns @false on failure, @true on success.
  NPPM_SETSTATUSBAR = (NPPMSG + 24);
  STATUSBAR_DOC_TYPE = 0;
  STATUSBAR_DOC_SIZE = 1;
  STATUSBAR_CUR_POS = 2;
  STATUSBAR_EOF_FORMAT = 3;
  STATUSBAR_UNICODE_TYPE = 4;
  STATUSBAR_TYPING_MODE = 5;
  //! `HMENU NPPM_GETMENUHANDLE(int menuChoice, 0)`
  //! @br Get a handle to the menu indicated by `menuChoice`.
  //! @param menuChoice [in] either the main menu (@link(NPPMAINMENU)) or the plugin menu (@link(NPPPLUGINMENU))
  //! @param lParam 0 (not used)
  //! @br@br Returns the desired menu handle (`HMENU`): either the plugin menu handle or the Notepad++ main menu handle.
  NPPM_GETMENUHANDLE = (NPPMSG + 25);
  NPPPLUGINMENU = 0;
  NPPMAINMENU = 1;
  //! `int NPPM_ENCODESCI(int inView, 0)`
  //! @br Change the document encoding of the given view.
  //! @param inView [in] either @link(MAIN_VIEW) or @link(SUB_VIEW)
  //! @param lParam 0 (not used)
  //! @br@br Returns the new UniMode, with the following value:.
  //! @orderedList(
  //!   @itemSpacing Compact
  //!   @itemSetNumber 0
  //!   @item ANSI
  //!   @item UTF-8 with BOM
  //!   @item UTF-16 Big Ending with BOM
  //!   @item UTF-16 Little Ending with BOM
  //!   @item UTF-8 without BOM
  //!   @item uni7Bit
  //!   @item UTF-16 Big Ending without BOM
  //!   @item UTF-16 Little Ending without BOM)
  NPPM_ENCODESCI = (NPPMSG + 26);
  //! `int NPPM_DECODESCI(int inView, 0)`
  //! @br Change the document encoding of the given view to ANSI.
  //! @param inView [in] either @link(MAIN_VIEW) or @link(SUB_VIEW))
  //! @param lParam 0 (not used)
  //! @br@br Returns the old UniMode -- see @link(NPPM_ENCODESCI).
  NPPM_DECODESCI = (NPPMSG + 27);
  //! `BOOL NPPM_ACTIVATEDOC(int , int index2Activate)`
  //! @br Switch to the document in the given view with the given `index2Activate`.
  //! @param inView [in] either @link(MAIN_VIEW) or @link(SUB_VIEW)
  //! @param index2Activate [in] index (in the given view) of the document to be activated
  //! @br@br Returns @true.
  NPPM_ACTIVATEDOC = (NPPMSG + 28);
  //! `BOOL NPPM_LAUNCHFINDINFILESDLG(wchar_t* dir2Search, wchar_t* filter)`
  //! @br Launch the "Find in Files" dialog and set the "Find in" directory and filters with the given arguments.
  //! @param dir2Search [in] if not @nil, this will be the working directory in which Notepad++ will search
  //! @param filter [in] if not @nil, this filter string will be set in the filter field
  //! @br@br Returns @true.
  NPPM_LAUNCHFINDINFILESDLG = (NPPMSG + 29);
  //! `BOOL NPPM_DMMSHOW(0, HWND hDlg)`
  //! @br Show a dialog that was previously registered with @link(NPPM_DMMREGASDCKDLG).
  //! @param wParam 0 (not used)
  //! @param hDlg [in] the handle of the dialog to show
  //! @br@br Returns @true.
  NPPM_DMMSHOW = (NPPMSG + 30);
  //! `BOOL NPPM_DMMHIDE(0, HWND hDlg)`
  //! @br Hide a dialog that was previously registered with @link(NPPM_DMMREGASDCKDLG).
  //! @param wParam 0 (not used)
  //! @param hDlg [in] the handle of the dialog to hide
  //! @br@br Returns @true.
  NPPM_DMMHIDE = (NPPMSG + 31);
  //! `BOOL NPPM_DMMUPDATEDISPINFO(0, HWND hDlg)`
  //! @br Redraw the title bar of a dialog that was previously registered with @link(NPPM_DMMREGASDCKDLG).
  //! @param wParam 0 (not used)
  //! @param hDlg [in] the handle of the dialog to redraw
  //! @br@br Returns @true.
  NPPM_DMMUPDATEDISPINFO = (NPPMSG + 32);
  //! `BOOL NPPM_DMMREGASDCKDLG(0, tTbData* pData)`
  //! @br Register a plugin dialog with the Docking Manager.
  //! @param wParam 0 (not used)
  //! @param(pData [in] a pointer of type @link(PToolbarData).
  //!        The fields which, at minimum, need to be filled out are @link(TToolbarData.ClientHandle), @link(TToolbarData.Title),
  //!        @link(TToolbarData.DlgId), @link(TToolbarData.Mask) and @link(TToolbarData.ModuleName).
  //!        Note that @link(TToolbarData.FloatRect) and @link(TToolbarData.PrevContainer) should **not** be filled. They are used internally.)
  //! @br@br Returns @true.
  NPPM_DMMREGASDCKDLG = (NPPMSG + 33);
  //! `BOOL NPPM_LOADSESSION(0, wchar_t* sessionFileName)`
  //! @br Reopen all the files listed in `sessionFileName`.
  //! @param wParam 0 (not used)
  //! @param sessionFileName [in] full path name of the session file to reload
  //! @br@br Returns @true.
  NPPM_LOADSESSION = (NPPMSG + 34);
  //! `BOOL NPPM_DMMVIEWOTHERTAB(0, wchar_t* name)`
  //! @br Show the docked dialog with the given `name` (or switch to the tab of that dialog in a docking group).
  //! @param wParam 0 (not used)
  //! @param name [in] the name used to register the dialog (i.e., the @link(TToolbarData.Title) passed to @link(NPPM_DMMREGASDCKDLG))
  //! @br@br Returns @true.
  NPPM_DMMVIEWOTHERTAB = (NPPMSG + 35);
  //! `BOOL NPPM_RELOADFILE(BOOL withAlert, wchar_t* filePathName2Reload)`
  //! @br Reload the document matching the given `filePathName2Reload`.
  //! @param wParam 0 (not used)
  //! @param filePathName2Reload [in] full file path of the document to reload
  //! @br@br Returns @true if reloading succeeds, otherwise @false.
  NPPM_RELOADFILE = (NPPMSG + 36);
  //! `BOOL NPPM_SWITCHTOFILE(0, wchar_t* filePathName2switch)`
  //! @br Switch to the document matching the given `filePathName2switch`.
  //! @param wParam 0 (not used)
  //! @param filePathName2Reload [in] the full file path of document to switch to
  //! @br@br Returns @true.
  NPPM_SWITCHTOFILE = (NPPMSG + 37);
  //! `BOOL NPPM_SAVECURRENTFILE(0, 0)`
  //! @br Save the currently active document.
  //! @param wParam 0 (not used)
  //! @param lParam 0 (not used)
  //! @br@br Returns @true if the file is saved, otherwise @false (the file doesn't need to be saved, or another reason).
  NPPM_SAVECURRENTFILE = (NPPMSG + 38);
  //! `BOOL NPPM_SAVEALLFILES(0, 0)`
  //! @br Save all opened documents.
  //! @param wParam 0 (not used)
  //! @param lParam 0 (not used)
  //! @br@br Returns @false when no file needs to be saved, else @true if at least one file is saved.
  NPPM_SAVEALLFILES = (NPPMSG + 39);
  //! `BOOL NPPM_SETMENUITEMCHECK(UINT pluginCmdID, BOOL doCheck)`
  //! @br Set or remove the checkmark on a plugin menu item and highlight or unhighlight its toolbar icon (if any).
  //! @param pluginCmdID [in] the plugin command ID corresponding to the menu item; see @link(_TFuncItem.CmdID)
  //! @param doCheck [in] @true to check the item, or @false to uncheck it
  //! @br@br Returns @true.
  NPPM_SETMENUITEMCHECK = (NPPMSG + 40);
  //! `BOOL NPPM_ADDTOOLBARICON_DEPRECATED(UINT pluginCmdID, toolbarIcons* iconHandles)`
  //! @br Add an icon to the toolbar.
  //! @param pluginCmdID [in] the plugin command ID corresponding to the toolbar item whose icon will be set; see @link(_TFuncItem.CmdID)
  //! @param(iconHandles [in] pointer to a @link(TToolbarIcons) structure.
  //!         2 formats (ICO and BMP) are needed. Both handles should be set to ensure correct display in case the user selects a custom toolbar icon set)
  //! @br@br Returns @true.
  //! @note Use @link(NPPM_ADDTOOLBARICON_FORDARKMODE) instead.
  NPPM_ADDTOOLBARICON_DEPRECATED = (NPPMSG + 41);
  //! See @link(NPPM_ADDTOOLBARICON_DEPRECATED)
  NPPM_ADDTOOLBARICON = NPPM_ADDTOOLBARICON_DEPRECATED deprecated;
  //! `winVer NPPM_GETWINDOWSVERSION(0, 0)`
  //! @br Get the host PC's (Windows) OS version.
  //! @param wParam 0 (not used)
  //! @param lParam 0 (not used)
  //! @br@br Returns a @link(TWinVer) value.
  NPPM_GETWINDOWSVERSION = (NPPMSG + 42);
  //! `HWND NPPM_DMMGETPLUGINHWNDBYNAME(const wchar_t* windowName, const wchar_t* moduleName)`
  //! @br Retrieve the handle of the docked dialog corresponding to the given `windowName` and `moduleName`.
  //! @param windowName [in] if @nil, the handle of the first window matching `moduleName` will be returned
  //! @param moduleName [in] if @nil, the return value is also @nil
  //! @br@br Returns @nil if `moduleName` is @nil. If `windowName` is @nil, the handle of the first window matching `moduleName` is returned.
  //! @note Use this API to communicate with another plugin's docking dialog.
  NPPM_DMMGETPLUGINHWNDBYNAME = (NPPMSG + 43);
  //! `BOOL NPPM_MAKECURRENTBUFFERDIRTY(0, 0)`
  //! @br Make the current document dirty, i.e., set the current buffer state to "modified".
  //! @param wParam 0 (not used)
  //! @param lParam 0 (not used)
  //! @br@br Returns @true.
  NPPM_MAKECURRENTBUFFERDIRTY = (NPPMSG + 44);
  //! `THEMEAPI NPPM_GETENABLETHEMETEXTUREFUNC(0, 0)`
  //! @br Get the function address of `::EnableThemeDialogTexture()`.
  //! @param wParam 0 (not used)
  //! @param lParam 0 (not used)
  //! @br@br Returns a procedure address, or @nil.
  //! @note(Deprecated since [8.4.9](https://github.com/notepad-plus-plus/notepad-plus-plus/commit/50e95d22675b86b6afeacb6fdc217a0011f9528e).
  //!       Use [EnableThemeDialogTexture()](https://learn.microsoft.com/windows/win32/api/uxtheme/nf-uxtheme-enablethemedialogtexture) directly from `uxtheme.h` instead.)
  NPPM_GETENABLETHEMETEXTUREFUNC_DEPRECATED = (NPPMSG + 45);
  //! `int NPPM_GETPLUGINSCONFIGDIR(int strLen, wchar_t* str)`
  //! @br Get the user's plugin config directory path.
  //! @param strLen [in] buffer length of `str`
  //! @param str [out] the allocated buffer
  //! @br@br When `str` is @nil, returns the number of UTF-16 characters to copy; when `str` is an allocated buffer, returns @false on failure, @true on success.
  //! @note(Users should first call this API with `str` set to @nil to get the required number of UTF-16 characters
  //!       (not including the terminating @nil character), allocate the `str` buffer with the return value + 1, then
  //!       call it again to get the directory path.)
  NPPM_GETPLUGINSCONFIGDIR = (NPPMSG + 46);
  //! `BOOL NPPM_MSGTOPLUGIN(wchar_t* destModuleName, communicationInfo *info)`
  //! @br Send a private message to the plugin with the given `destModuleName`.
  //! For example, plugin X can execute a command of plugin Y if plugin X knows the command ID and the file name of plugin Y.
  //! @param destModuleName [in] the complete module file name of the destination plugin (including the ".dll" file extension)
  //! @param communicationInfo [in] pointer to a @link(TCommunicationInfo) structure
  //! @br@br Returns @true if Notepad++ found the plugin by its module name (`destModuleName`) and passed the info (via `communicationInfo`),.
  //! or @false if the destination plugin is not found.
  NPPM_MSGTOPLUGIN = (NPPMSG + 47);
  //! `BOOL NPPM_MENUCOMMAND(0, int cmdID)`
  //! @br Run the Notepad++ command with the given command ID.
  //! @param wParam 0 (not used)
  //! @param cmdID [in] see [menuCmdID.h](https://github.com/notepad-plus-plus/notepad-plus-plus/master/PowerEditor/src/menuCmdID.h) for all the Notepad++ menu command items
  //! @br@br Returns @true.
  NPPM_MENUCOMMAND = (NPPMSG + 48);
  //! `BOOL NPPM_TRIGGERTABBARCONTEXTMENU(int inView, int index2Activate)`
  //! @br Switch to the document in the given view with the given `index2Activate`, then open the context menu in it.
  //! @param inView [in] either @link(MAIN_VIEW) or @link(SUB_VIEW)
  //! @param index2Activate [in] the index (in the given view) of the document where the context menu will be triggered
  //! @br@br Returns @true.
  NPPM_TRIGGERTABBARCONTEXTMENU = (NPPMSG + 49);
  //! `int NPPM_GETNPPVERSION(BOOL ADD_ZERO_PADDING, 0)`
  //! @br Get the version of the currently running edition of Notepad++.
  //! @param(ADD_ZERO_PADDING [in] *Since [8.4.1](https://github.com/notepad-plus-plus/notepad-plus-plus/commit/ef609c8):*
  //!        Whether or not to ensure that `100 >= LOWORD(version) <= 999`.)
  //! @param lParam 0 (not used)
  //! @br@br Return value:
  //! @longCode(
  //!     major_version_number := HIWORD(returned_value); // 1st digit of the version
  //!     minor_version_number := LOWORD(returned_value); // last 3 digits of the version
  //!
  //!     {  Examples:
  //!
  //!        ADD_ZERO_PADDING := True
  //!
  //!        version  | HIWORD | LOWORD
  //!        -----------------------------
  //!        8.9.6.4  | 8      | 964
  //!        9        | 9      | 0
  //!        6.9      | 6      | 900
  //!        6.6.6    | 6      | 660
  //!        13.6.6.6 | 13     | 666
  //!
  //!        ADD_ZERO_PADDING := False
  //!
  //!        version  | HIWORD | LOWORD
  //!        -----------------------------
  //!        8.9.6.4  | 8      | 964
  //!        9        | 9      | 0
  //!        6.9      | 6      | 9
  //!        6.6.6    | 6      | 66
  //!        13.6.6.6 | 13     | 666
  //!      })
  NPPM_GETNPPVERSION = (NPPMSG + 50);
  //! `BOOL NPPM_HIDETABBAR(0, BOOL hideOrNot)`
  //! @br Hide (or show) the tab bar.
  //! @param wParam 0 (not used)
  //! @param hideOrNot [in] if @true the tab bar will be hidden, otherwise it will be shown
  //! @br@br Returns the old status value.
  NPPM_HIDETABBAR = (NPPMSG + 51);
  //! `BOOL NPPM_ISTABBARHIDDEN(0, 0)`
  //! @br Get the visibility (hidden or visible) of the tab bar.
  //! @param wParam 0 (not used)
  //! @param lParam 0 (not used)
  //! @br@br Returns @true if the toolbar is hidden, otherwise @false.
  NPPM_ISTABBARHIDDEN = (NPPMSG + 52);
  //! `int NPPM_GETPOSFROMBUFFERID(UINT_PTR bufferID, int priorityView)`
  //! @br Get the position of the document with `bufferID`, searching in `priorityView` first.
  //! @param bufferID [in] buffer ID of the document
  //! @param(priorityView [in] the target view. If `bufferID` cannot be found in the target view, the other view will be searched.
  //!        If set to @link(SUB_VIEW), the sub view will be searched first.)
  //! @br@br Returns -1 if no document with `bufferID` exists, otherwise `(VIEW << 30) | INDEX`,.
  //! where `VIEW` is either @link(MAIN_VIEW) or @link(SUB_VIEW), and `INDEX` is the 0-based document index.
  NPPM_GETPOSFROMBUFFERID = (NPPMSG + 57);
  //! `int NPPM_GETFULLPATHFROMBUFFERID(UINT_PTR bufferID, wchar_t* fullFilePath)`
  //! @br Get the full file path of the document with the given `bufferID`.
  //! @param bufferID [in] buffer ID of the document
  //! @param(fullFilePath [out] The user should first call this function with `fullFilePath` @nil to get the number of UTF-16 characters
  //!        (not including the @nil character), then allocate `fullFilePath` with the return value + 1, then call it again to get the file path.)
  //! @br@br Returns -1 if no document with `bufferID` exists, otherwise the number of UTF-16 characters copied/to copy.
  NPPM_GETFULLPATHFROMBUFFERID = (NPPMSG + 58);
  //! `UINT_PTR NPPM_GETBUFFERIDFROMPOS(int index, int inView)`
  //! @br Get the buffer ID of the document in the given view with the given `index`.
  //! @param index [in] 0-based index of the document
  //! @param inView [in] view containing the document, either @link(MAIN_VIEW) or @link(SUB_VIEW)
  //! @br@br Returns @nil if invalid, otherwise the buffer ID of the document.
  NPPM_GETBUFFERIDFROMPOS = (NPPMSG + 59);
  //! `UINT_PTR NPPM_GETCURRENTBUFFERID(0, 0)`
  //! @br Get the active document's buffer ID.
  //! @param wParam 0 (not used)
  //! @param lParam 0 (not used)
  //! @br@br Returns the buffer ID of the active document.
  NPPM_GETCURRENTBUFFERID = (NPPMSG + 60);
  //! `BOOL NPPM_RELOADBUFFERID(UINT_PTR bufferID, BOOL alert)`
  //! @br Reload the document with the given `bufferID`.
  //! @param bufferID [in] buffer ID of the document to reload
  //! @param alert [in] @true to let the user confirm or reject the reload, or @false to reload with no alert
  //! @br@br Returns @true on success, @false otherwise.
  NPPM_RELOADBUFFERID = (NPPMSG + 61);
  //! `int NPPM_GETBUFFERLANGTYPE(UINT_PTR bufferID, 0)`
  //! @br Get the @link(TNppLang) associated with the document matching the given `bufferID`.
  //! @param bufferID [in] buffer ID of the document to get the language type from
  //! @param lParam 0 (not used)
  //! @br@br Returns a @link(TNppLang) value, or -1 on error.
  NPPM_GETBUFFERLANGTYPE = (NPPMSG + 64);
  //! `BOOL NPPM_SETBUFFERLANGTYPE(UINT_PTR bufferID, int langType)`
  //! @br Set the @link(TNppLang) associated with the document matching the given `bufferID`.
  //! @param bufferID [in] buffer ID of the document
  //! @param langType [in] a @link(TNppLang) value
  //! @br@br Returns @true on success, @false otherwise
  //! @note The `langType` parameter cannot be @link(TNppLang.L_USER) or @link(TNppLang.L_EXTERNAL).
  NPPM_SETBUFFERLANGTYPE = (NPPMSG + 65);
  //! `int NPPM_GETBUFFERENCODING(UINT_PTR bufferID, 0)`
  //! @br Get the encoding of the document with the given `bufferID`.
  //! @param bufferID [in] buffer ID of the document
  //! @param lParam 0 (not used)
  //! @br@br Returns -1 on error, otherwise UniMode, with the following value:.
  //! @orderedList(
  //!   @itemSpacing Compact
  //!   @itemSetNumber 0
  //!   @item ANSI
  //!   @item UTF-8 with BOM
  //!   @item UTF-16 Big Ending with BOM
  //!   @item UTF-16 Little Ending with BOM
  //!   @item UTF-8 without BOM
  //!   @item uni7Bit
  //!   @item UTF-16 Big Ending without BOM
  //!   @item UTF-16 Little Ending without BOM
  //!)
  NPPM_GETBUFFERENCODING = (NPPMSG + 66);
  //! `BOOL NPPM_SETBUFFERENCODING(UINT_PTR bufferID, int encoding)`
  //! @br Set the encoding of the document with the given `bufferID`.
  //! @param bufferID [in] buffer ID of the document
  //! @param encoding [in] one of the UniMode values returned by @link(NPPM_GETBUFFERENCODING)
  //! @br@br Returns @true on success, @false otherwise.
  //! @note Can only be called on new, unedited files.
  NPPM_SETBUFFERENCODING = (NPPMSG + 67);
  //! `int NPPM_GETBUFFERFORMAT(UINT_PTR bufferID, 0)`
  //! @br Get the EOL format of the document with the given `bufferID`.
  //! @param bufferID [in] buffer ID of the document
  //! @param lParam 0 (not used)
  //! @br@br Returns -1 on error, otherwise one of the following EOL formats:.
  //! @orderedList(
  //!   @itemSpacing Compact
  //!   @itemSetNumber 0
  //!   @item Windows (CRLF)
  //!   @item Macos (CR)
  //!   @item Unix (LF)
  //!   @item Unknown
  //!)
  NPPM_GETBUFFERFORMAT = (NPPMSG + 68);
  //! `BOOL NPPM_SETBUFFERFORMAT(UINT_PTR bufferID, int format)`
  //! @br Set the EOL format of the document with the given `bufferID`.
  //! @param bufferID [in] buffer ID of the document
  //! @param format[in] one of the EOL formats returned by @link(NPPM_GETBUFFERFORMAT)
  //! @br@br Returns @true on success, @false otherwise.
  NPPM_SETBUFFERFORMAT = (NPPMSG + 69);
  //! `BOOL NPPM_HIDETOOLBAR(0, BOOL hideOrNot)`
  //! @br Hide (or show) the toolbar.
  //! @param wParam 0 (not used)
  //! @param hideOrNot [in] if @true the toolbar will be hidden, otherwise it will be shown
  //! @br@br Returns the old status value.
  NPPM_HIDETOOLBAR = (NPPMSG + 70);
  //! `BOOL NPPM_ISTOOLBARHIDDEN(0, 0)`
  //! @br Get the visibility (hidden or visible) of the toolbar.
  //! @param wParam 0 (not used)
  //! @param lParam 0 (not used)
  //! @br@br Returns @true if the toolbar is hidden, otherwise @false.
  NPPM_ISTOOLBARHIDDEN = (NPPMSG + 71);
  //! `BOOL NPPM_HIDEMENU(0, BOOL hideOrNot)`
  //! @br Hide (or show) the menu bar.
  //! @param wParam 0 (not used)
  //! @param hideOrNot [in] if @true the menu will be hidden, otherwise it will be shown
  //! @br@br Returns the old status value.
  NPPM_HIDEMENU = (NPPMSG + 72);
  //! `BOOL NPPM_ISMENUHIDDEN(0, 0)`
  //! @br Get the visibility (hidden or visible) of the menu bar.
  //! @param wParam 0 (not used)
  //! @param lParam 0 (not used)
  //! @br@br Returns @true if the menu bar is hidden, otherwise @false.
  NPPM_ISMENUHIDDEN = (NPPMSG + 73);
  //! `BOOL NPPM_HIDESTATUSBAR(0, BOOL hideOrNot)`
  //! @br Hide (or show) the status bar.
  //! @param wParam 0 (not used)
  //! @param hideOrNot [in] if @true the status bar will be hidden, otherwise it will be shown
  //! @br@br Returns the old status value.
  NPPM_HIDESTATUSBAR = (NPPMSG + 74);
  //! `BOOL NPPM_ISSTATUSBARHIDDEN(0, 0)`
  //! @br Get the visibility (hidden or visible) of the status bar.
  //! @param wParam 0 (not used)
  //! @param lParam 0 (not used)
  //! @br@br Returns @true if the status bar is hidden, otherwise @false.
  NPPM_ISSTATUSBARHIDDEN = (NPPMSG + 75);
  //! `BOOL NPPM_GETSHORTCUTBYCMDID(int cmdID, ShortcutKey* sk)`
  //! @br Get the shortcut mapped to the plugin command with the given `cmdID`.
  //! @param cmdID [in] plugin command ID
  //! @param sk [out] pre-allocated pointer to a @link(TShortcutKey)
  //! @br@br Returns @true if the shortcut has been enabled, otherwise @false.
  //! @note Call this *after* the @link(NPPN_READY) notification has been sent.
  NPPM_GETSHORTCUTBYCMDID = (NPPMSG + 76);
  //! `BOOL NPPM_DOOPEN(0, const wchar_t* fullPathName2Open)`
  //! @br Open the file with the given `fullPathName2Open`.
  //! If it is already open in Notepad++, it will be activated and become the current document.
  //! @param wParam 0 (not used)
  //! @param fullPathName2Open [in] full path name of the file to be opened
  //! @br@br Returns @true if the operation is successful, otherwise @false.
  NPPM_DOOPEN = (NPPMSG + 77);
  //! `BOOL NPPM_SAVECURRENTFILEAS (BOOL saveAsCopy, const wchar_t* filename)`
  //! @br Save the currently active document with the given `filename` and, optionally, save a copy under the current file name.
  //! @param saveAsCopy [in] @false to rename the current file, or @true to save a copy of it (like the "Save a Copy As..." action)
  //! @param filename [in] full path name of the file to be saved
  //! @br@br Returns @true if the operation is successful, otherwise @false.
  NPPM_SAVECURRENTFILEAS = (NPPMSG + 78);
  //! `int NPPM_GETCURRENTNATIVELANGENCODING(0, 0)`
  //! @br Get the code page associated with the current localization of Notepad++.
  //! @param wParam 0 (not used)
  //! @param lParam 0 (not used)
  //! @br@br Returns the [code page identifier](https://learn.microsoft.com/windows/win32/intl/code-page-identifiers) of the current native language encoding.
  NPPM_GETCURRENTNATIVELANGENCODING = (NPPMSG + 79);
  //! `BOOL NPPM_ALLOCATESUPPORTED_DEPRECATED(0, 0)`
  //! @br Get the status of support for the @link(NPPM_ALLOCATECMDID) API.
  //! @param wParam 0 (not used)
  //! @param lParam 0 (not used)
  //! @note(Used to identify if subclassing is necessary. This message was added (in 2010) only for checking if
  //!       NPPM_ALLOCATECMDID was supported; it is no longer needed.)
  //! Returns @true if NPPM_ALLOCATECMDID is supported
  NPPM_ALLOCATESUPPORTED_DEPRECATED = (NPPMSG + 80);
  //! See @link(NPPM_ALLOCATESUPPORTED_DEPRECATED)
  NPPM_ALLOCATESUPPORTED = NPPM_ALLOCATESUPPORTED_DEPRECATED deprecated;
  //! `BOOL NPPM_ALLOCATECMDID(int numberRequested, int* startNumber)`
  //! @br Allocate a consecutive number of menu item IDs for a plugin.
  //! @note The obtained menu IDs are guaranteed not to conflict with other plugins.
  //! @param numberRequested [in] the number of IDs requested for reservation
  //! @param startNumber [out] will be set to the initial command ID if successful
  //! For example, if a plugin needs 4 menu item IDs, the following code can be used:
  //! @longCode(
  //!   uses NppPlugin { , ... };
  //!   // ...
  //!   var
  //!     idBegin: IntPtr;
  //!     isAllocatedSuccessful: LongBool;
  //!   begin
  //!     isAllocatedSuccessful := Self.SendNppMessage(NPPM_ALLOCATECMDID, 4, @idBegin);
  //!     // ...
  //!   end;
  //! )
  //! If `isAllocatedSuccessful` is TRUE, and the value of `idBegin` is 46581,
  //! then menu item IDs 46581, 46582, 46583 and 46584 are reserved by Notepad++, and they are safe to be used by the plugin.
  //! @br@br Returns @true if successful, @false otherwise; `startNumber` will also be set to 0 if unsuccessful.
  NPPM_ALLOCATECMDID = (NPPMSG + 81);
  //! `BOOL NPPM_ALLOCATEMARKER(int numberRequested, int* startNumber)`
  //! @br Allocate a consecutive number of marker IDs for a plugin.
  //! @note(If a plugin needs to add a marker on Notepad++'s Scintilla marker margin,
  //!       it should reserve it using this API, in order to prevent a conflict with other plugins.)
  //! @param numberRequested [in] the number of IDs requested for reservation
  //! @param startNumber [out] will be set to the initial command ID if successful
  //! For example, if a plugin needs 3 marker IDs, the following code can be used:
  //! @longCode(
  //!   uses NppPlugin { , ... };
  //!   // ...
  //!   var
  //!     idBegin: IntPtr;
  //!     isAllocatedSuccessful: LongBool;
  //!   BEGIN
  //!     isAllocatedSuccessful := Self.SendNppMessage(NPPM_ALLOCATEMARKER, 3, @idBegin);
  //!     // ...
  //!   END;
  //! )
  //! If `isAllocatedSuccessful` is @true, and the value of `idBegin` is 16,
  //! then marker IDs 16, 17 and 18 are reserved by Notepad++, and they are safe to be used by the plugin.
  //! @br@br Returns @true if successful, @false otherwise; `startNumber` will also be set to 0 if unsuccessful.
  NPPM_ALLOCATEMARKER = (NPPMSG + 82);
  //! `int NPPM_GETLANGUAGENAME(int langType, wchar_t* langName)`
  //! @br Get the name of the programming language associated with the given `langType`.
  //! @param langType [in] a @link(TNppLang) value
  //! @param langName [out] the allocated language name buffer
  //! @br@br Returns the number of UTF-16 characters copied/to copy.
  //! @note(Users should first call this API with `langName` set to @nil to get the required number of UTF-16 characters
  //!       (not including the terminating @nil character), allocate the `langName` buffer with the return value + 1, then
  //!       call it again to get the language name.)
  NPPM_GETLANGUAGENAME = (NPPMSG + 83);
  //! `int NPPM_GETLANGUAGEDESC(int langType, wchar_t* langDesc)`
  //! @br Get a short description of the programming language with the given `langType`.
  //! @param langType [in] a @link(TNppLang) value
  //! @param langDesc [out] the allocated language description buffer
  //! @br@br Returns the number of UTF-16 characters copied/to copy.
  //! @note(Users should first call this API with `langDesc` set to @nil to get the required number of UTF-16 characters
  //!       (not including the terminating @nil character), allocate the `langDesc` buffer with the return value + 1, then
  //!       call it again to get the description text.)
  NPPM_GETLANGUAGEDESC = (NPPMSG + 84);
  //! `BOOL NPPM_SHOWDOCLIST(0, BOOL toShowOrNot)`
  //! @br Show or hide the Document List panel.
  //! @param wParam 0 (not used)
  //! @param toShowOrNot [in] if @true, the Document List panel is shown, otherwise it is hidden
  //! @br@br Returns @true.
  NPPM_SHOWDOCLIST = (NPPMSG + 85);
  //! `BOOL NPPM_ISDOCLISTSHOWN(0, 0)`
  //! @br Get the visibility (hidden or visible) of the Document List panel.
  //! @param wParam 0 (not used)
  //! @param lParam 0 (not used)
  //! @br@br Returns @true if the Document List panel is currently shown, @false otherwise.
  NPPM_ISDOCLISTSHOWN = (NPPMSG + 86);
  //! `BOOL NPPM_GETAPPDATAPLUGINSALLOWED(0, 0)`
  //! @br Check to see if loading plugins from `"%APPDATA%\..\Local\Notepad++\plugins"` is allowed.
  //! @param wParam 0 (not used)
  //! @param lParam 0 (not used)
  //! @br@br Returns @true if loading plugins from `%APPDATA%` is allowed, @false otherwise.
  NPPM_GETAPPDATAPLUGINSALLOWED = (NPPMSG + 87);
  //! `int NPPM_GETCURRENTVIEW(0, 0)`
  //! @br Get the currently active view.
  //! @param wParam 0 (not used)
  //! @param lParam 0 (not used)
  //! @br@br Returns the current edit view of Notepad++: either @link(MAIN_VIEW) @link(SUB_VIEW).
  NPPM_GETCURRENTVIEW = (NPPMSG + 88);
  //! `BOOL NPPM_DOCLISTDISABLEEXTCOLUMN(0, BOOL disableOrNot)`
  //! @br Disable or enable the file extension column of the Document List.
  //! @param wParam 0 (not used)
  //! @param disableOrNot [in] if @true, the extension column is hidden, otherwise it is shown
  //! @br@br Returns @true.
  NPPM_DOCLISTDISABLEEXTCOLUMN = (NPPMSG + 89);
  //! `BOOL NPPM_DOCLISTDISABLEPATHCOLUMN(0, BOOL disableOrNot)`
  //! @br Disable or enable the path column of the Document List.
  //! @param wParam 0 (not used)
  //! @param disableOrNot [in] if @true, the path column is hidden, otherwise it is shown
  //! @br@br Returns @true.
  NPPM_DOCLISTDISABLEPATHCOLUMN = (NPPMSG + 102);
  //! `int NPPM_GETEDITORDEFAULTFOREGROUNDCOLOR(0, 0)`
  //! @br Get the editor's current default foreground color.
  //! @param wParam 0 (not used)
  //! @param lParam 0 (not used)
  //! @br@br Returns the color as an integer in hex format @code($00bbggrr).
  NPPM_GETEDITORDEFAULTFOREGROUNDCOLOR = (NPPMSG + 90);
  //! `int NPPM_GETEDITORDEFAULTBACKGROUNDCOLOR(0, 0)`
  //! @br Get the editor's current default background color.
  //! @param wParam 0 (not used)
  //! @param lParam 0 (not used)
  //! @br@br Returns the color as an integer in hex format @code($00bbggrr).
  NPPM_GETEDITORDEFAULTBACKGROUNDCOLOR = (NPPMSG + 91);
  //! `BOOL NPPM_SETSMOOTHFONT(0, BOOL setSmoothFontOrNot)`
  //! @br Enable or disable "smooth fonts" (i.e., [ClearType Antialiasing](https://learn.microsoft.com/windows/win32/gdi/cleartype-antialiasing)).
  //! This API simply sends the @link(SCI_SETFONTQUALITY) message to Scintilla with an equivalent font quality setting.
  //! @param wParam 0 (not used)
  //! @param setSmoothFontOrNot [in] @true to send @link(SCI_SETFONTQUALITY) with @link(SC_EFF_QUALITY_LCD_OPTIMIZED), or @false to send it with @link(SC_EFF_QUALITY_DEFAULT)
  //! @br@br Returns @true.
  NPPM_SETSMOOTHFONT = (NPPMSG + 92);
  //! `BOOL NPPM_SETEDITORBORDEREDGE(0, BOOL withEditorBorderEdgeOrNot)`
  //! @br Add or remove an additional sunken edge style to the Scintilla window.
  //! @param wParam 0 (not used)
  //! @param withEditorBorderEdgeOrNot [in] @true to add a border edge to the Scintilla window, @false to remove it
  //! @br@br Returns @true.
  NPPM_SETEDITORBORDEREDGE = (NPPMSG + 93);
  //! `BOOL NPPM_SAVEFILE(0, const wchar_t* fileNameToSave)`
  //! @br Save the (currently open) file with the given `fileNameToSave`.
  //! @param wParam 0 (not used)
  //! @param fileNameToSave [in] the full path of the file to be saved
  //! @br@br Returns @true on success, @false on fileNameToSave is not found.
  NPPM_SAVEFILE = (NPPMSG + 94);
  //! `BOOL NPPM_DISABLEAUTOUPDATE(0, 0)`
  //! @br Disable automatic updates of Notepad++.
  //! @param wParam 0 (not used)
  //! @param lParam 0 (not used)
  //! @br@br Returns @true.
  NPPM_DISABLEAUTOUPDATE = (NPPMSG + 95); { 2119 in decimal }
  //! `BOOL NPPM_REMOVESHORTCUTBYCMDID(int pluginCmdID, 0)`
  //! @br Remove a shortcut that was mapped to the plugin command with the given ID.
  //! @param pluginCmdID [in] the ID of a plugin command
  //! @param lParam 0 (not used)
  //! @br@br Returns @true if successful, otherwise @false.
  NPPM_REMOVESHORTCUTBYCMDID = (NPPMSG + 96); { 2120 in decimal }
  //! `int NPPM_GETPLUGINHOMEPATH(size_t strLen, wchar_t* pluginRootPath)`
  //! @br Get the root path of all the installed Notepad++ plugins.
  //! For example, the full path to a plugin's installation folder would be: `<pluginRootPath>\<pluginFolderName>`,
  //! where `<pluginFolderName>` is the name of the plugin without the ".dll" file extension.
  //! @param strLen [in] buffer length of `pluginRootPath`
  //! @param pluginRootPath [out] the allocated buffer
  //! @br@br Returns the number of UTF-16 characters copied/to copy, or 0 on failure.
  //! @note(Users should first call this API with `pluginRootPath` set to @nil to get the required number of UTF-16 characters
  //!       (not including the terminating @nil character), allocate the `pluginRootPath` buffer with the return value + 1, then
  //!       call it again to get the directory path.)
  NPPM_GETPLUGINHOMEPATH = (NPPMSG + 97);
  //! `int NPPM_GETSETTINGSONCLOUDPATH(size_t strLen, wchar_t* settingsOnCloudPath)`
  //! @br Get the user's cloud settings file path.
  //! @param strLen [in] buffer length of `settingsOnCloudPath`
  //! @param settingsOnCloudPath[out] the allocated file path buffer
  //! @br@br Returns the number of UTF-16 characters copied/to copy.
  //! The return value is 0 if this path is not set, or if `strLen` is not enough to copy the path
  //! @note(Users should first call this API with `settingsOnCloudPath` set to @nil to get the required number of UTF-16 characters
  //!       (not including the terminating @nil character), allocate the `settingsOnCloudPath` buffer with the return value + 1, then
  //!       call it again to get the file path.)
  NPPM_GETSETTINGSONCLOUDPATH = (NPPMSG + 98);
  //! `BOOL NPPM_SETLINENUMBERWIDTHMODE(0, int widthMode)`
  //! @br Set the line number margin width mode to "dynamic" (@link(LINENUMWIDTH_DYNAMIC)) or "constant" (@link(LINENUMWIDTH_CONSTANT)).
  //! @note Plugins should disable constant width mode to ensure a smoother visual effect during vertical content scrolling.
  //! @param wParam 0 (not used)
  //! @param widthMode [in] either @link(LINENUMWIDTH_DYNAMIC) or @link(LINENUMWIDTH_CONSTANT)
  //! Returns @true if successful, otherwise return @false
  NPPM_SETLINENUMBERWIDTHMODE = (NPPMSG + 99);
  LINENUMWIDTH_DYNAMIC     = 0;
  LINENUMWIDTH_CONSTANT    = 1;
  //! `int NPPM_GETLINENUMBERWIDTHMODE(0, 0)`
  //! @br Get the current line number margin width mode.
  //! @param wParam 0 (not used)
  //! @param lParam 0 (not used)
  //! @br@br Returns the current line number margin width mode: either @link(LINENUMWIDTH_DYNAMIC) or @link(LINENUMWIDTH_CONSTANT).
  NPPM_GETLINENUMBERWIDTHMODE = (NPPMSG + 100);
  //! `BOOL NPPM_ADDTOOLBARICON_FORDARKMODE(UINT pluginCmdID, toolbarIconsWithDarkMode* iconHandles)`
  //! @param pluginCmdID [in] the plugin command ID corresponding to the toolbar item whose icon will be set; see @link(_TFuncItem.CmdID)
  //! @br Add an icon with a dark mode variant to the toolbar.
  //! @param iconHandles [in] a pointer to a @link(TTbIconsDarkMode) structure
  //! @br@br Returns @true.
  //! @br@br Added in [8.0](https://community.notepad-plus-plus.org/topic/21652)
  NPPM_ADDTOOLBARICON_FORDARKMODE = (NPPMSG + 101);
  //! `BOOL NPPM_GETEXTERNALLEXERAUTOINDENTMODE(const wchar_t* languageName, ExternalLexerAutoIndentMode* autoIndentMode)`
  //! @br Get the @link(TExternalLexerAutoIndentMode) of the external lexer identified by `languageName`.
  //! @param languageName [in] name of an external lexer provided by a plugin
  //! @param autoIndentMode [out] see @link(NPPM_SETEXTERNALLEXERAUTOINDENTMODE)
  //! @br@br Returns @true on success, otherwise @false.
  //! @br@br Added in [8.3.3](https://github.com/notepad-plus-plus/notepad-plus-plus/commit/9cbd03c)
  NPPM_GETEXTERNALLEXERAUTOINDENTMODE = (NPPMSG + 103);
  //! `BOOL NPPM_SETEXTERNALLEXERAUTOINDENTMODE(const wchar_t* languageName, ExternalLexerAutoIndentMode autoIndentMode)`
  //! @br Set the @link(TExternalLexerAutoIndentMode) of the external lexer identified by `languageName`.
  //! @param languageName [in] name of an external lexer provided by a plugin
  //! @param(autoIndentMode [in] one of the following three values:
  //!   @unorderedList(
  //!   @itemSpacing Compact
  //!   @item @link(TExternalLexerAutoIndentMode.Standard) -- Notepad++ will keep the same TAB indentation between lines
  //!   @item @link(TExternalLexerAutoIndentMode.C_Like) -- Notepad++ will perform a C-Language style indentation for the selected external language
  //!   @item @link(TExternalLexerAutoIndentMode.Custom) -- a Plugin will be controlling auto-indentation for the current language)
  //! )
  //! @br@br Returns @true on success, otherwise @false.
  //! @br@br Added in [8.3.3](https://github.com/notepad-plus-plus/notepad-plus-plus/commit/9cbd03c)
  NPPM_SETEXTERNALLEXERAUTOINDENTMODE = (NPPMSG + 104);
  //! `BOOL NPPM_ISAUTOINDENTON(0, 0)`
  //! @br Get the current state of the "Use Auto-Indentation" setting.
  //! @param wParam 0 (not used)
  //! @param lParam 0 (not used)
  //! @br@br Returns @true if Auto-Indentation is on, @false otherwise.
  //! @br@br Added in [8.3.3](https://github.com/notepad-plus-plus/notepad-plus-plus/commit/9cbd03c)
  NPPM_ISAUTOINDENTON = (NPPMSG + 105);
  //! `MacroStatus NPPM_GETCURRENTMACROSTATUS(0, 0)`
  //! @br Get the current @link(TMacroStatus).
  //! @param wParam 0 (not used)
  //! @param lParam 0 (not used)
  //! @br@br Returns a @link(TMacroStatus) value:.
  //!   @unorderedList(
  //!   @itemSpacing Compact
  //!   @item @link(TMacroStatus.Idle) -- macro is not in use and it's empty
  //!   @item @link(TMacroStatus.RecordInProgress) -- macro is currently being recorded
  //!   @item @link(TMacroStatus.RecordingStopped) -- macro recording has been stopped
  //!   @item @link(TMacroStatus.PlayingBack) -- macro is currently being played back
  //! )
  //! Added in [8.3.3](https://github.com/notepad-plus-plus/notepad-plus-plus/commit/9cbd03c)
  NPPM_GETCURRENTMACROSTATUS = (NPPMSG + 106);
  //! `BOOL NPPM_ISDARKMODEENABLED(0, 0)`
  //! @br Get the current status (ON or OFF) of the dark mode setting.
  //! @param wParam 0 (not used)
  //! @param lParam 0 (not used)
  //! @br@br Returns @true if dark mode is enabled, otherwise @false.
  //! @br@br Added in [8.4.1](https://github.com/notepad-plus-plus/notepad-plus-plus/commit/1eb5b10)
  NPPM_ISDARKMODEENABLED = (NPPMSG + 107);
  //! `BOOL NPPM_GETDARKMODECOLORS (size_t cbSize, NppDarkMode::Colors* returnColors)`
  //! @br Get the color values of the active dark mode theme.
  //! @param cbSize [in] must be equal to `sizeof(TDarkModeColors)`
  //! @param returnColors [out] a pointer to a @link(TDarkModeColors) structure
  //! @br@br Returns @true when successful, @false otherwise.
  //! @note(If calling this API fails (i.e., @false is returned), you may need to change the @link(TDarkModeColors) structure as shown
  //!       [here](https://github.com/notepad-plus-plus/notepad-plus-plus/blob/master/PowerEditor/src/NppDarkMode.h#L25).)
  //! Added in [8.4.1](https://github.com/notepad-plus-plus/notepad-plus-plus/commit/1eb5b10)
  NPPM_GETDARKMODECOLORS = (NPPMSG + 108);
  //! `int NPPM_GETCURRENTCMDLINE(size_t strLen, wchar_t* commandLineStr)`
  //! @br Get the current command line string.
  //! @param strLen [in] buffer length of `commandLineStr`
  //! @param commandLineStr [out] allocated command line string buffer
  //! @br@br Returns the number of UTF-16 characters copied/to copy.
  //! @note(Users should first call this API with `commandLineStr` set to @nil to get the required number of UTF-16 characters
  //!       (not including the terminating @nil character), allocate the `commandLineStr` buffer with the value + 1, then call it
  //!        again to get the current command line string.)
  //! Added in [8.4.2](https://github.com/notepad-plus-plus/notepad-plus-plus/commit/0f8d572)
  NPPM_GETCURRENTCMDLINE = (NPPMSG + 109);
  //! `void* NPPM_CREATELEXER(0, const wchar_t* lexer_name)`
  //! @br Get an `ILexer` pointer created by Lexilla. This calls lexilla's `CreateLexer()` function so that plugins can
  //! set the lexer for a Scintilla instance created by @link(NPPM_CREATESCINTILLAHANDLE).
  //! @param wParam 0 (not used)
  //! @param lexer_name [in] the name of the lexer
  //! @br@br Returns the `ILexer` pointer.
  //! @br@br Added in [8.4.3](https://github.com/notepad-plus-plus/notepad-plus-plus/commit/f1ed4de)
  NPPM_CREATELEXER = (NPPMSG + 110);
  //! `int NPPM_GETBOOKMARKID(0, 0)`
  //! @br Get a stable bookmark ID.
  //! @param wParam 0 (not used)
  //! @param lParam 0 (not used)
  //! @br@br Returns the bookmark ID.
  //! @note This API guarantees you always get the right bookmark ID even if it's been changed by a newer version of Notepad++.
  //! Added in [8.4.7](https://github.com/notepad-plus-plus/notepad-plus-plus/commit/4d50692)
  NPPM_GETBOOKMARKID = (NPPMSG + 111);
  //! `ULONG NPPM_DARKMODESUBCLASSANDTHEME(ULONG dmFlags, HWND hwnd)`
  //! @br Make the plugin dialog with the given handle participate in automatic dark mode theming.
  //! Subclassing will be applied automatically unless the @link(NppDockingForms.DWS_USEOWNDARKMODE) flag is used.
  //! @param dmFlags [in] either @link(dmfInit) or @link(dmfHandleChange)
  //! @param hwnd [in] the dialog handle of the plugin
  //! @br@br Returns the combination of `dmFlags`, if successful.
  // Examples:
  //
  // - after controls initializations in WM_INITDIALOG, in WM_CREATE or after CreateWindow:
  //
  // auto success = static_cast<ULONG>(::SendMessage(nppData._nppHandle, NPPM_DARKMODESUBCLASSANDTHEME, static_cast<WPARAM>(NppDarkMode::dmfInit), reinterpret_cast<LPARAM>(mainHwnd)));
  //
  // - handling dark mode change:
  //
  // extern "C" __declspec(dllexport) void beNotified(SCNotification * notifyCode)
  // {
  // 	switch (notifyCode->nmhdr.code)
  // 	{
  // 		case NPPN_DARKMODECHANGED:
  // 		{
  // 			::SendMessage(nppData._nppHandle, NPPM_DARKMODESUBCLASSANDTHEME, static_cast<WPARAM>(dmfHandleChange), reinterpret_cast<LPARAM>(mainHwnd));
  // 			::SetWindowPos(mainHwnd, nullptr, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE | SWP_NOZORDER | SWP_FRAMECHANGED); // to redraw titlebar and window
  // 			break;
  // 		}
  // 	}
  // }
  //! @note Docking panels are always automatically subclassed and do not need to call this API.
  //! Added in [8.5.4](https://github.com/notepad-plus-plus/notepad-plus-plus/commit/e7f321f)
  NPPM_DARKMODESUBCLASSANDTHEME = (NPPMSG + 112);
  //! `BOOL NPPM_ALLOCATEINDICATOR(int numberRequested, int* startNumber)`
  //! @br Allocates an indicator number for a plugin.
  //! @param numberRequested [in] the ID number requested for reservation
  //! @param startNumber [out] will be set to the initial command ID, if successful
  //! For example, if a plugin needs 1 indicator ID, the following code can be used:
  //! @longCode(
  //!   uses NppPlugin { , ... };
  //!   // ...
  //!   var
  //!     idBegin: IntPtr;
  //!     isAllocatedSuccessful: LongBool;
  //!   begin
  //!     isAllocatedSuccessful := Self.SendNppMessage(NPPM_ALLOCATEINDICATOR, 1, @idBegin);
  //!     // ...
  //!   end;
  //! )
  //! If `isAllocatedSuccessful` is @true, and the value of `idBegin` is 7,
  //! then indicator ID 7 is reserved by Notepad++, and it is safe to be used by the plugin.
  //! @br@br Returns @true if successful, @false otherwise; `startNumber` will also be set to 0 if unsuccessful.
  //! @note If a plugin needs to add an indicator, it should reserve it using this API, in order to prevent a conflict with other plugins.
  //! Added in [8.5.6](https://github.com/notepad-plus-plus/notepad-plus-plus/commit/de25873)
  NPPM_ALLOCATEINDICATOR = (NPPMSG + 113);
  //! `int NPPM_GETTABCOLORID (int view, int tabIndex)`
  //! @br Get the color ID of the tab in the given view with the given tab index.
  //! @param view [in] 0 (@link(MAIN_VIEW)), 1 (@link(SUB_VIEW)), or -1 for the currently active view
  //! @param tabIndex [in] 0-based tab index, i.e., 0 for the first tab, 1 for the second tab, etc., or -1 for the currently active tab
  //! @br@br Returns the tab color's id value, which is one of:.
  //! @orderedList(
  //!   @itemSpacing Compact
  //!   @itemSetNumber -1
  //!   @item (no color)
  //!   @item (yellow)
  //!   @item (green)
  //!   @item (blue)
  //!   @item (orange)
  //!   @item (pink)
  //!)
  //! @note(There is no matching "NPPM_SETTABCOLORID" API for setting the tab color.
  //!       Plugins can instead use @link(NPPM_MENUCOMMAND) to set the active tab's color using the following menu command IDs:)
  //! @orderedList(
  //!   @itemSpacing Compact
  //!   @itemSetNumber 44110
  //!   @item `IDM_VIEW_TAB_COLOUR_NONE` (no color)
  //!   @item `IDM_VIEW_TAB_COLOUR_1` (yellow)
  //!   @item `IDM_VIEW_TAB_COLOUR_2` (green)
  //!   @item `IDM_VIEW_TAB_COLOUR_3` (blue)
  //!   @item `IDM_VIEW_TAB_COLOUR_4` (orange)
  //!   @item `IDM_VIEW_TAB_COLOUR_5` (pink)
  //!)
  //! Added in [8.6.8](https://github.com/notepad-plus-plus/notepad-plus-plus/commit/9244cd0)
  NPPM_GETTABCOLORID = (NPPMSG + 114);
  //! `BOOL NPPM_SETUNTITLEDNAME(BufferID id, const wchar_t* newName)`
  //! @br Set the name of the untitled tab with the given `bufferID`.
  //! @param id [in] buffer ID of the untitled tab
  //! @param newName [in] the desired new name of the tab
  //! @br@br Returns @true on success, @false otherwise.
  //! @br@br Added in [8.6.9](https://github.com/notepad-plus-plus/notepad-plus-plus/commit/b3daf0a98220ffc6e206133aa645d5a2d1d63a4f)
  NPPM_SETUNTITLEDNAME = (NPPMSG + 115);
  //! `int NPPM_GETNATIVELANGFILENAME(size_t strLen, char* nativeLangFileName)`
  //! @br Get the name of the currently active XML localization file.
  //! @param strLen [in] buffer length of `nativeLangFileName`
  //! @param[out] allocated language file name buffer
  //! @br@br Returns the number of single-byte characters copied/to copy. If there's no localization file in use, 0 is returned.
  //! @note(Users should first call this API with `nativeLangFileName` set to @nil to get the required number of single-byte characters
  //!       (not including the terminating @nil character), allocate the `nativeLangFileName` buffer with the return value + 1, then
  //!       call it again to get the localization file name. Call this  *after* the @link(NPPN_READY) notification has been sent.)
  //! Added in [8.7](https://github.com/notepad-plus-plus/notepad-plus-plus/commit/446cc98)
  NPPM_GETNATIVELANGFILENAME = (NPPMSG + 116);
  //! `BOOL NPPM_ADDSCNMODIFIEDFLAGS(0, unsigned long scnMotifiedFlags2Add)`
  //! @br Add the necessary flags so that your plugin will receive additional SCN_MODIFIED notifications.
  //! @param wParam 0 (not used)
  //! @param scnMotifiedFlags2Add [in] SCN_MODIFIED flags to add
  //! @br@br Returns @true.
  //! @note(By default, Notepad++ only forwards SCN_MODIFIED with the 5 flags/events in @link(DEFAULT_SC_MOD_MASK).
  //!       If your plugin needs to process other SCN_MODIFIED events, you should add the flags you need by sending this message *after* the
  //!       @link(NPPN_READY) notification has been sent, or only when your plugin needs to listen to specific events (to avoid penalizing Notepad++'s performance).
  //!       Just ensure this message is sent only once.)
  //! Added in [8.7.7](https://github.com/notepad-plus-plus/notepad-plus-plus/commit/6fd3830)
  NPPM_ADDSCNMODIFIEDFLAGS = (NPPMSG + 117);

  VAR_NOT_RECOGNIZED = 0;
  FULL_CURRENT_PATH = 1;
  CURRENT_DIRECTORY = 2;
  FILE_NAME = 3;
  NAME_PART = 4;
  EXT_PART = 5;
  CURRENT_WORD = 6;
  NPP_DIRECTORY = 7;
  CURRENT_LINE = 8;
  CURRENT_COLUMN = 9;
  NPP_FULL_FILE_PATH = 10;
  GETFILENAMEATCURSOR = 11;
  CURRENT_LINESTR = 12;
  RUNCOMMAND_USER = (WM_USER + 3000);
  NPPM_GETFULLCURRENTPATH = (RUNCOMMAND_USER + FULL_CURRENT_PATH);
  NPPM_GETCURRENTDIRECTORY = (RUNCOMMAND_USER + CURRENT_DIRECTORY);
  NPPM_GETFILENAME = (RUNCOMMAND_USER + FILE_NAME);
  NPPM_GETNAMEPART = (RUNCOMMAND_USER + NAME_PART);
  NPPM_GETEXTPART = (RUNCOMMAND_USER + EXT_PART);
  NPPM_GETCURRENTWORD = (RUNCOMMAND_USER + CURRENT_WORD);
  NPPM_GETNPPDIRECTORY = (RUNCOMMAND_USER + NPP_DIRECTORY);
  NPPM_GETFILENAMEATCURSOR = (RUNCOMMAND_USER + GETFILENAMEATCURSOR);
  NPPM_GETCURRENTLINESTR = (RUNCOMMAND_USER + CURRENT_LINESTR);
  // BOOL NPPM_GETXXXXXXXXXXXXXXXX(size_t strLen, wchar_t* str);
  // where str is the allocated `wchar_t` array,
  //       strLen is the allocated array size
  // The return value is TRUE when copying to the string buffer succeeds
  // Otherwise = (allocated array size is too small); FALSE
  NPPM_GETCURRENTLINE = (RUNCOMMAND_USER + CURRENT_LINE);
  // INT NPPM_GETCURRENTLINE(0, 0);
  //!< Returns the caret's current position line.
  NPPM_GETCURRENTCOLUMN = (RUNCOMMAND_USER + CURRENT_COLUMN);
  // INT NPPM_GETCURRENTCOLUMN(0, 0);
  //!< Returns the caret's current position column.
  NPPM_GETNPPFULLFILEPATH = (RUNCOMMAND_USER + NPP_FULL_FILE_PATH);



// Notification code
  NPPN_FIRST = 1000;
  //! To notify plugins that all of Notepad++'s initialization routines are complete
  //scnNotification->nmhdr.code = NPPN_READY;
  //scnNotification->nmhdr.hwndFrom = hwndNpp;
  //scnNotification->nmhdr.idFrom = 0;
  NPPN_READY = (NPPN_FIRST + 1);
  //! To notify plugins that toolbar icons can be registered
  //scnNotification->nmhdr.code = NPPN_TBMODIFICATION;
  //scnNotification->nmhdr.hwndFrom = hwndNpp;
  //scnNotification->nmhdr.idFrom = 0;
  NPPN_TBMODIFICATION = (NPPN_FIRST + 2);
  //! To notify plugins that a file is about to be closed
  //scnNotification->nmhdr.code = NPPN_FILEBEFORECLOSE;
  //scnNotification->nmhdr.hwndFrom = hwndNpp;
  //scnNotification->nmhdr.idFrom = BufferID;
  NPPN_FILEBEFORECLOSE = (NPPN_FIRST + 3);
  //! To notify plugins that a file was just opened
  //scnNotification->nmhdr.code = NPPN_FILEOPENED;
  //scnNotification->nmhdr.hwndFrom = hwndNpp;
  //scnNotification->nmhdr.idFrom = BufferID;
  NPPN_FILEOPENED = (NPPN_FIRST + 4);
  //! To notify plugins that a file was just closed
  //scnNotification->nmhdr.code = NPPN_FILECLOSED;
  //scnNotification->nmhdr.hwndFrom = hwndNpp;
  //scnNotification->nmhdr.idFrom = BufferID;
  NPPN_FILECLOSED = (NPPN_FIRST + 5);
  //! To notify plugins that a file is about to be opened
  //scnNotification->nmhdr.code = NPPN_FILEBEFOREOPEN;
  //scnNotification->nmhdr.hwndFrom = hwndNpp;
  //scnNotification->nmhdr.idFrom = BufferID;
  NPPN_FILEBEFOREOPEN = (NPPN_FIRST + 6);
  //! To notify plugins that the current file is about to be saved
  //scnNotification->nmhdr.code = NPPN_FILEBEFORESAVE;
  //scnNotification->nmhdr.hwndFrom = hwndNpp;
  //scnNotification->nmhdr.idFrom = BufferID;
  NPPN_FILEBEFORESAVE = (NPPN_FIRST + 7);
  //! To notify plugins that the current file was just saved
  //scnNotification->nmhdr.code = NPPN_FILESAVED;
  //scnNotification->nmhdr.hwndFrom = hwndNpp;
  //scnNotification->nmhdr.idFrom = BufferID;
  NPPN_FILESAVED = (NPPN_FIRST + 8);
  //! To notify plugins that Notepad++ is about to shut down
  //scnNotification->nmhdr.code = NPPN_SHUTDOWN;
  //scnNotification->nmhdr.hwndFrom = hwndNpp;
  //scnNotification->nmhdr.idFrom = 0;
  NPPN_SHUTDOWN = (NPPN_FIRST + 9);
  //! To notify plugins that a buffer has been activated (i.e., put into the foreground)
  //scnNotification->nmhdr.code = NPPN_BUFFERACTIVATED;
  //scnNotification->nmhdr.hwndFrom = hwndNpp;
  //scnNotification->nmhdr.idFrom = activatedBufferID;
  NPPN_BUFFERACTIVATED = (NPPN_FIRST + 10);
  //! To notify plugins that the programming language of the current document was just changed
  //scnNotification->nmhdr.code = NPPN_LANGCHANGED;
  //scnNotification->nmhdr.hwndFrom = hwndNpp;
  //scnNotification->nmhdr.idFrom = currentBufferID;
  NPPN_LANGCHANGED = (NPPN_FIRST + 11);
  //! To notify plugins that the user has made a change in the "Style Configurator" dialog
  //scnNotification->nmhdr.code = NPPN_WORDSTYLESUPDATED;
  //scnNotification->nmhdr.hwndFrom = hwndNpp;
  //scnNotification->nmhdr.idFrom = currentBufferID;
  NPPN_WORDSTYLESUPDATED = (NPPN_FIRST + 12);
  //! To notify plugins that a plugin command shortcut was remapped
  //scnNotification->nmhdr.code = NPPN_SHORTCUTSREMAPPED;
  //scnNotification->nmhdr.hwndFrom = ShortcutKeyStructurePointer;
  //scnNotification->nmhdr.idFrom = cmdID;
    //where ShortcutKeyStructurePointer is pointer of struct ShortcutKey:
    //struct ShortcutKey {
    //  bool _isCtrl;
    //  bool _isAlt;
    //  bool _isShift;
    //  UCHAR _key;
    //};
  NPPN_SHORTCUTSREMAPPED = (NPPN_FIRST + 13);
  //! To notify plugins that a file is about to be loaded
  //! @note Plugins can use this notification to filter SCN_MODIFIED.
  //scnNotification->nmhdr.code = NPPN_FILEBEFORELOAD;
  //scnNotification->nmhdr.hwndFrom = hwndNpp;
  //scnNotification->nmhdr.idFrom = NULL;
  NPPN_FILEBEFORELOAD = (NPPN_FIRST + 14);
  //! To notify plugins that a file-open operation failed
  //scnNotification->nmhdr.code = NPPN_FILELOADFAILED;
  //scnNotification->nmhdr.hwndFrom = hwndNpp;
  //scnNotification->nmhdr.idFrom = BufferID;
  NPPN_FILELOADFAILED = (NPPN_FIRST + 15);
  //! To notify plugins that the readonly status of the current document has changed
  //scnNotification->nmhdr.code = NPPN_READONLYCHANGED;
  //scnNotification->nmhdr.hwndFrom = bufferID;
  //scnNotification->nmhdr.idFrom = docStatus;
    // where bufferID is BufferID
    //       docStatus can be combined by DOCSTATUS_READONLY and DOCSTATUS_BUFFERDIRTY
  NPPN_READONLYCHANGED = (NPPN_FIRST + 16);
  DOCSTATUS_READONLY = 1;
  DOCSTATUS_BUFFERDIRTY = 2;
  //! To notify plugins that the document order has changed
  //scnNotification->nmhdr.code = NPPN_DOCORDERCHANGED;
  //scnNotification->nmhdr.hwndFrom = newIndex;
  //scnNotification->nmhdr.idFrom = BufferID;
  NPPN_DOCORDERCHANGED = (NPPN_FIRST + 17);
  //! To notify plugins that a dirty file snapshot was loaded on startup
  //scnNotification->nmhdr.code = NPPN_SNAPSHOTDIRTYFILELOADED;
  //scnNotification->nmhdr.hwndFrom = NULL;
  //scnNotification->nmhdr.idFrom = BufferID;
  NPPN_SNAPSHOTDIRTYFILELOADED = (NPPN_FIRST + 18);
  //! To notify plugins that an application shutdown has been triggered; no files have been closed yet
  //scnNotification->nmhdr.code = NPPN_BEFORESHUTDOWN;
  //scnNotification->nmhdr.hwndFrom = hwndNpp;
  //scnNotification->nmhdr.idFrom = 0;
  NPPN_BEFORESHUTDOWN = (NPPN_FIRST + 19);
  //! To notify plugins that an application shutdown has been cancelled
  //scnNotification->nmhdr.code = NPPN_CANCELSHUTDOWN;
  //scnNotification->nmhdr.hwndFrom = hwndNpp;
  //scnNotification->nmhdr.idFrom = 0;
  NPPN_CANCELSHUTDOWN = (NPPN_FIRST + 20);
  //! To notify plugins that a file is about to be renamed
  //scnNotification->nmhdr.code = NPPN_FILEBEFORERENAME;
  //scnNotification->nmhdr.hwndFrom = hwndNpp;
  //scnNotification->nmhdr.idFrom = BufferID;
  NPPN_FILEBEFORERENAME = (NPPN_FIRST + 21);
  //! To notify plugins that a file rename has been cancelled
  //scnNotification->nmhdr.code = NPPN_FILERENAMECANCEL;
  //scnNotification->nmhdr.hwndFrom = hwndNpp;
  //scnNotification->nmhdr.idFrom = BufferID;
  NPPN_FILERENAMECANCEL = (NPPN_FIRST + 22);
  //! To notify plugins that a file has been renamed
  //scnNotification->nmhdr.code = NPPN_FILERENAMED;
  //scnNotification->nmhdr.hwndFrom = hwndNpp;
  //scnNotification->nmhdr.idFrom = BufferID;
  NPPN_FILERENAMED = (NPPN_FIRST + 23);
  //! To notify plugins that a file is about to be deleted
  //scnNotification->nmhdr.code = NPPN_FILEBEFOREDELETE;
  //scnNotification->nmhdr.hwndFrom = hwndNpp;
  //scnNotification->nmhdr.idFrom = BufferID;
  NPPN_FILEBEFOREDELETE = (NPPN_FIRST + 24);
  //! To notify plugins that a file deletion has failed
  //scnNotification->nmhdr.code = NPPN_FILEDELETEFAILED;
  //scnNotification->nmhdr.hwndFrom = hwndNpp;
  //scnNotification->nmhdr.idFrom = BufferID;
  NPPN_FILEDELETEFAILED = (NPPN_FIRST + 25);
  //! To notify plugins that a file has been deleted
  //scnNotification->nmhdr.code = NPPN_FILEDELETED;
  //scnNotification->nmhdr.hwndFrom = hwndNpp;
  //scnNotification->nmhdr.idFrom = BufferID;
  NPPN_FILEDELETED = (NPPN_FIRST + 26);
  //! To notify plugins that dark mode was enabled/disabled
  //scnNotification->nmhdr.code = NPPN_DARKMODECHANGED;
  //scnNotification->nmhdr.hwndFrom = hwndNpp;
  //scnNotification->nmhdr.idFrom = 0;
  //! Added in [8.4.1](https://github.com/notepad-plus-plus/notepad-plus-plus/commit/1eb5b10e41d7ab92b60aa32b28d4fe7739d15b53)
  NPPN_DARKMODECHANGED = (NPPN_FIRST + 27);
  //! To notify plugins that the command line argument `-pluginMessage="YOUR_PLUGIN_ARGUMENT"` is available
  //scnNotification->nmhdr.code = NPPN_CMDLINEPLUGINMSG;
  //scnNotification->nmhdr.hwndFrom = hwndNpp;
  //scnNotification->nmhdr.idFrom = pluginMessage; //where pluginMessage is pointer of type wchar_t
  //! Added in [8.4.2](https://github.com/notepad-plus-plus/notepad-plus-plus/commit/0f8d5724afb0a540e8b4024252945ab60bc88c71)
  NPPN_CMDLINEPLUGINMSG = (NPPN_FIRST + 28);
  //! To notify lexer plugins that the buffer (passed in `idFrom`) was just applied to an external lexer
	//scnNotification->nmhdr.code = NPPN_EXTERNALLEXERBUFFER;
	//scnNotification->nmhdr.hwndFrom = hwndNpp;
	//scnNotification->nmhdr.idFrom = BufferID; //where pluginMessage is pointer of type wchar_t
  //! Added in [8.5](https://github.com/notepad-plus-plus/notepad-plus-plus/commit/03a5c4795b764fa5e719092da0c37fc66ec82889)
  NPPN_EXTERNALLEXERBUFFER = (NPPN_FIRST + 29);
  //! To notify plugins that the current document was just modified by the "Replace All" action
  // To solve a performance issue (from v8.6.4), Notepad++ doesn't trigger SCN_MODIFIED during the "Replace All" action anymore.
  // As a result, plugins that monitor SCN_MODIFIED should also monitor NPPN_GLOBALMODIFIED.
  // This notification is implemented in Notepad++ v8.6.5.
  //scnNotification->nmhdr.code = NPPN_GLOBALMODIFIED;
  //scnNotification->nmhdr.hwndFrom = BufferID;
  //scnNotification->nmhdr.idFrom = 0; // preserved for the future use, must be zero
  //! Added in [8.6.5](https://github.com/notepad-plus-plus/notepad-plus-plus/commit/49e6957d486c360e05ba85ceb1c179a891831779)
  NPPN_GLOBALMODIFIED = (NPPN_FIRST + 30);
  //! To notify plugins that the current native language has just changed to another one
  //! @note(Use @link(NPPM_GETNATIVELANGFILENAME) to get the current native language file name.
  //!       Use @link(NPPM_GETMENUHANDLE)(@link(NPPPLUGINMENU), 0) to get the "Plugins" submenu handle (`HMENU`).)
  //scnNotification->nmhdr.code = NPPN_NATIVELANGCHANGED;
  //scnNotification->nmhdr.hwndFrom = hwndNpp
  //scnNotification->nmhdr.idFrom = 0; // preserved for the future use, must be zero
  //! Added in [8.7](https://github.com/notepad-plus-plus/notepad-plus-plus/commit/446cc980e871d04885f13055bb56acee820636c8)
  NPPN_NATIVELANGCHANGED = (NPPN_FIRST + 31);

  MACRO_USER                = (WM_USER + 4000);
  WM_ISCURRENTMACRORECORDED = (MACRO_USER + 01);
  WM_MACRODLGRUNMACRO       = (MACRO_USER + 02);

type
  TNppLang = (L_TEXT = 0, L_PHP , L_C, L_CPP, L_CS, L_OBJC, L_JAVA, L_RC,
              L_HTML, L_XML, L_MAKEFILE, L_PASCAL, L_BATCH, L_INI, L_ASCII, L_USER,
              L_ASP, L_SQL, L_VB, L_JS, L_CSS, L_PERL, L_PYTHON, L_LUA,
              L_TEX, L_FORTRAN, L_BASH, L_FLASH, L_NSIS, L_TCL, L_LISP, L_SCHEME,
              L_ASM, L_DIFF, L_PROPS, L_PS, L_RUBY, L_SMALLTALK, L_VHDL, L_KIX, L_AU3,
              L_CAML, L_ADA, L_VERILOG, L_MATLAB, L_HASKELL, L_INNO, L_SEARCHRESULT,
              L_CMAKE, L_YAML, L_COBOL, L_GUI4CLI, L_D, L_POWERSHELL, L_R, L_JSP,
              L_COFFEESCRIPT, L_JSON, L_JAVASCRIPT, L_FORTRAN_77, L_BAANC, L_SREC,
              L_IHEX, L_TEHEX, L_SWIFT,
              L_ASN1, L_AVS, L_BLITZBASIC, L_PUREBASIC, L_FREEBASIC,
              L_CSOUND, L_ERLANG, L_ESCRIPT, L_FORTH, L_LATEX,
              L_MMIXAL, L_NIM, L_NNCRONTAB, L_OSCRIPT, L_REBOL,
              L_REGISTRY, L_RUST, L_SPICE, L_TXT2TAGS, L_VISUALPROLOG,
              L_TYPESCRIPT, L_JSON5, L_MSSQL, L_GDSCRIPT, L_HOLLYWOOD,
              L_GOLANG, L_RAKU, L_TOML, L_SAS,
              // Don't use L_JS, use L_JAVASCRIPT instead
              // The end of enumerated language type, so it should be always at the end
              L_EXTERNAL);

{$REGION 'Delphi plugin definitions'}
const
  L_TXT = TNppLang.L_TEXT; // https://github.com/notepad-plus-plus/notepad-plus-plus/commit/689d434a9f17cd7eb195fcdb7860d41631e44a6a
  FuncItemNameLen = 64;

type
  nppString = {$ifdef FPC} UnicodeString {$else} WideString {$endif};
  nppChar   = {$ifdef FPC} UnicodeChar   {$else} WChar      {$endif};
  nppPChar  = {$ifdef FPC} PUnicodeChar  {$else} PWChar     {$endif};
{$ENDREGION}

type
  //! Added in [8.3.3](https://github.com/notepad-plus-plus/notepad-plus-plus/commit/9cbd03c)
  TExternalLexerAutoIndentMode = ( Standard, C_Like, Custom );

  //! Added in [8.3.3](https://github.com/notepad-plus-plus/notepad-plus-plus/commit/9cbd03c)
  TMacroStatus = ( Idle, RecordInProgress, RecordingStopped, PlayingBack );

  //! Added in [7.3.2](https://github.com/notepad-plus-plus/notepad-plus-plus/commit/3dfe526)
  TPlatform = ( PF_UNKNOWN, PF_X86, PF_X64, PF_IA64, PF_ARM64 );

  TWinVer = ( WV_UNKNOWN, WV_WIN32S, WV_95, WV_98, WV_ME, WV_NT, WV_W2K, WV_XP, WV_S2003, WV_XPX64, WV_VISTA, WV_WIN7, WV_WIN8, WV_WIN81, WV_WIN10, WV_WIN11 );

  //! See @link(NPPM_SAVESESSION)
  TSessionInfo = record
    //! Full path name of the session file to be saved
    SessionFilePathName: nppPChar;
    //! Size of the @link(Files) array (i.e., the number of files to be saved in the session)
    NumFiles: Integer;
    //! Array of file names (full path) to be saved in the session
    Files: array of nppPChar;
  end;

  //! See @link(NPPM_ADDTOOLBARICON_DEPRECATED)
  //! @deprecated
  TToolbarIcons = record
    //! Standard 16x16 bitmap handle
    ToolbarBmp: HBITMAP;
    //! Standard 32x32 icon handle
    ToolbarIcon: HICON;
  end;

  // 2 formats / 3 icons are needed:  1 * BMP + 2 * ICO
  //! See @link(NPPM_ADDTOOLBARICON_FORDARKMODE)
  //! @note All 3 handles should be set to ensure correct display in case the user selects a custom toolbar icon set.
  TTbIconsDarkMode = record
    //! Standard 16x16 bitmap handle
    ToolbarBmp: HBITMAP;
    //! Fluent UI icon handle for light mode
    ToolbarIcon: HICON;
    //! Fluent UI icon handle for dark mode
    ToolbarIconDarkMode: HICON;
  end;

  //! See @link(NPPM_MSGTOPLUGIN)
  TCommunicationInfo = record
    //! An integer defined by plugin Y, known by plugin X, identifying the message being sent.
    internalMsg: LongInt;
    //! The complete module name (with the `.dll` extension) of caller (plugin X).
    srcModuleName: nppPChar;
    //! Defined by plugin, the information to be exchanged between X and Y. It's a void pointer so it should be defined by plugin Y and known by plugin X.
    info: Pointer;
  end;

  TNppData = packed record
    NppHandle: HWND;
    ScintillaMainHandle: HWND;
    ScintillaSecondHandle: HWND;
  end;
  PNPPData = ^TNppData;

  TShortcutKey = packed record
    IsCtrl: Boolean;
    IsAlt: Boolean;
    IsShift: Boolean;
    Key: UCHAR;
  end;
  PShortcutKey = ^TShortcutKey;

  //! The generic type of a function defined by the plugin and callable by the host application
  PFUNCPLUGINCMD = procedure; cdecl;

  _TFuncItem = packed record
    ItemName: array[0..FuncItemNameLen-1] of nppChar;
    Func: PFUNCPLUGINCMD;
    CmdID: Integer;
    Checked: LongBool;
    ShortcutKey: PShortcutKey;
  end;
  PFuncItem = ^_TFuncItem;

  //! See @link(NPPM_DMMREGASDCKDLG)
  TToolbarData = record
    ClientHandle: HWND; //! Client window handle
    Title: nppPChar; //! Name of plugin (shown in dialog title bar)
    DlgId: Integer;  //! User-provided index of the plugin command associated with this toolbar item -- *not to be confused with* @link(TNppDockingForm.CmdId)
    Mask: Cardinal; //! Dialog window attribute flags; see @link(NppDockingForms.DWS_DF_CONT_LEFT), etc.
    IconTab: HICON; //! Icon for tabs, provided the @link(NppDockingForms.DWS_ICONTAB) flag is set
    AdditionalInfo: nppPChar; //! Additional text for the dialog title bar, provided the @link(NppDockingForms.DWS_ADDINFO) flag is set
    FloatRect: TRect;  //! Internal data, **do not use**
    PrevContainer: Cardinal; //! Internal data, **do not use**
    ModuleName:nppPChar; //! Name of module (including the ".dll" file extension). This can be obtained by [GetModuleFileName()](https://learn.microsoft.com/windows/win32/api/libloaderapi/nf-libloaderapi-getmodulefilenamew)
  end;
  PToolbarData = ^TToolbarData;

{$ENDIF ~NPP_INC}
