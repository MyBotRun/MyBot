; #FUNCTION# ====================================================================================================================
; Name ..........: GoToNormalVillage()
; Description ...: Goes to Normal Village if Game is on Builder Island. Backup if there were any Problem on Start/Run. ( !! Temporary Fix !! )
; Syntax ........: GoToNormalVillage()
; Parameters ....:
; Return values .: None
; Author ........: Fliegerfaust (05-2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func GoToNormalVillage()
	SetLog("Game is currently on Builder Island! Going back to normal now")
	ZoomOut(True)

	If _Sleep(200) Then Return

	SetLog("Searching for Return Boat on Coast!")
	Local $aButtonCoords = findButton("ReturnHomeBoat")
	If IsArray($aButtonCoords) Then
		SetLog("Returning Home from Builder Island", $COLOR_SUCCESS)
		ClickP($aButtonCoords)
		Return True
	Else
		SetLog("Cannot find Return Home Boat on Coast!", $COLOR_ERROR)
		Return False
	EndIf
EndFunc   ;==>GoToNormalVillage
