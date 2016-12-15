; #FUNCTION# ====================================================================================================================
; Name ..........: 
; Description ...: This function will update the statistics in the GUI.
; Syntax ........: 
; Parameters ....: None
; Return values .: None
; Author ........: Boju (11-2016)
; Modified ......: 
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......:
; ===============================================================================================================================

Func StartGainCost()
	$TempGainCost[0] = 0
	$TempGainCost[1] = 0
	$TempGainCost[2] = 0
	VillageReport(True, True)
	Local $tempCounter = 0
	While ($iGoldCurrent = "" Or $iElixirCurrent = "" Or ($iDarkCurrent = "" And $iDarkStart <> "")) And $tempCounter < 5
		$tempCounter += 1
		If _Sleep(100) Then Return
		VillageReport(True, True)
	WEnd
	$TempGainCost[0] = $iGoldCurrent ;$tempGold
	$TempGainCost[1] = $iElixirCurrent ;$tempElixir
	$TempGainCost[2] = $iDarkCurrent ;$tempDElixir
EndFunc   ;==>StartGainCost

Func EndGainCost($Type)
	VillageReport(True, True)
	$tempCounter = 0
	While ($iGoldCurrent = "" Or $iElixirCurrent = "" Or ($iDarkCurrent = "" And $iDarkStart <> "")) And $tempCounter < 5
		$tempCounter += 1
		VillageReport(True, True)
	WEnd

	Switch $Type
		Case "Collect"
			Local $tempGoldCollected = 0
			Local $tempElixirCollected = 0
			Local $tempDElixirCollected = 0
			
			If $TempGainCost[0] <> "" And $iGoldCurrent <> "" And $TempGainCost[0] <> $iGoldCurrent Then
				$tempGoldCollected = $iGoldCurrent - $TempGainCost[0]
				$iGoldFromMines += $tempGoldCollected
				$iGoldTotal += $tempGoldCollected
			EndIf

			If $TempGainCost[1] <> "" And $iElixirCurrent <> "" And $TempGainCost[1] <> $iElixirCurrent Then
				$tempElixirCollected = $iElixirCurrent - $TempGainCost[1]
				$iElixirFromCollectors += $tempElixirCollected
				$iElixirTotal += $tempElixirCollected
			EndIf

			If $TempGainCost[2] <> "" And $iDarkCurrent <> "" And $TempGainCost[2] <> $iDarkCurrent Then
				$tempDElixirCollected = $iDarkCurrent - $TempGainCost[2]
				$iDElixirFromDrills += $tempDElixirCollected
				$iDarkTotal += $tempDElixirCollected
			EndIf
		Case "Train"
			Local $tempElixirSpent = 0
			Local $tempDElixirSpent = 0
			If $TempGainCost[1] <> "" And $iElixirCurrent <> ""  And $TempGainCost[1] <> $iElixirCurrent Then
				$tempElixirSpent = ($TempGainCost[1] - $iElixirCurrent)
				$iTrainCostElixir += $tempElixirSpent
				$iElixirTotal -= $tempElixirSpent
			EndIf

			If $TempGainCost[2] <> "" And $iDarkCurrent <> ""  And $TempGainCost[2] <> $iDarkCurrent Then
				$tempDElixirSpent = ($TempGainCost[2] - $iDarkCurrent)
				$iTrainCostDElixir += $tempDElixirSpent
				$iDarkTotal -= $tempDElixirSpent
			EndIf
	EndSwitch

	UpdateStats()
EndFunc   ;==>StartGainCost