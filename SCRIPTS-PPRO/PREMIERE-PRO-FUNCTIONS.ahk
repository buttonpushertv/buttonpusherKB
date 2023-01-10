; AutoHotKey - Buttonpusher Post-Production Keyboard Environment - Premiere Pro Functions
; by Ben Howard - ben@buttonpusher.tv

;===== START OF AUTO-EXECUTION SECTION =========================================================
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
; #Persistent ; Keeps script permanently running.
#SingleInstance force ; Ensures that there is only a single instance of this script running.
; SetTitleMatchMode, 2 ; sets title matching to search for "containing" instead of "exact"
#MaxHotkeysPerInterval 2000
#WinActivateForce ;https://autohotkey.com/docs/commands/_WinActivateForce.htm

;===== INITIALIZATION - VARIABLES ==============================================================

global Settings_rootFolder
EnvGet, Settings_rootFolder, BKB_ROOT
iniFile := Settings_rootFolder . "\settings.ini" ; the main settings file used by most of the buttonpusherKB scripts


;===== END OF AUTO-EXECUTE =====================================================================
;===== MODIFIER MEMORY HELPER ==================================================================
; combine below with key and '::' to define hotkey
; e.g.- ^f1::Msgbox You pressed Control and F1
; #=Win | !=Alt | ^=Ctrl | +=Shift | &=combine keys | *=ignore other mods
; <=use left mod key| >=use right mod key  | UP=fires on release

;===== FUNCTIONS ===============================================================================

;BH-Any comments that start with ';BH-' are mine. I left the original Taran Comments to help me figure out things as I debugged this on my system --Ben

;BH-This prfocus() function was taken from Taran's 2nd Keyboard Project...modified to work on my system.

prFocus(panel) ;this function allows you to have ONE spot where you define your PRIVATE shortcuts that "focus" panels in premiere.
{

if (panel = "effects")
    {
    Send {F22} ;bring focus to the effects panel, in order to "clear" the current focus on the MAIN monitor
    Sleep, 15
    Send {F22} ;do it AGAIN, just in case a panel was full-screened... it would only have exited full screen, and not switched to the effects panel as it should have.
    Sleep, 15
    goto FocusEnd ;should be in the correct panel, so end function
    }
else if (panel = "timeline")
    Send {F21} ;if focus had already been on the timeline, this would have switched to the next sequence in some arbitrary order.
else if (panel = "program") ;program monitor
        Send {F20}
else if (panel = "source") ;source monitor - if focus had already been on the source monitor, this will switch to the next clip in some name or listing order.
        Send {F19}
else if (panel = "project") ;AKA a "bin" or "folder"
        Send {F9}
else if (panel = "effect controls")
        Send {F6}

FocusEnd:
}
;end of prFocus()

;BH-Here is the instantVFX() function from TaranVH's 2nd-keyboard project (https://github.com/TaranVH/2nd-keyboard)
;I have modified it for my scripts & removed the code Taran has commented out (unless its useful)

instantVFX(efxControl)
{
	dontrestart = 0
	restartPoint:
	blockinput, sendandMouse
	blockinput, MouseMove
	blockinput, on
	prFocus("effect controls") ;essentially just hits CTRL ALT SHIFT 5 to highlight the effect controls panel.
	Sleep, 15
	MouseGetPos Xbeginlol, Ybeginlol
	global Settings_rootFolder
    global Xbegin = Xbeginlol
	global Ybegin = Ybeginlol
	ControlGetPos, Xcorner, Ycorner, Width, Height, DroverLord - Window Class91, ahk_class Premiere Pro ;This is HOPEFULLY the ClassNN of the effect controls panel. Use Window Spy to figure it out.
	;I might need a far more robust way of ensuring the effect controls panel has been located, in the future.

	;move mouse to expected triangle location. this is a VERY SPECIFIC PIXEL which will be right on the EDGE of the triangle when it is OPEN.
	;This takes advantage of the anti-aliasing between the color of the triangle, and that of the background behind it.
	;these pixel numbers will be DIFFERENT depending upon the RESOLUTION and UI SCALING of your monitor(s)
	; YY := Ycorner+99 ;ui 150%
	; XX := Xcorner+19 ;ui 150%
	YY := Ycorner+66 ;ui 100%
	XX := Xcorner+13 ;ui 100%
	MouseMove, XX, YY, 0
	;MSGBOX, , DEBUG, stopping here - where's the cursor?`nYY=%YY% / XX=%XX%`nXcorner=%Xcorner% / Ycorner=%Ycorner%
	Sleep, 15
	PixelGetColor, colorr, XX, YY
	;MSGBOX, , DEBUG, Here are color values read: colorr: %colorr%`nYY=%YY% / XX=%XX%
	; if (colorr = "0x353535") ;for 150% ui
	if (colorr = "0x222222") ;for 100% ui - CORRECT-BH
	{
		tooltip, color %colorr% means closed triangle. Will click and then SCALE SEARCH
		blockinput, Mouse
		Click XX, YY
		Sleep, 5
		clickTransformIcon()
		findVFX(efxControl)
		Return
	}
	;else if (colorr = "0x757575") ;for 150% ui. again, this values could be different for everyone. check with window spy. This color simply needs to be different from the color when the triangle is closed. it also cannot be the same as a normal panel color (1d1d1d or 232323)
	else if (colorr = "0x7A7A7A") ;for 100% ui - CORRECT-BH
	{
		;tooltip, %colorr% means OPENED triangle. SEARCHING FOR SCALE
		blockinput, Mouse
		Sleep, 5
		clickTransformIcon()
		findVFX(efxControl)
		;untwirled = 1
		Return, untwirled
	}
	else if (colorr = "0x1D1D1D" || colorr = "0x232323")
		{
		Send ^p ;--- i have CTRL P set up to toggle "selection follows playhead," which I never use otherwise. ;this makes it so that only the TOP clip is selected.
		Sleep, 15
		Send ^p ;this disables "selection follows playhead." I don't know if there is a way to CHECK if it is on or not. 
		resetFromAutoVFX()
		;now you need to do all that again, since the motion menu is now open. But only do it ONCE more! 
		If (dontrestart = 0)
			{
			dontrestart = 1
			goto, restartPoint ;this is stupid but it works. Feel free to improve any of my code.
			}
		Return reset
		}
	else
		{
		tooltip, %colorr% not expected
		;play noise
		resetFromAutoVFX()
		Return reset
		}
}
; end of instantVFX(

clickTransformIcon()
{
    ControlGetPos, Xcorner, Ycorner, Width, Height, DroverLord - Window Class87, ahk_class Premiere Pro ;you will need to set this value to the window class of your own Effect Controls panel! Use window spy and hover over it to find that info.

    ; Xcorner := Xcorner+83 ;150% ui
    ; Ycorner := Ycorner+98 ;150% ui
    Xcorner := Xcorner+56 ;100% ui
    Ycorner := Ycorner+66 ;100% ui

    MouseMove, Xcorner, Ycorner, 0 ;these numbers should move the cursor to the location of the transform icon. Use the message box below to debug this.
    Sleep, 15 ; just to make sure it gets there, this is done twice.
    MouseMove, Xcorner, Ycorner, 0 ;these numbers should move the cursor to the location of the transform icon. Use the message box below to debug this.
    ;msgbox, the cursor should now be positioned directly over the transform icon. `n Xcorner = %Xcorner% `n Ycorner = %Ycorner%
    MouseClick, left
}

findVFX(efxControl) ; searches for text inside of the Motion effect. requires an actual image.
{
    global Settings_rootFolder
    Sleep, 5
    MouseGetPos xPos, yPos
    ImageSearch, FoundX, FoundY, xPos-90, yPos, xPos+800, yPos+900, %Settings_rootFolder%\SUPPORTING-FILES\instantVFX\%efxControl%_D2020_ui100.png
    ;within 0 shades of variation (this is much faster)
    ;obviously, you need to take your own screenshot (look at mine to see what is needed) save as .png, and link to it from the line above.
    ;Again, your UI brightness might be different from mine! I now use the DEFAULT brightness.
    if ErrorLevel = 1
        {
        ;ImageSearch, FoundX, FoundY, xPos-30, yPos, xPos+1200, yPos+1200, *10 %Settings_rootFolder%\%efxControl%_D2020.png ;within 10 shades of variation (in case SCALE is fully extended with bezier handles, in which case, the other images are real hard to find because the horizontal seperating lines look a BIT different. But if you crop in really closely, you don't have to worry about this. so this part of the code is not really necessary execpt to expand the range to look.
        ImageSearch, FoundX, FoundY, xPos-30, yPos, xPos+1200, yPos+1200, *10 %Settings_rootFolder%\SUPPORTING-FILES\instantVFX\%efxControl%_D2020_ui100.png
        }
    if ErrorLevel = 2
        {
        msgbox,,, ERROR LEVEL 2`nCould not conduct the search`nI probably just can't find the image to search for.`nThis is the Effect Control I am looking for: %efxControl%.,2
        resetFromAutoVFX()
        Return
        }
    if ErrorLevel = 1
        {
        
        msgbox,,, ERROR LEVEL 1`n%efxControl% could not be found on the screeen,1
        resetFromAutoVFX()
        Return
        }
    else
        {
        MouseMove, FoundX, FoundY, 0
        Sleep, 5
        findHotText(efxControl)
        Return
        }
}

findHotText(efxControl)
{
    global Settings_rootFolder
    tooltip, ; removes any tooltips that might be in the way of the searcher.
    ; https://www.autohotkey.com/docs/commands/PixelSearch.htm
    MouseGetPos, xxx, yyy
    if (efxControl = "position")
        {
            prFocus("program")
            ControlGetPos, Xcorner, Ycorner, Width, Height, DroverLord - Window Class96, ahk_class Premiere Pro ;you will need to set this value to the window class of your own Effect Controls panel! Use window spy and hover over it to find that info.
            Xcorner += (Width / 2)
            Ycorner += (Height / 2)
            MouseMove, Xcorner, Ycorner
            ToolTip, Ready for you to adjust position.`nJust click and drag the image.
            RemoveToolTip(2000)
            Goto, endiVFX
        }
    else if (efxControl = "scale" ||  efxControl = "anchor_point" || efxControl = "rotation")
        {
            PixelSearch, Px, Py, xxx+50, yyy, xxx+450, yyy+11, 0x2d8ceb, 30, Fast RGB ;this is searching to the RIGHT, looking the blueness of the scrubbable hot text. Unfortunately, it sees to start looking from right to left, so if your window is sized too small, it'll possibly latch onto the blue of the playhead/CTI. TEchnically, I could check to see the size of the Effect controls panel FIRST, and then allow the number that is currently 250 to be less than half that, but I haven't run into too much trouble so far...
        }
    else if (efxControl = "anchor_point_vertical")
    {
        tooltip, seeking 0.00? ;(looking for that now)
        ImageSearch, Px, Py, xxx+50, yyy, xxx+800, yyy+100, *3 %Settings_rootFolder%\SUPPORTING-FILES\instantVFX\anti-flicker-filter_000_D2020_ui100.png ;for a user interface at 100%...
        ;the *3 allows some minor variation in the searched image.
        if ErrorLevel = 1
            ImageSearch, Px, Py, xxx+50, yyy, xxx+800, yyy+100, *3 %Settings_rootFolder%\SUPPORTING-FILES\instantVFX\anti-flicker-filter_000_D2020_2.png
    }

    if ErrorLevel
        {
        Sleep, 111
        resetFromAutoVFX()
        return ;i am not sure if this is needed.
        }
    else
        {
        if (efxControl <> "anchor_point_vertical")
        {
            MouseMove, Px+10, Py+5, 0 ;moves the cursor onto the scrubbable hot text for adjustment
        }
        else if (efxControl = "anchor_point_vertical")
        {
            MouseMove, Px+80, Py-20, 0 ;relative to the unrelated 0.00 text (which I've never changed,) this moves the cursor onto the SECOND variable for the anchor point...the VERTICAL number, rather than horizontal.
        }
        Click down left ; this click the left mouse button and holds it down
        
        GetKeyState, stateFirstCheck, %VFXkey%, P ; this will check the state of the passed VFXKey and keep adjusting while it is held down OR click in the field so you can enter a value directly.
            
        if stateFirstCheck = U
            {
                Click up left ; releases the left mouse button
                Sleep, 15
                resetFromAutoVFX(0) ;zero means, DO NOT click on the timeline to put the focus there.
                return ;this return has to be here, or the function will continue on to the next loop! Agh, I didn't realize that for a long time, dumb!
            }
        ;Now we start the official loop, which will continue as long as the user holds down the VFXkey. They can now simply move the mouse to change the value of the hot text which has been automatically selected for them.
        Loop
            {
            blockinput, off
            blockinput, MouseMoveOff
            tooltip, ;removes any tooltips that might exist.
            Sleep, 15
            GetKeyState, state, %VFXkey%, P ;since this relies on the PHYSICAL state of the key on the attached keyboard, this and other functions do NOT work if you're using Parsec, Teamviewer, or other remote access software.
            
            ;NOW is when the user moves their mouse around to change the value of the hot text. You can also use SHIFT or CTRL to make it change faster or slower. Then release the VFX key to return to normal.
            
            if state = U
                {
                Click up left
                Sleep, 15
                resetFromAutoVFX(1) ;1 means, DO send a middle click to put focus onto the timeline (or wherever the cursor was.)
                Return
                }
            }
        }
        endiVFX:
        blockinput, off
        blockinput, MouseMoveOff
        Return
}

resetFromAutoVFX(clicky := 0)
{
	global Xbegin
	global Ybegin
	MouseMove, Xbegin, Ybegin, 0
	if clicky = 1
		{
		;tooltip, WHY
		send, {mbutton} ;sends middle click. This will bring the panel you were hovering over, back into focus. Alternatively, i could do this with a keyboard shortcut that highlights the timeline panel, but that is probably less reliable, for... reasons.
		clicky = 0
		}
	blockinput, off
	blockinput, MouseMoveOff
	ToolTip
    Return	
}

; BH-End of functions added for InstantVFX() to work

; These Functions are for copying the timecode from the currently active sequence in the Program Monitor to the clipboard as text.

getProgramTCDisplayCoords(ByRef programXposP, ByRef programYposP) ; this will revise the stored values of the X & Y coords of where the Program Monitor's TC Display is located on your screen.
{
    global inifile
    global Settings_rootFolder
    CoordMode, Mouse, Screen
    programXposPOld := programXposP ; storing the previous X position
    programYposPOld := programYposP ; storing the previous Y position
    MouseGetPos, programXposPNew, programYposPNew ;---storing cursor's current coordinates at X%programXposPNew% Y%programYposPNew%
    ;Tooltip, X=%programXposPNew% / Y=%programYposPNew%`nGrabbing the X & Y coordinates of the mouse cursor`nMake sure it is over the Program Monitor's timecode display (lower left).`n`n(Previous values: X=%programXposPOld% / Y=%programYposPOld%)
    ;RemoveToolTip(4000)
    prFocus("program") ; Activating the Program Monitor
    Run, %Settings_rootFolder%\SCRIPTS-UTIL\pingPos.ahk %programXposP% %programYposP% "Screen"
    MsgBox, 35, Update TC Display Coords?, Make sure cursor is over the Program Monitor's Timecode Display (lower left).`n`nX=%programXposPNew% / Y=%programYposPNew%`nThese are the coordinates that were grabbed.`nWould you like to save these in settings.ini?`n`nYes will save.`nNo will just update them until script is reloaded.`nCancel will reset them to settings.ini values.`n`n(Previous values: X=%programXposPOld% / Y=%programYposPOld%)
    programXposP := programXposPNew ; storing new values in programXposP - this should cover the 'No' selection case
    programYposP := programYposPNew ; storing new values in programYposP - this should cover the 'No' selection case
    
    IfMsgBox Yes
        IniWrite, %programXposP%, %inifile%, Settings, TCDisplayProgramXpos ; writes the new X value to settings.ini
        IniWrite, %programYposP%, %inifile%, Settings, TCDisplayProgramYpos ; writes the new Y value to settings.ini
    IfMsgBox Cancel
        programXposP := programXposPOld ; puts the old X value back into programXposP on Cancel
        programYposP := programYposPOld ; puts the old Y value back into programYposP on Cancel
    ; selecting No should just save the new values for X & Y for the current instance of the script. Reloading will re-read the values from settings.ini
    
    Return
}

grabProgramTCAsText(ByRef grabbedTC, ByRef programXposP, ByRef programYposP)
{
    global Settings_rootFolder
    If (!programXposP and !programYposP)
    {
        MsgBox,, Grab Timecode Display position, You need to grab the X & Y coordinates of the Program Monitor's Timecode Display (lower left).`nPosition cursor then press CTRL-SHIFT-ALT-I to capture
        Return
    }
    ;prFocus("program") ; Activating the Program Monitor
    Sleep, 333
    CoordMode, Mouse, Screen
    MouseGetPos, programXposTEMP, programYposTEMP ;---storing cursor's current coordinates at X%programXposTEMP% Y%programYposTEMP%
    ; This tooltip below is commented out. The MsgBox above does the same thing but will only trigger if there's no values in settings.ini to read. This was an earlier reminder, but maybe it wants to stick around - BH
    ;Tooltip, Attempting a click at: X=%programXposP% / Y=%programYposP%`nIf this misclicks`, position cursor over TC display in Program Monitor then press CTRL-SHIFT-ALT-I to capture coordinates.
    ;RemoveToolTip(2000)
    BlockInput, On
    MouseMove, programXposP, programYposP
    Click, %programXposP%, %programYposP%, 0
    Sleep, 333
    Send, {Click}
    Sleep, 333
    Send, {Control Down}
    Sleep, 333
    Send, c
    Sleep, 333
    Send, {Control Up}
    Sleep, 333
    Send, {Esc}
    BlockInput, Off
    MouseMove, programXposTEMP, programYposTEMP ; putting cursor back where it was before hotkey was invoked
    grabbedTC = %clipboard%
    ;Run, %Settings_rootFolder%\SCRIPTS-UTIL\pingPos.ahk %programXposP% %programYposP% "Screen"
    Return grabbedTC
}

; These Functions are for copying the timecode from the currently active sequence in the Source Monitor to the clipboard as text.

getSourceTCDisplayCoords(ByRef sourceXposP, ByRef sourceYposP) ; this will revise the stored values of the X & Y coords of where the Source Monitor's TC Display is located on your screen.
{
    global inifile
    global Settings_rootFolder
    CoordMode, Mouse, Screen
    sourceXposPOld := sourceXposP ; storing the previous X position
    sourceYposPOld := sourceYposP ; storing the previous Y position
    MouseGetPos, sourceXposPNew, sourceYposPNew ;---storing cursor's current coordinates at X%sourceXposPNew% Y%sourceYposPNew%
    Tooltip, X=%sourceXposPNew% / Y=%sourceYposPNew%`nGrabbing the X & Y coordinates of the mouse cursor`nMake sure it is over the Source Monitor's timecode display (lower left).`n`n(Previous values: X=%sourceXposPOld% / Y=%sourceYposPOld%)
    RemoveToolTip(4000)
    prFocus("source") ; Activating the Source Monitor
    Run, %Settings_rootFolder%\SCRIPTS-UTIL\pingPos.ahk %sourceXposP% %sourceYposP% "Screen"
    MsgBox, 35, Update TC Display Coords?, Make sure cursor is over the Source Monitor's Timecode Display (lower left).`n`nX=%sourceXposPNew% / Y=%sourceYposPNew%`nThese are the coordinates that were grabbed.`nWould you like to save these in settings.ini?`n`nYes will save.`nNo will just update them until script is reloaded.`nCancel will reset them to settings.ini values.`n`n(Previous values: X=%sourceXposPOld% / Y=%sourceYposPOld%)
    sourceXposP := sourceXposPNew ; storing new values in sourceXposP - this should cover the 'No' selection case
    sourceYposP := sourceYposPNew ; storing new values in sourceYposP - this should cover the 'No' selection case
    
    IfMsgBox Yes
        IniWrite, %sourceXposP%, %inifile%, Settings, TCDisplaySourceXpos ; writes the new X value to settings.ini
        IniWrite, %sourceYposP%, %inifile%, Settings, TCDisplaySourceYpos ; writes the new Y value to settings.ini
    IfMsgBox Cancel
        sourceXposP := sourceXposPOld ; puts the old X value back into sourceXposP on Cancel
        sourceYposP := sourceYposPOld ; puts the old Y value back into sourceYposP on Cancel
    ; selecting No should just save the new values for X & Y for the current instance of the script. Reloading will re-read the values from settings.ini
    
    Return
}

grabSourceTCAsText(ByRef grabbedTC, ByRef sourceXposP, ByRef sourceYposP)
{
    global Settings_rootFolder
    If (!sourceXposP and !sourceYposP)
    {
        MsgBox,, Grab Timecode Display position, You need to grab the X & Y coordinates of the Source Monitor's Timecode Display (lower left).`nPosition cursor then press CTRL-SHIFT-ALT-I to capture
        Return
    }
    ;prFocus("source") ; Activating the Source Monitor
    Sleep, 333
    CoordMode, Mouse, Screen
    MouseGetPos, sourceXposTEMP, sourceYposTEMP ;---storing cursor's current coordinates at X%sourceXposTEMP% Y%sourceYposTEMP%
    ; This tooltip below is commented out. The MsgBox above does the same thing but will only trigger if there's no values in settings.ini to read. This was an earlier reminder, but maybe it wants to stick around - BH
    ;Tooltip, Attempting a click at: X=%sourceXposP% / Y=%sourceYposP%`nIf this misclicks`, position cursor over TC display in Source Monitor then press CTRL-SHIFT-ALT-I to capture coordinates.
    ;RemoveToolTip(2000)
    BlockInput, On
    MouseMove, sourceXposP, sourceYposP
    Click, %sourceXposP%, %sourceYposP%, 0
    Sleep, 333
    Send, {Click}
    Sleep, 333
    Send, ^c
    Sleep, 333
    Send, {Esc}
    BlockInput, Off
    MouseMove, sourceXposTEMP, sourceYposTEMP ; putting cursor back where it was before hotkey was invoked
    grabbedTC = %clipboard%
    ;Run, %Settings_rootFolder%\SCRIPTS-UTIL\pingPos.ahk %sourceXposP% %sourceYposP% "Screen"
    Return grabbedTC
}

; End of timecode reading functions

;BH-This preset() function was taken from Taran's 2nd Keyboard Project...modified to work on my system.
;Windows UI *MUST* be set to 100% scaling for any of this to work

;;;;;;;;;;FUNCTION FOR DIRECTLY APPLYING A PRESET EFFECT TO A CLIP!;;;;;;;;;;;;

#IfWinActive ahk_exe Adobe Premiere Pro.exe
preset(item)
{
    ifWinNotActive ahk_exe Adobe Premiere Pro.exe
	goto theEnding ;and this line is here just in case the function is called while not inside premiere.

    ;BH-My Effects Panel is alomst always on a different monitor than my timeline. I've set the coordmode to be the Screen here intiially and later will set it to Window mode to grab the preset location. And then we'll flip it back to Screen mode again for the click & drag back on to the timeline clip.

    ;Setting the coordinate mode is really important. This ensures that pixel distances are consistant for everything, everywhere.
    coordmode, pixel, Screen
    coordmode, mouse, Screen
    coordmode, Caret, Screen

    ;This (temporarily) blocks the mouse and keyboard from sending any information, which could interfere with the funcitoning of the script.
    BlockInput, SendAndMouse
    BlockInput, MouseMove
    BlockInput, On

    ;NO DELAY BETWEEN TYPED STUFF! It might actually be best to put this at "1" though.
    ;BH-seems to work better with it at '1'
    SetKeyDelay, 1

    Sendinput, 2 ;shuttle STOP
    Sleep, 5
    Sendinput, 2 ;shuttle STOP
    ;so if the video is playing, this will stop it. Othewise, it can mess up the script.
    Sleep, 5

    MouseGetPos, xposP, yposP ;---storing cursor's current coordinates at X%xposP% Y%yposP%
    sendinput, {mButton} ;this will MIDDLE CLICK to bring focus to the panel underneath the cursor (the timeline). I forget exactly why, but if you create a nest, and immediately try to apply a preset to it, it doesn't work, because the timeline wasn't in focus...?
    Sleep, 5
    prFocus("effects") ;brings focus to the effects panel
    Sleep, 5
    Sendinput, +f ; set in premiere to "select find box"
    Sleep, 5
    ;Any text in the Effects panel's find box has now been highlighted. There is also a blinking "text insertion point" at the end of that text. This is the vertical blinking line, or "caret."
    if (A_CaretX = "")
    {
    ;No Caret (blinking vertical line) can be found.
    waiting2 = 0
    ;the following loop is waiting until it sees the caret. SUPER IMPORTANT. Without this, the function doesn't work 10% of the time.
    ;This is also way better than just always waiting 60 milliseconds like it had been before. The function can continue as soon as Premiere is ready.
    loop
        {
        waiting2 ++
        Sleep, 333
        tooltip, counter = (%waiting2% * 33)`nCaret = %A_CaretX%
        if (A_CaretX <> "")
            {
            tooltip, CARET WAS FOUND
            break
            }
        if (waiting2 > 30)
            {
            BlockInput, Off
            MsgBox, FAIL - no caret found. `nIf your cursor will not move`, hit the button to call the preset() function again.`nTo remove this tooltip`, refresh the script using its icon in the taskbar.
            ;Note to self, need much better way to debug this than screwing the user
            Sleep, 666
            ;tooltip,
            GOTO theEnding
            ;lol, are you triggered by this GOTO? lolol lololol
            }
        }
    Sleep, 5
    tooltip,
    }
    ;yeah, I've seen this go all the way up to "8," which is 264 milliseconds

    ;Setting the coordinate mode is really important. This ensures that pixel distances are consistant for everything, everywhere.
    coordmode, pixel, Window
    coordmode, mouse, Window
    coordmode, Caret, Window

    MouseMove, %A_CaretX%, %A_CaretY%, 0
    Sleep, 5

    ;BH- uncomment 2 lines below to figure out what's getting stored
    ;BlockInput off
    ;MsgBox, stored coords - X:%xposP% / Y:%yposP%`nCaret coords - X:%A_CaretX% / Y:%A_CaretY%

    ;;;and fortunately, AHK knows the exact X and Y position of this caret. So therefore, we can find the effects panel find box, no matter what monitor it is on, with 100% consistency!

    MouseGetPos, , , Window, classNN
    WinGetClass, class, ahk_id %Window%

    ;;;I think ControlGetPos is not affected by coordmode??  Or at least, it gave me the wrong coordinates if premiere is not fullscreened... https://autohotkey.com/docs/commands/ControlGetPos.htm
    ControlGetPos, XX, YY, Width, Height, %classNN%, ahk_class %class%, SubWindow, SubWindow ;-I tried to exclude subwindows but I don't think it works...?
    ;;my results:  59, 1229, 252, 21,      Edit1,    ahk_class Premiere Pro

    ;now we have found a lot of useful information about this find box. Turns out, we don't need most of it...
    ;we just need the X and Y coordinates of the "upper left" corner...

    ;uncomment the following 2 lines to get a message box of your current variable values. The script will not advance until you dismiss the message box.
    ;BlockInput, Off
    ;MsgBox, xx=%XX% yy=%YY%

    ;MouseMove, XX-25, YY+10, 0 ;--------------------for 150% UI scaling, this moves the cursor onto the magnifying glass
    MouseMove, XX-15, YY+10, 0 ;--------------------for 100% UI scaling, this moves the cursor onto the magnifying glass
    ;msgbox, should be in the center of the magnifying glass now.
    Sleep, 5 ;was sleep 50
    ;This types in the text you wanted to search for. Like "pop in." We can do this because the entire find box text was already selected by Premiere. Otherwise, we could click the magnifying glass if we wanted to , in order to select that find box.
    Send %item%
    Sleep, 5
    ;MouseMove, 62, 95, 0, R ;----------------------(for 150% UI) relative to the position of the magnifying glass (established earlier,) this moves the cursor down and directly onto the preset's icon. In my case, it is inside the "presets" folder, then inside of another folder, and the written name should be completely unique so that it is the first and only item.
    MouseMove, 41, 63, 0, R ;----------------------(for 100% UI)
    Sleep, 5
    MouseGetPos, iconX, iconY, Window, classNN ;---now we have to figure out the ahk_class of the current panel we are on. It used to be DroverLord - Window Class14, but the number changes anytime you move panels around... so i must always obtain the information anew.
    Sleep, 5
    WinGetClass, class, ahk_id %Window% ;----------"ahk_id %Window%" is important for SOME REASON. if you delete it, this doesn't work.
    ;tooltip, ahk_class =   %class% `nClassNN =     %classNN% `nTitle= %Window%
    ;sleep 50
    ControlGetPos, xxx, yyy, www, hhh, %classNN%, ahk_class %class%, SubWindow, SubWindow ;-I tried to exclude subwindows but I don't think it works...?
    MouseMove, www/4, hhh/2, 0, R ;-----------------moves to roughly the CENTER of the Effects panel. This clears the displayed presets from any duplication errors. VERY important. without this, the script fails 20% of the time. This is also where the script can go wrong, by trying to do this on the timeline, meaning it didn't get the Effects panel window information as it should have... IDK how to fix yet.
    Sleep, 5
    MouseClick, left, , , 1 ;-----------------------the actual click
    Sleep, 5
    MouseMove, iconX, iconY, 0 ;--------------------moves cursor BACK onto the effect's icon
    ;tooltip, should be back on the effect's icon
    ;sleep 50
    Sleep, 5

    ;BH-Here is where we flip coormode back to Screen so that we can reuse the original coords we first grabbed. Uncomment line below to see if your cursor is starting exactly over the preset's icon.
    ;msgbox, The cursor should be directly on top of the preset's icon. `n If not, the script needs modification.

    ;Setting the coordinate mode is really important. This ensures that pixel distances are consistant for everything, everywhere.
    coordmode, pixel, Screen
    coordmode, mouse, Screen
    coordmode, Caret, Screen

    MouseGetPos, xIconPosP, yIconPosP

    ;BH-the above line grabs the Screen X & Y coords of the Preset's Icon for the drag. The line below will use these vars as the starting point for the drag. The ending point will be where the cursor was when you first launched this function.

    MouseClickDrag, Left, %xIconPosP%, %yIconPosP%, %xposP%, %yposP% ;---clicks the left button down, drags this effect to the cursor's pervious coordinates and releases the left mouse button, which should be above a clip, on the TIMELINE panel.

    ;BlockInput, Off
    ;MsgBox,,BREAKPOINT, About to try to clear the Effects Panel Find Box...,3

    Sleep, 666

    ;BH-and we should clear the Effects Panel Find text so things are cleared for the next visit
    prFocus("effects") ;brings focus to the effects panel
    Sleep, 5
    Sendinput, +f ; selecting the Find text box and it should select any existing text
    Sleep, 5
    Sendinput, {Backspace}{Enter}
    Sleep, 5
    ;MouseClick, middle, , , 1 ;this returns focus to the panel the cursor is hovering above, WITHOUT selecting anything. great!
    SendInput, {F6}
    Blockinput, MouseMoveOff ;returning mouse movement ability
    BlockInput, off ;do not comment out or delete this line -- or you won't regain control of the keyboard!! However, CTRL+ALT+DEL will still work if you get stuck!! Cool.

theEnding:
}
;END of preset()

; use this function to Remove ToolTips - pretty self-explanatory - 'duration' should be given in milliseconds (4000 = 4 seconds)
RemoveToolTip(duration) {
  SetTimer, ToolTipOff, %duration%
  Return

ToolTipOff:
    ToolTip
    return
}

FirstUsageSinceLaunch(messageBoxText) {
/*
    PURPOSE: This function creates a message that gets shown the first time you use a hotkey that contains something like the code below.
    USAGE: In order to use this function, place this code block at the top of any hotkey definition block where you want to use it. Change the 'message' to customize it. You can use '`n' to begin a new line.

        message := "This is the first time you've launched hotkey this since you've started buttonpusherKB."
        
        if (!f2MessageSeen) ; test this local variable
        {
            FirstUsageSinceLaunch(message) ; calls the function
            IfMsgBox, Cancel ; tests if you want to cancel this hotkey from executing.
            Return ; that means it will re-run this block again the next time you press this hotkey
            f2MessageSeen := 1 ; setting this to a non-zero value means the 'if' statement above will skip this whole block and move on to the 'else' section
            ;anything else you eish to do on this first time pressing this hotkey can be executed here
        }
        ; the 'else' below is optional. Most of the time, you can just delete it.
        else ; this 'else' section is only here if you want to do something different when this is not the first time pressing this hotkey.
        MSGBOX, , DEBUG, Already been run. ; this command is just an example to show that the 'else' is doing something.
*/

    MSGBOX, 49, First Launch Since Usage, %messageBoxText%
    Return
}