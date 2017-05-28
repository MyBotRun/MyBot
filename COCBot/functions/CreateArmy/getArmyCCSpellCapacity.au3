; #FUNCTION# ====================================================================================================================
; Name ..........: getArmyCCSpellCapacity
; Description ...: Obtains current and total quanitites for Clancastle spells from Training - Army Overview window
; Syntax ........: getArmyCCSpellCapacity()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (01-2017), Fliegerfaust (03-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func getArmyCCSpellCapacity($bOpenArmyWindow = False, $bCloseArmyWindow = False, $bSetLog = True, $CheckWindow = True)

	If $g_iDebugSetlogTrain = 1 Or $g_iDebugSetlog = 1 Then SetLog("Begin getArmyCCSpellCapacity:", $COLOR_DEBUG1)

	If $CheckWindow Then
		If Not $bOpenArmyWindow And Not IsTrainPage() Then ; check for train page
			SetError(1)
			Return ; not open, not requested to be open - error.
		ElseIf $bOpenArmyWindow = True Then
			If Not OpenArmyOverview() Then
				SetError(2)
				Return ; not open, requested to be open - error.
			EndIf
			If _Sleep($DELAYCHECKARMYCAMP5) Then Return
		EndIf
	EndIf

	Local $aGetCCSpellsSize[3] = ["", "", ""]
	Local $iCount
	Local $sCCSpellsInfo = ""

	; Verify spell current and total capacity
	If $g_abSearchCastleSpellsWaitEnable[$DB] Or $g_abSearchCastleSpellsWaitEnable[$LB] Then ; only use this code if the user has enabled Wait For CC Spells
		$sCCSpellsInfo = getArmyCampCap($g_aArmyCCSpellSize[0], $g_aArmyCCSpellSize[1]) ; OCR read Spells and total capacity

		$iCount = 0 ; reset OCR loop counter
		While $sCCSpellsInfo = "" ; In case the CC donations recieved msg are blocking, need to keep checking numbers till valid
			$sCCSpellsInfo = getArmyCampCap($g_aArmyCCSpellSize[0], $g_aArmyCCSpellSize[1]) ; OCR read Spells and total capacity
			$iCount += 1
			If $iCount > 10 Then ExitLoop ; try reading 30 times for 250+150ms OCR for 4 sec
			If _Sleep($DELAYCHECKARMYCAMP5) Then Return ; Wait 250ms
		WEnd

		If $g_iDebugSetlogTrain = 1 Then Setlog("$sCCSpellsInfo = " & $sCCSpellsInfo, $COLOR_DEBUG)
		$aGetCCSpellsSize = StringSplit($sCCSpellsInfo, "#") ; split the existen Spells from the total Spell factory capacity

		If IsArray($aGetCCSpellsSize) Then
			If $aGetCCSpellsSize[0] > 1 Then
				$g_iTotalCCSpell = Number($aGetCCSpellsSize[2])
				$g_iCurrentCCSpell = Number($aGetCCSpellsSize[1])
			Else
				Setlog("CC Spells size read error.", $COLOR_ERROR) ; log if there is read error
				$g_iTotalCCSpell = 0
				$g_iCurrentCCSpell = 0
			EndIf
		Else
			Setlog("CC Spells size read error.", $COLOR_ERROR) ; log if there is read error
			$g_iTotalCCSpell = 0
			$g_iCurrentCCSpell = 0
		EndIf

		SetLog("Total Clancastle Spells: " & $g_iCurrentCCSpell & "/" & $g_iTotalCCSpell)
	EndIf

	If $bCloseArmyWindow Then
		ClickP($aAway, 1, 0, "#0000") ;Click Away
		If _Sleep($DELAYCHECKARMYCAMP4) Then Return
	EndIf

EndFunc   ;==>getArmyCCSpellCapacity
