; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Upgrade" tab under the "Village" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_UPGRADE = 0, $g_hGUI_UPGRADE_TAB = 0, $g_hGUI_UPGRADE_TAB_ITEM1 = 0, $g_hGUI_UPGRADE_TAB_ITEM2 = 0, $g_hGUI_UPGRADE_TAB_ITEM3 = 0, _
		$g_hGUI_UPGRADE_TAB_ITEM4 = 0, $g_hGUI_UPGRADE_TAB_ITEM5 = 0

; Lab
Global $g_hChkAutoLabUpgrades = 0, $g_hCmbLaboratory = 0, $g_hLblNextUpgrade = 0, $g_hBtnResetLabUpgradeTime = 0, $g_hPicLabUpgrade = 0
Global $g_hChkAutoStarLabUpgrades = 0, $g_hCmbStarLaboratory = 0, $g_hLblNextSLUpgrade = 0, $g_hBtnResetStarLabUpgradeTime = 0, $g_hPicStarLabUpgrade = 0

; Heroes
Global $g_hChkUpgradeKing = 0, $g_hChkUpgradeQueen = 0, $g_hChkUpgradeWarden = 0, $g_hPicChkKingSleepWait = 0, $g_hPicChkQueenSleepWait = 0, $g_hPicChkWardenSleepWait = 0
Global $g_hCmbHeroReservedBuilder = 0, $g_hLblHeroReservedBuilderTop = 0, $g_hLblHeroReservedBuilderBottom = 0
Global $g_hChkUpgradeChampion = 0, $g_hPicChkChampionSleepWait = 0, $g_hBtnHeroEquipment = 0
Global $g_hGUI_HeroEquipment = 0, $g_hBtnHeroEquipmentClose = 0

Global $g_hChkUpgradePets[$ePetCount]

; Buildings
Global $g_hChkUpgrade[$g_iUpgradeSlots] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hPicUpgradeStatus[$g_iUpgradeSlots] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hTxtUpgradeName[$g_iUpgradeSlots] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hTxtUpgradeLevel[$g_iUpgradeSlots] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hPicUpgradeType[$g_iUpgradeSlots] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hTxtUpgradeValue[$g_iUpgradeSlots] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hTxtUpgradeTime[$g_iUpgradeSlots] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hTxtUpgradeEndTime[$g_iUpgradeSlots] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hChkUpgradeRepeat[$g_iUpgradeSlots] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hTxtUpgrMinGold = 0, $g_hTxtUpgrMinElixir = 0, $g_hTxtUpgrMinDark = 0

; Walls
Global $g_hChkWalls = 0, $g_hTxtWallMinGold = 0, $g_hTxtWallMinElixir = 0, $g_hRdoUseGold = 0, $g_hRdoUseElixir = 0, $g_hRdoUseElixirGold = 0, $g_hChkSaveWallBldr = 0, _
		$g_hCmbWalls = 4
Global $g_hLblWallCost = 0, $g_hBtnFindWalls = 0
Global $g_ahWallsCurrentCount[18] = [-1, -1, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] ; elements 0 to 3 are not referenced
Global $g_ahPicWallsLevel[18] = [-1, -1, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] ; elements 0 to 3 are not referenced

; Auto Upgrade
Global $g_hChkAutoUpgrade = 0, $g_hLblAutoUpgrade = 0, $g_hTxtAutoUpgradeLog = 0
Global $g_hTxtSmartMinGold = 0, $g_hTxtSmartMinElixir = 0, $g_hTxtSmartMinDark = 0
Global $g_hChkResourcesToIgnore[3] = [0, 0, 0]
Global $g_hChkUpgradesToIgnore[16] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

Func CreateVillageUpgrade()

	; ensure all language translation are created
	InitTranslatedTextUpgradeTab()

	$g_hGUI_UPGRADE = _GUICreate("", $g_iSizeWGrpTab2, $g_iSizeHGrpTab2, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_VILLAGE)
	;GUISetBkColor($COLOR_WHITE, $g_hGUI_UPGRADE)

	GUISwitch($g_hGUI_UPGRADE)
	$g_hGUI_UPGRADE_TAB = GUICtrlCreateTab(0, 0, $g_iSizeWGrpTab2, $g_iSizeHGrpTab2, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
	$g_hGUI_UPGRADE_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_02_STab_03_STab_01", "Laboratory"))
	CreateLaboratorySubTab()
	$g_hGUI_UPGRADE_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_02_STab_03_STab_02", "Heroes"))
	CreateHeroesSubTab()
	$g_hGUI_UPGRADE_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_02_STab_03_STab_03", "Buildings"))
	CreateBuildingsSubTab()
	$g_hGUI_UPGRADE_TAB_ITEM5 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_02_STab_03_STab_05", "Auto Upgrade"))
	CreateAutoUpgradeSubTab()
	$g_hGUI_UPGRADE_TAB_ITEM4 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_02_STab_03_STab_04", "Walls"))
	CreateWallsSubTab()
	CreateHeroEquipment()
	GUICtrlCreateTabItem("")

EndFunc   ;==>CreateVillageUpgrade

Func CreateLaboratorySubTab()
	Local $sTxtNames = GetTranslatedFileIni("MBR Global GUI Design", "Any", "Any") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBarbarians", "Barbarians") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtArchers", "Archers") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtGiants", "Giants") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtGoblins", "Goblins") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtWallBreakers", "Wall Breakers") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBalloons", "Balloons") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtWizards", "Wizards") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtHealers", "Healers") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtDragons", "Dragons") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtPekkas", "Pekkas") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBabyDragons", "Baby Dragons") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtMiners", "Miners") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtEDragon", "Electro Dragon") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtYeti", "Yeti") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtDragonRider", "Dragon Rider") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtElectroTitans", "Electro Titans") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtRootRiders", "Root Riders") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtLightningSpells", "Lightning Spell") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtHealingSpells", "Healing Spell") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtRageSpells", "Rage Spell") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtJumpSpells", "Jump Spell") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtFreezeSpells", "Freeze Spell") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtCloneSpells", "Clone Spell") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtInvisibilitySpells", "Invisibility Spell") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtRecallSpells", "Recall Spell") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtPoisonSpells", "Poison Spell") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtEarthQuakeSpells", "EarthQuake Spell") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtHasteSpells", "Haste Spell") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtSkeletonSpells", "Skeleton Spell") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtBatSpells", "Bat Spell") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtOvergrowthSpells", "Overgrowth Spell") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtMinions", "Minions") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtHogRiders", "Hog Riders") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtValkyries", "Valkyries") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtGolems", "Golems") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtWitches", "Witches") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtLavaHounds", "Lava Hounds") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBowlers", "Bowlers") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtIceGolems", "Ice Golems") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtHeadhunters", "Headhunters") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtAppWards", "App. Warden") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtWallWreckers", "Wall Wreckers") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBattleBlimps", "Battle Blimps") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtStoneSlammers", "Stone Slammers") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSiegeBarracks", "Siege Barracks") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtLogLaunchers", "Log Launchers") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtFlameFlingers", "Flame Flingers") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBattleDrills", "Battle Drills")

	Local $sTxtSLNames = GetTranslatedFileIni("MBR Global GUI Design", "Any", "Any") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Builderbase Troops", "TxtRagedBarbarian", "Raged Barbarian") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Builderbase Troops", "TxtSneakyArcher", "Sneaky Archer") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Builderbase Troops", "TxtBoxerGiant", "Boxer Giant") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Builderbase Troops", "TxtBetaMinion", "Beta Minion") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Builderbase Troops", "TxtBomber", "Bomber") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Builderbase Troops", "TxtBabyDragon", "Baby Dragon") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Builderbase Troops", "TxtCannonCart", "Cannon Cart") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Builderbase Troops", "TxtNightWitch", "Night Witch") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Builderbase Troops", "TxtDropShip", "Drop Ship") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Builderbase Troops", "TxtSuperPekka", "Super Pekka") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Builderbase Troops", "TxtHogGlider", "Hog Glider") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Builderbase Troops", "TxtEFWizard", "ElectroFire Wizard")

	Local $x = 25, $y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "Group_01", "Laboratory"), $x - 20, $y - 20, $g_iSizeWGrpTab3, 100)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnLabUpgrade, $x, $y, 64, 64)
	$g_hChkAutoLabUpgrades = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "ChkAutoLabUpgrades", "Auto Laboratory Upgrades"), $x + 80, $y + 5, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "ChkAutoLabUpgrades_Info_01", "Check box to enable automatically starting Upgrades in laboratory"))
	GUICtrlSetOnEvent(-1, "chkLab")
	$g_hLblNextUpgrade = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "LblNextUpgrade", "Next one") & ":", $x + 80, $y + 38, 50, -1)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$g_hCmbLaboratory = GUICtrlCreateCombo("", $x + 135, $y + 35, 140, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL, $WS_VSCROLL))
	GUICtrlSetData(-1, $sTxtNames, GetTranslatedFileIni("MBR Global GUI Design", "Any", "Any"))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "CmbLaboratory_Info_01", "Select the troop type to upgrade with this pull down menu") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "CmbLaboratory_Info_02", "The troop icon will appear on the right.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "CmbLaboratory_Info_03", "Any Dark Spell/Troop have priority over Upg Heroes!"))
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetOnEvent(-1, "cmbLab")
	; Red button, will show on upgrade in progress. Temp unhide here and in Func ChkLab() if GUI needs editing.
	$g_hBtnResetLabUpgradeTime = GUICtrlCreateButton("", $x + 120 + 172, $y + 36, 18, 18, BitOR($BS_PUSHLIKE, $BS_DEFPUSHBUTTON))
	GUICtrlSetBkColor(-1, $COLOR_ERROR)
	;_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnRedLight)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "BtnResetLabUpgradeTime_Info_01", "Visible Red button means that laboratory upgrade in process") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "BtnResetLabUpgradeTime_Info_02", "This will automatically disappear when near time for upgrade to be completed.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "BtnResetLabUpgradeTime_Info_03", "If upgrade has been manually finished with gems before normal end time,") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "BtnResetLabUpgradeTime_Info_04", "Click red button to reset internal upgrade timer BEFORE STARTING NEW UPGRADE") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "BtnResetLabUpgradeTime_Info_05", "Caution - Unnecessary timer reset will force constant checks for lab status"))
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetState(-1, $GUI_HIDE)         ; comment this line out to edit GUI
	GUICtrlSetOnEvent(-1, "ResetLabUpgradeTime")
	$g_hPicLabUpgrade = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBlank, $x + 330, $y, 64, 64)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 110
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "Group_02", "Star Laboratory"), $x - 20, $y - 20, $g_iSizeWGrpTab3, 100)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnStarLaboratory, $x, $y, 64, 64)
	$g_hChkAutoStarLabUpgrades = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "ChkAutoStarLabUpgrades", "Auto Star Laboratory Upgrades"), $x + 80, $y + 5, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "ChkAutoStarLabUpgrades_Info_01", "Check box to enable automatically starting Upgrades in star laboratory"))
	GUICtrlSetOnEvent(-1, "chkStarLab")
	$g_hLblNextSLUpgrade = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "LblNextUpgrade", "Next one") & ":", $x + 80, $y + 38, 50, -1)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$g_hCmbStarLaboratory = GUICtrlCreateCombo("", $x + 135, $y + 35, 140, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL, $WS_VSCROLL))
	GUICtrlSetData(-1, $sTxtSLNames, GetTranslatedFileIni("MBR Global GUI Design", "Any", "Any"))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "CmbLaboratory_Info_01", "Select the troop type to upgrade with this pull down menu") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "CmbLaboratory_Info_02", "The troop icon will appear on the right."))
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetOnEvent(-1, "cmbStarLab")
	; Red button, will show on upgrade in progress. Temp unhide here and in Func ChkLab() if GUI needs editing.
	$g_hBtnResetStarLabUpgradeTime = GUICtrlCreateButton("", $x + 120 + 172, $y + 36, 18, 18, BitOR($BS_PUSHLIKE, $BS_DEFPUSHBUTTON))
	GUICtrlSetBkColor(-1, $COLOR_ERROR)
	;_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnRedLight)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "BtnResetLabUpgradeTime_Info_01", "Visible Red button means that laboratory upgrade in process") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "BtnResetLabUpgradeTime_Info_02", "This will automatically disappear when near time for upgrade to be completed.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "BtnResetLabUpgradeTime_Info_03", "If upgrade has been manually finished with gems before normal end time,") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "BtnResetLabUpgradeTime_Info_04", "Click red button to reset internal upgrade timer BEFORE STARTING NEW UPGRADE") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "BtnResetLabUpgradeTime_Info_05", "Caution - Unnecessary timer reset will force constant checks for lab status"))
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetState(-1, $GUI_HIDE)         ; comment this line out to edit GUI
	GUICtrlSetOnEvent(-1, "ResetStarLabUpgradeTime")
	$g_hPicStarLabUpgrade = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBlank, $x + 330, $y, 64, 64)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateLaboratorySubTab

Func CreateHeroesSubTab()
	Local $sTxtTip = ""
	Local $x = 25, $y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "Group_01", "Upgrade Heroes Continuously"), $x - 20, $y - 20, $g_iSizeWGrpTab3 - 4, $g_iSizeHGrpTab3)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "LblAutoUpgrading_01", "Auto upgrading of your Heroes"), $x - 10, $y, -1, -1)

	$y += 20
	$g_hChkUpgradeKing = GUICtrlCreateCheckbox("", $x, $y + 25, 17, 17)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeKing_Info_01", "Enable upgrading of your King when you have enough Dark Elixir (Saving Min. Dark Elixir)") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeKing_Info_02", "You can manually locate your Kings Altar on Misc Tab") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeHeroes_Info_01", "Verify your Resume Bot Dark Elixir value at Misc Tab vs Saving Min. Dark Elixir here!") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeKing_Info_04", "Enabled with TownHall 7 and higher")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradeKing")
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnKingUpgr, $x + 18, $y, 64, 64)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hPicChkKingSleepWait = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSleepingKing, $x + 18, $y, 64, 64)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_HIDE)

	$x += 95
	$g_hChkUpgradeQueen = GUICtrlCreateCheckbox("", $x, $y + 25, 17, 17)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeQueen_Info_01", "Enable upgrading of your Queen when you have enough Dark Elixir (Saving Min. Dark Elixir)") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeQueen_Info_02", "You can manually locate your Queens Altar on Misc Tab") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeHeroes_Info_01", -1) & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeQueen_Info_03", "Enabled with TownHall 9 and higher")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradeQueen")
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnQueenUpgr, $x + 18, $y, 64, 64)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hPicChkQueenSleepWait = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSleepingQueen, $x + 18, $y, 64, 64)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_HIDE)

	$x += 95
	$g_hChkUpgradeWarden = GUICtrlCreateCheckbox("", $x, $y + 25, 17, 17)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeWarden_Info_01", "Enable upgrading of your Warden when you have enough Elixir (Saving Min. Elixir)") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeWarden_Info_02", "You can manually locate your Wardens Altar on Misc Tab") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeHeroes_Info_01", -1) & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeWarden_Info_03", "Enabled with TownHall 11")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradeWarden")
	GUICtrlSetColor(-1, $COLOR_ERROR)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnWardenUpgr, $x + 18, $y, 64, 64)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hPicChkWardenSleepWait = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSleepingWarden, $x + 18, $y, 64, 64)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_HIDE)

	$x += 95
	$g_hChkUpgradeChampion = GUICtrlCreateCheckbox("", $x, $y + 25, 17, 17)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeChampion_Info_01", "Enable upgrading of your Royal Champion when you have enough Dark Elixir (Saving Min. Dark Elixir)") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeChampion_Info_02", "You can manually locate your Royal Champion Altar on Misc Tab") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeHeroes_Info_01", -1) & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeChampion_Info_03", "Enabled with TownHall 13 and higher")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradeChampion")
	GUICtrlSetColor(-1, $COLOR_ERROR)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnChampionUpgr, $x + 18, $y, 64, 64)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hPicChkChampionSleepWait = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSleepingChampion, $x + 18, $y, 64, 64)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_HIDE)

	$y += 90
	$x = 25
	$g_hLblHeroReservedBuilderTop = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "LblHeroReservedBuilderTop", "Reserve "), $x, $y + 15, -1, -1)
	$g_hCmbHeroReservedBuilder = GUICtrlCreateCombo("", $x + 50, $y + 11, 30, 21, $CBS_DROPDOWNLIST, $WS_EX_RIGHT)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "CmbHeroReservedBuilder", "At least this many builders have to upgrade heroes, or wait for it."))
	GUICtrlSetData(-1, "|0|1|2|3", "0")
	GUICtrlSetOnEvent(-1, "cmbHeroReservedBuilder")
	$g_hLblHeroReservedBuilderBottom = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "LblHeroReservedBuilderBottom", "builder/s for hero upgrade"), $x, $y + 35, -1, -1)

	$g_hBtnHeroEquipment = GUICtrlCreateButton("Hero Equipment", $x + 250, $y + 11, -1, -1)
	GUICtrlSetOnEvent(-1, "BtnHeroEquipment")

	; Pets
	Local $x = 25, $y = 230
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Pets", "LblAutoUpgrading_02", "Auto upgrading of your Pets"), $x - 10, $y, -1, -1)
	$x += 20
	$y += 15
	$g_hChkUpgradePets[$ePetLassi] = GUICtrlCreateCheckbox("", $x, $y + 25, 17, 17)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeLassi_Info_01", "Enable upgrading of your Pet, Lassi, when you have enough Dark Elixir")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradePets")
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnPetLassi, $x + 23, $y + 5, 48, 48)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 95
	$g_hChkUpgradePets[$ePetElectroOwl] = GUICtrlCreateCheckbox("", $x, $y + 25, 17, 17)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeElectroOwl_Info_01", "Enable upgrading of your Pet, Electro Owl, when you have enough Dark Elixir")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradePets")
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnPetElectroOwl, $x + 23, $y + 5, 64, 64)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 95
	$g_hChkUpgradePets[$ePetMightyYak] = GUICtrlCreateCheckbox("", $x, $y + 25, 17, 17)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeMightyYak_Info_01", "Enable upgrading of your Pet, Mighty Yak, when you have enough Dark Elixir")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradePets")
	GUICtrlSetColor(-1, $COLOR_ERROR)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnPetMightyYak, $x + 23, $y - 1, 60, 60)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 95
	$g_hChkUpgradePets[$ePetUnicorn] = GUICtrlCreateCheckbox("", $x, $y + 25, 17, 17)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeUnicorn_Info_01", "Enable upgrading of your Pet, Unicorn, when you have enough Dark Elixir")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradePets")
	GUICtrlSetColor(-1, $COLOR_ERROR)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnPetUnicorn, $x + 23, $y - 4, 64, 64)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x = 25
	$y += 65
	$g_hChkUpgradePets[$ePetFrosty] = GUICtrlCreateCheckbox("", $x, $y + 25, 17, 17)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeFrosty_Info_01", "Enable upgrading of your Pet, Frosty, when you have enough Dark Elixir")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradePets")
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnPetFrosty, $x + 18, $y, 64, 64)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
	$g_hChkUpgradePets[$ePetDiggy] = GUICtrlCreateCheckbox("", $x, $y + 25, 17, 17)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeDiggy_Info_01", "Enable upgrading of your Pet, Diggy, when you have enough Dark Elixir")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradePets")
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnPetDiggy, $x + 18, $y + 2, 64, 64)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
	$g_hChkUpgradePets[$ePetPoisonLizard] = GUICtrlCreateCheckbox("", $x + 5, $y + 25, 17, 17)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradePoisonLizard_Info_01", "Enable upgrading of your Pet, Poison Lizard, when you have enough Dark Elixir")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradePets")
	GUICtrlSetColor(-1, $COLOR_ERROR)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnPetPoisonLizard, $x + 18, $y, 64, 64)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
	$g_hChkUpgradePets[$ePetPhoenix] = GUICtrlCreateCheckbox("", $x, $y + 25, 17, 17)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradePhoenix_Info_01", "Enable upgrading of your Pet, Phoenix, when you have enough Dark Elixir")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradePets")
	GUICtrlSetColor(-1, $COLOR_ERROR)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnPetPhoenix, $x + 13, $y, 64, 64)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 80
	$g_hChkUpgradePets[$ePetSpiritFox] = GUICtrlCreateCheckbox("", $x, $y + 25, 17, 17)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeSpiritFox_Info_01", "Enable upgrading of your Pet, Spirit Fox, when you have enough Dark Elixir")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradePets")
	GUICtrlSetColor(-1, $COLOR_ERROR)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSpiritFox, $x + 8, $y, 64, 64)
	_GUICtrlSetTip(-1, $sTxtTip)

	;--------------------------------------------------
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateHeroesSubTab

Func CreateHeroEquipment()
	Local $x = 25, $y = 5
	$g_hGUI_HeroEquipment = _GUICreate("Hero Equipment", $_GUI_MAIN_WIDTH  + 50, $_GUI_MAIN_HEIGHT - 67, $g_iFrmBotPosX - 25, $g_iFrmBotPosY + 40, $WS_DLGFRAME, -1, $g_hFrmBot)

	GUICtrlCreateIcon($g_sLibIconPath, $eIcnBlacksmith, $x + 15, $y + 15, 48, 48)
	$g_hChkCustomEquipmentOrderEnable = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Equipment", "ChkCustomEquipmentEnable", "Auto Equipment Upgrades"), $x + 75, $y + 30, -1, -1)
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Equipment", "ChkCustomEquipmentEnable_Info_01", "Enable to select a custom equipment upgrade order"))
	GUICtrlSetOnEvent(-1, "chkEquipmentOrder")

	Local $sComboData = ""
	For $t = 0 To UBound($g_asEquipmentOrderList) - 1
		$sComboData &= $g_asEquipmentOrderList[$t][0] & "|"
	Next

	Local $txtEquipmentOrder = GetTranslatedFileIni("MBR GUI Design Child Attack - Equipment", "TxtEquipmentOrder", "Select Equipment To Upgrade In Position ")

	; Create ComboBox(es) for selection of troop training order
	$x += 40
	$y = 90
	Local $2DigitsOffset = 3
	For $z = 0 To UBound($g_ahCmbEquipmentOrder) - 1
		If $z < 9 Then
			$g_EquipmentOrderLabel[$z] = GUICtrlCreateLabel($z + 1 & ":", $x - 36, $y + 3, -1, 25)
			$g_hChkCustomEquipmentOrder[$z] = GUICtrlCreateCheckbox("", $x - 20, $y - 2, -1, 25)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Equipment", "ChkCustomEquipmentOrder_Info_01", "Enable or disable a custom equipment upgrade"))
			$g_ahCmbEquipmentOrder[$z] = GUICtrlCreateCombo("", $x, $y, 120, 25, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
			GUICtrlSetOnEvent(-1, "GUIRoyalEquipmentOrder")
			GUICtrlSetData(-1, $sComboData, "")
			_GUICtrlSetTip(-1, $txtEquipmentOrder & $z + 1)
			$g_ahImgEquipmentOrder[$z] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnOptions, $x + 123, $y - 2, 24, 24)
			$g_ahImgEquipmentOrder2[$z] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnOptions, $x + 155, $y - 2, 24, 24)
			$y += 40 ; move down to next combobox location
		ElseIf $z = 9 Then
			If $z = 9 Then
				$x += 250
				$y = 90
			EndIf
			$g_EquipmentOrderLabel[$z] = GUICtrlCreateLabel($z + 1 & ":", $x - 36, $y + 3, -1, 25)
			$g_hChkCustomEquipmentOrder[$z] = GUICtrlCreateCheckbox("", $x - 20, $y - 2, -1, 25)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Equipment", "ChkCustomEquipmentOrder_Info_01", "Enable or disable a custom equipment upgrade"))
			$g_ahCmbEquipmentOrder[$z] = GUICtrlCreateCombo("", $x, $y, 120, 25, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
			GUICtrlSetOnEvent(-1, "GUIRoyalEquipmentOrder")
			GUICtrlSetData(-1, $sComboData, "")
			_GUICtrlSetTip(-1, $txtEquipmentOrder & $z + 1)
			$g_ahImgEquipmentOrder[$z] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnOptions, $x + 123, $y - 2, 24, 24)
			$g_ahImgEquipmentOrder2[$z] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnOptions, $x + 155, $y - 2, 24, 24)
			$y += 40 ; move down to next combobox location
		ElseIf $z > 9 Then
			If $z = 9 Then
				$x += 250
			EndIf
			$g_EquipmentOrderLabel[$z] = GUICtrlCreateLabel($z + 1 & ":", $x - 40, $y + 3, -1, 25)
			$g_hChkCustomEquipmentOrder[$z] = GUICtrlCreateCheckbox("", $x - 20, $y - 2, -1, 25)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Equipment", "ChkCustomEquipmentOrder_Info_01", "Enable or disable a custom equipment upgrade"))
			$g_ahCmbEquipmentOrder[$z] = GUICtrlCreateCombo("", $x, $y, 120, 25, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
			GUICtrlSetOnEvent(-1, "GUIRoyalEquipmentOrder")
			GUICtrlSetData(-1, $sComboData, "")
			_GUICtrlSetTip(-1, $txtEquipmentOrder & $z + 1)
			$g_ahImgEquipmentOrder[$z] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnOptions, $x + 123, $y - 2, 24, 24)
			$g_ahImgEquipmentOrder2[$z] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnOptions, $x + 155, $y - 2, 24, 24)
			$y += 40 ; move down to next combobox location
		EndIf
	Next

	$x = 125
	$y = 465
	$g_hBtnRegularOrder = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Equipment", "BtnRegularOrder", "Sort in Original Order"), $x + 70, $y, 130, 20)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Equipment", "BtnRegularOrder_Info_01", "Push button to sort equipment in original order"))
	GUICtrlSetOnEvent(-1, "btnRegularOrder")

	$x = 125
	$y = 510
	$g_hBtnRemoveEquipment = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Equipment", "BtnRemoveEquipment", "Empty Equipment List"), $x - 6, $y, 130, 20)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Equipment", "BtnRemoveEquipment_Info_01", "Push button to remove all equipment from list and start over"))
	GUICtrlSetOnEvent(-1, "btnRemoveEquipment")

	$x += 165
	$g_hBtnEquipmentOrderSet = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Equipment", "BtnEquipmentOrderSet", "Apply New Order"), $x - 6, $y, 96, 20)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Equipment", "BtnEquipmentOrderSet_Info_01", "Push button when finished selecting custom equipment upgrading order") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Equipment", "BtnEquipmentOrderSet_Info_02", "Icon changes color based on status: Red= Not Set, Green = Order Set") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Equipment", "BtnEquipmentOrderSet_Info_03", "When not all equipment slots are filled, will use random equipment order in empty slots!"))
	GUICtrlSetOnEvent(-1, "btnEquipmentOrderSet")
	$g_ahImgEquipmentOrderSet = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSilverStar, $x + 119, $y, 18, 18)

	$y = 550
	$g_hBtnHeroEquipmentClose = GUICtrlCreateButton("Close", 410, $y, 85, 25)
	GUICtrlSetOnEvent(-1, "CloseHeroEquipment")
EndFunc   ;==>CreateHeroEquipment

Func CreateBuildingsSubTab()
	Local $sTxtShowType = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "TxtShowType", "This shows type of upgrade, click to show location")
	Local $sTxtStatus = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "TxtStatus", "Status: Red=not programmed, Yellow=programmed, not completed, Green=Completed")
	Local $sTxtShowName = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "TxtShowName", "This box is updated with unit name after upgrades are checked")
	Local $sTxtShowLevel = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "TxtShowLevel", "This unit box is updated with unit level after upgrades are checked")
	Local $sTxtShowCost = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "TxtShowCost", "This upgrade cost box is updated after upgrades are checked")
	Local $sTxtShowTime = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "TxtShowTime", "This box is updated with time length of upgrade after upgrades are checked")
	Local $sTxtChkRepeat = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "TxtChkRepeat", "Check box to Enable Upgrade to repeat continuously")
	Local $sTxtShowEndTime = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "TxtShowEndTime", "This box is updated with estimate end time of upgrade after upgrades are checked")
	Local $sTxtCheckBox = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "TxtCheckBox", "Check box to Enable Upgrade")
	Local $sTxtAfterUsing = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "TxtAfterUsing", "after using Locate Upgrades button")

	Local $x = 25, $y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "Group_01", "Buildings or Heroes"), $x - 20, $y - 20, $g_iSizeWGrpTab3, 30 + ($g_iUpgradeSlots * 22))
	$x -= 7
	; table header
	$y -= 7
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "Table header_01", "Unit Name"), $x + 71, $y, 70, 18)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "Table header_02", "Lvl"), $x + 153, $y, 40, 18)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "Table header_03", "Type"), $x + 173, $y, 50, 18)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "Table header_04", "Cost"), $x + 219, $y, 50, 18)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "Table header_05", "Time"), $x + 270, $y, 50, 18)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "Table header_06", "Rep."), $x + 392, $y, 50, 18)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "Table header_07", "Estimated End"), $x + 315, $y, 75, 18)
	$y += 13

	; Create upgrade GUI slots 0 to $g_iUpgradeSlots
	; Can add more slots with $g_iUpgradeSlots value in Global variables file, 6 is minimum and max limit is 15 before GUI is too long.
	For $i = 0 To $g_iUpgradeSlots - 1
		$g_hPicUpgradeStatus[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnRedLight, $x - 10, $y + 1, 14, 14)
		_GUICtrlSetTip(-1, $sTxtStatus)
		$g_hChkUpgrade[$i] = GUICtrlCreateCheckbox($i + 1 & ":", $x + 5, $y + 1, 34, 15)
		_GUICtrlSetTip(-1, $sTxtCheckBox & " #" & $i + 1 & " " & $sTxtAfterUsing)
		;			GUICtrlSetFont(-1, 8)
		GUICtrlSetOnEvent(-1, "btnchkbxUpgrade")
		$g_hTxtUpgradeName[$i] = GUICtrlCreateInput("", $x + 40, $y, 107, 17, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		;			GUICtrlSetFont(-1, 8)
		_GUICtrlSetTip(-1, $sTxtShowName)
		$g_hTxtUpgradeLevel[$i] = GUICtrlCreateInput("", $x + 150, $y, 23, 17, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		;			GUICtrlSetFont(-1, 8)
		_GUICtrlSetTip(-1, $sTxtShowLevel)
		$g_hPicUpgradeType[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBlank, $x + 178, $y + 1, 15, 15)
		_GUICtrlSetTip(-1, $sTxtShowType)
		GUICtrlSetOnEvent(-1, "picUpgradeTypeLocation")
		$g_hTxtUpgradeValue[$i] = GUICtrlCreateInput("", $x + 197, $y, 65, 17, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		;			GUICtrlSetFont(-1, 8)
		_GUICtrlSetTip(-1, $sTxtShowCost)
		;HArchH was 35 wide.
		$g_hTxtUpgradeTime[$i] = GUICtrlCreateInput("", $x + 266, $y, 45, 17, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		;			GUICtrlSetFont(-1, 8)
		_GUICtrlSetTip(-1, $sTxtShowTime)
		;HArchH was 305 start and 85 wide
		$g_hTxtUpgradeEndTime[$i] = GUICtrlCreateInput("", $x + 315, $y, 75, 17, BitOR($ES_LEFT, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		GUICtrlSetFont(-1, 7)
		_GUICtrlSetTip(-1, $sTxtShowEndTime)
		$g_hChkUpgradeRepeat[$i] = GUICtrlCreateCheckbox("", $x + 395, $y + 1, 15, 15)
		;			GUICtrlSetFont(-1, 8)
		_GUICtrlSetTip(-1, $sTxtChkRepeat)
		GUICtrlSetOnEvent(-1, "btnchkbxRepeat")

		$y += 22
	Next
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x += 5
	$y += 8
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x - 15, $y, 15, 15)
	GUICtrlCreateLabel( GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "LblUpgrMinGold", "Min. Gold") & ":", $x + 5, $y + 3, -1, -1)
	$g_hTxtUpgrMinGold = GUICtrlCreateInput("150000", $x + 55, $y, 61, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "TxtUpgrMinGold_Info_01", "Save this much Gold after the upgrade completes.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "TxtUpgrMinGold_Info_02", "Set this value as needed to save for searching, or wall upgrades."))
	GUICtrlSetLimit(-1, 8)
	$y += 18
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x - 15, $y, 15, 15)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "LblUpgrMinElixir", "Min. Elixir") & ":", $x + 5, $y + 3, -1, -1)
	$g_hTxtUpgrMinElixir = GUICtrlCreateInput("1000", $x + 55, $y, 61, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "TxtUpgrMinElixir_Info_01", "Save this much Elixir after the upgrade completes") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "TxtUpgrMinElixir_Info_02", "Set this value as needed to save for making troops or wall upgrades."))
	GUICtrlSetLimit(-1, 8)
	$x -= 15
	$y -= 8
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 140, $y, 15, 15)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "LblUpgrMinDark", "Min. Dark") & ":", $x + 160, $y + 3, -1, -1)
	$g_hTxtUpgrMinDark = GUICtrlCreateInput("1000", $x + 210, $y, 61, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "TxtUpgrMinDark_Info_01", "Save this amount of Dark Elixir after the upgrade completes.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "TxtUpgrMinDark_Info_02", "Set this value higher if you want make war troops."))
	GUICtrlSetLimit(-1, 6)
	$y -= 8

	; Locate/reset buttons
	GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "BtnLocateUpgrades", "Locate Upgrades"), $x + 290, $y - 4, 120, 18, BitOR($BS_MULTILINE, $BS_VCENTER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "BtnLocateUpgrades_Info_01", "Push button to locate and record information on building/Hero upgrades") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "BtnLocateUpgrades_Info_02", "Any upgrades with repeat enabled are skipped and can not be located again"))
	GUICtrlSetOnEvent(-1, "btnLocateUpgrades")
	GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "BtnResetUpgrades", "Reset Upgrades"), $x + 290, $y + 16, 120, 18, BitOR($BS_MULTILINE, $BS_VCENTER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "BtnResetUpgrades_Info_01", "Push button to reset & remove upgrade information") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "BtnResetUpgrades_Info_02", "If repeat box is checked, data will not be reset"))
	GUICtrlSetOnEvent(-1, "btnResetUpgrade")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateBuildingsSubTab

Func CreateWallsSubTab()
	Local $x = 25, $y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "Group_01", "Walls"), $x - 20, $y - 20, $g_iSizeWGrpTab3, 120)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnWall, $x - 12, $y - 6, 24, 24)
	$g_hChkWalls = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "ChkWalls", "Auto Wall Upgrade"), $x + 18, $y - 2, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "ChkWalls_Info_01", "Check this to upgrade Walls if there are enough resources."))
	GUICtrlSetState(-1, $GUI_ENABLE)
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	GUICtrlSetOnEvent(-1, "chkWalls")
	#CS		$sldMaxNbWall = GUICtrlCreateSlider( $x + 135, $y, 85 , 24, BITOR($TBS_TOOLTIPS, $TBS_AUTOTICKS))
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "ChkWalls_Info_02", "No. of Positions to test and find walls. Higher is better but slower."))
				_GUICtrlSlider_SetTipSide(-1, $TBTS_BOTTOM)
				_GUICtrlSlider_SetTicFreq(-1, 1)
				GUICtrlSetLimit(-1, 8, 1)
				GUICtrlSetData(-1, 4)
				GUICtrlSetBkColor(-1, $COLOR_WHITE)
	#CE		$sldMaxNbWall = GUICtrlCreateSlider( $x + 135, $y, 85 , 24, BITOR($TBS_TOOLTIPS, $TBS_AUTOTICKS))
	$g_hBtnFindWalls = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "BtnFindWalls", "TEST"), $x + 150, $y + 26, 45, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "BtnFindWalls_Info_01", "Click here to test the Wall Detection."))
	GUICtrlSetOnEvent(-1, "btnWalls")
	If $g_bBtnColor Then GUICtrlSetBkColor(-1, 0x5CAD85)
	$g_hRdoUseGold = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "RdoUseGold", "Use Gold"), $x + 25, $y + 16, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "RdoUseGold_Info_01", "Use only Gold for Walls.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "RdoUseGold_Info_02", "Available at all Wall levels."))
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$g_hRdoUseElixir = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "RdoUseElixir", "Use Elixir"), $x + 25, $y + 34, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "RdoUseElixir_Info_01", "Use only Elixir for Walls.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "RdoUseElixir_Info_02", "Available only at Wall levels upgradeable with Elixir."))
	GUICtrlSetState(-1, $GUI_DISABLE)
	$g_hRdoUseElixirGold = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "RdoUseElixirGold", "Try Elixir first, Gold second"), $x + 25, $y + 52, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "RdoUseElixirGold_Info_01", "Try to use Elixir first. If not enough Elixir try to use Gold second for Walls.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "RdoUseElixir_Info_02", -1))
	GUICtrlSetState(-1, $GUI_DISABLE)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBuilder, $x - 12, $y + 72, 20, 20)
	$g_hChkSaveWallBldr = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "ChkSaveWallBldr", "Save ONE builder for Walls"), $x + 18, $y + 72, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "ChkSaveWallBldr_Info_01", "Check this to reserve 1 builder exclusively for walls and") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "ChkSaveWallBldr_Info_02", "reduce the available builder by 1 for other upgrades"))
	GUICtrlSetState(-1, $GUI_ENABLE)
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	GUICtrlSetOnEvent(-1, "chkSaveWallBldr")

	$x += 225
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "LblSearchforWalls", "Search for Walls level") & ":", $x, $y + 2, -1, -1)
	$g_hCmbWalls = GUICtrlCreateCombo("", $x + 110, $y, 61, 21, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL), $WS_EX_RIGHT)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "CmbWalls_Info_01", "Search for Walls of this level and try to upgrade them one by one."))
	GUICtrlSetData(-1, "4   |5   |6   |7   |8   |9   |10   |11   |12   |13   |14   |15   |16   ", "4   ")
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetOnEvent(-1, "cmbWalls")
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "LblNextWalllevelcosts", "Next Wall level costs") & ":", $x, $y + 25, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "LblNextWalllevelcosts_Info_01", "Use this value as an indicator.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "LblNextWalllevelcosts_Info_02", "The value will update if you select an other wall level."))
	$g_hLblWallCost = GUICtrlCreateLabel("30 000", $x + 110, $y + 25, 50, -1, $SS_RIGHT)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x, $y + 47, 16, 16)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "LblMin.Goldtosave", "Min. Gold to save"), $x + 20, $y + 47, -1, -1)
	$g_hTxtWallMinGold = GUICtrlCreateInput("150000", $x + 110, $y + 45, 61, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "LblMin.Goldtosave_Info_01", "Save this much Gold after the wall upgrade completes,") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "LblMin.Goldtosave_Info_02", "Set this value to save Gold for other upgrades, or searching."))
	GUICtrlSetLimit(-1, 8)
	GUICtrlSetState(-1, $GUI_DISABLE)

	$y += 2
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x, $y + 67, 16, 16)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "LblMin.Elixirtosave", "Min. Elixir to save"), $x + 20, $y + 70, -1, -1)
	$g_hTxtWallMinElixir = GUICtrlCreateInput("1000", $x + 110, $y + 65, 61, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "LblMin.Elixirtosave_Info_01", "Save this much Elixir after the wall upgrade completes,") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "LblMin.Elixirtosave_Info_02", "Set this value to save Elixir for other upgrades or troop making."))
	GUICtrlSetLimit(-1, 8)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 25, $y = 175
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "Group_02", "Walls counter"), $x - 20, $y - 20, $g_iSizeWGrpTab3, 95 + 40)
	$g_ahWallsCurrentCount[4] = GUICtrlCreateInput("0", $x, $y, 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_01", "Input number of Walls level") & " 4 " & GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_02", "you have."))
	$g_ahPicWallsLevel[4] = _GUICtrlCreateIcon($g_sLibIconPath, $eWall04, $x + 27, $y - 2, 24, 24)
	$x += 80
	$g_ahWallsCurrentCount[5] = GUICtrlCreateInput("0", $x, $y, 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_01", -1) & " 5 " & GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_02", -1))
	$g_ahPicWallsLevel[5] = _GUICtrlCreateIcon($g_sLibIconPath, $eWall05, $x + 27, $y - 2, 24, 24)
	$x += 80
	$g_ahWallsCurrentCount[6] = GUICtrlCreateInput("0", $x, $y, 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_01", -1) & " 6 " & GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_02", -1))
	$g_ahPicWallsLevel[6] = _GUICtrlCreateIcon($g_sLibIconPath, $eWall06, $x + 27, $y - 2, 24, 24)
	$x += 80
	$g_ahWallsCurrentCount[7] = GUICtrlCreateInput("0", $x, $y, 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_01", -1) & " 7 " & GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_02", -1))
	$g_ahPicWallsLevel[7] = _GUICtrlCreateIcon($g_sLibIconPath, $eWall07, $x + 27, $y - 2, 24, 24)
	$x += 80
	$g_ahWallsCurrentCount[8] = GUICtrlCreateInput("0", $x, $y, 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_01", -1) & " 8 " & GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_02", -1))
	$g_ahPicWallsLevel[8] = _GUICtrlCreateIcon($g_sLibIconPath, $eWall08, $x + 27, $y - 2, 24, 24)
	Local $x = 25
	$y += 40
	$g_ahWallsCurrentCount[9] = GUICtrlCreateInput("0", $x, $y, 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_01", -1) & " 9 " & GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_02", -1))
	$g_ahPicWallsLevel[9] = _GUICtrlCreateIcon($g_sLibIconPath, $eWall09, $x + 27, $y - 2, 24, 24)
	$x += 80
	$g_ahWallsCurrentCount[10] = GUICtrlCreateInput("0", $x, $y, 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_01", -1) & " 10 " & GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_02", -1))
	$g_ahPicWallsLevel[10] = _GUICtrlCreateIcon($g_sLibIconPath, $eWall10, $x + 27, $y - 2, 24, 24)
	$x += 80
	$g_ahWallsCurrentCount[11] = GUICtrlCreateInput("0", $x, $y, 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_01", -1) & " 11 " & GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_02", -1))
	$g_ahPicWallsLevel[11] = _GUICtrlCreateIcon($g_sLibIconPath, $eWall11, $x + 27, $y - 2, 24, 24)
	$x += 80
	$g_ahWallsCurrentCount[12] = GUICtrlCreateInput("0", $x, $y, 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_01", -1) & " 12 " & GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_02", -1))
	$g_ahPicWallsLevel[12] = _GUICtrlCreateIcon($g_sLibIconPath, $eWall12, $x + 27, $y - 2, 24, 24)
	$x += 80
	$g_ahWallsCurrentCount[13] = GUICtrlCreateInput("0", $x, $y, 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_01", -1) & " 13 " & GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_02", -1))
	$g_ahPicWallsLevel[13] = _GUICtrlCreateIcon($g_sLibIconPath, $eWall13, $x + 27, $y - 2, 24, 24)
	Local $x = 25
	$y += 40
	$g_ahWallsCurrentCount[14] = GUICtrlCreateInput("0", $x, $y, 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_01", -1) & " 14 " & GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_02", -1))
	$g_ahPicWallsLevel[14] = _GUICtrlCreateIcon($g_sLibIconPath, $eWall14, $x + 27, $y - 2, 24, 24)
	$x += 80
	$g_ahWallsCurrentCount[15] = GUICtrlCreateInput("0", $x, $y, 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_01", -1) & " 15 " & GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_02", -1))
	$g_ahPicWallsLevel[15] = _GUICtrlCreateIcon($g_sLibIconPath, $eWall15, $x + 27, $y - 2, 24, 24)
	$x += 80
	$g_ahWallsCurrentCount[16] = GUICtrlCreateInput("0", $x, $y, 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_01", -1) & " 16 " & GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_02", -1))
	$g_ahPicWallsLevel[16] = _GUICtrlCreateIcon($g_sLibIconPath, $eWall16, $x + 27, $y - 2, 24, 24)
	$x += 80
	$g_ahWallsCurrentCount[17] = GUICtrlCreateInput("0", $x, $y, 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_01", -1) & " 17 " & GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_02", -1))
	$g_ahPicWallsLevel[17] = _GUICtrlCreateIcon($g_sLibIconPath, $eWall17, $x + 26, $y - 5, 28, 28)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateWallsSubTab

Func CreateAutoUpgradeSubTab()

	Local $x = 25, $y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "Group_01", "Auto Upgrade"), $x - 20, $y - 20, $g_iSizeWGrpTab3, 100)

	$g_hChkAutoUpgrade = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "ChkAutoUpgrade", "Enable Auto Upgrade"), $x - 5, $y, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "ChkAutoUpgrade_Info_01", "Check box to enable automatically starting Upgrades from builders menu"))
	GUICtrlSetOnEvent(-1, "chkAutoUpgrade")

	$g_hLblAutoUpgrade = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "Label_01", "Save"), $x, $y + 32, -1, -1)
	$g_hTxtSmartMinGold = GUICtrlCreateInput("150000", $x + 33, $y + 29, 60, 21, BitOR($ES_CENTER, $ES_NUMBER))
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 98, $y + 32, 16, 16)
	$g_hTxtSmartMinElixir = GUICtrlCreateInput("1000", $x + 118, $y + 29, 60, 21, BitOR($ES_CENTER, $ES_NUMBER))
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 183, $y + 32, 16, 16)
	$g_hTxtSmartMinDark = GUICtrlCreateInput("1000", $x + 203, $y + 29, 60, 21, BitOR($ES_CENTER, $ES_NUMBER))
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 268, $y + 32, 16, 16)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "Label_02", "after launching upgrade"), $x + 290, $y + 32, -1, -1)

	$g_hChkResourcesToIgnore[0] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "Ignore_01", "Ignore Gold Upgrades"), $x, $y + 55, -1, -1)
	GUICtrlSetOnEvent(-1, "chkResourcesToIgnore")
	$g_hChkResourcesToIgnore[1] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "Ignore_02", "Ignore Elixir Upgrades"), $x + 130, $y + 55, -1, -1)
	GUICtrlSetOnEvent(-1, "chkResourcesToIgnore")
	$g_hChkResourcesToIgnore[2] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "Ignore_03", "Ignore Dark Elixir Upgrades"), $x + 258, $y + 55, -1, -1)
	GUICtrlSetOnEvent(-1, "chkResourcesToIgnore")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "Group_02", "Upgrades to ignore"), $x - 20, $y + 85, $g_iSizeWGrpTab3, 137)
	Local $x = 21, $y = 100
	Local $iIconSize = 32
	Local $xOff = (40 - $iIconSize) / 2
	Local $yRow1 = 50
	Local $yRow2 = 110
	Local $yChkOff = 32
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTH15, $x + 5, $y + $yRow1, $iIconSize, $iIconSize)
	$g_hChkUpgradesToIgnore[0] = GUICtrlCreateCheckbox("", $x + 20 - $xOff, $y + $yRow1 + $yChkOff, 17, 17)
	_GUICtrlSetTip(-1, "Ignore TownHall Upgrade")
	GUICtrlSetOnEvent(-1, "chkUpgradesToIgnore")

	_GUICtrlCreateIcon($g_sLibIconPath, $eIconTH15Weapon, $x + 50, $y + $yRow1, $iIconSize, $iIconSize)
	$g_hChkUpgradesToIgnore[15] = GUICtrlCreateCheckbox("", $x + 65 - $xOff, $y + $yRow1 + $yChkOff, 17, 17)
	_GUICtrlSetTip(-1, "Ignore TownHall Weapon Upgrade")
	GUICtrlSetOnEvent(-1, "chkUpgradesToIgnore")

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnKing, $x + 110, $y + $yRow1, $iIconSize, $iIconSize)
	$g_hChkUpgradesToIgnore[1] = GUICtrlCreateCheckbox("", $x + 125 - $xOff, $y + $yRow1 + $yChkOff, 17, 17)
	_GUICtrlSetTip(-1, "Ignore Barbarian King Upgrade")
	GUICtrlSetOnEvent(-1, "chkUpgradesToIgnore")

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnQueen, $x + 155, $y + $yRow1, $iIconSize, $iIconSize)
	$g_hChkUpgradesToIgnore[2] = GUICtrlCreateCheckbox("", $x + 170 - $xOff, $y + $yRow1 + $yChkOff, 17, 17)
	_GUICtrlSetTip(-1, "Ignore Archer Queen Upgrade")
	GUICtrlSetOnEvent(-1, "chkUpgradesToIgnore")

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnWarden, $x + 200, $y + $yRow1, $iIconSize, $iIconSize)
	$g_hChkUpgradesToIgnore[3] = GUICtrlCreateCheckbox("", $x + 215 - $xOff, $y + $yRow1 + $yChkOff, 17, 17)
	_GUICtrlSetTip(-1, "Ignore Grand Warden Upgrade")
	GUICtrlSetOnEvent(-1, "chkUpgradesToIgnore")

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnChampion, $x + 245, $y + $yRow1, $iIconSize, $iIconSize)
	$g_hChkUpgradesToIgnore[14] = GUICtrlCreateCheckbox("", $x + 260 - $xOff, $y + $yRow1 + $yChkOff, 17, 17)
	_GUICtrlSetTip(-1, "Ignore Royal Champion Upgrade")
	GUICtrlSetOnEvent(-1, "chkUpgradesToIgnore")

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCC, $x + 305, $y + $yRow1, $iIconSize, $iIconSize)
	$g_hChkUpgradesToIgnore[4] = GUICtrlCreateCheckbox("", $x + 320 - $xOff, $y + $yRow1 + $yChkOff, 17, 17)
	_GUICtrlSetTip(-1, "Ignore Clan Castle Upgrade")
	GUICtrlSetOnEvent(-1, "chkUpgradesToIgnore")

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnLaboratory, $x + 365, $y + $yRow1, $iIconSize, $iIconSize)
	$g_hChkUpgradesToIgnore[5] = GUICtrlCreateCheckbox("", $x + 380 - $xOff, $y + $yRow1 + $yChkOff, 17, 17)
	_GUICtrlSetTip(-1, "Ignore Laboratory Upgrade")
	GUICtrlSetOnEvent(-1, "chkUpgradesToIgnore")

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnWall, $x + 5, $y + $yRow2, $iIconSize, $iIconSize)
	$g_hChkUpgradesToIgnore[6] = GUICtrlCreateCheckbox("", $x + 20 - $xOff, $y + $yRow2 + $yChkOff, 17, 17)
	_GUICtrlSetTip(-1, "Ignore Wall Upgrade")
	GUICtrlSetOnEvent(-1, "chkUpgradesToIgnore")

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBarrack, $x + 65, $y + $yRow2, $iIconSize, $iIconSize)
	$g_hChkUpgradesToIgnore[7] = GUICtrlCreateCheckbox("", $x + 80 - $xOff, $y + $yRow2 + $yChkOff, 17, 17)
	_GUICtrlSetTip(-1, "Ignore Barrack Upgrade")
	GUICtrlSetOnEvent(-1, "chkUpgradesToIgnore")

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDarkBarrack, $x + 110, $y + $yRow2, $iIconSize, $iIconSize)
	$g_hChkUpgradesToIgnore[8] = GUICtrlCreateCheckbox("", $x + 125 - $xOff, $y + $yRow2 + $yChkOff, 17, 17)
	_GUICtrlSetTip(-1, "Ignore Dark Barrack Upgrade")
	GUICtrlSetOnEvent(-1, "chkUpgradesToIgnore")

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSpellFactory, $x + 170, $y + $yRow2, $iIconSize, $iIconSize)
	$g_hChkUpgradesToIgnore[9] = GUICtrlCreateCheckbox("", $x + 185 - $xOff, $y + $yRow2 + $yChkOff, 17, 17)
	_GUICtrlSetTip(-1, "Ignore Spell Factory Upgrade")
	GUICtrlSetOnEvent(-1, "chkUpgradesToIgnore")

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDarkSpellFactory, $x + 215, $y + $yRow2, $iIconSize, $iIconSize)
	$g_hChkUpgradesToIgnore[10] = GUICtrlCreateCheckbox("", $x + 230 - $xOff, $y + $yRow2 + $yChkOff, 17, 17)
	_GUICtrlSetTip(-1, "Ignore Dark Spell Factory Upgrade")
	GUICtrlSetOnEvent(-1, "chkUpgradesToIgnore")

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnMine, $x + 275, $y + $yRow2, $iIconSize, $iIconSize)
	$g_hChkUpgradesToIgnore[11] = GUICtrlCreateCheckbox("", $x + 290 - $xOff, $y + $yRow2 + $yChkOff, 17, 17)
	_GUICtrlSetTip(-1, "Ignore Gold Mine Upgrade")
	GUICtrlSetOnEvent(-1, "chkUpgradesToIgnore")

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 320, $y + $yRow2, $iIconSize, $iIconSize)
	$g_hChkUpgradesToIgnore[12] = GUICtrlCreateCheckbox("", $x + 335 - $xOff, $y + $yRow2 + $yChkOff, 17, 17)
	_GUICtrlSetTip(-1, "Ignore Elixir Collector Upgrade")
	GUICtrlSetOnEvent(-1, "chkUpgradesToIgnore")

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDrill, $x + 365, $y + $yRow2, $iIconSize, $iIconSize)
	$g_hChkUpgradesToIgnore[13] = GUICtrlCreateCheckbox("", $x + 380 - $xOff, $y + $yRow2 + $yChkOff, 17, 17)
	_GUICtrlSetTip(-1, "Ignore Dark Elixir Drill Upgrade")
	GUICtrlSetOnEvent(-1, "chkUpgradesToIgnore")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$g_hTxtAutoUpgradeLog = GUICtrlCreateEdit("", $x - 16, 275, $g_iSizeWGrpTab3, 127, BitOR($GUI_SS_DEFAULT_EDIT, $ES_READONLY))
	GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "TxtAutoUpgradeLog", "------------------------------------------------ AUTO UPGRADE LOG ------------------------------------------------"))

EndFunc   ;==>CreateAutoUpgradeSubTab
