; AutoHotKey - Buttonpusher Post-Production Keyboard Environment - Master Script
; by Ben Howard - ben@buttonpusher.tv
;
; portions copied from TaranVH's 2nd-keyboard project (https://github.com/TaranVH/2nd-keyboard)

;===== START OF AUTO-EXECUTION SECTION =========================================================
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent ; Keeps script permanently running.
#SingleInstance force ; Ensures that there is only a single instance of this script running.
SetTitleMatchMode, 2 ; sets title matching to search for "containing" instead of "exact"
#InstallKeybdHook        ;Recent Window 10 updates have started getting the Alt key stuck down,
#UseHook On              ;but only in AutoHotKey. These 3 commands are an attempt to fix that.
#HotkeyModifierTimeout 0 ;It's not clear if this completely fixes it.

Menu, Tray, Icon, imageres.dll, 187 ;tray icon is now a little keyboard, or piece of paper or something

#MenuMaskKey vk07 ; This is needed to block the Window key from triggering the Start Menu when pressed by itself.

if not A_IsAdmin
	Run *RunAs "%A_ScriptFullPath%" ; (A_AhkPath is usually optional if the script has the .ahk extension.) You would typically check first.

FileEncoding, UTF-8 ; this is here to make sure any files that we need to work with get created/opened/read as UTF-8

; The 2 lines below pertain to the 'reload on save' function below (CheckScriptUpdate).
; They are required for it to work.
;FileGetTime ScriptStartModTime, %A_ScriptFullPath%
;SetTimer CheckScriptUpdate, 100, 0x7FFFFFFF ; 100 ms, highest priority
; AUTO-RELOAD ON SAVE DISABLED - UNCOMMENT 2 LINES ABOVE TO RE-ENABLE
; SEE THE FUNCTION BELOW FOR MORE INFO

#Include %A_ScriptDir%\MASTER-FUNCTIONS.ahk

; IMPORTANT NOTE ++ IMPORTANT NOTE ++ IMPORTANT NOTE ++ IMPORTANT NOTE ++ IMPORTANT NOTE ++ 
; 
; All references to the root folder of this suite require an OS-level Environment Variable.
; When you first launch the BKB-startup.ahk script, it will help you create that Environment Variable in a permanent fashion on your system.
;
;===== INITIALIZATION - VARIABLES ==============================================================
; Sleep shortcuts - use these to standardize sleep times. Change here to change everywhere.
sleepMicro := 5
sleepMini := 15
sleepShort := 333
sleepMedium := 666
sleepLong := 1500
sleepDeep := 3500

halfScreenWidth := (A_ScreenWidth / 2) ; determine what half the screen's width is for splash screens
quarterScreenHeight := (A_ScreenHeight / 4) ; determine what 1/4 the screen's height is for splash screens

global iniFile := "settings.ini" ; the main settings file used by most of the buttonpusherKB scripts
global versionFile := "version.ini" ; the file which holds the current version of buttonpusherKB
global version ; creating a global variable for the version info
global Settings_rootFolder

global CapsLockCounter := 0 ; initial value for the CapsLock detection code below

SetCapsLockState, off ; turn off CapsLock so that the checking function doesn't go off automatically
SetScrollLockState, off ; since we're hacking ScrollLock to become a modifier key, we pretty much want it turned off all the time. This turns it off on script load. Most of the uses with this hacked-modifier will re-load the scripts.

; These 2 INI_ function calls will load the settings.ini info and load in the sections relevant for this script
INI_Init(iniFile)
INI_Load(iniFile)

FileRead, version, %versionFile% ; reading the version from versionFile

currentSystemLocationName := % Location_systemLocation%Location_currentSystemLocation%
global daysSinceLastBackupFile := "PRIVATE\" . currentSystemLocationName . "\days_since_system_backup.txt"
global daysSinceLastBackup
FileRead, daysSinceLastBackup, %daysSinceLastBackupFile%
daysSinceLastBackupText := "Days since last backup: " . daysSinceLastBackup
;MSGBOX, , DEBUG,section1_key1: %section1_key1%`ncurrentSelectedSystemLocation: %currentSelectedSystemLocation%`nLocation_currentSystemLocation: %Location_currentSystemLocation%`ncurrentSystemLocationName: %currentSystemLocationName%`ndaysSinceLastBackupFile: %daysSinceLastBackupFile%`ndaysSinceLastBackup: %daysSinceLastBackup%

launchAppGuiWidth := 850
launchAppKeyRows := (section2_keys / 3)
launchAppGuiHeight := ((launchAppKeyRows * 25) + 140)
If (launchAppGuiHeight < 330) {
	launchAppGuiHeight := 330
}
launchGuiBottomRowYpos := (launchAppGuiHeight - 57)
launchAppGuiColTwoStartingXpos := 270

; It seems that sometimes the BKB-Startup.ahk get stuck exiting or doesn't quit where it supposed to. This code block should see it and close it.
DetectHiddenWindows, On
BKBstartupPath := "BKB-startup"
IfWinExist,,%BKBstartupPath%
{
	MsgBox, 262144,, Found %BKBstartupPath%
	WinClose, %BKBstartupPath%
}
DetectHiddenWindows, Off

; ===== CREATE GUI FOR SPLASH SCREEN ITEMS HERE
Gui, +AlwaysOnTop
Gui, launchApp:Add, Text, section x0 y0,
Gui, launchApp:Color, FFFFFF
Gui, launchApp:Add, Picture, xs ys , SUPPORTING-FILES\BPS-Logo-PLUS-KB-240x275.png
Gui, launchApp:Font, S10 italic, %Settings_guiFont%
Gui, launchApp:Add, Text, xs+60 y%launchGuiBottomRowYpos%, %version%
Gui, launchApp:Add, Text, xp yp+20, %daysSinceLastBackupText%
Gui, launchApp:Font, norm
Gui, launchApp:Add, Text, x%launchAppGuiColTwoStartingXpos% yp-20, Press CAPS+F11 for Settings  |  Press CAPS+Q to Quit Running Scripts 
Gui, launchApp:Add, Text, x%launchAppGuiColTwoStartingXpos% yp+20, Press CAPS+F12 for buttonpusherKB Launcher
Gui, launchApp:Show, w%launchAppGuiWidth% h%launchAppGuiHeight%, Launching AHK Scripts
Gui, launchApp:Font, S18 norm bold
Gui, launchApp:Add, Text, x%launchAppGuiColTwoStartingXpos% ys+10 w450, Scripts Being Launched
Gui, launchApp:Font, S12 norm
; ===== LAUNCH STANDALONE SCRIPTS HERE
Gui, launchApp:Add, Text, section xp+10 yp+10,
; section2_keys is read from settings.ini
loop, %section2_keys% ; this loop will launch any scripts that are defined and enabled in settings.ini
{
    currentKey := % section2_key%A_Index%
    pathLookAhead := A_Index + 1
	nameLookAhead := A_Index + 2
    pathKey := % section2_key%pathLookAhead%
	nameKey := % section2_key%nameLookAhead%
    currentKeyValue := %section2%_%currentKey%
    currentPathValue := Settings_rootFolder . "\" . %section2%_%pathKey%
	currentNameValue := %section2%_%nameKey%
	currentSystemLocationName := % Location_systemLocation%Location_currentSystemLocation%
    currentKeyLeft7 := SubStr(currentKey, 1, 7)
    If (currentKeyLeft7 = "loadScr") {
        If (currentKeyValue) {
            If !FileExist(currentPathValue) {
              MsgBox The App could not be found at %currentPathValue%
              continue
              }
            else {
			Gui, launchApp:Font, S12
			Gui, launchApp:Add, Text, xs+25 yp+35, %currentNameValue%
            Run, %currentPathValue% %Location_currentSystemLocation% %currentSystemLocationName%,, UseErrorLevel, justLaunchedPID
			If !ErrorLevel {
				Gui, launchApp:Font, S14 CGreen
				Gui, launchApp:Add, Text, xs yp-2, % Chr(0x2713)
				Gui, launchApp:Font, S10 CBlack
			} else {
				Gui, launchApp:Font, S14 CRed
				Gui, launchApp:Add, Text, xs yp-2, % Chr(0x2713)
				Gui, launchApp:Font, S10 CBlack
			}
            Gui, launchApp:Show,, Launching %currentNameValue%
			DetectHiddenWindows, Off
            }
        }
        else {
            Continue
            }
        pathKey :=
        currentKeyValue :=
        currentPathValue :=
    }
    else
    Continue
}
Gui, launchApp:Show,, All Scripts Have Been Launched...Enjoy!
Sleep, Settings_splashScreenTimeout

goto launchAppTimeout

SetTimer, CapsLockCheck, %Settings_CapsLockCheckPeriod% ; the main timer to check for CapsLock. The variable 'Settings_CapsLockCheckPeriod' is defined in settings.ini. More info about this Function is in comments down in the Function Definition at the end of this script.

;===== END OF AUTO-EXECUTE =====================================================================
;===== MODIFIER MEMORY HELPER ==================================================================
; combine below with key and '::' to define hotkey
; e.g.- ^f1::Msgbox You pressed Control and F1
; #=Win | !=Alt | ^=Ctrl | +=Shift | &=combine keys | *=ignore other mods
; <=use left mod key| >=use right mod key  | UP=fires on release
;
; After each Hotkey Defintion, place a comment using this format:
; {hotkeyDef}:: ; <-- Define what HotKey does.
;
;   This will be read by \buttonpusherKB\UTIL-APPS\Hotkey Help.ahk to create a text cheat sheet of all HotKeys & Definitons. This text file can be used to create the Cheat Sheets shown with CAPS+F1, etc.
;===== MAIN HOTKEY DEFINITIONS HERE ============================================================
GroupAdd, altBlocked, ahk_exe Adobe Premiere Pro.exe ; items added to the group called 'altBlocked' will have the LAlt key blocked from triggering the menu selection

~LWin::Send {Blind}{vk07} ; <-- Blocks Left Window key from triggering the Start Menu when pressed by itself. The Right Window key will still work in the default fashion.

#IfWinActive, ahk_group altBlocked
; don't know if this works for alt too...
~LAlt:: ; <-- Blocks Left Alt key from triggering the menus when pressed by itself. The Right Alt key will still work in the default fashion.
    sendinput, {SC07E down}
    KeyWait, LAlt
    Return

~LAlt up:: ; <-- Part of blocking Left Alt Key from triggering menus
		sendinput, {SC07E up}
		return

#IfWinActive

; There are 2 hotkeys defined for the Hotkeys below because on my split keyboard it's easier to use ScrollLock & on my Kira/Preonic keyboards it's easier to use CapsLock.

ScrollLock & f11:: ; <-- Open the Settings GUI for MASTER-SCRIPT.AHK
CapsLock & f11:: ; <-- Open the Settings GUI for MASTER-SCRIPT.AHK
		ScrollLockOff()
		Run, %A_ScriptDir%\MASTER-SETTINGS.AHK ; runs the settings configuration script for the whole suite.
		SetCapsLockState, Off
    return

ScrollLock & f12:: ; <-- Open buttonpusherLAUNCHER
CapsLock & f12:: ; <-- Open buttonpusherLAUNCHER
		ScrollLockOff()
		Run, %A_ScriptDir%\BKB-LAUNCHER.ahk ; runs the launcher that runs at boot. Should only be used if you are making changes to what gets run at boot or if anything stops working properly
		SetCapsLockState, Off
    return

ScrollLock & Backspace:: ; <-- Reload MASTER-SCRIPT.ahk
CapsLock & Backspace:: ; <-- Reload MASTER-SCRIPT.ahk
		Reload ; reloads the MASTER-SCRIPT.ahk - will also force a reload of any other script that is set to load when MASTER-SCRIPT runs
		SetCapsLockState, Off
    Return

CapsLock & WheelDown::Send ^{PGDN} ; <-- Send Control+Page Down - for changing tabs in apps that support it (Chrome, Atom)
CapsLock & WheelUp::Send ^{PGUP} ; <-- Send Control+Page Up - for changing tabs in apps that support it (Chrome, Atom)

CapsLock & F:: ; <-- This will open the selected OR active path from an Explorer Window or Save/Open Dialog in FreeCommander OR VICE-VERSA
	WinGetActiveTitle, activeTitle
	If activeTitle contains FreeCommander ; checking to see if you might already be sitting in FreeCommander
	{
		Run, %A_ScriptDir%\SCRIPTS-UTIL\STREAMDECK\DRAKE\sendPATHtoEXPLORER.ahk ; this will open the Drake script that gets the current FCXE path and sends to Explorer
	}
	Else
	{
		Run, %A_ScriptDir%\SCRIPTS-UTIL\STREAMDECK\DRAKE\sendPATHtoFCXE.ahk ; this gets the active Explorer Window's path and sends to FCXE
	}
	SetCapsLockState, Off
	Return

CapsLock & G:: ; <-- This will return the selected OR active path from an Explorer Window/Save/Open Dialog OR FCXE in a MsgBox
	Run, %A_ScriptDir%\SCRIPTS-UTIL\STREAMDECK\DRAKE\getPATH.ahk
	SetCapsLockState, Off
	Return

CapsLock & H:: ; <-- Run HotKeyHelp.ahk
	Run, "%A_ScriptDir%\SCRIPTS-UTIL\Hotkey Help.ahk"
	SetCapsLockState, Off
	Return
	
CapsLock & L:: ; <-- This will launch BKB-LAUNCHX
    Run, %A_ScriptDir%\UTIL-APPS\BKB-LAUNCHX\launcher.ahk
	SetCapsLockState, Off
    Return

CapsLock & X:: ; <-- Backspace Key
	Send, {BackSpace} ; where you often are using one hand on mouse/trackball and one hand on keys the delete & backspace keys can be a long reach (or on right-half of split keyboard)
	SetCapsLockState, Off
return

CapsLock & Z:: ; <-- Delete Key
	Send, {Delete} ; where you often are using one hand on mouse/trackball and one hand on keys the delete & backspace keys can be a long reach (or on right-half of split keyboard)
	SetCapsLockState, Off
return

CapsLock & p:: ; <-- Toggle CapsLockCheck on or Off
; You may not always want to have this check running. This allows you to toggle it off or on and gives you a reminder ToolTip of it's state.
	If (IgnoreCapsCheck) {
		SetTimer, CapsLockCheck, %Settings_CapsLockCheckPeriod%
		IgnoreCapsCheck := 0
		ToolTip, CapsLock checking activated.
		RemoveToolTip(-2000)
		return
	} else {
	SetTimer, CapsLockCheck, Off
	IgnoreCapsCheck := 1
	ToolTip, CapsLock checking deactivated.
	RemoveToolTip(-2000)
	SetCapsLockState, Off
	return
	}

CapsLock & \:: ; <-- Exit MASTER-SCRIPT and child AHK Scripts
	goto Quitting ; this subroutine will ID any of the scripts that have been launched (via enabled in settings.ini) and then quit them all
return

CapsLock & M:: ;<--pingPos - just to show what it does
	tWidth := % Round(halfScreenWidth)
	tHeight := % Round(quarterScreenHeight)
	Run, %A_ScriptDir%\SCRIPTS-UTIL\pingPos.ahk %tWidth% %tHeight% "Screen"
	SetCapsLockState, Off
	Return

; USING THE HYPER KEY
; In Windows 10, Microsoft has hard-coded the HYPER Key (Control+Shift+Alt+Windows) to open the Office Hub. There some ways to remove that coding. They involve editing the Registry, so it's not something you should do lightly.
;
; You can learn about all of this here:
; https://www.howtogeek.com/445318/how-to-remap-the-office-key-on-your-keyboard/
;
; TLDR: Run Powershell as Admin & paste this code into it:
;
; REG ADD HKCU\Software\Classes\ms-officeapp\Shell\Open\Command /t REG_SZ /d rundll32
;
; That will stop the Hyper Key from opening the Office Hub & make it available to use as another modifier.
; If you still need to use the Office Hub, you can launch it via the Windows App icon (see below for a way to get it back as a HotKey).
; There are, however, several HYPER+key definitions that are more deeply hard-coded that may be more difficult to remove. These HYPER+keys are: T, Y, O, P, D, L, X, N, and Space.

/*
FWIW, Here are what the HYPER+keys do:
HYPER+D <-- Open your OneDrive in Explorer
HYPER+L <-- Open LinkedIn in browser
HYPER+N <-- Open OneNote
HYPER+O <-- Open Outlook
HYPER+P <-- Open PowerPoint
HYPER+T <-- Open Microsoft Teams
HYPER+W <-- Open Word
HYPER+X <-- Open Excel
HYPER+Y <-- Open Yammer
HYPER+Space <-- Open Emoji Menu
*/
;
; On that page linked above there is a very hackish way of removing them. Follow the instructions there if you wish. I have only done the RegEdit hack & blocked just the HYPER key opening Office Hub (as I can't really see a reason I'd want to use it.)
;
; As an example, here's how you would code a HYPER+key hotkey in AHK:
;#^!+F13::
;	MsgBox, You pressed HYPER + F13
;	Return

; You can even still open the Office Hub as a AHK hotkey. You need to get the AUMID (Aoplication User Model ID - aka Microsoft Store Apps unique identifiers). These are a pain to get. There are a few methods. This page (https://jcutrer.com/windows/find-aumid) lists several. The easiest is to use the BAT file method.
;
; In BKB\BAT-FILES, there is a BAT file called 'aumidsearch.bat' From a commandline, sitting in the BAT-FILES directory, type 'aumidsearch' + a space + your search term (in this case - 'aumidsearch office'). Copy the text that appears in the third column & paste after the 'Run' comnmand.

#^!+Q:: ; <-- Launches Office Hub
	ToolTip, Standby. Launching Office Hub. Release HYPER key quickly to prevent Office Hub from hiding itself.
	Sleep, sleepLong ; this Sleep is here to give you time to get your fingers off of the triggering keys. If Office Hub sees you press the HYPER combination while open, it will hide itself.
	Run shell:AppsFolder\Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe!Microsoft.MicrosoftOfficeHub
	Tooltip
	Return

#IfWinActive, ahk_exe Explorer.EXE

#^+f:: ; <-- Nuke Firefox
Run, %comspec% /c "taskkill.exe /F /IM firefox.exe",, hide
ToolTip, killed firefox
RemoveToolTip(-2000)
return

#^+p:: ; <-- Nuke Premiere
    Process, Exist, Adobe Premiere Pro.exe
    If (ErrorLevel > 0)
        PID = %ErrorLevel%
    Run, %comspec% /c "taskkill.exe /PID %PID% /T /F"
    ToolTip, killed premiere
    RemoveToolTip(-2000)
return

+^!p:: ; <-- Open selected file in Photoshop (only from Explorer Window)
	ClipSaved := ClipboardAll   ; Save the entire clipboard to a variable of your choice.
	; ... here make temporary use of the clipboard, such as for pasting Unicode text via Transform Unicode ...
	Clipboard =
	Send, ^c
	ClipWait
	Pfad = %Clipboard%
	;SplitPath, Pfad, Filename
	;msgbox, %Pfad%
	Clipboard := ClipSaved   ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
	ClipSaved =   ; Free the memory in case the clipboard was very large.  
	Run, "C:\Program Files\Adobe\Adobe Photoshop 2021\Photoshop.exe" "%Pfad%"
	WinActivate, ahk_exe Photoshop.exe
	Return

+^!S::Run "%Settings_pathToEditor%" "PRIVATE\MASTER-SCAF-KEYS.ahk" ; <-- Edit PRIVATE\MASTER-SCAF-KEYS.ahk
; Above edits master file of app-specific & one-off SCAF keys. Just keeping them in one place, so I don't need to create scripts for each and every app I want/need to make SCAF keys in. See comments in that file for more info
+^!Q::Run "%Settings_pathToEditor%" "PRIVATE\QUICKTYPE-HOTSTRINGS.ahk" ; <-- Edit PRIVATE\QUICKTYPE-HOTSTRINGS.ahk
; Above edits my Quicktype Hotstrings. These commands will do auto-replacment of commands as you type. See comments in SCRIPS-UTIL\QuickType.ahk & the above .txt file for more info

^Z:: ; <-- Interrupt Undo at the Explorer level to prevent undoing a file move/copy action. Windows *will not* alert you if you press undo immediately after a file move/copy that it is about to just undo the move/copy with no way to recover. This will protect against that behavior.
	WinGet, activeHwnd, ID, A
	MsgBox, 48, Control-Z Blocked, You appear to be in an Explorer window and have just pressed Control-Z. To protect your files this command has been blocked.`n`nPress Control-Shift-Z if you would like to undo an action in an Explorer window., 7
	WinActivate, ahk_id %activeHwnd%
	Return

^+Z::
	Send ^z
	Return

#IfWinActive

#Include %A_ScriptDir%\PRIVATE\MASTER-SCAF-KEYS.ahk
; The file included above is accessible for quick editing via the MASTER-SCRIPT hotkey SHIFT+CTRL+ALT+S when triggered when Desktop is Active. Or it can be sent to an editor when viewing Cheat Sheet #1 (under HYPER+F13 - click 'Edit Sheets')

;===== FUNCTIONS ===============================================================================

RemoveSplashScreen:
    SplashTextOff
    SetTimer RemoveSplashScreen, Off
    return

CapsLockCheck:
		; This function will detect if the CapsLock is toggled on.
		; There are 3 values defind in settings.ini:
		; CapsLockCheckPeriod defines how often to check for CapsLock Toggle, in milliseconds. Default is 10000 (or 10 seconds).
		; CapsLockToggleTimeoutThreshold defines a buffer of the number of CapsLock can be enabled before it starts playing the alert sound. Default is 4 times the CapsLockCheckPeriod (or 40 seconds).
		; CapsLockToggleOffTimeout defines the maximum number of times the timer will see CapsLock enabled. After this number is reached, CapsLock will be toggled off by this Function
		;
		; Pressing CAPS+P will enable or disable this checking.
		; A ToolTip will be displayed if CapsLock is auto-toggled or when enabling/disabling the check timer.
		;
		If IgnoreCapsCheck {
		SetTimer, CapsLockCheck, off
		return
		}

		stateRalt := GetKeyState("RAlt")        ; Attempting to resolve a bug in AutoHotKey that cropped Summer of 2019
		statePRalt := GetKeyState("RAlt", "P")  ; The Alt Keys kept getting stuck down. Since we are running the
		If (stateRalt = 1 or statePRalt = 1) {  ; CapsLock test most of the time, this is a good place to force it up.
		    Send, {RAlt Up}                     ; Not certain this is the best fix, but it seems to work.
		}                                       ; The earlier commands #InstallKeybdHook & #UseHook seemed to catch
																						; the Left Alt but not the Right Alt. Obviously, disabling the
																						; CapsLockCheck breaks this fix.
		If GetKeyState("CapsLock","T")
    {
    	CapsLockCounter += 1
			If (CapsLockCounter <= Settings_CapsLockToggleTimeoutThreshold ) {
					return
			} else If (CapsLockCounter >= Settings_CapsLockToggleOffTimeout ) {
				SetCapsLockState, Off
				ToolTip, CapsLock Being Deactivated - Press CAPS+P to toggle this check on/off.
				RemoveToolTip(-4000)
				CapsLockCounter := 0
				SoundPlay, SUPPORTING-FILES\SOUNDS\PB - Sci-Fi UI Free SFX\PremiumBeat SFX\PremiumBeat_0013_cursor_click_06.wav ; Assign your own sound
				Return
				}
			SoundPlay, SUPPORTING-FILES\SOUNDS\PB - Sci-Fi UI Free SFX\PremiumBeat SFX\PremiumBeat_0013_cursor_click_01.wav ; Assign your own sound
    	}	else {
			CapsLockCounter := 0
		}
    Return

launchAppTimeout:
	Gui, launchApp:Destroy
Return

Quitting:
    splashScreenSpacing := 75
    splashScreenStartY := 100
    splashScreenStartX := 100
    DetectHiddenWindows, On
    ;MsgBox, ,Quitting, Quitting MASTER-SCRIPT & child AHK scripts`n`n`nVersion: %version%, 3
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
					Sleep, sleepShort
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
			SetCapsLockState, Off
		    ExitApp
		    return


/*
; THIS FUNCTION WHILE USEFUL, MAY NOT BE NEEDED IN MOST SCRIPTS.
; IT IS HERE TO BE USED ON AN AS NEEDED BASIS - DURING DEVELOPMENT, FOR INSTANCE.
: REMOVE THE COMMENT BLOCK LINES AND UNCOMMENT THE LINES AT THE HEAD OF THIS SCRIPT TO RE-ENABLE IT.
; This function will auto-reload the script on save.
CheckScriptUpdate() {
    global ScriptStartModTime
    FileGetTime curModTime, %A_ScriptFullPath%
    If (curModTime <> ScriptStartModTime) {
        Loop
        {
            reload
            Sleep 333 ; ms
            MsgBox 0x2, %A_ScriptName%, Reload failed. ; 0x2 = Abort/Retry/Ignore
            IfMsgBox Abort
                ExitApp
            IfMsgBox Ignore
                break
        } ; loops reload on "Retry"
    }
}
*/
