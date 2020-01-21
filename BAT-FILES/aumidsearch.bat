@echo off
REM Command Line Utility to find AUMID of windows universal apps

reg query HKEY_CURRENT_USER\Software\Classes\ /s /f AppUserModelID | find "REG_SZ" | findstr -i %*
