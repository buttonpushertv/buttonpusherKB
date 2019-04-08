; AutoHotKey - Premiere Pro MOD - Right Click on timeline to move playhead
; Based on original script by Taran - https://github.com/TaranVH/2nd-keyboard
; Modified by Ben Howard - ben@buttonpusher.tv

#SingleInstance force ; only 1 instance of this script may run at a time.
#InstallMouseHook
#InstallKeybdHook

CoordMode, Mouse, screen
CoordMode, Pixel, screen

Menu, Tray, Icon, imageres.dll, 90 ; sets the Tray Icon to a timeline looking thingy

;===== INITIALIZATION - VARIABLES ==============================================================
; Sleep shortcuts - use these to standardize sleep times. Change here to change everywhere.
sleepMicro := 15
sleepShort := 333
sleepMedium := 666
sleepLong := 1500
sleepDeep := 3500

splashScreenX = %1%
splashScreenY = %2%

;First, we define all the timeline's DEFAULT possible colors.
;(Note that your colors will be different if you changed the UI brightness inside preferences > appearance > brightness.)
;I used Window Spy (it comes with AHK) to detect the exact colors onscreen.
timeline1 := 0x414141 ;timeline color inside the in/out points ON a targeted track
timeline2 := 0x313131 ;timeline color of the separating LINES between targeted AND non targeted tracks inside the in/out points
timeline3 := 0x1B1B1B ;the timeline color inside in/out points on a NON targeted track
timeline4 := 0x212121 ;the color of the bare timeline NOT inside the in out points
timeline5 := 0x202020 ;the color of a SELECTED blank space on the timeline, NOT in the in/out points
timeline6 := 0x414141 ;the color of a SELECTED blank space on the timeline, IN the in/out points, on a TARGETED track
timeline7 := 0x1B1B1B ;the color of a SELECTED blank space on the timeline, IN the in/out points, on an UNTARGETED track

; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; NOTE THAT YOU MUST ASSIGN \(backslash) to "Move playhead to cursor" in Premiere's keyboard shortcuts panel!
; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

;===== SPLASH SCREEN TO ANNOUNCE WHAT SCRIPT DOES ==============================================
SplashTextOn, 600, 100, Launching %A_ScriptFullPath%, Loaded Premiere Pro Right-Click Timeline MOD.`n`nRight Click in timeline to move playhead.`n`nRight Clicking on clips should still work normally.
WinMove, Launching %A_ScriptFullPath%, , %splashScreenX%, %splashScreenY%
Sleep, sleepLong
SplashTextOff

#IfWinActive ahk_exe Adobe Premiere Pro.exe ;exact name was gotten from windowspy

Rbutton:: ; <-- PPRO: Right Click on Blank Timeline area to move playhead
MouseGetPos X, Y
PixelGetColor colorr, %X%, %Y%, RGB
; I removed Taran's "deselect-all" step. I have no idea why you'd ever want to ever "deselect all" when moving the playhead - BEN

if (colorr = timeline1 || colorr = timeline2 || colorr = timeline3 || colorr = timeline4 || colorr = timeline5 || colorr = timeline6 || colorr = timeline7)
	{
	click middle ;sends the middle mouse button to BRING FOCUS TO the timeline, WITHOUT selecting any clips or empty spaces between clips. very nice!
	if GetKeyState("Rbutton", "P") = 1 ;<----THIS is the only way to phrase this query.
		{
		loop
			{
			Send \ ;in premiere, this must be set to "move playhead to cursor."
			Tooltip, Right click playhead mod! ;you can remove this line if you don't like the tooltip. You don't need it!
			sleep 16 ;this loop will repeat every 16 milliseconds.
			if GetKeyState("Rbutton", "P") = 0
				{
				tooltip,
				goto theEnd
				break
				}
			}
		}
	;Send {escape} ;in case you end up inside the "delete" right click menu from the timeline
	}
else
	sendinput {Rbutton} ;this is to make up for the lack of a ~ in front of Rbutton. ... ~Rbutton. It allows the command to pass through, but only if the above conditions were NOT met.
theEnd:
Return


