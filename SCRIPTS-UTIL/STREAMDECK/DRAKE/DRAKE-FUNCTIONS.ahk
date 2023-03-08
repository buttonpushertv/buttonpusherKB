; AutoHotKey - DRAKE FUNCTIONS
;  '||''|.   '||''|.       |     '||'  |'  '||''''|
;   ||   ||   ||   ||     |||     || .'     ||  .
;   ||    ||  ||''|'     |  ||    ||'|.     ||''|
;   ||    ||  ||   |.   .''''|.   ||  ||    ||
;  .||...|'  .||.  '|' .|.  .||. .||.  ||. .||.....|
;  a set of scripts to interract with Windows Explorer, Save Dialogs, and FreeCommander XE
; by Ben Howard - ben@buttonpusher.tv

; The InstantExplorer() function (along with Explorer_GetSelection(), Explorer_GetPath(), and saveLocation2()) are all pulled from TaranVH's 2nd-keyboard project (https://github.com/TaranVH/2nd-keyboard). I've modified & cleaned-up the code a little bit. Many thanks to Taran and his work. (His original comments appear in ALL CAPS).
;
;
; Why DRAKE? Sir Francis Drake was an EXPLORER....get it? (https://en.wikipedia.org/wiki/Francis_Drake)
; I know...I'm *hilarious* - Ben

;===== START OF AUTO-EXECUTION SECTION =========================================================
; Getting the rootFolder for BKB from the Environment Variable
EnvGet, Settings_rootFolder, BKB_ROOT
iniFile := Settings_rootFolder . "\settings.ini"
; and picking up a few other things
IniRead, Settings_pathToFCXE, %iniFile%, Settings, pathToFCXE
IniRead, Settings_FCXEParams, %iniFile%, Settings, FCXEParams
IniRead, Settings_fffDefaultDestination, %iniFile%, Settings, fffDefaultDestination
Settings_pathToFCXE = "%Settings_pathToFCXE%"

global currentWorkingProject
global lookupProjectNumber

;projectPath := Settings_rootFolder . "\PRIVATE\%A_Computername%\CurrentWorkingProject.txt"
;FileReadLine, currentWorkingProject, %Settings_rootFolder%\PRIVATE\%A_Computername%\CurrentWorkingProject.txt, 1

;===== END OF AUTO-EXECUTE =====================================================================
;===== MODIFIER MEMORY HELPER ==================================================================
; combine below with key and '::' to define hotkey
; e.g.- ^f1::Msgbox You pressed Control and F1
; #=Win | !=Alt | ^=Ctrl | +=Shift | &=combine keys | *=ignore other mods
; <=use left mod key| >=use right mod key  | UP=fires on release

;===== FUNCTIONS ===============================================================================
;
;===== START of TaranVH FUNCTIONS ================================================================
; The function below is used to navigate to folders in Windows Explorer windows, Save Dialogs, and Console Windows (cmd.exe)
;
; Here's what TaranVH had to say about where he got his inspiration:
;   BEGIN SAVAGE-FOLDER-NAVIGATION CODE!
;   I GOT MOST OF THIS CODE FROM HTTPS://AUTOHOTKEY.COM/DOCS/SCRIPTS/FAVORITEFOLDERS.HTM
;   AND MODIFIED IT TO WORK WITH ANY GIVEN KEYPRESS, RATHER THAN MIDDLE MOUSE CLICK AS IT HAD BEFORE.
;
InstantExplorer(pathToOpen,projectNumber)
{
  	global Settings_rootFolder
	global currentWorkingProject
  	send {SC0E8} ;SCAN CODE OF AN UNASSIGNED KEY. THIS IS NEEDED TO PREVENT THE ITEM FROM MERELY FLASHING ON THE TASK BAR, RATHER THAN OPENING THE FOLDER. DON'T ASK ME WHY, BUT THIS WORKS.

	; I tweaked this bit below a little bit to work with my idea of 'currentWorkingProject'
	; I often work on multiple projects & bounce between them throughout the day/week/month
	; By using a Project Numbering scheme, I can save multiple project root folders and then bounce between them easily
if (!projectNumber) { ; if no projectNumber is provided, then this will just open the path as provided
	fullPathToOpen = %pathToOpen%
	} else {
	projectLookupByNumber(projectNumber) ; this returns the path to the project stored 
	currentWorkingProject := getProjectByNumber()
	fullPathToOpen = %currentWorkingProject%\%pathToOpen%
	checkForProjectPath: ; this is going to be triggered if the path you are trying to access does not exist.
	parentFolderStringLocation := InStr(fullPathToOpen, "\",,0,2)
	parentFolder := SubStr(fullPathToOpen, 1, parentFolderStringLocation)
	if !FileExist(fullPathToOpen)
	{
	MsgBox, 8244, PATH DOES NOT EXIST, %fullPathToOpen% does not exist.`n`nWould you like to create & open it?`n`n`nSelect 'No' to open Parent folder:`n%parentFolder%
	IfMsgBox Yes
		{
		FileCreateDir, %fullPathToOpen%
		goto checkForProjectPath
		}
	IfMsgBox No
		{
		fullPathToOpen := parentFolder
		goto checkForProjectPath
		}
	}
  }

;;;SUPER IMPORTANT: YOU NEED TO GO INTO WINDOWS' FOLDER OPTIONS > VIEW > AND CHECK "DISPLAY THE FULL PATH IN THE TITLE BAR" OR THIS WON'T WORK.
;;;UPDATE: THE INSTRUCTION ABOVE MIGHT BE OBSOLETE NOW, I'VE FIGURED OUT A BETTER WAY TO DO THIS SHIT

quotedPathToOpen := """" . fullPathToOpen . """" ;THIS ADDS QUOTATION MARKS AROUND EVERYTHING SO THAT IT WORKS AS A STRING, NOT A VARIABLE.

f_path := quotedPathToOpen ; did this to maintain the code lifted from TaranVH below.

;f_path = %f_path%\ ;;THIS ADDS A \ AT THE VERY END OF THE FILE PATH, FOR THE SAKE OF OLD-STYLE SAVE AS DIALOUGE BOXES WHICH REQUIRE THEM IN ORDER TO UPDATE THE FOLDER PATH WHEN IT IS INSERTED INTO Edit1.

;MSGBOX,,DEBUG, from InstantExplorer()`nf_path has a value: %f_path%
; THESE FIRST FEW VARIABLES ARE SET HERE AND USED BY F_OPENFAVORITE:
WinGet, f_window_id, ID, A
WinGetClass, f_class, ahk_id %f_window_id%
WinGetTitle, f_title, ahk_id %f_window_id% ;TO BE USED LATER TO SEE IF THIS IS THE EXPORT DIALOUGE WINDOW IN PREMIERE...
if f_class in #32770,ExploreWClass,CabinetWClass  ; IF THE WINDOW CLASS IS A SAVE/LOAD DIALOG, OR AN EXPLORER WINDOW OF EITHER KIND.
	ControlGetPos, f_Edit1Pos, f_Edit1PosY,,, Edit1, ahk_id %f_window_id%
if f_path =
	return
if f_class = #32770    ; IT'S A DIALOG.
	{
	if WinActive("ahk_exe Adobe Premiere Pro.exe")
		{
		tooltip, you are inside of premiere

		if (f_title = "Export Settings") or if (f_title = "Link Media")
			{
			msgbox,,,you are in Premiere's export window or link media window, but NOT in the "Save as" inside of THAT window. no bueno, 1
			GOTO, instantExplorerEnd
			;RETURN ;NO, I DON'T WANT TO RETURN BECAUSE I STILL WANT TO OPEN AN EXPLORER WINDOW.
			}

		If InStr(f_title, "Link Media to") ;Note that you must have "use media browser to locate files" UNCHECKED because it is GARBAGE.
			{
			tooltip, you are inside Premieres relinker.
			; THIS REQUIRES CUSTOM CODE, BECAUSE THE EDITX BOXES ARE DIFFERENT:
			; LAST PATH   = EDIT1
			; FILENAME    = EDIT2
			; ADDRESS BAR = EDIT3

			ControlFocus, Edit2, ahk_id %f_window_id%

			tooltip, you are inside the link media thingy
			Sleep, 5

			WinActivate ahk_id %f_window_id%
			Sleep, 5
			ControlGetText, f_text, Edit2, ahk_id %f_window_id%
			Sleep, 5
			ControlSetText, Edit2, %f_path%, ahk_id %f_window_id%
			ControlSend, Edit2, +{Enter}, ahk_id %f_window_id%
			Sleep, 100  ; IT NEEDS EXTRA TIME ON SOME DIALOGS OR IN SOME CASES.
			ControlSetText, Edit2, %f_text%, ahk_id %f_window_id%
			tooltip,
			return
			}

		if (f_title = "Save As") or if (f_title = "Save Project")
			{
			ControlFocus, Edit1, ahk_id %f_window_id%
			tooltip, you are here
			Sleep, 5
			; ACTIVATE THE WINDOW SO THAT IF THE USER IS MIDDLE-CLICKING
			; OUTSIDE THE DIALOG, SUBSEQUENT CLICKS WILL ALSO WORK:
			WinActivate ahk_id %f_window_id%
			; RETRIEVE ANY FILENAME THAT MIGHT ALREADY BE IN THE FIELD SO
			; THAT IT CAN BE RESTORED AFTER THE SWITCH TO THE NEW FOLDER:
			ControlGetText, f_text, Edit1, ahk_id %f_window_id%
			Sleep, 5
			ControlSetText, Edit1, %f_path%, ahk_id %f_window_id%
			ControlSend, Edit1, +{Enter}, ahk_id %f_window_id%
			Sleep, 100  ; IT NEEDS EXTRA TIME ON SOME DIALOGS OR IN SOME CASES.
			ControlSetText, Edit1, %f_text%, ahk_id %f_window_id%
			tooltip,
			return
			}
		}

    if WinActive("ahk_exe Photoshop.exe")
      {
      tooltip, you are inside of Photoshop
      if (f_title = "Save As") or if (f_title = "Save Project")
        {
        ControlFocus, Edit1, ahk_id %f_window_id%
        ;tooltip, you are here
        Sleep, 5
        ; ACTIVATE THE WINDOW SO THAT IF THE USER IS MIDDLE-CLICKING
        ; OUTSIDE THE DIALOG, SUBSEQUENT CLICKS WILL ALSO WORK:
        WinActivate ahk_id %f_window_id%
        ; RETRIEVE ANY FILENAME THAT MIGHT ALREADY BE IN THE FIELD SO
        ; THAT IT CAN BE RESTORED AFTER THE SWITCH TO THE NEW FOLDER:
        ControlGetText, f_text, Edit1, ahk_id %f_window_id%
        Sleep, 5
        ControlSetText, Edit1, %f_path%, ahk_id %f_window_id%
        ControlSend, Edit1, +{Enter}, ahk_id %f_window_id%
        Sleep, 100  ; IT NEEDS EXTRA TIME ON SOME DIALOGS OR IN SOME CASES.
        ControlSetText, Edit1, %f_text%, ahk_id %f_window_id%
        tooltip,
        return
        }
      }


	; STUFF BEYOND HERE IS NOT IN PREMIERE
	if f_Edit1Pos <>   ; AND IT HAS AN EDIT1 CONTROL.
		{
		ControlFocus, Edit1, ahk_id %f_window_id% ;THIS IS REALLY IMPORTANT.... IT DOESN'T WORK IF YOU DON'T DO THIS...
		; ACTIVATE THE WINDOW SO THAT IF THE USER IS MIDDLE-CLICKING
		; OUTSIDE THE DIALOG, SUBSEQUENT CLICKS WILL ALSO WORK:
		WinActivate ahk_id %f_window_id%
		; RETRIEVE ANY FILENAME THAT MIGHT ALREADY BE IN THE FIELD SO
		; THAT IT CAN BE RESTORED AFTER THE SWITCH TO THE NEW FOLDER:
		ControlGetText, f_text, Edit1, ahk_id %f_window_id%
		sleep 2
		ControlSetText, Edit1, %f_path%, ahk_id %f_window_id%
		sleep 3
		ControlSend, Edit1, {Enter}, ahk_id %f_window_id%
		Sleep, 1000  ; IT NEEDS EXTRA TIME ON SOME DIALOGS OR IN SOME CASES.
		;NOW RESTORE THE FILENAME IN THAT TEXT FIELD. I DON'T LIKE DOING IT THIS WAY...
		ControlSetText, Edit1, %f_text%, ahk_id %f_window_id%
		sleep 2
		ControlFocus, DirectUIHWND2, ahk_id %f_window_id% ;TO TRY TO GET THE FOCUS BACK INTO THE CENTER AREA, SO YOU CAN NOW TYPE LETTERS AND HAVE IT GO TO A FILE OR FODLER, RATHER THAN TRY TO SEARCH OR TRY TO CHANGE THE FILE NAME BY DEFAULT.
		return
		}
	; ELSE FALL THROUGH TO THE BOTTOM OF THE SUBROUTINE TO TAKE STANDARD ACTION.
	}

else if f_class = ConsoleWindowClass ; IN A CONSOLE WINDOW, CD TO THAT DIRECTORY
	{
	WinActivate, ahk_id %f_window_id% ; BECAUSE SOMETIMES THE MCLICK DEACTIVATES IT.
	SetKeyDelay, 0  ; THIS WILL BE IN EFFECT ONLY FOR THE DURATION OF THIS THREAD.
	IfInString, f_path, :  ; IT CONTAINS A DRIVE LETTER (This is testing for presence of a colon character, which in, Windows *cannot* exist on commandline without a preceding drive letter, so yes, it contains a drive letter...almost certainly. We're scraping the first 2 characters, so we should get it anyhow.)
		{
      StringLeft, f_path_drive_temp, f_path, 2 ; scraping the first two characters - most likely a double quote and the drive letter
      StringRight, f_path_drive, f_path_drive_temp, 1 ; extracting just the drive letter without the quote
  		Send %f_path_drive%:{enter} ; now sending the drive letter plus a colon followed by Enter
		}
	Send, cd %f_path%{Enter}
	return
	}
ending2:
; SINCE THE ABOVE DIDN'T RETURN, ONE OF THE FOLLOWING IS TRUE:
; 1) IT'S AN UNSUPPORTED WINDOW TYPE BUT F_ALWAYSSHOWMENU IS Y (YES).
; 2) IT'S A SUPPORTED TYPE BUT IT LACKS AN EDIT1 CONTROL TO FACILITATE THE CUSTOM
;    ACTION, SO INSTEAD DO THE DEFAULT ACTION BELOW.

	Run, %f_path%  ; I GOT RID OF THE "EXPLORER" PART BECAUSE IT CAUSED REDUNDANT WINDOWS TO BE OPENED, RATHER THAN JUST SWITCHING TO THE EXISTING WINDOW
  ; For me, it *always* opens in a new Explorer Window. I must have a setting different on my system. - Ben

instantExplorerEnd:
tooltip,
}
;END OF INSTANTEXPLORER()

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;THIS FRIGGIN BEAUTIFUL CODE IS FROM THIS THREAD:
;HTTPS://AUTOHOTKEY.COM/BOARD/TOPIC/121208-WINDOWS-EXPLORER-GET-FOLDER-PATH/?P=687189
;https://autohotkey.com/board/topic/121208-windows-explorer-get-folder-path/

Explorer_GetSelection(hwnd="") {
	WinGet, process, ProcessName, % "ahk_id" hwnd := hwnd? hwnd:WinExist("A")
	WinGetClass activeClass, ahk_id %hwnd%
	WinGetTitle activeTitle, ahk_id %hwnd%
	;MsgBox, GetSelection:process:%process%`nclass:%class%`nahk_id:%hwnd%
	if (process = "explorer.exe") {
		if (activeClass ~= "Progman|WorkerW") {
			;;if you're on the desktop
			ControlGet, files, List, Selected Col1, SysListView321, ahk_class %activeClass%
			Loop, Parse, files, `n, `r
			ToReturn .= A_Desktop "\" A_LoopField "`n"
	} else if (activeClass ~= "(Cabinet|Explore)WClass") {
		for window in ComObjCreate("Shell.Application").Windows
			if (window.hwnd==hwnd)
				sel := window.Document.SelectedItems
		for item in sel
			ToReturn .= item.path "`n"
		} 
	} else if (activeClass ~= "#32770") {
		If (activeTitle = "Save As") {
			ControlGetText, gotPath, ToolbarWindow324, ahk_class #32770
			ToReturn :=SubStr(gotPath, 10)
		} else if (activeTitle = "Open File") {
			ControlGetText, gotPath, ToolbarWindow323, ahk_class #32770
		ToReturn :=SubStr(gotPath, 10)
		}	
	}
	;MSGBOX, , DEBUG, gotPath:%gotPath%`nToReturn:%ToReturn%
	return Trim(ToReturn,"`n")
}
; ; ;HOW TO CALL THE ABOVE FUNCTION
; ; F12::
; ; PATHANDNAME := EXPLORER_GETSELECTION()
; ; ;SPLITPATH, PATHANDNAME, FN
; ; SPLITPATH, PATHANDNAME, NAMEONLY ,THEPATH
; ; MSGBOX % "FILENAME :`T" NAMEONLY "`NPATH :`T" THEPATH "`NFULLNAME :`T" PATHANDNAME
; ; CLIPBOARD = % THEPATH
; ; SOUNDBEEP, 500, 200
; ; RETURN

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

;THIS ONE DOES NOT REQUIRE YOU TO SELECT AN ITEM IN THE FOLDER IN ORDER TO WORK! UNFORTUNATELY, IT DOES NOT WORK ON SAVE AS DIALOGS FOR WHATEVER REASON.
;; CODE WAS GOTTEN FROM HERE HTTPS://AUTOHOTKEY.COM/BOARD/TOPIC/121208-WINDOWS-EXPLORER-GET-FOLDER-PATH/?P=687189
;; AND HERE HTTPS://WWW.AUTOHOTKEY.COM/BOARDS/VIEWTOPIC.PHP?P=28751#P28751
Explorer_GetPath(hwnd="") {
	WinGet, process, ProcessName, % "ahk_id" hwnd := hwnd? hwnd:WinExist("A")
	WinGetClass activeClass, ahk_id %hwnd%
	WinGetTitle activeTitle, ahk_id %hwnd%
	;MsgBox, GetSelection:process:%process%`nclass:%class%`nahk_id:%hwnd%
	if (process = "explorer.exe") {
		if (activeClass ~= "Progman|WorkerW") {
			;;IF YOU'RE ON THE DESKTOP
			ControlGet, files, List, Selected Col1, SysListView321, ahk_class %activeClass%
			Loop, Parse, files, `n, `r
			ToReturn .= A_Desktop "\" A_LoopField "`n"
	} else if (activeClass ~= "(Cabinet|Explore)WClass") {
		for window in ComObjCreate("Shell.Application").Windows
			if (window.hwnd==hwnd)
				ToReturn := window.Document.Folder.Self.Path
		}
	} else if (activeClass ~= "#32770") {
		If (activeTitle = "Save As") {
			ControlGetText, gotPath, ToolbarWindow324, ahk_class #32770
			ToReturn :=SubStr(gotPath, 10)
		} else if (activeTitle = "Open File") {
			ControlGetText, gotPath, ToolbarWindow323, ahk_class #32770
			ToReturn :=SubStr(gotPath, 10)
		}	
	}
	;MSGBOX, , DEBUG, gotPath:%gotPath%`nToReturn:%ToReturn%
	return ToReturn
}
#IfWinActive

; Generic saving of the path info here. This is based on the fact that once we pull the path from wherever it comes from, we save it the same way anyhow.

savePath(pathToSave){
    global Settings_rootFolder
	FileDelete, %Settings_rootFolder%\PRIVATE\%A_Computername%\SavedPath.txt
	FileAppend, %pathToSave%, %Settings_rootFolder%\PRIVATE\%A_Computername%\SavedPath.txt
}

; This function is being phased out in favor of the more generic function "savePath()" - around line 318
; tweaked the function below to keep it consistent with the FCXE functions futher down.
savePathForExplorer(pathToSave){
	global Settings_rootFolder
	FileDelete, %Settings_rootFolder%\PRIVATE\%A_Computername%\SavedExplorerAddress.txt
	FileAppend, %pathToSave%, %Settings_rootFolder%\PRIVATE\%A_Computername%\SavedExplorerAddress.txt
;FOR SOME REASON, AFTER THIS SCRIPT RUNS, IT SOMETIMES ACTIVATES THE LAST ACTIVE WINDOW. IT DOESN'T MAKE ANY SENSE...
}
;FOR FURTHER READING:
;HTTPS://AUTOHOTKEY.COM/BOARD/TOPIC/60985-GET-PATHS-OF-SELECTED-ITEMS-IN-AN-EXPLORER-WINDOW/
;END OF SAVELOCATION2()
;===== END of TaranVH FUNCTIONS ==================================================================

;===== GENERIC FUNCTIONS ==================================================================

whichWindowType() {
  SetTitleMatchMode Slow
  WinGet, f_window_id, ID, A
  WinGetClass, f_class, ahk_id %f_window_id%
  return f_class
}

setCurrentWorkingProject(pathToSet) {
  global Settings_rootFolder
  FileCopy, %Settings_rootFolder%\PRIVATE\%A_Computername%\CurrentWorkingProject.txt, %Settings_rootFolder%\PRIVATE\%A_Computername%\PrevWorkingProject.txt
  FileDelete, %Settings_rootFolder%\PRIVATE\%A_Computername%\CurrentWorkingProject.txt
  FileAppend, %pathToSet%, %Settings_rootFolder%\PRIVATE\%A_Computername%\CurrentWorkingProject.txt
  MsgBox, 262208, Set NEW Current Working Project, The Current Working Project is NOW SET TO:`n%pathToSet%, 4
}

setProjectNumber(pathToSet, projectNumber, projectSlug) {
  global Settings_rootFolder
  FileDelete, %Settings_rootFolder%\PRIVATE\%A_Computername%\Project-%projectNumber%.txt
  FileAppend, 
  (
%pathToSet%
 %projectSlug%
), %Settings_rootFolder%\PRIVATE\%A_Computername%\Project-%projectNumber%.txt
  MsgBox, 262208, Set Project %projectNumber% as %pathToSet%, Project #%projectNumber% is NOW SET TO:`n%pathToSet%`nAnd the Project Short Name is:%projectSlug%, 4
}

getCurrentWorkingProject() {
	global Settings_rootFolder
	projectPath := Settings_rootFolder . "\PRIVATE\%A_Computername%\CurrentWorkingProject.txt"
	FileReadLine, currentWorkingProject, %Settings_rootFolder%\PRIVATE\%A_Computername%\CurrentWorkingProject.txt, 1
	return currentWorkingProject
}

projectLookupByNumber(projectNumber) {
	global lookupProjectNumberPath
	global Settings_rootFolder
	FileReadLine, lookupProjectNumberPath, %Settings_rootFolder%\PRIVATE\%A_Computername%\Project-%projectNumber%.txt, 1
}

getProjectByNumber() {
  global lookupProjectNumberPath
  return (lookupProjectNumberPath) 
}
;===== FreeCommanderXE FUNCTIONS ==================================================================

; I use FreeCommanderXE (https://freecommander.com/) as my primary file manager. Windows Explorer is lacking in many areas. I find FreeCommanderXE gives me a lot of support in those areas and makes things quicker & easier.
;
; While there are lots of keyboard commands within FreeCommanderXE, I found that if you are just opening locations, it was quicker to send it via the commandline interface that already exists in the app.

openProjectInFCXE(pathToOpen,projectNumber){
	global Settings_pathToFCXE
	global Settings_FCXEParams
  global currentWorkingProject
  if (!projectNumber) {
      fullPathToOpen = %pathToOpen%
  } else {	  
	projectLookupByNumber(projectNumber) ; this returns the path to the project stored 
	currentWorkingProject := getProjectByNumber()
	fullPathToOpen = %currentWorkingProject%\%pathToOpen%
    }
	checkForPath:
    quotedPathToOpen := """" . fullPathToOpen . """" ;THIS ADDS QUOTATION MARKS AROUND EVERYTHING SO THAT IT WORKS AS A STRING, NOT A VARIABLE.
    ;MSGBOX,,DEBUG, from openProjectInFCXE()`nfullPathToOpen has a value: %fullPathToOpen%`nAnd quotedPathToOpen is:%quotedPathToOpen%
    
    if !FileExist(fullPathToOpen)
    {
      MsgBox, 8244, PATH DOES NOT EXIST, %quotedPathToOpen% does not exist.`n`nWould you like to create & open it?`n`n`nSelect 'No' to open Parent of:`n%currentWorkingProject%
      IfMsgBox Yes
        {
        FileCreateDir, %fullPathToOpen%
        goto checkForPath
        }
      IfMsgBox No
        {
		parentFolderStringLocation := InStr(fullPathToOpen, "\",,0,2)
		fullPathToOpen := SubStr(fullPathToOpen, 1, parentFolderStringLocation)
		goto checkForPath
        }
    } else {
    Run, %Settings_pathToFCXE% %Settings_FCXEparams% %quotedPathToOpen%
    ; There is a trick about the way FCXE recieves it's parameters: If you are sending the one where you tell it which panel to open in ('/L=' or '/R=') it must not have a space between the parameter and the path you want to open. However, if you just want to open the path in the active panel of the current instance you must send '/C' with a space. SO, if you want to force it to open in a specific panel, you will need to remove the space between the 2 %'s above (like this: "%Settings_FCXEparams%%quotedPathToOpen%")
    }
    Return
}

openInFCXE(selectedPath){
	global Settings_pathToFCXE
	global Settings_FCXEParams
	quotedPathToOpen := """" . selectedPath . """" ;THIS ADDS QUOTATION MARKS AROUND EVERYTHING SO THAT IT WORKS AS A STRING, NOT A VARIABLE.
	;MsgBox, %Settings_pathToFCXE% %Settings_FCXEparams% %quotedPathToOpen%
    Run, %Settings_pathToFCXE% %Settings_FCXEparams% %quotedPathToOpen%
    ; There is a trick about the way FCXE recieves it's parameters: If you are sending the one where you tell it which panel to open in ('/L=' or '/R=') it must not have a space between the parameter and the path you want to open. However, if you just want to open the path in the active panel of the current instance you must send '/C' with a space. SO, if you want to force it to open in a specific panel, you will need to remove the space between the 2 %'s above (like this: "%Settings_FCXEparams%%quotedPathToOpen%")
	return
    }

getFCXEPath(){
  f_class := whichWindowType()
  If f_class contains FreeCommanderXE
  {
	    savedPath := parseFCXEPath()
	    pathToSave = % savedPath
        ;MSGBOX,,DEBUG, inside getFCXEPath:`nf_class:%f_class%`nsavedPath:%savedPath%`npathToSave:%pathToSave%
  } else {
	   MsgBox,,,You don't appear to be in a FreeCommanderXE window.,2
   }
   return pathToSave
}

; This function is being phased out in favor of the more generic function "savePath()" - around line 318
savePathForFCXE(savedPath){
	global Settings_rootFolder
	FileDelete, %Settings_rootFolder%\PRIVATE\%A_Computername%\SavedPathForFCXE.txt
	FileAppend, %savedPath%, %Settings_rootFolder%\PRIVATE\%A_Computername%\SavedPathForFCXE.txt
	;MSGBOX,,DEBUG,savePathForFCXE,%savedPath%`nwas saved to`n`n%Settings_rootFolder%\PRIVATE\SavedPathForFCXE.txt, 2
	return
}

parseFCXEPath() {
	WinGetActiveTitle, winTitleFromFCXE
	FoundPos := RegExMatch(winTitleFromFCXE, " - FreeCommander")
	StringLeft, tempPathFromFCXE, winTitleFromFCXE, (FoundPos - 1)
  ;pathFromFCXE := tempPathFromFCXE . "\"
  ;MSGBOX,,DEBUG, from parseFCXEPath:`nwinTitleFromFCXE:%winTitleFromFCXE%`ntempPathFromFCXE:%tempPathFromFCXE%
  return tempPathFromFCXE
}

getWorkingProject() {
  global currentWorkingProject
  return currentWorkingProject
}

Exiting(tipContent,projectNumber)
{
	projectLookupByNumber(projectNumber) ; this returns the path to the project stored 
	currentWorkingProject := getProjectByNumber()
	tipContent := currentWorkingProject . "\" . tipContent
	ToolTip, Opening %tipContent%
	Sleep, 3000
	ExitApp
	Return
  }

fffSettingsCreator(selectedPath) { ; This function sets up the freefilesync backup settings for the provided project path
	global Settings_rootFolder ; needed to pull in the values of these 2 variables from outside the function
	global Settings_fffDefaultDestination ; what that last line said
	Needle := "[^\\]+$" ;patter that matches all characters that are not a "\" starting from the end of the haystack (the double \ gets you the single character)
	RegExMatch(selectedPath, Needle, projectName) ; do the match and set the value to projectName
	fffDestinationFullPath = %Settings_fffDefaultDestination%%projectName% ; this is the full path using the settings.ini/fffDefaultDestination value plus the projectName value where the files will be backed up to.

	; ASK if user wants to create a freefilesync backup setting for this project
	MsgBox, 36, Create FreeFileSync backup setting?, Do you want to create a FreeFileSync backup settings file for:`n%selectedPath%?`n`n(This will facilitate easy incremental backups of your work on a regular basis). ; this will prompt user if they want to create the FreeFileSync setting (ffs_batch) for this backup
	IfMsgBox, No
		Return ; if they answer No, then we return & do nothing further
	; If user answers Yes then code contiues
	; ASK for the destination where freefilesync will backup the source
	InputBox, backupPath, Backup Destination?, Where should the backup be stored?,,800,,,,,,%fffDestinationFullPath% 

	backupSettingToCreate =  %Settings_rootFolder%\PRIVATE\%A_ComputerName%\_fff-backup-settings\%projectName%-backup.ffs_batch ; and this is the settings file along with full path that will created below

	FileDelete, %backupSettingToCreate% ; we are flat out deleting this here because the FileAppend will just tack a whole other set of XML items to the end of the file otherwise, causing FFF to error out.
	Tooltip, Deleting any old ffs_batch file settings
	RemoveToolTip(3000)
	; In order to save the source and destination paths, we need to construct the XML file that serves as a backup settings file for FreeFileSync. The FileAppend command below will construct that file and include the variables for the source and destination paths.
	FileAppend,
	(
    <?xml version="1.0" encoding="utf-8"?>
<FreeFileSync XmlType="BATCH" XmlFormat="17">
    <Compare>
        <Variant>TimeAndSize</Variant>
        <Symlinks>Exclude</Symlinks>
        <IgnoreTimeShift/>
    </Compare>
    <Synchronize>
        <Variant>Update</Variant>
        <DetectMovedFiles>false</DetectMovedFiles>
        <DeletionPolicy>RecycleBin</DeletionPolicy>
        <VersioningFolder Style="Replace"/>
    </Synchronize>
    <Filter>
        <Include>
            <Item>*</Item>
        </Include>
        <Exclude>
            <Item>\System Volume Information\</Item>
            <Item>\$Recycle.Bin\</Item>
            <Item>\RECYCLE?\</Item>
            <Item>*\thumbs.db</Item>
        </Exclude>
        <TimeSpan Type="None">0</TimeSpan>
        <SizeMin Unit="None">0</SizeMin>
        <SizeMax Unit="None">0</SizeMax>
    </Filter>
    <FolderPairs>
        <Pair>
            <Left>%selectedPath%</Left>
            <Right>%backupPath%</Right>
        </Pair>
    </FolderPairs>
    <Errors Ignore="false" Retry="0" Delay="5"/>
    <PostSyncCommand Condition="Completion"/>
    <LogFolder/>
    <EmailNotification Condition="Always"/>
    <Batch>
        <ProgressDialog Minimized="false" AutoClose="true"/>
        <ErrorDialog>Show</ErrorDialog>
        <PostSyncAction>None</PostSyncAction>
    </Batch>
</FreeFileSync>
), %backupSettingToCreate%

	FileCreateDir, %backupPath% ; this will create the directory at the backupPath location. backupPath came from the Inputbox above

	activeProjectBackupsPath = %Settings_rootFolder%\PRIVATE\%A_ComputerName%\ACTIVE-PROJECT-BACKUPS.cmd ; this is the path & name of the batch file that can be invoked via CapsLocK+B from MASTER-SCRIPT.ahk to run the automated backups of active projects.

	; ASK if this new setting should be appended to the ACTIVE_PROJECT_BACKUPS batch file
	MsgBox, 36, Add to Active Project Backups?, Would you like to append a call to run this FreeFileSync backup settings to the %activeProjectBackupsPath% batch file?
	IfMsgBox, No 
		Return ; if they answer No, then we return & do nothing further
	; If user answers Yes then code contiues

	; The block below is what will be added to end the file at: %Settings_rootFolder%\PRIVATE\%A_ComputerName%\ACTIVE-PROJECT-BACKUPS.cmd
	; 
	FileAppend,
	(

REM ==============
REM Project Name: %projectName%
REM Original Path: %selectedPath%
REM Backup Destination: %backupPath%
REM Added: %A_YYYY%-%A_MMM%-%A_DD% at %A_Hour%:%A_Min%:%A_Sec%
CALL "%backupSettingToCreate%"
if not `%errorlevel`% == 0 `(
  echo errorlevel gives some indication of what went wrong
  echo ==============================================
  echo 0 - Synchronization completed successfully
  echo 1 - Synchronization completed with warnings
  echo 2 - Synchronization completed with errors
  echo 3 - Synchronization was aborted
  echo ==============================================
  echo Errors occurred during synchronization of %projectName%...
  echo Exited with errorlevel: `%errorlevel`%
  pause
`)
REM ++++++++++++++
  ), %activeProjectBackupsPath%

	MSGBOX, 64, Automated Backup Settings Created, A FreeFileSync backup settings file (ffs_batch) has been created at:`n`n%backupSettingToCreate%`n`nAnd it has been added to the batch file:`n`n%activeProjectBackupsPath%`n`nCapsLock+B will invoke the batch file above to run backups of all active projects., 4

	; Issues to address at some point:
	; 1. There is NO check to see if the same project already exists in the ACTIVE-PROJECT-BACKUPS.cmd file
	; 2. Maybe it would be cool to have a GUI checklist of all projects that have been setup, so you could turn backups on and off
	; 3. Once projects get archived from the system & removed, should there be a way to track that info?
	Return
}

; use this function to Remove ToolTips - pretty self-explanatory - 'duration' should be given in milliseconds (4000 = 4 seconds)
RemoveToolTip(duration) {
  SetTimer, ToolTipOff, %duration%
  Return

ToolTipOff:
    ToolTip
    return
}