; #FUNCTION# ====================================================================================================================
; Name ..........: SetLog
; Description ...:
; Syntax ........: SetLog($String[, $Color = $COLOR_BLACK[, $Font = "Verdana"[, $FontSize = 7.5[, $statusbar = 1[, $time = Time([,
;                  $bConsoleWrite = True]]]]]])
; Parameters ....: $String              - an unknown value.
;                  $Color               - [optional] an unknown value. Default is $COLOR_BLACK.
;                  $Font                - [optional] an unknown value. Default is "Verdana".
;                  $FontSize            - [optional] an unknown value. Default is 7.5.
;                  $statusbar           - [optional] a string value. Default is 1.
;                  $time                - [optional] a dll struct value. Default is Time(.
;                  $bConsoleWrite       - [optional] a boolean value. Default is True.
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func SetLog($String, $Color = $COLOR_BLACK, $Font = "Verdana", $FontSize = 7.5, $statusbar = 1, $time = Time(), $bConsoleWrite = True, $LogPrefix = "L ") ;Sets the text for the log
	Local $log = $LogPrefix & TimeDebug() & $String
	If $bConsoleWrite = True And $String <> "" Then ConsoleWrite($log & @CRLF) ; Always write any log to console
	If $hLogFileHandle = "" Then CreateLogFile()
	If $SilentSetLog = True Then
		; Silent mode is active, only write to log file, not to log control
		__FileWriteLog($hLogFileHandle, $log)
		Return
	EndIf
	If IsDeclared("txtLog") Then
		Local $activeBot = _WinAPI_GetActiveWindow() = $frmBot ; different scroll to bottom when bot not active to fix strange bot activation flickering
		Local $hCtrl = _WinAPI_GetFocus() ; RichEdit tampers with focus so remember and restore
		_SendMessage($txtLog, $WM_SETREDRAW, False, 0) ; disable redraw so disabling has no visiual effect
		_WINAPI_EnableWindow($txtLog, False) ; disable RichEdit
		;If $activeBot Then _GUICtrlRichEdit_SetSel($txtLog, -1, -1) ; select end
		_GUICtrlRichEdit_SetSel($txtLog, -1, -1) ; select end
		_GUICtrlRichEdit_SetFont($txtLog, 6, "Lucida Console")
		_GUICtrlRichEdit_AppendTextColor($txtLog, $time, 0x000000, False)
		_GUICtrlRichEdit_SetFont($txtLog, $FontSize, $Font)
		_GUICtrlRichEdit_AppendTextColor($txtLog, $String & @CRLF, _ColorConvert($Color), False)
		If $statusbar = 1 And IsDeclared("statLog") Then _GUICtrlStatusBar_SetText($statLog, "Status : " & $String)
		_WINAPI_EnableWindow($txtLog, True) ; enabled RichEdit again
		;If $activeBot  Then _GUICtrlRichEdit_SetSel($txtLog, -1, -1) ; select end (scroll to end)
		_GUICtrlRichEdit_SetSel($txtLog, -1, -1) ; select end (scroll to end)
		_SendMessage($txtLog, $WM_SETREDRAW, True, 0) ; enabled RechEdit redraw again
		_WinAPI_RedrawWindow($txtLog, 0, 0, $RDW_INVALIDATE) ; redraw RichEdit
		If $activeBot And $hCtrl <> $txtLog Then _WinAPI_SetFocus($hCtrl) ; Restore Focus
		;If $activeBot = False Then _GUICtrlRichEdit_ScrollLineOrPage($txtLog, "pd")
		__FileWriteLog($hLogFileHandle, $log)
	Else
		; log it to RichEdit later...
		Local $iIndex = UBound($aTxtLogInitText)
		ReDim $aTxtLogInitText[$iIndex + 1][6]
		$aTxtLogInitText[$iIndex][0] = $String
		$aTxtLogInitText[$iIndex][1] = $Color
		$aTxtLogInitText[$iIndex][2] = $Font
		$aTxtLogInitText[$iIndex][3] = $FontSize
		$aTxtLogInitText[$iIndex][4] = $statusbar
		$aTxtLogInitText[$iIndex][5] = $time
	EndIf
EndFunc   ;==>SetLog

Func SetDebugLog($String, $Color = Default, $bSilentSetLog = False, $Font = "Verdana", $FontSize = 7.5, $statusbar = 0)
	If $Color = Default Then $Color = $COLOR_PURPLE
	Local $LogPrefix = "D "
	Local $log = $LogPrefix & TimeDebug() & $String
	If $String <> "" Then ConsoleWrite($log & @CRLF) ; Always write any log to console
	If $debugSetlog = 1 And $bSilentSetLog = False Then
		SetLog($String, $Color, $Font, $FontSize, $statusbar, Time(), False, $LogPrefix)
	Else
		If $hLogFileHandle = "" Then CreateLogFile()
		__FileWriteLog($hLogFileHandle, $log)
	EndIf
EndFunc   ;==>SetDebugLog

Func _GUICtrlRichEdit_AppendTextColor($hWnd, $sText, $iColor, $bGotoEnd = True)
	If $bGotoEnd Then _GUICtrlRichEdit_SetSel($hWnd, -1, -1)
	_GUICtrlRichEdit_SetCharColor($hWnd, $iColor)
	_GUICtrlRichEdit_AppendText($hWnd, $sText)
EndFunc   ;==>_GUICtrlRichEdit_AppendTextColor

Func _ColorConvert($nColor);RGB to BGR or BGR to RGB
	Return _
			BitOR(BitShift(BitAND($nColor, 0x000000FF), -16), _
			BitAND($nColor, 0x0000FF00), _
			BitShift(BitAND($nColor, 0x00FF0000), 16))
EndFunc   ;==>_ColorConvert

Func SetAtkLog($String1, $String2 = "", $Color = $COLOR_BLACK, $Font = "Lucida Console", $FontSize = 7.5) ;Sets the text for the log
	If $hAttackLogFileHandle = "" Then CreateAttackLogFile()
	;string1 see in video, string1&string2 put in file
	_GUICtrlRichEdit_SetFont($txtAtkLog, $FontSize, $Font)
	_GUICtrlRichEdit_AppendTextColor($txtAtkLog, $String1 & @CRLF, _ColorConvert($Color))
	_FileWriteLog($hAttackLogFileHandle, $String1 & $String2)
EndFunc   ;==>SetAtkLog

Func AtkLogHead()
	SetAtkLog(_PadStringCenter(" " & GetTranslated(601, 15, "ATTACK LOG") & " ", 71, "="), "", $COLOR_BLACK, "MS Shell Dlg", 8.5)
	SetAtkLog(GetTranslated(601, 16, "                   --------  LOOT --------       ----- BONUS ------"), "")
	SetAtkLog(GetTranslated(601, 17, " TIME|TROP.|SEARCH|   GOLD| ELIXIR|DARK EL|TR.|S|  GOLD|ELIXIR|  DE|L."), "")
EndFunc   ;==>AtkLogHead

Func __FileWriteLog($handle, $text)
	FileWriteLine($handle, $text)
EndFunc   ;==>__FileWriteLog
