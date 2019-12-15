; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Train Army" tab under the "Attack Plan" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GKevinOD (2014)
; Modified ......: DkEd, Hervidero (2015), Boju (11-2016), CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
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

; Custom train tab & Quick train tab
Global $g_hGUI_TRAINTYPE = 0
Global $g_hGUI_TRAINTYPE_TAB = 0, $g_hGUI_TRAINTYPE_TAB_ITEM1 = 0, $g_hGUI_TRAINTYPE_TAB_ITEM2 = 0, $g_hGUI_TRAINTYPE_TAB_ITEM3 = 0, $g_hGUI_TRAINTYPE_TAB_ITEM4 = 0

; Troops/Spells sub-tab
Global $g_hRadCustomTrain = 0, $g_hRadQuickTrain = 0, $g_ahChkArmy[3] = [0, 0, 0]
Global $g_ahTxtTrainArmyTroopCount[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_ahLblTrainArmyTroopLevel[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_ahTxtTrainArmySpellCount[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_ahLblTrainArmySpellLevel[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_ahTxtTrainArmySiegeCount[$eSiegeMachineCount] = [0, 0, 0, 0]
Global $g_ahLblTrainArmySiegeLevel[$eSiegeMachineCount] = [0, 0, 0, 0]
Global $g_hTxtFullTroop = 0, $g_hChkTotalCampForced = 0, $g_hTxtTotalCampForced = 0
Global $g_hChkDoubleTrain = 0, $g_hChkPreciseArmy = 0

Global $g_hGrpTrainTroops = 0
Global $g_ahPicTrainArmyTroop[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_ahPicTrainArmySpell[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_ahPicTrainArmySiege[$eSiegeMachineCount] = [0, 0, 0, 0]
Global $g_hLblTotalTimeCamp = 0, $g_hLblElixirCostCamp = 0, $g_hLblDarkCostCamp = 0, $g_hCalTotalTroops = 0, $g_hLblTotalProgress = 0, $g_hLblCountTotal = 0, _
		$g_hTxtTotalCountSpell = 0, $g_hLblTotalTimeSpell = 0, $g_hLblElixirCostSpell = 0, $g_hLblDarkCostSpell = 0, _
		$g_hLblTotalTimeSiege = 0, $g_hLblCountTotalSiege = 0, $g_hLblGoldCostSiege = 0

; Quick Train sub-tab
Global $g_aQuickTroopIcon[$eTroopCount] = [$eIcnBarbarian, $eIcnArcher, $eIcnGiant, $eIcnGoblin, $eIcnWallBreaker, $eIcnBalloon, $eIcnWizard, $eIcnHealer, $eIcnDragon, $eIcnPekka, _
		$eIcnBabyDragon, $eIcnMiner, $eIcnElectroDragon, $eIcnYeti, $eIcnMinion, $eIcnHogRider, $eIcnValkyrie, $eIcnGolem, $eIcnWitch, $eIcnLavaHound, $eIcnBowler, $eIcnIceGolem]
Global $g_aQuickSpellIcon[$eSpellCount] = [$eIcnLightSpell, $eIcnHealSpell, $eIcnRageSpell, $eIcnJumpSpell, $eIcnFreezeSpell, $eIcnCloneSpell, $eIcnPoisonSpell, $eIcnEarthQuakeSpell, $eIcnHasteSpell, $eIcnSkeletonSpell, $eIcnBatSpell]
Global $g_ahChkUseInGameArmy[3], $g_ahPicTotalQTroop[3], $g_ahPicTotalQSpell[3], $g_ahLblTotalQTroop[3], $g_ahLblTotalQSpell[3]
Global $g_ahBtnEditArmy[3], $g_ahLblEditArmy[3], $g_ahPicQuickTroop[3][22], $g_ahLblQuickTroop[3][22], $g_ahPicQuickSpell[3][11], $g_ahLblQuickSpell[3][11]
Global $g_ahLblQuickTrainNote[3], $g_ahLblUseInGameArmyNote[3]

Global $g_hGUI_QuickTrainEdit = 0, $g_hGrp_QTEdit = 0
Global $g_hBtnRemove_QTEdit, $g_hBtnSave_QTEdit, $g_hBtnCancel_QTEdit
Global $g_ahPicQTEdit_Troop[7], $g_ahTxtQTEdit_Troop[7], $g_ahPicQTEdit_Spell[7], $g_ahTxtQTEdit_Spell[7]
Global $g_ahLblQTEdit_TotalTroop, $g_ahLblQTEdit_TotalSpell
Global $g_ahPicTroop_QTEdit[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_ahPicSpell_QTEdit[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

; Boost sub-tab
Global $g_hCmbBoostBarracks = 0, $g_hCmbBoostSpellFactory = 0, $g_hCmbBoostWorkshop = 0, $g_hCmbBoostBarbarianKing = 0, $g_hCmbBoostArcherQueen = 0, $g_hCmbBoostWarden = 0, $g_hCmbBoostChampion = 0, $g_hCmbBoostEverything = 0
Global $g_hLblBoosthour = 0, $g_ahLblBoosthoursE = 0
Global $g_hLblBoosthours[12] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hChkBoostBarracksHours[24] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], $g_hChkBoostBarracksHoursE1 = 0, $g_hChkBoostBarracksHoursE2 = 0

; Train Order sub-tab
Func LoadTranslatedTrainTroopsOrderList()

	Global $g_asTroopOrderList = ["", _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBarbarians", "Barbarians"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtArchers", "Archers"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtGiants", "Giants"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtGoblins", "Goblins"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtWallBreakers", "Wall Breakers"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBalloons", "Balloons"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtWizards", "Wizards"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtHealers", "Healers"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtDragons", "Dragons"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtPekkas", "Pekkas"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBabyDragons", "Baby Dragons"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtMiners", "Miners"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtElectroDragons", "Electro Dragons"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtYetis", "Yetis"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtMinions", "Minions"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtHogRiders", "Hog Riders"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtValkyries", "Valkyries"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtGolems", "Golems"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtWitches", "Witches"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtLavaHounds", "Lava Hounds"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBowlers", "Bowlers"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtIceGolems", "Ice Golems")]
EndFunc   ;==>LoadTranslatedTrainTroopsOrderList

Global $g_hChkCustomTrainOrderEnable = 0
Global $g_ahCmbTroopOrder[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_ahImgTroopOrder[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
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
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortPoisonSpells", "Poison"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortEarthquakeSpells", "EarthQuake"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortHasteSpells", "Haste"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortSkeletonSpells", "Skeleton"), _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortBatSpells", "Bat")]
EndFunc   ;==>LoadTranslatedBrewSpellsOrderList

Global $g_hChkCustomBrewOrderEnable = 0
Global $g_ahCmbSpellsOrder[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_ahImgSpellsOrder[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
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

	$g_hChkTotalCampForced = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "ChkTotalCampForced", "Force Total Army Camp") & ":", $x, $y, -1, -1)
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
	GUICtrlSetOnEvent(-1, "TotalSpellCountClick")

	$g_hChkPreciseArmy = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "ChkPreciseArmy", "Precise Army"), $x + 242, $y + 26, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Precise ArmyTip", "Always check and remove wrong troops or spells exist in army"))
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)

	$g_hChkDoubleTrain = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "ChkDoubleTrain", "Double Train"), $x + 332, $y + 26, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "DoubleTrainTip", "Train 2nd set of Troops & Spells after training 1st combo") & @CRLF & _
			GetTranslatedFileIni("MBR Global GUI Design", "DoubleTrainTip1", "Make sure to enter exactly the 'Total Camp',") & @CRLF & _
			GetTranslatedFileIni("MBR Global GUI Design", "DoubleTrainTip2", "'Total Spell' and number of Troops/Spells in your Setting") & @CRLF & _
			GetTranslatedFileIni("MBR Global GUI Design", "DoubleTrainTip3", "Note: Donations + Double Train can produce an unbalanced army!"))
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)

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

	$g_hGUI_QuickTrainEdit = _GUICreate(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "GUI_QuickTrainEdit", "Edit troops and spells for quick train"), $g_iSizeWGrpTab2, 320, -1, -1, $WS_BORDER, $WS_EX_CONTROLPARENT)

	Local $x = 7
	Local $y = 5
	$g_hGrp_QTEdit = GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "GUI_QuickTrainEdit", "Edit troops and spells for quick train"), $x, $y, 422, 280)

		$x = 12
		$y = 20
		GUICtrlCreateGroup("", $x, $y - 3, 412, 125)

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

		$g_ahLblQTEdit_TotalTroop = GUICtrlCreateLabel(0, $x + 360, $y + 25, 40, 15, $SS_RIGHT)
		GUICtrlSetBkColor(-1, $COLOR_GRAY)
		GUICtrlSetColor(-1, $COLOR_WHITE)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTroopsCost, $x + 353, $y + 20, 24, 24)

		$g_ahLblQTEdit_TotalSpell = GUICtrlCreateLabel(0, $x + 360, $y + 85, 40, 15, $SS_RIGHT)
		GUICtrlSetBkColor(-1, $COLOR_GRAY)
		GUICtrlSetColor(-1, $COLOR_WHITE)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSpellsCost, $x + 350, $y + 80, 24, 24)

		GUICtrlCreateGroup("", -99, -99, 1, 1)

		$x = 14
		$y = 160
		For $i = 0 To $eTroopCount - 1
			If $i <= 10 Then
				If IsInt($i / 2) Then
					If $i > 0 Then $x += 37
					$y = 160
				Else
					$y += 40
				EndIf
			Else
				If IsInt($i / 2) Then
					If $i > 0 Then $x += 37
					$y = 160
				Else
					$y += 40
				EndIf
			EndIf
			$g_ahPicTroop_QTEdit[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $g_aQuickTroopIcon[$i], $x, $y, 32, 32)
			GUICtrlSetTip(-1, $g_asTroopNames[$i])
			GUICtrlSetOnEvent(-1, "SelectTroop_QTEdit")
		Next

		$x = 14
		$y = 240
		For $i = 0 To $eSpellCount - 1
			$g_ahPicSpell_QTEdit[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $g_aQuickSpellIcon[$i], $x, $y, 32, 32)
			GUICtrlSetTip(-1, $g_asSpellNames[$i])
			GUICtrlSetOnEvent(-1, "SelectSpell_QTEdit")
			$x += 37
			If $i = 5 Then $x += 5
		Next
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateQuickTrainEdit

Func CreateCustomTrainSubTab()

	$g_hGUI_TRAINARMY_ARMY_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_01_STab_01_STab_01", "Custom Train"))

	Local $sTxtSetPerc = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "TxtSetTroop_Info_01", "Enter the No. of")
	Local $sTxtSetPerc2 = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "TxtSetTroop_Info_02", "to make.")
	Local $iStartX = 12

	Local $x = 0
	Local $y = 45
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Btn_Remove_Army", "Remove Army"), $x + 325, $y + 15, -1, 15, $SS_LEFT)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnResetButton, $x + 395, $y + 10, 24, 24)
	GUICtrlSetOnEvent(-1, "Removecamp")

	$x = $iStartX
	$y += 40
	; Barbarians
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBarbarians", "Barbarians")
	$g_ahPicTrainArmyTroop[$eTroopBarbarian] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBarbarian, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Level", "Level") & " " & $sTroopName & ":" & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Mouse_Left_Click", "Mouse Left Click to Up level" & @CRLF & "Shift + Mouse Left Click to Down level"))
	GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
	$g_ahLblTrainArmyTroopLevel[$eTroopBarbarian] = GUICtrlCreateLabel("1", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$g_ahTxtTrainArmyTroopCount[$eTroopBarbarian] = GUICtrlCreateInput("58", $x + 1, $y + 29, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 3)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += 37
	; Giants
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtGiants", "Giants")
	$g_ahPicTrainArmyTroop[$eTroopGiant] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGiant, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Level", -1) & " " & $sTroopName & ":" & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Mouse_Left_Click", -1))
	GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
	$g_ahLblTrainArmyTroopLevel[$eTroopGiant] = GUICtrlCreateLabel("1", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$g_ahTxtTrainArmyTroopCount[$eTroopGiant] = GUICtrlCreateInput("4", $x + 1, $y + 29, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += 37
	; WallBreakers
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtWallBreakers", "Wall Breakers")
	$g_ahPicTrainArmyTroop[$eTroopWallBreaker] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnWallBreaker, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Level", -1) & " " & $sTroopName & ":" & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Mouse_Left_Click", -1))
	GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
	$g_ahLblTrainArmyTroopLevel[$eTroopWallBreaker] = GUICtrlCreateLabel("1", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$g_ahTxtTrainArmyTroopCount[$eTroopWallBreaker] = GUICtrlCreateInput("4", $x + 1, $y + 29, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 3)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += 37
	; Wizards
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtWizards", "Wizards")
	$g_ahPicTrainArmyTroop[$eTroopWizard] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnWizard, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Level", -1) & " " & $sTroopName & ":" & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Mouse_Left_Click", -1))
	GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
	$g_ahLblTrainArmyTroopLevel[$eTroopWizard] = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$g_ahTxtTrainArmyTroopCount[$eTroopWizard] = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += 37
	; Dragon
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtDragons", "Dragons")
	$g_ahPicTrainArmyTroop[$eTroopDragon] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDragon, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Level", -1) & " " & $sTroopName & ":" & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Mouse_Left_Click", -1))
	GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
	$g_ahLblTrainArmyTroopLevel[$eTroopDragon] = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$g_ahTxtTrainArmyTroopCount[$eTroopDragon] = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += 37
	; BDragon
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBabyDragons", "Baby Dragons")
	$g_ahPicTrainArmyTroop[$eTroopBabyDragon] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBabyDragon, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Level", -1) & " " & $sTroopName & ":" & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Mouse_Left_Click", -1))
	GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
	$g_ahLblTrainArmyTroopLevel[$eTroopBabyDragon] = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$g_ahTxtTrainArmyTroopCount[$eTroopBabyDragon] = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += 37
	; Electro Dragon
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtElectroDragons", "Electro Dragons")
	$g_ahPicTrainArmyTroop[$eTroopElectroDragon] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnElectroDragon, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Level", -1) & " " & $sTroopName & ":" & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Mouse_Left_Click", -1))
	GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
	$g_ahLblTrainArmyTroopLevel[$eTroopElectroDragon] = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$g_ahTxtTrainArmyTroopCount[$eTroopElectroDragon] = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += 42
	; Minions
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtMinions", "Minions")
	$g_ahPicTrainArmyTroop[$eTroopMinion] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnMinion, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Level", -1) & " " & $sTroopName & ":" & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Mouse_Left_Click", -1))
	GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
	$g_ahLblTrainArmyTroopLevel[$eTroopMinion] = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$g_ahTxtTrainArmyTroopCount[$eTroopMinion] = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 3)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += 37
	; Valkyries
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtValkyries", "Valkyries")
	$g_ahPicTrainArmyTroop[$eTroopValkyrie] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnValkyrie, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Level", -1) & " " & $sTroopName & ":" & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Mouse_Left_Click", -1))
	GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
	$g_ahLblTrainArmyTroopLevel[$eTroopValkyrie] = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$g_ahTxtTrainArmyTroopCount[$eTroopValkyrie] = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += 37
	; Witches
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtWitches", "Witches")
	$g_ahPicTrainArmyTroop[$eTroopWitch] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnWitch, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Level", -1) & " " & $sTroopName & ":" & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Mouse_Left_Click", -1))
	GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
	$g_ahLblTrainArmyTroopLevel[$eTroopWitch] = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$g_ahTxtTrainArmyTroopCount[$eTroopWitch] = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += 37
	; Bowlers
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBowlers", "Bowlers")
	$g_ahPicTrainArmyTroop[$eTroopBowler] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBowler, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Level", -1) & " " & $sTroopName & ":" & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Mouse_Left_Click", -1))
	GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
	$g_ahLblTrainArmyTroopLevel[$eTroopBowler] = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$g_ahTxtTrainArmyTroopCount[$eTroopBowler] = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	; Next Row
	$x = $iStartX
	$y += 55

	; Archers
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtArchers", "Archers")
	$g_ahPicTrainArmyTroop[$eTroopArcher] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnArcher, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Level", -1) & " " & $sTroopName & ":" & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Mouse_Left_Click", -1))
	GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
	$g_ahLblTrainArmyTroopLevel[$eTroopArcher] = GUICtrlCreateLabel("1", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$g_ahTxtTrainArmyTroopCount[$eTroopArcher] = GUICtrlCreateInput("115", $x + 1, $y + 29, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 3)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += 37
	; Goblins
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtGoblins", "Goblins")
	$g_ahPicTrainArmyTroop[$eTroopGoblin] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGoblin, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Level", -1) & " " & $sTroopName & ":" & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Mouse_Left_Click", -1))
	GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
	$g_ahLblTrainArmyTroopLevel[$eTroopGoblin] = GUICtrlCreateLabel("1", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$g_ahTxtTrainArmyTroopCount[$eTroopGoblin] = GUICtrlCreateInput("19", $x + 1, $y + 29, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 3)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += 37
	; Balloons
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBalloons", "Balloons")
	$g_ahPicTrainArmyTroop[$eTroopBalloon] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBalloon, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Level", -1) & " " & $sTroopName & ":" & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Mouse_Left_Click", -1))
	GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
	$g_ahLblTrainArmyTroopLevel[$eTroopBalloon] = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$g_ahTxtTrainArmyTroopCount[$eTroopBalloon] = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += 37
	; Healers
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtHealers", "Healers")
	$g_ahPicTrainArmyTroop[$eTroopHealer] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnHealer, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Level", -1) & " " & $sTroopName & ":" & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Mouse_Left_Click", -1))
	GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
	$g_ahLblTrainArmyTroopLevel[$eTroopHealer] = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$g_ahTxtTrainArmyTroopCount[$eTroopHealer] = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += 37
	; Pekkas
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtPekkas", "Pekkas")
	$g_ahPicTrainArmyTroop[$eTroopPekka] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnPekka, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Level", -1) & " " & $sTroopName & ":" & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Mouse_Left_Click", -1))
	GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
	$g_ahLblTrainArmyTroopLevel[$eTroopPekka] = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$g_ahTxtTrainArmyTroopCount[$eTroopPekka] = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += 37
	; Miners
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtMiners", "Miners")
	$g_ahPicTrainArmyTroop[$eTroopMiner] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnMiner, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Level", -1) & " " & $sTroopName & ":" & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Mouse_Left_Click", -1))
	GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
	$g_ahLblTrainArmyTroopLevel[$eTroopMiner] = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$g_ahTxtTrainArmyTroopCount[$eTroopMiner] = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += 37
	; Yeti
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtYetis", "Yetis")
	$g_ahPicTrainArmyTroop[$eTroopYeti] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnYeti, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Level", -1) & " " & $sTroopName & ":" & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Mouse_Left_Click", -1))
	GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
	$g_ahLblTrainArmyTroopLevel[$eTroopYeti] = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$g_ahTxtTrainArmyTroopCount[$eTroopYeti] = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += 42
	; Hogs
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtHogRiders", "Hog Riders")
	$g_ahPicTrainArmyTroop[$eTroopHogRider] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnHogRider, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Level", -1) & " " & $sTroopName & ":" & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Mouse_Left_Click", -1))
	GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
	$g_ahLblTrainArmyTroopLevel[$eTroopHogRider] = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$g_ahTxtTrainArmyTroopCount[$eTroopHogRider] = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += 37
	; Golems
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtGolems", "Golems")
	$g_ahPicTrainArmyTroop[$eTroopGolem] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGolem, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Level", -1) & " " & $sTroopName & ":" & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Mouse_Left_Click", -1))
	GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
	$g_ahLblTrainArmyTroopLevel[$eTroopGolem] = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$g_ahTxtTrainArmyTroopCount[$eTroopGolem] = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += 37
	; Lavas
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtLavaHounds", "Lava Hounds")
	$g_ahPicTrainArmyTroop[$eTroopLavaHound] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnLavaHound, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Level", -1) & " " & $sTroopName & ":" & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Mouse_Left_Click", -1))
	GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
	$g_ahLblTrainArmyTroopLevel[$eTroopLavaHound] = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$g_ahTxtTrainArmyTroopCount[$eTroopLavaHound] = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$x += 37
	; IceGolems
	Local $sTroopName = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtIceGolems", "IceGolems")
	$g_ahPicTrainArmyTroop[$eTroopIceGolem] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnIceGolem, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Level", -1) & " " & $sTroopName & ":" & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Mouse_Left_Click", -1))
	GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
	$g_ahLblTrainArmyTroopLevel[$eTroopIceGolem] = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$g_ahTxtTrainArmyTroopCount[$eTroopIceGolem] = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	$y += 37
	$x = 170
	; troop count
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTroopsCost, $x, $y + 10, 24, 24)
	$g_hLblTotalTimeCamp = GUICtrlCreateLabel(" 0s", $x + 28, $y + 15, 70, 15, $SS_RIGHT)
	GUICtrlSetBkColor(-1, $COLOR_GRAY)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_WHITE)
	$g_hLblElixirCostCamp = GUICtrlCreateLabel(" 0", $x + 103, $y + 15, 77, 15, $SS_RIGHT)
	GUICtrlSetBkColor(-1, $COLOR_GRAY)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_WHITE)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 101, $y + 14, 16, 16)
	$g_hLblDarkCostCamp = GUICtrlCreateLabel(" 0", $x + 185, $y + 15, 62, 15, $SS_RIGHT)
	GUICtrlSetBkColor(-1, $COLOR_GRAY)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_WHITE)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 183, $y + 14, 16, 16)

	$x = $iStartX
	$y += 26
	$g_hCalTotalTroops = GUICtrlCreateProgress($x, $y + 9, 336, 10)
	$g_hLblTotalProgress = GUICtrlCreateLabel("", $x, $y + 9, 336, 10)
	GUICtrlSetBkColor(-1, $COLOR_RED)
	GUICtrlSetState(-1, BitOR($GUI_DISABLE, $GUI_HIDE))

	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "LblCountTotal", "Total"), $x + 341, $y + 7, -1, -1)
	$g_hLblCountTotal = GUICtrlCreateLabel(0, $x + 368, $y + 7, 30, 15, $SS_CENTER)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "LblCountTotal_Info_01", "The total Units of Troops should equal Total Army Camps."))
	GUICtrlSetBkColor(-1, $COLOR_MONEYGREEN) ;lime, moneygreen
	GUICtrlCreateLabel("x", $x + 400, $y + 7, -1, -1)

	$x = $iStartX
	$y += 25
	; Lightning
	Local $sSpellName = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtLightningSpells", "Lightning Spell")
	$g_ahPicTrainArmySpell[$eSpellLightning] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnLightSpell, $x, $y + 10, 32, 32)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Level", -1) & " " & $sSpellName & ":" & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Mouse_Left_Click", -1))
	GUICtrlSetOnEvent(-1, "TrainSpellLevelClick")
	$g_ahLblTrainArmySpellLevel[$eSpellLightning] = GUICtrlCreateLabel("0", $x + 2, $y + 29, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$g_ahTxtTrainArmySpellCount[$eSpellLightning] = GUICtrlCreateInput("0", $x + 1, $y + 44, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sSpellName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainSpellCountEdit")

	$x += 37
	; Healing
	Local $sSpellName = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtHealingSpells", "Healing Spell")
	$g_ahPicTrainArmySpell[$eSpellHeal] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnHealSpell, $x, $y + 10, 32, 32)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Level", -1) & " " & $sSpellName & ":" & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Mouse_Left_Click", -1))
	GUICtrlSetOnEvent(-1, "TrainSpellLevelClick")
	$g_ahLblTrainArmySpellLevel[$eSpellHeal] = GUICtrlCreateLabel("0", $x + 2, $y + 29, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$g_ahTxtTrainArmySpellCount[$eSpellHeal] = GUICtrlCreateInput("0", $x + 1, $y + 44, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sSpellName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainSpellCountEdit")

	$x += 37
	; Rage
	Local $sSpellName = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtRageSpells", "Rage Spell")
	$g_ahPicTrainArmySpell[$eSpellRage] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnRageSpell, $x, $y + 10, 32, 32)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Level", -1) & " " & $sSpellName & ":" & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Mouse_Left_Click", -1))
	GUICtrlSetOnEvent(-1, "TrainSpellLevelClick")
	$g_ahLblTrainArmySpellLevel[$eSpellRage] = GUICtrlCreateLabel("0", $x + 2, $y + 29, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$g_ahTxtTrainArmySpellCount[$eSpellRage] = GUICtrlCreateInput("0", $x + 1, $y + 44, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sSpellName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainSpellCountEdit")

	$x += 37
	; Jump
	Local $sSpellName = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtJumpSpells", "Jump Spell")
	$g_ahPicTrainArmySpell[$eSpellJump] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnJumpSpell, $x, $y + 10, 32, 32)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Level", -1) & " " & $sSpellName & ":" & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Mouse_Left_Click", -1))
	GUICtrlSetOnEvent(-1, "TrainSpellLevelClick")
	$g_ahLblTrainArmySpellLevel[$eSpellJump] = GUICtrlCreateLabel("0", $x + 2, $y + 29, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$g_ahTxtTrainArmySpellCount[$eSpellJump] = GUICtrlCreateInput("0", $x + 1, $y + 44, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sSpellName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainSpellCountEdit")

	$x += 37
	; Freeze
	Local $sSpellName = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtFreezeSpells", "Freeze Spell")
	$g_ahPicTrainArmySpell[$eSpellFreeze] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnFreezeSpell, $x, $y + 10, 32, 32)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Level", -1) & " " & $sSpellName & ":" & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Mouse_Left_Click", -1))
	GUICtrlSetOnEvent(-1, "TrainSpellLevelClick")
	$g_ahLblTrainArmySpellLevel[$eSpellFreeze] = GUICtrlCreateLabel("0", $x + 2, $y + 29, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$g_ahTxtTrainArmySpellCount[$eSpellFreeze] = GUICtrlCreateInput("0", $x + 1, $y + 44, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sSpellName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainSpellCountEdit")

	$x += 37
	; Clone
	Local $sSpellName = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtCloneSpells", "Clone Spell")
	$g_ahPicTrainArmySpell[$eSpellClone] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnCloneSpell, $x, $y + 10, 32, 32)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Level", -1) & " " & $sSpellName & ":" & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Mouse_Left_Click", -1))
	GUICtrlSetOnEvent(-1, "TrainSpellLevelClick")
	$g_ahLblTrainArmySpellLevel[$eSpellClone] = GUICtrlCreateLabel("0", $x + 2, $y + 29, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$g_ahTxtTrainArmySpellCount[$eSpellClone] = GUICtrlCreateInput("0", $x + 1, $y + 44, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sSpellName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainSpellCountEdit")

	$x += 42
	; Poison
	Local $sSpellName = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtPoisonSpells", "Poison Spell")
	$g_ahPicTrainArmySpell[$eSpellPoison] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnPoisonSpell, $x, $y + 10, 32, 32)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Level", -1) & " " & $sSpellName & ":" & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Mouse_Left_Click", -1))
	GUICtrlSetOnEvent(-1, "TrainSpellLevelClick")
	$g_ahLblTrainArmySpellLevel[$eSpellPoison] = GUICtrlCreateLabel("0", $x + 2, $y + 29, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$g_ahTxtTrainArmySpellCount[$eSpellPoison] = GUICtrlCreateInput("0", $x + 1, $y + 44, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sSpellName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainSpellCountEdit")

	$x += 37
	; EarthQuake
	Local $sSpellName = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtEarthQuakeSpells", "EarthQuake Spell")
	$g_ahPicTrainArmySpell[$eSpellEarthquake] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnEarthquakeSpell, $x, $y + 10, 32, 32)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Level", -1) & " " & $sSpellName & ":" & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Mouse_Left_Click", -1))
	GUICtrlSetOnEvent(-1, "TrainSpellLevelClick")
	$g_ahLblTrainArmySpellLevel[$eSpellEarthquake] = GUICtrlCreateLabel("0", $x + 2, $y + 29, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$g_ahTxtTrainArmySpellCount[$eSpellEarthquake] = GUICtrlCreateInput("0", $x + 1, $y + 44, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sSpellName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainSpellCountEdit")

	$x += 37
	; Haste
	Local $sSpellName = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtHasteSpells", "Haste Spell")
	$g_ahPicTrainArmySpell[$eSpellHaste] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnHasteSpell, $x, $y + 10, 32, 32)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Level", -1) & " " & $sSpellName & ":" & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Mouse_Left_Click", -1))
	GUICtrlSetOnEvent(-1, "TrainSpellLevelClick")
	$g_ahLblTrainArmySpellLevel[$eSpellHaste] = GUICtrlCreateLabel("0", $x + 2, $y + 29, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$g_ahTxtTrainArmySpellCount[$eSpellHaste] = GUICtrlCreateInput("0", $x + 1, $y + 44, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sSpellName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainSpellCountEdit")

	$x += 37
	; Skeleton
	Local $sSpellName = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtSkeletonSpells", "Skeleton Spell")
	$g_ahPicTrainArmySpell[$eSpellSkeleton] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSkeletonSpell, $x, $y + 10, 32, 32)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Level", -1) & " " & $sSpellName & ":" & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Mouse_Left_Click", -1))
	GUICtrlSetOnEvent(-1, "TrainSpellLevelClick")
	$g_ahLblTrainArmySpellLevel[$eSpellSkeleton] = GUICtrlCreateLabel("0", $x + 2, $y + 29, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$g_ahTxtTrainArmySpellCount[$eSpellSkeleton] = GUICtrlCreateInput("0", $x + 1, $y + 44, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sSpellName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainSpellCountEdit")

	$x += 37
	; Bat
	Local $sSpellName = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtBatSpells", "Bat Spell")
	$g_ahPicTrainArmySpell[$eSpellBat] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBatSpell, $x, $y + 10, 32, 32)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Level", -1) & " " & $sSpellName & ":" & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Mouse_Left_Click", -1))
	GUICtrlSetOnEvent(-1, "TrainSpellLevelClick")
	$g_ahLblTrainArmySpellLevel[$eSpellBat] = GUICtrlCreateLabel("0", $x + 2, $y + 29, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$g_ahTxtTrainArmySpellCount[$eSpellBat] = GUICtrlCreateInput("0", $x + 1, $y + 44, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sSpellName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainSpellCountEdit")

	$y += 52
	$x = 170
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSpellsCost, $x, $y + 10, 24, 24)
	$g_hLblTotalTimeSpell = GUICtrlCreateLabel(" 0s", $x + 28, $y + 15, 70, 15, $SS_RIGHT)
	GUICtrlSetBkColor(-1, $COLOR_GRAY)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_WHITE)
	$g_hLblElixirCostSpell = GUICtrlCreateLabel(" 0", $x + 103, $y + 15, 77, 15, $SS_RIGHT)
	GUICtrlSetBkColor(-1, $COLOR_GRAY)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_WHITE)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 101, $y + 14, 16, 16)
	$g_hLblDarkCostSpell = GUICtrlCreateLabel(" 0", $x + 185, $y + 15, 62, 15, $SS_RIGHT)
	GUICtrlSetBkColor(-1, $COLOR_GRAY)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_WHITE)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 183, $y + 14, 16, 16)


	$x = $iStartX
	$y += 45
	; Battle Blimp
	Local $sSiegeName = GetTranslatedFileIni("MBR Global GUI Design Names Siege Machines", "TxtBattleBlimp", "Battle Blimp")
	$g_ahPicTrainArmySiege[$eSiegeBattleBlimp] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBattleB, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Level", -1) & " " & $sSiegeName & ":" & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Mouse_Left_Click", -1))
	GUICtrlSetOnEvent(-1, "TrainSiegeLevelClick")
	$g_ahLblTrainArmySiegeLevel[$eSiegeBattleBlimp] = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$g_ahTxtTrainArmySiegeCount[$eSiegeBattleBlimp] = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sSiegeName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainSiegeCountEdit")

	$x += 37
	; Wall Wrecker
	Local $sSiegeName = GetTranslatedFileIni("MBR Global GUI Design Names Siege Machines", "TxtWallWrecker", "Wall Wrecker")
	$g_ahPicTrainArmySiege[$eSiegeWallWrecker] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnWallW, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Level", -1) & " " & $sSiegeName & ":" & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Mouse_Left_Click", -1))
	GUICtrlSetOnEvent(-1, "TrainSiegeLevelClick")
	$g_ahLblTrainArmySiegeLevel[$eSiegeWallWrecker] = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$g_ahTxtTrainArmySiegeCount[$eSiegeWallWrecker] = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sSiegeName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainSiegeCountEdit")

	$x += 37
	; Stone Slammer
	Local $sSiegeName = GetTranslatedFileIni("MBR Global GUI Design Names Siege Machines", "TxtStoneSlammer", "Stone Slammer")
	$g_ahPicTrainArmySiege[$eSiegeStoneSlammer] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnStoneS, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Level", -1) & " " & $sSiegeName & ":" & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Mouse_Left_Click", -1))
	GUICtrlSetOnEvent(-1, "TrainSiegeLevelClick")
	$g_ahLblTrainArmySiegeLevel[$eSiegeStoneSlammer] = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$g_ahTxtTrainArmySiegeCount[$eSiegeStoneSlammer] = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sSiegeName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainSiegeCountEdit")

	$x += 37
	; Siege Barracks
	Local $sSiegeName = GetTranslatedFileIni("MBR Global GUI Design Names Siege Machines", "TxtSiegeBarracks", "Siege Barracks")
	$g_ahPicTrainArmySiege[$eSiegeBarracks] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSiegeB, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Level", -1) & " " & $sSiegeName & ":" & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "Mouse_Left_Click", -1))
	GUICtrlSetOnEvent(-1, "TrainSiegeLevelClick")
	$g_ahLblTrainArmySiegeLevel[$eSiegeBarracks] = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$g_ahTxtTrainArmySiegeCount[$eSiegeBarracks] = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sSiegeName & " " & $sTxtSetPerc2)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "TrainSiegeCountEdit")

	$x = 170
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSiegeCost, $x, $y + 5, 24, 24)
	$g_hLblTotalTimeSiege = GUICtrlCreateLabel(" 0s", $x + 28, $y + 10, 70, 15, $SS_RIGHT)
	GUICtrlSetBkColor(-1, $COLOR_GRAY)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_WHITE)
	$g_hLblGoldCostSiege = GUICtrlCreateLabel(" 0", $x + 103, $y + 10, 77, 15, $SS_RIGHT)
	GUICtrlSetBkColor(-1, $COLOR_GRAY)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_WHITE)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 101, $y + 9, 16, 16)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "LblCountTotal", "Total"), $x + 183, $y + 10, -1, -1)
	$g_hLblCountTotalSiege = GUICtrlCreateLabel(0, $x + 210, $y + 10, 30, 15, $SS_CENTER)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "LblCountTotal_Info_02", "The total units of Siege Machines"))
	GUICtrlSetBkColor(-1, $COLOR_MONEYGREEN) ;lime, moneygreen
	GUICtrlCreateLabel("x", $x + 242, $y + 10, -1, -1)

EndFunc   ;==>CreateCustomTrainSubTab

Func CreateTrainBoost()

	Local $sTextBoostLeft = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "TextBoostLeft", "Boosts left")
	Local $sTxtTip = ""

	$g_hGUI_TRAINARMY_BOOST = _GUICreate("", $g_iSizeWGrpTab3, $g_iSizeHGrpTab3, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_TRAINARMY)
	GUISetBkColor($COLOR_WHITE, $g_hGUI_TRAINARMY_BOOST)

	Local $x = 25, $y = 20
	; Army Buildings
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "Group_01", "Boost Army Buildings"), $x - 20, $y - 20, $g_iSizeWGrpTab3, 98)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBarrackBoost, $x - 10, $y - 2, 24, 24)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDarkBarrackBoost, $x + 19, $y - 2, 24, 24)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "LblBarracksBoost", "Barracks") & " " & $sTextBoostLeft, $x + 20 + 29, $y + 4, -1, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "LblBarracksBoost_Info_01", "Use this to boost your Barracks with GEMS! Use with caution!")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hCmbBoostBarracks = GUICtrlCreateCombo("", $x + 185, $y, 60, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|No limit", "0")
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 25
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSpellFactoryBoost, $x - 10, $y - 2, 24, 24)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDarkSpellBoost, $x + 19, $y - 2, 24, 24)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "LblSpellFactoryBoost", "Spell Factory") & " " & $sTextBoostLeft, $x + 20 + 29, $y + 4, -1, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "LblSpellFactoryBoost_Info_01", "Use this to boost your Spell Factory with GEMS! Use with caution!")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hCmbBoostSpellFactory = GUICtrlCreateCombo("", $x + 185, $y, 60, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|No limit", "0")
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 25
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnWorkshopBoost, $x + 5, $y - 2, 24, 24)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "LblWorkshopBoost", "Workshop") & " " & $sTextBoostLeft, $x + 20 + 29, $y + 4, -1, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "LblWorkshopBoost_Info_01", "Use this to boost your Workshop with GEMS! Use with caution!")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hCmbBoostWorkshop = GUICtrlCreateCombo("", $x + 185, $y, 60, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|No limit", "0")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Heroes
	$y += 55
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "Group_02", "Boost Heroes"), $x - 20, $y - 20, $g_iSizeWGrpTab3, 125)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnKingBoost, $x - 10, $y - 2, 24, 24)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design Names Troops", "King", -1) & " " & $sTextBoostLeft, $x + 20, $y + 4, -1, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "LblKingBoost_Info_01", "Use this to boost your Barbarian King with GEMS! Use with caution!")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hCmbBoostBarbarianKing = GUICtrlCreateCombo("", $x + 185, $y, 60, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|No limit", "0")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradeKing")

	$y += 25
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnQueenBoost, $x - 10, $y - 2, 24, 24)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Queen", -1) & " " & $sTextBoostLeft, $x + 20, $y + 4, -1, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "LblQueenBoost_Info_01", "Use this to boost your Archer Queen with GEMS! Use with caution!")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hCmbBoostArcherQueen = GUICtrlCreateCombo("", $x + 185, $y, 60, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|No limit", "0")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradeQueen")

	$y += 25
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnWardenBoost, $x - 10, $y - 2, 24, 24)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Grand Warden", -1) & " " & $sTextBoostLeft, $x + 20, $y + 4, -1, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "LblWardenBoost_Info_01", "Use this to boost your Grand Warden with GEMS! Use with caution!")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hCmbBoostWarden = GUICtrlCreateCombo("", $x + 185, $y, 60, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|No limit", "0")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradeWarden")

	$y += 25
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnChampionBoost, $x - 10, $y - 2, 24, 24)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Royal Champion", -1) & " " & $sTextBoostLeft, $x + 20, $y + 4, -1, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "LblChampionBoost_Info_01", "Use this to boost your Royal Champion with GEMS! Use with caution!")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hCmbBoostChampion = GUICtrlCreateCombo("", $x + 185, $y, 60, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|No limit", "0")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradeChampion")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 55
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "Group_03", "Boost Everything"), $x - 20, $y - 20, $g_iSizeWGrpTab3, 48)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBoostPotion, $x - 10, $y - 2, 24, 24)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Potion", -1) & " " & $sTextBoostLeft, $x + 20, $y + 4, -1, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "LblEverythingBoost_Info_01", "Use this to boost everything with POTIONS! Use with caution!")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hCmbBoostEverything = GUICtrlCreateCombo("", $x + 185, $y, 60, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0|1|2|3|4|5", "0")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 55
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Boost", "Group_04", "Boost Schedule"), $x - 20, $y - 20, $g_iSizeWGrpTab3, 75)

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

EndFunc   ;==>CreateTrainBoost

Func CreateTrainOrder()

	$g_hGUI_TRAINARMY_TRAINORDER = _GUICreate("", $g_iSizeWGrpTab3, $g_iSizeHGrpTab3, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_TRAINARMY)
	GUISetBkColor($COLOR_WHITE, $g_hGUI_TRAINARMY_TRAINORDER)

	SetDefaultTroopGroup(False)
	LoadTranslatedTrainTroopsOrderList()
	LoadTranslatedBrewSpellsOrderList()

	Local $x = 25, $y = 20
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_TrainingOrder", "Group_01", "Training Order"), $x - 20, $y - 20, $g_iSizeWGrpTab3, $g_iSizeHGrpTab3)
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
	$y += 23
	For $z = 0 To $eTroopCount - 1
		If $z < 11 Then
			GUICtrlCreateLabel($z + 1 & ":", $x - 16, $y + 2, -1, 18)
			$g_ahCmbTroopOrder[$z] = GUICtrlCreateCombo("", $x, $y, 94, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetOnEvent(-1, "GUITrainOrder")
			GUICtrlSetData(-1, $sComboData, "")
			_GUICtrlSetTip(-1, $txtTroopOrder & $z + 1)
			GUICtrlSetState(-1, $GUI_DISABLE)
			$g_ahImgTroopOrder[$z] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnOptions, $x + 96, $y + 1, 18, 18)
			$y += 22 ; move down to next combobox location
		Else
			If $z = 11 Then
				$x += 128
				$y = 20 + 23
			EndIf
			GUICtrlCreateLabel($z + 1 & ":", $x - 13, $y + 2, -1, 18)
			$g_ahCmbTroopOrder[$z] = GUICtrlCreateCombo("", $x + 4, $y, 94, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetOnEvent(-1, "GUITrainOrder")
			GUICtrlSetData(-1, $sComboData, "")
			_GUICtrlSetTip(-1, $txtTroopOrder & $z + 1)
			GUICtrlSetState(-1, $GUI_DISABLE)
			$g_ahImgTroopOrder[$z] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnOptions, $x + 100, $y + 1, 18, 18)
			$y += 22 ; move down to next combobox location
		EndIf
	Next
	$y += 23
	$g_hBtnRemoveTroops = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_TrainingOrder", "BtnRemoveTroops", "Empty troop list"), $x, $y, 110, 22)
	GUICtrlSetState(-1, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_TrainingOrder", "BtnRemoveTroops_Info_01", "Push button to remove all troops from list and start over"))
	GUICtrlSetOnEvent(-1, "btnRemoveTroops")

	$x = 25
	$y = 42 + 291
	; Create push button to set training order once completed
	$g_hBtnTroopOrderSet = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_TrainingOrder", "BtnTroopOrderSet", "Apply New Order"), $x, $y, 222, 20)
	GUICtrlSetState(-1, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_TrainingOrder", "BtnTroopOrderSet_Info_01", "Push button when finished selecting custom troop training order") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_TrainingOrder", "BtnTroopOrderSet_Info_02", "Icon changes color based on status: Red= Not Set, Green = Order Set") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_TrainingOrder", "BtnTroopOrderSet_Info_03", "When not all troop slots are filled, will use random troop order in empty slots!"))
	GUICtrlSetOnEvent(-1, "btnTroopOrderSet")
	$g_ahImgTroopOrderSet = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSilverStar, $x + 226, $y + 2, 18, 18)

	; Brew Spells Order  [641] 49 last
	Local $x = 300, $y = 20
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
	$y += 23
	For $z = 0 To $eSpellCount - 1
		GUICtrlCreateLabel($z + 1 & ":", $x - 16, $y + 2, -1, 18)
		$g_ahCmbSpellsOrder[$z] = GUICtrlCreateCombo("", $x, $y, 94, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetOnEvent(-1, "GUISpellsOrder")
		GUICtrlSetData(-1, $sComboData, "")
		_GUICtrlSetTip(-1, $txtSpellsOrder & $z + 1)
		GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahImgSpellsOrder[$z] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnOptions, $x + 96, $y + 1, 18, 18)
		$y += 22 ; move down to next combobox location
	Next
	$y += 20
	$g_hBtnRemoveSpells = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_TrainingOrder", "BtnRemoveSpells", "Empty Spell list"), $x, $y, 94, 22)
	GUICtrlSetState(-1, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_TrainingOrder", "BtnRemoveSpells_Info_01", "Push button to remove all spells from list and start over"))
	GUICtrlSetOnEvent(-1, "BtnRemoveSpells")
	$y += 25
	$g_hBtnSpellsOrderSet = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_TrainingOrder", "BtnSpellsOrderSet", "Apply New Order"), $x, $y, 94, 22)
	GUICtrlSetState(-1, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_TrainingOrder", "BtnSpellsOrderSet_Info_01", "Push button when finished selecting custom spells brew order") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_TrainingOrder", "BtnSpellsOrderSet_Info_02", "Icon changes color based on status: Red= Not Set, Green = Order Set") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_TrainingOrder", "BtnSpellsOrderSet_Info_03", "When not all spells slots are filled, will use random spell order in empty slots!"))
	GUICtrlSetOnEvent(-1, "BtnSpellsOrderSet")
	$g_ahImgSpellsOrderSet = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSilverStar, $x + 98, $y + 2, 18, 18)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateTrainOrder

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
