SetWorkingDir %A_ScriptDir%
#Include %A_ScriptDir%\DRAKE-FUNCTIONS.ahk

gottenCurrentWorkingProject := getCurrentWorkingProject()
MsgBox, 262208, CURRENT WORKING PROJECT, The Current Working Project is:`n%gottenCurrentWorkingProject%, 8

ExitApp
