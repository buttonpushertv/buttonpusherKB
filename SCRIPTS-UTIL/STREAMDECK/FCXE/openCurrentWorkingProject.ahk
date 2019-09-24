FileRead, currentWorkingProject, CurrentWorkingProject.txt
MsgBox, %currentWorkingProject%
openFCXE(currentWorkingProject)
exitapp

SetWorkingDir %A_ScriptDir%
#Include %A_ScriptDir%\MASTER-REDIRECTOR.ahk
