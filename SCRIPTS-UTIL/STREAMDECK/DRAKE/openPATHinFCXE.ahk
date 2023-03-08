SetWorkingDir %A_ScriptDir%
#Include %A_ScriptDir%\DRAKE-FUNCTIONS.ahk

; Usage should be: "C:\Program Files\AutoHotkey\AutoHotkey.exe" "C:\BKB\SCRIPTS-UTIL\STREAMDECK\DRAKE\openPATHinFCXE.ahk" "(path to open - quotes if needed)"

; You need the quotes to enclose paths with spaces.

pathGot = %1%
;MSGBOX, , DEBUG, %pathGot%

WinActivate, ahk_exe FreeCommander.exe

openInFCXE(pathGot)

exitapp
