
; #FUNCTION# ====================================================================================================================
; Name ..........: GetPixelDropTroop
; Description ...:
; Syntax ........: GetPixelDropTroop($troop, $number, $slotsPerEdge)
; Parameters ....: $troop               - a dll struct value.
;                  $number              - a general number value.
;                  $slotsPerEdge        - a string value.
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func GetPixelDropTroop($troop, $number, $slotsPerEdge)
	Local $newPixelTopLeft
	Local $newPixelBottomLeft
	Local $newPixelTopRight
	Local $newPixelBottomRight

	If ($troop = $eArch Or $troop = $eWiza Or $troop = $eMini Or $troop = $eBarb) Then
	  if Ubound($PixelTopLeftFurther) >0 then
		 $newPixelTopLeft = $PixelTopLeftFurther
	  Else
		 $newPixelTopLeft = $PixelTopLeft
	  EndIf
	  If Ubound($PixelBottomLeftFurther) >0 Then
		 $newPixelBottomLeft = $PixelBottomLeftFurther
	  Else
		 $newPixelBottomLeft = $PixelBottomLeft
	  EndIf
	  If Ubound( $PixelTopRightFurther) >0 Then
		 $newPixelTopRight = $PixelTopRightFurther
	  Else
		 $newPixelTopRight = $PixelTopRight
	  EndIf
	  If Ubound( $PixelBottomRightFurther) then
		 $newPixelBottomRight = $PixelBottomRightFurther
	  Else
		 $newPixelBottomRight = $PixelBottomRight
	  EndIf
	Else
		$newPixelTopLeft = $PixelTopLeft
		$newPixelBottomLeft = $PixelBottomLeft
		$newPixelTopRight = $PixelTopRight
		$newPixelBottomRight = $PixelBottomRight
	EndIf

	If ($slotsPerEdge = 1) Then
		$newPixelTopLeft = GetVectorPixelAverage($newPixelTopLeft, 0)
		$newPixelBottomLeft = GetVectorPixelAverage($newPixelBottomLeft, 1)
		$newPixelTopRight = GetVectorPixelAverage($newPixelTopRight, 1)
		$newPixelBottomRight = GetVectorPixelAverage($newPixelBottomRight, 0)
	ElseIf ($slotsPerEdge = 2) Then
		$newPixelTopLeft = GetVectorPixelOnEachSide($newPixelTopLeft, 0)
		$newPixelBottomLeft = GetVectorPixelOnEachSide($newPixelBottomLeft, 1)
		$newPixelTopRight = GetVectorPixelOnEachSide($newPixelTopRight, 1)
		$newPixelBottomRight = GetVectorPixelOnEachSide($newPixelBottomRight, 0)
	Else
		debugRedArea("GetPixelDropTroop :  $slotsPerEdge [" & $slotsPerEdge & "] ")
		$newPixelTopLeft = GetVectorPixelToDeploy($newPixelTopLeft, 0, $slotsPerEdge)
		$newPixelBottomLeft = GetVectorPixelToDeploy($newPixelBottomLeft, 1, $slotsPerEdge)
		$newPixelTopRight = GetVectorPixelToDeploy($newPixelTopRight, 1, $slotsPerEdge)
		$newPixelBottomRight = GetVectorPixelToDeploy($newPixelBottomRight, 0, $slotsPerEdge)

	EndIf
	Local $edgesPixelToDrop[4] = [$newPixelBottomRight, $newPixelTopLeft, $newPixelBottomLeft, $newPixelTopRight]
	Return $edgesPixelToDrop
EndFunc   ;==>GetPixelDropTroop
