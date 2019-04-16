; AutoHotKey - Settings for MASTER-SCRIPT.AHK
; by Ben Howard - ben@buttonpusher.tv


;===== START OF AUTO-EXECUTION SECTION =========================================================
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; #Persistent ; Keeps script permanently running.
#SingleInstance force ; Ensures that there is only a single instance of this script running.
; SetTitleMatchMode, 2 ; sets title matching to search for "containing" instead of "exact"

; The 2 lines below pertain to the 'reload on save' function below (CheckScriptUpdate). 
; They are required for it to work.
FileGetTime ScriptStartModTime, %A_ScriptFullPath%
SetTimer CheckScriptUpdate, 100, 0x7FFFFFFF ; 100 ms, highest priority

#Include MASTER-FUNCTIONS.ahk

;===== INITIALIZATION - VARIABLES ==============================================================
; Sleep shortcuts - use these to standardize sleep times
sleepMicro := 5
sleepMini := 15
sleepShort := 333
sleepMedium := 666
sleepLong := 1500
sleepDeep := 3500

global INIfile := "settings.ini"
global loadPremierePro := False
global loadPPRORightClickMod := False
global loadAfterEffects := False
global loadPhotoshop := False
global loadAcceleratedScrolling := False
global loadKeyPressOSD := False

INILoad(INIfile)

Gui, Font, S12 CDefault, Franklin Gothic Medium
Gui, Add, Text, x10 y10 w240 h20 , Settings for MASTER-SCRIPT.AHK
;Hotkey Scripts To Load Group Box
Gui, Add, GroupBox, x10 y40 w300 h170 , Hotkey Scripts to Load:
Gui, Add, CheckBox, x30 y80 w120 h20 vloadPremierePro Checked%loadPremierePro%, Premiere Pro
Gui, Add, CheckBox, x50 y110 w250 h20 vloadPPRORightClickMod Checked%loadPPRORightClickMod%, PPRO:Right Click Timeline MOD
Gui, Add, CheckBox, x30 y140 w120 h20 vloadAfterEffects Checked%loadAfterEffects%, After Effects
Gui, Add, CheckBox, x30 y170 w120 h20 vloadPhotoshop Checked%loadPhotoshop%, Photoshop
;Utility Scripts to Load Groupbox
Gui, Add, GroupBox, x330 y40 w300 h170 , Utility Scripts to Load:
Gui, Add, CheckBox, x350 y80 w170 h20 vloadAcceleratedScrolling Checked%loadAcceleratedScrolling%, Accelerated Scrolling
Gui, Add, CheckBox, x350 y110 w170 h20 vloadKeyPressOSD Checked%loadKeyPressOSD%, KeyPress OSD
;QuickLauncher Groupbox
Gui, Add, GroupBox, x10 y220 w620 h80 , Quick Launcher
Gui, Add, Button, x30 y250 w170 h30 , ShowRunningAHKs
Gui, Add, Button, x230 y250 w170 h30 , HotKey Help
Gui, Add, Button, x430 y250 w170 h30 , KeyPress OSD
;Text that appears above button row of buttons
Gui, Font, S10 CDefault, Franklin Gothic Medium
Gui, Add, Text, x30 y310 w450 h80, The buttons below do the following:`nReload - will reload this script and MASTER-SCRIPT.AHK (without saving)`nCancel - will cancel changes and exit settings`nOK - will save config above, exit settings and reload MASTER-SCRIPT.AHK
Gui, Add, Text, x30 y390 w500 h30, Press WIN-CTRL-ALT-Q while MASTER-SCRIPT.AHK is running to quit it and all Child Scripts.
;Bottom row of buttons- Quit, Reload, Cancel, OK
Gui, Font, S12 CDefault, Franklin Gothic Medium
Gui, Add, Button, x30 y425 w170 h30 , Reload
Gui, Add, Button, x230 y425 w170 h30 , Cancel
Gui, Add, Button, x430 y425 w170 h30 , OK


;===== END OF AUTO-EXECUTE =====================================================================
;===== MODIFIER MEMORY HELPER ==================================================================
; combine below with key and '::' to define hotkey 
; e.g.- ^f1::Msgbox You pressed Control and F1
; #=Win | !=Alt | ^=Ctrl | +=Shift | &=combine keys | *=ignore other mods
; <=use left mod key| >=use right mod key  | UP=fires on release

;===== MAIN HOTKEY DEFINITIONS HERE ============================================================

; AUTO Open the Settings GUI for MASTER-SCRIPT.AHK
Gui, Show, w660 h475, Settings GUI
return

;===============================================================================================

;===== FUNCTIONS ===============================================================================

ButtonShowRunningAHKs:
Run, C:\BPTV-KB\UTIL-APPS\ShowRunningAHKs.ahk
return

ButtonKeyPressOSD:
Run, C:\BPTV-KB\UTIL-APPS\KeypressOSD.ahk
return

ButtonHotKeyHelp:
Run, C:\BPTV-KB\UTIL-APPS\Hotkey Help.ahk
return

ButtonReload:
Send, {Control Down}
sleep, sleepShort
Send, {Alt Down}
sleep, sleepShort
Send, {LWin Down}
sleep, sleepShort
Send, {BackSpace}
sleep, sleepShort
Send, {Control Up}
sleep, sleepShort
Send, {Alt Up}
sleep, sleepShort
Send, {LWin Up}
Reload
return

ButtonOK:
Gui, Submit
INISAVE(INIfile)
Gui, hide
Send, {Control Down}
sleep, sleepShort
Send, {Alt Down}
sleep, sleepShort
Send, {LWin Down}
sleep, sleepShort
Send, {BackSpace}
sleep, sleepShort
Send, {Control Up}
sleep, sleepShort
Send, {Alt Up}
sleep, sleepShort
Send, {LWin Up}
sleep, sleepLong
goto Quitting
return

ButtonCancel:
GuiEscape:
GuiClose:
Gui, hide
goto Quitting
return

Quitting:
ExitApp
return


; This function will auto-reload the script on save.
CheckScriptUpdate() {
    global ScriptStartModTime
    FileGetTime curModTime, %A_ScriptFullPath%
    If (curModTime <> ScriptStartModTime) {
        Loop
        {
            reload
            Sleep 300 ; ms
            MsgBox 0x2, %A_ScriptName%, Reload failed. ; 0x2 = Abort/Retry/Ignore
            IfMsgBox Abort
                ExitApp
            IfMsgBox Ignore
                break
        } ; loops reload on "Retry"
    }
}