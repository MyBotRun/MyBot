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


Func readConfig() ;Reads config and sets it to the variables
	If FileExists($building) Then
		$TownHallPos[0] = IniRead($building, "other", "xTownHall", "-1")
		$TownHallPos[1] = IniRead($building, "other", "yTownHall", "-1")
		$iTownHallLevel = IniRead($building, "other", "LevelTownHall", "0")

		$aCCPos[0] = IniRead($building, "other", "xCCPos", "0")
		$aCCPos[1] = IniRead($building, "other", "yCCPos", "0")

		$barrackPos[0][0] = IniRead($building, "other", "xBarrack1", "0")
		$barrackPos[0][1] = IniRead($building, "other", "yBarrack1", "0")

		$barrackPos[1][0] = IniRead($building, "other", "xBarrack2", "0")
		$barrackPos[1][1] = IniRead($building, "other", "yBarrack2", "0")

		$barrackPos[2][0] = IniRead($building, "other", "xBarrack3", "0")
		$barrackPos[2][1] = IniRead($building, "other", "yBarrack3", "0")

		$barrackPos[3][0] = IniRead($building, "other", "xBarrack4", "0")
		$barrackPos[3][1] = IniRead($building, "other", "yBarrack4", "0")

		$ArmyPos[0] = IniRead($building, "other", "xArmy", "0")
		$ArmyPos[1] = IniRead($building, "other", "yArmy", "0")
		$TotalCamp = Number(IniRead($building, "other", "totalcamp", "0"))

		$SFPos[0] = IniRead($building, "other", "xspellfactory", "-1")
		$SFPos[1] = IniRead($building, "other", "yspellfactory", "-1")

		$DSFPos[0] = IniRead($building, "other", "xDspellfactory", "-1")
		$DSFPos[1] = IniRead($building, "other", "yDspellfactory", "-1")

		$KingAltarPos[0] = IniRead($building, "other", "xKingAltarPos", "-1")
		$KingAltarPos[1] = IniRead($building, "other", "yKingAltarPos", "-1")

		$QueenAltarPos[0] = IniRead($building, "other", "xQueenAltarPos", "-1")
		$QueenAltarPos[1] = IniRead($building, "other", "yQueenAltarPos", "-1")

		$WardenAltarPos[0] = IniRead($building, "other", "xWardenAltarPos", "-1")
		$WardenAltarPos[1] = IniRead($building, "other", "yWardenAltarPos", "-1")

		;$barrackNum = IniRead($building, "other", "barrackNum", "0")
		;$barrackDarkNum = IniRead($building, "other", "barrackDarkNum", "0")

		$listResourceLocation = IniRead($building, "other", "listResource", "")

		For $iz = 0 to UBound($aUpgrades, 1) - 1 ; SReads Upgrade building data
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
		$itxtUpgrMinGold = Number(IniRead($building, "upgrade", "minupgrgold", "100000"))
		$itxtUpgrMinElixir = Number(IniRead($building, "upgrade", "minupgrelixir", "100000"))
		$itxtUpgrMinDark = Number(IniRead($building, "upgrade", "minupgrdark", "2000"))
	EndIf

	If FileExists($config) Then

		;General Settings--------------------------------------------------------------------------
		;$icmbProfile = IniRead($config, "general", "cmbProfile", "01") ; Not needed with new profile system
		$frmBotPosX = IniRead($config, "general", "frmBotPosX", "900")
		$frmBotPosY = IniRead($config, "general", "frmBotPosY", "20")
		;$iVillageName = IniRead($config, "general", "villageName", "") ; Not needed with new profile system

		$iCmbLog = IniRead($config, "general", "logstyle", "0")
		$iDividerY = Number(IniRead($config, "general", "LogDividerY", "385"))

		$ichkAutoStart = IniRead($config, "general", "AutoStart", "0")
		$ichkAutoStartDelay = IniRead($config, "general", "AutoStartDelay", "10")
		$restarted = IniRead($config, "general", "Restarted", "0")
		$ichkBackground = IniRead($config, "general", "Background", "0")
		$ichkBotStop = IniRead($config, "general", "BotStop", "0")
		$icmbBotCommand = IniRead($config, "general", "Command", "0")
		$icmbBotCond = IniRead($config, "general", "Cond", "0")
		$icmbHoursStop = IniRead($config, "general", "Hour", "0")

		$iDisposeWindows = IniRead($config, "general", "DisposeWindows", "0")
		$icmbDisposeWindowsPos = IniRead($config, "general", "DisposeWindowsPos", "SNAP-TR")
		$iUseOldOCR = IniRead($config, "general", "UseOldOCR", "0")

		;Search Settings------------------------------------------------------------------------
		$iCmbSearchMode = IniRead($config, "search", "SearchMode", "0")
		$AlertSearch = IniRead($config, "search", "AlertSearch", "0")

		$iChkEnableAfter[$DB] = IniRead($config, "search", "DBEnableAfter", "0")
		$iCmbMeetGE[$DB] = IniRead($config, "search", "DBMeetGE", "1")
		$iChkMeetDE[$DB] = IniRead($config, "search", "DBMeetDE", "0")
		$iChkMeetTrophy[$DB] = IniRead($config, "search", "DBMeetTrophy", "0")
		$iChkMeetTH[$DB] = IniRead($config, "search", "DBMeetTH", "0")
		$iChkMeetTHO[$DB] = IniRead($config, "search", "DBMeetTHO", "0")
		$iChkWeakBase[$DB] = IniRead($config, "search", "DBWeakBase", "0")
		$iChkMeetOne[$DB] = IniRead($config, "search", "DBMeetOne", "0")

		$iEnableAfterCount[$DB] = IniRead($config, "search", "DBEnableAfterCount", "150")
		$iMinGold[$DB] = IniRead($config, "search", "DBsearchGold", "80000")
		$iMinElixir[$DB] = IniRead($config, "search", "DBsearchElixir", "80000")
		$iMinGoldPlusElixir[$DB] = IniRead($config, "search", "DBsearchGoldPlusElixir", "160000")
		$iMinDark[$DB] = IniRead($config, "search", "DBsearchDark", "0")
		$iMinTrophy[$DB] = IniRead($config, "search", "DBsearchTrophy", "0")
		$iCmbTH[$DB] = IniRead($config, "search", "DBTHLevel", "0")
		$iCmbWeakMortar[$DB] = IniRead($config, "search", "DBWeakMortar", "5")
		$iCmbWeakWizTower[$DB] = IniRead($config, "search", "DBWeakWizTower", "4")

		$iChkEnableAfter[$LB] = IniRead($config, "search", "ABEnableAfter", "0")
		$iCmbMeetGE[$LB] = IniRead($config, "search", "ABMeetGE", "2")
		$iChkMeetDE[$LB] = IniRead($config, "search", "ABMeetDE", "0")
		$iChkMeetTrophy[$LB] = IniRead($config, "search", "ABMeetTrophy", "0")
		$iChkMeetTH[$LB] = IniRead($config, "search", "ABMeetTH", "0")
		$iChkMeetTHO[$LB] = IniRead($config, "search", "ABMeetTHO", "0")
		$iChkWeakBase[$LB] = IniRead($config, "search", "ABWeakBase", "0")
		$iChkMeetOne[$LB] = IniRead($config, "search", "ABMeetOne", "0")

		$iEnableAfterCount[$LB] = IniRead($config, "search", "ABEnableAfterCount", "150")
		$iMinGold[$LB] = IniRead($config, "search", "ABsearchGold", "80000")
		$iMinElixir[$LB] = IniRead($config, "search", "ABsearchElixir", "80000")
		$iMinGoldPlusElixir[$LB] = IniRead($config, "search", "ABsearchGoldPlusElixir", "160000")
		$iMinDark[$LB] = IniRead($config, "search", "ABsearchDark", "0")
		$iMinTrophy[$LB] = IniRead($config, "search", "ABsearchTrophy", "0")
		$iCmbTH[$LB] = IniRead($config, "search", "ABTHLevel", "0")
		$iCmbWeakMortar[$LB] = IniRead($config, "search", "ABWeakMortar", "5")
		$iCmbWeakWizTower[$LB] = IniRead($config, "search", "ABWeakWizTower", "4")

		$iChkSearchReduction = IniRead($config, "search", "reduction", "1")
		$ReduceCount = IniRead($config, "search", "reduceCount", "20")
		$ReduceGold = IniRead($config, "search", "reduceGold", "2000")
		$ReduceElixir = IniRead($config, "search", "reduceElixir", "2000")
		$ReduceGoldPlusElixir = IniRead($config, "search", "reduceGoldPlusElixir", "4000")
		$ReduceDark = IniRead($config, "search", "reduceDark", "100")
		$ReduceTrophy = IniRead($config, "search", "reduceTrophy", "2")

		$iChkRestartSearchLimit = IniRead($config, "search", "ChkRestartSearchLimit", "0")
		$iRestartSearchlimit = IniRead($config, "search", "RestartSearchLimit", "15")

		;Attack Basics Settings-------------------------------------------------------------------------
		$iChkDeploySettings[$DB] = IniRead($config, "attack", "DBDeploy", "3")
		$iCmbUnitDelay[$DB] = IniRead($config, "attack", "DBUnitD", "5")
		$iCmbWaveDelay[$DB] = IniRead($config, "attack", "DBWaveD", "5")
		$iChkRandomspeedatk[$DB] = IniRead($config, "attack", "DBRandomSpeedAtk", "0")

		$iChkDeploySettings[$LB] = IniRead($config, "attack", "ABDeploy", "0")
		$iCmbUnitDelay[$LB] = IniRead($config, "attack", "ABUnitD", "5")
		$iCmbWaveDelay[$LB] = IniRead($config, "attack", "ABWaveD", "5")
		$iChkRandomspeedatk[$LB] = IniRead($config, "attack", "ABRandomSpeedAtk", "0")

		$iCmbSelectTroop[$DB] = IniRead($config, "attack", "DBSelectTroop", "0")
		$iCmbSelectTroop[$LB] = IniRead($config, "attack", "ABSelectTroop", "0")

		$iChkRedArea[$DB] = IniRead($config, "attack", "DBSmartAttackRedArea", "1")
		$iCmbSmartDeploy[$DB] = IniRead($config, "attack", "DBSmartAttackDeploy", "0")

		$iChkSmartAttack[$DB][0] = IniRead($config, "attack", "DBSmartAttackGoldMine", "0")
		$iChkSmartAttack[$DB][1] = IniRead($config, "attack", "DBSmartAttackElixirCollector", "0")
		$iChkSmartAttack[$DB][2] = IniRead($config, "attack", "DBSmartAttackDarkElixirDrill", "0")

		$iChkRedArea[$LB] = IniRead($config, "attack", "ABSmartAttackRedArea", "1")
		$iCmbSmartDeploy[$LB] = IniRead($config, "attack", "ABSmartAttackDeploy", "0")

		$iChkSmartAttack[$LB][0] = IniRead($config, "attack", "ABSmartAttackGoldMine", "0")
		$iChkSmartAttack[$LB][1] = IniRead($config, "attack", "ABSmartAttackElixirCollector", "0")
		$iChkSmartAttack[$LB][2] = IniRead($config, "attack", "ABSmartAttackDarkElixirDrill", "0")

		$iHeroAttack[$DB] = BitOR(Int(IniRead($config, "attack", "DBKingAtk", $HERO_NOHERO)), _
										Int(IniRead($config, "attack", "DBQueenAtk", $HERO_NOHERO)), _
										Int(IniRead($config, "attack", "DBWardenAtk", $HERO_NOHERO)))
		$iHeroAttack[$LB] = BitOR(Int(IniRead($config, "attack", "ABKingAtk", $HERO_NOHERO)), _
										Int(IniRead($config, "attack", "ABQueenAtk", $HERO_NOHERO)), _
										Int(IniRead($config, "attack", "ABWardenAtk", $HERO_NOHERO)))

		$iHeroWait[$DB] = BitOR(Int(IniRead($config, "attack", "DBKingWait", $HERO_NOHERO)), _
										Int(IniRead($config, "attack", "DBQueenWait", $HERO_NOHERO)), _
										Int(IniRead($config, "attack", "DBWardenWait", $HERO_NOHERO)))
		$iHeroWait[$LB] = BitOR(Int(IniRead($config, "attack", "ABKingWait", $HERO_NOHERO)), _
										Int(IniRead($config, "attack", "ABQueenWait", $HERO_NOHERO)), _
										Int(IniRead($config, "attack", "ABWardenWait", $HERO_NOHERO)))

		$iDropCC[$DB] = IniRead($config, "attack", "DBDropCC", "0")
		$iDropCC[$LB] = IniRead($config, "attack", "ABDropCC", "0")

		$iChkUseCCBalanced = IniRead($config, "attack", "BalanceCC", "0")
		$iCmbCCDonated = IniRead($config, "attack", "BalanceCCDonated", "1")
		$iCmbCCReceived = IniRead($config, "attack", "BalanceCCReceived", "1")

		$iActivateKQCondition = IniRead($config, "attack", "ActivateKQ", "Auto")
		$delayActivateKQ = (1000 * IniRead($config, "attack", "delayActivateKQ", "9"))
		$iActivateWardenCondition = IniRead($config, "attack", "ActivateWarden", "1")
		$delayActivateW = (1000 * IniRead($config, "attack", "delayActivateW", "9"))

		$TakeLootSnapShot = IniRead($config, "attack", "TakeLootSnapShot", "0")
		$ScreenshotLootInfo = IniRead($config, "attack", "ScreenshotLootInfo", "0")

		;Attack Adv. Settings--------------------------------------------------------------------------
		$ichkAttackNow = IniRead($config, "advanced", "AttackNow", "0")
		$iAttackNowDelay = IniRead($config, "advanced", "attacknowdelay", "3")

		$chkATH = IniRead($config, "advanced", "townhall", "0")

		$OptBullyMode = IniRead($config, "advanced", "BullyMode", "0")
		$ATBullyMode = IniRead($config, "advanced", "ATBullyMode", "0")
		$YourTH = IniRead($config, "advanced", "YourTH", "0")
		$iTHBullyAttackMode = IniRead($config, "advanced", "THBullyAttackMode", "0")

		$OptTrophyMode = IniRead($config, "advanced", "TrophyMode", "0")
		$THaddtiles = IniRead($config, "advanced", "THaddTiles", "2")
		;$icmbAttackTHType = IniRead($config, "advanced", "AttackTHType", "3")
		$scmbAttackTHType = IniRead($config, "advanced", "AttackTHType", "bam")

		$iChkEnableAfter[$TS] = IniRead($config, "search", "TSEnableAfter", "0")
		$iEnableAfterCount[$TS] = IniRead($config, "search", "TSEnableAfterCount", "50")
		$iMinGold[$TS] = IniRead($config, "search", "TSsearchGold", "80000")
		$iMinElixir[$TS] = IniRead($config, "search", "TSsearchElixir", "80000")
		$iMinGoldPlusElixir[$TS] = IniRead($config, "search", "TSsearchGoldPlusElixir", "160000")
		$iMinDark[$TS] = IniRead($config, "search", "TSsearchDark", "600")
		$iCmbMeetGE[$TS] = IniRead($config, "search", "TSMeetGE", "1")
		$iChkMeetDE[$TS] = IniRead($config, "search", "TSMeetDE", "0")

		$PushToken = IniRead($config, "advanced", "AccountToken", "")

		$iAlertPBVillage = IniRead($config, "advanced", "AlertPBVillage", "0")
		$iLastAttack = IniRead($config, "advanced", "AlertPBLastAttack", "0")

		$ichkUseKingTH = IniRead($config, "advanced", "UseKingTH", "0")
		$ichkUseQueenTH = IniRead($config, "advanced", "UseQueenTH", "0")
		$ichkUseClastleTH = IniRead($config, "advanced", "UseCastleTH", "0")
		$ichkUseLSpellsTH = IniRead($config, "advanced", "UseLspellTH", "0")
		$ichkUseRSpellsTH = IniRead($config, "advanced", "UseRspellTH", "0")
		$ichkUseHSpellsTH = IniRead($config, "advanced", "UseHspellTH", "0")

		;$iUnbreakableMode = IniRead($config, "advanced", "chkUnbreakable", "0")
		$iUnbreakableWait = IniRead($config, "advanced", "UnbreakableWait", "5")
		$iUnBrkMinGold = IniRead($config, "advanced", "minUnBrkgold", "50000")
		$iUnBrkMinElixir = IniRead($config, "advanced", "minUnBrkelixir", "50000")
		$iUnBrkMinDark = IniRead($config, "advanced", "minUnBrkdark", "5000")
		$iUnBrkMaxGold = IniRead($config, "advanced", "maxUnBrkgold", "600000")
		$iUnBrkMaxElixir = IniRead($config, "advanced", "maxUnBrkelixir", "600000")
		$iUnBrkMaxDark = IniRead($config, "advanced", "maxUnBrkdark", "10000")

		;atk their king
		;atk their queen

		;End Battle Settings------------------------------------------------------------------------
		$sTimeStopAtk = IniRead($config, "endbattle", "txtTimeStopAtk", "20")
		$iChkTimeStopAtk = IniRead($config, "endbattle", "chkTimeStopAtk", "1")

		$sTimeStopAtk2 = IniRead($config, "endbattle", "txtTimeStopAtk2", "7")
		$iChkTimeStopAtk2 = IniRead($config, "endbattle", "chkTimeStopAtk2", "0")

		$stxtMinGoldStopAtk2 = IniRead($config, "endbattle", "txtMinGoldStopAtk2", "1000")
		$stxtMinElixirStopAtk2 = IniRead($config, "endbattle", "txtMinElixirStopAtk2", "1000")
		$stxtMinDarkElixirStopAtk2 = IniRead($config, "endbattle", "txtMinDarkElixirStopAtk2", "50")

		$ichkEndOneStar = IniRead($config, "endbattle", "chkEndOneStar", "0")
		$ichkEndTwoStars = IniRead($config, "endbattle", "chkEndTwoStars", "0")
		$ichkEndNoResources = IniRead($config, "endbattle", "chkEndNoResources", "0")


		$DESideEB = IniRead($config, "endbattle", "chkDESideEB", "0")
		$DELowEndMin = IniRead($config, "endbattle", "txtDELowEndMin", "25")
		$DisableOtherEBO = IniRead($config, "endbattle", "chkDisableOtherEBO", "0")
		$DEEndOneStar = IniRead($config, "endbattle", "chkDEEndOneStar", "0")
		$DEEndBk = IniRead($config, "endbattle", "chkDEEndBk", "0")
		$DEEndAq = IniRead($config, "endbattle", "chkDEEndAq", "0")


		;Donate Settings-------------------------------------------------------------------------
		$iChkRequest = IniRead($config, "donate", "chkRequest", "0")
		$sTxtRequest = IniRead($config, "donate", "txtRequest", "")

		$ichkDonateBarbarians = IniRead($config, "donate", "chkDonateBarbarians", "0")
		$ichkDonateAllBarbarians = IniRead($config, "donate", "chkDonateAllBarbarians", "0")
		$sTxtDonateBarbarians = StringReplace(IniRead($config, "donate", "txtDonateBarbarians", "barbarians|barb|any"), "|", @CRLF)
		$sTxtBlacklistBarbarians = StringReplace(IniRead($config, "donate", "txtBlacklistBarbarians", "no barbarians|no barb|barbarians no|barb no"), "|", @CRLF)
		$aDonBarbarians = StringSplit($sTxtDonateBarbarians, @CRLF, $STR_ENTIRESPLIT)
		$aBlkBarbarians = StringSplit($sTxtBlacklistBarbarians, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateArchers = IniRead($config, "donate", "chkDonateArchers", "0")
		$ichkDonateAllArchers = IniRead($config, "donate", "chkDonateAllArchers", "0")
		$sTxtDonateArchers = StringReplace(IniRead($config, "donate", "txtDonateArchers", "archers|arch|any"), "|", @CRLF)
		$sTxtBlacklistArchers = StringReplace(IniRead($config, "donate", "txtBlacklistArchers", "no archers|no arch|archers no|arch no"), "|", @CRLF)
		$aDonArchers = StringSplit($sTxtDonateArchers, @CRLF, $STR_ENTIRESPLIT)
		$aBlkArchers = StringSplit($sTxtBlacklistArchers, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateGiants = IniRead($config, "donate", "chkDonateGiants", "0")
		$ichkDonateAllGiants = IniRead($config, "donate", "chkDonateAllGiants", "0")
		$sTxtDonateGiants = StringReplace(IniRead($config, "donate", "txtDonateGiants", "giants|giant|any"), "|", @CRLF)
		$sTxtBlacklistGiants = StringReplace(IniRead($config, "donate", "txtBlacklistGiants", "no giants|giants no"), "|", @CRLF)
		$aDonGiants = StringSplit($sTxtDonateGiants, @CRLF, $STR_ENTIRESPLIT)
		$aBlkGiants = StringSplit($sTxtBlacklistGiants, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateGoblins = IniRead($config, "donate", "chkDonateGoblins", "0")
		$ichkDonateAllGoblins = IniRead($config, "donate", "chkDonateAllGoblins", "0")
		$sTxtDonateGoblins = StringReplace(IniRead($config, "donate", "txtDonateGoblins", "goblins|goblin"), "|", @CRLF)
		$sTxtBlacklistGoblins = StringReplace(IniRead($config, "donate", "txtBlacklistGoblins", "no goblins|goblins no"), "|", @CRLF)
		$aDonGoblins = StringSplit($sTxtDonateGoblins, @CRLF, $STR_ENTIRESPLIT)
		$aBlkGoblins = StringSplit($sTxtBlacklistGoblins, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateWallBreakers = IniRead($config, "donate", "chkDonateWallBreakers", "0")
		$ichkDonateAllWallBreakers = IniRead($config, "donate", "chkDonateAllWallBreakers", "0")
		$sTxtDonateWallBreakers = StringReplace(IniRead($config, "donate", "txtDonateWallBreakers", "wall breakers|wb"), "|", @CRLF)
		$sTxtBlacklistWallBreakers = StringReplace(IniRead($config, "donate", "txtBlacklistWallBreakers", "no wallbreakers|wb no"), "|", @CRLF)
		$aDonWallBreakers = StringSplit($sTxtDonateWallBreakers, @CRLF, $STR_ENTIRESPLIT)
		$aBlkWallBreakers = StringSplit($sTxtBlacklistWallBreakers, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateBalloons = IniRead($config, "donate", "chkDonateBalloons", "0")
		$ichkDonateAllBalloons = IniRead($config, "donate", "chkDonateAllBalloons", "0")
		$sTxtDonateBalloons = StringReplace(IniRead($config, "donate", "txtDonateBalloons", "balloons|balloon"), "|", @CRLF)
		$sTxtBlacklistBalloons = StringReplace(IniRead($config, "donate", "txtBlacklistBalloons", "no balloons|balloons no"), "|", @CRLF)
		$aDonBalloons = StringSplit($sTxtDonateBalloons, @CRLF, $STR_ENTIRESPLIT)
		$aBlkBalloons = StringSplit($sTxtBlacklistBalloons, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateWizards = IniRead($config, "donate", "chkDonateWizards", "0")
		$ichkDonateAllWizards = IniRead($config, "donate", "chkDonateAllWizards", "0")
		$sTxtDonateWizards = StringReplace(IniRead($config, "donate", "txtDonateWizards", "wizards|wizard"), "|", @CRLF)
		$sTxtBlacklistWizards = StringReplace(IniRead($config, "donate", "txtBlacklistWizards", "no wizards|wizards no"), "|", @CRLF)
		$aDonWizards = StringSplit($sTxtDonateWizards, @CRLF, $STR_ENTIRESPLIT)
		$aBlkWizards = StringSplit($sTxtBlacklistWizards, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateHealers = IniRead($config, "donate", "chkDonateHealers", "0")
		$ichkDonateAllHealers = IniRead($config, "donate", "chkDonateAllHealers", "0")
		$sTxtDonateHealers = StringReplace(IniRead($config, "donate", "txtDonateHealers", "healer"), "|", @CRLF)
		$sTxtBlacklistHealers = StringReplace(IniRead($config, "donate", "txtBlacklistHealers", "no healer|healer no"), "|", @CRLF)
		$aDonHealers = StringSplit($sTxtDonateHealers, @CRLF, $STR_ENTIRESPLIT)
		$aBlkHealers = StringSplit($sTxtBlacklistHealers, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateDragons = IniRead($config, "donate", "chkDonateDragons", "0")
		$ichkDonateAllDragons = IniRead($config, "donate", "chkDonateAllDragons", "0")
		$sTxtDonateDragons = StringReplace(IniRead($config, "donate", "txtDonateDragons", "dragon"), "|", @CRLF)
		$sTxtBlacklistDragons = StringReplace(IniRead($config, "donate", "txtBlacklistDragons", "no dragon|dragon no"), "|", @CRLF)
		$aDonDragons = StringSplit($sTxtDonateDragons, @CRLF, $STR_ENTIRESPLIT)
		$aBlkDragons = StringSplit($sTxtBlacklistDragons, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonatePekkas = IniRead($config, "donate", "chkDonatePekkas", "0")
		$ichkDonateAllPekkas = IniRead($config, "donate", "chkDonateAllPekkas", "0")
		$sTxtDonatePekkas = StringReplace(IniRead($config, "donate", "txtDonatePekkas", "pekka"), "|", @CRLF)
		$sTxtBlacklistPekkas = StringReplace(IniRead($config, "donate", "txtBlacklistPekkas", "no pekka|pekka no"), "|", @CRLF)
		$aDonPekkas = StringSplit($sTxtDonatePekkas, @CRLF, $STR_ENTIRESPLIT)
		$aBlkPekkas = StringSplit($sTxtBlacklistPekkas, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateMinions = IniRead($config, "donate", "chkDonateMinions", "0")
		$ichkDonateAllMinions = IniRead($config, "donate", "chkDonateAllMinions", "0")
		$sTxtDonateMinions = StringReplace(IniRead($config, "donate", "txtDonateMinions", "minions|minion"), "|", @CRLF)
		$sTxtBlacklistMinions = StringReplace(IniRead($config, "donate", "txtBlacklistMinions", "no minions|minions no"), "|", @CRLF)
		$aDonMinions = StringSplit($sTxtDonateMinions, @CRLF, $STR_ENTIRESPLIT)
		$aBlkMinions = StringSplit($sTxtBlacklistMinions, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateHogRiders = IniRead($config, "donate", "chkDonateHogRiders", "0")
		$ichkDonateAllHogRiders = IniRead($config, "donate", "chkDonateAllHogRiders", "0")
		$sTxtDonateHogRiders = StringReplace(IniRead($config, "donate", "txtDonateHogRiders", "hogriders|hogs|hog"), "|", @CRLF)
		$sTxtBlacklistHogRiders = StringReplace(IniRead($config, "donate", "txtBlacklistHogRiders", "no hogriders|hogriders no|no hogs|hogs no"), "|", @CRLF)
		$aDonHogRiders = StringSplit($sTxtDonateHogRiders, @CRLF, $STR_ENTIRESPLIT)
		$aBlkHogRiders = StringSplit($sTxtBlacklistHogRiders, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateValkyries = IniRead($config, "donate", "chkDonateValkyries", "0")
		$ichkDonateAllValkyries = IniRead($config, "donate", "chkDonateAllValkyries", "0")
		$sTxtDonateValkyries = StringReplace(IniRead($config, "donate", "txtDonateValkyries", "valkyries|valkyrie"), "|", @CRLF)
		$sTxtBlacklistValkyries = StringReplace(IniRead($config, "donate", "txtBlacklistValkyries", "no valkyries|valkyries no"), "|", @CRLF)
		$aDonValkyries = StringSplit($sTxtDonateValkyries, @CRLF, $STR_ENTIRESPLIT)
		$aBlkValkyries = StringSplit($sTxtBlacklistValkyries, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateGolems = IniRead($config, "donate", "chkDonateGolems", "0")
		$ichkDonateAllGolems = IniRead($config, "donate", "chkDonateAllGolems", "0")
		$sTxtDonateGolems = StringReplace(IniRead($config, "donate", "txtDonateGolems", "golem"), "|", @CRLF)
		$sTxtBlacklistGolems = StringReplace(IniRead($config, "donate", "txtBlacklistGolems", "no golem|golem no"), "|", @CRLF)
		$aDonGolems = StringSplit($sTxtDonateGolems, @CRLF, $STR_ENTIRESPLIT)
		$aBlkGolems = StringSplit($sTxtBlacklistGolems, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateWitches = IniRead($config, "donate", "chkDonateWitches", "0")
		$ichkDonateAllWitches = IniRead($config, "donate", "chkDonateAllWitches", "0")
		$sTxtDonateWitches = StringReplace(IniRead($config, "donate", "txtDonateWitches", "witches|witch"), "|", @CRLF)
		$sTxtBlacklistWitches = StringReplace(IniRead($config, "donate", "txtBlacklistWitches", "no witches|witches no"), "|", @CRLF)
		$aDonWitches = StringSplit($sTxtDonateWitches, @CRLF, $STR_ENTIRESPLIT)
		$aBlkWitches = StringSplit($sTxtBlacklistWitches, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateLavaHounds = IniRead($config, "donate", "chkDonateLavaHounds", "0")
		$ichkDonateAllLavaHounds = IniRead($config, "donate", "chkDonateAllLavaHounds", "0")
		$sTxtDonateLavaHounds = StringReplace(IniRead($config, "donate", "txtDonateLavaHounds", "lavahounds|hound|lava"), "|", @CRLF)
		$sTxtBlacklistLavaHounds = StringReplace(IniRead($config, "donate", "txtBlacklistLavaHounds", "no lavahound|hound no"), "|", @CRLF)
		$aDonLavaHounds = StringSplit($sTxtDonateLavaHounds, @CRLF, $STR_ENTIRESPLIT)
		$aBlkLavaHounds = StringSplit($sTxtBlacklistLavaHounds, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonatePoisonSpells = IniRead($config, "donate", "chkDonatePoisonSpells", "0")
		$ichkDonateAllPoisonSpells = IniRead($config, "donate", "chkDonateAllPoisonSpells", "0")
		$sTxtDonatePoisonSpells = StringReplace(IniRead($config, "donate", "txtDonatePoisonSpells", "poison"), "|", @CRLF)
		$sTxtBlacklistPoisonSpells = StringReplace(IniRead($config, "donate", "txtBlacklistPoisonSpells", "no poison|poison no"), "|", @CRLF)
		$aDonPoisonSpells = StringSplit($sTxtDonatePoisonSpells, @CRLF, $STR_ENTIRESPLIT)
		$aBlkPoisonSpells = StringSplit($sTxtBlacklistPoisonSpells, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateEarthQuakeSpells = IniRead($config, "donate", "chkDonateEarthQuakeSpells", "0")
		$ichkDonateAllEarthQuakeSpells = IniRead($config, "donate", "chkDonateAllEarthQuakeSpells", "0")
		$sTxtDonateEarthQuakeSpells = StringReplace(IniRead($config, "donate", "txtDonateEarthQuakeSpells", "earthquake|quake"), "|", @CRLF)
		$sTxtBlacklistEarthQuakeSpells = StringReplace(IniRead($config, "donate", "txtBlacklistEarthQuakeSpells", "no earthquake|quake no"), "|", @CRLF)
		$aDonEarthQuakeSpells = StringSplit($sTxtDonateEarthQuakeSpells, @CRLF, $STR_ENTIRESPLIT)
		$aBlkEarthQuakeSpells = StringSplit($sTxtBlacklistEarthQuakeSpells, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateHasteSpells = IniRead($config, "donate", "chkDonateHasteSpells", "0")
		$ichkDonateAllHasteSpells = IniRead($config, "donate", "chkDonateAllHasteSpells", "0")
		$sTxtDonateHasteSpells = StringReplace(IniRead($config, "donate", "txtDonateHasteSpells", "haste"), "|", @CRLF)
		$sTxtBlacklistHasteSpells = StringReplace(IniRead($config, "donate", "txtBlacklistHasteSpells", "no haste|haste no"), "|", @CRLF)
		$aDonHasteSpells = StringSplit($sTxtDonateHasteSpells, @CRLF, $STR_ENTIRESPLIT)
		$aBlkHasteSpells = StringSplit($sTxtBlacklistHasteSpells, @CRLF, $STR_ENTIRESPLIT)

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

		$sTxtBlacklist = StringReplace(IniRead($config, "donate", "txtBlacklist", "clan war|war|cw"), "|", @CRLF)
		$aBlackList = StringSplit($sTxtBlacklist, @CRLF, $STR_ENTIRESPLIT)

		; Extra Alphabets , Cyrillic.
		$ichkExtraAlphabets = IniRead($config, "donate", "chkExtraAlphabets", "0")

		;Troop Settings--------------------------------------------------------------------------
		$iCmbTroopComp = IniRead($config, "troop", "TroopComposition", "0")
		$icmbDarkTroopComp = IniRead($config, "troop", "DarkTroopComposition", "0")
		For $i = 0 To UBound($TroopName) - 1
			Assign($TroopName[$i] & "Comp", IniRead($config, "troop", $TroopName[$i], "0"))
		Next
		For $i = 0 To UBound($TroopDarkName) - 1
			Assign($TroopDarkName[$i] & "Comp", IniRead($config, "troop", $TroopDarkName[$i], "0"))
		Next

		For $i = 0 To 3 ;Covers all 4 Barracks
			$barrackTroop[$i] = IniRead($config, "troop", "troop" & $i + 1, "0")
		Next

		For $i = 0 To 1 ;Covers all 2 Barracks
			$darkBarrackTroop[$i] = IniRead($config, "troop", "Darktroop" & $i + 1, "0")
		Next
		$fulltroop = IniRead($config, "troop", "fullTroop", "100")

		$isldTrainITDelay = IniRead($config, "troop", "TrainITDelay", "20")
		;barracks boost not saved (no use)

		; Spells Creation  ---------------------------------------------------------------------
		$iLightningSpellComp = Int(IniRead($config, "Spells", "LightningSpell", "0"))
		$iRageSpellComp = Int(IniRead($config, "Spells", "RageSpell", "0"))
		$iHealSpellComp = Int(IniRead($config, "Spells", "HealSpell", "0"))
		$iJumpSpellComp = Int(IniRead($config, "Spells", "JumpSpell", "0"))
		$iFreezeSpellComp = Int(IniRead($config, "Spells", "FreezeSpell", "0"))
		$iPoisonSpellComp = Int(IniRead($config, "Spells", "PoisonSpell", "0"))
		$iHasteSpellComp = Int(IniRead($config, "Spells", "HasteSpell", "0"))
		$iEarthSpellComp = Int(IniRead($config, "Spells", "EarthSpell", "0"))
		$iTotalCountSpell = Int(IniRead($config, "Spells", "SpellFactory", "0"))

		;Misc Settings--------------------------------------------------------------------------

		;Laboratory
		$ichkLab = IniRead($config, "upgrade", "upgradetroops", "0")
		$icmbLaboratory = IniRead($config, "upgrade", "upgradetroopname", "0")
		$sLabUpgradeTime = IniRead($building, "upgrade", "upgradelabtime", "")
		$aLabPos[0] = Int(IniRead($building, "upgrade", "LabPosX", "0"))
		$aLabPos[1] = Int(IniRead($building, "upgrade", "LabPosY", "0"))

		;Heroes upgrade
		$ichkUpgradeKing = IniRead($config, "upgrade", "UpgradeKing", "0")
		$ichkUpgradeQueen = IniRead($config, "upgrade", "UpgradeQueen", "0")
		$ichkUpgradeWarden = IniRead($config, "upgrade", "UpgradeWarden", "0")

		$ichkWalls = IniRead($config, "other", "auto-wall", "0")
		$iSaveWallBldr = IniRead($config, "other", "savebldr", "0")
		$iUseStorage = IniRead($config, "other", "use-storage", "0")

		$icmbWalls = IniRead($config, "other", "walllvl", "0")
		$iMaxNbWall = IniRead($config, "other", "MaxNbWall", "8")

		$itxtWallMinGold = IniRead($config, "other", "minwallgold", "0")
		$itxtWallMinElixir = IniRead($config, "other", "minwallelixir", "0")

		$itxtRestartGold = IniRead($config, "other", "minrestartgold", "10000")
		$itxtRestartElixir = IniRead($config, "other", "minrestartelixir", "25000")
		$itxtRestartDark = IniRead($config, "other", "minrestartdark", "500")

		$ichkTrap = IniRead($config, "other", "chkTrap", "0")
		$iChkCollect = IniRead($config, "other", "chkCollect", "1")
		$ichkTombstones = IniRead($config, "other", "chkTombstones", "0")
		$ichkCleanYard = IniRead($config, "other", "chkCleanYard", "0")
		$sTimeWakeUp = IniRead($config, "other", "txtTimeWakeUp", "0")
		$iVSDelay = IniRead($config, "other", "VSDelay", "0")
		$iMaxVSDelay = IniRead($config, "other", "MaxVSDelay", "0")

		$itxtMaxTrophy = IniRead($config, "other", "MaxTrophy", "5000")
		$itxtdropTrophy = IniRead($config, "other", "MinTrophy", "5000")
		$iChkTrophyHeroes = IniRead($config, "other", "chkTrophyHeroes", "0")
		$iChkTrophyAtkDead = IniRead($config, "other", "chkTrophyAtkDead", "0")
		$itxtDTArmyMin = IniRead($config, "other", "DTArmyMin", "70")

		$iWAOffsetX = IniRead($config, "other", "WAOffsetX", "10")
		$iWAOffsetY = IniRead($config, "other", "WAOffsetY", "0")

		;PushBullet Settings ---------------------------------------------
		$PushToken = IniRead($config, "pushbullet", "AccountToken", "")
		$iOrigPushB = IniRead($config, "pushbullet", "OrigPushB", $sCurrProfile)

		$iAlertPBVillage = IniRead($config, "pushbullet", "AlertPBVillage", "0")
		$iLastAttack = IniRead($config, "pushbullet", "AlertPBLastAttack", "0")
		$iAlertPBLastRaidTxt = IniRead($config, "pushbullet", "AlertPBLastRaidTxt", "0")


		$pEnabled = IniRead($config, "pushbullet", "PBEnabled", "0")
		$pRemote = IniRead($config, "pushbullet", "PBRemote", "0")
		$iDeleteAllPushes = IniRead($config, "pushbullet", "DeleteAllPBPushes", "0")
		$pMatchFound = IniRead($config, "pushbullet", "AlertPBVMFound", "0")
		$pLastRaidImg = IniRead($config, "pushbullet", "AlertPBLastRaid", "0")
		$pWallUpgrade = IniRead($config, "pushbullet", "AlertPBWallUpgrade", "0")
		$pOOS = IniRead($config, "pushbullet", "AlertPBOOS", "0")
		$pTakeAbreak = IniRead($config, "pushbullet", "AlertPBVBreak", "0")
		$pAnotherDevice = IniRead($config, "pushbullet", "AlertPBOtherDevice", "0")
		$icmbHoursPushBullet = IniRead($config, "pushbullet", "HoursPushBullet", "4")
		$ichkDeleteOldPushes = IniRead($config, "pushbullet", "DeleteOldPushes", "0")
		$ichkAlertPBCampFull = IniRead($config, "pushbullet", "AlertCampFull", "0")


		$ichkDeleteLogs = IniRead($config, "deletefiles", "DeleteLogs", "0")
		$iDeleteLogsDays = IniRead($config, "deletefiles", "DeleteLogsDays", "7")
		$ichkDeleteTemp = IniRead($config, "deletefiles", "DeleteTemp", "0")
		$iDeleteTempDays = IniRead($config, "deletefiles", "DeleteTempDays", "7")
		$ichkDeleteLoots = IniRead($config, "deletefiles", "DeleteLoots", "0")
		$iDeleteLootsDays = IniRead($config, "deletefiles", "DeleteLootsDays", "7")

		$debugClick = IniRead($config, "debug", "debugClick", "0")
		If $DevMode = 1 Then
			GUICtrlSetState($chkDebugSetlog, $GUI_SHOW)
			GUICtrlSetState($chkDebugOcr, $GUI_SHOW)
			GUICtrlSetState($chkDebugImageSave, $GUI_SHOW)
			GUICtrlSetState($chkdebugBuildingPos, $GUI_SHOW)
			GUICtrlSetState($chkmakeIMGCSV, $GUI_SHOW)
			$DebugSetlog = BitOR($DebugSetlog, IniRead($config, "debug", "debugsetlog", "0"))
			$DebugOcr = BitOR($DebugOcr, IniRead($config, "debug", "debugocr", "0"))
			$DebugImageSave = BitOR($DebugImageSave, IniRead($config, "debug", "debugimagesave", "0"))
			$debugBuildingPos = BitOR($debugBuildingPos, IniRead($config, "debug", "debugbuildingpos", "0"))
			$makeIMGCSV = BitOR($debugBuildingPos, IniRead($config, "debug", "debugmakeimgcsv", "0"))
			$debugresourcesoffset = BitOR($debugresourcesoffset, IniRead($config, "debug", "debugresourcesoffset", "0"))
			$continuesearchelixirdebug = BitOR($DebugSetlog, IniRead($config, "debug", "continuesearchelixirdebug", "0"))
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

		;Share Attack Settings----------------------------------------
		$iShareminGold = IniRead($config, "shareattack", "minGold", "200000")
		$iShareminElixir = IniRead($config, "shareattack", "minElixir", "200000")
		$iSharemindark = IniRead($config, "shareattack", "minDark", "100")
		$iShareAttack = IniRead($config, "shareattack", "ShareAttack", "0")
		$sShareMessage = StringReplace(IniRead($config, "shareattack", "Message", "Nice|Good|Thanks|Wowwww"), "|", @CRLF)

		;screenshot type: 0 JPG   1 PNG
		$iScreenshotType = IniRead($config, "other", "ScreenshotType", "0")

		$ichkScreenshotHideName = IniRead($config, "other", "ScreenshotHideName", "1")

		;forced Total Camp values
		$ichkTotalCampForced = IniRead($config, "other", "ChkTotalCampForced", "0")
		$iValueTotalCampForced = IniRead($config, "other", "ValueTotalCampForced", "200")

		$ichkSinglePBTForced  = IniRead($config, "other", "chkSinglePBTForced", "0")
		$iValueSinglePBTimeForced = IniRead($config, "other", "ValueSinglePBTimeForced", "18")
		$iValuePBTimeForcedExit = IniRead($config, "other", "ValuePBTimeForcedExit", "15")

		$ichkLanguage = IniRead($config, "General", "ChkLanguage", "1")
		$ichkVersion = IniRead($config, "General", "ChkVersion", "1")

		;Snipe While Train
		$iChkSnipeWhileTrain = IniRead($config, "SnipeWhileTrain", "chkSnipeWhileTrain", "0")
		$itxtSearchlimit = IniRead($config, "SnipeWhileTrain", "txtSearchlimit", "15")
		$itxtminArmyCapacityTHSnipe = IniRead($config, "SnipeWhileTrain", "txtminArmyCapacityTHSnipe", "35")
		$itxtSWTtiles = IniRead($config, "SnipeWhileTrain", "SWTtiles", "1")

		;AttackCSV
		$KingAttackCSV[$DB] = IniRead($config, "attackCSV", "DBKingAtk", "0")
		$KingAttackCSV[$LB] = IniRead($config, "attackCSV", "ABKingAtk", "0")
		$QueenAttackCSV[$DB] = IniRead($config, "attackCSV", "DBQueenAtk", "0")
		$QueenAttackCSV[$LB] = IniRead($config, "attackCSV", "ABQueenAtk", "0")
		$iDropCCCSV[$DB] = IniRead($config, "attackCSV", "DBDropCC", "0")
		$iDropCCCSV[$LB] = IniRead($config, "attackCSV", "ABDropCC", "0")
		$WardenAttackCSV[$DB] = IniRead($config, "attackCSV", "DBWardenAtk", "0")
		$WardenAttackCSV[$LB] = IniRead($config, "attackCSV", "ABWardenAtk", "0")
		$iChkUseCCBalancedCSV = IniRead($config, "attackCSV", "BalanceCC", "0")
		$iCmbCCDonatedCSV = IniRead($config, "attackCSV", "BalanceCCDonated", "1")
		$iCmbCCReceivedCSV = IniRead($config, "attackCSV", "BalanceCCReceived", "1")
		$iActivateKQConditionCSV = IniRead($config, "attackCSV", "ActivateKQ", "Auto")
		$delayActivateKQCSV = (1000 * IniRead($config, "attackCSV", "delayActivateKQ", "9"))
		$iActivateWardenConditionCSV = IniRead($config, "attackCSV", "ActivateWarden", "1")
		$scmbDBScriptName = IniRead($config, "attackCSV", "ScriptDB", "Barch four fingers")
		$ichkUseAttackDBCSV = IniRead($config, "attackCSV", "EnableScriptDB", "0")
		$scmbABScriptName = IniRead($config, "attackCSV", "ScriptAB", "Barch four fingers")
		$ichkUseAttackABCSV = IniRead($config, "attackCSV", "EnableScriptAB", "0")
		$ichkLightSpell[$DB] = IniRead($config, "attackCSV", "DBLightSpell", "0")
		$ichkLightSpell[$LB] = IniRead($config, "attackCSV", "ABLightSpell", "0")
		$ichkHealSpell[$DB] = IniRead($config, "attackCSV", "DBHealSpell", "0")
		$ichkHealSpell[$LB] = IniRead($config, "attackCSV", "ABHealSpell", "0")
		$ichkRageSpell[$DB] = IniRead($config, "attackCSV", "DBRageSpell", "0")
		$ichkRageSpell[$LB] = IniRead($config, "attackCSV", "ABRageSpell", "0")
		$ichkJumpSpell[$DB] = IniRead($config, "attackCSV", "DBJumpSpell", "0")
		$ichkJumpSpell[$LB] = IniRead($config, "attackCSV", "ABJumpSpell", "0")
		$ichkFreezeSpell[$DB] = IniRead($config, "attackCSV", "DBFreezeSpell", "0")
		$ichkFreezeSpell[$LB] = IniRead($config, "attackCSV", "ABFreezeSpell", "0")
		$ichkPoisonSpell[$DB] = IniRead($config, "attackCSV", "DBPoisonSpell", "0")
		$ichkPoisonSpell[$LB] = IniRead($config, "attackCSV", "ABPoisonSpell", "0")
		$ichkEarthquakeSpell[$DB] = IniRead($config, "attackCSV", "DBEarthquakeSpell", "0")
		$ichkEarthquakeSpell[$LB] = IniRead($config, "attackCSV", "ABEarthquakeSpell", "0")
		$ichkHasteSpell[$DB] = IniRead($config, "attackCSV", "DBHasteSpell", "0")
		$ichkHasteSpell[$LB] = IniRead($config, "attackCSV", "ABHasteSpell", "0")

		;MilkingAttack
		$MilkFarmLocateMine = IniRead($config,"MilkingAttack","LocateMine","1")
	    $MilkFarmLocateElixir = IniRead($config,"MilkingAttack","LocateElixir","1")
		$MilkFarmLocateDrill = IniRead($config,"MilkingAttack","LocateDrill","1")
		$MilkFarmElixirParam = StringSplit(IniRead($config,"MilkingAttack","LocateElixirLevel","-1|-1|-1|-1|-1|-1|2|2|2"),"|",2)
		If Ubound($MilkFarmElixirParam) <> 9 Then $MilkFarmElixirParam = StringSplit("-1|-1|-1|-1|-1|-1|2|2|2","|",2)
		$MilkFarmMineParam = IniRead($config,"MilkingAttack","MineParam","5")
		$MilkFarmDrillParam = IniRead($config,"MilkingAttack","DrillParam","1")

	    $MilkFarmAttackElixirExtractors = IniRead($config,"MilkingAttack","AttackElixir","1")
		$MilkFarmAttackGoldMines =  IniRead($config,"MilkingAttack","AttackMine","1")
		$MilkFarmAttackDarkDrills = IniRead($config,"MilkingAttack","AttackDrill","1")
		$MilkFarmLimitGold = IniRead($config,"MilkingAttack","LimitGold","9950000")
		$MilkFarmLimitElixir = IniRead($config,"MilkingAttack","LimitElixir","9950000")
		$MilkFarmLimitDark = IniRead($config,"MilkingAttack","LimitDark","199000")
		$MilkFarmResMaxTilesFromBorder = IniRead($config,"MilkingAttack","MaxTiles","0")

		$MilkFarmTroopForWaveMin = IniRead($config,"MilkingAttack","TroopForWaveMin","4")
		$MilkFarmTroopForWaveMax = IniRead($config,"MilkingAttack","TroopForWaveMax","6")
		$MilkFarmTroopMaxWaves = IniRead($config,"MilkingAttack","MaxWaves","4")
		$MilkFarmDelayFromWavesMin = IniRead($config,"MilkingAttack","DelayBetweenWavesMin","3000")
		$MilkFarmDelayFromWavesMax = IniRead($config,"MilkingAttack","DelayBetweenWavesMax","5000")
;~ 		$MilkFarmSnipeTh = IniRead($config,"MilkingAttack","SnipeTownHall","5000")
;~ 		$MilkFarmTHMaxTilesFromBorder = IniRead($config,"MilkingAttack","TownhallTiles","1")
;~ 		$MilkFarmAlgorithmTh = IniRead($config,"MilkingAttack","TownHallAlgorithm","Bam")
;~ 		$MilkFarmSnipeEvenIfNoExtractorsFound = IniRead($config,"MilkingAttack","TownHallHitAnyway","1")



	Else
		Return False
	EndIf
EndFunc   ;==>readConfig
