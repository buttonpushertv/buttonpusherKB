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

FileEncoding, UTF-8 ; this is here to make sure any files that we need to work with get created/opened/read as UTF-8

#Include %A_ScriptDir%\MASTER-FUNCTIONS.ahk

;===== END OF AUTO-EXECUTE =====================================================================
;===== MAIN HOTKEY DEFINITIONS HERE ============================================================
global versionFile := "version.ini" ; the file which holds the current version of buttonpusherKB
global version ; creating a global variable for the version info
FileRead, version, %versionFile% ; reading the version from versionFile
global scriptRootFolder := A_ScriptDir ; sets the scriptRootFolder value to A_ScriptDir. This should then auto-set the rootFolder value in the settings.ini file. The idea here is that this should make it possible to change the name of the root folder where all of this gets installed and then it should propagate throughout the script.

global currentSelectedSystemLocation :=
global Location_currentSystemLocation :=
; This section will Initialize & Load the settiings from %inifile%
; code is commented below
inifile = settings.ini

INI_Init(inifile)
INI_Load(inifile)

;Creating the Main GUI for the app - the bit that loads inititally when run
;setting width variables
guiWidth := 980
halfGuiWidth := (guiWidth / 2)
quarterGuiWidth := (guiWidth / 4)
guiElementWidth := (halfGuiWidth - 25)
buttonElementWidth := (quarterGuiWidth - 25)
;figuring out how tall the whole GUI will be
section1H := (section1_keys - 1)
section2H := (section2_keys / 3)
section3H := (section3_keys / 3)
section4H := (section4_keys)
keyRows := section1H
keyRows += section2H
keyRows += section3H

guiRowPadding := 25
guiHeight := (keyRows * guiRowPadding)
guiHeight += 450 ; this is to add the bit at the bottom for the buttons, text
buttonStartingY := (guiHeight - 160)
buttonStartingX := quarterGuiWidth
global scriptSectionKeys := round(section2_keys / 3)
global appSectionKeys := round(section3_keys / 3)
global settingsSectionKeys := section4_keys

; for Section 4 - figuring out the longest setting value
longestSettingValue :=
loop, %section4_keys%{
  currentSettingName := % section4_key%A_Index%
  currentSettingValue := %section4%_%currentSettingName%
  CurrentLength := StrLen(currentSettingValue)
  If (CurrentLength > longestSettingValue) {
    longestSettingValue := CurrentLength
  }
}
section4EditBoxW := (longestSettingValue * 7)

;Section 1 - System Location
section1GroupH := (section1H +1.25)
currentAltCounter := 1
Gui, mainWindow:Font, S12 CDefault Bold, %Settings_guiFont%
Gui, mainWindow:Add, GroupBox, R%section1GroupH% x10 y10 w%guiElementWidth%, System Location
Gui, mainWindow:Add, Text, hidden section yp,
Gui, mainWindow:Font, S12 norm, %Settings_guiFont%
loop, %section1_keys%
  {
    if (A_Index = 1) {
      Continue
    }
    currentAltCounter := (A_Index - 1)
    currentKey := % section1_key%A_Index%
    currentKeyValue := % %section1%_%currentKey%
    currentKeyValueForRadio := "Location" . currentAltCounter . " > " . currentKeyValue
    if (currentAltCounter = Location_currentSystemLocation) {
      Gui, mainWindow:Add, Radio, xs+20 yp+25 vLocRadioGroup%currentAltCounter% Checked, %currentKeyValueForRadio%
      global currentSelectedSystemLocation := currentKeyValue
    } else
      Gui, mainWindow:Add, Radio, xs+20 yp+25 vLocRadioGroup%currentAltCounter%, %currentKeyValueForRadio%
  }
  Gui, mainWindow:Font, S10 CDefault, %Settings_guiFont%
  Gui, mainWindow:Add, Text, xp yp+30, Select a Location on the left.`nThis can be used to provide location specific settings.
  Gui, mainWindow:Font, S12 CDefault, %Settings_guiFont%

;Section 2 - Scripts To Run
section2GroupH := (section2H - 1)
currentAltCounter := 1
Gui, mainWindow:Font, S12 CDefault Bold, %Settings_guiFont%
Gui, mainWindow:Add, GroupBox, R%section2GroupH% x10 yp+60 w%guiElementWidth%, Scripts to Load (loaded via MASTER-SCRIPT.ahk)
Gui, mainWindow:Add, Text, hidden section xp yp,
Gui, mainWindow:Font, S12 norm, %Settings_guiFont%
loop, %section2_keys%
  {
    scriptCheckboxEnable%A_Index% := 0
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
      scriptCheckboxEnable%A_Index% := currentKeyValue
      Gui, mainWindow:Add, Checkbox, xs+20 yp+25 vscriptCheckboxEnable%currentAltCounter% Checked%currentKeyValue%, %currentNameValue%
      currentAltCounter += 1
      pathKey :=
	  nameKey :=
      currentKeyValue :=
      currentPathValue :=

    }
    else
      Continue
  }

;Section 3 - Apps To Load
section3GroupH := (section3H + 2)
currentAltCounter := 1
Gui, mainWindow:Font, S12 CDefault Bold, %Settings_guiFont%
Gui, mainWindow:Add, GroupBox, R%section3GroupH% x10 yp+50 w%guiElementWidth%, Apps to Load (loaded via BKB-LAUNCHER.ahk*)
Gui, mainWindow:Add, Text, hidden section xp yp,
Gui, mainWindow:Font, S12 norm, %Settings_guiFont%
loop, %section3_keys%
    {
      appCheckboxEnable%A_Index% := 0
      currentKey := % section3_key%A_Index%
      pathLookAhead := A_Index + 1
      nameLookAhead := A_Index + 2
      pathKey := % section3_key%pathLookAhead%
      nameKey := % section3_key%nameLookAhead%
      currentKeyValue := %section3%_%currentKey%
      currentPathValue := %section3%_%pathKey%
      currentNameValue := %section3%_%nameKey%
      currentKeyLeft7 := SubStr(currentKey, 1, 7)
      If (currentKeyLeft7 = "loadApp"){
        appCheckboxEnable%A_Index% := currentKeyValue
        Gui, mainWindow:Add, Checkbox, xs+20 yp+25 vappCheckboxEnable%currentAltCounter% Checked%currentKeyValue%, %currentNameValue%
        currentAltCounter += 1
        pathKey :=
  	  nameKey :=
        currentKeyValue :=
        currentPathValue :=

      }
      else
        Continue
    }
paddedGuiElementWidth := guiElementWidth - 50
Gui, mainWindow:Font, S8 CDefault, %Settings_guiFont%
Gui, mainWindow:Add, Text, x30 yp+30 w%paddedGuiElementWidth%, *-App enabling/disabling will take effect when BKB-LAUNCHER is relaunched. Changes made here will be saved. All enabled and/or open apps should be closed before relaunching BKB-LAUNCHER.

Gui, mainWindow:Font, S12 CDefault, %Settings_guiFont%
spacing := 25
buttonPadding := buttonElementWidth + spacing
;Gui, mainWindow:Add, Button, x520 yp w100 h30, Variables ; Uncomment if you wish to have a button to show Variables assigned by the script
Gui, mainWindow:Add, Button, x%buttonStartingX% y%buttonStartingY% w%buttonElementWidth% h30, &Manage Scripts
Gui, mainWindow:Add, Text, hidden xp+%buttonPadding%
Gui, mainWindow:Add, Button, xp y%buttonStartingY% w%buttonElementWidth% h30, Manage &Apps
Gui, mainWindow:Add, Button, x%buttonStartingX% yp+32 w%buttonElementWidth% h30, &Cancel
Gui, mainWindow:Add, Text, hidden xp+%buttonPadding%
Gui, mainWindow:Add, Button, xp yp w%buttonElementWidth% h30, &SAVE
Gui, mainWindow:Font, S12 CDefault Bold, %Settings_guiFont%
Gui, mainWindow:Add, Button, x%buttonStartingX% yp+32 w%guiElementWidth% h30, SAVE AND &RELAUNCH MASTER-SCRIPT
Gui, mainWindow:Font, S10 CDefault norm, %Settings_guiFont%
Gui, mainWindow:Add, Text, x%buttonStartingX% yp+32 w%guiElementWidth%, Clicking 'SAVE' will just save the settings above and reload this panel.`nClick 'SAVE AND RELAUNCH MASTER-SCRIPT' to save and relaunch all the checked scripts and exit this panel.

; Section 4 - Other Settings
section4GroupH := (section4H *1.6)
Gui, mainWindow:Font, S12 CDefault Bold, %Settings_guiFont%
Gui, mainWindow:Add, GroupBox, R%section4GroupH% x%halfGuiWidth% y10 w%guiElementWidth%,Other Settings
Gui, mainWindow:Font, S10 norm
Gui, mainWindow:Add, Text, hidden section xp yp Center,
loop, %section4_keys%
    {
      currentSettingName := % section4_key%A_Index%
      currentSettingValue := %section4%_%currentSettingName%
      Gui, mainWindow:Add, Text, xs+50 yp+25, %currentSettingName%:
      Gui, mainWindow:Add, Edit, yp+20 h25 w%section4EditBoxW% Right vnewSettingValue%A_Index%, %currentSettingValue%
      currentSettingName :=
      currentSettingValue :=
    }

Gui, mainWindow:Show, w%guiWidth% h%guiHeight%
Gui, mainWindow:Default
return

mainWindowButtonVariables:
Listvars
return

mainWindowButtonManageScripts:
	manageScriptsGUIH := (scriptSectionKeys * 50) + 40
	manageScriptsGUIW := 880
	manageScriptsLVH := (manageScriptsGUIH - 130)
	manageScriptsLVW := 850

	Gui, manageScripts:New, , Manage Scripts
	Gui, manageScripts:Font, S12 CDefault, %Settings_guiFont%
	Gui, manageScripts:Add, Text, , Current Script Order:
	Gui, manageScripts:Add, ListView, x15 r%scriptSectionKeys% w%manageScriptsLVW% h%manageScriptsLVH% gmanageScriptsLVevent -ReadOnly, Script|Enabled?|Path
	Gui, manageScripts:Font, S10 CDefault, %Settings_guiFont%
	Gui, manageScripts:Add, Text, yp+%manageScriptsLVH% , SORT: Click Column Headers (2nd click to reverse order)`nEDIT NAME: Select Script `& press F2.`nEDIT PATH: Right-Double-Click on Script
	Gui, manageScripts:Add, Text, x440 yp , ADD SCRIPT: Use 'Add Script' button below.`nDELETE SCRIPT: Double-click individual Script name then confirm deletion.`nCANCEL: Press Escape.
	Gui, manageScripts:Font, S12 CDefault, %Settings_guiFont%
	Gui, manageScripts:Add, Button, x15 yp+55 w100 h30 gmanageScriptsAddScript, &Add Script
	Gui, manageScripts:Add, Button, x635 yp w100 h30, &Cancel
	Gui, manageScripts:Add, Button, x765 yp w100 h30 gmanageScriptsSaveSorted, &Save Sorted
	loop, %scriptSectionKeys%
	  {
		LV_Add(,Scripts_nameScript%A_Index%, Scripts_loadScript%A_Index%, Scripts_pathScript%A_Index%)
	  }
	LV_ModifyCol(1)
	Gui, manageScripts:Show, w%manageScriptsGUIW% h%manageScriptsGUIH%
	return

manageScriptsLVevent:
	if (A_GuiEvent = "ColClick") {
	Loop, %scriptSectionKeys%
	{
		LV_GetText(new_name, A_Index, 1)
		LV_GetText(new_enabled, A_Index, 2)
		LV_GetText(new_path, A_Index, 3)
		Scripts_loadScript%A_Index% := new_enabled
		Scripts_nameScript%A_Index% := new_name
		Scripts_pathScript%A_Index% := new_path
	}
	}
	if (A_GuiEvent = "DoubleClick") {
	LV_GetText(RowText, A_EventInfo)
    scriptToDel := % Scripts_nameScript%A_EventInfo%  ; Get the text from the row's first field.
    MsgBox, 36, Delete this Script?, Is this the script you want to delete?`n#%A_EventInfo%: %scriptToDel%
    IfMsgBox, No
      goto delScriptNo
    IfMsgBox, Yes
      newNumberOfKeySets := (section2_keys - 3)
      currentAltCounter := 1
      Loop, %scriptSectionKeys%
      {
        If (A_Index = A_EventInfo) {
          Continue
        }
        tempScripts_loadScript%currentAltCounter% := % Scripts_loadScript%A_Index%
        tempScripts_nameScript%currentAltCounter% := % Scripts_nameScript%A_Index%
        tempScripts_pathScript%currentAltCounter% := % Scripts_pathScript%A_Index%
        currentNameValue := % tempScripts_nameScript%currentAltCounter%
        currentPathValue := % tempScripts_pathScript%currentAltCounter%
        currentLoadValue := % tempScripts_loadScript%currentAltCounter%
        currentAltCounter += 1
      }
      Loop, %scriptSectionKeys%
      {
        Scripts_loadScript%A_Index% := % tempScripts_loadScript%A_Index%
        Scripts_nameScript%A_Index% := % tempScripts_nameScript%A_Index%
        Scripts_pathScript%A_Index% := % tempScripts_pathScript%A_Index%
      }
      Scripts_loadScript%scriptSectionKeys% := 0
      Scripts_nameScript%scriptSectionKeys% :=
      Scripts_pathScript%scriptSectionKeys% :=
      IniDelete, %inifile%, Scripts, loadScript%scriptSectionKeys%
      IniDelete, %inifile%, Scripts, nameScript%scriptSectionKeys%
      IniDelete, %inifile%, Scripts, pathScript%scriptSectionKeys%
      scriptSectionKeys -= 1
      Loop, %scriptSectionKeys%
      {
        currentLoadValue := % Scripts_loadScript%A_Index%
        currentNameValue := % Scripts_nameScript%A_Index%
        currentPathValue := % Scripts_pathScript%A_Index%
        IniWrite, %currentLoadValue%, %inifile%, Scripts, loadScript%A_Index%
        IniWrite, %currentNameValue%, %inifile%, Scripts, nameScript%A_Index%
        IniWrite, %currentPathValue%, %inifile%, Scripts, pathScript%A_Index%
      }
	  reload
      delScriptNo:
      return
	}
	If (A_GuiEvent = "R") {
		LV_GetText(pathToEdit, A_EventInfo, 3)
		InputBox, newScriptPathValue, Edit File Path, Enter the full path to the new script.`n(include path relative to %A_ScriptName%`nwhich is located in %A_ScriptDir%),,,,,,,,%pathToEdit%
		Scripts_pathScript%A_EventInfo% := newScriptPathValue
    INI_Save(inifile)
		Gui, manageScripts:Destroy
    Gui, mainWindow:Default
		Goto mainWindowButtonManageScripts
	return
	}
	return

manageScriptsGuiEscape:
manageScriptsButtonCancel:
	Gui, manageScripts:Destroy
  Gui, mainWindow:Default
	return

manageScriptsAddScript:
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

manageScriptsEditPath:
	LV_GetText(pathToEdit, A_EventInfo, 3)
	InputBox, newScriptPathValue, Edit File Path, Enter the full path to the new script.`n(include path relative to %A_ScriptName%`nwhich is located in %A_ScriptDir%),,,,,,,,%pathToEdit%
  LV_Modify(A_EventInfo, ,,,newScriptPathValue)
	return

manageScriptsSaveSorted:
    INI_Save(inifile)
    Gui, manageScripts:Destroy
    Gui, mainWindow:Default
    return

mainWindowButtonManageApps:
   	manageAppsGUIH := (appSectionKeys * 50) + 150
   	manageAppsGUIW := 880
   	manageAppsLVH := (manageAppsGUIH - 130)
   	manageAppsLVW := 850

   	Gui, manageApps:New, ,Manage Apps
   	Gui, manageApps:Font, S12 CDefault, %Settings_guiFont%
   	Gui, manageApps:Add, Text, , Current App Order:
   	Gui, manageApps:Add, ListView, x15 r%appSectionKeys% w%manageAppsLVW% h%manageAppsLVH% gmanageAppsLVevent -ReadOnly, App|Enabled?|Path
   	Gui, manageApps:Font, S10 CDefault, %Settings_guiFont%
   	Gui, manageApps:Add, Text, yp+%manageAppsLVH% , SORT: Click Column Headers (2nd click to reverse order)`nEDIT NAME: Select App `& press F2.`nEDIT PATH: Right-Double-Click on App
   	Gui, manageApps:Add, Text, x440 yp , ADD App: Use 'Add App' button below.`nDELETE App: Double-click individual App name then confirm deletion.`nCANCEL: Press Escape.
   	Gui, manageApps:Font, S12 CDefault, %Settings_guiFont%
   	Gui, manageApps:Add, Button, x15 yp+55 w100 h30 gmanageAppsAddApp, &Add App
   	Gui, manageApps:Add, Button, x635 yp w100 h30, &Cancel
   	Gui, manageApps:Add, Button, x765 yp w100 h30 gmanageAppsSaveSorted, &Save Sorted
    Gui, manageApps:Default
   	loop, %appSectionKeys%
   	  {
        currentAppsLoadValue := % Apps_loadApp%A_Index%
        currentAppsNameValue := % Apps_nameApp%A_Index%
        currentAppsPathValue := % Apps_pathApp%A_Index%
        LV_Add(,currentAppsNameValue, currentAppsLoadValue, currentAppsPathValue)
   	  }
   	LV_ModifyCol(1)
   	Gui, manageApps:Show, w%manageAppsGUIW% h%manageAppsGUIH%
   	return

manageAppsLVevent:
   	if (A_GuiEvent = "ColClick") {
   	Loop, %appSectionKeys%
   	{
   		LV_GetText(new_name, A_Index, 1)
   		LV_GetText(new_enabled, A_Index, 2)
   		LV_GetText(new_path, A_Index, 3)
   		Apps_loadApp%A_Index% := new_enabled
   		Apps_nameApp%A_Index% := new_name
   		Apps_pathApp%A_Index% := new_path
   	}
   	}
   	if (A_GuiEvent = "DoubleClick") {
   	LV_GetText(RowText, A_EventInfo)
       AppToDel := % Apps_nameApp%A_EventInfo%  ; Get the text from the row's first field.
       MsgBox, 36, Delete this App?, Is this the App you want to delete?`n#%A_EventInfo%: %AppToDel%
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
         Loop, %appSectionKeys%
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
   	  reload
         delAppNo:
         return
   	}
   	If (A_GuiEvent = "R") {
      LV_GetText(pathToEdit, A_EventInfo, 3)
     	InputBox, newAppPathValue, Edit File Path, Enter the full path to the new App.`n(include path relative to %A_ScriptName%`nwhich is located in %A_ScriptDir%),,,,,,,,%pathToEdit%
      LV_Modify(A_EventInfo, ,,,newAppPathValue)
      Apps_pathApp%A_EventInfo% := newAppPathValue
      INI_Save(inifile)
      Gui, manageApps:Destroy
      Gui, mainWindow:Default
      Goto mainWindowButtonManageApps
   	}
   	return

manageAppsGuiEscape:
manageAppsButtonCancel:
   	Gui, manageApps:Destroy
    Gui, mainWindow:Default
   	return

manageAppsAddApp:
   	InputBox, newAppNameValue, Name or Description, Enter a Name or Description for the new app.
   	InputBox, newAppPathValue, File Path, Enter the full path to the new App.`n(include path relative to %A_ScriptName%`nwhich is located in %A_ScriptDir%)
   	if (!newAppPathValue) {
   	  MsgBox You must enter, at least, a path to an app. Please try again.
   	  return
   	  }
   	numberOfKeySets := round(section2_keys / 3)
   	newNumberOfKeySets := (numberOfKeySets + 1)
   	newAppEnableKey := (section2_keys + 1)
   	newAppPathKey := (section2_keys + 2)
   	newAppNameKey := (section2_keys + 3)
   	section2_key%newAppEnableKey% := "loadApp" . newNumberOfKeySets
   	section2_key%newAppPathKey% := "pathApp" . newNumberOfKeySets
   	section2_key%newAppNameKey% := "nameApp" . newNumberOfKeySets
   	Apps_loadApp%newNumberOfKeySets% := 1
   	Apps_pathApp%newNumberOfKeySets% := newAppPathValue
   	Apps_nameApp%newNumberOfKeySets% := newAppNameValue
   	section2_keys += 3
   	INI_Save(inifile)
   	reload
   	return

manageAppsSaveSorted:
      INI_Save(inifile)
      Gui, manageApps:Destroy
      Gui, mainWindow:Default
      return


mainWindowButtonSaveAndRelaunchMaster-Script: 
saveAndRelaunchMaster := 1 ; this flag determines if we need to save and relaunch the MASTER-SCRIPT.ahk
mainWindowButtonSAVE: ; otherwise we enter here and should save things and reload this MASTER-SETTINGS.ahk
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
  loop, %scriptSectionKeys%
    {
      Scripts_loadScript%A_Index% = % scriptCheckboxEnable%A_Index%
    }
  ;Setting Apps_loadAppX to new values
  loop, %appSectionKeys%
    {
      Apps_loadApp%A_Index% = % appCheckboxEnable%A_Index%
    }
  ;Setting the Other Settings values to their new values
  loop, %settingsSectionKeys%
    {
      currentSettingName := % section4_key%A_Index%
      %section4%_%currentSettingName% := % newSettingValue%A_Index%
    }

  INI_Save(inifile)

  If !saveAndRelaunchMaster { ; here is where we check the saveAndRelaunchMaster flag 
    Reload
  } else {
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
  }
Return

mainWindowButtonCancel:
mainWindowGuiClose:
mainWindowGuiEscape:
ExitApp

;===== FUNCTIONS ===============================================================================

SortArray(Array, Order="A") {
    ;Order A: Ascending, D: Descending, R: Reverse
    MaxIndex := ObjMaxIndex(Array)
    If (Order = "R") {
        count := 0
        Loop, % MaxIndex
            ObjInsert(Array, ObjRemove(Array, MaxIndex - count++))
        Return
    }
    Partitions := "|" ObjMinIndex(Array) "," MaxIndex
    Loop {
        comma := InStr(this_partition := SubStr(Partitions, InStr(Partitions, "|", False, 0)+1), ",")
        spos := pivot := SubStr(this_partition, 1, comma-1) , epos := SubStr(this_partition, comma+1)
        if (Order = "A") {
            Loop, % epos - spos {
                if (Array[pivot] > Array[A_Index+spos])
                    ObjInsert(Array, pivot++, ObjRemove(Array, A_Index+spos))
            }
        } else {
            Loop, % epos - spos {
                if (Array[pivot] < Array[A_Index+spos])
                    ObjInsert(Array, pivot++, ObjRemove(Array, A_Index+spos))
            }
        }
        Partitions := SubStr(Partitions, 1, InStr(Partitions, "|", False, 0)-1)
        if (pivot - spos) > 1    ;if more than one elements
            Partitions .= "|" spos "," pivot-1        ;the left partition
        if (epos - pivot) > 1    ;if more than one elements
            Partitions .= "|" pivot+1 "," epos        ;the right partition
    } Until !Partitions
}
