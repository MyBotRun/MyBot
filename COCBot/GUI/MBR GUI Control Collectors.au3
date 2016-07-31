; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Collectors
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: zengzeng
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func checkCollectors($log = False, $showLabel = True)
	Local $anyCollectorsEnabled = 0
	For $i = 6 To 12
		If Eval("chkLvl"&$i&"Enabled") = 1 Then
			$anyCollectorsEnabled = 1
			ExitLoop
		EndIf
	Next
	If $anyCollectorsEnabled = 0 Then
		If $showLabel Then GUICtrlSetState($lblCollectorWarning, $GUI_SHOW)
		If $log Then
			SetLog("Warning: Dead base is enabled, but no collectors are selected!", $COLOR_RED)
			SetLog("Dead base will never be found!", $COLOR_RED)
			SetLog("Select some in Attack Plan-Search&Attack-DeadBase-Collectors", $COLOR_RED)
			Return False
		EndIf
	ElseIf $anyCollectorsEnabled = 1 Then
		If $showLabel Then GUICtrlSetState($lblCollectorWarning, $GUI_HIDE)
		Return True
	EndIf
	Return False
EndFunc
Func chkLvl6()
	If GUICtrlRead($chkLvl6) = $GUI_CHECKED Then
		$chkLvl6Enabled = 1
		GUICtrlSetState($cmbLvl6, $GUI_ENABLE)
	Else
		$chkLvl6Enabled = 0
		GUICtrlSetState($cmbLvl6, $GUI_DISABLE)
	EndIf
	checkCollectors()
EndFunc   ;==>chkLvl6
Func chkLvl7()
	If GUICtrlRead($chkLvl7) = $GUI_CHECKED Then
		$chkLvl7Enabled = 1
		GUICtrlSetState($cmbLvl7, $GUI_ENABLE)
	Else
		$chkLvl7Enabled = 0
		GUICtrlSetState($cmbLvl7, $GUI_DISABLE)
	EndIf
	checkCollectors()
EndFunc   ;==>chkLvl7
Func chkLvl8()
	If GUICtrlRead($chkLvl8) = $GUI_CHECKED Then
		$chkLvl8Enabled = 1
		GUICtrlSetState($cmbLvl8, $GUI_ENABLE)
	Else
		$chkLvl8Enabled = 0
		GUICtrlSetState($cmbLvl8, $GUI_DISABLE)
	EndIf
	checkCollectors()
EndFunc   ;==>chkLvl8
Func chkLvl9()
	If GUICtrlRead($chkLvl9) = $GUI_CHECKED Then
		$chkLvl9Enabled = 1
		GUICtrlSetState($cmbLvl9, $GUI_ENABLE)
	Else
		$chkLvl9Enabled = 0
		GUICtrlSetState($cmbLvl9, $GUI_DISABLE)
	EndIf
	checkCollectors()
EndFunc   ;==>chkLvl9
Func chkLvl10()
	If GUICtrlRead($chkLvl10) = $GUI_CHECKED Then
		$chkLvl10Enabled = 1
		GUICtrlSetState($cmbLvl10, $GUI_ENABLE)
	Else
		$chkLvl10Enabled = 0
		GUICtrlSetState($cmbLvl10, $GUI_DISABLE)
	EndIf
	checkCollectors()
EndFunc   ;==>chkLvl10
Func chkLvl11()
	If GUICtrlRead($chkLvl11) = $GUI_CHECKED Then
		$chkLvl11Enabled = 1
		GUICtrlSetState($cmbLvl11, $GUI_ENABLE)
	Else
		$chkLvl11Enabled = 0
		GUICtrlSetState($cmbLvl11, $GUI_DISABLE)
	EndIf
	checkCollectors()
EndFunc   ;==>chkLvl11
Func chkLvl12()
	If GUICtrlRead($chkLvl12) = $GUI_CHECKED Then
		$chkLvl12Enabled = 1
		GUICtrlSetState($cmbLvl12, $GUI_ENABLE)
	Else
		$chkLvl12Enabled = 0
		GUICtrlSetState($cmbLvl12, $GUI_DISABLE)
	EndIf
	checkCollectors()
EndFunc   ;==>chkLvl12
Func cmbLvl6()
	$cmbLvl6Fill = _GUICtrlComboBox_GetCurSel($cmbLvl6)
EndFunc   ;==>cmbLvl6
Func cmbLvl7()
	$cmbLvl7Fill = _GUICtrlComboBox_GetCurSel($cmbLvl7)
EndFunc   ;==>cmbLvl7
Func cmbLvl8()
	$cmbLvl8Fill = _GUICtrlComboBox_GetCurSel($cmbLvl8)
EndFunc   ;==>cmbLvl8
Func cmbLvl9()
	$cmbLvl9Fill = _GUICtrlComboBox_GetCurSel($cmbLvl9)
EndFunc   ;==>cmbLvl9
Func cmbLvl10()
	$cmbLvl10Fill = _GUICtrlComboBox_GetCurSel($cmbLvl10)
EndFunc   ;==>cmbLvl10
Func cmbLvl11()
	$cmbLvl11Fill = _GUICtrlComboBox_GetCurSel($cmbLvl11)
EndFunc   ;==>cmbLvl11
Func cmbLvl12()
	$cmbLvl12Fill = _GUICtrlComboBox_GetCurSel($cmbLvl12)
EndFunc   ;==>cmbLvl12
Func sldCollectorTolerance()
	$toleranceOffset = GUICtrlRead($sldCollectorTolerance)
EndFunc   ;==>sldCollectorTolerance
