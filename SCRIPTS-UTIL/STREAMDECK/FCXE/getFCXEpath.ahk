SetWorkingDir %A_ScriptDir%
#Include %A_ScriptDir%\FCXE-FUNCTIONS.ahk
SetTitleMatchMode, 2
gotPath := getFCXEPath()
pathGot = % gotPath
MsgBox, from getFCXEPath.ahk: %pathGot%
WinActivate, FreeCommander
exitapp
