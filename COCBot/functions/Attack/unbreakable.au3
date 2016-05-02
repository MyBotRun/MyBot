; #FUNCTION# ====================================================================================================================
; Name ..........: Unbreakable.au3
; Description ...: This file Includes function to perform defense farming.
; Syntax ........:
; Parameters ....: None
; Return values .: False if regular farming is needed to refill storage
; Author ........: KnowJack (Jul/Aug 2015) updated for COC changes, added early Take-A-Break Detection
; Modified ......: Sardo (2015-08), MonkeyHunter (2015-12)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func Unbreakable()
	;
	; Special mode to complete unbreakable achievement
	; Need to set max/min trophy on Misc tab to range where base can win defenses
	; Enable mode with checkbox, and set desired time to be offline getting defense wins before base is reset.
	; Set absolute minimum loot required to still farm for more loot in Farm Minimum setting, and Save Minimum setting loot that will atttact enemy attackers
	;
	Local $x, $y, $i, $iTime, $iCount

	Switch $iUnbreakableMode
		Case 2
			If (Number($iGoldCurrent) > Number($iUnBrkMaxGold)) And (Number($iElixirCurrent) > Number($iUnBrkMaxElixir)) And (Number($iDarkCurrent) > Number($iUnBrkMaxDark)) Then
				SetLog(" ====== Unbreakable Mode restarted! ====== ", $COLOR_GREEN)
				$iUnbreakableMode = 1
			Else
				SetLog(" = Unbreakable Mode Paused, Farming to Refill Storages =", $COLOR_BLUE)
				Return False
			EndIf
		Case 1
			SetLog(" ====== Unbreakable Mode enabled! ====== ", $COLOR_GREEN)
		Case Else
			SetLog(">>> Programmer Humor, You shouldn't ever see this message, RUN! <<<", $COLOR_PURPLE)
	EndSwitch

	Select
		Case $iChkTrophyAtkDead = 1 ; If attack dead bases during trophy drop is enabled then make sure we have at least 70% full army
			If ($CurCamp <= ($TotalCamp * 70 / 100)) Then
				SetLog("Oops, wait for 70% troops due attack dead base checked", $COLOR_RED)
				Return True ; no troops then cycle again
			EndIf
		Case $iChkTrophyAtkDead = 0 ; no deadbase attacks, then only a few troops needed to enable drop trophy to work
			If ($CurCamp <= ($TotalCamp * 20 / 100)) Then
				SetLog("Oops, wait for 20% troops for use in trophy drop", $COLOR_RED)
				Return True ; no troops then cycle again
			EndIf
		Case Else
			SetLog("You should not see this, silly programmer made a mistake, RUN!", $COLOR_MAROON)
	EndSelect

	Local $sMissingLoot = ""
	If ((Number($iGoldCurrent) - Number($iUnBrkMinGold)) < 0) Then
		$sMissingLoot &= "Gold, "
	EndIf
	If ((Number($iElixirCurrent) - Number($iUnBrkMinElixir)) < 0) Then
		$sMissingLoot &= "Elixir, "
	EndIf
	If ((Number($iDarkCurrent) - Number($iUnBrkMinDark)) < 0) Then
		$sMissingLoot &= "Dark Elixir"
	EndIf
	If $sMissingLoot <> "" Then
		SetLog("Oops, Out of " & $sMissingLoot & " - back to farming", $COLOR_RED)
		$iUnbreakableMode = 2 ; go back to farming mode.
		Return False
	EndIf

	DropTrophy()
	If _Sleep($iDelayUnbreakable2) Then Return True ; wait for home screen
	ClickP($aAway, 1, $iDelayUnbreakable7, "#0112") ;clear screen
	If _Sleep($iDelayUnbreakable1) Then Return True ; wait for home screen
	If $Restart = True Then Return True ; Check Restart Flag to see if drop trophy used all the troops and need to train more.
	$iCount = 0
	Local $iTrophyCurrent = getTrophyMainScreen($aTrophies[0], $aTrophies[1]) ; Get trophy
	If $debugSetlog = 1 Then Setlog("Trophy Count Read = " & $iTrophyCurrent, $COLOR_PURPLE)
	While Number($iTrophyCurrent) > Number($itxtMaxTrophy) ; verify that trophy dropped and didn't fail due misc errors searching
		If $debugSetlog = 1 Then Setlog("Drop Trophy Loop #" & $iCount + 1, $COLOR_PURPLE)
		DropTrophy()
		If _Sleep($iDelayUnbreakable2) Then Return ; wait for home screen
		ClickP($aAway, 1, 0, "#0395") ;clear screen
		If _Sleep($iDelayUnbreakable1) Then Return ; wait for home screen
		$iTrophyCurrent = getTrophyMainScreen($aTrophies[0], $aTrophies[1])
		If ($iCount > 2) And (Number($iTrophyCurrent) > Number($itxtMaxTrophy)) Then ; If unable to drop trophy after a couple of tries, restart at main loop.
			Setlog("Unable to drop trophy, trying again", $COLOR_RED)
			If _Sleep(500) Then Return
			Return True
		EndIf
		$iCount += 1
	WEnd
	If $Restart = True Then Return True ; Check Restart Flag to see if drop trophy used all the troops and need to train more.

	BreakPersonalShield()  ; break personal Shield and Personal Guard
	If @error Then
		If @extended <> "" Then Setlog("PersonalShield button problem: " & @extended, $COLOR_RED)
		Return True ; return to runbot and try again
	EndIf

	ClickP($aAway, 2, $iDelayUnbreakable8, "#0115") ;clear screen selections
	If _Sleep($iDelayUnbreakable1) Then Return True

	If CheckObstacles() = True Then Setlog("Window clean required, but no problem for MyBot!", $COLOR_BLUE)
	_WinAPI_EmptyWorkingSet(WinGetProcess($HWnD)) ; Reduce Android memory usage

	SetLog("Closing Clash Of Clans", $COLOR_BLUE)

	$i = 0
	While 1
		BS1BackButton()
		;PureClickP($aBSBackButton, 1, 0, "#0116") ; Hit BS Back button for the confirm exit dialog to appear
		If _Sleep($iDelayUnbreakable1) Then Return True
		; New button search as old pixel check matched grass color sometimes
		Local $offColors[3][3] = [[0x000000, 144, 0], [0xFFFFFF, 54, 17], [0xCBE870, 54, 10]] ; 2nd Black opposite button, 3rd pixel white "O" center top, 4th pixel White "0" bottom center
		Global $ButtonPixel = _MultiPixelSearch(438, 372 + $midOffsetY, 590, 404 + $midOffsetY, 1, 1, Hex(0x000000, 6), $offColors, 20) ; first vertical black pixel of Okay
		If $debugSetlog = 1 Then Setlog("Exit btn chk-#1: " & _GetPixelColor(441, 374, True) & ", #2: " & _GetPixelColor(441 + 144, 374, True) & ", #3: " & _GetPixelColor(441 + 54, 374 + 17, True) & ", #4: " & _GetPixelColor(441 + 54, 374 + 10, True), $COLOR_PURPLE)
		If IsArray($ButtonPixel) Then
			If $debugSetlog = 1 Then
				Setlog("ButtonPixel = " & $ButtonPixel[0] & ", " & $ButtonPixel[1], $COLOR_PURPLE) ;Debug
				Setlog("Pixel color found #1: " & _GetPixelColor($ButtonPixel[0], $ButtonPixel[1], True) & ", #2: " & _GetPixelColor($ButtonPixel[0] + 144, $ButtonPixel[1], True) & ", #3: " & _GetPixelColor($ButtonPixel[0] + 54, $ButtonPixel[1] + 17, True) & ", #4: " & _GetPixelColor($ButtonPixel[0] + 54, $ButtonPixel[1] + 27, True), $COLOR_PURPLE)
			EndIf
			PureClick($ButtonPixel[0] + 75, $ButtonPixel[1] + 25, 2, 50, "#0117") ; Click Okay Button
			ExitLoop
		EndIf
		If $i > 15 Then ExitLoop
		$i += 1
	WEnd

	$iTime = Number($iUnbreakableWait)
	If $iTime < 1 Then $iTime = 1 ;error check user time input
	Local Const $iGracePeriodTime = 5  ; 5 minutes for server to acknowledge log off.
	$iTime = ($iTime + $iGracePeriodTime) * 60 * 1000  ; add server grace time and convert to milliseconds

	WaitnOpenCoC($iTime, False) ;Tell ClosenOpenCoC False to not cleanup windows

	$iCount = 0
	While 1 ; Under attack when return from sleep?  wait some more ...
		If $debugSetlog = 1 Then Setlog("Under Attack Pixels = " & _GetPixelColor(841, 342 + $midOffsetY, True) & "/" & _GetPixelColor(842, 348 + $midOffsetY, True), $COLOR_PURPLE)
		If _ColorCheck(_GetPixelColor(841, 342 + $midOffsetY, True), Hex(0x711C0A, 6), 20) And _ColorCheck(_GetPixelColor(842, 348 + $midOffsetY, True), Hex(0x721C0E, 6), 20) Then
			Setlog("Base is under attack, waiting 30 seocnds for end", $COLOR_BLUE)
		Else
			ExitLoop
		EndIf
		If _SleepStatus($iDelayUnbreakable6) Then Return True ; sleep 30 seconds
		If $iCount > 7 Then ExitLoop ; wait 3 minutes for attack, and 30 seconds prep time; up to 3:30 total
		$iCount += 1
	WEnd
	If _Sleep($iDelayUnbreakable4) Then Return True

	Local $Message = _PixelSearch(20, 624, 105, 627, Hex(0xE1E3CB, 6), 15) ;Check if Return Home button available and close the screen
	If IsArray($Message) Then
		If $debugSetlog = 1 Then Setlog("Return Home Pixel = " & _GetPixelColor($Message[0], $Message[1], True) & ", Pos: " & $Message[0] & "/" & $Message[1], $COLOR_PURPLE)
		PureClick(67, 602 + $bottomOffsetY, 1, 0, "#0138")
		If _Sleep($iDelayUnbreakable3) Then Return True
	EndIf

	If _ColorCheck(_GetPixelColor(235, 209 + $midOffsetY, True), Hex(0x9E3826, 6), 20) And _ColorCheck(_GetPixelColor(242, 140 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) Then ;See if village was attacked, then click Okay
		If $debugSetlog = 1 Then Setlog("Village Attacked Pixels = " & _GetPixelColor(235, 209 + $midOffsetY, True) & "/" & _GetPixelColor(242, 140 + $midOffsetY, True), $COLOR_PURPLE)
		PureClick(429, 493 + $midOffsetY, 1, 0, "#0132")
		If _Sleep($iDelayUnbreakable3) Then Return True
	EndIf

	If CheckObstacles() = True Then ; Check for unusual windows open, or slow windows
		If _Sleep($iDelayUnbreakable3) Then Return ; wait for window to close
		If CheckObstacles() = True Then CheckMainScreen(False) ; Check again, if true then let Check main screen fix it and zoomout
		Return
	EndIf

	ZoomOut()
	If _Sleep($iDelayUnbreakable1) Then Return True

	Return True

EndFunc   ;==>Unbreakable
