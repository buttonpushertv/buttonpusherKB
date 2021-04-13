@echo off

ffmpeg.exe -hide_banner -vcodec libvpx-vp9 -i "%1" -pix_fmt rgba -map 0 -c:v rawvideo -c:a copy "%~n1.avi"
pause