; #FUNCTION# ====================================================================================================================
; Name ..........: _GetRedArea
; Description ...:  See strategy below
; Syntax ........: _GetRedArea()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
; Strategy :
; 			Search red area
;			Split the result in 4 sides (global var) : Top Left / Bottom Left / Top Right / Bottom Right
;			Remove bad pixel (Suppose that pixel to deploy are in the green area)
;			Get pixel next the "out zone" , indeed the red color is very different and more uncertain
;			Sort each sides
;			Add each sides in one array (not use, but it can help to get closer pixel of all the red area)

Func _GetRedArea($iMode = $REDLINE_IMGLOC, $iMaxAllowedPixelDistance = 25)
	Local $nameFunc = "[_GetRedArea] "
	debugRedArea($nameFunc & " IN")

	Local $colorVariation = 40
	Local $xSkip = 1
	Local $ySkip = 5
	Local $result = 0

    If $g_iMatchMode = $LB And $g_aiAttackAlgorithm[$LB] = 0 And $g_aiAttackStdDropSides[$LB] = 4 Then ; Used for DES Side Attack (need to know the side the DES is on)
		$result = DllCall($g_hLibFunctions, "str", "getRedAreaSideBuilding", "ptr", $hHBitmap2, "int", $xSkip, "int", $ySkip, "int", $colorVariation, "int", $eSideBuildingDES)
		If $g_iDebugSetlog Then Setlog("Debug: Redline with DES Side chosen")
    ElseIf $g_iMatchMode = $LB And $g_aiAttackAlgorithm[$LB] = 0 And $g_aiAttackStdDropSides[$LB] = 5 Then ; Used for TH Side Attack (need to know the side the TH is on)
		$result = DllCall($g_hLibFunctions, "str", "getRedAreaSideBuilding", "ptr", $hHBitmap2, "int", $xSkip, "int", $ySkip, "int", $colorVariation, "int", $eSideBuildingTH)
		If $g_iDebugSetlog Then Setlog("Debug: Redline with TH Side chosen")
	Else ; Normal getRedArea

		Switch $iMode
			Case $REDLINE_NONE ; No red line
				Local $listPixelBySide = ["NoRedLine", "", "", "", ""]
			Case $REDLINE_IMGLOC_RAW ; ImgLoc raw red line routine
				; ensure redline exists
				SearchRedLinesMultipleTimes()
				Local $listPixelBySide = getRedAreaSideBuilding()
			Case $REDLINE_IMGLOC ; New ImgLoc based deployable red line routine
				; ensure redline exists
				SearchRedLinesMultipleTimes()
				Local $dropPoints = GetOffSetRedline("TL") & "|" & GetOffSetRedline("BL") & "|" & GetOffSetRedline("BR") & "|" & GetOffSetRedline("TR")
				Local $listPixelBySide = getRedAreaSideBuilding($dropPoints)
				#cs
					$PixelTopLeft = _SortRedline(GetOffSetRedline("TL"))
					$PixelBottomLeft =  _SortRedline(GetOffSetRedline("BL"))
					$PixelBottomRight = _SortRedline(GetOffSetRedline("BR"))
					$PixelTopRight =  _SortRedline(GetOffSetRedline("TR"))
					Local $listPixelBySide = ["ImgLoc", $PixelTopLeft, $PixelBottomLeft, $PixelBottomRight, $PixelTopRight]
				#ce
			Case $REDLINE_ORIGINAL ; Original red line routine
				Local $result = DllCall($g_hLibFunctions, "str", "getRedArea", "ptr", $hHBitmap2, "int", $xSkip, "int", $ySkip, "int", $colorVariation)
		EndSwitch
		If $g_iDebugSetlog Then Setlog("Debug: Redline chosen")
	EndIf

	If IsArray($result) Then
		Local $listPixelBySide = StringSplit($result[0], "#")
	EndIf
	$PixelTopLeft = GetPixelSide($listPixelBySide, 1)
	$PixelBottomLeft = GetPixelSide($listPixelBySide, 2)
	$PixelBottomRight = GetPixelSide($listPixelBySide, 3)
	$PixelTopRight = GetPixelSide($listPixelBySide, 4)

		;02.02  - CLEAN REDAREA BAD POINTS -----------------------------------------------------------------------------------------------------------------------
	CleanRedArea($PixelTopLeft)
	CleanRedArea($PixelTopRight)
	CleanRedArea($PixelBottomLeft)
	CleanRedArea($PixelBottomRight)
	debugAttackCSV("RedArea cleaned")
	debugAttackCSV("	[" & UBound($PixelTopLeft) & "] pixels TopLeft")
	debugAttackCSV("	[" & UBound($PixelTopRight) & "] pixels TopRight")
	debugAttackCSV("	[" & UBound($PixelBottomLeft) & "] pixels BottomLeft")
	debugAttackCSV("	[" & UBound($PixelBottomRight) & "] pixels BottomRight")
	If _Sleep($iDelayRespond) Then Return

	;02.03 - MAKE FULL DROP LINE EDGE--------------------------------------------------------------------------------------------------------------------------
	; default inner area edges
	Local $coordLeft = [$ExternalArea[0][0], $ExternalArea[0][1]]
	Local $coordTop = [$ExternalArea[2][0], $ExternalArea[2][1]]
	Local $coordRight = [$ExternalArea[1][0], $ExternalArea[1][1]]
	Local $coordBottom = [$ExternalArea[3][0], $ExternalArea[3][1]]
	Switch $g_aiAttackScrDroplineEdge[$g_iMatchMode]
	Case $DROPLINE_EDGE_FIXED, $DROPLINE_FULL_EDGE_FIXED ; default inner area edges
		; nothing to do here
	Case $DROPLINE_EDGE_FIRST, $DROPLINE_FULL_EDGE_FIRST ; use first red point
		Local $newAxis
		; left
		Local $aPoint1 = GetMaxPoint($PixelTopLeft, 1)
		Local $aPoint2 = GetMinPoint($PixelBottomLeft, 1)
		$newAxis = (($aPoint1[0] < $aPoint2[0]) ? ($aPoint1[0]) : ($aPoint2[0]))
		If Abs($newAxis) < 9999 Then $coordLeft[0] = $newAxis
		; top
		Local $aPoint1 = GetMaxPoint($PixelTopLeft, 0)
		Local $aPoint2 = GetMinPoint($PixelTopRight, 0)
		$newAxis = (($aPoint1[1] < $aPoint2[1]) ? ($aPoint1[1]) : ($aPoint2[1]))
		If Abs($newAxis) < 9999 Then $coordTop[1] = $newAxis
		; right

		Local $aPoint1 = GetMaxPoint($PixelTopRight, 1)
		Local $aPoint2 = GetMinPoint($PixelBottomRight, 1)
		$newAxis = (($aPoint1[0] > $aPoint2[0]) ? ($aPoint1[0]) : ($aPoint2[0]))
		If Abs($newAxis) < 9999 Then $coordRight[0] = $newAxis
		; bottom
		Local $aPoint1 = GetMaxPoint($PixelBottomLeft, 0)
		Local $aPoint2 = GetMinPoint($PixelBottomRight, 0)
		$newAxis = (($aPoint1[1] > $aPoint2[1]) ? ($aPoint1[1]) : ($aPoint2[1]))
		If Abs($newAxis) < 9999 Then $coordBottom[1] = $newAxis
	EndSwitch

	Local $StartEndTopLeft = [$coordLeft, $coordTop]
	Local $StartEndTopRight = [$coordTop, $coordRight]
	Local $StartEndBottomLeft = [$coordLeft, $coordBottom]
	Local $StartEndBottomRight = [$coordBottom, $coordRight]

	SetDebugLog("_GetRedArea, StartEndTopLeft     = " & PixelArrayToString($StartEndTopLeft, ","))
	SetDebugLog("_GetRedArea, StartEndTopRight    = " & PixelArrayToString($StartEndTopRight, ","))
	SetDebugLog("_GetRedArea, StartEndBottomLeft  = " & PixelArrayToString($StartEndBottomLeft, ","))
	SetDebugLog("_GetRedArea, StartEndBottomRight = " & PixelArrayToString($StartEndBottomRight, ","))

	Local $startPoint, $endPoint, $invalid1, $invalid2
	Local $totalInvalid = 0
	$startPoint = $StartEndTopLeft[0]
	$endPoint = $StartEndTopLeft[1]
	Local $PixelTopLeft1 = SortByDistance($PixelTopLeft, $startPoint, $endPoint, $invalid1)
	$startPoint = $StartEndTopLeft[1]
	$endPoint = $StartEndTopLeft[0]
	Local $PixelTopLeft2 = SortByDistance($PixelTopLeft, $startPoint, $endPoint, $invalid2)
	$totalInvalid += (($invalid1 <= $invalid2) ? ($invalid1) : ($invalid2))
	$PixelTopLeft = SortByDistance((($invalid1 <= $invalid2) ? ($PixelTopLeft1) : ($PixelTopLeft2)), $StartEndTopLeft[0], $StartEndTopLeft[1], $invalid1)
	$startPoint = $StartEndTopRight[0]
	$endPoint = $StartEndTopRight[1]
	Local $PixelTopRight1 = SortByDistance($PixelTopRight, $startPoint, $endPoint, $invalid1)
	$startPoint = $StartEndTopRight[1]
	$endPoint = $StartEndTopRight[0]
	Local $PixelTopRight2 = SortByDistance($PixelTopRight, $startPoint, $endPoint, $invalid2)
	$totalInvalid += (($invalid1 <= $invalid2) ? ($invalid1) : ($invalid2))
	$PixelTopRight = SortByDistance((($invalid1 <= $invalid2) ? ($PixelTopRight1) : ($PixelTopRight2)), $StartEndTopRight[0], $StartEndTopRight[1], $invalid1)
	$startPoint = $StartEndBottomLeft[0]
	$endPoint = $StartEndBottomLeft[1]
	Local $PixelBottomLeft1 = SortByDistance($PixelBottomLeft, $startPoint, $endPoint, $invalid1)
	$startPoint = $StartEndBottomLeft[1]
	$endPoint = $StartEndBottomLeft[0]
	Local $PixelBottomLeft2 = SortByDistance($PixelBottomLeft, $startPoint, $endPoint, $invalid2)
	$totalInvalid += (($invalid1 <= $invalid2) ? ($invalid1) : ($invalid2))
	$PixelBottomLeft = SortByDistance((($invalid1 <= $invalid2) ? ($PixelBottomLeft1) : ($PixelBottomLeft2)), $StartEndBottomLeft[0], $StartEndBottomLeft[1], $invalid1)
	$startPoint = $StartEndBottomRight[0]
	$endPoint = $StartEndBottomRight[1]
	Local $PixelBottomRight1 = SortByDistance($PixelBottomRight, $startPoint, $endPoint, $invalid1)
	$startPoint = $StartEndBottomRight[1]
	$endPoint = $StartEndBottomRight[0]
	Local $PixelBottomRight2 = SortByDistance($PixelBottomRight, $startPoint, $endPoint, $invalid2)
	$totalInvalid += (($invalid1 <= $invalid2) ? ($invalid1) : ($invalid2))
	$PixelBottomRight = SortByDistance((($invalid1 <= $invalid2) ? ($PixelBottomRight1) : ($PixelBottomRight2)), $StartEndBottomRight[0], $StartEndBottomRight[1], $invalid1)

	; Pixel further calc

	Local $offsetArcher = 15

	ReDim $PixelRedArea[UBound($PixelTopLeft) + UBound($PixelBottomLeft) + UBound($PixelTopRight) + UBound($PixelBottomRight)]
	ReDim $PixelRedAreaFurther[UBound($PixelRedArea)]

	;If Milking Attack ($g_aiAttackAlgorithm[$DB] = 2) or AttackCSV skip calc of troops further offset (archers drop points for standard attack)
	; but need complete calc if use standard attack after milking attack ($MilkAttackAfterStandardAtk =1) and use redarea ($g_abAttackStdSmartAttack[$MA] = True)
	;If $g_iDebugSetlog = 1 Then Setlog("REDAREA matchmode " & $g_iMatchMode & " atkalgorithm[0] = " & $g_aiAttackAlgorithm[$DB] & " $g_bMilkAttackAfterScriptedAtkEnable = " & $g_bMilkAttackAfterScriptedAtkEnable , $COLOR_DEBUG1)
	Local $a
	If ($g_iMatchMode = $DB And $g_aiAttackAlgorithm[$DB] = 2) Or ($g_iMatchMode = $DB And $ichkUseAttackDBCSV = 1) Or ($g_iMatchMode = $LB And $ichkUseAttackABCSV = 1) Then
		If $g_iDebugSetlog = 1 Then setlog("redarea no calc pixel further (quick)", $COLOR_DEBUG)
		Local $count = 0
		ReDim $PixelTopLeftFurther[UBound($PixelTopLeft)]
		For $i = 0 To UBound($PixelTopLeft) - 1
			$a = $PixelTopLeft[$i]
			$PixelTopLeftFurther[$i] = $a
			$PixelRedArea[$count] = $a
			$PixelRedAreaFurther[$count] = $PixelTopLeftFurther[$i]
			$count += 1
		Next
		ReDim $PixelBottomLeftFurther[UBound($PixelBottomLeft)]
		For $i = 0 To UBound($PixelBottomLeft) - 1
			$PixelBottomLeftFurther[$i] = $PixelBottomLeft[$i]
			$PixelRedArea[$count] = $PixelBottomLeft[$i]
			$PixelRedAreaFurther[$count] = $PixelBottomLeftFurther[$i]
			$count += 1
		Next
		ReDim $PixelTopRightFurther[UBound($PixelTopRight)]
		For $i = 0 To UBound($PixelTopRight) - 1
			$PixelTopRightFurther[$i] = $PixelTopRight[$i]
			$PixelRedArea[$count] = $PixelTopRight[$i]
			$PixelRedAreaFurther[$count] = $PixelTopRightFurther[$i]
			$count += 1
		Next
		ReDim $PixelBottomRightFurther[UBound($PixelBottomRight)]
		For $i = 0 To UBound($PixelBottomRight) - 1
			$PixelBottomRightFurther[$i] = $PixelBottomRight[$i]
			$PixelRedArea[$count] = $PixelBottomRight[$i]
			$PixelRedAreaFurther[$count] = $PixelBottomRightFurther[$i]
			$count += 1
		Next
	Else
		If $g_iDebugSetlog = 1 Then setlog("redarea calc pixel further", $COLOR_DEBUG)
		Local $count = 0
		ReDim $PixelTopLeftFurther[UBound($PixelTopLeft)]
		For $i = 0 To UBound($PixelTopLeft) - 1
			$PixelTopLeftFurther[$i] = _GetOffsetTroopFurther($PixelTopLeft[$i], $eVectorLeftTop, $offsetArcher)
			$PixelRedArea[$count] = $PixelTopLeft[$i]
			$PixelRedAreaFurther[$count] = $PixelTopLeftFurther[$i]
			$count += 1
		Next
		ReDim $PixelBottomLeftFurther[UBound($PixelBottomLeft)]
		For $i = 0 To UBound($PixelBottomLeft) - 1
			$PixelBottomLeftFurther[$i] = _GetOffsetTroopFurther($PixelBottomLeft[$i], $eVectorLeftBottom, $offsetArcher)
			$PixelRedArea[$count] = $PixelBottomLeft[$i]
			$PixelRedAreaFurther[$count] = $PixelBottomLeftFurther[$i]
			$count += 1
		Next
		ReDim $PixelTopRightFurther[UBound($PixelTopRight)]
		For $i = 0 To UBound($PixelTopRight) - 1
			$PixelTopRightFurther[$i] = _GetOffsetTroopFurther($PixelTopRight[$i], $eVectorRightTop, $offsetArcher)
			$PixelRedArea[$count] = $PixelTopRight[$i]
			$PixelRedAreaFurther[$count] = $PixelTopRightFurther[$i]
			$count += 1
		Next
		ReDim $PixelBottomRightFurther[UBound($PixelBottomRight)]
		For $i = 0 To UBound($PixelBottomRight) - 1
			$PixelBottomRightFurther[$i] = _GetOffsetTroopFurther($PixelBottomRight[$i], $eVectorRightBottom, $offsetArcher)
			$PixelRedArea[$count] = $PixelBottomRight[$i]
			$PixelRedAreaFurther[$count] = $PixelBottomRightFurther[$i]
			$count += 1
		Next
	EndIf

	If UBound($PixelTopLeft) < 10 Or GetPixelListDistance($PixelTopLeft, $iMaxAllowedPixelDistance) * 2 < GetPixelDistance($coordTop, $coordLeft) Then
		$PixelTopLeft = _GetVectorOutZone($eVectorLeftTop)
		$PixelTopLeftFurther = $PixelTopLeft
	EndIf
	If UBound($PixelBottomLeft) < 10 Or GetPixelListDistance($PixelBottomLeft, $iMaxAllowedPixelDistance) * 2 < GetPixelDistance($coordBottom, $coordLeft)  Then
		$PixelBottomLeft = _GetVectorOutZone($eVectorLeftBottom)
		$PixelBottomLeftFurther = $PixelBottomLeft
	EndIf
	If UBound($PixelTopRight) < 10 Or GetPixelListDistance($PixelTopRight, $iMaxAllowedPixelDistance) * 2 < GetPixelDistance($coordTop, $coordRight)  Then
		$PixelTopRight = _GetVectorOutZone($eVectorRightTop)
		$PixelTopRightFurther = $PixelTopRight
	EndIf
	If UBound($PixelBottomRight) < 10 Or GetPixelListDistance($PixelBottomRight, $iMaxAllowedPixelDistance) * 2 < GetPixelDistance($coordBottom, $coordRight)  Then
		$PixelBottomRight = _GetVectorOutZone($eVectorRightBottom)
		$PixelBottomRightFurther = $PixelBottomRight
	EndIf

	debugRedArea($nameFunc & "  Size of arr pixel for TopLeft [" & UBound($PixelTopLeft) & "] /  BottomLeft [" & UBound($PixelBottomLeft) & "] /  TopRight [" & UBound($PixelTopRight) & "] /  BottomRight [" & UBound($PixelBottomRight) & "] ")

	debugRedArea($nameFunc & " OUT ")
EndFunc   ;==>_GetRedArea

Func SortRedline($redline, $StartPixel, $EndPixel, $sDelim = ",")
	Local $aPoints = StringSplit($redline, "|", $STR_NOCOUNT)
	Local $size = UBound($aPoints)
	If $size < 2 Then Return StringReplace($redline, $sDelim, "-")
	For $i = 0 To $size - 1
		Local $sPoint = $aPoints[$i]
		Local $aPoint = GetPixel($sPoint, $sDelim)
		If UBound($aPoint) > 1 Then $aPoints[$i] = $aPoint
	Next
	Local $iInvalid = 0
	Local $s = PixelArrayToString(SortByDistance($aPoints, $StartPixel, $EndPixel, $iInvalid))
	Return $s
EndFunc   ;==>SortRedline

Func SortByDistance($PixelList, ByRef $StartPixel, ByRef $EndPixel, ByRef $iInvalid)

	If $g_iDebugSetlog = 1 Then SetDebugLog("SortByDistance Start = " & PixelToString($StartPixel, ',') & " : " & PixelArrayToString($PixelList, ","))
	Local $iMax = UBound($PixelList) - 1
	Local $iMin2 = 0
	Local $iMax2 = $iMax
	Local $Sorted[0]
	Local $PrevPixel = $StartPixel
	Local $PrevDistance = -1
	Local $totalDistances = 0
	Local $totalPoints = 0
	Local $firstPixel = [-1, -1], $lastPixel = [-1, -1]
	Local $avgDistance = 0
	$iInvalid = 0

	For $i = 0 To $iMax
		Local $ClosestIndex = 0
		Local $ClosestDistance = 9999
		Local $ClosestPixel = [0, 0]
		Local $adjustMin = True
		Local $adjustMax = 0
		For $j = $iMin2 To $iMax2
			Local $Pixel = $PixelList[$j]
			If IsArray($Pixel) = 0 Then
				If $adjustMin Then $iMin2 = $j + 1
				If $adjustMax = $iMax Then $adjustMax = $j
				ContinueLoop
			EndIf
			$adjustMin = False
			$adjustMax = $iMax
			Local $d = GetPixelDistance($PrevPixel, $Pixel)
			If $d < $ClosestDistance Then
				$ClosestIndex = $j
				$ClosestDistance = $d
				$ClosestPixel = $Pixel
			EndIf
		Next
		$iMax2 = $adjustMax
		; skip drop points that are too far away
		$avgDistance = $totalDistances / $totalPoints
		Local $invalidPoint = $ClosestPixel[0] < 0 Or $ClosestPixel[1] < 0
		If $invalidPoint Or ($PrevDistance > -1 And ($iMax - $i) / $iMax < 0.20 And ($ClosestDistance > $avgDistance * 10 Or ($ClosestDistance > $avgDistance * 3 And (GetPixelDistance($PrevPixel, $EndPixel) < 25 Or $ClosestDistance > $totalDistances / 2)))) Then
			; skip this pixel
			$iInvalid += 1
		Else
			If $firstPixel[0] = -1 Then $firstPixel = $ClosestPixel
			$lastPixel = $ClosestPixel
			$PrevPixel = $ClosestPixel
			$PrevDistance = $ClosestDistance
			$totalPoints += 1
			$totalDistances += $ClosestDistance
			ReDim $Sorted[UBound($Sorted) + 1]
			$Sorted[UBound($Sorted) - 1] = $ClosestPixel
		EndIf
		$PixelList[$ClosestIndex] = 0
	Next

	; validate start and end pixel
	If $firstPixel[0] > 0 And GetPixelDistance($StartPixel, $firstPixel) > $avgDistance * 3 Then
		$StartPixel[0] = $firstPixel[0]
		$StartPixel[1] = $firstPixel[1]
	EndIf
	If $lastPixel[0] > 0 And GetPixelDistance($EndPixel, $lastPixel) > $avgDistance * 3 Then
		$EndPixel[0] = $lastPixel[0]
		$EndPixel[1] = $lastPixel[1]
	EndIf

	;If $g_iDebugSetlog = 1 Then SetDebugLog("SortByDistance Done : " & PixelArrayToString($Sorted, ","))
	Return $Sorted

EndFunc   ;==>SortByDistance

Func PixelArrayToString(Const ByRef $PixelList, $sDelim = "-")
	If UBound($PixelList) < 1 Then Return ""
	Local $s = ""
	For $i = 0 To UBound($PixelList) - 1
		Local $Pixel = $PixelList[$i]
		$s &= "|" & PixelToString($Pixel, $sDelim)
	Next
	$s = StringMid($s, 2)
	Return $s
EndFunc   ;==>PixelArrayToString

Func PixelToString(Const ByRef $Pixel, $sDelim = "-")
	Return $Pixel[0] & $sDelim & $Pixel[1]
EndFunc   ;==>PixelToString

Func _SortRedline($redline, $sDelim = ",")
	Local $aPoints = StringSplit($redline, "|", $STR_NOCOUNT)
	Local $size = UBound($aPoints)
	If $size < 2 Then Return StringReplace($redline, $sDelim, "-")
	Local $a1[$size + 1][2] = [[0, 0]]
	For $sPoint In $aPoints
		Local $aPoint = GetPixel($sPoint, $sDelim)
		If UBound($aPoint) > 1 Then getRedAreaSideBuildingSetPoint($a1, $aPoint)
	Next
	Local $s = getRedAreaSideBuildingString($a1)
	Return $s
EndFunc   ;==>_SortRedline

Func getRedAreaSideBuildingSetPoint(ByRef $aSide, ByRef $aPoint)
	$aSide[0][0] += 1
	$aSide[$aSide[0][0]][0] = Int($aPoint[0])
	$aSide[$aSide[0][0]][1] = Int($aPoint[1])
EndFunc   ;==>getRedAreaSideBuildingSetPoint

Func getRedAreaSideBuildingString(ByRef $aSide)
	If UBound($aSide) < 2 Or $aSide[0][0] < 1 Then Return ""
	_ArraySort($aSide, 0, 1, $aSide[0][0], 0)
	Local $s = ""
	For $j = 1 To $aSide[0][0]
		$s &= ("|" & $aSide[$j][0] & "-" & $aSide[$j][1])
	Next
	$s = StringMid($s, 2)
	Return $s
EndFunc   ;==>getRedAreaSideBuildingString

Func getRedAreaSideBuilding($redline = $IMGLOCREDLINE)
	;SetDebugLog("getRedAreaSideBuilding: " & $redline)
	Local $c = 0
	Local $a[5]
	Local $aPoints = StringSplit($redline, "|", $STR_NOCOUNT)
	Local $size = UBound($aPoints)
	Local $a1[$size + 1][2] = [[0, 0]] ; Top Left
	Local $a2[$size + 1][2] = [[0, 0]] ; Bottom Left
	Local $a3[$size + 1][2] = [[0, 0]] ; Bottom Right
	Local $a4[$size + 1][2] = [[0, 0]] ; Top Right

	For $sPoint In $aPoints
		Local $aPoint = GetPixel($sPoint, ",")
		If UBound($aPoint) > 1 Then
			$c += 1
			Local $i = GetPixelSection($aPoint[0], $aPoint[1])
			Switch $i
				Case 1 ; Top Left
					getRedAreaSideBuildingSetPoint($a1, $aPoint)
				Case 2 ; Bottom Left
					getRedAreaSideBuildingSetPoint($a2, $aPoint)
				Case 3 ; Bottom Right
					getRedAreaSideBuildingSetPoint($a3, $aPoint)
				Case 4 ; Top Right
					getRedAreaSideBuildingSetPoint($a4, $aPoint)
			EndSwitch
		EndIf
	Next
	$a[0] = $c
	$a[1] = getRedAreaSideBuildingString($a1)
	$a[2] = getRedAreaSideBuildingString($a2)
	$a[3] = getRedAreaSideBuildingString($a3)
	$a[4] = getRedAreaSideBuildingString($a4)
	;SetDebugLog("getRedAreaSideBuilding, Side " & $i & ": " & StringReplace($a[$i], "-", ","))
	Return $a
EndFunc   ;==>getRedAreaSideBuilding

Func GetPixelSection($x, $y)
	Local $isLeft = ($x <= $ExternalArea[2][0])
	Local $isTop = ($y <= $ExternalArea[0][1])
	If $isLeft Then
		If $isTop Then Return 1 ; Top Left
		Return 2 ; Bottom Left
	EndIf
	If $isTop Then Return 4 ; Top Right
	Return 3 ; Bottom Right
EndFunc   ;==>GetPixelSection

Func FindClosestToAxis(Const ByRef $PixelList)
	Local $Axis = [$ExternalArea[2][0], $ExternalArea[0][1]]
	Local $Search[2] = [9999, 9999]
	Local $Points[2]
	For $Pixel In $PixelList
		For $i = 0 To 1
			If Abs($Pixel[$i] - $Axis[$i]) < Abs($Search[$i] - $Axis[$i]) Then
				$Search[$i] = $Pixel[$i]
				$Points[$i] = $Pixel
			EndIf
		Next
	Next
	#cs
		Local $Order
		Local $OrderXY = [0, 1]
		Local $OrderYX = [1, 0]
		Local $FixStartEnd
		Switch $Side
		Case 1 ; Top Left
		$Order = $OrderYX
		Local $FixStartEnd = []
		Case 2 ; Bottom Left
		$Order = $OrderYX
		Case 3 ; Bottom Right
		$Order = $OrderXY
		Case 4 ; Top Right
		$Order = $OrderXY
		EndSwitch
	#ce
	For $i = 0 To 1
		If $Search[$i] = 9999 Then $Search[$i] = $Axis[$i]
	Next
	Return $Search
EndFunc   ;==>FindClosestToAxis
