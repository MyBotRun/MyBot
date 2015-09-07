;Returns complete Value of elixir xxx, xxx

Func getElixir($x_start, $y_start)
	_CaptureRegion(0, 0, $x_start + 90, $y_start + 20)

	Local $x = $x_start, $y = $y_start
	Local $Elixir, $i = 0
	While getDigit($x, $y + $i, "Elixir") = ""
		If $i >= 15 Then ExitLoop
		$i += 1
	WEnd
	$x = $x_start
	$Elixir &= getDigit($x, $y + $i, "Elixir")
	$Elixir &= getDigit($x, $y + $i, "Elixir")
	$Elixir &= getDigit($x, $y + $i, "Elixir")
	$x += 6
	$Elixir &= getDigit($x, $y + $i, "Elixir")
	$Elixir &= getDigit($x, $y + $i, "Elixir")
	$Elixir &= getDigit($x, $y + $i, "Elixir")
	Return $Elixir
EndFunc   ;==>getElixir
