SetWorkingDir %A_ScriptDir%
#Include %A_ScriptDir%\DRAKE-FUNCTIONS.ahk
projectSubfolder = GRAPHICS
f_class := whichWindowType()
if f_class in #32770,ExploreWClass,CabinetWClass
    {
    InstantExplorer(projectSubfolder,1)
    }
    else openProjectInFCXE(projectSubfolder,1)

Exiting(projectSubfolder,1)
