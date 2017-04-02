; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Attack" tab under the "ActiveBase" tab under the "Search & Attack" tab under the "Attack Plan" tab
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

; Attack with
Global $g_hCmbABAlgorithm = 0, $g_hCmbABSelectTroop = 0, $g_hChkABKingAttack = 0, $g_hChkABQueenAttack = 0, $g_hChkABWardenAttack = 0, $g_hChkABDropCC = 0
Global $g_hChkABLightSpell = 0, $g_hChkABHealSpell = 0, $g_hChkABRageSpell = 0, $g_hChkABJumpSpell = 0, $g_hChkABFreezeSpell = 0, $g_hChkABCloneSpell = 0, _
	   $g_hChkABPoisonSpell = 0, $g_hChkABEarthquakeSpell = 0, $g_hChkABHasteSpell = 0, $g_hChkABSkeletonSpell = 0

Global $g_hGrpABAttack = 0, $g_hPicABKingAttack = 0, $g_hPicABQueenAttack = 0, $g_hPicABWardenAttack = 0, $g_hPicABDropCC = 0
Global $g_hPicABLightSpell = 0, $g_hPicABHealSpell = 0, $g_hPicABRageSpell = 0, $g_hPicABJumpSpell = 0, $g_hPicABFreezeSpell = 0, $g_hPicABCloneSpell = 0, _
	   $g_hPicABPoisonSpell = 0, $g_hPicABEarthquakeSpell = 0, $g_hPicABHasteSpell = 0, $g_hPicABSkeletonSpell = 0

; TH Snipe
Global $g_hChkTHSnipeBeforeLBEnable = 0, $g_hTxtTHSnipeBeforeLBTiles = 0, $g_hCmbTHSnipeBeforeLBScript = 0
Global $g_hLblTHSnipeBeforeLBTiles = 0

Func CreateAttackSearchActiveBaseAttack()
   Local $sTxtTip = ""
   Local $x = 25, $y = 40
	$g_hGrpABAttack = GUICtrlCreateGroup(GetTranslated(624,1, -1), $x - 20, $y - 15, 145, 223)
		$x -= 15
		$y += 5
		$g_hCmbABAlgorithm = GUICtrlCreateCombo("", $x, $y, 135, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, "")
			GUICtrlSetData(-1, GetTranslated(624,3, -1) & "|" & GetTranslated(624,4, -1) , GetTranslated(624,3,-1))
			GUICtrlSetOnEvent(-1, "cmbABAlgorithm")

		$y += 30
		$g_hCmbABSelectTroop=GUICtrlCreateCombo("", $x, $y, 135, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, GetTranslated(624,7, -1) & "|" & GetTranslated(624,8, -1) & "|" & GetTranslated(624,9, -1) & "|" & GetTranslated(624,10, -1) & "|" & GetTranslated(624,11, -1) & "|" & GetTranslated(624,12, -1) & "|" & GetTranslated(624,13, -1) & "|" & GetTranslated(624,14, -1) & "|" & GetTranslated(624,15, -1) & "|" & GetTranslated(624,16, -1) & "|" & GetTranslated(624,17, -1), GetTranslated(624,7, -1))
			_GUICtrlSetTip(-1, GetTranslated(624,18, -1))

		$y += 30
		$g_hPicABKingAttack=GUICtrlCreateIcon($g_sLibIconPath, $eIcnKing, $x , $y, 24, 24)
			$sTxtTip = GetTranslated(624,20, -1) & @CRLF & GetTranslated(624, 41, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hChkABKingAttack = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $sTxtTip)

		$x += 46
		$g_hPicABQueenAttack=GUICtrlCreateIcon($g_sLibIconPath, $eIcnQueen, $x, $y, 24, 24)
			$sTxtTip = GetTranslated(624,21, -1) & @CRLF & GetTranslated(624, 42, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hChkABQueenAttack = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $sTxtTip)

		$x +=46
		$g_hPicABWardenAttack=GUICtrlCreateIcon($g_sLibIconPath, $eIcnWarden, $x, $y, 24, 24)
			$sTxtTip = GetTranslated(624,22, -1) & @CRLF & GetTranslated(624, 43, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hChkABWardenAttack = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $sTxtTip)

		$y +=27
		$x -=92
		$g_hPicABDropCC=GUICtrlCreateIcon($g_sLibIconPath, $eIcnCC, $x, $y, 24, 24)
			$sTxtTip = GetTranslated(624,23, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hChkABDropCC = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $sTxtTip)

		$x += 46
		$g_hPicABLightSpell=GUICtrlCreateIcon($g_sLibIconPath, $eIcnLightSpell, $x, $y, 24, 24)
			$sTxtTip = GetTranslated(624,24, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hChkABLightSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $sTxtTip)

		$x +=46
		$g_hPicABHealSpell=GUICtrlCreateIcon($g_sLibIconPath, $eIcnHealSpell, $x, $y, 24, 24)
			$sTxtTip = GetTranslated(624,25, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hChkABHealSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $sTxtTip)

		$y +=27
		$x -=92
		$g_hPicABRageSpell=GUICtrlCreateIcon($g_sLibIconPath, $eIcnRageSpell, $x, $y, 24, 24)
			$sTxtTip = GetTranslated(624,26, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hChkABRageSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $sTxtTip)

		$x +=46
			$g_hPicABJumpSpell=GUICtrlCreateIcon($g_sLibIconPath, $eIcnJumpSpell , $x, $y, 24, 24)
			$sTxtTip =GetTranslated(624,27, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hChkABJumpSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $sTxtTip)

		$x += 46
		$g_hPicABFreezeSpell=GUICtrlCreateIcon($g_sLibIconPath, $eIcnFreezeSpell , $x, $y, 24, 24)
			$sTxtTip = GetTranslated(624,28, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hChkABFreezeSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $sTxtTip)

		$y +=27
		$x -=92
		$g_hPicABCloneSpell=GUICtrlCreateIcon($g_sLibIconPath, $eIcnCloneSpell , $x, $y, 24, 24)
			$sTxtTip = GetTranslated(624,44, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hChkABCloneSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $sTxtTip)

		$x +=46
		$g_hPicABPoisonSpell=GUICtrlCreateIcon($g_sLibIconPath, $eIcnPoisonSpell , $x, $y, 24, 24)
			$sTxtTip = GetTranslated(624,29, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hChkABPoisonSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $sTxtTip)

		$x +=46
		$g_hPicABEarthquakeSpell=GUICtrlCreateIcon($g_sLibIconPath, $eIcnEarthquakeSpell , $x, $y, 24, 24)
			$sTxtTip = GetTranslated(624,30, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hChkABEarthquakeSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $sTxtTip)

		$y +=27
		$x -=92
		$g_hPicABHasteSpell=GUICtrlCreateIcon($g_sLibIconPath, $eIcnHasteSpell, $x, $y, 24, 24)
		$sTxtTip =GetTranslated(624,31, -1)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hChkABHasteSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
		_GUICtrlSetTip(-1, $sTxtTip)

		$x +=46
		$g_hPicABSkeletonSpell=GUICtrlCreateIcon($g_sLibIconPath, $eIcnSkeletonSpell , $x, $y, 24, 24)
			$sTxtTip = GetTranslated(624,45, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hChkABSkeletonSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

   Local $x = 10, $y = 268
	GUICtrlCreateGroup(GetTranslated(624,32, -1),  $x - 5, $y - 20, 145, 84,$SS_CENTER)
		$g_hChkTHSnipeBeforeLBEnable = GUICtrlCreateCheckbox(GetTranslated(624,33, -1) ,$x, $y - 5, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(624,34, -1))
			GUICtrlSetOnEvent(-1, "chkTHSnipeBeforeLBEnable")

		$y += 16
		$g_hLblTHSnipeBeforeLBTiles = GUICtrlCreateLabel(GetTranslated(624,35, -1)& ":", $x, $y + 3, 70, -1, $SS_RIGHT)
		GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hTxtTHSnipeBeforeLBTiles = GUICtrlCreateInput("2", $x + 75, $y + 1, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = GetTranslated(624,36, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetState(-1, $GUI_DISABLE)
 		GUICtrlCreateIcon($g_sLibIconPath, $eIcnTiles, $x + 107, $y + 1, 16, 16)
 			_GUICtrlSetTip(-1, $sTxtTip)

		$y += 21
		$g_hCmbTHSnipeBeforeLBScript = GUICtrlCreateCombo("",  $x, $y, 130, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "")
			_GUICtrlSetTip(-1, GetTranslated(624,37, -1))
			;GUICtrlSetOnEvent(-1, "cmbAttackTHType")
			GUICtrlSetState(-1, $GUI_DISABLE)

   LoadABSnipeAttacks()
   _GUICtrlComboBox_SetCurSel($g_hCmbTHSnipeBeforeLBScript,_GUICtrlComboBox_FindStringExact($g_hCmbTHSnipeBeforeLBScript, "Bam"))
	   GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc
