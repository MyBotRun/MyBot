; #FUNCTION# ====================================================================================================================
; Name ..........: Bot Clan Capital / ClanCapital.au3
; Description ...: This file controls the "Clan Capital" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Xbebenk, Moebius14
; Modified ......: Moebius14 (14.12.2022)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func CollectCCGold($bTest = False)
	If Not $g_bChkEnableCollectCCGold Then Return
	Local $bWindowOpened = False
	Local $CollectingCCGold = 0, $CollectedCCGold = 0
	Local $aCollect
	SetLog("Start Collecting Clan Capital Gold", $COLOR_INFO)
	ClickAway("Right")
	If _Sleep(500) Then Return
	ZoomOut() ;ZoomOut first
	If _Sleep(500) Then Return

	If QuickMIS("BC1", $g_sImgCCGoldCollect, 250, 490 + $g_iBottomOffsetY, 400, 670 + $g_iBottomOffsetY) Then
		Click($g_iQuickMISX, $g_iQuickMISY + 30)
		For $i = 1 To 5
			SetDebugLog("Waiting for Forge Window #" & $i, $COLOR_ACTION)
			If QuickMIS("BC1", $g_sImgGeneralCloseButton, 770, 130 + $g_iMidOffsetY, 810, 180 + $g_iMidOffsetY) Then
				$bWindowOpened = True
				ExitLoop
			EndIf
			If _Sleep(500) Then Return
		Next

		If $bWindowOpened Then
			$aCollect = QuickMIS("CNX", $g_sImgCCGoldCollect, 60, 350 + $g_iMidOffsetY, 770, 415 + $g_iMidOffsetY)
			_ArraySort($aCollect, 0, 0, 0, 1)
			If IsArray($aCollect) And UBound($aCollect) > 0 And UBound($aCollect, $UBOUND_COLUMNS) > 1 Then
				For $i = 0 To UBound($aCollect) - 1
					If Not $bTest Then
						$CollectingCCGold = getOcrAndCapture("coc-forge-ccgold", $aCollect[$i][1] - 75, $aCollect[$i][2] - 15, 60, 18, True)
						SetLog("Collecting " & _NumberFormat($CollectingCCGold, True) & " Clan Capital Gold", $COLOR_INFO)
						$CollectedCCGold += $CollectingCCGold
						Click($aCollect[$i][1], $aCollect[$i][2]) ;Click Collect
					Else
						$CollectingCCGold = getOcrAndCapture("coc-forge-ccgold", $aCollect[$i][1] - 75, $aCollect[$i][2] - 15, 60, 18, True)
						SetLog("Test Only, Should Collecting " & _NumberFormat($CollectingCCGold, True) & " Clan Capital Gold", $COLOR_INFO)
						$CollectedCCGold += $CollectingCCGold
						SetLog("Test Only, Should Click on [" & $aCollect[$i][1] & "," & $aCollect[$i][2] & "]")
					EndIf
					If _Sleep(1000) Then Return
				Next
			EndIf
			If _Sleep(1000) Then Return

			If $g_iTownHallLevel > 11 Then
				If $g_iTownHallLevel < 14 Then
					SetLog("Checking 3rd forge result", $COLOR_INFO)
					ClickDrag(770, 290 + $g_iMidOffsetY, 640, 290 + $g_iMidOffsetY)
					If _Sleep(2000) Then Return
					If QuickMIS("BC1", $g_sImgCCGoldCollect, 610, 350 + $g_iMidOffsetY, 790, 415 + $g_iMidOffsetY) Then
						If Not $bTest Then
							$CollectingCCGold = getOcrAndCapture("coc-forge-ccgold", $g_iQuickMISX - 75, $g_iQuickMISY - 15, 60, 18, True)
							SetLog("Collecting " & _NumberFormat($CollectingCCGold, True) & " Clan Capital Gold", $COLOR_INFO)
							$CollectedCCGold += $CollectingCCGold
							Click($g_iQuickMISX, $g_iQuickMISY) ;Click Collect
						Else
							$CollectingCCGold = getOcrAndCapture("coc-forge-ccgold", $g_iQuickMISX - 75, $g_iQuickMISY - 15, 60, 18, True)
							SetLog("Test Only, Should Collecting " & _NumberFormat($CollectingCCGold, True) & " Clan Capital Gold", $COLOR_INFO)
							$CollectedCCGold += $CollectingCCGold
							SetLog("Test Only, Should Click on [" & $g_iQuickMISX & "," & $g_iQuickMISY & "]")
						EndIf
						If _Sleep(1000) Then Return
					EndIf
				Else
					SetLog("Checking 3rd and 4th forge result", $COLOR_INFO)
					ClickDrag(770, 290 + $g_iMidOffsetY, 490, 290 + $g_iMidOffsetY)
					If _Sleep(2000) Then Return
					$aCollect = QuickMIS("CNX", $g_sImgCCGoldCollect, 450, 350 + $g_iMidOffsetY, 800, 415 + $g_iMidOffsetY)
					_ArraySort($aCollect, 0, 0, 0, 1)
					If IsArray($aCollect) And UBound($aCollect) > 0 And UBound($aCollect, $UBOUND_COLUMNS) > 1 Then
						For $i = 0 To UBound($aCollect) - 1
							If Not $bTest Then
								$CollectingCCGold = getOcrAndCapture("coc-forge-ccgold", $aCollect[$i][1] - 75, $aCollect[$i][2] - 15, 60, 18, True)
								SetLog("Collecting " & _NumberFormat($CollectingCCGold, True) & " Clan Capital Gold", $COLOR_INFO)
								$CollectedCCGold += $CollectingCCGold
								Click($aCollect[$i][1], $aCollect[$i][2]) ;Click Collect
							Else
								$CollectingCCGold = getOcrAndCapture("coc-forge-ccgold", $aCollect[$i][1] - 75, $aCollect[$i][2] - 15, 60, 18, True)
								SetLog("Test Only, Should Collecting " & _NumberFormat($CollectingCCGold, True) & " Clan Capital Gold", $COLOR_INFO)
								$CollectedCCGold += $CollectingCCGold
								SetLog("Test Only, Should Click on [" & $aCollect[$i][1] & "," & $aCollect[$i][2] & "]")
							EndIf
							If _Sleep(1000) Then Return
						Next
					EndIf
				EndIf
			EndIf

			SetLog("Collected " & _NumberFormat($CollectedCCGold, True) & " Clan Capital Gold Successfully !", $COLOR_SUCCESS1)
			If _Sleep(800) Then Return

		EndIf
		$g_iStatsClanCapCollected = $g_iStatsClanCapCollected + $CollectedCCGold
	Else
		SetLog("No available Clan Capital Gold to be collected!", $COLOR_INFO)
		Return
	EndIf
	CloseWindow()
	If _Sleep($DELAYCOLLECT3) Then Return
EndFunc   ;==>CollectCCGold

Func ClanCapitalReport($SetLog = True)
	$g_iLootCCGold = getOcrAndCapture("coc-ms", 670, 17, 160, 25, True)
	$g_iLootCCMedal = getOcrAndCapture("coc-ms", 670, 70, 160, 25, True)
	$g_iCCTrophies = getOcrAndCapture("coc-cc-trophy", 75, 90, 60, 16, True)
	PicCCTrophies()
	GUICtrlSetData($g_lblCapitalGold, _NumberFormat($g_iLootCCGold, True))
	GUICtrlSetData($g_lblCapitalMedal, _NumberFormat($g_iLootCCMedal, True))
	GUICtrlSetData($g_lblCapitalTrophies, _NumberFormat($g_iCCTrophies, True))
	UpdateStats()
	If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")

	If $SetLog Then SetLog("[Gold]: " & _NumberFormat($g_iLootCCGold, True) & " [Medals]: " & _NumberFormat($g_iLootCCMedal, True) & " [Trophies]: " & _NumberFormat($g_iCCTrophies, True), $COLOR_SUCCESS)

	If QuickMIS("BC1", $g_sImgCCRaid, 360, 445 + $g_iMidOffsetY, 500, 500 + $g_iMidOffsetY) Then
		Click($g_iQuickMISX, $g_iQuickMISY)
		If _Sleep(5000) Then Return
		SwitchToCapitalMain()
	EndIf
EndFunc   ;==>ClanCapitalReport

Func OpenForgeWindow()
	If $g_iTownHallLevel < 6 Then
		SetLog("TH reads as Lvl " & $g_iTownHallLevel & ", has no Forge.")
		Return False
	EndIf
	Local $bRet = False
	For $z = 1 To 5
		If QuickMIS("BC1", $g_sImgForgeHouse, 240, 510 + $g_iBottomOffsetY, 380, 670 + $g_iBottomOffsetY) Then
			Click($g_iQuickMISX + 18, $g_iQuickMISY + 20)
			For $i = 1 To 5
				SetDebugLog("Waiting for Forge Window #" & $i, $COLOR_ACTION)
				If QuickMIS("BC1", $g_sImgGeneralCloseButton, 780, 120 + $g_iMidOffsetY, 850, 170 + $g_iMidOffsetY) Then
					$bRet = True
					ExitLoop 2
				EndIf
				If _Sleep(600) Then Return
			Next
		EndIf
		If _Sleep(600) Then Return
	Next
	Return $bRet
EndFunc   ;==>OpenForgeWindow

Func WaitStartCraftWindow()
	Local $bRet = False
	For $i = 1 To 5
		SetDebugLog("Waiting for StartCraft Window #" & $i, $COLOR_ACTION)
		If QuickMIS("BC1", $g_sImgGeneralCloseButton, 620, 170 + $g_iMidOffsetY, 670, 220 + $g_iMidOffsetY) Then
			$bRet = True
			ExitLoop
		EndIf
		If _Sleep(600) Then Return
	Next
	If Not $bRet Then SetLog("StartCraft Window does not open", $COLOR_ERROR)
	Return $bRet
EndFunc   ;==>WaitStartCraftWindow

Func RemoveDupCNX(ByRef $arr, $sortBy = 1, $distance = 10)
	Local $atmparray[0][4]
	Local $tmpCoord = 0
	_ArraySort($arr, 0, 0, 0, $sortBy) ;sort by 1 = , 2 = y
	For $i = 0 To UBound($arr) - 1
		SetDebugLog("SortBy:" & $arr[$i][$sortBy])
		SetDebugLog("tmpCoord:" & $tmpCoord)
		If $arr[$i][$sortBy] >= $tmpCoord + $distance Then
			_ArrayAdd($atmparray, $arr[$i][0] & "|" & $arr[$i][1] & "|" & $arr[$i][2] & "|" & $arr[$i][3])
			$tmpCoord = $arr[$i][$sortBy] + $distance
		Else
			SetDebugLog("Skip this dup: " & $arr[$i][$sortBy] & " is near " & $tmpCoord, $COLOR_INFO)
			ContinueLoop
		EndIf
	Next
	$arr = $atmparray
	SetDebugLog(_ArrayToString($arr))
EndFunc   ;==>RemoveDupCNX

Func ForgeClanCapitalGold($bTest = False)
	If Not $g_bRunState Then Return
	Local $aForgeType[5] = [$g_bChkEnableForgeGold, $g_bChkEnableForgeElix, $g_bChkEnableForgeDE, $g_bChkEnableForgeBBGold, $g_bChkEnableForgeBBElix]
	Local $bForgeEnabled = False
	For $i In $aForgeType ;check for every option enabled
		If $i = True Then
			$bForgeEnabled = True
			ExitLoop
		EndIf
	Next
	If Not $bForgeEnabled Then Return

	Local $iBuilderToUse = $g_iCmbForgeBuilder
	Local $ReservedBuilders = 0
	Local $iUpgradeBuilders = 0
	Local $aResource, $b_ToStopCheck = False
	Local $SkipGold = False, $SkipElix = False, $SkipDE = False
	If Not $g_bRunState Then Return

	SetLog("Checking for Forge ClanCapital Gold", $COLOR_INFO)
	ClickAway()
	ZoomOut()
	getBuilderCount(True) ;check if we have available builder

	If $bTest Then $g_iFreeBuilderCount = 3
	For $iz = 0 To UBound($g_avBuildingUpgrades, 1) - 1 ; loop through all upgrades to see if any are enabled.
		If $g_abBuildingUpgradeEnable[$iz] = True Then $iUpgradeBuilders += 1 ; count number enabled
	Next
	Local $iWallReserve = $g_bUpgradeWallSaveBuilder ? 1 : 0
	If $g_iFreeBuilderCount - $iWallReserve - ReservedBuildersForHeroes() - $iUpgradeBuilders < 1 Then ;check builder reserve on wall, hero upgrade, Buildings upgrade
		If Not _CheckPixel($aPersonalChallengeOpenButton2, $g_bCapturePixel) Then
			SetDebugLog("FreeBuilder=" & $g_iFreeBuilderCount & ", Reserved (ForHero=" & $g_iHeroReservedBuilder & " ForWall=" & $iWallReserve & " ForBuilding=" & $iUpgradeBuilders & ")", $COLOR_INFO)
			SetLog("No available builder for Craft", $COLOR_INFO)
			Return
		EndIf
		$b_ToStopCheck = True
	Else
		$ReservedBuilders = $g_iFreeBuilderCount - $iWallReserve - ReservedBuildersForHeroes(False) - $iUpgradeBuilders
		SetDebugLog("Free Builders allowed for Forge : " & $ReservedBuilders & " / " & $g_iFreeBuilderCount, $COLOR_DEBUG)
	EndIf

	Local $iCurrentGold = getResourcesMainScreen(695, 23) ;get current Gold
	Local $iCurrentElix = getResourcesMainScreen(695, 74) ;get current Elixir
	Local $iCurrentDE = getResourcesMainScreen(720, 120) ;get current Dark Elixir
	Local $isFullGold = _CheckPixel($aIsGoldFull, $g_bCapturePixel)
	Local $isFullElix = _CheckPixel($aIsElixirFull, $g_bCapturePixel)
	Local $isFullDark = _CheckPixel($aIsDarkElixirFull, $g_bCapturePixel)

	If $isFullGold And $g_bChkEnableForgeGold Then SetLog("Gold Storages are full!", $COLOR_SUCCESS)
	If $isFullElix And $g_bChkEnableForgeElix Then SetLog("Elixir Storages are full!", $COLOR_SUCCESS)
	If $isFullDark And $g_bChkEnableForgeDE Then SetLog("Dark Elixir Storage is full!", $COLOR_SUCCESS)

	If Not $g_bRunState Then Return
	If Not OpenForgeWindow() Then
		SetLog("Forge Window not Opened, exiting", $COLOR_ACTION)
		Return
	EndIf

	If _Sleep(1000) Then Return

	If Not AutoForgeSlot($bTest, $iCurrentGold, $iCurrentElix, $iCurrentDE, $isFullGold, $isFullElix, $isFullDark, $SkipGold, $SkipElix, $SkipDE) Then $b_ToStopCheck = True

	If $b_ToStopCheck Or $g_iCmbForgeBuilder = 0 Then
		CloseWindow()
		Return
	EndIf

	If $g_iTownHallLevel > 11 Then
		If $g_iTownHallLevel < 14 Then
			SetDebugLog("Checking 3rd forge", $COLOR_INFO)
			ClickDrag(770, 290 + $g_iMidOffsetY, 640, 290 + $g_iMidOffsetY)
		Else
			SetDebugLog("Checking 3rd and 4th forge", $COLOR_INFO)
			ClickDrag(770, 290 + $g_iMidOffsetY, 490, 290 + $g_iMidOffsetY)
		EndIf
	EndIf
	If _Sleep(2000) Then Return

	Select
		Case ($g_iTownHallLevel = 13 Or $g_iTownHallLevel = 12) And $iBuilderToUse = 4
			SetLog("TH Level Allows 3 Builders For Forge", $COLOR_DEBUG)
			$iBuilderToUse = 3
			$g_iCmbForgeBuilder = $iBuilderToUse - 1
			_GUICtrlComboBox_SetCurSel($g_hCmbForgeBuilder, $g_iCmbForgeBuilder)
		Case $g_iTownHallLevel = 11 And $iBuilderToUse > 2
			SetLog("TH Level Allows 2 Builders For Forge", $COLOR_DEBUG)
			$iBuilderToUse = 2
			$g_iCmbForgeBuilder = $iBuilderToUse - 1
			_GUICtrlComboBox_SetCurSel($g_hCmbForgeBuilder, $g_iCmbForgeBuilder)
		Case $g_iTownHallLevel < 11 And $iBuilderToUse > 1
			SetLog("TH Level Allows Only 1 Builder For Forge", $COLOR_DEBUG)
			$iBuilderToUse = 1
			$g_iCmbForgeBuilder = $iBuilderToUse - 1
			_GUICtrlComboBox_SetCurSel($g_hCmbForgeBuilder, $g_iCmbForgeBuilder)
	EndSelect

	If Not $g_bRunState Then Return
	SetLog("Number of Enabled builder for Forge : " & $iBuilderToUse, $COLOR_ACTION)

	Local $iBuilder = 0

	;check if we have forge in progress
	If $g_iTownHallLevel > 11 Then
		If $g_iTownHallLevel < 14 Then
			Local $iActiveForge = QuickMIS("CNX", $g_sImgActiveForge, 260, 285 + $g_iMidOffsetY, 805, 340 + $g_iMidOffsetY)
		Else
			Local $iActiveForge = QuickMIS("CNX", $g_sImgActiveForge, 95, 285 + $g_iMidOffsetY, 805, 340 + $g_iMidOffsetY)
		EndIf
	Else
		Local $iActiveForge = QuickMIS("CNX", $g_sImgActiveForge, 415, 285 + $g_iMidOffsetY, 770, 340 + $g_iMidOffsetY)
	EndIf
	RemoveDupCNX($iActiveForge)
	If IsArray($iActiveForge) And UBound($iActiveForge) > 0 Then
		If UBound($iActiveForge) >= $iBuilderToUse Then
			SetLog("We have All Builder Active for Forge", $COLOR_INFO)
			ClickAway("Right")
			Return
		EndIf
		$iBuilder = UBound($iActiveForge)
	EndIf

	SetLog("Already active builder Forging : " & $iBuilder, $COLOR_ACTION)
	If Not $g_bRunState Then Return

	;check if we have craft ready to start
	If $g_iTownHallLevel > 11 Then
		If $g_iTownHallLevel < 14 Then
			Local $aCraft = QuickMIS("CNX", $g_sImgCCGoldCraft, 260, 350 + $g_iMidOffsetY, 805, 410 + $g_iMidOffsetY)
		Else
			Local $aCraft = QuickMIS("CNX", $g_sImgCCGoldCraft, 95, 350 + $g_iMidOffsetY, 805, 410 + $g_iMidOffsetY)
		EndIf
	Else
		Local $aCraft = QuickMIS("CNX", $g_sImgCCGoldCraft, 415, 350 + $g_iMidOffsetY, 770, 410 + $g_iMidOffsetY)
	EndIf
	RemoveDupCNX($aCraft)
	_ArraySort($aCraft, 0, 0, 0, 1) ;sort by column 1 (x coord)
	SetDebugLog("Count of Craft Button : " & UBound($aCraft), $COLOR_DEBUG)

	If IsArray($aCraft) And UBound($aCraft) > 0 And UBound($aCraft, $UBOUND_COLUMNS) > 1 Then

		Local $iBuilderToAssign = 0
		Local $UnactiveCraftToStart = $iBuilderToUse - $iBuilder
		SetDebugLog("Number of Builder(s) To Use : " & $UnactiveCraftToStart, $COLOR_DEBUG)
		If $UnactiveCraftToStart < UBound($aCraft) Then
			$iBuilderToAssign = $UnactiveCraftToStart ; When assigned in Gui < Crafts ready to start
			If $bTest Then SetLog("Case 1 : Gui < Crafts", $COLOR_DEBUG)
		Else
			$iBuilderToAssign = UBound($aCraft)    ; When assigned in Gui >= Crafts ready to start
			If $bTest Then SetLog("Case 2 : Gui >= Crafts", $COLOR_DEBUG)
		EndIf

		If $ReservedBuilders < $iBuilderToAssign Then ;check builder reserve on wall and hero upgrade
			$iBuilderToAssign = $ReservedBuilders
			If ($g_iHeroReservedBuilder + $iWallReserve + $iUpgradeBuilders) = 1 Then
				SetLog("Reserved Builder (ForHero=" & $g_iHeroReservedBuilder & " ForWall=" & $iWallReserve & " ForBuilding=" & $iUpgradeBuilders & ")", $COLOR_ACTION)
			Else
				SetLog("Reserved Builders (ForHero=" & $g_iHeroReservedBuilder & " ForWall=" & $iWallReserve & " ForBuilding=" & $iUpgradeBuilders & ")", $COLOR_ACTION)
			EndIf
		EndIf

		If $iBuilderToAssign = 1 Then
			SetLog("Builder to Assign : " & $iBuilderToAssign, $COLOR_SUCCESS1)
		Else
			SetLog("Builders to Assign : " & $iBuilderToAssign, $COLOR_SUCCESS1)
		EndIf

		Local $aResource
		Local $SkipGold = False, $SkipElix = False, $SkipDE = False

		For $j = 1 To $iBuilderToAssign
			Select
				Case $g_bChkEnableForgeGold And Not $g_bChkEnableForgeElix And Not $g_bChkEnableForgeDE And Not $g_bChkEnableForgeBBGold And Not $g_bChkEnableForgeBBElix
					If $SkipGold Then ExitLoop
				Case Not $g_bChkEnableForgeGold And $g_bChkEnableForgeElix And Not $g_bChkEnableForgeDE And Not $g_bChkEnableForgeBBGold And Not $g_bChkEnableForgeBBElix
					If $SkipElix Then ExitLoop
				Case Not $g_bChkEnableForgeGold And Not $g_bChkEnableForgeElix And $g_bChkEnableForgeDE And Not $g_bChkEnableForgeBBGold And Not $g_bChkEnableForgeBBElix
					If $SkipDE Then ExitLoop
				Case $g_bChkEnableForgeGold And $g_bChkEnableForgeElix And Not $g_bChkEnableForgeDE And Not $g_bChkEnableForgeBBGold And Not $g_bChkEnableForgeBBElix
					If $SkipGold And $SkipElix Then ExitLoop
				Case $g_bChkEnableForgeGold And Not $g_bChkEnableForgeElix And $g_bChkEnableForgeDE And Not $g_bChkEnableForgeBBGold And Not $g_bChkEnableForgeBBElix
					If $SkipGold And $SkipDE Then ExitLoop
				Case Not $g_bChkEnableForgeGold And $g_bChkEnableForgeElix And $g_bChkEnableForgeDE And Not $g_bChkEnableForgeBBGold And Not $g_bChkEnableForgeBBElix
					If $SkipElix And $SkipDE Then ExitLoop
				Case $g_bChkEnableForgeGold And $g_bChkEnableForgeElix And $g_bChkEnableForgeDE And Not $g_bChkEnableForgeBBGold And Not $g_bChkEnableForgeBBElix
					If $SkipElix And $SkipElix And $SkipDE Then ExitLoop
			EndSelect
			SetDebugLog("Proceed with builder #" & $j)
			Click($aCraft[$j - 1][1], $aCraft[$j - 1][2])
			If _Sleep(500) Then Return
			If Not WaitStartCraftWindow() Then
				ClickAway("Right")
				Return
			EndIf
			Local $IsLowResource = True

			If $isFullGold Or $isFullElix Or $isFullDark Then
				$aResource = SortResources(Number($iCurrentGold), Number($iCurrentElix), Number($iCurrentDE), Number($g_aiCurrentLootBB[$eLootGoldBB]), Number($g_aiCurrentLootBB[$eLootElixirBB]))
				For $i = 0 To UBound($aResource) - 1
					If $aResource[$i][3] = True Then ;check if ForgeType Enabled
						Switch $aResource[$i][0]
							Case "Gold"
								If Not $isFullGold Or $SkipGold Then ContinueLoop
							Case "Elixir"
								If Not $isFullElix Or $SkipElix Then ContinueLoop
							Case "Dark Elixir"
								If Not $isFullDark Or $SkipDE Then ContinueLoop
							Case Else
								ContinueLoop
						EndSwitch
						SetLog("Try Forge using " & $aResource[$i][0], $COLOR_INFO)
						Click($aResource[$i][2], 270 + $g_iMidOffsetY)
						If _Sleep(1000) Then Return
						Local $cost = getOcrAndCapture("coc-forge", 250, 350 + $g_iMidOffsetY, 110, 25, True)
						Local $gain = getOcrAndCapture("coc-forge", 530, 365 + $g_iMidOffsetY, 65, 25, True)
						Local $bSafeToForge = False
						Switch $aResource[$i][0]
							Case "Gold"
								If Number($cost) + Number($g_iacmdGoldSaveMin) <= $iCurrentGold Then $bSafeToForge = True
							Case "Elixir"
								If Number($cost) + Number($g_iacmdElixSaveMin) <= $iCurrentElix Then $bSafeToForge = True
							Case "Dark Elixir"
								If Number($cost) + Number($g_iacmdDarkSaveMin) <= $iCurrentDE Then $bSafeToForge = True
						EndSwitch
						SetLog("Forge Cost: " & _NumberFormat($cost, True) & ", gain Capital Gold: " & _NumberFormat($gain, True), $COLOR_ACTION)
						If Not $bSafeToForge Then
							SetLog("Not safe to forge with " & $aResource[$i][0] & ", not enough resource to save", $COLOR_INFO)
							Switch $aResource[$i][0]
								Case "Gold"
									$SkipGold = True
									$isFullGold = False
								Case "Elixir"
									$SkipElix = True
									$isFullElix = False
								Case "Dark Elixir"
									$SkipDE = True
									$isFullDark = False
							EndSwitch
							ContinueLoop
						EndIf
						If SkipCraftStart($aResource[$i][0], $cost, $iCurrentGold, $iCurrentElix, $iCurrentDE) Then
							Switch $aResource[$i][0]
								Case "Gold"
									$SkipGold = True
								Case "Elixir"
									$SkipElix = True
								Case "Dark Elixir"
									$SkipDE = True
							EndSwitch
							ContinueLoop
						EndIf
						If Not $g_bRunState Then Return
						If Not $bTest Then
							Click(430, 450 + $g_iMidOffsetY)
							SetLog("Success Forge with " & $aResource[$i][0] & ", will gain " & _NumberFormat($gain, True) & " Capital Gold", $COLOR_SUCCESS)
							$IsLowResource = False
							$g_iFreeBuilderCount -= 1
							If _Sleep(1000) Then Return
							Switch $aResource[$i][0]
								Case "Gold"
									$iCurrentGold = $iCurrentGold - Number($cost)
									SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentGold, True) & "", $COLOR_SUCCESS)
									$isFullGold = False
								Case "Elixir"
									$iCurrentElix = $iCurrentElix - Number($cost)
									SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentElix, True) & "", $COLOR_SUCCESS)
									$isFullElix = False
								Case "Dark Elixir"
									$iCurrentDE = $iCurrentDE - Number($cost)
									SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentDE, True) & "", $COLOR_SUCCESS)
									$isFullDark = False
							EndSwitch
							ContinueLoop 2
						Else
							SetLog("Only Test, should click on [430,480]", $COLOR_INFO)
							$IsLowResource = False
							$g_iFreeBuilderCount -= 1
							CloseWindow()
							Switch $aResource[$i][0]
								Case "Gold"
									$iCurrentGold = $iCurrentGold - Number($cost)
									SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentGold, True) & "", $COLOR_SUCCESS)
									$isFullGold = False
								Case "Elixir"
									$iCurrentElix = $iCurrentElix - Number($cost)
									SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentElix, True) & "", $COLOR_SUCCESS)
									$isFullElix = False
								Case "Dark Elixir"
									$iCurrentDE = $iCurrentDE - Number($cost)
									SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentDE, True) & "", $COLOR_SUCCESS)
									$isFullDark = False
							EndSwitch
							ContinueLoop 2
						EndIf
					EndIf
					If _Sleep(1000) Then Return
					If Not $g_bRunState Then Return
				Next
			Else
				$aResource = SortResources(Number($iCurrentGold), Number($iCurrentElix), Number($iCurrentDE), Number($g_aiCurrentLootBB[$eLootGoldBB]), Number($g_aiCurrentLootBB[$eLootElixirBB]))
			EndIf

			For $i = 0 To UBound($aResource) - 1
				If $aResource[$i][3] = True Then ;check if ForgeType Enabled
					Switch $aResource[$i][0]
						Case "Gold"
							If $SkipGold Then ContinueLoop
						Case "Elixir"
							If $SkipElix Then ContinueLoop
						Case "Dark Elixir"
							If $SkipDE Then ContinueLoop
					EndSwitch
					SetLog("Try Forge using " & $aResource[$i][0], $COLOR_INFO)
					Click($aResource[$i][2], 270 + $g_iMidOffsetY)
					If _Sleep(1000) Then Return
					Local $cost = getOcrAndCapture("coc-forge", 250, 350 + $g_iMidOffsetY, 110, 25, True)
					Local $gain = getOcrAndCapture("coc-forge", 530, 365 + $g_iMidOffsetY, 65, 25, True)
					Local $ResCostDiff = -1
					Switch $aResource[$i][0]
						Case "Gold"
							$ResCostDiff = $iCurrentGold - Number($cost)
						Case "Elixir"
							$ResCostDiff = $iCurrentElix - Number($cost)
						Case "Dark Elixir"
							$ResCostDiff = $iCurrentDE - Number($cost)
						Case "Builder Base Gold"
							$ResCostDiff = $g_aiCurrentLootBB[$eLootGoldBB] - Number($cost)
						Case "Builder Base Elixir"
							$ResCostDiff = $g_aiCurrentLootBB[$eLootElixirBB] - Number($cost)
					EndSwitch
					If $cost = "" Or $ResCostDiff < 0 Then
						SetLog("Not enough resource to forge with " & $aResource[$i][0], $COLOR_INFO)
						Switch $aResource[$i][0]
							Case "Gold"
								$SkipGold = True
							Case "Elixir"
								$SkipElix = True
							Case "Dark Elixir"
								$SkipDE = True
						EndSwitch
						ContinueLoop
					EndIf
					Local $bSafeToForge = False
					Switch $aResource[$i][0]
						Case "Gold"
							If Number($cost) + Number($g_iacmdGoldSaveMin) <= $iCurrentGold Then $bSafeToForge = True
						Case "Elixir"
							If Number($cost) + Number($g_iacmdElixSaveMin) <= $iCurrentElix Then $bSafeToForge = True
						Case "Dark Elixir"
							If Number($cost) + Number($g_iacmdDarkSaveMin) <= $iCurrentDE Then $bSafeToForge = True
						Case "Builder Base Gold"
							If Number($cost) + Number($g_iacmdBBGoldSaveMin) <= $g_aiCurrentLootBB[$eLootGoldBB] Then $bSafeToForge = True
						Case "Builder Base Elixir"
							If Number($cost) + Number($g_iacmdBBElixSaveMin) <= $g_aiCurrentLootBB[$eLootElixirBB] Then $bSafeToForge = True
					EndSwitch
					SetLog("Forge Cost: " & _NumberFormat($cost, True) & ", gain Capital Gold: " & _NumberFormat($gain, True), $COLOR_ACTION)
					If Not $bSafeToForge Then
						SetLog("Not safe to forge with " & $aResource[$i][0] & ", not enough resource to save", $COLOR_INFO)
						Switch $aResource[$i][0]
							Case "Gold"
								$SkipGold = True
							Case "Elixir"
								$SkipElix = True
							Case "Dark Elixir"
								$SkipDE = True
						EndSwitch
						ContinueLoop
					EndIf
					If SkipCraftStart($aResource[$i][0], $cost, $iCurrentGold, $iCurrentElix, $iCurrentDE) Then
						Switch $aResource[$i][0]
							Case "Gold"
								$SkipGold = True
							Case "Elixir"
								$SkipElix = True
							Case "Dark Elixir"
								$SkipDE = True
						EndSwitch
						ContinueLoop
					EndIf
					If Not $g_bRunState Then Return
					If Not $bTest Then
						Click(430, 450 + $g_iMidOffsetY)
						If isGemOpen(True) Then
							SetLog("Not enough resource to forge with " & $aResource[$i][0], $COLOR_INFO)
							Switch $aResource[$i][0]
								Case "Gold"
									$SkipGold = True
								Case "Elixir"
									$SkipElix = True
								Case "Dark Elixir"
									$SkipDE = True
							EndSwitch
							ContinueLoop
						EndIf
						SetLog("Success Forge with " & $aResource[$i][0] & ", will gain " & _NumberFormat($gain, True) & " Capital Gold", $COLOR_SUCCESS)
						$IsLowResource = False
						$g_iFreeBuilderCount -= 1
						If _Sleep(1000) Then Return
						Switch $aResource[$i][0]
							Case "Gold"
								$iCurrentGold = $iCurrentGold - Number($cost)
								SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentGold, True), $COLOR_SUCCESS)
							Case "Elixir"
								$iCurrentElix = $iCurrentElix - Number($cost)
								SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentElix, True), $COLOR_SUCCESS)
							Case "Dark Elixir"
								$iCurrentDE = $iCurrentDE - Number($cost)
								SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentDE, True), $COLOR_SUCCESS)
							Case "Builder Base Gold"
								$g_aiCurrentLootBB[$eLootGoldBB] = $g_aiCurrentLootBB[$eLootGoldBB] - Number($cost)
								SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($g_aiCurrentLootBB[$eLootGoldBB], True), $COLOR_SUCCESS)
							Case "Builder Base Elixir"
								$g_aiCurrentLootBB[$eLootElixirBB] = $g_aiCurrentLootBB[$eLootElixirBB] - Number($cost)
								SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($g_aiCurrentLootBB[$eLootElixirBB], True), $COLOR_SUCCESS)
						EndSwitch
						ExitLoop
					Else
						SetLog("Only Test, should click on [430,480]", $COLOR_INFO)
						$IsLowResource = False
						$g_iFreeBuilderCount -= 1
						CloseWindow()
						Switch $aResource[$i][0]
							Case "Gold"
								$iCurrentGold = $iCurrentGold - Number($cost)
								SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentGold, True), $COLOR_SUCCESS)
							Case "Elixir"
								$iCurrentElix = $iCurrentElix - Number($cost)
								SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentElix, True), $COLOR_SUCCESS)
							Case "Dark Elixir"
								$iCurrentDE = $iCurrentDE - Number($cost)
								SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentDE, True), $COLOR_SUCCESS)
							Case "Builder Base Gold"
								$g_aiCurrentLootBB[$eLootGoldBB] = $g_aiCurrentLootBB[$eLootGoldBB] - Number($cost)
								SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($g_aiCurrentLootBB[$eLootGoldBB], True), $COLOR_SUCCESS)
							Case "Builder Base Elixir"
								$g_aiCurrentLootBB[$eLootElixirBB] = $g_aiCurrentLootBB[$eLootElixirBB] - Number($cost)
								SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($g_aiCurrentLootBB[$eLootElixirBB], True), $COLOR_SUCCESS)
						EndSwitch
						ExitLoop
					EndIf
				EndIf
				If _Sleep(1000) Then Return
				If Not $g_bRunState Then Return
			Next
			If $IsLowResource Then CloseWindow()
			If Not $g_bRunState Then Return
		Next
	EndIf
	$g_aiCurrentLoot[$eLootGold] = $iCurrentGold
	$g_aiCurrentLoot[$eLootElixir] = $iCurrentElix
	$g_aiCurrentLoot[$eLootDarkElixir] = $iCurrentDE
	UpdateStats()
	If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
	If _Sleep(1000) Then Return
	CloseWindow()
EndFunc   ;==>ForgeClanCapitalGold

Func AutoForgeSlot($bTest, ByRef $iCurrentGold, ByRef $iCurrentElix, ByRef $iCurrentDE, ByRef $isFullGold, ByRef $isFullElix, ByRef $isFullDark, ByRef $SkipGold, ByRef $SkipElix, ByRef $SkipDE)
	Local $aResource
	Local $g_CraftLaunched = False

	If QuickMIS("BC1", $g_sImgCCGoldCraft, 240, 350 + $g_iMidOffsetY, 415, 420 + $g_iMidOffsetY) Then ;check if we have craft ready to start
		Click($g_iQuickMISX, $g_iQuickMISY)
		If _Sleep(500) Then Return
		If Not WaitStartCraftWindow() Then
			ClickAway()
			Return
		EndIf
		Local $IsLowResource = True

		If $isFullGold Or $isFullElix Or $isFullDark Then
			$aResource = SortResources(Number($iCurrentGold), Number($iCurrentElix), Number($iCurrentDE), Number($g_aiCurrentLootBB[$eLootGoldBB]), Number($g_aiCurrentLootBB[$eLootElixirBB]))
			For $i = 0 To UBound($aResource) - 1
				If $aResource[$i][3] = True Then ;check if ForgeType Enabled
					SetLog("Try Forge using " & $aResource[$i][0], $COLOR_INFO)
					Click($aResource[$i][2], 270 + $g_iMidOffsetY)
					If _Sleep(1000) Then Return
					Local $cost = getOcrAndCapture("coc-forge", 240, 358 + $g_iMidOffsetY, 160, 25, True)
					Local $gain = getOcrAndCapture("coc-forge", 530, 365 + $g_iMidOffsetY, 65, 25, True)
					Local $bSafeToForge = False
					Switch $aResource[$i][0]
						Case "Gold"
							If Number($cost) + Number($g_iacmdGoldSaveMin) <= $iCurrentGold Then $bSafeToForge = True
						Case "Elixir"
							If Number($cost) + Number($g_iacmdElixSaveMin) <= $iCurrentElix Then $bSafeToForge = True
						Case "Dark Elixir"
							If Number($cost) + Number($g_iacmdDarkSaveMin) <= $iCurrentDE Then $bSafeToForge = True
					EndSwitch
					SetLog("Forge Cost: " & _NumberFormat($cost, True) & ", gain Capital Gold: " & _NumberFormat($gain, True), $COLOR_ACTION)
					If Not $bSafeToForge Then
						SetLog("Not safe to forge with " & $aResource[$i][0] & ", not enough resource to save", $COLOR_INFO)
						Switch $aResource[$i][0]
							Case "Gold"
								$SkipGold = True
								$isFullGold = False
							Case "Elixir"
								$SkipElix = True
								$isFullElix = False
							Case "Dark Elixir"
								$SkipDE = True
								$isFullDark = False
						EndSwitch
						ContinueLoop
					EndIf
					If SkipCraftStart($aResource[$i][0], $cost, $iCurrentGold, $iCurrentElix, $iCurrentDE) Then
						Switch $aResource[$i][0]
							Case "Gold"
								$SkipGold = True
							Case "Elixir"
								$SkipElix = True
							Case "Dark Elixir"
								$SkipDE = True
						EndSwitch
						ContinueLoop
					EndIf
					If Not $g_bRunState Then Return
					If Not $bTest Then
						Click(430, 450 + $g_iMidOffsetY)
						SetLog("Success Forge with " & $aResource[$i][0] & ", will gain " & _NumberFormat($gain, True) & " Capital Gold", $COLOR_SUCCESS)
						$IsLowResource = False
						$g_CraftLaunched = True
						If _Sleep(1000) Then Return
						Switch $aResource[$i][0]
							Case "Gold"
								$iCurrentGold = $iCurrentGold - Number($cost)
								SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentGold, True), $COLOR_SUCCESS)
								$isFullGold = False
							Case "Elixir"
								$iCurrentElix = $iCurrentElix - Number($cost)
								SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentElix, True), $COLOR_SUCCESS)
								$isFullElix = False
							Case "Dark Elixir"
								$iCurrentDE = $iCurrentDE - Number($cost)
								SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentDE, True), $COLOR_SUCCESS)
								$isFullDark = False
						EndSwitch
						Return True
					Else
						SetLog("Only Test, should click on [430,480]", $COLOR_INFO)
						$IsLowResource = False
						$g_CraftLaunched = True
						CloseWindow()
						Switch $aResource[$i][0]
							Case "Gold"
								$iCurrentGold = $iCurrentGold - Number($cost)
								SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentGold, True), $COLOR_SUCCESS)
								$isFullGold = False
							Case "Elixir"
								$iCurrentElix = $iCurrentElix - Number($cost)
								SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentElix, True), $COLOR_SUCCESS)
								$isFullElix = False
							Case "Dark Elixir"
								$iCurrentDE = $iCurrentDE - Number($cost)
								SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentDE, True), $COLOR_SUCCESS)
								$isFullDark = False
						EndSwitch
						Return True
					EndIf
				EndIf
				If _Sleep(1000) Then Return
				If Not $g_bRunState Then Return
			Next
		Else
			$aResource = SortResources(Number($iCurrentGold), Number($iCurrentElix), Number($iCurrentDE), Number($g_aiCurrentLootBB[$eLootGoldBB]), Number($g_aiCurrentLootBB[$eLootElixirBB]))
		EndIf

		For $i = 0 To UBound($aResource) - 1
			If $aResource[$i][3] = True Then ;check if ForgeType Enabled
				Switch $aResource[$i][0]
					Case "Gold"
						If $SkipGold Then ContinueLoop
					Case "Elixir"
						If $SkipElix Then ContinueLoop
					Case "Dark Elixir"
						If $SkipDE Then ContinueLoop
				EndSwitch
				SetLog("Try Forge using " & $aResource[$i][0], $COLOR_INFO)
				Click($aResource[$i][2], 270 + $g_iMidOffsetY)
				If _Sleep(1000) Then Return
				Local $cost = getOcrAndCapture("coc-forge", 240, 358 + $g_iMidOffsetY, 160, 25, True)
				Local $gain = getOcrAndCapture("coc-forge", 530, 365 + $g_iMidOffsetY, 65, 25, True)
				Local $ResCostDiff = -1
				Switch $aResource[$i][0]
					Case "Gold"
						$ResCostDiff = $iCurrentGold - Number($cost)
					Case "Elixir"
						$ResCostDiff = $iCurrentElix - Number($cost)
					Case "Dark Elixir"
						$ResCostDiff = $iCurrentDE - Number($cost)
					Case "Builder Base Gold"
						$ResCostDiff = $g_aiCurrentLootBB[$eLootGoldBB] - Number($cost)
					Case "Builder Base Elixir"
						$ResCostDiff = $g_aiCurrentLootBB[$eLootElixirBB] - Number($cost)
				EndSwitch
				If $cost = "" Or $ResCostDiff < 0 Then
					SetLog("Not enough resource to forge with " & $aResource[$i][0], $COLOR_INFO)
					Switch $aResource[$i][0]
						Case "Gold"
							$SkipGold = True
						Case "Elixir"
							$SkipElix = True
						Case "Dark Elixir"
							$SkipDE = True
					EndSwitch
					ContinueLoop
				EndIf
				Local $bSafeToForge = False
				Switch $aResource[$i][0]
					Case "Gold"
						If Number($cost) + Number($g_iacmdGoldSaveMin) <= $iCurrentGold Then $bSafeToForge = True
					Case "Elixir"
						If Number($cost) + Number($g_iacmdElixSaveMin) <= $iCurrentElix Then $bSafeToForge = True
					Case "Dark Elixir"
						If Number($cost) + Number($g_iacmdDarkSaveMin) <= $iCurrentDE Then $bSafeToForge = True
					Case "Builder Base Gold"
						If Number($cost) + Number($g_iacmdBBGoldSaveMin) <= $g_aiCurrentLootBB[$eLootGoldBB] Then $bSafeToForge = True
					Case "Builder Base Elixir"
						If Number($cost) + Number($g_iacmdBBElixSaveMin) <= $g_aiCurrentLootBB[$eLootElixirBB] Then $bSafeToForge = True
				EndSwitch
				SetLog("Forge Cost: " & _NumberFormat($cost, True) & ", gain Capital Gold: " & _NumberFormat($gain, True), $COLOR_ACTION)
				If Not $bSafeToForge Then
					SetLog("Not safe to forge with " & $aResource[$i][0] & ", not enough resource to save", $COLOR_INFO)
					Switch $aResource[$i][0]
						Case "Gold"
							$SkipGold = True
						Case "Elixir"
							$SkipElix = True
						Case "Dark Elixir"
							$SkipDE = True
					EndSwitch
					ContinueLoop
				EndIf
				If SkipCraftStart($aResource[$i][0], $cost, $iCurrentGold, $iCurrentElix, $iCurrentDE) Then
					Switch $aResource[$i][0]
						Case "Gold"
							$SkipGold = True
						Case "Elixir"
							$SkipElix = True
						Case "Dark Elixir"
							$SkipDE = True
					EndSwitch
					ContinueLoop
				EndIf
				If Not $g_bRunState Then Return
				If Not $bTest Then
					Click(430, 450 + $g_iMidOffsetY)
					If isGemOpen(True) Then
						SetLog("Not enough resource to forge with " & $aResource[$i][0], $COLOR_INFO)
						Switch $aResource[$i][0]
							Case "Gold"
								$SkipGold = True
							Case "Elixir"
								$SkipElix = True
							Case "Dark Elixir"
								$SkipDE = True
						EndSwitch
						ContinueLoop
					EndIf
					SetLog("Success Forge with " & $aResource[$i][0] & ", will gain " & _NumberFormat($gain, True) & " Capital Gold", $COLOR_SUCCESS)
					$IsLowResource = False
					$g_CraftLaunched = True
					If _Sleep(1000) Then Return
					Switch $aResource[$i][0]
						Case "Gold"
							$iCurrentGold = $iCurrentGold - Number($cost)
							SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentGold, True), $COLOR_SUCCESS)
						Case "Elixir"
							$iCurrentElix = $iCurrentElix - Number($cost)
							SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentElix, True), $COLOR_SUCCESS)
						Case "Dark Elixir"
							$iCurrentDE = $iCurrentDE - Number($cost)
							SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentDE, True), $COLOR_SUCCESS)
						Case "Builder Base Gold"
							$g_aiCurrentLootBB[$eLootGoldBB] = $g_aiCurrentLootBB[$eLootGoldBB] - Number($cost)
							SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($g_aiCurrentLootBB[$eLootGoldBB], True), $COLOR_SUCCESS)
						Case "Builder Base Elixir"
							$g_aiCurrentLootBB[$eLootElixirBB] = $g_aiCurrentLootBB[$eLootElixirBB] - Number($cost)
							SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($g_aiCurrentLootBB[$eLootElixirBB], True), $COLOR_SUCCESS)
					EndSwitch
					ExitLoop
				Else
					SetLog("Only Test, should click on [430,480]", $COLOR_INFO)
					$IsLowResource = False
					$g_CraftLaunched = True
					CloseWindow()
					Switch $aResource[$i][0]
						Case "Gold"
							$iCurrentGold = $iCurrentGold - Number($cost)
							SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentGold, True), $COLOR_SUCCESS)
						Case "Elixir"
							$iCurrentElix = $iCurrentElix - Number($cost)
							SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentElix, True), $COLOR_SUCCESS)
						Case "Dark Elixir"
							$iCurrentDE = $iCurrentDE - Number($cost)
							SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentDE, True), $COLOR_SUCCESS)
						Case "Builder Base Gold"
							$g_aiCurrentLootBB[$eLootGoldBB] = $g_aiCurrentLootBB[$eLootGoldBB] - Number($cost)
							SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($g_aiCurrentLootBB[$eLootGoldBB], True), $COLOR_SUCCESS)
						Case "Builder Base Elixir"
							$g_aiCurrentLootBB[$eLootElixirBB] = $g_aiCurrentLootBB[$eLootElixirBB] - Number($cost)
							SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($g_aiCurrentLootBB[$eLootElixirBB], True), $COLOR_SUCCESS)
					EndSwitch
					ExitLoop
				EndIf
			EndIf
			If _Sleep(1000) Then Return
			If Not $g_bRunState Then Return
		Next
		If $IsLowResource Then CloseWindow()
		If Not $g_bRunState Then Return
		If Not $g_CraftLaunched Then Return False
	EndIf
	Return True
EndFunc   ;==>AutoForgeSlot

Func IsCCBuilderMenuOpen()
	Local $bRet = False
	For $i = 0 To 3
		If IsArray(_PixelSearch(399, 72, 401, 74, Hex(0xFFFFFF, 6), 15, True)) Then
			SetDebugLog("Found White Border Color", $COLOR_ACTION)
			$bRet = True ;got correct color for border
			ExitLoop
		EndIf
		If _Sleep(350) Then Return
	Next
	Return $bRet
EndFunc   ;==>IsCCBuilderMenuOpen

Func ClickCCBuilder()
	Local $bRet = False
	If IsCCBuilderMenuOpen() Then $bRet = True
	If Not $bRet Then
		If QuickMIS("BC1", $g_sImgCCMap, 300, 10, 430, 40) Then
			Click($g_iQuickMISX, $g_iQuickMISY)
			If _Sleep(1000) Then Return
			If IsCCBuilderMenuOpen() Then $bRet = True
		EndIf
	EndIf
	Return $bRet
EndFunc   ;==>ClickCCBuilder

Func FindCCExistingUpgrade()
	Local $aResult[0][3], $aBackup[0][3], $name[2] = ["", 0]
	Local $IsFoundArmy = False
	Local $isIgnored = 0
	Local $aUpgrade = QuickMIS("CNX", $g_sImgResourceCC, 400, 100, 565, 330 + $g_iMidOffsetY)
	If IsArray($aUpgrade) And UBound($aUpgrade) > 0 Then
		_ArraySort($aUpgrade, 0, 0, 0, 2) ;sort by Y coord

		For $i = 0 To UBound($aUpgrade) - 1
			If IsIgnored($aUpgrade[$i][1], $aUpgrade[$i][2], False) Then $isIgnored += 1
		Next
		If $isIgnored = UBound($aUpgrade) Then
			SetLog("All upgrades in progress are to be ignored", $COLOR_ERROR)
			Return 0
		EndIf

		For $i = 0 To UBound($aUpgrade) - 1
			If Not $g_bChkAutoUpgradeCCPriorArmy Then ExitLoop
			$name = getCCBuildingName($aUpgrade[$i][1] - 275, $aUpgrade[$i][2] - 8)
			For $y In $g_bCCPriorArmy
				If StringInStr($name[0], $y) Then
					SetLog("Upgrade for Army Stuff Detected", $COLOR_SUCCESS1)
					$aResult = $aBackup
					_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
					$IsFoundArmy = True
					ExitLoop 2
				EndIf
			Next
		Next
		If $IsFoundArmy = True Then Return $aResult

		For $i = 0 To UBound($aUpgrade) - 1
			$name = getCCBuildingName($aUpgrade[$i][1] - 275, $aUpgrade[$i][2] - 8)
			If $g_bChkAutoUpgradeCCIgnore Then
				For $y In $aCCBuildingIgnore
					If StringInStr($name[0], $y) Then
						SetLog("Upgrade for " & $name[0] & " Ignored, Skip!!", $COLOR_ACTION)
						ContinueLoop 2 ;skip this upgrade, looking next
					EndIf
				Next
			EndIf
			If $g_bChkAutoUpgradeCCWallIgnore Then ; Filter for wall
				If StringInStr($name[0], "Wall") Then
					SetLog("Upgrade for Walls Ignored, Skip!!", $COLOR_ACTION)
					ContinueLoop ;skip this upgrade, looking next
				EndIf
			EndIf
			_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
		Next

	EndIf
	Return $aResult
EndFunc   ;==>FindCCExistingUpgrade

Func FindCCSuggestedUpgrade()
	Local $aResult[0][3], $aBackup[0][3], $name[2] = ["", 0]
	Local $IsFoundArmy = False
	Local $aUpgrade = QuickMIS("CNX", $g_sImgResourceCC, 400, 100, 565, 330 + $g_iMidOffsetY)
	If IsArray($aUpgrade) And UBound($aUpgrade) > 0 Then
		_ArraySort($aUpgrade, 0, 0, 0, 2) ;sort by Y coord

		For $i = 0 To UBound($aUpgrade) - 1
			SetDebugLog("Pixel on " & $aUpgrade[$i][1] - 15 & "," & $aUpgrade[$i][2] - 6 & ": " & _GetPixelColor($aUpgrade[$i][1] - 10, $aUpgrade[$i][2] - 5, True), $COLOR_INFO)
			If _ColorCheck(_GetPixelColor($aUpgrade[$i][1] - 15, $aUpgrade[$i][2] - 6, True), Hex(0xffffff, 6), 20) Then ContinueLoop ;check if we have progressbar, upgrade to ignore
			$name = getCCBuildingNameSuggested($aUpgrade[$i][1] - 235, $aUpgrade[$i][2] - 12)

			If QuickMIS("BC1", $g_sImgDecoration, $aUpgrade[$i][1] - 260, $aUpgrade[$i][2] - 20, $aUpgrade[$i][1] - 160, $aUpgrade[$i][2] + 10) Then
				$name = getCCBuildingNameBlue($aUpgrade[$i][1] - 230, $aUpgrade[$i][2] - 14)
			EndIf

			If $g_bChkAutoUpgradeCCPriorArmy Then
				For $y In $g_bCCPriorArmy
					If StringInStr($name[0], $y) Then
						SetLog("Upgrade for Army Stuff Detected", $COLOR_SUCCESS1)
						$aResult = $aBackup
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
						$IsFoundArmy = True
						ExitLoop 2
					EndIf
				Next
			EndIf
		Next
		If $IsFoundArmy = True Then Return $aResult

		For $i = 0 To UBound($aUpgrade) - 1
			SetDebugLog("Pixel on " & $aUpgrade[$i][1] - 15 & "," & $aUpgrade[$i][2] - 6 & ": " & _GetPixelColor($aUpgrade[$i][1] - 10, $aUpgrade[$i][2] - 5, True), $COLOR_INFO)
			If _ColorCheck(_GetPixelColor($aUpgrade[$i][1] - 15, $aUpgrade[$i][2] - 6, True), Hex(0xffffff, 6), 20) Then ContinueLoop ;check if we have progressbar, upgrade to ignore
			$name = getCCBuildingNameSuggested($aUpgrade[$i][1] - 235, $aUpgrade[$i][2] - 12)

			If QuickMIS("BC1", $g_sImgDecoration, $aUpgrade[$i][1] - 260, $aUpgrade[$i][2] - 20, $aUpgrade[$i][1] - 160, $aUpgrade[$i][2] + 10) Then
				$name = getCCBuildingNameBlue($aUpgrade[$i][1] - 230, $aUpgrade[$i][2] - 14)
			EndIf

			If $g_bChkAutoUpgradeCCIgnore Then
				For $y In $aCCBuildingIgnore
					If StringInStr($name[0], $y) Then
						SetLog("Upgrade for " & $name[0] & " Ignored, Skip!!", $COLOR_ACTION)
						ContinueLoop 2 ;skip this upgrade, looking next
					EndIf
				Next
			EndIf
			If $g_bChkAutoUpgradeCCWallIgnore Then ; Filter for wall
				If StringInStr($name[0], "Wall") Then
					SetLog("Upgrade for Walls Ignored, Skip!!", $COLOR_ACTION)
					ContinueLoop ;skip this upgrade, looking next
				EndIf
			EndIf
			_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
		Next
	EndIf
	Return $aResult
EndFunc   ;==>FindCCSuggestedUpgrade

Func WaitUpgradeButtonCC()
	Local $aRet[3] = [False, 0, 0]
	For $i = 1 To 10
		If Not $g_bRunState Then Return $aRet
		SetLog("Waiting for Upgrade Button #" & $i, $COLOR_ACTION)
		If QuickMIS("BC1", $g_sImgCCUpgradeButton, 300, 510 + $g_iBottomOffsetY, 600, 620 + $g_iBottomOffsetY) Then ;check for upgrade button (Hammer)
			$aRet[0] = True
			$aRet[1] = $g_iQuickMISX
			$aRet[2] = $g_iQuickMISY
			If _Sleep(250) Then Return
			Return $aRet ;immediately return as we found upgrade button
		EndIf
		If _Sleep(1000) Then Return
	Next
	Return $aRet
EndFunc   ;==>WaitUpgradeButtonCC

Func WaitUpgradeWindowCC()
	Local $bRet = False
	For $i = 1 To 10
		SetLog("Waiting for Upgrade Window #" & $i, $COLOR_ACTION)
		If _Sleep(1000) Then Return
		If QuickMIS("BC1", $g_sImgGeneralCloseButton, 750, 60, 810, 90 + $g_iMidOffsetY) Then ;check if upgrade window opened
			$bRet = True
			Return $bRet
		EndIf
	Next
	If Not $bRet Then SetLog("Upgrade Window doesn't open", $COLOR_ERROR)
	Return $bRet
EndFunc   ;==>WaitUpgradeWindowCC

Func SwitchToMainVillage()
	Local $bRet = False, $loop = 0
	SetDebugLog("Going To MainVillage", $COLOR_ACTION)
	SwitchToCapitalMain()
	For $i = 1 To 20
		If QuickMIS("BC1", $g_sImgGeneralCloseButton, 780, 90, 840, 130 + $g_iMidOffsetY) Then ; check if we have window covering map, close it!
			SetLog("Found Raid Window Covering Map, Close it!", $COLOR_INFO)
			If _Sleep(Random(1250, 2000, 1)) Then Return
			Click($g_iQuickMISX, $g_iQuickMISY)
			If _Sleep(3000) Then Return
			SwitchToCapitalMain()
		EndIf
		If QuickMIS("BC1", $g_sImgCCMap, 15, 550 + $g_iBottomOffsetY, 115, 640 + $g_iBottomOffsetY) Then
			If $g_iQuickMISName = "ReturnHome" Then
				Click(60, 610 + $g_iBottomOffsetY) ;Click ReturnHome
				If _Sleep(2000) Then Return
				ExitLoop
			EndIf
		EndIf
		If _Sleep(250) Then Return
	Next

	While 1
		If isOnMainVillage(True) Then
			$bRet = True
			ExitLoop
		EndIf
		$loop += 1
		If $loop = 20 Then ExitLoop
		If _Sleep(500) Then Return
	WEnd

	If $bRet Then
		ZoomOut()
	Else
		SetLog("Main Village Not Found, Restarting COC", $COLOR_ERROR)
	EndIf
	Return $bRet
EndFunc   ;==>SwitchToMainVillage

Func SwitchToClanCapital()
	Local $bRet = False
	Local $bAirShipFound = False
	For $z = 0 To 14
		If QuickMIS("BC1", $g_sImgAirShip, 200, 510 + $g_iBottomOffsetY, 400, 670 + $g_iBottomOffsetY) Then
			$bAirShipFound = True
			Click($g_iQuickMISX, $g_iQuickMISY)
			If _Sleep(3000) Then Return
			ExitLoop
		EndIf
		If _Sleep(250) Then Return
	Next
	If $bAirShipFound = False Then Return $bRet
	For $i = 0 To 14
		If QuickMIS("BC1", $g_sImgGeneralCloseButton, 780, 90, 840, 130 + $g_iMidOffsetY) Then
			SetLog("Found Raid Window Covering Map, Close it!", $COLOR_INFO)
			If _Sleep(Random(1250, 2000, 1)) Then Return
			Click($g_iQuickMISX, $g_iQuickMISY)
			If _Sleep(3000) Then Return
			ExitLoop
		EndIf
		If _Sleep(250) Then Return
		If QuickMIS("BC1", $g_sImgCCMap, 15, 550 + $g_iBottomOffsetY, 115, 640 + $g_iBottomOffsetY) Then
			If $g_iQuickMISName = "ReturnHome" Then
				SetDebugLog("We are on Clan Capital", $COLOR_ACTION)
				ExitLoop
			EndIf
		EndIf
	Next
	For $t = 0 To 14
		If QuickMIS("BC1", $g_sImgCCRaid, 360, 445 + $g_iMidOffsetY, 500, 500 + $g_iMidOffsetY) Then
			Click($g_iQuickMISX, $g_iQuickMISY)
			If _Sleep(6000) Then Return
			ExitLoop
		EndIf
		If _Sleep(250) Then Return
		If QuickMIS("BC1", $g_sImgCCMap, 15, 550 + $g_iBottomOffsetY, 115, 640 + $g_iBottomOffsetY) Then
			If $g_iQuickMISName = "ReturnHome" Then
				SetDebugLog("We are on Clan Capital", $COLOR_ACTION)
				ExitLoop
			EndIf
		EndIf
	Next
	SwitchToCapitalMain()
	For $i = 1 To 10
		SetDebugLog("Waiting for Travel to Clan Capital Map #" & $i, $COLOR_ACTION)
		If QuickMIS("BC1", $g_sImgCCMap, 300, 10, 430, 65) Then
			$bRet = True
			SetLog("Success Travel to Clan Capital Map", $COLOR_INFO)
			ExitLoop
		EndIf
		If _Sleep(800) Then Return
	Next
	If $bRet Then ClanCapitalReport()
	Return $bRet
EndFunc   ;==>SwitchToClanCapital

Func SwitchToCapitalMain()
	Local $bRet = False
	SetDebugLog("Going to Clan Capital", $COLOR_ACTION)
	For $i = 1 To 14
		If QuickMIS("BC1", $g_sImgCCMap, 15, 550 + $g_iBottomOffsetY, 115, 640 + $g_iBottomOffsetY) Then
			If $g_iQuickMISName = "MapButton" Then
				Click(60, 610 + $g_iBottomOffsetY) ;Click Map
				If _Sleep(3000) Then Return
			EndIf
		EndIf
		If QuickMIS("BC1", $g_sImgCCMap, 15, 550 + $g_iBottomOffsetY, 115, 640 + $g_iBottomOffsetY) Then
			If $g_iQuickMISName = "ReturnHome" Then
				SetDebugLog("We are on Clan Capital", $COLOR_ACTION)
				$bRet = True
				ExitLoop
			EndIf
		EndIf
		If _Sleep(250) Then Return
	Next
	Return $bRet
EndFunc   ;==>SwitchToCapitalMain

Func AutoUpgradeCC()
	If Not $g_bChkEnableAutoUpgradeCC Then Return
	Local $Failed = False
	SetLog("Checking Clan Capital AutoUpgrade", $COLOR_INFO)
	ZoomOut() ;ZoomOut first
	If Not SwitchToClanCapital() Then Return
	If _Sleep(1000) Then Return
	If Number($g_iLootCCGold) = 0 Then
		SetLog("No Capital Gold to spend to Contribute", $COLOR_INFO)
		If _Sleep(2500) Then Return
		If Not SwitchToMainVillage() Then
			CloseCoC(True)
			checkMainScreen()
		EndIf
		Return
	EndIf

	While $g_iLootCCGold > 0
		If Not $g_bRunState Then Return
		If ClickCCBuilder() Then
			If _Sleep(1000) Then Return
			Local $Text = getOcrAndCapture("coc-buildermenu-capital", 345, 81, 100, 25)
			If StringInStr($Text, "No") Then
				SetLog("No Upgrades in progress", $COLOR_INFO)
				If _Sleep(500) Then Return
				ClickAway("Right") ;close builder menu
				ClanCapitalReport(False)
				ExitLoop
			EndIf
		Else
			SetLog("Fail to open Builder Menu", $COLOR_ERROR)
			$Failed = True
			ExitLoop
		EndIf
		If _Sleep(500) Then Return
		Local $aUpgrade = FindCCExistingUpgrade() ;Find on Capital Map, should only find currently on progress building
		If IsArray($aUpgrade) And UBound($aUpgrade) > 0 And UBound($aUpgrade, $UBOUND_COLUMNS) > 1 Then
			If Not CapitalMainUpgradeLoop($aUpgrade) Then
				$Failed = True
				ExitLoop
			EndIf
		Else
			ExitLoop
		EndIf
	WEnd

	If _Sleep(500) Then Return
	ClickAway("Right")
	If $Failed Then
		If Not SwitchToMainVillage() Then
			CloseCoC(True)
			checkMainScreen()
		EndIf
		Return
	EndIf

	;Upgrade through districts map
	Local $aMapCoord[9][3] = [["Goblin Mines", 580, 620], ["Skeleton Park", 375, 620], ["Golem Quarry", 185, 590], ["Dragon Cliffs", 630, 465], ["Builder's Workshop", 490, 525], ["Balloon Lagoon", 300, 490], _
			["Wizard Valley", 410, 400], ["Barbarian Camp", 530, 340], ["Capital Peak", 400, 225]]
	If Number($g_iLootCCGold) > 0 Then
		SetLog("Checking Upgrades From Districts", $COLOR_INFO)
		For $i = 0 To UBound($aMapCoord) - 1
			If _Sleep(1000) Then Return
			SetLog("[" & $i & "] Checking " & $aMapCoord[$i][0], $COLOR_ACTION)
			If QuickMIS("BC1", $g_sImgLock, $aMapCoord[$i][1], $aMapCoord[$i][2] - 120, $aMapCoord[$i][1] + 100, $aMapCoord[$i][2]) Then
				SetLog($aMapCoord[$i][0] & " is Locked", $COLOR_INFO)
				ContinueLoop
			Else
				SetLog($aMapCoord[$i][0] & " is UnLocked", $COLOR_INFO)
			EndIf
			SetLog("Go to " & $aMapCoord[$i][0] & " to Check Upgrades", $COLOR_ACTION)
			Click($aMapCoord[$i][1], $aMapCoord[$i][2])
			If Not $g_bRunState Then Return
			If _Sleep(2000) Then Return
			If Not WaitForMap($aMapCoord[$i][0]) Then
				SetLog("Going to " & $aMapCoord[$i][0] & " Failed", $COLOR_ERROR)
				SwitchToCapitalMain()
				If _Sleep(1500) Then Return
				ContinueLoop
			EndIf
			If Not ClickCCBuilder() Then
				SetLog("Fail to open Builder Menu", $COLOR_ERROR)
				SwitchToCapitalMain()
				If _Sleep(1500) Then Return
				ContinueLoop
			EndIf
			If _Sleep(1000) Then Return
			Local $aUpgrade = FindCCSuggestedUpgrade() ;Find on Distric Map, Will Read Blue Font (Ruins.. etc)
			If IsArray($aUpgrade) And UBound($aUpgrade) > 0 And UBound($aUpgrade, $UBOUND_COLUMNS) > 1 Then
				DistrictUpgrade($aUpgrade)
				If Number($g_iLootCCGold) = 0 Then
					ExitLoop
				EndIf
			Else
				Local $Text = getOcrAndCapture("coc-buildermenu", 300, 81, 230, 25)
				Local $aDone[2] = ["All possible", "done"]
				For $z In $aDone
					If StringInStr($Text, $z) Then
						SetDebugLog("Match with: " & $z)
						SetLog("All Possible Upgrades Done In This District", $COLOR_INFO)
					EndIf
				Next
			EndIf
			SwitchToCapitalMain()
			If Not $g_bRunState Then Return
		Next
	EndIf
	ClanCapitalReport(False)
	If Not $g_bRunState Then Return
	If Not SwitchToMainVillage() Then
		CloseCoC(True)
		checkMainScreen()
	EndIf
EndFunc   ;==>AutoUpgradeCC

Func CapitalMainUpgradeLoop($aUpgrade)
	Local $aRet[3] = [False, 0, 0]
	Local $Failed = False
	If _Sleep(1000) Then Return
	SetLog("Checking Upgrades From Capital Map", $COLOR_INFO)
	For $i = 0 To UBound($aUpgrade) - 1
		SetDebugLog("CCExistingUpgrade: " & $aUpgrade[$i][0])
		Click($aUpgrade[$i][1], $aUpgrade[$i][2])
		If _Sleep(3000) Then Return
		$aRet = WaitUpgradeButtonCC()
		If Not $g_bRunState Then Return
		If Not $aRet[0] Then
			SetLog("Upgrade Button Not Found", $COLOR_ERROR)
			$Failed = True
			ExitLoop
		Else
			If IsUpgradeCCIgnore() Then
				SetLog("Upgrade Ignored, Back To Main Village", $COLOR_INFO) ; Should Never happen
				$Failed = True
				ExitLoop
			EndIf
			Local $BuildingName = getOcrAndCapture("coc-build", 180, 512 + $g_iBottomOffsetY, 510, 25)
			Click($aRet[1], $aRet[2])
			If _Sleep(2000) Then Return
			If Not WaitUpgradeWindowCC() Then
				$Failed = True
				ExitLoop
			EndIf
			If Not $g_bRunState Then Return
			Click(700, 575 + $g_iMidOffsetY) ;Click Contribute
			$g_iStatsClanCapUpgrade = $g_iStatsClanCapUpgrade + 1
			AutoUpgradeCCLog($BuildingName)
			If _Sleep(1000) Then Return
			ClickAway("Right")
			If _Sleep(2000) Then Return
		EndIf
		ExitLoop
	Next
	SwitchToCapitalMain()
	If _Sleep(1000) Then Return
	ClanCapitalReport(False)
	If $Failed Then
		Return False
	Else
		Return True
	EndIf
EndFunc   ;==>CapitalMainUpgradeLoop

Func DistrictUpgrade($aUpgrade)
	Local $aRet[3] = [False, 0, 0]
	If _Sleep(1000) Then Return
	For $j = 0 To UBound($aUpgrade) - 1
		SetDebugLog("CCSuggestedUpgrade: " & $aUpgrade[$j][0])
		Click($aUpgrade[$j][1], $aUpgrade[$j][2])
		If _Sleep(3000) Then Return
		$aRet = WaitUpgradeButtonCC()
		If Not $aRet[0] Then
			SetLog("Upgrade Button Not Found", $COLOR_ERROR)
			ExitLoop
		Else
			If IsUpgradeCCIgnore() Then
				SetLog("Upgrade Ignored, Looking Next Upgrade", $COLOR_INFO) ; Shouldn't happen
				ContinueLoop
			EndIf
			Local $BuildingName = getOcrAndCapture("coc-build", 180, 512 + $g_iBottomOffsetY, 510, 25)
			Click($aRet[1], $aRet[2])
			If _Sleep(2000) Then Return
			If Not WaitUpgradeWindowCC() Then
				ExitLoop
			EndIf
			If Not $g_bRunState Then Return
			Click(700, 575 + $g_iMidOffsetY) ;Click Contribute
			$g_iStatsClanCapUpgrade = $g_iStatsClanCapUpgrade + 1
			AutoUpgradeCCLog($BuildingName)
			If _Sleep(1500) Then Return
			ClickAway("Right")
			If _Sleep(1500) Then Return
			ClickAway("Right")
		EndIf
		ExitLoop
	Next
	If _Sleep(1000) Then Return
	SwitchToCapitalMain()
	If _Sleep(2000) Then Return
	ClanCapitalReport(False)
EndFunc   ;==>DistrictUpgrade

Func WaitForMap($sMapName = "Capital Peak")
	Local $bRet = False
	For $i = 1 To 10
		SetDebugLog("Waiting for " & $sMapName & "#" & $i, $COLOR_ACTION)
		If QuickMIS("BC1", $g_sImgCCMap, 300, 10, 430, 40) Then
			If _Sleep(500) Then Return
			ExitLoop
		EndIf
		If _Sleep(1000) Then Return
		If $i = 10 Then Return $bRet
	Next
	Local $aMapName = StringSplit($sMapName, " ", $STR_NOCOUNT)
	SetDebugLog("checking with image", $COLOR_DEBUG)
	Local $bLoop = 0
	While 1
		Local $ccMap = QuickMIS("CNX", $g_sImgCCMapName, $g_iQuickMISX, $g_iQuickMISY - 10, $g_iQuickMISX + 220, $g_iQuickMISY + 20)
		If IsArray($ccMap) And UBound($ccMap) > 0 Then ExitLoop
		$bLoop += 1
		If _Sleep(250) Then Return
		If $bLoop = 20 Then Return $bRet
	WEnd
	Local $mapName = "dummyName"
	For $z = 0 To UBound($ccMap) - 1
		$mapName = String($ccMap[$z][0])
		For $i In $aMapName
			If StringInStr($mapName, $i) Then
				SetDebugLog("Match with: " & $i)
				$bRet = True
				SetLog("We are on " & $sMapName, $COLOR_INFO)
				ExitLoop
			EndIf
		Next
	Next
	Return $bRet
EndFunc   ;==>WaitForMap

Func IsUpgradeCCIgnore()
	Local $bRet = False
	Local $UpgradeName = getOcrAndCapture("coc-build", 180, 512 + $g_iBottomOffsetY, 510, 25)
	If $g_bChkAutoUpgradeCCWallIgnore Then ; Filter for wall
		If StringInStr($UpgradeName, "Wall") Then
			SetDebugLog($UpgradeName & " Match with: Wall")
			SetLog("Upgrade for wall Ignored, Skip!!", $COLOR_ACTION)
			$bRet = True
		EndIf
	EndIf
	If $g_bChkAutoUpgradeCCIgnore Then
		For $y In $aCCBuildingIgnore
			If StringInStr($UpgradeName, $y) Then
				SetDebugLog($UpgradeName & " Match with: " & $y)
				SetLog("Upgrade for " & $y & " Ignored, Skip!!", $COLOR_ACTION)
				$bRet = True
				ExitLoop
			Else
				SetDebugLog("OCR: " & $UpgradeName & " compare with: " & $y)
			EndIf
		Next
	EndIf
	Return $bRet
EndFunc   ;==>IsUpgradeCCIgnore

Func AutoUpgradeCCLog($BuildingName = "")
	SetLog("Successfully upgrade " & $BuildingName, $COLOR_SUCCESS)
	GUICtrlSetData($g_hTxtAutoUpgradeCCLog, @CRLF & _NowDate() & " " & _NowTime() & " [" & $g_sProfileCurrentName & "] - Upgrade " & $BuildingName, 1)
EndFunc   ;==>AutoUpgradeCCLog

Func IsIgnored($aUpgradeX, $aUpgradeY, $SetLog = True)
	Local $name[2] = ["", 0]
	Local $bRet = False
	$name = getCCBuildingName($aUpgradeX - 275, $aUpgradeY - 8)
	If $g_bChkAutoUpgradeCCWallIgnore Then
		If StringInStr($name[0], "Wall") Then
			If $SetLog Then SetLog("Upgrade for Wall Ignored, Skip!!", $COLOR_ACTION)
			$bRet = True ;skip this upgrade, looking next
		EndIf
	EndIf
	If $g_bChkAutoUpgradeCCIgnore Then
		For $y In $aCCBuildingIgnore
			If StringInStr($name[0], $y) Then
				If $SetLog Then SetLog("Upgrade for " & $name[0] & " Ignored, Skip!!", $COLOR_ACTION)
				$bRet = True ;skip this upgrade, looking next
			EndIf
		Next
	EndIf
	Return $bRet
EndFunc   ;==>IsIgnored

Func PicCCTrophies()
	_GUI_Value_STATE("HIDE", $g_aGroupCCLeague)
	If Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[21][1]) Then
		GUICtrlSetState($g_ahPicCCLeague[$eLeagueLegend], $GUI_SHOW)
		GUICtrlSetState($g_hLblCCLeague1, $GUI_HIDE)
		GUICtrlSetState($g_hLblCCLeague2, $GUI_HIDE)
		GUICtrlSetState($g_hLblCCLeague3, $GUI_HIDE)
	ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[18][1]) Then
		GUICtrlSetState($g_ahPicCCLeague[$eLeagueTitan], $GUI_SHOW)
		If Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[20][1]) Then
			GUICtrlSetState($g_hLblCCLeague1, $GUI_SHOW)
		ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[19][1]) Then
			GUICtrlSetState($g_hLblCCLeague2, $GUI_SHOW)
		ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[18][1]) Then
			GUICtrlSetState($g_hLblCCLeague3, $GUI_SHOW)
		EndIf
	ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[15][1]) Then
		GUICtrlSetState($g_ahPicCCLeague[$eLeagueChampion], $GUI_SHOW)
		If Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[17][1]) Then
			GUICtrlSetState($g_hLblCCLeague1, $GUI_SHOW)
		ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[16][1]) Then
			GUICtrlSetState($g_hLblCCLeague2, $GUI_SHOW)
		ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[15][1]) Then
			GUICtrlSetState($g_hLblCCLeague3, $GUI_SHOW)
		EndIf
	ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[12][1]) Then
		GUICtrlSetState($g_ahPicCCLeague[$eLeagueMaster], $GUI_SHOW)
		If Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[14][1]) Then
			GUICtrlSetState($g_hLblCCLeague1, $GUI_SHOW)
		ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[13][1]) Then
			GUICtrlSetState($g_hLblCCLeague2, $GUI_SHOW)
		ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[12][1]) Then
			GUICtrlSetState($g_hLblCCLeague3, $GUI_SHOW)
		EndIf
	ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[9][1]) Then
		GUICtrlSetState($g_ahPicCCLeague[$eLeagueCrystal], $GUI_SHOW)
		If Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[11][1]) Then
			GUICtrlSetState($g_hLblCCLeague1, $GUI_SHOW)
		ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[10][1]) Then
			GUICtrlSetState($g_hLblCCLeague2, $GUI_SHOW)
		ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[9][1]) Then
			GUICtrlSetState($g_hLblCCLeague3, $GUI_SHOW)
		EndIf
	ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[6][1]) Then
		GUICtrlSetState($g_ahPicCCLeague[$eLeagueGold], $GUI_SHOW)
		If Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[8][1]) Then
			GUICtrlSetState($g_hLblCCLeague1, $GUI_SHOW)
		ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[7][1]) Then
			GUICtrlSetState($g_hLblCCLeague2, $GUI_SHOW)
		ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[6][1]) Then
			GUICtrlSetState($g_hLblCCLeague3, $GUI_SHOW)
		EndIf
	ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[3][1]) Then
		GUICtrlSetState($g_ahPicCCLeague[$eLeagueSilver], $GUI_SHOW)
		If Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[5][1]) Then
			GUICtrlSetState($g_hLblCCLeague1, $GUI_SHOW)
		ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[4][1]) Then
			GUICtrlSetState($g_hLblCCLeague2, $GUI_SHOW)
		ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[3][1]) Then
			GUICtrlSetState($g_hLblCCLeague3, $GUI_SHOW)
		EndIf
	ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[0][1]) Then
		GUICtrlSetState($g_ahPicCCLeague[$eLeagueBronze], $GUI_SHOW)
		If Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[2][1]) Then
			GUICtrlSetState($g_hLblCCLeague1, $GUI_SHOW)
		ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[1][1]) Then
			GUICtrlSetState($g_hLblCCLeague2, $GUI_SHOW)
		ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[0][1]) Then
			GUICtrlSetState($g_hLblCCLeague3, $GUI_SHOW)
		EndIf
	Else
		GUICtrlSetState($g_ahPicCCLeague[$eLeagueUnranked], $GUI_SHOW)
		GUICtrlSetState($g_hLblCCLeague1, $GUI_HIDE)
		GUICtrlSetState($g_hLblCCLeague2, $GUI_HIDE)
		GUICtrlSetState($g_hLblCCLeague3, $GUI_HIDE)
	EndIf
EndFunc   ;==>PicCCTrophies

Func SortResources($iCurrentGold = 0, $iCurrentElix = 0, $iCurrentDE = 0, $g_aiCurrentGoldBB = 0, $g_aiCurrentElixBB = 0)
	Local $aResource[5][4] = [["Gold", $iCurrentGold, 240, $g_bChkEnableForgeGold], ["Elixir", $iCurrentElix, 330, $g_bChkEnableForgeElix], ["Dark Elixir", $iCurrentDE * 60, 425, $g_bChkEnableForgeDE], _
			["Builder Base Gold", $g_aiCurrentGoldBB * 4, 520, $g_bChkEnableForgeBBGold], ["Builder Base Elixir", $g_aiCurrentElixBB * 4, 610, $g_bChkEnableForgeBBElix]]
	If $g_bChkEnableSmartUse Then _ArraySort($aResource, 1, 0, 0, 1)

	Return $aResource
EndFunc   ;==>SortResources

Func SkipCraftStart($b_ResType = "Gold", $cost = 0, $iCurrentGold = 0, $iCurrentElix = 0, $iCurrentDE = 0) ; Dynamic Upgrades

	Local $iUpgradeAction = 0
	Local $iBuildingsNeedGold = 0
	Local $iBuildingsNeedElixir = 0
	Local $iBuildingsNeedDarkElixir = 0

	;;;;; Check building upgrade resouce needs .vs. available resources for crafts
	For $iz = 0 To UBound($g_avBuildingUpgrades, 1) - 1 ; loop through all upgrades to see if any are enabled.
		If $g_abBuildingUpgradeEnable[$iz] = True Then $iUpgradeAction += 1 ; count number enabled
	Next

	If $iUpgradeAction > 0 Then ; check if builder available for bldg upgrade, and upgrades enabled
		For $iz = 0 To UBound($g_avBuildingUpgrades, 1) - 1
			If $g_abBuildingUpgradeEnable[$iz] = True And $g_avBuildingUpgrades[$iz][7] = "" Then
				Switch $g_avBuildingUpgrades[$iz][3]
					Case "Gold"
						$iBuildingsNeedGold += Number($g_avBuildingUpgrades[$iz][2]) ; sum gold required for enabled upgrade
					Case "Elixir"
						$iBuildingsNeedElixir += Number($g_avBuildingUpgrades[$iz][2]) ; sum elixir required for enabled upgrade
					Case "Dark"
						$iBuildingsNeedDarkElixir += Number($g_avBuildingUpgrades[$iz][2]) ; sum dark elixir required for enabled upgrade
				EndSwitch
			EndIf
		Next
		SetDebugLog("Gold needed for upgrades : " & _NumberFormat($iBuildingsNeedGold, True), $COLOR_WARNING)
		SetDebugLog("Elixir needed for upgrades : " & _NumberFormat($iBuildingsNeedElixir, True), $COLOR_WARNING)
		SetDebugLog("Dark Elixir needed for upgrades : " & _NumberFormat($iBuildingsNeedDarkElixir, True), $COLOR_WARNING)
		If $iBuildingsNeedGold > 0 Or $iBuildingsNeedElixir > 0 Or $iBuildingsNeedDarkElixir > 0 Then ; if upgrade enabled and building upgrade resource is required, log user messages.
			Switch $b_ResType
				Case "Gold" ; Using gold
					If $iCurrentGold - ($iBuildingsNeedGold + $cost + Number($g_iacmdGoldSaveMin)) < 0 Then
						SetLog("Skip - insufficient gold for selected upgrades", $COLOR_WARNING)
						Return True
					EndIf
				Case "Elixir" ; Using elixir
					If $iCurrentElix - ($iBuildingsNeedElixir + $cost + Number($g_iacmdElixSaveMin)) < 0 Then
						SetLog("Skip - insufficient elixir for selected upgrades", $COLOR_WARNING)
						Return True
					EndIf
				Case "Dark Elixir" ; Using dark elixir
					If $iCurrentDE - ($iBuildingsNeedDarkElixir + $cost + Number($g_iacmdDarkSaveMin)) < 0 Then
						SetLog("Skip - insufficient dark elixir for selected upgrades", $COLOR_WARNING)
						Return True
					EndIf
			EndSwitch
		EndIf
		If _Sleep($DELAYRESPOND) Then Return True
	EndIf
	;;;;;;;;;;;;;;;;;;;;;;;;;;;End bldg upgrade value checking

	;   Is Warden Level updated |          Is Warden not max yet           |  Is Upgrade enabled       |               Is Warden not already upgrading
	If ($g_iWardenLevel <> -1) And ($g_iWardenLevel < $g_iMaxWardenLevel) And $g_bUpgradeWardenEnable And BitAND($g_iHeroUpgradingBit, $eHeroWarden) <> $eHeroWarden Then
		Local $WardenFinalCost = ($g_afWardenUpgCost[$g_iWardenLevel] * 1000000) - (($g_afWardenUpgCost[$g_iWardenLevel] * 1000000) * Number($g_iBuilderBoostDiscount) / 100)
		Local $bMinWardenElixir = Number($iCurrentElix) > ($cost + $WardenFinalCost + Number($g_iacmdElixSaveMin))
		If Not $bMinWardenElixir Then
			If $b_ResType = "Elixir" Then
				SetLog("Grand Warden needs " & _NumberFormat($WardenFinalCost, True) & " Elixir for next Level", $COLOR_WARNING)
				SetLog("Skipping", $COLOR_WARNING)
				Return True
			EndIf
		EndIf
	EndIf

	;   Is Queen Level updated |          Is Queen not max yet          |  Is Upgrade enabled      |               Is Queen not already upgrading
	If ($g_iQueenLevel <> -1) And ($g_iQueenLevel < $g_iMaxQueenLevel) And $g_bUpgradeQueenEnable And BitAND($g_iHeroUpgradingBit, $eHeroQueen) <> $eHeroQueen Then
		Local $QueenFinalCost = ($g_afQueenUpgCost[$g_iQueenLevel] * 1000) - (($g_afQueenUpgCost[$g_iQueenLevel] * 1000) * Number($g_iBuilderBoostDiscount) / 100)
		Local $bMinQueenDarkElixir = Number($iCurrentDE) > ($cost + $QueenFinalCost + Number($g_iacmdDarkSaveMin))
		If Not $bMinQueenDarkElixir Then
			If $b_ResType = "Dark Elixir" Then
				SetLog("Queen needs " & _NumberFormat($QueenFinalCost, True) & " Dark Elixir for next Level", $COLOR_WARNING)
				SetLog("Skipping", $COLOR_WARNING)
				Return True
			EndIf
		EndIf
	EndIf

	;   Is King Level updated |          Is King not max yet         |  Is Upgrade enabled     |               Is King not already upgrading
	If ($g_iKingLevel <> -1) And ($g_iKingLevel < $g_iMaxKingLevel) And $g_bUpgradeKingEnable And BitAND($g_iHeroUpgradingBit, $eHeroKing) <> $eHeroKing Then
		Local $KingFinalCost = ($g_afKingUpgCost[$g_iKingLevel] * 1000) - (($g_afKingUpgCost[$g_iKingLevel] * 1000) * Number($g_iBuilderBoostDiscount) / 100)
		Local $bMinKingDarkElixir = Number($iCurrentDE) > ($cost + $KingFinalCost + Number($g_iacmdDarkSaveMin))
		If Not $bMinKingDarkElixir Then
			If $b_ResType = "Dark Elixir" Then
				SetLog("King needs " & _NumberFormat($KingFinalCost, True) & " Dark Elixir for next Level", $COLOR_WARNING)
				SetLog("Skipping", $COLOR_WARNING)
				Return True
			EndIf
		EndIf
	EndIf

	;   Is Champion Level updated |            Is Champion not max yet           |    Is Upgrade enabled       |               Is Champion not already upgrading
	If ($g_iChampionLevel <> -1) And ($g_iChampionLevel < $g_iMaxChampionLevel) And $g_bUpgradeChampionEnable And BitAND($g_iHeroUpgradingBit, $eHeroChampion) <> $eHeroChampion Then
		Local $ChampionFinalCost = ($g_afChampionUpgCost[$g_iChampionLevel] * 1000) - (($g_afChampionUpgCost[$g_iChampionLevel] * 1000) * Number($g_iBuilderBoostDiscount) / 100)
		Local $bMinChampionDarkElixir = Number($iCurrentDE) > ($cost + $ChampionFinalCost + Number($g_iacmdDarkSaveMin))
		If Not $bMinChampionDarkElixir Then
			If $b_ResType = "Dark Elixir" Then
				SetLog("Champion needs " & _NumberFormat($ChampionFinalCost, True) & " Dark Elixir for next Level", $COLOR_WARNING)
				SetLog("Skipping", $COLOR_WARNING)
				Return True
			EndIf
		EndIf
	EndIf

	;;;;;;;;;;;;;;;;;;;;;;;;;;;##### Verify the Upgrade troop kind in Laboratory , if is elixir/Dark elixir Spell/Troop , the Lab have priority #####;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	Local $bMinCraftElixir = Number($iCurrentElix) > ($cost + Number($g_iLaboratoryElixirCost) + Number($g_iacmdElixSaveMin)) ; Check if enough Elixir
	If $g_bAutoLabUpgradeEnable And $g_iLaboratoryElixirCost > 0 And Not $bMinCraftElixir Then
		If $b_ResType = "Elixir" Then
			SetLog("Laboratory needs Elixir to Upgrade :  " & _NumberFormat($g_iLaboratoryElixirCost, True), $COLOR_SUCCESS1)
			SetLog("Skipping", $COLOR_SUCCESS1)
			Return True
		EndIf
	EndIf

	Local $bMinCraftDarkElixir = Number($iCurrentDE) > ($cost + Number($g_iLaboratoryDElixirCost) + Number($g_iacmdDarkSaveMin)) ; Check if enough Dark Elixir
	If $g_bAutoLabUpgradeEnable And $g_iLaboratoryDElixirCost > 0 And Not $bMinCraftDarkElixir Then
		If $b_ResType = "Dark Elixir" Then
			SetLog("Laboratory needs Dark Elixir to Upgrade :  " & _NumberFormat($g_iLaboratoryDElixirCost, True), $COLOR_SUCCESS1)
			SetLog("Skipping", $COLOR_SUCCESS1)
			Return True
		EndIf
	EndIf

	Return False

EndFunc   ;==>SkipCraftStart
