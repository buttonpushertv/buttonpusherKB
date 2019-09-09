﻿; AutoHotKey - Buttonpusher Post-Production Keyboard Environment - Master Script
; by Ben Howard - ben@buttonpusher.tv

;===== START OF AUTO-EXECUTION SECTION =========================================================
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent ; Keeps script permanently running.
#SingleInstance force ; Ensures that there is only a single instance of this script running.
; SetTitleMatchMode, 2 ; sets title matching to search for "containing" instead of "exact"
Menu, Tray, Icon, imageres.dll, 187 ;tray icon is now a little keyboard, or piece of paper or something
;#MaxThreadsPerHotkey 1

#MenuMaskKey vk07 ; This is needed to block the Window key from triggering the Start Menu when pressed by itself.

if not A_IsAdmin
	Run *RunAs "%A_ScriptFullPath%" ; (A_AhkPath is usually optional if the script has the .ahk extension.) You would typically check  first.

; The 2 lines below pertain to the 'reload on save' function below (CheckScriptUpdate).
; They are required for it to work.
FileGetTime ScriptStartModTime, %A_ScriptFullPath%
SetTimer CheckScriptUpdate, 100, 0x7FFFFFFF ; 100 ms, highest priority

#Include MASTER-FUNCTIONS.ahk

;===== INITIALIZATION - VARIABLES ==============================================================
; Sleep shortcuts - use these to standardize sleep times. Change here to change everywhere.
sleepMicro := 15
sleepShort := 333
sleepMedium := 666
sleepLong := 1500
sleepDeep := 3500

halfScreenWidth := (A_ScreenWidth / 2) ; determine what half the screen's width is for splash screens
quarterScreenHeight := (A_ScreenHeight / 4) ; determine what 1/4 the screen's height is for splash screens

global iniFile := "settings.ini" ; the main settings file used by most of the BPTV-KB scripts
global splashScreenSpacing := 150
global splashScreenStartY := 50
global splashScreenStartX := (halfScreenWidth - 300)
global CapsLockCounter := 0

SetScrollLockState, off

INI_Init(iniFile)
INI_Load(iniFile)

;===== SPLASH SCREEN TO ANNOUNCE WHAT SCRIPT DOES ==============================================
SplashTextOn, 600, 100, Launching %A_ScriptFullPath%, Loading MASTER AHK Script.`nCAPS-F1 for CheatSheet of AHK Hotkeys.`nCAPS-Q to quit MASTER-SCRIPT & child scripts.`nCAPS-F11 to edit settings(MASTER-SETTINGS.ahk)
WinMove, Launching %A_ScriptFullPath%, , %splashScreenStartX%, %splashScreenStartY%

splashScreenStartY += splashScreenSpacing

; ===== LAUNCH STANDALONE SCRIPTS HERE

loop, %section2_keys%
{
    currentKey := % section2_key%A_Index%
    pathLookAhead := A_Index + 1
    pathKey := % section2_key%pathLookAhead%
    currentKeyValue := %section2%_%currentKey%
    currentPathValue := %section2%_%pathKey%
    currentKeyLeft7 := SubStr(currentKey, 1, 7)
    If (currentKeyLeft7 = "loadScr") {
        If (currentKeyValue) {
            If !FileExist(currentPathValue) {
              MsgBox The App could not be found at %currentPathValue%
              continue
              }
            else {
            Run, %currentPathValue% %splashScreenStartX% %splashScreenStartY% %Settings_splashScreenTimeout%
            splashScreenStartY += splashScreenSpacing
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
SetTimer, RemoveSplashScreen, %Settings_splashScreenTimeout%

SetTimer, CapsLockCheck, %Settings_CapsLockCheckPeriod%
;
;===== END OF AUTO-EXECUTE =====================================================================
;===== MODIFIER MEMORY HELPER ==================================================================
; combine below with key and '::' to define hotkey
; e.g.- ^f1::Msgbox You pressed Control and F1
; #=Win | !=Alt | ^=Ctrl | +=Shift | &=combine keys | *=ignore other mods
; <=use left mod key| >=use right mod key  | UP=fires on release

;===== MAIN HOTKEY DEFINITIONS HERE ============================================================

~LWin::Send {Blind}{vk07} ; <-- Blocks Left Window key from triggering the Start Menu when pressed by itself. The Right Window key will still work in the default fashion.

; don't know if this works for alt too...
~LAlt::Send {Blind}{vk07}

ScrollLock & f11:: ; <--Open the Settings GUI for MASTER-SCRIPT.AHK
		ScrollLockOff()
		Run, MASTER-SETTINGS.AHK
    return

ScrollLock & f12:: ; <-- Open BPTV-LAUNCHER
		ScrollLockOff()
		Run, C:\BPTV-KB\BPTV-LAUNCHER.ahk
    return

ScrollLock & Backspace:: ; <-- Reload MASTER-SCRIPT.ahk
		Reload
    Return

CapsLock & WheelDown::Send ^{PGDN}
CapsLock & WheelUp::Send ^{PGUP}

CapsLock & b:: ; <-- Send 'buttonpusher' as text
	Send, buttonpusher
return

CapsLock & n:: ; <-- Send 'ben@buttonpusher' as text
	Send, ben@buttonpusher.tv
return

CapsLock & c:: ; <-- Delete Key
	Send, {Delete}
return

CapsLock & e:: ; <-- Send 'ben@buttonpusher.tv' as text
	Send, ben@buttonpusher.tv
return

CapsLock & p:: ; <-- Toggle CapsLockCheck on or Off
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
	return
	}

CapsLock & q:: ; <-- Exit MASTER-SCRIPT and child AHK Scripts
goto Quitting

CapsLock & v:: ; <-- Backspace Key
Send, {BackSpace}
return

CapsLock & f1:: ; <--Display a Text File CheatSheet of MASTER-SCRIPT AutoHotKeys
    txt2show := "SUPPORTING-FILES\AHK-KEYS-F1-LOC" . Location_currentSystemLocation . ".txt"
    showText(txt2show)
    keywait, f1
    Gui, Text:Destroy
    return

CapsLock & f2:: ; <--Display an image CheatSheet of App Specific Keyboard Shortcuts (In-app and AHK)
    If WinActive("ahk_exe Explorer.EXE") {
        pic2show := "SUPPORTING-FILES\KBF2-WIN-PAGE"
        PictureWidth := 2000
        numPages := 2
    }
    else
    If WinActive("ahk_exe Adobe Premiere Pro.exe") {
        pic2Show := "SUPPORTING-FILES\KBF2-PPRO.png"
        PictureWidth := 2000
        numPages := 1
    }
    else
    If WinActive("ahk_exe AfterFX.exe") {
        pic2Show := "SUPPORTING-FILES\KBF2-AE.png"
        PictureWidth := 2000
        numPages := 1
    }
    else
    If WinActive("ahk_exe SubtitleEdit.exe") {
        pic2Show := "SUPPORTING-FILES\CONTOUR-PRO-SUBTITLE-EDIT.jpg"
        PictureWidth := 906
        numPages := 1
    }
    else
    If WinActive("ahk_exe stickies.exe") {
        pic2Show := "C:\BPTV-KB\SUPPORTING-FILES\KBF2-STICKIES.png"
        PictureWidth := 1920
        numPages := 1
    }
    else {
        pic2Show := "SUPPORTING-FILES\NO-CHEAT-SHEET.png"
        PictureWidth := 579
        numPages := 1
    }
    showImageTabs(pic2Show, PictureWidth, numPages)
    keywait, f2
    numPages := 0
    Gui, Picture:Destroy
    return

CapsLock & f3:: ; <--Display a Text File CheatSheet of App Specific AutoHotKeys
    If WinActive("ahk_exe Explorer.EXE")
        showText("SUPPORTING-FILES\WINDOWS-DEFAULT-KEYS.txt")
    else
    If WinActive("ahk_exe Adobe Premiere Pro.exe")
        showText("SUPPORTING-FILES\AHK-KEYS-F3-PPRO.txt")
    else
    If WinActive("ahk_exe stickies.exe")
        showText("SUPPORTING-FILES\AHK-KEYS-F3-STICKIES.txt")
    else
        showText("SUPPORTING-FILES\AHK-KEYS-NO-CHEATSHEET.txt")
    keywait, f3
    Gui, Text:Destroy
    return

CapsLock & f4:: ; <--Display an image CheatSheet based on System Location Setting
    locationPic := "SUPPORTING-FILES\KBF4-LOC" . Location_currentSystemLocation . ".png"
    showPic(locationPic, 0)
    keywait,f4
    Gui, Picture:Destroy
    return

CapsLock & t:: ; <-- Send time & date as text
    ;timestamp(theTimeStamp)
    FormatTime, now,, hh:mm tt
    today = %A_YYYY%-%A_MMM%-%A_DD%
    theTimeStamp = %now% - %today%
    Send, %theTimeStamp%
    return

#IfWinActive, ahk_exe Explorer.EXE

#^+f:: ; <-- Nuke Firefox
Run, %comspec% /c "taskkill.exe /F /IM firefox.exe",, hide
ToolTip, killed firefox
RemoveToolTip(-2000)
return

#^p:: ; <-- Nuke Premiere
    Process, Exist, Adobe Premiere Pro.exe
    If (ErrorLevel > 0)
        PID = %ErrorLevel%
    Run, %comspec% /c "taskkill.exe /PID %PID% /T /F"
    ToolTip, killed premiere
    RemoveToolTip(-2000)
return

;===== FUNCTIONS ===============================================================================

RemoveSplashScreen:
    SplashTextOff
    SetTimer RemoveSplashScreen, Off
    return

CapsLockCheck:
		If IgnoreCapsCheck {
		SetTimer, CapsLockCheck, off
		return
		}
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
				SoundPlay,C:\BPTV-KB\SUPPORTING-FILES\SOUNDS\PB - Sci-Fi UI Free SFX\PremiumBeat SFX\PremiumBeat_0013_cursor_click_06.wav ; Assign your own sound
				Return
				}
			SoundPlay, C:\BPTV-KB\SUPPORTING-FILES\SOUNDS\PB - Sci-Fi UI Free SFX\PremiumBeat SFX\PremiumBeat_0013_cursor_click_01.wav ; Assign your own sound
    	}	else {
			CapsLockCounter := 0
		}
    Return

Quitting:
    splashScreenSpacing := 75
    splashScreenStartY := 100
    splashScreenStartX := 100
    DetectHiddenWindows, On
    MsgBox, ,Quitting, Quitting MASTER-SCRIPT & child AHK scripts, 3
    SetTitleMatchMode, 2
		loop, %section2_keys%
		{
		    currentKey := % section2_key%A_Index%
		    pathLookAhead := A_Index + 1
		    pathKey := % section2_key%pathLookAhead%
		    currentKeyValue := %section2%_%currentKey%
		    currentPathValue := %section2%_%pathKey%
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
		    ExitApp
		    return


; This function will auto-reload the script on save.
CheckScriptUpdate() {
    global ScriptStartModTime
    FileGetTime curModTime, %A_ScriptFullPath%
    If (curModTime <> ScriptStartModTime) {
        Loop
        {
            reload
            Sleep 300 ; ms
            MsgBox 0x2, %A_ScriptName%, Reload failed. ; 0x2 = Abort/Retry/Ignore
            IfMsgBox Abort
                ExitApp
            IfMsgBox Ignore
                break
        } ; loops reload on "Retry"
    }
}
