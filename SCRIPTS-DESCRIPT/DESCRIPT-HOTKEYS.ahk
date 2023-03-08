; AutoHotKey - DESCRIPT HOTKEYS
; by Ben Howard - ben@buttonpusher.tv

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

;===== INITIALIZATION - VARIABLES ==============================================================
; Sleep shortcuts - use these to standardize sleep times
sleepMicro := 5
sleepMini := 15
sleepShort := 333
sleepMedium := 666
sleepLong := 1000
sleepDeep := 3500

;===== END OF AUTO-EXECUTE =====================================================================
;===== MODIFIER MEMORY HELPER ==================================================================
; combine below with key and '::' to define hotkey 
; e.g.- ^f1::Msgbox You pressed Control and F1
; #=Win | !=Alt | ^=Ctrl | +=Shift | &=combine keys | *=ignore other mods
; <=use left mod key| >=use right mod key  | UP=fires on release

;===== MAIN HOTKEY DEFINITIONS HERE ============================================================

#IfWinActive, ahk_exe Descript.exe

F12:: ;<-- Export a Timeline to an XML file
    Send, ^+e ; open Export window
    Sleep, sleepLong
    Send, {Tab} ;focus on export window
    Sleep, sleepLong
    Send, {Tab} ;focus on export type selector
    Sleep, sleepLong
    Send, {Enter} ;open the pulldown
    Sleep, sleepLong
    Send, {Down} ;move down one item
    Sleep, sleepMedium
    Send, {Down} ;move down one item
    Sleep, sleepMedium
    Send, {Down} ;move down one item
    Sleep, sleepMedium
    Send, {Enter} ; select 'Timeline' item
    Sleep, sleepLong
    Send, {Tab} ;move focus ahead by one area
    Sleep, sleepLong
    Send, {Tab} ;move focus ahead by one area
    Sleep, sleepLong
    Send, {Tab} ;move focus ahead by one area
    Sleep, sleepLong
    Send, {Tab} ;move focus ahead by one area
    Sleep, sleepLong
    Send, {Enter} ; save the XML
    Sleep, sleepLong
    Send, {Enter}
    Sleep, sleepMedium
    Send, {Escape}{Escape}
Return

#IfWinActive

;===============================================================================================

;===== FUNCTIONS ===============================================================================
