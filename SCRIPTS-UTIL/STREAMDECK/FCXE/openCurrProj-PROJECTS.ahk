SetWorkingDir %A_ScriptDir%
#Include %A_ScriptDir%\FCXE-FUNCTIONS.ahk
projectSubfolder := "_PROJECTS_"
currentProject := getWorkingProject()
currentWorkingProject := currentProject . projectSubfolder
;MsgBox, trying to open %projectFolder% subfolder:`nprojectSubfolder:%projectSubfolder%`ncurrentProject:%currentProject%`ncurrenWorkingProject: %currentWorkingProject%
openFCXE(currentWorkingProject)
exitapp
