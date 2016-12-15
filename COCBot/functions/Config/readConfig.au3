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

	$configLoaded = True
	If FileExists($building) Then
		SetDebugLog("Read Building Config " & $building)
		Local $locationsInvalid = False
		Local $buildingVersion = "0.0.0"
		IniReadS($buildingVersion, $building, "general", "version", $buildingVersion)
		Local $_ver630 = GetVersionNormalized("6.3.0")
		Local $_ver63u = GetVersionNormalized("6.3.u")
		Local $_ver63u3 = GetVersionNormalized("6.3.u3")
		If $buildingVersion < $_ver630 _
		Or ($buildingVersion >= $_ver63u And $buildingVersion <= $_ver63u3) Then
			SetLog("New MyBot.run version! Re-locate all buildings!", $COLOR_WARNING)
			$locationsInvalid = True
		EndIf

		IniReadS($iTownHallLevel, $building, "other", "LevelTownHall", "0")

		If $locationsInvalid = False Then
			IniReadS($TownHallPos[0], $building, "other", "xTownHall", "-1")
			IniReadS($TownHallPos[1], $building, "other", "yTownHall", "-1")

			IniReadS($aCCPos[0], $building, "other", "xCCPos", "-1")
			IniReadS($aCCPos[1], $building, "other", "yCCPos", "-1")

			IniReadS($barrackPos[0][0], $building, "other", "xBarrack1", "-1")
			IniReadS($barrackPos[0][1], $building, "other", "yBarrack1", "-1")

			IniReadS($barrackPos[1][0], $building, "other", "xBarrack2", "-1")
			IniReadS($barrackPos[1][1], $building, "other", "yBarrack2", "-1")

			IniReadS($barrackPos[2][0], $building, "other", "xBarrack3", "-1")
			IniReadS($barrackPos[2][1], $building, "other", "yBarrack3", "-1")

			IniReadS($barrackPos[3][0], $building, "other", "xBarrack4", "-1")
			IniReadS($barrackPos[3][1], $building, "other", "yBarrack4", "-1")

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

			InireadS($aLabPos[0], $building, "upgrade", "LabPosX", "-1")
			InireadS($aLabPos[1], $building, "upgrade", "LabPosY", "-1")
		EndIf

		IniReadS($ArmyPos[0], $building, "other", "xArmy", "-1")
		IniReadS($ArmyPos[0], $building, "other", "yArmy", "-1")

		IniReadS($TotalCamp, $building, "other", "totalcamp", "0")
		IniReadS($listResourceLocation, $building, "other", "listResource", "")

		For $iz = 0 To UBound($aUpgrades, 1) - 1 ; Reads Upgrade building data
			$aUpgrades[$iz][0] = IniRead($building, "upgrade", "xupgrade" & $iz, "-1")
			$aUpgrades[$iz][1] = IniRead($building, "upgrade", "yupgrade" & $iz, "-1")
			$aUpgrades[$iz][2] = IniRead($building, "upgrade", "upgradevalue" & $iz, "-1")
			$aUpgrades[$iz][3] = IniRead($building, "upgrade", "upgradetype" & $iz, "")
			$aUpgrades[$iz][4] = IniRead($building, "upgrade", "upgradename" & $iz, "")
			$aUpgrades[$iz][5] = IniRead($building, "upgrade", "upgradelevel" & $iz, "")
			$aUpgrades[$iz][6] = IniRead($building, "upgrade", "upgradetime" & $iz, "")
			$aUpgrades[$iz][7] = IniRead($building, "upgrade", "upgradeend" & $iz, "-1")
			$ichkbxUpgrade[$iz] = IniRead($building, "upgrade", "upgradechk" & $iz, "0")
			$ichkUpgrdeRepeat[$iz] = IniRead($building, "upgrade", "upgraderepeat" & $iz, "0")
			$ipicUpgradeStatus[$iz] = IniRead($building, "upgrade", "upgradestatusicon" & $iz, $eIcnTroops)

			If $locationsInvalid = True Then
				$aUpgrades[$iz][0] = -1
				$aUpgrades[$iz][1] = -1
				$ichkbxUpgrade[$iz] = 0
				$ichkUpgrdeRepeat[$iz] = 0
			EndIf
		Next

		InireadS($ichkLab, $building, "upgrade", "upgradetroops", "0")
		InireadS($icmbLaboratory, $building, "upgrade", "upgradetroopname", "0")
		$sLabUpgradeTime = IniRead($building, "upgrade", "upgradelabtime", "")

	EndIf

	If FileExists($config) Then

		SetDebugLog("Read Config " & $config)

		;General Settings--------------------------------------------------------------------------
		;InireadS($icmbProfile,$config, "general", "cmbProfile", "01")?
		IniReadS($frmBotPosX, $config, "general", "frmBotPosX", "-1")
		IniReadS($frmBotPosY, $config, "general", "frmBotPosY", "-1")
		If $frmBotPosX < -30000 Or $frmBotPosY < -30000 Then
			; bot window was minimized, restore default position
			$frmBotPosX = -1
			$frmBotPosY = -1
		EndIf
		IniReadS($AndroidPosX, $config, "general", "AndroidPosX", "-1")
		IniReadS($AndroidPosY, $config, "general", "AndroidPosY", "-1")
		If $AndroidPosX < -30000 Or $AndroidPosY < -30000 Then
			; bot window was minimized, restore default position
			$AndroidPosX = -1
			$AndroidPosY = -1
		EndIf
		IniReadS($frmBotDockedPosX, $config, "general", "frmBotDockedPosX", "-1")
		IniReadS($frmBotDockedPosY, $config, "general", "frmBotDockedPosY", "-1")
		If $frmBotDockedPosX < -30000 Or $frmBotDockedPosY < -30000 Then
			; bot window was minimized, restore default position
			$frmBotDockedPosX = -1
			$frmBotDockedPosY = -1
		EndIf
		; $iUpdatingWhenMinimized must be always enabled
		;IniReadS($iUpdatingWhenMinimized, $config, "general", "UpdatingWhenMinimized", $iUpdatingWhenMinimized)
		IniReadS($iHideWhenMinimized, $config, "general", "HideWhenMinimized", $iHideWhenMinimized)

		IniReadS($iVillageName, $config, "general", "villageName", "")

		IniReadS($iCmbLog, $config, "general", "logstyle", "0")
		IniReadS($iDividerY, $config, "general", "LogDividerY", "243")

		IniReadS($ichkAutoStart, $config, "general", "AutoStart", "0")
		IniReadS($ichkAutoStartDelay, $config, "general", "AutoStartDelay", "10")
		IniReadS($restarted, $config, "general", "Restarted", $restarted, "int")
		If $bBotLaunchOption_Autostart = True Then $restarted = 1
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

		; 0 = disabled, 1 = Redraw always entire bot window, 2 = Redraw only required bot window area (or entire bot if control not specified)
		IniReadS($RedrawBotWindowMode, $config, "general", "RedrawBotWindowMode", "2", "Int")

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
		; IniReadS($iMaxNbWall, $config, "upgrade", "MaxNbWall", "8")
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
		IniReadS($iTrainArchersToFitCamps, $config, "troop", "TrainArchersToFitCamps", "1")

		IniReadS($iChkUseQuickTrain, $config, "troop", "UseQuickTrain", "0")
		IniReadS($iCmbCurrentArmy, $config, "troop", "CurrentArmy", "1")

		IniReadS($iRadio_Army1, $config, "troop", "QuickTrain1", "1")
		IniReadS($iRadio_Army2, $config, "troop", "QuickTrain2", "0")
		IniReadS($iRadio_Army3, $config, "troop", "QuickTrain3", "0")

		Local $tempTroop, $tempLevTroop
		For $T = 0 To UBound($TroopName) - 1
			Switch $TroopName[$T]
				Case "Barb"
					IniReadS($tempTroop, $config, "troop", $TroopName[$T], "58")
					IniReadS($tempLevTroop, $config, "LevelTroop", $TroopName[$T], "1")
				Case "Arch"
					IniReadS($tempTroop, $config, "troop", $TroopName[$T], "115")
					IniReadS($tempLevTroop, $config, "LevelTroop", $TroopName[$T], "1")
				Case "Gobl"
					IniReadS($tempTroop, $config, "troop", $TroopName[$T], "19")
					IniReadS($tempLevTroop, $config, "LevelTroop", $TroopName[$T], "1")
				Case "Giant"
					IniReadS($tempTroop, $config, "troop", $TroopName[$T], "4")
					IniReadS($tempLevTroop, $config, "LevelTroop", $TroopName[$T], "1")
				Case "Wall"
					IniReadS($tempTroop, $config, "troop", $TroopName[$T], "4")
					IniReadS($tempLevTroop, $config, "LevelTroop", $TroopName[$T], "1")
				Case Else
					IniReadS($tempTroop, $config, "troop", $TroopName[$T], "0")
					IniReadS($tempLevTroop, $config, "LevelTroop", $TroopName[$T], "0")
			EndSwitch
			Assign($TroopName[$T] & "Comp", $tempTroop)
			Assign("itxtLev" & $TroopName[$T], $tempLevTroop)
		Next
		Local $tempSpell, $tempLevSpell
		For $S = 0 To (UBound($SpellName) - 1)
			IniReadS($tempSpell, $config, "Spells", $SpellName[$S], "0")
			Assign($SpellName[$S] & "Comp", $tempSpell)
			IniReadS($tempLevSpell, $config, "LevelSpell", $SpellName[$S], "0")
			Assign("itxtLev" & $SpellName[$S], $tempLevSpell)
		Next

		For $i = 0 To 3 ;Covers all 4 Barracks
			IniReadS($barrackTroop[$i], $config, "troop", "troop" & $i + 1, "0")
		Next

		For $i = 0 To 1 ;Covers all 2 Barracks
			IniReadS($darkBarrackTroop[$i], $config, "troop", "Darktroop" & $i + 1, "0")
		Next

		IniReadS($fulltroop, $config, "troop", "fullTroop", "100")

		IniReadS($isldTrainITDelay, $config, "other", "TrainITDelay", "40")

		IniReadS($ichkCloseWaitEnable, $config, "other", "chkCloseWaitEnable", "1")
		IniReadS($ichkCloseWaitTrain, $config, "other", "chkCloseWaitTrain", "0")
		IniReadS($ibtnCloseWaitStop, $config, "other", "btnCloseWaitStop", "0")
		IniReadS($ibtnCloseWaitStopRandom, $config, "other", "btnCloseWaitStopRandom", "0")
		IniReadS($ibtnCloseWaitExact, $config, "other", "btnCloseWaitExact", "0")
		IniReadS($ibtnCloseWaitRandom, $config, "other", "btnCloseWaitRandom", "1")
		IniReadS($icmbCloseWaitRdmPercent, $config, "other", "CloseWaitRdmPercent", "10")
		IniReadS($icmbMinimumTimeClose, $config, "other", "MinimumTimeToClose", "2")

		IniReadS($ichkTroopOrder, $config, "troop", "chkTroopOrder", "0")
		For $z = 0 To UBound($DefaultTroopGroup) -1
			IniReadS($icmbTroopOrder[$z], $config, "troop", "cmbTroopOrder" & $z, $z)
		Next

		; IniReadS($ichkDarkTroopOrder, $config, "troop", "chkDarkTroopOrder", "0")
		; For $z = 0 To UBound($DefaultTroopGroupDark) -1
			; IniReadS($icmbDarkTroopOrder[$z], $config, "troop", "cmbDarkTroopOrder" & $z, "-1")
		; Next

		;Level Troops
		; IniReadS($itxtLevBarb, $config, "LevelTroop", "Barb", "0")
		; IniReadS($itxtLevArch, $config, "LevelTroop", "Arch", "0")
		; IniReadS($itxtLevGobl, $config, "LevelTroop", "Gobl", "0")
		; IniReadS($itxtLevGiant, $config, "LevelTroop", "Giant", "0")
		; IniReadS($itxtLevWall, $config, "LevelTroop", "Wall", "0")
		; IniReadS($itxtLevHeal, $config, "LevelTroop", "Heal", "0")
		; IniReadS($itxtLevPekk, $config, "LevelTroop", "Pekk", "0")
		; IniReadS($itxtLevBall, $config, "LevelTroop", "Ball", "0")
		; IniReadS($itxtLevWiza, $config, "LevelTroop", "Wiza", "0")
		; IniReadS($itxtLevDrag, $config, "LevelTroop", "Drag", "0")
		; IniReadS($itxtLevBabyD, $config, "LevelTroop", "BabyD", "0")
		; IniReadS($itxtLevMine, $config, "LevelTroop", "Mine", "0")
		; IniReadS($itxtLevMini, $config, "LevelTroop", "Mini", "0")
		; IniReadS($itxtLevHogs, $config, "LevelTroop", "Hogs", "0")
		; IniReadS($itxtLevValk, $config, "LevelTroop", "Valk", "0")
		; IniReadS($itxtLevGole, $config, "LevelTroop", "Gole", "0")
		; IniReadS($itxtLevWitc, $config, "LevelTroop", "Witc", "0")
		; IniReadS($itxtLevLava, $config, "LevelTroop", "Lava", "0")
		; IniReadS($itxtLevBowl, $config, "LevelTroop", "Bowl", "0")

		;Army training - Spells Creation  -----------------------------------------------------
		; Local $tempQtaSpell
		; IniReadS($LSpellComp, $config, "Spells", "LightningSpell", "0")
		; IniReadS($RSpellComp, $config, "Spells", "RageSpell", "0")
		; IniReadS($HSpellComp, $config, "Spells", "HealSpell", "0")
		; IniReadS($JSpellComp, $config, "Spells", "JumpSpell", "0")
		; IniReadS($FSpellComp, $config, "Spells", "FreezeSpell", "0")
		; IniReadS($CSpellComp, $config, "Spells", "CloneSpell", "0", "Int")
		; IniReadS($PSpellComp, $config, "Spells", "PoisonSpell", "0")
		; IniReadS($HaSpellComp, $config, "Spells", "HasteSpell", "0")
		; IniReadS($ESpellComp, $config, "Spells", "EarthSpell", "0")
		; IniReadS($SkSpellComp, $config, "Spells", "SkeletonSpell", "0", "Int")
		IniReadS($iTotalCountSpell, $config, "Spells", "SpellFactory", "0")
		; $LSpellComp = Int($LSpellComp)
		; $RSpellComp = Int($RSpellComp)
		; $HSpellComp = Int($HSpellComp)
		; $JSpellComp = Int($JSpellComp)
		; $FSpellComp = Int($FSpellComp)
		; $CSpellComp = Int($CSpellComp)
		; $PSpellComp = Int($PSpellComp)
		; $HaSpellComp = Int($HaSpellComp)
		; $ESpellComp = Int($ESpellComp)
		; $SkSpellComp = Int($SkSpellComp)
		$iTotalCountSpell = Int($iTotalCountSpell)
		;Level spell
		; IniReadS($itxtLevLSpell, $config, "LevelSpell", "Lightning", "0")
		; IniReadS($itxtLevHSpell, $config, "LevelSpell", "Heal", "0")
		; IniReadS($itxtLevRSpell, $config, "LevelSpell", "Rage", "0")
		; IniReadS($itxtLevJSpell, $config, "LevelSpell", "JumpSpell", "0")
		; IniReadS($itxtLevFSpell, $config, "LevelSpell", "Freeze", "0")
		; IniReadS($itxtLevCSpell, $config, "LevelSpell", "Clone", "0")
		; IniReadS($itxtLevPSpell, $config, "LevelSpell", "Poison", "0")
		; IniReadS($itxtLevESpell, $config, "LevelSpell", "Earthquake", "0")
		; IniReadS($itxtLevHaSpell, $config, "LevelSpell", "Haste", "0")
		; IniReadS($itxtLevSkSpell, $config, "LevelSpell", "Skeleton", "0")

		;======================================================================================================================
		;Search Settings------------------------------------------------------------------------

		IniReadS($iChkEnableAfter[$DB], $config, "search", "DBEnableAfter", "0")
		IniReadS($iCmbMeetGE[$DB], $config, "search", "DBMeetGE", "1")
		IniReadS($iChkMeetDE[$DB], $config, "search", "DBMeetDE", "0")
		IniReadS($iChkMeetTrophy[$DB], $config, "search", "DBMeetTrophy", "0")
		IniReadS($iChkMeetTH[$DB], $config, "search", "DBMeetTH", "0")
		IniReadS($iChkMeetTHO[$DB], $config, "search", "DBMeetTHO", "0")
		IniReadS($iChkMeetOne[$DB], $config, "search", "DBMeetOne", "0")

		IniReadS($iEnableAfterCount[$DB], $config, "search", "DBEnableAfterCount", "1")
		IniReadS($iEnableBeforeCount[$DB], $config, "search", "DBEnableBeforeCount", "9999", "Int")
		IniReadS($iEnableAfterTropies[$DB], $config, "search", "DBEnableAfterTropies", "100", "Int")
		IniReadS($iEnableBeforeTropies[$DB], $config, "search", "DBEnableBeforeTropies", "6000", "Int")
		IniReadS($iEnableAfterArmyCamps[$DB], $config, "search", "DBEnableAfterArmyCamps", "100", "Int")
		IniReadS($iMinGold[$DB], $config, "search", "DBsearchGold", "80000", "Int")
		IniReadS($iMinElixir[$DB], $config, "search", "DBsearchElixir", "80000")
		IniReadS($iMinGoldPlusElixir[$DB], $config, "search", "DBsearchGoldPlusElixir", "160000", "Int")
		IniReadS($iMinDark[$DB], $config, "search", "DBsearchDark", "0", "Int")
		IniReadS($iMinTrophy[$DB], $config, "search", "DBsearchTrophy", "0", "Int")
		IniReadS($iCmbTH[$DB], $config, "search", "DBTHLevel", "0")

		IniReadS($iCmbWeakMortar[$DB], $config, "search", "DBWeakMortar", "5", "Int")
		IniReadS($iCmbWeakWizTower[$DB], $config, "search", "DBWeakWizTower", "4", "Int")
		IniReadS($iCmbWeakAirDefense[$DB], $config, "search", "DBWeakAirDefense", "7", "Int")
		IniReadS($iCmbWeakXBow[$DB], $config, "search", "DBWeakXBow", "4", "Int")
		IniReadS($iCmbWeakInferno[$DB], $config, "search", "DBWeakInferno", "1", "Int")
		IniReadS($iCmbWeakEagle[$DB], $config, "search", "DBWeakEagle", "2", "Int")
		IniReadS($iChkMaxMortar[$DB], $config, "search", "DBCheckMortar", "0", "Int")
		IniReadS($iChkMaxWizTower[$DB], $config, "search", "DBCheckWizTower", "0", "Int")
		IniReadS($iChkMaxAirDefense[$DB], $config, "search", "DBCheckAirDefense", "0", "Int")
		IniReadS($iChkMaxXBow[$DB], $config, "search", "DBCheckXBow", "0", "Int")
		IniReadS($iChkMaxInferno[$DB], $config, "search", "DBCheckInferno", "0", "Int")
		IniReadS($iChkMaxEagle[$DB], $config, "search", "DBCheckEagle", "0", "Int")

		IniReadS($iChkEnableAfter[$LB], $config, "search", "ABEnableAfter", "0")
		IniReadS($iCmbMeetGE[$LB], $config, "search", "ABMeetGE", "2")
		IniReadS($iChkMeetDE[$LB], $config, "search", "ABMeetDE", "0")
		IniReadS($iChkMeetTrophy[$LB], $config, "search", "ABMeetTrophy", "0")
		IniReadS($iChkMeetTH[$LB], $config, "search", "ABMeetTH", "0")
		IniReadS($iChkMeetTHO[$LB], $config, "search", "ABMeetTHO", "0")
		IniReadS($iChkMeetOne[$LB], $config, "search", "ABMeetOne", "0")

		IniReadS($iEnableAfterCount[$LB], $config, "search", "ABEnableAfterCount", "1")
		IniReadS($iEnableBeforeCount[$LB], $config, "search", "ABEnableBeforeCount", "9999", "Int")
		IniReadS($iEnableAfterTropies[$LB], $config, "search", "ABEnableAfterTropies", "100", "Int")
		IniReadS($iEnableBeforeTropies[$LB], $config, "search", "ABEnableBeforeTropies", "6000", "Int")
		IniReadS($iEnableAfterArmyCamps[$LB], $config, "search", "ABEnableAfterArmyCamps", "100", "Int")

		IniReadS($iMinGold[$LB], $config, "search", "ABsearchGold", "80000", "Int")
		IniReadS($iMinElixir[$LB], $config, "search", "ABsearchElixir", "80000")
		IniReadS($iMinGoldPlusElixir[$LB], $config, "search", "ABsearchGoldPlusElixir", "160000", "Int")
		IniReadS($iMinDark[$LB], $config, "search", "ABsearchDark", "0", "Int")
		IniReadS($iMinTrophy[$LB], $config, "search", "ABsearchTrophy", "0", "Int")
		IniReadS($iCmbTH[$LB], $config, "search", "ABTHLevel", "0")

		IniReadS($iCmbWeakMortar[$LB], $config, "search", "ABWeakMortar", "5", "Int")
		IniReadS($iCmbWeakWizTower[$LB], $config, "search", "ABWeakWizTower", "4", "Int")
		IniReadS($iCmbWeakAirDefense[$LB], $config, "search", "ABWeakAirDefense", "7", "Int")
		IniReadS($iCmbWeakXBow[$LB], $config, "search", "ABWeakXBow", "4", "Int")
		IniReadS($iCmbWeakInferno[$LB], $config, "search", "ABWeakInferno", "1", "Int")
		IniReadS($iCmbWeakEagle[$LB], $config, "search", "ABWeakEagle", "2", "Int")
		IniReadS($iChkMaxMortar[$LB], $config, "search", "ABCheckMortar", "0", "Int")
		IniReadS($iChkMaxWizTower[$LB], $config, "search", "ABCheckWizTower", "0", "Int")
		IniReadS($iChkMaxAirDefense[$LB], $config, "search", "ABCheckAirDefense", "0", "Int")
		IniReadS($iChkMaxXBow[$LB], $config, "search", "ABCheckXBow", "0", "Int")
		IniReadS($iChkMaxInferno[$LB], $config, "search", "ABCheckInferno", "0", "Int")
		IniReadS($iChkMaxEagle[$LB], $config, "search", "ABCheckEagle", "0", "Int")

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
		IniReadS($iEnableBeforeCount[$TS], $config, "search", "TSEnableBeforeCount", "9999", "Int")
		IniReadS($iEnableAfterTropies[$TS], $config, "search", "TSEnableAfterTropies", "100", "Int")
		IniReadS($iEnableBeforeTropies[$TS], $config, "search", "TSEnableBeforeTropies", "6000", "Int")
		IniReadS($iEnableAfterArmyCamps[$TS], $config, "search", "TSEnableAfterArmyCamps", "100", "Int")
		IniReadS($iMinGold[$TS], $config, "search", "TSsearchGold", "80000", "Int")
		IniReadS($iMinElixir[$TS], $config, "search", "TSsearchElixir", "80000", "Int")
		IniReadS($iMinGoldPlusElixir[$TS], $config, "search", "TSsearchGoldPlusElixir", "160000", "Int")
		IniReadS($iMinDark[$TS], $config, "search", "TSsearchDark", "600", "Int")
		IniReadS($iCmbMeetGE[$TS], $config, "search", "TSMeetGE", "1")

		IniReadS($iChkTrophyRange, $config, "search", "TrophyRange", "0")
		IniReadS($itxtdropTrophy, $config, "search", "MinTrophy", "5000", "Int")
		IniReadS($itxtMaxTrophy, $config, "search", "MaxTrophy", "5000", "Int")
		IniReadS($iChkTrophyHeroes, $config, "search", "chkTrophyHeroes", "0")
		IniReadS($iCmbTrophyHeroesPriority, $config, "search", "cmbTrophyHeroesPriority", "0")
		IniReadS($iChkTrophyAtkDead, $config, "search", "chkTrophyAtkDead", "0")
		IniReadS($itxtDTArmyMin, $config, "search", "DTArmyMin", "70")

		IniReadS($itxtSWTtiles, $config, "search", "SWTtiles", "1")

		IniReadS($iDeadBaseDisableCollectorsFilter,$config, "search", "chkDisableCollectorsFilter", "0")
		;======================================================================================================================
		;Attack Basics Settings-------------------------------------------------------------------------
		IniReadS($iAtkAlgorithm[$DB], $config, "attack", "DBAtkAlgorithm", "0")
		IniReadS($iAtkAlgorithm[$LB], $config, "attack", "ABAtkAlgorithm", "0")
		IniReadS($iChkDeploySettings[$DB], $config, "attack", "DBDeploy", "3")
		IniReadS($iCmbUnitDelay[$DB], $config, "attack", "DBUnitD", "4")
		IniReadS($iCmbWaveDelay[$DB], $config, "attack", "DBWaveD", "4")
		IniReadS($iChkRandomspeedatk[$DB], $config, "attack", "DBRandomSpeedAtk", "1")

		IniReadS($iChkDeploySettings[$LB], $config, "attack", "ABDeploy", "0")
		IniReadS($iCmbUnitDelay[$LB], $config, "attack", "ABUnitD", "4")
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
		$iHeroWaitNoBit[$DB][0] = ($temp1 > $HERO_NOHERO) ? 1 : 0
		$iHeroWaitNoBit[$DB][1] = ($temp2 > $HERO_NOHERO) ? 1 : 0
		$iHeroWaitNoBit[$DB][2] = ($temp3 > $HERO_NOHERO) ? 1 : 0

		IniReadS($temp1, $config, "attack", "ABKingWait", $HERO_NOHERO)
		IniReadS($temp2, $config, "attack", "ABQueenWait", $HERO_NOHERO)
		IniReadS($temp3, $config, "attack", "ABWardenWait", $HERO_NOHERO)
		$iHeroWait[$LB] = BitOR(Int($temp1), Int($temp2), Int($temp3))
		$iHeroWaitNoBit[$LB][0] = ($temp1 > $HERO_NOHERO) ? 1 : 0
		$iHeroWaitNoBit[$LB][1] = ($temp2 > $HERO_NOHERO) ? 1 : 0
		$iHeroWaitNoBit[$LB][2] = ($temp3 > $HERO_NOHERO) ? 1 : 0

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

		IniReadS($ichkCloneSpell[$DB], $config, "attack", "DBCloneSpell", "0")
		IniReadS($ichkCloneSpell[$LB], $config, "attack", "ABCloneSpell", "0")

		IniReadS($ichkSkeletonSpell[$DB], $config, "attack", "DBSkeletonSpell", "0")
		IniReadS($ichkSkeletonSpell[$LB], $config, "attack", "ABSkeletonSpell", "0")

		IniReadS($scmbDBScriptName, $config, "attack", "ScriptDB", "Barch four fingers")
		IniReadS($scmbABScriptName, $config, "attack", "ScriptAB", "Barch four fingers")

		IniReadS($iRedlineRoutine[$DB], $config, "attack", "RedlineRoutineDB", $iRedlineRoutine[$DB], "Int")
		IniReadS($iRedlineRoutine[$LB], $config, "attack", "RedlineRoutineAB", $iRedlineRoutine[$LB], "Int")
		IniReadS($iDroplineEdge[$DB], $config, "attack", "DroplineEdgeDB", $iDroplineEdge[$DB], "Int")
		IniReadS($iDroplineEdge[$LB], $config, "attack", "DroplineEdgeAB", $iDroplineEdge[$LB], "Int")

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

#CS
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
#CE
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
		IniReadS($iVSDelay, $config, "other", "VSDelay", "0", "Int")
		IniReadS($iMaxVSDelay, $config, "other", "MaxVSDelay", "4", "Int")

		IniReadS($iWAOffsetX, $config, "other", "WAOffsetX", "0")
		IniReadS($iWAOffsetY, $config, "other", "WAOffsetY", "0")

		;==============================================================
		;NOTIFY CONFIG ================================================
		;==============================================================
		;PushBullet / Telegram----------------------------------------
		IniReadS($NotifyPBToken, $config, "notify", "PBToken", "")
		IniReadS($NotifyTGToken, $config, "notify", "TGToken", "")
		IniReadS($NotifyOrigin, $config, "notify", "Origin", $sCurrProfile)

		IniReadS($NotifyAlerLastRaidTXT, $config, "notify", "AlertPBLastRaidTxt", "0")
		IniReadS($NotifyPBEnabled, $config, "notify", "PBEnabled", "0")
		IniReadS($NotifyTGEnabled, $config, "notify", "TGEnabled", "0")
		IniReadS($NotifyRemoteEnable, $config, "notify", "PBRemote", "0")
		IniReadS($NotifyDeleteAllPushesOnStart, $config, "notify", "DeleteAllPBPushes", "0")
		IniReadS($NotifyAlertMatchFound, $config, "notify", "AlertPBVMFound", "0")
		IniReadS($NotifyAlerLastRaidIMG, $config, "notify", "AlertPBLastRaid", "0")
		IniReadS($NotifyAlertUpgradeWalls, $config, "notify", "AlertPBWallUpgrade", "0")
		IniReadS($NotifyAlertOutOfSync, $config, "notify", "AlertPBOOS", "0")
		IniReadS($NotifyAlertTakeBreak, $config, "notify", "AlertPBVBreak", "0")
		IniReadS($NotifyAlertAnotherDevice, $config, "notify", "AlertPBOtherDevice", "0")
		IniReadS($NotifyDeletePushesOlderThanHours, $config, "notify", "HoursPushBullet", "4")
		IniReadS($NotifyDeletePushesOlderThan, $config, "notify", "DeleteOldPBPushes", "0")
		IniReadS($NotifyAlertCampFull, $config, "notify", "AlertPBCampFull", "0")
		IniReadS($NotifyAlertVillageReport, $config, "notify", "AlertPBVillage", "0")
		IniReadS($NotifyAlertLastAttack, $config, "notify", "AlertPBLastAttack", "0")
		IniReadS($NotifyAlertBulderIdle, $config, "notify", "AlertBuilderIdle", "0")
		IniReadS($NotifyAlertMaintenance, $config, "notify", "AlertPBMaintenance", "0")
		IniReadS($NotifyAlertBAN, $config, "notify", "AlertPBBAN", "0")
		IniReadS($NotifyAlertBOTUpdate, $config, "notify", "AlertPBUpdate", "0")

		;Schedule
		$NotifyScheduleWeekDaysEnable = IniRead($config, "notify", "NotifyWeekDaysEnable", "0")
		$NotifyScheduleWeekDays = StringSplit(IniRead($config, "notify", "NotifyWeekDays", "1|1|1|1|1|1|1"),"|", $STR_NOCOUNT)
		$NotifyScheduleHoursEnable = IniRead($config, "notify", "NotifyHoursEnable", "0")
		$NotifyScheduleHours = StringSplit(IniRead($config, "notify", "NotifyHours", "1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1"),"|", $STR_NOCOUNT)
		;==============================================================
		;NOTIFY CONFIG ================================================
		;==============================================================


		IniReadS($ichkDeleteLogs, $config, "deletefiles", "DeleteLogs", "1")
		IniReadS($iDeleteLogsDays, $config, "deletefiles", "DeleteLogsDays", "2")
		IniReadS($ichkDeleteTemp, $config, "deletefiles", "DeleteTemp", "1")
		IniReadS($iDeleteTempDays, $config, "deletefiles", "DeleteTempDays", "2")
		IniReadS($ichkDeleteLoots, $config, "deletefiles", "DeleteLoots", "1")
		IniReadS($iDeleteLootsDays, $config, "deletefiles", "DeleteLootsDays", "2")

		$DebugClick = BitOR($DebugClick, Int(IniRead($config, "debug", "debugsetclick", "0")))
		If $DevMode = 1 Then
			$DebugSetlog = BitOR($DebugSetlog, Int(IniRead($config, "debug", "debugsetlog", "0")))
			$DebugDisableZoomout = BitOR($DebugDisableZoomout, Int(IniRead($config, "debug", "disablezoomout", "0")))
			$DebugDisableVillageCentering = BitOR($DebugDisableVillageCentering, Int(IniRead($config, "debug", "disablevillagecentering", "0")))
			$DebugOcr = BitOR($DebugOcr, Int(IniRead($config, "debug", "debugocr", "0")))
			$DebugImageSave = BitOR($DebugImageSave, Int(IniRead($config, "debug", "debugimagesave", "0")))
			$debugBuildingPos = BitOR($debugBuildingPos, Int(IniRead($config, "debug", "debugbuildingpos", "0")))
			$debugsetlogTrain = BitOR($debugsetlogTrain, Int(IniRead($config, "debug", "debugtrain", "0")))
			$debugresourcesoffset = BitOR($debugresourcesoffset, Int(IniRead($config, "debug", "debugresourcesoffset", "0")))
			$continuesearchelixirdebug = BitOR($continuesearchelixirdebug, Int(IniRead($config, "debug", "continuesearchelixirdebug", "0")))
			$debugMilkingIMGmake = BitOR($debugMilkingIMGmake, Int(IniRead($config, "debug", "debugMilkingIMGmake", "0")))
			$debugOCRdonate = BitOR($debugOCRdonate, Int(IniRead($config, "debug", "debugOCRDonate", "0")))
			$debugAttackCSV = BitOR($debugAttackCSV, Int(IniRead($config, "debug", "debugAttackCSV", "0")))
			$makeIMGCSV = BitOR($makeIMGCSV, Int(IniRead($config, "debug", "debugmakeimgcsv", "0")))
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

		$ichkAttackPlannerEnable = IniRead($config, "planned", "chkAttackPlannerEnable", "0")
		$ichkAttackPlannerCloseCoC = IniRead($config, "planned", "chkAttackPlannerCloseCoC", "0")
		$ichkAttackPlannerCloseAll = IniRead($config, "planned", "chkAttackPlannerCloseAll", "0")
		$ichkAttackPlannerRandom = IniRead($config, "planned", "chkAttackPlannerRandom", "0")
		$icmbAttackPlannerRandom = IniRead($config, "planned", "cmbAttackPlannerRandom", "4")
		$ichkAttackPlannerDayLimit = IniRead($config, "planned", "chkAttackPlannerDayLimit", "0")
		$icmbAttackPlannerDayMin = IniRead($config, "planned", "cmbAttackPlannerDayMin", "12")
		$icmbAttackPlannerDayMax = IniRead($config, "planned", "cmbAttackPlannerDayMax", "15")


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

		;Use random click
		$iUseRandomClick = IniRead($config, "other", "UseRandomClick", "0")

		;Add idle phase during training read variables from ini file
		$ichkAddIdleTime = IniRead($config, "other", "chkAddIdleTime", "1")
		IniReadS($iAddIdleTimeMin, $config, "other", "txtAddDelayIdlePhaseTimeMin", $iAddIdleTimeMin)
		IniReadS($iAddIdleTimeMax, $config, "other", "txtAddDelayIdlePhaseTimeMax", $iAddIdleTimeMax)

		;screenshot type: 0 JPG   1 PNG
		$iScreenshotType = IniRead($config, "other", "ScreenshotType", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")

		$ichkScreenshotHideName = IniRead($config, "other", "ScreenshotHideName", "1")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")

		$ichkUseQTrain = IniRead($config, "other", "ChkUseQTrain", "0")
		$ichkForceBrewBeforeAttack = IniRead($config, "other", "ChkForceBrewBeforeAttack", "0")

		;forced Total Camp values
		$ichkTotalCampForced = IniRead($config, "other", "ChkTotalCampForced", "1")
		$iValueTotalCampForced = IniRead($config, "other", "ValueTotalCampForced", "220")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")

		$ichkSinglePBTForced = IniRead($config, "other", "chkSinglePBTForced", "0")
		$iValueSinglePBTimeForced = IniRead($config, "other", "ValueSinglePBTimeForced", "18")
		$iValuePBTimeForcedExit = IniRead($config, "other", "ValuePBTimeForcedExit", "15")

		$ichkLanguage = IniRead($config, "General", "ChkLanguage", "1")
		$ichkDisableSplash = IniRead($config, "General", "ChkDisableSplash", $ichkDisableSplash)
		$ichkVersion = IniRead($config, "General", "ChkVersion", "1")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")
		;InireadS(xxxx,$config, "attack", "xxxx", "0")

		$ichkFixClanCastle = IniRead($config, "other", "ChkFixClanCastle", "0")

		;Donate Settings-------------------------------------------------------------------------
		$sTxtRequest = IniRead($config, "donate", "txtRequest", "")
		$sSkipDonateNearFulLTroopsPercentual = IniRead($config, "donate", "SkipDonateNearFulLTroopsPercentual", 90)
		$iSkipDonateNearFulLTroopsEnable = IniRead($config, "donate", "SkipDonateNearFulLTroopsEnable", 1)
		;InireadS(xxxx,$config, "attack", "xxxx", "0")

		$ichkDonateBarbarians = IniRead($config, "donate", "chkDonateBarbarians", "0")
		$ichkDonateAllBarbarians = IniRead($config, "donate", "chkDonateAllBarbarians", "0")
		$sTxtDonateBarbarians = StringReplace(IniRead($config, "donate", "txtDonateBarbarians", "barbarians|barbarian|barb"), "|", @CRLF)
		$sTxtBlacklistBarbarians = StringReplace(IniRead($config, "donate", "txtBlacklistBarbarians", "no barbarians|no barb|barbarian no|barb no"), "|", @CRLF)
		$aDonBarbarians = StringSplit($sTxtDonateBarbarians, @CRLF, $STR_ENTIRESPLIT)
		$aBlkBarbarians = StringSplit($sTxtBlacklistBarbarians, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateArchers = IniRead($config, "donate", "chkDonateArchers", "0")
		$ichkDonateAllArchers = IniRead($config, "donate", "chkDonateAllArchers", "0")
		$sTxtDonateArchers = StringReplace(IniRead($config, "donate", "txtDonateArchers", "archers|archer|arch"), "|", @CRLF)
		$sTxtBlacklistArchers = StringReplace(IniRead($config, "donate", "txtBlacklistArchers", "no archers|no arch|archer no|arch no"), "|", @CRLF)
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
		$sTxtBlacklistBalloons = StringReplace(IniRead($config, "donate", "txtBlacklistBalloons", "no balloon|balloons no"), "|", @CRLF)
		$aDonBalloons = StringSplit($sTxtDonateBalloons, @CRLF, $STR_ENTIRESPLIT)
		$aBlkBalloons = StringSplit($sTxtBlacklistBalloons, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateWizards = IniRead($config, "donate", "chkDonateWizards", "0")
		$ichkDonateAllWizards = IniRead($config, "donate", "chkDonateAllWizards", "0")
		$sTxtDonateWizards = StringReplace(IniRead($config, "donate", "txtDonateWizards", "wizards|wizard|wiz"), "|", @CRLF)
		$sTxtBlacklistWizards = StringReplace(IniRead($config, "donate", "txtBlacklistWizards", "no wizards|wizards no|no wizard|wizard no"), "|", @CRLF)
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
		$sTxtDonatePekkas = StringReplace(IniRead($config, "donate", "txtDonatePekkas", "PEKKA|pekka"), "|", @CRLF)
		$sTxtBlacklistPekkas = StringReplace(IniRead($config, "donate", "txtBlacklistPekkas", "no PEKKA|pekka no"), "|", @CRLF)
		$aDonPekkas = StringSplit($sTxtDonatePekkas, @CRLF, $STR_ENTIRESPLIT)
		$aBlkPekkas = StringSplit($sTxtBlacklistPekkas, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateBabyDragons = IniRead($config, "donate", "chkDonateBabyDragons", "0")
		$ichkDonateAllBabyDragons = IniRead($config, "donate", "chkDonateAllBabyDragons", "0")
		$sTxtDonateBabyDragons = StringReplace(IniRead($config, "donate", "txtDonateBabyDragons", "baby dragon|baby"), "|", @CRLF)
		$sTxtBlacklistBabyDragons = StringReplace(IniRead($config, "donate", "txtBlacklistBabyDragons", "no baby dragon|baby dragon no|no baby|baby no"), "|", @CRLF)
		$aDonBabyDragons = StringSplit($sTxtDonateBabyDragons, @CRLF, $STR_ENTIRESPLIT)
		$aBlkBabyDragons = StringSplit($sTxtBlacklistBabyDragons, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateMiners = IniRead($config, "donate", "chkDonateMiners", "0")
		$ichkDonateAllMiners = IniRead($config, "donate", "chkDonateAllMiners", "0")
		$sTxtDonateMiners = StringReplace(IniRead($config, "donate", "txtDonateMiners", "miner|mine"), "|", @CRLF)
		$sTxtBlacklistMiners = StringReplace(IniRead($config, "donate", "txtBlacklistMiners", "no miner|miner no|no mine|mine no"), "|", @CRLF)
		$aDonMiners = StringSplit($sTxtDonateMiners, @CRLF, $STR_ENTIRESPLIT)
		$aBlkMiners = StringSplit($sTxtBlacklistMiners, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateMinions = IniRead($config, "donate", "chkDonateMinions", "0")
		$ichkDonateAllMinions = IniRead($config, "donate", "chkDonateAllMinions", "0")
		$sTxtDonateMinions = StringReplace(IniRead($config, "donate", "txtDonateMinions", "minions|minion"), "|", @CRLF)
		$sTxtBlacklistMinions = StringReplace(IniRead($config, "donate", "txtBlacklistMinions", "no minion|minions no"), "|", @CRLF)
		$aDonMinions = StringSplit($sTxtDonateMinions, @CRLF, $STR_ENTIRESPLIT)
		$aBlkMinions = StringSplit($sTxtBlacklistMinions, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateHogRiders = IniRead($config, "donate", "chkDonateHogRiders", "0")
		$ichkDonateAllHogRiders = IniRead($config, "donate", "chkDonateAllHogRiders", "0")
		$sTxtDonateHogRiders = StringReplace(IniRead($config, "donate", "txtDonateHogRiders", "hogriders|hogs|hog"), "|", @CRLF)
		$sTxtBlacklistHogRiders = StringReplace(IniRead($config, "donate", "txtBlacklistHogRiders", "no hogriders|hogriders no|no hog|hogs no"), "|", @CRLF)
		$aDonHogRiders = StringSplit($sTxtDonateHogRiders, @CRLF, $STR_ENTIRESPLIT)
		$aBlkHogRiders = StringSplit($sTxtBlacklistHogRiders, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateValkyries = IniRead($config, "donate", "chkDonateValkyries", "0")
		$ichkDonateAllValkyries = IniRead($config, "donate", "chkDonateAllValkyries", "0")
		$sTxtDonateValkyries = StringReplace(IniRead($config, "donate", "txtDonateValkyries", "valkyries|valkyrie|valk"), "|", @CRLF)
		$sTxtBlacklistValkyries = StringReplace(IniRead($config, "donate", "txtBlacklistValkyries", "no valkyrie|valkyries no|no valk|valk no"), "|", @CRLF)
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
		$sTxtBlacklistWitches = StringReplace(IniRead($config, "donate", "txtBlacklistWitches", "no witches|witches no|no witch|witch no"), "|", @CRLF)
		$aDonWitches = StringSplit($sTxtDonateWitches, @CRLF, $STR_ENTIRESPLIT)
		$aBlkWitches = StringSplit($sTxtBlacklistWitches, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateLavaHounds = IniRead($config, "donate", "chkDonateLavaHounds", "0")
		$ichkDonateAllLavaHounds = IniRead($config, "donate", "chkDonateAllLavaHounds", "0")
		$sTxtDonateLavaHounds = StringReplace(IniRead($config, "donate", "txtDonateLavaHounds", "lavahounds|lava|hound"), "|", @CRLF)
		$sTxtBlacklistLavaHounds = StringReplace(IniRead($config, "donate", "txtBlacklistLavaHounds", "no lavahound|lavahound no|no lava|lava no|nohound|hound no"), "|", @CRLF)
		$aDonLavaHounds = StringSplit($sTxtDonateLavaHounds, @CRLF, $STR_ENTIRESPLIT)
		$aBlkLavaHounds = StringSplit($sTxtBlacklistLavaHounds, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateBowlers = IniRead($config, "donate", "chkDonateBowlers", "0")
		$ichkDonateAllBowlers = IniRead($config, "donate", "chkDonateAllBowlers", "0")
		$sTxtDonateBowlers = StringReplace(IniRead($config, "donate", "txtDonateBowlers", "bowler|bowl"), "|", @CRLF)
		$sTxtBlacklistBowlers = StringReplace(IniRead($config, "donate", "txtBlacklistBowlers", "no bowler|bowl no"), "|", @CRLF)
		$aDonBowlers = StringSplit($sTxtDonateBowlers, @CRLF, $STR_ENTIRESPLIT)
		$aBlkBowlers = StringSplit($sTxtBlacklistBowlers, @CRLF, $STR_ENTIRESPLIT)

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

		$ichkDonateSkeletonSpells = IniRead($config, "donate", "chkDonateSkeletonSpells", "0")
		$ichkDonateAllSkeletonSpells = IniRead($config, "donate", "chkDonateAllSkeletonSpells", "0")
		$sTxtDonateSkeletonSpells = StringReplace(IniRead($config, "donate", "txtDonateSkeletonSpells", "skeleton"), "|", @CRLF)
		$sTxtBlacklistSkeletonSpells = StringReplace(IniRead($config, "donate", "txtBlacklistSkeletonSpells", "no skeleton|skeleton no"), "|", @CRLF)
		$aDonSkeletonSpells = StringSplit($sTxtDonateSkeletonSpells, @CRLF, $STR_ENTIRESPLIT)
		$aBlkSkeletonSpells = StringSplit($sTxtBlacklistSkeletonSpells, @CRLF, $STR_ENTIRESPLIT)

		;;; Custom Combination Donate by ChiefM3, edit by Hervidero & MonkeyHunter
		$ichkDonateCustomA = IniRead($config, "donate", "chkDonateCustomA", "0")
		$ichkDonateAllCustomA = IniRead($config, "donate", "chkDonateAllCustomA", "0")
		$sTxtDonateCustomA = StringReplace(IniRead($config, "donate", "txtDonateCustomA", "ground support|ground"), "|", @CRLF)
		$sTxtBlacklistCustomA = StringReplace(IniRead($config, "donate", "txtBlacklistCustomA", "no ground|ground no|nonly"), "|", @CRLF)
		$aDonCustomA = StringSplit($sTxtDonateCustomA, @CRLF, $STR_ENTIRESPLIT)
		$aBlkCustomA = StringSplit($sTxtBlacklistCustomA, @CRLF, $STR_ENTIRESPLIT)
		$varDonateCustomA[0][0] = IniRead($config, "donate", "cmbDonateCustomA1", "6")
		$varDonateCustomA[1][0] = IniRead($config, "donate", "cmbDonateCustomA2", "1")
		$varDonateCustomA[2][0] = IniRead($config, "donate", "cmbDonateCustomA3", "0")
		$varDonateCustomA[0][1] = IniRead($config, "donate", "txtDonateCustomA1", "2")
		$varDonateCustomA[1][1] = IniRead($config, "donate", "txtDonateCustomA2", "3")
		$varDonateCustomA[2][1] = IniRead($config, "donate", "txtDonateCustomA3", "1")

		$ichkDonateCustomB = IniRead($config, "donate", "chkDonateCustomB", "0")
		$ichkDonateAllCustomB = IniRead($config, "donate", "chkDonateAllCustomB", "0")
		$sTxtDonateCustomB = StringReplace(IniRead($config, "donate", "txtDonateCustomB", "air support|any air"), "|", @CRLF)
		$sTxtBlacklistCustomB = StringReplace(IniRead($config, "donate", "txtBlacklistCustomB", "no air|air no|only|just"), "|", @CRLF)
		$aDonCustomB = StringSplit($sTxtDonateCustomB, @CRLF, $STR_ENTIRESPLIT)
		$aBlkCustomB = StringSplit($sTxtBlacklistCustomB, @CRLF, $STR_ENTIRESPLIT)
		$varDonateCustomB[0][0] = IniRead($config, "donate", "cmbDonateCustomB1", "11")
		$varDonateCustomB[1][0] = IniRead($config, "donate", "cmbDonateCustomB2", "1")
		$varDonateCustomB[2][0] = IniRead($config, "donate", "cmbDonateCustomB3", "6")
		$varDonateCustomB[0][1] = IniRead($config, "donate", "txtDonateCustomB1", "3")
		$varDonateCustomB[1][1] = IniRead($config, "donate", "txtDonateCustomB2", "13")
		$varDonateCustomB[2][1] = IniRead($config, "donate", "txtDonateCustomB3", "5")

		$sTxtBlacklist = StringReplace(IniRead($config, "donate", "txtBlacklist", "clan war|war|cw"), "|", @CRLF)
		$aBlackList = StringSplit($sTxtBlacklist, @CRLF, $STR_ENTIRESPLIT)


		$icmbFilterDonationsCC = IniRead($config, "donate", "cmbFilterDonationsCC", "0")


		; Extra Alphabets, Cyrillic, Chinese
		$ichkExtraAlphabets = IniRead($config, "donate", "chkExtraAlphabets", "0")
		$ichkExtraChinese = IniRead($config, "donate", "chkExtraChinese", "0")

		;InireadS($chkLvl6Enabled, $config, "collectors", "lvl6Enabled", "0", "Int")
		$chkLvl6Enabled = 0
		InireadS($chkLvl7Enabled, $config, "collectors", "lvl7Enabled", "1", "Int")
		InireadS($chkLvl8Enabled, $config, "collectors", "lvl8Enabled", "1", "Int")
		InireadS($chkLvl9Enabled, $config, "collectors", "lvl9Enabled", "1", "Int")
		InireadS($chkLvl10Enabled, $config, "collectors", "lvl10Enabled", "1", "Int")
		InireadS($chkLvl11Enabled, $config, "collectors", "lvl11Enabled", "1", "Int")
		InireadS($chkLvl12Enabled, $config, "collectors", "lvl12Enabled", "1", "Int")
		InireadS($cmbLvl6Fill, $config, "collectors", "lvl6fill", "0", "Int")
		If $cmbLvl6Fill > 1 Then $cmbLvl6Fill = 1
		InireadS($cmbLvl7Fill, $config, "collectors", "lvl7fill", "0", "Int")
		If $cmbLvl7Fill > 1 Then $cmbLvl7Fill = 1
		InireadS($cmbLvl8Fill, $config, "collectors", "lvl8fill", "0", "Int")
		If $cmbLvl8Fill > 1 Then $cmbLvl8Fill = 1
		InireadS($cmbLvl9Fill, $config, "collectors", "lvl9fill", "0", "Int")
		If $cmbLvl9Fill > 1 Then $cmbLvl9Fill = 1
		InireadS($cmbLvl10Fill, $config, "collectors", "lvl10fill", "0", "Int")
		If $cmbLvl10Fill > 1 Then $cmbLvl10Fill = 1
		InireadS($cmbLvl11Fill, $config, "collectors", "lvl11fill", "0", "Int")
		If $cmbLvl11Fill > 1 Then $cmbLvl11Fill = 1
		InireadS($cmbLvl12Fill, $config, "collectors", "lvl12fill", "0", "Int")
		If $cmbLvl12Fill > 1 Then $cmbLvl12Fill = 1
		InireadS($toleranceOffset, $config, "collectors", "tolerance", "0", "Int")
		InireadS($iMinCollectorMatches, $config, "collectors", "minmatches", $iMinCollectorMatches) ; 1-6 collectors
		If $iMinCollectorMatches < 1 Or $iMinCollectorMatches > 6 Then $iMinCollectorMatches = 3

		; Android Configuration
		$AndroidAutoAdjustConfig = IniRead($config, "android", "auto.adjust.config", ($AndroidAutoAdjustConfig ? "1" : "0")) = "1" ; if enabled, best android options are configured
		$AndroidGameDistributor = IniRead($config, "android", "game.distributor", $AndroidGameDistributor)
		$AndroidGamePackage = IniRead($config, "android", "game.package", $AndroidGamePackage)
		$AndroidGameClass = IniRead($config, "android", "game.class", $AndroidGameClass)
		$UserGameDistributor = IniRead($config, "android", "user.distributor", $UserGameDistributor)
		$UserGamePackage = IniRead($config, "android", "user.package", $UserGamePackage)
		$UserGameClass = IniRead($config, "android", "user.class", $UserGameClass)
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
		$AndroidShieldColor = Dec(IniRead($config, "android", "shield.color", Hex($AndroidShieldColor, 6)))
		$AndroidShieldTransparency = Int(IniRead($config, "android", "shield.transparency", $AndroidShieldTransparency))
		$AndroidActiveColor = Dec(IniRead($config, "android", "active.color", Hex($AndroidActiveColor, 6)))
		$AndroidActiveTransparency = Int(IniRead($config, "android", "active.transparency", $AndroidActiveTransparency))
		$AndroidInactiveColor = Dec(IniRead($config, "android", "inactive.color", Hex($AndroidInactiveColor, 6)))
		$AndroidInactiveTransparency = Int(IniRead($config, "android", "inactive.transparency", $AndroidInactiveTransparency))

		;Apply to switch Attack Standard after THSnipe End ==>
		IniReadS($ichkTSActivateCamps2, $config, "search", "ChkTSSearchCamps2", "0")
		IniReadS($iEnableAfterArmyCamps2, $config, "search", "TSEnableAfterArmyCamps2", "100")
		;==>Apply to switch Attack Standard after THSnipe End

		;Wait For Spells
		IniReadS($iEnableSpellsWait[$DB], $config, "search", "ChkDBSpellsWait", "0")
		IniReadS($iEnableSpellsWait[$LB], $config, "search", "ChkABSpellsWait", "0")
		IniReadS($iTotalTrainSpaceSpell, $config, "search", "TotalTrainSpaceSpell", "0")
		IniReadS($iChkWaitForCastleSpell[$DB], $config, "search", "ChkDBCastleSpellWait", "0")
		IniReadS($iChkWaitForCastleSpell[$LB], $config, "search", "ChkABCastleSpellWait", "0")
		IniReadS($iChkWaitForCastleTroops[$DB], $config, "search", "ChkDBCastleTroopsWait", "0")
		IniReadS($iChkWaitForCastleTroops[$LB], $config, "search", "ChkABCastleTroopsWait", "0")
		IniReadS($iCmbWaitForCastleSpell[$DB], $config, "search", "cmbDBWaitForCastleSpell", "0")
		IniReadS($iCmbWaitForCastleSpell[$LB], $config, "search", "cmbABWaitForCastleSpell", "0")
#Cs
		;SmartZap
		$ichkSmartZap = IniRead($config, "SmartZap", "UseSmartZap", "0")
		$ichkSmartZapDB = IniRead($config, "SmartZap", "ZapDBOnly", "1")
		$ichkSmartZapSaveHeroes = IniRead($config, "SmartZap", "THSnipeSaveHeroes", "1")
		$itxtMinDE = IniRead($config, "SmartZap", "MinDE", "250")
		$ichkNoobZap = IniRead($config, "SmartZap", "UseNoobZap", "0")
		$itxtExpectedDE = IniRead($config, "SmartZap", "ExpectedDE", "95")
#Ce
	Else
		Return False
	EndIf

EndFunc   ;==>readConfig
