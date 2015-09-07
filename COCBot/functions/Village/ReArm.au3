; #FUNCTION# ====================================================================================================================
; Name ..........: ReArm.au3
; Description ...: Rearms and reloads traps that have been triggered.
; Syntax ........: ReArm()
; Parameters ....:
; Return values .:
; Authors .......: Saviart, Hervidero
; Modified ......: Hervidero, ProMac, KnowJack (May/July-2015) added check for loot available to prevent spending gems. changed screen capture to pixel capture.
;                  Sardo 2015-08
; Remarks .......: This file is part of ClashGameBot. Copyright 2015
;                  ClashGameBot is distributed under the terms of the GNU GPL
; Related .......: Click
; Link ..........:
; Example .......: No
; ===============================================================================================================================

Func ReArm()

	If $ichkTrap = 0 Then Return  ; If re-arm is not enable in GUI return and skip this code
	Local $y = 562

	SetLog("Checking if Village needs Rearming..", $COLOR_BLUE)

	If isInsideDiamond($TownHallPos) = False Then
		LocateTownHall(True)  ; get only new TH location during rearm, due BotFirstDetect now must have TH or there is an error.
		SaveConfig()
		If _Sleep($iDelayReArm1) Then Return
	EndIf

	ClickP($aAway,1,0,"#0224") ; Click away
	If _Sleep($iDelayReArm2) Then Return
	Click($TownHallPos[0], $TownHallPos[1] + 5,1,0,"#0225")
	If _Sleep($iDelayReArm3) Then Return

	;If $debugSetlog = 1 Then DebugImageSave("ReArmView")

	;Traps
	Local $offColors[3][3] = [[0x887d79, 24, 34], [0xF3EC55, 69, 7], [0xECEEE9, 77, 0]] ; 2nd pixel brown wrench, 3rd pixel gold, 4th pixel edge of button
	Global $RearmPixel = _MultiPixelSearch2(240, $y, 670, 600, 1, 1, Hex(0xF6F9F2, 6), $offColors, 30) ; first gray/white pixel of button
	If IsArray($RearmPixel) Then
		If $debugSetlog = 1 Then
			Setlog("Traps ButtonPixel = " & $RearmPixel[0] & ", " & $RearmPixel[1], $COLOR_PURPLE) ;Debug
			Setlog("Color #1: " & _GetPixelColor($RearmPixel[0], $RearmPixel[1], True) & ", #2: " & _GetPixelColor($RearmPixel[0] + 24, $RearmPixel[1] + 34, True) & ", #3: " & _GetPixelColor($RearmPixel[0] + 69, $RearmPixel[1]+7, True) & ", #4: " & _GetPixelColor($RearmPixel[0] + 77, $RearmPixel[1], True), $COLOR_PURPLE)
		EndIf
		Click($RearmPixel[0] + 20, $RearmPixel[1] + 20,1,0,"#0326") ; Click RearmButton
		If _Sleep($iDelayReArm4) Then Return
		Click(515, 400,1,0,"#0226")
		If _Sleep($iDelayReArm4) Then Return
		If isGemOpen(True) = True Then
			Setlog("Not enough loot to rearm traps.....", $COLOR_RED)
			Click(585, 252,1,0,"#0227")  ; Click close gem window "X"
			If _Sleep($iDelayReArm5) Then Return
		Else
			SetLog("Rearmed Trap(s)", $COLOR_GREEN)
			If _Sleep($iDelayReArm5) Then Return
		EndIf
	Endif

	;Xbow
	Local $offColors[3][3] = [[0x8F4B9E, 19, 20], [0xFB5CF4, 70, 7], [0xF0F1EC, 77, 0]]; xbow, elixir, edge
	Local $XbowPixel = _MultiPixelSearch2(240, $y, 670, 600, 1, 1, Hex(0xF4F7F0, 6), $offColors, 30) ; button start
	If IsArray($XbowPixel) Then
		Click($XbowPixel[0] + 20, $XbowPixel[1] + 20,1,0,"#0228") ; Click RearmButton
		If $debugSetlog = 1 Then
			Setlog("x-bow ButtonPixel = " & $XbowPixel[0] & ", " & $XbowPixel[1], $COLOR_PURPLE) ;Debug
			Setlog("Color #1: " & _GetPixelColor($XbowPixel[0], $XbowPixel[1], True) & ", #2: " & _GetPixelColor($XbowPixel[0] + 19, $XbowPixel[1] + 20, True) & ", #3: " & _GetPixelColor($XbowPixel[0] + 70, $XbowPixel[1]+7, True) & ", #4: " & _GetPixelColor($XbowPixel[0] + 77, $XbowPixel[1], True), $COLOR_PURPLE)
		EndIf
		If _Sleep($iDelayReArm4) Then Return
		Click(515, 400,1,0,"#0229")
		If _Sleep($iDelayReArm4) Then Return
		If isGemOpen(True) = True Then
			Setlog(" Not enough Elixir to rearm x-bow.....", $COLOR_RED)
			Click(585, 252,1,0,"#0230")  ; Click close gem window "X"
			If _Sleep($iDelayReArm5) Then Return
		Else
			SetLog("Reloaded Xbow(s)", $COLOR_GREEN)
			If _Sleep($iDelayReArm5) Then Return
		EndIf
	EndIf

	;Inferno
	Local $offColors[3][3] = [[0x8D7477, 19, 20], [0x574460, 70, 7], [0xF0F1EC, 77, 0]]; inferno, dark, edge
	Global $InfernoPixel = _MultiPixelSearch2(240, $y, 670, 600, 1, 1, Hex(0xF4F7F0, 6), $offColors, 30)
	If IsArray($InfernoPixel) Then
		If $debugSetlog = 1 Then
			Setlog("Inferno ButtonPixel = " & $RearmPixel[0] & ", " & $RearmPixel[1], $COLOR_PURPLE) ;Debug
			Setlog("Color #1: " & _GetPixelColor($RearmPixel[0], $RearmPixel[1], True) & ", #2: " & _GetPixelColor($RearmPixel[0] + 19, $RearmPixel[1] + 20, True) & ", #3: " & _GetPixelColor($RearmPixel[0] + 70, $RearmPixel[1]+7, True) & ", #4: " & _GetPixelColor($RearmPixel[0] + 77, $RearmPixel[1], True), $COLOR_PURPLE)
		EndIf
		Click($InfernoPixel[0] + 20, $InfernoPixel[1] + 20,1,0,"#0231") ; Click InfernoButton
		If _Sleep($iDelayReArm4) Then Return
		Click(515, 400,1,0,"#0232")
		If _Sleep($iDelayReArm4) Then Return
		If isGemOpen(True) = True Then
			Setlog("Not enough Dark Elixir to rearm Inferno .....", $COLOR_RED)
			Click(585, 252,1,0,"#0233")  ; Click close gem window "X"
			If _Sleep($iDelayReArm5) Then Return
		Else
			SetLog("Reloaded Inferno(s)", $COLOR_GREEN)
			If _Sleep($iDelayReArm5) Then Return
		EndIf
	EndIf

	ClickP($aAway,1,0,"#0234") ; Click away
	If _Sleep($iDelayReArm5) Then Return
	checkMainScreen(False) ; check for screen errors while running function

EndFunc   ;==>ReArm
