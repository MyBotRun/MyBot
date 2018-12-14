; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Attack" tab under the "DeadBase" tab under the "Search & Attack" tab under the "Attack Plan" tab
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

; Attack with
Global $g_hCmbDBAlgorithm = 0, $g_hCmbDBSelectTroop = 0, $g_hChkDBKingAttack = 0, $g_hChkDBQueenAttack = 0, $g_hChkDBWardenAttack = 0, $g_hChkDBDropCC = 0
Global $g_hChkDBLightSpell = 0, $g_hChkDBHealSpell = 0, $g_hChkDBRageSpell = 0, $g_hChkDBJumpSpell = 0, $g_hChkDBFreezeSpell = 0, $g_hChkDBCloneSpell = 0, _
	   $g_hChkDBPoisonSpell = 0, $g_hChkDBEarthquakeSpell = 0, $g_hChkDBHasteSpell = 0, $g_hChkDBSkeletonSpell = 0, $g_hChkDBBatSpell = 0

Global $g_hPicDBKingAttack = 0, $g_hPicDBQueenAttack = 0, $g_hPicDBWardenAttack = 0, $g_hPicDBDropCC = 0
Global $g_hPicDBLightSpell = 0, $g_hPicDBHealSpell = 0, $g_hPicDBRageSpell = 0, $g_hPicDBJumpSpell = 0, $g_hPicDBFreezeSpell = 0, $g_hPicDBCloneSpell = 0, _
	   $g_hPicDBPoisonSpell = 0, $g_hPicDBEarthquakeSpell = 0, $g_hPicDBHasteSpell = 0, $g_hPicDBSkeletonSpell = 0, $g_hPicDBBatSpell = 0

; TH Snipe
Global $g_hChkTHSnipeBeforeDBEnable = 0, $g_hTxtTHSnipeBeforeDBTiles = 0, $g_hCmbTHSnipeBeforeDBScript = 0
Global $g_hLblTHSnipeBeforeDBTiles = 0

Global $g_hCmbDBSiege = 0

Func CreateAttackSearchDeadBaseAttack()
	Local $sTxtTip = ""
	Local $x = 25, $y = 40
		GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Group_01", "Attack with"), $x - 20, $y - 15, 145, 223)
		$x -= 15
		$y += 5
			$g_hCmbDBAlgorithm = GUICtrlCreateCombo("", $x, $y, 135, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				_GUICtrlSetTip(-1, "")
				GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Algorithm_Item_01", "Standard Attack") & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Algorithm_Item_02", "Scripted Attack") & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Algorithm_Item_03", "Milking Attack") & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Algorithm_Item_04", "SmartFarm Attack"), GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Algorithm_Item_01", -1))
				GUICtrlSetOnEvent(-1, "cmbDBAlgorithm")

		$y += 30
			$g_hCmbDBSelectTroop = GUICtrlCreateCombo("", $x, $y, 135, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-SelectTroop_Item_01", "Use All Troops") & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-SelectTroop_Item_02", "Use Troops in Barracks") & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-SelectTroop_Item_03", "Barb Only") & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-SelectTroop_Item_04", "Arch Only") & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-SelectTroop_Item_05", "B+A") & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-SelectTroop_Item_06", "B+Gob") & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-SelectTroop_Item_07", "A+Gob") & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-SelectTroop_Item_08", "B+A+Gi") & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-SelectTroop_Item_09", "B+A+Gob+Gi") & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-SelectTroop_Item_10", "B+A+Hog Rider") & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-SelectTroop_Item_11", "B+A+Minion"), GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-SelectTroop_Item_01", -1))
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-SelectTroop_Info_01", "Select the troops to use in attacks"))

		$y += 30
			$g_hPicDBKingAttack = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnKing, $x , $y, 24, 24)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-King_Info_01", "Use your King when Attacking...") & @CRLF & _
						   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-King_Info_02", "Enabled with TownHall 7 and higher")
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hChkDBKingAttack = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
				_GUICtrlSetTip(-1, $sTxtTip)

		$x += 46
			$g_hPicDBQueenAttack = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnQueen, $x, $y, 24, 24)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Queen_Info_01", "Use your Queen when Attacking...") & @CRLF & _
						   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Queen_Info_02", "Enabled with TownHall 9 and higher")
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hChkDBQueenAttack = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
				_GUICtrlSetTip(-1, $sTxtTip)

		$x += 46
			$g_hPicDBWardenAttack = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnWarden, $x, $y, 24, 24)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Warden_Info_01", "Use your Warden when Attacking...") & @CRLF & _
						   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Warden_Info_02", "Enabled with Townhall 11")
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hChkDBWardenAttack = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
				_GUICtrlSetTip(-1, $sTxtTip)

		$y += 27
		$x -= 92
			$g_hPicDBDropCC = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnCC, $x, $y, 24, 24)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Clan Castle_Info_01", "Drop your Clan Castle in battle if it contains troops.")
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hChkDBDropCC = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
				_GUICtrlSetTip(-1, $sTxtTip)

		$x += 46
			$g_hPicDBLightSpell = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnLightSpell, $x, $y, 24, 24)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Light_Info_01", "Use your Light Spells when Attacking...")
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hChkDBLightSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
				_GUICtrlSetTip(-1, $sTxtTip)

		$x += 46
			$g_hPicDBHealSpell = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnHealSpell, $x, $y, 24, 24)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Healing_Info_01", "Use your Healing Spells when Attacking...")
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hChkDBHealSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
				_GUICtrlSetTip(-1, $sTxtTip)

		$y += 27
		$x -= 92
			$g_hPicDBRageSpell = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnRageSpell, $x, $y, 24, 24)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Rage_Info_01", "Use your Rage Spells when Attacking...")
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hChkDBRageSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
				_GUICtrlSetTip(-1, $sTxtTip)

		$x += 46
			$g_hPicDBJumpSpell = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnJumpSpell, $x, $y, 24, 24)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Jump_Info_01", "Use your Jump Spells when Attacking...")
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hChkDBJumpSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
				_GUICtrlSetTip(-1, $sTxtTip)

		$x += 46
			$g_hPicDBFreezeSpell = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnFreezeSpell, $x, $y, 24, 24)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Freeze_Info_01", "Use your Freeze Spells when Attacking...")
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hChkDBFreezeSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
				_GUICtrlSetTip(-1, $sTxtTip)

		$y += 27
		$x -= 92
			$g_hPicDBCloneSpell = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnCloneSpell, $x, $y, 24, 24)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Clone_Info_01", "Use your Clone Spells when Attacking...")
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hChkDBCloneSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
				_GUICtrlSetTip(-1, $sTxtTip)

		$x += 46
			$g_hPicDBPoisonSpell = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnPoisonSpell, $x, $y, 24, 24)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Poison_Info_01", "Use your Poison Spells when Attacking...")
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hChkDBPoisonSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
				_GUICtrlSetTip(-1, $sTxtTip)

		$x += 46
			$g_hPicDBEarthquakeSpell = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnEarthquakeSpell, $x, $y, 24, 24)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Earthquake_Info_01", "Use your Earthquake Spells when Attacking...")
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hChkDBEarthquakeSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
				_GUICtrlSetTip(-1, $sTxtTip)

		$y += 27
		$x -= 92
			$g_hPicDBHasteSpell = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnHasteSpell, $x, $y, 24, 24)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Haste_Info_01", "Use your Haste Spells when Attacking...")
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hChkDBHasteSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
				_GUICtrlSetTip(-1, $sTxtTip)

		$x += 46
			$g_hPicDBSkeletonSpell = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSkeletonSpell, $x, $y, 24, 24)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Skeleton_Info_01", "Use your Bats Spells when Attacking...")
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hChkDBSkeletonSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
				_GUICtrlSetTip(-1, $sTxtTip)
				
		$x += 46
			$g_hPicDBBatSpell = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBatSpell, $x, $y, 24, 24)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Bat_Info_01", "Use your Bats Spells when Attacking...")
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hChkDBBatSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
				_GUICtrlSetTip(-1, $sTxtTip)		
		GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 10, $y = 268
		GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Group_02", "TH Snipe"), $x - 5, $y - 20, 145, 84, $SS_CENTER)
			$g_hChkTHSnipeBeforeDBEnable = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "ChkTHSnipeBeforeEnable", "Snipe TH External first"), $x, $y - 5, -1, -1)
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "ChkTHSnipeBeforeEnable_Info_01", "If TH is external start with a TH Snipe"))
				GUICtrlSetOnEvent(-1, "chkTHSnipeBeforeDBEnable")

		$y += 16
			$g_hLblTHSnipeBeforeDBTiles = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "LblTHSnipeBeforeTiles", "Add Tiles")& ":", $x, $y + 3, 70, -1, $SS_RIGHT)
				GUICtrlSetState(-1, $GUI_DISABLE)
			$g_hTxtTHSnipeBeforeDBTiles = GUICtrlCreateInput("2", $x + 75, $y + 1, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "LblTHSnipeBeforeTiles_Info_01", "Max numbers of tiles from border to consider TH as external")
				_GUICtrlSetTip(-1, $sTxtTip)
				GUICtrlSetLimit(-1, 2)
				GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTiles, $x + 107, $y + 1, 16, 16)
				_GUICtrlSetTip(-1, $sTxtTip)

		$y += 21
			$g_hCmbTHSnipeBeforeDBScript = GUICtrlCreateCombo("",  $x, $y, 130, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, "")
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "CmbTHSnipeBeforeScript_Info_01", "You can add/edit CSV settings in the CSV\THSnipe folder"))
				GUICtrlSetState(-1, $GUI_DISABLE)
				;GUICtrlSetOnEvent(-1, "cmbAttackTHType")
		LoadDBSnipeAttacks()
		_GUICtrlComboBox_SetCurSel($g_hCmbTHSnipeBeforeDBScript, _GUICtrlComboBox_FindStringExact($g_hCmbTHSnipeBeforeDBScript, "Bam"))
		GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 10, $y = 332
		GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Group_03", "Siege Machines"), $x - 5, $y , 145, 40, $SS_CENTER)

			$g_hCmbDBSiege = GUICtrlCreateCombo("", $x, $y + 14, 130, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Siege_Item_01", "Castle only") & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Siege_Item_02", "Wall Wrecker") & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Siege_Item_03", "Battle Blimp")& "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Siege_Item_04", "Stone Slammer"), GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Siege_Item_01", -1))
			GUICtrlSetOnEvent(-1, "cmbDBSiege")

		GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateAttackSearchDeadBaseAttack
