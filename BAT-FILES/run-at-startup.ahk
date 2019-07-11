; AutoHotKey - BPTV-KB run-at-startup
; by Ben Howard - ben@buttonpusher.tv

;===== START OF AUTO-EXECUTION SECTION =========================================================
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; #Persistent ; Keeps script permanently running.
#SingleInstance force ; Ensures that there is only a single instance of this script running.
; SetTitleMatchMode, 2 ; sets title matching to search for "containing" instead of "exact"

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

Run, C:\BPTV-KB\BAT-FILES\user_files_VHDMount_to_X.cmd,,OutputVarPID
WinWait ahk_pid %OutputVarPID%
Winset, AlwaysOnTop, On, ahk_exe cmd.exe
Sleep, sleepDeep
WinActivate, ahk_exe cmd.exe
WinMaximize, ahk_exe cmd.exe
Winset, AlwaysOnTop, On, ahk_exe cmd.exe
Sleep, sleepDeep
WinActivate, ahk_exe cmd.exe
WinMaximize, ahk_exe cmd.exe
Winset, AlwaysOnTop, On, ahk_exe cmd.exe

;===== FUNCTIONS ===============================================================================
