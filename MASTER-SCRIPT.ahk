; AutoHotKey - Buttonpusher Post-Production Keyboard Environment - Master Script
; by Ben Howard - ben@buttonpusher.tv

;===== START OF AUTO-EXECUTION SECTION =========================================================
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent ; Keeps script permanently running.
#SingleInstance force ; Ensures that there is only a single instance of this script running.
; SetTitleMatchMode, 2 ; sets title matching to search for "containing" instead of "exact"
Menu, Tray, Icon, imageres.dll, 187 ;tray icon is now a little keyboard, or piece of paper or something

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

global INIfile := "settings.ini"
global loadPremierePro := False
global loadPPRORightClickMod := False
global loadAfterEffects := False
global loadPhotoshop := False
global loadAcceleratedScrolling := False
global loadKeyPressOSD := False
global splashScreenSpacing := 150
global splashScreenStartY := 100
global splashScreenStartX := 100


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
;MASTER-SCRIPT Settings Groupbox
Gui, Add, GroupBox, x10 y220 w620 h75 , MASTER-SCRIPT Settings
Gui, Add, Text, x30 y250 w180, Splash Screen Spacing:
Gui, Add, Edit, x200 y247 w60 h30 r1 Number Limit3 vsplashScreenSpacing, %splashScreenSpacing%
;QuickLauncher Groupbox
Gui, Add, GroupBox, x10 y300 w620 h80 , Quick Launcher
Gui, Add, Button, x30 y330 w170 h30 , ShowRunningAHKs
Gui, Add, Button, x230 y330 w170 h30 , HotKey Help
Gui, Add, Button, x430 y330 w170 h30 , KeyPress OSD
;Bottom row of buttons- Quit, Reload, Cancel, OK
Gui, Add, Button, x30 y400 w80 h30 , Reload
Gui, Add, Button, x120 y400 w80 h30 , Quit
Gui, Add, Button, x230 y400 w170 h30 , Cancel
Gui, Add, Button, x430 y400 w170 h30 , OK


;===== SPLASH SCREEN TO ANNOUNCE WHAT SCRIPT DOES ==============================================
SplashTextOn, 600, 100, Launching %A_ScriptFullPath%, Loading MASTER AHK Script.`nWin-F1 for CheatSheet of AHK Hotkeys.`n`nWin-Ctrl-Alt-Shift-Q to quit MASTER-SCRIPT & child scripts.
WinMove, Launching %A_ScriptFullPath%, , %splashScreenStartX%, %splashScreenStartY%  

splashScreenStartY = % splashScreenStartY + splashScreenSpacing

; ===== LAUNCH STANDALONE SCRIPTS HERE

If (loadPremierePro <> 0){
    Run, SCRIPTS-PPRO\PREMIERE-PRO-HOTKEYS.ahk %splashScreenStartX% %splashScreenStartY%
    splashScreenStartY = % splashScreenStartY + splashScreenSpacing
}
If (loadPPRORightClickMod <> 0){
    Run, SCRIPTS-PPRO\PPRO_Right_click_timeline_to_move_playhead.ahk %splashScreenStartX% %splashScreenStartY%
    splashScreenStartY = % splashScreenStartY + splashScreenSpacing
}
If (loadAfterEffects <> 0){
    MsgBox After Effects Not Implemented Yet
    splashScreenStartY = % splashScreenStartY + splashScreenSpacing
}   
If (loadPhotoshop <> 0){
    MsgBox Photoshop Not Implemented Yet
    splashScreenStartY = % splashScreenStartY + splashScreenSpacing
}
If (loadAcceleratedScrolling <> 0){
    Run, SCRIPTS-UTIL\Accelerated-Scrolling-1-3.ahk %splashScreenStartX% %splashScreenStartY%
    splashScreenStartY = % splashScreenStartY + splashScreenSpacing
}
If (loadKeyPressOSD <> 0){
    Run, UTIL-APPS\KeypressOSD.ahk %splashScreenStartX% %splashScreenStart%
    splashScreenStartY = % splashScreenStartY + splashScreenSpacing
}
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

#b:: ; <-- Send 'buttonpusher' as text
Send, buttonpusher
return

#!b:: ; <-- Send 'ben@buttonpusher.tv' as text
Send, ben@buttonpusher.tv
return

#^!f1:: ; <-- Open the Settings GUI for MASTER-SCRIPT.AHK
Gui, Show, w660 h475, Settings GUI
return

#^!Backspace:: ; <-- Reload MASTER-SCRIPT.ahk
Reload
Return

#^!q:: ; <-- Exit MASTER-SCRIPT and child AHK Scripts
goto Quitting

#f1:: ; <--Display a Text File CheatSheet of MASTER-SCRIPT AutoHotKeys
    showText("SUPPORTING-FILES\AHK-KEYS-MASTER.txt")
    keywait, f1
    Gui, Text:Destroy
    return

#f2:: ; <--Display an image CheatSheet of App Specific Keyboard Shortcuts (In-app and AHK) 
    If WinActive("ahk_exe Adobe Premiere Pro.exe")
    showPic("SUPPORTING-FILES\BEN-CC19-KEYBOARD.png")
    else
    showPic("SUPPORTING-FILES\NO-CHEAT-SHEET.png")
    keywait, f2
    Gui, Picture:Destroy
    return

#f3:: ; <--Display a Text File CheatSheet of App Specific AutoHotKeys
    If WinActive("ahk_exe Adobe Premiere Pro.exe")
    showText("SUPPORTING-FILES\AHK-KEYS-PPRO.txt")
    else
    showText("SUPPORTING-FILES\AHK-KEYS-NO-CHEATSHEET.txt")
    keywait, f3
    Gui, Text:Destroy
    return

#f4:: ; <--Display an image CheatSheet for Preonic Keyboard 
    showPic("SUPPORTING-FILES\PREONIC-KEY-LAYOUT.png")
    keywait,f4
    Gui, Picture:Destroy
    return


#f12:: ; <-- Launch buttonpusherTV LAUNCH-X
    Run, C:\BPTV-KB\UTIL-APPS\BPTV-LAUNCHX\launcher.ahk ,C:\BPTV-KB\UTIL-APPS\BPTV-LAUNCHX 
    return
    
#w:: ; <--Display a Text File CheatSheet of Windows Default Keys
    showText("SUPPORTING-FILES\WINDOWS-DEFAULT-KEYS.txt")
    keywait, w
    Gui, Text:Destroy
    return

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
Reload
return

ButtonQuit:
goto Quitting

ButtonOK:
Gui, Submit
INISAVE(INIfile)
Gui, hide
Reload
return

ButtonCancel:
GuiEscape:
GuiClose:
Gui, hide
return

#IfWinActive, ahk_exe Explorer.EXE
 
#^+f:: ; <-- Nuke Firefox
Run, %comspec% /c "taskkill.exe /F /IM firefox.exe",, hide
ToolTip, killed firefox
SetTimer, RemoveToolTip, -2000
return

#^+p:: ; <-- Nuke Premiere
Run, %comspec% /c "taskkill.exe /IM /Adobe Premiere Pro.exe /T /F" ;,, hide
ToolTip, killed premiere
SetTimer, RemoveToolTip, -2000
return


;===== FUNCTIONS ===============================================================================

RemoveToolTip:
ToolTip
return

Quitting:
    DetectHiddenWindows, On
    MsgBox, ,Quitting, Quitting MASTER-SCRIPT & child AHK scripts, 3
    SetTitleMatchMode, 2
    If (loadPremierePro <> 0){
        WinClose, PREMIERE-PRO-HOTKEYS.ahk
}
    If (loadPPRORightClickMod <> 0){
        WinClose, PPRO_Right_click_timeline_to_move_playhead.ahk
}
    If (loadAfterEffects <> 0){
}    
    If (loadPhotoshop <> 0){
}
    If (loadAcceleratedScrolling <> 0){
        WinClose, Accelerated-Scrolling-1-3.ahk
}
    If (loadKeyPressOSD <> 0){
        WinClose, UTIL-APPS\KeypressOSD.ahk
}
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