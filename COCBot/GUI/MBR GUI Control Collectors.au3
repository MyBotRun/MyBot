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

Global $chkLvl6Enabled
Global $chkLvl7Enabled
Global $chkLvl8Enabled
Global $chkLvl9Enabled
Global $chkLvl10Enabled
Global $chkLvl11Enabled
Global $chkLvl12Enabled
Global $cmbLvl6Fill
Global $cmbLvl7Fill
Global $cmbLvl8Fill
Global $cmbLvl9Fill
Global $cmbLvl10Fill
Global $cmbLvl11Fill
Global $cmbLvl12Fill
Global $toleranceOffset
Func chkLvl6()
	If GUICtrlRead($chkLvl6) = $GUI_CHECKED Then
		$chkLvl6Enabled = "1"
		GUICtrlSetState($cmbLvl6, $GUI_ENABLE)
	Else
		$chkLvl6Enabled = "0"
		GUICtrlSetState($cmbLvl6, $GUI_DISABLE)
	EndIf
EndFunc
Func chkLvl7()
	If GUICtrlRead($chkLvl7) = $GUI_CHECKED Then
		$chkLvl7Enabled = "1"
		GUICtrlSetState($cmbLvl7, $GUI_ENABLE)
	Else
		$chkLvl7Enabled = "0"
		GUICtrlSetState($cmbLvl7, $GUI_DISABLE)
	EndIf
EndFunc
Func chkLvl8()
	If GUICtrlRead($chkLvl8) = $GUI_CHECKED Then
		$chkLvl8Enabled = "1"
		GUICtrlSetState($cmbLvl8, $GUI_ENABLE)
	Else
		$chkLvl8Enabled = "0"
		GUICtrlSetState($cmbLvl8, $GUI_DISABLE)
	EndIf
EndFunc
Func chkLvl9()
	If GUICtrlRead($chkLvl9) = $GUI_CHECKED Then
		$chkLvl9Enabled = "1"
		GUICtrlSetState($cmbLvl9, $GUI_ENABLE)
	Else
		$chkLvl9Enabled = "0"
		GUICtrlSetState($cmbLvl9, $GUI_DISABLE)
	EndIf
EndFunc
Func chkLvl10()
	If GUICtrlRead($chkLvl10) = $GUI_CHECKED Then
		$chkLvl10Enabled = "1"
		GUICtrlSetState($cmbLvl10, $GUI_ENABLE)
	Else
		$chkLvl10Enabled = "0"
		GUICtrlSetState($cmbLvl10, $GUI_DISABLE)
	EndIf
EndFunc
Func chkLvl11()
	If GUICtrlRead($chkLvl11) = $GUI_CHECKED Then
		$chkLvl11Enabled = "1"
		GUICtrlSetState($cmbLvl11, $GUI_ENABLE)
	Else
		$chkLvl11Enabled = "0"
		GUICtrlSetState($cmbLvl11, $GUI_DISABLE)
	EndIf
EndFunc
Func chkLvl12()
	If GUICtrlRead($chkLvl12) = $GUI_CHECKED Then
		$chkLvl12Enabled = "1"
		GUICtrlSetState($cmbLvl12, $GUI_ENABLE)
	Else
		$chkLvl12Enabled = "0"
		GUICtrlSetState($cmbLvl12, $GUI_DISABLE)
	EndIf
EndFunc
Func cmbLvl6()
	$cmbLvl6Fill= _GUICtrlComboBox_GetCurSel($cmbLvl6)
EndFunc
Func cmbLvl7()
	$cmbLvl7Fill= _GUICtrlComboBox_GetCurSel($cmbLvl7)
EndFunc
Func cmbLvl8()
	$cmbLvl8Fill= _GUICtrlComboBox_GetCurSel($cmbLvl8)
EndFunc
Func cmbLvl9()
	$cmbLvl9Fill= _GUICtrlComboBox_GetCurSel($cmbLvl9)
EndFunc
Func cmbLvl10()
	$cmbLvl10Fill= _GUICtrlComboBox_GetCurSel($cmbLvl10)
EndFunc
Func cmbLvl11()
	$cmbLvl11Fill= _GUICtrlComboBox_GetCurSel($cmbLvl11)
EndFunc
Func cmbLvl12()
	$cmbLvl12Fill= _GUICtrlComboBox_GetCurSel($cmbLvl12)
EndFunc
Func sldCollectorTolerance()
	$toleranceOffset = GUICtrlRead($sldCollectorTolerance)
EndFunc
Func readCollectorConfig()
	$chkLvl6Enabled = IniRead($config,"collectors", "lvl6Enabled", "1")
	$chkLvl7Enabled = IniRead($config,"collectors", "lvl7Enabled", "1")
	$chkLvl8Enabled = IniRead($config,"collectors", "lvl8Enabled", "1")
	$chkLvl9Enabled = IniRead($config,"collectors", "lvl9Enabled", "1")
	$chkLvl10Enabled = IniRead($config,"collectors", "lvl10Enabled", "1")
	$chkLvl11Enabled = IniRead($config,"collectors", "lvl11Enabled", "1")
	$chkLvl12Enabled = IniRead($config,"collectors", "lvl12Enabled", "1")
	$cmbLvl6fill = IniRead($config,"collectors", "lvl6fill", "2")
	$cmbLvl7fill = IniRead($config,"collectors", "lvl7fill", "2")
	$cmbLvl8fill = IniRead($config,"collectors", "lvl8fill", "2")
	$cmbLvl9fill = IniRead($config,"collectors", "lvl9fill", "1")
	$cmbLvl10fill = IniRead($config,"collectors", "lvl10fill", "0")
	$cmbLvl11fill = IniRead($config,"collectors", "lvl11fill", "0")
	$cmbLvl12fill = IniRead($config,"collectors", "lvl12fill", "0")
	$toleranceOffset = IniRead($config, "collectors", "tolerance", "0")
EndFunc
Func saveCollectorConfig()
	Iniwrite($config,"collectors", "lvl6Enabled", $chkLvl6Enabled)
	Iniwrite($config,"collectors", "lvl7Enabled", $chkLvl7Enabled)
	Iniwrite($config,"collectors", "lvl8Enabled", $chkLvl8Enabled)
	Iniwrite($config,"collectors", "lvl9Enabled", $chkLvl9Enabled)
	Iniwrite($config,"collectors", "lvl10Enabled", $chkLvl10Enabled)
	Iniwrite($config,"collectors", "lvl11Enabled", $chkLvl11Enabled)
	Iniwrite($config,"collectors", "lvl12Enabled", $chkLvl12Enabled)
	Iniwrite($config,"collectors", "lvl6fill", $cmbLvl6Fill)
	Iniwrite($config,"collectors", "lvl7fill", $cmbLvl7Fill)
	Iniwrite($config,"collectors", "lvl8fill", $cmbLvl8Fill)
	Iniwrite($config,"collectors", "lvl9fill", $cmbLvl9Fill)
	Iniwrite($config,"collectors", "lvl10fill", $cmbLvl10Fill)
	Iniwrite($config,"collectors", "lvl11fill", $cmbLvl11Fill)
	Iniwrite($config,"collectors", "lvl12fill", $cmbLvl12Fill)
	IniWrite($config, "collectors", "tolerance", $toleranceOffset)
EndFunc
Func applyCollectorConfig()
	If $chkLvl6Enabled = "1" Then
		GUICtrlSetState($chkLvl6, $GUI_CHECKED)
		GUICtrlSetState($cmbLvl6, $GUI_ENABLE)
	Else
		GUICtrlSetState($chkLvl6, $GUI_UNCHECKED)
		GUICtrlSetState($cmbLvl6, $GUI_DISABLE)
	EndIf
	If $chkLvl7Enabled = "1" Then
		GUICtrlSetState($chkLvl7, $GUI_CHECKED)
		GUICtrlSetState($cmbLvl7, $GUI_ENABLE)
	Else
		GUICtrlSetState($chkLvl7, $GUI_UNCHECKED)
		GUICtrlSetState($cmbLvl7, $GUI_DISABLE)
	EndIf
	If $chkLvl8Enabled = "1" Then
		GUICtrlSetState($chkLvl8, $GUI_CHECKED)
		GUICtrlSetState($cmbLvl8, $GUI_ENABLE)
	Else
		GUICtrlSetState($chkLvl8, $GUI_UNCHECKED)
		GUICtrlSetState($cmbLvl8, $GUI_DISABLE)
	EndIf
	If $chkLvl9Enabled = "1" Then
		GUICtrlSetState($chkLvl9, $GUI_CHECKED)
		GUICtrlSetState($cmbLvl9, $GUI_ENABLE)
	Else
		GUICtrlSetState($chkLvl9, $GUI_UNCHECKED)
		GUICtrlSetState($cmbLvl9, $GUI_DISABLE)
	EndIf
	If $chkLvl10Enabled = "1" Then
		GUICtrlSetState($chkLvl10, $GUI_CHECKED)
		GUICtrlSetState($cmbLvl10, $GUI_ENABLE)
	Else
		GUICtrlSetState($chkLvl10, $GUI_UNCHECKED)
		GUICtrlSetState($cmbLvl10, $GUI_DISABLE)
	EndIf
	If $chkLvl11Enabled = "1" Then
		GUICtrlSetState($chkLvl11, $GUI_CHECKED)
		GUICtrlSetState($cmbLvl11, $GUI_ENABLE)
	Else
		GUICtrlSetState($chkLvl11, $GUI_UNCHECKED)
		GUICtrlSetState($cmbLvl11, $GUI_DISABLE)
	EndIf
	If $chkLvl12Enabled = "1" Then
		GUICtrlSetState($chkLvl12, $GUI_CHECKED)
		GUICtrlSetState($cmbLvl12, $GUI_ENABLE)
	Else
		GUICtrlSetState($chkLvl12, $GUI_UNCHECKED)
		GUICtrlSetState($cmbLvl12, $GUI_DISABLE)
	EndIf


	_GUICtrlComboBox_SetCurSel($cmbLvl6, $cmblvl6Fill)
	_GUICtrlComboBox_SetCurSel($cmbLvl7, $cmblvl7Fill)
	_GUICtrlComboBox_SetCurSel($cmbLvl8, $cmblvl8Fill)
	_GUICtrlComboBox_SetCurSel($cmbLvl9, $cmblvl9Fill)
	_GUICtrlComboBox_SetCurSel($cmbLvl10, $cmblvl10Fill)
	_GUICtrlComboBox_SetCurSel($cmbLvl11, $cmblvl11Fill)
	_GUICtrlComboBox_SetCurSel($cmbLvl12, $cmblvl12Fill)
	GUICtrlSetData($sldCollectorTolerance, $toleranceOffset)
EndFunc
Func OpenGUI2()
    If $hCollectorGUI = 0 Then
	   GUI2()
	   readCollectorConfig()
	   applyCollectorConfig()
	   GUISetState(@SW_SHOW, $hCollectorGUI)
	   GUISetState(@SW_DISABLE, $frmBot)
    EndIf
EndFunc
Func CloseGUI2()
	saveCollectorConfig()
	GUIDelete($hCollectorGUI)
	$hCollectorGUI = 0
	GUISetState(@SW_ENABLE, $frmBot)
	WinActivate($frmBot)
EndFunc