REM ffmpeg -i [path to input video] -c:v qtrle [path to output].mov
REM or
REM ffmpeg -i [path to input video] -c:v qtrle -pix_fmt yuva420p [path to output].mov

set fname=%~n1
set newname="%fname%-CONVERT2.mov"
ffmpeg -i %1 -c:v qtrle -pix_fmt yuva420p %newname%