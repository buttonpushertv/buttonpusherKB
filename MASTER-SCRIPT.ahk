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

#MenuMaskKey vk07 ; This is needed to block the Window key from triggering the Start Menu when pressed by itself.

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

;global theTimeStamp := "now"
global iniFile := "settings.ini"
global splashScreenSpacing := 150
global splashScreenStartY := 100
global splashScreenStartX := 100

INI_Init(iniFile)
INI_Load(iniFile)

;===== SPLASH SCREEN TO ANNOUNCE WHAT SCRIPT DOES ==============================================
SplashTextOn, 600, 100, Launching %A_ScriptFullPath%, Loading MASTER AHK Script.`nWin-F1 for CheatSheet of AHK Hotkeys.`n`nWin-Ctrl-Alt-Shift-Q to quit MASTER-SCRIPT & child scripts.
WinMove, Launching %A_ScriptFullPath%, , %splashScreenStartX%, %splashScreenStartY%

splashScreenStartY += splashScreenSpacing

; ===== LAUNCH STANDALONE SCRIPTS HERE

loop, %section2_keys%
{
    currentKey := % section2_key%A_Index%
    pathLookAhead := A_Index + 1
    pathKey :=
    currentKeyValue :=
    currentPathValue :=
    If mod(A_Index,2){
        pathKey := % section2_key%pathLookAhead%
        currentKeyValue := %section2%_%currentKey%
        currentPathValue := %section2%_%pathKey%
        ;MsgBox currentKey: %currentKey%`ncurrentKeyValue: %currentKeyValue%`npathKey: %pathKey%`ncurrentPathValue: %currentPathValue%
        If (currentKeyValue) {
            ;MsgBox Runnning: %currentPathValue%
            Run, %currentPathValue% %splashScreenStartX% %splashScreenStartY%
            splashScreenStartY += splashScreenSpacing
        }
        else
            Continue
    }
    else
    Continue
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

~LWin::Send {Blind}{vk07} ; <-- Blocks Left Window key from triggering the Start Menu when pressed by itself. The Right Window key will still work in the default fashion.

; don't know if this works for alt too...
~LAlt::Send {Blind}{vk07}


#b:: ; <-- Send 'buttonpusher' as text
Send, buttonpusher
return

#!b:: ; <-- Send 'ben@buttonpusher.tv' as text
Send, ben@buttonpusher.tv
return

#c:: ; <-- Delete Key
Send, {Delete}
return

#v:: ; <-- Backspace Key
Send, {BackSpace}
return

#f11:: ; <--Open the Settings GUI for MASTER-SCRIPT.AHK
Run, MASTER-SETTINGS.AHK
return

#^!Backspace:: ; <-- Reload MASTER-SCRIPT.ahk
Reload
Return

#^!q:: ; <-- Exit MASTER-SCRIPT and child AHK Scripts
goto Quitting

#f1:: ; <--Display a Text File CheatSheet of MASTER-SCRIPT AutoHotKeys
    locationPic := "SUPPORTING-FILES\AHK-KEYS-F1-LOC" . Location_currentSystemLocation . ".txt"
    showText(locationPic)
    keywait, f1
    Gui, Text:Destroy
    return

#f2:: ; <--Display an image CheatSheet of App Specific Keyboard Shortcuts (In-app and AHK)
    If WinActive("ahk_exe Adobe Premiere Pro.exe") {
        pic2Show := "SUPPORTING-FILES\KBF2-PPRO-LOC" . Location_currentSystemLocation . ".png"
        showPic(pic2Show)
    }
    else
    If WinActive("ahk_exe AfterFX.exe") {
        pic2Show := "SUPPORTING-FILES\KBF2-AE-LOC" . Location_currentSystemLocation . ".png"
        showPic(pic2Show)
    }
    else
    showPic("SUPPORTING-FILES\KB-NO-CHEAT-SHEET.png")
    keywait, f2
    Gui, Picture:Destroy
    return

#f3:: ; <--Display a Text File CheatSheet of App Specific AutoHotKeys
    If WinActive("ahk_exe Adobe Premiere Pro.exe")
    showText("SUPPORTING-FILES\AHK-KEYS-F3-PPRO.txt")
    else
    showText("SUPPORTING-FILES\AHK-KEYS-NO-CHEATSHEET.txt")
    keywait, f3
    Gui, Text:Destroy
    return

#f4:: ; <--Display an image CheatSheet based on System Location Setting
    locationPic := "SUPPORTING-FILES\KBF4-LOC" . Location_currentSystemLocation . ".png"
    showPic(locationPic)
    keywait,f4
    Gui, Picture:Destroy
    return

#f12:: ; <-- Launch buttonpusherTV LAUNCH-X
    Run, C:\BPTV-KB\UTIL-APPS\BPTV-LAUNCHX\launcher.ahk ,C:\BPTV-KB\UTIL-APPS\BPTV-LAUNCHX
    return

#t:: ; <-- Send time & date as text
    ;timestamp(theTimeStamp)
    FormatTime, now,, hh:mm tt
    today = %A_YYYY%-%A_MMM%-%A_DD%
    theTimeStamp = %now% - %today%
    Send, %theTimeStamp%
    return

#w:: ; <--Display a Text File CheatSheet of Windows Default Keys
    showText("SUPPORTING-FILES\WINDOWS-DEFAULT-KEYS.txt")
    keywait, w
    Gui, Text:Destroy
    return

#IfWinActive, ahk_exe Explorer.EXE

#^+f:: ; <-- Nuke Firefox
Run, %comspec% /c "taskkill.exe /F /IM firefox.exe",, hide
ToolTip, killed firefox
SetTimer, RemoveToolTip, -2000
return

#^p:: ; <-- Nuke Premiere
    Process, Exist, Adobe Premiere Pro.exe
    If (ErrorLevel > 0)
        PID = %ErrorLevel%
    Run, %comspec% /c "taskkill.exe /PID %PID% /T /F"
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
    WinClose, PREMIERE-PRO-HOTKEYS.ahk
    WinClose, PPRO_Right_click_timeline_to_move_playhead.ahk
    WinClose, Accelerated-Scrolling-1-3.ahk
    WinClose, UTIL-APPS\KeypressOSD.ahk
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
