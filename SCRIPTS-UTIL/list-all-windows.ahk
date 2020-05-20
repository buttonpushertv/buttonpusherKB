DetectHiddenWindows, On

WinGet windows, List
Loop %windows%
{
	id := windows%A_Index%
	WinGetTitle wt, ahk_id %id%
	r .= wt . "`n"
}
Clipboard := r
Run, notepad.exe
WinWaitActive, Untitled - Notepad
Send, ^V

DetectHiddenWindows, On
WinGet, wList, List, ahk_class AutoHotkey
MsgBox % "There is " ((wList>2) ? "more than " : "") "one AutoHotkey script open."
 ; will say 'more than one' if more than one script is currently running
return