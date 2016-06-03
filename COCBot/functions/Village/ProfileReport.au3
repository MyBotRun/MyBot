
; #FUNCTION# ====================================================================================================================
; Name ..........: ProfileReport
; Description ...: This function will report Attacks Won, Defenses Won, Troops Donated and Troops Received from Profile info page
; Syntax ........: ProfileReport()
; Parameters ....:
; Return values .: None
; Author ........: Sardo
; Modified ......: KnowJack (July 2015) add wait loop for slow PC read of OCR
;                  Sardo 2015-08
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func ProfileReport()

	Local $iCount
	ClickP($aAway, 1, 0, "#0221") ;Click Away
	If _Sleep($iDelayProfileReport1) Then Return

	SetLog("Profile Report", $COLOR_BLUE)
	SetLog("Opening Profile page to read atk, def, donated and received...", $COLOR_BLUE)
	Click(190, 33, 1, 0, "#0222") ; Click Info Profile Button
	If _Sleep($iDelayProfileReport2) Then Return

	While _ColorCheck(_GetPixelColor(400, 104 + $midOffsetY, True), Hex(0xA2A6BE, 6), 20) = False ; wait for Info Profile to open
		If $Debugsetlog = 1 Then Setlog("Profile wait time: " & $iCount & ", color= " & _GetPixelColor(400, 104 + $midOffsetY, True)& " pos (400," & 104 + $midOffsetY&")", $COLOR_PURPLE)
		$iCount += 1
		If _Sleep($iDelayProfileReport1) Then Return
		If $iCount >= 25 Then ExitLoop
	WEnd
	If $Debugsetlog = 1 And $iCount >= 25 Then Setlog("Excess wait time for profile to open: " & $iCount, $COLOR_PURPLE)
	If _Sleep($iDelayProfileReport1) Then Return
	$AttacksWon = ""

	If _ColorCheck(_GetPixelColor($ProfileRep01[0], $ProfileRep01[1] , True), Hex($ProfileRep01[2], 6), $ProfileRep01[3]) = true  Then
		If $debugSetlog=1 Then Setlog("Village have no attack and no defenses " & $ProfileRep01[0] & "," & $ProfileRep01[1] + $midOffsetY,$Color_PURPLE)
		$AttacksWon = 0
		$DefensesWon = 0
	Else
		$AttacksWon = getProfile(578, 268 + $midOffsetY)
		If $Debugsetlog = 1 Then Setlog("$AttacksWon 1st read: " & $AttacksWon, $COLOR_PURPLE)
		$iCount = 0
		While $AttacksWon = "" ; Wait for $attacksWon to be readable in case of slow PC
			If _Sleep($iDelayProfileReport1) Then Return
			$AttacksWon = getProfile(578, 268 + $midOffsetY)
			If $Debugsetlog = 1 Then Setlog("Read Loop $AttacksWon: " & $AttacksWon & ", Count: " & $iCount, $COLOR_PURPLE)
			$iCount += 1
			If $iCount >= 20 Then ExitLoop
		WEnd
		If $Debugsetlog = 1 And $iCount >= 20 Then Setlog("Excess wait time for reading $AttacksWon: " & getProfile(578, 268 + $midOffsetY), $COLOR_PURPLE)
		$DefensesWon = getProfile(790, 268 + $midOffsetY)
	EndIf
	$TroopsDonated = getProfile(158, 268 + $midOffsetY)
	$TroopsReceived = getProfile(360, 268 + $midOffsetY)

	SetLog(" [ATKW]: " & _NumberFormat($AttacksWon) & " [DEFW]: " & _NumberFormat($DefensesWon) & " [TDON]: " & _NumberFormat($TroopsDonated) & " [TREC]: " & _NumberFormat($TroopsReceived), $COLOR_GREEN)
	Click(820, 40, 1, 0, "#0223") ; Close Profile page
	If _Sleep($iDelayProfileReport3) Then Return

	$iCount = 0
	While _CheckPixel($aIsMain, $bCapturePixel) = False ; wait for profile report window very slow close
		If _Sleep($iDelayProfileReport3) Then Return
		$iCount += 1
		If $Debugsetlog = 1 Then Setlog("End ProfileReport $iCount= " & $iCount, $Color_PURPLE)
		If $iCount > 50 Then
			If $Debugsetlog = 1 Then Setlog("Excess wait time clearing ProfileReport window: " & $iCount, $COLOR_PURPLE)
			ExitLoop
		EndIf
	WEnd

EndFunc   ;==>ProfileReport
