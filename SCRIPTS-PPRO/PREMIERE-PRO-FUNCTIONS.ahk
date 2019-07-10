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
; Sleep shortcuts - use these to standardize sleep times. Change here to change everywhere.
sleepMicro := 5
sleepMini := 15
sleepShort := 333
sleepMedium := 666
sleepLong := 1500
sleepDeep := 3500

;===== END OF AUTO-EXECUTE =====================================================================
;===== MODIFIER MEMORY HELPER ==================================================================
; combine below with key and '::' to define hotkey 
; e.g.- ^f1::Msgbox You pressed Control and F1
; #=Win | !=Alt | ^=Ctrl | +=Shift | &=combine keys | *=ignore other mods
; <=use left mod key| >=use right mod key  | UP=fires on release

;===== FUNCTIONS ===============================================================================

;BH-Any comments that start with ';BH-' are mine. I left the original Taran Comments to help me figure out things as I debugged this on my system --Ben

;BH-This prfocus() function was taken from Taran's 2nd Keyboard Project...modified to work on my system.

prFocus(panel) ;this function allows you to have ONE spot where you define your personal shortcuts that "focus" panels in premiere.
{

if (panel = "effects")
    {
    Send {F8} ;bring focus to the effects panel, in order to "clear" the current focus on the MAIN monitor
    sleep sleepMini
    Send {F8} ;do it AGAIN, just in case a panel was full-screened... it would only have exited full screen, and not switched to the effects panel as it should have.
    sleep sleepMini
    goto FocusEnd ;should be in the correct panel, so end function
    }
else if (panel = "timeline")
    Send {Control Down}{f9}{Control Up} ;if focus had already been on the timeline, this would have switched to the next sequence in some arbitrary order.
else if (panel = "program") ;program monitor
        Send {F8}
else if (panel = "source") ;source monitor
        Send {Shift Down}{F8}{Shift Up}
else if (panel = "project") ;AKA a "bin" or "folder"
        Send {F9}
else if (panel = "effect controls")
        Send {F7}

FocusEnd:
}
;end of prFocus()


;BH-This preset() function was taken from Taran's 2nd Keyboard Project...modified to work on my system.

;;;;;;;;;;FUNCTION FOR DIRECTLY APPLYING A PRESET EFFECT TO A CLIP!;;;;;;;;;;;;
;preset() is my most used, and most useful AHK function! There is no good reason why Premiere doesn't have this functionality.
;keep in mind, I use 150% UI scaling, so your pixel distances for commands like mousemove WILL be different!
;to use this script yourself, carefully go through  testing the script and changing the values, ensuring that the script works, one line at a time. use message boxes to check on variables and see where the cursor is. remove those message boxes later when you have it all working!


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
    sleep, sleepMicro
    Sendinput, 2 ;shuttle STOP
    ;so if the video is playing, this will stop it. Othewise, it can mess up the script.
    sleep, sleepMicro

    MouseGetPos, xposP, yposP ;---storing cursor's current coordinates at X%xposP% Y%yposP%
    sendinput, {mButton} ;this will MIDDLE CLICK to bring focus to the panel underneath the cursor (the timeline). I forget exactly why, but if you create a nest, and immediately try to apply a preset to it, it doesn't work, because the timeline wasn't in focus...?
    sleep sleepMicro
    prFocus("effects") ;brings focus to the effects panel
    sleep sleepMicro
    Sendinput, +f ; set in premiere to "select find box"
    sleep sleepMicro
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
        sleep sleepShort
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
            sleep SleepMedium
            ;tooltip,
            GOTO theEnding
            ;lol, are you triggered by this GOTO? lolol lololol
            }
        }
    sleep 1
    tooltip,
    }
    ;yeah, I've seen this go all the way up to "8," which is 264 milliseconds

    ;Setting the coordinate mode is really important. This ensures that pixel distances are consistant for everything, everywhere.
    coordmode, pixel, Window
    coordmode, mouse, Window
    coordmode, Caret, Window

    MouseMove, %A_CaretX%, %A_CaretY%, 0
    sleep sleepMicro

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
    sleep sleepMicro ;was sleep 50
    ;This types in the text you wanted to search for. Like "pop in." We can do this because the entire find box text was already selected by Premiere. Otherwise, we could click the magnifying glass if we wanted to , in order to select that find box.
    Send %item%
    sleep sleepMicro
    ;MouseMove, 62, 95, 0, R ;----------------------(for 150% UI) relative to the position of the magnifying glass (established earlier,) this moves the cursor down and directly onto the preset's icon. In my case, it is inside the "presets" folder, then inside of another folder, and the written name should be completely unique so that it is the first and only item.
    MouseMove, 41, 63, 0, R ;----------------------(for 100% UI) 
    sleep sleepMicro
    MouseGetPos, iconX, iconY, Window, classNN ;---now we have to figure out the ahk_class of the current panel we are on. It used to be DroverLord - Window Class14, but the number changes anytime you move panels around... so i must always obtain the information anew.
    sleep sleepMicro
    WinGetClass, class, ahk_id %Window% ;----------"ahk_id %Window%" is important for SOME REASON. if you delete it, this doesn't work.
    ;tooltip, ahk_class =   %class% `nClassNN =     %classNN% `nTitle= %Window%
    ;sleep 50
    ControlGetPos, xxx, yyy, www, hhh, %classNN%, ahk_class %class%, SubWindow, SubWindow ;-I tried to exclude subwindows but I don't think it works...?
    MouseMove, www/4, hhh/2, 0, R ;-----------------moves to roughly the CENTER of the Effects panel. This clears the displayed presets from any duplication errors. VERY important. without this, the script fails 20% of the time. This is also where the script can go wrong, by trying to do this on the timeline, meaning it didn't get the Effects panel window information as it should have... IDK how to fix yet.
    sleep sleepMicro
    MouseClick, left, , , 1 ;-----------------------the actual click
    sleep sleepMicro
    MouseMove, iconX, iconY, 0 ;--------------------moves cursor BACK onto the effect's icon
    ;tooltip, should be back on the effect's icon
    ;sleep 50
    sleep sleepMicro
    
    ;BH-Here is where we flip coormdoe back to Screen so that we can reuse the original coords we first grabbed. Uncomment line below to see if your cursor is starting exactly over the preset's icon.
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
        
    sleep sleepMedium
    
    ;BH-and we should clear the Effects Panel Find text so things are cleared for the next visit
    prFocus("effects") ;brings focus to the effects panel
    sleep sleepMicro
    Sendinput, +f ; selecting the Find text box and it should select any existing text
    sleep sleepMicro
    Sendinput, {Backspace}{Enter}
    sleep sleepMicro
    
    MouseClick, middle, , , 1 ;this returns focus to the panel the cursor is hovering above, WITHOUT selecting anything. great!
    Blockinput, MouseMoveOff ;returning mouse movement ability
    BlockInput, off ;do not comment out or delete this line -- or you won't regain control of the keyboard!! However, CTRL+ALT+DEL will still work if you get stuck!! Cool.    

theEnding:
}
;END of preset()
