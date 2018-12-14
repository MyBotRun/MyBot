; #FUNCTION# ====================================================================================================================
; Name ..........: Laboratory
; Description ...:
; Syntax ........: Laboratory()
; Parameters ....:
; Return values .: None
; Author ........: summoner
; Modified ......: KnowJack (2015-06), Sardo (2015-08), Monkeyhunter(2016-02,2016-04), MMHK(2018-06)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global Const $sColorNA = Hex(0xD3D3CB, 6) ; relative location: 47,1; Troop not unlocked in Lab, beige pixel in center just below edge for troop
Global Const $sColorNoLoot = Hex(0xFD877E, 6) ; relative location: 68,79 & 68,84; Not enough loot available to upgrade, find pink pixel in value
Global Const $sColorMaxLvl = Hex(0xFFFFFF, 6) ; relative location: 76,76 & 76,80; Upgrade already at MAX level, white in last "l"
Global Const $sColorLabUgReq = Hex(0x838383, 6) ; relative location: 0,20 or 93,20 lab upgrade required, Look for Gray pixel inside left border
Global Const $sColorMaxTroop = Hex(0xFFC360, 6) ; relative location: 23,60; troop already MAX
Global Const $sColorBG = Hex(0xD3D3CB, 6) ; background color in laboratory
Global Const $aiCloseDefaultPOS[2] = [721, 143]
Global Const $aiIconDefaultPOS[36][2] = [ _
			[-1, -1], _						; blank
			[114, 337 + $g_iMidOffsetY], _	; page 1
			[114, 444 + $g_iMidOffsetY], _
			[221, 337 + $g_iMidOffsetY], _
			[221, 444 + $g_iMidOffsetY], _
			[327, 337 + $g_iMidOffsetY], _
			[327, 444 + $g_iMidOffsetY], _
			[434, 337 + $g_iMidOffsetY], _
			[434, 444 + $g_iMidOffsetY], _
			[541, 337 + $g_iMidOffsetY], _
			[541, 444 + $g_iMidOffsetY], _
			[647, 337 + $g_iMidOffsetY], _
			[647, 444 + $g_iMidOffsetY], _
			[114, 337 + $g_iMidOffsetY], _	; page 2
			[114, 444 + $g_iMidOffsetY], _
			[221, 337 + $g_iMidOffsetY], _
			[221, 444 + $g_iMidOffsetY], _
			[327, 337 + $g_iMidOffsetY], _
			[327, 444 + $g_iMidOffsetY], _
			[434, 337 + $g_iMidOffsetY], _
			[434, 444 + $g_iMidOffsetY], _
			[541, 337 + $g_iMidOffsetY], _ 
			[541, 444 + $g_iMidOffsetY], _
			[647, 337 + $g_iMidOffsetY], _
			[647, 444 + $g_iMidOffsetY], _
			[114, 337 + $g_iMidOffsetY], _	; page 3
			[114, 444 + $g_iMidOffsetY], _
			[221, 337 + $g_iMidOffsetY], _
			[221, 444 + $g_iMidOffsetY], _
			[327, 337 + $g_iMidOffsetY], _
			[327, 444 + $g_iMidOffsetY], _
			[434, 337 + $g_iMidOffsetY], _
			[434, 444 + $g_iMidOffsetY], _
			[541, 337 + $g_iMidOffsetY], _
			[541, 444 + $g_iMidOffsetY], _
			[647, 337 + $g_iMidOffsetY]]

Func TestLaboratory()
	Local $bWasRunState = $g_bRunState
	Local $sWasLabUpgradeTime = $g_sLabUpgradeTime
	Local $sWasLabUpgradeEnable = $g_bAutoLabUpgradeEnable
	$g_bRunState = True
	$g_bAutoLabUpgradeEnable = True
	$g_sLabUpgradeTime = ""
	Local $Result = Laboratory()
	$g_bRunState = $bWasRunState
	$g_sLabUpgradeTime = $sWasLabUpgradeTime
	$g_bAutoLabUpgradeEnable = $sWasLabUpgradeEnable
	Return $Result
EndFunc

Func Laboratory()

	;Create local array to hold upgrade values
	;Was static, but makes no sense in switch account context
	Local $aUpgradeValue[36] = [-1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	Local $iAvailElixir, $iAvailDark, $sElixirCount, $sDarkCount, $TimeDiff, $aArray, $Result, $iCheapestCost = 0
	Local $iXMoved = 0, $iYMoved = 0, $iFirstPageOffset = 0, $iLastPageOffset = 0
	Local $iSelectedUpgrade = $g_iCmbLaboratory

	$g_iUpgradeMinElixir = Number($g_iUpgradeMinElixir)
	$g_iUpgradeMinDark = Number($g_iUpgradeMinDark)

	$g_iLaboratoryElixirCost = 0
	$g_iLaboratoryDElixirCost = 0
	If Not $g_bAutoLabUpgradeEnable Then Return ; Lab upgrade not enabled.

	If $g_aiLaboratoryPos[0] = 0 Or $g_aiLaboratoryPos[1] = 0 Then
		SetLog("Laboratory Location not found!", $COLOR_WARNING)
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

	;Click Laboratory
	BuildingClickP($g_aiLaboratoryPos, "#0197")
	If _Sleep($DELAYLABORATORY3) Then Return ; Wait for window to open

	; Find Research Button
	If QuickMIS("BC1", @ScriptDir & "\imgxml\Lab\Research", 200, 620, 700, 700) Then
		If $g_bDebugImageSave Then DebugImageSave("LabUpgrade") ; Debug Only
		Click($g_iQuickMISX + 200, $g_iQuickMISY + 620)
		If _Sleep($DELAYLABORATORY1) Then Return ; Wait for window to open
	Else
		Setlog("Trouble finding research button, try again...", $COLOR_WARNING)
		ClickP($aAway, 2, $DELAYLABORATORY4, "#0199")
		Return False
	EndIf

	; check for upgrade in process - look for green in finish upgrade with gems button
	If $g_bDebugSetlog Then SetLog("_GetPixelColor(730, 200): " & _GetPixelColor(730, 200, True) & ":A2CB6C", $COLOR_DEBUG)
	If _ColorCheck(_GetPixelColor(730, 200, True), Hex(0xA2CB6C, 6), 20) Then
		SetLog("Laboratory Upgrade in progress, waiting for completion", $COLOR_INFO)
		If _Sleep($DELAYLABORATORY2) Then Return
		; upgrade in process and time not recorded so update completion time!
		Local $sLabTimeOCR = getRemainTLaboratory(270, 257)
		Local $iLabFinishTime = ConvertOCRTime("Lab Time", $sLabTimeOCR, False)
		SetDebugLog("$sLabTimeOCR: " & $sLabTimeOCR & ", $iLabFinishTime = " & $iLabFinishTime & " m")
		If $iLabFinishTime > 0 Then
			$g_sLabUpgradeTime = _DateAdd('n', Ceiling($iLabFinishTime), _NowCalc())
			If @error Then _logErrorDateAdd(@error)
			SetLog("Research will finish in " & $sLabTimeOCR & " (" & $g_sLabUpgradeTime & ")")
			LabStatusGUIUpdate() ; Update GUI flag
		ElseIf $g_bDebugSetlog Then
			SetLog("Invalid getRemainTLaboratory OCR", $COLOR_DEBUG)
		EndIf
		ClickP($aAway, 2, $DELAYLABORATORY4, "#0328")
		Return False
	EndIf

	; reset lab troop positions to default
	For $i = 1 to UBound($aiIconDefaultPOS) - 1
		$g_avLabTroops[$i][0] = $aiIconDefaultPOS[$i][0]
		$g_avLabTroops[$i][1] = $aiIconDefaultPOS[$i][1]
	Next

	; Lab window coor correction
	Local $aiCloseBtn = findButton("CloseWindow")
	If IsArray($aiCloseBtn) Then
		$iXMoved = $aiCloseBtn[0] - $aiCloseDefaultPOS[0]
		$iYMoved = $aiCloseBtn[1] - $aiCloseDefaultPOS[1]
		If $g_bDebugSetlog Then Setlog("Lab window off: (" & $iXMoved & ", " & $iYMoved & ")", $COLOR_DEBUG)
	Else
		SetLog("Trouble finding lab close button, try again...", $COLOR_WARNING)
		ClickP($aAway, 2, $DELAYLABORATORY4, "#0199")
		Return False
	EndIf
	For $x = 0 To 10 ; check for an offset of icons on first page in lab
		If Not (_ColorCheck(_GetPixelColor(114 + $x + $iXMoved, 410 + $iYMoved, True), $sColorBG, 10) And _
			_ColorCheck(_GetPixelColor(114 + $x + $iXMoved, 520 + $iYMoved, True), $sColorBG, 10)) Then
			$iFirstPageOffset = $x
			ExitLoop
		EndIf
	Next
	If $g_bDebugSetlog Then Setlog("Icon Offset on First Page: " & $iFirstPageOffset & "px", $COLOR_DEBUG)
	For $i = 0 To 2 
		ClickDrag(635, 439 + $g_iMidOffsetY, 220, 439 + $g_iMidOffsetY, 250)
	Next
	If _Sleep($DELAYLABORATORY5) Then Return
	For $x = 0 To 5 ; check for an offset of icons on last page in lab
		If Not (_ColorCheck(_GetPixelColor(114 + $x + $iXMoved, 410 + $iYMoved, True), $sColorBG, 10) And _
			_ColorCheck(_GetPixelColor(114 + $x + $iXMoved, 520 + $iYMoved, True), $sColorBG, 10)) Then
			$iLastPageOffset = $x
			ExitLoop
		EndIf
	Next
	If $g_bDebugSetlog Then Setlog("Icon Offset on Last Page: " & $iLastPageOffset & "px", $COLOR_DEBUG)
	For $i = 0 To 2 
		ClickDrag(220, 439 + $g_iMidOffsetY, 635, 439 + $g_iMidOffsetY, 250)
	Next
	If _Sleep($DELAYLABORATORY5) Then Return

	For $i = 1 to UBound($aiIconDefaultPOS) - 1 ; Applying all offsets
		$g_avLabTroops[$i][0] = $aiIconDefaultPOS[$i][0] + $iXMoved + (($g_avLabTroops[$i][2] = 0) ? $iFirstPageOffset : 0) + (($g_avLabTroops[$i][2] = 2) ? $iLastPageOffset : 0)
		If $g_bDebugSetlog Then Setlog("New icon X position of " & $g_avLabTroops[$i][3] & " : " & $g_avLabTroops[$i][0], $COLOR_DEBUG)
		$g_avLabTroops[$i][1] = $aiIconDefaultPOS[$i][1] + $iYMoved
		If $g_bDebugSetlog Then Setlog("New icon Y position of " & $g_avLabTroops[$i][3] & " : " & $g_avLabTroops[$i][1], $COLOR_DEBUG)
	Next
	
	; First page
	If $g_bDebugSetlog Then LabTroopImages(1, 12)
	For $i = 1 To 12
		$aUpgradeValue[$i] = getLabUpgrdResourceRed($g_avLabTroops[$i][0] + 3, $g_avLabTroops[$i][1] + 73)
		If $g_bDebugSetlog Then SetLog($g_avLabTroops[$i][3] & " Red text upgrade value = " & $aUpgradeValue[$i], $COLOR_DEBUG)
		If $aUpgradeValue[$i] = "" Or Int($aUpgradeValue[$i]) < 9999 Then ; check if blank or below min value for any upgrade on page 1
			$aUpgradeValue[$i] = getLabUpgrdResourceWht($g_avLabTroops[$i][0] + 3, $g_avLabTroops[$i][1] + 73)
			If $g_bDebugSetlog Then SetLog($g_avLabTroops[$i][3] & " White text upgrade value = " & $aUpgradeValue[$i], $COLOR_DEBUG)
		EndIf
		If $aUpgradeValue[$i] = "" Or Int($aUpgradeValue[$i]) < 9999 Then ; check if blank or below min value for any upgrade on page 1
			$aUpgradeValue[$i] = 0
			If _ColorCheck(_GetPixelColor($g_avLabTroops[$i][0] + 76, $g_avLabTroops[$i][1] + 76, True), $sColorMaxLvl, 20) And _
			   _ColorCheck(_GetPixelColor($g_avLabTroops[$i][0] + 76, $g_avLabTroops[$i][1] + 80, True), $sColorMaxLvl, 20) Then
				$aUpgradeValue[$i] = -1
				If $g_bDebugSetlog Then SetLog($g_avLabTroops[$i][3] & " Is Maxed already, now = " & $aUpgradeValue[$i], $COLOR_DEBUG)
			; Check if Lab upgrade required, Look for Gray pixel inside left border
			ElseIf _ColorCheck(_GetPixelColor($g_avLabTroops[$i][0], $g_avLabTroops[$i][1] + 20, True), $sColorLabUgReq, 25) = True Or _
			       _ColorCheck(_GetPixelColor($g_avLabTroops[$i][0] + 93, $g_avLabTroops[$i][1] + 20, True), $sColorLabUgReq, 25) = True Then
				$aUpgradeValue[$i] = -1
				If $g_bDebugSetlog Then SetLog("Lab upgrade required for " & $g_avLabTroops[$i][3] & ", now = " & $aUpgradeValue[$i], $COLOR_DEBUG)
			; Check if troop not unlocked, look for beige pixel in center just below top edge
			ElseIf _ColorCheck(_GetPixelColor($g_avLabTroops[$i][0] + 47, $g_avLabTroops[$i][1] + 1, True), $sColorNA, 20) = True Then
				$aUpgradeValue[$i] = -1
				If $g_bDebugSetlog Then SetLog($g_avLabTroops[$i][3] & " not unlocked yet, now = " & $aUpgradeValue[$i], $COLOR_DEBUG)
			EndIf
		EndIf
		If Not $g_bRunState Then Return
	Next

	; Second page
	For $i = 0 To 1 
		ClickDrag(615, 439 + $g_iMidOffsetY, 325, 439 + $g_iMidOffsetY, 250)
	Next
	If _Sleep($DELAYLABORATORY3) Then Return
	If Not ClickDragLab($g_avLabTroops[14][0]) Then
		SetLog("Trouble finding 2nd page of lab, try again...", $COLOR_WARNING)
		ClickP($aAway, 2, $DELAYLABORATORY4, "#0199")
		Return False
	EndIf
	If _Sleep($DELAYLABORATORY3) Then Return
	If $g_bDebugSetlog Then LabTroopImages(13, 20)
	For $i = 13 To 24
		$aUpgradeValue[$i] = getLabUpgrdResourceRed($g_avLabTroops[$i][0] + 3, $g_avLabTroops[$i][1] + 73)
		If $g_bDebugSetlog Then SetLog($g_avLabTroops[$i][3] & " Red text upgrade value = " & $aUpgradeValue[$i], $COLOR_DEBUG)
		If $aUpgradeValue[$i] = "" Or $aUpgradeValue[$i] < 9999 Then ; check if blank or below min value for any upgrade on page 2
			$aUpgradeValue[$i] = getLabUpgrdResourceWht($g_avLabTroops[$i][0] + 3, $g_avLabTroops[$i][1] + 73)
			If $g_bDebugSetlog Then SetLog($g_avLabTroops[$i][3] & " White text upgrade value = " & $aUpgradeValue[$i], $COLOR_DEBUG)
		EndIf
		If $aUpgradeValue[$i] = "" Or $aUpgradeValue[$i] < 9999 Then ; check if blank or below min value for any upgrade on page 2
			$aUpgradeValue[$i] = 0
			If _ColorCheck(_GetPixelColor($g_avLabTroops[$i][0] + 76, $g_avLabTroops[$i][1] + 76, True), $sColorMaxLvl, 20) And _
			   _ColorCheck(_GetPixelColor($g_avLabTroops[$i][0] + 76, $g_avLabTroops[$i][1] + 80, True), $sColorMaxLvl, 20) Then
				$aUpgradeValue[$i] = -1
				If $g_bDebugSetlog Then SetLog($g_avLabTroops[$i][3] & " Is Maxed already, now = " & $aUpgradeValue[$i], $COLOR_DEBUG)
			; Check if Lab upgrade required, Look for Gray pixel inside left border
			ElseIf _ColorCheck(_GetPixelColor($g_avLabTroops[$i][0], $g_avLabTroops[$i][1] + 20, True), $sColorLabUgReq, 25) = True Or _
				   _ColorCheck(_GetPixelColor($g_avLabTroops[$i][0] + 93, $g_avLabTroops[$i][1] + 20, True), $sColorLabUgReq, 25) = True Then
				$aUpgradeValue[$i] = -1
				If $g_bDebugSetlog Then SetLog("Lab upgrade required for " & $g_avLabTroops[$i][3] & ", now = " & $aUpgradeValue[$i], $COLOR_DEBUG)
			; Check if troop not unlocked, look for beige pixel in center just below top edge
			ElseIf _ColorCheck(_GetPixelColor($g_avLabTroops[$i][0] + 47, $g_avLabTroops[$i][1] + 1, True), $sColorNA, 20) = True Then
				$aUpgradeValue[$i] = -1
				If $g_bDebugSetlog Then SetLog($g_avLabTroops[$i][3] & " not unlocked yet, now = " & $aUpgradeValue[$i], $COLOR_DEBUG)
			EndIf
		EndIf
		If Not $g_bRunState Then Return
	Next

	; Third page
	For $i = 0 To 1 
		ClickDrag(620, 439 + $g_iMidOffsetY, 320, 439 + $g_iMidOffsetY, 250)
	Next
	If _Sleep($DELAYLABORATORY5) Then Return
	If $g_bDebugSetlog Then LabTroopImages(21, 32)
	For $i = 25 To 35
		$aUpgradeValue[$i] = getLabUpgrdResourceRed($g_avLabTroops[$i][0] + 3, $g_avLabTroops[$i][1] + 73)
		If $g_bDebugSetlog Then SetLog($g_avLabTroops[$i][3] & " Red text upgrade value = " & $aUpgradeValue[$i], $COLOR_DEBUG)
		If $aUpgradeValue[$i] = "" Or Int($aUpgradeValue[$i]) < 9999 Then ; check if blank or below min value for any upgrade on last page
			$aUpgradeValue[$i] = getLabUpgrdResourceWht($g_avLabTroops[$i][0] + 3, $g_avLabTroops[$i][1] + 73)
			If $g_bDebugSetlog Then SetLog($g_avLabTroops[$i][3] & " White text upgrade value = " & $aUpgradeValue[$i], $COLOR_DEBUG)
		EndIf
		If $aUpgradeValue[$i] = "" Or Int($aUpgradeValue[$i]) < 9999 Then ; check if blank or below min value for any upgrade on last page
			$aUpgradeValue[$i] = 0
			If _ColorCheck(_GetPixelColor($g_avLabTroops[$i][0] + 76, $g_avLabTroops[$i][1] + 76, True), $sColorMaxLvl, 20) And _
			   _ColorCheck(_GetPixelColor($g_avLabTroops[$i][0] + 76, $g_avLabTroops[$i][1] + 80, True), $sColorMaxLvl, 20) Then
				$aUpgradeValue[$i] = -1
				If $g_bDebugSetlog Then SetLog($g_avLabTroops[$i][3] & " Is Maxed already, now = " & $aUpgradeValue[$i], $COLOR_DEBUG)
			; Check if Lab upgrade required, Look for Gray pixel inside left border
			ElseIf _ColorCheck(_GetPixelColor($g_avLabTroops[$i][0], $g_avLabTroops[$i][1] + 20, True), $sColorLabUgReq, 25) = True Or _
				   _ColorCheck(_GetPixelColor($g_avLabTroops[$i][0] + 93, $g_avLabTroops[$i][1] + 20, True), $sColorLabUgReq, 25) = True Then
				$aUpgradeValue[$i] = -1
				If $g_bDebugSetlog Then SetLog("Lab upgrade required for " & $g_avLabTroops[$i][3] & ", now = " & $aUpgradeValue[$i], $COLOR_DEBUG)
			; Check if troop not unlocked, look for beige pixel in center just below top edge
			ElseIf _ColorCheck(_GetPixelColor($g_avLabTroops[$i][0] + 47, $g_avLabTroops[$i][1] + 1, True), $sColorNA, 20) = True Then
				$aUpgradeValue[$i] = -1
				If $g_bDebugSetlog Then SetLog($g_avLabTroops[$i][3] & " not unlocked yet, now = " & $aUpgradeValue[$i], $COLOR_DEBUG)
			EndIf
		EndIf
		If Not $g_bRunState Then Return
	Next
	
	If $aUpgradeValue[$g_iCmbLaboratory] = -1 Then
		If $g_iCmbLaboratory = 0 Then
			SetLog("No dedicated troop for upgrade selected, doing cheapest upgrade", $COLOR_ACTION)
		Else
			SetLog("No upgrade for " & $g_avLabTroops[$g_iCmbLaboratory][3] & " available, doing cheapest upgrade", $COLOR_ACTION)
		EndIf
		For $i = 1 To 35
			Switch $i
				Case 1 To 19 ; regular elixir
					ContinueCase
				Case 33 To 35
					If $aUpgradeValue[$i] > 0 And ($iCheapestCost = 0 Or $aUpgradeValue[$i] < $iCheapestCost) Then
						$iSelectedUpgrade = $i
						$iCheapestCost = $aUpgradeValue[$i]
					EndIf
				Case 20 To 32; Dark Elixir, multiply value with 50
					If $aUpgradeValue[$i] > 0 And ($iCheapestCost = 0 Or $aUpgradeValue[$i] * 50 < $iCheapestCost) Then
						$iSelectedUpgrade = $i
						$iCheapestCost = $aUpgradeValue[$i] * 50
					EndIf
			EndSwitch
		Next
		If $g_iCmbLaboratory = $iSelectedUpgrade Then
			SetLog("No alternate troop for upgrade found", $COLOR_WARNING)
			ClickP($aAway, 2, $DELAYLABORATORY4, "#0353")
			Return False
		Else
			SetLog($g_avLabTroops[$iSelectedUpgrade][3] & " selected for upgrade, upgrade cost = " & $aUpgradeValue[$iSelectedUpgrade], $COLOR_INFO)
		EndIf
	EndIf

	; Drag back to page 2 or 1
	If $g_avLabTroops[$iSelectedUpgrade][2] < 2 Then ; when troop located on page 1 or 2
		If $g_avLabTroops[$iSelectedUpgrade][2] = 1 Then ; page 2 position correction when stay on 2nd page
			For $i = 0 To 1 
				ClickDrag(320, 439 + $g_iMidOffsetY, 620, 439 + $g_iMidOffsetY, 250)
			Next
			If _Sleep($DELAYLABORATORY3) Then Return
			If Not ClickDragLab($g_avLabTroops[14][0]) Then
				SetLog("Trouble finding 2nd page of lab, try again...", $COLOR_WARNING)
				ClickP($aAway, 2, $DELAYLABORATORY4, "#0199")
				Return False
			EndIf
		Else
			For $i = 0 To 2 
				ClickDrag(220, 439 + $g_iMidOffsetY, 635, 439 + $g_iMidOffsetY, 250)
			Next
		EndIf
		If _Sleep($DELAYLABORATORY5) Then Return
	EndIf

	; Try to upgrade - LabUpgrade(), check insufficient resource first
	Switch $iSelectedUpgrade
		Case 1 To 19 ; regular elixir
			ContinueCase
		Case 33 To 35
			If $iAvailElixir < ($aUpgradeValue[$iSelectedUpgrade] + $g_iUpgradeMinElixir) Then
				If $aUpgradeValue[$iSelectedUpgrade] > 0 Then $g_iLaboratoryElixirCost = $aUpgradeValue[$iSelectedUpgrade] ; Reserve elixier and prevent wall upgrade as long
				SetLog("Insufficent Elixir for " & $g_avLabTroops[$iSelectedUpgrade][3] & ", Lab requires: " & $aUpgradeValue[$iSelectedUpgrade] & " + " & $g_iUpgradeMinElixir & " user reserve, available: " & $iAvailElixir, $COLOR_INFO)
				ClickP($aAway, 2, $DELAYLABORATORY4, "#0355")
				Return False
			EndIf
			If LabUpgrade($iSelectedUpgrade) = True Then
				SetLog("Elixir used = " & $aUpgradeValue[$iSelectedUpgrade], $COLOR_INFO)
				ClickP($aAway, 2, $DELAYLABORATORY4, "#0356")
				Return True
			EndIf

		Case 20 To 32; Dark Elixir
			If $iAvailDark < $aUpgradeValue[$iSelectedUpgrade] + $g_iUpgradeMinDark Then
				If $aUpgradeValue[$iSelectedUpgrade] > 0 Then $g_iLaboratoryDElixirCost = $aUpgradeValue[$iSelectedUpgrade] ; Reserve dark elixier and prevent hero upgrade as long
				SetLog("Insufficent Dark Elixir for " & $g_avLabTroops[$iSelectedUpgrade][3] & ", Lab requires: " & $aUpgradeValue[$iSelectedUpgrade] & " + " & $g_iUpgradeMinDark & " user reserve, available: " & $iAvailDark, $COLOR_INFO)
				ClickP($aAway, 2, $DELAYLABORATORY4, "#0357")
				Return False
			EndIf
			If LabUpgrade($iSelectedUpgrade) = True Then
				SetLog("Dark Elixir used = " & $aUpgradeValue[$iSelectedUpgrade], $COLOR_INFO)
				ClickP($aAway, 2, $DELAYLABORATORY4, "#0358")
				Return True
			EndIf

		Case Else
			SetLog("Something went wrong with loot value on Lab upgrade on #" & $g_avLabTroops[$iSelectedUpgrade][3], $COLOR_ERROR)
			Return False
	EndSwitch

	ClickP($aAway, 2, $DELAYLABORATORY4, "#0359")
	Return False

EndFunc   ;==>Laboratory
;
Func LabUpgrade($iSelectedUpgrade)
	Local $StartTime, $EndTime, $EndPeriod, $Result, $TimeAdd = 0
	Select
		Case _ColorCheck(_GetPixelColor($g_avLabTroops[$iSelectedUpgrade][0] + 47, $g_avLabTroops[$iSelectedUpgrade][1] + 1, True), $sColorNA, 20) = True
			; check for beige pixel in center just below edge for troop not unlocked
			SetLog($g_avLabTroops[$iSelectedUpgrade][3] & " not unlocked yet, select another troop", $COLOR_WARNING)
			If _Sleep($DELAYLABUPGRADE2) Then Return

		Case _PixelSearch($g_avLabTroops[$iSelectedUpgrade][0] + 67, $g_avLabTroops[$iSelectedUpgrade][1] + 79, $g_avLabTroops[$iSelectedUpgrade][0] + 69, $g_avLabTroops[$iSelectedUpgrade][0] + 84, $sColorNoLoot, 20) <> 0
			; Check for Pink pixels last zero of loot value to see if enough loot is available.
			; this case should never be run if value check is working right!
			SetLog("Value check error and Not enough Loot to upgrade " & $g_avLabTroops[$iSelectedUpgrade][3] & "...", $COLOR_ERROR)
			If _Sleep($DELAYLABUPGRADE2) Then Return

		Case _ColorCheck(_GetPixelColor($g_avLabTroops[$iSelectedUpgrade][0] + 22, $g_avLabTroops[$iSelectedUpgrade][1] + 60, True), Hex(0xFFC360, 6), 20) = True
			; Look for Golden pixel inside level indicator for max troops
			SetLog($g_avLabTroops[$iSelectedUpgrade][3] & " already max level, select another troop", $COLOR_ERROR)
			If _Sleep($DELAYLABUPGRADE2) Then Return

		Case _ColorCheck(_GetPixelColor($g_avLabTroops[$iSelectedUpgrade][0] + 3, $g_avLabTroops[$iSelectedUpgrade][1] + 19, True), Hex(0xB7B7B7, 6), 20) = True
			; Look for Gray pixel inside left border if Lab upgrade required or if we missed that upgrade is in process
			SetLog("Laboratory upgrade not available now for " & $g_avLabTroops[$iSelectedUpgrade][3] & "...", $COLOR_ERROR)
			If _Sleep($DELAYLABUPGRADE2) Then Return

		Case Else
			; If none of other error conditions apply, begin upgrade process
			Click($g_avLabTroops[$iSelectedUpgrade][0] + 40, $g_avLabTroops[$iSelectedUpgrade][1] + 40, 1, 0, "#0200") ; Click Upgrade troop button
			If _Sleep($DELAYLABUPGRADE1) Then Return ; Wait for window to open
			If $g_bDebugImageSave Then DebugImageSave("LabUpgrade")

			; double check if maxed?
			If _ColorCheck(_GetPixelColor(258, 192, True), Hex(0xFF1919, 6), 20) And _ColorCheck(_GetPixelColor(272, 194, True), Hex(0xFF1919, 6), 20) Then
				SetLog($g_avLabTroops[$iSelectedUpgrade][3] & " Previously maxxed, select another troop", $COLOR_ERROR) ; oops, we found the red warning message
				If _Sleep($DELAYLABUPGRADE2) Then Return
				ClickP($aAway, 2, $DELAYLABUPGRADE3, "#0201")
				Return False
			EndIf

			; double check enough elixir?
			If _PixelSearch($g_avLabTroops[$iSelectedUpgrade][0] + 67, $g_avLabTroops[$iSelectedUpgrade][1] + 79, $g_avLabTroops[$iSelectedUpgrade][0] + 69, $g_avLabTroops[$iSelectedUpgrade][0] + 84, $sColorNoLoot, 20) <> 0 Then ; Check for Red Zero = means not enough loot!
				SetLog("Missing Loot to upgrade " & $g_avLabTroops[$iSelectedUpgrade][3] & " (secondary check after Upgrade Value read failed)", $COLOR_ERROR)
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
				$Result = getLabUpgradeTime(581, 497) ; Try to read white text showing time for upgrade
				Local $iLabFinishTime = ConvertOCRTime("Lab Time", $Result, False)
				SetLog($g_avLabTroops[$iSelectedUpgrade][3] & " Upgrade OCR Time = " & $Result & ", $iLabFinishTime = " & $iLabFinishTime & " m", $COLOR_INFO)
				$StartTime = _NowCalc() ; what is date:time now
				If $g_bDebugSetlog Then SetDebugLog($g_avLabTroops[$iSelectedUpgrade][3] & " Upgrade Started @ " & $StartTime, $COLOR_SUCCESS)
				If $iLabFinishTime > 0 Then
					$g_sLabUpgradeTime = _DateAdd('n', Ceiling($iLabFinishTime), $StartTime)
					SetLog($g_avLabTroops[$iSelectedUpgrade][3] & " Upgrade Finishes @ " & $Result & " (" & $g_sLabUpgradeTime & ")", $COLOR_SUCCESS)
				Else
					SetLog("Error processing upgrade time required, try again!", $COLOR_WARNING)
					Return False
				EndIf

				LabStatusGUIUpdate()
				Click(660, 520 + $g_iMidOffsetY, 1, 0, "#0202") ; Everything is good - Click the upgrade button
				If _Sleep($DELAYLABUPGRADE1) Then Return
			EndIf

			If isGemOpen(True) = False Then ; check for gem window
				; check for green button to use gems to finish upgrade, checking if upgrade actually started
				If Not (_ColorCheck(_GetPixelColor(625, 218 + $g_iMidOffsetY, True), Hex(0x6fbd1f, 6), 15) Or _ColorCheck(_GetPixelColor(660, 218 + $g_iMidOffsetY, True), Hex(0x6fbd1f, 6), 15)) Then
					SetLog("Something went wrong with " & $g_avLabTroops[$iSelectedUpgrade][3] & " Upgrade, try again.", $COLOR_ERROR)
					ClickP($aAway, 2, $DELAYLABUPGRADE3, "#0360")
					Return False
				EndIf
				SetLog("Upgrade " & $g_avLabTroops[$iSelectedUpgrade][3] & " in your laboratory started with success...", $COLOR_SUCCESS)
				PushMsg("LabSuccess")
				If _Sleep($DELAYLABUPGRADE2) Then Return
				;$g_bAutoLabUpgradeEnable = False ;reset enable lab upgrade flag
				;GUICtrlSetState($g_hChkAutoLabUpgrades, $GUI_UNCHECKED) ; reset enable lab upgrade check box

				ClickP($aAway, 2, 0, "#0204")

				Return True
			Else
				SetLog("Oops, Gems required for " & $g_avLabTroops[$iSelectedUpgrade][3] & " Upgrade, try again.", $COLOR_ERROR)
			EndIf
	EndSelect
	ClickP($aAway, 2, $DELAYLABUPGRADE3, "#0205")
	Return False

EndFunc   ;==>LabUpgrade

Func ClickDragLab($iXTroop) ; drag a page to exact or nearby target position and update coor if necessary
	Local $iCounter = 1
	Local $iDiff = CheckXPos($iXTroop)
	While $iDiff <> 0
		If $iDiff = 9999 Then ExitLoop
		ClickDrag(426, 439 + $g_iMidOffsetY, 426 + $iDiff, 439 + $g_iMidOffsetY, 1000)
		If _Sleep($DELAYLABORATORY2) Then Return False
		$iDiff = CheckXPos($iXTroop)
		$iCounter += 1
		If $iCounter = 5 Then ExitLoop
	WEnd
	If $iDiff = 0 Then
		Return True
	ElseIf Abs($iDiff) < 10 Then
		For $i = 13 to 24 ; update x
			$g_avLabTroops[$i][0] = $g_avLabTroops[$i][0] - $iDiff
			If $g_bDebugSetlog Then Setlog("New icon X position of " & $g_avLabTroops[$i][3] & " : " & $g_avLabTroops[$i][0], $COLOR_DEBUG)
		Next
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>ClickDragLab

Func CheckXPos($iXTroop) ; return x diff between lightning spell border and target position $iXTroop or 9999 when not found
	Local $aCoor = [114, 362, 740, 575]
	Local $sDirectory = "lab-lspell-bundle"
	Local $sReturnProps = "objectpoints"
	Local $result = ""
	Local $aPosXY[0]
	Local $iDiffBorder = 23

	If $g_bDebugImageSave Then DebugImageSave("CheckXPos")
	_CaptureRegion2($aCoor[0], $aCoor[1], $aCoor[2], $aCoor[3])

	$result = findMultiple($sDirectory, "FV", "FV", 0, 0, 1, $sReturnProps, False)
	If IsArray($result) then
		$aPosXY = StringSplit(($result[0])[0], ",", $STR_NOCOUNT) ; get x,y
		Local $iRBorder = Int(Number($aPosXY[0])) - $iDiffBorder
		Local $iABorder = $iRBorder + $aCoor[0]
		Local $iXDiff = $iXTroop - $iABorder
		If $g_bDebugSetlog Then
			Setlog("CheckXPos: " & $aPosXY[0] & " - " & $iDiffBorder & " = " & $iRBorder & " relative icon border", $COLOR_DEBUG)
			Setlog("CheckXPos: " & $iRBorder & " + " & $aCoor[0] & " = " & $iABorder & " absolute icon border", $COLOR_DEBUG)
			Setlog("CheckXPos: " & $iXTroop & " - " & $iABorder & " = " & $iXDiff & " differences to target icon border", $COLOR_DEBUG)
		EndIf
		Return $iXDiff
	Else
		If $g_bDebugSetlog Then SetLog("CheckXPos: detected X = NOT Found" , $COLOR_DEBUG)
		Return 9999
	EndIf
EndFunc   ;==>CheckXPos

Func DebugIconSave($sTxtName = "Unknown", $iLeft = 0, $iTop = 0) ; Debug Code to save images before zapping for later review, time stamped to align with logfile!
	SetLog("Taking debug icon snapshot for later review", $COLOR_SUCCESS)
	Local $iIconLength = 94
	Local $Date = @MDAY & "_" & @MON & "_" & @YEAR
	Local $Time = @HOUR & "_" & @MIN & "_" & @SEC
	Local $sName =  $g_sProfileTempDebugPath & "LabUpgrade\" & $sTxtName & "_" & $Date & "_" & $Time & ".png"
	DirCreate($g_sProfileTempDebugPath & "LabUpgrade\")
	ForceCaptureRegion()
	_CaptureRegion($iLeft, $iTop, $iLeft + $iIconLength, $iTop + $iIconLength)
	_GDIPlus_ImageSaveToFile($g_hBitmap, $sName)
	If @error Then SetLog("DebugIconSave failed to save LabUpgrade image: " & $sName, $COLOR_WARNING)
	If _Sleep($DELAYLABORATORY2) Then Return
EndFunc   ;==>DebugIconSave

Func LabTroopImages($iStart, $iEnd) ; Debug function to record pixel values for troops
	If $g_bDebugImageSave Then DebugImageSave("LabUpgrade")
	For $i = $iStart To $iEnd
		DebugIconSave($g_avLabTroops[$i][3], $g_avLabTroops[$i][0], $g_avLabTroops[$i][1])
		SetDebugLog($g_avLabTroops[$i][3], $COLOR_WARNING)
		SetDebugLog("_GetPixelColor(+47, +1): " & _GetPixelColor($g_avLabTroops[$i][0] + 47, $g_avLabTroops[$i][1] + 1, True) & ":D3D3CB =Not unlocked", $COLOR_DEBUG)
		SetDebugLog("_GetPixelColor(+68, +79): " & _GetPixelColor($g_avLabTroops[$i][0] + 68, $g_avLabTroops[$i][1] + 79, True) & ":FD877E =No Loot1", $COLOR_DEBUG)
		SetDebugLog("_GetPixelColor(+68, +82): " & _GetPixelColor($g_avLabTroops[$i][0] + 68, $g_avLabTroops[$i][1] + 84, True) & ":FD877E =No Loot2", $COLOR_DEBUG)
		SetDebugLog("_GetPixelColor(+81, +82): " & _GetPixelColor($g_avLabTroops[$i][0] + 81, $g_avLabTroops[$i][1] + 82, True) & ":XXXXXX =Loot type", $COLOR_DEBUG)
		SetDebugLog("_GetPixelColor(+76, +76): " & _GetPixelColor($g_avLabTroops[$i][0] + 76, $g_avLabTroops[$i][1] + 76, True) & ":FFFFFF =Max L", $COLOR_DEBUG)
		SetDebugLog("_GetPixelColor(+76, +80): " & _GetPixelColor($g_avLabTroops[$i][0] + 76, $g_avLabTroops[$i][1] + 80, True) & ":FFFFFF =Max L", $COLOR_DEBUG)
		SetDebugLog("_GetPixelColor(+0, +20): " & _GetPixelColor($g_avLabTroops[$i][0] + 0, $g_avLabTroops[$i][1] + 20, True) & ":838383 =Lab Upgrade", $COLOR_DEBUG)
		SetDebugLog("_GetPixelColor(+93, +20): " & _GetPixelColor($g_avLabTroops[$i][0] + 93, $g_avLabTroops[$i][1] + 20, True) & ":838383 =Lab Upgrade", $COLOR_DEBUG)
		SetDebugLog("_GetPixelColor(+8, +59): " & _GetPixelColor($g_avLabTroops[$i][0] + 23, $g_avLabTroops[$i][1] + 60, True) & ":FFC360 =Max troop", $COLOR_DEBUG)
	Next
EndFunc   ;==>LabTroopImages
