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

; This script will store the contents of the PPRO Settings->Labels panel to a text file

; message box to alert user that:
; 1. they should be in the PPRO Settings/>Lables panel
; 2. give options - OK to proceed & Cancel to cancel

; input box to get name of labels file to be stored

; step through each Label field and copy each item to clipboard
; and then store to array & save to a file



; END OF SCRIPT
ExitApp
