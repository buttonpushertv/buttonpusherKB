iniFile := "C:\BPTV-KB\settings.ini"
IniRead, Settings_rootFolder, %iniFile%, Settings, rootFolder
;MsgBox, From FCXE-FUNCTIONS(INITIALIZATION):`n%iniFile%`n%Settings_rootFolder%

InstantExplorer(f_path,pleasePrepend := 0)
{
  global Settings_rootFolder

  send {SC0E8} ;scan code of an unassigned key. This is needed to prevent the item from merely FLASHING on the task bar, rather than opening the folder. Don't ask me why, but this works.

if pleasePrepend = 1 ;i think this is for the changeable stream deck folder shortcuts
	{
	FileRead, SavedExplorerAddress, %Settings_rootFolder%\PERSONAL\SavedExplorerAddress.txt
  if f_path {
    f_path = %SavedExplorerAddress%\%f_path%
  } else f_path = %SavedExplorerAddress%
  }
;MsgBox, %f_path%

;;;SUPER IMPORTANT: YOU NEED TO GO INTO WINDOWS' FOLDER OPTIONS > VIEW > AND CHECK "DISPLAY THE FULL PATH IN THE TITLE BAR" OR THIS WON'T WORK.
;;;UPDATE: THE INSTRUCTION ABOVE MIGHT BE OBSOLETE NOW, I'VE FIGURED OUT A BETTER WAY TO DO THIS SHIT

instantExplorerTryAgain:
if !FileExist(f_path)
{
	MsgBox,,, %f_path%`nNo such path exists`, but we will go down in folders until it does.,1.0

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
		MsgBox,,, %f_path%`n`nNo such path exists.,1.0
		GOTO, instantExplorerEnd
	}
}

f_path = %f_path%\ ;;THIS ADDS A \ AT THE VERY END OF THE FILE PATH, FOR THE SAKE OF OLD-STYLE SAVE AS DIALOUGE BOXES WHICH REQUIRE THEM IN ORDER TO UPDATE THE FOLDER PATH WHEN IT IS INSERTED INTO Edit1.

f_path := """" . f_path . """" ;this adds quotation marks around everything so that it works as a string, not a variable.

; These first few variables are set here and used by f_OpenFavorite:
WinGet, f_window_id, ID, A
WinGetClass, f_class, ahk_id %f_window_id%
WinGetTitle, f_title, ahk_id %f_window_id% ;to be used later to see if this is the export dialouge window in Premiere...
if f_class in #32770,ExploreWClass,CabinetWClass  ; if the window class is a save/load dialog, or an Explorer window of either kind.
	ControlGetPos, f_Edit1Pos, f_Edit1PosY,,, Edit1, ahk_id %f_window_id%

if f_path =
	return
if f_class = #32770    ; It's a dialog.
	{
	if WinActive("ahk_exe Adobe Premiere Pro.exe")
		{
		tooltip, you are inside of premiere

		if (f_title = "Export Settings") or if (f_title = "Link Media")
			{
			msgbox,,,you are in Premiere's export window or link media window, but NOT in the "Save as" inside of THAT window. no bueno, 1
			GOTO, instantExplorerEnd
			;return ;no, I don't want to return because i still want to open an explorer window.
			}

		If InStr(f_title, "Link Media to") ;Note that you must have "use media browser to locate files" UNCHECKED because it is GARBAGE.
			{
			tooltip, you are inside Premieres relinker.
			; This requires custom code, because the EditX boxes are different:
			; last path   = Edit1
			; filename    = Edit2
			; address bar = Edit3

			ControlFocus, Edit2, ahk_id %f_window_id%

			tooltip, you are inside the link media thingy
			sleep 1

			WinActivate ahk_id %f_window_id%
			sleep 1
			ControlGetText, f_text, Edit2, ahk_id %f_window_id%
			sleep 1
			ControlSetText, Edit2, %f_path%, ahk_id %f_window_id%
			ControlSend, Edit2, +{Enter}, ahk_id %f_window_id%
			Sleep, 100  ; It needs extra time on some dialogs or in some cases.
			ControlSetText, Edit2, %f_text%, ahk_id %f_window_id%
			;msgbox, AFTER:`n f_path: %f_path%`n f_class:  %f_class%`n f_Edit1Pos:  %f_Edit1Pos%

			tooltip,
			return
			}

		if (f_title = "Save As") or if (f_title = "Save Project")
			{
			ControlFocus, Edit1, ahk_id %f_window_id%
			tooltip, you are here
			sleep 1
			; Activate the window so that if the user is middle-clicking
			; outside the dialog, subsequent clicks will also work:
			WinActivate ahk_id %f_window_id%
			; Retrieve any filename that might already be in the field so
			; that it can be restored after the switch to the new folder:
			ControlGetText, f_text, Edit1, ahk_id %f_window_id%
			sleep 1
			ControlSetText, Edit1, %f_path%, ahk_id %f_window_id%
			ControlSend, Edit1, +{Enter}, ahk_id %f_window_id%
			Sleep, 100  ; It needs extra time on some dialogs or in some cases.
			ControlSetText, Edit1, %f_text%, ahk_id %f_window_id%
			tooltip,
			return
			}
		}

	; stuff beyond here is NOT in premiere
	if f_Edit1Pos <>   ; And it has an Edit1 control.
		{
		ControlFocus, Edit1, ahk_id %f_window_id% ;this is really important.... it doesn't work if you don't do this...
		; Activate the window so that if the user is middle-clicking
		; outside the dialog, subsequent clicks will also work:
		WinActivate ahk_id %f_window_id%
		; Retrieve any filename that might already be in the field so
		; that it can be restored after the switch to the new folder:
		ControlGetText, f_text, Edit1, ahk_id %f_window_id%
		sleep 2
		ControlSetText, Edit1, %f_path%, ahk_id %f_window_id%
		sleep 3
		ControlSend, Edit1, {Enter}, ahk_id %f_window_id%
		Sleep, 1000  ; It needs extra time on some dialogs or in some cases.

		;now RESTORE the filename in that text field. I don't like doing it this way...
		ControlSetText, Edit1, %f_text%, ahk_id %f_window_id%
		;msgbox, AFTER:`n f_path: %f_path%`n f_class:  %f_class%`n f_Edit1Pos:  %f_Edit1Pos%
		sleep 2
		ControlFocus, DirectUIHWND2, ahk_id %f_window_id% ;to try to get the focus back into the center area, so you can now type letters and have it go to a file or fodler, rather than try to SEARCH or try to change the FILE NAME by default.
		return
		}
	; else fall through to the bottom of the subroutine to take standard action.
	}

else if f_class = ConsoleWindowClass ; In a console window, CD to that directory
	{
	WinActivate, ahk_id %f_window_id% ; Because sometimes the mclick deactivates it.
	SetKeyDelay, 0  ; This will be in effect only for the duration of this thread.
	IfInString, f_path, :  ; It contains a drive letter
		{
		StringLeft, f_path_drive, f_path, 1
		Send %f_path_drive%:{enter}
		}
	Send, cd %f_path%{Enter}
	return
	}
ending2:
; Since the above didn't return, one of the following is true:
; 1) It's an unsupported window type but f_AlwaysShowMenu is y (yes).
; 2) It's a supported type but it lacks an Edit1 control to facilitate the custom
;    action, so instead do the default action below.

	Run, %f_path%  ; I got rid of the "Explorer" part because it caused redundant windows to be opened, rather than just switching to the existing window

instantExplorerEnd:
tooltip,
}
;end of instantexplorer()


;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;This friggin beautiful code is from this thread:
;https://autohotkey.com/board/topic/121208-windows-explorer-get-folder-path/?p=687189
;another version of this function exists in filemover.ahk , but i think it's not used at all, lol.

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
; ; ;How to call the above function
; ; F12::
; ; pathAndName := Explorer_GetSelection()
; ; ;SplitPath, pathAndName, fn
; ; SplitPath, pathAndName, nameOnly ,thePath
; ; MsgBox % "FileName :`t" nameOnly "`nPath :`t" thePath "`nFullName :`t" pathAndName
; ; clipboard = % thePath
; ; SoundBeep, 500, 200
; ; return

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

;This one does not require you to select an item in the folder in order to work! Unfortunately, it does NOT work on Save As dialogs for whatever reason.
;; code was gotten from here https://autohotkey.com/board/topic/121208-windows-explorer-get-folder-path/?p=687189
;; and here https://www.autohotkey.com/boards/viewtopic.php?p=28751#p28751
Explorer_GetPath(hwnd="") {
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
				lePath := window.Document.Folder.Self.Path
	}
return lePath
}

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#IfWinActive

saveLocation2(){
  global Settings_rootFolder
f_text = 0
SetTitleMatchMode Slow
WinGet, f_window_id, ID, A
WinGetClass, f_class, ahk_id %f_window_id%
if f_class in ExploreWClass,CabinetWClass ;;,#32770 ; if the window class is an Explorer window of either kind.
	{
	thePath := Explorer_GetPath()
	title = % thePath

	FileDelete, %Settings_rootFolder%\PERSONAL\SavedExplorerAddress.txt
	FileAppend, %title% , %Settings_rootFolder%\PERSONAL\SavedExplorerAddress.txt
	SavedExplorerAddress = %title%
	msgbox, , , %title%`n`nwas saved as %Settings_rootFolder%\PERSONAL\SavedExplorerAddress.txt, 5
	}
else
	msgbox,,, this is PROBABLY not an explorer window you chump,0.5
;for some reason, after this script runs, it sometimes activates the last active window. It doesn't make any sense...
}
;for further reading:
;https://autohotkey.com/board/topic/60985-get-paths-of-selected-items-in-an-explorer-window/
;end of savelocation2()
