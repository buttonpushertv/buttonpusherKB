REM this batch file will convert the input file to ProRes
REM you need to supply both the input filename and the output file name
set fname=%~n1
set newname="%fname%-PR422.mov"

if not exist "originals\" (
    mkdir originals
)

ffmpeg -i %1 -c:v prores -profile:v 3 %newname%

move %1 originals\

%BKB_ROOT%\SCRIPTS-UTIL\play_a_sound.ahk "C:\BKB\SUPPORTING-FILES\SOUNDS\PB - Sci-Fi UI Free SFX\PremiumBeat SFX\PremiumBeat_0013_cursor_selection_11.wav" "Conversion is done! Original moved to 'originals' folder" 4000
