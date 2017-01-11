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

		IniReadS($iTownHallLevel, $building, "other", "LevelTownHall", 0, "int")

		If $locationsInvalid = False Then
			IniReadS($TownHallPos[0], $building, "other", "xTownHall", -1, "int")
			IniReadS($TownHallPos[1], $building, "other", "yTownHall", -1, "int")

			IniReadS($aCCPos[0], $building, "other", "xCCPos", -1, "int")
			IniReadS($aCCPos[1], $building, "other", "yCCPos", -1, "int")

			IniReadS($barrackPos[0][0], $building, "other", "xBarrack1", -1, "int")
			IniReadS($barrackPos[0][1], $building, "other", "yBarrack1", -1, "int")

			IniReadS($barrackPos[1][0], $building, "other", "xBarrack2", -1, "int")
			IniReadS($barrackPos[1][1], $building, "other", "yBarrack2", -1, "int")

			IniReadS($barrackPos[2][0], $building, "other", "xBarrack3", -1, "int")
			IniReadS($barrackPos[2][1], $building, "other", "yBarrack3", -1, "int")

			IniReadS($barrackPos[3][0], $building, "other", "xBarrack4", -1, "int")
			IniReadS($barrackPos[3][1], $building, "other", "yBarrack4", -1, "int")

			IniReadS($SFPos[0], $building, "other", "xspellfactory", -1, "int")
			IniReadS($SFPos[1], $building, "other", "yspellfactory", -1, "int")

			IniReadS($DSFPos[0], $building, "other", "xDspellfactory", -1, "int")
			IniReadS($DSFPos[1], $building, "other", "yDspellfactory", -1, "int")

			IniReadS($KingAltarPos[0], $building, "other", "xKingAltarPos", -1, "int")
			IniReadS($KingAltarPos[1], $building, "other", "yKingAltarPos", -1, "int")

			IniReadS($QueenAltarPos[0], $building, "other", "xQueenAltarPos", -1, "int")
			IniReadS($QueenAltarPos[1], $building, "other", "yQueenAltarPos", -1, "int")

			IniReadS($WardenAltarPos[0], $building, "other", "xWardenAltarPos", -1, "int")
			IniReadS($WardenAltarPos[1], $building, "other", "yWardenAltarPos", -1, "int")

			IniReadS($aLabPos[0], $building, "upgrade", "LabPosX", -1, "int")
			IniReadS($aLabPos[1], $building, "upgrade", "LabPosY", -1, "int")
		EndIf

		IniReadS($ArmyPos[0], $building, "other", "xArmy", -1, "int")
		IniReadS($ArmyPos[0], $building, "other", "yArmy", -1, "int")

		IniReadS($TotalCamp, $building, "other", "totalcamp", 0, "int")
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
			$ichkbxUpgrade[$iz] = Int(IniRead($building, "upgrade", "upgradechk" & $iz, 0))
			$ichkUpgrdeRepeat[$iz] = Int(IniRead($building, "upgrade", "upgraderepeat" & $iz, 0))
			$ipicUpgradeStatus[$iz] = IniRead($building, "upgrade", "upgradestatusicon" & $iz, $eIcnTroops)

			If $locationsInvalid = True Then
				$aUpgrades[$iz][0] = -1
				$aUpgrades[$iz][1] = -1
				$ichkbxUpgrade[$iz] = 0
				$ichkUpgrdeRepeat[$iz] = 0
			EndIf
		Next

		InireadS($ichkLab, $building, "upgrade", "upgradetroops", 0, "int")
		InireadS($icmbLaboratory, $building, "upgrade", "upgradetroopname", 0, "int")
		$sLabUpgradeTime = IniRead($building, "upgrade", "upgradelabtime", "")

	EndIf

	If FileExists($config) Then

		SetDebugLog("Read Config " & $config)

		;General Settings--------------------------------------------------------------------------
		;IniReadS($icmbProfile,$config, "general", "cmbProfile", 01, "int")?
		IniReadS($frmBotPosX, $config, "general", "frmBotPosX", -1, "int")
		IniReadS($frmBotPosY, $config, "general", "frmBotPosY", -1, "int")
		If $frmBotPosX < -30000 Or $frmBotPosY < -30000 Then
			; bot window was minimized, restore default position
			$frmBotPosX = -1
			$frmBotPosY = -1
		EndIf
		IniReadS($AndroidPosX, $config, "general", "AndroidPosX", -1, "int")
		IniReadS($AndroidPosY, $config, "general", "AndroidPosY", -1, "int")
		If $AndroidPosX < -30000 Or $AndroidPosY < -30000 Then
			; bot window was minimized, restore default position
			$AndroidPosX = -1
			$AndroidPosY = -1
		EndIf
		IniReadS($frmBotDockedPosX, $config, "general", "frmBotDockedPosX", -1, "int")
		IniReadS($frmBotDockedPosY, $config, "general", "frmBotDockedPosY", -1, "int")
		If $frmBotDockedPosX < -30000 Or $frmBotDockedPosY < -30000 Then
			; bot window was minimized, restore default position
			$frmBotDockedPosX = -1
			$frmBotDockedPosY = -1
		EndIf
		; $iUpdatingWhenMinimized must be always enabled
		;IniReadS($iUpdatingWhenMinimized, $config, "general", "UpdatingWhenMinimized", $iUpdatingWhenMinimized)
		IniReadS($iHideWhenMinimized, $config, "general", "HideWhenMinimized", $iHideWhenMinimized)

		IniReadS($iVillageName, $config, "general", "villageName", "")

		IniReadS($iCmbLog, $config, "general", "logstyle", 0, "int")
		IniReadS($iDividerY, $config, "general", "LogDividerY", 243, "int")

		IniReadS($ichkAutoStart, $config, "general", "AutoStart", 0, "int")
		IniReadS($ichkAutoStartDelay, $config, "general", "AutoStartDelay", 10, "int")
		IniReadS($restarted, $config, "general", "Restarted", $restarted, "int")
		If $bBotLaunchOption_Autostart = True Then $restarted = 1
		IniReadS($ichkBackground, $config, "general", "Background", 1, "int")
		IniReadS($ichkBotStop, $config, "general", "BotStop", 0, "int")
		IniReadS($icmbBotCommand, $config, "general", "Command", 0, "int")
		IniReadS($icmbBotCond, $config, "general", "Cond", 0, "int")
		IniReadS($icmbHoursStop, $config, "general", "Hour", 0, "int")

		IniReadS($iDisposeWindows, $config, "general", "DisposeWindows", 0, "int")
		IniReadS($icmbDisposeWindowsPos, $config, "general", "DisposeWindowsPos", "SNAP-TR")
		;InireadS($iUseOldOCR,$config, "general", "UseOldOCR", 0, "int")

		IniReadS($AlertSearch, $config, "general", "AlertSearch", 0, "int")

		IniReadS($ichkAttackNow, $config, "general", "AttackNow", 0, "int")
		IniReadS($iAttackNowDelay, $config, "general", "attacknowdelay", 3, "int")

		IniReadS($ichkbtnScheduler, $config, "general", "BtnScheduler", 0, "int")

		; 0 = disabled, 1 = Redraw always entire bot window, 2 = Redraw only required bot window area (or entire bot if control not specified)
		IniReadS($RedrawBotWindowMode, $config, "general", "RedrawBotWindowMode", 2, "int")

		;Upgrades
		IniReadS($ichkUpgradeKing, $config, "upgrade", "UpgradeKing", 0, "int")
		IniReadS($ichkUpgradeQueen, $config, "upgrade", "UpgradeQueen", 0, "int")
		IniReadS($ichkUpgradeWarden, $config, "upgrade", "UpgradeWarden", 0, "int")
		IniReadS($itxtUpgrMinGold, $config, "upgrade", "minupgrgold", 100000, "int")
		IniReadS($itxtUpgrMinElixir, $config, "upgrade", "minupgrelixir", 100000, "int")
		IniReadS($itxtUpgrMinDark, $config, "upgrade", "minupgrdark", 2000, "int")
		IniReadS($ichkWalls, $config, "upgrade", "auto-wall", 0, "int")
		IniReadS($iSaveWallBldr, $config, "upgrade", "savebldr", 0, "int")
		IniReadS($iUseStorage, $config, "upgrade", "use-storage", 0, "int")
		IniReadS($icmbWalls, $config, "upgrade", "walllvl", 6, "int")
		; IniReadS($iMaxNbWall, $config, "upgrade", "MaxNbWall", 8, "int")
		IniReadS($itxtWallMinGold, $config, "upgrade", "minwallgold", 0, "int")
		IniReadS($itxtWallMinElixir, $config, "upgrade", "minwallelixir", 0, "int")
		IniReadS($WallCost, $config, "upgrade", "WallCost", 0, "int")

		IniReadS($itxtWall04ST, $config, "Walls", "Wall04", 0, "int")
		IniReadS($itxtWall05ST, $config, "Walls", "Wall05", 0, "int")
		IniReadS($itxtWall06ST, $config, "Walls", "Wall06", 0, "int")
		IniReadS($itxtWall07ST, $config, "Walls", "Wall07", 0, "int")
		IniReadS($itxtWall08ST, $config, "Walls", "Wall08", 0, "int")
		IniReadS($itxtWall09ST, $config, "Walls", "Wall09", 0, "int")
		IniReadS($itxtWall10ST, $config, "Walls", "Wall10", 0, "int")
		IniReadS($itxtWall11ST, $config, "Walls", "Wall11", 0, "int")
		IniReadS($itxtWall12ST, $config, "Walls", "Wall12", 0, "int")

		IniReadS($itxtRestartGold, $config, "other", "minrestartgold", 50000, "int")
		IniReadS($itxtRestartElixir, $config, "other", "minrestartelixir", 50000, "int")
		IniReadS($itxtRestartDark, $config, "other", "minrestartdark", 500, "int")


		;======================================================================================================================
		; Army training - Troop Settings-------------------------------------------------------
		IniReadS($iCmbTroopComp, $config, "troop", "TroopComposition", 9, "int")
		IniReadS($icmbDarkTroopComp, $config, "troop", "DarkTroopComposition", 2, "int")
		IniReadS($iTrainArchersToFitCamps, $config, "troop", "TrainArchersToFitCamps", 1, "int")

		IniReadS($iChkUseQuickTrain, $config, "troop", "UseQuickTrain", 0, "int")
		IniReadS($iCmbCurrentArmy, $config, "troop", "CurrentArmy", 1, "int")

		IniReadS($iChkQuickArmy1, $config, "troop", "QuickTrain1", 1, "int")
		IniReadS($iChkQuickArmy2, $config, "troop", "QuickTrain2", 0, "int")
		IniReadS($iChkQuickArmy3, $config, "troop", "QuickTrain3", 0, "int")

		Local $tempTroop, $tempLevTroop
		For $T = 0 To UBound($TroopName) - 1
			Switch $TroopName[$T]
				Case "Barb"
					IniReadS($tempTroop, $config, "troop", $TroopName[$T], 58, "int")
					IniReadS($tempLevTroop, $config, "LevelTroop", $TroopName[$T], 1, "int")
				Case "Arch"
					IniReadS($tempTroop, $config, "troop", $TroopName[$T], 115, "int")
					IniReadS($tempLevTroop, $config, "LevelTroop", $TroopName[$T], 1, "int")
				Case "Gobl"
					IniReadS($tempTroop, $config, "troop", $TroopName[$T], 19, "int")
					IniReadS($tempLevTroop, $config, "LevelTroop", $TroopName[$T], 1, "int")
				Case "Giant"
					IniReadS($tempTroop, $config, "troop", $TroopName[$T], 4, "int")
					IniReadS($tempLevTroop, $config, "LevelTroop", $TroopName[$T], 1, "int")
				Case "Wall"
					IniReadS($tempTroop, $config, "troop", $TroopName[$T], 4, "int")
					IniReadS($tempLevTroop, $config, "LevelTroop", $TroopName[$T], 1, "int")
				Case Else
					IniReadS($tempTroop, $config, "troop", $TroopName[$T], 0, "int")
					IniReadS($tempLevTroop, $config, "LevelTroop", $TroopName[$T], 0, "int")
			EndSwitch
			Assign($TroopName[$T] & "Comp", $tempTroop)
			Assign("itxtLev" & $TroopName[$T], $tempLevTroop)
		Next
		Local $tempSpell, $tempLevSpell
		For $S = 0 To (UBound($SpellName) - 1)
			IniReadS($tempSpell, $config, "Spells", $SpellName[$S], 0, "int")
			Assign($SpellName[$S] & "Comp", $tempSpell)
			IniReadS($tempLevSpell, $config, "LevelSpell", $SpellName[$S], 0, "int")
			Assign("itxtLev" & $SpellName[$S], $tempLevSpell)
		Next

		For $i = 0 To 3 ;Covers all 4 Barracks
			IniReadS($barrackTroop[$i], $config, "troop", "troop" & $i + 1, 0, "int")
		Next

		For $i = 0 To 1 ;Covers all 2 Barracks
			IniReadS($darkBarrackTroop[$i], $config, "troop", "Darktroop" & $i + 1, 0, "int")
		Next

		IniReadS($fulltroop, $config, "troop", "fullTroop", 100, "int")

		IniReadS($isldTrainITDelay, $config, "other", "TrainITDelay", 40, "int")

		IniReadS($ichkCloseWaitEnable, $config, "other", "chkCloseWaitEnable", 1, "int")
		IniReadS($ichkCloseWaitTrain, $config, "other", "chkCloseWaitTrain", 0, "int")
		IniReadS($ibtnCloseWaitStop, $config, "other", "btnCloseWaitStop", 0, "int")
		IniReadS($ibtnCloseWaitStopRandom, $config, "other", "btnCloseWaitStopRandom", 0, "int")
		IniReadS($ibtnCloseWaitExact, $config, "other", "btnCloseWaitExact", 0, "int")
		IniReadS($ibtnCloseWaitRandom, $config, "other", "btnCloseWaitRandom", 1, "int")
		IniReadS($icmbCloseWaitRdmPercent, $config, "other", "CloseWaitRdmPercent", 10, "int")
		IniReadS($icmbMinimumTimeClose, $config, "other", "MinimumTimeToClose", 2, "int")

		IniReadS($ichkTroopOrder, $config, "troop", "chkTroopOrder", 0, "int")
		For $z = 0 To UBound($DefaultTroopGroup) -1
			IniReadS($icmbTroopOrder[$z], $config, "troop", "cmbTroopOrder" & $z, $z)
		Next

		; IniReadS($ichkDarkTroopOrder, $config, "troop", "chkDarkTroopOrder", 0, "int")
		; For $z = 0 To UBound($DefaultTroopGroupDark) -1
			; IniReadS($icmbDarkTroopOrder[$z], $config, "troop", "cmbDarkTroopOrder" & $z, -1, "int")
		; Next

		;Level Troops
		; IniReadS($itxtLevBarb, $config, "LevelTroop", "Barb", 0, "int")
		; IniReadS($itxtLevArch, $config, "LevelTroop", "Arch", 0, "int")
		; IniReadS($itxtLevGobl, $config, "LevelTroop", "Gobl", 0, "int")
		; IniReadS($itxtLevGiant, $config, "LevelTroop", "Giant", 0, "int")
		; IniReadS($itxtLevWall, $config, "LevelTroop", "Wall", 0, "int")
		; IniReadS($itxtLevHeal, $config, "LevelTroop", "Heal", 0, "int")
		; IniReadS($itxtLevPekk, $config, "LevelTroop", "Pekk", 0, "int")
		; IniReadS($itxtLevBall, $config, "LevelTroop", "Ball", 0, "int")
		; IniReadS($itxtLevWiza, $config, "LevelTroop", "Wiza", 0, "int")
		; IniReadS($itxtLevDrag, $config, "LevelTroop", "Drag", 0, "int")
		; IniReadS($itxtLevBabyD, $config, "LevelTroop", "BabyD", 0, "int")
		; IniReadS($itxtLevMine, $config, "LevelTroop", "Mine", 0, "int")
		; IniReadS($itxtLevMini, $config, "LevelTroop", "Mini", 0, "int")
		; IniReadS($itxtLevHogs, $config, "LevelTroop", "Hogs", 0, "int")
		; IniReadS($itxtLevValk, $config, "LevelTroop", "Valk", 0, "int")
		; IniReadS($itxtLevGole, $config, "LevelTroop", "Gole", 0, "int")
		; IniReadS($itxtLevWitc, $config, "LevelTroop", "Witc", 0, "int")
		; IniReadS($itxtLevLava, $config, "LevelTroop", "Lava", 0, "int")
		; IniReadS($itxtLevBowl, $config, "LevelTroop", "Bowl", 0, "int")

		;Army training - Spells Creation  -----------------------------------------------------
		; Local $tempQtaSpell
		; IniReadS($LSpellComp, $config, "Spells", "LightningSpell", 0, "int")
		; IniReadS($RSpellComp, $config, "Spells", "RageSpell", 0, "int")
		; IniReadS($HSpellComp, $config, "Spells", "HealSpell", 0, "int")
		; IniReadS($JSpellComp, $config, "Spells", "JumpSpell", 0, "int")
		; IniReadS($FSpellComp, $config, "Spells", "FreezeSpell", 0, "int")
		; IniReadS($CSpellComp, $config, "Spells", "CloneSpell", 0, "int")
		; IniReadS($PSpellComp, $config, "Spells", "PoisonSpell", 0, "int")
		; IniReadS($HaSpellComp, $config, "Spells", "HasteSpell", 0, "int")
		; IniReadS($ESpellComp, $config, "Spells", "EarthSpell", 0, "int")
		; IniReadS($SkSpellComp, $config, "Spells", "SkeletonSpell", 0, "int")
		IniReadS($iTotalCountSpell, $config, "Spells", "SpellFactory", 0, "int")
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
		; IniReadS($itxtLevLSpell, $config, "LevelSpell", "Lightning", 0, "int")
		; IniReadS($itxtLevHSpell, $config, "LevelSpell", "Heal", 0, "int")
		; IniReadS($itxtLevRSpell, $config, "LevelSpell", "Rage", 0, "int")
		; IniReadS($itxtLevJSpell, $config, "LevelSpell", "JumpSpell", 0, "int")
		; IniReadS($itxtLevFSpell, $config, "LevelSpell", "Freeze", 0, "int")
		; IniReadS($itxtLevCSpell, $config, "LevelSpell", "Clone", 0, "int")
		; IniReadS($itxtLevPSpell, $config, "LevelSpell", "Poison", 0, "int")
		; IniReadS($itxtLevESpell, $config, "LevelSpell", "Earthquake", 0, "int")
		; IniReadS($itxtLevHaSpell, $config, "LevelSpell", "Haste", 0, "int")
		; IniReadS($itxtLevSkSpell, $config, "LevelSpell", "Skeleton", 0, "int")

		;======================================================================================================================
		;Search Settings------------------------------------------------------------------------

		IniReadS($iChkEnableAfter[$DB], $config, "search", "DBEnableAfter", 0, "int")
		IniReadS($iCmbMeetGE[$DB], $config, "search", "DBMeetGE", 1, "int")
		IniReadS($iChkMeetDE[$DB], $config, "search", "DBMeetDE", 0, "int")
		IniReadS($iChkMeetTrophy[$DB], $config, "search", "DBMeetTrophy", 0, "int")
		IniReadS($iChkMeetTH[$DB], $config, "search", "DBMeetTH", 0, "int")
		IniReadS($iChkMeetTHO[$DB], $config, "search", "DBMeetTHO", 0, "int")
		IniReadS($iChkMeetOne[$DB], $config, "search", "DBMeetOne", 0, "int")

		IniReadS($iEnableAfterCount[$DB], $config, "search", "DBEnableAfterCount", 1, "int")
		IniReadS($iEnableBeforeCount[$DB], $config, "search", "DBEnableBeforeCount", 9999, "int")
		IniReadS($iEnableAfterTropies[$DB], $config, "search", "DBEnableAfterTropies", 100, "int")
		IniReadS($iEnableBeforeTropies[$DB], $config, "search", "DBEnableBeforeTropies", 6000, "int")
		IniReadS($iEnableAfterArmyCamps[$DB], $config, "search", "DBEnableAfterArmyCamps", 100, "int")
		IniReadS($iMinGold[$DB], $config, "search", "DBsearchGold", 80000, "int")
		IniReadS($iMinElixir[$DB], $config, "search", "DBsearchElixir", 80000, "int")
		IniReadS($iMinGoldPlusElixir[$DB], $config, "search", "DBsearchGoldPlusElixir", 160000, "int")
		IniReadS($iMinDark[$DB], $config, "search", "DBsearchDark", 0, "int")
		IniReadS($iMinTrophy[$DB], $config, "search", "DBsearchTrophy", 0, "int")
		IniReadS($iCmbTH[$DB], $config, "search", "DBTHLevel", 0, "int")

		IniReadS($iCmbWeakMortar[$DB], $config, "search", "DBWeakMortar", 5, "int")
		IniReadS($iCmbWeakWizTower[$DB], $config, "search", "DBWeakWizTower", 4, "int")
		IniReadS($iCmbWeakAirDefense[$DB], $config, "search", "DBWeakAirDefense", 7, "int")
		IniReadS($iCmbWeakXBow[$DB], $config, "search", "DBWeakXBow", 4, "int")
		IniReadS($iCmbWeakInferno[$DB], $config, "search", "DBWeakInferno", 1, "int")
		IniReadS($iCmbWeakEagle[$DB], $config, "search", "DBWeakEagle", 2, "int")
		IniReadS($iChkMaxMortar[$DB], $config, "search", "DBCheckMortar", 0, "int")
		IniReadS($iChkMaxWizTower[$DB], $config, "search", "DBCheckWizTower", 0, "int")
		IniReadS($iChkMaxAirDefense[$DB], $config, "search", "DBCheckAirDefense", 0, "int")
		IniReadS($iChkMaxXBow[$DB], $config, "search", "DBCheckXBow", 0, "int")
		IniReadS($iChkMaxInferno[$DB], $config, "search", "DBCheckInferno", 0, "int")
		IniReadS($iChkMaxEagle[$DB], $config, "search", "DBCheckEagle", 0, "int")

		IniReadS($iChkEnableAfter[$LB], $config, "search", "ABEnableAfter", 0, "int")
		IniReadS($iCmbMeetGE[$LB], $config, "search", "ABMeetGE", 2, "int")
		IniReadS($iChkMeetDE[$LB], $config, "search", "ABMeetDE", 0, "int")
		IniReadS($iChkMeetTrophy[$LB], $config, "search", "ABMeetTrophy", 0, "int")
		IniReadS($iChkMeetTH[$LB], $config, "search", "ABMeetTH", 0, "int")
		IniReadS($iChkMeetTHO[$LB], $config, "search", "ABMeetTHO", 0, "int")
		IniReadS($iChkMeetOne[$LB], $config, "search", "ABMeetOne", 0, "int")

		IniReadS($iEnableAfterCount[$LB], $config, "search", "ABEnableAfterCount", 1, "int")
		IniReadS($iEnableBeforeCount[$LB], $config, "search", "ABEnableBeforeCount", 9999, "int")
		IniReadS($iEnableAfterTropies[$LB], $config, "search", "ABEnableAfterTropies", 100, "int")
		IniReadS($iEnableBeforeTropies[$LB], $config, "search", "ABEnableBeforeTropies", 6000, "int")
		IniReadS($iEnableAfterArmyCamps[$LB], $config, "search", "ABEnableAfterArmyCamps", 100, "int")

		IniReadS($iMinGold[$LB], $config, "search", "ABsearchGold", 80000, "int")
		IniReadS($iMinElixir[$LB], $config, "search", "ABsearchElixir", 80000, "int")
		IniReadS($iMinGoldPlusElixir[$LB], $config, "search", "ABsearchGoldPlusElixir", 160000, "int")
		IniReadS($iMinDark[$LB], $config, "search", "ABsearchDark", 0, "int")
		IniReadS($iMinTrophy[$LB], $config, "search", "ABsearchTrophy", 0, "int")
		IniReadS($iCmbTH[$LB], $config, "search", "ABTHLevel", 0, "int")

		IniReadS($iCmbWeakMortar[$LB], $config, "search", "ABWeakMortar", 5, "int")
		IniReadS($iCmbWeakWizTower[$LB], $config, "search", "ABWeakWizTower", 4, "int")
		IniReadS($iCmbWeakAirDefense[$LB], $config, "search", "ABWeakAirDefense", 7, "int")
		IniReadS($iCmbWeakXBow[$LB], $config, "search", "ABWeakXBow", 4, "int")
		IniReadS($iCmbWeakInferno[$LB], $config, "search", "ABWeakInferno", 1, "int")
		IniReadS($iCmbWeakEagle[$LB], $config, "search", "ABWeakEagle", 2, "int")
		IniReadS($iChkMaxMortar[$LB], $config, "search", "ABCheckMortar", 0, "int")
		IniReadS($iChkMaxWizTower[$LB], $config, "search", "ABCheckWizTower", 0, "int")
		IniReadS($iChkMaxAirDefense[$LB], $config, "search", "ABCheckAirDefense", 0, "int")
		IniReadS($iChkMaxXBow[$LB], $config, "search", "ABCheckXBow", 0, "int")
		IniReadS($iChkMaxInferno[$LB], $config, "search", "ABCheckInferno", 0, "int")
		IniReadS($iChkMaxEagle[$LB], $config, "search", "ABCheckEagle", 0, "int")

		IniReadS($iChkSearchReduction, $config, "search", "reduction", 0, "int")
		IniReadS($ReduceCount, $config, "search", "reduceCount", 20, "int")
		IniReadS($ReduceGold, $config, "search", "reduceGold", 2000, "int")
		IniReadS($ReduceElixir, $config, "search", "reduceElixir", 2000, "int")
		IniReadS($ReduceGoldPlusElixir, $config, "search", "reduceGoldPlusElixir", 4000, "int")
		IniReadS($ReduceDark, $config, "search", "reduceDark", 100, "int")
		IniReadS($ReduceTrophy, $config, "search", "reduceTrophy", 2, "int")

		IniReadS($iChkRestartSearchLimit, $config, "search", "ChkRestartSearchLimit", 1, "int")
		IniReadS($iRestartSearchlimit, $config, "search", "RestartSearchLimit", 50, "int")

		IniReadS($iDBcheck, $config, "search", "DBcheck", 1, "int")
		IniReadS($iABcheck, $config, "search", "ABcheck", 0, "int")
		IniReadS($iTScheck, $config, "search", "TScheck", 0, "int")

		IniReadS($iEnableSearchSearches[$DB], $config, "search", "ChkDBSearchSearches", 1, "int")
		IniReadS($iEnableSearchSearches[$LB], $config, "search", "ChkABSearchSearches", 0, "int")
		IniReadS($iEnableSearchSearches[$TS], $config, "search", "ChkTSSearchSearches", 0, "int")
		IniReadS($iEnableSearchTropies[$DB], $config, "search", "ChkDBSearchTropies", 0, "int")
		IniReadS($iEnableSearchTropies[$LB], $config, "search", "ChkABSearchTropies", 0, "int")
		IniReadS($iEnableSearchTropies[$TS], $config, "search", "ChkTSSearchTropies", 0, "int")
		IniReadS($iEnableSearchCamps[$DB], $config, "search", "ChkDBSearchCamps", 0, "int")
		IniReadS($iEnableSearchCamps[$LB], $config, "search", "ChkABSearchCamps", 0, "int")
		IniReadS($iEnableSearchCamps[$TS], $config, "search", "ChkTSSearchCamps", 0, "int")

		IniReadS($OptBullyMode, $config, "search", "BullyMode", 0, "int")
		IniReadS($ATBullyMode, $config, "search", "ATBullyMode", 0, "int")
		IniReadS($YourTH, $config, "search", "YourTH", 0, "int")
		IniReadS($iTHBullyAttackMode, $config, "search", "THBullyAttackMode", 0, "int")

		IniReadS($THaddtiles, $config, "search", "THaddTiles", 2, "int")

		IniReadS($iEnableAfterCount[$TS], $config, "search", "TSEnableAfterCount", 1, "int")
		IniReadS($iEnableBeforeCount[$TS], $config, "search", "TSEnableBeforeCount", 9999, "int")
		IniReadS($iEnableAfterTropies[$TS], $config, "search", "TSEnableAfterTropies", 100, "int")
		IniReadS($iEnableBeforeTropies[$TS], $config, "search", "TSEnableBeforeTropies", 6000, "int")
		IniReadS($iEnableAfterArmyCamps[$TS], $config, "search", "TSEnableAfterArmyCamps", 100, "int")
		IniReadS($iMinGold[$TS], $config, "search", "TSsearchGold", 80000, "int")
		IniReadS($iMinElixir[$TS], $config, "search", "TSsearchElixir", 80000, "int")
		IniReadS($iMinGoldPlusElixir[$TS], $config, "search", "TSsearchGoldPlusElixir", 160000, "int")
		IniReadS($iMinDark[$TS], $config, "search", "TSsearchDark", 600, "int")
		IniReadS($iCmbMeetGE[$TS], $config, "search", "TSMeetGE", 1, "int")

		IniReadS($iChkTrophyRange, $config, "search", "TrophyRange", 0, "int")
		IniReadS($itxtdropTrophy, $config, "search", "MinTrophy", 5000, "int")
		IniReadS($itxtMaxTrophy, $config, "search", "MaxTrophy", 5000, "int")
		IniReadS($iChkTrophyHeroes, $config, "search", "chkTrophyHeroes", 0, "int")
		IniReadS($iCmbTrophyHeroesPriority, $config, "search", "cmbTrophyHeroesPriority", 0, "int")
		IniReadS($iChkTrophyAtkDead, $config, "search", "chkTrophyAtkDead", 0, "int")
		IniReadS($itxtDTArmyMin, $config, "search", "DTArmyMin", 70, "int")

		IniReadS($itxtSWTtiles, $config, "search", "SWTtiles", 1, "int")

		IniReadS($iDeadBaseDisableCollectorsFilter,$config, "search", "chkDisableCollectorsFilter", 0, "int")
		;======================================================================================================================
		;Attack Basics Settings-------------------------------------------------------------------------
		IniReadS($iAtkAlgorithm[$DB], $config, "attack", "DBAtkAlgorithm", 0, "int")
		IniReadS($iAtkAlgorithm[$LB], $config, "attack", "ABAtkAlgorithm", 0, "int")
		IniReadS($iChkDeploySettings[$DB], $config, "attack", "DBDeploy", 3, "int")
		IniReadS($iCmbUnitDelay[$DB], $config, "attack", "DBUnitD", 4, "int")
		IniReadS($iCmbWaveDelay[$DB], $config, "attack", "DBWaveD", 4, "int")
		IniReadS($iChkRandomspeedatk[$DB], $config, "attack", "DBRandomSpeedAtk", 1, "int")

		IniReadS($iChkDeploySettings[$LB], $config, "attack", "ABDeploy", 0, "int")
		IniReadS($iCmbUnitDelay[$LB], $config, "attack", "ABUnitD", 4, "int")
		IniReadS($iCmbWaveDelay[$LB], $config, "attack", "ABWaveD", 4, "int")
		IniReadS($iChkRandomspeedatk[$LB], $config, "attack", "ABRandomSpeedAtk", 1, "int")

		IniReadS($iCmbSelectTroop[$DB], $config, "attack", "DBSelectTroop", 0, "int")
		IniReadS($iCmbSelectTroop[$LB], $config, "attack", "ABSelectTroop", 0, "int")
		IniReadS($iCmbSelectTroop[$TS], $config, "attack", "TSSelectTroop", 0, "int")

		IniReadS($iChkRedArea[$DB], $config, "attack", "DBSmartAttackRedArea", 1, "int")

		IniReadS($iCmbSmartDeploy[$DB], $config, "attack", "DBSmartAttackDeploy", 0, "int")

		IniReadS($iChkSmartAttack[$DB][0], $config, "attack", "DBSmartAttackGoldMine", 0, "int")
		IniReadS($iChkSmartAttack[$DB][1], $config, "attack", "DBSmartAttackElixirCollector", 0, "int")
		IniReadS($iChkSmartAttack[$DB][2], $config, "attack", "DBSmartAttackDarkElixirDrill", 0, "int")

		IniReadS($iChkRedArea[$LB], $config, "attack", "ABSmartAttackRedArea", 1, "int")
		IniReadS($iCmbSmartDeploy[$LB], $config, "attack", "ABSmartAttackDeploy", 1, "int")

		IniReadS($iChkSmartAttack[$LB][0], $config, "attack", "ABSmartAttackGoldMine", 0, "int")
		IniReadS($iChkSmartAttack[$LB][1], $config, "attack", "ABSmartAttackElixirCollector", 0, "int")
		IniReadS($iChkSmartAttack[$LB][2], $config, "attack", "ABSmartAttackDarkElixirDrill", 0, "int")

		IniReadS($KingAttack[$DB], $config, "attack", "DBKingAtk", 0, "int")
		IniReadS($KingAttack[$LB], $config, "attack", "ABKingAtk", 0, "int")
		IniReadS($KingAttack[$TS], $config, "attack", "TSKingAtk", 0, "int")

		IniReadS($QueenAttack[$DB], $config, "attack", "DBQueenAtk", 0, "int")
		IniReadS($QueenAttack[$LB], $config, "attack", "ABQueenAtk", 0, "int")
		IniReadS($QueenAttack[$TS], $config, "attack", "TSQueenAtk", 0, "int")

		IniReadS($iCmbStandardAlgorithm[$DB], $config, "attack", "DBStandardAlgorithm", 0, "int")
		IniReadS($iCmbStandardAlgorithm[$LB], $config, "attack", "LBStandardAlgorithm", 0, "int")

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

		IniReadS($iDropCC[$DB], $config, "attack", "DBDropCC", 0, "int")
		IniReadS($iDropCC[$LB], $config, "attack", "ABDropCC", 0, "int")
		IniReadS($iDropCC[$TS], $config, "attack", "TSDropCC", 0, "int")

		IniReadS($WardenAttack[$DB], $config, "attack", "DBWardenAtk", 0, "int")
		IniReadS($WardenAttack[$LB], $config, "attack", "ABWardenAtk", 0, "int")
		IniReadS($WardenAttack[$TS], $config, "attack", "TSWardenAtk", 0, "int")


		IniReadS($ichkLightSpell[$DB], $config, "attack", "DBLightSpell", 0, "int")
		IniReadS($ichkLightSpell[$LB], $config, "attack", "ABLightSpell", 0, "int")
		IniReadS($ichkLightSpell[$TS], $config, "attack", "TSLightSpell", 0, "int")

		IniReadS($ichkHealSpell[$DB], $config, "attack", "DBHealSpell", 0, "int")
		IniReadS($ichkHealSpell[$LB], $config, "attack", "ABHealSpell", 0, "int")
		IniReadS($ichkHealSpell[$TS], $config, "attack", "TSHealSpell", 0, "int")

		IniReadS($ichkRageSpell[$DB], $config, "attack", "DBRageSpell", 0, "int")
		IniReadS($ichkRageSpell[$LB], $config, "attack", "ABRageSpell", 0, "int")
		IniReadS($ichkRageSpell[$TS], $config, "attack", "TSRageSpell", 0, "int")

		IniReadS($ichkJumpSpell[$DB], $config, "attack", "DBJumpSpell", 0, "int")
		IniReadS($ichkJumpSpell[$LB], $config, "attack", "ABJumpSpell", 0, "int")
		IniReadS($ichkJumpSpell[$TS], $config, "attack", "TSJumpSpell", 0, "int")

		IniReadS($ichkFreezeSpell[$DB], $config, "attack", "DBFreezeSpell", 0, "int")
		IniReadS($ichkFreezeSpell[$LB], $config, "attack", "ABFreezeSpell", 0, "int")
		IniReadS($ichkFreezeSpell[$TS], $config, "attack", "TSFreezeSpell", 0, "int")

		IniReadS($ichkPoisonSpell[$DB], $config, "attack", "DBPoisonSpell", 0, "int")
		IniReadS($ichkPoisonSpell[$LB], $config, "attack", "ABPoisonSpell", 0, "int")
		IniReadS($ichkPoisonSpell[$TS], $config, "attack", "TSPoisonSpell", 0, "int")

		IniReadS($ichkEarthquakeSpell[$DB], $config, "attack", "DBEarthquakeSpell", 0, "int")
		IniReadS($ichkEarthquakeSpell[$LB], $config, "attack", "ABEarthquakeSpell", 0, "int")
		IniReadS($ichkEarthquakeSpell[$TS], $config, "attack", "TSEarthquakeSpell", 0, "int")

		IniReadS($ichkHasteSpell[$DB], $config, "attack", "DBHasteSpell", 0, "int")
		IniReadS($ichkHasteSpell[$LB], $config, "attack", "ABHasteSpell", 0, "int")
		IniReadS($ichkHasteSpell[$TS], $config, "attack", "TSHasteSpell", 0, "int")

		IniReadS($ichkCloneSpell[$DB], $config, "attack", "DBCloneSpell", 0, "int")
		IniReadS($ichkCloneSpell[$LB], $config, "attack", "ABCloneSpell", 0, "int")

		IniReadS($ichkSkeletonSpell[$DB], $config, "attack", "DBSkeletonSpell", 0, "int")
		IniReadS($ichkSkeletonSpell[$LB], $config, "attack", "ABSkeletonSpell", 0, "int")

		IniReadS($scmbDBScriptName, $config, "attack", "ScriptDB", "Barch four fingers")
		IniReadS($scmbABScriptName, $config, "attack", "ScriptAB", "Barch four fingers")

		IniReadS($iRedlineRoutine[$DB], $config, "attack", "RedlineRoutineDB", $iRedlineRoutine[$DB], "Int")
		IniReadS($iRedlineRoutine[$LB], $config, "attack", "RedlineRoutineAB", $iRedlineRoutine[$LB], "Int")
		IniReadS($iDroplineEdge[$DB], $config, "attack", "DroplineEdgeDB", $iDroplineEdge[$DB], "Int")
		IniReadS($iDroplineEdge[$LB], $config, "attack", "DroplineEdgeAB", $iDroplineEdge[$LB], "Int")

		IniReadS($iActivateKQCondition, $config, "attack", "ActivateKQ", "Auto")
		IniReadS($delayActivateKQ, $config, "attack", "delayActivateKQ", 9, "int")
		$delayActivateKQ *= 1000
		IniReadS($iActivateWardenCondition, $config, "attack", "ActivateWarden", 1, "int")
		IniReadS($delayActivateW, $config, "attack", "delayActivateW", 9, "int")
		$delayActivateW *= 1000

		IniReadS($TakeLootSnapShot, $config, "attack", "TakeLootSnapShot", 0, "int")
		IniReadS($ScreenshotLootInfo, $config, "attack", "ScreenshotLootInfo", 0, "int")



		IniReadS($scmbAttackTHType, $config, "attack", "AttackTHType", "bam")


		IniReadS($THSnipeBeforeDBEnable, $config, "attack", "THSnipeBeforeDBEnable", 0, "int")
		IniReadS($THSnipeBeforeLBEnable, $config, "attack", "THSnipeBeforeLBEnable", 0, "int")
		IniReadS($THSnipeBeforeDBTiles, $config, "attack", "THSnipeBeforeDBTiles", 0, "int")
		IniReadS($THSnipeBeforeLBTiles, $config, "attack", "THSnipeBeforeLBTiles", 0, "int")
		IniReadS($THSnipeBeforeDBScript, $config, "attack", "THSnipeBeforeDBScript", "bam")
		IniReadS($THSnipeBeforeLBScript, $config, "attack", "THSnipeBeforeLBScript", "bam")



		;MilkingAttack
		IniReadS($MilkFarmLocateMine, $config, "MilkingAttack", "LocateMine", 1, "int")
		IniReadS($MilkFarmLocateElixir, $config, "MilkingAttack", "LocateElixir", 1, "int")
		IniReadS($MilkFarmLocateDrill, $config, "MilkingAttack", "LocateDrill", 1, "int")
		Local $tempMilkFarmElixirParam
		IniReadS($tempMilkFarmElixirParam, $config, "MilkingAttack", "LocateElixirLevel", "-1|-1|-1|-1|-1|-1|2|2|2")
		$MilkFarmElixirParam = StringSplit($tempMilkFarmElixirParam, "|", 2)
		If UBound($MilkFarmElixirParam) <> 9 Then $MilkFarmElixirParam = StringSplit("-1|-1|-1|-1|-1|-1|2|2|2", "|", 2)
		IniReadS($MilkFarmMineParam, $config, "MilkingAttack", "MineParam", 5, "int")
		IniReadS($MilkFarmDrillParam, $config, "MilkingAttack", "DrillParam", 1, "int")

		IniReadS($MilkFarmAttackElixirExtractors, $config, "MilkingAttack", "AttackElixir", 1, "int")
		IniReadS($MilkFarmAttackGoldMines, $config, "MilkingAttack", "AttackMine", 1, "int")
		IniReadS($MilkFarmAttackDarkDrills, $config, "MilkingAttack", "AttackDrill", 1, "int")
		IniReadS($MilkFarmLimitGold, $config, "MilkingAttack", "LimitGold", 9950000, "int")
		IniReadS($MilkFarmLimitElixir, $config, "MilkingAttack", "LimitElixir", 9950000, "int")
		IniReadS($MilkFarmLimitDark, $config, "MilkingAttack", "LimitDark", 200000, "int")
		IniReadS($MilkFarmResMaxTilesFromBorder, $config, "MilkingAttack", "MaxTiles", 1, "int")

		IniReadS($MilkFarmTroopForWaveMin, $config, "MilkingAttack", "TroopForWaveMin", 4, "int")
		IniReadS($MilkFarmTroopForWaveMax, $config, "MilkingAttack", "TroopForWaveMax", 6, "int")
		IniReadS($MilkFarmTroopMaxWaves, $config, "MilkingAttack", "MaxWaves", 4, "int")
		IniReadS($MilkFarmDelayFromWavesMin, $config, "MilkingAttack", "DelayBetweenWavesMin", 3000, "int")
		IniReadS($MilkFarmDelayFromWavesMax, $config, "MilkingAttack", "DelayBetweenWavesMax", 5000, "int")
		IniReadS($MilkFarmForcetolerance, $config, "MilkingAttack", "MilkFarmForceTolerance", 0, "int")
		IniReadS($MilkFarmForcetolerancenormal, $config, "MilkingAttack", "MilkFarmForcetolerancenormal", 60, "int")
		IniReadS($MilkFarmForcetoleranceboosted, $config, "MilkingAttack", "MilkFarmForcetoleranceboosted", 60, "int")
		IniReadS($MilkFarmForcetolerancedestroyed, $config, "MilkingAttack", "MilkFarmForcetolerancedestroyed", 60, "int")

		IniReadS($MilkingAttackCheckStructureDestroyedBeforeAttack, $config, "MilkingAttack", "CheckStructureDestroyedBeforeAttack", 0, "int")
		IniReadS($MilkingAttackCheckStructureDestroyedAfterAttack, $config, "MilkingAttack", "CheckStructureDestroyedAfterAttack", 0, "int")

		IniReadS($MilkingAttackDropGoblinAlgorithm, $config, "MilkingAttack", "DropRandomPlace", 0, "int")

		IniReadS($MilkFarmTHMaxTilesFromBorder, $config, "MilkingAttack", "TownhallTiles", 0, "int")
		IniReadS($MilkFarmAlgorithmTh, $config, "MilkingAttack", "TownHallAlgorithm", "Bam")
		IniReadS($MilkFarmSnipeEvenIfNoExtractorsFound, $config, "MilkingAttack", "TownHallHitAnyway", 0, "int")

		IniReadS($MilkingAttackStructureOrder, $config, "MilkingAttack", "StructureOrder", 1, "int")

		IniReadS($MilkAttackAfterTHSnipe, $config, "MilkingAttack", "MilkAttackAfterTHSnipe", 0, "int")
		IniReadS($MilkAttackAfterScriptedAtk, $config, "MilkingAttack", "MilkAttackAfterScriptedAtk", 0, "int")

;~ 		IniReadS($iCmbStandardAlgorithm[$MA], $config, "MilkingAttack", "MAStandardAlgorithm", 0, "int")
;~ 		IniReadS($iChkDeploySettings[$MA], $config, "MilkingAttack", "MADeploy", 0, "int")
;~ 		IniReadS($iCmbUnitDelay[$MA], $config, "MilkingAttack", "MAUnitD", 5, "int")
;~ 		IniReadS($iCmbWaveDelay[$MA], $config, "MilkingAttack", "MAWaveD", 5, "int")
;~ 		IniReadS($iChkRandomspeedatk[$MA], $config, "MilkingAttack", "MARandomSpeedAtk", 0, "int")
;~ 		IniReadS($iChkRedArea[$MA], $config, "MilkingAttack", "MASmartAttackRedArea", 1, "int")
;~ 		IniReadS($iChkSmartAttack[$MA][0], $config, "MilkingAttack", "MASmartAttackGoldMine", 0, "int")
;~ 		IniReadS($iChkSmartAttack[$MA][1], $config, "MilkingAttack", "MASmartAttackElixirCollector", 0, "int")
;~ 		IniReadS($iChkSmartAttack[$MA][2], $config, "MilkingAttack", "MASmartAttackDarkElixirDrill", 0, "int")

		IniReadS($MilkAttackCSVscript, $config, "MilkingAttack", "MilkAttackCSVscript", "0")
		IniReadS($MilkAttackType, $config, "MilkingAttack", "MilkAttackType", 0, "int")





		;======================================================================================================================
		;End Battle Settings------------------------------------------------------------------------
		IniReadS($sTimeStopAtk[$DB], $config, "endbattle", "txtDBTimeStopAtk", 15, "int")
		IniReadS($iChkTimeStopAtk[$DB], $config, "endbattle", "chkDBTimeStopAtk", 1, "int")
		IniReadS($sTimeStopAtk2[$DB], $config, "endbattle", "txtDBTimeStopAtk2", 7, "int")
		IniReadS($iChkTimeStopAtk2[$DB], $config, "endbattle", "chkDBTimeStopAtk2", 0, "int")
		IniReadS($stxtMinGoldStopAtk2[$DB], $config, "endbattle", "txtDBMinGoldStopAtk2", 1000, "int")
		IniReadS($stxtMinElixirStopAtk2[$DB], $config, "endbattle", "txtDBMinElixirStopAtk2", 1000, "int")
		IniReadS($stxtMinDarkElixirStopAtk2[$DB], $config, "endbattle", "txtDBMinDarkElixirStopAtk2", 50, "int")
		IniReadS($ichkEndOneStar[$DB], $config, "endbattle", "chkDBEndOneStar", 0, "int")
		IniReadS($ichkEndTwoStars[$DB], $config, "endbattle", "chkDBEndTwoStars", 0, "int")
		IniReadS($ichkEndNoResources[$DB], $config, "endbattle", "chkDBEndNoResources", 0, "int")

		IniReadS($sTimeStopAtk[$LB], $config, "endbattle", "txtABTimeStopAtk", 20, "int")
		IniReadS($iChkTimeStopAtk[$LB], $config, "endbattle", "chkABTimeStopAtk", 1, "int")
		IniReadS($sTimeStopAtk2[$LB], $config, "endbattle", "txtABTimeStopAtk2", 7, "int")
		IniReadS($iChkTimeStopAtk2[$LB], $config, "endbattle", "chkABTimeStopAtk2", 0, "int")
		IniReadS($stxtMinGoldStopAtk2[$LB], $config, "endbattle", "txtABMinGoldStopAtk2", 1000, "int")
		IniReadS($stxtMinElixirStopAtk2[$LB], $config, "endbattle", "txtABMinElixirStopAtk2", 1000, "int")
		IniReadS($stxtMinDarkElixirStopAtk2[$LB], $config, "endbattle", "txtABMinDarkElixirStopAtk2", 50, "int")
		IniReadS($ichkEndOneStar[$LB], $config, "endbattle", "chkABEndOneStar", 0, "int")
		IniReadS($ichkEndTwoStars[$LB], $config, "endbattle", "chkABEndTwoStars", 0, "int")
		IniReadS($ichkEndNoResources[$LB], $config, "endbattle", "chkABEndNoResources", 0, "int")

#CS
		IniReadS($sTimeStopAtk[$TS], $config, "endbattle", "txtTSTimeStopAtk", 20, "int")
		IniReadS($iChkTimeStopAtk[$TS], $config, "endbattle", "chkTSTimeStopAtk", 1, "int")
		IniReadS($sTimeStopAtk2[$TS], $config, "endbattle", "txtTSTimeStopAtk2", 7, "int")
		IniReadS($iChkTimeStopAtk2[$TS], $config, "endbattle", "chkTSTimeStopAtk2", 0, "int")
		IniReadS($stxtMinGoldStopAtk2[$TS], $config, "endbattle", "txtTSMinGoldStopAtk2", 1000, "int")
		IniReadS($stxtMinElixirStopAtk2[$TS], $config, "endbattle", "txtTSMinElixirStopAtk2", 1000, "int")
		IniReadS($stxtMinDarkElixirStopAtk2[$TS], $config, "endbattle", "txtTSMinDarkElixirStopAtk2", 50, "int")
		IniReadS($ichkEndOneStar[$TS], $config, "endbattle", "chkTSEndOneStar", 0, "int")
		IniReadS($ichkEndTwoStars[$TS], $config, "endbattle", "chkTSEndTwoStars", 0, "int")
		IniReadS($ichkEndNoResources[$TS], $config, "endbattle", "chkTSEndNoResources", 0, "int")
#CE
		;end battle de side
		IniReadS($DESideEB, $config, "endbattle", "chkDESideEB", 0, "int")
		IniReadS($DELowEndMin, $config, "endbattle", "txtDELowEndMin", 25, "int")
		IniReadS($DisableOtherEBO, $config, "endbattle", "chkDisableOtherEBO", 0, "int")
		IniReadS($DEEndOneStar, $config, "endbattle", "chkDEEndOneStar", 0, "int")
		IniReadS($DEEndBk, $config, "endbattle", "chkDEEndBk", 0, "int")
		IniReadS($DEEndAq, $config, "endbattle", "chkDEEndAq", 0, "int")


		;======================================================================================================================
		;Attack Adv. Settings--------------------------------------------------------------------------

		IniReadS($iUnbreakableMode, $config, "Unbreakable", "chkUnbreakable", 0, "int")
		IniReadS($iUnbreakableWait, $config, "Unbreakable", "UnbreakableWait", 5, "int")
		IniReadS($iUnBrkMinGold, $config, "Unbreakable", "minUnBrkgold", 50000, "int")
		IniReadS($iUnBrkMinElixir, $config, "Unbreakable", "minUnBrkelixir", 50000, "int")
		IniReadS($iUnBrkMinDark, $config, "Unbreakable", "minUnBrkdark", 5000, "int")
		IniReadS($iUnBrkMaxGold, $config, "Unbreakable", "maxUnBrkgold", 600000, "int")
		IniReadS($iUnBrkMaxElixir, $config, "Unbreakable", "maxUnBrkelixir", 600000, "int")
		IniReadS($iUnBrkMaxDark, $config, "Unbreakable", "maxUnBrkdark", 10000, "int")

		;======================================================================================================================

		IniReadS($iChkUseCCBalanced, $config, "ClanClastle", "BalanceCC", 0, "int")
		IniReadS($iCmbCCDonated, $config, "ClanClastle", "BalanceCCDonated", 1, "int")
		IniReadS($iCmbCCReceived, $config, "ClanClastle", "BalanceCCReceived", 1, "int")

		;======================================================================================================================

		;Misc Settings--------------------------------------------------------------------------



		IniReadS($ichkTrap, $config, "other", "chkTrap", 1, "int")
		IniReadS($iChkCollect, $config, "other", "chkCollect", 1, "int")
		IniReadS($ichkTombstones, $config, "other", "chkTombstones", 1, "int")
		IniReadS($ichkCleanYard, $config, "other", "chkCleanYard", 0, "int")
		;Boju Only clear GemBox
		IniReadS($ichkGemsBox, $config, "other", "chkGemsBox", 0, "int")
		;Only clear GemBox
		IniReadS($sTimeWakeUp, $config, "other", "txtTimeWakeUp", 0, "int")
		IniReadS($iVSDelay, $config, "other", "VSDelay", 0, "Int")
		IniReadS($iMaxVSDelay, $config, "other", "MaxVSDelay", 4, "Int")

		IniReadS($iWAOffsetX, $config, "other", "WAOffsetX", "")
		IniReadS($iWAOffsetY, $config, "other", "WAOffsetY", "")

		;==============================================================
		;NOTIFY CONFIG ================================================
		;==============================================================
		;PushBullet / Telegram----------------------------------------
		IniReadS($NotifyPBToken, $config, "notify", "PBToken", "")
		IniReadS($NotifyTGToken, $config, "notify", "TGToken", "")
		IniReadS($NotifyOrigin, $config, "notify", "Origin", $sCurrProfile)

		IniReadS($NotifyAlerLastRaidTXT, $config, "notify", "AlertPBLastRaidTxt", 0, "int")
		IniReadS($NotifyPBEnabled, $config, "notify", "PBEnabled", 0, "int")
		IniReadS($NotifyTGEnabled, $config, "notify", "TGEnabled", 0, "int")
		IniReadS($NotifyRemoteEnable, $config, "notify", "PBRemote", 0, "int")
		IniReadS($NotifyDeleteAllPushesOnStart, $config, "notify", "DeleteAllPBPushes", 0, "int")
		IniReadS($NotifyAlertMatchFound, $config, "notify", "AlertPBVMFound", 0, "int")
		IniReadS($NotifyAlerLastRaidIMG, $config, "notify", "AlertPBLastRaid", 0, "int")
		IniReadS($NotifyAlertUpgradeWalls, $config, "notify", "AlertPBWallUpgrade", 0, "int")
		IniReadS($NotifyAlertOutOfSync, $config, "notify", "AlertPBOOS", 0, "int")
		IniReadS($NotifyAlertTakeBreak, $config, "notify", "AlertPBVBreak", 0, "int")
		IniReadS($NotifyAlertAnotherDevice, $config, "notify", "AlertPBOtherDevice", 0, "int")
		IniReadS($NotifyDeletePushesOlderThanHours, $config, "notify", "HoursPushBullet", 4, "int")
		IniReadS($NotifyDeletePushesOlderThan, $config, "notify", "DeleteOldPBPushes", 0, "int")
		IniReadS($NotifyAlertCampFull, $config, "notify", "AlertPBCampFull", 0, "int")
		IniReadS($NotifyAlertVillageReport, $config, "notify", "AlertPBVillage", 0, "int")
		IniReadS($NotifyAlertLastAttack, $config, "notify", "AlertPBLastAttack", 0, "int")
		IniReadS($NotifyAlertBulderIdle, $config, "notify", "AlertBuilderIdle", 0, "int")
		IniReadS($NotifyAlertMaintenance, $config, "notify", "AlertPBMaintenance", 0, "int")
		IniReadS($NotifyAlertBAN, $config, "notify", "AlertPBBAN", 0, "int")
		IniReadS($NotifyAlertBOTUpdate, $config, "notify", "AlertPBUpdate", 0, "int")

		;Schedule
		$NotifyScheduleWeekDaysEnable = Int(IniRead($config, "notify", "NotifyWeekDaysEnable", 0))
		$NotifyScheduleWeekDays = StringSplit(IniRead($config, "notify", "NotifyWeekDays", "1|1|1|1|1|1|1"),"|", $STR_NOCOUNT)
		$NotifyScheduleHoursEnable = Int(IniRead($config, "notify", "NotifyHoursEnable", 0))
		$NotifyScheduleHours = StringSplit(IniRead($config, "notify", "NotifyHours", "1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1"),"|", $STR_NOCOUNT)
		;==============================================================
		;NOTIFY CONFIG ================================================
		;==============================================================


		IniReadS($ichkDeleteLogs, $config, "deletefiles", "DeleteLogs", 1, "int")
		IniReadS($iDeleteLogsDays, $config, "deletefiles", "DeleteLogsDays", 2, "int")
		IniReadS($ichkDeleteTemp, $config, "deletefiles", "DeleteTemp", 1, "int")
		IniReadS($iDeleteTempDays, $config, "deletefiles", "DeleteTempDays", 2, "int")
		IniReadS($ichkDeleteLoots, $config, "deletefiles", "DeleteLoots", 1, "int")
		IniReadS($iDeleteLootsDays, $config, "deletefiles", "DeleteLootsDays", 2, "int")

		$DebugClick = BitOR($DebugClick, Int(IniRead($config, "debug", "debugsetclick", 0)))
		If $DevMode = 1 Then
			$DebugSetlog = BitOR($DebugSetlog, Int(IniRead($config, "debug", "debugsetlog", 0)))
			$DebugDisableZoomout = BitOR($DebugDisableZoomout, Int(IniRead($config, "debug", "disablezoomout", 0)))
			$DebugDisableVillageCentering = BitOR($DebugDisableVillageCentering, Int(IniRead($config, "debug", "disablevillagecentering", 0)))
			$DebugDeadbaseImage = BitOR($DebugDeadbaseImage, Int(IniRead($config, "debug", "debugdeadbaseimage", 0)))
			$DebugOcr = BitOR($DebugOcr, Int(IniRead($config, "debug", "debugocr", 0)))
			$DebugImageSave = BitOR($DebugImageSave, Int(IniRead($config, "debug", "debugimagesave", 0)))
			$debugBuildingPos = BitOR($debugBuildingPos, Int(IniRead($config, "debug", "debugbuildingpos", 0)))
			$debugsetlogTrain = BitOR($debugsetlogTrain, Int(IniRead($config, "debug", "debugtrain", 0)))
			$debugresourcesoffset = BitOR($debugresourcesoffset, Int(IniRead($config, "debug", "debugresourcesoffset", 0)))
			$continuesearchelixirdebug = BitOR($continuesearchelixirdebug, Int(IniRead($config, "debug", "continuesearchelixirdebug", 0)))
			$debugMilkingIMGmake = BitOR($debugMilkingIMGmake, Int(IniRead($config, "debug", "debugMilkingIMGmake", 0)))
			$debugOCRdonate = BitOR($debugOCRdonate, Int(IniRead($config, "debug", "debugOCRDonate", 0)))
			$debugAttackCSV = BitOR($debugAttackCSV, Int(IniRead($config, "debug", "debugAttackCSV", 0)))
			$makeIMGCSV = BitOR($makeIMGCSV, Int(IniRead($config, "debug", "debugmakeimgcsv", 0)))
			;InireadS(xxxx,$config, "attack", "xxxx", 0, "int")
			;InireadS(xxxx,$config, "attack", "xxxx", 0, "int")
			;InireadS(xxxx,$config, "attack", "xxxx", 0, "int")
			;InireadS(xxxx,$config, "attack", "xxxx", 0, "int")
			;InireadS(xxxx,$config, "attack", "xxxx", 0, "int")
			;InireadS(xxxx,$config, "attack", "xxxx", 0, "int")
			;InireadS(xxxx,$config, "attack", "xxxx", 0, "int")
			;InireadS(xxxx,$config, "attack", "xxxx", 0, "int")
			;InireadS(xxxx,$config, "attack", "xxxx", 0, "int")
			;InireadS(xxxx,$config, "attack", "xxxx", 0, "int")
			;InireadS(xxxx,$config, "attack", "xxxx", 0, "int")
		EndIf

		; Hours Planned
		$iPlannedDonateHours = StringSplit(IniRead($config, "planned", "DonateHours", "1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1"), "|", $STR_NOCOUNT)
		$iPlannedRequestCCHours = StringSplit(IniRead($config, "planned", "RequestHours", "1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1"), "|", $STR_NOCOUNT)
		$iPlannedDropCCHours = StringSplit(IniRead($config, "planned", "DropCCHours", "1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1"), "|", $STR_NOCOUNT)
		$iPlannedDonateHoursEnable = Int(IniRead($config, "planned", "DonateHoursEnable", 0))
		$iPlannedRequestCCHoursEnable = Int(IniRead($config, "planned", "RequestHoursEnable", 0))
		$iPlannedDropCCHoursEnable = Int(IniRead($config, "planned", "DropCCEnable", 0))
		$iPlannedBoostBarracksEnable = Int(IniRead($config, "planned", "BoostBarracksHoursEnable", 0))
		$iPlannedBoostBarracksHours = StringSplit(IniRead($config, "planned", "BoostBarracksHours", "1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1"), "|", $STR_NOCOUNT)
		$iPlannedattackHours = StringSplit(IniRead($config, "planned", "attackHours", "1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1"), "|", $STR_NOCOUNT)
		$iPlannedAttackWeekDays = StringSplit(IniRead($config, "planned", "attackDays", "1|1|1|1|1|1|1"), "|", $STR_NOCOUNT)

		$ichkAttackPlannerEnable = Int(IniRead($config, "planned", "chkAttackPlannerEnable", 0))
		$ichkAttackPlannerCloseCoC = Int(IniRead($config, "planned", "chkAttackPlannerCloseCoC", 0))
		$ichkAttackPlannerCloseAll = Int(IniRead($config, "planned", "chkAttackPlannerCloseAll", 0))
		$ichkAttackPlannerRandom = Int(IniRead($config, "planned", "chkAttackPlannerRandom", 0))
		$icmbAttackPlannerRandom = Int(IniRead($config, "planned", "cmbAttackPlannerRandom", 4))
		$ichkAttackPlannerDayLimit = Int(IniRead($config, "planned", "chkAttackPlannerDayLimit", 0))
		$icmbAttackPlannerDayMin = Int(IniRead($config, "planned", "cmbAttackPlannerDayMin", 12))
		$icmbAttackPlannerDayMax = Int(IniRead($config, "planned", "cmbAttackPlannerDayMax", 15))


		;Share Attack Settings----------------------------------------
		$iShareminGold = Int(IniRead($config, "shareattack", "minGold", 200000))
		$iShareminElixir = Int(IniRead($config, "shareattack", "minElixir", 200000))
		$iSharemindark = Int(IniRead($config, "shareattack", "minDark", 100))
		$iShareAttack = Int(IniRead($config, "shareattack", "ShareAttack", 0))
		$sShareMessage = StringReplace(IniRead($config, "shareattack", "Message", "Nice|Good|Thanks|Wowwww"), "|", @CRLF)
		;InireadS(xxxx,$config, "attack", "xxxx", 0, "int")
		;InireadS(xxxx,$config, "attack", "xxxx", 0, "int")
		;InireadS(xxxx,$config, "attack", "xxxx", 0, "int")
		;InireadS(xxxx,$config, "attack", "xxxx", 0, "int")
		;InireadS(xxxx,$config, "attack", "xxxx", 0, "int")

		;Use random click
		$iUseRandomClick = Int(IniRead($config, "other", "UseRandomClick", 0))

		;Add idle phase during training read variables from ini file
		$ichkAddIdleTime = Int(IniRead($config, "other", "chkAddIdleTime", 1))
		IniReadS($iAddIdleTimeMin, $config, "other", "txtAddDelayIdlePhaseTimeMin", $iAddIdleTimeMin)
		IniReadS($iAddIdleTimeMax, $config, "other", "txtAddDelayIdlePhaseTimeMax", $iAddIdleTimeMax)

		;screenshot type: 0 JPG   1 PNG
		$iScreenshotType = Int(IniRead($config, "other", "ScreenshotType", 0))
		;InireadS(xxxx,$config, "attack", "xxxx", 0, "int")

		$ichkScreenshotHideName = Int(IniRead($config, "other", "ScreenshotHideName", 1))
		;InireadS(xxxx,$config, "attack", "xxxx", 0, "int")

		$ichkUseQTrain = Int(IniRead($config, "other", "ChkUseQTrain", 0))
		$ichkForceBrewBeforeAttack = Int(IniRead($config, "other", "ChkForceBrewBeforeAttack", 0))

		;forced Total Camp values
		$ichkTotalCampForced = Int(IniRead($config, "other", "ChkTotalCampForced", 1))
		$iValueTotalCampForced = Int(IniRead($config, "other", "ValueTotalCampForced", 220))
		;InireadS(xxxx,$config, "attack", "xxxx", 0, "int")
		;InireadS(xxxx,$config, "attack", "xxxx", 0, "int")

		$ichkSinglePBTForced = Int(IniRead($config, "other", "chkSinglePBTForced", 0))
		$iValueSinglePBTimeForced = Int(IniRead($config, "other", "ValueSinglePBTimeForced", 18))
		$iValuePBTimeForcedExit = Int(IniRead($config, "other", "ValuePBTimeForcedExit", 15))

		$ichkLanguage = Int(IniRead($config, "General", "ChkLanguage", 1))
		$ichkDisableSplash = IniRead($config, "General", "ChkDisableSplash", $ichkDisableSplash)
		$ichkVersion = Int(IniRead($config, "General", "ChkVersion", 1))
		;InireadS(xxxx,$config, "attack", "xxxx", 0, "int")
		;InireadS(xxxx,$config, "attack", "xxxx", 0, "int")

		$ichkFixClanCastle = Int(IniRead($config, "other", "ChkFixClanCastle", 0))

		;Donate Settings-------------------------------------------------------------------------
		$sTxtRequest = IniRead($config, "donate", "txtRequest", "")
		$sSkipDonateNearFulLTroopsPercentual = IniRead($config, "donate", "SkipDonateNearFulLTroopsPercentual", 90)
		$iSkipDonateNearFulLTroopsEnable = IniRead($config, "donate", "SkipDonateNearFulLTroopsEnable", 1)
		;InireadS(xxxx,$config, "attack", "xxxx", 0, "int")

		$ichkDonateBarbarians = Int(IniRead($config, "donate", "chkDonateBarbarians", 0))
		$ichkDonateAllBarbarians = Int(IniRead($config, "donate", "chkDonateAllBarbarians", 0))
		$sTxtDonateBarbarians = StringReplace(IniRead($config, "donate", "txtDonateBarbarians", "barbarians|barbarian|barb"), "|", @CRLF)
		$sTxtBlacklistBarbarians = StringReplace(IniRead($config, "donate", "txtBlacklistBarbarians", "no barbarians|no barb|barbarian no|barb no"), "|", @CRLF)
		$aDonBarbarians = StringSplit($sTxtDonateBarbarians, @CRLF, $STR_ENTIRESPLIT)
		$aBlkBarbarians = StringSplit($sTxtBlacklistBarbarians, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateArchers = Int(IniRead($config, "donate", "chkDonateArchers", 0))
		$ichkDonateAllArchers = Int(IniRead($config, "donate", "chkDonateAllArchers", 0))
		$sTxtDonateArchers = StringReplace(IniRead($config, "donate", "txtDonateArchers", "archers|archer|arch"), "|", @CRLF)
		$sTxtBlacklistArchers = StringReplace(IniRead($config, "donate", "txtBlacklistArchers", "no archers|no arch|archer no|arch no"), "|", @CRLF)
		$aDonArchers = StringSplit($sTxtDonateArchers, @CRLF, $STR_ENTIRESPLIT)
		$aBlkArchers = StringSplit($sTxtBlacklistArchers, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateGiants = Int(IniRead($config, "donate", "chkDonateGiants", 0))
		$ichkDonateAllGiants = Int(IniRead($config, "donate", "chkDonateAllGiants", 0))
		$sTxtDonateGiants = StringReplace(IniRead($config, "donate", "txtDonateGiants", "giants|giant|any"), "|", @CRLF)
		$sTxtBlacklistGiants = StringReplace(IniRead($config, "donate", "txtBlacklistGiants", "no giants|giants no"), "|", @CRLF)
		$aDonGiants = StringSplit($sTxtDonateGiants, @CRLF, $STR_ENTIRESPLIT)
		$aBlkGiants = StringSplit($sTxtBlacklistGiants, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateGoblins = Int(IniRead($config, "donate", "chkDonateGoblins", 0))
		$ichkDonateAllGoblins = Int(IniRead($config, "donate", "chkDonateAllGoblins", 0))
		$sTxtDonateGoblins = StringReplace(IniRead($config, "donate", "txtDonateGoblins", "goblins|goblin"), "|", @CRLF)
		$sTxtBlacklistGoblins = StringReplace(IniRead($config, "donate", "txtBlacklistGoblins", "no goblins|goblins no"), "|", @CRLF)
		$aDonGoblins = StringSplit($sTxtDonateGoblins, @CRLF, $STR_ENTIRESPLIT)
		$aBlkGoblins = StringSplit($sTxtBlacklistGoblins, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateWallBreakers = Int(IniRead($config, "donate", "chkDonateWallBreakers", 0))
		$ichkDonateAllWallBreakers = Int(IniRead($config, "donate", "chkDonateAllWallBreakers", 0))
		$sTxtDonateWallBreakers = StringReplace(IniRead($config, "donate", "txtDonateWallBreakers", "wall breakers|wb"), "|", @CRLF)
		$sTxtBlacklistWallBreakers = StringReplace(IniRead($config, "donate", "txtBlacklistWallBreakers", "no wallbreakers|wb no"), "|", @CRLF)
		$aDonWallBreakers = StringSplit($sTxtDonateWallBreakers, @CRLF, $STR_ENTIRESPLIT)
		$aBlkWallBreakers = StringSplit($sTxtBlacklistWallBreakers, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateBalloons = Int(IniRead($config, "donate", "chkDonateBalloons", 0))
		$ichkDonateAllBalloons = Int(IniRead($config, "donate", "chkDonateAllBalloons", 0))
		$sTxtDonateBalloons = StringReplace(IniRead($config, "donate", "txtDonateBalloons", "balloons|balloon"), "|", @CRLF)
		$sTxtBlacklistBalloons = StringReplace(IniRead($config, "donate", "txtBlacklistBalloons", "no balloon|balloons no"), "|", @CRLF)
		$aDonBalloons = StringSplit($sTxtDonateBalloons, @CRLF, $STR_ENTIRESPLIT)
		$aBlkBalloons = StringSplit($sTxtBlacklistBalloons, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateWizards = Int(IniRead($config, "donate", "chkDonateWizards", 0))
		$ichkDonateAllWizards = Int(IniRead($config, "donate", "chkDonateAllWizards", 0))
		$sTxtDonateWizards = StringReplace(IniRead($config, "donate", "txtDonateWizards", "wizards|wizard|wiz"), "|", @CRLF)
		$sTxtBlacklistWizards = StringReplace(IniRead($config, "donate", "txtBlacklistWizards", "no wizards|wizards no|no wizard|wizard no"), "|", @CRLF)
		$aDonWizards = StringSplit($sTxtDonateWizards, @CRLF, $STR_ENTIRESPLIT)
		$aBlkWizards = StringSplit($sTxtBlacklistWizards, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateHealers = Int(IniRead($config, "donate", "chkDonateHealers", 0))
		$ichkDonateAllHealers = Int(IniRead($config, "donate", "chkDonateAllHealers", 0))
		$sTxtDonateHealers = StringReplace(IniRead($config, "donate", "txtDonateHealers", "healer"), "|", @CRLF)
		$sTxtBlacklistHealers = StringReplace(IniRead($config, "donate", "txtBlacklistHealers", "no healer|healer no"), "|", @CRLF)
		$aDonHealers = StringSplit($sTxtDonateHealers, @CRLF, $STR_ENTIRESPLIT)
		$aBlkHealers = StringSplit($sTxtBlacklistHealers, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateDragons = Int(IniRead($config, "donate", "chkDonateDragons", 0))
		$ichkDonateAllDragons = Int(IniRead($config, "donate", "chkDonateAllDragons", 0))
		$sTxtDonateDragons = StringReplace(IniRead($config, "donate", "txtDonateDragons", "dragon"), "|", @CRLF)
		$sTxtBlacklistDragons = StringReplace(IniRead($config, "donate", "txtBlacklistDragons", "no dragon|dragon no"), "|", @CRLF)
		$aDonDragons = StringSplit($sTxtDonateDragons, @CRLF, $STR_ENTIRESPLIT)
		$aBlkDragons = StringSplit($sTxtBlacklistDragons, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonatePekkas = Int(IniRead($config, "donate", "chkDonatePekkas", 0))
		$ichkDonateAllPekkas = Int(IniRead($config, "donate", "chkDonateAllPekkas", 0))
		$sTxtDonatePekkas = StringReplace(IniRead($config, "donate", "txtDonatePekkas", "PEKKA|pekka"), "|", @CRLF)
		$sTxtBlacklistPekkas = StringReplace(IniRead($config, "donate", "txtBlacklistPekkas", "no PEKKA|pekka no"), "|", @CRLF)
		$aDonPekkas = StringSplit($sTxtDonatePekkas, @CRLF, $STR_ENTIRESPLIT)
		$aBlkPekkas = StringSplit($sTxtBlacklistPekkas, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateBabyDragons = Int(IniRead($config, "donate", "chkDonateBabyDragons", 0))
		$ichkDonateAllBabyDragons = Int(IniRead($config, "donate", "chkDonateAllBabyDragons", 0))
		$sTxtDonateBabyDragons = StringReplace(IniRead($config, "donate", "txtDonateBabyDragons", "baby dragon|baby"), "|", @CRLF)
		$sTxtBlacklistBabyDragons = StringReplace(IniRead($config, "donate", "txtBlacklistBabyDragons", "no baby dragon|baby dragon no|no baby|baby no"), "|", @CRLF)
		$aDonBabyDragons = StringSplit($sTxtDonateBabyDragons, @CRLF, $STR_ENTIRESPLIT)
		$aBlkBabyDragons = StringSplit($sTxtBlacklistBabyDragons, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateMiners = Int(IniRead($config, "donate", "chkDonateMiners", 0))
		$ichkDonateAllMiners = Int(IniRead($config, "donate", "chkDonateAllMiners", 0))
		$sTxtDonateMiners = StringReplace(IniRead($config, "donate", "txtDonateMiners", "miner|mine"), "|", @CRLF)
		$sTxtBlacklistMiners = StringReplace(IniRead($config, "donate", "txtBlacklistMiners", "no miner|miner no|no mine|mine no"), "|", @CRLF)
		$aDonMiners = StringSplit($sTxtDonateMiners, @CRLF, $STR_ENTIRESPLIT)
		$aBlkMiners = StringSplit($sTxtBlacklistMiners, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateLightningSpells = Int(IniRead($config, "donate", "chkDonateLightningSpells", 0))
		$ichkDonateAllLightningSpells = Int(IniRead($config, "donate", "chkDonateAllLightningSpells", 0))
		$sTxtDonateLightningSpells = StringReplace(IniRead($config, "donate", "txtDonateLightningSpells", "lightning"), "|", @CRLF)
		$sTxtBlacklistLightningSpells = StringReplace(IniRead($config, "donate", "txtBlacklistLightningSpells", "no lightning|lightning no"), "|", @CRLF)
		$aDonLightningSpells = StringSplit($sTxtDonateLightningSpells, @CRLF, $STR_ENTIRESPLIT)
		$aBlkLightningSpells = StringSplit($sTxtBlacklistLightningSpells, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateHealSpells = Int(IniRead($config, "donate", "chkDonateHealSpells", 0))
		$ichkDonateAllHealSpells = Int(IniRead($config, "donate", "chkDonateAllHealSpells", 0))
		$sTxtDonateHealSpells = StringReplace(IniRead($config, "donate", "txtDonateHealSpells", "heal"), "|", @CRLF)
		$sTxtBlacklistHealSpells = StringReplace(IniRead($config, "donate", "txtBlacklistHealSpells", "no heal|heal no"), "|", @CRLF)
		$aDonHealSpells = StringSplit($sTxtDonateHealSpells, @CRLF, $STR_ENTIRESPLIT)
		$aBlkHealSpells = StringSplit($sTxtBlacklistHealSpells, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateRageSpells = Int(IniRead($config, "donate", "chkDonateRageSpells", 0))
		$ichkDonateAllRageSpells = Int(IniRead($config, "donate", "chkDonateAllRageSpells", 0))
		$sTxtDonateRageSpells = StringReplace(IniRead($config, "donate", "txtDonateRageSpells", "rage"), "|", @CRLF)
		$sTxtBlacklistRageSpells = StringReplace(IniRead($config, "donate", "txtBlacklistRageSpells", "no rage|rage no"), "|", @CRLF)
		$aDonRageSpells = StringSplit($sTxtDonateRageSpells, @CRLF, $STR_ENTIRESPLIT)
		$aBlkRageSpells = StringSplit($sTxtBlacklistRageSpells, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateJumpSpells = Int(IniRead($config, "donate", "chkDonateJumpSpells", 0))
		$ichkDonateAllJumpSpells = Int(IniRead($config, "donate", "chkDonateAllJumpSpells", 0))
		$sTxtDonateJumpSpells = StringReplace(IniRead($config, "donate", "txtDonateJumpSpells", "jump"), "|", @CRLF)
		$sTxtBlacklistJumpSpells = StringReplace(IniRead($config, "donate", "txtBlacklistJumpSpells", "no jump|jump no"), "|", @CRLF)
		$aDonJumpSpells = StringSplit($sTxtDonateJumpSpells, @CRLF, $STR_ENTIRESPLIT)
		$aBlkJumpSpells = StringSplit($sTxtBlacklistJumpSpells, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateFreezeSpells = Int(IniRead($config, "donate", "chkDonateFreezeSpells", 0))
		$ichkDonateAllFreezeSpells = Int(IniRead($config, "donate", "chkDonateAllFreezeSpells", 0))
		$sTxtDonateFreezeSpells = StringReplace(IniRead($config, "donate", "txtDonateFreezeSpells", "freeze"), "|", @CRLF)
		$sTxtBlacklistFreezeSpells = StringReplace(IniRead($config, "donate", "txtBlacklistFreezeSpells", "no freeze|freeze no"), "|", @CRLF)
		$aDonFreezeSpells = StringSplit($sTxtDonateFreezeSpells, @CRLF, $STR_ENTIRESPLIT)
		$aBlkFreezeSpells = StringSplit($sTxtBlacklistFreezeSpells, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateMinions = Int(IniRead($config, "donate", "chkDonateMinions", 0))
		$ichkDonateAllMinions = Int(IniRead($config, "donate", "chkDonateAllMinions", 0))
		$sTxtDonateMinions = StringReplace(IniRead($config, "donate", "txtDonateMinions", "minions|minion"), "|", @CRLF)
		$sTxtBlacklistMinions = StringReplace(IniRead($config, "donate", "txtBlacklistMinions", "no minion|minions no"), "|", @CRLF)
		$aDonMinions = StringSplit($sTxtDonateMinions, @CRLF, $STR_ENTIRESPLIT)
		$aBlkMinions = StringSplit($sTxtBlacklistMinions, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateHogRiders = Int(IniRead($config, "donate", "chkDonateHogRiders", 0))
		$ichkDonateAllHogRiders = Int(IniRead($config, "donate", "chkDonateAllHogRiders", 0))
		$sTxtDonateHogRiders = StringReplace(IniRead($config, "donate", "txtDonateHogRiders", "hogriders|hogs|hog"), "|", @CRLF)
		$sTxtBlacklistHogRiders = StringReplace(IniRead($config, "donate", "txtBlacklistHogRiders", "no hogriders|hogriders no|no hog|hogs no"), "|", @CRLF)
		$aDonHogRiders = StringSplit($sTxtDonateHogRiders, @CRLF, $STR_ENTIRESPLIT)
		$aBlkHogRiders = StringSplit($sTxtBlacklistHogRiders, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateValkyries = Int(IniRead($config, "donate", "chkDonateValkyries", 0))
		$ichkDonateAllValkyries = Int(IniRead($config, "donate", "chkDonateAllValkyries", 0))
		$sTxtDonateValkyries = StringReplace(IniRead($config, "donate", "txtDonateValkyries", "valkyries|valkyrie|valk"), "|", @CRLF)
		$sTxtBlacklistValkyries = StringReplace(IniRead($config, "donate", "txtBlacklistValkyries", "no valkyrie|valkyries no|no valk|valk no"), "|", @CRLF)
		$aDonValkyries = StringSplit($sTxtDonateValkyries, @CRLF, $STR_ENTIRESPLIT)
		$aBlkValkyries = StringSplit($sTxtBlacklistValkyries, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateGolems = Int(IniRead($config, "donate", "chkDonateGolems", 0))
		$ichkDonateAllGolems = Int(IniRead($config, "donate", "chkDonateAllGolems", 0))
		$sTxtDonateGolems = StringReplace(IniRead($config, "donate", "txtDonateGolems", "golem"), "|", @CRLF)
		$sTxtBlacklistGolems = StringReplace(IniRead($config, "donate", "txtBlacklistGolems", "no golem|golem no"), "|", @CRLF)
		$aDonGolems = StringSplit($sTxtDonateGolems, @CRLF, $STR_ENTIRESPLIT)
		$aBlkGolems = StringSplit($sTxtBlacklistGolems, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateWitches = Int(IniRead($config, "donate", "chkDonateWitches", 0))
		$ichkDonateAllWitches = Int(IniRead($config, "donate", "chkDonateAllWitches", 0))
		$sTxtDonateWitches = StringReplace(IniRead($config, "donate", "txtDonateWitches", "witches|witch"), "|", @CRLF)
		$sTxtBlacklistWitches = StringReplace(IniRead($config, "donate", "txtBlacklistWitches", "no witches|witches no|no witch|witch no"), "|", @CRLF)
		$aDonWitches = StringSplit($sTxtDonateWitches, @CRLF, $STR_ENTIRESPLIT)
		$aBlkWitches = StringSplit($sTxtBlacklistWitches, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateLavaHounds = Int(IniRead($config, "donate", "chkDonateLavaHounds", 0))
		$ichkDonateAllLavaHounds = Int(IniRead($config, "donate", "chkDonateAllLavaHounds", 0))
		$sTxtDonateLavaHounds = StringReplace(IniRead($config, "donate", "txtDonateLavaHounds", "lavahounds|lava|hound"), "|", @CRLF)
		$sTxtBlacklistLavaHounds = StringReplace(IniRead($config, "donate", "txtBlacklistLavaHounds", "no lavahound|lavahound no|no lava|lava no|nohound|hound no"), "|", @CRLF)
		$aDonLavaHounds = StringSplit($sTxtDonateLavaHounds, @CRLF, $STR_ENTIRESPLIT)
		$aBlkLavaHounds = StringSplit($sTxtBlacklistLavaHounds, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateBowlers = Int(IniRead($config, "donate", "chkDonateBowlers", 0))
		$ichkDonateAllBowlers = Int(IniRead($config, "donate", "chkDonateAllBowlers", 0))
		$sTxtDonateBowlers = StringReplace(IniRead($config, "donate", "txtDonateBowlers", "bowler|bowl"), "|", @CRLF)
		$sTxtBlacklistBowlers = StringReplace(IniRead($config, "donate", "txtBlacklistBowlers", "no bowler|bowl no"), "|", @CRLF)
		$aDonBowlers = StringSplit($sTxtDonateBowlers, @CRLF, $STR_ENTIRESPLIT)
		$aBlkBowlers = StringSplit($sTxtBlacklistBowlers, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonatePoisonSpells = Int(IniRead($config, "donate", "chkDonatePoisonSpells", 0))
		$ichkDonateAllPoisonSpells = Int(IniRead($config, "donate", "chkDonateAllPoisonSpells", 0))
		$sTxtDonatePoisonSpells = StringReplace(IniRead($config, "donate", "txtDonatePoisonSpells", "poison"), "|", @CRLF)
		$sTxtBlacklistPoisonSpells = StringReplace(IniRead($config, "donate", "txtBlacklistPoisonSpells", "no poison|poison no"), "|", @CRLF)
		$aDonPoisonSpells = StringSplit($sTxtDonatePoisonSpells, @CRLF, $STR_ENTIRESPLIT)
		$aBlkPoisonSpells = StringSplit($sTxtBlacklistPoisonSpells, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateEarthQuakeSpells = Int(IniRead($config, "donate", "chkDonateEarthQuakeSpells", 0))
		$ichkDonateAllEarthQuakeSpells = Int(IniRead($config, "donate", "chkDonateAllEarthQuakeSpells", 0))
		$sTxtDonateEarthQuakeSpells = StringReplace(IniRead($config, "donate", "txtDonateEarthQuakeSpells", "earthquake|quake"), "|", @CRLF)
		$sTxtBlacklistEarthQuakeSpells = StringReplace(IniRead($config, "donate", "txtBlacklistEarthQuakeSpells", "no earthquake|quake no"), "|", @CRLF)
		$aDonEarthQuakeSpells = StringSplit($sTxtDonateEarthQuakeSpells, @CRLF, $STR_ENTIRESPLIT)
		$aBlkEarthQuakeSpells = StringSplit($sTxtBlacklistEarthQuakeSpells, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateHasteSpells = Int(IniRead($config, "donate", "chkDonateHasteSpells", 0))
		$ichkDonateAllHasteSpells = Int(IniRead($config, "donate", "chkDonateAllHasteSpells", 0))
		$sTxtDonateHasteSpells = StringReplace(IniRead($config, "donate", "txtDonateHasteSpells", "haste"), "|", @CRLF)
		$sTxtBlacklistHasteSpells = StringReplace(IniRead($config, "donate", "txtBlacklistHasteSpells", "no haste|haste no"), "|", @CRLF)
		$aDonHasteSpells = StringSplit($sTxtDonateHasteSpells, @CRLF, $STR_ENTIRESPLIT)
		$aBlkHasteSpells = StringSplit($sTxtBlacklistHasteSpells, @CRLF, $STR_ENTIRESPLIT)

		$ichkDonateSkeletonSpells = Int(IniRead($config, "donate", "chkDonateSkeletonSpells", 0))
		$ichkDonateAllSkeletonSpells = Int(IniRead($config, "donate", "chkDonateAllSkeletonSpells", 0))
		$sTxtDonateSkeletonSpells = StringReplace(IniRead($config, "donate", "txtDonateSkeletonSpells", "skeleton"), "|", @CRLF)
		$sTxtBlacklistSkeletonSpells = StringReplace(IniRead($config, "donate", "txtBlacklistSkeletonSpells", "no skeleton|skeleton no"), "|", @CRLF)
		$aDonSkeletonSpells = StringSplit($sTxtDonateSkeletonSpells, @CRLF, $STR_ENTIRESPLIT)
		$aBlkSkeletonSpells = StringSplit($sTxtBlacklistSkeletonSpells, @CRLF, $STR_ENTIRESPLIT)

		;;; Custom Combination Donate by ChiefM3, edit by Hervidero & MonkeyHunter
		$ichkDonateCustomA = Int(IniRead($config, "donate", "chkDonateCustomA", 0))
		$ichkDonateAllCustomA = Int(IniRead($config, "donate", "chkDonateAllCustomA", 0))
		$sTxtDonateCustomA = StringReplace(IniRead($config, "donate", "txtDonateCustomA", "ground support|ground"), "|", @CRLF)
		$sTxtBlacklistCustomA = StringReplace(IniRead($config, "donate", "txtBlacklistCustomA", "no ground|ground no|nonly"), "|", @CRLF)
		$aDonCustomA = StringSplit($sTxtDonateCustomA, @CRLF, $STR_ENTIRESPLIT)
		$aBlkCustomA = StringSplit($sTxtBlacklistCustomA, @CRLF, $STR_ENTIRESPLIT)
		$varDonateCustomA[0][0] = Int(IniRead($config, "donate", "cmbDonateCustomA1", 6))
		$varDonateCustomA[1][0] = Int(IniRead($config, "donate", "cmbDonateCustomA2", 1))
		$varDonateCustomA[2][0] = Int(IniRead($config, "donate", "cmbDonateCustomA3", 0))
		$varDonateCustomA[0][1] = Int(IniRead($config, "donate", "txtDonateCustomA1", 2))
		$varDonateCustomA[1][1] = Int(IniRead($config, "donate", "txtDonateCustomA2", 3))
		$varDonateCustomA[2][1] = Int(IniRead($config, "donate", "txtDonateCustomA3", 1))

		$ichkDonateCustomB = Int(IniRead($config, "donate", "chkDonateCustomB", 0))
		$ichkDonateAllCustomB = Int(IniRead($config, "donate", "chkDonateAllCustomB", 0))
		$sTxtDonateCustomB = StringReplace(IniRead($config, "donate", "txtDonateCustomB", "air support|any air"), "|", @CRLF)
		$sTxtBlacklistCustomB = StringReplace(IniRead($config, "donate", "txtBlacklistCustomB", "no air|air no|only|just"), "|", @CRLF)
		$aDonCustomB = StringSplit($sTxtDonateCustomB, @CRLF, $STR_ENTIRESPLIT)
		$aBlkCustomB = StringSplit($sTxtBlacklistCustomB, @CRLF, $STR_ENTIRESPLIT)
		$varDonateCustomB[0][0] = Int(IniRead($config, "donate", "cmbDonateCustomB1", 11))
		$varDonateCustomB[1][0] = Int(IniRead($config, "donate", "cmbDonateCustomB2", 1))
		$varDonateCustomB[2][0] = Int(IniRead($config, "donate", "cmbDonateCustomB3", 6))
		$varDonateCustomB[0][1] = Int(IniRead($config, "donate", "txtDonateCustomB1", 3))
		$varDonateCustomB[1][1] = Int(IniRead($config, "donate", "txtDonateCustomB2", 13))
		$varDonateCustomB[2][1] = Int(IniRead($config, "donate", "txtDonateCustomB3", 5))

		$sTxtBlacklist = StringReplace(IniRead($config, "donate", "txtBlacklist", "clan war|war|cw"), "|", @CRLF)
		$aBlackList = StringSplit($sTxtBlacklist, @CRLF, $STR_ENTIRESPLIT)


		$icmbFilterDonationsCC = Int(IniRead($config, "donate", "cmbFilterDonationsCC", 0))


		; Extra Alphabets, Cyrillic, Chinese
		$ichkExtraAlphabets = Int(IniRead($config, "donate", "chkExtraAlphabets", 0))
		$ichkExtraChinese = Int(IniRead($config, "donate", "chkExtraChinese", 0))

		;IniReadS($chkLvl6Enabled, $config, "collectors", "lvl6Enabled", 0, "int")
		$chkLvl6Enabled = 0
		IniReadS($chkLvl7Enabled, $config, "collectors", "lvl7Enabled", 1, "int")
		IniReadS($chkLvl8Enabled, $config, "collectors", "lvl8Enabled", 1, "int")
		IniReadS($chkLvl9Enabled, $config, "collectors", "lvl9Enabled", 1, "int")
		IniReadS($chkLvl10Enabled, $config, "collectors", "lvl10Enabled", 1, "int")
		IniReadS($chkLvl11Enabled, $config, "collectors", "lvl11Enabled", 1, "int")
		IniReadS($chkLvl12Enabled, $config, "collectors", "lvl12Enabled", 1, "int")
		IniReadS($cmbLvl6Fill, $config, "collectors", "lvl6fill", 0, "int")
		If $cmbLvl6Fill > 1 Then $cmbLvl6Fill = 1
		IniReadS($cmbLvl7Fill, $config, "collectors", "lvl7fill", 0, "int")
		If $cmbLvl7Fill > 1 Then $cmbLvl7Fill = 1
		IniReadS($cmbLvl8Fill, $config, "collectors", "lvl8fill", 0, "int")
		If $cmbLvl8Fill > 1 Then $cmbLvl8Fill = 1
		IniReadS($cmbLvl9Fill, $config, "collectors", "lvl9fill", 0, "int")
		If $cmbLvl9Fill > 1 Then $cmbLvl9Fill = 1
		IniReadS($cmbLvl10Fill, $config, "collectors", "lvl10fill", 0, "int")
		If $cmbLvl10Fill > 1 Then $cmbLvl10Fill = 1
		IniReadS($cmbLvl11Fill, $config, "collectors", "lvl11fill", 0, "int")
		If $cmbLvl11Fill > 1 Then $cmbLvl11Fill = 1
		IniReadS($cmbLvl12Fill, $config, "collectors", "lvl12fill", 0, "int")
		If $cmbLvl12Fill > 1 Then $cmbLvl12Fill = 1
		IniReadS($toleranceOffset, $config, "collectors", "tolerance", 0, "int")
		InireadS($iMinCollectorMatches, $config, "collectors", "minmatches", $iMinCollectorMatches) ; 1-6 collectors
		If $iMinCollectorMatches < 1 Or $iMinCollectorMatches > 6 Then $iMinCollectorMatches = 3

		; Android Configuration
		$AndroidAutoAdjustConfig = Int(IniRead($config, "android", "auto.adjust.config", ($AndroidAutoAdjustConfig ? 1 : 0))) = 1 ; if enabled, best android options are configured
		$AndroidGameDistributor = IniRead($config, "android", "game.distributor", $AndroidGameDistributor)
		$AndroidGamePackage = IniRead($config, "android", "game.package", $AndroidGamePackage)
		$AndroidGameClass = IniRead($config, "android", "game.class", $AndroidGameClass)
		$UserGameDistributor = IniRead($config, "android", "user.distributor", $UserGameDistributor)
		$UserGamePackage = IniRead($config, "android", "user.package", $UserGamePackage)
		$UserGameClass = IniRead($config, "android", "user.class", $UserGameClass)
		$AndroidCheckTimeLagEnabled = Int(IniRead($config, "android", "check.time.lag.enabled", ($AndroidCheckTimeLagEnabled ? 1 : 0))) = 1
		$AndroidAdbScreencapTimeoutMin = Int(IniRead($config, "android", "adb.screencap.timeout.min", $AndroidAdbScreencapTimeoutMin))
		$AndroidAdbScreencapTimeoutMax = Int(IniRead($config, "android", "adb.screencap.timeout.max", $AndroidAdbScreencapTimeoutMax))
		$AndroidAdbScreencapTimeoutDynamic = Int(IniRead($config, "android", "adb.screencap.timeout.dynamic", $AndroidAdbScreencapTimeoutDynamic))
		$AndroidAdbInputEnabled = Int(IniRead($config, "android", "adb.input.enabled", ($AndroidAdbInputEnabled ? 1 : 0))) = 1
		$AndroidAdbClickEnabled = Int(IniRead($config, "android", "adb.click.enabled", ($AndroidAdbClickEnabled ? 1 : 0))) = 1
		$AndroidAdbClickGroup = Int(IniRead($config, "android", "adb.click.group", $AndroidAdbClickGroup))
		$AndroidAdbClicksEnabled = Int(IniRead($config, "android", "adb.clicks.enabled", ($AndroidAdbClicksEnabled ? 1 : 0))) = 1
		$AndroidAdbClicksTroopDeploySize = Int(IniRead($config, "android", "adb.clicks.troop.deploy.size", $AndroidAdbClicksTroopDeploySize))
		$NoFocusTampering = Int(IniRead($config, "android", "no.focus.tampering", ($NoFocusTampering ? 1 : 0))) = 1
		$AndroidShieldColor = Dec(IniRead($config, "android", "shield.color", Hex($AndroidShieldColor, 6)))
		$AndroidShieldTransparency = Int(IniRead($config, "android", "shield.transparency", $AndroidShieldTransparency))
		$AndroidActiveColor = Dec(IniRead($config, "android", "active.color", Hex($AndroidActiveColor, 6)))
		$AndroidActiveTransparency = Int(IniRead($config, "android", "active.transparency", $AndroidActiveTransparency))
		$AndroidInactiveColor = Dec(IniRead($config, "android", "inactive.color", Hex($AndroidInactiveColor, 6)))
		$AndroidInactiveTransparency = Int(IniRead($config, "android", "inactive.transparency", $AndroidInactiveTransparency))

		;Apply to switch Attack Standard after THSnipe End ==>
		IniReadS($ichkTSActivateCamps2, $config, "search", "ChkTSSearchCamps2", 0, "int")
		IniReadS($iEnableAfterArmyCamps2, $config, "search", "TSEnableAfterArmyCamps2", 100, "int")
		;==>Apply to switch Attack Standard after THSnipe End

		;Wait For Spells
		IniReadS($iEnableSpellsWait[$DB], $config, "search", "ChkDBSpellsWait", 0, "int")
		IniReadS($iEnableSpellsWait[$LB], $config, "search", "ChkABSpellsWait", 0, "int")
		IniReadS($iTotalTrainSpaceSpell, $config, "search", "TotalTrainSpaceSpell", 0, "int")
		IniReadS($iChkWaitForCastleSpell[$DB], $config, "search", "ChkDBCastleSpellWait", 0, "int")
		IniReadS($iChkWaitForCastleSpell[$LB], $config, "search", "ChkABCastleSpellWait", 0, "int")
		IniReadS($iChkWaitForCastleTroops[$DB], $config, "search", "ChkDBCastleTroopsWait", 0, "int")
		IniReadS($iChkWaitForCastleTroops[$LB], $config, "search", "ChkABCastleTroopsWait", 0, "int")
		IniReadS($iCmbWaitForCastleSpell[$DB], $config, "search", "cmbDBWaitForCastleSpell", 0, "int")
		IniReadS($iCmbWaitForCastleSpell2[$DB], $config, "search", "cmbDBWaitForCastleSpell2", 0, "int")
		IniReadS($iCmbWaitForCastleSpell[$LB], $config, "search", "cmbABWaitForCastleSpell", 0, "int")
		IniReadS($iCmbWaitForCastleSpell2[$LB], $config, "search", "cmbABWaitForCastleSpell2", 0, "int")

; ============================================================================
; ================================= SmartZap =================================
; ============================================================================
		$ichkSmartZap = IniRead($config, "SmartZap", "UseSmartZap", "0")
		$ichkSmartZapDB = IniRead($config, "SmartZap", "ZapDBOnly", "1")
		$ichkSmartZapSaveHeroes = IniRead($config, "SmartZap", "THSnipeSaveHeroes", "1")
		$itxtMinDE = IniRead($config, "SmartZap", "MinDE", "350")
		$ichkNoobZap = IniRead($config, "SmartZap", "UseNoobZap", "0")
		$ichkEarthQuakeZap = IniRead($config, "SmartZap", "UseEarthQuakeZap", "0")
		$itxtExpectedDE = IniRead($config, "SmartZap", "ExpectedDE", "320")
		$DebugSmartZap = IniRead($config, "SmartZap", "DebugSmartZap", "0")
; ============================================================================
; ================================= SmartZap =================================
; ============================================================================

		$_CheckIceWizardSlot = True ; recheck if Ice Wizard exists in Train Window

	Else
		Return False
	EndIf

EndFunc   ;==>readConfig
