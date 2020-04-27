; AutoHotKey - Hotkeys for Microsoft Word
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
;FileGetTime ScriptStartModTime, %A_ScriptFullPath%
;SetTimer CheckScriptUpdate, 100, 0x7FFFFFFF ; 100 ms, highest priority

;===== INITIALIZATION - VARIABLES ==============================================================
; Sleep shortcuts - use these to standardize sleep times. Change here to change everywhere.
sleepMicro := 15
sleepShort := 333
sleepMedium := 666
sleepLong := 1500
sleepDeep := 3500

splashScreenX = %1%
splashScreenY = %2%
splashScreenTimeout = %3%
Location_currentSystemLocation = %4%

Menu, Tray, Icon, imageres.dll, 243 ;tray icon is now something like '\\..'

;===== SPLASH SCREEN TO ANNOUNCE WHAT SCRIPT DOES ==============================================
SplashTextOn, 600, 100, Launching %A_ScriptFullPath%, Hotkey shortcuts for Microsft Word.
WinMove, Launching %A_ScriptFullPath%, , %splashScreenX%, %splashScreenY%
SetTimer, RemoveSplashScreen, %splashScreenTimeout%

;===== END OF AUTO-EXECUTE =====================================================================
;===== MODIFIER MEMORY HELPER ==================================================================
; combine below with key and '::' to define hotkey
; e.g.- ^f1::Msgbox You pressed Control and F1
; #=Win | !=Alt | ^=Ctrl | +=Shift | &=combine keys | *=ignore other mods
; <=use left mod key| >=use right mod key  | UP=fires on release

;===== MAIN HOTKEY DEFINITIONS HERE ============================================================

#IfWinActive, ahk_exe WINWORD.EXE

F13::
    ;WinActivate, PhRMA Price Setting- Scripted Narrative Drafts 4-22-2020 F4.doc  -  Compatibility Mode - Word
    SendInput, ^c
    Sleep, sleepShort
    WinActivate, PHRMA-LEE-SKYPE-4-17-2020.doc  -  Compatibility Mode - Word
    Sleep, sleepMedium
    SendInput, ^f
    Sleep, sleepShort
    SendInput, ^a
    Sleep, sleepShort
    SendInput, ^v
    Sleep, sleepShort
    SendInput, {Enter}
    Sleep, sleepShort
    WinActivate, ahk_exe Adobe Premiere Pro.exe
    Sleep, sleepShort
    SendInput, ^{F8}
    Return

    
#IfWinActive


;===== FUNCTIONS ===============================================================================

RemoveSplashScreen:
    SplashTextOff
    SetTimer RemoveSplashScreen, Off
    return



/* COMMENTED THE BELOW OUT SINCE I GENERALLY DON'T USE THIS FEATURE ANY MORE - but I thought I'd just keep it around...just in case...
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
*/