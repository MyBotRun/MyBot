; #FUNCTION# ====================================================================================================================
; Name ..........:
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .:
; Author ........:
; Modified ......: Moebius14 (08-2023)
; Remarks .......: This file is part of MyBotRun. Copyright 2015-2024
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......: ---
; Link ..........: https://www.mybot.run
; Example .......: ---
;================================================================================================================================
Func AutoUpgrade($bTest = False)
	Local $bWasRunState = $g_bRunState
	$g_bRunState = True
	Local $Result = _AutoUpgrade()
	$g_bRunState = $bWasRunState
	Return $Result
EndFunc   ;==>AutoUpgrade

Func _AutoUpgrade()
	If Not $g_bAutoUpgradeEnabled Then Return

	SetLog("Starting Auto Upgrade", $COLOR_INFO)
	Local $iLoopAmount = 0
	Local $iLoopMax = 8

	While 1

		$iLoopAmount += 1
		If $iLoopAmount >= $iLoopMax Or $iLoopAmount >= 12 Then ExitLoop ; 8 loops max, to avoid infinite loop

		ClickAway()
		If _sleep($DELAYAUTOUPGRADEBUILDING1) Then Return
		VillageReport(True, True)

		;Check if there is a free builder for Auto Upgrade
		If ($g_iFreeBuilderCount - ($g_bAutoUpgradeWallsEnable And $g_bUpgradeWallSaveBuilder ? 1 : 0) - ReservedBuildersForHeroes()) <= 0 Then
			SetLog("No builder available. Skipping Auto Upgrade!", $COLOR_WARNING)
			ExitLoop
		EndIf

		; check if builder head is clickable
		Local $g_iBuilderMenu = _PixelSearch(381, 13, 384, 15, Hex(0xF5F5ED, 6), 20)
		If Not IsArray($g_iBuilderMenu) Then
			SetLog("Unable to find the Builder menu button... Exiting Auto Upgrade...", $COLOR_ERROR)
			ExitLoop
		EndIf

		; open the builders menu
		Click(435, 30)
		If _Sleep($DELAYAUTOUPGRADEBUILDING1) Then Return

		; search for ressource images in builders menu, if found, a possible upgrade is available
		Local $aTmpCoord
		Local $IsElix = False
		$aTmpCoord = QuickMIS("CNX", $g_sImgResourceIcon, 410, $g_iNextLineOffset, 550, 370 + $g_iMidOffsetY)
		_ArraySort($aTmpCoord, 0, 0, 0, 2) ;sort by Y coord
		If IsArray($aTmpCoord) And UBound($aTmpCoord) > 0 Then
			$g_iNextLineOffset = $aTmpCoord[0][2] + 14
			If QuickMIS("BC1", $g_sImgAUpgradeZero, $aTmpCoord[0][1], $aTmpCoord[0][2] - 8, $aTmpCoord[0][1] + 100, $aTmpCoord[0][2] + 7) Then
				SetLog("Possible upgrade found !", $COLOR_SUCCESS)
				If $aTmpCoord[0][0] = "Elix" Then $IsElix = True
			Else
				SetLog("Not Enough Ressource, looking next...", $COLOR_INFO)
				ContinueLoop
			EndIf
		Else
			SetLog("No upgrade available... Exiting Auto Upgrade...", $COLOR_INFO)
			ExitLoop
		EndIf

		; check in the line if we can see "New" or the Gear of the equipment, in this case, will not do the upgrade
		If QuickMIS("NX", $g_sImgAUpgradeObst, 180, $aTmpCoord[0][2] - 15, 480, $aTmpCoord[0][2] + 15) <> "none" Then
			SetLog("This is a New Building or an Equipment, looking next...", $COLOR_WARNING)
			ContinueLoop
		EndIf

		; if it's an upgrade, will click on the upgrade, in builders menu
		Click($aTmpCoord[0][1] + 20, $aTmpCoord[0][2])
		If _Sleep($DELAYAUTOUPGRADEBUILDING1) Then Return

		$g_aUpgradeNameLevel = BuildingInfo(242, 468 + $g_iBottomOffsetY)
		Local $aUpgradeButton, $aTmpUpgradeButton

		; check if any wrong click by verifying the presence of the Upgrade button (the hammer)
		$aUpgradeButton = findButton("Upgrade", Default, 1, True)

		If $g_aUpgradeNameLevel[1] = "Town Hall" And $g_aUpgradeNameLevel[2] > 11 Then ;Upgrade THWeapon not Ignored
			$aTmpUpgradeButton = findButton("THWeapon") ;try to find UpgradeTHWeapon button (swords)
			If IsArray($aTmpUpgradeButton) And UBound($aTmpUpgradeButton) = 2 Then
				If $g_iChkUpgradesToIgnore[15] Then
					ContinueLoop
				EndIf
				$g_aUpgradeNameLevel[1] = "Town Hall Weapon"
				$aUpgradeButton = $aTmpUpgradeButton
			EndIf
		EndIf

		If Not (IsArray($aUpgradeButton) And UBound($aUpgradeButton, 1) = 2) Then
			SetLog("No upgrade here... Wrong click, looking next...", $COLOR_WARNING)
			ContinueLoop
		EndIf

		;Wall Double Button Case
		If $g_aUpgradeNameLevel[1] = "Wall" Then
			If WaitforPixel($aUpgradeButton[0], $aUpgradeButton[1] - 25, $aUpgradeButton[0] + 30, $aUpgradeButton[1] - 16, "FF887F", 20, 2) Or $IsElix Then ; Red On Gold Or Was Elix in Menu
				If UBound(decodeSingleCoord(FindImageInPlace2("UpgradeButton2", $g_sImgUpgradeBtn2Wall, $aUpgradeButton[0] + 65, $aUpgradeButton[1] - 20, _
						$aUpgradeButton[0] + 140, $aUpgradeButton[1] + 20, True))) > 1 Then $aUpgradeButton[0] += 94
			EndIf
		EndIf

		; get the name and actual level of upgrade selected, if strings are empty, will exit Auto Upgrade, an error happens
		If $g_aUpgradeNameLevel[0] = "" Then
			SetLog("Error when trying to get upgrade name and level, looking next...", $COLOR_ERROR)
			ContinueLoop
		EndIf

		Local $bMustIgnoreUpgrade = False
		; matchmaking between building name and the ignore list
		Switch $g_aUpgradeNameLevel[1]
			Case "Town Hall"
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[0] = 1) ? True : False
			Case "Town Hall Weapon"
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[15] = 1) ? True : False
			Case "Barbarian King"
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[1] = 1 Or $g_bUpgradeKingEnable = True) ? True : False ; if upgrade king is selected, will ignore it
			Case "Archer Queen"
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[2] = 1 Or $g_bUpgradeQueenEnable = True) ? True : False ; if upgrade queen is selected, will ignore it
			Case "Grand Warden"
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[3] = 1 Or $g_bUpgradeWardenEnable = True) ? True : False ; if upgrade warden is selected, will ignore it
			Case "Royal Champion"
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[14] = 1 Or $g_bUpgradeChampionEnable = True) ? True : False ; if upgrade champion is selected, will ignore it
			Case "Clan Castle"
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[4] = 1) ? True : False
			Case "Laboratory"
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[5] = 1) ? True : False
			Case "Wall"
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[6] = 1 Or $g_bAutoUpgradeWallsEnable = True) ? True : False ; if wall upgrade enabled, will ignore it
			Case "Barracks"
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[7] = 1) ? True : False
			Case "Dark Barracks"
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[8] = 1) ? True : False
			Case "Spell Factory"
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[9] = 1) ? True : False
			Case "Dark Spell Factory"
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[10] = 1) ? True : False
			Case "Gold Mine"
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[11] = 1) ? True : False
			Case "Elixir Collector"
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[12] = 1) ? True : False
			Case "Dark Elixir Drill"
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[13] = 1) ? True : False
			Case Else
				$bMustIgnoreUpgrade = False
		EndSwitch

		; check if the upgrade name is on the list of upgrades that must be ignored
		If $bMustIgnoreUpgrade = True Then
			SetLog("This upgrade must be ignored, looking next...", $COLOR_WARNING)
			ContinueLoop
		EndIf

		; if upgrade don't have to be ignored, click on the Upgrade button to open Upgrade window
		ClickP($aUpgradeButton)
		If _Sleep($DELAYAUTOUPGRADEBUILDING1) Then Return

		$g_aUpgradeResourceCostDuration[0] = QuickMIS("N1", $g_sImgAUpgradeRes, 670, 535 + $g_iMidOffsetY, 700, 565 + $g_iMidOffsetY) ; get resource
		$g_aUpgradeResourceCostDuration[1] = getCostsUpgrade(552, 541 + $g_iMidOffsetY) ; get cost
		If $g_aUpgradeResourceCostDuration[1] = "" Then $g_aUpgradeResourceCostDuration[1] = getCostsUpgrade(552, 532 + $g_iMidOffsetY) ; Try to read yellow text (Discount).
		$g_aUpgradeResourceCostDuration[2] = getBldgUpgradeTime(717, 544 + $g_iMidOffsetY) ; get duration
		If $g_aUpgradeResourceCostDuration[2] = "" Then $g_aUpgradeResourceCostDuration[2] = getBldgUpgradeTime(717, 532 + $g_iMidOffsetY) ; Try to read yellow text (Discount).

		; if one of the value is empty, there is an error, we must exit Auto Upgrade
		For $i = 0 To 2
			If $g_aUpgradeNameLevel[1] = "Wall" And $i = 2 Then ExitLoop ; Wall Case : No Upgrade Time
			If $g_aUpgradeResourceCostDuration[$i] = "" Then
				SaveDebugImage("UpgradeReadError_")
				SetLog("Error when trying to get upgrade details, looking next...", $COLOR_ERROR)
				ClickAway()
				ContinueLoop 2
			EndIf
		Next

		Local $bMustIgnoreResource = False
		; matchmaking between resource name and the ignore list
		Switch $g_aUpgradeResourceCostDuration[0]
			Case "Gold"
				$bMustIgnoreResource = ($g_iChkResourcesToIgnore[0] = 1) ? True : False
			Case "Elixir"
				$bMustIgnoreResource = ($g_iChkResourcesToIgnore[1] = 1) ? True : False
			Case "Dark Elixir"
				$bMustIgnoreResource = ($g_iChkResourcesToIgnore[2] = 1) ? True : False
			Case Else
				$bMustIgnoreResource = False
		EndSwitch

		; check if the resource of the upgrade must be ignored
		If $bMustIgnoreResource = True Then
			SetLog("This resource must be ignored, looking next...", $COLOR_WARNING)
			ClickAway()
			ContinueLoop
		EndIf

		; initiate a False boolean, that firstly says that there is no sufficent resource to launch upgrade
		Local $bSufficentResourceToUpgrade = False
		; if Cost of upgrade + Value set in settings to be kept after upgrade > Current village resource, make boolean True and can continue
		Switch $g_aUpgradeResourceCostDuration[0]
			Case "Gold"
				If $g_aiCurrentLoot[$eLootGold] >= ($g_aUpgradeResourceCostDuration[1] + $g_iTxtSmartMinGold) Then $bSufficentResourceToUpgrade = True
			Case "Elixir"
				If $g_aiCurrentLoot[$eLootElixir] >= ($g_aUpgradeResourceCostDuration[1] + $g_iTxtSmartMinElixir) Then $bSufficentResourceToUpgrade = True
			Case "Dark Elixir"
				If $g_aiCurrentLoot[$eLootDarkElixir] >= ($g_aUpgradeResourceCostDuration[1] + $g_iTxtSmartMinDark) Then $bSufficentResourceToUpgrade = True
		EndSwitch
		; if boolean still False, we can't launch upgrade, exiting...
		If Not $bSufficentResourceToUpgrade Then
			SetLog("Insufficent " & $g_aUpgradeResourceCostDuration[0] & " to launch this upgrade, looking Next...", $COLOR_WARNING)
			ClickAway()
			ContinueLoop
		EndIf

		; final click on upgrade button, click coord is get looking at upgrade type (heroes have a diferent place for Upgrade button)
		Click(630, 540 + $g_iMidOffsetY)

		;Check for 'End Boost?' pop-up
		If _Sleep(1000) Then Return
		If $g_aUpgradeNameLevel[1] = "Town Hall" Then
			Local $aiCancelButton = findButton("Cancel", Default, 1, True)
			If IsArray($aiCancelButton) And UBound($aiCancelButton, 1) = 2 Then
				SetLog("MBR is not designed to rush a TH upgrade", $COLOR_ERROR)
				PureClick($aiCancelButton[0], $aiCancelButton[1], 2, 50, "#0117") ; Click Cancel Button
				If _Sleep(1500) Then Return
				CloseWindow()
				ContinueLoop
			EndIf
		EndIf
		Local $aImgAUpgradeEndBoost = decodeSingleCoord(findImage("EndBoost", $g_sImgAUpgradeEndBoost, GetDiamondFromRect2(350, 280 + $g_iMidOffsetY, 570, 200 + $g_iMidOffsetY), 1, True))
		If UBound($aImgAUpgradeEndBoost) > 1 Then
			SetLog("End Boost? pop-up found", $COLOR_INFO)
			SetLog("Clicking OK", $COLOR_INFO)
			Local $aImgAUpgradeEndBoostOKBtn = decodeSingleCoord(findImage("EndBoostOKBtn", $g_sImgAUpgradeEndBoostOKBtn, GetDiamondFromRect2(420, 440 + $g_iMidOffsetY, 610, 350 + $g_iMidOffsetY), 1, True))
			If UBound($aImgAUpgradeEndBoostOKBtn) > 1 Then
				Click($aImgAUpgradeEndBoostOKBtn[0], $aImgAUpgradeEndBoostOKBtn[1])
				If _Sleep(1000) Then Return
			Else
				SetLog("Unable to locate OK Button", $COLOR_ERROR)
				If _Sleep(1000) Then Return
				ClickAway()
				Return
			EndIf
		EndIf

		; Upgrade completed, but at the same line there might be more...
		$g_iNextLineOffset = $aTmpCoord[0][2] - 10
		$iLoopMax += 1

		; update Logs and History file
		If $g_aUpgradeNameLevel[1] = "Town Hall Weapon" Then
			Switch $g_aUpgradeNameLevel[2]
				Case 12
					$g_aUpgradeNameLevel[1] = "Giga Tesla"
					SetLog("Launched upgrade of Giga Tesla successfully !", $COLOR_SUCCESS)
				Case 13
					$g_aUpgradeNameLevel[1] = "Giga Inferno"
					SetLog("Launched upgrade of Giga Inferno successfully !", $COLOR_SUCCESS)
				Case 14
					$g_aUpgradeNameLevel[1] = "Giga Inferno"
					SetLog("Launched upgrade of Giga Inferno successfully !", $COLOR_SUCCESS)
				Case 15
					$g_aUpgradeNameLevel[1] = "Giga Inferno"
					SetLog("Launched upgrade of Giga Inferno successfully !", $COLOR_SUCCESS)
				Case 16
					$g_aUpgradeNameLevel[1] = "Giga Inferno"
					SetLog("Launched upgrade of Giga Inferno successfully !", $COLOR_SUCCESS)
			EndSwitch
		Else
			SetLog("Launched upgrade of " & $g_aUpgradeNameLevel[1] & " to level " & $g_aUpgradeNameLevel[2] + 1 & " successfully !", $COLOR_SUCCESS)
		EndIf

		SetLog(" - Cost : " & _NumberFormat($g_aUpgradeResourceCostDuration[1]) & " " & $g_aUpgradeResourceCostDuration[0], $COLOR_SUCCESS)
		If $g_aUpgradeNameLevel[1] <> "Wall" Then SetLog(" - Duration : " & $g_aUpgradeResourceCostDuration[2], $COLOR_SUCCESS) ; Wall Case : No Upgrade Time

		;Stats
		Switch $g_aUpgradeNameLevel[1]
			Case "Wall"
				AutoWallsStatsMAJ($g_aUpgradeNameLevel[2])
				If $g_aUpgradeResourceCostDuration[0] = "Gold" Then
					$g_iNbrOfWallsUppedGold += 1
					$g_iCostGoldWall += $g_aUpgradeResourceCostDuration[1]
				Else
					$g_iNbrOfWallsUppedElixir += 1
					$g_iCostElixirWall += $g_aUpgradeResourceCostDuration[1]
				EndIf
			Case "Monolith"
				$g_iNbrOfBuildingsUppedDElixir += 1
				$g_iCostDElixirBuilding += $g_aUpgradeResourceCostDuration[1]
			Case "Barbarian King", "Archer Queen", "Royal Champion"
				$g_iNbrOfHeroesUpped += 1
				$g_iCostDElixirHero += $g_aUpgradeResourceCostDuration[1]
			Case "Grand Warden"
				$g_iNbrOfWardenUpped += 1
				$g_iCostElixirWarden += $g_aUpgradeResourceCostDuration[1]
			Case Else
				If $g_aUpgradeResourceCostDuration[0] = "Gold" Then
					$g_iNbrOfBuildingsUppedGold += 1
					$g_iCostGoldBuilding += $g_aUpgradeResourceCostDuration[1]
				Else
					$g_iNbrOfBuildingsUppedElixir += 1
					$g_iCostElixirBuilding += $g_aUpgradeResourceCostDuration[1]
				EndIf
		EndSwitch

		_GUICtrlEdit_AppendText($g_hTxtAutoUpgradeLog, _
				@CRLF & _NowDate() & " " & _NowTime() & _
				" - Upgrading " & $g_aUpgradeNameLevel[1] & _
				" to level " & $g_aUpgradeNameLevel[2] + 1 & _
				" for " & _NumberFormat($g_aUpgradeResourceCostDuration[1]) & _
				" " & $g_aUpgradeResourceCostDuration[0] & _
				" - Duration : " & $g_aUpgradeResourceCostDuration[2])

		_FileWriteLog($g_sProfileLogsPath & "\AutoUpgradeHistory.log", _
				"Upgrading " & $g_aUpgradeNameLevel[1] & _
				" to level " & $g_aUpgradeNameLevel[2] + 1 & _
				" for " & _NumberFormat($g_aUpgradeResourceCostDuration[1]) & _
				" " & $g_aUpgradeResourceCostDuration[0] & _
				" - Duration : " & $g_aUpgradeResourceCostDuration[2])

	WEnd

	; resetting the offset of the lines
	$g_iNextLineOffset = 75

	SetLog("Auto Upgrade finished", $COLOR_INFO)
	ClickAway()
	ZoomOut() ; re-center village

EndFunc   ;==>_AutoUpgrade

Func AutoWallsStatsMAJ($CurrentWallLevel = 10)
	$g_aiWallsCurrentCount[$CurrentWallLevel + 1] = $g_aiWallsCurrentCount[$CurrentWallLevel + 1] + 1
	$g_aiWallsCurrentCount[$CurrentWallLevel] = $g_aiWallsCurrentCount[$CurrentWallLevel] - 1
	GUICtrlSetData($g_ahWallsCurrentCount[$CurrentWallLevel + 1], $g_aiWallsCurrentCount[$CurrentWallLevel + 1])
	GUICtrlSetData($g_ahWallsCurrentCount[$CurrentWallLevel], $g_aiWallsCurrentCount[$CurrentWallLevel])
	SaveConfig()
EndFunc   ;==>AutoWallsStatsMAJ
