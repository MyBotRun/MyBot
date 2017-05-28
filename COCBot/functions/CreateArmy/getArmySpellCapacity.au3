; #FUNCTION# ====================================================================================================================
; Name ..........: getArmySpellCapacity
; Description ...: Obtains current and total quanitites for spells from Training - Army Overview window
; Syntax ........: getArmySpellCapacity()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (01-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func getArmySpellCapacity($bOpenArmyWindow = False, $bCloseArmyWindow = False, $bSetLog = True, $CheckWindow = True)
	Local $TotalSFactory = 0

	If $g_iDebugSetlogTrain = 1 Or $g_iDebugSetlog = 1 Then SetLog("Begin getArmySpellCapacity:", $COLOR_DEBUG1)

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

	Local $aGetSFactorySize[3] = ["", "", ""]
	Local $iCount
	Local $sSpellsInfo = ""

	; Verify spell current and total capacity
	If $g_iTotalSpellValue > 0 Then ; only use this code if the user had input spells to brew ... and assign the spells quantity
		$sSpellsInfo = getArmyCampCap($aArmySpellSize[0], $aArmySpellSize[1]) ; OCR read Spells and total capacity

		$iCount = 0 ; reset OCR loop counter
		While $sSpellsInfo = "" ; In case the CC donations recieved msg are blocking, need to keep checking numbers till valid
			$sSpellsInfo = getArmyCampCap($aArmySpellSize[0], $aArmySpellSize[1]) ; OCR read Spells and total capacity
			$iCount += 1
			If $iCount > 10 Then ExitLoop ; try reading 30 times for 250+150ms OCR for 4 sec
			If _Sleep($DELAYCHECKARMYCAMP5) Then Return ; Wait 250ms
		WEnd

		If $g_iDebugSetlogTrain = 1 Then Setlog("$sSpellsInfo = " & $sSpellsInfo, $COLOR_DEBUG)
		$aGetSFactorySize = StringSplit($sSpellsInfo, "#") ; split the existen Spells from the total Spell factory capacity

		If IsArray($aGetSFactorySize) Then
			If $aGetSFactorySize[0] > 1 Then
				$TotalSFactory = Number($aGetSFactorySize[2])
				$g_iSpellFactorySize = Number($aGetSFactorySize[1])
			Else
				Setlog("Spell Factory size read error.", $COLOR_ERROR) ; log if there is read error
				$g_iSpellFactorySize = 0
				$TotalSFactory = $g_iTotalSpellValue
			EndIf
		Else
			Setlog("Spell Factory size read error.", $COLOR_ERROR) ; log if there is read error
			$g_iSpellFactorySize = 0
			$TotalSFactory = $g_iTotalSpellValue
		EndIf

		If $bSetLog Then SetLog("Total Spell(s) Capacity: " & $g_iSpellFactorySize & "/" & $TotalSFactory)
	EndIf

	If $TotalSFactory <> $g_iTotalSpellValue Then
		If $bSetLog Then Setlog("Note: Spell Factory Size read not same User Input Value.", $COLOR_WARNING) ; log if there difference between user input and OCR
	EndIf

	If $bCloseArmyWindow Then
		ClickP($aAway, 1, 0, "#0000") ;Click Away
		If _Sleep($DELAYCHECKARMYCAMP4) Then Return
	EndIf

EndFunc   ;==>getArmySpellCapacity
