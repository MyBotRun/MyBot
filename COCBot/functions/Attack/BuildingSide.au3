; #FUNCTION# ====================================================================================================================
; Name ..........: GetBuildingEdge, BuildingXY, DElow, SaveAndDisableEBO, RevertEBO
; Description ...: GetBuildingEdge, BuildingXY: To detect the edge of the enemy base the DE STorage or Townhall is on, when Redline is not used.
;                  DElow : To detect the min. of Dark left when DES side attack is used.
;                  SaveAndDisableEBO, RevertEBO: To store the DES exeptions by saving Normal GoldElixir EBO values and put them back after the attack.
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Knowskones (2015)
; Modified ......: Hervidero (2015), CodeSlinger69 (01-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_abSaveiChkTimeStopAtk[$g_iModeCount], $g_abSaveiChkTimeStopAtk2[$g_iModeCount], $g_abSaveichkEndOneStar[$g_iModeCount], $g_abSaveichkEndTwoStars[$g_iModeCount]
Global $g_iBuildingLoc = 0, $g_iBuildingLocX = 0, $g_iBuildingLocY = 0

Func GetBuildingEdge($TypeBuilding = $eSideBuildingDES) ;Using $g_iBuildingLoc x y we are finding which side the building is located, only needed when not using redline.
	Local $TypeBuildingName

	BuildingXY($TypeBuilding) ; Get XY coord for Building

	Switch $TypeBuilding
		Case $eSideBuildingDES
			$TypeBuildingName = "DE Storage"
		Case $eSideBuildingTH
			$TypeBuildingName = "TownHall"
	EndSwitch

	If $g_iBuildingLoc = 1 Then
		If ($g_iBuildingLocX = 430) And ($g_iBuildingLocY = 313) Then
			SetLog($TypeBuildingName & " Located in Middle... Attacking Random Side", $COLOR_INFO)
			$g_iBuildingEdge = (Random(Round(0, 3)))
		ElseIf ($g_iBuildingLocX >= 430) And ($g_iBuildingLocY >= 313) Then
			SetLog($TypeBuildingName & " Located Bottom Right... Attacking Bottom Right", $COLOR_INFO)
			$g_iBuildingEdge = 0
		ElseIf ($g_iBuildingLocX > 430) And ($g_iBuildingLocY < 313) Then
			SetLog($TypeBuildingName & " Located Top Right... Attacking Top Right", $COLOR_INFO)
			$g_iBuildingEdge = 3
		ElseIf ($g_iBuildingLocX <= 430) And ($g_iBuildingLocY <= 313) Then
			SetLog($TypeBuildingName & " Located Top Left... Attacking Top Left", $COLOR_INFO)
			$g_iBuildingEdge = 1
		ElseIf ($g_iBuildingLocX < 430) And ($g_iBuildingLocY > 313) Then
			SetLog($TypeBuildingName & " Located Bottom Left... Attacking Bottom Left", $COLOR_INFO)
			$g_iBuildingEdge = 2
		EndIf
	ElseIf $g_iBuildingLoc = 0 Then
		SetLog($TypeBuildingName & " Not Located... Attacking Random Side", $COLOR_INFO)
		$g_iBuildingEdge = (Random(Round(0, 3)))
	EndIf
EndFunc   ;==>GetBuildingEdge

Func BuildingXY($TypeBuilding = $eSideBuildingDES)
	Local $TypeBuildingName

	; USES OLD OPENCV DETECTION
	_CaptureRegion2(230, 170, 630, 440)
	Switch $TypeBuilding
		Case $eSideBuildingDES
			$TypeBuildingName = "DE Storage"
			$g_iBuildingToLoc = GetLocationDarkElixirStorage()
		Case $eSideBuildingTH
			$TypeBuildingName = "TownHall"
			$g_iBuildingToLoc = GetLocationTownHall()
	EndSwitch

	Local $pixel
	If (UBound($g_iBuildingToLoc) > 1) Then
		Local $centerPixel[2] = [430, 313]
		Local $arrPixelCloser = _FindPixelCloser($g_iBuildingToLoc, $centerPixel, 1)
		$pixel = $arrPixelCloser[0]
	ElseIf (UBound($g_iBuildingToLoc) > 0) Then
		$pixel = $g_iBuildingToLoc[0]
	Else
		$pixel = -1
	EndIf

	If $pixel = -1 Then
		$g_iBuildingLoc = 0
		SetLog(" == " & $TypeBuildingName & " Not Found ==")
	Else
		$pixel[0] += 230 ; compensate CaptureRegion reduction
		$pixel[1] += 170 ; compensate CaptureRegion reduction
		SetLog("== " & $TypeBuildingName & " : [" & $pixel[0] & "," & $pixel[1] & "] ==", $COLOR_INFO)
		If _Sleep(1000) Then Return False
		$g_iBuildingLocX = $pixel[0] ; compensation for $x center
		$g_iBuildingLocY = $pixel[1] ; compensation for $y center
		$g_iBuildingLoc = 1
	EndIf
EndFunc   ;==>BuildingXY

Func DELow()
	Local $DarkE = ""
	Local $Dchk = 0
	While $DarkE = "" ;~~~~~~~~Loop 10x or until Dark Elixer is Readable.
		$DarkE = getDarkElixirVillageSearch(48, 126)
		$Dchk += 1
		If _Sleep(50) Then Return
		If $Dchk >= 10 Then
			SetLog("Can't find De", $COLOR_ERROR)
			Return False
		EndIf
	WEnd
	If Number($DarkE) < (Number($g_iSearchDark) * (Number($g_iDESideEndMin) / 100)) Then ; First check if Dark Elixer is below set minimum
		If _Sleep(50) Then Return
		$DarkE = getDarkElixirVillageSearch(48, 126)
		If _Sleep(50) Then Return
		If Number($DarkE) < (Number($g_iSearchDark) * (Number($g_iDESideEndMin) / 100)) Then ; Second check if Dark Elixer is below set minimum
			If $g_bDESideEndAQWeak And $g_bDropQueen And Not $g_bCheckQueenPower Then
				If $g_iActivateQueen = 0 Then
					$g_iDarkLow = 1
					SetLog("Low De. De = ( " & $DarkE & " ) and AQ health Low. Return to protect Heroes.  Returning immediately", $COLOR_SUCCESS)
					Return False
				ElseIf Not _ColorCheck(_GetPixelColor(68 + (72 * $g_iQueenSlot), 572, True), Hex(0x72F50B, 6), 120, "Heroes") Then
					$g_iDarkLow = 1
					SetLog("Low De. De = ( " & $DarkE & " ) and AQ health Low. Return to protect Heroes.  Returning immediately", $COLOR_SUCCESS)
					Return False
				EndIf
			EndIf
			If $g_bDESideEndBKWeak And $g_bDropKing And Not $g_bCheckKingPower Then
				If $g_iActivateKing = 0 Then
					$g_iDarkLow = 1
					SetLog("Low De. De = ( " & $DarkE & " ) and BK health Low. Return to protect Heroes.  Returning immediately", $COLOR_SUCCESS)
					Return False
				ElseIf Not _ColorCheck(_GetPixelColor(68 + (72 * $g_iKingSlot), 572, True), Hex(0x4FD404, 6), 120, "Heroes") Then
					$g_iDarkLow = 1
					SetLog("Low De. De = ( " & $DarkE & " ) and BK health Low. Return to protect Heroes.  Returning immediately", $COLOR_SUCCESS)
					Return False
				EndIf
			EndIf
			If $g_bDESideEndOneStar Then
				If _ColorCheck(_GetPixelColor($aWonOneStar[0], $aWonOneStar[1], True), Hex($aWonOneStar[2], 6), $aWonOneStar[3]) Then
					SetLog("Low De. De = ( " & $DarkE & " ) and 1 star achieved. Return to protect Heroes.  Returning immediately", $COLOR_SUCCESS)
					$g_iDarkLow = 1
					Return False
				Else
					SetLog("Low De. ( " & $DarkE & " ) Waiting for 1 star", $COLOR_SUCCESS)
					$g_iDarkLow = 2
					Return False
				EndIf
			EndIf
			If Not $g_bDESideEndAQWeak And Not $g_bDESideEndBKWeak And Not $g_bDESideEndOneStar Then
				SetLog("Low De. De = ( " & $DarkE & " ). Return to protect Heroes.  Returning immediately", $COLOR_SUCCESS)
				Return False
			EndIf
		EndIf
	Else
		$g_iDarkLow = 0
	EndIf
EndFunc   ;==>DELow

Func SaveandDisableEBO()
	$g_abSaveichkEndOneStar[$g_iMatchMode] = $g_abStopAtkOneStar[$g_iMatchMode]
	$g_abSaveichkEndTwoStars[$g_iMatchMode] = $g_abStopAtkTwoStars[$g_iMatchMode]
	$g_abSaveiChkTimeStopAtk[$g_iMatchMode] = $g_abStopAtkNoLoot1Enable[$g_iMatchMode]
	$g_abSaveiChkTimeStopAtk2[$g_iMatchMode] = $g_abStopAtkNoLoot2Enable[$g_iMatchMode]
	$g_abStopAtkOneStar[$g_iMatchMode] = 0
	$g_abStopAtkTwoStars[$g_iMatchMode] = 0
	$g_abStopAtkNoLoot1Enable[$g_iMatchMode] = 0
	$g_abStopAtkNoLoot2Enable[$g_iMatchMode] = 0
EndFunc   ;==>SaveandDisableEBO

Func RevertEBO()
	$g_abStopAtkOneStar[$g_iMatchMode] = $g_abSaveichkEndOneStar
	$g_abStopAtkTwoStars[$g_iMatchMode] = $g_abSaveichkEndTwoStars
	$g_abStopAtkNoLoot1Enable[$g_iMatchMode] = $g_abSaveiChkTimeStopAtk
	$g_abStopAtkNoLoot2Enable[$g_iMatchMode] = $g_abSaveiChkTimeStopAtk2
EndFunc   ;==>RevertEBO

