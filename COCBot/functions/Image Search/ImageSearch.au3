; #FUNCTION# ====================================================================================================================
; Name ..........: _ImageSearch
; Description ...:
; Syntax ........: _ImageSearch($findImage, $resultPosition, Byref $x, Byref $y, $Tolerance)
; Parameters ....: $findImage           - the image to find.
;                  $resultPosition      - .
;                  $x                   - [in/out] X Location of image found.
;                  $y                   - [in/out] Y Location of image found.
;                  $Tolerance           - allowable variation in finding image.
; Return values .:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _ImageSearch($findImage, $resultPosition, ByRef $x, ByRef $y, $Tolerance)
	Return _ImageSearchArea($findImage, $resultPosition, 0, 0, 840, 720, $x, $y, $Tolerance)
EndFunc   ;==>_ImageSearch
;
;
; #FUNCTION# ====================================================================================================================
; Name ..........: _ImageSearchArea
; Description ...:
; Syntax ........: _ImageSearchArea($findImage, $resultPosition, $x1, $y1, $right, $bottom, Byref $x, Byref $y, $Tolerance)
; Parameters ....: $findImage           - the image to find.
;                  $resultPosition      - an unknown value.
;                  $x1                  - Top left corner X location of area to search
;                  $y1                  - Top left corner Y location of area to search
;                  $right               - Bottom right corner x location of area to search
;                  $bottom              - Bottom right corner y location of area to search
;                  $x                   - X Location of image match if found.
;                  $y                   - Y Location of image match if found.
;                  $Tolerance           - allowable variation in finding image.
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _ImageSearchArea($findImage, $resultPosition, $x1, $y1, $right, $bottom, ByRef $x, ByRef $y, $Tolerance)
	Global $HBMP = $hHBitmap
	If $ichkBackground = 0 Then
		$HBMP = 0
		$x1 += $BSPos[0]
		$y1 += $BSPos[1]
		$right += $BSPos[0]
		$bottom += $BSPos[1]
	EndIf
	;MsgBox(0,"asd","" & $x1 & " " & $y1 & " " & $right & " " & $bottom)

	Local $result
	If IsString($findImage) Then
		If $Tolerance > 0 Then $findImage = "*" & $Tolerance & " " & $findImage
		If $HBMP = 0 Then
			$result = DllCall($pImageLib, "str", "ImageSearch", "int", $x1, "int", $y1, "int", $right, "int", $bottom, "str", $findImage)
		Else
			$result = DllCall($pImageLib, "str", "ImageSearchEx", "int", $x1, "int", $y1, "int", $right, "int", $bottom, "str", $findImage, "ptr", $HBMP)
		EndIf
	Else
		$result = DllCall($pImageLib, "str", "ImageSearchExt", "int", $x1, "int", $y1, "int", $right, "int", $bottom, "int", $Tolerance, "ptr", $findImage, "ptr", $HBMP)
	EndIf
	If @error Then _logErrorDLLCall($pImageLib, @error)

	; If error exit
	If IsArray($result) Then
		If $result[0] = "0" Then Return 0
	Else
		SetLog("Error: Image Search not working...", $COLOR_RED)
		Return 1
	EndIf


	; Otherwise get the x,y location of the match and the size of the image to
	; compute the centre of search
	$array = StringSplit($result[0], "|")
	If (UBound($array) >= 4) Then
		$x = Int(Number($array[2]))
		$y = Int(Number($array[3]))
		If $resultPosition = 1 Then
			$x = $x + Int(Number($array[4]) / 2)
			$y = $y + Int(Number($array[5]) / 2)
		EndIf
		If $Hide = False Then
			$x -= $x1
			$y -= $y1
		EndIf
		Return 1
	EndIf
EndFunc   ;==>_ImageSearchArea
