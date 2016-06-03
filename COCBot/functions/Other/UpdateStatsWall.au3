; #FUNCTION# ====================================================================================================================
; Name ..........: WallsStatsMAJ
; Description ...: This function will update the statistics in the GUI.
; Syntax ........: WallsStatsMAJ()
; Parameters ....: None
; Return values .: None
; Author ........: Boju (2016)
; Modified ......: zengzeng (2016-3)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......:
; ===============================================================================================================================
Func WallsStatsMAJ()
	Local $sVarNameOld = "itxtwall" & ($icmbWalls + 4 < 10 ? "0" : "") & ($icmbWalls + 4) & "ST"
	Local $sVarNameNew = "itxtwall" & ($icmbWalls + 5 < 10 ? "0" : "") & ($icmbWalls + 5) & "ST"
	Assign($sVarNameOld, Number(Eval($sVarNameOld)) - Number($iNbrOfWallsUpped))
	Assign($sVarNameNew, Number(Eval($sVarNameNew)) + Number($iNbrOfWallsUpped))
	$iNbrOfWallsUpped = 0
		GUICtrlSetData($txtWall04ST, $itxtWall04ST)
		GUICtrlSetData($txtWall05ST, $itxtWall05ST)
		GUICtrlSetData($txtWall06ST, $itxtWall06ST)
		GUICtrlSetData($txtWall07ST, $itxtWall07ST)
		GUICtrlSetData($txtWall08ST, $itxtWall08ST)
		GUICtrlSetData($txtWall09ST, $itxtWall09ST)
		GUICtrlSetData($txtWall10ST, $itxtWall10ST)
		GUICtrlSetData($txtWall11ST, $itxtWall11ST)
	SaveConfig()
EndFunc   ;==>WallsStatsMAJ
