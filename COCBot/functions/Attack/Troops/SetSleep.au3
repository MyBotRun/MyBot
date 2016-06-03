; #FUNCTION# ====================================================================================================================
; Name ..........: SetSleep
; Description ...: Randomizes deployment wait time
; Syntax ........: SetSleep($type)
; Parameters ....: $type                - Flag for type return desired.
; Return values .: None
; Author ........:
; Modified ......: KnowJack (June2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func SetSleep($type)
	If IsKeepClicksActive() = True Then Return 0 ; fast bulk deploy
	Local $factor0 = 10
	Local $factor1 = 100
	If $AndroidAdbClick = True Then
	   ; adjust for slow ADB clicks the delay factor
	   $factor0 = 10
	   $factor1 = 100
    EndIf
	Switch $type
		Case 0
			If $iChkRandomspeedatk[$iMatchMode] = 1 Then
				Return Round(Random(1, 10)) * $factor0
			Else
				Return ($iCmbUnitDelay[$iMatchMode] + 1) * $factor0
			EndIf
		Case 1
			If $iChkRandomspeedatk[$iMatchMode] = 1 Then
				Return Round(Random(1, 10)) * $factor1
			Else
				Return ($iCmbWaveDelay[$iMatchMode] + 1) * $factor1
			EndIf
	EndSwitch
EndFunc   ;==>SetSleep

; #FUNCTION# ====================================================================================================================
; Name ..........: _SleepAttack
; Description ...: Version of _Sleep() used in attack code so active keep clicks mode doesn't slow down bulk deploy
; Syntax ........: see _Sleep
; Parameters ....: see _Sleep
; Return values .: see _Sleep
; Author ........: cosote (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _SleepAttack($iDelay, $iSleep = True)
	If $RunState = False Then
		ResumeAndroid()
		Return True
	EndIf
	If IsKeepClicksActive() = True Then Return False
	Return _Sleep($iDelay, $iSleep)
EndFunc   ;==>_SleepAttack
