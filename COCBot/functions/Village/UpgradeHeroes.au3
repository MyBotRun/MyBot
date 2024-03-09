; #FUNCTION# ====================================================================================================================
; Name ..........: Upgrade Heroes Continuously
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: z0mbie (2015)
; Modified ......: Master1st (09/2015), ProMac (10/2015), MonkeyHunter (06/2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func UpgradeHeroes()

	If Not $g_bUpgradeKingEnable And Not $g_bUpgradeQueenEnable And Not $g_bUpgradeWardenEnable And Not $g_bUpgradeChampionEnable Then Return
	If _Sleep(500) Then Return

	checkMainScreen(False)

	If $g_bRestart Then Return

	If $g_bUpgradeKingEnable Then
		If Not isInsideDiamond($g_aiKingAltarPos) Then LocateKingAltar()
		If $g_aiKingAltarPos[0] = -1 Or $g_aiKingAltarPos[1] = -1 Then LocateKingAltar()
		SaveConfig()
	EndIf

	If $g_bUpgradeQueenEnable Then
		If Not isInsideDiamond($g_aiQueenAltarPos) Then LocateQueenAltar()
		If $g_aiQueenAltarPos[0] = -1 Or $g_aiQueenAltarPos[1] = -1 Then LocateQueenAltar()
		SaveConfig()
	EndIf

	If $g_bUpgradeWardenEnable Then
		If Not isInsideDiamond($g_aiWardenAltarPos) Then LocateWardenAltar()
		If $g_aiWardenAltarPos[0] = -1 Or $g_aiWardenAltarPos[1] = -1 Then LocateWardenAltar()
		SaveConfig()
	EndIf

	If $g_bUpgradeChampionEnable Then
		If Not isInsideDiamond($g_aiChampionAltarPos) Then LocateChampionAltar()
		If $g_aiChampionAltarPos[0] = -1 Or $g_aiChampionAltarPos[1] = -1 Then LocateChampionAltar()
		SaveConfig()
	EndIf

	SetLog("Upgrading Heroes", $COLOR_INFO)

	;Check if Auto Lab Upgrade is enabled and if a Dark Troop/Spell is selected for Upgrade. If yes, it has priority!
	If $g_bAutoLabUpgradeEnable And $g_iLaboratoryDElixirCost > 0 Then
		SetLog("Laboratory needs DE to Upgrade:  " & $g_iLaboratoryDElixirCost)
		SetLog("Skipping the Queen and King Upgrade!")
	Else
		; ### Archer Queen ###
		If $g_bUpgradeQueenEnable And BitAND($g_iHeroUpgradingBit, $eHeroQueen) <> $eHeroQueen Then
			If Not getBuilderCount() Then Return ; update builder data, return if problem
			If _Sleep($DELAYRESPOND) Then Return
			If $g_iFreeBuilderCount < 1 + ($g_bAutoUpgradeWallsEnable And $g_bUpgradeWallSaveBuilder ? 1 : 0) Then
				SetLog("Not enough Builders available to upgrade the Archer Queen")
				Return
			EndIf
			QueenUpgrade()

			If _Sleep($DELAYUPGRADEHERO1) Then Return
		EndIf
		; ### Barbarian King ###
		If $g_bUpgradeKingEnable And BitAND($g_iHeroUpgradingBit, $eHeroKing) <> $eHeroKing Then
			If Not getBuilderCount() Then Return ; update builder data, return if problem
			If _Sleep($DELAYRESPOND) Then Return
			If $g_iFreeBuilderCount < 1 + ($g_bAutoUpgradeWallsEnable And $g_bUpgradeWallSaveBuilder ? 1 : 0) Then
				SetLog("Not enough Builders available to upgrade the Barbarian King")
				Return
			EndIf
			KingUpgrade()

			If _Sleep($DELAYUPGRADEHERO1) Then Return
		EndIf
		; ### Royal Champion ###
		If $g_bUpgradeChampionEnable And BitAND($g_iHeroUpgradingBit, $eHeroChampion) <> $eHeroChampion Then
			If Not getBuilderCount() Then Return ; update builder data, return if problem
			If _Sleep($DELAYRESPOND) Then Return
			If $g_iFreeBuilderCount < 1 + ($g_bAutoUpgradeWallsEnable And $g_bUpgradeWallSaveBuilder ? 1 : 0) Then
				SetLog("Not enough Builders available to upgrade the Royal Champion")
				Return
			EndIf
			ChampionUpgrade()

			If _Sleep($DELAYUPGRADEHERO1) Then Return
		EndIf
	EndIf

	; ### Grand Warden ###
	;Check if Auto Lab Upgrade is enabled and if a Elixir Troop/Spell is selected for Upgrade. If yes, it has priority!
	If $g_bAutoLabUpgradeEnable And $g_iLaboratoryElixirCost > 0 Then
		SetLog("Laboratory needs Elixir to Upgrade:  " & $g_iLaboratoryElixirCost)
		SetLog("Skipping the Warden Upgrade!")
	ElseIf $g_bUpgradeWardenEnable And BitAND($g_iHeroUpgradingBit, $eHeroWarden) <> $eHeroWarden Then
		If Not getBuilderCount() Then Return ; update builder data, return if problem
		If _Sleep($DELAYRESPOND) Then Return
		If $g_iFreeBuilderCount < 1 + ($g_bAutoUpgradeWallsEnable And $g_bUpgradeWallSaveBuilder ? 1 : 0) Then
			SetLog("Not enough Builders available to upgrade the Grand Warden")
			Return
		EndIf
		WardenUpgrade()
	EndIf
EndFunc   ;==>UpgradeHeroes

Func QueenUpgrade()

	If Not $g_bUpgradeQueenEnable Then Return

	SetLog("Upgrade Queen")
	ClickAway()
	If _Sleep($DELAYUPGRADEHERO2) Then Return
	BuildingClickP($g_aiQueenAltarPos) ;Click Queen Altar
	If _Sleep($DELAYUPGRADEHERO2) Then Return

	;Get Queen info and Level
	Local $sInfo = BuildingInfo(242, 468 + $g_iBottomOffsetY) ; 860x780
	If @error Then SetError(0, 0, 0)
	Local $CountGetInfo = 0
	While IsArray($sInfo) = False
		$sInfo = BuildingInfo(242, 468 + $g_iBottomOffsetY) ; 860x780
		If @error Then SetError(0, 0, 0)
		Sleep(100)
		$CountGetInfo += 1
		If $CountGetInfo >= 50 Then Return
	WEnd
	SetDebugLog(_ArrayToString($sInfo, " "), $COLOR_DEBUG)
	If @error Then Return SetError(0, 0, 0)


	If $sInfo[0] > 1 Or $sInfo[0] = "" Then
		If StringInStr($sInfo[1], "Quee") = 0 Then
			SetLog("Bad Archer Queen location", $COLOR_ACTION)
			Return
		Else
			If $sInfo[2] <> "" Then
				$g_iQueenLevel = Number($sInfo[2]) ; grab hero level from building info array
				SetLog("Your Archer Queen Level read as: " & $g_iQueenLevel, $COLOR_SUCCESS)
				If $g_iQueenLevel = $g_iMaxQueenLevel Then ; max hero
					SetLog("Your Archer Queen is at max level, cannot upgrade anymore!", $COLOR_INFO)
					$g_bUpgradeQueenEnable = False ; turn Off the Queens upgrade
					GUICtrlSetState($g_hChkUpgradeQueen, $GUI_UNCHECKED)
					chkUpgradeQueen()
					ReducecmbHeroReservedBuilder()
					ClickAway()
					Return
				EndIf
			Else
				SetLog("Your Queen Level was not found!", $COLOR_INFO)
				Return
			EndIf
		EndIf
	Else
		SetLog("Bad Queen OCR", $COLOR_ERROR)
		Return
	EndIf

	If _Sleep($DELAYUPGRADEHERO1) Then Return

	;##### Get updated village elixir and dark elixir values
	If _CheckPixel($aVillageHasDarkElixir, $g_bCapturePixel) Then ; check if the village have a Dark Elixir Storage
		$g_aiCurrentLoot[$eLootDarkElixir] = Number(getResourcesMainScreen(728, 123))
		SetDebugLog("Updating village values [D]: " & $g_aiCurrentLoot[$eLootDarkElixir], $COLOR_DEBUG)
	Else
		SetDebugLog("getResourcesMainScreen didn't get the DE value", $COLOR_DEBUG)
	EndIf

	If $g_aiCurrentLoot[$eLootDarkElixir] < ($g_afQueenUpgCost[$g_iQueenLevel] * 1000) * (1 - Number($g_iBuilderBoostDiscount) / 100) + $g_iUpgradeMinDark Then
		SetLog("Insufficient DE for Upg Queen, requires: " & ($g_afQueenUpgCost[$g_iQueenLevel] * 1000) * (1 - Number($g_iBuilderBoostDiscount) / 100) & " + " & $g_iUpgradeMinDark, $COLOR_INFO)
		Return
	EndIf

	Local $aUpgradeButton = findButton("Upgrade", Default, 1, True)
	If IsArray($aUpgradeButton) And UBound($aUpgradeButton, 1) = 2 Then
		If _Sleep($DELAYUPGRADEHERO2) Then Return
		ClickP($aUpgradeButton)
		If _Sleep($DELAYUPGRADEHERO3) Then Return ; Wait for window to open
		If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn1")
		If _ColorCheck(_GetPixelColor(800, 88 + $g_iMidOffsetY, True), Hex(0xF38E8D, 6), 20) Then ; Check if the Hero Upgrade window is open

			Local $aWhiteZeros = decodeSingleCoord(findImage("UpgradeWhiteZero", $g_sImgUpgradeWhiteZero, GetDiamondFromRect("560,565,670,595"), 1, True, Default))
			Local $YellowSearch = _PixelSearch(610, 539 + $g_iMidOffsetY, 650, 543 + $g_iMidOffsetY, Hex(0xFFF10D, 6), 20)
			If (IsArray($aWhiteZeros) And UBound($aWhiteZeros, 1) = 2) Then
				ClickP($aWhiteZeros, 1, 0) ; Click upgrade buttton
				ClickAway()

				If _Sleep($DELAYUPGRADEHERO1) Then Return
				If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn2")
				If isGemOpen(True) Then ; Redundant Safety Check if the use Gem window opens
					SetLog("Queen Upgrade Fail! Gem Window popped up!", $COLOR_ERROR)
					ClickAway()
					Return
				EndIf
				SetLog("Queen Upgrade complete", $COLOR_SUCCESS)
				If _Sleep($DELAYUPGRADEHERO2) Then Return ; Wait for window to close
				$g_iNbrOfHeroesUpped += 1
				$g_iCostDElixirHero += 1000 * ($g_afQueenUpgCost[$g_iQueenLevel - 1] * 1000 * (1 - Number($g_iBuilderBoostDiscount) / 100))
				UpdateStats()
			ElseIf IsArray($YellowSearch) Then
				ClickP($YellowSearch, 1, 0) ; Click upgrade buttton
				ClickAway()

				If _Sleep($DELAYUPGRADEHERO1) Then Return
				If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn2")
				If isGemOpen(True) Then ; Redundant Safety Check if the use Gem window opens
					SetLog("Queen Upgrade Fail! Gem Window popped up!", $COLOR_ERROR)
					ClickAway()
					Return
				EndIf
				SetLog("Queen Upgrade complete", $COLOR_SUCCESS)
				If _Sleep($DELAYUPGRADEHERO2) Then Return ; Wait for window to close
				$g_iNbrOfHeroesUpped += 1
				$g_iCostDElixirHero += 1000 * ($g_afQueenUpgCost[$g_iQueenLevel - 1] * 1000 * (1 - Number($g_iBuilderBoostDiscount) / 100))
				UpdateStats()
			Else
				SetLog("Queen Upgrade Fail! No DE!", $COLOR_ERROR)
				ClickAway()
				Return
			EndIf
		Else
			SetLog("Upgrade Queen window open fail", $COLOR_ERROR)
		EndIf
	Else
		SetLog("Upgrade Queen error finding button", $COLOR_ERROR)
	EndIf

	ClickAway()
EndFunc   ;==>QueenUpgrade

Func KingUpgrade()
	;upgradeking
	If Not $g_bUpgradeKingEnable Then Return

	SetLog("Upgrade King")
	ClickAway()
	If _Sleep($DELAYUPGRADEHERO2) Then Return
	BuildingClickP($g_aiKingAltarPos) ;Click King Altar
	If _Sleep($DELAYUPGRADEHERO2) Then Return

	;Get King info
	Local $sInfo = BuildingInfo(242, 468 + $g_iBottomOffsetY) ; 860x780
	If @error Then SetError(0, 0, 0)
	Local $CountGetInfo = 0
	While IsArray($sInfo) = False
		$sInfo = BuildingInfo(242, 468 + $g_iBottomOffsetY) ; 860x780
		If @error Then SetError(0, 0, 0)
		If _Sleep(100) Then Return
		$CountGetInfo += 1
		If $CountGetInfo >= 50 Then Return
	WEnd
	SetDebugLog(_ArrayToString($sInfo, " "), $COLOR_DEBUG)
	If @error Then Return SetError(0, 0, 0)

	If $sInfo[0] > 1 Or $sInfo[0] = "" Then
		If StringInStr($sInfo[1], "Barbarian") = 0 Then
			SetLog("Bad Barbarian King location", $COLOR_ACTION)
			Return
		Else
			If $sInfo[2] <> "" Then
				$g_iKingLevel = Number($sInfo[2]) ; grab hero level from building info array
				SetLog("Your Babarian King Level read as: " & $g_iKingLevel, $COLOR_SUCCESS)
				If $g_iKingLevel = $g_iMaxKingLevel Then ; max hero
					SetLog("Your Babarian King is at max level, cannot upgrade anymore!", $COLOR_INFO)
					$g_bUpgradeKingEnable = False ; Turn Off the King's Upgrade
					GUICtrlSetState($g_hChkUpgradeKing, $GUI_UNCHECKED)
					chkUpgradeKing()
					ReducecmbHeroReservedBuilder()
					ClickAway()
					Return
				EndIf
			Else
				SetLog("Your Barbarian King Level was not found!", $COLOR_INFO)
				Return
			EndIf
		EndIf
	Else
		SetLog("Bad King OCR", $COLOR_ERROR)
		Return
	EndIf

	If _Sleep($DELAYUPGRADEHERO1) Then Return

	;##### Get updated village elixir and dark elixir values
	If _CheckPixel($aVillageHasDarkElixir, $g_bCapturePixel) Then ; check if the village have a Dark Elixir Storage
		$g_aiCurrentLoot[$eLootDarkElixir] = Number(getResourcesMainScreen(728, 123))
		SetDebugLog("Updating village values [D]: " & $g_aiCurrentLoot[$eLootDarkElixir], $COLOR_DEBUG)
	Else
		SetDebugLog("getResourcesMainScreen didn't get the DE value", $COLOR_DEBUG)
	EndIf
	If _Sleep(100) Then Return

	If $g_aiCurrentLoot[$eLootDarkElixir] < ($g_afKingUpgCost[$g_iKingLevel] * 1000) * (1 - Number($g_iBuilderBoostDiscount) / 100) + $g_iUpgradeMinDark Then
		SetLog("Insufficient DE for Upg King, requires: " & ($g_afKingUpgCost[$g_iKingLevel] * 1000) * (1 - Number($g_iBuilderBoostDiscount) / 100) & " + " & $g_iUpgradeMinDark, $COLOR_INFO)
		Return
	EndIf

	Local $aUpgradeButton = findButton("Upgrade", Default, 1, True)
	If IsArray($aUpgradeButton) And UBound($aUpgradeButton, 1) = 2 Then
		If _Sleep($DELAYUPGRADEHERO2) Then Return
		ClickP($aUpgradeButton)
		If _Sleep($DELAYUPGRADEHERO3) Then Return ; Wait for window to open
		If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn1")

		If _ColorCheck(_GetPixelColor(800, 88 + $g_iMidOffsetY, True), Hex(0xF38E8D, 6), 20) Then ; Check if the Hero Upgrade window is open
			Local $aWhiteZeros = decodeSingleCoord(findImage("UpgradeWhiteZero", $g_sImgUpgradeWhiteZero, GetDiamondFromRect("560,565,670,595"), 1, True, Default))
			Local $YellowSearch = _PixelSearch(610, 539 + $g_iMidOffsetY, 650, 543 + $g_iMidOffsetY, Hex(0xFFF10D, 6), 20)
			If (IsArray($aWhiteZeros) And UBound($aWhiteZeros, 1) = 2) Then
				ClickP($aWhiteZeros, 1, 0) ; Click upgrade buttton
				ClickAway()

				If _Sleep($DELAYUPGRADEHERO1) Then Return
				If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn2")
				If isGemOpen(True) Then ; Redundant Safety Check if the use Gem window opens
					SetLog("King Upgrade Fail! Gem Window popped up!", $COLOR_ERROR)
					ClickAway()
					Return
				EndIf
				SetLog("King Upgrade complete", $COLOR_SUCCESS)
				If _Sleep($DELAYUPGRADEHERO2) Then Return ; Wait for window to close
				$g_iNbrOfHeroesUpped += 1
				$g_iCostDElixirHero += 1000 * ($g_afKingUpgCost[$g_iKingLevel - 1] * 1000 * (1 - Number($g_iBuilderBoostDiscount) / 100))
				UpdateStats()
			ElseIf IsArray($YellowSearch) Then
				ClickP($YellowSearch, 1, 0) ; Click upgrade buttton
				ClickAway()

				If _Sleep($DELAYUPGRADEHERO1) Then Return
				If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn2")
				If isGemOpen(True) Then ; Redundant Safety Check if the use Gem window opens
					SetLog("King Upgrade Fail! Gem Window popped up!", $COLOR_ERROR)
					ClickAway()
					Return
				EndIf
				SetLog("King Upgrade complete", $COLOR_SUCCESS)
				If _Sleep($DELAYUPGRADEHERO2) Then Return ; Wait for window to close
				$g_iNbrOfHeroesUpped += 1
				$g_iCostDElixirHero += 1000 * ($g_afKingUpgCost[$g_iKingLevel - 1] * 1000 * (1 - Number($g_iBuilderBoostDiscount) / 100))
				UpdateStats()
			Else
				SetLog("King Upgrade Fail! No DE!", $COLOR_ERROR)
				ClickAway()
				Return
			EndIf

		Else
			SetLog("Upgrade King window open fail", $COLOR_ERROR)
		EndIf
	Else
		SetLog("Upgrade King error finding button", $COLOR_ERROR)
	EndIf

	ClickAway()
EndFunc   ;==>KingUpgrade

Func WardenUpgrade()
	If Not $g_bUpgradeWardenEnable Then Return

	If Number($g_iTownHallLevel) <= 10 Then
		SetLog("Must have atleast Townhall 11 for Grand Warden Upgrade", $COLOR_ERROR)
		Return
	EndIf

	SetLog("Upgrade Grand Warden")
	ClickAway()

	If _Sleep($DELAYUPGRADEHERO2) Then Return

	ClickP($g_aiWardenAltarPos, 1, 0, "#8888") ;Click Warden Altar

	If _Sleep($DELAYUPGRADEHERO2) Then Return

	;Get Warden info
	Local $sInfo = BuildingInfo(242, 468 + $g_iBottomOffsetY) ; 860x780
	If @error Then SetError(0, 0, 0)
	Local $CountGetInfo = 0
	While IsArray($sInfo) = False
		$sInfo = BuildingInfo(242, 468 + $g_iBottomOffsetY) ; 860x780
		If @error Then SetError(0, 0, 0)
		If _Sleep(100) Then Return
		$CountGetInfo += 1
		If $CountGetInfo = 50 Then Return
	WEnd
	SetDebugLog(_ArrayToString($sInfo, " "))
	If @error Then Return SetError(0, 0, 0)

	If $sInfo[0] > 1 Or $sInfo[0] = "" Then
		If StringInStr($sInfo[1], "Grand") = 0 Then
			SetLog("Bad Warden location", $COLOR_ACTION)
			Return
		Else
			If $sInfo[2] <> "" Then
				$g_iWardenLevel = Number($sInfo[2]) ; grab hero level from building info array
				SetLog("Your Grand Warden Level read as: " & $g_iWardenLevel, $COLOR_SUCCESS)
				If $g_iWardenLevel = $g_iMaxWardenLevel Then ; max hero
					SetLog("Your Grand Warden is at max level, cannot upgrade anymore!", $COLOR_INFO)
					$g_bUpgradeWardenEnable = False ; turn OFF the Wardn's Upgrade
					GUICtrlSetState($g_hChkUpgradeWarden, $GUI_UNCHECKED)
					chkUpgradeWarden()
					ReducecmbHeroReservedBuilder()
					CloseWindow()
					Return
				EndIf
			Else
				SetLog("Your Grand Warden Level was not found!", $COLOR_INFO)
				Return
			EndIf
		EndIf
	Else
		SetLog("Bad Warden OCR", $COLOR_ERROR)
		Return
	EndIf

	If _Sleep($DELAYUPGRADEHERO1) Then Return

	;##### Get updated village elixir values
	If _CheckPixel($aVillageHasDarkElixir, $g_bCapturePixel) Then ; check if the village have a Dark Elixir Storage
		$g_aiCurrentLoot[$eLootElixir] = getResourcesMainScreen(705, 74)
		SetDebugLog("Updating village values [E]: " & $g_aiCurrentLoot[$eLootElixir], $COLOR_DEBUG)
	Else
		$g_aiCurrentLoot[$eLootElixir] = getResourcesMainScreen(710, 74)
	EndIf

	If _Sleep(100) Then Return

	If $g_aiCurrentLoot[$eLootElixir] < ($g_afWardenUpgCost[$g_iWardenLevel] * 1000000) * (1 - Number($g_iBuilderBoostDiscount) / 100) + $g_iUpgradeMinElixir Then
		SetLog("Insufficient Elixir for Warden Upgrade, requires: " & ($g_afWardenUpgCost[$g_iWardenLevel] * 1000000) * (1 - Number($g_iBuilderBoostDiscount) / 100) & " + " & $g_iUpgradeMinElixir, $COLOR_INFO)
		Return
	EndIf

	If _Sleep($DELAYUPGRADEHERO2) Then Return

	Local $aUpgradeButton = findButton("Upgrade", Default, 1, True)
	If IsArray($aUpgradeButton) And UBound($aUpgradeButton, 1) = 2 Then
		If _Sleep($DELAYUPGRADEHERO2) Then Return
		ClickP($aUpgradeButton)
		If _Sleep($DELAYUPGRADEHERO3) Then Return ; Wait for window to open

		If $g_bDebugSetlog Then SaveDebugImage("UpgradeElixirBtn1")

		If _ColorCheck(_GetPixelColor(800, 88 + $g_iMidOffsetY, True), Hex(0xF38E8D, 6), 20) Then ; Check if the Hero Upgrade window is open

			Local $aWhiteZeros = decodeSingleCoord(findImage("UpgradeWhiteZero", $g_sImgUpgradeWhiteZero, GetDiamondFromRect("560,565,670,595"), 1, True, Default))
			Local $YellowSearch = _PixelSearch(610, 539 + $g_iMidOffsetY, 650, 543 + $g_iMidOffsetY, Hex(0xFFF10D, 6), 20)
			If (IsArray($aWhiteZeros) And UBound($aWhiteZeros, 1) = 2) Then
				ClickP($aWhiteZeros, 1, 0) ; Click upgrade buttton
				ClickAway()

				If _Sleep($DELAYUPGRADEHERO1) Then Return

				If $g_bDebugSetlog Then SaveDebugImage("UpgradeElixirBtn2")
				If isGemOpen(True) Then ; Redundant Safety Check if the use Gem window opens
					SetLog("Warden Upgrade Fail! Gem Window popped up!", $COLOR_ERROR)
					ClickAway()
					Return
				EndIf

				SetLog("Warden Upgrade Started", $COLOR_SUCCESS)
				If _Sleep($DELAYUPGRADEHERO2) Then Return ; Wait for window to close
				$g_iNbrOfWardenUpped += 1
				$g_iCostElixirWarden += 1000 * ($g_afWardenUpgCost[$g_iWardenLevel - 1] * 1000 * (1 - Number($g_iBuilderBoostDiscount) / 100))
				$g_iWardenLevel += 1
				UpdateStats()
			ElseIf IsArray($YellowSearch) Then
				ClickP($YellowSearch, 1, 0) ; Click upgrade buttton
				ClickAway()

				If _Sleep($DELAYUPGRADEHERO1) Then Return
				If $g_bDebugSetlog Then SaveDebugImage("UpgradeElixirBtn2")
				If isGemOpen(True) Then ; Redundant Safety Check if the use Gem window opens
					SetLog("Warden Upgrade Fail! Gem Window popped up!", $COLOR_ERROR)
					ClickAway()
					Return
				EndIf

				SetLog("Warden Upgrade Started", $COLOR_SUCCESS)
				If _Sleep($DELAYUPGRADEHERO2) Then Return ; Wait for window to close
				$g_iNbrOfWardenUpped += 1
				$g_iCostElixirWarden += 1000 * ($g_afWardenUpgCost[$g_iWardenLevel - 1] * 1000 * (1 - Number($g_iBuilderBoostDiscount) / 100))
				$g_iWardenLevel += 1
				UpdateStats()
			Else
				SetLog("Warden Upgrade Fail! Not enough Elixir!", $COLOR_ERROR)
				ClickAway()
				Return
			EndIf
		Else
			SetLog("Upgrade Warden window open fail", $COLOR_ERROR)
		EndIf
	Else
		SetLog("Upgrade Warden error finding button", $COLOR_ERROR)
	EndIf

	ClickAway()
EndFunc   ;==>WardenUpgrade

Func ChampionUpgrade()

	If Not $g_bUpgradeChampionEnable Then Return

	SetLog("Upgrade Champion")
	ClickAway()
	If _Sleep($DELAYUPGRADEHERO2) Then Return
	BuildingClickP($g_aiChampionAltarPos) ;Click Champion Altar
	If _Sleep($DELAYUPGRADEHERO2) Then Return

	;Get Champion info and Level
	Local $sInfo = BuildingInfo(242, 468 + $g_iBottomOffsetY) ; 860x780
	If @error Then SetError(0, 0, 0)
	Local $CountGetInfo = 0
	While IsArray($sInfo) = False
		$sInfo = BuildingInfo(242, 468 + $g_iBottomOffsetY) ; 860x780
		If @error Then SetError(0, 0, 0)
		Sleep(100)
		$CountGetInfo += 1
		If $CountGetInfo >= 50 Then Return
	WEnd
	SetDebugLog(_ArrayToString($sInfo, " "), $COLOR_DEBUG)
	If @error Then Return SetError(0, 0, 0)


	If $sInfo[0] > 1 Or $sInfo[0] = "" Then
		If StringInStr($sInfo[1], "Champ") = 0 Then
			SetLog("Bad Royal Champion location", $COLOR_ACTION)
			Return
		Else
			If $sInfo[2] <> "" Then
				$g_iChampionLevel = Number($sInfo[2]) ; grab hero level from building info array
				SetLog("Your Royal Champion Level read as: " & $g_iChampionLevel, $COLOR_SUCCESS)
				If $g_iChampionLevel = $g_iMaxChampionLevel Then ; max hero
					SetLog("Your Royal Champion is at max level, cannot upgrade anymore!", $COLOR_INFO)
					$g_bUpgradeChampionEnable = False ; turn Off the Champions upgrade
					GUICtrlSetState($g_hChkUpgradeChampion, $GUI_UNCHECKED)
					chkUpgradeChampion()
					ReducecmbHeroReservedBuilder()
					ClickAway()
					Return
				EndIf
			Else
				SetLog("Your Royal Champion Level was not found!", $COLOR_INFO)
				Return
			EndIf
		EndIf
	Else
		SetLog("Bad Royal Champion OCR", $COLOR_ERROR)
		Return
	EndIf

	If _Sleep($DELAYUPGRADEHERO1) Then Return

	;##### Get updated village elixir and dark elixir values
	If _CheckPixel($aVillageHasDarkElixir, $g_bCapturePixel) Then ; check if the village have a Dark Elixir Storage
		$g_aiCurrentLoot[$eLootDarkElixir] = Number(getResourcesMainScreen(728, 123))
		SetDebugLog("Updating village values [D]: " & $g_aiCurrentLoot[$eLootDarkElixir], $COLOR_DEBUG)
	Else
		SetDebugLog("getResourcesMainScreen didn't get the DE value", $COLOR_DEBUG)
	EndIf

	If $g_aiCurrentLoot[$eLootDarkElixir] < ($g_afChampionUpgCost[$g_iChampionLevel] * 1000) * (1 - Number($g_iBuilderBoostDiscount) / 100) + $g_iUpgradeMinDark Then
		SetLog("Insufficient DE for Upg Champion, requires: " & ($g_afChampionUpgCost[$g_iChampionLevel] * 1000) * (1 - Number($g_iBuilderBoostDiscount) / 100) & " + " & $g_iUpgradeMinDark, $COLOR_INFO)
		Return
	EndIf

	Local $aUpgradeButton = findButton("Upgrade", Default, 1, True)
	If IsArray($aUpgradeButton) And UBound($aUpgradeButton, 1) = 2 Then
		If _Sleep($DELAYUPGRADEHERO2) Then Return
		ClickP($aUpgradeButton)
		If _Sleep($DELAYUPGRADEHERO3) Then Return ; Wait for window to open
		If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn1")
		If _ColorCheck(_GetPixelColor(800, 88 + $g_iMidOffsetY, True), Hex(0xF38E8D, 6), 20) Then ; Check if the Hero Upgrade window is open

			Local $aWhiteZeros = decodeSingleCoord(findImage("UpgradeWhiteZero", $g_sImgUpgradeWhiteZero, GetDiamondFromRect("560,565,670,595"), 1, True, Default))
			Local $YellowSearch = _PixelSearch(610, 539 + $g_iMidOffsetY, 650, 543 + $g_iMidOffsetY, Hex(0xFFF10D, 6), 20)
			If (IsArray($aWhiteZeros) And UBound($aWhiteZeros, 1) = 2) Then
				ClickP($aWhiteZeros, 1, 0) ; Click upgrade buttton
				ClickAway()

				If _Sleep($DELAYUPGRADEHERO1) Then Return
				If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn2")
				If isGemOpen(True) Then ; Redundant Safety Check if the use Gem window opens
					SetLog("Champion Upgrade Fail! Gem Window popped up!", $COLOR_ERROR)
					ClickAway()
					Return
				EndIf
				SetLog("Champion Upgrade complete", $COLOR_SUCCESS)
				If _Sleep($DELAYUPGRADEHERO2) Then Return ; Wait for window to close
				$g_iNbrOfHeroesUpped += 1
				$g_iCostDElixirHero += 1000 * ($g_afChampionUpgCost[$g_iChampionLevel - 1] * 1000 * (1 - Number($g_iBuilderBoostDiscount) / 100))
				UpdateStats()
			ElseIf IsArray($YellowSearch) Then
				ClickP($YellowSearch, 1, 0) ; Click upgrade buttton
				ClickAway()

				If _Sleep($DELAYUPGRADEHERO1) Then Return
				If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn2")
				If isGemOpen(True) Then ; Redundant Safety Check if the use Gem window opens
					SetLog("Champion Upgrade Fail! Gem Window popped up!", $COLOR_ERROR)
					ClickAway()
					Return
				EndIf
				SetLog("Champion Upgrade complete", $COLOR_SUCCESS)
				If _Sleep($DELAYUPGRADEHERO2) Then Return ; Wait for window to close
				$g_iNbrOfHeroesUpped += 1
				$g_iCostDElixirHero += 1000 * ($g_afChampionUpgCost[$g_iChampionLevel - 1] * 1000 * (1 - Number($g_iBuilderBoostDiscount) / 100))
				UpdateStats()
			Else
				SetLog("Champion Upgrade Fail! No DE!", $COLOR_ERROR)
				ClickAway()
				Return
			EndIf
		Else
			SetLog("Upgrade Royal Champion window open fail", $COLOR_ERROR)
		EndIf
	Else
		SetLog("Upgrade Royal Champion error finding button", $COLOR_ERROR)
	EndIf

	ClickAway()
EndFunc   ;==>ChampionUpgrade

Func ReservedBuildersForHeroes($aSetLog = True)
	Local $iUsedBuildersForHeroes = Number(BitAND($g_iHeroUpgradingBit, $eHeroKing) = $eHeroKing ? 1 : 0) + Number(BitAND($g_iHeroUpgradingBit, $eHeroQueen) = $eHeroQueen ? 1 : 0) + Number(BitAND($g_iHeroUpgradingBit, $eHeroWarden) = $eHeroWarden ? 1 : 0) + Number(BitAND($g_iHeroUpgradingBit, $eHeroChampion) = $eHeroChampion ? 1 : 0)
	If $iUsedBuildersForHeroes = 1 Then
		If $aSetLog Then SetLog($iUsedBuildersForHeroes & " builder is upgrading your heroes.", $COLOR_INFO)
	Else
		If $aSetLog Then SetLog($iUsedBuildersForHeroes & " builders are upgrading your heroes.", $COLOR_INFO)
	EndIf

	Local $iFreeBuildersReservedForHeroes = _Max(Number($g_iHeroReservedBuilder) - $iUsedBuildersForHeroes, 0)
	If $iFreeBuildersReservedForHeroes = 1 Then
		If $aSetLog Then SetLog($iFreeBuildersReservedForHeroes & " free builder is reserved for heroes.", $COLOR_INFO)
	Else
		If $aSetLog Then SetLog($iFreeBuildersReservedForHeroes & " free builders are reserved for heroes.", $COLOR_INFO)
	EndIf

	If $g_bDebugSetlog Then SetLog("HeroBuilders R|Rn|W|F: " & $g_iHeroReservedBuilder & "|" & Number($g_iHeroReservedBuilder) & "|" & $iUsedBuildersForHeroes & "|" & $iFreeBuildersReservedForHeroes, $COLOR_DEBUG)

	Return $iFreeBuildersReservedForHeroes
EndFunc   ;==>ReservedBuildersForHeroes
