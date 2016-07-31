; #FUNCTION# ====================================================================================================================
; Name ..........: getArmySpellCapacity
; Description ...: Obtains current and total quanitites for spells from Training - Army Overview window
; Syntax ........: getArmySpellCapacity()
; Parameters ....:
; Return values .: None
; Author ........: Separated from checkArmyCamp()
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func getArmySpellCapacity($bOpenArmyWindow = False, $bCloseArmyWindow = False)

	If $debugsetlogTrain = 1 Then SETLOG("Begin getArmySpellCapacity:", $COLOR_PURPLE)

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

	Local $aGetSFactorySize[3] = ["", "", ""]
	Local $iCount
	Local $sSpellsInfo = ""

	$bFullSpell = False

	; Verify spell current and total capacity
	If $iTotalCountSpell > 0 Then ; only use this code if the user had input spells to brew ... and assign the spells quantity
		$sSpellsInfo = getArmyCampCap($aArmySpellSize[0], $aArmySpellSize[1]) ; OCR read Spells and total capacity

		$iCount = 0 ; reset OCR loop counter
		While $sSpellsInfo = "" ; In case the CC donations recieved msg are blocking, need to keep checking numbers till valid
			$sSpellsInfo = getArmyCampCap($aArmySpellSize[0], $aArmySpellSize[1]) ; OCR read Spells and total capacity
			$iCount += 1
			If $iCount > 10 Then ExitLoop ; try reading 30 times for 250+150ms OCR for 4 sec
			If _Sleep($iDelaycheckArmyCamp5) Then Return ; Wait 250ms
		WEnd

		If $debugsetlogTrain = 1 Then Setlog("$sSpellsInfo = " & $sSpellsInfo, $COLOR_PURPLE)
		$aGetSFactorySize = StringSplit($sSpellsInfo, "#") ; split the existen Spells from the total Spell factory capacity

		If IsArray($aGetSFactorySize) Then
			If $aGetSFactorySize[0] > 1 Then
				$TotalSFactory = Number($aGetSFactorySize[2])
				$CurSFactory = Number($aGetSFactorySize[1])
			Else
				Setlog("Spell Factory size read error.", $COLOR_RED) ; log if there is read error
				$CurSFactory = 0
				$TotalSFactory = $iTotalCountSpell
			EndIf
		Else
			Setlog("Spell Factory size read error.", $COLOR_RED) ; log if there is read error
			$CurSFactory = 0
			$TotalSFactory = $iTotalCountSpell
		EndIf

		SetLog("Total Spell(s) Capacity: " & $CurSFactory & "/" & $TotalSFactory)

		If $CurSFactory >= $TotalSFactory Then
			$bFullSpell = True
		Else
			$bFullSpell = False
		EndIf
	EndIf

	If $TotalSFactory <> $iTotalCountSpell Then
		Setlog("Note: Spell Factory Size read not same User Input Value.", $COLOR_MAROON) ; log if there difference between user input and OCR
	EndIf

	If $bCloseArmyWindow = True Then
		ClickP($aAway, 1, 0, "#0000") ;Click Away
		If _Sleep($iDelaycheckArmyCamp4) Then Return
	EndIf

EndFunc   ;==>getArmySpellCapacity
