; #FUNCTION# ====================================================================================================================
; Name ..........: CleanRedArea
; Description ...: Remove pixels that are outside diamond
; Syntax ........: CleanRedArea($InputVect, $side)
; Parameters ....: $InputVect - an array
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func CleanRedArea(ByRef $InputVect, $side = "")
	Local $TempVectStr = ""
	For $i = 0 To UBound($InputVect) - 1
		$pixel = $InputVect[$i]
		If isInsideDiamondRedArea($pixel) And Not ($pixel[0] = 261 And $pixel[1] = 191) And Not ($pixel[0] = $ExternalArea[2][0]) Then
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
