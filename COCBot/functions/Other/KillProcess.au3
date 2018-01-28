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
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: checkMainscreen, isProblemAffect
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func KillProcess($pid, $process_info = "", $attempts = 3)
	Local $iCount = 0
	If $process_info <> "" Then $process_info = ", " & $process_info
	While ProcessExists($pid) And $iCount < $attempts
		If ProcessClose($pid) = 1 Then
			SetDebugLog("KillProcess(" & $iCount & "): PID = " & $pid & " closed" & $process_info)
		Else
			Switch @error
				Case 1 ; OpenProcess failed
					SetDebugLog("Process close error: OpenProcess failed")
				Case 2 ; AdjustTokenPrivileges Failed
					SetDebugLog("Process close error: AdjustTokenPrivileges Failed")
				Case 3 ; TerminateProcess Failed
					SetDebugLog("Process close error: TerminateProcess Failed")
				Case 4 ; Cannot verify if process exists
					SetDebugLog("Process close error: Cannot verify if process exists")
			EndSwitch
		EndIf
		If ProcessExists($pid) Then ; If it is still running, then try again
			ShellExecute(@WindowsDir & "\System32\taskkill.exe", " -pid " & $pid, "", Default, @SW_HIDE)
			If _Sleep(1000) Then Return False; Give OS time to work
			If ProcessExists($pid) = 0 Then
				SetDebugLog("KillProcess(" & $iCount & "): PID = " & $pid & " killed (using taskkill)" & $process_info)
			EndIf
		EndIf
		If ProcessExists($pid) Then ; If it is still running, then force kill it (and entire tree!)
			ShellExecute(@WindowsDir & "\System32\taskkill.exe", "-f -t -pid " & $pid, "", Default, @SW_HIDE)
			If _Sleep(1000) Then Return False; Give OS time to work
			If ProcessExists($pid) = 0 Then
				SetDebugLog("KillProcess(" & $iCount & "): PID = " & $pid & " killed (using taskkill -f -t)" & $process_info)
			EndIf
		EndIf
		$iCount += 1
	WEnd
	If ProcessExists($pid) Then
		SetDebugLog("KillProcess(" & $iCount & "): PID = " & $pid & " failed to kill" & $process_info, $COLOR_ERROR)
		Return False
	EndIf
	Return True ; process ssuccessfuly killed
EndFunc   ;==>KillProcess
