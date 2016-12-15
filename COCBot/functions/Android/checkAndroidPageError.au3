; #FUNCTION# ====================================================================================================================
; Name ..........: checkAndroidPageError
; Description ...: Function to check for Android IsPage error to reboot Android if threshold exceeded
; Syntax ........: checkAndroidPageError()
; Parameters ....: $bRebootAndroid = True reboots Android if too many page errors per Minutes detected
; Return values .: True if Android reboot should be initiated, False otherwise
; Author ........: Cosote (October 2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: If checkAndroidPageError() = True Then Return
; ===============================================================================================================================

Func checkAndroidPageError($bRebootAndroid = True)

	If $AndroidPageError[1] = 0 Then Return False

	Local $bResetTimer = TimerDiff($AndroidPageError[1]) > $iAndroidRebootPageErrorPerMinutes * 60 * 1000

	If $AndroidPageError[0] >= $iAndroidRebootPageErrorCount And $bResetTimer = False Then

		Local $sMin = Round(TimerDiff($AndroidPageError[1]) / (60 * 1000), 1) & " Minutes"

		If $bRebootAndroid = True Then
			SetLog("Reboot " & $Android & " due to " & $AndroidPageError[0] & " page errors in " & $sMin, $COLOR_ERROR)
		Else
			SetLog($Android & " had " & $AndroidPageError[0] & " page errors in " & $sMin, $COLOR_ERROR)
		EndIf
		InitAndroidPageError()

		If $bRebootAndroid = True Then
			Return True
		EndIf

		Return False

	EndIf

	If $bResetTimer = True Then

		If $AndroidPageError[0] > 0 Then
			SetDebugLog("Cleared " & $AndroidPageError[0] & " " & $Android & " page errors")
		EndIf

		InitAndroidPageError()

	EndIf

	Return False

EndFunc   ;==>checkAndroidPageError


Func AndroidPageError($sSource)

	$AndroidPageError[0] += 1
	SetDebugLog("Page error count increased to " & $AndroidPageError[0] & ", source: " & $sSource)
	If $AndroidPageError[1] = 0 Then $AndroidPageError[1] = TimerInit()
	Return $AndroidPageError[0]

EndFunc   ;==>AndroidPageError

