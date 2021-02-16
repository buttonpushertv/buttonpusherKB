; AutoHotKey - Blank Template
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

#IfWinActive, ahk_exe chrome.exe
CoordMode, Mouse, Client

F21:: ; <-- Downloading Comps from a ShutterStock Single Image page
    ; This will auto-magically download comp versions of video clips from iStockPhoto.com
    ; It will do this by doing the following: 
    ;   -Store the current position of the cursor when hotkey is pressed.
    ;   -Shift Middle-Click on a clip in a board to open in new tab. 
    ;   -Activate that new tab.
    ;   -Left click on the 'Try' link to download a comp
    ;   -Wait 2/3 second.
    ;   -Close the Tab.
    ;   -Restore cursor to position where it started.
    ;
    ; There are a few things you need to setup/make sure of before using this hotkey:
    ;   1-Use Chrome (that's why it's in the CHROME-HOTKEYS.ahk)
    ;   2-Make sure Chrome view is set to 100%
    ;   3-Be using an Shutterstock.com Board. See the F19 version for saving from a Video's page directly.
    ;   4-You will need to move the downloaded comp videos to an appropriate location for your project.
    ;     (FileJuggler can help move them auto-magically from the 'Downloads' folder - if you are getting a large number of clips)
    ;
    MouseGetPos, xposP, yposP ;---storing cursor's current coordinates at X%xposP% Y%yposP%
    Sleep, sleepShort
    shutterStockClickAndClose()
    MouseMove, xposP, yposP
    Return


F22:: ; <-- Downloading Comps from a ShutterStock Board
    ; This will auto-magically download comp versions of video clips from iStockPhoto.com
    ; It will do this by doing the following: 
    ;   -Store the current position of the cursor when hotkey is pressed.
    ;   -Shift Middle-Click on a clip in a board to open in new tab. 
    ;   -Activate that new tab.
    ;   -Left click on the 'Try' link to download a comp
    ;   -Wait 2/3 second.
    ;   -Close the Tab.
    ;   -Restore cursor to position where it started.
    ;
    ; There are a few things you need to setup/make sure of before using this hotkey:
    ;   1-Use Chrome (that's why it's in the CHROME-HOTKEYS.ahk)
    ;   2-Make sure Chrome view is set to 100%
    ;   3-Be using an Shutterstock.com Board. See the F19 version for saving from a Video's page directly.
    ;   4-You will need to move the downloaded comp videos to an appropriate location for your project.
    ;     (FileJuggler can help move them auto-magically from the 'Downloads' folder - if you are getting a large number of clips)
    ;
    MouseGetPos, xposP, yposP ;---storing cursor's current coordinates at X%xposP% Y%yposP%
    Send, {LShift Down}
    Sleep, sleepShort
    Send, {MButton}
    Sleep, sleepShort
    Send, {Blind}{LShift Up}
    pageLoadCheck:
    PixelSearch, Px, Py, 277, 18, 281, 23, 0xEE3625, 10, Fast RGB
    if ErrorLevel
        goto pageLoadCheck
    else
        shutterStockClickAndClose()
    MouseMove, xposP, yposP
    
    Return

F23:: ; <-- Downloading Comps from an iStockPhoto Single Video Page
    ; This will auto-magically download comp versions of video clips from iStockPhoto.com
    ; It will do this by doing the following: 
    ;   -Store the current position of the cursor when hotkey is pressed.
    ;   -Right click on the bottom, middle of the preview clip.
    ;   -Select "Save Video As".
    ;   -Wait for the 'Save As' window to activate.
    ;   -Press Enter to save the comp clip.
    ;   -Wait for the 'Save As' window to deactivate.
    ;   -Restore cursor to position where it started.
    ;
    ; There are a few things you need to setup/make sure of before using this hotkey:
    ;   1-Use Chrome (that's why it's in the CHROME-HOTKEYS.ahk)
    ;   2-Make sure Chrome view is set to 100%
    ;   3-Do the process once, manually, to set the location where files will be saved.
    ;
    MouseGetPos, xposP, yposP ;---storing cursor's current coordinates at X%xposP% Y%yposP%
    Click, right, 390, 590
    Sleep, sleepMedium
    Click, 440, 630
    WinWaitActive, Save As,, 3
    SendInput, {Enter}
    WinWaitNotActive, Save As,, 3
    MouseMove, xposP, yposP
    Return

F24:: ; <-- Downloading Comps from an iStockPhoto Board
    ; This will auto-magically download comp versions of video clips from iStockPhoto.com
    ; It will do this by doing the following: 
    ;   -Store the current position of the cursor when hotkey is pressed.
    ;   -Shift Middle-Click on a clip in a board to open in new tab.
    ;   -Activate that new tab.
    ;   -Right click on the bottom, middle of the preview clip.
    ;   -Select "Save Video As".
    ;   -Wait for the 'Save As' window to activate.
    ;   -Press Enter to save the comp clip.
    ;   -Wait for the 'Save As' window to deactivate.
    ;   -Close the Tab.
    ;   -Restore cursor to position where it started.
    ;
    ; There are a few things you need to setup/make sure of before using this hotkey:
    ;   1-Use Chrome (that's why it's in the CHROME-HOTKEYS.ahk)
    ;   2-Make sure Chrome view is set to 100%
    ;   3-Be using an iStockPhoto.com Board. See the F23 version for saving from a Video's page directly.
    ;   4-Do the process once, manually, to set the location where files will be saved.
    ;
    MouseGetPos, xposP, yposP ;---storing cursor's current coordinates at X%xposP% Y%yposP%
    Send, {LShift Down}
    Sleep, sleepShort
    Send, {MButton}
    Sleep, sleepShort
    Send, {Blind}{LShift Up}
    Sleep, sleepMedium
    Click, right, 390, 590
    Sleep, sleepMedium
    Click, 460, 680
    WinWaitActive, Save As,, 3
    SendInput, {Enter}
    WinWaitNotActive, Save As,, 3
    Send, {Control Down}w
    Send, {Blind}{Control Up}
    MouseMove, xposP, yposP
    Return

^F24:: ; <-- Reload CHROME-HOTKEYS.ahk
    MSGBOX, , DEBUG,Reloading Chrome-Hotkeys
    Reload
    Return

#IfWinActive
;===== FUNCTIONS ===============================================================================

shutterStockClickAndClose() {
    global sleepLong
    Click, 600, 715
    Sleep, sleepLong
    Send, {Control Down}w
    Send, {Blind}{Control Up}
    Return
}