; #FUNCTION# ====================================================================================================================
; Name ..........: StartClockTowerBoost
; Description ...:
; Syntax ........: StartClockTowerBoost($bSwitchToBB = False, $bSwitchToNV = False)
; Parameters ....: $bSwitchToBB: Switch from Normal Village to Builder Base - $bSwitchToNV: Switch back to normal Village after Function ran
; Return values .: None
; Author ........: Fliegerfaust (06-2017), MMHK (07-2017)
; Modified ......: Moebius14 (07-2023)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func ClockTimeGained()
Local $aResult = BuildingInfo(242, 468 + $g_iBottomOffsetY)
Local $TowerClockLevel = $aResult[2]
SetLog("Clock Tower Level " & $TowerClockLevel & " Detected")
Local $ClockTimeGained = 0
	Switch $TowerClockLevel
		Case 1
			$ClockTimeGained = 126 ;boost lenght*(10-1) <=> boost lenght*9
		Case 2
			$ClockTimeGained = 144
		Case 3
			$ClockTimeGained = 162
		Case 4
			$ClockTimeGained = 180
		Case 5
			$ClockTimeGained = 198
		Case 6
			$ClockTimeGained = 216
		Case 7
			$ClockTimeGained = 236
		Case 8
			$ClockTimeGained = 252
		Case 9
			$ClockTimeGained = 270
		Case 10
			$ClockTimeGained = 288
		Case Else
			$ClockTimeGained = 270;30 minutes boost(?)
	EndSwitch
Return $ClockTimeGained
EndFunc

Func StartClockTowerBoost($bSwitchToBB = False, $bSwitchToNV = False)

	If Not $g_bChkStartClockTowerBoost Then Return
	If Not $g_bRunState Then Return
	
	Local $TimeGained = 0

	If $bSwitchToBB Then
		ClickAway()
		If Not SwitchBetweenBases(True, True) Then Return ; Switching to Builders Base
	EndIf

	Local $bCTBoost = True
	If $g_bChkCTBoostBlderBz Then
		getBuilderCount(True, True) ; Update Builder Variables for Builders Base
		If $g_iFreeBuilderCountBB = $g_iTotalBuilderCountBB Then $bCTBoost = False ; Builder is not busy, skip Boost
	EndIf

	If Not $bCTBoost Then
		SetLog("Skip Clock Tower Boost as no Building is currently under Upgrade!", $COLOR_INFO)
	Else ; Start Boosting
		SetLog("Boosting Clock Tower", $COLOR_INFO)
		If _Sleep($DELAYCOLLECT2) Then Return

		Local $sCTCoords, $aCTCoords, $aCTBoost
		$sCTCoords = findImage("ClockTowerAvailable", $g_sImgStartCTBoost, "FV", 1, True) ; Search for Clock Tower
		If $sCTCoords <> "" Then
			$aCTCoords = StringSplit($sCTCoords, ",", $STR_NOCOUNT)
			ClickP($aCTCoords)
			If _Sleep($DELAYCLOCKTOWER1) Then Return
			$TimeGained = ClockTimeGained()

			$aCTBoost = findButton("BoostCT") ; Search for Start Clock Tower Boost Button
			If IsArray($aCTBoost) Then
				ClickP($aCTBoost)
				If _Sleep($DELAYCLOCKTOWER1) Then Return

				$aCTBoost = findButton("BOOSTBtn") ; Search for Boost Button
				If IsArray($aCTBoost) Then
					ClickP($aCTBoost)
					If _Sleep($DELAYCLOCKTOWER2) Then Return
					SetLog("Boosted Clock Tower successfully!", $COLOR_SUCCESS)
					If $iStarLabFinishTimeMod > 0 Then
						$g_sStarLabUpgradeTime = _DateAdd('n', Ceiling($iStarLabFinishTimeMod - $TimeGained), _NowCalc())
						SetLog("Recalculate Research Time, Boosting Clock Tower (" & $g_sStarLabUpgradeTime & ")")
						StarLabStatusGUIUpdate()
					EndIf
				Else
					SetLog("Failed to find the BOOST window button", $COLOR_ERROR)
				EndIf
			Else
				SetLog("Cannot find the Boost Button of Clock Tower", $COLOR_ERROR)
			EndIf
		Else
			SetLog("Clock Tower boost is not available!")
		EndIf
	EndIf
	ClickAway()
	If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")

	If $bSwitchToNV Then SwitchBetweenBases() ; Switching back to the normal Village if true
EndFunc   ;==>StartClockTowerBoost
