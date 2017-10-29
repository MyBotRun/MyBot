
; #FUNCTION# ====================================================================================================================
; Name ..........: ProfileReport
; Description ...: This function will report Attacks Won, Defenses Won, Troops Donated and Troops Received from Profile info page
; Syntax ........: ProfileReport()
; Parameters ....:
; Return values .: None
; Author ........: Sardo
; Modified ......: KnowJack (07-2015), Sardo (08-2015), CodeSlinger69 (01-2017), Fliegerfaust (09-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once
Func ProfileReport()

	Local $iAttacksWon = 0, $iDefensesWon = 0

	Local $iCount
	ClickP($aAway, 1, 0, "#0221") ;Click Away
	If _Sleep($DELAYPROFILEREPORT1) Then Return

	SetLog("Profile Report", $COLOR_INFO)
	SetLog("Opening Profile page to read Attacks, Defenses, Donations and Recieved Troops", $COLOR_INFO)
	Click(30, 40, 1, 0, "#0222") ; Click Info Profile Button
	If _Sleep($DELAYPROFILEREPORT2) Then Return

	While Not _ColorCheck(_GetPixelColor(200, 345, True), Hex(0x2E2C62, 6), 20) ; wait for Info Profile to open
		$iCount += 1
		If _Sleep($DELAYPROFILEREPORT1) Then Return
		If $iCount >= 25 Then ExitLoop
	WEnd
	If $iCount >= 25 Then SetDebugLog("Profile Page did not open after " & $iCount & " Loops", $COLOR_DEBUG)
	If _Sleep($DELAYPROFILEREPORT1) Then Return
	$iAttacksWon = ""

	If _ColorCheck(_GetPixelColor($aProfileReport[0], $aProfileReport[1], True), Hex($aProfileReport[2], 6), $aProfileReport[3]) Then
		SetDebugLog("Profile seems to be currently unranked", $COLOR_DEBUG)
		$iAttacksWon = 0
		$iDefensesWon = 0
	Else
		$iAttacksWon = getProfile(578, 347)
		If $g_bDebugSetlog Then Setlog("$iAttacksWon: " & $iAttacksWon, $COLOR_DEBUG)
		$iCount = 0
		While $iAttacksWon = "" ; Wait for $attacksWon to be readable in case of slow PC
			If _Sleep($DELAYPROFILEREPORT1) Then Return
			$iAttacksWon = getProfile(578, 347)
			If $g_bDebugSetlog Then Setlog("Read Loop $iAttacksWon: " & $iAttacksWon & ", Count: " & $iCount, $COLOR_DEBUG)
			$iCount += 1
			If $iCount >= 20 Then ExitLoop
		WEnd
		If $g_bDebugSetlog And $iCount >= 20 Then Setlog("Excess wait time for reading $AttacksWon: " & getProfile(578, 347), $COLOR_DEBUG)
		$iDefensesWon = getProfile(790, 347)
	EndIf
	$g_iTroopsDonated = getProfile(158, 347)
	$g_iTroopsReceived = getProfile(360, 347)

	SetLog(" [ATKW]: " & _NumberFormat($iAttacksWon) & " [DEFW]: " & _NumberFormat($iDefensesWon) & " [TDON]: " & _NumberFormat($g_iTroopsDonated) & " [TREC]: " & _NumberFormat($g_iTroopsReceived), $COLOR_SUCCESS)
	Click(830, 80, 1, 0, "#0223") ; Close Profile page
	If _Sleep($DELAYPROFILEREPORT3) Then Return

	$iCount = 0
	While Not _CheckPixel($aIsMain, $g_bCapturePixel) ; wait for profile report window very slow close
		If _Sleep($DELAYPROFILEREPORT3) Then Return
		$iCount += 1
		If $iCount > 50 Then
			SetDebugLog("Main Window did not appear after " & $iCount & " Loops", $COLOR_DEBUG)
			ExitLoop
		EndIf
	WEnd

EndFunc   ;==>ProfileReport
