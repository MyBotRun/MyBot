
; #FUNCTION# ====================================================================================================================
; Name ..........: GetVectorPixelOnEachSide
; Description ...:
; Syntax ........: GetVectorPixelOnEachSide($arrPixel, $vectorDirection)
; Parameters ....: $arrPixel            - an array of unknowns.
;                  $vectorDirection     - a variant value.
; Return values .: None
; Author ........:
; Modified ......: ProMac (07-2018)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;~ Func GetVectorPixelOnEachSide($arrPixel, $vectorDirection)
;~ 	Local $vectorPixelEachSide[2]
;~ 	If (UBound($arrPixel) > 1) Then
;~ 		Local $pixelSearch[2] = [-1, -1]
;~ 		Local $minPixel = $arrPixel[0]
;~ 		Local $maxPixel = $arrPixel[UBound($arrPixel) - 1]
;~ 		Local $min = $minPixel[$vectorDirection]
;~ 		Local $max = $maxPixel[$vectorDirection]
;~ 		Local $posSide = ($max - $min) / 4

;~ 		$pixelSearch[$vectorDirection] = $min + $posSide
;~ 		Local $arrPixelCloser = _FindPixelCloser($arrPixel, $pixelSearch, 1)
;~ 		$vectorPixelEachSide[0] = $arrPixelCloser[0]

;~ 		$pixelSearch[$vectorDirection] = $min + $posSide * 3
;~ 		Local $arrPixelCloser = _FindPixelCloser($arrPixel, $pixelSearch, 1)
;~ 		$vectorPixelEachSide[1] = $arrPixelCloser[0]


;~ 	EndIf
;~ 	Return $vectorPixelEachSide
;~ EndFunc   ;==>GetVectorPixelOnEachSide

Func GetVectorPixelOnEachSide2($arrPixel, $vectorDirection, $slotsPerEdge)
	; $vectorDirection = 0 than is Xaxis , $vectorDirection = 1 than is Yaxis
	Local $vectorPixelEachSide[$slotsPerEdge]
	If (UBound($arrPixel) > 1) Then
		Local $pixelSearch[2] = [-1, -1]
		Local $minPixel = $arrPixel[0]
		Local $maxPixel = $arrPixel[UBound($arrPixel) - 1]
		Local $min = $minPixel[$vectorDirection]
		Local $max = $maxPixel[$vectorDirection]
		If $g_bDebugSmartFarm Then Setlog("Min pixel coord: " & $min & ", Max Pixel coord: " & $max)
		Local $posSide = Floor(($max - $min) / $slotsPerEdge)

		For $i = 0 To $slotsPerEdge - 1
			$pixelSearch[$vectorDirection] = $min + Floor(($posSide * ($i + 1)) - ($posSide / 2))
			Local $coordinate = ($vectorDirection = 0) ? "X" : "Y"
			If $g_bDebugSmartFarm Then Setlog("Deploy point number[" & $i + 1 & "] at " &  $coordinate & ": " & $min + Floor(($posSide * ($i + 1)) - ($posSide / 2)))
			Local $arrPixelCloser = _FindPixelCloser($arrPixel, $pixelSearch, 1)
			If $g_bDebugSmartFarm Then Setlog("Deploy point Closer[" & $i + 1 & "] at: " & _ArrayToString($arrPixelCloser[0]))
			$vectorPixelEachSide[$i] = $arrPixelCloser[0]
		Next

	EndIf
	Return $vectorPixelEachSide
EndFunc   ;==>GetVectorPixelOnEachSide2
