;Uses multiple pixels with coordinates of each color in a certain region, works for memory BMP

;$xSkip and $ySkip for numbers of pixels skip
;$offColor[2][COLOR/OFFSETX/OFFSETY] offset relative to firstColor coordination

; rotate y first, x second: search in columns
Func _MultiPixelSearch($iLeft, $iTop, $iRight, $iBottom, $xSkip, $ySkip, $firstColor, $offColor, $iColorVariation)
	_CaptureRegion($iLeft, $iTop, $iRight, $iBottom)
	For $x = 0 To $iRight - $iLeft Step $xSkip
		For $y = 0 To $iBottom - $iTop Step $ySkip
			If _ColorCheck(_GetPixelColor($x, $y), $firstColor, $iColorVariation) Then
				Local $allchecked = True
				For $i = 0 To UBound($offColor) - 1
					If _ColorCheck(_GetPixelColor($x + $offColor[$i][1], $y + $offColor[$i][2]), Hex($offColor[$i][0], 6), $iColorVariation) = False Then
						$allchecked = False
						ExitLoop
					EndIf
				Next
				If $allchecked Then
					Local $Pos[2] = [$iLeft + $x, $iTop + $y]
					Return $Pos
				EndIf
			EndIf
		Next
	Next
	Return 0
EndFunc   ;==>_MultiPixelSearch

; rotate x first, y second: search in rows
Func _MultiPixelSearch2($iLeft, $iTop, $iRight, $iBottom, $xSkip, $ySkip, $firstColor, $offColor, $iColorVariation)
	_CaptureRegion($iLeft, $iTop, $iRight, $iBottom)
	For $y = 0 To $iBottom - $iTop Step $ySkip
		For $x = 0 To $iRight - $iLeft Step $xSkip
			If _ColorCheck(_GetPixelColor($x, $y), $firstColor, $iColorVariation) Then
				Local $allchecked = True
				For $i = 0 To UBound($offColor) - 1
					If _ColorCheck(_GetPixelColor($x + $offColor[$i][1], $y + $offColor[$i][2]), Hex($offColor[$i][0], 6), $iColorVariation) = False Then
						$allchecked = False
						ExitLoop
					EndIf
				Next
				If $allchecked Then
					Local $Pos[2] = [$iLeft + $x, $iTop + $y]
					Return $Pos
				EndIf
			EndIf
		Next
	Next
	Return 0
EndFunc   ;==>_MultiPixelSearch2
