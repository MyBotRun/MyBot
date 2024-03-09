; #FUNCTION# ====================================================================================================================
; Name ..........: StarLaboratory
; Description ...:
; Syntax ........: StarLaboratory()
; Parameters ....:
; Return values .: None
; Author ........: TripleM
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global Const $sStarColorNA = Hex(0xD3D3CB, 6) ; relative location: 47,1; Troop not unlocked in Lab, beige pixel in center just below edge for troop
Global Const $sStarColorNoLoot = Hex(0xFF7B72, 6) ; relative location: 67,79 & 67,82; Not enough loot available to upgrade, find pink pixel in value
Global Const $sStarColorMaxLvl = Hex(0xFFFFFF, 6) ; relative location: 76,76 & 76,80; Upgrade already at MAX level, white in last "l"
Global Const $sStarColorLabUgReq = Hex(0x757575, 6) ; relative location: 0,20 or 93,20 lab upgrade required, Look for Gray pixel inside left border
Global Const $sStarColorMaxTroop = Hex(0xFFC360, 6) ; relative location: 23,60; troop already MAX
Global Const $sStarColorBG = Hex(0xD3D3CB, 6) ; background color in laboratory

Func TestStarLaboratory()
	Local $bWasRunState = $g_bRunState
	Local $sWasStarLabUpgradeTime = $g_sStarLabUpgradeTime
	Local $bWasStarLabUpgradeEnable = $g_bAutoStarLabUpgradeEnable
	$g_bRunState = True
	$g_bAutoStarLabUpgradeEnable = True
	$g_sStarLabUpgradeTime = ""
	Local $Result = StarLaboratory(True)
	$g_bRunState = $bWasRunState
	$g_sStarLabUpgradeTime = $sWasStarLabUpgradeTime
	$g_bAutoStarLabUpgradeEnable = $bWasStarLabUpgradeEnable
	Return $Result
EndFunc   ;==>TestStarLaboratory

Func StarLaboratory($bTestRun = False)

	If Not $g_bAutoStarLabUpgradeEnable Then Return ; Lab upgrade not enabled.

	;Create local array to hold upgrade values
	Local $aUpgradeValue[13] = [-1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	Local $iAvailElixir, $sElixirCount, $TimeDiff, $aArray, $Result, $aSearchForTroop
	Local $iSelectedUpgrade = $g_iCmbStarLaboratory

	If $g_sStarLabUpgradeTime <> "" Then $TimeDiff = _DateDiff("n", _NowCalc(), $g_sStarLabUpgradeTime) ; what is difference between end time and now in minutes?
	If @error Then _logErrorDateDiff(@error)
	If $g_bDebugSetlog Then SetDebugLog($g_avStarLabTroops[$g_iCmbStarLaboratory][3] & " Lab end time: " & $g_sStarLabUpgradeTime & ", DIFF= " & $TimeDiff, $COLOR_DEBUG)

	If Not $g_bRunState Then Return
	If $TimeDiff <= 0 Then
		SetLog("Checking Troop Upgrade in Star Laboratory", $COLOR_INFO)
	Else
		SetLog("Star Laboratory Upgrade in progress, waiting for completion", $COLOR_INFO)
		Return False
	EndIf

	$sElixirCount = getResourcesMainScreen(705, 74)
	SetLog("Updating village values [E]: " & $sElixirCount, $COLOR_SUCCESS)
	$iAvailElixir = Number($sElixirCount)

	If Not LocateStarLab() Then Return False

	; Find Research Button
	Local $aResearchButton = findButton("Research", Default, 1, True)
	If IsArray($aResearchButton) And UBound($aResearchButton, 1) = 2 Then
		If $g_bDebugImageSave Then SaveDebugImage("StarLabUpgrade") ; Debug Only
		ClickP($aResearchButton)
		If _Sleep($DELAYLABORATORY1) Then Return ; Wait for window to open
	Else
		SetLog("Cannot find the Star Laboratory Research Button!", $COLOR_ERROR)
		ClickAway()
		Return False
	EndIf

	; Lab window coor correction
	Local $aiCloseBtn = findButton("CloseWindow")
	If Not IsArray($aiCloseBtn) Then
		SetLog("Trouble finding lab close button, try again...", $COLOR_WARNING)
		CloseWindow()
		Return False
	EndIf

	; check for upgrade in process - Look for light green in upper right corner of lab window.
	If _ColorCheck(_GetPixelColor(790, 120 + $g_iMidOffsetY, True), Hex(0xA2CB6C, 6), 20) Then
		SetLog("Laboratory Upgrade in progress, waiting for completion", $COLOR_INFO)
		If _Sleep($DELAYLABORATORY2) Then Return
		; upgrade in process and time not recorded so update completion time!
		Local $sLabTimeOCR = getRemainTLaboratory(220, 200 + $g_iMidOffsetY)
		Local $iLabFinishTime = ConvertOCRTime("Lab Time", $sLabTimeOCR, False)
		SetDebugLog("$sLabTimeOCR: " & $sLabTimeOCR & ", $iLabFinishTime = " & $iLabFinishTime & " m")
		If $iLabFinishTime > 0 Then
			$g_sStarLabUpgradeTime = _DateAdd('n', Ceiling($iLabFinishTime), _NowCalc())
			If @error Then _logErrorDateAdd(@error)
			SetLog("Research will finish in " & $sLabTimeOCR & " (" & $g_sStarLabUpgradeTime & ")")
			$iStarLabFinishTimeMod = $iLabFinishTime
			If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save") ; saving $asStarLabUpgradeTime[$g_iCurAccount] = $g_sStarLabUpgradeTime for instantly displaying in multi-stats
			StarLabStatusGUIUpdate() ; Update GUI flag
		ElseIf $g_bDebugSetlog Then
			SetLog("Invalid getRemainTLaboratory OCR", $COLOR_DEBUG)
		EndIf
		CloseWindow()
		Return False
	EndIf

	; reset lab troop positions to default
	For $i = 1 To UBound($g_avStarLabTroops) - 1
		$g_avStarLabTroops[$i][0] = -1
		$g_avStarLabTroops[$i][1] = -1
	Next
	; find upgradeable troops by elixir image
	$aSearchForTroop = decodeMultipleCoords(findImage("TroopPositions", $g_sImgStarLabElex, GetDiamondFromRect2(30, 345 + $g_iMidOffsetY, 790, 590 + $g_iMidOffsetY), 0, True, Default))
	If IsArray($aSearchForTroop) And UBound($aSearchForTroop, 1) > 0 Then
		For $i = 0 To UBound($aSearchForTroop) - 1
			Local $aTempArray = $aSearchForTroop[$i]
			If IsArray($aTempArray) And UBound($aTempArray) = 2 Then
				Local $iCurrentTroop = 2 * Int(($aTempArray[0] - 90) / 127) + Int(($aTempArray[1] - 375) / 127) + 1 ; calculating troop index from found elixir coords
				$g_avStarLabTroops[$iCurrentTroop][0] = $aTempArray[0] - 98 ; setting troop position relativ to found elixir coords
				$g_avStarLabTroops[$iCurrentTroop][1] = $aTempArray[1] - 101 ; setting troop position relativ to found elixir coords
				If $g_bDebugSetlog Then
					Setlog("New icon X position of " & $g_avStarLabTroops[$iCurrentTroop][3] & " : " & $g_avStarLabTroops[$iCurrentTroop][0], $COLOR_DEBUG)
					Setlog("New icon Y position of " & $g_avStarLabTroops[$iCurrentTroop][3] & " : " & $g_avStarLabTroops[$iCurrentTroop][1], $COLOR_DEBUG)
				EndIf
			EndIf
		Next
	Else
		SetLog("No upgradable troop found!", $COLOR_ERROR)
		CloseWindow()
		Return False
	EndIf

	If $g_bDebugSetlog Then StarLabTroopImages(1, 10)
	For $i = 1 To UBound($aUpgradeValue) - 1
		If $g_avStarLabTroops[$i][0] = -1 Or $g_avStarLabTroops[$i][1] = -1 Then
			$aUpgradeValue[$i] = -1
			If $g_bDebugSetlog Then SetLog($g_avStarLabTroops[$i][3] & " is not upgradeable, now = " & $aUpgradeValue[$i], $COLOR_DEBUG)
		Else
			$aUpgradeValue[$i] = getStarLabUpgrdResourceRed($g_avStarLabTroops[$i][0] + 2, $g_avStarLabTroops[$i][1] + 93)
			If $g_bDebugSetlog Then SetLog($g_avStarLabTroops[$i][3] & " Red text upgrade value = " & $aUpgradeValue[$i], $COLOR_DEBUG)
			If $aUpgradeValue[$i] = "" Or Int($aUpgradeValue[$i]) < 3000 Then ; check if blank or below min value for any upgrade
				$aUpgradeValue[$i] = getLabUpgrdResourceWht($g_avStarLabTroops[$i][0] + 2, $g_avStarLabTroops[$i][1] + 93)
				If $g_bDebugSetlog Then SetLog($g_avStarLabTroops[$i][3] & " White text upgrade value = " & $aUpgradeValue[$i], $COLOR_DEBUG)
			EndIf
			If $aUpgradeValue[$i] = "" Or Int($aUpgradeValue[$i]) < 3000 Then ; check if blank or below min value for any upgrade
				$aUpgradeValue[$i] = 0
				If $g_bDebugSetlog Then SetLog("Failed to read cost of " & $g_avStarLabTroops[$i][3], $COLOR_DEBUG)
				StarLabTroopImages($i, $i) ; Make Troop capture, when elixir icon was found, but cost not
			EndIf
		EndIf
		If Not $g_bRunState Then Return
		$aUpgradeValue[$i] = Number($aUpgradeValue[$i])
	Next

	If $aUpgradeValue[$g_iCmbStarLaboratory] = -1 Then
		Local $iCheapestCost = 0
		If $g_iCmbStarLaboratory = 0 Then
			SetLog("No dedicated troop for upgrade selected.", $COLOR_INFO)
		Else
			SetLog("No upgrade for " & $g_avStarLabTroops[$g_iCmbStarLaboratory][3] & " available.", $COLOR_INFO)
		EndIf
		For $i = 1 To UBound($aUpgradeValue) - 1
			If $aUpgradeValue[$i] > 0 Then ; is upgradeable
				If $g_bDebugSetlog Then SetLog($g_avStarLabTroops[$i][3] & " is upgradeable, Value = " & $aUpgradeValue[$i], $COLOR_DEBUG)
				If $iCheapestCost = 0 Or $aUpgradeValue[$i] < $iCheapestCost Then
					$iSelectedUpgrade = $i
					$iCheapestCost = $aUpgradeValue[$i]
				EndIf
			EndIf
		Next
		If $g_iCmbStarLaboratory = $iSelectedUpgrade Then
			SetLog("No alternate troop for upgrade found", $COLOR_WARNING)
			CloseWindow()
			Return False
		Else
			SetLog($g_avStarLabTroops[$iSelectedUpgrade][3] & " selected for upgrade, upgrade cost = " & _NumberFormat($aUpgradeValue[$iSelectedUpgrade], True), $COLOR_INFO)
		EndIf
	EndIf

	; Try to upgrade - LabUpgrade(), check insufficient resource first
	If $iAvailElixir < $aUpgradeValue[$iSelectedUpgrade] Then
		SetLog("Insufficent Elixir for " & $g_avStarLabTroops[$iSelectedUpgrade][3] & ", Lab requires: " & _NumberFormat($aUpgradeValue[$iSelectedUpgrade], True) & ", available: " & _NumberFormat($iAvailElixir, True), $COLOR_INFO)
		CloseWindow()
		Return False
	ElseIf StarLabUpgrade($iSelectedUpgrade, $bTestRun) = True Then
		SetLog("Elixir used = " & _NumberFormat($aUpgradeValue[$iSelectedUpgrade], True), $COLOR_INFO)
		If _Sleep(1500) Then Return
		ClickAway()
		Return True
	EndIf

	ClickAway()
	Return False

EndFunc   ;==>StarLaboratory
;
Func StarLabUpgrade($iSelectedUpgrade, $bTestRun = False)
	Local $StartTime, $EndTime, $EndPeriod, $Result, $TimeAdd = 0
	Select
		Case _ColorCheck(_GetPixelColor($g_avStarLabTroops[$iSelectedUpgrade][0] + 47, $g_avStarLabTroops[$iSelectedUpgrade][1] + 1, True), $sStarColorNA, 20) = True
			; check for beige pixel in center just below edge for troop not unlocked
			SetLog($g_avStarLabTroops[$iSelectedUpgrade][3] & " not unlocked yet, select another troop", $COLOR_WARNING)
			If _Sleep($DELAYLABUPGRADE2) Then Return

		Case _PixelSearch($g_avStarLabTroops[$iSelectedUpgrade][0] + 66, $g_avStarLabTroops[$iSelectedUpgrade][1] + 79, $g_avStarLabTroops[$iSelectedUpgrade][0] + 68, $g_avStarLabTroops[$iSelectedUpgrade][1] + 82, $sStarColorNoLoot, 20) <> 0
			; Check for Pink pixels last zero of loot value to see if enough loot is available.
			; this case should never be run if value check is working right!
			SetLog("Value check error and Not enough Loot to upgrade " & $g_avStarLabTroops[$iSelectedUpgrade][3] & "...", $COLOR_ERROR)
			If _Sleep($DELAYLABUPGRADE2) Then Return

		Case _ColorCheck(_GetPixelColor($g_avStarLabTroops[$iSelectedUpgrade][0] + 22, $g_avStarLabTroops[$iSelectedUpgrade][1] + 60, True), Hex(0xFFC360, 6), 20) = True
			; Look for Golden pixel inside level indicator for max troops
			SetLog($g_avStarLabTroops[$iSelectedUpgrade][3] & " already max level, select another troop", $COLOR_ERROR)
			If _Sleep($DELAYLABUPGRADE2) Then Return

		Case _ColorCheck(_GetPixelColor($g_avStarLabTroops[$iSelectedUpgrade][0] + 3, $g_avStarLabTroops[$iSelectedUpgrade][1] + 19, True), Hex(0xB7B7B7, 6), 20) = True
			; Look for Gray pixel inside left border if Lab upgrade required or if we missed that upgrade is in process
			SetLog("Laboratory upgrade not available now for " & $g_avStarLabTroops[$iSelectedUpgrade][3] & "...", $COLOR_ERROR)
			If _Sleep($DELAYLABUPGRADE2) Then Return

		Case Else
			; If none of other error conditions apply, begin upgrade process
			Click($g_avStarLabTroops[$iSelectedUpgrade][0] + 45, $g_avStarLabTroops[$iSelectedUpgrade][1] + 55, 1, 0, "#0200") ; Click Upgrade troop button
			If _Sleep($DELAYLABUPGRADE1) Then Return ; Wait for window to open
			If $g_bDebugImageSave Then SaveDebugImage("StarLabUpgrade")

			; double check if maxed?
			If _ColorCheck(_GetPixelColor(258, 192, True), Hex(0xFF1919, 6), 20) And _ColorCheck(_GetPixelColor(272, 194, True), Hex(0xFF1919, 6), 20) Then
				SetLog($g_avStarLabTroops[$iSelectedUpgrade][3] & " Previously maxxed, select another troop", $COLOR_ERROR) ; oops, we found the red warning message
				If _Sleep($DELAYLABUPGRADE2) Then Return
				ClickAway()
				Return False
			EndIf

			; double check enough elixir?
			If _PixelSearch($g_avStarLabTroops[$iSelectedUpgrade][0] + 67, $g_avStarLabTroops[$iSelectedUpgrade][1] + 98, $g_avStarLabTroops[$iSelectedUpgrade][0] + 69, $g_avStarLabTroops[$iSelectedUpgrade][0] + 103, $sStarColorNoLoot, 20) <> 0 Then ; Check for Red Zero = means not enough loot!
				SetLog("Missing Loot to upgrade " & $g_avStarLabTroops[$iSelectedUpgrade][3] & " (secondary check after Upgrade Value read failed)", $COLOR_ERROR)
				If _Sleep($DELAYLABUPGRADE2) Then Return
				ClickAway()
				Return False
			EndIf

			; triple check for upgrade in process by gray upgrade button
			If _ColorCheck(_GetPixelColor(460, 592 + $g_iMidOffsetY, True), Hex(0x848480, 6), 20) And _ColorCheck(_GetPixelColor(566, 592 + $g_iMidOffsetY, True), Hex(0x848480, 6), 20) Then
				SetLog("Upgrade in progress, waiting for completion of other troops", $COLOR_WARNING)
				If _Sleep($DELAYLABORATORY2) Then Return
				ClickAway()
				Return False
			Else
				; get upgrade time from window
				$Result = getLabUpgradeTime(590, 493 + $g_iMidOffsetY) ; Try to read white text showing time for upgrade
				Local $iLabFinishTime = ConvertOCRTime("Lab Time", $Result, False)
				SetDebugLog($g_avStarLabTroops[$iSelectedUpgrade][3] & " Upgrade OCR Time = " & $Result & ", $iLabFinishTime = " & $iLabFinishTime & " m", $COLOR_INFO)
				$StartTime = _NowCalc() ; what is date:time now
				If $g_bDebugSetlog Then SetDebugLog($g_avStarLabTroops[$iSelectedUpgrade][3] & " Upgrade Started @ " & $StartTime, $COLOR_SUCCESS)
				If $iLabFinishTime > 0 Then
					$g_sStarLabUpgradeTime = _DateAdd('n', Ceiling($iLabFinishTime), $StartTime)
					SetLog($g_avStarLabTroops[$iSelectedUpgrade][3] & " Upgrade Finishes @ " & $Result & " (" & $g_sStarLabUpgradeTime & ")", $COLOR_SUCCESS)
					$iStarLabFinishTimeMod = $iLabFinishTime
					If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save") ; saving $asStarLabUpgradeTime[$g_iCurAccount] = $g_sStarLabUpgradeTime for instantly displaying in multi-stats
				Else
					SetLog("Error processing upgrade time required, try again!", $COLOR_WARNING)
					Return False
				EndIf

				If Not $bTestRun Then
					Click(695, 580 + $g_iMidOffsetY, 1, 0, "#0202") ; Everything is good - Click the upgrade button
					If $iSelectedUpgrade = $g_iCmbStarLaboratory Then
						;HArchH When upgraded user's choice, reset to "Any" for the next time.
						$g_iCmbStarLaboratory = 0 ; Reset user choice to "Any".
						_GUICtrlComboBox_SetCurSel($g_hCmbStarLaboratory, $g_iCmbStarLaboratory)
						_GUICtrlSetImage($g_hPicStarLabUpgrade, $g_sLibIconPath, $g_avStarLabTroops[$g_iCmbStarLaboratory][4]) ; Set the corresponding image.
						SetLog("Upgraded user's choice. Resetting to Any.", $COLOR_INFO)
						SaveBuildingConfig() ;Preserve the "Any" value.
						If _Sleep($DELAYLABUPGRADE1) Then Return
					EndIf
				EndIf
			EndIf

			If isGemOpen(True) = False Then ; check for gem window
				; check for green button to use gems to finish upgrade, checking if upgrade actually started
				If Not (_ColorCheck(_GetPixelColor(660, 185 + $g_iMidOffsetY, True), Hex(0x6DBC1F, 6), 15) Or _ColorCheck(_GetPixelColor(720, 185 + $g_iMidOffsetY, True), Hex(0x6DBC1F, 6), 15)) Then
					SetLog("Something went wrong with " & $g_avStarLabTroops[$iSelectedUpgrade][3] & " Upgrade, try again.", $COLOR_ERROR)
					ClickAway()
					Return False
				EndIf
				SetLog("Upgrade " & $g_avStarLabTroops[$iSelectedUpgrade][3] & " in your star laboratory started with success...", $COLOR_SUCCESS)
				StarLabStatusGUIUpdate()
				PushMsg("StarLabSuccess")
				If _Sleep($DELAYLABUPGRADE2) Then Return
				CloseWindow()
				Return True
			Else
				SetLog("Oops, Gems required for " & $g_avStarLabTroops[$iSelectedUpgrade][3] & " Upgrade, try again.", $COLOR_ERROR)
			EndIf
	EndSelect
	ClickAway()
	Return False
EndFunc   ;==>StarLabUpgrade

Func StarDebugIconSave($sTxtName = "Unknown", $iLeft = 0, $iTop = 0) ; Debug Code to save images before zapping for later review, time stamped to align with logfile!
	SetLog("Taking debug icon snapshot for later review", $COLOR_SUCCESS)
	Local $iIconLength = 94
	Local $Date = @MDAY & "_" & @MON & "_" & @YEAR
	Local $Time = @HOUR & "_" & @MIN & "_" & @SEC
	Local $sName = $g_sProfileTempDebugPath & "StarLabUpgrade\" & $sTxtName & "_" & $Date & "_" & $Time & ".png"
	DirCreate($g_sProfileTempDebugPath & "StarLabUpgrade\")
	ForceCaptureRegion()
	_CaptureRegion($iLeft, $iTop, $iLeft + $iIconLength, $iTop + $iIconLength)
	_GDIPlus_ImageSaveToFile($g_hBitmap, $sName)
	If @error Then SetLog("DebugIconSave failed to save StarLabUpgrade image: " & $sName, $COLOR_WARNING)
	If _Sleep($DELAYLABORATORY2) Then Return
EndFunc   ;==>StarDebugIconSave

Func StarLabTroopImages($iStart, $iEnd) ; Debug function to record pixel values for troops
	If $g_bDebugImageSave Then SaveDebugImage("StarLabUpgrade")
	For $i = $iStart To $iEnd
		If $g_avStarLabTroops[$i][0] <> -1 And $g_avStarLabTroops[$i][1] <> -1 Then
			StarDebugIconSave($g_avStarLabTroops[$i][3], $g_avStarLabTroops[$i][0], $g_avStarLabTroops[$i][1])
			SetDebugLog($g_avStarLabTroops[$i][3], $COLOR_WARNING)
			SetDebugLog("_GetPixelColor(+47, +1): " & _GetPixelColor($g_avStarLabTroops[$i][0] + 47, $g_avStarLabTroops[$i][1] + 1, True) & ":" & $sStarColorNA & " =Not unlocked", $COLOR_DEBUG)
			SetDebugLog("_GetPixelColor(+67, +79): " & _GetPixelColor($g_avStarLabTroops[$i][0] + 67, $g_avStarLabTroops[$i][1] + 79, True) & ":" & $sStarColorNoLoot & " =No Loot1", $COLOR_DEBUG)
			SetDebugLog("_GetPixelColor(+67, +82): " & _GetPixelColor($g_avStarLabTroops[$i][0] + 67, $g_avStarLabTroops[$i][1] + 82, True) & ":" & $sStarColorNoLoot & " =No Loot2", $COLOR_DEBUG)
			SetDebugLog("_GetPixelColor(+81, +82): " & _GetPixelColor($g_avStarLabTroops[$i][0] + 81, $g_avStarLabTroops[$i][1] + 82, True) & ":XXXXXX =Loot type", $COLOR_DEBUG)
			SetDebugLog("_GetPixelColor(+76, +76): " & _GetPixelColor($g_avStarLabTroops[$i][0] + 76, $g_avStarLabTroops[$i][1] + 76, True) & ":" & $sStarColorMaxLvl & " =Max L", $COLOR_DEBUG)
			SetDebugLog("_GetPixelColor(+76, +80): " & _GetPixelColor($g_avStarLabTroops[$i][0] + 76, $g_avStarLabTroops[$i][1] + 80, True) & ":" & $sStarColorMaxLvl & " =Max L", $COLOR_DEBUG)
			SetDebugLog("_GetPixelColor(+0, +20): " & _GetPixelColor($g_avStarLabTroops[$i][0] + 0, $g_avStarLabTroops[$i][1] + 20, True) & ":" & $sStarColorLabUgReq & " =Lab Upgrade", $COLOR_DEBUG)
			SetDebugLog("_GetPixelColor(+93, +20): " & _GetPixelColor($g_avStarLabTroops[$i][0] + 93, $g_avStarLabTroops[$i][1] + 20, True) & ":" & $sStarColorLabUgReq & " =Lab Upgrade", $COLOR_DEBUG)
			SetDebugLog("_GetPixelColor(+23, +60): " & _GetPixelColor($g_avStarLabTroops[$i][0] + 23, $g_avStarLabTroops[$i][1] + 60, True) & ":" & $sStarColorMaxTroop & " =Max troop", $COLOR_DEBUG)
		EndIf
	Next
EndFunc   ;==>StarLabTroopImages

Func LocateStarLab()
	; Zoomout before locating
	ZoomOut()

	If $g_aiStarLaboratoryPos[0] > 0 And $g_aiStarLaboratoryPos[1] > 0 Then
		BuildingClickP($g_aiStarLaboratoryPos, "#0197")
		If _Sleep($DELAYLABORATORY1) Then Return ; Wait for description to popup

		Local $aResult = BuildingInfo(242, 468 + $g_iBottomOffsetY) ; Get building name and level with OCR
		If $aResult[0] = 2 Then ; We found a valid building name
			If StringInStr($aResult[1], "Lab") = True Then ; we found the Star Laboratory
				SetLog("Star Laboratory located.", $COLOR_INFO)
				SetLog("It reads as Level " & $aResult[2] & ".", $COLOR_INFO)
				Return True
			Else
				ClickAway()
				SetDebugLog("Stored Star Laboratory Position is not valid.", $COLOR_ERROR)
				SetDebugLog("Found instead: " & $aResult[1] & ", " & $aResult[2] & " !", $COLOR_DEBUG)
				SetDebugLog("Village position: " & $g_aiStarLaboratoryPos[0] & ", " & $g_aiStarLaboratoryPos[1], $COLOR_DEBUG, True)
				ConvertToVillagePos($g_aiStarLaboratoryPos[0], $g_aiStarLaboratoryPos[1])
				SetDebugLog("Real position: " & $g_aiStarLaboratoryPos[0] & ", " & $g_aiStarLaboratoryPos[1], $COLOR_DEBUG, True)
				$g_aiStarLaboratoryPos[0] = -1
				$g_aiStarLaboratoryPos[1] = -1
			EndIf
		Else
			ClickAway()
			SetDebugLog("Stored Star Laboratory Position is not valid.", $COLOR_ERROR)
			SetDebugLog("Village position: " & $g_aiStarLaboratoryPos[0] & ", " & $g_aiStarLaboratoryPos[1], $COLOR_DEBUG, True)
			ConvertToVillagePos($g_aiStarLaboratoryPos[0], $g_aiStarLaboratoryPos[1])
			SetDebugLog("Real position: " & $g_aiStarLaboratoryPos[0] & ", " & $g_aiStarLaboratoryPos[1], $COLOR_DEBUG, True)
			$g_aiStarLaboratoryPos[0] = -1
			$g_aiStarLaboratoryPos[1] = -1
		EndIf
	EndIf

	SetLog("Looking for Star Laboratory...", $COLOR_ACTION)

	Local $sCocDiamond = $CocDiamondDCD
	Local $sRedLines = $sCocDiamond
	Local $iMinLevel = 0
	Local $iMaxLevel = 1000
	Local $iMaxReturnPoints = 1
	Local $sReturnProps = "objectname,objectpoints"
	Local $bForceCapture = True

	; DETECTION IMGLOC
	Local $aResult = findMultiple($g_sImgStarLaboratory, $sCocDiamond, $sRedLines, $iMinLevel, $iMaxLevel, $iMaxReturnPoints, $sReturnProps, $bForceCapture)
	If IsArray($aResult) And UBound($aResult) > 0 Then ; we have an array with data of images found
		For $i = 0 To UBound($aResult) - 1
			If _Sleep(50) Then Return ; just in case on PAUSE
			If Not $g_bRunState Then Return ; Stop Button
			SetDebugLog(_ArrayToString($aResult[$i]))
			Local $aTEMP = $aResult[$i]
			Local $sObjectname = String($aTEMP[0])
			SetDebugLog("Image name: " & String($aTEMP[0]), $COLOR_INFO)
			Local $aObjectpoints = $aTEMP[1] ; number of  objects returned
			SetDebugLog("Object points: " & String($aTEMP[1]), $COLOR_INFO)
			If StringInStr($aObjectpoints, "|") Then
				$aObjectpoints = StringReplace($aObjectpoints, "||", "|")
				Local $sString = StringRight($aObjectpoints, 1)
				If $sString = "|" Then $aObjectpoints = StringTrimRight($aObjectpoints, 1)
				Local $tempObbjs = StringSplit($aObjectpoints, "|", $STR_NOCOUNT) ; several detected points
				For $j = 0 To UBound($tempObbjs) - 1
					; Test the coordinates
					Local $tempObbj = StringSplit($tempObbjs[$j], ",", $STR_NOCOUNT) ;  will be a string : 708,360
					If UBound($tempObbj) = 2 Then
						$g_aiStarLaboratoryPos[0] = Number($tempObbj[0]) + 9
						$g_aiStarLaboratoryPos[1] = Number($tempObbj[1]) + 15
						ConvertFromVillagePos($g_aiStarLaboratoryPos[0], $g_aiStarLaboratoryPos[1])
						ExitLoop 2
					EndIf
				Next
			Else
				; Test the coordinate
				Local $tempObbj = StringSplit($aObjectpoints, ",", $STR_NOCOUNT) ;  will be a string : 708,360
				If UBound($tempObbj) = 2 Then
					$g_aiStarLaboratoryPos[0] = Number($tempObbj[0]) + 9
					$g_aiStarLaboratoryPos[1] = Number($tempObbj[1]) + 15
					ConvertFromVillagePos($g_aiStarLaboratoryPos[0], $g_aiStarLaboratoryPos[1])
					ExitLoop
				EndIf
			EndIf
		Next
	EndIf

	If $g_aiStarLaboratoryPos[0] > 0 And $g_aiStarLaboratoryPos[1] > 0 Then
		BuildingClickP($g_aiStarLaboratoryPos, "#0197")
		If _Sleep($DELAYLABORATORY1) Then Return ; Wait for description to popup

		Local $aResult = BuildingInfo(242, 468 + $g_iBottomOffsetY) ; Get building name and level with OCR
		If $aResult[0] = 2 Then ; We found a valid building name
			If StringInStr($aResult[1], "Lab") = True Then ; we found the Star Laboratory
				SetLog("Star Laboratory located.", $COLOR_INFO)
				SetLog("It reads as Level " & $aResult[2] & ".", $COLOR_INFO)
				Return True
			Else
				ClickAway()
				SetDebugLog("Found Star Laboratory Position is not valid.", $COLOR_ERROR)
				SetDebugLog("Found instead: " & $aResult[1] & ", " & $aResult[2] & " !", $COLOR_DEBUG)
				SetDebugLog("Village position: " & $g_aiStarLaboratoryPos[0] & ", " & $g_aiStarLaboratoryPos[1], $COLOR_DEBUG, True)
				ConvertToVillagePos($g_aiStarLaboratoryPos[0], $g_aiStarLaboratoryPos[1])
				SetDebugLog("Real position: " & $g_aiStarLaboratoryPos[0] & ", " & $g_aiStarLaboratoryPos[1], $COLOR_DEBUG, True)
				$g_aiStarLaboratoryPos[0] = -1
				$g_aiStarLaboratoryPos[1] = -1
			EndIf
		Else
			ClickAway()
			SetDebugLog("Found Star Laboratory Position is not valid.", $COLOR_ERROR)
			SetDebugLog("Village position: " & $g_aiStarLaboratoryPos[0] & ", " & $g_aiStarLaboratoryPos[1], $COLOR_DEBUG, True)
			ConvertToVillagePos($g_aiStarLaboratoryPos[0], $g_aiStarLaboratoryPos[1])
			SetDebugLog("Real position: " & $g_aiStarLaboratoryPos[0] & ", " & $g_aiStarLaboratoryPos[1], $COLOR_DEBUG, True)
			$g_aiStarLaboratoryPos[0] = -1
			$g_aiStarLaboratoryPos[1] = -1
		EndIf
	EndIf

	SetLog("Can not find Star Laboratory.", $COLOR_ERROR)
	Return False
EndFunc   ;==>LocateStarLab

Func StarLabGuiDisplay()

	Local Static $iLastTimeChecked[8]
	If $g_bFirstStart Then $iLastTimeChecked[$g_iCurAccount] = ""

	; Check if is a valid date and Calculated the number of minutes from remain time Lab and now
	If _DateIsValid($g_sStarLabUpgradeTime) And _DateIsValid($iLastTimeChecked[$g_iCurAccount]) Then
		Local $iStarLabTime = _DateDiff('n', _NowCalc(), $g_sStarLabUpgradeTime)
		Local $iLastCheck = _DateDiff('n', $iLastTimeChecked[$g_iCurAccount], _NowCalc()) ; elapse time from last check (minutes)
		SetDebugLog("Star Lab UpgradeTime: " & $g_sStarLabUpgradeTime & ", Star Lab DateCalc: " & $iStarLabTime)
		SetDebugLog("Star Lab LastCheck: " & $iLastTimeChecked[$g_iCurAccount] & ", Check DateCalc: " & $iLastCheck)
		; A check each 6 hours [6*60 = 360] or when Lab research time finishes
		If $iStarLabTime > 0 And $iLastCheck <= 360 Then Return
	EndIf

	If Not LocateStarLab() Then Return False

	; Find Research Button
	Local $aResearchButton = findButton("Research", Default, 1, True)
	If IsArray($aResearchButton) And UBound($aResearchButton, 1) = 2 Then
		If $g_bDebugImageSave Then SaveDebugImage("StarLabUpgrade") ; Debug Only
		ClickP($aResearchButton)
		If _Sleep($DELAYLABORATORY1) Then Return ; Wait for window to open
	Else
		SetLog("Cannot find the Star Laboratory Research Button!", $COLOR_ERROR)
		ClickAway()
		Return False
	EndIf

	$iLastTimeChecked[$g_iCurAccount] = _NowCalc()

	; Lab window coor correction
	Local $aiCloseBtn = findButton("CloseWindow")
	If Not IsArray($aiCloseBtn) Then
		SetLog("Trouble finding lab close button, try again...", $COLOR_WARNING)
		CloseWindow()
		Return False
	EndIf

	; check for upgrade in process - Look for light green in upper right corner of lab window.
	If _ColorCheck(_GetPixelColor(790, 120 + $g_iMidOffsetY, True), Hex(0xA2CB6C, 6), 20) Then
		SetLog("Star Laboratory Upgrade in progress, waiting for completion", $COLOR_INFO)
		If _Sleep($DELAYLABORATORY2) Then Return
		; upgrade in process and time not recorded so update completion time!
		Local $sLabTimeOCR = getRemainTLaboratory(220, 200 + $g_iMidOffsetY)
		Local $iLabFinishTime = ConvertOCRTime("Lab Time", $sLabTimeOCR, False)
		SetDebugLog("$sLabTimeOCR: " & $sLabTimeOCR & ", $iLabFinishTime = " & $iLabFinishTime & " m")
		If $iLabFinishTime > 0 Then
			$iStarLabFinishTimeMod = $iLabFinishTime
			$g_sStarLabUpgradeTime = _DateAdd('n', Ceiling($iLabFinishTime), _NowCalc())
			If @error Then _logErrorDateAdd(@error)
			SetLog("Research will finish in " & $sLabTimeOCR & " (" & $g_sStarLabUpgradeTime & ")")
			StarLabStatusGUIUpdate() ; Update GUI flag
		ElseIf $g_bDebugSetlog Then
			SetLog("Invalid getRemainTLaboratory OCR", $COLOR_DEBUG)
			If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save") ; saving $asStarLabUpgradeTime[$g_iCurAccount] = $g_sStarLabUpgradeTime for instantly displaying in multi-stats
			CloseWindow()
			Return False
		EndIf
	Else
		SetLog("No Star Laboratory Upgrade in progress", $COLOR_INFO)
		$g_sStarLabUpgradeTime = ""
		StarLabStatusGUIUpdate()
		If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save") ; saving $asStarLabUpgradeTime[$g_iCurAccount] = $g_sStarLabUpgradeTime for instantly displaying in multi-stats
		CloseWindow()
		Return False
	EndIf
	If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save") ; saving $asStarLabUpgradeTime[$g_iCurAccount] = $g_sStarLabUpgradeTime for instantly displaying in multi-stats
	CloseWindow()
	Return True
EndFunc   ;==>StarLabGuiDisplay
