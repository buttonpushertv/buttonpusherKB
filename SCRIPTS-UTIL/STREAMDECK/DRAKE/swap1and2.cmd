set rootFolder=%BKB_ROOT%

copy %rootFolder%\PRIVATE\%computername%\Project-1.txt %rootFolder%\PRIVATE\%computername%\Project-TEMP.txt
copy %rootFolder%\PRIVATE\%computername%\Project-2.txt %rootFolder%\PRIVATE\%computername%\Project-1.txt
copy %rootFolder%\PRIVATE\%computername%\Project-TEMP.txt %rootFolder%\PRIVATE\%computername%\Project-2.txt
del %rootFolder%\PRIVATE\%computername%\Project-TEMP.txt




