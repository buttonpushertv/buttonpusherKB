; AutoHotKey - Buttonpusher Post-Production Keyboard Environment - AVID Media Composer Hotkeys
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
;FileGetTime ScriptStartModTime, %A_ScriptFullPath%
;SetTimer CheckScriptUpdate, 100, 0x7FFFFFFF ; 100 ms, highest priority
; AUTO-RELOAD ON SAVE DISABLED - UNCOMMENT 2 LINES ABOVE TO RE-ENABLE
; SEE THE FUNCTION BELOW FOR MORE INFO

Menu, Tray, Icon, shell32.dll, 116 ; this changes the tray icon to a filmstrip!
;===== INITIALIZATION - VARIABLES ==============================================================
; Sleep shortcuts - use these to standardize sleep times. Change here to change everywhere.
sleepMicro := 5
sleepMini := 15
sleepTiny := 111
sleepShort := 200
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

;===== APP-SPECIFIC HOTKEY DEFINITIONS HERE ============================================

; AVID MC only allows the plain keys and the shifted keys to be used as mappable keyboard shortcuts within the app. These hotkeys below allow for Alt & Ctrl to be used as mappable keys.

; IMPORTANT - this script must be used in conjunction with the Avid MC keyboard layout contained within this script's folder. It is a substantially modified keyboard layout from the standard Avid layout. I prefer to have most of the functions mapped to the left side of the keyboard, so this will only work with that keyboard layout (as many of the shifted right hand keys are remapped to functions I want to move to the left side by using Alt and Control as modifiers.) - BEN

#IfWinActive, ahk_exe AvidMediaComposer.exe

F1:: ; Move backward 1 frame
    Send, {Left}
    Return

+F1:: ; Move backward 8/10 frames
    Send, +{Left}
    Return

!q:: ; clear In Point
    Send, I
    Return

!w:: ; clear Out Point
    Send, O
    Return

!F3:: ; this will clear the In & Out points
    Send, P
    Return


;===== SHIFT-CONTROL-ALT-FUNCTION KEY DEFINITIONS HERE =========================================

+^!f1:: ;<-- toggle V1
    KeyWait, F1
    Send, {F7}
    Return
+^!f2:: ;<-- toggle v2
    KeyWait, F2
    Send, {F8}
    Return
+^!f3:: ; <-- Toggle selection of the first 8 audio tracks by Avid MC KB Shortcut
    KeyWait, F3
    SoundPlay, ..\SUPPORTING-FILES\SOUNDS\interfaceanditemsounds\V.3.0 Files\Special & Powerup (32).wav
    Send, {F9}
    Sleep, sleepShort
    Send, {F10}
    Sleep, sleepShort
    Send, {F11}
    Sleep, sleepShort
    Send, {F12}
    Sleep, sleepShort
    Send, +{F9}
    Sleep, sleepShort
    Send, +{F10}
    Sleep, sleepShort
    Send, +{F11}
    Sleep, sleepShort
    Send, +{F12}
    Sleep, sleepShort
    SoundPlay, ..\SUPPORTING-FILES\SOUNDS\interfaceanditemsounds\V1.0\Items & Collectables\Coins (1).wav
    Return
;+^!f4::
+^!f5:: ;<-- focus
    KeyWait, F5
    Send, h
    Return
+^!f6:: ;<-- view whole timeline
    KeyWait, F6
    Send, ^/
    Return
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

/*
; THIS FUNCTION WHILE USEFUL, MAY NOT BE NEEDED IN MOST SCRIPTS.
; IT IS HERE TO BE USED ON AN AS NEEDED BASIS - DURING DEVELOPMENT, FOR INSTANCE.
: REMOVE THE COMMENT BLOCK LINES AND UNCOMMENT THE LINES AT THE HEAD OF THIS SCRIPT TO RE-ENABLE IT.
; This function will auto-reload the script on save.
CheckScriptUpdate() {
    global ScriptStartModTime
    FileGetTime curModTime, %A_ScriptFullPath%
    If (curModTime <> ScriptStartModTime) {
        Loop
        {
            reload
            Sleep 333 ; ms
            MsgBox 0x2, %A_ScriptName%, Reload failed. ; 0x2 = Abort/Retry/Ignore
            IfMsgBox Abort
                ExitApp
            IfMsgBox Ignore
                break
        } ; loops reload on "Retry"
    }
}
*/