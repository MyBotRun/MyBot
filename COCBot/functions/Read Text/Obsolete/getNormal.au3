;Returns complete value of normal xxx

Func getNormal($x_start, $y_start)
	_CaptureRegion(0, 0, $x_start + 90, $y_start + 20)
	;-----------------------------------------------------------------------------
	Local $x = $x_start, $y = $y_start
	Local $Normal, $i = 0

	$Normal = getDigit($x, $y, "Normal")

	While $Normal = ""
		If $i >= 50 Then ExitLoop
		$i += 1
		$x += 1
		$Normal = getDigit($x, $y, "Normal")
	WEnd

	$Normal &= getDigit($x, $y, "Normal")
	$Normal &= getDigit($x, $y, "Normal")

	Return $Normal
EndFunc   ;==>getNormal