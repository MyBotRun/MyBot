
; #FUNCTION# ====================================================================================================================
; Name ..........: PrepareSearch
; Description ...: Goes into searching for a match, breaks shield if it has to
; Syntax ........: PrepareSearch()
; Parameters ....:
; Return values .: None
; Author ........: Code Monkey #4
; Modified ......: KnowJack (June/July 2015) add gem spend check & new shield button search to avoid dropping troop on enemy base, and early take a brak detection
; Remarks .......: This file is part of ClashGameBot. Copyright 2015
;                  ClashGameBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func PrepareSearch() ;Click attack button and find match button, will break shield

	SetLog("Going to Attack...", $COLOR_BLUE)

	ClickP($aAttackButton, 1, 0, "#0149") ; Click Attack Button
	If _Sleep($iDelayPrepareSearch1) Then Return

	ClickP($aFindMatchButton, 1, 0, "#0150");Click Find a Match Button
	If _Sleep($iDelayPrepareSearch2) Then Return

	Local $Result = getAttackDisable(346, 182)  ; Grab Ocr for TakeABreak check

	If isGemOpen(True) = True Then ; Check for gem window open)
		Setlog(" Not enough gold to start searching.....", $COLOR_RED)
		Click(585, 252, 1, 0, "#0151") ; Click close gem window "X"
		If _Sleep($iDelayPrepareSearch1) Then Return
		Click(822, 32, 1, 0, "#0152") ; Click close attack window "X"
		If _Sleep($iDelayPrepareSearch1) Then Return
		$OutOfGold = 1 ; Set flag for out of gold to search for attack
	EndIf

	If _Sleep($iDelayPrepareSearch1) Then Return
	If $result = "" Then $Result = getAttackDisable(346, 182)  ; Grab Ocr for TakeABreak 2nd time if not found due slow PC
	If $debugSetlog = 1 Then Setlog("Take-A-Break OCR result = " & $Result, $COLOR_PURPLE)
	If $Result <> "" Then ; we may have Take-A-Break
		If StringInStr($Result, "disable") <> 0 Then ; double check just in case.
			Setlog("Attacking disabled, Take-A-Break detected. Exiting CoC", $COLOR_RED)
			; shut it down...
			$Restart = True ; Set flag to restart bot main code and let Checkmainscreen clean up
			Local $i = 0
			While 1
				PureClick(50, 700, 1, 0, "#0116") ; Hit BS Back button for the confirm exit dialog to appear
				If _Sleep($iDelayPrepareSearch1) Then Return
				Local $offColors[3][3] = [[0x000000, 144, 0], [0xFFFFFF, 54, 17], [0xCBE870, 54, 10]] ; 2nd Black opposite button, 3rd pixel white "O" center top, 4th pixel White "0" bottom center
				Global $ButtonPixel = _MultiPixelSearch(438, 372, 590, 404, 1, 1, Hex(0x000000, 6), $offColors, 20) ; first vertical black pixel of Okay
				If $debugSetlog = 1 Then Setlog("Exit btn chk-#1: " & _GetPixelColor(441, 374, True) & ", #2: " & _GetPixelColor(441 + 144, 374, True) & ", #3: " & _GetPixelColor(441 + 54, 374 + 17, True) & ", #4: " & _GetPixelColor(441 + 54, 374 + 10, True), $COLOR_PURPLE)
				If IsArray($ButtonPixel) Then
					If $debugSetlog = 1 Then
						Setlog("ButtonPixel = " & $ButtonPixel[0] & ", " & $ButtonPixel[1], $COLOR_PURPLE) ;Debug
						Setlog("Pixel color found #1: " & _GetPixelColor($ButtonPixel[0], $ButtonPixel[1], True) & ", #2: " & _GetPixelColor($ButtonPixel[0] + 144, $ButtonPixel[1], True) & ", #3: " & _GetPixelColor($ButtonPixel[0] + 54, $ButtonPixel[1] + 17, True) & ", #4: " & _GetPixelColor($ButtonPixel[0] + 54, $ButtonPixel[1] + 27, True), $COLOR_PURPLE)
					EndIf
					PureClick($ButtonPixel[0] + 75, $ButtonPixel[1] + 25, 2, $iDelayPrepareSearch7,"#0345") ; Click Okay Button
					If _Sleep($iDelayPrepareSearch3) Then Return
					ExitLoop
				EndIf
				If $i > 15 Then
					Setlog("Can not find Okay button to exit CoC, giving up", $COLOR_RED)
					If _Sleep($iDelayPrepareSearch4) Then Return
					Return
				EndIf
				$i += 1
			WEnd
			SetLog("Waiting 20 seconds for server logoff", $COLOR_GREEN)
			If _SleepStatus($iDelayPrepareSearch5) Then Return ; Wait for server to see log off
			$HWnD = WinGetHandle($Title)
			Local $RunApp = StringReplace(_WinAPI_GetProcessFileName(WinGetProcess($Title)), "Frontend", "RunApp")
			Run($RunApp & " Android com.supercell.clashofclans com.supercell.clashofclans.GameApp")
			If $debugSetlog = 1 Then setlog("Waiting for CoC to restart", $COLOR_PURPLE)
			If _SleepStatus($iDelayPrepareSearch6) Then Return ; Wait 15 seconds for CoC restart
		EndIf
	EndIf
	If $debugSetlog = 1 Then Setlog("PrepareSearch exit T&B check $Restart= " & $Restart&", $OutOfGold= "&$OutOfGold, $COLOR_PURPLE)
	If $Restart = True or $OutOfGold = 1 Then ; If we have one or both errors, then return
		$Is_ClientSyncError = False  ; reset fast restart flag to stop start collecting resources after the extended break
		Return
	EndIf

	Local $offColors[3][3] = [[0x000000, 144, 0], [0xFFFFFF, 54, 17], [0xCBE870, 54, 10]] ; 2nd Black opposite button, 3rd pixel white "O" center top, 4th pixel White "0" bottom center
	Global $ButtonPixel = _MultiPixelSearch(438, 372, 590, 404, 1, 1, Hex(0x000000, 6), $offColors, 20) ; first vertical black pixel of Okay
	If $debugSetlog = 1 Then Setlog("Shield btn clr chk-#1: " & _GetPixelColor(441, 374, True) & ", #2: " & _GetPixelColor(441 + 144, 374, True) & ", #3: " & _GetPixelColor(441 + 54, 374 + 17, True) & ", #4: " & _GetPixelColor(441 + 54, 374 + 10, True), $COLOR_PURPLE)
	If IsArray($ButtonPixel) Then
		If $debugSetlog = 1 Then
			Setlog("ButtonPixel = " & $ButtonPixel[0] & ", " & $ButtonPixel[1], $COLOR_PURPLE) ;Debug
			Setlog("Shld Btn Pixel color found #1: " & _GetPixelColor($ButtonPixel[0], $ButtonPixel[1], True) & ", #2: " & _GetPixelColor($ButtonPixel[0] + 144, $ButtonPixel[1], True) & ", #3: " & _GetPixelColor($ButtonPixel[0] + 54, $ButtonPixel[1] + 17, True) & ", #4: " & _GetPixelColor($ButtonPixel[0] + 54, $ButtonPixel[1] + 27, True), $COLOR_PURPLE)
		EndIf
		Click($ButtonPixel[0] + 75, $ButtonPixel[1] + 25, 1, 0, "#0153") ; Click Okay Button
	EndIf

EndFunc   ;==>PrepareSearch


