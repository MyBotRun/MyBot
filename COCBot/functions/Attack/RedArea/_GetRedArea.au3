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

Func _GetRedArea()
	$nameFunc = "[_GetRedArea] "
	debugRedArea($nameFunc & " IN")

	Local $colorVariation = 40
	Local $xSkip = 1
	Local $ySkip = 5

	If $iMatchMode = $LB And $iChkDeploySettings[$LB] = 4 Then ; Used for DES Side Attack (need to know the side the DES is on)
		Local $result = DllCall($hFuncLib, "str", "getRedAreaSideBuilding", "ptr", $hBitmapFirst, "int", $xSkip, "int", $ySkip, "int", $colorVariation, "int", $eSideBuildingDES)
		If $debugSetlog Then Setlog("Debug: Redline with DES Side chosen")
	ElseIf $iMatchMode = $LB And $iChkDeploySettings[$LB] = 5 Then ; Used for TH Side Attack (need to know the side the TH is on)
		Local $result = DllCall($hFuncLib, "str", "getRedAreaSideBuilding", "ptr", $hBitmapFirst, "int", $xSkip, "int", $ySkip, "int", $colorVariation, "int", $eSideBuildingTH)
		If $debugSetlog Then Setlog("Debug: Redline with TH Side chosen")
	Else ; Normal getRedArea
		Local $result = DllCall($hFuncLib, "str", "getRedArea", "ptr", $hBitmapFirst, "int", $xSkip, "int", $ySkip, "int", $colorVariation)
		If $debugSetlog Then Setlog("Debug: Redline chosen")
	EndIf
	Local $listPixelBySide = StringSplit($result[0], "#")
	$PixelTopLeft = GetPixelSide($listPixelBySide, 1)
	$PixelBottomLeft = GetPixelSide($listPixelBySide, 2)
	$PixelBottomRight = GetPixelSide($listPixelBySide, 3)
	$PixelTopRight = GetPixelSide($listPixelBySide, 4)

	Local $offsetArcher = 15

	ReDim $PixelRedArea[UBound($PixelTopLeft) + UBound($PixelBottomLeft) + UBound($PixelTopRight) + UBound($PixelBottomRight)]
	ReDim $PixelRedAreaFurther[UBound($PixelTopLeft) + UBound($PixelBottomLeft) + UBound($PixelTopRight) + UBound($PixelBottomRight)]


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
	debugRedArea("PixelTopLeftFurther " + UBound($PixelTopLeftFurther))


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


