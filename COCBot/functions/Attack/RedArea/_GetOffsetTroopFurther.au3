
Func _GetOffsetTroopFurther($pixel, $eVectorType, $offset)
	debugRedArea("_GetOffsetTroopFurther IN")
	Local $xMin, $xMax, $yMin, $yMax, $xStep, $yStep, $xOffset, $yOffset
	Local $vectorRedArea[0]
	Local $pixelOffset = GetOffestPixelRedArea2($pixel, $eVectorType, $offset)
	If ($eVectorType = $eVectorLeftTop) Then
		$xMin = 74
		$xMax = 433
		$yMin = 320
		$yMax = 60
		$xStep = 4
		$yStep = -3
		$yOffset = -1 * $offset
		$xOffset = Floor($yOffset)
	ElseIf ($eVectorType = $eVectorRightTop) Then
		$xMin = 417
		$xMax = 800
		$yMin = 39
		$yMax = 320
		$xStep = 4
		$yStep = 3
		$yOffset = -1 * $offset
		$xOffset = Floor($yOffset) * -1
	ElseIf ($eVectorType = $eVectorLeftBottom) Then
		$xMin = 75
		$xMax = 451
		$yMin = 298
		$yMax = 580
		$xStep = 4
		$yStep = 3
		$yOffset = $offset
		$xOffset = Floor($yOffset) * -1
	Else
		$xMin = 433
		$xMax = 800
		$yMin = 570
		$yMax = 300
		$xStep = 4
		$yStep = -3
		$yOffset = $offset
		$xOffset = Floor($yOffset)
	EndIf



	Local $y = $yMin
	Local $found = False
	For $x = $xMin To $xMax Step $xStep
		If ($eVectorType = $eVectorRightBottom And $y > $yMax And $pixelOffset[0] > $x And $pixelOffset[1] > $y) Then
			$pixelOffset[0] = $x + $xOffset
			$pixelOffset[1] = $y + $yOffset
			$found = True
		ElseIf ($eVectorType = $eVectorLeftBottom And $y < $yMax And $pixelOffset[0] < $x And $pixelOffset[1] > $y) Then
			$pixelOffset[0] = $x + $xOffset
			$pixelOffset[1] = $y + $yOffset
			$found = True
		ElseIf ($eVectorType = $eVectorLeftTop And $y > $yMax And $pixelOffset[0] < $x And $pixelOffset[1] < $y) Then
			$pixelOffset[0] = $x + $xOffset
			$pixelOffset[1] = $y + $yOffset

			$found = True
		ElseIf ($eVectorType = $eVectorRightTop And $y < $yMax And $pixelOffset[0] > $x And $pixelOffset[1] < $y) Then
			$pixelOffset[0] = $x + $xOffset
			$pixelOffset[1] = $y + $yOffset
			$found = True
		EndIf

		$y += $yStep
		If ($found) Then ExitLoop
	Next
	; Not select pixel in menu of troop
	If $pixelOffset[1] > 547 Then
		$pixelOffset[1] = 547
	EndIf
	debugRedArea("$pixelOffset x : [" + $pixelOffset[0] + "] / y : [" + $pixelOffset[1] + "]")

	Return $pixelOffset
EndFunc   ;==>_GetOffsetTroopFurther
