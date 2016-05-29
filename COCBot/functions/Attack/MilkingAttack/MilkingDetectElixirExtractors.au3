; #FUNCTION# ====================================================================================================================
; Name ..........:MilkingDetectElixirExtractors.au3
; Description ...:Find all elixr collectors that meet requirements
; Syntax ........:MilkingDetectElixirExtractors()
; Parameters ....:None
; Return values .:None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: Noo
; ===============================================================================================================================

Func MilkingDetectElixirExtractors()
	;detect elixir extractors position according to settings: amount of resource and level.

	If $MilkFarmAttackElixirExtractors = 1 and $iElixirCurrent >= $MilkFarmLimitElixir Then
		If $debugsetlog=1 Then setlog("skip attack of elixir extractors, current elixir (" & $iElixirCurrent & ") >= limit (" & $MilkFarmLimitElixir & ")",$color_purple)
		return 0
	Else
		If $debugsetlog=1 Then setlog("current elixir (" & $iElixirCurrent & ") < limit (" & $MilkFarmLimitElixir & ")",$color_purple)
	EndIf

	$MilkFarmObjectivesSTR = ""
	Local $MilkFarmAtkPixelListSTR = ""

	Local $hTimer = TimerInit()
	;03.01 locate extractors
	_CaptureRegion2()
	Local $ElixirVect = StringSplit(GetLocationElixirWithLevel(), "~", 2) ; ["6#527-209" , "6#421-227" , "6#600-264" , "6#299-331" , "6#511-404" , "6#511-453"]
	Local $elixirfounds = UBound($ElixirVect)
	Local $elixirmatch = 0
	Local $elixirdiscard = 0
	Local $redareapointsnearstructure = ""
	For $i = 0 To UBound($ElixirVect) - 1
		If $debugsetlog = 1 Then Setlog($i & " : " & $ElixirVect[$i]) ;[15:51:30] 0 : 2#405-325 -> level 6
		;03.02 check isinsidediamond
		Local $temp = StringSplit($ElixirVect[$i], "#", 2) ;TEMP ["2", "404-325"]
		If UBound($temp) = 2 Then
			$pixel = StringSplit($temp[1], "-", 2) ;PIXEL ["404","325"]
			If UBound($pixel) = 2 Then
				;A: check if resource it is inside village.........................................................................
				If isInsideDiamondRedArea($pixel) Then
;~ 					;B: check if amount of resource it is enough...................................................................
;~ 					If AmountOfResourcesInStructure("elixir", $pixel, $temp[0]) Then
;~ 						$MilkFarmAtkPixelListSTR &= $temp[1] & "|"
;~ 						;C: insert and add redarea points..........................................................................
;~ 						If $MilkFarmLocateElixir = 1 Then
;~ 						   Local $qtyofpointsdetectedaroundstructure = 0
;~ 						   $qtyofpointsdetectedaroundstructure = MilkFarmObjectivesSTR_INSERT("elixir", $temp[0], $temp[1])
;~ 						   if $qtyofpointsdetectedaroundstructure >0 then
;~ 							  $elixirmatch += 1
;~ 						   Else
;~   							  If $debugsetlog = 1 Then Setlog(" - discard #6 no redarea points matching conditions", $color_purple)
;~ 							  $elixirdiscard += 1
;~ 						   EndIf
;~ 						Else
;~ 						   If $debugsetlog = 1 Then Setlog(" - discard #5 skip locate elixir", $color_purple)
;~ 						   $elixirdiscard += 1
;~ 						EndIf
;~ 					Else
;~ 						If $debugsetlog = 1 Then Setlog(" - discard #4 no match conditions", $color_purple)
;~ 						$elixirdiscard += 1
;~ 					EndIf
					;B: check if structure it is near redline ...........(result in  $redareapointsnearstructure ) ...................
					 $redareapointsnearstructure = MilkingRedAreaPointsNearStructure("elixir", $temp[0], $temp[1])
					 ;if $debugsetlog = 1 Then Setlog("structure elixir (" & $pixel[0] &"," & $pixel[1] & ") redarea points match: >>>" & $redareapointsnearstructure & "<<<",$color_purple)
					 if $redareapointsnearstructure <>"" Then
						If AmountOfResourcesInStructure("elixir", $pixel, $temp[0]) Then
						   If $MilkFarmLocateElixir = 1 Then
							  if $MilkFarmObjectivesSTR <> "" then 		  $MilkFarmObjectivesSTR &= "|"
							  $MilkFarmObjectivesSTR &= "elixir"			;type
							  $MilkFarmObjectivesSTR &= "." & $temp[0]		;level
							  $MilkFarmObjectivesSTR &= "." & $temp[1]		;coordinate
							  $MilkFarmObjectivesSTR &= $redareapointsnearstructure
							  $elixirmatch += 1
						   Else
							  If $debugsetlog = 1 Then Setlog(" - discard #6 skip locate elixir", $color_purple)
							  $elixirdiscard += 1
						   EndIf
						Else
						   If $debugsetlog = 1 Then Setlog(" - discard #5 no match condition % amount of elixir", $color_purple)
						   $elixirdiscard += 1
						EndIf
					 Else
						If $debugsetlog = 1 Then Setlog(" - discard #4 no redarea points matching conditions", $color_purple)
						$elixirdiscard += 1
					 EndIf


					If $debugresourcesoffset = 1 Then ; make debug image for check offset
						Local $resourceoffsetx = 0
						Local $resourceoffsety = 0
						Local $px = StringSplit($MilkFarmOffsetElixir[$temp[0]], "-", 2)
						$resourceoffsetx = $px[0]
						$resourceoffsety = $px[1]
						_CaptureRegion($pixel[0] + $resourceoffsetx - 30, $pixel[1] + $resourceoffsety - 30, $pixel[0] + $resourceoffsetx + 30, $pixel[1] + $resourceoffsety + 30)
						Local $hPen = _GDIPlus_PenCreate(0xFFFFD800, 1)
						Local $multiplier = 2
						Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($hBitmap)
						Local $hBrush = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)
						_GDIPlus_GraphicsDrawLine($hGraphic, 0, 30, 60, 30, $hPen)
						_GDIPlus_GraphicsDrawLine($hGraphic, 30, 0, 30, 60, $hPen)
						_GDIPlus_PenDispose($hPen)
						_GDIPlus_BrushDispose($hBrush)
						_GDIPlus_GraphicsDispose($hGraphic)
						DebugImageSave("debugresourcesoffset_" & "elixir" & "_" & $temp[0] & "_",  False)
					EndIf


				Else
					If $debugsetlog = 1 Then Setlog(" - discard #3 out of insidediamond", $color_purple)
					$elixirdiscard += 1
				EndIf
			Else
				If $debugsetlog = 1 Then Setlog(" - discard #2 no pixel coordinate", $color_purple)
				$elixirdiscard += 1
			EndIf
		Else
			If $debugsetlog = 1 Then Setlog(" - discard #1 no valid point", $color_purple)
			$elixirdiscard += 1
		EndIf
	Next
	If StringLen($MilkFarmAtkPixelListSTR) > 1 Then
		$MilkFarmAtkPixelListSTR = StringLeft($MilkFarmAtkPixelListSTR, StringLen($MilkFarmAtkPixelListSTR) - 1)
	EndIf
	If $debugsetlog = 1 Then Setlog("> Elixir Extractors to attack list: " & $MilkFarmAtkPixelListSTR, $color_purple)
	Local $htimerLocateElixir = Round(TimerDiff($hTimer) / 1000, 2)
	If $debugsetlog = 1 Then Setlog("> Elixir Extractors found: " & $elixirfounds & " | match conditions: " & $elixirmatch & " | discard " & $elixirdiscard, $color_blue)
	If $debugsetlog = 1 Then SetLog("> Elixir Extractors position and %full detectecd in " & $htimerLocateElixir & " seconds", $color_blue)
	Return $elixirmatch
EndFunc   ;==>MilkingDetectElixirExtractors
