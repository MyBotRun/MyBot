; _NumberFormat

Func _NumberFormat($Number = "") ; pad numbers with spaces as thousand separator

	If $Number = "" then Return ""

	If StringLeft($Number, 1) = "-" Then
		Return "- " & StringRegExpReplace(StringTrimLeft($Number, 1), "(\A\d{1,3}(?=(\d{3})+\z)|\d{3}(?=\d))", "\1 ")
	Else
		Return StringRegExpReplace($Number, "(\A\d{1,3}(?=(\d{3})+\z)|\d{3}(?=\d))", "\1 ")
	EndIf

EndFunc
