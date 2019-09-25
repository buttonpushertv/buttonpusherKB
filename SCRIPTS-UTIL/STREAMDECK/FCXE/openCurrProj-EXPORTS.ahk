SetWorkingDir %A_ScriptDir%
#Include %A_ScriptDir%\FCXE-FUNCTIONS.ahk
projectSubfolder := "EXPORTS"
currentProject := getWorkingProject()
currentWorkingProject := currentProject . projectSubfolder
;MsgBox, trying to open EXPORTS subfolder:`nprojectSubfolder:%projectSubfolder%`ncurrentProject:%currentProject%`ncurrenWorkingProject: %currentWorkingProject%
openFCXE(currentWorkingProject)
exitapp
