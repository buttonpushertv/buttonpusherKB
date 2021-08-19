; AutoHotKey - RunOrActivate - 1-Shot Template - v2
; by Ben Howard - ben@buttonpusher.tv

/*
To be used as a 1-Shot event when trying to call up an application from a hotkey or something like the StreamDeck (so we don't always launch new instances of apps)....There are no hotkey in this script.

Be careful with this though. It will not set the wokring directory (like you can in a BAT file). Use a BAT file to launch something that needs a working directory set.

TO USE THIS TEMPLATE:

1 - change the Launchcode to be the path to your app. If you are using an App in the C:\BKB hierarchy you can use '..\'s to work your way back up and down the folder paths.

2 - Change the WindowTitle to match your app when open. Use AHK's WindowSpy to find this exact bit and copy the text from WindowSpy & paste below. If you want/need to snag something other than the window's displayed title (the top line in WindowSpy), you could use 'ahk_class' or 'ahk_exe' - you would need to copy the whole item, like this: 'ahk_exe vnchelper.exe'

3 - Save this to a new AHK file, named appropriately and place into StreamDeck, etc.

There are a few MsgBox's that have been commented out to aid in debugging. Just uncomment them to see what is getting passed around the script.
*/

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
LaunchCode := "C:\Program Files\Adobe\Adobe Illustrator 2021\Adobe Illustrator 2020.lnk"
WindowTitle := "ahk_exe Illustrator.exe"

;MsgBox,,Attempt,Trying to run or activate:`n%WindowLaunch%,2
RunOrActivate(LaunchCode, WindowTitle)
ExitApp

;===== FUNCTIONS ===============================================================================

RunOrActivate(LaunchCode, Windowtitle)
{
   ;MsgBox, launching this code, LaunchCode:`n%LaunchCode%`n`nWindowTitle:%WindowTitle%`n
   if WinExist(WindowTitle) {
      ;MsgBox Activiating
      WinActivate, %WindowTitle%
      }
   else {
      ;MsgBox Running
      Run, %LaunchCode%
   }
}
