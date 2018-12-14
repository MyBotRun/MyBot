; #FUNCTION# ====================================================================================================================
; Name ..........: UpgradeWall
; Description ...: This file checks if enough resources to upgrade walls, and upgrades them
; Syntax ........: UpgradeWall()
; Parameters ....:
; Return values .: None
; Author ........: ProMac (2015), HungLe (2015)
; Modified ......: Sardo (08-2015), KnowJack (08-2015), MonkeyHunter(06-2016) , trlopes (07-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: checkwall.au3
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func UpgradeWall()

	If $g_bAutoUpgradeWallsEnable = True Then
		SetLog("Checking Upgrade Walls", $COLOR_INFO)
		If SkipWallUpgrade() Then Return
		If $g_iFreeBuilderCount > 0 Then
			ClickP($aAway, 1, 0, "#0313") ; click away
			Local $MinWallGold = Number($g_aiCurrentLoot[$eLootGold] - $g_iWallCost) > Number($g_iUpgradeWallMinGold) ; Check if enough Gold
			Local $MinWallElixir = Number($g_aiCurrentLoot[$eLootElixir] - $g_iWallCost) > Number($g_iUpgradeWallMinElixir) ; Check if enough Elixir

			While ($g_iUpgradeWallLootType = 0 And $MinWallGold) Or ($g_iUpgradeWallLootType = 1 And $MinWallElixir) Or ($g_iUpgradeWallLootType = 2 And ($MinWallGold Or $MinWallElixir))

				Switch $g_iUpgradeWallLootType
					Case 0
						If $MinWallGold Then
							SetLog("Upgrading Wall using Gold", $COLOR_SUCCESS)
							If imglocCheckWall() Then
								If Not UpgradeWallGold() Then
									SetLog("Upgrade with Gold failed, skipping...", $COLOR_ERROR)
									Return
								EndIf
							ElseIf SwitchToNextWallLevel() Then
								SetLog("No more walls of current level, switching to next", $COLOR_ACTION)
							Else
								Return
							EndIf
						Else
							SetLog("Gold is below minimum, Skipping Upgrade", $COLOR_ERROR)
						EndIf
					Case 1
						If $MinWallElixir Then
							SetLog("Upgrading Wall using Elixir", $COLOR_SUCCESS)
							If imglocCheckWall() Then
								If Not UpgradeWallElixir() Then
									SetLog("Upgrade with Elixier failed, skipping...", $COLOR_ERROR)
									Return
								EndIf
							ElseIf SwitchToNextWallLevel() Then
								SetLog("No more walls of current level, switching to next", $COLOR_ACTION)
							Else
								Return
							EndIf
						Else
							SetLog("Elixir is below minimum, Skipping Upgrade", $COLOR_ERROR)
						EndIf
					Case 2
						If $MinWallElixir Then
							SetLog("Upgrading Wall using Elixir", $COLOR_SUCCESS)
							If imglocCheckWall() Then
								If Not UpgradeWallElixir() Then
									SetLog("Upgrade with Elixir failed, attempt to upgrade using Gold", $COLOR_ERROR)
									If Not UpgradeWallGold() Then
										SetLog("Upgrade with Gold failed, skipping...", $COLOR_ERROR)
										Return
									EndIf
								EndIf
							ElseIf SwitchToNextWallLevel() Then
								SetLog("No more walls of current level, switching to next", $COLOR_ACTION)
							Else
								Return
							EndIf
						Else
							SetLog("Elixir is below minimum, attempt to upgrade using Gold", $COLOR_ERROR)
							If $MinWallGold Then
								If imglocCheckWall() Then
									If Not UpgradeWallGold() Then
										SetLog("Upgrade with Gold failed, skipping...", $COLOR_ERROR)
										Return
									EndIf
								ElseIf SwitchToNextWallLevel() Then
									SetLog("No more walls of current level, switching to next", $COLOR_ACTION)
								Else
									Return
								EndIf
							Else
								SetLog("Gold is below minimum, Skipping Upgrade", $COLOR_ERROR)
							EndIf
						EndIf
				EndSwitch

				; Check Builder/Shop if open by accident
				If _CheckPixel($g_aShopWindowOpen, $g_bCapturePixel, Default, "ChkShopOpen", $COLOR_DEBUG) = True Then
					Click(820, 40, 1, 0, "#0315") ; Close it
				EndIf

				ClickP($aAway, 1, 0, "#0314") ; click away
				VillageReport(True, True)
				$MinWallGold = Number($g_aiCurrentLoot[$eLootGold] - $g_iWallCost) > Number($g_iUpgradeWallMinGold) ; Check if enough Gold
				$MinWallElixir = Number($g_aiCurrentLoot[$eLootElixir] - $g_iWallCost) > Number($g_iUpgradeWallMinElixir) ; Check if enough Elixir

			WEnd
		Else
			SetLog("No free builder, Upgrade Walls skipped..", $COLOR_ERROR)
		EndIf
	EndIf
	If _Sleep($DELAYUPGRADEWALL1) Then Return
	checkMainScreen(False) ; Check for errors during function

EndFunc   ;==>UpgradeWall


Func UpgradeWallGold()

	;Click($WallxLOC, $WallyLOC)
	If _Sleep($DELAYRESPOND) Then Return

	Local $offColors[3][3] = [[0xD6714B, 47, 37], [0xF0E850, 70, 0], [0xF4F8F2, 79, 0]] ; 2nd pixel brown hammer, 3rd pixel gold, 4th pixel edge of button
	Local $ButtonPixel = _MultiPixelSearch(240, 563 + $g_iBottomOffsetY, 670, 650 + $g_iBottomOffsetY, 1, 1, Hex(0xF3F3F1, 6), $offColors, 30) ; first gray/white pixel of button
	If IsArray($ButtonPixel) Then
		If $g_bDebugSetlog Then
			SetDebugLog("ButtonPixel = " & $ButtonPixel[0] & ", " & $ButtonPixel[1], $COLOR_DEBUG) ;Debug
			SetDebugLog("Color #1: " & _GetPixelColor($ButtonPixel[0], $ButtonPixel[1], True) & ", #2: " & _GetPixelColor($ButtonPixel[0] + 47, $ButtonPixel[1] + 37, True) & ", #3: " & _GetPixelColor($ButtonPixel[0] + 70, $ButtonPixel[1], True) & ", #4: " & _GetPixelColor($ButtonPixel[0] + 79, $ButtonPixel[1], True), $COLOR_DEBUG)
		EndIf
		Click($ButtonPixel[0] + 20, $ButtonPixel[1] + 20, 1, 0, "#0316") ; Click Upgrade Gold Button
		If _Sleep($DELAYUPGRADEWALLGOLD2) Then Return

		If _ColorCheck(_GetPixelColor(677, 150 + $g_iMidOffsetY, True), Hex(0xE1090E, 6), 20) Then ; wall upgrade window red x
			If isNoUpgradeLoot(False) = True Then
				SetLog("Upgrade stopped due no loot", $COLOR_ERROR)
				Return False
			EndIf
			Click(440, 480 + $g_iMidOffsetY, 1, 0, "#0317")
			If _Sleep(1000) Then Return
			If isGemOpen(True) Then
				ClickP($aAway, 1, 0, "#0314") ; click away
				SetLog("Upgrade stopped due no loot", $COLOR_ERROR)
				Return False
			ElseIf _ColorCheck(_GetPixelColor(677, 150 + $g_iMidOffsetY, True), Hex(0xE1090E, 6), 20) Then ; wall upgrade window red x, didnt closed on upgradeclick, so not able to upgrade
				ClickP($aAway, 1, 0, "#0314") ; click away
				SetLog("unable to upgrade", $COLOR_ERROR)
				Return False
			Else
				If _Sleep($DELAYUPGRADEWALLGOLD3) Then Return
				SetLog("Upgrade complete", $COLOR_SUCCESS)
				PushMsg("UpgradeWithGold")
				$g_iNbrOfWallsUppedGold += 1
				$g_iNbrOfWallsUpped += 1
				$g_iCostGoldWall += $g_iWallCost
				UpdateStats()
				Return True
			EndIf
		EndIf
	Else
		SetLog("No Upgrade Gold Button", $COLOR_ERROR)
		Pushmsg("NowUpgradeGoldButton")
		Return False
	EndIf

EndFunc   ;==>UpgradeWallGold

Func UpgradeWallElixir()

	;Click($WallxLOC, $WallyLOC)
	If _Sleep($DELAYRESPOND) Then Return

	Local $offColors[3][3] = [[0xBC5B31, 38, 32], [0xF84CF9, 72, 0], [0xF5F9F2, 79, 0]] ; 2nd pixel brown hammer, 3rd pixel gold, 4th pixel edge of button
	Local $ButtonPixel = _MultiPixelSearch(240, 563 + $g_iBottomOffsetY, 670, 650 + $g_iBottomOffsetY, 1, 1, Hex(0xF4F7F2, 6), $offColors, 30) ; first gray/white pixel of button
	If IsArray($ButtonPixel) Then
		Click($ButtonPixel[0] + 20, $ButtonPixel[1] + 20, 1, 0, "#0322") ; Click Upgrade Elixir Button

		If _Sleep($DELAYUPGRADEWALLELIXIR2) Then Return
		If _ColorCheck(_GetPixelColor(677, 150 + $g_iMidOffsetY, True), Hex(0xE1090E, 6), 20) Then
			If isNoUpgradeLoot(False) = True Then
				SetLog("Upgrade stopped due to insufficient loot", $COLOR_ERROR)
				Return False
			EndIf
			Click(440, 480 + $g_iMidOffsetY, 1, 0, "#0318")
			If _Sleep(1000) Then Return
			If isGemOpen(True) Then
				ClickP($aAway, 1, 0, "#0314") ; click away
				SetLog("Upgrade stopped due to insufficient loot", $COLOR_ERROR)
				Return False
			ElseIf _ColorCheck(_GetPixelColor(677, 150 + $g_iMidOffsetY, True), Hex(0xE1090E, 6), 20) Then ; wall upgrade window red x, didnt closed on upgradeclick, so not able to upgrade
				ClickP($aAway, 1, 0, "#0314") ; click away
				SetLog("unable to upgrade", $COLOR_ERROR)
				Return False
			Else
				If _Sleep($DELAYUPGRADEWALLELIXIR3) Then Return
				SetLog("Upgrade complete", $COLOR_SUCCESS)
				PushMsg("UpgradeWithElixir")
				$g_iNbrOfWallsUppedElixir += 1
				$g_iNbrOfWallsUpped += 1
				$g_iCostElixirWall += $g_iWallCost
				UpdateStats()
				Return True
			EndIf
		EndIf
	Else
		SetLog("No Upgrade Elixir Button", $COLOR_ERROR)
		Pushmsg("NowUpgradeElixirButton")
		Return False
	EndIf

EndFunc   ;==>UpgradeWallElixir

Func SkipWallUpgrade() ; Dynamic Upgrades

	IniReadS($g_iUpgradeWallLootType, $g_sProfileConfigPath, "upgrade", "use-storage", "0") ; Reset Variable to User Selection

	Local $iUpgradeAction = 0
	Local $iBuildingsNeedGold = 0
	Local $iBuildingsNeedElixir = 0
	Local $iAvailBuilderCount = 0

	Switch $g_iTownHallLevel
		Case 5 To 8 ;Start at Townhall 5 because any Wall Level below 4 is not supported anyways
			If $g_iTownHallLevel < $g_iCmbUpgradeWallsLevel + 4 Then
				SetLog("Skip Wall upgrade -insufficient TH-Level", $COLOR_WARNING)
				Return True
			EndIf
		Case 9 To 12
			If $g_iTownHallLevel < $g_iCmbUpgradeWallsLevel + 3 Then
				SetLog("Skip Wall upgrade -insufficient TH-Level", $COLOR_WARNING)
				Return True
			EndIf
		Case Else
			Return True
	EndSwitch

	If Not getBuilderCount() Then Return True ; update builder data, return true to skip if problem
	If _Sleep($DELAYRESPOND) Then Return True

	$iAvailBuilderCount = $g_iFreeBuilderCount ; capture local copy of free builders

	;;;;; Check building upgrade resouce needs .vs. available resources for walls
	For $iz = 0 To UBound($g_avBuildingUpgrades, 1) - 1 ; loop through all upgrades to see if any are enabled.
		If $g_abBuildingUpgradeEnable[$iz] = True Then $iUpgradeAction += 1 ; count number enabled
	Next

	If $g_iFreeBuilderCount > ($g_bUpgradeWallSaveBuilder ? 1 : 0) And $iUpgradeAction > 0 Then ; check if builder available for bldg upgrade, and upgrades enabled
		For $iz = 0 To UBound($g_avBuildingUpgrades, 1) - 1
			; internal check if builder still available, if loop index upgrade slot is enabled, and if upgrade is not in progress
			If $iAvailBuilderCount > ($g_bUpgradeWallSaveBuilder ? 1 : 0) And $g_abBuildingUpgradeEnable[$iz] = True And $g_avBuildingUpgrades[$iz][7] = "" Then
				Switch $g_avBuildingUpgrades[$iz][3]
					Case "Gold"
						$iBuildingsNeedGold += Number($g_avBuildingUpgrades[$iz][2]) ; sum gold required for enabled upgrade
						$iAvailBuilderCount -= 1 ; subtract builder from free count, as only need to save gold for upgrades where builder is available
					Case "Elixir"
						$iBuildingsNeedElixir += Number($g_avBuildingUpgrades[$iz][2]) ; sum elixir required for enabled upgrade
						$iAvailBuilderCount -= 1 ; subtract builder from free count, as only need to save elixir for upgrades where builder is available
				EndSwitch
			EndIf
		Next
		SetLog("SkipWall-Upgrade Summary: G:" & $iBuildingsNeedGold & ", E:" & $iBuildingsNeedElixir & ", Wall: " & $g_iWallCost & ", MinG: " & $g_iUpgradeWallMinGold & ", MinE: " & $g_iUpgradeWallMinElixir) ; debug
		If $iBuildingsNeedGold > 0 Or $iBuildingsNeedElixir > 0 Then ; if upgrade enabled and building upgrade resource is required, log user messages.
			Switch $g_iUpgradeWallLootType
				Case 0 ; Using gold
					If $g_aiCurrentLoot[$eLootGold] - ($iBuildingsNeedGold + $g_iWallCost + Number($g_iUpgradeWallMinGold)) < 0 Then
						SetLog("Skip Wall upgrade -insufficient gold for selected upgrades", $COLOR_WARNING)
						Return True
					EndIf
				Case 1 ; Using elixir
					If $g_aiCurrentLoot[$eLootElixir] - ($iBuildingsNeedElixir + $g_iWallCost + Number($g_iUpgradeWallMinElixir)) < 0 Then
						SetLog("Skip Wall upgrade - insufficient elixir for selected upgrades", $COLOR_WARNING)
						Return True
					EndIf
				Case 2 ; Using gold and elixir
					If $g_aiCurrentLoot[$eLootGold] - ($iBuildingsNeedGold + $g_iWallCost + Number($g_iUpgradeWallMinGold)) < 0 Then
						SetLog("Wall upgrade: insufficient gold for selected upgrades", $COLOR_WARNING)
						If $g_aiCurrentLoot[$eLootElixir] - ($iBuildingsNeedElixir + $g_iWallCost + Number($g_iUpgradeWallMinElixir)) >= 0 Then
							SetLog("Using Elixir only for wall Upgrade", $COLOR_SUCCESS1)
							$g_iUpgradeWallLootType = 1
						Else
							SetLog("Skip Wall upgrade -insufficient resources for selected upgrades", $COLOR_WARNING)
							Return True
						EndIf
					EndIf
					If $g_aiCurrentLoot[$eLootElixir] - ($iBuildingsNeedElixir + $g_iWallCost + Number($g_iUpgradeWallMinElixir)) < 0 Then
						SetLog("Wall upgrade: insufficient elixir for selected upgrades", $COLOR_WARNING)
						If $g_aiCurrentLoot[$eLootGold] - ($iBuildingsNeedGold + $g_iWallCost + Number($g_iUpgradeWallMinGold)) >= 0 Then
							SetLog("Using Gold only for Wall Upgrade", $COLOR_SUCCESS1)
							$g_iUpgradeWallLootType = 0
						Else
							SetLog("Skip Wall upgrade -insufficient resources for selected upgrades", $COLOR_WARNING)
							Return True
						EndIf
					EndIf
			EndSwitch
		EndIf
		If _Sleep($DELAYRESPOND) Then Return True
	EndIf
	;;;;;;;;;;;;;;;;;;;;;;;;;;;End bldg upgrade value checking


	;   Is Warden Level updated |          Is Warden not max yet           |  Is Upgrade enabled       |               Is Warden not already upgrading                |               Is a Builder available
	If ($g_iWardenLevel <> -1) And ($g_iWardenLevel < $g_iMaxWardenLevel) And $g_bUpgradeWardenEnable And BitAND($g_iHeroUpgradingBit, $eHeroWarden) <> $eHeroWarden And ($g_iFreeBuilderCount > ($g_bUpgradeWallSaveBuilder ? 1 : 0)) Then
		Local $bMinWardenElixir = Number($g_aiCurrentLoot[$eLootElixir]) > ($g_iWallCost + $g_afWardenUpgCost[$g_iWardenLevel] * 1000000 + Number($g_iUpgradeWallMinElixir))
		If Not $bMinWardenElixir Then
			Switch $g_iUpgradeWallLootType
				Case 1 ; Elixir
					SetLog("Grand Warden needs " & ($g_afWardenUpgCost[$g_iWardenLevel] * 1000000) & " Elixir for next Level", $COLOR_WARNING)
					SetLog("Skipping Wall Upgrade", $COLOR_WARNING)
					Return True
				Case 2 ; Elixir & Gold
					SetLog("Grand Warden needs " & ($g_afWardenUpgCost[$g_iWardenLevel] * 1000000) & " Elixir for next Level", $COLOR_SUCCESS1)
					SetLog("Using Gold only for Wall Upgrade", $COLOR_SUCCESS1)
					$g_iUpgradeWallLootType = 0
			EndSwitch
		EndIf
	EndIf


	;;;;;;;;;;;;;;;;;;;;;;;;;;;##### Verify the Upgrade troop kind in Laboratory , if is elixir Spell/Troop , the Lab have priority #####;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	Local $bMinWallElixir = Number($g_aiCurrentLoot[$eLootElixir]) > ($g_iWallCost + Number($g_iLaboratoryElixirCost) + Number($g_iUpgradeWallMinElixir)) ; Check if enough Elixir
	If $g_bAutoLabUpgradeEnable And $g_iLaboratoryElixirCost > 0 And Not $bMinWallElixir Then
		Switch $g_iUpgradeWallLootType
			Case 0 ; Using gold
				; do nothing
			Case 1 ; Using elixir
				SetLog("Laboratory needs Elixir to Upgrade :  " & $g_iLaboratoryElixirCost, $COLOR_SUCCESS1)
				SetLog("Skipping Wall Upgrade", $COLOR_SUCCESS1)
				Return True
			Case 2 ; Using gold and elixir
				SetLog("Laboratory needs Elixir to Upgrade :  " & $g_iLaboratoryElixirCost, $COLOR_SUCCESS1)
				SetLog("Using Gold only for Wall Upgrade", $COLOR_SUCCESS1)
				$g_iUpgradeWallLootType = 0
		EndSwitch
	EndIf

	Return False

EndFunc   ;==>SkipWallUpgrade

Func SwitchToNextWallLevel() ; switches wall level to upgrade to next level
	If $g_aiWallsCurrentCount[$g_iCmbUpgradeWallsLevel + 4] = 0 And $g_iCmbUpgradeWallsLevel < 8 Then
		EnableGuiControls()
		_GUICtrlComboBox_SetCurSel($g_hCmbWalls, $g_iCmbUpgradeWallsLevel + 1)
		cmbWalls()
		If $g_iCmbUpgradeWallsLevel = 4 Then
			GUICtrlSetState($g_hRdoUseElixirGold, $GUI_CHECKED)
			GUICtrlSetData($g_hTxtWallMinElixir, GUICtrlRead($g_hTxtWallMinGold))
		EndIf
		SaveConfig()
		DisableGuiControls()
		Return True
	EndIf
	Return False
EndFunc   ;==>SwitchToNextWallLevel

