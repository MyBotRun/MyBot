; #FUNCTION# ====================================================================================================================
; Name ..........: isGemOpen.au3
; Description ...: Test the screen for Gem Window open
; Syntax ........: isGemOpen($bNeedCaptureRegion), FALSE is default.
; Parameters ....: $bNeedCaptureRegion = True will make a new 2x2 screencapture to identify the pixels to test, False will assume there is a full screen capture to use.
; Return values .: True if Gem window is open and it was closed with click to $aAway
; Author ........: KnowJack (May-2015)
; Modified ......: Sardo 2015-08
; Remarks .......: This file is part of ClashGameBot. Copyright 2015
;                  ClashGameBot is distributed under the terms of the GNU GPL
; Related .......: Click
; Link ..........:
; Example .......: No
; ===============================================================================================================================

Func isGemOpen($bNeedCaptureRegion = False)
	_Sleep($iDelayisGemOpen1)
	If _ColorCheck(_GetPixelColor(573, 256, $bNeedCaptureRegion), Hex(0xE1090E, 6), 20) Then ; Safety Check if the normal use Gem window opens
		If $debugSetlog = 1 Then Setlog("Gemclick Red X detect", $COLOR_PURPLE)
		PureClickP($aAway, 1, 0, "#0140") ; click away to close gem window
		Return True
	ElseIf _ColorCheck(_GetPixelColor(577, 266, $bNeedCaptureRegion), Hex(0xD80408, 6), 20) And _  ; check for the red line under the redX square of gem window
			_ColorCheck(_GetPixelColor(586, 266, $bNeedCaptureRegion), Hex(0xD80408, 6), 20) And _
			_ColorCheck(_GetPixelColor(595, 266, $bNeedCaptureRegion), Hex(0xD80408, 6), 20) Then
		If $debugSetlog = 1 Then Setlog("Gemclick Red Line detect", $COLOR_PURPLE)
		PureClickP($aAway, 1, 0, "#0141")
		Return True
	EndIf
	Return False
EndFunc   ;==>isGemOpen

