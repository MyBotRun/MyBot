;
; #FUNCTION# ====================================================================================================================
; Name ..........: ReadTroopQuantity
; Description ...: Read the quantity for a given troop
; Syntax ........: ReadTroopQuantity($Troop)
; Parameters ....: $Troop               - an unknown value.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func ReadTroopQuantity($Troop)
	Local $iAmount
	$iAmount = getTroopCountSmall(GetXPosOfArmySlot($Troop, 40), 582 + $g_iBottomOffsetY)
	If $iAmount = "" Then
		$iAmount = getTroopCountBig(GetXPosOfArmySlot($Troop, 40), 577 + $g_iBottomOffsetY)
	EndIf
	Return Number($iAmount)
EndFunc   ;==>ReadTroopQuantity
