@echo =================
@echo RUNNING DAILY BAT
@echo =================

@REM Backing up various settings that have paths that are universal. These files exist in the same location on any system they are installed on.
@REM To backup items which have unique paths or are located in different places on different systems, use the SYSTEM SPECIFIC SCRIPT at the end of this section.
IF EXIST %BKB_ROOT%\PRIVATE\%computername%\last_daily_run.txt (
  for %%a in (%BKB_ROOT%\PRIVATE\%computername%\last_daily_run.txt) do set lastDailyRun=%%~ta
  ) ELSE (
  set /a lastDailyRun = NONE
  )
@echo lastDailyRun is set to: %lastDailyRun%

@if /i %lastDailyRun:~0,10% EQU %date:~4,10% exit /b

@echo This backs up the buttonpusherKB settings.ini for this system. You want to back these up for each system (e.g.-location) because you likely have different settings for each.
copy %BKB_ROOT%\settings.ini %BKB_ROOT%\PRIVATE\%computername%\SETTINGS-BACKUPS\

@echo This backs up the StreamDeck's Profile from this system
call %BKB_ROOT%\BAT-FILES\Backup-StreamDeck-Profiles.cmd %BKB_ROOT%

@echo This runs a backup that is specific to this system
call %BKB_ROOT%\PRIVATE\%computername%-BACKUPS.cmd %BKB_ROOT%

@echo %date% > %BKB_ROOT%\PRIVATE\%computername%\last_daily_run.txt
@echo ------------------
@echo DAILY BAT COMPLETE
@echo ------------------
@echo.
