; AutoHotKey - RunOrActivate - VNCHelper
; by Ben Howard - ben@buttonpusher.tv

;To be used as a 1-Shot event when trying to call up an application from a hotkey or something like the StreamDeck (so we don't always launch new instances of apps)....There are no hotkey in this script.

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

;===== END OF AUTO-EXECUTE =====================================================================
DetectHiddenWindows, On
LaunchCode := "..\..\BAT-FILES\STREAMDECK-BATS\vnchelper.cmd"
WindowTitle := "VNC helper"

;MsgBox,,Attempt,Trying to run or activate:`n%AppToRun%,2
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
      ;Sleep, 3500
      ;WinActivate, C:\Windows\system32\cmd.exe
      ;WinClose, C:\Windows\system32\cmd.exe
   }
}