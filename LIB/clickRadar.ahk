; Click Radar - This supporting script is meant to be included in any script where you want to use the 'clickRadar' function. It relies on the 'gdip.ahk' library. (That's why it lives in the same LIB folder.

; The idea is that, since often times when we want to click on UI elements, they need to be located at a certain spot on the screen. This function will show a yellow-circle centered on the x & y coordinates we will be clicking.



#include C:\BKB\LIB\gdip.ahk
;Thanks to tic (Tariq Porter) for his GDI+ Library
;ahkscript.org/boards/viewtopic.php?t=6517

If !pToken := Gdip_Startup() ; this is here just to test that the GDI+ library is available at the path in the above #include
{
	MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
	ExitApp
}
OnExit, GdiplusExit

; clickRadar is used to show a yellow-circle.png centered on the coords you send the function. The idea is that they should be centered on the coords you will be clicking on.
; to get the transparency working, we need to use the GDI+ library
; Based on the tutorial here: https://github.com/tariqporter/Gdip/blob/master/Gdip.Tutorial.3-Create.Gui.From.Image.ahk
clickRadar(sx,sy){
	; this is all blackmagic provided by GDI+
  Gui, ShowPicture:  -Caption +E0x80000 +LastFound +OwnDialogs +Owner +hwndhwnd +alwaysontop
  Gui, ShowPicture: Show, NA ,dialog

  pBitmap:=Gdip_CreateBitmapFromFile("yellow-circle.png")
  Gdip_GetImageDimensions(pBitmap,w,h)

  hbm := CreateDIBSection(w,h)
  hdc := CreateCompatibleDC()
  obm := SelectObject(hdc, hbm)
  pGraphics:=Gdip_GraphicsFromHDC(hdc)

  Gdip_DrawImage(pGraphics, pBitmap, 0,0,w,h)
  UpdateLayeredWindow(hwnd, hdc,sx,sy,w,h)
  Gdip_DisposeImage(pBitmap)
return
}

destroyGDIplusGUI(){ ; this should not only kill the ShowPicture but free up everything it used and reset things for the next time a CheatSheet is shown (we want showPicture to be set to 0)
	global xposP, yposP
  global showPicture
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
	coordmode, mouse, Screen
	MouseMove, xposP, yposP ; this puts the cursor back where it came from before we showed this cheatsheet
  Return
}

GdiplusExit:
; gdi+ may now be shutdown on exiting the program
Gdip_Shutdown(pToken)
ExitApp