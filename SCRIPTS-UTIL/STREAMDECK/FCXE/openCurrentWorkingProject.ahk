SetWorkingDir %A_ScriptDir%
#Include %A_ScriptDir%\MASTER-REDIRECTOR.ahk

FileReadLine, currentWorkingProject, %A_ScriptDir%\CurrentWorkingProject.txt, 1
MsgBox, %currentWorkingProject%
openFCXE(currentWorkingProject)
exitapp

