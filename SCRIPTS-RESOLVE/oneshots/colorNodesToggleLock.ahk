; BKB-RESOLVE 1-SHOT SCRIPT TEMPLATE
;
; This is the template for all the one shot scripts.

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include %A_ScriptDir%\..\RESOLVE-1SHOT-CONFIG.ahk

SetDefaultMouseSpeed, 0
MouseGetPos x, y ; store the location of the cursor, so we can put it back when done.

Click
Sleep, sleepShort
Click, right
Sleep, sleepShort
Click, left, 60, 85, Relative
SoundPlay, ..\SUPPORTING-FILES\SOUNDS\interfaceanditemsounds\V1.0\Interface\Item Lock (1).wav

MouseMove %x%, %y% ; restore the cursor to its location before 1-shot script was executed

ExitApp ; just to ensure the script exits