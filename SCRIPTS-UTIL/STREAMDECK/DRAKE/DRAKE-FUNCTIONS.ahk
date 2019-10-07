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
; This is my attempt to avoid hard-coding the paths of where everything lies into the scripts. Since this script *should* always live in its current folder, the double-double-dots-with-backslashes should always lead to where the settings.ini file lives. And that's where the rootFolder info is stored.
iniFile := "..\..\..\settings.ini"
IniRead, Settings_rootFolder, %iniFile%, Settings, rootFolder
IniRead, Settings_pathToFCXE, %iniFile%, Settings, pathToFCXE
IniRead, Settings_FCXEParams, %iniFile%, Settings, FCXEParams
Settings_pathToFCXE = "%Settings_pathToFCXE%"
;MSGBOX,,DEBUG, From DRAKE-FUNCTIONS(INITIALIZATION):`n%iniFile%`n%Settings_rootFolder%`n%Settings_pathToFCXE%`n%Settings_FCXEParams%

global currentWorkingProject
projectPath := Settings_rootFolder . "\PRIVATE\CurrentWorkingProject.txt"
FileReadLine, currentWorkingProject, %Settings_rootFolder%\PRIVATE\CurrentWorkingProject.txt, 1
;MsgBox,,DEBUG FROM DRAKE, %currentWorkingProject%
;===== END OF AUTO-EXECUTE =====================================================================
;===== MODIFIER MEMORY HELPER ==================================================================
; combine below with key and '::' to define hotkey
; e.g.- ^f1::Msgbox You pressed Control and F1
; #=Win | !=Alt | ^=Ctrl | +=Shift | &=combine keys | *=ignore other mods
; <=use left mod key| >=use right mod key  | UP=fires on release

;===== FUNCTIONS ===============================================================================
;
Exiting(tipContent,pleasePrepend)
{
  global currentWorkingProject
  if (pleasePrepend=1) {
    tipContent := currentWorkingProject . "\" . tipContent
  }
  ;MSGBOX, ,DEBUG, from Exiting()`ntipContent:%tipContent%`ncurrentWorkingProject:%currentWorkingProject%`npleasePrepend:%pleasePrepend%
  ToolTip, Opening %tipContent%
  Sleep, 3000
  ExitApp
  Return
  }

;===== START of TaranVH FUNCTIONS ================================================================
; The function below is used to navigate to folders in Windows Explorer windows, Save Dialogs, and Console Windows (cmd.exe)
;
; Here's what TaranVH had to say about where he got his inspiration:
;   BEGIN SAVAGE-FOLDER-NAVIGATION CODE!
;   I GOT MOST OF THIS CODE FROM HTTPS://AUTOHOTKEY.COM/DOCS/SCRIPTS/FAVORITEFOLDERS.HTM
;   AND MODIFIED IT TO WORK WITH ANY GIVEN KEYPRESS, RATHER THAN MIDDLE MOUSE CLICK AS IT HAD BEFORE.
;
InstantExplorer(f_path,pleasePrepend)
{
  global Settings_rootFolder

  send {SC0E8} ;SCAN CODE OF AN UNASSIGNED KEY. THIS IS NEEDED TO PREVENT THE ITEM FROM MERELY FLASHING ON THE TASK BAR, RATHER THAN OPENING THE FOLDER. DON'T ASK ME WHY, BUT THIS WORKS.

  ; I tweaked this bit below a little bit to work with my idea of 'currentWorkingProject'
  ; I just find it easier to refer to it this way & it provides a bit more flexibility
  ; Basically, if pleasePrepend is set to '1', then it will prepend the 'currentWorkingProject' path onto whatever is sent to the Function.
  ; If you want to visit a location outside of the currentWorkingProject, then you can set pleasePrepend to 0 and send the full path to your location.
;MSGBOX,,DEBUG, from InstantExplorer()`nf_path has a value: %f_path%
if (pleasePrepend = 1) {
    f_path = %currentWorkingProject%\%f_path%
  } else f_path = %currentWorkingProject%

;;;SUPER IMPORTANT: YOU NEED TO GO INTO WINDOWS' FOLDER OPTIONS > VIEW > AND CHECK "DISPLAY THE FULL PATH IN THE TITLE BAR" OR THIS WON'T WORK.
;;;UPDATE: THE INSTRUCTION ABOVE MIGHT BE OBSOLETE NOW, I'VE FIGURED OUT A BETTER WAY TO DO THIS SHIT

instantExplorerTryAgain: ; this is going to be triggered if the path you are trying to access does not exist.
; fUTURE iDEA - you could add an option in here to create the path if it didn't already exist...
if !FileExist(f_path)
{
	;MSGBOX,,DEBUG,, %f_path%`nNo such path exists`, but we will go down in folders until it does.,1.0
	if InStr(f_path, "\"){
		FoundPos := InStr(f_path, "\", , StartingPos := 0, Occurrence := 1)
		Length := StrLen(f_path)
		trimThis := Length - FoundPos
		NewString := SubStr(f_path, 1, FoundPos-1)
		f_path := NewString
		GOTO, instantExplorerTryAgain
	}
	else
	{
		MSGBOX,,DEBUG,, %f_path%`n`nNo such path exists.,1.0
		GOTO, instantExplorerEnd
	}
}

;f_path = %f_path%\ ;;THIS ADDS A \ AT THE VERY END OF THE FILE PATH, FOR THE SAKE OF OLD-STYLE SAVE AS DIALOUGE BOXES WHICH REQUIRE THEM IN ORDER TO UPDATE THE FOLDER PATH WHEN IT IS INSERTED INTO Edit1.

f_path := """" . f_path . """" ;THIS ADDS QUOTATION MARKS AROUND EVERYTHING SO THAT IT WORKS AS A STRING, NOT A VARIABLE.
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
			sleep 1

			WinActivate ahk_id %f_window_id%
			sleep 1
			ControlGetText, f_text, Edit2, ahk_id %f_window_id%
			sleep 1
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
			sleep 1
			; ACTIVATE THE WINDOW SO THAT IF THE USER IS MIDDLE-CLICKING
			; OUTSIDE THE DIALOG, SUBSEQUENT CLICKS WILL ALSO WORK:
			WinActivate ahk_id %f_window_id%
			; RETRIEVE ANY FILENAME THAT MIGHT ALREADY BE IN THE FIELD SO
			; THAT IT CAN BE RESTORED AFTER THE SWITCH TO THE NEW FOLDER:
			ControlGetText, f_text, Edit1, ahk_id %f_window_id%
			sleep 1
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
        sleep 1
        ; ACTIVATE THE WINDOW SO THAT IF THE USER IS MIDDLE-CLICKING
        ; OUTSIDE THE DIALOG, SUBSEQUENT CLICKS WILL ALSO WORK:
        WinActivate ahk_id %f_window_id%
        ; RETRIEVE ANY FILENAME THAT MIGHT ALREADY BE IN THE FIELD SO
        ; THAT IT CAN BE RESTORED AFTER THE SWITCH TO THE NEW FOLDER:
        ControlGetText, f_text, Edit1, ahk_id %f_window_id%
        sleep 1
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

Explorer_GetSelection(hwnd="") {
	WinGet, process, processName, % "ahk_id" hwnd := hwnd? hwnd:WinExist("A")
	WinGetClass class, ahk_id %hwnd%
	if (process = "explorer.exe")
		if (class ~= "Progman|WorkerW") {
			;;if you're on the desktop
			ControlGet, files, List, Selected Col1, SysListView321, ahk_class %class%
			Loop, Parse, files, `n, `r
			ToReturn .= A_Desktop "\" A_LoopField "`n"
	} else if (class ~= "(Cabinet|Explore)WClass") {
		for window in ComObjCreate("Shell.Application").Windows
			if (window.hwnd==hwnd)
				sel := window.Document.SelectedItems
		for item in sel
			ToReturn .= item.path "`n"
	}
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
	WinGet, process, processName, % "ahk_id" hwnd := hwnd? hwnd:WinExist("A")
	WinGetClass class, ahk_id %hwnd%
	if (process = "explorer.exe")
		if (class ~= "Progman|WorkerW") {
			;;IF YOU'RE ON THE DESKTOP
			ControlGet, files, List, Selected Col1, SysListView321, ahk_class %class%
			Loop, Parse, files, `n, `r
			ToReturn .= A_Desktop "\" A_LoopField "`n"
	} else if (class ~= "(Cabinet|Explore)WClass") {
		for window in ComObjCreate("Shell.Application").Windows
			if (window.hwnd==hwnd)
				lePath := window.Document.Folder.Self.Path
	}
return lePath
}

#IfWinActive

; tweaked the function below to keep it consistent with the FCXE functions futher down.
savePathForExplorer(pathToSave){
	FileDelete, %Settings_rootFolder%\PRIVATE\SavedExplorerAddress.txt
	FileAppend, %title%, %Settings_rootFolder%\PRIVATE\SavedExplorerAddress.txt
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
  FileDelete, %Settings_rootFolder%\PRIVATE\CurrentWorkingProject.txt
  FileAppend, %pathToSet%, %Settings_rootFolder%\PRIVATE\CurrentWorkingProject.txt
  MsgBox, 262208, Set NEW Current Working Project, The Current Working Project is NOW SET TO:`n%pathToSet%, 4
}

getCurrentWorkingProject() {
  projectPath := Settings_rootFolder . "\PRIVATE\CurrentWorkingProject.txt"
  FileReadLine, currentWorkingProject, %Settings_rootFolder%\PRIVATE\CurrentWorkingProject.txt, 1
  return currentWorkingProject
}
;===== FreeCommanderXE FUNCTIONS ==================================================================

; I use FreeCommanderXE (https://freecommander.com/) as my primary file manager. Windows Explorer is lacking in many areas. I find FreeCommanderXE gives me a lot of support in those areas and makes things quicker & easier.
;
; While there are lots of keyboard commands within FreeCommanderXE, I found that if you are just opening locations, it was quicker to send it via the commandline interface that already exists in the app.

openFCXE(pathToOpen, pleasePrepend){
	global Settings_pathToFCXE
	global Settings_FCXEParams
  global currentWorkingProject
  if (pleasePrepend = 1) {
      pathToOpen = %currentWorkingProject%\%pathToOpen%
    }
    pathToOpen := """" . pathToOpen . """" ;THIS ADDS QUOTATION MARKS AROUND EVERYTHING SO THAT IT WORKS AS A STRING, NOT A VARIABLE.
    ;MSGBOX,,DEBUG, from openFCXE()`npathToOpen has a value: %pathToOpen%
  Run, %Settings_pathToFCXE% %Settings_FCXEparams%%pathToOpen%
	Return
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

savePathForFCXE(savedPath){
  global Settings_rootFolder
  FileDelete, %Settings_rootFolder%\PRIVATE\SavedPathForFCXE.txt
	FileAppend, %savedPath%, %Settings_rootFolder%\PRIVATE\SavedPathForFCXE.txt
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

setWorkingProject() {
  global Settings_rootFolder
  getFCXEPath()
  ;MSGBOX,,DEBUG, %Settings_rootFolder%\PRIVATE\CurrentWorkingProject.txt
  FileDelete, %Settings_rootFolder%\PRIVATE\CurrentWorkingProject.txt
  FileCopy, %Settings_rootFolder%\PRIVATE\SavedPathForFCXE.txt, %Settings_rootFolder%\PRIVATE\CurrentWorkingProject.txt
}

getWorkingProject() {
  global currentWorkingProject
  return currentWorkingProject
}
