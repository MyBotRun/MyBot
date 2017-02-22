; #FUNCTION# ====================================================================================================================
; Name ..........: UpdateStats
; Description ...: This function will update the statistics in the GUI.
; Syntax ........: UpdateStats()
; Parameters ....: None
; Return values .: None
; Author ........: kaganus (06-2015)
; Modified ......: CodeSlinger69 (01-2017), Fliegerfaust (02-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......:
; ===============================================================================================================================
#include-once

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
Global $iOldAttackedCount, $iOldAttackedVillageCount[$g_iModeCount + 1] ; number of attack villages for DB, LB, TB, TS
Global $iOldTotalGoldGain[$g_iModeCount + 1], $iOldTotalElixirGain[$g_iModeCount + 1], $iOldTotalDarkGain[$g_iModeCount + 1], $iOldTotalTrophyGain[$g_iModeCount + 1] ; total resource gains for DB, LB, TB, TS
Global $iOldNbrOfDetectedMines[$g_iModeCount + 1], $iOldNbrOfDetectedCollectors[$g_iModeCount + 1], $iOldNbrOfDetectedDrills[$g_iModeCount + 1] ; number of mines, collectors, drills detected for DB, LB, TB
Global $topgoldloot = 0
Global $topelixirloot = 0
Global $topdarkloot = 0
Global $topTrophyloot = 0


Func UpdateStats()
    Static $s_iOldSmartZapGain = 0, $s_iOldNumLSpellsUsed = 0, $s_iOldNumEQSpellsUsed = 0
	Local $bDonateTroopsStatsChanged = False, $bDonateSpellsStatsChanged = False

	If $g_iFirstRun = 1 Then
		;GUICtrlSetState($g_hLblResultStatsTemp, $GUI_HIDE)
		GUICtrlSetState($g_hLblVillageReportTemp, $GUI_HIDE)
		GUICtrlSetState($g_hPicResultGoldTemp, $GUI_HIDE)
		GUICtrlSetState($g_hPicResultElixirTemp, $GUI_HIDE)
		GUICtrlSetState($g_hPicResultDETemp, $GUI_HIDE)

		GUICtrlSetState($g_hLblResultGoldNow, $GUI_SHOW + $GUI_DISABLE) ; $GUI_DISABLE to trigger default view in btnVillageStat
		GUICtrlSetState($g_hPicResultGoldNow, $GUI_SHOW)
		GUICtrlSetState($g_hLblResultElixirNow, $GUI_SHOW)
		GUICtrlSetState($g_hPicResultElixirNow, $GUI_SHOW)
		If $iDarkCurrent <> "" Then
			GUICtrlSetState($g_hLblResultDeNow, $GUI_SHOW)
			GUICtrlSetState($g_hPicResultDeNow, $GUI_SHOW)
		Else
			GUICtrlSetState($g_hPicResultDEStart, $GUI_HIDE)
			GUICtrlSetState($g_hPicDarkLoot, $GUI_HIDE)
			GUICtrlSetState($g_hPicDarkLastAttack, $GUI_HIDE)
			GUICtrlSetState($g_hPicHourlyStatsDark, $GUI_HIDE)
		EndIf
		GUICtrlSetState($g_hLblResultTrophyNow, $GUI_SHOW)
		GUICtrlSetState($g_hLblResultBuilderNow, $GUI_SHOW)
		GUICtrlSetState($g_hLblResultGemNow, $GUI_SHOW)
		btnVillageStat("UpdateStats")
		$g_iStatsStartedWith[$eLootGold] = $iGoldCurrent
		$g_iStatsStartedWith[$eLootElixir] = $iElixirCurrent
		$g_iStatsStartedWith[$eLootDarkElixir] = $iDarkCurrent
		$g_iStatsStartedWith[$eLootTrophy] = $iTrophyCurrent
		GUICtrlSetData($g_ahLblStatsStartedWith[$eLootGold], _NumberFormat($iGoldCurrent, True))
		GUICtrlSetData($g_hLblResultGoldNow, _NumberFormat($iGoldCurrent, True))
		$iOldGoldCurrent = $iGoldCurrent
		GUICtrlSetData($g_ahLblStatsStartedWith[$eLootElixir], _NumberFormat($iElixirCurrent, True))
		GUICtrlSetData($g_hLblResultElixirNow, _NumberFormat($iElixirCurrent, True))
		$iOldElixirCurrent = $iElixirCurrent
		If $g_iStatsStartedWith[$eLootDarkElixir] <> "" Then
			GUICtrlSetData($g_ahLblStatsStartedWith[$eLootDarkElixir], _NumberFormat($iDarkCurrent, True))
			GUICtrlSetData($g_hLblResultDeNow, _NumberFormat($iDarkCurrent, True))
			$iOldDarkCurrent = $iDarkCurrent
		EndIf
		GUICtrlSetData($g_ahLblStatsStartedWith[$eLootTrophy], _NumberFormat($iTrophyCurrent, True))
		GUICtrlSetData($g_hLblResultTrophyNow, _NumberFormat($iTrophyCurrent, True))
		$iOldTrophyCurrent = $iTrophyCurrent
		GUICtrlSetData($g_hLblResultGemNow, _NumberFormat($iGemAmount, True))
		$iOldGemAmount = $iGemAmount
		GUICtrlSetData($g_hLblResultBuilderNow, $iFreeBuilderCount & "/" & $iTotalBuilderCount)
		$iOldFreeBuilderCount = $iFreeBuilderCount
		$iOldTotalBuilderCount = $iTotalBuilderCount
		$g_iFirstRun = 0
		GUICtrlSetState($btnResetStats, $GUI_ENABLE)
		Return
	EndIf

	If $g_iFirstAttack = 1 Then
		;GUICtrlSetState($lblLastAttackTemp, $GUI_HIDE)
		;GUICtrlSetState($lblLastAttackBonusTemp, $GUI_HIDE)
		;GUICtrlSetState($lblTotalLootTemp, $GUI_HIDE)
		;GUICtrlSetState($lblHourlyStatsTemp, $GUI_HIDE)
		$g_iFirstAttack = 2
	EndIf

	If Number($g_iStatsLastAttack[$eLootGold]) > Number($topgoldloot) Then
		$topgoldloot = $g_iStatsLastAttack[$eLootGold]
		GUICtrlSetData($g_ahLblStatsTop[$eLootGold],_NumberFormat($topgoldloot))
	EndIf

	If Number($g_iStatsLastAttack[$eLootElixir]) > Number($topelixirloot) Then
		$topelixirloot = $g_iStatsLastAttack[$eLootElixir]
		GUICtrlSetData($g_ahLblStatsTop[$eLootElixir],_NumberFormat($topelixirloot))
	EndIf

	If Number($g_iStatsLastAttack[$eLootDarkElixir]) > Number($topdarkloot) Then
		$topdarkloot = $g_iStatsLastAttack[$eLootDarkElixir]
		GUICtrlSetData($g_ahLblStatsTop[$eLootDarkElixir],_NumberFormat($topdarkloot))
	EndIf

	If Number($g_iStatsLastAttack[$eLootTrophy]) > Number($topTrophyloot) Then
		$topTrophyloot = $g_iStatsLastAttack[$eLootTrophy]
		GUICtrlSetData($g_ahLblStatsTop[$eLootTrophy],_NumberFormat($topTrophyloot))
	EndIf

	If $ResetStats = 1 Then
		GUICtrlSetData($g_ahLblStatsStartedWith[$eLootGold], _NumberFormat($iGoldCurrent, True))
		GUICtrlSetData($g_ahLblStatsStartedWith[$eLootElixir], _NumberFormat($iElixirCurrent, True))
		If $g_iStatsStartedWith[$eLootDarkElixir] <> "" Then
			GUICtrlSetData($g_ahLblStatsStartedWith[$eLootDarkElixir], _NumberFormat($iDarkCurrent, True))
		EndIf
		GUICtrlSetData($g_ahLblStatsStartedWith[$eLootTrophy], _NumberFormat($iTrophyCurrent, True))
		GUICtrlSetData($g_ahLblStatsGainPerHour[$eLootGold], "")
		GUICtrlSetData($g_ahLblStatsGainPerHour[$eLootElixir], "")
		GUICtrlSetData($g_ahLblStatsGainPerHour[$eLootDarkElixir], "")
		GUICtrlSetData($g_ahLblStatsGainPerHour[$eLootTrophy], "")
		GUICtrlSetData($g_hLblResultGoldHourNow, "") ;GUI BOTTOM
		GUICtrlSetData($g_hLblResultElixirHourNow, "");GUI BOTTOM
		GUICtrlSetData($g_hLblResultDEHourNow, "") ;GUI BOTTOM

	EndIf

	If $iOldFreeBuilderCount <> $iFreeBuilderCount Or $iOldTotalBuilderCount <> $iTotalBuilderCount Then
		GUICtrlSetData($g_hLblResultBuilderNow, $iFreeBuilderCount & "/" & $iTotalBuilderCount)
		$iOldFreeBuilderCount = $iFreeBuilderCount
		$iOldTotalBuilderCount = $iTotalBuilderCount
	EndIf

	If $iOldGemAmount <> $iGemAmount Then
		GUICtrlSetData($g_hLblResultGemNow, _NumberFormat($iGemAmount, True))
		$iOldGemAmount = $iGemAmount
	EndIf

	If $iOldGoldCurrent <> $iGoldCurrent Then
		GUICtrlSetData($g_hLblResultGoldNow, _NumberFormat($iGoldCurrent, True))
		$iOldGoldCurrent = $iGoldCurrent
	EndIf

	If $iOldElixirCurrent <> $iElixirCurrent Then
		GUICtrlSetData($g_hLblResultElixirNow, _NumberFormat($iElixirCurrent, True))
		$iOldElixirCurrent = $iElixirCurrent
	EndIf

	If $iOldDarkCurrent <> $iDarkCurrent And $g_iStatsStartedWith[$eLootDarkElixir] <> "" Then
		GUICtrlSetData($g_hLblResultDeNow, _NumberFormat($iDarkCurrent, True))
		$iOldDarkCurrent = $iDarkCurrent
	EndIf

	If $iOldTrophyCurrent <> $iTrophyCurrent Then
		GUICtrlSetData($g_hLblResultTrophyNow, _NumberFormat($iTrophyCurrent, True))
		$iOldTrophyCurrent = $iTrophyCurrent
	EndIf

	If $iOldGoldTotal <> $g_iStatsTotalGain[$eLootGold] And ($g_iFirstAttack = 2 Or $ResetStats = 1) Then
		GUICtrlSetData($g_ahLblStatsTotalGain[$eLootGold], _NumberFormat($g_iStatsTotalGain[$eLootGold]))
		$iOldGoldTotal = $g_iStatsTotalGain[$eLootGold]
	EndIf

	If $iOldElixirTotal <> $g_iStatsTotalGain[$eLootElixir] And ($g_iFirstAttack = 2 Or $ResetStats = 1) Then
		GUICtrlSetData($g_ahLblStatsTotalGain[$eLootElixir], _NumberFormat($g_iStatsTotalGain[$eLootElixir]))
		$iOldElixirTotal = $g_iStatsTotalGain[$eLootElixir]
	EndIf

	If $iOldDarkTotal <> $g_iStatsTotalGain[$eLootDarkElixir] And (($g_iFirstAttack = 2 And $g_iStatsStartedWith[$eLootDarkElixir] <> "") Or $ResetStats = 1) Then
		GUICtrlSetData($g_ahLblStatsTotalGain[$eLootDarkElixir], _NumberFormat($g_iStatsTotalGain[$eLootDarkElixir]))
		$iOldDarkTotal = $g_iStatsTotalGain[$eLootDarkElixir]
	EndIf

	If $iOldTrophyTotal <> $g_iStatsTotalGain[$eLootTrophy] And ($g_iFirstAttack = 2 Or $ResetStats = 1) Then
		GUICtrlSetData($g_ahLblStatsTotalGain[$eLootTrophy], _NumberFormat($g_iStatsTotalGain[$eLootTrophy]))
		$iOldTrophyTotal = $g_iStatsTotalGain[$eLootTrophy]
	EndIf

	If $iOldGoldLast <> $g_iStatsLastAttack[$eLootGold] Then
		GUICtrlSetData($g_ahLblStatsLastAttack[$eLootGold], _NumberFormat($g_iStatsLastAttack[$eLootGold]))
		$iOldGoldLast = $g_iStatsLastAttack[$eLootGold]
	EndIf

	If $iOldElixirLast <> $g_iStatsLastAttack[$eLootElixir] Then
		GUICtrlSetData($g_ahLblStatsLastAttack[$eLootElixir], _NumberFormat($g_iStatsLastAttack[$eLootElixir]))
		$iOldElixirLast = $g_iStatsLastAttack[$eLootElixir]
	EndIf

	If $iOldDarkLast <> $g_iStatsLastAttack[$eLootDarkElixir] Then
		GUICtrlSetData($g_ahLblStatsLastAttack[$eLootDarkElixir], _NumberFormat($g_iStatsLastAttack[$eLootDarkElixir]))
		$iOldDarkLast = $g_iStatsLastAttack[$eLootDarkElixir]
	EndIf

	If $iOldTrophyLast <> $g_iStatsLastAttack[$eLootTrophy] Then
		GUICtrlSetData($g_ahLblStatsLastAttack[$eLootTrophy], _NumberFormat($g_iStatsLastAttack[$eLootTrophy]))
		$iOldTrophyLast = $g_iStatsLastAttack[$eLootTrophy]
	EndIf

	If $iOldGoldLastBonus <> $g_iStatsBonusLast[$eLootGold] Then
		GUICtrlSetData($g_ahLblStatsBonusLast[$eLootGold], _NumberFormat($g_iStatsBonusLast[$eLootGold]))
		$iOldGoldLastBonus = $g_iStatsBonusLast[$eLootGold]
	EndIf

	If $iOldElixirLastBonus <> $g_iStatsBonusLast[$eLootElixir] Then
		GUICtrlSetData($g_ahLblStatsBonusLast[$eLootElixir], _NumberFormat($g_iStatsBonusLast[$eLootElixir]))
		$iOldElixirLastBonus = $g_iStatsBonusLast[$eLootElixir]
	EndIf

	If $iOldDarkLastBonus <> $g_iStatsBonusLast[$eLootDarkElixir] Then
		GUICtrlSetData($g_ahLblStatsBonusLast[$eLootDarkElixir], _NumberFormat($g_iStatsBonusLast[$eLootDarkElixir]))
		$iOldDarkLastBonus = $g_iStatsBonusLast[$eLootDarkElixir]
	EndIf

	If $iOldCostGoldWall <> $iCostGoldWall Then
		GUICtrlSetData($g_hLblWallUpgCostGold, _NumberFormat($iCostGoldWall, True))
		$iOldCostGoldWall = $iCostGoldWall
	EndIf

	If $iOldCostElixirWall <> $iCostElixirWall Then
		GUICtrlSetData($g_hLblWallUpgCostElixir, _NumberFormat($iCostElixirWall, True))
		$iOldCostElixirWall = $iCostElixirWall
	EndIf

	If $iOldCostGoldBuilding <> $iCostGoldBuilding Then
		GUICtrlSetData($g_hLblBuildingUpgCostGold, _NumberFormat($iCostGoldBuilding, True))
		$iOldCostGoldBuilding = $iCostGoldBuilding
	EndIf

	If $iOldCostElixirBuilding <> $iCostElixirBuilding Then
		GUICtrlSetData($g_hLblBuildingUpgCostElixir, _NumberFormat($iCostElixirBuilding, True))
		$iOldCostElixirBuilding = $iCostElixirBuilding
	EndIf

	If $iOldCostDElixirHero <> $iCostDElixirHero Then
		GUICtrlSetData($g_hLblHeroUpgCost, _NumberFormat($iCostDElixirHero, True))
		$iOldCostDElixirHero = $iCostDElixirHero
	EndIf

	If $iOldSkippedVillageCount <> $iSkippedVillageCount Then
		GUICtrlSetData($g_hLblResultVillagesSkipped, _NumberFormat($iSkippedVillageCount, True))
		GUICtrlSetData($g_hLblResultSkippedHourNow, _NumberFormat($iSkippedVillageCount, True))
		$iOldSkippedVillageCount = $iSkippedVillageCount
	EndIf

	If $iOldDroppedTrophyCount <> $iDroppedTrophyCount Then
		GUICtrlSetData($g_hLblResultTrophiesDropped, _NumberFormat($iDroppedTrophyCount, True))
		$iOldDroppedTrophyCount = $iDroppedTrophyCount
	EndIf

	If $iOldNbrOfWallsUppedGold <> $iNbrOfWallsUppedGold Then
		GUICtrlSetData($g_hLblWallGoldMake, $iNbrOfWallsUppedGold)
		$iOldNbrOfWallsUppedGold = $iNbrOfWallsUppedGold
		WallsStatsMAJ()
	EndIf

	If $iOldNbrOfWallsUppedElixir <> $iNbrOfWallsUppedElixir Then
		GUICtrlSetData($g_hLblWallElixirMake, $iNbrOfWallsUppedElixir)
		$iOldNbrOfWallsUppedElixir = $iNbrOfWallsUppedElixir
		WallsStatsMAJ()
	EndIf

	If $iOldNbrOfBuildingsUppedGold <> $iNbrOfBuildingsUppedGold Then
		GUICtrlSetData($g_hLblNbrOfBuildingUpgGold, $iNbrOfBuildingsUppedGold)
		$iOldNbrOfBuildingsUppedGold = $iNbrOfBuildingsUppedGold
	EndIf

	If $iOldNbrOfBuildingsUppedElixir <> $iNbrOfBuildingsUppedElixir Then
		GUICtrlSetData($g_hLblNbrOfBuildingUpgElixir, $iNbrOfBuildingsUppedElixir)
		$iOldNbrOfBuildingsUppedElixir = $iNbrOfBuildingsUppedElixir
	EndIf

	If $iOldNbrOfHeroesUpped <> $iNbrOfHeroesUpped Then
		GUICtrlSetData($g_hLblNbrOfHeroUpg, $iNbrOfHeroesUpped)
		$iOldNbrOfHeroesUpped = $iNbrOfHeroesUpped
	EndIf

	If $iOldSearchCost <> $iSearchCost Then
		GUICtrlSetData($g_hLblSearchCost, _NumberFormat($iSearchCost, True))
		$iOldSearchCost = $iSearchCost
	EndIf

	If $iOldTrainCostElixir <> $iTrainCostElixir Then
		GUICtrlSetData($g_hLblTrainCostElixir, _NumberFormat($iTrainCostElixir, True))
		$iOldTrainCostElixir = $iTrainCostElixir
	EndIf

	If $iOldTrainCostDElixir <> $iTrainCostDElixir Then
		GUICtrlSetData($g_hLblTrainCostDElixir, _NumberFormat($iTrainCostDElixir, True))
		$iOldTrainCostDElixir = $iTrainCostDElixir
	EndIf

	If $iOldNbrOfOoS <> $iNbrOfOoS Then
		GUICtrlSetData($g_hLblNbrOfOoS, $iNbrOfOoS)
		$iOldNbrOfOoS = $iNbrOfOoS
	EndIf

	If $iOldNbrOfTHSnipeFails <> $iNbrOfTHSnipeFails Then
		GUICtrlSetData($g_hLblNbrOfTSFailed, $iNbrOfTHSnipeFails)
		$iOldNbrOfTHSnipeFails = $iNbrOfTHSnipeFails
	EndIf

	If $iOldNbrOfTHSnipeSuccess <> $iNbrOfTHSnipeSuccess Then
		GUICtrlSetData($g_hLblNbrOfTSSuccess, $iNbrOfTHSnipeSuccess)
		$iOldNbrOfTHSnipeSuccess = $iNbrOfTHSnipeSuccess
	EndIf

	If $iOldGoldFromMines <> $iGoldFromMines Then
		GUICtrlSetData($g_hLblGoldFromMines, _NumberFormat($iGoldFromMines, True))
		$iOldGoldFromMines = $iGoldFromMines
	EndIf

	If $iOldElixirFromCollectors <> $iElixirFromCollectors Then
		GUICtrlSetData($g_hLblElixirFromCollectors, _NumberFormat($iElixirFromCollectors, True))
		$iOldElixirFromCollectors = $iElixirFromCollectors
	EndIf

	If $iOldDElixirFromDrills <> $iDElixirFromDrills Then
		GUICtrlSetData($g_hLblDElixirFromDrills, _NumberFormat($iDElixirFromDrills, True))
		$iOldDElixirFromDrills = $iDElixirFromDrills
	EndIf

	For $i = 0 To $eTroopCount - 1
		If $g_aiDonateStatsTroops[$i][0] <> $g_aiDonateStatsTroops[$i][1] Then
			GUICtrlSetData($g_hLblDonTroop[$i], _NumberFormat($g_aiDonateStatsTroops[$i][0], True))
			$g_iTotalDonateStatsTroops += ($g_aiDonateStatsTroops[$i][0] - $g_aiDonateStatsTroops[$i][1])
			$g_iTotalDonateStatsTroopsXP += (($g_aiDonateStatsTroops[$i][0] - $g_aiDonateStatsTroops[$i][1]) * $g_aiTroopDonateXP[$i])
			$g_aiDonateStatsTroops[$i][1] = $g_aiDonateStatsTroops[$i][0]
			$bDonateTroopsStatsChanged = True
		EndIf
	Next
	If $bDonateTroopsStatsChanged Then
		GUICtrlSetData($g_hLblTotalTroopsQ, _NumberFormat($g_iTotalDonateStatsTroops, True))
		GUICtrlSetData($g_hLblTotalTroopsXP, _NumberFormat($g_iTotalDonateStatsTroopsXP, True))
		$bDonateTroopsStatsChanged = False
	EndIf

	For $i = 0 To $eSpellCount - 1
		If $g_aiDonateStatsSpells[$i][0] <> $g_aiDonateStatsSpells[$i][1] And $i <> $eSpellClone Then
			GUICtrlSetData($g_hLblDonSpell[$i], _NumberFormat($g_aiDonateStatsSpells[$i][0], True))
			$g_iTotalDonateStatsSpells += ($g_aiDonateStatsSpells[$i][0] - $g_aiDonateStatsSpells[$i][1])
			$g_iTotalDonateStatsSpellsXP += (($g_aiDonateStatsSpells[$i][0] - $g_aiDonateStatsSpells[$i][1]) * $g_aiSpellDonateXP[$i])
			$g_aiDonateStatsSpells[$i][1] = $g_aiDonateStatsSpells[$i][0]
			$bDonateSpellsStatsChanged = True
		EndIf
	Next

	If $bDonateSpellsStatsChanged Then
		GUICtrlSetData($g_hLblTotalSpellsQ, _NumberFormat($g_iTotalDonateStatsSpells, True))
		GUICtrlSetData($g_hLblTotalSpellsXP, _NumberFormat($g_iTotalDonateStatsSpellsXP, True))
		$bDonateSpellsStatsChanged = False
	EndIf


	If $s_iOldSmartZapGain <> $g_iSmartZapGain Then
		GUICtrlSetData($g_hLblSmartZap, _NumberFormat($g_iSmartZapGain, True))
		$s_iOldSmartZapGain = $g_iSmartZapGain
	EndIf

	If $s_iOldNumLSpellsUsed <> $g_iNumLSpellsUsed Then
		GUICtrlSetData($g_hLblSmartLightningUsed, _NumberFormat($g_iNumLSpellsUsed, True))
		$s_iOldNumLSpellsUsed = $g_iNumLSpellsUsed
 	EndIf

	If $s_iOldNumEQSpellsUsed <> $g_iNumEQSpellsUsed Then
		GUICtrlSetData($g_hLblSmartEarthQuakeUsed, _NumberFormat($g_iNumEQSpellsUsed, True))
		$s_iOldNumEQSpellsUsed = $g_iNumEQSpellsUsed
 	EndIf

	$iAttackedCount = 0

	For $i = 0 To $g_iModeCount

		If $iOldAttackedVillageCount[$i] <> $iAttackedVillageCount[$i] Then
			GUICtrlSetData($g_hLblAttacked[$i], _NumberFormat($iAttackedVillageCount[$i], True))
			$iOldAttackedVillageCount[$i] = $iAttackedVillageCount[$i]
		EndIf
		$iAttackedCount += $iAttackedVillageCount[$i]

		If $iOldTotalGoldGain[$i] <> $iTotalGoldGain[$i] Then
			GUICtrlSetData($g_hLblTotalGoldGain[$i], _NumberFormat($iTotalGoldGain[$i], True))
			$iOldTotalGoldGain[$i] = $iTotalGoldGain[$i]
		EndIf

		If $iOldTotalElixirGain[$i] <> $iTotalElixirGain[$i] Then
			GUICtrlSetData($g_hLblTotalElixirGain[$i], _NumberFormat($iTotalElixirGain[$i], True))
			$iOldTotalElixirGain[$i] = $iTotalElixirGain[$i]
		EndIf

		If $iOldTotalDarkGain[$i] <> $iTotalDarkGain[$i] Then
			GUICtrlSetData($g_hLblTotalDElixirGain[$i], _NumberFormat($iTotalDarkGain[$i], True))
			$iOldTotalDarkGain[$i] = $iTotalDarkGain[$i]
		EndIf

		If $iOldTotalTrophyGain[$i] <> $iTotalTrophyGain[$i] Then
			GUICtrlSetData($g_hLblTotalTrophyGain[$i], _NumberFormat($iTotalTrophyGain[$i], True))
			$iOldTotalTrophyGain[$i] = $iTotalTrophyGain[$i]
		EndIf

	Next

	If $iOldAttackedCount <> $iAttackedCount Then
		GUICtrlSetData($g_hLblResultVillagesAttacked, _NumberFormat($iAttackedCount, True))
		GUICtrlSetData($g_hLblResultAttackedHourNow, _NumberFormat($iAttackedCount, True))
		$iOldAttackedCount = $iAttackedCount
	EndIf

	For $i = 0 To $g_iModeCount

		If $i = $TS Then ContinueLoop

		If $iOldNbrOfDetectedMines[$i] <> $iNbrOfDetectedMines[$i] Then
			GUICtrlSetData($g_hLblNbrOfDetectedMines[$i], $iNbrOfDetectedMines[$i])
			$iOldNbrOfDetectedMines[$i] = $iNbrOfDetectedMines[$i]
		EndIf

		If $iOldNbrOfDetectedCollectors[$i] <> $iNbrOfDetectedCollectors[$i] Then
			GUICtrlSetData($g_hLblNbrOfDetectedCollectors[$i], $iNbrOfDetectedCollectors[$i])
			$iOldNbrOfDetectedCollectors[$i] = $iNbrOfDetectedCollectors[$i]
		EndIf

		If $iOldNbrOfDetectedDrills[$i] <> $iNbrOfDetectedDrills[$i] Then
			GUICtrlSetData($g_hLblNbrOfDetectedDrills[$i], $iNbrOfDetectedDrills[$i])
			$iOldNbrOfDetectedDrills[$i] = $iNbrOfDetectedDrills[$i]
		EndIf

	Next

	If $g_iFirstAttack = 2 Then
		GUICtrlSetData($g_ahLblStatsGainPerHour[$eLootGold], _NumberFormat(Round($g_iStatsTotalGain[$eLootGold] / (Int(TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "k / h")
		GUICtrlSetData($g_ahLblStatsGainPerHour[$eLootElixir], _NumberFormat(Round($g_iStatsTotalGain[$eLootElixir] / (Int(TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "k / h")
		If $g_iStatsStartedWith[$eLootDarkElixir] <> "" Then
			GUICtrlSetData($g_ahLblStatsGainPerHour[$eLootDarkElixir], _NumberFormat(Round($g_iStatsTotalGain[$eLootDarkElixir] / (Int(TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600 * 1000)) & " / h")
		EndIf
		GUICtrlSetData($g_ahLblStatsGainPerHour[$eLootTrophy], _NumberFormat(Round($g_iStatsTotalGain[$eLootTrophy] / (Int(TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600 * 1000)) & " / h")

		GUICtrlSetData($g_hLblResultGoldHourNow, _NumberFormat(Round($g_iStatsTotalGain[$eLootGold] / (Int(TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "k / h") ;GUI BOTTOM
		GUICtrlSetData($g_hLblResultElixirHourNow, _NumberFormat(Round($g_iStatsTotalGain[$eLootElixir] / (Int(TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "k / h") ;GUI BOTTOM
		If $g_iStatsStartedWith[$eLootDarkElixir] <> "" Then
			GUICtrlSetData($g_hLblResultDEHourNow, _NumberFormat(Round($g_iStatsTotalGain[$eLootDarkElixir] / (Int(TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600 * 1000)) & " / h") ;GUI BOTTOM
		EndIf

	EndIf

	If Number($g_iStatsLastAttack[$eLootGold]) > Number($topgoldloot) Then
		$topgoldloot = $g_iStatsLastAttack[$eLootGold]
		GUICtrlSetData($g_ahLblStatsTop[$eLootGold],_NumberFormat($topgoldloot))
	EndIf

	If Number($g_iStatsLastAttack[$eLootElixir]) > Number($topelixirloot) Then
		$topelixirloot = $g_iStatsLastAttack[$eLootElixir]
		GUICtrlSetData($g_ahLblStatsTop[$eLootElixir],_NumberFormat($topelixirloot))
	EndIf

	If Number($g_iStatsLastAttack[$eLootDarkElixir]) > Number($topdarkloot) Then
		$topdarkloot = $g_iStatsLastAttack[$eLootDarkElixir]
		GUICtrlSetData($g_ahLblStatsTop[$eLootDarkElixir],_NumberFormat($topdarkloot))
	EndIf

	If Number($g_iStatsLastAttack[$eLootTrophy]) > Number($topTrophyloot) Then
		$topTrophyloot = $g_iStatsLastAttack[$eLootTrophy]
		GUICtrlSetData($g_ahLblStatsTop[$eLootTrophy],_NumberFormat($topTrophyloot))
	EndIf

	If $ResetStats = 1 Then
		$ResetStats = 0
	EndIf

EndFunc   ;==>UpdateStats

Func ResetStats()
	$ResetStats = 1
	$g_iFirstAttack = 0
	$g_iTimePassed = 0
	$g_hTimerSinceStarted = TimerInit()
	GUICtrlSetData($g_hLblResultRuntime, "00:00:00")
	GUICtrlSetData($g_hLblResultRuntimeNow, "00:00:00")
	$g_iStatsStartedWith[$eLootGold] = $iGoldCurrent
	$g_iStatsStartedWith[$eLootElixir] = $iElixirCurrent
	$g_iStatsStartedWith[$eLootDarkElixir] = $iDarkCurrent
	$g_iStatsStartedWith[$eLootTrophy] = $iTrophyCurrent
	$g_iStatsTotalGain[$eLootGold] = 0
	$g_iStatsTotalGain[$eLootElixir] = 0
	$g_iStatsTotalGain[$eLootDarkElixir] = 0
	$g_iStatsTotalGain[$eLootTrophy] = 0
	$g_iStatsLastAttack[$eLootGold] = 0
	$g_iStatsLastAttack[$eLootElixir] = 0
	$g_iStatsLastAttack[$eLootDarkElixir] = 0
	$g_iStatsLastAttack[$eLootTrophy] = 0
	$g_iStatsBonusLast[$eLootGold] = 0
	$g_iStatsBonusLast[$eLootElixir] = 0
	$g_iStatsBonusLast[$eLootDarkElixir] = 0
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
	$g_iSmartZapGain = 0
	$g_iNumLSpellsUsed = 0
	$g_iNumEQSpellsUsed = 0
	For $i = 0 To $g_iModeCount
		$iAttackedVillageCount[$i] = 0
		$iTotalGoldGain[$i] = 0
		$iTotalElixirGain[$i] = 0
		$iTotalDarkGain[$i] = 0
		$iTotalTrophyGain[$i] = 0
		$iNbrOfDetectedMines[$i] = 0
		$iNbrOfDetectedCollectors[$i] = 0
		$iNbrOfDetectedDrills[$i] = 0
	Next

	For $i = 0 To $eTroopCount - 1
		$g_aiDonateStatsTroops[$i][0] = 0
    Next

	For $i = 0 To $eSpellCount - 1
	   If $i <> $eSpellClone Then
		   $g_aiDonateStatsSpells[$i][0] = 0
	   EndIf
	Next

	$g_iTotalDonateStatsTroops = 0
	$g_iTotalDonateStatsTroopsXP = 0
	$g_iTotalDonateStatsSpells = 0
	$g_iTotalDonateStatsSpellsXP = 0

	UpdateStats()
 EndFunc   ;==>ResetStats

 Func WallsStatsMAJ()
	$g_aiWallsCurrentCount[$g_iCmbUpgradeWallsLevel + 4] -= Number($iNbrOfWallsUpped)
	$g_aiWallsCurrentCount[$g_iCmbUpgradeWallsLevel + 5] += Number($iNbrOfWallsUpped)
	$iNbrOfWallsUpped = 0
	For $i = 4 To 12
		GUICtrlSetData($g_ahWallsCurrentCount[$i], $g_aiWallsCurrentCount[$i])
    Next
    SaveConfig()
EndFunc   ;==>WallsStatsMAJ
