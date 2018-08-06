; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Attack Standard
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: MyBot.run team
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func chkRandomSpeedAtkAB()
	If GUICtrlRead($g_hChkRandomSpeedAtkAB) = $GUI_CHECKED Then
		;$iChkABRandomSpeedAtk = 1
		GUICtrlSetState($g_hCmbStandardUnitDelayAB, $GUI_DISABLE)
		GUICtrlSetState($g_hCmbStandardWaveDelayAB, $GUI_DISABLE)
	Else
		;$iChkABRandomSpeedAtk = 0
		GUICtrlSetState($g_hCmbStandardUnitDelayAB, $GUI_ENABLE)
		GUICtrlSetState($g_hCmbStandardWaveDelayAB, $GUI_ENABLE)
	EndIf
EndFunc   ;==>chkRandomSpeedAtkAB

Func chkSmartAttackRedAreaAB()
	If GUICtrlRead($g_hChkSmartAttackRedAreaAB) = $GUI_CHECKED Then
		$g_abAttackStdSmartAttack[$LB] = 1
		For $i = $g_hLblSmartDeployAB To $g_hPicAttackNearDarkElixirDrillAB
			GUICtrlSetState($i, $GUI_SHOW)
		Next
	Else
		$g_abAttackStdSmartAttack[$LB] = 0
		For $i = $g_hLblSmartDeployAB To $g_hPicAttackNearDarkElixirDrillAB
			GUICtrlSetState($i, $GUI_HIDE)
		Next
	EndIf
EndFunc   ;==>chkSmartAttackRedAreaAB

Func chkRandomSpeedAtkDB()
	Local $iCmbValue = _GUICtrlComboBox_GetCurSel($g_hCmbDBAlgorithm)
	If $iCmbValue = 0 Then
		If GUICtrlRead($g_hChkRandomSpeedAtkDB) = $GUI_CHECKED Then
			GUICtrlSetState($g_hChkRandomSpeedAtkDB1, $GUI_CHECKED)
			GUICtrlSetState($g_hCmbStandardUnitDelayDB, $GUI_DISABLE)
			GUICtrlSetState($g_hCmbStandardWaveDelayDB, $GUI_DISABLE)
			GUICtrlSetState($g_hCmbStandardUnitDelayDB1, $GUI_DISABLE)
			GUICtrlSetState($g_hCmbStandardWaveDelayDB1, $GUI_DISABLE)
		Else
			GUICtrlSetState($g_hChkRandomSpeedAtkDB1, $GUI_UNCHECKED)
			GUICtrlSetState($g_hCmbStandardUnitDelayDB, $GUI_ENABLE)
			GUICtrlSetState($g_hCmbStandardWaveDelayDB, $GUI_ENABLE)
			GUICtrlSetState($g_hCmbStandardUnitDelayDB1, $GUI_ENABLE)
			GUICtrlSetState($g_hCmbStandardWaveDelayDB1, $GUI_ENABLE)
			chkSpeedAtkDB()
		EndIf
	EndIf
	If $iCmbValue = 3 Then
		If GUICtrlRead($g_hChkRandomSpeedAtkDB1) = $GUI_CHECKED And $iCmbValue = 3 Then
			GUICtrlSetState($g_hChkRandomSpeedAtkDB, $GUI_CHECKED)
			GUICtrlSetState($g_hCmbStandardUnitDelayDB, $GUI_DISABLE)
			GUICtrlSetState($g_hCmbStandardWaveDelayDB, $GUI_DISABLE)
			GUICtrlSetState($g_hCmbStandardUnitDelayDB1, $GUI_DISABLE)
			GUICtrlSetState($g_hCmbStandardWaveDelayDB1, $GUI_DISABLE)
		Else
			GUICtrlSetState($g_hChkRandomSpeedAtkDB, $GUI_UNCHECKED)
			GUICtrlSetState($g_hCmbStandardUnitDelayDB, $GUI_ENABLE)
			GUICtrlSetState($g_hCmbStandardWaveDelayDB, $GUI_ENABLE)
			GUICtrlSetState($g_hCmbStandardUnitDelayDB1, $GUI_ENABLE)
			GUICtrlSetState($g_hCmbStandardWaveDelayDB1, $GUI_ENABLE)
			chkSpeedAtkDB()
		EndIf
	EndIf
EndFunc   ;==>chkRandomSpeedAtkDB

Func chkSpeedAtkDB()
	Local $iCmbValue = _GUICtrlComboBox_GetCurSel($g_hCmbDBAlgorithm)
	If $iCmbValue = 3 And GUICtrlRead($g_hChkRandomSpeedAtkDB1) = $GUI_UNCHECKED then
		_GUICtrlComboBox_SetCurSel($g_hCmbStandardUnitDelayDB, _GUICtrlComboBox_GetCurSel($g_hCmbStandardUnitDelayDB1))
		_GUICtrlComboBox_SetCurSel($g_hCmbStandardWaveDelayDB, _GUICtrlComboBox_GetCurSel($g_hCmbStandardWaveDelayDB1))
	ElseIf $iCmbValue = 0 And GUICtrlRead($g_hChkRandomSpeedAtkDB) = $GUI_UNCHECKED then
		_GUICtrlComboBox_SetCurSel($g_hCmbStandardUnitDelayDB1, _GUICtrlComboBox_GetCurSel($g_hCmbStandardUnitDelayDB))
		_GUICtrlComboBox_SetCurSel($g_hCmbStandardWaveDelayDB1, _GUICtrlComboBox_GetCurSel($g_hCmbStandardWaveDelayDB))
	EndIf
EndFunc

Func chkSmartAttackRedAreaDB()
	If GUICtrlRead($g_hChkSmartAttackRedAreaDB) = $GUI_CHECKED Then
		$g_abAttackStdSmartAttack[$DB] = 1
		For $i = $g_hLblSmartDeployDB To $g_hPicAttackNearDarkElixirDrillDB
			GUICtrlSetState($i, $GUI_SHOW)
		Next
	Else
		$g_abAttackStdSmartAttack[$DB] = 0
		For $i = $g_hLblSmartDeployDB To $g_hPicAttackNearDarkElixirDrillDB
			GUICtrlSetState($i, $GUI_HIDE)
		Next
	EndIf
EndFunc   ;==>chkSmartAttackRedAreaDB
