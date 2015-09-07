Func _PadStringCenter($String = "", $Width = 50, $PadChar = "=")

	If $String = "" Then Return ""

	Local $Odd = Mod(($Width - StringLen($String)), 2)
	Local $Count = ($Width - StringLen($String)) / 2
	Local $Pad = ""

	For $i = 0 To $Count - 1
		$Pad &= $PadChar
	Next

	If $Odd Then
		$Out = $Pad & $String & $Pad & $PadChar ; Odd
	Else
		$Out = $Pad & $String & $Pad ; Even
	EndIf

	Return $Out

EndFunc   ;==>_PadStringCenter
