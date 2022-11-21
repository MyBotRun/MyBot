; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Misc" tab under the "Village" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017), Chilly-Chill (2019)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once
Global $g_hGUI_MISC = 0, $g_hGUI_MISC_TAB = 0, $g_hGUI_MISC_TAB_ITEM1 = 0, $g_hGUI_MISC_TAB_ITEM2 = 0, $g_hGUI_MISC_TAB_ITEM3 = 0, $g_hGUI_MISC_TAB_ITEM4 = 0

Global $g_hChkBotStop = 0, $g_hCmbBotCommand = 0, $g_hCmbBotCond = 0, $g_hCmbHoursStop = 0, $g_hCmbTimeStop = 0
Global $g_LblResumeAttack = 0, $g_ahTxtResumeAttackLoot[$eLootCount] = [0, 0, 0, 0], $g_hCmbResumeTime = 0
Global $g_hChkCollectStarBonus = 0
Global $g_hTxtRestartGold = 0, $g_hTxtRestartElixir = 0, $g_hTxtRestartDark = 0
Global $g_hChkTrap = 1, $g_hChkCollect = 1, $g_hChkTombstones = 1, $g_hChkCleanYard = 0, $g_hChkGemsBox = 0
Global $g_hChkCollectCartFirst = 0, $g_hTxtCollectGold = 0, $g_hTxtCollectElixir = 0, $g_hTxtCollectDark = 0
Global $g_hBtnLocateSpellfactory = 0, $g_hBtnLocateDarkSpellFactory = 0
Global $g_hBtnLocateKingAltar = 0, $g_hBtnLocateQueenAltar = 0, $g_hBtnLocateWardenAltar = 0, $g_hBtnLocateChampionAltar = 0, $g_hBtnLocateLaboratory = 0, $g_hBtnLocatePetHouse = 0, $g_hBtnResetBuilding = 0
Global $g_hChkTreasuryCollect = 0, $g_hTxtTreasuryGold = 0, $g_hTxtTreasuryElixir = 0, $g_hTxtTreasuryDark = 0 , $g_hChkCollectAchievements = 0, $g_hChkFreeMagicItems = 0, $g_hChkCollectRewards = 0, $g_hChkSellRewards = 0

Global $g_alblBldBaseStats[3] = ["", "", ""]
Global $g_hChkCollectBuilderBase = 0, $g_hChkStartClockTowerBoost = 0, $g_hChkCTBoostBlderBz = 0, $g_hChkCleanBBYard = 0
Global $g_hChkCollectBldGE = 0, $g_hChkCollectBldGems = 0, $g_hChkActivateClockTower = 0
Global $g_hChkBattleMachineUpgrade = 0 ; grumpy
Global $g_hChkDoubleCannonUpgrade = 0
Global $g_hChkArcherTowerUpgrade = 0
Global $g_hChkMultiMortarUpgrade = 0
Global $g_hChkMegaTeslaUpgrade = 0
Global $g_hChkBBSuggestedUpgrades = 0, $g_hChkBBSuggestedUpgradesIgnoreGold = 0 , $g_hChkBBSuggestedUpgradesIgnoreElixir , $g_hChkBBSuggestedUpgradesIgnoreHall = 0
Global $g_hChkPlacingNewBuildings = 0, $g_hChkBBSuggestedUpgradesIgnoreWall = 0

; Clan Games
Global $g_hChkClanGamesAir = 0, $g_hChkClanGamesGround = 0, $g_hChkClanGamesMisc = 0
Global $g_hChkClanGamesEnabled = 0 , $g_hChkClanGames60 = 0
Global $g_hChkClanGamesLoot = 0 , $g_hChkClanGamesBattle =0 , $g_hChkClanGamesDestruction = 0 , $g_hChkClanGamesAirTroop = 0 , $g_hChkClanGamesGroundTroop = 0 , $g_hChkClanGamesMiscellaneous = 0
global $g_hChkClanGamesSpell = 0

Global $g_hChkClanGamesBBBattle = 0, $g_hChkClanGamesBBDestruction = 0

Global $g_hChkClanGamesNightVillage = 0

Global $g_hChkClanGamesPurgeHome = 0
Global $g_hChkClanGamesPurgeNight = 0

Global $g_hChkClanGamesPurge = 0 , $g_hcmbPurgeLimit = 0 , $g_hChkClanGamesStopBeforeReachAndPurge = 0
Global $g_hTxtClanGamesLog = 0
Global $g_hChkClanGamesDebug = 0
Global $g_hChkClanGamesDebugImages = 0
Global $g_hChkClanGamesCollectRewards = 0
Global $g_hLblRemainTime = 0 , $g_hLblYourScore = 0

;ClanCapitalTAB
Global $g_lblCapitalGold = 0, $g_lblCapitalMedal = 0, $g_hCmbForgeBuilder = 0, $g_hChkEnableAutoUpgradeCC = 0, $g_hChkAutoUpgradeCCIgnore = 0, $g_hTxtAutoUpgradeCCLog = 0, $g_hChkAutoUpgradeCCWallIgnore = 0, _
$g_hChkAutoUpgradeCCPriorArmy = 0
Global $g_hChkEnableCollectCCGold = 0, $g_hChkEnableForgeGold = 0, $g_hChkEnableForgeElix = 0, $g_hChkEnableForgeDE = 0, $g_hChkEnableForgeBBGold = 0, $g_hChkEnableForgeBBElix = 0

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

		$g_ahTxtResumeAttackLoot[$eLootTrophy] = GUICtrlCreateInput("", $x + 15, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER)) ;HArchH Was 50 wide, now 40.
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkResumeAttackTip_02", "After Halt-attack due to full resource, the Bot will resume attack when one of the resources drops below this minimum"))
		GUICtrlSetLimit(-1, 4)
		GUICtrlCreateLabel("<", $x + 5, $y + 2, -1, -1)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 56, $y, 16, 16) ;HArchH Was 65, now 56.

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
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_02", "Collect, Clear"), $x -10, $y - 20, $g_iSizeWGrpTab3, 170)
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
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTombstone, $x + 32 , $y, 24, 24)
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

        _GUICtrlCreateIcon($g_sLibIconPath, $eIcnPowerPotion, $x + 233, $y + 1 , 19, 24)
		$g_hChkFreeMagicItems = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkFreeMagicItems", "Collect Free Magic Items"), $x + 265, $y + 4, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkFreeMagicItems_Info", "Check this to automatically collect free magic items.\r\nMust be at least Th8."))
			GUICtrlSetOnEvent(-1, "ChkFreeMagicItems")
			GUICtrlSetColor ( -1, $COLOR_ERROR )

	$y += 21
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollectAchievements, $x + 22, $y - 8 , 48, 48)
		$g_hChkCollectAchievements = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollectAchievements", "Collect Achievements"), $x + 100, $y + 4, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollectAchievements_Info", "Check this to automatically collect achievement rewards."))

		$g_hChkCollectRewards = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollectRewards", "Collect Challenge Rewards"), $x + 265, $y + 4, -1, -1)

	$y += 21
		$g_hChkSellRewards = GUICtrlCreateCheckBox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkSellRewards", "Sell Extras"), $x + 295, $y + 4, -1, -1)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkSellExtra_Info_01", "Check to automatically sell all extra magic item rewards for gems."))

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 20, $y = 363
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_03", "Locate Manually"), $x - 15, $y - 20, $g_iSizeWGrpTab3, 60)
		Local $sTxtRelocate = GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtRelocate_Info_01", "Relocate your") & " "
	$x -= 11
	$y -= 2
		GUICtrlCreateButton(GetTranslatedFileIni("MBR Global GUI Design", "LblTownhall", -1), $x, $y, 36, 36, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnTH15, 1)
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

	$x += 119
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

		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBBElix, $x + 140, $y - 2, 24, 24)
		$g_alblBldBaseStats[$eLootElixirBB] = GUICtrlCreateLabel("---", $x + 175, $y + 2, 100, -1)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBBTrophy, $x + 280, $y - 2, 24, 24)
		$g_alblBldBaseStats[$eLootTrophyBB] = GUICtrlCreateLabel("---", $x + 315, $y + 2, 100, -1)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y = 75
	Local $iBBAttackGroupSize = 110 ; y size

	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_13", "Builders Base Attacking"), $x - 10,  $y, $g_iSizeWGrpTab3, $iBBAttackGroupSize)
		$g_hChkEnableBBAttack = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkEnableBBAttack", "Attack"), $x + 20, $y + 30, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkEnableBBAttack_Info_01", "Uses the currently queued army to attack."))
			GUICtrlSetOnEvent(-1, "chkEnableBBAttack")
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblBBNextTroopDelay", "Next Troop Delay"), $x + 113, $y + 17)
		$g_hCmbBBNextTroopDelay = GUICtrlCreateCombo( "", $x+138, $y + 34, 30, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBBNextTroopDelay_Info_01", "Set the delay between different troops. 1 fastest to 9 slowest."))
			GUICtrlSetOnEvent(-1, "cmbBBNextTroopDelay")
			GUICtrlSetData(-1, "1|2|3|4|5|6|7|8|9")
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlComboBox_SetCurSel($g_hCmbBBNextTroopDelay, 4) ; start in middle
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblBBSameTroopDelay", "Same Troop Delay"), $x + 113, $y + 63)
		$g_hCmbBBSameTroopDelay = GUICtrlCreateCombo( "", $x+138, $y + 80, 30, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBBSameTroopDelay_Info_01", "Set the delay between same troops. 1 fastest to 9 slowest."))
			GUICtrlSetOnEvent(-1, "cmbBBSameTroopDelay")
			GUICtrlSetData(-1, "1|2|3|4|5|6|7|8|9")
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlComboBox_SetCurSel($g_hCmbBBSameTroopDelay, 4) ; start in middle
		$g_hBtnBBDropOrder = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnBBDropOrder", "Drop Order"), $x + 10, $y + 62, -1, -1)
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

		$g_hChkBBAttIfLootAvail = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkBBAttIfLootAvail", "Only if loot is available"), $x + 235, $y + 35)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkBBAttIfLootAvail_Info_01", "Only attack if there is loot available."))
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
		$g_hChkCollectBuilderBase = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollectBuilderBase", "Collect Ressources"), $x + 100, $y + 4, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollectBuildersBase_Info_01", "Check this to collect Ressources on the Builder Base"))
		$g_hChkCleanBBYard = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCleanBBYard", "Remove Obstacles"), $x + 260, $y + 4, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCleanBBYard_Info_01", "Check this to automatically clear Yard from Trees, Trunks, etc."))
			GUICtrlSetState (-1, $GUI_ENABLE)

	$y += 32
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnClockTower, $x + 32, $y, 24, 24)
		$g_hChkStartClockTowerBoost = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkActivateClockTowerBoost", "Activate Clock Tower Boost"), $x + 100, $y + 4, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkActivateClockTowerBoost_Info_01", "Check this to activate the Clock Tower Boost when it is available.\r\nThis option doesn't use your Gems"))
			GUICtrlSetOnEvent(-1, "chkStartClockTowerBoost")
		$g_hChkCTBoostBlderBz = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCTBoostBlderBz", "only when builder is busy"), $x + 260, $y + 4, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCTBoostBlderBz_Info_01", "boost only when the builder is busy"))
			GUICtrlSetState (-1, $GUI_DISABLE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)


; BB Building Upgrades
	;Local $iOffset = $iBBAttackGroupSize + 5
	Local $x = 15, $y = 175 + $iOffset
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_05", "OTTO Building Upgrades"), $x - 10, $y - 20, $g_iSizeWGrpTab3, 45)

		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBattleMachine, $x + 10, $y - 5 , 26, 26)
		$g_hChkBattleMachineUpgrade = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "chkBattleMachineUpgrade", " "), $x + 40, $y - 3, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkBattleMachineUpgrade_Info_01", "Check to upgrade the Battle Machine to Level 30"))
			GUICtrlSetOnEvent(-1, "chkUpgradeBattleMachine")

		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDoubleCannon4, $x + 87, $y - 7 , 30, 30)
		$g_hChkDoubleCannonUpgrade = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "chkUpgradeDoubleCannon", " "), $x + 120, $y - 3, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkUpgradeDoubleCannon_Info_01", "Check to upgrade the selected Double Cannon to Level 4"))
			GUICtrlSetOnEvent(-1, "chkUpgradeDoubleCannon")
			
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnArcheTower6, $x + 170, $y - 7 , 28, 28)
		$g_hChkArcherTowerUpgrade = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "chkBattleArcherTower", " "), $x + 200, $y - 3, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkArcherTowerUpgrade_Info_01", "Check to upgrade the selected Archer Tower to Level 6"))
			GUICtrlSetOnEvent(-1, "chkUpgradeArcherTower")
			
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnMultiMortar8, $x + 247, $y - 7 , 28, 28)
		$g_hChkMultiMortarUpgrade = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "chkMultiMortarUpgrade", " "), $x + 280, $y - 3, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkMultiMortarUpgrade_Info_01", "Check to upgrade the Multi Mortar to Level 8"))
			GUICtrlSetOnEvent(-1, "chkUpgradeMultiMortar")
			
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnMegaTesla9, $x + 330, $y - 7 , 28, 28)
		$g_hChkMegaTeslaUpgrade = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "chkMegaTeslaUpgrade", " "), $x + 360, $y - 3, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkMegaTeslaUpgrade_Info_01", "Check to upgrade the Mega Tesla to Level 9"))
			GUICtrlSetOnEvent(-1, "chkUpgradeMegaTesla")

	Local $x = 15, $y = 220 + $iOffset
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_06", "Suggested Upgrades"), $x - 10, $y - 20, $g_iSizeWGrpTab3, 85)

		_GUICtrlCreateIcon($g_sLibIconPath, $g_sIcnMBisland, $x , $y - 5 , 64, 64)
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
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_CG", "Clan Games"), $x - 10, $y - 20, $g_iSizeWGrpTab3, 245)
		GUICtrlCreatePic($g_sLibIconPathMOD, $x + 5, $y, 94, 128, $SS_BITMAP)

		GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesTimeRemaining", "Time Remaining"), $x - 5, $y + 135, 110, 40)
			$g_hLblRemainTime = GUICtrlCreateLabel("0d 00h", $x + 15, $y + 135 + 15, 65, 17, $SS_CENTER)
				GUICtrlSetFont(-1, 9.5, $FW_BOLD, $GUI_FONTNORMAL)
		GUICtrlCreateGroup("", -99, -99, 1, 1)

		GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesYourScore", "Your Score"), $x - 5, $y + 158 + 20, 110, 40)
			$g_hLblYourScore = GUICtrlCreateLabel("0/0", $x + 15, $y + 158 + 35, 65, 17, $SS_CENTER)
				GUICtrlSetFont(-1, 9.5, $FW_BOLD, $GUI_FONTNORMAL)
		GUICtrlCreateGroup("", -99, -99, 1, 1)

	;$x = 110
	$x = 135
	$g_hChkClanGamesCollectRewards = GUICtrlCreateCheckBox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesCollectRewards", "Collect Rewards"), $x, $y, -1, -1)
	$g_hChkClanGamesDebug = GUICtrlCreateCheckBox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesDebug", "Debug"), $x + 100, $y, -1, -1)
	$g_hChkClanGamesDebugImages = GUICtrlCreateCheckBox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesDebugImages", "Debug Event Images"), $x + 155, $y, -1, -1)
	
	$y += 30
		$g_hChkClanGamesEnabled = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesEnabled", "Home Village Challenges"), $x, $y, -1, -1)
			GUICtrlSetOnEvent(-1, "chkActivateClangames")
		$g_hChkClanGamesNightVillage = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesNightVillage", "Night Village Challenges"), $x + 155, $y, -1, -1)
			GUICtrlSetOnEvent(-1, "chkActivateClangamesNightVillage")

;		$g_hChkClanGames60 = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGames60", "No 60min Events"), $x + 100 , $y, -1, -1)
;			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGames60_Info_01", "will not choose 60 minute events"))
	;$x += 10


	$y += 20
		$g_hChkClanGamesLoot = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesLoot", "Loot Challenges"), $x, $y, -1, -1)


	$y += 20
		$g_hChkClanGamesBattle = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesBattle", "Battle Challenges"), $x, $y, -1, -1)


	$y += 20
		$g_hChkClanGamesDestruction = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesDestruction", "Destruction Challenges"), $x, $y, -1, -1)

	$y += 20
		$g_hChkClanGamesAirTroop = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesAirTroop", "Air Troops Challenges"), $x, $y, -1, -1)
        ;$g_hChkClanGamesBBDestruction = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesBBDestruction", "BB Destruction Challenges"), $x + 155, $y, -1, -1)


	$y += 20
		$g_hChkClanGamesGroundTroop = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesGroundTroop", "Ground Troops Challenges"), $x, $y, -1, -1)


	$y += 20
		$g_hChkClanGamesSpell = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesSpell", "Spell Challenges"), $x, $y, -1, -1)


	$y += 20
		$g_hChkClanGamesMiscellaneous = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesMiscellaneous", "Miscellaneous Challenges"), $x, $y, -1, -1)


	$y += 20
		$g_hChkClanGamesPurgeHome = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesPurgeHome", "Purge Home Village Events"), $x, $y, -1, -1)
		$g_hChkClanGamesPurgeNight = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesPurgeNight", "Purge Night Village Events"), $x + 155, $y, -1, -1)

		;$g_hChkClanGamesDebug = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesDebug", "Debug"), $x, $y, -1, -1)
		;$g_hChkClanGamesDebugImages = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesDebugImages", "Debug Event Images"), $x + 155, $y, -1, -1)

;	$y += 25
;		$g_hChkClanGamesPurge = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesPurge", "Purge Versus Battles Events"), $x, $y, -1, -1)
			;GUICtrlSetOnEvent(-1, "chkPurgeLimits")
		;$g_hcmbPurgeLimit = GUICtrlCreateCombo("" , $x + 155, $y, 70, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		;	GUICtrlSetData(-1, "Unlimited| 1x| 2x| 3x| 4x| 5x| 6x| 7x| 8x| 9x|10x", " 5x")
	;$y += 25
	;	$g_hChkClanGamesStopBeforeReachAndPurge = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesStopBeforeReachAndPurge", "Stop before completing your limit and only Purge"), $x, $y, -1, -1)

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = 15
	$y = 45
	$g_hTxtClanGamesLog = GUICtrlCreateEdit("", $x - 10, 275, $g_iSizeWGrpTab3, 127, BitOR($GUI_SS_DEFAULT_EDIT, $ES_READONLY, $ES_AUTOVSCROLL))
	GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtClanGamesLog", _
			"--------------------------------------------------------- Clan Games LOG ------------------------------------------------"))

EndFunc   ;==>CreateMiscClanGamesV3SubTab

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

		$y+=5
		For $i=0 To $g_iBBTroopCount-1
			If $i < 6 Then
				GUICtrlCreateLabel($i + 1 & ":", $x - 19, $y + 3 + 25*$i, -1, 18)
				$g_ahCmbBBDropOrder[$i] = GUICtrlCreateCombo("", $x, $y + 25*$i, 94, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
					GUICtrlSetOnEvent(-1, "GUIBBDropOrder")
					GUICtrlSetData(-1,  $g_sBBDropOrderDefault)
					_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtBBDropOrder", "Enter sequence order for drop of troop #" & $i + 1))
					GUICtrlSetState(-1, $GUI_DISABLE)
			Else
				GUICtrlCreateLabel($i + 1 & ":", $x + 150 - 19, $y + 3 + 25*($i-6), -1, 18)
				$g_ahCmbBBDropOrder[$i] = GUICtrlCreateCombo("", $x+150, $y + 25*($i-6), 94, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
					GUICtrlSetOnEvent(-1, "GUIBBDropOrder")
					GUICtrlSetData(-1,  $g_sBBDropOrderDefault)
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

EndFunc ;==>CreateBBDropOrderGUI


Func CreateClanCapitalTab()
	Local $x = 15, $y = 40
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_ClanCapital_01", "Stats"), $x - 10, $y - 15, $g_iSizeWGrpTab3 - 3, 70)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCapitalGold,  $x, $y, 24, 24)
		$g_lblCapitalGold = GUICtrlCreateLabel("---", $x + 35, $y + 5, 100, -1)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCapitalMedal, $x + 140, $y, 24, 24)
		$g_lblCapitalMedal = GUICtrlCreateLabel("---", $x + 175, $y + 5, 100, -1)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		$y += 30
		$g_hChkEnableCollectCCGold = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CollectCCGold", "Collect Clan Capital Gold"), $x, $y, -1, -1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_ClanCapital_02", "Forge/Craft Gold"), $x - 10, $y - 15, $g_iSizeWGrpTab3 - 3, 88)
		$g_hChkEnableForgeGold = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "EnableCCGoldForgeGold", "Use Gold"), $x, $y, -1, -1)
	$y += 20
		$g_hChkEnableForgeElix = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "EnableCCGoldForgeElix", "Use Elixir"), $x, $y, -1, -1)
	$x += 100
	$y -= 20
		$g_hChkEnableForgeDE = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "EnableCCGoldForgeDE", "Use Dark Elixir"), $x, $y, -1, -1)
	$y += 20
		$g_hChkEnableForgeBBGold = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "EnableCCGoldForgeBBGold", "Use BuilderBase Gold"), $x, $y, -1, -1)
	$x += 140
	$y -= 20
		$g_hChkEnableForgeBBElix = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "EnableCCGoldForgeBBElix", "Use BuilderBase Elixir"), $x, $y, -1, -1)
	$x = 15
	$y += 48
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblForgeUseBuilder", "Use "), $x, $y + 2, 45, 17)
		$g_hCmbForgeBuilder = GUICtrlCreateCombo("", $x + 23, $y, 40, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, "1|2|3|4", "1")
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "InputForgeUseBuilder", "Put How many builder to use to Forge"))
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblForgeBuilder", "Builder for Forge"), $x + 65, $y + 2, 100, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 47
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_ClanCapital_03", "Auto Upgrade Clan Capital"), $x - 10, $y - 15, $g_iSizeWGrpTab3 - 3, 65)
		$g_hChkEnableAutoUpgradeCC = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkEnableAutoUpgradeCC", "Enable"), $x, $y, -1, -1)
		GUICtrlSetOnEvent(-1 , "EnableAutoUpgradeCC")
	$y += 20
		$g_hChkAutoUpgradeCCPriorArmy = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkAutoUpgradeCCPriorArmy", "Prior Army Stuff"), $x , $y , -1, -1)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Info_ChkAutoUpgradeCCPriorArmy", "Prior Army Camps, Barracks, Fortress Yard, Spell Storage and Factory"))
		$g_hChkAutoUpgradeCCIgnore = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkAutoUpgradeCCIgnore", "Ignore Decoration Buildings"), $x + 100, $y, -1, -1)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Info_ChkAutoUpgradeCCIgnore", "Enable Ignore Upgrade for Groove, Tree, Forest, Campsite, etc..."))
		$g_hChkAutoUpgradeCCWallIgnore = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkAutoUpgradeCCWallIgnore", "Ignore Walls"), $x + 255, $y , -1, -1)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Info_ChkAutoUpgradeCCWallIgnore", "Enable Ignore Upgrade for Walls"))
	$y += 40
	$g_hTxtAutoUpgradeCCLog = GUICtrlCreateEdit("", $x - 10, $y, $g_iSizeWGrpTab3 - 3, 120, BitOR($GUI_SS_DEFAULT_EDIT, $ES_READONLY, $ES_AUTOVSCROLL))
	GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtCCLog", "------------------------------------------- CLAN CAPITAL UPGRADE LOG --------------------------------------"))
	GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc
