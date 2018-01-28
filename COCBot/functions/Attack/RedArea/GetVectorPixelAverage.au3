
; #FUNCTION# ====================================================================================================================
; Name ..........: GetVectorPixelAverage
; Description ...:
; Syntax ........: GetVectorPixelAverage($arrPixel, $vectorDirection)
; Parameters ....: $arrPixel            - an array of unknowns.
;                  $vectorDirection     - a variant value.
; Return values .: None
; Author ........: didipe
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func GetVectorPixelAverage($arrPixel, $vectorDirection)
	Local $vectorPixelAverage[1]
	debugRedArea("GetVectorPixelAverage IN $vectorDirection [" & $vectorDirection & "]")
	If (UBound($arrPixel) > 1) Then
		Local $pixelSearch[2] = [-1, -1]
		Local $minPixel = $arrPixel[0]
		Local $maxPixel = $arrPixel[UBound($arrPixel) - 1]
		Local $min = $minPixel[$vectorDirection]
		Local $max = $maxPixel[$vectorDirection]
		Local $posAverage = ($max - $min) / 2
		debugRedArea("GetVectorPixelAverage IN $min [" & $min & "]")
		debugRedArea("GetVectorPixelAverage IN $max [" & $max & "]")

		$pixelSearch[$vectorDirection] = $min + $posAverage
		debugRedArea("GetVectorPixelAverage $pixelSearch x : [" & $pixelSearch[0] & "] / y [" & $pixelSearch[1] & "] ")
		Local $arrPixelCloser = _FindPixelCloser($arrPixel, $pixelSearch, 1)
		Local $arrTemp = $arrPixelCloser[0]
		debugRedArea("GetVectorPixelAverage $arrTemp x : [" & $arrTemp[0] & "] / y [" & $arrTemp[1] & "] ")
		$vectorPixelAverage[0] = $arrPixelCloser[0]


	EndIf
	Return $vectorPixelAverage
EndFunc   ;==>GetVectorPixelAverage
