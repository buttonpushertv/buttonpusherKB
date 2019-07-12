; AutoHotKey - MASTER-SETTINGS for MASTER-SCRIPT
; by Ben Howard - ben@buttonpusher.tv
; based on an example given in this post:
; https://autohotkey.com/board/topic/19650-auto-readload-and-save-an-ini-file-updated/

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
guiWidth := 700
guiElementWidth := (guiWidth - 20) 
;figuring out how tall the whole GUI will be
keyRows := (section1_keys - 1)
keyRows += (section2_keys / 3)
guiHeight := (keyRows * 30)
guiHeight += 150 ; this is to add the bit at the bottom for the buttons, text
buttonStartingY := (guiHeight - 50)

;Section 1 - System Location
sectionGroupH := (section1_keys - 1)
currentAltCounter := 1
Gui, Font, S12 CDefault, Franklin Gothic Medium
Gui, Add, GroupBox, R%sectionGroupH% x10 y10 w300 , System Location
Gui, Font, S10 CDefault, Franklin Gothic Medium
Gui, Add, Text, x330 y20 w280, Select a Location at the left. This can be used to provide location specific settings.`n`nBelow, check the boxes for the scripts you'd like to launch when running MASTER-SCRIPT.ahk.`n`nEdit '%inifile%' to add more locations and scripts.
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
Gui, Font, S10 CDefault, Franklin Gothic Medium
Gui, Add, Text, x30 y%buttonStartingY% w340, Clicking 'SAVE' will save the settings above and reload MASTER-SCRIPT.ahk and the checked scripts above.
Gui, Font, S12 CDefault, Franklin Gothic Medium
Gui, Add, Button, x400 y%buttonStartingY% w100 h30, Cancel
Gui, Add, Button, x520 yp w100 h30, SAVE
;Gui, Add, Button, x400 yp+32 w220 h20, Variables
Gui, Show, w%guiWidth% h%guiHeight%
return

ButtonVariables:
Listvars
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
Run, "MASTER-SCRIPT.ahk" ; forcing the MASTER-SCRIPT.ahk to reload
Gui, Destroy
ExitApp
return

ButtonCancel:
GuiClose:
GuiEscape:
ExitApp

;===== FUNCTIONS ===============================================================================
