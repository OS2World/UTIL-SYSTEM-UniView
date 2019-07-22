/* This file is a part of UniView 0.2_1						*/
/* Copyright 2016-2017 Laurenz Sommer						*/

/* Licensed under the Apache License, Version 2.0 (the "License");		*/
/* you may not use this file except in compliance with the License.		*/
/* You may obtain a copy of the License at					*/

/*     http://www.apache.org/licenses/LICENSE-2.0				*/

/* Unless required by applicable law or agreed to in writing, software		*/
/* distributed under the License is distributed on an "AS IS" BASIS,		*/
/* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.	*/
/* See the License for the specific language governing permissions and		*/
/* limitations under the License.						*/

/* Changelog									*/
/*  11.9.2016:	Initial public release. Version 0.1				*/
/* 21.11.2016:	Improvements in parsing UNIVIEW.CFG, improved message Boxes 	*/
/*		(thanks to Jeff Glatt for his REXX-tutorial and "dargndorp"	*/
/*		from the os2.org forum for showing it to me). Version 0.2	*/
/*   3.1.2017:	bug-fix for compatibility with 4OS2. Version 0.2_1		*/


call RxFuncAdd 'SysLoadFuncs', 'RexxUtil', 'SysLoadFuncs'
call SysLoadFuncs

parse arg datei

if left(datei,1) = '"' then datei = substr(datei, pos('"', datei)+1, lastpos('"', datei)-pos('"', datei)-1)

If datei = '' then do
	if left(value('LANG',,'OS2ENVIRONMENT'), 3) = 'de_' then do 
		usage = 'Verwendung:' || '0A'x || 'UNIVIEW.EXE "Dateiname"' || '0A'x || '0A'x
		usage = usage||'UniView 0.2_1' || '0A'x
		usage = usage||'Copyright 2016-2017 Laurenz Sommer' || '0A'x || '0A'x
		usage = usage||'Lizenziert gemÑ· den Bedingungen der Apache License, Version 2.0. Die Benutzung dieses Programms ist nur in öbereinstimmung mit dieser Lizenz erlaubt. Sie finden den Text der Lizenz unter:' || '0A'x || 'http://www.apache.org/licenses/LICENSE-2.0'
	end
	else do
		usage = 'Usage:' || '0A'x || 'UNIVIEW.EXE "filename"' || '0A'x || '0A'x
		usage = usage||'UniView 0.2_1' || '0A'x
		usage = usage||'Copyright 2016-2017 Laurenz Sommer' || '0A'x || '0A'x
		usage = usage||'Licensed under the Apache License, Version 2.0 (the "License"); you may not use this program except in compliance with the License. You may obtain a copy of the License at:' || '0A'x || 'http://www.apache.org/licenses/LICENSE-2.0'
	end
	call RxMessageBox usage, 'Information:', 'OK', 'INFORMATION'
	exit
end

cfgdat = value('USER_INI',,'OS2ENVIRONMENT')
if substr(cfgdat,2,2) \= ':\' then cfgdat = SysBootDrive() || '\OS2\UNIVIEW.CFG' /* I am not sure, if USER_INI is set on all systems */
else cfgdat = left(cfgdat, lastpos('\',cfgdat))'UNIVIEW.CFG'

if pos('4OS2.EXE', translate(value('COMSPEC',,'OS2ENVIRONMENT'))) = 0 then os24 = 0
else os24 = 1

if stream(cfgdat,'c','query exists') = '' then do
	if left(value('LANG',,'OS2ENVIRONMENT'), 3) = 'de_' then do
		no_cfg_msg1 = 'Die Anzeige-Programme wurden noch nicht festgelegt. UniView wird nun automatisch die Standard-Werte festlegen. Wenn Sie diese Ñndern mîchten, bearbeiten Sie bitte die Datei "'
		no_cfg_msg2 = '" entsprechend.'
	end
	else do
		no_cfg_msg1 = 'The programs for the different file-types are not yet defined. UniView will set the default-values. If you want to edit them, edit the file "'
		no_cfg_msg2 = '".'
	end
	rc = RxMessageBox(no_cfg_msg1||cfgdat||no_cfg_msg2, 'Information:', 'OKCANCEL', 'INFORMATION')
	if rc = 1 then call setcfg
	else exit
end

/* read viewer-values from config-file */
call SysFileSearch '=', cfgdat, zeile
configheader = linein(cfgdat,1,1)
call lineout cfgdat

if configheader \= '# Configuration-file for UniView 0.1 by Laurenz Sommer.' then call corrupt

OS2 = ''
ODIN = ''
WINDOWS = ''
PLAIN = ''

do q=1 to zeile.0
	if left(zeile.q,1) = '#' then iterate
	if pos('"', zeile.q) = 0 then iterate
	if left(zeile.q,3) = 'OS2' then interpret zeile.q	
	if left(zeile.q,4) = 'ODIN' then interpret zeile.q
	if left(zeile.q,7) = 'WINDOWS' then interpret zeile.q
	if left(zeile.q,5) = 'PLAIN' then interpret zeile.q
end

/* determine file-type */
header = linein(datei,1,1)
call lineout datei

select
	when left(header,3) = '?_' then do
		if ODIN = '' then do
			if WINDOWS = '' then call nowin
			if stream(WINDOWS,'c','query exists') = '' then call nowin 
			if translate(right(WINDOWS,12)) = '\WINHELP.EXE' then '@start /win /pgm "'WINDOWS'" 'datei /* start is required, otherwise WINHELP will be opened in a fullscreen WIN-OS2 session */
			else do
				if \os24 then '@"'WINDOWS'" 'datei
				else '@start /win /pgm "'WINDOWS'" 'datei
			end
		end
		else do
			if WINDOWS = '' then call nowin
			if stream(WINDOWS,'c','query exists') = '' then call nowin
			if stream(ODIN,'c','query exists') = '' then call noodin
			if \os24 then '@"'ODIN'" "'WINDOWS'" 'datei
			else '@start /win /pgm "'ODIN'" "'WINDOWS'" 'datei
		end
	end
	when left(header,3) = 'HSP' then do
		if OS2 = '' then call noos2
		if stream(OS2,'c','query exists') = '' then call noos2
		if \os24 then '@"'OS2'" "'datei'"'
		else '@start /win /pgm "'OS2'" 'datei
	end

	otherwise do
		if PLAIN = '' then call nodef
		if stream(PLAIN,'c','query exists') = '' then call  nodef
		if \os24 then '@"'PLAIN'" "'datei'"'	
		else '@start /win /pgm "'PLAIN'" 'datei
	end
end

exit

setcfg:
	WINDOWS = ''
	ODIN = SysSearchPath('PATH', 'PE.EXE')
	if ODIN \= '' then WINDOWS = SysSearchPath('PATH', 'WINHLP32.EXE')
	if WINDOWS = '' then do
		WINDOWS = SysSearchPath('PATH', 'WINHELP.EXE')
		ODIN = ''
	end
	OS2 = SysSearchPath('PATH', 'NEWVIEW.EXE')
	if OS2 = '' then OS2 = 'VIEW.EXE'
	PLAIN = SysSearchPath('PATH', 'E.EXE')
	call lineout cfgdat, '# Configuration-file for UniView 0.1 by Laurenz Sommer.'
	call lineout cfgdat, '# Edit the paths below, so they match your needs. Do not remove the quotes.'
	call lineout cfgdat, ''
	call lineout cfgdat, '# This is the viewer for OS/2 help-files.'
	call lineout cfgdat, 'OS2 = "'OS2'"'
	call lineout cfgdat, '# This is the PE.EXE of Odin, with is required for WINHLP32. If you do not use the WIN32 HELP, leave this empty.'
	call lineout cfgdat, 'ODIN = "'ODIN'"'
	call lineout cfgdat, '# This is the viewer for Windows help-files. If you want to use WINHLP32.EXE, be sure to specify the ODIN variable.'
	call lineout cfgdat, 'WINDOWS = "'WINDOWS'"'
	call lineout cfgdat, '# This is the default viewer for files whichs file-type could not be determined.'
	call lineout cfgdat, 'PLAIN = "'PLAIN'"'
	call lineout cfgdat

return

corrupt:
	if left(value('LANG',,'OS2ENVIRONMENT'), 3) = 'de_' then corrup = 'Die Konfigurationsdatei ist anscheinend beschÑdigt.' || '0A'x || 'Lîschen Sie bitte die Datei "'cfgdat'" oder benennen Sie sie um und starten Sie UniView dann erneut.'
	else corrup = 'The configuration-file seems to be corrupted.' || '0A'x || 'Please delete or rename "'cfgdat'" and restart UniView.'
	call RxMessageBox corrup,, 'OK', 'ERROR'
	exit
return

nowin:
	if left(value('LANG',,'OS2ENVIRONMENT'), 3) = 'de_' then do
		nowinmsg = 'Das Anzeigeprogramm fÅr Windows-Hilfe-Dateien ist nicht richtig definiert.' || '0A'x
		nowinmsg = nowinmsg||'Bearbeiten oder lîschen Sie bitte die Datei "'cfgdat'" oder benennen Sie sie um und starten Sie UniView dann erneut.'
	end
	else do
		nowinmsg = 'The viewer for Windows help-files is not defined correctly.' || '0A'x
		nowinmsg = nowinmsg||'Please edit, delete or rename "'cfgdat'" and restart UniView.'
	end
	call RxMessageBox nowinmsg,, 'OK', 'ERROR'
	exit
return

noos2:
	if left(value('LANG',,'OS2ENVIRONMENT'), 3) = 'de_' then do
		noos2msg = 'Das Anzeigeprogramm fÅr OS/2-Hilfe-Dateien ist nicht richtig definiert.' || '0A'x
		noos2msg = noos2msg||'Bearbeiten oder lîschen Sie bitte die Datei "'cfgdat'" oder benennen Sie sie um und starten Sie UniView dann erneut.'
	end
	else do
		noos2msg = 'The viewer for OS/2 help-files is not defined correctly.' || '0A'x
		noos2msg = noos2msg||'Please edit, delete or rename "'cfgdat'" and restart UniView.'
	end
	call RxMessageBox noos2msg,, 'OK', 'ERROR'
	exit
return

nodef:
	if left(value('LANG',,'OS2ENVIRONMENT'), 3) = 'de_' then do
		nodefmsg = 'Das Standard-Anzeigeprogramm ist nicht richtig definiert.' || '0A'x
		nodefmsg = nodefmsg||'Bearbeiten oder lîschen Sie bitte die Datei "'cfgdat'" oder benennen Sie sie um und starten Sie UniView dann erneut.'
	end
	else do
		nodefmsg = 'The default viewer is not defined correctly.' || '0A'x
		nodefmsg = nodefmsg||'Please edit, delete or rename "'cfgdat'" and restart UniView.'
	end
	call RxMessageBox nodefmsg,, 'OK', 'ERROR'
	exit
return

noodin:
	if left(value('LANG',,'OS2ENVIRONMENT'), 3) = 'de_' then do
		noodinmsg = 'Der Pfad zum Odin-Programm PE.EXE ist nicht richtig definiert.' || '0A'x
		noodinmsg = noodinmsg||'Bearbeiten oder lîschen Sie bitte die Datei "'cfgdat'" oder benennen Sie sie um und starten Sie UniView dann erneut.'
	end
	else do
		noodinmsg = 'The location of the Odin program PE.EXE is not defined correctly.' || '0A'x
		noodinmsg = noodinmsg||'Please edit, delete or rename "'cfgdat'" and restart UniView.'
	end
	call RxMessageBox noodinmsg,, 'OK', 'ERROR'
	exit
return