; #FUNCTION# ====================================================================================================================
; Name ..........: GetVectorPixelToDeploy
; Description ...:
; Syntax ........: GetVectorPixelToDeploy($arrPixel, $vectorDirection, $sizeVector)
; Parameters ....: $arrPixel            - Array of pixel where troop are deploy
;                  $vectorDirection     - The vector direction => 0 = Left To Right (x asc) / 1 = Top to Bottom (y asc)
;                  $sizeVector          - Number of pixel for the vector
; Return values .: vector of pixel
; Author ........: didipe
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
; Strategy :
; 			Get min / max pixel of array pixel
;			Get min / max value of x or y (depends vector direction)
;			Get the offset to browse the array pixel (depends of size vector)
;			For min to max with offset , get pixel closer and add to the vector

Func GetVectorPixelToDeploy($arrPixel, $vectorDirection, $sizeVector)
	Local $vectorPixel[0]
	debugRedArea("GetVectorPixelToDeploy IN")
	debugRedArea("size " & UBound($arrPixel))
	If (UBound($arrPixel) > 1) Then
		Local $pixelSearch[2] = [-1, -1]
		Local $minPixel = $arrPixel[0]
		Local $maxPixel = $arrPixel[UBound($arrPixel) - 1]
		Local $min = $minPixel[$vectorDirection]
		Local $max = $maxPixel[$vectorDirection]
		Local $offset = ($max - $min) / $sizeVector
		debugRedArea("min : [" & $min & "] / max [" & $max & "] / offset [" & $offset & "]")
		If ($min <= $max And $offset <= 0) Then
			$offset = 1
		ElseIf ($min >= $max And $offset >= 0) Then
			$offset = -1
		EndIf
		For $i = $min To $max Step $offset
			$pixelSearch[$vectorDirection] = $i
			Local $arrPixelCloser = _FindPixelCloser($arrPixel, $pixelSearch, 1)
			ReDim $vectorPixel[UBound($vectorPixel) + 1]
			$vectorPixel[UBound($vectorPixel) - 1] = $arrPixelCloser[0]
		Next

	EndIf
	Return $vectorPixel
EndFunc   ;==>GetVectorPixelToDeploy
