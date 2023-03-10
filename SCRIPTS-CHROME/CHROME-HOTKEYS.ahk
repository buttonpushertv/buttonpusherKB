; AutoHotKey - CHROME-HOTKEYS.ahk
; by Ben Howard - ben@buttonpusher.tv

;===== START OF AUTO-EXECUTION SECTION =========================================================
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; #Persistent ; Keeps script permanently running.
#SingleInstance force ; Ensures that there is only a single instance of this script running.
; SetTitleMatchMode, 2 ; sets title matching to search for "containing" instead of "exact"

Menu, Tray, NoIcon ; removes the tray icon
;===== INITIALIZATION - VARIABLES ==============================================================
; Sleep shortcuts - use these to standardize sleep times
sleepMicro := 5
sleepMini := 15
sleepShort := 333
sleepMedium := 666
sleepLong := 1500
sleepDeep := 3500

#Include, C:\BKB\SCRIPTS-UTIL\CaptureScreen.ahk

;===== END OF AUTO-EXECUTE =====================================================================
;===== MODIFIER MEMORY HELPER ==================================================================
; combine below with key and '::' to define hotkey 
; e.g.- ^f1::Msgbox You pressed Control and F1
; #=Win | !=Alt | ^=Ctrl | +=Shift | &=combine keys | *=ignore other mods
; <=use left mod key| >=use right mod key  | UP=fires on release

;===== MAIN HOTKEY DEFINITIONS HERE ============================================================

#IfWinActive, ahk_exe chrome.exe

F22:: ;<-- Morvold Press Master Maps List click on link & switch to that tab
    MouseGetPos, xposP, yposP  
    Send, ^{Click}
    Sleep, sleepShort
    Send, ^{Tab}
    Sleep, sleepShort
    Sleep, sleepDeep
    ImageSearch, foundLinkX, foundLinkY, 680, 380, 1400, 2300, C:\BKB\PRIVATE\GAMING_SCRIPTS\Xchrome_morvold-press-link-image-to-match.png
    If ErrorLevel
    {
        SoundPlay, C:\BKB\SUPPORTING-FILES\SOUNDS\interfaceanditemsounds\V.3.0 Files\Buzz Error (7).wav
        MSGBOX, DEBUG, found the image at: X: %foundLinkX% | Y: %foundLinkY%`n`nMoving to X: %destLinkX% | Y: %destLinkY%
        Return
    }
    Sleep, sleepLong
    destLinkX := foundLinkX+20
    destLinkY := foundLinkY+10
    SoundPlay, C:\BKB\SUPPORTING-FILES\SOUNDS\interfaceanditemsounds\V1.0\Interface\Futuristic\Future Sounds (2).wav
    MouseMove, destLinkX, destLinkY
    Sleep, sleepShort
    Click
    Sleep, sleepShort
    
    yposP += 278
    MouseMove, xposP, yposP ; this puts the cursor back where it came from 
Return
    

F23:: ;<--Start a Google Drive link download from a page with NO blue button
    Send, {Tab}
    Sleep, sleepShort
    Send, {Tab}
    Sleep, sleepShort
    Send, {Tab}
    Sleep, sleepShort
    Send, {Tab}
    Sleep, sleepMedium
    Send, {Enter}
    Sleep, sleepMedium
    Send, {Tab}
    Sleep, sleepMedium
    Send, {Tab}
    Sleep, sleepLong
    Send, {Enter}
    SoundPlay, C:\BKB\SUPPORTING-FILES\SOUNDS\interfaceanditemsounds\V1.0\Interface\Futuristic\Future Sounds (8).wav
    Sleep, sleepLong
    Send, ^w
    Sleep, sleepShort
    Send, ^w
    Sleep, sleepShort
    Send, ^w
    Sleep, sleepShort
Return

F24:: ;<-- Start a Google Drive link download when there's a blue button to click
    Send, {Tab}
    Sleep, sleepShort
    Send, {Enter}
    Sleep, sleepLong
    Send, {Tab}
    Sleep, sleepMedium
    Send, {Tab}
    Sleep, sleepLong
    Send, {Enter}
    SoundPlay, C:\BKB\SUPPORTING-FILES\SOUNDS\interfaceanditemsounds\V1.0\Interface\Futuristic\Future Sounds (9).wav
    Sleep, sleepLong
    Send, ^w
    Sleep, sleepShort
    Send, ^w
    Sleep, sleepShort
    Send, ^w
    Sleep, sleepShort
Return


^F24:: ; <-- Reload CHROME-HOTKEYS.ahk
    MSGBOX, , DEBUG,Reloading Chrome-Hotkeys
    Reload
    Return

#IfWinActive
;===== FUNCTIONS ===============================================================================

shutterStockClickAndClose() {
    Click, 600, 715
    Sleep, 1500
    Send, {Control Down}w
    Send, {Blind}{Control Up}
    Return
}

FirstUsageSinceLaunch(messageBoxText) {
/*
    PURPOSE: This function creates a message that gets shown the first time you use a hotkey that contains something like the code below.
    USAGE: In order to use this function, place this code block at the top of any hotkey definition block where you want to use it. Change the 'message' to customize it. You can use '`n' to begin a new line.

        message := "This is the first time you've launched hotkey this since you've started buttonpusherKB."
        
        if (!tempMessageSeen) ; test this local variable
        {
            FirstUsageSinceLaunch(message) ; calls the function
            IfMsgBox, Cancel ; tests if you want to cancel this hotkey from executing.
            Return ; that means it will re-run this block again the next time you press this hotkey
            tempMessageSeen := 1 ; setting this to a non-zero value means the 'if' statement above will skip this whole block and move on to the 'else' section
            ; keep in mind that the variable set here (not inside a function) will be global, so you probably should change it to a unique name within each instance of using this code block.
            ;anything else you wish to do on this first time pressing this hotkey can be executed here
        }
        ; the 'else' below is optional. Most of the time, you can just delete it.
        else ; this 'else' section is only here if you want to do something different when this is not the first time pressing this hotkey.
        MSGBOX, , DEBUG, Already been run. ; this command is just an example to show that the 'else' is doing something.

    IMPORTANT: This message will always appear the very first time you press a hotkey that contains the above code for the first time after launching this script
*/

    MSGBOX, 49, First Launch Since Usage, %messageBoxText%
    Return
}

;====== INACTIVE HOTKEYS =======================================================================
; Hotkey defs here to hold them inactive for later use.
/*

!z:: ; <-- FCM - leave fullscreen, continue to next video, and then setting back to fullscreen
    ; currently set for use on Xeonator Laptop
    Send, {Escape}
    Sleep, sleepMedium
    Click, 2960,2130
    Sleep, sleepLong
    Click, 3250,2130
    Sleep, sleepDeep
    Click, 2344,1408
    Sleep, 3000
    Click, 3378,1973
    Return


F24:: ; <-- Press Right Arrow looped number of times
loopAmount := 14
Loop, %loopAmount%
{
    Send, {Right}
    Sleep, sleepShort
}
Return

F23:: ; <-- Press Left Arrow looped number of times
loopAmount := 14
Loop, %loopAmount%
{
    Send, {Left}
    Sleep, sleepShort
}
Return

F16:: ; <-- Press Up Arrow looped number of times
loopAmount := 6
Loop, %loopAmount%
{
    Send, {Up}
    Sleep, sleepShort
}
Return

F20:: ; <-- Press Down Arrow looped number of times
loopAmount := 6
Loop, %loopAmount%
{
    Send, {Down}
    Sleep, sleepShort
}
Return

CoordMode, Mouse, Client
F22:: ; <-- capture the screen and prompt for file name
    InputBox, ImageToGrab, Image filename?, What name should this grab be called?,,,,,,,,C:\BKB\PRIVATE\GAMING_SCRIPTS\TEST\FMG_IMAGE
    Sleep, sleepMedium
    if ErrorLevel
        MsgBox, CANCEL was pressed
    else
        CaptureScreen("58,0,3440,1390",0,ImageToGrab)
Return

!z:: ; <-- No idea what this is for....
    Send, {Escape}
    Sleep, sleepMedium
    Click, 1300, 975
    Sleep, sleepLong
    Click, 1100, 620
    Sleep, sleepLong
    Click, 1561, 872
    Return


F21:: ; <-- Downloading Comps from a ShutterStock Single Image page
    ; This will auto-magically download comp versions of video clips from iStockPhoto.com
    ; It will do this by doing the following: 
    ;   -Store the current position of the cursor when hotkey is pressed.
    ;   -Shift Middle-Click on a clip in a board to open in new tab. 
    ;   -Activate that new tab.
    ;   -Left click on the 'Try' link to download a comp
    ;   -Wait 2/3 second.
    ;   -Close the Tab.
    ;   -Restore cursor to position where it started.
    ;
    ; There are a few things you need to setup/make sure of before using this hotkey:
    ;   1-Use Chrome (that's why it's in the CHROME-HOTKEYS.ahk)
    ;   2-Make sure Chrome view is set to 100%
    ;   3-Be using an Shutterstock.com Board. See the F19 version for saving from a Video's page directly.
    ;   4-You will need to move the downloaded comp videos to an appropriate location for your project.
    ;     (FileJuggler can help move them auto-magically from the 'Downloads' folder - if you are getting a large number of clips)
    ;
    MouseGetPos, xposP, yposP ;---storing cursor's current coordinates at X%xposP% Y%yposP%
    Sleep, sleepShort
    shutterStockClickAndClose()
    MouseMove, xposP, yposP
    Return


F22:: ; <-- Downloading Comps from a ShutterStock Board
    ; This will auto-magically download comp versions of video clips from iStockPhoto.com
    ; It will do this by doing the following: 
    ;   -Store the current position of the cursor when hotkey is pressed.
    ;   -Shift Middle-Click on a clip in a board to open in new tab. 
    ;   -Activate that new tab.
    ;   -Left click on the 'Try' link to download a comp
    ;   -Wait 2/3 second.
    ;   -Close the Tab.
    ;   -Restore cursor to position where it started.
    ;
    ; There are a few things you need to setup/make sure of before using this hotkey:
    ;   1-Use Chrome (that's why it's in the CHROME-HOTKEYS.ahk)
    ;   2-Make sure Chrome view is set to 100%
    ;   3-Be using an Shutterstock.com Board. See the F19 version for saving from a Video's page directly.
    ;   4-You will need to move the downloaded comp videos to an appropriate location for your project.
    ;     (FileJuggler can help move them auto-magically from the 'Downloads' folder - if you are getting a large number of clips)
    ;
    MouseGetPos, xposP, yposP ;---storing cursor's current coordinates at X%xposP% Y%yposP%
    Send, {LShift Down}
    Sleep, sleepShort
    Send, {MButton}
    Sleep, sleepShort
    Send, {Blind}{LShift Up}
    pageLoadCheck:
    PixelSearch, Px, Py, 277, 18, 281, 23, 0xEE3625, 10, Fast RGB
    if ErrorLevel
        goto pageLoadCheck
    else
        shutterStockClickAndClose()
    MouseMove, xposP, yposP
    
    Return

F23:: ; <-- Downloading Comps from an iStockPhoto Single Video Page
    ; This will auto-magically download comp versions of video clips from iStockPhoto.com
    ; It will do this by doing the following: 
    ;   -Store the current position of the cursor when hotkey is pressed.
    ;   -Right click on the bottom, middle of the preview clip.
    ;   -Select "Save Video As".
    ;   -Wait for the 'Save As' window to activate.
    ;   -Press Enter to save the comp clip.
    ;   -Wait for the 'Save As' window to deactivate.
    ;   -Restore cursor to position where it started.
    ;
    ; There are a few things you need to setup/make sure of before using this hotkey:
    ;   1-Use Chrome (that's why it's in the CHROME-HOTKEYS.ahk)
    ;   2-Make sure Chrome view is set to 100%
    ;   3-Do the process once, manually, to set the location where files will be saved.
    ;
    MouseGetPos, xposP, yposP ;---storing cursor's current coordinates at X%xposP% Y%yposP%
    Click, right, 390, 590
    Sleep, sleepMedium
    Click, 440, 630
    WinWaitActive, Save As,, 3
    SendInput, {Enter}
    WinWaitNotActive, Save As,, 3
    MouseMove, xposP, yposP
    Return

F24:: ; <-- Downloading Comps from an iStockPhoto Board
    ; This will auto-magically download comp versions of video clips from iStockPhoto.com
    ; It will do this by doing the following: 
    ;   -Store the current position of the cursor when hotkey is pressed.
    ;   -Shift Middle-Click on a clip in a board to open in new tab.
    ;   -Activate that new tab.
    ;   -Right click on the bottom, middle of the preview clip.
    ;   -Select "Save Video As".
    ;   -Wait for the 'Save As' window to activate.
    ;   -Press Enter to save the comp clip.
    ;   -Wait for the 'Save As' window to deactivate.
    ;   -Close the Tab.
    ;   -Restore cursor to position where it started.
    ;
    ; There are a few things you need to setup/make sure of before using this hotkey:
    ;   1-Use Chrome (that's why it's in the CHROME-HOTKEYS.ahk)
    ;   2-Make sure Chrome view is set to 100%
    ;   3-Be using an iStockPhoto.com Board. See the F23 version for saving from a Video's page directly.
    ;   4-Do the process once, manually, to set the location where files will be saved.
    ;
    MouseGetPos, xposP, yposP ;---storing cursor's current coordinates at X%xposP% Y%yposP%
    Send, {LShift Down}
    Sleep, sleepShort
    Send, {MButton}
    Sleep, sleepShort
    Send, {Blind}{LShift Up}
    Sleep, sleepMedium
    Click, right, 390, 590
    Sleep, sleepMedium
    Click, 460, 680
    WinWaitActive, Save As,, 3
    SendInput, {Enter}
    WinWaitNotActive, Save As,, 3
    Send, {Control Down}w
    Send, {Blind}{Control Up}
    MouseMove, xposP, yposP
    Return

F24:: ; <-- Downloading Comps from an iStockPhoto Board
    ; This will auto-magically download comp versions of video clips from iStockPhoto.com
    ; It will do this by doing the following: 
    ;   -Store the current position of the cursor when hotkey is pressed.
    ;   -Shift Middle-Click on a clip in a board to open in new tab.
    ;   -Activate that new tab.
    ;   -Right click on the bottom, middle of the preview clip.
    ;   -Select "Save Video As".
    ;   -Wait for the 'Save As' window to activate.
    ;   -Press Enter to save the comp clip.
    ;   -Wait for the 'Save As' window to deactivate.
    ;   -Close the Tab.
    ;   -Restore cursor to position where it started.
    ;
    ; There are a few things you need to setup/make sure of before using this hotkey:
    ;   1-Use Chrome (that's why it's in the CHROME-HOTKEYS.ahk)
    ;   2-Make sure Chrome view is set to 100%
    ;   3-Be using an iStockPhoto.com Board. See the F23 version for saving from a Video's page directly.
    ;   4-Do the process once, manually, to set the location where files will be saved.
    ;
    MouseGetPos, xposP, yposP ;---storing cursor's current coordinates at X%xposP% Y%yposP%
    Send, {MButton}
    Sleep, sleepMedium
    Send, {CtrlDown}{Tab}
    Sleep, sleepMedium
    Send, {Blind}{CtrlUp}
    Sleep, sleepMedium
    Click, right, 390, 590
    Sleep, sleepMedium
    Click, 460, 680
    WinWaitActive, Save As,, 3
    SendInput, {Enter}
    WinWaitNotActive, Save As,, 3
    Send, {Control Down}w
    Send, {Blind}{Control Up}
    MouseMove, xposP, yposP
    Return



*/