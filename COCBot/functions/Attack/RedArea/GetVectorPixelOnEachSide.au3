
Func GetVectorPixelOnEachSide($arrPixel, $vectorDirection)
	Local $vectorPixelEachSide[2]
	If (UBound($arrPixel) > 1) Then
		Local $pixelSearch[2] = [-1, -1]
		Local $minPixel = $arrPixel[0]
		Local $maxPixel = $arrPixel[UBound($arrPixel) - 1]
		Local $min = $minPixel[$vectorDirection]
		Local $max = $maxPixel[$vectorDirection]
		Local $posSide = ($max - $min) / 4

		$pixelSearch[$vectorDirection] = $min + $posSide
		Local $arrPixelCloser = _FindPixelCloser($arrPixel, $pixelSearch, 1)
		$vectorPixelEachSide[0] = $arrPixelCloser[0]

		$pixelSearch[$vectorDirection] = $min + $posSide * 3
		Local $arrPixelCloser = _FindPixelCloser($arrPixel, $pixelSearch, 1)
		$vectorPixelEachSide[1] = $arrPixelCloser[0]


	EndIf
	Return $vectorPixelEachSide
EndFunc   ;==>GetVectorPixelOnEachSide
