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
SetTitleMatchMode, 2 ; sets title matching to search for "containing" instead of "exact"

FileEncoding, UTF-8 ; this is here to make sure any files that we need to work with get created/opened/read as UTF-8

;===== INITIALIZATION - VARIABLES ==============================================================
; Sleep shortcuts - use these to standardize sleep times
sleepMicro := 5
sleepMini := 15
sleepShort := 333
sleepMedium := 666
sleepLong := 1500
sleepDeep := 3500

#Include %A_ScriptDir%\MASTER-FUNCTIONS.ahk

;===== END OF AUTO-EXECUTE =====================================================================

;===== MAIN HOTKEY DEFINITIONS HERE ============================================================
inifile = settings.ini

INI_Init(inifile)
INI_Load(inifile)

global readSettings_TimeoutPeriod := Settings_timeoutPeriod

; It seems that sometimes the BKB-Startup.ahk get stuck exiting or doesn't quit where it supposed to. This code block should see it and close it.
DetectHiddenWindows, On
BKBstartupPath := "BKB-startup"
IfWinExist,,%BKBstartupPath%
{
	MsgBox, 262144,, Found %BKBstartupPath%
	WinClose, %BKBstartupPath%
}
DetectHiddenWindows, Off


; this little section detects if the MASTER-SCRIPT.ahk is already running. That would be a sign that this launcher may have already been run. Since we don't usually want to run this launcher a second time (while the apps it launches are already running) we will set the timeout period to something very high so you have time to interact with the GUI and not have it quickly launch everything over again. ("OVER 9000!")
SetTitleMatchMode, 2
DetectHiddenWindows, On
if WinExist("MASTER-SCRIPT.ahk") {
  Settings_timeoutPeriod := 9600000
  timeoutSegments := Round(Settings_timeoutPeriod / 1000)
  Tooltip, MASTER-SCRIPT.ahk IS ALREADY RUNNING.`nThe timeout is set to %timeoutSegments% seconds temporarily.`nQuit all checked apps `& scripts to reset timeout period.
  RemoveTooltip(4000)
}


;Creating the Main GUI for the app - the bit that loads inititally when run
;setting width variables
guiWidth := 640
guiElementWidth := (guiWidth - 20)
;figuring out how tall the whole GUI will be
keyRows := (section3_keys / 3)
guiElementHeight := (keyRows * 20) + 40
guiHeight := (guiElementHeight + 200) ; this is to add the bit at the bottom for the buttons, text ,and progress bar timer
If (guiHeight < 299) {
	guiHeight := 300
}
buttonStartingY := (guiHeight - 150)

;MSGBOX, guiHeight: %guiHeight%`nkeyRows: %keyRows%`nbuttonStartingY: %buttonStartingY%`nguiElementHeight: %guiElementHeight%

;Section 1 - System Location
currentSystemLocation = % Location_systemLocation%Location_currentSystemLocation%
Gui, Color, FFFFFF
Gui, Add, Picture, x0 y15, SUPPORTING-FILES\BPS-Logo-PLUS-KB-100x115.png
Gui, Add, Text, x110 y10 hidden section
Gui, Font, S10 CDefault, %Settings_guiFont%
Gui, Add, Text, xs ys , Current Selected System Location: %currentSystemLocation%
Gui, Font, S8 CDefault, %Settings_guiFont%
Gui, Add, Text, xs yp+15, (This can be changed via MASTER-SETTINGS.AHK - see button below)
Gui, Font, S12 CDefault, %Settings_guiFont%

;Section 2 - Scripts To Run
;THIS SECTION IS SKIPPED FOR THE LAUNCHER. It is used by MASTER-SCRIPT.AHK to launch child AHK scripts.

;Section 3 - Apps To Run - adding these elements to the GUI
section3GroupH := (keyRows)
currentAltCounter := 1
Gui, Font, S10 CDefault bold, %Settings_guiFont%
Gui, Add, GroupBox, xs yp+20 w%guiElementWidth% h%guiElementHeight%, Apps to Load
Gui, Font, S10 CDefault norm, %Settings_guiFont%
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
Gui, Font, S8 CDefault, %Settings_guiFont%
Gui, Add, Button, x10 y%buttonStartingY% w120 h50, &Add App
Gui, Add, Button, xp+125 yp w120 h50, &Delete App
Gui, Add, Button, xp+125 yp w120 h50, &Launch MASTER-SETTINGS
Gui, Add, Button, xp+125 yp w120 h50, Change &Timeout
Gui, Add, Button, xp+125 yp w120 h50, &Save Changes
timeoutSegments := Round(Settings_timeoutPeriod / 1000)
timeoutText1 := "Launching Apps in " . timeoutSegments . " seconds."
timeoutText2 := "Launching in:"
timeoutRemaining := timeoutSegments
Gui, Font, S8 CDefault, %Settings_guiFont%
Gui, Add, Text, x45 yp+55, %timeoutText1% ; timer bar related
Gui, Add, Text, xp+200 yp vtimeoutText, %timeoutText2% ; timer bar related
Gui, Add, Text, xp+75 yp w25 vtimeoutTextProgress ; timer bar related
Gui, Font, S8 CDefault bold, %Settings_guiFont%
Gui, Add, Text, xp+75 yp, Press ESC to Cancel.
Gui, Font, S12 CDefault norm, %Settings_guiFont%
Gui, Add, Progress, x10 yp+20 w%guiElementWidth% h20 cGreen BackgroundNavy Range0-%timeoutSegments% vtimeoutProgress ; this line draws the timer bar
Gui, Font, S12 CDefault bold, %Settings_guiFont%
Gui, Add, Button, Default x10 yp+30 w%guiElementWidth% h30, Launch Apps &Now
;guiHeight += 75
;Gui, Add, Button, x10 yp+40 w430 h30, Variables
Gui, Show, w%guiWidth% h%guiHeight%

;timer code section here
;the timeout period is stored in settings.ini - under the [Settings] section as milliseconds - other values designated in above GUI code
launcherTimeoutSleep := 1000 ; this value sets the duration between bar segment advances to 1 second

;this code block creates and updates the timer text & progress bar
loop, %timeoutSegments%
  {
  GuiControl, , timeoutTextProgress, %timeoutRemaining%
  sleep, launcherTimeoutSleep
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
            Run, %currentPathValue% %A_ScriptDir%
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

If (Settings_timeoutPeriod != readSettings_TimeoutPeriod) {
  Settings_timeoutPeriod := readSettings_TimeoutPeriod
}

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
launcherTimeoutSleep := 10000
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
launcherTimeoutSleep := 10000
delTimeoutRemain := (timeoutRemaining * 10)
delAppGUIH := 40
appSectionKeys := round(section3_keys / 3)
delAppGUIH += (appSectionKeys * 60)
delAppGUIW := 580
delAppLVH := (delAppGUIH - 60)
delAppLVW := 560

Gui, DelApp:New, , Delete an App
Gui, DelApp:Font, S12 CDefault, %Settings_guiFont%
Gui, DelApp:Add, Text, x10 y10 , Double-click the app you would like to remove below:
Gui, DelApp:Font, S9 CDefault, %Settings_guiFont%
Gui, DelApp:Add, Text, x10 y30 , (You have about %delTimeoutRemain% seconds to make a choice.)
Gui, DelApp:Font, S12 CDefault, %Settings_guiFont%
Gui, DelApp:Add, ListView, r%appSectionKeys% w%delAppLVW% h%delAppLVH% gdelListView, #|App|Enabled?

loop, %appSectionKeys%
  {
    LV_Add(,A_Index, Apps_nameApp%A_Index%, Apps_loadApp%A_Index% )
  }
LV_ModifyCol(2)
Gui, DelApp:Show, w580 h%delAppGUIH%

delListView:
if (A_GuiEvent = "DoubleClick")
  {
    LV_GetText(RowText, A_EventInfo)
    appToDel := % Apps_nameApp%A_EventInfo%  ; Get the text from the row's first field.
    MsgBox, 36, Delete this App?, Is this the app you want to delete?`n#%A_EventInfo%: %appToDel%
    IfMsgBox, No
      goto delAppNo
    IfMsgBox, Yes
      newNumberOfKeySets := (section3_keys - 3)
      currentAltCounter := 1
      Loop, %appSectionKeys%
      {
        If (A_Index = A_EventInfo) {
          Continue
        }
        tempApps_loadApp%currentAltCounter% := % Apps_loadApp%A_Index%
        tempApps_nameApp%currentAltCounter% := % Apps_nameApp%A_Index%
        tempApps_pathApp%currentAltCounter% := % Apps_pathApp%A_Index%
        currentNameValue := % tempApps_nameApp%currentAltCounter%
        currentPathValue := % tempApps_pathApp%currentAltCounter%
        currentLoadValue := % tempApps_loadApp%currentAltCounter%
        currentAltCounter += 1
      }
      Loop, %section2_keys%
      {
        Apps_loadApp%A_Index% := % tempApps_loadApp%A_Index%
        Apps_nameApp%A_Index% := % tempApps_nameApp%A_Index%
        Apps_pathApp%A_Index% := % tempApps_pathApp%A_Index%
      }
      Apps_loadApp%appSectionKeys% := 0
      Apps_nameApp%appSectionKeys% :=
      Apps_pathApp%appSectionKeys% :=
      IniDelete, %inifile%, Apps, loadApp%appSectionKeys%
      IniDelete, %inifile%, Apps, nameApp%appSectionKeys%
      IniDelete, %inifile%, Apps, pathApp%appSectionKeys%
      appSectionKeys -= 1
      Loop, %appSectionKeys%
      {
        currentLoadValue := % Apps_loadApp%A_Index%
        currentNameValue := % Apps_nameApp%A_Index%
        currentPathValue := % Apps_pathApp%A_Index%
        IniWrite, %currentLoadValue%, %inifile%, Apps, loadApp%A_Index%
        IniWrite, %currentNameValue%, %inifile%, Apps, nameApp%A_Index%
        IniWrite, %currentPathValue%, %inifile%, Apps, pathApp%A_Index%
      }
      delAppNo:
      Gui, DelApp:Destroy
      reload
  }
return

ButtonChangeTimeout:
InputBox, OutputVar, Change Timeout Delay, Set the amount of time to wait before launching checked apps.`n`n(Enter time in milliseconds. 6 seconds would be 6000ms, etc.)),,,,,,,%Settings_timeoutPeriod%
if OutputVar=                                 ;IF NONE IS SELECTED , RETURN
  return
Settings_timeoutPeriod := OutputVar
INI_Save(inifile)
reload
return

ButtonLaunchMaster-Settings:
  Run, %A_ScriptDir%\MASTER-SETTINGS.AHK ; runs the settings configuration script for the whole suite.
  ExitApp
return
;===== FUNCTIONS ===============================================================================
