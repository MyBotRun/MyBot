; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Misc" tab under the "Village" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017), Chilly-Chill (2019)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once
#include <TreeViewConstants.au3>
Global $g_hGUI_MISC = 0, $g_hGUI_MISC_TAB = 0, $g_hGUI_MISC_TAB_ITEM1 = 0, $g_hGUI_MISC_TAB_ITEM2 = 0, $g_hGUI_MISC_TAB_ITEM3 = 0, $g_hGUI_MISC_TAB_ITEM4 = 0

Global $g_hChkBotStop = 0, $g_hCmbBotCommand = 0, $g_hCmbBotCond = 0, $g_hCmbHoursStop = 0, $g_hCmbTimeStop = 0
Global $g_LblResumeAttack = 0, $g_ahTxtResumeAttackLoot[$eLootCount] = [0, 0, 0, 0], $g_hCmbResumeTime = 0
Global $g_hChkCollectStarBonus = 0
Global $g_hTxtRestartGold = 0, $g_hTxtRestartElixir = 0, $g_hTxtRestartDark = 0
Global $g_hChkTrap = 1, $g_hChkCollect = 1, $g_hChkTombstones = 1, $g_hChkCleanYard = 0, $g_hChkGemsBox = 0
Global $g_hChkCollectCartFirst = 0, $g_hTxtCollectGold = 0, $g_hTxtCollectElixir = 0, $g_hTxtCollectDark = 0
Global $g_hBtnLocateSpellfactory = 0, $g_hBtnLocateDarkSpellFactory = 0
Global $g_hBtnLocateKingAltar = 0, $g_hBtnLocateQueenAltar = 0, $g_hBtnLocateWardenAltar = 0, $g_hBtnLocateChampionAltar = 0, $g_hBtnLocateLaboratory = 0, $g_hBtnLocatePetHouse = 0, $g_hBtnResetBuilding = 0, $g_hBtnLocateBlacksmith = 0
Global $g_hChkTreasuryCollect = 0, $g_hTxtTreasuryGold = 0, $g_hTxtTreasuryElixir = 0, $g_hTxtTreasuryDark = 0, $g_hChkCollectAchievements = 0, $g_hChkFreeMagicItems = 0, $g_hChkCollectRewards = 0, $g_hChkSellRewards = 0

Global $g_alblBldBaseStats[3] = ["", "", ""]
Global $g_hChkCollectBuilderBase = 0, $g_hChkStartClockTowerBoost = 0, $g_hChkCTBoostBlderBz = 0, $g_hChkCleanBBYard = 0
Global $g_hChkCollectBldGE = 0, $g_hChkCollectBldGems = 0, $g_hChkActivateClockTower = 0
Global $g_hBtnDelDoubleCannonCoord = 0, $g_hBtnDelArcherTowerCoord = 0, $g_hBtnDelMultiMortarCoord = 0, $g_hBtnDelCannonCoord = 0, $g_hBtnBattleMachineCoord = 0, $g_hBtnBattlecopterCoord = 0
Global $g_hChkBattleMachineUpgrade = 0, $g_hChkDoubleCannonUpgrade = 0, $g_hChkArcherTowerUpgrade = 0, $g_hChkMultiMortarUpgrade = 0
Global $g_hChkBattleCopterUpgrade = 0, $g_hChkAnyDefUpgrade = 0
Global $g_hChkBBSuggestedUpgrades = 0, $g_hChkBBSuggestedUpgradesIgnoreGold = 0, $g_hChkBBSuggestedUpgradesIgnoreElixir, $g_hChkBBSuggestedUpgradesIgnoreHall = 0
Global $g_hChkPlacingNewBuildings = 0, $g_hChkBBSuggestedUpgradesIgnoreWall = 0
Global $g_ahPicBBLeague[$eBBLeagueCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], $g_hLblBBLeague1 = 0, $g_hLblBBLeague2 = 0, $g_hLblBBLeague3 = 0, $g_hLblBBLeague4 = 0, $g_hLblBBLeague5 = 0

;ClanGames Challenges
Global $g_hChkClanGamesEnabled = 0, $g_hChkClanGamesAllTimes = 0, $g_hChkClanGamesNoOneDay = 0
Global $g_hTxtClanGamesLog = 0, $g_hLblRemainTime = 0, $g_hLblYourScore = 0
Global $g_hGUI_CGSettings = 0, $g_hBtnCGSettingsOpen = 0, $g_hBtnCGSettingsClose = 0
Global $g_hGUI_CGRewardsSettings = 0, $g_hChkClanGamesCollectRewards = 0, $g_hBtnCGRewardsSettingsOpen = 0, $g_hBtnCGRewardsSettingsClose = 0, _
		$TitlePriority = 0, $TitlePriority2 = 0, $g_hBtnCGRewardsSettingsDefault = 0
Global $g_hLabelRewardFull = 0, $g_hLabelReward5Gems = 0, $g_hLabelReward10Gems = 0, $g_hLabelReward50Gems = 0, $g_hLabelAllPotionsFull = 0, $g_hLabelAllBooksFull = 0, $g_hLabelAllBooks = 0
Global $g_acmbPriorityReward[22] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hChkForceBBAttackOnClanGames = 0, $g_hChkClanGamesPurgeAny = 0, $g_hChkClanGamesStopBeforeReachAndPurge = 0
Global $g_hChkForceAttackOnClanGamesWhenHalt = 0
Global $hSearchBBEventFirst = 0, $hSearchMainEventFirst = 0, $hSearchBothVillages = 0
Global $g_hChkClanGamesSort = 0, $g_hCmbClanGamesSort = 0
Global $g_hLabelClangamesDesc = 0, $g_hChkCGRootEnabledAll = 0

Global $g_hClanGamesTV = 0, $g_hChkCGMainLoot = 0, $g_hChkCGMainBattle = 0, $g_hChkCGMainDestruction = 0
Global $g_hChkCGMainAir = 0, $g_hChkCGMainGround = 0, $g_hChkCGMainMisc = 0, $g_hChkCGMainSpell = 0
Global $g_hChkCGBBBattle = 0, $g_hChkCGBBDestruction = 0, $g_hChkCGBBTroops = 0
Global $g_hChkClanGamesDebug = 0, $g_hChkCGDebugEvents = 0

Global $g_ahCGMainLootItem[6], $g_ahCGMainBattleItem[22], $g_ahCGMainDestructionItem[34], $g_ahCGMainAirItem[13], _
		$g_ahCGMainGroundItem[29], $g_ahCGMainMiscItem[3], $g_ahCGMainSpellItem[12], $g_ahCGBBBattleItem[4], _
		$g_ahCGBBDestructionItem[21], $g_ahCGBBTroopsItem[12]

;ClanCapitalTAB
Global $g_lblCapitalGold = 0, $g_lblCapitalMedal = 0, $g_hCmbForgeBuilder = 0, $g_hLbCmbForgeBuilder = 0, $g_hChkEnableAutoUpgradeCC = 0, $g_hChkAutoUpgradeCCIgnore = 0, $g_hTxtAutoUpgradeCCLog = 0, _
		$g_hChkAutoUpgradeCCWallIgnore = 0, $g_hChkAutoUpgradeCCPriorArmy = 0, $g_lblCapitalTrophies = 0, $g_ahPicCCLeague[$eLeagueCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0], $g_hLblCCLeague1 = 0, $g_hLblCCLeague2 = 0, $g_hLblCCLeague3 = 0
Global $g_hChkEnableCollectCCGold = 0, $g_hChkEnableForgeGold = 0, $g_hChkEnableForgeElix = 0, $g_hChkEnableForgeDE = 0, $g_hChkEnableForgeBBGold = 0, $g_hChkEnableForgeBBElix = 0, $g_hChkEnableSmartUse = 0
Global $g_hLbacmdGoldSaveMin = 0, $g_acmdGoldSaveMin = 0, $g_hLbacmdElixSaveMin = 0, $g_acmdElixSaveMin = 0, $g_hLbacmdDarkSaveMin = 0, $g_acmdDarkSaveMin = 0
Global $g_hLbacmdBBGoldSaveMin = 0, $g_acmdBBGoldSaveMin = 0, $g_hLbacmdBBElixSaveMin = 0, $g_acmdBBElixSaveMin = 0

Func CreateVillageMisc()
	$g_hGUI_MISC = _GUICreate("", $g_iSizeWGrpTab2, $g_iSizeHGrpTab2, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_VILLAGE)

	GUISwitch($g_hGUI_MISC)
	$g_hGUI_MISC_TAB = GUICtrlCreateTab(0, 0, $g_iSizeWGrpTab2, $g_iSizeHGrpTab2, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
	$g_hGUI_MISC_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "MISC_TAB_ITEM1", "Normal Village"))
	CreateMiscNormalVillageSubTab()
	$g_hGUI_MISC_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "MISC_TAB_ITEM2", "Builder Base"))
	CreateMiscBuilderBaseSubTab()
	$g_hGUI_MISC_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "MISC_TAB_ITEM3", "Clan Games"))
	CreateMiscClanGamesV3SubTab()
	$g_hGUI_MISC_TAB_ITEM4 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "MISC_TAB_ITEM4", "Clan Capital"))
	CreateClanCapitalTab()
	CreateBBDropOrderGUI()
	CreateClanGamesSettings()
	GUICtrlCreateTabItem("")

EndFunc   ;==>CreateVillageMisc

Func CreateMiscNormalVillageSubTab()
	Local $sTxtTip = ""
	Local $x = 15, $y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_01", "Halt Attack"), $x - 10, $y - 20, $g_iSizeWGrpTab3, 145)
	$g_hChkBotStop = GUICtrlCreateCheckbox("", $x, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BotStop_Info_01", "Use these options to set when the bot will stop attacking.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkBotStop")

	$g_hCmbBotCommand = GUICtrlCreateCombo("", $x + 20, $y - 3, 95, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCommand_Item_01", "Halt Attack") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCommand_Item_02", "Stop Bot") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCommand_Item_03", "Close Bot") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCommand_Item_04", "Close CoC+Bot") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCommand_Item_05", "Shutdown PC") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCommand_Item_06", "Sleep PC") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCommand_Item_07", "Reboot PC") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCommand_Item_08", "Turn Idle"), GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCommand_Item_01", -1))
	GUICtrlSetOnEvent(-1, "cmbBotCond")
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblBotCommand", "When..."), $x + 125, $y, 45, 17)

	$g_hCmbBotCond = GUICtrlCreateCombo("", $x + 173, $y - 3, 160, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_01", "G and E Full and Max.Trophy") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_02", "(G and E) Full or Max.Trophy") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_03", "(G or E) Full and Max.Trophy") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_04", "G or E Full or Max.Trophy") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_05", "Gold and Elixir Full") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_06", "Gold or Elixir Full") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_07", "Gold Full and Max.Trophy") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_08", "Elixir Full and Max.Trophy") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_09", "Gold Full or Max.Trophy") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_10", "Elixir Full or Max.Trophy") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_11", "Gold Full") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_12", "Elixir Full") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_13", "Reach Max. Trophy") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_14", "Dark Elixir Full") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_15", "All Storage (G+E+DE) Full") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_16", "Bot running for...") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_17", "Now (Train/Donate Only)") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_18", "Now (Donate Only)") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_19", "Now (Only stay online)") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_20", "W/Shield (Train/Donate Only)") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_21", "W/Shield (Donate Only)") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_22", "W/Shield (Only stay online)") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_23", "At certain time in the day"), GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_17", -1))
	GUICtrlSetOnEvent(-1, "cmbBotCond")
	GUICtrlSetState(-1, $GUI_DISABLE)

	$g_hCmbHoursStop = GUICtrlCreateCombo("", $x + 337, $y - 3, 80, 35, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	_GUICtrlSetTip(-1, $sTxtTip)
	Local $sTxtHours = GetTranslatedFileIni("MBR Global GUI Design", "Hours", "Hours")
	GUICtrlSetData(-1, "-|1 " & GetTranslatedFileIni("MBR Global GUI Design", "Hour", "Hour") & "|2 " & $sTxtHours & "|3 " & $sTxtHours & "|4 " & $sTxtHours & "|5 " & $sTxtHours & "|6 " & _
			$sTxtHours & "|7 " & $sTxtHours & "|8 " & $sTxtHours & "|9 " & $sTxtHours & "|10 " & $sTxtHours & "|11 " & $sTxtHours & "|12 " & _
			$sTxtHours & "|13 " & $sTxtHours & "|14 " & $sTxtHours & "|15 " & $sTxtHours & "|16 " & $sTxtHours & "|17 " & $sTxtHours & "|18 " & _
			$sTxtHours & "|19 " & $sTxtHours & "|20 " & $sTxtHours & "|21 " & $sTxtHours & "|22 " & $sTxtHours & "|23 " & $sTxtHours & "|24 " & $sTxtHours, "-")
	GUICtrlSetState(-1, $GUI_DISABLE)
	$g_hCmbTimeStop = GUICtrlCreateCombo("", $x + 337, $y - 3, 80, 35, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0:00 AM|1:00 AM|2:00 AM|3:00 AM|4:00 AM|5:00 AM|6:00 AM|7:00 AM|8:00 AM|9:00 AM|10:00 AM|11:00 AM" & _
			"|12:00 PM|1:00 PM|2:00 PM|3:00 PM|4:00 PM|5:00 PM|6:00 PM|7:00 PM|8:00 PM|9:00 PM|10:00 PM|11:00 PM", "0:00 AM")
	GUICtrlSetState(-1, $GUI_HIDE)

	$y += 25
	$g_LblResumeAttack = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblResumeAttack", "Resume Attack") & ":", $x + 20, $y + 2, 80, -1)

	$x += 94
	$g_hCmbResumeTime = GUICtrlCreateCombo("", $x + 15, $y - 1, 80, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkResumeAttackTip_01", "After Halt-attack due to time schedule, the Bot will resume attack when the clock turns this time in a day"))
	GUICtrlSetData(-1, "0:00 AM|1:00 AM|2:00 AM|3:00 AM|4:00 AM|5:00 AM|6:00 AM|7:00 AM|8:00 AM|9:00 AM|10:00 AM|11:00 AM" & _
			"|12:00 PM|1:00 PM|2:00 PM|3:00 PM|4:00 PM|5:00 PM|6:00 PM|7:00 PM|8:00 PM|9:00 PM|10:00 PM|11:00 PM", "12:00 PM")
	GUICtrlSetState(-1, $GUI_HIDE)

	$g_ahTxtResumeAttackLoot[$eLootTrophy] = GUICtrlCreateInput("", $x + 15, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))     ;HArchH Was 50 wide, now 40.
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkResumeAttackTip_02", "After Halt-attack due to full resource, the Bot will resume attack when one of the resources drops below this minimum"))
	GUICtrlSetLimit(-1, 4)
	GUICtrlCreateLabel("<", $x + 5, $y + 2, -1, -1)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 56, $y, 16, 16)     ;HArchH Was 65, now 56.

	$g_hChkCollectStarBonus = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollectStarBonus", "When star bonus available"), $x + 15, $y + 20, -1, -1)

	$x += 75
	GUICtrlCreateLabel("<", $x + 5, $y + 2, -1, -1)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 70, $y, 16, 16)
	$g_ahTxtResumeAttackLoot[$eLootGold] = GUICtrlCreateInput("", $x + 15, $y, 55, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkResumeAttackTip_02", -1))
	GUICtrlSetLimit(-1, 8)

	$x += 85
	GUICtrlCreateLabel("<", $x + 5, $y + 2, -1, -1)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 70, $y, 16, 16)
	$g_ahTxtResumeAttackLoot[$eLootElixir] = GUICtrlCreateInput("", $x + 15, $y, 55, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkResumeAttackTip_02", -1))
	GUICtrlSetLimit(-1, 8)

	$x += 80
	GUICtrlCreateLabel("<", $x + 5, $y + 2, -1, -1)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 65, $y, 16, 16)
	$g_ahTxtResumeAttackLoot[$eLootDarkElixir] = GUICtrlCreateInput("", $x + 15, $y, 45, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkResumeAttackTip_02", -1))
	GUICtrlSetLimit(-1, 6)

	$x = 15
	$y += 45
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblBotWillHaltAutomatically", "The bot will Halt automatically when you run out of Resources. It will resume when reaching these minimal values:"), $x + 20, $y, 400, 25, $BS_MULTILINE)

	$y += 30
	$x += 90
	GUICtrlCreateLabel(ChrW(8805), $x + 89, $y + 2, -1, -1)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 149, $y, 16, 16)
	$g_hTxtRestartGold = GUICtrlCreateInput("10000", $x + 99, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtRestartGold_Info_01", "Minimum Gold value for the bot to resume attacking after halting because of low gold."))
	GUICtrlSetLimit(-1, 7)

	$x += 80
	GUICtrlCreateLabel(ChrW(8805), $x + 89, $y + 2, -1, -1)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 149, $y, 16, 16)
	$g_hTxtRestartElixir = GUICtrlCreateInput("25000", $x + 99, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtRestartElixir_Info_01", "Minimum Elixir value for the bot to resume attacking after halting because of low elixir."))
	GUICtrlSetLimit(-1, 7)

	$x += 80
	GUICtrlCreateLabel(ChrW(8805), $x + 89, $y + 2, -1, -1)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 149, $y, 16, 16)
	$g_hTxtRestartDark = GUICtrlCreateInput("500", $x + 99, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtRestartDark_Info_01", "Minimum Dark Elixir value for the bot to resume attacking after halting because of low dark elixir."))
	GUICtrlSetLimit(-1, 6)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 15, $y = 192
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_02", "Collect, Clear"), $x - 10, $y - 20, $g_iSizeWGrpTab3, 170)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnMine, $x - 5, $y, 24, 24)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 20, $y, 24, 24)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDrill, $x + 45, $y, 24, 24)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnLootCart, $x + 70, $y, 24, 24)
	$g_hChkCollect = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollect", "Collect Resources && Loot Cart"), $x + 100, $y - 6, -1, -1, -1)
	GUICtrlSetOnEvent(-1, "ChkCollect")
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollect_Info_01", "Check this to automatically collect the Villages Resources") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollect_Info_02", "from Gold Mines, Elixir Collectors and Dark Elixir Drills.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollect_Info_03", "This will also search for a Loot Cart in your village and collect it."))
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkCollectCartFirst = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollectCartFirst", "Loot Cart first"), $x + 280, $y - 6, -1, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollectCartFirst_Info_01", "Check this to collect the Loot Cart before Villages Resources."))
	GUICtrlSetState(-1, $GUI_CHECKED)

	$x += 179
	$y += 15
	GUICtrlCreateLabel("<", $x, $y + 2, -1, -1)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 60, $y, 16, 16)
	$g_hTxtCollectGold = GUICtrlCreateInput("0", $x + 10, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetState(-1, $GUI_DISABLE)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtCollectGold_Info_01", "Minimum Gold Storage amount to collect Gold.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtCollectGold_Info_02", "Set same as Resume Attack values to collect when 'out of gold' error") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtCollectGold_Info_03", "happens while searching for attack.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtCollectGold_Info_04", "Set to zero to always collect."))
	GUICtrlSetLimit(-1, 7)

	$x += 80
	GUICtrlCreateLabel("<", $x, $y + 2, -1, -1)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 60, $y, 16, 16)
	$g_hTxtCollectElixir = GUICtrlCreateInput("0", $x + 10, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetState(-1, $GUI_DISABLE)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtCollectElixir_Info_01", "Minimum Elixir Storage amount to collect Elixier.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtCollectElixir_Info_02", "Set same as Resume Attack values to collect when 'out of elixir' error") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtCollectElixir_Info_03", "happens during troop training.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtCollectGold_Info_04", -1))
	GUICtrlSetLimit(-1, 7)

	$x += 80
	GUICtrlCreateLabel("<", $x, $y + 2, -1, -1)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 60, $y, 16, 16)
	$g_hTxtCollectDark = GUICtrlCreateInput("0", $x + 10, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetState(-1, $GUI_DISABLE)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtCollectDark_Info_01", "Minimum Dark Elixir Storage amount to collect Dark Elixier.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtCollectElixir_Info_02", -1) & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtCollectElixir_Info_03", -1) & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtCollectGold_Info_04", -1))
	GUICtrlSetLimit(-1, 6)

	$x = 15
	$y += 22
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTreasury, $x + 22, $y - 14, 48, 48)
	$g_hChkTreasuryCollect = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTreasuryCollect", "Treasury"), $x + 100, $y - 2, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTreasuryCollect_Info_01", "Check this to automatically collect Treasury when FULL,") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTreasuryCollect_Info_02", "'OR' when Storage values are BELOW minimum values on right,") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTreasuryCollect_Info_03", "Use zero as min values to ONLY collect when Treasury is full") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTreasuryCollect_Info_04", "Large minimum values will collect Treasury loot more often!"))
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	GUICtrlSetOnEvent(-1, "ChkTreasuryCollect")

	$x += 179
	GUICtrlCreateLabel("<", $x, $y + 2, -1, -1)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 60, $y, 16, 16)
	$g_hTxtTreasuryGold = GUICtrlCreateInput("1000000", $x + 10, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetState(-1, $GUI_DISABLE)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtTreasuryGold_Info_01", "Minimum Gold Storage amount to collect Treasury.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtTreasuryGold_Info_02", "Set same as Resume Attack values to collect when 'out of gold' error") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtTreasuryGold_Info_03", "happens while searching for attack") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTreasuryCollect_Info_01", -1))
	GUICtrlSetLimit(-1, 7)

	$x += 80
	GUICtrlCreateLabel("<", $x, $y + 2, -1, -1)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 60, $y, 16, 16)
	$g_hTxtTreasuryElixir = GUICtrlCreateInput("1000000", $x + 10, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetState(-1, $GUI_DISABLE)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtTreasuryElixir_Info_01", "Minimum Elixir Storage amount to collect Treasury.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtTreasuryElixir_Info_02", "Set same as Resume Attack values to collect when 'out of elixir' error") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtTreasuryElixir_Info_03", "happens during troop training") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTreasuryCollect_Info_01", -1))
	GUICtrlSetLimit(-1, 7)

	$x += 80
	GUICtrlCreateLabel("<", $x, $y + 2, -1, -1)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 60, $y, 16, 16)
	$g_hTxtTreasuryDark = GUICtrlCreateInput("1000", $x + 10, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetState(-1, $GUI_DISABLE)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtTreasuryDark_Info_01", "Minimum Dark Elixir Storage amount to collect Treasury.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtTreasuryElixir_Info_02", -1) & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtTreasuryElixir_Info_03", -1) & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTreasuryCollect_Info_01", -1))
	GUICtrlSetLimit(-1, 6)

	$x = 15
	$y += 21
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTombstone, $x + 32, $y, 24, 24)
	$g_hChkTombstones = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTombstones", "Clear Tombstones"), $x + 100, $y + 4, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTombstones_Info_01", "Check this to automatically clear tombstones after enemy attack."))
	GUICtrlSetState(-1, $GUI_CHECKED)

	;_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTree, $x + 230, $y, 24, 24)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBark, $x + 230, $y, 24, 24)
	$g_hChkCleanYard = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCleanYard", "Remove Obstacles"), $x + 265, $y + 4, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCleanYard_Info_01", "Check this to automatically clear Yard from Trees, Trunks, etc."))
	GUICtrlSetState(-1, $GUI_UNCHECKED)

	$y += 21
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGembox, $x + 32, $y, 24, 24)
	$g_hChkGemsBox = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkGemsBox", "Remove GemBox"), $x + 100, $y + 4, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkGemsBox_Info_01", "Check this to automatically clear GemBox."))
	GUICtrlSetState(-1, $GUI_UNCHECKED)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnPowerPotion, $x + 233, $y + 1, 19, 24)
	$g_hChkFreeMagicItems = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkFreeMagicItems", "Collect Free Magic Items"), $x + 265, $y + 4, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkFreeMagicItems_Info", "Check this to automatically collect free magic items.\r\nMust be at least Th8."))
	GUICtrlSetOnEvent(-1, "ChkFreeMagicItems")
	GUICtrlSetColor(-1, $COLOR_ERROR)

	$y += 21
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollectAchievements, $x + 22, $y - 8, 48, 48)
	$g_hChkCollectAchievements = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollectAchievements", "Collect Achievements"), $x + 100, $y + 4, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollectAchievements_Info", "Check this to automatically collect achievement rewards."))

	$g_hChkCollectRewards = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollectRewards", "Collect Challenge Rewards"), $x + 265, $y + 4, -1, -1)

	$y += 21
	$g_hChkSellRewards = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkSellRewards", "Sell Extras"), $x + 295, $y + 4, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkSellExtra_Info_01", "Check to automatically sell all extra magic item rewards for gems."))

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 20, $y = 363
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_03", "Locate Manually"), $x - 15, $y - 20, $g_iSizeWGrpTab3, 60)
	Local $sTxtRelocate = GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtRelocate_Info_01", "Relocate your") & " "
	$x -= 11
	$y -= 2
	GUICtrlCreateButton(GetTranslatedFileIni("MBR Global GUI Design", "LblTownhall", -1), $x, $y, 36, 36, $BS_ICON)
	_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnTH16, 1)
	_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnTownhall", "Town Hall"))
	GUICtrlSetOnEvent(-1, "btnLocateTownHall")

	$x += 38
	GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnCC", "Clan Castle"), $x, $y, 36, 36, $BS_ICON)
	_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnCC, 1)
	_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnCC", "Clan Castle"))
	GUICtrlSetOnEvent(-1, "btnLocateClanCastle")

	$x += 38
	$g_hBtnLocateKingAltar = GUICtrlCreateButton(GetTranslatedFileIni("MBR Global GUI Design Names Troops", "King", "King"), $x, $y, 36, 36, $BS_ICON)
	_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnKingBoostLocate)
	_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnAltarKing_Info_01", "Barbarian King Altar"))
	GUICtrlSetOnEvent(-1, "btnLocateKingAltar")

	$x += 38
	$g_hBtnLocateQueenAltar = GUICtrlCreateButton(GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Queen", "Queen"), $x, $y, 36, 36, $BS_ICON)
	_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnQueenBoostLocate)
	_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnAltarQueen_Info_01", "Archer Queen Altar"))
	GUICtrlSetOnEvent(-1, "btnLocateQueenAltar")

	$x += 38
	$g_hBtnLocateWardenAltar = GUICtrlCreateButton(GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Grand Warden", "Grand Warden"), $x, $y, 36, 36, $BS_ICON)
	_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnWardenBoostLocate)
	_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnAltarWarden_Info_01", "Grand Warden Altar"))
	GUICtrlSetOnEvent(-1, "btnLocateWardenAltar")

	$x += 38
	$g_hBtnLocateChampionAltar = GUICtrlCreateButton(GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Royal Champion", "Royal Champion"), $x, $y, 36, 36, $BS_ICON)
	_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnChampionBoostLocate)
	_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnAltarChampion_Info_01", "Royal Champion Altar"))
	GUICtrlSetOnEvent(-1, "btnLocateChampionAltar")

	$x += 38
	$g_hBtnLocateLaboratory = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnLocateLaboratory", "Lab."), $x, $y, 36, 36, $BS_ICON)
	_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnLaboratory)
	_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnLocateLaboratory_Info_01", "Laboratory"))
	GUICtrlSetOnEvent(-1, "btnLab")

	$x += 38
	$g_hBtnLocatePetHouse = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnLocatePetHouse", "Pet House"), $x, $y, 36, 36, $BS_ICON)
	_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnPetHouseGreen)
	_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnLocatePetHouse_Info_01", "PetHouse"))
	GUICtrlSetOnEvent(-1, "btnPet")

	$x += 38
	$g_hBtnLocateBlacksmith = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnLocateBlacksmith", "Blacksmith"), $x, $y, 36, 36, $BS_ICON)
	_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnBlacksmithgreen)
	_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnLocateBlacksmith_Info_01", "Blacksmith"))
	GUICtrlSetOnEvent(-1, "btnBsmith")

	$x += 81
	GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnReset", "Reset."), $x, $y, 36, 36, $BS_ICON)
	_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnBldgX)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnReset_Info_01", "Click here to reset all building locations,") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnReset_Info_02", "when you have changed your village layout."))
	GUICtrlSetOnEvent(-1, "btnResetBuilding")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateMiscNormalVillageSubTab

Func CreateMiscBuilderBaseSubTab()
	Local $x = 15, $y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_05", "Builders Base Stats"), $x - 10, $y - 20, $g_iSizeWGrpTab3, 50)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBBGold, $x, $y - 2, 24, 24)
	$g_alblBldBaseStats[$eLootGoldBB] = GUICtrlCreateLabel("---", $x + 35, $y + 2, 100, -1)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBBElix, $x + 130, $y - 2, 24, 24)
	$g_alblBldBaseStats[$eLootElixirBB] = GUICtrlCreateLabel("---", $x + 165, $y + 2, 100, -1)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBBTrophy, $x + 260, $y - 3, 26, 26)
	$g_alblBldBaseStats[$eLootTrophyBB] = GUICtrlCreateLabel("---", $x + 295, $y + 2, 100, -1)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

	$g_ahPicBBLeague[$eBBLeagueUnranked] = _GUICtrlCreateIcon($g_sLibIconPath, $eUnranked, $x + 355, $y - 15, 40, 40)
	GUICtrlSetState(-1, $GUI_SHOW)
	$g_ahPicBBLeague[$eLeagueWood] = _GUICtrlCreateIcon($g_sLibIconPath, $eWood, $x + 355, $y - 12, 40, 40)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicBBLeague[$eLeagueClay] = _GUICtrlCreateIcon($g_sLibIconPath, $eClay, $x + 355, $y - 12, 40, 40)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicBBLeague[$eLeagueStone] = _GUICtrlCreateIcon($g_sLibIconPath, $eStone, $x + 355, $y - 12, 40, 40)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicBBLeague[$eLeagueCopper] = _GUICtrlCreateIcon($g_sLibIconPath, $eCopper, $x + 355, $y - 12, 40, 40)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicBBLeague[$eLeagueBrass] = _GUICtrlCreateIcon($g_sLibIconPath, $eBrass, $x + 355, $y - 12, 40, 40)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicBBLeague[$eLeagueIron] = _GUICtrlCreateIcon($g_sLibIconPath, $eIron, $x + 355, $y - 12, 40, 40)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicBBLeague[$eLeagueSteel] = _GUICtrlCreateIcon($g_sLibIconPath, $eSteel, $x + 355, $y - 12, 40, 40)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicBBLeague[$eLeagueTitanium] = _GUICtrlCreateIcon($g_sLibIconPath, $eTitanium, $x + 355, $y - 12, 40, 40)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicBBLeague[$eLeaguePlatinum] = _GUICtrlCreateIcon($g_sLibIconPath, $ePlatinum, $x + 355, $y - 12, 40, 40)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicBBLeague[$eLeagueEmerald] = _GUICtrlCreateIcon($g_sLibIconPath, $eEmerald, $x + 355, $y - 12, 40, 40)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicBBLeague[$eLeagueRuby] = _GUICtrlCreateIcon($g_sLibIconPath, $eRuby, $x + 355, $y - 12, 40, 40)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicBBLeague[$eLeagueDiamond] = _GUICtrlCreateIcon($g_sLibIconPath, $eDiamond, $x + 355, $y - 12, 40, 40)
	GUICtrlSetState(-1, $GUI_HIDE)

	$g_hLblBBLeague1 = _GUICtrlCreateIcon($g_sLibIconPath, $eLigue1, $x + 382, $y + 12, 10, 10)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hLblBBLeague2 = _GUICtrlCreateIcon($g_sLibIconPath, $eLigue2, $x + 382, $y + 12, 10, 10)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hLblBBLeague3 = _GUICtrlCreateIcon($g_sLibIconPath, $eLigue3, $x + 382, $y + 13, 10, 10)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hLblBBLeague4 = _GUICtrlCreateIcon($g_sLibIconPath, $eLigue4, $x + 382, $y + 13, 10, 10)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hLblBBLeague5 = _GUICtrlCreateIcon($g_sLibIconPath, $eLigue5, $x + 382, $y + 13, 10, 10)
	GUICtrlSetState(-1, $GUI_HIDE)

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y = 75
	Local $iBBAttackGroupSize = 110 ; y size

	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_13", "Builders Base Attacking"), $x - 10, $y, 430, 110)
	$g_hChkEnableBBAttack = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkEnableBBAttack", "Attack"), $x + 20, $y + 20, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkEnableBBAttack_Info_01", "Uses the currently queued army to attack."))
	GUICtrlSetOnEvent(-1, "chkEnableBBAttack")

	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblBBAttackTimes", "Attack Count"), $x + 85, $y + 24)
	$g_hCmbBBAttackCount = GUICtrlCreateCombo("", $x + 150, $y + 20, 65, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblBBAttackTimes_Info_01", "Set how many time Bot will Attack On Builder Base") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblBBAttackTimes_Info_02", "PRO Tips: set Stars will always attack while stars available") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblBBAttackTimes_Info_03", "PRO Tips: set Random will attack random times"))
	GUICtrlSetOnEvent(-1, "cmbBBAttackCount")
	GUICtrlSetData(-1, "Stars|Random|1|2|3|4|5|6|7|8|9|10", "Random")
	GUICtrlSetState(-1, $GUI_DISABLE)

	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblBBNextTroopDelay", "Next Troop Delay"), $x + 85, $y + 51)
	$g_hCmbBBNextTroopDelay = GUICtrlCreateCombo("", $x + 180, $y + 48, 30, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBBNextTroopDelay_Info_01", "Set the delay between different troops. 1 fastest to 9 slowest."))
	GUICtrlSetOnEvent(-1, "cmbBBNextTroopDelay")
	GUICtrlSetData(-1, "1|2|3|4|5|6|7|8|9")
	GUICtrlSetState(-1, $GUI_DISABLE)
	_GUICtrlComboBox_SetCurSel($g_hCmbBBNextTroopDelay, 4)         ; start in middle

	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblBBSameTroopDelay", "Same Troop Delay"), $x + 85, $y + 78)
	$g_hCmbBBSameTroopDelay = GUICtrlCreateCombo("", $x + 180, $y + 75, 30, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBBSameTroopDelay_Info_01", "Set the delay between same troops. 1 fastest to 9 slowest."))
	GUICtrlSetOnEvent(-1, "cmbBBSameTroopDelay")
	GUICtrlSetData(-1, "1|2|3|4|5|6|7|8|9")
	GUICtrlSetState(-1, $GUI_DISABLE)
	_GUICtrlComboBox_SetCurSel($g_hCmbBBSameTroopDelay, 4)         ; start in middle

	$g_hBtnBBDropOrder = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnBBDropOrder", "Drop Order"), $x + 10, $y + 52, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnBBDropOrder_Info", "Set a custom dropping order for your troops."))
	GUICtrlSetBkColor(-1, $COLOR_RED)
	GUICtrlSetOnEvent(-1, "btnBBDropOrder")
	GUICtrlSetState(-1, $GUI_DISABLE)

	$g_hChkBBTrophyRange = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkBBTrophyRange", "Trophies"), $x + 235, $y + 10)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkBBTrophyRange_Info_01", "Enable ability to set a trophy range."))
	GUICtrlSetOnEvent(-1, "chkBBTrophyRange")
	GUICtrlSetState(-1, $GUI_DISABLE)
	$g_hTxtBBTrophyLowerLimit = GUICtrlCreateInput($g_iTxtBBTrophyLowerLimit, $x + 310, $y + 10, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtBBTrophyLimit_Info_01", "If your trophies go below this number then attacking is stopped."))
	GUICtrlSetState(-1, $GUI_DISABLE)
	$g_hTxtBBTrophyUpperLimit = GUICtrlCreateInput($g_iTxtBBTrophyUpperLimit, $x + 360, $y + 10, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtBBTrophyLimit_Info_02", "If your trophies go above this number then the bot drops trophies"))
	GUICtrlSetState(-1, $GUI_DISABLE)

	$g_hChkBBAttIfLootAvail = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkBBAttIfLootAvail", "Only if stars are available"), $x + 235, $y + 35)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkBBAttIfLootAvail_Info_01", "Only attack if there are stars available."))
	GUICtrlSetState(-1, $GUI_DISABLE)

	$g_hChkBBHaltOnGoldFull = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkBBHaltOnGoldFull", "Halt if Gold Full"), $x + 235, $y + 60)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkBBHaltOnFullGold_Info_01", "Halt if Gold Storage is Full."))
	GUICtrlSetState(-1, $GUI_DISABLE)

	$g_hChkBBHaltOnElixirFull = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkBBHaltOnElixirFull", "Halt if Elixir Full"), $x + 330, $y + 60)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkBBHaltOnElixirGold_Info_01", "Halt if Elixir Storage is Full."))
	GUICtrlSetState(-1, $GUI_DISABLE)

	$g_hChkBBWaitForMachine = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkBBWaitForMachine", "Wait For Battle Machine"), $x + 235, $y + 85, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkBBWaitForMachine_Info_01", "Makes the bot not attack while Machine is down."))
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $iOffset = $iBBAttackGroupSize + 5
	Local $x = 15, $y = 90 + $iOffset
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_04", "Collect && Activate"), $x - 10, $y - 20, $g_iSizeWGrpTab3, 85)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGoldMineL5, $x + 7, $y, 24, 24)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixirCollectorL5, $x + 32, $y, 24, 24)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGemMine, $x + 57, $y, 24, 24)
	$g_hChkCollectBuilderBase = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollectBuilderBase", "Collect Resources"), $x + 100, $y + 4, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollectBuildersBase_Info_01", "Check this to collect Resources and Elixir Cart on the Builder Base"))
	$g_hChkCleanBBYard = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCleanBBYard", "Remove Obstacles"), $x + 260, $y + 4, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCleanBBYard_Info_01", "Check this to automatically clear Yard from Trees, Trunks, etc."))
	GUICtrlSetState(-1, $GUI_ENABLE)

	$y += 32
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnClockTower, $x + 32, $y, 24, 24)
	$g_hChkStartClockTowerBoost = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkActivateClockTowerBoost", "Activate Clock Tower Boost"), $x + 100, $y + 4, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkActivateClockTowerBoost_Info_01", "Check this to activate the Clock Tower Boost when it is available.\r\nThis option doesn't use your Gems"))
	GUICtrlSetOnEvent(-1, "chkStartClockTowerBoost")
	$g_hChkCTBoostBlderBz = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCTBoostBlderBz", "only when builder is busy"), $x + 260, $y + 4, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCTBoostBlderBz_Info_01", "boost only when the builder is busy"))
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)


	; BB Building Upgrades
	Local $x = 15, $y = 175 + $iOffset
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_05", "BOB Building Upgrades"), $x - 10, $y - 20, $g_iSizeWGrpTab3, 45)

	Local $sTxtRelocate = GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtRelocateBB_Info_01", "Click on icon to delete your") & " "

	$g_hBtnDelDoubleCannonCoord = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDoubleCannon4, $x + 8, $y - 7, 30, 30)
	_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnDoubleCannon_Info_01", "Double Cannon saved coordinates"))
	GUICtrlSetOnEvent(-1, "DeleteDoubleCannonCoord")
	$g_hChkDoubleCannonUpgrade = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "chkUpgradeDoubleCannon", " "), $x + 40, $y - 3, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkUpgradeDoubleCannon_Info_01", "Check to upgrade the selected Double Cannon to Level 4") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkUpgradeDoubleCannon_Info_02", "Requirement to upgrade BOB Control to Level 2"))
	GUICtrlSetOnEvent(-1, "chkUpgradeDoubleCannon")

	$g_hBtnDelArcherTowerCoord = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnArcheTower6, $x + 81, $y - 6, 28, 28)
	_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnArcherTower_Info_01", "Archer Tower saved coordinates"))
	GUICtrlSetOnEvent(-1, "DeleteArcherTowerCoord")
	$g_hChkArcherTowerUpgrade = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "chkBattleArcherTower", " "), $x + 110, $y - 3, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkArcherTowerUpgrade_Info_01", "Check to upgrade the selected Archer Tower to Level 6") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkArcherTowerUpgrade_Info_02", "Requirement to upgrade BOB Control to Level 2"))
	GUICtrlSetOnEvent(-1, "chkUpgradeArcherTower")

	$g_hBtnDelMultiMortarCoord = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnMultiMortar8, $x + 146, $y - 6, 28, 28)
	_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnMultiMortar_Info_01", "Multi Mortar saved coordinates"))
	GUICtrlSetOnEvent(-1, "DeleteMultiMortarCoord")
	$g_hChkMultiMortarUpgrade = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "chkMultiMortarUpgrade", " "), $x + 180, $y - 3, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkMultiMortarUpgrade_Info_01", "Check to upgrade the Multi Mortar to Level 8") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkMultiMortarUpgrade_Info_02", "Requirement to upgrade BOB Control to Level 2"))
	GUICtrlSetOnEvent(-1, "chkUpgradeMultiMortar")

	$g_hBtnDelCannonCoord = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnCannon9, $x + 210, $y - 15, 44, 44)
	_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnCannon_Info_01", "Cannon Coordinates"))
	GUICtrlSetOnEvent(-1, "DeleteCannonCoord")
	$g_hChkAnyDefUpgrade = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "chkAnyDefUpgrade", " "), $x + 250, $y - 3, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkAnyDefUpgrade_Info_01", "Check to upgrade any defensive building to Level 9") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkAnyDefUpgrade_Info_02", "Requirement to upgrade BOB Control to Level 4") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkAnyDefUpgrade_Info_03", "Cannon is the cheapest defensive building"))
	GUICtrlSetOnEvent(-1, "chkUpgradeAnyDef")

	$g_hBtnBattleMachineCoord = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBattleMachine, $x + 288, $y - 5, 26, 26)
	_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnBattleMachine_Info_01", "BattleMachine saved coordinates"))
	GUICtrlSetOnEvent(-1, "DeleteBattleMachineCoord")
	$g_hChkBattleMachineUpgrade = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "chkBattleMachineUpgrade", " "), $x + 320, $y - 3, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkBattleMachineUpgrade_Info_01", "Check to upgrade the Battle Machine to Level 35") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CChkBattleMachineUpgrade_Info_02", "Requirement to upgrade BOB Control to Level 5") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CChkBattleMachineUpgrade_Info_03", "Combined machines level must be at least 45"))

	$g_hBtnBattlecopterCoord = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBattleCopter, $x + 358, $y - 8, 32, 32)
	_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnBattleCopter_Info_01", "BattleCopter saved coordinates"))
	GUICtrlSetOnEvent(-1, "DeleteBattleCopterCoord")
	$g_hChkBattleCopterUpgrade = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "chkBattleCopterUpgrade", " "), $x + 392, $y - 3, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkBattleCopterUpgrade_Info_01", "Check to upgrade the Battle Copter to Level 35") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CChkBattleMachineUpgrade_Info_02", -1) & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CChkBattleMachineUpgrade_Info_03", -1))

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 15, $y = 220 + $iOffset
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_06", "Suggested Upgrades"), $x - 10, $y - 20, $g_iSizeWGrpTab3, 85)

	_GUICtrlCreateIcon($g_sLibIconPath, $g_sIcnMBisland, $x, $y - 5, 64, 64)
	$g_hChkBBSuggestedUpgrades = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkBBSuggestedUpgrades", "Suggested Upgrades"), $x + 70, $y + 25, -1, -1)
	GUICtrlSetOnEvent(-1, "chkActivateBBSuggestedUpgrades")

	$g_hChkPlacingNewBuildings = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkPlacingNewBuildings", "Build 'New' tagged buildings"), $x + 200, $y - 10, -1, -1)
	GUICtrlSetOnEvent(-1, "chkPlacingNewBuildings")

	$g_hChkBBSuggestedUpgradesIgnoreGold = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkBBSuggestedUpgradesIgnore_01", "Ignore Gold values"), $x + 200, $y + 15, -1, -1)
	GUICtrlSetOnEvent(-1, "chkActivateBBSuggestedUpgradesGold")
	$g_hChkBBSuggestedUpgradesIgnoreElixir = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkBBSuggestedUpgradesIgnore_02", "Ignore Elixir values"), $x + 200, $y + 40, -1, -1)
	GUICtrlSetOnEvent(-1, "chkActivateBBSuggestedUpgradesElixir")
	$g_hChkBBSuggestedUpgradesIgnoreHall = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkBBSuggestedUpgradesIgnore_03", "Ignore Builder Hall"), $x + 315, $y + 15, -1, -1)
	GUICtrlSetOnEvent(-1, "chkActivateBBSuggestedUpgradesGold")
	$g_hChkBBSuggestedUpgradesIgnoreWall = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkBBSuggestedUpgradesIgnore_04", "Ignore Wall"), $x + 315, $y + 40, -1, -1)
	GUICtrlSetOnEvent(-1, "chkActivateBBSuggestedUpgradesGold")

	;Local $x = 15, $y = 200 + $iOffset

	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateMiscBuilderBaseSubTab

; Clan Games v3
Func CreateMiscClanGamesV3SubTab()

	Local Const $g_sLibIconPathMOD = @ScriptDir & "\images\ClanGames.bmp"

	; GUI SubTab
	Local $x = 15, $y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_CG", "Clan Games"), $x - 10, $y - 20, $g_iSizeWGrpTab3 - 5, 245)
	GUICtrlCreatePic($g_sLibIconPathMOD, $x + 5, $y, 94, 128, $SS_BITMAP)

	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesTimeRemaining", "Time Remaining"), $x - 5, $y + 135, 110, 40)
	$g_hLblRemainTime = GUICtrlCreateLabel("0d 00h", $x + 15, $y + 135 + 15, 65, 17, $SS_CENTER)
	GUICtrlSetFont(-1, 9.5, $FW_BOLD, $GUI_FONTNORMAL)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesYourScore", "Your Score"), $x - 5, $y + 158 + 20, 110, 40)
	$g_hLblYourScore = GUICtrlCreateLabel("0/0", $x + 15, $y + 158 + 35, 65, 17, $SS_CENTER)
	GUICtrlSetFont(-1, 9.5, $FW_BOLD, $GUI_FONTNORMAL)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$y = 33
	$x = 135
	$g_hChkClanGamesEnabled = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesEnabled", "Enabled"), $x, $y + 10, -1, -1)
	GUICtrlSetOnEvent(-1, "chkActivateClangames")

	$g_hChkClanGamesDebug = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CGDebug", "Debug CG"), $x + 220, $y + 3, -1, -1)
	_GUICtrlSetTip(-1, "Check To Enable Clan Games Debug.")
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetState(-1, $GUI_HIDE)

	$g_hChkCGDebugEvents = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CGDebugEvents", "CG Events"), $x + 220, $y + 23, -1, -1)
	_GUICtrlSetTip(-1, "Check To Capture CG Events Window.")
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetState(-1, $GUI_HIDE)

	$y += 55
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_CG_Challenges", "Challenges"), $x - 10, $y - 15, $g_iSizeWGrpTab3 - 130, 70)
	$y += 10
	$g_hBtnCGSettingsOpen = GUICtrlCreateButton("Clan Games Settings", $x + 80, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "btnCGSettings")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 80
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_CG_Rewards", "Rewards"), $x - 10, $y - 15, $g_iSizeWGrpTab3 - 130, 70)
	$y += 10
	$g_hChkClanGamesCollectRewards = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesCollectRewards", "Collect"), $x, $y + 2, -1, -1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = 15
	$y = 40
	$g_hTxtClanGamesLog = GUICtrlCreateEdit("", $x - 10, 275, $g_iSizeWGrpTab3, 127, BitOR($GUI_SS_DEFAULT_EDIT, $ES_READONLY, $ES_AUTOVSCROLL))
	GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtClanGamesLog", _
			"--------------------------------------------------------- Clan Games LOG ------------------------------------------------"))

EndFunc   ;==>CreateMiscClanGamesV3SubTab

Func CreateClanGamesSettings()
	Local $tmpChallenges
	$g_hGUI_CGSettings = _GUICreate(GetTranslatedFileIni("GUI Design Child Village - Misc", "GUI_CGSettings", "ClanGames Challenge Settings"), $_GUI_MAIN_WIDTH - 4, $_GUI_MAIN_HEIGHT - 100, $g_iFrmBotPosX, $g_iFrmBotPosY + 80, $WS_DLGFRAME, -1, $g_hFrmBot)
	Local $x = 25, $y = 25

	$g_hClanGamesTV = GUICtrlCreateTreeView(6, 6, 200, $_GUI_MAIN_HEIGHT - 140, BitOR($TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_CHECKBOXES), $WS_EX_CLIENTEDGE)

	$g_hChkCGMainLoot = GUICtrlCreateTreeViewItem("Loot Challenges", $g_hClanGamesTV)
	GUICtrlSetOnEvent(-1, "CGLootTVRoot")
	$tmpChallenges = ClanGamesChallenges("$LootChallenges")
	For $j = 0 To UBound($tmpChallenges) - 1
		$g_ahCGMainLootItem[$j] = GUICtrlCreateTreeViewItem($tmpChallenges[$j][1], $g_hChkCGMainLoot)
		GUICtrlSetOnEvent(-1, "CGLootTVItem")
	Next

	$g_hChkCGMainBattle = GUICtrlCreateTreeViewItem("Battle Challenges", $g_hClanGamesTV)
	GUICtrlSetOnEvent(-1, "CGMainBattleTVRoot")
	$tmpChallenges = ClanGamesChallenges("$BattleChallenges")
	For $j = 0 To UBound($tmpChallenges) - 1
		$g_ahCGMainBattleItem[$j] = GUICtrlCreateTreeViewItem($tmpChallenges[$j][1], $g_hChkCGMainBattle)
		GUICtrlSetOnEvent(-1, "CGMainBattleTVItem")
	Next

	$g_hChkCGMainDestruction = GUICtrlCreateTreeViewItem("Destruction Challenges", $g_hClanGamesTV)
	GUICtrlSetOnEvent(-1, "CGMainDestructionTVRoot")
	$tmpChallenges = ClanGamesChallenges("$DestructionChallenges")
	For $j = 0 To UBound($tmpChallenges) - 1
		$g_ahCGMainDestructionItem[$j] = GUICtrlCreateTreeViewItem($tmpChallenges[$j][1], $g_hChkCGMainDestruction)
		GUICtrlSetOnEvent(-1, "CGMainDestructionTVItem")
	Next

	$g_hChkCGMainAir = GUICtrlCreateTreeViewItem("AirTroop Challenges", $g_hClanGamesTV)
	GUICtrlSetOnEvent(-1, "CGMainAirTVRoot")
	$tmpChallenges = ClanGamesChallenges("$AirTroopChallenges")
	For $j = 0 To UBound($tmpChallenges) - 1
		$g_ahCGMainAirItem[$j] = GUICtrlCreateTreeViewItem($tmpChallenges[$j][1], $g_hChkCGMainAir)
		GUICtrlSetOnEvent(-1, "CGMainAirTVItem")
	Next

	$g_hChkCGMainGround = GUICtrlCreateTreeViewItem("GroundTroop Challenges", $g_hClanGamesTV)
	GUICtrlSetOnEvent(-1, "CGMainGroundTVRoot")
	$tmpChallenges = ClanGamesChallenges("$GroundTroopChallenges")
	For $j = 0 To UBound($tmpChallenges) - 1
		$g_ahCGMainGroundItem[$j] = GUICtrlCreateTreeViewItem($tmpChallenges[$j][1], $g_hChkCGMainGround)
		GUICtrlSetOnEvent(-1, "CGMainGroundTVItem")
	Next

	$g_hChkCGMainMisc = GUICtrlCreateTreeViewItem("Miscellaneous Challenges", $g_hClanGamesTV)
	GUICtrlSetOnEvent(-1, "CGMainMiscTVRoot")
	$tmpChallenges = ClanGamesChallenges("$MiscChallenges")
	For $j = 0 To UBound($tmpChallenges) - 1
		$g_ahCGMainMiscItem[$j] = GUICtrlCreateTreeViewItem($tmpChallenges[$j][1], $g_hChkCGMainMisc)
		GUICtrlSetOnEvent(-1, "CGMainMiscTVItem")
	Next

	$g_hChkCGMainSpell = GUICtrlCreateTreeViewItem("Spell Challenges", $g_hClanGamesTV)
	GUICtrlSetOnEvent(-1, "CGMainSpellTVRoot")
	$tmpChallenges = ClanGamesChallenges("$SpellChallenges")
	For $j = 0 To UBound($tmpChallenges) - 1
		$g_ahCGMainSpellItem[$j] = GUICtrlCreateTreeViewItem($tmpChallenges[$j][1], $g_hChkCGMainSpell)
		GUICtrlSetOnEvent(-1, "CGMainSpellTVItem")
	Next

	$g_hChkCGBBBattle = GUICtrlCreateTreeViewItem("BB Battle Challenges", $g_hClanGamesTV)
	GUICtrlSetOnEvent(-1, "CGBBBattleTVRoot")
	$tmpChallenges = ClanGamesChallenges("$BBBattleChallenges")
	For $j = 0 To UBound($tmpChallenges) - 1
		$g_ahCGBBBattleItem[$j] = GUICtrlCreateTreeViewItem($tmpChallenges[$j][1], $g_hChkCGBBBattle)
		GUICtrlSetOnEvent(-1, "CGBBBattleTVItem")
	Next

	$g_hChkCGBBDestruction = GUICtrlCreateTreeViewItem("BB Destruction Challenges", $g_hClanGamesTV)
	GUICtrlSetOnEvent(-1, "CGBBDestructionTVRoot")
	$tmpChallenges = ClanGamesChallenges("$BBDestructionChallenges")
	For $j = 0 To UBound($tmpChallenges) - 1
		$g_ahCGBBDestructionItem[$j] = GUICtrlCreateTreeViewItem($tmpChallenges[$j][1], $g_hChkCGBBDestruction)
		GUICtrlSetOnEvent(-1, "CGBBDestructionTVItem")
	Next

	$g_hChkCGBBTroops = GUICtrlCreateTreeViewItem("BB Troops Challenges", $g_hClanGamesTV)
	GUICtrlSetOnEvent(-1, "CGBBTroopsTVRoot")
	$tmpChallenges = ClanGamesChallenges("$BBTroopsChallenges")
	For $j = 0 To UBound($tmpChallenges) - 1
		$g_ahCGBBTroopsItem[$j] = GUICtrlCreateTreeViewItem($tmpChallenges[$j][1], $g_hChkCGBBTroops)
		GUICtrlSetOnEvent(-1, "CGBBTroopsTVItem")
	Next

	$x = 220
	$y -= 23
	$g_hChkForceBBAttackOnClanGames = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkForceBBAttackOnClanGames", "Always Force BB Attack"), $x, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "chkClanGamesBB")
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGames_Info_02", "If Enabled : Ignore BB Trophy, BB Loot, BB Wait BM"))
	GUICtrlSetState(-1, $GUI_DISABLE)

	$y += 23
	$g_hChkForceAttackOnClanGamesWhenHalt = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkForceAttackOnClanGamesWhenHalt", "Always Force Attack in Halt Mode"), $x, $y, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGames_Info_03", "If Enabled : Ignore Halt Mode If A Challenge Is Running (Attack !)" & @CRLF & _
			"For Stop Mode, Close Mode, Etc, Finish Running Challenge First"))
	GUICtrlSetState(-1, $GUI_DISABLE)

	$y += 33
	$g_hChkClanGamesPurgeAny = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesPurgeAny", "Purge Any Challenge If No Challenge Found"), $x, $y, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGames_Info_04", "If No Challenge Found, Purge Any"))
	GUICtrlSetOnEvent(-1, "ChkClanGamesPurgeAny")

	$y += 33
	$g_hChkClanGamesStopBeforeReachAndPurge = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesStopBeforeReachAndPurge", "Stop before completing your limit and only Purge"), $x, $y, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGames_Info_06", "Stop Selecting Challenges 300 points before End And Purge" & @CRLF & _
			"But not purge on last day of Clan Games"))

	$y += 35
	GUIStartGroup()
	$g_hChkClanGamesAllTimes = GUICtrlCreateRadio("All Challenges", $x + 20, $y, -1, -1)
	_GUICtrlSetTip(-1, "Classic Behaviour : All Times Challenges")
	GUICtrlSetOnEvent(-1, "ChkClanGamesAllTimes")
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkClanGamesNoOneDay = GUICtrlCreateRadio("No 1 Day Challenges", $x + 120, $y, -1, -1)
	_GUICtrlSetTip(-1, "Not choose 1 Day Challenges, This Will be 8 Hours Or 3 Hours Challenges")
	GUICtrlSetOnEvent(-1, "ChkClanGamesNoOneDay")
	GUICtrlSetState(-1, $GUI_UNCHECKED)

	$y += 35
	$g_hChkClanGamesSort = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesSort", "Sort Challenges By :"), $x, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "chkSortClanGames")
	GUICtrlSetState(-1, $GUI_CHECKED)

	$y += 23
	$g_hCmbClanGamesSort = GUICtrlCreateCombo("", $x + 20, $y, 120, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	Local $sCmbTxt = "Easier Difficulties|Shortest Time|Longest Time"
	GUICtrlSetData(-1, $sCmbTxt, "Easier Difficulties")

	$y += 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ClangamesDesc", "Description"), $x - 10, $y - 15, 250, 120)
	$g_hLabelClangamesDesc = GUICtrlCreateLabel("", $x, $y, 230, 100)
	GUICtrlSetFont(-1, 9, $FW_BOLD, $GUI_FONTITALIC)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 135
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ClangamesPriority", "Challenges Priority Select"), $x - 10, $y - 15, 250, 45)
	$hSearchBBEventFirst = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "SearchBBEventFirst", "BB First"), $x, $y, -1, -1)
	GUICtrlSetState(-1, $GUI_UNCHECKED)

	$x += 65
	$hSearchMainEventFirst = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "SearchMainEventFirst", "Main First"), $x, $y, -1, -1)
	GUICtrlSetState(-1, $GUI_UNCHECKED)

	$x += 70
	$hSearchBothVillages = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "SearchBothVillages", "Both Equal"), $x, $y, -1, -1)
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x -= 135
	$y += 50
	$g_hChkCGRootEnabledAll = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCGRootEnableAllItem", "Challenges inherit Challenge Category"), $x, $y, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCGRootEnableAllItem02", "Enable/Disable this to quickly set/clear all group sub-elements"))
	GUICtrlSetState(-1, $GUI_UNCHECKED)

	$y += 20
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCGRootEnableHelp", "You must pick the container and its sub-element(s) to enable challenge(s)."), $x + 17, $y, 230, 40)

	$g_hBtnCGSettingsClose = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnCGSettings", "Close"), $_GUI_MAIN_WIDTH - 100, $_GUI_MAIN_HEIGHT - 160, 85, 25)
	GUICtrlSetOnEvent(-1, "CloseCGSettings")

EndFunc   ;==>CreateClanGamesSettings

; Builder base drop order gui
Func CreateBBDropOrderGUI()
	$g_hGUI_BBDropOrder = _GUICreate(GetTranslatedFileIni("GUI Design Child Village - Misc", "GUI_BBDropOrder", "BB Custom Drop Order"), 322, 313, -1, -1, $WS_BORDER, $WS_EX_CONTROLPARENT)


	Local $x = 25, $y = 25
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BBDropOrderGroup", "BB Custom Dropping Order"), $x - 20, $y - 20, 308, 250)
	$x += 10
	$y += 20

	$g_hChkBBCustomDropOrderEnable = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BBChkCustomDropOrderEnable", "Enable Custom Dropping Order"), $x - 13, $y - 22, -1, -1)
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BBChkCustomDropOrderEnable_Info_01", "Enable to select a custom troops dropping order"))
	GUICtrlSetOnEvent(-1, "chkBBDropOrder")

	$y += 5
	For $i = 0 To $g_iBBTroopCount - 1
		If $i < 6 Then
			GUICtrlCreateLabel($i + 1 & ":", $x - 19, $y + 3 + 25 * $i, -1, 18)
			$g_ahCmbBBDropOrder[$i] = GUICtrlCreateCombo("", $x, $y + 25 * $i, 94, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetOnEvent(-1, "GUIBBDropOrder")
			GUICtrlSetData(-1, $g_sBBDropOrderDefault)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtBBDropOrder", "Enter sequence order for drop of troop #" & $i + 1))
			GUICtrlSetState(-1, $GUI_DISABLE)
		Else
			GUICtrlCreateLabel($i + 1 & ":", $x + 150 - 19, $y + 3 + 25 * ($i - 6), -1, 18)
			$g_ahCmbBBDropOrder[$i] = GUICtrlCreateCombo("", $x + 150, $y + 25 * ($i - 6), 94, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetOnEvent(-1, "GUIBBDropOrder")
			GUICtrlSetData(-1, $g_sBBDropOrderDefault)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtBBDropOrder", "Enter sequence order for drop of troop #" & $i + 1))
			GUICtrlSetState(-1, $GUI_DISABLE)
		EndIf
	Next

	$x = 25
	$y = 225
	; Create push button to set training order once completed
	$g_hBtnBBDropOrderSet = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnBBDropOrderSet", "Apply New Order"), $x, $y, 100, 25)
	GUICtrlSetState(-1, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnBBDropOrderSet_Info_01", "Push button when finished selecting custom troops dropping order") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnBBDropOrderSet_Info_02", "When not all troop slots are filled, will use default order."))
	GUICtrlSetOnEvent(-1, "BtnBBDropOrderSet")

	$x += 150
	$g_hBtnBBRemoveDropOrder = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnBBRemoveDropOrder", "Empty Drop List"), $x, $y, 118, 25)
	GUICtrlSetState(-1, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnBBRemoveDropOrder_Info_01", "Push button to remove all troops from list and start over"))
	GUICtrlSetOnEvent(-1, "BtnBBRemoveDropOrder")

	$g_hBtnBBClose = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnBBDropOrderClose", "Close"), 229, 258, 85, 25)
	GUICtrlSetOnEvent(-1, "CloseCustomBBDropOrder")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateBBDropOrderGUI

Func CreateClanCapitalTab()
	Local $x = 15, $y = 40
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_ClanCapital_01", "Stats"), $x - 10, $y - 15, $g_iSizeWGrpTab3 - 3, 70)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCapitalGold, $x, $y + 1, 24, 24)
	$g_lblCapitalGold = GUICtrlCreateLabel("---", $x + 35, $y + 5, 100, -1)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCapitalMedal, $x + 110, $y, 24, 24)
	$g_lblCapitalMedal = GUICtrlCreateLabel("---", $x + 145, $y + 5, 100, -1)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCapitalTrophy, $x + 220, $y - 4, 32, 32)
	$g_lblCapitalTrophies = GUICtrlCreateLabel("---", $x + 255, $y + 5, 100, -1)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

	$y += 30

	$g_hChkEnableCollectCCGold = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CollectCCGold", "Collect Clan Capital Gold"), $x, $y, -1, -1)

	GUICtrlCreateLabel("", $x + 313, $y - 39, 1, 63)
	GUICtrlSetBkColor(-1, 0xC3C3C3)

	$g_ahPicCCLeague[$eLeagueUnranked] = _GUICtrlCreateIcon($g_sLibIconPath, $eUnranked, $x + 345, $y - 27, 46, 46)
	GUICtrlSetState(-1, $GUI_SHOW)
	$g_ahPicCCLeague[$eLeagueBronze] = _GUICtrlCreateIcon($g_sLibIconPath, $eBronze, $x + 345, $y - 27, 46, 46)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicCCLeague[$eLeagueSilver] = _GUICtrlCreateIcon($g_sLibIconPath, $eSilver, $x + 345, $y - 26, 46, 46)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicCCLeague[$eLeagueGold] = _GUICtrlCreateIcon($g_sLibIconPath, $eGold, $x + 345, $y - 24, 46, 46)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicCCLeague[$eLeagueCrystal] = _GUICtrlCreateIcon($g_sLibIconPath, $eCrystal, $x + 345, $y - 28, 46, 46)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicCCLeague[$eLeagueMaster] = _GUICtrlCreateIcon($g_sLibIconPath, $eMaster, $x + 345, $y - 24, 46, 46)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicCCLeague[$eLeagueChampion] = _GUICtrlCreateIcon($g_sLibIconPath, $eLChampion, $x + 345, $y - 25, 46, 46)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicCCLeague[$eLeagueTitan] = _GUICtrlCreateIcon($g_sLibIconPath, $eTitan, $x + 345, $y - 25, 46, 46)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicCCLeague[$eLeagueLegend] = _GUICtrlCreateIcon($g_sLibIconPath, $eLegend, $x + 345, $y - 27, 46, 46)
	GUICtrlSetState(-1, $GUI_HIDE)

	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblLeague", "League"), $x + 345, $y - 38, -1, -1, $SS_CENTER)

	$g_hLblCCLeague1 = _GUICtrlCreateIcon($g_sLibIconPath, $eLigue1, $x + 376, $y + 6, 10, 10)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hLblCCLeague2 = _GUICtrlCreateIcon($g_sLibIconPath, $eLigue2, $x + 376, $y + 6, 10, 10)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hLblCCLeague3 = _GUICtrlCreateIcon($g_sLibIconPath, $eLigue3, $x + 376, $y + 7, 10, 10)
	GUICtrlSetState(-1, $GUI_HIDE)

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_ClanCapital_02", "Forge/Craft Gold"), $x - 10, $y - 15, $g_iSizeWGrpTab3 - 3, 113)
	$g_hChkEnableForgeGold = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "EnableCCGoldForgeGold", "Use Gold"), $x, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "ChkEnableForgeGold")
	$g_hLbacmdGoldSaveMin = GUICtrlCreateLabel("Save : ", $x + 70, $y + 4, -1, -1)
	$g_acmdGoldSaveMin = GUICtrlCreateInput("150000", $x + 110, $y + 2, 55, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetLimit(-1, 8)
	$y += 20
	$g_hChkEnableForgeElix = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "EnableCCGoldForgeElix", "Use Elixir"), $x, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "ChkEnableForgeElix")
	$g_hLbacmdElixSaveMin = GUICtrlCreateLabel("Save : ", $x + 70, $y + 4, -1, -1)
	$g_acmdElixSaveMin = GUICtrlCreateInput("1000", $x + 110, $y + 2, 55, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetLimit(-1, 8)
	$x += 100
	$y -= 20
	$g_hChkEnableForgeDE = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "EnableCCGoldForgeDE", "Use Dark"), $x - 100, $y + 40, -1, -1)
	GUICtrlSetOnEvent(-1, "ChkEnableForgeDE")
	$g_hLbacmdDarkSaveMin = GUICtrlCreateLabel("Save : ", $x - 30, $y + 44, -1, -1)
	$g_acmdDarkSaveMin = GUICtrlCreateInput("1000", $x + 10, $y + 42, 55, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetLimit(-1, 6)
	$g_hChkEnableSmartUse = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "EnableSmartUse", "Smart Use of Resources"), $x + 115, $y + 40, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "EnableSmartUse_Info_01", "If checked, Bot will use resources in the order of their values.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "EnableSmartUse_Info_02", "If unchecked, Bot will use resources by type."))
	$y += 20
	$g_hChkEnableForgeBBElix = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "EnableCCGoldForgeBBElix", "Use BB Elixir"), $x + 115, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "ChkEnableForgeBBElix")
	$g_hLbacmdBBElixSaveMin = GUICtrlCreateLabel("Save : ", $x + 200, $y + 4, -1, -1)
	$g_acmdBBElixSaveMin = GUICtrlCreateInput("1000", $x + 240, $y + 2, 55, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetLimit(-1, 7)
	$x += 115
	$y -= 20
	$g_hChkEnableForgeBBGold = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "EnableCCGoldForgeBBGold", "Use BB Gold"), $x, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "ChkEnableForgeBBGold")
	$g_hLbacmdBBGoldSaveMin = GUICtrlCreateLabel("Save : ", $x + 85, $y + 4, -1, -1)
	$g_acmdBBGoldSaveMin = GUICtrlCreateInput("1000", $x + 125, $y + 2, 55, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetLimit(-1, 7)
	$x = 15
	$y += 68
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblForgeUseBuilder", "Use "), $x, $y + 2, 45, 17)
	$g_hCmbForgeBuilder = GUICtrlCreateCombo("", $x + 24, $y - 2, 40, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0|1|2|3|4", "0")
	GUICtrlSetOnEvent(-1, "CmbForgeBuilder")
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "InputForgeUseBuilder", "Put How many builder to use to Forge"))
	$g_hLbCmbForgeBuilder = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblForgeBuilder", "Builder for Forge"), $x + 69, $y + 2, 100, 25)

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 47
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_ClanCapital_03", "Auto Upgrade Clan Capital"), $x - 10, $y - 15, $g_iSizeWGrpTab3 - 3, 65)
	$g_hChkEnableAutoUpgradeCC = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkEnableAutoUpgradeCC", "Enable"), $x, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "EnableAutoUpgradeCC")
	$y += 20
	$g_hChkAutoUpgradeCCPriorArmy = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkAutoUpgradeCCPriorArmy", "Prior Army Stuff"), $x, $y, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Info_ChkAutoUpgradeCCPriorArmy", "Prior Army Camps, Barracks, Fortress Yard, Spell Storage and Factory"))
	$g_hChkAutoUpgradeCCIgnore = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkAutoUpgradeCCIgnore", "Ignore Decoration Buildings"), $x + 100, $y, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Info_ChkAutoUpgradeCCIgnore", "Enable Ignore Upgrade for Groove, Tree, Forest, Campsite, etc..."))
	$g_hChkAutoUpgradeCCWallIgnore = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkAutoUpgradeCCWallIgnore", "Ignore Walls"), $x + 255, $y, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Info_ChkAutoUpgradeCCWallIgnore", "Enable Ignore Upgrade for Walls"))
	$y += 40
	$g_hTxtAutoUpgradeCCLog = GUICtrlCreateEdit("", $x - 10, $y, $g_iSizeWGrpTab3 - 3, 105, BitOR($GUI_SS_DEFAULT_EDIT, $ES_READONLY, $ES_AUTOVSCROLL))
	GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtCCLog", "------------------------------------------- CLAN CAPITAL UPGRADE LOG --------------------------------------"))
	GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc   ;==>CreateClanCapitalTab
