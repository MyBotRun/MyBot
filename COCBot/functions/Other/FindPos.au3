Func FindPos()
	getBSPos()
	Local $Pos[2]
	While 1
		If _IsPressed("01") Then
			$Pos[0] = MouseGetPos()[0] - $BSpos[0]
			$Pos[1] = MouseGetPos()[1] - $BSpos[1]
			Return $Pos
		EndIf
	WEnd
EndFunc   ;==>FindPos