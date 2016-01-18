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