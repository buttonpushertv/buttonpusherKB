; AutoHotKey - System-Backup Reminder & Manager
; by Ben Howard - ben@buttonpusher.tv

; You can customize this template by editing "C:\Windows\ShellNew\Template.ahk"
;===============================================================================================
; This Template.ahk file contains several of the most common items that I find myself often
; needing or adding to my scripts. It's not all essential. Here's a short list of what's here:
; - Function (CheckScriptUpdate) that will auto-reload the script when it detects a change
;	in the last modified timestamp on the script file itself
; - Sleep duration shortcuts - so that sleep times can be modified in one place to affect all
; - Modifier Memory Helper - just a comment section to remind you of what the codes are for things
;
; See comments througout the file to figure out what something is here for.

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

#Include ..\MASTER-FUNCTIONS.ahk

FileReadLine, dayssince, ..\PRIVATE\%A_Computername%\days_since_system_backup.txt, 1

If (dayssince < 15) {
  ExitApp
}

Settings_timeoutPeriod := 10000 ; in milliseconds

guiHeight := 200
guiWidth := 325
guiElementWidth := (guiWidth - 50)
backupApplication := "C:\Program Files (x86)\EaseUS\Todo Backup\bin\Loader.exe"

;===== END OF AUTO-EXECUTE =====================================================================
;===== MODIFIER MEMORY HELPER ==================================================================
; combine below with key and '::' to define hotkey
; e.g.- ^f1::Msgbox You pressed Control and F1
; #=Win | !=Alt | ^=Ctrl | +=Shift | &=combine keys | *=ignore other mods
; <=use left mod key| >=use right mod key  | UP=fires on release

;===== MAIN HOTKEY DEFINITIONS HERE ============================================================
Gui, Font, S12 CDefault, Franklin Gothic Medium
Gui, Add, Text, x25 y20 h40 , It's been %dayssince% days since the last backup.
Gui, Add, Text, x25 y60 h40 , Do you want to run a System Backup?
timeoutSegments := Round(Settings_timeoutPeriod / 1000)
timeoutText := "Skipping in       seconds."
timeoutRemaining := timeoutSegments
Gui, Font, S8 CDefault, Franklin Gothic Medium
Gui, Add, Text, x100 y115 vtimeoutText, %timeoutText%
Gui, Add, Text, x160 y115 w15 vtimeoutTextProgress
Gui, Add, Progress, x25 y90 w%guiElementWidth% h20 cGreen BackgroundNavy Range0-%timeoutSegments% vtimeoutProgress
Gui, Font, S12 CDefault, Franklin Gothic Medium
Gui, Add, Button, Default x175 y140 w100 h40 , &No
Gui, Add, Button, x50 y140 w100 h40 , &Yes

Gui, Show, w%guiWidth% h%guiHeight%, Untitled GUI

;timer code section here
;the timeout period is stored in settings.ini - under the [Settings] section as milliseconds - other values designated in above GUI code

;this code creates and upadtes the timer text & progress bar
loop, %timeoutSegments%
  {
  GuiControl, , timeoutTextProgress, %timeoutRemaining%
  sleep, 1000
  GuiControl, , timeoutProgress, +1
  timeoutRemaining := (timeoutSegments - A_Index)
  }
  goto ButtonNo
return

ButtonYes:
Run, %backupApplication%
Sleep, 8000
WinActivate, EaseUS Todo Backup
WinWaitNotActive, EaseUS Todo Backup
Gui, Hide
MsgBox, 36, BackUp App Launched, You launched the Backup App.`n`nSuccessfully backed up?
IfMsgBox, Yes
{
    FileDelete, C:\BPTV-KB\PRIVATE\days_since_system_backup.txt
    FileAppend, 0, C:\BPTV-KB\PRIVATE\days_since_system_backup.txt
}
IfMsgBox, No
{
    MsgBox,,Backup UNsuccessful?, Very well.`n`nRe-run %A_ScriptName% when you're ready., 4
}
ExitApp
return

ButtonNo:
MsgBox, , Run System Backup Soon, Consider running a System Backup Soon., 4

GuiClose:
GuiEscape:
ExitApp

;===== FUNCTIONS ===============================================================================
