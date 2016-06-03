; #FUNCTION# ====================================================================================================================
; Name ..........: GetListPixel3
; Description ...:
; Syntax ........: GetListPixel3($listPixel)
; Parameters ....: $listPixel           - an unknown value.
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func GetListPixel3($listPixel)
	Local $listPixelSideStr = StringSplit($listPixel, "|")
	If ($listPixelSideStr[0] > 1) Then
		Local $listPixelSide[UBound($listPixelSideStr) - 1]
		For $i = 0 To UBound($listPixelSide) - 1
			Local $pixelStr = StringSplit($listPixelSideStr[$i + 1], "-")
			If ($pixelStr[0] > 2) Then
				Local $pixel[3] = [$pixelStr[1], $pixelStr[2], $pixelStr[3]]
				$listPixelSide[$i] = $pixel
			EndIf
		Next
		Return $listPixelSide
	Else
		If StringInStr($listPixel, "-") > 0 Then
			Local $pixelStrHere = StringSplit($listPixel, "-")
			Local $pixelHere[3] = [$pixelStrHere[1], $pixelStrHere[2], $pixelStrHere[3]]
			Local $listPixelHere[1]
			$listPixelHere[0] = $pixelHere
			Return $listPixelHere
		EndIf
		Return -1;
	EndIf
EndFunc   ;==>GetListPixel3
