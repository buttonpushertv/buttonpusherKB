; AutoHotKey - MASTER-FUNCTIONS for inclusion into MASTER-SCRIPT.AHK
;by Ben Howard - ben@buttonpusher.tv
;
; portions copied from TaranVH's 2nd-keyboard project (https://github.com/TaranVH/2nd-keyboard)

;===============================================================================================
;===== START OF AUTO-EXECUTION SECTION =========================================================
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force ; Ensures that there is only a single instance of this script running.

;===== INITIALIZATION - VARIABLES ==============================================================
; Sleep shortcuts - use these to standardize sleep times
sleepMicro := 15
sleepShort := 333
sleepMedium := 666
sleepLong := 1500
sleepDeep := 3500

FileEncoding, UTF-8 ; this is here to make sure any files that we need to work with get created/opened/read as UTF-8

global scriptRootFolder := A_ScriptDir ; sets the scriptRootFolder value to A_ScriptDir. This should then auto-set the rootFolder value in the settings.ini file. The idea here is that this should make it possible to change the name of the root folder where all of this gets installed and then it should propagate throughout the script.

iniFile := A_ScriptDir . "\settings.ini"

;===== END OF AUTO-EXECUTE =====================================================================
;===== MODIFIER MEMORY HELPER ==================================================================
; combine below with key and '::' to define hotkey
; e.g.- ^f1::Msgbox You pressed Control and F1
; #=Win | !=Alt | ^=Ctrl | +=Shift | &=combine keys | *=ignore other mods
; <=use left mod key| >=use right mod key  | UP=fires on release

;===== FUNCTIONS ===============================================================================

; use this function to Remove ToolTips - pretty self-explanatory - 'duration' should be given in milliseconds (4000 = 4 seconds)
RemoveToolTip(duration) {
  SetTimer, ToolTipOff, %duration%
  Return

ToolTipOff:
    ToolTip
    return
}

; use this function to turn ScrollLock off
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


/*
  This sections defines the Functions to Initialize, Read, and Saves the settings from the file defined by the variable %iniFile% - set in MASTER-SCRIPT.ahk (around line 37)
  INI_Init(inifile)     ;prepares the global variables to be populated
  INI_Load(inifile)     ;Reads all the settings into the global variables from the file
  INI_Save(inifile)     ;Saves all the settings from the global variables into the file

  INI_ReadAll(inifile)  ;Synonym for INI_Load
  INI_WriteAll(inifile) ;Synonym for INI_Save

*/
INI_Init(inifile = "inifile.ini"){
  global

;the section below will check for the existance of the 'settings.ini' file. If it does not exist, then a default one will be created.
  If !FileExist("settings.ini"){ ;remember an ! before the variable to test in an 'if' statement means 'logical not' - it's a way to invert the value for something where you only want to do a thing if the result is false. (i.e.-you don't need an if (true) stop...else (false) do something)
		FileAppend,
      (
[Location]
currentSystemLocation=1
systemLocation1=This-PC
[Scripts]
loadScript1=1
pathScript1=settings-made.ahk
nameScript1=settings-made.ahk (auto-created)
[Apps]
loadApp1=1
pathApp1=MASTER-SCRIPT.ahk
nameApp1=Run MASTER-SCRIPT.AHK
[Settings]
rootFolder=
), settings.ini
    FileAppend,
    (
      %scriptRootFolder%
      ), settings.ini
    FileAppend,
    (

timeoutPeriod=15000
splashScreenTimeout=4000
CapsLockToggleTimeoutThreshold=4
CapsLockToggleOffTimeout=8
CapsLockCheckPeriod=10000
      ), settings.ini
	  FileAppend,
	  (
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
MsgBox, 64, 'settings.ini' file created, The 'settings.ini' file has been created in %A_ScriptDir%.``n``nYou can edit it in a text editor to add to it. Follow the format of the created file to add Locations, Apps (for buttonpusherKB-Launcher), and Scripts to Run at the Launch of MASTER-SCRIPT.AHK.``n``nFeel free to delete this script and it's corresponding settings once you have begun adding your own items.``n``nPress CapsLock OR ScrollLock+F11 to open the settings interface.
	), settings-made.ahk
	}

;done checking for and/or creating 'settings.ini' if it doesn't exist

  local key
  inisections:=0
;this loop will read the settings from the existing %iniFile%
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
;
; These functions are a bit flaky - Ben
;
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

