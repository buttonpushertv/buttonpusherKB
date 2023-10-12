; AutoHotKey - FREECOMMANDER-HOTKEYS.ahk
; by Ben Howard - ben@buttonpusher.tv

;===== START OF AUTO-EXECUTION SECTION =========================================================
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; #Persistent ; Keeps script permanently running.
#SingleInstance force ; Ensures that there is only a single instance of this script running.
; SetTitleMatchMode, 2 ; sets title matching to search for "containing" instead of "exact"

Menu, Tray, NoIcon ; removes the tray icon
;===== INITIALIZATION - VARIABLES ==============================================================
; Sleep shortcuts - use these to standardize sleep times
sleepMicro := 5
sleepMini := 15
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

#IfWinActive, ahk_exe FreeCommander.exe

F13:: ;<-- Get the name of the current selected item & copy to clipboard
;press F2 to toggle text selection
Send, {F2}
Sleep, sleepShort
;copy to clipboard
Send, ^c
Sleep, sleepShort
Send, {Escape}
return


#IfWinActive
;===== FUNCTIONS ===============================================================================

/*
HOLDING TANK for inactive hotkeys

F13:: ; NO IDEA WHAT THIS WAS FOR - something about making a new folder from clipboard text
Send, {ShiftDown}}{AltDown}c{ShiftUp}{AltUp}
Sleep, sleepMedium
Send, {Tab}
Sleep, sleepMedium
Send, {F7}
Sleep, sleepMedium
Send, {CtrlDown}v{CtrlUp}
Sleep, sleepMedium
Send, {Enter}
Return

*/