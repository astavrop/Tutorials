---
author: Benjamin Eikel, Claudius Jähn, Ralf Petring, Sascha Brandt
category: Installation Guide@0
last_updated: November 15, 2018
order: 0
permalink: installation_guide
summary: This tutorial describes how to build PADrend from source code.
title: Building PADrend from source
---

## Windows (64bit)
The following work-flow is tested to work on a newly installed windows (>=7) system.
Latest full test 2014-07-07.

__Please check and update this work flow continuously!__

### Required build tools
#### Compiler: MinGW
* Download MinGW 64 bit version (e.g. [mingw-w64-install.exe](http://sourceforge.net/projects/mingw-w64/files/), see 'Compiler versions' section below).
* Install settings: 
	* Version: 8.1.0 (at least 5.1.0)
	* Architecture: x86_64
	* Threads: posix
	* Exception: seh
	* Build revision: largest available
	* Destination folder: `c:\mingw-w64` (the actual MinGW will then be installed in c:\mingw-w64\mingw64).
* Copy a version of the __libiconv-2.dll__ into the `c:\mingw-w64\mingw64\bin` folder. 
 The file is shipped with many different software packages -- just search in your programs folder and you will probably find one. The windows GIT-client (see below) contains the file in its ''bin'' folder.
 (If this file can not be found while compiling the third party libraries, libXML2 fails to build.)

* __Notes: (if you want to use another compiler)__
	* Only compilers using  ljsj exception handling are supported; dwarf2 is not supported.
	* The installation path should not contain any white spaces.
	* In version 4.8.1, the Bullet physics library can not be compiled [http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58165](http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58165)
	* If using the __tdm64-gcc-4.7.1-3__ from [here](http://sourceforge.net/projects/tdm-gcc/files/TDM-GCC%20Installer/Previous/1.1006.0/), replace the file `C:\MinGW64\lib\gcc\x86_64-w64-mingw32\4.7.1\include\c++\array` with this patched version: [attachment:array] It patches a bug in this compiler version resulting in that _std::array::at_ sometimes returns wrong values.<!--TODO: No idea how to handle the attachment -->
	* Be prepared that each compiler version can lead to different problems... 

#### MSYS (shell required for building third-party libs)
* Download __MSYS-20111123.zip__ from  [here](http://sourceforge.net/projects/mingw-w64/files/External%20binary%20packages%20%28Win64%20hosted%29/MSYS%20%2832-bit%29/).
* Expand it to `C:\mingw-w64\msys`.
* Open a MSYS shell: `C:\mingw-w64\msys\msys.bat`.
* Connect the MSYS installation with your compiler by running the following command and following the wizard:
 `sh /postinstall/pi.sh`. The path to your MinGW installation should be `c:/mingw-w64/mingw64` .
* To check if everything is working, enter `gcc --version`, which should give you the installed compiler version.

#### CMake (>=2.8.11)
* Download the latest CMake version from [here](http://www.cmake.org/).
* Install it and and check the option _Add CMake too the system PATH for current user_ (for convenience).

#### GIT 
* You need GIT to get the source.
* A Git-Client for windows is available [here](https://gitforwindows.org/).
	* The _Windows Explorer integration_ is not necessary.
	* The recommended _line ending conversion_ is _Checkout as-is, commit as-is_. (Note: Only use Unix-style line endings!)
* (optional) Install a graphical git user interface (e.g. [Toritoise-GIT](https://code.google.com/p/tortoisegit/)).

#### Choose your IDE
* Visual Studio does not work (if you manage to make it work, please contact us).
* Other than that, you can use any C++ IDE you like (that supports GCC).
* We recommend using [Atom](https://atom.io/) with the plugins [autocomplete-clang](https://atom.io/packages/autocomplete-clang), [linter-clang](https://atom.io/packages/linter-clang) and [language-escript](https://atom.io/packages/language-escript) (a detailed guide how to set up Atom is in the works).

### Download source 
__For compiling the external libraries, PADrend must be located in a short path without any white spaces, like `C:\PADrend`.__

* (Public open source part) Clone the repository `https://github.com/PADrend/PADrendComplete.git` into `c:\PADrend` using the `--recursive` option (See a git manual for details.).
 All required (Open Source) repositories are embedded as submodules.
* (Closed source part; optional; needs permission to access) Clone the repository `https://git.cs.upb.de/algoCG/extPlugins.git` into the `C:\PADrend\extPlugins` folder.

### Build third party libraries
* Open CMake-GUI (_best from within the MSYS shell_)
* Set the source path to `C:\PADrend\ThirdParty` and the build path to `C:\PADrend\ThirdParty\build`.
* _Configure_ -> Target: _MSYS Makefile_ -> _Specify native compilers_ -> C: `c:\mingw-w64\mingw64\bin\gcc.exe`; C++ `c:\mingw-w64\mingw64\bin\g++.exe`
* If CMake reports a missing build program, enable the __Advanced__ configuration settings -> Set __CMAKE_MAKE_PROGRAM__ to `c:/mingw-w64/msys/bin/make.exe` -> _Configure_.
* If CMake-GUI fails to find the _winpthread-1.dll_, start CMake-GUI by calling `cmake-gui` from within the MSYS-console. This changes the paths variable to include the compiler installation folder.
* You should now have a list of libraries you can build. Unselect the ones, you don't want to compile. The entries' tooltips provide hints if the libraries are important for you. 
	* OpenCollada takes very long to build!
* Hit __Configure__ again and then __Generate__. The MSYS makefile will be generated into the build folder.

* Open a MSYS shell.
* Navigate into build folder: `cd /c/PADrend/ThirdParty/build`
* Start the build process: `cmake --build .`
* If the build process fails, try restarting the build: `cmake --build .`
* If the build process fails repeatedly for a library, exclude that library from the build (using CMake-GUI to recreate the target).
* Finally, copy all dll-files from the folder `C:\PADrend\ThirdParty\x64_64-w64-mingw32\bin` into the folder `C:\PADrend`.

* The libraries should be rebuilt whenever you upgrade the used compiler.

### Build PADrend (command line via Ninja)
For building PADrend (not the third party libraries!) the [Ninja](https://github.com/martine/ninja) build system can be used.

* A binary release can be found here: [https://github.com/martine/ninja/releases](https://github.com/martine/ninja/releases)
* Proposal: Copy the `ninja.exe` into your `mingw-w64/mingw64/bin` folder, so that it can easily be found.

To build PADrend:

* Open CMake-GUI.
* Set the source path to `C:\PADrend` and the build path to `C:\PADrend\build`.
* _Configure_ -> Target: _Ninja_ -> _Specify native compilers_ -> C: `c:\mingw-w64\mingw64\bin\gcc.exe`; C++ `c:\mingw-w64\mingw64\bin\g++.exe`
* If CMake reports a missing build program, enable the __Advanced__ configuration settings -> Set __CMAKE_MAKE_PROGRAM__ to `c:/mingw-w64/msys/bin/make.exe` -> _Configure_.
* You should now have a list of MinSG-Extensions you can build. Select the ones to compile. The following list is a recommendation if you don't know which ones to choose:
	* MINSG_EXT_BLUE_SURFELS, MINSG_EXT_COLORCUBES , MINSG_EXT_EVALUATORS , MINSG_EXT_IMAGECOMPARE,  MINSG_EXT_PARTICLES , MINSG_EXT_SVS , MINSG_EXT_TRIANGULATION, MINSG_EXT_WAYPOINTS, MINSG_EXT_VISIBILITY_SUBDIVISION.
* Setting the following compiler flags (`CMAKE_CXX_FLAGS`) is recommended:
  ` -pedantic -Wall -Wextra -Wshadow -Wcast-qual -Wcast-align -Wlogical-op -Wredundant-decls -Wdisabled-optimization -Wstack-protector -Winit-self -Wmissing-include-dirs -Wswitch-default -Wswitch-enum -Wabi -Wctor-dtor-privacy -Wstrict-null-sentinel -Wno-non-template-friend -Wold-style-cast -Woverloaded-virtual -Wno-pmf-conversions -Wsign-promo -Wmissing-declarations -Wno-abi`
* The variable `OPENAL_INCLUDE_DIR` set by CMake ends with `AL/`. Remove that suffix. Otherwise, the compiler may report: `fatal error: AL/al.h: No such file or directory`

* Hit _Configure_ again and then _Generate_. The Ninja-makefile will be generated.
* Open a MSYS shell.
* Navigate into build folder: `cd /c/PADrend`
* Start the build process: `ninja`

### Build PADrend (CodeBlocks IDE)
**Note: This method is deprecated and might not work anymore.**

One possible IDE for developing PADrend is CodeBlocks.
To setup CodeBlocks:

* Download and install (=extract) the latest version from [here](http://forums.codeblocks.org/index.php/board,20.0.html).
  Make sure to follow the instructions on the download page regarding the additional dlls to install.
	* To setup the MinGW compiler in CodeBlocks, open CodeBlocks -> _Settings_ -> _Compiler..._ -> _GNU GCC Compiler_ -> _Toolchain executables_
		* Compiler's installation directory: `c:\mingw-w64\mingw64`
		* C Compiler: gcc.exe
		* C++ Compiler: g++.exe
		* Linker for dynamic libs: g++.exe
	* To parallelize the build process: open CodeBlocks -> _Settings_ -> _Compiler..._ -> _GNU GCC Compiler_ -> _Build options_ -> _Number of processes for parallel builds_: number of your cpus.
	* __Important:__ Configure line endings:  _Settings_ -> _Editor..._ -> _General settings_ -> _End-of-line mode_ : __LF__ (and disable _Strip trailing blanks_).
* Download and install the build file generator for CodeBlocks: EkkiEkkiKateng from [here](https://github.com/ClaudiusJ/EkkiEkkiKateng/releases).
	* Recommended installation folder: `c:\mingw-w64\EkkiEkkiKateng`  
	* To install it into your _Program files_ folder, you have to run the installer with administrator privileges (right-click on the installer -> install as administrator).
	* The EkkiEkkiKateng folder contains files for syntax highlighting EScript files in CodeBlocks.
     To enabled them, copy the files located in `???\EkkiEkkiKateng\resources\CodeBlocks\lexers` to `???\CodeBlocks\share\CodeBlocks\lexers`.

To create or update the project file:

* Open the file `c:\PADrend\PADrend\PADrend.ekki` with EkkiEkkiKateng. 
  If the EkkiEkkiKateng installer failed to associate the file ending, open it with the _EScript.exe_ located in the EkkiEkkiKateng installation folder.
  Now, the generator script scans the available libraries and files, and creates the configuration file `c:\PADrend\PADrend\PADrend.txt` and the project file `c:\PADrend\PADrend.cbp`.
* (optional) Open the configuration file with a (proper = not Notepad) text editor and configure the extensions, you want to include in the build.
  Here you can also adjust the used compiler options.
  To apply the changes to the project file, re-run the __PADrend.ekki__-script.
* Open the project file in CodeBlocks.
  The build target to build/update all modules at once is _PADrendApp(dbg)_ or _PADrendApp(release)_.
  To start PADrend from within CodeBlocks: _green triangle_ -> select the _PADrend(debug)_ or _PADrend(release)_ to provide the main executable.

Notes:

* After new files are added or files are removed, re-run the __PADrend.ekki__-script -- don't update your project file manually, as all those changes will be overwritten on the next update.
* If you get an error when starting the compiled PADrend (like _Application error 0xc000007b_), copy the following DLLs from your compiler folder into the PADrend folder: _libgcc_s_sjlj-1.dll_, _libstdc++-6.dll_, and _libwinpthread-1.dll_.
  If the problem persists, you can use a tool like [DependencyWalker](http://www.dependencywalker.com/) to identify missing DLLs.

### Build PADrend (Eclipse or other)
See the process for building with Ninja, but choose another target. Not all targets are guaranteed to work!

### Notes 
* Make sure the path where PADrend is located is short (e.g.`d:/PADrend`)! Otherwise some libraries (especially OpenCollada) can not be built due to too long path names.
* If MSYS does not find the `patch` command, install it using:

`mingw-get install msys-patch`

* If the `patch` command exits with a "permission denied" error, run MSYS as administrator.
* When using MinGW in a 32-bit version, set `CMAKE_C_FLAGS` to `-march=i586`. Without this, you probably will get [linker errors](http://stackoverflow.com/questions/130740/link-error-when-compiling-gcc-atomic-operation-in-32-bit-mode) when building OpenAL.
* If receiving the error "expecting string instruction after rep", read the bug report [http://sourceforge.net/p/mingw/bugs/2031/](http://sourceforge.net/p/mingw/bugs/2031/)
* If the linker reports `undefined reference to '__gxx_personality_v0'` (or similar), add `-lstdc++` to the CMake parameter `CMAKE_CXX_STANDARD_LIBRARIES`.
 You may also consider adding `-shared-libstdc++` to `CMAKE_CXX_FLAGS` (result is not confirmed.).
* If CMake-GUI complains about a missing `libiconv-2.dll`, just copy it from your `MinGW/bin` folder into your CMake `bin` folder.
* If CMake-GUI complains about a missing `windres.exe`, check the path. The auto detection may fail here.
* If you choose a MSYS-build, make sure to check the `CMAKE_MAKE_PROGRAM` parameter. CMake tends to find the wrong MSYS environment if you have multiple ones.
* Instead of the built version of OpenAL32.dll, you may use the official [OpenAL-installer](http://www.openal.org/) version of the library. It provides better sound quality, but you have to install the OpenAL-Runtime (oalinst.exe) on your system in order to start PADrend.


### Compiler versions
* __TDM-GCC 32bit 4.9.2__ (''gcc (tdm-1) 4.9.2''; OpenCOLLADA and OpenCL skipped; no adaptations necessary for building libs, search paths must be adapted in PADrend.ekki.txt) (claudius, 2015-02-25)
* ~ ~__TDM-GCC 64bit 4.7.1__ (''gcc (tdm64-1) 4.7.1''; no c++11-thread support) (claudius, 2015-02-25)~ ~

----

## Linux

### Requirements 
#### C++ compiler (C++11 compatible)
To compile the libraries of PADrend, a C++ compiler is needed.
Any modern C++ compiler that has support for [C++11](https://macabeo.cs.upb.de/trac/AlgoCG/wiki/C%2B%2B11) should (in principle) be able to compile PADrend.
Make sure that your C++ compiler works as expected by compiling a simple C++ program (e.g. the program from [Wikipedia: C++](http://en.wikipedia.org/wiki/C++#Language_features)).

* On GNU/Linux and OS X, you can choose between [GCC](http://gcc.gnu.org/)  (>=4.7) and [ Clang](http://clang.llvm.org/) (>=3.1).
* Windows: A MinGW-distribution should be used ([ MinGW](http://www.mingw.org/)).
  The currently recommended distribution is  [http://tdm-gcc.tdragon.net/](http://tdm-gcc.tdragon.net/) for both, 32- and 64 bit.
	* If you run into problems, consider [adding the MinGW binaries to the PATH environment variable](http://www.mingw.org/wiki/Getting_Started#toc4).
	* Only compilers using  ljsj exception handling are supported; dwarf2 is not supported.
	* The installation path of the compiler should contain no spaces; proposed path: `C:\MinGW`
	* Following versions are known to produce problems:
		* 4.7.X std::array::at sometimes returns wrong values
			* To use [TDM-GCC 4.7.1-3 64bit](http://sourceforge.net/projects/tdm-gcc/files/TDM-GCC%20Installer/Previous/1.1006.0/) replace the file `MinGW\lib\gcc\x86_64-w64-mingw32\4.7.1\include\c++\array` with this patched version: [attachment:array] <!--TODO: No idea how to handle the attachment -->
		* 4.8.1 Bullet physics library can not be compiled [http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58165](http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58165)

#### CMake (>=2.8.11)
The build system of PADrend is [CMake](http://www.cmake.org/).
CMake creates a project for your IDE, or a Makefile, that uses the C++ compiler to compile PADrend.
Install CMake by [downloading it](http://www.cmake.org/cmake/resources/software.html) or by using your package manager (e.g. the [package cmake-qt-gui for Debian](http://packages.debian.org/cmake-qt-gui)).
Currently, you need at least CMake in version 2.8.11 to build PADrend.

#### (optional) Ninja build system
For building PADrend (not the libraries!) the [Ninja](https://github.com/martine/ninja) build system can be used.

#### Choose your IDE
* We recommend using [Atom](https://atom.io/) with the plugins [autocomplete-clang](https://atom.io/packages/autocomplete-clang), [linter-clang](https://atom.io/packages/linter-clang) and [language-escript](https://atom.io/packages/language-escript) (a detailed guide how to set up Atom is in the works).

### Getting the source
* You need GIT to get the source.
* If it is not already installed on your machine you should be able to simply install it using your favorite package manager (e.g., `apt-get install git`)
* (Public open source part) Clone the repository `https://github.com/PADrend/PADrendComplete.git` into `~/PADrend` using the `--recursive` option (See a git manual for details.).
 All required (Open Source) repositories are embedded as submodules.
* (Closed source part; optional; needs permission to access) Clone the repository `https://git.cs.upb.de/algoCG/extPlugins.git` into the `~/PADrend/extPlugins` folder.

### Building the external libraries
Some of the external libraries are required.
Others are optional and add additional functionality to PADrend.

On GNU/Linux, there are packaged versions of the required libraries.
For example, for Debian you should install 
[libcurl4-openssl-dev](http://packages.debian.org/libcurl4-openssl-dev), 
[libglew-dev](http://packages.debian.org/libglew-dev), 
[libopenal-dev](http://packages.debian.org/libopenal-dev), 
[libpng-dev](http://packages.debian.org/libpng-dev), 
[libsdl2-dev](http://packages.debian.org/libsdl2-dev), 
[libsdl2-image-dev](http://packages.debian.org/libsdl-image1.2-dev), 
[libsdl2-net-dev](http://packages.debian.org/libsdl-net1.2-dev), 
[libsqlite3-dev](http://packages.debian.org/libsqlite3-dev), 
[libxml2-dev](http://packages.debian.org/libxml2-dev), 
[libzip-dev](http://packages.debian.org/libzip-dev), 
[libfreetype6-dev](http://packages.debian.org/libfreetype6-dev), 
[libarchive-dev](http://packages.debian.org/libarchive-dev), 
and [zlib1g-dev](http://packages.debian.org/zlib1g-dev):

	sudo apt install libcurl4-openssl-dev libglew-dev libopenal-dev libpng-dev libsdl2-dev libsdl2-image-dev libsdl2-net-dev libsqlite3-dev libxml2-dev libzip-dev libfreetype6-dev libarchive-dev zlib1g-dev

When using OS X, you can check if there are development packages of the required libraries that you can install (e.g. by using [Fink](http://www.finkproject.org/) or [MacPorts](http://www.macports.org/)).
Otherwise, you have to compile the external libraries yourself.

To build the external libraries on any platform, open a command prompt (Terminal on OS X, MSYS on Windows).
Go into the `ThirdParty` directory of PADrend.
Create a new build directory for building the external libraries.
Use CMake to generate a project file.
In this step, make sure that you specify the correct compiler (e.g. Clang instead of GCC on OS X).
After that, start the build.
In many cases, the following commands are enough to build all libraries:

	cd ThirdParty
	mkdir build
	cd build
	cmake ..
	cmake --build .

You need a connection to the Internet during this step, because the sources of the external libraries are automatically downloaded.
The libraries and their headers are installed into a directory inside the `ThirdParty` directory (e.g. `mingw32`, `x86_64-linux-gnu` or `x86_64-w64-mingw32`).

##### Notes
* Generally, it is possible to use a compiler for building the external libraries that is different from the compiler used for building PADrend. To avoid problems, you should use the same compiler for both builds.

----

### Building PADrend
You should do an [out-of source build](http://www.cmake.org/Wiki/CMake_FAQ#What_is_an_.22out-of-source.22_build.3F).
For this purpose, you have to create a separate build directory.
Now, you have to tell CMake to use the PADrend directory as source directory and the newly created directory as build directory.
Using the command line, you can do it like this:

	mkdir build
	cd build
	cmake ..

If you are using CMake's GUI, click "Configure", after setting up the two directories.
Depending on your system, CMake might ask you where your C/C++ compiler is located and what kind of project you want it to generate.
If you want to use Makefiles on Windows, choose "MSYS Makefiles".

When using Makefiles, the build type can be changed by setting the variable [CMAKE_BUILD_TYPE](http://cmake.org/cmake/help/v2.8.8/cmake.html#variable:CMAKE_BUILD_TYPE) either in the GUI or by using for instance `-DCMAKE_BUILD_TYPE=RelWithDebInfo` on the command line.

#### Generating the build files
If the configuration step worked without problems (CMake tells you "Configuring done"), you can click on the "Generate" button.
If that step also worked without problems (CMake tells you "Generating done"), you can exit CMake.

#### Building the project
The way how to build the project differs depending on the generator that was used by CMake.
If you generated a project for your IDE (e.g. Eclipse, Code::Blocks), open the project from the build directory with your IDE.
Then, use your IDE to build the project.
If you generated Makefiles, simply call `make` (or `mingw32-make.exe` on Windows) from the build directory to build.

#### Notes (general)
* The variable `OPENAL_INCLUDE_DIR` set by CMake ends with `AL/`. Remove that suffix. Otherwise, the compiler may report: `fatal error: AL/al.h: No such file or directory`

#### Notes (Clang on Linux)
* Setting the following compiler flags (`CMAKE_CXX_FLAGS`) is recommended:
  `-pedantic -Wall -Wextra -Wshadow -Wcast-qual -Wcast-align -Wredundant-decls -Wdisabled-optimization -Winit-self -Wmissing-include-dirs -Wswitch-default -Wswitch-enum -Wabi -Wctor-dtor-privacy -Wold-style-cast -Woverloaded-virtual -Wsign-promo`
  (See [Warning Options](http://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html#Warning-Options) and [C++ Dialect Options](http://gcc.gnu.org/onlinedocs/gcc/C_002b_002b-Dialect-Options.html#C_002b_002b-Dialect-Options).)

#### Notes (GCC on Linux) 
* Setting the following compiler flags (`CMAKE_CXX_FLAGS`) is recommended:
  `-ansi -pedantic -Wall -Wextra -Wshadow -Wcast-qual -Wcast-align -Wlogical-op -Wredundant-decls -Wdisabled-optimization -Wstack-protector -Winit-self -Wmissing-include-dirs -Wswitch-default -Wswitch-enum -Wabi -Wctor-dtor-privacy -Wstrict-null-sentinel -Wno-non-template-friend -Wold-style-cast -Woverloaded-virtual -Wno-pmf-conversions -Wsign-promo -Wmissing-declarations -Wunused-local-typedefs -Wzero-as-null-pointer-constant`
  (See [Warning Options](http://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html#Warning-Options) and [C++ Dialect Options](http://gcc.gnu.org/onlinedocs/gcc/C_002b_002b-Dialect-Options.html#C_002b_002b-Dialect-Options).)

----

### Starting PADrend
If you generated a project for your IDE, you can start PADrend out of your IDE.
Make sure that the source directory of PADrend is used as working directory.
Otherwise, PADrend will not be able to find external files that are required.
With Makefiles, do the following:

	cd ..
	build/PADrendMain

On Windows, the external libraries have to be located in the working directory of PADrend.
Therefore, you have to copy all the `.dll` files from `libs/${ARCH_TRIPLET}/bin` into the working directory (e.g. by executing `cp libs/x86_64-w64-mingw32/bin/*.dll .`).
