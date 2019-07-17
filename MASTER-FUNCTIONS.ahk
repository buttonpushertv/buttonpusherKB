; AutoHotKey - MASTER-FUNCTIONS for inclusion into MASTER-SCRIPT.AHK
;by Ben Howard - ben@buttonpusher.tv

;===============================================================================================
;===== START OF AUTO-EXECUTION SECTION =========================================================
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; #Persistent ; Keeps script permanently running.
#SingleInstance force ; Ensures that there is only a single instance of this script running.
; SetTitleMatchMode, 2 ; sets title matching to search for "containing" instead of "exact"

;===== INITIALIZATION - VARIABLES ==============================================================
; Sleep shortcuts - use these to standardize sleep times
sleepMicro := 15
sleepShort := 333
sleepMedium := 666
sleepLong := 1500
sleepDeep := 3500

;===== END OF AUTO-EXECUTE =====================================================================
;===== MODIFIER MEMORY HELPER ==================================================================
; combine below with key and '::' to define hotkey
; e.g.- ^f1::Msgbox You pressed Control and F1
; #=Win | !=Alt | ^=Ctrl | +=Shift | &=combine keys | *=ignore other mods
; <=use left mod key| >=use right mod key  | UP=fires on release

;===== FUNCTIONS ===============================================================================

RemoveToolTip(duration) {
  SetTimer, ToolTipOff, %duration%
  Return

ToolTipOff:
    ToolTip
    return
}


timestamp(theTimeStamp) {
global
FormatTime, now,, hh:mm tt
today = %A_YYYY%-%A_MMM%-%A_DD%
theTimeStamp = %now% - %today%
}

ScrollLockOff() {
  SetTimer, ScrollLockToggle, 1000
  return

ScrollLockToggle:
  SetScrollLockState, off
  ToolTip, Scroll Lock Toggled Off.
  RemoveToolTip(-2000)
  SetTimer, ScrollLockToggle, Off
  Return

}


;for showText & showPic - I want to add code in that will downgrade to the next lowest code that does exist if it can't find whatever file it is sent.

showText(fileToShow){
  IfNotExist, %fileToShow%
    fileToShow := "SUPPORTING-FILES\AHK-KEYS-NO-CHEATSHEET.txt"
  FileRead, textToShow, %fileToShow%
  FormatTime, now,, hh:mm tt
  today = %A_YYYY%-%A_MMM%-%A_DD%
  Gui, Text:+alwaysontop +disabled -sysmenu +owner -caption +toolwindow +0x02000000
  Gui, Text:Color, 000000
  Gui, Text:Margin, 30, 30
  Gui, Text:font, s12 cFFFFFF, Consolas
  Gui, Text:Add, Text, , %now% - %today%
  Gui, Text:add, text, , %textToShow%
  Gui, Text:add, text, , File: %A_ScriptDir%\%fileToShow%
  Gui, Text:Show
return
}

showPic(picToShow, PictureWidth){
  SysGet, Mon1, Monitor, 1
  If (Mon1Right < PictureWidth)
    PictureWidth -= 425
  if !FileExist(picToShow) {
    picToShow := "SUPPORTING-FILES\NO-CHEAT-SHEET.png"
    PictureWidth := 579
  }
  Gui, Picture:+alwaysontop +disabled -sysmenu +owner -caption +toolwindow +0x02000000
  Gui, Picture:Color, 000000
  Gui, Picture:Margin, 15, 15
  Gui, Picture:font, s14 cFFFFFF, Consolas
  Gui, Picture:add, picture, w%PictureWidth% h-1 , %picToShow%
  Gui, Picture:add, text, , File: %A_ScriptDir%\%picToShow%
  Gui, Picture:Show
return
}

showImageTabs(picToshow, PictureWidth, numPages){
    SysGet, Mon1, Monitor, 1
    If (Mon1Right < PictureWidth)
      PictureWidth -= 450
    If (numPages = 1) {
      showPic(picToshow, PictureWidth)
      return
    }
    Gui, Picture:+alwaysontop -sysmenu +owner -caption +toolwindow +0x02000000
    Gui, Picture:Color, 111111
    Gui, Picture:Margin, 5, 5
    Gui, Picture:font, s10 cFFFFFF, Consolas
    loop, %numPages% {
        nextTab := tabList . "Page" . A_Index . "|"
        tabList := nextTab
        }
    Gui, Picture:add, Tab3,, %tabList%
    loop, %numPages% {
        fileToShow := picToShow . A_Index . ".png"
          if !FileExist(fileToShow) {
            picToShow := "SUPPORTING-FILES\NO-CHEAT-SHEET.png"
            PictureWidth := 579
            showPic(picToshow, PictureWidth)
            Return
          }
        If (A_Index = 1) {
            Gui, Picture:add, picture, w%PictureWidth% h-1 , %fileToShow%
            Gui, Picture:add, text, , %PictureWidth% - File: %A_ScriptDir%\%fileToShow%
        }
        else {
            Gui, Picture:Tab, %A_Index%
            Gui, Picture:add, picture, w%PictureWidth% h-1 , %fileToShow%
            Gui, Picture:add, text, , File: %A_ScriptDir%\%fileToShow%
            }
    }
    Gui, Picture:Tab
    Gui, Picture:Show
    return
}


killGui(whicGUI){
Gui, Destroy
return
}



/*
INI_Init(inifile)     ;prepares the global variables to be populated
INI_Load(inifile)     ;Reads all the settings into the global variables from the file
INI_Save(inifile)     ;Saves all the settings from the global variables into the file

INI_ReadAll(inifile)  ;Synonym for INI_Load
INI_WriteAll(inifile) ;Synonym for INI_Save

*/
INI_Init(inifile = "inifile.ini"){
  global

;the section below will check for the existance of the 'settings.ini' file. If it does not exist, then a default one will be created.
  If !FileExist("settings.ini"){ ;remember an ! before the variable to test in an 'if' statement means 'logical not' - it's a way to invert the value for something where you only want to do a thing if the result is false. (i.e.-you don't need an if (true) stop...else (false) do soemthing
		FileAppend,
      (
[Location]
currentSystemLocation=1
systemLocation1=This-PC
[Scripts]
loadScript1=1
pathScript1=settings-made.ahk
      ), settings.ini
	  FileAppend,
	  (
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
MsgBox, 64, 'settings.ini' file created, The 'settings.ini' file has been created in D:\Dropbox\PostOp-Ben Share\Apps\AutoHotKey\AHK-SCRIPTS-working\using an ini file.``n``nYou can edit it in a text editor to add to it. Follow the format of the created file to add Locations and/or Scripts to Run at the Launch of MASTER-SCRIPT.AHK.``n``nFeel free to delete this script and it's corresponding settings once you have begun adding your own items.``n``nPress WIN+F11 to open the settings interface.
	), settings-made.ahk
	}

;done checking for and/or creating 'settings.ini' if it doesn't exist

  local key
  inisections:=0

  loop,read,%inifile%
  {
    if regexmatch(A_Loopreadline,"\[(\w+)]")
      {
        inisections+= 1
        section%inisections%:=regexreplace(A_loopreadline,"(\[)(\w+)(])","$2")
        section%inisections%_keys:=0
      }
    else if regexmatch(A_LoopReadLine,"(\w+)=(.*)")
      {
        section%inisections%_keys+= 1
        key:=section%inisections%_keys
        section%inisections%_key%key%:=regexreplace(A_LoopReadLine,"(\w+)=(.*)","$1")
      }
  }
}

INI_readAll(inifile="inifile.ini"){
  INI_load(inifile)
}

INI_load(inifile="inifile.ini"){
  global
  local sec,var
  loop,%inisections%
    {
      sec:=A_index
      loop,% section%a_index%_keys
        {
          var:=section%sec% "_" section%sec%_key%A_index%
          iniread,%var%,%inifile%,% section%sec%,% section%sec%_key%A_index%
        }
    }
}

INI_writeAll(inifile="inifile.ini"){
  INI_Save(inifile)
}

INI_Save(inifile="inifile.ini"){
  global
  local sec,var
  loop,%inisections%
    {
      sec:=A_index
      loop,% section%a_index%_keys
        {
          var:=section%sec% "_" section%sec%_key%A_index%,var:=%var%
          iniwrite,%var%,%inifile%,% section%sec%,% section%sec%_key%A_index%
        }
    }
}


; ===========================================================================
; Run a program or switch to it if already running.
;    Target - Program to run. E.g. Calc.exe or C:\Progs\Bobo.exe
;    WinTitle - Optional title of the window to activate.  Programs like
;    MS Outlook might have multiple windows open (main window and email
;    windows).  This parm allows activating a specific window.
; ===========================================================================

RunOrActivate(Target, WinTitle = "", Parameters = "")
{
   ; Get the filename without a path
   SplitPath, Target, TargetNameOnly

   Process, Exist, %TargetNameOnly%
   If ErrorLevel > 0
      PID = %ErrorLevel%
   Else
      Run, %Target% "%Parameters%", , , PID

   ; At least one app (Seapine TestTrack wouldn't always become the active
   ; window after using Run), so we always force a window activate.
   ; Activate by title if given, otherwise use PID.
   If WinTitle <>
   {
      SetTitleMatchMode, 2
      WinWait, %WinTitle%, , 3
      TrayTip, , Activating Window Title "%WinTitle%" (%TargetNameOnly%)
      WinActivate, %WinTitle%
   }
   Else
   {
      WinWait, ahk_pid %PID%, , 3
      TrayTip, , Activating PID %PID% (%TargetNameOnly%)
      WinActivate, ahk_pid %PID%
   }
}

VNCRunOrActivate(VNCLaunchCode, VNCWintitle)
{
   if WinExist(VNCWinTitle)
      WinActivate, %VNCWinTitle%
   else
      Run, %VNCLaunchCode%
}
