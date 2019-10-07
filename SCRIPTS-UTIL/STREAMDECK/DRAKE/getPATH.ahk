SetWorkingDir %A_ScriptDir%
#Include %A_ScriptDir%\DRAKE-FUNCTIONS.ahk

f_class := whichWindowType()
If f_class contains FreeCommander
    {
      gotPath := getFCXEPath()
      pathGot = % gotPath
      } else if f_class contains #32770
      {
      gotPath := Explorer_GetSelection()
      pathGot = % gotPath
      }
      else {
      gotPath := Explorer_GetPath()
      pathGot = % gotPath
      }
MsgBox, You are in:`nApp:%f_class%`nPath:%pathGot%`n`ngotPath:%gotPath%
exitapp
