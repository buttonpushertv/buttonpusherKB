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

xpos = %1%
ypos = %2%

MSGBOX, , DEBUG, xpos: %xpos% / ypos: %ypos%
clickRadar(xpos, ypos)
Sleep, 10000
ExitApp

; clickRadar is used to show a yellow-circle.png centered on the coords you send the function. The idea is that they should be centered on the coords you will be clicking on.
; to get the transparency working, we need to use the GDI+ library
; Based on the tutorial here: https://github.com/tariqporter/Gdip/blob/master/Gdip.Tutorial.3-Create.Gui.From.Image.ahk
clickRadar(sx,sy){
    global sleepShort
    ; we are going to store the position of your cursor when you show this so that we can put the cursor back where it was
	;coordmode, mouse, Screen
	MouseGetPos, xposP, yposP
    offsetSX := (sx - 25)
    offsetSY := (sy - 25)
    MSgBox, Sent: %sx%, %sy%`nOffset: %offsetSX%, %offsetSY%`nGrabbed: %xposP%, %yposP%
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
    sleep, sleepShort
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