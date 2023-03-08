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

; message box to alert user that:
; 1. they should be in the PPRO Settings/>Lables panel
; 2. Inform User that this will load the Default set of labels into the fields
; 3. give options - OK to proceed & Cancel to cancel

MsgBox, 33, Load PPRO Label Fields, This script will load text vaules into the fields on the Settings->Labels panel in Premiere Pro.`n`nPlease make sure you are sitting with that panel open and ready to accept text entry before running this script.`n`nClick OK to begjn pasting the DEFAULT LABELS into the text fields.`nClick CANCEL to abort this process.

IfMsgBox Cancel
    ExitApp

; step through each text field and paste an entry

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
Send, FINAL EXPORT READY
Sleep, sleepShort
; field 11
Send, {Tab}
Sleep, sleepShort
Send, FINAL EXPORTED
Sleep, sleepShort
; field 12
Send, {Tab}
Sleep, sleepShort
Send, AWAITING COMMENTS
Sleep, sleepShort
; field 13
Send, {Tab}
Sleep, sleepShort
Send, NEEDS REVISIONS
Sleep, sleepShort
; field 14
Send, {Tab}
Sleep, sleepShort
Send, IN PROGRESS
Sleep, sleepShort
; field 15
Send, {Tab}
Sleep, sleepShort
Send, REVIEW READY
Sleep, sleepShort
; field 16
Send, {Tab}
Sleep, sleepShort
Send, EXPORT READY
Sleep, sleepShort

; Message box to declare process complete
MsgBox, Labels have been replaced.`n`nClick OK on the Settings panel to save them.

; exit the script WITHOUT saving of closing the Settings Panel

; END OF SCRIPT
ExitApp
