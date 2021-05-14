@echo off
@REM IMPORTANT-This batch file requires an arguement be passed that is the root folder where your install of buttonpusherKB is running from. It is probably best if you just leave it as 'C:\BKB".

@echo The current directory is %CD%
@echo and this is what got passed: %1

SET rootFolder=%BKB_ROOT%
)

@cd %rootFolder%
@echo Now the current directory is %CD%
@REM This command launches LINTALIST64 at the path & location below
@REM This had to be done becuase LINTALIST takes commandline arguments and since we send %A_ScriptDir% to every thing we launch, it was getting confused since that kind of input doesn't mean anything to the app...

start %rootfolder%\PRIVATE\%COMPUTERNAME%\lintalist64\lintalist.exe
