; #FUNCTION# ====================================================================================================================
; Name ..........: _Sleep
; Description ...:
; Syntax ........: _Sleep($iDelay[, $iSleep = True])
; Parameters ....: $iDelay              - an integer value.
;                  $iSleep              - [optional] an integer value. Default is True.
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of ClashGameBot. Copyright 2015
;                  ClashGameBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Sleep($iDelay, $iSleep = True)
	If $iDeleteAllPushesNow = True Then PushMsg("DeleteAllPBMessages") ; only when button is pushed, and only when on a sleep cyle
	If $iMakeScreenshotNow = True Then
		If $iScreenshotType = 0 Then
			MakeScreenshot($dirTemp, "jpg")
		Else
			MakeScreenshot($dirTemp, "png")
		EndIf
	EndIf
	Local $iBegin = TimerInit()
	While TimerDiff($iBegin) < $iDelay
		If $RunState = False Then Return True
		tabMain()
		If $iSleep = True Then Sleep(50)
	WEnd
	Return False
EndFunc   ;==>_Sleep

