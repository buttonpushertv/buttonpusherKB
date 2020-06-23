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

Menu, Tray, Icon, shell32.dll, 116 ; this changes the tray icon to a filmstrip!
;===== INITIALIZATION - VARIABLES ==============================================================
; Sleep shortcuts - use these to standardize sleep times. Change here to change everywhere.
sleepMicro := 15
sleepShort := 333
sleepMedium := 666
sleepLong := 1500
sleepDeep := 3500

#Include %A_ScriptDir%\PREMIERE-PRO-FUNCTIONS.ahk

;===== END OF AUTO-EXECUTE =====================================================================

;===== MODIFIER MEMORY HELPER ==================================================================
; combine below with key and '::' to define hotkey
; e.g.- ^f1::Msgbox You pressed Control and F1
; #=Win | !=Alt | ^=Ctrl | +=Shift | &=combine keys | *=ignore other mods
; <=use left mod key| >=use right mod key  | UP=fires on release

;===== MAIN HOTKEY DEFINITIONS HERE ============================================================

;===== PREMIERE PRO HOTKEY DEFINITIONS HERE ============================================

#IfWinActive, ahk_exe Adobe Premiere Pro.exe

#F1::prFocus("timeline") ; <-- Focus the Timeline Window

^1:: ; <-- Step Left 1 second
Send, ^+a
sleep, sleepShort
Send, {NumpadSub}
sleep, sleepMicro
Send, {Numpad1}
sleep, sleepMicro
Send, {NumpadDot}
sleep, sleepMicro
Send, {NumpadEnter}{NumpadEnter}
return

^2:: ; <-- Step Left 5 seconds THEN Play
Send, {2}
sleep, sleepShort
Send, ^+a
sleep, sleepShort
Send, {NumpadSub}
sleep, sleepMicro
Send, {Numpad5}
sleep, sleepMicro
Send, {NumpadDot}
sleep, sleepMicro
Send, {NumpadEnter}{NumpadEnter}
sleep, sleepMicro
Send, 3
return

^3:: ; <-- Step Right 1 second
Send, ^+a
sleep, sleepShort
Send, {NumpadAdd}
sleep, sleepMicro
Send, {Numpad1}
sleep, sleepMicro
Send, {NumpadDot}
sleep, sleepMicro
Send, {NumpadEnter}{NumpadEnter}
return

^+2:: ; <-- Step Left 10 seconds THEN Play
Send, {2}
sleep, sleepShort
Send, ^+a
sleep, sleepShort
Send, {NumpadSub}
sleep, sleepMicro
Send, {Numpad1}
sleep, sleepMicro
Send, {Numpad0}
sleep, sleepMicro
Send, {NumpadDot}
sleep, sleepMicro
Send, {NumpadEnter}{NumpadEnter}
sleep, sleepMicro
Send, 3
return

^!F4:: ; <-- Add edit, mark previous clip and delete
sleep, sleepShort
Send, {F4}
sleep, sleepShort
Send, {Up}
sleep, sleepShort
Send, {Control Down}{F3}{Control Up}
sleep, sleepShort
Send, {Shift Down}x{Shift Up}
Return

; The section below addresses the issue of the Alt key opening the menu bar items. Even though there is a block in MASTER-SCRIPT that prevents the Left Alt key from opening menu items, if you press the Alt plus another key, it will still open the menu. The block just prevents the Left Alt from setting the focus on the menu bar until you hit Escape. If you want to use Alt with C,E,F,G,H,M,S,V, or W you need to immediatley send {ESC} so that it forces the menu to close. (For plain Alt+those keys, I have them all set here.)

!c:: ; <-- closing the Menu that gets opened when this key combo is sent
Send, !c{ESC}
return

;Alt+E can't be escaped immediatley becuase it closes the Export Media dialog.
;(This problem probably exists on som eof the others too).
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

!z:: ; <-- Select clip @ playhead & delete it
Send, d ; PPro Key for 'select clip at playhead'
Send, {DEL} ; PPro Key for 'remove'
return

^+!i:: ; <-- Find Coordinates of Sequence Timecode so 'Get Current Timecode of Sequence' below knows where to look.
  CoordMode, Mouse, Window
  MouseGetPos, xposP, yposP ;---storing cursor's current coordinates at X%xposP% Y%yposP%
  Tooltip, X=%xposP% / Y=%yposP%`nGrabbing the X & Y coordinates of the mouse cursor`nMake sure it is over the Program Monitor's timecode display (lower left).
  RemoveToolTip(3000)
  Return

+!i:: ; <-- Get Current Timecode of Sequence
  If (!xposP and !yposP)
    {
      MsgBox,, Grab Timecode Display position, You need to grab the X & Y coordinates of the Program Monitor's Timecode Display (lower left).`nPosition cursor then press CTRL-SHIFT-ALT-I to capture,3
      Return
    }
  prFocus(program) ; Activating the Program Monitor
  Sleep, sleepShort
  CoordMode, Mouse, Window
  MouseGetPos, xposTEMP, yposTEMP ;---storing cursor's current coordinates at X%xposTEMP% Y%yposTEMP%
  Tooltip, X=%xposP% / Y=%yposP%`nIf this misclicks`, position cursor then press CTRL-SHIFT-ALT-I to capture coordinates.
  RemoveToolTip(3000) 
  ;BlockInput, On
  MouseMove, xposP, yposP
  Click, xposP, yposP, 0
  Sleep, sleepShort
  Send, {Click}
  Sleep, sleepShort
  Send, {Control Down}
  Sleep, sleepShort
  Send, C
  Sleep, sleepShort
  Send, {Control Up}
  Sleep, sleepShort
  Send, {Esc}
  ;BlockInput, Off
  MouseMove, xposTEMP, yposTEMP
  return

;===== SHIFT-CONTROL-ALT-FUNCTION KEY DEFINITIONS HERE =========================================

#^!F1:: ; <-- move ahead 1 sec, mark in, go to next xsit, back 1 frame, mark out, & extract
Send, {NumpadAdd}
sleep, sleepShort
Send, {Numpad1}
sleep, sleepShort
Send, {NumpadDot}
sleep, sleepShort
Send, {NumpadEnter}
sleep, sleepShort
Send, {q}
sleep, sleepShort
Send, {Down}
sleep, sleepShort
Send, {LEFT}
sleep, sleepShort
Send, {w}
sleep, sleepShort
Send, {Shift Down}
sleep, sleepShort
Send, X
sleep, sleepShort
Send,{Shift Up}
return

+^!f2:: ; <-- open a clip marker, select all, copy text to clipboard, close clip marker, create seq marker, edit seq marker, paste text
sleep, sleepShort
Send, m
sleep, sleepShort
Send, ^a
sleep, sleepShort
Send, ^c
sleep, sleepShort
Send, {ESC}
sleep, sleepShort
Send, ^+a
sleep, sleepShort
Send, m
sleep, sleepLong
Send, m
sleep, sleepShort
Send, ^v
sleep, sleepShort
Send, {Enter}
return

+^!f3:: ; <-- Step Left 2 seconds
sleep, sleepMicro
Send, ^+a
sleep, sleepShort
Send, {NumpadSub}
sleep, sleepMicro
Send, {Numpad2}
sleep, sleepMicro
Send, {NumpadDot}
sleep, sleepMicro
Send, {NumpadEnter}{NumpadEnter}
return

+^!f4:: ; <-- Step Right 2 Seconds
sleep, sleepMicro
Send, ^+a
sleep, sleepShort
Send, {NumpadAdd}
sleep, sleepMicro
Send, {Numpad2}
sleep, sleepMicro
Send, {NumpadDot}
sleep, sleepMicro
Send, {NumpadEnter}{NumpadEnter}
return

;+^!f5::
;+^!f6::

+^!f7:: ; <-- Step Left 5 seconds
sleep, sleepMicro
Send, ^+a
sleep, sleepShort
Send, {NumpadSub}
sleep, sleepMicro
Send, {Numpad5}
sleep, sleepMicro
Send, {NumpadDot}
sleep, sleepMicro
Send, {NumpadEnter}{NumpadEnter}
return


+^!f8:: ; <-- Step Right 5 Seconds
sleep, sleepMicro
Send, ^+a
sleep, sleepShort
Send, {NumpadAdd}
sleep, sleepMicro
Send, {Numpad5}
sleep, sleepMicro
Send, {NumpadDot}
sleep, sleepMicro
Send, {NumpadEnter}{NumpadEnter}
return

+^!f9:: ; <-- Go to next edit then add edit to active tracks
Send, {down}
Sleep, sleepShort
Send, {F4}
return

;+^!f10::
;+^!f11::
;+^!f12::
;+^!f13::
;+^!f14::
;+^!f15::
;+^!f16::

#IfWinActive

;===== END Program 1 DEFINITIONS ===============================================================

;===== FUNCTIONS ===============================================================================

RemoveSplashScreen:
    SplashTextOff
    SetTimer RemoveSplashScreen, Off
    return

; use this function to Remove ToolTips - pretty self-explanatory - 'duration' should be given in milliseconds (4000 = 4 seconds)
RemoveToolTip(duration) {
  SetTimer, ToolTipOff, %duration%
  Return

ToolTipOff:
    ToolTip
    return
}
