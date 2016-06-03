; #FUNCTION# ====================================================================================================================
; Name ..........: _SleepStatus
; Description ...:
; Syntax ........: _SleepStatus($iDelay[, $iSleep = True[, $bDirection = True]])
; Parameters ....: $iDelay              - an integer value.
;                  $iSleep              - [optional] an integer value. Default is True.
;                  $bDirection          - [optional] a boolean value. Default is True.
; Return values .: None
; Author ........: KnowJack (June-2015)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _SleepStatus($iDelay, $iSleep = True, $bDirection = True)
	;
	; $bDirection: True equals count down display, False equals count up display
	;
	Local $iCurTime, $iMinCalc, $iSecCalc, $iTime, $iBegin, $sString
	Local $iDelayMinCalc, $iDelaySecCalc, $iDelaySecCalc
	Local Const $Font = "Verdana"
	Local Const $FontSize = 7.5
	$iBegin = TimerInit()
	$iDelayMinCalc = Int($iDelay / (60 * 1000))
	$iDelaySecCalc = $iDelay - ($iDelayMinCalc * 60 * 1000)
	$iDelaySecCalc = Int($iDelaySecCalc / 1000)
	While TimerDiff($iBegin) < $iDelay
		If $RunState = False Then Return True
		$iCurTime = TimerDiff($iBegin)
		$iTime = $iCurTime ; display count up timer
		If $bDirection = True Then $iTime = $iDelay - $iCurTime ; display countdown timer
		$iMinCalc = Int($iTime / (60 * 1000))
		$iSecCalc = $iTime - ($iMinCalc * 60 * 1000)
		$iSecCalc = Int($iSecCalc / 1000)
		$sString = "Waiting Time= " & StringFormat("%02u" & ":" & "%02u", $iDelayMinCalc, $iDelaySecCalc) & ",  Time Left= " & StringFormat("%02u" & ":" & "%02u", $iMinCalc, $iSecCalc)
		_GUICtrlStatusBar_SetText($statLog, " Status: " & $sString)
		;tabMain()
		If $iSleep = True Then Sleep(500)
	WEnd
	Return False
EndFunc   ;==>_SleepStatus
