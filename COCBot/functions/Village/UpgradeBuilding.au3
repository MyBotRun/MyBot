; #FUNCTION# ====================================================================================================================
; Name ..........: UpgradeBuilding.au3
; Description ...: Upgrades buildings if loot and builders are available
; Syntax ........: UpgradeBuilding(), UpgradeNormal($inum), UpgradeHero($inum)
; Parameters ....: $inum = array index [0-3]
; Return values .:
; Author ........: KnowJack (April-2015)
; Modified ......: KnowJack (Jun/Aug-2015),Sardo 2015-08,Monkeyhunter(2106-2)
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
	Local $Endtime, $Endperiod, $TimeAdd
	Local $iUpGrdEndTimeDiff = 0
	Local $aCheckFrequency[9] = [5, 15, 20, 30, 60, 60, 120, 240, 240] ; Dwell Time in minutes between each repeat upgrade check TH3-11
	;  $aCheckFrequency[($iTownHallLevel < 3 ? 0 : $iTownHallLevel - 3)]  ; returns dwell time based on user THlevel, range from 3=[0] to 11=[7]
	Local $iDTDiff
	Local $bChkAllRptUpgrade = False

	Static Local $sNextCheckTime = _DateAdd("n", -1, _NowCalc()) ; initialize with date/time of NOW minus one minute
	If @error Then _logErrorDateAdd(@error)

	$itxtUpgrMinGold = Number($itxtUpgrMinGold)
	$itxtUpgrMinElixir = Number($itxtUpgrMinElixir)
	$itxtUpgrMinDark = Number($itxtUpgrMinDark)

	; check to see if anything is enabled before wasting time.
	For $iz = 0 To UBound($aUpgrades, 1) - 1
		If $ichkbxUpgrade[$iz] = 1 Then
			$iUpgradeAction += 2 ^ ($iz + 1)
		EndIf
	Next
	If $iUpgradeAction < 0 Then Return False
	$iUpgradeAction = 0 ; Reset action

	Setlog("Checking Upgrades", $COLOR_BLUE)

	VillageReport(True, True) ; Get current loot available after training troops and update free builder status
	$iAvailGold = Number($iGoldCurrent)
	$iAvailElixir = Number($iElixirCurrent)
	$iAvailDark = Number($iDarkCurrent)

	If $iSaveWallBldr = 1 Then ; If save wall builder is enable, make sure to reserve builder if enabled
		$iAvailBldr = $iFreeBuilderCount - $iSaveWallBldr
	Else
		$iAvailBldr = $iFreeBuilderCount
	EndIf

	If $iAvailBldr <= 0 Then
		Setlog("No builder available for upgrade process", $COLOR_RED)
		Return False
	EndIf

	For $iz = 0 To UBound($aUpgrades, 1) - 1

		If $debugSetlog = 1 Then SetlogUpgradeValues($iz) ; massive debug data dump for each upgrade

		If $ichkbxUpgrade[$iz] = 0 Then ContinueLoop ; Is the upgrade checkbox selected?

		If $aUpgrades[$iz][0] <= 0 Or $aUpgrades[$iz][1] <= 0 Or $aUpgrades[$iz][3] = "" Then ContinueLoop ; Now check to see if upgrade has locatation?

		; Check free builder in case of multiple upgrades, but skip check when time to check repeated upgrades.
		If $iAvailBldr <= 0 And $bChkAllRptUpgrade = False Then
			Setlog("No builder available for #" & $iz + 1 & ", " & $aUpgrades[$iz][4], $COLOR_RED)
			Return False
		EndIf

		If $ichkUpgrdeRepeat[$iz] = 1 Then ; if repeated upgrade, may need to check upgrade value

			If $bChkAllRptUpgrade = False Then
				$iDTDiff = Int(_DateDiff("n", _NowCalc(), $sNextCheckTime)) ; get date/time difference for repeat upgrade check
				If @error Then _logErrorDateDiff(@error)
				If $debugSetlog = 1 Then
					Setlog("Delay time between repeat upgrade checks = " & $aCheckFrequency[($iTownHallLevel < 3 ? 0 : $iTownHallLevel - 3)] & " Min", $COLOR_PURPLE)
					SetLog("Delay time remaining = " & $iDTDiff & " Min", $COLOR_PURPLE)
				EndIf
				If $iDTDiff < 0 Then ; check dwell time clock to avoid checking repeats too often
					$sNextCheckTime = _DateAdd("n", $aCheckFrequency[($iTownHallLevel < 3 ? 0 : $iTownHallLevel - 3)], _NowCalc()) ; create new check date/time
					If @error Then _logErrorDateAdd(@error) ; log Date function errors
					$bChkAllRptUpgrade = True ; set flag to allow entire array of updates to get updated values if delay time is past.
					If $debugSetlog = 1 Then SetLog("New delayed check time=  " & $sNextCheckTime, $COLOR_PURPLE)
				EndIf
			EndIf

			If _DateIsValid($aUpgrades[$iz][7]) Then ; check for valid date in upgrade array
				$iUpGrdEndTimeDiff = Int(_DateDiff("n", _NowCalc(), $aUpgrades[$iz][7])) ; what is difference between End time and now in minutes?
				If @error Then ; trap/log errors and zero time difference
					_logErrorDateDiff(@error)
					$iUpGrdEndTimeDiff = 0
				EndIf
				If $debugSetlog = 1 Then SetLog("Difference between upgrade end and NOW= " & $iUpGrdEndTimeDiff & " Min", $COLOR_PURPLE)
			EndIf

			If $bChkAllRptUpgrade = True Or $iUpGrdEndTimeDiff < 0 Then ; when past delay time or past end time for previous upgrade then check status
				If UpgradeValue($iz, True) = False Then ; try to get new upgrade values
					If $debugSetlog = 1 Then SetlogUpgradeValues($iz) ; Debug data for when upgrade is not ready or done repeating
					Setlog("Repeat upgrade #" & $iz + 1 & " " & $aUpgrades[$iz][4] & " not ready yet", $COLOR_RED)
					ContinueLoop ; Not ready yet..
				ElseIf ($iAvailBldr <= 0) Then
					; must stop upgrade attempt if no builder here, due bypass of available builder check when $bChkAllRptUpgrade=true to get updated building values.
					Setlog("No builder available for " & $aUpgrades[$iz][4], $COLOR_RED)
					ContinueLoop
				EndIf
			EndIf
		EndIf

		SetLog("Upgrade #" & $iz + 1 & " " & $aUpgrades[$iz][4] & " Selected", $COLOR_GREEN) ; Tell logfile which upgrade working on.
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
			Case "Dark"
				If $iAvailDark < $aUpgrades[$iz][2] + $itxtUpgrMinDark Then
					SetLog("Insufficent Dark for #" & $iz + 1 & ", requires: " & $aUpgrades[$iz][2] & " + " & $itxtUpgrMinDark, $COLOR_BLUE)
					ContinueLoop
				EndIf
				If UpgradeHero($iz) = False Then ContinueLoop
				$iUpgradeAction += 2 ^ ($iz + 1)
				Setlog("Dark Elixir used = " & $aUpgrades[$iz][2], $COLOR_BLUE)
				$iNbrOfHeroesUpped += 1
				$iCostDElixirHero += $aUpgrades[$iz][2]
				UpdateStats()
				$iAvailDark -= $aUpgrades[$iz][2]
				$iAvailBldr -= 1
			Case Else
				Setlog("Something went wrong with loot type on Upgradebuilding module on #" & $iz + 1, $COLOR_RED)
				ExitLoop
		EndSwitch

		$aUpgrades[$iz][7] = _NowCalc() ; what is date:time now
		If $debugSetlog = 1 Then SetLog("Upgrade #" & $iz + 1 & " " & $aUpgrades[$iz][4] & " Started @ " & $aUpgrades[$iz][7], $COLOR_GREEN)
		$Endtime = ""
		$Endperiod = ""
		$TimeAdd = 0
		$aArray = StringRegExp($aUpgrades[$iz][6], '\d+', 1) ; get the digits
		If IsArray($aArray) Then
			If $debugSetlog = 1 Then
				For $i = 0 To UBound($aArray) - 1
					Setlog("Stripped Time Value $aArray[" & $i & "] = " & $aArray[$i], $COLOR_PURPLE)
				Next
			EndIf
			$Endtime = $aArray[0]
			$Endperiod = StringReplace($aUpgrades[$iz][6], $Endtime, "") ; get the time period
			$Endperiod = StringReplace($Endperiod, " ", "") ;remove extra spaces
			Switch $Endperiod
				Case "D"
					$TimeAdd = (Int($Endtime) * 24 * 60) - 10 ; change days to minutes, minus 10 minute
					$aUpgrades[$iz][7] = _DateAdd('n', $TimeAdd, $aUpgrades[$iz][7]) ; add the time required to finish the  upgrade
				Case "H"
					$TimeAdd = (Int($Endtime) * 60) - 3 ; change hours to minutes, minus 3 minutes
					$aUpgrades[$iz][7] = _DateAdd('n', $TimeAdd, $aUpgrades[$iz][7]) ; add the time required to finish the  upgrade
				Case "M"
					$TimeAdd = Int($Endtime) ; change to minutes
					$aUpgrades[$iz][7] = _DateAdd('n', $TimeAdd, $aUpgrades[$iz][7]) ; add the time required to finish the  upgrade
				Case Else
					Setlog("Upgrade #" & $iz + 1 & " time period invalid, try again!", $COLOR_RED)
			EndSwitch
			If $debugSetlog = 1 Then Setlog("$EndTime = " & $Endtime & " , $EndPeriod = " & $Endperiod & ", $timeadd = " & $TimeAdd, $COLOR_PURPLE)
			SetLog("Upgrade #" & $iz + 1 & " " & $aUpgrades[$iz][4] & " Finishes @ " & $aUpgrades[$iz][7], $COLOR_GREEN)
		Else
			Setlog("Non critical error processing upgrade time for " & "#" & $iz + 1 & ": " & $aUpgrades[$iz][4], $COLOR_FUCHSIA)
		EndIf

	Next
	If $iUpgradeAction <= 0 Then
		Setlog("No Upgrades Available", $COLOR_GREEN)
	Else
		saveConfig()
	EndIf
	If _Sleep($iDelayUpgradeBuilding2) Then Return
	checkMainScreen(False) ; Check for screen errors during function
	Return $iUpgradeAction

EndFunc   ;==>UpgradeBuilding
;
Func UpgradeNormal($inum)

	Local $aResult

	ClickP($aAway, 1, 0, "#0211") ;Click Away to close the upgrade window
	If _Sleep($iDelayUpgradeNormal1) Then Return

	Click($aUpgrades[$inum][0], $aUpgrades[$inum][1], 1, 0, "#0296") ; Select the item to be upgrade
	If _Sleep($iDelayUpgradeNormal1) Then Return ; Wait for window to open

	$aResult = BuildingInfo(242, 520 + $bottomOffsetY) ; read building name/level to check we have right bldg or if collector was not full

	If StringStripWS($aResult[1], BitOR($STR_STRIPLEADING, $STR_STRIPTRAILING)) <> StringStripWS($aUpgrades[$inum][4], BitOR($STR_STRIPLEADING, $STR_STRIPTRAILING)) Then ; check bldg names

		SetLog("#" & $inum + 1 & ":" & $aUpgrades[$inum][4] & ": Not same as :" & $aResult[1] & ":? Retry now...", $COLOR_BLUE)
		ClickP($aAway, 1, 0, "#0211") ;Click Away to close window
		If _Sleep($iDelayUpgradeNormal1) Then Return

		Click($aUpgrades[$inum][0], $aUpgrades[$inum][1], 1, 0, "#0296") ; Select the item to be upgrade again in case full collector/mine
		If _Sleep($iDelayUpgradeNormal1) Then Return ; Wait for window to open

		$aResult = BuildingInfo(242, 520 + $bottomOffsetY) ; read building name/level to check we have right bldg or if collector was not full
		If $aResult[0] > 1 Then
			If StringStripWS($aResult[1], BitOR($STR_STRIPLEADING, $STR_STRIPTRAILING)) <> StringStripWS($aUpgrades[$inum][4], BitOR($STR_STRIPLEADING, $STR_STRIPTRAILING)) Then ; check bldg names
				SetLog("Found #" & $inum + 1 & ":" & $aUpgrades[$inum][4] & ": Not same as : " & $aResult[1] & ":, May need new location?", $COLOR_RED)
				Return False
			EndIf
		EndIf
	EndIf

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
		Click($ButtonPixel[0] + 20, $ButtonPixel[1] + 20, 1, 0, "#0297") ; Click Upgrade Button
		If _Sleep($iDelayUpgradeNormal3) Then Return ; Wait for window to open
		If $debugImageSave = 1 Then DebugImageSave("UpgradeRegBtn1")
		If _ColorCheck(_GetPixelColor(677, 150 + $midOffsetY, True), Hex(0xE00408, 6), 20) Then ; Check if the building Upgrade window is open
			If _ColorCheck(_GetPixelColor(459, 490 + $midOffsetY, True), Hex(0xE70A12, 6), 20) And _ColorCheck(_GetPixelColor(459, 494 + $midOffsetY), Hex(0xE70A12, 6), 20) And _
					_ColorCheck(_GetPixelColor(459, 498 + $midOffsetY, True), Hex(0xE70A12, 6), 20) Then ; Check for Red Zero = means not enough loot!

				SetLog("Upgrade Fail #" & $inum + 1 & " " & $aUpgrades[$inum][4] & ", No Loot!", $COLOR_RED)

				ClickP($aAway, 2, 0, "#0298") ;Click Away
				Return False
			Else
				Click(440, 480 + $midOffsetY, 1, 0, "#0299") ; Click upgrade buttton
				If _Sleep($iDelayUpgradeNormal3) Then Return
				If $debugImageSave = 1 Then DebugImageSave("UpgradeRegBtn2")
				If _ColorCheck(_GetPixelColor(573, 256 + $midOffsetY, True), Hex(0xE1090E, 6), 20) Then ; Redundant Safety Check if the use Gem window opens
					SetLog("Upgrade Fail #" & $inum + 1 & " " & $aUpgrades[$inum][4] & " No Loot!", $COLOR_RED)
					ClickP($aAway, 2, 0, "#0300") ;Click Away to close windows
					Return False
				EndIf
				SetLog("Upgrade #" & $inum + 1 & " " & $aUpgrades[$inum][4] & " started", $COLOR_GREEN)
				GUICtrlSetImage($picUpgradeStatus[$inum], $pIconLib, $eIcnGreenLight) ; Change GUI upgrade status to done
				$ipicUpgradeStatus[$inum] = $eIcnGreenLight ; Change GUI upgrade status to done
				GUICtrlSetData($txtUpgradeValue[$inum], -($aUpgrades[$inum][2])) ; Show Negative Upgrade value in GUI
				;$itxtUpgradeValue[$inum] = -($aUpgrades[$inum][2]) ; Show Negative Upgrade value in GUI
				GUICtrlSetData($txtUpgradeLevel[$inum], $aUpgrades[$inum][5] & "+") ; Set GUI level to match $aUpgrades variable
				$itxtUpgradeLevel[$inum] = $aUpgrades[$inum][5] & "+" ; Set GUI level to match $aUpgrades variable
				If $ichkUpgrdeRepeat[$inum] = 0 Then ; Check for repeat upgrade
					GUICtrlSetState($chkbxUpgrade[$inum], $GUI_UNCHECKED) ; Change upgrade selection box to unchecked
					$ichkbxUpgrade[$inum] = 0 ; Change upgrade selection box to unchecked
					$aUpgrades[$inum][0] = -1 ;Reset $UpGrade position coordinate variable to blank to show its completed
					$aUpgrades[$inum][1] = -1
					$aUpgrades[$inum][3] = "" ; Reset loot type
					GUICtrlSetData($txtUpgradeLevel[$inum], $aUpgrades[$inum][5] & "+") ; Set GUI level to match $aUpgrades variable
					$aUpgrades[$inum][5] = $aUpgrades[$inum][5] & "+" ; Set GUI level to match $aUpgrades variable
				ElseIf $ichkUpgrdeRepeat[$inum] = 1 Then
					GUICtrlSetState($chkbxUpgrade[$inum], $GUI_CHECKED) ; Ensure upgrade selection box is checked
					$ichkbxUpgrade[$inum] = 1 ; Ensure upgrade selection box is checked
				EndIf
				ClickP($aAway, 2, 0, "#0301") ;Click Away to close windows
				If _Sleep($iDelayUpgradeNormal3) Then Return ; Wait for window to close

				Return True
			EndIf
		Else
			Setlog("Upgrade #" & $inum + 1 & " window open fail", $COLOR_RED)
			ClickP($aAway, 2, 0, "#0302") ;Click Away
		EndIf
	Else
		Setlog("Upgrade #" & $inum + 1 & " Error finding button", $COLOR_RED)
		ClickP($aAway, 2, 0, "#0303") ;Click Away
		Return False
	EndIf
EndFunc   ;==>UpgradeNormal
;
Func UpgradeHero($inum)

	Click($aUpgrades[$inum][0], $aUpgrades[$inum][1], 1, 0, "#0304") ; Select the item to be upgrade
	If _Sleep($iDelayUpgradeHero1) Then Return ; Wait for window to open

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
		If $debugImageSave = 1 Then DebugImageSave("UpgradeDarkBtn1")
		If _ColorCheck(_GetPixelColor(715, 120 + $midOffsetY, True), Hex(0xE1090E, 6), 20) Then ; Check if the Hero Upgrade window is open
			If _ColorCheck(_GetPixelColor(691, 523 + $midOffsetY, True), Hex(0xE70A12, 6), 20) And _ColorCheck(_GetPixelColor(691, 527 + $midOffsetY), Hex(0xE70A12, 6), 20) And _
					_ColorCheck(_GetPixelColor(691, 531 + $midOffsetY, True), Hex(0xE70A12, 6), 20) Then ; Check for Red Zero = means not enough loot!
				SetLog("Hero Upgrade Fail #" & $inum + 1 & " " & $aUpgrades[$inum][4] & " No DE!", $COLOR_RED)
				ClickP($aAway, 2, 0, "#0306") ;Click Away to close window
				Return False
			Else
				Click(660, 515 + $midOffsetY, 1, 0, "#0307") ; Click upgrade buttton
				ClickP($aAway, 1, 0, "#0308") ;Click Away to close windows
				If _Sleep($iDelayUpgradeHero1) Then Return
				If $debugImageSave = 1 Then DebugImageSave("UpgradeDarkBtn2")
				If _ColorCheck(_GetPixelColor(573, 256 + $midOffsetY, True), Hex(0xE1090E, 6), 20) Then ; Redundant Safety Check if the use Gem window opens
					SetLog("Upgrade Fail #" & $inum + 1 & " " & $aUpgrades[$inum][4] & " No DE!", $COLOR_RED)
					ClickP($aAway, 2, 0, "#0309") ;Click Away to close windows
					Return False
				EndIf
				SetLog("Hero Upgrade #" & $inum + 1 & " " & $aUpgrades[$inum][4] & " started", $COLOR_GREEN)
				GUICtrlSetImage($picUpgradeStatus[$inum], $pIconLib, $eIcnGreenLight) ; Change GUI upgrade status to done
				$ipicUpgradeStatus[$inum] = $eIcnGreenLight ; Change GUI upgrade status to done
				GUICtrlSetData($txtUpgradeValue[$inum], -($aUpgrades[$inum][2])) ; Show Negative Upgrade value in GUI
				;$itxtUpgradeValue[$inum] = -($aUpgrades[$inum][2]) ; Show Negative Upgrade value in GUI
				GUICtrlSetData($txtUpgradeLevel[$inum], $aUpgrades[$inum][5] & "+") ; Set GUI level to match $aUpgrades variable
				$itxtUpgradeLevel[$inum] = $aUpgrades[$inum][5] & "+" ; Set GUI level to match $aUpgrades variable
				If $ichkUpgrdeRepeat[$inum] = 0 Then ; Check for repeat upgrade
					GUICtrlSetState($chkbxUpgrade[$inum], $GUI_UNCHECKED) ; Change upgrade selection box to unchecked
					$ichkbxUpgrade[$inum] = 0 ; Change upgrade selection box to unchecked
					$aUpgrades[$inum][0] = -1 ;Reset $UpGrade position coordinate variable to blank to show its completed
					$aUpgrades[$inum][1] = -1
					$aUpgrades[$inum][3] = "" ; Reset loot type
					GUICtrlSetData($txtUpgradeLevel[$inum], $aUpgrades[$inum][5] & "+") ; Set GUI level to match $aUpgrades variable
					$aUpgrades[$inum][5] = $aUpgrades[$inum][5] & "+" ; Set GUI level to match $aUpgrades variable
				ElseIf $ichkUpgrdeRepeat[$inum] = 1 Then
					GUICtrlSetState($chkbxUpgrade[$inum], $GUI_CHECKED) ; Ensure upgrade selection box is checked
					$ichkbxUpgrade[$inum] = 1 ; Ensure upgrade selection box is checked
				EndIf
				ClickP($aAway, 2, 0, "#0310") ;Click Away to close windows
				If _Sleep($iDelayUpgradeHero2) Then Return ; Wait for window to close
				Return True
			EndIf
		Else
			Setlog("Upgrade #" & $inum + 1 & " window open fail", $COLOR_RED)
			ClickP($aAway, 2, 0, "#0311") ;Click Away to close windows
		EndIf
	Else
		Setlog("Upgrade #" & $inum + 1 & " Error finding button", $COLOR_RED)
		ClickP($aAway, 2, 0, "#0312") ;Click Away to close windows
		Return False
	EndIf
EndFunc   ;==>UpgradeHero

Func SetlogUpgradeValues($i)
	Local $j
	For $j = 0 To UBound($aUpgrades, 2) - 1
		Setlog("$aUpgrades[" & $i & "][" & $j & "]= " & $aUpgrades[$i][$j], $COLOR_PURPLE)
	Next
	;Setlog("$chkbxUpgrade= " & GUICtrlRead($chkbxUpgrade[$i]) & "|" & $ichkbxUpgrade[$i], $COLOR_PURPLE) ; upgrade selection box
	;Setlog("$txtUpgradeName= " & GUICtrlRead($txtUpgradeName[$i]) & "|" &  $aUpgrades[$i][4], $COLOR_PURPLE) ;  Unit Name
	;Setlog("$txtUpgradeLevel= " & GUICtrlRead($txtUpgradeLevel[$i]) & "|" & $itxtUpgradeLevel[$i], $COLOR_PURPLE) ; Unit Level
	;Setlog("$picUpgradeType= " & GUICtrlRead($picUpgradeType[$i]) & "|" & $ipicUpgradeStatus[$i], $COLOR_PURPLE) ; status image
	;Setlog("$txtUpgradeValue= " & GUICtrlRead($txtUpgradeValue[$i]) & "|" & $aUpgrades[$i][2], $COLOR_PURPLE) ; Upgrade value
	;Setlog("$txtUpgradeTime= " & GUICtrlRead($txtUpgradeTime[$i]) & "|" & $aUpgrades[$i][6], $COLOR_PURPLE) ; Upgrade time
	;Setlog("$chkUpgrdeRepeat= " & GUICtrlRead($chkUpgrdeRepeat[$i]) & "|" & $ichkUpgrdeRepeat, $COLOR_PURPLE) ; repeat box
	Setlog("$chkbxUpgrade= " & $ichkbxUpgrade[$i], $COLOR_PURPLE) ; upgrade selection box
	Setlog("$txtUpgradeName= " & $aUpgrades[$i][4], $COLOR_PURPLE) ;  Unit Name
	Setlog("$txtUpgradeLevel= " & $itxtUpgradeLevel[$i], $COLOR_PURPLE) ; Unit Level
	Setlog("$picUpgradeType= " & $ipicUpgradeStatus[$i], $COLOR_PURPLE) ; status image
	Setlog("$txtUpgradeValue= " & $aUpgrades[$i][2], $COLOR_PURPLE) ; Upgrade value
	Setlog("$txtUpgradeTime= " & $aUpgrades[$i][6], $COLOR_PURPLE) ; Upgrade time
	Setlog("$chkUpgrdeRepeat= " & $ichkUpgrdeRepeat, $COLOR_PURPLE) ; repeat box
EndFunc   ;==>SetlogUpgradeValues
