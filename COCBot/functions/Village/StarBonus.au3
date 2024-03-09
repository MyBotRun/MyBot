; #FUNCTION# ====================================================================================================================
; Name ..........: StarBonus
; Description ...: Checks for Star bonus window, and clicks ok to close window.
; Syntax ........: StarBonus()
; Parameters ....:
; Return values .: MonkeyHunter(2016-1)
; Modified ......: MonkeyHunter (05-2017), Moebius14 (12-2023)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func StarBonus()

	SetDebugLog("Begin Star Bonus window check", $COLOR_DEBUG1)

	; Verify is Star bonus window open?
	If Not _CheckPixel($aIsMainGrayed, $g_bCapturePixel, Default, "IsMainGrayed") Then Return ; Star bonus window opens on main base view, and grays page.

	Local $aWindowChk1[4] = [630, 100 + $g_iMidOffsetY, 0x32A1F7, 20] ; Top Blue Sky
	Local $aWindowChk2[4] = [570, 180 + $g_iMidOffsetY, 0xC8CAC6, 20] ; Grey star

	If _Sleep($DELAYSTARBONUS100) Then Return

	; Verify actual star bonus window open
	If _CheckPixel($aWindowChk1, $g_bCapturePixel, Default, "Starbonus1") And _CheckPixel($aWindowChk2, $g_bCapturePixel, Default, "Starbonus2") Then
		; Find and Click Okay button
		Local $aiOkayButton = findButton("Okay", Default, 1, True)
		If IsArray($aiOkayButton) And UBound($aiOkayButton, 1) = 2 Then
			PureClick($aiOkayButton[0], $aiOkayButton[1], 2, 50, "#0117") ; Click Okay Button
			If _Sleep($DELAYSTARBONUS500) Then Return
			$StarBonusReceived = 1
			Return True
		Else
			SetDebugLog("Cannot Find Okay Button", $COLOR_ERROR)
		EndIf
	EndIf

	SetDebugLog("Star Bonus window not found?", $COLOR_DEBUG)
	Return False

EndFunc   ;==>StarBonus
