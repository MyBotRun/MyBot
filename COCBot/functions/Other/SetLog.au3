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
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $aTxtLogInitText[0][6] = [[]]
Global $aTxtAtkLogInitText[0][6] = [[]]


Func SetLog($String, $Color = Default, $Font = Default, $FontSize = Default, $statusbar = Default, $time = Default, $bConsoleWrite = True, _
			$LogPrefix = "L ", $bPostponed = $g_bCriticalMessageProcessing) ;Sets the text for the log

	If $Color = Default Then $Color = $COLOR_BLACK
	If $Font = Default Then $Font = "Verdana"
	If $FontSize = Default Then $FontSize = 7.5
	If $statusbar = Default Then $statusbar = 1
	If $time = Default Then $time = Time()
	Local $log = $LogPrefix & TimeDebug() & $String
	If $bConsoleWrite = True And $String <> "" Then ConsoleWrite($log & @CRLF) ; Always write any log to console
	If $g_hLogFile = 0 Then CreateLogFile()

	; write to log file
	__FileWriteLog($g_hLogFile, $log)
	If $g_bSilentSetLog = True Then
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

	If $g_hTxtLog <> 0 And $g_bRunState = False Or ($bPostponed = False And TimerDiff($g_hTxtLogTimer) >= $g_iTxtLogTimerTimeout) Then
		; log now to GUI
		CheckPostponedLog()
	EndIf
EndFunc   ;==>SetLog

Func SetLogText(ByRef $hTxtLog, ByRef $String, ByRef $Color, ByRef $Font, ByRef $FontSize, ByRef $time) ;Sets the text for the log
	If $time Then
		_GUICtrlRichEdit_SetFont($hTxtLog, 6, "Lucida Console")
		_GUICtrlRichEdit_AppendTextColor($hTxtLog, $time, 0x000000, False)
	EndIf
	_GUICtrlRichEdit_SetFont($hTxtLog, $FontSize, $Font)
	_GUICtrlRichEdit_AppendTextColor($hTxtLog, $String & @CRLF, _ColorConvert($Color), False)
EndFunc   ;==>SetLogText

Func SetDebugLog($String, $Color = Default, $bSilentSetLog = Default, $Font = Default, $FontSize = Default, $statusbar = Default)
	If $Color = Default Then $Color = $COLOR_DEBUG
	If $bSilentSetLog = Default Then $bSilentSetLog = False
	If $statusbar = Default Then $statusbar = 0

	Local $LogPrefix = "D "
	Local $log = $LogPrefix & TimeDebug() & $String
	If $String <> "" Then ConsoleWrite($log & @CRLF) ; Always write any log to console
	If $g_iDebugSetlog = 1 And $bSilentSetLog = False Then
		SetLog($String, $Color, $Font, $FontSize, $statusbar, Time(), False, $LogPrefix)
	 Else
		If $g_hLogFile = 0 Then CreateLogFile()
		__FileWriteLog($g_hLogFile, $log)
	EndIf
EndFunc   ;==>SetDebugLog

Func SetGuiLog($String, $Color = Default, $bGuiLog = Default)
	If $bGuiLog = Default Then $bGuiLog = True
	If $bGuiLog = True Then
		Return SetLog($String, $Color)
	EndIf
	Return SetDebugLog($String, $Color)
EndFunc   ;==>SetGuiLog

Func FlushGuiLog(ByRef $hTxtLog, ByRef $aTxtLog, $bUpdateStatus = False, $sLogMutexName = "txtLog")
	Local $wasLock = AndroidShieldLock(True) ; lock Android Shield as shield changes state when focus changes
	Local $txtLogMutex = AcquireMutex($sLogMutexName) ; synchronize access

	Local $activeBot = _WinAPI_GetActiveWindow() = $g_hFrmBot ; different scroll to bottom when bot not active to fix strange bot activation flickering
	Local $hCtrl = _WinAPI_GetFocus() ; RichEdit tampers with focus so remember and restore
	_SendMessage($hTxtLog, $WM_SETREDRAW, False, 0) ; disable redraw so logging has no visiual effect
	_WinAPI_EnableWindow($hTxtLog, False) ; disable RichEdit
	_GUICtrlRichEdit_SetSel($hTxtLog, -1, -1) ; select end

	;add existing Log
	Local $i
	For $i = 0 To UBound($aTxtLog) - 1
		If $i < UBound($aTxtLog) And UBound($aTxtLog, 2) > 5 Then
			SetLogText($hTxtLog, $aTxtLog[$i][0], $aTxtLog[$i][1], $aTxtLog[$i][2], $aTxtLog[$i][3], $aTxtLog[$i][5])
		EndIf
	Next
	Local $iLogs = UBound($aTxtLog)
	If $bUpdateStatus = True And $iLogs - 1 >= 0 And $aTxtLog[$iLogs - 1][4] = 1 And $g_hStatusBar <> 0 Then
		_GUICtrlStatusBar_SetText($g_hStatusBar, "Status : " & $aTxtLog[$iLogs - 1][0])
	EndIf

	$iLogs = UBound($aTxtLog)
	Redim $aTxtLog[0][6]

	_WinAPI_EnableWindow($hTxtLog, True) ; enabled RichEdit again
	_GUICtrlRichEdit_SetSel($hTxtLog, -1, -1) ; select end (scroll to end)
	_SendMessage($hTxtLog, $WM_SETREDRAW, True, 0) ; enabled RechEdit redraw again
	_WinAPI_RedrawWindow($hTxtLog, 0, 0, $RDW_INVALIDATE) ; redraw RichEdit
	If $activeBot And $hCtrl <> $hTxtLog Then _WinAPI_SetFocus($hCtrl) ; Restore Focus

	ReleaseMutex($txtLogMutex) ; end of synchronized block
	AndroidShieldLock($wasLock) ; unlock Android Shield
	Return $iLogs
EndFunc   ;==>FlushGuiLog

Func CheckPostponedLog()
	Local $iLogs = 0
	If $g_bCriticalMessageProcessing Or TimerDiff($g_hTxtLogTimer) < $g_iTxtLogTimerTimeout Then Return 0

	If UBound($aTxtLogInitText) > 0 And $g_hTxtLog <> 0 Then
		$iLogs += FlushGuiLog($g_hTxtLog, $aTxtLogInitText, True, "txtLog")
	EndIf

	If UBound($aTxtAtkLogInitText) > 0 And $g_hTxtAtkLog <> 0 Then
		$iLogs += FlushGuiLog($g_hTxtAtkLog, $aTxtAtkLogInitText, False, "txtAtkLog")
	EndIf

	$g_hTxtLogTimer = TimerInit()
	Return $iLogs
EndFunc   ;==>CheckPostponedLog

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
	If $g_hAttackLogFile = 0 Then CreateAttackLogFile()
	;string1 see in video, string1&string2 put in file
	_FileWriteLog($g_hAttackLogFile, $String1 & $String2)

	Local $txtLogMutex = AcquireMutex("txtAtkLog")
	Local $iIndex = UBound($aTxtAtkLogInitText)
	ReDim $aTxtAtkLogInitText[$iIndex + 1][6]
	$aTxtAtkLogInitText[$iIndex][0] = $String1
	$aTxtAtkLogInitText[$iIndex][1] = $Color
	$aTxtAtkLogInitText[$iIndex][2] = $Font
	$aTxtAtkLogInitText[$iIndex][3] = $FontSize
	$aTxtAtkLogInitText[$iIndex][4] = 0 ; no status bar update
	$aTxtAtkLogInitText[$iIndex][5] = 0 ; no time
	ReleaseMutex($txtLogMutex)

EndFunc   ;==>SetAtkLog

Func AtkLogHead()
	SetAtkLog(_PadStringCenter(" " & GetTranslated(601, 15, "ATTACK LOG") & " ", 71, "="), "", $COLOR_BLACK, "MS Shell Dlg", 8.5)
	SetAtkLog(GetTranslated(601, 16, "                   --------  LOOT --------       ----- BONUS ------"), "")
	SetAtkLog(GetTranslated(601, 17, " TIME|TROP.|SEARCH|   GOLD| ELIXIR|DARK EL|TR.|S|  GOLD|ELIXIR|  DE|L."), "")
EndFunc   ;==>AtkLogHead

Func __FileWriteLog($handle, $text)
	FileWriteLine($handle, $text)
EndFunc   ;==>__FileWriteLog
