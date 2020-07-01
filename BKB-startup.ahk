; AutoHotKey - buttonpusherKB BKB_startup
; by Ben Howard - ben@buttonpusher.tv

;===== START OF AUTO-EXECUTION SECTION =========================================================
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; #Persistent ; Keeps script permanently running.
#SingleInstance force ; Ensures that there is only a single instance of this script running.
; SetTitleMatchMode, 2 ; sets title matching to search for "containing" instead of "exact"

;===== INITIALIZATION - VARIABLES ==============================================================
; Sleep shortcuts - use these to standardize sleep times. Change here to change everywhere.
sleepShort = 333
sleepMedium = 666
sleepLong = 1500
sleepDeep = 3500

EnvGet, Settings_rootFolder, BKB_ROOT
If !(Settings_rootFolder) {
  MsgBox, 262164, MISSING ENVIRONMENT VARIABLE, The Environment Varible BKB_ROOT appears to be missing or empty.`n`nYou need to run BAT-FILES\setENVIRONVARS.cmd to set the System Environment Variable needed to make this script suite work. The above script will run as Admin to set the Root Folder Environment Variable in the Registry. It should remain configured even after a reboot.`n`nDo you want to run this script to set the Environment Variable? (No will exit this script.) 
  IfMsgBox, Yes
    Run, BAT-FILES\setENVIRONVARS.cmd
    ExitApp
  IfMsgBox, No
    ExitApp
}

iniFile := Settings_rootFolder . "\settings.ini" ; the main settings file used by most of the buttonpusherKB scripts
versionFile := Settings_rootFolder . "\version.ini" ; the file which holds the current version of buttonpusherKB
IniRead, Settings_timeoutPeriod, %iniFile%, Settings, timeoutPeriod
IniRead, currentSystemLocation, %iniFile%, Location, currentSystemLocation
IniRead, guiFont, %iniFile%, Settings, guiFont
FileRead, version, %versionFile% ; reading the version from versionFile

;Creating the Main GUI for the app - the bit that loads inititally when run
;setting width variables
guiHeight := 320
guiWidth := 500
guiElementWidth := (guiWidth - 20)

;===== END OF AUTO-EXECUTE =====================================================================
;===== MODIFIER MEMORY HELPER ==================================================================
; combine below with key and '::' to define hotkey
; e.g.- ^f1::Msgbox You pressed Control and F1
; #=Win | !=Alt | ^=Ctrl | +=Shift | &=combine keys | *=ignore other mods
; <=use left mod key| >=use right mod key  | UP=fires on release

;===== MAIN HOTKEY DEFINITIONS HERE ============================================================

timeoutSegments := Round(Settings_timeoutPeriod / 1000)
timeoutText := "Launching in " . timeoutSegments . " seconds."
timeoutRemaining := timeoutSegments

Gui, +AlwaysOnTop
Gui, Color, FFFFFF
Gui, Add, Picture, x0 y0 w-1, %Settings_rootFolder%\SUPPORTING-FILES\BPS-Logo-PLUS-KB-240x275.png
Gui, Add, Text, x90 y270, %version%
Gui, Add, Text, section x255 y0,
Gui, Font, S10 CDefault, %guiFont%
Gui, Add, Text, xs yp+25, About to load buttonpusherKB.
Gui, Add, Text, xs yp+25, Press ESC or Cancel to abort.
Gui, Add, Text, xs+20 yp+45 vtimeoutText, %timeoutText% ; displays the "Launching in..." text
Gui, Font, S28 CDefault, %guiFont% Bold
Gui, Add, Text, xs+100 yp+30 vtimeoutTextProgress ; Big timeout countdown display
Gui, Font, S10 CDefault, %guiFont%
Gui, Add, Progress, x10 y290 w%guiElementWidth% h20 cGreen BackgroundNavy Range0-%timeoutSegments% vtimeoutProgress ; this line draws the timer bar
Gui, Add, Button, xs-10 y195 w110 h40, &Cancel
Gui, Add, Button, Default xs+110 y195 w125 h40, Launch BKB &Now
Gui, Add, Button, xs-10 y245 w245 h30, Jump to &MASTER Script
Gui, Show, w%guiWidth% h%guiHeight%

;timer code section here
;the timeout period is stored in settings.ini - under the [Settings] section as milliseconds - other values designated in above GUI code
launcherTimeoutSleep := 1000 ; this value sets the duration between bar segment advances to 1 second

;this code block creates and updates the timer text & progress bar
loop, %timeoutSegments%
  {
  GuiControl, , timeoutTextProgress, %timeoutRemaining%
  sleep, launcherTimeoutSleep
  GuiControl, , timeoutProgress, +1
  timeoutRemaining := (timeoutSegments - A_Index)
  }
  goto launchBKB
return

ButtonLaunchBKBNow:
goto launchBKB
return

ButtonJumpToMasterScript:
Gui, Destroy
Run, %Settings_rootFolder%\MASTER-SCRIPT.ahk
ExitApp
return

launchBKB:
Gui, Destroy
If (currentSystemLocation = 1) {
  Run, %Settings_rootFolder%\BAT-FILES\user_files_VHDMount_to_X.cmd ; this batch file will mount a Bitlocker Encrypted VHD and then launch BKB-Launcher
  goto Quitting
} else If (currentSystemLocation = 2) {
  Run, %Settings_rootFolder%\BAT-FILES\PortableApps_VHDMount_to_X.cmd ; this batch file will mount an unencrypted VHD and then launch BKB-Launcher
  sleep, sleepMedium
  WinClose,, X: ; closing the File Explorer window that opens from the unencrypted VHD...but not on the Bitlocker one...hmmmm
  goto Quitting
} else {
  Run, %Settings_rootFolder%\BKB-LAUNCHER.ahk ; on these systems there isn't a Encrypted VHD to mount, so we jump to BKB-Launcher directly
  goto Quitting
}
return

ButtonCancel:
GuiClose:
GuiEscape:
Quitting:
Gui, Destroy
ExitApp
return

;===== FUNCTIONS ===============================================================================
