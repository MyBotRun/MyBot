; #FUNCTION# ====================================================================================================================
; Name ..........: CGB GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GkevinOD (2014)
; Modified ......: Hervidero (2015)
; Remarks .......: This file is part of ClashGameBot. Copyright 2015
;                  ClashGameBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
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
