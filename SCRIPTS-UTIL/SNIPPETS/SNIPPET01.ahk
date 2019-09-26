; AutoHotKey - Text Snippet Macro
; by Ben Howard - ben@buttonpusher.tv

; The purpose of this script is to insert snippets of text quickly. Simply edit the text below & then call the script
; from a StreamDeck (or other programmable macro pad). The idea is to facilitate inputting snippets quickly, so that
; you can keep things consistent without having to always type out long chunks of commonly used text in your projects.

; The idea behind this script is that it is a one-shot file. There isn't a hard-coded hotkey. You call this by running
; it from StreamDeck (et al) each time you need it. And if you build up a small set of pre-built scripts, you can have
; an easy way to just edit a given script that can change as you move from project to project.

;

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
Send, TaranVH's 2nd-keyboard project (https://github.com/TaranVH/2nd-keyboard)
Exit
