
; #FUNCTION# ====================================================================================================================
; Name ..........: getArmyCCStatus
; Description ...: Updates global value of time reamining in mimutes for CC remaining time till can reques again - Army Overview window
; Syntax ........: getArmyCCStatus($bOpenArmyWindow = False, $bCloseArmyWindow = False)
; Parameters ....:
; Return values .: MonkeyHunter (06-2016)
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
;
Func getArmyCCStatus($bOpenArmyWindow = False, $bCloseArmyWindow = False)

	If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then Setlog("Begin getArmyCCStatus:", $COLOR_PURPLE)

	$iCCRemainTime = 0 ; reset global time

	If $bOpenArmyWindow = False And IsTrainPage() = False Then ; check for train page
		SetError(1)
		Return ; not open, not requested to be open - error.
	ElseIf $bOpenArmyWindow = True Then
		If openArmyOverview() = False Then
			SetError(2)
			Return ; not open, requested to be open - error.
		EndIf
		If _Sleep($iDelaycheckArmyCamp5) Then Return
	EndIf

	;verify can make requestCC and update global flag
	$canRequestCC = _ColorCheck(_GetPixelColor($aRequestTroopsAO[0], $aRequestTroopsAO[1], True), Hex($aRequestTroopsAO[2], 6), $aRequestTroopsAO[5])
	If $debugsetlogTrain = 1 Then SETLOG("Can Request CC: " & $canRequestCC, $COLOR_PURPLE)

	; check if waiting for request to expire to udpate time
	If _ColorCheck(_GetPixelColor($aRequestTroopsAO[0], $aRequestTroopsAO[1], True), Hex($aRequestTroopsAO[3], 6), $aRequestTroopsAO[5]) Then
		Local $iRemainTrainCCTimer = 0, $sResultCCMinutes = "", $aResult

		Local $sResultCC = getArmyCampCap($aArmyCCRemainTime[0], $aArmyCCRemainTime[1]) ;Get CC time via OCR.
		If $debugsetlogTrain = 1 Then Setlog("getArmyCampCap returned: " & $sResultCC, $COLOR_PURPLE)

		If $sResultCC <> "" Then
			If StringInStr($sResultCC, "m") > 1 Then
				$aResult = StringSplit($sResultCC, "m", $STR_NOCOUNT)
				; $aResult[0] will be the Minutes and the $aResult[1] will be the seconds with the "s" at end
				$aResult[1] = StringStripWS($aResult[1], $STR_STRIPALL)
				$sResultCCMinutes = StringTrimRight($aResult[1], 1) ; removing the "s"
				$iRemainTrainCCTimer = Number($aResult[0]) + Number($sResultCCMinutes / 60)
			ElseIf StringInStr($sResultCC, "s") > 1 Then
				$iRemainTrainCCTimer = Number(StringStripWS($sResultCC, $STR_STRIPALL)) / 60 ; removing the "s", " ", and convert to minutes
			Else
				If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then SetLog("getArmyCCStatus: Bad OCR string: " & $sResultCC, $COLOR_RED)
			EndIf
			If $bDonationEnabled Or $debugsetlogTrain = 1 Or $debugSetlog = 1 Then SetLog("CC request time: " & StringFormat("%.2f", $iRemainTrainCCTimer) & " minutes", $COLOR_BLUE)
			$iCCRemainTime = $iRemainTrainCCTimer ; update global value
		Else
			If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then SetLog("Can not read remaining Spell train time!", $COLOR_RED)
		EndIf
	EndIf

	If $bCloseArmyWindow = True Then
		ClickP($aAway, 1, 0, "#0000") ;Click Away
		If _Sleep($iDelaycheckArmyCamp4) Then Return
	EndIf

EndFunc   ;==>getArmyCCStatus
