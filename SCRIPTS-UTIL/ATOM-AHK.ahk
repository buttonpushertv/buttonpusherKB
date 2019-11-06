; AutoHotKey - Atom Helper Script for AHK work
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
sleepMicro := 15
sleepShort := 333
sleepMedium := 666
sleepLong := 1500
sleepDeep := 3500

splashScreenX = %1%
splashScreenY = %2%
splashScreenTimeout = %3%

iniFile := "..\settings.ini"
IniRead, Settings_rootFolder, %iniFile%, Settings, rootFolder
;MsgBox, %Settings_rootFolder%
;===== SPLASH SCREEN TO ANNOUNCE WHAT SCRIPT DOES ==============================================
SplashTextOn, 600, 100, Launching %A_ScriptFullPath%, Loading ATOM AHK HELPER Script.`n`nF1 <-- Search selected AHK command in web docs.
WinMove, Launching %A_ScriptFullPath%, , %splashScreenX%, %splashScreenY%
SetTimer, RemoveSplashScreen, %splashScreenTimeout%
;===== END OF AUTO-EXECUTE =====================================================================
;===== MODIFIER MEMORY HELPER ==================================================================
; combine below with key and '::' to define hotkey
; e.g.- ^f1::Msgbox You pressed Control and F1
; #=Win | !=Alt | ^=Ctrl | +=Shift | &=combine keys | *=ignore other mods
; <=use left mod key| >=use right mod key  | UP=fires on release

;===== MAIN HOTKEY DEFINITIONS HERE ============================================================
;===== APPLICATION SPECIFIC HOTKEY DEFINITIONS HERE ============================================

#IfWinActive, ahk_exe atom.exe

;===== SHIFT-CONTROL-ALT-FUNCTION KEY DEFINITIONS HERE =========================================
; Quick template for the 16 Function keys to use as SCAF Keys.

; What are SCAF Keys? It's my method of creating a standardized set of macro keys. I have several
; keyboards/macropads with the keys programmed in (via QMK or device driver/config apps) so that
; I have easy access to a set of keys that are not likely to be used by other apps. Use them for
; any kind of repetitive task or other function that may not have an existing (or inconvinient)
; keystroke combo to execute.

+^!f1::Run, "SNIPPETS\SNIPPET01.ahk"
;+^!f2::
;+^!f3::
;+^!f4::
+^!f5:: Send, MSGBOX, , DEBUG,
+^!f6:: Run, "search-for-AHK-token.ahk"
;+^!f7::
;+^!f8::
;+^!f9::
;+^!f10::
;+^!f11::
;+^!f12::
;+^!f13::
;+^!f14::
;+^!f15::
;+^!f16::


#IfWinActive

;===== END Program 1 DEFINITIONS ===============================================================

;===== FUNCTIONS ===============================================================================

RemoveSplashScreen:
    SplashTextOff
    SetTimer RemoveSplashScreen, Off
    return
