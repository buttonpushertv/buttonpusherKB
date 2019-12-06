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

#Include MASTER-FUNCTIONS.ahk

;===== END OF AUTO-EXECUTE =====================================================================
;===== MAIN HOTKEY DEFINITIONS HERE ============================================================
global versionFile := "version.ini" ; the file which holds the current version of BPTV-KB
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
guiWidth := 660
guiElementWidth := (guiWidth - 20)
;figuring out how tall the whole GUI will be
keyRows := (section1_keys - 1)
keyRows += (section2_keys / 3)
guiHeight := (keyRows * 27)
guiHeight += 180 ; this is to add the bit at the bottom for the buttons, text
buttonStartingY := (guiHeight - 100)
global scriptSectionKeys := round(section2_keys / 3)
global appSectionKeys := round(section3_keys / 3)

;Section 1 - System Location
section1GroupH := (section1_keys - 1)
currentAltCounter := 1
Gui, Font, S12 CDefault, Franklin Gothic Medium
Gui, Add, GroupBox, R%section1GroupH% x10 y10 w300 , System Location
Gui, Font, S10 CDefault, Franklin Gothic Medium
Gui, Add, Text, x330 y20 w280, Select a Location at the left. This can be used to provide location specific settings.`n`nRoot Folder: %Settings_rootFolder%`nVersion: %version%`nBelow, check the boxes for the scripts you'd like to launch when running MASTER-SCRIPT.ahk.
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
    if (currentAltCounter = Location_currentSystemLocation) {
      Gui, Add, Radio, xs+20 vLocRadioGroup%currentAltCounter% Checked, %currentKeyValueForRadio%
      global currentSelectedSystemLocation := currentKeyValue
    } else
      Gui, Add, Radio, xs+20 vLocRadioGroup%currentAltCounter%, %currentKeyValueForRadio%
  }

;Section 2 - Scripts To Run
section2GroupH := (section2_keys / 3) - 1.75
currentAltCounter := 1
Gui, Add, GroupBox, R%section2GroupH% x10 yp+50 w630 , Scripts to Load
Gui, Add, Text, section xp yp+10,
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
      ;MSGBOX, , DEBUG, currentKey: %currentKey%`ncurrentKeyValue: %currentKeyValue%`ncurrentPathValue: %currentPathValue%`ncurrentNameValue: %currentNameValue%`npathKey: %pathKey%`nnameKey: %nameKey%
      Gui, Add, Checkbox, xs+20 yp+20 vscriptCheckboxEnable%currentAltCounter% Checked%currentKeyValue%, %currentNameValue%
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
Gui, Add, Button, x520 yp w100 h30, Variables ; Uncomment if you wish to have a button to show Variables assigned by the script
Gui, Add, Button, x30 y%buttonStartingY% w150 h30, &Manage Scripts
Gui, Add, Button, x200 y%buttonStartingY% w150 h30, Manage &Apps
Gui, Add, Button, x400 yp w100 h30, &Cancel
Gui, Add, Button, x520 yp w100 h30, &SAVE
Gui, Add, Button, x30 yp+33 w590 h30, &RELAUNCH MASTER-SCRIPT
Gui, Font, S10 CDefault, Franklin Gothic Medium
Gui, Add, Text, x30 yp+30 w650, Clicking 'SAVE' will just save the settings above.`nClick 'RELAUNCH MASTER-SCRIPT' to save & relaunch all the checked scripts.

Gui, Show, w%guiWidth% h%guiHeight%
return

ButtonVariables:
Listvars
return

ButtonManageScripts:
	manageScriptsGUIH := (scriptSectionKeys * 50) + 40
	manageScriptsGUIW := 880
	manageScriptsLVH := (manageScriptsGUIH - 130)
	manageScriptsLVW := 850

	Gui, manageScripts:New, , Manage Scripts
	Gui, manageScripts:Font, S12 CDefault, Franklin Gothic Medium
	Gui, manageScripts:Add, Text, , Current Script Order:
	Gui, manageScripts:Add, ListView, x15 r%scriptSectionKeys% w%manageScriptsLVW% h%manageScriptsLVH% gmanageScriptsLVevent -ReadOnly, Script|Enabled?|Path
	Gui, manageScripts:Font, S10 CDefault, Franklin Gothic Medium
	Gui, manageScripts:Add, Text, yp+%manageScriptsLVH% , SORT: Click Column Headers (2nd click to reverse order)`nEDIT NAME: Select Script `& press F2.`nEDIT PATH: Right-Double-Click on Script
	Gui, manageScripts:Add, Text, x440 yp , ADD SCRIPT: Use 'Add Script' button below.`nDELETE SCRIPT: Double-click individual Script name then confirm deletion.`nCANCEL: Press Escape.
	Gui, manageScripts:Font, S12 CDefault, Franklin Gothic Medium
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
		newScripts_loadScript%A_Index% := new_enabled
		newScripts_nameScript%A_Index% := new_name
		newScripts_pathScript%A_Index% := new_path
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
		Gui, manageScripts:Destroy
		Goto ButtonManageScripts
	return
	}
	return

manageScriptsGuiEscape:
manageScriptsButtonCancel:
	Gui, manageScripts:Destroy
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
	Loop, %scriptSectionKeys%
	{
    scriptCheckboxEnable%A_Index% :=
		Scripts_loadScript%A_Index% :=
		Scripts_loadScript%A_Index% := % newScripts_loadScript%A_Index%
		scriptCheckboxEnable%A_Index% := % newScripts_loadScript%A_Index%
		Scripts_nameScript%A_Index% := % newScripts_nameScript%A_Index%
		Scripts_pathScript%A_Index% := % newScripts_pathScript%A_Index%
	}

  /*
   Gui, newsortScript:New, , NEW Sorted Scripts
 	 Gui, newsortScript:Font, S12 CDefault, Franklin Gothic Medium
	 Gui, newsortScript:Add, Text, , Current Script Order:
	 Gui, newsortScript:Add, ListView, r%scriptSectionKeys% w%manageScriptsLVW% h%manageScriptsLVH%, Script|Enabled?|Path
	 loop, %scriptSectionKeys%
	 {
     currentLoadValue := % Scripts_loadScript%A_Index%
     currentNameValue := % Scripts_nameScript%A_Index%
     currentPathValue := % Scripts_pathScript%A_Index%
     LV_Add(,currentNameValue, currentLoadValue, currentPathValue)
  	   }
  	 LV_ModifyCol(1)
	 Gui, newsortScript:Show, w%manageScriptsGUIW% h%manageScriptsGUIH%

   MsgBox, 36, Does this look correct?
   IfMsgBox, No
     goto saveSortedNo
    IfMsgBox, Yes
   	Goto, ButtonSave
    saveSortedNo:
    Gui, newsortScript:Destroy
    */
    Goto, ButtonSave
   return

ButtonManageApps:
   	manageAppsGUIH := (appSectionKeys * 50) + 150
   	manageAppsGUIW := 880
   	manageAppsLVH := (manageAppsGUIH - 130)
   	manageAppsLVW := 850

   	Gui, manageApps:New, ,Manage Apps
   	Gui, manageApps:Font, S12 CDefault, Franklin Gothic Medium
   	Gui, manageApps:Add, Text, , Current App Order:
   	Gui, manageApps:Add, ListView, x15 r%appSectionKeys% w%manageAppsLVW% h%manageAppsLVH% gmanageAppsLVevent -ReadOnly, App|Enabled?|Path
   	Gui, manageApps:Font, S10 CDefault, Franklin Gothic Medium
   	Gui, manageApps:Add, Text, yp+%manageAppsLVH% , SORT: Click Column Headers (2nd click to reverse order)`nEDIT NAME: Select App `& press F2.`nEDIT PATH: Right-Double-Click on App
   	Gui, manageApps:Add, Text, x440 yp , ADD App: Use 'Add App' button below.`nDELETE App: Double-click individual App name then confirm deletion.`nCANCEL: Press Escape.
   	Gui, manageApps:Font, S12 CDefault, Franklin Gothic Medium
   	Gui, manageApps:Add, Button, x15 yp+55 w100 h30 gmanageAppsAddApp, &Add App
   	Gui, manageApps:Add, Button, x635 yp w100 h30, &Cancel
   	Gui, manageApps:Add, Button, x765 yp w100 h30 gmanageAppsSaveSorted, &Save Sorted
   	loop, %appSectionKeys%
   	  {
        currentAppsLoadValue := % Apps_loadApp%A_Index%
        currentAppsNameValue := % Apps_nameApp%A_Index%
        currentAppsPathValue := % Apps_pathApp%A_Index%
        ;MSGBOX, , DEBUG,%A_DefaultListView%`n%currentAppsNameValue%`n%currentAppsLoadValue%`n%currentAppsPathValue%
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
   		newApps_loadApp%A_Index% := new_enabled
   		newApps_nameApp%A_Index% := new_name
   		newApps_pathApp%A_Index% := new_path
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
   		Apps_pathApp%A_EventInfo% := newAppPathValue
   		Gui, manageApps:Destroy
   		Goto ButtonManageApps
   	return
   	}
   	return

   manageAppsGuiEscape:
   manageAppsButtonCancel:
   	Gui, manageApps:Destroy
   	return

   manageAppsAddApp:
   	InputBox, newAppNameValue, Name or DeAppion, Enter a Name or DeAppion for the new app.
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

   manageAppsEditAppPath:
   	LV_GetText(pathToEdit, A_EventInfo, 3)
   	InputBox, newAppPathValue, Edit File Path, Enter the full path to the new App.`n(include path relative to %A_ScriptName%`nwhich is located in %A_ScriptDir%),,,,,,,,%pathToEdit%
     LV_Modify(A_EventInfo, ,,,newAppPathValue)
   	return

   manageAppsSaveSorted:
   	Loop, %appSectionKeys%
   	{
      AppCheckboxEnable%A_Index% :=
   		Apps_loadApp%A_Index% :=
   		Apps_loadApp%A_Index% := % newApps_loadApp%A_Index%
   		AppCheckboxEnable%A_Index% := % newApps_loadApp%A_Index%
   		Apps_nameApp%A_Index% := % newApps_nameApp%A_Index%
   		Apps_pathApp%A_Index% := % newApps_pathApp%A_Index%
   	}

    /*
    Gui, newsortApp:New, , NEW Sorted Apps
    Gui, newsortApp:Font, S12 CDefault, Franklin Gothic Medium
    Gui, newsortApp:Add, Text, , Current App Order:
    Gui, newsortApp:Add, ListView, r%appSectionKeys% w%manageAppsLVW% h%manageAppsLVH%, App|Enabled?|Path
    loop, %appSectionKeys%
    {
        currentLoadValue := % Apps_loadApp%A_Index%
        currentNameValue := % Apps_nameApp%A_Index%
        currentPathValue := % Apps_pathApp%A_Index%
        LV_Add(,currentNameValue, currentLoadValue, currentPathValue)
     	   }
     	 LV_ModifyCol(1)
   	 Gui, newsortApp:Show, w%manageAppsGUIW% h%manageAppsGUIH%

      MsgBox, 36, Does this look correct?
      IfMsgBox, No
        goto saveSortedNo
       IfMsgBox, Yes
      	INI_Save(inifile)
       saveSortedNo:
       Gui, newsortApp:Destroy
      */
       INI_Save(inifile)
       Gui, manageApps:Destroy
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
  loop, %scriptSectionKeys%
    {
    Scripts_loadScript%A_Index% = % scriptCheckboxEnable%A_Index%
    ;MSGBOX, , DEBUG, % Scripts_loadScript%A_Index%
    }
  INI_Save(inifile)
  Reload
Return

ButtonRelaunchMaster-Script:
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
  if mod(A_Index,3) {
    Scripts_loadScript%currentAltCounter% = % scriptCheckboxEnable%currentAltCounter%
    currentAltCounter += 1
  }
  else
    Continue
  }
INI_Save(inifile)
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
