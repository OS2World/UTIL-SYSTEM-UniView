                            --- UniView 0.2_1 - README ---

PLEASE REMEMBER:
This is beta software. I am not a professional programer, so if this program does anything bad
(deleting important files, setting your house on fire, etc.) it is only your fault! If it does good things
I am responsible, of course. 


	- License

UniView 0.2_1
Copyright 2016 Laurenz Sommer

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this program except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

A copy of the Apache License, Version 2.0, can be found in the file "Apache License 2.0.txt",
which should be distributed with this program.


	- Files

Apache License 2.0.txt: a copy of the Apache License 2.0 under which this program is licensed
README.TXT: this file
SOURCE.ZIP: sources and build instructions
UNIVIEW.CFG: sample configuration file
UNIVIEW.EXE: the program


	- General

UniView was written by Laurenz Sommer. It's purpose is to make the usage of *.hlp and *.inf
files easier.
The problem with *.hlp and *.inf files under OS/2 is, that OS/2 help files, Windows help files
and some configuration-files (e. g. for Windows Drivers) use this file extensions. If you associate
this two extension to the OS/2 help viewer VIEW.EXE you'll get an error, whenever you open a file
which is not an OS/2 help file. NewView by Aaron Lawrence may route Windows help files to WIN-OS/2's
WINHELP.EXE but this program is restricted by the 8.3 file name limitation of WIN-OS/2 programs.

UniView solves this problems by determining the file type (OS/2 help file, Windows help file or
unknown) of the opened file and opening the file with the right program.

To by honest, this is not my idea, but Salvador Parra Camacho's, who's program "Intelligent View"
does basically the same as UniView but has a huge limitation: It can't open files with spaces in the
file name or path.
So I wrote this program, using REXX as language and compiled it to an executable, using Dennis Bareis'
REXX compiler "REXX2EXE" to allow the program the usage of RxMessageBoxes and hide the command windows
popping up when executing the .cmd file.


	- Installation

Simply copy UNIVIEW.EXE somewhere on your hard disk and associate *.hlp and *.inf files
with UNIVIEW.EXE.
To do so, open the exe's notebook and switch to the "Association" tab. At the area "new name" type "*.hlp"
(without the quotes) and add and "*.inf" and add (the used terms may differ according to your
systems language, because I'm using an german OS/2 I do not even know, if the english ones are correct).
If you are using XWorkplace and the turbo folder feature is enabled, the way to associate *.hlp and
*.inf files to UNIVIEW.EXE is completely different:
Open the Workplace Shell object in the systems configuration folder. At the first tab "File Types"
search for a file type called "Help File" or similar. If it does not exist, you'll have to create it:
Click at the area "File types" with the right mouse button and select "Create root type". Enter a
name for the new type (e. g. Help File) and click "OK".
Now add the filters for *.hlp and *.inf files: Select the "Help files" type in the "File types" area,
right-click the area "Filters" and select "New Filter". Enter "*.hlp" and
press "OK". Repeat this step for "*.inf".
Finally you have to associate the UNIVIEW.EXE with this file type: Select the "Help files" type in
the "File types" area and then simply drag and drop UNIVIEW.EXE to the "Associations" area.

At the first time you open a file with UniView, UniView will create a configuration file. You may
edit this file with a text editor to use other programs than the default ones. Do not remove the two "
in each configuration line, because they are needed by UniView to correctly determine the programs path.
Use full qualified paths only! 

If you have Odin installed  and are owner of a license for Windows 98 (other versions of Windows are
not tested, but may work) you may use WINHLP32.EXE instead of WINHELP.EXE. WINHLP32, in opposite to
Windows 3.1's WINHELP, can handle file names which exceed the 8.3 file name limitation.
To use WINHLP32 you have to copy winhlp32.exe to the system32 directory of your Odin installation.
This file may be found in the WINDOWS directory of your Windows installation or in the file "WIN98_45.CAB"
at the Windows 98 CD-ROM.
If UniView finds Odin and WINHLP32.EXE when creating the configuration file, it will use them by default.
If not, you have to edit the configuration file, which is named "uniview.cfg" and is located in the
same directory as the OS2.INI (usally X:\OS2\). Edit the ODIN and the WINDOWS statement, e. g.:

ODIN = "D:\ODIN\SYSTEM32\PE.EXE"
WINDOWS = "D:\ODIN\SYSTEM32\WINHLP32.EXE"


	- Building

See source.zip.


	- Acknowledgements

Many thanks to
- Salvador Parra Camacho for his program "Intelligent View", which inspired me to write UniView,
- Dennis Bareis for his REXX compiler REXX2EXE version 99.349 (C)opyright Dennis Bareis 1994,
- Ludwig van Beethoven for his wonderful Symphony No. 7.


	- Changelog

11.9.2016:	First public release, UniView 0.1

21.11.2016:	Improvements in parsing UNIVIEW.CFG, compiled Icon into EXE, Testing with Warp 3,
		improved message Boxes (thanks to Jeff Glatt for his REXX-tutorial and "dargndorp"
		from the os2.org forum for showing it to me), UniView 0.2

31.1.2017:	Bug fix for compatibility with 4OS2. Files weren't opend if COMSPEC was set to 4OS2.
		UniView 0.2_1
		

	- Contact

If you want to contribute anything to this little program, want to report a bug, have a question or
anything else related to UniView, please send an email to rexfahrer@googlemail.com. If you speak German,
you may write in German, but English is welcome, too.
