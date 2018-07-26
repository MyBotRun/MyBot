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
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
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
;                  $resultPosition      - 1 returns centered coordinates of image found.
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
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _ImageSearchArea($findImage, $resultPosition, $x1, $y1, $right, $bottom, ByRef $x, ByRef $y, $Tolerance)
	Local $HBMP = $g_hHBitmap
	If $g_bChkBackgroundMode = False Then
		$HBMP = 0
		$x1 += $g_aiBSpos[0]
		$y1 += $g_aiBSpos[1]
		$right += $g_aiBSpos[0]
		$bottom += $g_aiBSpos[1]
	EndIf
	;MsgBox(0,"asd","" & $x1 & " " & $y1 & " " & $right & " " & $bottom)

	Local $result
	If IsString($findImage) Then
		If $Tolerance > 0 Then $findImage = "*" & $Tolerance & " " & $findImage
		If $HBMP = 0 Then
			;$result = DllCallMyBot("ImageSearch", "int", $x1, "int", $y1, "int", $right, "int", $bottom, "str", $findImage) ;
			$result = DllCall($g_sLibImageSearchPath, "str", "ImageSearch", "int", $x1, "int", $y1, "int", $right, "int", $bottom, "str", $findImage) ;
		Else
			;$result = DllCallMyBot("ImageSearchEx", "int", $x1, "int", $y1, "int", $right, "int", $bottom, "str", $findImage, "ptr", $HBMP)
			$result = DllCall($g_sLibImageSearchPath, "str", "ImageSearchEx", "int", $x1, "int", $y1, "int", $right, "int", $bottom, "str", $findImage, "ptr", $HBMP)
		EndIf
	Else
		;$result = DllCallMyBot("ImageSearchExt", "int", $x1, "int", $y1, "int", $right, "int", $bottom, "int", $Tolerance, "ptr", $findImage, "ptr", $HBMP)
		$result = DllCall($g_sLibImageSearchPath, "str", "ImageSearchExt", "int", $x1, "int", $y1, "int", $right, "int", $bottom, "int", $Tolerance, "ptr", $findImage, "ptr", $HBMP)
	EndIf
	If @error Then _logErrorDLLCall($g_sLibImageSearchPath, @error)

	; If error exit
	If IsArray($result) Then
		If $result[0] = "0" Then Return 0
	Else
		SetLog("Error: Image Search not working...", $COLOR_ERROR)
		Return 1
	EndIf


	; Otherwise get the x,y location of the match and the size of the image to
	; compute the centre of search
	Local $array = StringSplit($result[0], "|")
	If (UBound($array) >= 4) Then
		$x = Int(Number($array[2]))
		$y = Int(Number($array[3]))
		If $resultPosition = 1 Then
			$x = $x + Int(Number($array[4]) / 2)
			$y = $y + Int(Number($array[5]) / 2)
		EndIf
		;If $g_bIsHidden = False Then
		$x -= $x1
		$y -= $y1
		;EndIf
		Return 1
	EndIf
EndFunc   ;==>_ImageSearchArea

Func _ImageSearchAreaImgLoc($findImage, $resultPosition, $x1, $y1, $right, $bottom, ByRef $x, ByRef $y, $hHBMP = $g_hHBitmap)

	Local $sArea = Int($x1) & "," & Int($y1) & "|" & Int($right) & "," & Int($y1) & "|" & Int($right) & "," & Int($bottom) & "|" & Int($x1) & "," & Int($bottom)
	Local $MaxReturnPoints = 1

	Local $res = DllCallMyBot("FindTile", "handle", $hHBMP, "str", $findImage, "str", $sArea, "Int", $MaxReturnPoints)
	If @error Then _logErrorDLLCall($g_sLibMyBotPath, @error)
	If IsArray($res) Then
		If $res[0] = "0" Or $res[0] = "" Then
			;SetLog($findImage & " not found", $COLOR_GREEN)
		ElseIf StringLeft($res[0], 2) = "-1" Then
			SetLog("DLL Error: " & $res[0] & ", " & $findImage, $COLOR_ERROR)
		Else
			Local $expRet = StringSplit($res[0], "|", $STR_NOCOUNT)
			;$expret contains 2 positions; 0 is the total objects; 1 is the point in X,Y format
			If UBound($expRet) >= 2 Then
				Local $posPoint = StringSplit($expRet[1], ",", $STR_NOCOUNT)
				If UBound($posPoint) >= 2 Then
					$x = Int($posPoint[0])
					$y = Int($posPoint[1])
					If $resultPosition <> 1 Then ; ImgLoc is always centered, convert to upper-left
						Local $sImgInfo = _ImageGetInfo($findImage)
						Local $iTileWidth = _ImageGetParam($sImgInfo, "Width")
						Local $iTileHeight = _ImageGetParam($sImgInfo, "Height")
						$x -= Int(Number($iTileWidth) / 2)
						$y -= Int(Number($iTileHeight) / 2)
					EndIf
					$x -= $x1
					$y -= $y1
					Return 1
				Else
					;SetLog($findImage & " not found: " & $expRet[1], $COLOR_GREEN)
				EndIf
			EndIf
		EndIf
	EndIf

	Return 0
EndFunc   ;==>_ImageSearchAreaImgLoc
