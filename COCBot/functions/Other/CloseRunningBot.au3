; #FUNCTION# ====================================================================================================================
; Name ..........: CloseRunningBot
; Description ...: Code to close existing My Bot instance by Window Title
; Syntax ........:
; Parameters ....: $sBotWindowTitle
; Return values .: True if window found and closed
; Author ........: Cosote (2016-01)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func CloseRunningBot($sBotWindowTitle)
	; terminate same bot instance, this current instance doesn't have main window yet, so no need to exclude this PID
	Local $otherHWnD = WinGetHandle($sBotTitle)
	If @error = 0 Then
		; other bot window found
		Local $otherPID = WinGetProcess($otherHWnD)
		SetDebugLog("Found existing " & $sBotTitle & " instance to close, PID " & $otherPID & ", HWnD " & $otherHWnD)
		If WinClose($otherHWnD) = 1 Then
			SetDebugLog("Existing bot window closed")
		EndIf
		If WinWaitClose($otherHWnD, "", 10) = 0 Then
			; bot didn't close in 10 secodns, force close now
			SetDebugLog("Existing bot window still there...")
			WinKill($otherHWnD)
			SetDebugLog("Existing bot window killed")
		EndIf
		; paranoia section...
		If ProcessExists($otherPID) = $otherPID Then
			SetDebugLog("Existing bot process still there...")
			If ProcessClose($otherPID) = 1 Then
				SetDebugLog("Existing bot process now closed")
				Return True
			Else
				Switch @error
					Case 1 ; OpenProcess failed
						SetDebugLog("Existing bot process close error: OpenProcess failed")
					Case 2 ; AdjustTokenPrivileges Failed
						SetDebugLog("Existing bot process close error: AdjustTokenPrivileges Failed")
					Case 3 ; TerminateProcess Failed
						SetDebugLog("Existing bot process close error: TerminateProcess Failed")
					Case 4 ; Cannot verify if process exists
						SetDebugLog("Existing bot process close error: Cannot verify if process exists")
				EndSwitch
				Return False
			EndIf
		EndIf
		Return True
	EndIf
	Return False
EndFunc   ;==>CloseRunningBot
