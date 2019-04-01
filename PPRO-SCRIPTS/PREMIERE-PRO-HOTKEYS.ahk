; AutoHotKey - EDIT 2 - Premiere Pro Actions & Functions
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


Menu, Tray, Icon, shell32.dll, 116 ; this changes the tray icon to a filmstrip!
;===== INITIALIZATION - VARIABLES ==============================================================
; Sleep shortcuts - use these to standardize sleep times. Change here to change everywhere.
sleepMicro = 15
sleepShort = 333
sleepMedium = 666
sleepLong = 1500
sleepDeep = 3500

;===== SPLASH SCREEN TO ANNOUNCE WHAT SCRIPT DOES ==============================================
SplashTextOn, 600, 80, Launching %A_ScriptFullPath%, Loading PREMIERE PRO HOTKEYS Script.`n`nWin-[ to show CheatSheet of Keyboard Layout (BEN-CC19.kys).
WinMove, Launching %A_ScriptFullPath%, , 100, 300
Sleep, sleepLong
SplashTextOff
;===== END OF AUTO-EXECUTE =====================================================================

;===== MODIFIER MEMORY HELPER ==================================================================
; combine below with key and '::' to define hotkey 
; e.g.- ^f1::Msgbox You pressed Control and F1
; #=Win | !=Alt | ^=Ctrl | +=Shift | &=combine keys | *=ignore other mods
; <=use left mod key| >=use right mod key  | UP=fires on release

;===== MAIN HOTKEY DEFINITIONS HERE ============================================================

;===== PREMIERE PRO HOTKEY DEFINITIONS HERE ============================================

#IfWinActive, ahk_exe Adobe Premiere Pro.exe

^3:: ; <-- PPRO: Step Left 5 seconds THEN Play
Send, {2}{Control Down}{f9}{Control Up}
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
sleep, sleepMicro
Send, 3
return

^4:: ; <-- PPRO: Step Left 1 second
Send, {Control Down}{f9}{Control Up}
sleep, sleepMicro
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

^5:: ; <-- PPRO: Step Right 1 second
Send, {Control Down}{f9}{Control Up}
sleep, sleepMicro
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

^+3:: ; <-- PPRO: Step Left 10 seconds THEN Play
Send, {2}{Control Down}{f9}{Control Up}
sleep, sleepMicro
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


!f:: ; <-- PPRO: closing the Menu that gets opened when this key combo is sent
Send, !f{ESC}
return

!m:: ; <-- PPRO: closing the Menu that gets opened when this key combo is sent
Send, !m{ESC}
return

!w:: ; <-- PPRO: closing the Menu that gets opened when this key combo is sent
Send, !w{ESC}
return

!z:: ; <-- PPRO: Select clip @ playhead & delete it
Send, d ; PPro Key for 'select clip at playhead'
Send, {DEL} ; PPro Key for 'remove'
return


 
#IfWinActive

;===== END Program 1 DEFINITIONS ===============================================================

;===== FUNCTIONS ===============================================================================

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
