; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Train Army" tab under the "Attack Plan" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GKevinOD (2014)
; Modified ......: DkEd, Hervidero (2015), Boju (11-2016), CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_TRAINARMY = 0
Global $g_hGUI_TRAINARMY_TAB = 0, $g_hGUI_TRAINARMY_TAB_ITEM1 = 0, $g_hGUI_TRAINARMY_TAB_ITEM2 = 0, $g_hGUI_TRAINARMY_TAB_ITEM3 = 0, $g_hGUI_TRAINARMY_TAB_ITEM4 = 0

; TrainArmy childs
Global $g_hGUI_TRAINARMY_ARMY = 0, $g_hGUI_TRAINARMY_BOOST = 0, $g_hGUI_TRAINARMY_TRAINORDER = 0, $g_hGUI_TRAINARMY_OPTIONS = 0
Global $g_hGUI_TRAINARMY_ARMY_TAB = 0, $g_hGUI_TRAINARMY_ARMY_TAB_ITEM1 = 0, $g_hGUI_TRAINARMY_ARMY_TAB_ITEM2 = 0
Global $g_hGUI_TRAINARMY_ORDER_TAB = 0, $g_hGUI_TRAINARMY_ORDER_TAB_ITEM1 = 0, $g_hGUI_TRAINARMY_ORDER_TAB_ITEM2 = 0

; Custom train tab & Quick train tab
Global $g_hGUI_TRAINTYPE = 0
Global $g_hGUI_TRAINTYPE_TAB = 0, $g_hGUI_TRAINTYPE_TAB_ITEM1 = 0, $g_hGUI_TRAINTYPE_TAB_ITEM2 = 0, $g_hGUI_TRAINTYPE_TAB_ITEM3 = 0, $g_hGUI_TRAINTYPE_TAB_ITEM4 = 0
Global $g_hBtnElixirTroops = 0, $g_hBtnDarkElixirTroops = 0, $g_hBtnSuperTroops = 0, $g_hBtnSpells = 0, $g_hBtnSieges = 0

; Troops/Spells sub-tab
Global $g_hRadCustomTrain = 0, $g_hRadQuickTrain = 0, $g_ahChkArmy[3] = [0, 0, 0]
Global $g_ahTxtTrainArmyTroopCount[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_ahTxtTrainArmySpellCount[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_ahTxtTrainArmySiegeCount[$eSiegeMachineCount] = [0, 0, 0, 0, 0, 0, 0]
Global $g_hTxtFullTroop = 0, $g_hChkTotalCampForced = 0, $g_hTxtTotalCampForced = 0
Global $g_hChkDoubleTrain = 0, $g_hChkPreciseArmy = 0

Global $g_hGrpTrainTroops = 0
Global $g_ahPicTrainArmyTroop[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_ahPicTrainArmyTroopTmp[7] = [0, 0, 0, 0, 0, 0, 0]
Global $g_ahLblTrainArmyTroopTmp[7] = [0, 0, 0, 0, 0, 0, 0]
Global $g_ahPicTrainArmySpell[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_ahPicTrainArmySpellTmp[7] = [0, 0, 0, 0, 0, 0, 0]
Global $g_ahLblTrainArmySpellTmp[7] = [0, 0, 0, 0, 0, 0, 0]
Global $g_ahPicTrainArmySiege[$eSiegeMachineCount] = [0, 0, 0, 0, 0, 0]
Global $g_ahPicTrainArmySiegeTmp[3] = [0, 0, 0]
Global $g_ahLblTrainArmySiegeTmp[3] = [0, 0, 0]
Global $g_hLblTotalTimeCamp = 0, $g_hLblElixirCostCamp = 0, $g_hLblDarkCostCamp = 0, $g_hCalTotalTroops = 0, $g_hCalTotalSpells = 0, $g_hLblCountTotalSpells = 0, $g_hLblCountTotal = 0, _
		$g_hTxtTotalCountSpell = 0, $g_hLblTotalTimeSpell = 0, $g_hLblElixirCostSpell = 0, $g_hLblDarkCostSpell = 0

; Quick Train sub-tab
Global $g_aQuickTroopIcon[$eTroopCount] = [$eIcnBarbarian, $eIcnSuperBarbarian, $eIcnArcher, $eIcnSuperArcher, $eIcnGiant, $eIcnSuperGiant, $eIcnGoblin, _
		$eIcnSneakyGoblin, $eIcnWallBreaker, $eIcnSuperWallBreaker, $eIcnBalloon, $eIcnRocketBalloon, $eIcnWizard, $eIcnSuperWizard, $eIcnHealer, $eIcnDragon, _
		$eIcnSuperDragon, $eIcnPekka, $eIcnBabyDragon, $eIcnInfernoDragon, $eIcnMiner, $eIcnSuperMiner, $eIcnElectroDragon, $eIcnYeti, $eIcnDragonRider, _
		$eIcnElectroTitan, $eIcnRootRider, $eIcnMinion, $eIcnSuperMinion, $eIcnHogRider, $eIcnSuperHogRider, $eIcnValkyrie, $eIcnSuperValkyrie, $eIcnGolem, $eIcnWitch, $eIcnSuperWitch, _
		$eIcnLavaHound, $eIcnIceHound, $eIcnBowler, $eIcnSuperBowler, $eIcnIceGolem, $eIcnHeadhunter, $eIcnAppWard]
Global $g_aQuickSpellIcon[$eSpellCount] = [$eIcnLightSpell, $eIcnHealSpell, $eIcnRageSpell, $eIcnJumpSpell, $eIcnFreezeSpell, $eIcnCloneSpell, $eIcnInvisibilitySpell, $eIcnRecallSpell, $eIcnPoisonSpell, _
		$eIcnEarthQuakeSpell, $eIcnHasteSpell, $eIcnSkeletonSpell, $eIcnBatSpell, $eIcnOvergrowthSpell]
Global $g_ahChkUseInGameArmy[3], $g_ahPicTotalQTroop[3], $g_ahPicTotalQSpell[3], $g_ahLblTotalQTroop[3], $g_ahLblTotalQSpell[3]
Global $g_ahBtnEditArmy[3], $g_ahLblEditArmy[3], $g_ahPicQuickTroop[3][22], $g_ahLblQuickTroop[3][22], $g_ahPicQuickSpell[3][11], $g_ahLblQuickSpell[3][11]
Global $g_ahLblQuickTrainNote[3], $g_ahLblUseInGameArmyNote[3]

Global $g_hGUI_QuickTrainEdit = 0, $g_hGrp_QTEdit = 0
Global $g_hBtnRemove_QTEdit, $g_hBtnSave_QTEdit, $g_hBtnCancel_QTEdit
Global $g_ahPicQTEdit_Troop[7], $g_ahTxtQTEdit_Troop[7], $g_ahPicQTEdit_Spell[7], $g_ahTxtQTEdit_Spell[7]
Global $g_ahLblQTEdit_TotalTroop, $g_ahLblQTEdit_TotalSpell
Global $g_ahPicTroop_QTEdit[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_ahPicSpell_QTEdit[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

; Boost sub-tab
Global $g_hCmbBoostBarracks = 0, $g_hCmbBoostSpellFactory = 0, $g_hCmbBoostWorkshop = 0, $g_hCmbBoostBarbarianKing = 0, $g_hCmbBoostArcherQueen = 0, $g_hCmbBoostWarden = 0, $g_hCmbBoostChampion = 0, $g_hCmbBoostEverything = 0
Global $g_hCmbBoostMaxSuperTroops = 0
Global $g_hLblBoosthour = 0, $g_ahLblBoosthoursE = 0
Global $g_hLblBoosthours[12] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hChkBoostBarracksHours[24] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], $g_hChkBoostBarracksHoursE1 = 0, $g_hChkBoostBarracksHoursE2 = 0
Global $g_hChkSuperTroops = 0, $g_hChkSkipBoostSuperTroopOnHalt = 0, $g_hChkUsePotionFirst = 0, $g_ahLblSuperTroops[$iMaxSupersTroop] = [0, 0], $g_ahCmbSuperTroops[$iMaxSupersTroop] = [0, 0], $g_ahPicSuperTroops[$iMaxSupersTroop] = [0, 0]

; Train Order sub-tab
Func LoadTranslatedTrainTroopsOrderList()

	Global $g_asTroopOrderList = ["", _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBarbarians", "Barbarians"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperBarbarians", "Super Barbarians"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtArchers", "Archers"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperArchers", "Super Archers"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtGiants", "Giants"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperGiants", "Super Giants"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtGoblins", "Goblins"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSneakyGoblins", "Sneaky Goblin"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtWallBreakers", "Wall Breakers"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperWallBreakers", "Super Wall Breakers"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBalloons", "Balloons"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtRocketBalloons", "Rocket Balloons"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtWizards", "Wizards"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperWizards", "Super Wizards"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtHealers", "Healers"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtDragons", "Dragons"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtDragons", "Super Dragons"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtPekkas", "Pekkas"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBabyDragons", "Baby Dragons"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtInfernoDragons", "Inferno Dragons"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtMiners", "Miners"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperMiners", "Super Miners"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtElectroDragons", "Electro Dragons"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtYetis", "Yetis"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtDragonRiders", "Dragon Riders"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtElectroTitans", "Electro Titans"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtRootRiders", "Root Riders"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtMinions", "Minions"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperMinions", "Super Minions"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtHogRiders", "Hog Riders"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperHogRiders", "Super Hog Riders"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtValkyries", "Valkyries"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperValkyries", "Super Valkyries"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtGolems", "Golems"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtWitches", "Witches"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperWitches", "Super Witches"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtLavaHounds", "Lava Hounds"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtIceHounds", "Ice Hounds"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBowlers", "Bowlers"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperBowlers", "Super Bowlers"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtIceGolems", "Ice Golems"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtHeadhunters", "Headhunters"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtAppWards", "Apprentice Wardens")]
EndFunc   ;==>LoadTranslatedTrainTroopsOrderList

Global $g_hChkCustomTrainOrderEnable = 0
Global $g_ahCmbTroopOrder[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_ahImgTroopOrder[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hBtnTroopOrderSet = 0, $g_ahImgTroopOrderSet = 0
Global $g_hBtnRemoveTroops

; Spells Brew Order
Func LoadTranslatedBrewSpellsOrderList()

	Global $g_asSpellsOrderList = ["", _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortLightningSpells", "Lightning"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortHealSpells", "Heal"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortRageSpells", "Rage"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortJumpSpells", "Jump"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortFreezeSpells", "Freeze"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortCloneSpells", "Clone"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortInvisibilitySpells", "Invisibility"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtRecallSpells", "Recall"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortPoisonSpells", "Poison"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortEarthquakeSpells", "EarthQuake"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortHasteSpells", "Haste"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortSkeletonSpells", "Skeleton"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortBatSpells", "Bat"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortOvergrowthSpells", "Overgrowth")]
EndFunc   ;==>LoadTranslatedBrewSpellsOrderList

Global $g_hChkCustomBrewOrderEnable = 0
Global $g_ahCmbSpellsOrder[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_ahImgSpellsOrder[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hBtnSpellsOrderSet = 0, $g_ahImgSpellsOrderSet = 0
Global $g_hBtnRemoveSpells


; Options sub-tab
Global $g_hChkCloseWhileTraining = 0, $g_hChkCloseWithoutShield = 0, $g_hChkCloseEmulator = 0, $g_hChkSuspendComputer = 0, $g_hChkRandomClose = 0, $g_hRdoCloseWaitExact = 0, _
		$g_hRdoCloseWaitRandom = 0, $g_hCmbCloseWaitRdmPercent = 0, $g_hCmbMinimumTimeClose = 0, $g_hSldTrainITDelay = 0, $g_hChkTrainAddRandomDelayEnable = 0, $g_hTxtAddRandomDelayMin = 0, _
		$g_hTxtAddRandomDelayMax = 0

Global $g_hLblCloseWaitRdmPercent = 0, $g_hLblCloseWaitingTroops = 0, $g_hLblSymbolWaiting = 0, $g_hLblWaitingInMinutes = 0, $g_hLblTrainITDelay = 0, $g_hLblTrainITDelayTime = 0, _
		$g_hLblAddDelayIdlePhaseBetween = 0, $g_hLblAddDelayIdlePhaseSec = 0, $g_hPicCloseWaitTrain = 0, $g_hPicCloseWaitStop = 0, $g_hPicCloseWaitExact = 0

Func CreateAttackTroops()
	$g_hGUI_TRAINARMY = _GUICreate("", $g_iSizeWGrpTab2, $g_iSizeHGrpTab2, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_ATTACK)
	GUISetBkColor($COLOR_WHITE, $g_hGUI_TRAINARMY)

	;creating subchilds first!
	CreateTrainArmy()
	CreateTrainBoost()
	CreateTrainOrder()
	CreateTrainOptions()

	GUISwitch($g_hGUI_TRAINARMY)
	$g_hGUI_TRAINARMY_TAB = GUICtrlCreateTab(0, 0, $g_iSizeWGrpTab2, $g_iSizeHGrpTab2, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
	$g_hGUI_TRAINTYPE_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_01_STab_01", "Army"))
	$g_hGUI_TRAINTYPE_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_01_STab_02", "Boost"))
	$g_hGUI_TRAINTYPE_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_01_STab_03", "Train Order"))
	$g_hGUI_TRAINTYPE_TAB_ITEM4 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_01_STab_04", "Options"))

	CreateQuickTrainEdit()

	GUICtrlCreateTabItem("")

EndFunc   ;==>CreateAttackTroops

Func CreateTrainArmy()

	$g_hGUI_TRAINARMY_ARMY = _GUICreate("", $g_iSizeWGrpTab3, $g_iSizeHGrpTab3, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_TRAINARMY)
	GUISetBkColor($COLOR_WHITE, $g_hGUI_TRAINARMY_ARMY)

	$g_hRadCustomTrain = GUICtrlCreateRadio("", 75, 35, 13, 13)
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetOnEvent(-1, "radSelectTrainType")
	$g_hRadQuickTrain = GUICtrlCreateRadio("", 165, 35, 13, 13)
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetOnEvent(-1, "radSelectTrainType")

	Local $x = 12
	Local $y = 5

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnResetButton, $x - 12, $y - 2, 24, 24)
	GUICtrlSetOnEvent(-1, "Removecamp")

	$g_hChkTotalCampForced = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "ChkTotalCampForced", "Force Army Camp") & ":", $x + 25, $y, -1, -1)
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlSetOnEvent(-1, "chkTotalCampForced")
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "ChkTotalCampForced_Info_01", "If not detected set army camp values (instead ask)"))
	$g_hTxtTotalCampForced = GUICtrlCreateInput("220", $x + 134, $y + 3, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetOnEvent(-1, "SetComboTroopComp")
	GUICtrlSetLimit(-1, 3)

	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "LblFullTroop", "'Full' Camp") & " " & ChrW(8805), $x + 170, $y + 5, 70, 17, $SS_RIGHT)
	$g_hTxtFullTroop = GUICtrlCreateInput("100", $x + 242, $y + 3, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetOnEvent(-1, "SetComboTroopComp")
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "TxtFullTroop_Info_01", "Army camps are 'Full' when reaching this %, then start attack."))
	GUICtrlSetLimit(-1, 3)
	GUICtrlCreateLabel("%", $x + 273, $y + 5, -1, 17)

	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "SpellCapacity", "Spell Capacity") & ":", $x + 288, $y + 5, 90, 17, $SS_RIGHT)
	$g_hTxtTotalCountSpell = GUICtrlCreateCombo("", $x + 380, $y + 1, 35, 16, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "TxtTotalCountSpell_Info_01", "Enter the No. of Spells Capacity."))
	GUICtrlSetData(-1, "0|2|4|6|7|8|9|10|11", "0")

	$g_hChkPreciseArmy = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "ChkPreciseArmy", "Precise Army"), $x + 220, $y + 26, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Precise ArmyTip", "Always check and remove wrong troops or spells exist in army"))
	GUICtrlSetOnEvent(-1, "ChkPreciseArmy")

	$g_hChkDoubleTrain = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "ChkDoubleTrain", "Double Train"), $x + 310, $y + 26, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "DoubleTrainTip", "Train 2nd set of Troops & Spells after training 1st combo") & @CRLF & _
			GetTranslatedFileIni("MBR Global GUI Design", "DoubleTrainTip1", "Make sure to enter exactly the 'Total Camp',") & @CRLF & _
			GetTranslatedFileIni("MBR Global GUI Design", "DoubleTrainTip2", "'Total Spell' and number of Troops/Spells in your Setting") & @CRLF & _
			GetTranslatedFileIni("MBR Global GUI Design", "DoubleTrainTip3", "Note: Donations + Double Train can produce an unbalanced army!"))

	$g_hGUI_TRAINARMY_ARMY_TAB = GUICtrlCreateTab(0, 30, $g_iSizeWGrpTab3, $g_iSizeHGrpTab3 - 30, BitOR($TCS_FORCELABELLEFT, $TCS_FIXEDWIDTH))
	_GUICtrlTab_SetItemSize($g_hGUI_TRAINARMY_ARMY_TAB, 90, 20)
	CreateCustomTrainSubTab()
	CreateQuickTrainSubTab()

EndFunc   ;==>CreateTrainArmy

Func CreateQuickTrainSubTab()
	$g_hGUI_TRAINARMY_ARMY_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_01_STab_01_STab_02", "Quick Train"))

	Local $x = 12, $y = 50, $del_y = 108

	For $i = 0 To 2
		GUICtrlCreateGroup("", $x - 2, $y, 412, $del_y)
		$g_ahChkArmy[$i] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "ChkArmy", "Army ") & $i + 1, $x + 10, $y + 20, 70, 15)
		If $i = 0 Then GUICtrlSetState(-1, $GUI_CHECKED)
		GUICtrlSetOnEvent(-1, "chkQuickTrainArmy")

		$g_ahChkUseInGameArmy[$i] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "ChkUseInGameArmy", "In-Game Army"), $x + 10, $y + 45, -1, 15)
		GUICtrlSetState(-1, $GUI_CHECKED)
		GUICtrlSetOnEvent(-1, "chkUseInGameArmy")
		GUICtrlSetTip(-1, "Uncheck and create preset army here, MBR will apply this preset to in-game quick train setting")

		$g_ahBtnEditArmy[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrain, $x + 10, $y + 70, 22, 22)
		GUICtrlSetOnEvent(-1, "EditQuickTrainArmy")
		$g_ahLblEditArmy[$i] = GUICtrlCreateLabel(" " & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Btn_Edit_Army", "Edit Army"), $x + 35, $y + 75, 50, 15, $SS_LEFT)

		$g_ahLblTotalQTroop[$i] = GUICtrlCreateLabel(0, $x + 360, $y + 25, 40, 15, $SS_RIGHT)
		GUICtrlSetBkColor(-1, $COLOR_GRAY)
		GUICtrlSetColor(-1, $COLOR_WHITE)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		$g_ahPicTotalQTroop[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnTroopsCost, $x + 353, $y + 20, 24, 24)

		$g_ahLblTotalQSpell[$i] = GUICtrlCreateLabel(0, $x + 360, $y + 70, 40, 15, $SS_RIGHT)
		GUICtrlSetBkColor(-1, $COLOR_GRAY)
		GUICtrlSetColor(-1, $COLOR_WHITE)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		$g_ahPicTotalQSpell[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSpellsCost, $x + 350, $y + 65, 24, 24)

		$g_ahLblQuickTrainNote[$i] = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "LblQuickTrainNote", "Use button 'Edit Army' to create troops and spells in quick Army ") & $i + 1, $x + 120, $y + 30, 200, 70, $SS_CENTER)
		GUICtrlSetFont(-1, 12, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_SKYBLUE)
		$g_ahLblUseInGameArmyNote[$i] = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "LblUseInGameArmyNote", "Quick train using in-game troops and spells preset Army ") & $i + 1, $x + 120, $y + 30, 270, 70, $SS_CENTER)
		GUICtrlSetFont(-1, 12, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_SKYBLUE)

		For $j = 0 To 6
			$g_ahPicQuickTroop[$i][$j] = _GUICtrlCreateIcon($g_sLibIconPath, $eEmpty3, $x + 100 + $j * 36, $y + 10, 32, 32)
			$g_ahLblQuickTroop[$i][$j] = GUICtrlCreateLabel("", $x + 101 + $j * 36, $y + 42, 30, 11, $ES_CENTER)
			$g_ahPicQuickSpell[$i][$j] = _GUICtrlCreateIcon($g_sLibIconPath, $eEmpty3, $x + 100 + $j * 36, $y + 58, 32, 32)
			$g_ahLblQuickSpell[$i][$j] = GUICtrlCreateLabel("", $x + 101 + $j * 36, $y + 90, 30, 11, $ES_CENTER)
		Next

		GUICtrlCreateGroup("", -99, -99, 1, 1)

		For $j = $g_ahLblQuickTrainNote[$i] To $g_ahLblQuickSpell[$i][6]
			GUICtrlSetState($j, $GUI_HIDE)
		Next

		$x = 12
		$y += $del_y
	Next
EndFunc   ;==>CreateQuickTrainSubTab

Func CreateQuickTrainEdit()

	$g_hGUI_QuickTrainEdit = _GUICreate(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "GUI_QuickTrainEdit", "Edit troops and spells for quick train"), 475, 445, -1, -1, $WS_BORDER, $WS_EX_CONTROLPARENT)

	Local $x = 7
	Local $y = 5
	$g_hGrp_QTEdit = GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "GUI_QuickTrainEdit", "Edit troops and spells for quick train"), $x, $y, 454, 405)

	$x = 12
	$y = 20
	GUICtrlCreateGroup("", $x, $y - 3, 444, 130)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnResetButton, $x + 10, $y + 15, 22, 22)
	GUICtrlSetOnEvent(-1, "RemoveArmy_QTEdit")
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Btn_Remove", "Remove"), $x + 35, $y + 20, -1, 15, $SS_LEFT)
	GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Btn_Cancel", "Cancel"), $x + 10, $y + 40, 65, 20, $SS_LEFT)
	GUICtrlSetOnEvent(-1, "ExitQuickTrainEdit")
	GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Btn_Save", "Save"), $x + 10, $y + 65, 65, 20, $SS_LEFT)
	GUICtrlSetOnEvent(-1, "SaveArmy_QTEdit")

	For $i = 0 To 6
		$g_ahPicQTEdit_Troop[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eEmpty3, $x + 100 + $i * 36, $y + 10, 32, 32)
		GUICtrlSetOnEvent(-1, "RemoveTroop_QTEdit")
		GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtQTEdit_Troop[$i] = GUICtrlCreateInput(0, $x + 101 + $i * 36, $y + 45, 30, 15, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		GUICtrlSetOnEvent(-1, "TxtQTEdit_Troop")
		GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicQTEdit_Spell[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eEmpty3, $x + 100 + $i * 36, $y + 65, 32, 32)
		GUICtrlSetOnEvent(-1, "RemoveSpell_QTEdit")
		GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtQTEdit_Spell[$i] = GUICtrlCreateInput(0, $x + 101 + $i * 36, $y + 100, 30, 15, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		GUICtrlSetOnEvent(-1, "TxtQTEdit_Spell")
		GUICtrlSetState(-1, $GUI_HIDE)
	Next

	$g_ahLblQTEdit_TotalTroop = GUICtrlCreateLabel(0, $x + 390, $y + 25, 40, 15, $SS_RIGHT)
	GUICtrlSetBkColor(-1, $COLOR_GRAY)
	GUICtrlSetColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTroopsCost, $x + 380, $y + 20, 24, 24)

	$g_ahLblQTEdit_TotalSpell = GUICtrlCreateLabel(0, $x + 390, $y + 85, 40, 15, $SS_RIGHT)
	GUICtrlSetBkColor(-1, $COLOR_GRAY)
	GUICtrlSetColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSpellsCost, $x + 380, $y + 80, 24, 24)

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	For $i = 0 To $eTroopCount - 1
		If $i <= 12 Then
			$x = 14 + (34 * $i)
			$y = 160
		ElseIf $i > 12 And $i <= 25 Then
			$x = 14 + (34 * ($i - 13))
			$y = 200
		ElseIf $i > 25 And $i <= 38 Then
			$x = 14 + (34 * ($i - 26))
			$y = 240
		Else
			$x = 14 + (34 * ($i - 39))
			$y = 280
		EndIf
		$g_ahPicTroop_QTEdit[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $g_aQuickTroopIcon[$i], $x, $y, 32, 32)
		GUICtrlSetTip(-1, $g_asTroopNames[$i])
		GUICtrlSetOnEvent(-1, "SelectTroop_QTEdit")
	Next

	$x = 14
	$y = 330
	For $i = 0 To $eSpellCount - 1
		If $i <= 12 Then
			If $i > 0 Then $x += 34
		Else
			If $i = 13 Then
				$x = 14
			Else
				$x += 34
			EndIf
			$y = 370
		EndIf
		$g_ahPicSpell_QTEdit[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $g_aQuickSpellIcon[$i], $x, $y, 32, 32)
		GUICtrlSetTip(-1, $g_asSpellNames[$i])
		GUICtrlSetOnEvent(-1, "SelectSpell_QTEdit")
	Next
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateQuickTrainEdit

Func CreateCustomTrainSubTab()

	$g_hGUI_TRAINARMY_ARMY_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_01_STab_01_STab_01", "Custom Train"))

	Local $iStartX = 4, $iStartY = 200
	Local $x = $iStartX, $y = 70
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "TrainTroops", "Train Troops"), $x, $y - 15, $g_iSizeWGrpTab3 - 150, 85)
	Local $x1 = 39, $xx = 10
	For $i = 0 To UBound($g_ahPicTrainArmyTroopTmp) - 1
		$g_ahPicTrainArmyTroopTmp[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBarbarian, $xx + ($x1 * $i), $y, 38, 38)
		$g_ahLblTrainArmyTroopTmp[$i] = GUICtrlCreateLabel("0", $xx + ($x1 * $i) + 1, $y + 37, 40, 12, $SS_CENTER)
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		GUICtrlSetColor(-1, $COLOR_BLUE)
		GUICtrlSetFont(-1, 9, 900)
	Next
	$g_hCalTotalTroops = GUICtrlCreateProgress($x + 5, $y + 53, 235, 10)
	$g_hLblCountTotal = GUICtrlCreateLabel(0, $x + 245, $y + 51, 35, 15, $SS_CENTER)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "TrainSieges", "Train Sieges"), $g_iSizeWGrpTab3 - 140, $y - 15, 130, 75)
	Local $x1 = 39, $xx = $g_iSizeWGrpTab3 - 133
	For $i = 0 To UBound($g_ahPicTrainArmySiegeTmp) - 1
		$g_ahPicTrainArmySiegeTmp[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnWallW, $xx + ($x1 * $i), $y, 38, 38)
		$g_ahLblTrainArmySiegeTmp[$i] = GUICtrlCreateLabel("0", $xx + ($x1 * $i) + 1, $y + 37, 40, 12, $SS_CENTER)
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		GUICtrlSetColor(-1, $COLOR_BLUE)
		GUICtrlSetFont(-1, 9, 900)
	Next
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 88
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "TrainSpells", "Train Spells"), $x, $y - 15, $g_iSizeWGrpTab3 - 150, 85)
	Local $x1 = 39, $xx = 10
	For $i = 0 To UBound($g_ahPicTrainArmySpellTmp) - 1
		$g_ahPicTrainArmySpellTmp[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnPoisonSpell, $xx + ($x1 * $i), $y, 38, 38)
		$g_ahLblTrainArmySpellTmp[$i] = GUICtrlCreateLabel("0", $xx + ($x1 * $i) + 1, $y + 37, 40, 12, $SS_CENTER)
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		GUICtrlSetColor(-1, $COLOR_BLUE)
		GUICtrlSetFont(-1, 9, 900)
	Next

	$g_hCalTotalSpells = GUICtrlCreateProgress($x + 5, $y + 53, 235, 10)
	$g_hLblCountTotalSpells = GUICtrlCreateLabel(0, $x + 245, $y + 51, 35, 15, $SS_CENTER)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTroopsCost, $g_iSizeWGrpTab3 - 125, $y - 1, 24, 24)
	$g_hLblTotalTimeCamp = GUICtrlCreateLabel(" 0s", $g_iSizeWGrpTab3 - 99, $y + 4, 70, 15, $SS_RIGHT)
	GUICtrlSetBkColor(-1, $COLOR_GRAY)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_WHITE)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSpellsCost, $g_iSizeWGrpTab3 - 125, $y + 24, 24, 24)
	$g_hLblTotalTimeSpell = GUICtrlCreateLabel(" 0s", $g_iSizeWGrpTab3 - 99, $y + 29, 70, 15, $SS_RIGHT)
	GUICtrlSetBkColor(-1, $COLOR_GRAY)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_WHITE)

	$x = $iStartX + 10
	$y = $iStartY + 33
	$g_hBtnElixirTroops = GUICtrlCreateButton("Elixir Troops", $x, $y, 100, 21)
	GUICtrlSetOnEvent(-1, "BtnElixirTroops")
	$g_hBtnDarkElixirTroops = GUICtrlCreateButton("Dark Troops", $x + 100, $y, 90, 21)
	GUICtrlSetOnEvent(-1, "BtnDarkElixirTroops")
	$g_hBtnSuperTroops = GUICtrlCreateButton("Super Troops", $x + 190, $y, 100, 21)
	GUICtrlSetOnEvent(-1, "BtnSuperTroops")
	$g_hBtnSpells = GUICtrlCreateButton("Spells", $x + 290, $y, 50, 21)
	GUICtrlSetOnEvent(-1, "BtnSpells")
	$g_hBtnSieges = GUICtrlCreateButton("Sieges", $x + 340, $y, 60, 21)
	GUICtrlSetOnEvent(-1, "BtnSieges")

	$iStartY += 60
	Local $xsplit = 42, $ysplit = 60
	$x = $iStartX
	$y = $iStartY
	Local $sTxtSetPerc = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "TxtSetTroop_Info_01", "Enter the No. of")
	Local $sTxtSetPerc2 = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "TxtSetTroop_Info_02", "to make.")

	; Barbarians
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBarbarians", "Barbarians")
	$g_ahPicTrainArmyTroop[$eTroopBarbarian] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBarbarian, $x + 3, $y, 36, 36)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Level", "Level") & " " & $sTroopName & ":" & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Mouse_Left_Click", "Mouse Left Click to Up level" & @CRLF & "Shift + Mouse Left Click to Down level"))
	$g_ahTxtTrainArmyTroopCount[$eTroopBarbarian] = GUICtrlCreateInput("58", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 3)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += $xsplit
	; Archers
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtArchers", "Archers")
	$g_ahPicTrainArmyTroop[$eTroopArcher] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnArcher, $x + 3, $y, 36, 36)

	$g_ahTxtTrainArmyTroopCount[$eTroopArcher] = GUICtrlCreateInput("115", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 3)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += $xsplit
	; Giants
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtGiants", "Giants")
	$g_ahPicTrainArmyTroop[$eTroopGiant] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGiant, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmyTroopCount[$eTroopGiant] = GUICtrlCreateInput("4", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += $xsplit
	;Goblins
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtGoblins", "Goblins")
	$g_ahPicTrainArmyTroop[$eTroopGoblin] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGoblin, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmyTroopCount[$eTroopGoblin] = GUICtrlCreateInput("19", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 3)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += $xsplit
	; WallBreakers
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtWallBreakers", "Wall Breakers")
	$g_ahPicTrainArmyTroop[$eTroopWallBreaker] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnWallBreaker, $x + 3, $y, 36, 36)

	$g_ahTxtTrainArmyTroopCount[$eTroopWallBreaker] = GUICtrlCreateInput("4", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 3)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += $xsplit
	; Balloons
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBalloons", "Balloons")
	$g_ahPicTrainArmyTroop[$eTroopBalloon] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBalloon, $x + 3, $y, 36, 36)

	$g_ahTxtTrainArmyTroopCount[$eTroopBalloon] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += $xsplit
	; Wizards
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtWizards", "Wizards")
	$g_ahPicTrainArmyTroop[$eTroopWizard] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnWizard, $x + 3, $y, 36, 36)

	$g_ahTxtTrainArmyTroopCount[$eTroopWizard] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += $xsplit
	; Healers
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtHealers", "Healers")
	$g_ahPicTrainArmyTroop[$eTroopHealer] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnHealer, $x + 3, $y, 36, 36)

	$g_ahTxtTrainArmyTroopCount[$eTroopHealer] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += $xsplit
	; Dragon
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtDragons", "Dragons")
	$g_ahPicTrainArmyTroop[$eTroopDragon] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDragon, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmyTroopCount[$eTroopDragon] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += $xsplit
	; Pekkas
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtPekkas", "Pekkas")
	$g_ahPicTrainArmyTroop[$eTroopPekka] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnPekka, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmyTroopCount[$eTroopPekka] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	; Next Row
	$x = $iStartX
	$y += $ysplit

	; BDragon
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBabyDragons", "Baby Dragons")
	$g_ahPicTrainArmyTroop[$eTroopBabyDragon] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBabyDragon, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmyTroopCount[$eTroopBabyDragon] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += $xsplit
	; Miners
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtMiners", "Miners")
	$g_ahPicTrainArmyTroop[$eTroopMiner] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnMiner, $x + 3, $y, 36, 36)

	$g_ahTxtTrainArmyTroopCount[$eTroopMiner] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += $xsplit
	; Electro Dragon
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtElectroDragons", "Electro Dragons")
	$g_ahPicTrainArmyTroop[$eTroopElectroDragon] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnElectroDragon, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmyTroopCount[$eTroopElectroDragon] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += $xsplit
	; Yeti
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtYetis", "Yetis")
	$g_ahPicTrainArmyTroop[$eTroopYeti] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnYeti, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmyTroopCount[$eTroopYeti] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += $xsplit
	; Dragon Rider
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtDragonRiders", "Dragon Riders")
	$g_ahPicTrainArmyTroop[$eTroopDragonRider] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDragonRider, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmyTroopCount[$eTroopDragonRider] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += $xsplit
	; Electro Titan
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtElectroTitans", "Electro Titans")
	$g_ahPicTrainArmyTroop[$eTroopElectroTitan] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnElectroTitan, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmyTroopCount[$eTroopElectroTitan] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += $xsplit
	; Root Rider
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtRootRiders", "Root Riders")
	$g_ahPicTrainArmyTroop[$eTroopRootRider] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnRootRider, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmyTroopCount[$eTroopRootRider] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x = $iStartX
	$y = $iStartY
	; Minions
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtMinions", "Minions")
	$g_ahPicTrainArmyTroop[$eTroopMinion] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnMinion, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmyTroopCount[$eTroopMinion] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 3)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += $xsplit
	; Hogs
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtHogRiders", "Hog Riders")
	$g_ahPicTrainArmyTroop[$eTroopHogRider] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnHogRider, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmyTroopCount[$eTroopHogRider] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += $xsplit
	; Valkyries
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtValkyries", "Valkyries")
	$g_ahPicTrainArmyTroop[$eTroopValkyrie] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnValkyrie, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmyTroopCount[$eTroopValkyrie] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += $xsplit
	; Golems
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtGolems", "Golems")
	$g_ahPicTrainArmyTroop[$eTroopGolem] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGolem, $x + 3, $y, 36, 36)

	$g_ahTxtTrainArmyTroopCount[$eTroopGolem] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += $xsplit
	; Witches
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtWitches", "Witches")
	$g_ahPicTrainArmyTroop[$eTroopWitch] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnWitch, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmyTroopCount[$eTroopWitch] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += $xsplit
	; Lavas
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtLavaHounds", "Lava Hounds")
	$g_ahPicTrainArmyTroop[$eTroopLavaHound] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnLavaHound, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmyTroopCount[$eTroopLavaHound] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += $xsplit
	; Bowlers
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBowlers", "Bowlers")
	$g_ahPicTrainArmyTroop[$eTroopBowler] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBowler, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmyTroopCount[$eTroopBowler] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")


	$x += $xsplit
	; IceGolems
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtIceGolems", "IceGolems")
	$g_ahPicTrainArmyTroop[$eTroopIceGolem] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnIceGolem, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmyTroopCount[$eTroopIceGolem] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += $xsplit
	; Headhunters
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtHeadhunters", "Headhunters")
	$g_ahPicTrainArmyTroop[$eTroopHeadhunter] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnHeadhunter, $x + 3, $y, 36, 36)

	$g_ahTxtTrainArmyTroopCount[$eTroopHeadhunter] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += $xsplit
	; Apprentice Warden
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtAppWards", "Apprentice Wardens")
	$g_ahPicTrainArmyTroop[$eTroopAppWard] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnAppWard, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmyTroopCount[$eTroopAppWard] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x = $iStartX
	; Super Barbarians
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperBarbarians", "Super Barbarians")
	$g_ahPicTrainArmyTroop[$eTroopSuperBarbarian] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperBarbarian, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmyTroopCount[$eTroopSuperBarbarian] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 3)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += $xsplit
	; Super Archers
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperArchers", "Super Archers")
	$g_ahPicTrainArmyTroop[$eTroopSuperArcher] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperArcher, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmyTroopCount[$eTroopSuperArcher] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 3)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += $xsplit
	; SneakyGoblins
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSneakyGoblins", "Sneaky Goblins")
	$g_ahPicTrainArmyTroop[$eTroopSneakyGoblin] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSneakyGoblin, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmyTroopCount[$eTroopSneakyGoblin] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 3)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += $xsplit
	; Super WallBreakers
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperWallBreakers", "Super Wall Breakers")
	$g_ahPicTrainArmyTroop[$eTroopSuperWallBreaker] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperWallBreaker, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmyTroopCount[$eTroopSuperWallBreaker] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 3)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += $xsplit
	; Super Giants
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperGiants", "Super Giants")
	$g_ahPicTrainArmyTroop[$eTroopSuperGiant] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperGiant, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmyTroopCount[$eTroopSuperGiant] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += $xsplit
	; Rocket Balloons
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtRocketBalloons", "Rocket Balloons")
	$g_ahPicTrainArmyTroop[$eTroopRocketBalloon] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnRocketBalloon, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmyTroopCount[$eTroopRocketBalloon] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += $xsplit
	; Super Wizards
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperWizards", "Super Wizards")
	$g_ahPicTrainArmyTroop[$eTroopSuperWizard] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperWizard, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmyTroopCount[$eTroopSuperWizard] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += $xsplit
	; Super Dragon
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperDragon", "Super Dragon")
	$g_ahPicTrainArmyTroop[$eTroopSuperDragon] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperDragon, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmyTroopCount[$eTroopSuperDragon] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += $xsplit
	; Inferno Dragon
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtInfernoDragons", "Inferno Dragons")
	$g_ahPicTrainArmyTroop[$eTroopInfernoDragon] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnInfernoDragon, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmyTroopCount[$eTroopInfernoDragon] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += $xsplit
	; Super Minions
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperMinions", "SuperMinions")
	$g_ahPicTrainArmyTroop[$eTroopSuperMinion] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperMinion, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmyTroopCount[$eTroopSuperMinion] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 3)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x = $iStartX
	$y += $ysplit
	; Super Valkyries
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperValkyries", "Super Valkyries")
	$g_ahPicTrainArmyTroop[$eTroopSuperValkyrie] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperValkyrie, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmyTroopCount[$eTroopSuperValkyrie] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += $xsplit
	; Super Witches
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperWitches", "Super Witches")
	$g_ahPicTrainArmyTroop[$eTroopSuperWitch] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperWitch, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmyTroopCount[$eTroopSuperWitch] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += $xsplit
	; Ice Hound
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtIceHounds", "Ice Hounds")
	$g_ahPicTrainArmyTroop[$eTroopIceHound] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnIceHound, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmyTroopCount[$eTroopIceHound] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += $xsplit
	; Super Bowler
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperBowlers", "Super Bowlers")
	$g_ahPicTrainArmyTroop[$eTroopSuperBowler] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperBowler, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmyTroopCount[$eTroopSuperBowler] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 3)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += $xsplit
	; Super Miners
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperMiner", "Super Miner")
	$g_ahPicTrainArmyTroop[$eTroopSuperMiner] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperMiner, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmyTroopCount[$eTroopSuperMiner] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += $xsplit
	; Super Hog Riders
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSuperHogRider", "Super Hog Rider")
	$g_ahPicTrainArmyTroop[$eTroopSuperHogRider] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperHogRider, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmyTroopCount[$eTroopSuperHogRider] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x = $iStartX
	$y = $iStartY
	; Lightning
	Local $sSpellName = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtLightningSpells", "Lightning Spell")
	$g_ahPicTrainArmySpell[$eSpellLightning] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnLightSpell, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmySpellCount[$eSpellLightning] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sSpellName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainSpellCountEdit")

	$x += $xsplit
	; Healing
	Local $sSpellName = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtHealingSpells", "Healing Spell")
	$g_ahPicTrainArmySpell[$eSpellHeal] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnHealSpell, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmySpellCount[$eSpellHeal] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sSpellName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainSpellCountEdit")

	$x += $xsplit
	; Rage
	Local $sSpellName = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtRageSpells", "Rage Spell")
	$g_ahPicTrainArmySpell[$eSpellRage] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnRageSpell, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmySpellCount[$eSpellRage] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sSpellName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainSpellCountEdit")

	$x += $xsplit
	; Jump
	Local $sSpellName = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtJumpSpells", "Jump Spell")
	$g_ahPicTrainArmySpell[$eSpellJump] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnJumpSpell, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmySpellCount[$eSpellJump] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sSpellName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainSpellCountEdit")

	$x += $xsplit
	; Freeze
	Local $sSpellName = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtFreezeSpells", "Freeze Spell")
	$g_ahPicTrainArmySpell[$eSpellFreeze] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnFreezeSpell, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmySpellCount[$eSpellFreeze] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sSpellName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainSpellCountEdit")

	$x += $xsplit
	; Clone
	Local $sSpellName = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtCloneSpells", "Clone Spell")
	$g_ahPicTrainArmySpell[$eSpellClone] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnCloneSpell, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmySpellCount[$eSpellClone] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sSpellName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainSpellCountEdit")

	$x += $xsplit
	; Invisibility
	Local $sSpellName = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtInvisibilitySpells", "Invisibility Spell")
	$g_ahPicTrainArmySpell[$eSpellInvisibility] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnInvisibilitySpell, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmySpellCount[$eSpellInvisibility] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sSpellName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainSpellCountEdit")

	$x += $xsplit
	; Recall
	Local $sSpellName = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtRecallSpells", "Recall Spell")
	$g_ahPicTrainArmySpell[$eSpellRecall] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnRecallSpell, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmySpellCount[$eSpellRecall] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sSpellName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainSpellCountEdit")

	$x += $xsplit
	; Poison
	Local $sSpellName = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtPoisonSpells", "Poison Spell")
	$g_ahPicTrainArmySpell[$eSpellPoison] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnPoisonSpell, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmySpellCount[$eSpellPoison] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sSpellName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainSpellCountEdit")

	$x += $xsplit
	; EarthQuake
	Local $sSpellName = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtEarthQuakeSpells", "EarthQuake Spell")
	$g_ahPicTrainArmySpell[$eSpellEarthquake] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnEarthquakeSpell, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmySpellCount[$eSpellEarthquake] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sSpellName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainSpellCountEdit")

	$x = $iStartX
	$y += $ysplit
	; Haste
	Local $sSpellName = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtHasteSpells", "Haste Spell")
	$g_ahPicTrainArmySpell[$eSpellHaste] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnHasteSpell, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmySpellCount[$eSpellHaste] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sSpellName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainSpellCountEdit")

	$x += $xsplit
	; Skeleton
	Local $sSpellName = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtSkeletonSpells", "Skeleton Spell")
	$g_ahPicTrainArmySpell[$eSpellSkeleton] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSkeletonSpell, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmySpellCount[$eSpellSkeleton] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sSpellName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainSpellCountEdit")

	$x += $xsplit
	; Bat
	Local $sSpellName = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtBatSpells", "Bat Spell")
	$g_ahPicTrainArmySpell[$eSpellBat] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBatSpell, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmySpellCount[$eSpellBat] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sSpellName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainSpellCountEdit")

	$x += $xsplit
	; Overgrowth
	Local $sSpellName = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtOvergrowthSpells", "Overgrowth Spell")
	$g_ahPicTrainArmySpell[$eSpellOvergrowth] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnOvergrowthSpell, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmySpellCount[$eSpellOvergrowth] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sSpellName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainSpellCountEdit")

	$x = $iStartX
	$y = $iStartY
	; Wall Wrecker
	Local $sSiegeName = GetTranslatedFileIni("MBR Global GUI Design Names Siege Machines", "TxtWallWrecker", "Wall Wrecker")
	$g_ahPicTrainArmySiege[$eSiegeWallWrecker] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnWallW, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmySiegeCount[$eSiegeWallWrecker] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sSiegeName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainSiegeCountEdit")

	$x += $xsplit
	; Battle Blimp
	Local $sSiegeName = GetTranslatedFileIni("MBR Global GUI Design Names Siege Machines", "TxtBattleBlimp", "Battle Blimp")
	$g_ahPicTrainArmySiege[$eSiegeBattleBlimp] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBattleB, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmySiegeCount[$eSiegeBattleBlimp] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sSiegeName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainSiegeCountEdit")

	$x += $xsplit
	; Stone Slammer
	Local $sSiegeName = GetTranslatedFileIni("MBR Global GUI Design Names Siege Machines", "TxtStoneSlammer", "Stone Slammer")
	$g_ahPicTrainArmySiege[$eSiegeStoneSlammer] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnStoneS, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmySiegeCount[$eSiegeStoneSlammer] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sSiegeName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainSiegeCountEdit")

	$x += $xsplit
	; Siege Barracks
	Local $sSiegeName = GetTranslatedFileIni("MBR Global GUI Design Names Siege Machines", "TxtSiegeBarracks", "Siege Barracks")
	$g_ahPicTrainArmySiege[$eSiegeBarracks] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSiegeB, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmySiegeCount[$eSiegeBarracks] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sSiegeName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainSiegeCountEdit")

	$x += $xsplit
	; Log Launcher
	Local $sSiegeName = GetTranslatedFileIni("MBR Global GUI Design Names Siege Machines", "TxtLogLauncher", "Log Launcher")
	$g_ahPicTrainArmySiege[$eSiegeLogLauncher] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnLogL, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmySiegeCount[$eSiegeLogLauncher] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sSiegeName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainSiegeCountEdit")

	$x += $xsplit
	; Flame Finger
	Local $sSiegeName = GetTranslatedFileIni("MBR Global GUI Design Names Siege Machines", "TxtFlameFinger", "Flame Flinger")
	$g_ahPicTrainArmySiege[$eSiegeFlameFlinger] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnFlameF, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmySiegeCount[$eSiegeFlameFlinger] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sSiegeName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainSiegeCountEdit")

	$x += $xsplit
	; Battle Drill
	Local $sSiegeName = GetTranslatedFileIni("MBR Global GUI Design Names Siege Machines", "TxtBattleDrill", "Battle Drill")
	$g_ahPicTrainArmySiege[$eSiegeBattleDrill] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBattleD, $x + 3, $y, 36, 36)
	$g_ahTxtTrainArmySiegeCount[$eSiegeBattleDrill] = GUICtrlCreateInput("0", $x + 1, $y + 39, 40, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sSiegeName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainSiegeCountEdit")

	RemoveAllTmpTrain()
	HideAllTroops()
	BtnElixirTroops()

EndFunc   ;==>CreateCustomTrainSubTab

Func CreateTrainBoost()

	Local $sTxtTip = ""

	$g_hGUI_TRAINARMY_BOOST = _GUICreate("", $g_iSizeWGrpTab3, $g_iSizeHGrpTab3, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_TRAINARMY)
	GUISetBkColor($COLOR_WHITE, $g_hGUI_TRAINARMY_BOOST)

	Local $x = 25, $y = 20
	; Army Buildings
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "Group_01", "Boost Army Buildings"), $x - 20, $y - 20, $g_iSizeWGrpTab3 - 12, 73)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBarrackBoost, $x - 10, $y - 2, 24, 24)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDarkBarrackBoost, $x + 19, $y - 2, 24, 24)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "LblBarracksBoost", "Barracks"), $x + 20 + 29, $y + 4, -1, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "LblBarracksBoost_Info_01", "Use this to boost your Barracks with GEMS! Use with caution!")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hCmbBoostBarracks = GUICtrlCreateCombo("", $x + 135, $y, 60, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|No limit", "0")
	_GUICtrlSetTip(-1, $sTxtTip)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSpellFactoryBoost, $x + 204, $y - 2, 24, 24)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDarkSpellBoost, $x + 233, $y - 2, 24, 24)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "LblSpellFactoryBoost", "Spell Factory"), $x + 263, $y + 4, -1, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "LblSpellFactoryBoost_Info_01", "Use this to boost your Spell Factory with GEMS! Use with caution!")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hCmbBoostSpellFactory = GUICtrlCreateCombo("", $x + 330, $y, 60, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|No limit", "0")
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 25
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnWorkshopBoost, $x + 5, $y - 2, 24, 24)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "LblWorkshopBoost", "Workshop"), $x + 20 + 29, $y + 4, -1, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "LblWorkshopBoost_Info_01", "Use this to boost your Workshop with GEMS! Use with caution!")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hCmbBoostWorkshop = GUICtrlCreateCombo("", $x + 135, $y, 60, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|No limit", "0")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Heroes
	$y += 55
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "Group_02", "Boost Heroes"), $x - 20, $y - 20, $g_iSizeWGrpTab3 - 12, 75)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnKingBoost, $x - 10, $y - 2, 24, 24)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design Names Troops", "King", -1), $x + 20, $y + 4, -1, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "LblKingBoost_Info_01", "Use this to boost your Barbarian King with GEMS! Use with caution!")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hCmbBoostBarbarianKing = GUICtrlCreateCombo("", $x + 135, $y, 60, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|No limit", "0")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradeKing")

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnQueenBoost, $x + 204, $y - 2, 24, 24)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Queen", -1), $x + 234, $y + 4, -1, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "LblQueenBoost_Info_01", "Use this to boost your Archer Queen with GEMS! Use with caution!")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hCmbBoostArcherQueen = GUICtrlCreateCombo("", $x + 330, $y, 60, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|No limit", "0")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradeQueen")

	$y += 25
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnWardenBoost, $x - 10, $y - 2, 24, 24)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Grand Warden", -1), $x + 20, $y + 4, -1, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "LblWardenBoost_Info_01", "Use this to boost your Grand Warden with GEMS! Use with caution!")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hCmbBoostWarden = GUICtrlCreateCombo("", $x + 135, $y, 60, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|No limit", "0")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradeWarden")

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnChampionBoost, $x + 204, $y - 2, 24, 24)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Royal Champion", -1), $x + 234, $y + 4, -1, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "LblChampionBoost_Info_01", "Use this to boost your Royal Champion with GEMS! Use with caution!")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hCmbBoostChampion = GUICtrlCreateCombo("", $x + 330, $y, 60, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|No limit", "0")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradeChampion")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 55
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "Group_03", "Boost Everything"), $x - 20, $y - 20, $g_iSizeWGrpTab3 - 12, 48)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBoostPotion, $x - 10, $y - 2, 24, 24)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Potion", -1), $x + 20, $y + 4, -1, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "LblEverythingBoost_Info_01", "Use this to boost everything with POTIONS! Use with caution!")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hCmbBoostEverything = GUICtrlCreateCombo("", $x + 135, $y, 60, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0|1|2|3|4|5", "0")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 55
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "Group_04", "Boost Schedule"), $x - 20, $y - 20, $g_iSizeWGrpTab3 - 12, 75)

	$g_hLblBoosthour = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Hour", -1) & ":", $x, $y, -1, 15)
	$sTxtTip = GetTranslatedFileIni("MBR Global GUI Design", "Only_during_hours", -1)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblBoosthours[0] = GUICtrlCreateLabel(" 0", $x + 30, $y)
	$g_hLblBoosthours[1] = GUICtrlCreateLabel(" 1", $x + 45, $y)
	$g_hLblBoosthours[2] = GUICtrlCreateLabel(" 2", $x + 60, $y)
	$g_hLblBoosthours[3] = GUICtrlCreateLabel(" 3", $x + 75, $y)
	$g_hLblBoosthours[4] = GUICtrlCreateLabel(" 4", $x + 90, $y)
	$g_hLblBoosthours[5] = GUICtrlCreateLabel(" 5", $x + 105, $y)
	$g_hLblBoosthours[6] = GUICtrlCreateLabel(" 6", $x + 120, $y)
	$g_hLblBoosthours[7] = GUICtrlCreateLabel(" 7", $x + 135, $y)
	$g_hLblBoosthours[8] = GUICtrlCreateLabel(" 8", $x + 150, $y)
	$g_hLblBoosthours[9] = GUICtrlCreateLabel(" 9", $x + 165, $y)
	$g_hLblBoosthours[10] = GUICtrlCreateLabel("10", $x + 180, $y)
	$g_hLblBoosthours[11] = GUICtrlCreateLabel("11", $x + 195, $y)
	$g_ahLblBoosthoursE = GUICtrlCreateLabel("X", $x + 213, $y + 2, 11, 11)

	$y += 15
	$g_hChkBoostBarracksHours[0] = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[1] = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[2] = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[3] = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[4] = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[5] = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[6] = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[7] = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[8] = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[9] = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[10] = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[11] = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHoursE1 = GUICtrlCreateCheckbox("", $x + 211, $y + 1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
	_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoldStar, 0)
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Clear_set_row_of_boxes", "This button will clear or set the entire row of boxes"))
	GUICtrlSetOnEvent(-1, "chkBoostBarracksHoursE1")
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "AM", "AM"), $x + 5, $y)

	$y += 15
	$g_hChkBoostBarracksHours[12] = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[13] = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[14] = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[15] = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[16] = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[17] = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[18] = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[19] = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[20] = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[21] = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[22] = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHours[23] = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkBoostBarracksHoursE2 = GUICtrlCreateCheckbox("", $x + 211, $y + 1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
	_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoldStar, 0)
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Clear_set_row_of_boxes", -1))
	GUICtrlSetOnEvent(-1, "chkBoostBarracksHoursE2")
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "PM", "PM"), $x + 5, $y)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "Group_05", "Boost Super Troops"), $x - 20, $y - 20, $g_iSizeWGrpTab3 - 12, 90)
	$x += 200
	$g_hChkSkipBoostSuperTroopOnHalt = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "ChkSkipBoostSuperTroopOnHalt", "Skip Boost on Halt"), $x - 14, $y - 10, -1, -1)
	GUICtrlSetOnEvent(-1, "chkSuperTroops")
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "Group_05", "Will Skip boost If Enabled Halt Attack and Account got on HaltAttack Mode"))
	$g_hChkUsePotionFirst = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "ChkusePotionFirst", "Use Potion First"), $x - 14, $y + 10, -1, -1)
	GUICtrlSetOnEvent(-1, "chkSuperTroops")
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "Group_05", "Will Skip boost If Enabled Halt Attack and Account got on HaltAttack Mode"))
	$x -= 200

	Local $sCmbTroopList = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtListOfSuperTroops", "Disabled|" & _ArrayToString($g_asSuperTroopNames))

	$g_hChkSuperTroops = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "ChkSuperTroops", "Enable Super Troops"), $x - 14, $y + 5, -1, -1)
	GUICtrlSetOnEvent(-1, "chkSuperTroops")

	For $i = 0 To $iMaxSupersTroop - 1
		$g_ahLblSuperTroops[$i] = GUICtrlCreateLabel($i + 1 & ":", $x - 14, $y + 38, 50, -1)
		GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahCmbSuperTroops[$i] = GUICtrlCreateCombo("", $x + 1, $y + 35, 115, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL, $WS_VSCROLL))
		GUICtrlSetData(-1, $sCmbTroopList, "Disabled")
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetOnEvent(-1, "cmbSuperTroops")
		$g_ahPicSuperTroops[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnOptions, $x + 120, $y + 10, 48, 48)
		GUICtrlSetState(-1, $GUI_HIDE)
		$x += 200
	Next
	GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc   ;==>CreateTrainBoost

Func CreateTrainOrder()
	$g_hGUI_TRAINARMY_TRAINORDER = _GUICreate("", $g_iSizeWGrpTab3, $g_iSizeHGrpTab3, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_TRAINARMY)
	GUISetBkColor($COLOR_WHITE, $g_hGUI_TRAINARMY_TRAINORDER)

	$g_hGUI_TRAINARMY_ORDER_TAB = GUICtrlCreateTab(0, 0, $g_iSizeWGrpTab3, $g_iSizeHGrpTab3, BitOR($TCS_FORCELABELLEFT, $TCS_FIXEDWIDTH))
	_GUICtrlTab_SetItemSize($g_hGUI_TRAINARMY_ORDER_TAB, 90, 20)
	CreateOrderTroopsSubTab()
	CreateOrderSpellsSubTab()

EndFunc   ;==>CreateTrainOrder

Func CreateOrderTroopsSubTab()
	$g_hGUI_TRAINARMY_ORDER_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_01_STab_03_STab_01", "Troops"))

	SetDefaultTroopGroup(False)
	LoadTranslatedTrainTroopsOrderList()

	Local $x = 20, $y = 30
	$g_hChkCustomTrainOrderEnable = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_TrainingOrder", "ChkCustomTrainOrderEnable", "Troops Order"), $x - 5, $y, -1, -1)
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_TrainingOrder", "ChkCustomTrainOrderEnable_Info_01", "Enable to select a custom troop training order") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_TrainingOrder", "ChkCustomTrainOrderEnable_Info_02", "Changing train order can be useful with CSV scripted attack armies!"))
	GUICtrlSetOnEvent(-1, "chkTroopOrder2")

	If UBound($g_asTroopOrderList) - 1 <> $eTroopCount Then ; safety check in case troops are added
		If $g_bDebugSetlogTrain Then SetLog("UBound($g_asTroopOrderList) - 1: " & UBound($g_asTroopOrderList) - 1 & " = " & "$eTroopCount: " & $eTroopCount, $COLOR_DEBUG) ;Debug
		SetLog("Monkey ate bad banana, fix $g_asTroopOrderList & $eTroopCount arrays!", $COLOR_RED)
	EndIf

	; Create translated list of Troops for combo box
	Local $sComboData = ""
	For $j = 0 To UBound($g_asTroopOrderList) - 1
		$sComboData &= $g_asTroopOrderList[$j] & "|"
	Next

	Local $txtTroopOrder = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_TrainingOrder", "TxtTroopOrder", "Enter sequence order for training of troop #")

	; Create ComboBox(es) for selection of troop training order
	$x += 50
	$y += 30
	For $z = 0 To UBound($g_ahCmbTroopOrder) - 1
		If $z < 5 Then
			GUICtrlCreateLabel($z + 1 & ":", $x - 16, $y + 2, -1, 25)
			$g_ahCmbTroopOrder[$z] = GUICtrlCreateCombo("", $x, $y, 94, 25, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
			GUICtrlSetOnEvent(-1, "GUITrainOrder")
			GUICtrlSetData(-1, $sComboData, "")
			_GUICtrlSetTip(-1, $txtTroopOrder & $z + 1)
			GUICtrlSetState(-1, $GUI_DISABLE)
			$g_ahImgTroopOrder[$z] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnOptions, $x + 97, $y - 2, 24, 24)
			$y += 35 ; move down to next combobox location
		ElseIf $z > 4 And $z < 10 Then
			If $z = 5 Then
				$x += 161
				$y = 60
			EndIf
			GUICtrlCreateLabel($z + 1 & ":", $x - 13, $y + 2, -1, 25)
			$g_ahCmbTroopOrder[$z] = GUICtrlCreateCombo("", $x + 4, $y, 94, 25, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
			GUICtrlSetOnEvent(-1, "GUITrainOrder")
			GUICtrlSetData(-1, $sComboData, "")
			_GUICtrlSetTip(-1, $txtTroopOrder & $z + 1)
			GUICtrlSetState(-1, $GUI_DISABLE)
			$g_ahImgTroopOrder[$z] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnOptions, $x + 101, $y - 2, 24, 24)
			$y += 35 ; move down to next combobox location
		Else
			$g_ahCmbTroopOrder[$z] = GUICtrlCreateCombo("", $x + 4, $y, 94, 25, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
			GUICtrlSetOnEvent(-1, "GUITrainOrder")
			GUICtrlSetData(-1, $sComboData, "")
			GUICtrlSetState(-1, $GUI_HIDE)
		EndIf
	Next

	$x = 85
	$y = 280
	$g_hBtnRemoveTroops = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_TrainingOrder", "BtnRemoveTroops", "Empty Troop List"), $x - 6, $y, 96, 20)
	GUICtrlSetState(-1, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_TrainingOrder", "BtnRemoveTroops_Info_01", "Push button to remove all troops from list and start over"))
	GUICtrlSetOnEvent(-1, "btnRemoveTroops")

	$x += 145
	$g_hBtnTroopOrderSet = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_TrainingOrder", "BtnTroopOrderSet", "Apply New Order"), $x - 6, $y, 96, 20)
	GUICtrlSetState(-1, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_TrainingOrder", "BtnTroopOrderSet_Info_01", "Push button when finished selecting custom troop training order") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_TrainingOrder", "BtnTroopOrderSet_Info_02", "Icon changes color based on status: Red= Not Set, Green = Order Set") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_TrainingOrder", "BtnTroopOrderSet_Info_03", "When not all troop slots are filled, will use random troop order in empty slots!"))
	GUICtrlSetOnEvent(-1, "btnTroopOrderSet")
	$g_ahImgTroopOrderSet = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSilverStar, $x + 119, $y, 18, 18)
EndFunc   ;==>CreateOrderTroopsSubTab

Func CreateOrderSpellsSubTab()
	$g_hGUI_TRAINARMY_ORDER_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_01_STab_03_STab_02", "Spells"))

	SetDefaultTroopGroup(False)
	LoadTranslatedTrainTroopsOrderList()
	LoadTranslatedBrewSpellsOrderList()

	Local $x = 25, $y = 30
	; Brew Spells Order  [641] 49 last
	$g_hChkCustomBrewOrderEnable = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_TrainingOrder", "ChkCustomBrewOrderEnable", "Spells Order"), $x - 5, $y, -1, -1)
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_TrainingOrder", "ChkCustomBrewOrderEnable_Info_01", "Enable to select a Brew Spells order") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_TrainingOrder", "ChkCustomBrewOrderEnable_Info_02", "Changing spells order can be useful with CSV scripted attack armies!"))
	GUICtrlSetOnEvent(-1, "chkSpellsOrder")

	; Create translated list of Spells for combo box
	Local $sComboData = ""
	For $j = 0 To UBound($g_asSpellsOrderList) - 1
		$sComboData &= $g_asSpellsOrderList[$j] & "|"
	Next

	Local $txtSpellsOrder = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_TrainingOrder", "txtSpellsOrder", "Enter sequence order for brew Spells #")

	; Create ComboBox(es) for selection of Spells brew order
	$x += 50
	$y += 30
	For $z = 0 To $eSpellCount - 1
		If $z < 7 Then
			GUICtrlCreateLabel($z + 1 & ":", $x - 16, $y + 2, -1, 18)
			$g_ahCmbSpellsOrder[$z] = GUICtrlCreateCombo("", $x, $y, 94, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetOnEvent(-1, "GUISpellsOrder")
			GUICtrlSetData(-1, $sComboData, "")
			_GUICtrlSetTip(-1, $txtSpellsOrder & $z + 1)
			GUICtrlSetState(-1, $GUI_DISABLE)
			$g_ahImgSpellsOrder[$z] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnOptions, $x + 97, $y - 2, 24, 24)
			$y += 35 ; move down to next combobox location
		Else
			If $z = 7 Then
				$x += 161
				$y = 60
			EndIf
			GUICtrlCreateLabel($z + 1 & ":", $x - 13, $y + 2, -1, 18)
			$g_ahCmbSpellsOrder[$z] = GUICtrlCreateCombo("", $x + 4, $y, 94, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetOnEvent(-1, "GUISpellsOrder")
			GUICtrlSetData(-1, $sComboData, "")
			_GUICtrlSetTip(-1, $txtSpellsOrder & $z + 1)
			GUICtrlSetState(-1, $GUI_DISABLE)
			$g_ahImgSpellsOrder[$z] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnOptions, $x + 101, $y - 2, 24, 24)
			$y += 35 ; move down to next combobox location
		EndIf
	Next
	$x = 85
	$y = 320
	$g_hBtnRemoveSpells = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_TrainingOrder", "BtnRemoveSpells", "Empty Spell list"), $x, $y, 94, 22)
	GUICtrlSetState(-1, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_TrainingOrder", "BtnRemoveSpells_Info_01", "Push button to remove all spells from list and start over"))
	GUICtrlSetOnEvent(-1, "BtnRemoveSpells")

	$x += 145
	$g_hBtnSpellsOrderSet = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_TrainingOrder", "BtnSpellsOrderSet", "Apply New Order"), $x, $y, 94, 22)
	GUICtrlSetState(-1, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_TrainingOrder", "BtnSpellsOrderSet_Info_01", "Push button when finished selecting custom spells brew order") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_TrainingOrder", "BtnSpellsOrderSet_Info_02", "Icon changes color based on status: Red= Not Set, Green = Order Set") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_TrainingOrder", "BtnSpellsOrderSet_Info_03", "When not all spells slots are filled, will use random spell order in empty slots!"))
	GUICtrlSetOnEvent(-1, "BtnSpellsOrderSet")
	$g_ahImgSpellsOrderSet = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSilverStar, $x + 119, $y + 2, 18, 18)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc   ;==>CreateOrderSpellsSubTab

Func CreateTrainOptions()

	$g_hGUI_TRAINARMY_OPTIONS = _GUICreate("", $g_iSizeWGrpTab3, $g_iSizeHGrpTab3, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_TRAINARMY)
	GUISetBkColor($COLOR_WHITE, $g_hGUI_TRAINARMY_OPTIONS)

	Local $sTxtTip = ""
	Local $x = 25, $y = 20
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "Group_01", "Training Idle Time"), $x - 20, $y - 20, 151, 294)
	$g_hChkCloseWhileTraining = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkCloseWhileTraining", "Close While Training"), $x - 12, $y, 140, -1)
	GUICtrlSetState(-1, $GUI_CHECKED)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkCloseWhileTraining_Info_01", "Option will exit CoC game for time required to complete TROOP training when SHIELD IS ACTIVE") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkCloseWhileTraining_Info_02", "Close for Spell creation will be enabled when 'Wait for Spells' is selected on Search tabs") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkCloseWhileTraining_Info_03", "Close for Hero healing will be enabled when 'Wait for Heroes' is enabled on Search tabs"))
	GUICtrlSetOnEvent(-1, "chkCloseWaitEnable")

	$y += 28
	$g_hChkCloseWithoutShield = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkCloseWithoutShield", "Without Shield"), $x + 18, $y + 1, 110, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkCloseWithoutShield_Info_01", "Option will ALWAYS close CoC for idle training time and when NO SHIELD IS ACTIVE!") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkCloseWithoutShield_Info_02", "Note - You can be attacked and lose trophies when this option is enabled!")
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkCloseWaitTrain")
	$g_hPicCloseWaitTrain = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnNoShield, $x - 13, $y, 24, 24)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_hChkCloseEmulator = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkCloseEmulator", "Close Emulator"), $x + 18, $y + 1, 110, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkCloseEmulator_Info_01", "Option will close Android Emulator completely when selected") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkCloseEmulator_Info_02", "Adding this option may increase offline time slightly due to variable times required for startup")
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "btnCloseWaitStop")
	$g_hPicCloseWaitStop = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnRecycle, $x - 13, $y + 13, 24, 24)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_hChkSuspendComputer = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkSuspendComputer", "Suspend Computer"), $x + 18, $y + 1, 110, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkSuspendComputer_Info_01", "Option will suspend computer when selected\r\nAdding this option may increase offline time slightly due to variable times required for startup")
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "btnCloseWaitSuspendComputer")
	;$g_hPicCloseWaitStop = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnRecycle, $x - 13, $y + 13, 24, 24)
	;_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_hChkRandomClose = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkRandomClose", "Random Close"), $x + 18, $y + 1, 110, -1)
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkRandomClose_Info_01", "Option will Randomly choose between time out, close CoC, or Close emulator when selected") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkRandomClose_Info_02", "Adding this option may increase offline time slightly due to variable times required for startup"))
	GUICtrlSetOnEvent(-1, "btnCloseWaitStopRandom")

	$y += 28
	$g_hRdoCloseWaitExact = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "RdoCloseWaitExact", "Exact Time"), $x + 18, $y + 1, 110, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "RdoCloseWaitExact_Info_01", "Select to wait exact time required for troops to complete training"))
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	GUICtrlSetOnEvent(-1, "btnCloseWaitRandom")
	$g_hPicCloseWaitExact = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnHourGlass, $x - 13, $y + 13, 24, 24)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "RdoCloseWaitExact_Info_02", "Select how much time to wait when feature enables"))

	$y += 24
	$g_hRdoCloseWaitRandom = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "RdoCloseWaitRandom", "Random Time"), $x + 18, $y + 1, 110, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "RdoCloseWaitRandom_Info_01", "Select to ADD a random extra wait time like human who forgets to clash"))
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlSetOnEvent(-1, "btnCloseWaitRandom")

	$y += 28
	$g_hCmbCloseWaitRdmPercent = GUICtrlCreateCombo("", $x + 36, $y, 40, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "CmbCloseWaitRdmPercent_Info_01", "Enter maximum percentage of additional time to be used creating random wait times,") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "CmbCloseWaitRdmPercent_Info_02", "Bot will compute a random wait time between exact time needed, and") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "CmbCloseWaitRdmPercent_Info_03", "maximum random percent entered to appear more human like")
	GUICtrlSetData(-1, "1|2|3|4|5|6|7|8|9|10|11|12|13|14|15", "10")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblCloseWaitRdmPercent = GUICtrlCreateLabel("%", $x + 84, $y + 3, -1, -1)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_hLblCloseWaitingTroops = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "LblCloseWaitingTroops", "Minimum Time To Close") & ": ", $x - 12, $y, -1, -1)
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "LblCloseWaitingTroops_Info_01", "Will be close CoC If train time troops >= (Minimum time required to close)" & @CRLF & _
			"Just stay in the main screen if train time troops < (Minimum time required to close)"))
	GUICtrlSetOnEvent(-1, "chkCloseWaitEnable")

	$y += 22
	$g_hLblSymbolWaiting = GUICtrlCreateLabel(">", $x + 26, $y + 3, -1, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "LblSymbolWaiting_Info_01", "Enter number Minimum time to close in minutes for close CoC which you want, Default Is (2)")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hCmbMinimumTimeClose = GUICtrlCreateCombo("", $x + 36, $y, 40, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "2|3|4|5|6|7|8|9|10", "2")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblWaitingInMinutes = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "min.", "min."), $x + 84, $y + 3, -1, -1)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 53
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "Group_02", "Train Click Timing"), $x - 20, $y - 20, 151, 60)
	$g_hLblTrainITDelay = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "LblTrainITDelay", "delay"), $x - 10, $y, 37, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "LblTrainITDelay_Info_01", "Increase the delay if your PC is slow or to create human like training click speed")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblTrainITDelayTime = GUICtrlCreateLabel("100 ms", $x - 10, $y + 15, 37, -1)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hSldTrainITDelay = GUICtrlCreateSlider($x + 30, $y, 90, 25, BitOR($TBS_TOOLTIPS, $TBS_AUTOTICKS))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "LblTrainITDelay_Info_01", -1))
	_GUICtrlSlider_SetTipSide(-1, $TBTS_BOTTOM)
	_GUICtrlSlider_SetTicFreq(-100, 100)
	GUICtrlSetLimit(-1, 500, 1) ; change max/min value
	GUICtrlSetData(-1, 100) ; default value
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetOnEvent(-1, "sldTrainITDelay")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = 25 + 151 + 5
	$y = 20
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "Group_03", "Training Add Random Delay"), $x - 20, $y - 20, 173, 81)
	$y += 15
	$g_hChkTrainAddRandomDelayEnable = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkTrainAddRandomDelayEnable", "Add Random Delay"), $x + 18, $y - 11, 130, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkTrainAddRandomDelayEnable_Info_01", "Add random delay between two calls of train army.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkTrainAddRandomDelayEnable_Info_02", "This option reduces the calls to the training window  humanizing the bot spacing calls each time with a causal interval chosen between the minimum and maximum values indicated below.")
	GUICtrlSetState(-1, $GUI_CHECKED)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkAddDelayIdlePhaseEnable")
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDelay, $x - 13, $y - 13, 24, 24)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 18
	$y += 18
	$g_hLblAddDelayIdlePhaseBetween = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "LblAddDelayIdlePhaseBetween", "Between"), $x - 12, $y, 50, -1)
	$g_hTxtAddRandomDelayMin = GUICtrlCreateInput($g_iTrainAddRandomDelayMin, $x + 32, $y - 2, 25, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetLimit(-1, 999)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtWaitForCastleSpell", "And"), $x + 61, $y, 20, -1)
	$g_hTxtAddRandomDelayMax = GUICtrlCreateInput($g_iTrainAddRandomDelayMax, $x + 82, $y - 2, 25, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetLimit(-1, 999)
	$g_hLblAddDelayIdlePhaseSec = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "sec.", "sec."), $x + 110, $y, 20, -1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateTrainOptions
