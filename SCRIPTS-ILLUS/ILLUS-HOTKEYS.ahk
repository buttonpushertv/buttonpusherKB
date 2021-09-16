; AutoHotKey - Buttonpusher Post-Production Keyboard Environment - Illustrator HotKeys
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
sleepMicro := 15
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

;===== ILLUSTRATOR HOTKEY DEFINITIONS HERE ============================================

#IfWinActive, ahk_exe Illustrator.exe

+^!F1:: ; <-- Clicking on 'Vertical Distribute Center' FOR TYPE ONLY
    ;- why can't this be assigned a key board shortcut in Illustrator?!?
    ; 'clickRadar' is a function below. You give it the coordinates you want to click & it does the rest.
    clickRadar(1750, 65)
    Return


+^!F2:: ; <-- Clicking on 'Vertical Distribute Center' FOR MIXED OBJECTS
    ;- why can't this be assigned a key board shortcut in Illustrator?!?
    ; 'clickRadar' is a function below. You give it the coordinates you want to click & it does the rest.
    clickRadar(1056,66) 
    Return

#IfWinActive, ahk_exe Illustrator.exe
+^!f12:: ; <--ILLUSTRATOR: Resetting a PLAIN Keyboard Template Key to PLAIN & set to opacity 10%
    ;ITEM LOOP STARTS HERE
    Sleep, sleepMedium
    Click
    Sleep, sleepMedium
    Click,2
    Sleep, sleepMedium
    Send, {Control Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepMedium
    Send, PLAIN
    Sleep, sleepMedium
    Send, {ESC}
    Sleep, sleepMedium
    Send, {Shift Down}
    Sleep, sleepShort
    Send, 1
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Down}
    Sleep, sleepShort
    Send, {Shift Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepShort
    ;ITEM LOOP ENDS HERE
    SoundBeep
    return
+^!f13::  ; <-- Resetting a CONTROL Keyboard Template Key to CONTROL & set to opacity 10%
    ;ITEM LOOP STARTS HERE
    Sleep, sleepShort
    Click
    Sleep, sleepMedium
    Click,2
    Sleep, sleepMedium
    Send, {Control Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepMedium
    Send, CONTROL
    Sleep, sleepMedium
    Send, {ESC}
    Sleep, sleepMedium
    Send, {Shift Down}
    Sleep, sleepShort
    Send, 1
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Down}
    Sleep, sleepShort
    Send, {Shift Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepShort
    ;ITEM LOOP ENDS HERE
    SoundBeep
    return
+^!f14:: ; <-- Resetting a ALT Keyboard Template Key to ALT & set to opacity 10%
    ;ITEM LOOP STARTS HERE
    Sleep, sleepShort
    Click
    Sleep, sleepMedium
    Click,2
    Sleep, sleepMedium
    Send, {Control Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepMedium
    Send, ALT
    Sleep, sleepMedium
    Send, {ESC}
    Sleep, sleepMedium
    Send, {Shift Down}
    Sleep, sleepShort
    Send, 1
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Down}
    Sleep, sleepShort
    Send, {Shift Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepShort
    ;ITEM LOOP ENDS HERE
    SoundBeep
    return
+^!f15:: ; <-- Resetting a SHIFT Keyboard Template Key to SHIFT & set to opacity 10%
    ;ITEM LOOP STARTS HERE
    Sleep, sleepShort
    Click
    Sleep, sleepMedium
    Click,2
    Sleep, sleepMedium
    Send, {Control Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepMedium
    Send, SHIFT
    Sleep, sleepMedium
    Send, {ESC}
    Sleep, sleepMedium
    Send, {Shift Down}
    Sleep, sleepShort
    Send, 1
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Down}
    Sleep, sleepShort
    Send, {Shift Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepShort
    ;ITEM LOOP ENDS HERE
    SoundBeep
    return
+^!f16:: ; <-- Resetting a CTRL+ALT Keyboard Template Key to CTRL+ALT & set to opacity 10%
    ;ITEM LOOP STARTS HERE
    Sleep, sleepShort
    Click
    Sleep, sleepMedium
    Click,2
    Sleep, sleepMedium
    Send, {Control Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepMedium
    Send, CTRL{+}ALT
    Sleep, sleepMedium
    Send, {ESC}
    Sleep, sleepMedium
    Send, {Shift Down}
    Sleep, sleepShort
    Send, 1
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Down}
    Sleep, sleepShort
    Send, {Shift Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepShort
    ;ITEM LOOP ENDS HERE
    SoundBeep
    return
+^!f17::  ; <-- Resetting a CTRL+SHIFT Keyboard Template Key to CTRL+SHIFT & set to opacity 10%
    ;ITEM LOOP STARTS HERE
    Sleep, sleepShort
    Click
    Sleep, sleepMedium
    Click,2
    Sleep, sleepMedium
    Send, {Control Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepMedium
    Send, CTRL{+}SHIFT
    Sleep, sleepMedium
    Send, {ESC}
    Sleep, sleepMedium
    Send, {Shift Down}
    Sleep, sleepShort
    Send, 1
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Down}
    Sleep, sleepShort
    Send, {Shift Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepShort
    ;ITEM LOOP ENDS HERE
    SoundBeep
    return
+^!f18::  ; <-- Resetting a ALT+SHIFT Keyboard Template Key to ALT+SHIFT & set to opacity 10%
    ;ITEM LOOP STARTS HERE
    Sleep, sleepShort
    Click
    Sleep, sleepMedium
    Click,2
    Sleep, sleepMedium
    Send, {Control Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepMedium
    Send, ALT{+}SHIFT
    Sleep, sleepMedium
    Send, {ESC}
    Sleep, sleepMedium
    Send, {Shift Down}
    Sleep, sleepShort
    Send, 1
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Down}
    Sleep, sleepShort
    Send, {Shift Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepShort
    ;ITEM LOOP ENDS HERE
    SoundBeep
    return
+^!f19::   ; <-- Resetting a CTRL+ALT+SHIFT Keyboard Template Key to CTRL+ALT+SHIFT & set to opacity 10%
    ;ITEM LOOP STARTS HERE
    Sleep, sleepShort
    Click
    Sleep, sleepMedium
    Click,2
    Sleep, sleepMedium
    Send, {Control Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepMedium
    Send, CTRL{+}ALT{+}SHIFT
    Sleep, sleepMedium
    Send, {ESC}
    Sleep, sleepMedium
    Send, {Shift Down}
    Sleep, sleepShort
    Send, 1
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Down}
    Sleep, sleepShort
    Send, {Shift Down}
    Sleep, sleepShort
    Send, a
    Sleep, sleepShort
    Send, {Shift Up}
    Sleep, sleepShort
    Send, {Control Up}
    Sleep, sleepShort
    ;ITEM LOOP ENDS HERE
    SoundBeep
    return
#IfWinActive



#IfWinActive

;===== END SCAF DEFINITIONS ===============================================================

;===== FUNCTIONS ===============================================================================

RemoveSplashScreen:
    SplashTextOff
    SetTimer RemoveSplashScreen, Off
    return

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

