; #FUNCTION# ====================================================================================================================
; Name ..........: getDigit.au3
; Description ...: Finds pixel color pattern of specific X and Y values
; Syntax ........: getDigit(ByRef $x, $y, $type)
; Parameters ....:
; Return values .: returns digit if pixel color pattern found.
; Author ........:
; Modified ......: KnowJack (April/June-2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func getDigit(ByRef $x, $y, $type)
	Local $digitWidth[11] = [13, 6, 10, 10, 12, 10, 11, 21, 10, 11, 11]
	Local $digitNumber[11] = ["0", 1, 2, 3, 4, 5, 6, 74, 7, 8, 9]
	Local $digitOffset[11][3][2] = _
		[[[6, 4], [7, 7], [10, 13]], [[1, 1], [1, 12], [4, 12]], _	;0, 1
		[[1, 7], [3, 6], [7, 7]], [[2, 3], [4, 8], [5, 13]], _		;2, 3
		[[2, 3], [3, 1], [1, 5]], [[5, 4], [4, 9], [6, 12]], _		;4, 5
		[[5, 4], [5, 9], [8, 5]], [[13, 7], [7, 7], [1, 12]], _		;6, 74
		[[5, 11], [4, 3], [7, 7]], [[5, 3], [5, 10], [1, 6]], _		;7, 8
		[[5, 5], [5, 9], [8, 12]]]									;9
	Switch $type
		Case "Gold"
			Local $digitColor[11][3] = _
				[[0x989579, 0x39382E, 0x272720], [0x979478, 0x313127, 0xD7D4AC], _ 	;0, 1
				[0xA09E80, 0xD8D4AC, 0x979579], [0x7F7D65, 0x070706, 0x37362C], _	;2, 3
				[0x282720, 0x080806, 0x403F33], [0x060604, 0x040403, 0xB7B492], _	;4, 5
				[0x070605, 0x040403, 0x181713], [0x414034, 0x4C4B3D, 0xD3D0A9], _	;6, 74
				[0x5E5C4B, 0x87856C, 0x5D5C4B], [0x27261F, 0x302F26, 0x26261F], _	;7, 8
				[0x302F26, 0x050504, 0x272720]]										;9
		Case "Elixir"
			Local $digitColor[11][3] = _
				[[0x978A96, 0x393439, 0x272427], [0x968895, 0x312D31, 0xD8C4D6], _ 	;0, 1
				[0xA0919F, 0xD8C4D6, 0x978A96], [0x7F737E, 0x070607, 0x373236], _	;2, 3
				[0x282428, 0x080708, 0x403A40], [0x060606, 0x040404, 0xB7A7B6], _	;4, 5
				[0x070707, 0x040404, 0x181618], [0x413E38, 0x4C4941, 0xD3CEAB], _	;6, 74
				[0x5F565E, 0x877B86, 0x5F565E], [0x272427, 0x302B2F, 0x26261F], _	;7, 8
				[0x302C30, 0x050505, 0x282427]]										;9
		Case "DarkElixir"
			Local $digitColor[11][3] = _
				[[0x909090, 0x363636, 0x262626], [0x8F8F8F, 0x2F2F2F, 0xCDCDCD], _ 	;0, 1
				[0x989898, 0xCDCDCD, 0x909090], [0x797979, 0x070707, 0x343434], _	;2, 3
				[0x262626, 0x070707, 0x3D3D3D], [0x060606, 0x040404, 0xAFAFAF], _	;4, 5
				[0x060606, 0x030303, 0x161616], [0x3F3F3F, 0x4A4A4A, 0xD1D1D1], _	;6, 74
				[0x5A5A5A, 0x818181, 0x5A5A5A], [0x252525, 0x2D2D2D, 0x242424], _	;7, 8
				[0x2E2E2E, 0x050505, 0x262626]]										;9
		Case "Builder"
			Local $digitColor[11][3] = _
				[[0x979797, 0x373737, 0x262626], [0x969696, 0x313131, 0xD8D8D8], _ 	;0, 1
				[0xA0A0A0, 0xD8D8D8, 0x979797], [0x7F7F7F, 0x070707, 0x373737], _	;2, 3
				[0x282828, 0x080808, 0x404040], [0x060606, 0x040404, 0xB7B7B7], _	;4, 5
				[0x070707, 0x040404, 0x181818], [0x414141, 0x4C4C4C, 0xD3D3D3], _	;6, 74
				[0x5F5F5F, 0x878787, 0x5F5F5F], [0x272727, 0x303030, 0x262626], _	;7, 8
				[0x303030, 0x050505, 0x272727]]										;9
		Case "Resource"
			Local $digitColor[11][3] = _
				[[0x919191, 0x373737, 0x272727], [0x959098, 0x312f31, 0xD4CCD7], _ 	;0, 1
				[0x9E99A0, 0xD3D3D3, 0x919191], [0x7A7A7A, 0x070707, 0x373737], _	;2, 3
				[0x282828, 0x080808, 0x404040], [0x060606, 0x040404, 0xB7B7B7], _	;4, 5
				[0x070707, 0x040404, 0x181818], [0x414141, 0x4C4C4C, 0xD3D3D3], _	;6, 74
				[0x5F5F5F, 0x878787, 0x5F5F5F], [0x272727, 0x303030, 0x262626], _	;7, 8
				[0x303030, 0x050505, 0x272727]]										;9
		Case "Upgrades"
			Local $digitColor[11][3] = _
				[[0x919191, 0x373737, 0x272727], [0x979797, 0x313131, 0xD7D7D7], _ 	;0, 1
				[0x9E99A0, 0xD3D3D3, 0x919191], [0x7A7A7A, 0x070707, 0x373737], _	;2, 3
				[0x282828, 0x080808, 0x404040], [0x060606, 0x040404, 0xB7B7B7], _	;4, 5
				[0x070707, 0x040404, 0x181818], [0x414141, 0x4C4C4C, 0xD3D3D3], _	;6, 74
				[0x5F5F5F, 0x878787, 0x5F5F5F], [0x272727, 0x303030, 0x262626], _	;7, 8
				[0x303030, 0x050505, 0x272727]]										;9
		Case "RedUpgrades"
			Local $digitColor[11][3] = _
				 [[0x89060B, 0x340204, 0x230103], [0x89060B, 0x2D0203, 0xC3080F], _  ;0, 1
				 [0x90060B, 0xC3080F, 0x89060B], [0x730509, 0x060000, 0x320204], _   ;2, 3
				 [0x240203, 0x070000, 0x3A0204], [0x060000, 0x040000, 0xA6070D], _  ;4, 5
				 [0x060000, 0x030000, 0x150102], [0x97070C, 0x550407, 0xC0080F], _ 	;6, 74
				 [0x550407, 0x7A050A, 0x550407], [0x240203, 0x2C0203, 0x220103], _   ;7, 8
				 [0x2B0203, 0x040000, 0x240103]]  									;9
		Case Else
			Local $digitColor[11][3] = _
				[[0x979797, 0x393939, 0x272727], [0x969696, 0x313131, 0xD8D8D8], _ 	;0, 1
				[0xA0A0A0, 0xD8D8D8, 0x979797], [0x7F7F7F, 0x070707, 0x373737], _	;2, 3
				[0x282828, 0x080808, 0x404040], [0x060606, 0x040404, 0xB7B7B7], _	;4, 5
				[0x070707, 0x040404, 0x181818], [0x414141, 0x4C4C4C, 0xD3D3D3], _	;6, 74
				[0x5F5F5F, 0x878787, 0x5F5F5F], [0x272727, 0x303030, 0x262626], _	;7, 8
				[0x303030, 0x050505, 0x272727]]										;9
	EndSwitch

	For $i = 0 to 10
		For $z = -1 to 1
			$x += $z
			Local $pixel1[3] = [$x + $digitOffset[$i][0][0], $y + $digitOffset[$i][0][1], Hex($digitColor[$i][0], 6)]
			Local $pixel2[3] = [$x + $digitOffset[$i][1][0], $y + $digitOffset[$i][1][1], Hex($digitColor[$i][1], 6)]
			Local $pixel3[3] = [$x + $digitOffset[$i][2][0], $y + $digitOffset[$i][2][1], Hex($digitColor[$i][2], 6)]
			If boolPixelSearch($pixel1, $pixel2, $pixel3) Then
				$x += $digitWidth[$i]
				Return $digitNumber[$i]
			EndIf
			$x -= $z
		Next
	Next

	Return ""
EndFunc