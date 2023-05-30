REM Convert audio to wav
REM ffmpeg -i <infile> -ac 2 -f wav <outfile>


set fname=%~n1
set newname="%fname%.wav"
ffmpeg -i %1 -ac 2 -f wav %newname%