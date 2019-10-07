SetWorkingDir %A_ScriptDir%
#Include %A_ScriptDir%\DRAKE-FUNCTIONS.ahk
projectSubfolder = EXPORTS\MASTERS
f_class := whichWindowType()
If f_class contains FreeCommander
    {
    openFCXE(projectSubfolder,1)
    }
    else InstantExplorer(projectSubfolder,1)

Exiting(projectSubfolder,1)
