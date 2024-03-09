; #FUNCTION# ====================================================================================================================
; Name ..........: readConfig.au3
; Description ...: Reads config file and sets variables
; Syntax ........: readConfig()
; Parameters ....: NA
; Return values .: NA
; Author ........:
; Modified ......: CodeSlinger69 (01-2018)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func readConfig($inputfile = $g_sProfileConfigPath) ;Reads config and sets it to the variables
	Static $iReadConfigCount = 0
	If $g_bReadConfigIsActive Then
		SetDebugLog("readConfig(), already running, exit")
		Return
	EndIf
	$g_bReadConfigIsActive = True
	$iReadConfigCount += 1
	SetDebugLog("readConfig(), call number " & $iReadConfigCount)

	; Read the stats files into arrays, will create the files if necessary
	$g_aiWeakBaseStats = readWeakBaseStats()

	ReadProfileConfig()
	If FileExists($g_sProfileBuildingPath) Then ReadBuildingConfig()
	If FileExists($g_sProfileConfigPath) Then ReadRegularConfig()
	If FileExists($g_sProfileClanGamesPath) Then ReadClanGamesConfig()

	$g_bReadConfigIsActive = False
EndFunc   ;==>readConfig

Func ReadProfileConfig($sIniFile = $g_sProfilePath & "\profile.ini")
	If FileExists($sIniFile) = 0 Then Return False
	Local $iValue, $sValue
	; defaultprofile read not required
	;$g_sProfileCurrentName = StringRegExpReplace(IniRead($sIniFile, "general", "defaultprofile", ""), '[/:*?"<>|]', '_')

	$iValue = $g_iGlobalActiveBotsAllowed
	$g_iGlobalActiveBotsAllowed = Int(IniRead($sIniFile, "general", "globalactivebotsallowed", $g_iGlobalActiveBotsAllowed))
	If $g_iGlobalActiveBotsAllowed < 1 Then $g_iGlobalActiveBotsAllowed = 2 ; ensure that multiple bots can run
	If $iValue <> $g_iGlobalActiveBotsAllowed Then
		SetDebugLog("Maximum of " & $iValue & " bots running at same time changed to " & $g_iGlobalActiveBotsAllowed)
	EndIf

	$iValue = $g_iGlobalThreads
	$g_iGlobalThreads = Int(IniRead($sIniFile, "general", "globalthreads", $g_iGlobalThreads))
	If $iValue <> $g_iGlobalThreads Then
		SetDebugLog("Threading: Using " & $g_iGlobalThreads & " threads shared across all bot instances changed to " & $iValue)
	EndIf

	; Not used anymore since MBR v7.6.7
	;$sValue = IniRead($sIniFile, "general", "adb.path", $g_sAndroidAdbPath)
	;If FileExists($sValue) Then $g_sAndroidAdbPath = $sValue

	Return True
EndFunc   ;==>ReadProfileConfig

Func ReadClanGamesConfig()
	SetDebugLog("Read Clan Games Config " & $g_sProfileClanGamesPath)

	; <><><><> Clan Games / Debug <><><><>
	ReadConfigCG_Debug()

	# NEW CLANGAMES GUI
	IniReadS($g_bChkClanGamesEnabled, $g_sProfileClanGamesPath, "clangames", "ChkClanGamesEnabled", False, "Bool")
	IniReadS($g_bChkClanGamesAllTimes, $g_sProfileClanGamesPath, "clangames", "ChkClanGamesAllTimes", True, "Bool")
	IniReadS($g_bChkClanGamesNoOneDay, $g_sProfileClanGamesPath, "clangames", "ChkClanGamesNoOneDay", False, "Bool")
	IniReadS($g_bChkClanGamesCollectRewards, $g_sProfileClanGamesPath, "clangames", "ChkClanGamesCollectRewards", False, "Bool")

	IniReadS($g_bChkClanGamesLoot, $g_sProfileClanGamesPath, "clangames", "ChkClanGamesLoot", True, "Bool")
	IniReadS($g_bChkClanGamesBattle, $g_sProfileClanGamesPath, "clangames", "ChkClanGamesBattle", True, "Bool")
	IniReadS($g_bChkClanGamesDes, $g_sProfileClanGamesPath, "clangames", "ChkClanGamesDestruction", True, "Bool")
	IniReadS($g_bChkClanGamesAirTroop, $g_sProfileClanGamesPath, "clangames", "ChkClanGamesAirTroop", False, "Bool")
	IniReadS($g_bChkClanGamesGroundTroop, $g_sProfileClanGamesPath, "clangames", "ChkClanGamesGroundTroop", False, "Bool")
	IniReadS($g_bChkClanGamesMiscellaneous, $g_sProfileClanGamesPath, "clangames", "ChkClanGamesMiscellaneous", True, "Bool")
	IniReadS($g_bChkClanGamesSpell, $g_sProfileClanGamesPath, "clangames", "ChkClanGamesSpell", False, "Bool")
	IniReadS($g_bChkClanGamesBBBattle, $g_sProfileClanGamesPath, "clangames", "ChkClanGamesBBBattle", True, "Bool")
	IniReadS($g_bChkClanGamesBBDes, $g_sProfileClanGamesPath, "clangames", "ChkClanGamesBBDestruction", True, "Bool")
	IniReadS($g_bChkClanGamesBBTroops, $g_sProfileClanGamesPath, "clangames", "ChkClanGamesBBTroops", False, "Bool")

	IniReadS($g_bChkForceBBAttackOnClanGames, $g_sProfileClanGamesPath, "clangames", "ChkForceBBAttackOnClanGames", True, "Bool")
	IniReadS($g_bChkForceAttackOnClanGamesWhenHalt, $g_sProfileClanGamesPath, "clangames", "ChkForceAttackOnClanGamesWhenHalt", False, "Bool")
	IniReadS($bSearchBBEventFirst, $g_sProfileClanGamesPath, "clangames", "SearchBBEventFirst", $bSearchBBEventFirst, "Bool")
	IniReadS($bSearchMainEventFirst, $g_sProfileClanGamesPath, "clangames", "SearchMainEventFirst", $bSearchMainEventFirst, "Bool")
	IniReadS($bSearchBothVillages, $g_sProfileClanGamesPath, "clangames", "SearchBothVillages", $bSearchBothVillages, "Bool")
	IniReadS($g_bChkClanGamesPurgeAny, $g_sProfileClanGamesPath, "clangames", "ChkClanGamesPurgeAny", True, "Bool")
	IniReadS($g_bChkClanGamesStopBeforeReachAndPurge, $g_sProfileClanGamesPath, "clangames", "ChkClanGamesStopBeforeReachAndPurge", True, "Bool")
	IniReadS($g_bSortClanGames, $g_sProfileClanGamesPath, "clangames", "ChkClanGamesSort", True, "Bool")
	IniReadS($g_iSortClanGames, $g_sProfileClanGamesPath, "clangames", "ClanGamesSortBy", 0, "int")

	Local $str
	;ClanGames MainVillage Loot Challenges
	$str = StringSplit(IniRead($g_sProfileClanGamesPath, "clangames", "EnabledCGLoot", "0|0|0|0|0|0|"), "|", $STR_NOCOUNT)
	For $i = 0 To UBound($g_abCGMainLootItem) - 1
		If $i >= UBound($str) Then
			$g_abCGMainLootItem[$i] = 0
		Else
			$g_abCGMainLootItem[$i] = $str[$i]
		EndIf
	Next
	;ClanGames MainVillage Battle Challenges
	$str = StringSplit(IniRead($g_sProfileClanGamesPath, "clangames", "EnabledCGBattle", "0|0|0|0||0|0|0||0|0|0||0|0|0||0|0|0||0|0|0||0|0|0|"), "|", $STR_NOCOUNT)
	For $i = 0 To UBound($g_abCGMainBattleItem) - 1
		If $i >= UBound($str) Then
			$g_abCGMainBattleItem[$i] = 0
		Else
			$g_abCGMainBattleItem[$i] = $str[$i]
		EndIf
	Next
	;ClanGames MainVillage Destructions Challenges
	$str = StringSplit(IniRead($g_sProfileClanGamesPath, "clangames", "EnabledCGDes", "0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|"), "|", $STR_NOCOUNT)
	For $i = 0 To UBound($g_abCGMainDestructionItem) - 1
		If $i >= UBound($str) Then
			$g_abCGMainDestructionItem[$i] = 0
		Else
			$g_abCGMainDestructionItem[$i] = $str[$i]
		EndIf
	Next
	;ClanGames MainVillage Air Troops Challenges
	$str = StringSplit(IniRead($g_sProfileClanGamesPath, "clangames", "EnabledCGAirTroop", "0|0|0|0|0|0|0|0|0|0|0|0|0|"), "|", $STR_NOCOUNT)
	For $i = 0 To UBound($g_abCGMainAirItem) - 1
		If $i >= UBound($str) Then
			$g_abCGMainAirItem[$i] = 0
		Else
			$g_abCGMainAirItem[$i] = $str[$i]
		EndIf
	Next
	;ClanGames MainVillage Ground Troops Challenges
	$str = StringSplit(IniRead($g_sProfileClanGamesPath, "clangames", "EnabledCGGroundTroop", "0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|"), "|", $STR_NOCOUNT)
	For $i = 0 To UBound($g_abCGMainGroundItem) - 1
		If $i >= UBound($str) Then
			$g_abCGMainGroundItem[$i] = 0
		Else
			$g_abCGMainGroundItem[$i] = $str[$i]
		EndIf
	Next
	;ClanGames MainVillage Miscellaneous Challenges
	$str = StringSplit(IniRead($g_sProfileClanGamesPath, "clangames", "EnabledCGMisc", "0|0|0|"), "|", $STR_NOCOUNT)
	For $i = 0 To UBound($g_abCGMainMiscItem) - 1
		If $i >= UBound($str) Then
			$g_abCGMainMiscItem[$i] = 0
		Else
			$g_abCGMainMiscItem[$i] = $str[$i]
		EndIf
	Next
	;ClanGames MainVillage Spell Challenges
	$str = StringSplit(IniRead($g_sProfileClanGamesPath, "clangames", "EnabledCGSpell", "0|0|0|0|0|0|0|0|0|0|0|0|"), "|", $STR_NOCOUNT)
	For $i = 0 To UBound($g_abCGMainSpellItem) - 1
		If $i >= UBound($str) Then
			$g_abCGMainSpellItem[$i] = 0
		Else
			$g_abCGMainSpellItem[$i] = $str[$i]
		EndIf
	Next
	;ClanGames BuilderBase Battle Challenges
	$str = StringSplit(IniRead($g_sProfileClanGamesPath, "clangames", "EnabledBBBattle", "0|0|0|0|"), "|", $STR_NOCOUNT)
	For $i = 0 To UBound($g_abCGBBBattleItem) - 1
		If $i >= UBound($str) Then
			$g_abCGBBBattleItem[$i] = 0
		Else
			$g_abCGBBBattleItem[$i] = $str[$i]
		EndIf
	Next
	;ClanGames BuilderBase Destructions Challenges
	$str = StringSplit(IniRead($g_sProfileClanGamesPath, "clangames", "EnabledBBDestruction", "0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|"), "|", $STR_NOCOUNT)
	For $i = 0 To UBound($g_abCGBBDestructionItem) - 1
		If $i >= UBound($str) Then
			$g_abCGBBDestructionItem[$i] = 0
		Else
			$g_abCGBBDestructionItem[$i] = $str[$i]
		EndIf
	Next
	;ClanGames BuilderBase Troops Challenges
	$str = StringSplit(IniRead($g_sProfileClanGamesPath, "clangames", "EnabledBBTroops", "0|0|0|0|0|0|0|0|0|0|0|0|"), "|", $STR_NOCOUNT)
	For $i = 0 To UBound($g_abCGBBTroopsItem) - 1
		If $i >= UBound($str) Then
			$g_abCGBBTroopsItem[$i] = 0
		Else
			$g_abCGBBTroopsItem[$i] = $str[$i]
		EndIf
	Next
EndFunc   ;==>ReadClanGamesConfig

Func ReadBuildingConfig()
	SetDebugLog("Read Building Config " & $g_sProfileBuildingPath)
	Local $locationsInvalid = False
	Local $buildingVersion = "0.0.0"
	IniReadS($buildingVersion, $g_sProfileBuildingPath, "general", "version", $buildingVersion)
	Local $_ver630 = GetVersionNormalized("6.3.0")
	Local $_ver63u = GetVersionNormalized("6.3.u")
	Local $_ver63u3 = GetVersionNormalized("6.3.u3")
	If $buildingVersion < $_ver630 _
			Or ($buildingVersion >= $_ver63u And $buildingVersion <= $_ver63u3) Then
		SetLog("New MyBot.run version! Re-locate all buildings!", $COLOR_WARNING)
		$locationsInvalid = True
	EndIf

	IniReadS($g_iTownHallLevel, $g_sProfileBuildingPath, "other", "LevelTownHall", 0, "int")

	If $locationsInvalid = False Then
		IniReadS($g_aiTownHallPos[0], $g_sProfileBuildingPath, "other", "xTownHall", -1, "int")
		IniReadS($g_aiTownHallPos[1], $g_sProfileBuildingPath, "other", "yTownHall", -1, "int")

		IniReadS($g_aiClanCastlePos[0], $g_sProfileBuildingPath, "other", "xCCPos", -1, "int")
		IniReadS($g_aiClanCastlePos[1], $g_sProfileBuildingPath, "other", "yCCPos", -1, "int")

		;IniReadS($barrackPos[0][0], $g_sProfileBuildingPath, "other", "xBarrack1", -1, "int")
		;IniReadS($barrackPos[0][1], $g_sProfileBuildingPath, "other", "yBarrack1", -1, "int")

		;IniReadS($barrackPos[1][0], $g_sProfileBuildingPath, "other", "xBarrack2", -1, "int")
		;IniReadS($barrackPos[1][1], $g_sProfileBuildingPath, "other", "yBarrack2", -1, "int")

		;IniReadS($barrackPos[2][0], $g_sProfileBuildingPath, "other", "xBarrack3", -1, "int")
		;IniReadS($barrackPos[2][1], $g_sProfileBuildingPath, "other", "yBarrack3", -1, "int")

		;IniReadS($barrackPos[3][0], $g_sProfileBuildingPath, "other", "xBarrack4", -1, "int")
		;IniReadS($barrackPos[3][1], $g_sProfileBuildingPath, "other", "yBarrack4", -1, "int")

		;IniReadS($SFPos[0], $g_sProfileBuildingPath, "other", "xspellfactory", -1, "int")
		;IniReadS($SFPos[1], $g_sProfileBuildingPath, "other", "yspellfactory", -1, "int")

		;IniReadS($DSFPos[0], $g_sProfileBuildingPath, "other", "xDspellfactory", -1, "int")
		;IniReadS($DSFPos[1], $g_sProfileBuildingPath, "other", "yDspellfactory", -1, "int")

		IniReadS($g_aiKingAltarPos[0], $g_sProfileBuildingPath, "other", "xKingAltarPos", -1, "int")
		IniReadS($g_aiKingAltarPos[1], $g_sProfileBuildingPath, "other", "yKingAltarPos", -1, "int")

		IniReadS($g_aiQueenAltarPos[0], $g_sProfileBuildingPath, "other", "xQueenAltarPos", -1, "int")
		IniReadS($g_aiQueenAltarPos[1], $g_sProfileBuildingPath, "other", "yQueenAltarPos", -1, "int")

		IniReadS($g_aiWardenAltarPos[0], $g_sProfileBuildingPath, "other", "xWardenAltarPos", -1, "int")
		IniReadS($g_aiWardenAltarPos[1], $g_sProfileBuildingPath, "other", "yWardenAltarPos", -1, "int")

		IniReadS($g_aiChampionAltarPos[0], $g_sProfileBuildingPath, "other", "xChampionAltarPos", -1, "int")
		IniReadS($g_aiChampionAltarPos[1], $g_sProfileBuildingPath, "other", "yChampionAltarPos", -1, "int")

		IniReadS($g_aiLaboratoryPos[0], $g_sProfileBuildingPath, "upgrade", "LabPosX", -1, "int")
		IniReadS($g_aiLaboratoryPos[1], $g_sProfileBuildingPath, "upgrade", "LabPosY", -1, "int")

		IniReadS($g_aiPetHousePos[0], $g_sProfileBuildingPath, "upgrade", "PetHousePosX", -1, "int")
		IniReadS($g_aiPetHousePos[1], $g_sProfileBuildingPath, "upgrade", "PetHousePosY", -1, "int")

		IniReadS($g_aiBlacksmithPos[0], $g_sProfileBuildingPath, "upgrade", "BlacksmithPosX", -1, "int")
		IniReadS($g_aiBlacksmithPos[1], $g_sProfileBuildingPath, "upgrade", "BlacksmithPosY", -1, "int")
	EndIf

	IniReadS($g_aiStarLaboratoryPos[0], $g_sProfileBuildingPath, "upgrade", "StarLabPosX", -1, "int")
	IniReadS($g_aiStarLaboratoryPos[1], $g_sProfileBuildingPath, "upgrade", "StarLabPosY", -1, "int")

	IniReadS($g_aiBattleMachinePos[0], $g_sProfileBuildingPath, "upgrade", "BattleMachinePosX", -1, "int")
	IniReadS($g_aiBattleMachinePos[1], $g_sProfileBuildingPath, "upgrade", "BattleMachinePosY", -1, "int")

	IniReadS($g_aiBuilderHallPos[0], $g_sProfileBuildingPath, "other", "BuilderHallPosX", -1, "int")
	IniReadS($g_aiBuilderHallPos[1], $g_sProfileBuildingPath, "other", "BuilderHallPosY", -1, "int")
	IniReadS($g_iBuilderHallLevel, $g_sProfileBuildingPath, "other", "LevelBuilderHall", 0, "int")

	IniReadS($g_aiDoubleCannonPos[0], $g_sProfileBuildingPath, "other", "DoubleCannonPosX", -1, "int")
	IniReadS($g_aiDoubleCannonPos[1], $g_sProfileBuildingPath, "other", "DoubleCannonPosY", -1, "int")
	IniReadS($g_aiDoubleCannonPos[2], $g_sProfileBuildingPath, "other", "DoubleCannonPosV", -1, "int")

	IniReadS($g_aiArcherTowerPos[0], $g_sProfileBuildingPath, "other", "ArcherTowerPosX", -1, "int")
	IniReadS($g_aiArcherTowerPos[1], $g_sProfileBuildingPath, "other", "ArcherTowerPosY", -1, "int")
	IniReadS($g_aiArcherTowerPos[2], $g_sProfileBuildingPath, "other", "ArcherTowerPosV", -1, "int")

	IniReadS($g_aiMultiMortarPos[0], $g_sProfileBuildingPath, "other", "MultiMortarPosX", -1, "int")
	IniReadS($g_aiMultiMortarPos[1], $g_sProfileBuildingPath, "other", "MultiMortarPosY", -1, "int")
	IniReadS($g_aiMultiMortarPos[2], $g_sProfileBuildingPath, "other", "MultiMortarPosV", -1, "int")

	IniReadS($g_aiBattleCopterPos[0], $g_sProfileBuildingPath, "other", "BattleCopterPosX", -1, "int")
	IniReadS($g_aiBattleCopterPos[1], $g_sProfileBuildingPath, "other", "BattleCopterPosY", -1, "int")

	IniReadS($g_aiAnyDefPos[0], $g_sProfileBuildingPath, "other", "AnyDefPosX", -1, "int")
	IniReadS($g_aiAnyDefPos[1], $g_sProfileBuildingPath, "other", "AnyDefPosY", -1, "int")
	IniReadS($g_aiAnyDefPos[2], $g_sProfileBuildingPath, "other", "AnyDefPosV", -1, "int")

	IniReadS($g_aiLastGoodWallPos[0], $g_sProfileBuildingPath, "upgrade", "xLastGoodWallPos", -1, "int")
	IniReadS($g_aiLastGoodWallPos[1], $g_sProfileBuildingPath, "upgrade", "yLastGoodWallPos", -1, "int")

	IniReadS($g_iTotalCampSpace, $g_sProfileBuildingPath, "other", "totalcamp", 0, "int")

	For $iz = 0 To UBound($g_avBuildingUpgrades, 1) - 1 ; Reads Upgrade building data
		$g_avBuildingUpgrades[$iz][0] = IniRead($g_sProfileBuildingPath, "upgrade", "xupgrade" & $iz, "-1")
		$g_avBuildingUpgrades[$iz][1] = IniRead($g_sProfileBuildingPath, "upgrade", "yupgrade" & $iz, "-1")
		$g_avBuildingUpgrades[$iz][2] = IniRead($g_sProfileBuildingPath, "upgrade", "upgradevalue" & $iz, "-1")
		$g_avBuildingUpgrades[$iz][3] = IniRead($g_sProfileBuildingPath, "upgrade", "upgradetype" & $iz, "")
		$g_avBuildingUpgrades[$iz][4] = IniRead($g_sProfileBuildingPath, "upgrade", "upgradename" & $iz, "")
		$g_avBuildingUpgrades[$iz][5] = IniRead($g_sProfileBuildingPath, "upgrade", "upgradelevel" & $iz, "")
		$g_avBuildingUpgrades[$iz][6] = IniRead($g_sProfileBuildingPath, "upgrade", "upgradetime" & $iz, "")
		$g_avBuildingUpgrades[$iz][7] = IniRead($g_sProfileBuildingPath, "upgrade", "upgradeend" & $iz, "-1")
		$g_abBuildingUpgradeEnable[$iz] = (IniRead($g_sProfileBuildingPath, "upgrade", "upgradechk" & $iz, 0) = "1")
		$g_abUpgradeRepeatEnable[$iz] = (IniRead($g_sProfileBuildingPath, "upgrade", "upgraderepeat" & $iz, 0) = "1")
		$g_aiPicUpgradeStatus[$iz] = IniRead($g_sProfileBuildingPath, "upgrade", "upgradestatusicon" & $iz, $eIcnRedLight)

		If $locationsInvalid = True Then
			$g_avBuildingUpgrades[$iz][0] = -1
			$g_avBuildingUpgrades[$iz][1] = -1
			$g_abBuildingUpgradeEnable[$iz] = False
			$g_abUpgradeRepeatEnable[$iz] = False
		EndIf
	Next
EndFunc   ;==>ReadBuildingConfig

Func ReadRegularConfig()
	SetDebugLog("Read Config " & $g_sProfileConfigPath)

	; <><><><> Bot / Debug <><><><>
	ReadConfig_Debug()

	IniReadS($g_iThreads, $g_sProfileConfigPath, "general", "threads", $g_iThreads, "int")
	If $g_iThreads < 0 Then $g_iThreads = 0
	IniReadS($g_iBotDesignFlags, $g_sProfileConfigPath, "general", "botDesignFlags", 0, "int") ; Default for existing profiles is 0, for new is 3

	; Window positions
	IniReadS($g_iFrmBotPosX, $g_sProfileConfigPath, "general", "frmBotPosX", $g_iFrmBotPosX, "int")
	IniReadS($g_iFrmBotPosY, $g_sProfileConfigPath, "general", "frmBotPosY", $g_iFrmBotPosY, "int")
	If $g_iFrmBotPosX < -30000 Or $g_iFrmBotPosY < -30000 Then
		; bot window was minimized, restore default position
		$g_iFrmBotPosX = $g_WIN_POS_DEFAULT
		$g_iFrmBotPosY = $g_WIN_POS_DEFAULT
	EndIf

	IniReadS($g_iAndroidPosX, $g_sProfileConfigPath, "general", "AndroidPosX", $g_iAndroidPosX, "int")
	IniReadS($g_iAndroidPosY, $g_sProfileConfigPath, "general", "AndroidPosY", $g_iAndroidPosY, "int")
	If $g_iAndroidPosX < -30000 Or $g_iAndroidPosY < -30000 Then
		; bot window was minimized, restore default position
		$g_iAndroidPosX = $g_WIN_POS_DEFAULT
		$g_iAndroidPosY = $g_WIN_POS_DEFAULT
	EndIf

	IniReadS($g_iFrmBotDockedPosX, $g_sProfileConfigPath, "general", "frmBotDockedPosX", $g_iFrmBotDockedPosX, "int")
	IniReadS($g_iFrmBotDockedPosY, $g_sProfileConfigPath, "general", "frmBotDockedPosY", $g_iFrmBotDockedPosY, "int")
	If $g_iFrmBotDockedPosX < -30000 Or $g_iFrmBotDockedPosY < -30000 Then
		; bot window was minimized, restore default position
		$g_iFrmBotDockedPosX = $g_WIN_POS_DEFAULT
		$g_iFrmBotDockedPosY = $g_WIN_POS_DEFAULT
	EndIf

	; Redraw mode:  0 = disabled, 1 = Redraw always entire bot window, 2 = Redraw only required bot window area (or entire bot if control not specified)
	IniReadS($g_iRedrawBotWindowMode, $g_sProfileConfigPath, "general", "RedrawBotWindowMode", 2, "int")

	; <><><><> Bot / Android <><><><>
	ReadConfig_Android()
	; <><><><> Log window <><><><>
	ReadConfig_600_1()
	; <><><><> Village / Misc <><><><>
	ReadConfig_600_6()
	; <><><><> Village / Achievements <><><><>
	ReadConfig_600_9()
	; <><><><> Village / Donate - Request <><><><>
	ReadConfig_600_11()
	; <><><><> Village / Donate - Donate <><><><>
	ReadConfig_600_12()
	; <><><><> Village / Donate - Schedule <><><><>
	ReadConfig_600_13()
	; <><><><> Village / Upgrade - Lab <><><><>
	ReadConfig_600_14()
	; <><><><> Village / Upgrade - Heroes <><><><>
	ReadConfig_600_15()
	; <><><><> Village / Upgrade - Buildings <><><><>
	ReadConfig_600_16()
	; <><><><> Village / Upgrade - Auto Upgrade <><><><>
	ReadConfig_auto()
	; <><><><> Village / Upgrade - Walls <><><><>
	ReadConfig_600_17()
	; <><><><> Village / Notify <><><><>
	ReadConfig_600_18()
	; <><><><> Village / Notify <><><><>
	ReadConfig_600_19()
	; <><><> Attack Plan / Train Army / Boost <><><>
	ReadConfig_600_22()
	; <><><><> Attack Plan / Search & Attack / Bully <><><><>
	ReadConfig_600_26()
	; <><><><> Attack Plan / Search & Attack / Options / Search <><><><>
	ReadConfig_600_28()
	; <><><><> Attack Plan / Search & Attack / Deadbase / Search <><><><>
	ReadConfig_600_28_DB()
	; <><><><> Attack Plan / Search & Attack / Activebase / Search <><><><>
	ReadConfig_600_28_LB()
	; <><><><> Attack Plan / Search & Attack / Options / Attack <><><><>
	ReadConfig_600_29()
	; <><><><> Attack Plan / Search & Attack / Deadbase / Attack <><><><>
	ReadConfig_600_29_DB()
	; <><><><> Attack Plan / Search & Attack / Activebase / Attack <><><><>
	ReadConfig_600_29_LB()
	; <><><><> Attack Plan / Search & Attack / Options / End Battle <><><><>
	ReadConfig_600_30()
	; <><><><> Attack Plan / Search & Attack / Deadbase / End Battle <><><><>
	ReadConfig_600_30_DB()
	; <><><><> Attack Plan / Search & Attack / Activebase / End Battle <><><><>
	ReadConfig_600_30_LB()
	; <><><><> Attack Plan / Search & Attack / Deadbase / Collectors <><><><>
	ReadConfig_600_31()
	; <><><><> Attack Plan / Search & Attack / Options / Trophy Settings <><><><>
	ReadConfig_600_32()
	; <><><><> Attack Plan / Search & Attack / Drop Order Troops <><><><>
	ReadConfig_600_33()
	; <><><><> Bot / Options <><><><>
	ReadConfig_600_35_1()
	; <><><><> Bot / Profile / Switch Account <><><><>
	ReadConfig_600_35_2()
	; <><><> Attack Plan / Train Army / Troops/Spells <><><>
	; Quick train
	ReadConfig_600_52_1()
	; troop/spell levels and counts
	ReadConfig_600_52_2()
	; <><><> Attack Plan / Train Army / Train Order <><><>
	ReadConfig_600_54()
	; <><><><> Attack Plan / Search & Attack / Options / SmartZap <><><><>
	ReadConfig_600_56()
	; <><><> Attack Plan / Train Army / Options <><><>
	ReadConfig_641_1()

	; <><><><> Attack Plan / Strategies <><><><>
	; <<< nothing here >>>

	; <><><><> Bot / Android <><><><>
	; <<< nothing here >>>

	; <><><><> Bot / Debug <><><><>
	; Settings at top of this function for easy access

	; <><><><> Bot / Profiles <><><><>
	; <<< nothing here >>>

	; <><><><> Bot / Stats <><><><>
	; <<< nothing here >>>
EndFunc   ;==>ReadRegularConfig

Func ReadConfig_Debug()
	; Debug settings
	$g_bDebugSetlog = IniRead($g_sProfileConfigPath, "debug", "debugsetlog", 0) = 1 ? True : False
	$g_bDebugAndroid = IniRead($g_sProfileConfigPath, "debug", "debugAndroid", 0) = 1 ? True : False
	$g_bDebugClick = IniRead($g_sProfileConfigPath, "debug", "debugsetclick", 0) = 1 ? True : False
	If $g_bDevMode Then
		Local $bDebugFunc = IniRead($g_sProfileConfigPath, "debug", "debugFunc", 0) = 1 ? True : False
		$g_bDebugFuncTime = $bDebugFunc
		$g_bDebugFuncCall = $bDebugFunc
		$g_bDebugDisableZoomout = IniRead($g_sProfileConfigPath, "debug", "disablezoomout", 0) = 1 ? True : False
		$g_bDebugDisableVillageCentering = IniRead($g_sProfileConfigPath, "debug", "disablevillagecentering", 0) = 1 ? True : False
		$g_bDebugDeadBaseImage = IniRead($g_sProfileConfigPath, "debug", "debugdeadbaseimage", 0) = 1 ? True : False
		$g_bDebugOcr = IniRead($g_sProfileConfigPath, "debug", "debugocr", 0) = 1 ? True : False
		$g_bDebugImageSave = IniRead($g_sProfileConfigPath, "debug", "debugimagesave", 0) = 1 ? True : False
		$g_bDebugBuildingPos = IniRead($g_sProfileConfigPath, "debug", "debugbuildingpos", 0) = 1 ? True : False
		$g_bDebugSetlogTrain = IniRead($g_sProfileConfigPath, "debug", "debugtrain", 0) = 1 ? True : False
		$g_bDebugOCRdonate = IniRead($g_sProfileConfigPath, "debug", "debugOCRDonate", 0) = 1 ? True : False
		$g_bDebugAttackCSV = IniRead($g_sProfileConfigPath, "debug", "debugAttackCSV", 0) = 1 ? True : False
		$g_bDebugMakeIMGCSV = IniRead($g_sProfileConfigPath, "debug", "debugmakeimgcsv", 0) = 1 ? True : False
		$g_bDebugSmartZap = BitOR($g_bDebugSmartZap, Int(IniRead($g_sProfileConfigPath, "debug", "DebugSmartZap", 0)))
	EndIf
EndFunc   ;==>ReadConfig_Debug

Func ReadConfigCG_Debug()
	; Debug settings
	If $g_bDevMode Then
		$g_bChkClanGamesDebug = IniRead($g_sProfileClanGamesPath, "debug", "CGDebug", 0) = 1 ? True : False
		$g_bCGDebugEvents = IniRead($g_sProfileClanGamesPath, "debug", "CGDebugEvents", 0) = 1 ? True : False
	EndIf
EndFunc   ;==>ReadConfigCG_Debug

Func ReadConfig_Android()
	; Android Configuration
	$g_sAndroidGameDistributor = IniRead($g_sProfileConfigPath, "android", "game.distributor", $g_sAndroidGameDistributor)
	$g_sAndroidGamePackage = IniRead($g_sProfileConfigPath, "android", "game.package", $g_sAndroidGamePackage)
	$g_sAndroidGameClass = IniRead($g_sProfileConfigPath, "android", "appActitivityName", $g_sAndroidGameClass)
	$g_sUserGameDistributor = IniRead($g_sProfileConfigPath, "android", "user.distributor", $g_sUserGameDistributor)
	$g_sUserGamePackage = IniRead($g_sProfileConfigPath, "android", "user.package", $g_sUserGamePackage)
	$g_sUserGameClass = IniRead($g_sProfileConfigPath, "android", "UserAppActitivityName", $g_sUserGameClass)
	$g_iAndroidBackgroundMode = Int(IniRead($g_sProfileConfigPath, "android", "backgroundmode", $g_iAndroidBackgroundMode))
	$g_iAndroidZoomoutMode = Int(IniRead($g_sProfileConfigPath, "android", "zoomoutmode", $g_iAndroidZoomoutMode))
	$g_iAndroidAdbReplace = Int(IniRead($g_sProfileConfigPath, "android", "adb.replace", $g_iAndroidAdbReplace))
	$g_bAndroidCheckTimeLagEnabled = Int(IniRead($g_sProfileConfigPath, "android", "check.time.lag.enabled", ($g_bAndroidCheckTimeLagEnabled ? 1 : 0))) = 1
	$g_bAndroidAdbPortPerInstance = Int(IniRead($g_sProfileConfigPath, "android", "adb.dedicated.instance", $g_bAndroidAdbPortPerInstance ? 1 : 0)) = 1
	$g_iAndroidAdbScreencapTimeoutMin = Int(IniRead($g_sProfileConfigPath, "android", "adb.screencap.timeout.min", $g_iAndroidAdbScreencapTimeoutMin))
	$g_iAndroidAdbScreencapTimeoutMax = Int(IniRead($g_sProfileConfigPath, "android", "adb.screencap.timeout.max", $g_iAndroidAdbScreencapTimeoutMax))
	$g_iAndroidAdbScreencapTimeoutDynamic = Int(IniRead($g_sProfileConfigPath, "android", "adb.screencap.timeout.dynamic", $g_iAndroidAdbScreencapTimeoutDynamic))
	$g_bAndroidAdbInputEnabled = Int(IniRead($g_sProfileConfigPath, "android", "adb.input.enabled", ($g_bAndroidAdbInputEnabled ? 1 : 0))) = 1
	$g_bAndroidAdbClickEnabled = Int(IniRead($g_sProfileConfigPath, "android", "adb.click.enabled", ($g_bAndroidAdbClickEnabled ? 1 : 0))) = 1
	$g_bAndroidAdbClickDragScript = Int(IniRead($g_sProfileConfigPath, "android", "adb.click.drag.script", (BitAND($g_iAndroidSupportFeature, 128) ? 0 : 1))) = 1 ; if bit is 0, enable script
	$g_iAndroidAdbClickGroup = Int(IniRead($g_sProfileConfigPath, "android", "adb.click.group", $g_iAndroidAdbClickGroup))
	$g_bAndroidAdbClicksEnabled = Int(IniRead($g_sProfileConfigPath, "android", "adb.clicks.enabled", ($g_bAndroidAdbClicksEnabled ? 1 : 0))) = 1
	$g_iAndroidAdbClicksTroopDeploySize = Int(IniRead($g_sProfileConfigPath, "android", "adb.clicks.troop.deploy.size", $g_iAndroidAdbClicksTroopDeploySize))
	$g_bNoFocusTampering = Int(IniRead($g_sProfileConfigPath, "android", "no.focus.tampering", ($g_bNoFocusTampering ? 1 : 0))) = 1
	$g_iAndroidShieldColor = Dec(IniRead($g_sProfileConfigPath, "android", "shield.color", Hex($g_iAndroidShieldColor, 6)))
	$g_iAndroidShieldTransparency = Int(IniRead($g_sProfileConfigPath, "android", "shield.transparency", $g_iAndroidShieldTransparency))
	$g_iAndroidActiveColor = Dec(IniRead($g_sProfileConfigPath, "android", "active.color", Hex($g_iAndroidActiveColor, 6)))
	$g_iAndroidActiveTransparency = Int(IniRead($g_sProfileConfigPath, "android", "active.transparency", $g_iAndroidActiveTransparency))
	$g_iAndroidInactiveColor = Dec(IniRead($g_sProfileConfigPath, "android", "inactive.color", Hex($g_iAndroidInactiveColor, 6)))
	$g_iAndroidInactiveTransparency = Int(IniRead($g_sProfileConfigPath, "android", "inactive.transparency", $g_iAndroidInactiveTransparency))
	$g_iAndroidSuspendModeFlags = Int(IniRead($g_sProfileConfigPath, "android", "suspend.mode", $g_iAndroidSuspendModeFlags))
	$g_iAndroidRebootHours = Int(IniRead($g_sProfileConfigPath, "android", "reboot.hours", $g_iAndroidRebootHours))
	$g_bAndroidCloseWithBot = Int(IniRead($g_sProfileConfigPath, "android", "close", $g_bAndroidCloseWithBot ? 1 : 0)) = 1
	$g_bUpdateSharedPrefs = Int(IniRead($g_sProfileConfigPath, "android", "shared_prefs.update", $g_bUpdateSharedPrefs ? 1 : 0)) = 1
	$g_bUpdateSharedPrefs = 0 ; force to disable
	$g_iAndroidProcessAffinityMask = Int(IniRead($g_sProfileConfigPath, "android", "process.affinity.mask", $g_iAndroidProcessAffinityMask))
	$g_iAndroidControlClickAdditionalDelay = Int(IniRead($g_sProfileConfigPath, "android", "click.additional.delay", $g_iAndroidControlClickAdditionalDelay))

	If $g_bBotLaunchOption_Restart = True Or $g_asCmdLine[0] < 2 Then
		; for now only read when bot crashed and restarted through watchdog or nofify event
		Local $sAndroidEmulator = IniRead($g_sProfileConfigPath, "android", "emulator", "")
		Local $sAndroidInstance = IniRead($g_sProfileConfigPath, "android", "instance", "")
		If $sAndroidEmulator <> "" Then
			#cs Not required yet
				If $g_hFrmBot = 0 Then
				; early readConfig during bot launch: use command line if specified
				If $g_asCmdLine[0] > 1 Then
				If $g_asCmdLine[1] <> $sAndroidEmulator Then
				$sAndroidEmulator = $g_asCmdLine[1]
				SetDebugLog("Override Android Emulator by command line: " & $sAndroidEmulator)
				EndIf
				If $g_asCmdLine[0] > 2 Then
				If $g_asCmdLine[2] <> $sAndroidInstance Then
				$sAndroidInstance = $g_asCmdLine[2]
				SetDebugLog("Override Android Instance by command line: " & $sAndroidInstance)
				EndIf
				EndIf
				EndIf
				EndIf
			#ce Not required yet

			If $sAndroidEmulator <> $g_sAndroidEmulator Or $sAndroidInstance <> $g_sAndroidInstance Then
				; check if Android Emulator or Instance changed, then invalidate Android Handle
				UpdateHWnD(0)
				UpdateAndroidConfig($sAndroidInstance, $sAndroidEmulator)
			EndIf
		Else
			; flag that detection must run
			$g_bBotLaunchOption_Restart = False
		EndIf
	EndIf

EndFunc   ;==>ReadConfig_Android

Func ReadConfig_600_1()
	; <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
	; GUI Settings
	; <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
	; <><><><> Log window <><><><>
	IniReadS($g_iCmbLogDividerOption, $g_sProfileConfigPath, "general", "logstyle", 0, "int")
	IniReadS($g_iLogDividerY, $g_sProfileConfigPath, "general", "LogDividerY", 243, "int")
	; <><><><> Bottom panel <><><><>
	IniReadS($g_bChkBackgroundMode, $g_sProfileConfigPath, "general", "Background", True, "Bool")
EndFunc   ;==>ReadConfig_600_1

Func ReadConfig_600_6()
	; <><><><> Village / Misc <><><><>
	IniReadS($g_bChkBotStop, $g_sProfileConfigPath, "general", "BotStop", False, "Bool")
	IniReadS($g_iCmbBotCommand, $g_sProfileConfigPath, "general", "Command", 0, "int")
	IniReadS($g_iCmbBotCond, $g_sProfileConfigPath, "general", "Cond", 0, "int")
	IniReadS($g_iCmbHoursStop, $g_sProfileConfigPath, "general", "Hour", 0, "int")
	For $i = 0 To $eLootCount - 1
		IniReadS($g_aiResumeAttackLoot[$i], $g_sProfileConfigPath, "other", "MinResumeAttackLoot_" & $i, 0, "int")
	Next
	IniReadS($g_bCollectStarBonus, $g_sProfileConfigPath, "general", "CollectStarBonus", False, "Bool")
	IniReadS($g_iCmbTimeStop, $g_sProfileConfigPath, "general", "CmbTimeStop", 0, "int")
	IniReadS($g_iResumeAttackTime, $g_sProfileConfigPath, "other", "ResumeAttackTime", 12, "int")

	IniReadS($g_iTxtRestartGold, $g_sProfileConfigPath, "other", "minrestartgold", 50000, "int")
	IniReadS($g_iTxtRestartElixir, $g_sProfileConfigPath, "other", "minrestartelixir", 50000, "int")
	IniReadS($g_iTxtRestartDark, $g_sProfileConfigPath, "other", "minrestartdark", 500, "int")
	IniReadS($g_bChkCollect, $g_sProfileConfigPath, "other", "chkCollect", True, "Bool")
	IniReadS($g_bChkCollectCartFirst, $g_sProfileConfigPath, "other", "chkCollectCartFirst", False, "Bool")
	IniReadS($g_iTxtCollectGold, $g_sProfileConfigPath, "other", "minCollectgold", 0, "int")
	IniReadS($g_iTxtCollectElixir, $g_sProfileConfigPath, "other", "minCollectelixir", 0, "int")
	IniReadS($g_iTxtCollectDark, $g_sProfileConfigPath, "other", "minCollectdark", 0, "int")
	IniReadS($g_bChkTombstones, $g_sProfileConfigPath, "other", "chkTombstones", True, "Bool")
	IniReadS($g_bChkCleanYard, $g_sProfileConfigPath, "other", "chkCleanYard", False, "Bool")
	IniReadS($g_bChkGemsBox, $g_sProfileConfigPath, "other", "chkGemsBox", False, "Bool")
	IniReadS($g_bChkCollectAchievements, $g_sProfileConfigPath, "other", "ChkCollectAchievements", False, "Bool")
	IniReadS($g_bChkCollectFreeMagicItems, $g_sProfileConfigPath, "other", "ChkCollectFreeMagicItems", False, "Bool")
	IniReadS($g_bChkCollectRewards, $g_sProfileConfigPath, "other", "ChkCollectRewards", False, "Bool")
	IniReadS($g_bChkSellRewards, $g_sProfileConfigPath, "other", "ChkSellRewards", False, "Bool")
	IniReadS($g_bChkTreasuryCollect, $g_sProfileConfigPath, "other", "ChkTreasuryCollect", False, "Bool")
	IniReadS($g_iTxtTreasuryGold, $g_sProfileConfigPath, "other", "minTreasurygold", 0, "int")
	IniReadS($g_iTxtTreasuryElixir, $g_sProfileConfigPath, "other", "minTreasuryelixir", 0, "int")
	IniReadS($g_iTxtTreasuryDark, $g_sProfileConfigPath, "other", "minTreasurydark", 0, "int")

	IniReadS($g_bChkCollectBuilderBase, $g_sProfileConfigPath, "other", "ChkCollectBuildersBase", False, "Bool")
	IniReadS($g_bChkCleanBBYard, $g_sProfileConfigPath, "other", "ChkCleanBBYard", False, "Bool")
	IniReadS($g_bChkStartClockTowerBoost, $g_sProfileConfigPath, "other", "ChkStartClockTowerBoost", False, "Bool")
	IniReadS($g_bChkCTBoostBlderBz, $g_sProfileConfigPath, "other", "ChkCTBoostBlderBz", False, "Bool")
	IniReadS($g_iChkBBSuggestedUpgrades, $g_sProfileConfigPath, "other", "ChkBBSuggestedUpgrades", $g_iChkBBSuggestedUpgrades, "Int")
	IniReadS($g_iChkBBSuggestedUpgradesIgnoreGold, $g_sProfileConfigPath, "other", "ChkBBSuggestedUpgradesIgnoreGold", $g_iChkBBSuggestedUpgradesIgnoreGold, "Int")
	IniReadS($g_iChkBBSuggestedUpgradesIgnoreElixir, $g_sProfileConfigPath, "other", "ChkBBSuggestedUpgradesIgnoreElixir", $g_iChkBBSuggestedUpgradesIgnoreElixir, "Int")
	IniReadS($g_iChkBBSuggestedUpgradesIgnoreHall, $g_sProfileConfigPath, "other", "ChkBBSuggestedUpgradesIgnoreHall", $g_iChkBBSuggestedUpgradesIgnoreHall, "Int")
	IniReadS($g_iChkBBSuggestedUpgradesIgnoreWall, $g_sProfileConfigPath, "other", "ChkBBSuggestedUpgradesIgnoreWall", $g_iChkBBSuggestedUpgradesIgnoreWall, "Int")

	IniReadS($g_iChkPlacingNewBuildings, $g_sProfileConfigPath, "other", "ChkPlacingNewBuildings", $g_iChkPlacingNewBuildings, "Int")

	; BOB Building Upgrades
	IniReadS($g_bBattleMachineUpgrade, $g_sProfileConfigPath, "other", "chkBattleMachineUpgrade", False, "Bool")
	IniReadS($g_bDoubleCannonUpgrade, $g_sProfileConfigPath, "other", "chkDoubleCannonUpgrade", False, "Bool")
	IniReadS($g_bArcherTowerUpgrade, $g_sProfileConfigPath, "other", "chkArcherTowerUpgrade", False, "Bool")
	IniReadS($g_bMultiMortarUpgrade, $g_sProfileConfigPath, "other", "chkMultiMortarUpgrade", False, "Bool")
	IniReadS($g_bBattlecopterUpgrade, $g_sProfileConfigPath, "other", "chkBattlecopterUpgrade", False, "Bool")
	IniReadS($g_bAnyDefUpgrade, $g_sProfileConfigPath, "other", "chkAnyDefUpgrade", False, "Bool")

	; Builder Base Attack
	IniReadS($g_bChkEnableBBAttack, $g_sProfileConfigPath, "other", "ChkEnableBBAttack", False, "Bool")
	IniReadS($g_bChkBBTrophyRange, $g_sProfileConfigPath, "other", "ChkBBTrophyRange", False, "Bool")
	IniReadS($g_iTxtBBTrophyLowerLimit, $g_sProfileConfigPath, "other", "TxtBBTrophyLowerLimit", 0, "int")
	IniReadS($g_iTxtBBTrophyUpperLimit, $g_sProfileConfigPath, "other", "TxtBBTrophyUpperLimit", 5000, "int")
	IniReadS($g_bChkBBAttIfLootAvail, $g_sProfileConfigPath, "other", "ChkBBAttIfLootAvail", False, "Bool")

	IniReadS($g_bChkBBHaltOnGoldFull, $g_sProfileConfigPath, "other", "ChkBBHaltOnGoldFull", False, "Bool")
	IniReadS($g_bChkBBHaltOnElixirFull, $g_sProfileConfigPath, "other", "ChkBBHaltOnElixirFull", False, "Bool")

	IniReadS($g_bChkBBWaitForMachine, $g_sProfileConfigPath, "other", "ChkBBWaitForMachine", False, "Bool")
	IniReadS($g_iBBNextTroopDelay, $g_sProfileConfigPath, "other", "iBBNextTroopDelay", $g_iBBNextTroopDelayDefault, "int")
	IniReadS($g_iBBSameTroopDelay, $g_sProfileConfigPath, "other", "iBBSameTroopDelay", $g_iBBSameTroopDelayDefault, "int")
	IniReadS($g_iBBAttackCount, $g_sProfileConfigPath, "other", "iBBAttackCount", 6, "int")

	; Builder Base Drop Order
	IniReadS($g_bBBDropOrderSet, $g_sProfileConfigPath, "other", "bBBDropOrderSet", False, "Bool")
	$g_sBBDropOrder = IniRead($g_sProfileConfigPath, "other", "sBBDropOrder", $g_sBBDropOrderDefault)

	;Clan Capital
	IniReadS($g_bChkEnableCollectCCGold, $g_sProfileConfigPath, "ClanCapital", "ChkCollectCCGold", False, "Bool")
	IniReadS($g_bChkEnableForgeGold, $g_sProfileConfigPath, "ClanCapital", "ChkEnableForgeGold", False, "Bool")
	IniReadS($g_bChkEnableForgeElix, $g_sProfileConfigPath, "ClanCapital", "ChkEnableForgeElix", False, "Bool")
	IniReadS($g_bChkEnableForgeDE, $g_sProfileConfigPath, "ClanCapital", "ChkEnableForgeDE", False, "Bool")
	IniReadS($g_bChkEnableForgeBBGold, $g_sProfileConfigPath, "ClanCapital", "ChkEnableForgeBBGold", False, "Bool")
	IniReadS($g_bChkEnableForgeBBElix, $g_sProfileConfigPath, "ClanCapital", "ChkEnableForgeBBElix", False, "Bool")
	IniReadS($g_bChkEnableSmartUse, $g_sProfileConfigPath, "ClanCapital", "ChkEnableSmartUse", False, "Bool")
	IniReadS($g_iacmdGoldSaveMin, $g_sProfileConfigPath, "ClanCapital", "cmdGoldSaveMin", $g_iacmdGoldSaveMin, "int")
	IniReadS($g_iacmdElixSaveMin, $g_sProfileConfigPath, "ClanCapital", "cmdElixSaveMin", $g_iacmdElixSaveMin, "int")
	IniReadS($g_iacmdDarkSaveMin, $g_sProfileConfigPath, "ClanCapital", "cmdDarkSaveMin", $g_iacmdDarkSaveMin, "int")
	IniReadS($g_iacmdBBGoldSaveMin, $g_sProfileConfigPath, "ClanCapital", "cmdBBGoldSaveMin", $g_iacmdBBGoldSaveMin, "int")
	IniReadS($g_iacmdBBElixSaveMin, $g_sProfileConfigPath, "ClanCapital", "cmdBBElixSaveMin", $g_iacmdBBElixSaveMin, "int")
	IniReadS($g_iCmbForgeBuilder, $g_sProfileConfigPath, "ClanCapital", "ForgeUseBuilder", 0, "int")
	IniReadS($g_bChkEnableAutoUpgradeCC, $g_sProfileConfigPath, "ClanCapital", "AutoUpgradeCC", False, "Bool")
	IniReadS($g_bChkAutoUpgradeCCIgnore, $g_sProfileConfigPath, "ClanCapital", "ChkAutoUpgradeCCIgnore", False, "Bool")
	IniReadS($g_bChkAutoUpgradeCCWallIgnore, $g_sProfileConfigPath, "ClanCapital", "ChkAutoUpgradeCCWallIgnore", False, "Bool")
	IniReadS($g_bChkAutoUpgradeCCPriorArmy, $g_sProfileConfigPath, "ClanCapital", "ChkAutoUpgradeCCPriorArmy", False, "Bool")
EndFunc   ;==>ReadConfig_600_6

Func ReadConfig_600_9()
	; <><><><> Village / Achievements <><><><>
	IniReadS($g_iUnbrkMode, $g_sProfileConfigPath, "Unbreakable", "chkUnbreakable", 0, "int")
	IniReadS($g_iUnbrkWait, $g_sProfileConfigPath, "Unbreakable", "UnbreakableWait", 5, "int")
	IniReadS($g_iUnbrkMinGold, $g_sProfileConfigPath, "Unbreakable", "minUnBrkgold", 50000, "int")
	IniReadS($g_iUnbrkMaxGold, $g_sProfileConfigPath, "Unbreakable", "maxUnBrkgold", 600000, "int")
	IniReadS($g_iUnbrkMinElixir, $g_sProfileConfigPath, "Unbreakable", "minUnBrkelixir", 50000, "int")
	IniReadS($g_iUnbrkMaxElixir, $g_sProfileConfigPath, "Unbreakable", "maxUnBrkelixir", 600000, "int")
	IniReadS($g_iUnbrkMinDark, $g_sProfileConfigPath, "Unbreakable", "minUnBrkdark", 5000, "int")
	IniReadS($g_iUnbrkMaxDark, $g_sProfileConfigPath, "Unbreakable", "maxUnBrkdark", 10000, "int")
EndFunc   ;==>ReadConfig_600_9

Func ReadConfig_600_11()
	; <><><><> Village / Donate - Request <><><><>
	$g_bRequestTroopsEnable = (IniRead($g_sProfileConfigPath, "planned", "RequestHoursEnable", "0") = "1")
	$g_sRequestTroopsText = IniRead($g_sProfileConfigPath, "donate", "txtRequest", "")
	; Request Type - Demen
	$g_abRequestType[0] = (IniRead($g_sProfileConfigPath, "donate", "RequestType_Troop", "0") = "1")
	$g_abRequestType[1] = (IniRead($g_sProfileConfigPath, "donate", "RequestType_Spell", "0") = "1")
	$g_abRequestType[2] = (IniRead($g_sProfileConfigPath, "donate", "RequestType_Siege", "0") = "1")
	$g_iRequestCountCCTroop = Int(IniRead($g_sProfileConfigPath, "donate", "RequestCountCC_Troop", "0"))
	$g_iRequestCountCCSpell = Int(IniRead($g_sProfileConfigPath, "donate", "RequestCountCC_Spell", "0"))
	For $i = 0 To $eTroopCount - 1
		$g_aiCCTroopsExpected[$i] = 0
		If $i < $eSpellCount Then $g_aiCCSpellsExpected[$i] = 0
		If $i < $eSiegeMachineCount Then $g_aiCCSiegeExpected[$i] = 0
	Next
	For $i = 0 To 2
		$g_aiClanCastleTroopWaitType[$i] = Int(IniRead($g_sProfileConfigPath, "donate", "cmbClanCastleTroop" & $i, "0"))
		$g_aiClanCastleTroopWaitQty[$i] = Int(IniRead($g_sProfileConfigPath, "donate", "txtClanCastleTroop" & $i, "0"))
		If $g_aiClanCastleTroopWaitType[$i] > 0 Then ; Barb - Hunt
			$g_aiCCTroopsExpected[$g_aiClanCastleTroopWaitType[$i] - 1] += $g_aiClanCastleTroopWaitQty[$i]
		EndIf

		$g_aiClanCastleSpellWaitType[$i] = Int(IniRead($g_sProfileConfigPath, "donate", "cmbClanCastleSpell" & $i, "0"))
		If $g_aiClanCastleSpellWaitType[$i] > 0 Then ; LSpell - OgSpell
			$g_aiCCSpellsExpected[$g_aiClanCastleSpellWaitType[$i] - 1] += 1
		EndIf

		If $i > 1 Then ContinueLoop ; Siege has only 2 combobox
		$g_aiClanCastleSiegeWaitType[$i] = Int(IniRead($g_sProfileConfigPath, "donate", "cmbClanCastleSiege" & $i, "0"))
		If $g_aiClanCastleSiegeWaitType[$i] > 0 Then $g_aiCCSiegeExpected[$g_aiClanCastleSiegeWaitType[$i] - 1] = 1 ; WallW - StoneS
	Next

	$g_abRequestCCHours = StringSplit(IniRead($g_sProfileConfigPath, "planned", "RequestHours", "1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1"), "|", $STR_NOCOUNT)
	For $i = 0 To 23
		$g_abRequestCCHours[$i] = ($g_abRequestCCHours[$i] = "1")
	Next
EndFunc   ;==>ReadConfig_600_11

Func ReadConfig_600_12()
	; <><><><> Village / Donate - Donate <><><><>
	IniReadS($g_bChkDonate, $g_sProfileConfigPath, "donate", "Doncheck", True, "Bool")
	IniReadS($g_abChkDonateQueueOnly[0], $g_sProfileConfigPath, "donate", "chkDonateQueueOnly[0]", True, "Bool")
	IniReadS($g_abChkDonateQueueOnly[1], $g_sProfileConfigPath, "donate", "chkDonateQueueOnly[1]", True, "Bool")
	For $i = 0 To $eTroopCount - 1 + $g_iCustomDonateConfigs
		Local $sIniName = ""
		If $i >= $eTroopBarbarian And $i <= $eTroopAppWard Then
			$sIniName = StringReplace($g_asTroopNamesPlural[$i], " ", "")
		ElseIf $i = $eCustomA Then
			$sIniName = "CustomA"
		ElseIf $i = $eCustomB Then
			$sIniName = "CustomB"
		EndIf
		$g_abChkDonateTroop[$i] = (IniRead($g_sProfileConfigPath, "donate", "chkDonate" & $sIniName, "0") = "1")
		$g_abChkDonateAllTroop[$i] = (IniRead($g_sProfileConfigPath, "donate", "chkDonateAll" & $sIniName, "0") = "1")
		$g_asTxtDonateTroop[$i] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonate" & $sIniName, $g_asTxtDonateTroop[$i]), "|", @CRLF)
		$g_asTxtBlacklistTroop[$i] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklist" & $sIniName, $g_asTxtBlacklistTroop[$i]), "|", @CRLF)
	Next

	For $i = 0 To $eSpellCount - 1
		Local $sIniName = $g_asSpellNames[$i] & "Spells"
		$g_abChkDonateSpell[$i] = (IniRead($g_sProfileConfigPath, "donate", "chkDonate" & $sIniName, "0") = "1")
		$g_abChkDonateAllSpell[$i] = (IniRead($g_sProfileConfigPath, "donate", "chkDonateAll" & $sIniName, "0") = "1")
		$g_asTxtDonateSpell[$i] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonate" & $sIniName, $g_asTxtDonateSpell[$i]), "|", @CRLF)
		$g_asTxtBlacklistSpell[$i] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklist" & $sIniName, $g_asTxtBlacklistSpell[$i]), "|", @CRLF)
	Next

	For $i = $eSiegeWallWrecker To $eSiegeMachineCount - 1
		Local $index = $eTroopCount + $g_iCustomDonateConfigs
		Local $sIniName = $g_asSiegeMachineShortNames[$i]
		$g_abChkDonateTroop[$index + $i] = (IniRead($g_sProfileConfigPath, "donate", "chkDonate" & $sIniName, "0") = "1")
		$g_abChkDonateAllTroop[$index + $i] = (IniRead($g_sProfileConfigPath, "donate", "chkDonateAll" & $sIniName, "0") = "1")
		$g_asTxtDonateTroop[$index + $i] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonate" & $sIniName, $g_asTxtDonateTroop[$index + $i]), "|", @CRLF)
		$g_asTxtBlacklistTroop[$index + $i] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklist" & $sIniName, $g_asTxtBlacklistTroop[$index + $i]), "|", @CRLF)
	Next

	$g_aiDonateCustomTrpNumA[0][0] = Int(IniRead($g_sProfileConfigPath, "donate", "cmbDonateCustomA1", 12))
	$g_aiDonateCustomTrpNumA[1][0] = Int(IniRead($g_sProfileConfigPath, "donate", "cmbDonateCustomA2", 2))
	$g_aiDonateCustomTrpNumA[2][0] = Int(IniRead($g_sProfileConfigPath, "donate", "cmbDonateCustomA3", 0))
	$g_aiDonateCustomTrpNumA[0][1] = Int(IniRead($g_sProfileConfigPath, "donate", "txtDonateCustomA1", 2))
	$g_aiDonateCustomTrpNumA[1][1] = Int(IniRead($g_sProfileConfigPath, "donate", "txtDonateCustomA2", 3))
	$g_aiDonateCustomTrpNumA[2][1] = Int(IniRead($g_sProfileConfigPath, "donate", "txtDonateCustomA3", 1))

	$g_aiDonateCustomTrpNumB[0][0] = Int(IniRead($g_sProfileConfigPath, "donate", "cmbDonateCustomB1", 18))
	$g_aiDonateCustomTrpNumB[1][0] = Int(IniRead($g_sProfileConfigPath, "donate", "cmbDonateCustomB2", 9))
	$g_aiDonateCustomTrpNumB[2][0] = Int(IniRead($g_sProfileConfigPath, "donate", "cmbDonateCustomB3", 25))
	$g_aiDonateCustomTrpNumB[0][1] = Int(IniRead($g_sProfileConfigPath, "donate", "txtDonateCustomB1", 3))
	$g_aiDonateCustomTrpNumB[1][1] = Int(IniRead($g_sProfileConfigPath, "donate", "txtDonateCustomB2", 13))
	$g_aiDonateCustomTrpNumB[2][1] = Int(IniRead($g_sProfileConfigPath, "donate", "txtDonateCustomB3", 5))

	$g_bChkExtraAlphabets = (IniRead($g_sProfileConfigPath, "donate", "chkExtraAlphabets", "0") = "1")
	$g_bChkExtraChinese = (IniRead($g_sProfileConfigPath, "donate", "chkExtraChinese", "0") = "1")
	$g_bChkExtraKorean = (IniRead($g_sProfileConfigPath, "donate", "chkExtraKorean", "0") = "1")
	$g_bChkExtraPersian = (IniRead($g_sProfileConfigPath, "donate", "chkExtraPersian", "0") = "1")

	$g_sTxtGeneralBlacklist = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklist", "clan war|war|cw"), "|", @CRLF)
EndFunc   ;==>ReadConfig_600_12

Func ReadConfig_600_13()
	; <><><><> Village / Donate - Schedule <><><><>
	$g_bDonateHoursEnable = (IniRead($g_sProfileConfigPath, "planned", "DonateHoursEnable", "0") = "1")
	$g_abDonateHours = StringSplit(IniRead($g_sProfileConfigPath, "planned", "DonateHours", "1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1"), "|", $STR_NOCOUNT)
	For $i = 0 To 23
		$g_abDonateHours[$i] = ($g_abDonateHours[$i] = "1")
	Next
	$g_iCmbDonateFilter = Int(IniRead($g_sProfileConfigPath, "donate", "cmbFilterDonationsCC", 0))
	$g_iDonateSkipNearFullPercent = Int(IniRead($g_sProfileConfigPath, "donate", "SkipDonateNearFulLTroopsPercentual", 90))
	$g_bDonateSkipNearFullEnable = (IniRead($g_sProfileConfigPath, "donate", "SkipDonateNearFulLTroopsEnable", "1") = "1")
	IniReadS($g_bUseCCBalanced, $g_sProfileConfigPath, "donate", "BalanceCC", False, "Bool")
	IniReadS($g_iCCDonated, $g_sProfileConfigPath, "donate", "BalanceCCDonated", 1, "int")
	IniReadS($g_iCCReceived, $g_sProfileConfigPath, "donate", "BalanceCCReceived", 1, "int")
	IniReadS($g_bCheckDonateOften, $g_sProfileConfigPath, "donate", "CheckDonateOften", False, "Bool")
EndFunc   ;==>ReadConfig_600_13

Func ReadConfig_600_14()
	IniReadS($g_bAutoLabUpgradeEnable, $g_sProfileBuildingPath, "upgrade", "upgradetroops", False, "Bool")
	IniReadS($g_iCmbLaboratory, $g_sProfileBuildingPath, "upgrade", "upgradetroopname", 0, "int")
	;IniReadS($g_iLaboratoryElixirCost, $g_sProfileBuildingPath, "upgrade", "upgradelabelexircost", 0, "int")
	;IniReadS($g_iLaboratoryDElixirCost, $g_sProfileBuildingPath, "upgrade", "upgradelabdelexircost", 0, "int")
	IniReadS($g_bAutoStarLabUpgradeEnable, $g_sProfileBuildingPath, "upgrade", "upgradestartroops", False, "Bool")
	IniReadS($g_iCmbStarLaboratory, $g_sProfileBuildingPath, "upgrade", "upgradestartroopname", 0, "int")
EndFunc   ;==>ReadConfig_600_14

Func ReadConfig_600_15()
	; <><><><> Village / Upgrade - Heroes <><><><>
	IniReadS($g_bUpgradeKingEnable, $g_sProfileConfigPath, "upgrade", "UpgradeKing", False, "Bool")
	IniReadS($g_bUpgradeQueenEnable, $g_sProfileConfigPath, "upgrade", "UpgradeQueen", False, "Bool")
	IniReadS($g_bUpgradeWardenEnable, $g_sProfileConfigPath, "upgrade", "UpgradeWarden", False, "Bool")
	IniReadS($g_bUpgradeChampionEnable, $g_sProfileConfigPath, "upgrade", "UpgradeChampion", False, "Bool")
	IniReadS($g_iHeroReservedBuilder, $g_sProfileConfigPath, "upgrade", "HeroReservedBuilder", 0, "int")

	; Equipment Order
	IniReadS($g_bChkCustomEquipmentOrderEnable, $g_sProfileConfigPath, "upgrade", "ChkUpgradeEquipment", False, "Bool")
	For $z = 0 To UBound($g_aiCmbCustomEquipmentOrder) - 1
		IniReadS($g_bChkCustomEquipmentOrder[$z], $g_sProfileConfigPath, "upgrade", "ChkEquipment" & $z, False, "Bool")
		IniReadS($g_aiCmbCustomEquipmentOrder[$z], $g_sProfileConfigPath, "upgrade", "cmbEquipmentOrder" & $z, -1)
	Next

	For $i = 0 To $ePetCount - 1
		IniReadS($g_bUpgradePetsEnable[$i], $g_sProfileConfigPath, "upgrade", "UpgradePet[" & $g_asPetShortNames[$i] & "]", False, "Bool")
	Next
EndFunc   ;==>ReadConfig_600_15

Func ReadConfig_600_16()
	; <><><><> Village / Upgrade - Buildings <><><><>
	IniReadS($g_iUpgradeMinGold, $g_sProfileConfigPath, "upgrade", "minupgrgold", 150000, "int")
	IniReadS($g_iUpgradeMinElixir, $g_sProfileConfigPath, "upgrade", "minupgrelixir", 1000, "int")
	IniReadS($g_iUpgradeMinDark, $g_sProfileConfigPath, "upgrade", "minupgrdark", 1000, "int")
	; The other building settings are loaded in the ReadBuildingConfig() function
EndFunc   ;==>ReadConfig_600_16

Func ReadConfig_auto()
	; Auto Upgrade
	IniReadS($g_bAutoUpgradeEnabled, $g_sProfileConfigPath, "Auto Upgrade", "AutoUpgradeEnabled", False, "Bool")
	For $i = 0 To UBound($g_iChkUpgradesToIgnore) - 1
		IniReadS($g_iChkUpgradesToIgnore[$i], $g_sProfileConfigPath, "Auto Upgrade", "ChkUpgradesToIgnore[" & $i & "]", $g_iChkUpgradesToIgnore[$i], "int")
	Next
	For $i = 0 To 2
		IniReadS($g_iChkResourcesToIgnore[$i], $g_sProfileConfigPath, "Auto Upgrade", "ChkResourcesToIgnore[" & $i & "]", $g_iChkResourcesToIgnore[$i], "int")
	Next
	IniReadS($g_iTxtSmartMinGold, $g_sProfileConfigPath, "Auto Upgrade", "SmartMinGold", 150000, "int")
	IniReadS($g_iTxtSmartMinElixir, $g_sProfileConfigPath, "Auto Upgrade", "SmartMinElixir", 1000, "int")
	IniReadS($g_iTxtSmartMinDark, $g_sProfileConfigPath, "Auto Upgrade", "SmartMinDark", 1000, "int")
EndFunc   ;==>ReadConfig_auto

Func ReadConfig_600_17()
	; <><><><> Village / Upgrade - Walls <><><><>
	IniReadS($g_bAutoUpgradeWallsEnable, $g_sProfileConfigPath, "upgrade", "auto-wall", False, "Bool")
	IniReadS($g_iUpgradeWallMinGold, $g_sProfileConfigPath, "upgrade", "minwallgold", 0, "int")
	IniReadS($g_iUpgradeWallMinElixir, $g_sProfileConfigPath, "upgrade", "minwallelixir", 0, "int")
	IniReadS($g_iUpgradeWallLootType, $g_sProfileConfigPath, "upgrade", "use-storage", 0, "int")
	IniReadS($g_bUpgradeWallSaveBuilder, $g_sProfileConfigPath, "upgrade", "savebldr", False, "Bool")
	IniReadS($g_iCmbUpgradeWallsLevel, $g_sProfileConfigPath, "upgrade", "walllvl", 6, "int")
	For $i = 4 To 17
		IniReadS($g_aiWallsCurrentCount[$i], $g_sProfileConfigPath, "Walls", "Wall" & StringFormat("%02d", $i), 0, "int")
	Next
	IniReadS($g_iWallCost, $g_sProfileConfigPath, "upgrade", "WallCost", 0, "int")
EndFunc   ;==>ReadConfig_600_17

Func ReadConfig_600_18()
	; <><><><> Village / Notify <><><><>
	;Telegram
	IniReadS($g_bNotifyTGEnable, $g_sProfileConfigPath, "notify", "TGEnabled", False, "Bool")
	IniReadS($g_sNotifyTGToken, $g_sProfileConfigPath, "notify", "TGToken", "")
	IniReadS($g_sTGChatID, $g_sProfileConfigPath, "notify", "TGUserID", "")

	;Remote Control
	IniReadS($g_bNotifyRemoteEnable, $g_sProfileConfigPath, "notify", "PBRemote", False, "Bool")
	IniReadS($g_sNotifyOrigin, $g_sProfileConfigPath, "notify", "Origin", $g_sProfileCurrentName)
	IniReadS($g_iNotifyDeletePushesOlderThanHours, $g_sProfileConfigPath, "notify", "HoursPushBullet", 4, "int")
	;Alerts
	IniReadS($g_bNotifyAlertMatchFound, $g_sProfileConfigPath, "notify", "AlertPBVMFound", False, "Bool")
	IniReadS($g_bNotifyAlerLastRaidIMG, $g_sProfileConfigPath, "notify", "AlertPBLastRaid", False, "Bool")
	IniReadS($g_bNotifyAlerLastRaidTXT, $g_sProfileConfigPath, "notify", "AlertPBLastRaidTxt", False, "Bool")
	IniReadS($g_bNotifyAlertCampFull, $g_sProfileConfigPath, "notify", "AlertPBCampFull", False, "Bool")
	IniReadS($g_bNotifyAlertUpgradeWalls, $g_sProfileConfigPath, "notify", "AlertPBWallUpgrade", False, "Bool")
	IniReadS($g_bNotifyAlertOutOfSync, $g_sProfileConfigPath, "notify", "AlertPBOOS", False, "Bool")
	IniReadS($g_bNotifyAlertTakeBreak, $g_sProfileConfigPath, "notify", "AlertPBVBreak", False, "Bool")
	IniReadS($g_bNotifyAlertBulderIdle, $g_sProfileConfigPath, "notify", "AlertBuilderIdle", False, "Bool")
	IniReadS($g_bNotifyAlertVillageReport, $g_sProfileConfigPath, "notify", "AlertPBVillage", False, "Bool")
	IniReadS($g_bNotifyAlertLastAttack, $g_sProfileConfigPath, "notify", "AlertPBLastAttack", False, "Bool")
	IniReadS($g_bNotifyAlertAnotherDevice, $g_sProfileConfigPath, "notify", "AlertPBOtherDevice", False, "Bool")
	IniReadS($g_bNotifyAlertMaintenance, $g_sProfileConfigPath, "notify", "AlertPBMaintenance", False, "Bool")
	IniReadS($g_bNotifyAlertBAN, $g_sProfileConfigPath, "notify", "AlertPBBAN", False, "Bool")
	IniReadS($g_bNotifyAlertBOTUpdate, $g_sProfileConfigPath, "notify", "AlertPBUpdate", False, "Bool")
	IniReadS($g_bNotifyAlertSmartWaitTime, $g_sProfileConfigPath, "notify", "AlertSmartWaitTime", False, "Bool")
	IniReadS($g_bNotifyAlertLaboratoryIdle, $g_sProfileConfigPath, "notify", "AlertLaboratoryIdle", False, "Bool")
EndFunc   ;==>ReadConfig_600_18

Func ReadConfig_600_19()
	; <><><><> Village / Notify <><><><>
	;Schedule
	$g_bNotifyScheduleHoursEnable = (IniRead($g_sProfileConfigPath, "notify", "NotifyHoursEnable", "0") = "1")
	$g_abNotifyScheduleHours = StringSplit(IniRead($g_sProfileConfigPath, "notify", "NotifyHours", "1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1"), "|", $STR_NOCOUNT)
	For $i = 0 To 23
		$g_abNotifyScheduleHours[$i] = ($g_abNotifyScheduleHours[$i] = "1")
	Next
	$g_bNotifyScheduleWeekDaysEnable = (IniRead($g_sProfileConfigPath, "notify", "NotifyWeekDaysEnable", "0") = "1")
	$g_abNotifyScheduleWeekDays = StringSplit(IniRead($g_sProfileConfigPath, "notify", "NotifyWeekDays", "1|1|1|1|1|1|1"), "|", $STR_NOCOUNT)
	For $i = 0 To 6
		$g_abNotifyScheduleWeekDays[$i] = ($g_abNotifyScheduleWeekDays[$i] = "1")
	Next
EndFunc   ;==>ReadConfig_600_19

Func ReadConfig_600_22()
	; <><><><> Attack Plan / Train Army / Boost <><><><>
	$g_abBoostBarracksHours = StringSplit(IniRead($g_sProfileConfigPath, "planned", "BoostBarracksHours", "1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1"), "|", $STR_NOCOUNT)
	For $i = 0 To 23
		$g_abBoostBarracksHours[$i] = ($g_abBoostBarracksHours[$i] = "1")
	Next
	IniReadS($g_bSuperTroopsEnable, $g_sProfileConfigPath, "SuperTroopsBoost", "SuperTroopsEnable", False, "Bool")
	IniReadS($g_bSkipBoostSuperTroopOnHalt, $g_sProfileConfigPath, "SuperTroopsBoost", "SkipSuperTroopsBoostOnHalt", False, "Bool")
	IniReadS($g_bSuperTroopsBoostUsePotionFirst, $g_sProfileConfigPath, "SuperTroopsBoost", "SuperTroopsBoostUsePotionFirst", False, "Bool")

	For $i = 0 To $iMaxSupersTroop - 1
		$g_iCmbSuperTroops[$i] = Int(IniRead($g_sProfileConfigPath, "SuperTroopsBoost", "SuperTroopsIndex" & $i, 0))
	Next
	; Note: These global variables are not stored to the ini file, to prevent automatic boosting (and spending of gems) when the bot is started:
	; $g_iCmbBoostBarracks, $g_iCmbBoostSpellFactory, $g_iCmbBoostWorkshop, $g_iCmbBoostBarbarianKing, $g_iCmbBoostArcherQueen, $g_iCmbBoostWarden
EndFunc   ;==>ReadConfig_600_22

Func ReadConfig_600_26()
	; <><><><> Attack Plan / Search & Attack / Bully <><><><>
	IniReadS($g_abAttackTypeEnable[$TB], $g_sProfileConfigPath, "search", "BullyMode", False, "Bool")
	IniReadS($g_iAtkTBEnableCount, $g_sProfileConfigPath, "search", "ATBullyMode", 0, "int")
	IniReadS($g_iAtkTBMaxTHLevel, $g_sProfileConfigPath, "search", "YourTH", 0, "int")
	IniReadS($g_iAtkTBMode, $g_sProfileConfigPath, "search", "THBullyAttackMode", 0, "int")
EndFunc   ;==>ReadConfig_600_26

Func ReadConfig_600_28()
	; <><><><> Attack Plan / Search & Attack / Options / Search <><><><>
	IniReadS($g_bSearchReductionEnable, $g_sProfileConfigPath, "search", "reduction", False, "Bool")
	IniReadS($g_iSearchReductionCount, $g_sProfileConfigPath, "search", "reduceCount", 20, "int")
	IniReadS($g_iSearchReductionGold, $g_sProfileConfigPath, "search", "reduceGold", 2000, "int")
	IniReadS($g_iSearchReductionElixir, $g_sProfileConfigPath, "search", "reduceElixir", 2000, "int")
	IniReadS($g_iSearchReductionGoldPlusElixir, $g_sProfileConfigPath, "search", "reduceGoldPlusElixir", 4000, "int")
	IniReadS($g_iSearchReductionDark, $g_sProfileConfigPath, "search", "reduceDark", 100, "int")
	IniReadS($g_iSearchReductionTrophy, $g_sProfileConfigPath, "search", "reduceTrophy", 2, "int")
	IniReadS($g_iSearchDelayMin, $g_sProfileConfigPath, "other", "VSDelay", 0, "Int")
	IniReadS($g_iSearchDelayMax, $g_sProfileConfigPath, "other", "MaxVSDelay", 4, "Int")
	IniReadS($g_bSearchAttackNowEnable, $g_sProfileConfigPath, "general", "AttackNow", False, "Bool")
	IniReadS($g_iSearchAttackNowDelay, $g_sProfileConfigPath, "general", "attacknowdelay", 3, "int")
	IniReadS($g_bSearchRestartEnable, $g_sProfileConfigPath, "search", "ChkRestartSearchLimit", True, "Bool")
	IniReadS($g_iSearchRestartLimit, $g_sProfileConfigPath, "search", "RestartSearchLimit", 50, "int")
	IniReadS($g_bSearchRestartPickupHero, $g_sProfileConfigPath, "search", "RestartSearchPickupHero", False, "Bool")
	IniReadS($g_bSearchAlertMe, $g_sProfileConfigPath, "general", "AlertSearch", False, "Bool")
EndFunc   ;==>ReadConfig_600_28

Func ReadConfig_600_28_DB()
	; <><><><> Attack Plan / Search & Attack / Deadbase / Search <><><><>
	IniReadS($g_abAttackTypeEnable[$DB], $g_sProfileConfigPath, "search", "DBcheck", True, "Bool")
	; Search - Start Search If
	IniReadS($g_abSearchSearchesEnable[$DB], $g_sProfileConfigPath, "search", "ChkDBSearchSearches", True, "Bool")
	IniReadS($g_aiSearchSearchesMin[$DB], $g_sProfileConfigPath, "search", "DBEnableAfterCount", 1, "int")
	IniReadS($g_aiSearchSearchesMax[$DB], $g_sProfileConfigPath, "search", "DBEnableBeforeCount", 9999, "int")
	IniReadS($g_abSearchTropiesEnable[$DB], $g_sProfileConfigPath, "search", "ChkDBSearchTropies", False, "Bool")
	IniReadS($g_aiSearchTrophiesMin[$DB], $g_sProfileConfigPath, "search", "DBEnableAfterTropies", 100, "int")
	IniReadS($g_aiSearchTrophiesMax[$DB], $g_sProfileConfigPath, "search", "DBEnableBeforeTropies", 6000, "int")
	IniReadS($g_abSearchCampsEnable[$DB], $g_sProfileConfigPath, "search", "ChkDBSearchCamps", False, "Bool")
	IniReadS($g_aiSearchCampsPct[$DB], $g_sProfileConfigPath, "search", "DBEnableAfterArmyCamps", 100, "int")
	Local $temp1, $temp2, $temp3, $temp4
	IniReadS($temp1, $g_sProfileConfigPath, "attack", "DBKingWait", $eHeroNone)
	IniReadS($temp2, $g_sProfileConfigPath, "attack", "DBQueenWait", $eHeroNone)
	IniReadS($temp3, $g_sProfileConfigPath, "attack", "DBWardenWait", $eHeroNone)
	IniReadS($temp4, $g_sProfileConfigPath, "attack", "DBChampionWait", $eHeroNone)
	$g_aiSearchHeroWaitEnable[$DB] = BitOR(Int($temp1 > $eHeroNone ? $eHeroKing : 0), Int($temp2 > $eHeroNone ? $eHeroQueen : 0), Int($temp3 > $eHeroNone ? $eHeroWarden : 0), Int($temp4 > $eHeroNone ? $eHeroChampion : 0))
	IniReadS($g_aiSearchNotWaitHeroesEnable[$DB], $g_sProfileConfigPath, "attack", "DBNotWaitHeroes", 0, "int")
	$g_iHeroWaitAttackNoBit[$DB][0] = ($temp1 > $eHeroNone) ? 1 : 0
	$g_iHeroWaitAttackNoBit[$DB][1] = ($temp2 > $eHeroNone) ? 1 : 0
	$g_iHeroWaitAttackNoBit[$DB][2] = ($temp3 > $eHeroNone) ? 1 : 0
	$g_iHeroWaitAttackNoBit[$DB][3] = ($temp4 > $eHeroNone) ? 1 : 0
	IniReadS($g_abSearchSpellsWaitEnable[$DB], $g_sProfileConfigPath, "search", "ChkDBSpellsWait", False, "Bool")
	IniReadS($g_abSearchCastleWaitEnable[$DB], $g_sProfileConfigPath, "search", "ChkDBCastleWait", False, "Bool")
	; Search - Filters
	IniReadS($g_aiFilterMeetGE[$DB], $g_sProfileConfigPath, "search", "DBMeetGE", 1, "int")
	IniReadS($g_aiFilterMinGold[$DB], $g_sProfileConfigPath, "search", "DBsearchGold", 80000, "int")
	IniReadS($g_aiFilterMinElixir[$DB], $g_sProfileConfigPath, "search", "DBsearchElixir", 80000, "int")
	IniReadS($g_aiFilterMinGoldPlusElixir[$DB], $g_sProfileConfigPath, "search", "DBsearchGoldPlusElixir", 160000, "int")
	IniReadS($g_abFilterMeetDEEnable[$DB], $g_sProfileConfigPath, "search", "DBMeetDE", False, "Bool")
	IniReadS($g_aiFilterMeetDEMin[$DB], $g_sProfileConfigPath, "search", "DBsearchDark", 0, "int")
	IniReadS($g_abFilterMeetTrophyEnable[$DB], $g_sProfileConfigPath, "search", "DBMeetTrophy", False, "Bool")
	IniReadS($g_aiFilterMeetTrophyMin[$DB], $g_sProfileConfigPath, "search", "DBsearchTrophy", 0, "int")
	IniReadS($g_aiFilterMeetTrophyMax[$DB], $g_sProfileConfigPath, "search", "DBsearchTrophyMax", 99, "int")
	IniReadS($g_abFilterMeetTH[$DB], $g_sProfileConfigPath, "search", "DBMeetTH", False, "Bool")
	IniReadS($g_aiFilterMeetTHMin[$DB], $g_sProfileConfigPath, "search", "DBTHLevel", 0, "int")
	IniReadS($g_abFilterMeetTHOutsideEnable[$DB], $g_sProfileConfigPath, "search", "DBMeetTHO", False, "Bool")

	IniReadS($g_bChkDeadEagle, $g_sProfileConfigPath, "search", "DBMeetDeadEagle", False, "Bool")
	IniReadS($g_iDeadEagleSearch, $g_sProfileConfigPath, "search", "DBMeetDeadEagleSearch", 99, "int")

	IniReadS($g_abFilterMaxMortarEnable[$DB], $g_sProfileConfigPath, "search", "DBCheckMortar", False, "Bool")
	IniReadS($g_abFilterMaxWizTowerEnable[$DB], $g_sProfileConfigPath, "search", "DBCheckWizTower", False, "Bool")
	IniReadS($g_abFilterMaxAirDefenseEnable[$DB], $g_sProfileConfigPath, "search", "DBCheckAirDefense", False, "Bool")
	IniReadS($g_abFilterMaxXBowEnable[$DB], $g_sProfileConfigPath, "search", "DBCheckXBow", False, "Bool")
	IniReadS($g_abFilterMaxInfernoEnable[$DB], $g_sProfileConfigPath, "search", "DBCheckInferno", False, "Bool")
	IniReadS($g_abFilterMaxEagleEnable[$DB], $g_sProfileConfigPath, "search", "DBCheckEagle", False, "Bool")
	IniReadS($g_abFilterMaxScatterEnable[$DB], $g_sProfileConfigPath, "search", "DBCheckScatter", False, "Bool")
	IniReadS($g_abFilterMaxMonolithEnable[$DB], $g_sProfileConfigPath, "search", "DBCheckMonolith", False, "Bool")
	IniReadS($g_aiFilterMaxMortarLevel[$DB], $g_sProfileConfigPath, "search", "DBWeakMortar", 5, "int")
	IniReadS($g_aiFilterMaxWizTowerLevel[$DB], $g_sProfileConfigPath, "search", "DBWeakWizTower", 4, "int")
	IniReadS($g_aiFilterMaxAirDefenseLevel[$DB], $g_sProfileConfigPath, "search", "DBWeakAirDefense", 7, "int")
	IniReadS($g_aiFilterMaxXBowLevel[$DB], $g_sProfileConfigPath, "search", "DBWeakXBow", 4, "int")
	IniReadS($g_aiFilterMaxInfernoLevel[$DB], $g_sProfileConfigPath, "search", "DBWeakInferno", 1, "int")
	IniReadS($g_aiFilterMaxEagleLevel[$DB], $g_sProfileConfigPath, "search", "DBWeakEagle", 2, "int")
	IniReadS($g_aiFilterMaxScatterLevel[$DB], $g_sProfileConfigPath, "search", "DBWeakScatter", 1, "int")
	IniReadS($g_aiFilterMaxMonolithLevel[$DB], $g_sProfileConfigPath, "search", "DBWeakMonolith", 1, "int")
	IniReadS($g_abFilterMeetOneConditionEnable[$DB], $g_sProfileConfigPath, "search", "DBMeetOne", False, "Bool")
EndFunc   ;==>ReadConfig_600_28_DB

Func ReadConfig_600_28_LB()
	; <><><><> Attack Plan / Search & Attack / Activebase / Search <><><><>
	IniReadS($g_abAttackTypeEnable[$LB], $g_sProfileConfigPath, "search", "ABcheck", False, "Bool")
	; Search - Start Search If
	IniReadS($g_abSearchSearchesEnable[$LB], $g_sProfileConfigPath, "search", "ChkABSearchSearches", False, "Bool")
	IniReadS($g_aiSearchSearchesMin[$LB], $g_sProfileConfigPath, "search", "ABEnableAfterCount", 1, "int")
	IniReadS($g_aiSearchSearchesMax[$LB], $g_sProfileConfigPath, "search", "ABEnableBeforeCount", 9999, "int")
	IniReadS($g_abSearchTropiesEnable[$LB], $g_sProfileConfigPath, "search", "ChkABSearchTropies", False, "Bool")
	IniReadS($g_aiSearchTrophiesMin[$LB], $g_sProfileConfigPath, "search", "ABEnableAfterTropies", 100, "int")
	IniReadS($g_aiSearchTrophiesMax[$LB], $g_sProfileConfigPath, "search", "ABEnableBeforeTropies", 6000, "int")
	IniReadS($g_abSearchCampsEnable[$LB], $g_sProfileConfigPath, "search", "ChkABSearchCamps", False, "Bool")
	IniReadS($g_aiSearchCampsPct[$LB], $g_sProfileConfigPath, "search", "ABEnableAfterArmyCamps", 100, "int")
	Local $temp1, $temp2, $temp3, $temp4
	IniReadS($temp1, $g_sProfileConfigPath, "attack", "ABKingWait", $eHeroNone)
	IniReadS($temp2, $g_sProfileConfigPath, "attack", "ABQueenWait", $eHeroNone)
	IniReadS($temp3, $g_sProfileConfigPath, "attack", "ABWardenWait", $eHeroNone)
	IniReadS($temp4, $g_sProfileConfigPath, "attack", "ABChampionWait", $eHeroNone)
	$g_aiSearchHeroWaitEnable[$LB] = BitOR(Int($temp1 > $eHeroNone ? $eHeroKing : 0), Int($temp2 > $eHeroNone ? $eHeroQueen : 0), Int($temp3 > $eHeroNone ? $eHeroWarden : 0), Int($temp4 > $eHeroNone ? $eHeroChampion : 0))
	IniReadS($g_aiSearchNotWaitHeroesEnable[$LB], $g_sProfileConfigPath, "attack", "ABNotWaitHeroes", 0, "int")
	$g_iHeroWaitAttackNoBit[$LB][0] = ($temp1 > $eHeroNone) ? 1 : 0
	$g_iHeroWaitAttackNoBit[$LB][1] = ($temp2 > $eHeroNone) ? 1 : 0
	$g_iHeroWaitAttackNoBit[$LB][2] = ($temp3 > $eHeroNone) ? 1 : 0
	$g_iHeroWaitAttackNoBit[$LB][3] = ($temp4 > $eHeroNone) ? 1 : 0
	IniReadS($g_abSearchSpellsWaitEnable[$LB], $g_sProfileConfigPath, "search", "ChkABSpellsWait", False, "Bool")
	IniReadS($g_abSearchCastleWaitEnable[$LB], $g_sProfileConfigPath, "search", "ChkABCastleWait", False, "Bool")
	; Search - Filters
	IniReadS($g_aiFilterMeetGE[$LB], $g_sProfileConfigPath, "search", "ABMeetGE", 2, "int")
	IniReadS($g_aiFilterMinGold[$LB], $g_sProfileConfigPath, "search", "ABsearchGold", 80000, "int")
	IniReadS($g_aiFilterMinElixir[$LB], $g_sProfileConfigPath, "search", "ABsearchElixir", 80000, "int")
	IniReadS($g_aiFilterMinGoldPlusElixir[$LB], $g_sProfileConfigPath, "search", "ABsearchGoldPlusElixir", 160000, "int")
	IniReadS($g_abFilterMeetDEEnable[$LB], $g_sProfileConfigPath, "search", "ABMeetDE", False, "Bool")
	IniReadS($g_aiFilterMeetDEMin[$LB], $g_sProfileConfigPath, "search", "ABsearchDark", 0, "int")
	IniReadS($g_abFilterMeetTrophyEnable[$LB], $g_sProfileConfigPath, "search", "ABMeetTrophy", False, "Bool")
	IniReadS($g_aiFilterMeetTrophyMin[$LB], $g_sProfileConfigPath, "search", "ABsearchTrophy", 0, "int")
	IniReadS($g_aiFilterMeetTrophyMax[$LB], $g_sProfileConfigPath, "search", "ABsearchTrophyMax", 99, "int")
	IniReadS($g_abFilterMeetTH[$LB], $g_sProfileConfigPath, "search", "ABMeetTH", False, "Bool")
	IniReadS($g_aiFilterMeetTHMin[$LB], $g_sProfileConfigPath, "search", "ABTHLevel", 0, "int")
	IniReadS($g_abFilterMeetTHOutsideEnable[$LB], $g_sProfileConfigPath, "search", "ABMeetTHO", False, "Bool")
	IniReadS($g_abFilterMaxMortarEnable[$LB], $g_sProfileConfigPath, "search", "ABCheckMortar", False, "Bool")
	IniReadS($g_abFilterMaxWizTowerEnable[$LB], $g_sProfileConfigPath, "search", "ABCheckWizTower", False, "Bool")
	IniReadS($g_abFilterMaxAirDefenseEnable[$LB], $g_sProfileConfigPath, "search", "ABCheckAirDefense", False, "Bool")
	IniReadS($g_abFilterMaxXBowEnable[$LB], $g_sProfileConfigPath, "search", "ABCheckXBow", False, "Bool")
	IniReadS($g_abFilterMaxInfernoEnable[$LB], $g_sProfileConfigPath, "search", "ABCheckInferno", False, "Bool")
	IniReadS($g_abFilterMaxEagleEnable[$LB], $g_sProfileConfigPath, "search", "ABCheckEagle", False, "Bool")
	IniReadS($g_abFilterMaxScatterEnable[$LB], $g_sProfileConfigPath, "search", "ABCheckScatter", False, "Bool")
	IniReadS($g_abFilterMaxMonolithEnable[$LB], $g_sProfileConfigPath, "search", "ABCheckMonolith", False, "Bool")
	IniReadS($g_aiFilterMaxMortarLevel[$LB], $g_sProfileConfigPath, "search", "ABWeakMortar", 5, "int")
	IniReadS($g_aiFilterMaxWizTowerLevel[$LB], $g_sProfileConfigPath, "search", "ABWeakWizTower", 4, "int")
	IniReadS($g_aiFilterMaxAirDefenseLevel[$LB], $g_sProfileConfigPath, "search", "ABWeakAirDefense", 7, "int")
	IniReadS($g_aiFilterMaxXBowLevel[$LB], $g_sProfileConfigPath, "search", "ABWeakXBow", 4, "int")
	IniReadS($g_aiFilterMaxInfernoLevel[$LB], $g_sProfileConfigPath, "search", "ABWeakInferno", 1, "int")
	IniReadS($g_aiFilterMaxEagleLevel[$LB], $g_sProfileConfigPath, "search", "ABWeakEagle", 2, "int")
	IniReadS($g_aiFilterMaxScatterLevel[$LB], $g_sProfileConfigPath, "search", "ABWeakScatter", 1, "int")
	IniReadS($g_aiFilterMaxMonolithLevel[$LB], $g_sProfileConfigPath, "search", "ABWeakMonolith", 1, "int")
	IniReadS($g_abFilterMeetOneConditionEnable[$LB], $g_sProfileConfigPath, "search", "ABMeetOne", False, "Bool")
EndFunc   ;==>ReadConfig_600_28_LB

Func ReadConfig_600_29()
	; <><><><> Attack Plan / Search & Attack / Options / Attack <><><><>
	IniReadS($g_iActivateQueen, $g_sProfileConfigPath, "attack", "ActivateQueen", 0, "int")
	IniReadS($g_iActivateKing, $g_sProfileConfigPath, "attack", "ActivateKing", 0, "int")
	IniReadS($g_iActivateWarden, $g_sProfileConfigPath, "attack", "ActivateWarden", 0, "int")
	IniReadS($g_iActivateChampion, $g_sProfileConfigPath, "attack", "ActivateChampion", 0, "int")
	IniReadS($g_iDelayActivateQueen, $g_sProfileConfigPath, "attack", "delayActivateQueen", 9000, "int")
	IniReadS($g_iDelayActivateKing, $g_sProfileConfigPath, "attack", "delayActivateKing", 9000, "int")
	IniReadS($g_iDelayActivateWarden, $g_sProfileConfigPath, "attack", "delayActivateWarden", 10000, "int")
	IniReadS($g_iDelayActivateChampion, $g_sProfileConfigPath, "attack", "delayActivateChampion", 10000, "int")

	$g_bAttackPlannerEnable = (IniRead($g_sProfileConfigPath, "planned", "chkAttackPlannerEnable", "0") = "1")
	$g_bAttackPlannerCloseCoC = (IniRead($g_sProfileConfigPath, "planned", "chkAttackPlannerCloseCoC", "0") = "1")
	$g_bAttackPlannerCloseAll = (IniRead($g_sProfileConfigPath, "planned", "chkAttackPlannerCloseAll", "0") = "1")
	$g_bAttackPlannerSuspendComputer = (IniRead($g_sProfileConfigPath, "planned", "chkAttackPlannerSuspendComputer", "0") = "1")
	$g_bAttackPlannerRandomEnable = (IniRead($g_sProfileConfigPath, "planned", "chkAttackPlannerRandom", "0") = "1")
	$g_iAttackPlannerRandomTime = Int(IniRead($g_sProfileConfigPath, "planned", "cmbAttackPlannerRandom", 4))
	$g_bAttackPlannerDayLimit = (IniRead($g_sProfileConfigPath, "planned", "chkAttackPlannerDayLimit", "0") = "1")
	$g_iAttackPlannerDayMin = Int(IniRead($g_sProfileConfigPath, "planned", "cmbAttackPlannerDayMin", 12))
	$g_iAttackPlannerDayMax = Int(IniRead($g_sProfileConfigPath, "planned", "cmbAttackPlannerDayMax", 15))
	$g_abPlannedAttackWeekDays = StringSplit(IniRead($g_sProfileConfigPath, "planned", "attackDays", "1|1|1|1|1|1|1"), "|", $STR_NOCOUNT)
	For $i = 0 To 6
		$g_abPlannedAttackWeekDays[$i] = ($g_abPlannedAttackWeekDays[$i] = "1")
	Next
	$g_abPlannedattackHours = StringSplit(IniRead($g_sProfileConfigPath, "planned", "attackHours", "1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1"), "|", $STR_NOCOUNT)
	For $i = 0 To 23
		$g_abPlannedattackHours[$i] = ($g_abPlannedattackHours[$i] = "1")
	Next
	$g_bPlannedDropCCHoursEnable = (IniRead($g_sProfileConfigPath, "planned", "DropCCEnable", "0") = "1")
	$g_abPlannedDropCCHours = StringSplit(IniRead($g_sProfileConfigPath, "planned", "DropCCHours", "1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1"), "|", $STR_NOCOUNT)
	For $i = 0 To 23
		$g_abPlannedDropCCHours[$i] = ($g_abPlannedDropCCHours[$i] = "1")
	Next
EndFunc   ;==>ReadConfig_600_29

Func ReadConfig_600_29_DB()
	; <><><><> Attack Plan / Search & Attack / Deadbase / Attack <><><><>
	IniReadS($g_aiAttackAlgorithm[$DB], $g_sProfileConfigPath, "attack", "DBAtkAlgorithm", 0, "int")
	IniReadS($g_aiAttackTroopSelection[$DB], $g_sProfileConfigPath, "attack", "DBSelectTroop", 0, "int")
	Local $temp1, $temp2, $temp3, $temp4
	IniReadS($temp1, $g_sProfileConfigPath, "attack", "DBKingAtk", $eHeroNone)
	IniReadS($temp2, $g_sProfileConfigPath, "attack", "DBQueenAtk", $eHeroNone)
	IniReadS($temp3, $g_sProfileConfigPath, "attack", "DBWardenAtk", $eHeroNone)
	IniReadS($temp4, $g_sProfileConfigPath, "attack", "DBChampionAtk", $eHeroNone)
	$g_aiAttackUseHeroes[$DB] = BitOR(Int($temp1), Int($temp2), Int($temp3), Int($temp4))
	IniReadS($g_abAttackDropCC[$DB], $g_sProfileConfigPath, "attack", "DBDropCC", False, "Bool")
	IniReadS($g_abAttackUseLightSpell[$DB], $g_sProfileConfigPath, "attack", "DBLightSpell", False, "Bool")
	IniReadS($g_abAttackUseHealSpell[$DB], $g_sProfileConfigPath, "attack", "DBHealSpell", False, "Bool")
	IniReadS($g_abAttackUseRageSpell[$DB], $g_sProfileConfigPath, "attack", "DBRageSpell", False, "Bool")
	IniReadS($g_abAttackUseJumpSpell[$DB], $g_sProfileConfigPath, "attack", "DBJumpSpell", False, "Bool")
	IniReadS($g_abAttackUseFreezeSpell[$DB], $g_sProfileConfigPath, "attack", "DBFreezeSpell", False, "Bool")
	IniReadS($g_abAttackUsePoisonSpell[$DB], $g_sProfileConfigPath, "attack", "DBPoisonSpell", False, "Bool")
	IniReadS($g_abAttackUseEarthquakeSpell[$DB], $g_sProfileConfigPath, "attack", "DBEarthquakeSpell", False, "Bool")
	IniReadS($g_abAttackUseHasteSpell[$DB], $g_sProfileConfigPath, "attack", "DBHasteSpell", False, "Bool")
	IniReadS($g_abAttackUseCloneSpell[$DB], $g_sProfileConfigPath, "attack", "DBCloneSpell", False, "Bool")
	IniReadS($g_abAttackUseInvisibilitySpell[$DB], $g_sProfileConfigPath, "attack", "DBInvisibilitySpell", False, "Bool")
	IniReadS($g_abAttackUseRecallSpell[$DB], $g_sProfileConfigPath, "attack", "DBRecallSpell", False, "Bool")
	IniReadS($g_abAttackUseSkeletonSpell[$DB], $g_sProfileConfigPath, "attack", "DBSkeletonSpell", False, "Bool")
	IniReadS($g_abAttackUseBatSpell[$DB], $g_sProfileConfigPath, "attack", "DBBatSpell", False, "Bool")
	IniReadS($g_abAttackUseOvergrowthSpell[$DB], $g_sProfileConfigPath, "attack", "DBOgSpell", False, "Bool")
	; <><><><> Attack Plan / Search & Attack / Deadbase / Attack / Standard <><><><>
	IniReadS($g_aiAttackStdDropOrder[$DB], $g_sProfileConfigPath, "attack", "DBStandardAlgorithm", 0, "int")
	IniReadS($g_aiAttackStdDropSides[$DB], $g_sProfileConfigPath, "attack", "DBDeploy", 3, "int")
	IniReadS($g_abAttackStdSmartAttack[$DB], $g_sProfileConfigPath, "attack", "DBSmartAttackRedArea", True, "Bool")
	IniReadS($g_aiAttackStdSmartDeploy[$DB], $g_sProfileConfigPath, "attack", "DBSmartAttackDeploy", 0, "int")
	IniReadS($g_abAttackStdSmartNearCollectors[$DB][0], $g_sProfileConfigPath, "attack", "DBSmartAttackGoldMine", False, "Bool")
	IniReadS($g_abAttackStdSmartNearCollectors[$DB][1], $g_sProfileConfigPath, "attack", "DBSmartAttackElixirCollector", False, "Bool")
	IniReadS($g_abAttackStdSmartNearCollectors[$DB][2], $g_sProfileConfigPath, "attack", "DBSmartAttackDarkElixirDrill", False, "Bool")
	; <><><><> Attack Plan / Search & Attack / Deadbase / Attack / Scripted <><><><>
	IniReadS($g_aiAttackScrRedlineRoutine[$DB], $g_sProfileConfigPath, "attack", "RedlineRoutineDB", $g_aiAttackScrRedlineRoutine[$DB], "Int")
	IniReadS($g_aiAttackScrDroplineEdge[$DB], $g_sProfileConfigPath, "attack", "DroplineEdgeDB", $g_aiAttackScrDroplineEdge[$DB], "Int")
	IniReadS($g_sAttackScrScriptName[$DB], $g_sProfileConfigPath, "attack", "ScriptDB", "Barch four fingers")

	IniReadS($g_aiAttackUseWardenMode[$DB], $g_sProfileConfigPath, "attack", "DBAtkUseWardenMode", 2, "int")
	IniReadS($g_aiAttackUseSiege[$DB], $g_sProfileConfigPath, "attack", "DBAtkUseSiege", 7, "int")

	; <><><><> Attack Plan / Search & Attack / Deadbase / Attack / SmartFarm <><><><>
	IniReadS($g_iTxtInsidePercentage, $g_sProfileConfigPath, "SmartFarm", "InsidePercentage", 65, "int")
	IniReadS($g_iTxtOutsidePercentage, $g_sProfileConfigPath, "SmartFarm", "OutsidePercentage", 80, "int")
	IniReadS($g_bDebugSmartFarm, $g_sProfileConfigPath, "SmartFarm", "DebugSmartFarm", False, "Bool")

EndFunc   ;==>ReadConfig_600_29_DB

Func ReadConfig_600_29_LB()
	; <><><><> Attack Plan / Search & Attack / Activebase / Attack <><><><>
	IniReadS($g_aiAttackAlgorithm[$LB], $g_sProfileConfigPath, "attack", "ABAtkAlgorithm", 0, "int")
	IniReadS($g_aiAttackTroopSelection[$LB], $g_sProfileConfigPath, "attack", "ABSelectTroop", 0, "int")
	Local $temp1, $temp2, $temp3, $temp4
	IniReadS($temp1, $g_sProfileConfigPath, "attack", "ABKingAtk", $eHeroNone)
	IniReadS($temp2, $g_sProfileConfigPath, "attack", "ABQueenAtk", $eHeroNone)
	IniReadS($temp3, $g_sProfileConfigPath, "attack", "ABWardenAtk", $eHeroNone)
	IniReadS($temp4, $g_sProfileConfigPath, "attack", "ABChampionAtk", $eHeroNone)
	$g_aiAttackUseHeroes[$LB] = BitOR(Int($temp1), Int($temp2), Int($temp3), Int($temp4))
	IniReadS($g_abAttackDropCC[$LB], $g_sProfileConfigPath, "attack", "ABDropCC", False, "Bool")
	IniReadS($g_abAttackUseLightSpell[$LB], $g_sProfileConfigPath, "attack", "ABLightSpell", False, "Bool")
	IniReadS($g_abAttackUseHealSpell[$LB], $g_sProfileConfigPath, "attack", "ABHealSpell", False, "Bool")
	IniReadS($g_abAttackUseRageSpell[$LB], $g_sProfileConfigPath, "attack", "ABRageSpell", False, "Bool")
	IniReadS($g_abAttackUseJumpSpell[$LB], $g_sProfileConfigPath, "attack", "ABJumpSpell", False, "Bool")
	IniReadS($g_abAttackUseFreezeSpell[$LB], $g_sProfileConfigPath, "attack", "ABFreezeSpell", False, "Bool")
	IniReadS($g_abAttackUsePoisonSpell[$LB], $g_sProfileConfigPath, "attack", "ABPoisonSpell", False, "Bool")
	IniReadS($g_abAttackUseEarthquakeSpell[$LB], $g_sProfileConfigPath, "attack", "ABEarthquakeSpell", False, "Bool")
	IniReadS($g_abAttackUseHasteSpell[$LB], $g_sProfileConfigPath, "attack", "ABHasteSpell", False, "Bool")
	IniReadS($g_abAttackUseCloneSpell[$LB], $g_sProfileConfigPath, "attack", "ABCloneSpell", False, "Bool")
	IniReadS($g_abAttackUseInvisibilitySpell[$LB], $g_sProfileConfigPath, "attack", "ABInvisibilitySpell", False, "Bool")
	IniReadS($g_abAttackUseRecallSpell[$LB], $g_sProfileConfigPath, "attack", "ABRecallSpell", False, "Bool")
	IniReadS($g_abAttackUseSkeletonSpell[$LB], $g_sProfileConfigPath, "attack", "ABSkeletonSpell", False, "Bool")
	IniReadS($g_abAttackUseBatSpell[$LB], $g_sProfileConfigPath, "attack", "ABBatSpell", False, "Bool")
	IniReadS($g_abAttackUseOvergrowthSpell[$LB], $g_sProfileConfigPath, "attack", "ABOgSpell", False, "Bool")
	; <><><><> Attack Plan / Search & Attack / Activebase / Attack / Standard <><><><>
	IniReadS($g_aiAttackStdDropOrder[$LB], $g_sProfileConfigPath, "attack", "LBStandardAlgorithm", 0, "int")
	IniReadS($g_aiAttackStdDropSides[$LB], $g_sProfileConfigPath, "attack", "ABDeploy", 0, "int")
	IniReadS($g_abAttackStdSmartAttack[$LB], $g_sProfileConfigPath, "attack", "ABSmartAttackRedArea", True, "Bool")
	IniReadS($g_aiAttackStdSmartDeploy[$LB], $g_sProfileConfigPath, "attack", "ABSmartAttackDeploy", 1, "int")
	IniReadS($g_abAttackStdSmartNearCollectors[$LB][0], $g_sProfileConfigPath, "attack", "ABSmartAttackGoldMine", False, "Bool")
	IniReadS($g_abAttackStdSmartNearCollectors[$LB][1], $g_sProfileConfigPath, "attack", "ABSmartAttackElixirCollector", False, "Bool")
	IniReadS($g_abAttackStdSmartNearCollectors[$LB][2], $g_sProfileConfigPath, "attack", "ABSmartAttackDarkElixirDrill", False, "Bool")
	; <><><><> Attack Plan / Search & Attack / Activebase / Attack / Scripted <><><><>
	IniReadS($g_aiAttackScrRedlineRoutine[$LB], $g_sProfileConfigPath, "attack", "RedlineRoutineAB", $g_aiAttackScrRedlineRoutine[$LB], "Int")
	IniReadS($g_aiAttackScrDroplineEdge[$LB], $g_sProfileConfigPath, "attack", "DroplineEdgeAB", $g_aiAttackScrDroplineEdge[$LB], "Int")
	IniReadS($g_sAttackScrScriptName[$LB], $g_sProfileConfigPath, "attack", "ScriptAB", "Barch four fingers")

	IniReadS($g_aiAttackUseWardenMode[$LB], $g_sProfileConfigPath, "attack", "ABAtkUseWardenMode", 2, "int")
	IniReadS($g_aiAttackUseSiege[$LB], $g_sProfileConfigPath, "attack", "ABAtkUseSiege", 7, "int")
EndFunc   ;==>ReadConfig_600_29_LB

Func ReadConfig_600_30()
	; <><><><> Attack Plan / Search & Attack / Options / End Battle <><><><>
	$g_bShareAttackEnable = (IniRead($g_sProfileConfigPath, "shareattack", "ShareAttack", "0") = "1")
	$g_iShareMinGold = Int(IniRead($g_sProfileConfigPath, "shareattack", "minGold", 200000))
	$g_iShareMinElixir = Int(IniRead($g_sProfileConfigPath, "shareattack", "minElixir", 200000))
	$g_iShareMinDark = Int(IniRead($g_sProfileConfigPath, "shareattack", "minDark", 100))
	$g_sShareMessage = IniRead($g_sProfileConfigPath, "shareattack", "Message", "Nice|Good|Thanks|Wowwww")
	IniReadS($g_bTakeLootSnapShot, $g_sProfileConfigPath, "attack", "TakeLootSnapShot", False, "Bool")
	IniReadS($g_bScreenshotLootInfo, $g_sProfileConfigPath, "attack", "ScreenshotLootInfo", False, "Bool")
EndFunc   ;==>ReadConfig_600_30

Func ReadConfig_600_30_DB()
	; <><><><> Attack Plan / Search & Attack / Deadbase / End Battle <><><><>
	IniReadS($g_abStopAtkNoLoot1Enable[$DB], $g_sProfileConfigPath, "endbattle", "chkDBTimeStopAtk", True, "Bool")
	IniReadS($g_aiStopAtkNoLoot1Time[$DB], $g_sProfileConfigPath, "endbattle", "txtDBTimeStopAtk", 15, "int")
	IniReadS($g_abStopAtkNoLoot2Enable[$DB], $g_sProfileConfigPath, "endbattle", "chkDBTimeStopAtk2", False, "Bool")
	IniReadS($g_aiStopAtkNoLoot2Time[$DB], $g_sProfileConfigPath, "endbattle", "txtDBTimeStopAtk2", 7, "int")
	IniReadS($g_aiStopAtkNoLoot2MinGold[$DB], $g_sProfileConfigPath, "endbattle", "txtDBMinGoldStopAtk2", 1000, "int")
	IniReadS($g_aiStopAtkNoLoot2MinElixir[$DB], $g_sProfileConfigPath, "endbattle", "txtDBMinElixirStopAtk2", 1000, "int")
	IniReadS($g_aiStopAtkNoLoot2MinDark[$DB], $g_sProfileConfigPath, "endbattle", "txtDBMinDarkElixirStopAtk2", 50, "int")
	IniReadS($g_abStopAtkNoResources[$DB], $g_sProfileConfigPath, "endbattle", "chkDBEndNoResources", False, "Bool")
	IniReadS($g_abStopAtkOneStar[$DB], $g_sProfileConfigPath, "endbattle", "chkDBEndOneStar", False, "Bool")
	IniReadS($g_abStopAtkTwoStars[$DB], $g_sProfileConfigPath, "endbattle", "chkDBEndTwoStars", False, "Bool")
	IniReadS($g_abStopAtkPctHigherEnable[$DB], $g_sProfileConfigPath, "endbattle", "chkDBPercentageHigher", False, "Bool")
	IniReadS($g_aiStopAtkPctHigherAmt[$DB], $g_sProfileConfigPath, "endbattle", "txtDBPercentageHigher", 50, "int")
	IniReadS($g_abStopAtkPctNoChangeEnable[$DB], $g_sProfileConfigPath, "endbattle", "chkDBPercentageChange", False, "Bool")
	IniReadS($g_aiStopAtkPctNoChangeTime[$DB], $g_sProfileConfigPath, "endbattle", "txtDBPercentageChange", 15, "int")
EndFunc   ;==>ReadConfig_600_30_DB

Func ReadConfig_600_30_LB()
	; <><><><> Attack Plan / Search & Attack / Activebase / End Battle <><><><>

	IniReadS($g_abStopAtkNoLoot1Enable[$LB], $g_sProfileConfigPath, "endbattle", "chkABTimeStopAtk", True, "Bool")
	IniReadS($g_aiStopAtkNoLoot1Time[$LB], $g_sProfileConfigPath, "endbattle", "txtABTimeStopAtk", 20, "int")
	IniReadS($g_abStopAtkNoLoot2Enable[$LB], $g_sProfileConfigPath, "endbattle", "chkABTimeStopAtk2", False, "Bool")
	IniReadS($g_aiStopAtkNoLoot2Time[$LB], $g_sProfileConfigPath, "endbattle", "txtABTimeStopAtk2", 7, "int")
	IniReadS($g_aiStopAtkNoLoot2MinGold[$LB], $g_sProfileConfigPath, "endbattle", "txtABMinGoldStopAtk2", 1000, "int")
	IniReadS($g_aiStopAtkNoLoot2MinElixir[$LB], $g_sProfileConfigPath, "endbattle", "txtABMinElixirStopAtk2", 1000, "int")
	IniReadS($g_aiStopAtkNoLoot2MinDark[$LB], $g_sProfileConfigPath, "endbattle", "txtABMinDarkElixirStopAtk2", 50, "int")
	IniReadS($g_abStopAtkNoResources[$LB], $g_sProfileConfigPath, "endbattle", "chkABEndNoResources", False, "Bool")
	IniReadS($g_abStopAtkOneStar[$LB], $g_sProfileConfigPath, "endbattle", "chkABEndOneStar", False, "Bool")
	IniReadS($g_abStopAtkTwoStars[$LB], $g_sProfileConfigPath, "endbattle", "chkABEndTwoStars", False, "Bool")
	IniReadS($g_bDESideEndEnable, $g_sProfileConfigPath, "endbattle", "chkDESideEB", False, "Bool")
	IniReadS($g_iDESideEndMin, $g_sProfileConfigPath, "endbattle", "txtDELowEndMin", 25, "int")
	IniReadS($g_bDESideDisableOther, $g_sProfileConfigPath, "endbattle", "chkDisableOtherEBO", False, "Bool")
	IniReadS($g_bDESideEndBKWeak, $g_sProfileConfigPath, "endbattle", "chkDEEndBk", False, "Bool")
	IniReadS($g_bDESideEndAQWeak, $g_sProfileConfigPath, "endbattle", "chkDEEndAq", False, "Bool")
	IniReadS($g_bDESideEndOneStar, $g_sProfileConfigPath, "endbattle", "chkDEEndOneStar", False, "Bool")
	IniReadS($g_abStopAtkPctHigherEnable[$LB], $g_sProfileConfigPath, "endbattle", "chkABPercentageHigher", False, "Bool")
	IniReadS($g_aiStopAtkPctHigherAmt[$LB], $g_sProfileConfigPath, "endbattle", "txtABPercentageHigher", 50, "int")
	IniReadS($g_abStopAtkPctNoChangeEnable[$LB], $g_sProfileConfigPath, "endbattle", "chkABPercentageChange", False, "Bool")
	IniReadS($g_aiStopAtkPctNoChangeTime[$LB], $g_sProfileConfigPath, "endbattle", "txtABPercentageChange", 15, "int")
EndFunc   ;==>ReadConfig_600_30_LB

Func ReadConfig_600_31()
	; <><><><> Attack Plan / Search & Attack / Deadbase / Collectors <><><><>
	$g_abCollectorLevelEnabled[7] = 0
	For $i = 7 To 15
		IniReadS($g_abCollectorLevelEnabled[$i], $g_sProfileConfigPath, "collectors", "lvl" & $i & "Enabled", True, "Bool")
	Next
	For $i = 6 To 15
		IniReadS($g_aiCollectorLevelFill[$i], $g_sProfileConfigPath, "collectors", "lvl" & $i & "fill", 0, "int")
		If $g_aiCollectorLevelFill[$i] > 1 Then $g_aiCollectorLevelFill[$i] = 1
	Next
	IniReadS($g_bCollectorFilterDisable, $g_sProfileConfigPath, "search", "chkDisableCollectorsFilter", False, "Bool")
	IniReadS($g_iCollectorMatchesMin, $g_sProfileConfigPath, "collectors", "minmatches", $g_iCollectorMatchesMin) ; 1-6 collectors
	If $g_iCollectorMatchesMin < 1 Or $g_iCollectorMatchesMin > 6 Then $g_iCollectorMatchesMin = 3
	IniReadS($g_iCollectorToleranceOffset, $g_sProfileConfigPath, "collectors", "tolerance", 0, "int")
EndFunc   ;==>ReadConfig_600_31

Func ReadConfig_600_32()
	; <><><><> Attack Plan / Search & Attack / Options / Trophy Settings <><><><>
	IniReadS($g_bDropTrophyEnable, $g_sProfileConfigPath, "search", "TrophyRange", False, "Bool")
	IniReadS($g_iDropTrophyMin, $g_sProfileConfigPath, "search", "MinTrophy", 5000, "int")
	IniReadS($g_iDropTrophyMax, $g_sProfileConfigPath, "search", "MaxTrophy", 5000, "int")
	IniReadS($g_bDropTrophyUseHeroes, $g_sProfileConfigPath, "search", "chkTrophyHeroes", False, "Bool")
	IniReadS($g_iDropTrophyHeroesPriority, $g_sProfileConfigPath, "search", "cmbTrophyHeroesPriority", 0, "int")
	IniReadS($g_bDropTrophyAtkDead, $g_sProfileConfigPath, "search", "chkTrophyAtkDead", False, "Bool")
	IniReadS($g_iDropTrophyArmyMinPct, $g_sProfileConfigPath, "search", "DTArmyMin", 70, "int")
EndFunc   ;==>ReadConfig_600_32

Func ReadConfig_600_33()
	; <><><><> Attack Plan / Search & Attack / Drop Order Troops <><><><>
	IniReadS($g_bCustomDropOrderEnable, $g_sProfileConfigPath, "DropOrder", "chkDropOrder", False, "Bool")
	For $p = 0 To UBound($g_aiCmbCustomDropOrder) - 1
		IniReadS($g_aiCmbCustomDropOrder[$p], $g_sProfileConfigPath, "DropOrder", "cmbDropOrder" & $p, -1)
	Next
EndFunc   ;==>ReadConfig_600_33

Func ReadConfig_600_35_1()
	; <><><><> Bot / Options <><><><>
	$g_bDisableSplash = (IniRead($g_sProfileConfigPath, "General", "ChkDisableSplash", "0") = "1")
	$g_bCheckVersion = (IniRead($g_sProfileConfigPath, "General", "ChkVersion", "1") = "1")
	IniReadS($g_bDeleteLogs, $g_sProfileConfigPath, "deletefiles", "DeleteLogs", True, "Bool")
	IniReadS($g_iDeleteLogsDays, $g_sProfileConfigPath, "deletefiles", "DeleteLogsDays", 2, "int")
	IniReadS($g_bDeleteTemp, $g_sProfileConfigPath, "deletefiles", "DeleteTemp", True, "Bool")
	IniReadS($g_iDeleteTempDays, $g_sProfileConfigPath, "deletefiles", "DeleteTempDays", 5, "int")
	IniReadS($g_bDeleteLoots, $g_sProfileConfigPath, "deletefiles", "DeleteLoots", True, "Bool")
	IniReadS($g_iDeleteLootsDays, $g_sProfileConfigPath, "deletefiles", "DeleteLootsDays", 2, "int")
	IniReadS($g_bAutoStart, $g_sProfileConfigPath, "general", "AutoStart", False, "Bool")
	IniReadS($g_iAutoStartDelay, $g_sProfileConfigPath, "general", "AutoStartDelay", 10, "int")
	IniReadS($g_bRestarted, $g_sProfileConfigPath, "general", "Restarted", $g_bRestarted, "int")
	If $g_bBotLaunchOption_Autostart = True Then $g_bRestarted = True
	$g_bCheckGameLanguage = (IniRead($g_sProfileConfigPath, "General", "ChkLanguage", "1") = "1")
	IniReadS($g_bAutoAlignEnable, $g_sProfileConfigPath, "general", "DisposeWindows", False, "Bool")
	IniReadS($g_iAutoAlignPosition, $g_sProfileConfigPath, "general", "DisposeWindowsPos", "EMBED")
	IniReadS($g_iAutoAlignOffsetX, $g_sProfileConfigPath, "other", "WAOffsetX", "")
	IniReadS($g_iAutoAlignOffsetY, $g_sProfileConfigPath, "other", "WAOffsetY", "")
	;$g_bUpdatingWhenMinimized must be always enabled
	;IniReadS($g_bUpdatingWhenMinimized, $g_sProfileConfigPath, "general", "UpdatingWhenMinimized", True, "Bool")
	IniReadS($g_bHideWhenMinimized, $g_sProfileConfigPath, "general", "HideWhenMinimized", False, "Bool")
	$g_bUseRandomClick = (IniRead($g_sProfileConfigPath, "other", "UseRandomClick", "0") = "1")
	$g_bScreenshotPNGFormat = (IniRead($g_sProfileConfigPath, "other", "ScreenshotType", "0") = "1") ;screenshot type: 0 JPG   1 PNG
	$g_bScreenshotHideName = (IniRead($g_sProfileConfigPath, "other", "ScreenshotHideName", "1") = "1")
	IniReadS($g_iAnotherDeviceWaitTime, $g_sProfileConfigPath, "other", "txtTimeWakeUp", 0, "int")
	$g_bAutoResumeEnable = (IniRead($g_sProfileConfigPath, "other", "ChkAutoResume", "0") = "1")
	$g_iAutoResumeTime = Int(IniRead($g_sProfileConfigPath, "other", "AutoResumeTime", 5))
	IniReadS($g_bDisableNotifications, $g_sProfileConfigPath, "other", "ChkDisableNotifications", False, "Bool")
	$g_bForceClanCastleDetection = (IniRead($g_sProfileConfigPath, "other", "ChkFixClanCastle", "0") = "1")
	IniReadS($g_bUseStatistics, $g_sProfileConfigPath, "other", "ChkSqlite", False, "Bool")

	IniReadS($g_bOnlySCIDAccounts, $g_sProfileConfigPath, "ProfileSCID", "OnlySCIDAccounts", True, "Bool")
	$g_iWhatSCIDAccount2Use = Int(IniRead($g_sProfileConfigPath, "ProfileSCID", "WhatSCIDAccount2Use", 0))
EndFunc   ;==>ReadConfig_600_35_1

Func ReadConfig_600_35_2()
	; <><><><> Bot / Profile / Switch Account <><><><>
	Local $sSwitchAccFile
	$g_iCmbSwitchAcc = 0
	$g_bChkSwitchAcc = False
	For $g = 1 To 8
		; find group this profile belongs to: no switch profile config is saved in config.ini on purpose!
		$sSwitchAccFile = $g_sProfilePath & "\SwitchAccount.0" & $g & ".ini"
		If FileExists($sSwitchAccFile) = 0 Then ContinueLoop
		Local $sProfile
		Local $bEnabled
		For $i = 1 To Int(IniRead($sSwitchAccFile, "SwitchAccount", "TotalCocAccount", 0)) + 1
			$bEnabled = IniRead($sSwitchAccFile, "SwitchAccount", "Enable", "") = "1"
			If $bEnabled Then
				$bEnabled = IniRead($sSwitchAccFile, "SwitchAccount", "AccountNo." & $i, "") = "1"
				If $bEnabled Then
					$sProfile = IniRead($sSwitchAccFile, "SwitchAccount", "ProfileName." & $i, "")
					If $sProfile = $g_sProfileCurrentName Then
						; found current profile
						$g_iCmbSwitchAcc = $g
						ExitLoop
					EndIf
				EndIf
			EndIf
		Next

		If $g_iCmbSwitchAcc Then
			ReadConfig_SwitchAccounts()
			ExitLoop
		EndIf
	Next
EndFunc   ;==>ReadConfig_600_35_2

Func ReadConfig_SwitchAccounts()
	If $g_iCmbSwitchAcc Then
		Local $sSwitchAccFile = $g_sProfilePath & "\SwitchAccount.0" & $g_iCmbSwitchAcc & ".ini"
		$g_bChkSwitchAcc = IniRead($sSwitchAccFile, "SwitchAccount", "Enable", "0") = "1"
		$g_bChkGooglePlay = IniRead($sSwitchAccFile, "SwitchAccount", "GooglePlay", "0") = "1"
		$g_bChkSuperCellID = IniRead($sSwitchAccFile, "SwitchAccount", "SuperCellID", "0") = "1"
		$g_bChkSharedPrefs = IniRead($sSwitchAccFile, "SwitchAccount", "SharedPrefs", "0") = "1"
		$g_bChkSmartSwitch = IniRead($sSwitchAccFile, "SwitchAccount", "SmartSwitch", "0") = "1"
		$g_bDonateLikeCrazy = IniRead($sSwitchAccFile, "SwitchAccount", "DonateLikeCrazy", "0") = "1"
		$g_iTotalAcc = Int(IniRead($sSwitchAccFile, "SwitchAccount", "TotalCocAccount", "-1"))
		$g_iTrainTimeToSkip = Int(IniRead($sSwitchAccFile, "SwitchAccount", "TrainTimeToSkip", "1"))
		For $i = 1 To 8
			$g_abAccountNo[$i - 1] = IniRead($sSwitchAccFile, "SwitchAccount", "AccountNo." & $i, "") = "1"
			$g_asProfileName[$i - 1] = IniRead($sSwitchAccFile, "SwitchAccount", "ProfileName." & $i, "")
			$g_abDonateOnly[$i - 1] = IniRead($sSwitchAccFile, "SwitchAccount", "DonateOnly." & $i, "0") = "1"
		Next
	EndIf
EndFunc   ;==>ReadConfig_SwitchAccounts

Func ReadConfig_600_52_1()
	; <><><><> Attack Plan / Train Army / Troops/Spells <><><><>
	$g_bQuickTrainEnable = (IniRead($g_sProfileConfigPath, "other", "ChkUseQTrain", "0") = "1")
	For $i = 0 To 2
		$g_bQuickTrainArmy[$i] = (IniRead($g_sProfileConfigPath, "troop", "QuickTrainArmy" & $i + 1, "0") = "1")
		$g_abUseInGameArmy[$i] = (IniRead($g_sProfileConfigPath, "troop", "UseInGameArmy_" & $i + 1, "1") = "1")
		For $j = 0 To 6
			IniReadS($g_aiQuickTroopType[$i][$j], $g_sProfileConfigPath, "QuickTroop", "QuickTroopType_" & $i + 1 & "_Slot_" & $j, -1, "int")
			IniReadS($g_aiQuickTroopQty[$i][$j], $g_sProfileConfigPath, "QuickTroop", "QuickTroopQty_" & $i + 1 & "_Slot_" & $j, 0, "int")
			IniReadS($g_aiQuickSpellType[$i][$j], $g_sProfileConfigPath, "QuickTroop", "QuickSpellType_" & $i + 1 & "_Slot_" & $j, -1, "int")
			IniReadS($g_aiQuickSpellQty[$i][$j], $g_sProfileConfigPath, "QuickTroop", "QuickSpellQty_" & $i + 1 & "_Slot_" & $j, 0, "int")
		Next
		IniReadS($g_aiTotalQuickTroop[$i], $g_sProfileConfigPath, "QuickTroop", "TotalQuickTroop" & $i + 1, 0, "int")
		IniReadS($g_aiTotalQuickSpell[$i], $g_sProfileConfigPath, "QuickTroop", "TotalQuickSpell" & $i + 1, 0, "int")
	Next
EndFunc   ;==>ReadConfig_600_52_1

Func ReadConfig_600_52_2()
	For $T = 0 To $eTroopCount - 1
		Local $tempTroopCount, $tempTroopLevel
		Switch $T
			Case $eTroopBarbarian
				IniReadS($tempTroopCount, $g_sProfileConfigPath, "troop", $g_asTroopShortNames[$T], 58, "int")
				IniReadS($tempTroopLevel, $g_sProfileConfigPath, "LevelTroop", $g_asTroopShortNames[$T], 1, "int")
			Case $eTroopArcher
				IniReadS($tempTroopCount, $g_sProfileConfigPath, "troop", $g_asTroopShortNames[$T], 115, "int")
				IniReadS($tempTroopLevel, $g_sProfileConfigPath, "LevelTroop", $g_asTroopShortNames[$T], 1, "int")
			Case $eTroopGoblin
				IniReadS($tempTroopCount, $g_sProfileConfigPath, "troop", $g_asTroopShortNames[$T], 19, "int")
				IniReadS($tempTroopLevel, $g_sProfileConfigPath, "LevelTroop", $g_asTroopShortNames[$T], 1, "int")
			Case $eTroopGiant
				IniReadS($tempTroopCount, $g_sProfileConfigPath, "troop", $g_asTroopShortNames[$T], 4, "int")
				IniReadS($tempTroopLevel, $g_sProfileConfigPath, "LevelTroop", $g_asTroopShortNames[$T], 1, "int")
			Case $eTroopWallBreaker
				IniReadS($tempTroopCount, $g_sProfileConfigPath, "troop", $g_asTroopShortNames[$T], 4, "int")
				IniReadS($tempTroopLevel, $g_sProfileConfigPath, "LevelTroop", $g_asTroopShortNames[$T], 1, "int")
			Case Else
				IniReadS($tempTroopCount, $g_sProfileConfigPath, "troop", $g_asTroopShortNames[$T], 0, "int")
				IniReadS($tempTroopLevel, $g_sProfileConfigPath, "LevelTroop", $g_asTroopShortNames[$T], 0, "int")
		EndSwitch
		$g_aiArmyCustomTroops[$T] = $tempTroopCount
		$g_aiTrainArmyTroopLevel[$T] = $tempTroopLevel
	Next

	For $S = 0 To $eSpellCount - 1
		IniReadS($g_aiArmyCustomSpells[$S], $g_sProfileConfigPath, "Spells", $g_asSpellShortNames[$S], 0, "int")
		IniReadS($g_aiTrainArmySpellLevel[$S], $g_sProfileConfigPath, "LevelSpell", $g_asSpellShortNames[$S], 0, "int")
	Next
	$g_aiArmyCompTroops = $g_bQuickTrainEnable ? $g_aiArmyQuickTroops : $g_aiArmyCustomTroops
	$g_aiArmyCompSpells = $g_bQuickTrainEnable ? $g_aiArmyQuickSpells : $g_aiArmyCustomSpells

	For $S = 0 To $eSiegeMachineCount - 1
		IniReadS($g_aiArmyCompSiegeMachines[$S], $g_sProfileConfigPath, "Siege", $g_asSiegeMachineShortNames[$S], 0, "int")
		;IniReadS($g_aiTrainArmySiegeMachineLevel[$S], $g_sProfileConfigPath, "LevelSiege", $g_asSiegeMachineShortNames[$S], 0, "int")
		;SetLog("Siege" & $g_asSiegeMachineShortNames[$S] & " - " & $g_aiArmyCompSiegeMachines[$S], $COLOR_ERROR)
	Next
	IniReadS($g_iTrainArmyFullTroopPct, $g_sProfileConfigPath, "troop", "fullTroop", 100, "int")
	$g_bTotalCampForced = (IniRead($g_sProfileConfigPath, "other", "ChkTotalCampForced", "1") = "1")
	$g_iTotalCampForcedValue = Int(IniRead($g_sProfileConfigPath, "other", "ValueTotalCampForced", 220))
	IniReadS($g_iTotalSpellValue, $g_sProfileConfigPath, "Spells", "SpellFactory", 0, "int")
	$g_iTotalSpellValue = Int($g_iTotalSpellValue)
	; DoubleTrain - Demen
	$g_bDoubleTrain = (IniRead($g_sProfileConfigPath, "troop", "DoubleTrain", "0") = "1")
	$g_bPreciseArmy = (IniRead($g_sProfileConfigPath, "troop", "PreciseArmy", "0") = "1")
EndFunc   ;==>ReadConfig_600_52_2

Func ReadConfig_600_54()
	; <><><><> Attack Plan / Train Army / Train Order <><><><>
	; Troops Order
	IniReadS($g_bCustomTrainOrderEnable, $g_sProfileConfigPath, "troop", "chkTroopOrder", False, "Bool")
	For $z = 0 To UBound($g_aiCmbCustomTrainOrder) - 1
		IniReadS($g_aiCmbCustomTrainOrder[$z], $g_sProfileConfigPath, "troop", "cmbTroopOrder" & $z, -1)
	Next

	; Spells Order
	IniReadS($g_bCustomBrewOrderEnable, $g_sProfileConfigPath, "Spells", "chkSpellOrder", False, "Bool")
	For $z = 0 To UBound($g_aiCmbCustomBrewOrder) - 1
		IniReadS($g_aiCmbCustomBrewOrder[$z], $g_sProfileConfigPath, "Spells", "cmbSpellOrder" & $z, -1)
	Next
EndFunc   ;==>ReadConfig_600_54

Func ReadConfig_600_56()
	; <><><><> Attack Plan / Search & Attack / Options / SmartZap <><><><>
	$g_bSmartZapEnable = (IniRead($g_sProfileConfigPath, "SmartZap", "UseSmartZap", "0") = "1")
	$g_bEarthQuakeZap = (IniRead($g_sProfileConfigPath, "SmartZap", "UseEarthQuakeZap", "0") = "1")
	$g_bNoobZap = (IniRead($g_sProfileConfigPath, "SmartZap", "UseNoobZap", "0") = "1")
	$g_bSmartZapDB = (IniRead($g_sProfileConfigPath, "SmartZap", "ZapDBOnly", "1") = "1")
	$g_bSmartZapSaveHeroes = (IniRead($g_sProfileConfigPath, "SmartZap", "THSnipeSaveHeroes", "1") = "1")
	$g_bSmartZapFTW = (IniRead($g_sProfileConfigPath, "SmartZap", "FTW", "0") = "1")
	$g_iSmartZapMinDE = Int(IniRead($g_sProfileConfigPath, "SmartZap", "MinDE", 350))
	$g_iSmartZapExpectedDE = Int(IniRead($g_sProfileConfigPath, "SmartZap", "ExpectedDE", 320))
EndFunc   ;==>ReadConfig_600_56

Func ReadConfig_641_1()
	; <><><><> Attack Plan / Train Army / Options <><><><>
	IniReadS($g_bCloseWhileTrainingEnable, $g_sProfileConfigPath, "other", "chkCloseWaitEnable", True, "Bool")
	IniReadS($g_bCloseWithoutShield, $g_sProfileConfigPath, "other", "chkCloseWaitTrain", False, "Bool")
	IniReadS($g_bCloseEmulator, $g_sProfileConfigPath, "other", "btnCloseWaitStop", False, "Bool")
	IniReadS($g_bSuspendComputer, $g_sProfileConfigPath, "other", "btnCloseWaitSuspendComputer", False, "Bool")
	IniReadS($g_bCloseRandom, $g_sProfileConfigPath, "other", "btnCloseWaitStopRandom", False, "Bool")
	IniReadS($g_bCloseExactTime, $g_sProfileConfigPath, "other", "btnCloseWaitExact", False, "Bool")
	IniReadS($g_bCloseRandomTime, $g_sProfileConfigPath, "other", "btnCloseWaitRandom", True, "Bool")
	IniReadS($g_iCloseRandomTimePercent, $g_sProfileConfigPath, "other", "CloseWaitRdmPercent", 10, "int")
	IniReadS($g_iCloseMinimumTime, $g_sProfileConfigPath, "other", "MinimumTimeToClose", 2, "int")
	IniReadS($g_iTrainClickDelay, $g_sProfileConfigPath, "other", "TrainITDelay", 100, "int")
	IniReadS($g_bTrainAddRandomDelayEnable, $g_sProfileConfigPath, "other", "chkAddIdleTime", $g_bTrainAddRandomDelayEnable, "Bool")
	IniReadS($g_iTrainAddRandomDelayMin, $g_sProfileConfigPath, "other", "txtAddDelayIdlePhaseTimeMin", $g_iTrainAddRandomDelayMin, "Int")
	IniReadS($g_iTrainAddRandomDelayMax, $g_sProfileConfigPath, "other", "txtAddDelayIdlePhaseTimeMax", $g_iTrainAddRandomDelayMax, "Int")
EndFunc   ;==>ReadConfig_641_1

Func IniReadS(ByRef $variable, $PrimaryInputFile, $section, $key, $defaultvalue, $valueType = Default)
	;read from standard config ini file but, if variable $g_sProfileSecondaryInputFileName <>"" (valorized by button read strategy), if exists
	;section->key override values from ini files with values in $g_sProfileSecondaryInputFileName
	Local $defaultvalueTest = "?"
	Local $readValue = IniRead($g_sProfileSecondaryInputFileName, $section, $key, $defaultvalueTest)
	If $readValue = $defaultvalueTest Then
		$readValue = IniRead($PrimaryInputFile, $section, $key, $defaultvalue)
	EndIf
	Switch $valueType
		Case Default
			; no conversion
			$variable = $readValue
		Case "Int"
			; convert to Int
			$variable = Int($readValue)
		Case "Bool"
			; convert to boolean type
			If $readValue = "True" Or $readValue = "1" Then
				$variable = True
			Else
				$variable = False
			EndIf
		Case Else
			; Unsupported type
			$variable = $readValue
	EndSwitch

EndFunc   ;==>IniReadS
