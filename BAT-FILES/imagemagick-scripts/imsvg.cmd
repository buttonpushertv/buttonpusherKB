echo off
set fname=%~n1
set newname="%fname%.svg"
magick %1 %newname%
