; #FUNCTION# ====================================================================================================================
; Name ..........: Synchronization functions
; Description ...: Synchronize access to functions or code
; Syntax ........:
; Parameters ....:
; Return values .:
; Author ........: Cosote (2016-08)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func AcquireMutex($mutexName, $scope = Default, $timout = Default)
	Local $timer = TimerInit()
	Local $hMutex_MyBot = 0
	If $scope = Default Then
		$scope = @AutoItPID + "/"
	ElseIf $scope <> "" Then
		$scope += "/"
	EndIf
	If $timout = Default Then $timeout = 30000
	While $hMutex_MyBot = 0 And ($timout = 0 Or TimerDiff($timer) < $timout)
		$hMutex_MyBot = _Singleton("MyBot.run/" + $scope + $mutexName, 1)
		If $hMutex_MyBot <> 0 Then ExitLoop
		If $timout = 0 Then ExitLoop
		Sleep($iDelaySleep)
	WEnd
	Return $hMutex_MyBot
EndFunc   ;==>AcquireMutex

Func ReleaseMutex($hMutex, $ReturnValue = Default)
	_WinAPI_CloseHandle($hMutex)
	If $ReturnValue = Default Then Return
	Return $ReturnValue
EndFunc   ;==>ReleaseMutex

Func WaitForSemaphore($sSemaphore, $iInitial = 4096, $iMaximum = 4096, $tSecurity = 0)
	Local $bAquired = False
	While $bAquired = False
		Local $hSemaphore = _WinAPI_CreateSemaphore($sSemaphore, $iInitial, $iMaximum, $tSecurity)
		$bAquired = _WinAPI_WaitForSingleObject($hSemaphore, 0) <> -1
		If $bAquired = True Then
			_WinAPI_ReleaseSemaphore($hSemaphore)
			_WinAPI_CloseHandle($hSemaphore)
			ExitLoop
		EndIf
		_Sleep($iDelaySleep, True, False)
	WEnd
EndFunc   ;==>WaitForSemaphore

Func LockSemaphore($sSemaphore)
	Local $bAquired = False
	While $bAquired = False
		Local $hSemaphore = _WinAPI_CreateSemaphore($sSemaphore, 0, 1)
		$bAquired = _WinAPI_WaitForSingleObject($hSemaphore, 0) <> -1
		If $bAquired = True And _WinAPI_WaitForSingleObject($hSemaphore, 0) = -1 Then
			Return $hSemaphore
			ExitLoop
		EndIf
		_WinAPI_ReleaseSemaphore($hSemaphore)
		_WinAPI_CloseHandle($hSemaphore)
		_Sleep($iDelaySleep, True, False)
	WEnd
EndFunc   ;==>LockSemaphore

Func UnlockSemaphore($hSemaphore)
	If $hSemaphore <> 0 And $hSemaphore <> -1 Then
		_WinAPI_ReleaseSemaphore($hSemaphore)
		Return _WinAPI_CloseHandle($hSemaphore)
	EndIf
	Return False
EndFunc   ;==>UnlockSemaphore
