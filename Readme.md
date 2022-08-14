# Notepad++ Plugin Template for Delphi & Lazarus

<img src="https://i.ibb.co/BGGB7Tb/npp-8-3-3-x64-docked.png" alt="npp-8-3-3-x64-docked" border="0">

An updated version of the [Delphi plugin template][upstream] by [Damjan Zobo Cvetko](https://github.com/zobo), developer of the popular [DBGP] plugin for the Xdebug server.

Since Delphi 2009 added [Unicode support][D2009], and ANSI plugins can't be loaded in current versions of Notepad++, compiling for Unicode is now the only option.

Compatibility with 64-bit Notepad++ has also been added (requires [Delphi XE2][DXE2] or newer).


## Usage

Download one of these tagged revisions to target an appropriate API level:

| Tag                      | Scintilla API version   | Supported Notepad++ versions   |
| :--                      | :--                     | :--                            |
| **[api-v5.2.3]**         |  5.2.3                  | 8.4.3+        (all builds)     |
| **[api-v5.2.2]**         |  5.2.2                  | 8.4 - 8.4.2   (all builds)     |
| **[api-v4]**             |  4.4.6                  | 7.9.4 - 8.3.3 (32-bit) <br/> 8.3 - 8.3.3 (64-bit) |
| &#x2013;                 |  &#x2013;               | *or, with the `NPP_NO_HUGE_FILES` compiler definition* |
| &#x2013;                 |  &#x2013;               | 7.9.4 - 8.2.1 (64-bit)         |

[api-v5.2.3]: https://bitbucket.org/rdipardo/delphiplugintemplate/get/api-v5.2.3.zip
[api-v5.2.2]: https://bitbucket.org/rdipardo/delphiplugintemplate/get/api-v5.2.2.zip
[api-v4]: https://bitbucket.org/rdipardo/delphiplugintemplate/get/api-v4.zip

Or, clone the repository and check out a tag, for example:

    git checkout -f api-v5.2.3

Run the install script with the name of a project directory, e.g.:

    install %USERPROFILE%\projects\MyPlugin

**Note**
Remember to edit the DLL attach hook in 'Source/Units/DLLExports.pas' with the actual name of your plugin class instance and type:

~~~pascal
case dwReason of
DLL_PROCESS_ATTACH:
  begin
    // create the main 'Npp' object
    // Npp := THelloWorldPlugin.Create;
    MyPlugin := TMyPlugin.Create;
  end;
// ...
end;
~~~

## Supported Features

### Dark Mode Icons (Notepad++ 8.0 and later)

<img src="https://i.ibb.co/GdYYz8c/npp-8-3-3-x64-dark-detail.png" alt="npp_8.3.3_x64_dark_detail" border="0"/>

Plugin API messages provided by 'Source/Include/Npp.inc':

- `NPPM_ADDTOOLBARICON_FORDARKMODE` [^1]
- `NPPM_ADDTOOLBARICON_DEPRECATED` [^2]

**Note**
`NPPM_ADDTOOLBARICON_DEPRECATED` is defined as an alias for the older `NPPM_ADDTOOLBARICON` message, so standard toolbar icons will still work in versions of Notepad++ before 8.0. Your plugin can use either message interchangeably.

Types provided by 'Source/Include/Npp.inc':

- `TTbIconsDarkMode`[^3]

Methods provided by 'Source/Units/Common/NppPlugin.pas'

- `TNppPlugin.SupportsDarkMode` - returns `true` if the running editor is at least version 8.0


### Huge File Support (64-bit Notepad++ 8.3 and later)

Since [version 8.3][8.3], x64 builds of Notepad++ can open files of >2GiB in size.
To support these Notepad++ versions, 64-bit plugins that call any Scintilla APIs _*must*_ be able to handle 64-bit character positions.

The definitions provided in 'Source/Include/Scintilla.inc' will support huge files without any configuration.

#### 64-bit DLLs compiled with the default Scintilla definitions are compatible with Notepad++ >= 8.3 _*ONLY!*_

There may be cases where huge file support can be disabled, for example:

- your plugin is only offered in 32-bit versions
- your plugin does not call any [Scintilla APIs][sci] like `SCI_GETTEXTRANGE`, `SCI_GETLENGTH`, etc.
- you intend to only support 8.2.1 and earlier versions of Notepad++. Read the [documented instructions][docs] on how to indicate a plugin's maximum supported Notepad++ version

The template provides two (very basic) options to configure huge file support:

1. Set the `NPP_NO_HUGE_FILES` compiler definition to limit character positions to the size of `System.Integer`, even on x64 architecture

> In the IDE, select 'Project > Options', or press Ctrl + Shift + F11.
>
> Go to 'Building > Delphi Compiler > Conditional Defines' and add 'NPP_NO_HUGE_FILES'.

2. The `TNppPlugin` base class implements a `SupportsBigFiles` method that returns `true` if the running editor is version 8.3 or greater.
Note that it _does not_ check CPU architecture; you still need to use conditional expressions, for example:

~~~pascal
{$IFDEF CPUx64}
{$IFNDEF NPP_NO_HUGE_FILES}
  if MyPlugin.SupportsBigFiles then
  begin
    // code for Npp 8.3+
  end;
{$ENDIF}
{$ENDIF}
~~~

### 64-bit Scintilla APIs for Windows (Notepad++ 8.4.3 and later)

Scintilla began supporting 64-bit character positions on the Windows platform in [version 5.2.3][sci523].
Notepad++ added these APIs in 8.4.3:

- `SCI_FINDTEXTFULL`
- `SCI_FORMATRANGEFULL`
- `SCI_GETTEXTRANGEFULL`

Note that, [since Notepad++ 8.3][8.3], all of the _former_ APIs return 64-bit values also; these include:

- `SCI_FINDTEXT`
- `SCI_FORMATRANGE`
- `SCI_GETTEXTRANGE`

Calling any of the six APIs above is functionally equivalent in Notepad++ 8.4.3 or later.
However, a future version of Scintilla will [deprecate the former APIs][sciNext] (the ones without the `*FULL` suffix).
For forward compatibility, the following types are provided by 'Source/Include/Scintilla.inc':

- `TSciTextRangeFull`
- `TSciTextToFindFull`
- `TSciRangeToFormatFull`

Methods provided by 'Source/Units/Common/NppPlugin.pas':

- `TNppPlugin.HasFullRangeApis` - returns `true` if the `SCI_FINDTEXTFULL`, `SCI_FORMATRANGEFULL` and `SCI_GETTEXTRANGEFULL` APIs are available


### Breaking Changes in Notepad++ 8.4.3 and later

'Source/Include/Scintilla.inc' no longer provides the `TSearchResultMarking` type.

Notepad++ replaced the underlying Scintilla structure with [a custom type][oneMatch] that can't be implemented in Object Pascal.


### Breaking Changes in Notepad++ 8.4 and later

#### Loading an external lexer from a plugin

An overview of the new Lexilla protocol is provided [here](https://www.scintilla.org/Scintilla5Migration.html).
Note that the following messages are no longer provided:

- `SCI_SETLEXER`
- `SCI_SETLEXERLANGUAGE`
- `SCI_LOADLEXERLIBRARY`

#### `SCI_GETTEXT`, `SCI_GETSELTEXT` and `SCI_GETCURLINE`

Since Scintilla version [5.1.5][sci515], calling any of these three APIs with an empty buffer returns a string length that _does not count the final `NULL` character_.
Code paths depending on the old implementation should add 1 to the return value.

Methods provided by 'Source/Units/Common/NppPlugin.pas':

- `TNppPlugin.HasV5Apis` - returns `true` if the running editor is at least version 8.4, [the first release][8.4] with a Scintilla v5 API

### Optional Scintilla Features (as of v5.2.3)[^4]

Use these compiler definitions to enable or disable features.

#### `INCLUDE_DEPRECATED_FEATURES`

Exposes the following API messages:

      SCI_SETKEYSUNICODE
      SCI_GETKEYSUNICODE
      SCI_GETTWOPHASEDRAW
      SCI_SETTWOPHASEDRAW
      SCI_SETSTYLEBITS
      SCI_GETSTYLEBITS
      SCI_GETSTYLEBITSNEEDED
      INDIC0_MASK
      INDIC1_MASK
      INDIC2_MASK
      INDICS_MASK

_The following type aliases will also become available:_

| Alias          | Type               |
| :--            | :--                |
| CharacterRange | TSciCharacterRange |
| TextRange      | TSciTextRange      |
| TextToFind     | TSciTextToFind     |
| RangeToFormat  | TSciRangeToFormat  |
| NotifyHeader   | TNotifyHeader      |


#### `SCI_DISABLE_PROVISIONAL`

_Hides_ the following API messages:

      SC_BIDIRECTIONAL_DISABLED
      SC_BIDIRECTIONAL_L2R
      SC_BIDIRECTIONAL_R2L
      SCI_GETBIDIRECTIONAL
      SCI_SETBIDIRECTIONAL


## Plugin API Reference

[^1]: [`NPPM_ADDTOOLBARICON_FORDARKMODE`](https://community.notepad-plus-plus.org/topic/21652/add-new-api-nppm_addtoolbaricon_fordarkmode-for-dark-mode)

[^2]: [`NPPM_ADDTOOLBARICON_DEPRECATED`](https://github.com/notepad-plus-plus/npp-usermanual/blob/master/content/docs/plugin-communication.md#nppm_addtoolbaricon-nppm_addtoolbaricon_deprecated-in-v80)

[^3]: [`TTbIconsDarkMode`](https://github.com/notepad-plus-plus/notepad-plus-plus/commit/8a898bae3f84c03c44aaed25001e9fa1ddfa09aa)

[^4]: [Scintilla 5.2.3 definitions](https://github.com/notepad-plus-plus/notepad-plus-plus/blob/ed4bb1a93e763001aac842698fcde0856ba8b0bc/scintilla/include/Scintilla.h)



[upstream]: https://sourceforge.net/projects/npp-plugins/files/DelphiPluginTemplate
[DBGP]: https://github.com/zobo/dbgpPlugin
[D2009]: https://www.embarcadero.com/rad-in-action/migration-upgrade-center#unicode
[DXE2]: https://community.embarcadero.com/blogs/entry/delphi-64bit-code
[sci]: https://www.scintilla.org/ScintillaDoc.html#TextRetrievalAndModification
[sci515]: https://sourceforge.net/p/scintilla/code/ci/483efdbe6facf2d9a4f10a8ec1f049bfae7723ae/tree/doc/ScintillaHistory.html?diff=2a700fc24c59a47fa6b29b0bb6c556dcc39c5b31
[sci523]: https://sourceforge.net/p/scintilla/code/ci/241398a1d33bb7644596826f61639bdff477b32c/tree/doc/ScintillaHistory.html?diff=1c48196154f5d39fcd70f02d71344c6707543b8f
[sciNext]: https://groups.google.com/g/scintilla-interest/c/mPLwYdC0-FE#:~:text=SCI_GETTEXTRANGE%20will%20be%20deprecated%20at%20some%20point
[8.3]: https://community.notepad-plus-plus.org/topic/22471/prevent-plugin-from-crash-on-v8-3-and-later-version-recompile-x64-plugins-with-new-header
[8.4]: https://github.com/notepad-plus-plus/notepad-plus-plus/commit/a61b03ea8887e21c6e1b7374068962f635b79b80
[oneMatch]: https://github.com/notepad-plus-plus/notepad-plus-plus/commit/08128ee36a31fdb0b3d72d1d7342f50e8103ea47#diff-41f42d8960fb90330ea7a19c8e7f35d0575fe12eb976cb95f4971106c48329b4
[docs]: https://npp-user-manual.org/docs/plugins/#rules-for-adding-your-plugins-into-list
