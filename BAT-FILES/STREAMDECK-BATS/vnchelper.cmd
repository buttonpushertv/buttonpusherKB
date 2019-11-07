REM This will use initool.exe to read the location of the rootFolder from settings.ini
@FOR /F "tokens=* USEBACKQ" %%F IN (`..\UTIL-APPS\initool\initool.exe g ..\settings.ini Settings rootFolder --value-only`) DO (
SET rootFolder=%%F
)

start "VNC Helper Launcher" /D "%rootFolder%\UTIL-APPS\vnchelper\" "vnchelper.exe"
