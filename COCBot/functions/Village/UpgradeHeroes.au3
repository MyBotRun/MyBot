; #FUNCTION# ====================================================================================================================
; Name ..........: Upgrade Heroes Continuously
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: z0mbie (2015)
; Modified ......: Master1st (09/2015), ProMac (10/2015), MonkeyHunter (06/2016), Moebius14 (12/2024)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Local $bInitalXcoord = 67
Local $bDistanceSlot = 153
Local $bXcoords[5] = [$bInitalXcoord, $bInitalXcoord + $bDistanceSlot, $bInitalXcoord + $bDistanceSlot * 2, $bInitalXcoord + $bDistanceSlot * 3, $bInitalXcoord + $bDistanceSlot * 4]

Func FinishTimeCalculation($bHero = "")
	Switch $bHero
		Case "King"
			Click($bXcoords[0] + 115, 232 + $g_iMidOffsetY)
			If _Sleep($DELAYUPGRADEHERO3) Then Return ; Wait for window to open
			Local $g_aUpgradeDuration = getHeroUpgradeTime(715, 544 + $g_iMidOffsetY) ; get duration
			Local $HeroUpgradeTime = ConvertOCRTime("TimeToFinish", $g_aUpgradeDuration, False)
			If $HeroUpgradeTime = 0 Then
				$g_aUpgradeDuration = getHeroUpgradeTime2(715, 544 + $g_iMidOffsetY) ; Try to read with 2nd lib.
				$HeroUpgradeTime = ConvertOCRTime("TimeToFinish", $g_aUpgradeDuration, False)
			EndIf
			SetDebugLog("Upgrade Time OCR : " & $g_aUpgradeDuration)
			$g_aiHeroUpgradeFinishDate[0] = _DateAdd('n', Ceiling($HeroUpgradeTime), _NowCalc())
			SetLog($bHero & " Upgrade Finishes @ " & $g_aiHeroUpgradeFinishDate[0], $COLOR_SUCCESS)
			If _Sleep(200) Then Return
			CloseWindow2()
			If _Sleep($DELAYUPGRADEHERO3) Then Return
		Case "Queen"
			Click($bXcoords[1] + 115, 232 + $g_iMidOffsetY)
			If _Sleep($DELAYUPGRADEHERO3) Then Return ; Wait for window to open
			Local $g_aUpgradeDuration = getHeroUpgradeTime(715, 544 + $g_iMidOffsetY) ; get duration
			Local $HeroUpgradeTime = ConvertOCRTime("TimeToFinish", $g_aUpgradeDuration, False)
			If $HeroUpgradeTime = 0 Then
				$g_aUpgradeDuration = getHeroUpgradeTime2(715, 544 + $g_iMidOffsetY) ; Try to read with 2nd lib.
				$HeroUpgradeTime = ConvertOCRTime("TimeToFinish", $g_aUpgradeDuration, False)
			EndIf
			SetDebugLog("Upgrade Time OCR : " & $g_aUpgradeDuration)
			$g_aiHeroUpgradeFinishDate[1] = _DateAdd('n', Ceiling($HeroUpgradeTime), _NowCalc())
			SetLog($bHero & " Upgrade Finishes @ " & $g_aiHeroUpgradeFinishDate[1], $COLOR_SUCCESS)
			If _Sleep(200) Then Return
			CloseWindow2()
			If _Sleep($DELAYUPGRADEHERO3) Then Return
		Case "Prince"
			Click($bXcoords[2] + 115, 232 + $g_iMidOffsetY)
			If _Sleep($DELAYUPGRADEHERO3) Then Return ; Wait for window to open
			Local $g_aUpgradeDuration = getHeroUpgradeTime(715, 544 + $g_iMidOffsetY) ; get duration
			Local $HeroUpgradeTime = ConvertOCRTime("TimeToFinish", $g_aUpgradeDuration, False)
			If $HeroUpgradeTime = 0 Then
				$g_aUpgradeDuration = getHeroUpgradeTime2(715, 544 + $g_iMidOffsetY) ; Try to read with 2nd lib.
				$HeroUpgradeTime = ConvertOCRTime("TimeToFinish", $g_aUpgradeDuration, False)
			EndIf
			SetDebugLog("Upgrade Time OCR : " & $g_aUpgradeDuration)
			$g_aiHeroUpgradeFinishDate[2] = _DateAdd('n', Ceiling($HeroUpgradeTime), _NowCalc())
			SetLog($bHero & " Upgrade Finishes @ " & $g_aiHeroUpgradeFinishDate[2], $COLOR_SUCCESS)
			If _Sleep(200) Then Return
			CloseWindow2()
			If _Sleep($DELAYUPGRADEHERO3) Then Return
		Case "Warden"
			Click($bXcoords[3] + 115, 232 + $g_iMidOffsetY)
			If _Sleep($DELAYUPGRADEHERO3) Then Return ; Wait for window to open
			Local $g_aUpgradeDuration = getHeroUpgradeTime(715, 544 + $g_iMidOffsetY) ; get duration
			Local $HeroUpgradeTime = ConvertOCRTime("TimeToFinish", $g_aUpgradeDuration, False)
			If $HeroUpgradeTime = 0 Then
				$g_aUpgradeDuration = getHeroUpgradeTime2(715, 544 + $g_iMidOffsetY) ; Try to read with 2nd lib.
				$HeroUpgradeTime = ConvertOCRTime("TimeToFinish", $g_aUpgradeDuration, False)
			EndIf
			SetDebugLog("Upgrade Time OCR : " & $g_aUpgradeDuration)
			$g_aiHeroUpgradeFinishDate[3] = _DateAdd('n', Ceiling($HeroUpgradeTime), _NowCalc())
			SetLog($bHero & " Upgrade Finishes @ " & $g_aiHeroUpgradeFinishDate[3], $COLOR_SUCCESS)
			If _Sleep(200) Then Return
			CloseWindow2()
			If _Sleep($DELAYUPGRADEHERO3) Then Return
		Case "Champion"
			Click($bXcoords[4] + 115, 232 + $g_iMidOffsetY)
			If _Sleep($DELAYUPGRADEHERO3) Then Return ; Wait for window to open
			Local $g_aUpgradeDuration = getHeroUpgradeTime(715, 544 + $g_iMidOffsetY) ; get duration
			Local $HeroUpgradeTime = ConvertOCRTime("TimeToFinish", $g_aUpgradeDuration, False)
			If $HeroUpgradeTime = 0 Then
				$g_aUpgradeDuration = getHeroUpgradeTime2(715, 544 + $g_iMidOffsetY) ; Try to read with 2nd lib.
				$HeroUpgradeTime = ConvertOCRTime("TimeToFinish", $g_aUpgradeDuration, False)
			EndIf
			SetDebugLog("Upgrade Time OCR : " & $g_aUpgradeDuration)
			$g_aiHeroUpgradeFinishDate[4] = _DateAdd('n', Ceiling($HeroUpgradeTime), _NowCalc())
			SetLog($bHero & " Upgrade Finishes @ " & $g_aiHeroUpgradeFinishDate[4], $COLOR_SUCCESS)
			If _Sleep(200) Then Return
			CloseWindow2()
			If _Sleep($DELAYUPGRADEHERO3) Then Return
	EndSwitch
EndFunc   ;==>FinishTimeCalculation

Func NeededResources($bHero = "")
	Switch $bHero
		Case "King"
			Click($bXcoords[0] + 115, 232 + $g_iMidOffsetY)
			If _Sleep($DELAYUPGRADEHERO3) Then Return ; Wait for window to open
			$g_iKingLevel = getYellowLevel(452, 116)
			$g_aiHeroNeededResource[0] = Number(getCostsUpgradeRed(552, 541 + $g_iMidOffsetY)) ;read Red upgrade text
			If $g_aiHeroNeededResource[0] = "" Then $g_aiHeroNeededResource[0] = Number(getCostsUpgradeRed(552, 532 + $g_iMidOffsetY)) ;read Red upgrade text (Discount).
			SetLog($bHero & " Upgrade Requires " & _NumberFormat($g_aiHeroNeededResource[0]) & " Dark Elixir", $COLOR_SUCCESS)
			If _Sleep(200) Then Return
			CloseWindow2()
		Case "Queen"
			Click($bXcoords[1] + 115, 232 + $g_iMidOffsetY)
			If _Sleep($DELAYUPGRADEHERO3) Then Return ; Wait for window to open
			$g_iQueenLevel = getYellowLevel(445, 116)
			$g_aiHeroNeededResource[1] = Number(getCostsUpgradeRed(552, 541 + $g_iMidOffsetY)) ;read Red upgrade text
			If $g_aiHeroNeededResource[1] = "" Then $g_aiHeroNeededResource[1] = Number(getCostsUpgradeRed(552, 532 + $g_iMidOffsetY)) ;read Red upgrade text (Discount).
			SetLog($bHero & " Upgrade Requires " & _NumberFormat($g_aiHeroNeededResource[1]) & " Dark Elixir", $COLOR_SUCCESS)
			If _Sleep(200) Then Return
			CloseWindow2()
		Case "Prince"
			Click($bXcoords[2] + 115, 232 + $g_iMidOffsetY)
			If _Sleep($DELAYUPGRADEHERO3) Then Return ; Wait for window to open
			$g_iPrinceLevel = getYellowLevel(535, 116)
			$g_aiHeroNeededResource[2] = Number(getCostsUpgradeRed(552, 541 + $g_iMidOffsetY)) ;read Red upgrade text
			If $g_aiHeroNeededResource[2] = "" Then $g_aiHeroNeededResource[2] = Number(getCostsUpgradeRed(552, 532 + $g_iMidOffsetY)) ;read Red upgrade text (Discount).
			SetLog($bHero & " Upgrade Requires " & _NumberFormat($g_aiHeroNeededResource[2]) & " Dark Elixir", $COLOR_SUCCESS)
			If _Sleep(200) Then Return
			CloseWindow2()
		Case "Warden"
			Click($bXcoords[3] + 115, 232 + $g_iMidOffsetY)
			If _Sleep($DELAYUPGRADEHERO3) Then Return ; Wait for window to open
			$g_iWardenLevel = getYellowLevel(452, 116)
			$g_aiHeroNeededResource[3] = Number(getCostsUpgradeRed(552, 541 + $g_iMidOffsetY)) ;read Red upgrade text
			If $g_aiHeroNeededResource[3] = "" Then $g_aiHeroNeededResource[3] = Number(getCostsUpgradeRed(552, 532 + $g_iMidOffsetY)) ;read Red upgrade text (Discount).
			SetLog($bHero & " Upgrade Requires " & _NumberFormat($g_aiHeroNeededResource[3]) & " Elixir", $COLOR_SUCCESS)
			If _Sleep(200) Then Return
			CloseWindow2()
		Case "Champion"
			Click($bXcoords[4] + 115, 232 + $g_iMidOffsetY)
			If _Sleep($DELAYUPGRADEHERO3) Then Return ; Wait for window to open
			$g_iChampionLevel = getYellowLevel(452, 116)
			$g_aiHeroNeededResource[4] = Number(getCostsUpgradeRed(552, 541 + $g_iMidOffsetY)) ;read Red upgrade text
			If $g_aiHeroNeededResource[4] = "" Then $g_aiHeroNeededResource[4] = Number(getCostsUpgradeRed(552, 532 + $g_iMidOffsetY)) ;read Red upgrade text (Discount).
			SetLog($bHero & " Upgrade Requires " & _NumberFormat($g_aiHeroNeededResource[4]) & " Dark Elixir", $COLOR_SUCCESS)
			If _Sleep(200) Then Return
			CloseWindow2()
	EndSwitch
EndFunc   ;==>NeededResources

Func UpgradeHeroes()

	If Not $g_bUpgradeKingEnable And Not $g_bUpgradeQueenEnable And Not $g_bUpgradePrinceEnable And Not $g_bUpgradeWardenEnable And Not $g_bUpgradeChampionEnable Then Return
	If _Sleep(500) Then Return

	If $g_iTownHallLevel < 7 Then
		SetLog("Townhall Lvl " & $g_iTownHallLevel & " has no Hero Hall, so skip locating.", $COLOR_DEBUG)
		Return
	EndIf

	If Not $g_bRunState Then Return
	checkMainScreen(False)

	If $g_bRestart Then Return

	$g_aiCurrentLoot[$eLootElixir] = getResourcesMainScreen(696, 74)
	$g_aiCurrentLoot[$eLootDarkElixir] = getResourcesMainScreen(728, 123)

	If Not getBuilderCount() Then Return ; update builder data, return if problem
	If _Sleep($DELAYRESPOND) Then Return

	If $g_iFreeBuilderCount < 1 + ($g_bAutoUpgradeWallsEnable And $g_bUpgradeWallSaveBuilder ? 1 : 0) Then
		If Not $bCheckValuesForWarden Then
			SetLog("Not enough Builders available to upgrade Heroes")
			Return
		EndIf
	EndIf

	Local $IsToOpen = 0
	If Not $bCheckValuesForWarden Then
		If $g_bUpgradeKingEnable Then
			If _DateIsValid($g_aiHeroUpgradeFinishDate[0]) Then
				If _DateDiff('n', _NowCalc(), $g_aiHeroUpgradeFinishDate[0]) < 0 Then
					$IsToOpen += 1
				Else
					If BitAND($g_iHeroUpgradingBit, $eHeroKing) <> $eHeroKing Then
						$IsToOpen += 1
					Else
						SetLog("King Upgrade Finishes @ " & $g_aiHeroUpgradeFinishDate[0] & ", Skip", $COLOR_INFO)
					EndIf
				EndIf
			Else
				If $g_aiHeroNeededResource[0] = 0 Then
					$IsToOpen += 1
				Else
					If Number($g_aiHeroNeededResource[0]) <= Number($g_aiCurrentLoot[$eLootDarkElixir]) Then
						$IsToOpen += 1
					Else
						SetLog("King Upgrade Requires " & _NumberFormat($g_aiHeroNeededResource[0]) & " Dark Elixir, Skip", $COLOR_INFO)
					EndIf
				EndIf
			EndIf
		EndIf
		If $g_bUpgradeQueenEnable Then
			If _DateIsValid($g_aiHeroUpgradeFinishDate[1]) Then
				If _DateDiff('n', _NowCalc(), $g_aiHeroUpgradeFinishDate[1]) < 0 Then
					$IsToOpen += 1
				Else
					If BitAND($g_iHeroUpgradingBit, $eHeroQueen) <> $eHeroQueen Then
						$IsToOpen += 1
					Else
						SetLog("Queen Upgrade Finishes @ " & $g_aiHeroUpgradeFinishDate[1] & ", Skip", $COLOR_INFO)
					EndIf
				EndIf
			Else
				If $g_aiHeroNeededResource[1] = 0 Then
					$IsToOpen += 1
				Else
					If Number($g_aiHeroNeededResource[1]) <= Number($g_aiCurrentLoot[$eLootDarkElixir]) Then
						$IsToOpen += 1
					Else
						SetLog("Queen Upgrade Requires " & _NumberFormat($g_aiHeroNeededResource[1]) & " Dark Elixir, Skip", $COLOR_INFO)
					EndIf
				EndIf
			EndIf
		EndIf
		If $g_bUpgradePrinceEnable Then
			If _DateIsValid($g_aiHeroUpgradeFinishDate[2]) Then
				If _DateDiff('n', _NowCalc(), $g_aiHeroUpgradeFinishDate[2]) < 0 Then
					$IsToOpen += 1
				Else
					If BitAND($g_iHeroUpgradingBit, $eHeroPrince) <> $eHeroPrince Then
						$IsToOpen += 1
					Else
						SetLog("Prince Upgrade Finishes @ " & $g_aiHeroUpgradeFinishDate[2] & ", Skip", $COLOR_INFO)
					EndIf
				EndIf
			Else
				If $g_aiHeroNeededResource[2] = 0 Then
					$IsToOpen += 1
				Else
					If Number($g_aiHeroNeededResource[2]) <= Number($g_aiCurrentLoot[$eLootDarkElixir]) Then
						$IsToOpen += 1
					Else
						SetLog("Prince Upgrade Requires " & _NumberFormat($g_aiHeroNeededResource[2]) & " Dark Elixir, Skip", $COLOR_INFO)
					EndIf
				EndIf
			EndIf
		EndIf
		If $g_bUpgradeWardenEnable Then
			If _DateIsValid($g_aiHeroUpgradeFinishDate[3]) Then
				If _DateDiff('n', _NowCalc(), $g_aiHeroUpgradeFinishDate[3]) < 0 Then
					$IsToOpen += 1
				Else
					If BitAND($g_iHeroUpgradingBit, $eHeroWarden) <> $eHeroWarden Then
						$IsToOpen += 1
					Else
						SetLog("Warden Upgrade Finishes @ " & $g_aiHeroUpgradeFinishDate[3] & ", Skip", $COLOR_INFO)
					EndIf
				EndIf
			Else
				If $g_aiHeroNeededResource[3] = 0 Then
					$IsToOpen += 1
				Else
					If Number($g_aiHeroNeededResource[3]) <= Number($g_aiCurrentLoot[$eLootElixir]) Then
						$IsToOpen += 1
					Else
						SetLog("Warden Upgrade Requires " & _NumberFormat($g_aiHeroNeededResource[3]) & " Elixir, Skip", $COLOR_INFO)
					EndIf
				EndIf
			EndIf
		EndIf
		If $g_bUpgradeChampionEnable Then
			If _DateIsValid($g_aiHeroUpgradeFinishDate[4]) Then
				If _DateDiff('n', _NowCalc(), $g_aiHeroUpgradeFinishDate[4]) < 0 Then
					$IsToOpen += 1
				Else
					If BitAND($g_iHeroUpgradingBit, $eHeroChampion) <> $eHeroChampion Then
						$IsToOpen += 1
					Else
						SetLog("Champion Upgrade Finishes @ " & $g_aiHeroUpgradeFinishDate[4] & ", Skip", $COLOR_INFO)
					EndIf
				EndIf
			Else
				If $g_aiHeroNeededResource[4] = 0 Then
					$IsToOpen += 1
				Else
					If Number($g_aiHeroNeededResource[4]) <= Number($g_aiCurrentLoot[$eLootDarkElixir]) Then
						$IsToOpen += 1
					Else
						SetLog("Champion Upgrade Requires " & _NumberFormat($g_aiHeroNeededResource[4]) & " Dark Elixir, Skip", $COLOR_INFO)
					EndIf
				EndIf
			EndIf
		EndIf
	Else
		$IsToOpen = 1
	EndIf
	If $IsToOpen = 0 Then Return

	If BitOR($g_bUpgradeKingEnable, $g_bUpgradeQueenEnable, $g_bUpgradePrinceEnable, $g_bUpgradeWardenEnable, $g_bUpgradeChampionEnable) Then
		If Not isInsideDiamondXY($g_aiHeroHallPos[0], $g_aiHeroHallPos[1]) Then ImgLocateHeroHall()
		If $g_aiHeroHallPos[0] = -1 Or $g_aiHeroHallPos[1] = -1 Or $g_aiHeroHallPos[2] = -1 Then ImgLocateHeroHall()
		SaveConfig()
	EndIf

	If Not $bCheckValuesForWarden Then
		SetLog("Upgrading Heroes", $COLOR_INFO)
	Else
		SetLog("Checking Warden Values", $COLOR_INFO)
	EndIf

	If Not $g_bRunState Then Return

	BuildingClick($g_aiHeroHallPos[0], $g_aiHeroHallPos[1])
	If _Sleep($DELAYBUILDINGINFO1) Then Return
	Local $sHeroHallInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY)
	If StringInStr($sHeroHallInfo[1], "Hero") Then
		If $g_aiHeroHallPos[2] <> $sHeroHallInfo[2] Then
			$g_aiHeroHallPos[2] = $sHeroHallInfo[2]
		EndIf
		Local $HeroHallButton = FindButton("HeroHallButton")
		If IsArray($HeroHallButton) And UBound($HeroHallButton) = 2 Then
			ClickP($HeroHallButton)
			If _Sleep(Random(1500, 2000, 1)) Then Return
		Else
			SetLog("Hero Hall Button not found", $COLOR_ERROR)
			ClearScreen()
			Return
		EndIf
	EndIf

	If Not QuickMIS("BC1", $g_sImgGeneralCloseButton, 780, 145 + $g_iMidOffsetY, 815, 175 + $g_iMidOffsetY) Then
		SetLog("Hero Hall Window Didn't Open", $COLOR_DEBUG1)
		CloseWindow2()
		If _Sleep(1000) Then Return
		ClearScreen()
		Return
	EndIf

	If Not $g_bRunState Then Return

	;Check Hidden Hero Upgrade To be sure
	Switch $g_aiCmbCustomHeroOrder[4]
		Case 0
			If IsArray(_PixelSearch($bXcoords[0] - 6, 438 + $g_iMidOffsetY, $bXcoords[0] + 4, 444 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
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
					If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroKing) = $eHeroKing) Or _
							($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroKing) = $eHeroKing) Then                     ; check wait for hero status
						If $g_iSearchNotWaitHeroesEnable Then
							$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroKing)
						Else
							SetLog("Warning: King Upgrading & Wait enabled, Disable Wait for King or may never attack!", $COLOR_ERROR)
						EndIf
						_GUI_Value_STATE("SHOW", $groupKingSleeping)                     ; Show king sleeping icon
					EndIf
				EndIf
			EndIf
		Case 1
			If IsArray(_PixelSearch($bXcoords[1] - 6, 438 + $g_iMidOffsetY, $bXcoords[1] + 4, 444 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
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
					If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroQueen) = $eHeroQueen) Or _
							($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroQueen) = $eHeroQueen) Then                     ; check wait for hero status
						If $g_iSearchNotWaitHeroesEnable Then
							$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroQueen)
						Else
							SetLog("Warning: Queen Upgrading & Wait enabled, Disable Wait for Queen or may never attack!", $COLOR_ERROR)
						EndIf
						_GUI_Value_STATE("SHOW", $groupQueenSleeping)                     ; Show Queen sleeping icon
					EndIf
				EndIf
			EndIf
		Case 2
			If IsArray(_PixelSearch($bXcoords[2] - 6, 438 + $g_iMidOffsetY, $bXcoords[2] + 4, 444 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
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
					If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroPrince) = $eHeroPrince) Or _
							($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroPrince) = $eHeroPrince) Then                     ; check wait for hero status
						If $g_iSearchNotWaitHeroesEnable Then
							$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroPrince)
						Else
							SetLog("Warning: Prince Upgrading & Wait enabled, Disable Wait for Prince or may never attack!", $COLOR_ERROR)
						EndIf
						_GUI_Value_STATE("SHOW", $groupPrinceSleeping)                     ; Show king sleeping icon
					EndIf
				EndIf
			EndIf
		Case 3
			If IsArray(_PixelSearch($bXcoords[3] - 6, 438 + $g_iMidOffsetY, $bXcoords[3] + 4, 444 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
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
					If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroWarden) = $eHeroWarden) Or _
							($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroWarden) = $eHeroWarden) Then                     ; check wait for hero status
						If $g_iSearchNotWaitHeroesEnable Then
							$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroWarden)
						Else
							SetLog("Warning: Warden Upgrading & Wait enabled, Disable Wait for Warden or may never attack!", $COLOR_ERROR)
						EndIf
						_GUI_Value_STATE("SHOW", $groupWardenSleeping)                     ; Show king sleeping icon
					EndIf
				EndIf
			EndIf
		Case 4
			If IsArray(_PixelSearch($bXcoords[4] - 6, 438 + $g_iMidOffsetY, $bXcoords[4] + 4, 444 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
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
					If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroChampion) = $eHeroChampion) Or _
							($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroChampion) = $eHeroChampion) Then                     ; check wait for hero status
						If $g_iSearchNotWaitHeroesEnable Then
							$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroChampion)
						Else
							SetLog("Warning: Champion Upgrading & Wait enabled, Disable Wait for Champion or may never attack!", $COLOR_ERROR)
						EndIf
						_GUI_Value_STATE("SHOW", $groupChampionSleeping)                     ; Show king sleeping icon
					EndIf
				EndIf
			EndIf
	EndSwitch

	If $bCheckValuesForWarden Then
		WardenUpgrade()
		CloseWindow()
		$bCheckValuesForWarden = False
		Return
	EndIf

	;Check if Auto Lab Upgrade is enabled and if a Dark Troop/Spell is selected for Upgrade. If yes, it has priority!
	If BitOR($g_bUpgradeKingEnable, $g_bUpgradeQueenEnable, $g_bUpgradePrinceEnable, $g_bUpgradeChampionEnable) Then
		If $g_bAutoLabUpgradeEnable And $g_iLaboratoryDElixirCost > 0 Then
			SetLog("Laboratory needs DE to Upgrade:  " & $g_iLaboratoryDElixirCost)
			SetLog("Skipping the Queen, King, Champion and Prince Upgrade!")
		Else
			; ### Barbarian King ###
			If $g_bUpgradeKingEnable And BitAND($g_iHeroUpgradingBit, $eHeroKing) <> $eHeroKing Then
				If $g_iFreeBuilderCount < 1 + ($g_bAutoUpgradeWallsEnable And $g_bUpgradeWallSaveBuilder ? 1 : 0) Then
					SetLog("Not enough Builders available to upgrade the Barbarian King")
					Return
				EndIf
				KingUpgrade()

				If _Sleep($DELAYUPGRADEHERO1) Then Return
			ElseIf $g_bUpgradeKingEnable And BitAND($g_iHeroUpgradingBit, $eHeroKing) = $eHeroKing Then
				If Not _DateIsValid($g_aiHeroUpgradeFinishDate[0]) Then FinishTimeCalculation("King")
			EndIf
			If Not $g_bRunState Then Return
			; ### Archer Queen ###
			If $g_bUpgradeQueenEnable And BitAND($g_iHeroUpgradingBit, $eHeroQueen) <> $eHeroQueen Then
				If $g_iFreeBuilderCount < 1 + ($g_bAutoUpgradeWallsEnable And $g_bUpgradeWallSaveBuilder ? 1 : 0) Then
					SetLog("Not enough Builders available to upgrade the Archer Queen")
					Return
				EndIf
				QueenUpgrade()

				If _Sleep($DELAYUPGRADEHERO1) Then Return
			ElseIf $g_bUpgradeQueenEnable And BitAND($g_iHeroUpgradingBit, $eHeroQueen) = $eHeroQueen Then
				If Not _DateIsValid($g_aiHeroUpgradeFinishDate[1]) Then FinishTimeCalculation("Queen")
			EndIf
			If Not $g_bRunState Then Return
			; ### Minion Prince ###
			If $g_bUpgradePrinceEnable And BitAND($g_iHeroUpgradingBit, $eHeroPrince) <> $eHeroPrince Then
				If $g_iFreeBuilderCount < 1 + ($g_bAutoUpgradeWallsEnable And $g_bUpgradeWallSaveBuilder ? 1 : 0) Then
					SetLog("Not enough Builders available to upgrade the Archer Queen")
					Return
				EndIf
				PrinceUpgrade()

				If _Sleep($DELAYUPGRADEHERO1) Then Return
			ElseIf $g_bUpgradePrinceEnable And BitAND($g_iHeroUpgradingBit, $eHeroPrince) = $eHeroPrince Then
				If Not _DateIsValid($g_aiHeroUpgradeFinishDate[2]) Then FinishTimeCalculation("Prince")
			EndIf
			If Not $g_bRunState Then Return
			; ### Royal Champion ###
			If $g_bUpgradeChampionEnable And BitAND($g_iHeroUpgradingBit, $eHeroChampion) <> $eHeroChampion Then
				If $g_iFreeBuilderCount < 1 + ($g_bAutoUpgradeWallsEnable And $g_bUpgradeWallSaveBuilder ? 1 : 0) Then
					SetLog("Not enough Builders available to upgrade the Royal Champion")
					Return
				EndIf
				ChampionUpgrade()

				If _Sleep($DELAYUPGRADEHERO1) Then Return
			ElseIf $g_bUpgradeChampionEnable And BitAND($g_iHeroUpgradingBit, $eHeroChampion) = $eHeroChampion Then
				If Not _DateIsValid($g_aiHeroUpgradeFinishDate[4]) Then FinishTimeCalculation("Champion")
			EndIf
			If Not $g_bRunState Then Return
		EndIf
	EndIf

	; ### Grand Warden ###
	;Check if Auto Lab Upgrade is enabled and if a Elixir Troop/Spell is selected for Upgrade. If yes, it has priority!
	If $g_bUpgradeWardenEnable Then
		If $g_bAutoLabUpgradeEnable And $g_iLaboratoryElixirCost > 0 Then
			SetLog("Laboratory needs Elixir to Upgrade:  " & $g_iLaboratoryElixirCost)
			SetLog("Skipping the Warden Upgrade!")
		ElseIf BitAND($g_iHeroUpgradingBit, $eHeroWarden) <> $eHeroWarden Then
			If $g_iFreeBuilderCount < 1 + ($g_bAutoUpgradeWallsEnable And $g_bUpgradeWallSaveBuilder ? 1 : 0) Then
				SetLog("Not enough Builders available to upgrade the Grand Warden")
				Return
			EndIf
			WardenUpgrade()
		ElseIf BitAND($g_iHeroUpgradingBit, $eHeroWarden) = $eHeroWarden Then
			If Not _DateIsValid($g_aiHeroUpgradeFinishDate[3]) Then FinishTimeCalculation("Warden")
		EndIf
	EndIf

	If Not $g_bRunState Then Return
	CloseWindow()

EndFunc   ;==>UpgradeHeroes

Func KingUpgrade()

	If Not $g_bUpgradeKingEnable Then Return

	SetLog("Upgrade King")

	If Not $g_bRunState Then Return

	If $g_iTownHallLevel < 7 Then
		SetLog("TH upgrade needed - Skipped!", $COLOR_ERROR)
		$g_bUpgradeKingEnable = False ; Turn Off the King's Upgrade
		GUICtrlSetState($g_hChkUpgradeKing, $GUI_UNCHECKED)
		chkUpgradeKing()
		ReducecmbHeroReservedBuilder()
		Return
	EndIf

	If IsArray(_PixelSearch($bXcoords[0] - 6, 438 + $g_iMidOffsetY, $bXcoords[0] + 4, 444 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
		SetLog("King Upgrade is already Running - Skipped!", $COLOR_INFO)
		Return
	EndIf
	Local $bOffset = False
	If _ColorCheck(_GetPixelColor($bXcoords[0], 438 + $g_iMidOffsetY, True), Hex(0x8BD43A, 6), 20) And _
			IsArray(_PixelSearch($bXcoords[0], 438 + $g_iMidOffsetY, $bXcoords[0] + 95, 444 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
		SetDebugLog("Green Pixel Check: OK")
	ElseIf _ColorCheck(_GetPixelColor($bXcoords[0] + 42, 438 + $g_iMidOffsetY, True), Hex(0x8BD43A, 6), 20) And _
			IsArray(_PixelSearch($bXcoords[0] + 42, 438 + $g_iMidOffsetY, $bXcoords[0] + 95, 444 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
		SetDebugLog("Green Pixel Check: OK")
		$bOffset = True
	Else
		If IsArray(_PixelSearch($bXcoords[0], 438 + $g_iMidOffsetY, $bXcoords[0] + 95, 444 + $g_iMidOffsetY, Hex(0xFF887F, 6), 20, True)) Then
			SetLog("Insufficient DE for Upg King", $COLOR_INFO)
			If $g_aiHeroNeededResource[0] = 0 Then NeededResources("King")
			Return
		EndIf
		Local $HeroMaxLevel = decodeSingleCoord(FindImageInPlace2("HeroMaxLevel", $ImgHeroMaxLevel, $bXcoords[0] + 20, 420 + $g_iMidOffsetY, $bXcoords[0] + 100, 445 + $g_iMidOffsetY, True))
		If IsArray($HeroMaxLevel) And UBound($HeroMaxLevel) = 2 Then
			SetLog("Your Barbarian King is at max level, cannot upgrade anymore!", $COLOR_INFO)
			$g_bUpgradeKingEnable = False ; turn Off the Kings upgrade
			GUICtrlSetState($g_hChkUpgradeKing, $GUI_UNCHECKED)
			chkUpgradeKing()
			ReducecmbHeroReservedBuilder()
			Return
		EndIf
		If _ColorCheck(_GetPixelColor($bXcoords[0], 438 + $g_iMidOffsetY, True), Hex(0xADADAD, 6), 15) Or _ColorCheck(_GetPixelColor($bXcoords[0] + 42, 438 + $g_iMidOffsetY, True), Hex(0xADADAD, 6), 15) Then
			SetLog("Hero Hall upgrade needed - Skipped!", $COLOR_ERROR)
			Return
		EndIf
		If _ColorCheck(_GetPixelColor($bXcoords[0], 438 + $g_iMidOffsetY, True), Hex(0x6D6D6D, 6), 15) Then
			SetLog("Hero Hall upgrade needed - Skipped!", $COLOR_ERROR)
			Return
		EndIf
	EndIf

	If $bOffset Then
		Local $g_iKingCostOCR = getOcrAndCapture("coc-HeroCost", $bXcoords[0] + 38, 433 + $g_iMidOffsetY, 65, 20, True)
	Else
		Local $g_iKingCostOCR = getOcrAndCapture("coc-HeroCost", $bXcoords[0] + 23, 433 + $g_iMidOffsetY, 65, 20, True)
	EndIf
	If $g_iKingCostOCR = "" Then
		SetLog("King Cost OCR Read Error", $COLOR_ERROR)
		Return
	EndIf

	If _Sleep($DELAYUPGRADEHERO1) Then Return

	Click($bXcoords[0] + 55, 433 + $g_iMidOffsetY) ; Click Upgrade Button
	If _Sleep($DELAYUPGRADEHERO3) Then Return ; Wait for window to open
	If Not $g_bRunState Then Return

	If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn1")
	If _ColorCheck(_GetPixelColor(800, 88 + $g_iMidOffsetY, True), Hex(0xF38E8D, 6), 20) Then ; Check if the Hero Upgrade window is open
		Local $g_iKingLevelOCR = getYellowLevel(527, 116)
		$g_iKingLevel = Number($g_iKingLevelOCR - 1)
		If $g_iKingLevel = -1 Then
			SetLog("Unable To Read King Level, Skip Upgrade!", $COLOR_ERROR)
			CloseWindow2(1)
			Return
		Else
			SetLog("Your Babarian King Level read as: " & $g_iKingLevel, $COLOR_SUCCESS)
		EndIf
	EndIf

	Local $RedSearch = _PixelSearch(610, 535 + $g_iMidOffsetY, 650, 557 + $g_iMidOffsetY, Hex(0xFF887F, 6), 20)
	If IsArray($RedSearch) Then
		If $g_aiCurrentLoot[$eLootDarkElixir] < ($g_afKingUpgCost[$g_iKingLevel] * 1000) * (1 - Number($g_iBuilderBoostDiscount) / 100) + $g_iUpgradeMinDark Then
			SetLog("Insufficient DE for Upg King, requires: " & ($g_afKingUpgCost[$g_iKingLevel] * 1000) * (1 - Number($g_iBuilderBoostDiscount) / 100) & " + " & $g_iUpgradeMinDark, $COLOR_INFO)
			CloseWindow2(1)
			Return
		EndIf
	EndIf

	Local $g_aUpgradeDuration = getHeroUpgradeTime(715, 544 + $g_iMidOffsetY) ; get duration
	If $g_aUpgradeDuration = "" Then $g_aUpgradeDuration = getHeroUpgradeTime(730, 532 + $g_iMidOffsetY) ; Try to read yellow text (Discount).

	Local $aWhiteZeros = decodeSingleCoord(FindImageInPlace2("UpgradeWhiteZero", $g_sImgUpgradeWhiteZero, 560, 535 + $g_iMidOffsetY, 670, 565 + $g_iMidOffsetY, True))
	Local $YellowSearch = _PixelSearch(610, 539 + $g_iMidOffsetY, 650, 543 + $g_iMidOffsetY, Hex(0xFFF10D, 6), 20)
	Local $ahGroupKingWait[4] = [$g_hChkDBKingWait, $g_hChkABKingWait, $g_hPicDBKingWait, $g_hPicABKingWait]
	Local $TxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtKingWait_Info_01", -1) & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtKingWait_Info_02", -1)
	Local $TxtWarningTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtKingWait_Info_03", "ATTENTION: King auto upgrade is currently enable.")
	If (IsArray($aWhiteZeros) And UBound($aWhiteZeros, 1) = 2) Then

		Local $bUpgradeCost = ($g_afKingUpgCost[$g_iKingLevel] * 1000 * (1 - Number($g_iBuilderBoostDiscount) / 100))
		SetLog("Upgrade cost " & _NumberFormat($bUpgradeCost) & " Dark Elixir", $COLOR_INFO)
		If _Sleep(1000) Then Return

		ClickP($aWhiteZeros, 1, 120)         ; Click upgrade buttton

		If _Sleep($DELAYUPGRADEHERO1) Then Return
		If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn2")
		If isGemOpen(True) Then         ; Redundant Safety Check if the use Gem window opens
			SetLog("King Upgrade Fail! Gem Window popped up!", $COLOR_ERROR)
			Return
		EndIf
		SetLog("King Upgrade complete", $COLOR_SUCCESS)
		GUICtrlSetState($g_hPicKingGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicKingRed, $GUI_SHOW)
		GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicKingGreen, $GUI_HIDE)
		$g_iHeroUpgrading[0] = 1
		$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroKing)
		$g_iFreeBuilderCount -= 1
		If _Sleep($DELAYUPGRADEHERO2) Then Return         ; Wait for window to close
		$g_iNbrOfHeroesUpped += 1
		$g_iCostDElixirHero += $bUpgradeCost
		UpdateStats()
		If Not $g_bRepUpgradeKingEnable Then
			$g_bUpgradeKingEnable = False ; turn Off the Kings upgrade
			GUICtrlSetState($g_hChkUpgradeKing, $GUI_UNCHECKED)
			_GUI_Value_STATE("HIDE", $groupKingSleeping)
			For $i In $ahGroupKingWait
				_GUICtrlSetTip($i, $TxtTip)
			Next
			GUICtrlSetState($g_hChkRepUpgradeKing, $GUI_UNCHECKED + $GUI_DISABLE)
		EndIf
		Local $bFinishTime = ConvertOCRTime("FinishTime", $g_aUpgradeDuration, False)
		$g_aiHeroUpgradeFinishDate[0] = _DateAdd('n', Ceiling($bFinishTime), _NowCalc())
		SetLog("King Upgrade Finishes @ " & $g_aiHeroUpgradeFinishDate[0], $COLOR_SUCCESS)
		$g_aiHeroNeededResource[0] = 0
		$g_aiCurrentLoot[$eLootDarkElixir] -= $bUpgradeCost
	ElseIf IsArray($YellowSearch) Then

		Local $bUpgradeCost = ($g_afKingUpgCost[$g_iKingLevel] * 1000 * (1 - Number($g_iBuilderBoostDiscount) / 100))
		SetLog("Upgrade cost " & _NumberFormat($bUpgradeCost) & " Dark Elixir", $COLOR_INFO)
		If _Sleep(1000) Then Return

		ClickP($YellowSearch, 1, 120)         ; Click upgrade buttton

		If _Sleep($DELAYUPGRADEHERO1) Then Return
		If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn2")
		If isGemOpen(True) Then         ; Redundant Safety Check if the use Gem window opens
			SetLog("King Upgrade Fail! Gem Window popped up!", $COLOR_ERROR)
			Return
		EndIf
		SetLog("King Upgrade complete", $COLOR_SUCCESS)
		GUICtrlSetState($g_hPicKingGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicKingRed, $GUI_SHOW)
		GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicKingGreen, $GUI_HIDE)
		$g_iHeroUpgrading[0] = 1
		$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroKing)
		If _Sleep($DELAYUPGRADEHERO2) Then Return         ; Wait for window to close
		$g_iNbrOfHeroesUpped += 1
		$g_iCostDElixirHero += $bUpgradeCost
		UpdateStats()
		If Not $g_bRepUpgradeKingEnable Then
			$g_bUpgradeKingEnable = False ; turn Off the Kings upgrade
			GUICtrlSetState($g_hChkUpgradeKing, $GUI_UNCHECKED)
			_GUI_Value_STATE("HIDE", $groupKingSleeping)
			For $i In $ahGroupKingWait
				_GUICtrlSetTip($i, $TxtTip)
			Next
			GUICtrlSetState($g_hChkRepUpgradeKing, $GUI_UNCHECKED + $GUI_DISABLE)
		EndIf
		Local $bFinishTime = ConvertOCRTime("FinishTime", $g_aUpgradeDuration, False)
		$g_aiHeroUpgradeFinishDate[0] = _DateAdd('n', Ceiling($bFinishTime), _NowCalc())
		SetLog("King Upgrade Finishes @ " & $g_aiHeroUpgradeFinishDate[0], $COLOR_SUCCESS)
		$g_aiHeroNeededResource[0] = 0
		$g_aiCurrentLoot[$eLootDarkElixir] -= $bUpgradeCost
	Else
		SetLog("King Upgrade Fail! No DE!", $COLOR_ERROR)
		CloseWindow2(1)
		Return
	EndIf

EndFunc   ;==>KingUpgrade

Func QueenUpgrade()

	If Not $g_bUpgradeQueenEnable Then Return

	SetLog("Upgrade Queen")

	If Not $g_bRunState Then Return

	If $g_iTownHallLevel < 8 Then
		SetLog("TH upgrade needed - Skipped!", $COLOR_ERROR)
		$g_bUpgradeQueenEnable = False ; turn Off the Queens upgrade
		GUICtrlSetState($g_hChkUpgradeQueen, $GUI_UNCHECKED)
		chkUpgradeQueen()
		ReducecmbHeroReservedBuilder()
		Return
	EndIf

	If IsArray(_PixelSearch($bXcoords[1] - 6, 438 + $g_iMidOffsetY, $bXcoords[1] + 4, 444 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
		SetLog("Queen Upgrade is already Running - Skipped!", $COLOR_INFO)
		Return
	EndIf
	Local $bOffset = False
	If _ColorCheck(_GetPixelColor($bXcoords[1], 438 + $g_iMidOffsetY, True), Hex(0x8BD43A, 6), 20) And _
			IsArray(_PixelSearch($bXcoords[1], 438 + $g_iMidOffsetY, $bXcoords[1] + 95, 444 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
		SetDebugLog("Green Pixel Check: OK")
	ElseIf _ColorCheck(_GetPixelColor($bXcoords[1] + 42, 438 + $g_iMidOffsetY, True), Hex(0x8BD43A, 6), 20) And _
			IsArray(_PixelSearch($bXcoords[1] + 42, 438 + $g_iMidOffsetY, $bXcoords[1] + 95, 444 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
		SetDebugLog("Green Pixel Check: OK")
		$bOffset = True
	Else
		If IsArray(_PixelSearch($bXcoords[1], 438 + $g_iMidOffsetY, $bXcoords[1] + 95, 444 + $g_iMidOffsetY, Hex(0xFF887F, 6), 20, True)) Then
			SetLog("Insufficient DE for Upg Queen", $COLOR_INFO)
			If $g_aiHeroNeededResource[1] = 0 Then NeededResources("Queen")
			Return
		EndIf
		Local $HeroMaxLevel = decodeSingleCoord(FindImageInPlace2("HeroMaxLevel", $ImgHeroMaxLevel, $bXcoords[1] + 20, 420 + $g_iMidOffsetY, $bXcoords[1] + 100, 445 + $g_iMidOffsetY, True))
		If IsArray($HeroMaxLevel) And UBound($HeroMaxLevel) = 2 Then
			SetLog("Your Archer Queen is at max level, cannot upgrade anymore!", $COLOR_INFO)
			$g_bUpgradeQueenEnable = False ; turn Off the Kings upgrade
			GUICtrlSetState($g_hChkUpgradeQueen, $GUI_UNCHECKED)
			chkUpgradeQueen()
			ReducecmbHeroReservedBuilder()
			Return
		EndIf
		If _ColorCheck(_GetPixelColor($bXcoords[1], 438 + $g_iMidOffsetY, True), Hex(0xADADAD, 6), 15) Or _ColorCheck(_GetPixelColor($bXcoords[1] + 42, 438 + $g_iMidOffsetY, True), Hex(0xADADAD, 6), 15) Then
			SetLog("Hero Hall upgrade needed - Skipped!", $COLOR_ERROR)
			Return
		EndIf
		If _ColorCheck(_GetPixelColor($bXcoords[1], 438 + $g_iMidOffsetY, True), Hex(0x6D6D6D, 6), 15) Then
			SetLog("Hero Hall upgrade needed - Skipped!", $COLOR_ERROR)
			Return
		EndIf
	EndIf

	If $bOffset Then
		Local $g_iQueenCostOCR = getOcrAndCapture("coc-HeroCost", $bXcoords[1] + 38, 433 + $g_iMidOffsetY, 65, 20, True)
	Else
		Local $g_iQueenCostOCR = getOcrAndCapture("coc-HeroCost", $bXcoords[1] + 23, 433 + $g_iMidOffsetY, 65, 20, True)
	EndIf
	If $g_iQueenCostOCR = "" Then
		SetLog("Queen Cost OCR Read Error", $COLOR_ERROR)
		Return
	EndIf

	If _Sleep($DELAYUPGRADEHERO1) Then Return

	Click($bXcoords[1] + 55, 433 + $g_iMidOffsetY) ; Click Upgrade Button
	If _Sleep($DELAYUPGRADEHERO3) Then Return ; Wait for window to open
	If Not $g_bRunState Then Return

	If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn1")
	If _ColorCheck(_GetPixelColor(800, 88 + $g_iMidOffsetY, True), Hex(0xF38E8D, 6), 20) Then ; Check if the Hero Upgrade window is open
		Local $g_iQueenLevelOCR = getYellowLevel(518, 116)
		$g_iQueenLevel = Number($g_iQueenLevelOCR - 1)
		If $g_iQueenLevel = -1 Then
			SetLog("Unable To Read Queen Level, Skip Upgrade!", $COLOR_ERROR)
			CloseWindow2(1)
			Return
		Else
			SetLog("Your Archer Queen Level read as: " & $g_iQueenLevel, $COLOR_SUCCESS)
		EndIf
	EndIf

	Local $RedSearch = _PixelSearch(610, 535 + $g_iMidOffsetY, 650, 557 + $g_iMidOffsetY, Hex(0xFF887F, 6), 20)
	If IsArray($RedSearch) Then
		If $g_aiCurrentLoot[$eLootDarkElixir] < ($g_afQueenUpgCost[$g_iQueenLevel] * 1000) * (1 - Number($g_iBuilderBoostDiscount) / 100) + $g_iUpgradeMinDark Then
			SetLog("Insufficient DE for Upg Queen, requires: " & ($g_afQueenUpgCost[$g_iQueenLevel] * 1000) * (1 - Number($g_iBuilderBoostDiscount) / 100) & " + " & $g_iUpgradeMinDark, $COLOR_INFO)
			CloseWindow2(1)
			Return
		EndIf
	EndIf

	Local $g_aUpgradeDuration = getHeroUpgradeTime(715, 544 + $g_iMidOffsetY) ; get duration
	If $g_aUpgradeDuration = "" Then $g_aUpgradeDuration = getHeroUpgradeTime(730, 532 + $g_iMidOffsetY) ; Try to read yellow text (Discount).

	Local $aWhiteZeros = decodeSingleCoord(FindImageInPlace2("UpgradeWhiteZero", $g_sImgUpgradeWhiteZero, 560, 535 + $g_iMidOffsetY, 670, 565 + $g_iMidOffsetY, True))
	Local $YellowSearch = _PixelSearch(610, 539 + $g_iMidOffsetY, 650, 543 + $g_iMidOffsetY, Hex(0xFFF10D, 6), 20)
	Local $ahGroupQueenWait[4] = [$g_hChkDBQueenWait, $g_hChkABQueenWait, $g_hPicDBQueenWait, $g_hPicABQueenWait]
	Local $TxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtQueenWait_Info_01", -1) & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtQueenWait_Info_02", -1)
	Local $TxtWarningTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtQueenWait_Info_03", "ATTENTION: Queen auto upgrade is currently enable.")
	If (IsArray($aWhiteZeros) And UBound($aWhiteZeros, 1) = 2) Then

		Local $bUpgradeCost = ($g_afQueenUpgCost[$g_iQueenLevel] * 1000 * (1 - Number($g_iBuilderBoostDiscount) / 100))
		SetLog("Upgrade cost " & _NumberFormat($bUpgradeCost) & " Dark Elixir", $COLOR_INFO)
		If _Sleep(1000) Then Return

		ClickP($aWhiteZeros, 1, 120)         ; Click upgrade buttton

		If _Sleep($DELAYUPGRADEHERO1) Then Return
		If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn2")
		If isGemOpen(True) Then         ; Redundant Safety Check if the use Gem window opens
			SetLog("Queen Upgrade Fail! Gem Window popped up!", $COLOR_ERROR)
			Return
		EndIf
		SetLog("Queen Upgrade complete", $COLOR_SUCCESS)
		GUICtrlSetState($g_hPicQueenGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicQueenRed, $GUI_SHOW)
		GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicQueenGreen, $GUI_HIDE)
		$g_iHeroUpgrading[1] = 1
		$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroQueen)
		$g_iFreeBuilderCount -= 1
		If _Sleep($DELAYUPGRADEHERO2) Then Return         ; Wait for window to close
		$g_iNbrOfHeroesUpped += 1
		$g_iCostDElixirHero += $bUpgradeCost
		UpdateStats()
		If Not $g_bRepUpgradeQueenEnable Then
			$g_bUpgradeQueenEnable = False ; turn Off the Queens upgrade
			GUICtrlSetState($g_hChkUpgradeQueen, $GUI_UNCHECKED)
			_GUI_Value_STATE("HIDE", $groupQueenSleeping)
			For $i In $ahGroupQueenWait
				_GUICtrlSetTip($i, $TxtTip)
			Next
			GUICtrlSetState($g_hChkRepUpgradeQueen, $GUI_UNCHECKED + $GUI_DISABLE)
		EndIf
		Local $bFinishTime = ConvertOCRTime("FinishTime", $g_aUpgradeDuration, False)
		$g_aiHeroUpgradeFinishDate[1] = _DateAdd('n', Ceiling($bFinishTime), _NowCalc())
		SetLog("Queen Upgrade Finishes @ " & $g_aiHeroUpgradeFinishDate[1], $COLOR_SUCCESS)
		$g_aiHeroNeededResource[1] = 0
		$g_aiCurrentLoot[$eLootDarkElixir] -= $bUpgradeCost
	ElseIf IsArray($YellowSearch) Then

		Local $bUpgradeCost = ($g_afQueenUpgCost[$g_iQueenLevel] * 1000 * (1 - Number($g_iBuilderBoostDiscount) / 100))
		SetLog("Upgrade cost " & _NumberFormat($bUpgradeCost) & " Dark Elixir", $COLOR_INFO)
		If _Sleep(1000) Then Return

		ClickP($YellowSearch, 1, 120)         ; Click upgrade buttton

		If _Sleep($DELAYUPGRADEHERO1) Then Return
		If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn2")
		If isGemOpen(True) Then         ; Redundant Safety Check if the use Gem window opens
			SetLog("Queen Upgrade Fail! Gem Window popped up!", $COLOR_ERROR)
			Return
		EndIf
		SetLog("Queen Upgrade complete", $COLOR_SUCCESS)
		GUICtrlSetState($g_hPicQueenGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicQueenRed, $GUI_SHOW)
		GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicQueenGreen, $GUI_HIDE)
		$g_iHeroUpgrading[1] = 1
		$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroQueen)
		If _Sleep($DELAYUPGRADEHERO2) Then Return         ; Wait for window to close
		$g_iNbrOfHeroesUpped += 1
		$g_iCostDElixirHero += $bUpgradeCost
		UpdateStats()
		If Not $g_bRepUpgradeQueenEnable Then
			$g_bUpgradeQueenEnable = False ; turn Off the Queens upgrade
			GUICtrlSetState($g_hChkUpgradeQueen, $GUI_UNCHECKED)
			_GUI_Value_STATE("HIDE", $groupQueenSleeping)
			For $i In $ahGroupQueenWait
				_GUICtrlSetTip($i, $TxtTip)
			Next
			GUICtrlSetState($g_hChkRepUpgradeQueen, $GUI_UNCHECKED + $GUI_DISABLE)
		EndIf
		Local $bFinishTime = ConvertOCRTime("FinishTime", $g_aUpgradeDuration, False)
		$g_aiHeroUpgradeFinishDate[1] = _DateAdd('n', Ceiling($bFinishTime), _NowCalc())
		SetLog("Queen Upgrade Finishes @ " & $g_aiHeroUpgradeFinishDate[1], $COLOR_SUCCESS)
		$g_aiHeroNeededResource[1] = 0
		$g_aiCurrentLoot[$eLootDarkElixir] -= $bUpgradeCost
	Else
		SetLog("Queen Upgrade Fail! No DE!", $COLOR_ERROR)
		CloseWindow2(1)
		Return
	EndIf

EndFunc   ;==>QueenUpgrade

Func PrinceUpgrade()

	If Not $g_bUpgradePrinceEnable Then Return

	SetLog("Upgrade Prince")

	If Not $g_bRunState Then Return

	If $g_iTownHallLevel < 9 Then
		SetLog("TH upgrade needed - Skipped!", $COLOR_ERROR)
		$g_bUpgradePrinceEnable = False ; turn Off the Princes upgrade
		GUICtrlSetState($g_hChkUpgradePrince, $GUI_UNCHECKED)
		chkUpgradePrince()
		ReducecmbHeroReservedBuilder()
		Return
	EndIf

	If IsArray(_PixelSearch($bXcoords[2] - 6, 438 + $g_iMidOffsetY, $bXcoords[2] + 4, 444 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
		SetLog("Prince Upgrade is already Running - Skipped!", $COLOR_INFO)
		Return
	EndIf
	Local $bOffset = False
	If _ColorCheck(_GetPixelColor($bXcoords[2], 438 + $g_iMidOffsetY, True), Hex(0x8BD43A, 6), 20) And _
			IsArray(_PixelSearch($bXcoords[2], 438 + $g_iMidOffsetY, $bXcoords[2] + 95, 444 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
		SetDebugLog("Green Pixel Check: OK")
	ElseIf _ColorCheck(_GetPixelColor($bXcoords[2] + 42, 438 + $g_iMidOffsetY, True), Hex(0x8BD43A, 6), 20) And _
			IsArray(_PixelSearch($bXcoords[2] + 42, 438 + $g_iMidOffsetY, $bXcoords[2] + 95, 444 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
		SetDebugLog("Green Pixel Check: OK")
		$bOffset = True
	Else
		If IsArray(_PixelSearch($bXcoords[2], 438 + $g_iMidOffsetY, $bXcoords[2] + 95, 444 + $g_iMidOffsetY, Hex(0xFF887F, 6), 20, True)) Then
			SetLog("Insufficient DE for Upg Prince", $COLOR_INFO)
			If $g_aiHeroNeededResource[2] = 0 Then NeededResources("Prince")
			Return
		EndIf
		Local $HeroMaxLevel = decodeSingleCoord(FindImageInPlace2("HeroMaxLevel", $ImgHeroMaxLevel, $bXcoords[2] + 20, 420 + $g_iMidOffsetY, $bXcoords[2] + 100, 445 + $g_iMidOffsetY, True))
		If IsArray($HeroMaxLevel) And UBound($HeroMaxLevel) = 2 Then
			SetLog("Your Minion Prince is at max level, cannot upgrade anymore!", $COLOR_INFO)
			$g_bUpgradePrinceEnable = False ; turn Off the Princes upgrade
			GUICtrlSetState($g_hChkUpgradePrince, $GUI_UNCHECKED)
			chkUpgradePrince()
			ReducecmbHeroReservedBuilder()
			Return
		EndIf
		If _ColorCheck(_GetPixelColor($bXcoords[2], 438 + $g_iMidOffsetY, True), Hex(0xADADAD, 6), 15) Or _ColorCheck(_GetPixelColor($bXcoords[2] + 42, 438 + $g_iMidOffsetY, True), Hex(0xADADAD, 6), 15) Then
			SetLog("Hero Hall upgrade needed - Skipped!", $COLOR_ERROR)
			Return
		EndIf
		If _ColorCheck(_GetPixelColor($bXcoords[2], 438 + $g_iMidOffsetY, True), Hex(0x6D6D6D, 6), 15) Then
			SetLog("Hero Hall upgrade needed - Skipped!", $COLOR_ERROR)
			Return
		EndIf
	EndIf

	If $bOffset Then
		Local $g_iPrinceCostOCR = getOcrAndCapture("coc-HeroCost", $bXcoords[2] + 38, 433 + $g_iMidOffsetY, 65, 20, True)
	Else
		Local $g_iPrinceCostOCR = getOcrAndCapture("coc-HeroCost", $bXcoords[2] + 23, 433 + $g_iMidOffsetY, 65, 20, True)
	EndIf
	If $g_iPrinceCostOCR = "" Then
		SetLog("Prince Cost OCR Read Error", $COLOR_ERROR)
		Return
	EndIf

	If _Sleep($DELAYUPGRADEHERO1) Then Return

	Click($bXcoords[2] + 55, 433 + $g_iMidOffsetY) ; Click Upgrade Button
	If _Sleep($DELAYUPGRADEHERO3) Then Return ; Wait for window to open
	If Not $g_bRunState Then Return

	If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn1")
	If _ColorCheck(_GetPixelColor(800, 88 + $g_iMidOffsetY, True), Hex(0xF38E8D, 6), 20) Then ; Check if the Hero Upgrade window is open
		Local $g_iPrinceLevelOCR = getYellowLevel(518, 116)
		$g_iPrinceLevel = Number($g_iPrinceLevelOCR - 1)
		If $g_iPrinceLevel = -1 Then
			SetLog("Unable To Read Prince Level, Skip Upgrade!", $COLOR_ERROR)
			CloseWindow2(1)
			Return
		Else
			SetLog("Your Minion Prince Level read as: " & $g_iPrinceLevel, $COLOR_SUCCESS)
		EndIf
	EndIf

	Local $RedSearch = _PixelSearch(610, 535 + $g_iMidOffsetY, 650, 557 + $g_iMidOffsetY, Hex(0xFF887F, 6), 20)
	If IsArray($RedSearch) Then
		If $g_aiCurrentLoot[$eLootDarkElixir] < ($g_afPrinceUpgCost[$g_iPrinceLevel] * 1000) * (1 - Number($g_iBuilderBoostDiscount) / 100) + $g_iUpgradeMinDark Then
			SetLog("Insufficient DE for Upg Prince, requires: " & ($g_afPrinceUpgCost[$g_iPrinceLevel] * 1000) * (1 - Number($g_iBuilderBoostDiscount) / 100) & " + " & $g_iUpgradeMinDark, $COLOR_INFO)
			CloseWindow2(1)
			Return
		EndIf
	EndIf

	Local $g_aUpgradeDuration = getHeroUpgradeTime(715, 544 + $g_iMidOffsetY) ; get duration
	If $g_aUpgradeDuration = "" Then $g_aUpgradeDuration = getHeroUpgradeTime(730, 532 + $g_iMidOffsetY) ; Try to read yellow text (Discount).

	Local $aWhiteZeros = decodeSingleCoord(FindImageInPlace2("UpgradeWhiteZero", $g_sImgUpgradeWhiteZero, 560, 535 + $g_iMidOffsetY, 670, 565 + $g_iMidOffsetY, True))
	Local $YellowSearch = _PixelSearch(610, 539 + $g_iMidOffsetY, 650, 543 + $g_iMidOffsetY, Hex(0xFFF10D, 6), 20)
	Local $ahGroupPrinceWait[4] = [$g_hChkDBPrinceWait, $g_hChkABPrinceWait, $g_hPicDBPrinceWait, $g_hPicABPrinceWait]
	Local $TxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtPrinceWait_Info_01", -1) & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtPrinceWait_Info_02", -1)
	Local $TxtWarningTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtPrinceWait_Info_03", "ATTENTION: Prince auto upgrade is currently enable.")
	If (IsArray($aWhiteZeros) And UBound($aWhiteZeros, 1) = 2) Then

		Local $bUpgradeCost = ($g_afPrinceUpgCost[$g_iPrinceLevel] * 1000 * (1 - Number($g_iBuilderBoostDiscount) / 100))
		SetLog("Upgrade cost " & _NumberFormat($bUpgradeCost) & " Dark Elixir", $COLOR_INFO)
		If _Sleep(1000) Then Return

		ClickP($aWhiteZeros, 1, 120)         ; Click upgrade buttton

		If _Sleep($DELAYUPGRADEHERO1) Then Return
		If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn2")
		If isGemOpen(True) Then         ; Redundant Safety Check if the use Gem window opens
			SetLog("Prince Upgrade Fail! Gem Window popped up!", $COLOR_ERROR)
			Return
		EndIf
		SetLog("Prince Upgrade complete", $COLOR_SUCCESS)
		GUICtrlSetState($g_hPicPrinceGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicPrinceRed, $GUI_SHOW)
		GUICtrlSetState($g_hPicPrinceBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicPrinceGreen, $GUI_HIDE)
		$g_iHeroUpgrading[2] = 1
		$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroPrince)
		$g_iFreeBuilderCount -= 1
		If _Sleep($DELAYUPGRADEHERO2) Then Return         ; Wait for window to close
		$g_iNbrOfHeroesUpped += 1
		$g_iCostDElixirHero += $bUpgradeCost
		UpdateStats()
		If Not $g_bRepUpgradePrinceEnable Then
			$g_bUpgradePrinceEnable = False ; turn Off the Princes upgrade
			GUICtrlSetState($g_hChkUpgradePrince, $GUI_UNCHECKED)
			_GUI_Value_STATE("HIDE", $groupPrinceSleeping)
			For $i In $ahGroupPrinceWait
				_GUICtrlSetTip($i, $TxtTip)
			Next
			GUICtrlSetState($g_hChkRepUpgradePrince, $GUI_UNCHECKED + $GUI_DISABLE)
		EndIf
		Local $bFinishTime = ConvertOCRTime("FinishTime", $g_aUpgradeDuration, False)
		$g_aiHeroUpgradeFinishDate[2] = _DateAdd('n', Ceiling($bFinishTime), _NowCalc())
		SetLog("Prince Upgrade Finishes @ " & $g_aiHeroUpgradeFinishDate[2], $COLOR_SUCCESS)
		$g_aiHeroNeededResource[2] = 0
		$g_aiCurrentLoot[$eLootDarkElixir] -= $bUpgradeCost
	ElseIf IsArray($YellowSearch) Then

		Local $bUpgradeCost = ($g_afPrinceUpgCost[$g_iPrinceLevel] * 1000 * (1 - Number($g_iBuilderBoostDiscount) / 100))
		SetLog("Upgrade cost " & _NumberFormat($bUpgradeCost) & " Dark Elixir", $COLOR_INFO)
		If _Sleep(1000) Then Return

		ClickP($YellowSearch, 1, 120)         ; Click upgrade buttton

		If _Sleep($DELAYUPGRADEHERO1) Then Return
		If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn2")
		If isGemOpen(True) Then         ; Redundant Safety Check if the use Gem window opens
			SetLog("Prince Upgrade Fail! Gem Window popped up!", $COLOR_ERROR)
			Return
		EndIf
		SetLog("Prince Upgrade complete", $COLOR_SUCCESS)
		GUICtrlSetState($g_hPicPrinceGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicPrinceRed, $GUI_SHOW)
		GUICtrlSetState($g_hPicPrinceBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicPrinceGreen, $GUI_HIDE)
		$g_iHeroUpgrading[2] = 1
		$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroPrince)
		If _Sleep($DELAYUPGRADEHERO2) Then Return         ; Wait for window to close
		$g_iNbrOfHeroesUpped += 1
		$g_iCostDElixirHero += $bUpgradeCost
		UpdateStats()
		If Not $g_bRepUpgradePrinceEnable Then
			$g_bUpgradePrinceEnable = False ; turn Off the Princes upgrade
			GUICtrlSetState($g_hChkUpgradePrince, $GUI_UNCHECKED)
			_GUI_Value_STATE("HIDE", $groupPrinceSleeping)
			For $i In $ahGroupPrinceWait
				_GUICtrlSetTip($i, $TxtTip)
			Next
			GUICtrlSetState($g_hChkRepUpgradePrince, $GUI_UNCHECKED + $GUI_DISABLE)
		EndIf
		Local $bFinishTime = ConvertOCRTime("FinishTime", $g_aUpgradeDuration, False)
		$g_aiHeroUpgradeFinishDate[2] = _DateAdd('n', Ceiling($bFinishTime), _NowCalc())
		SetLog("Prince Upgrade Finishes @ " & $g_aiHeroUpgradeFinishDate[2], $COLOR_SUCCESS)
		$g_aiHeroNeededResource[2] = 0
		$g_aiCurrentLoot[$eLootDarkElixir] -= $bUpgradeCost
	Else
		SetLog("Prince Upgrade Fail! No DE!", $COLOR_ERROR)
		CloseWindow2(1)
		Return
	EndIf

EndFunc   ;==>PrinceUpgrade

Func WardenUpgrade()
	If Not $g_bUpgradeWardenEnable Then Return

	If Not $bCheckValuesForWarden Then
		SetLog("Upgrade Warden")
	Else
		SetLog("Checking Warden Values")
	EndIf

	If Not $g_bRunState Then Return

	If $g_iTownHallLevel < 11 Then
		SetLog("TH upgrade needed - Skipped!", $COLOR_ERROR)
		$g_bUpgradeWardenEnable = False ; turn Off the Wardens upgrade
		GUICtrlSetState($g_hChkUpgradeWarden, $GUI_UNCHECKED)
		chkUpgradeWarden()
		ReducecmbHeroReservedBuilder()
		Return
	EndIf

	If IsArray(_PixelSearch($bXcoords[3] - 6, 438 + $g_iMidOffsetY, $bXcoords[3] + 4, 444 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
		SetLog("Warden Upgrade is already Running - Skipped!", $COLOR_INFO)
		Return
	EndIf
	Local $bOffset = False
	If _ColorCheck(_GetPixelColor($bXcoords[3], 438 + $g_iMidOffsetY, True), Hex(0x8BD43A, 6), 20) And _
			IsArray(_PixelSearch($bXcoords[3], 438 + $g_iMidOffsetY, $bXcoords[3] + 95, 444 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
		SetDebugLog("Green Pixel Check: OK")
	ElseIf _ColorCheck(_GetPixelColor($bXcoords[3] + 42, 425 + $g_iMidOffsetY, True), Hex(0xBEEA8C, 6), 20) And _
			IsArray(_PixelSearch($bXcoords[3] + 42, 438 + $g_iMidOffsetY, $bXcoords[3] + 95, 444 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
		SetDebugLog("Green Pixel Check: OK")
		$bOffset = True
	Else
		If IsArray(_PixelSearch($bXcoords[3], 438 + $g_iMidOffsetY, $bXcoords[3] + 95, 444 + $g_iMidOffsetY, Hex(0xFF887F, 6), 20, True)) Then
			SetLog("Insufficient Elixir for Upg Warden", $COLOR_INFO)
			If $g_aiHeroNeededResource[3] = 0 Then NeededResources("Warden")
			Return
		EndIf
		Local $HeroMaxLevel = decodeSingleCoord(FindImageInPlace2("HeroMaxLevel", $ImgHeroMaxLevel, $bXcoords[3] + 20, 420 + $g_iMidOffsetY, $bXcoords[3] + 100, 445 + $g_iMidOffsetY, True))
		If IsArray($HeroMaxLevel) And UBound($HeroMaxLevel) = 2 Then
			SetLog("Your Grand Warden is at max level, cannot upgrade anymore!", $COLOR_INFO)
			$g_bUpgradeWardenEnable = False ; turn Off the Wardens upgrade
			GUICtrlSetState($g_hChkUpgradeWarden, $GUI_UNCHECKED)
			chkUpgradeWarden()
			ReducecmbHeroReservedBuilder()
			Return
		EndIf
		If _ColorCheck(_GetPixelColor($bXcoords[3], 438 + $g_iMidOffsetY, True), Hex(0xADADAD, 6), 15) Or _ColorCheck(_GetPixelColor($bXcoords[3] + 42, 425 + $g_iMidOffsetY, True), Hex(0xD2D2D2, 6), 15) Then
			SetLog("Hero Hall upgrade needed - Skipped!", $COLOR_ERROR)
			Return
		EndIf
		If _ColorCheck(_GetPixelColor($bXcoords[3], 438 + $g_iMidOffsetY, True), Hex(0x6D6D6D, 6), 15) Then
			SetLog("Hero Hall upgrade needed - Skipped!", $COLOR_ERROR)
			Return
		EndIf
	EndIf

	If $bOffset Then
		Local $g_iWardenCostOCR = getOcrAndCapture("coc-HeroCost", $bXcoords[3] + 32, 433 + $g_iMidOffsetY, 75, 20, True)
	Else
		Local $g_iWardenCostOCR = getOcrAndCapture("coc-HeroCost", $bXcoords[3] + 10, 433 + $g_iMidOffsetY, 84, 20, True)
	EndIf
	If $g_iWardenCostOCR = "" Then
		SetLog("Warden Cost OCR Read Error", $COLOR_ERROR)
		Return
	EndIf

	If _Sleep($DELAYUPGRADEHERO1) Then Return

	Click($bXcoords[3] + 55, 433 + $g_iMidOffsetY) ; Click Upgrade Button
	If _Sleep($DELAYUPGRADEHERO3) Then Return ; Wait for window to open
	If Not $g_bRunState Then Return

	If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn1")
	If _ColorCheck(_GetPixelColor(800, 88 + $g_iMidOffsetY, True), Hex(0xF38E8D, 6), 20) Then ; Check if the Hero Upgrade window is open
		Local $g_iWardenLevelOCR = getYellowLevel(522, 116)
		$g_iWardenLevel = Number($g_iWardenLevelOCR - 1)
		If $g_iWardenLevel = -1 Then
			SetLog("Unable To Read Warden Level, Skip Upgrade!", $COLOR_ERROR)
			CloseWindow2(1)
			Return
		Else
			SetLog("Your Grand Warden Level read as: " & $g_iWardenLevel, $COLOR_SUCCESS)
		EndIf
	EndIf

	If $bCheckValuesForWarden Then
		If $g_aiHeroNeededResource[3] = 0 Then
			$g_aiHeroNeededResource[3] = ($g_afWardenUpgCost[$g_iWardenLevel] * 1000000 * (1 - Number($g_iBuilderBoostDiscount) / 100))
			SetLog("Warden Upgrade Requires " & _NumberFormat($g_aiHeroNeededResource[3]) & " Elixir", $COLOR_SUCCESS)
			CloseWindow2(1)
			Return
		EndIf
	EndIf

	Local $RedSearch = _PixelSearch(610, 535 + $g_iMidOffsetY, 650, 557 + $g_iMidOffsetY, Hex(0xFF887F, 6), 20)
	If IsArray($RedSearch) Then
		If $g_aiCurrentLoot[$eLootElixir] < ($g_afWardenUpgCost[$g_iWardenLevel] * 1000000) * (1 - Number($g_iBuilderBoostDiscount) / 100) + $g_iUpgradeMinDark Then
			SetLog("Insufficient Elixir for Upg Warden, requires: " & ($g_afWardenUpgCost[$g_iWardenLevel] * 1000000) * (1 - Number($g_iBuilderBoostDiscount) / 100) & " + " & $g_iUpgradeMinDark, $COLOR_INFO)
			CloseWindow2(1)
			Return
		EndIf
	EndIf

	Local $g_aUpgradeDuration = getHeroUpgradeTime(715, 544 + $g_iMidOffsetY) ; get duration
	If $g_aUpgradeDuration = "" Then $g_aUpgradeDuration = getHeroUpgradeTime(730, 532 + $g_iMidOffsetY) ; Try to read yellow text (Discount).

	Local $aWhiteZeros = decodeSingleCoord(FindImageInPlace2("UpgradeWhiteZero", $g_sImgUpgradeWhiteZero, 560, 535 + $g_iMidOffsetY, 670, 565 + $g_iMidOffsetY, True))
	Local $YellowSearch = _PixelSearch(610, 539 + $g_iMidOffsetY, 650, 543 + $g_iMidOffsetY, Hex(0xFFF10D, 6), 20)
	Local $ahGroupWardenWait[4] = [$g_hChkDBWardenWait, $g_hChkABWardenWait, $g_hPicDBWardenWait, $g_hPicABWardenWait]
	Local $TxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtWardenWait_Info_01", -1) & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtWardenWait_Info_02", -1)
	Local $TxtWarningTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtWardenWait_Info_03", "ATTENTION: Warden auto upgrade is currently enable.")
	If (IsArray($aWhiteZeros) And UBound($aWhiteZeros, 1) = 2) Then

		Local $bUpgradeCost = ($g_afWardenUpgCost[$g_iWardenLevel] * 1000000 * (1 - Number($g_iBuilderBoostDiscount) / 100))
		SetLog("Upgrade cost " & _NumberFormat($bUpgradeCost) & " Elixir", $COLOR_INFO)
		If _Sleep(1000) Then Return

		ClickP($aWhiteZeros, 1, 120)         ; Click upgrade buttton

		If _Sleep($DELAYUPGRADEHERO1) Then Return
		If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn2")
		If isGemOpen(True) Then         ; Redundant Safety Check if the use Gem window opens
			SetLog("Warden Upgrade Fail! Gem Window popped up!", $COLOR_ERROR)
			Return
		EndIf
		SetLog("Warden Upgrade complete", $COLOR_SUCCESS)
		GUICtrlSetState($g_hPicWardenGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicWardenRed, $GUI_SHOW)
		GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicWardenGreen, $GUI_HIDE)
		$g_iHeroUpgrading[3] = 1
		$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroWarden)
		$g_iFreeBuilderCount -= 1
		If _Sleep($DELAYUPGRADEHERO2) Then Return         ; Wait for window to close
		$g_iNbrOfWardenUpped += 1
		$g_iCostElixirWarden += $bUpgradeCost
		UpdateStats()
		If Not $g_bRepUpgradeWardenEnable Then
			$g_bUpgradeWardenEnable = False ; turn Off the Wardens upgrade
			GUICtrlSetState($g_hChkUpgradeWarden, $GUI_UNCHECKED)
			_GUI_Value_STATE("HIDE", $groupWardenSleeping)
			For $i In $ahGroupWardenWait
				_GUICtrlSetTip($i, $TxtTip)
			Next
			GUICtrlSetState($g_hChkRepUpgradeWarden, $GUI_UNCHECKED + $GUI_DISABLE)
		EndIf
		Local $bFinishTime = ConvertOCRTime("FinishTime", $g_aUpgradeDuration, False)
		$g_aiHeroUpgradeFinishDate[3] = _DateAdd('n', Ceiling($bFinishTime), _NowCalc())
		SetLog("Warden Upgrade Finishes @ " & $g_aiHeroUpgradeFinishDate[3], $COLOR_SUCCESS)
		$g_aiHeroNeededResource[3] = 0
		$g_aiCurrentLoot[$eLootElixir] -= $bUpgradeCost
	ElseIf IsArray($YellowSearch) Then

		Local $bUpgradeCost = ($g_afWardenUpgCost[$g_iWardenLevel] * 1000000 * (1 - Number($g_iBuilderBoostDiscount) / 100))
		SetLog("Upgrade cost " & _NumberFormat($bUpgradeCost) & " Elixir", $COLOR_INFO)
		If _Sleep(1000) Then Return

		ClickP($YellowSearch, 1, 120)         ; Click upgrade buttton

		If _Sleep($DELAYUPGRADEHERO1) Then Return
		If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn2")
		If isGemOpen(True) Then         ; Redundant Safety Check if the use Gem window opens
			SetLog("Warden Upgrade Fail! Gem Window popped up!", $COLOR_ERROR)
			Return
		EndIf
		SetLog("Warden Upgrade complete", $COLOR_SUCCESS)
		GUICtrlSetState($g_hPicWardenGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicWardenRed, $GUI_SHOW)
		GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicWardenGreen, $GUI_HIDE)
		$g_iHeroUpgrading[3] = 1
		$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroWarden)
		If _Sleep($DELAYUPGRADEHERO2) Then Return         ; Wait for window to close
		$g_iNbrOfWardenUpped += 1
		$g_iCostElixirWarden += $bUpgradeCost
		UpdateStats()
		If Not $g_bRepUpgradeWardenEnable Then
			$g_bUpgradeWardenEnable = False ; turn Off the Wardens upgrade
			GUICtrlSetState($g_hChkUpgradeWarden, $GUI_UNCHECKED)
			_GUI_Value_STATE("HIDE", $groupWardenSleeping)
			For $i In $ahGroupWardenWait
				_GUICtrlSetTip($i, $TxtTip)
			Next
			GUICtrlSetState($g_hChkRepUpgradeWarden, $GUI_UNCHECKED + $GUI_DISABLE)
		EndIf
		Local $bFinishTime = ConvertOCRTime("FinishTime", $g_aUpgradeDuration, False)
		$g_aiHeroUpgradeFinishDate[3] = _DateAdd('n', Ceiling($bFinishTime), _NowCalc())
		SetLog("Warden Upgrade Finishes @ " & $g_aiHeroUpgradeFinishDate[3], $COLOR_SUCCESS)
		$g_aiHeroNeededResource[3] = 0
		$g_aiCurrentLoot[$eLootElixir] -= $bUpgradeCost
	Else
		SetLog("Warden Upgrade Fail! No Elixir!", $COLOR_ERROR)
		CloseWindow2(1)
		Return
	EndIf

EndFunc   ;==>WardenUpgrade

Func ChampionUpgrade()

	If Not $g_bUpgradeChampionEnable Then Return

	SetLog("Upgrade Champion")

	If Not $g_bRunState Then Return

	If $g_iTownHallLevel < 13 Then
		SetLog("TH upgrade needed - Skipped!", $COLOR_ERROR)
		$g_bUpgradeChampionEnable = False ; turn Off the Champions upgrade
		GUICtrlSetState($g_hChkUpgradeChampion, $GUI_UNCHECKED)
		chkUpgradeChampion()
		ReducecmbHeroReservedBuilder()
		Return
	EndIf

	If IsArray(_PixelSearch($bXcoords[4] - 6, 438 + $g_iMidOffsetY, $bXcoords[4] + 4, 444 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
		SetLog("Champion Upgrade is already Running - Skipped!", $COLOR_INFO)
		Return
	EndIf
	Local $bOffset = False
	If _ColorCheck(_GetPixelColor($bXcoords[4], 438 + $g_iMidOffsetY, True), Hex(0x8BD43A, 6), 20) And _
			IsArray(_PixelSearch($bXcoords[4], 438 + $g_iMidOffsetY, $bXcoords[4] + 95, 444 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
		SetDebugLog("Green Pixel Check: OK")
	ElseIf _ColorCheck(_GetPixelColor($bXcoords[4] + 42, 438 + $g_iMidOffsetY, True), Hex(0x8BD43A, 6), 20) And _
			IsArray(_PixelSearch($bXcoords[4] + 42, 438 + $g_iMidOffsetY, $bXcoords[4] + 95, 444 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
		SetDebugLog("Green Pixel Check: OK")
		$bOffset = True
	Else
		If IsArray(_PixelSearch($bXcoords[4], 438 + $g_iMidOffsetY, $bXcoords[4] + 95, 444 + $g_iMidOffsetY, Hex(0xFF887F, 6), 20, True)) Then
			SetLog("Insufficient DE for Upg Champion", $COLOR_INFO)
			If $g_aiHeroNeededResource[4] = 0 Then NeededResources("Champion")
			Return
		EndIf
		Local $HeroMaxLevel = decodeSingleCoord(FindImageInPlace2("HeroMaxLevel", $ImgHeroMaxLevel, $bXcoords[4] + 20, 420 + $g_iMidOffsetY, $bXcoords[4] + 100, 445 + $g_iMidOffsetY, True))
		If IsArray($HeroMaxLevel) And UBound($HeroMaxLevel) = 2 Then
			SetLog("Your Royal Champion is at max level, cannot upgrade anymore!", $COLOR_INFO)
			$g_bUpgradeChampionEnable = False ; turn Off the Champions upgrade
			GUICtrlSetState($g_hChkUpgradeChampion, $GUI_UNCHECKED)
			chkUpgradeChampion()
			ReducecmbHeroReservedBuilder()
			Return
		EndIf
		If _ColorCheck(_GetPixelColor($bXcoords[4], 438 + $g_iMidOffsetY, True), Hex(0xADADAD, 6), 15) Or _ColorCheck(_GetPixelColor($bXcoords[4] + 42, 438 + $g_iMidOffsetY, True), Hex(0xADADAD, 6), 15) Then
			SetLog("Hero Hall upgrade needed - Skipped!", $COLOR_ERROR)
			Return
		EndIf
		If _ColorCheck(_GetPixelColor($bXcoords[4], 438 + $g_iMidOffsetY, True), Hex(0x6D6D6D, 6), 15) Then
			SetLog("Hero Hall upgrade needed - Skipped!", $COLOR_ERROR)
			Return
		EndIf
	EndIf

	If $bOffset Then
		Local $g_iChampionCostOCR = getOcrAndCapture("coc-HeroCost", $bXcoords[4] + 38, 433 + $g_iMidOffsetY, 65, 20, True)
	Else
		Local $g_iChampionCostOCR = getOcrAndCapture("coc-HeroCost", $bXcoords[4] + 23, 433 + $g_iMidOffsetY, 65, 20, True)
	EndIf
	If $g_iChampionCostOCR = "" Then
		SetLog("Champion Cost OCR Read Error", $COLOR_ERROR)
		Return
	EndIf

	If _Sleep($DELAYUPGRADEHERO1) Then Return

	Click($bXcoords[4] + 55, 433 + $g_iMidOffsetY) ; Click Upgrade Button
	If _Sleep($DELAYUPGRADEHERO3) Then Return ; Wait for window to open
	If Not $g_bRunState Then Return

	If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn1")
	If _ColorCheck(_GetPixelColor(800, 88 + $g_iMidOffsetY, True), Hex(0xF38E8D, 6), 20) Then ; Check if the Hero Upgrade window is open
		Local $g_iChampionLevelOCR = getYellowLevel(525, 116)
		$g_iChampionLevel = Number($g_iChampionLevelOCR - 1)
		If $g_iChampionLevel = -1 Then
			SetLog("Unable To Read Champion Level, Skip Upgrade!", $COLOR_ERROR)
			CloseWindow2(1)
			Return
		Else
			SetLog("Your Royal Champion Level read as: " & $g_iChampionLevel, $COLOR_SUCCESS)
		EndIf
	EndIf

	Local $RedSearch = _PixelSearch(610, 535 + $g_iMidOffsetY, 650, 557 + $g_iMidOffsetY, Hex(0xFF887F, 6), 20)
	If IsArray($RedSearch) Then
		If $g_aiCurrentLoot[$eLootDarkElixir] < ($g_afChampionUpgCost[$g_iChampionLevel] * 1000) * (1 - Number($g_iBuilderBoostDiscount) / 100) + $g_iUpgradeMinDark Then
			SetLog("Insufficient DE for Upg Champion, requires: " & ($g_afChampionUpgCost[$g_iChampionLevel] * 1000) * (1 - Number($g_iBuilderBoostDiscount) / 100) & " + " & $g_iUpgradeMinDark, $COLOR_INFO)
			CloseWindow2(1)
			Return
		EndIf
	EndIf

	Local $g_aUpgradeDuration = getHeroUpgradeTime(715, 544 + $g_iMidOffsetY) ; get duration
	If $g_aUpgradeDuration = "" Then $g_aUpgradeDuration = getHeroUpgradeTime(730, 532 + $g_iMidOffsetY) ; Try to read yellow text (Discount).

	Local $aWhiteZeros = decodeSingleCoord(FindImageInPlace2("UpgradeWhiteZero", $g_sImgUpgradeWhiteZero, 560, 535 + $g_iMidOffsetY, 670, 565 + $g_iMidOffsetY, True))
	Local $YellowSearch = _PixelSearch(610, 539 + $g_iMidOffsetY, 650, 543 + $g_iMidOffsetY, Hex(0xFFF10D, 6), 20)
	Local $ahGroupChampionWait[4] = [$g_hChkDBChampionWait, $g_hChkABChampionWait, $g_hPicDBChampionWait, $g_hPicABChampionWait]
	Local $TxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtChampionWait_Info_01", -1) & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtChampionWait_Info_02", -1)
	Local $TxtWarningTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtChampionWait_Info_03", "ATTENTION: Champion auto upgrade is currently enable.")
	If (IsArray($aWhiteZeros) And UBound($aWhiteZeros, 1) = 2) Then

		Local $bUpgradeCost = ($g_afChampionUpgCost[$g_iChampionLevel] * 1000 * (1 - Number($g_iBuilderBoostDiscount) / 100))
		SetLog("Upgrade cost " & _NumberFormat($bUpgradeCost) & " Dark Elixir", $COLOR_INFO)
		If _Sleep(1000) Then Return

		ClickP($aWhiteZeros, 1, 120)         ; Click upgrade buttton

		If _Sleep($DELAYUPGRADEHERO1) Then Return
		If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn2")
		If isGemOpen(True) Then         ; Redundant Safety Check if the use Gem window opens
			SetLog("Champion Upgrade Fail! Gem Window popped up!", $COLOR_ERROR)
			Return
		EndIf
		SetLog("Champion Upgrade complete", $COLOR_SUCCESS)
		GUICtrlSetState($g_hPicChampionGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicChampionRed, $GUI_SHOW)
		GUICtrlSetState($g_hPicChampionBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicChampionGreen, $GUI_HIDE)
		$g_iHeroUpgrading[4] = 1
		$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroChampion)
		$g_iFreeBuilderCount -= 1
		If _Sleep($DELAYUPGRADEHERO2) Then Return         ; Wait for window to close
		$g_iNbrOfHeroesUpped += 1
		$g_iCostDElixirHero += $bUpgradeCost
		UpdateStats()
		If Not $g_bRepUpgradeChampionEnable Then
			$g_bUpgradeChampionEnable = False ; turn Off the Champions upgrade
			GUICtrlSetState($g_hChkUpgradeChampion, $GUI_UNCHECKED)
			_GUI_Value_STATE("HIDE", $groupChampionSleeping)
			For $i In $ahGroupChampionWait
				_GUICtrlSetTip($i, $TxtTip)
			Next
			GUICtrlSetState($g_hChkRepUpgradeChampion, $GUI_UNCHECKED + $GUI_DISABLE)
		EndIf
		Local $bFinishTime = ConvertOCRTime("FinishTime", $g_aUpgradeDuration, False)
		$g_aiHeroUpgradeFinishDate[4] = _DateAdd('n', Ceiling($bFinishTime), _NowCalc())
		SetLog("Champion Upgrade Finishes @ " & $g_aiHeroUpgradeFinishDate[4], $COLOR_SUCCESS)
		$g_aiHeroNeededResource[4] = 0
		$g_aiCurrentLoot[$eLootDarkElixir] -= $bUpgradeCost
	ElseIf IsArray($YellowSearch) Then

		Local $bUpgradeCost = ($g_afChampionUpgCost[$g_iChampionLevel] * 1000 * (1 - Number($g_iBuilderBoostDiscount) / 100))
		SetLog("Upgrade cost " & _NumberFormat($bUpgradeCost) & " Dark Elixir", $COLOR_INFO)
		If _Sleep(1000) Then Return

		ClickP($YellowSearch, 1, 120)         ; Click upgrade buttton

		If _Sleep($DELAYUPGRADEHERO1) Then Return
		If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn2")
		If isGemOpen(True) Then         ; Redundant Safety Check if the use Gem window opens
			SetLog("Champion Upgrade Fail! Gem Window popped up!", $COLOR_ERROR)
			Return
		EndIf
		SetLog("Champion Upgrade complete", $COLOR_SUCCESS)
		GUICtrlSetState($g_hPicChampionGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicChampionRed, $GUI_SHOW)
		GUICtrlSetState($g_hPicChampionBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicChampionGreen, $GUI_HIDE)
		$g_iHeroUpgrading[4] = 1
		$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroChampion)
		If _Sleep($DELAYUPGRADEHERO2) Then Return         ; Wait for window to close
		$g_iNbrOfHeroesUpped += 1
		$g_iCostDElixirHero += $bUpgradeCost
		UpdateStats()
		If Not $g_bRepUpgradeChampionEnable Then
			$g_bUpgradeChampionEnable = False ; turn Off the Champions upgrade
			GUICtrlSetState($g_hChkUpgradeChampion, $GUI_UNCHECKED)
			_GUI_Value_STATE("HIDE", $groupChampionSleeping)
			For $i In $ahGroupChampionWait
				_GUICtrlSetTip($i, $TxtTip)
			Next
			GUICtrlSetState($g_hChkRepUpgradeChampion, $GUI_UNCHECKED + $GUI_DISABLE)
		EndIf
		Local $bFinishTime = ConvertOCRTime("FinishTime", $g_aUpgradeDuration, False)
		$g_aiHeroUpgradeFinishDate[4] = _DateAdd('n', Ceiling($bFinishTime), _NowCalc())
		SetLog("Champion Upgrade Finishes @ " & $g_aiHeroUpgradeFinishDate[4], $COLOR_SUCCESS)
		$g_aiHeroNeededResource[4] = 0
		$g_aiCurrentLoot[$eLootDarkElixir] -= $bUpgradeCost
	Else
		SetLog("Champion Upgrade Fail! No DE!", $COLOR_ERROR)
		CloseWindow2(1)
		Return
	EndIf

EndFunc   ;==>ChampionUpgrade

Func ReservedBuildersForHeroes($aSetLog = True)
	Local $iUsedBuildersForHeroes = Number(BitAND($g_iHeroUpgradingBit, $eHeroKing) = $eHeroKing ? 1 : 0) + Number(BitAND($g_iHeroUpgradingBit, $eHeroQueen) = $eHeroQueen ? 1 : 0) + _
			Number(BitAND($g_iHeroUpgradingBit, $eHeroPrince) = $eHeroPrince ? 1 : 0) + Number(BitAND($g_iHeroUpgradingBit, $eHeroWarden) = $eHeroWarden ? 1 : 0) + Number(BitAND($g_iHeroUpgradingBit, $eHeroChampion) = $eHeroChampion ? 1 : 0)
	If $aSetLog Then SetLog($iUsedBuildersForHeroes & " builder" & ($iUsedBuildersForHeroes > 1 ? "s are" : " is") & " upgrading your heroes.", $COLOR_INFO)

	Local $iFreeBuildersReservedForHeroes = _Max(Number($g_iHeroReservedBuilder) - $iUsedBuildersForHeroes, 0)
	If $aSetLog Then SetLog($iFreeBuildersReservedForHeroes & " free builder" & ($iFreeBuildersReservedForHeroes > 1 ? "s are" : " is") & " reserved for heroes.", $COLOR_INFO)

	If $g_bDebugSetLog Then SetLog("HeroBuilders R|Rn|W|F: " & $g_iHeroReservedBuilder & "|" & Number($g_iHeroReservedBuilder) & "|" & $iUsedBuildersForHeroes & "|" & $iFreeBuildersReservedForHeroes, $COLOR_DEBUG)

	Return $iFreeBuildersReservedForHeroes
EndFunc   ;==>ReservedBuildersForHeroes

Func TakeWardenValues()
	If $g_bUpgradeWardenEnable And $g_bAutoUpgradeWallsEnable Then
		Local $bWardenCheck = False
		If Not _DateIsValid($g_aiHeroUpgradeFinishDate[3]) Then
			If $g_aiHeroNeededResource[3] = 0 Then $bWardenCheck = True
		ElseIf _DateIsValid($g_aiHeroUpgradeFinishDate[3]) Then
			If _DateDiff('n', _NowCalc(), $g_aiHeroUpgradeFinishDate[3]) < 0 Then $bWardenCheck = True
		EndIf
		If $bWardenCheck Then
			$bCheckValuesForWarden = True
			Return True
		EndIf
	EndIf
	Return False
EndFunc   ;==>TakeWardenValues
