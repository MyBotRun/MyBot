; #FUNCTION# ====================================================================================================================
; Name ..........: UpgradeWall
; Description ...: This file checks if enough resources to upgrade walls, and upgrades them
; Syntax ........: UpgradeWall()
; Parameters ....:
; Return values .: None
; Author ........: ProMac (2015), HungLe (2015)
; Modified ......: Sardo 2015-08, KnowJack (Aug 2105), MonkeyHunter(06-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: checkwall.au3
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func UpgradeWall()

	If $ichkWalls = 1 Then
		SetLog("Checking Upgrade Walls", $COLOR_BLUE)
		If SkipWallUpgrade() Then Return
		If $iFreeBuilderCount > 0 Then
			ClickP($aAway, 1, 0, "#0313") ; click away
			Local $MinWallGold = Number($iGoldCurrent - $WallCost) > Number($itxtWallMinGold) ; Check if enough Gold
			Local $MinWallElixir = Number($iElixirCurrent - $WallCost) > Number($itxtWallMinElixir) ; Check if enough Elixir

			Switch $iUseStorage
				Case 0
					If $MinWallGold Then
						SetLog("Upgrading Wall using Gold", $COLOR_GREEN)
						If CheckWall() Then UpgradeWallGold()
					Else
						SetLog("Gold is below minimum, Skipping Upgrade", $COLOR_RED)
					EndIf
				Case 1
					If $MinWallElixir Then
						Setlog("Upgrading Wall using Elixir", $COLOR_GREEN)
						If CheckWall() Then UpgradeWallElixir()
					Else
						Setlog("Elixir is below minimum, Skipping Upgrade", $COLOR_RED)
					EndIf
				Case 2
					If $MinWallElixir Then
						SetLog("Upgrading Wall using Elixir", $COLOR_GREEN)
						If CheckWall() And Not UpgradeWallElixir() Then
							SetLog("Upgrade with Elixir failed, attempt to upgrade using Gold", $COLOR_RED)
							UpgradeWallGold()
						EndIf
					Else
						SetLog("Elixir is below minimum, attempt to upgrade using Gold", $COLOR_RED)
						If $MinWallGold Then
							If CheckWall() Then UpgradeWallGold()
						Else
							Setlog("Gold is below minimum, Skipping Upgrade", $COLOR_RED)
						EndIf
					EndIf
			EndSwitch

			ClickP($aAway, 1, 0, "#0314") ; click away
			If _Sleep(100) Then Return

			Click(820, 40, 1, 0, "#0315") ; Close Builder/Shop if open by accident
		Else
			SetLog("No free builder, Upgrade Walls skipped..", $COLOR_RED)
		EndIf
	EndIf
	If _Sleep($iDelayUpgradeWall1) Then Return
	checkMainScreen(False) ; Check for errors during function

EndFunc   ;==>UpgradeWall


Func UpgradeWallGold()

	;Click($WallxLOC, $WallyLOC)
	If _Sleep($iDelayUpgradeWallGold1) Then Return

	Local $offColors[3][3] = [[0xD6714B, 47, 37], [0xF0E850, 70, 0], [0xF4F8F2, 79, 0]] ; 2nd pixel brown hammer, 3rd pixel gold, 4th pixel edge of button
	Global $ButtonPixel = _MultiPixelSearch(240, 563 + $bottomOffsetY, 670, 650 + $bottomOffsetY, 1, 1, Hex(0xF3F3F1, 6), $offColors, 30) ; first gray/white pixel of button
	If IsArray($ButtonPixel) Then
		If $debugSetlog = 1 Then
			Setlog("ButtonPixel = " & $ButtonPixel[0] & ", " & $ButtonPixel[1], $COLOR_PURPLE) ;Debug
			Setlog("Color #1: " & _GetPixelColor($ButtonPixel[0], $ButtonPixel[1], True) & ", #2: " & _GetPixelColor($ButtonPixel[0] + 47, $ButtonPixel[1] + 37, True) & ", #3: " & _GetPixelColor($ButtonPixel[0] + 70, $ButtonPixel[1], True) & ", #4: " & _GetPixelColor($ButtonPixel[0] + 79, $ButtonPixel[1], True), $COLOR_PURPLE)
		EndIf
		Click($ButtonPixel[0] + 20, $ButtonPixel[1] + 20, 1, 0, "#0316") ; Click Upgrade Gold Button
		If _Sleep($iDelayUpgradeWallGold2) Then Return

		If _ColorCheck(_GetPixelColor(677, 150 + $midOffsetY, True), Hex(0xE1090E, 6), 20) Then ; wall upgrade window red x
			If isNoUpgradeLoot(False) = True Then
				SetLog("Upgrade stopped due no loot", $COLOR_RED)
				Return False
			EndIf
			Click(440, 480 + $midOffsetY, 1, 0, "#0317")
			If _Sleep($iDelayUpgradeWallGold3) Then Return
			SetLog("Upgrade complete", $COLOR_GREEN)
			PushMsg("UpgradeWithGold")
			$iNbrOfWallsUppedGold += 1
			$iNbrOfWallsUpped += 1
			$iCostGoldWall += $WallCost
			UpdateStats()
			Return True
		EndIf
	Else
		Setlog("No Upgrade Gold Button", $COLOR_RED)
		Pushmsg("NowUpgradeGoldButton")
		Return False
	EndIf

EndFunc   ;==>UpgradeWallGold

Func UpgradeWallElixir()

	;Click($WallxLOC, $WallyLOC)
	If _Sleep($iDelayUpgradeWallElixir1) Then Return

	Local $offColors[3][3] = [[0xBC5B31, 38, 32], [0xF84CF9, 72, 0], [0xF5F9F2, 79, 0]] ; 2nd pixel brown hammer, 3rd pixel gold, 4th pixel edge of button
	Global $ButtonPixel = _MultiPixelSearch(240, 563 + $bottomOffsetY, 670, 650 + $bottomOffsetY, 1, 1, Hex(0xF4F7F2, 6), $offColors, 30) ; first gray/white pixel of button
	If IsArray($ButtonPixel) Then
		Click($ButtonPixel[0] + 20, $ButtonPixel[1] + 20, 1, 0, "#0322") ; Click Upgrade Elixir Button

		If _Sleep($iDelayUpgradeWallElixir2) Then Return
		If _ColorCheck(_GetPixelColor(677, 150 + $midOffsetY, True), Hex(0xE1090E, 6), 20) Then
			If isNoUpgradeLoot(False) = True Then
				SetLog("Upgrade stopped due to insufficient loot", $COLOR_RED)
				Return False
			EndIf
			Click(440, 480 + $midOffsetY, 1, 0, "#0318")
			If _Sleep($iDelayUpgradeWallElixir3) Then Return
			SetLog("Upgrade complete", $COLOR_GREEN)
			PushMsg("UpgradeWithElixir")
			$iNbrOfWallsUppedElixir += 1
			$iNbrOfWallsUpped += 1
			$iCostElixirWall += $WallCost
			UpdateStats()
			Return True
		EndIf
	Else
		Setlog("No Upgrade Elixir Button", $COLOR_RED)
		Pushmsg("NowUpgradeElixirButton")
		Return False
	EndIf

EndFunc   ;==>UpgradeWallElixir

Func SkipWallUpgrade() ; Dynamic Upgrades

	If _Sleep(500) Then Return
	checkMainScreen(False)
	If $Restart = True Then Return
	; $iUseStorage = IniRead($config, "other", "use-storage", "0") ; Reset Variable to User Selection
	InireadS($iUseStorage,$config, "upgrade", "use-storage", "0")
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;;;;;;;;;;;;;;;;;;;;##### Verify Builders available For Building Upgrades, If builder is available then buildings upgrade have priority #####;;;;;;;;;;;;;;;;;;;;
	Local $iUpgradeAction = 0
	Local $BuildingsNeedGold = 0
	Local $BuildingsNeedElixir = 0

	If getBuilderCount() = False Then Return True ; update builder data, return true to skip if problem
	If _Sleep($iDelayRespond) Then Return True

	;;;;;;;;;;;;;;;;;;;;;;;;;;;
	For $iz = 0 To UBound($aUpgrades, 1) - 1
		If $ichkbxUpgrade[$iz] = 1 Then $iUpgradeAction += 1
	Next
	If $iFreeBuilderCount > $iSaveWallBldr And $iUpgradeAction > 0 Then
		For $iz = 0 To UBound($aUpgrades, 1) - 1
			Switch $aUpgrades[$iz][3]
				Case "Gold"
					$BuildingsNeedGold += 1
				Case "Elixir"
					$BuildingsNeedElixir += 1
			EndSwitch
		Next
		If $BuildingsNeedGold > 0 And $BuildingsNeedElixir > 0 Then
			SetLog("A Builder is available for Building Upgrade Skipping Wall upgrade", $COLOR_RED)
			Return True
		ElseIf $BuildingsNeedGold = 0 And $BuildingsNeedElixir = 0 Then
			; Do nothing
		Else
			Switch $iUseStorage
				Case 0 ; Using gold
					If $BuildingsNeedGold > 0 Then
						SetLog("A Builder is available for Building Upgrade Skipping Wall upgrade", $COLOR_RED)
						Return True
					EndIf
				Case 1 ; Using elixir
					If $BuildingsNeedElixir > 0 Then
						SetLog("A Builder is available for Building Upgrade Skipping Wall upgrade", $COLOR_RED)
						Return True
					EndIf
				Case 2 ; Using gold and elixir
					If $BuildingsNeedGold > 0 Then
						Setlog("A Building needs Gold to Upgrade", $COLOR_GREEN)
						Setlog("Using Elixir only for wall Upgrade", $COLOR_GREEN)
						$iUseStorage = 1
					EndIf
					If $BuildingsNeedElixir > 0 Then
						Setlog("A Building needs Elixir to Upgrade", $COLOR_GREEN)
						Setlog("Using Gold only for wall Upgrade", $COLOR_GREEN)
						$iUseStorage = 0
					EndIf
			EndSwitch
		EndIf
	EndIf
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;;;;;;;;;;;;;;;;;;;;;;;;;;;##### Verify the Upgrade troop kind in Laboratory , if is elixir Spell/Troop , the Lab have priority #####;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	Local $MinWallElixir = Number($iElixirCurrent - $WallCost) > Number($iLaboratoryElixirCost) ; Check if enough Elixir
	If $ichkLab = 1 And $icmbLaboratory >= 1 And $icmbLaboratory <= 15 And $MinWallElixir = False Then
		For $i = 1 To 15
			If $icmbLaboratory = $i Then
				Local $name = $aLabTroops[$i][3]
				ExitLoop
			EndIf
		Next
		Switch $iUseStorage
			Case 0 ; Using gold
				; do nothing
			Case 1 ; Using elixir
				Setlog("Laboratory needs Elixir to Upgrade :  " & $name, $COLOR_GREEN)
				Setlog("Skipping Wall Upgrade", $COLOR_GREEN)
				Return True
			Case 2 ; Using gold and elixir
				Setlog("Laboratory needs Elixir to Upgrade :  " & $name, $COLOR_GREEN)
				Setlog("Using Gold only for wall Upgrade  " & $name, $COLOR_GREEN)
				$iUseStorage = 0
		EndSwitch
	EndIf

EndFunc   ;==>SkipWallUpgrade
