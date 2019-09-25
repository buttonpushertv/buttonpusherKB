SetWorkingDir %A_ScriptDir%
#Include %A_ScriptDir%\FCXE-FUNCTIONS.ahk
projectSubfolder := "SOURCES"
currentProject := getWorkingProject()
currentWorkingProject := currentProject . projectSubfolder
openFCXE(currentWorkingProject)
exitapp
