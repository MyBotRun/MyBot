;Returns complete value of dark elixir xxx, xxx

Func getDarkElixir($x_start, $y_start)
	_CaptureRegion(0, 0, $x_start + 90, $y_start + 20)

	Local $x = $x_start, $y = $y_start
	Local $DarkElixir, $i = 0
	While getDigit($x, $y + $i, "DarkElixir") = ""
		If $i >= 15 Then ExitLoop
		$i += 1
	WEnd
	$x = $x_start
	$DarkElixir &= getDigit($x, $y + $i, "DarkElixir")
	$DarkElixir &= getDigit($x, $y + $i, "DarkElixir")
	$DarkElixir &= getDigit($x, $y + $i, "DarkElixir")
	$x += 6
	$DarkElixir &= getDigit($x, $y + $i, "DarkElixir")
	$DarkElixir &= getDigit($x, $y + $i, "DarkElixir")
	$DarkElixir &= getDigit($x, $y + $i, "DarkElixir")
	Return $DarkElixir
EndFunc   ;==>getDarkElixir
