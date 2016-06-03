
; #FUNCTION# ====================================================================================================================
; Name ..........: StarBonus
; Description ...: Checks for Star bonus window, and clicks ok to close window.
; Syntax ........: StarBonus()
; Parameters ....:
; Return values .: MonkeyHunter(2016-1)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func StarBonus()

	If $debugSetlog = 1 Then Setlog("Begin Star Bonus window check", $COLOR_PURPLE)

	; Verify is Star bonus window open?
	If _CheckPixel($aIsMainGrayed, $bCapturePixel) = False Then Return ; Star bonus window opens on main base view, and grays page.

	If $debugSetlog = 1 Then Setlog("StarBonusWindowChk #1: " & _GetPixelColor(640, 185 + $midOffsetY, $bCapturePixel) & ", #2: " & _GetPixelColor(650, 462 + $bottomOffsetY, $bCapturePixel), $COLOR_PURPLE)
	If _Sleep($iDelayStarBonus100) Then Return

	; Verify actual star bonus window open
	If _ColorCheck(_GetPixelColor(640, 185 + $midOffsetY, $bCapturePixel), Hex(0xC00F15, 6), 10) And _  ; Check for Red below X for window close
			_ColorCheck(_GetPixelColor(650, 462 + $bottomOffsetY, $bCapturePixel), Hex(0xE8E8E0, 6), 10) Then ; and White pixel on top trees where it does not belong

		; Find and Click Okay button
		Local $offColors[3][3] = [[0x000000, 143, 0], [0xFFFFFF, 53, 17], [0xFFFFFF, 53, 29]] ; 2nd Black opposite button, 3rd pixel white "O" center top, 4th pixel White "0" bottom center
		Global $ButtonPixel = _MultiPixelSearch(353, 440 + $midOffsetY, 502, 474 + $midOffsetY, 1, 1, Hex(0x000000, 6), $offColors, 20) ; first vertical black pixel of Okay
		If $debugSetlog = 1 Then Setlog("Bonus Okay btn chk-#1: " & _GetPixelColor(355, 441 + $midOffsetY, $bCapturePixel) & ", #2: " & _GetPixelColor(355 + 143, 441 + $midOffsetY, $bCapturePixel) & ", #3: " & _GetPixelColor(355 + 53, 441 + 17 + $midOffsetY, $bCapturePixel) & ", #4: " & _GetPixelColor(355 + 53, 441 + 29 + $midOffsetY, $bCapturePixel), $COLOR_PURPLE)
		If IsArray($ButtonPixel) Then
			If $debugSetlog = 1 Then
				Setlog("ButtonPixel = " & $ButtonPixel[0] & ", " & $ButtonPixel[1], $COLOR_PURPLE) ;Debug
				Setlog("Bonus Okay Pixel color found #1: " & _GetPixelColor($ButtonPixel[0], $ButtonPixel[1], $bCapturePixel) & ", #2: " & _GetPixelColor($ButtonPixel[0] + 143, $ButtonPixel[1], $bCapturePixel) & ", #3: " & _GetPixelColor($ButtonPixel[0] + 53, $ButtonPixel[1] + 17, $bCapturePixel) & ", #4: " & _GetPixelColor($ButtonPixel[0] + 53, $ButtonPixel[1] + 29, $bCapturePixel), $COLOR_PURPLE)
			EndIf
			Click($ButtonPixel[0] + 75, $ButtonPixel[1] + 25, 1, 0, "#0000") ; Click Okay Button
			If _Sleep($iDelayStarBonus500) Then Return
			Return True
		EndIf

	EndIf

	If $debugSetlog = 1 Then Setlog("Star Bonus window not found?", $COLOR_PURPLE)
	Return False

EndFunc   ;==>StarBonus
