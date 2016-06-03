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

Func btnMilkingOptions()
;~ 	OpenGUIMilk2()
EndFunc   ;==>btnMilkingOptions

Func btnDBAttackConfigure()
	Switch _GUICtrlComboBox_GetCurSel($cmbDBAlgorithm)
		Case 0
			;Algorithm Alltroops
;~ 			OpenGUIAlgorithmAllTroopsConfig($DB)
		Case 1
			; Scripted Attack
;~ 			OpenGUIAlgorithmAttackCSVConfig($DB)
		Case 2
			; Milking Attack
;~ 			OpenGUIMilk2()
	EndSwitch
EndFunc   ;==>btnDBAttackConfigure

Func btnABAttackConfigure()
	Switch _GUICtrlComboBox_GetCurSel($cmbABAlgorithm)
		Case 0
			;Algorithm Alltroops
;~ 			OpenGUIAlgorithmAllTroopsConfig($LB)
		Case 1
			; Scripted Attack
;~ 			OpenGUIAlgorithmAttackCSVConfig($LB)

	EndSwitch
EndFunc   ;==>btnABAttackConfigure

Func cmbDBAlgorithm()
	Local $iCmbValue =  _GUICtrlComboBox_GetCurSel($cmbDBAlgorithm)
	; Algorithm Alltroops
	If $iCmbValue = 1 or $iCmbValue = 2 Then  ;show spells if milking because after milking you can continue to attack with thsnipe or standard attack where you can use spells
		_GUI_Value_STATE("SHOW", $groupAttackDBSpell&"#"&$groupIMGAttackDBSpell)
	Else
		_GUI_Value_STATE("HIDE", $groupAttackDBSpell&"#"&$groupIMGAttackDBSpell)
	EndIf
	Select
		Case $iCmbValue = 0 ; Standard Attack
			GUISetState(@SW_SHOWNOACTIVATE, $hGUI_DEADBASE_ATTACK_STANDARD)
			GUISetState(@SW_HIDE, $hGUI_DEADBASE_ATTACK_SCRIPTED)
			GUISetState(@SW_HIDE, $hGUI_DEADBASE_ATTACK_MILKING)
		Case $iCmbValue = 1 ; Scripted Attack
			GUISetState(@SW_HIDE, $hGUI_DEADBASE_ATTACK_STANDARD)
			GUISetState(@SW_SHOWNOACTIVATE, $hGUI_DEADBASE_ATTACK_SCRIPTED)
			GUISetState(@SW_HIDE, $hGUI_DEADBASE_ATTACK_MILKING)
		Case $iCmbValue = 2 ; Milking Attack
			GUISetState(@SW_HIDE, $hGUI_DEADBASE_ATTACK_STANDARD)
			GUISetState(@SW_HIDE, $hGUI_DEADBASE_ATTACK_SCRIPTED)
			GUISetState(@SW_SHOWNOACTIVATE, $hGUI_DEADBASE_ATTACK_MILKING)
		Case Else
			GUISetState(@SW_HIDE, $hGUI_DEADBASE_ATTACK_STANDARD)
			GUISetState(@SW_HIDE, $hGUI_DEADBASE_ATTACK_SCRIPTED)
			GUISetState(@SW_HIDE, $hGUI_DEADBASE_ATTACK_MILKING)
	EndSelect
EndFunc

Func cmbABAlgorithm()
	Local $iCmbValue =  _GUICtrlComboBox_GetCurSel($cmbABAlgorithm)
	If $iCmbValue = 1 Then
		_GUI_Value_STATE("SHOW", $groupAttackABSpell&"#"&$groupIMGAttackABSpell)
	Else
		_GUI_Value_STATE("HIDE", $groupAttackABSpell&"#"&$groupIMGAttackABSpell)
	EndIf
	Select
		Case $iCmbValue = 0 ; Standard Attack
			GUISetState(@SW_SHOWNOACTIVATE, $hGUI_ACTIVEBASE_ATTACK_STANDARD)
			GUISetState(@SW_HIDE, $hGUI_ACTIVEBASE_ATTACK_SCRIPTED)
		Case $iCmbValue = 1 ; Scripted Attack
			GUISetState(@SW_HIDE, $hGUI_ACTIVEBASE_ATTACK_STANDARD)
			GUISetState(@SW_SHOWNOACTIVATE, $hGUI_ACTIVEBASE_ATTACK_SCRIPTED)
		Case Else
			GUISetState(@SW_HIDE, $hGUI_ACTIVEBASE_ATTACK_STANDARD)
			GUISetState(@SW_HIDE, $hGUI_ACTIVEBASE_ATTACK_SCRIPTED)
	EndSelect
EndFunc

Func chkAttackNow()
	If GUICtrlRead($chkAttackNow) = $GUI_CHECKED Then
		$iChkAttackNow = 1
		GUICtrlSetState($lblAttackNow, $GUI_ENABLE)
		GUICtrlSetState($lblAttackNowSec, $GUI_ENABLE)
		GUICtrlSetState($cmbAttackNowDelay, $GUI_ENABLE)
		GUICtrlSetState($cmbAttackNowDelay, $GUI_ENABLE)
	Else
		$iChkAttackNow = 0
		GUICtrlSetState($lblAttackNow, $GUI_DISABLE)
		GUICtrlSetState($lblAttackNowSec, $GUI_DISABLE)
		GUICtrlSetState($cmbAttackNowDelay, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkAttackNow

Func LoadThSnipeAttacks()
	Dim $FileSearch, $NewFile
	$FileSearch = FileFindFirstFile($dirTHSnipesAttacks & "\*.csv")
	Dim $output = ""
	While True
		$NewFile = FileFindNextFile($FileSearch)
		If @error Then ExitLoop
		$output = $output & StringLeft($NewFile, StringLen($NewFile) - 4) & "|"
	WEnd
	FileClose($FileSearch)
	;remove last |
	$output = StringLeft($output, StringLen($output) - 1)
	;reset combo box
	_GUICtrlComboBox_ResetContent($cmbAttackTHType)
	;set combo box
	GUICtrlSetData($cmbAttackTHType, $output)

	_GUICtrlComboBox_SetCurSel($cmbAttackTHType, _GUICtrlComboBox_FindStringExact($cmbAttackTHType, $scmbAttackTHType))
EndFunc   ;==>LoadThSnipeAttacks


Func LoadDBSnipeAttacks()
	Dim $FileSearch, $NewFile
	$FileSearch = FileFindFirstFile($dirTHSnipesAttacks & "\*.csv")
	Dim $output = ""
	While True
		$NewFile = FileFindNextFile($FileSearch)
		If @error Then ExitLoop
		$output = $output & StringLeft($NewFile, StringLen($NewFile) - 4) & "|"
	WEnd
	FileClose($FileSearch)
	;remove last |
	$output = StringLeft($output, StringLen($output) - 1)
	;reset combo box
	_GUICtrlComboBox_ResetContent($cmbTHSnipeBeforeDBScript)
	;set combo box
	GUICtrlSetData($cmbTHSnipeBeforeDBScript, $output)

	_GUICtrlComboBox_SetCurSel($cmbTHSnipeBeforeDBScript, _GUICtrlComboBox_FindStringExact($cmbTHSnipeBeforeDBScript, $THSnipeBeforeDBTiles))
EndFunc   ;==>LoadDBSnipeAttacks

Func LoadABSnipeAttacks()
	Dim $FileSearch, $NewFile
	$FileSearch = FileFindFirstFile($dirTHSnipesAttacks & "\*.csv")
	Dim $output = ""
	While True
		$NewFile = FileFindNextFile($FileSearch)
		If @error Then ExitLoop
		$output = $output & StringLeft($NewFile, StringLen($NewFile) - 4) & "|"
	WEnd
	FileClose($FileSearch)
	;remove last |
	$output = StringLeft($output, StringLen($output) - 1)
	;reset combo box
	_GUICtrlComboBox_ResetContent($cmbTHSnipeBeforeLBScript)
	;set combo box
	GUICtrlSetData($cmbTHSnipeBeforeLBScript, $output)

	_GUICtrlComboBox_SetCurSel($cmbTHSnipeBeforeLBScript, _GUICtrlComboBox_FindStringExact($cmbTHSnipeBeforeLBScript, $THSnipeBeforeLBscript))
EndFunc   ;==>LoadABSnipeAttacks



Func cmbAttackTHType()
	Local $arrayattack = _GUICtrlComboBox_GetListArray($cmbAttackTHType)
	$scmbAttackTHType = $arrayattack[_GUICtrlComboBox_GetCurSel($cmbAttackTHType) + 1]
EndFunc   ;==>cmbAttackTHType

Func btnTestTHcsv()
	AttackTHParseCSV(True) ; launch attach th parse CSV only for test in log
EndFunc   ;==>btnTestTHcsv

Func cmbTSGoldElixir()
	If _GUICtrlComboBox_GetCurSel($cmbTSMeetGE) < 2 Then
		GUICtrlSetState($txtTSMinGold, $GUI_SHOW)
		GUICtrlSetState($picTSMinGold, $GUI_SHOW)
		GUICtrlSetState($txtTSMinElixir, $GUI_SHOW)
		GUICtrlSetState($picTSMinElixir, $GUI_SHOW)
		GUICtrlSetState($txtTSMinGoldPlusElixir, $GUI_HIDE)
		GUICtrlSetState($picTSMinGPEGold, $GUI_HIDE)
	Else
		GUICtrlSetState($txtTSMinGold, $GUI_HIDE)
		GUICtrlSetState($picTSMinGold, $GUI_HIDE)
		GUICtrlSetState($txtTSMinElixir, $GUI_HIDE)
		GUICtrlSetState($picTSMinElixir, $GUI_HIDE)
		GUICtrlSetState($txtTSMinGoldPlusElixir, $GUI_SHOW)
		GUICtrlSetState($picTSMinGPEGold, $GUI_SHOW)
	EndIf
EndFunc   ;==>cmbTSGoldElixir

;~ Func chkbtnScheduler()
;~ 	If GUICtrlRead($chkbtnScheduler) = $GUI_CHECKED Then
;~ 		$ichkbtnScheduler = 1
;~ 		GUICtrlSetState($btnScheduler, $GUI_ENABLE)
;~ 	Else
;~ 		$ichkbtnScheduler = 0
;~ 		GUICtrlSetState($btnScheduler, $GUI_DISABLE)
;~ 	EndIf
;~ EndFunc   ;==>chkbtnScheduler

;~ Func btnScheduler()
;~ 	OpenGUIAttHSched()
;~ EndFunc   ;==>btnScheduler

Func chkTHSnipeBeforeDBEnable()
	If GUICtrlRead($chkTHSnipeBeforeDBEnable) = $GUI_CHECKED Then
		GUICtrlSetState($lblTHSnipeBeforeDBTiles, $GUI_ENABLE)
		GUICtrlSetState($txtTHSnipeBeforeDBTiles, $GUI_ENABLE)
		GUICtrlSetState($cmbTHSnipeBeforeDBScript, $GUI_ENABLE)
	Else
		GUICtrlSetState($lblTHSnipeBeforeDBTiles, $GUI_DISABLE)
		GUICtrlSetState($txtTHSnipeBeforeDBTiles, $GUI_DISABLE)
		GUICtrlSetState($cmbTHSnipeBeforeDBScript, $GUI_DISABLE)
	EndIf
EndFunc

Func chkTHSnipeBeforeLBEnable()
	If GUICtrlRead($chkTHSnipeBeforeLBEnable) = $GUI_CHECKED Then
		GUICtrlSetState($lblTHSnipeBeforeLBTiles, $GUI_ENABLE)
		GUICtrlSetState($txtTHSnipeBeforeLBTiles, $GUI_ENABLE)
		GUICtrlSetState($cmbTHSnipeBeforeLBScript, $GUI_ENABLE)
	Else
		GUICtrlSetState($lblTHSnipeBeforeLBTiles, $GUI_DISABLE)
		GUICtrlSetState($txtTHSnipeBeforeLBTiles, $GUI_DISABLE)
		GUICtrlSetState($cmbTHSnipeBeforeLBScript, $GUI_DISABLE)
	EndIf
EndFunc

Func chkattackHoursE1()
	If GUICtrlRead($chkattackHoursE1) = $GUI_CHECKED And GUICtrlRead($chkattackHours0) = $GUI_CHECKED Then
		For $i = $chkattackHours0 To $chkattackHours11
			GUICtrlSetState($i, $GUI_UNCHECKED)
		Next
	Else
		For $i = $chkattackHours0 To $chkattackHours11
			GUICtrlSetState($i, $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($chkattackHoursE1, $GUI_UNCHECKED)
EndFunc   ;==>chkattackHoursE1

Func chkattackHoursE2()
	If GUICtrlRead($chkattackHoursE2) = $GUI_CHECKED And GUICtrlRead($chkattackHours12) = $GUI_CHECKED Then
		For $i = $chkattackHours12 To $chkattackHours23
			GUICtrlSetState($i, $GUI_UNCHECKED)
		Next
	Else
		For $i = $chkattackHours12 To $chkattackHours23
			GUICtrlSetState($i, $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($chkattackHoursE2, $GUI_UNCHECKED)
EndFunc   ;==>chkattackHoursE2

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

Func chkSearchReduction()
	If GUICtrlRead($chkSearchReduction) = $GUI_CHECKED Then
		_GUICtrlEdit_SetReadOnly($txtSearchReduceCount, False)
		_GUICtrlEdit_SetReadOnly($txtSearchReduceGold, False)
		_GUICtrlEdit_SetReadOnly($txtSearchReduceElixir, False)
		_GUICtrlEdit_SetReadOnly($txtSearchReduceGoldPlusElixir, False)
		_GUICtrlEdit_SetReadOnly($txtSearchReduceDark, False)
		_GUICtrlEdit_SetReadOnly($txtSearchReduceTrophy, False)
	Else
		_GUICtrlEdit_SetReadOnly($txtSearchReduceCount, True)
		_GUICtrlEdit_SetReadOnly($txtSearchReduceGold, True)
		_GUICtrlEdit_SetReadOnly($txtSearchReduceGoldPlusElixir, True)
		_GUICtrlEdit_SetReadOnly($txtSearchReduceElixir, True)
		_GUICtrlEdit_SetReadOnly($txtSearchReduceDark, True)
		_GUICtrlEdit_SetReadOnly($txtSearchReduceTrophy, True)
	EndIf
EndFunc   ;==>chkSearchReduction

; Func chkBullyMode()
	; If GUICtrlRead($Bullycheck) = $GUI_CHECKED Then
		; GUISetState(@SW_SHOW, $grpBullyAtkCombo)
		; GUISetState(@SW_SHOW, $lblBullyMode)
		; GUISetState(@SW_SHOW, $txtATBullyMode)
		; GUISetState(@SW_SHOW, $lblATBullyMode)
		; GUISetState(@SW_SHOW, $cmbYourTH)
		; GUISetState(@SW_SHOW, $radUseDBAttack)
		; GUISetState(@SW_SHOW, $radUseLBAttack)
	; Else
		; GUISetState(@SW_HIDE, $grpBullyAtkCombo)
		; GUISetState(@SW_HIDE, $lblBullyMode)
		; GUISetState(@SW_HIDE, $txtATBullyMode)
		; GUISetState(@SW_HIDE, $lblATBullyMode)
		; GUISetState(@SW_HIDE, $cmbYourTH)
		; GUISetState(@SW_HIDE, $radUseDBAttack)
		; GUISetState(@SW_HIDE, $radUseLBAttack)
	; EndIf
; EndFunc   ;==>chkBullyMode