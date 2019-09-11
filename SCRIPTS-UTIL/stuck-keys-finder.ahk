; AutoHotKey - Blank Template by Ben Howard - ben@buttonpusher.tv
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
#InstallKeybdHook
#UseHook On
#HotkeyModifierTimeout 0
; The 2 lines below pertain to the 'reload on save' function below (CheckScriptUpdate).
; They are required for it to work.
FileGetTime ScriptStartModTime, %A_ScriptFullPath%
SetTimer CheckScriptUpdate, 100, 0x7FFFFFFF ; 100 ms, highest priority

;===== INITIALIZATION - VARIABLES ==============================================================
; Sleep shortcuts - use these to standardize sleep times. Change here to change everywhere.
sleepMicro := 15
sleepShort := 333
sleepMedium := 666
sleepLong := 1500
sleepDeep := 3500

;===== END OF AUTO-EXECUTE =====================================================================
;===== MODIFIER MEMORY HELPER ==================================================================
; combine below with key and '::' to define hotkey
; e.g.- ^f1::Msgbox You pressed Control and F1
; #=Win | !=Alt | ^=Ctrl | +=Shift | &=combine keys | *=ignore other mods
; <=use left mod key| >=use right mod key  | UP=fires on release

;===== MAIN HOTKEY DEFINITIONS HERE ============================================================
SetTimer, DebugStickyKeys, 300
Gui, Add, Text, x62 y5 w30 h20, Left
Gui, Add, Text, x122 y5 w30 h20, Right
Gui, Add, Text, x22 y25 w30 h20 , CTRL
Gui, Add, Text, x22 y55 w30 h20 , SHFT
Gui, Add, Text, x22 y85 w30 h20 , ALT
Gui, Add, Text, x22 y115 w30 h20 , WIN
Gui, Add, Text, x62 y25 w20 h20 vLctrlState, %stateLctrl%
Gui, Add, Text, x62 y55 w20 h20 vLshiftState, %stateLshift%
Gui, Add, Text, x62 y85 w20 h20 vLaltState, %stateLalt%
Gui, Add, Text, x62 y115 w20 h20 vLwinState, %stateLwin%
Gui, Add, Text, x92 y25 w20 h20 vLctrlStateP, %statePLctrl%
Gui, Add, Text, x92 y55 w20 h20 vLshiftStateP, %statePLshift%
Gui, Add, Text, x92 y85 w20 h20 vLaltStateP, %statePLalt%
Gui, Add, Text, x92 y115 w20 h20 vLwinStateP, %statePLwin%
Gui, Add, Text, x122 y25 w20 h20 vRctrlState, %stateRctrl%
Gui, Add, Text, x122 y55 w20 h20 vRshiftState, %stateRshift%
Gui, Add, Text, x122 y85 w20 h20 vRaltState, %stateRalt%
Gui, Add, Text, x122 y115 w20 h20 vRwinState, %stateRwin%
Gui, Add, Text, x152 y25 w20 h20 vRctrlStateP, %statePRctrl%
Gui, Add, Text, x152 y55 w20 h20 vRshiftStateP, %statePRshift%
Gui, Add, Text, x152 y85 w20 h20 vRaltStateP, %statePRalt%
Gui, Add, Text, x152 y115 w20 h20 vRwinStateP, %statePRwin%
Gui, Show, w200 h157, Finding Stuck Keys GUI
Gosub, DebugStickyKeys
return

DebugStickyKeys:
;If (stateLalt = 0 or statePLalt = 0) {
;    Send, {Lalt Up}
;}
;If (stateRalt = 1 or statePRalt = 1) {
;    Send, {Ralt Up}
;}
stateLalt := GetKeyState("LAlt")
statePLalt := GetKeyState("LAlt", "P")
stateLctrl := GetKeyState("LControl")
statePLctrl := GetKeyState("LControl", "P")
stateLshift := GetKeyState("LShift")
statePLshift := GetKeyState("LShift", "P")
stateLwin := GetKeyState("LWin")
statePLwin := GetKeyState("LWin", "P")
stateRalt := GetKeyState("RAlt")
statePRalt := GetKeyState("RAlt", "P")
stateRctrl := GetKeyState("RControl")
statePRctrl := GetKeyState("RControl", "P")
stateRshift := GetKeyState("RShift")
statePRshift := GetKeyState("RShift", "P")
stateRwin := GetKeyState("RWin")
statePRwin := GetKeyState("RWin", "P")
GuiControl,, LctrlState, %stateLctrl%
GuiControl,, LshiftState, %stateLshift%
GuiControl,, LaltState, %stateLalt%
GuiControl,, LwinState, %stateLwin%
GuiControl,, LctrlStateP, %statePLctrl%
GuiControl,, LshiftStateP, %statePLshift%
GuiControl,, LaltStateP, %statePLalt%
GuiControl,, LwinStateP, %statePLwin%
GuiControl,, RctrlState, %stateRctrl%
GuiControl,, RshiftState, %stateRshift%
GuiControl,, RaltState, %stateRalt%
GuiControl,, RwinState, %stateRwin%
GuiControl,, RctrlStateP, %statePRctrl%
GuiControl,, RshiftStateP, %statePRshift%
GuiControl,, RaltStateP, %statePRalt%
GuiControl,, RwinStateP, %statePRwin%

return

GuiClose:
GuiEsc:
ExitApp

;===============================================================================================

;===== FUNCTIONS ===============================================================================

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
