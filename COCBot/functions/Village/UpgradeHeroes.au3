; #FUNCTION# ====================================================================================================================
; Name ..........: Upgrade Heroes Continuously
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: z0mbie (2015)
; Modified ......: Master1st (09-2015), ProMac (10-2015), MonkeyHunter (06-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func UpgradeHeroes()

	If Not $g_bUpgradeKingEnable And Not $g_bUpgradeQueenEnable And Not $g_bUpgradeWardenEnable Then Return

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
	EndIf

	;Check if Auto Lab Upgrade is enabled and if a Dark Troop is selected for Upgrade. If yes, it has priority!
	If $g_bAutoLabUpgradeEnable And $g_iCmbLaboratory >= 19 Then
		SetLog("Laboratory needs DE to Upgrade :  " & $g_avLabTroops[$g_iCmbLaboratory][3])
		SetLog("Skipping the Heroes Upgrade!")
		Return
	EndIf

	SetLog("Upgrading Heroes", $COLOR_INFO)

	; ### Archer Queen ###
	If $g_bUpgradeQueenEnable Then
		If Not getBuilderCount() Then Return ; update builder data, return if problem
		If _Sleep($DELAYRESPOND) Then Return
		If $g_iFreeBuilderCount < 1 + ($g_bUpgradeWallSaveBuilder ? 1 : 0) Then
			SetLog("Not enough Builders available to upgrade the Archer Queen")
			Return
		EndIf
		QueenUpgrade()

		If _Sleep($DELAYUPGRADEHERO1) Then Return
	EndIf

	; ### Barbarian King ###
	If $g_bUpgradeKingEnable Then
		If Not getBuilderCount() Then Return ; update builder data, return if problem
		If _Sleep($DELAYRESPOND) Then Return
		If $g_iFreeBuilderCount < 1 + ($g_bUpgradeWallSaveBuilder ? 1 : 0) Then
			SetLog("Not enough Builders available to upgrade the Barbarian King")
			Return
		EndIf
		KingUpgrade()

		If _Sleep($DELAYUPGRADEHERO1) Then Return
	EndIf

	; ### Grand Warden ###
	If $g_bUpgradeWardenEnable Then
		If Not getBuilderCount() Then Return ; update builder data, return if problem
		If _Sleep($DELAYRESPOND) Then Return
		If $g_iFreeBuilderCount < 1 + ($g_bUpgradeWallSaveBuilder ? 1 : 0) Then
			SetLog("Not enough Builders available to upgrade the Grand Warden")
			Return
		EndIf
		WardenUpgrade()
	EndIf

EndFunc   ;==>UpgradeHeroes

Func QueenUpgrade()

	If Not $g_bUpgradeQueenEnable Then Return
	Local $aHeroLevel = 0

	SetLog("Upgrade Queen")
	ClickP($aTopLeftClient, 1, 0, "#0166") ; Click away
	If _Sleep($DELAYUPGRADEHERO2) Then Return
	BuildingClickP($g_aiQueenAltarPos) ;Click Queen Altar
	If _Sleep($DELAYUPGRADEHERO2) Then Return

	;Get Queen info and Level
	Local $sInfo = BuildingInfo(242, 520 + $g_iBottomOffsetY) ; 860x780
	If @error Then SetError(0, 0, 0)
	Local $CountGetInfo = 0
	While IsArray($sInfo) = False
		$sInfo = BuildingInfo(242, 520 + $g_iBottomOffsetY) ; 860x780
		If @error Then SetError(0, 0, 0)
		Sleep(100)
		$CountGetInfo += 1
		If $CountGetInfo >= 50 Then Return
	WEnd
	If $g_bDebugSetlog Then SetDebugLog(_ArrayToString($sInfo, " "), $COLOR_DEBUG)
	If @error Then Return SetError(0, 0, 0)


	If $sInfo[0] > 1 Or $sInfo[0] = "" Then
		If StringInStr($sInfo[1], "Quee") = 0 Then
			SetLog("Bad Archer Queen location", $COLOR_ACTION)
			Return
		Else
			If $sInfo[2] <> "" Then
				$aHeroLevel = Number($sInfo[2]) ; grab hero level from building info array
				SetLog("Your Archer Queen level read as: " & $aHeroLevel, $COLOR_SUCCESS)
				If $aHeroLevel = $g_iMaxQueenLevel Then ; max hero
					SetLog("Your Archer Queen is at max level, cannot upgrade anymore!", $COLOR_INFO)
					$g_bUpgradeQueenEnable = False ; turn Off the Queens upgrade
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
		If $g_bDebugSetlog Then SetDebugLog("Updating village values [D]: " & $g_aiCurrentLoot[$eLootDarkElixir], $COLOR_DEBUG)
	Else
		If $g_bDebugSetlog Then SetDebugLog("getResourcesMainScreen didn't get the DE value", $COLOR_DEBUG)
	EndIf

	If $g_aiCurrentLoot[$eLootDarkElixir] < ($g_afQueenUpgCost[$aHeroLevel] * 1000) + $g_iUpgradeMinDark Then
		SetLog("Insufficient DE for Upg Queen, requires: " & ($g_afQueenUpgCost[$aHeroLevel] * 1000) & " + " & $g_iUpgradeMinDark, $COLOR_INFO)
		Return
	EndIf

	Local $offColors[3][3] = [[0xE07B50, 41, 23], [0x282020, 72, 0], [0xF5F9F2, 79, 0]] ; 2nd pixel brown hammer, 3rd pixel black, 4th pixel edge of button
	Local $ButtonPixel = _MultiPixelSearch(240, 563 + $g_iBottomOffsetY, 670, 620 + $g_iBottomOffsetY, 1, 1, Hex(0xF5F6F2, 6), $offColors, 30) ; first gray/white pixel of button

	If IsArray($ButtonPixel) Then
		If $g_bDebugSetlog And IsArray($ButtonPixel) Then
			SetLog("ButtonPixel = " & $ButtonPixel[0] & ", " & $ButtonPixel[1], $COLOR_DEBUG) ;Debug
			SetLog("Color #1: " & _GetPixelColor($ButtonPixel[0], $ButtonPixel[1], True) & ", #2: " & _GetPixelColor($ButtonPixel[0] + 41, $ButtonPixel[1] + 23, True) & ", #3: " & _GetPixelColor($ButtonPixel[0] + 72, $ButtonPixel[1], True) & ", #4: " & _GetPixelColor($ButtonPixel[0] + 79, $ButtonPixel[1], True), $COLOR_DEBUG)
		EndIf
		If _Sleep($DELAYUPGRADEHERO2) Then Return
		Click($ButtonPixel[0] + 20, $ButtonPixel[1] + 20, 1, 0, "#0305") ; Click Upgrade Button
		If _Sleep($DELAYUPGRADEHERO3) Then Return ; Wait for window to open
		If $g_bDebugImageSave Then DebugImageSave("UpgradeDarkBtn1")
		If _ColorCheck(_GetPixelColor(721, 118 + $g_iMidOffsetY, True), Hex(0xE00408, 6), 20) Then ; Check if the Hero Upgrade window is open
			If _ColorCheck(_GetPixelColor(691, 523 + $g_iMidOffsetY, True), Hex(0xE70A12, 6), 20) And _ColorCheck(_GetPixelColor(691, 527 + $g_iMidOffsetY), Hex(0xE70A12, 6), 20) And _
					_ColorCheck(_GetPixelColor(691, 531 + $g_iMidOffsetY, True), Hex(0xE70A12, 6), 20) Then ; Check for Red Zero = means not enough loot!
				SetLog("Queen Upgrade Fail! No DE!", $COLOR_ERROR)
				ClickP($aAway, 2, 0, "#0306") ;Click Away to close window
				Return
			Else
				Click(665, 515 + $g_iMidOffsetY, 1, 0, "#0307") ; Click upgrade buttton
				ClickP($aAway, 1, 0, "#0308") ;Click Away to close windows
				If _Sleep($DELAYUPGRADEHERO1) Then Return
				If $g_bDebugImageSave Then DebugImageSave("UpgradeDarkBtn2")
				If _ColorCheck(_GetPixelColor(573, 256 + $g_iMidOffsetY, True), Hex(0xDB0408, 6), 20) Then ; Redundant Safety Check if the use Gem window opens
					SetLog("Queen Upgrade Fail! No DE!", $COLOR_ERROR)
					ClickP($aAway, 2, 0, "#0309") ;Click Away to close windows
					Return
				EndIf
				SetLog("Queen Upgrade complete", $COLOR_SUCCESS)
				If _Sleep($DELAYUPGRADEHERO2) Then Return ; Wait for window to close
				$g_iNbrOfHeroesUpped += 1
				$g_iCostDElixirHero += $g_afQueenUpgCost[$aHeroLevel - 1] * 1000
				UpdateStats()
			EndIf
		Else
			SetLog("Upgrade Queen window open fail", $COLOR_ERROR)
		EndIf
	Else
		SetLog("Upgrade Queen error finding button", $COLOR_ERROR)
	EndIf

	ClickP($aAway, 2, 0, "#0312") ;Click Away to close windows

EndFunc   ;==>QueenUpgrade

Func KingUpgrade()
	;upgradeking
	If Not $g_bUpgradeKingEnable Then Return
	Local $aHeroLevel = 0

	SetLog("Upgrade King")
	ClickP($aTopLeftClient, 1, 0, "#0166") ; Click away
	If _Sleep($DELAYUPGRADEHERO2) Then Return
	BuildingClickP($g_aiKingAltarPos) ;Click King Altar
	If _Sleep($DELAYUPGRADEHERO2) Then Return

	;Get King info
	Local $sInfo = BuildingInfo(242, 520 + $g_iBottomOffsetY) ; 860x780
	If @error Then SetError(0, 0, 0)
	Local $CountGetInfo = 0
	While IsArray($sInfo) = False
		$sInfo = BuildingInfo(242, 520 + $g_iBottomOffsetY) ; 860x780
		If @error Then SetError(0, 0, 0)
		If _Sleep(100) Then Return
		$CountGetInfo += 1
		If $CountGetInfo >= 50 Then Return
	WEnd
	If $g_bDebugSetlog Then SetDebugLog(_ArrayToString($sInfo, " "), $COLOR_DEBUG)
	If @error Then Return SetError(0, 0, 0)

	If $sInfo[0] > 1 Or $sInfo[0] = "" Then
		If StringInStr($sInfo[1], "Barbarian") = 0 Then
			SetLog("Bad Barbarian King location", $COLOR_ACTION)
			Return
		Else
			If $sInfo[2] <> "" Then
				$aHeroLevel = Number($sInfo[2]) ; grab hero level from building info array
				SetLog("Your King Level read as: " & $aHeroLevel, $COLOR_SUCCESS)
				If $aHeroLevel = $g_iMaxKingLevel Then ; max hero
					SetLog("Your Babarian King is at max level, cannot upgrade anymore!", $COLOR_INFO)
					$g_bUpgradeKingEnable = False ; Turn Off the King's Upgrade
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
		If $g_bDebugSetlog Then SetDebugLog("Updating village values [D]: " & $g_aiCurrentLoot[$eLootDarkElixir], $COLOR_DEBUG)
	Else
		If $g_bDebugSetlog Then SetDebugLog("getResourcesMainScreen didn't get the DE value", $COLOR_DEBUG)
	EndIf
	If _Sleep(100) Then Return

	If $g_aiCurrentLoot[$eLootDarkElixir] < ($g_afKingUpgCost[$aHeroLevel] * 1000) + $g_iUpgradeMinDark Then
		SetLog("Insufficient DE for Upg King, requires: " & ($g_afKingUpgCost[$aHeroLevel] * 1000) & " + " & $g_iUpgradeMinDark, $COLOR_INFO)
		Return
	EndIf

	Local $offColors[3][3] = [[0xE07B50, 41, 23], [0x282020, 72, 0], [0xF4F5F2, 79, 0]] ; 2nd pixel brown hammer, 3rd pixel black, 4th pixel edge of button
	Local $ButtonPixel = _MultiPixelSearch(240, 563 + $g_iBottomOffsetY, 670, 620 + $g_iBottomOffsetY, 1, 1, Hex(0xF5F6F2, 6), $offColors, 30) ; first gray/white pixel of button

	If IsArray($ButtonPixel) Then
		If $g_bDebugSetlog And IsArray($ButtonPixel) Then
			SetLog("ButtonPixel = " & $ButtonPixel[0] & ", " & $ButtonPixel[1], $COLOR_DEBUG) ;Debug
			SetLog("Color #1: " & _GetPixelColor($ButtonPixel[0], $ButtonPixel[1], True) & ", #2: " & _GetPixelColor($ButtonPixel[0] + 41, $ButtonPixel[1] + 23, True) & ", #3: " & _GetPixelColor($ButtonPixel[0] + 72, $ButtonPixel[1], True) & ", #4: " & _GetPixelColor($ButtonPixel[0] + 79, $ButtonPixel[1], True), $COLOR_DEBUG)
		EndIf
		If _Sleep($DELAYUPGRADEHERO2) Then Return
		Click($ButtonPixel[0] + 20, $ButtonPixel[1] + 20, 1, 0, "#0305") ; Click Upgrade Button
		If _Sleep($DELAYUPGRADEHERO3) Then Return ; Wait for window to open
		If $g_bDebugImageSave Then DebugImageSave("UpgradeDarkBtn1")
		If _ColorCheck(_GetPixelColor(715, 120 + $g_iMidOffsetY, True), Hex(0xE01C20, 6), 20) Then ; Check if the Hero Upgrade window is open
			If _ColorCheck(_GetPixelColor(691, 523 + $g_iMidOffsetY, True), Hex(0xE70A12, 6), 20) And _ColorCheck(_GetPixelColor(691, 527 + $g_iMidOffsetY), Hex(0xE70A12, 6), 20) And _
					_ColorCheck(_GetPixelColor(691, 531 + $g_iMidOffsetY, True), Hex(0xE70A12, 6), 20) Then ; Check for Red Zero = means not enough loot!
				SetLog("King Upgrade Fail! No DE!", $COLOR_ERROR)
				ClickP($aAway, 2, 0, "#0306") ;Click Away to close window
				Return
			Else
				Click(660, 515 + $g_iMidOffsetY, 1, 0, "#0307") ; Click upgrade buttton
				ClickP($aAway, 1, 0, "#0308") ;Click Away to close windows
				If _Sleep($DELAYUPGRADEHERO1) Then Return
				If $g_bDebugImageSave Then DebugImageSave("UpgradeDarkBtn2")
				If _ColorCheck(_GetPixelColor(573, 256 + $g_iMidOffsetY, True), Hex(0xDB0408, 6), 20) Then ; Redundant Safety Check if the use Gem window opens
					SetLog("King Upgrade Fail! No DE!", $COLOR_ERROR)
					ClickP($aAway, 2, 0, "#0309") ;Click Away to close windows
					Return
				EndIf
				SetLog("King Upgrade complete", $COLOR_SUCCESS)
				If _Sleep($DELAYUPGRADEHERO2) Then Return ; Wait for window to close
				$g_iNbrOfHeroesUpped += 1
				$g_iCostDElixirHero += $g_afKingUpgCost[$aHeroLevel - 1] * 1000
				UpdateStats()
			EndIf
		Else
			SetLog("Upgrade King window open fail", $COLOR_ERROR)
		EndIf
	Else
		SetLog("Upgrade King error finding button", $COLOR_ERROR)
	EndIf

	ClickP($aAway, 2, 0, "#0312") ;Click Away to close windows

EndFunc   ;==>KingUpgrade

Func WardenUpgrade()

	If Not $g_bUpgradeWardenEnable Then Return

	If Number($g_iTownHallLevel) <= 10 Then
		SetLog("Must have TH 11 for Grand Warden upgrade", $COLOR_ERROR)
		Return
	EndIf

	SetLog("Upgrade Grand Warden")
	ClickP($aTopLeftClient, 1, 0, "#0166") ; Click away
	If _Sleep($DELAYUPGRADEHERO2) Then Return
	ClickP($g_aiWardenAltarPos, 1, 0, "#8888") ;Click Warden Altar
	If _Sleep($DELAYUPGRADEHERO2) Then Return

	;Get Warden info
	Local $sInfo = BuildingInfo(242, 520 + $g_iBottomOffsetY) ; 860x780
	If @error Then SetError(0, 0, 0)
	Local $CountGetInfo = 0
	While IsArray($sInfo) = False
		$sInfo = BuildingInfo(242, 520 + $g_iBottomOffsetY) ; 860x780
		If @error Then SetError(0, 0, 0)
		If _Sleep(100) Then Return
		$CountGetInfo += 1
		If $CountGetInfo = 50 Then Return
	WEnd
	If $g_bDebugSetlog Then SetDebugLog(_ArrayToString($sInfo, " "))
	If @error Then Return SetError(0, 0, 0)

	If $sInfo[0] > 1 Or $sInfo[0] = "" Then
		If StringInStr($sInfo[1], "Grand") = 0 Then
			SetLog("Bad Warden location", $COLOR_ACTION)
			Return
		Else
			If $sInfo[2] <> "" Then
				$g_iWardenLevel = Number($sInfo[2]) ; grab hero level from building info array
				SetLog("Your Grand Warden Warden Level read as: " & $g_iWardenLevel, $COLOR_SUCCESS)
				If $g_iWardenLevel = $g_iMaxWardenLevel Then ; max hero
					SetLog("Your Grand Warden is at max level, cannot upgrade anymore!", $COLOR_INFO)
					$g_bUpgradeWardenEnable = False ; turn OFF the Wardn's Upgrade
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
		If $g_bDebugSetlog Then SetDebugLog("Updating village values [E]: " & $g_aiCurrentLoot[$eLootElixir], $COLOR_DEBUG)
	Else
		$g_aiCurrentLoot[$eLootElixir] = getResourcesMainScreen(710, 74)
	EndIf
	If _Sleep(100) Then Return

	If $g_aiCurrentLoot[$eLootElixir] < ($g_afWardenUpgCost[$g_iWardenLevel] * 1000000) + $g_iUpgradeMinElixir Then
		SetLog("Insufficient Elixir for Warden Upgrade, requires: " & ($g_afWardenUpgCost[$g_iWardenLevel] * 1000000) & " + " & $g_iUpgradeMinElixir, $COLOR_INFO)
		Return
	EndIf
	If _Sleep($DELAYUPGRADEHERO2) Then Return
	Local $offColors[3][3] = [[0xBC5B31, 38, 32], [0xF84CF9, 72, 0], [0xF5F9F2, 79, 0]] ; 2nd pixel brown hammer, 3rd pixel pink, 4th pixel edge of button
	Local $ButtonPixel = _MultiPixelSearch(240, 563 + $g_iBottomOffsetY, 670, 620 + $g_iBottomOffsetY, 1, 1, Hex(0xF4F7F2, 6), $offColors, 30) ; first gray/white pixel of button
	If IsArray($ButtonPixel) Then
		If $g_bDebugSetlog And IsArray($ButtonPixel) Then
			SetLog("ButtonPixel = " & $ButtonPixel[0] & ", " & $ButtonPixel[1], $COLOR_DEBUG) ;Debug
			SetLog("Color #1: " & _GetPixelColor($ButtonPixel[0], $ButtonPixel[1], True) & ", #2: " & _GetPixelColor($ButtonPixel[0] + 41, $ButtonPixel[1] + 23, True) & ", #3: " & _GetPixelColor($ButtonPixel[0] + 72, $ButtonPixel[1], True) & ", #4: " & _GetPixelColor($ButtonPixel[0] + 79, $ButtonPixel[1], True), $COLOR_DEBUG)
		EndIf
		If _Sleep($DELAYUPGRADEHERO2) Then Return
		Click($ButtonPixel[0] + 20, $ButtonPixel[1] + 20, 1, 0, "#0305") ; Click Upgrade Button
		If _Sleep($DELAYUPGRADEHERO3) Then Return ; Wait for window to open
		If $g_bDebugSetlog Then DebugImageSave("UpgradeElixirBtn1")
		If $g_bDebugSetlog Then SetDebugLog("pixel: " & _GetPixelColor(718, 120 + $g_iMidOffsetY, True) & " expected " & Hex(0xDD0408, 6) & " result: " & _ColorCheck(_GetPixelColor(718, 120 + $g_iMidOffsetY, True), Hex(0xDD0408, 6), 20), $COLOR_DEBUG)
		If _ColorCheck(_GetPixelColor(718, 120 + $g_iMidOffsetY, True), Hex(0xDD0408, 6), 20) Then ; Check if the Hero Upgrade window is open
			If $g_bDebugSetlog Then SetDebugLog("pixel1: " & _GetPixelColor(692, 525 + $g_iMidOffsetY, True) & " expected " & Hex(0xFFFFFF, 6) & " result: " & (_ColorCheck(_GetPixelColor(692, 525 + $g_iMidOffsetY, True), Hex(0xFFFFFF, 6), 20)), $COLOR_DEBUG)
			If Not (_ColorCheck(_GetPixelColor(692, 525 + $g_iMidOffsetY, True), Hex(0xFFFFFF, 6), 20)) Then ; Check for Red Zero = means not enough loot!
				SetLog("Warden Upgrade Fail! No Elixir!", $COLOR_ERROR)
				ClickP($aAway, 1, 0, "#0306") ;Click Away to close window
				Return
			Else
				Click(660, 515 + $g_iMidOffsetY, 1, 0, "#0307") ; Click upgrade buttton
				ClickP($aAway, 1, 0, "#0308") ;Click Away to close windows
				If _Sleep($DELAYUPGRADEHERO1) Then Return
				If $g_bDebugSetlog Then DebugImageSave("UpgradeElixirBtn2")
				If _ColorCheck(_GetPixelColor(573, 256 + $g_iMidOffsetY, True), Hex(0xDB0408, 6), 20) Then ; Redundant Safety Check if the use Gem window opens
					SetLog("Warden Upgrade Fail! No Elixir!", $COLOR_ERROR)
					ClickP($aAway, 1, 0, "#0309") ;Click Away to close windows
					Return
				EndIf
				SetLog("Warden Upgrade Started", $COLOR_SUCCESS)
				If _Sleep($DELAYUPGRADEHERO2) Then Return ; Wait for window to close
				$g_iNbrOfHeroesUpped += 1
				$g_iCostElixirBuilding += $g_afWardenUpgCost[$g_iWardenLevel - 1] * 1000
				$g_iWardenLevel += 1
				UpdateStats()
			EndIf
		Else
			SetLog("Upgrade Warden window open fail", $COLOR_ERROR)
		EndIf
	Else
		SetLog("Upgrade Warden error finding button", $COLOR_ERROR)
	EndIf

	ClickP($aAway, 2, 0, "#0312") ;Click Away to close windows

EndFunc   ;==>WardenUpgrade
