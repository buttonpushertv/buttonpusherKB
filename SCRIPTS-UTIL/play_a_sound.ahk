; Play a sound when executed
;
; Accepts:
; Argument #1: will play the sound found at that location
; Argument #2: message to display in a tooltip
; Argument #3: tooltip duration (in milliseconds)

soundToPlay := A_Args[1]
tooltipMessage := A_Args[2]
tooltipDuration := A_Args[3]

If !(soundToPlay) {
    MsgBox, , How to use play-a-sound.ahk, To use this script, please execute with the following commandline arguments - in quotes & separated by spaces:`n#1 - path to sound`n#2 - Tooltip message to display when sound plays`n#3 - Tooltip duration, in milliseconds, before it gets removed (default = 3000), 8
    exitapp
}

If !(tooltipDuration) {
    tooltipDuration = 3000
}

If !(tooltipMessage) {
    tooltipMessage := "I did the thing!"
}

SoundPlay, %soundToPlay%
ToolTip, %tooltipMessage%
Sleep, %tooltipDuration%
ToolTip
;MSGBOX, Did you hear the sound?`n%soundToPlay%