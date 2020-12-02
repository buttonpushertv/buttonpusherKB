sleepTime := 5000
#SingleInstance force

EnvGet, Settings_rootFolder, BKB_ROOT
pingFile := Settings_rootFolder . "\SUPPORTING-FILES\yellow-cross.png"

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
wMode = %3%

pingPos(xpos, ypos, wMode)
ExitApp

; clickRadar is used to show a yellow-circle.png centered on the coords you send the function. The idea is that they should be centered on the coords you will be clicking on.
; to get the transparency working, we need to use the GDI+ library
; Based on the tutorial here: https://github.com/tariqporter/Gdip/blob/master/Gdip.Tutorial.3-Create.Gui.From.Image.ahk
pingPos(sx,sy,mode){
    global sleepTime
    global pingFile
    CoordMode, Mouse, %mode%
    ; this is all blackmagic provided by GDI+
    Gui, ShowPicture: -Caption +E0x80000 +LastFound +OwnDialogs +Owner +hwndhwnd +alwaysontop
    Gui, ShowPicture: Show, NA ,dialog
    pBitmap:=Gdip_CreateBitmapFromFile(pingFile)
    Gdip_GetImageDimensions(pBitmap,w,h)
    halfWidth := (w/2)
    halfHeight := (h/2)
    offsetSX := (sx-halfWidth)
    offsetSY := (sy-halfHeight)
    hbm := CreateDIBSection(w,h)
    hdc := CreateCompatibleDC()
    obm := SelectObject(hdc, hbm)
    pGraphics:=Gdip_GraphicsFromHDC(hdc)
    Gdip_DrawImage(pGraphics, pBitmap, 0,0,w,h)
    UpdateLayeredWindow(hwnd, hdc,offsetSX,offsetSY,w,h)
    Gdip_DisposeImage(pBitmap)
    ;MSgBox,4096,,Sent: x:%sx% y:%sy%`nOffset: x:%offsetSX% y:%offsetSY%`npingFile: %pingFile%`nmode: %mode%`nbitmap h: %h% width:%w%, 10
    sleep, sleepTime
    destroyGDIplusGUI()
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