SetWorkingDir %A_ScriptDir%
#Include %A_ScriptDir%\DRAKE-FUNCTIONS.ahk
projectSubfolder = EXPORTS
f_class := whichWindowType()
If f_class contains FreeCommander
    {
    currentProject := getWorkingProject()
    currentWorkingProject := currentProject . "\" . projectSubfolder
    openFCXE(currentWorkingProject)
    } else {
      InstantExplorer(projectSubfolder,1)
    }
exitapp
