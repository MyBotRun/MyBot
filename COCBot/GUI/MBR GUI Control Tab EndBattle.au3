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

Func chkTimeStopAtk()
	If GUICtrlRead($chkTimeStopAtk) = $GUI_CHECKED Then
		$ichkTimeStopAtk = 1
		GUICtrlSetState($txtTimeStopAtk, $GUI_ENABLE)
		GUICtrlSetState($lblTimeStopAtk, $GUI_ENABLE)
	Else
		$ichkTimeStopAtk = 0
		GUICtrlSetState($txtTimeStopAtk, $GUI_DISABLE)
		GUICtrlSetState($lblTimeStopAtk, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkTimeStopAtk

Func chkTimeStopAtk2()
	If GUICtrlRead($chkTimeStopAtk2) = $GUI_CHECKED Then
		$ichkTimeStopAtk2 = 1
		GUICtrlSetState($txtTimeStopAtk2, $GUI_ENABLE)
		GUICtrlSetState($lblTimeStopAtk2, $GUI_ENABLE)
		GUICtrlSetState($lblMinGoldStopAtk2, $GUI_ENABLE)
		GUICtrlSetState($txtMinGoldStopAtk2, $GUI_ENABLE)
		GUICtrlSetState($lblMinElixirStopAtk2, $GUI_ENABLE)
		GUICtrlSetState($txtMinElixirStopAtk2, $GUI_ENABLE)
		GUICtrlSetState($lblMinDarkElixirStopAtk2, $GUI_ENABLE)
		GUICtrlSetState($txtMinDarkElixirStopAtk2, $GUI_ENABLE)
	Else
		$ichkTimeStopAtk2 = 0
		GUICtrlSetState($txtTimeStopAtk2, $GUI_DISABLE)
		GUICtrlSetState($lblTimeStopAtk2, $GUI_DISABLE)
		GUICtrlSetState($lblMinGoldStopAtk2, $GUI_DISABLE)
		GUICtrlSetState($txtMinGoldStopAtk2, $GUI_DISABLE)
		GUICtrlSetState($lblMinElixirStopAtk2, $GUI_DISABLE)
		GUICtrlSetState($txtMinElixirStopAtk2, $GUI_DISABLE)
		GUICtrlSetState($lblMinDarkElixirStopAtk2, $GUI_DISABLE)
		GUICtrlSetState($txtMinDarkElixirStopAtk2, $GUI_DISABLE)

	EndIf
EndFunc   ;==>chkTimeStopAtk2

Func chkDESideEB()
	If _GUICtrlComboBox_GetCurSel($cmbABDeploy) = 4 Then
		GUICtrlSetState($chkDESideEB, $GUI_ENABLE)
		If GUICtrlRead($chkDESideEB) = $GUI_CHECKED Then
			For $i = $txtDELowEndMin To $lblDEEndAq
				GUICtrlSetState($i, $GUI_ENABLE)
			Next
		Else
			For $i = $txtDELowEndMin To $lblDEEndAq
			GUICtrlSetState($i, $GUI_DISABLE)
			Next
		EndIf
	Else
		For $i = $chkDESideEB To $lblDEEndAq
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc		;==>chkDESideEB


Func chkShareAttack()
	If GUICtrlRead($chkShareAttack) = $GUI_CHECKED Then
		For $i = $lblShareMinGold To $txtShareMessage
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else;If GUICtrlRead($chkUnbreakable) = $GUI_UNCHECKED Then
		For $i = $lblShareMinGold To $txtShareMessage
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>chkShareAttack
