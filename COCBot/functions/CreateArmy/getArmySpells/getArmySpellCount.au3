
; #FUNCTION# ====================================================================================================================
; Name ..........: GetCurTotalSpell
; Description ...: Obtains count of spells available from Training - Army Overview window
; Syntax ........: GetCurTotalSpell()
; Parameters ....:
; Return values .: Total current spell count or -1 when not yet read
; Author ........:
; Modified ......: MonkeyHunter (06-2016), CodeSlinger69 (01-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func GetCurTotalSpell()

	Local $iCount = 0
	For $i = 0 To $eSpellCount - 1
		$iCount += $g_aiCurrentSpells[$i]
	Next

	Return $iCount
EndFunc   ;==>GetCurTotalSpell

; #FUNCTION# ====================================================================================================================
; Name ..........: GetCurTotalDarkSpell
; Description ...: Returns total count of dark spells available after call to getArmySpellCount()
; Return values .: Total current spell count or -1 when not yet read
; ===============================================================================================================================

Func GetCurTotalDarkSpell()

	Local $iCount = 0
	For $i = $eSpellPoison To $eSpellBat - 1
		$iCount += $g_aiCurrentSpells[$i]
	Next

	Return $iCount
EndFunc   ;==>GetCurTotalDarkSpell

; #FUNCTION# ====================================================================================================================
; Name ..........: GetCurTotalSpells
; Description ...: Returns total count of all Spells available after call to getArmySpellCount()
; Return values .: Total current spell count or -1 when not yet read
; ===============================================================================================================================
Func GetCurTotalSpells()

	Local $aCount[2]
	For $i = $eSpellLightning To $eSpellBat - 1
		$aCount[0] += $g_aiCurrentSpells[$i]
		If $g_aiCurrentSpells[$i] >= 1 Then $aCount[1] += 1
	Next

	Return $aCount
EndFunc   ;==>GetCurTotalSpells
