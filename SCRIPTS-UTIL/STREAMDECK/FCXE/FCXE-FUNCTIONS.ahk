iniFile := "C:\BPTV-KB\settings.ini"
IniRead, Settings_rootFolder, %iniFile%, Settings, rootFolder
;MsgBox, From FCXE-FUNCTIONS(INITIALIZATION): %iniFile%`n%Settings_rootFolder%

openFCXE(pathToOpen){
	pathToFCXE = "C:\Program Files\FreeCommander XE\FreeCommander.exe"
	FCXEparams =  /C /T /R=
	pathToOpen = "%pathToOpen%"
	Run, %pathToFCXE% %FCXEparams%%pathToOpen%
	Return
}

getFCXEPath(){
  SetTitleMatchMode Slow
  WinGet, f_window_id, ID, A
  WinGetClass, f_class, ahk_id %f_window_id%
  If f_class contains FreeCommanderXE
  {
	    savedPath := parseFCXEPath()
	    pathToSave = % savedPath
  } else {
	   MsgBox,,,You don't appear to be in a FreeCommanderXE window.,2
   }
   ;MsgBox, from getFCXEPath: %pathToSave%
   return pathToSave
}

savePathForFCXE(savedPath){
  global Settings_rootFolder
  FileDelete, %Settings_rootFolder%\PERSONAL\SavedPathForFCXE.txt
	FileAppend, %savedPath%, %Settings_rootFolder%\PERSONAL\SavedPathForFCXE.txt
	;MsgBox,,savePathForFCXE,%savedPath%`nwas saved to`n`n%Settings_rootFolder%\PERSONAL\SavedPathForFCXE.txt, 2
	return
}

parseFCXEPath() {
	WinGetActiveTitle, winTitleFromFCXE
	FoundPos := RegExMatch(winTitleFromFCXE, " - FreeCommander")
	StringLeft, tempPathFromFCXE, winTitleFromFCXE, (FoundPos - 1)
  pathFromFCXE := tempPathFromFCXE . "\"
  ;MsgBox, from parseFCXEPath: winTitleFromFCXE:%winTitleFromFCXE%`ntempPathFromFCXE:%tempPathFromFCXE%
  return PathFromFCXE
}

setWorkingProject() {
  global Settings_rootFolder
  getFCXEPath()
  MsgBox, %Settings_rootFolder%\PERSONAL\CurrentWorkingProject.txt
  FileDelete, %Settings_rootFolder%\PERSONAL\CurrentWorkingProject.txt
  FileCopy, %Settings_rootFolder%\PERSONAL\SavedPathForFCXE.txt, %Settings_rootFolder%\PERSONAL\CurrentWorkingProject.txt
}

getWorkingProject() {
  global Settings_rootFolder
  projectPath := Settings_rootFolder . "\PERSONAL\CurrentWorkingProject.txt"
  FileReadLine, readWorkingProject, %Settings_rootFolder%\PERSONAL\CurrentWorkingProject.txt, 1
  currentWorkingProject := readWorkingProject
  ;MsgBox, from getWorkingProject function: %currentWorkingProject%
  return currentWorkingProject
}
