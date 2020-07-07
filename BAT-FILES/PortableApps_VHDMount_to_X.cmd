::::::::::::::::::::::::::::::::::::::::::::
:: Automatically check & get admin rights V2
::::::::::::::::::::::::::::::::::::::::::::
@echo off
CLS

ECHO.
ECHO +==============================+
ECHO Running Admin Shell
ECHO +==============================+
:init
setlocal DisableDelayedExpansion
set "batchPath=%~0"
for %%k in (%0) do set batchName=%%~nk
set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
setlocal EnableDelayedExpansion

:checkPrivileges
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
ECHO.
ECHO **************************************
ECHO Invoking UAC for Privilege Escalation
ECHO (Asking to Run as Admin)
ECHO **************************************

ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
ECHO args = "ELEV " >> "%vbsGetPrivileges%"
ECHO For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
ECHO args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
ECHO Next >> "%vbsGetPrivileges%"
ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
"%SystemRoot%\System32\WScript.exe" "%vbsGetPrivileges%" %*
exit /B

:gotPrivileges
setlocal & pushd .
cd /d %~dp0
if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)

::::::::::::::::::::::::::::
::START
::::::::::::::::::::::::::::
REM Run shell as admin (example) - put here code as you like
REM ECHO %batchName% Arguments: %1 %2 %3 %4 %5 %6 %7 %8 %9
REM cmd /k
ECHO.
ECHO Running as Admin now...
ECHO.
ECHO.
	ECHO +==============================+
	ECHO.
	ECHO Mounted Volumes - (Local Drives)
	wmic logicaldisk get volumename,name
	ECHO Mounted Volumes - (Network Shares)
	type %temp%\StartupLog.txt
	ECHO.
	ECHO +==============================+

	ECHO Checking for existence of X:
	IF EXIST X:\ (
		echo X: Drive already mounted.
		echo Press any key to run BKB-Launcher (CTRL-C to abort)...
		pause
		goto unLocked
	) else (
		echo.
		echo X: not mounted
		echo.
	)

	SET DiskPartScript="%TEMP%\DiskpartScript.txt"

	ECHO SELECT VDISK FILE="D:\PortableApps.vhdx" > %DiskPartScript%
	ECHO ATTACH VDISK >> %DiskPartScript%
	ECHO ASSIGN LETTER X

	DiskPart /s %DiskPartScript%

	:accessDisk
    REM This VHD is not password protected. It should be 'unlocked' by default.

	:unLocked

	ECHO Launching BKB-LAUNCHER
	cd %BKB_ROOT%
	BKB-LAUNCHER.ahk

	:allDone
	exit