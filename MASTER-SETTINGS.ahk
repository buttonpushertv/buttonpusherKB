; AutoHotKey - MASTER-SETTINGS for MASTER-SCRIPT
; by Ben Howard - ben@buttonpusher.tv
; based on an example given in this post:
; https://autohotkey.com/board/topic/19650-auto-readload-and-save-an-ini-file-updated/

;===== START OF AUTO-EXECUTION SECTION =========================================================
;
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force ; Ensures that there is only a single instance of this script running.
;
;===== INITIALIZATION - VARIABLES ==============================================================
; Sleep shortcuts - use these to standardize sleep times
sleepMicro := 5
sleepMini := 15
sleepShort := 333
sleepMedium := 666
sleepLong := 1500
sleepDeep := 3500

#Include MASTER-FUNCTIONS.ahk

;===== END OF AUTO-EXECUTE =====================================================================
;===== MAIN HOTKEY DEFINITIONS HERE ============================================================

; This section will Initialize & Load the settiings from %inifile%
; code is commented below
inifile = settings.ini

INI_Init(inifile)
INI_Load(inifile)

;Creating the Main GUI for the app - the bit that loads inititally when run
;setting width variables
guiWidth := 660
guiElementWidth := (guiWidth - 20)
;figuring out how tall the whole GUI will be
keyRows := (section1_keys - 1)
keyRows += (section2_keys / 3)
guiHeight := (keyRows * 30)
guiHeight += 180 ; this is to add the bit at the bottom for the buttons, text
buttonStartingY := (guiHeight - 80)

;Section 1 - System Location
sectionGroupH := (section1_keys - 1)
currentAltCounter := 1
Gui, Font, S12 CDefault, Franklin Gothic Medium
Gui, Add, GroupBox, R%sectionGroupH% x10 y10 w300 , System Location
Gui, Font, S10 CDefault, Franklin Gothic Medium
Gui, Add, Text, x330 y20 w280, Select a Location at the left. This can be used to provide location specific settings.`n`nBelow, check the boxes for the scripts you'd like to launch when running MASTER-SCRIPT.ahk.
Gui, Font, S12 CDefault, Franklin Gothic Medium
Gui, Add, Text, section x10 y10,
loop, %section1_keys%
  {
    if (A_Index = 1) {
      Continue
    }
    currentAltCounter := (A_Index - 1)
    currentKey := % section1_key%A_Index%
    currentKeyValue := % %section1%_%currentKey%
    currentKeyValueForRadio := "Location" . currentAltCounter . " > " . currentKeyValue
    if (currentAltCounter = Location_currentSystemLocation)
      Gui, Add, Radio, xs+20 vLocRadioGroup%currentAltCounter% Checked, %currentKeyValueForRadio%
    else
      Gui, Add, Radio, xs+20 vLocRadioGroup%currentAltCounter%, %currentKeyValueForRadio%
  }

;Section 2 - Scripts To Run
sectionGroupH := (section2_keys / 3)
currentAltCounter := 1
Gui, Add, GroupBox, R%sectionGroupH% x10 yp+50 w630 , Scripts to Load
Gui, Add, Text, section xp yp+10,
loop, %section2_keys%
  {
    currentKey := % section2_key%A_Index%
    pathLookAhead := A_Index + 1
    nameLookAhead := A_Index + 2
    pathKey := % section2_key%pathLookAhead%
    nameKey := % section2_key%nameLookAhead%
    currentKeyValue := %section2%_%currentKey%
    currentPathValue := %section2%_%pathKey%
    currentNameValue := %section2%_%nameKey%
    currentKeyLeft7 := SubStr(currentKey, 1, 7)
    If (currentKeyLeft7 = "loadScr"){
      scriptCheckboxEnable%A_Index% = %currentKeyValue%
      Gui, Add, Checkbox, xs+20 yp+20 vscriptCheckboxEnable%currentAltCounter% Checked%currentKeyValue%, %currentPathValue%
      currentAltCounter += 1
      pathKey :=
	  nameKey :=
      currentKeyValue :=
      currentPathValue :=

    }
    else
      Continue
  }

Gui, Font, S12 CDefault, Franklin Gothic Medium
Gui, Add, Button, x30 y%buttonStartingY% w100 h30, Add Script
Gui, Add, Button, x400 y%buttonStartingY% w100 h30, Cancel
Gui, Add, Button, x520 yp w100 h30, SAVE
Gui, Font, S10 CDefault, Franklin Gothic Medium
Gui, Add, Text, x30 yp+40 w650, Clicking 'SAVE' will save the settings above and reload MASTER-SCRIPT.ahk and the checked scripts above.
;Gui, Add, Button, x400 yp+32 w220 h20, Variables ; Uncomment if you wish to have a button to show Variables assigned by the script
Gui, Show, w%guiWidth% h%guiHeight%
return

ButtonVariables:
Listvars
return

ButtonAddScript:
InputBox, newScriptNameValue, Name or Description, Enter a Name or Description for the new app.
InputBox, newScriptPathValue, File Path, Enter the full path to the new script.`n(include path relative to %A_ScriptName%`nwhich is located in %A_ScriptDir%)
if (!newScriptPathValue) {
  MsgBox You must enter, at least, a path to an app. Please try again.
  return
  }
numberOfKeySets := round(section2_keys / 3)
newNumberOfKeySets := (numberOfKeySets + 1)
newScriptEnableKey := (section2_keys + 1)
newScriptPathKey := (section2_keys + 2)
newScriptNameKey := (section2_keys + 3)
section2_key%newScriptEnableKey% := "loadScript" . newNumberOfKeySets
section2_key%newScriptPathKey% := "pathScript" . newNumberOfKeySets
section2_key%newScriptNameKey% := "nameScript" . newNumberOfKeySets
Scripts_loadScript%newNumberOfKeySets% := 1
Scripts_pathScript%newNumberOfKeySets% := newScriptPathValue
Scripts_nameScript%newNumberOfKeySets% := newScriptNameValue
section2_keys += 3
INI_Save(inifile)
reload
return

ButtonSAVE:
Gui, Submit
;Setting the location if it got changed
loop, %section1_keys%
  {
    if (A_Index = 1)
      Continue
    currentAltCounter := (A_Index - 1)
    currentRadioGroup := % LocRadioGroup%currentAltCounter%
    if LocRadioGroup%currentAltCounter%
      Location_currentSystemLocation = %currentAltCounter%
  }
;Setting Scripts_loadScriptX to new values
currentAltCounter := 1
loop, %section2_keys%
  {
  if mod(A_Index,2) {
    Scripts_loadScript%currentAltCounter% = % scriptCheckboxEnable%currentAltCounter%
    currentAltCounter += 1
  }
  else
    Continue
  }
INI_Save(inifile)
;Reload ;uncomment to reload immed. after save - to check what it saved
splashScreenSpacing := 75
splashScreenStartY := 100
splashScreenStartX := 100
DetectHiddenWindows, On
SetTitleMatchMode, 2
loop, %section2_keys%
{
    currentKey := % section2_key%A_Index%
    pathLookAhead := A_Index + 1
    pathKey := % section2_key%pathLookAhead%
    currentKeyValue := %section2%_%currentKey%
    currentPathValue := %section2%_%pathKey%
        currentPathSlashPos := InStr(currentPathValue, "\")
        currentPathResolvedName := SubStr(String, currentPathSlashPos + 1)
        currentKeyLeft7 := SubStr(currentKey, 1, 7)
    If (currentKeyLeft7 = "loadScr") {
        If (currentKeyValue) {
            SplashTextOn, 600, 50, Quitting AHK scripts, Quitting %currentPathValue%
            WinMove, Quitting AHK scripts, , %splashScreenStartX%, %splashScreenStartY%
            WinClose, %currentPathValue%
            splashScreenStartY += splashScreenSpacing
        pathKey :=
        currentKeyValue :=
        currentPathValue :=
            }
        }
    else {
    Continue
    }
}
    SplashTextOn, 600, 50, Quitting AHK scripts, All MASTER-SCRIPT.AHK shut down.`nGoodbye & thanks for all the fishes...
    WinMove, Quitting AHK scripts, , %splashScreenStartX%, %splashScreenStartY%
    Sleep, sleepMedium
    SplashTextOff
    WinClose, MASTER-SCRIPT.ahk
Run, "MASTER-SCRIPT.ahk" ; forcing the MASTER-SCRIPT.ahk to reload. Since '#SingleInstance force' is defined in MASTER-SCRIPT.ahk, by just running the script again will reload it.
Gui, Destroy
ExitApp
return

ButtonCancel:
GuiClose:
GuiEscape:
ExitApp

;===== FUNCTIONS ===============================================================================
Quitting:
