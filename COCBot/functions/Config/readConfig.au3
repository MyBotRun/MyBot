; #FUNCTION# ====================================================================================================================
; Name ..........: readConfig.au3
; Description ...: Reads config file and sets variables
; Syntax ........: readConfig()
; Parameters ....: NA
; Return values .: NA
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================



Func readConfig($inputfile = $config, $partial = False) ;Reads config and sets it to the variables
	; Read the stats files into arrays, will create the files if necessary
	$aWeakBaseStats = readWeakBaseStats()

    $configLoaded=True
	If FileExists($building) Then
		SetDebugLog("Read Building Config " & $building)

		IniReadS($TownHallPos[0], $building, "other", "xTownHall", "-1")
		IniReadS($TownHallPos[1], $building, "other", "yTownHall", "-1")
		IniReadS($iTownHallLevel, $building, "other", "LevelTownHall", "0")

		IniReadS($aCCPos[0], $building, "other", "xCCPos", "0")
		IniReadS($aCCPos[1], $building, "other", "yCCPos", "0")

		IniReadS($barrackPos[0][0], $building, "other", "xBarrack1", "0")
		IniReadS($barrackPos[0][1], $building, "other", "yBarrack1", "0")

		IniReadS($barrackPos[1][0], $building, "other", "xBarrack2", "0")
		IniReadS($barrackPos[1][1], $building, "other", "yBarrack2", "0")

		IniReadS($barrackPos[2][0], $building, "other", "xBarrack3", "0")
		IniReadS($barrackPos[2][1], $building, "other", "yBarrack3", "0")

		IniReadS($barrackPos[3][0], $building, "other", "xBarrack4", "0")
		IniReadS($barrackPos[3][1], $building, "other", "yBarrack4", "0")

		IniReadS($ArmyPos[0], $building, "other", "xArmy", "0")
		IniReadS($ArmyPos[0], $building, "other", "yArmy", "0")
		IniReadS($TotalCamp, $building, "other", "totalcamp", "0")

		IniReadS($SFPos[0], $building, "other", "xspellfactory", "-1")
		IniReadS($SFPos[1], $building, "other", "yspellfactory", "-1")

		IniReadS($DSFPos[0], $building, "other", "xDspellfactory", "-1")
		IniReadS($DSFPos[1], $building, "other", "yDspellfactory", "-1")

		IniReadS($KingAltarPos[0], $building, "other", "xKingAltarPos", "-1")
		IniReadS($KingAltarPos[1], $building, "other", "yKingAltarPos", "-1")

		IniReadS($QueenAltarPos[0], $building, "other", "xQueenAltarPos", "-1")
		IniReadS($QueenAltarPos[1], $building, "other", "yQueenAltarPos", "-1")

		IniReadS($WardenAltarPos[0], $building, "other", "xWardenAltarPos", "-1")
		IniReadS($WardenAltarPos[1], $building, "other", "yWardenAltarPos", "-1")

		IniReadS($listResourceLocation, $building, "other", "listResource", "")

		For $iz = 0 to UBound($aUpgrades, 1) - 1 ; Reads Upgrade building data
			$aUpgrades[$iz][0] = IniRead($building, "upgrade", "xupgrade"&$iz, "-1")
			$aUpgrades[$iz][1] = IniRead($building, "upgrade", "yupgrade"&$iz, "-1")
			$aUpgrades[$iz][2] = IniRead($building, "upgrade", "upgradevalue"&$iz, "-1")
			$aUpgrades[$iz][3] = IniRead($building, "upgrade", "upgradetype"&$iz, "")
			$aUpgrades[$iz][4] = IniRead($building, "upgrade", "upgradename"&$iz, "")
			$aUpgrades[$iz][5] = IniRead($building, "upgrade", "upgradelevel"&$iz, "")
			$aUpgrades[$iz][6] = IniRead($building, "upgrade", "upgradetime"&$iz, "")
			$aUpgrades[$iz][7] = IniRead($building, "upgrade", "upgradeend"&$iz, "-1")
			$ichkbxUpgrade[$iz] = IniRead($building, "upgrade", "upgradechk"&$iz, "0")
			$ichkUpgrdeRepeat[$iz] = IniRead($building, "upgrade", "upgraderepeat"&$iz, "0")
			$ipicUpgradeStatus[$iz] = IniRead($building, "upgrade", "upgradestatusicon"&$iz, $eIcnTroops)
		Next

		InireadS($ichkLab,$building, "upgrade", "upgradetroops", "0")
		InireadS($icmbLaboratory,$building, "upgrade", "upgradetroopname", "0")
		$sLabUpgradeTime = IniRead($building, "upgrade", "upgradelabtime", "")
		InireadS($aLabPos[0],$building, "upgrade", "LabPosX", "0")
		InireadS($aLabPos[1],$building, "upgrade", "LabPosY", "0")

	EndIf

	If FileExists($config) Then

		SetDebugLog("Read Config " & $config)

		;General Settings--------------------------------------------------------------------------
		;InireadS($icmbProfile,$config, "general", "cmbProfile", "01")?
		IniReadS($frmBotPosX, $config, "general", "frmBotPosX", "900")
		IniReadS($frmBotPosY, $config, "general", "frmBotPosY", "20")


		IniReadS($iVillageName, $config, "general", "villageName", "")

		IniReadS($iCmbLog, $config, "general", "logstyle", "0")
		IniReadS($iDividerY, $config, "general", "LogDividerY", "243")

		IniReadS($ichkAutoStart, $config, "general", "AutoStart", "0")
		IniReadS($ichkAutoStartDelay, $config, "general", "AutoStartDelay", "10")
		IniReadS($restarted, $config, "general", "Restarted", "0")
		IniReadS($ichkBackground, $config, "general", "Background", "1")
		IniReadS($ichkBotStop, $config, "general", "BotStop", "0")
		IniReadS($icmbBotCommand, $config, "general", "Command", "0")
		IniReadS($icmbBotCond, $config, "general", "Cond", "0")
		IniReadS($icmbHoursStop, $config, "general", "Hour", "0")

		IniReadS($iDisposeWindows, $config, "general", "DisposeWindows", "0")
		IniReadS($icmbDisposeWindowsPos, $config, "general", "DisposeWindowsPos", "SNAP-TR")
		;InireadS($iUseOldOCR,$config, "general", "UseOldOCR", "0")

		IniReadS($AlertSearch, $config, "general", "AlertSearch", "0")

		IniReadS($ichkAttackNow, $config, "general", "AttackNow", "0")
		IniReadS($iAttackNowDelay, $config, "general", "attacknowdelay", "3")

		IniReadS($ichkbtnScheduler, $config, "general", "BtnScheduler", "0")


		;Upgrades
		IniReadS($ichkUpgradeKing, $config, "upgrade", "UpgradeKing", "0")
		IniReadS($ichkUpgradeQueen, $config, "upgrade", "UpgradeQueen", "0")
		IniReadS($ichkUpgradeWarden, $config, "upgrade", "UpgradeWarden", "0")
		IniReadS($itxtUpgrMinGold, $config, "upgrade", "minupgrgold", "100000")
		IniReadS($itxtUpgrMinElixir, $config, "upgrade", "minupgrelixir", "100000")
		IniReadS($itxtUpgrMinDark, $config, "upgrade", "minupgrdark", "2000")
		IniReadS($ichkWalls, $config, "upgrade", "auto-wall", "0")
		IniReadS($iSaveWallBldr, $config, "upgrade", "savebldr", "0")
		IniReadS($iUseStorage, $config, "upgrade", "use-storage", "0")
		IniReadS($icmbWalls, $config, "upgrade", "walllvl", "6")
		IniReadS($iMaxNbWall, $config, "upgrade", "MaxNbWall", "8")
		IniReadS($itxtWallMinGold, $config, "upgrade", "minwallgold", "0")
		IniReadS($itxtWallMinElixir, $config, "upgrade", "minwallelixir", "0")
		IniReadS($WallCost, $config, "upgrade", "WallCost", "0")

		IniReadS($itxtWall04ST, $config, "Walls", "Wall04", "0")
		IniReadS($itxtWall05ST, $config, "Walls", "Wall05", "0")
		IniReadS($itxtWall06ST, $config, "Walls", "Wall06", "0")
		IniReadS($itxtWall07ST, $config, "Walls", "Wall07", "0")
		IniReadS($itxtWall08ST, $config, "Walls", "Wall08", "0")
		IniReadS($itxtWall09ST, $config, "Walls", "Wall09", "0")
		IniReadS($itxtWall10ST, $config, "Walls", "Wall10", "0")
		IniReadS($itxtWall11ST, $config, "Walls", "Wall11", "0")

		IniReadS($itxtRestartGold, $config, "other", "minrestartgold", "50000")
		IniReadS($itxtRestartElixir, $config, "other", "minrestartelixir", "50000")
		IniReadS($itxtRestartDark, $config, "other", "minrestartdark", "500")


		;======================================================================================================================
		; Army training - Troop Settings-------------------------------------------------------
		IniReadS($iCmbTroopComp, $config, "troop", "TroopComposition", "9")
		IniReadS($icmbDarkTroopComp, $config, "troop", "DarkTroopComposition", "2")

		Local $tempTroop
		For $i = 0 To UBound($TroopName) - 1
			IniReadS($tempTroop, $config, "troop", $TroopName[$i], "0")
			Assign($TroopName[$i] & "Comp", $tempTroop)
		Next
		For $i = 0 To UBound($TroopDarkName) - 1
			IniReadS($tempTroop, $config, "troop", $TroopDarkName[$i], "0")
			Assign($TroopDarkName[$i] & "Comp", $tempTroop)
		Next


		For $i = 0 To 3 ;Covers all 4 Barracks
			IniReadS($barrackTroop[$i], $config, "troop", "troop" & $i + 1, "0")
		Next

		For $i = 0 To 1 ;Covers all 2 Barracks
			IniReadS($darkBarrackTroop[$i], $config, "troop", "Darktroop" & $i + 1, "0")
		Next

		IniReadS($fulltroop, $config, "troop", "fullTroop", "100")

		IniReadS($isldTrainITDelay, $config, "other", "TrainITDelay", "40")

		;Army training - Spells Creation  -----------------------------------------------------
		Local $tempQtaSpell
		IniReadS($iLightningSpellComp, $config, "Spells", "LightningSpell", "0")
		IniReadS($iRageSpellComp, $config, "Spells", "RageSpell", "0")
		IniReadS($iHealSpellComp, $config, "Spells", "HealSpell", "0")
		IniReadS($iJumpSpellComp, $config, "Spells", "JumpSpell", "0")
		IniReadS($iFreezeSpellComp, $config, "Spells", "FreezeSpell", "0")
		IniReadS($iPoisonSpellComp, $config, "Spells", "PoisonSpell", "0")
		IniReadS($iHasteSpellComp, $config, "Spells", "HasteSpell", "0")
		IniReadS($iEarthSpellComp, $config, "Spells", "EarthSpell", "0")
		IniReadS($iTotalCountSpell, $config, "Spells", "SpellFactory", "0")
		$iLightningSpellComp = Int($iLightningSpellComp)
		$iRageSpellComp = Int($iRageSpellComp)
		$iHealSpellComp = Int($iHealSpellComp)
		$iJumpSpellComp = Int($iJumpSpellComp)
		$iFreezeSpellComp = Int($iFreezeSpellComp)
		$iPoisonSpellComp = Int($iPoisonSpellComp)
		$iHasteSpellComp = Int($iHasteSpellComp)
		$iEarthSpellComp = Int($iEarthSpellComp)
		$iTotalCountSpell = Int($iTotalCountSpell)

		;======================================================================================================================
		;Search Settings------------------------------------------------------------------------

		IniReadS($iChkEnableAfter[$DB], $config, "search", "DBEnableAfter", "0")
		IniReadS($iCmbMeetGE[$DB], $config, "search", "DBMeetGE", "1")
		IniReadS($iChkMeetDE[$DB], $config, "search", "DBMeetDE", "0")
		IniReadS($iChkMeetTrophy[$DB], $config, "search", "DBMeetTrophy", "0")
		IniReadS($iChkMeetTH[$DB], $config, "search", "DBMeetTH", "0")
		IniReadS($iChkMeetTHO[$DB], $config, "search", "DBMeetTHO", "0")
		IniReadS($iChkWeakBase[$DB], $config, "search", "DBWeakBase", "0")
		IniReadS($iChkMeetOne[$DB], $config, "search", "DBMeetOne", "0")

		IniReadS($iEnableAfterCount[$DB], $config, "search", "DBEnableAfterCount", "1")
		IniReadS($iEnableBeforeCount[$DB], $config, "search", "DBEnableBeforeCount", "9999")
		IniReadS($iEnableAfterTropies[$DB], $config, "search", "DBEnableAfterTropies", "100")
		IniReadS($iEnableBeforeTropies[$DB], $config, "search", "DBEnableBeforeTropies", "6000")
		IniReadS($iEnableAfterArmyCamps[$DB], $config, "search", "DBEnableAfterArmyCamps", "100")
		IniReadS($iMinGold[$DB], $config, "search", "DBsearchGold", "80000")
		IniReadS($iMinElixir[$DB], $config, "search", "DBsearchElixir", "80000")
		IniReadS($iMinGoldPlusElixir[$DB], $config, "search", "DBsearchGoldPlusElixir", "160000")
		IniReadS($iMinDark[$DB], $config, "search", "DBsearchDark", "0")
		IniReadS($iMinTrophy[$DB], $config, "search", "DBsearchTrophy", "0")
		IniReadS($iCmbTH[$DB], $config, "search", "DBTHLevel", "0")

		IniReadS($iCmbWeakMortar[$DB], $config, "search", "DBWeakMortar", "5")
		IniReadS($iCmbWeakWizTower[$DB], $config, "search", "DBWeakWizTower", "4")
		IniReadS($iCmbWeakXBow[$DB], $config, "search", "DBWeakXBow", "4")
		IniReadS($iCmbWeakInferno[$DB], $config, "search", "DBWeakInferno", "1")
		IniReadS($iCmbWeakEagle[$DB], $config, "search", "DBWeakEagle", "2")
		IniReadS($iChkChkMortar[$DB], $config, "search", "DBCheckMortar", "0")
		IniReadS($iChkChkWizTower[$DB], $config, "search", "DBCheckWizTower", "0")
		IniReadS($iChkChkXBow[$DB], $config, "search", "DBCheckXBow", "0")
		IniReadS($iChkChkInferno[$DB], $config, "search", "DBCheckInferno", "0")
		IniReadS($iChkChkEagle[$DB], $config, "search", "DBCheckEagle", "0")

		IniReadS($iChkEnableAfter[$LB], $config, "search", "ABEnableAfter", "0")
		IniReadS($iCmbMeetGE[$LB], $config, "search", "ABMeetGE", "2")
		IniReadS($iChkMeetDE[$LB], $config, "search", "ABMeetDE", "0")
		IniReadS($iChkMeetTrophy[$LB], $config, "search", "ABMeetTrophy", "0")
		IniReadS($iChkMeetTH[$LB], $config, "search", "ABMeetTH", "0")
		IniReadS($iChkMeetTHO[$LB], $config, "search", "ABMeetTHO", "0")
		IniReadS($iChkWeakBase[$LB], $config, "search", "ABWeakBase", "0")
		IniReadS($iChkMeetOne[$LB], $config, "search", "ABMeetOne", "0")

		IniReadS($iEnableAfterCount[$LB], $config, "search", "ABEnableAfterCount", "1")
		IniReadS($iEnableBeforeCount[$LB], $config, "search", "ABEnableBeforeCount", "9999")
		IniReadS($iEnableAfterTropies[$LB], $config, "search", "ABEnableAfterTropies", "100")
		IniReadS($iEnableBeforeTropies[$LB], $config, "search", "ABEnableBeforeTropies", "6000")
		IniReadS($iEnableAfterArmyCamps[$LB], $config, "search", "ABEnableAfterArmyCamps", "100")

		IniReadS($iMinGold[$LB], $config, "search", "ABsearchGold", "80000")
		IniReadS($iMinElixir[$LB], $config, "search", "ABsearchElixir", "80000")
		IniReadS($iMinGoldPlusElixir[$LB], $config, "search", "ABsearchGoldPlusElixir", "160000")
		IniReadS($iMinDark[$LB], $config, "search", "ABsearchDark", "0")
		IniReadS($iMinTrophy[$LB], $config, "search", "ABsearchTrophy", "0")
		IniReadS($iCmbTH[$LB], $config, "search", "ABTHLevel", "0")

		IniReadS($iCmbWeakMortar[$LB], $config, "search", "ABWeakMortar", "5")
		IniReadS($iCmbWeakWizTower[$LB], $config, "search", "ABWeakWizTower", "4")
		IniReadS($iCmbWeakXBow[$LB], $config, "search", "ABWeakXBow", "4")
		IniReadS($iCmbWeakInferno[$LB], $config, "search", "ABWeakInferno", "1")
		IniReadS($iCmbWeakEagle[$LB], $config, "search", "ABWeakEagle", "2")
		IniReadS($iChkChkMortar[$LB], $config, "search", "ABCheckMortar", "0")
		IniReadS($iChkChkWizTower[$LB], $config, "search", "ABCheckWizTower", "0")
		IniReadS($iChkChkXBow[$LB], $config, "search", "ABCheckXBow", "0")
		IniReadS($iChkChkInferno[$LB], $config, "search", "ABCheckInferno", "0")
		IniReadS($iChkChkEagle[$LB], $config, "search", "ABCheckEagle", "0")

		IniReadS($iChkSearchReduction, $config, "search", "reduction", "0")
		IniReadS($ReduceCount, $config, "search", "reduceCount", "20")
		IniReadS($ReduceGold, $config, "search", "reduceGold", "2000")
		IniReadS($ReduceElixir, $config, "search", "reduceElixir", "2000")
		IniReadS($ReduceGoldPlusElixir, $config, "search", "reduceGoldPlusElixir", "4000")
		IniReadS($ReduceDark, $config, "search", "reduceDark", "100")
		IniReadS($ReduceTrophy, $config, "search", "reduceTrophy", "2")

		IniReadS($iChkRestartSearchLimit, $config, "search", "ChkRestartSearchLimit", "1")
		IniReadS($iRestartSearchlimit, $config, "search", "RestartSearchLimit", "50")

		IniReadS($iDBcheck, $config, "search", "DBcheck", "1")
		IniReadS($iABcheck, $config, "search", "ABcheck", "0")
		IniReadS($iTScheck, $config, "search", "TScheck", "0")

		IniReadS($iEnableSearchSearches[$DB], $config, "search", "ChkDBSearchSearches", "1")
		IniReadS($iEnableSearchSearches[$LB], $config, "search", "ChkABSearchSearches", "0")
		IniReadS($iEnableSearchSearches[$TS], $config, "search", "ChkTSSearchSearches", "0")
		IniReadS($iEnableSearchTropies[$DB], $config, "search", "ChkDBSearchTropies", "0")
		IniReadS($iEnableSearchTropies[$LB], $config, "search", "ChkABSearchTropies", "0")
		IniReadS($iEnableSearchTropies[$TS], $config, "search", "ChkTSSearchTropies", "0")
		IniReadS($iEnableSearchCamps[$DB], $config, "search", "ChkDBSearchCamps", "0")
		IniReadS($iEnableSearchCamps[$LB], $config, "search", "ChkABSearchCamps", "0")
		IniReadS($iEnableSearchCamps[$TS], $config, "search", "ChkTSSearchCamps", "0")

		IniReadS($OptBullyMode, $config, "search", "BullyMode", "0")
		IniReadS($ATBullyMode, $config, "search", "ATBullyMode", "0")
		IniReadS($YourTH, $config, "search", "YourTH", "0")
		IniReadS($iTHBullyAttackMode, $config, "search", "THBullyAttackMode", "0")

		IniReadS($THaddtiles, $config, "search", "THaddTiles", "2")

		IniReadS($iEnableAfterCount[$TS], $config, "search", "TSEnableAfterCount", "1")
		IniReadS($iEnableBeforeCount[$TS], $config, "search", "TSEnableBeforeCount", "9999")
		IniReadS($iEnableAfterTropies[$TS], $config, "search", "TSEnableAfterTropies", "100")
		IniReadS($iEnableBeforeTropies[$TS], $config, "search", "TSEnableBeforeTropies", "6000")
		IniReadS($iEnableAfterArmyCamps[$TS], $config, "search", "TSEnableAfterArmyCamps", "100")
		IniReadS($iMinGold[$TS], $config, "search", "TSsearchGold", "80000")
		IniReadS($iMinElixir[$TS], $config, "search", "TSsearchElixir", "80000")
		IniReadS($iMinGoldPlusElixir[$TS], $config, "search", "TSsearchGoldPlusElixir", "160000")
		IniReadS($iMinDark[$TS], $config, "search", "TSsearchDark", "600")
		IniReadS($iCmbMeetGE[$TS], $config, "search", "TSMeetGE", "1")

		IniReadS($iChkTrophyRange, $config, "search", "TrophyRange", "0")
		IniReadS($itxtdropTrophy, $config, "search", "MinTrophy", "5000")
		IniReadS($itxtMaxTrophy, $config, "search", "MaxTrophy", "5000")
		IniReadS($iChkTrophyHeroes, $config, "search", "chkTrophyHeroes", "0")
		IniReadS($iChkTrophyAtkDead, $config, "search", "chkTrophyAtkDead", "0")
		IniReadS($itxtDTArmyMin, $config, "search", "DTArmyMin", "70")

		IniReadS($itxtSWTtiles, $config, "search", "SWTtiles", "1")

		;======================================================================================================================
		;Attack Basics Settings-------------------------------------------------------------------------
		IniReadS($iAtkAlgorithm[$DB], $config, "attack", "DBAtkAlgorithm", "0")
		IniReadS($iAtkAlgorithm[$LB], $config, "attack", "ABAtkAlgorithm", "0")
		IniReadS($iChkDeploySettings[$DB], $config, "attack", "DBDeploy", "3")
		IniReadS($iCmbUnitDelay[$DB], $config, "attack", "DBUnitD", "6")
		IniReadS($iCmbWaveDelay[$DB], $config, "attack", "DBWaveD", "4")
		IniReadS($iChkRandomspeedatk[$DB], $config, "attack", "DBRandomSpeedAtk", "1")

		IniReadS($iChkDeploySettings[$LB], $config, "attack", "ABDeploy", "0")
		IniReadS($iCmbUnitDelay[$LB], $config, "attack", "ABUnitD", "6")
		IniReadS($iCmbWaveDelay[$LB], $config, "attack", "ABWaveD", "4")
		IniReadS($iChkRandomspeedatk[$LB], $config, "attack", "ABRandomSpeedAtk", "1")

		IniReadS($iCmbSelectTroop[$DB], $config, "attack", "DBSelectTroop", "0")
		IniReadS($iCmbSelectTroop[$LB], $config, "attack", "ABSelectTroop", "0")
		IniReadS($iCmbSelectTroop[$TS], $config, "attack", "TSSelectTroop", "0")

		IniReadS($iChkRedArea[$DB], $config, "attack", "DBSmartAttackRedArea", "1")

		IniReadS($iCmbSmartDeploy[$DB], $config, "attack", "DBSmartAttackDeploy", "0")

		IniReadS($iChkSmartAttack[$DB][0], $config, "attack", "DBSmartAttackGoldMine", "0")
		IniReadS($iChkSmartAttack[$DB][1], $config, "attack", "DBSmartAttackElixirCollector", "0")
		IniReadS($iChkSmartAttack[$DB][2], $config, "attack", "DBSmartAttackDarkElixirDrill", "0")

		IniReadS($iChkRedArea[$LB], $config, "attack", "ABSmartAttackRedArea", "1")
		IniReadS($iCmbSmartDeploy[$LB], $config, "attack", "ABSmartAttackDeploy", "1")

		IniReadS($iChkSmartAttack[$LB][0], $config, "attack", "ABSmartAttackGoldMine", "0")
		IniReadS($iChkSmartAttack[$LB][1], $config, "attack", "ABSmartAttackElixirCollector", "0")
		IniReadS($iChkSmartAttack[$LB][2], $config, "attack", "ABSmartAttackDarkElixirDrill", "0")

		IniReadS($KingAttack[$DB], $config, "attack", "DBKingAtk", "0")
		IniReadS($KingAttack[$LB], $config, "attack", "ABKingAtk", "0")
		IniReadS($KingAttack[$TS], $config, "attack", "TSKingAtk", "0")

		IniReadS($QueenAttack[$DB], $config, "attack", "DBQueenAtk", "0")
		IniReadS($QueenAttack[$LB], $config, "attack", "ABQueenAtk", "0")
		IniReadS($QueenAttack[$TS], $config, "attack", "TSQueenAtk", "0")

		IniReadS($iCmbStandardAlgorithm[$DB], $config, "attack", "DBStandardAlgorithm", "0")
		IniReadS($iCmbStandardAlgorithm[$LB], $config, "attack", "LBStandardAlgorithm", "0")

		Local $temp1, $temp2, $temp3
		IniReadS($temp1, $config, "attack", "DBKingAtk", $HERO_NOHERO)
		IniReadS($temp2, $config, "attack", "DBQueenAtk", $HERO_NOHERO)
		IniReadS($temp3, $config, "attack", "DBWardenAtk", $HERO_NOHERO)
		$iHeroAttack[$DB] = BitOR(Int($temp1), Int($temp2), Int($temp3))

		IniReadS($temp1, $config, "attack", "ABKingAtk", $HERO_NOHERO)
		IniReadS($temp2, $config, "attack", "ABQueenAtk", $HERO_NOHERO)
		IniReadS($temp3, $config, "attack", "ABWardenAtk", $HERO_NOHERO)
		$iHeroAttack[$LB] = BitOR(Int($temp1), Int($temp2), Int($temp3))

		IniReadS($temp1, $config, "attack", "DBKingWait", $HERO_NOHERO)
		IniReadS($temp2, $config, "attack", "DBQueenWait", $HERO_NOHERO)
		IniReadS($temp3, $config, "attack", "DBWardenWait", $HERO_NOHERO)
		$iHeroWait[$DB] = BitOR(Int($temp1), Int($temp2), Int($temp3))

		IniReadS($temp1, $config, "attack", "ABKingWait", $HERO_NOHERO)
		IniReadS($temp2, $config, "attack", "ABQueenWait", $HERO_NOHERO)
		IniReadS($temp3, $config, "attack", "ABWardenWait", $HERO_NOHERO)
		$iHeroWait[$LB] = BitOR(Int($temp1), Int($temp2), Int($temp3))

		IniReadS($iDropCC[$DB], $config, "attack", "DBDropCC", "0")
		IniReadS($iDropCC[$LB], $config, "attack", "ABDropCC", "0")
		IniReadS($iDropCC[$TS], $config, "attack", "TSDropCC", "0")

		IniReadS($WardenAttack[$DB], $config, "attack", "DBWardenAtk", "0")
		IniReadS($WardenAttack[$LB], $config, "attack", "ABWardenAtk", "0")
		IniReadS($WardenAttack[$TS], $config, "attack", "TSWardenAtk", "0")


		IniReadS($ichkLightSpell[$DB], $config, "attack", "DBLightSpell", "0")
		IniReadS($ichkLightSpell[$LB], $config, "attack", "ABLightSpell", "0")
		IniReadS($ichkLightSpell[$TS], $config, "attack", "TSLightSpell", "0")

		IniReadS($ichkHealSpell[$DB], $config, "attack", "DBHealSpell", "0")
		IniReadS($ichkHealSpell[$LB], $config, "attack", "ABHealSpell", "0")
		IniReadS($ichkHealSpell[$TS], $config, "attack", "TSHealSpell", "0")

		IniReadS($ichkRageSpell[$DB], $config, "attack", "DBRageSpell", "0")
		IniReadS($ichkRageSpell[$LB], $config, "attack", "ABRageSpell", "0")
		IniReadS($ichkRageSpell[$TS], $config, "attack", "TSRageSpell", "0")

		IniReadS($ichkJumpSpell[$DB], $config, "attack", "DBJumpSpell", "0")
		IniReadS($ichkJumpSpell[$LB], $config, "attack", "ABJumpSpell", "0")
		IniReadS($ichkJumpSpell[$TS], $config, "attack", "TSJumpSpell", "0")

		IniReadS($ichkFreezeSpell[$DB], $config, "attack", "DBFreezeSpell", "0")
		IniReadS($ichkFreezeSpell[$LB], $config, "attack", "ABFreezeSpell", "0")
		IniReadS($ichkFreezeSpell[$TS], $config, "attack", "TSFreezeSpell", "0")

		IniReadS($ichkPoisonSpell[$DB], $config, "attack", "DBPoisonSpell", "0")
		IniReadS($ichkPoisonSpell[$LB], $config, "attack", "ABPoisonSpell", "0")
		IniReadS($ichkPoisonSpell[$TS], $config, "attack", "TSPoisonSpell", "0")

		IniReadS($ichkEarthquakeSpell[$DB], $config, "attack", "DBEarthquakeSpell", "0")
		IniReadS($ichkEarthquakeSpell[$LB], $config, "attack", "ABEarthquakeSpell", "0")
		IniReadS($ichkEarthquakeSpell[$TS], $config, "attack", "TSEarthquakeSpell", "0")

		IniReadS($ichkHasteSpell[$DB], $config, "attack", "DBHasteSpell", "0")
		IniReadS($ichkHasteSpell[$LB], $config, "attack", "ABHasteSpell", "0")
		IniReadS($ichkHasteSpell[$TS], $config, "attack", "TSHasteSpell", "0")

		IniReadS($scmbDBScriptName, $config, "attack", "ScriptDB", "Barch four fingers")
		IniReadS($scmbABScriptName, $config, "attack", "ScriptAB", "Barch four fingers")

		IniReadS($iActivateKQCondition, $config, "attack", "ActivateKQ", "Auto")
		IniReadS($delayActivateKQ, $config, "attack", "delayActivateKQ", "9")
		$delayActivateKQ *= 1000
		IniReadS($iActivateWardenCondition, $config, "attack", "ActivateWarden", "1")
		IniReadS($delayActivateW, $config, "attack", "delayActivateW", "9")
		$delayActivateW *= 1000

		IniReadS($TakeLootSnapShot, $config, "attack", "TakeLootSnapShot", "0")
		IniReadS($ScreenshotLootInfo, $config, "attack", "ScreenshotLootInfo", "0")



		IniReadS($scmbAttackTHType, $config, "attack", "AttackTHType", "bam")


		IniReadS($THSnipeBeforeDBEnable, $config, "attack", "THSnipeBeforeDBEnable", "0")
		IniReadS($THSnipeBeforeLBEnable, $config, "attack", "THSnipeBeforeLBEnable", "0")
		IniReadS($THSnipeBeforeDBTiles, $config, "attack", "THSnipeBeforeDBTiles", "0")
		IniReadS($THSnipeBeforeLBTiles, $config, "attack", "THSnipeBeforeLBTiles", "0")
		IniReadS($THSnipeBeforeDBScript, $config, "attack", "THSnipeBeforeDBScript", "bam")
		IniReadS($THSnipeBeforeLBScript, $config, "attack", "THSnipeBeforeLBScript", "bam")



		;MilkingAttack
		IniReadS($MilkFarmLocateMine, $config, "MilkingAttack", "LocateMine", "1")
		IniReadS($MilkFarmLocateElixir, $config, "MilkingAttack", "LocateElixir", "1")
		IniReadS($MilkFarmLocateDrill, $config, "MilkingAttack", "LocateDrill", "1")
		Local $tempMilkFarmElixirParam
		IniReadS($tempMilkFarmElixirParam, $config, "MilkingAttack", "LocateElixirLevel", "-1|-1|-1|-1|-1|-1|2|2|2")
		$MilkFarmElixirParam = StringSplit($tempMilkFarmElixirParam, "|", 2)
		If UBound($MilkFarmElixirParam) <> 9 Then $MilkFarmElixirParam = StringSplit("-1|-1|-1|-1|-1|-1|2|2|2", "|", 2)
		IniReadS($MilkFarmMineParam, $config, "MilkingAttack", "MineParam", "5")
		IniReadS($MilkFarmDrillParam, $config, "MilkingAttack", "DrillParam", "1")

		IniReadS($MilkFarmAttackElixirExtractors, $config, "MilkingAttack", "AttackElixir", "1")
		IniReadS($MilkFarmAttackGoldMines, $config, "MilkingAttack", "AttackMine", "1")
		IniReadS($MilkFarmAttackDarkDrills, $config, "MilkingAttack", "AttackDrill", "1")
		IniReadS($MilkFarmLimitGold, $config, "MilkingAttack", "LimitGold", "9950000")
		IniReadS($MilkFarmLimitElixir, $config, "MilkingAttack", "LimitElixir", "9950000")
		IniReadS($MilkFarmLimitDark, $config, "MilkingAttack", "LimitDark", "200000")
		IniReadS($MilkFarmResMaxTilesFromBorder, $config, "MilkingAttack", "MaxTiles", "1")

		IniReadS($MilkFarmTroopForWaveMin, $config, "MilkingAttack", "TroopForWaveMin", "4")
		IniReadS($MilkFarmTroopForWaveMax, $config, "MilkingAttack", "TroopForWaveMax", "6")
		IniReadS($MilkFarmTroopMaxWaves, $config, "MilkingAttack", "MaxWaves", "4")
		IniReadS($MilkFarmDelayFromWavesMin, $config, "MilkingAttack", "DelayBetweenWavesMin", "3000")
		IniReadS($MilkFarmDelayFromWavesMax, $config, "MilkingAttack", "DelayBetweenWavesMax", "5000")
		IniReadS($MilkFarmForcetolerance, $config, "MilkingAttack", "MilkFarmForceTolerance", "0")
		IniReadS($MilkFarmForcetolerancenormal, $config, "MilkingAttack", "MilkFarmForcetolerancenormal", "60")
		IniReadS($MilkFarmForcetoleranceboosted, $config, "MilkingAttack", "MilkFarmForcetoleranceboosted", "60")
		IniReadS($MilkFarmForcetolerancedestroyed, $config, "MilkingAttack", "MilkFarmForcetolerancedestroyed", "60")

		IniReadS($MilkingAttackCheckStructureDestroyedBeforeAttack, $config, "MilkingAttack", "CheckStructureDestroyedBeforeAttack", "0")
		IniReadS($MilkingAttackCheckStructureDestroyedAfterAttack, $config, "MilkingAttack", "CheckStructureDestroyedAfterAttack", "0")

		IniReadS($MilkingAttackDropGoblinAlgorithm, $config, "MilkingAttack", "DropRandomPlace", "0")

		IniReadS($MilkFarmTHMaxTilesFromBorder, $config, "MilkingAttack", "TownhallTiles", "0")
		IniReadS($MilkFarmAlgorithmTh, $config, "MilkingAttack", "TownHallAlgorithm", "Bam")
		IniReadS($MilkFarmSnipeEvenIfNoExtractorsFound, $config, "MilkingAttack", "TownHallHitAnyway", "0")

		IniReadS($MilkingAttackStructureOrder, $config, "MilkingAttack", "StructureOrder", "1")

		IniReadS($MilkAttackAfterTHSnipe, $config, "MilkingAttack", "MilkAttackAfterTHSnipe", "0")
		IniReadS($MilkAttackAfterScriptedAtk, $config, "MilkingAttack", "MilkAttackAfterScriptedAtk", "0")

;~ 		IniReadS($iCmbStandardAlgorithm[$MA], $config, "MilkingAttack", "MAStandardAlgorithm", "0")
;~ 		IniReadS($iChkDeploySettings[$MA], $config, "MilkingAttack", "MADeploy", "0")
;~ 		IniReadS($iCmbUnitDelay[$MA], $config, "MilkingAttack", "MAUnitD", "5")
;~ 		IniReadS($iCmbWaveDelay[$MA], $config, "MilkingAttack", "MAWaveD", "5")
;~ 		IniReadS($iChkRandomspeedatk[$MA], $config, "MilkingAttack", "MARandomSpeedAtk", "0")
;~ 		IniReadS($iChkRedArea[$MA], $config, "MilkingAttack", "MASmartAttackRedArea", "1")
;~ 		IniReadS($iChkSmartAttack[$MA][0], $config, "MilkingAttack", "MASmartAttackGoldMine", "0")
;~ 		IniReadS($iChkSmartAttack[$MA][1], $config, "MilkingAttack", "MASmartAttackElixirCollector", "0")
;~ 		IniReadS($iChkSmartAttack[$MA][2], $config, "MilkingAttack", "MASmartAttackDarkElixirDrill", "0")

		IniReadS($MilkAttackCSVscript, $config, "MilkingAttack", "MilkAttackCSVscript", "0")
		IniReadS($MilkAttackType, $config, "MilkingAttack", "MilkAttackType", "0")





		;======================================================================================================================
		;End Battle Settings------------------------------------------------------------------------
		IniReadS($sTimeStopAtk[$DB], $config, "endbattle", "txtDBTimeStopAtk", "20")
		IniReadS($iChkTimeStopAtk[$DB], $config, "endbattle", "chkDBTimeStopAtk", "1")
		IniReadS($sTimeStopAtk2[$DB], $config, "endbattle", "txtDBTimeStopAtk2", "7")
		IniReadS($iChkTimeStopAtk2[$DB], $config, "endbattle", "chkDBTimeStopAtk2", "0")
		IniReadS($stxtMinGoldStopAtk2[$DB], $config, "endbattle", "txtDBMinGoldStopAtk2", "1000")
		IniReadS($stxtMinElixirStopAtk2[$DB], $config, "endbattle", "txtDBMinElixirStopAtk2", "1000")
		IniReadS($stxtMinDarkElixirStopAtk2[$DB], $config, "endbattle", "txtDBMinDarkElixirStopAtk2", "50")
		IniReadS($ichkEndOneStar[$DB], $config, "endbattle", "chkDBEndOneStar", "0")
		IniReadS($ichkEndTwoStars[$DB], $config, "endbattle", "chkDBEndTwoStars", "0")
		IniReadS($ichkEndNoResources[$DB], $config, "endbattle", "chkDBEndNoResources", "0")

		IniReadS($sTimeStopAtk[$LB], $config, "endbattle", "txtABTimeStopAtk", "20")
		IniReadS($iChkTimeStopAtk[$LB], $config, "endbattle", "chkABTimeStopAtk", "1")
		IniReadS($sTimeStopAtk2[$LB], $config, "endbattle", "txtABTimeStopAtk2", "7")
		IniReadS($iChkTimeStopAtk2[$LB], $config, "endbattle", "chkABTimeStopAtk2", "0")
		IniReadS($stxtMinGoldStopAtk2[$LB], $config, "endbattle", "txtABMinGoldStopAtk2", "1000")
		IniReadS($stxtMinElixirStopAtk2[$LB], $config, "endbattle", "txtABMinElixirStopAtk2", "1000")
		IniReadS($stxtMinDarkElixirStopAtk2[$LB], $config, "endbattle", "txtABMinDarkElixirStopAtk2", "50")
		IniReadS($ichkEndOneStar[$LB], $config, "endbattle", "chkABEndOneStar", "0")
		IniReadS($ichkEndTwoStars[$LB], $config, "endbattle", "chkABEndTwoStars", "0")
		IniReadS($ichkEndNoResources[$LB], $config, "endbattle", "chkABEndNoResources", "0")

		IniReadS($sTimeStopAtk[$TS], $config, "endbattle", "txtTSTimeStopAtk", "20")
		IniReadS($iChkTimeStopAtk[$TS], $config, "endbattle", "chkTSTimeStopAtk", "1")
		IniReadS($sTimeStopAtk2[$TS], $config, "endbattle", "txtTSTimeStopAtk2", "7")
		IniReadS($iChkTimeStopAtk2[$TS], $config, "endbattle", "chkTSTimeStopAtk2", "0")
		IniReadS($stxtMinGoldStopAtk2[$TS], $config, "endbattle", "txtTSMinGoldStopAtk2", "1000")
		IniReadS($stxtMinElixirStopAtk2[$TS], $config, "endbattle", "txtTSMinElixirStopAtk2", "1000")
		IniReadS($stxtMinDarkElixirStopAtk2[$TS], $config, "endbattle", "txtTSMinDarkElixirStopAtk2", "50")
		IniReadS($ichkEndOneStar[$TS], $config, "endbattle", "chkTSEndOneStar", "0")
		IniReadS($ichkEndTwoStars[$TS], $config, "endbattle", "chkTSEndTwoStars", "0")
		IniReadS($ichkEndNoResources[$TS], $config, "endbattle", "chkTSEndNoResources", "0")

		;end battle de side
		IniReadS($DESideEB, $config, "endbattle", "chkDESideEB", "0")
		IniReadS($DELowEndMin, $config, "endbattle", "txtDELowEndMin", "25")
		IniReadS($DisableOtherEBO, $config, "endbattle", "chkDisableOtherEBO", "0")
		IniReadS($DEEndOneStar, $config, "endbattle", "chkDEEndOneStar", "0")
		IniReadS($DEEndBk, $config, "endbattle", "chkDEEndBk", "0")
		IniReadS($DEEndAq, $config, "endbattle", "chkDEEndAq", "0")


		;======================================================================================================================
		;Attack Adv. Settings--------------------------------------------------------------------------

		IniReadS($iUnbreakableMode, $config, "Unbreakable", "chkUnbreakable", "0")
		IniReadS($iUnbreakableWait, $config, "Unbreakable", "UnbreakableWait", "5")
		IniReadS($iUnBrkMinGold, $config, "Unbreakable", "minUnBrkgold", "50000")
		IniReadS($iUnBrkMinElixir, $config, "Unbreakable", "minUnBrkelixir", "50000")
		IniReadS($iUnBrkMinDark, $config, "Unbreakable", "minUnBrkdark", "5000")
		IniReadS($iUnBrkMaxGold, $config, "Unbreakable", "maxUnBrkgold", "600000")
		IniReadS($iUnBrkMaxElixir, $config, "Unbreakable", "maxUnBrkelixir", "600000")
		IniReadS($iUnBrkMaxDark, $config, "Unbreakable", "maxUnBrkdark", "10000")

		;======================================================================================================================

		IniReadS($iChkUseCCBalanced, $config, "ClanClastle", "BalanceCC", "0")
		IniReadS($iCmbCCDonated, $config, "ClanClastle", "BalanceCCDonated", "1")
		IniReadS($iCmbCCReceived, $config, "ClanClastle", "BalanceCCReceived", "1")

		;======================================================================================================================

		;Misc Settings--------------------------------------------------------------------------



		IniReadS($ichkTrap, $config, "other", "chkTrap", "1")
		IniReadS($iChkCollect, $config, "other", "chkCollect", "1")
		IniReadS($ichkTombstones, $config, "other", "chkTombstones", "1")
		IniReadS($ichkCleanYard, $config, "other", "chkCleanYard", "0")
		;Boju Only clear GemBox
		IniReadS($ichkGemsBox, $config, "other", "chkGemsBox", "0")
		;Only clear GemBox
		IniReadS($sTimeWakeUp, $config, "other", "txtTimeWakeUp", "0")
		IniReadS($iVSDelay, $config, "other", "VSDelay", "0")
		IniReadS($iMaxVSDelay, $config, "other", "MaxVSDelay", "4")

		IniReadS($iWAOffsetX, $config, "other", "WAOffsetX", "0")
		IniReadS($iWAOffsetY, $config, "other", "WAOffsetY", "0")

		;PushBullet Settings ---------------------------------------------
		IniReadS($PushBulletToken, $config, "pushbullet", "AccountToken", "")
		IniReadS($iOrigPushBullet, $config, "pushbullet", "OrigPushBullet", $sCurrProfile)

		IniReadS($iAlertPBVillage, $config, "pushbullet", "AlertPBVillage", "0")
		IniReadS($iLastAttackPB, $config, "pushbullet", "AlertPBLastAttack", "0")
		IniReadS($iAlertPBLastRaidTxt, $config, "pushbullet", "AlertPBLastRaidTxt", "0")

		IniReadS($PushBulletEnabled, $config, "pushbullet", "PBEnabled", "0")
		IniReadS($pRemote, $config, "pushbullet", "PBRemote", "0")
		IniReadS($iDeleteAllPBPushes, $config, "pushbullet", "DeleteAllPBPushes", "0")
		IniReadS($pMatchFound, $config, "pushbullet", "AlertPBVMFound", "0")
		IniReadS($pLastRaidImg, $config, "pushbullet", "AlertPBLastRaid", "0")
		IniReadS($pWallUpgrade, $config, "pushbullet", "AlertPBWallUpgrade", "0")
		IniReadS($pOOS, $config, "pushbullet", "AlertPBOOS", "0")
		IniReadS($pTakeAbreak, $config, "pushbullet", "AlertPBVBreak", "0")
		IniReadS($pAnotherDevice, $config, "pushbullet", "AlertPBOtherDevice", "0")
		IniReadS($icmbHoursPushBullet, $config, "pushbullet", "HoursPushBullet", "4")
		IniReadS($ichkDeleteOldPBPushes, $config, "pushbullet", "DeleteOldPBPushes", "0")
		IniReadS($ichkAlertPBCampFull, $config, "pushbullet", "AlertPBCampFull", "0")
		IniReadS($iAlertPBVillage, $config, "pushbullet", "AlertPBVillage", "0")
		IniReadS($iLastAttackPB, $config, "pushbullet", "AlertPBLastAttack", "0")

		IniReadS($ichkDeleteLogs, $config, "deletefiles", "DeleteLogs", "1")
		IniReadS($iDeleteLogsDays, $config, "deletefiles", "DeleteLogsDays", "2")
		IniReadS($ichkDeleteTemp, $config, "deletefiles", "DeleteTemp", "1")
		IniReadS($iDeleteTempDays, $config, "deletefiles", "DeleteTempDays", "2")
		IniReadS($ichkDeleteLoots, $config, "deletefiles", "DeleteLoots", "1")
		IniReadS($iDeleteLootsDays, $config, "deletefiles", "DeleteLootsDays", "2")

	    $DebugClick = BitOR($DebugClick, IniRead($config, "debug", "debugsetclick", "0"))
		If $DevMode = 1 Then
			$DebugSetlog = BitOR($DebugSetlog, IniRead($config, "debug", "debugsetlog", "0"))
			$DebugOcr = BitOR($DebugOcr, IniRead($config, "debug", "debugocr", "0"))
			$DebugImageSave = BitOR($DebugImageSave, IniRead($config, "debug", "debugimagesave", "0"))
			$debugBuildingPos = BitOR($debugBuildingPos, IniRead($config, "debug", "debugbuildingpos", "0"))
			$debugsetlogTrain = BitOR($debugsetlogTrain, IniRead($config, "debug", "debugtrain", "0"))
			$makeIMGCSV = BitOR($debugBuildingPos, IniRead($config, "debug", "debugmakeimgcsv", "0"))
			$debugresourcesoffset = BitOR($debugresourcesoffset, IniRead($config, "debug", "debugresourcesoffset", "0"))
			$continuesearchelixirdebug = BitOR($continuesearchelixirdebug, IniRead($config, "debug", "continuesearchelixirdebug", "0"))
			$debugMilkingIMGmake =  BitOR($debugMilkingIMGmake, IniRead($config, "debug", "debugMilkingIMGmake", "0"))
			$debugOCRdonate = BitOr ($debugOCRdonate,  IniRead($config, "debug", "debugOCRDonate", "0"))
			;InireadS(xxxx,$config, "attack", "xxxx", "0")
			;InireadS(xxxx,$config, "attack", "xxxx", "0")
			;InireadS(xxxx,$config, "attack", "xxxx", "0")
			;InireadS(xxxx,$config, "attack", "xxxx", "0")
			;InireadS(xxxx,$config, "attack", "xxxx", "0")
			;InireadS(xxxx,$config, "attack", "xxxx", "0")
			;InireadS(xxxx,$config, "attack", "xxxx", "0")
			;InireadS(xxxx,$config, "attack", "xxxx", "0")
			;InireadS(xxxx,$config, "attack", "xxxx", "0")
			;InireadS(xxxx,$config, "attack", "xxxx", "0")
			;InireadS(xxxx,$config, "attack", "xxxx", "0")
		EndIf

		; Hours Planned
		$iPlannedDonateHours = StringSplit(IniRead($config, "planned", "DonateHours", "1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1"), "|", $STR_NOCOUNT)
		$iPlannedRequestCCHours = StringSplit(IniRead($config, "planned", "RequestHours", "1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1"), "|", $STR_NOCOUNT)
		$iPlannedDropCCHours = StringSplit(IniRead($config, "planned", "DropCCHours", "1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1"), "|", $STR_NOCOUNT)
		$iPlannedDonateHoursEnable = IniRead($config, "planned", "DonateHoursEnable", "0")
		$iPlannedRequestCCHoursEnable = IniRead($config, "planned", "RequestHoursEnable", "0")
		$iPlannedDropCCHoursEnable = IniRead($config, "planned", "DropCCEnable", "0")
		$iPlannedBoostBarracksEnable = IniRead($config, "planned", "BoostBarracksHoursEnable", "0")
		$iPlannedBoostBarracksHours = StringSplit(IniRead($config, "planned", "BoostBarracksHours", "1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1"), "|", $STR_NOCOUNT)
		$iPlannedattackHours = StringSplit(IniRead($config, "planned", "attackHours", "1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1"), "|", $STR_NOCOUNT)
		$iPlannedAttackWeekDays = StringSplit(IniRead($config, "planned", "attackDays", "1|1|1|1|1|1|1"), "|", $STR_NOCOUNT)
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")

		;Share Attack Settings----------------------------------------
		$iShareminGold = IniRead($config, "shareattack", "minGold", "200000")
		$iShareminElixir = IniRead($config, "shareattack", "minElixir", "200000")
		$iSharemindark = IniRead($config, "shareattack", "minDark", "100")
		$iShareAttack = IniRead($config, "shareattack", "ShareAttack", "0")
		$sShareMessage = StringReplace(IniRead($config, "shareattack", "Message", "Nice|Good|Thanks|Wowwww"), "|", @CRLF)
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")

		;screenshot type: 0 JPG   1 PNG
		$iScreenshotType = IniRead($config, "other", "ScreenshotType", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")

		$ichkScreenshotHideName = IniRead($config, "other", "ScreenshotHideName", "1")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")

		;forced Total Camp values
		$ichkTotalCampForced = IniRead($config, "other", "ChkTotalCampForced", "0")
		$iValueTotalCampForced = IniRead($config, "other", "ValueTotalCampForced", "200")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")

		$ichkSinglePBTForced = IniRead($config, "other", "chkSinglePBTForced", "0")
		$iValueSinglePBTimeForced = IniRead($config, "other", "ValueSinglePBTimeForced", "18")
		$iValuePBTimeForcedExit = IniRead($config, "other", "ValuePBTimeForcedExit", "15")

		$ichkLanguage = IniRead($config, "General", "ChkLanguage", "1")
		$ichkVersion = IniRead($config, "General", "ChkVersion", "1")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")


		;Donate Settings-------------------------------------------------------------------------
		$sTxtRequest = IniRead($config, "donate", "txtRequest", "")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")

		$ichkDonateBarbarians = IniRead($config, "donate", "chkDonateBarbarians", "0")
		$ichkDonateAllBarbarians = IniRead($config, "donate", "chkDonateAllBarbarians", "0")
		$sTxtDonateBarbarians = StringReplace(IniRead($config, "donate", "txtDonateBarbarians", "barbarians|barb|any"), "|", @CRLF)
		$sTxtBlacklistBarbarians = StringReplace(IniRead($config, "donate", "txtBlacklistBarbarians", "no barbarians|no barb|barbarians no|barb no"), "|", @CRLF)
		$aDonBarbarians = StringSplit($sTxtDonateBarbarians, @CRLF, $STR_ENTIRESPLIT)
		$aBlkBarbarians = StringSplit($sTxtBlacklistBarbarians, @CRLF, $STR_ENTIRESPLIT)
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")

		$ichkDonateArchers = IniRead($config, "donate", "chkDonateArchers", "0")
		$ichkDonateAllArchers = IniRead($config, "donate", "chkDonateAllArchers", "0")
		$sTxtDonateArchers = StringReplace(IniRead($config, "donate", "txtDonateArchers", "archers|arch|any"), "|", @CRLF)
		$sTxtBlacklistArchers = StringReplace(IniRead($config, "donate", "txtBlacklistArchers", "no archers|no arch|archers no|arch no"), "|", @CRLF)
		$aDonArchers = StringSplit($sTxtDonateArchers, @CRLF, $STR_ENTIRESPLIT)
		$aBlkArchers = StringSplit($sTxtBlacklistArchers, @CRLF, $STR_ENTIRESPLIT)
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")

		$ichkDonateGiants = IniRead($config, "donate", "chkDonateGiants", "0")
		$ichkDonateAllGiants = IniRead($config, "donate", "chkDonateAllGiants", "0")
		$sTxtDonateGiants = StringReplace(IniRead($config, "donate", "txtDonateGiants", "giants|giant|any"), "|", @CRLF)
		$sTxtBlacklistGiants = StringReplace(IniRead($config, "donate", "txtBlacklistGiants", "no giants|giants no"), "|", @CRLF)
		$aDonGiants = StringSplit($sTxtDonateGiants, @CRLF, $STR_ENTIRESPLIT)
		$aBlkGiants = StringSplit($sTxtBlacklistGiants, @CRLF, $STR_ENTIRESPLIT)
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")

		$ichkDonateGoblins = IniRead($config, "donate", "chkDonateGoblins", "0")
		$ichkDonateAllGoblins = IniRead($config, "donate", "chkDonateAllGoblins", "0")
		$sTxtDonateGoblins = StringReplace(IniRead($config, "donate", "txtDonateGoblins", "goblins|goblin"), "|", @CRLF)
		$sTxtBlacklistGoblins = StringReplace(IniRead($config, "donate", "txtBlacklistGoblins", "no goblins|goblins no"), "|", @CRLF)
		$aDonGoblins = StringSplit($sTxtDonateGoblins, @CRLF, $STR_ENTIRESPLIT)
		$aBlkGoblins = StringSplit($sTxtBlacklistGoblins, @CRLF, $STR_ENTIRESPLIT)
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")

		$ichkDonateWallBreakers = IniRead($config, "donate", "chkDonateWallBreakers", "0")
		$ichkDonateAllWallBreakers = IniRead($config, "donate", "chkDonateAllWallBreakers", "0")
		$sTxtDonateWallBreakers = StringReplace(IniRead($config, "donate", "txtDonateWallBreakers", "wall breakers|wb"), "|", @CRLF)
		$sTxtBlacklistWallBreakers = StringReplace(IniRead($config, "donate", "txtBlacklistWallBreakers", "no wallbreakers|wb no"), "|", @CRLF)
		$aDonWallBreakers = StringSplit($sTxtDonateWallBreakers, @CRLF, $STR_ENTIRESPLIT)
		$aBlkWallBreakers = StringSplit($sTxtBlacklistWallBreakers, @CRLF, $STR_ENTIRESPLIT)
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")

		$ichkDonateBalloons = IniRead($config, "donate", "chkDonateBalloons", "0")
		$ichkDonateAllBalloons = IniRead($config, "donate", "chkDonateAllBalloons", "0")
		$sTxtDonateBalloons = StringReplace(IniRead($config, "donate", "txtDonateBalloons", "balloons|balloon"), "|", @CRLF)
		$sTxtBlacklistBalloons = StringReplace(IniRead($config, "donate", "txtBlacklistBalloons", "no balloons|balloons no"), "|", @CRLF)
		$aDonBalloons = StringSplit($sTxtDonateBalloons, @CRLF, $STR_ENTIRESPLIT)
		$aBlkBalloons = StringSplit($sTxtBlacklistBalloons, @CRLF, $STR_ENTIRESPLIT)
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")

		$ichkDonateWizards = IniRead($config, "donate", "chkDonateWizards", "0")
		$ichkDonateAllWizards = IniRead($config, "donate", "chkDonateAllWizards", "0")
		$sTxtDonateWizards = StringReplace(IniRead($config, "donate", "txtDonateWizards", "wizards|wizard"), "|", @CRLF)
		$sTxtBlacklistWizards = StringReplace(IniRead($config, "donate", "txtBlacklistWizards", "no wizards|wizards no"), "|", @CRLF)
		$aDonWizards = StringSplit($sTxtDonateWizards, @CRLF, $STR_ENTIRESPLIT)
		$aBlkWizards = StringSplit($sTxtBlacklistWizards, @CRLF, $STR_ENTIRESPLIT)
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")

		$ichkDonateHealers = IniRead($config, "donate", "chkDonateHealers", "0")
		$ichkDonateAllHealers = IniRead($config, "donate", "chkDonateAllHealers", "0")
		$sTxtDonateHealers = StringReplace(IniRead($config, "donate", "txtDonateHealers", "healer"), "|", @CRLF)
		$sTxtBlacklistHealers = StringReplace(IniRead($config, "donate", "txtBlacklistHealers", "no healer|healer no"), "|", @CRLF)
		$aDonHealers = StringSplit($sTxtDonateHealers, @CRLF, $STR_ENTIRESPLIT)
		$aBlkHealers = StringSplit($sTxtBlacklistHealers, @CRLF, $STR_ENTIRESPLIT)
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")

		$ichkDonateDragons = IniRead($config, "donate", "chkDonateDragons", "0")
		$ichkDonateAllDragons = IniRead($config, "donate", "chkDonateAllDragons", "0")
		$sTxtDonateDragons = StringReplace(IniRead($config, "donate", "txtDonateDragons", "dragon"), "|", @CRLF)
		$sTxtBlacklistDragons = StringReplace(IniRead($config, "donate", "txtBlacklistDragons", "no dragon|dragon no"), "|", @CRLF)
		$aDonDragons = StringSplit($sTxtDonateDragons, @CRLF, $STR_ENTIRESPLIT)
		$aBlkDragons = StringSplit($sTxtBlacklistDragons, @CRLF, $STR_ENTIRESPLIT)
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")

		$ichkDonatePekkas = IniRead($config, "donate", "chkDonatePekkas", "0")
		$ichkDonateAllPekkas = IniRead($config, "donate", "chkDonateAllPekkas", "0")
		$sTxtDonatePekkas = StringReplace(IniRead($config, "donate", "txtDonatePekkas", "pekka"), "|", @CRLF)
		$sTxtBlacklistPekkas = StringReplace(IniRead($config, "donate", "txtBlacklistPekkas", "no pekka|pekka no"), "|", @CRLF)
		$aDonPekkas = StringSplit($sTxtDonatePekkas, @CRLF, $STR_ENTIRESPLIT)
		$aBlkPekkas = StringSplit($sTxtBlacklistPekkas, @CRLF, $STR_ENTIRESPLIT)
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")

		$ichkDonateMinions = IniRead($config, "donate", "chkDonateMinions", "0")
		$ichkDonateAllMinions = IniRead($config, "donate", "chkDonateAllMinions", "0")
		$sTxtDonateMinions = StringReplace(IniRead($config, "donate", "txtDonateMinions", "minions|minion"), "|", @CRLF)
		$sTxtBlacklistMinions = StringReplace(IniRead($config, "donate", "txtBlacklistMinions", "no minions|minions no"), "|", @CRLF)
		$aDonMinions = StringSplit($sTxtDonateMinions, @CRLF, $STR_ENTIRESPLIT)
		$aBlkMinions = StringSplit($sTxtBlacklistMinions, @CRLF, $STR_ENTIRESPLIT)
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")

		$ichkDonateHogRiders = IniRead($config, "donate", "chkDonateHogRiders", "0")
		$ichkDonateAllHogRiders = IniRead($config, "donate", "chkDonateAllHogRiders", "0")
		$sTxtDonateHogRiders = StringReplace(IniRead($config, "donate", "txtDonateHogRiders", "hogriders|hogs|hog"), "|", @CRLF)
		$sTxtBlacklistHogRiders = StringReplace(IniRead($config, "donate", "txtBlacklistHogRiders", "no hogriders|hogriders no|no hogs|hogs no"), "|", @CRLF)
		$aDonHogRiders = StringSplit($sTxtDonateHogRiders, @CRLF, $STR_ENTIRESPLIT)
		$aBlkHogRiders = StringSplit($sTxtBlacklistHogRiders, @CRLF, $STR_ENTIRESPLIT)
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")

		$ichkDonateValkyries = IniRead($config, "donate", "chkDonateValkyries", "0")
		$ichkDonateAllValkyries = IniRead($config, "donate", "chkDonateAllValkyries", "0")
		$sTxtDonateValkyries = StringReplace(IniRead($config, "donate", "txtDonateValkyries", "valkyries|valkyrie"), "|", @CRLF)
		$sTxtBlacklistValkyries = StringReplace(IniRead($config, "donate", "txtBlacklistValkyries", "no valkyries|valkyries no"), "|", @CRLF)
		$aDonValkyries = StringSplit($sTxtDonateValkyries, @CRLF, $STR_ENTIRESPLIT)
		$aBlkValkyries = StringSplit($sTxtBlacklistValkyries, @CRLF, $STR_ENTIRESPLIT)
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")

		$ichkDonateGolems = IniRead($config, "donate", "chkDonateGolems", "0")
		$ichkDonateAllGolems = IniRead($config, "donate", "chkDonateAllGolems", "0")
		$sTxtDonateGolems = StringReplace(IniRead($config, "donate", "txtDonateGolems", "golem"), "|", @CRLF)
		$sTxtBlacklistGolems = StringReplace(IniRead($config, "donate", "txtBlacklistGolems", "no golem|golem no"), "|", @CRLF)
		$aDonGolems = StringSplit($sTxtDonateGolems, @CRLF, $STR_ENTIRESPLIT)
		$aBlkGolems = StringSplit($sTxtBlacklistGolems, @CRLF, $STR_ENTIRESPLIT)
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")

		$ichkDonateWitches = IniRead($config, "donate", "chkDonateWitches", "0")
		$ichkDonateAllWitches = IniRead($config, "donate", "chkDonateAllWitches", "0")
		$sTxtDonateWitches = StringReplace(IniRead($config, "donate", "txtDonateWitches", "witches|witch"), "|", @CRLF)
		$sTxtBlacklistWitches = StringReplace(IniRead($config, "donate", "txtBlacklistWitches", "no witches|witches no"), "|", @CRLF)
		$aDonWitches = StringSplit($sTxtDonateWitches, @CRLF, $STR_ENTIRESPLIT)
		$aBlkWitches = StringSplit($sTxtBlacklistWitches, @CRLF, $STR_ENTIRESPLIT)
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")

		$ichkDonateLavaHounds = IniRead($config, "donate", "chkDonateLavaHounds", "0")
		$ichkDonateAllLavaHounds = IniRead($config, "donate", "chkDonateAllLavaHounds", "0")
		$sTxtDonateLavaHounds = StringReplace(IniRead($config, "donate", "txtDonateLavaHounds", "lavahounds|hound|lava"), "|", @CRLF)
		$sTxtBlacklistLavaHounds = StringReplace(IniRead($config, "donate", "txtBlacklistLavaHounds", "no lavahound|hound no"), "|", @CRLF)
		$aDonLavaHounds = StringSplit($sTxtDonateLavaHounds, @CRLF, $STR_ENTIRESPLIT)
		$aBlkLavaHounds = StringSplit($sTxtBlacklistLavaHounds, @CRLF, $STR_ENTIRESPLIT)
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")

		$ichkDonatePoisonSpells = IniRead($config, "donate", "chkDonatePoisonSpells", "0")
		$ichkDonateAllPoisonSpells = IniRead($config, "donate", "chkDonateAllPoisonSpells", "0")
		$sTxtDonatePoisonSpells = StringReplace(IniRead($config, "donate", "txtDonatePoisonSpells", "poison"), "|", @CRLF)
		$sTxtBlacklistPoisonSpells = StringReplace(IniRead($config, "donate", "txtBlacklistPoisonSpells", "no poison|poison no"), "|", @CRLF)
		$aDonPoisonSpells = StringSplit($sTxtDonatePoisonSpells, @CRLF, $STR_ENTIRESPLIT)
		$aBlkPoisonSpells = StringSplit($sTxtBlacklistPoisonSpells, @CRLF, $STR_ENTIRESPLIT)
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")

		$ichkDonateEarthQuakeSpells = IniRead($config, "donate", "chkDonateEarthQuakeSpells", "0")
		$ichkDonateAllEarthQuakeSpells = IniRead($config, "donate", "chkDonateAllEarthQuakeSpells", "0")
		$sTxtDonateEarthQuakeSpells = StringReplace(IniRead($config, "donate", "txtDonateEarthQuakeSpells", "earthquake|quake"), "|", @CRLF)
		$sTxtBlacklistEarthQuakeSpells = StringReplace(IniRead($config, "donate", "txtBlacklistEarthQuakeSpells", "no earthquake|quake no"), "|", @CRLF)
		$aDonEarthQuakeSpells = StringSplit($sTxtDonateEarthQuakeSpells, @CRLF, $STR_ENTIRESPLIT)
		$aBlkEarthQuakeSpells = StringSplit($sTxtBlacklistEarthQuakeSpells, @CRLF, $STR_ENTIRESPLIT)
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")

		$ichkDonateHasteSpells = IniRead($config, "donate", "chkDonateHasteSpells", "0")
		$ichkDonateAllHasteSpells = IniRead($config, "donate", "chkDonateAllHasteSpells", "0")
		$sTxtDonateHasteSpells = StringReplace(IniRead($config, "donate", "txtDonateHasteSpells", "haste"), "|", @CRLF)
		$sTxtBlacklistHasteSpells = StringReplace(IniRead($config, "donate", "txtBlacklistHasteSpells", "no haste|haste no"), "|", @CRLF)
		$aDonHasteSpells = StringSplit($sTxtDonateHasteSpells, @CRLF, $STR_ENTIRESPLIT)
		$aBlkHasteSpells = StringSplit($sTxtBlacklistHasteSpells, @CRLF, $STR_ENTIRESPLIT)
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")

		;;; Custom Combination Donate by ChiefM3, edit by Hervidero
		$ichkDonateCustom = IniRead($config, "donate", "chkDonateCustom", "0")
		$ichkDonateAllCustom = IniRead($config, "donate", "chkDonateAllCustom", "0")
		$sTxtDonateCustom = StringReplace(IniRead($config, "donate", "txtDonateCustom", "any|need"), "|", @CRLF)
		$sTxtBlacklistCustom = StringReplace(IniRead($config, "donate", "txtBlacklistCustom", "only|just"), "|", @CRLF)
		$aDonCustom = StringSplit($sTxtDonateCustom, @CRLF, $STR_ENTIRESPLIT)
		$aBlkCustom = StringSplit($sTxtBlacklistCustom, @CRLF, $STR_ENTIRESPLIT)
		$varDonateCustom[0][0] = IniRead($config, "donate", "cmbDonateCustom1", "6")
		$varDonateCustom[1][0] = IniRead($config, "donate", "cmbDonateCustom2", "1")
		$varDonateCustom[2][0] = IniRead($config, "donate", "cmbDonateCustom3", "0")
		$varDonateCustom[0][1] = IniRead($config, "donate", "txtDonateCustom1", "2")
		$varDonateCustom[1][1] = IniRead($config, "donate", "txtDonateCustom2", "3")
		$varDonateCustom[2][1] = IniRead($config, "donate", "txtDonateCustom3", "1")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")

		$sTxtBlacklist = StringReplace(IniRead($config, "donate", "txtBlacklist", "clan war|war|cw"), "|", @CRLF)
		$aBlackList = StringSplit($sTxtBlacklist, @CRLF, $STR_ENTIRESPLIT)
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")

		; Extra Alphabets , Cyrillic.
		$ichkExtraAlphabets = IniRead($config, "donate", "chkExtraAlphabets", "0")

		;InireadS(xxxx,$config, "attack", "xxxx", "0")

		InireadS($chkLvl6Enabled,$config, "collectors", "lvl6Enabled", "1")
		InireadS($chkLvl7Enabled,$config, "collectors", "lvl7Enabled", "1")
		InireadS($chkLvl8Enabled,$config, "collectors", "lvl8Enabled", "1")
		InireadS($chkLvl9Enabled,$config, "collectors", "lvl9Enabled", "1")
		InireadS($chkLvl10Enabled,$config, "collectors", "lvl10Enabled", "1")
		InireadS($chkLvl11Enabled,$config, "collectors", "lvl11Enabled", "1")
		InireadS($chkLvl12Enabled,$config, "collectors", "lvl12Enabled", "1")
		InireadS($cmbLvl6Fill,$config, "collectors", "lvl6fill", "2")
		InireadS($cmbLvl7Fill,$config, "collectors", "lvl7fill", "2")
		InireadS($cmbLvl8Fill,$config, "collectors", "lvl8fill", "2")
		InireadS($cmbLvl9Fill,$config, "collectors", "lvl9fill", "1")
		InireadS($cmbLvl10Fill,$config, "collectors", "lvl10fill", "0")
		InireadS($cmbLvl11Fill,$config, "collectors", "lvl11fill", "0")
		InireadS($cmbLvl12Fill,$config, "collectors", "lvl12fill", "0")
		InireadS($toleranceOffset,$config, "collectors", "tolerance", "0")

		; Android Configuration
		$AndroidGamePackage = IniRead($config, "android", "game.package", $AndroidGamePackage)
		$AndroidGameClass = IniRead($config, "android", "game.class", $AndroidGameClass)
		$AndroidCheckTimeLagEnabled = IniRead($config, "android", "check.time.lag.enabled", ($AndroidCheckTimeLagEnabled ? "1" : "0")) = "1"
		$AndroidAdbScreencapTimeoutMin = Int(IniRead($config, "android", "adb.screencap.timeout.min", $AndroidAdbScreencapTimeoutMin))
		$AndroidAdbScreencapTimeoutMax = Int(IniRead($config, "android", "adb.screencap.timeout.max", $AndroidAdbScreencapTimeoutMax))
		$AndroidAdbScreencapTimeoutDynamic = Int(IniRead($config, "android", "adb.screencap.timeout.dynamic", $AndroidAdbScreencapTimeoutDynamic))
		$AndroidAdbInputEnabled = IniRead($config, "android", "adb.input.enabled", ($AndroidAdbInputEnabled ? "1" : "0")) = "1"
		$AndroidAdbClickEnabled = IniRead($config, "android", "adb.click.enabled", ($AndroidAdbClickEnabled ? "1" : "0")) = "1"
		$AndroidAdbClickGroup = Int(IniRead($config, "android", "adb.click.group", $AndroidAdbClickGroup))
		$AndroidAdbClicksEnabled = IniRead($config, "android", "adb.clicks.enabled", ($AndroidAdbClicksEnabled ? "1" : "0")) = "1"
		$AndroidAdbClicksTroopDeploySize = Int(IniRead($config, "android", "adb.clicks.troop.deploy.size", $AndroidAdbClicksTroopDeploySize))
		$NoFocusTampering = IniRead($config, "android", "no.focus.tampering", ($NoFocusTampering ? "1" : "0")) = "1"

	Else
		Return False
	EndIf
EndFunc   ;==>readConfig


