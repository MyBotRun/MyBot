#cs ----------------------------------------------------------------------------
	AutoIt Version: 3.3.6.1
	This file was made to software CoCgameBot v3.0
	Author:         sardo
	Script Function: getDigitProfile()
	CoCgameBot is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or any later version.
	CoCgameBot is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty;of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
	You should have received a copy of the GNU General Public License along with CoCgameBot.  If not, see ;<[url=http://www.gnu.org/licenses/]http://www.gnu.org/licenses/[/url]>.
#ce ----------------------------------------------------------------------------
;==============================================================================================================
;===Get Digit Profile==========================================================================================
;--------------------------------------------------------------------------------------------------------------
;Finds pixel color pattern of specific X and Y values, returns digit if pixel color pattern found.
;--------------------------------------------------------------------------------------------------------------
Func getDigitProfile(ByRef $x, $y, $type)
	Local $width = 0
	;Search for digit 0
	$width = 9
	Select
		Case $type = "MyProfile"
			Local $c1 = Hex(0x3a3e41, 6), $c2 = Hex(0x616362, 6), $c3 = Hex(0x3d4144, 6)
	EndSelect
	For $i = 0 To 1
		Local $pixel1[3] = [$x + 2, $y + 1, $c1], $pixel2[3] = [$x + 2, $y + 5, $c2], $pixel3[3] = [$x + 5, $y + 8, $c3]
		If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
			$x += $width ;Adds to x coordinate to get the next digit
			Return "0"
		Else
			$x -= 1 ;Solves the problem when the spaces between the middle goes from 6 to 5 pixels
			Local $pixel1[3] = [$x + 2, $y + 1, $c1], $pixel2[3] = [$x + 2, $y + 5, $c2], $pixel3[3] = [$x + 5, $y + 8, $c3]
			If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
				$x += $width ;Changes x coordinate for the next digit.
				Return "0"
			Else
				$x += 2 ;Solves the problem when there is 1 pixel space between a set of numbers
				Local $pixel1[3] = [$x + 2, $y + 1, $c1], $pixel2[3] = [$x + 2, $y + 5, $c2], $pixel3[3] = [$x + 5, $y + 8, $c3]
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
		Case $type = "MyProfile"
			Local $c1 = Hex(0x43484c, 6), $c2 = Hex(0x7b848d, 6), $c3 = Hex(0x58626c, 6)
	EndSelect
	For $i = 0 To 2
		Local $pixel1[3] = [$x + 1, $y + 1, $c1], $pixel2[3] = [$x + 1, $y + 6, $c2], $pixel3[3] = [$x + 2, $y + 9, $c3]
		If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
			$x += $width
			Return 1
		Else
			$x -= 1
			Local $pixel1[3] = [$x + 1, $y + 1, $c1], $pixel2[3] = [$x + 1, $y + 6, $c2], $pixel3[3] = [$x + 2, $y + 9, $c3]
			If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
				$x += $width
				Return 1
			Else
				$x += 2
				Local $pixel1[3] = [$x + 1, $y + 1, $c1], $pixel2[3] = [$x + 1, $y + 6, $c2], $pixel3[3] = [$x + 2, $y + 9, $c3]
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
		Case $type = "MyProfile"
			Local $c1 = Hex(0x9ba4ae, 6), $c2 = Hex(0xa5afba, 6), $c3 = Hex(0x4b4d4f, 6)
	EndSelect
	For $i = 0 To 5
		Local $pixel1[3] = [$x + 1, $y + 4, $c1], $pixel2[3] = [$x + 3, $y + 2, $c2], $pixel3[3] = [$x + 3, $y + 8, $c3]
		If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
			$x += $width
			Return 2
		Else
			$x -= 1
			Local $pixel1[3] = [$x + 1, $y + 4, $c1], $pixel2[3] = [$x + 3, $y + 2, $c2], $pixel3[3] = [$x + 3, $y + 8, $c3]
			If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
				$x += $width
				Return 2
			Else
				$x += 2
				Local $pixel1[3] = [$x + 1, $y + 4, $c1], $pixel2[3] = [$x + 3, $y + 2, $c2], $pixel3[3] = [$x + 3, $y + 8, $c3]
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
		Case $type = "MyProfile"
			Local $c1 = Hex(0x4a4e4f, 6), $c2 = Hex(0x818b95, 6), $c3 = Hex(0x525b64, 6)
	EndSelect
	For $i = 0 To 8
		Local $pixel1[3] = [$x + 6, $y + 1, $c1], $pixel2[3] = [$x + 3, $y + 8, $c2], $pixel3[3] = [$x + 4, $y + 9, $c3]
		If boolPixelSearch($pixel1, $pixel2, $pixel3, 8) Then
			$x += $width
			Return 3
		Else
			$x -= 1
			Local $pixel1[3] = [$x + 6, $y + 1, $c1], $pixel2[3] = [$x + 3, $y + 8, $c2], $pixel3[3] = [$x + 4, $y + 9, $c3]
			If boolPixelSearch($pixel1, $pixel2, $pixel3, 8) Then
				$x += $width
				Return 3
			Else
				$x += 2
				Local $pixel1[3] = [$x + 6, $y + 1, $c1], $pixel2[3] = [$x + 3, $y + 8, $c2], $pixel3[3] = [$x + 4, $y + 9, $c3]
				If boolPixelSearch($pixel1, $pixel2, $pixel3, 8) Then
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
		Case $type = "MyProfile"
			Local $c1 = Hex(0x343539, 6), $c2 = Hex(0x414246, 6), $c3 = Hex(0xacb3b9, 6)
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
			Case $type = "MyProfile"
				Local $c1 = Hex(0x676c70, 6), $c2 = Hex(0x9fa4a7, 6), $c3 = Hex(0x828b90, 6)
		EndSelect
		Local $pixel1[3] = [$x + 3, $y + 2, $c1], $pixel2[3] = [$x + 4, $y + 8, $c2], $pixel3[3] = [$x + 6, $y + 9, $c3]
		If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
			$x += $width
			Return 5
		Else
			$x -= 1
			Local $pixel1[3] = [$x + 3, $y + 2, $c1], $pixel2[3] = [$x + 4, $y + 8, $c2], $pixel3[3] = [$x + 6, $y + 9, $c3]
			If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
				$x += $width
				Return 5
			Else
				$x += 2
				Local $pixel1[3] = [$x + 3, $y + 2, $c1], $pixel2[3] = [$x + 4, $y + 8, $c2], $pixel3[3] = [$x + 6, $y + 9, $c3]
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
	$width = 9
	Select
		Case $type = "MyProfile"
			Local $c1 = Hex(0x838b92, 6), $c2 = Hex(0x6c7176, 6), $c3 = Hex(0x9fa9b4, 6)
	EndSelect
	Local $pixel1[3] = [$x + 6, $y + 1, $c1], $pixel2[3] = [$x + 5, $y + 6, $c2], $pixel3[3] = [$x + 6, $y + 9, $c3]
	If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
		$x += $width
		Return 6
	Else
		$x -= 1
		Local $pixel1[3] = [$x + 6, $y + 1, $c1], $pixel2[3] = [$x + 5, $y + 6, $c2], $pixel3[3] = [$x + 6, $y + 9, $c3]
		If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
			$x += $width
			Return 6
		Else
			$x += 2
			Local $pixel1[3] = [$x + 6, $y + 1, $c1], $pixel2[3] = [$x + 5, $y + 6, $c2], $pixel3[3] = [$x + 6, $y + 9, $c3]
			If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
				$x += $width
				Return 6
			Else
				$x -= 1
			EndIf
		EndIf
	EndIf
	;Search for digit 7
	$width = 7
	Select
		Case $type = "MyProfile"
			Local $c1 = Hex(0x9da7b0, 6), $c2 = Hex(0x6d7277, 6), $c3 = Hex(0x4f5254, 6)
	EndSelect
	Local $pixel1[3] = [$x + 4, $y + 7, $c1], $pixel2[3] = [$x + 2, $y + 2, $c2], $pixel3[3] = [$x + 3, $y + 1, $c3]
	If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
		$x += $width
		Return 7
	Else
		$x -= 1
		Local $pixel1[3] = [$x + 4, $y + 7, $c1], $pixel2[3] = [$x + 2, $y + 2, $c2], $pixel3[3] = [$x + 3, $y + 1, $c3]
		If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
			$x += $width
			Return 7
		Else
			$x += 2
			Local $pixel1[3] = [$x + 4, $y + 7, $c1], $pixel2[3] = [$x + 2, $y + 2, $c2], $pixel3[3] = [$x + 3, $y + 1, $c3]
			If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
				$x += $width
				Return 7
			Else
				$x -= 1
			EndIf
		EndIf
	EndIf
	;Search for digit 8
	$width = 8
	Select
		Case $type = "MyProfile"
			Local $c1 = Hex(0x7f868c, 6), $c2 = Hex(0x89909a, 6), $c3 = Hex(0x97a0a7, 6)
	EndSelect
	Local $pixel1[3] = [$x + 5, $y + 2, $c1], $pixel2[3] = [$x + 7, $y + 6, $c2], $pixel3[3] = [$x + 1, $y + 5, $c3]
	If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
		$x += $width
		Return 8
	Else
		$x -= 1
		Local $pixel1[3] = [$x + 5, $y + 2, $c1], $pixel2[3] = [$x + 7, $y + 6, $c2], $pixel3[3] = [$x + 1, $y + 5, $c3]
		If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
			$x += $width
			Return 8
		Else
			$x += 2
			Local $pixel1[3] = [$x + 5, $y + 2, $c1], $pixel2[3] = [$x + 7, $y + 6, $c2], $pixel3[3] = [$x + 1, $y + 5, $c3]
			If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
				$x += $width
				Return 8
			Else
				$x -= 1
			EndIf
		EndIf
	EndIf
	;Search for digit 9
	$width = 8
	Select
		Case $type = "MyProfile"
			Local $c1 = Hex(0x8d97a0, 6), $c2 = Hex(0x0646c77, 6), $c3 = Hex(0xb2becc, 6)
	EndSelect
	Local $pixel1[3] = [$x + 5, $y + 3, $c1], $pixel2[3] = [$x + 5, $y + 9, $c2], $pixel3[3] = [$x + 6, $y + 9, $c3]
	If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
		$x += $width
		Return 9
	Else
		$x -= 1
		Local $pixel1[3] = [$x + 5, $y + 3, $c1], $pixel2[3] = [$x + 5, $y + 9, $c2], $pixel3[3] = [$x + 6, $y + 9, $c3]
		If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
			$x += $width
			Return 9
		Else
			$x += 2
			Local $pixel1[3] = [$x + 5, $y + 3, $c1], $pixel2[3] = [$x + 5, $y + 9, $c2], $pixel3[3] = [$x + 6, $y + 9, $c3]
			If boolPixelSearch($pixel1, $pixel2, $pixel3, 7) Then
				$x += $width
				Return 9
			Else
				$x -= 1
			EndIf
		EndIf
	EndIf
	Return ""
EndFunc   ;==>getDigitProfile
