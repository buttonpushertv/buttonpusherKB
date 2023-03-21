; AutoHotKey - Buttonpusher Post-Production Keyboard Environment - Premiere Pro HotKeys
; by Ben Howard - ben@buttonpusher.tv

; One-shot Script for use with: Premiere Pro

; The idea nehind this script is to use it in conjunction with a Streamdeck, so you don't need to dedicate keyboard shortcuts to various tasks. Also should help fight the 'hiding' of commands, which get buried under key combos that can be hard to track or remember

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

; Sleep shortcuts - use these to standardize sleep times. Change here to change everywhere.
sleepMicro := 5
sleepMini := 15
sleepShort := 333
sleepMedium := 666
sleepLong := 1500
sleepDeep := 3500

; This is included to allow for app-related functions to be used in the script 
#Include %A_ScriptDir%\..\PREMIERE-PRO-FUNCTIONS.ahk

; This script will store the contents of the PPRO Settings->Labels panel to a text file

MsgBox, 33, Load PPRO Label Fields, This script will save the text values from the fields on the Settings->Labels panel.`n`nPlease make sure you are sitting with that panel open and ready to accept text entry before running this script.`n`nClick OK to begjn grabbing the LABELS into the text fields.`nClick CANCEL to abort this process.

IfMsgBox Cancel
    ExitApp

; step through each text field and paste an entry
WinActivate, ahk_exe Adobe Premiere Pro.exe
Sleep, sleepShort

; message box to alert user that:
; 1. they should be in the PPRO Settings/>Lables panel
; 2. give options - OK to proceed & Cancel to cancel

; input box to get name of labels file to be stored
storedLabels := [] ; creating the array

arrayCount := 1 ; set the count to 1
elementMax := 16 ; this is the number of fields to loop through
While(arrayCount <= elementMax)
    {
    Send, {Tab}
    Sleep, sleepShort
    Send, ^c
    Sleep, sleepShort
    storedLabels[arrayCount] := clipboard
    ;MSGBOX, , DEBUG, % "clipboard: " . clipboard . "`narrayCount: " . arrayCount . "`nelementMax: " . elementMax . "`nstoredLabels[" . arrayCount . "]: " .  storedLabels[arrayCount]
    arrayCount++
    }

    ; step through each Label field and copy each item to clipboard and then store to array
    
    ;MSGBOX, , DEBUG, % "clipboard: " . clipboard . "`narrayCount: " . arrayCount . "`nelementMax: " . elementMax . "`nstoredLabels[1]: " .  storedLabels[1] . "`nstoredLabels[2]: " .  storedLabels[2] . "`nstoredLabels[3]: " .  storedLabels[3] . "`nstoredLabels[4]: " .  storedLabels[4] . "`nstoredLabels[5]: " .  storedLabels[5] . "`nstoredLabels[6]: " .  storedLabels[6] . "`nstoredLabels[7]: " .  storedLabels[7] . "`nstoredLabels[8]: " .  storedLabels[8] . "`nstoredLabels[9]: " .  storedLabels[9] . "`nstoredLabels[10]: " .  storedLabels[10] . "`nstoredLabels[11]: " .  storedLabels[11] . "`nstoredLabels[12]: " .  storedLabels[12] . "`nstoredLabels[13]: " .  storedLabels[13] . "`nstoredLabels[14]: " .  storedLabels[14] . "`nstoredLabels[15]: " .  storedLabels[15] . "`nstoredLabels[16]: " .  storedLabels[16]

    ; save array to a single block on clipboard
    arrayCount := 1 ; set the count to 1
    clipboard :=
    clipboard .= "/*`n"
    While(arrayCount <= elementMax)
        {
            tempItem := storedLabels[arrayCount]
            clipboard .= arrayCount . "-" . tempItem . "`n"
            arrayCount++
        }
    clipboard .= "*/`n"

MSGBOX, 4, Label values stored on clipboard, The values currently stored in Premiere Pro's Label text fields are now stored on the clipboard.`n`n The values are:`n %clipboard%`n`nBe sure to save them before copying anything else to the clipboard.`n`nClick YES below to open VS Code in the BKB Workspace to paste these labels into the appropriate script.`nClick NO to skip.

IfMsgBox Yes 
    Run, "C:\BKB\PRIVATE\buttonpusherKB.code-workspace"

; END OF SCRIPT
ExitApp
