REM BATCH CONVERT folder to wav
REM Convert audio to wav
REM ffmpeg -i <infile> -ac 2 -f wav <outfile>

FOR /F "tokens=*" %%G IN ('dir /b /s *_Proxy*') DO ffmpeg -i "%%G" -ac 2 -f wav "%%~pnG.wav"
