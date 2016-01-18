
; #FUNCTION# ====================================================================================================================
; Name ..........: _GetVectorOutZone
; Description ...:
; Syntax ........: _GetVectorOutZone($eVectorType)
; Parameters ....: $eVectorType         - an unknown value.
; Return values .: None
; Author ........: didipe
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: NoNo
; ===============================================================================================================================
Func _GetVectorOutZone($eVectorType)
	debugRedArea("_GetVectorOutZone IN")
	Local $vectorOutZone[0]

	If ($eVectorType = $eVectorLeftTop) Then
		$xMin = 430
		$yMin = 29
		$xMax = 33
		$yMax = 325
		$xStep = -4
		$yStep = 3
	ElseIf ($eVectorType = $eVectorRightTop) Then
		$xMin = 430
		$yMin = 29
		$xMax = 834
		$yMax = 325
		$xStep = 4
		$yStep = 3
	ElseIf ($eVectorType = $eVectorLeftBottom) Then
		$xMin = 39
		$yMin = 338
		$xMax = 430
		$yMax = 630
		$xStep = 4
		$yStep = 3
	Else
		$xMin = 834
		$yMin = 325
		$xMax = 430
		$yMax = 630
		$xStep = -4
		$yStep = 3
	EndIf


	Local $pixel[2]
	Local $x = $xMin
	For $y = $yMin To $yMax Step $yStep
		$x += $xStep
		$pixel[0] = $x
		$pixel[1] = $y
		ReDim $vectorOutZone[UBound($vectorOutZone) + 1]
		$vectorOutZone[UBound($vectorOutZone) - 1] = $pixel

	Next

	Return $vectorOutZone
EndFunc   ;==>_GetVectorOutZone
