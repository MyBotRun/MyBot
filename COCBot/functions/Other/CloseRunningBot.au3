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
	Local $param = ""
	For $i = 1 To $aCmdLine[0]
		If $param <> "" Then $param &= " "
		$param &= $aCmdLine[$i]
	Next
	Local $otherPID = 0
	Local $otherPIDs = 0
	If $param <> "" Then
		$otherPIDs = ProcessesExist(@AutoItExe, $param, 1, 1)
	EndIf
	Local $otherHWnD = WinGetHandle($sBotTitle)
	If @error = 0 Or UBound($otherPIDs) > 0 Then
		; other bot window found
		If $otherHWnD <> 0 Then
			$otherPID = WinGetProcess($otherHWnD)
		Else
			; find PID in array
			For $pid In $otherPIDs
				If $pid <> @AutoItPID Then
					$otherPID = $pid
					ExitLoop
				EndIf
			Next
		EndIf
		If $otherPID > 0 And $otherPID <> @AutoItPID Then
			SetDebugLog("Found existing " & $sBotTitle & " instance to close, PID " & $otherPID & ", HWnD " & $otherHWnD)
			; close any related WerFault Window as well
			WerFaultClose("AutoIt v3 Script")
			WerFaultClose(@AutoItExe)
			If WinClose($otherHWnD) = 1 Then
				SetDebugLog("Existing bot window closed")
			EndIf
			If ProcessWaitClose($otherPID, 30) = 0 Then
				; bot didn't close in 30 secodns, force close now
				SetDebugLog("Existing bot window still there...")
				WinKill($otherHWnD)
				SetDebugLog("Existing bot window killed")
			EndIf
			; paranoia section...
			If ProcessExists($otherPID) = $otherPID Then
				SetDebugLog("Existing bot process still there...")
				If KillProcess($otherPID, "CloseRunningBot") = True Then
					SetDebugLog("Existing bot process now closed")
					Return True
				EndIf
				Return False
			EndIf
			Return True
		EndIf
	EndIf
	Return False
EndFunc   ;==>CloseRunningBot
