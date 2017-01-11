; #FUNCTION# ====================================================================================================================
; Name ..........: _GetRedArea
; Description ...:  See strategy below
; Syntax ........: _GetRedArea()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
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

Func _GetRedArea($iMode = $REDLINE_IMGLOC)
	$nameFunc = "[_GetRedArea] "
	debugRedArea($nameFunc & " IN")

	Local $colorVariation = 40
	Local $xSkip = 1
	Local $ySkip = 5
	Local $result = 0

	If $iMatchMode = $LB And $iAtkAlgorithm[$LB] = 0 And $iChkDeploySettings[$LB] = 4 Then ; Used for DES Side Attack (need to know the side the DES is on)
		$result = DllCall($hFuncLib, "str", "getRedAreaSideBuilding", "ptr", $hHBitmap2, "int", $xSkip, "int", $ySkip, "int", $colorVariation, "int", $eSideBuildingDES)
		If $debugSetlog Then Setlog("Debug: Redline with DES Side chosen")
	ElseIf $iMatchMode = $LB And $iAtkAlgorithm[$LB] = 0 And $iChkDeploySettings[$LB] = 5 Then ; Used for TH Side Attack (need to know the side the TH is on)
		$result = DllCall($hFuncLib, "str", "getRedAreaSideBuilding", "ptr", $hHBitmap2, "int", $xSkip, "int", $ySkip, "int", $colorVariation, "int", $eSideBuildingTH)
		If $debugSetlog Then Setlog("Debug: Redline with TH Side chosen")
	Else ; Normal getRedArea

		Switch $iMode
			Case $REDLINE_NONE ; No red line
				Local $listPixelBySide = ["NoRedLine", "", "", "", ""]
			Case $REDLINE_IMGLOC_RAW ; ImgLoc raw red line routine
				; ensure redline exists
				SearchRedLines()
				Local $listPixelBySide = getRedAreaSideBuilding()
			Case $REDLINE_IMGLOC ; New ImgLoc based deployable red line routine
				; ensure redline exists
				SearchRedLines()
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
				Local $result = DllCall($hFuncLib, "str", "getRedArea", "ptr", $hHBitmap2, "int", $xSkip, "int", $ySkip, "int", $colorVariation)
		EndSwitch
		If $debugSetlog Then Setlog("Debug: Redline chosen")
	EndIf

	If IsArray($result) Then
		Local $listPixelBySide = StringSplit($result[0], "#")
	EndIf
	$PixelTopLeft = GetPixelSide($listPixelBySide, 1)
	$PixelBottomLeft = GetPixelSide($listPixelBySide, 2)
	$PixelBottomRight = GetPixelSide($listPixelBySide, 3)
	$PixelTopRight = GetPixelSide($listPixelBySide, 4)

	Local $offsetArcher = 15

	ReDim $PixelRedArea[UBound($PixelTopLeft) + UBound($PixelBottomLeft) + UBound($PixelTopRight) + UBound($PixelBottomRight)]
	ReDim $PixelRedAreaFurther[UBound($PixelTopLeft) + UBound($PixelBottomLeft) + UBound($PixelTopRight) + UBound($PixelBottomRight)]

	;If Milking Attack ($iAtkAlgorithm[$DB] = 2) or AttackCSV skip calc of troops further offset (archers drop points for standard attack)
	; but need complete calc if use standard attack after milking attack ($MilkAttackAfterStandardAtk =1) and use redarea ($iChkRedArea[$MA] = 1)
	;If $debugsetlog = 1 Then Setlog("REDAREA matchmode " & $iMatchMode & " atkalgorithm[0] = " & $iAtkAlgorithm[$DB] & " $MilkAttackAfterScriptedAtk = " & $MilkAttackAfterScriptedAtk , $COLOR_DEBUG1)
	If ($iMatchMode = $DB And $iAtkAlgorithm[$DB] = 2) Or ($iMatchMode = $DB And $ichkUseAttackDBCSV = 1) Or ($iMatchMode = $LB And $ichkUseAttackABCSV = 1) Then
		If $debugsetlog = 1 Then setlog("redarea no calc pixel further (quick)", $COLOR_DEBUG)
		$count = 0
		ReDim $PixelTopLeftFurther[UBound($PixelTopLeft)]
		For $i = 0 To UBound($PixelTopLeft) - 1
			$PixelTopLeftFurther[$i] = $PixelTopLeft[$i]
			$PixelRedArea[$count] = $PixelTopLeft[$i]
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
		If $debugsetlog = 1 Then setlog("redarea calc pixel further", $COLOR_DEBUG)
		$count = 0
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

	If UBound($PixelTopLeft) < 10 Then
		$PixelTopLeft = _GetVectorOutZone($eVectorLeftTop)
		$PixelTopLeftFurther = $PixelTopLeft
	EndIf
	If UBound($PixelBottomLeft) < 10 Then
		$PixelBottomLeft = _GetVectorOutZone($eVectorLeftBottom)
		$PixelBottomLeftFurther = $PixelBottomLeft
	EndIf
	If UBound($PixelTopRight) < 10 Then
		$PixelTopRight = _GetVectorOutZone($eVectorRightTop)
		$PixelTopRightFurther = $PixelTopRight
	EndIf
	If UBound($PixelBottomRight) < 10 Then
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

	If $debugSetlog = 1 Then SetDebugLog("SortByDistance Start = " & PixelToString($StartPixel, ',') & " : " & PixelArrayToString($PixelList, ","))
	Local $iMax = UBound($PixelList) - 1
	Local $iMin2 = 0
	Local $iMax2 = $iMax
	Local $Sorted[$iMax + 1]
	Local $PrevPixel = $StartPixel
	Local $PrevDistance = -1
	Local $totalDistances = 0
	Local $totalPoints = 0
	Local $firstPixel = [-1, -1], $lastPixel = [-1, 1]
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
		Local $avgDistance = $totalDistances / $totalPoints
		Local $invalidPoint = $ClosestPixel[0] < 0 And $ClosestPixel[1] < 0
		If $invalidPoint Or ($PrevDistance > -1 And ($iMax - $i) / $iMax < 0.20 And ($ClosestDistance > $avgDistance * 10 Or ($ClosestDistance > $avgDistance * 3 And (GetPixelDistance($PrevPixel, $EndPixel) < 25 Or $ClosestDistance > $totalDistances / 2)))) Then
			; skip this pixel
			$iInvalid += 1
			If $invalidPoint = False Then
				$ClosestPixel[0] = -$ClosestPixel[0]
				$ClosestPixel[1] = -$ClosestPixel[1]
			EndIf
		Else
			If $firstPixel[0] = -1 Then $firstPixel = $ClosestPixel
			$lastPixel = $ClosestPixel
			$PrevPixel = $ClosestPixel
			$PrevDistance = $ClosestDistance
			$totalPoints += 1
			$totalDistances += $ClosestDistance
		EndIf
		$Sorted[$i] = $ClosestPixel
		$PixelList[$ClosestIndex] = 0
	Next

	; validate start and end pixel
	If GetPixelDistance($StartPixel, $firstPixel) > $avgDistance * 3 Then
		$StartPixel[0] = $firstPixel[0]
		$StartPixel[1] = $firstPixel[1]
	EndIf
	If GetPixelDistance($EndPixel, $lastPixel) > $avgDistance * 3 Then
		$EndPixel[0] = $lastPixel[0]
		$EndPixel[1] = $lastPixel[1]
	EndIf

	If $debugSetlog = 1 Then SetDebugLog("SortByDistance Done : " & PixelArrayToString($Sorted, ","))
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
