; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GkevinOD (2014)
; Modified ......: Hervidero (2015), kaganus (August 2015), CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func btnResetStats()
	ResetStats()
EndFunc   ;==>btnResetStats

Func UpdateMultiStats()
	Local $bEnableSwitchAcc = $g_iCmbSwitchAcc > 0
	Local $iCmbTotalAcc = _GUICtrlComboBox_GetCurSel($g_hCmbTotalAccount) + 1 ; combobox data starts with 2
	For $i = 0 To 7
		If $bEnableSwitchAcc And $i <= $iCmbTotalAcc Then
			_GUI_Value_STATE("SHOW", $g_ahGrpDefaultAcc[$i])
			If (GUICtrlGetState($g_ahLblHourlyStatsGoldAcc[$i]) And GUICtrlGetState($g_ahLbLLootCCGold[$i])) = $GUI_ENABLE + $GUI_HIDE Then
				_GUI_Value_STATE("SHOW", $g_ahGrpReportAcc[$i])
			
			ElseIf (GUICtrlGetState($g_ahLbLLootCCGold[$i]) And GUICtrlGetState($g_ahLblResultGoldNowAcc[$i])) = $GUI_ENABLE + $GUI_HIDE Then
				_GUI_Value_STATE("SHOW", $g_ahGrpStatsAcc[$i])
		
			ElseIf (GUICtrlGetState($g_ahLblResultGoldNowAcc[$i]) And GUICtrlGetState($g_ahLblHourlyStatsGoldAcc[$i])) = $GUI_ENABLE + $GUI_HIDE Then
				_GUI_Value_STATE("SHOW", $g_ahGrpStats2Acc[$i])
				
			EndIf	
						
			If GUICtrlRead($g_ahChkAccount[$i]) = $GUI_CHECKED Then
				If GUICtrlRead($g_ahChkDonate[$i]) = $GUI_UNCHECKED Then
					GUICtrlSetData($g_ahGrpVillageAcc[$i], GUICtrlRead($g_ahCmbProfile[$i]) & " (Active)")
				Else
					GUICtrlSetData($g_ahGrpVillageAcc[$i], GUICtrlRead($g_ahCmbProfile[$i]) & " (Donate)")
				EndIf
			Else
				GUICtrlSetData($g_ahGrpVillageAcc[$i], GUICtrlRead($g_ahCmbProfile[$i]) & " (Idle)")
			EndIf
		Else
			_GUI_Value_STATE("HIDE", $g_ahGrpDefaultAcc[$i] & "#" & $g_ahGrpReportAcc[$i] & "#" & $g_ahGrpStatsAcc[$i] & "#" & $g_ahGrpStats2Acc[$i])
		EndIf
	Next
EndFunc   ;==>UpdateMultiStats

Func SwitchVillageInfo()
	For $i = 0 To 7
		If @GUI_CtrlId = $g_ahPicArrowLeft[$i] Then
			Return _SwitchVillageInfo($i)
		EndIf
	Next
EndFunc

Func SwitchVillageInfo2()
	For $i = 0 To 7
		If @GUI_CtrlId = $g_ahPicArrowRight[$i] Then
			Return _SwitchVillageInfo2($i)
		EndIf
	Next
EndFunc

Func _SwitchVillageInfo($i)
	If GUICtrlGetState($g_ahLblResultGoldNowAcc[$i]) = $GUI_ENABLE + $GUI_SHOW Then
		_GUI_Value_STATE("HIDE", $g_ahGrpReportAcc[$i])
		_GUI_Value_STATE("SHOW", $g_ahGrpStats2Acc[$i])
		_GUI_Value_STATE("HIDE", $g_ahGrpStatsAcc[$i])
		
	ElseIf GUICtrlGetState($g_ahLblHourlyStatsGoldAcc[$i]) = $GUI_ENABLE + $GUI_SHOW Then
		_GUI_Value_STATE("SHOW", $g_ahGrpReportAcc[$i])
		_GUI_Value_STATE("HIDE", $g_ahGrpStats2Acc[$i])
		_GUI_Value_STATE("HIDE", $g_ahGrpStatsAcc[$i])
	
	ElseIf GUICtrlGetState($g_ahLbLLootCCGold[$i]) = $GUI_ENABLE + $GUI_SHOW Then
		_GUI_Value_STATE("HIDE", $g_ahGrpReportAcc[$i])
		_GUI_Value_STATE("HIDE", $g_ahGrpStats2Acc[$i])
		_GUI_Value_STATE("SHOW", $g_ahGrpStatsAcc[$i])
	EndIf
EndFunc

Func _SwitchVillageInfo2($i)
	If GUICtrlGetState($g_ahLblResultGoldNowAcc[$i]) = $GUI_ENABLE + $GUI_SHOW Then
		_GUI_Value_STATE("HIDE", $g_ahGrpReportAcc[$i])
		_GUI_Value_STATE("HIDE", $g_ahGrpStats2Acc[$i])
		_GUI_Value_STATE("SHOW", $g_ahGrpStatsAcc[$i])
		
	ElseIf GUICtrlGetState($g_ahLblHourlyStatsGoldAcc[$i]) = $GUI_ENABLE + $GUI_SHOW Then
		_GUI_Value_STATE("HIDE", $g_ahGrpReportAcc[$i])
		_GUI_Value_STATE("SHOW", $g_ahGrpStats2Acc[$i])
		_GUI_Value_STATE("HIDE", $g_ahGrpStatsAcc[$i])
		
	ElseIf GUICtrlGetState($g_ahLbLLootCCGold[$i]) = $GUI_ENABLE + $GUI_SHOW Then
		_GUI_Value_STATE("SHOW", $g_ahGrpReportAcc[$i])
		_GUI_Value_STATE("HIDE", $g_ahGrpStats2Acc[$i])
		_GUI_Value_STATE("HIDE", $g_ahGrpStatsAcc[$i])
	EndIf
EndFunc

