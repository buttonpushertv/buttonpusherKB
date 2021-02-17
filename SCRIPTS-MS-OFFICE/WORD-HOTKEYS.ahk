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
; AUTO-RELOAD ON SAVE DISABLED - UNCOMMENT 2 LINES ABOVE TO RE-ENABLE
; SEE THE FUNCTION BELOW FOR MORE INFO

;===== INITIALIZATION - VARIABLES ==============================================================
; Sleep shortcuts - use these to standardize sleep times. Change here to change everywhere.
sleepMicro := 15
sleepShort := 333
sleepMedium := 666
sleepLong := 1500
sleepDeep := 3500

Location_currentSystemLocation = %1%

Menu, Tray, Icon, imageres.dll, 243 ;tray icon is now something like '\\..'


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

/*
; THIS FUNCTION WHILE USEFUL, MAY NOT BE NEEDED IN MOST SCRIPTS.
; IT IS HERE TO BE USED ON AN AS NEEDED BASIS - DURING DEVELOPMENT, FOR INSTANCE.
: REMOVE THE COMMENT BLOCK LINES AND UNCOMMENT THE LINES AT THE HEAD OF THIS SCRIPT TO RE-ENABLE IT.
; This function will auto-reload the script on save.
CheckScriptUpdate() {
    global ScriptStartModTime
    FileGetTime curModTime, %A_ScriptFullPath%
    If (curModTime <> ScriptStartModTime) {
        Loop
        {
            reload
            Sleep 333 ; ms
            MsgBox 0x2, %A_ScriptName%, Reload failed. ; 0x2 = Abort/Retry/Ignore
            IfMsgBox Abort
                ExitApp
            IfMsgBox Ignore
                break
        } ; loops reload on "Retry"
    }
}
*/