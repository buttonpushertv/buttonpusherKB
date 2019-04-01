﻿; AutoHotKey - Blank Template by Ben Howard - ben@buttonpusher.tv
; You can customize this template by editing "C:\Windows\ShellNew\Template.ahk"
;===============================================================================================
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


;===== FUNCTIONS ===============================================================================

showText(fileToShow){
FileRead, textToShow, %fileToShow%
Gui, +alwaysontop +disabled -sysmenu +owner -caption +toolwindow +0x02000000
Gui, Color, 000000
Gui, Margin, 30, 30
Gui, font, s14 cFFFFFF, Consolas
Gui, add, text, , %textToShow%
Gui, Show
return
}

showPic(picToShow){
Gui, +alwaysontop +disabled -sysmenu +owner -caption +toolwindow +0x02000000
Gui, Color, 000000
Gui, Margin, 30, 30
Gui, add, picture, , %picToShow%
Gui, Show
return
}

killGui(){
Gui, Destroy
return
}