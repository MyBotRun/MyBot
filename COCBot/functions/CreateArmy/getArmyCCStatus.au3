; #FUNCTION# ====================================================================================================================
; Name ..........: getArmyCCStatus
; Description ...: Updates global value of time reamining in mimutes for CC remaining time till can reques again - Army Overview window
; Syntax ........: getArmyCCStatus($bOpenArmyWindow = False, $bCloseArmyWindow = False)
; Parameters ....:
; Return values .:
; Author ........: MonkeyHunter (06-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
;
Func getArmyCCStatus($bOpenArmyWindow = False, $bCloseArmyWindow = False, $bSetLog = True, $CheckWindow = True)

	If $g_iDebugSetlogTrain = 1 Or $g_iDebugSetlog = 1 Then Setlog("Begin getArmyCCStatus:", $COLOR_DEBUG1)

	$g_iCCRemainTime = 0 ; reset global time

	If $CheckWindow Then
		If Not $bOpenArmyWindow And Not IsTrainPage() Then ; check for train page
			SetError(1)
			Return ; not open, not requested to be open - error.
		ElseIf $bOpenArmyWindow Then
			If Not OpenArmyOverview() Then
				SetError(2)
				Return ; not open, requested to be open - error.
			EndIf
			If _Sleep($DELAYCHECKARMYCAMP5) Then Return
		EndIf
	EndIf

	;verify can make requestCC and update global flag
	$g_bCanRequestCC = _ColorCheck(_GetPixelColor($aRequestTroopsAO[0], $aRequestTroopsAO[1], True), Hex($aRequestTroopsAO[2], 6), $aRequestTroopsAO[5])
	If $g_iDebugSetlogTrain = 1 Then SetLog("Can Request CC: " & $g_bCanRequestCC, $COLOR_DEBUG)

	If Not $g_bCanRequestCC Then
		If _ColorCheck(_GetPixelColor($aRequestTroopsAO[0], $aRequestTroopsAO[1], True), Hex($aRequestTroopsAO[3], 6), $aRequestTroopsAO[5]) Then
			If $bSetLog Then Setlog(" - Clancastle request already made.", $COLOR_INFO)
		EndIf
		If _ColorCheck(_GetPixelColor($aRequestTroopsAO[0], $aRequestTroopsAO[1], True), Hex($aRequestTroopsAO[4], 6), $aRequestTroopsAO[5]) Then
			If $bSetLog Then Setlog("Clancastle Full/No clan.", $COLOR_INFO)
		EndIf
	EndIf

	; check if waiting for request to expire to udpate time
	If _ColorCheck(_GetPixelColor($aRequestTroopsAO[0], $aRequestTroopsAO[1], True), Hex($aRequestTroopsAO[3], 6), $aRequestTroopsAO[5]) Then
		Local $iRemainTrainCCTimer = 0, $sResultCCMinutes = "", $aResult

		;Local $sResultCC = getArmyCampCap($aArmyCCRemainTime[0], $aArmyCCRemainTime[1]) ;Get CC time via OCR.
		Local $sResultCC = getRequestRemainTime($aArmyCCRemainTime[0], $aArmyCCRemainTime[1])
		If $g_iDebugSetlogTrain = 1 Then Setlog("getArmyCampCap returned: " & $sResultCC, $COLOR_DEBUG)
		$g_iCCRemainTime = ConvertOCRTime("CC request", $sResultCC, $bSetLog)
	EndIf

	If $bCloseArmyWindow Then
		ClickP($aAway, 1, 0, "#0000") ;Click Away
		If _Sleep($DELAYCHECKARMYCAMP4) Then Return
	EndIf

EndFunc   ;==>getArmyCCStatus
