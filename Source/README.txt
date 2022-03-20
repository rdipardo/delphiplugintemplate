Quick Start
===========
* Launch the RAD Studio Command Prompt (if available)

* Alternatively, open the Command Prompt and initialize your Delphi environment
  e.g., for Delphi 10.3 (Rio), run
    
    "%ProgramFiles(x86)%\Embarcadero\Studio\20.0\bin\rsvars.bat"

* Enter the 'Source' directory

* To build a 64-bit DLL, run

    dcc64 helloworld.dpr

  *NOTE* to target Notepad++ 8.2.1 and older, run

    dcc64 -DNPP_NO_HUGE_FILES helloworld.dpr

* To build a 32-bit DLL, run

    dcc32 helloworld.dpr


Using the IDE
=============
* Double-click helloworld.dpr and build the project as usual
