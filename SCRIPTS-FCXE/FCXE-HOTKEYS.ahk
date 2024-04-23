; AutoHotKey - FREECOMMANDER-HOTKEYS.ahk
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

#IfWinActive, ahk_exe FreeCommander.exe

F13:: ;<-- Create new Folder using first WORD of selected file
Send, !+c
Sleep, sleepShort
    clipboard := Clipboard ; Get the current clipboard content
    words := StrSplit(clipboard, " ") ; Split the clipboard content into an array of words
    if (words.MaxIndex() >= 1) { ; Extract the first word
        firstWord := words[1]
    } else {
        firstWord := clipboard
    }
    Clipboard := firstWord ; Assign the first two words back to the clipboard
; MsgBox, Extracted: %firstWord%
Send, {F7}
Sleep, sleepShort
Send, ^v
Sleep, sleepShort
Send, {Enter}
Sleep, sleepShort
Send, ^r
return

F14:: ;<-- Create new Folder using first TWO words of selected file
Send, !+c
Sleep, sleepShort
    clipboard := Clipboard ; Get the current clipboard content
    words := StrSplit(clipboard, " ") ; Split the clipboard content into an array of words
    if (words.MaxIndex() >= 2) { ; Extract the first two words
        firstTwoWords := words[1] " " words[2]
    } else {
        firstTwoWords := clipboard
    }
    Clipboard := firstTwoWords ; Assign the first two words back to the clipboard
; MsgBox, Extracted: %firstTwoWords%
Send, {F7}
Sleep, sleepShort
Send, ^v
Sleep, sleepShort
Send, {Enter}
Sleep, sleepShort
WinWaitActive, ahk_exe FreeCommander.exe
Send, ^r
return

F15:: ;<-- Create new Folder using first THREE words of selected file
Send, !+c
Sleep, sleepShort
    clipboard := Clipboard ; Get the current clipboard content
    words := StrSplit(clipboard, " ") ; Split the clipboard content into an array of words
    if (words.MaxIndex() >= 3) { ; Extract the first three words
        firstThreeWords := words[1] " " words[2] " " words[3]
    } else {
        firstThreeWords := clipboard
    }
    Clipboard := firstThreeWords ; Assign the first two words back to the clipboard
; MsgBox, Extracted: %firstThreeWords%
Send, {F7}
Sleep, sleepShort
Send, ^v
Sleep, sleepShort
Send, {Enter}
Sleep, sleepShort
WinWaitActive, ahk_exe FreeCommander.exe
Send, ^r
return

F16:: ;<-- Create new Folder using first FOUR words of selected file
Send, !+c
Sleep, sleepShort
    clipboard := Clipboard ; Get the current clipboard content
    words := StrSplit(clipboard, " ") ; Split the clipboard content into an array of words
    if (words.MaxIndex() >= 4) { ; Extract the first four words
        firstFourWords := words[1] " " words[2] " " words[3] " " words[4]
    } else {
        firstFourWords := clipboard
    }
    Clipboard := firstFourWords ; Assign the first two words back to the clipboard
; MsgBox, Extracted: %firstFourWords%
Send, {F7}
Sleep, sleepShort
Send, ^v
Sleep, sleepShort
Send, {Enter}
Sleep, sleepShort
WinWaitActive, ahk_exe FreeCommander.exe
Send, ^r
return

F17:: ;<-- Append "(Gridded)" to selected file/folder
Send, {F2}
Sleep, sleepShort
Send, {End}
Sleep, sleepShort
Send, {Space}(Gridded){Enter}
return

F18:: ;<-- Append "(Gridless)" to selected file/folder
Send, {F2}
Sleep, sleepShort
Send, {End}
Sleep, sleepShort
Send, {Space}(Gridless){Enter}
return


F24:: ;<-- Rename to StreamDeckXL
Send, {F2}
Sleep, sleepShort
Send, StreamDeckXL{Enter}
Sleep, sleepShort
Send, {F2}
Sleep, sleepShort
Send, {Home}
Return

#IfWinActive
;===== FUNCTIONS ===============================================================================

/*
HOLDING TANK for inactive hotkeys

F13:: ; NO IDEA WHAT THIS WAS FOR - something about making a new folder from clipboard text
Send, {ShiftDown}}{AltDown}c{ShiftUp}{AltUp}
Sleep, sleepMedium
Send, {Tab}
Sleep, sleepMedium
Send, {F7}
Sleep, sleepMedium
Send, {CtrlDown}v{CtrlUp}
Sleep, sleepMedium
Send, {Enter}
Return

*/