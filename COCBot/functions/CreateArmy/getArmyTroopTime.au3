
; #FUNCTION# ====================================================================================================================
; Name ..........: getArmyTroopTime
; Description ...: Obtains time reamining in mimutes for Troops Training - Army Overview window
; Syntax ........: getArmyTroopTime($bOpenArmyWindow = False, $bCloseArmyWindow = False)
; Parameters ....:
; Return values .: Promac(04-2016)
; Author ........: MonkeyHunter (04-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
;
Func getArmyTroopTime($bOpenArmyWindow = False, $bCloseArmyWindow = False)

	If $g_iDebugSetlogTrain = 1 Or $g_iDebugSetlog = 1 Then SETLOG("Begin getArmyTroopTime:", $COLOR_DEBUG1)

	$aTimeTrain[0] = 0  ; reset time

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
	Local $sResultTroops = getRemainTrainTimer(756, 169) ;Get time via OCR.
	$aTimeTrain[0] = ConvertOCRTime("Troops", $sResultTroops)  ; update global array

	If $bCloseArmyWindow = True Then
		ClickP($aAway, 1, 0, "#0000") ;Click Away
		If _Sleep($iDelaycheckArmyCamp4) Then Return
	EndIf
EndFunc   ;==>getArmyTroopTime
