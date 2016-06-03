; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Local $x = 25, $y = 40
	$grpTSAttack = GUICtrlCreateGroup(GetTranslated(624,1, -1), $x - 20, $y - 15, 420, 305)
		$x -= 15
		$lblAttackTHType = GUICtrlCreateLabel(GetTranslated(624,2, -1) & ":", $x  , $y  , 135, 18, $SS_LEFT)
		$y += 15
		$cmbAttackTHType = GUICtrlCreateCombo("",  $x, $y, 128, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "")
            $txtTip = GetTranslated(624,37, -1)
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "cmbAttackTHType")
			LoadThSnipeAttacks()

		$y += 25
		$lblTSSelectTroop=GUICtrlCreateLabel(GetTranslated(624,6,-1) & ":",$x, $y , 135 , 18,$SS_LEFT)
		$y += 15
		$cmbTSSelectTroop=GUICtrlCreateCombo("", $x , $y, 128, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, GetTranslated(624,7, -1) & "|" & GetTranslated(624,8, -1) & "|" & GetTranslated(624,9, -1) & "|" & GetTranslated(624,10, -1) & "|" & GetTranslated(624,11, -1) & "|" & GetTranslated(624,12, -1) & "|" & GetTranslated(624,13, -1) & "|" & GetTranslated(624,14, -1) & "|" & GetTranslated(624,15, -1) & "|" & GetTranslated(624,16, -1) & "|" & GetTranslated(624,17, -1), GetTranslated(624,7, -1))
			GUICtrlSetTip(-1, GetTranslated(624,18, -1))
		$y += 25
		$lblTSSelectSpecialTroop=GUICtrlCreateLabel(GetTranslated(624,19, -1) & ":",$x, $y, 135, 18, $SS_LEFT)
		$y += 18

	    $IMGchkTSKingAttack=GUICtrlCreateIcon($pIconLib, $eIcnKing, $x , $y, 24, 24)
			$txtTip = GetTranslated(624,20, -1)
			GUICtrlSetTip(-1, $txtTip)
		$chkTSKingAttack = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			GUICtrlSetTip(-1, $txtTip)
		$x += 46
		$IMGchkTSQueenAttack=GUICtrlCreateIcon($pIconLib, $eIcnQueen, $x, $y, 24, 24)
			$txtTip = GetTranslated(624,21, -1)
			GUICtrlSetTip(-1, $txtTip)
		$chkTSQueenAttack = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			GUICtrlSetTip(-1, $txtTip)
		$x +=46
		$IMGchkTSWardenAttack=GUICtrlCreateIcon($pIconLib, $eIcnWarden, $x, $y, 24, 24)
			$txtTip = GetTranslated(624,22, -1)
			GUICtrlSetTip(-1, $txtTip)
		$chkTSWardenAttack = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			GUICtrlSetTip(-1, $txtTip)
	    $y +=27
		$x -=92
			$IMGchkTSDropCC=GUICtrlCreateIcon($pIconLib, $eIcnCC, $x, $y, 24, 24)
			$txtTip =GetTranslated(624,23, -1)
			GUICtrlSetTip(-1, $txtTip)
		$chkTSDropCC = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			GUICtrlSetTip(-1, $txtTip)
		$x += 46
		$IMGchkTSLightSpell=GUICtrlCreateIcon($pIconLib, $eIcnLightSpell, $x, $y, 24, 24)
			$txtTip = GetTranslated(624,24, -1)
			GUICtrlSetTip(-1, $txtTip)
		$chkTSLightSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			GUICtrlSetTip(-1, $txtTip)
		$x +=46
		$IMGchkTSHealSpell=GUICtrlCreateIcon($pIconLib, $eIcnHealSpell, $x, $y, 24, 24)
			$txtTip = GetTranslated(624,25, -1)
			GUICtrlSetTip(-1, $txtTip)
		$chkTSHealSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			GUICtrlSetTip(-1, $txtTip)
	    $y +=27
		$x -=92
		$IMGchkTSRageSpell=GUICtrlCreateIcon($pIconLib, $eIcnRageSpell, $x, $y, 24, 24)
			$txtTip = GetTranslated(624,26, -1)
			GUICtrlSetTip(-1, $txtTip)
		$chkTSRageSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			GUICtrlSetTip(-1, $txtTip)
		$x +=46
			$IMGchkTSJumpSpell=GUICtrlCreateIcon($pIconLib, $eIcnJumpSpell , $x, $y, 24, 24)
			$txtTip =GetTranslated(624,27, -1)
			GUICtrlSetTip(-1, $txtTip)
		$chkTSJumpSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			GUICtrlSetTip(-1, $txtTip)
		$x += 46
		$IMGchkTSFreezeSpell=GUICtrlCreateIcon($pIconLib, $eIcnFreezeSpell , $x, $y, 24, 24)
			$txtTip = GetTranslated(624,28, -1)
			GUICtrlSetTip(-1, $txtTip)
		$chkTSFreezeSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			GUICtrlSetTip(-1, $txtTip)
	    $y +=27
		$x -=92
		$IMGchkTSPoisonSpell=GUICtrlCreateIcon($pIconLib, $eIcnPoisonSpell , $x, $y, 24, 24)
			$txtTip = GetTranslated(624,29, -1)
			GUICtrlSetTip(-1, $txtTip)
		$chkTSPoisonSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			GUICtrlSetTip(-1, $txtTip)
		$x +=46
		$IMGchkTSEarthquakeSpell=GUICtrlCreateIcon($pIconLib, $eIcnEarthquakeSpell , $x, $y, 24, 24)
			$txtTip = GetTranslated(624,30, -1)
			GUICtrlSetTip(-1, $txtTip)
		$chkTSEarthquakeSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			GUICtrlSetTip(-1, $txtTip)
		$x +=46
			$IMGchkTSHasteSpell=GUICtrlCreateIcon($pIconLib, $eIcnHasteSpell, $x, $y, 24, 24)
			$txtTip =GetTranslated(624,31, -1)
			GUICtrlSetTip(-1, $txtTip)
		$chkTSHasteSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			GUICtrlSetTip(-1, $txtTip)
		$y += 30
		$x = 30
	 		$chkAttackTH = GUICtrlCreateCheckbox(GetTranslated(624,38, "Attack Townhall Outside"), $x, $y, -1, -1)
			GUICtrlSetTip(-1, GetTranslated(624,39, "Check this to Attack an exposed Townhall first. (Townhall outside of Walls)") & @CRLF & GetTranslated(624,40, "TIP: Also tick 'Meet Townhall Outside' on the Search tab if you only want to search for bases with exposed Townhalls."))
			GUICtrlSetState(-1,$GUI_HIDE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
