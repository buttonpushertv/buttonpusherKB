SetWorkingDir %A_ScriptDir%
#Include %A_ScriptDir%\DRAKE-FUNCTIONS.ahk

f_class := whichWindowType()
If f_class contains FreeCommander
    {
      gotPath := getFCXEPath()
      pathGot = % gotPath
      } 
      else if f_class contains #32770
      {
      gotPath := Explorer_GetSelection()
      pathGot = % gotPath
      } 
      else if f_class contains ExploreWClass,CabinetWClass 
      {
      gotPath := Explorer_GetPath()
      pathGot = % gotPath
      } 
      else 
      {
        MsgBox, 262208, NOT IN CORRECT WINDOW, It looks as if you are not in a FreeCommanderXE`nor Windows Explorer Window, 5
        exitapp
      }
      MsgBox, You are in:`nApp:%f_class%`nPath:%pathGot%
  exitapp
