; #FUNCTION# ====================================================================================================================
; Name ..........: UpgradeBuilding.au3
; Description ...: Upgrades buildings if loot and builders are available
; Syntax ........: UpgradeBuilding(), UpgradeNormal($inum), UpgradeHero($inum)
; Parameters ....: $inum = array index [0-3]
; Return values .:
; Author ........: KnowJack (April-2015)
; Modified ......: KnowJack (June-2015) edited for V3.x Bot and SC updates
;                  Sardo 2015-08
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
;
Func UpgradeBuilding()
	Local $iz = 0
	Local $iUpgradeAction = -1
	Local $iAvailBldr, $iAvailGold, $iAvailElixir, $iAvailDark
	$itxtUpgrMinGold = Number($itxtUpgrMinGold)
	$itxtUpgrMinElixir = Number($itxtUpgrMinElixir)
	$itxtUpgrMinDark = Number($itxtUpgrMinDark)

	; check to see if anything is enabled before wasting time.
	For $iz = 0 To 5
		If $ichkbxUpgrade[$iz] = 1 Then
			$iUpgradeAction += 2 ^ ($iz + 1)
		EndIf
	Next
	If $iUpgradeAction < 0 Then Return False
	$iUpgradeAction = -1 ; Reset action

	Setlog("Checking Upgrade", $COLOR_BLUE)

	; Need to update village report function to skip statistics and extra messages not required using a bypass?
	VillageReport(True, True) ; Get current loot available after training troops and update free builder status
	$iAvailGold = Number($iGoldCurrent)
	$iAvailElixir = Number($iElixirCurrent)
	$iAvailDark = Number($iDarkCurrent)

	If $iSaveWallBldr = 1 Then  ; If save wall builder is enable, make sure to reserve builder if enabled
		$iAvailBldr = $iFreeBuilderCount - $iSaveWallBldr
	Else
		$iAvailBldr = $iFreeBuilderCount
	EndIf

	If $iAvailBldr <= 0 Then
		Setlog("No builder available for upgrades", $COLOR_RED)
		Return False
	EndIf

	For $iz = 0 To 5
		If $ichkbxUpgrade[$iz] = 0 Then ContinueLoop ; Is the upgrade checkbox selected?
		If $aUpgrades[$iz][0] <= 0 Or $aUpgrades[$iz][1] <= 0 Or $aUpgrades[$iz][3] = "" Then ContinueLoop ; Now check to see if upgrade manually located?
		If $iAvailBldr <= 0 Then ; Check free builder in case of multiple upgrades
			Setlog("No builder available for upgrade #" & $iz + 1, $COLOR_RED)
			Return False
		EndIf
		SetLog("Checking Upgrade " & $iz + 1, $COLOR_GREEN) ; Tell logfile which upgrade working on.
		If $debugSetlog = 1 Then SetLog("-Upgrade location =  " & "(" & $aUpgrades[$iz][0] & "," & $aUpgrades[$iz][1] & ")", $COLOR_PURPLE) ;Debug
		If _Sleep($iDelayUpgradeBuilding1) Then Return

		Switch $aUpgrades[$iz][3] ;Change action based on upgrade type!
			Case "Gold"
				If $iAvailGold < $aUpgrades[$iz][2] + $itxtUpgrMinGold Then ; Do we have enough Gold?
					SetLog("Insufficent Gold for #" & $iz + 1 & ", requires: " & $aUpgrades[$iz][2] & " + " & $itxtUpgrMinGold, $COLOR_BLUE)
					ContinueLoop
				EndIf
				If UpgradeNormal($iz) = False Then ContinueLoop
				$iUpgradeAction += 2 ^ ($iz + 1)
				Setlog("Gold used = " & $aUpgrades[$iz][2], $COLOR_BLUE)
				$iNbrOfBuildingsUppedGold += 1
				$iCostGoldBuilding += $aUpgrades[$iz][2]
				UpdateStats()
				$iAvailGold -= $aUpgrades[$iz][2]
				$iAvailBldr -= 1
				ContinueLoop
			Case "Elixir"
				If $iAvailElixir < $aUpgrades[$iz][2] + $itxtUpgrMinElixir Then
					SetLog("Insufficent Elixir for #" & $iz + 1 & ", requires: " & $aUpgrades[$iz][2] & " + " & $itxtUpgrMinElixir, $COLOR_BLUE)
					ContinueLoop
				EndIf
				If UpgradeNormal($iz) = False Then ContinueLoop
				$iUpgradeAction += 2 ^ ($iz + 1)
				Setlog("Elixir used = " & $aUpgrades[$iz][2], $COLOR_BLUE)
				$iNbrOfBuildingsUppedElixir += 1
				$iCostElixirBuilding += $aUpgrades[$iz][2]
				UpdateStats()
				$iAvailElixir -= $aUpgrades[$iz][2]
				$iAvailBldr -= 1
				ContinueLoop
			Case "Dark"
				If $iAvailDark  < $aUpgrades[$iz][2] + $itxtUpgrMinDark Then
					SetLog("Insufficent Dark for #" & $iz + 1 & ", requires: " & $aUpgrades[$iz][2] & " + " & $itxtUpgrMinDark, $COLOR_BLUE)
					ContinueLoop
				EndIf
				If UpgradeHero($iz) = False Then ContinueLoop
				$iUpgradeAction += 2 ^ ($iz + 1)
				Setlog("Dark Elixir used = " & $aUpgrades[$iz][2], $COLOR_BLUE)
				$iNbrOfHeroesUpped += 1
				$iCostDElixirHero += $aUpgrades[$iz][2]
				UpdateStats()
				$iAvailDark  -= $aUpgrades[$iz][2]
				$iAvailBldr -= 1
				ContinueLoop
			Case Else
				Setlog("Something went wrong with loot type on Upgradebuilding module on #" & $iz + 1, $COLOR_RED)
				ExitLoop
		EndSwitch
	Next
	If $iUpgradeAction <= 0 Then Setlog("No Upgrades Available", $COLOR_GREEN)
	If _Sleep($iDelayUpgradeBuilding2) Then Return
	checkMainScreen(False)  ; Check for screen errors during function
	Return $iUpgradeAction

EndFunc   ;==>UpgradeBuilding
;
Func UpgradeNormal($inum)
	Click($aUpgrades[$inum][0], $aUpgrades[$inum][1],1,0,"#0296") ; Select the item to be upgrade (clean field)
	If _Sleep($iDelayUpgradeValue1) Then Return
	ClickP($aAway,1,0, "#0211") ;Click Away to close the upgrade window
	If _Sleep($iDelayUpgradeValue1) Then Return
	Click($aUpgrades[$inum][0], $aUpgrades[$inum][1],1,0,"#0296") ; Select the item to be upgrade
	If _Sleep($iDelayUpgradeNormal1) Then Return ; Wait for window to open
	If $aUpgrades[$inum][3] = "Gold" Then
		Local $offColors[3][3] = [[0xD6714B, 47, 37], [0xF0E850, 70, 0], [0xF4F8F2, 79, 0]] ; 2nd pixel brown hammer, 3rd pixel gold, 4th pixel edge of button
		Global $ButtonPixel = _MultiPixelSearch(240, 563 + $bottomOffsetY, 670, 650 + $bottomOffsetY, 1, 1, Hex(0xF3F3F1, 6), $offColors, 30) ; first gray/white pixel of button
		If $debugSetlog = 1 And IsArray($ButtonPixel) Then
			Setlog("ButtonPixel = " & $ButtonPixel[0] & ", " & $ButtonPixel[1], $COLOR_PURPLE) ;Debug
			Setlog("Color #1: " & _GetPixelColor($ButtonPixel[0], $ButtonPixel[1], True) & ", #2: " & _GetPixelColor($ButtonPixel[0] + 47, $ButtonPixel[1] + 37, True) & ", #3: " & _GetPixelColor($ButtonPixel[0] + 70, $ButtonPixel[1], True) & ", #4: " & _GetPixelColor($ButtonPixel[0] + 79, $ButtonPixel[1], True), $COLOR_PURPLE)
		EndIf
	Else ;Use elxir button
		Local $offColors[3][3] = [[0xBC5B31, 38, 32], [0xF84CF9, 72, 0], [0xF5F9F2, 79, 0]] ; 2nd pixel brown hammer, 3rd pixel pink, 4th pixel edge of button
		Global $ButtonPixel = _MultiPixelSearch(240, 563 + $bottomOffsetY, 670, 650 + $bottomOffsetY, 1, 1, Hex(0xF4F7F2, 6), $offColors, 30) ; first gray/white pixel of button
		If $debugSetlog = 1 And IsArray($ButtonPixel) Then
			Setlog("ButtonPixel = " & $ButtonPixel[0] & ", " & $ButtonPixel[1], $COLOR_PURPLE) ;Debug
			Setlog("Color #1: " & _GetPixelColor($ButtonPixel[0], $ButtonPixel[1], True) & ", #2: " & _GetPixelColor($ButtonPixel[0] + 38, $ButtonPixel[1] + 32, True) & ", #3: " & _GetPixelColor($ButtonPixel[0] + 72, $ButtonPixel[1], True) & ", #4: " & _GetPixelColor($ButtonPixel[0] + 79, $ButtonPixel[1], True), $COLOR_PURPLE)
		EndIf
	EndIf
	If IsArray($ButtonPixel) Then
		If _Sleep($iDelayUpgradeNormal2) Then Return
		Click($ButtonPixel[0] + 20, $ButtonPixel[1] + 20,1,0,"#0297") ; Click Upgrade Button
		If _Sleep($iDelayUpgradeNormal3) Then Return ; Wait for window to open
		if $debugImageSave= 1 Then DebugImageSave("UpgradeRegBtn1")
		If _ColorCheck(_GetPixelColor(677, 150 + $midOffsetY, True), Hex(0xE00408, 6), 20) Then ; Check if the building Upgrade window is open
			If _ColorCheck(_GetPixelColor(459, 490 + $midOffsetY, True), Hex(0xE70A12, 6), 20) And _ColorCheck(_GetPixelColor(459, 494 + $midOffsetY), Hex(0xE70A12, 6), 20) And _
					_ColorCheck(_GetPixelColor(459, 498 + $midOffsetY, True), Hex(0xE70A12, 6), 20) Then ; Check for Red Zero = means not enough loot!
				SetLog("Upgrade Fail #" & $inum + 1 & " No Loot!", $COLOR_RED)
				ClickP($aAway, 2,0,"#0298") ;Click Away
				Return False
			Else
				Click(440, 480 + $midOffsetY,1,0,"#0299") ; Click upgrade buttton
				If _Sleep($iDelayUpgradeNormal3) Then Return
				if $debugImageSave= 1 Then DebugImageSave("UpgradeRegBtn2")
				If _ColorCheck(_GetPixelColor(573, 256 + $midOffsetY, True), Hex(0xE1090E, 6), 20) Then ; Redundant Safety Check if the use Gem window opens
					SetLog("Upgrade Fail #" & $inum + 1 & " No Loot!", $COLOR_RED)
					ClickP($aAway, 2,0,"#0300") ;Click Away to close windows
					Return False
				EndIf
				SetLog("Upgrade #" & $inum + 1 & " complete", $COLOR_GREEN)
				$aUpgrades[$inum][0] = -1 ;Reset $UpGrade position coordinate variable to blank to show its completed
				$aUpgrades[$inum][1] = -1
				$aUpgrades[$inum][3] = ""
				GUICtrlSetImage($picUpgradeStatus[$inum], $pIconLib, $eIcnGreenLight) ; Change GUI upgrade status to done
				GUICtrlSetState($chkbxUpgrade[$inum], $GUI_UNCHECKED) ; Change upgrade selection box to unchecked
				ClickP($aAway, 2,0,"#0301") ;Click Away to close windows
				If _Sleep($iDelayUpgradeNormal3) Then Return ; Wait for window to close
				Return True
			EndIf
		Else
			Setlog("Upgrade #" & $inum + 1 & " window open fail", $COLOR_RED)
			ClickP($aAway, 2,0,"#0302") ;Click Away
		EndIf
	Else
		Setlog("Upgrade #" & $inum + 1 & " Error finding button", $COLOR_RED)
		ClickP($aAway, 2,0,"#0303") ;Click Away
		Return False
	EndIf
EndFunc   ;==>UpgradeNormal
;
Func UpgradeHero($inum)
	Click($aUpgrades[$inum][0], $aUpgrades[$inum][1],1,0,"#0304") ; Select the item to be upgrade
	If _Sleep($iDelayUpgradeHero1) Then Return ; Wait for window to open
	Local $offColors[3][3] = [[0x9B4C28, 41, 23], [0x040009, 72, 0], [0xF5F9F2, 79, 0]] ; 2nd pixel brown hammer, 3rd pixel black, 4th pixel edge of button
	Global $ButtonPixel = _MultiPixelSearch(240, 563 + $bottomOffsetY, 670, 620 + $bottomOffsetY, 1, 1, Hex(0xF6F9F3, 6), $offColors, 30) ; first gray/white pixel of button
	If IsArray($ButtonPixel) Then
		If $debugSetlog = 1 And IsArray($ButtonPixel) Then
			Setlog("ButtonPixel = " & $ButtonPixel[0] & ", " & $ButtonPixel[1], $COLOR_PURPLE) ;Debug
			Setlog("Color #1: " & _GetPixelColor($ButtonPixel[0], $ButtonPixel[1], True) & ", #2: " & _GetPixelColor($ButtonPixel[0] + 41, $ButtonPixel[1] + 23, True) & ", #3: " & _GetPixelColor($ButtonPixel[0] + 72, $ButtonPixel[1], True) & ", #4: " & _GetPixelColor($ButtonPixel[0] + 79, $ButtonPixel[1], True), $COLOR_PURPLE)
		EndIf
		If _Sleep($iDelayUpgradeHero2) Then Return
		Click($ButtonPixel[0] + 20, $ButtonPixel[1] + 20,1,0,"#0305") ; Click Upgrade Button
		If _Sleep($iDelayUpgradeHero3) Then Return ; Wait for window to open
		if $debugImageSave= 1 Then DebugImageSave("UpgradeDarkBtn1")
		If _ColorCheck(_GetPixelColor(715, 120 + $midOffsetY, True), Hex(0xE1090E, 6), 20) Then ; Check if the Hero Upgrade window is open
			If _ColorCheck(_GetPixelColor(691, 523 + $midOffsetY, True), Hex(0xE70A12, 6), 20) And _ColorCheck(_GetPixelColor(691, 527 + $midOffsetY), Hex(0xE70A12, 6), 20) And _
					_ColorCheck(_GetPixelColor(691, 531 + $midOffsetY, True), Hex(0xE70A12, 6), 20) Then ; Check for Red Zero = means not enough loot!
				SetLog("Hero Upgrade Fail #" & $inum + 1 & " No DE!", $COLOR_RED)
				ClickP($aAway, 2,0,"#0306") ;Click Away to close window
				Return False
			Else
				Click(660, 515 + $midOffsetY, 1, 0, "#0307") ; Click upgrade buttton
				ClickP($aAway, 1,0,"#0308") ;Click Away to close windows
				If _Sleep($iDelayUpgradeHero1) Then Return
				if $debugImageSave= 1 Then DebugImageSave("UpgradeDarkBtn2")
				If _ColorCheck(_GetPixelColor(573, 256 + $midOffsetY, True), Hex(0xE1090E, 6), 20) Then ; Redundant Safety Check if the use Gem window opens
					SetLog("Upgrade Fail #" & $inum + 1 & " No DE!", $COLOR_RED)
					ClickP($aAway, 2,0,"#0309") ;Click Away to close windows
					Return False
				EndIf
				SetLog("Hero Upgrade #" & $inum + 1 & " complete", $COLOR_GREEN)
				$aUpgrades[$inum][0] = -1 ;Reset $UpGrade position coordinate variable to blank to show its completed
				$aUpgrades[$inum][1] = -1
				$aUpgrades[$inum][3] = ""
				GUICtrlSetImage($picUpgradeStatus[$inum],  $pIconLib, $eIcnGreenLight) ; Change GUI upgrade status to done
				GUICtrlSetState($chkbxUpgrade[$inum], $GUI_UNCHECKED) ; Change upgrade selection box to unchecked
				ClickP($aAway, 2,0,"#0310") ;Click Away to close windows
				If _Sleep($iDelayUpgradeHero2) Then Return ; Wait for window to close
				Return True
			EndIf
		Else
			Setlog("Upgrade #" & $inum + 1 & " window open fail", $COLOR_RED)
			ClickP($aAway, 2,0,"#0311") ;Click Away to close windows
		EndIf
	Else
		Setlog("Upgrade #" & $inum + 1 & " Error finding button", $COLOR_RED)
		ClickP($aAway, 2,0,"#0312") ;Click Away to close windows
		Return False
	EndIf
EndFunc   ;==>UpgradeHero
