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
IniRead, programXposP, %inifile%, Settings, TCDisplayProgramXpos
IniRead, programYposP, %inifile%, Settings, TCDisplayProgramYpos
IniRead, sourceXposP, %inifile%, Settings, TCDisplaySourceXpos
IniRead, sourceYposP, %inifile%, Settings, TCDisplaySourceYpos

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
  getProgramTCDisplayCoords(programXposP, programYposP)
  Run, %Settings_rootFolder%\SCRIPTS-UTIL\pingPos.ahk %programXposP% %programYposP% "Screen"
  ;MSGBOX, , DEBUG, This is what came back from the function: X=%programXposP% / Y=%programYposP%
  Return

+!i:: ; <-- Get Current Timecode of Sequence
  CoordMode, Mouse, Screen
  grabProgramTCAsText(grabbedTC, programXposP, programYposP)
  ToolTip, Grabbed %grabbedTC% to Clipboard
  RemoveToolTip(2000)
  MSGBOX,,Timecode value read..., This is the value of grabbedTC: %grabbedTC% `nThis is the value stored on the clipboard: %clipboard%`n`nYou can send this to other apps by editing %A_ScriptName% and using the function 'grabProgramTCAsText' (see PREMIERE-PRO-FUNCTIONS.ahk for more info)., 2
  Return

^!i:: ; <-- Show coords that are stored
  CoordMode, Mouse, Screen
  MouseMove, programXposP, programYposP
  Tooltip, Mouse positioned at:`nprogramXposP:%programXposP%/programYposP:%programYposP%
  Run, %Settings_rootFolder%\SCRIPTS-UTIL\pingPos.ahk %programXposP% %programYposP% "Screen"
  RemoveToolTip(2500)
  Return

; these are usage examples for the functions to grab the timecode of the current Source Monitor clip.

^+!u:: ; <-- Find Coordinates of Source Clip's Timecode so 'Get Current Timecode of Source' below knows where to look.
  getSourceTCDisplayCoords(sourceXposP, sourceYposP)
  Run, %Settings_rootFolder%\SCRIPTS-UTIL\pingPos.ahk %sourceXposP% %sourceYposP% "Screen"
  ;MSGBOX, , DEBUG, This is what came back from the function: X=%sourceXposP% / Y=%sourceYposP%
  Return

+!u:: ; <-- Get Current Timecode of Source Clip
  CoordMode, Mouse, Screen
  grabSourceTCAsText(grabbedTC, sourceXposP, sourceYposP)
  ToolTip, Grabbed %grabbedTC% to Clipboard
  RemoveToolTip(2000)
  MSGBOX,,Timecode value read..., This is the value of grabbedTC: %grabbedTC% `nThis is the value stored on the clipboard: %clipboard%`n`nYou can send this to other apps by editing %A_ScriptName% and using the function 'grabSourceTCAsText' (see PREMIERE-PRO-FUNCTIONS.ahk for more info)., 2
  Return

^!u:: ; <-- Show coords that are stored for Source
  CoordMode, Mouse, Screen
  MouseMove, sourceXposP, sourceYposP
  Tooltip, Mouse positioned at:`nsourceXposP:%sourceXposP%/sourceYposP:%sourceYposP%
  Run, %Settings_rootFolder%\SCRIPTS-UTIL\pingPos.ahk %sourceXposP% %sourceYposP% "Screen"
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

+^!F1:: ;<-- match framing to a secondary Clip that has matching timecode
  message := "It appears you haven't used this command since you launched buttonpusherKB since you booted up today.`n`nThis hotkey will help you matchframe to a secondary source clip. It does this by matchframing a primary clip, copying that timecode to the clipboard, then loading a secondary source clip that has matching timecode, setting an in point to the same timecode, and then replacing the primary source clip with the secondary source clip.`n`nIn order to use this properly, follow these steps:`n`n1. Your secondary source clip (sequence or multicam clip,etc.) must have identical timecode to your original source clip. This will not work properly if you don't make the identical.`n`n2. Make sure the Secondary Source Clip is the only item in the Source Monitor listing. Right-click the source name and you can close any that shouldn't be there.`n`n3. This hotkey (currently) only works with one primary/secondary source clip at a time. As long as your primary source timecode exists within your secondary source clip, it should work.`n`n4. Make sure you have duped your sequence or duped the primary source layer to another layer - so you can compare the replaced clip with the original.`n`n5. You need to have ""Selection Follows Playhead"" turned on in the Sequence menu & make sure the clip you are replacing is selected in timeline before proceeding.`n`nPress Cancel below if things aren't setup properly.`n`nPress OK to continue with this hotkey (or if you're seeing this after fixing things to make it work.)"
  if (!f1MessageSeen)
  {
    FirstUsageSinceLaunch(message)
    IfMsgBox, Cancel
      Return
    f1MessageSeen := 1
  }
  prfocus("program") ;First we need to give the Record monitor focus
  Sleep, sleepShort
  Send, {F3} ; mark the selected clip
  Sleep, sleepShort
  Send, +i ; go to In Point
  Sleep, sleepShort
  Send, f ;then we perfom the standard matchframe to the source clips
  Sleep, sleepShort
  Send, {Tab} ;then we tab into the timecode field on the source monitor
  Sleep, sleepShort
  Send, ^c ; to copy the highlighted timecode to the clipboard
  ToolTip, Grabbed %clipboard% - now on Clipboard
  RemoveToolTip(1500)
  Sleep, sleepMedium
  Send, {Escape}
  Sleep, sleepShort
  prfocus("source") ;PPRO has an interesting behavior in that it will cycle through clips loaded in Source Monitor on successive presses of the "Source Monitor" hotkey. So, this should load in the 2nd clip - which should be the secondary source
    ; BlockInput, On
    Loop, 5
      {
      Send {Tab}
      }
    Sleep, sleepMedium
    Send, ^v ;then go to the matching timecode in the secondary source - pasting from clipboard
    Sleep, sleepMedium
    Send, {Enter}
    Sleep, sleepMedium
    Send, i ;then set an in point on the secondary source
    Sleep, sleepMedium
    prfocus("timeline") ;then switch back to timeline
    Sleep, sleepLong
    Send, +b ; edit on to timeline
    Sleep, sleepMedium
    prfocus("program") ; and then set focus back on Program Monitor
    ; BlockInput, Off
    SoundPlay, ..\SUPPORTING-FILES\SOUNDS\interfaceanditemsounds\V.3.0 Files\Special & Powerup (31).wav
    Sleep, sleepShort
    Send, ^s ; save project
Return

+^!F2:: ;<-- select all audio tracks & move down two tracks
  Send, +0 ;lock video
  Sleep, sleepShort
  Send, ^a ;select all - which will only get audio since video is locked
  Sleep, sleepShort
  Send, !{Down} ;opt-down to move down one track
  Sleep, sleepShort
  Send, !{Down} ;opt-down to move down one track
  Sleep, sleepShort
  Send, +0 ;unlock video
  Sleep, sleepShort
  Send, ^+a ;deselect all
  Sleep, sleepShort
  Send, {right} ; move to next edit
  Sleep, sleepShort
  Send, {left} ; then move back to previous edit
  Sleep, sleepShort
  Send, ^s ; save project
  SoundPlay, ..\SUPPORTING-FILES\SOUNDS\interfaceanditemsounds\V.3.0 Files\Futuristic Sounds (27).wav
  Return

+^!f3:: ; Increment a Sequence version number
; Press {Enter} to select the sequence name
Send, {Enter}
Sleep, sleepShort
; Copy Sequence name to clipboard
Send, ^c
Sleep, sleepShort
; Create temp var of Sequence name without final digits
; this will search from the end of the seq name, backwards
versionLoc := InStr(clipboard,"V", ,-1)
sequenceTemp := Substr(clipboard, 1, versionLoc)
; Extract the digits following the final 'V' from name
digitLoc := versionLoc
digitLoc++
versionCurr := Substr(clipboard, digitLoc)
; increment the final digit
versionCurr++
; Concatenante the Temp Sequence name var with the incremented digit
newSeqName := sequenceTemp . versionCurr
; Store new Sequence name to clipboard
clipboard := newSeqName
; Paste back into the Sequence name
Send, ^v
Sleep, sleepShort
; Press Enter to save the name
Send, {NumpadEnter}
Sleep, sleepShort
Send, ^s ; save project
SoundPlay, ..\SUPPORTING-FILES\SOUNDS\interfaceanditemsounds\V.3.0 Files\Quick Transition (4).wav

Sleep, sleepDeep
prfocus("project")
Return


+^!f4::  ; <- Changing Sequence Settings to 4k
  Send, ^k
  Sleep, sleepShort
  Send, {tab}{tab}{tab}{tab}
  Sleep, sleepShort
  Send, 3840{tab}
  Sleep, sleepShort
  Send, 2160
  Sleep, sleepShort
  Send, {tab}{tab}{tab}{tab}{tab}{tab}{tab}{tab}{tab}{tab}
  Sleep, sleepShort
  Send, {Down}{Down}
  Sleep, sleepShort
  Send, {tab}{tab}{tab}{tab}{tab}{tab}{space}
  Sleep, sleepShort
  Send, {enter}{enter}
  Sleep, sleepShort
  Send, +9 ; lock audio
  Send, ^a
  Sleep, sleepShort
  Send, ^!x
  Sleep, sleepShort
  Send, {enter}
  Sleep, sleepShort
  Send, +9 ; unlock audio
  ToolTip, What is currently selected?
  RemoveToolTip(4000)
  /*

  Send, {F21} ; select timeline panel

  Sleep, sleepShort

*/

  Send, ^s ; save project
  Sleep, sleepDeep
  Send, ^k ; reopen seq settings to double check
  SoundPlay, ..\SUPPORTING-FILES\SOUNDS\interfaceanditemsounds\V.3.0 Files\Futuristic Sounds (27).wav

Return

;+^!f5:: ; [USED by PPRO to Toggle Transmit(Video Playback)]
;+^!f6:: ; [USED by PPRO to Set Starting Timecode on Sequence]
;+^!f7::
;+^!f8::
;+^!f9:: 
;+^!f10::
;+^!f11::
;+^!f12::

+^!f13:: ;<-- update the date on the tail of a sequence
; prior to using this command, select the sequence you want to update
; the sequence SHOULD already have a date at its tail - formatted as YYYY-MMM-DD-HHSS
  Send, {Enter}
  Send, {End}
  Loop, 16 {
    Send, {BackSpace}
  }
  FormatTime, TimeString,, yyyy-MMM-dd-HHmm
  SendInput, %TimeString%
  Send, {Enter}
  Send, {Escape}
Return

;+^!f14::
;+^!f15::
;+^!f16::

+^!f17:: ;<-- get the name of a clip without the trailing extension
      prFocus("project")
  ; Press {Enter} to select the clip name
  Send, {Enter}
  Sleep, sleepShort
  ; Copy Sequence name to clipboard
  Send, ^c
  Sleep, sleepShort
  ; Create temp var of Sequence name without final digits
  endTrim := InStr(clipboard,".mp3") ; find the location of '.mp3' & set endTrim to the char num of the period
  endTrim-- ; remomving 1 extra character for the period
  sequenceTemp := Substr(clipboard, 1, endTrim) ; copy the left part of the name to new var
    clipboard := sequenceTemp ; Store new name to clipboard
    Sleep, sleepShort
    Send, {Escape}
    Sleep, sleepShort
    Send, O ; opens clip in source monitor & activates the transcript in the Text/Transcription Panel
  ;MSGBOX, , DEBUG, %sequenceTemp%
  Sleep, sleepShort
  SoundPlay, ..\SUPPORTING-FILES\SOUNDS\interfaceanditemsounds\V.3.0 Files\Futuristic Sounds (27).wav
  Return

+^!f18:: ;<-- Focus the Text Panel and Export the active transcript as CSV
      ;Click to focus the Text Panel - you cannot get the panel to have focus via a keyboard shortcut
      Click, 47, 135 ; this activates the Text/Transcript Window - provided it's already at least visible
      Send, ^!+c ; ;Send the Export to CSV keyboard shortcut - set it if it isn't already & make this line match your command in PPRO
      Sleep, sleepDeep
      Send, ^v
      Sleep, sleepLong
      Send, {Enter}
      Sleep, sleepShort
      prFocus("project")
      Sleep, sleepShort
      Send, {Down}
  Sleep, sleepShort
  SoundPlay, ..\SUPPORTING-FILES\SOUNDS\interfaceanditemsounds\V.3.0 Files\Futuristic Sounds (27).wav
  Return

#IfWinActive

;===== END Program 1 DEFINITIONS ===============================================================

/* COMMAND HOLDING TANK
(This comment block is a place where you can store previously used hotkeys that you may want to keep around in case you need to reuse them. Make sure to comment on what they did and/or were for.)

;<-- Get name of item above currently selected & copy to clipboard
      Send, {Enter}
      Send, +{Enter}
      Send, ^c
      Send, {Enter}
      Send, ^v
    Return

;<-- match framing to a secondary Clip that has matching timecode
; THIS VERSION DOES THIS BY CLICKING ON THE TIMECODE FIELDS WITHIN THE SOURCE MONITOR
  message := "It appears you haven't used this command since you launched buttonpusherKB since you booted up today.`n`nThis hotkey will help you matchframe to a secondary source clip. It does this by matchframing a primary clip, copying that timecode to the clipboard, then loading a secondary source clip that has matching timecode, setting an in point to the same timecode, and then replacing the primary source clip with the secondary source clip.`n`nIn order to use this properly, follow these steps:`n`n1. Your secondary source clip (sequence or multicam clip,etc.) must have identical timecode to your original source clip. This will not work properly if you don't make the identical.`n`n2. Make sure the Secondary Source Clip is the only item in the Source Monitor listing. Right-click the source name and you can close any that shouldn't be there.`n`n3. This hotkey (currently) only works with one primary/secondary source clip at a time. As long as your primary source timecode exists within your secondary source clip, it should work.`n`n4. Make sure you have duped your sequence or duped the primary source layer to another layer - so you can compare the replaced clip with the original.`n`n5. You need to have ""Selection Follows Playhead"" turned on in the Sequence menu & make sure the clip you are replacing is selected in timeline before proceeding.`n`nPress Cancel below if things aren't setup properly.`n`nPress OK to continue with this hotkey (or if you're seeing this after fixing things to make it work.)"
  if (!f1MessageSeen)
  {
    FirstUsageSinceLaunch(message)
    IfMsgBox, Cancel
      Return
    f1MessageSeen := 1
  }
  prfocus("program") ;First we need to give the Record monitor focus
  Sleep, sleepShort
  Send, {F3} ; mark the selected clip
  Sleep, sleepShort
  Send, +i ; go to In Point
  Sleep, sleepShort
  Send, f ;then we perfom the standard matchframe to the source clips
  Sleep, sleepShort
  ;then we grab the timecode from the source monitor
  CoordMode, Mouse, Screen
  grabSourceTCAsText(grabbedTC, sourceXposP, sourceYposP)
  ToolTip, Grabbed %grabbedTC% to Clipboard
  RemoveToolTip(1500)
  prfocus("source") ;PPRO has an interesting behavior in that it will cycle through clips loaded in Source Monitor on successive presses of the "Source Monitor" hotkey. So, this should load in the 2nd clip - which should be the secondary source
    BlockInput, On
    MouseMove, sourceXposP, sourceYposP
    Sleep, sleepLong
    Click, %sourceXposP%, %sourceYposP%, 0
    Sleep, sleepMedium
    Send, {Click}
    Sleep, sleepMedium
    Send, ^v ;then go to the matching timecode in the secondary source - pasting from clipboard
    Sleep, sleepMedium
    Send, {Enter}
    Sleep, sleepMedium
    Send, i ;then set an in point on the secondary source
    Sleep, sleepMedium
    prfocus("timeline") ;then switch back to timeline
    Sleep, sleepLong
    Send, +b ; edit on to timeline
    Sleep, sleepMedium
    prfocus("program") ; and then set focus back on Program Monitor
    BlockInput, Off
    SoundPlay, ..\SUPPORTING-FILES\SOUNDS\interfaceanditemsounds\V.3.0 Files\Special & Powerup (31).wav
    Sleep, sleepShort
    Send, ^s ; save project

Return


 ; Trim last 18 chars from clip name in project window
  ; Press {Enter} to select the sequence name
  Send, {Enter}
  Sleep, sleepShort
  ; Copy Sequence name to clipboard
  Send, ^c
  Sleep, sleepShort
  ; Create temp var of Sequence name without final digits
  versionCurr := "-V0" ; this is what we will tack on to the ending
  endTrim := InStr(clipboard,"(") ; find the location of the first parenthesis
  endTrim-- ; we need to trim off 2 characters
  endTrim-- ; so there's no space before the version
  sequenceTemp := Substr(clipboard, 1, endTrim) ; copy the left part of the name to new var
  newSeqName := sequenceTemp . versionCurr ; Concatenate the parts back together
  clipboard := newSeqName ; Store new Sequence name to clipboard
  ;MSGBOX, , DEBUG, %newSeqName%
  ; Paste back into the Sequence name
  Send, ^v
  Sleep, sleepShort
  ; Press Enter to save the name
  Send, {NumpadEnter}
  Sleep, sleepShort
  Send, ^s ; save project
  Sleep, sleepDeep
  prfocus("project")
  Sleep, sleepShort
  Send, ^!+o
  Sleep, sleepShort
  SoundPlay, ..\SUPPORTING-FILES\SOUNDS\interfaceanditemsounds\V.3.0 Files\Futuristic Sounds (27).wav
  Return



+^!F1:: ;<-- match framing to a secondary Clip that has matching timecode
  message := "It appears you haven't used this command since you launched buttonpusherKB since you booted up today.`n`nThis hotkey will help you matchframe to a secondary source clip. It does this by matchframing a primary clip, copying that timecode to the clipboard, then loading a secondary source clip that has matching timecode, setting an in point to the same timecode, and then replacing the primary source clip with the secondary source clip.`n`nIn order to use this properly, follow these steps:`n`n1. Your secondary source clip (sequence or multicam clip,etc.) must have identical timecode to your original source clip. This will not work properly if you don't make the identical.`n`n2. Make sure the Secondary Source Clip is the only item in the Source Monitor listing. Right-click the source name and you can close any that shouldn't be there.`n`n3. This hotkey (currently) only works with one primary/secondary source clip at a time. As long as your primary source timecode exists within your secondary source clip, it should work.`n`n4. Make sure you have duped your sequence or duped the primary source layer to another layer - so you can compare the replaced clip with the original.`n`n5. You need to have ""Selection Follows Playhead"" turned on in the Sequence menu & make sure the clip you are replacing is selected in timeline before proceeding.`n`nPress Cancel below if things aren't setup properly.`n`nPress OK to continue with this hotkey (or if you're seeing this after fixing things to make it work.)"
  if (!f1MessageSeen)
  {
    FirstUsageSinceLaunch(message)
    IfMsgBox, Cancel
      Return
    f1MessageSeen := 1
  }
  prfocus("program") ;First we need to give the Record monitor focus
  Send, f ;then we perfom the standard matchframe to the source clips
  Sleep, sleepShort
  ;then we grab the timecode from the source monitor
  CoordMode, Mouse, Screen
  grabSourceTCAsText(grabbedTC, sourceXposP, sourceYposP)
  ToolTip, Grabbed %grabbedTC% to Clipboard
  RemoveToolTip(1500)
  prfocus("source") ;PPRO has an interesting behavior in that it will cycle through clips loaded in Source Monitor on successive presses of the "Source Monitor" hotkey. So, this should load in the 2nd clip - which should be the secondary source
    BlockInput, On
    MouseMove, sourceXposP, sourceYposP
    Sleep, sleepLong
    Click, %sourceXposP%, %sourceYposP%, 0
    Sleep, sleepMedium
    Send, {Click}
    Sleep, sleepMedium
    Send, ^v ;then go to the matching timecode in the secondary source - pasting from clipboard
    Sleep, sleepMedium
    Send, {Enter}
    Sleep, sleepMedium
    Send, i ;then set an in point on the secondary source
    Sleep, sleepMedium
    prfocus("timeline") ;then switch back to timeline
    Sleep, sleepLong
    Send, ^!+2 ;and replace the clip contents from "Source Monitor, Match Frame"
    Sleep, sleepMedium
    prfocus("program") ; and then set focus back on Program Monitor
    BlockInput, Off

Return

; <-- Push current timecode value to Word
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

 ;<-- Select text from cursor location to beginning of line, delete, & paste from clipboard
  Send, {Shift Down}{Home}{Shift Up}
  Sleep, sleepShort
  Send, {Delete}
  Sleep, sleepShort
  Send, ^v
  Sleep, sleepShort
  Send, {Enter}
  Return

 ;<-- Grabbing a single frame to export & add TC into the name
  Send, !{F3} ; clear in & out marks
  ; mark in & out on single frame
  Send, i 
  Sleep, sleepShort
  Send, o
  Sleep, sleepShort
  ; grab current playhead TC
  CoordMode, Mouse, Screen
  grabTCAsText(grabbedTC, xposP, yposP)
  ToolTip, Grabbed %grabbedTC% to Clipboard
  RemoveToolTip(2000)
  ; open export dialog
  Send, !e
  Sleep, sleepShort
  ; add TC to export filename
  Click, 1814, 465
  Sleep, sleepShort
  Send, {Right}
  Sleep, sleepShort
  Send, {Left}{Left}{Left}{Left}
  Sleep, sleepShort
  Send, -
  Sleep, sleepShort
  Send, %clipboard%
  Sleep, sleepShort
  Send, {Enter}
  Sleep, sleepLong
  ; set export to 'Seq In/Out'
  Click, 985, 1221
  Sleep, sleepShort
  Click, 985, 1260
  Sleep, sleepShort
  ; export the frame
  Click, 1870, 1210
  ; activate FreeCommander
  WinActivate, ahk_exe FreeCommander.exe
Return

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

+^!f18::  ; Trim last 9 chars from clip name in project window
  ; Press {Enter} to select the sequence name
  Send, {Enter}
  Sleep, sleepShort
  ; Copy Sequence name to clipboard
  Send, ^c
  Sleep, sleepShort
  ; Create temp var of Sequence name without final digits
  versionCurr := "-VERTICAL-V1" ; this is what we will tack on to the ending
  endTrim := InStr(clipboard,"Copy") ; find the location of '-V0''
  endTrim-- ; we need to trim off 4 characters
  endTrim--
  endTrim--
  endTrim--
  endTrim--
  sequenceTemp := Substr(clipboard, 1, endTrim) ; copy the left part of the name to new var
  newSeqName := sequenceTemp . versionCurr ; Concatenate the parts back together
  clipboard := newSeqName ; Store new Sequence name to clipboard
  ;MSGBOX, , DEBUG, %newSeqName%
  ; Paste back into the Sequence name
  Send, ^v
  Sleep, sleepShort
  ; Press Enter to save the name
  Send, {NumpadEnter}
  Sleep, sleepShort
  Send, ^s ; save project
  Sleep, sleepDeep
  prfocus("project")
  Sleep, sleepShort
  ;Send, ^!+o ; opens the selected sequence in the Program Monitor
  Sleep, sleepShort
  SoundPlay, ..\SUPPORTING-FILES\SOUNDS\interfaceanditemsounds\V.3.0 Files\Futuristic Sounds (27).wav
  Return

*/

;===== FUNCTIONS ===============================================================================
