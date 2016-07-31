; #FUNCTION# ====================================================================================================================
; Name ..........: UpdateStats
; Description ...: This function will update the statistics in the GUI.
; Syntax ........: UpdateStats()
; Parameters ....: None
; Return values .: None
; Author ........: kaganus (2015-jun-20)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......:
; ===============================================================================================================================

Global $ResetStats = 0
Global $iOldFreeBuilderCount, $iOldTotalBuilderCount, $iOldGemAmount ; builder and gem amounts
Global $iOldGoldCurrent, $iOldElixirCurrent, $iOldDarkCurrent, $iOldTrophyCurrent ; current stats
Global $iOldGoldTotal, $iOldElixirTotal, $iOldDarkTotal, $iOldTrophyTotal ; total stats
Global $iOldGoldLast, $iOldElixirLast, $iOldDarkLast, $iOldTrophyLast ; loot and trophy gain from last raid
Global $iOldGoldLastBonus, $iOldElixirLastBonus, $iOldDarkLastBonus ; bonus loot from last raid
Global $iOldSkippedVillageCount, $iOldDroppedTrophyCount ; skipped village and dropped trophy counts
Global $iOldCostGoldWall, $iOldCostElixirWall, $iOldCostGoldBuilding, $iOldCostElixirBuilding, $iOldCostDElixirHero ; wall, building and hero upgrade costs
Global $iOldNbrOfWallsUppedGold, $iOldNbrOfWallsUppedElixir, $iOldNbrOfBuildingsUppedGold, $iOldNbrOfBuildingsUppedElixir, $iOldNbrOfHeroesUpped ; number of wall, building, hero upgrades with gold, elixir, delixir
Global $iOldSearchCost, $iOldTrainCostElixir, $iOldTrainCostDElixir ; search and train troops cost
Global $iOldNbrOfOoS ; number of Out of Sync occurred
Global $iOldNbrOfTHSnipeFails, $iOldNbrOfTHSnipeSuccess ; number of fails and success while TH Sniping
Global $iOldGoldFromMines, $iOldElixirFromCollectors, $iOldDElixirFromDrills ; number of resources gain by collecting mines, collectors, drills
Global $iOldAttackedCount, $iOldAttackedVillageCount[$iModeCount + 1] ; number of attack villages for DB, LB, TB, TS
Global $iOldTotalGoldGain[$iModeCount + 1], $iOldTotalElixirGain[$iModeCount + 1], $iOldTotalDarkGain[$iModeCount + 1], $iOldTotalTrophyGain[$iModeCount + 1] ; total resource gains for DB, LB, TB, TS
Global $iOldNbrOfDetectedMines[$iModeCount + 1], $iOldNbrOfDetectedCollectors[$iModeCount + 1], $iOldNbrOfDetectedDrills[$iModeCount + 1] ; number of mines, collectors, drills detected for DB, LB, TB

Func UpdateStats()
	If $FirstRun = 1 Then
		GUICtrlSetState($lblResultStatsTemp, $GUI_HIDE)
		GUICtrlSetState($lblVillageReportTemp, $GUI_HIDE)
		GUICtrlSetState($picResultGoldTemp, $GUI_HIDE)
		GUICtrlSetState($picResultElixirTemp, $GUI_HIDE)
		GUICtrlSetState($picResultDETemp, $GUI_HIDE)

		GUICtrlSetState($lblResultGoldNow, $GUI_SHOW)
		GUICtrlSetState($picResultGoldNow, $GUI_SHOW)
		GUICtrlSetState($lblResultElixirNow, $GUI_SHOW)
		GUICtrlSetState($picResultElixirNow, $GUI_SHOW)
		If $iDarkCurrent <> "" Then
			GUICtrlSetState($lblResultDeNow, $GUI_SHOW)
			GUICtrlSetState($picResultDeNow, $GUI_SHOW)
		Else
			GUICtrlSetState($picResultDEStart, $GUI_HIDE)
			GUICtrlSetState($picDarkLoot, $GUI_HIDE)
			GUICtrlSetState($picDarkLastAttack, $GUI_HIDE)
			GUICtrlSetState($picHourlyStatsDark, $GUI_HIDE)
		EndIf
		GUICtrlSetState($lblResultTrophyNow, $GUI_SHOW)
		GUICtrlSetState($lblResultBuilderNow, $GUI_SHOW)
		GUICtrlSetState($lblResultGemNow, $GUI_SHOW)
		$iGoldStart = $iGoldCurrent
		$iElixirStart = $iElixirCurrent
		$iDarkStart = $iDarkCurrent
		$iTrophyStart = $iTrophyCurrent
		GUICtrlSetData($lblResultGoldStart, _NumberFormat($iGoldCurrent, True))
		GUICtrlSetData($lblResultGoldNow, _NumberFormat($iGoldCurrent, True))
		$iOldGoldCurrent = $iGoldCurrent
		GUICtrlSetData($lblResultElixirStart, _NumberFormat($iElixirCurrent, True))
		GUICtrlSetData($lblResultElixirNow, _NumberFormat($iElixirCurrent, True))
		$iOldElixirCurrent = $iElixirCurrent
		If $iDarkStart <> "" Then
			GUICtrlSetData($lblResultDEStart, _NumberFormat($iDarkCurrent, True))
			GUICtrlSetData($lblResultDeNow, _NumberFormat($iDarkCurrent, True))
			$iOldDarkCurrent = $iDarkCurrent
		EndIf
		GUICtrlSetData($lblResultTrophyStart, _NumberFormat($iTrophyCurrent, True))
		GUICtrlSetData($lblResultTrophyNow, _NumberFormat($iTrophyCurrent, True))
		$iOldTrophyCurrent = $iTrophyCurrent
		GUICtrlSetData($lblResultGemNow, _NumberFormat($iGemAmount, True))
		$iOldGemAmount = $iGemAmount
		GUICtrlSetData($lblResultBuilderNow, $iFreeBuilderCount & "/" & $iTotalBuilderCount)
		$iOldFreeBuilderCount = $iFreeBuilderCount
		$iOldTotalBuilderCount = $iTotalBuilderCount
		$FirstRun = 0
		GUICtrlSetState($btnResetStats, $GUI_ENABLE)
		Return
	EndIf

	If $FirstAttack = 1 Then
		GUICtrlSetState($lblLastAttackTemp, $GUI_HIDE)
		GUICtrlSetState($lblLastAttackBonusTemp, $GUI_HIDE)
		GUICtrlSetState($lblTotalLootTemp, $GUI_HIDE)
		GUICtrlSetState($lblHourlyStatsTemp, $GUI_HIDE)
		$FirstAttack = 2
	EndIf

	If $ResetStats = 1 Then
		GUICtrlSetData($lblResultGoldStart, _NumberFormat($iGoldCurrent, True))
		GUICtrlSetData($lblResultElixirStart, _NumberFormat($iElixirCurrent, True))
		If $iDarkStart <> "" Then
			GUICtrlSetData($lblResultDEStart, _NumberFormat($iDarkCurrent, True))
		EndIf
		GUICtrlSetData($lblResultTrophyStart, _NumberFormat($iTrophyCurrent, True))
		GUICtrlSetData($lblHourlyStatsGold, "")
		GUICtrlSetData($lblHourlyStatsElixir, "")
		GUICtrlSetData($lblHourlyStatsDark, "")
		GUICtrlSetData($lblHourlyStatsTrophy, "")
		GUICtrlSetData($lblResultGoldHourNow, "") ;GUI BOTTOM
		GUICtrlSetData($lblResultElixirHourNow, "");GUI BOTTOM
		GUICtrlSetData($lblResultDEHourNow, "") ;GUI BOTTOM

	EndIf

	If $iOldFreeBuilderCount <> $iFreeBuilderCount Or $iOldTotalBuilderCount <> $iTotalBuilderCount Then
		GUICtrlSetData($lblResultBuilderNow, $iFreeBuilderCount & "/" & $iTotalBuilderCount)
		$iOldFreeBuilderCount = $iFreeBuilderCount
		$iOldTotalBuilderCount = $iTotalBuilderCount
	EndIf

	If $iOldGemAmount <> $iGemAmount Then
		GUICtrlSetData($lblResultGemNow, _NumberFormat($iGemAmount, True))
		$iOldGemAmount = $iGemAmount
	EndIf

	If $iOldGoldCurrent <> $iGoldCurrent Then
		GUICtrlSetData($lblResultGoldNow, _NumberFormat($iGoldCurrent, True))
		$iOldGoldCurrent = $iGoldCurrent
	EndIf

	If $iOldElixirCurrent <> $iElixirCurrent Then
		GUICtrlSetData($lblResultElixirNow, _NumberFormat($iElixirCurrent, True))
		$iOldElixirCurrent = $iElixirCurrent
	EndIf

	If $iOldDarkCurrent <> $iDarkCurrent And $iDarkStart <> "" Then
		GUICtrlSetData($lblResultDeNow, _NumberFormat($iDarkCurrent, True))
		$iOldDarkCurrent = $iDarkCurrent
	EndIf

	If $iOldTrophyCurrent <> $iTrophyCurrent Then
		GUICtrlSetData($lblResultTrophyNow, _NumberFormat($iTrophyCurrent, True))
		$iOldTrophyCurrent = $iTrophyCurrent
	EndIf

	If $iOldGoldTotal <> $iGoldTotal And ($FirstAttack = 2 Or $ResetStats = 1) Then
		GUICtrlSetData($lblGoldLoot, _NumberFormat($iGoldTotal))
		$iOldGoldTotal = $iGoldTotal
	EndIf

	If $iOldElixirTotal <> $iElixirTotal And ($FirstAttack = 2 Or $ResetStats = 1) Then
		GUICtrlSetData($lblElixirLoot, _NumberFormat($iElixirTotal))
		$iOldElixirTotal = $iElixirTotal
	EndIf

	If $iOldDarkTotal <> $iDarkTotal And (($FirstAttack = 2 And $iDarkStart <> "") Or $ResetStats = 1) Then
		GUICtrlSetData($lblDarkLoot, _NumberFormat($iDarkTotal))
		$iOldDarkTotal = $iDarkTotal
	EndIf

	If $iOldTrophyTotal <> $iTrophyTotal And ($FirstAttack = 2 Or $ResetStats = 1) Then
		GUICtrlSetData($lblTrophyLoot, _NumberFormat($iTrophyTotal))
		$iOldTrophyTotal = $iTrophyTotal
	EndIf

	If $iOldGoldLast <> $iGoldLast Then
		GUICtrlSetData($lblGoldLastAttack, _NumberFormat($iGoldLast))
		$iOldGoldLast = $iGoldLast
	EndIf

	If $iOldElixirLast <> $iElixirLast Then
		GUICtrlSetData($lblElixirLastAttack, _NumberFormat($iElixirLast))
		$iOldElixirLast = $iElixirLast
	EndIf

	If $iOldDarkLast <> $iDarkLast Then
		GUICtrlSetData($lblDarkLastAttack, _NumberFormat($iDarkLast))
		$iOldDarkLast = $iDarkLast
	EndIf

	If $iOldTrophyLast <> $iTrophyLast Then
		GUICtrlSetData($lblTrophyLastAttack, _NumberFormat($iTrophyLast))
		$iOldTrophyLast = $iTrophyLast
	EndIf

	If $iOldGoldLastBonus <> $iGoldLastBonus Then
		GUICtrlSetData($lblGoldBonusLastAttack, _NumberFormat($iGoldLastBonus))
		$iOldGoldLastBonus = $iGoldLastBonus
	EndIf

	If $iOldElixirLastBonus <> $iElixirLastBonus Then
		GUICtrlSetData($lblElixirBonusLastAttack, _NumberFormat($iElixirLastBonus))
		$iOldElixirLastBonus = $iElixirLastBonus
	EndIf

	If $iOldDarkLastBonus <> $iDarkLastBonus Then
		GUICtrlSetData($lblDarkBonusLastAttack, _NumberFormat($iDarkLastBonus))
		$iOldDarkLastBonus = $iDarkLastBonus
	EndIf

	If $iOldCostGoldWall <> $iCostGoldWall Then
		GUICtrlSetData($lblWallUpgCostGold, _NumberFormat($iCostGoldWall, True))
		$iOldCostGoldWall = $iCostGoldWall
	EndIf

	If $iOldCostElixirWall <> $iCostElixirWall Then
		GUICtrlSetData($lblWallUpgCostElixir, _NumberFormat($iCostElixirWall, True))
		$iOldCostElixirWall = $iCostElixirWall
	EndIf

	If $iOldCostGoldBuilding <> $iCostGoldBuilding Then
		GUICtrlSetData($lblBuildingUpgCostGold, _NumberFormat($iCostGoldBuilding, True))
		$iOldCostGoldBuilding = $iCostGoldBuilding
	EndIf

	If $iOldCostElixirBuilding <> $iCostElixirBuilding Then
		GUICtrlSetData($lblBuildingUpgCostElixir, _NumberFormat($iCostElixirBuilding, True))
		$iOldCostElixirBuilding = $iCostElixirBuilding
	EndIf

	If $iOldCostDElixirHero <> $iCostDElixirHero Then
		GUICtrlSetData($lblHeroUpgCost, _NumberFormat($iCostDElixirHero, True))
		$iOldCostDElixirHero = $iCostDElixirHero
	EndIf

	If $iOldSkippedVillageCount <> $iSkippedVillageCount Then
		GUICtrlSetData($lblresultvillagesskipped, _NumberFormat($iSkippedVillageCount, True))
		GUICtrlSetData($lblResultSkippedHourNow, _NumberFormat($iSkippedVillageCount, True))
		$iOldSkippedVillageCount = $iSkippedVillageCount
	EndIf

	If $iOldDroppedTrophyCount <> $iDroppedTrophyCount Then
		GUICtrlSetData($lblresulttrophiesdropped, _NumberFormat($iDroppedTrophyCount, True))
		$iOldDroppedTrophyCount = $iDroppedTrophyCount
	EndIf

	If $iOldNbrOfWallsUppedGold <> $iNbrOfWallsUppedGold Then
		GUICtrlSetData($lblWallgoldmake, $iNbrOfWallsUppedGold)
		$iOldNbrOfWallsUppedGold = $iNbrOfWallsUppedGold
		WallsStatsMAJ()
	EndIf

	If $iOldNbrOfWallsUppedElixir <> $iNbrOfWallsUppedElixir Then
		GUICtrlSetData($lblWallelixirmake, $iNbrOfWallsUppedElixir)
		$iOldNbrOfWallsUppedElixir = $iNbrOfWallsUppedElixir
		WallsStatsMAJ()
	EndIf

	If $iOldNbrOfBuildingsUppedGold <> $iNbrOfBuildingsUppedGold Then
		GUICtrlSetData($lblNbrOfBuildingUpgGold, $iNbrOfBuildingsUppedGold)
		$iOldNbrOfBuildingsUppedGold = $iNbrOfBuildingsUppedGold
	EndIf

	If $iOldNbrOfBuildingsUppedElixir <> $iNbrOfBuildingsUppedElixir Then
		GUICtrlSetData($lblNbrOfBuildingUpgElixir, $iNbrOfBuildingsUppedElixir)
		$iOldNbrOfBuildingsUppedElixir = $iNbrOfBuildingsUppedElixir
	EndIf

	If $iOldNbrOfHeroesUpped <> $iNbrOfHeroesUpped Then
		GUICtrlSetData($lblNbrOfHeroUpg, $iNbrOfHeroesUpped)
		$iOldNbrOfHeroesUpped = $iNbrOfHeroesUpped
	EndIf

	If $iOldSearchCost <> $iSearchCost Then
		GUICtrlSetData($lblSearchCost, _NumberFormat($iSearchCost, True))
		$iOldSearchCost = $iSearchCost
	EndIf

	If $iOldTrainCostElixir <> $iTrainCostElixir Then
		GUICtrlSetData($lblTrainCostElixir, _NumberFormat($iTrainCostElixir, True))
		$iOldTrainCostElixir = $iTrainCostElixir
	EndIf

	If $iOldTrainCostDElixir <> $iTrainCostDElixir Then
		GUICtrlSetData($lblTrainCostDElixir, _NumberFormat($iTrainCostDElixir, True))
		$iOldTrainCostDElixir = $iTrainCostDElixir
	EndIf

	If $iOldNbrOfOoS <> $iNbrOfOoS Then
		GUICtrlSetData($lblNbrOfOoS, $iNbrOfOoS)
		$iOldNbrOfOoS = $iNbrOfOoS
	EndIf

	If $iOldNbrOfTHSnipeFails <> $iNbrOfTHSnipeFails Then
		GUICtrlSetData($lblNbrOfTSFailed, $iNbrOfTHSnipeFails)
		$iOldNbrOfTHSnipeFails = $iNbrOfTHSnipeFails
	EndIf

	If $iOldNbrOfTHSnipeSuccess <> $iNbrOfTHSnipeSuccess Then
		GUICtrlSetData($lblNbrOfTSSuccess, $iNbrOfTHSnipeSuccess)
		$iOldNbrOfTHSnipeSuccess = $iNbrOfTHSnipeSuccess
	EndIf

	If $iOldGoldFromMines <> $iGoldFromMines Then
		GUICtrlSetData($lblGoldFromMines, _NumberFormat($iGoldFromMines, True))
		$iOldGoldFromMines = $iGoldFromMines
	EndIf

	If $iOldElixirFromCollectors <> $iElixirFromCollectors Then
		GUICtrlSetData($lblElixirFromCollectors, _NumberFormat($iElixirFromCollectors, True))
		$iOldElixirFromCollectors = $iElixirFromCollectors
	EndIf

	If $iOldDElixirFromDrills <> $iDElixirFromDrills Then
		GUICtrlSetData($lblDElixirFromDrills, _NumberFormat($iDElixirFromDrills, True))
		$iOldDElixirFromDrills = $iDElixirFromDrills
	EndIf

	$iAttackedCount = 0

	For $i = 0 To $iModeCount

		If $iOldAttackedVillageCount[$i] <> $iAttackedVillageCount[$i] Then
			GUICtrlSetData($lblAttacked[$i], _NumberFormat($iAttackedVillageCount[$i], True))
			$iOldAttackedVillageCount[$i] = $iAttackedVillageCount[$i]
		EndIf
		$iAttackedCount += $iAttackedVillageCount[$i]

		If $iOldTotalGoldGain[$i] <> $iTotalGoldGain[$i] Then
			GUICtrlSetData($lblTotalGoldGain[$i], _NumberFormat($iTotalGoldGain[$i], True))
			$iOldTotalGoldGain[$i] = $iTotalGoldGain[$i]
		EndIf

		If $iOldTotalElixirGain[$i] <> $iTotalElixirGain[$i] Then
			GUICtrlSetData($lblTotalElixirGain[$i], _NumberFormat($iTotalElixirGain[$i], True))
			$iOldTotalElixirGain[$i] = $iTotalElixirGain[$i]
		EndIf

		If $iOldTotalDarkGain[$i] <> $iTotalDarkGain[$i] Then
			GUICtrlSetData($lblTotalDElixirGain[$i], _NumberFormat($iTotalDarkGain[$i], True))
			$iOldTotalDarkGain[$i] = $iTotalDarkGain[$i]
		EndIf

		If $iOldTotalTrophyGain[$i] <> $iTotalTrophyGain[$i] Then
			GUICtrlSetData($lblTotalTrophyGain[$i], _NumberFormat($iTotalTrophyGain[$i], True))
			$iOldTotalTrophyGain[$i] = $iTotalTrophyGain[$i]
		EndIf

	Next

	If $iOldAttackedCount <> $iAttackedCount Then
		GUICtrlSetData($lblresultvillagesattacked, _NumberFormat($iAttackedCount, True))
		GUICtrlSetData($lblResultAttackedHourNow, _NumberFormat($iAttackedCount, True))
		$iOldAttackedCount = $iAttackedCount
	EndIf

	For $i = 0 To $iModeCount

		If $i = $TS Then ContinueLoop

		If $iOldNbrOfDetectedMines[$i] <> $iNbrOfDetectedMines[$i] Then
			GUICtrlSetData($lblNbrOfDetectedMines[$i], $iNbrOfDetectedMines[$i])
			$iOldNbrOfDetectedMines[$i] = $iNbrOfDetectedMines[$i]
		EndIf

		If $iOldNbrOfDetectedCollectors[$i] <> $iNbrOfDetectedCollectors[$i] Then
			GUICtrlSetData($lblNbrOfDetectedCollectors[$i], $iNbrOfDetectedCollectors[$i])
			$iOldNbrOfDetectedCollectors[$i] = $iNbrOfDetectedCollectors[$i]
		EndIf

		If $iOldNbrOfDetectedDrills[$i] <> $iNbrOfDetectedDrills[$i] Then
			GUICtrlSetData($lblNbrOfDetectedDrills[$i], $iNbrOfDetectedDrills[$i])
			$iOldNbrOfDetectedDrills[$i] = $iNbrOfDetectedDrills[$i]
		EndIf

	Next

	If $FirstAttack = 2 Then
		GUICtrlSetData($lblHourlyStatsGold, _NumberFormat(Round($iGoldTotal / (Int(TimerDiff($sTimer) + $iTimePassed)) * 3600)) & "K / h")
		GUICtrlSetData($lblHourlyStatsElixir, _NumberFormat(Round($iElixirTotal / (Int(TimerDiff($sTimer) + $iTimePassed)) * 3600)) & "K / h")
		If $iDarkStart <> "" Then
			GUICtrlSetData($lblHourlyStatsDark, _NumberFormat(Round($iDarkTotal / (Int(TimerDiff($sTimer) + $iTimePassed)) * 3600 * 1000)) & " / h")
		EndIf
		GUICtrlSetData($lblHourlyStatsTrophy, _NumberFormat(Round($iTrophyTotal / (Int(TimerDiff($sTimer) + $iTimePassed)) * 3600 * 1000)) & " / h")

		GUICtrlSetData($lblResultGoldHourNow, _NumberFormat(Round($iGoldTotal / (Int(TimerDiff($sTimer) + $iTimePassed)) * 3600)) & "K / h") ;GUI BOTTOM
		GUICtrlSetData($lblResultElixirHourNow, _NumberFormat(Round($iElixirTotal / (Int(TimerDiff($sTimer) + $iTimePassed)) * 3600)) & "K / h") ;GUI BOTTOM
		If $iDarkStart <> "" Then
			GUICtrlSetData($lblResultDEHourNow, _NumberFormat(Round($iDarkTotal / (Int(TimerDiff($sTimer) + $iTimePassed)) * 3600 * 1000)) & " / h") ;GUI BOTTOM
		EndIf

	EndIf

	If $ResetStats = 1 Then
		$ResetStats = 0
	EndIf

EndFunc   ;==>UpdateStats

Func ResetStats()
	$ResetStats = 1
	$FirstAttack = 0
	$iTimePassed = 0
	$sTimer = TimerInit()
	GUICtrlSetData($lblresultruntime, "00:00:00")
	GUICtrlSetData($lblResultRuntimeNow, "00:00:00")
	GUICtrlSetState($lblLastAttackTemp, $GUI_SHOW)
	GUICtrlSetState($lblLastAttackBonusTemp, $GUI_SHOW)
	GUICtrlSetState($lblTotalLootTemp, $GUI_SHOW)
	GUICtrlSetState($lblHourlyStatsTemp, $GUI_SHOW)
	$iGoldStart = $iGoldCurrent
	$iElixirStart = $iElixirCurrent
	$iDarkStart = $iDarkCurrent
	$iTrophyStart = $iTrophyCurrent
	$iGoldTotal = 0
	$iElixirTotal = 0
	$iDarkTotal = 0
	$iTrophyTotal = 0
	$iGoldLast = 0
	$iElixirLast = 0
	$iDarkLast = 0
	$iTrophyLast = 0
	$iGoldLastBonus = 0
	$iElixirLastBonus = 0
	$iDarkLastBonus = 0
	$iSkippedVillageCount = 0
	$iDroppedTrophyCount = 0
	$iCostGoldWall = 0
	$iCostElixirWall = 0
	$iCostGoldBuilding = 0
	$iCostElixirBuilding = 0
	$iCostDElixirHero = 0
	$iNbrOfWallsUppedGold = 0
	$iNbrOfWallsUppedElixir = 0
	$iNbrOfBuildingsUppedGold = 0
	$iNbrOfBuildingsUppedElixir = 0
	$iNbrOfHeroesUpped = 0
	$iSearchCost = 0
	$iTrainCostElixir = 0
	$iTrainCostDElixir = 0
	$iNbrOfOoS = 0
	$iNbrOfTHSnipeFails = 0
	$iNbrOfTHSnipeSuccess = 0
	$iGoldFromMines = 0
	$iElixirFromCollectors = 0
	$iDElixirFromDrills = 0
	For $i = 0 To $iModeCount
		$iAttackedVillageCount[$i] = 0
		$iTotalGoldGain[$i] = 0
		$iTotalElixirGain[$i] = 0
		$iTotalDarkGain[$i] = 0
		$iTotalTrophyGain[$i] = 0
		$iNbrOfDetectedMines[$i] = 0
		$iNbrOfDetectedCollectors[$i] = 0
		$iNbrOfDetectedDrills[$i] = 0
	Next
	UpdateStats()
EndFunc   ;==>ResetStats
