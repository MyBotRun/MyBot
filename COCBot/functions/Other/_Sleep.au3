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
	If SetCriticalMessageProcessing() = False Then
		CheckPostponedLog()
		If $iDelay > 0 Then

			If $RunState And Not $bSearchMode And Not $TPaused And ($hTimer_SetTime = 0 Or TimerDiff($hTimer_SetTime) >= 1000) Then
				SetTime()
				$hTimer_SetTime = TimerInit()
			EndIf
			If $hTimer_PBRemoteControlInterval = 0 Or TimerDiff($hTimer_PBRemoteControlInterval) >= $PBRemoteControlInterval Then
				PushBulletRemoteControl()
				$hTimer_PBRemoteControlInterval = TimerInit()
			EndIf
			If $hTimer_PBDeleteOldPushesInterval = 0 Or TimerDiff($hTimer_PBDeleteOldPushesInterval) >= $PBDeleteOldPushesInterval Then
				PushBulletDeleteOldPushes()
				$hTimer_PBDeleteOldPushesInterval = TimerInit()
			EndIf
			If $RunState And TestCapture() = False And ($hTimer_EmptyWorkingSetAndroid = 0 Or TimerDiff($hTimer_EmptyWorkingSetAndroid) >= $iEmptyWorkingSetAndroid) Then
				If IsArray(getAndroidPos(True)) = 1 Then _WinAPI_EmptyWorkingSet(GetAndroidPid()) ; Reduce Working Set of Android Process
				$hTimer_EmptyWorkingSetAndroid = TimerInit()
			EndIf
			If $hTimer_EmptyWorkingSetBot = 0 Or TimerDiff($hTimer_EmptyWorkingSetBot) >= $iEmptyWorkingSetBot Then
				_WinAPI_EmptyWorkingSet(@AutoItPID) ; Reduce Working Set of Bot
				$hTimer_EmptyWorkingSetBot = TimerInit()
			EndIF
			If $TogglePauseUpdateState Then TogglePauseUpdateState("_Sleep") ; Update Pause GUI states
			If $TPaused And $SleepWhenPaused And $TogglePauseAllowed Then TogglePauseSleep() ; Bot is paused

			If $bMoveDivider Then
				MoveDivider()
				$bMoveDivider = False
			EndIf

			If $NotifyDeleteAllPushesNow = True Then PushMsg("DeleteAllPBMessages") ; only when button is pushed, and only when on a sleep cyle
			If $iMakeScreenshotNow = True Then
				If $iScreenshotType = 0 Then
					MakeScreenshot($dirTemp, "jpg")
				Else
					MakeScreenshot($dirTemp, "png")
				EndIf
			EndIf
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
		If $CheckRunState = True And $RunState = False Then
			ResumeAndroid()
			Return True
		EndIf
		If $iRemaining >= $iDelaySleep Then
			Sleep($iDelaySleep)
		ElseIf $iRemaining >= 10 Then
			Sleep($iRemaining)
		Else
			_SleepMicro(Int($iRemaining * 1000))
		EndIf
		$iRemaining = $iDelay - TimerDiff($iBegin)
		If SetCriticalMessageProcessing() = False Then
			AndroidEmbedCheck()
			AndroidShieldCheck()
		EndIf
	WEnd
	Return False
EndFunc   ;==>_Sleep

Func _SleepMicro($iMicroSec)
    Local $hStruct = DllStructCreate("int64 time;")
    DllStructSetData($hStruct, "time", -1 * ($iMicroSec * 10))
    DllCall($hNtDll, "dword", "ZwDelayExecution", "int", 0, "ptr", DllStructGetPtr($hStruct))
EndFunc   ;==>_SleepMicro