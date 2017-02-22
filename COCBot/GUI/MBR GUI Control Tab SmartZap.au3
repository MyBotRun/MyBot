; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 [2017]
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func chkSmartLightSpell()
	If GUICtrlRead($g_hChkSmartLightSpell) = $GUI_CHECKED Then
		GUICtrlSetState($g_hChkSmartZapDB, $GUI_ENABLE)
		GUICtrlSetState($g_hChkSmartZapSaveHeroes, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtSmartMinDark, $GUI_ENABLE)
		GUICtrlSetState($g_hChkNoobZap, $GUI_ENABLE)
		GUICtrlSetState($g_hLblSmartUseLSpell, $GUI_SHOW)
		If GUICtrlRead($g_hChkNoobZap) = $GUI_UNCHECKED Then
			GUICtrlSetState($g_hChkSmartEQSpell, $GUI_ENABLE)
		Else
			GUICtrlSetState($g_hChkSmartEQSpell, $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkSmartEQSpell, $GUI_DISABLE)
			GUICtrlSetState($g_hLblSmartUseEQSpell, $GUI_HIDE)
		EndIf
		If GUICtrlRead($g_hChkNoobZap) = $GUI_CHECKED Then
			GUICtrlSetState($g_hTxtSmartExpectedDE, $GUI_ENABLE)
		Else
			GUICtrlSetState($g_hTxtSmartExpectedDE, $GUI_DISABLE)
		EndIf
		$ichkSmartZap = 1
	Else
		GUICtrlSetState($g_hChkSmartZapDB, $GUI_DISABLE)
		GUICtrlSetState($g_hChkSmartZapSaveHeroes, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtSmartMinDark, $GUI_DISABLE)
		GUICtrlSetState($g_hChkNoobZap, $GUI_DISABLE)
		GUICtrlSetState($g_hChkSmartEQSpell, $GUI_DISABLE)
		GUICtrlSetState($g_hLblSmartUseLSpell, $GUI_HIDE)
		GUICtrlSetState($g_hTxtSmartExpectedDE, $GUI_DISABLE)
		$ichkSmartZap = 0
	EndIf
EndFunc   ;==>chkSmartLightSpell

Func chkNoobZap()
	If GUICtrlRead($g_hChkNoobZap) = $GUI_CHECKED Then
		GUICtrlSetState($g_hTxtSmartExpectedDE, $GUI_ENABLE)
		GUICtrlSetState($g_hChkSmartEQSpell, $GUI_UNCHECKED)
		GUICtrlSetState($g_hChkSmartEQSpell, $GUI_DISABLE)
		GUICtrlSetState($g_hLblSmartUseEQSpell, $GUI_HIDE)
		$ichkNoobZap = 1
	Else
		GUICtrlSetState($g_hTxtSmartExpectedDE, $GUI_DISABLE)
		GUICtrlSetState($g_hChkSmartEQSpell, $GUI_ENABLE)
		$ichkNoobZap = 0
	EndIf
EndFunc   ;==>chkNoobZap

Func chkEarthQuakeZap()
	If GUICtrlRead($g_hChkSmartEQSpell) = $GUI_CHECKED Then
		GUICtrlSetState($g_hLblSmartUseEQSpell, $GUI_SHOW)
		$ichkEarthQuakeZap = 1
	Else
		GUICtrlSetState($g_hLblSmartUseEQSpell, $GUI_HIDE)
		$ichkEarthQuakeZap = 0
	EndIf
EndFunc   ;==>chkEarthQuakeZap

Func chkSmartZapDB()
    $ichkSmartZapDB = GUICtrlRead($g_hChkSmartZapDB) = $GUI_CHECKED ? 1 : 0
EndFunc   ;==>chkSmartZapDB

Func chkSmartZapSaveHeroes()
    $ichkSmartZapSaveHeroes = GUICtrlRead($g_hChkSmartZapSaveHeroes) = $GUI_CHECKED ? 1 : 0
EndFunc   ;==>chkSmartZapSaveHeroes

Func txtMinDark()
	$itxtMinDE = GUICtrlRead($g_hTxtSmartMinDark)
EndFunc   ;==>txtMinDark

Func txtExpectedDE()
	$itxtExpectedDE = GUICtrlRead($g_hTxtSmartExpectedDE)
EndFunc   ;==>TxtExpectedDE