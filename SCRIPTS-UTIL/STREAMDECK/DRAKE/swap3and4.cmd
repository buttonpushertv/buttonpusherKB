copy %BKB_ROOT%\PRIVATE\%computername%\Project-3.txt %BKB_ROOT%\PRIVATE\%computername%\Project-TEMP.txt
copy %BKB_ROOT%\PRIVATE\%computername%\Project-4.txt %BKB_ROOT%\PRIVATE\%computername%\Project-3.txt
copy %BKB_ROOT%\PRIVATE\%computername%\Project-TEMP.txt %BKB_ROOT%\PRIVATE\%computername%\Project-4.txt
del %BKB_ROOT%\PRIVATE\%computername%\Project-TEMP.txt



