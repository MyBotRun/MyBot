; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Misc" tab under the "Village" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once
Global $g_hGUI_MISC = 0, $g_hGUI_MISC_TAB = 0, $g_hGUI_MISC_TAB_ITEM1 = 0, $g_hGUI_MISC_TAB_ITEM2 = 0, $g_hGUI_MISC_TAB_ITEM3 = 0

Global $g_hChkBotStop = 0, $g_hCmbBotCommand = 0, $g_hCmbBotCond = 0, $g_hCmbHoursStop = 0
Global $g_hTxtRestartGold = 0, $g_hTxtRestartElixir = 0, $g_hTxtRestartDark = 0
Global $g_hChkTrap = 1, $g_hChkCollect = 1, $g_hChkTombstones = 1, $g_hChkCleanYard = 0, $g_hChkGemsBox = 0
Global $g_hBtnLocateSpellfactory = 0, $g_hBtnLocateDarkSpellFactory = 0
Global $g_hBtnLocateKingAltar = 0, $g_hBtnLocateQueenAltar = 0, $g_hBtnLocateWardenAltar = 0, $g_hBtnLocateLaboratory = 0, $g_hBtnResetBuilding = 0
Global $g_hChkTreasuryCollect = 0, $g_hTxtTreasuryGold = 0, $g_hTxtTreasuryElixir = 0, $g_hTxtTreasuryDark = 0 , $g_hChkFreeMagicItems = 0

Global $g_alblBldBaseStats[4] = ["", "", ""]
Global $g_hChkCollectBuilderBase = 0, $g_hChkStartClockTowerBoost = 0, $g_hChkCTBoostBlderBz = 0
Global $g_hChkCollectBldGE = 0, $g_hChkCollectBldGems = 0, $g_hChkActivateClockTower = 0
Global $g_hChkBBSuggestedUpgrades = 0, $g_hChkBBSuggestedUpgradesIgnoreGold = 0 , $g_hChkBBSuggestedUpgradesIgnoreElixir , $g_hChkBBSuggestedUpgradesIgnoreHall = 0
Global $g_hChkPlacingNewBuildings = 0

Global $g_hChkClanGamesAir = 0, $g_hChkClanGamesGround = 0, $g_hChkClanGamesMisc = 0
Global $g_hChkClanGamesEnabled = 0
Global $g_hChkClanGamesLoot = 0 , $g_hChkClanGamesBattle =0 , $g_hChkClanGamesDestruction = 0 , $g_hChkClanGamesAirTroop = 0 , $g_hChkClanGamesGroundTroop = 0 , $g_hChkClanGamesMiscellaneous = 0
Global $g_hChkClanGamesPurge = 0 , $g_hcmbPurgeLimit = 0 , $g_hChkClanGamesStopBeforeReachAndPurge = 0
Global $g_hTxtClanGamesLog = 0
Global $g_hChkClanGamesDebug = 0
Global $g_hLblRemainTime = 0 , $g_hLblYourScore = 0

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
	GUICtrlCreateTabItem("")

EndFunc   ;==>CreateVillageMisc

Func CreateMiscNormalVillageSubTab()
	Local $sTxtTip = ""
	Local $x = 15, $y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_01", "Halt Attack"), $x - 10, $y - 20, $g_iSizeWGrpTab3, 98)
		$g_hChkBotStop = GUICtrlCreateCheckbox("", $x - 5, $y, 16, 16)
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
							   GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCommand_Item_07", "Reboot PC"), GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCommand_Item_01", -1))
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
							   GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_22", "W/Shield (Only stay online)"), GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_17", -1))
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

	$y += 25
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblBotWillHaltAutomatically", "The bot will Halt automatically when you run out of Resources. It will resume when reaching these minimal values."), $x + 20, $y, 400, 25, $BS_MULTILINE)

	$y += 30
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblResumeAttack", "Resume Attack") & ":", $x + 20, $y + 2, 80, -1)

	$x += 90
		GUICtrlCreateLabel(ChrW(8805), $x + 22, $y + 2, -1, -1)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 84, $y, 16, 16)
		$g_hTxtRestartGold = GUICtrlCreateInput("10000", $x + 32, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtRestartGold_Info_01", "Minimum Gold value for the bot to resume attacking after halting because of low gold."))
			GUICtrlSetLimit(-1, 7)

	$x += 90
		GUICtrlCreateLabel(ChrW(8805), $x + 22, $y + 2, -1, -1)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 84, $y, 16, 16)
		$g_hTxtRestartElixir = GUICtrlCreateInput("25000", $x + 32, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtRestartElixir_Info_01", "Minimum Elixir value for the bot to resume attacking after halting because of low elixir."))
			GUICtrlSetLimit(-1, 7)

	$x += 90
		GUICtrlCreateLabel(ChrW(8805), $x + 22, $y + 2, -1, -1)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 84, $y, 16, 16)
		$g_hTxtRestartDark = GUICtrlCreateInput("500", $x + 32, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtRestartDark_Info_01", "Minimum Dark Elixir value for the bot to resume attacking after halting because of low dark elixir."))
			GUICtrlSetLimit(-1, 6)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 15, $y = 145
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_02", "Rearm, Collect, Clear"), $x -10, $y - 20, $g_iSizeWGrpTab3, 217)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrap, $x + 7, $y, 24, 24)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnXbow, $x + 32, $y, 24, 24)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnInferno, $x + 57, $y, 24, 24)
		$g_hChkTrap = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTrap", "Rearm Traps && Reload Xbows and Infernos"), $x + 100, $y + 4, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTrap_Info_01", "Check this to automatically Rearm Traps, Reload Xbows and Infernos (if any) in your Village."))
			GUICtrlSetState(-1, $GUI_CHECKED)

	$y += 32
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnMine, $x - 5, $y, 24, 24)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 20, $y, 24, 24)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDrill, $x + 45, $y, 24, 24)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnLootCart, $x + 70, $y, 24, 24)
		$g_hChkCollect = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollect", "Collect Resources && Loot Cart"), $x + 100, $y + 4, -1, -1, -1)
			GUICtrlSetOnEvent(-1, "ChkCollect")
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollect_Info_01", "Check this to automatically collect the Village's Resources") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollect_Info_02", "from Gold Mines, Elixir Collectors and Dark Elixir Drills.") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollect_Info_03", "This will also search for a Loot Cart in your village and collect it."))
			GUICtrlSetState(-1, $GUI_CHECKED)

	$y += 32
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTreasury, $x + 22, $y - 10, 48, 48)
		$g_hChkTreasuryCollect = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTreasuryCollect", "Treasury"), $x + 100, $y + 4, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTreasuryCollect_Info_01", "Check this to automatically collect Treasury when FULL,") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTreasuryCollect_Info_02", "'OR' when Storage values are BELOW minimum values on right,") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTreasuryCollect_Info_03", "Use zero as min values to ONLY collect when Treasury is full") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTreasuryCollect_Info_04", "Large minimum values will collect Treasury loot more often!"))
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "ChkTreasuryCollect")

	$x += 170
	$y -= 10
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 55, $y + 4, 16, 16)
		GUICtrlCreateLabel("<", $x + 47, $y + 6, -1, -1)
		$g_hTxtTreasuryGold = GUICtrlCreateInput("1000000", $x + 72, $y + 4, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtTreasuryGold_Info_01", "Minimum Gold Storage amount to collect Treasury.") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtTreasuryGold_Info_02", "Set same as Resume Attack values to collect when 'out of gold' error") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtTreasuryGold_Info_03", "happens while searching for attack") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTreasuryCollect_Info_01", -1))
			GUICtrlSetLimit(-1, 7)
	$y += 12
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblTreasuryOr", "Or"), $x, $y + 6, -1, -1)
	$y += 12
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 55, $y + 4, 16, 16)
		GUICtrlCreateLabel("<", $x + 47, $y + 6, -1, -1)
		$g_hTxtTreasuryElixir = GUICtrlCreateInput("1000000", $x + 72, $y + 4, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtTreasuryElixir_Info_01", "Minimum Elixir Storage amount to collect Treasury.") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtTreasuryElixir_Info_02", "Set same as Resume Attack values to collect when 'out of elixir' error") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtTreasuryElixir_Info_03", "happens during troop training") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTreasuryCollect_Info_01", -1))
			GUICtrlSetLimit(-1, 7)
	$y -= 12
	$x += 125
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblTreasuryOr", -1), $x + 4, $y + 6, -1, -1)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 55, $y + 4, 16, 16)
		GUICtrlCreateLabel("<", $x + 47, $y + 6, -1, -1)
		$g_hTxtTreasuryDark = GUICtrlCreateInput("1000", $x + 72, $y + 4, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtTreasuryDark_Info_01", "Minimum Dark Elixir Storage amount to collect Treasury.") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtTreasuryElixir_Info_02", -1) & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtTreasuryElixir_Info_03", -1) & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTreasuryCollect_Info_01", -1))
			GUICtrlSetLimit(-1, 6)

	$x -= (170 + 126)
	$y += 32
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTombstone, $x + 32 , $y, 24, 24)
		$g_hChkTombstones = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTombstones", "Clear Tombstones"), $x + 100, $y + 4, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTombstones_Info_01", "Check this to automatically clear tombstones after enemy attack."))
			GUICtrlSetState(-1, $GUI_CHECKED)

	$y += 32
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTree, $x + 20, $y, 24, 24)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBark, $x + 45, $y, 24, 24)
		$g_hChkCleanYard = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCleanYard", "Remove Obstacles"), $x + 100, $y + 4, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCleanYard_Info_01", "Check this to automatically clear Yard from Trees, Trunks, etc."))
			GUICtrlSetState(-1, $GUI_UNCHECKED)

	$y += 32
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGembox, $x + 32, $y, 24, 24)
		$g_hChkGemsBox = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkGemsBox", "Remove GemBox"), $x + 100, $y + 4, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkGemsBox_Info_01", "Check this to automatically clear GemBox."))
			GUICtrlSetState(-1, $GUI_UNCHECKED)

		$g_hChkFreeMagicItems = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkFreeMagicItems", "Collect Free Magic Items"), $x + 250, $y + 4, -1, -1)
	$y -= 64
		Local const $icon = @ScriptDir & "\images\Potion.bmp"
		GUICtrlCreatePic($icon, $x + 300, $y + 20, 36, 47, $SS_BITMAP)

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 20, $y = 363
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_03", "Locate Manually"), $x - 15, $y - 20, $g_iSizeWGrpTab3, 60)
		Local $sTxtRelocate = GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtRelocate_Info_01", "Relocate your") & " "
	$x -= 11
	$y -= 2
		GUICtrlCreateButton(GetTranslatedFileIni("MBR Global GUI Design", "LblTownhall", -1), $x, $y, 36, 36, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnTH11, 1)
			_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnTownhall", -1))
			GUICtrlSetOnEvent(-1, "btnLocateTownHall")

	$x += 38
		GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnCC", "Clan Castle"), $x, $y, 36, 36, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnCC, 1)
			_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnCC", -1))
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
		$g_hBtnLocateLaboratory = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnLocateLaboratory", "Lab."), $x, $y, 36, 36, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnLaboratory)
			_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnLocateLaboratory_Info_01", "Laboratory"))
			GUICtrlSetOnEvent(-1, "btnLab")

	$x += 195
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

		_GUICtrlCreatePic($g_sIcnBldGold, $x, $y - 2, 24, 24)
		$g_alblBldBaseStats[$eLootGoldBB] = GUICtrlCreateLabel("---", $x + 35, $y + 2, 100, -1)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

		_GUICtrlCreatePic($g_sIcnBldElixir, $x + 140, $y - 2, 24, 24)
		$g_alblBldBaseStats[$eLootElixirBB] = GUICtrlCreateLabel("---", $x + 175, $y + 2, 100, -1)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

		_GUICtrlCreatePic($g_sIcnBldTrophy, $x + 280, $y - 2, 24, 24)
		$g_alblBldBaseStats[$eLootTrophyBB] = GUICtrlCreateLabel("---", $x + 315, $y + 2, 100, -1)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 15, $y = 100
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_04", "Collect && Activate"), $x - 10, $y - 20, $g_iSizeWGrpTab3, 80)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnGoldMineL5, $x + 7, $y, 24, 24)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixirCollectorL5, $x + 32, $y, 24, 24)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnGemMine, $x + 57, $y, 24, 24)
		$g_hChkCollectBuilderBase = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollectBuilderBase", "Collect Ressources"), $x + 100, $y + 4, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollectBuildersBase_Info_01", "Check this to collect Ressources on the Builder Base"))

	$y += 32
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnClockTower, $x + 32, $y, 24, 24)
		$g_hChkStartClockTowerBoost = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkActivateClockTowerBoost", "Activate Clock Tower Boost"), $x + 100, $y + 4, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkActivateClockTowerBoost_Info_01", "Check this to activate the Clock Tower Boost when it is available.\r\nThis option doesn't use your Gems"))
			GUICtrlSetOnEvent(-1, "chkStartClockTowerBoost")
		$g_hChkCTBoostBlderBz = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCTBoostBlderBz", "only when builder is busy"), $x + 260, $y + 4, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCTBoostBlderBz_Info_01", "boost only when the builder is busy"))
			GUICtrlSetState (-1, $GUI_DISABLE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 15, $y = 190
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_06", "Suggested Upgrades"), $x - 10, $y - 20, $g_iSizeWGrpTab3, 233)

		_GUICtrlCreatePic($g_sIcnMBisland, $x , $y , 64, 64)
		$g_hChkBBSuggestedUpgrades = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkBBSuggestedUpgrades", "Suggested Upgrades"), $x + 70, $y + 25, -1, -1)
			GUICtrlSetOnEvent(-1, "chkActivateBBSuggestedUpgrades")
		$g_hChkBBSuggestedUpgradesIgnoreGold = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkBBSuggestedUpgradesIgnore_01", "Ignore Gold values"), $x + 200, $y + 15, -1, -1)
			GUICtrlSetOnEvent(-1, "chkActivateBBSuggestedUpgradesGold")
		$g_hChkBBSuggestedUpgradesIgnoreElixir = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkBBSuggestedUpgradesIgnore_02", "Ignore Elixir values"), $x + 200, $y + 40, -1, -1)
			GUICtrlSetOnEvent(-1, "chkActivateBBSuggestedUpgradesElixir")
		$g_hChkBBSuggestedUpgradesIgnoreHall = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkBBSuggestedUpgradesIgnore_03", "Ignore Builder Hall"), $x + 315, $y + 28, -1, -1)
			GUICtrlSetOnEvent(-1, "chkActivateBBSuggestedUpgradesGold")

	Local $x = 15, $y = 200
		$g_hChkPlacingNewBuildings = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkPlacingNewBuildings", "Build 'New' tagged buildings"), $x + 70, $y + 60, -1, -1)
			GUICtrlSetOnEvent(-1, "chkPlacingNewBuildings")
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

	$x = 150
		$g_hChkClanGamesEnabled = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesEnabled", "Clan Games"), $x, $y, -1, -1)
		GUICtrlSetOnEvent(-1, "chkActivateClangames")
		$g_hChkClanGamesDebug = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesDebug", "Debug"), $x + 205, $y, -1, -1)
	$x += 25
	$y += 25
		$g_hChkClanGamesLoot = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesLoot", "Loot Challenges"), $x, $y, -1, -1)
	$y += 25
		$g_hChkClanGamesBattle = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesBattle", "Battle Challenges"), $x, $y, -1, -1)
	$y += 25
		$g_hChkClanGamesDestruction = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesDestruction", "Destruction Challenges"), $x, $y, -1, -1)
	$y += 25
		$g_hChkClanGamesAirTroop = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesAirTroop", "Air Troops Challenges"), $x, $y, -1, -1)
	$y += 25
		$g_hChkClanGamesGroundTroop = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesGroundTroop", "Ground Troops Challenges"), $x, $y, -1, -1)
	$y += 25
		$g_hChkClanGamesMiscellaneous = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesMiscellaneous", "Miscellaneous Challenges"), $x, $y, -1, -1)
	$y += 25
		$g_hChkClanGamesPurge = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesPurge", "Purge Versus Battles Events"), $x, $y, -1, -1)
			GUICtrlSetOnEvent(-1, "chkPurgeLimits")
		$g_hcmbPurgeLimit = GUICtrlCreateCombo("" , $x + 155, $y, 70, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "Unlimited| 1x| 2x| 3x| 4x| 5x| 6x| 7x| 8x| 9x|10x", " 5x")
	$y += 25
		$g_hChkClanGamesStopBeforeReachAndPurge = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesStopBeforeReachAndPurge", "Stop before completing your limit and only Purge"), $x, $y, -1, -1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = 15
	$y = 45
	$g_hTxtClanGamesLog = GUICtrlCreateEdit("", $x - 10, 275, $g_iSizeWGrpTab3, 127, BitOR($GUI_SS_DEFAULT_EDIT, $ES_READONLY, $ES_AUTOVSCROLL))
	GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtClanGamesLog", _
			"--------------------------------------------------------- Clan Games LOG ------------------------------------------------"))

EndFunc   ;==>CreateMiscClanGamesV3SubTab
