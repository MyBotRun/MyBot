; #FUNCTION# ====================================================================================================================
; Name ..........: _Sleep
; Description ...:
; Syntax ........: _Sleep($iDelay[, $iSleep = True])
; Parameters ....: $iDelay              - an integer value.
;                  $iSleep              - [optional] an integer value. Default is True. unused and deprecated
;                  $CheckRunState      - Exit and returns True if $g_bRunState is False
; Return values .: True when $g_bRunState is False otherwise True (also True if $CheckRunState=False)
; Author ........:
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func _Sleep($iDelay, $iSleep = True, $CheckRunState = True, $SleepWhenPaused = True)
	Static $hTimer_SetTime = 0
	Static $hTimer_PBRemoteControlInterval = 0
	;Static $hTimer_PBDeleteOldPushesInterval = 0
	Static $hTimer_EmptyWorkingSetAndroid = 0
	Static $hTimer_EmptyWorkingSetBot = 0
	Static $b_Sleep_Active = False

	Local $iBegin = __TimerInit()

	If $b_Sleep_Active = True Then
		; ups, prevent bad recursion
		#cs Disabled for now, maybe fix Pause button state and re-activate
			Local $iRemaining = $iDelay - __TimerDiff($iBegin)
			While $iRemaining > 0
			DllCall($g_hLibNTDLL, "dword", "ZwYieldExecution")
			If $CheckRunState = True And $g_bRunState = False Then
			Return True
			EndIf
			$iRemaining = $iDelay - __TimerDiff($iBegin)
			If $iRemaining >= $DELAYSLEEP Then
			_SleepMilli($DELAYSLEEP)
			Else
			_SleepMilli($iRemaining)
			EndIf
			WEnd
			Return False
		#ce
	EndIf

	$b_Sleep_Active = True

	debugGdiHandle("_Sleep")
	CheckBotRequests() ; check if bot window should be moved, minized etc.

	If SetCriticalMessageProcessing() = False Then

		If $g_bMoveDivider Then
			MoveDivider()
			$g_bMoveDivider = False
		EndIf

		If $iDelay > 0 And __TimerDiff($g_hTxtLogTimer) >= $g_iTxtLogTimerTimeout Then

			; Notify stuff
			; If $g_bNotifyDeleteAllPushesNow = True Then PushMsg("DeleteAllPBMessages") ; only when button is pushed, and only when on a sleep cyle

			If __TimerDiff($hTimer_PBRemoteControlInterval) >= $g_iPBRemoteControlInterval Or ($hTimer_PBRemoteControlInterval = 0 And $g_bNotifyRemoteEnable) Then
				NotifyRemoteControl()
				$hTimer_PBRemoteControlInterval = __TimerInit()
			EndIf
;~ 			If __TimerDiff($hTimer_PBDeleteOldPushesInterval) >= $g_iPBDeleteOldPushesInterval  Then
;~ 				PushBulletDeleteOldPushes()
;~ 				$hTimer_PBDeleteOldPushesInterval = __TimerInit()
;~ 			EndIf

			; Android & Bot Stuff
			If (($g_iEmptyWorkingSetAndroid > 0 And __TimerDiff($hTimer_EmptyWorkingSetAndroid) >= $g_iEmptyWorkingSetAndroid * 1000) Or $hTimer_EmptyWorkingSetAndroid = 0) And $g_bRunState And TestCapture() = False Then
				If IsArray(getAndroidPos(True)) = 1 Then _WinAPI_EmptyWorkingSet(GetAndroidPid()) ; Reduce Working Set of Android Process
				$hTimer_EmptyWorkingSetAndroid = __TimerInit()
			EndIf
			If ($g_iEmptyWorkingSetBot > 0 And __TimerDiff($hTimer_EmptyWorkingSetBot) >= $g_iEmptyWorkingSetBot * 1000) Or $hTimer_EmptyWorkingSetBot = 0 Then
				ReduceBotMemory(False)
				$hTimer_EmptyWorkingSetBot = __TimerInit()
			EndIf

			CheckPostponedLog()

			If BotCloseRequestProcessed() Then
				BotClose() ; improve responsive bot close
				$b_Sleep_Active = False
				Return True
			EndIf
		EndIf
	EndIf

	If $CheckRunState And Not $g_bRunState Then
		ResumeAndroid()
		$b_Sleep_Active = False
		Return True
	EndIf
	Local $iRemaining = $iDelay - __TimerDiff($iBegin)
	While $iRemaining > 0
		DllCall($g_hLibNTDLL, "dword", "ZwYieldExecution")
		If $CheckRunState = True And $g_bRunState = False Then
			ResumeAndroid()
			$b_Sleep_Active = False
			Return True
		EndIf
		If SetCriticalMessageProcessing() = False Then
			If $g_bBotPaused And $SleepWhenPaused And $g_bTogglePauseAllowed Then TogglePauseSleep() ; Bot is paused
			If $g_bTogglePauseUpdateState Then TogglePauseUpdateState("_Sleep") ; Update Pause GUI states
			If $g_bMakeScreenshotNow = True Then
				If $g_bScreenshotPNGFormat = False Then
					MakeScreenshot($g_sProfileTempPath, "jpg")
				Else
					MakeScreenshot($g_sProfileTempPath, "png")
				EndIf
			EndIf
			If __TimerDiff($g_hTxtLogTimer) >= $g_iTxtLogTimerTimeout Then
				If $g_bRunState And Not $g_bSearchMode And Not $g_bBotPaused And ($hTimer_SetTime = 0 Or __TimerDiff($hTimer_SetTime) >= 750) Then
					SetTime()
					$hTimer_SetTime = __TimerInit()
				EndIf
				AndroidEmbedCheck()
				AndroidShieldCheck()
				CheckPostponedLog()
			EndIf
		EndIf
		$iRemaining = $iDelay - __TimerDiff($iBegin)
		If $iRemaining >= $DELAYSLEEP Then
			_SleepMilli($DELAYSLEEP)
		Else
			_SleepMilli($iRemaining)
		EndIf
		CheckBotRequests() ; check if bot window should be moved
	WEnd
	$b_Sleep_Active = False
	Return False
EndFunc   ;==>_Sleep

Func _SleepMicro($iMicroSec)
	DllStructSetData($g_hStruct_SleepMicro, "time", $iMicroSec * -10)
	DllCall($g_hLibNTDLL, "dword", "ZwDelayExecution", "int", 0, "ptr", $g_pStruct_SleepMicro)
EndFunc   ;==>_SleepMicro

Func _SleepMilli($iMilliSec)
	_SleepMicro(Int($iMilliSec * 1000))
EndFunc   ;==>_SleepMilli
