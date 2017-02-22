
; #FUNCTION# ====================================================================================================================
; Name ..........: SelectDropTroop
; Description ...:
; Syntax ........: SelectDropTroop($Troop)
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
Func SelectDropTroop($Troop)
	If IsAttackPage() Then Click(GetXPosOfArmySlot($Troop, 68), 595 + $g_iBottomOffsetY, 1, 0, "#0111") ;860x780
EndFunc   ;==>SelectDropTroop
