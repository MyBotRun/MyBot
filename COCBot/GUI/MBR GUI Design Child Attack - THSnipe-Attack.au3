; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Attack" tab under the "TH Snipe" tab under the "Search & Attack" tab under the "Attack Plan" tab
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

Global $g_hCmbAttackTHType = 0, $g_hCmbTSSelectTroop = 0, $g_hChkTSKingAttack = 0, $g_hChkTSQueenAttack = 0, $g_hChkTSWardenAttack = 0, $g_hChkTSDropCC = 0
Global $g_hChkTSLightSpell = 0, $g_hChkTSHealSpell = 0, $g_hChkTSRageSpell = 0, $g_hChkTSJumpSpell = 0, $g_hChkTSFreezeSpell = 0,$g_hChkTSPoisonSpell = 0, _
	   $g_hChkTSEarthquakeSpell = 0, $g_hChkTSHasteSpell = 0 ;, $g_hChkAttackTH = 0

Global $g_hLblAttackTHType = 0, $g_hLblTSSelectTroop = 0, $g_hLblTSSelectSpecialTroop = 0, $g_hPicTSKingAttack = 0, $g_hPicTSQueenAttack = 0, $g_hPicTSWardenAttack = 0, _
	   $g_hPicTSDropCC = 0
Global $g_hPicTSLightSpell = 0, $g_hPicTSHealSpell = 0, $g_hPicTSRageSpell = 0, $g_hPicTSJumpSpell = 0, $g_hPicTSFreezeSpell = 0,  $g_hPicTSPoisonSpell = 0, _
	   $g_hPicTSEarthquakeSpell = 0, $g_hPicTSHasteSpell = 0

Func CreateAttackSearchTHSnipeAttack()

	Local $sTxtTip
	Local $x = 25, $y = 40
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Group_01", -1), $x - 20, $y - 15, $g_iSizeWGrpTab4, $g_iSizeHGrpTab4)
	$x -= 15
		$g_hLblAttackTHType = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "LblAttackType", "Attack Type") & ":", $x, $y, 135, 18, $SS_LEFT)

	$y += 15
		$g_hCmbAttackTHType = GUICtrlCreateCombo("", $x, $y, 128, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "")
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "CmbTHSnipeBeforeScript_Info_01", -1))
			GUICtrlSetOnEvent(-1, "cmbAttackTHType")
			LoadThSnipeAttacks()

	$y += 25
		$g_hLblTSSelectTroop = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "LblSelectTroop", "Only drop these troops") & ":", $x, $y, 135, 18,$SS_LEFT)

	$y += 15
		$g_hCmbTSSelectTroop = GUICtrlCreateCombo("", $x, $y, 128, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
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

	$y += 25
		$g_hLblTSSelectSpecialTroop = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "LblSelectSpecialTroop", "Special troops to use") & ":", $x, $y, 135, 18, $SS_LEFT)

	$y += 18
		$g_hPicTSKingAttack = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnKing, $x, $y, 24, 24)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-King_Info_01", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hChkTSKingAttack = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $sTxtTip)

	$x += 46
		$g_hPicTSQueenAttack = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnQueen, $x, $y, 24, 24)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Queen_Info_01", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hChkTSQueenAttack = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $sTxtTip)

	$x += 46
		$g_hPicTSWardenAttack = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnWarden, $x, $y, 24, 24)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Warden_Info_01", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hChkTSWardenAttack = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 27
	$x -= 92
		$g_hPicTSDropCC = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnCC, $x, $y, 24, 24)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Clan Castle_Info_01", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hChkTSDropCC = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $sTxtTip)

	$x += 46
		$g_hPicTSLightSpell = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnLightSpell, $x, $y, 24, 24)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Light_Info_01", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hChkTSLightSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $sTxtTip)

	$x += 46
		$g_hPicTSHealSpell = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnHealSpell, $x, $y, 24, 24)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Healing_Info_01", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hChkTSHealSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 27
	$x -= 92
		$g_hPicTSRageSpell = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnRageSpell, $x, $y, 24, 24)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Rage_Info_01", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hChkTSRageSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $sTxtTip)

	$x += 46
		$g_hPicTSJumpSpell = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnJumpSpell, $x, $y, 24, 24)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Jump_Info_01", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hChkTSJumpSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $sTxtTip)

	$x += 46
		$g_hPicTSFreezeSpell = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnFreezeSpell, $x, $y, 24, 24)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Freeze_Info_01", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hChkTSFreezeSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 27
	$x -= 92
		$g_hPicTSPoisonSpell = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnPoisonSpell, $x, $y, 24, 24)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Poison_Info_01", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hChkTSPoisonSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $sTxtTip)

	$x += 46
		$g_hPicTSEarthquakeSpell = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnEarthquakeSpell, $x, $y, 24, 24)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Earthquake_Info_01", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hChkTSEarthquakeSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $sTxtTip)

	$x += 46
		$g_hPicTSHasteSpell = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnHasteSpell, $x, $y, 24, 24)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Haste_Info_01", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hChkTSHasteSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateAttackSearchTHSnipeAttack
