
; #FUNCTION# ====================================================================================================================
; Name ..........: checkAttackDisable
; Description ...:
; Syntax ........: checkAttackDisable($iSource, [$Result = getAttackDisable(X,Y])
; Parameters ....: $Result              - [optional] previous saved string from OCR read. Default is getAttackDisable(346, 182) or getAttackDisable(180,167)
;					    $iSource				 - integer, 1 = called during search process (preparesearch/villagesearch)
;																	2 = called during time when not trying to attack (all other idle times have different message)
; Return values .: None
; Author ........: KnowJack (Aug 2015)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func checkAttackDisable($iSource, $Result = "")

	Switch $iSource
		Case $iTaBChkAttack  ; look at location 346, 182 for "disable", or "for" if checked early enough
			If $Result = "" Then $Result = getAttackDisable(346, 182)
			If _Sleep(1000) Then Return
			If $Result = "" Or (StringLen($Result) < 3) Then $Result = getAttackDisable(346, 182) ; Grab Ocr for TakeABreak 2nd time if not found due slow PC
			If $debugSetlog = 1 Then Setlog("Attack Take-A-Break OCR result = " & $Result, $COLOR_PURPLE)
			If $Result <> "" Then ; fast test to see if have Take-A-Break
				If StringInStr($Result, "disable") <> 0 Or StringInStr($Result, "for") <> 0 Then ; verify we have right text strings
					Setlog("Attacking disabled, Take-A-Break detected. Exiting CoC", $COLOR_MAROON)
					If _CheckPixel($aSurrenderButton, $bCapturePixel) Then ; village search requires end battle 1s, so check for surrender/endbattle button
						ReturnHome(False, False) ;If End battle is available
					EndIf
				Else
					If $debugSetlog = 1 Then Setlog("wrong text string", $COLOR_PURPLE)
					Return ; exit function, wrong string found
				EndIf
			Else
				Return ; exit function, take a break text not found
			EndIf
		Case $iTaBChkIdle ; look at location 180, 167 for the have "been" online too long message
			If $Result = "" Then getAttackDisable(180, 167)
			If _Sleep(500) Then Return ; short wait to not delay to much
			If $Result = "" Or (StringLen($Result) < 3) Then $Result = getAttackDisable(180, 167) ; Grab Ocr for "Have Been" 2nd time if not found due slow PC
			If $debugSetlog = 1 Then Setlog("Online2Long OCR result = " & $Result, $COLOR_PURPLE)
			If $Result <> "" Then ; fast test to see if have Take-A-Break
				If StringInStr($Result, "been") <> 0 Then ; verify we have right text string
					Setlog("Online too long, Take-A-Break detected. Exiting CoC", $COLOR_RED)
				Else
					If $debugSetlog = 1 Then Setlog("wrong text string", $COLOR_PURPLE)
					Return ; exit function, wrong string found
				EndIf
			Else
				Return ; exit function, take a break text not found
			EndIf
		Case Else
			Setlog("Misformed $sSource parameter, silly programmer made a mistake!", $COLOR_PURPLE)
			Return False
	EndSwitch

	$Restart = True ; Set flag to restart the process at the bot main code when it returns

	; Find and wait for the confirmation of exit "okay" button
	Local $i = 0 ; Reset Loop counter
	While 1
		ControlFocus($Title, "", "") ; grab window focus
		PureClick(50, 700, 1, 0, "#0116") ; Hit BS Back button for the confirm exit dialog to appear
		If _Sleep(1000) Then Return False
		Local $offColors[3][3] = [[0x000000, 144, 0], [0xFFFFFF, 54, 17], [0xCBE870, 54, 10]] ; 2nd Black opposite button, 3rd pixel white "O" center top, 4th pixel White "0" bottom center
		Global $ButtonPixel = _MultiPixelSearch(438, 372, 590, 404, 1, 1, Hex(0x000000, 6), $offColors, 20) ; first vertical black pixel of Okay
		If $debugSetlog = 1 Then Setlog("Exit btn chk-#1: " & _GetPixelColor(441, 374, True) & ", #2: " & _GetPixelColor(441 + 144, 374, True) & ", #3: " & _GetPixelColor(441 + 54, 374 + 17, True) & ", #4: " & _GetPixelColor(441 + 54, 374 + 10, True), $COLOR_PURPLE)
		If IsArray($ButtonPixel) Then
			If $debugSetlog = 1 Then
				Setlog("ButtonPixel = " & $ButtonPixel[0] & ", " & $ButtonPixel[1], $COLOR_PURPLE) ;Debug
				Setlog("Pixel color found #1: " & _GetPixelColor($ButtonPixel[0], $ButtonPixel[1], True) & ", #2: " & _GetPixelColor($ButtonPixel[0] + 144, $ButtonPixel[1], True) & ", #3: " & _GetPixelColor($ButtonPixel[0] + 54, $ButtonPixel[1] + 17, True) & ", #4: " & _GetPixelColor($ButtonPixel[0] + 54, $ButtonPixel[1] + 27, True), $COLOR_PURPLE)
			EndIf
			PureClick($ButtonPixel[0] + 75, $ButtonPixel[1] + 25, 2, 50) ; Click Okay Button
			ExitLoop
		EndIf
		If $i > 15 Then
			Setlog("Can not find Okay button to exit CoC, giving up", $COLOR_RED)
			If $DebugSetlog = 1 Then DebugImageSave("CheckAttackDisableFailedButtonCheck_")
			SetError(1, @extended, False)
			Return
		EndIf
		$i += 1
	WEnd
	If _Sleep(1000) Then Return ; short wait for CoC to exit
	PushMsg("TakeBreak")

	; CoC is closed >>
	WaitnOpenCoC(20000, True) ; close CoC for 20 seconds to ensure server logoff, True=call checkmainscreen to clean up if needed

EndFunc   ;==>checkAttackDisable

