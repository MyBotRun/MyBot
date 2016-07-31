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
	$grpABAttack = GUICtrlCreateGroup(GetTranslated(624,1, -1), $x - 20, $y - 15, 145, 223)
		$x -= 15
		$lblABAlgorithm = GUICtrlCreateLabel(GetTranslated(624,2, -1) & ":",  $x, $y, 135, 18,$SS_LEFT)
		$y += 15
		$cmbABAlgorithm = GUICtrlCreateCombo("", $x, $y, 135, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, "")
			GUICtrlSetData(-1, GetTranslated(624,3, -1) & "|" & GetTranslated(624,4, -1) , GetTranslated(624,3,-1))
			GUICtrlSetOnEvent(-1, "cmbABAlgorithm")
		$y += 25
		$lblABSelectTroop=GUICtrlCreateLabel(GetTranslated(624,6, -1) & ":", $x, $y, 135, 18,$SS_LEFT)
		$y += 15
		$cmbABSelectTroop=GUICtrlCreateCombo("", $x, $y, 135, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, GetTranslated(624,7, -1) & "|" & GetTranslated(624,8, -1) & "|" & GetTranslated(624,9, -1) & "|" & GetTranslated(624,10, -1) & "|" & GetTranslated(624,11, -1) & "|" & GetTranslated(624,12, -1) & "|" & GetTranslated(624,13, -1) & "|" & GetTranslated(624,14, -1) & "|" & GetTranslated(624,15, -1) & "|" & GetTranslated(624,16, -1) & "|" & GetTranslated(624,17, -1), GetTranslated(624,7, -1))
			_GUICtrlSetTip(-1, GetTranslated(624,18, -1))
		$y += 25
		$lblABSelectSpecialTroop=GUICtrlCreateLabel(GetTranslated(624,19, -1) & ":",$x, $y, 135, 18, $SS_LEFT)
		$y += 18
		$IMGchkABKingAttack=GUICtrlCreateIcon($pIconLib, $eIcnKing, $x , $y, 24, 24)
			$txtTip = GetTranslated(624,20, -1) & @CRLF & GetTranslated(624, 41, -1)
			_GUICtrlSetTip(-1, $txtTip)
		$chkABKingAttack = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $txtTip)
		$x += 46
		$IMGchkABQueenAttack=GUICtrlCreateIcon($pIconLib, $eIcnQueen, $x, $y, 24, 24)
			$txtTip = GetTranslated(624,21, -1) & @CRLF & GetTranslated(624, 42, -1)
			_GUICtrlSetTip(-1, $txtTip)
		$chkABQueenAttack = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $txtTip)
		$x +=46
		$IMGchkABWardenAttack=GUICtrlCreateIcon($pIconLib, $eIcnWarden, $x, $y, 24, 24)
			$txtTip = GetTranslated(624,22, -1) & @CRLF & GetTranslated(624, 43, -1)
			_GUICtrlSetTip(-1, $txtTip)
		$chkABWardenAttack = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $txtTip)
	    $y +=27
		$x -=92
		$IMGchkABDropCC=GUICtrlCreateIcon($pIconLib, $eIcnCC, $x, $y, 24, 24)
			$txtTip = GetTranslated(624,23, -1)
			_GUICtrlSetTip(-1, $txtTip)
		$chkABDropCC = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $txtTip)
		$x += 46
		$IMGchkABLightSpell=GUICtrlCreateIcon($pIconLib, $eIcnLightSpell, $x, $y, 24, 24)
			$txtTip = GetTranslated(624,24, -1)
			_GUICtrlSetTip(-1, $txtTip)
		$chkABLightSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $txtTip)
		$x +=46
		$IMGchkABHealSpell=GUICtrlCreateIcon($pIconLib, $eIcnHealSpell, $x, $y, 24, 24)
			$txtTip = GetTranslated(624,25, -1)
			_GUICtrlSetTip(-1, $txtTip)
		$chkABHealSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $txtTip)
	    $y +=27
		$x -=92
		$IMGchkABRageSpell=GUICtrlCreateIcon($pIconLib, $eIcnRageSpell, $x, $y, 24, 24)
			$txtTip = GetTranslated(624,26, -1)
			_GUICtrlSetTip(-1, $txtTip)
		$chkABRageSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $txtTip)
		$x +=46
			$IMGchkABJumpSpell=GUICtrlCreateIcon($pIconLib, $eIcnJumpSpell , $x, $y, 24, 24)
			$txtTip =GetTranslated(624,27, -1)
			_GUICtrlSetTip(-1, $txtTip)
		$chkABJumpSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $txtTip)
		$x += 46
		$IMGchkABFreezeSpell=GUICtrlCreateIcon($pIconLib, $eIcnFreezeSpell , $x, $y, 24, 24)
			$txtTip = GetTranslated(624,28, -1)
			_GUICtrlSetTip(-1, $txtTip)
		$chkABFreezeSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $txtTip)
	    $y +=27
		$x -=92
		$IMGchkABPoisonSpell=GUICtrlCreateIcon($pIconLib, $eIcnPoisonSpell , $x, $y, 24, 24)
			$txtTip = GetTranslated(624,29, -1)
			_GUICtrlSetTip(-1, $txtTip)
		$chkABPoisonSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $txtTip)
		$x +=46
		$IMGchkABEarthquakeSpell=GUICtrlCreateIcon($pIconLib, $eIcnEarthquakeSpell , $x, $y, 24, 24)
			$txtTip = GetTranslated(624,30, -1)
			_GUICtrlSetTip(-1, $txtTip)
		$chkABEarthquakeSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $txtTip)
		$x +=46
			$IMGchkABHasteSpell=GUICtrlCreateIcon($pIconLib, $eIcnHasteSpell, $x, $y, 24, 24)
			$txtTip =GetTranslated(624,31, -1)
			_GUICtrlSetTip(-1, $txtTip)
		$chkABHasteSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

Local $x = 10, $y = 268
	$grpTSAttackBeforeAB = GUICtrlCreateGroup(GetTranslated(624,32, -1),  $x - 5, $y - 20, 145, 84,$SS_CENTER)
		$chkTHSnipeBeforeLBEnable = GUICtrlCreateCheckbox(GetTranslated(624,33, -1) ,$x, $y - 5, -1, -1)
			$txtTip = GetTranslated(624,34, -1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkTHSnipeBeforeLBEnable")
		$y += 16
		$lblTHSnipeBeforeLBTiles = GUICtrlCreateLabel(GetTranslated(624,35, -1)& ":", $x, $y + 3, 70, -1, $SS_RIGHT)
		GUICtrlSetState(-1, $GUI_DISABLE)
		$txtTHSnipeBeforeLBTiles = GUICtrlCreateInput("2", $x + 75, $y + 1, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(624,36, -1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetState(-1, $GUI_DISABLE)
 		$picTHSnipeBeforeLBTiles = GUICtrlCreateIcon($pIconLib, $eIcnTiles, $x + 107, $y + 1, 16, 16)
 			_GUICtrlSetTip(-1, $txtTip)
		$y += 21
		$cmbTHSnipeBeforeLBScript = GUICtrlCreateCombo("",  $x, $y, 130, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "")
            $txtTip = GetTranslated(624,37, -1)
			_GUICtrlSetTip(-1, $txtTip)
			;GUICtrlSetOnEvent(-1, "cmbAttackTHType")
			GUICtrlSetState(-1, $GUI_DISABLE)
LoadABSnipeAttacks()
_GUICtrlComboBox_SetCurSel($cmbTHSnipeBeforeLBScript,_GUICtrlComboBox_FindStringExact($cmbTHSnipeBeforeLBScript, "Bam"))
	GUICtrlCreateGroup("", -99, -99, 1, 1)
