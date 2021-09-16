; AutoHotKey - NOTEPAD++-HOTKEYS.ahk
; by Ben Howard - ben@buttonpusher.tv

;===== START OF AUTO-EXECUTION SECTION =========================================================
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; #Persistent ; Keeps script permanently running.
#SingleInstance force ; Ensures that there is only a single instance of this script running.
; SetTitleMatchMode, 2 ; sets title matching to search for "containing" instead of "exact"

Menu, Tray, NoIcon ; removes the tray icon
;===== INITIALIZATION - VARIABLES ==============================================================
; Sleep shortcuts - use these to standardize sleep times
sleepMicro := 5
sleepMini := 15
sleepShort := 333
sleepMedium := 666
sleepLong := 1500
sleepDeep := 3500

;===== END OF AUTO-EXECUTE =====================================================================
;===== MODIFIER MEMORY HELPER ==================================================================
; combine below with key and '::' to define hotkey 
; e.g.- ^f1::Msgbox You pressed Control and F1
; #=Win | !=Alt | ^=Ctrl | +=Shift | &=combine keys | *=ignore other mods
; <=use left mod key| >=use right mod key  | UP=fires on release

;===== MAIN HOTKEY DEFINITIONS HERE ============================================================

#IfWinActive, ahk_exe notepad++.exe

+^!f13:: ; <-- HTML: wrap selected text in <strong>..</strong> tag
    WinActivate, ahk_exe notepad++.exe
    Send, ^c
    ClipWait
    wrappedText := "<strong>" . Clipboard . "</strong>"
    WinActivate, ahk_exe notepad++.exe
    SendInput, %wrappedText%
    Clipboard = ; clears Clipboard
Return

+^!f14:: ; <-- DOKUWIKI: underline selected
    WinActivate, ahk_exe notepad++.exe
    Send, ^c
    ClipWait
    wrappedText := "__" . Clipboard . "__"
    WinActivate, ahk_exe notepad++.exe
    SendInput, %wrappedText%
    Clipboard = ; clears Clipboard
Return

+^!f15:: ; <--DOKUWIKI: italicize selected text
    WinActivate, ahk_exe notepad++.exe
    Send, ^c
    ClipWait
    wrappedText := "//" . Clipboard . "//"
    WinActivate, ahk_exe notepad++.exe
    SendInput, %wrappedText%
    Clipboard = ; clears Clipboard
Return

+^!f16:: ; <--DOKUWIKI: bold selected text
    WinActivate, ahk_exe notepad++.exe
    Send, ^c
    ClipWait
    wrappedText := "**" . Clipboard . "**"
    WinActivate, ahk_exe notepad++.exe
    SendInput, %wrappedText%
    Clipboard = ; clears Clipboard
Return

F13:: ; <--HTML: open DIV tag for FVTT-FATE development
    Send, <div class="arecibo">{Enter}
    Sleep, sleepMedium
    Send, {Control Down}{End}{Control Up}
    Sleep, sleepMedium
    Send, {Enter}</div>
    Return

F14:: ; <--HTML: close DIV tag for FVTT-FATE development
    Send, </div>
    Return

F17:: ; <--DOKUWIKI: make selection an Internal Link
    WinActivate, ahk_exe notepad++.exe
    Send, ^c
    ClipWait
    wrappedText := "[[" . Clipboard . "]]"
    WinActivate, ahk_exe notepad++.exe
    SendInput, %wrappedText%
    Clipboard = ; clears Clipboard
    Return

F19:: ; <--DOKUWIKI: set headline to Top Level
    Send, ^x
    Send, ======{Space}
    Send, %Clipboard%
    Send, {Space}======
    Return

F20:: ; <--DOKUWIKI: set headline to 2nd Level
    Send, ^x
    Send, ====={Space}
    Send, %Clipboard%
    Send, {Space}=====
    Return

F21:: ; <--DOKUWIKI: set headline to 3rd Level
    Send, ^x
    Send, ===={Space}
    Send, %Clipboard%
    Send, {Space}====
    Return

F22:: ; <--DOKUWIKI: set headline to 4th Level
    Send, ^x
    Send, ==={Space}
    Send, %Clipboard%
    Send, {Space}===
    Return

F23:: ; <--DOKUWIKI: set headline to 5th Level
    Send, ^x
    Send, =={Space}
    Send, %Clipboard%
    Send, {Space}==
    Return

^F24:: ; <-- Reload NOTEPAD++-HOTKEYS.ahk
    MSGBOX, , DEBUG,Reloading Notepad++-Hotkeys
    Reload
    Return

#IfWinActive

;===== HOLDING TANK FOR DEACTIVATED HOTKEYS ====================================================
/* Just a place to store Hotkeys that I don't need but want to keep around...just in case.

	+^!F21:: ; <-- copy current line for robocopy - DC Comics project
		Send, {Home}
		Sleep, %sleepShort%
		Send, {LShift Down}{End}{LShift Up}
		Sleep, %sleepShort%
		Send, {Control Down}c{Control Up}
		Sleep, %sleepShort%
		Send, {Home}
		Sleep, %sleepShort%
		Send, --
		Sleep, %sleepShort%
		Send, {Down}
		Sleep, %sleepShort%
		Send, {Control Down}s{Control Up}
		WinActivate, ahk_exe WindowsTerminal.exe
		Send, {Control Down}{LShift Down}v{Control Up}{LShift Up}
		Sleep, %sleepShort%
		Send, {Enter}
		Sleep, %sleepShort%
		WinActivate, ahk_exe notepad++.exe
	Return

*/


;===== FUNCTIONS ===============================================================================

