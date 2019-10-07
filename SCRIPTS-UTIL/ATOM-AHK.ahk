; AutoHotKey - Atom Helper Script for AHK work
; by Ben Howard - ben@buttonpusher.tv


;===== START OF AUTO-EXECUTION SECTION =========================================================
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; #Persistent ; Keeps script permanently running.
#SingleInstance force ; Ensures that there is only a single instance of this script running.
; SetTitleMatchMode, 2 ; sets title matching to search for "containing" instead of "exact"


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

iniFile := "..\settings.ini"
IniRead, Settings_rootFolder, %iniFile%, Settings, rootFolder
;MsgBox, %Settings_rootFolder%
;===== SPLASH SCREEN TO ANNOUNCE WHAT SCRIPT DOES ==============================================
SplashTextOn, 600, 100, Launching %A_ScriptFullPath%, Loading ATOM AHK HELPER Script.`n`nF1 <-- Search selected AHK command in web docs.
WinMove, Launching %A_ScriptFullPath%, , %splashScreenX%, %splashScreenY%
SetTimer, RemoveSplashScreen, %splashScreenTimeout%
;===== END OF AUTO-EXECUTE =====================================================================
;===== MODIFIER MEMORY HELPER ==================================================================
; combine below with key and '::' to define hotkey
; e.g.- ^f1::Msgbox You pressed Control and F1
; #=Win | !=Alt | ^=Ctrl | +=Shift | &=combine keys | *=ignore other mods
; <=use left mod key| >=use right mod key  | UP=fires on release

;===== MAIN HOTKEY DEFINITIONS HERE ============================================================
;===== APPLICATION SPECIFIC HOTKEY DEFINITIONS HERE ============================================

#IfWinActive, ahk_exe atom.exe

; The hotkey below uses the clipboard to provide compatibility with the maximum
; number of editors (since ControlGet doesn't work with most advanced editors).
; It restores the original clipboard contents afterward, but as plain text,
; which seems better than nothing.

F1::
; The following values are in effect only for the duration of this hotkey thread.
; Therefore, there is no need to change them back to their original values
; because that is done automatically when the thread ends:
SetWinDelay 10
SetKeyDelay 0
AutoTrim, On

if A_OSType = WIN32_WINDOWS  ; Windows 9x
    Sleep, 500  ; Give time for the user to release the key.

C_ClipboardPrev = %clipboard%
clipboard =
; Use the highlighted word if there is one (since sometimes the user might
; intentionally highlight something that isn't a command):
Send, ^c
ClipWait, 0.1
if ErrorLevel <> 0
{
    ; Get the entire line because editors treat cursor navigation keys differently:
    Send, {home}+{end}^c
    ClipWait, 0.2
    if ErrorLevel <> 0  ; Rare, so no error is reported.
    {
        clipboard = %C_ClipboardPrev%
        return
    }
}
C_Cmd = %clipboard%  ; This will trim leading and trailing tabs & spaces.
clipboard = %C_ClipboardPrev%  ; Restore the original clipboard for the user.
Loop, parse, C_Cmd, %A_Space%`,  ; The first space or comma is the end of the command.
{
    C_Cmd = %A_LoopField%
    break ; i.e. we only need one interation.
}
IfWinNotExist, AutoHotkey Help
{
    ; Determine AutoHotkey's location:
    RegRead, ahk_dir, HKEY_LOCAL_MACHINE, SOFTWARE\AutoHotkey, InstallDir
    if ErrorLevel  ; Not found, so look for it in some other common locations.
    {
        if A_AhkPath
            SplitPath, A_AhkPath,, ahk_dir
        else IfExist ..\..\AutoHotkey.chm
            ahk_dir = ..\..
        else IfExist %A_ProgramFiles%\AutoHotkey\AutoHotkey.chm
            ahk_dir = %A_ProgramFiles%\AutoHotkey
        else
        {
            MsgBox Could not find the AutoHotkey folder.
            return
        }
    }
    Run %ahk_dir%\AutoHotkey.chm
    WinWait AutoHotkey Help
}
; The above has set the "last found" window which we use below:
WinActivate
WinWaitActive
StringReplace, C_Cmd, C_Cmd, #, {#}
Send, !n{home}+{end}%C_Cmd%{enter}
return

;===== SHIFT-CONTROL-ALT-FUNCTION KEY DEFINITIONS HERE =========================================
; Quick template for the 16 Function keys to use as SCAF Keys.

; What are SCAF Keys? It's my method of creating a standardized set of macro keys. I have several
; keyboards/macropads with the keys programmed in (via QMK or device driver/config apps) so that
; I have easy access to a set of keys that are not likely to be used by other apps. Use them for
; any kind of repetitive task or other function that may not have an existing (or inconvinient)
; keystroke combo to execute.

+^!f1::Run, "SNIPPETS\SNIPPET01.ahk"
;+^!f2::
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

;===== END Program 1 DEFINITIONS ===============================================================

;===== FUNCTIONS ===============================================================================

RemoveSplashScreen:
    SplashTextOff
    SetTimer RemoveSplashScreen, Off
    return
