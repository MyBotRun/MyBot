; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Attack" tab under the "TH Snipe" tab under the "Search & Attack" tab under the "Attack Plan" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
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
	GUICtrlCreateGroup(GetTranslated(624,1, -1), $x - 20, $y - 15, 420, 305)
		$x -= 15
		$g_hLblAttackTHType = GUICtrlCreateLabel(GetTranslated(624,2, -1) & ":", $x  , $y  , 135, 18, $SS_LEFT)

		$y += 15
		$g_hCmbAttackTHType = GUICtrlCreateCombo("",  $x, $y, 128, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "")
			_GUICtrlSetTip(-1, GetTranslated(624,37, -1))
			GUICtrlSetOnEvent(-1, "cmbAttackTHType")
			LoadThSnipeAttacks()

		$y += 25
		$g_hLblTSSelectTroop=GUICtrlCreateLabel(GetTranslated(624,6,-1) & ":",$x, $y , 135 , 18,$SS_LEFT)

		$y += 15
		$g_hCmbTSSelectTroop=GUICtrlCreateCombo("", $x , $y, 128, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, GetTranslated(624,7, -1) & "|" & GetTranslated(624,8, -1) & "|" & GetTranslated(624,9, -1) & "|" & GetTranslated(624,10, -1) & "|" & GetTranslated(624,11, -1) & "|" & GetTranslated(624,12, -1) & "|" & GetTranslated(624,13, -1) & "|" & GetTranslated(624,14, -1) & "|" & GetTranslated(624,15, -1) & "|" & GetTranslated(624,16, -1) & "|" & GetTranslated(624,17, -1), GetTranslated(624,7, -1))
			_GUICtrlSetTip(-1, GetTranslated(624,18, -1))

		$y += 25
		$g_hLblTSSelectSpecialTroop=GUICtrlCreateLabel(GetTranslated(624,19, -1) & ":",$x, $y, 135, 18, $SS_LEFT)

		$y += 18
	    $g_hPicTSKingAttack=GUICtrlCreateIcon($g_sLibIconPath, $eIcnKing, $x , $y, 24, 24)
			$sTxtTip = GetTranslated(624,20, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hChkTSKingAttack = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $sTxtTip)

	    $x += 46
		$g_hPicTSQueenAttack=GUICtrlCreateIcon($g_sLibIconPath, $eIcnQueen, $x, $y, 24, 24)
			$sTxtTip = GetTranslated(624,21, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hChkTSQueenAttack = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $sTxtTip)

		$x +=46
		$g_hPicTSWardenAttack=GUICtrlCreateIcon($g_sLibIconPath, $eIcnWarden, $x, $y, 24, 24)
			$sTxtTip = GetTranslated(624,22, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hChkTSWardenAttack = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $sTxtTip)

		$y +=27
		$x -=92
	    $g_hPicTSDropCC=GUICtrlCreateIcon($g_sLibIconPath, $eIcnCC, $x, $y, 24, 24)
			$sTxtTip =GetTranslated(624,23, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hChkTSDropCC = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $sTxtTip)

		$x += 46
		$g_hPicTSLightSpell=GUICtrlCreateIcon($g_sLibIconPath, $eIcnLightSpell, $x, $y, 24, 24)
			$sTxtTip = GetTranslated(624,24, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hChkTSLightSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $sTxtTip)

		$x +=46
		$g_hPicTSHealSpell=GUICtrlCreateIcon($g_sLibIconPath, $eIcnHealSpell, $x, $y, 24, 24)
			$sTxtTip = GetTranslated(624,25, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hChkTSHealSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $sTxtTip)

		$y +=27
		$x -=92
		$g_hPicTSRageSpell=GUICtrlCreateIcon($g_sLibIconPath, $eIcnRageSpell, $x, $y, 24, 24)
			$sTxtTip = GetTranslated(624,26, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hChkTSRageSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $sTxtTip)

		$x +=46
	    $g_hPicTSJumpSpell=GUICtrlCreateIcon($g_sLibIconPath, $eIcnJumpSpell , $x, $y, 24, 24)
			$sTxtTip =GetTranslated(624,27, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hChkTSJumpSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $sTxtTip)

		$x += 46
		$g_hPicTSFreezeSpell=GUICtrlCreateIcon($g_sLibIconPath, $eIcnFreezeSpell , $x, $y, 24, 24)
			$sTxtTip = GetTranslated(624,28, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hChkTSFreezeSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $sTxtTip)

		$y +=27
		$x -=92
		$g_hPicTSPoisonSpell=GUICtrlCreateIcon($g_sLibIconPath, $eIcnPoisonSpell , $x, $y, 24, 24)
			$sTxtTip = GetTranslated(624,29, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hChkTSPoisonSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $sTxtTip)

		$x +=46
		$g_hPicTSEarthquakeSpell=GUICtrlCreateIcon($g_sLibIconPath, $eIcnEarthquakeSpell , $x, $y, 24, 24)
			$sTxtTip = GetTranslated(624,30, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hChkTSEarthquakeSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $sTxtTip)

		$x +=46
			$g_hPicTSHasteSpell=GUICtrlCreateIcon($g_sLibIconPath, $eIcnHasteSpell, $x, $y, 24, 24)
			$sTxtTip =GetTranslated(624,31, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hChkTSHasteSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $sTxtTip)

		;$y += 30
		;$x = 30
	 	;	$g_hChkAttackTH = GUICtrlCreateCheckbox(GetTranslated(624,38, "Attack Townhall Outside"), $x, $y, -1, -1)
		;	_GUICtrlSetTip(-1, GetTranslated(624,39, "Check this to Attack an exposed Townhall first. (Townhall outside of Walls)") & @CRLF & _
		;					   GetTranslated(624,40, "TIP: Also tick 'Meet Townhall Outside' on the Search tab if you only want to search for bases with exposed Townhalls."))
		;	GUICtrlSetState(-1,$GUI_HIDE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
 EndFunc
