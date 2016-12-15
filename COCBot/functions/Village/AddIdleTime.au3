
; #FUNCTION# ====================================================================================================================
; Name ..........: AddIdleTime.au3
; Description ...:
; Syntax ........: AddIdleTime()
; Parameters ....:
; Return values .: None
; Author ........: Sardo
; Modified ......: Sardo (2916-09), Boju (2016-11)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func AddIdleTime()
	;Increases the waiting time in the idle phase during training
	Local $timetowait

	; Add idle time if feature it is enable
	; If $iChkBotStop = 1 And $icmbBotCond >= 19 Then Return
	if $ichkAddIdleTime = 1 Then
		if $iAddIdleTimeMin = $iAddIdleTimeMax Then
			$timetowait  = $iAddIdleTimeMin
		Else
			$timetowait = random($iAddIdleTimeMin,$iAddIdleTimeMax,1)  ; return integer random number between $AddIdleTimeMin and $AddIdleTimeMax
		EndIf
		;If $debugsetlog=1 Then
			Setlog("Waiting, Add random delay of " & $timetowait   & " seconds.",$COLOR_INFO)
		;EndIf
		If _SleepStatus($timetowait*1000) Then Return
		_GUICtrlStatusBar_SetText($statLog, "")  ; Clear text from status bar when done waiting.
	EndIf
	Return True
EndFunc   ;==>AddIdleTime()
