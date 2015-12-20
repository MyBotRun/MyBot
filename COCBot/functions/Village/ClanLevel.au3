; #FUNCTION# ====================================================================================================================
; Name ..........: ClanLevel()
; Description ...: Gets Clan Level to assign the correct quantity troops to train after donate - DonateCC.au3
; Author ........: ProMac (2015)
; Modified ......:
; Remarks .......: This file is part of MyBot Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: Assign the Clan Level to $iClanLevel
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: ClanLevel (87,101)
; ===============================================================================================================================

Func ClanLevel()

	Local $aClanTab[2] = [200, 21]

	ClickP($aAway, 2, 20, "#0467") ;Click Away

	If _Sleep($iDelayDonateCC1) Then Return

	If $debugSetlog = 1 Then SetLog("Click $aOpenChat", $COLOR_GREEN)
	ClickP($aOpenChat, 1, 0, "#0468") ; clicking clan tab

	; WaitforPixel($iLeft, $iTop, $iRight, $iBottom, $firstColor, $iColorVariation, $maxDelay = 10)
	; Wait until find the Info "i" icon , max 5 seconds

	If WaitforPixel(308, 47, 309, 48, Hex(0x706c50, 6), 5, 10) Then
		If $debugSetlog = 1 Then SetLog("Click $aClanTab", $COLOR_GREEN)
		ClickP($aClanTab, 1, 0, "#0469") ; click Clan Tab
	EndIf

	If $debugSetlog = 1 Then SetLog("Wait until find the Info icon , max 5 seconds", $COLOR_GREEN)

	If WaitforPixel($aClanInfo[0], $aClanInfo[1], $aClanInfo[0]+3, $aClanInfo[1]+2, Hex(0x3088c4, 6), 5, 10) Then ;jp
		If $debugSetlog = 1 Then SetLog("Click $aClanInfo", $COLOR_GREEN)
		ClickP($aClanInfo, 1, 0, "#0470") ; click Info
	Else
		If $debugSetlog = 1 Then SetLog("Found " & _GetPixelColor($aClanInfo[0], $aClanInfo[1], True) & " at info icon " & $aClanInfo[0] & "," & $aClanInfo[1], $COLOR_GREEN)
		SetLog("Please join a Clan ...", $COLOR_GREEN)
		If _ColorCheck(_GetPixelColor($aCloseChat[0], $aCloseChat[1]), Hex($aCloseChat[2], 6), $aCloseChat[3]) Then
			; Clicks chat thing
			ClickP($aCloseChat, 1, 0, "#0470")
		EndIf
		Return
	EndIf

	If _Sleep($iDelayDonateCC1) Then Return
	$iClanLevel = ""
	If $debugSetlog = 1 Then SetLog("Wait until find the Clan Perk Button, max 5 seconds", $COLOR_GREEN)
	; $iLeft, $iTop, $iRight, $iBottom, $firstColor, $iColorVariation, $maxDelay = 10
	; Wait until find the Clan Perk Button , max 5 seconds
	If WaitforPixel(95, 243+30, 98, 244+30, Hex(0x7cd8e8, 6), 5, 10) Then ;jp
		$iClanLevel = getOcrClanLevel(87, 101+30) ;jp
		If Not $iClanLevel = "" Then
			SetLog("Found Clan Level: " & $iClanLevel, $COLOR_GREEN)
		Else
			SetLog("Error finding Clan Level...", $COLOR_RED)
			$iClanLevel = 8
		EndIf
	EndIf

	; click red cross to close the Clan Info Window
	Click(830, 73+30) ;jp

	If _Sleep($iDelayDonateCC1) Then Return

	; Wait for totaly closed Clan Info Window , closing the chat , max 3 seconds (100x30)
	$i = 0
	While 1
		If _Sleep(100) Then Return
		If _ColorCheck(_GetPixelColor($aCloseChat[0], $aCloseChat[1], True), Hex($aCloseChat[2], 6), $aCloseChat[3]) Then
			; Clicks chat thing
			ClickP($aCloseChat, 1, 0, "#0470")
			ExitLoop
		Else
			If _Sleep(100) Then Return
			$i += 1
			If $i > 30 Then
				SetLog("Error finding Clan tab to close...", $COLOR_RED)
				ExitLoop
			EndIf
		EndIf
	WEnd

	If _Sleep($iDelayDonateCC1) Then Return
EndFunc   ;==>ClanLevel
