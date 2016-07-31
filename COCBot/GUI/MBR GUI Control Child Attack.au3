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
	Local $iCmbValue = _GUICtrlComboBox_GetCurSel($cmbDBAlgorithm)
	; Algorithm Alltroops
	If $iCmbValue = 1 Or $iCmbValue = 2 Then ;show spells if milking because after milking you can continue to attack with thsnipe or standard attack where you can use spells
		_GUI_Value_STATE("SHOW", $groupAttackDBSpell & "#" & $groupIMGAttackDBSpell)
	Else
		_GUI_Value_STATE("HIDE", $groupAttackDBSpell & "#" & $groupIMGAttackDBSpell)
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
EndFunc   ;==>cmbDBAlgorithm

Func cmbABAlgorithm()
	Local $iCmbValue = _GUICtrlComboBox_GetCurSel($cmbABAlgorithm)
	If $iCmbValue = 1 Then
		_GUI_Value_STATE("SHOW", $groupAttackABSpell & "#" & $groupIMGAttackABSpell)
	Else
		_GUI_Value_STATE("HIDE", $groupAttackABSpell & "#" & $groupIMGAttackABSpell)
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
EndFunc   ;==>cmbABAlgorithm

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
EndFunc   ;==>chkTHSnipeBeforeDBEnable

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
EndFunc   ;==>chkTHSnipeBeforeLBEnable

Func chkattackHoursE1()
	If GUICtrlRead($chkattackHoursE1) = $GUI_CHECKED And IschkattackHoursE1() Then
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

Func IschkattackHoursE1()
	For $i = $chkattackHours0 To $chkattackHours11
		If GUICtrlRead($i) = $GUI_CHECKED Then Return True
	Next
	Return False
EndFunc   ;==>IschkattackHoursE1

Func chkattackHoursE2()
	If GUICtrlRead($chkattackHoursE2) = $GUI_CHECKED And IschkattackHoursE2() Then
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

Func IschkattackHoursE2()
	For $i = $chkattackHours12 To $chkattackHours23
		If GUICtrlRead($i) = $GUI_CHECKED Then Return True
	Next
	Return False
EndFunc   ;==>IschkattackHoursE2

Func chkattackWeekDaysE()
	If GUICtrlRead($chkattackWeekDaysE) = $GUI_CHECKED And IschkAttackWeekdays() Then
		For $i = $chkAttackWeekdays0 To $chkAttackWeekdays6
			GUICtrlSetState($i, $GUI_UNCHECKED)
		Next
	Else
		For $i = $chkAttackWeekdays0 To $chkAttackWeekdays6
			GUICtrlSetState($i, $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($chkattackWeekDaysE, $GUI_UNCHECKED)
EndFunc   ;==>chkattackWeekDaysE

Func IschkAttackWeekdays()
	For $i = $chkAttackWeekdays0 To $chkAttackWeekdays6
		If GUICtrlRead($i) = $GUI_CHECKED Then Return True
	Next
	Return False
EndFunc   ;==>IschkAttackWeekdays

Func chkAttackPlannerEnable()
	If GUICtrlRead($chkAttackPlannerEnable) = $GUI_CHECKED Then
		$ichkAttackPlannerEnable = 1
		If GUICtrlRead($chkAttackPlannerCloseAll) = $GUI_UNCHECKED Then
			GUICtrlSetState($chkAttackPlannerCloseAll, $GUI_ENABLE)
			GUICtrlSetState($chkAttackPlannerCloseCoC, $GUI_ENABLE)
		Else
			GUICtrlSetState($chkAttackPlannerCloseAll, $GUI_ENABLE)
			GUICtrlSetState($chkAttackPlannerCloseCoC, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		EndIf
		GUICtrlSetState($chkAttackPlannerRandom, $GUI_ENABLE)
		GUICtrlSetState($chkAttackPlannerDayLimit, $GUI_ENABLE)
		chkAttackPlannerDayLimit()
		cmbAttackPlannerRandom() ; check and update label is needed
		If GUICtrlRead($chkAttackPlannerRandom) = $GUI_CHECKED Then
			GUICtrlSetState($cmbAttackPlannerRandom, $GUI_ENABLE)
			GUICtrlSetState($lbAttackPlannerRandom, $GUI_ENABLE)
			For $i = $chkAttackWeekdays0 To $chkattackWeekDaysE
				GUICtrlSetState($i, $GUI_DISABLE)
			Next
			For $i = $chkattackHours0 To $chkattackHoursE1
				GUICtrlSetState($i, $GUI_DISABLE)
			Next
			For $i = $chkAttackHours12 To $chkattackHoursE2
				GUICtrlSetState($i, $GUI_DISABLE)
			Next
		Else
			GUICtrlSetState($cmbAttackPlannerRandom, $GUI_DISABLE)
			GUICtrlSetState($lbAttackPlannerRandom, $GUI_DISABLE)
			For $i = $chkAttackWeekdays0 To $chkattackWeekDaysE
				GUICtrlSetState($i, $GUI_ENABLE)
			Next
			For $i = $chkattackHours0 To $chkattackHoursE1
				GUICtrlSetState($i, $GUI_ENABLE)
			Next
			For $i = $chkAttackHours12 To $chkattackHoursE2
				GUICtrlSetState($i, $GUI_ENABLE)
			Next
		EndIf
	Else
		$ichkAttackPlannerEnable = 0
		GUICtrlSetState($chkAttackPlannerCloseCoC, $GUI_DISABLE)
		GUICtrlSetState($chkAttackPlannerCloseAll, $GUI_DISABLE)
		GUICtrlSetState($chkAttackPlannerRandom, $GUI_DISABLE)
		GUICtrlSetState($cmbAttackPlannerRandom, $GUI_DISABLE)
		GUICtrlSetState($lbAttackPlannerRandom, $GUI_DISABLE)
		GUICtrlSetState($chkAttackPlannerDayLimit, $GUI_DISABLE)
		GUICtrlSetState($cmbAttackPlannerDayMin, $GUI_DISABLE)
		GUICtrlSetState($cmbAttackPlannerDayMax, $GUI_DISABLE)
		For $i = $chkAttackWeekdays0 To $chkattackWeekDaysE
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
		For $i = $chkattackHours0 To $chkattackHoursE1
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
		For $i = $chkAttackHours12 To $chkattackHoursE2
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>chkAttackPlannerEnable

Func chkAttackPlannerCloseCoC()
	If GUICtrlRead($chkAttackPlannerCloseCoC) = $GUI_CHECKED Then
		$ichkAttackPlannerCloseCoC = 1
	Else
		$ichkAttackPlannerCloseCoC = 0
	EndIf
EndFunc   ;==>chkAttackPlannerCloseCoC

Func chkAttackPlannerCloseAll()
	If GUICtrlRead($chkAttackPlannerCloseAll) = $GUI_CHECKED Then
		$ichkAttackPlannerCloseAll = 1
		GUICtrlSetState($chkAttackPlannerCloseCoC, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
	Else
		$ichkAttackPlannerCloseAll = 0
		GUICtrlSetState($chkAttackPlannerCloseCoC, $GUI_ENABLE)
	EndIf
EndFunc   ;==>chkAttackPlannerCloseAll

Func chkAttackPlannerRandom()
	If GUICtrlRead($chkAttackPlannerRandom) = $GUI_CHECKED Then
		$ichkAttackPlannerRandom = 1
		GUICtrlSetState($cmbAttackPlannerRandom, $GUI_ENABLE)
		GUICtrlSetState($lbAttackPlannerRandom, $GUI_ENABLE)
		For $i = $chkAttackWeekdays0 To $chkattackWeekDaysE
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
		For $i = $chkattackHours0 To $chkattackHoursE1
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
		For $i = $chkAttackHours12 To $chkattackHoursE2
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	Else
		$ichkAttackPlannerRandom = 0
		chkAttackPlannerEnable()
	EndIf
EndFunc   ;==>chkAttackPlannerRandom

Func cmbAttackPlannerRandom()
	$icmbAttackPlannerRandom = Int(_GUICtrlComboBox_GetCurSel($cmbAttackPlannerRandom))
	If $icmbAttackPlannerRandom > 0 Then
		GUICtrlSetData($lbAttackPlannerRandom, GetTranslated(603, 37, -1))
	Else
		GUICtrlSetData($lbAttackPlannerRandom, GetTranslated(603, 38, "hr"))
	EndIf
EndFunc   ;==>cmbAttackPlannerRandom

Func chkAttackPlannerDayLimit()
	If GUICtrlRead($chkAttackPlannerDayLimit) = $GUI_CHECKED Then
		$ichkAttackPlannerDayLimit = 1
		GUICtrlSetState($cmbAttackPlannerDayMin, $GUI_ENABLE)
		GUICtrlSetState($lbAttackPlannerDayLimit, $GUI_ENABLE)
		GUICtrlSetState($cmbAttackPlannerDayMax, $GUI_ENABLE)
	Else
		$ichkAttackPlannerDayLimit = 0
		GUICtrlSetState($cmbAttackPlannerDayMin, $GUI_DISABLE)
		GUICtrlSetState($lbAttackPlannerDayLimit, $GUI_DISABLE)
		GUICtrlSetState($cmbAttackPlannerDayMax, $GUI_DISABLE)
	EndIf
	_cmbAttackPlannerDayLimit()
EndFunc   ;==>chkAttackPlannerDayLimit

Func cmbAttackPlannerDayMin()
	If Int(GUICtrlRead($cmbAttackPlannerDayMax)) < Int(GUICtrlRead($cmbAttackPlannerDayMin)) Then
		GUICtrlSetData($cmbAttackPlannerDayMin, GUICtrlRead($cmbAttackPlannerDayMax))
	EndIf
	$icmbAttackPlannerDayMin = Int(GUICtrlRead($cmbAttackPlannerDayMin))
	_cmbAttackPlannerDayLimit()
EndFunc   ;==>cmbAttackPlannerDayMin

Func cmbAttackPlannerDayMax()
	If Int(GUICtrlRead($cmbAttackPlannerDayMax)) < Int(GUICtrlRead($cmbAttackPlannerDayMin)) Then
		GUICtrlSetData($cmbAttackPlannerDayMax, GUICtrlRead($cmbAttackPlannerDayMin))
	EndIf
	$icmbAttackPlannerDayMax = Int(GUICtrlRead($cmbAttackPlannerDayMax))
	_cmbAttackPlannerDayLimit()
EndFunc   ;==>cmbAttackPlannerDayMax

Func _cmbAttackPlannerDayLimit()
	Switch Int(GUICtrlRead($cmbAttackPlannerDayMin))
		Case 0 To 15
			GUICtrlSetBkColor($cmbAttackPlannerDayMin, $COLOR_MONEYGREEN)
		Case 16 To 20
			GUICtrlSetBkColor($cmbAttackPlannerDayMin, $COLOR_YELLOW)
		Case 21 To 999
			GUICtrlSetBkColor($cmbAttackPlannerDayMin, $COLOR_RED)
	EndSwitch
	Switch Int(GUICtrlRead($cmbAttackPlannerDayMax))
		Case 0 To 15
			GUICtrlSetBkColor($cmbAttackPlannerDayMax, $COLOR_MONEYGREEN)
		Case 16 To 25
			GUICtrlSetBkColor($cmbAttackPlannerDayMax, $COLOR_YELLOW)
		Case 26 To 999
			GUICtrlSetBkColor($cmbAttackPlannerDayMax, $COLOR_RED)
	EndSwitch
EndFunc   ;==>_cmbAttackPlannerDayLimit

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

Func sldMaxVSDelay()
	$iMaxVSDelay = GUICtrlRead($sldMaxVSDelay)
	GUICtrlSetData($lblMaxVSDelay, $iMaxVSDelay)
	If $iMaxVSDelay < $iVSDelay Then
		GUICtrlSetData($lblVSDelay, $iMaxVSDelay)
		GUICtrlSetData($sldVSDelay, $iMaxVSDelay)
		$iVSDelay = $iMaxVSDelay
	EndIf
	If $iVSDelay = 1 Then
		GUICtrlSetData($lbltxtVSDelay, GetTranslated(603, 7, "second"))
	Else
		GUICtrlSetData($lbltxtVSDelay, GetTranslated(603, 8, "seconds"))
	EndIf
	If $iMaxVSDelay = 1 Then
		GUICtrlSetData($lbltxtMaxVSDelay, GetTranslated(603, 7, "second"))
	Else
		GUICtrlSetData($lbltxtMaxVSDelay, GetTranslated(603, 8, "seconds"))
	EndIf
EndFunc   ;==>sldMaxVSDelay

Func sldVSDelay()
	$iVSDelay = GUICtrlRead($sldVSDelay)
	GUICtrlSetData($lblVSDelay, $iVSDelay)
	If $iVSDelay > $iMaxVSDelay Then
		GUICtrlSetData($lblMaxVSDelay, $iVSDelay)
		GUICtrlSetData($sldMaxVSDelay, $iVSDelay)
		$iMaxVSDelay = $iVSDelay
	EndIf
	If $iVSDelay = 1 Then
		GUICtrlSetData($lbltxtVSDelay, GetTranslated(603, 7, "second"))
	Else
		GUICtrlSetData($lbltxtVSDelay, GetTranslated(603, 8, "seconds"))
	EndIf
	If $iMaxVSDelay = 1 Then
		GUICtrlSetData($lbltxtMaxVSDelay, GetTranslated(603, 7, "second"))
	Else
		GUICtrlSetData($lbltxtMaxVSDelay, GetTranslated(603, 8, "seconds"))
	EndIf
EndFunc   ;==>sldVSDelay
