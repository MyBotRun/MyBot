Func SetLog($String, $Color = $COLOR_BLACK, $Font = "Verdana", $FontSize = 7.5, $statusbar = 1, $time = Time()) ;Sets the text for the log
    If IsDeclared("txtLog") Then
	   _GUICtrlRichEdit_SetFont($txtLog, 6, "Lucida Console")
	   _GUICtrlRichEdit_AppendTextColor($txtLog, Time(), 0x000000)
	   _GUICtrlRichEdit_SetFont($txtLog, $FontSize, $Font)
	   _GUICtrlRichEdit_AppendTextColor($txtLog, $String & @CRLF, _ColorConvert($Color))
	   If $statusbar = 1 And IsDeclared("statLog") Then _GUICtrlStatusBar_SetText($statLog, "Status : " & $String)
	   _FileWriteLog($hLogFileHandle, $String)
    Else
	    Local $iIndex = UBound($aTxtLogInitText)
	    ReDim $aTxtLogInitText[$iIndex + 1][6]
		$aTxtLogInitText[$iIndex][0] = $String
		$aTxtLogInitText[$iIndex][1] = $Color
		$aTxtLogInitText[$iIndex][2] = $Font
		$aTxtLogInitText[$iIndex][3] = $FontSize
		$aTxtLogInitText[$iIndex][4] = $statusbar
		$aTxtLogInitText[$iIndex][5] = Time()
	EndIf
EndFunc   ;==>SetLog

Func SetDebugLog($String, $Color = $COLOR_PURPLE, $Font = "Verdana", $FontSize = 7.5, $statusbar = 1)
   If $debugSetlog = 1 Then SetLog($String, $Color, $Font, $FontSize, $statusbar)
EndFunc

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

Func SetAtkLog($String1, $String2 = "", $Color = $COLOR_BLACK, $Font = "Lucida Console", $FontSize = 7.5) ;Sets the text for the log
   ;string1 see in video, string1&string2 put in file
	_GUICtrlRichEdit_SetFont($txtAtkLog, $FontSize, $Font)
	_GUICtrlRichEdit_AppendTextColor($txtAtkLog, $String1 & @CRLF, _ColorConvert($Color))
	If $hAttackLogFileHandle = "" Then CreateAttackLogFile()
	_FileWriteLog($hAttackLogFileHandle,  $String1 & $String2)
EndFunc   ;==>SetAtkLog

Func AtkLogHead()
	SetAtkLog(_PadStringCenter(" " & GetTranslated(0,15, "ATTACK LOG") & " ", 71, "="),"", $COLOR_BLACK, "MS Shell Dlg", 8.5)
	SetAtkLog(GetTranslated(0,16, "                   --------  LOOT --------       ----- BONUS ------"),"")
	SetAtkLog(GetTranslated(0,17, " TIME|TROP.|SEARCH|   GOLD| ELIXIR|DARK EL|TR.|S|  GOLD|ELIXIR|  DE|L."),"")
EndFunc   ;==>AtkLogHead
