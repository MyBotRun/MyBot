; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Collectors
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: zengzeng
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func chkDBDisableCollectorsFilter()
	If GUICtrlRead($g_hChkDBDisableCollectorsFilter) = $GUI_CHECKED Then
		GUICtrlSetState($g_hChkSupercharge, $GUI_DISABLE)
		GUICtrlSetState($g_hCmbMinCollectorMatches, $GUI_DISABLE)
	Else
		GUICtrlSetState($g_hChkSupercharge, $GUI_ENABLE)
		GUICtrlSetState($g_hCmbMinCollectorMatches, $GUI_ENABLE)
	EndIf
EndFunc   ;==>chkDBDisableCollectorsFilter

Func sldCollectorTolerance()
	$g_iCollectorToleranceOffset = GUICtrlRead($g_hSldCollectorTolerance)
EndFunc   ;==>sldCollectorTolerance

Func cmbMinCollectorMatches()
	$g_iCollectorMatchesMin = _GUICtrlComboBox_GetCurSel($g_hCmbMinCollectorMatches) + 1
EndFunc   ;==>cmbMinCollectorMatches
