; AutoHotKey - VISUALSTUDIO-HOTKEYS.ahk
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

EnvGet, Settings_rootFolder, BKB_ROOT
;MSGBOX, , DEBUG, %Settings_rootFolder%
;===== END OF AUTO-EXECUTE =====================================================================
;===== MODIFIER MEMORY HELPER ==================================================================
; combine below with key and '::' to define hotkey 
; e.g.- ^f1::Msgbox You pressed Control and F1
; #=Win | !=Alt | ^=Ctrl | +=Shift | &=combine keys | *=ignore other mods
; <=use left mod key| >=use right mod key  | UP=fires on release

;===== MAIN HOTKEY DEFINITIONS HERE ============================================================

#IfWinActive, ahk_exe Code.exe

;===== SHIFT-CONTROL-ALT-FUNCTION KEY DEFINITIONS HERE =========================================
+^!f1:: ;<-- Type a Comment template
    Send, {Space}
    Send, {Raw};<--
    Send, {Space}
    Return
;+^!f2::
;+^!f3::
+^!f4:: Send, Sleep`, sleepShort
+^!f5:: Send, MSGBOX, , DEBUG, ; <--VIZ STUDIO CODE: Make a DEBUG MsgBox
+^!f6:: Run, "..\SCRIPTS-UTIL\search-for-AHK-token.ahk" ; <--VIZ STUDIO CODE: Search AHK Help for Token Word under cursor (Run search-for-AHK-token.ahk)
;+^!f7::
;+^!f8::
;+^!f9:: 
;+^!f10::
+^!F11:: Send, MSGBOX, , Made it here! ; <--VIZ STUDIO CODE: Make a MSGBOX to act as a flag for script routing
;+^!f12::
;+^!f13::
;+^!f14::
;+^!f15::
;+^!f16::
;+^!f17::
;+^!f18::
;+^!f19::
;+^!f20::
;+^!f21::
;+^!f22::
;+^!f23::
;+^!f24::

#IfWinActive

;===== END Program 1 DEFINITIONS ===============================================================

#IfWinActive

;===== HOLDING TANK FOR DEACTIVATED HOTKEYS ====================================================
/* Just a place to store Hotkeys that I don't need but want to keep around...just in case.


*/


;===== FUNCTIONS ===============================================================================

