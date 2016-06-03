
; #FUNCTION# ====================================================================================================================
; Name ..........: ClickRemove
; Description ...: checks if shield information window is open, finds remove button and clicks if found
; Syntax ........: ClickRemove([$FeatureName = "Remove"])
; Parameters ....: $FeatureName         - [optional] an unknown value. Default is "Remove".
; Return values .: Returns True if button found, if button not found, then returns False and sets @error = 1
; Author ........: MonkeyHunter (2015-12)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func ClickRemove($FeatureName = "Remove")
	If _CheckPixel($aIsShieldInfo, $bCapturePixel) Then ; check for open shield info window
		Local $i = 0
		While 1 ; wait window with remove button
			Local $offColors[3][3] = [[0x111111, 109, 0], [0xFFFFFF, 65, 10], [0xC00000, 55, 20]] ; 2nd Black opposite button, 3rd pixel white "O" center top, 4th pixel Red in bottom center
			Global $ButtonPixel = _MultiPixelSearch(472, 251, 588, 278, 1, 1, Hex(0x090908, 6), $offColors, 20) ; first vertical black pixel of Remove, used 860x780, need to check 860x720?
			If $debugSetlog = 1 Then Setlog($FeatureName & " btn chk-#1: " & _GetPixelColor(475, 255, True) & ", #2: " & _GetPixelColor(475 + 109, 255, True) & ", #3: " & _GetPixelColor(475 + 65, 255 + 10, True) & ", #4: " & _GetPixelColor(475 + 55, 255 + 20, True), $COLOR_PURPLE)
			If IsArray($ButtonPixel) Then
				If $debugSetlog = 1 Then
					Setlog("ButtonPixelLocation = " & $ButtonPixel[0] & ", " & $ButtonPixel[1], $COLOR_PURPLE) ;Debug
					Setlog("Pixel color found #1: " & _GetPixelColor($ButtonPixel[0], $ButtonPixel[1], True) & ", #2: " & _GetPixelColor($ButtonPixel[0] + 109, $ButtonPixel[1], True) & ", #3: " & _GetPixelColor($ButtonPixel[0] + 65, $ButtonPixel[1] + 10, True) & ", #4: " & _GetPixelColor($ButtonPixel[0] + 55, $ButtonPixel[1] + 20, True), $COLOR_PURPLE)
				EndIf
				PureClick($ButtonPixel[0] + 55, $ButtonPixel[1] + 10, 1, 0) ; Click Okay Button
				ExitLoop
			EndIf
			If $i > 15 Then
				Setlog("Can not find button for " & $FeatureName & ", giving up", $COLOR_RED)
				If $debugImageSave = 1 Then DebugImageSave($FeatureName & "_ButtonCheck_")
				SetError(1, @extended, False)
				Return
			EndIf
			$i += 1
			If _Sleep($iSpecialClick1) Then Return False ; improve pause button response
		WEnd
		Return True
	Else
		If $debugSetlog = 1 Then Setlog($FeatureName & " remove button found", $COLOR_BLUE)
		Return False
	EndIf
EndFunc   ;==>ClickRemove
