
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
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
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
		If UBound($g_aiPixelTopLeftFurther) > 0 Then
			$newPixelTopLeft = $g_aiPixelTopLeftFurther
		Else
			$newPixelTopLeft = $g_aiPixelTopLeft
		EndIf
		If UBound($g_aiPixelBottomLeftFurther) > 0 Then
			$newPixelBottomLeft = $g_aiPixelBottomLeftFurther
		Else
			$newPixelBottomLeft = $g_aiPixelBottomLeft
		EndIf
		If UBound($g_aiPixelTopRightFurther) > 0 Then
			$newPixelTopRight = $g_aiPixelTopRightFurther
		Else
			$newPixelTopRight = $g_aiPixelTopRight
		EndIf
		If UBound($g_aiPixelBottomRightFurther) Then
			$newPixelBottomRight = $g_aiPixelBottomRightFurther
		Else
			$newPixelBottomRight = $g_aiPixelBottomRight
		EndIf
	Else
		$newPixelTopLeft = $g_aiPixelTopLeft
		$newPixelBottomLeft = $g_aiPixelBottomLeft
		$newPixelTopRight = $g_aiPixelTopRight
		$newPixelBottomRight = $g_aiPixelBottomRight
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
	Local $g_aaiEdgeDropPointsPixelToDrop[4] = [$newPixelBottomRight, $newPixelTopLeft, $newPixelBottomLeft, $newPixelTopRight]
	Return $g_aaiEdgeDropPointsPixelToDrop
EndFunc   ;==>GetPixelDropTroop
