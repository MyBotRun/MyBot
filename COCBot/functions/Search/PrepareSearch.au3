
; #FUNCTION# ====================================================================================================================
; Name ..........: PrepareSearch
; Description ...: Goes into searching for a match, breaks shield if it has to
; Syntax ........: PrepareSearch()
; Parameters ....:
; Return values .: None
; Author ........: Code Monkey #4
; Modified ......: KnowJack (Aug 2015), MonkeyHunter(2015-12)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func PrepareSearch() ;Click attack button and find match button, will break shield

	SetLog("Going to Attack...", $COLOR_BLUE)

	ChkAttackCSVConfig()

	If IsMainPage() Then
		ClickP($aAttackButton, 1, 0, "#0149") ; Click Attack Button
	EndIF
	If _Sleep($iDelayPrepareSearch1) Then Return

	Local $j = 0
	While Not ( IsLaunchAttackPage())
		If _Sleep($iDelayPrepareSearch1) Then Return ; wait for Train Window to be ready.
		$j += 1
		If $j > 15 Then ExitLoop
	WEnd
	If $j > 15 Then
		SetLog("Launch attack Page Fail", $COLOR_RED)
		checkMainScreen()
		Return
	Else
		ClickP($aFindMatchButton, 1, 0, "#0150");Click Find a Match Button
	EndIf


	If _Sleep($iDelayPrepareSearch2) Then Return

	Local $Result = getAttackDisable(346, 182) ; Grab Ocr for TakeABreak check

	If isGemOpen(True) = True Then ; Check for gem window open)
		Setlog(" Not enough gold to start searching.....", $COLOR_RED)
		Click(585, 252, 1, 0, "#0151") ; Click close gem window "X"
		If _Sleep($iDelayPrepareSearch1) Then Return
		Click(822, 32, 1, 0, "#0152") ; Click close attack window "X"
		If _Sleep($iDelayPrepareSearch1) Then Return
		$OutOfGold = 1 ; Set flag for out of gold to search for attack
	EndIf

	checkAttackDisable($iTaBChkAttack, $Result) ;See If TakeABreak msg on screen

	If $debugSetlog = 1 Then Setlog("PrepareSearch exit check $Restart= " & $Restart & ", $OutOfGold= " & $OutOfGold, $COLOR_PURPLE)

	If $Restart = True Or $OutOfGold = 1 Then ; If we have one or both errors, then return
		$Is_ClientSyncError = False ; reset fast restart flag to stop OOS mode, and rearm, collecting resources etc.
		Return
	EndIf
	If IsAttackWhileShieldPage(False) Then ; check for shield window and then button to lose time due attack and click okay
		Local $offColors[3][3] = [[0x000000, 144, 1], [0xFFFFFF, 54, 17], [0xFFFFFF, 54, 28]] ; 2nd Black opposite button, 3rd pixel white "O" center top, 4th pixel White "0" bottom center
		Global $ButtonPixel = _MultiPixelSearch(359, 404 + $midOffsetY, 510, 445 + $midOffsetY, 1, 1, Hex(0x000000, 6), $offColors, 20) ; first vertical black pixel of Okay
		If $debugSetlog = 1 Then Setlog("Shield btn clr chk-#1: " & _GetPixelColor(441, 344 + $midOffsetY, True) & ", #2: " & _GetPixelColor(441 + 144, 344 + $midOffsetY, True) & ", #3: " & _GetPixelColor(441 + 54, 344 + 17 + $midOffsetY, True) & ", #4: " & _GetPixelColor(441 + 54, 344 + 10 + $midOffsetY, True), $COLOR_PURPLE)
		If IsArray($ButtonPixel) Then
			If $debugSetlog = 1 Then
				Setlog("ButtonPixel = " & $ButtonPixel[0] & ", " & $ButtonPixel[1], $COLOR_PURPLE) ;Debug
				Setlog("Shld Btn Pixel color found #1: " & _GetPixelColor($ButtonPixel[0], $ButtonPixel[1], True) & ", #2: " & _GetPixelColor($ButtonPixel[0] + 144, $ButtonPixel[1], True) & ", #3: " & _GetPixelColor($ButtonPixel[0] + 54, $ButtonPixel[1] + 17, True) & ", #4: " & _GetPixelColor($ButtonPixel[0] + 54, $ButtonPixel[1] + 27, True), $COLOR_PURPLE)
			EndIf
			Click($ButtonPixel[0] + 75, $ButtonPixel[1] + 25, 1, 0, "#0153") ; Click Okay Button
		EndIf
	EndIf

EndFunc   ;==>PrepareSearch


