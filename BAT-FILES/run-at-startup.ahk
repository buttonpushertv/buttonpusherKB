; AutoHotKey - buttonpusherKB run-at-startup
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

EnvGet, Settings_rootFolder, BKB_ROOT

;iniFile := "C:\BKB\settings.ini"
;IniRead, Settings_rootFolder, %iniFile%, Settings, rootFolder

;===== END OF AUTO-EXECUTE =====================================================================
;===== MODIFIER MEMORY HELPER ==================================================================
; combine below with key and '::' to define hotkey
; e.g.- ^f1::Msgbox You pressed Control and F1
; #=Win | !=Alt | ^=Ctrl | +=Shift | &=combine keys | *=ignore other mods
; <=use left mod key| >=use right mod key  | UP=fires on release

;===== MAIN HOTKEY DEFINITIONS HERE ============================================================

; The setting below might be a way to get the rootFolder setting available to everything else
Run, %Settings_rootFolder%\BAT-FILES\setENVIRONVARS.cmd,,

Run, %Settings_rootFolder%\BAT-FILES\user_files_VHDMount_to_X.cmd,,OutputVarPID
WinWait ahk_pid %OutputVarPID%
Winset, AlwaysOnTop, On, ahk_exe cmd.exe ; all the commands that come after this are my attempt to force
Sleep, sleepDeep                         ; the Command window to stay in the foreground so that it is easy
WinActivate, ahk_exe cmd.exe             ; to type my BitLocker password into without having to mouse over
WinMaximize, ahk_exe cmd.exe             ; to it and click and then type.
Winset, AlwaysOnTop, On, ahk_exe cmd.exe ; All the other apps that load at boot keep stealing focus from this
Sleep, sleepDeep                         ; Window. I had to run through these commands a few times because
WinActivate, ahk_exe cmd.exe             ; other apps are rude and there's not an obvious way to force a Command
WinMaximize, ahk_exe cmd.exe             ; window to always stay on top & keep focus no matter what.
Winset, AlwaysOnTop, On, ahk_exe cmd.exe

;===== FUNCTIONS ===============================================================================
