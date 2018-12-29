; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......: eslindsey (2018), CodeSlinger69 (2017)
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

Func ClanGames_PopulateTreeView()
	; Read challenge data from CSV file (a real CSV file, not a MyBot CSV file)
	Local Const $challengesCsv = @ScriptDir & "\challenges.csv"
	Local Const $baseDir = @ScriptDir & "\images\ClanGames\"
	Local Const $iconDir = $baseDir & "16\"
	Local $i, $rc, $hImages
	Local $m_headings[], $m_tids[], $m_images[]
	$hImages = _GUIImageList_Create(16, 16, 5, 3)
	_GUIImageList_AddBitmap($hImages, $baseDir & "white.bmp")
	$rc = _FileReadToArray($challengesCsv, $g_aChallengeData, $FRTA_NOCOUNT, ",")
	If $rc <> 0 Then
		; Store the column numbers in a map to access by column name
		For $i = 0 To UBound($g_aChallengeData, $UBOUND_COLUMNS) - 1
			$g_mChallengeColumns[$g_aChallengeData[0][$i]] = $i
		Next
		; Store the challenge data in a global array to access later
		_GUICtrlTreeView_BeginUpdate($g_hTreeClanGames)
		_GUICtrlTreeView_SetNormalImageList($g_hTreeClanGames, $hImages)
		For $i = 2 To UBound($g_aChallengeData) - 1
			Local $set     = $g_aChallengeData[$i][$g_mChallengeColumns["Set"]]
			Local $tid     = $g_aChallengeData[$i][$g_mChallengeColumns["TID"]]
			Local $heading = $g_aChallengeData[$i][$g_mChallengeColumns["Heading"]]
			Local $icon    = $g_aChallengeData[$i][$g_mChallengeColumns["IconExportName"]]
			If Not $m_headings[$heading] Then
				If Not $m_images[$heading] Then
					$m_images[$heading] = _GUIImageList_AddBitmap($hImages, $baseDir & $heading & ".bmp")
					If $m_images[$heading] = -1 Then
						SetLog("Couldn't load image " & $baseDir & $heading & ".bmp", $COLOR_WARNING)
						$m_images[$heading] = 0
					EndIf
				EndIf
				$m_headings[$heading] = _GUICtrlTreeView_Add($g_hTreeClanGames, 0, $heading, $m_images[$heading], $m_images[$heading])
			EndIf
			If Not $m_tids[$tid] Then
				If Not $m_images[$icon] Then
					$m_images[$icon] = _GUIImageList_AddBitmap($hImages, $iconDir & $icon & ".bmp")
					If $m_images[$icon] = -1 Then
						SetLog("Couldn't load image " & $iconDir & $icon & ".bmp", $COLOR_WARNING)
						$m_images[$icon] = 0
					EndIf
				EndIf
				$m_tids[$tid] = _GUICtrlTreeView_AddChild($g_hTreeClanGames, $m_headings[$heading], $tid, $m_images[$icon], $m_images[$icon])
			EndIf
			If Not $m_images[$set] Then
				$m_images[$set] = _GUIImageList_AddBitmap($hImages, $baseDir & $set & ".bmp")
				If $m_images[$set] = -1 Then
					SetLog("Couldn't load image " & $baseDir & $set & ".bmp", $COLOR_WARNING)
					$m_images[$set] = 0
				EndIf
			EndIf
			Local $hItem = _GUICtrlTreeView_AddChild($g_hTreeClanGames, $m_tids[$tid], $set, $m_images[$set], $m_images[$set])
			_GUICtrlTreeView_SetItemParam($g_hTreeClanGames, $hItem, $i)
		Next
		_GUICtrlTreeView_EndUpdate($g_hTreeClanGames)
	Else
		Local $err
		Switch @error
			Case 1
				$err = "Error opening specified file"
			Case 2
				$err = "Unable to split the data"
			Case 3
				$err = "File lines have different numbers of fields"
			Case 4
				$err = "No delimiters found"
		EndSwitch
		SetLog($challengesCsv & ": " & $err, $COLOR_ERROR)
	EndIf
EndFunc   ;==>ClanGames_PopulateTreeView

Func PopulateAttackComboBox()
	; Figure out what is currently selected
	Local $sel
	Local $hItem = _GUICtrlComboBox_GetCurSel($g_hCmbAttack)
	_GUICtrlComboBox_GetLBText($g_hCmbAttack, $hItem, $sel)
	; Reset the combo box
	_GUICtrlComboBox_ResetContent($g_hCmbAttack)
	; Populate the strategy files in the combo box
	GUICtrlSetData($g_hCmbAttack, "Do Not Change Strategy|————————————————————|" & GetPresetComboBox())
	; Restore previous selection
	_GUICtrlComboBox_SetCurSel($g_hCmbAttack, 0)
	If $hItem >= 2 Then
		Local $newSel = _GUICtrlComboBox_FindStringExact($g_hCmbAttack, $sel)
		If $newSel > -1 Then _GUICtrlComboBox_SetCurSel($g_hCmbAttack, $newSel)
	EndIf
EndFunc   ;==>PopulateAttackComboBox

Func ClanGames_StrategyChanged()
	Local $i = _GUICtrlComboBox_GetCurSel($g_hCmbAttack)
	If $i = 1 Then Return  ; Ignore the separator line after "Do Not Change Strategy"
	Local $hItem = _GUICtrlTreeView_GetSelection($g_hTreeClanGames)
	Local $text = _GUICtrlTreeView_GetText($g_hTreeClanGames, $hItem)
	Local $pos = StringInStr($text, " - ")
	If $pos > 0 Then $text = StringLeft($text, $pos - 1)
	If $i > 1 Then
		Local $comboText
		_GUICtrlComboBox_GetLBText($g_hCmbAttack, $i, $comboText)
		$text &= " - " & $comboText
	EndIf
	_GUICtrlTreeView_SetText($g_hTreeClanGames, $hItem, $text)
EndFunc   ;==>ClanGames_StrategyChanged

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
	If $hItem = 0 Then Return
;~ 		GUICtrlSetState($g_hCmbAttack, $GUI_DISABLE)
;~ 		ClanGames_SetDescriptionState($GUI_HIDE)
;~ 	Else
		; If using a specific strategy, select it
		Local $selText = _GUICtrlTreeView_GetText($g_hTreeClanGames, $hItem)
		Local $i = StringInStr($selText, " - ")
		If $i > 0 Then
			$selText = StringMid($selText, $i + 3)
			$i = _GUICtrlComboBox_FindStringExact($g_hCmbAttack, $selText)
			If $i > -1 Then
				_GUICtrlComboBox_SetCurSel($g_hCmbAttack, $i)
			Else
				_GUICtrlComboBox_SetCurSel($g_hCmbAttack, 0)
			EndIf
		Else
			_GUICtrlComboBox_SetCurSel($g_hCmbAttack, 0)
		EndIf
		GUICtrlSetState($g_hCmbAttack, $GUI_ENABLE)
		; Update the clan games description section
		$i = _GUICtrlTreeView_GetItemParam($hWndFrom, $hItem)
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
;~ 	EndIf
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
