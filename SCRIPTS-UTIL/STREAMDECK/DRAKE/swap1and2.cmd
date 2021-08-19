copy %BKB_ROOT%\PRIVATE\%computername%\Project-1.txt %BKB_ROOT%\PRIVATE\%computername%\Project-TEMP.txt
copy %BKB_ROOT%\PRIVATE\%computername%\Project-2.txt %BKB_ROOT%\PRIVATE\%computername%\Project-1.txt
copy %BKB_ROOT%\PRIVATE\%computername%\Project-TEMP.txt %BKB_ROOT%\PRIVATE\%computername%\Project-2.txt
del %BKB_ROOT%\PRIVATE\%computername%\Project-TEMP.txt




