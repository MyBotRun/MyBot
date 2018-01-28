; #FUNCTION# ====================================================================================================================
; Name ..........:MilkingDetectElixirExtractors.au3
; Description ...:Find all elixr collectors that meet requirements
; Syntax ........:MilkingDetectElixirExtractors()
; Parameters ....:None
; Return values .:None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: Noo
; ===============================================================================================================================

Func MilkingDetectElixirExtractors()
	;detect elixir extractors position according to settings: amount of resource and level.

	If $g_bMilkFarmAttackElixirExtractors And $g_aiCurrentLoot[$eLootElixir] >= $g_iMilkFarmLimitElixir Then
		If $g_bDebugSetlog Then SetDebugLog("skip attack of elixir extractors, current elixir (" & $g_aiCurrentLoot[$eLootElixir] & ") >= limit (" & $g_iMilkFarmLimitElixir & ")", $COLOR_DEBUG)
		Return 0
	Else
		If $g_bDebugSetlog Then SetDebugLog("current elixir (" & $g_aiCurrentLoot[$eLootElixir] & ") < limit (" & $g_iMilkFarmLimitElixir & ")", $COLOR_DEBUG)
	EndIf

	$g_sMilkFarmObjectivesSTR = ""
	Local $MilkFarmAtkPixelListSTR = ""

	Local $hTimer = __TimerInit()
	;03.01 locate extractors
	_CaptureRegion2()
	Local $ElixirVect = StringSplit(GetLocationElixirWithLevel(), "~", 2) ; ["6#527-209" , "6#421-227" , "6#600-264" , "6#299-331" , "6#511-404" , "6#511-453"]
	Local $elixirfounds = UBound($ElixirVect)
	Local $elixirmatch = 0
	Local $elixirdiscard = 0
	Local $redareapointsnearstructure = ""
	For $i = 0 To UBound($ElixirVect) - 1
		If $g_bDebugSetlog Then SetDebugLog($i & " : " & $ElixirVect[$i]) ;[15:51:30] 0 : 2#405-325 -> level 6
		;03.02 check isinsidediamond
		Local $temp = StringSplit($ElixirVect[$i], "#", 2) ;TEMP ["2", "404-325"]
		If UBound($temp) = 2 Then
			Local $pixel = StringSplit($temp[1], "-", 2) ;PIXEL ["404","325"]
			If UBound($pixel) = 2 Then
				;A: check if resource it is inside village.........................................................................
				If isInsideDiamondRedArea($pixel) Then
					;B: check if structure it is near redline ...........(result in  $redareapointsnearstructure ) ...................
					$redareapointsnearstructure = MilkingRedAreaPointsNearStructure("elixir", $temp[0], $temp[1])
					If $redareapointsnearstructure <> "" Then
						If AmountOfResourcesInStructure("elixir", $pixel, $temp[0]) Then
							If $g_bMilkFarmLocateElixir Then
								If $g_sMilkFarmObjectivesSTR <> "" Then $g_sMilkFarmObjectivesSTR &= "|"
								$g_sMilkFarmObjectivesSTR &= "elixir" ;type
								$g_sMilkFarmObjectivesSTR &= "." & $temp[0] ;level
								$g_sMilkFarmObjectivesSTR &= "." & $temp[1] ;coordinate
								$g_sMilkFarmObjectivesSTR &= $redareapointsnearstructure
								$elixirmatch += 1
							Else
								If $g_bDebugSetlog Then SetDebugLog(" - discard #6 skip locate elixir", $COLOR_DEBUG)
								$elixirdiscard += 1
							EndIf
						Else
							If $g_bDebugSetlog Then SetDebugLog(" - discard #5 no match condition % amount of elixir", $COLOR_DEBUG)
							$elixirdiscard += 1
						EndIf
					Else
						If $g_bDebugSetlog Then SetDebugLog(" - discard #4 no redarea points matching conditions", $COLOR_DEBUG)
						$elixirdiscard += 1
					EndIf


					If $g_bDebugResourcesOffset Then ; make debug image for check offset
						Local $resourceoffsetx = 0
						Local $resourceoffsety = 0
						Local $px = StringSplit($g_asMilkFarmOffsetElixir[$temp[0]], "-", 2)
						$resourceoffsetx = $px[0]
						$resourceoffsety = $px[1]
						_CaptureRegion($pixel[0] + $resourceoffsetx - 30, $pixel[1] + $resourceoffsety - 30, $pixel[0] + $resourceoffsetx + 30, $pixel[1] + $resourceoffsety + 30)
						Local $hPen = _GDIPlus_PenCreate(0xFFFFD800, 1)
						Local $multiplier = 2
						Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($g_hBitmap)
						Local $hBrush = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)
						_GDIPlus_GraphicsDrawLine($hGraphic, 0, 30, 60, 30, $hPen)
						_GDIPlus_GraphicsDrawLine($hGraphic, 30, 0, 30, 60, $hPen)
						_GDIPlus_PenDispose($hPen)
						_GDIPlus_BrushDispose($hBrush)
						_GDIPlus_GraphicsDispose($hGraphic)
						DebugImageSave("debugresourcesoffset_" & "elixir" & "_" & $temp[0] & "_", False)
					EndIf


				Else
					If $g_bDebugSetlog Then SetDebugLog(" - discard #3 out of insidediamond", $COLOR_DEBUG)
					$elixirdiscard += 1
				EndIf
			Else
				If $g_bDebugSetlog Then SetDebugLog(" - discard #2 no pixel coordinate", $COLOR_DEBUG)
				$elixirdiscard += 1
			EndIf
		Else
			If $g_bDebugSetlog Then SetDebugLog(" - discard #1 no valid point", $COLOR_DEBUG)
			$elixirdiscard += 1
		EndIf
	Next
	If StringLen($MilkFarmAtkPixelListSTR) > 1 Then
		$MilkFarmAtkPixelListSTR = StringLeft($MilkFarmAtkPixelListSTR, StringLen($MilkFarmAtkPixelListSTR) - 1)
	EndIf
	If $g_bDebugSetlog Then SetDebugLog("> Elixir Extractors to attack list: " & $MilkFarmAtkPixelListSTR, $COLOR_DEBUG)
	Local $htimerLocateElixir = Round(__TimerDiff($hTimer) / 1000, 2)
	If $g_bDebugSetlog Then SetDebugLog("> Elixir Extractors found: " & $elixirfounds & " | match conditions: " & $elixirmatch & " | discard " & $elixirdiscard, $COLOR_INFO)
	If $g_bDebugSetlog Then SetDebugLog("> Elixir Extractors position and %full detectecd in " & $htimerLocateElixir & " seconds", $COLOR_INFO)
	Return $elixirmatch
EndFunc   ;==>MilkingDetectElixirExtractors
