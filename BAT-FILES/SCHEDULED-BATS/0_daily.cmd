@echo =================
@echo RUNNING DAILY BAT
@echo =================

@REM Backing up various settings that have paths that are universal. These files exist in the same location on any system they are installed on.
@REM To backup items which have unique paths or are located in different places on different systems, use the SYSTEM SPECIFIC SCRIPT at the end of this section.
IF EXIST %1\PRIVATE\%computername%\last_daily_run.txt (
  for %%a in (%1\PRIVATE\%computername%\last_daily_run.txt) do set lastDailyRun=%%~ta
  ) ELSE (
  set /a lastDailyRun = NONE
  )
@echo lastDailyRun is set to: %lastDailyRun%

@if /i %lastDailyRun:~0,10% EQU %date:~4,10% exit /b

@echo This backs up the BPTV-KB settings for this system. You want to back these up for each system (e.g.-location) because you likely have different settings for each.
copy %1\settings.ini %1\PRIVATE\%computername%\SETTINGS-BACKUPS\

@echo This backs up the settings for VNCHelper - again it's location specific but the settings file is stored in the same place where ever BPTV-KB is installed.
copy %1\UTIL-APPS\vnchelper\vnchelper.ini %1\PRIVATE\%computername%\SETTINGS-BACKUPS\

@echo This backs up the QuickAccessPopup's ini for this system
copy %1\UTIL-APPS\QAP\QuickAccessPopup.ini %1\PRIVATE\%computername%\SETTINGS-BACKUPS\

@echo This backs up the StreamDeck's Profile from this system
call %1\BAT-FILES\Backup-StreamDeck-Profiles.cmd %1

@echo This runs a backup that is specific to this system
call %1\PRIVATE\%computername%-BACKUPS.cmd %1

@echo %date% > %1\PRIVATE\%computername%\last_daily_run.txt
@echo ------------------
@echo DAILY BAT COMPLETE
@echo ------------------
@echo.
