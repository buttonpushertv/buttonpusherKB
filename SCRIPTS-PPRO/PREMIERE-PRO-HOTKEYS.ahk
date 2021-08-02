; AutoHotKey - Buttonpusher Post-Production Keyboard Environment - Premiere Pro HotKeys
; by Ben Howard - ben@buttonpusher.tv

;===== START OF AUTO-EXECUTION SECTION =========================================================
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; #Persistent ; Keeps script permanently running.
#SingleInstance force ; Ensures that there is only a single instance of this script running.
; SetTitleMatchMode, 2 ; sets title matching to search for "containing" instead of "exact"
#MaxHotkeysPerInterval 2000
#WinActivateForce ;https://autohotkey.com/docs/commands/_WinActivateForce.htm

;Menu, Tray, Icon, shell32.dll, 116 ; this changes the tray icon to a filmstrip!
Menu, Tray, NoIcon
;===== INITIALIZATION - VARIABLES ==============================================================
; Sleep shortcuts - use these to standardize sleep times. Change here to change everywhere.
sleepMicro := 5
sleepMini := 15
sleepShort := 333
sleepMedium := 666
sleepLong := 1500
sleepDeep := 3500

#Include %A_ScriptDir%\PREMIERE-PRO-FUNCTIONS.ahk

; This section pre-defines the (most likely) location of the Program Monitor's Timecode display based on which edit system you happen to be working on. It also is tied to the most commonly used window layout that I use in each location.

EnvGet, Settings_rootFolder, BKB_ROOT
iniFile := Settings_rootFolder . "\settings.ini" ; the main settings file used by most of the buttonpusherKB scripts
IniRead, xposP, %inifile%, Settings, TCDisplayXpos
IniRead, yposP, %inifile%, Settings, TCDisplayYpos

;===== END OF AUTO-EXECUTE =====================================================================

;===== MODIFIER MEMORY HELPER ==================================================================
; combine below with key and '::' to define hotkey
; e.g.- ^f1::Msgbox You pressed Control and F1
; #=Win | !=Alt | ^=Ctrl | +=Shift | &=combine keys | *=ignore other mods
; <=use left mod key| >=use right mod key  | UP=fires on release

;===== MAIN HOTKEY DEFINITIONS HERE ============================================================

;===== PREMIERE PRO HOTKEY DEFINITIONS HERE ============================================

#IfWinActive, ahk_exe Adobe Premiere Pro.exe

^1:: ; <-- Step Left 1 second
Send, ^+a
Sleep, sleepShort
Send, {NumpadSub}
Sleep, sleepMicro
Send, {Numpad1}
Sleep, sleepMicro
Send, {NumpadDot}
Sleep, sleepMicro
Send, {NumpadEnter}{NumpadEnter}
return

^2:: ; <-- Step Left 5 seconds THEN Play
Send, {2}
Sleep, sleepShort
Send, ^+a
Sleep, sleepShort
Send, {NumpadSub}
Sleep, sleepMicro
Send, {Numpad5}
Sleep, sleepMicro
Send, {NumpadDot}
Sleep, sleepMicro
Send, {NumpadEnter}{NumpadEnter}
Sleep, sleepMicro
Send, 3
return

^3:: ; <-- Step Right 1 second
Send, ^+a
Sleep, sleepShort
Send, {NumpadAdd}
Sleep, sleepMicro
Send, {Numpad1}
Sleep, sleepMicro
Send, {NumpadDot}
Sleep, sleepMicro
Send, {NumpadEnter}{NumpadEnter}
return

^+1:: ; <-- Step Left 5 seconds
Sleep, sleepMicro
Send, ^+a
Sleep, sleepShort
Send, {NumpadSub}
Sleep, sleepMicro
Send, {Numpad5}
Sleep, sleepMicro
Send, {NumpadDot}
Sleep, sleepMicro
Send, {NumpadEnter}{NumpadEnter}
return

^+2:: ; <-- Step Left 10 seconds THEN Play
Send, {2}
Sleep, sleepShort
Send, ^+a
Sleep, sleepShort
Send, {NumpadSub}
Sleep, sleepMicro
Send, {Numpad1}
Sleep, sleepMicro
Send, {Numpad0}
Sleep, sleepMicro
Send, {NumpadDot}
Sleep, sleepMicro
Send, {NumpadEnter}{NumpadEnter}
Sleep, sleepMicro
Send, 3
return

^+3:: ; <-- Step Right 5 Seconds
Sleep, sleepMicro
Send, ^+a
Sleep, sleepShort
Send, {NumpadAdd}
Sleep, sleepMicro
Send, {Numpad5}
Sleep, sleepMicro
Send, {NumpadDot}
Sleep, sleepMicro
Send, {NumpadEnter}{NumpadEnter}
return

^+F3:: ; <-- Mark current clip & Ripple Delete
Sleep, sleepShort
Send, {Control Down}
Sleep, sleepShort
Send, {F3}
Sleep, sleepShort
Send, {Control Up}
Sleep, sleepShort
Send, {Shift Down}x{Shift Up}
Return

^+F4:: ; <-- Add edit, mark previous clip and delete (this WILL pull up the rest of the timeline)
Sleep, sleepShort
Send, {F4}
Sleep, sleepShort
Send, {Up}
Sleep, sleepShort
Send, {Control Down}{F3}{Control Up}
Sleep, sleepShort
Send, {Shift Down}x{Shift Up}
Return

^!F4:: ; <-- Add edit, mark previous clip and remove (this WILL NOT pull up the rest of the timeline)
Sleep, sleepShort
Send, {F4}
Sleep, sleepShort
Send, {Up}
Sleep, sleepShort
Send, {Control Down}{F3}{Control Up}
Sleep, sleepShort
Send, {Shift Down}z{Shift Up}
; AND THIS WILL RETURN THE PLAYHEAD TO THE POINT OF THE EDIT
Send, {Down}
Return

!z:: ; <-- Select clip @ playhead & delete it
Send, d ; PPro Key for 'select clip at playhead'
Send, {DEL} ; PPro Key for 'remove'
return

; these are usage examples for the functions to grab the timecode of the current Program Monitor sequence.

^+!i:: ; <-- Find Coordinates of Sequence Timecode so 'Get Current Timecode of Sequence' below knows where to look.
  getTCDisplayCoords(xposP, yposP)
  Run, %Settings_rootFolder%\SCRIPTS-UTIL\pingPos.ahk %xposP% %yposP% "Screen"
  ;MSGBOX, , DEBUG, This is what came back from the function: X=%xposP% / Y=%yposP%
  Return

+!i:: ; <-- Get Current Timecode of Sequence
  CoordMode, Mouse, Screen
  grabTCAsText(grabbedTC, xposP, yposP)
  ToolTip, Grabbed %grabbedTC% to Clipboard
  RemoveToolTip(2000)
  ;MSGBOX,,Timecode value read..., This is the value of grabbedTC: %grabbedTC% `nThis is the value stored on the clipboard: %clipboard%`n`nYou can send this to other apps by editing %A_ScriptName% and using the function 'grabTCAsText' (see PREMIERE-PRO-FUNCTIONS.ahk for more info)., 2
  Return

^!i:: ; <-- Show coords that are stored
  CoordMode, Mouse, Screen
  MouseMove, xposP, yposP
  Tooltip, Mouse positioned at:`nxposP:%xposP%/yposP:%yposP%
  Run, %Settings_rootFolder%\SCRIPTS-UTIL\pingPos.ahk %xposP% %yposP% "Screen"
  RemoveToolTip(2500)
  Return

/*
TEMPORARILY DISABLING THESE COMMANDS

F20:: ; <-- Step Left 2 seconds
Sleep, sleepMicro
Send, ^+a
Sleep, sleepShort
Send, {NumpadSub}
Sleep, sleepMicro
Send, {Numpad2}
Sleep, sleepMicro
Send, {NumpadDot}
Sleep, sleepMicro
Send, {NumpadEnter}{NumpadEnter}
return

F21:: ; <-- Step Right 2 Seconds
Sleep, sleepMicro
Send, ^+a
Sleep, sleepShort
Send, {NumpadAdd}
Sleep, sleepMicro
Send, {Numpad2}
Sleep, sleepMicro
Send, {NumpadDot}
Sleep, sleepMicro
Send, {NumpadEnter}{NumpadEnter}
return



F23:: ; <-- Send '-30'
Sleep, sleepShort
Send, {NumpadSub}
Sleep, sleepMicro
Send, {Numpad3}
Sleep, sleepMicro
Send, {Numpad0}
Sleep, sleepMicro
Send, {NumpadEnter}
Return

F24:: ; <-- Send '+30'
Sleep, sleepShort
Send, {NumpadAdd}
Sleep, sleepMicro
Send, {Numpad3}
Sleep, sleepMicro
Send, {Numpad0}
Sleep, sleepMicro
Send, {NumpadEnter}
Return
*/

;these hotkeys are used by instantVFX()
F13::
  global VFXKey = "F13"
  instantVFX("position")
return

F14::
	global VFXkey = "F14"
	instantVFX("scale")
return

F15::
	global VFXkey = "F15"
	instantVFX("rotation")
return

F16::
	global VFXkey = "F16"
	instantVFX("anchor_point_vertical")
return

F17::
	global VFXkey = "F17"
	instantVFX("anchor_point")
return


; The section below addresses the issue of the Alt key opening the menu bar items. Even though there is a block in MASTER-SCRIPT that prevents the Left Alt key from opening menu items, if you press the Alt plus another key, it will still open the menu. The block just prevents the Left Alt from setting the focus on the menu bar until you hit Escape. If you want to use Alt with C,E,F,G,H,M,S,V, or W you need to immediatley send {ESC} so that it forces the menu to close. (For plain Alt+those keys, I have them all set here.)

!c:: ; <-- closing the Menu that gets opened when this key combo is sent
Send, !c{ESC}
return

;Alt+E can't be escaped immediatley becuase it closes the Export Media dialog.
;(This problem probably exists on some of the others too).
;!e:: ; <-- closing the Menu that gets opened when this key combo is sent
;Send, !e{ESC}
;return

!f:: ; <-- closing the Menu that gets opened when this key combo is sent
Send, !f{ESC}
return

!g:: ; <-- closing the Menu that gets opened when this key combo is sent
Send, !g{ESC}
return

!h:: ; <-- closing the Menu that gets opened when this key combo is sent
Send, !h{ESC}
return

!m:: ; <-- closing the Menu that gets opened when this key combo is sent
Send, !m{ESC}
return

!s:: ; <-- closing the Menu that gets opened when this key combo is sent
Send, !s{ESC}
return

!v:: ; <-- closing the Menu that gets opened when this key combo is sent
Send, !v{ESC}
return

!w:: ; <-- closing the Menu that gets opened when this key combo is sent
Send, !w{ESC}
return

; For some reason, Alt+Shift+S still opens the 'Sequence' menu. So this should stop that

+!s:: ; <-- closing the Menu that gets opened when this key combo is sent
Send, +!s{ESC}
return

; It doesn't do it for Alt+Shift+E though....

;===== SHIFT-CONTROL-ALT-FUNCTION KEY DEFINITIONS HERE =========================================

+^!F1:: ; <-- Push current timecode value to Word
  grabTCAsText(grabbedTC, xposP, yposP)
  Sleep, sleepShort
  WinActivate, ahk_exe WINWORD.EXE ;switch to Word
  Sleep, sleepShort
  Send, {Down}{Down} ;move cursor down two rows
  Sleep, sleepShort
  ;MSGBOX, , DEBUG, %grabbedTC%
  Send, %clipboard% ;paste the clipboard where the cursor is sitting
  Sleep, sleepShort
  WinActivate, ahk_exe Adobe Premiere Pro.exe ;switch back to PPRO
  Sleep, sleepShort
  prFocus("timeline") ; set timeline as the focused window in PPRO
Return

;+^!f2:: 
;+^!f3::
;+^!f4::
;+^!f5:: ; [USED by PPRO to Toggle Transmit(Video Playback)]
;+^!f6:: ; [USED by PPRO to Set Starting Timecode on Sequence]
;+^!f7::
;+^!f8::
;+^!f9:: 
;+^!f10::
;+^!f11::
;+^!f12::
;+^!f13::
;+^!f14::
;+^!f15::
;+^!f16::

#IfWinActive

;===== END Program 1 DEFINITIONS ===============================================================

/* COMMAND HOLDING TANK
(This comment block is a place where you can store previously used hotkeys that you may want to keep around in case you need to reuse them. Make sure to comment on what they did and/or were for.)

; <-- Go to next edit then add edit to active tracks
  Send, {down}
  Sleep, sleepShort
  Send, {F4}
return

; <-- open a clip marker, select all, copy text to clipboard, close clip marker, create seq marker, edit seq marker, paste text
  Sleep, sleepShort
  Send, m
  Sleep, sleepShort
  Send, ^a
  Sleep, sleepShort
  Send, ^c
  Sleep, sleepShort
  Send, {ESC}
  Sleep, sleepShort
  Send, ^+a
  Sleep, sleepShort
  Send, m
  Sleep, sleepLong
  Send, m
  Sleep, sleepShort
  Send, ^v
  Sleep, sleepShort
  Send, {Enter}
return

 ; <-- move ahead 1 sec, mark in, go to next xsit, back 1 frame, mark out, & extract
  Send, {NumpadAdd}
  Sleep, sleepShort
  Send, {Numpad1}
  Sleep, sleepShort
  Send, {NumpadDot}
  Sleep, sleepShort
  Send, {NumpadEnter}
  Sleep, sleepShort
  Send, {q}
  Sleep, sleepShort
  Send, {Down}
  Sleep, sleepShort
  Send, {LEFT}
  Sleep, sleepShort
  Send, {w}
  Sleep, sleepShort
  Send, {Shift Down}
  Sleep, sleepShort
  Send, X
  Sleep, sleepShort
  Send,{Shift Up}
return

 ; <--Removing a pattern from a string
  searchText := "LivingRoom"
  replaceText := "TreatmentRoom"
  Send, {Enter}
  Sleep, sleepShort
  Send, ^c
  ClipWait
  workingText = %clipboard%
  ;replaceText := ""
  editedText := RegExReplace(workingText, searchText, Replacement := replaceText)
  ;MsgBox, %workingText%n%searchText%n%replaceText%`n%editedText%
  Clipboard := editedText
  Sleep, sleepShort
  Send, ^v
  Sleep, sleepShort
  Send, {Enter}
  Sleep, sleepMedium
  Send, {Escape}
Return

F18:: ; <-- for PPRO - PHARMA Project - copy marker to comment when there is already stuff in the comment window
  CoordMode, Mouse, Client
  Send, 5
  Sleep, sleepShort
  Send, ^a
  Sleep, sleepShort
  Send, ^c
  Sleep, sleepShort
  Send, {Tab}
  Sleep, sleepShort
  Send, {ctrl Down}{home}{Ctrl Up}
  Sleep, sleepShort
  Send, ^v
  Sleep, sleepShort
  Send, {Shift Down}{Enter}{Shift Up}
  Sleep, sleepShort
  Click, 260, 53
  Sleep, sleepShort
  Send, 0
  Sleep, sleepShort
  Send, {NumpadEnter}
Return

F19:: ; <-- for PPRO - PHARMA Project - copy marker text to comment
  CoordMode, Mouse, Client
  Send, 5
  Sleep, sleepShort
  Send, ^a
  Sleep, sleepShort
  Send, ^c
  Sleep, sleepShort
  Send, {Tab}
  Sleep, sleepShort
  Send, ^v
  Sleep, sleepShort
  Send, {NumpadEnter}
  Sleep, sleepShort
  Send, {down}
return

F20:: ; <-- For PPRO - PHARMA Project - to ID client selected takes with a marker
  Send, 5
  Sleep, sleepShort
  Send, 5
  Sleep, sleepShort
  Send, client selected
  Send, {Tab}
  Sleep, sleepShort
  Send, client selected
  Sleep, sleepShort
  Send, {NumpadEnter}
return

*/

;===== FUNCTIONS ===============================================================================
