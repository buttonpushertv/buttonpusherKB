SetWorkingDir %A_ScriptDir%
#Include %A_ScriptDir%\DRAKE-FUNCTIONS.ahk

projectLookupByNumber(1)
lookupProjectNumberResult := getProjectByNumber()
MsgBox, 262208, CURRENT WORKING PROJECT, The Current Working Project for %A_Computername% is:`n%lookupProjectNumberResult%, 8

ExitApp
