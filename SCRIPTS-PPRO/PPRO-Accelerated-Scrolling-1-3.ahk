; Accelerated Scrolling
; V1.3
; By BoffinbraiN
; with additons by ben@buttonpusher.tv

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent ; Keeps script permanently running.
#SingleInstance force ; Ensures that there is only a single instance of this script running.
;#NoTrayIcon
Menu, Tray, Icon, imageres.dll, 306 ;tray icon is now an icon
#MaxHotkeysPerInterval 120

; Sleep shortcuts - use these to standardize sleep times. Change here to change everywhere.
sleepMicro := 15
sleepShort := 333
sleepMedium := 666
sleepLong := 1500
sleepDeep := 3500

Process, Priority, , H
SendMode Input

; Show scroll velocity as a tooltip while scrolling. 1 or 0.
tooltips := 0

; The length of a scrolling session.
; Keep scrolling within this time to accumulate boost.
; Default: 500. Recommended between 400 and 1000.
timeout := 500

; If you scroll a long distance in one session, apply additional boost factor.
; The higher the value, the longer it takes to activate, and the slower it accumulates.
; Set to zero to disable completely. Default: 30.
boost := 30

; Spamming applications with hundreds of individual scroll events can slow them down.
; This sets the maximum number of scrolls sent per click, i.e. max velocity. Default: 60.
limit := 60

; Runtime variables. Do not modify.
distance := 0
vmax := 1

; Key bindings

#IfWinActive, ahk_exe Adobe Premiere Pro.exe
WheelUp::    Goto Scroll ; <-- Accelerated Scroll Up (limited to PPRO only currently)
WheelDown::  Goto Scroll ; <-- Accelerated Scroll Down (limited to PPRO only currently)
#WheelUp::   Suspend ; <-- Suspend Accelerated Scrolling (limited to PPRO only currently)
#WheelDown:: Goto Quit ; <-- Quit Accelerated Scrolling (limited to PPRO only currently)

#IfWinActive

Scroll:
	t := A_TimeSincePriorHotkey
	if (A_PriorHotkey = A_ThisHotkey && t < timeout)
	{
		; Remember how many times we've scrolled in the current direction
		distance++

		; Calculate acceleration factor using a 1/x curve
		v := (t < 80 && t > 1) ? (250.0 / t) - 1 : 1

		; Apply boost
		if (boost > 1 && distance > boost)
		{
			; Hold onto the highest speed we've achieved during this boost
			if (v > vmax)
				vmax := v
			else
				v := vmax

			v *= distance / boost
		}

		; Validate
		v := (v > 1) ? ((v > limit) ? limit : Floor(v)) : 1

		if (v > 1 && tooltips)
			QuickToolTip("×"v, timeout)

		MouseClick, %A_ThisHotkey%, , , v
	}
	else
	{
		; Combo broken, so reset session variables
		distance := 0
		vmax := 1

		MouseClick %A_ThisHotkey%
	}
	return

Quit:
	QuickToolTip("Exiting Accelerated Scrolling...", 1000)
	Sleep 1000
	ExitApp

QuickToolTip(text, delay)
{
	ToolTip, %text%
	SetTimer ToolTipOff, %delay%
	return

	ToolTipOff:
	SetTimer ToolTipOff, Off
	ToolTip
	return
}

RemoveSplashScreen:
    SplashTextOff
    SetTimer RemoveSplashScreen, Off
    return