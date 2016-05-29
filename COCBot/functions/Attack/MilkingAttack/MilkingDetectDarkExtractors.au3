; #FUNCTION# ====================================================================================================================
; Name ..........:MilkingDetectDarkExtractors
; Description ...:Find all dark drills that meet requirements
; Syntax ........:MilkingDetectDarkExtractors()
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

Func MilkingDetectDarkExtractors()

	If $MilkFarmAttackDarkDrills = 1 and Number($iDarkCurrent) >= number($MilkFarmLimitDark) Then
		If $debugsetlog=1  and $MilkFarmAttackDarkDrills = 1 Then setlog("skip attack of dark drills, current dark (" & $iDarkCurrent & ") >= limit (" & $MilkFarmLimitDark & ")",$color_purple)
		If $debugsetlog=1  and $MilkFarmAttackDarkDrills = 0 Then setlog("skip attack of dark drills",$color_purple)
		return 0
	Else
		If $debugsetlog=1 Then setlog("current dark (" & $iDarkCurrent & ") < limit (" & $MilkFarmLimitDark & ")",$color_purple)
	EndIf


	Local $MilkFarmAtkPixelListDRILLSTR = ""
	If $MilkFarmLocateDrill = 1 Then
		Local $hTimer = TimerInit()
		;03.01 locate extractors
		_CaptureRegion2()
		Local $DrillVect = StringSplit(GetLocationDarkElixirWithLevel(), "~", 2) ; ["6#527-209" , "6#421-227" , "6#600-264" , "6#299-331" , "6#511-404" , "6#511-453"]
		Local $Drillfounds = UBound($DrillVect)
		Local $Drillmatch = 0
		Local $Drilldiscard = 0
		For $i = 0 To UBound($DrillVect) - 1
			;If $debugsetlog=1 Then Setlog($i & " : " & $DrillVect[$i])    			;[15:51:30] 0 : 2#405-325 -> level 6
			;03.02 check isinsidediamond
			Local $temp = StringSplit($DrillVect[$i], "#", 2) ;TEMP ["2", "404-325"]
			If UBound($temp) = 2 Then
				$pixel = StringSplit($temp[1], "-", 2) ;PIXEL ["404","325"]
				If UBound($pixel) = 2 Then
					If isInsideDiamondRedArea($pixel) Then
						;debug if need
						If $debugresourcesoffset = 1 Then
							Local $level = $temp[0]
							Local $type = "drill"
							Local $resourceoffsetx = 0
							Local $resourceoffsety = 0
							Local $px = StringSplit($MilkFarmOffsetDark[$level], "-", 2)
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
							DebugImageSave("debugresourcesoffset_" & $type & "_" & $level & "_" , False)
						EndIf
						;ok add if conditions satisfied
						If AmountOfResourcesInStructure("drill", $pixel, $temp[0]) Then
							$MilkFarmAtkPixelListDRILLSTR &= $temp[1] & "|"
							If MilkFarmObjectivesSTR_INSERT("ddrill", $temp[0], $temp[1]) > 0 Then
								$Drillmatch += 1
							Else
								$Drilldiscard += 1
							EndIf
						Else
							If $debugsetlog = 1 Then Setlog(" - discard #4 no match conditions", $color_purple)
							$Drilldiscard += 1
						EndIf
					Else
						If $debugsetlog = 1 Then Setlog(" - discard #3 out of insidediamond", $color_purple)
						$Drilldiscard += 1
					EndIf
				Else
					If $debugsetlog = 1 Then Setlog(" - discard #2 no pixel coordinate", $color_purple)
					$Drilldiscard += 1
				EndIf
			Else
				If $debugsetlog = 1 Then Setlog(" - discard #1 no valid point", $color_purple)
				$Drilldiscard += 1
			EndIf
		Next
		If StringLen($MilkFarmAtkPixelListDRILLSTR) > 1 Then $MilkFarmAtkPixelListDRILLSTR = StringLeft($MilkFarmAtkPixelListDRILLSTR, StringLen($MilkFarmAtkPixelListDRILLSTR) - 1)
		If $debugsetlog = 1 Then Setlog("> Drill Extractors to attack list: " & $MilkFarmAtkPixelListDRILLSTR, $color_purple)
		Local $htimerLocateDrill = Round(TimerDiff($hTimer) / 1000, 2)
		If $debugsetlog = 1 Then Setlog("> Drill Extractors found: " & $Drillfounds & " | match conditions: " & $Drillmatch & " | discard " & $Drilldiscard, $color_blue)
		If $debugsetlog = 1 Then SetLog("> Drill Extractors position detectecd in " & $htimerLocateDrill & " seconds", $color_blue)
		Return $Drillmatch
	Else
		Return 0
	EndIf



EndFunc   ;==>MilkingDetectDarkExtractors
