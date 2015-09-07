;Gets complete value of gold xxx, xxx

Func getGold($x_start, $y_start)
	_CaptureRegion(0, 0, $x_start + 90, $y_start + 20)

	Local $x = $x_start, $y = $y_start
	Local $Gold, $i = 0
	While getDigit($x, $y + $i, "Gold") = ""
		 If $i >= 15 Then ExitLoop
		 $i += 1
	WEnd
	$x = $x_start
	$Gold &= getDigit($x, $y + $i, "Gold")
	$Gold &= getDigit($x, $y + $i, "Gold")
	$Gold &= getDigit($x, $y + $i, "Gold")
	$x += 6
	$Gold &= getDigit($x, $y + $i, "Gold")
	$Gold &= getDigit($x, $y + $i, "Gold")
	$Gold &= getDigit($x, $y + $i, "Gold")
	Return $Gold
EndFunc   ;==>getGold
