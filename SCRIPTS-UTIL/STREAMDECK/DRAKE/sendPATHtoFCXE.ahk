SetWorkingDir %A_ScriptDir%
#Include %A_ScriptDir%\DRAKE-FUNCTIONS.ahk

f_class := whichWindowType()
if f_class contains #32770
      {
      gotPath := Explorer_GetSelection()
      pathGot = % gotPath
      }
else {
      gotPath := Explorer_GetPath()
      pathGot = % gotPath
      }

openInFCXE(pathGot)

WinActivate, ahk_exe FreeCommander.exe

exitapp
