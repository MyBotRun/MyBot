; #FUNCTION# ====================================================================================================================
; Name ..........: Laboratory
; Description ...:
; Syntax ........: Laboratory()
; Parameters ....:
; Return values .: None
; Author ........: summoner
; Modified ......: KnowJack (June2015) Sardo 2015-08, Monkeyhunter(2106-2,2016-4)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global Const $sColorNA = Hex(0xD3D3CB, 6) ; relative location: 47,6; Troop not unlocked in Lab, beige pixel in center just below edge for troop
Global Const $sColorNoLoot = Hex(0xFD877E, 6) ; relative location: 68,79 & 68,84; Not enough loot available to upgrade, find pink pixel in value
Global Const $sColorMaxLvl = Hex(0xFFFFFF, 6) ; relative location: 77,77 & 77,82; Upgrade already at MAX level, white in last "l"
Global Const $sColorNotPossible = Hex(0xC0C0C0, 6) ; relative location: 3,19, upgrade not possible
Global Const $sColorMaxTroop = Hex(0xFFC360, 6) ; relative location: 23,60; troop already MAX

Func Laboratory()

	;Create local static array to hold upgrade values
	Static $aUpgradeValue[30] = [-1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	Local $iAvailElixir, $iAvailDark, $sElixirCount, $sDarkCount, $TimeDiff, $aArray, $Result

	$g_iUpgradeMinElixir = Number($g_iUpgradeMinElixir)
	$g_iUpgradeMinDark = Number($g_iUpgradeMinDark)

	$g_iLaboratoryElixirCost = 0
	If Not $g_bAutoLabUpgradeEnable Then Return ; Lab upgrade not enabled.

	If $g_iCmbLaboratory = 0 Then
		SetLog("Laboratory enabled, but no troop upgrade selected", $COLOR_WARNING)
		Return False ; Nothing selected to upgrade
	EndIf
	If $g_aiLaboratoryPos[0] = 0 Or $g_aiLaboratoryPos[1] = 0 Then
		SetLog("Laboratory Location not found!", $COLOR_ERROR)
		LocateLab() ; Lab location unknown, so find it.
		If $g_aiLaboratoryPos[0] = 0 Or $g_aiLaboratoryPos[1] = 0 Then
			SetLog("Problem locating Laboratory, train laboratory position before proceeding", $COLOR_ERROR)
			Return False
		EndIf
	EndIf

	If $g_sLabUpgradeTime <> "" Then $TimeDiff = _DateDiff("n", _NowCalc(), $g_sLabUpgradeTime) ; what is difference between end time and now in minutes?
	If @error Then _logErrorDateDiff(@error)
	If $g_bDebugSetlog Then SetDebugLog($g_avLabTroops[$g_iCmbLaboratory][3] & " Lab end time: " & $g_sLabUpgradeTime & ", DIFF= " & $TimeDiff, $COLOR_DEBUG)

	If Not $g_bRunState Then Return
	If $TimeDiff <= 0 Then
		SetLog("Checking Troop Upgrade in Laboratory ...", $COLOR_INFO)
	Else
		SetLog("Laboratory Upgrade in progress, waiting for completion", $COLOR_INFO)
		Return False
	EndIf

	; Get updated village elixir and dark elixir values
	If _CheckPixel($aVillageHasDarkElixir, $g_bCapturePixel) Then ; check if the village have a Dark Elixir Storage
		$sElixirCount = getResourcesMainScreen(696, 74)
		$sDarkCount = getResourcesMainScreen(728, 123)
		SetLog("Updating village values [E]: " & $sElixirCount & " [D]: " & $sDarkCount, $COLOR_SUCCESS)
	Else
		$sElixirCount = getResourcesMainScreen(701, 74)
		SetLog("Updating village values [E]: " & $sElixirCount, $COLOR_SUCCESS)
	EndIf
	$iAvailElixir = Number($sElixirCount)
	$iAvailDark = Number($sDarkCount)

	BuildingClickP($g_aiLaboratoryPos, "#0197") ;Click Laboratory

	If _Sleep($DELAYLABORATORY3) Then Return ; Wait for window to open
	; Find Research Button
	Local $offColors[4][3] = [[0x708CB0, 37, 34], [0x603818, 50, 43], [0xD5FC58, 61, 8], [0x000000, 82, 0]] ; 2nd pixel Blue blade, 3rd pixel brown handle, 4th pixel Green cross, 5th black button edge
	Local $ButtonPixel = _MultiPixelSearch(433, 565 + $g_iBottomOffsetY, 562, 619 + $g_iBottomOffsetY, 1, 1, Hex(0x000000, 6), $offColors, 30) ; Black pixel of button edge
	If IsArray($ButtonPixel) Then
		If $g_bDebugSetlog Then
			SetDebugLog("ButtonPixel = " & $ButtonPixel[0] & ", " & $ButtonPixel[1], $COLOR_DEBUG) ;Debug
			SetDebugLog("#1: " & _GetPixelColor($ButtonPixel[0], $ButtonPixel[1], True) & ", #2: " & _GetPixelColor($ButtonPixel[0] + 37, $ButtonPixel[1] + 34, True) & ", #3: " & _GetPixelColor($ButtonPixel[0] + 50, $ButtonPixel[1] + 43, True) & ", #4: " & _GetPixelColor($ButtonPixel[0] + 61, $ButtonPixel[1] + 8, True), $COLOR_DEBUG)
		EndIf
		If $g_bDebugImageSave Then DebugImageSave("LabUpgrade") ; Debug Only
		Click($ButtonPixel[0] + 40, $ButtonPixel[1] + 25, 1, 0, "#0198") ; Click Research Button
		If _Sleep($DELAYLABORATORY1) Then Return ; Wait for window to open
	Else
		SetLog("Trouble finding research button, try again...", $COLOR_WARNING)
		ClickP($aAway, 2, $DELAYLABORATORY4, "#0199")
		Return False
	EndIf

	If $g_bDebugSetlog Then LabTroopImages1() ; Debug Only

	If $g_iFirstTimeLab = 0 Then ; Need to get upgrade value for troops on page 1, only do this on 1st cycle of function
		For $i = 1 To 10
			$aUpgradeValue[$i] = getLabUpgrdResourceRed($g_avLabTroops[$i][0] + 13, $g_avLabTroops[$i][1] + 74)
			If $g_bDebugSetlog Then SetDebugLog($g_avLabTroops[$i][3] & " Red text upgrade value = " & $aUpgradeValue[$i], $COLOR_DEBUG)
			If $aUpgradeValue[$i] = "" Or $aUpgradeValue[$i] < 49999 Then ; check if blank or below min value for any upgrade on page 1
				$aUpgradeValue[$i] = getLabUpgrdResourceWht($g_avLabTroops[$i][0] + 13, $g_avLabTroops[$i][1] + 74)
				If $g_bDebugSetlog Then SetDebugLog($g_avLabTroops[$i][3] & " White text upgrade value = " & $aUpgradeValue[$i], $COLOR_DEBUG)
			EndIf
			If $aUpgradeValue[$i] = "" Or $aUpgradeValue[$i] < 49999 Then ; check if blank or below min value for any upgrade on page 1
				If _ColorCheck(_GetPixelColor($g_avLabTroops[$i][0] + 77, $g_avLabTroops[$i][1] + 77, True), $sColorMaxLvl, 20) And _ColorCheck(_GetPixelColor($g_avLabTroops[$i][0] + 77, $g_avLabTroops[$i][1] + 82, True), $sColorMaxLvl, 20) Then
					$aUpgradeValue[$i] = -1
					If $g_bDebugSetlog Then SetDebugLog($g_avLabTroops[$i][3] & " Is Maxed already, now = " & $aUpgradeValue[$i], $COLOR_DEBUG)
				EndIf
			EndIf
			If Not $g_bRunState Then Return
		Next
		$g_iFirstTimeLab = 1
	EndIf

	If $g_avLabTroops[$g_iCmbLaboratory][2] >= 1 Then ;Check if troop located on page 2 of lab window and Move to three icon squares to get spells
		;_PostMessage_ClickDrag(650, 423 + $g_iMidOffsetY, 545, 423 + $g_iMidOffsetY, "left", 1000)
		ClickDrag(650, 443 + $g_iMidOffsetY, 323, 443 + $g_iMidOffsetY, 1000)
		;_PostMessage_ClickDrag(734, 393, 643, 393, "left", 1500)
		If _Sleep($DELAYLABORATORY3) Then Return
		If $g_bDebugSetlog Then LabTroopImages2() ; Debug Only
		If $g_iFirstTimeLab < 2 Then
			For $i = 11 To 18
				$aUpgradeValue[$i] = getLabUpgrdResourceRed($g_avLabTroops[$i][0] + 13, $g_avLabTroops[$i][1] + 74)
				If $g_bDebugSetlog Then SetDebugLog($g_avLabTroops[$i][3] & " Red text upgrade value = " & $aUpgradeValue[$i], $COLOR_DEBUG)
				If $aUpgradeValue[$i] = "" Or $aUpgradeValue[$i] < 9999 Then ; check if blank or below min value for any upgrade on page 2
					$aUpgradeValue[$i] = getLabUpgrdResourceWht($g_avLabTroops[$i][0] + 13, $g_avLabTroops[$i][1] + 74)
					If $g_bDebugSetlog Then SetDebugLog($g_avLabTroops[$i][3] & " White text upgrade value = " & $aUpgradeValue[$i], $COLOR_DEBUG)
				EndIf
				If $aUpgradeValue[$i] = "" Or $aUpgradeValue[$i] < 9999 Then ; check if blank or below min value for any upgrade on page 2
					If _ColorCheck(_GetPixelColor($g_avLabTroops[$i][0] + 77, $g_avLabTroops[$i][1] + 77, True), $sColorMaxLvl, 20) And _ColorCheck(_GetPixelColor($g_avLabTroops[$i][0] + 77, $g_avLabTroops[$i][1] + 82, True), $sColorMaxLvl, 20) Then
						$aUpgradeValue[$i] = -1
						If $g_bDebugSetlog Then SetDebugLog($g_avLabTroops[$i][3] & " Is Maxed already, $aUpgradeValue now = " & $aUpgradeValue[$i], $COLOR_DEBUG)
					EndIf
				EndIf
				If Not $g_bRunState Then Return
			Next
			$g_iFirstTimeLab += 2
		EndIf
	EndIf

	If $g_avLabTroops[$g_iCmbLaboratory][2] = 2 Then ;Check if troop located on next page of lab window and Move to page for upgrade values
		;_PostMessage_ClickDrag(734, 423 + $g_iMidOffsetY, 3, 423 + $g_iMidOffsetY, "left", 2000)
		ClickDrag(734, 443 + $g_iMidOffsetY, 3, 443 + $g_iMidOffsetY, 2000)
		;_PostMessage_ClickDrag(734, 393, 643, 393, "left", 1500)
		If _Sleep($DELAYLABORATORY3) Then Return
		If $g_bDebugSetlog Then LabTroopImages3() ; Debug Only
		If $g_iFirstTimeLab < 4 Then
			For $i = 19 To 29
				$aUpgradeValue[$i] = getLabUpgrdResourceRed($g_avLabTroops[$i][0] + 13, $g_avLabTroops[$i][1] + 74)
				If $g_bDebugSetlog Then SetDebugLog($g_avLabTroops[$i][3] & " Red text upgrade value = " & $aUpgradeValue[$i], $COLOR_DEBUG)
				If $aUpgradeValue[$i] = "" Or $aUpgradeValue[$i] < 9999 Then ; check if blank or below min value for any upgrade on page 2
					$aUpgradeValue[$i] = getLabUpgrdResourceWht($g_avLabTroops[$i][0] + 13, $g_avLabTroops[$i][1] + 74)
					If $g_bDebugSetlog Then SetDebugLog($g_avLabTroops[$i][3] & " White text upgrade value = " & $aUpgradeValue[$i], $COLOR_DEBUG)
				EndIf
				If $aUpgradeValue[$i] = "" Or $aUpgradeValue[$i] < 9999 Then ; check if blank or below min value for any upgrade on page 2
					If _ColorCheck(_GetPixelColor($g_avLabTroops[$i][0] + 77, $g_avLabTroops[$i][1] + 77, True), $sColorMaxLvl, 20) And _ColorCheck(_GetPixelColor($g_avLabTroops[$i][0] + 77, $g_avLabTroops[$i][1] + 82, True), $sColorMaxLvl, 20) Then
						$aUpgradeValue[$i] = -1
						If $g_bDebugSetlog Then SetDebugLog($g_avLabTroops[$i][3] & " Is Maxed already, $aUpgradeValue now = " & $aUpgradeValue[$i], $COLOR_DEBUG)
					EndIf
				EndIf
				If Not $g_bRunState Then Return
			Next
			$g_iFirstTimeLab += 4
		EndIf
	EndIf

	; Track Elixir cost for Wall Upgrade check
	Switch $g_iCmbLaboratory
		Case 1 To 18 ; regular elixir
			If $aUpgradeValue[$g_iCmbLaboratory] > 0 Then $g_iLaboratoryElixirCost = $aUpgradeValue[$g_iCmbLaboratory]
	EndSwitch

	; check for upgrade in process - look for green in finish upgrade with gems button
	If _ColorCheck(_GetPixelColor(625, 266 + $g_iMidOffsetY, True), Hex(0x6CB91D, 6), 20) Or _ColorCheck(_GetPixelColor(660, 266 + $g_iMidOffsetY, True), Hex(0x6CB91D, 6), 20) Then
		SetLog("Upgrade in progress, waiting for completion of other troops", $COLOR_INFO)
		If _Sleep($DELAYLABORATORY2) Then Return
		; upgrade in process and time not recorded?  Then update completion time!
		If $g_sLabUpgradeTime = "" Or $TimeDiff <= 0 Then
			$Result = getRemainTLaboratory(270, 257) ; Try to read white text showing actual time left for upgrade
			If $g_bDebugSetlog Then SetDebugLog($g_avLabTroops[$g_iCmbLaboratory][3] & " OCR Remaining Lab Time = " & $Result, $COLOR_DEBUG)
			$aArray = StringSplit($Result, ' ', BitOR($STR_CHRSPLIT, $STR_NOCOUNT)) ;separate days, hours, minutes, seconds
			If IsArray($aArray) Then
				Local $iRemainingTimeMin = 0
				For $i = 0 To UBound($aArray) - 1 ; step through array and compute minutes remaining
					Local $sTime = ""
					Select
						Case StringInStr($aArray[$i], "d", $STR_NOCASESENSEBASIC) > 0
							$sTime = StringTrimRight($aArray[$i], 1) ; removing the "d"
							$iRemainingTimeMin += (Int($sTime) * 24 * 60) ; change days to minutes and add
						Case StringInStr($aArray[$i], "h", $STR_NOCASESENSEBASIC) > 0
							$sTime = StringTrimRight($aArray[$i], 1) ; removing the "h"
							$iRemainingTimeMin += (Int($sTime) * 60) ; change hours to minutes and add
						Case StringInStr($aArray[$i], "m", $STR_NOCASESENSEBASIC) > 0
							$sTime = StringTrimRight($aArray[$i], 1) ; removing the "m"
							$iRemainingTimeMin += Int($sTime) ; add minutes
						Case StringInStr($aArray[$i], "s", $STR_NOCASESENSEBASIC) > 0
							$sTime = StringTrimRight($aArray[$i], 1) ; removing the "s"
							$iRemainingTimeMin += Int($sTime) / 60 ; Add seconds
						Case Else
							SetLog("Remaining lab time OCR invalid:" & $aArray[$i], $COLOR_WARNING)
							ClickP($aAway, 2, $DELAYLABORATORY4, "#0328")
							Return False
					EndSelect
					If $g_bDebugSetlog Then SetDebugLog("Remain Lab Time: " & $aArray[$i] & ", Minutes= " & $iRemainingTimeMin, $COLOR_DEBUG)
				Next
				$g_sLabUpgradeTime = _DateAdd('n', Ceiling($iRemainingTimeMin), _NowCalc()) ; add the time required to NOW to finish the upgrade
				If @error Then _logErrorDateAdd(@error)
				SetLog("Updated Lab finishing time: " & $g_sLabUpgradeTime, $COLOR_SUCCESS)
				LabStatusGUIUpdate() ; Update GUI flag
			Else
				If $g_bDebugSetlog Then SetDebugLog("Invalid getRemainTLaboratory OCR", $COLOR_DEBUG)
			EndIf
		EndIf
		ClickP($aAway, 2, $DELAYLABORATORY4, "#0328")
		Return False
	EndIf

	If $aUpgradeValue[$g_iCmbLaboratory] = -1 Then
		SetLog($g_avLabTroops[$g_iCmbLaboratory][3] & " already max level, select another troop", $COLOR_ERROR)
		ClickP($aAway, 2, $DELAYLABORATORY4, "#0353")
		Return False
	EndIf
	If $aUpgradeValue[$g_iCmbLaboratory] = 0 Then
		If _ColorCheck(_GetPixelColor($g_avLabTroops[$g_iCmbLaboratory][0] + 3, $g_avLabTroops[$g_iCmbLaboratory][1] + 19, True), Hex(0xC0C0C0, 6), 25) = True Then
			; Look for Gray pixel inside left border if Lab upgrade required, also matches troop not available in lab with v7.2 game update
			SetLog("Lab upgrade not available for " & $g_avLabTroops[$g_iCmbLaboratory][3] & ", Pick different troop!", $COLOR_ERROR)
			If _Sleep($DELAYLABUPGRADE2) Then Return
		Else
			SetLog($g_avLabTroops[$g_iCmbLaboratory][3] & " value read error, close bot and try again!", $COLOR_ERROR)
		EndIf
		$g_iFirstTimeLab = 2 ; reset value read flag in case use does not restart bot.
		ClickP($aAway, 2, $DELAYLABORATORY4, "#0354")
		Return False
	EndIf
	Switch $g_iCmbLaboratory ;Change messaging based on troop number
		Case 1 To 18 ; regular elixir
			If $iAvailElixir < ($aUpgradeValue[$g_iCmbLaboratory] + $g_iUpgradeMinElixir) Then
				SetLog("Insufficent Elixir for " & $g_avLabTroops[$g_iCmbLaboratory][3] & ", Lab requires: " & $aUpgradeValue[$g_iCmbLaboratory] & " + " & $g_iUpgradeMinElixir & " user reserve, available: " & $iAvailElixir, $COLOR_INFO)
				ClickP($aAway, 2, $DELAYLABORATORY4, "#0355")
				Return False
			EndIf
			If LabUpgrade() = True Then
				SetLog("Elixir used = " & $aUpgradeValue[$g_iCmbLaboratory], $COLOR_INFO)
				ClickP($aAway, 2, $DELAYLABORATORY4, "#0356")
				Return True
			EndIf

		Case 19 To 29 ; Dark Elixir
			If $iAvailDark < $aUpgradeValue[$g_iCmbLaboratory] + $g_iUpgradeMinDark Then
				SetLog("Insufficent Dark Elixir for " & $g_avLabTroops[$g_iCmbLaboratory][3] & ", Lab requires: " & $aUpgradeValue[$g_iCmbLaboratory] & " + " & $g_iUpgradeMinDark & " user reserve, available: " & $iAvailDark, $COLOR_INFO)
				ClickP($aAway, 2, $DELAYLABORATORY4, "#0357")
				Return False
			EndIf
			If LabUpgrade() = True Then
				SetLog("Dark Elixir used = " & $aUpgradeValue[$g_iCmbLaboratory], $COLOR_INFO)
				ClickP($aAway, 2, $DELAYLABORATORY4, "#0358")
				Return True
			EndIf

		Case Else
			SetLog("Something went wrong with loot value on Lab upgrade on #" & $g_avLabTroops[$g_iCmbLaboratory][3], $COLOR_ERROR)
			Return False
	EndSwitch

	ClickP($aAway, 2, $DELAYLABORATORY4, "#0359")
	Return False

EndFunc   ;==>Laboratory
;
Func LabUpgrade()
	Local $StartTime, $EndTime, $EndPeriod, $Result, $TimeAdd = 0
	Select
		Case _ColorCheck(_GetPixelColor($g_avLabTroops[$g_iCmbLaboratory][0] + 47, $g_avLabTroops[$g_iCmbLaboratory][1] + 6, True), $sColorNA, 20) = True
			; check for beige pixel in center just below edge for troop not unlocked
			SetLog($g_avLabTroops[$g_iCmbLaboratory][3] & " not unlocked yet, select another troop", $COLOR_ERROR)
			If _Sleep($DELAYLABUPGRADE2) Then Return

		Case _PixelSearch($g_avLabTroops[$g_iCmbLaboratory][0] + 67, $g_avLabTroops[$g_iCmbLaboratory][1] + 79, $g_avLabTroops[$g_iCmbLaboratory][0] + 69, $g_avLabTroops[$g_iCmbLaboratory][0] + 84, $sColorNoLoot, 20) <> 0
			; Check for Pink pixels last zero of loot value to see if enough loot is available.
			; this case should never be run if value check is working right!
			SetLog("Value check error and Not enough Loot to upgrade " & $g_avLabTroops[$g_iCmbLaboratory][3] & "...", $COLOR_ERROR)
			If _Sleep($DELAYLABUPGRADE2) Then Return

		Case _ColorCheck(_GetPixelColor($g_avLabTroops[$g_iCmbLaboratory][0] + 22, $g_avLabTroops[$g_iCmbLaboratory][1] + 60, True), Hex(0xFFC360, 6), 20) = True
			; Look for Golden pixel inside level indicator for max troops
			SetLog($g_avLabTroops[$g_iCmbLaboratory][3] & " already max level, select another troop", $COLOR_ERROR)
			If _Sleep($DELAYLABUPGRADE2) Then Return

		Case _ColorCheck(_GetPixelColor($g_avLabTroops[$g_iCmbLaboratory][0] + 3, $g_avLabTroops[$g_iCmbLaboratory][1] + 19, True), Hex(0xB7B7B7, 6), 20) = True
			; Look for Gray pixel inside left border if Lab upgrade required or if we missed that upgrade is in process
			SetLog("Laboratory upgrade not available now for " & $g_avLabTroops[$g_iCmbLaboratory][3] & "...", $COLOR_ERROR)
			If _Sleep($DELAYLABUPGRADE2) Then Return

		Case Else
			; If none of other error conditions apply, begin upgrade process
			Click($g_avLabTroops[$g_iCmbLaboratory][0] + 40, $g_avLabTroops[$g_iCmbLaboratory][1] + 40, 1, 0, "#0200") ; Click Upgrade troop button
			If _Sleep($DELAYLABUPGRADE1) Then Return ; Wait for window to open
			If $g_bDebugImageSave Then DebugImageSave("LabUpgrade")

			; double check if maxed?
			If _ColorCheck(_GetPixelColor(258, 192, True), Hex(0xFF1919, 6), 20) And _ColorCheck(_GetPixelColor(272, 194, True), Hex(0xFF1919, 6), 20) Then
				SetLog($g_avLabTroops[$g_iCmbLaboratory][3] & " Previously maxxed, select another troop", $COLOR_ERROR) ; oops, we found the red warning message
				If _Sleep($DELAYLABUPGRADE2) Then Return
				ClickP($aAway, 2, $DELAYLABUPGRADE3, "#0201")
				Return False
			EndIf

			; double check enough elixir?
			If _PixelSearch($g_avLabTroops[$g_iCmbLaboratory][0] + 67, $g_avLabTroops[$g_iCmbLaboratory][1] + 79, $g_avLabTroops[$g_iCmbLaboratory][0] + 69, $g_avLabTroops[$g_iCmbLaboratory][0] + 84, $sColorNoLoot, 20) <> 0 Then ; Check for Red Zero = means not enough loot!
				SetLog("Missing Loot to upgrade " & $g_avLabTroops[$g_iCmbLaboratory][3] & " (secondary check after Upgrade Value read failed)", $COLOR_ERROR)
				If _Sleep($DELAYLABUPGRADE2) Then Return
				ClickP($aAway, 2, $DELAYLABUPGRADE3, "#0333")
				Return False
			EndIf

			; triple check for upgrade in process by gray upgrade button
			If _ColorCheck(_GetPixelColor(625, 250 + $g_iMidOffsetY, True), Hex(0x848484, 6), 20) And _ColorCheck(_GetPixelColor(660, 250 + $g_iMidOffsetY, True), Hex(0x848484, 6), 20) Then
				SetLog("Upgrade in progress, waiting for completion of other troops", $COLOR_WARNING)
				If _Sleep($DELAYLABORATORY2) Then Return
				ClickP($aAway, 2, $DELAYLABORATORY4, "#0000")
				Return False
			Else
				; get upgrade time from window
				$Result = getLabUpgradeTime(481, 557) ; Try to read white text showing time for upgrade
				SetLog($g_avLabTroops[$g_iCmbLaboratory][3] & " Upgrade OCR Time = " & $Result, $COLOR_INFO)
				$StartTime = _NowCalc() ; what is date:time now
				If $g_bDebugSetlog Then SetDebugLog($g_avLabTroops[$g_iCmbLaboratory][3] & "Upgrade Started @ " & $StartTime, $COLOR_SUCCESS)
				; Compute upgrade end time
				$EndTime = ""
				$EndPeriod = ""
				$TimeAdd = 0
				$g_sLabUpgradeTime = StringStripWS($Result, $STR_STRIPALL)
				Local $aArray = StringRegExp($g_sLabUpgradeTime, '\d+', $STR_REGEXPARRAYMATCH)
				If IsArray($aArray) Then
					If $g_bDebugSetlog Then ; debug - display array value
						For $i = 0 To UBound($aArray) - 1
							SetLog("UpgradeTime $aArray[" & $i & "] = " & $aArray[$i])
						Next
					EndIf
					$EndTime = $aArray[0]
					$EndPeriod = StringReplace($g_sLabUpgradeTime, $EndTime, "")
					Switch $EndPeriod
						Case "d"
							$TimeAdd = (Int($EndTime) * 24 * 60) - 10 ; change days to minutes, minus 10 minute
							$g_sLabUpgradeTime = _DateAdd('n', $TimeAdd, $StartTime) ; add the time required to finish the  upgrade
						Case "h"
							$TimeAdd = (Int($EndTime) * 60) - 3 ; change hours to minutes, minus 3 minutes
							$g_sLabUpgradeTime = _DateAdd('n', $TimeAdd, $StartTime) ; add the time required to finish the  upgrade
						Case "m"
							$TimeAdd = Int($EndTime) ; change to minutes
							$g_sLabUpgradeTime = _DateAdd('n', $TimeAdd, $StartTime) ; add the time required to finish the  upgrade
						Case Else
							SetLog("Upgrade time period invalid, try again!", $COLOR_WARNING)
					EndSwitch
					If $g_bDebugSetlog Then SetDebugLog("$EndTime = " & $EndTime & " , $EndPeriod = " & $EndPeriod & ", $timeadd = " & $TimeAdd, $COLOR_DEBUG)
					SetLog($g_avLabTroops[$g_iCmbLaboratory][3] & "Upgrade Finishes @ " & $g_sLabUpgradeTime, $COLOR_SUCCESS)
				Else
					SetLog("Error reading the upgrade time required, try again!", $COLOR_WARNING)
				EndIf
				If _DateIsValid($g_sLabUpgradeTime) = 0 Then ; verify success of StringRegExp to process upgrade date/time
					SetLog("Error processing upgrade time required, try again!", $COLOR_WARNING)
					Return False
				Else
					Local $txtTip = GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_01", "Visible Red button means that laboratory upgrade in process") & @CRLF & _
							GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_02", "This will automatically disappear when near time for upgrade to be completed.") & @CRLF & _
							GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_03", "If upgrade has been manually finished with gems before normal end time,") & @CRLF & _
							GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_04", "Click red button to reset internal upgrade timer BEFORE STARTING NEW UPGRADE") & @CRLF & _
							GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_05", "Caution - Unnecessary timer reset will force constant checks for lab status") & @CRLF & @CRLF & _
							GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_06", "Troop Upgrade started") & ": " & $StartTime & ", " & _
							GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_07", "Will begin to check completion at:") & " " & $g_sLabUpgradeTime & @CRLF & " "
					_GUICtrlSetTip($g_hBtnResetLabUpgradeTime, $txtTip)
				EndIf

				Click(660, 520 + $g_iMidOffsetY, 1, 0, "#0202") ; Everything is good - Click the upgrade button
				If _Sleep($DELAYLABUPGRADE1) Then Return
			EndIf

			If isGemOpen(True) = False Then ; check for gem window
				; check for green button to use gems to finish upgrade, checking if upgrade actually started
				If Not (_ColorCheck(_GetPixelColor(625, 266 + $g_iMidOffsetY, True), Hex(0x6CB91D, 6), 20) Or _ColorCheck(_GetPixelColor(660, 266 + $g_iMidOffsetY, True), Hex(0x6CB91D, 6), 20)) Then
					SetLog("Something went wrong with " & $g_avLabTroops[$g_iCmbLaboratory][3] & " Upgrade, try again.", $COLOR_ERROR)
					ClickP($aAway, 2, $DELAYLABUPGRADE3, "#0360")
					Return False
				EndIf
				SetLog("Upgrade " & $g_avLabTroops[$g_iCmbLaboratory][3] & " in your laboratory is complete...", $COLOR_SUCCESS)
				PushMsg("LabSuccess")
				If _Sleep($DELAYLABUPGRADE2) Then Return
				$g_bAutoLabUpgradeEnable = False ;reset enable lab upgrade flag
				GUICtrlSetState($g_hChkAutoLabUpgrades, $GUI_UNCHECKED) ; reset enable lab upgrade check box

				ClickP($aAway, 2, 0, "#0204")

				Return True
			Else
				SetLog("Oops, Gems required for " & $g_avLabTroops[$g_iCmbLaboratory][3] & " Upgrade, try again.", $COLOR_ERROR)
			EndIf
	EndSelect
	ClickP($aAway, 2, $DELAYLABUPGRADE3, "#0205")
	Return False

EndFunc   ;==>LabUpgrade

Func DebugRegionSave($sTxtName = "Unknown", $iLeft = 0, $iTop = 0, $iRight = $g_iDEFAULT_WIDTH, $iBottom = $g_iDEFAULT_HEIGHT)

	; Debug Code to save images before zapping for later review, time stamped to align with logfile!
	SetLog("Taking debug snapshot for later review", $COLOR_SUCCESS) ;Debug purposes only :)
	Local $Date = @MDAY & "_" & @MON & "_" & @YEAR
	Local $Time = @HOUR & "_" & @MIN & "_" & @SEC
	Local $sName =  $g_sProfileTempDebugPath & "LabUpgrade\" & $sTxtName & "_" & $Date & "_" & $Time & ".png"
	DirCreate($g_sProfileTempDebugPath & "LabUpgrade\")
	ForceCaptureRegion()
	_CaptureRegion($iLeft, $iTop, $iRight, $iBottom)
	_GDIPlus_ImageSaveToFile($g_hBitmap, $sName)
	If @error Then SetLog("DebugRegionSave failed to save LabUpgrade image: " & $sName, $COLOR_WARNING)
	If _Sleep($DELAYLABORATORY2) Then Return

EndFunc   ;==>DebugRegionSave

Func LabTroopImages1() ; Debug function to record pixel values for page 1 of lab troop window
	If $g_bDebugImageSave Then DebugImageSave("LabUpgrade")
	For $i = 1 To 10
		DebugRegionSave($g_avLabTroops[$i][3], $g_avLabTroops[$i][0], $g_avLabTroops[$i][1], $g_avLabTroops[$i][0] + 98, $g_avLabTroops[$i][1] + 98)
		SetLog($g_avLabTroops[$i][3], $COLOR_WARNING)
		SetLog("_GetPixelColor(+47, +6): " & _GetPixelColor($g_avLabTroops[$i][0] + 47, $g_avLabTroops[$i][1] + 6, True) & ":D3D3CB =Not unlocked", $COLOR_DEBUG)
		SetLog("_GetPixelColor(+68, +79): " & _GetPixelColor($g_avLabTroops[$i][0] + 68, $g_avLabTroops[$i][1] + 79, True) & ":FD877E =No Loot1", $COLOR_DEBUG)
		SetLog("_GetPixelColor(+68, +82): " & _GetPixelColor($g_avLabTroops[$i][0] + 68, $g_avLabTroops[$i][1] + 84, True) & ":FD877E =No Loot2", $COLOR_DEBUG)
		SetLog("_GetPixelColor(+81, +82): " & _GetPixelColor($g_avLabTroops[$i][0] + 81, $g_avLabTroops[$i][1] + 82, True) & ":XXXXXX =Loot type", $COLOR_DEBUG)
		SetLog("_GetPixelColor(+77, +82): " & _GetPixelColor($g_avLabTroops[$i][0] + 77, $g_avLabTroops[$i][1] + 82, True) & ":FFFFFF =Max L", $COLOR_DEBUG)
		SetLog("_GetPixelColor(+77, +77): " & _GetPixelColor($g_avLabTroops[$i][0] + 77, $g_avLabTroops[$i][1] + 77, True) & ":EFFFFF =Max L", $COLOR_DEBUG)
		SetLog("_GetPixelColor(+3, +19): " & _GetPixelColor($g_avLabTroops[$i][0] + 3, $g_avLabTroops[$i][1] + 19, True) & ":C0C0C0 =Not possible", $COLOR_DEBUG)
		SetLog("_GetPixelColor(+8, +59): " & _GetPixelColor($g_avLabTroops[$i][0] + 23, $g_avLabTroops[$i][1] + 60, True) & ":FFC360 =Max troop", $COLOR_DEBUG)
	Next
EndFunc   ;==>LabTroopImages1

Func LabTroopImages2() ; Debug function to record pixel values for page 2 of lab troop window
	If $g_bDebugImageSave Then DebugImageSave("LabUpgrade")
	For $i = 11 To 18
		DebugRegionSave($g_avLabTroops[$i][3], $g_avLabTroops[$i][0], $g_avLabTroops[$i][1], $g_avLabTroops[$i][0] + 98, $g_avLabTroops[$i][1] + 98)
		SetLog($g_avLabTroops[$i][3], $COLOR_WARNING)
		SetLog("_GetPixelColor(+47, +6): " & _GetPixelColor($g_avLabTroops[$i][0] + 47, $g_avLabTroops[$i][1] + 6, True) & ":D3D3CB =Not unlocked", $COLOR_DEBUG)
		SetLog("_GetPixelColor(+68, +79): " & _GetPixelColor($g_avLabTroops[$i][0] + 68, $g_avLabTroops[$i][1] + 79, True) & ":FD877E =No Loot1", $COLOR_DEBUG)
		SetLog("_GetPixelColor(+68, +82): " & _GetPixelColor($g_avLabTroops[$i][0] + 68, $g_avLabTroops[$i][1] + 84, True) & ":FD877E =No Loot2", $COLOR_DEBUG)
		SetLog("_GetPixelColor(+81, +82): " & _GetPixelColor($g_avLabTroops[$i][0] + 81, $g_avLabTroops[$i][1] + 82, True) & ":XXXXXX =Loot type", $COLOR_DEBUG)
		SetLog("_GetPixelColor(+77, +82): " & _GetPixelColor($g_avLabTroops[$i][0] + 77, $g_avLabTroops[$i][1] + 82, True) & ":FFFFFF =Max L", $COLOR_DEBUG)
		SetLog("_GetPixelColor(+77, +77): " & _GetPixelColor($g_avLabTroops[$i][0] + 77, $g_avLabTroops[$i][1] + 77, True) & ":EFFFFF =Max L", $COLOR_DEBUG)
		SetLog("_GetPixelColor(+3, +19): " & _GetPixelColor($g_avLabTroops[$i][0] + 3, $g_avLabTroops[$i][1] + 19, True) & ":C0C0C0 =Not possible", $COLOR_DEBUG)
		SetLog("_GetPixelColor(+8, +59): " & _GetPixelColor($g_avLabTroops[$i][0] + 23, $g_avLabTroops[$i][1] + 60, True) & ":FFC360 =Max troop", $COLOR_DEBUG)
	Next
EndFunc   ;==>LabTroopImages2

Func LabTroopImages3() ; Debug function to record pixel values for page 2 of lab troop window
	If $g_bDebugImageSave Then DebugImageSave("LabUpgrade")
	For $i = 19 To 29
		DebugRegionSave($g_avLabTroops[$i][3], $g_avLabTroops[$i][0], $g_avLabTroops[$i][1], $g_avLabTroops[$i][0] + 98, $g_avLabTroops[$i][1] + 98)
		SetLog($g_avLabTroops[$i][3], $COLOR_WARNING)
		SetLog("_GetPixelColor(+47, +6): " & _GetPixelColor($g_avLabTroops[$i][0] + 47, $g_avLabTroops[$i][1] + 6, True) & ":D3D3CB =Not unlocked", $COLOR_DEBUG)
		SetLog("_GetPixelColor(+68, +79): " & _GetPixelColor($g_avLabTroops[$i][0] + 68, $g_avLabTroops[$i][1] + 79, True) & ":FD877E =No Loot1", $COLOR_DEBUG)
		SetLog("_GetPixelColor(+68, +82): " & _GetPixelColor($g_avLabTroops[$i][0] + 68, $g_avLabTroops[$i][1] + 84, True) & ":FD877E =No Loot2", $COLOR_DEBUG)
		SetLog("_GetPixelColor(+81, +82): " & _GetPixelColor($g_avLabTroops[$i][0] + 81, $g_avLabTroops[$i][1] + 82, True) & ":XXXXXX =Loot type", $COLOR_DEBUG)
		SetLog("_GetPixelColor(+77, +82): " & _GetPixelColor($g_avLabTroops[$i][0] + 77, $g_avLabTroops[$i][1] + 82, True) & ":FFFFFF =Max L", $COLOR_DEBUG)
		SetLog("_GetPixelColor(+77, +77): " & _GetPixelColor($g_avLabTroops[$i][0] + 77, $g_avLabTroops[$i][1] + 77, True) & ":EFFFFF =Max L", $COLOR_DEBUG)
		SetLog("_GetPixelColor(+3, +19): " & _GetPixelColor($g_avLabTroops[$i][0] + 3, $g_avLabTroops[$i][1] + 19, True) & ":C0C0C0 =Not possible", $COLOR_DEBUG)
		SetLog("_GetPixelColor(+8, +59): " & _GetPixelColor($g_avLabTroops[$i][0] + 23, $g_avLabTroops[$i][1] + 60, True) & ":FFC360 =Max troop", $COLOR_DEBUG)
	Next
EndFunc   ;==>LabTroopImages3
