SetWorkingDir %A_ScriptDir%
#Include %A_ScriptDir%\FCXE-FUNCTIONS.ahk
SetTitleMatchMode, 2
currentProject := getWorkingProject()
currentWorkingProject = % currentProject
;MsgBox, %currentWorkingProject%
openFCXE(currentWorkingProject)
WinActivate, FreeCommander
exitapp
