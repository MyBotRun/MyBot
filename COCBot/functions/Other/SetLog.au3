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
Func SetLog($String, $Color = Default, $Font = Default, $FontSize = Default, $statusbar = Default, $time = Default, $bConsoleWrite = True, $LogPrefix = "L ", $bPostponed = $bCriticalMessageProcessing) ;Sets the text for the log
	If $Color = Default Then $Color = $COLOR_BLACK
	If $Font = Default Then $Font = "Verdana"
	If $FontSize = Default Then $FontSize = 7.5
	If $statusbar = Default Then $statusbar = 1
	If $time = Default Then $time = Time()
	Local $log = $LogPrefix & TimeDebug() & $String
	If $bConsoleWrite = True And $String <> "" Then ConsoleWrite($log & @CRLF) ; Always write any log to console
	If $hLogFileHandle = "" Then CreateLogFile()
	; write to log file
	__FileWriteLog($hLogFileHandle, $log)
	If $SilentSetLog = True Then
		; Silent mode is active, only write to log file, not to log control
		Return
	EndIf
	Local $txtLogMutex = AcquireMutex("txtLog")
	Local $iIndex = UBound($aTxtLogInitText)
	ReDim $aTxtLogInitText[$iIndex + 1][6]
	$aTxtLogInitText[$iIndex][0] = $String
	$aTxtLogInitText[$iIndex][1] = $Color
	$aTxtLogInitText[$iIndex][2] = $Font
	$aTxtLogInitText[$iIndex][3] = $FontSize
	$aTxtLogInitText[$iIndex][4] = $statusbar
	$aTxtLogInitText[$iIndex][5] = $time
	ReleaseMutex($txtLogMutex)
	If IsDeclared("txtLog") And $RunState = False Or ($bPostponed = False And TimerDiff($hTxtLogTimer) >= $iTxtLogTimerTimeout) Then
		; log now to GUI
		CheckPostponedLog()
	EndIf
EndFunc   ;==>SetLog

Func SetLogText($String, $Color, $Font, $FontSize, $time) ;Sets the text for the log
	_GUICtrlRichEdit_SetFont($txtLog, 6, "Lucida Console")
	_GUICtrlRichEdit_AppendTextColor($txtLog, $time, 0x000000, False)
	_GUICtrlRichEdit_SetFont($txtLog, $FontSize, $Font)
	_GUICtrlRichEdit_AppendTextColor($txtLog, $String & @CRLF, _ColorConvert($Color), False)
EndFunc   ;==>SetLogText

Func SetDebugLog($String, $Color = Default, $bSilentSetLog = Default, $Font = Default, $FontSize = Default, $statusbar = Default)
	If $Color = Default Then $Color = $COLOR_DEBUG
	If $bSilentSetLog = Default Then $bSilentSetLog = False
	If $statusbar = Default Then $statusbar = 0

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

Func SetGuiLog($String, $Color = Default, $bGuiLog = Default)
	If $bGuiLog = Default Then $bGuiLog = True
	If $bGuiLog = True Then
		Return SetLog($String, $Color)
	EndIf
	Return SetDebugLog($String, $Color)
EndFunc   ;==>SetGuiLog

Func CheckPostponedLog()
	If $bCriticalMessageProcessing Or TimerDiff($hTxtLogTimer) < $iTxtLogTimerTimeout Then Return 0
	If UBound($aTxtLogInitText) > 0 And IsDeclared("txtLog") Then
		Local $wasLock = AndroidShieldLock(True) ; lock Android Shield as shield changes state when focus changes
		Local $txtLogMutex = AcquireMutex("txtLog") ; synchronize access

		Local $activeBot = _WinAPI_GetActiveWindow() = $frmBot ; different scroll to bottom when bot not active to fix strange bot activation flickering
		Local $hCtrl = _WinAPI_GetFocus() ; RichEdit tampers with focus so remember and restore
		_SendMessage($txtLog, $WM_SETREDRAW, False, 0) ; disable redraw so logging has no visiual effect
		_WinAPI_EnableWindow($txtLog, False) ; disable RichEdit
		_GUICtrlRichEdit_SetSel($txtLog, -1, -1) ; select end

		;add existing Log
		;Execute("LogPostponedText()")
		LogPostponedText()
		$hTxtLogTimer = TimerInit()

		$iLogs = UBound($aTxtLogInitText)
		Redim $aTxtLogInitText[0][6]

		_WinAPI_EnableWindow($txtLog, True) ; enabled RichEdit again
		_GUICtrlRichEdit_SetSel($txtLog, -1, -1) ; select end (scroll to end)
		_SendMessage($txtLog, $WM_SETREDRAW, True, 0) ; enabled RechEdit redraw again
		_WinAPI_RedrawWindow($txtLog, 0, 0, $RDW_INVALIDATE) ; redraw RichEdit
		If $activeBot And $hCtrl <> $txtLog Then _WinAPI_SetFocus($hCtrl) ; Restore Focus

		ReleaseMutex($txtLogMutex) ; end of synchronized block
		AndroidShieldLock($wasLock) ; unlock Android Shield

		Return $iLogs
	EndIf

	Return 0
EndFunc   ;==>CheckPostponedLog

Func LogPostponedText()
	Local $i
	For $i = 0 To UBound($aTxtLogInitText) - 1
		If $i < UBound($aTxtLogInitText) And UBound($aTxtLogInitText, 2) > 5 Then
			SetLogText($aTxtLogInitText[$i][0], $aTxtLogInitText[$i][1], $aTxtLogInitText[$i][2], $aTxtLogInitText[$i][3], $aTxtLogInitText[$i][5])
		EndIf
	Next
	Local $iLogs = UBound($aTxtLogInitText)
	If $iLogs - 1 >= 0 And $aTxtLogInitText[$iLogs - 1][4] = 1 And IsDeclared("statLog") Then
		_GUICtrlStatusBar_SetText($statLog, "Status : " & $aTxtLogInitText[$iLogs - 1][0])
	EndIf
EndFunc   ;==>LogPostponedLogs

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

	_SendMessage($txtAtkLog, $WM_SETREDRAW, False, 0) ; disable redraw so logging has no visiual effect
	_WinAPI_EnableWindow($txtAtkLog, False) ; disable RichEdit

	_GUICtrlRichEdit_SetFont($txtAtkLog, $FontSize, $Font)
	_GUICtrlRichEdit_AppendTextColor($txtAtkLog, $String1 & @CRLF, _ColorConvert($Color), False)

	_WinAPI_EnableWindow($txtAtkLog, True) ; enabled RichEdit again
	_SendMessage($txtAtkLog, $WM_SETREDRAW, True, 0) ; enabled RechEdit redraw again
	_WinAPI_RedrawWindow($txtAtkLog, 0, 0, $RDW_INVALIDATE) ; redraw RichEdit
	_GUICtrlRichEdit_SetSel($txtAtkLog, -1, -1) ; select end (scroll to end)

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
