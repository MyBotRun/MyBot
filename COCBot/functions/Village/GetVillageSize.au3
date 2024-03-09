; #FUNCTION# ====================================================================================================================
; Name ..........: GetVillageSize
; Description ...: Measures the size of village. After CoC October 2016 update, max'ed zoomed out village is 440 (reference!)
;                  But usually sizes around 470 - 490 pixels are measured due to lock on max zoom out.
;                  The 'zoom' has changed in the Spring 2022 update.  Prior to the update, the game screen at max'ed zoom has no 'up down'
;                  movement and only a little sideways movement.  This meant the fixed points used to 'center and measure' the village
;                  was always visible.  After the update, at max'ed zoom out, it is now possible to move both the 'tree' fixed points
;                  out of view or move the 'main' stone fixed point out of view.  The top and bottom black bars that sometimes appear
;                  at max'ed zoom are no longer present.
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
; Modified ......: GrumpyHog (05-2022)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func GetVillageSize($DebugLog = Default, $sStonePrefix = Default, $sTreePrefix = Default, $sFixedPrefix = Default, $bOnBuilderBase = Default, $bMeasureOnly = False)

	If $DebugLog = Default Then $DebugLog = False
	If $sStonePrefix = Default Then $sStonePrefix = "stone"
	If $sTreePrefix = Default Then $sTreePrefix = "tree"

	Local $aResult = 0
	Local $sDirectory
	Local $stone[6] = [0, 0, 0, 0, 0, ""], $tree[6] = [0, 0, 0, 0, 0, ""], $scenery[6] = [0, 0, 0, 0, 0, ""]
	Local $x0, $y0, $d0, $x, $y, $x1, $y1, $right, $bottom, $a

	Local $iAdditionalX = 200
	Local $iAdditionalY = 125

	Local $iTreeIndex = 0

	Local $bIsOnMainBase = isOnMainVillage(True)

	$g_bOnBuilderBaseEnemyVillage = isOnBuilderBaseEnemyVillage(True)

	If $bOnBuilderBase = Default Then
		$bOnBuilderBase = isOnBuilderBase(True)
	EndIf

	If $bOnBuilderBase Or $g_bOnBuilderBaseEnemyVillage Then
		$sDirectory = @ScriptDir & "\imgxml\village\BuilderBase\"
		SetDeBugLog("GVZ using : \imgxml\village\BuilderBase\", $COLOR_INFO)
	Else
		$sDirectory = @ScriptDir & "\imgxml\village\NormalVillage\" ; all sceneries support
		SetDeBugLog("GVZ using : \imgxml\village\NormalVillage\", $COLOR_INFO)
	EndIf

	Local $hTimer = TimerInit()

	Local $i, $findImage, $sArea, $a, $sScenery = "", $bForceCapture = False

	If $bIsOnMainBase Then
		$x1 = 185
		$y1 = 600
		$right = 680
		$bottom = 730

		Local $sSearchArea = Int($x1) & "," & Int($y1) & "|" & Int($right) & "," & Int($y1) & "|" & Int($right) & "," & Int($bottom) & "|" & Int($x1) & "," & Int($bottom)
		Local $sImgDir = @ScriptDir & "\imgxml\village\VillageScenery\"

		Local $avSceneries = findMultiple($sImgDir, $sSearchArea, $sSearchArea, 0, 1000, 1, "objectname,objectpoints", $bForceCapture)

		If Not IsArray($avSceneries) Or UBound($avSceneries, $UBOUND_ROWS) <= 0 Then
			SetDeBugLog("No Sceneries Found", $COLOR_ERROR)
			If $g_bDebugImageSave Then SaveDebugRectImage("FailedSceneryMultiSearch", $x1 & "," & $y1 & "," & $right & "," & $bottom)
		Else
			Local $avTempArray, $aiSceneryCoords

			; loop thro the detected images
			For $i = 0 To UBound($avSceneries, $UBOUND_ROWS) - 1
				$avTempArray = $avSceneries[$i]
				SetDeBugLog("Sceneries Search find : " & $avTempArray[0], $COLOR_INFO)
				$aiSceneryCoords = decodeSingleCoord($avTempArray[1])

				If Not IsArray($aiSceneryCoords) Or UBound($aiSceneryCoords, $UBOUND_ROWS) < 2 Then
					SetDeBugLog("Couldn't get proper Scenery coordinates", $COLOR_ERROR)
				Else
					SetDeBugLog("Coords : " & $aiSceneryCoords[0] & ", " & $aiSceneryCoords[1], $COLOR_INFO)

					$a = StringRegExp($avTempArray[0], ".*-(\d+)-(\d+)", $STR_REGEXPARRAYMATCH)

					$x = Number($aiSceneryCoords[0])
					$y = Number($aiSceneryCoords[1])

					If UBound($a) = 2 Then
						$x0 = Number($a[0])
						$y0 = Number($a[1])

						SetDeBugLog("Ref Coord : " & $x0 & ", " & $y0)

						$scenery[0] = $x ; x center of stone found
						$scenery[1] = $y ; y center of stone found
						$scenery[2] = $x0 ; x ref. center of stone
						$scenery[3] = $y0 ; y ref. center of stone
						$scenery[4] = 0 ;$d0 ; distance to village map in pixel
						$scenery[5] = $avTempArray[0]

						Local $sVillage = StringSplit($avTempArray[0], "-") ; get filename only
						$sScenery = StringRight($sVillage[1], 2) ; get extension

						SetDeBugLog("Village Scenery Found: " & $sScenery, $COLOR_OLIVE)

						; if too far away from expected location then align
						If $x > ($x0 + 75) Or $x < ($x0 - 75) Then
							SetDeBugLog("Village Scenery FP X is off by more than 75 pixels", $COLOR_WARNING)
							CenterVillage($x, $y, $x - $x0, $y - $y0)
							$bForceCapture = True ; forces new capture after align
							;If _Sleep(250) Then Return
						EndIf

						; reduce fix point search area
						$iAdditionalX = 100
						$iAdditionalY = 75
						ExitLoop ; found scenery
					EndIf
				EndIf
			Next
		EndIf

		SetDeBugLog("Scenery search (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds)", $COLOR_INFO)
		$hTimer = TimerInit()

		If Not $bMeasureOnly Then
			If $scenery[0] = 0 And $g_aiSearchZoomOutCounter[0] = 1 Then
				If $g_bDebugImageSave Then SaveDebugRectImage("FailedScenerySearch", $x1 & "," & $y1 & "," & $right & "," & $bottom)
				ClickAway()
				If _Sleep(100) Then Return
			EndIf
			;If $scenery[0] = 0 Then SaveDebugRectImage("FailedScenerySearch", $x1 & "," & $y1 & "," & $right & "," & $bottom)

			; force 2 zoomout then give up!
			If $scenery[0] = 0 And $g_aiSearchZoomOutCounter[0] < 2 Then
				SetDeBugLog("No sceneries found and zoomoutcount : " & $g_aiSearchZoomOutCounter[0], $COLOR_WARNING)
				Return $aResult
			EndIf
		EndIf
	EndIf

	SetDeBugLog("Scenery routines completed (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds)", $COLOR_INFO)
	$hTimer = TimerInit()

	If $scenery[0] = 0 Then
		If $bIsOnMainBase Then SetDeBugLog("No Supported Sceneries Found!", $COLOR_ERROR)
		SetDeBugLog("Searching ALL Stone files", $COLOR_INFO)
		Local $aStoneFiles = _FileListToArray($sDirectory, $sStonePrefix & "*.*", $FLTA_FILES)
	Else
		SetDeBugLog("Loading Stone Scenery: " & $sScenery, $COLOR_INFO)
		Local $aStoneFiles = _FileListToArray($sDirectory, $sStonePrefix & $sScenery & "*.*", $FLTA_FILES)
	EndIf

	If @error Then
		SetDeBugLog("Error: Missing stone files (" & @error & ")", $COLOR_ERROR)
		Return $aResult
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
			SetDebugLog("GetVillageSize check for image " & $findImage)
			$a = decodeSingleCoord(findImage($findImage, $sDirectory & "\" & $findImage, $sArea, 1, $bForceCapture))
			If $g_bDebugImageSave Then SaveDebugRectImage("GetVillageSize", $x1 & "," & $y1 & "," & $right & "," & $bottom)
			If UBound($a) = 2 Then
				$x = Int($a[0])
				$y = Int($a[1])
				SetDebugLog("Found stone image at " & $x & ", " & $y & ": " & $findImage)
				;SetLog("Found Stone image at " & $x & ", " & $y & ": " & $findImage)
				$stone[0] = $x ; x center of stone found
				$stone[1] = $y ; y center of stone found
				$stone[2] = $x0 ; x ref. center of stone
				$stone[3] = $y0 ; y ref. center of stone
				$stone[4] = $d0 ; distance to village map in pixel
				$stone[5] = $findImage

				Local $asStoneName = StringSplit($findImage, "-") ; get filename only
				Local $asStoneScenery = StringRight($asStoneName[1], 2) ; get extension

				SetDeBugLog("Found Stone scenery : " & $asStoneScenery, $COLOR_INFO)

				ExitLoop
			EndIf

		Else
			;SetDebugLog("GetVillageSize ignore image " & $findImage & ", reason: " & UBound($a), $COLOR_WARNING)
		EndIf
	Next

	If $stone[0] = 0 Then
		SetDeBugLog("GetVillageSize cannot find stone", $COLOR_WARNING)
		;Return $aResult
	EndIf

	SetDeBugLog("Stone search (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds)", $COLOR_INFO)
	$hTimer = TimerInit()

	If $stone[0] = 0 Then
		SetDeBugLog("Searching ALL tree files!", $COLOR_INFO)
		Local $aTreeFiles = _FileListToArray($sDirectory, $sTreePrefix & "*.*", $FLTA_FILES)
	ElseIf $asStoneScenery = "DS" Then
		Local $aTreeFiles = _FileListToArray($sDirectory, $sTreePrefix & "D*.*", $FLTA_FILES)
	Else
		Local $aTreeFiles = _FileListToArray($sDirectory, $sTreePrefix & $asStoneScenery & "*.*", $FLTA_FILES)
	EndIf

	If @error Then
		SetDeBugLog("Error: Missing tree (" & @error & ")", $COLOR_ERROR)
		Return FuncReturn($aResult)
	EndIf

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
			SetDebugLog("GetVillageSize check for image " & $findImage)
			$a = decodeSingleCoord(findImage($findImage, $sDirectory & "\" & $findImage, $sArea, 1, False))
			If $g_bDebugImageSave Then SaveDebugRectImage("GetVillageSize", $x1 & "," & $y1 & "," & $right & "," & $bottom)
			If UBound($a) = 2 Then
				$x = Int($a[0])
				$y = Int($a[1])
				SetDebugLog("Found tree image at " & $x & ", " & $y & ": " & $findImage)
				;SetLog("Found tree image at " & $x & ", " & $y & ": " & $findImage)
				$tree[0] = $x ; x center of tree found
				$tree[1] = $y ; y center of tree found
				$tree[2] = $x0 ; x ref. center of tree
				$tree[3] = $y0 ; y ref. center of tree
				$tree[4] = $d0 ; distance to village map in pixel
				$tree[5] = $findImage

				Local $asTreeName = StringSplit($findImage, "-") ; get filename only
				Local $sTreeName = $asTreeName[1]
				If StringInStr($sTreeName, "2tree") Then
					SetDeBugLog("Using 2tree")
					$sTreeName = StringReplace($sTreeName, "2", "") ; remove 2 in 2tree
					$iTreeIndex = 5
				EndIf

				$g_iTree = Int(Eval("e" & $sTreeName))
				If $DebugLog Then SetDeBugLog($sTreeName & " " & $g_iTree, $COLOR_INFO)
				ExitLoop
			EndIf

		Else
			;SetDebugLog("GetVillageSize ignore image " & $findImage & ", reason: " & UBound($a), $COLOR_WARNING)
		EndIf
	Next

	If $tree[0] = 0 Then
		SetDeBugLog("GetVillageSize cannot find tree", $COLOR_WARNING)
		;Return $aResult
	EndIf

	SetDeBugLog("Tree search (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds)", $COLOR_INFO)
	$hTimer = TimerInit()

	Local $iX_Exp = 0
	Local $iY_Exp = 0
	Local $z = 1    ; for centering only
	Local $c = 0    ; for centering only
	Local $a = 0, $b = 0, $iRefSize = 0

	; Failed to locate Stone Or Tree ; zoom out
	If $stone[0] = 0 And $tree[0] = 0 Then
		SetDeBugLog("GetVillageSize cannot find stone or tree", $COLOR_WARNING)
		Return $aResult
	ElseIf $stone[0] = 0 And $tree[0] > 0 Then ; calculate offset using trees
		$x = $tree[0] - $tree[2]
		$y = $tree[1] - $tree[3]
		SetDeBugLog("Found Tree! Offset : " & $x & ", " & $y, $COLOR_INFO)
	ElseIf $tree[0] = 0 And $stone[0] > 0 Then ; calculate offset using stone
		$x = $stone[0] - $stone[2]
		$y = $stone[1] - $stone[3]
		SetDeBugLog("Found Stone! Offset : " & $x & ", " & $y, $COLOR_INFO)
	Else
		; calculate village size, see https://en.wikipedia.org/wiki/Pythagorean_theorem
		$a = $tree[0] - $stone[0]
		$b = $stone[1] - $tree[1]
		$c = Sqrt($a * $a + $b * $b) - $stone[4] - $tree[4]

		$iRefSize = $g_afRefVillage[$g_iTree][$iTreeIndex]

		$z = $c / $iRefSize

		Local $stone_x_exp = $stone[2]
		Local $stone_y_exp = $stone[3]
		ConvertVillagePos($stone_x_exp, $stone_y_exp, $z) ; expected x, y position of stone
		$x = $stone[0] - $stone_x_exp
		$y = $stone[1] - $stone_y_exp

		SetDeBugLog("Found Stone and Tree!", $COLOR_INFO) ;
		SetDeBugLog("Village Size : " & $c, $COLOR_INFO)
		SetDeBugLog("Zoom Factor : " & $z, $COLOR_INFO)
		SetDeBugLog("Offset : " & $x & ", " & $y, $COLOR_INFO)
		;If $DebugLog Then SetDebugLog("GetVillageSize measured: " & $c & ", Zoom factor: " & $z & ", Offset: " & $x & ", " & $y, $COLOR_INFO)
	EndIf

	Dim $aResult[11]
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
	$aResult[10] = $iRefSize

	$g_aVillageSize[0] = $aResult[0]
	$g_aVillageSize[1] = $aResult[1]
	$g_aVillageSize[2] = $aResult[2]
	$g_aVillageSize[3] = $aResult[3]
	$g_aVillageSize[4] = $aResult[4]
	$g_aVillageSize[5] = $aResult[5]
	$g_aVillageSize[6] = $aResult[6]
	$g_aVillageSize[7] = $aResult[7]
	$g_aVillageSize[8] = $aResult[8]
	$g_aVillageSize[9] = $aResult[9]

	SetDeBugLog("GetVillageSize calculations (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds)", $COLOR_INFO)

	Return FuncReturn($aResult)
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

Func CenterVillage($iX, $iY, $iOffsetX, $iOffsetY)
	Local $aScrollPos[2] = [0, 0]

	If IsCoordSafe($iX, $iY) Then
		$aScrollPos[0] = $iX
		$aScrollPos[1] = $iY
	Else
		$aScrollPos[0] = $aCenterHomeVillageClickDrag[0]
		$aScrollPos[1] = $aCenterHomeVillageClickDrag[1]
	EndIf

	If $g_bDebugSetlog Then SetDebugLog("CenterVillage at point : " & $aScrollPos[0] & ", " & $aScrollPos[1] & " Offset : " & $iOffsetX & ", " & $iOffsetY, $COLOR_INFO)
	If $g_bDebugImageSave Then SaveDebugPointImage("CenterVillage", $aScrollPos)
	ClickAway()
	ClickDrag($aScrollPos[0], $aScrollPos[1], $aScrollPos[0] - $iOffsetX, $aScrollPos[1] - $iOffsetY)

	If _Sleep(150) Then Return
EndFunc   ;==>CenterVillage

Func IsCoordSafe($x, $y)
	Local $bResult = True
	Local $bIsOnMainBase = isOnMainVillage()

	SetDeBugLog("Testing Coords : " & $x & "," & $y)

	If $x < 82 And $y > 427 + $g_iBottomOffsetY And $bIsOnMainBase Then ; coordinates where the game will click on the War Button (safe margin)
		If $g_bDebugSetlog Then SetDebugLog("Too close to War Button")
		$bResult = False
	ElseIf $x < 72 And ($y > 270 + $g_iMidOffsetY And $y < 345 + $g_iMidOffsetY) Then ; coordinates where the game will click on the CHAT tab (safe margin)
		If $g_bDebugSetlog Then SetDebugLog("Too close to CHAT Tab")
		$bResult = False
	ElseIf $y < 63 Then ; coordinates where the game will click on the BUILDER button or SHIELD button (safe margin)
		If $g_bDebugSetlog Then SetDebugLog("Too close to Builder and Shield")
		$bResult = False
	ElseIf $x > 692 And $y > 126 + $g_iMidOffsetY And $y < 180 + $g_iMidOffsetY And $bIsOnMainBase Then ; coordinates where the game will click on the GEMS button (safe margin)
		If $g_bDebugSetlog Then SetDebugLog("Too close to GEMS")
		$bResult = False
	EndIf

	If _Sleep(100) Then Return

	Return $bResult
EndFunc   ;==>IsCoordSafe
