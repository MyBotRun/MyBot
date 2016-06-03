
; #FUNCTION# ====================================================================================================================
; Name ..........: ClickOkay
; Description ...: checks for window with "Okay" button, and clicks it
; Syntax ........: ClickOkay($FeatureName)
; Parameters ....: $FeatureName         - [optional] String with name of feature calling. Default is "Okay".
; ...............; $bCheckOneTime       - (optional) Boolean flag - only checks for Okay button once
; Return values .: Returns True if button found, if button not found, then returns False and sets @error = 1
; Author ........: MonkeyHunter (2015-12)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func ClickOkay($FeatureName = "Okay", $bCheckOneTime = False)
	Local $i = 0
	If _Sleep($iSpecialClick1) Then Return False ; Wait for Okay button window
	While 1 ; Wait for window with Okay Button
		Local $offColors[3][3] = [[0x000000, 144, 0], [0xFFFFFF, 54, 17], [0xCBE870, 54, 10]] ; 2nd Black opposite button, 3rd pixel white "O" center top, 4th pixel White "0" bottom center
		Global $ButtonPixel = _MultiPixelSearch(438, 372 + $midOffsetY, 590, 404 + $midOffsetY, 1, 1, Hex(0x000000, 6), $offColors, 20) ; first vertical black pixel of Okay
		If $debugSetlog = 1 Then Setlog($FeatureName & " btn chk-#1: " & _GetPixelColor(441, 374 + $midOffsetY, True) & ", #2: " & _GetPixelColor(441 + 144, 374 + $midOffsetY, True) & ", #3: " & _GetPixelColor(441 + 54, 374 + 17 + $midOffsetY, True) & ", #4: " & _GetPixelColor(441 + 54, 374 + 10 + $midOffsetY, True), $COLOR_PURPLE)
		If IsArray($ButtonPixel) Then
			If $debugSetlog = 1 Then
				Setlog("ButtonPixelLocation = " & $ButtonPixel[0] & ", " & $ButtonPixel[1], $COLOR_PURPLE) ;Debug
				Setlog("Pixel color found #1: " & _GetPixelColor($ButtonPixel[0], $ButtonPixel[1], True) & ", #2: " & _GetPixelColor($ButtonPixel[0] + 144, $ButtonPixel[1], True) & ", #3: " & _GetPixelColor($ButtonPixel[0] + 54, $ButtonPixel[1] + 17, True) & ", #4: " & _GetPixelColor($ButtonPixel[0] + 54, $ButtonPixel[1] + 10, True), $COLOR_PURPLE)
			EndIf
			PureClick($ButtonPixel[0] + 75, $ButtonPixel[1] + 25, 2, 50, "#0117") ; Click Okay Button
			ExitLoop
		EndIf
		If $bCheckOneTime = True Then Return False ; enable external control of loop count or follow on actions, return false if not clicked
		If $i > 5 Then
			Setlog("Can not find button for " & $FeatureName & ", giving up", $COLOR_RED)
			If $debugImageSave = 1 Then DebugImageSave($FeatureName & "_ButtonCheck_")
			SetError(1, @extended, False)
			Return
		EndIf
		$i += 1
		If _Sleep($iSpecialClick2) Then Return False ; improve pause button response
	WEnd
	Return True
EndFunc   ;==>ClickOkay
