;Returns color of pixel in the coordinations

Func _GetPixelColor($iX, $iY, $bNeedCapture = False)
	If $bNeedCapture = False Then
		$aPixelColor = _GDIPlus_BitmapGetPixel($hBitmap, $iX, $iY)
	Else
		_CaptureRegion($iX - 1, $iY - 1, $iX + 1, $iY + 1)
		$aPixelColor = _GDIPlus_BitmapGetPixel($hBitmap, 1, 1)
	EndIf
	If $debugGetPixel = 1 Then Setlog("GetPixel x=" & $iX & ", y=" & $iY & " = " & Hex($aPixelColor, 6), $COLOR_CYAN)
	Return Hex($aPixelColor, 6)
EndFunc   ;==>_GetPixelColor
