; #FUNCTION# ====================================================================================================================
; Name ..........: SetLog
; Description ...:
; Syntax ........: SetLog($String[, $Color = $COLOR_BLACK[, $Font = "Verdana"[, $FontSize = 7.5[, $statusbar = 1[, $time = Time([,
;                  $bConsoleWrite = True]]]]]])
; Parameters ....: $sLogMessage         - The message which gets shown in Bot log
;                  $iColor               - [optional] an unknown value. Default is $COLOR_BLACK.
;                  $sFont                - [optional] an unknown value. Default is "Verdana".
;                  $iFontSize            - [optional] an unknown value. Default is 7.5.
;                  $statusbar           - [optional] a string value. Default is 1.
;                  $time                - [optional] a dll struct value. Default is Time(.
;                  $bConsoleWrite       - [optional] a boolean value. Default is True.
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (01-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_oTxtLogInitText = ObjCreate("Scripting.Dictionary")
Global $g_oTxtAtkLogInitText = ObjCreate("Scripting.Dictionary")


Func SetLog($sLogMessage, $iColor = Default, $sFont = Default, $iFontSize = Default, $iStatusbar = Default, $bConsoleWrite = Default) ;Sets the text for the log
	If $sLogMessage <> "" Then Return _SetLog($sLogMessage, $iColor, $sFont, $iFontSize, $iStatusbar, $bConsoleWrite)
EndFunc   ;==>SetLog

; internal _SetLog(), don't use outside this file
Func _SetLog($sLogMessage, $Color = Default, $Font = Default, $FontSize = Default, $statusbar = Default, $time = Default, $bConsoleWrite = Default, _
			$LogPrefix = Default, $bPostponed = Default, $bSilentSetLog = Default, $bWriteToLogFile = Default)

	If $Color = Default Then $Color = $COLOR_BLACK
	If $Font = Default Then $Font = "Verdana"
	If $FontSize = Default Then $FontSize = 7.5
	If $statusbar = Default Then $statusbar = 1
	If $time = Default Then $time = Time()
	Local $debugTime = TimeDebug()
	If $bConsoleWrite = Default Then $bConsoleWrite = True
	If $LogPrefix = Default Then $LogPrefix = "L "
	If $bPostponed = Default Then $bPostponed = $g_bCriticalMessageProcessing
	If $bSilentSetLog = Default Then $bSilentSetLog = $g_bSilentSetLog
	If $bWriteToLogFile = Default Then $bWriteToLogFile = True

	Local $log = $LogPrefix & $debugTime & $sLogMessage
	If $bConsoleWrite = True And $sLogMessage <> "" Then
		Local $sLevel = GetLogLevel($Color)
		ConsoleWrite($sLevel & $log & @CRLF) ; Always write any log to console
	EndIf
	If $g_hLogFile = 0 And $g_sProfileLogsPath Then
		CreateLogFile()
	EndIf

	; write to log file
	If $bWriteToLogFile Then __FileWriteLog($g_hLogFile, $log)
	If $bSilentSetLog = True And ($bWriteToLogFile = False Or $g_hLogFile) Then
		; Silent mode is active, only write to log file, not to log control
		Return
	EndIf
	;Local $txtLogMutex = AcquireMutex("txtLog")
	Local $a[6]
	$a[0] = $sLogMessage
	$a[1] = $Color
	$a[2] = $Font
	$a[3] = $FontSize
	$a[4] = $statusbar
	$a[5] = $time
	If $g_hLogFile = 0 Then
		; could not write to log file, so add additional info (does happen only before config file is available)
		ReDim $a[8]
		$a[6] = (($bSilentSetLog) ? (1) : (2)) ; write to log file with silent flag
		$a[7] = $LogPrefix & $debugTime ; log file prefix
	EndIf
	$g_oTxtLogInitText($g_oTxtLogInitText.Count + 1) = $a
	;ReleaseMutex($txtLogMutex)

	If ($g_hTxtLog <> 0 And $g_bRunState = False) Or ($bPostponed = False And __TimerDiff($g_hTxtLogTimer) >= $g_iTxtLogTimerTimeout) Then
		; log now to GUI
		CheckPostponedLog()
	EndIf
EndFunc   ;==>_SetLog

Func GetLogLevel($Color)
	; translate log level
	Local $sLevel = ""
	Switch $Color
	Case $COLOR_ERROR
		$sLevel = "ERROR    "
	Case $COLOR_WARNING
		$sLevel = "WARN     "
	Case $COLOR_SUCCESS
		$sLevel = "SUCCESS  "
	Case $COLOR_SUCCESS1
		$sLevel = "SUCCESS1 "
	Case $COLOR_INFO
		$sLevel = "INFO     "
	Case $COLOR_DEBUG
		$sLevel = "DEBUG    "
	Case $COLOR_DEBUG1
		$sLevel = "DEBUG1   "
	Case $COLOR_DEBUG2
		$sLevel = "DEBUG2   "
	Case $COLOR_DEBUGS
		$sLevel = "DEBUGS   "
	Case $COLOR_ACTION
		$sLevel = "ACTION   "
	Case $COLOR_ACTION1
		$sLevel = "ACTION1  "
	Case $COLOR_ORANGE
		$sLevel = "ORANGE   "
	Case $COLOR_BLACK
		$sLevel = "NORMAL   "
	Case Else
		$sLevel = Hex($Color, 6) & "   "
	EndSwitch
	Return $sLevel
EndFunc   ;==>GetLogLevel

Func SetLogText(ByRef $hTxtLog, ByRef $sLogMessage, ByRef $Color, ByRef $Font, ByRef $FontSize, ByRef $time) ;Sets the text for the log
	If $time Then
		_GUICtrlRichEdit_SetFont($hTxtLog, 6, "Lucida Console")
		_GUICtrlRichEdit_AppendTextColor($hTxtLog, $time, 0x000000, False)
	EndIf
	_GUICtrlRichEdit_SetFont($hTxtLog, $FontSize, $Font)
	_GUICtrlRichEdit_AppendTextColor($hTxtLog, $sLogMessage & @CRLF, _ColorConvert($Color), False)
EndFunc   ;==>SetLogText

Func SetDebugLog($sLogMessage, $Color = Default, $bSilentSetLog = Default, $Font = Default, $FontSize = Default, $statusbar = Default)
	If $Color = Default Then $Color = $COLOR_DEBUG
	If $bSilentSetLog = Default Then $bSilentSetLog = False
	If $statusbar = Default Then $statusbar = 0

	Local $LogPrefix = "D "
	Local $log = $LogPrefix & TimeDebug() & $sLogMessage
	If $g_iDebugSetlog = 1 And $bSilentSetLog = False Then
		_SetLog($sLogMessage, $Color, $Font, $FontSize, $statusbar, Default, True, $LogPrefix)
	Else
		If $sLogMessage <> "" Then ConsoleWrite(GetLogLevel($Color) & $log & @CRLF) ; Always write any log to console
		If $g_hLogFile = 0 And $g_sProfileLogsPath Then CreateLogFile()
		If $g_hLogFile Then
			__FileWriteLog($g_hLogFile, $log)
		Else
			; log later
			_SetLog($sLogMessage, $Color, $Font, $FontSize, $statusbar, Default, False, $LogPrefix, Default, True)
		EndIf
	EndIf
EndFunc   ;==>SetDebugLog

Func SetGuiLog($sLogMessage, $Color = Default, $bGuiLog = Default)
	If $bGuiLog = Default Then $bGuiLog = True
	If $bGuiLog = True Then
		Return _SetLog($sLogMessage, $Color)
	EndIf
	Return SetDebugLog($sLogMessage, $Color)
EndFunc   ;==>SetGuiLog

Func FlushGuiLog(ByRef $hTxtLog, ByRef $aTxtLog, $bUpdateStatus = False, $sLogMutexName = "txtLog")
	Local $wasLock = AndroidShieldLock(True) ; lock Android Shield as shield changes state when focus changes
	;Local $txtLogMutex = AcquireMutex($sLogMutexName) ; synchronize access

	Local $activeBot = _WinAPI_GetActiveWindow() = $g_hFrmBot ; different scroll to bottom when bot not active to fix strange bot activation flickering
	Local $hCtrl = _WinAPI_GetFocus() ; RichEdit tampers with focus so remember and restore
	If $hTxtLog Then
		_SendMessage($hTxtLog, $WM_SETREDRAW, False, 0) ; disable redraw so logging has no visiual effect
		_WinAPI_EnableWindow($hTxtLog, False) ; disable RichEdit
		_GUICtrlRichEdit_SetSel($hTxtLog, -1, -1) ; select end
	EndIf

	;add existing Log
	Local $sLastStatus = ""
	For $i = 1 To $aTxtLog.Count
		Local $a = $aTxtLog($i)
		Local $iSize = UBound($a)
		If $hTxtLog Then
			If $iSize = 0 And $a = 0 Then
				; clear log command
				_GUICtrlEdit_SetText($hTxtLog, "")
				ContinueLoop
			EndIf
			If $iSize = 6 Or ($iSize > 6 And $a[6] = 2) Then
				; log to GUI
				SetLogText($hTxtLog, $a[0], $a[1], $a[2], $a[3], $a[5])
			EndIf
		EndIf
		If $iSize > 7 And $a[6] > 0 Then
			; log to file now (must be normal log, not attack log)
			__FileWriteLog($g_hLogFile, $a[7] & $a[0])
			If $a[6] = 1 Then
				; was silent
				ContinueLoop
			EndIf
		EndIf

		If $bUpdateStatus = True And $g_hStatusBar <> 0 And $a[4] = 1 Then
			$sLastStatus = $a[0]
			; only till CR/LF or text overwrites
			Local $iPosCr = StringInStr($sLastStatus, Chr(13))
			Local $iPosLf = StringInStr($sLastStatus, Chr(10))
			Local $iPos = $iPosCr
			If $iPosLf > 0 And $iPosLf < $iPosCr Then $iPos = $iPosLf
			If $iPos > 0 Then $sLastStatus = StringLeft($sLastStatus, $iPos - 1)
		EndIf
	Next

	If $sLastStatus Then
		_GUICtrlStatusBar_SetText($g_hStatusBar, "Status : " & $sLastStatus)
	EndIf

	Local $iLogs = $aTxtLog.Count
	$aTxtLog.RemoveAll

	If $hTxtLog Then
		_WinAPI_EnableWindow($hTxtLog, True) ; enabled RichEdit again
		_GUICtrlRichEdit_SetSel($hTxtLog, -1, -1) ; select end (scroll to end)
		_SendMessage($hTxtLog, $WM_SETREDRAW, True, 0) ; enabled RechEdit redraw again
		_WinAPI_RedrawWindow($hTxtLog, 0, 0, $RDW_INVALIDATE) ; redraw RichEdit
		If $activeBot And $hCtrl <> $hTxtLog Then _WinAPI_SetFocus($hCtrl) ; Restore Focus
	EndIf

	;ReleaseMutex($txtLogMutex) ; end of synchronized block
	AndroidShieldLock($wasLock) ; unlock Android Shield
	Return $iLogs
EndFunc   ;==>FlushGuiLog

Func CheckPostponedLog($bNow = False)
	Local $iLogs = 0
	If $g_bCriticalMessageProcessing Or ($bNow = False And __TimerDiff($g_hTxtLogTimer) < $g_iTxtLogTimerTimeout) Then Return 0

	If $g_oTxtLogInitText.Count > 0 And $g_hTxtLog <> 0 Then
		$iLogs += FlushGuiLog($g_hTxtLog, $g_oTxtLogInitText, True, "txtLog")
	EndIf

	If $g_oTxtAtkLogInitText.Count > 0 And $g_hTxtAtkLog <> 0 Then
		$iLogs += FlushGuiLog($g_hTxtAtkLog, $g_oTxtAtkLogInitText, False, "txtAtkLog")
	EndIf

	$g_hTxtLogTimer = __TimerInit()
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

	;Local $txtLogMutex = AcquireMutex("txtAtkLog")
	Dim $a[6]
	$a[0] = $String1
	$a[1] = $Color
	$a[2] = $Font
	$a[3] = $FontSize
	$a[4] = 0 ; no status bar update
	$a[5] = 0 ; no time
	$g_oTxtAtkLogInitText($g_oTxtAtkLogInitText.Count + 1) = $a
	;ReleaseMutex($txtLogMutex)

EndFunc   ;==>SetAtkLog

Func AtkLogHead()
	SetAtkLog(_PadStringCenter(" " & GetTranslatedFileIni("MBR Func_AtkLogHead", "AtkLogHead_Text_01", "ATTACK LOG") & " ", 71, "="), "", $COLOR_BLACK, "MS Shell Dlg", 8.5)
	SetAtkLog(GetTranslatedFileIni("MBR Func_AtkLogHead", "AtkLogHead_Text_02", '|                  --------  LOOT --------       ----- BONUS ------'), "")
	SetAtkLog(GetTranslatedFileIni("MBR Func_AtkLogHead", "AtkLogHead_Text_03", '|TIME|TROP.|SEARCH|   GOLD| ELIXIR|DARK EL|TR.|S|  GOLD|ELIXIR|  DE|L.'), "")
EndFunc   ;==>AtkLogHead

Func __FileWriteLog($handle, $text)
	Return FileWriteLine($handle, $text)
EndFunc   ;==>__FileWriteLog

Func ClearLog($hRichEditCtrl = $g_hTxtLog)
	Switch $hRichEditCtrl
	Case $g_hTxtLog
		$g_oTxtLogInitText($g_oTxtLogInitText.Count + 1) = 0
	Case $g_hTxtAtkLog
		$g_oTxtAtkLogInitText($g_oTxtAtkLogInitText.Count + 1) = 0
	EndSwitch
EndFunc   ;==>ClearLog

Func SetLogCentered($String, $sPad = Default, $Color = Default, $bClearLog = False)
	If $sPad = Default Then $sPad = "="
	If $bClearLog = True Then ClearLog($g_hTxtLog)
	_SetLog(_PadStringCenter($String, 53, $sPad), $Color, "Lucida Console", 8)
EndFunc   ;==>SetLogCentered