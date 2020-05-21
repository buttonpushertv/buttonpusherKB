::::::::::::::::::::::::::::::::::::::::::::
:: Automatically check & get admin rights V2
::::::::::::::::::::::::::::::::::::::::::::
@echo off
CLS

@If "%BKB_TEMP%" EQU "" setx BKB_TEMP LOWER
@If "%BKB_TEMP%" EQU "ELEV" goto init

ECHO.
ECHO +==============================+
ECHO Running Admin Shell
ECHO +==============================+
ECHO.
ECHO This script is going to reload itself and Windows
ECHO will ask for permission to allow the script to run 
ECHO as an Admin on this system.
ECHO.
ECHO Please allow this to occur. This script will setup 
ECHO an Environment Variable in your Windows Registry.
ECHO.
ECHO Once completed, it will be found in the Registry here:
ECHO. 
ECHO Computer\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\BKB_ROOT
ECHO.
pause

:init
@setx BKB_TEMP "ELEV"
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
@setx BKB_TEMP ""
@cd ..
@SET rootFolder==%CD%
@ECHO It appears that you are running buttonpusherKB from this directory: %rootFolder%
@CHOICE /C YN /M "Is that correct?"
@echo %ERRORLEVEL%
@If %ERRORLEVEL% EQU 1 setx /m BKB_ROOT %CD%
@If %ERRORLEVEL% EQU 1 @echo Environment Variable set.
@If %ERRORLEVEL% EQU 2 @echo Re-run this script once you have your rootfolder set up the way you want it.
@pause
exit
