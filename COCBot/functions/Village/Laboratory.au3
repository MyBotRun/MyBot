; #FUNCTION# ====================================================================================================================
; Name ..........: Laboratory
; Description ...:
; Syntax ........: Laboratory()
; Parameters ....:
; Return values .: None
; Author ........: summoner
; Modified ......: KnowJack (June2015) Sardo 2015-08, Monkeyhunter(2106-2,2016-4)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func Laboratory()

	;Create local static array to hold upgrade values
	Static $aUpgradeValue[30] = [-1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	Local $iAvailElixir, $iAvailDark, $iElixirCount, $iDarkCount, $TimeDiff, $aArray, $Result
	$itxtUpgrMinElixir = Number($itxtUpgrMinElixir)
	$itxtUpgrMinDark = Number($itxtUpgrMinDark)

	$iLaboratoryElixirCost = 0
	If $ichkLab = 0 Then Return ; Lab upgrade not enabled.

	If $icmbLaboratory = 0 Then
		SetLog("Laboratory enabled, but no troop upgrade selected", $COLOR_MAROON)
		Return False ; Nothing selected to upgrade
	EndIf
	If $aLabPos[0] = 0 Or $aLabPos[1] = 0 Then
		SetLog("Laboratory Location not found!", $COLOR_RED)
		LocateLab() ; Lab location unknown, so find it.
		If $aLabPos[0] = 0 Or $aLabPos[1] = 0 Then
			SetLog("Problem locating Laboratory, train laboratory position before proceeding", $COLOR_RED)
			Return False
		EndIf
	EndIf

	If $sLabUpgradeTime <> "" Then $TimeDiff = _DateDiff("n", _NowCalc(), $sLabUpgradeTime) ; what is difference between end time and now in minutes?
	If @error Then _logErrorDateDiff(@error)
	If $debugSetlog = 1 Then SetLog($aLabTroops[$icmbLaboratory][3] & " Lab end time: " & $sLabUpgradeTime & ", DIFF= " & $TimeDiff, $COLOR_PURPLE)

	If $RunState = False Then Return
	If $TimeDiff <= 0 Then
		SetLog("Checking Troop Upgrade in Laboratory ...", $COLOR_BLUE)
	Else
		SetLog("Laboratory Upgrade in progress, waiting for completion", $COLOR_BLUE)
		Return False
	EndIf

	; Get updated village elixir and dark elixir values
	If _ColorCheck(_GetPixelColor(812, 141, True), Hex(0x000000, 6), 10) Then ; check if the village have a Dark Elixir Storage
		$iElixirCount = getResourcesMainScreen(705, 74)
		$iDarkCount = getResourcesMainScreen(728, 123)
		SetLog("Updating village values [E]: " & $iElixirCount & " [D]: " & $iDarkCount, $COLOR_GREEN)
	Else
		$iElixirCount = getResourcesMainScreen(710, 74)
		SetLog("Updating village values [E]: " & $iElixirCount, $COLOR_GREEN)
	EndIf
	$iAvailElixir = Number($iElixirCount)
	$iAvailDark = Number($iDarkCount)

	Clickp($aLabPos, 1, 0, "#0197") ;Click Laboratory

	If _Sleep($iDelayLaboratory1) Then Return ; Wait for window to open
	; Find Research Button
	Local $offColors[4][3] = [[0x708CB0, 37, 34], [0x603818, 50, 43], [0xD5FC58, 61, 8], [0x000000, 82, 0]] ; 2nd pixel Blue blade, 3rd pixel brown handle, 4th pixel Green cross, 5th black button edge
	Global $ButtonPixel = _MultiPixelSearch(433, 565 + $bottomOffsetY, 562, 619 + $bottomOffsetY, 1, 1, Hex(0x000000, 6), $offColors, 30) ; Black pixel of button edge
	If IsArray($ButtonPixel) Then
		If $debugSetlog = 1 Then
			Setlog("ButtonPixel = " & $ButtonPixel[0] & ", " & $ButtonPixel[1], $COLOR_PURPLE) ;Debug
			Setlog("#1: " & _GetPixelColor($ButtonPixel[0], $ButtonPixel[1], True) & ", #2: " & _GetPixelColor($ButtonPixel[0] + 37, $ButtonPixel[1] + 34, True) & ", #3: " & _GetPixelColor($ButtonPixel[0] + 50, $ButtonPixel[1] + 43, True) & ", #4: " & _GetPixelColor($ButtonPixel[0] + 61, $ButtonPixel[1] + 8, True), $COLOR_PURPLE)
		EndIf
		If $debugImageSave = 1 Then DebugImageSave("LabUpgrade_") ; Debug Only
		Click($ButtonPixel[0] + 40, $ButtonPixel[1] + 25, 1, 0, "#0198") ; Click Research Button
		If _Sleep($iDelayLaboratory1) Then Return ; Wait for window to open
	Else
		Setlog("Trouble finding research button, try again...", $COLOR_MAROON)
		ClickP($aAway, 2, $iDelayLaboratory4, "#0199")
		Return False
	EndIf
	If $debugSetlog = 1 Then LabTroopImages1() ; Debug Only

	If $iFirstTimeLab = 0 Then ; Need to get upgrade value for troops on page 1, only do this on 1st cycle of function
		For $i = 1 To 12
			$aUpgradeValue[$i] = getLabUpgrdResourceRed($aLabTroops[$i][0] + 13, $aLabTroops[$i][1] + 74)
			If $debugSetlog = 1 Then Setlog($aLabTroops[$i][3] & " Red text upgrade value = " & $aUpgradeValue[$i], $COLOR_PURPLE)
			If $aUpgradeValue[$i] = "" Or $aUpgradeValue[$i] < 49999 Then ; check if blank or below min value for any upgrade on page 1
				$aUpgradeValue[$i] = getLabUpgrdResourceWht($aLabTroops[$i][0] + 13, $aLabTroops[$i][1] + 74)
				If $debugSetlog = 1 Then Setlog($aLabTroops[$i][3] & " White text upgrade value = " & $aUpgradeValue[$i], $COLOR_PURPLE)
			EndIf
			If $aUpgradeValue[$i] = "" Or $aUpgradeValue[$i] < 49999 Then ; check if blank or below min value for any upgrade on page 1
				If _ColorCheck(_GetPixelColor($aLabTroops[$i][0] + 78, $aLabTroops[$i][1] + 78, True), Hex(0xEFFFFF, 6), 20) And _ColorCheck(_GetPixelColor($aLabTroops[$i][0] + 78, $aLabTroops[$i][1] + 83, True), Hex(0xFFFFFF, 6), 20) Then
					$aUpgradeValue[$i] = -1
					If $debugSetlog = 1 Then Setlog($aLabTroops[$i][3] & " Is Maxed already, now = " & $aUpgradeValue[$i], $COLOR_PURPLE)
				EndIf
			EndIf
			If $RunState = False Then Return
		Next
		$iFirstTimeLab = 1
	EndIf

	If $aLabTroops[$icmbLaboratory][2] >= 1 Then ;Check if troop located on page 2 of lab window and Move to three icon squares to get spells
		;_PostMessage_ClickDrag(650, 423 + $midOffsetY, 545, 423 + $midOffsetY, "left", 1000)
		ClickDrag(650, 423 + $midOffsetY, 323, 423 + $midOffsetY, 1000)
		;_PostMessage_ClickDrag(734, 393, 643, 393, "left", 1500)
		If _Sleep($iDelayLaboratory3) Then Return
		If $debugSetlog = 1 Then LabTroopImages2() ; Debug Only
		If $iFirstTimeLab < 2 Then
			For $i = 13 To 18
				$aUpgradeValue[$i] = getLabUpgrdResourceRed($aLabTroops[$i][0] + 13, $aLabTroops[$i][1] + 74)
				If $debugSetlog = 1 Then Setlog($aLabTroops[$i][3] & " Red text upgrade value = " & $aUpgradeValue[$i], $COLOR_PURPLE)
				If $aUpgradeValue[$i] = "" Or $aUpgradeValue[$i] < 9999 Then ; check if blank or below min value for any upgrade on page 2
					$aUpgradeValue[$i] = getLabUpgrdResourceWht($aLabTroops[$i][0] + 13, $aLabTroops[$i][1] + 74)
					If $debugSetlog = 1 Then Setlog($aLabTroops[$i][3] & " White text upgrade value = " & $aUpgradeValue[$i], $COLOR_PURPLE)
				EndIf
				If $aUpgradeValue[$i] = "" Or $aUpgradeValue[$i] < 9999 Then ; check if blank or below min value for any upgrade on page 2
					If _ColorCheck(_GetPixelColor($aLabTroops[$i][0] + 78, $aLabTroops[$i][1] + 78, True), Hex(0xEFFFFF, 6), 20) And _ColorCheck(_GetPixelColor($aLabTroops[$i][0] + 78, $aLabTroops[$i][1] + 83, True), Hex(0xFFFFFF, 6), 20) Then
						$aUpgradeValue[$i] = -1
						If $debugSetlog = 1 Then Setlog($aLabTroops[$i][3] & " Is Maxed already, $aUpgradeValue now = " & $aUpgradeValue[$i], $COLOR_PURPLE)
					EndIf
				EndIf
				If $RunState = False Then Return
			Next
			$iFirstTimeLab += 2
		EndIf
	EndIf

	If $aLabTroops[$icmbLaboratory][2] = 2 Then ;Check if troop located on next page of lab window and Move to page for upgrade values
		;_PostMessage_ClickDrag(734, 423 + $midOffsetY, 3, 423 + $midOffsetY, "left", 2000)
		ClickDrag(734, 423 + $midOffsetY, 3, 423 + $midOffsetY, 2000)
		;_PostMessage_ClickDrag(734, 393, 643, 393, "left", 1500)
		If _Sleep($iDelayLaboratory3) Then Return
		If $debugSetlog = 1 Then LabTroopImages3() ; Debug Only
		If $iFirstTimeLab < 4 Then
			For $i = 19 To 29
				$aUpgradeValue[$i] = getLabUpgrdResourceRed($aLabTroops[$i][0] + 13, $aLabTroops[$i][1] + 74)
				If $debugSetlog = 1 Then Setlog($aLabTroops[$i][3] & " Red text upgrade value = " & $aUpgradeValue[$i], $COLOR_PURPLE)
				If $aUpgradeValue[$i] = "" Or $aUpgradeValue[$i] < 9999 Then ; check if blank or below min value for any upgrade on page 2
					$aUpgradeValue[$i] = getLabUpgrdResourceWht($aLabTroops[$i][0] + 13, $aLabTroops[$i][1] + 74)
					If $debugSetlog = 1 Then Setlog($aLabTroops[$i][3] & " White text upgrade value = " & $aUpgradeValue[$i], $COLOR_PURPLE)
				EndIf
				If $aUpgradeValue[$i] = "" Or $aUpgradeValue[$i] < 9999 Then ; check if blank or below min value for any upgrade on page 2
					If _ColorCheck(_GetPixelColor($aLabTroops[$i][0] + 78, $aLabTroops[$i][1] + 78, True), Hex(0xEFFFFF, 6), 20) And _ColorCheck(_GetPixelColor($aLabTroops[$i][0] + 78, $aLabTroops[$i][1] + 83, True), Hex(0xFFFFFF, 6), 20) Then
						$aUpgradeValue[$i] = -1
						If $debugSetlog = 1 Then Setlog($aLabTroops[$i][3] & " Is Maxed already, $aUpgradeValue now = " & $aUpgradeValue[$i], $COLOR_PURPLE)
					EndIf
				EndIf
				If $RunState = False Then Return
			Next
			$iFirstTimeLab += 4
		EndIf
	EndIf

	; Track Elixir cost for Wall Upgrade check
	Switch $icmbLaboratory
		Case 1 To 18 ; regular elixir
			If $aUpgradeValue[$icmbLaboratory] > 0 Then $iLaboratoryElixirCost = $aUpgradeValue[$icmbLaboratory]
	EndSwitch

	; check for upgrade in process - look for green in finish upgrade with gems button
	If _ColorCheck(_GetPixelColor(625, 250 + $midOffsetY, True), Hex(0x60AC10, 6), 20) Or _ColorCheck(_GetPixelColor(660, 250 + $midOffsetY, True), Hex(0x60AC10, 6), 20) Then
		SetLog("Upgrade in progress, waiting for completion of other troops", $COLOR_BLUE)
		If _Sleep($iDelayLaboratory2) Then Return
		; upgrade in process and time not recorded?  Then update completion time!
		If $sLabUpgradeTime = ""  Or $TimeDiff <= 0 Then
			$Result = getRemainTLaboratory(336, 260)      ; Try to read white text showing actual time left for upgrade
			If $debugSetlog = 1 Then Setlog($aLabTroops[$icmbLaboratory][3] & " OCR Remaining Lab Time = " & $Result, $COLOR_PURPLE)
			$aArray = StringSplit($Result, ' ', BitOR($STR_CHRSPLIT, $STR_NOCOUNT))  ;separate days, hours, minutes, seconds
			If IsArray($aArray) Then
				$iRemainingTimeMin = 0
				For $i = 0 To UBound($aArray) - 1  ; step through array and compute minutes remaining
					$sTime = ""
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
							$iRemainingTimeMin += Int($sTime) / 60  ; Add seconds
						Case Else
							Setlog("Remaining lab time OCR invalid:" & $aArray[$i], $COLOR_FUCHSIA)
							ClickP($aAway, 2, $iDelayLaboratory4, "#0328")
							Return False
					EndSelect
					If $debugSetlog = 1 Then Setlog("Remain Lab Time: " & $aArray[$i] & ", Minutes= " & $iRemainingTimeMin, $COLOR_PURPLE)
				Next
				$sLabUpgradeTime = _DateAdd('n', Ceiling($iRemainingTimeMin), _NowCalc()) ; add the time required to NOW to finish the upgrade
				If @error Then _logErrorDateAdd(@error)
				SetLog($aLabTroops[$icmbLaboratory][3] & "Updated Lab finishing time: " & $sLabUpgradeTime, $COLOR_GREEN)
				LabStatusGUIUpdate()  ; Update GUI flag
			Else
				If $debugSetlog = 1 Then Setlog("Invalid getRemainTLaboratory OCR", $COLOR_PURPLE)
			EndIf
		EndIf
		;If $debugSetlog <> 1 Then
		ClickP($aAway, 2, $iDelayLaboratory4, "#0328")
		Return False
		;EndIf
	EndIf

	If $aUpgradeValue[$icmbLaboratory] = -1 Then
		SetLog($aLabTroops[$icmbLaboratory][3] & " already max level, select another troop", $COLOR_RED)
		ClickP($aAway, 2, $iDelayLaboratory4, "#0353")
		Return False
	EndIf
	If $aUpgradeValue[$icmbLaboratory] = 0 Then
		If _ColorCheck(_GetPixelColor($aLabTroops[$icmbLaboratory][0] + 3, $aLabTroops[$icmbLaboratory][1] + 19, True), Hex(0xC0C0C0, 6), 25) = True Then
			; Look for Gray pixel inside left border if Lab upgrade required
			SetLog("Lab upgrade not available for " & $aLabTroops[$icmbLaboratory][3] & ", Pick different troop!", $COLOR_RED)
			If _Sleep($iDelayLabUpgrade2) Then Return
		Else
			SetLog($aLabTroops[$icmbLaboratory][3] & " value read error, close bot and try again!", $COLOR_RED)
		EndIf
		$iFirstTimeLab = 2 ; reset value read flag in case use does not restart bot.
		ClickP($aAway, 2, $iDelayLaboratory4, "#0354")
		Return False
	EndIf
	Switch $icmbLaboratory ;Change messaging based on troop number
		Case 1 To 18; regular elixir
			If $iAvailElixir < ($aUpgradeValue[$icmbLaboratory] + $itxtUpgrMinElixir) Then
				SetLog("Insufficent Elixir for " & $aLabTroops[$icmbLaboratory][3] & ", Lab requires: " & $aUpgradeValue[$icmbLaboratory] & " + " & $itxtUpgrMinElixir & " user reserve", $COLOR_BLUE)
				ClickP($aAway, 2, $iDelayLaboratory4, "#0355")
				Return False
			EndIf
			If LabUpgrade() = True Then
				Setlog("Elixir used = " & $aUpgradeValue[$icmbLaboratory], $COLOR_BLUE)
				ClickP($aAway, 2, $iDelayLaboratory4, "#0356")
				Return True
			EndIf

		Case 19 To 29 ; Dark Elixir
			If $iAvailDark < $aUpgradeValue[$icmbLaboratory] + $itxtUpgrMinDark Then
				SetLog("Insufficent Dark Elixir for " & $aLabTroops[$icmbLaboratory][3] & ", Lab requires: " & $aUpgradeValue[$icmbLaboratory] & " + " & $itxtUpgrMinDark & " user reserve", $COLOR_BLUE)
				ClickP($aAway, 2, $iDelayLaboratory4, "#0357")
				Return False
			EndIf
			If LabUpgrade() = True Then
				Setlog("Dark Elixir used = " & $aUpgradeValue[$icmbLaboratory], $COLOR_BLUE)
				ClickP($aAway, 2, $iDelayLaboratory4, "#0358")
				Return True
			EndIf

		Case Else
			Setlog("Something went wrong with loot value on Lab upgrade on #" & $aLabTroops[$icmbLaboratory][3], $COLOR_RED)
			Return False
	EndSwitch

	ClickP($aAway, 2, $iDelayLaboratory4, "#0359")
	Return False

EndFunc   ;==>Laboratory
;
Func LabUpgrade()
	Local $StartTime, $EndTime, $EndPeriod, $Result, $TimeAdd = 0
	Select
		Case _ColorCheck(_GetPixelColor($aLabTroops[$icmbLaboratory][0] + 47, $aLabTroops[$icmbLaboratory][1] + 6, True), Hex(0xE8E8E0, 6), 20) = True
			; check for beige pixel in center just below edge for troop not unlocked
			SetLog($aLabTroops[$icmbLaboratory][3] & " not unlocked yet, select another troop", $COLOR_RED)
			If _Sleep($iDelayLabUpgrade2) Then Return

		Case _ColorCheck(_GetPixelColor($aLabTroops[$icmbLaboratory][0] + 68, $aLabTroops[$icmbLaboratory][1] + 79, True), Hex(0xE70A12, 6), 20) And _ColorCheck(_GetPixelColor($aLabTroops[$icmbLaboratory][0] + 68, $aLabTroops[$icmbLaboratory][1] + 84, True), Hex(0xE70A12, 6), 20)
			; Check for 2 red pixels in last zero of loot value to see if enough loot is available.
			; this case should never be run if value check is working right!
			SetLog("Value check error and Not enough Loot to upgrade " & $aLabTroops[$icmbLaboratory][3] & "...", $COLOR_RED)
			If _Sleep($iDelayLabUpgrade2) Then Return

		Case _ColorCheck(_GetPixelColor($aLabTroops[$icmbLaboratory][0] + 23, $aLabTroops[$icmbLaboratory][1] + 60, True), Hex(0xFFC360, 6), 20) = True
			; Look for Golden pixel inside level indicator for max troops
			SetLog($aLabTroops[$icmbLaboratory][3] & " already max level, select another troop", $COLOR_RED)
			If _Sleep($iDelayLabUpgrade2) Then Return

		Case _ColorCheck(_GetPixelColor($aLabTroops[$icmbLaboratory][0] + 3, $aLabTroops[$icmbLaboratory][1] + 19, True), Hex(0xB7B7B7, 6), 20) = True
			; Look for Gray pixel inside left border if Lab upgrade required or if we missed that upgrade is in process
			SetLog("Laboratory upgrade not available now for " & $aLabTroops[$icmbLaboratory][3] & "...", $COLOR_RED)
			If _Sleep($iDelayLabUpgrade2) Then Return

		Case Else
			; If none of other error conditions apply, begin upgrade process
			Click($aLabTroops[$icmbLaboratory][0] + 40, $aLabTroops[$icmbLaboratory][1] + 40, 1, 0, "#0200") ; Click Upgrade troop button
			If _Sleep($iDelayLabUpgrade1) Then Return ; Wait for window to open
			If $debugImageSave = 1 Then DebugImageSave("LabUpgrade_")

			; double check if maxed?
			If _ColorCheck(_GetPixelColor(258, 192, True), Hex(0xFF1919, 6), 20) And _ColorCheck(_GetPixelColor(272, 194, True), Hex(0xFF1919, 6), 20) Then
				SetLog($aLabTroops[$icmbLaboratory][3] & " Previously maxxed, select another troop", $COLOR_RED) ; oops, we found the red warning message
				If _Sleep($iDelayLabUpgrade2) Then Return
				ClickP($aAway, 2, $iDelayLabUpgrade3, "#0201")
				Return False
			EndIf

			; double check enough elixir?
			If _ColorCheck(_GetPixelColor(557, 487, True), Hex(0xE70A12, 6), 20) And _ColorCheck(_GetPixelColor(557, 494), Hex(0xE70A12, 6), 20) Then ; Check for Red Zero = means not enough loot!
				SetLog("Missing Loot to upgrade " & $aLabTroops[$icmbLaboratory][3] & " (secondary check after Upgrade Value read failed)", $COLOR_RED)
				If _Sleep($iDelayLabUpgrade2) Then Return
				ClickP($aAway, 2, $iDelayLabUpgrade3, "#0333")
				Return False
			EndIf

			; triple check for upgrade in process by gray upgrade button
			If _ColorCheck(_GetPixelColor(625, 250 + $midOffsetY, True), Hex(0x848484, 6), 20) And _ColorCheck(_GetPixelColor(660, 250 + $midOffsetY, True), Hex(0x848484, 6), 20) Then
				SetLog("Upgrade in progress, waiting for completion of other troops", $COLOR_MAROON)
				If _Sleep($iDelayLaboratory2) Then Return
				ClickP($aAway, 2, $iDelayLaboratory4, "#0000")
				Return False
			Else
				; get upgrade time from window
				$Result = getLabUpgradeTime(482, 557) ; Try to read white text showing time for upgrade
				Setlog($aLabTroops[$icmbLaboratory][3] & " Upgrade OCR Time = " & $Result, $COLOR_BLUE)
				$StartTime = _NowCalc() ; what is date:time now
				If $debugSetlog = 1 Then SetLog($aLabTroops[$icmbLaboratory][3] & "Upgrade Started @ " & $StartTime, $COLOR_GREEN)
				; Compute upgrade end time
				$EndTime = ""
				$EndPeriod = ""
				$TimeAdd = 0
				$sLabUpgradeTime = StringStripWS($Result, $STR_STRIPALL)
				$aArray = StringRegExp($sLabUpgradeTime, '\d+', $STR_REGEXPARRAYMATCH)
				If IsArray($aArray) Then
					If $debugSetlog = 1 Then ; debug - display array value
						For $i = 0 To UBound($aArray) - 1
							Setlog("UpgradeTime $aArray[" & $i & "] = " & $aArray[$i])
						Next
					EndIf
					$EndTime = $aArray[0]
					$EndPeriod = StringReplace($sLabUpgradeTime, $EndTime, "")
					Switch $EndPeriod
						Case "d"
							$TimeAdd = (Int($EndTime) * 24 * 60) - 10 ; change days to minutes, minus 10 minute
							$sLabUpgradeTime = _DateAdd('n', $TimeAdd, $StartTime) ; add the time required to finish the  upgrade
						Case "h"
							$TimeAdd = (Int($EndTime) * 60) - 3 ; change hours to minutes, minus 3 minutes
							$sLabUpgradeTime = _DateAdd('n', $TimeAdd, $StartTime) ; add the time required to finish the  upgrade
						Case "m"
							$TimeAdd = Int($EndTime) ; change to minutes
							$sLabUpgradeTime = _DateAdd('n', $TimeAdd, $StartTime) ; add the time required to finish the  upgrade
						Case Else
							Setlog("Upgrade time period invalid, try again!", $COLOR_FUCHSIA)
					EndSwitch
					If $debugSetlog = 1 Then Setlog("$EndTime = " & $EndTime & " , $EndPeriod = " & $EndPeriod & ", $timeadd = " & $TimeAdd, $COLOR_PURPLE)
					SetLog($aLabTroops[$icmbLaboratory][3] & "Upgrade Finishes @ " & $sLabUpgradeTime, $COLOR_GREEN)
				Else
					Setlog("Error reading the upgrade time required, try again!", $COLOR_FUCHSIA)
				EndIf
				If _DateIsValid($sLabUpgradeTime) = 0 Then ; verify success of StringRegExp to process upgrade date/time
					Setlog("Error processing upgrade time required, try again!", $COLOR_FUCHSIA)
					Return False
				Else
					$txtTip = GetTranslated(614, 8, "Visible Red button means that laboratory upgrade in process") & @CRLF & _
							GetTranslated(614, 9, "This will automatically disappear when near time for upgrade to be completed.") & @CRLF & _
							GetTranslated(614, 10, "If upgrade has been manually finished with gems before normal end time,") & @CRLF & _
							GetTranslated(614, 11, "Click red button to reset internal upgrade timer BEFORE STARTING NEW UPGRADE") & @CRLF & _
							GetTranslated(614, 12, "Caution - Unnecessary timer reset will force constant checks for lab status") & @CRLF & @CRLF & _
							GetTranslated(614, 19, "Troop Upgrade started") & ": " & $StartTime & ", " & _
							GetTranslated(614, 20, "Will begin to check completion at:") & " " & $sLabUpgradeTime & @CRLF & " "
					_GUICtrlSetTip($btnResetLabUpgradeTime, $txtTip)
				EndIf

				Click(660, 520 + $midOffsetY, 1, 0, "#0202") ; Everything is good - Click the upgrade button
				If _Sleep($iDelayLabUpgrade1) Then Return
			EndIf

			If isGemOpen(True) = False Then ; check for gem window
				If Not (_ColorCheck(_GetPixelColor(625, 250 + $midOffsetY, True), Hex(0x60AC10, 6), 20)) Or Not (_ColorCheck(_GetPixelColor(660, 250 + $midOffsetY, True), Hex(0x60AC10, 6), 20)) Then
					SetLog("Something went wrong with " & $aLabTroops[$icmbLaboratory][3] & " Upgrade, try again.", $COLOR_RED)
					ClickP($aAway, 2, $iDelayLabUpgrade3, "#0360")
					Return False
				EndIf
				SetLog("Upgrade " & $aLabTroops[$icmbLaboratory][3] & " in your laboratory is complete...", $COLOR_GREEN)
				PushMsg("LabSuccess")
				If _Sleep($iDelayLabUpgrade2) Then Return
				$ichkLab = 0 ;reset enable lab upgrade flag
				GUICtrlSetState($chkLab, $GUI_UNCHECKED) ; reset enable lab upgrade check box

				ClickP($aAway, 2, 0, "#0204")

				Return True
			Else
				SetLog("Oops, Gems required for " & $aLabTroops[$icmbLaboratory][3] & " Upgrade, try again.", $COLOR_RED)
			EndIf
	EndSelect
	ClickP($aAway, 2, $iDelayLabUpgrade3, "#0205")
	Return False

EndFunc   ;==>LabUpgrade

Func DebugRegionSave($sTxtName = "Unknown", $iLeft = 0, $iTop = 0, $iRight = $DEFAULT_WIDTH, $iBottom = $DEFAULT_HEIGHT)

	; Debug Code to save images before zapping for later review, time stamped to align with logfile!
	SetLog("Taking debug snapshot for later review", $COLOR_GREEN) ;Debug purposes only :)
	Local $Date = @MDAY & "." & @MON & "." & @YEAR
	Local $Time = @HOUR & "." & @MIN & "." & @SEC
	If $iLeft <> 0 And $iTop <> 0 And $iRight <> $DEFAULT_WIDTH And $iBottom <> $DEFAULT_HEIGHT Then
		Local $sName = $sTxtName & "_Left_" & $iLeft & "_Top_" & $iTop & "_Right_" & $iRight & "_Bottom_" & $iBottom & "_"
	Else
		$sName = $sTxtName
	EndIf
	_CaptureRegion($iLeft, $iTop, $iRight, $iBottom)
	_GDIPlus_ImageSaveToFile($hBitmap, $dirTempDebug & $sName & $Date & " at " & $Time & ".png")
	If _Sleep($iDelayLaboratory2) Then Return

EndFunc   ;==>DebugRegionSave

Func LabTroopImages1() ; Debug function to record pixel values for page 1 of lab troop window
	If $debugImageSave = 1 Then DebugImageSave("LabUpgrade_")
	For $i = 1 To 12
		DebugRegionSave($aLabTroops[$i][3], $aLabTroops[$i][0], $aLabTroops[$i][1], $aLabTroops[$i][0] + 98, $aLabTroops[$i][1] + 98)
		SetLog($aLabTroops[$i][3], $COLOR_FUCHSIA)
		SetLog("_GetPixelColor(+47, +6): " & _GetPixelColor($aLabTroops[$i][0] + 47, $aLabTroops[$i][1] + 6, True) & ":E0E4D0 =Not unlocked", $COLOR_PURPLE)
		SetLog("_GetPixelColor(+68, +79): " & _GetPixelColor($aLabTroops[$i][0] + 68, $aLabTroops[$i][1] + 79, True) & ":E70A12 =No Loot1", $COLOR_PURPLE)
		SetLog("_GetPixelColor(+68, +82): " & _GetPixelColor($aLabTroops[$i][0] + 68, $aLabTroops[$i][1] + 84, True) & ":E70A12 =No Loot2", $COLOR_PURPLE)
		SetLog("_GetPixelColor(+81, +82): " & _GetPixelColor($aLabTroops[$i][0] + 81, $aLabTroops[$i][1] + 82, True) & ":XXXXXX =Loot type", $COLOR_PURPLE)
		SetLog("_GetPixelColor(+78, +83): " & _GetPixelColor($aLabTroops[$i][0] + 78, $aLabTroops[$i][1] + 83, True) & ":FFFFFF =Max L", $COLOR_PURPLE)
		SetLog("_GetPixelColor(+78, +78): " & _GetPixelColor($aLabTroops[$i][0] + 78, $aLabTroops[$i][1] + 78, True) & ":EFFFFF =Max L", $COLOR_PURPLE)
		SetLog("_GetPixelColor(+3, +19): " & _GetPixelColor($aLabTroops[$i][0] + 3, $aLabTroops[$i][1] + 19, True) & ":C0C0C0 =Not possible", $COLOR_PURPLE)
		SetLog("_GetPixelColor(+8, +59): " & _GetPixelColor($aLabTroops[$i][0] + 23, $aLabTroops[$i][1] + 60, True) & ":FFC360 =Max troop", $COLOR_PURPLE)
	Next
EndFunc   ;==>LabTroopImages1

Func LabTroopImages2() ; Debug function to record pixel values for page 2 of lab troop window
	If $debugImageSave = 1 Then DebugImageSave("LabUpgrade_")
	For $i = 13 To 18
		DebugRegionSave($aLabTroops[$i][3], $aLabTroops[$i][0], $aLabTroops[$i][1], $aLabTroops[$i][0] + 98, $aLabTroops[$i][1] + 98)
		SetLog($aLabTroops[$i][3], $COLOR_FUCHSIA)
		SetLog("_GetPixelColor(+47, +6): " & _GetPixelColor($aLabTroops[$i][0] + 47, $aLabTroops[$i][1] + 6, True) & ":E0E4D0 =Not unlocked", $COLOR_PURPLE)
		SetLog("_GetPixelColor(+68, +79): " & _GetPixelColor($aLabTroops[$i][0] + 68, $aLabTroops[$i][1] + 79, True) & ":E70A12 =No Loot1", $COLOR_PURPLE)
		SetLog("_GetPixelColor(+68, +82): " & _GetPixelColor($aLabTroops[$i][0] + 68, $aLabTroops[$i][1] + 84, True) & ":E70A12 =No Loot2", $COLOR_PURPLE)
		SetLog("_GetPixelColor(+81, +82): " & _GetPixelColor($aLabTroops[$i][0] + 81, $aLabTroops[$i][1] + 82, True) & ":XXXXXX =Loot type", $COLOR_PURPLE)
		SetLog("_GetPixelColor(+78, +83): " & _GetPixelColor($aLabTroops[$i][0] + 78, $aLabTroops[$i][1] + 83, True) & ":FFFFFF =Max L", $COLOR_PURPLE)
		SetLog("_GetPixelColor(+78, +78): " & _GetPixelColor($aLabTroops[$i][0] + 78, $aLabTroops[$i][1] + 78, True) & ":EFFFFF =Max L", $COLOR_PURPLE)
		SetLog("_GetPixelColor(+3, +19): " & _GetPixelColor($aLabTroops[$i][0] + 3, $aLabTroops[$i][1] + 19, True) & ":C0C0C0 =Not possible", $COLOR_PURPLE)
		SetLog("_GetPixelColor(+8, +59): " & _GetPixelColor($aLabTroops[$i][0] + 23, $aLabTroops[$i][1] + 60, True) & ":FFC360 =Max troop", $COLOR_PURPLE)
	Next
EndFunc   ;==>LabTroopImages2

Func LabTroopImages3() ; Debug function to record pixel values for page 2 of lab troop window
	If $debugImageSave = 1 Then DebugImageSave("LabUpgrade_")
	For $i = 19 To 29
		DebugRegionSave($aLabTroops[$i][3], $aLabTroops[$i][0], $aLabTroops[$i][1], $aLabTroops[$i][0] + 98, $aLabTroops[$i][1] + 98)
		SetLog($aLabTroops[$i][3], $COLOR_FUCHSIA)
		SetLog("_GetPixelColor(+47, +6): " & _GetPixelColor($aLabTroops[$i][0] + 47, $aLabTroops[$i][1] + 6, True) & ":E0E4D0 =Not unlocked", $COLOR_PURPLE)
		SetLog("_GetPixelColor(+68, +79): " & _GetPixelColor($aLabTroops[$i][0] + 68, $aLabTroops[$i][1] + 79, True) & ":E70A12 =No Loot1", $COLOR_PURPLE)
		SetLog("_GetPixelColor(+68, +82): " & _GetPixelColor($aLabTroops[$i][0] + 68, $aLabTroops[$i][1] + 84, True) & ":E70A12 =No Loot2", $COLOR_PURPLE)
		SetLog("_GetPixelColor(+81, +82): " & _GetPixelColor($aLabTroops[$i][0] + 81, $aLabTroops[$i][1] + 82, True) & ":XXXXXX =Loot type", $COLOR_PURPLE)
		SetLog("_GetPixelColor(+78, +83): " & _GetPixelColor($aLabTroops[$i][0] + 78, $aLabTroops[$i][1] + 83, True) & ":FFFFFF =Max L", $COLOR_PURPLE)
		SetLog("_GetPixelColor(+78, +78): " & _GetPixelColor($aLabTroops[$i][0] + 78, $aLabTroops[$i][1] + 78, True) & ":EFFFFF =Max L", $COLOR_PURPLE)
		SetLog("_GetPixelColor(+3, +19): " & _GetPixelColor($aLabTroops[$i][0] + 3, $aLabTroops[$i][1] + 19, True) & ":C0C0C0 =Not possible", $COLOR_PURPLE)
		SetLog("_GetPixelColor(+8, +59): " & _GetPixelColor($aLabTroops[$i][0] + 23, $aLabTroops[$i][1] + 60, True) & ":FFC360 =Max troop", $COLOR_PURPLE)
	Next
EndFunc   ;==>LabTroopImages3
