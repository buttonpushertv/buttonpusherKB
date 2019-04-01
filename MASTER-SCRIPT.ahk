; AutoHotKey - EDIT2 - Master Script
; by Ben Howard - ben@buttonpusher.tv

;===== START OF AUTO-EXECUTION SECTION =========================================================
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent ; Keeps script permanently running.
#SingleInstance force ; Ensures that there is only a single instance of this script running.
; SetTitleMatchMode, 2 ; sets title matching to search for "containing" instead of "exact"
;Menu, Tray, Icon, shell32.dll, 283 ;tray icon is now a little keyboard, or piece of paper or something

if not A_IsAdmin
	Run *RunAs "%A_ScriptFullPath%" ; (A_AhkPath is usually optional if the script has the .ahk extension.) You would typically check  first.

; The 2 lines below pertain to the 'reload on save' function below (CheckScriptUpdate). 
; They are required for it to work.
FileGetTime ScriptStartModTime, %A_ScriptFullPath%
SetTimer CheckScriptUpdate, 100, 0x7FFFFFFF ; 100 ms, highest priority

#Include MASTER-FUNCTIONS.ahk

;===== INITIALIZATION - VARIABLES ==============================================================
; Sleep shortcuts - use these to standardize sleep times. Change here to change everywhere.
sleepMicro := 15
sleepShort := 333
sleepMedium := 666
sleepLong := 1500
sleepDeep := 3500

;===== SPLASH SCREEN TO ANNOUNCE WHAT SCRIPT DOES ==============================================
SplashTextOn, 600, 80, Launching %A_ScriptFullPath%, Loading MASTER AHK Script.`nWin-] for CheatSheet of AHK Hotkeys.`n`nWin-Ctrl-Alt-Shift-Q to quit MASTER-SCRIPT & child scripts.
WinMove, Launching %A_ScriptFullPath%, , 100, 100  
; ===== LAUNCH STANDALONE SCRIPTS HERE
Run, "PPRO-SCRIPTS\PREMIERE-PRO-HOTKEYS.ahk"
Run, "PPRO-SCRIPTS\PPRO_Right_click_timeline_to_move_playhead.ahk"
Run, "UTIL-SCRIPTS\Accelerated Scrolling 1.3.ahk"
Sleep, sleepLong
SplashTextOff

;
;===== END OF AUTO-EXECUTE =====================================================================
;===== MODIFIER MEMORY HELPER ==================================================================
; combine below with key and '::' to define hotkey 
; e.g.- ^f1::Msgbox You pressed Control and F1
; #=Win | !=Alt | ^=Ctrl | +=Shift | &=combine keys | *=ignore other mods
; <=use left mod key| >=use right mod key  | UP=fires on release

;===== MAIN HOTKEY DEFINITIONS HERE ============================================================

#!^+q:: ; <-- Exit MASTER-SCRIPT & child AHK Scripts
    DetectHiddenWindows, On
    MsgBox, ,Quitting, Quitting MASTER-SCRIPT & child AHK scripts, 3
    SetTitleMatchMode, 2
    WinClose, PREMIERE-PRO-HOTKEYS.ahk
    WinClose, PPRO_Right_click_timeline_to_move_playhead.ahk
    WinClose, Accelerated Scrolling 1.3.ahk
    ExitApp
    return


#[:: ; <--Display an image CheatSheet of App Specific Keyboard Shortcuts 
    If WinActive("ahk_exe Adobe Premiere Pro.exe")
    showPic("SUPPORTING-FILES\BEN-CC19-KEYBOARD.png")
    else
    showPic("SUPPORTING-FILES\NO-CHEAT-SHEET.png")
    keywait, [
    killGui()
    return

#]:: ; <--Display a Text File CheatSheet of My AHK Keyboard Shortcuts 
    showText("SUPPORTING-FILES\MY-AHK-KEYS.txt")
    keywait, ]
    killGui()
    return

#w:: ; <--Display a Text File CheatSheet of Windows Default Keys
    showText("SUPPORTING-FILES\WINDOWS-DEFAULT-KEYS.txt")
    keywait, w
    killGui()
    return

!#p:: ; <--Display an image CheatSheet of App Specific Keyboard Shortcuts 
    showPic("SUPPORTING-FILES\PREONIC-KEY-LAYOUT.png")
    keywait, p
    killGui()
    return

#IfWinNotActive ahk_exe FreeCommander.exe

LAlt:: ; <-- PPRO: blocking ALT key from triggering the menu bar items - from TaranVH
sendinput, {LAlt down}
sendinput, {SC0E8 down} ;this is the scan code of an unassigned key. As long as you nor the system never use it for anything else, it can be used in THIS way to cancel the menu acceleration.
;tooltip, Lalt is pressed
KeyWait, LAlt
; That line is important, so that ALT does not continuously fire as you are holding it down.
;tooltip, Lalt was released
return

LAlt up:: ; <-- PPRO: blocking ALT key from triggering the menu bar items - from TaranVH
sendinput, {LAlt up}
sendinput, {SC0E8 up}
;;;Unlike my 2nd keyboard, this method does not use the scan code as a strict "wrapper."
;;tooltip, 
return


RAlt:: ; <-- PPRO: blocking ALT key from triggering the menu bar items - from TaranVH
sendinput, {RAlt down}
sendinput, {SC0E8 down}
;;tooltip, Ralt is pressed
KeyWait, RAlt
;;tooltip, Ralt was released
return

RAlt up:: ; <-- PPRO: blocking ALT key from triggering the menu bar items - from TaranVH
sendinput, {RAlt up}
sendinput, {SC0E8 up}
;;tooltip, 
return

#IfWinActive, ahk_exe Explorer.EXE
 
^!+f:: ; <-- Nuke Firefox
Run, %comspec% /c "taskkill.exe /F /IM firefox.exe",, hide
ToolTip, killed firefox
SetTimer, RemoveToolTip, -2000
return

^!+p:: ; <-- Nuke Premiere
Run, %comspec% /c "taskkill.exe /IM /Adobe Premiere Pro.exe /T /F" ;,, hide
ToolTip, killed premiere
SetTimer, RemoveToolTip, -2000
return


;===== FUNCTIONS ===============================================================================

RemoveToolTip:
ToolTip
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