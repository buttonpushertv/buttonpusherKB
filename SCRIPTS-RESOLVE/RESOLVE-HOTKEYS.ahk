; AutoHotKey - Buttonpusher Post-Production Keyboard Environment - DaVinci Resolve HotKeys
; by Ben Howard - ben@buttonpusher.tv

;===== START OF AUTO-EXECUTION SECTION =========================================================
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; #Persistent ; Keeps script permanently running.
#SingleInstance force ; Ensures that there is only a single instance of this script running.
SetTitleMatchMode, 2 ; sets title matching to search for "containing" instead of "exact"
#MaxHotkeysPerInterval 2000
#WinActivateForce ;https://autohotkey.com/docs/commands/_WinActivateForce.htm

;Menu, Tray, Icon, shell32.dll, 116 ; this changes the tray icon to a filmstrip!
Menu, Tray, NoIcon

;===== INITIALIZATION - VARIABLES ==============================================================
; Sleep shortcuts - use these to standardize sleep times. Change here to change everywhere.
sleepMicro := 5
sleepMini := 15
sleepTiny := 111
sleepShort := 333
sleepMedium := 666
sleepLong := 1500
sleepDeep := 3500

#Include %A_ScriptDir%\RESOLVE-FUNCTIONS.ahk

; This section pre-defines the (most likely) location of the Program Monitor's Timecode display based on which edit system you happen to be working on. It also is tied to the most commonly used window layout that I use in each location.

EnvGet, Settings_rootFolder, BKB_ROOT
iniFile := Settings_rootFolder . "\settings.ini" ; the main settings file used by most of the buttonpusherKB scripts
IniRead, Location_currentSystemLocation, %iniFile%, Location, currentSystemLocation
IniRead, xposP, %inifile%, Settings, TCDisplayXpos
IniRead, yposP, %inifile%, Settings, TCDisplayYpos

;===== END OF AUTO-EXECUTE =====================================================================

;===== MODIFIER MEMORY HELPER ==================================================================
; combine below with key and '::' to define hotkey
; e.g.- ^f1::Msgbox You pressed Control and F1
; #=Win | !=Alt | ^=Ctrl | +=Shift | &=combine keys | *=ignore other mods
; <=use left mod key| >=use right mod key  | UP=fires on release

;===== MAIN HOTKEY DEFINITIONS HERE ============================================================

;===== DAVINCI RESOLVE HOTKEY DEFINITIONS HERE ============================================

#IfWinActive, ahk_exe Resolve.exe

F16:: ; < -- Left Click holder. This will allow you to use the scroll wheel to adjust a parameter

Return

#!^+F21:: ; < -- The Resolve location grabbing subroutine
; (To use this sub, the cursor should be positioned over the button/location/command you wish to grab before invoking it)

MouseGetPos currentCursorX, currentCursorY ; store the current cursor coords to currentCursorX and currentCursorY

; display an input box with the contents of the clipboard pre-populated in the entry field
InputBox, processLoc, Grabbing %Clipboard%, Is this the button/location/command you are grabbing?,,,,,,,,%Clipboard%

If ErrorLevel
    Return ; if user selects CANCEL, exit this subroutine
else ; the below will be processed if user presses OK
currentButtonName := processLoc ; puts the value we are grabbing into this variable
current1ShotScriptName := currentButtonName . ".ahk" ; appends the ".ahk" to create the script filename
oneshotPathName := "oneshots\" ; this is the path where we will find the 1-shot scripts
full1ShotScriptPath := "" . oneshotPathName . current1ShotScriptName . "" ; this creates the full path *without* quotes
quotedPath := """" . full1ShotScriptPath . """" ; this creates the full path *with* quotes
if !FileExist(full1ShotScriptPath) ; if the script file doesn't exist, create it
{
FileCopy, BKB-RESOLVE-1-SHOT-TEMPLATE.ahk, %full1ShotScriptPath% ; this will copy from the template to the specific script named in full1ShotScriptPath for this currentButtonName
ToolTip ,The script did not exist.`nIt has been created at:`n%full1ShotScriptPath%
RemoveToolTip(2000)
}

WinActivate, RESOLVE-1SHOT-CONFIG.ahk ; this should activate the window where the config file is being edited

; below will create the info we will want to paste into the config file
formattedText =
(
; Loc %Location_currentSystemLocation% %currentButtonName%
%currentButtonName%LocX = %currentCursorX%
%currentButtonName%LocY = %currentCursorY%
)
clipboard = %formattedText%
; below we define the comment text to search for
seekText =
(
; Loc %Location_currentSystemLocation% %currentButtonName%
)
; these send commands will perform a replace on the seekText comment and replace it with formattedText
Sleep, sleepShort
Send, ^h
Sleep, sleepShort
Send, +{Tab}
Sleep, sleepShort
Send, %seekText%
Sleep, sleepShort
Send, {Tab}
Sleep, sleepShort
Send, ^v
Sleep, sleepShort
Send, !r
Sleep, sleepMedium
Send, {Escape}{Escape}
Sleep, sleepShort
Send, {Left}{Down}{Down}{Down}
Sleep, sleepShort
Send, ^{Right}^{Right}^{Right}
Sleep, sleepShort
Send, ^s
ToolTip, Saved location info for %currentButtonName%
RemoveToolTip(5000)

; prompt to open the referred 1shot script for editing
;MsgBox,4, Edit new script?, Do you need to adjust or edit the new script at %full1ShotScriptPath%, 4
;IfMsgBox No
;    Return
;Run, edit %quotedPath%
;Sleep, sleepMedium
;Send, {Escape}
Return
#IfWinActive

;===== END Program 1 DEFINITIONS ===============================================================

;===== FUNCTIONS ===============================================================================
