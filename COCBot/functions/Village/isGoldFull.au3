; #FUNCTION# ====================================================================================================================
; Name ..........: isGoldFull
; Description ...: Checks if your Gold Storages are maxed out
; Syntax ........: isGoldFull()
; Parameters ....:
; Return values .: True or False
; Author ........: Code Monkey #57 (send more bananas please!)
; Modified ......: Hervidero (2015)
; Remarks .......: This file is part of ClashGameBot. Copyright 2015
;                  ClashGameBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================

Func isGoldFull()
	If _CheckPixel($aIsGoldFull, $bCapturePixel) Then ;Hex if color of gold (orange)
		SetLog("Gold Storages are full!", $COLOR_GREEN)
		Return True
	EndIf
	Return False
EndFunc   ;==>isGoldFull
