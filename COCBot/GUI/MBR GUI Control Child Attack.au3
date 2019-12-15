; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GkevinOD (2014)
; Modified ......: Hervidero (2015), CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func cmbDBAlgorithm()
	Local $iCmbValue = _GUICtrlComboBox_GetCurSel($g_hCmbDBAlgorithm)
	; Algorithm Alltroops
	_GUI_Value_STATE($iCmbValue = 1 ? "SHOW" : "HIDE", $g_aGroupAttackDBSpell & "#" & $groupIMGAttackDBSpell)

	If BitAND(GUICtrlGetState($g_hGUI_DEADBASE), $GUI_SHOW) And GUICtrlRead($g_hGUI_DEADBASE_TAB) = 1 Then ; fix ghosting during control applyConfig
		Select
			Case $iCmbValue = 0 ; Standard Attack
				GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_DEADBASE_ATTACK_STANDARD)
				GUISetState(@SW_HIDE, $g_hGUI_DEADBASE_ATTACK_SCRIPTED)
				GUISetState(@SW_HIDE,$g_hGUI_DEADBASE_ATTACK_SMARTFARM)
			Case $iCmbValue = 1 ; Scripted Attack
				GUISetState(@SW_HIDE, $g_hGUI_DEADBASE_ATTACK_STANDARD)
				GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_DEADBASE_ATTACK_SCRIPTED)
				GUISetState(@SW_HIDE,$g_hGUI_DEADBASE_ATTACK_SMARTFARM)
			Case $iCmbValue = 2 ; Smart Farm Attack
				GUISetState(@SW_HIDE, $g_hGUI_DEADBASE_ATTACK_STANDARD)
				GUISetState(@SW_HIDE, $g_hGUI_DEADBASE_ATTACK_SCRIPTED)
				GUISetState(@SW_SHOWNOACTIVATE,$g_hGUI_DEADBASE_ATTACK_SMARTFARM)
			Case Else
				GUISetState(@SW_HIDE, $g_hGUI_DEADBASE_ATTACK_STANDARD)
				GUISetState(@SW_HIDE, $g_hGUI_DEADBASE_ATTACK_SCRIPTED)
				GUISetState(@SW_HIDE,$g_hGUI_DEADBASE_ATTACK_SMARTFARM)
		EndSelect
	EndIf
EndFunc   ;==>cmbDBAlgorithm

Func cmbABAlgorithm()
	Local $iCmbValue = _GUICtrlComboBox_GetCurSel($g_hcmbABAlgorithm)
	_GUI_Value_STATE($iCmbValue = 1 ? "SHOW" : "HIDE", $groupAttackABSpell & "#" & $groupIMGAttackABSpell)

	If BitAND(GUICtrlGetState($g_hGUI_ACTIVEBASE), $GUI_SHOW) And GUICtrlRead($g_hGUI_ACTIVEBASE_TAB) = 1 Then ; fix ghosting during control applyConfig
		Select
			Case $iCmbValue = 0 ; Standard Attack
				GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_ACTIVEBASE_ATTACK_STANDARD)
				GUISetState(@SW_HIDE, $g_hGUI_ACTIVEBASE_ATTACK_SCRIPTED)
			Case $iCmbValue = 1 ; Scripted Attack
				GUISetState(@SW_HIDE, $g_hGUI_ACTIVEBASE_ATTACK_STANDARD)
				GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_ACTIVEBASE_ATTACK_SCRIPTED)
			Case Else
				GUISetState(@SW_HIDE, $g_hGUI_ACTIVEBASE_ATTACK_STANDARD)
				GUISetState(@SW_HIDE, $g_hGUI_ACTIVEBASE_ATTACK_SCRIPTED)
		EndSelect
	EndIf
EndFunc   ;==>cmbABAlgorithm

Func chkABWardenAttack()
	If GUICtrlRead($g_hChkABWardenAttack) = $GUI_CHECKED Then
		GUICtrlSetState($g_hCmbABWardenMode, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hCmbABWardenMode, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkABWardenAttack

Func chkDBWardenAttack()
	If GUICtrlRead($g_hChkDBWardenAttack) = $GUI_CHECKED Then
		GUICtrlSetState($g_hCmbDBWardenMode, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hCmbDBWardenMode, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkDBWardenAttack

Func chkABDropCC()
	If GUICtrlRead($g_hChkABDropCC) = $GUI_CHECKED Then
		GUICtrlSetState($g_hcmbABSiege, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hcmbABSiege, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkABDropCC

Func chkDBDropCC()
	If GUICtrlRead($g_hChkDBDropCC) = $GUI_CHECKED Then
		GUICtrlSetState($g_hcmbDBSiege, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hcmbDBSiege, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkDBDropCC

Func chkAttackNow()
	If GUICtrlRead($g_hChkAttackNow) = $GUI_CHECKED Then
		$g_bSearchAttackNowEnable = True
		GUICtrlSetState($g_hLblAttackNow, $GUI_ENABLE)
		GUICtrlSetState($g_hLblAttackNowSec, $GUI_ENABLE)
		GUICtrlSetState($g_hCmbAttackNowDelay, $GUI_ENABLE)
		GUICtrlSetState($g_hCmbAttackNowDelay, $GUI_ENABLE)
	Else
		$g_bSearchAttackNowEnable = False
		GUICtrlSetState($g_hLblAttackNow, $GUI_DISABLE)
		GUICtrlSetState($g_hLblAttackNowSec, $GUI_DISABLE)
		GUICtrlSetState($g_hCmbAttackNowDelay, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkAttackNow

Func radHerosApply()
	GUICtrlSetState($g_hRadAutoQueenAbility, $g_iActivateQueen = 0 ? $GUI_CHECKED : $GUI_UNCHECKED)
	GUICtrlSetState($g_hRadManQueenAbility, $g_iActivateQueen = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
	GUICtrlSetState($g_hRadBothQueenAbility, $g_iActivateQueen = 2 ? $GUI_CHECKED : $GUI_UNCHECKED)
	GUICtrlSetData($g_hTxtManQueenAbility, ($g_iDelayActivateQueen / 1000))

	GUICtrlSetState($g_hRadAutoKingAbility, $g_iActivateKing = 0 ? $GUI_CHECKED : $GUI_UNCHECKED)
	GUICtrlSetState($g_hRadManKingAbility, $g_iActivateKing = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
	GUICtrlSetState($g_hRadBothKingAbility, $g_iActivateKing = 2 ? $GUI_CHECKED : $GUI_UNCHECKED)
	GUICtrlSetData($g_hTxtManKingAbility, ($g_iDelayActivateKing / 1000))

	GUICtrlSetState($g_hRadAutoWardenAbility, $g_iActivateWarden = 0 ? $GUI_CHECKED : $GUI_UNCHECKED)
	GUICtrlSetState($g_hRadManWardenAbility, $g_iActivateWarden = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
	GUICtrlSetState($g_hRadBothWardenAbility, $g_iActivateWarden = 2 ? $GUI_CHECKED : $GUI_UNCHECKED)
	GUICtrlSetData($g_hTxtManWardenAbility, ($g_iDelayActivateWarden / 1000))

	GUICtrlSetState($g_hRadAutoChampionAbility, $g_iActivateChampion = 0 ? $GUI_CHECKED : $GUI_UNCHECKED)
	GUICtrlSetState($g_hRadManChampionAbility, $g_iActivateChampion = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
	GUICtrlSetState($g_hRadBothChampionAbility, $g_iActivateChampion = 2 ? $GUI_CHECKED : $GUI_UNCHECKED)
	GUICtrlSetData($g_hTxtManChampionAbility, ($g_iDelayActivateChampion / 1000))
EndFunc   ;==>radHerosApply

Func chkattackHoursE1()
	If GUICtrlRead($g_ahChkAttackHoursE1) = $GUI_CHECKED And IschkattackHoursE1() Then
		For $i = 0 To 11
			GUICtrlSetState($g_ahChkAttackHours[$i], $GUI_UNCHECKED)
		Next
	Else
		For $i = 0 To 11
			GUICtrlSetState($g_ahChkAttackHours[$i], $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($g_ahChkAttackHoursE1, $GUI_UNCHECKED)
EndFunc   ;==>chkattackHoursE1

Func IschkattackHoursE1()
	For $i = 0 To 11
		If GUICtrlRead($g_ahChkAttackHours[$i]) = $GUI_CHECKED Then Return True
	Next
	Return False
EndFunc   ;==>IschkattackHoursE1

Func chkattackHoursE2()
	If GUICtrlRead($g_ahChkAttackHoursE2) = $GUI_CHECKED And IschkattackHoursE2() Then
		For $i = 12 To 23
			GUICtrlSetState($g_ahChkAttackHours[$i], $GUI_UNCHECKED)
		Next
	Else
		For $i = 12 To 23
			GUICtrlSetState($g_ahChkAttackHours[$i], $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($g_ahChkAttackHoursE2, $GUI_UNCHECKED)
EndFunc   ;==>chkattackHoursE2

Func IschkattackHoursE2()
	For $i = 12 To 23
		If GUICtrlRead($g_ahChkAttackHours[$i]) = $GUI_CHECKED Then Return True
	Next
	Return False
EndFunc   ;==>IschkattackHoursE2

Func chkattackWeekDaysE()
	If GUICtrlRead($g_ahChkAttackWeekdaysE) = $GUI_CHECKED And IschkAttackWeekdays() Then
		For $i = 0 To 6
			GUICtrlSetState($g_ahChkAttackWeekdays[$i], $GUI_UNCHECKED)
		Next
	Else
		For $i = 0 To 6
			GUICtrlSetState($g_ahChkAttackWeekdays[$i], $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($g_ahChkAttackWeekdaysE, $GUI_UNCHECKED)
EndFunc   ;==>chkattackWeekDaysE

Func IschkAttackWeekdays()
	For $i = 0 To 6
		If GUICtrlRead($g_ahChkAttackWeekdays[$i]) = $GUI_CHECKED Then Return True
	Next
	Return False
EndFunc   ;==>IschkAttackWeekdays

Func chkAttackPlannerEnable()
	If GUICtrlRead($g_hChkAttackPlannerEnable) = $GUI_CHECKED Then
		$g_bAttackPlannerEnable = True

		If GUICtrlRead($g_hChkAttackPlannerCloseAll) = $GUI_UNCHECKED Then
			GUICtrlSetState($g_hChkAttackPlannerCloseAll, $GUI_ENABLE)
			GUICtrlSetState($g_hChkAttackPlannerCloseCoC, $GUI_ENABLE)
			GUICtrlSetState($g_hChkAttackPlannerSuspendComputer, $GUI_ENABLE)
		Else
			GUICtrlSetState($g_hChkAttackPlannerCloseAll, $GUI_ENABLE)
			GUICtrlSetState($g_hChkAttackPlannerCloseCoC, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		EndIf

		GUICtrlSetState($g_hChkAttackPlannerRandom, $GUI_ENABLE)
		GUICtrlSetState($g_hChkAttackPlannerDayLimit, $GUI_ENABLE)
		chkAttackPlannerDayLimit()
		cmbAttackPlannerRandom() ; check and update label is needed
		If GUICtrlRead($g_hChkAttackPlannerRandom) = $GUI_CHECKED Then
			GUICtrlSetState($g_hCmbAttackPlannerRandom, $GUI_ENABLE)
			GUICtrlSetState($g_hLbAttackPlannerRandom, $GUI_ENABLE)

			For $i = 0 To 6
				GUICtrlSetState($g_ahChkAttackWeekdays[$i], $GUI_DISABLE)
			Next
			GUICtrlSetState($g_ahChkAttackWeekdaysE, $GUI_DISABLE)

			For $i = 0 To 23
				GUICtrlSetState($g_ahChkAttackHours[$i], $GUI_DISABLE)
			Next
			GUICtrlSetState($g_ahChkAttackHoursE1, $GUI_DISABLE)
			GUICtrlSetState($g_ahChkAttackHoursE2, $GUI_DISABLE)
		Else
			GUICtrlSetState($g_hCmbAttackPlannerRandom, $GUI_DISABLE)
			GUICtrlSetState($g_hLbAttackPlannerRandom, $GUI_DISABLE)

			For $i = 0 To 6
				GUICtrlSetState($g_ahChkAttackWeekdays[$i], $GUI_ENABLE)
			Next
			GUICtrlSetState($g_ahChkAttackWeekdaysE, $GUI_ENABLE)

			For $i = 0 To 23
				GUICtrlSetState($g_ahChkAttackHours[$i], $GUI_ENABLE)
			Next
			GUICtrlSetState($g_ahChkAttackHoursE1, $GUI_ENABLE)
			GUICtrlSetState($g_ahChkAttackHoursE2, $GUI_ENABLE)
		EndIf
	Else
		$g_bAttackPlannerEnable = False
		GUICtrlSetState($g_hChkAttackPlannerCloseCoC, $GUI_DISABLE)
		GUICtrlSetState($g_hChkAttackPlannerSuspendComputer, $GUI_DISABLE)
		GUICtrlSetState($g_hChkAttackPlannerCloseAll, $GUI_DISABLE)
		GUICtrlSetState($g_hChkAttackPlannerRandom, $GUI_DISABLE)
		GUICtrlSetState($g_hCmbAttackPlannerRandom, $GUI_DISABLE)
		GUICtrlSetState($g_hLbAttackPlannerRandom, $GUI_DISABLE)
		GUICtrlSetState($g_hChkAttackPlannerDayLimit, $GUI_DISABLE)
		GUICtrlSetState($g_hCmbAttackPlannerDayMin, $GUI_DISABLE)
		GUICtrlSetState($g_hCmbAttackPlannerDayMax, $GUI_DISABLE)
		For $i = 0 To 6
			GUICtrlSetState($g_ahChkAttackWeekdays[$i], $GUI_DISABLE)
		Next
		GUICtrlSetState($g_ahChkAttackWeekdaysE, $GUI_DISABLE)

		For $i = 0 To 23
			GUICtrlSetState($g_ahChkAttackHours[$i], $GUI_DISABLE)
		Next
		GUICtrlSetState($g_ahChkAttackHoursE2, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkAttackPlannerEnable

Func chkAttackPlannerCloseCoC()
	If GUICtrlRead($g_hChkAttackPlannerCloseCoC) = $GUI_CHECKED Then
		$g_bAttackPlannerCloseCoC = True
	Else
		$g_bAttackPlannerCloseCoC = False
	EndIf
EndFunc   ;==>chkAttackPlannerCloseCoC

Func chkAttackPlannerSuspendComputer()
	If GUICtrlRead($g_hChkAttackPlannerSuspendComputer) = $GUI_CHECKED Then
		$g_bAttackPlannerSuspendComputer = True
	Else
		$g_bAttackPlannerSuspendComputer = False
	EndIf
EndFunc   ;==>chkAttackPlannerSuspendComputer

Func chkAttackPlannerCloseAll()
	If GUICtrlRead($g_hChkAttackPlannerCloseAll) = $GUI_CHECKED Then
		$g_bAttackPlannerCloseAll = True
		GUICtrlSetState($g_hChkAttackPlannerCloseCoC, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
	Else
		$g_bAttackPlannerCloseAll = False
		GUICtrlSetState($g_hChkAttackPlannerCloseCoC, $GUI_ENABLE)
	EndIf
EndFunc   ;==>chkAttackPlannerCloseAll

Func chkAttackPlannerRandom()
	If GUICtrlRead($g_hChkAttackPlannerRandom) = $GUI_CHECKED Then
		$g_bAttackPlannerRandomEnable = True
		GUICtrlSetState($g_hCmbAttackPlannerRandom, $GUI_ENABLE)
		GUICtrlSetState($g_hLbAttackPlannerRandom, $GUI_ENABLE)
		For $i = 0 To 6
			GUICtrlSetState($g_ahChkAttackWeekdays[$i], $GUI_DISABLE)
		Next
		GUICtrlSetState($g_ahChkAttackWeekdaysE, $GUI_DISABLE)

		For $i = 0 To 23
			GUICtrlSetState($g_ahChkAttackHours[$i], $GUI_DISABLE)
		Next
		GUICtrlSetState($g_ahChkAttackHoursE1, $GUI_DISABLE)
		GUICtrlSetState($g_ahChkAttackHoursE2, $GUI_DISABLE)
	Else
		$g_bAttackPlannerRandomEnable = False
		chkAttackPlannerEnable()
	EndIf
EndFunc   ;==>chkAttackPlannerRandom

Func cmbAttackPlannerRandom()
	$g_iAttackPlannerRandomTime = Int(_GUICtrlComboBox_GetCurSel($g_hCmbAttackPlannerRandom))
	GUICtrlSetData($g_hLbAttackPlannerRandom, $g_iAttackPlannerRandomTime > 0 ? GetTranslatedFileIni("MBR Global GUI Design", "hrs", -1) : GetTranslatedFileIni("MBR Global GUI Design", "hr", -1))
EndFunc   ;==>cmbAttackPlannerRandom

Func chkAttackPlannerDayLimit()
	If GUICtrlRead($g_hChkAttackPlannerDayLimit) = $GUI_CHECKED Then
		$g_bAttackPlannerDayLimit = True
		GUICtrlSetState($g_hCmbAttackPlannerDayMin, $GUI_ENABLE)
		GUICtrlSetState($g_hLbAttackPlannerDayLimit, $GUI_ENABLE)
		GUICtrlSetState($g_hCmbAttackPlannerDayMax, $GUI_ENABLE)
	Else
		$g_bAttackPlannerDayLimit = False
		GUICtrlSetState($g_hCmbAttackPlannerDayMin, $GUI_DISABLE)
		GUICtrlSetState($g_hLbAttackPlannerDayLimit, $GUI_DISABLE)
		GUICtrlSetState($g_hCmbAttackPlannerDayMax, $GUI_DISABLE)
	EndIf
	_cmbAttackPlannerDayLimit()
EndFunc   ;==>chkAttackPlannerDayLimit

Func cmbAttackPlannerDayMin()
	If Int(GUICtrlRead($g_hCmbAttackPlannerDayMax)) < Int(GUICtrlRead($g_hCmbAttackPlannerDayMin)) Then
		GUICtrlSetData($g_hCmbAttackPlannerDayMin, GUICtrlRead($g_hCmbAttackPlannerDayMax))
	EndIf
	$g_iAttackPlannerDayMin = Int(GUICtrlRead($g_hCmbAttackPlannerDayMin))
	_cmbAttackPlannerDayLimit()
EndFunc   ;==>cmbAttackPlannerDayMin

Func cmbAttackPlannerDayMax()
	If Int(GUICtrlRead($g_hCmbAttackPlannerDayMax)) < Int(GUICtrlRead($g_hCmbAttackPlannerDayMin)) Then
		GUICtrlSetData($g_hCmbAttackPlannerDayMax, GUICtrlRead($g_hCmbAttackPlannerDayMin))
	EndIf
	$g_iAttackPlannerDayMax = Int(GUICtrlRead($g_hCmbAttackPlannerDayMax))
	_cmbAttackPlannerDayLimit()
EndFunc   ;==>cmbAttackPlannerDayMax

Func _cmbAttackPlannerDayLimit()
	Switch Int(GUICtrlRead($g_hCmbAttackPlannerDayMin))
		Case 0 To 15
			GUICtrlSetBkColor($g_hCmbAttackPlannerDayMin, $COLOR_MONEYGREEN)
		Case 16 To 20
			GUICtrlSetBkColor($g_hCmbAttackPlannerDayMin, $COLOR_YELLOW)
		Case 21 To 999
			GUICtrlSetBkColor($g_hCmbAttackPlannerDayMin, $COLOR_RED)
	EndSwitch
	Switch Int(GUICtrlRead($g_hCmbAttackPlannerDayMax))
		Case 0 To 15
			GUICtrlSetBkColor($g_hCmbAttackPlannerDayMax, $COLOR_MONEYGREEN)
		Case 16 To 25
			GUICtrlSetBkColor($g_hCmbAttackPlannerDayMax, $COLOR_YELLOW)
		Case 26 To 999
			GUICtrlSetBkColor($g_hCmbAttackPlannerDayMax, $COLOR_RED)
	EndSwitch
EndFunc   ;==>_cmbAttackPlannerDayLimit

Func chkDropCCHoursEnable()
	Local $bChk = GUICtrlRead($g_hChkDropCCHoursEnable) = $GUI_CHECKED

	$g_bPlannedDropCCHoursEnable = ($bChk ? 1 : 0)
	For $i = 0 To 23
		GUICtrlSetState($g_ahChkDropCCHours[$i], $bChk ? $GUI_ENABLE : $GUI_DISABLE)
	Next
	GUICtrlSetState($g_ahChkDropCCHoursE1, $bChk ? $GUI_ENABLE : $GUI_DISABLE)
	GUICtrlSetState($g_ahChkDropCCHoursE2, $bChk ? $GUI_ENABLE : $GUI_DISABLE)
EndFunc   ;==>chkDropCCHoursEnable

Func chkDropCCHoursE1()
	Local $bChk = GUICtrlRead($g_ahChkDropCCHoursE1) = $GUI_CHECKED And GUICtrlRead($g_ahChkDropCCHours[0]) = $GUI_CHECKED

	For $i = 0 To 11
		GUICtrlSetState($g_ahChkDropCCHours[$i], $bChk ? $GUI_UNCHECKED : $GUI_CHECKED)
	Next
	Sleep(300)
	GUICtrlSetState($g_ahChkDropCCHoursE1, $GUI_UNCHECKED)
EndFunc   ;==>chkDropCCHoursE1

Func chkDropCCHoursE2()
	Local $bChk = GUICtrlRead($g_ahChkDropCCHoursE2) = $GUI_CHECKED And GUICtrlRead($g_ahChkDropCCHours[12]) = $GUI_CHECKED

	For $i = 12 To 23
		GUICtrlSetState($g_ahChkDropCCHours[$i], $bChk ? $GUI_UNCHECKED : $GUI_CHECKED)
	Next
	Sleep(300)
	GUICtrlSetState($g_ahChkDropCCHoursE2, $GUI_UNCHECKED)
EndFunc   ;==>chkDropCCHoursE2

Func chkShareAttack()
	If GUICtrlRead($g_hChkShareAttack) = $GUI_CHECKED Then
		For $i = $g_hLblShareMinLoot To $g_hTxtShareMessage
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else ;If GUICtrlRead($chkUnbreakable) = $GUI_UNCHECKED Then
		For $i = $g_hLblShareMinLoot To $g_hTxtShareMessage
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>chkShareAttack

Func chkSearchReduction()
	If GUICtrlRead($g_hChkSearchReduction) = $GUI_CHECKED Then
		_GUICtrlEdit_SetReadOnly($g_hTxtSearchReduceCount, False)
		_GUICtrlEdit_SetReadOnly($g_hTxtSearchReduceGold, False)
		_GUICtrlEdit_SetReadOnly($g_hTxtSearchReduceElixir, False)
		_GUICtrlEdit_SetReadOnly($g_hTxtSearchReduceGoldPlusElixir, False)
		_GUICtrlEdit_SetReadOnly($g_hTxtSearchReduceDark, False)
		_GUICtrlEdit_SetReadOnly($g_hTxtSearchReduceTrophy, False)
	Else
		_GUICtrlEdit_SetReadOnly($g_hTxtSearchReduceCount, True)
		_GUICtrlEdit_SetReadOnly($g_hTxtSearchReduceGold, True)
		_GUICtrlEdit_SetReadOnly($g_hTxtSearchReduceGoldPlusElixir, True)
		_GUICtrlEdit_SetReadOnly($g_hTxtSearchReduceElixir, True)
		_GUICtrlEdit_SetReadOnly($g_hTxtSearchReduceDark, True)
		_GUICtrlEdit_SetReadOnly($g_hTxtSearchReduceTrophy, True)
	EndIf
EndFunc   ;==>chkSearchReduction

Func sldMaxVSDelay()
	$g_iSearchDelayMax = GUICtrlRead($g_hSldMaxVSDelay)
	GUICtrlSetData($g_hLblMaxVSDelay, $g_iSearchDelayMax)
	If $g_iSearchDelayMax < $g_iSearchDelayMin Then
		GUICtrlSetData($g_hLblVSDelay, $g_iSearchDelayMax)
		GUICtrlSetData($g_hSldVSDelay, $g_iSearchDelayMax)
		$g_iSearchDelayMin = $g_iSearchDelayMax
	EndIf
	If $g_iSearchDelayMin = 1 Then
		GUICtrlSetData($g_hLblTextVSDelay, GetTranslatedFileIni("MBR Global GUI Design", "second", "second"))
	Else
		GUICtrlSetData($g_hLblTextVSDelay, GetTranslatedFileIni("MBR Global GUI Design", "seconds", "seconds"))
	EndIf
	If $g_iSearchDelayMax = 1 Then
		GUICtrlSetData($g_hLblTextMaxVSDelay, GetTranslatedFileIni("MBR Global GUI Design", "second", "second"))
	Else
		GUICtrlSetData($g_hLblTextMaxVSDelay, GetTranslatedFileIni("MBR Global GUI Design", "seconds", "seconds"))
	EndIf
EndFunc   ;==>sldMaxVSDelay

Func sldVSDelay()
	$g_iSearchDelayMin = GUICtrlRead($g_hSldVSDelay)
	GUICtrlSetData($g_hLblVSDelay, $g_iSearchDelayMin)
	If $g_iSearchDelayMin > $g_iSearchDelayMax Then
		GUICtrlSetData($g_hLblMaxVSDelay, $g_iSearchDelayMin)
		GUICtrlSetData($g_hSldMaxVSDelay, $g_iSearchDelayMin)
		$g_iSearchDelayMax = $g_iSearchDelayMin
	EndIf
	If $g_iSearchDelayMin = 1 Then
		GUICtrlSetData($g_hLblTextVSDelay, GetTranslatedFileIni("MBR Global GUI Design", "second", "second"))
	Else
		GUICtrlSetData($g_hLblTextVSDelay, GetTranslatedFileIni("MBR Global GUI Design", "seconds", "seconds"))
	EndIf
	If $g_iSearchDelayMax = 1 Then
		GUICtrlSetData($g_hLblTextMaxVSDelay, GetTranslatedFileIni("MBR Global GUI Design", "second", "second"))
	Else
		GUICtrlSetData($g_hLblTextMaxVSDelay, GetTranslatedFileIni("MBR Global GUI Design", "seconds", "seconds"))
	EndIf
EndFunc   ;==>sldVSDelay

Func dbCheck()
	$g_abAttackTypeEnable[$DB] = (GUICtrlRead($g_hChkDeadbase) = $GUI_CHECKED)

	If IsBotLaunched() Then _GUICtrlTab_SetCurFocus($g_hGUI_SEARCH_TAB, 0) ; activate deadbase tab
	If BitAND(GUICtrlRead($g_hChkDBActivateSearches), GUICtrlRead($g_hChkDBActivateTropies), GUICtrlRead($g_hChkDBActivateCamps), GUICtrlRead($g_hChkDBSpellsWait)) = $GUI_UNCHECKED Then
		GUICtrlSetState($g_hChkDBActivateSearches, $GUI_CHECKED)
		chkDBActivateSearches() ; this includes a call to dbCheckall() -> tabSEARCH()
	Else
		tabSEARCH() ; just call tabSEARCH()
	EndIf
EndFunc   ;==>dbCheck

Func abCheck()
	$g_abAttackTypeEnable[$LB] = (GUICtrlRead($g_hChkActivebase) = $GUI_CHECKED)

	If IsBotLaunched() Then _GUICtrlTab_SetCurFocus($g_hGUI_SEARCH_TAB, 1)
	If BitAND(GUICtrlRead($g_hChkABActivateSearches), GUICtrlRead($g_hChkABActivateTropies), GUICtrlRead($g_hChkABActivateCamps), GUICtrlRead($g_hChkABSpellsWait)) = $GUI_UNCHECKED Then
		GUICtrlSetState($g_hChkABActivateSearches, $GUI_CHECKED)
		chkABActivateSearches() ; this includes a call to abCheckall() -> tabSEARCH()
	Else
		tabSEARCH() ; just call tabSEARCH()
	EndIf
EndFunc   ;==>abCheck

Func bullyCheck()
	$g_abAttackTypeEnable[$TB] = (GUICtrlRead($g_hChkBully) = $GUI_CHECKED)

	If IsBotLaunched() Then _GUICtrlTab_SetCurFocus($g_hGUI_SEARCH_TAB, 3)
	tabSEARCH()
EndFunc   ;==>bullyCheck
