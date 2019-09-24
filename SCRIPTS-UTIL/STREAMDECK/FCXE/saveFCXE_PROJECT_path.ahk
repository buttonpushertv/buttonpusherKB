getFCXEPath()
FileCopy, %A_ScriptDir%\SavedPathForFCXE.txt, %A_ScriptDir%\CurrentWorkingProject.txt
exitapp

SetWorkingDir %A_ScriptDir%
#Include %A_ScriptDir%\MASTER-REDIRECTOR.ahk
