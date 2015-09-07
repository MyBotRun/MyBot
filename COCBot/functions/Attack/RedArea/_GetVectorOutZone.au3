
Func _GetVectorOutZone($eVectorType)
	debugRedArea("_GetVectorOutZone IN")
	Local $vectorOutZone[0]

	If ($eVectorType = $eVectorLeftTop) Then
		$xMin = 426
		$yMin = 10
		$xMax = 31
		$yMax = 300
		$xStep = -4
		$yStep = 3
	ElseIf ($eVectorType = $eVectorRightTop) Then
		$xMin = 426
		$yMin = 10
		$xMax = 834
		$yMax = 312
		$xStep = 4
		$yStep = 3
	ElseIf ($eVectorType = $eVectorLeftBottom) Then
		$xMin = 24
		$yMin = 307
		$xMax = 336
		$yMax = 540
		$xStep = 4
		$yStep = 3
	Else
		$xMin = 834
		$yMin = 312
		$xMax = 545
		$yMax = 544
		$xStep = -4
		$yStep = 3
	EndIf


	Local $pixel[2]
	Local $x = $xMin
	For $y = $yMin To $yMax Step $yStep
		$x += $xStep
		$pixel[0] = $x
		$pixel[1] = $y
		ReDim $vectorOutZone[UBound($vectorOutZone) + 1]
		$vectorOutZone[UBound($vectorOutZone) - 1] = $pixel

	Next

	Return $vectorOutZone
EndFunc   ;==>_GetVectorOutZone
