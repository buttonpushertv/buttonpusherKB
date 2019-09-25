SetWorkingDir %A_ScriptDir%
#Include %A_ScriptDir%\FCXE-FUNCTIONS.ahk
projectSubfolder := "COLOR"
currentProject := getWorkingProject()
currentWorkingProject := currentProject . projectSubfolder
openFCXE(currentWorkingProject)
exitapp
