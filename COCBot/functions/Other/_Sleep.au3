; #FUNCTION# ====================================================================================================================
; Name ..........: _Sleep
; Description ...:
; Syntax ........: _Sleep($iDelay[, $iSleep = True])
; Parameters ....: $iDelay              - an integer value.
;                  $iSleep              - [optional] an integer value. Default is True. unused and deprecated
;                  $$CheckRunState      - Exit and returns True if $RunState is False
; Return values .: True when $RunState is False otherwise True (also True if $CheckRunState=False)
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _Sleep($iDelay, $iSleep = True, $CheckRunState = True, $SleepWhenPaused = True)
	Local $iBegin = TimerInit()

	; track GDI count
	If $DebugGdiCount <> 0 Then
		Local $iCount = _WinAPI_GetGuiResources()
		If $iCount <> $DebugGdiCount Then
			SetDebugLog("GDI Handle Count: " & $iCount)
			$DebugGdiCount = $iCount
		EndIf
	EndIf

	If SetCriticalMessageProcessing() = False Then

		If $bMoveDivider Then
			MoveDivider()
			$bMoveDivider = False
		EndIf

		If $iDelay > 0 And TimerDiff($hTxtLogTimer) >= $iTxtLogTimerTimeout Then
			If $NotifyDeleteAllPushesNow = True Then PushMsg("DeleteAllPBMessages") ; only when button is pushed, and only when on a sleep cyle

			If TimerDiff($hTimer_PBRemoteControlInterval) >= $PBRemoteControlInterval Then
				PushBulletRemoteControl()
				$hTimer_PBRemoteControlInterval = TimerInit()
			EndIf
			If TimerDiff($hTimer_PBDeleteOldPushesInterval) >= $PBDeleteOldPushesInterval Then
				PushBulletDeleteOldPushes()
				$hTimer_PBDeleteOldPushesInterval = TimerInit()
			EndIf
			If $RunState And TestCapture() = False And TimerDiff($hTimer_EmptyWorkingSetAndroid) >= $iEmptyWorkingSetAndroid Then
				If IsArray(getAndroidPos(True)) = 1 Then _WinAPI_EmptyWorkingSet(GetAndroidPid()) ; Reduce Working Set of Android Process
				$hTimer_EmptyWorkingSetAndroid = TimerInit()
			EndIf
			If TimerDiff($hTimer_EmptyWorkingSetBot) >= $iEmptyWorkingSetBot Then
				_WinAPI_EmptyWorkingSet(@AutoItPID) ; Reduce Working Set of Bot
				$hTimer_EmptyWorkingSetBot = TimerInit()
			EndIF

			CheckPostponedLog()
		EndIf
	EndIf
	;AndroidEmbedCheck()
	;AndroidShieldCheck()
	If $CheckRunState = True And $RunState = False Then
		ResumeAndroid()
		Return True
	EndIf
	Local $iRemaining = $iDelay - TimerDiff($iBegin)
	While $iRemaining > 0
		DllCall($hNtDll, "dword", "ZwYieldExecution")
		If $CheckRunState = True And $RunState = False Then
			ResumeAndroid()
			Return True
		EndIf
		If SetCriticalMessageProcessing() = False Then
			If $TPaused And $SleepWhenPaused And $TogglePauseAllowed Then TogglePauseSleep() ; Bot is paused
			If $TogglePauseUpdateState Then TogglePauseUpdateState("_Sleep") ; Update Pause GUI states
			If $iMakeScreenshotNow = True Then
				If $iScreenshotType = 0 Then
					MakeScreenshot($dirTemp, "jpg")
				Else
					MakeScreenshot($dirTemp, "png")
				EndIf
			EndIf
			If TimerDiff($hTxtLogTimer) >= $iTxtLogTimerTimeout Then
				If $RunState And Not $bSearchMode And Not $TPaused And ($hTimer_SetTime = 0 Or TimerDiff($hTimer_SetTime) >= 750) Then
					SetTime()
					$hTimer_SetTime = TimerInit()
				EndIf
				AndroidEmbedCheck()
				AndroidShieldCheck()
				CheckPostponedLog()
			EndIf
		EndIf
		$iRemaining = $iDelay - TimerDiff($iBegin)
		If $iRemaining >= $iDelaySleep Then
			_SleepMilli($iDelaySleep)
		Else
			_SleepMilli($iRemaining)
		EndIf
	WEnd
	Return False
EndFunc   ;==>_Sleep

Func _SleepMicro($iMicroSec)
	;Local $hStruct_SleepMicro = DllStructCreate("int64 time;")
	;Local $pStruct_SleepMicro = DllStructGetPtr($hStruct_SleepMicro)
    DllStructSetData($hStruct_SleepMicro, "time", $iMicroSec * -10)
    DllCall($hNtDll, "dword", "ZwDelayExecution", "int", 0, "ptr", $pStruct_SleepMicro)
	;$hStruct_SleepMicro = 0
EndFunc   ;==>_SleepMicro

Func _SleepMilli($iMilliSec)
	_SleepMicro(Int($iMilliSec * 1000))
EndFunc   ;==>_SleepMilli
