Func SetLog($String, $Color = $COLOR_BLACK, $Font = "Verdana", $FontSize = 7.5, $statusbar = 1) ;Sets the text for the log
	_GUICtrlRichEdit_SetFont($txtLog, 6, "Lucida Console")
	_GUICtrlRichEdit_AppendTextColor($txtLog, Time(), 0x000000)
	_GUICtrlRichEdit_SetFont($txtLog, $FontSize, $Font)
	_GUICtrlRichEdit_AppendTextColor($txtLog, $String & @CRLF, _ColorConvert($Color))
	if $statusbar = 1 Then _GUICtrlStatusBar_SetText($statLog, "Status : " & $String)
	_FileWriteLog($hLogFileHandle, $String)
EndFunc   ;==>SetLog

Func _GUICtrlRichEdit_AppendTextColor($hWnd, $sText, $iColor)
	Local $iLength = _GUICtrlRichEdit_GetTextLength($hWnd, True, True)
	Local $iCp = _GUICtrlRichEdit_GetCharPosOfNextWord($hWnd, $iLength)
	_GUICtrlRichEdit_AppendText($hWnd, $sText)
	_GUICtrlRichEdit_SetSel($hWnd, $iCp - 1, $iLength + StringLen($sText))
	_GUICtrlRichEdit_SetCharColor($hWnd, $iColor)
	_GUICtrlRichEdit_Deselect($hWnd)
EndFunc   ;==>_GUICtrlRichEdit_AppendTextColor

Func _ColorConvert($nColor);RGB to BGR or BGR to RGB
	Return _
			BitOR(BitShift(BitAND($nColor, 0x000000FF), -16), _
			BitAND($nColor, 0x0000FF00), _
			BitShift(BitAND($nColor, 0x00FF0000), 16))
EndFunc   ;==>_ColorConvert

Func SetAtkLog($String, $Color = $COLOR_BLACK, $Font = "Lucida Console", $FontSize = 7.5) ;Sets the text for the log
	_GUICtrlRichEdit_SetFont($txtAtkLog, $FontSize, $Font)
	_GUICtrlRichEdit_AppendTextColor($txtAtkLog, $String & @CRLF, _ColorConvert($Color))
	If $hAttackLogFileHandle = "" Then CreateAttackLogFile()
	_FileWriteLog($hAttackLogFileHandle,  $String)
EndFunc   ;==>SetAtkLog

Func AtkLogHead()
	SetAtkLog(_PadStringCenter(" ATTACK LOG ", 71, "="), $COLOR_BLACK, "MS Shell Dlg", 8.5)
	SetAtkLog("                   --------  LOOT --------       ----- BONUS ------   ")
	SetAtkLog(" TIME|TROP.|SEARCH|   GOLD| ELIXIR|DARK EL|TR.|S|  GOLD|ELIXIR|  DE|L.")
EndFunc   ;==>AtkLogHead
