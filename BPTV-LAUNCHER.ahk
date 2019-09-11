; AutoHotKey - LAUNCHER Script
; by Ben Howard - ben@buttonpusher.tv
; based on an example given in this post:
; https://autohotkey.com/board/topic/19650-auto-readload-and-save-an-ini-file-updated/

/*
I wanted a script that could launch a set of apps after a specified time.

It uses the same settings file that is created by MASTER-SETTINGS.ahk - so you can make use of the Location info (which system you're working on).

*/

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

#Include MASTER-FUNCTIONS.ahk

;===== END OF AUTO-EXECUTE =====================================================================

;===== MAIN HOTKEY DEFINITIONS HERE ============================================================
inifile = settings.ini

INI_Init(inifile)
INI_Load(inifile)

;Creating the Main GUI for the app - the bit that loads inititally when run
;setting width variables
guiWidth := 560
guiElementWidth := (guiWidth - 20)
;figuring out how tall the whole GUI will be
keyRows := (section3_keys / 3)
guiHeight := (keyRows * 30)
guiHeight += 240 ; this is to add the bit at the bottom for the buttons, text ,and progress bar timer
buttonStartingY := (guiHeight - 150)

;Section 1 - System Location
currentSystemLocation = % Location_systemLocation%Location_currentSystemLocation%
Gui, Font, S10 CDefault, Franklin Gothic Medium
Gui, Add, Text, x20 y10 , Current Selected System Location: %currentSystemLocation%
Gui, Font, S8 CDefault, Franklin Gothic Medium
Gui, Add, Text, xp yp+15, (This can be changed in MASTER-SETTINGS.AHK)
Gui, Font, S12 CDefault, Franklin Gothic Medium

;Section 2 - Scripts To Run
;THIS SECTION IS SKIPPED FOR THE LAUNCHER. It is used by MASTER-SCRIPT.AHK to launch child AHK scripts.

;Section 3 - Apps To Run - adding these elements to the GUI
section3GroupH := (keyRows)
currentAltCounter := 1
Gui, Add, GroupBox, R%section3GroupH% x10 yp+20 w%guiElementWidth% , Apps to Load
Gui, Add, Text, section xp yp+10,
loop, %section3_keys%
  {
    currentKey := % section3_key%A_Index%
    pathLookAhead := A_Index + 1
    nameLookAhead := A_Index + 2
    pathKey := % section3_key%pathLookAhead%
    nameKey := % section3_key%nameLookAhead%
    currentKeyValue := %section3%_%currentKey%
    currentPathValue := %section3%_%pathKey%
    currentNameValue := %section3%_%nameKey%
    currentKeyLeft7 := SubStr(currentKey, 1, 7)
    If (currentKeyLeft7 = "loadApp") {
      appCheckboxEnable%A_Index% = %currentKeyValue%
      Gui, Add, Checkbox, xs+20 yp+20 vappCheckboxEnable%currentAltCounter% Checked%currentKeyValue%, %currentNameValue%
      currentAltCounter += 1
      pathKey :=
	  nameKey :=
      currentKeyValue :=
      currentPathValue :=
      currentNameValue :=
    }
    else
      Continue
  }
Gui, Font, S8 CDefault, Franklin Gothic Medium
Gui, Font, S12 CDefault, Franklin Gothic Medium
Gui, Add, Button, x10 y%buttonStartingY% w100 h50, &Add App
Gui, Add, Button, xp+110 yp w100 h50, &Delete App
Gui, Add, Button, xp+110 yp w100 h50, &Edit`nsettings.ini
Gui, Add, Button, xp+110 yp w100 h50, Change &Timeout
Gui, Add, Button, xp+110 yp w100 h50, &Save Changes
timeoutSegments := Round(Settings_timeoutPeriod / 1000)
timeoutText := "Launching Apps in " . timeoutSegments . " seconds.        Launching in:                 Press ESC to Cancel."
timeoutRemaining := timeoutSegments
Gui, Font, S8 CDefault, Franklin Gothic Medium
Gui, Add, Text, x85 yp+55 vtimeoutText, %timeoutText%
Gui, Add, Text, x330 yp w25 vtimeoutTextProgress
Gui, Font, S12 CDefault, Franklin Gothic Medium
Gui, Add, Progress, x10 yp+20 w%guiElementWidth% h20 cGreen BackgroundNavy Range0-%timeoutSegments% vtimeoutProgress
Gui, Add, Button, Default x10 yp+30 w%guiElementWidth% h30, Launch Apps &Now
;guiHeight += 75
;Gui, Add, Button, x10 yp+40 w430 h30, Variables
Gui, Show, w%guiWidth% h%guiHeight%



;timer code section here
;the timeout period is stored in settings.ini - under the [Settings] section as milliseconds - other values designated in above GUI code

;this code creates and upadtes the timer text & progress bar
loop, %timeoutSegments%
  {
  GuiControl, , timeoutTextProgress, %timeoutRemaining%
  sleep, 1000
  GuiControl, , timeoutProgress, +1
  timeoutRemaining := (timeoutSegments - A_Index)
  }
  goto launchApps
return

launchApps:
loop, %section3_keys%
{
    currentKey := % section3_key%A_Index%
    pathLookAhead := A_Index + 1
    pathKey := % section3_key%pathLookAhead%
    currentKeyValue := %section3%_%currentKey%
    currentPathValue := %section3%_%pathKey%
    currentKeyLeft7 := SubStr(currentKey, 1, 7)
    If (currentKeyLeft7 = "loadApp") {
        If (currentKeyValue) {
            If !FileExist(currentPathValue) {
              MsgBox The App could not be found at %currentPathValue%
              continue
              }
            else {
            Run, %currentPathValue%
            Sleep, sleepMedium
            Continue
            }
          }
        else
            Continue
    pathKey :=
    currentKeyValue :=
    currentPathValue :=
    }
    else
    Continue
}
ExitApp
return

ButtonLaunchAppsNow:
goto launchApps
return

ButtonVariables:
Listvars
return

ButtonSaveChanges:
Gui, Submit
;Setting Scripts_loadScriptX to new values
currentAltCounter := 1
loop, %section3_keys%
  {
  if mod(A_Index,2) {
    Apps_loadApp%currentAltCounter% = % appCheckboxEnable%currentAltCounter%
    currentAltCounter += 1
  }
  else
    Continue
  }
INI_Save(inifile)
Gui, Destroy
Reload ;reloading after Save to launch the new set of enabled apps
return

GuiClose:
GuiEscape:
ExitApp
return

ButtonAddApp:
InputBox, newAppNameValue, Name or Description, Enter a Name or Description for the new app.
InputBox, newAppPathValue, File Path, Enter the full path to the new app.`n(include path relative to %A_ScriptName%`nwhich is located in %A_ScriptDir%)
if (!newAppPathValue) {
  MsgBox You must enter, at least, a path to an app. Please try again.
  return
  }
numberOfKeySets := round(section3_keys / 3)
newNumberOfKeySets := (numberOfKeySets + 1)
newAppEnableKey := (section3_keys + 1)
newAppPathKey := (section3_keys + 2)
newAppNameKey := (section3_keys + 3)
section3_key%newAppEnableKey% := "loadApp" . newNumberOfKeySets
section3_key%newAppPathKey% := "pathApp" . newNumberOfKeySets
section3_key%newAppNameKey% := "nameApp" . newNumberOfKeySets
Apps_loadApp%newNumberOfKeySets% := 1
Apps_pathApp%newNumberOfKeySets% := newAppPathValue
Apps_nameApp%newNumberOfKeySets% := newAppNameValue
section3_keys += 3
INI_Save(inifile)
reload
return

ButtonDeleteApp:
MsgBox Not implemented yet. Edit the settings.ini file to remove items for now.
return

ButtonChangeTimeout:
InputBox, OutputVar, Change Timeout Delay, Set the amount of time to wait before launching checked apps.`n`n(Enter time in milliseconds. 6 seconds would be 6000ms, etc.))
if OutputVar=                                 ;IF NONE IS SELECTED , RETURN
  return
Settings_timeoutPeriod := OutputVar
INI_Save(inifile)
reload
return

ButtonEditsettings.ini:
MsgBox, 262449, WARNING, You are opening the 'settings.ini' file in a text editor!`n`nThis file controls all aspects of how this set of scripts operates.`n`nPlease be very careful in here.`n`nIf you are going in to remove Apps or Scripts`, be sure to update the numbers after any items you delete (loadscript1, enableApp3, etc). Stuff will break if you don't.`n`nCANCEL to turn back...`n`nAfter exiting the text editor, this script will reload with your changes.
RunWait, notepad.exe settings.ini, %A_ScriptDir%, Max
Reload
return
;===== FUNCTIONS ===============================================================================
