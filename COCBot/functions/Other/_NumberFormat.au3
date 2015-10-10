; _NumberFormat
; Modified by kaganus (August 2015)

Func _NumberFormat($Number, $NullToZero = False) ; pad numbers with spaces as thousand separator

	If $Number = "" Then
		If $NullToZero = False Then
			Return ""
		Else
			Return "0"
		EndIf
	EndIf

	If StringLeft($Number, 1) = "-" Then
		Return "- " & StringRegExpReplace(StringTrimLeft($Number, 1), "(\A\d{1,3}(?=(\d{3})+\z)|\d{3}(?=\d))", "\1 ")
	Else
		Return StringRegExpReplace($Number, "(\A\d{1,3}(?=(\d{3})+\z)|\d{3}(?=\d))", "\1 ")
	EndIf

EndFunc
