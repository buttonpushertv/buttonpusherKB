REM echo off
set fname=%~n1
set newname="%fname%.webp"
magick %1 -quality 65 %newname%
