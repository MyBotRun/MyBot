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
	cmbLogImpl(False)
EndFunc   ;==>cmbLog

Func cmbLogImpl($ApplyConfig)
	Local $x = 30, $y = 150, $w = 450, $h = 170 ; default GUI values, used as reference
	$x -= 20
	$y -= 20
	Switch _GUICtrlComboBox_GetCurSel($cmbLog)
		Case 0
			If $ApplyConfig Then ; If bot was closed using Divider, use its Y coordinate to restore logs' and divider's positions
				GUICtrlSetPos($divider, $x, $iDividerY, $w, $iDividerHeight)
				ControlMove($frmBot, "", $txtLog, $x, $y, $w, $iDividerY - $y)
				ControlMove($frmBot, "", $txtAtkLog, $x, $iDividerY + $iDividerHeight, $w, ($h * 2) - ($iDividerY - $y))
			Else
				$TPos = ControlGetPos($frmBot, "", $txtLog)
				$BPos = ControlGetPos($frmBot, "", $txtAtkLog)
				$totalHeight = $h * 2 + $iDividerHeight
				If $TPos[3] = $totalHeight Then ; If Attack Log is hidden
					$iDividerY = $TPos[1] + $totalHeight - $iDividerHeight
					ControlMove($frmBot, "", $txtLog, $x, $TPos[1], $w, $TPos[3] - $iDividerHeight)
				ElseIf $BPos[3] = $totalHeight Then ; If Bot Log is hidden
					$iDividerY = $y
					ControlMove($frmBot, "", $txtAtkLog, $x, $BPos[1] + $iDividerHeight, $w, $BPos[3] - $iDividerHeight)
				Else ; If Divider is visible
					$iDividerY = $BPos[1] - $iDividerHeight
				EndIf
				GUICtrlSetState($divider, $GUI_SHOW) ;ControlShow($frmBot, "", $divider)
				GUICtrlSetPos($divider, $x, $iDividerY, $w, $iDividerHeight)
			EndIf
		Case 1
			ControlShow($frmBot, "", $txtLog)
			ControlMove($frmBot, "", $txtLog, $x, $y, $w, $h)
			$y += $h
			GUICtrlSetState($divider, $GUI_HIDE);ControlHide($frmBot, "", $divider)
			$y += $iDividerHeight
			ControlShow($frmBot, "", $txtAtkLog)
			ControlMove($frmBot, "", $txtAtkLog, $x, $y, $w, $h)
		Case 2
			ControlShow($frmBot, "", $txtLog)
			ControlMove($frmBot, "", $txtLog, $x, $y, $w, $h + ($h / 2))
			$y += $h + ($h / 2) + $iDividerHeight
			GUICtrlSetState($divider, $GUI_HIDE);ControlHide($frmBot, "", $divider)
			ControlShow($frmBot, "", $txtAtkLog)
			ControlMove($frmBot, "", $txtAtkLog, $x, $y, $w, $h - ($h / 2))
		Case 3
			ControlShow($frmBot, "", $txtLog)
			ControlMove($frmBot, "", $txtLog, $x, $y, $w, $h - ($h / 2))
			$y += ($h / 2) + $iDividerHeight
			GUICtrlSetState($divider, $GUI_HIDE);ControlHide($frmBot, "", $divider)
			ControlShow($frmBot, "", $txtAtkLog)
			ControlMove($frmBot, "", $txtAtkLog, $x, $y, $w, $h + ($h / 2))
		Case 4
			ControlShow($frmBot, "", $txtLog)
			ControlMove($frmBot, "", $txtLog, $x, $y, $w, $h * 2 + $iDividerHeight)
			ControlHide($frmBot, "", $txtAtkLog)
			ControlMove($frmBot, "", $txtAtkLog, $x, $y + $h * 2 + $iDividerHeight, $w, 0)
			GUICtrlSetState($divider, $GUI_HIDE);ControlHide($frmBot, "", $divider)
		Case 5
			ControlHide($frmBot, "", $txtLog)
			ControlMove($frmBot, "", $txtLog, $x, $y, $w, 0)
			ControlShow($frmBot, "", $txtAtkLog)
			ControlMove($frmBot, "", $txtAtkLog, $x, $y, $w, $h * 2 + $iDividerHeight)
			GUICtrlSetState($divider, $GUI_HIDE);ControlHide($frmBot, "", $divider)
	EndSwitch
EndFunc   ;==>cmbLogImpl

Func MoveDivider()

	$TPos = ControlGetPos($frmBot, "", $txtLog)
	$BPos = ControlGetPos($frmBot, "", $txtAtkLog)
	$DPos = ControlGetPos($frmBot, "", $divider)
	$logAndDividerX = $TPos[0]
	$logAndDividerWidth = $TPos[2]
	$totalLogsHeight = $TPos[3] + $BPos[3]
	$minVisibleHeight = Ceiling($totalLogsHeight / 4)
	$snapToMinMax = Ceiling($minVisibleHeight / 3)
	$halfDividerTopHeight = Ceiling($iDividerHeight / 2)
	$halfDividerBottomHeight = Floor($iDividerHeight / 2)
	$startLogsY = $TPos[1]
	$endLogsY = $BPos[1] + $BPos[3]
	GUISetState(@SW_DISABLE, $frmBot)
	Do
		$pos = GUIGetCursorInfo($frmBot)
		GUICtrlSetPos($divider, $DPos[0], $pos[1] - $halfDividerTopHeight, $logAndDividerWidth, $iDividerHeight)
	Until $pos[2] = 0
	$clickY = $pos[1]
	If $clickY - $halfDividerTopHeight <= $startLogsY + $snapToMinMax Then
		GUICtrlSetPos($divider, $logAndDividerX, $startLogsY, $logAndDividerWidth, $iDividerHeight)
		$clickY = $startLogsY + $halfDividerTopHeight
	ElseIf $clickY + $halfDividerBottomHeight >= $endLogsY - $snapToMinMax Then
		GUICtrlSetPos($divider, $logAndDividerX, $endLogsY - $iDividerHeight, $logAndDividerWidth, $iDividerHeight)
		$clickY = $endLogsY - $halfDividerBottomHeight
	ElseIf $clickY - $halfDividerTopHeight > $startLogsY + $snapToMinMax And $clickY - $halfDividerTopHeight <= $startLogsY + $minVisibleHeight Then
		GUICtrlSetPos($divider, $logAndDividerX, $startLogsY + $minVisibleHeight, $logAndDividerWidth, $iDividerHeight)
		$clickY = $startLogsY + $minVisibleHeight + $halfDividerTopHeight
	ElseIf $clickY + $halfDividerBottomHeight < $endLogsY - $snapToMinMax And $clickY + $halfDividerBottomHeight >= $endLogsY - $minVisibleHeight Then
		GUICtrlSetPos($divider, $logAndDividerX, $endLogsY - $minVisibleHeight - $iDividerHeight, $logAndDividerWidth, $iDividerHeight)
		$clickY = $endLogsY - $minVisibleHeight - $halfDividerBottomHeight
	EndIf
	ControlMove($frmBot, "", $txtLog, $logAndDividerX, $startLogsY, $logAndDividerWidth, $clickY - $startLogsY - $halfDividerTopHeight)
	If $endLogsY - ($clickY + $halfDividerBottomHeight) < 0 Then
		ControlMove($frmBot, "", $txtAtkLog, $logAndDividerX, $endLogsY, $logAndDividerWidth, 0)
	Else
		ControlMove($frmBot, "", $txtAtkLog, $logAndDividerX, $clickY + $halfDividerBottomHeight, $logAndDividerWidth, $endLogsY - $clickY - $halfDividerBottomHeight)
	EndIf
	ControlShow($frmBot, "", $txtLog)
	ControlShow($frmBot, "", $txtAtkLog)
	GUISetState(@SW_ENABLE, $frmBot)
	GUICtrlSetState($divider, $GUI_FOCUS)

EndFunc   ;==>MoveDivider


Func XPStyleToggle($Off = 1)
	Local $XS_n
     If Not StringInStr(@OSTYPE, "WIN32_NT") Then Return 0

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
 EndFunc

