
Func GetPixelDropTroop($troop, $number, $slotsPerEdge)
	Local $newPixelTopLeft
	Local $newPixelBottomLeft
	Local $newPixelTopRight
	Local $newPixelBottomRight

	If ($troop = $eArch Or $troop = $eWiza Or $troop = $eMini) Then
		$newPixelTopLeft = $PixelTopLeftFurther
		$newPixelBottomLeft = $PixelBottomLeftFurther
		$newPixelTopRight = $PixelTopRightFurther
		$newPixelBottomRight = $PixelBottomRightFurther

	Else
		$newPixelTopLeft = $PixelTopLeft
		$newPixelBottomLeft = $PixelBottomLeft
		$newPixelTopRight = $PixelTopRight
		$newPixelBottomRight = $PixelBottomRight
	EndIf

	If ($slotsPerEdge = 1) Then
		$newPixelTopLeft = GetVectorPixelAverage($newPixelTopLeft, 0)
		$newPixelBottomLeft = GetVectorPixelAverage($newPixelBottomLeft, 1)
		$newPixelTopRight = GetVectorPixelAverage($newPixelTopRight, 1)
		$newPixelBottomRight = GetVectorPixelAverage($newPixelBottomRight, 0)
	ElseIf ($slotsPerEdge = 2) Then
		$newPixelTopLeft = GetVectorPixelOnEachSide($newPixelTopLeft, 0)
		$newPixelBottomLeft = GetVectorPixelOnEachSide($newPixelBottomLeft, 1)
		$newPixelTopRight = GetVectorPixelOnEachSide($newPixelTopRight, 1)
		$newPixelBottomRight = GetVectorPixelOnEachSide($newPixelBottomRight, 0)
	Else
		debugRedArea("GetPixelDropTroop :  $slotsPerEdge [" & $slotsPerEdge & "] ")
		$newPixelTopLeft = GetVectorPixelToDeploy($newPixelTopLeft, 0, $slotsPerEdge)
		$newPixelBottomLeft = GetVectorPixelToDeploy($newPixelBottomLeft, 1, $slotsPerEdge)
		$newPixelTopRight = GetVectorPixelToDeploy($newPixelTopRight, 1, $slotsPerEdge)
		$newPixelBottomRight = GetVectorPixelToDeploy($newPixelBottomRight, 0, $slotsPerEdge)

	EndIf
	Local $edgesPixelToDrop[4] = [$newPixelBottomRight, $newPixelTopLeft, $newPixelBottomLeft, $newPixelTopRight]
	Return $edgesPixelToDrop
EndFunc   ;==>GetPixelDropTroop
