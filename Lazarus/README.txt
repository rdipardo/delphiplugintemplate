*NOTES*
--------
Make sure 'lazbuild.exe' is on the PATH.

You may have to set up the PATH yourself if Lazarus was installed directly from the
project website at https://www.lazarus-ide.org

Using Scoop (https://scoop.sh), the PATH will be configured automatically when you
install the Lazarus IDE; look for it in the 'extras' bucket: https://github.com/ScoopInstaller/Extras

Test your installation with the command: %LazarusDir%\lazbuild -v

--------
The Free Pascal compiler that comes with Lazarus is not cross-platform.
For cross-compiling, install an add-on package from https://sourceforge.net/projects/lazarus/files

To build 32-bit Windows binaries using a 64-bit compiler, choose the package that looks like this:

    lazarus-x.y.z-fpc-x.y.z-cross-i386-win32-win64.exe

To build 64-bit Windows binaries using a 32-bit compiler, the package looks like this:

    lazarus-x.y.z-fpc-x.y.z-cross-x86_64-win64-win32.exe

Quick Start
===========
* Enter the 'Lazarus' directory

* To build a 64-bit DLL, run

    lazbuild -B --cpu=x86_64 HelloWorld.lpi

* To build a 32-bit DLL, run

    lazbuild -B --cpu=i386 HelloWorld.lpi

Using the IDE
=============
* Double-click 'helloworld.lpi' to start Lazarus
* From the menu, select Run > Build

Targeting Notepad++ 8.2.1 and older
===================================
* In the IDE, select Project > Project Options > Compiler Options
* Add '-dNPP_NO_HUGE_FILES' to Custom Options
