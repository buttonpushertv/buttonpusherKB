REM The command below creates a ZIP file of the StreamDeck Profiles found on a given system and stores them at the argument passed as %1 on execution.

PowerShell -Command "Compress-Archive -Path '%appdata%\Elgato\StreamDeck\ProfilesV2\' -Destination '%1\PRIVATE\%computername%\StreamDeck_Profiles_Backup' -force"

REM the creation of this ZIP file takes a longish time....maybe it just needs to be a copy?