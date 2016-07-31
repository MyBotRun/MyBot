; #FUNCTION# ====================================================================================================================
; Name ..........: Upgrade Heroes Continuously
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: @z0mbie (2015)
; Modified ......: Master1st (Set2015) - ProMac (Oct2015), MonkeyHunter (6-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================


Func UpgradeHeroes()

	If $ichkUpgradeKing = 0 And $ichkUpgradeQueen = 0 And $ichkUpgradeWarden = 0 Then Return
	If _Sleep(500) Then Return
	checkMainScreen(False)
	If $Restart = True Then Return

	If $ichkUpgradeKing = 1 Then
		If isInsideDiamond($KingAltarPos) = False Then LocateKingAltar()
		If $KingAltarPos[0] = -1 Or $KingAltarPos[1] = -1 Then LocateKingAltar()
		SaveConfig()
	EndIf

	If $ichkUpgradeQueen = 1 Then
		If isInsideDiamond($QueenAltarPos) = False Then LocateQueenAltar()
		If $QueenAltarPos[0] = -1 Or $QueenAltarPos[1] = -1 Then LocateQueenAltar()
		SaveConfig()
	EndIf

	If $ichkUpgradeWarden = 1 Then
		If isInsideDiamond($WardenAltarPos) = False Then LocateWardenAltar()
		If $WardenAltarPos[0] = -1 Or $WardenAltarPos[1] = -1 Then LocateWardenAltar()
	EndIf

	;##### Verify the Upgrade troop kind in Laboratory , if is a Dark Spell/Troop , the Lab haves priority #####;
	If $ichkLab = 1 And $icmbLaboratory >= 19 Then
		Setlog("Laboratory needs DE to Upgrade :  " & $aLabTroops[$icmbLaboratory][3])
		SetLog("Skipping the Heroes Upgrade!")
		Return
	EndIf

	SetLog("Upgrading Heroes", $COLOR_BLUE)
	;;;;;;;;;;;;;;;;;;;;;;;;##### Archer Queen #####;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;##### Verify Builders available #####;
	If getBuilderCount() = False Then Return  ; update builder data, return if problem
	If _Sleep($iDelayRespond) Then Return
	If $iFreeBuilderCount < 1 + $iSaveWallBldr Then
		SetLog("Not Enough Builders for Queen", $COLOR_RED)
		Return
	EndIf
	;#### upgrade queen ####;
	QueenUpgrade()
	If _Sleep($iDelayUpgradeHero1) Then Return
	;;;;;;;;;;;;;;;;;;;;;;;;##### Barbarian King #####;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;##### Verify Builders available #####;
	If getBuilderCount() = False Then Return  ; update builder data, return if problem
	If _Sleep($iDelayRespond) Then Return
	If $iFreeBuilderCount < 1 + $iSaveWallBldr Then
		SetLog("Not Enough Builders for King", $COLOR_RED)
		Return
	EndIf
	;##### Upgrade King #####;
	KingUpgrade()
	If _Sleep($iDelayUpgradeHero1) Then Return
	;;;;;;;;;;;;;;;;;;;;;;;;##### Grand Warden #####;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;##### Verify Builders available
	If getBuilderCount() = False Then Return  ; update builder data, return if problem
	If _Sleep($iDelayRespond) Then Return
	If $iFreeBuilderCount < 1 + $iSaveWallBldr Then
		SetLog("Not Enough Builder for Warden", $COLOR_RED)
		Return
	EndIf
	;##### Upg Warden
	WardenUpgrade()

EndFunc   ;==>UpgradeHeroes

Func QueenUpgrade()

	If $ichkUpgradeQueen = 0 Then Return
	Local $aHeroLevel = 0

	SetLog("Upgrade Queen")
	ClickP($aTopLeftClient, 1, 0, "#0166") ; Click away
	If _Sleep(500) Then Return
	Click($QueenAltarPos[0], $QueenAltarPos[1]) ;Click Queen Altar

	;Get Queen info and Level
	Local $sInfo = BuildingInfo(242, 520 + $bottomOffsetY); 860x780
	If @error Then SetError(0, 0, 0)
	Local $CountGetInfo = 0
	While IsArray($sInfo) = False
		$sInfo = BuildingInfo(242, 520 + $bottomOffsetY); 860x780
		If @error Then SetError(0, 0, 0)
		Sleep(100)
		$CountGetInfo += 1
		If $CountGetInfo >= 50 Then Return
	WEnd
	If $debugSetlog = 1 Then SetLog(_ArrayToString($sInfo, " "), $COLOR_PURPLE)
	If @error Then Return SetError(0, 0, 0)


	If $sInfo[0] > 1 Or $sInfo[0] = "" Then
		If StringInStr($sInfo[1], "Quee") = 0 Then
			SetLog("Bad AQ location", $COLOR_ORANGE)
			Return
		Else
			If $sInfo[2] <> "" Then
				$aHeroLevel = Number($sInfo[2]) ; grab hero level from building info array
				SetLog("Your Queen Level read as: " & $aHeroLevel, $COLOR_GREEN)
				If $aHeroLevel = 40 Then; max hero
					SetLog("Your AQ is max, cannot upgrade!", $COLOR_BLUE)
					$ichkUpgradeQueen = 0 ; turn Off the Queen´s upgrade
					Return
				EndIf
			Else
				SetLog("Your Queen Level was not found!", $COLOR_BLUE)
				Return
			EndIf
		EndIf
	EndIf

	If _Sleep($iDelayUpgradeHero1) Then Return

	;##### Get updated village elixir and dark elixir values
	If _ColorCheck(_GetPixelColor(812, 141, True), Hex(0x000000, 6), 10) Then ; check if the village have a Dark Elixir Storage
		$iDarkCurrent = Number(getResourcesMainScreen(728, 123))
		If $debugSetlog = 1 Then SetLog("Updating village values [D]: " & $iDarkCurrent, $COLOR_PURPLE)
	Else
		If $debugSetlog = 1 Then Setlog("getResourcesMainScreen didn't get the DE value", $COLOR_PURPLE)
	EndIf

	If $iDarkCurrent < ($aQueenUpgCost[$aHeroLevel] * 1000) + $itxtUpgrMinDark Then
		SetLog("Insufficient DE for Upg Queen, requires: " & ($aQueenUpgCost[$aHeroLevel] * 1000) & " + " & $itxtUpgrMinDark, $COLOR_BLUE)
		Return
	EndIf

	Local $offColors[3][3] = [[0x9B4C28, 41, 23], [0x040009, 72, 0], [0xF5F9F2, 79, 0]] ; 2nd pixel brown hammer, 3rd pixel black, 4th pixel edge of button
	Global $ButtonPixel = _MultiPixelSearch(240, 563 + $bottomOffsetY, 670, 620 + $bottomOffsetY, 1, 1, Hex(0xF6F9F3, 6), $offColors, 30) ; first gray/white pixel of button

	If IsArray($ButtonPixel) Then
		If $debugSetlog = 1 And IsArray($ButtonPixel) Then
			Setlog("ButtonPixel = " & $ButtonPixel[0] & ", " & $ButtonPixel[1], $COLOR_PURPLE) ;Debug
			Setlog("Color #1: " & _GetPixelColor($ButtonPixel[0], $ButtonPixel[1], True) & ", #2: " & _GetPixelColor($ButtonPixel[0] + 41, $ButtonPixel[1] + 23, True) & ", #3: " & _GetPixelColor($ButtonPixel[0] + 72, $ButtonPixel[1], True) & ", #4: " & _GetPixelColor($ButtonPixel[0] + 79, $ButtonPixel[1], True), $COLOR_PURPLE)
		EndIf
		If _Sleep($iDelayUpgradeHero2) Then Return
		Click($ButtonPixel[0] + 20, $ButtonPixel[1] + 20, 1, 0, "#0305") ; Click Upgrade Button
		If _Sleep($iDelayUpgradeHero3) Then Return ; Wait for window to open
		If $DebugImageSave = 1 Then DebugImageSave("UpgradeDarkBtn1")
		If _ColorCheck(_GetPixelColor(721, 118 + $midOffsetY, True), Hex(0xE00408, 6), 20) Then ; Check if the Hero Upgrade window is open
			If _ColorCheck(_GetPixelColor(691, 523 + $midOffsetY, True), Hex(0xE70A12, 6), 20) And _ColorCheck(_GetPixelColor(691, 527 + $midOffsetY), Hex(0xE70A12, 6), 20) And _
					_ColorCheck(_GetPixelColor(691, 531 + $midOffsetY, True), Hex(0xE70A12, 6), 20) Then ; Check for Red Zero = means not enough loot!
				SetLog("Queen Upgrade Fail! No DE!", $COLOR_RED)
				ClickP($aAway, 2, 0, "#0306") ;Click Away to close window
				Return
			Else
				Click(665, 515 + $midOffsetY, 1, 0, "#0307") ; Click upgrade buttton
				ClickP($aAway, 1, 0, "#0308") ;Click Away to close windows
				If _Sleep($iDelayUpgradeHero1) Then Return
				If $DebugImageSave = 1 Then DebugImageSave("UpgradeDarkBtn2")
				If _ColorCheck(_GetPixelColor(573, 256 + $midOffsetY, True), Hex(0xDB0408, 6), 20) Then ; Redundant Safety Check if the use Gem window opens
					SetLog("Queen Upgrade Fail! No DE!", $COLOR_RED)
					ClickP($aAway, 2, 0, "#0309") ;Click Away to close windows
					Return
				EndIf
				SetLog("Queen Upgrade complete", $COLOR_GREEN)
				If _Sleep($iDelayUpgradeHero2) Then Return ; Wait for window to close
				$iNbrOfHeroesUpped += 1
				$iCostDElixirHero += $aQueenUpgCost[$aHeroLevel - 1] * 1000
				UpdateStats()
			EndIf
		Else
			Setlog("Upgrade Queen window open fail", $COLOR_RED)
		EndIf
	Else
		Setlog("Upgrade Queen error finding button", $COLOR_RED)
	EndIf

	ClickP($aAway, 2, 0, "#0312") ;Click Away to close windows

EndFunc   ;==>QueenUpgrade

Func KingUpgrade()
	;upgradeking
	If $ichkUpgradeKing = 0 Then Return
	Local $aHeroLevel = 0

	SetLog("Upgrade King")
	Click($KingAltarPos[0], $KingAltarPos[1]) ;Click King Altar
	If _Sleep(500) Then Return

	;Get King info
	Local $sInfo = BuildingInfo(242, 520 + $bottomOffsetY); 860x780
	If @error Then SetError(0, 0, 0)
	Local $CountGetInfo = 0
	While IsArray($sInfo) = False
		$sInfo = BuildingInfo(242, 520 + $bottomOffsetY); 860x780
		If @error Then SetError(0, 0, 0)
		If _Sleep(100) Then Return
		$CountGetInfo += 1
		If $CountGetInfo >= 50 Then Return
	WEnd
	If $debugSetlog = 1 Then SetLog(_ArrayToString($sInfo, " "), $COLOR_PURPLE)
	If @error Then Return SetError(0, 0, 0)

	If $sInfo[0] > 1 Or $sInfo[0] = "" Then
		If StringInStr($sInfo[1], "Barbarian") = 0 Then
			SetLog("Bad King location", $COLOR_ORANGE)
			Return
		Else
			If $sInfo[2] <> "" Then
				$aHeroLevel = Number($sInfo[2]) ; grab hero level from building info array
				SetLog("Your King Level read as: " & $aHeroLevel, $COLOR_GREEN)
				If $aHeroLevel = 40 Then; max hero
					SetLog("Your BK is max, cannot upgrade!", $COLOR_BLUE)
					$ichkUpgradeKing = 0 ; Turn Off the King's Upgrade
					Return
				EndIf
			Else
				SetLog("Your King Level was not found!", $COLOR_BLUE)
				Return
			EndIf
		EndIf
	EndIf

	If _Sleep($iDelayUpgradeHero1) Then Return

	;##### Get updated village elixir and dark elixir values
	If _ColorCheck(_GetPixelColor(812, 141, True), Hex(0x000000, 6), 10) Then ; check if the village have a Dark Elixir Storage
		$iDarkCurrent = Number(getResourcesMainScreen(728, 123))
		If $debugSetlog = 1 Then SetLog("Updating village values [D]: " & $iDarkCurrent, $COLOR_PURPLE)
	Else
		If $debugSetlog = 1 Then Setlog("getResourcesMainScreen didn't get the DE value", $COLOR_PURPLE)
	EndIf
	If _Sleep(100) Then Return

	If $iDarkCurrent < ($aKingUpgCost[$aHeroLevel] * 1000) + $itxtUpgrMinDark Then
		SetLog("Insufficient DE for Upg King, requires: " & ($aKingUpgCost[$aHeroLevel] * 1000) & " + " & $itxtUpgrMinDark, $COLOR_BLUE)
		Return
	EndIf

	Local $offColors[3][3] = [[0x9B4C28, 41, 23], [0x040009, 72, 0], [0xF5F9F2, 79, 0]] ; 2nd pixel brown hammer, 3rd pixel black, 4th pixel edge of button
	Global $ButtonPixel = _MultiPixelSearch(240, 563 + $bottomOffsetY, 670, 620 + $bottomOffsetY, 1, 1, Hex(0xF6F9F3, 6), $offColors, 30) ; first gray/white pixel of button

	If IsArray($ButtonPixel) Then
		If $debugSetlog = 1 And IsArray($ButtonPixel) Then
			Setlog("ButtonPixel = " & $ButtonPixel[0] & ", " & $ButtonPixel[1], $COLOR_PURPLE) ;Debug
			Setlog("Color #1: " & _GetPixelColor($ButtonPixel[0], $ButtonPixel[1], True) & ", #2: " & _GetPixelColor($ButtonPixel[0] + 41, $ButtonPixel[1] + 23, True) & ", #3: " & _GetPixelColor($ButtonPixel[0] + 72, $ButtonPixel[1], True) & ", #4: " & _GetPixelColor($ButtonPixel[0] + 79, $ButtonPixel[1], True), $COLOR_PURPLE)
		EndIf
		If _Sleep($iDelayUpgradeHero2) Then Return
		Click($ButtonPixel[0] + 20, $ButtonPixel[1] + 20, 1, 0, "#0305") ; Click Upgrade Button
		If _Sleep($iDelayUpgradeHero3) Then Return ; Wait for window to open
		If $DebugImageSave = 1 Then DebugImageSave("UpgradeDarkBtn1")
		If _ColorCheck(_GetPixelColor(715, 120 + $midOffsetY, True), Hex(0xE01C20, 6), 20) Then ; Check if the Hero Upgrade window is open
			If _ColorCheck(_GetPixelColor(691, 523 + $midOffsetY, True), Hex(0xE70A12, 6), 20) And _ColorCheck(_GetPixelColor(691, 527 + $midOffsetY), Hex(0xE70A12, 6), 20) And _
					_ColorCheck(_GetPixelColor(691, 531 + $midOffsetY, True), Hex(0xE70A12, 6), 20) Then ; Check for Red Zero = means not enough loot!
				SetLog("King Upgrade Fail! No DE!", $COLOR_RED)
				ClickP($aAway, 2, 0, "#0306") ;Click Away to close window
				Return
			Else
				Click(660, 515 + $midOffsetY, 1, 0, "#0307") ; Click upgrade buttton
				ClickP($aAway, 1, 0, "#0308") ;Click Away to close windows
				If _Sleep($iDelayUpgradeHero1) Then Return
				If $DebugImageSave = 1 Then DebugImageSave("UpgradeDarkBtn2")
				If _ColorCheck(_GetPixelColor(573, 256 + $midOffsetY, True), Hex(0xDB0408, 6), 20) Then ; Redundant Safety Check if the use Gem window opens
					SetLog("King Upgrade Fail! No DE!", $COLOR_RED)
					ClickP($aAway, 2, 0, "#0309") ;Click Away to close windows
					Return
				EndIf
				SetLog("King Upgrade complete", $COLOR_GREEN)
				If _Sleep($iDelayUpgradeHero2) Then Return ; Wait for window to close
				$iNbrOfHeroesUpped += 1
				$iCostDElixirHero += $aKingUpgCost[$aHeroLevel - 1] * 1000
				UpdateStats()
			EndIf
		Else
			Setlog("Upgrade King window open fail", $COLOR_RED)
		EndIf
	Else
		Setlog("Upgrade King error finding button", $COLOR_RED)
	EndIf

	ClickP($aAway, 2, 0, "#0312") ;Click Away to close windows

EndFunc   ;==>KingUpgrade

Func WardenUpgrade()

	If $ichkUpgradeWarden = 0 Then Return

	If Number($iTownHallLevel) <= 10 Then
		Setlog("Must have TH 11 for Grand Warden upgrade", $COLOR_RED)
		Return
	EndIf

	Local $aHeroLevel = 0

	SetLog("Upgrade Grand Warden")
	ClickP($WardenAltarPos, 1, 0, "#8888") ;Click Warden Altar
	If _Sleep($iDelayUpgradeHero2) Then Return

	;Get Warden info
	Local $sInfo = BuildingInfo(242, 520 + $bottomOffsetY); 860x780
	If @error Then SetError(0, 0, 0)
	Local $CountGetInfo = 0
	While IsArray($sInfo) = False
		$sInfo = BuildingInfo(242, 520 + $bottomOffsetY); 860x780
		If @error Then SetError(0, 0, 0)
		If _Sleep(100) Then Return
		$CountGetInfo += 1
		If $CountGetInfo = 50 Then Return
	WEnd
	If $debugSetlog = 1 Then SetLog(_ArrayToString($sInfo, " "))
	If @error Then Return SetError(0, 0, 0)

	If $sInfo[0] > 1 Or $sInfo[0] = "" Then
		If StringInStr($sInfo[1], "Grand") = 0 Then
			SetLog("Bad Warden location", $COLOR_ORANGE)
			Return
		Else
			If $sInfo[2] <> "" Then
				$aHeroLevel = Number($sInfo[2]) ; grab hero level from building info array
				SetLog("Your Warden Level read as: " & $aHeroLevel, $COLOR_GREEN)
				If $aHeroLevel = 20 Then; max hero
					SetLog("Your GW is max, cannot upgrade!", $COLOR_BLUE)
					$ichkUpgradeWarden = 0 ; turn OFF the Wardn's Upgrade
					Return
				EndIf
			Else
				SetLog("Your Warden Level was not found!", $COLOR_BLUE)
				Return
			EndIf
		EndIf
	EndIf

	If _Sleep($iDelayUpgradeHero1) Then Return

	;##### Get updated village elixir values
	If _ColorCheck(_GetPixelColor(812, 141, True), Hex(0x000000, 6), 10) Then ; check if the village have a Dark Elixir Storage
		$iElixirCurrent = getResourcesMainScreen(705, 74)
		If $debugSetlog = 1 Then SetLog("Updating village values [E]: " & $iElixirCurrent, $COLOR_PURPLE)
	Else
		$iElixirCurrent = getResourcesMainScreen(710, 74)
	EndIf
	If _Sleep(100) Then Return

	If $iElixirCurrent < ($aWardenUpgCost[$aHeroLevel] * 1000000) + $itxtUpgrMinElixir Then
		SetLog("Insufficient Elixir for Warden Upgrade, requires: " & ($aWardenUpgCost[$aHeroLevel] * 1000000) & " + " & $itxtUpgrMinElixir, $COLOR_BLUE)
		Return
	EndIf
	If _Sleep($iDelayUpgradeHero2) Then Return
	Local $offColors[3][3] = [[0xBC5B31, 38, 32], [0xF84CF9, 72, 0], [0xF5F9F2, 79, 0]] ; 2nd pixel brown hammer, 3rd pixel pink, 4th pixel edge of button
	Global $ButtonPixel = _MultiPixelSearch(240, 563 + $bottomOffsetY, 670, 620 + $bottomOffsetY, 1, 1, Hex(0xF4F7F2, 6), $offColors, 30) ; first gray/white pixel of button
	If IsArray($ButtonPixel) Then
		If $debugSetlog = 1 And IsArray($ButtonPixel) Then
			Setlog("ButtonPixel = " & $ButtonPixel[0] & ", " & $ButtonPixel[1], $COLOR_PURPLE) ;Debug
			Setlog("Color #1: " & _GetPixelColor($ButtonPixel[0], $ButtonPixel[1], True) & ", #2: " & _GetPixelColor($ButtonPixel[0] + 41, $ButtonPixel[1] + 23, True) & ", #3: " & _GetPixelColor($ButtonPixel[0] + 72, $ButtonPixel[1], True) & ", #4: " & _GetPixelColor($ButtonPixel[0] + 79, $ButtonPixel[1], True), $COLOR_PURPLE)
		EndIf
		If _Sleep($iDelayUpgradeHero2) Then Return
		Click($ButtonPixel[0] + 20, $ButtonPixel[1] + 20, 1, 0, "#0305") ; Click Upgrade Button
		If _Sleep($iDelayUpgradeHero3) Then Return ; Wait for window to open
		If $debugSetlog = 1 Then DebugImageSave("UpgradeElixirBtn1")
		If $debugSetlog = 1 Then Setlog("pixel: " & _GetPixelColor(718, 120 + $midOffsetY, True) & " expected " & Hex(0xDD0408, 6) & " result: " & _ColorCheck(_GetPixelColor(718, 120 + $midOffsetY, True), Hex(0xDD0408, 6), 20), $COLOR_PURPLE)
		If _ColorCheck(_GetPixelColor(718, 120 + $midOffsetY, True), Hex(0xDD0408, 6), 20) Then ; Check if the Hero Upgrade window is open
			If $debugSetlog = 1 Then Setlog("pixel1: " & _GetPixelColor(692, 525 + $midOffsetY, True) & " expected " & Hex(0xFFFFFF, 6) & " result: " & (_ColorCheck(_GetPixelColor(692, 525 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20)), $COLOR_PURPLE)
			If Not (_ColorCheck(_GetPixelColor(692, 525 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20)) Then ; Check for Red Zero = means not enough loot!
				SetLog("Warden Upgrade Fail! No Elixir!", $COLOR_RED)
				ClickP($aAway, 1, 0, "#0306") ;Click Away to close window
				Return
			Else
				Click(660, 515 + $midOffsetY, 1, 0, "#0307") ; Click upgrade buttton
				ClickP($aAway, 1, 0, "#0308") ;Click Away to close windows
				If _Sleep($iDelayUpgradeHero1) Then Return
				If $debugSetlog = 1 Then DebugImageSave("UpgradeElixirBtn2")
				If _ColorCheck(_GetPixelColor(573, 256 + $midOffsetY, True), Hex(0xDB0408, 6), 20) Then ; Redundant Safety Check if the use Gem window opens
					SetLog("Warden Upgrade Fail! No Elixir!", $COLOR_RED)
					ClickP($aAway, 1, 0, "#0309") ;Click Away to close windows
					Return
				EndIf
				SetLog("Warden Upgrade Started", $COLOR_GREEN)
				If _Sleep($iDelayUpgradeHero2) Then Return ; Wait for window to close
				$iNbrOfHeroesUpped += 1
				$iCostElixirBuilding += $aWardenUpgCost[$aHeroLevel - 1] * 1000
				UpdateStats()
			EndIf
		Else
			Setlog("Upgrade Warden window open fail", $COLOR_RED)
		EndIf
	Else
		Setlog("Upgrade Warden error finding button", $COLOR_RED)
	EndIf

	ClickP($aAway, 2, 0, "#0312") ;Click Away to close windows

EndFunc   ;==>WardenUpgrade
