
; #FUNCTION# ====================================================================================================================
; Name ..........: _GetOffsetTroopFurther
; Description ...:
; Syntax ........: _GetOffsetTroopFurther($pixel, $eVectorType, $offset)
; Parameters ....: $pixel               - a pointer value.
;                  $eVectorType         - an unknown value.
;                  $offset              - an object.
; Return values .: None
; Author ........: didipe
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _GetOffsetTroopFurther($pixel, $eVectorType, $offset)
	debugRedArea("_GetOffsetTroopFurther IN")
	Local $xMin, $xMax, $yMin, $yMax, $xStep, $yStep, $xOffset, $yOffset
	Local $vectorRedArea[0]
	Local $pixelOffset = GetOffestPixelRedArea2($pixel, $eVectorType, $offset)
	If ($eVectorType = $eVectorLeftTop) Then
		$xMin = 80
		$xMax = 430
		$yMin = 338
		$yMax = 73
		$xStep = 4
		$yStep = -3
		$yOffset = -1 * $offset
		$xOffset = Floor($yOffset)
	ElseIf ($eVectorType = $eVectorRightTop) Then
		$xMin = 430
		$xMax = 780
		$yMin = 73
		$yMax = 338
		$xStep = 4
		$yStep = 3
		$yOffset = -1 * $offset
		$xOffset = Floor($yOffset) * -1
	ElseIf ($eVectorType = $eVectorLeftBottom) Then
		$xMin = 80
		$xMax = 430
		$yMin = 338
		$yMax = 600
		$xStep = 4
		$yStep = 3
		$yOffset = $offset
		$xOffset = Floor($yOffset) * -1
	Else
		$xMin = 430
		$xMax = 780
		$yMin = 600
		$yMax = 338
		$xStep = 4
		$yStep = -3
		$yOffset = $offset
		$xOffset = Floor($yOffset)
	EndIf



	Local $y = $yMin
	Local $found = False
	For $x = $xMin To $xMax Step $xStep
		If ($eVectorType = $eVectorRightBottom And $y > $yMax And $pixelOffset[0] > $x And $pixelOffset[1] > $y) Then
			$pixelOffset[0] = $x + $xOffset
			$pixelOffset[1] = $y + $yOffset
			$found = True
		ElseIf ($eVectorType = $eVectorLeftBottom And $y < $yMax And $pixelOffset[0] < $x And $pixelOffset[1] > $y) Then
			$pixelOffset[0] = $x + $xOffset
			$pixelOffset[1] = $y + $yOffset
			$found = True
		ElseIf ($eVectorType = $eVectorLeftTop And $y > $yMax And $pixelOffset[0] < $x And $pixelOffset[1] < $y) Then
			$pixelOffset[0] = $x + $xOffset
			$pixelOffset[1] = $y + $yOffset

			$found = True
		ElseIf ($eVectorType = $eVectorRightTop And $y < $yMax And $pixelOffset[0] > $x And $pixelOffset[1] < $y) Then
			$pixelOffset[0] = $x + $xOffset
			$pixelOffset[1] = $y + $yOffset
			$found = True
		EndIf

		$y += $yStep
		If ($found) Then ExitLoop
	Next
	; Not select pixel in menu of troop
	If $pixelOffset[1] > 547 + $bottomOffsetY Then
		$pixelOffset[1] = 547 + $bottomOffsetY
	EndIf
	debugRedArea("$pixelOffset x : [" & $pixelOffset[0] & "] / y : [" & $pixelOffset[1] & "]")

	Return $pixelOffset
EndFunc   ;==>_GetOffsetTroopFurther
