; AutoHotKey - Apply 6FRM Audio Crossfade
; by Ben Howard - ben@buttonpusher.tv

; ONE-SHOT SCRIPT
; The idea behind this script is that it is a one-shot file. There isn't a hard-coded hotkey. You call this by running
; it from StreamDeck (et al) each time you need it. And if you build up a small set of pre-built scripts, you can have 
; an easy way to just edit a given script that can change as you move from project to project.


;===== START OF AUTO-EXECUTION SECTION =========================================================
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force ; Ensures that there is only a single instance of this script running.

;===== INITIALIZATION - VARIABLES ==============================================================
; Sleep shortcuts - use these to standardize sleep times. Change here to change everywhere.
sleepShort = 333
sleepMedium = 666
sleepLong = 1500
sleepDeep = 3500

;===== END OF AUTO-EXECUTE =====================================================================
;===== MODIFIER MEMORY HELPER ==================================================================
; combine below with key and '::' to define hotkey 
; e.g.- ^f1::Msgbox You pressed Control and F1
; #=Win | !=Alt | ^=Ctrl | +=Shift | &=combine keys | *=ignore other mods
; <=use left mod key| >=use right mod key  | UP=fires on release

;===== MAIN HOTKEY DEFINITIONS HERE ============================================================
Send, {LShift Down}d{LShift Up}
Sleep, sleepShort
ToolTip, Make sure cursor is located *above* the level adjustment on the timeline
Click, 2
Sleep, sleepShort
Send, 6
Sleep, sleepShort
Send, {ENTER}

Exit