; #FUNCTION# ====================================================================================================================
; Name ..........:MilkingDetectDarkExtractors
; Description ...:Find all dark drills that meet requirements
; Syntax ........:MilkingDetectDarkExtractors()
; Parameters ....:None
; Return values .:None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: Noo
; ===============================================================================================================================

Func MilkingDetectDarkExtractors()

	If $g_bMilkFarmAttackDarkDrills And Number($g_aiCurrentLoot[$eLootDarkElixir]) >= Number($g_iMilkFarmLimitDark) Then
		If $g_bDebugSetlog And $g_bMilkFarmAttackDarkDrills Then SetLog("skip attack of dark drills, current dark (" & $g_aiCurrentLoot[$eLootDarkElixir] & ") >= limit (" & $g_iMilkFarmLimitDark & ")", $COLOR_DEBUG)
		If $g_bDebugSetlog And $g_bMilkFarmAttackDarkDrills = False Then SetLog("skip attack of dark drills", $COLOR_DEBUG)
		Return 0
	Else
		If $g_bDebugSetlog Then SetDebugLog("current dark (" & $g_aiCurrentLoot[$eLootDarkElixir] & ") < limit (" & $g_iMilkFarmLimitDark & ")", $COLOR_DEBUG)
	EndIf


	Local $MilkFarmAtkPixelListDRILLSTR = ""
	If $g_bMilkFarmLocateDrill Then
		Local $hTimer = __TimerInit()
		;03.01 locate extractors
		_CaptureRegion2()
		Local $DrillVect = StringSplit(GetLocationDarkElixirWithLevel(), "~", 2) ; ["6#527-209" , "6#421-227" , "6#600-264" , "6#299-331" , "6#511-404" , "6#511-453"]
		Local $Drillfounds = UBound($DrillVect)
		Local $Drillmatch = 0
		Local $Drilldiscard = 0
		For $i = 0 To UBound($DrillVect) - 1
			;03.02 check isinsidediamond
			Local $temp = StringSplit($DrillVect[$i], "#", 2) ;TEMP ["2", "404-325"]
			If UBound($temp) = 2 Then
				Local $pixel = StringSplit($temp[1], "-", 2) ;PIXEL ["404","325"]
				If UBound($pixel) = 2 Then
					If isInsideDiamondRedArea($pixel) Then
						;debug if need
						If $g_bDebugResourcesOffset Then
							Local $level = $temp[0]
							Local $type = "drill"
							Local $resourceoffsetx = 0
							Local $resourceoffsety = 0
							Local $px = StringSplit($g_asMilkFarmOffsetDark[$level], "-", 2)
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
							DebugImageSave("debugresourcesoffset_" & $type & "_" & $level & "_", False)
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
							If $g_bDebugSetlog Then SetDebugLog(" - discard #4 no match conditions", $COLOR_DEBUG)
							$Drilldiscard += 1
						EndIf
					Else
						If $g_bDebugSetlog Then SetDebugLog(" - discard #3 out of insidediamond", $COLOR_DEBUG)
						$Drilldiscard += 1
					EndIf
				Else
					If $g_bDebugSetlog Then SetDebugLog(" - discard #2 no pixel coordinate", $COLOR_DEBUG)
					$Drilldiscard += 1
				EndIf
			Else
				If $g_bDebugSetlog Then SetDebugLog(" - discard #1 no valid point", $COLOR_DEBUG)
				$Drilldiscard += 1
			EndIf
		Next
		If StringLen($MilkFarmAtkPixelListDRILLSTR) > 1 Then $MilkFarmAtkPixelListDRILLSTR = StringLeft($MilkFarmAtkPixelListDRILLSTR, StringLen($MilkFarmAtkPixelListDRILLSTR) - 1)
		If $g_bDebugSetlog Then SetDebugLog("> Drill Extractors to attack list: " & $MilkFarmAtkPixelListDRILLSTR, $COLOR_DEBUG)
		Local $htimerLocateDrill = Round(__TimerDiff($hTimer) / 1000, 2)
		If $g_bDebugSetlog Then SetDebugLog("> Drill Extractors found: " & $Drillfounds & " | match conditions: " & $Drillmatch & " | discard " & $Drilldiscard, $COLOR_INFO)
		If $g_bDebugSetlog Then SetDebugLog("> Drill Extractors position detectecd in " & $htimerLocateDrill & " seconds", $COLOR_INFO)
		Return $Drillmatch
	Else
		Return 0
	EndIf



EndFunc   ;==>MilkingDetectDarkExtractors
