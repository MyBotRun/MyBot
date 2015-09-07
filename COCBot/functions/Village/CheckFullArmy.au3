; #FUNCTION# ====================================================================================================================
; Name ..........: CheckFullArmy
; Description ...: Checks for Full army camp status when Training window is open to one of the barracks tabs
; Syntax ........: CheckFullArmy()
; Parameters ....: None
; Return values .: None
; Author ........: Code Monkey #18
; Modified ......: KnowJack (July 2015) Update for July CoC changes
;				   Sardo 2015-08
; Remarks .......: This file is part of ClashGameBot. Copyright 2015
;                  ClashGameBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func CheckFullArmy()

	If _sleep(200) Then Return
	Local $Pixel = _CheckPixel($aArmyCampFull, True)
	If $debugSetlog = 1 Then Setlog("Checking for full army [!]" & $Pixel, $COLOR_PURPLE)
;~ 	If Not $Pixel Then
;~ 		If _sleep(200) Then Return
;~ 		$Pixel = (_ColorCheck(_GetPixelColor(653, 247, True), Hex(0x888888, 6), 20) And Not _ColorCheck(_GetPixelColor(475, 214, True), Hex(0xD1D0C2, 6), 20)) ; check for gray button and not empty barrack
;~ 	EndIf
	If $Pixel Then
		$fullArmy = True
	ElseIf $iCmbTroopComp = 1 And ($CommandStop <> 3 Or $CommandStop <> 0) Then ; If baracks mode, then $FullArmy false, except when idle loop is halt mode
		$fullArmy = False
	EndIf

EndFunc   ;==>CheckFullArmy

; #FUNCTION# ====================================================================================================================
; Name ..........: CheckOverviewFullArmy
; Description ...: Checks if the army is full on the training overview screen
; Syntax ........: CheckOverviewFullArmy([$bWindowOpen = False])
; Parameters ....: $bWindowOpen         - [optional] a boolean flag if we need to open the Amry training window. Default is False.
; Return values .: None
; Author ........: KnowJack (July 2015)
; Modified ......:
; Remarks .......: This file is part of ClashGameBot. Copyright 2015
;                  ClashGameBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================

Func CheckOverviewFullArmy($bWindowOpen = False)
;
	If $bWindowOpen = True Then
		ClickP($aAway,1,0,"#0346") ;Click Away
		If _Sleep($iDelayCheckFullArmy1) Then Return

		Click($aArmyTrainButton[0], $aArmyTrainButton[1],1,0,"#0347") ;Click Army Camp
		If _Sleep($iDelayCheckFullArmy2) Then Return
		Local $j = 0
		While Not _ColorCheck(_GetPixelColor($btnpos[0][0], $btnpos[0][1], True), Hex(0xE8E8E0, 6), 20)
			If $debugSetlog = 1 Then Setlog("OverView TabColor=" & _GetPixelColor($btnpos[0][0], $btnpos[0][1], True), $COLOR_PURPLE)
			If _Sleep($iDelayCheckFullArmy1) Then Return ; wait for Train Window to be ready.
			$j += 1
			If $j > 15 Then ExitLoop
		WEnd
		If $j > 15 Then
			SetLog("Training Overview Window didn't open", $COLOR_RED)
			Return
		EndIf
	EndIf
	If _sleep($iDelayCheckFullArmy2) Then Return
	Local $Pixel = _CheckPixel($aIsCampFull, True) And _ColorCheck(_GetPixelColor(152, 158, True), Hex(0x40770A, 6), 20)
	If Not $Pixel Then
		If _sleep($iDelayCheckFullArmy2) Then Return
		$Pixel = _CheckPixel($aIsCampFull, True) And _ColorCheck(_GetPixelColor(152, 158, True), Hex(0x40770A, 6), 20)
	EndIf
	If $debugSetlog = 1 Then Setlog("Checking Overview for full army [!] " & $Pixel & ", " & _GetPixelColor(152, 158, True), $COLOR_PURPLE)
	If $Pixel Then
		$fullArmy = True
	ElseIf $iCmbTroopComp = 1 And ($CommandStop <> 3 Or $CommandStop <> 0) Then ; If baracks mode, then $FullArmy false, except when idle loop is halt mode
		$fullArmy = False
	EndIf

	If $bWindowOpen = True Then
		ClickP($aAway,1,0,"#0348") ;Click Away
		If _Sleep($iDelayCheckFullArmy3) Then Return
	EndIf

EndFunc   ;==>CheckOverviewFullArmy
