; #FUNCTION# ====================================================================================================================
; Name ..........:MilkingDetectMineExtractors.au3
; Description ...:Find all gold mines that meet requirements
; Syntax ........:MilkingDetectMineExtractors()
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

Func MilkingDetectMineExtractors()

	If $g_bMilkFarmAttackGoldMines and $iGoldCurrent >= $g_iMilkFarmLimitGold Then
		If $g_iDebugSetlog = 1 Then setlog("skip attack of gold mines, current gold (" & $iGoldCurrent & ") >= limit (" & $g_iMilkFarmLimitGold & ")",$COLOR_DEBUG)
		Return 0
	Else
		If $g_iDebugSetlog = 1 Then setlog("current gold (" & $iGoldCurrent & ") < limit (" & $g_iMilkFarmLimitGold & ")",$COLOR_DEBUG)
	EndIf


	Local $MilkFarmAtkPixelListMINESTR = ""
	If $g_bMilkFarmLocateMine Then
		Local $hTimer = TimerInit()
		;03.01 locate extractors
		;_CaptureRegion2(80, 70, 785, 530)
		_CaptureRegion2()
		Local $MineVect = StringSplit(GetLocationMineWithLevel(), "~", 2) ; ["6#527-209" , "6#421-227" , "6#600-264" , "6#299-331" , "6#511-404" , "6#511-453"]
		Local $Minefounds = 0
		Local $Minematch = 0
		Local $Minediscard = 0
		For $i = 0 To UBound($MineVect) - 1
			;If $g_iDebugSetlog=1 Then Setlog($i & " : " & $MineVect[$i])    			;[15:51:30] 0 : 2#405-325 -> level 6
			;03.02 check isinsidediamond
			Local $temp = StringSplit($MineVect[$i], "#", 2) ;TEMP ["2", "404-325"]
			If UBound($temp) = 2 Then
				Local $pixel = StringSplit($temp[1], "-", 2) ;PIXEL ["404","325"]
				If UBound($pixel) = 2 Then
					Local $tempPixel[2] = [$pixel[0] , $pixel[1] ]
					$pixel = $tempPixel
					$temp[1] = String($pixel[0] & "-" & $pixel[1])
					If isInsideDiamondRedArea($pixel) Then
						$Minefounds += 1
						;debug if need
						If $g_iDebugResourcesOffset = 1 Then
							Local $level = $temp[0]
							Local $type = "mine"
							Local $resourceoffsetx = 0
							Local $resourceoffsety = 0
							Local $px = StringSplit($MilkFarmOffsetMine[$level], "-", 2)
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
						If AmountOfResourcesInStructure("mine", $pixel, $temp[0]) Then
							$MilkFarmAtkPixelListMINESTR &= $temp[1] & "|"
							If MilkFarmObjectivesSTR_INSERT("gomine", $temp[0], $temp[1]) Then
								$Minematch += 1
							Else
								$Minediscard += 1
							EndIf
						Else
							If $g_iDebugSetlog = 1 Then Setlog(" - discard #4 no match conditions", $COLOR_DEBUG)
							$Minediscard += 1
						EndIf
					Else
						If $g_iDebugSetlog = 1 Then Setlog(" - discard #3 out of insidediamond", $COLOR_DEBUG)
					EndIf
				Else
					If $g_iDebugSetlog = 1 Then Setlog(" - discard #2 no pixel coordinate", $COLOR_DEBUG)
				EndIf
			Else
				If $g_iDebugSetlog = 1 Then Setlog(" - discard #1 no valid point", $COLOR_DEBUG)
				$Minediscard += 1
			EndIf
		Next
		If StringLen($MilkFarmAtkPixelListMINESTR) > 1 Then $MilkFarmAtkPixelListMINESTR = StringLeft($MilkFarmAtkPixelListMINESTR, StringLen($MilkFarmAtkPixelListMINESTR) - 1)
		If $g_iDebugSetlog = 1 Then Setlog("> Mine Extractors to attack list: " & $MilkFarmAtkPixelListMINESTR, $COLOR_DEBUG)
		Local $htimerLocateMine = Round(TimerDiff($hTimer) / 1000, 2)
		If $g_iDebugSetlog = 1 Then Setlog("> Mine Extractors found: " & $Minefounds & " | match conditions: " & $Minematch & " | discard " & $Minediscard, $COLOR_INFO)
		If $g_iDebugSetlog = 1 Then SetLog("> Mine Extractors position detectecd in " & $htimerLocateMine & " seconds", $COLOR_INFO)
		Return $Minematch
	Else
		Return 0
	EndIf
EndFunc   ;==>MilkingDetectMineExtractors
