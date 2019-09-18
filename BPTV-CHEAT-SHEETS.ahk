; AutoHotKey - Blank Template
; by Ben Howard - ben@buttonpusher.tv

; You can customize this template by editing "C:\Windows\ShellNew\Template.ahk"
;===============================================================================================
; This Template.ahk file contains several of the most common items that I find myself often
; needing or adding to my scripts. It's not all essential. Here's a short list of what's here:
; - Function (CheckScriptUpdate) that will auto-reload the script when it detects a change
;	in the last modified timestamp on the script file itself
; - Sleep duration shortcuts - so that sleep times can be modified in one place to affect all
; - Modifier Memory Helper - just a comment section to remind you of what the codes are for things
;
; See comments througout the file to figure out what something is here for.

;===== START OF AUTO-EXECUTION SECTION =========================================================
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent ; Keeps script permanently running.
#SingleInstance force ; Ensures that there is only a single instance of this script running.
#InstallKeybdHook        ;Recent Window 10 updates have started getting the Alt key stuck down,
#UseHook On              ;but only in AutoHotKey. These 3 commands are an attempt to fix that.
#HotkeyModifierTimeout 0 ;It's not clear if this completely fixes it.
; SetTitleMatchMode, 2 ; sets title matching to search for "containing" instead of "exact"

; The 2 lines below pertain to the 'reload on save' function below (CheckScriptUpdate).
; They are required for it to work.
FileGetTime ScriptStartModTime, %A_ScriptFullPath%
SetTimer CheckScriptUpdate, 100, 0x7FFFFFFF ; 100 ms, highest priority

;===== INITIALIZATION - VARIABLES ==============================================================
; Sleep shortcuts - use these to standardize sleep times. Change here to change everywhere.
sleepShort = 333
sleepMedium = 666
sleepLong = 1500
sleepDeep = 3500

splashScreenX = %1%
splashScreenY = %2%
splashScreenTimeout = %3%
;Location_currentSystemLocation = 1
Location_currentSystemLocation = %4%


;===== SPLASH SCREEN TO ANNOUNCE WHAT SCRIPT DOES ==============================================
SplashTextOn, 600, 80, Launching %A_ScriptFullPath%, Loading BPTV-CHEAT-SHEETS
WinMove, Launching %A_ScriptFullPath%, , %splashScreenX%, %splashScreenY%
SetTimer, RemoveSplashScreen, %splashScreenTimeout%
Sleep, sleepDeep
SplashTextOff

;===== END OF AUTO-EXECUTE =====================================================================
;===== MODIFIER MEMORY HELPER ==================================================================
; combine below with key and '::' to define hotkey
; e.g.- ^f1::Msgbox You pressed Control and F1
; #=Win | !=Alt | ^=Ctrl | +=Shift | &=combine keys | *=ignore other mods
; <=use left mod key| >=use right mod key  | UP=fires on release

;===== MAIN HOTKEY DEFINITIONS HERE ============================================================
CapsLock & f1:: ; <--Display a Text File CheatSheet of MASTER-SCRIPT AutoHotKeys based on Location setting.
    txt2show := "SUPPORTING-FILES\KBF1-LOC" . Location_currentSystemLocation . ".txt"
    showText(txt2show)
    keywait, f1
    Gui, Text:Destroy
return

CapsLock & f2:: ; <--Display an image CheatSheet of App Specific Keyboard Shortcuts (In-app and AHK)
    If WinActive("ahk_exe Explorer.EXE") {
        pic2show := "SUPPORTING-FILES\KBF2-WIN-PAGE"
        PictureWidth := 2000
        numPages := 2
    }
    else
    If WinActive("ahk_exe Adobe Premiere Pro.exe") {
        pic2Show := "SUPPORTING-FILES\KBF2-PPRO.png"
        PictureWidth := 2000
        numPages := 1
    }
    else
    If WinActive("ahk_exe AfterFX.exe") {
        pic2Show := "SUPPORTING-FILES\KBF2-AE.png"
        PictureWidth := 2000
        numPages := 1
    }
    else
    If WinActive("ahk_exe SubtitleEdit.exe") {
        pic2Show := "SUPPORTING-FILES\KBF2-CONTOUR-PRO-SUBTITLE-EDIT.jpg"
        PictureWidth := 906
        numPages := 1
    }
    else
    If WinActive("ahk_exe stickies.exe") {
        pic2Show := "SUPPORTING-FILES\KBF2-STICKIES.png"
        PictureWidth := 1920
        numPages := 1
    }
    else {
        pic2Show := "SUPPORTING-FILES\NO-CHEATSHEET.png"
        PictureWidth := 579
        numPages := 1
    }
    showImageTabs(pic2Show, PictureWidth, numPages)
    keywait, f2
    numPages := 0
    Gui, Picture:Destroy
return

CapsLock & f3:: ; <--Display a Text File CheatSheet of App Specific AutoHotKeys
    If WinActive("ahk_exe Explorer.EXE")
        showText("SUPPORTING-FILES\KBF3-WINDOWS-DEFAULT-KEYS.txt")
    else
    If WinActive("ahk_exe Adobe Premiere Pro.exe")
        showText("SUPPORTING-FILES\KBF3-PPRO.txt")
    else
    If WinActive("ahk_exe stickies.exe")
        showText("SUPPORTING-FILES\KBF3-STICKIES.txt")
    else
        showText("SUPPORTING-FILES\NO-CHEATSHEET.txt")
    keywait, f3
    Gui, Text:Destroy
return

CapsLock & f4:: ; <--Display an image CheatSheet based on System Location Setting
    locationPic := "SUPPORTING-FILES\KBF4-LOC" . Location_currentSystemLocation . ".png"
    showPic(locationPic, 0)
    keywait,f4
    Gui, Picture:Destroy
return

;===== FUNCTIONS ===============================================================================

RemoveSplashScreen:
    SplashTextOff
    SetTimer RemoveSplashScreen, Off
return

;for showText & showPic - I want to add code in that will downgrade to the next lowest code that does exist if it can't find whatever file it is sent.

; showText is used to create and display a GUI for a text file as a Cheat Sheet
showText(fileToShow){
  IfNotExist, %fileToShow%
    fileToShow := "SUPPORTING-FILES\AHK-KEYS-NO-CHEATSHEET.txt"
  FileRead, textToShow, %fileToShow%
  FormatTime, now,, hh:mm tt
  today = %A_YYYY%-%A_MMM%-%A_DD%
  Gui, Text:+alwaysontop +disabled -sysmenu +owner -caption +toolwindow +0x02000000
  Gui, Text:Color, 000000
  Gui, Text:Margin, 30, 30
  Gui, Text:font, s12 cFFFFFF, Consolas
  Gui, Text:Add, Text, , %now% - %today%
  Gui, Text:add, text, , %textToShow%
  Gui, Text:add, text, , File: %A_ScriptDir%\%fileToShow%
  Gui, Text:Show
return
}

; showPic is used to create and display a GUI for an image Cheat Sheet
; showPic can only display single images in a single frame (see showImageTabs below for more than 1 image)
showPic(picToShow, PictureWidth){
  SysGet, Mon1, Monitor, 1
  If (Mon1Right < PictureWidth)
    PictureWidth -= 425
  if !FileExist(picToShow) {
    picToShow := "SUPPORTING-FILES\NO-CHEAT-SHEET.png"
    PictureWidth := 579
  }
  Gui, Picture:+alwaysontop +disabled -sysmenu +owner -caption +toolwindow +0x02000000
  Gui, Picture:Color, 000000
  Gui, Picture:Margin, 15, 15
  Gui, Picture:font, s14 cFFFFFF, Consolas
  Gui, Picture:add, picture, w%PictureWidth% h-1 , %picToShow%
  Gui, Picture:add, text, , File: %A_ScriptDir%\%picToShow%
  Gui, Picture:Show
return
}

; showImageTabs is used to create and display a GUI for multiple images in tabs
; Once displayed, you can scroll up or down to change visible image tabs
showImageTabs(picToshow, PictureWidth, numPages){
    SysGet, Mon1, Monitor, 1
    If (Mon1Right < PictureWidth)
      PictureWidth -= 450
    If (numPages = 1) {
      showPic(picToshow, PictureWidth)
      return
    }
    Gui, Picture:+alwaysontop -sysmenu +owner -caption +toolwindow +0x02000000
    Gui, Picture:Color, 111111
    Gui, Picture:Margin, 5, 5
    Gui, Picture:font, s10 cFFFFFF, Consolas
    loop, %numPages% {
        nextTab := tabList . "Page" . A_Index . "|"
        tabList := nextTab
        }
    Gui, Picture:add, Tab3,, %tabList%
    loop, %numPages% {
        fileToShow := picToShow . A_Index . ".png"
          if !FileExist(fileToShow) {
            picToShow := "SUPPORTING-FILES\NO-CHEAT-SHEET.png"
            PictureWidth := 579
            showPic(picToshow, PictureWidth)
            Return
          }
        If (A_Index = 1) {
            Gui, Picture:add, picture, w%PictureWidth% h-1 , %fileToShow%
            Gui, Picture:add, text, , %PictureWidth% - File: %A_ScriptDir%\%fileToShow%
        }
        else {
            Gui, Picture:Tab, %A_Index%
            Gui, Picture:add, picture, w%PictureWidth% h-1 , %fileToShow%
            Gui, Picture:add, text, , File: %A_ScriptDir%\%fileToShow%
            }
    }
    Gui, Picture:Tab
    Gui, Picture:Show
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
            Sleep 300 ; ms
            MsgBox 0x2, %A_ScriptName%, Reload failed. ; 0x2 = Abort/Retry/Ignore
            IfMsgBox Abort
                ExitApp
            IfMsgBox Ignore
                break
        } ; loops reload on "Retry"
    }
}
