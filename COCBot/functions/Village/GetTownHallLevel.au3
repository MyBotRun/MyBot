; #FUNCTION# ====================================================================================================================
; Name ..........: GetTownHallLevel
; Description ...:
; Syntax ........: GetTownHallLevel($bFirstTime)
; Parameters ....: $bFirstTime          - a boolean value True = first time the bot has run
; Return values .: None
; Author ........: KNowJack (July 2015)
; Modified ......: Sardo 2015-08
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func GetTownHallLevel($bFirstTime = False)

	Local $aTHInfo[3] = ["", "", ""]

	If $debugSetlog = 1 Then SetLog("Town Hall Position: " & $TownHallPos[0] & ", " & $TownHallPos[1], $COLOR_PURPLE)
	If isInsideDiamond($TownHallPos) = False Then ; If TH pos is not known or is outside village then get new position
		LocateTownHall(True) ; Set flag = true for location only, or repeated loop happens
		If isInsideDiamond($TownHallPos) Then SaveConfig() ; save new location
		If _Sleep($iDelayGetTownHallLevel1) Then Return
	EndIf

	If $bFirstTime = True Then
		Click($TownHallPos[0], $TownHallPos[1] + 5, 1, 0, "#0349")
		If _Sleep($iDelayGetTownHallLevel2) Then Return
	EndIf

	If $debugImageSave = 1 Then DebugImageSave("GetTHLevelView")

	$iTownHallLevel = 0 ; Reset Townhall level
	$aTHInfo = BuildingInfo(242, 520 + $bottomOffsetY)
	If $debugSetlog = 1 Then Setlog("$aTHInfo[0]=" & $aTHInfo[0] & ", $aTHInfo[1]=" & $aTHInfo[1] & ", $aTHInfo[2]=" & $aTHInfo[2], $COLOR_PURPLE)
	If $aTHInfo[0] > 1 Then
		If StringInStr($aTHInfo[1], "Town") = 0 Then
			SetLog("Town Hall not found! I detected a " & $aTHInfo[1] & "! Please locate again!", $COLOR_Fuchsia)
			Return $aTHInfo
		EndIf
		If $aTHInfo[2] <> "" Then
			$iTownHallLevel = $aTHInfo[2] ; grab building level from building info array
			SetLog("Your Town Hall Level read as: " & $iTownHallLevel, $COLOR_GREEN)
		Else
			SetLog("Your Town Hall Level was not found! Please Manually Locate", $COLOR_BLUE)
			ClickP($aAway, 1, 0, "#0350") ; Unselect TH
			Return False
		EndIf
	Else
		SetLog("Your Town Hall Level was not found! Please Manually Locate", $COLOR_BLUE)
		ClickP($aAway, 1, 0, "#0351") ; Unselect TH
		Return False
	EndIf

	ClickP($aAway, 2, $iDelayGetTownHallLevel3, "#0352") ; Unselect TH
	Return True

EndFunc   ;==>GetTownHallLevel
