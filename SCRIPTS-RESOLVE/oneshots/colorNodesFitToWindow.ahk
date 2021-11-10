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

locToGetX := currentName . "LocX"
locToGetY := currentName . "LocY"

currentLocX = % %locToGetX%
currentLocY = % %locToGetY%

PixelSearch, foundLocX, foundLocY, %currentLocX%, %currentLocY%, %tempSearchZoneX%, %tempSearchZoneY%, 0x282828, 10, Fast

PixelGetColor, foundPixelColor, %currentLocX%, %currentLocY%
MouseMove, %currentLocX%, %currentLocY%

;MSGBOX, foundPixelColor:%foundPixelColor%`n%foundLocX%`n%foundLocY%`ncurrentLocX:%currentLocX%`ncurrentLocY:%currentLocY%`ntempSearchZoneX:%tempSearchZoneX%`ntempSearchZoneY:%tempSearchZoneY%

if ErrorLevel {
	MSGBOX, A clear portion of the node panel could not be found
	ExitApp
	}
else
	Click, right, %foundLocX%, %foundLocY%
	Sleep, 333
	Send, {Down}{Down}{Down}{Down}{Down}{Down}{Down}{Enter}

MouseMove %x%, %y% ; restore the cursor to its location before 1-shot script was executed

ExitApp ; just to ensure the script exits