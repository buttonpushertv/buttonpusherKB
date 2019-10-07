; AutoHotKey - Buttonpusher Post-Production Keyboard Environment - Master Script
; by Ben Howard - ben@buttonpusher.tv
;
;based on the "FavoritesFolders" script by Savage - (https://www.autohotkey.com/docs/scripts/FavoriteFolders.htm)

;===== START OF AUTO-EXECUTION SECTION =========================================================
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; #Persistent ; Keeps script permanently running.
#SingleInstance force ; Ensures that there is only a single instance of this script running.
; SetTitleMatchMode, 2 ; sets title matching to search for "containing" instead of "exact"
;#MaxHotkeysPerInterval 2000
;#WinActivateForce ;https://autohotkey.com/docs/commands/_WinActivateForce.htm


Menu, Tray, Icon, shell32.dll, 111 ; this changes the tray icon to a folder with a menu
;===== INITIALIZATION - VARIABLES ==============================================================
; Sleep shortcuts - use these to standardize sleep times. Change here to change everywhere.
sleepMicro := 15
sleepShort := 333
sleepMedium := 666
sleepLong := 1500
sleepDeep := 3500

iniFile := "..\settings.ini"
IniRead, Settings_rootFolder, %iniFile%, Settings, rootFolder
IniRead, Settings_pathToFCXE, %iniFile%, Settings, pathToFCXE
;IniRead, Settings_FCXEParams, %iniFile%, Settings, FCXEParams ; reading these from settings will open in the same tab as DRAKE scripts. The value below will put them in the other tab. Swap the commenting to change this behavior.
Settings_FCXEParams := "/C /L=" ; this should open the location in the upper pane of FCXE
Settings_pathToFCXE = "%Settings_pathToFCXE%"

; The ScreenSpacing variables below place the splash screens across all scripts loaded after MASTER-SCRIPT.ahk
splashScreenX = %1%
splashScreenY = %2%
splashScreenTimeout = %3%

;===== SPLASH SCREEN TO ANNOUNCE WHAT SCRIPT DOES ==============================================
SplashTextOn, 600, 100, Launching %A_ScriptFullPath%, Loading FavoritesMenu - SHIFT-MIDDLE-MOUSE to open menu of Favorites`n(Define more within the script itself...soon moving to settings.ini)
WinMove, Launching %A_ScriptFullPath%, , %splashScreenX%, %splashScreenY%
SetTimer, RemoveSplashScreen, %splashScreenTimeout%
;===== END OF AUTO-EXECUTE =====================================================================
;===== MODIFIER MEMORY HELPER ==================================================================
; combine below with key and '::' to define hotkey
; e.g.- ^f1::Msgbox You pressed Control and F1
; #=Win | !=Alt | ^=Ctrl | +=Shift | &=combine keys | *=ignore other mods
; <=use left mod key| >=use right mod key  | UP=fires on release


; Easy Access to Favorite Folders -- by Savage
; http://www.autohotkey.com
; When you click the middle mouse button while certain types of
; windows are active, this script displays a menu of your favorite
; folders.  Upon selecting a favorite, the script will instantly
; switch to that folder within the active window.  The following
; window types are supported: 1) Standard file-open or file-save
; dialogs; 2) Explorer windows; 3) Console (command prompt) windows.
; The menu can also be optionally shown for unsupported window
; types, in which case the chosen favorite will be opened as a new
; Explorer window.

; Note: In Windows Explorer, if "View > Toolbars > Address Bar" is
; not enabled, the menu will not be shown if the hotkey chosen below
; has a tilde.  If it does have a tilde, the menu will be shown
; but the favorite will be opened in a new Explorer window rather
; than switching the active Explorer window to that folder.

; CONFIG: CHOOSE YOUR HOTKEY
; If your mouse has more than 3 buttons, you could try using
; XButton1 (the 4th) or XButton2 (the 5th) instead of MButton.
; You could also use a modified mouse button (such as ^MButton) or
; a keyboard hotkey.  In the case of MButton, the tilde (~) prefix
; is used so that MButton's normal functionality is not lost when
; you click in other window types, such as a browser.  The presence
; of a tilde tells the script to avoid showing the menu for
; unsupported window types.  In other words, if there is no tilde,
; the hotkey will always display the menu; and upon selecting a
; favorite while an unsupported window type is active, a new
; Explorer window will be opened to display the contents of that
; folder.
f_Hotkey = +MButton

; CONFIG: CHOOSE YOUR FAVORITES
; Update the special commented section below to list your favorite
; folders.  Specify the name of the menu item first, followed by a
; semicolon, followed by the name of the actual path of the favorite.
; Use a blank line to create a separator line.

/*
ITEMS IN FAVORITES MENU <-- Do not change this string.
:F:\Client Media	;	F:\Client Media
:F:\Dropfolder	;	F:\Dropfolder
:F:\EDIT2 ELEMENTS	;	F:\EDIT2 ELEMENTS

D:\Dropbox (postopmedia)	;	D:\Dropbox (postopmedia)
D:\Dropbox (postopmedia)\EDIT2\_CLIENT MEDIA_	;	D:\Dropbox (postopmedia)\EDIT2\_CLIENT MEDIA_



:PostHaste Templates ; C:\Users\ben\OneDrive\Documents\Digital Rebellion\Post Haste\Templates
:AE Scripts(2019) ; C:\Program Files\Adobe\Adobe After Effects CC 2019\Support Files\Scripts

>Backup PERSONAL ; %Settings_rootFolder%\BAT-FILES\PERSONAL-BACKUP.CMD
*/


; END OF CONFIGURATION SECTION
; Do not make changes below this point unless you want to change
; the basic functionality of the script.

Hotkey, %f_Hotkey%, f_DisplayMenu
StringLeft, f_HotkeyFirstChar, f_Hotkey, 1
if f_HotkeyFirstChar = ~  ; Show menu only for certain window types.
	f_AlwaysShowMenu = n
else
	f_AlwaysShowMenu = y

; Used to reliably determine whether script is compiled:
SplitPath, A_ScriptName,,, f_FileExt
if f_FileExt = Exe  ; Read the menu items from an external file.
	f_FavoritesFile = %A_ScriptDir%\Favorites.ini
else  ; Read the menu items directly from this script file.
	f_FavoritesFile = %A_ScriptFullPath%

;----Read the configuration file.
f_AtStartingPos = n
f_MenuItemCount = 0
Loop, Read, %f_FavoritesFile%
{
	if f_FileExt <> Exe
	{
		; Since the menu items are being read directly from this
		; script, skip over all lines until the starting line is
		; arrived at.
		if f_AtStartingPos = n
		{
			IfInString, A_LoopReadLine, ITEMS IN FAVORITES MENU
				f_AtStartingPos = y
			continue  ; Start a new loop iteration.
		}
		; Otherwise, the closing comment symbol marks the end of the list.
		if A_LoopReadLine = */
			break  ; terminate the loop
	}
	; Menu separator lines must also be counted to be compatible
	; with A_ThisMenuItemPos:
	f_MenuItemCount++
	if A_LoopReadLine =  ; Blank indicates a separator line.
		Menu, Favorites, Add
	else
	{
		StringSplit, f_line, A_LoopReadLine, `;
		f_line1 = %f_line1%  ; Trim leading and trailing spaces.
		f_line2 = %f_line2%  ; Trim leading and trailing spaces.
		; Resolve any references to variables within either field, and
		; create a new array element containing the path of this favorite:
		Transform, f_path%f_MenuItemCount%, deref, %f_line2%
		Transform, f_line1, deref, %f_line1%
		Menu, Favorites, Add, %f_line1%, f_OpenFavorite
	}
}
return  ;----End of auto-execute section.


;----Open the selected favorite
f_OpenFavorite:
; Fetch the array element that corresponds to the selected menu item:
StringTrimLeft, f_path, f_path%A_ThisMenuItemPos%, 0
if f_path =
	return

if f_class contains FreeCommander ; in FCXE
{
  Run, %Settings_pathToFCXE% %Settings_FCXEparams%"%f_path%"
  return
}
else if f_class = #32770    ; It's a dialog.
{
	if f_Edit1Pos <>   ; And it has an Edit1 control.
	{
		; Activate the window so that if the user is middle-clicking
		; outside the dialog, subsequent clicks will also work:
		WinActivate ahk_id %f_window_id%
		; Retrieve any filename that might already be in the field so
		; that it can be restored after the switch to the new folder:
		ControlGetText, f_text, Edit1, ahk_id %f_window_id%
		ControlSetText, Edit1, %f_path%, ahk_id %f_window_id%
		ControlSend, Edit1, {Enter}, ahk_id %f_window_id%
		Sleep, 100  ; It needs extra time on some dialogs or in some cases.
		ControlSetText, Edit1, %f_text%, ahk_id %f_window_id%
		return
	}
	; else fall through to the bottom of the subroutine to take standard action.
}
else if f_class in ExploreWClass,CabinetWClass  ; In Explorer, switch folders.
{
	if f_Edit1Pos <>   ; And it has an Edit1 control.
	{
		ControlSetText, Edit1, %f_path%, ahk_id %f_window_id%
		; Tekl reported the following: "If I want to change to Folder L:\folder
		; then the addressbar shows http://www.L:\folder.com. To solve this,
		; I added a {right} before {Enter}":
		ControlSend, Edit1, {Right}{Enter}, ahk_id %f_window_id%
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
; Since the above didn't return, one of the following is true:
; 1) It's an unsupported window type but f_AlwaysShowMenu is y (yes).
; 2) It's a supported type but it lacks an Edit1 control to facilitate the custom
;    action, so instead do the default action below.
Run, "%f_path%"  ; Might work on more systems without double quotes.
return


;----Display the menu
f_DisplayMenu:
; These first few variables are set here and used by f_OpenFavorite:
WinGet, f_window_id, ID, A
WinGetClass, f_class, ahk_id %f_window_id%
if f_class in #32770,ExploreWClass,CabinetWClass  ; Dialog or Explorer.
	ControlGetPos, f_Edit1Pos,,,, Edit1, ahk_id %f_window_id%
if f_AlwaysShowMenu = n  ; The menu should be shown only selectively.
{
	if f_class in #32770,ExploreWClass,CabinetWClass  ; Dialog or Explorer.
	{
		if f_Edit1Pos =  ; The control doesn't exist, so don't display the menu
			return
	}
	else if f_class <> ConsoleWindowClass
		return ; Since it's some other window type, don't display menu.
}
; Otherwise, the menu should be presented for this type of window:
Menu, Favorites, show
return

;===== FUNCTIONS ===============================================================================

RemoveSplashScreen:
    SplashTextOff
    SetTimer RemoveSplashScreen, Off
    return
