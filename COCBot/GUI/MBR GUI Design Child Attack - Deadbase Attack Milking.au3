; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Milking Attack" tab under the "Attack" tab under the "DeadBase" tab under the "Search & Attack" tab under the "Attack Plan" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_DEADBASE_ATTACK_MILKING = 0

; Tab A
Global $g_hCmbMilkAttackType = 0, $g_hCmbMilkLvl[13] = [-1, -1, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0] ; Elements 0 to 3 are never referenced

; Tab B
Global $g_hChkAtkElixirExtractors = 0, $g_hChkAtkGoldMines = 0, $g_hCmbAtkGoldMinesLevel = 0, $g_hChkAtkDarkDrills = 0, $g_hCmbAtkDarkDrillsLevel = 0
Global $g_hCmbRedlineResDistance = 0, $g_hChkAttackMinesIfGold = 0, $g_hTxtAttackMinesIfGold = 0, $g_hChkAttackMinesIfElixir = 0, $g_hTxtAttackMinesIfElixir = 0, _
	   $g_hChkAttackMinesIfDarkElixir = 0, $g_hTxtAttackMinesIfDarkElixir = 0

; Tab C
Global $g_hTxtLowerXWave = 0, $g_hTxtUpperXWave = 0, $g_hTxtMaxWaves = 0, $g_hTxtLowerDelayWaves = 0, $g_hTxtUpperDelayWaves = 0
Global $g_hCmbMilkingAttackDropGoblinAlgorithm = 0, $g_hCmbStructureOrder = 0
Global $g_hChkStructureDestroyedBeforeAttack = 0, $g_hChkStructureDestroyedAfterAttack = 0

; Tab D
Global $g_hChkMilkAfterAttackTHSnipe = 0, $g_hTxtMaxTilesMilk = 0, $g_hCmbMilkSnipeAlgorithm = 0, $g_hChkSnipeIfNoElixir = 0, $g_hChkMilkAfterAttackScripted = 0, _
	   $g_hCmbMilkingCSVScriptName = 0
Global $g_hGrpSnipeOutsideTHAtEnd = 0, $g_hGrpDeploy = 0, $g_hLblMilkingCSVNotesScript = 0

; Tab Advanced
Global $g_hChkMilkFarmForceTolerance = 0, $g_hTxtMilkFarmForceToleranceNormal = 0, $g_hTxtMilkFarmForceToleranceBoosted = 0, $g_hTxtMilkFarmForceToleranceDestroyed = 0
Global $g_hGrpMilkingDebug = 0, $g_hChkMilkingDebugIMG = 0, $g_hChkMilkingDebugVillage = 0, $g_hChkMilkingDebugFullSearch = 0


Func CreateAttackSearchDeadBaseMilking()

	$g_hGUI_DEADBASE_ATTACK_MILKING = _GUICreate("", $_GUI_MAIN_WIDTH - 195, $g_iSizeHGrpTab4, 150, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_DEADBASE)
	;GUISetBkColor($COLOR_WHITE, $g_hGUI_DEADBASE_ATTACK_MILKING)

	Local $sTxtDisable = GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "TxtDisable", "DIS.")

	; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	; TAB A
	; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	Local $x = 5, $y = 0
	GUICtrlCreateTab($x, $y, 268, 306, $TCS_MULTILINE)
	GUICtrlCreateTabItem(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Algorithm_Item_03_SubItem_01", "A - Structures"))
		Local $x = 15, $y = 45
		GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "Group_01", "Choose Milking Search Type"), $x - 5, $y - 5, 260, 45)
		$y += 15
			$g_hCmbMilkAttackType = GUICtrlCreateCombo("", $x, $y, 250, 20,BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "CmbMilkAttackType_Item_01", "Slower: Check the Resources in each collector.") & "|" &  _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "CmbMilkAttackType_Item_02", "Faster: Only check the Level of each collector."), GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "CmbMilkAttackType_Item_02", -1))
		$y += 30
		GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "Group_02", "Elixir Collectors Min. Level to Attack"), $x - 5, $y, 210, 145)
		$y += 20
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "CmbMilkLvl_01", "Levels 1-4"), $x, $y)
			$g_hCmbMilkLvl[4] = GUICtrlCreateCombo("", $x, $y + 16, 65, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, $sTxtDisable & "|0-4%|5-19%|20-74%|75-89%|90-100%", $sTxtDisable)
		$x += 67
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "CmbMilkLvl_05", "Level 5"), $x, $y)
			$g_hCmbMilkLvl[5] = GUICtrlCreateCombo("", $x, $y + 16, 65, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, $sTxtDisable & "|0-4%|5-19%|20-74%|75-89%|90-100%", $sTxtDisable)
		$x += 67
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "CmbMilkLvl_06", "Level 6"), $x, $y)
			$g_hCmbMilkLvl[6] = GUICtrlCreateCombo("", $x, $y + 16, 65, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, $sTxtDisable & "|0-4%|5-19%|20-74%|75-89%|90-100%", $sTxtDisable)
		$x = 15
		$y += 40
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "CmbMilkLvl_07", "Level 7"), $x, $y)
			$g_hCmbMilkLvl[7] = GUICtrlCreateCombo("", $x, $y + 16, 65, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, $sTxtDisable & "|0-4%|5-19%|20-74%|75-89%|90-100%", $sTxtDisable)
		$x += 67
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "CmbMilkLvl_08", "Level 8"), $x, $y)
			$g_hCmbMilkLvl[8] = GUICtrlCreateCombo("", $x, $y + 16, 65, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, $sTxtDisable & "|0-4%|5-19%|20-74%|75-89%|90-100%", $sTxtDisable)
		$x += 67
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "CmbMilkLvl_09", "Level 9"), $x, $y)
			$g_hCmbMilkLvl[9] = GUICtrlCreateCombo("", $x, $y + 16, 65, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, $sTxtDisable & "|0-4%|5-19%|20-74%|75-89%|90-100%", $sTxtDisable)
		$x = 15
		$y += 40
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "CmbMilkLvl_10", "Level 10"), $x, $y)
			$g_hCmbMilkLvl[10] = GUICtrlCreateCombo("", $x, $y + 16, 65, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, $sTxtDisable & "|0-4%|5-19%|20-74%|75-89%|90-100%", "5-19%")
		$x += 67
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "CmbMilkLvl_11", "Level 11"), $x, $y)
			$g_hCmbMilkLvl[11] = GUICtrlCreateCombo("", $x, $y + 16, 65, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, $sTxtDisable & "|0-4%|5-19%|20-74%|75-89%|90-100%", "5-19%")
		$x += 67
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "CmbMilkLvl_12", "Level 12"), $x, $y)
			$g_hCmbMilkLvl[12] = GUICtrlCreateCombo("", $x, $y + 16, 65, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, $sTxtDisable & "|0-4%|5-19%|20-74%|75-89%|90-100%", "5-19%")
		GUICtrlCreateGroup("", -99, -99, 1, 1)

		Local $x = 10, $y = 240
		GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "Group_03", "Legend"), $x, $y, 260, 65)
		$x = 23
		$y = 255
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "CapacityStructure_01", "0-4%"), $x, $y)
		$x = 21
		$y = 273
			_GUICtrlCreatePic(@ScriptDir & "\Images\CapacityStructure\elixir_8_0_70_A.bmp", $x, $y, 25, 25)

		$x = 65
		$y = 255
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "CapacityStructure_02", "5-19%"), $x, $y)
		$x = 66
		$y = 273
			_GUICtrlCreatePic(@ScriptDir & "\Images\CapacityStructure\elixir_8_1_70_A.bmp", $x, $y, 25, 25)

		$x = 117
		$y = 255
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "CapacityStructure_03", "20-74%"), $x, $y)
		$x = 121
		$y = 273
			_GUICtrlCreatePic(@ScriptDir & "\Images\CapacityStructure\elixir_8_2_70_A.bmp", $x, $y, 25, 25)

		$x = 173
		$y = 255
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "CapacityStructure_04", "75-89%"), $x, $y)
		$x = 176
		$y = 273
			_GUICtrlCreatePic(@ScriptDir & "\Images\CapacityStructure\elixir_8_3_70_A.bmp", $x, $y, 25, 25)

		$x = 224
		$y = 255
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "CapacityStructure_05", "90-100%"), $x, $y)
		$x = 232
		$y = 273
			_GUICtrlCreatePic(@ScriptDir & "\Images\CapacityStructure\elixir_8_4_70_A.bmp", $x, $y, 25, 25)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateTabItem("")

	; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	; TAB B
	; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	GUICtrlCreateTabItem( GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Algorithm_Item_03_SubItem_02", "B - Conditions"))
		Local $x = 14, $y = 45
		GUICtrlCreateGroup( GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "Group_04", "Structures to Attack"), $x - 5, $y, 260, 100)
		$y += 22
			$g_hChkAtkElixirExtractors = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "ChkAtkGEDExtractors", "Attack"), $x, $y, -1, 18)
				GUICtrlSetState(-1, $GUI_CHECKED)
			_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 55, $y - 6, 24, 24)

		$y += 26
			$g_hChkAtkGoldMines = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "ChkAtkGEDExtractors", -1), $x, $y, -1, 18)
				GUICtrlSetState(-1, $GUI_CHECKED)
				GUICtrlSetOnEvent(-1, "chkAtkGoldMines")
			_GUICtrlCreateIcon($g_sLibIconPath, $eIcnMine, $x + 55, $y - 6, 24, 24)
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "LblWhichLevel", "Which have a Level") & " " & ChrW(8805), $x + 75, $y + 2, 115, 18, $SS_RIGHT)
			$g_hCmbAtkGoldMinesLevel = GUICtrlCreateCombo("", $x + 200, $y - 2, 50, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, "1-4|5|6|7|8|9|10|11", "5")

		$y += 26
			$g_hChkAtkDarkDrills = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "ChkAtkGEDExtractors", -1), $x, $y, -1, 18)
				GUICtrlSetOnEvent(-1, "chkAtkDarkDrills")
				GUICtrlSetState(-1, $GUI_CHECKED)
			_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDrill, $x + 55, $y - 6, 24, 24)
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "LblWhichLevel", -1) & " " & ChrW(8805), $x + 75, $y + 2, 115, 18, $SS_RIGHT)
			$g_hCmbAtkDarkDrillsLevel = GUICtrlCreateCombo("", $x + 200, $y - 2, 50, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, "1|2|3|4|5|6", "1")
		GUICtrlCreateGroup("", -99, -99, 1, 1)

		Local $x = 14, $y = 155
		GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "Group_05", "Only Attack If"), $x - 5, $y - 5, 260, 110)
		$y += 15
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "LblRedline-and-Collectors", "Distance between red line and collectors"), $x, $y)
			$g_hCmbRedlineResDistance = GUICtrlCreateCombo("", $x + 200, $y - 4, 50, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, "0 tile|1 tile|2 tiles", "0 tile")

		$y += 21
			$g_hChkAttackMinesIfGold = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "ChkAttackMinesIfGold", "Attack Gold Mines If Gold Under"), $x, $y)
				GUICtrlSetOnEvent(-1, "chkAttackMinesifGold")
				GUICtrlSetState(-1, $GUI_CHECKED)
			$g_hTxtAttackMinesIfGold = GUICtrlCreateInput("9950000", $x + 200, $y, 50, 18, $SS_CENTER)
				GUICtrlSetState(-1,$GUI_DISABLE)
				GUICtrlSetLimit(-1, 7)

		$y += 21
			$g_hChkAttackMinesIfElixir = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "ChkAttackMinesIfElixir", "Attack Elixir Collectors If Elixir Under"), $x, $y)
				GUICtrlSetOnEvent(-1, "chkAttackMinesifElixir")
				GUICtrlSetState(-1, $GUI_CHECKED)
			$g_hTxtAttackMinesIfElixir = GUICtrlCreateInput("9950000", $x + 200, $y, 50, 18, $SS_CENTER)
				GUICtrlSetState(-1,$GUI_DISABLE)
				GUICtrlSetLimit(-1, 7)

		$y += 21
			$g_hChkAttackMinesIfDarkElixir = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "ChkAttackMinesIfDarkElixir", "Attack Dark Elixir Drills If Dark Under"), $x, $y)
				GUICtrlSetOnEvent(-1, "chkAttackMinesifDarkElixir")
				GUICtrlSetState(-1, $GUI_CHECKED)
			$g_hTxtAttackMinesIfDarkElixir = GUICtrlCreateInput("200000", $x + 200, $y, 50, 18, $SS_CENTER)
				GUICtrlSetState(-1,$GUI_DISABLE)
				GUICtrlSetLimit(-1, 6)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateTabItem("")

	; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	; TAB C
	; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	GUICtrlCreateTabItem(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Algorithm_Item_03_SubItem_03", "C - Attack"))
		Local $x = 9
		Local $y = 45
		GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "Group_06", "4. Troops To Use For Each Building"), $x, $y, 260, 90)
		$x = 15
		$y += 20
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "TxtXWave", "- Troops Per Wave:"), $x, $y)
			$g_hTxtLowerXWave = GUICtrlCreateInput("4", 180 - 10, $y - 3, 35, 18, $SS_CENTER)
				GUICtrlSetLimit(-1, 2)
				GUICtrlCreateLabel("-", 213, $y)
			$g_hTxtUpperXWave = GUICtrlCreateInput("6", 245 - 20, $y - 3, 35, 18, $SS_CENTER)
				GUICtrlSetLimit(-1, 2)

		$y += 20
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "TxtMaxWaves",  "- Max Waves:"), $x, $y)
			$g_hTxtMaxWaves = GUICtrlCreateInput("3", 180 - 10, $y - 3, 35, 18, $SS_CENTER)
				GUICtrlSetLimit(-1, 2)
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "TxtMaxWaves_Info_01", "Choose the maximum number of waves of troops to drop at each collector.") & @CRLF & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "TxtMaxWaves_Info_02", "If the collector gets destroyed, then no more waves will be dropped at it."))

		$y += 20
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "TxtDelayWaves", "- Delay Between Waves (ms):"), $x, $y)
			$g_hTxtLowerDelayWaves = GUICtrlCreateInput("3000", 180 - 10, $y - 3, 35, 18, $SS_CENTER)
				GUICtrlSetLimit(-1, 5)
				GUICtrlCreateLabel("-", 213, $y)
			$g_hTxtUpperDelayWaves = GUICtrlCreateInput("5000", 245 - 20, $y - 3, 35, 18, $SS_CENTER)
				GUICtrlSetLimit(-1, 5)
		GUICtrlCreateGroup("", -99, -99, 1, 1)

		$x = 9
		$y += 40
		GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "Group_07", "5. Dropping options"), $x, $y, 260, 80)
		$y += 21
			$g_hCmbMilkingAttackDropGoblinAlgorithm = GUICtrlCreateCombo("", $x + 5, $y, 250, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "CmbMilkingAttackDropGoblinAlgorithm_Item_01", "Drop each Goblin in the same place") & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "CmbMilkingAttackDropGoblinAlgorithm_Item_02", "Drop each Goblin in a different place"), GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "CmbMilkingAttackDropGoblinAlgorithm_Item_01", -1))

		$y += 25
			$g_hCmbStructureOrder = GUICtrlCreateCombo("", $x + 5, $y, 250, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "CmbStructureOrder_Item_01", "Attack Order: as found") & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "CmbStructureOrder_Item_02", "Attack Order: Random") & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "CmbStructureOrder_Item_03", "Attack Order: by side"), GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "CmbStructureOrder_Item_03", -1))
		GUICtrlCreateGroup("", -99, -99, 1, 1)

		$x = 9
		$y += 40
		GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "Group_08", "Check Destroyed Structures"), $x, $y, 260, 70)
		$y += 20
		$x += 5
			$g_hChkStructureDestroyedBeforeAttack = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "ChkStructureDestroyedBeforeAttack", "Check Structure Destruction Before Wave"), $x, $y)
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "ChkStructureDestroyedBeforeAttack_Info_01", "Before attacking a structure, check to see if it has been destroyed by another wave.") & @CRLF & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "ChkStructureDestroyedBeforeAttack_Info_02", "You must have a high delay between waves to use this option"))

		$y += 20
			$g_hChkStructureDestroyedAfterAttack = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "ChkStructureDestroyedAfterAttack", "Check Structure Destruction After Wave"), $x, $y)
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "ChkStructureDestroyedAfterAttack_Info_01", "After attacking a structure, check to see if it has been destroyed by another wave.") & @CRLF & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "ChkStructureDestroyedAfterAttack_Info_02", "You must have a high delay between waves to use this option"))
		GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateTabItem("")

	; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	; TAB D
	; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	GUICtrlCreateTabItem(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Algorithm_Item_03_SubItem_04", "D - After Milking"))
		Local $x = 9
		Local $y = 45
		$g_hGrpSnipeOutsideTHAtEnd = GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "Group_09", "5a. Snipe Outside TH After Milking"), $x, $y - 4, 260, 120)
		$x = 15
		$y+= 15
			$g_hChkMilkAfterAttackTHSnipe = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "ChkMilkAfterAttackTHSnipe", "Enable TH Snipe"), $x, $y, -1, -1)
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "ChkMilkAfterAttackTHSnipe", -1))
				GUICtrlSetOnEvent(-1, "chkMilkAfterAttackTHSnipe")

		$y += 21
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "LblMaxTilesMilk", "Max Tiles From Border") & ":", $x, $y)
				GUICtrlSetState(-1, $GUI_DISABLE)
			$g_hTxtMaxTilesMilk = GUICtrlCreateInput("1", $x + 115, $y - 3, 30, 18, $SS_CENTER)
				GUICtrlSetLimit(-1, 2)
				GUICtrlSetState(-1, $GUI_DISABLE)

		$y += 20
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "LblMilkSnipeAlgorithm", "Use Algorithm") & ":", $x, $y)
				GUICtrlSetState(-1, $GUI_DISABLE)
			$g_hCmbMilkSnipeAlgorithm = GUICtrlCreateCombo("", 130, $y - 2, 133, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetState(-1, $GUI_DISABLE)
			PopulateCmbMilkSnipeAlgorithm()
			_GUICtrlComboBox_SetCurSel($g_hCmbMilkSnipeAlgorithm, _GUICtrlComboBox_FindStringExact($g_hCmbMilkSnipeAlgorithm, "Queen&GobTakeTH"))

		$y += 20
			$g_hChkSnipeIfNoElixir = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "ChkSnipeIfNoElixir", "Snipe Even If No Collectors can be Milked"), $x, $y)
				GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateGroup("", -99, -99, 1, 1)

		$x = 9
		$y += 85
		Local $mode = $DB
		$g_hGrpDeploy = GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "Group_10", "5b. Continue With An Scripted Attack"), $x , $y - 20, 260, 70)
		$x += 15
			$g_hChkMilkAfterAttackScripted = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "ChkMilkAfterAttackScripted", "Enable Scripted Attack"), $x, $y, -1, -1)
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "ChkMilkAfterAttackScripted",  "Enable Scripted Attack"))
				;GUICtrlSetOnEvent(-1, "chkMilkAfterAttackStandard")

		$y += 21
			$g_hCmbMilkingCSVScriptName = GUICtrlCreateCombo("", $x - 10 , $y, 250, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "ChkMilkAfterAttackScripted_Info_02", "Use scripted attack for dead bases, this disables standard attack"))
			PopulateComboMilkingCSVScriptsFiles()
			_GUICtrlComboBox_SetCurSel($g_hCmbMilkingCSVScriptName, _GUICtrlComboBox_FindStringExact($g_hCmbMilkingCSVScriptName, "Barch four fingers"))

		$y += 25
			$g_hLblMilkingCSVNotesScript = GUICtrlCreateLabel("", $x, $y + 5, 180, 118)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateTabItem("")

	; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	; TAB Advanced
	; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	GUICtrlCreateTabItem(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Algorithm_Item_03_SubItem_05", "Advanced"))
		Local $x = 9
		Local $y = 45
		$y += 21
		GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "Group_11", "Tolerance Settings"), $x, $y, 260, 120)
		$x += 5
		$y += 21
			$g_hChkMilkFarmForceTolerance = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "ChkMilkFarmForceTolerance", "Force Tolerance"), $x, $y)
				GUICtrlSetOnEvent(-1,"chkMilkFarmForcetolerance")

		$y += 21
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "ChkMilkFarmForceTolerance_Info_01", "Tolerance Normal"), $x, $y)
			$g_hTxtMilkFarmForceToleranceNormal = GUICtrlCreateInput("60", 235 - 31, $y - 3, 60 - 8, 20, $SS_CENTER)
				GUICtrlSetLimit(-1, 4)
				GUICtrlSetState(-1, $GUI_DISABLE)

		$y += 21
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "ChkMilkFarmForceTolerance_Info_02", "Tolerance Boosted"), $x, $y)
			$g_hTxtMilkFarmForceToleranceBoosted = GUICtrlCreateInput("60", 235 - 31, $y - 3, 60 - 8, 20, $SS_CENTER)
				GUICtrlSetLimit(-1, 4)
				GUICtrlSetState(-1, $GUI_DISABLE)

		$y += 21
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "ChkMilkFarmForceTolerance_Info_03", "Tolerance Destroyed"), $x, $y)
			$g_hTxtMilkFarmForceToleranceDestroyed = GUICtrlCreateInput("60", 235 - 31, $y - 3, 60 - 8, 20, $SS_CENTER)
				GUICtrlSetLimit(-1, 4)
				GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateGroup("", -99, -99, 1, 1)

		$x = 9
		$y += 50
		$g_hGrpMilkingDebug = GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "Group_12", "Debug"), $x, $y, 260, 100)
			GUICtrlSetState(-1, $GUI_HIDE)
		$y += 20
		$x += 5
			$g_hChkMilkingDebugIMG = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "ChkMilkingDebugIMG", "Make Images of each extractor with offset"), $x, $y)
				GUICtrlSetState(-1, $GUI_HIDE)

		$y += 20
			$g_hChkMilkingDebugVillage = GUICtrlCreateCheckbox( GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "ChkMilkingDebugVillage", "Make Images of villages"), $x, $y)
				GUICtrlSetState(-1, $GUI_HIDE)

		$y += 20
			$g_hChkMilkingDebugFullSearch = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "ChkMilkingDebugFullSearch", "fullsearch, only for debug purpose (very slow)"), $x, $y)
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase Attack Milking", "ChkMilkingDebugFullSearch_Info_01", "with this options you can detect images of undetected Elixir Extractors"))
				GUICtrlSetState(-1, $GUI_HIDE)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateTabItem("")

EndFunc   ;==>CreateAttackSearchDeadBaseMilking
