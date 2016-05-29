;
; #FUNCTION# ====================================================================================================================
; Name ..........: KillProcess
; Description ...:
; Syntax ........: KillProcess($pid, $process_info = "", $attempts = 3)
; Parameters ....: $pid, Process Id
;                : $process_info, additional process info like process filename or full command line for Debug Log
;                : $attempts, number of attempts
; Return values .: True if process was killed, false if not or _Sleep interrupted
; Author ........: Cosote (Dec-2015)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: checkMainscreen, isProblemAffect
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func KillProcess($pid, $process_info = "", $attempts = 3)
	Local $iCount = 0
	If $process_info <> "" Then $process_info = ", " & $process_info
	While ProcessExists($pid) And $iCount < $attempts
		SetDebugLog("KillProcess(" & $iCount & "): PID = " & $pid & $process_info)
		ShellExecute(@WindowsDir & "\System32\taskkill.exe", " -pid " & $pid, "", Default, @SW_HIDE)
		If _Sleep(1000) Then Return False; Give OS time to work
		If ProcessExists($pid) Then ; If it is still running, then force kill it (and entire tree!)
			SetDebugLog("KillProcess(" & $iCount & "): PID = " & $pid & ", 1st kill failed, trying again" & $process_info)
			ShellExecute(@WindowsDir & "\System32\taskkill.exe", "-f -t -pid " & $pid, "", Default, @SW_HIDE)
			If _Sleep(500) Then Return False; Give OS time to work
		EndIf
		$iCount += 1
	WEnd
	If ProcessExists($pid) Then
		Return False
	EndIf
	Return True ; process ssuccessfuly killed
EndFunc   ;==>KillProcess
