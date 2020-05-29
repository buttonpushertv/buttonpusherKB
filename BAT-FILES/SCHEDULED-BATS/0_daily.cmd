@echo =================
@echo RUNNING DAILY BAT
@echo =================

@SET rootFolder=%1

@REM Backing up various settings that have paths that are universal. These files exist in the same location on any system they are installed on.
@REM To backup items which have unique paths or are located in different places on different systems, use the SYSTEM SPECIFIC SCRIPT at the end of this section.
IF EXIST %rootFolder%\PRIVATE\%computername%\last_daily_run.txt (
  for %%a in (%rootFolder%\PRIVATE\%computername%\last_daily_run.txt) do set lastDailyRun=%%~ta
  ) ELSE (
  set /a lastDailyRun = NONE
  )
@echo lastDailyRun is set to: %lastDailyRun%

@if /i %lastDailyRun:~0,10% EQU %date:~4,10% exit /b

@echo This backs up the buttonpusherKB settings.ini for this system. You want to back these up for each system (e.g.-location) because you likely have different settings for each.
copy %rootFolder%\settings.ini %rootFolder%\PRIVATE\%computername%\SETTINGS-BACKUPS\

@echo This backs up the settings for VNCHelper - again it's location specific but the settings file is stored in the same place where ever buttonpusherKB is installed.
copy %rootFolder%\UTIL-APPS\vnchelper\vnchelper.ini %rootFolder%\PRIVATE\%computername%\SETTINGS-BACKUPS\

@echo This backs up the StreamDeck's Profile from this system
call %rootFolder%\BAT-FILES\Backup-StreamDeck-Profiles.cmd %rootFolder%

@echo This runs a backup that is specific to this system
call %rootFolder%\PRIVATE\%computername%-BACKUPS.cmd %rootFolder%

@echo %date% > %rootFolder%\PRIVATE\%computername%\last_daily_run.txt
@echo ------------------
@echo DAILY BAT COMPLETE
@echo ------------------
@echo.
