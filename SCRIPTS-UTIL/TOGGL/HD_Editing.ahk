; AutoHotKey - Text Snippet Macro
; by Ben Howard - ben@buttonpusher.tv

; TOGGL
; this family of AHK scripts is for use with TOGGL (http://toggl.com) - specifically with the TOGGL Desktop App.
; Mouse clicks are based off of the Window x & y coords - to make it work wherever the TOGGL Desktop App window is.

; ONE-SHOT SCRIPT
; The idea behind this script is that it is a one-shot file. There isn't a hard-coded hotkey. You call this by running
; it from StreamDeck (et al) each time you need it. And if you build up a small set of pre-built scripts, you can have
; an easy way to just edit a given script that can change as you move from project to project.



;===== START OF AUTO-EXECUTION SECTION =========================================================
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode, Event  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force ; Ensures that there is only a single instance of this script running.
;#InstallKeybdHook
;#UseHook On
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
CoordMode, Mouse, Window
WinActivate, Toggl Desktop
Sleep, sleepMedium
Click, 20, 60
Sleep, sleepMedium
Send, HD Editing
Sleep, sleepShort
MouseMove, 325, 60
Exit
