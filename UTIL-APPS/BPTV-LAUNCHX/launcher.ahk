/*
**************************************************************************************************
buttonpushertv LaunchX
-a modified version of the following script:
LAUNCH-X-by, KAMAL AWASTHI
https://github.com/KamalAwasthi/Launchx
**************************************************************************************************
I needed a script to present me with some options of which apps to load on boot of my system. Kamal's
script had a bunch of the things I was looking for. I have modified this version for the way I needed it
to work. I've stripped out the functions I don't need and pared it down to the basics.

For my needs, here a few of the main issues:
	- LAUNCHER.AHK will be auto-launched at boot/login. I generally do not need it to be run via a Hotkey.
	- I've only kept the AHK version
	- I've removed the Help and Settings sections, since it's straight forward enough & things aren't going to
	  change much once it's in place
	  
Enjoy - Ben
*/


;===== START OF AUTO-EXECUTION SECTION =========================================================
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; #Persistent ; Keeps script permanently running.
#SingleInstance force ; Ensures that there is only a single instance of this script running.
; SetTitleMatchMode, 2 ; sets title matching to search for "containing" instead of "exact"
SetBatchLines, -1

;===== INITIALIZATION - VARIABLES ==============================================================
; Sleep shortcuts - use these to standardize sleep times. Change here to change everywhere.
sleepMicro := 15
sleepShort := 333
sleepMedium := 666
sleepLong := 1500
sleepDeep := 3500


FileReadLine,current,settings.ini,3

;Reading the ini file

IniRead,currentfile,settings.ini,filelog,current
   if(currentfile= "ERROR")
   {
      IniWrite,0,settings.ini,filelog,current
   }
IniRead,nextfile,settings.ini,filelog,next
   if(nextfile= "ERROR")
   {
      IniWrite,1,settings.ini,filelog,next
   }
IniRead,current3,settings.ini,filelog,extra
   if(current3= "ERROR")
   {
      IniWrite,0,settings.ini,filelog,extra
   }

/*
******************************
Controlling the window styles
******************************
*/

Gui,+AlwaysOnTop +Border +Caption +e0x80 +Toolwindow
TransColor = D4D1CF
Gui, Color, %transColor%

/*
***********
 GLOBALS
***********
*/
global x_axis:=10
global y_axis:=10
global Array := Object()
global Path := Object()
global count:=0
global width:=150
global height:=45
global spacer:=10

;Menu,logo.png,,1
Menu, Tray, Icon,,,1

;===== END OF AUTO-EXECUTE =====================================================================
;===== MODIFIER MEMORY HELPER ==================================================================
; combine below with key and '::' to define hotkey 
; e.g.- ^f1::Msgbox You pressed Control and F1
; #=Win | !=Alt | ^=Ctrl | +=Shift | &=combine keys | *=ignore other mods
; <=use left mod key| >=use right mod key  | UP=fires on release

;===== MAIN HOTKEY DEFINITIONS HERE ============================================================

Gui, Color,5865d8
 WinSet, Transparent, 190
Loop, Read, path%currentfile%.ka ;LOOP TO READ THE BUTTON FILE
{
    Array.Insert(A_LoopReadLine) 
}


Loop, Read,run%currentfile%.ka ;LOOP TO READ THE PATH FILE
{
  Path.Insert(A_LoopReadLine)
}

gui, font, s10 CBlue, Verdana ;SETTING THE FONT

for index, element in Array ;ADDING THE BUTTONS ON WINDOW
{
	;Gui,Color,EEAA99
	;Gui, Font, s10 CWhite, Verdana 
  Gui,Add,Button,gArray%A_Index%  X%x_axis%  Y%y_axis% w%width% h%height%, %   "" . element

if (x_axis>330) ;SETTING THE POSITONS OF BUTTONS
	{
	x_axis:=10
	y_axis:=y_axis+(height+spacer)
	}
else
	{
	x_axis:=x_axis+(width+spacer)
	}

 count:=count+1
}

y_axis:=y_axis+(height+spacer*3)
x_axis:=90
height:=30
; change the above value to 10 if you enable the Delete All button below. Otherwise it should be 90.
;Gui,Add,Button,x%x_axis% y%y_axis% w%width% h%height% CBlue,&Delete_All ;adding the DELETE ALL button
;x_axis:=(x_axis+width+spacer)
Gui,Add,Button,x%x_axis% y%y_axis% w%width% h%height% cWhite gDelete ,&Remove A Button ;ADDING THE Remove BUTTON
x_axis:=(x_axis+width+spacer)
Gui,Add,Button,x%x_axis% y%y_axis% w%width% h%height% cWhite ,&Add_New ;ADDING THE +ADD BUTTON
x_axis:=(x_axis+width+spacer)
Gui,Add,Button,x%x_axis% y%y_axis% w%width% h%height% CBlue, &Exit_App ;ADDING THE CLOSE BUTTON
Gui,Show,w650,buttonpusherTV Launch-X ;PUTS ALL GUI ON WINDOW
return

Esc::
ExitApp
return

/*
*****************************
end of main programe
*****************************
*/

quit:
ButtonExit_App: ;g-LABEL FOR CLOSE BUTTON
GuiClose: 
ExitApp
return 

Delete_All:
FileDelete,path%currentfile%.ka
FileDelete,run%currentfile%.ka
Reload
return

Delete:
Run,delete.ahk
return

ButtonDelete_All:
MsgBox, 262436, Delete All Buttons?, Are you sure you want to delete all buttons?
IfMsgBox Yes
	gosub, Delete_All
IfMsgBox No
	Reload
	return

afterClick:
	;gosub quit
	return

/*
****************************
 BUTTON EVENTS
****************************
*/
Array1:
t:=Path[1]
Run,%t%
gosub afterClick
return

Array2:
t:=Path[2]
Run,%t%
gosub afterClick
return

Array3:
t:=Path[3]
Run,%t%
gosub afterClick
return

Array4:
t:=Path[4]
Run,%t%
gosub afterClick
return

Array5:
g:=Path[5]
Run,%g%
ExitApp
return

Array6:
g:=Path[6]
Run,%g%
ExitApp
return

Array7:
g:=Path[7]
Run,%g%
ExitApp
return

Array8:
g:=Path[8]
Run,%g%
ExitApp
return

Array9:
g:=Path[9]
Run,%g%
ExitApp
return

Array10:
g:=Path[10]
Run,%g%
ExitApp
return

Array11:
g:=Path[11]
Run,%g%
ExitApp
return

Array12:
g:=Path[12]
Run,%g%
ExitApp
return

Array13:
g:=Path[13]
Run,%g%
ExitApp
return

Array14:
g:=Path[14]
Run,%g%
ExitApp
return

Array15:
g:=Path[15]
Run,%g%
ExitApp
return

Array16:
g:=Path[16]
Run,%g%
ExitApp
return

Array17:
g:=Path[17]
Run,%g%
ExitApp
return

Array18:
g:=Path[18]
Run,%g%
ExitApp
return

Array19:
g:=Path[`9]
Run,%g%
ExitApp
return

Array20:
g:=Path[20]
Run,%g%
ExitApp
return


/*
**************************
newhotkey
**************************
*/
newkey:
Gui, 2:Submit, Nohide
Gui, 2:+AlwaysOnTop +Border +Caption -e0x90 +Toolwindow
IfNotEqual, hotkey
{
Fileatline("settings.ini", hotkey, 3)
Hotkey,%current%,ShowGUI, Off
Hotkey,%hotkey%,ShowGUI, On
current := hotkey
}
return

/*
***************************
Show Shortcut Reset window
***************************
*/
ShowGui:
WinActivate,Launch-X
return

/*
****************
+ADD_EVENT
****************
*/
ButtonAdd_New:
Gui,3:Color,0xefe6a3
Gui,3:+AlwaysOnTop +Border +Caption -e0x90 +Toolwindow
TransColor = D4D1CF
Gui,3:Font,S10 CBlue, Verdana
Gui,3:Add,Text, x20 y10 w150 h30,_Add New?
Gui,3:Add,Button,x15 y70 w100 h30 gfolder ,&Folder
Gui,3:Add,Button,x135 y70 w100 h30 gfile,&File
Gui,3:Add,Button,x190 y140 w55 h30 gcan,&Cancel
Gui,3:Show,w250 h180,Selection
return

can:
Gui,3:Hide
return

folder:
Gui, 3:+LastFound +OwnDialogs +AlwaysOnTop
Gui,3:Hide
InputBox, OutputVar, File Name, Button name?`n(Text will be centered.)`n(Names over 20 chars will be split on multiple lines.)  ;ASKING THE BUTTON NAME
if  OutputVar=                                 ;IF NONE IS SELECTED , RETURN
return
 FileSelectFolder,Path, ,3,Select the Folder
 if Path=                                        ;IF INPUT IS EMPTY,RETURN ,OTHERWISE CONTINUE
return
 FileAppend,        
(
%OutputVar% 

), path%currentfile%.ka
FileAppend,
(
%Path%
 
),run%currentfile%.ka
Reload
return

file:
Gui, 3:+LastFound +OwnDialogs +AlwaysOnTop
Gui,3:Hide
InputBox, OutputVar, File Name, Button name?`n(Text will be centered.)`n(Names over 20 chars will be split on multiple lines.)   ;ASKING THE BUTTON NAME
if  OutputVar=                                 ;IF NONE IS SELECTED , RETURN
return
FileSelectFile,Path, , 3, Select the file
if Path=                                        ;IF INPUT IS EMPTY,RETURN ,OTHERWISE CONTINUE
return
FileAppend,        
(
%OutputVar% 

), path%currentfile%.ka


FileAppend,
(
%Path%
 
),run%currentfile%.ka
Reload
return


/*
**********************
Functions definition
**********************
*/
FILEATLINE(file, filecon, number){
loop
{
	FileReadLine,readline,%file%,%A_index%
	if Errorlevel = 1
		lineended := true , readline := ""

	if !(A_index == number)
		filedata .= readline . "`r`n"
	else
		filedata .= filecon . "`r`n"

	if (A_index >= number)
		if (lineended)
			break
}
StringTrimRight,filedata,filedata,2
FileDelete, %file%
FileAppend, %filedata%, %file%
}

Browse(site){
RegRead, OutputVar, HKEY_CLASSES_ROOT, http\shell\open\command 
  run,% "iexplore.exe" . " """ . site . """"	;internet explorer
}
