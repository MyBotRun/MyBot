; #FUNCTION# ====================================================================================================================
; Name ..........: OpenPersonalChallenges()
; Description ...: Open personal challenges
; Author ........: TripleM (04/2019)
; Modified ......: 
; Remarks .......: This file is part of MyBot Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: 
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: OpenPersonalChallenges ()
; ===============================================================================================================================
#include-once

Func OpenPersonalChallenges()
	SetLog("Opening personal challenges", $COLOR_INFO)

	If _CheckPixel($aPersonalChallengeOpenButton1, $g_bCapturePixel) Then
		ClickP($aPersonalChallengeOpenButton1, 1, 0, "#0666")
	ElseIf _CheckPixel($aPersonalChallengeOpenButton2, $g_bCapturePixel) Then
		ClickP($aPersonalChallengeOpenButton2, 1, 0, "#0666")
	Else
		SetLog("Can't find button", $COLOR_ERROR)
		ClickP($aAway, 2, 20, "#0467") ;Click Away
	EndIf

	Local $counter = 0
	While Not _CheckPixel($aPersonalChallengeCloseButton, $g_bCapturePixel) ; test for Personal Challenge Close Button
		If $g_bDebugSetlog Then SetDebugLog("Wait for Personal Challenge Close Button to appear #" & $counter)
		If _Sleep($DELAYRUNBOT6) Then ExitLoop
		$counter += 1
		If $counter > 40 Then ExitLoop
	WEnd

EndFunc   ;==>OpenPersonalChallenges

; #FUNCTION# ====================================================================================================================
; Name ..........: ClosePersonalChallenges()
; Description ...: Close personal challenges
; Author ........: TripleM (04/2019)
; Modified ......: 
; Remarks .......: This file is part of MyBot Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: 
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: ClosePersonalChallenges ()
; ===============================================================================================================================
#include-once

Func ClosePersonalChallenges()
	If $g_bDebugSetlog Then SetLog("Opening personal challenges", $COLOR_INFO)

	If _CheckPixel($aPersonalChallengeCloseButton, $g_bCapturePixel) Then
		ClickP($aPersonalChallengeCloseButton, 1, 0, "#0667")
	Else
		SetLog("Can't find close button", $COLOR_ERROR)
		ClickP($aAway, 2, 20, "#0467") ;Click Away
	EndIf

	Local $counter = 0
	While Not IsMainPage(1) ; test for Personal Challenge Close Button
		If $g_bDebugSetlog Then SetDebugLog("Wait for Personal Challenge Window to close #" & $counter)
		If _Sleep($DELAYRUNBOT6) Then ExitLoop
		$counter += 1
		If $counter > 40 Then ExitLoop
	WEnd

EndFunc   ;==>ClosePersonalChallenges
