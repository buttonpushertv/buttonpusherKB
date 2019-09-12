#NoEnv
#SingleInstance, Force

    Gui, +AlwaysOnTop
    Gui, Add, Text,, Currently running AHK-scripts:
    Gui, Add, ListBox, r15 w450 vLB_scripts
    Gui, Add, Button, w70, Refresh
    Gui, Add, Button, x+m wp, Cancel
    Gui, Show
    Gosub, ButtonRefresh
    ;~ SetTimer, ButtonRefresh ; "real-time"

Return


;-------------------------------------------------------------------------------
;~ ^F5::                   	; hotkey
;-------------------------------------------------------------------------------
ButtonRefresh:              ; GUI button
;-------------------------------------------------------------------------------
    DetectHiddenWindows, On
    WinGet, hwnd, List, ahk_class AutoHotkey
    Result := ""
    Loop, %hwnd% {
        WinGetTitle, Title, % "ahk_id " hwnd%A_Index%
        Title := RegExReplace(Title, " - .*")
        ;SplitPath, Title, Title
        Result .= Title "|"
    }
    GuiControl,, LB_scripts, |%Result%

Return


GuiClose:
ButtonCancel:
ExitApp