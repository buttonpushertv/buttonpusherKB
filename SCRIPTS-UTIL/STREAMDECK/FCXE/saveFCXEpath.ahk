SetWorkingDir %A_ScriptDir%
#Include %A_ScriptDir%\FCXE-FUNCTIONS.ahk

savedPath := getFCXEPath()
savePathForFCXE(savedPath)
exitapp
