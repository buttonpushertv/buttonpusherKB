SetWorkingDir %A_ScriptDir%	
#Include %A_ScriptDir%\DRAKE-FUNCTIONS.ahk	
dontSetCurrProj :=	
projectNumber := A_Args[1]	
if (!projectNumber) {	
    projectNumber =1	
}	
InputBox, projectSlug, Project Short Name, What's a short name for this project?	
f_class := whichWindowType()	
If f_class contains FreeCommander	
{	
  gotPath := getFCXEPath()	
  pathGot = % gotPath	
  savePathForFCXE(pathGot)	
}	
else if f_class contains #32770	
{	
    gotPath := Explorer_GetPath()	
    pathGot = % gotPath	
    savePathForExplorer(pathGot)	
    ;MsgBox, 262208, IN A SAVE or SAVE AS DIALOG?, It looks as if you are in a Save As Dialog - there is a way to get this info...just need to figure out how..., 5	
    ;dontSetCurrProj := 1	

}	
else if f_class contains ExploreWClass,CabinetWClass	
{	
  gotPath := Explorer_GetPath()	
  pathGot = % gotPath	
  savePathForExplorer(pathGot)	
}	
else	
{	
  dontSetCurrProj := 1	
  MsgBox, 262208, NOT IN CORRECT WINDOW, It looks as if you are not in a FreeCommanderXE`nor Windows Explorer Window, 5	
}	

If !dontSetCurrProj {	
  setProjectNumber(pathGot, projectNumber, projectSlug)	
}	

exitapp