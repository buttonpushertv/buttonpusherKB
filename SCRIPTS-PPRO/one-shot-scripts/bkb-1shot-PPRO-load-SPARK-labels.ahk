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

; Sleep shortcuts - use these to standardize sleep times. Change here to change everywhere.
sleepMicro := 5
sleepMini := 15
sleepShort := 333
sleepMedium := 666
sleepLong := 1500
sleepDeep := 3500

; This is included to allow for app-related functions to be used in the script 
#Include %A_ScriptDir%\..\PREMIERE-PRO-FUNCTIONS.ahk

; This script will store the contents of the PPRO Settings->Labels panel to a text file

labelSet := "IGNITING THE SPARK"

; message box to alert user that:
; 1. they should be in the PPRO Settings/>Lables panel
; 2. Inform User that this will load the labelSet(from above) of labels into the fields
; 3. give options - OK to proceed & Cancel to cancel

MsgBox, 33, Load PPRO Label Fields, This script will load text vaules into the fields on the Settings->Labels panel in Premiere Pro for this project:`n`n %labelSet% Labels`n`nPlease make sure you are sitting with that panel open and have clicked on the Labels entry in the sidebar before running this script.`n`nClick OK to begjn pasting the %labelSet% labels into the text fields.`n`nClick CANCEL to abort this process.

IfMsgBox Cancel
    ExitApp

; step through each text field and paste an entry
WinActivate, ahk_exe Adobe Premiere Pro.exe
Sleep, sleepShort

; field 1
Send, {Tab}
Sleep, sleepShort
Send, Violet
Sleep, sleepShort
; field 2
Send, {Tab}
Sleep, sleepShort
Send, Iris
Sleep, sleepShort
; field 3
Send, {Tab}
Sleep, sleepShort
Send, Caribbean
Sleep, sleepShort
; field 4
Send, {Tab}
Sleep, sleepShort
Send, Lavender
Sleep, sleepShort
; field 5
Send, {Tab}
Sleep, sleepShort
Send, Cerulean
Sleep, sleepShort
; field 6
Send, {Tab}
Sleep, sleepShort
Send, Forest
Sleep, sleepShort
; field 7
Send, {Tab}
Sleep, sleepShort
Send, Rose
Sleep, sleepShort
; field 8
Send, {Tab}
Sleep, sleepShort
Send, Mango
Sleep, sleepShort
; field 9
Send, {Tab}
Sleep, sleepShort
Send, Purple
Sleep, sleepShort
; field 10
Send, {Tab}
Sleep, sleepShort
Send, INT-REVIEWED BY BEN
Sleep, sleepShort
; field 11
Send, {Tab}
Sleep, sleepShort
Send, KELLEY-PREPPED
Sleep, sleepShort
; field 12
Send, {Tab}
Sleep, sleepShort
Send, SINGLE CAM INT
Sleep, sleepShort
; field 13
Send, {Tab}
Sleep, sleepShort
Send, Tan
Sleep, sleepShort
; field 14
Send, {Tab}
Sleep, sleepShort
Send, Green
Sleep, sleepShort
; field 15
Send, {Tab}
Sleep, sleepShort
Send, Brown
Sleep, sleepShort
; field 16
Send, {Tab}
Sleep, sleepShort
Send, KELLEY-PREP-withGOLDs
Sleep, sleepShort

; Message box to declare process complete
MsgBox, Labels have been replaced with labels for:`n`n %labelSet% Labels`n`nClick OK on the Settings panel to save them.


; exit the script WITHOUT saving of closing the Settings Panel

; END OF SCRIPT
ExitApp

/*
1-Violet
2-Iris
3-Caribbean
4-Lavender
5-Cerulean
6-Forest
7-Rose
8-Mango
9-Purple
10-INT-REVIEWED BY BEN
11-MULTICAM-APPLIED
12-SINGLE CAM INT
13-Tan
14-Green
15-Brown
16-KELLEY-PREP-withGOLDs
*/

