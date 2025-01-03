; #FUNCTION# ====================================================================================================================
; Name ..........: ProfileReport
; Description ...: This function will report Attacks Won, Defenses Won, Troops Donated and Troops Received from Profile info page
; Syntax ........: ProfileReport()
; Parameters ....:
; Return values .: None
; Author ........: Sardo
; Modified ......: KnowJack (07-2015), Sardo (08-2015), CodeSlinger69 (01-2017), Fliegerfaust (09-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once
Func ProfileReport()

	Local $iAttacksWon = 0, $iDefensesWon = 0

	Local $iCount
	ClearScreen()
	If _Sleep($DELAYPROFILEREPORT1) Then Return

	SetLog("Profile Report", $COLOR_INFO)
	SetLog("Opening Profile page to read Attacks, Defenses, Donations and received Troops", $COLOR_INFO)
	Click(40, 32, 1, 140, "#0222") ; Click Info Profile Button
	If _Sleep($DELAYPROFILEREPORT2) Then Return

	While Not _ColorCheck(_GetPixelColor(252, 100 + $g_iMidOffsetY, True), Hex(0xE8E8E0, 6), 5) ; wait for Info Profile to open
		$iCount += 1
		If _Sleep($DELAYPROFILEREPORT1) Then Return
		If $iCount >= 25 Then ExitLoop
	WEnd
	If $iCount >= 25 Then SetDebugLog("Profile Page did not open after " & $iCount & " Loops", $COLOR_DEBUG)

	Local $sSearchArea = GetDiamondFromRect2(660, 130 + $g_iMidOffsetY, 845, 645 + $g_iMidOffsetY)
	Local $aClaimButtons = findMultiple($g_sImgAchievementsClaimReward, $sSearchArea, $sSearchArea, 0, 1000, 0, "objectname,objectpoints", True)
	If IsArray($aClaimButtons) And UBound($aClaimButtons) > 0 Then
		If $g_bChkCollectAchievements Then
			For $i = 0 To UBound($aClaimButtons) - 1
				Local $aTemp = $aClaimButtons[$i]
				Local $aClaimButtonXY = decodeMultipleCoords($aTemp[1])
				For $t = 0 To UBound($aClaimButtonXY) - 1
					Local $aTemp = $aClaimButtonXY[$t]
					Click($aTemp[0], $aTemp[1])
					SetLog("Achievement reward collected", $COLOR_SUCCESS)
					If _Sleep(1500) Then Return
				Next
			Next
		EndIf
		For $z = 0 To 12
			Local $bX1 = Random(321, 325, 1), $bX2 = Random(326, 330, 1)
			Local $bY1 = Random(198 + $g_iMidOffsetY, 200 + $g_iMidOffsetY, 1), $bY2 = Random(538 + $g_iMidOffsetY, 540 + $g_iMidOffsetY, 1)
			ClickDrag($bX1, $bY1, $bX2, $bY2, 1000)
			If _Sleep(Random(1500, 2500, 1)) Then Return ; 2000ms
			If _ColorCheck(_GetPixelColor($aCheckTopProfile[0], $aCheckTopProfile[1], True), Hex($aCheckTopProfile[2], 6), $aCheckTopProfile[3]) And _
					_ColorCheck(_GetPixelColor($aCheckTopProfile2[0], $aCheckTopProfile2[1], True), Hex($aCheckTopProfile2[2], 6), $aCheckTopProfile2[3]) Then ExitLoop
		Next
	Else
		If Not _ColorCheck(_GetPixelColor($aCheckTopProfile[0], $aCheckTopProfile[1], True), Hex($aCheckTopProfile[2], 6), $aCheckTopProfile[3]) And _
				Not _ColorCheck(_GetPixelColor($aCheckTopProfile2[0], $aCheckTopProfile2[1], True), Hex($aCheckTopProfile2[2], 6), $aCheckTopProfile2[3]) Then
			For $z = 0 To 12
				Local $bX1 = Random(321, 325, 1), $bX2 = Random(326, 330, 1)
				Local $bY1 = Random(198 + $g_iMidOffsetY, 200 + $g_iMidOffsetY, 1), $bY2 = Random(538 + $g_iMidOffsetY, 540 + $g_iMidOffsetY, 1)
				ClickDrag($bX1, $bY1, $bX2, $bY2, 1000)
				If _Sleep(Random(1500, 2500, 1)) Then Return ; 2000ms
				If _ColorCheck(_GetPixelColor($aCheckTopProfile[0], $aCheckTopProfile[1], True), Hex($aCheckTopProfile[2], 6), $aCheckTopProfile[3]) And _
						_ColorCheck(_GetPixelColor($aCheckTopProfile2[0], $aCheckTopProfile2[1], True), Hex($aCheckTopProfile2[2], 6), $aCheckTopProfile2[3]) Then ExitLoop
			Next
		EndIf
	EndIf

	If _Sleep($DELAYPROFILEREPORT1) Then Return

	If _ColorCheck(_GetPixelColor($aProfileReport[0], $aProfileReport[1], True), Hex($aProfileReport[2], 6), $aProfileReport[3]) Then
		SetDebugLog("Profile seems to be currently unranked", $COLOR_DEBUG)
		$iAttacksWon = 0
		$iDefensesWon = 0
	Else
		$iAttacksWon = getProfile(547, 449 + $g_iMidOffsetY)
		If $g_bDebugSetLog Then SetDebugLog("$iAttacksWon: " & $iAttacksWon, $COLOR_DEBUG)
		$iCount = 0
		While $iAttacksWon = "" ; Wait for $attacksWon to be readable in case of slow PC
			If _Sleep($DELAYPROFILEREPORT1) Then Return
			$iAttacksWon = getProfile(547, 449 + $g_iMidOffsetY)
			If $g_bDebugSetLog Then SetDebugLog("Read Loop $iAttacksWon: " & $iAttacksWon & ", Count: " & $iCount, $COLOR_DEBUG)
			$iCount += 1
			If $iCount >= 20 Then ExitLoop
		WEnd
		If $g_bDebugSetLog And $iCount >= 20 Then SetLog("Excess wait time for reading $AttacksWon: " & getProfile(547, 449 + $g_iMidOffsetY), $COLOR_DEBUG)
		$iDefensesWon = getProfile(761, 449 + $g_iMidOffsetY)
	EndIf
	$g_iTroopsDonated = getProfile(179, 449 + $g_iMidOffsetY)
	$g_iTroopsReceived = getProfile(363, 449 + $g_iMidOffsetY)

	SetLog(" [ATKW]: " & _NumberFormat($iAttacksWon) & " [DEFW]: " & _NumberFormat($iDefensesWon) & " [TDON]: " & _NumberFormat($g_iTroopsDonated) & " [TREC]: " & _NumberFormat($g_iTroopsReceived), $COLOR_SUCCESS)
	CloseWindow() ; Close Profile page
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
