SetWorkingDir %A_ScriptDir%
#Include %A_ScriptDir%\DRAKE-FUNCTIONS.ahk
projectSubfolder = _PROJECTS_
projectNumber := A_Args[1]
if (!projectNumber) {
    projectNumber =1
}
f_class := whichWindowType()
if f_class contains #32770,ExploreWClass,CabinetWClass,AutoHotKeyGUI
    {
    InstantExplorer(projectSubfolder,projectNumber)
    }
    else openProjectInFCXE(projectSubfolder,projectNumber)

Exiting(projectSubfolder,projectNumber)
