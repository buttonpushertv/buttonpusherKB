WinActivate, ahk_exe FreeCommander.exe
WinWaitActive, ahk_exe FreeCommander.exe, , 3
If ErrorLevel
{
    MsgBox, FreeCommander didn't open.
    Return
}
Else
    ExitApp