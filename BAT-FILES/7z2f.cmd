@echo off

SET "filename=%~1"
SET dirName=%filename:~0,-4%

"C:\Program Files\7-Zip\7z.exe" x -o"%dirName%" "%filename%"
