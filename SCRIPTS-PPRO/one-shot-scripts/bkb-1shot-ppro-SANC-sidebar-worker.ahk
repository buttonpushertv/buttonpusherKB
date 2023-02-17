; AutoHotKey - Buttonpusher Post-Production Keyboard Environment - Premiere Pro HotKeys
; by Ben Howard - ben@buttonpusher.tv

; One-shot Script for use with: Premiere Pro

; The idea nehind this script is to use it in conjunction with a Streamdeck, so you don't need to dedicate keyboard shortcuts to various tasks. Also should help fight the 'hiding' of commands, which get buried under key combos that can be hard to track or remember

;===== START OF AUTO-EXECUTION SECTION =========================================================
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; #Persistent ; Keeps script permanently running.
#SingleInstance force ; Ensures that there is only a single instance of this script running.
; SetTitleMatchMode, 2 ; sets title matching to search for "containing" instead of "exact"
#MaxHotkeysPerInterval 2000
#WinActivateForce ;https://autohotkey.com/docs/commands/_WinActivateForce.htm

; This is included to allow for app-related functions to be used in the script 
#Include %A_ScriptDir%\..\PREMIERE-PRO-FUNCTIONS.ahk

;===== MODIFIER MEMORY HELPER ==================================================================
; combine below with key and '::' to define hotkey
; e.g.- ^f1::Msgbox You pressed Control and F1
; #=Win | !=Alt | ^=Ctrl | +=Shift | &=combine keys | *=ignore other mods
; <=use left mod key| >=use right mod key  | UP=fires on release

; SCRIPT EXECUTION
; command for this 1-shot script go here

; THIS SCRIPT WAS CREATED FOR WORKFLOW ISSUES ON THE SANCTUARY HEALTH EDITING PROJECT

; THIS SCRIPT WILL PROCESS TEXT FROM THE CLIPBOARD INTO A PLACED MOGRT ON THE TIMELINE

; get the clipboard contents
; count the number of lines - cpLineLength
; open or focus the Essential Graphic panel
; paste the clipboard contents into the text field

; focus the timeline
; add edits into the MOGRT based on this pattern:
;  - starting at 2 secs, add an edit
;  - add then add cpLineLength edits into the MOGRT track

;MsgBox, , Ready to start, This will perfom several edits.`n`nPlease make sure you have done the following:`n1. Pasted Text into MOGRT`n2. Placed MOGRT past the end of the piece on timeline.`n3. Adjusted the line spacing for the sidebar items.`n`n4. Hit Save!`n`nReady to go?
;WinActivate, ahk_exe Adobe Premiere Pro.exe

;prfocus("timeline")
Send, ^+a
Sleep, 333

; TITLE START
Sleep, 333
Send, {NumpadAdd}
Sleep, 333
Send,{Numpad2}{NumpadDot}{Numpad1}{Numpad4}
Sleep, 333
Send, {NumpadEnter}
Sleep, 333
Send, {F4}
;TITLE END

Loop, 11
    {
    ; ITEM START
    Sleep, 333
    Send, {NumpadAdd}
    Sleep, 333
    Send,{Numpad1}{NumpadDot}{Numpad2}{Numpad3}
    Sleep, 333
    Send, {NumpadEnter}
    Sleep, 333
    Send, {F4}
    ;ITEM END
    }

Sleep, 333
; ENDING
Send, {Down}
Sleep, 333
Send, {NumpadSub}{Numpad1}{Numpad5}
Sleep, 333
Send, {NumpadEnter}
Sleep, 333
Send, {F4}




; END OF SCRIPT
ExitApp


/*
HOLDING THIS FOR LATER USE
Loop, 12
    {
    ; ITEM START
    Sleep, 333
    Send, {NumpadAdd}
    Sleep, 333
    Send,{Numpad1}{NumpadDot}{Numpad2}{Numpad3}
    Sleep, 333
    Send, {NumpadEnter}
    Sleep, 333
    Send, {F4}
    ;ITEM END
    }
*/
