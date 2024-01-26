; BKB-RESOLVE 1-SHOT SCRIPT TEMPLATE
;
; This is the template for all the one shot scripts.

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

CoordMode, Mouse, Screen

#Include %A_ScriptDir%\..\RESOLVE-1SHOT-CONFIG.ahk

SetDefaultMouseSpeed, 0
MouseGetPos x, y ; store the location of the cursor, so we can put it back when done.

tempName = %A_ScriptName%
StringTrimRight, currentName, tempName, 4

;first open the Clips menu on the Color Page to get to the correct item
locToGetX := "colorClipsOpenMenuLocX"
locToGetY := "colorClipsOpenMenuLocY"

currentLocX = % %locToGetX%
currentLocY = % %locToGetY%

SendEvent {Click, %currentLocX%, %currentLocY%}

; rather than using the coords of the item to select, we will use the arrow keys to navigate to the item we want
Sleep, sleepMedium
Loop 14 {
    Send, {Down}
}
Sleep, sleepMedium
Send, {Right}
Sleep, sleepMedium
Send, {Enter}


MouseMove %x%, %y% ; restore the cursor to its location before 1-shot script was executed

ExitApp ; just to ensure the script exits