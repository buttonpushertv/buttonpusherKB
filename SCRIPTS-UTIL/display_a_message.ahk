; AutoHotKey - Display a Message passed from the commandline
; by Ben Howard - ben@buttonpusher.tv

;To be used as a 1-Shot event when trying to call up an application from a hotkey or something like the StreamDeck (so we don't always launch new instances of apps)....There are no hotkey in this script.

; IMPORTANT NOTE - since the StreamDeck can't accept commandline arguments, this version doesn't work as well. Use the version 2 Template to create hard-coded, 1-shot app runOrActivate scripts.

;Be careful with this though. It will not set the wokring directory (like you can in a BAT file). Use a BAT file to launch something that needs a working directory set.

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
sleepMicro := 5
sleepMini := 15
sleepTiny := 111
sleepShort := 333
sleepMedium := 666
sleepLong := 1500
sleepDeep := 3500

EnvGet, scriptRootFolder, BKB_ROOT
;===== END OF AUTO-EXECUTE =====================================================================
SoundPlay, %2%
MsgBox, , An important message, %1%, 3
ExitApp


;===== FUNCTIONS ===============================================================================
