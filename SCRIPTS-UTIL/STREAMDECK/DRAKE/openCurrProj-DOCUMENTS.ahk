SetWorkingDir %A_ScriptDir%
#Include %A_ScriptDir%\DRAKE-FUNCTIONS.ahk
projectSubfolder = DOCUMENTS
f_class := whichWindowType()
if f_class contains #32770,ExploreWClass,CabinetWClass,AutoHotKeyGUI
    {
    InstantExplorer(projectSubfolder,1)
    }
    else openProjectInFCXE(projectSubfolder,1)

Exiting(projectSubfolder,1)
