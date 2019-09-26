SetWorkingDir %A_ScriptDir%
#Include %A_ScriptDir%\DRAKE-FUNCTIONS.ahk

f_class := whichWindowType()
If f_class contains FreeCommander
    {
    currentProject := getWorkingProject()
    currentWorkingProject = % currentProject
    openFCXE(currentWorkingProject)
    }
    else {
      InstantExplorer("",1)
    }

exitapp
