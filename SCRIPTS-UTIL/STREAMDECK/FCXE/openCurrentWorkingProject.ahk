SetWorkingDir %A_ScriptDir%
#Include %A_ScriptDir%\FCXE-FUNCTIONS.ahk
SetTitleMatchMode, 2
WinActivate, FreeCommander
currentProject := getWorkingProject()
currentWorkingProject = % currentProject
;MsgBox, %currentWorkingProject%
openFCXE(currentWorkingProject)
WinActivate, FreeCommander
exitapp
