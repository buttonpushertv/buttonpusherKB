; AutoHotKey - Buttonpusher Post-Production Keyboard Environment - After Effects HotKeys
; by Ben Howard - ben@buttonpusher.tv

;===== START OF AUTO-EXECUTION SECTION =========================================================
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent ; Keeps script permanently running.
#SingleInstance force ; Ensures that there is only a single instance of this script running.
; SetTitleMatchMode, 2 ; sets title matching to search for "containing" instead of "exact"
#MaxHotkeysPerInterval 2000
#WinActivateForce ;https://autohotkey.com/docs/commands/_WinActivateForce.htm

; The 2 lines below pertain to the 'reload on save' function below (CheckScriptUpdate).
; They are required for it to work.
;FileGetTime ScriptStartModTime, %A_ScriptFullPath%
;SetTimer CheckScriptUpdate, 100, 0x7FFFFFFF ; 100 ms, highest priority
; AUTO-RELOAD ON SAVE DISABLED - UNCOMMENT 2 LINES ABOVE TO RE-ENABLE
; SEE THE FUNCTION BELOW FOR MORE INFO

Menu, Tray, Icon, imageres.dll, 251 ; this changes the tray icon to a filmstrip!
;===== INITIALIZATION - VARIABLES ==============================================================
; Sleep shortcuts - use these to standardize sleep times. Change here to change everywhere.
sleepMicro := 5
sleepMini := 15
sleepShort := 333
sleepMedium := 666
sleepLong := 1500
sleepDeep := 3500

#include %A_ScriptDir%\..\LIB\gdip.ahk
;Thanks to tic (Tariq Porter) for his GDI+ Library
;ahkscript.org/boards/viewtopic.php?t=6517

If !pToken := Gdip_Startup() ; this is here just to test that the GDI+ library is available at the path in the above #include
{
	MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
	ExitApp
}
OnExit, GdiplusExit

;===== END OF AUTO-EXECUTE =====================================================================

;===== MODIFIER MEMORY HELPER ==================================================================
; combine below with key and '::' to define hotkey
; e.g.- ^f1::Msgbox You pressed Control and F1
; #=Win | !=Alt | ^=Ctrl | +=Shift | &=combine keys | *=ignore other mods
; <=use left mod key| >=use right mod key  | UP=fires on release

;===== MAIN HOTKEY DEFINITIONS HERE ============================================================

;===== AFTER EFFECTS HOTKEY DEFINITIONS HERE ============================================

#IfWinActive, ahk_exe AfterFX.exe

F13:: ; <- In Timeline, Select All then collapse/open effects/animated on all tracks
        MouseGetPos, xpos, ypos
        halfScreenHeight := (A_ScreenHeight / 2)
        ;MSGBOX, , DEBUG, X: %xpos%`nY:%ypos%`nScreen Height:%A_ScreenHeight%`nhalfScreenHeight:%halfScreenHeight%
        If (ypos < halfScreenHeight) {
            ToolTip, Make sure to fire this hotkey when Timeline has focus.
            RemoveToolTip(3000)
        }

        Send, {Control Down}a{Control Up}
        Sleep, sleepShort
        Send, u
    Return

    
#IfWinActive


;===== ILLUSTRATOR HOTKEY DEFINITIONS HERE ============================================

/* 

THIS BLOCK IS JUST HERE FOR REFERENCE ON USING 'clickradar()' FUNCTION

#IfWinActive, ahk_exe Illustrator.exe

+^!F6:: ; <-- Clicking on 'Vertical Distribute Center' FOR MIXED OBJECTS
    ;- why can't this be assigned a key board shortcut in Illustrator?!?
    ; 'clickRadar' is a function below. You give it the coordinates you want to click & it does the rest.
    clickRadar(1056,66) 
    Return

#IfWinActive
*/
;===== END SCAF DEFINITIONS ===============================================================

;===== FUNCTIONS ===============================================================================

RemoveSplashScreen:
    SplashTextOff
    SetTimer RemoveSplashScreen, Off
    return



; use this function to Remove ToolTips - pretty self-explanatory - 'duration' should be given in milliseconds (4000 = 4 seconds)
RemoveToolTip(duration) {
  SetTimer, ToolTipOff, %duration%
  Return

ToolTipOff:
    ToolTip
    return
}

; clickRadar is used to show a yellow-circle.png centered on the coords you send the function. The idea is that they should be centered on the coords you will be clicking on.
; to get the transparency working, we need to use the GDI+ library
; Based on the tutorial here: https://github.com/tariqporter/Gdip/blob/master/Gdip.Tutorial.3-Create.Gui.From.Image.ahk
clickRadar(sx,sy){
    ; we are going to store the position of your cursor when you show this so that we can put the cursor back where it was
	;coordmode, mouse, Screen
	MouseGetPos, xposP, yposP
    offsetSX := (sx - 25)
    offsetSY := (sy - 25)
    ;MSgBox, Sent: %sx%, %sy%`nOffset: %offsetSX%, %offsetSY%`nGrabbed: %xposP%, %yposP%
	; this is all blackmagic provided by GDI+
    Gui, ShowPicture: -Caption +E0x80000 +LastFound +OwnDialogs +Owner +hwndhwnd +alwaysontop
    Gui, ShowPicture: Show, NA ,dialog

    pBitmap:=Gdip_CreateBitmapFromFile("yellow-circle.png")
    Gdip_GetImageDimensions(pBitmap,w,h)

    hbm := CreateDIBSection(w,h)
    hdc := CreateCompatibleDC()
    obm := SelectObject(hdc, hbm)
    pGraphics:=Gdip_GraphicsFromHDC(hdc)

    Gdip_DrawImage(pGraphics, pBitmap, 0,0,w,h)
    UpdateLayeredWindow(hwnd, hdc,offsetSX,offsetSY,w,h)
    Gdip_DisposeImage(pBitmap)
    Sleep, 333
    destroyGDIplusGUI()
    Click, %sx%, %sy%
    MouseMove, xposP, yposP, 0 ; returning cursor where it was
return
}

destroyGDIplusGUI(){ ; this should not only kill the ShowPicture but free up everything it used and reset things for the next time a CheatSheet is shown (we want showPicture to be set to 0)
  ; Now the bitmap may be deleted
  DeleteObject(hbm)

  ; Also the device context related to the bitmap may be deleted
  DeleteDC(hdc)

  ; The graphics may now be deleted
  Gdip_DeleteGraphics(G)

  ; The bitmap we made from the image may be deleted
  Gdip_DisposeImage(pBitmap)
  showPicture = 0
Gui, ShowPicture:Destroy
  Return
}

GdiplusExit:
; gdi+ may now be shutdown on exiting the program
Gdip_Shutdown(pToken)
ExitApp

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