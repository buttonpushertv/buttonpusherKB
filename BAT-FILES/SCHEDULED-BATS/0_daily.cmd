@echo off
@echo =================
@echo RUNNING DAILY BAT
@echo =================

REM Backing up various settings that have paths that are universal. These files exist in the same location on any system they are installed on.
REM To backup items which have unique paths or are located in different places on different systems, use the SYSTEM SPECIFIC SCRIPT at the end of this section.

REM This backs up the BPTV-KB settings for this system. You want to back these up for each system (e.g.-location) because you likely have different settings for each.
copy C:\BPTV-KB\settings.ini C:\BPTV-KB\PRIVATE\%computername%\SETTINGS-BACKUPS\

REM This backs up the settings for VNCHelper - again it's location specific but the settings file is stored in the same place where ever BPTV-KB is installed.
copy C:\BPTV-KB\UTIL-APPS\vnchelper\vnchelper.ini C:\BPTV-KB\PRIVATE\%computername%\SETTINGS-BACKUPS\

copy C:\BPTV-KB\UTIL-APPS\QAP\QuickAccessPopup.ini C:\BPTV-KB\PRIVATE\%computername%\SETTINGS-BACKUPS\

call "..\Backup StreamDeck Profiles.cmd"

call C:\BPTV-KB\PRIVATE\%computername%-BACKUPS.cmd

@echo ------------------
@echo DAILY BAT COMPLETE
@echo ------------------
@echo.
