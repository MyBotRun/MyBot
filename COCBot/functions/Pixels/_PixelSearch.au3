;PixelSearch a certain region, works for memory BMP

Func _PixelSearch($iLeft, $iTop, $iRight, $iBottom, $iColor, $iColorVariation)
	_CaptureRegion($iLeft, $iTop, $iRight, $iBottom)
	For $x = $iRight - $iLeft To 0 Step -1
		For $y = 0 To $iBottom - $iTop
			If _ColorCheck(_GetPixelColor($x, $y), $iColor, $iColorVariation) Then
				Local $Pos[2] = [$iLeft + $x, $iTop + $y]
				Return $Pos
			EndIf
		Next
	Next
	Return 0
EndFunc   ;==>_PixelSearch