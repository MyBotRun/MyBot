
; #FUNCTION# ====================================================================================================================
; Name ..........: _MultiPixelSearch
; Description ...: Uses multiple pixels with coordinates of each color in a certain region, works for memory BMP
; Syntax ........: _MultiPixelSearch($iLeft, $iTop, $iRight, $iBottom, $xSkip, $ySkip, $firstColor, $offColor, $iColorVariation)
; 						$xSkip and $ySkip for numbers of pixels skip
;						$offColor[2][COLOR/OFFSETX/OFFSETY] offset relative to firstColor coordination
; Parameters ....: $iLeft               - an integer value.
;                  $iTop                - an integer value.
;                  $iRight              - an integer value.
;                  $iBottom             - an integer value.
;                  $xSkip               - an unknown value.
;                  $ySkip               - an unknown value.
;                  $firstColor          - 1st pixel to find
;                  $offColor            - array of pixel location, and color
;                  $iColorVariation     - an integer value.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
; rotate y first, x second: search in columns
Func _MultiPixelSearch($iLeft, $iTop, $iRight, $iBottom, $xSkip, $ySkip, $firstColor, $offColor, $iColorVariation)
	_CaptureRegion($iLeft, $iTop, $iRight, $iBottom)
	For $x = 0 To $iRight - $iLeft Step $xSkip
		For $y = 0 To $iBottom - $iTop Step $ySkip
			If _ColorCheck(_GetPixelColor($x, $y), $firstColor, $iColorVariation) Then
				Local $allchecked = True
				For $i = 0 To UBound($offColor) - 1
					If _ColorCheck(_GetPixelColor($x + $offColor[$i][1], $y + $offColor[$i][2]), Hex($offColor[$i][0], 6), $iColorVariation) = False Then
						$allchecked = False
						ExitLoop
					EndIf
				Next
				If $allchecked Then
					Local $Pos[2] = [$iLeft + $x, $iTop + $y]
					Return $Pos
				EndIf
			EndIf
		Next
	Next
	Return 0
EndFunc   ;==>_MultiPixelSearch

; rotate x first, y second: search in rows
Func _MultiPixelSearch2($iLeft, $iTop, $iRight, $iBottom, $xSkip, $ySkip, $firstColor, $offColor, $iColorVariation)
	_CaptureRegion($iLeft, $iTop, $iRight, $iBottom)
	For $y = 0 To $iBottom - $iTop Step $ySkip
		For $x = 0 To $iRight - $iLeft Step $xSkip
			If _ColorCheck(_GetPixelColor($x, $y), $firstColor, $iColorVariation) Then
				Local $allchecked = True
				For $i = 0 To UBound($offColor) - 1
					If _ColorCheck(_GetPixelColor($x + $offColor[$i][1], $y + $offColor[$i][2]), Hex($offColor[$i][0], 6), $iColorVariation) = False Then
						$allchecked = False
						ExitLoop
					EndIf
				Next
				If $allchecked Then
					Local $Pos[2] = [$iLeft + $x, $iTop + $y]
					Return $Pos
				EndIf
			EndIf
		Next
	Next
	Return 0
EndFunc   ;==>_MultiPixelSearch2

Func WaitforPixel($iLeft, $iTop, $iRight, $iBottom, $firstColor, $iColorVariation, $maxDelay = 10) ; $maxDelay is in 1/2 second
	For $i = 1 To $maxDelay * 10
		$result = _PixelSearch($iLeft, $iTop, $iRight, $iBottom, $firstColor, $iColorVariation)
		If IsArray($result) Then Return True
		If _Sleep(50) Then Return
	Next
	Return False
EndFunc   ;==>_WaitForPixel
