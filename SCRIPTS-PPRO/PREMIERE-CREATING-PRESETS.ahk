; AutoHotKey - Creating Premiere Pro Templates
; by Ben Howard - ben@buttonpusher.tv

;I had an idea you could use %A_ScriptName% to feed the preset() function. That means you should be able to a)create/save a preset in Premiere, b)set the name to something unique, c)copy that name to the clipboard, d) then create a script in the preset-scripts folder so that you could easily add it to streamdeck (or wherever) without having to touch any code.

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

;===== MAIN HOTKEY DEFINITIONS HERE ============================================================

    coordmode, mouse, Window
    Click
    Sleep, sleepShort
    Send, {LControl Down}
    Sleep, sleepShort
    Send, {c Down}
    Sleep, sleepShort
    Send, {c Up}
    Sleep, sleepShort
    Send, {LControl Up}
    Sleep, sleepShort
    Send, {ESC}
    fileToCreate = %clipboard%
    MsgBox, 36, Is This Correct?, For this to work`, you need to:`n  1) Position cursor over the name of the Preset`n  2) Click *once* on the Preset you are trying to save. (It should be higlighted gray.)`n`nIs this the correct Preset name:   %clipboard%
    IfMsgBox No
        MsgBox Select the Preset you wish to save and leave cursor over it's name.
    IfMsgBox Yes
        {
            IfExist, preset-scripts\%fileToCreate%.ahk
                {
                MsgBox, 36, Preset Already Exists,A Preset with the name`n`n%fileToCreate%.ahk`n`nalready exists in the "preset-scripts" folder.`n`nOverwrite?
                    {
                    IfMsgBox Yes
                        {
                        FileDelete, preset-scripts\%fileToCreate%.ahk
                        goto createPresetFile
                        }
                    IfMsgBox No
                        MsgBox,,File Not Deleted,preset-scripts\%fileToCreate%.ahk left on disk.,3
                    }
                }
            createPresetFile:
            FileAppend,
            (
preset("%fileToCreate%")
exitapp

#Include %A_LineFile%\..\..\PREMIERE-PRO-FUNCTIONS.ahk
            ), preset-scripts\%fileToCreate%.ahk
        MsgBox Preset saved to preset-scripts\%fileToCreate%.ahk
        }
    ExitApp

;===== FUNCTIONS ===============================================================================
