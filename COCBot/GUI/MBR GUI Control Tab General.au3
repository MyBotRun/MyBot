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

Func btnAtkLogClear()
	_GUICtrlRichEdit_SetText($txtAtkLog, "")
	AtkLogHead()
EndFunc   ;==>btnAtkLogClear

Func btnAtkLogCopyClipboard()
	Local $text = _GUICtrlRichEdit_GetText($txtAtkLog)
	$text = StringReplace($text, @CR, @CRLF)
	ClipPut($text)
EndFunc   ;==>btnAtkLogCopyClipboard

Func cmbLog()
	Local $x = 0, $y = 0, $w = $_GUI_MAIN_WIDTH - 20, $h = $_GUI_MAIN_HEIGHT - 470 + Int($frmBotAddH / 2) ; default GUI values, used as reference
	If ($iDividerY > $h + Int($h / 2) + $y And $iDividerY < $h * 2 + $iDividerHeight + $y) Or $iDividerY > $h * 2 + $iDividerHeight + $y Then $iDividerY = $h + Int($h / 2) + $y
	If ($iDividerY < Int($h / 2) + $y And $iDividerY > 0) Or $iDividerY < 0 Then $iDividerY = Int($h / 2)
	_SendMessage($txtLog, $WM_SETREDRAW, False, 0) ; disable redraw so disabling has no visiual effect
	_WINAPI_EnableWindow($txtLog, False) ; disable RichEdit
	_SendMessage($txtAtkLog, $WM_SETREDRAW, False, 0) ; disable redraw so disabling has no visiual effect
	_WINAPI_EnableWindow($txtAtkLog, False) ; disable RichEdit
	Switch _GUICtrlComboBox_GetCurSel($cmbLog)
		Case 0
			ControlShow($hGUI_LOG, "", $divider)
			ControlMove($hGUI_LOG, "", $divider, $x, $iDividerY - $y, $w, $iDividerHeight)
			ControlShow($hGUI_LOG, "", $txtLog)
			ControlMove($hGUI_LOG, "", $txtLog, $x, $y, $w, $iDividerY - $y)
			ControlShow($hGUI_LOG, "", $txtAtkLog)
			ControlMove($hGUI_LOG, "", $txtAtkLog, $x, $iDividerY + $iDividerHeight, $w, ($h * 2) - ($iDividerY - $y))
		Case 1
			ControlShow($hGUI_LOG, "", $txtLog)
			ControlMove($hGUI_LOG, "", $txtLog, $x, $y, $w, $h)
			$y += $h
			ControlHide($hGUI_LOG, "", $divider)
			$y += $iDividerHeight
			ControlShow($hGUI_LOG, "", $txtAtkLog)
			ControlMove($hGUI_LOG, "", $txtAtkLog, $x, $y, $w, $h)
		Case 2
			ControlShow($hGUI_LOG, "", $txtLog)
			ControlMove($hGUI_LOG, "", $txtLog, $x, $y, $w, $h + ($h / 2))
			$y += $h + ($h / 2) + $iDividerHeight
			ControlHide($hGUI_LOG, "", $divider)
			ControlShow($hGUI_LOG, "", $txtAtkLog)
			ControlMove($hGUI_LOG, "", $txtAtkLog, $x, $y, $w, $h - ($h / 2))
		Case 3
			ControlShow($hGUI_LOG, "", $txtLog)
			ControlMove($hGUI_LOG, "", $txtLog, $x, $y, $w, $h - ($h / 2))
			$y += ($h / 2) + $iDividerHeight
			ControlHide($hGUI_LOG, "", $divider)
			ControlShow($hGUI_LOG, "", $txtAtkLog)
			ControlMove($hGUI_LOG, "", $txtAtkLog, $x, $y, $w, $h + ($h / 2))
		Case 4
			ControlShow($hGUI_LOG, "", $txtLog)
			ControlMove($hGUI_LOG, "", $txtLog, $x, $y, $w, $h * 2 + $iDividerHeight)
			ControlHide($hGUI_LOG, "", $txtAtkLog)
			ControlMove($hGUI_LOG, "", $txtAtkLog, $x, $y + $h * 2 + $iDividerHeight, $w, 0)
			ControlHide($hGUI_LOG, "", $divider)
		Case 5
			ControlHide($hGUI_LOG, "", $txtLog)
			ControlMove($hGUI_LOG, "", $txtLog, $x, $y, $w, 0)
			ControlShow($hGUI_LOG, "", $txtAtkLog)
			ControlMove($hGUI_LOG, "", $txtAtkLog, $x, $y, $w, $h * 2 + $iDividerHeight)
			ControlHide($hGUI_LOG, "", $divider)
	EndSwitch
	_SendMessage($txtLog, $WM_SETREDRAW, True, 0) ; enabled RechEdit redraw again
	_WINAPI_EnableWindow($txtLog, True) ; enable RichEdit
	;_WinAPI_RedrawWindow($txtLog, 0, 0, $RDW_INVALIDATE + $RDW_ALLCHILDREN) ; redraw RichEdit
	;_WinAPI_UpdateWindow($txtLog)
	_SendMessage($txtAtkLog, $WM_SETREDRAW, True, 0) ; enabled RechEdit redraw again
	_WINAPI_EnableWindow($txtAtkLog, True) ; enable RichEdit
	;_WinAPI_RedrawWindow($txtAtkLog, 0, 0, $RDW_INVALIDATE + $RDW_ALLCHILDREN) ; redraw RichEdit
	;_WinAPI_UpdateWindow($txtAtkLog)

	CheckRedrawControls(True)
EndFunc   ;==>cmbLog

Func MoveDivider()

	Local $PPos = ControlGetPos($frmBot, "", $hGUI_LOG)
	$TPos = ControlGetPos($hGUI_LOG, "", $txtLog)
	$BPos = ControlGetPos($hGUI_LOG, "", $txtAtkLog)
	$DPos = ControlGetPos($hGUI_LOG, "", $divider)
	$logAndDividerX = $TPos[0] - $PPos[0]
	$logAndDividerWidth = $TPos[2]
	$totalLogsHeight = $TPos[3] + $BPos[3]
	$minVisibleHeight = Ceiling($totalLogsHeight / 4)
	$snapToMinMax = Ceiling($minVisibleHeight / 3)
	$halfDividerTopHeight = Ceiling($iDividerHeight / 2)
	$halfDividerBottomHeight = Floor($iDividerHeight / 2)
	$startLogsY = $TPos[1] - $_GUI_CHILD_TOP
	$endLogsY = $BPos[1] - $_GUI_CHILD_TOP + $BPos[3]

	;SetDebugLog("Devider: " & $iDividerY & ", " & $logAndDividerX & ", " & $logAndDividerWidth & ", " & $totalLogsHeight & ", " & $minVisibleHeight & ", " & $snapToMinMax & ", " & $halfDividerTopHeight & ", " & $halfDividerBottomHeight & ", " & $halfDividerBottomHeight & ", " & $startLogsY & ", " & $endLogsY)

	Do
		$pos = GUIGetCursorInfo($hGUI_LOG)
		$clickY = $pos[1]

		; adjust $clickY to final value
		If $clickY - $halfDividerTopHeight <= $startLogsY + $snapToMinMax Then
			$clickY = $startLogsY + $halfDividerTopHeight
		ElseIf $clickY + $halfDividerBottomHeight >= $endLogsY - $snapToMinMax Then
			$clickY = $endLogsY - $halfDividerBottomHeight
		ElseIf $clickY - $halfDividerTopHeight > $startLogsY + $snapToMinMax And $clickY - $halfDividerTopHeight <= $startLogsY + $minVisibleHeight Then
			$clickY = $startLogsY + $minVisibleHeight + $halfDividerTopHeight
		ElseIf $clickY + $halfDividerBottomHeight < $endLogsY - $snapToMinMax And $clickY + $halfDividerBottomHeight >= $endLogsY - $minVisibleHeight Then
			$clickY = $endLogsY - $minVisibleHeight - $halfDividerBottomHeight
		EndIf
		$iDividerY = $clickY - $halfDividerTopHeight
		ControlMove($hGUI_LOG, "", $divider, $logAndDividerX, $iDividerY, $logAndDividerWidth, $iDividerHeight)
		ControlMove($hGUI_LOG, "", $txtLog, $logAndDividerX, $startLogsY, $logAndDividerWidth, $clickY - $startLogsY - $halfDividerTopHeight)
		If $endLogsY - ($clickY + $halfDividerBottomHeight) < 0 Then
			ControlMove($hGUI_LOG, "", $txtAtkLog, $logAndDividerX, $endLogsY, $logAndDividerWidth, 0)
		Else
			ControlMove($hGUI_LOG, "", $txtAtkLog, $logAndDividerX, $clickY + $halfDividerBottomHeight, $logAndDividerWidth, $endLogsY - $clickY - $halfDividerBottomHeight)
		EndIf

		_WinAPI_UpdateWindow(WinGetHandle($hGUI_LOG))

	Until $pos[2] = 0

	_GUICtrlRichEdit_SetSel($txtLog, - 1, -1) ; select end
	_GUICtrlRichEdit_SetSel($txtAtkLog, - 1, -1) ; select end

	SetDebugLog("MoveDivider exit", Default, True)

EndFunc   ;==>MoveDivider


Func XPStyleToggle($Off = 1)
	Local $XS_n
	If Not StringInStr(@OSType, "WIN32_NT") Then Return 0

	If $Off Then
		$XS_n = DllCall("uxtheme.dll", "int", "GetThemeAppProperties")
		DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", 0)
		Return 1
	ElseIf IsArray($XS_n) Then
		DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", $XS_n[0])
		$XS_n = ""
		Return 1
	EndIf
	Return 0
EndFunc   ;==>XPStyleToggle

