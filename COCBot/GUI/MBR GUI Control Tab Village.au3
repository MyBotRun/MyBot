; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......: eslindsey (2018)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

; Func chkTrap()
	; If GUICtrlRead($g_hChkTrap) = $GUI_CHECKED Then
		; $g_bChkTrap = True
		; ;GUICtrlSetState($btnLocateTownHall, $GUI_SHOW)
	; Else
		; $g_bChkTrap = False
		; ;GUICtrlSetState($btnLocateTownHall, $GUI_HIDE)
	; EndIf
; EndFunc   ;==>chkTrap

; Func ChkCollect()
	; $g_bChkCollect = (GUICtrlRead($g_hChkCollect) = $GUI_CHECKED)
; EndFunc   ;==>ChkCollect

Func TreeView_SetChildren($hWnd, $hItem, $bCheck)
	Local $hChild = _GUICtrlTreeView_GetFirstChild($hWnd, $hItem)
	While $hChild
		_GUICtrlTreeView_SetChecked($hWnd, $hChild, $bCheck)
		TreeView_SetChildren($hWnd, $hChild, $bCheck)
		$hChild = _GUICtrlTreeView_GetNextSibling($hWnd, $hChild)
	WEnd
EndFunc   ;==>TreeView_CheckChildren

Func TreeView_CheckParent($hWnd, $hItem)
	Local $hParent = _GUICtrlTreeView_GetParentHandle($hWnd, $hItem)
	If $hParent = 0 Or $hParent = $hWnd Then Return
	Local $hChild = _GUICtrlTreeView_GetFirstChild($hWnd, $hParent)
	Local $checked = 0, $total = 0
	While $hChild
		Switch _GUICtrlTreeView_GetStateImageIndex($hWnd, $hChild)
			Case 2
				$checked += 1
			Case 3
				$checked = 1
				$total = 2
				ExitLoop
		EndSwitch
		$total += 1
		$hChild = _GUICtrlTreeView_GetNextSibling($hWnd, $hChild)
	WEnd
	If $checked = 0 Then
		_GUICtrlTreeView_SetStateImageIndex($hWnd, $hParent, 1)
	ElseIf $checked = $total Then
		_GUICtrlTreeView_SetStateImageIndex($hWnd, $hParent, 2)
	Else
		_GUICtrlTreeView_SetStateImageIndex($hWnd, $hParent, 3)
	EndIf
	TreeView_CheckParent($hWnd, $hParent)
EndFunc   ;==>TreeView_CheckParent

Func ClanGames_WM_NOTIFY($hWnd, $iMsg, $wParam, $lParam)
	Local $tNotifyHdr = DllStructCreate($tagNMHDR, $lParam)
	Local $hWndFrom = DllStructGetData($tNotifyHdr, "hWndFrom")
	Local $code = DllStructGetData($tNotifyHdr, "Code")
	Switch $hWndFrom
		Case GUICtrlGetHandle($g_hTreeClanGames)         ; Clan Games TreeView
			Switch $code
				Case $TVN_ITEMCHANGEDA, $TVN_ITEMCHANGEDW   ; Item state changed
					_ClanGames_ItemStateChanged($hWndFrom, $lParam)
					Return
				Case $TVN_SELCHANGEDA, $TVN_SELCHANGEDW     ; Selection changed
					_ClanGames_SelectedItemChanged($hWndFrom, $lParam)
					Return
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>ClanGames_WM_NOTIFY

Func _ClanGames_ItemStateChanged($hWndFrom, $lParam)
	Local $tItemChange = DllStructCreate($tagNMTVITEMCHANGE, $lParam)
	Local $hItem = DllStructGetData($tItemChange, "hItem")
	; State image index is stored in bits 8-11 of the item state, so why do I have to shift by 12 to get it?
	Local $uStateNewImageIndex = BitAND(BitShift(DllStructGetData($tItemChange, "StateNew"), 12), 0xF)
	Local $uStateOldImageIndex = BitAND(BitShift(DllStructGetData($tItemChange, "StateOld"), 12), 0xF)
	If $uStateNewImageIndex <> $uStateOldImageIndex Then
		If $uStateNewImageIndex = 3 Then
			_GUICtrlTreeView_SetStateImageIndex($hWndFrom, $hItem, 1)
			$uStateNewImageIndex = 1
		EndIf
		TreeView_SetChildren($hWndFrom, $hItem, $uStateNewImageIndex = 2)
		TreeView_CheckParent($hWndFrom, $hItem)
	EndIf
EndFunc   ;==>_ClanGames_ItemStateChanged

Func _ClanGames_SelectedItemChanged($hWndFrom, $lParam)
	Local $tTreeView = DllStructCreate($tagNMTREEVIEW, $lParam)
	Local $hItem = DllStructGetData($tTreeView, "NewhItem")
	If $hItem = 0 Then
		GUICtrlSetState($g_hCmbAttack, $GUI_DISABLE)
		ClanGames_SetDescriptionState($GUI_HIDE)
	Else
		; Item has been selected
		GUICtrlSetState($g_hCmbAttack, $GUI_ENABLE)
		Local $i = _GUICtrlTreeView_GetItemParam($hWndFrom, $hItem)
		If $i Then
			Local $dm = Number($g_aChallengeData[$i][$g_mChallengeColumns["DurationMinutes"]])
			Local $dh = Mod(Floor($dm / 60), 24)
			Local $dd = Floor($dm / 1440)
			$dm = Mod($dm, 60)
			Local $duration = ""
			If $dd > 0 Then $duration &= $dd & "d "
			If $dh > 0 Then $duration &= $dh & "h "
			If $dm > 0 Then $duration &= $dm & "m "
			GUICtrlSetData($g_hGrpChallengeTid, $g_aChallengeData[$i][$g_mChallengeColumns["TID"]])
			GUICtrlSetData($g_hLblChallengeInfoTid, $g_aChallengeData[$i][$g_mChallengeColumns["InfoTID"]])
			GUICtrlSetData($g_hLblChallengeScore, $g_aChallengeData[$i][$g_mChallengeColumns["Score"]])
			GUICtrlSetData($g_hLblChallengeDuration, $duration)
			GUICtrlSetImage($g_hPicChallengeIcon, @ScriptDir & "\images\ClanGames\40\" & $g_aChallengeData[$i][$g_mChallengeColumns["IconExportName"]] & ".gif")
			ClanGames_SetDescriptionState($GUI_SHOW)
		Else
			ClanGames_SetDescriptionState($GUI_HIDE)
		EndIf
	EndIf
EndFunc   ;==>_ClanGames_SelectedItemChanged

Func ClanGames_SetDescriptionState($state)
	For $i = $g_hGrpChallengeTid To $g_hLblChallengeInfoTid
		GUICtrlSetState($i, $state)
	Next
EndFunc   ;==>ClanGames_SetDescriptionState

Func chkRequestCCHours()
	Local $bWasRedraw = SetRedrawBotWindow(False, Default, Default, Default, "chkRequestCCHours")

	If GUICtrlRead($g_hChkRequestTroopsEnable) = $GUI_CHECKED Then
		GUICtrlSetState($g_hTxtRequestCC, $GUI_SHOW + $GUI_ENABLE)
		For $i = $g_hLblRequestType To $g_hLblRequestCCHoursPM
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
		chkRequestCountCC()
	Else
		GUICtrlSetState($g_hTxtRequestCC, $GUI_SHOW + $GUI_DISABLE)
		For $i = $g_hLblRequestType To $g_hLblRequestCCHoursPM
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf

	SetRedrawBotWindowControls($bWasRedraw, $g_hGrpRequestCC, "chkRequestCCHours")
EndFunc   ;==>chkRequestCCHours

Func chkRequestCountCC()
	If GUICtrlRead($g_hChkRequestType_Troops) = $GUI_CHECKED Then
		GUICtrlSetState($g_hTxtRequestCountCCTroop, $GUI_ENABLE)
		For $i = $g_ahCmbClanCastleTroop[0] To $g_ahCmbClanCastleTroop[2]
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
		CmbClanCastleTroop()
	Else
		GUICtrlSetState($g_hTxtRequestCountCCTroop, $GUI_DISABLE)
		For $i = $g_ahCmbClanCastleTroop[0] To $g_ahTxtClanCastleTroop[2]
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
	If GUICtrlRead($g_hChkRequestType_Spells) = $GUI_CHECKED Then
		GUICtrlSetState($g_hTxtRequestCountCCSpell, $GUI_ENABLE)
		For $i = $g_ahCmbClanCastleSpell[0] To $g_ahCmbClanCastleSpell[1]
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
		CmbClanCastleSpell()
	Else
		GUICtrlSetState($g_hTxtRequestCountCCSpell, $GUI_DISABLE)
		For $i = $g_ahCmbClanCastleSpell[0] To $g_ahTxtClanCastleSpell[1]
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>chkRequestCountCC

Func CmbClanCastleTroop()
	For $i = 0 To UBound($g_ahCmbClanCastleTroop) - 1
		If _GUICtrlComboBox_GetCurSel($g_ahCmbClanCastleTroop[$i]) <= $eTroopBowler Then
			GUICtrlSetState($g_ahTxtClanCastleTroop[$i], $GUI_ENABLE)
		Else
			GUICtrlSetState($g_ahTxtClanCastleTroop[$i], $GUI_DISABLE)
		EndIf
	Next
EndFunc   ;==>CmbClanCastleTroop

Func CmbClanCastleSpell()
	For $i = 0 To UBound($g_ahCmbClanCastleSpell) - 1
		If _GUICtrlComboBox_GetCurSel($g_ahCmbClanCastleSpell[$i]) = $eCSpell - $eLSpell Then _GUICtrlComboBox_SetCurSel($g_ahCmbClanCastleSpell[$i], $eBtSpell - $eLSpell + 1)
		If _GUICtrlComboBox_GetCurSel($g_ahCmbClanCastleSpell[$i]) <= $eBtSpell - $eLSpell Then
			GUICtrlSetState($g_ahTxtClanCastleSpell[$i], $GUI_ENABLE)
		Else
			GUICtrlSetState($g_ahTxtClanCastleSpell[$i], $GUI_DISABLE)
		EndIf
	Next
EndFunc   ;==>CmbClanCastleSpell

Func chkRequestCCHoursE1()
	If GUICtrlRead($g_hChkRequestCCHoursE1) = $GUI_CHECKED And GUICtrlRead($g_ahChkRequestCCHours[0]) = $GUI_CHECKED Then
		For $i = 0 To 11
			GUICtrlSetState($g_ahChkRequestCCHours[$i], $GUI_UNCHECKED)
		Next
	Else
		For $i = 0 To 11
			GUICtrlSetState($g_ahChkRequestCCHours[$i], $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($g_hChkRequestCCHoursE1, $GUI_UNCHECKED)
EndFunc   ;==>chkRequestCCHoursE1

Func chkRequestCCHoursE2()
	If GUICtrlRead($g_hChkRequestCCHoursE2) = $GUI_CHECKED And GUICtrlRead($g_ahChkRequestCCHours[12]) = $GUI_CHECKED Then
		For $i = 12 To 23
			GUICtrlSetState($g_ahChkRequestCCHours[$i], $GUI_UNCHECKED)
		Next
	Else
		For $i = 12 To 23
			GUICtrlSetState($g_ahChkRequestCCHours[$i], $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($g_hChkRequestCCHoursE2, $GUI_UNCHECKED)
EndFunc   ;==>chkRequestCCHoursE2

Func chkDonateHours()
	Local $bWasRedraw = SetRedrawBotWindow(False, Default, Default, Default, "chkDonateHours")

    If GUICtrlRead($g_hChkDonateHoursEnable) = $GUI_CHECKED Then
		For $i = $g_hLblDonateCChour To $g_hLblDonateHoursPM
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else
		For $i = $g_hLblDonateCChour To $g_hLblDonateHoursPM
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf

	SetRedrawBotWindowControls($bWasRedraw, $g_hGrpDonateCC, "chkDonateHours")
EndFunc   ;==>chkDonateHours

Func chkDonateHoursE1()
	If GUICtrlRead($g_ahChkDonateHoursE1) = $GUI_CHECKED And GUICtrlRead($g_ahChkDonateHours[0]) = $GUI_CHECKED Then
		For $i = 0 To 11
			GUICtrlSetState($g_ahChkDonateHours[$i], $GUI_UNCHECKED)
		Next
	Else
		For $i = 0 To 11
			GUICtrlSetState($g_ahChkDonateHours[$i], $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($g_ahChkDonateHoursE1, $GUI_UNCHECKED)
EndFunc   ;==>chkDonateHoursE1

Func chkDonateHoursE2()
	If GUICtrlRead($g_ahChkDonateHoursE2) = $GUI_CHECKED And GUICtrlRead($g_ahChkDonateHours[12]) = $GUI_CHECKED Then
		For $i = 12 To 23
			GUICtrlSetState($g_ahChkDonateHours[$i], $GUI_UNCHECKED)
		Next
	Else
		For $i = 12 To 23
			GUICtrlSetState($g_ahChkDonateHours[$i], $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($g_ahChkDonateHoursE2, $GUI_UNCHECKED)
EndFunc   ;==>chkDonateHoursE2
