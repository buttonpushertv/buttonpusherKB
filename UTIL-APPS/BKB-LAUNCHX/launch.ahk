#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance,force

; Uncomment the lines below if you want to make sure this script gets launched at every boot
;FileCreateShortcut,%A_ScriptFullPath%,%A_Startup%/launch.lnk
;IfExist,%A_Startup%/launch.lnk
;{
;FileDelete,%A_Startup%/launch.lnk
;FileCreateShortcut,%A_ScriptFullPath%,%A_Startup%/launch.lnk
;}

#NoEnv
#SingleInstance, force
SetWorkingDir %A_ScriptDir%
FileReadLine,current,settings.ini,3
IniRead,currentfile,settings.ini,filelog,current
   if(currentfile= "ERROR")
   {
      IniWrite,0,settings.ini,filelog,current
   }
IniRead,nextfile,settings.ini,filelog,next
   if(nextfile= "ERROR")
   {
      IniWrite,1,settings.ini,filelog,next
   }
IniRead,current3,settings.ini,filelog,extra
   if(current3= "ERROR")
   {
      IniWrite,0,settings.ini,filelog,extra
   }

;===== SPLASH SCREEN TO ANNOUNCE WHAT SCRIPT DOES ==============================================
SplashTextOn, 600, 80, Launching %A_ScriptFullPath%, Loading ButtonpusherTV-LAUNCH-X.`nWindows-T to open the launcher.
Sleep, 3500
SplashTextOff

Hotkey,%current%,ShowGui,On
return

ShowGui:
Run,launcher.ahk
return

GuiClose:
ExitApp


;===== FUNCTIONS ===============================================================================
