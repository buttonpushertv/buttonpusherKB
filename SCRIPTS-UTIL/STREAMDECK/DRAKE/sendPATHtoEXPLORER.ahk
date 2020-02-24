SetWorkingDir %A_ScriptDir%
#Include %A_ScriptDir%\DRAKE-FUNCTIONS.ahk

f_class := whichWindowType()
If f_class contains FreeCommander
    {
      gotPath := getFCXEPath()
      pathGot = % gotPath
      } 

InstantExplorer(pathGot,0)

WinActivate, ahk_exe Explorer.exe

exitapp
