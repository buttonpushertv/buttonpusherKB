; AutoHotKey - Buttonpusher Post-Production Keyboard Environment - PHOTOSHOP HotKeys
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

Menu, Tray, Icon, shell32.dll, 110 ; this changes the tray icon to a filmstrip!
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
SplashTextOn, 600, 100, Launching %A_ScriptFullPath%, Loading PHOTOSHOP HOTKEYS Script.
WinMove, Launching %A_ScriptFullPath%, , %splashScreenX%, %splashScreenY%
SetTimer, RemoveSplashScreen, %splashScreenTimeout%
;===== END OF AUTO-EXECUTE =====================================================================

;===== MODIFIER MEMORY HELPER ==================================================================
; combine below with key and '::' to define hotkey
; e.g.- ^f1::Msgbox You pressed Control and F1
; #=Win | !=Alt | ^=Ctrl | +=Shift | &=combine keys | *=ignore other mods
; <=use left mod key| >=use right mod key  | UP=fires on release

;===== MAIN HOTKEY DEFINITIONS HERE ============================================================

;===== PHOTOSHOP HOTKEY DEFINITIONS HERE ============================================
CoordMode, Mouse, Window

#IfWinActive, ahk_exe Photoshop.exe

;===== SHIFT-CONTROL-ALT-FUNCTION KEY DEFINITIONS HERE =========================================

+^!f1:: ; <-- set foreground color and get the hexcode to paste into https://www.color-blindness.com/color-name-hue/ to find the name of the color
MouseGetPos, posX, posY
Send, i
Sleep, sleepShort
Click
Sleep, sleepShort
Click, 22, 700
Sleep, sleepShort
Send, ^c
Sleep, sleepShort
Send {ESC}
Sleep, sleepMedium
Click, %posX%, %posY%, 2
Sleep, sleepLong
WinActivate, Color Name & Hue – Colblindor - Google Chrome
Sleep, sleeplong
Click, 619,799, 2
Sleep, sleepShort
Send, {CTRL Down}
Sleep, sleepShort
Send, V
Sleep, sleepShort
Send, {CTRL Up}   
Sleep, sleepShort
WinActivate, ahk_exe Photoshop.exe
return

+^!f2:: ; <-- creating a new color layer using forground color
Send, ^A
Sleep, sleepShort
Send, ^C
Sleep, sleepShort
Send, {Enter}
Sleep, sleepShort
Click, -1461,687
Sleep, sleepShort
Send, ^+n
Sleep, sleepShort
Send, ^V
Sleep, sleepShort
Send, {Enter}
Sleep, sleepShort
Send, {Shift Down}{F5}{Shift Up}
Sleep, sleepShort
Send, {Enter}
Sleep, sleepShort
MouseMove, %posX%, %posY%
return

;+^!f3:: 
;+^!f4:: 
;+^!f5::
;+^!f6::
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

;===== END PHOTOSHOP DEFINITIONS ===============================================================

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
