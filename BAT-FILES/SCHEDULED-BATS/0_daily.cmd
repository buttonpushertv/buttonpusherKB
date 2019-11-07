@echo off
@echo =================
@echo RUNNING DAILY BAT
@echo =================

REM Backing up various settings that have paths that are universal. These files exist in the same location on any system they are installed on.
REM To backup items which have unique paths or are located in different places on different systems, use the SYSTEM SPECIFIC SCRIPT at the end of this section.

REM This backs up the BPTV-KB settings for this system. You want to back these up for each system (e.g.-location) because you likely have different settings for each.
copy %1\settings.ini %1\PRIVATE\%computername%\SETTINGS-BACKUPS\

REM This backs up the settings for VNCHelper - again it's location specific but the settings file is stored in the same place where ever BPTV-KB is installed.
copy %1\UTIL-APPS\vnchelper\vnchelper.ini %1\PRIVATE\%computername%\SETTINGS-BACKUPS\

copy %1\UTIL-APPS\QAP\QuickAccessPopup.ini %1\PRIVATE\%computername%\SETTINGS-BACKUPS\

call %1\BAT-FILES\Backup-StreamDeck-Profiles.cmd %1

call %1\PRIVATE\%computername%-BACKUPS.cmd %1

@echo ------------------
@echo DAILY BAT COMPLETE
@echo ------------------
@echo.
