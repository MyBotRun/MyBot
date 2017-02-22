; #FUNCTION# ====================================================================================================================
; Name ..........: _Sleep
; Description ...:
; Syntax ........: _Sleep($iDelay[, $iSleep = True])
; Parameters ....: $iDelay              - an integer value.
;                  $iSleep              - [optional] an integer value. Default is True. unused and deprecated
;                  $$CheckRunState      - Exit and returns True if $g_bRunState is False
; Return values .: True when $g_bRunState is False otherwise True (also True if $CheckRunState=False)
; Author ........:
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func _Sleep($iDelay, $iSleep = True, $CheckRunState = True, $SleepWhenPaused = True)
    Static $hTimer_SetTime = 0
	Static $hTimer_PBRemoteControlInterval = 0
    Static $hTimer_PBDeleteOldPushesInterval = 0
    Static $hTimer_EmptyWorkingSetAndroid = 0
	Static $hTimer_EmptyWorkingSetBot = 0

	Local $iBegin = TimerInit()

	debugGdiHandle("_Sleep")

	If SetCriticalMessageProcessing() = False Then

		If $g_bMoveDivider Then
			MoveDivider()
			$g_bMoveDivider = False
		EndIf

		If $iDelay > 0 And TimerDiff($g_hTxtLogTimer) >= $g_iTxtLogTimerTimeout Then
			If $g_bNotifyDeleteAllPushesNow = True Then PushMsg("DeleteAllPBMessages") ; only when button is pushed, and only when on a sleep cyle

			If TimerDiff($hTimer_PBRemoteControlInterval) >= $g_iPBRemoteControlInterval Then
				PushBulletRemoteControl()
				$hTimer_PBRemoteControlInterval = TimerInit()
			EndIf
			If TimerDiff($hTimer_PBDeleteOldPushesInterval) >= $g_iPBDeleteOldPushesInterval Then
				PushBulletDeleteOldPushes()
				$hTimer_PBDeleteOldPushesInterval = TimerInit()
			EndIf
			If $g_bRunState And TestCapture() = False And TimerDiff($hTimer_EmptyWorkingSetAndroid) >= $g_iEmptyWorkingSetAndroid Then
				If IsArray(getAndroidPos(True)) = 1 Then _WinAPI_EmptyWorkingSet(GetAndroidPid()) ; Reduce Working Set of Android Process
				$hTimer_EmptyWorkingSetAndroid = TimerInit()
			EndIf
			If TimerDiff($hTimer_EmptyWorkingSetBot) >= $g_iEmptyWorkingSetBot Then
				ReduceBotMemory()
				$hTimer_EmptyWorkingSetBot = TimerInit()
			EndIF

			CheckPostponedLog()
		EndIf
	EndIf
	;AndroidEmbedCheck()
	;AndroidShieldCheck()
	If $CheckRunState = True And $g_bRunState = False Then
		ResumeAndroid()
		Return True
	EndIf
	Local $iRemaining = $iDelay - TimerDiff($iBegin)
	While $iRemaining > 0
		DllCall($g_hLibNTDLL, "dword", "ZwYieldExecution")
		If $CheckRunState = True And $g_bRunState = False Then
			ResumeAndroid()
			Return True
		EndIf
		If SetCriticalMessageProcessing() = False Then
			If $g_bBotPaused And $SleepWhenPaused And $g_bTogglePauseAllowed Then TogglePauseSleep() ; Bot is paused
			If $g_bTogglePauseUpdateState Then TogglePauseUpdateState("_Sleep") ; Update Pause GUI states
			If $g_bMakeScreenshotNow = True Then
				If $iScreenshotType = 0 Then
					MakeScreenshot($g_sProfileTempPath, "jpg")
				Else
					MakeScreenshot($g_sProfileTempPath, "png")
				EndIf
			EndIf
			If TimerDiff($g_hTxtLogTimer) >= $g_iTxtLogTimerTimeout Then
				If $g_bRunState And Not $bSearchMode And Not $g_bBotPaused And ($hTimer_SetTime = 0 Or TimerDiff($hTimer_SetTime) >= 750) Then
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
    DllStructSetData($hStruct_SleepMicro, "time", $iMicroSec * -10)
    DllCall($g_hLibNTDLL, "dword", "ZwDelayExecution", "int", 0, "ptr", $pStruct_SleepMicro)
EndFunc   ;==>_SleepMicro

Func _SleepMilli($iMilliSec)
	_SleepMicro(Int($iMilliSec * 1000))
EndFunc   ;==>_SleepMilli
