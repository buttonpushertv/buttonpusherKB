SetWorkingDir %A_ScriptDir%
#Include %A_ScriptDir%\DRAKE-FUNCTIONS.ahk
wantedProjectNumber := A_Args[1]
projectLookupByNumber(wantedProjectNumber)
lookupProjectNumberResult := getProjectByNumber()
Send, %lookupProjectNumberResult%
sleep, 333
Send, {ENTER}

ExitApp
