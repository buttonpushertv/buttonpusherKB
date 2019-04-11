; AutoHotKey - RunOrActivate Portable Thunderbird
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

;===== END OF AUTO-EXECUTE =====================================================================
DetectHiddenWindows, On
LaunchCode := "X:\PortableApps\ThunderbirdPortable2ndProfile\ThunderbirdPortable2ndProfile.exe"
WindowTitle := "ahk_class MozillaWindowClass"

;MsgBox,,Attempt,Trying to run or activate:`n%WindowTitle%,2
RunOrActivate(LaunchCode, WindowTitle)
ExitApp

;===== FUNCTIONS ===============================================================================

RunOrActivate(LaunchCode, Windowtitle)
{
   ;MsgBox, launching this code, LaunchCode:`n%LaunchCode%`n`nWindowTitle:%WindowTitle%`n
   ;Check for WindowTitle
   if WinExist(WindowTitle) {
      ;MsgBox Activiating
      WinActivate, %WindowTitle%
      }
   else {
      ;MsgBox Running
      Run, %LaunchCode%
   }
}