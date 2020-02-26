SetWorkingDir %A_ScriptDir%
#Include %A_ScriptDir%\DRAKE-FUNCTIONS.ahk

Loop %A_ScriptDir%\*.ahk
    files .= (( files <> "" ) ? "|" : "" ) A_LoopFileName

Gui, Add, ComboBox, Simple w320 r20 vScript gRunScript, %files%
Gui, Add, Button, h25 +Default gRunScript2, Run Script
Gui, Show, x50 y50, AHK Scripts

Return ;                         // end of auto-execute section //

RunScript:
    IfNotEqual, A_GuiEvent, DoubleClick, Return

RunScript2:
    GuiControlGet, Script
    Run, %A_AhkPath% "%Script%"
    ExitApp
    Return

GuiClose:
GuiEscape:
ExitApp