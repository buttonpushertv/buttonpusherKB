@echo off
REM This batch file contains calls to backup active project files via FreeFileSync and the settings files created thru the DRAKE\SAVEProjNumber.ahk script
REM Based on the settings files, they should alert you if there are errors.

REM From time to time, you may want to edit this file and remove any older entries for projects that have been archived
REM (Maybe someday this can be automated)

CALL C:\BKB\PRIVATE\RYZEN9-PC\_fff-backup-settings\P7W_Renova-CommittedToCommunity-Color-backup.ffs_batch
if not %errorlevel% == 0 (
  echo Errors occurred during synchronization...
  pause & exit 1
)
CALL C:\BKB\PRIVATE\RYZEN9-PC\_fff-backup-settings\PBS-ShotTextRemoval-backup.ffs_batch
if not %errorlevel% == 0 (
  echo Errors occurred during synchronization...
  pause & exit 1
)
CALL C:\BKB\PRIVATE\RYZEN9-PC\_fff-backup-settings\RESERVOIR-ACLA-Captions-backup.ffs_batch
if not %errorlevel% == 0 (
  echo Errors occurred during synchronization...
  pause & exit 1
)
CALL C:\BKB\PRIVATE\RYZEN9-PC\_fff-backup-settings\Molly_CollegePreScreens-backup.ffs_batch
if not %errorlevel% == 0 (
  echo Errors occurred during synchronization...
  pause & exit 1
)
CALL C:\BKB\PRIVATE\RYZEN9-PC\_fff-backup-settings\BPS_AnimatedAssetsRemix-backup.ffs_batch
if not %errorlevel% == 0 (
  echo Errors occurred during synchronization...
  pause & exit 1
)
CALL C:\BKB\PRIVATE\RYZEN9-PC\_fff-backup-settings\BPS_StreamingElements-backup.ffs_batch
if not %errorlevel% == 0 (
  echo Errors occurred during synchronization...
  pause & exit 1
)

CALL C:\BKB\PRIVATE\RYZEN9-PC\_fff-backup-settings\_NMF_BROADCAST_TEMPLATE_PREMIERE-backup.ffs_batch
if not %errorlevel% == 0 (
  echo Errors occurred during synchronization...
  pause & exit 1
)
