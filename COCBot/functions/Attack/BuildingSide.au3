; #FUNCTION# ====================================================================================================================
; Name ..........: GetBuildingEdge, BuildingXY, DElow, SaveAndDisableEBO, RevertEBO
; Description ...: GetBuildingEdge, BuildingXY: To detect the edge of the enemy base the DE STorage or Townhall is on, when Redline is not used.
;                  DElow : To detect the min. of Dark left when DES side attack is used.
;                  SaveAndDisableEBO, RevertEBO: To store the DES exeptions by saving Normal GoldElixir EBO values and put them back after the attack.
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Knowskones (2015)
; Modified ......: Hervidero (2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func GetBuildingEdge($TypeBuilding = $eSideBuildingDES) ;Using $BuildingLoc x y we are finding which side the building is located, only needed when not using redline.
	Local $TypeBuildingName

	BuildingXY($TypeBuilding) ; Get XY coord for Building

	Switch $TypeBuilding
		Case $eSideBuildingDES
			$TypeBuildingName = "DE Storage"
		Case $eSideBuildingTH
			$TypeBuildingName = "TownHall"
	EndSwitch

	If $BuildingLoc = 1 Then
		If ($BuildingLocx = 430) And ($BuildingLocy = 313) Then
			SetLog($TypeBuildingName & " Located in Middle... Attacking Random Side", $COLOR_BLUE)
			$BuildingEdge = (Random(Round(0, 3)))
		ElseIf ($BuildingLocx >= 430) And ($BuildingLocy >= 313) Then
			SetLog($TypeBuildingName & " Located Bottom Right... Attacking Bottom Right", $COLOR_BLUE)
			$BuildingEdge = 0
		ElseIf ($BuildingLocx > 430) And ($BuildingLocy < 313) Then
			SetLog($TypeBuildingName & " Located Top Right... Attacking Top Right", $COLOR_BLUE)
			$BuildingEdge = 3
		ElseIf ($BuildingLocx <= 430) And ($BuildingLocy <= 313) Then
			SetLog($TypeBuildingName & " Located Top Left... Attacking Top Left", $COLOR_BLUE)
			$BuildingEdge = 1
		ElseIf ($BuildingLocx < 430) And ($BuildingLocy > 313) Then
			SetLog($TypeBuildingName & " Located Bottom Left... Attacking Bottom Left", $COLOR_BLUE)
			$BuildingEdge = 2
		EndIf
	ElseIf $BuildingLoc = 0 Then
		SetLog($TypeBuildingName & " Not Located... Attacking Random Side", $COLOR_BLUE)
		$BuildingEdge = (Random(Round(0, 3)))
	EndIf
EndFunc   ;==>GetBuildingEdge

Func BuildingXY($TypeBuilding = $eSideBuildingDES)
	Local $TypeBuildingName

	_CaptureRegion2(230, 170, 630, 440)
	Switch $TypeBuilding
		Case $eSideBuildingDES
			$TypeBuildingName = "DE Storage"
			$BuildingToLoc = GetLocationDarkElixirStorage()
		Case $eSideBuildingTH
			$TypeBuildingName = "TownHall"
			$BuildingToLoc = GetLocationTownHall()
	EndSwitch
	If (UBound($BuildingToLoc) > 1) Then
		Local $centerPixel[2] = [430, 313]
		Local $arrPixelCloser = _FindPixelCloser($BuildingToLoc, $centerPixel, 1)
		$pixel = $arrPixelCloser[0]
	ElseIf (UBound($BuildingToLoc) > 0) Then
		$pixel = $BuildingToLoc[0]
	Else
		$pixel = -1
	EndIf
	If $pixel = -1 Then
		$BuildingLoc = 0
		SetLog(" == " & $TypeBuildingName & " Not Found ==")
	Else
		$pixel[0] += 230 ; compensate CaptureRegion reduction
		$pixel[1] += 170 ; compensate CaptureRegion reduction
		SetLog("== " & $TypeBuildingName & " : [" & $pixel[0] & "," & $pixel[1] & "] ==", $COLOR_BLUE)
		If _Sleep(1000) Then Return False
		$BuildingLocx = $pixel[0] ; compensation for $x center
		$BuildingLocy = $pixel[1] ; compensation for $y center
		$BuildingLoc = 1
	EndIf
EndFunc   ;==>BuildingXY

Func DELow()
	Local $DarkE = ""
	Local $Dchk = 0
	While $DarkE = "" ;~~~~~~~~Loop 10x or until Dark Elixer is Readable.
		$DarkE = getDarkElixirVillageSearch(48, 125)
		$Dchk += 1
		If _Sleep(50) Then Return
		If $Dchk >= 10 Then
			SetLog("Can't find De", $COLOR_RED)
			Return False
		EndIf
	WEnd
	If Number($DarkE) < (Number($searchDark) * (Number($DELowEndMin) / 100)) Then ; First check if Dark Elixer is below set minimum
		If _Sleep(50) Then Return
		$DarkE = getDarkElixirVillageSearch(48, 125)
		If _Sleep(50) Then Return
		If Number($DarkE) < (Number($searchDark) * (Number($DELowEndMin) / 100)) Then ; Second check if Dark Elixer is below set minimum
			If $DEEndAq And $dropQueen And $checkQPower = False Then
				If $iActivateKQCondition = "Auto" Then
					$DarkLow = 1
					SetLog("Low De. De = ( " & $DarkE & " ) and AQ health Low. Return to protect Royals.  Returning immediately", $COLOR_GREEN)
					Return False
				ElseIf Not _ColorCheck(_GetPixelColor(68 + (72 * $Queen), 572, True), Hex(0x72F50B, 6), 120, "Heroes") Then
					$DarkLow = 1
					SetLog("Low De. De = ( " & $DarkE & " ) and AQ health Low. Return to protect Royals.  Returning immediately", $COLOR_GREEN)
					Return False
				EndIf
			EndIf
			If $DEEndBk And $dropKing And $checkKPower = False Then
				If $iActivateKQCondition = "Auto" Then
					$DarkLow = 1
					SetLog("Low De. De = ( " & $DarkE & " ) and BK health Low. Return to protect Royals.  Returning immediately", $COLOR_GREEN)
					Return False
				ElseIf Not _ColorCheck(_GetPixelColor(68 + (72 * $King), 572, True), Hex(0x4FD404, 6), 120, "Heroes") Then
					$DarkLow = 1
					SetLog("Low De. De = ( " & $DarkE & " ) and BK health Low. Return to protect Royals.  Returning immediately", $COLOR_GREEN)
					Return False
				EndIf
			EndIf
			If $DEEndOneStar Then
				If _ColorCheck(_GetPixelColor($aWonOneStar[0], $aWonOneStar[1], True), Hex($aWonOneStar[2], 6), $aWonOneStar[3]) Then
					SetLog("Low De. De = ( " & $DarkE & " ) and 1 star achieved. Return to protect Royals.  Returning immediately", $COLOR_GREEN)
					$DarkLow = 1
					Return False
				Else
					SetLog("Low De. ( " & $DarkE & " ) Waiting for 1 star", $COLOR_GREEN)
					$DarkLow = 2
					Return False
				EndIf
			EndIf
			If $DEEndAq = 0 And $DEEndBk = 0 And $DEEndOneStar = 0 Then
				SetLog("Low De. De = ( " & $DarkE & " ). Return to protect Royals.  Returning immediately", $COLOR_GREEN)
				Return False
			EndIf
		EndIf
	Else
		$DarkLow = 0
	EndIf
EndFunc   ;==>DELow

Func SaveandDisableEBO()
	$saveichkEndOneStar[$iMatchMode] = $ichkEndOneStar[$iMatchMode]
	$saveichkEndTwoStars[$iMatchMode] = $ichkEndTwoStars[$iMatchMode]
	$saveichkTimeStopAtk[$iMatchMode] = $ichkTimeStopAtk[$iMatchMode]
	$saveiChkTimeStopAtk2[$iMatchMode] = $iChkTimeStopAtk2[$iMatchMode]
	$ichkEndOneStar[$iMatchMode] = 0
	$ichkEndTwoStars[$iMatchMode] = 0
	$ichkTimeStopAtk[$iMatchMode] = 0
	$iChkTimeStopAtk2[$iMatchMode] = 0
EndFunc   ;==>SaveandDisableEBO

Func RevertEBO()
	$ichkEndOneStar[$iMatchMode] = $saveichkEndOneStar
	$ichkEndTwoStars[$iMatchMode] = $saveichkEndTwoStars
	$ichkTimeStopAtk[$iMatchMode] = $saveichkTimeStopAtk
	$iChkTimeStopAtk2[$iMatchMode] = $saveiChkTimeStopAtk2
EndFunc   ;==>RevertEBO

