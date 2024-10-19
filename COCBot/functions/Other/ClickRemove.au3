; #FUNCTION# ====================================================================================================================
; Name ..........: ClickRemove
; Description ...: checks if shield information window is open, finds remove button and clicks if found
; Syntax ........: ClickRemove([$FeatureName = "Remove"])
; Parameters ....: $FeatureName         - [optional] an unknown value. Default is "Remove".
; Return values .: Returns True if button found, if button not found, then returns False and sets @error = 1
; Author ........: MonkeyHunter (2015-12)(2017-06)
; Modified ......: Moebius14 (2024-04)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func ClickRemove($FeatureName = "Remove")
	If _CheckPixel($aIsShieldInfo, $g_bCapturePixel) Then ; check for open shield info window
		Local $i = 0
		While 1 ; wait window with remove button
			Local $offColors[3][3] = [[0x110D0D, 137, 0], [0xFFFFFF, 82, 11], [0xE31216, 55, 24]] ; 2nd Black opposite button, 3rd pixel white "O" center top, 4th pixel Red in bottom center
			Local $ButtonPixel = _MultiPixelSearch(480, 254, 635, 285, 1, 1, Hex(0x110D0D, 6), $offColors, 20) ; first vertical black pixel of Remove, used 860x780, need to check 860x720?
			If $g_bDebugSetlog Then SetDebugLog($FeatureName & " btn chk-#1: " & _GetPixelColor(488, 256, True) & ", #2: " & _GetPixelColor(488 + 137, 256, True) & ", #3: " & _GetPixelColor(488 + 82, 256 + 11, True) & ", #4: " & _GetPixelColor(488 + 55, 256 + 24, True), $COLOR_DEBUG)
			If IsArray($ButtonPixel) Then
				If $g_bDebugSetlog Then
					SetDebugLog("ButtonPixelLocation = " & $ButtonPixel[0] & ", " & $ButtonPixel[1], $COLOR_DEBUG) ;Debug
					SetDebugLog("Pixel color found #1: " & _GetPixelColor($ButtonPixel[0], $ButtonPixel[1], True) & ", #2: " & _GetPixelColor($ButtonPixel[0] + 137, $ButtonPixel[1], True) & ", #3: " & _GetPixelColor($ButtonPixel[0] + 82, $ButtonPixel[1] + 11, True) & ", #4: " & _GetPixelColor($ButtonPixel[0] + 55, $ButtonPixel[1] + 24, True), $COLOR_DEBUG)
				EndIf
				PureClick($ButtonPixel[0] + 68, $ButtonPixel[1] + 12, 1, 120) ; Click Okay Button
				ExitLoop
			EndIf
			If $i > 15 Then
				SetLog("Can not find button for " & $FeatureName & ", giving up", $COLOR_ERROR)
				If $g_bDebugImageSave Then SaveDebugImage($FeatureName & "_ButtonCheck_")
				SetError(1, @extended, False)
				Return
			EndIf
			$i += 1
			If _Sleep($DELAYSPECIALCLICK1) Then Return False ; improve pause button response
		WEnd
		Return True
	Else
		If $g_bDebugSetlog Then SetDebugLog($FeatureName & " remove button found", $COLOR_INFO)
		Return False
	EndIf
EndFunc   ;==>ClickRemove
