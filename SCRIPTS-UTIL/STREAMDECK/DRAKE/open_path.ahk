SetWorkingDir %A_ScriptDir%
#Include %A_ScriptDir%\DRAKE-FUNCTIONS.ahk
projectSubfolder := A_Args[1]
f_class := whichWindowType()
if f_class contains #32770,ExploreWClass,CabinetWClass,AutoHotKeyGUI
    {
    InstantExplorer(projectSubfolder,0)
    }
    else openInFCXE(projectSubfolder)

Exiting(projectSubfolder,0)
