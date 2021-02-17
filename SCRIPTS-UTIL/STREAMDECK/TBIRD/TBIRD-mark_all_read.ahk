; AutoHotKey - 1-Shot - TBIRD
; by Ben Howard - ben@buttonpusher.tv

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Event ; Thunderbird does not see 'Input' flavor Sends...
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;===== INITIALIZATION - VARIABLES ==============================================================
; Sleep shortcuts - use these to standardize sleep times. Change here to change everywhere.
sleepMicro := 5
sleepMini := 15
sleepTiny := 111
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
WinActivate, ahk_exe thunderbird.exe
Sleep, sleepShort
Send, {Shift Down}
Sleep, sleepShort
Send, c
Sleep, sleepShort
Send, {Shift Up}
ExitApp