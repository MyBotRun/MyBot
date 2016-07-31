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

$hGUI_ACTIVEBASE_ATTACK_STANDARD = GUICreate("", $_GUI_MAIN_WIDTH - 195, $_GUI_MAIN_HEIGHT - 344, 150, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $hGUI_ACTIVEBASE)
;GUISetBkColor($COLOR_WHITE, $hGUI_ACTIVEBASE_ATTACK_STANDARD)

Local $x = 25, $y = 20
$grpDeployAB = GUICtrlCreateGroup(GetTranslated(608,1, -1), $x - 20, $y - 20, 270, 306)
;$x -= 15
   $lblABmode = GUICtrlCreateLabel(GetTranslated(608,2, -1),$x, $y, 143,18,$SS_LEFT)
$y += 15
	$cmbStandardAlgorithmAB = GUICtrlCreateCombo("", $x, $y, 150, Default, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, GetTranslated(608,25, -1)&"|Barch/BAM/BAG|GiBarch", GetTranslated(608,25, -1))
			_GUICtrlSetTip(-1, GetTranslated(608,33, -1)&@CRLF&GetTranslated(608,34, -1))
	$y += 25
	;95)
		$lblDeployAB = GUICtrlCreateLabel(GetTranslated(608,3, "Attack on")&":", $x, $y + 5, -1, -1)
		$cmbDeployAB = GUICtrlCreateCombo("", $x + 55, $y, 120, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, GetTranslated(608,4, -1) & @CRLF & GetTranslated(608,5, -1) & @CRLF & GetTranslated(608,6, -1) & @CRLF & GetTranslated(608,29, "Attack on the single side closest to the Dark Elixir Storage") & @CRLF & GetTranslated(608,30, "Attack on the single side closest to the Townhall"), GetTranslated(608,7, -1))
			GUICtrlSetData(-1, GetTranslated(608,8, -1) & "|" & GetTranslated(608,9, -1) & "|" & GetTranslated(608,10, -1) & "|" & GetTranslated(608,11, -1) & "|" & GetTranslated(608,31, "DE Side Attack") & "|" & GetTranslated(608,32, "TH Side Attack"), GetTranslated(608,11, -1))
			;GUICtrlSetOnEvent(-1, "chkDESideEB")

		$y += 25
		$lblUnitDelayAB = GUICtrlCreateLabel(GetTranslated(608,12, -1) & ":", $x, $y + 5, -1, -1)
			$txtTip = GetTranslated(608,13, -1) & @CRLF & GetTranslated(608,14, -1)
			_GUICtrlSetTip(-1, $txtTip)
		$cmbUnitDelayAB = GUICtrlCreateCombo("", $x + 55, $y, 36, 21, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetData(-1, "1|2|3|4|5|6|7|8|9|10", "4")
		$lblWaveDelayAB = GUICtrlCreateLabel(GetTranslated(608,15, -1) & ":", $x + 100, $y + 5, -1, -1)
			_GUICtrlSetTip(-1, $txtTip)
		$cmbWaveDelayAB = GUICtrlCreateCombo("", $x + 140, $y, 36, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetData(-1, "1|2|3|4|5|6|7|8|9|10", "4")
		$y += 22
		$chkRandomSpeedAtkAB = GUICtrlCreateCheckbox(GetTranslated(608,16, -1), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkRandomSpeedAtkAB")
	$y +=22
		$chkSmartAttackRedAreaAB = GUICtrlCreateCheckbox(GetTranslated(608,17, -1), $x, $y, -1, -1)
			$txtTip = GetTranslated(608,18, -1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkSmartAttackRedAreaAB")
		$y += 22
		$lblSmartDeployAB = GUICtrlCreateLabel(GetTranslated(608,19, -1) & ":", $x, $y + 5, -1, -1)
			$txtTip = GetTranslated(608,20, -1) & @CRLF & GetTranslated(608,21, -1) & @CRLF & GetTranslated(608,22, -1)
			_GUICtrlSetTip(-1, $txtTip)
		$cmbSmartDeployAB = GUICtrlCreateCombo("", $x + 55, $y, 120, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, GetTranslated(608,23, -1) & "|" & GetTranslated(608,24, -1) , GetTranslated(608,23, -1))
			_GUICtrlSetTip(-1, $txtTip)
		$y += 26
		$chkAttackNearGoldMineAB = GUICtrlCreateCheckbox("", $x + 20, $y, 17, 17)
			$txtTip = GetTranslated(608,26, -1)
			_GUICtrlSetTip(-1, $txtTip)
		$picAttackNearGoldMineAB = GUICtrlCreateIcon($pIconLib, $eIcnMine, $x + 40 , $y - 3 , 24, 24)
			_GUICtrlSetTip(-1, $txtTip)
		$x += 75
		$chkAttackNearElixirCollectorAB = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			$txtTip = GetTranslated(608,27, -1)
			_GUICtrlSetTip(-1, $txtTip)
		$picAttackNearElixirCollectorAB = GUICtrlCreateIcon($pIconLib, $eIcnCollector, $x + 20 , $y - 3 , 24, 24)
			_GUICtrlSetTip(-1, $txtTip)
 		$x += 55
  		$chkAttackNearDarkElixirDrillAB = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			$txtTip = GetTranslated(608,28, -1)
 			_GUICtrlSetTip(-1, $txtTip)
		$picAttackNearDarkElixirDrillAB = GUICtrlCreateIcon($pIconLib, $eIcnDrill, $x + 20 , $y - 3, 24, 24)
 			_GUICtrlSetTip(-1, $txtTip)

;GUISetState()
