@echo off

@cd %BKB_ROOT%

@REM This command launches LINTALIST64 at the path & location below
@REM This had to be done becuase LINTALIST takes commandline arguments and since we send %A_ScriptDir% to every thing we launch, it was getting confused since that kind of input doesn't mean anything to the app...

start %BKB_ROOT%\PRIVATE\%COMPUTERNAME%\lintalist64\lintalist.exe
