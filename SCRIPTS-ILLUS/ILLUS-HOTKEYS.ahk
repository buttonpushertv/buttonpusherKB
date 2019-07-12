; AutoHotKey - Buttonpusher Post-Production Keyboard Environment - Illustrator HotKeys
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

; The 2 lines below pertain to the 'reload on save' function below (CheckScriptUpdate). 
; They are required for it to work.
FileGetTime ScriptStartModTime, %A_ScriptFullPath%
SetTimer CheckScriptUpdate, 100, 0x7FFFFFFF ; 100 ms, highest priority

Menu, Tray, Icon, imageres.dll, 251 ; this changes the tray icon to a filmstrip!
;===== INITIALIZATION - VARIABLES ==============================================================
; Sleep shortcuts - use these to standardize sleep times. Change here to change everywhere.
sleepMicro := 15
sleepShort := 333
sleepMedium := 666
sleepLong := 1500
sleepDeep := 3500

splashScreenX = %1%
splashScreenY = %2%
splashScreenTimeout = %3%

;===== SPLASH SCREEN TO ANNOUNCE WHAT SCRIPT DOES ==============================================
SplashTextOn, 600, 100, Launching %A_ScriptFullPath%, Loading ILLUSTRATOR HOTKEYS Script.`n`nWin-[ to show CheatSheet of Keyboard Layout.
WinMove, Launching %A_ScriptFullPath%, , %splashScreenX%, %splashScreenY%
SetTimer, RemoveSplashScreen, %splashScreenTimeout%
;===== END OF AUTO-EXECUTE =====================================================================

;===== MODIFIER MEMORY HELPER ==================================================================
; combine below with key and '::' to define hotkey 
; e.g.- ^f1::Msgbox You pressed Control and F1
; #=Win | !=Alt | ^=Ctrl | +=Shift | &=combine keys | *=ignore other mods
; <=use left mod key| >=use right mod key  | UP=fires on release

;===== MAIN HOTKEY DEFINITIONS HERE ============================================================

;===== ILLUSTRATOR HOTKEY DEFINITIONS HERE ============================================

#IfWinActive, ahk_exe Illustrator.exe

;===== SHIFT-CONTROL-ALT-FUNCTION KEY DEFINITIONS HERE =========================================
; Quick template for the 16 Function keys to use as SCAF Keys.

; What are SCAF Keys? It's my method of creating a standardized set of macro keys. I have several
; keyboards/macropads with the keys programmed in (via QMK or device driver/config apps) so that
; I have easy access to a set of keys that are not likely to be used by other apps. Use them for
; any kind of repetitive task or other function that may not have an existing (or inconvinient)
; keystroke combo to execute.

;+^!f1:: ; <-- Resetting a Keyboard Template Key to Default Values & all labels set to opacity 10%
    
    /* 
    global Choice
    global xposP
    global yposP
    
    Choice1 := "none"
    
    ;Setting the coordinate mode is really important. This ensures that pixel distances are consistant for everything, everywhere.
    coordmode, pixel, Window
    coordmode, mouse, Window
    SetKeyDelay, 1
    
    MouseGetPos, xposP, yposP
    
    MsgBox, Mouse: %xposP%, %yposP%
    
    Gui, Add, DropDownList, vChoice, PLAIN||CONTROL|ALT|SHIFT|CTRL+ALT|CTRL+SHIFT|ALT+SHIFT|CTRL+ALT+SHIFT
    Gui, Add, Button,, Cancel 
    Gui, Add, Button, Default, Submit
    Gui, show
    Return

    GuiClose:
    ButtonCancel:
    Gui, destroy
    return
    
    ButtonSubmit:
    MsgBox, Choice %Choice%
    WinActivate, ahk_exe Illustrator.exe
    Chooser(Choice)
    Gui, destroy
    return
    */
    
+^!f2:: ; <-- Resetting a PLAIN Keyboard Template Key to PLAIN & set to opacity 10%
    ;ITEM LOOP STARTS HERE
    Sleep, sleepMedium
    Click
    Sleep, sleepMedium
    Click,2
    Sleep, sleepMedium
    Send, {Control Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepMedium
    Send, PLAIN
    Sleep, sleepMedium
    Send, {ESC}
    Sleep, sleepMedium
    Send, {Shift Down}
    Sleep, sleepShort
    Send, 1
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Down}
    Sleep, sleepShort
    Send, {Shift Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepShort
    ;ITEM LOOP ENDS HERE
    SoundBeep
    return
+^!f3::  ; <-- Resetting a CONTROL Keyboard Template Key to CONTROL & set to opacity 10%
    ;ITEM LOOP STARTS HERE
    Sleep, sleepShort
    Click
    Sleep, sleepMedium
    Click,2
    Sleep, sleepMedium
    Send, {Control Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepMedium
    Send, CONTROL
    Sleep, sleepMedium
    Send, {ESC}
    Sleep, sleepMedium
    Send, {Shift Down}
    Sleep, sleepShort
    Send, 1
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Down}
    Sleep, sleepShort
    Send, {Shift Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepShort
    ;ITEM LOOP ENDS HERE
    SoundBeep
    return
+^!f4:: ; <-- Resetting a ALT Keyboard Template Key to ALT & set to opacity 10%
    ;ITEM LOOP STARTS HERE
    Sleep, sleepShort
    Click
    Sleep, sleepMedium
    Click,2
    Sleep, sleepMedium
    Send, {Control Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepMedium
    Send, ALT
    Sleep, sleepMedium
    Send, {ESC}
    Sleep, sleepMedium
    Send, {Shift Down}
    Sleep, sleepShort
    Send, 1
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Down}
    Sleep, sleepShort
    Send, {Shift Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepShort
    ;ITEM LOOP ENDS HERE
    SoundBeep
    return
+^!f5:: ; <-- Resetting a SHIFT Keyboard Template Key to SHIFT & set to opacity 10%
    ;ITEM LOOP STARTS HERE
    Sleep, sleepShort
    Click
    Sleep, sleepMedium
    Click,2
    Sleep, sleepMedium
    Send, {Control Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepMedium
    Send, SHIFT
    Sleep, sleepMedium
    Send, {ESC}
    Sleep, sleepMedium
    Send, {Shift Down}
    Sleep, sleepShort
    Send, 1
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Down}
    Sleep, sleepShort
    Send, {Shift Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepShort
    ;ITEM LOOP ENDS HERE
    SoundBeep
    return
+^!f6:: ; <-- Resetting a CTRL+ALT Keyboard Template Key to CTRL+ALT & set to opacity 10%
    ;ITEM LOOP STARTS HERE
    Sleep, sleepShort
    Click
    Sleep, sleepMedium
    Click,2
    Sleep, sleepMedium
    Send, {Control Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepMedium
    Send, CTRL{+}ALT
    Sleep, sleepMedium
    Send, {ESC}
    Sleep, sleepMedium
    Send, {Shift Down}
    Sleep, sleepShort
    Send, 1
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Down}
    Sleep, sleepShort
    Send, {Shift Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepShort
    ;ITEM LOOP ENDS HERE
    SoundBeep
    return
+^!f7::  ; <-- Resetting a CTRL+SHIFT Keyboard Template Key to CTRL+SHIFT & set to opacity 10%
    ;ITEM LOOP STARTS HERE
    Sleep, sleepShort
    Click
    Sleep, sleepMedium
    Click,2
    Sleep, sleepMedium
    Send, {Control Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepMedium
    Send, CTRL{+}SHIFT 
    Sleep, sleepMedium
    Send, {ESC}
    Sleep, sleepMedium
    Send, {Shift Down}
    Sleep, sleepShort
    Send, 1
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Down}
    Sleep, sleepShort
    Send, {Shift Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepShort
    ;ITEM LOOP ENDS HERE
    SoundBeep
    return
+^!f8::  ; <-- Resetting a ALT+SHIFT Keyboard Template Key to ALT+SHIFT & set to opacity 10%
    ;ITEM LOOP STARTS HERE
    Sleep, sleepShort
    Click
    Sleep, sleepMedium
    Click,2
    Sleep, sleepMedium
    Send, {Control Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepMedium
    Send, ALT{+}SHIFT 
    Sleep, sleepMedium
    Send, {ESC}
    Sleep, sleepMedium
    Send, {Shift Down}
    Sleep, sleepShort
    Send, 1
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Down}
    Sleep, sleepShort
    Send, {Shift Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepShort
    ;ITEM LOOP ENDS HERE
    SoundBeep
    return
+^!f9::   ; <-- Resetting a CTRL+ALT+SHIFT Keyboard Template Key to CTRL+ALT+SHIFT & set to opacity 10%
    ;ITEM LOOP STARTS HERE
    Sleep, sleepShort
    Click
    Sleep, sleepMedium
    Click,2
    Sleep, sleepMedium
    Send, {Control Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepMedium
    Send, CTRL{+}ALT{+}SHIFT
    Sleep, sleepMedium
    Send, {ESC}
    Sleep, sleepMedium
    Send, {Shift Down}
    Sleep, sleepShort
    Send, 1
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Down}
    Sleep, sleepShort
    Send, {Shift Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepShort
    ;ITEM LOOP ENDS HERE
    SoundBeep
    return
;+^!f10:: ; <-- Resetting a Keyboard Template Key to Default Values & all labels set to opacity 10%
    ;Setting the coordinate mode is really important. This ensures that pixel distances are consistant for everything, everywhere.
    coordmode, pixel, Window
    coordmode, mouse, Window
    coordmode, Caret, Window
    SetKeyDelay, 1 
    ;ITEM LOOP STARTS HERE
    Sleep, sleepShort
    Click
    Sleep, sleepMedium
    Click,2
    Sleep, sleepMedium
    Send, {Control Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepMedium
    Send, PLAIN
    Sleep, sleepMedium
    Send, {ESC}
    Sleep, sleepMedium
    Send, {Shift Down}
    Sleep, sleepShort
    Send, 1
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Down}
    Sleep, sleepShort
    Send, {Shift Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepShort
    MouseMove, 0,+23, 0, R ; <-- moves cursor down to next line
    ;ITEM LOOP ENDS HERE
    ;ITEM LOOP STARTS HERE
    Sleep, sleepShort
    Click
    Sleep, sleepMedium
    Click,2
    Sleep, sleepMedium
    Send, {Control Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepMedium
    Send, CONTROL
    Sleep, sleepMedium
    Send, {ESC}
    Sleep, sleepMedium
    Send, {Shift Down}
    Sleep, sleepShort
    Send, 1
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Down}
    Sleep, sleepShort
    Send, {Shift Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepShort
    MouseMove, 0,+23, 0, R ; <-- moves cursor down to next line
    ;ITEM LOOP ENDS HERE
    ;ITEM LOOP STARTS HERE
    Sleep, sleepShort
    Click
    Sleep, sleepMedium
    Click,2
    Sleep, sleepMedium
    Send, {Control Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepMedium
    Send, ALT
    Sleep, sleepMedium
    Send, {ESC}
    Sleep, sleepMedium
    Send, {Shift Down}
    Sleep, sleepShort
    Send, 1
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Down}
    Sleep, sleepShort
    Send, {Shift Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepShort
    MouseMove, 0,+23, 0, R ; <-- moves cursor down to next line
    ;ITEM LOOP ENDS HERE
    ;ITEM LOOP STARTS HERE
    Sleep, sleepShort
    Click
    Sleep, sleepMedium
    Click,2
    Sleep, sleepMedium
    Send, {Control Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepMedium
    Send, SHIFT
    Sleep, sleepMedium
    Send, {ESC}
    Sleep, sleepMedium
    Send, {Shift Down}
    Sleep, sleepShort
    Send, 1
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Down}
    Sleep, sleepShort
    Send, {Shift Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepShort
    MouseMove, 0,+23, 0, R ; <-- moves cursor down to next line
    ;ITEM LOOP ENDS HERE
    ;ITEM LOOP STARTS HERE
    Sleep, sleepShort
    Click
    Sleep, sleepMedium
    Click,2
    Sleep, sleepMedium
    Send, {Control Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepMedium
    Send, CTRL+ALT
    Sleep, sleepMedium
    Send, {ESC}
    Sleep, sleepMedium
    Send, {Shift Down}
    Sleep, sleepShort
    Send, 1
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Down}
    Sleep, sleepShort
    Send, {Shift Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepShort
    MouseMove, 0,+23, 0, R ; <-- moves cursor down to next line
    ;ITEM LOOP ENDS HERE
    ;ITEM LOOP STARTS HERE
    Sleep, sleepShort
    Click
    Sleep, sleepMedium
    Click,2
    Sleep, sleepMedium
    Send, {Control Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepMedium
    Send, CTRL+SHIFT
    Sleep, sleepMedium
    Send, {ESC}
    Sleep, sleepMedium
    Send, {Shift Down}
    Sleep, sleepShort
    Send, 1
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Down}
    Sleep, sleepShort
    Send, {Shift Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepShort
    MouseMove, 0,+23, 0, R ; <-- moves cursor down to next line
    ;ITEM LOOP ENDS HERE
    ;ITEM LOOP STARTS HERE
    Sleep, sleepShort
    Click
    Sleep, sleepMedium
    Click,2
    Sleep, sleepMedium
    Send, {Control Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepMedium
    Send, ALT+SHIFT
    Sleep, sleepMedium
    Send, {ESC}
    Sleep, sleepMedium
    Send, {Shift Down}
    Sleep, sleepShort
    Send, 1
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Down}
    Sleep, sleepShort
    Send, {Shift Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepShort
    MouseMove, 0,+23, 0, R ; <-- moves cursor down to next line
    ;ITEM LOOP ENDS HERE
    ;ITEM LOOP STARTS HERE
    Sleep, sleepShort
    Click
    Sleep, sleepMedium
    Click,2
    Sleep, sleepMedium
    Send, {Control Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepMedium
    Send, CTRL+ALT+SHIFT
    Sleep, sleepMedium
    Send, {ESC}
    Sleep, sleepMedium
    Send, {Shift Down}
    Sleep, sleepShort
    Send, 1
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Down}
    Sleep, sleepShort
    Send, {Shift Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepShort
    MouseMove, 0,+23, 0, R ; <-- moves cursor down to next line
    ;ITEM LOOP ENDS HERE
    msgbox, ALL-done
    return
;+^!f11::
;+^!f12::
;+^!f13::
;+^!f14::
;+^!f15::
;+^!f16::


#IfWinActive

;===== END SCAF DEFINITIONS ===============================================================

;===== FUNCTIONS ===============================================================================

RemoveSplashScreen:
    SplashTextOff
    SetTimer RemoveSplashScreen, Off
    return

; This function will auto-reload the script on save.
CheckScriptUpdate() {
    global ScriptStartModTime
    FileGetTime curModTime, %A_ScriptFullPath%
    If (curModTime <> ScriptStartModTime) {
        Loop
        {
            reload
            Sleep 300 ; ms
            MsgBox 0x2, %A_ScriptName%, Reload failed. ; 0x2 = Abort/Retry/Ignore
            IfMsgBox Abort
                ExitApp
            IfMsgBox Ignore
                break
        } ; loops reload on "Retry"
    }
}

Chooser(Choice) {
    MsgBox, Mouse: %xposP%, %yposP%
    ;ITEM LOOP STARTS HERE
    Sleep, sleepShort
    Click, %xposP%, %yposP%, 0
    Sleep, sleepMedium
    Click,2
    Sleep, sleepMedium
    Send, {Control Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepMedium
    Send, %Choice1%
    Sleep, sleepMedium
    Send, {ESC}
    Sleep, sleepMedium
    Send, {Shift Down}
    Sleep, sleepShort
    Send, 1
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Down}
    Sleep, sleepShort
    Send, {Shift Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepShort
    MouseMove, 0,+23, 0, R ; <-- moves cursor down to next line
    ;ITEM LOOP ENDS HERE
    msgbox, %Choice%-done
}