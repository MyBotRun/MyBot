; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design Bot Android
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

Local $x = 25, $y = 45
$grpCOCDistributors = GUICtrlCreateGroup(GetTranslated(643,1, "Distributors"), $x - 20, $y - 20, 210, 47)
	$y -=2
	$cmbCOCDistributors = GUICtrlCreateCombo("", $x - 8 , $y, 185, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	$txtTip = GetTranslated(643,2, "Allow bot to launch COC based on the distribution chosen")
	_GUICtrlSetTip(-1, $txtTip)
	LoadCOCDistributorsComboBox()
	SetCurSelCmbCOCDistributors()
	GUICtrlSetOnEvent(-1, "cmbCOCDistributors")
GUICtrlCreateGroup("", -99, -99, 1, 1)
