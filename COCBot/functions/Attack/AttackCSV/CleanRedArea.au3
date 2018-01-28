; #FUNCTION# ====================================================================================================================
; Name ..........: CleanRedArea
; Description ...: Remove pixels that are outside diamond
; Syntax ........: CleanRedArea($InputVect, $side)
; Parameters ....: $InputVect - an array
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func CleanRedArea(ByRef $InputVect, $side = "")
	Local $TempVectStr = ""
	For $i = 0 To UBound($InputVect) - 1
		Local $pixel = $InputVect[$i]
		If isInsideDiamondRedArea($pixel) Then
			$TempVectStr &= $pixel[0] & "-" & $pixel[1] & "|"
		Else
			debugAttackCSV("CleanRedArea removed (" & $pixel[0] & "," & $pixel[1] & ")")
		EndIf
	Next
	If StringLen($TempVectStr) > 0 Then
		$TempVectStr = StringLeft($TempVectStr, StringLen($TempVectStr) - 1)
		$InputVect = GetListPixel($TempVectStr)
	EndIf
EndFunc   ;==>CleanRedArea
