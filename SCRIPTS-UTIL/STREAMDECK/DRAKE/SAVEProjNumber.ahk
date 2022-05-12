SetWorkingDir %A_ScriptDir%
#Include %A_ScriptDir%\DRAKE-FUNCTIONS.ahk

; Getting the rootFolder for BKB from the Environment Variable
EnvGet, Settings_rootFolder, BKB_ROOT

dontSetCurrProj :=
projectNumber := A_Args[1]
if (!projectNumber) {
    projectNumber = 1
}

; this section will identify the type of window you are sitting within: Explorer, Windows Save Dialog, or FreeCommander window and extract the path from that window using functions within DRAKE-FUNCTIONS.ahk (included above).
f_class := whichWindowType()
If f_class contains FreeCommander ; if it's a FreeCommander window
{
  gotPath := getFCXEPath()
  pathGot = % gotPath
}
else if f_class contains #32770 ; if it's another Window Dialog window
{
    gotPath := Explorer_GetPath()
    pathGot = % gotPath

}
else if f_class contains ExploreWClass,CabinetWClass ; if it's a Windows Explorer window
{
  gotPath := Explorer_GetPath()
  pathGot = % gotPath
}
else ; or identify that the type of window you're in or that it can't extract the path
{
  dontSetCurrProj := 1
  MsgBox, 262208, NOT IN CORRECT WINDOW, It looks as if you are not in a FreeCommanderXE`nor Windows Explorer Window, 5
  exitapp
}

InputBox, projectSlug, Project Short Name, What's a short name for this project?`nYou sitting in this folder:`n%pathGot%,,450,,,,,,

If ErrorLevel
  exitapp
else
  ; savePath(pathGot) ; this will actually save the path that was extracted from whatever type of window.
  ; the above is just a fall back. It may not even be needed for the script to function - disabled for now

If !dontSetCurrProj {
  setProjectNumber(pathGot, projectNumber, projectSlug)
}

fffSettingsCreator(pathGot)

exitapp

