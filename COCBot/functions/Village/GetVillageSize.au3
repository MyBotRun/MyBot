; #FUNCTION# ====================================================================================================================
; Name ..........: GetVillageSize
; Description ...: Measures the size of village. After CoC October 2016 update, max'ed zoomed out village is 440 (reference!)
;                  But usually sizes around 470 - 490 pixels are measured due to lock on max zoom out.
; Syntax ........: GetVillageSize()
; Parameters ....:
; Return values .: 0 if not identified or Array with index
;                      0 = Size of village (float)
;                      1 = Zoom factor based on 440 village size (float)
;                      2 = X offset of village center (int)
;                      3 = Y offset of village center (int)
;                      4 = X coordinate of stone
;                      5 = Y coordinate of stone
;                      6 = stone image file name
;                      7 = X coordinate of tree
;                      8 = Y coordinate of tree
;                      9 = tree image file name
; Author ........: Cosote (Oct 17th 2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func GetVillageSize($DebugLog = Default, $sStonePrefix = Default, $sTreePrefix = Default, $sFixedPrefix = Default, $bOnBuilderBase = Default)
	FuncEnter(GetVillageSize)
	If $DebugLog = Default Then $DebugLog = False
	If $sStonePrefix = Default Then $sStonePrefix = "stone"
	If $sTreePrefix = Default Then $sTreePrefix = "tree"
	If $sFixedPrefix = Default Then
		$sFixedPrefix = ""
		If $g_bUpdateSharedPrefs Then $sFixedPrefix = "fixed"
	EndIf

	Local $aResult = 0
	Local $sDirectory
	Local $stone = [0, 0, 0, 0, 0, ""], $tree = [0, 0, 0, 0, 0, ""], $fixed = [0, 0, 0, 0, 0, ""]
	Local $x0, $y0, $d0, $x, $y, $x1, $y1, $right, $bottom, $a

	Local $iAdditionalY = 75
	Local $iAdditionalX = 100

	If $bOnBuilderBase = Default Then
		$bOnBuilderBase = isOnBuilderBase(True)
	EndIf
	If $bOnBuilderBase Then
		$sDirectory = $g_sImgZoomOutDirBB
	Else
		$sDirectory = $g_sImgZoomOutDir
	EndIf
	Local $aStoneFiles = _FileListToArray($sDirectory, $sStonePrefix & "*.*", $FLTA_FILES)
	If @error Then
		SetLog("Error: Missing stone files (" & @error & ")", $COLOR_ERROR)
		Return FuncReturn($aResult)
	EndIf
	; use stoneBlueStacks2A stones first
	Local $iNewIdx = 1
	For $i = 1 To $aStoneFiles[0]
		If StringInStr($aStoneFiles[$i], "stoneBlueStacks2A") = 1 Then
			Local $s = $aStoneFiles[$iNewIdx]
			$aStoneFiles[$iNewIdx] = $aStoneFiles[$i]
			$aStoneFiles[$i] = $s
			$iNewIdx += 1
		EndIf
	Next
	Local $aTreeFiles = _FileListToArray($sDirectory, $sTreePrefix & "*.*", $FLTA_FILES)
	If @error Then
		SetLog("Error: Missing tree (" & @error & ")", $COLOR_ERROR)
		Return FuncReturn($aResult)
	EndIf
	Local $i, $findImage, $sArea, $a

	Local $aFixedFiles = ($sFixedPrefix ? _FileListToArray($sDirectory, $sFixedPrefix & "*.*", $FLTA_FILES) : 0)

	If UBound($aFixedFiles) > 0 Then
		For $i = 1 To $aFixedFiles[0]
			$findImage = $aFixedFiles[$i]
			$a = StringRegExp($findImage, ".*-(\d+)-(\d+)-(\d*,*\d+)_.*[.](xml|png|bmp)$", $STR_REGEXPARRAYMATCH)
			If UBound($a) = 4 Then

				$x0 = $a[0]
				$y0 = $a[1]
				$d0 = StringReplace($a[2], ",", ".")

				$x1 = $x0 - $iAdditionalX
				$y1 = $y0 - $iAdditionalY
				$right = $x0 + $iAdditionalX
				$bottom = $y0 + $iAdditionalY
				$sArea = Int($x1) & "," & Int($y1) & "|" & Int($right) & "," & Int($y1) & "|" & Int($right) & "," & Int($bottom) & "|" & Int($x1) & "," & Int($bottom)
				;SetDebugLog("GetVillageSize check for image " & $findImage)
				$a = decodeSingleCoord(findImage($findImage, $sDirectory & $findImage, $sArea, 1, True))
				If UBound($a) = 2 Then
					$x = Int($a[0])
					$y = Int($a[1])
					;SetDebugLog("Found fixed image at " & $x & ", " & $y & ": " & $findImage)
					$fixed[0] = $x ; x center of fixed found
					$fixed[1] = $y ; y center of fixed found
					$fixed[2] = $x0 ; x ref. center of fixed
					$fixed[3] = $y0 ; y ref. center of fixed
					$fixed[4] = $d0 ; distance to village map in pixel
					$fixed[5] = $findImage
					ExitLoop
				EndIf

			Else
				;SetDebugLog("GetVillageSize ignore image " & $findImage & ", reason: " & UBound($a), $COLOR_WARNING)
			EndIf
		Next
	EndIf

	For $i = 1 To $aStoneFiles[0]
		$findImage = $aStoneFiles[$i]
		$a = StringRegExp($findImage, ".*-(\d+)-(\d+)-(\d*,*\d+)_.*[.](xml|png|bmp)$", $STR_REGEXPARRAYMATCH)
		If UBound($a) = 4 Then

			$x0 = $a[0]
			$y0 = $a[1]
			$d0 = StringReplace($a[2], ",", ".")

			$x1 = $x0 - $iAdditionalX
			$y1 = $y0 - $iAdditionalY
			$right = $x0 + $iAdditionalX
			$bottom = $y0 + $iAdditionalY
			$sArea = Int($x1) & "," & Int($y1) & "|" & Int($right) & "," & Int($y1) & "|" & Int($right) & "," & Int($bottom) & "|" & Int($x1) & "," & Int($bottom)
			;SetDebugLog("GetVillageSize check for image " & $findImage)
			$a = decodeSingleCoord(findImage($findImage, $sDirectory & $findImage, $sArea, 1, True))
			If UBound($a) = 2 Then
				$x = Int($a[0])
				$y = Int($a[1])
				;SetDebugLog("Found stone image at " & $x & ", " & $y & ": " & $findImage)
				$stone[0] = $x ; x center of stone found
				$stone[1] = $y ; y center of stone found
				$stone[2] = $x0 ; x ref. center of stone
				$stone[3] = $y0 ; y ref. center of stone
				$stone[4] = $d0 ; distance to village map in pixel
				$stone[5] = $findImage
				ExitLoop
			EndIf

		Else
			;SetDebugLog("GetVillageSize ignore image " & $findImage & ", reason: " & UBound($a), $COLOR_WARNING)
		EndIf
	Next

	If $stone[0] = 0 And $fixed[0] = 0 Then
		SetDebugLog("GetVillageSize cannot find stone", $COLOR_WARNING)
		Return FuncReturn($aResult)
	EndIf

	If $stone[0] Then
		For $i = 1 To $aTreeFiles[0]
			$findImage = $aTreeFiles[$i]
			$a = StringRegExp($findImage, ".*-(\d+)-(\d+)-(\d*,*\d+)_.*[.](xml|png|bmp)$", $STR_REGEXPARRAYMATCH)
			If UBound($a) = 4 Then

				$x0 = $a[0]
				$y0 = $a[1]
				$d0 = StringReplace($a[2], ",", ".")

				$x1 = $x0 - $iAdditionalX
				$y1 = $y0 - $iAdditionalY
				$right = $x0 + $iAdditionalX
				$bottom = $y0 + $iAdditionalY
				$sArea = Int($x1) & "," & Int($y1) & "|" & Int($right) & "," & Int($y1) & "|" & Int($right) & "," & Int($bottom) & "|" & Int($x1) & "," & Int($bottom)
				;SetDebugLog("GetVillageSize check for image " & $findImage)
				$a = decodeMultipleCoords(findImage($findImage, $sDirectory & $findImage, $sArea, 2, True), Default, Default, 0) ; sort by x because there can be a 2nd at the right that should not be used
				If UBound($a) > 0 Then
					$a = $a[0]
					$x = Int($a[0])
					$y = Int($a[1])
					;SetDebugLog("Found tree image at " & $x & ", " & $y & ": " & $findImage)
					$tree[0] = $x ; x center of tree found
					$tree[1] = $y ; y center of tree found
					$tree[2] = $x0 ; x ref. center of tree
					$tree[3] = $y0 ; y ref. center of tree
					$tree[4] = $d0 ; distance to village map in pixel
					$tree[5] = $findImage
					ExitLoop
				EndIf

			Else
				;SetDebugLog("GetVillageSize ignore image " & $findImage & ", reason: " & UBound($a), $COLOR_WARNING)
			EndIf
		Next

		If $g_bUpdateSharedPrefs And Not $bOnBuilderBase And $tree[0] = 0 And $fixed[0] = 0 Then
			; On main village use stone as fixed point
			$fixed = $stone
		EndIf

		If $tree[0] = 0 And $fixed[0] = 0 And Not $g_bRestart Then
			SetDebugLog("GetVillageSize cannot find tree", $COLOR_WARNING)
			Return FuncReturn($aResult)
		EndIf
	EndIf

	; calculate village size, see https://en.wikipedia.org/wiki/Pythagorean_theorem
	Local $a = $tree[0] - $stone[0]
	Local $b = $stone[1] - $tree[1]
	Local $c = Sqrt($a * $a + $b * $b) - $stone[4] - $tree[4]

	If $g_bUpdateSharedPrefs And Not $bOnBuilderBase And $fixed[0] = 0 And $c >= 500 Then
		; On main village use stone as fixed point when village size is too large, as that might cause an infinite loop when obstacle blocked (and another tree found)
		$fixed = $stone
	EndIf

	; initial reference village had a width of 473.60282919315 (and not 440) and stone located at 226, 567, so center on that reference and used zoom factor on that size
	;Local $z = $c / 473.60282919315 ; don't use size of 440, as beta already using reference village
	Local $iRefSize = 458 ; 2019-01-02 Update village measuring as outer edges didn't align anymore
	Local $iDefSize = 444 ; 2019-04-01 New default size using shared_prefs zoom level
	Local $z = $c / $iRefSize

	Local $stone_x_exp = $stone[2]
	Local $stone_y_exp = $stone[3]
	ConvertVillagePos($stone_x_exp, $stone_y_exp, $z) ; expected x, y position of stone
	$x = $stone[0] - $stone_x_exp
	$y = $stone[1] - $stone_y_exp

	If $fixed[0] = 0 And Not $g_bRestart Then

		If $DebugLog Then SetDebugLog("GetVillageSize measured: " & $c & ", Zoom factor: " & $z & ", Offset: " & $x & ", " & $y, $COLOR_INFO)

		Dim $aResult[10]
		$aResult[0] = $c
		$aResult[1] = $z
		$aResult[2] = $x
		$aResult[3] = $y
		$aResult[4] = $stone[0]
		$aResult[5] = $stone[1]
		$aResult[6] = $stone[5]
		$aResult[7] = $tree[0]
		$aResult[8] = $tree[1]
		$aResult[9] = $tree[5]
		Return FuncReturn($aResult)

	Else

		; used fixed tile position for village offset
		Local $bReset = $g_bUpdateSharedPrefs And $c >= 500
		If $tree[0] = 0 Or $stone[0] = 0 Or $bReset Then
			; missing a tile or reset required
			If $bReset Then SetDebugLog("GetVillageSize resets village size from " & $c & " to " & $iDefSize, $COLOR_WARNING)
			$c = $iDefSize
			$z = $iDefSize / $iRefSize
		EndIf

		$x = $fixed[0] - $fixed[2]
		$y = $fixed[1] - $fixed[3]

		If $DebugLog Then SetDebugLog("GetVillageSize measured (fixed): " & $c & ", Zoom factor: " & $z & ", Offset: " & $x & ", " & $y, $COLOR_INFO)

		Dim $aResult[10]
		$aResult[0] = $c
		$aResult[1] = $z
		$aResult[2] = $x
		$aResult[3] = $y
		$aResult[4] = $stone[0]
		$aResult[5] = $stone[1]
		$aResult[6] = $stone[5]
		$aResult[7] = $tree[0]
		$aResult[8] = $tree[1]
		$aResult[9] = $tree[5]
		Return FuncReturn($aResult)

	EndIf

	FuncReturn()

EndFunc   ;==>GetVillageSize

Func UpdateGlobalVillageOffset($x, $y)

	Local $updated = False

	If $g_sImglocRedline <> "" Then

		Local $newReadLine = ""
		Local $aPoints = StringSplit($g_sImglocRedline, "|", $STR_NOCOUNT)

		For $sPoint In $aPoints

			Local $aPoint = GetPixel($sPoint, ",")
			$aPoint[0] += $x
			$aPoint[1] += $y

			If StringLen($newReadLine) > 0 Then $newReadLine &= "|"
			$newReadLine &= ($aPoint[0] & "," & $aPoint[1])

		Next

		; set updated red line
		$g_sImglocRedline = $newReadLine

		$updated = True
	EndIf

	If $g_aiTownHallDetails[0] <> 0 And $g_aiTownHallDetails[1] <> 0 Then
		$g_aiTownHallDetails[0] += $x
		$g_aiTownHallDetails[1] += $y
		$updated = True
	EndIf
	If $g_iTHx <> 0 And $g_iTHy <> 0 Then
		$g_iTHx += $x
		$g_iTHy += $y
		$updated = True
	EndIf

	ConvertInternalExternArea()

	Return $updated

EndFunc   ;==>UpdateGlobalVillageOffset
