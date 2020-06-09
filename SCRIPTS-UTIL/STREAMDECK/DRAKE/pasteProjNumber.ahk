SetWorkingDir %A_ScriptDir%
#Include %A_ScriptDir%\DRAKE-FUNCTIONS.ahk



gottenCurrentWorkingProject := getCurrentWorkingProject()
Send, %gottenCurrentWorkingProject%
sleep, 333
Send, {ENTER}

ExitApp
