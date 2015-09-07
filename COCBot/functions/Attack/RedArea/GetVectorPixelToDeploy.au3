

; Param : 	$arrPixel : Array of pixel where troop are deploy
;			$vectorDirection : The vector direction => 0 = Left To Right (x asc) / 1 = Top to Bottom (y asc)
;			$sizeVector : Number of pixel for the vector
; Return : 	The vector of pixel
; Strategy :
; 			Get min / max pixel of array pixel
;			Get min / max value of x or y (depends vector direction)
;			Get the offset to browse the array pixel (depends of size vector)
;			For min to max with offset , get pixel closer and add to the vector
Func GetVectorPixelToDeploy($arrPixel, $vectorDirection, $sizeVector)
	Local $vectorPixel[0]
	debugRedArea("GetVectorPixelToDeploy IN")
	debugRedArea("size " & UBound($arrPixel))
	If (UBound($arrPixel) > 1) Then
		Local $pixelSearch[2] = [-1, -1]
		Local $minPixel = $arrPixel[0]
		Local $maxPixel = $arrPixel[UBound($arrPixel) - 1]
		Local $min = $minPixel[$vectorDirection]
		Local $max = $maxPixel[$vectorDirection]
		Local $offset = ($max - $min) / $sizeVector
		debugRedArea("min : [" & $min & "] / max [" & $max & "] / offset [" & $offset & "]")
		If ($min <= $max And $offset <= 0) Then
			$offset = 1
		ElseIf ($min >= $max And $offset >= 0) Then
			$offset = -1
		EndIf
		For $i = $min To $max Step $offset
			$pixelSearch[$vectorDirection] = $i
			Local $arrPixelCloser = _FindPixelCloser($arrPixel, $pixelSearch, 1)
			ReDim $vectorPixel[UBound($vectorPixel) + 1]
			$vectorPixel[UBound($vectorPixel) - 1] = $arrPixelCloser[0]
		Next

	EndIf
	Return $vectorPixel
EndFunc   ;==>GetVectorPixelToDeploy
