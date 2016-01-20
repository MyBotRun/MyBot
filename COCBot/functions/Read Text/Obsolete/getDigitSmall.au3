;==============================================================================================================
;===Get Digit Small=============================================================================================
;--------------------------------------------------------------------------------------------------------------
;Finds pixel color pattern of specific X and Y values, returns digit if pixel color pattern found.
;--------------------------------------------------------------------------------------------------------------

Func getDigitSmall(ByRef $x, $y, $type)
    Local $width = 0

    ;Search for digit 0
    $width = 10
   Select
	 Case $type = "Camp"
		 Local $c1 = Hex(0x979797, 6), $c2 = Hex(0x050505, 6), $c3 = Hex(0xD8D8D8, 6)
	  EndSelect

   For $i = 0 To 1
	Local $pixel1[3] = [$x + 5, $y + 3, $c1], $pixel2[3] = [$x + 5, $y + 4, $c2], $pixel3[3] = [$x + 6, $y + 8, $c3]
	If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
		$x += $width ;Adds to x coordinate to get the next digit
		Return "0"
	Else
		$x -= 1 ;Solves the problem when the spaces between the middle goes from 6 to 5 pixels
		Local $pixel1[3] = [$x + 5, $y + 3, $c1], $pixel2[3] = [$x + 5, $y + 4, $c2], $pixel3[3] = [$x + 6, $y + 8, $c3]
		If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
			$x += $width ;Changes x coordinate for the next digit.
			Return "0"
		Else
			$x += 2 ;Solves the problem when there is 1 pixel space between a set of numbers
			Local $pixel1[3] = [$x + 5, $y + 3, $c1], $pixel2[3] = [$x + 5, $y + 4, $c2], $pixel3[3] = [$x + 6, $y + 8, $c3]
			If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
				$x += $width
				Return "0"
			Else
				$x -= 1
			EndIf
		EndIf
	 EndIf
	 If $i = 0 Then $x -= 1
	 Next
   $x += 1

    ;Search for digit 1
    $width = 4
    Select
        Case $type = "Camp"
            Local $c1 = Hex(0xBEBEBE, 6), $c2 = Hex(0x9C9C9C, 6), $c3 = Hex(0x070707, 6)
		 EndSelect
   For $i = 0 To 1
    Local $pixel1[3] = [$x + 1, $y + 3, $c1], $pixel2[3] = [$x + 1, $y + 9, $c2], $pixel3[3] = [$x + 2, $y + 10, $c3]
    If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
        $x += $width
        Return 1
    Else
        $x -= 1
        Local $pixel1[3] = [$x + 1, $y + 3, $c1], $pixel2[3] = [$x + 1, $y + 9, $c2], $pixel3[3] = [$x + 2, $y + 10, $c3]
        If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
            $x += $width
            Return 1
        Else
            $x += 2
            Local $pixel1[3] = [$x + 1, $y + 3, $c1], $pixel2[3] = [$x + 1, $y + 9, $c2], $pixel3[3] = [$x + 2, $y + 10, $c3]
            If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
                $x += $width
                Return 1
            Else
                $x -= 1
            EndIf
        EndIf
    EndIf
	 If $i = 0 Then $x -= 1
	 Next
   $x += 1

    ;Search for digit 2
    $width = 8
    Select
        Case $type = "Camp"
            Local $c1 = Hex(0x000000, 6), $c2 = Hex(0xC7C7C7, 6), $c3 = Hex(0x9F9F9F, 6)
		 EndSelect
   For $i = 0 To 1
    Local $pixel1[3] = [$x + 1, $y + 4, $c1], $pixel2[3] = [$x + 3, $y + 2, $c2], $pixel3[3] = [$x + 3, $y + 7, $c3]
    If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
        $x += $width
        Return 2
    Else
        $x -= 1
        Local $pixel1[3] = [$x + 1, $y + 4, $c1], $pixel2[3] = [$x + 3, $y + 2, $c2], $pixel3[3] = [$x + 3, $y + 7, $c3]
        If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
            $x += $width
            Return 2
        Else
            $x += 2
            Local $pixel1[3] = [$x + 1, $y + 4, $c1], $pixel2[3] = [$x + 3, $y + 2, $c2], $pixel3[3] = [$x + 3, $y + 7, $c3]
            If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
                $x += $width
                Return 2
            Else
                $x -= 1
            EndIf
        EndIf
    EndIf
	 If $i = 0 Then $x -= 1
	 Next
   $x += 1

    ;Search for digit 3
    $width = 8
    Select
        Case $type = "Camp"
            Local $c1 = Hex(0xA1A1A1, 6), $c2 = Hex(0xF9F9F9, 6), $c3 = Hex(0x1E1E1E, 6)
		 EndSelect
   For $i = 0 To 1
    Local $pixel1[3] = [$x + 6, $y + 1, $c1], $pixel2[3] = [$x + 3, $y + 8, $c2], $pixel3[3] = [$x + 4, $y + 10, $c3]
    If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
        $x += $width
        Return 3
    Else
        $x -= 1
        Local $pixel1[3] = [$x + 6, $y + 1, $c1], $pixel2[3] = [$x + 3, $y + 8, $c2], $pixel3[3] = [$x + 4, $y + 10, $c3]
        If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
            $x += $width
            Return 3
        Else
            $x += 2
            Local $pixel1[3] = [$x + 6, $y + 1, $c1], $pixel2[3] = [$x + 3, $y + 8, $c2], $pixel3[3] = [$x + 4, $y + 10, $c3]
            If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
                $x += $width
                Return 3
            Else
                $x -= 1
            EndIf
        EndIf
    EndIf
	 If $i = 0 Then $x -= 1
	 Next
   $x += 1

	;Search for digit 4
	   $width = 9
	   Select
		   Case $type = "Camp"
			   Local $c1 = Hex(0xC9C9C9, 6), $c2 = Hex(0x202020, 6), $c3 = Hex(0x1E1E1E, 6)
			EndSelect
   For $i = 0 To 1
	   Local $pixel1[3] = [$x + 2, $y + 4, $c1], $pixel2[3] = [$x + 3, $y + 1, $c2], $pixel3[3] = [$x + 2, $y + 8, $c3]
	   If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
		   $x += $width
		   Return 4
	   Else
		   $x -= 1
		   Local $pixel1[3] = [$x + 2, $y + 4, $c1], $pixel2[3] = [$x + 3, $y + 1, $c2], $pixel3[3] = [$x + 2, $y + 8, $c3]
		   If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
			   $x += $width
			   Return 4
		   Else
			   $x += 2
			   Local $pixel1[3] = [$x + 2, $y + 4, $c1], $pixel2[3] = [$x + 3, $y + 1, $c2], $pixel3[3] = [$x + 2, $y + 8, $c3]
			   If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
				   $x += $width
				   Return 4
			   Else
				   $x -= 1
			   EndIf
		   EndIf
		EndIf
		If $i = 0 Then $x -= 3
    Next
    $x += 3

	;Search for digit 5
	For $i = 0 To 1
	$width = 8
	Select
		Case $type = "Camp"
			Local $c1 = Hex(0xE8E8E8, 6), $c2 = Hex(0x242424, 6), $c3 = Hex(0x9F9F9F, 6)
	EndSelect
	Local $pixel1[3] = [$x + 5, $y + 2, $c1], $pixel2[3] = [$x + 4, $y + 7, $c2], $pixel3[3] = [$x + 6, $y + 9, $c3]
	If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
		$x += $width
		Return 5
	Else
		$x -= 1
		Local $pixel1[3] = [$x + 5, $y + 2, $c1], $pixel2[3] = [$x + 4, $y + 7, $c2], $pixel3[3] = [$x + 6, $y + 9, $c3]
		If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
			$x += $width
			Return 5
		Else
			$x += 2
			Local $pixel1[3] = [$x + 5, $y + 2, $c1], $pixel2[3] = [$x + 4, $y + 7, $c2], $pixel3[3] = [$x + 6, $y + 9, $c3]
			If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
				$x += $width
				Return 5
			Else
				$x -= 1
			EndIf
		EndIf
	EndIf
		If $i = 0 Then $x -= 3
    Next
    $x += 3

	;Search for digit 6
	$width = 8
	Select
		Case $type = "Camp"
			Local $c1 = Hex(0xAFAFAF, 6), $c2 = Hex(0x878787, 6), $c3 = Hex(0x070707, 6)
	EndSelect
	Local $pixel1[3] = [$x + 5, $y + 2, $c1], $pixel2[3] = [$x + 4, $y + 6, $c2], $pixel3[3] = [$x + 7, $y + 10, $c3]
	If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
		$x += $width
		Return 6
	Else
		$x -= 1
		Local $pixel1[3] = [$x + 5, $y + 2, $c1], $pixel2[3] = [$x + 4, $y + 6, $c2], $pixel3[3] = [$x + 7, $y + 10, $c3]
		If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
			$x += $width
			Return 6
		Else
			$x += 2
			Local $pixel1[3] = [$x + 5, $y + 2, $c1], $pixel2[3] = [$x + 4, $y + 6, $c2], $pixel3[3] = [$x + 7, $y + 10, $c3]
			If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
				$x += $width
				Return 6
			Else
				$x -= 1
			EndIf
		EndIf
	EndIf

	;Search for digit 7
	$width = 8
	Select
		Case $type = "Camp"
			Local $c1 = Hex(0xCFCFCF, 6), $c2 = Hex(0xAFAFAF, 6), $c3 = Hex(0xBFBFBF, 6)
	EndSelect
	Local $pixel1[3] = [$x + 4, $y + 7, $c1], $pixel2[3] = [$x + 2, $y + 2, $c2], $pixel3[3] = [$x + 3, $y + 2, $c3]
	If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
		$x += $width
		Return 7
	Else
		$x -= 1
		Local $pixel1[3] = [$x + 4, $y + 7, $c1], $pixel2[3] = [$x + 2, $y + 2, $c2], $pixel3[3] = [$x + 3, $y + 2, $c3]
		If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
			$x += $width
			Return 7
		Else
			$x += 2
			Local $pixel1[3] = [$x + 4, $y + 7, $c1], $pixel2[3] = [$x + 2, $y + 2, $c2], $pixel3[3] = [$x + 3, $y + 2, $c3]
			If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
				$x += $width
				Return 7
			Else
				$x -= 1
			EndIf
		EndIf
	EndIf

	;Search for digit 8
	$width = 9
	Select
		Case $type = "Camp"
			Local $c1 = Hex(0x6F6F6F, 6), $c2 = Hex(0x959595, 6), $c3 = Hex(0x7D7D7D, 6)
	EndSelect
	Local $pixel1[3] = [$x + 4, $y + 2, $c1], $pixel2[3] = [$x + 5, $y + 7, $c2], $pixel3[3] = [$x + 1, $y + 5, $c3]
	If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
		$x += $width
		Return 8
	Else
		$x -= 1
		Local $pixel1[3] = [$x + 4, $y + 2, $c1], $pixel2[3] = [$x + 5, $y + 7, $c2], $pixel3[3] = [$x + 1, $y + 5, $c3]
		If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
			$x += $width
			Return 8
		Else
			$x += 2
			Local $pixel1[3] = [$x + 4, $y + 2, $c1], $pixel2[3] = [$x + 5, $y + 7, $c2], $pixel3[3] = [$x + 1, $y + 5, $c3]
			If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
				$x += $width
				Return 8
			Else
				$x -= 1
			EndIf
		EndIf
	EndIf

	;Search for digit 9
	$width = 9
	Select
		Case $type = "Camp"
			Local $c1 = Hex(0x070707, 6), $c2 = Hex(0xAFAFAF, 6), $c3 = Hex(0x5F5F5F, 6)
	EndSelect
	Local $pixel1[3] = [$x + 4, $y + 3, $c1], $pixel2[3] = [$x + 5, $y + 9, $c2], $pixel3[3] = [$x + 6, $y + 9, $c3]
	If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
		$x += $width
		Return 9
	Else
		$x -= 1
		Local $pixel1[3] = [$x + 4, $y + 3, $c1], $pixel2[3] = [$x + 5, $y + 9, $c2], $pixel3[3] = [$x + 6, $y + 9, $c3]
		If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
			$x += $width
			Return 9
		Else
			$x += 2
			Local $pixel1[3] = [$x + 4, $y + 3, $c1], $pixel2[3] = [$x + 5, $y + 9, $c2], $pixel3[3] = [$x + 6, $y + 9, $c3]
			If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
				$x += $width
				Return 9
			Else
				$x -= 1
			EndIf
		EndIf
	EndIf

	Return ""
EndFunc   ;==>getDigit