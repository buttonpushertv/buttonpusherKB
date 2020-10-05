; AutoHotKey - QuickType (a Text Expander type-dealy)
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
sleepShort = 333
sleepMedium = 666
sleepLong = 1500
sleepDeep = 3500

Location_currentSystemLocation = %1%

Menu, Tray, Icon, imageres.dll, 243 ;tray icon is now something like '\\..'

;===== END OF AUTO-EXECUTE =====================================================================
;===== MODIFIER MEMORY HELPER ==================================================================
; combine below with key and '::' to define hotkey
; e.g.- ^f1::Msgbox You pressed Control and F1
; #=Win | !=Alt | ^=Ctrl | +=Shift | &=combine keys | *=ignore other mods
; <=use left mod key| >=use right mod key  | UP=fires on release

;===== MAIN HOTKEY DEFINITIONS HERE ============================================================

; The text expanding 'Hotsrings' are simple to format.
; Just type them in this format:
; ::shortcut::Text to type in place of shortcut
; (This is documented in the AHK docs here - https://www.autohotkey.com/docs/Hotstrings.htm)

#Include %A_ScriptDir%\..\PRIVATE\QUICKTYPE-HOTSTRINGS.ahk
; The file included above is accessible for quick editing via the MASTER-SCRIPT hotkey SHIFT+CTRL+ALT+Q when triggered when Desktop is Active. Or it can be sent to an editor when viewing Cheat Sheet #1 (under HYPER+F13 - click 'Edit Sheets')

; The Hotstrings below can auto-replace text from their code, but require more than a single line/command to acheive their results.

; Timestamping hotstrings moved to Lintalist


;===== FUNCTIONS ===============================================================================
RemoveSplashScreen:
    SplashTextOff
    SetTimer RemoveSplashScreen, Off
return

; use this function to Remove ToolTips - pretty self-explanatory - 'duration' should be given in milliseconds (4000 = 4 seconds)
RemoveToolTip(duration) {
  SetTimer, ToolTipOff, %duration%
  Return

ToolTipOff:
    ToolTip
    return
}

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
