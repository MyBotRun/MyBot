; #FUNCTION# ====================================================================================================================
; Name ..........:
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .:
; Author ........:
; Modified ......: Moebius14 (08-2023)
; Remarks .......: This file is part of MyBotRun. Copyright 2015-2025
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
	Local $iLoopHero = 0
	Local $HeroArray[0][3]
	Local $HeroArrayBackup[0][3]

	While 1

		$iLoopAmount += 1
		If $iLoopAmount >= $iLoopMax Or $iLoopAmount >= 12 Then ExitLoop ; 8 loops max, to avoid infinite loop

		If _Sleep($DELAYAUTOUPGRADEBUILDING1) Then Return
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
		If Not IsBuilderMenuOpen() Then ClickMainBuilder()
		If _Sleep($DELAYAUTOUPGRADEBUILDING1) Then Return

		; search for ressource images in builders menu, if found, a possible upgrade is available
		Local $aTmpCoord
		Local $IsElix = False
		$aTmpCoord = QuickMIS("CNX", $g_sImgResourceIcon, 410, $g_iNextLineOffset, 565, 370 + $g_iMidOffsetY)
		If IsArray($aTmpCoord) And UBound($aTmpCoord) > 0 Then
			_ArraySort($aTmpCoord, 0, 0, 0, 2) ;sort by Y coord
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

		Local $bHeroSystem = False, $bBlackHero = False
		If QuickMIS("BC1", $g_sImgGeneralCloseButton, 780, 145 + $g_iMidOffsetY, 815, 175 + $g_iMidOffsetY) Then
			SetLog("Hero Hall Window Opened", $COLOR_DEBUG1)
			$bHeroSystem = True
			If $iLoopHero = 0 Then
				$HeroArray = NewHeroUpgradeSystem($IsElix)
			Else
				$HeroArray = $HeroArrayBackup
				$HeroArray = NewHeroUpgradeSystem($IsElix)
			EndIf
			If $HeroArray[0][0] = "" Then
				SetLog("Something gone wrong, looking next...", $COLOR_WARNING)
				$HeroArray = $HeroArrayBackup
				CloseWindow2()
				ContinueLoop
			EndIf
			Local $g_aUpgradeNameLevelTemp[3] = [2, $HeroArray[0][0], 0]
			If Not $IsElix Then $bBlackHero = True
			$g_aUpgradeNameLevel = $g_aUpgradeNameLevelTemp
			$iLoopHero += 1
		Else

			$g_aUpgradeNameLevel = BuildingInfo(242, 475 + $g_iBottomOffsetY)
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
			If $g_aUpgradeNameLevel[0] = "" And Not $bHeroSystem Then
				SetLog("Error when trying to get upgrade name and level, looking next...", $COLOR_ERROR)
				ContinueLoop
			EndIf

		EndIf

		Local $bMustIgnoreUpgrade = False
		; matchmaking between building name and the ignore list
		Switch $g_aUpgradeNameLevel[1]
			Case "Town Hall"
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[0] = 1) ? True : False
			Case "Town Hall Weapon"
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[1] = 1) ? True : False
			Case "Barbarian King"
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[2] = 1 Or $g_bUpgradeKingEnable = True) ? True : False ; if upgrade king is selected, will ignore it
			Case "Archer Queen"
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[3] = 1 Or $g_bUpgradeQueenEnable = True) ? True : False ; if upgrade queen is selected, will ignore it
			Case "Minion Prince"
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[4] = 1 Or $g_bUpgradePrinceEnable = True) ? True : False ; if upgrade prince is selected, will ignore it
			Case "Grand Warden"
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[5] = 1 Or $g_bUpgradeWardenEnable = True) ? True : False ; if upgrade warden is selected, will ignore it
			Case "Royal Champion"
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[6] = 1 Or $g_bUpgradeChampionEnable = True) ? True : False ; if upgrade champion is selected, will ignore it
			Case "Clan Castle"
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[7] = 1) ? True : False
			Case "Laboratory"
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[8] = 1) ? True : False
			Case "Wall"
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[9] = 1 Or $g_bAutoUpgradeWallsEnable = True) ? True : False ; if wall upgrade enabled, will ignore it
			Case "Barracks"
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[10] = 1) ? True : False
			Case "Dark Barracks"
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[11] = 1) ? True : False
			Case "Spell Factory"
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[12] = 1) ? True : False
			Case "Dark Spell Factory"
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[13] = 1) ? True : False
			Case "Gold Mine"
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[14] = 1) ? True : False
			Case "Elixir Collector"
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[15] = 1) ? True : False
			Case "Dark Elixir Drill"
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[16] = 1) ? True : False
			Case Else
				$bMustIgnoreUpgrade = False
		EndSwitch

		; check if the upgrade name is on the list of upgrades that must be ignored
		If $bMustIgnoreUpgrade = True Then
			SetLog("This upgrade must be ignored, looking next...", $COLOR_WARNING)
			If $bHeroSystem Then
				CloseWindow2()
				If $bBlackHero Then _ArrayDelete($HeroArray, 0)
			EndIf
			ContinueLoop
		EndIf

		; if upgrade don't have to be ignored, click on the Upgrade button to open Upgrade window
		If $bHeroSystem Then
			Click($HeroArray[0][2], 433 + $g_iMidOffsetY)
			If _Sleep($DELAYAUTOUPGRADEBUILDING1) Then Return
			Switch $g_aUpgradeNameLevel[1]
				Case "Barbarian King"
					Local $g_iKingLevelOCR = Number(getOcrAndCapture("coc-YellowLevel", 627, 116, 50, 20))
					Local $g_aUpgradeNameLevelTemp2[3] = [$g_aUpgradeNameLevel[0], $g_aUpgradeNameLevel[1], Number($g_iKingLevelOCR - 1)]
				Case "Archer Queen"
					Local $g_iQueenLevelOCR = Number(getOcrAndCapture("coc-YellowLevel", 618, 116, 50, 20))
					Local $g_aUpgradeNameLevelTemp2[3] = [$g_aUpgradeNameLevel[0], $g_aUpgradeNameLevel[1], Number($g_iQueenLevelOCR - 1)]
				Case "Minion Prince"
					Local $g_iPrinceLevelOCR = Number(getOcrAndCapture("coc-YellowLevel", 618, 116, 50, 20))
					Local $g_aUpgradeNameLevelTemp2[3] = [$g_aUpgradeNameLevel[0], $g_aUpgradeNameLevel[1], Number($g_iPrinceLevelOCR - 1)]
				Case "Grand Warden"
					Local $g_iWardenLevelOCR = Number(getOcrAndCapture("coc-YellowLevel", 622, 116, 50, 20))
					Local $g_aUpgradeNameLevelTemp2[3] = [$g_aUpgradeNameLevel[0], $g_aUpgradeNameLevel[1], Number($g_iWardenLevelOCR - 1)]
				Case "Royal Champion"
					Local $g_iChampionLevelOCR = Number(getOcrAndCapture("coc-YellowLevel", 625, 116, 50, 20))
					Local $g_aUpgradeNameLevelTemp2[3] = [$g_aUpgradeNameLevel[0], $g_aUpgradeNameLevel[1], Number($g_iChampionLevelOCR - 1)]
			EndSwitch
			$g_aUpgradeNameLevel = $g_aUpgradeNameLevelTemp2
		Else
			ClickP($aUpgradeButton)
			If _Sleep($DELAYAUTOUPGRADEBUILDING1) Then Return
			CloseSuperchargeWindow()
		EndIf

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
				CloseWindow2()
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
			If $bHeroSystem Then
				CloseWindow2()
				If $bBlackHero Then _ArrayDelete($HeroArray, 0)
			EndIf
			CloseWindow2()
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
			If $bHeroSystem Then
				CloseWindow2()
				If $bBlackHero Then _ArrayDelete($HeroArray, 0)
			EndIf
			CloseWindow2()
			ContinueLoop
		EndIf

		; final click on upgrade button, click coord is get looking at upgrade type (heroes have a diferent place for Upgrade button)
		Click(630, 540 + $g_iMidOffsetY)
		If $bHeroSystem Then
			If $bBlackHero Then _ArrayDelete($HeroArray, 0)
		EndIf

		;Check for 'End Boost?' pop-up
		If _Sleep(1000) Then Return
		If $g_aUpgradeNameLevel[1] = "Town Hall" Then
			Local $aiCancelButton = findButton("Cancel", Default, 1, True)
			If IsArray($aiCancelButton) And UBound($aiCancelButton, 1) = 2 Then
				SetLog("MBR is not designed to rush a TH upgrade", $COLOR_ERROR)
				PureClick($aiCancelButton[0], $aiCancelButton[1], 2, 120, "#0117") ; Click Cancel Button
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
				Case 17
					$g_aUpgradeNameLevel[1] = "Inferno Artillery"
					SetLog("Launched upgrade of Inferno Artillery successfully !", $COLOR_SUCCESS)
			EndSwitch
		Else
			SetLog("Launched upgrade of " & $g_aUpgradeNameLevel[1] & " to level " & $g_aUpgradeNameLevel[2] + 1 & " successfully !", $COLOR_SUCCESS)
			Switch $g_aUpgradeNameLevel[1]
				Case "Barbarian King"
					GUICtrlSetState($g_hPicKingGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingRed, $GUI_SHOW)
					GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingGreen, $GUI_HIDE)
					$g_iHeroUpgrading[0] = 1
					$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroKing)
				Case "Archer Queen"
					GUICtrlSetState($g_hPicQueenGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenRed, $GUI_SHOW)
					GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenGreen, $GUI_HIDE)
					$g_iHeroUpgrading[1] = 1
					$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroQueen)
				Case "Minion Prince"
					GUICtrlSetState($g_hPicPrinceGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicPrinceRed, $GUI_SHOW)
					GUICtrlSetState($g_hPicPrinceBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicPrinceGreen, $GUI_HIDE)
					$g_iHeroUpgrading[2] = 1
					$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroPrince)
				Case "Grand Warden"
					GUICtrlSetState($g_hPicWardenGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenRed, $GUI_SHOW)
					GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenGreen, $GUI_HIDE)
					$g_iHeroUpgrading[3] = 1
					$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroWarden)
				Case "Royal Champion"
					GUICtrlSetState($g_hPicChampionGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicChampionRed, $GUI_SHOW)
					GUICtrlSetState($g_hPicChampionBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicChampionGreen, $GUI_HIDE)
					$g_iHeroUpgrading[4] = 1
					$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroChampion)
			EndSwitch
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
			Case "Barbarian King", "Archer Queen", "Minion Prince", "Royal Champion"
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

		If $bHeroSystem Then CloseWindow2()

		ClearScreen()

	WEnd

	If IsBuilderMenuOpen() Then
		Click(435, 30)
		If _Sleep(500) Then Return
	EndIf
	ClearScreen()
	If _Sleep(500) Then Return

	; resetting the offset of the lines
	$g_iNextLineOffset = 75

	SetLog("Auto Upgrade finished", $COLOR_INFO)
	If _Sleep($DELAYUPGRADEBUILDING2) Then Return
	VillageReport(True, True)
	UpdateStats()
	ZoomOut() ; re-center village

EndFunc   ;==>_AutoUpgrade

Func AutoWallsStatsMAJ($CurrentWallLevel = 10)
	$g_aiWallsCurrentCount[$CurrentWallLevel + 1] = $g_aiWallsCurrentCount[$CurrentWallLevel + 1] + 1
	$g_aiWallsCurrentCount[$CurrentWallLevel] = $g_aiWallsCurrentCount[$CurrentWallLevel] - 1
	GUICtrlSetData($g_ahWallsCurrentCount[$CurrentWallLevel + 1], $g_aiWallsCurrentCount[$CurrentWallLevel + 1])
	GUICtrlSetData($g_ahWallsCurrentCount[$CurrentWallLevel], $g_aiWallsCurrentCount[$CurrentWallLevel])
	SaveConfig()
EndFunc   ;==>AutoWallsStatsMAJ

Func ClickMainBuilder($bTest = False, $Counter = 3)
	Local $b_WindowOpened = False
	If Not $g_bRunState Then Return
	; open the builders menu
	Click(435, 30)
	If _Sleep(1000) Then Return

	If IsBuilderMenuOpen() Then
		SetDebugLog("Open Upgrade Window, Success", $COLOR_SUCCESS)
		$b_WindowOpened = True
	Else
		For $i = 1 To $Counter
			SetLog("Upgrade Window didn't open, trying again!", $COLOR_DEBUG)
			Click(435, 30)
			If _Sleep(1000) Then Return
			If IsBuilderMenuOpen() Then
				$b_WindowOpened = True
				ExitLoop
			EndIf
		Next
		If Not $b_WindowOpened Then
			SetLog("Something is wrong with upgrade window, already tried 3 times!", $COLOR_DEBUG)
		EndIf
	EndIf
	Return $b_WindowOpened
EndFunc   ;==>ClickMainBuilder

Func IsBuilderMenuOpen()
	Local $bRet = False
	Local $sTriangle

	For $i = 0 To 5
		If IsArray(_PixelSearch(399, 72, 401, 74, Hex(0xFFFFFF, 6), 30, True)) Then
			SetDebugLog("Found White Border Color", $COLOR_ACTION)
			$bRet = True ;got correct color for border
			ExitLoop
		EndIf
		_Sleep(500)
	Next

	If Not $bRet Then ;lets re check if border color check not success
		$sTriangle = getOcrAndCapture("coc-buildermenu-main", 420, 60, 445, 73)
		SetDebugLog("$sTriangle: " & $sTriangle)
		If $sTriangle = "^" Then $bRet = True
	EndIf

	Return $bRet
EndFunc   ;==>IsBuilderMenuOpen

Func NewHeroUpgradeSystem($IsElix = False)

	Local $bInitalXcoord = 67
	Local $bDistanceSlot = 153
	Local $bXcoords[5] = [$bInitalXcoord, $bInitalXcoord + $bDistanceSlot, $bInitalXcoord + $bDistanceSlot * 2, $bInitalXcoord + $bDistanceSlot * 3, $bInitalXcoord + $bDistanceSlot * 4]
	Local $HeroArrayTemp[0][3]

	;Check Hidden Hero Upgrade To be sure
	Switch $g_aiCmbCustomHeroOrder[4]
		Case 0
			If IsArray(_PixelSearch($bXcoords[0] - 6, 438 + $g_iMidOffsetY, $bXcoords[0] + 10, 444 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
				GUICtrlSetState($g_hPicKingGray, $GUI_HIDE)
				GUICtrlSetState($g_hPicKingRed, $GUI_SHOW)
				GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
				GUICtrlSetState($g_hPicKingGreen, $GUI_HIDE)
				SetLog($g_asHeroNames[0] & " is being upgraded", $COLOR_DEBUG)
				;Set Status Variable
				$g_iHeroUpgrading[0] = 1
				$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroKing)
			Else
				If Not _ColorCheck(_GetPixelColor($bXcoords[0], 438 + $g_iMidOffsetY, True), Hex(0x6D6D6D, 6), 15) Then
					GUICtrlSetState($g_hPicKingGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingGreen, $GUI_SHOW)
					SetLog($g_asHeroNames[0] & " is ready to fight", $COLOR_SUCCESS1)
					$g_iHeroUpgrading[0] = 0
					$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroQueen, $eHeroPrince, $eHeroWarden, $eHeroChampion))
				EndIf
			EndIf
		Case 1
			If IsArray(_PixelSearch($bXcoords[1] - 6, 438 + $g_iMidOffsetY, $bXcoords[1] + 10, 444 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
				GUICtrlSetState($g_hPicQueenGray, $GUI_HIDE)
				GUICtrlSetState($g_hPicQueenRed, $GUI_SHOW)
				GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
				GUICtrlSetState($g_hPicQueenGreen, $GUI_HIDE)
				SetLog($g_asHeroNames[1] & " is being upgraded", $COLOR_DEBUG)
				;Set Status Variable
				$g_iHeroUpgrading[1] = 1
				$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroQueen)
			Else
				If Not _ColorCheck(_GetPixelColor($bXcoords[1], 438 + $g_iMidOffsetY, True), Hex(0x6D6D6D, 6), 15) Then
					GUICtrlSetState($g_hPicQueenGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenGreen, $GUI_SHOW)
					SetLog($g_asHeroNames[1] & " is ready to fight", $COLOR_SUCCESS1)
					$g_iHeroUpgrading[1] = 0
					$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroPrince, $eHeroWarden, $eHeroChampion))
				EndIf
			EndIf
		Case 2
			If IsArray(_PixelSearch($bXcoords[2] - 6, 438 + $g_iMidOffsetY, $bXcoords[2] + 10, 444 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
				GUICtrlSetState($g_hPicPrinceGray, $GUI_HIDE)
				GUICtrlSetState($g_hPicPrinceRed, $GUI_SHOW)
				GUICtrlSetState($g_hPicPrinceBlue, $GUI_HIDE)
				GUICtrlSetState($g_hPicPrinceGreen, $GUI_HIDE)
				SetLog($g_asHeroNames[2] & " is being upgraded", $COLOR_DEBUG)
				;Set Status Variable
				$g_iHeroUpgrading[2] = 1
				$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroPrince)
			Else
				If Not _ColorCheck(_GetPixelColor($bXcoords[2], 438 + $g_iMidOffsetY, True), Hex(0x6D6D6D, 6), 15) Then
					GUICtrlSetState($g_hPicPrinceGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicPrinceRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicPrinceBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicPrinceGreen, $GUI_SHOW)
					SetLog($g_asHeroNames[2] & " is ready to fight", $COLOR_SUCCESS1)
					$g_iHeroUpgrading[2] = 0
					$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroWarden, $eHeroChampion))
				EndIf
			EndIf
		Case 3
			If IsArray(_PixelSearch($bXcoords[3] - 6, 438 + $g_iMidOffsetY, $bXcoords[3] + 10, 444 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
				GUICtrlSetState($g_hPicWardenGray, $GUI_HIDE)
				GUICtrlSetState($g_hPicWardenRed, $GUI_SHOW)
				GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
				GUICtrlSetState($g_hPicWardenGreen, $GUI_HIDE)
				SetLog($g_asHeroNames[3] & " is being upgraded", $COLOR_DEBUG)
				;Set Status Variable
				$g_iHeroUpgrading[3] = 1
				$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroWarden)
			Else
				If Not _ColorCheck(_GetPixelColor($bXcoords[3], 438 + $g_iMidOffsetY, True), Hex(0x6D6D6D, 6), 15) Then
					GUICtrlSetState($g_hPicWardenGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenGreen, $GUI_SHOW)
					SetLog($g_asHeroNames[3] & " is ready to fight", $COLOR_SUCCESS1)
					$g_iHeroUpgrading[3] = 0
					$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroPrince, $eHeroChampion))
				EndIf
			EndIf
		Case 4
			If IsArray(_PixelSearch($bXcoords[4] - 6, 438 + $g_iMidOffsetY, $bXcoords[4] + 10, 444 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
				GUICtrlSetState($g_hPicChampionGray, $GUI_HIDE)
				GUICtrlSetState($g_hPicChampionRed, $GUI_SHOW)
				GUICtrlSetState($g_hPicChampionBlue, $GUI_HIDE)
				GUICtrlSetState($g_hPicChampionGreen, $GUI_HIDE)
				SetLog($g_asHeroNames[4] & " is being upgraded", $COLOR_DEBUG)
				;Set Status Variable
				$g_iHeroUpgrading[4] = 1
				$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroChampion)
			Else
				If Not _ColorCheck(_GetPixelColor($bXcoords[4], 438 + $g_iMidOffsetY, True), Hex(0x6D6D6D, 6), 15) Then
					GUICtrlSetState($g_hPicChampionGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicChampionRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicChampionBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicChampionGreen, $GUI_SHOW)
					SetLog($g_asHeroNames[4] & " is ready to fight", $COLOR_SUCCESS1)
					$g_iHeroUpgrading[4] = 0
					$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroPrince, $eHeroWarden))
				EndIf
			EndIf
	EndSwitch

	If $IsElix Then

		; Warden
		Local $g_iWardenCostOCR = "", $bWarden = "Grand Warden"
		If _ColorCheck(_GetPixelColor($bXcoords[3], 438 + $g_iMidOffsetY, True), Hex(0x8BD43A, 6), 20) Then
			Local $g_iWardenCostOCR = Number(getOcrAndCapture("coc-HeroCost", $bXcoords[3] + 10, 433 + $g_iMidOffsetY, 84, 20, True))
			If $g_iWardenCostOCR = "" Then $g_iWardenCostOCR = 0
			_ArrayAdd($HeroArrayTemp, $bWarden & "|" & $g_iWardenCostOCR & "|" & $bXcoords[3] + 55)
		Else
			If _ColorCheck(_GetPixelColor($bXcoords[3] + 42, 425 + $g_iMidOffsetY, True), Hex(0xBEEA8C, 6), 20) Then
				Local $g_iWardenCostOCR = Number(getOcrAndCapture("coc-HeroCost", $bXcoords[3] + 32, 433 + $g_iMidOffsetY, 75, 20, True))
				If $g_iWardenCostOCR = "" Then $g_iWardenCostOCR = 0
				_ArrayAdd($HeroArrayTemp, $bWarden & "|" & $g_iWardenCostOCR & "|" & $bXcoords[3] + 80)
			EndIf
		EndIf
		If _Sleep(100) Then Return
		Return $HeroArrayTemp

	Else

		; King
		Local $g_iKingCostOCR = "", $bKing = "Barbarian King"
		If _ColorCheck(_GetPixelColor($bXcoords[0], 438 + $g_iMidOffsetY, True), Hex(0x8BD43A, 6), 20) Then
			Local $g_iKingCostOCR = Number(getOcrAndCapture("coc-HeroCost", $bXcoords[0] + 23, 433 + $g_iMidOffsetY, 65, 20, True))
			If $g_iKingCostOCR = "" Then $g_iKingCostOCR = 0
			_ArrayAdd($HeroArrayTemp, $bKing & "|" & $g_iKingCostOCR & "|" & $bXcoords[0] + 55)
		Else
			If _ColorCheck(_GetPixelColor($bXcoords[0] + 42, 438 + $g_iMidOffsetY, True), Hex(0x8BD43A, 6), 20) Then
				Local $g_iKingCostOCR = Number(getOcrAndCapture("coc-HeroCost", $bXcoords[0] + 38, 433 + $g_iMidOffsetY, 65, 20, True))
				If $g_iKingCostOCR = "" Then $g_iKingCostOCR = 0
				_ArrayAdd($HeroArrayTemp, $bKing & "|" & $g_iKingCostOCR & "|" & $bXcoords[0] + 80)
			EndIf
		EndIf

		If _Sleep(100) Then Return

		; Queen
		Local $g_iQueenCostOCR = "", $bQueen = "Archer Queen"
		If _ColorCheck(_GetPixelColor($bXcoords[1], 438 + $g_iMidOffsetY, True), Hex(0x8BD43A, 6), 20) Then
			Local $g_iQueenCostOCR = Number(getOcrAndCapture("coc-HeroCost", $bXcoords[1] + 23, 433 + $g_iMidOffsetY, 65, 20, True))
			If $g_iQueenCostOCR = "" Then $g_iQueenCostOCR = 0
			_ArrayAdd($HeroArrayTemp, $bQueen & "|" & $g_iQueenCostOCR & "|" & $bXcoords[1] + 55)
		Else
			If _ColorCheck(_GetPixelColor($bXcoords[1] + 42, 438 + $g_iMidOffsetY, True), Hex(0x8BD43A, 6), 20) Then
				Local $g_iQueenCostOCR = Number(getOcrAndCapture("coc-HeroCost", $bXcoords[1] + 38, 433 + $g_iMidOffsetY, 65, 20, True))
				If $g_iQueenCostOCR = "" Then $g_iQueenCostOCR = 0
				_ArrayAdd($HeroArrayTemp, $bQueen & "|" & $g_iQueenCostOCR & "|" & $bXcoords[1] + 80)
			EndIf
		EndIf

		If _Sleep(100) Then Return

		; Prince
		Local $g_iPrinceCostOCR = "", $bPrince = "Minion Prince"
		If _ColorCheck(_GetPixelColor($bXcoords[2], 438 + $g_iMidOffsetY, True), Hex(0x8BD43A, 6), 20) Then
			Local $g_iPrinceCostOCR = Number(getOcrAndCapture("coc-HeroCost", $bXcoords[2] + 23, 433 + $g_iMidOffsetY, 65, 20, True))
			If $g_iPrinceCostOCR = "" Then $g_iPrinceCostOCR = 0
			_ArrayAdd($HeroArrayTemp, $bPrince & "|" & $g_iPrinceCostOCR & "|" & $bXcoords[2] + 55)
		Else
			If _ColorCheck(_GetPixelColor($bXcoords[2] + 42, 438 + $g_iMidOffsetY, True), Hex(0x8BD43A, 6), 20) Then
				Local $g_iPrinceCostOCR = Number(getOcrAndCapture("coc-HeroCost", $bXcoords[2] + 38, 433 + $g_iMidOffsetY, 65, 20, True))
				If $g_iPrinceCostOCR = "" Then $g_iPrinceCostOCR = 0
				_ArrayAdd($HeroArrayTemp, $bPrince & "|" & $g_iPrinceCostOCR & "|" & $bXcoords[2] + 80)
			EndIf
		EndIf

		If _Sleep(100) Then Return

		; Champion
		Local $g_iChampionCostOCR = "", $bChampion = "Royal Champion"
		If _ColorCheck(_GetPixelColor($bXcoords[4], 438 + $g_iMidOffsetY, True), Hex(0x8BD43A, 6), 20) Then
			Local $g_iChampionCostOCR = Number(getOcrAndCapture("coc-HeroCost", $bXcoords[4] + 23, 433 + $g_iMidOffsetY, 65, 20, True))
			If $g_iChampionCostOCR = "" Then $g_iChampionCostOCR = 0
			_ArrayAdd($HeroArrayTemp, $bChampion & "|" & $g_iChampionCostOCR & "|" & $bXcoords[4] + 55)
		Else
			If _ColorCheck(_GetPixelColor($bXcoords[4] + 42, 438 + $g_iMidOffsetY, True), Hex(0x8BD43A, 6), 20) Then
				Local $g_iChampionCostOCR = Number(getOcrAndCapture("coc-HeroCost", $bXcoords[4] + 38, 433 + $g_iMidOffsetY, 65, 20, True))
				If $g_iChampionCostOCR = "" Then $g_iChampionCostOCR = 0
				_ArrayAdd($HeroArrayTemp, $bChampion & "|" & $g_iChampionCostOCR & "|" & $bXcoords[4] + 80)
			EndIf
		EndIf

		If _Sleep(100) Then Return

		_ArraySort($HeroArrayTemp, 1, 0, 0, 1)

		Return $HeroArrayTemp

	EndIf

EndFunc   ;==>NewHeroUpgradeSystem
