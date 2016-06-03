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

Func cmbTroopComp()
	If _GUICtrlComboBox_GetCurSel($cmbTroopComp) <> $icmbTroopComp Then
		$icmbTroopComp = _GUICtrlComboBox_GetCurSel($cmbTroopComp)
		For $i = 0 To UBound($TroopName) - 1
			Assign("Cur" & $TroopName[$i], 1)
		Next
		For $i = 0 To UBound($TroopDarkName) - 1
			Assign("Cur" & $TroopDarkName[$i], 1)
		Next
		SetComboTroopComp()
	EndIf
EndFunc   ;==>cmbTroopComp

Func cmbDarkTroopComp()
	If _GUICtrlComboBox_GetCurSel($cmbDarkTroopComp) <> $icmbDarkTroopComp Then
		$icmbDarkTroopComp = _GUICtrlComboBox_GetCurSel($cmbDarkTroopComp)
		SetComboDarkTroopComp()
	EndIf
EndFunc   ;==>cmbDarkTroopComp

Func SetComboDarkTroopComp()
	Local $bWasRedraw = SetRedrawBotWindow(False)
	Switch _GUICtrlComboBox_GetCurSel($cmbDarkTroopComp)

		Case 0
			;show all the barrack mode controls
			HideDarkCustomControls()
			ShowDarkBarrackControls()
		Case 1
			;show custom mode controls
			HideDarkBarrackControls()
			ShowDarkCustomControls()
		Case 2
			;Hide All
			HideDarkBarrackControls()
			HideDarkCustomControls()
	EndSwitch
	SetRedrawBotWindow($bWasRedraw)
EndFunc   ;==>SetComboDarkTroopComp

Func ShowDarkBarrackControls()
	_GUI_Value_STATE("SHOW", $grpDarkBarrackMode & "#" & Eval("cmbDarkBarrack1") & "#" & Eval("cmbDarkBarrack2") & "#" & Eval("lblDarkBarrack1") & "#" & Eval("lblDarkBarrack2"))
	_GUI_Value_STATE("ENABLE", Eval("cmbDarkBarrack1") & "#" & Eval("cmbDarkBarrack2"))
EndFunc   ;==>ShowDarkBarrackControls

Func ShowDarkCustomControls()
	GUICtrlSetState($grpDarkTroops, $GUI_SHOW)
	For $i = 0 To UBound($TroopDarkName) - 1
		GUICtrlSetState(Eval("txtNum" & $TroopDarkName[$i]), $GUI_SHOW)
	Next
	_GUI_Value_STATE("SHOW", $groupTroopsDark)
EndFunc   ;==>ShowDarkCustomControls

Func HideDarkBarrackControls()
	_GUI_Value_STATE("HIDE", $grpDarkBarrackMode & "#" & Eval("cmbDarkBarrack1") & "#" & Eval("cmbDarkBarrack2") & "#" & Eval("lblDarkBarrack1") & "#" & Eval("lblDarkBarrack2"))
EndFunc   ;==>HideDarkBarrackControls

Func HideDarkCustomControls()
	GUICtrlSetState($grpDarkTroops, $GUI_HIDE)
	For $i = 0 To UBound($TroopDarkName) - 1
		GUICtrlSetState(Eval("txtNum" & $TroopDarkName[$i]), $GUI_HIDE)
	Next
	_GUI_Value_STATE("HIDE", $groupTroopsDark)
EndFunc   ;==>HideDarkCustomControls

Func SetComboTroopComp()
	Local $bWasRedraw = SetRedrawBotWindow(False)
	HideBarrackControls()
	HideCustomControls()
	Switch _GUICtrlComboBox_GetCurSel($cmbTroopComp)
		Case 0
			_GUI_Value_STATE("SHOW", $groupTroopsArch & "#" & $groupTroopsTot)
			For $i = 0 To UBound($TroopName) - 1
				GUICtrlSetData(Eval("txtNum" & $TroopName[$i]), "0")
			Next
			For $i = 0 To UBound($TroopDarkName) - 1
				GUICtrlSetData(Eval("txtNum" & $TroopDarkName[$i]), "0")
			Next
			GUICtrlSetData($txtNumArch, "100")
		Case 1
			_GUI_Value_STATE("SHOW", $groupTroopsBarB & "#" & $groupTroopsTot)
			For $i = 0 To UBound($TroopName) - 1
				GUICtrlSetData(Eval("txtNum" & $TroopName[$i]), "0")
			Next
			For $i = 0 To UBound($TroopDarkName) - 1
				GUICtrlSetData(Eval("txtNum" & $TroopDarkName[$i]), "0")
			Next
			GUICtrlSetData($txtNumBarb, "100")
		Case 2
			_GUI_Value_STATE("SHOW", $groupTroopsGobl & "#" & $groupTroopsTot)
			For $i = 0 To UBound($TroopName) - 1
				GUICtrlSetData(Eval("txtNum" & $TroopName[$i]), "0")
			Next
			For $i = 0 To UBound($TroopDarkName) - 1
				GUICtrlSetData(Eval("txtNum" & $TroopDarkName[$i]), "0")
			Next
			GUICtrlSetData($txtNumGobl, "100")
		Case 3
			_GUI_Value_STATE("SHOW", $groupTroopsArch & "#" & $groupTroopsTot)
			_GUI_Value_STATE("SHOW", $groupTroopsBarB & "#" & $groupTroopsTot)
			For $i = 0 To UBound($TroopName) - 1
				GUICtrlSetData(Eval("txtNum" & $TroopName[$i]), "0")
			Next
			For $i = 0 To UBound($TroopDarkName) - 1
				GUICtrlSetData(Eval("txtNum" & $TroopDarkName[$i]), "0")
			Next
			GUICtrlSetData($txtNumBarb, "50")
			GUICtrlSetData($txtNumArch, "50")
		Case 4
			_GUI_Value_STATE("SHOW", $groupTroopsArch & "#" & $groupTroopsTot)
			_GUI_Value_STATE("SHOW", $groupTroopsBarB & "#" & $groupTroopsTot)
			_GUI_Value_STATE("SHOW", $groupTroopsGobl & "#" & $groupTroopsTot)
			_GUI_Value_STATE("SHOW", $groupTroopsGiant)
			For $i = 0 To UBound($TroopName) - 1
				GUICtrlSetData(Eval("txtNum" & $TroopName[$i]), "0")
			Next
			For $i = 0 To UBound($TroopDarkName) - 1
				GUICtrlSetData(Eval("txtNum" & $TroopDarkName[$i]), "0")
			Next
			GUICtrlSetData($txtNumBarb, "60")
			GUICtrlSetData($txtNumArch, "30")
			GUICtrlSetData($txtNumGobl, "10")
			GUICtrlSetData($txtNumGiant, $GiantComp)
		Case 5
			_GUI_Value_STATE("SHOW", $groupTroopsArch & "#" & $groupTroopsTot)
			_GUI_Value_STATE("SHOW", $groupTroopsBarB & "#" & $groupTroopsTot)
			_GUI_Value_STATE("SHOW", $groupTroopsGiant)
			For $i = 0 To UBound($TroopName) - 1
				GUICtrlSetData(Eval("txtNum" & $TroopName[$i]), "0")
			Next
			For $i = 0 To UBound($TroopDarkName) - 1
				GUICtrlSetData(Eval("txtNum" & $TroopDarkName[$i]), "0")
			Next
			GUICtrlSetData($txtNumBarb, "50")
			GUICtrlSetData($txtNumArch, "50")
			GUICtrlSetData($txtNumGiant, $GiantComp)
		Case 6
			_GUI_Value_STATE("SHOW", $groupTroopsArch & "#" & $groupTroopsTot)
			_GUI_Value_STATE("SHOW", $groupTroopsBarB & "#" & $groupTroopsTot)
			_GUI_Value_STATE("SHOW", $groupTroopsGobl & "#" & $groupTroopsTot)
			For $i = 0 To UBound($TroopName) - 1
				GUICtrlSetData(Eval("txtNum" & $TroopName[$i]), "0")
			Next
			For $i = 0 To UBound($TroopDarkName) - 1
				GUICtrlSetData(Eval("txtNum" & $TroopDarkName[$i]), "0")
			Next
			GUICtrlSetData($txtNumBarb, "60")
			GUICtrlSetData($txtNumArch, "30")
			GUICtrlSetData($txtNumGobl, "10")
		Case 7
			_GUI_Value_STATE("SHOW", $groupTroopsArch & "#" & $groupTroopsTot)
			_GUI_Value_STATE("SHOW", $groupTroopsBarB & "#" & $groupTroopsTot)
			_GUI_Value_STATE("SHOW", $groupTroopsGobl & "#" & $groupTroopsTot)
			_GUI_Value_STATE("SHOW", $groupTroopsGiant)
			_GUI_Value_STATE("SHOW", $groupTroopsWall)
			For $i = 0 To UBound($TroopName) - 1
				GUICtrlSetData(Eval("txtNum" & $TroopName[$i]), "0")
			Next
			For $i = 0 To UBound($TroopDarkName) - 1
				GUICtrlSetData(Eval("txtNum" & $TroopDarkName[$i]), "0")
			Next
			GUICtrlSetData($txtNumBarb, "60")
			GUICtrlSetData($txtNumArch, "30")
			GUICtrlSetData($txtNumGobl, "10")
			GUICtrlSetData($txtNumGiant, $GiantComp)
			GUICtrlSetData($txtNumWall, $WallComp)
			GUICtrlSetData($txtNumWiza, $WizaComp)
		Case 8
			;show all the barrack mode controls
			ShowBarrackControls()
			For $i = 0 To UBound($TroopName) - 1
				GUICtrlSetData(Eval("txtNum" & $TroopName[$i]), "0")
			Next
		Case 9
			_GUI_Value_STATE("SHOW", $groupTroops1)
			_GUI_Value_STATE("SHOW", $groupTroops2)
			For $i = 0 To UBound($TroopName) - 1
				GUICtrlSetData(Eval("txtNum" & $TroopName[$i]), Eval($TroopName[$i] & "Comp"))
			Next
	EndSwitch
	lblTotalCount()
	SetRedrawBotWindow($bWasRedraw)
EndFunc   ;==>SetComboTroopComp

Func HideBarrackControls()
	_GUI_Value_STATE("HIDE", $grpBarrackMode & "#" & $cmbBarrack1 & "#" & $cmbBarrack2 & "#" & $cmbBarrack3 & "#" & $cmbBarrack4)
	_GUI_Value_STATE("HIDE", Eval("lblBarrack1") & "#" & Eval("lblBarrack2") & "#" & Eval("lblBarrack3") & "#" & Eval("lblBarrack4"))
EndFunc   ;==>HideBarrackControls

Func HideCustomControls()
	For $i = 0 To UBound($TroopName) - 1
		GUICtrlSetState(Eval("txtNum" & $TroopName[$i]), $GUI_HIDE)
	Next
	_GUI_Value_STATE("HIDE", $groupTroops1)
	_GUI_Value_STATE("HIDE", $groupTroops2)
EndFunc   ;==>HideCustomControls

Func ShowBarrackControls()
	_GUI_Value_STATE("SHOW", $grpBarrackMode & "#" & $cmbBarrack1 & "#" & $cmbBarrack2 & "#" & $cmbBarrack3 & "#" & $cmbBarrack4)
	_GUI_Value_STATE("SHOW", Eval("lblBarrack1") & "#" & Eval("lblBarrack2") & "#" & Eval("lblBarrack3") & "#" & Eval("lblBarrack4"))
EndFunc   ;==>ShowBarrackControls

Func lblTotalCount()
	GUICtrlSetData($lblTotalCount, GUICtrlRead($txtNumBarb) + GUICtrlRead($txtNumArch) + GUICtrlRead($txtNumGobl))
	If GUICtrlRead($lblTotalCount) = "100" Then
		GUICtrlSetBkColor($lblTotalCount, $COLOR_MONEYGREEN)
	ElseIf GUICtrlRead($lblTotalCount) = "0" Then
		GUICtrlSetBkColor($lblTotalCount, $COLOR_ORANGE)
	Else
		GUICtrlSetBkColor($lblTotalCount, $COLOR_RED)
	EndIf
EndFunc   ;==>lblTotalCount

Func lblTotalCountSpell()
	_GUI_Value_STATE("HIDE", $groupListSpeel)
	If (GUICtrlRead($txtNumLightningSpell) * 2 + GUICtrlRead($txtNumHealSpell) * 2 + GUICtrlRead($txtNumRageSpell) * 2 + GUICtrlRead($txtNumJumpSpell) * 2 + GUICtrlRead($txtNumFreezeSpell) * 2 + GUICtrlRead($txtNumPoisonSpell) + GUICtrlRead($txtNumHasteSpell) + GUICtrlRead($txtNumEarthSpell)) < GUICtrlRead($txtTotalCountSpell) + 1 Then
		GUICtrlSetBkColor($txtNumLightningSpell, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($txtNumHealSpell, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($txtNumRageSpell, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($txtNumJumpSpell, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($txtNumFreezeSpell, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($txtNumPoisonSpell, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($txtNumEarthSpell, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($txtNumHasteSpell, $COLOR_MONEYGREEN)
	Else
		GUICtrlSetBkColor($txtNumLightningSpell, $COLOR_RED)
		GUICtrlSetBkColor($txtNumHealSpell, $COLOR_RED)
		GUICtrlSetBkColor($txtNumRageSpell, $COLOR_RED)
		GUICtrlSetBkColor($txtNumFreezeSpell, $COLOR_RED)
		GUICtrlSetBkColor($txtNumJumpSpell, $COLOR_RED)
		GUICtrlSetBkColor($txtNumPoisonSpell, $COLOR_RED)
		GUICtrlSetBkColor($txtNumEarthSpell, $COLOR_RED)
		GUICtrlSetBkColor($txtNumHasteSpell, $COLOR_RED)
	EndIf
	$iTownHallLevel = Int($iTownHallLevel)
	If $iTownHallLevel > 4 Or $iTownHallLevel = 0 Then
		_GUI_Value_STATE("SHOW", $groupLightning)
	Else
		GUICtrlSetData($txtNumLightningSpell, 0)
		GUICtrlSetData($txtNumRageSpell, 0)
		GUICtrlSetData($txtNumHealSpell, 0)
		GUICtrlSetData($txtNumJumpSpell, 0)
		GUICtrlSetData($txtNumFreezeSpell, 0)
		GUICtrlSetData($txtNumPoisonSpell, 0)
		GUICtrlSetData($txtNumEarthSpell, 0)
		GUICtrlSetData($txtNumHasteSpell, 0)
		GUICtrlSetData($txtTotalCountSpell, 0)
	EndIf
	If $iTownHallLevel > 5 Or $iTownHallLevel = 0 Then
		_GUI_Value_STATE("SHOW", $groupHeal)
	Else
		GUICtrlSetData($txtNumRageSpell, 0)
		GUICtrlSetData($txtNumJumpSpell, 0)
		GUICtrlSetData($txtNumFreezeSpell, 0)
		GUICtrlSetData($txtNumPoisonSpell, 0)
		GUICtrlSetData($txtNumEarthSpell, 0)
		GUICtrlSetData($txtNumHasteSpell, 0)
	EndIf
	If $iTownHallLevel > 6 Or $iTownHallLevel = 0 Then
		_GUI_Value_STATE("SHOW", $groupRage)
	Else
		GUICtrlSetData($txtNumJumpSpell, 0)
		GUICtrlSetData($txtNumFreezeSpell, 0)
		GUICtrlSetData($txtNumPoisonSpell, 0)
		GUICtrlSetData($txtNumEarthSpell, 0)
		GUICtrlSetData($txtNumHasteSpell, 0)
	EndIf
	If $iTownHallLevel > 7 Or $iTownHallLevel = 0 Then
		_GUI_Value_STATE("SHOW", $groupPoison)
		_GUI_Value_STATE("SHOW", $groupEarthquake)
	Else
		GUICtrlSetData($txtNumJumpSpell, 0)
		GUICtrlSetData($txtNumFreezeSpell, 0)
		GUICtrlSetData($txtNumHasteSpell, 0)
	EndIf
	If $iTownHallLevel > 8 Or $iTownHallLevel = 0 Then
		_GUI_Value_STATE("SHOW", $groupJumpSpell)
		_GUI_Value_STATE("SHOW", $groupFreeze)
		_GUI_Value_STATE("SHOW", $groupHaste)
	EndIf
	; EndIf
EndFunc   ;==>lblTotalCountSpell
Func chkBoostBarracksHoursE1()
	If GUICtrlRead($chkBoostBarracksHoursE1) = $GUI_CHECKED And GUICtrlRead($chkBoostBarracksHours0) = $GUI_CHECKED Then
		For $i = $chkBoostBarracksHours0 To $chkBoostBarracksHours11
			GUICtrlSetState($i, $GUI_UNCHECKED)
		Next
	Else
		For $i = $chkBoostBarracksHours0 To $chkBoostBarracksHours11
			GUICtrlSetState($i, $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($chkBoostBarracksHoursE1, $GUI_UNCHECKED)
EndFunc   ;==>chkBoostBarracksHoursE1

Func chkBoostBarracksHoursE2()
	If GUICtrlRead($chkBoostBarracksHoursE2) = $GUI_CHECKED And GUICtrlRead($chkBoostBarracksHours12) = $GUI_CHECKED Then
		For $i = $chkBoostBarracksHours12 To $chkBoostBarracksHours23
			GUICtrlSetState($i, $GUI_UNCHECKED)
		Next
	Else
		For $i = $chkBoostBarracksHours12 To $chkBoostBarracksHours23
			GUICtrlSetState($i, $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($chkBoostBarracksHoursE2, $GUI_UNCHECKED)
EndFunc   ;==>chkBoostBarracksHoursE2
