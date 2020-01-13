; AutoHotKey - BPTV-KB Cheat Sheets
; by Ben Howard - ben@buttonpusher.tv

;===== START OF AUTO-EXECUTION SECTION =========================================================
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent ; Keeps script permanently running.
#SingleInstance force ; Ensures that there is only a single instance of this script running.
#InstallKeybdHook        ;Recent Window 10 updates have started getting the Alt key stuck down,
#UseHook On              ;but only in AutoHotKey. These 3 commands are an attempt to fix that.
#HotkeyModifierTimeout 0 ;It's not clear if this completely fixes it.
SetTitleMatchMode, 2 ; sets title matching to search for "containing" instead of "exact"

FileEncoding, UTF-8 ; this is here to make sure any files that we need to work with get created/opened/read as UTF-8

#include LIB\gdip.ahk
;Thanks to tic (Tariq Porter) for his GDI+ Library
;ahkscript.org/boards/viewtopic.php?t=6517

If !pToken := Gdip_Startup() ; this is here just to test that the GDI+ library is available at the path in the above #include
{
	MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
	ExitApp
}
OnExit, GdiplusExit

Menu, Tray, Icon, shell32.dll, 214 ;tray icon is now a little keyboard, or piece of paper or something

;===== INITIALIZATION - VARIABLES ==============================================================
; Sleep shortcuts - use these to standardize sleep times. Change here to change everywhere.
sleepShort = 333
sleepMedium = 666
sleepLong = 1500
sleepDeep = 3500

splashScreenX = %1%
splashScreenY = %2%
splashScreenTimeout = %3%
Location_currentSystemLocation = %4%

If !(Location_currentSystemLocation) {
  Location_currentSystemLocation := 1
}

global backgroundColor := "2D2A2B"
global foregroundColor := "FFFFFF"
global showTaskBarPicture = 0
global yposP
global xposP
global activeWin

;===== SPLASH SCREEN TO ANNOUNCE WHAT SCRIPT DOES ==============================================
SplashTextOn, 600, 100, Launching %A_ScriptFullPath%, Loading BPTV-CHEAT-SHEETS
WinMove, Launching %A_ScriptFullPath%, , %splashScreenX%, %splashScreenY%
SetTimer, RemoveSplashScreen, %splashScreenTimeout%
Sleep, sleepDeep
SplashTextOff


;===== END OF AUTO-EXECUTE =====================================================================
;===== MODIFIER MEMORY HELPER ==================================================================
; combine below with key and '::' to define hotkey
; e.g.- ^f1::Msgbox You pressed Control and F1
; #=Win | !=Alt | ^=Ctrl | +=Shift | &=combine keys | *=ignore other mods
; <=use left mod key| >=use right mod key  | UP=fires on release

;===== MAIN HOTKEY DEFINITIONS HERE ============================================================
; IMPORTANT CHANGE: I've changed the way that you get out of a Cheat Sheet. Previously the script waited until you released whichever hotkey you used to show a given sheet. That was getting annoying to hold down the key the whole time. Now I've changed it so that Escape will close the open cheat sheet. Beware that the cheatsheets are set to be 'alwaysontop'

; I've also added a Tooltip that reminds you that Escape is how you close the sheets. And how to switch tabs for the KBF2 cheaetsheet (the app-specific image one).

; Using the AHK command: "Hotkey" we can define a hotkey and call a sub-routine instead of using the double colon method. This allows the hotkey to be updated or changed based on variables (like Location_currentSystemLocation as we use below). By Default, we'll use the CapsLock plus Function method we've used previously. When we have SCAF macro pads or keys defined on a keybaord, we can use alternate hot key definitions, as we do below when we're in location #1...we can even flop the order of the keys, so they are easy to locate without too much looking.

If (Location_currentSystemLocation = 1) { ; if the script is running on Location #1 then...
	HotKey, F13, firstShower ; Set 2nd Hotkey for KBF1 (firstShower: a text file shower)
	HotKey, F14, secondShower ; Set 2nd Hotkey for KBF2 (secondShower: a image file shower - App-Specific)
	HotKey, F15, thirdShower ; Set 2nd Hotkey for KBF3 (thirdShower: a text file shower - App-Specific)
	HotKey, F16, fourthShower ; Set 2nd Hotkey for KBF4 (fourthShower: a image file shower - Location Specific)
	;The goal here is to be able to define the above Hotkeys based on the location or use the Hotkeys below by default if not specified above.
} else {
	HotKey, CapsLock & F1, firstShower ; <-- Hotkey for KBF1 (firstShower: a text file shower)
	HotKey, CapsLock & F2, secondShower ; <-- Hotkey for KBF2 (secondShower: a image file shower - App-Specific)
	HotKey, CapsLock & F3, thirdShower ; <-- Hotkey for KBF3 (thirdShower: a text file shower - App-Specific)
	HotKey, CapsLock & F4, fourthShower ; <-- Hotkey for KBF4 (fourthShower: a image file shower - Location Specific)
}


; The section below will allow you to define different hotkeys based on location. I thought I'd want to do this but then it became annoying to recall which hotkeys worked where. But, I want to keep this around because with some incoming keyboard changes, this will be useful again.
;If (Location_currentSystemLocation = 1) { ; if the script is running on Location #1 then...
;	HotKey, ^!+f12, firstShower ; Set 2nd Hotkey for KBF1 (firstShower: a text file shower)
;	HotKey, ^!+f11, secondShower ; Set 2nd Hotkey for KBF2 (secondShower: a image file shower - App-Specific)
;	HotKey, ^!+f10, thirdShower ; Set 2nd Hotkey for KBF3 (thirdShower: a text file shower - App-Specific)
;	HotKey, ^!+f9, fourthShower ; Set 2nd Hotkey for KBF4 (fourthShower: a image file shower - Location Specific)
;}

return ; this prevents the script from processing the labels below at script launch (at least the firstShower label...)

firstShower: ; <--Display a Text File CheatSheet of MASTER-SCRIPT AutoHotKeys based on Location setting.
    WinGetActiveTitle, activeWin ; We need to capture whatever was the Window that had focus when this was launched, otherwise it will give focus to whichever Window had focus before that (or some random Window).
    txt2show := "SUPPORTING-FILES\KBF1-LOC" . Location_currentSystemLocation . ".txt"
    showText(txt2show)
		If (Location_currentSystemLocation = 1) { ; based on the location this will change how the release of the invoking Hotkey will close the GUI
			keywait, %A_ThisHotKey% ; this will just keep GUI window open while hotkey is depressed
		} else {
			ToolTip, Press ESC to close Cheatsheet`n`n`n(This window will remain on top until it closes) ; this will display a ToolTip that gives you a bit of instruction
			RemoveToolTip(4000)
			keywait, ESC, D ; you can release the invoking hotkey and this will wait for ESCAPE to be pressed down
			Tooltip ; kills the Tooltip if you close GUI before RemoveToolTip duration
		}

		squashGUI(activeWin)
		;Gui, Text:Destroy ; destroys the Text:GUI
    ;WinActivate, %activeWin% ; this refocuses the Window that had focus before this was triggered
		return

secondShower: ; <-- Display an image CheatSheet of App Specific Keyboard Shortcuts (In-app and AHK)
    WinGetActiveTitle, activeWin ; We need to capture whatever was the Window that had focus when this was launched, otherwise it will give focus to whichever Window had focus before that (or some random Window).
    If WinActive("ahk_exe Explorer.EXE") {
        pic2show := "SUPPORTING-FILES\KBF2-WIN-PAGE"
        PictureWidth := 2000
        numPages := 2
        PictureStartY := 0 ; determines where the cheatsheet is going to start drawing. Whenever we want to display the TaskBar Cheatsheet, we should make sure the CheatSheet image doesn't get drawn underneath the TaskBar CheatSheet.
        taskBarPic := "SUPPORTING-FILES\WIN-TASKBAR\windows-taskbar-keyboard-cheaetsheet-DKYELLOW.png"
        showTaskBarPicture = 1
    }
    else
    If WinActive("ahk_exe Adobe Premiere Pro.exe") {
        pic2Show := "SUPPORTING-FILES\KBF2-PPRO-PAGE"
        PictureWidth := 2000
        numPages := 3
        PictureStartY := 50 ; setting the starting coords to '-1' will make it center vertically on the screen
    }
    else
    If WinActive("ahk_exe AfterFX.exe") {
        pic2Show := "SUPPORTING-FILES\KBF2-AE-PAGE"
        PictureWidth := 2000
        numPages := 2
        PictureStartY := 50
    }
    else
    If WinActive("ahk_exe Photoshop.exe") {
        pic2Show := "SUPPORTING-FILES\KBF2-PS.png"
        PictureWidth := 2000
        numPages := 1
        PictureStartY := 50
    }
    else
    If WinActive("ahk_exe SubtitleEdit.exe") {
        pic2Show := "SUPPORTING-FILES\KBF2-CONTOUR-PRO-SUBTITLE-EDIT.jpg"
        PictureWidth := 906
        numPages := 1
        PictureStartY := 50
    }
    else
    If WinActive("ahk_exe stickies.exe") {
        pic2Show := "SUPPORTING-FILES\KBF2-STICKIES.png"
        PictureWidth := 1920
        numPages := 1
        PictureStartY := 50
    }
		else
		If WinActive("ahk_exe atom.exe") {
				pic2Show := "SUPPORTING-FILES\KBF2-ATOM-PAGE"
				PictureWidth := 2000
				numPages := 2
				PictureStartY := 50
		}
    else
		If WinActive("ahk_exe FreeCommander.exe") {
				pic2Show := "SUPPORTING-FILES\KBF2-FCXE.png"
				PictureWidth := 2000
				numPages := 1
				PictureStartY := 50
		}
		else
		{
        pic2Show := "SUPPORTING-FILES\NO-CHEATSHEET.png"
        PictureWidth := 579
        numPages := 1
    }
    showImageTabs(pic2Show, PictureWidth, numPages, PictureStartY)
    ;If you want some help recalling which line is which in the BPTV-KB templates, you can uncomment the ToolTip below. It will appear near the mouse cursor when the Cheat Sheet is invoked & clear with everything else. Make sure to also uncomment the plain ToolTip line a few lines down.
    ;ToolTip, PLAIN`nCONTROL`nALT`nSHIFT`nCTRL+ALT`nCTRL+SHIFT`nALT+SHIFT`nCTRL+ALT+SHIFT
    if showTaskBarPicture {
      showTaskBarPic(taskBarPic) ; as an extra little helper, this will display an indicator above the Windows TaskBar to remind you which apps can be launched/activated by pressing Windows plus that number key.
    }
    WinActivate, Picture
		ToolTip, Press ESC to close Cheatsheet`n`nLeft/Right (or Caps+Scroll Up/Down) to switch Tabs`n`n(This window will remain on top until it closes)
		RemoveToolTip(4000)
    keywait, ESC, D ; wait for ESCAPE to be pressed down
		Tooltip ; kills the Tooltip if you close GUI before RemoveToolTip duration
    numPages := 0
		squashGUI(activeWin)
    ;Gui, Picture:Destroy ; this kills the main cheatsheet GUI window
    ;destroyGDIplusGUI() ; this kills the TaskBar CheatSheet
    ;ToolTip ; also uncomment this line to clear the ToolTip when done
    ;WinActivate, %activeWin% ; this refocuses the Window that had focus before this was triggered
return

thirdShower:
    WinGetActiveTitle, activeWin
    If WinActive("ahk_exe Explorer.EXE")
        showText("SUPPORTING-FILES\KBF3-WINDOWS-DEFAULT-KEYS.txt")
    else
    If WinActive("ahk_exe Adobe Premiere Pro.exe")
        showText("SUPPORTING-FILES\KBF3-PPRO.txt")
    else
    If WinActive("ahk_exe stickies.exe")
        showText("SUPPORTING-FILES\KBF3-STICKIES.txt")
    else
		If WinActive("ahk_exe atom.exe")
        showText("SUPPORTING-FILES\KBF3-ATOM.txt")
    else
		If WinActive("ahk_exe WindowsTerminal.exe")
				showText("SUPPORTING-FILES\KBF3-WINTERMpvw.txt")
		else
		If WinActive("ahk_exe SubtitleEdit.exe")
				showText("SUPPORTING-FILES\KBF3-SUBTITLE-EDIT.txt")
		else
        showText("SUPPORTING-FILES\NO-CHEATSHEET.txt")
		ToolTip, Press ESC to close Cheatsheet`n`n`n(This window will remain on top until it closes)
		RemoveToolTip(4000)
    keywait, ESC, D ; wait for ESCAPE to be pressed down
		Tooltip ; kills the Tooltip if you close GUI before RemoveToolTip duration
		squashGUI(activeWin)
		;Gui, Text:Destroy
    ;WinActivate, %activeWin% ; this refocuses the Window that had focus before this was triggered
return

fourthShower:
    WinGetActiveTitle, activeWin ; We need to capture whatever was the Window that had focus when this was launched, otherwise it will give focus to whichever Window had focus before that (or some random Window).
    locationPic := "SUPPORTING-FILES\KBF4-LOC" . Location_currentSystemLocation . ".png"
    showPic(locationPic, 0)
		ToolTip, Press ESC to close Cheatsheet`n`n`n(This window will remain on top until it closes)
		RemoveToolTip(4000)
    keywait, ESC, D ; wait for ESCAPE to be pressed down
		Tooltip ; kills the Tooltip if you close GUI before RemoveToolTip duration
    squashGUI(activeWin)
		;Gui, Picture:Destroy
    ;WinActivate, %activeWin% ; this refocuses the Window that had focus before this was triggered
return

CapsLock & F5:: ;<-- Testing the TaskBar CheatSheet
    WinGetActiveTitle, activeWin ; We need to capture whatever was the Window that had focus when this was launched, otherwise it will give focus to whichever Window had focus before that (or some random Window).
    taskBarPic := "SUPPORTING-FILES\WIN-TASKBAR\windows-taskbar-keyboard-cheaetsheet-DKYELLOW.png"
    showTaskBarPic(taskBarPic)
    keywait, ESC, D ; wait for ESCAPE to be pressed down
		squashGUI(activeWin)
    ;destroyGDIplusGUI()
    ;WinActivate, %activeWin% ; this refocuses the Window that had focus before this was triggered
return

;===== FUNCTIONS ===============================================================================

RemoveSplashScreen:
    SplashTextOff
    SetTimer RemoveSplashScreen, Off
return

; use this function to Remove ToolTips - pretty self-explanatory
RemoveToolTip(duration) {
  SetTimer, ToolTipOff, %duration%
  Return

ToolTipOff:
    ToolTip
    return
}

;for showText & showPic - I want to add code in that will downgrade to the next lowest location code that does exist if it can't find whatever file it is sent.

; showText is used to create and display a GUI for a text file as a Cheat Sheet
showText(fileToShow){
  IfNotExist, %fileToShow%
    fileToShow := "SUPPORTING-FILES\AHK-KEYS-NO-CHEATSHEET.txt"
  FileRead, textToShow, %fileToShow%
  FormatTime, now,, hh:mm tt
  today = %A_YYYY%-%A_MMM%-%A_DD%
  Gui, Text:+alwaysontop +disabled -sysmenu +owner -caption +toolwindow +0x02000000
  Gui, Text:Color, %backgroundColor%
  Gui, Text:Margin, 30, 30
  Gui, Text:font, s12 c%foregroundColor%, Consolas
  Gui, Text:Add, Text, , %now% - %today%
  Gui, Text:add, text, , %textToShow%
  ;Gui, Text:add, text, , File: %A_ScriptDir%\%fileToShow%
	;uncomment line above to display the path to the %fileToShow% at the bottom of this GUI window
  Gui, Text:Show
return
}

; showPic is used to create and display a GUI for an image Cheat Sheet
; showPic can only display single images in a single frame (see showImageTabs below for more than 1 image)
showPic(picToShow, PictureWidth){
  SysGet, Mon1, Monitor, 1
  If (Mon1Right < PictureWidth)
    PictureWidth -= 425
  if !FileExist(picToShow) {
    picToShow := "SUPPORTING-FILES\NO-CHEAT-SHEET.png"
    PictureWidth := 579
  }
  Gui, Picture:+alwaysontop +disabled -sysmenu +owner -caption +toolwindow +0x02000000
  Gui, Picture:Color, %backgroundColor%
  Gui, Picture:Margin, 15, 15
  Gui, Picture:font, s14 c%foregroundColor%, Consolas
  Gui, Picture:add, picture, w%PictureWidth% h-1 , %picToShow%
  ;Gui, Picture:add, text, , File: %A_ScriptDir%\%picToShow%
	;uncomment line above to display the path to the %fileToShow% at the bottom of this GUI window
  Gui, Picture:Show
return
}

; showImageTabs is used to create and display a GUI for multiple images in tabs
; Once displayed, you can scroll up or down to change visible image tabs
showImageTabs(picToshow, PictureWidth, numPages, PictureStartY){
    SysGet, Mon1, Monitor, 1
    If (Mon1Right < PictureWidth)
      PictureWidth -= 450
    If (numPages = 1) {
      showPic(picToshow, PictureWidth)
      return
    }
    Gui, Picture:+alwaysontop -sysmenu +owner -caption +toolwindow +0x02000000
    Gui, Picture:Color, %backgroundColor%
    Gui, Picture:Margin, 5, 5
    Gui, Picture:font, s10 c%foregroundColor%, Consolas
    loop, %numPages% {
        nextTab := tabList . "Page" . A_Index . "|"
        tabList := nextTab
        }
    Gui, Picture:add, Tab3,, %tabList%
    loop, %numPages% {
        fileToShow := picToShow . A_Index . ".png"
          if !FileExist(fileToShow) {
            picToShow := "SUPPORTING-FILES\NO-CHEAT-SHEET.png"
            PictureWidth := 579
            showPic(picToshow, PictureWidth)
            Return
          }
        If (A_Index = 1) {
            Gui, Picture:add, picture, w%PictureWidth% h-1 , %fileToShow%
            ;Gui, Picture:add, text, , File: %A_ScriptDir%\%fileToShow%
						;uncomment line above to display the path to the %fileToShow% at the bottom of this GUI window
        }
        else {
            Gui, Picture:Tab, %A_Index%
            Gui, Picture:add, picture, w%PictureWidth% h-1 , %fileToShow%
            ;Gui, Picture:add, text, , File: %A_ScriptDir%\%fileToShow%
						;uncomment line above to display the path to the %fileToShow% at the bottom of this GUI window
            }
    }
    Gui, Picture:Tab
    Gui, Picture:Show, y%PictureStartY%
    return
}

; showTaskBarPic is used to create and display a GUI for an image  that shows the taskbar shortcuts
; to get the transparency working, we need to use the GDI+ library
; Based on the tutorial here: https://github.com/tariqporter/Gdip/blob/master/Gdip.Tutorial.3-Create.Gui.From.Image.ahk
showTaskBarPic(sFile){
	global xposP, yposP        ; we are going to store the position of your cursor when you show
	coordmode, mouse, Screen   ; this cheatsheet so that we can put the cursor back where it was
	MouseGetPos, xposP, yposP  ; when we are done showing this because...
  DllCall("SetCursorPos", "int", (a_screenwidth/2+300), "int", a_screenheight) ; this will force the cursor to move to the bottom-middle of the screen so that the taskbar will unhide itself. The '/2+300' bit after a_screenwidth above will move the cursor over to the right 300 pixels - this is to prevent any running app icons from showing a preview window if the cursor lands on them. If you have that many running apps at one time then you have other problems. Also, if you don't run with the Taskbar auto-hiding (you monster!) you can probably comment this line out

	; this is all blackmagic provided by GDI+
  Gui, TaskBarPicture:  -Caption +E0x80000 +LastFound +OwnDialogs +Owner +hwndhwnd +alwaysontop
  Gui, TaskBarPicture: Show, NA ,dialog

  pBitmap:=Gdip_CreateBitmapFromFile(sFile)
  Gdip_GetImageDimensions(pBitmap,w,h)

  hbm := CreateDIBSection(w,h)
  hdc := CreateCompatibleDC()
  obm := SelectObject(hdc, hbm)
  pGraphics:=Gdip_GraphicsFromHDC(hdc)

  Gdip_DrawImage(pGraphics, pBitmap, 0,0,w,h)
  UpdateLayeredWindow(hwnd, hdc,0,(a_screenheight-h),w,h)
  Gdip_DisposeImage(pBitmap)
return
}

destroyGDIplusGUI(){ ; this should not only kill the TaskBarPicture but free up everything it used and reset things for the next time a CheatSheet is shown (we want showTaskBarPicture to be set to 0)
	global xposP, yposP
  global showTaskBarPicture
  ; Now the bitmap may be deleted
  DeleteObject(hbm)

  ; Also the device context related to the bitmap may be deleted
  DeleteDC(hdc)

  ; The graphics may now be deleted
  Gdip_DeleteGraphics(G)

  ; The bitmap we made from the image may be deleted
  Gdip_DisposeImage(pBitmap)
  showTaskBarPicture = 0
	Gui, TaskBarPicture:Destroy
	coordmode, mouse, Screen
	MouseMove, xposP, yposP ; this puts the cursor back where it came from before we showed this cheatsheet
  Return
}

GdiplusExit:
; gdi+ may now be shutdown on exiting the program
Gdip_Shutdown(pToken)
ExitApp

squashGUI(activeWin){
	;this function should destroy the GUI - no matter which kind it is
	Gui, Text:Destroy ; destroys the Text:GUI
	Gui, Picture:Destroy ; this kills the main cheatsheet GUI window
	destroyGDIplusGUI() ; this kills the TaskBar CheatSheet

	WinActivate, %activeWin% ; this refocuses the Window that had focus before this was triggered
}

GuiEscape:
	Gui, Text:Destroy ; destroys the Text:GUI window
  Gui, Picture:Destroy ; this kills the Picture:GUI window
	WinActivate, %activeWin% ; this refocuses the Window that had focus before this was triggered
	Return
