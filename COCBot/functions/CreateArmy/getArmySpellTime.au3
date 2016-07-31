
; #FUNCTION# ====================================================================================================================
; Name ..........: getArmySpellTime
; Description ...: Obtains time reamining in mimutes for spells Training - Army Overview window
; Syntax ........: getArmySpellTime($bOpenArmyWindow = False, $bCloseArmyWindow = False)
; Parameters ....:
; Return values .: Promac (04-2016)
; Author ........: MonkeyHunter (04-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
;
Func getArmySpellTime($bOpenArmyWindow = False, $bCloseArmyWindow = False)

	If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then Setlog("Begin getArmySpellTime:", $COLOR_PURPLE)

	$aTimeTrain[1] = 0  ; reset time

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

	Local $iRemainTrainSpellsTimer = 0, $sResultSpellsMinutes = "", $aResult

	Local $sResultSpells = getRemainTrainTimer(360, 422)  ;Get spell training time via OCR.

	If $sResultSpells <> "" Then
		If StringInStr($sResultSpells, "h") > 1 Then
			$aResult = StringSplit($sResultSpells, "h", $STR_NOCOUNT)
			; $aResult[0] will be the Hour and the $aResult[1] will be the Minutes with the "m" at end
			$sResultSpellsMinutes = StringTrimRight($aResult[1], 1) ; removing the "m"
			$iRemainTrainSpellsTimer = (Number($aResult[0]) * 60) + Number($sResultSpellsMinutes)
		ElseIf StringInStr($sResultSpells, "m") > 1 Then
			$iRemainTrainSpellsTimer = Number(StringTrimRight($sResultSpells, 1)) ; removing the "m"
		ElseIf StringInStr($sResultSpells, "s") > 1 Then
			$iRemainTrainSpellsTimer = Number(StringTrimRight($sResultSpells, 1)) / 60  ; removing the "s" and convert to minutes
		Else
			If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then SetLog("getArmySpellTime: Bad OCR string", $COLOR_RED)
		EndIf
		SetLog("Spells cook time: " & StringFormat("%.2f", $iRemainTrainSpellsTimer), $COLOR_BLUE)
	Else
		If Not $bFullArmySpells Then
			If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then SetLog("Can not read remaining Spell train time!", $COLOR_RED)
		EndIf
	EndIf

	If $bCloseArmyWindow = True Then
		ClickP($aAway, 1, 0, "#0000") ;Click Away
		If _Sleep($iDelaycheckArmyCamp4) Then Return
	EndIf

	$aTimeTrain[1] = $iRemainTrainSpellsTimer  ; update global array

EndFunc   ;==>getArmySpellCount
