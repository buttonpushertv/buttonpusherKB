REM this batch file will convert the input file to ProRes
REM you need to supply both the input filename and the output file name

ffmpeg -i %1 -c:v prores -profile:v 3 %2