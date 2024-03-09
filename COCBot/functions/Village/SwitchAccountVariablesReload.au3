; #FUNCTION# ====================================================================================================================
; Name ..........: SwitchAccountVariablesReload
; Description ...: This file contains the Sequence that runs all MBR Bot
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Demen
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func SwitchAccountVariablesReload($sType = "Load", $iAccount = $g_iCurAccount)

	; Empty arrays
	Local $aiZero[8] = [0, 0, 0, 0, 0, 0, 0, 0], $aiTrue[8] = [1, 1, 1, 1, 1, 1, 1, 1], $aiMinus[8] = [-1, -1, -1, -1, -1, -1, -1, -1]
	Local $aiZero83[8][3] = [[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]]
	Local $aiZero84[8][4] = [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]
	Local $asEmpty[8] = ["", "", "", "", "", "", "", ""]
	Local $aiZeroTroop[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	Local $aiZeroSpell[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

	; FirstRun
	Static $abFirstStart = $aiTrue
	Static $aiFirstRun = $aiTrue

	; Bottom & Multi-Stats
	Static $aiSkippedVillageCount = $aiZero
	Static $aiAttackedCount = $aiZero

	; Gain Stats
	Static $aiStatsTotalGain = $aiZero84, $aiStatsStartedWith = $aiZero84, $aiStatsLastAttack = $aiZero84, $aiStatsBonusLast = $aiZero84

	;Clan Capital
	Static $gSiLootCCGold = $aiZero
	Static $gSiLootCCMedal = $aiZero
	Static $gSiCCTrophies = $aiZero

	;Super Troops Boost
	Static $gSbFirstStartBarrel = $aiTrue

	;Builders Base
	Static $gSaiCurrentLootBB = $aiZero83
	Static $gSiFreeBuilderCountBB = $aiZero
	Static $gSiTotalBuilderCountBB = $aiZero

	; Misc Stats
	Static $aiNbrOfOoS = $aiZero
	Static $aiDroppedTrophyCount = $aiZero
	Static $aiSearchCost = $aiZero, $aiTrainCostElixir = $aiZero, $aiTrainCostDElixir = $aiZero, $aiTrainCostGold = $aiZero ; search and train troops cost
	Static $aiGoldFromMines = $aiZero, $aiElixirFromCollectors = $aiZero, $aiDElixirFromDrills = $aiZero ; number of resources gain by collecting mines, collectors, drills
	Static $aiCostGoldWall = $aiZero, $aiCostElixirWall = $aiZero, $aiCostGoldBuilding = $aiZero, $aiCostElixirBuilding = $aiZero, $aiCostDElixirBuilding = $aiZero, $aiCostDElixirHero = $aiZero, $aiCostElixirWarden = $aiZero ; wall, building and hero upgrade costs
	Static $aiNbrOfWallsUppedGold = $aiZero, $aiNbrOfWallsUppedElixir = $aiZero, $aiNbrOfBuildingsUppedGold = $aiZero, $aiNbrOfBuildingsUppedElixir = $aiZero, $aiNbrOfBuildingsUppedDElixir = $aiZero, $aiNbrOfHeroesUpped = $aiZero, $aiNbrOfWardenUpped = $aiZero ; number of wall, building, hero upgrades with gold, elixir, delixir
	Static $aiNbrOfWallsUpped = $aiZero

	; Attack Stats
	Static $aiAttackedVillageCount = $aiZero83 ; number of attack villages for DB, LB, TB
	Static $aiTotalGoldGain = $aiZero83, $aiTotalElixirGain = $aiZero83, $aiTotalDarkGain = $aiZero83, $aiTotalTrophyGain = $aiZero83 ; total resource gains for DB, LB, TB
	Static $aiNbrOfDetectedMines = $aiZero83, $aiNbrOfDetectedCollectors = $aiZero83, $aiNbrOfDetectedDrills = $aiZero83 ; number of mines, collectors, drills detected for DB, LB, TB
	Static $aiSmartZapGain = $aiZero, $aiNumEQSpellsUsed = $aiZero, $aiNumLSpellsUsed = $aiZero ; smart zap

	; Labs time
	Static $asLabUpgradeTime = $asEmpty, $aiLabStatus = $aiZero, $aiLabElixirCost = $aiZero, $aiLabDElixirCost = $aiZero
	Static $asPetLabUpgradeTime = $asEmpty, $aiPetStatus = $aiZero, $asiMinDark4PetUpgrade = $aiZero
	Static $asStarLabUpgradeTime = $asEmpty

	; Hero State
	Static $aiHeroAvailable = $aiZero
	Static $aiHeroUpgradingBit = $aiZero
	Static $aiHeroUpgrading = $aiZero83

	; QuickTrain comp
	Static $aaArmyQuickTroops[8] = [$aiZeroTroop, $aiZeroTroop, $aiZeroTroop, $aiZeroTroop, $aiZeroTroop, $aiZeroTroop, $aiZeroTroop, $aiZeroTroop]
	Static $aaArmyQuickSpells[8] = [$aiZeroSpell, $aiZeroSpell, $aiZeroSpell, $aiZeroSpell, $aiZeroSpell, $aiZeroSpell, $aiZeroSpell, $aiZeroSpell]
	Static $aiTotalQuickTroops = $aiZero
	Static $aiTotalQuickSpells = $aiZero
	Static $abQuickArmyMixed = $aiZero

	; Other global status
	Static $aiCommandStop = $aiMinus
	Static $aiAllBarracksUpgd = $aiZero

	Static $abFullStorage = $aiZero84
	Static $aiBuilderBoostDiscount = $aiZero

	Static $abNotNeedAllTime0 = $aiTrue
	Static $abNotNeedAllTime1 = $aiTrue

	;Clan Games
	Static $gSbClanGamesCompleted = $aiZero
	Static $gSbIsBBevent = $aiZero
	Static $SIsCGEventRunning = $aiZero
	Static $Sg_hCoolDownTimer = $aiZero

	;StarBonus
	Static $SStarBonusReceived = $aiZero

	; First time switch account
	Switch $sType
		Case "Reset"
			$abFirstStart = $aiTrue
			$aiFirstRun = $aiTrue

			$g_asTrainTimeFinish = $asEmpty
			For $i = 0 To 7
				GUICtrlSetData($g_ahLblTroopTime[$i], "")
				GUICtrlSetData($g_ahLblTroopTimeRep[$i], "")
			Next
			$g_ahTimerSinceSwitched = $aiZero
			$g_ahTimerSinceSwitched[$iAccount] = $g_hTimerSinceStarted

			; Multi-Stats
			$aiSkippedVillageCount = $aiZero
			$aiAttackedCount = $aiZero

			; Gain Stats
			$aiStatsTotalGain = $aiZero84
			$aiStatsStartedWith = $aiZero84
			$aiStatsLastAttack = $aiZero84
			$aiStatsBonusLast = $aiZero84

			; Misc Stats
			$aiNbrOfOoS = $aiZero
			$aiDroppedTrophyCount = $aiZero
			$aiSearchCost = $aiZero
			$aiTrainCostElixir = $aiZero
			$aiTrainCostDElixir = $aiZero
			$aiTrainCostGold = $aiZero
			$aiGoldFromMines = $aiZero
			$aiElixirFromCollectors = $aiZero
			$aiDElixirFromDrills = $aiZero

			$aiCostGoldWall = $aiZero
			$aiCostElixirWall = $aiZero
			$aiCostGoldBuilding = $aiZero
			$aiCostElixirBuilding = $aiZero
			$aiCostDElixirBuilding = $aiZero
			$aiCostDElixirHero = $aiZero
			$aiCostElixirWarden = $aiZero
			$aiNbrOfWallsUppedGold = $aiZero
			$aiNbrOfWallsUppedElixir = $aiZero
			$aiNbrOfBuildingsUppedGold = $aiZero
			$aiNbrOfBuildingsUppedElixir = $aiZero
			$aiNbrOfBuildingsUppedDElixir = $aiZero
			$aiNbrOfHeroesUpped = $aiZero
			$aiNbrOfWardenUpped = $aiZero
			$aiNbrOfWallsUpped = $aiZero

			; Attack Stats
			$aiAttackedVillageCount = $aiZero83
			$aiTotalGoldGain = $aiZero83
			$aiTotalElixirGain = $aiZero83
			$aiTotalDarkGain = $aiZero83
			$aiTotalTrophyGain = $aiZero83
			$aiNbrOfDetectedMines = $aiZero83
			$aiNbrOfDetectedCollectors = $aiZero83
			$aiNbrOfDetectedDrills = $aiZero83
			$aiSmartZapGain = $aiZero
			$aiNumEQSpellsUsed = $aiZero
			$aiNumLSpellsUsed = $aiZero

			; Labs time
			$asLabUpgradeTime = $asEmpty
			$aiLabElixirCost = $aiZero
			$aiLabDElixirCost = $aiZero
			$aiLabStatus = $aiZero
			$asPetLabUpgradeTime = $asEmpty
			$aiPetStatus = $aiZero
			$asiMinDark4PetUpgrade = $asEmpty
			$asStarLabUpgradeTime = $asEmpty

			;StarBonus
			$SStarBonusReceived = $aiZero

			; Hero State
			$aiHeroAvailable = $aiZero
			$aiHeroUpgradingBit = $aiZero
			$aiHeroUpgrading = $aiZero83

			;Clan Games
			$gSbClanGamesCompleted = $aiZero
			$gSbIsBBevent = $aiZero
			$SIsCGEventRunning = $aiZero
			$Sg_hCoolDownTimer = $aiZero

			; QuickTrain comp
			For $i = 0 To 7
				$aaArmyQuickTroops[$i] = $aiZeroTroop
				$aaArmyQuickSpells[$i] = $aiZeroSpell
			Next
			$aiTotalQuickTroops = $aiZero
			$aiTotalQuickSpells = $aiZero
			$abQuickArmyMixed = $aiZero

			; Other global status
			$aiCommandStop = $aiMinus
			$aiAllBarracksUpgd = $aiZero
			$abFullStorage = $aiZero84
			$aiBuilderBoostDiscount = $aiZero
			$abNotNeedAllTime0 = $aiTrue
			$abNotNeedAllTime1 = $aiTrue

			;Clan Capital
			$gSiLootCCGold = $aiZero
			$gSiLootCCMedal = $aiZero
			$gSiCCTrophies = $aiZero

			;Super Troops Boost
			$gSbFirstStartBarrel = $aiTrue

			;Builders Base
			$gSaiCurrentLootBB = $aiZero83
			$gSiFreeBuilderCountBB = $aiZero
			$gSiTotalBuilderCountBB = $aiZero

		Case "Save"
			$abFirstStart[$iAccount] = $g_bFirstStart
			$aiFirstRun[$iAccount] = $g_iFirstRun

			; Multi-Stats
			$aiSkippedVillageCount[$iAccount] = $g_iSkippedVillageCount
			$aiAttackedCount[$iAccount] = $g_aiAttackedCount

			; Gain Stats
			For $i = 0 To 3
				$aiStatsTotalGain[$iAccount][$i] = $g_iStatsTotalGain[$i]
				$aiStatsStartedWith[$iAccount][$i] = $g_iStatsStartedWith[$i]
				$aiStatsLastAttack[$iAccount][$i] = $g_iStatsLastAttack[$i]
				$aiStatsBonusLast[$iAccount][$i] = $g_iStatsBonusLast[$i]
			Next

			;Clan Capital
			$gSiLootCCGold[$iAccount] = $g_iLootCCGold
			$gSiLootCCMedal[$iAccount] = $g_iLootCCMedal
			$gSiCCTrophies[$iAccount] = $g_iCCTrophies

			;Super Troops Boost
			$gSbFirstStartBarrel[$iAccount] = $g_bFirstStartBarrel

			;Builders Base
			For $i = 0 To UBound($g_aiCurrentLootBB) - 1
				$gSaiCurrentLootBB[$iAccount][$i] = $g_aiCurrentLootBB[$i]
			Next
			$gSiFreeBuilderCountBB[$iAccount] = $g_iFreeBuilderCountBB
			$gSiTotalBuilderCountBB[$iAccount] = $g_iTotalBuilderCountBB

			; Misc Stats
			$aiNbrOfOoS[$iAccount] = $g_iNbrOfOoS
			$aiDroppedTrophyCount[$iAccount] = $g_iDroppedTrophyCount
			$aiSearchCost[$iAccount] = $g_iSearchCost
			$aiTrainCostElixir[$iAccount] = $g_iTrainCostElixir
			$aiTrainCostDElixir[$iAccount] = $g_iTrainCostDElixir
			$aiTrainCostGold[$iAccount] = $g_iTrainCostGold
			$aiGoldFromMines[$iAccount] = $g_iGoldFromMines
			$aiElixirFromCollectors[$iAccount] = $g_iElixirFromCollectors
			$aiDElixirFromDrills[$iAccount] = $g_iDElixirFromDrills

			$aiCostGoldWall[$iAccount] = $g_iCostGoldWall
			$aiCostElixirWall[$iAccount] = $g_iCostElixirWall
			$aiCostGoldBuilding[$iAccount] = $g_iCostGoldBuilding
			$aiCostElixirBuilding[$iAccount] = $g_iCostElixirBuilding
			$aiCostDElixirBuilding[$iAccount] = $g_iCostDElixirBuilding
			$aiCostDElixirHero[$iAccount] = $g_iCostDElixirHero
			$aiCostElixirWarden[$iAccount] = $g_iCostElixirWarden
			$aiNbrOfWallsUppedGold[$iAccount] = $g_iNbrOfWallsUppedGold
			$aiNbrOfWallsUppedElixir[$iAccount] = $g_iNbrOfWallsUppedElixir
			$aiNbrOfBuildingsUppedGold[$iAccount] = $g_iNbrOfBuildingsUppedGold
			$aiNbrOfBuildingsUppedElixir[$iAccount] = $g_iNbrOfBuildingsUppedElixir
			$aiNbrOfBuildingsUppedDElixir[$iAccount] = $g_iNbrOfBuildingsUppedDElixir
			$aiNbrOfHeroesUpped[$iAccount] = $g_iNbrOfHeroesUpped
			$aiNbrOfWardenUpped[$iAccount] = $g_iNbrOfWardenUpped
			$aiNbrOfWallsUpped[$iAccount] = $g_iNbrOfWallsUpped

			; Attack Stats
			For $i = 0 To $g_iModeCount - 1
				$aiAttackedVillageCount[$iAccount][$i] = $g_aiAttackedVillageCount[$i]
				$aiTotalGoldGain[$iAccount][$i] = $g_aiTotalGoldGain[$i]
				$aiTotalElixirGain[$iAccount][$i] = $g_aiTotalElixirGain[$i]
				$aiTotalDarkGain[$iAccount][$i] = $g_aiTotalDarkGain[$i]
				$aiTotalTrophyGain[$iAccount][$i] = $g_aiTotalTrophyGain[$i]
				$aiNbrOfDetectedMines[$iAccount][$i] = $g_aiNbrOfDetectedMines[$i]
				$aiNbrOfDetectedCollectors[$iAccount][$i] = $g_aiNbrOfDetectedCollectors[$i]
				$aiNbrOfDetectedDrills[$iAccount][$i] = $g_aiNbrOfDetectedDrills[$i]
			Next
			$aiSmartZapGain[$iAccount] = $g_iSmartZapGain
			$aiNumEQSpellsUsed[$iAccount] = $g_iNumEQSpellsUsed
			$aiNumLSpellsUsed[$iAccount] = $g_iNumLSpellsUsed

			; Labs time
			$asLabUpgradeTime[$iAccount] = $g_sLabUpgradeTime
			$aiLabElixirCost[$iAccount] = $g_iLaboratoryElixirCost
			$aiLabDElixirCost[$iAccount] = $g_iLaboratoryDElixirCost
			If GUICtrlGetState($g_hPicLabGreen) = $GUI_ENABLE + $GUI_SHOW Then
				$aiLabStatus[$iAccount] = 1
			ElseIf GUICtrlGetState($g_hPicLabRed) = $GUI_ENABLE + $GUI_SHOW Then
				$aiLabStatus[$iAccount] = 2
			Else
				$aiLabStatus[$iAccount] = 0
			EndIf

			$asPetLabUpgradeTime[$iAccount] = $g_sPetUpgradeTime
			If GUICtrlGetState($g_hPicPetGreen) = $GUI_ENABLE + $GUI_SHOW Then
				$aiPetStatus[$iAccount] = 1
			ElseIf GUICtrlGetState($g_hPicPetRed) = $GUI_ENABLE + $GUI_SHOW Then
				$aiPetStatus[$iAccount] = 2
			Else
				$aiPetStatus[$iAccount] = 0
			EndIf
			$asiMinDark4PetUpgrade[$iAccount] = $g_iMinDark4PetUpgrade

			$asStarLabUpgradeTime[$iAccount] = $g_sStarLabUpgradeTime

			;StarBonus
			$SStarBonusReceived[$iAccount] = $StarBonusReceived

			; Hero State
			$aiHeroAvailable[$iAccount] = $g_iHeroAvailable
			$aiHeroUpgradingBit[$iAccount] = $g_iHeroUpgradingBit
			For $i = 0 To 2
				$aiHeroUpgrading[$iAccount][$i] = $g_iHeroUpgrading[$i]
			Next

			; QuickTrain comp
			$aaArmyQuickTroops[$iAccount] = $g_aiArmyQuickTroops
			$aaArmyQuickSpells[$iAccount] = $g_aiArmyQuickSpells
			$aiTotalQuickTroops[$iAccount] = $g_iTotalQuickTroops
			$aiTotalQuickSpells[$iAccount] = $g_iTotalQuickSpells
			$abQuickArmyMixed[$iAccount] = $g_bQuickArmyMixed

			; Other global status
			$aiCommandStop[$iAccount] = $g_iCommandStop
			$aiAllBarracksUpgd[$iAccount] = $g_bAllBarracksUpgd

			;ClanGames
			$gSbClanGamesCompleted[$iAccount] = $g_bClanGamesCompleted
			$gSbIsBBevent[$iAccount] = $g_bIsBBevent
			$SIsCGEventRunning[$iAccount] = $IsCGEventRunning
			$Sg_hCoolDownTimer[$iAccount] = $g_hCoolDownTimer

			For $i = 0 To 3
				$abFullStorage[$iAccount][$i] = $g_abFullStorage[$i]
			Next
			$aiBuilderBoostDiscount[$iAccount] = $g_iBuilderBoostDiscount
			$abNotNeedAllTime0[$iAccount] = $g_abNotNeedAllTime[0]
			$abNotNeedAllTime1[$iAccount] = $g_abNotNeedAllTime[1]

		Case "Load"
			$g_bFirstStart = $abFirstStart[$iAccount]
			$g_iFirstRun = $aiFirstRun[$iAccount]

			; Multi-Stats
			$g_iSkippedVillageCount = $aiSkippedVillageCount[$iAccount]
			$g_aiAttackedCount = $aiAttackedCount[$iAccount]

			; Gain Stats
			For $i = 0 To 3
				$g_iStatsTotalGain[$i] = $aiStatsTotalGain[$iAccount][$i]
				$g_iStatsStartedWith[$i] = $aiStatsStartedWith[$iAccount][$i]
				$g_iStatsLastAttack[$i] = $aiStatsLastAttack[$iAccount][$i]
				$g_iStatsBonusLast[$i] = $aiStatsBonusLast[$iAccount][$i]
			Next

			;Clan Capital
			$g_iLootCCGold = $gSiLootCCGold[$iAccount]
			$g_iLootCCMedal = $gSiLootCCMedal[$iAccount]
			$g_iCCTrophies = $gSiCCTrophies[$iAccount]
			GUICtrlSetData($g_lblCapitalGold, _NumberFormat($g_iLootCCGold, True))
			GUICtrlSetData($g_lblCapitalMedal, _NumberFormat($g_iLootCCMedal, True))
			GUICtrlSetData($g_lblCapitalTrophies, _NumberFormat($g_iCCTrophies, True))
			PicCCTrophies()

			;Super Troops Boost
			$g_bFirstStartBarrel = $gSbFirstStartBarrel[$iAccount]

			;Builders Base
			For $i = 0 To UBound($g_aiCurrentLootBB) - 1
				$g_aiCurrentLootBB[$i] = $gSaiCurrentLootBB[$iAccount][$i]
				GUICtrlSetData($g_alblBldBaseStats[$i], _NumberFormat($g_aiCurrentLootBB[$i], True))
			Next
			PicBBTrophies()
			$g_iFreeBuilderCountBB = $gSiFreeBuilderCountBB[$iAccount]
			$g_iTotalBuilderCountBB = $gSiTotalBuilderCountBB[$iAccount]

			; Misc Stats
			$g_iNbrOfOoS = $aiNbrOfOoS[$iAccount]
			$g_iDroppedTrophyCount = $aiDroppedTrophyCount[$iAccount]
			$g_iSearchCost = $aiSearchCost[$iAccount]
			$g_iTrainCostElixir = $aiTrainCostElixir[$iAccount]
			$g_iTrainCostDElixir = $aiTrainCostDElixir[$iAccount]
			$g_iTrainCostGold = $aiTrainCostGold[$iAccount]
			$g_iGoldFromMines = $aiGoldFromMines[$iAccount]
			$g_iElixirFromCollectors = $aiElixirFromCollectors[$iAccount]
			$g_iDElixirFromDrills = $aiDElixirFromDrills[$iAccount]

			$g_iCostGoldWall = $aiCostGoldWall[$iAccount]
			$g_iCostElixirWall = $aiCostElixirWall[$iAccount]
			$g_iCostGoldBuilding = $aiCostGoldBuilding[$iAccount]
			$g_iCostElixirBuilding = $aiCostElixirBuilding[$iAccount]
			$g_iCostDElixirBuilding = $aiCostDElixirBuilding[$iAccount]
			$g_iCostDElixirHero = $aiCostDElixirHero[$iAccount]
			$g_iCostElixirWarden = $aiCostElixirWarden[$iAccount]
			$g_iNbrOfWallsUppedGold = $aiNbrOfWallsUppedGold[$iAccount]
			$g_iNbrOfWallsUppedElixir = $aiNbrOfWallsUppedElixir[$iAccount]
			$g_iNbrOfBuildingsUppedGold = $aiNbrOfBuildingsUppedGold[$iAccount]
			$g_iNbrOfBuildingsUppedElixir = $aiNbrOfBuildingsUppedElixir[$iAccount]
			$g_iNbrOfBuildingsUppedDElixir = $aiNbrOfBuildingsUppedDElixir[$iAccount]
			$g_iNbrOfHeroesUpped = $aiNbrOfHeroesUpped[$iAccount]
			$g_iNbrOfWardenUpped = $aiNbrOfWardenUpped[$iAccount]
			$g_iNbrOfWallsUpped = $aiNbrOfWallsUpped[$iAccount]

			; Attack Stats
			For $i = 0 To $g_iModeCount - 1
				$g_aiAttackedVillageCount[$i] = $aiAttackedVillageCount[$iAccount][$i]
				$g_aiTotalGoldGain[$i] = $aiTotalGoldGain[$iAccount][$i]
				$g_aiTotalElixirGain[$i] = $aiTotalElixirGain[$iAccount][$i]
				$g_aiTotalDarkGain[$i] = $aiTotalDarkGain[$iAccount][$i]
				$g_aiTotalTrophyGain[$i] = $aiTotalTrophyGain[$iAccount][$i]
				$g_aiNbrOfDetectedMines[$i] = $aiNbrOfDetectedMines[$iAccount][$i]
				$g_aiNbrOfDetectedCollectors[$i] = $aiNbrOfDetectedCollectors[$iAccount][$i]
				$g_aiNbrOfDetectedDrills[$i] = $aiNbrOfDetectedDrills[$iAccount][$i]
			Next
			$g_iSmartZapGain = $aiSmartZapGain[$iAccount]
			$g_iNumEQSpellsUsed = $aiNumEQSpellsUsed[$iAccount]
			$g_iNumLSpellsUsed = $aiNumLSpellsUsed[$iAccount]

			; Labs time
			$g_sLabUpgradeTime = $asLabUpgradeTime[$iAccount]
			GUICtrlSetData($g_hLbLLabTime, "")
			$g_iLaboratoryElixirCost = $aiLabElixirCost[$iAccount]
			$g_iLaboratoryDElixirCost = $aiLabDElixirCost[$iAccount]
			Local $Counter = 0
			For $i = $g_hPicLabGray To $g_hPicLabRed
				GUICtrlSetState($i, $GUI_HIDE)
				If $aiLabStatus[$iAccount] = $Counter Then GUICtrlSetState($i, $GUI_SHOW)
				$Counter += 1
			Next

			$g_sPetUpgradeTime = $asPetLabUpgradeTime[$iAccount]
			GUICtrlSetData($g_hLbLPetTime, "")
			Local $Counter = 0
			For $i = $g_hPicPetGray To $g_hPicPetRed
				GUICtrlSetState($i, $GUI_HIDE)
				If $aiPetStatus[$iAccount] = $Counter Then GUICtrlSetState($i, $GUI_SHOW)
				$Counter += 1
			Next
			$g_iMinDark4PetUpgrade = $asiMinDark4PetUpgrade[$iAccount]

			$g_sStarLabUpgradeTime = $asStarLabUpgradeTime[$iAccount]

			;Clan Games
			$g_bClanGamesCompleted = $gSbClanGamesCompleted[$iAccount]
			$g_bIsBBevent = $gSbIsBBevent[$iAccount]
			$IsCGEventRunning = $SIsCGEventRunning[$iAccount]
			$g_hCoolDownTimer = $Sg_hCoolDownTimer[$iAccount]

			;StarBonus
			$StarBonusReceived = $SStarBonusReceived[$iAccount]

			; Hero State
			$g_iHeroAvailable = $aiHeroAvailable[$iAccount]
			$g_iHeroUpgradingBit = $aiHeroUpgradingBit[$iAccount]
			For $i = 0 To 2
				$g_iHeroUpgrading[$i] = $aiHeroUpgrading[$iAccount][$i]
			Next

			; QuickTrain comp
			$g_aiArmyQuickTroops = $aaArmyQuickTroops[$iAccount]
			$g_aiArmyQuickSpells = $aaArmyQuickSpells[$iAccount]
			$g_iTotalQuickTroops = $aiTotalQuickTroops[$iAccount]
			$g_iTotalQuickSpells = $aiTotalQuickSpells[$iAccount]
			$g_bQuickArmyMixed = $abQuickArmyMixed[$iAccount]

			; Other global status
			$g_iCommandStop = $aiCommandStop[$iAccount]
			$g_bAllBarracksUpgd = $aiAllBarracksUpgd[$iAccount]
			For $i = 0 To 3
				$g_abFullStorage[$i] = $abFullStorage[$iAccount][$i]
			Next
			$g_iBuilderBoostDiscount = $aiBuilderBoostDiscount[$iAccount]
			$g_abNotNeedAllTime[0] = $abNotNeedAllTime0[$iAccount]
			$g_abNotNeedAllTime[1] = $abNotNeedAllTime1[$iAccount]

			ResetVariables("donated") ; reset for new account
			$g_aiAttackedCountSwitch[$iAccount] = $aiAttackedCount[$iAccount]

			; Reset the log
			$g_hLogFile = 0

		Case "UpdateStats"
			For $i = 0 To 3
				GUICtrlSetData($g_ahLblStatsStartedWith[$i], _NumberFormat($g_iStatsStartedWith[$i], True))
				$aiStatsTotalGain[$iAccount][$i] = $g_iStatsTotalGain[$i]
			Next
			For $i = 0 To 7
				GUICtrlSetData($g_ahLblHourlyStatsGoldAcc[$i], _NumberFormat(Round($aiStatsTotalGain[$i][$eLootGold] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "k / h")
				GUICtrlSetData($g_ahLblHourlyStatsElixirAcc[$i], _NumberFormat(Round($aiStatsTotalGain[$i][$eLootElixir] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "k / h")
				GUICtrlSetData($g_ahLblHourlyStatsDarkAcc[$i], _NumberFormat(Round($aiStatsTotalGain[$i][$eLootDarkElixir] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600 * 1000)) & " / h")
			Next

		Case "SetTime"
			Local $day, $hour, $min, $sec
			For $i = 0 To $g_iTotalAcc
				If _DateIsValid($asLabUpgradeTime[$i]) Then
					Local $iLabTime = _DateDiff("s", _NowCalc(), $asLabUpgradeTime[$i]) * 1000
					If $iLabTime > 0 Then
						_TicksToDay($iLabTime, $day, $hour, $min, $sec)
						GUICtrlSetData($g_ahLblLabTime[$i], $day > 0 ? StringFormat("%2ud %02i:%02i'", $day, $hour, $min) : StringFormat("%02i:%02i:%02i", $hour, $min, $sec))
						GUICtrlSetColor($g_ahLblLabTime[$i], $day > 0 ? $COLOR_GREEN : $COLOR_OLIVE)
					Else
						GUICtrlSetData($g_ahLblLabTime[$i], "")
						$asLabUpgradeTime[$i] = ""
					EndIf
				Else
					GUICtrlSetData($g_ahLblLabTime[$i], "")
				EndIf
				If _DateIsValid($asStarLabUpgradeTime[$i]) Then
					Local $iStarLabTime = _DateDiff("s", _NowCalc(), $asStarLabUpgradeTime[$i]) * 1000
					If $iStarLabTime > 0 Then
						_TicksToDay($iStarLabTime, $day, $hour, $min, $sec)
						GUICtrlSetData($g_ahLbLStarLabTime[$i], $day > 0 ? StringFormat("%2ud %02i:%02i'", $day, $hour, $min) : StringFormat("%02i:%02i:%02i", $hour, $min, $sec))
						GUICtrlSetColor($g_ahLbLStarLabTime[$i], $day > 0 ? $COLOR_GREEN : $COLOR_OLIVE)
					Else
						GUICtrlSetData($g_ahLbLStarLabTime[$i], "")
						$asStarLabUpgradeTime[$i] = ""
					EndIf
				Else
					GUICtrlSetData($g_ahLbLStarLabTime[$i], "")
				EndIf
				If _DateIsValid($asPetLabUpgradeTime[$i]) Then
					Local $iPetHouseTime = _DateDiff("s", _NowCalc(), $asPetLabUpgradeTime[$i]) * 1000
					If $iPetHouseTime > 0 Then
						_TicksToDay($iPetHouseTime, $day, $hour, $min, $sec)
						GUICtrlSetData($g_ahLbLPetTime[$i], $day > 0 ? StringFormat("%2ud %02i:%02i'", $day, $hour, $min) : StringFormat("%02i:%02i:%02i", $hour, $min, $sec))
						GUICtrlSetColor($g_ahLbLPetTime[$i], $day > 0 ? $COLOR_GREEN : $COLOR_OLIVE)
					Else
						GUICtrlSetData($g_ahLbLPetTime[$i], "")
						$asPetLabUpgradeTime[$i] = ""
					EndIf
				Else
					GUICtrlSetData($g_ahLbLPetTime[$i], "")
				EndIf
			Next

		Case "$g_iCommandStop"
			Return $aiCommandStop[$iAccount]

	EndSwitch

EndFunc   ;==>SwitchAccountVariablesReload
