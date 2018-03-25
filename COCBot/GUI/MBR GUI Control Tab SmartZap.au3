; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 [2017]
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func chkSmartLightSpell()
	If GUICtrlRead($g_hChkSmartLightSpell) = $GUI_CHECKED Then
		GUICtrlSetState($g_hChkSmartZapDB, $GUI_ENABLE)
		GUICtrlSetState($g_hChkSmartZapSaveHeroes, $GUI_ENABLE)
		GUICtrlSetState($g_hChkSmartZapFTW, $GUI_ENABLE)
		GUICtrlSetState($g_hChkNoobZap, $GUI_ENABLE)
		GUICtrlSetState($g_hChkSmartEQSpell, $GUI_ENABLE)
		GUICtrlSetState($g_hLblSmartUseLSpell, $GUI_SHOW)
		If GUICtrlRead($g_hChkNoobZap) = $GUI_CHECKED Then
			GUICtrlSetState($g_hTxtSmartZapMinDE, $GUI_ENABLE)
			GUICtrlSetState($g_hTxtSmartExpectedDE, $GUI_ENABLE)
		Else
			GUICtrlSetState($g_hTxtSmartZapMinDE, $GUI_DISABLE)
			GUICtrlSetState($g_hTxtSmartExpectedDE, $GUI_DISABLE)
		EndIf
		$g_bSmartZapEnable = True
	Else
		GUICtrlSetState($g_hChkSmartZapDB, $GUI_DISABLE)
		GUICtrlSetState($g_hChkSmartZapSaveHeroes, $GUI_DISABLE)
		GUICtrlSetState($g_hChkSmartZapFTW, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtSmartZapMinDE, $GUI_DISABLE)
		GUICtrlSetState($g_hChkNoobZap, $GUI_DISABLE)
		GUICtrlSetState($g_hChkSmartEQSpell, $GUI_DISABLE)
		GUICtrlSetState($g_hLblSmartUseLSpell, $GUI_HIDE)
		GUICtrlSetState($g_hTxtSmartExpectedDE, $GUI_DISABLE)
		$g_bSmartZapEnable = False
	EndIf
EndFunc   ;==>chkSmartLightSpell

Func chkNoobZap()
	If GUICtrlRead($g_hChkNoobZap) = $GUI_CHECKED Then
		GUICtrlSetState($g_hTxtSmartZapMinDE, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtSmartExpectedDE, $GUI_ENABLE)
		$g_bNoobZap = True
	Else
		GUICtrlSetState($g_hTxtSmartZapMinDE, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtSmartExpectedDE, $GUI_DISABLE)
		$g_bNoobZap = False
	EndIf
EndFunc   ;==>chkNoobZap

Func chkEarthQuakeZap()
	If GUICtrlRead($g_hChkSmartEQSpell) = $GUI_CHECKED Then
		GUICtrlSetState($g_hLblSmartUseEQSpell, $GUI_SHOW)
		$g_bEarthQuakeZap = True
	Else
		GUICtrlSetState($g_hLblSmartUseEQSpell, $GUI_HIDE)
		$g_bEarthQuakeZap = False
	EndIf
EndFunc   ;==>chkEarthQuakeZap

Func chkSmartZapDB()
    $g_bSmartZapDB = (GUICtrlRead($g_hChkSmartZapDB) = $GUI_CHECKED)
EndFunc   ;==>chkSmartZapDB

Func chkSmartZapFTW()
    $g_bSmartZapFTW = (GUICtrlRead($g_hChkSmartZapFTW) = $GUI_CHECKED)
EndFunc   ;==>chkSmartZapFTW

Func chkSmartZapSaveHeroes()
    $g_bSmartZapSaveHeroes = (GUICtrlRead($g_hChkSmartZapSaveHeroes) = $GUI_CHECKED)
EndFunc   ;==>chkSmartZapSaveHeroes

Func txtMinDark()
	$g_iSmartZapMinDE = GUICtrlRead($g_hTxtSmartZapMinDE)
EndFunc   ;==>txtMinDark

Func txtExpectedDE()
	$g_iSmartZapExpectedDE = GUICtrlRead($g_hTxtSmartExpectedDE)
EndFunc   ;==>TxtExpectedDE