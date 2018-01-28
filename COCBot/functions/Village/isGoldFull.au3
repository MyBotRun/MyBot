; #FUNCTION# ====================================================================================================================
; Name ..........: isGoldFull
; Description ...: Checks if your Gold Storages are maxed out
; Syntax ........: isGoldFull()
; Parameters ....:
; Return values .: True or False
; Author ........: Code Monkey #57 (send more bananas please!)
; Modified ......: Hervidero (2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func isGoldFull()
	If _CheckPixel($aIsGoldFull, $g_bCapturePixel) Then ;Hex if color of gold (orange)
		SetLog("Gold Storages are full!", $COLOR_SUCCESS)
		Return True
	EndIf
	Return False
EndFunc   ;==>isGoldFull
