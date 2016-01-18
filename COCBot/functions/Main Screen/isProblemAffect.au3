; #FUNCTION# ====================================================================================================================
; Name ..........: isProblemAffect
; Description ...: Test the screen for possible error messages from CoC or Bluestacks
; Syntax ........: isProblemAffect($bNeedCaptureRegion), False is default.
; Parameters ....: $bNeedCaptureRegion = True will make a new 2x2 screencapture to identify the pixels to test, False will assume there is a full screen capture to use.
; Return values .: True if screen is blocked by an error message from CoC or BlueStacks
; Author ........: HungLe (may-2015)
; Modified ......: HungLe (may-2015), Hervidero (may-2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: Click
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func isProblemAffect($bNeedCaptureRegion = False)
	If Not _ColorCheck(_GetPixelColor(253, 395 + $midOffsetY, $bNeedCaptureRegion), Hex(0x282828, 6), 10) Then
		Return False
	ElseIf Not _ColorCheck(_GetPixelColor(373, 395 + $midOffsetY, $bNeedCaptureRegion), Hex(0x282828, 6), 10) Then
		Return False
	ElseIf Not _ColorCheck(_GetPixelColor(473, 395 + $midOffsetY, $bNeedCaptureRegion), Hex(0x282828, 6), 10) Then
		Return False
	ElseIf Not _ColorCheck(_GetPixelColor(283, 395 + $midOffsetY, $bNeedCaptureRegion), Hex(0x282828, 6), 10) Then
		Return False
	ElseIf Not _ColorCheck(_GetPixelColor(320, 395 + $midOffsetY, $bNeedCaptureRegion), Hex(0x282828, 6), 10) Then
		Return False
	ElseIf Not _ColorCheck(_GetPixelColor(594, 395 + $midOffsetY, $bNeedCaptureRegion), Hex(0x282828, 6), 10) Then
		Return False
	ElseIf _ColorCheck(_GetPixelColor(823, 32, $bNeedCaptureRegion), Hex(0xF8FCFF, 6), 10) Then
		Return False
	Else
		Return True
	EndIf
EndFunc   ;==>isProblemAffect
