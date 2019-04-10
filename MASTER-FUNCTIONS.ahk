; AutoHotKey - MASTER-FUNCTIONS for inclusion into MASTER-SCRIPT.AHK
;by Ben Howard - ben@buttonpusher.tv

;===============================================================================================
;===== START OF AUTO-EXECUTION SECTION =========================================================
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; #Persistent ; Keeps script permanently running.
#SingleInstance force ; Ensures that there is only a single instance of this script running.
; SetTitleMatchMode, 2 ; sets title matching to search for "containing" instead of "exact"

;===== INITIALIZATION - VARIABLES ==============================================================
; Sleep shortcuts - use these to standardize sleep times
sleepMicro := 15
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

showText(fileToShow){
FileRead, textToShow, %fileToShow%
FormatTime, now,, hh:mm tt
today = %A_YYYY%-%A_MMM%-%A_DD%
Gui, Text:+alwaysontop +disabled -sysmenu +owner -caption +toolwindow +0x02000000
Gui, Text:Color, 000000
Gui, Text:Margin, 30, 30
Gui, Text:font, s14 cFFFFFF, Consolas
Gui, Text:Add, Text, , %now% - %today%
Gui, Text:add, text, , %textToShow%
Gui, Text:add, text, , File: %A_ScriptDir%\%fileToShow%
Gui, Text:Show
return
}

showPic(picToShow){
Gui, Picture:+alwaysontop +disabled -sysmenu +owner -caption +toolwindow +0x02000000
Gui, Picture:Color, 000000
Gui, Picture:Margin, 30, 30
Gui, Picture:font, s14 cFFFFFF, Consolas
Gui, Picture:add, picture, , %picToShow%
Gui, Picture:add, text, , File: %A_ScriptDir%\%picToShow%
Gui, Picture:Show
return
}

killGui(whicGUI){
Gui, Destroy
return
}

INILoad(INIfile) {
    INIRead, loadPremierePro, %INIfile%, Apps, loadPremierePro
    INIRead, loadPPRORightClickMod, %INIfile%, Apps, loadPPRORightClickMod
    INIRead, loadAfterEffects, %INIfile%, Apps, loadAfterEffects
    INIRead, loadPhotoshop, %INIfile%, Apps, loadPhotoshop
    INIRead, loadAcceleratedScrolling, %INIfile%, Helpers, loadAcceleratedScrolling
    INIRead, loadKeyPressOSD, %INIfile%, Helpers, loadKeyPressOSD
}

INISave(INIfile) {
    IniWrite, %loadPremierePro%, %INIfile%, Apps, loadPremierePro
    IniWrite, %loadPPRORightClickMod%, %INIfile%, Apps, loadPPRORightClickMod
    INIWrite, %loadAfterEffects%, %INIfile%, Apps, loadAfterEffects
    INIWrite, %loadPhotoshop%, %INIfile%, Apps, loadPhotoshop
    INIWrite, %loadAcceleratedScrolling%, %INIfile%, Helpers, loadAcceleratedScrolling
    INIWrite, %loadKeyPressOSD%, %INIfile%, Helpers, loadKeyPressOSD
}




; ===========================================================================
; Run a program or switch to it if already running.
;    Target - Program to run. E.g. Calc.exe or C:\Progs\Bobo.exe
;    WinTitle - Optional title of the window to activate.  Programs like
;    MS Outlook might have multiple windows open (main window and email
;    windows).  This parm allows activating a specific window.
; ===========================================================================

RunOrActivate(Target, WinTitle = "", Parameters = "")
{
   ; Get the filename without a path
   SplitPath, Target, TargetNameOnly

   Process, Exist, %TargetNameOnly%
   If ErrorLevel > 0
      PID = %ErrorLevel%
   Else
      Run, %Target% "%Parameters%", , , PID

   ; At least one app (Seapine TestTrack wouldn't always become the active
   ; window after using Run), so we always force a window activate.
   ; Activate by title if given, otherwise use PID.
   If WinTitle <> 
   {
      SetTitleMatchMode, 2
      WinWait, %WinTitle%, , 3
      TrayTip, , Activating Window Title "%WinTitle%" (%TargetNameOnly%)
      WinActivate, %WinTitle%
   }
   Else
   {
      WinWait, ahk_pid %PID%, , 3
      TrayTip, , Activating PID %PID% (%TargetNameOnly%)
      WinActivate, ahk_pid %PID%
   }
}

VNCRunOrActivate(VNCLaunchCode, VNCWintitle)
{
   if WinExist(VNCWinTitle)
      WinActivate, %VNCWinTitle%
   else
      Run, %VNCLaunchCode%
}