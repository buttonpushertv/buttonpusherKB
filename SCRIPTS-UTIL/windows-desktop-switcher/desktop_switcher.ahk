#SingleInstance Force ; The script will Reload if launched while already running
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases
#KeyHistory 0 ; Ensures user privacy when debugging is not needed
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability

Menu, Tray, NoIcon ; removes the tray icon

; This script was originally found here: https://www.computerhope.com/tips/tip224.htm
;
; And then I found this expanded script at: https://github.com/pmb6tz/windows-desktop-switcher
;
; I added the GUI to inform you which Desktop you are switching to or deleting/adding.

; The 2 lines below pertain to the 'reload on save' function below (CheckScriptUpdate).
; They are required for it to work.
FileGetTime ScriptStartModTime, %A_ScriptFullPath%
SetTimer CheckScriptUpdate, 100, 0x7FFFFFFF ; 100 ms, highest priority


; Globals
DesktopCount := 2        ; Windows starts with 2 desktops at boot
CurrentDesktop := 1      ; Desktop count is 1-indexed (Microsoft numbers them this way)
LastOpenedDesktop := 1

; DLL
hVirtualDesktopAccessor := DllCall("LoadLibrary", "Str", A_ScriptDir . "\VirtualDesktopAccessor.dll", "Ptr")
global IsWindowOnDesktopNumberProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "IsWindowOnDesktopNumber", "Ptr")
global MoveWindowToDesktopNumberProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "MoveWindowToDesktopNumber", "Ptr")

;======================================
; Main
SetKeyDelay, 75
mapDesktopsFromRegistry()
OutputDebug, [loading] desktops: %DesktopCount% current: %CurrentDesktop%

showGUI("Launching Virtual Desktop Helper`nCurrently on Desktop:", CurrentDesktop)

#Include %A_ScriptDir%\user_config.ahk

return

;=====================================

;
; This function examines the registry to build an accurate list of the current virtual desktops and which one we're currently on.
; Current desktop UUID appears to be in HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SessionInfo\1\VirtualDesktops
; List of desktops appears to be in HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops
;
mapDesktopsFromRegistry()
{
    global CurrentDesktop, DesktopCount

    ; Get the current desktop UUID. Length should be 32 always, but there's no guarantee this couldn't change in a later Windows release so we check.
    IdLength := 32
    SessionId := getSessionId()
    if (SessionId) {
        RegRead, CurrentDesktopId, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SessionInfo\%SessionId%\VirtualDesktops, CurrentVirtualDesktop
        if (CurrentDesktopId) {
            IdLength := StrLen(CurrentDesktopId)
        }
    }

    ; Get a list of the UUIDs for all virtual desktops on the system
    RegRead, DesktopList, HKEY_CURRENT_USER, SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops, VirtualDesktopIDs
    if (DesktopList) {
        DesktopListLength := StrLen(DesktopList)
        ; Figure out how many virtual desktops there are
        DesktopCount := floor(DesktopListLength / IdLength)
    }
    else {
        DesktopCount := 1
    }

    ; Parse the REG_DATA string that stores the array of UUID's for virtual desktops in the registry.
    i := 0
    while (CurrentDesktopId and i < DesktopCount) {
        StartPos := (i * IdLength) + 1
        DesktopIter := SubStr(DesktopList, StartPos, IdLength)
        OutputDebug, The iterator is pointing at %DesktopIter% and count is %i%.

        ; Break out if we find a match in the list. If we didn't find anything, keep the
        ; old guess and pray we're still correct :-D.
        if (DesktopIter = CurrentDesktopId) {
            CurrentDesktop := i + 1
            OutputDebug, Current desktop number is %CurrentDesktop% with an ID of %DesktopIter%.
            break
        }
        i++
    }
}

;
; This functions finds out ID of current session.
;
getSessionId()
{
    ProcessId := DllCall("GetCurrentProcessId", "UInt")
    if ErrorLevel {
        OutputDebug, Error getting current process id: %ErrorLevel%
        return
    }
    OutputDebug, Current Process Id: %ProcessId%

    DllCall("ProcessIdToSessionId", "UInt", ProcessId, "UInt*", SessionId)
    if ErrorLevel {
        OutputDebug, Error getting session id: %ErrorLevel%
        return
    }
    OutputDebug, Current Session Id: %SessionId%
    return SessionId
}

_switchDesktopToTarget(targetDesktop)
{
    ; Globals variables should have been updated via updateGlobalVariables() prior to entering this function
    global CurrentDesktop, DesktopCount, LastOpenedDesktop

    ; Don't attempt to switch to an invalid desktop
    if (targetDesktop > DesktopCount || targetDesktop < 1 || targetDesktop == CurrentDesktop) {
        OutputDebug, [invalid] target: %targetDesktop% current: %CurrentDesktop%
        return
    }

    LastOpenedDesktop := CurrentDesktop

    ; Fixes the issue of active windows in intermediate desktops capturing the switch shortcut and therefore delaying or stopping the switching sequence. This also fixes the flashing window button after switching in the taskbar. More info: https://github.com/pmb6tz/windows-desktop-switcher/pull/19
    WinActivate, ahk_class Shell_TrayWnd

    ; Go right until we reach the desktop we want
    while(CurrentDesktop < targetDesktop) {
        Send ^#{Right}
        CurrentDesktop++
        OutputDebug, [right] target: %targetDesktop% current: %CurrentDesktop%
    }

    ; Go left until we reach the desktop we want
    while(CurrentDesktop > targetDesktop) {
        Send ^#{Left}
        CurrentDesktop--
        OutputDebug, [left] target: %targetDesktop% current: %CurrentDesktop%
    }

; THIS PIECE OF CODE CAUSES THE SCRIPT TO HANG & NOT PROCESS FUTURE KEYS
    ; Makes the WinActivate fix less intrusive
    ;Sleep, 50
    ;focusTheForemostWindow(targetDesktop)
; NOT REALLY SURE WHY OR WHAT THIS 'FIXES' - IT SEEMS TO BREAK THINGS FOR ME -- BEN

    showGUI("Switched to Desktop:",CurrentDesktop)
    SetCapsLockState, Off
    Send, {Control Up}{Alt Up}{Shift Up}
}

updateGlobalVariables()
{
    ; Re-generate the list of desktops and where we fit in that. We do this because
    ; the user may have switched desktops via some other means than the script.
    mapDesktopsFromRegistry()
}

switchDesktopByNumber(targetDesktop)
{
    global CurrentDesktop, DesktopCount
    updateGlobalVariables()
    if (targetDesktop > DesktopCount) {
    moveAction = Desktop Does Not Exist.`nChoose one between 1 and %DesktopCount%
    showGUI(moveAction, targetDesktop)
    }
    else if (targetDesktop = CurrentDesktop) {
        showGUI("Currently on Desktop:", CurrentDesktop)
    }
    _switchDesktopToTarget(targetDesktop)
}

switchDesktopToLastOpened()
{
    global CurrentDesktop, DesktopCount, LastOpenedDesktop
    updateGlobalVariables()
    _switchDesktopToTarget(LastOpenedDesktop)
}

switchDesktopToRight()
{
    global CurrentDesktop, DesktopCount
    updateGlobalVariables()
    _switchDesktopToTarget(CurrentDesktop == DesktopCount ? 1 : CurrentDesktop + 1)
}

switchDesktopToLeft()
{
    global CurrentDesktop, DesktopCount
    updateGlobalVariables()
    _switchDesktopToTarget(CurrentDesktop == 1 ? DesktopCount : CurrentDesktop - 1)
}

focusTheForemostWindow(targetDesktop) {
    foremostWindowId := getForemostWindowIdOnDesktop(targetDesktop)
    if isWindowNonMinimized(foremostWindowId) {
        WinActivate, ahk_id %foremostWindowId%
    }
}

isWindowNonMinimized(windowId) {
    WinGet MMX, MinMax, ahk_id %windowId%
    return MMX != -1
}

getForemostWindowIdOnDesktop(n)
{
    n := n - 1 ; Desktops start at 0, while in script it's 1

    ; winIDList contains a list of windows IDs ordered from the top to the bottom for each desktop.
    WinGet winIDList, list
    Loop % winIDList {
        windowID := % winIDList%A_Index%
        windowIsOnDesktop := DllCall(IsWindowOnDesktopNumberProc, UInt, windowID, UInt, n)
        ; Select the first (and foremost) window which is in the specified desktop.
        if (windowIsOnDesktop == 1) {
            return windowID
        }
    }
}

MoveCurrentWindowToDesktop(desktopNumber) {
    global CurrentDesktop, DesktopCount
    if (desktopNumber > DesktopCount) {
        moveAction = Desktop Does Not Exist.`nChoose one between 1 and %DesktopCount%
        showGUI(moveAction, desktopNumber)
    }
    WinGet, activeHwnd, ID, A
    DllCall(MoveWindowToDesktopNumberProc, UInt, activeHwnd, UInt, desktopNumber - 1)
    switchDesktopByNumber(desktopNumber)
    Sleep, 333
    WinActivate, ahk_id %activeHwnd%
}

MoveCurrentWindowToRightDesktop()
{
    global CurrentDesktop, DesktopCount
    updateGlobalVariables()
    WinGet, activeHwnd, ID, A
    DllCall(MoveWindowToDesktopNumberProc, UInt, activeHwnd, UInt, (CurrentDesktop == DesktopCount ? 1 : CurrentDesktop + 1) - 1)
    _switchDesktopToTarget(CurrentDesktop == DesktopCount ? 1 : CurrentDesktop + 1)
    Sleep, 333
    WinActivate, ahk_id %activeHwnd%
}

MoveCurrentWindowToLeftDesktop()
{
    global CurrentDesktop, DesktopCount
    updateGlobalVariables()
    WinGet, activeHwnd, ID, A
    DllCall(MoveWindowToDesktopNumberProc, UInt, activeHwnd, UInt, (CurrentDesktop == 1 ? DesktopCount : CurrentDesktop - 1) - 1)
    _switchDesktopToTarget(CurrentDesktop == 1 ? DesktopCount : CurrentDesktop - 1)
    Sleep, 333
    WinActivate, ahk_id %activeHwnd%
}

;
; This function creates a new virtual desktop and switches to it
;
createVirtualDesktop()
{
    global CurrentDesktop, DesktopCount
    Send, #^d
    DesktopCount++
    CurrentDesktop := DesktopCount
    showGUI("Created Virtual Desktop:",DesktopCount)
    OutputDebug, [create] desktops: %DesktopCount% current: %CurrentDesktop%
}

;
; This function deletes the current virtual desktop
;
deleteVirtualDesktop()
{
    global CurrentDesktop, DesktopCount, LastOpenedDesktop
    Send, #^{F4}
    oldDesktop = %CurrentDesktop%
	deleteAction = Deleted Desktop:%oldDesktop%`nSwitched to:
    if (LastOpenedDesktop >= CurrentDesktop) {
        LastOpenedDesktop--
    }
	DesktopCount--
	CurrentDesktop--
	showGUI(deleteAction, CurrentDesktop)
    OutputDebug, [delete] desktops: %DesktopCount% current: %CurrentDesktop%
}

showGUI(action, desktop) {
    global CurrentDesktop, DesktopCount, LastOpenedDesktop
    removeGUI()
    SysGet, monSize, Monitor
    guiStartHeight := monSizeBottom - 400
    Sleep, 666
	CustomColor := "cddefa"
	Gui, +AlwaysOnTop +Disabled -SysMenu +Owner -Caption +ToolWindow  ; +Owner avoids a taskbar button.
	Gui, Color, %CustomColor%
	Gui, Font, s20
	Gui, Add, Text, x50 w500 +Center, %action%
	Gui, Font, s72
	Gui, Add, Text, x50 w500 +Center, %desktop%
    if (CurrentDesktop = 1 && desktop < DesktopCount) {
        Gui, Add, Picture, w50 h-1 x0 y0, rect-50x300-dark-red.png
    }
    if (CurrentDesktop > 1) {
        Gui, Add, Picture, w50 h-1 x0 y0, rect-50x300-dark-green.png
    }
	if (CurrentDesktop < DesktopCount  && desktop < DesktopCount) {
        Gui, Add, Picture, w50 h-1 x550 y0, rect-50x300-dark-green.png
    }
    if (CurrentDesktop >= DesktopCount) {
        Gui, Add, Picture, w50 h-1 x550 y0, rect-50x300-dark-red.png
    }
    if (desktop > DesktopCount) {
    }
	Gui, Show, w600 h200 y%guiStartHeight% NoActivate, ; NoActivate avoids deactivating the currently active window.
	timedGUIremove(1000)
	return
}

removeGUI() {
	Gui, Destroy
	return
	}

timedGUIremove(time) {
	SetTimer, destroyGUI, %time%
	Return
	
	destroyGUI:
	removeGUI()
	return
}


; This function will auto-reload the script on save.
CheckScriptUpdate() {
    global ScriptStartModTime
    FileGetTime curModTime, %A_ScriptFullPath%
    If (curModTime <> ScriptStartModTime) {
        Loop
        {
            reload
            Sleep 333 ; ms
            MsgBox 0x2, %A_ScriptName%, Reload failed. ; 0x2 = Abort/Retry/Ignore
            IfMsgBox Abort
                ExitApp
            IfMsgBox Ignore
                break
        } ; loops reload on "Retry"
    }
}
