; #FUNCTION# ====================================================================================================================
; Name ..........: ClanLevel()
; Description ...: Gets Clan Level to assign the correct quantity troops to train after donate - DonateCC.au3
; Author ........: ProMac (2015)
; Modified ......:
; Remarks .......: This file is part of MyBot Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: Assign the Clan Level to $iClanLevel
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: ClanLevel (87,101)
; ===============================================================================================================================

Func ClanLevel()
	Setlog("Finding your Clan Level, wait..", $COLOR_BLUE)
	; Local $aClanTab[2] = [200, 21]

	ClickP($aAway, 2, 20, "#0467") ;Click Away

	If _Sleep($iDelayClanLevel1) Then Return

	;Verify if exist and active Clan Icon (2 swords) in mainscreen
	If Not _ColorCheck(_GetPixelColor(19, 474 + $midOffsetY, True), Hex(0xE2A539, 6), 15) Then
		SetLog("Please join a Clan ...", $COLOR_GREEN)
		If $iPlannedRequestCCHoursEnable = 1 Then
			$canRequestCC = False
			SetLog("Clan Requests Turned Off, be careful with your settings!", $COLOR_RED)
		EndIf
		$iClanLevel = 0
		Return
	EndIf

	If $debugSetlog = 1 Then SetLog("Click $aOpenChat", $COLOR_GREEN)
	If IsMainPage() Then ClickP($aOpenChat, 1, 0, "#0468") ; clicking clan tab

	; WaitforPixel($iLeft, $iTop, $iRight, $iBottom, $firstColor, $iColorVariation, $maxDelay = 10)
	; Wait until find the Blackzone near the "i" icon , max 5 seconds
	If WaitforPixel(299, 22, 300, 23, Hex(0x000000, 6), 5, $iDelayClanLevel1) Then
		If _Sleep($iDelayDonateCC2) Then Return
		If IsMainChatOpenPage() Then Click(222, 22) ; Click on Clan Chat Tab , confirm Clan Chat intead of Global Chat
		If _Sleep($iDelayDonateCC2) Then Return
		If $debugSetlog = 1 Then SetLog("Click $aClanTab", $COLOR_GREEN)
		If IsMainChatOpenPage() Then ClickP($aClanTab, 1, 0, "#0469") ; click Clan Tab
	EndIf

	If $debugSetlog = 1 Then SetLog("Wait until find the Info icon , max 5 seconds", $COLOR_GREEN)

	If WaitforPixel(282, 55, 285, 57, Hex(0x3088c2, 6), 5, 10) Then
		If $debugSetlog = 1 Then SetLog("Click $aClanInfo", $COLOR_GREEN)
		If IsMainChatOpenPage() Then ClickP($aClanInfo, 1, 0, "#0470") ; click Info
	Else
		SetLog("Please join a Clan ...", $COLOR_GREEN)
		If _ColorCheck(_GetPixelColor($aCloseChat[0], $aCloseChat[1], True), Hex($aCloseChat[2], 6), $aCloseChat[3]) Then
			; Clicks chat thing
			If IsMainChatOpenPage() Then Click($aCloseChat[0], $aCloseChat[1], 1, 0, "#0471")
		EndIf
		Return
	EndIf

	If _Sleep($iDelayDonateCC1) Then Return
	$iClanLevel = ""
	If $debugSetlog = 1 Then SetLog("Wait until find the Clan Perk Button, max 5 seconds", $COLOR_GREEN)
	; $iLeft, $iTop, $iRight, $iBottom, $firstColor, $iColorVariation, $maxDelay = 10
	; Wait until find the Clan Perk Button , max 5 seconds
	If WaitforPixel(95, 243 + $midOffsetY, 98, 244 + $midOffsetY, Hex(0x7cd8e8, 6), 5, $iDelayClanLevel1) Then
		$iClanLevel = getOcrClanLevel(87, 101 + $midOffsetY)
		If Not $iClanLevel = "" Then
			SetLog("Found Clan Level: " & $iClanLevel, $COLOR_GREEN)
		Else
			SetLog("Error finding Clan Level...", $COLOR_RED)
			$iClanLevel = 8
		EndIf
	EndIf

	; click red cross to close the Clan Info Window
	If IsClanInfoPage() Then Click(830, 73, 1, 0, "#0473")

	If _Sleep($iDelayDonateCC1) Then Return

	; Wait for totaly closed Clan Info Window , closing the chat , max 3 seconds (100x30)
	$i = 0
	While 1
		If _Sleep(100) Then Return
		If _ColorCheck(_GetPixelColor($aCloseChat[0], $aCloseChat[1], True), Hex($aCloseChat[2], 6), $aCloseChat[3]) Then
			; Clicks chat thing
			If IsMainChatOpenPage() Then Click($aCloseChat[0], $aCloseChat[1], 1, 0, "#0472")
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
