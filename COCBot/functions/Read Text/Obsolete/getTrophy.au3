;Returns complete value of Trophy xx

Func getTrophy($x_start, $y_start)
	_CaptureRegion(0, 0, $x_start + 90, $y_start + 20)

	Local $x = $x_start, $y = $y_start
	Local $Trophy, $i = 0
	While getDigit($x, $y + $i, "Trophy") = ""
		If $i >= 15 Then ExitLoop
		$i += 1
	WEnd
	$x = $x_start
	$Trophy &= getDigit($x, $y + $i, "Trophy")
	$Trophy &= getDigit($x, $y + $i, "Trophy")
	Return $Trophy
EndFunc   ;==>getTrophy
