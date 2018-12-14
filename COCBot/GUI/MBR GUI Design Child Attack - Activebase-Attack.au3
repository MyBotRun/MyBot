; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Attack" tab under the "ActiveBase" tab under the "Search & Attack" tab under the "Attack Plan" tab
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
Global $g_hCmbABAlgorithm = 0, $g_hCmbABSelectTroop = 0, $g_hChkABKingAttack = 0, $g_hChkABQueenAttack = 0, $g_hChkABWardenAttack = 0, $g_hChkABDropCC = 0
Global $g_hChkABLightSpell = 0, $g_hChkABHealSpell = 0, $g_hChkABRageSpell = 0, $g_hChkABJumpSpell = 0, $g_hChkABFreezeSpell = 0, $g_hChkABCloneSpell = 0, _
	   $g_hChkABPoisonSpell = 0, $g_hChkABEarthquakeSpell = 0, $g_hChkABHasteSpell = 0, $g_hChkABSkeletonSpell = 0, $g_hChkABBatSpell = 0

Global $g_hGrpABAttack = 0, $g_hPicABKingAttack = 0, $g_hPicABQueenAttack = 0, $g_hPicABWardenAttack = 0, $g_hPicABDropCC = 0
Global $g_hPicABLightSpell = 0, $g_hPicABHealSpell = 0, $g_hPicABRageSpell = 0, $g_hPicABJumpSpell = 0, $g_hPicABFreezeSpell = 0, $g_hPicABCloneSpell = 0, _
	   $g_hPicABPoisonSpell = 0, $g_hPicABEarthquakeSpell = 0, $g_hPicABHasteSpell = 0, $g_hPicABSkeletonSpell = 0, $g_hPicABBatSpell = 0

; TH Snipe
Global $g_hChkTHSnipeBeforeLBEnable = 0, $g_hTxtTHSnipeBeforeLBTiles = 0, $g_hCmbTHSnipeBeforeLBScript = 0
Global $g_hLblTHSnipeBeforeLBTiles = 0

Global $g_hCmbABSiege = 0

Func CreateAttackSearchActiveBaseAttack()
	Local $sTxtTip = ""
	Local $x = 25, $y = 40
		$g_hGrpABAttack = GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Group_01", -1), $x - 20, $y - 15, 145, 223)
		$x -= 15
		$y += 5
			$g_hCmbABAlgorithm = GUICtrlCreateCombo("", $x, $y, 135, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				_GUICtrlSetTip(-1, "")
				GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Algorithm_Item_01", -1) & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Algorithm_Item_02", -1), GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Algorithm_Item_01", -1))
				GUICtrlSetOnEvent(-1, "cmbABAlgorithm")

		$y += 30
			$g_hCmbABSelectTroop = GUICtrlCreateCombo("", $x, $y, 135, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-SelectTroop_Item_01", -1) & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-SelectTroop_Item_02", -1) & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-SelectTroop_Item_03", -1) & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-SelectTroop_Item_04", -1) & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-SelectTroop_Item_05", -1) & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-SelectTroop_Item_06", -1) & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-SelectTroop_Item_07", -1) & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-SelectTroop_Item_08", -1) & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-SelectTroop_Item_09", -1) & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-SelectTroop_Item_10", -1) & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-SelectTroop_Item_11", -1), GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-SelectTroop_Item_01", -1))
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-SelectTroop_Info_01", -1))

		$y += 30
			$g_hPicABKingAttack = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnKing, $x , $y, 24, 24)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-King_Info_01", -1) & @CRLF & _
						   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-King_Info_02", -1)
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hChkABKingAttack = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
				_GUICtrlSetTip(-1, $sTxtTip)

		$x += 46
			$g_hPicABQueenAttack = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnQueen, $x, $y, 24, 24)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Queen_Info_01", -1) & @CRLF & _
						   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Queen_Info_02", -1)
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hChkABQueenAttack = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
				_GUICtrlSetTip(-1, $sTxtTip)

		$x += 46
			$g_hPicABWardenAttack = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnWarden, $x, $y, 24, 24)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Warden_Info_01", -1) & @CRLF & _
						   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Warden_Info_02", -1)
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hChkABWardenAttack = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
				_GUICtrlSetTip(-1, $sTxtTip)

		$y += 27
		$x -= 92
			$g_hPicABDropCC = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnCC, $x, $y, 24, 24)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Clan Castle_Info_01", -1)
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hChkABDropCC = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
				_GUICtrlSetTip(-1, $sTxtTip)

		$x += 46
			$g_hPicABLightSpell = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnLightSpell, $x, $y, 24, 24)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Light_Info_01", -1)
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hChkABLightSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
				_GUICtrlSetTip(-1, $sTxtTip)

		$x += 46
			$g_hPicABHealSpell = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnHealSpell, $x, $y, 24, 24)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Healing_Info_01", -1)
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hChkABHealSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
				_GUICtrlSetTip(-1, $sTxtTip)

		$y += 27
		$x -= 92
			$g_hPicABRageSpell = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnRageSpell, $x, $y, 24, 24)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Rage_Info_01", -1)
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hChkABRageSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
				_GUICtrlSetTip(-1, $sTxtTip)

		$x += 46
			$g_hPicABJumpSpell = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnJumpSpell, $x, $y, 24, 24)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Jump_Info_01", -1)
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hChkABJumpSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
				_GUICtrlSetTip(-1, $sTxtTip)

		$x += 46
			$g_hPicABFreezeSpell = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnFreezeSpell, $x, $y, 24, 24)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Freeze_Info_01", -1)
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hChkABFreezeSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
				_GUICtrlSetTip(-1, $sTxtTip)

		$y += 27
		$x -= 92
			$g_hPicABCloneSpell = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnCloneSpell, $x, $y, 24, 24)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Clone_Info_01", -1)
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hChkABCloneSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
				_GUICtrlSetTip(-1, $sTxtTip)

		$x += 46
			$g_hPicABPoisonSpell = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnPoisonSpell, $x, $y, 24, 24)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Poison_Info_01", -1)
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hChkABPoisonSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
				_GUICtrlSetTip(-1, $sTxtTip)

		$x += 46
			$g_hPicABEarthquakeSpell = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnEarthquakeSpell, $x, $y, 24, 24)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Earthquake_Info_01", -1)
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hChkABEarthquakeSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
				_GUICtrlSetTip(-1, $sTxtTip)

		$y += 27
		$x -= 92
			$g_hPicABHasteSpell = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnHasteSpell, $x, $y, 24, 24)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Haste_Info_01", -1)
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hChkABHasteSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
				_GUICtrlSetTip(-1, $sTxtTip)

		$x += 46
			$g_hPicABSkeletonSpell = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSkeletonSpell, $x, $y, 24, 24)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Skeleton_Info_01", -1)
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hChkABSkeletonSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
				_GUICtrlSetTip(-1, $sTxtTip)
		
        $x += 46
			$g_hPicABBatSpell = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBatSpell, $x, $y, 24, 24)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Bat_Info_01", -1)
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hChkABBatSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
				_GUICtrlSetTip(-1, $sTxtTip)		
		GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 10, $y = 268
		GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Group_02", -1), $x - 5, $y - 20, 145, 84,$SS_CENTER)
			$g_hChkTHSnipeBeforeLBEnable = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "ChkTHSnipeBeforeEnable", -1), $x, $y - 5, -1, -1)
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "ChkTHSnipeBeforeEnable_Info_01", -1))
				GUICtrlSetOnEvent(-1, "chkTHSnipeBeforeLBEnable")

		$y += 16
			$g_hLblTHSnipeBeforeLBTiles = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "LblTHSnipeBeforeTiles", -1) & ":", $x, $y + 3, 70, -1, $SS_RIGHT)
				GUICtrlSetState(-1, $GUI_DISABLE)
			$g_hTxtTHSnipeBeforeLBTiles = GUICtrlCreateInput("2", $x + 75, $y + 1, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "LblTHSnipeBeforeTiles_Info_01", -1)
				_GUICtrlSetTip(-1, $sTxtTip)
				GUICtrlSetLimit(-1, 2)
				GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTiles, $x + 107, $y + 1, 16, 16)
				_GUICtrlSetTip(-1, $sTxtTip)

		$y += 21
			$g_hCmbTHSnipeBeforeLBScript = GUICtrlCreateCombo("", $x, $y, 130, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, "")
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "CmbTHSnipeBeforeScript_Info_01", -1))
				;GUICtrlSetOnEvent(-1, "cmbAttackTHType")
				GUICtrlSetState(-1, $GUI_DISABLE)
		LoadABSnipeAttacks()
		_GUICtrlComboBox_SetCurSel($g_hCmbTHSnipeBeforeLBScript, _GUICtrlComboBox_FindStringExact($g_hCmbTHSnipeBeforeLBScript, "Bam"))
		GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 10, $y = 332
		GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Group_03", -1), $x - 5, $y , 145, 40, $SS_CENTER)

			$g_hCmbABSiege = GUICtrlCreateCombo("", $x, $y + 14, 130, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Siege_Item_01", -1) & "|" & _
									   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Siege_Item_02", -1) & "|" & _
									   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Siege_Item_03", -1) & "|" & _
									   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Siege_Item_04", "Stone Slammer"), GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Siege_Item_01", -1))
				GUICtrlSetOnEvent(-1, "cmbABSiege")

		GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateAttackSearchActiveBaseAttack
