; Search the closer array of pixel in the array of pixel
Func _FindPixelCloser($arrPixel, $pixel, $nb = 1)
	Local $arrPixelCloser[0]
	For $j = 0 To $nb
		Local $PixelCloser = $arrPixel[0]
		For $i = 0 To UBound($arrPixel) - 1
			$alreadyExist = False
			Local $arrTemp = $arrPixel[$i]
			Local $found = False
			;search closer only on y
			If ($pixel[0] = -1) Then
				If (Abs($arrTemp[1] - $pixel[1]) < Abs($PixelCloser[1] - $pixel[1])) Then
					$found = True
				EndIf
				;search closer only on x
			ElseIf ($pixel[1] = -1) Then
				If (Abs($arrTemp[0] - $pixel[0]) < Abs($PixelCloser[0] - $pixel[0])) Then
					$found = True
				EndIf
				;search closer on x/y
			Else
				If ((Abs($arrTemp[0] - $pixel[0]) + Abs($arrTemp[1] - $pixel[1])) < (Abs($PixelCloser[0] - $pixel[0]) + Abs($PixelCloser[1] - $pixel[1]))) Then
					$found = True
				EndIf
			EndIf
			If ($found) Then
				For $k = 0 To UBound($arrPixelCloser) - 1
					Local $arrTemp2 = $arrPixelCloser[$k]
					If ($arrTemp[0] = $arrTemp2[0] And $arrTemp[1] = $arrTemp2[1]) Then
						$alreadyExist = True
						ExitLoop
					EndIf
				Next
				If ($alreadyExist = False) Then
					$PixelCloser = $arrTemp
				EndIf
			EndIf
		Next
		ReDim $arrPixelCloser[UBound($arrPixelCloser) + 1]
		$arrPixelCloser[UBound($arrPixelCloser) - 1] = $PixelCloser

	Next
	Return $arrPixelCloser
EndFunc   ;==>_FindPixelCloser
