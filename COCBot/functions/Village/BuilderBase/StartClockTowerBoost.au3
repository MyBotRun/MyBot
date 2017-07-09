; #FUNCTION# ====================================================================================================================
; Name ..........: StartClockTowerBoost
; Description ...:
; Syntax ........: StartClockTowerBoost($bSwitchToBB = False, $bSwitchToNV = False)
; Parameters ....: $bSwitchToBB: Switch from Normal Village to Builder Base - $bSwitchToNV: Switch back to normal Village after Function ran
; Return values .: None
; Author ........: Fliegerfaust (06-2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func StartClockTowerBoost($bSwitchToBB = False, $bSwitchToNV = False)

	If Not $g_bChkStartClockTowerBoost Then Return

	If Not $g_bRunState Then Return

	Local $aClockTowerCoords, $aStartClockTowerBoost

	If $bSwitchToBB Then
		ClickP($aAway, 1, 0, "#0332") ;Click Away
		If Not SwitchBetweenBases() Then Return ; Switching to Builders Base
	EndIf

	getBuilderCount(True, True) ; Update Builder Variables for Builders Base

	If $g_iFreeBuilderCountBB = $g_iTotalBuilderCountBB Then ; Builder is not busy, skip Boost to prevent a useless one
		SetLog("Skip Clock Tower Boost as no Building is currently under Upgrade! Boost would be a waste!", $COLOR_INFO)
	Else ; Start Boosting
		SetLog("Boosting your Clock Tower now!", $COLOR_INFO)
		If _Sleep($DELAYCOLLECT2) Then Return

		$aClockTowerCoords = findImage("ClockTowerAvailable", @ScriptDir & "\imgxml\Resources\BuildersBase\ClockTower\ClockTowerAvailable_0_89.xml", "DCD", 1, True)
		If IsArray($aClockTowerCoords) And IsNumber($aClockTowerCoords[0]) Then
			ClickP($aClockTowerCoords) ; Click on the found Clock Tower Coordinates
			If _Sleep($DELAYCLOCKTOWER1) Then Return

			$aStartClockTowerBoost = findButton("StartClockTowerBoost") ; Search for Start Clock Tower Boost Button
			If IsArray($aStartClockTowerBoost) And IsNumber($aStartClockTowerBoost[0]) Then ; Check if findButton returned proper Coordinates
				ClickP($aStartClockTowerBoost) ; Boost Clock Tower
				If _Sleep($DELAYCLOCKTOWER1) Then Return

				If _CheckPixel($aConfirmBoost) Then ; Check if Confirm Boost is open
					ClickP($aConfirmBoost)
					If _Sleep($DELAYCLOCKTOWER2) Then Return
					SetLog("Boosted your Clock Tower successfully!", $COLOR_SUCCESS)
				Else
					SetLog("Failed to verify the Confirm Boost Button", $COLOR_ERROR)
				EndIf
			Else
				SetLog("Cannot find the Boost Button of your Clock Tower", $COLOR_ERROR)
			EndIf
		Else
			SetLog("Cannot find the Clock Tower on your Builder Base, seems like there is no boost available or it is still broken!", $COLOR_INFO)
		EndIf
	EndIf

	If $bSwitchToNV Then SwitchBetweenBases() ; Switching back to the normal Village if true
EndFunc   ;==>StartClockTowerBoost
