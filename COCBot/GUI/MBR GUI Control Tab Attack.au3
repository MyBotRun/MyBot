; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GkevinOD (2014)
; Modified ......: Hervidero (2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func chkDBSmartAttackRedArea()
	If GUICtrlRead($chkDBSmartAttackRedArea) = $GUI_CHECKED Then
		$iChkRedArea[$DB] = 1
		For $i = $lblDBSmartDeploy To $picDBAttackNearDarkElixirDrill
			GUICtrlSetState($i, $GUI_SHOW)
		Next
	Else
		$iChkRedArea[$DB] = 0
		For $i = $lblDBSmartDeploy To $picDBAttackNearDarkElixirDrill
			GUICtrlSetState($i, $GUI_HIDE)
		Next
	EndIf
EndFunc   ;==>chkDBSmartAttackRedArea

Func chkABSmartAttackRedArea()
	If GUICtrlRead($chkABSmartAttackRedArea) = $GUI_CHECKED Then
		$iChkRedArea[$LB] = 1
		For $i = $lblABSmartDeploy To $picABAttackNearDarkElixirDrill
			GUICtrlSetState($i, $GUI_SHOW)
		Next
	Else
		$iChkRedArea[$LB] = 0
		For $i = $lblABSmartDeploy To $picABAttackNearDarkElixirDrill
			GUICtrlSetState($i, $GUI_HIDE)
		Next
	EndIf
EndFunc   ;==>chkABSmartAttackRedArea

Func chkBalanceDR()
	If GUICtrlRead($chkUseCCBalanced) = $GUI_CHECKED Then
		GUICtrlSetState($cmbCCDonated, $GUI_ENABLE)
		GUICtrlSetState($cmbCCReceived, $GUI_ENABLE)
	Else
		GUICtrlSetState($cmbCCDonated, $GUI_DISABLE)
		GUICtrlSetState($cmbCCReceived, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkBalanceDR

Func cmbBalanceDR()
	If _GUICtrlComboBox_GetCurSel($cmbCCDonated) = _GUICtrlComboBox_GetCurSel($cmbCCReceived) Then
		_GUICtrlComboBox_SetCurSel($cmbCCDonated, 0)
		_GUICtrlComboBox_SetCurSel($cmbCCReceived, 0)
	EndIf
EndFunc   ;==>cmbBalanceDR

Func chkDBRandomSpeedAtk()
	If GUICtrlRead($chkDBRandomSpeedAtk) = $GUI_CHECKED Then
		;$iChkDBRandomSpeedAtk = 1
		GUICtrlSetState($cmbDBUnitDelay, $GUI_DISABLE)
		GUICtrlSetState($cmbDBWaveDelay, $GUI_DISABLE)
	Else
		;$iChkDBRandomSpeedAtk = 0
		GUICtrlSetState($cmbDBUnitDelay, $GUI_ENABLE)
		GUICtrlSetState($cmbDBWaveDelay, $GUI_ENABLE)
	EndIf
EndFunc   ;==>chkDBRandomSpeedAtk

Func chkABRandomSpeedAtk()
	If GUICtrlRead($chkABRandomSpeedAtk) = $GUI_CHECKED Then
		;$iChkABRandomSpeedAtk = 1
		GUICtrlSetState($cmbABUnitDelay, $GUI_DISABLE)
		GUICtrlSetState($cmbABWaveDelay, $GUI_DISABLE)
	Else
		;$iChkABRandomSpeedAtk = 0
		GUICtrlSetState($cmbABUnitDelay, $GUI_ENABLE)
		GUICtrlSetState($cmbABWaveDelay, $GUI_ENABLE)
	EndIf
EndFunc   ;==>chkABRandomSpeedAtk

Func btnMilkingOptions()
	OpenGUIMilk2()
EndFunc

Func cmbABDeploy()
	chkDESideEB()
	If _GUICtrlComboBox_GetCurSel($cmbABDeploy) = 6 Then ; 6 it is milking attack strategy
		GUICtrlSetState($btnMilkingOptions, $GUI_ENABLE)
	Else
		GUICtrlSetState($btnMilkingOptions, $GUI_DISABLE)
	EndIf
EndFunc

Func chkDBHeroWait()

	If GUICtrlRead($chkDBKingWait) = $GUI_CHECKED Then
		If GUICtrlRead($chkUpgradeKing) = $GUI_UNCHECKED Then
			GUICtrlSetState($chkDBKingAttack, $GUI_CHECKED)
		Else
			GUICtrlSetState($chkDBKingWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		EndIf
	Else
		If GUICtrlRead($chkUpgradeKing) = $GUI_UNCHECKED Then
			GUICtrlSetState($chkDBKingWait, $GUI_ENABLE)
		Else
			GUICtrlSetState($chkDBKingWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		EndIf
	EndIf

	If GUICtrlRead($chkDBQueenWait) = $GUI_CHECKED Then
		If GUICtrlRead($chkUpgradeQueen) = $GUI_UNCHECKED Then
			GUICtrlSetState($chkDBQueenAttack, $GUI_CHECKED)
		Else
			GUICtrlSetState($chkDBQueenWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		EndIf
	Else
		If GUICtrlRead($chkUpgradeQueen) = $GUI_UNCHECKED Then
			GUICtrlSetState($chkDBQueenWait, $GUI_ENABLE)
		Else
			GUICtrlSetState($chkDBQueenWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		EndIf
	EndIf

	If GUICtrlRead($chkDBWardenWait) = $GUI_CHECKED Then
		If GUICtrlRead($chkUpgradeWarden) = $GUI_UNCHECKED Then
			GUICtrlSetState($chkDBWardenAttack, $GUI_CHECKED)
		Else
			GUICtrlSetState($chkDBWardenWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		EndIf
	Else
		If GUICtrlRead($chkUpgradeWarden) = $GUI_UNCHECKED Then
			GUICtrlSetState($chkDBWardenWait, $GUI_ENABLE)
		Else
			GUICtrlSetState($chkDBWardenWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		EndIf
	EndIf

EndFunc

Func chkABHeroWait()

	If GUICtrlRead($chkABKingWait) = $GUI_CHECKED Then
		If GUICtrlRead($chkUpgradeKing) = $GUI_UNCHECKED Then
			GUICtrlSetState($chkABKingAttack, $GUI_CHECKED)
		Else
			GUICtrlSetState($chkABKingWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		EndIf
	Else
		If GUICtrlRead($chkUpgradeKing) = $GUI_UNCHECKED Then
			GUICtrlSetState($chkABKingWait, $GUI_ENABLE)
		Else
			GUICtrlSetState($chkABKingWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		EndIf
	EndIf

	If GUICtrlRead($chkABQueenWait) = $GUI_CHECKED Then
		If GUICtrlRead($chkUpgradeQueen) = $GUI_UNCHECKED Then
			GUICtrlSetState($chkABQueenAttack, $GUI_CHECKED)
		Else
			GUICtrlSetState($chkABQueenWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		EndIf
	Else
		If GUICtrlRead($chkUpgradeQueen) = $GUI_UNCHECKED Then
			GUICtrlSetState($chkABQueenWait, $GUI_ENABLE)
		Else
			GUICtrlSetState($chkABQueenWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		EndIf
	EndIf

	If GUICtrlRead($chkABWardenWait) = $GUI_CHECKED Then
		If GUICtrlRead($chkUpgradeWarden) = $GUI_UNCHECKED Then
			GUICtrlSetState($chkABWardenAttack, $GUI_CHECKED)
		Else
			GUICtrlSetState($chkABWardenWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		EndIf
	Else
		If GUICtrlRead($chkUpgradeWarden) = $GUI_UNCHECKED Then
			GUICtrlSetState($chkABWardenWait, $GUI_ENABLE)
		Else
			GUICtrlSetState($chkABWardenWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		EndIf
	EndIf

EndFunc