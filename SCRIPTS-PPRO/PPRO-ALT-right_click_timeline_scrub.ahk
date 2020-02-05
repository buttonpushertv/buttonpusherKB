; AutoHotKey - PPRO - ALTERNATE Right Click to Scrub TIMELINE
; by Ben Howard - ben@buttonpusher.tv

; You can customize this template by editing "C:\Windows\ShellNew\Template.ahk"
;===============================================================================================
; This Template.ahk file contains several of the most common items that I find myself often
; needing or adding to my scripts. It's not all essential. Here's a short list of what's here:
; - Function (CheckScriptUpdate) that will auto-reload the script when it detects a change
;	in the last modified timestamp on the script file itself
; - Sleep duration shortcuts - so that sleep times can be modified in one place to affect all
; - Modifier Memory Helper - just a comment section to remind you of what the codes are for things
;
; See comments througout the file to figure out what something is here for.

;===== START OF AUTO-EXECUTION SECTION =========================================================
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; #Persistent ; Keeps script permanently running.
#SingleInstance force ; Ensures that there is only a single instance of this script running.
; SetTitleMatchMode, 2 ; sets title matching to search for "containing" instead of "exact"

; The 2 lines below pertain to the 'reload on save' function below (CheckScriptUpdate). 
; They are required for it to work.
FileGetTime ScriptStartModTime, %A_ScriptFullPath%
SetTimer CheckScriptUpdate, 100, 0x7FFFFFFF ; 100 ms, highest priority

;===== INITIALIZATION - VARIABLES ==============================================================
; Sleep shortcuts - use these to standardize sleep times. Change here to change everywhere.
sleepShort = 333
sleepMedium = 666
sleepLong = 1500
sleepDeep = 3500

;===== SPLASH SCREEN TO ANNOUNCE WHAT SCRIPT DOES ==============================================
SplashTextOn, 600, 80, Launching %A_ScriptFullPath%, Text here to id what this script does.
Sleep, sleepDeep
SplashTextOff

;===== END OF AUTO-EXECUTE =====================================================================
;===== MODIFIER MEMORY HELPER ==================================================================
; combine below with key and '::' to define hotkey 
; e.g.- ^f1::Msgbox You pressed Control and F1
; #=Win | !=Alt | ^=Ctrl | +=Shift | &=combine keys | *=ignore other mods
; <=use left mod key| >=use right mod key  | UP=fires on release

;===== MAIN HOTKEY DEFINITIONS HERE ============================================================
#IfWinActive Adobe Premiere Pro

Rbutton:
    MouseGetPos, mousexpos, mouseypos
    Imagesearch, YellowX, YellowY, mousexpos, mouseypos-1080, mousexpos+500, mouseypos, Yellowline.png
    Mousemove, YellowX, YellowY-20, 0
    SendInput {Lbutton down}
    MouseGetPos, newmousexpos, newmouseypos
    sleep 10
    Mousemove, newmousexpos, mouseypos, 0
    KeyWait, Rbutton, u
    SendInput {Lbutton up}
return

​
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