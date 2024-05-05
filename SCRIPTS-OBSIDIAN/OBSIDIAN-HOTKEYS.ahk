; AutoHotKey - OBISDIAN HOTKEYS
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

#IfWinActive, ahk_exe Obsidian.exe

F13:: ;<-- Import Burgs
Send, ^!j
Sleep, sleepShort
Send, {Enter}
Sleep, sleepShort
; Load the JSON File
WinWaitActive, Open
Send, Ladonia Full 2024-03-31-10-23-MODDED.json
Sleep, sleepShort
Send, {ENTER}
Sleep, sleepMedium
; Move to Handlebar Template Button
Loop, 4
{
    Send, {Tab}
    Sleep, sleepShort
}
; Load the Handlebar Template
Send, {Enter}
Sleep, sleepShort
WinWaitActive, Open
Sleep, sleepShort
Send, Burgs-FMG-JSON Handlerbars Template.md
Sleep, sleepShort
Send, {Enter}
; Move to Helper JS Button
Sleep, sleepLong
Send, {Tab}
Sleep, sleepShort
; Load the Helper JS Script
Send, {Enter}
WinWaitActive, Open
Send, Helpers-FMG-JSON.js
Sleep, sleepShort
Send, {Enter}
Sleep, sleepLong
; tab over the new Batch field
Send, {Tab}
Sleep, sleepShort
;Move to the Field Containing the Data
Send, {Tab}
Sleep, sleepShort
Send, pack.burgs ; field to edit
Sleep, sleepShort
; Move to the Data Field to Use
Loop, 2
    {
        Send, {Tab}
        Sleep, sleepShort
    }
Sleep, sleepMedium
Send, {Backspace}
Sleep, sleepShort
;Send, name ; field name here
Send, @{{}return ``${{}this.state{}}-${{}(this.state > 0) && dataRoot.pack.states.find(state => state.i === this.state)?.name || "Unknown" {}}/${{}dataRoot.pack.cells.find(c => c.i === this.cell)?.province{}}-${{}dataRoot.pack.provinces.find(p => p.i === dataRoot.pack.cells.find(c => c.i === this.cell)?.province)?.fullName{}}/${{}this.name{}}``{}}
Sleep, sleepShort
Loop, 6
    {
        Send, {Tab}
        Sleep, sleepShort
    }
clipboard := "01-Campaigns/Test Campaign Ladonia/05-Atlas/States"

Return

F14:: ;<-- Import Provinces
Send, ^!j
Sleep, sleepShort
Send, {Enter}
Sleep, sleepShort
; Load the JSON File
WinWaitActive, Open
Send, Ladonia Full 2024-03-31-10-23-MODDED.json
Sleep, sleepShort
Send, {ENTER}
Sleep, sleepMedium
; Move to Handlebar Template Button
Loop, 4
{
    Send, {Tab}
    Sleep, sleepShort
}
; Load the Handlebar Template
Send, {Enter}
Sleep, sleepShort
WinWaitActive, Open
Sleep, sleepShort
Send, Provinces-FMG-JSON Handlebars Template.md
Sleep, sleepShort
Send, {Enter}
; Move to Helper JS Button
Sleep, sleepLong
Send, {Tab}
Sleep, sleepShort
; Load the Helper JS Script
Send, {Enter}
WinWaitActive, Open
Send, Helpers-FMG-JSON.js
Sleep, sleepShort
Send, {Enter}
Sleep, sleepLong
; tab over the new Batch field
Send, {Tab}
Sleep, sleepShort
;Move to the Field Containing the Data
Send, {Tab}
Sleep, sleepShort
Send, pack.provinces ; field to edit
Sleep, sleepShort
; Move to the Data Field to Use
Loop, 2
    {
        Send, {Tab}
        Sleep, sleepShort
    }
Sleep, sleepMedium
Send, {Backspace}
Sleep, sleepShort
; Send, fullName ; field name here
Send, @{{}return ``${{}this.state{}}-${{}(this.state > 0) && dataRoot.pack.states.find(state => state.i === this.state)?.name || "Unknown" {}}/${{}this.i{}}-${{}(this.i > 0) && this.fullName || "Unknown"{}}/${{}this.fullName{}}``{}}
Sleep, sleepShort
Loop, 6
    {
        Send, {Tab}
        Sleep, sleepShort
    }
clipboard := "01-Campaigns/Test Campaign Ladonia/05-Atlas/States"
Return

F15:: ;<-- Import States
Send, ^!j
Sleep, sleepShort
Send, {Enter}
Sleep, sleepShort
; Load the JSON File
WinWaitActive, Open
Send, Ladonia Full 2024-03-31-10-23-MODDED.json
Sleep, sleepShort
Send, {ENTER}
Sleep, sleepMedium
; Move to Handlebar Template Button
Loop, 4
{
    Send, {Tab}
    Sleep, sleepShort
}
; Load the Handlebar Template
Send, {Enter}
Sleep, sleepShort
WinWaitActive, Open
Sleep, sleepShort
Send, States-FMG-JSON Handlebars Template.md
Sleep, sleepShort
Send, {Enter}
; Move to Helper JS Button
Sleep, sleepLong
Send, {Tab}
Sleep, sleepShort
; Load the Helper JS Script
Send, {Enter}
WinWaitActive, Open
Send, Helpers-FMG-JSON.js
Sleep, sleepShort
Send, {Enter}
Sleep, sleepLong
; tab over the new Batch field
Send, {Tab}
Sleep, sleepShort
;Move to the Field Containing the Data
Send, {Tab}
Sleep, sleepShort
Send, pack.states ; field to edit
Sleep, sleepShort
; Move to the Data Field to Use
Loop, 2
    {
        Send, {Tab}
        Sleep, sleepShort
    }
Sleep, sleepMedium
Send, {Backspace}
Sleep, sleepShort
;Send, name ; field name here
Send, ${{}i{}}-${{}name{}}/${{}name{}}
Sleep, sleepShort
Loop, 3
    {
        Send, {Tab}
        Sleep, sleepShort
    }
Send, {Backspace}
Loop, 3
    {
        Send, {Tab}
        Sleep, sleepShort
    }
clipboard := "01-Campaigns/Test Campaign Ladonia/05-Atlas/States"
Return

F16:: ;<-- Import Cultures
Send, ^!j
Sleep, sleepShort
Send, {Enter}
Sleep, sleepShort
; Load the JSON File
WinWaitActive, Open
Send, Ladonia Full 2024-03-31-10-23-MODDED.json
Sleep, sleepShort
Send, {ENTER}
Sleep, sleepMedium
; Move to Handlebar Template Button
Loop, 4
{
    Send, {Tab}
    Sleep, sleepShort
}
; Load the Handlebar Template
Send, {Enter}
Sleep, sleepShort
WinWaitActive, Open
Sleep, sleepShort
Send, Cultures-FMG-JSON Handlebars Template.md
Sleep, sleepShort
Send, {Enter}
; Move to Helper JS Button
Sleep, sleepLong
Send, {Tab}
Sleep, sleepShort
; Load the Helper JS Script
Send, {Enter}
WinWaitActive, Open
Send, Helpers-FMG-JSON.js
Sleep, sleepShort
Send, {Enter}
Sleep, sleepLong
; tab over the new Batch field
Send, {Tab}
Sleep, sleepShort
;Move to the Field Containing the Data
Send, {Tab}
Sleep, sleepShort
Send, pack.cultures ; field to edit
Sleep, sleepShort
; Move to the Data Field to Use
Loop, 2
    {
        Send, {Tab}
        Sleep, sleepShort
    }
Sleep, sleepMedium
Send, {Backspace}
Sleep, sleepShort
Send, name ; field name here
Sleep, sleepShort
Loop, 3
    {
        Send, {Tab}
        Sleep, sleepShort
    }
Send, {Backspace}
Loop, 3
    {
        Send, {Tab}
        Sleep, sleepShort
    }
clipboard := "01-Campaigns/Test Campaign Ladonia/05-Atlas/Cultures"
Return

F17:: ;<-- Import Religions
Send, ^!j
Sleep, sleepShort
Send, {Enter}
Sleep, sleepShort
; Load the JSON File
WinWaitActive, Open
Send, Ladonia Full 2024-03-31-10-23-MODDED.json
Sleep, sleepShort
Send, {ENTER}
Sleep, sleepMedium
; Move to Handlebar Template Button
Loop, 4
{
    Send, {Tab}
    Sleep, sleepShort
}
; Load the Handlebar Template
Send, {Enter}
Sleep, sleepShort
WinWaitActive, Open
Sleep, sleepShort
Send, Religions-FMG-JSON Handlebars Template.md
Sleep, sleepShort
Send, {Enter}
; Move to Helper JS Button
Sleep, sleepLong
Send, {Tab}
Sleep, sleepShort
; Load the Helper JS Script
Send, {Enter}
WinWaitActive, Open
Send, Helpers-FMG-JSON.js
Sleep, sleepShort
Send, {Enter}
Sleep, sleepLong
; tab over the new Batch field
Send, {Tab}
Sleep, sleepShort
;Move to the Field Containing the Data
Send, {Tab}
Sleep, sleepShort
Send, pack.religions ; field to edit
Sleep, sleepShort
; Move to the Data Field to Use
Loop, 2
    {
        Send, {Tab}
        Sleep, sleepShort
    }
Sleep, sleepMedium
Send, {Backspace}
Sleep, sleepShort
Send, name ; field name here
Sleep, sleepShort
Loop, 6
    {
        Send, {Tab}
        Sleep, sleepShort
    }
clipboard := "01-Campaigns/Test Campaign Ladonia/05-Atlas/Religions"
Return

F18:: ;<-- Import Atlas
Send, ^!j
Sleep, sleepShort
Send, {Enter}
Sleep, sleepShort
; Load the JSON File
WinWaitActive, Open
Send, Ladonia Full 2024-03-31-10-23-MODDED.json
Sleep, sleepShort
Send, {ENTER}
Sleep, sleepMedium
; Move to Handlebar Template Button
Loop, 4
{
    Send, {Tab}
    Sleep, sleepShort
}
; Load the Handlebar Template
Send, {Enter}
Sleep, sleepShort
WinWaitActive, Open
Sleep, sleepShort
Send, Atlas-FMG-JSON Handlebars Template.md
Sleep, sleepShort
Send, {Enter}
; Move to Helper JS Button
Sleep, sleepLong
Send, {Tab}
Sleep, sleepShort
; Load the Helper JS Script
Send, {Enter}
WinWaitActive, Open
Send, Helpers-FMG-JSON.js
Sleep, sleepShort
Send, {Enter}
Sleep, sleepLong
;Move to the Field Containing the Data
Send, {Tab}
Sleep, sleepShort
Send, {Backspace} ; field to edit
Sleep, sleepShort
; Move to the Data Field to Use
Loop, 2
    {
        Send, {Tab}
        Sleep, sleepShort
    }
Sleep, sleepMedium
Send, {Backspace}
Sleep, sleepShort
Send, info.thisCampaign ; field name here
Sleep, sleepShort
Loop, 3
    {
        Send, {Tab}
        Sleep, sleepShort
    }
Send, -Linked Atlas
Loop, 3
    {
        Send, {Tab}
        Sleep, sleepShort
    }
clipboard := "01-Campaigns/Test Campaign Ladonia/05-Atlas"
Return

F19:: ;<-- Import Linked Atlas
Send, ^!j
Sleep, sleepShort
Send, {Enter}
Sleep, sleepShort
; Load the JSON File
WinWaitActive, Open
Send, Ladonia Full 2024-03-31-10-23-MODDED.json
Sleep, sleepShort
Send, {ENTER}
Sleep, sleepMedium
; Move to Handlebar Template Button
Loop, 4
{
    Send, {Tab}
    Sleep, sleepShort
}
; Load the Handlebar Template
Send, {Enter}
Sleep, sleepShort
WinWaitActive, Open
Sleep, sleepShort
Send, states-tester-FMG-JSON-Template.md
Sleep, sleepShort
Send, {Enter}
; Move to Helper JS Button
Sleep, sleepLong
Send, {Tab}
Sleep, sleepShort
; Load the Helper JS Script
Send, {Enter}
WinWaitActive, Open
Send, Helpers-FMG-JSON.js
Sleep, sleepShort
Send, {Enter}
Sleep, sleepLong
; tab over the new Batch field
Send, {Tab}
Sleep, sleepShort
;Move to the Field Containing the Data
Send, {Tab}
Sleep, sleepShort
Send, pack.states ; field to edit
Sleep, sleepShort
; Move to the Data Field to Use
Loop, 2
    {
        Send, {Tab}
        Sleep, sleepShort
    }
Sleep, sleepMedium
Send, {Backspace}
Sleep, sleepShort
Send, ${{}i{}}-${{}name{}}
Sleep, sleepShort
Loop, 3
    {
        Send, {Tab}
        Sleep, sleepShort
    }
Send, -TEST
Loop, 3
    {
        Send, {Tab}
        Sleep, sleepShort
    }
clipboard := "01-Campaigns/Test Campaign Ladonia/05-Atlas/state-test"
Return

;===============================================================================================

;===== FUNCTIONS ===============================================================================
