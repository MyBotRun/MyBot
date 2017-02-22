; #FUNCTION# ====================================================================================================================
; Name ..........:
; Description ...: This file contens the attack algorithm SCRIPTED
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $MAINSIDE = "BOTTOM-RIGHT"
Global $FRONT_LEFT = "BOTTOM-RIGHT-DOWN"
Global $FRONT_RIGHT = "BOTTOM-RIGHT-UP"
Global $RIGHT_FRONT = "TOP-RIGHT-DOWN"
Global $RIGHT_BACK = "TOP-RIGHT-UP"
Global $LEFT_FRONT = "BOTTOM-LEFT-DOWN"
Global $LEFT_BACK = "BOTTOM-LEFT-UP"
Global $BACK_LEFT = "TOP-LEFT-DOWN"
Global $BACK_RIGHT = "TOP-LEFT-UP"


Global $PixelTopLeftDropLine
Global $PixelTopRightDropLine
Global $PixelBottomLeftDropLine
Global $PixelBottomRightDropLine
Global $PixelTopLeftUPDropLine
Global $PixelTopLeftDOWNDropLine
Global $PixelTopRightUPDropLine
Global $PixelTopRightDOWNDropLine
Global $PixelBottomLeftUPDropLine
Global $PixelBottomLeftDOWNDropLine
Global $PixelBottomRightUPDropLine
Global $PixelBottomRightDOWNDropLine

Local $DeployableLRTB = [0, $g_iGAME_WIDTH - 1, 0, 626]
Local $DiamandAdjX = -28
Local $DiamandAdjY = -24
Local $OuterDiamondLeft = -18 - $DiamandAdjX, $OuterDiamondRight = 857 + $DiamandAdjX, $OuterDiamondTop = 20 - $DiamandAdjY, $OuterDiamondBottom = 679 + $DiamandAdjY ; set the diamond shape based on reference village
Local $DiamondMiddleX = ($OuterDiamondLeft + $OuterDiamondRight) / 2
Local $DiamondMiddleY = ($OuterDiamondTop + $OuterDiamondBottom) / 2
Local $InnerDiamandDiffX = 55 + $DiamandAdjX ; set the diamond shape based on reference village
Local $InnerDiamandDiffY = 47 + $DiamandAdjY; set the diamond shape based on reference village
Local $InnerDiamondLeft = $OuterDiamondLeft + $InnerDiamandDiffX, $InnerDiamondRight = $OuterDiamondRight - $InnerDiamandDiffX, $InnerDiamondTop = $OuterDiamondTop + $InnerDiamandDiffY, $InnerDiamondBottom = $OuterDiamondBottom - $InnerDiamandDiffY

Global $CocDiamondECD = "ECD"
Global $ExternalArea[8][3]
Global $ExternalAreaRef[8][3] = [ _
		[$OuterDiamondLeft, $DiamondMiddleY, "LEFT"], _
		[$OuterDiamondRight, $DiamondMiddleY, "RIGHT"], _
		[$DiamondMiddleX, $OuterDiamondTop, "TOP"], _
		[$DiamondMiddleX, $OuterDiamondBottom, "BOTTOM"], _
		[$OuterDiamondLeft + ($DiamondMiddleX - $OuterDiamondLeft) / 2, $OuterDiamondTop + ($DiamondMiddleY - $OuterDiamondTop) / 2, "TOP-LEFT"], _
		[$DiamondMiddleX + ($OuterDiamondRight - $DiamondMiddleX) / 2, $OuterDiamondTop + ($DiamondMiddleY - $OuterDiamondTop) / 2, "TOP-RIGHT"], _
		[$OuterDiamondLeft + ($DiamondMiddleX - $OuterDiamondLeft) / 2, $DiamondMiddleY + ($OuterDiamondBottom - $DiamondMiddleY) / 2, "BOTTOM-LEFT"], _
		[$DiamondMiddleX + ($OuterDiamondRight - $DiamondMiddleX) / 2, $DiamondMiddleY + ($OuterDiamondBottom - $DiamondMiddleY) / 2, "BOTTOM-RIGHT"] _
		]
Global $CocDiamondDCD = "DCD"
Global $InternalArea[8][3]
Global $InternalAreaRef[8][3] = [ _
		[$InnerDiamondLeft, $DiamondMiddleY, "LEFT"], _
		[$InnerDiamondRight, $DiamondMiddleY, "RIGHT"], _
		[$DiamondMiddleX, $InnerDiamondTop, "TOP"], _
		[$DiamondMiddleX, $InnerDiamondBottom, "BOTTOM"], _
		[$InnerDiamondLeft + ($DiamondMiddleX - $InnerDiamondLeft) / 2, $InnerDiamondTop + ($DiamondMiddleY - $InnerDiamondTop) / 2, "TOP-LEFT"], _
		[$DiamondMiddleX + ($InnerDiamondRight - $DiamondMiddleX) / 2, $InnerDiamondTop + ($DiamondMiddleY - $InnerDiamondTop) / 2, "TOP-RIGHT"], _
		[$InnerDiamondLeft + ($DiamondMiddleX - $InnerDiamondLeft) / 2, $DiamondMiddleY + ($InnerDiamondBottom - $DiamondMiddleY) / 2, "BOTTOM-LEFT"], _
		[$DiamondMiddleX + ($InnerDiamondRight - $DiamondMiddleX) / 2, $DiamondMiddleY + ($InnerDiamondBottom - $DiamondMiddleY) / 2, "BOTTOM-RIGHT"] _
		]
ConvertInternalExternArea() ; initial layout so variables are not empty

Func ConvertInternalExternArea()
	Local $x, $y

	; Update External coord.
	For $i = 0 To 7
		$x = $ExternalAreaRef[$i][0]
		$y = $ExternalAreaRef[$i][1]
		ConvertToVillagePos($x, $y)
		$ExternalArea[$i][0] = $x
		$ExternalArea[$i][1] = $y
		$ExternalArea[$i][2] = $ExternalAreaRef[$i][2]
		;debugAttackCSV("External Area Point " & $ExternalArea[$i][2] & ": " & $x & ", " & $y)
	Next
	; Full ECD Diamond $CocDiamondECD
	; Top
	$x = $ExternalAreaRef[2][0]
	$y = $ExternalAreaRef[2][1] + $DiamandAdjY
	ConvertToVillagePos($x, $y)
	$CocDiamondECD = $x & "," & $y
	; Right
	$x = $ExternalAreaRef[1][0] - $DiamandAdjX
	$y = $ExternalAreaRef[1][1]
	ConvertToVillagePos($x, $y)
	$CocDiamondECD &= "|" & $x & "," & $y
	; Bottom
	$x = $ExternalAreaRef[3][0]
	$y = $ExternalAreaRef[3][1] - $DiamandAdjY
	ConvertToVillagePos($x, $y)
	$CocDiamondECD &= "|" & $x & "," & $y
	; Left
	$x = $ExternalAreaRef[0][0] + $DiamandAdjX
	$y = $ExternalAreaRef[0][1]
	ConvertToVillagePos($x, $y)
	$CocDiamondECD &= "|" & $x & "," & $y

	; Update Internal coord.
	For $i = 0 To 7
		$x = $InternalAreaRef[$i][0]
		$y = $InternalAreaRef[$i][1]
		ConvertToVillagePos($x, $y)
		$InternalArea[$i][0] = $x
		$InternalArea[$i][1] = $y
		$InternalArea[$i][2] = $InternalAreaRef[$i][2]
		;debugAttackCSV("Internal Area Point " & $InternalArea[$i][2] & ": " & $x & ", " & $y)
	Next
	$CocDiamondDCD =  $InternalArea[2][0] & "," & $InternalArea[2][1] & "|" & _
					  $InternalArea[1][0] & "," & $InternalArea[1][1] & "|" & _
					  $InternalArea[3][0] & "," & $InternalArea[3][1] & "|" & _
					  $InternalArea[0][0] & "," & $InternalArea[0][1]
EndFunc   ;==>ConvertInternalExternArea

Func CheckAttackLocation(ByRef $x, ByRef $y)
	;If $x < 1 Then $x = 1
	;If $x > $g_iGAME_WIDTH - 1 Then $x = $g_iGAME_WIDTH - 1
	;If $y < 1 Then $y = 1
    If $y > $DeployableLRTB[3] Then
        $y = $DeployableLRTB[3]
        Return False
    EndIf
	Return True
	#cs
	Local $sPoints = GetDeployableNextTo($x & "," & $y)
	Local $aPoints = StringSplit($sPoints, "|", $STR_NOCOUNT)
	If UBound($aPoints) > 0 Then
		Local $aPoint = StringSplit($aPoints[0], ",", $STR_NOCOUNT)
		If UBound($aPoint) > 1 Then
			$x = $aPoint[0]
			$y = $aPoint[1]
			Return True
		EndIf
	EndIf
	#ce

	#cs
	Local $aPoint = [$x, $y]
	If isInsideDiamondRedArea($aPoint) = True Then Return False

	; find closest red line point

	Local $isLeft = ($x <= $ExternalArea[2][0])
	Local $isTop = ($y <=  $ExternalArea[0][1])

	Local $aPoints
	If $isLeft = True Then
		If $isTop = True Then
			$aPoints = $PixelTopLeft
		Else
			$aPoints = $PixelBottomLeft
		EndIf
	Else
		If $isTop = True Then
			$aPoints = $PixelTopRight
		Else
			$aPoints = $PixelBottomRight
		EndIf
	EndIf

	Local $aP = [0, 0, 9999]
	For $aPoint In $aPoints
		Local $a = $x - $aPoint[0]
		Local $b = $y - $aPoint[1]
		Local $d = Round(Sqrt($a * $a + $b * $b))
		If $d < $aP[2] Then
			Local $aP = [$aPoint[0], $aPoint[1], $d]
			If $d < 5 Then ExitLoop
		EndIf
	Next

	If $aP[2] < 9999 Then
		$x = $aP[0]
		$y = $aP[1]
		Return True
	EndIf
	#ce

	;debugAttackCSV("CheckAttackLocation: Failed: " & $x & ", " & $y)
EndFunc   ;==>CheckAttackLocation

Func GetMinPoint($PointList, $Dim)
	Local $Result = [9999, 9999]
	For $i = 0 To UBound($PointList) - 1
		Local $Point = $PointList[$i]
		If $Point[$Dim] < $Result[$Dim] Then $Result = $Point
	Next
	Return $Result
EndFunc   ;==>GetMinPoint

Func GetMaxPoint($PointList, $Dim)
	Local $Result = [-9999, -9999]
	For $i = 0 To UBound($PointList) - 1
		Local $Point = $PointList[$i]
		If $Point[$Dim] > $Result[$Dim] Then $Result = $Point
	Next
	Return $Result
EndFunc   ;==>GetMaxPoint

; #FUNCTION# ====================================================================================================================
; Name ..........: Algorithm_AttackCSV
; Description ...:
; Syntax ........: Algorithm_AttackCSV([$testattack = False])
; Parameters ....: $testattack          - [optional]
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func Algorithm_AttackCSV($testattack = False, $captureredarea = True)
   Local $PixelNearCollectorTopLeft[0]
   Local $PixelNearCollectorBottomLeft[0]
   Local $PixelNearCollectorTopRight[0]
   Local $PixelNearCollectorBottomRight[0]

	;00 read attack file SIDE row and valorize variables
	ParseAttackCSV_Read_SIDE_variables()
	$lastTroopPositionDropTroopFromINI = -1
	If _Sleep($iDelayRespond) Then Return

	;01 - TROOPS ------------------------------------------------------------------------------------------------------------------------------------------
	debugAttackCSV("Troops to be used (purged from troops) ")
	For $i = 0 To UBound($atkTroops) - 1 ; identify the position of this kind of troop
		debugAttackCSV("SLOT n.: " & $i & " - Troop: " & NameOfTroop($atkTroops[$i][0]) & " (" & $atkTroops[$i][0] & ") - Quantity: " & $atkTroops[$i][1])
	Next

	Local $hTimerTOTAL = TimerInit()
	;02.01 - REDAREA -----------------------------------------------------------------------------------------------------------------------------------------
	Local $hTimer = TimerInit()

    SetDebugLog("Redline mode: " & $g_aiAttackScrRedlineRoutine[$g_iMatchMode])
    SetDebugLog("Dropline mode: " & $g_aiAttackScrDroplineEdge[$g_iMatchMode])

	_CaptureRegion2() ; ensure full screen is captured (not ideal for debugging as clean image was already saved, but...)
	If $captureredarea Then _GetRedArea($g_aiAttackScrRedlineRoutine[$g_iMatchMode])
	If _Sleep($iDelayRespond) Then Return

	Local $htimerREDAREA = Round(TimerDiff($hTimer) / 1000, 2)
	debugAttackCSV("Calculated  (in " & $htimerREDAREA & " seconds) :")
	debugAttackCSV("	[" & UBound($PixelTopLeft) & "] pixels TopLeft")
	debugAttackCSV("	[" & UBound($PixelTopRight) & "] pixels TopRight")
	debugAttackCSV("	[" & UBound($PixelBottomLeft) & "] pixels BottomLeft")
	debugAttackCSV("	[" & UBound($PixelBottomRight) & "] pixels BottomRight")

	If $g_aiAttackScrDroplineEdge[$g_iMatchMode] = $DROPLINE_DROPPOINTS_ONLY Then

		$PixelTopLeftDropLine = $PixelTopLeft
		$PixelTopRightDropLine = $PixelTopRight
		$PixelBottomLeftDropLine = $PixelBottomLeft
		$PixelBottomRightDropLine = $PixelBottomRight

	Else

		Local $coordLeft = [$ExternalArea[0][0], $ExternalArea[0][1]]
		Local $coordTop = [$ExternalArea[2][0], $ExternalArea[2][1]]
		Local $coordRight = [$ExternalArea[1][0], $ExternalArea[1][1]]
		Local $coordBottom = [$ExternalArea[3][0], $ExternalArea[3][1]]

		Local $StartEndTopLeft = [$coordLeft, $coordTop]
		If UBound($PixelTopLeft) > 2 Then Local $StartEndTopLeft = [$PixelTopLeft[0], $PixelTopLeft[UBound($PixelTopLeft) - 1]]
		Local $StartEndTopRight = [$coordTop, $coordRight]
		If UBound($PixelTopRight) > 2 Then Local $StartEndTopRight = [$PixelTopRight[0], $PixelTopRight[UBound($PixelTopRight) - 1]]
		Local $StartEndBottomLeft = [$coordLeft, $coordBottom]
		If UBound($PixelBottomLeft) > 2 Then Local $StartEndBottomLeft = [$PixelBottomLeft[0], $PixelBottomLeft[UBound($PixelBottomLeft) - 1]]
		Local $StartEndBottomRight = [$coordBottom, $coordRight]
		If UBound($PixelBottomRight) > 2 Then Local $StartEndBottomRight = [$PixelBottomRight[0], $PixelBottomRight[UBound($PixelBottomRight) - 1]]

		Switch $g_aiAttackScrDroplineEdge[$g_iMatchMode]
		Case $DROPLINE_EDGE_FIXED, $DROPLINE_FULL_EDGE_FIXED ; default inner area edges
			; reset fix corners
			Local $StartEndTopLeft = [$coordLeft, $coordTop]
			Local $StartEndTopRight = [$coordTop, $coordRight]
			Local $StartEndBottomLeft = [$coordLeft, $coordBottom]
			Local $StartEndBottomRight = [$coordBottom, $coordRight]
		EndSwitch

		SetDebugLog("MakeDropLines, StartEndTopLeft     = " & PixelArrayToString($StartEndTopLeft, ","))
		SetDebugLog("MakeDropLines, StartEndTopRight    = " & PixelArrayToString($StartEndTopRight, ","))
		SetDebugLog("MakeDropLines, StartEndBottomLeft  = " & PixelArrayToString($StartEndBottomLeft, ","))
		SetDebugLog("MakeDropLines, StartEndBottomRight = " & PixelArrayToString($StartEndBottomRight, ","))

		Switch $g_aiAttackScrDroplineEdge[$g_iMatchMode]
		Case $DROPLINE_EDGE_FIXED, $DROPLINE_EDGE_FIRST ; default drop line
			$PixelTopLeftDropLine = MakeDropLineOriginal($PixelTopLeft, $StartEndTopLeft[0], $StartEndTopLeft[1])
			$PixelTopRightDropLine = MakeDropLineOriginal($PixelTopRight, $StartEndTopRight[0], $StartEndTopRight[1])
			$PixelBottomLeftDropLine = MakeDropLineOriginal($PixelBottomLeft, $StartEndBottomLeft[0], $StartEndBottomLeft[1])
			$PixelBottomRightDropLine = MakeDropLineOriginal($PixelBottomRight, $StartEndBottomRight[0], $StartEndBottomRight[1])
		Case $DROPLINE_FULL_EDGE_FIXED, $DROPLINE_FULL_EDGE_FIRST ; full drop line
			Local $iLineDistanceThreshold = 75
			If $g_aiAttackScrRedlineRoutine[$g_iMatchMode] = $REDLINE_IMGLOC Then $iLineDistanceThreshold = 25
			$PixelTopLeftDropLine = MakeDropLine($PixelTopLeft, $StartEndTopLeft[0], $StartEndTopLeft[1], $iLineDistanceThreshold, $g_aiAttackScrDroplineEdge[$g_iMatchMode] = $DROPLINE_FULL_EDGE_FIXED)
			$PixelTopRightDropLine = MakeDropLine($PixelTopRight, $StartEndTopRight[0], $StartEndTopRight[1], $iLineDistanceThreshold, $g_aiAttackScrDroplineEdge[$g_iMatchMode] = $DROPLINE_FULL_EDGE_FIXED)
			$PixelBottomLeftDropLine = MakeDropLine($PixelBottomLeft, $StartEndBottomLeft[0], $StartEndBottomLeft[1], $iLineDistanceThreshold, $g_aiAttackScrDroplineEdge[$g_iMatchMode] = $DROPLINE_FULL_EDGE_FIXED)
			$PixelBottomRightDropLine = MakeDropLine($PixelBottomRight, $StartEndBottomRight[0], $StartEndBottomRight[1], $iLineDistanceThreshold, $g_aiAttackScrDroplineEdge[$g_iMatchMode] = $DROPLINE_FULL_EDGE_FIXED)
		EndSwitch
	EndIf

	;02.04 - MAKE DROP LINE SLICE ----------------------------------------------------------------------------------------------------------------------------
	;-- TOP LEFT
	Local $tempvectstr1 = ""
	Local $tempvectstr2 = ""
	For $i = 0 To UBound($PixelTopLeftDropLine) - 1
		Local $pixel = $PixelTopLeftDropLine[$i]
		Local $slice = Slice8($pixel)
		Switch StringLeft($slice, 1)
			Case "6"
				$tempvectstr1 &= $pixel[0] & "," & $pixel[1] & "|"
			Case "5"
				$tempvectstr2 &= $pixel[0] & "," & $pixel[1] & "|"
			Case Else
				SetDebugLog("TOP LEFT: Skip slice " & $slice & " at " & $pixel[0] & ", " & $pixel[1])
		EndSwitch
	Next
	If StringLen($tempvectstr1) > 0 Then $tempvectstr1 = StringLeft($tempvectstr1, StringLen($tempvectstr1) - 1)
	If StringLen($tempvectstr2) > 0 Then $tempvectstr2 = StringLeft($tempvectstr2, StringLen($tempvectstr2) - 1)
	$PixelTopLeftDOWNDropLine = GetListPixel($tempvectstr1, ",", "TL-DOWN")
	$PixelTopLeftUPDropLine = GetListPixel($tempvectstr2, ",", "TL-UP")

	;-- TOP RIGHT
	Local $tempvectstr1 = ""
	Local $tempvectstr2 = ""
	For $i = 0 To UBound($PixelTopRightDropLine) - 1
		Local $pixel = $PixelTopRightDropLine[$i]
		Local $slice = Slice8($pixel)
		Switch StringLeft($slice, 1)
			Case "3"
				$tempvectstr1 &= $pixel[0] & "," & $pixel[1] & "|"
			Case "4"
				$tempvectstr2 &= $pixel[0] & "," & $pixel[1] & "|"
			Case Else
				SetDebugLog("TOP RIGHT: Skip slice " & $slice & " at " & $pixel[0] & ", " & $pixel[1])
		EndSwitch
	Next
	If StringLen($tempvectstr1) > 0 Then $tempvectstr1 = StringLeft($tempvectstr1, StringLen($tempvectstr1) - 1)
	If StringLen($tempvectstr2) > 0 Then $tempvectstr2 = StringLeft($tempvectstr2, StringLen($tempvectstr2) - 1)
	$PixelTopRightDOWNDropLine = GetListPixel($tempvectstr1, ",", "TR-DOWN")
	$PixelTopRightUPDropLine = GetListPixel($tempvectstr2, ",", "TR-UP")

	;-- BOTTOM LEFT
	Local $tempvectstr1 = ""
	Local $tempvectstr2 = ""
	For $i = 0 To UBound($PixelBottomLeftDropLine) - 1
		Local $pixel = $PixelBottomLeftDropLine[$i]
		Local $slice = Slice8($pixel)
		Switch StringLeft($slice, 1)
			Case "8"
				$tempvectstr1 &= $pixel[0] & "," & $pixel[1] & "|"
			Case "7"
				$tempvectstr2 &= $pixel[0] & "," & $pixel[1] & "|"
			Case Else
				SetDebugLog("BOTTOM LEFT: Skip slice " & $slice & " at " & $pixel[0] & ", " & $pixel[1])
		EndSwitch
	Next
	If StringLen($tempvectstr1) > 0 Then $tempvectstr1 = StringLeft($tempvectstr1, StringLen($tempvectstr1) - 1)
	If StringLen($tempvectstr2) > 0 Then $tempvectstr2 = StringLeft($tempvectstr2, StringLen($tempvectstr2) - 1)
	$PixelBottomLeftDOWNDropLine = GetListPixel($tempvectstr1, ",", "BL-DOWN")
	$PixelBottomLeftUPDropLine = GetListPixel($tempvectstr2, ",", "BL-UP")

	;-- BOTTOM RIGHT
	Local $tempvectstr1 = ""
	Local $tempvectstr2 = ""
	For $i = 0 To UBound($PixelBottomRightDropLine) - 1
		Local $pixel = $PixelBottomRightDropLine[$i]
		Local $slice = Slice8($pixel)
		Switch StringLeft($slice, 1)
			Case "1"
				$tempvectstr1 &= $pixel[0] & "," & $pixel[1] & "|"
			Case "2"
				$tempvectstr2 &= $pixel[0] & "," & $pixel[1] & "|"
			Case Else
				SetDebugLog("BOTTOM RIGHT: Skip slice " & $slice & " at " & $pixel[0] & ", " & $pixel[1])
		EndSwitch
	Next
	If StringLen($tempvectstr1) > 0 Then $tempvectstr1 = StringLeft($tempvectstr1, StringLen($tempvectstr1) - 1)
	If StringLen($tempvectstr2) > 0 Then $tempvectstr2 = StringLeft($tempvectstr2, StringLen($tempvectstr2) - 1)
	$PixelBottomRightDOWNDropLine = GetListPixel($tempvectstr1, ",", "BR-DOWN")
	$PixelBottomRightUPDropLine = GetListPixel($tempvectstr2, ",", "BR-UP")
	Setlog("> Drop Lines located in  " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds", $COLOR_INFO)
	If _Sleep($iDelayRespond) Then Return

	; 03 - TOWNHALL ------------------------------------------------------------------------
	If $searchTH = "-" Then

		If $attackcsv_locate_townhall = 1 Then
			SuspendAndroid()
			$hTimer = TimerInit()
			Local $searchTH = imgloccheckTownHallADV2(0, 0, False)

			Setlog("> Townhall located in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds", $COLOR_INFO)
			ResumeAndroid()
		Else
			Setlog("> Townhall search not needed, skip")
		EndIf
	Else
		Setlog("> Townhall has already been located in while searching for an image", $COLOR_INFO)
	EndIf
	If _Sleep($iDelayRespond) Then Return

	;_CaptureRegion2() ;

	;04 - MINES, COLLECTORS, DRILLS -----------------------------------------------------------------------------------------------------------------------

	;_CaptureRegion()

	;reset variables
	Global $PixelMine[0]
	Global $PixelElixir[0]
	Global $PixelDarkElixir[0]
	Local $PixelNearCollectorTopLeftSTR = ""
	Local $PixelNearCollectorBottomLeftSTR = ""
	Local $PixelNearCollectorTopRightSTR = ""
	Local $PixelNearCollectorBottomRightSTR = ""


	;04.01 If drop troop near gold mine
	If $attackcsv_locate_mine = 1 Then
		;SetLog("Locating mines")
		$hTimer = TimerInit()
		SuspendAndroid()
		$PixelMine = GetLocationMine()
		ResumeAndroid()
		If _Sleep($iDelayRespond) Then Return
		CleanRedArea($PixelMine)
		Local $htimerMine = Round(TimerDiff($hTimer) / 1000, 2)
		If (IsArray($PixelMine)) Then
			For $i = 0 To UBound($PixelMine) - 1
				$pixel = $PixelMine[$i]
				Local $str = $pixel[0] & "-" & $pixel[1] & "-" & "MINE"
				If isInsideDiamond($pixel) Then
					If $pixel[0] <= $InternalArea[2][0] Then
						If $pixel[1] <= $InternalArea[0][1] Then
							;Setlog($str & " :  TOP LEFT SIDE")
							$PixelNearCollectorTopLeftSTR &= $str & "|"
						Else
							;Setlog($str & " :  BOTTOM LEFT SIDE")
							$PixelNearCollectorBottomLeftSTR &= $str & "|"
						EndIf
					Else
						If $pixel[1] <= $InternalArea[0][1] Then
							;Setlog($str & " :  TOP RIGHT SIDE")
							$PixelNearCollectorTopRightSTR &= $str & "|"
						Else
							;Setlog($str & " :  BOTTOM RIGHT SIDE")
							$PixelNearCollectorBottomRightSTR &= $str & "|"
						EndIf
					EndIf
				EndIf
			Next
		EndIf
		Setlog("> Mines located in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds", $COLOR_INFO)
	Else
		Setlog("> Mines detection not needed, skip", $COLOR_INFO)
	EndIf
	If _Sleep($iDelayRespond) Then Return

	;04.02  If drop troop near elisir
	If $attackcsv_locate_elixir = 1 Then
		;SetLog("Locating elixir")
		$hTimer = TimerInit()
		SuspendAndroid()
		$PixelElixir = GetLocationElixir()
		ResumeAndroid()
		If _Sleep($iDelayRespond) Then Return
		CleanRedArea($PixelElixir)
		Local $htimerMine = Round(TimerDiff($hTimer) / 1000, 2)
		If (IsArray($PixelElixir)) Then
			For $i = 0 To UBound($PixelElixir) - 1
				$pixel = $PixelElixir[$i]
				Local $str = $pixel[0] & "-" & $pixel[1] & "-" & "ELIXIR"
				If isInsideDiamond($pixel) Then
					If $pixel[0] <= $InternalArea[2][0] Then
						If $pixel[1] <= $InternalArea[0][1] Then
							;Setlog($str & " :  TOP LEFT SIDE")
							$PixelNearCollectorTopLeftSTR &= $str & "|"
						Else
							;Setlog($str & " :  BOTTOM LEFT SIDE")
							$PixelNearCollectorBottomLeftSTR &= $str & "|"
						EndIf
					Else
						If $pixel[1] <= $InternalArea[0][1] Then
							;Setlog($str & " :  TOP RIGHT SIDE")
							$PixelNearCollectorTopRightSTR &= $str & "|"
						Else
							;Setlog($str & " :  BOTTOM RIGHT SIDE")
							$PixelNearCollectorBottomRightSTR &= $str & "|"
						EndIf
					EndIf
				EndIf
			Next
		EndIf
		Setlog("> Elixir collectors located in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds", $COLOR_INFO)
	Else
		Setlog("> Elixir collectors detection not needed, skip", $COLOR_INFO)
	EndIf
	If _Sleep($iDelayRespond) Then Return

	;04.03 If drop troop near drill
	If $attackcsv_locate_drill = 1 Then
		;SetLog("Locating drills")
		$hTimer = TimerInit()
		SuspendAndroid()
		$PixelDarkElixir = GetLocationDarkElixir()
		ResumeAndroid()
		If _Sleep($iDelayRespond) Then Return
		CleanRedArea($PixelDarkElixir)
		Local $htimerMine = Round(TimerDiff($hTimer) / 1000, 2)
		If (IsArray($PixelDarkElixir)) Then
			For $i = 0 To UBound($PixelDarkElixir) - 1
				$pixel = $PixelDarkElixir[$i]
				Local $str = $pixel[0] & "-" & $pixel[1] & "-" & "DRILL"
				If isInsideDiamond($pixel) Then
					If $pixel[0] <= $InternalArea[2][0] Then
						If $pixel[1] <= $InternalArea[0][1] Then
							;Setlog($str & " :  TOP LEFT SIDE")
							$PixelNearCollectorTopLeftSTR &= $str & "|"
						Else
							;Setlog($str & " :  BOTTOM LEFT SIDE")
							$PixelNearCollectorBottomLeftSTR &= $str & "|"
						EndIf
					Else
						If $pixel[1] <= $InternalArea[0][1] Then
							;Setlog($str & " :  TOP RIGHT SIDE")
							$PixelNearCollectorTopRightSTR &= $str & "|"
						Else
							;Setlog($str & " :  BOTTOM RIGHT SIDE")
							$PixelNearCollectorBottomRightSTR &= $str & "|"
						EndIf
					EndIf
				EndIf
			Next
		EndIf
		Setlog("> Drills located in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds", $COLOR_INFO)
	Else
		Setlog("> Drills detection not needed, skip", $COLOR_INFO)
	EndIf
	If _Sleep($iDelayRespond) Then Return

	If StringLen($PixelNearCollectorTopLeftSTR) > 0 Then $PixelNearCollectorTopLeftSTR = StringLeft($PixelNearCollectorTopLeftSTR, StringLen($PixelNearCollectorTopLeftSTR) - 1)
	If StringLen($PixelNearCollectorTopRightSTR) > 0 Then $PixelNearCollectorTopRightSTR = StringLeft($PixelNearCollectorTopRightSTR, StringLen($PixelNearCollectorTopRightSTR) - 1)
	If StringLen($PixelNearCollectorBottomLeftSTR) > 0 Then $PixelNearCollectorBottomLeftSTR = StringLeft($PixelNearCollectorBottomLeftSTR, StringLen($PixelNearCollectorBottomLeftSTR) - 1)
	If StringLen($PixelNearCollectorBottomRightSTR) > 0 Then $PixelNearCollectorBottomRightSTR = StringLeft($PixelNearCollectorBottomRightSTR, StringLen($PixelNearCollectorBottomRightSTR) - 1)
	$PixelNearCollectorTopLeft = GetListPixel3($PixelNearCollectorTopLeftSTR)
	$PixelNearCollectorTopRight = GetListPixel3($PixelNearCollectorTopRightSTR)
	$PixelNearCollectorBottomLeft = GetListPixel3($PixelNearCollectorBottomLeftSTR)
	$PixelNearCollectorBottomRight = GetListPixel3($PixelNearCollectorBottomRightSTR)

	If $attackcsv_locate_gold_storage = 1 Then
		SuspendAndroid()
		$GoldStoragePos = GetLocationGoldStorage()
		ResumeAndroid()
	EndIf

	If $attackcsv_locate_elixir_storage = 1 Then
		SuspendAndroid()
		$ElixirStoragePos = GetLocationElixirStorage()
		ResumeAndroid()
	EndIf


	; 05 - DARKELIXIRSTORAGE ------------------------------------------------------------------------
	If $attackcsv_locate_dark_storage = 1 Then
		$hTimer = TimerInit()
		SuspendAndroid()
		Local $PixelDarkElixirStorage = GetLocationDarkElixirStorageWithLevel()
		ResumeAndroid()
		If _Sleep($iDelayRespond) Then Return
		CleanRedArea($PixelDarkElixirStorage)
		Local $pixel = StringSplit($PixelDarkElixirStorage, "#", 2)
		If UBound($pixel) >= 2 Then
			Local $pixellevel = $pixel[0]
			Local $pixelpos = StringSplit($pixel[1], "-", 2)
			If UBound($pixelpos) >= 2 Then
				Local $temp = [Int($pixelpos[0]), Int($pixelpos[1])]
				$darkelixirStoragePos = $temp
			EndIf
		EndIf
		Setlog("> Dark Elixir Storage located in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds", $COLOR_INFO)
	Else
		Setlog("> Dark Elixir Storage detection not need, skip", $COLOR_INFO)
	EndIf

	; 06 - EAGLEARTILLERY ------------------------------------------------------------------------

	$EagleArtilleryPos[0] = "" ; reset pixel position to null
	$EagleArtilleryPos[1] = ""
	If $searchTH = "-" Or Int($searchTH) > 10 Then
		If $attackcsv_locate_Eagle = 1 Then
			$hTimer = TimerInit()
			SuspendAndroid()
			Local $result = returnSingleMatch(@ScriptDir & "\imgxml\WeakBase\Eagle")
			ResumeAndroid()
			If UBound($result) > 1 Then
				Local $tempeaglePos = $result[1][5] ;assign eagle x,y sub array to temp variable
				If $g_iDebugSetlog = 1 Then
					Setlog(": ImageName: " & $result[1][0], $COLOR_DEBUG)
					Setlog(": ObjectName: " & $result[1][1], $COLOR_DEBUG)
					Setlog(": ObjectLevel: " & $result[1][2], $COLOR_DEBUG)
				EndIf
				If $tempeaglePos[0][0] <> "" Then
					$EagleArtilleryPos[0] = $tempeaglePos[0][0]
					$EagleArtilleryPos[1] = $tempeaglePos[0][1]
					Setlog("> Eagle located in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds", $COLOR_INFO)
					If $g_iDebugSetlog = 1 Then
						Setlog(": $EagleArtilleryPosition X:Y= " & $EagleArtilleryPos[0] & ":" & $EagleArtilleryPos[1], $COLOR_DEBUG)
					EndIf
				Else
					Setlog("> Eagle detection error", $COLOR_WARNING)
				EndIf
			Else
				Setlog("> Eagle detection error", $COLOR_WARNING)
			EndIf
		Else
			Setlog("> Eagle Artillery detection not need, skip", $COLOR_INFO)
		EndIf
	Else
		Setlog("> TH Level to low for Eagle detection, skip", $COLOR_INFO)
	EndIf

	Setlog(">> Total time: " & Round(TimerDiff($hTimerTOTAL) / 1000, 2) & " seconds", $COLOR_INFO)

	; 06 - DEBUGIMAGE ------------------------------------------------------------------------
	If $g_iDebugMakeIMGCSV = 1 Then AttackCSVDEBUGIMAGE() ;make IMG debug

	; 07 - START TH SNIPE BEFORE ATTACK CSV IF NEED ------------------------------------------
	If $g_bTHSnipeBeforeEnable[$DB] And $searchTH = "-" Then FindTownHall(True) ;search townhall if no previous detect
	If $g_bTHSnipeBeforeEnable[$DB] Then
		If $searchTH <> "-" Then
			If SearchTownHallLoc() Then
				Setlog(_PadStringCenter(" TH snipe Before Scripted Attack ", 54, "="), $COLOR_INFO)
				$THusedKing = 0
				$THusedQueen = 0
				AttackTHParseCSV()
			Else
				If $g_iDebugSetlog = 1 Then Setlog("TH snipe before scripted attack skip, th internal village", $COLOR_DEBUG)
			EndIf
		Else
			If $g_iDebugSetlog = 1 Then Setlog("TH snipe before scripted attack skip, no th found", $COLOR_DEBUG)
		EndIf
	EndIf

	; 08 - LAUNCH PARSE FUNCTION -------------------------------------------------------------
	SetSlotSpecialTroops()
	If _Sleep($iDelayRespond) Then Return

	If TestCapture() = True Then
		; no launch when testing with image
		Return
	EndIf

	ParseAttackCSV($testattack)

	;Activate Heroe's power Manual after X seconds
	If ($checkKPower Or $checkQPower or $checkWPower) And $iActivateKQCondition = "Manual" Then
		SetLog("Waiting " & $delayActivateKQ / 1000 & " seconds before activating Hero abilities", $COLOR_INFO)
		If _Sleep($delayActivateKQ) Then Return
		If $checkKPower Then
			SetLog("Activating King's power", $COLOR_INFO)
			SelectDropTroop($King)
			$checkKPower = False
		EndIf
		If $checkQPower Then
			SetLog("Activating Queen's power", $COLOR_INFO)
			SelectDropTroop($Queen)
			$checkQPower = False
		EndIf
		If $checkWPower then
			SetLog("Activating Warden's power", $COLOR_INFO)
			SelectDropTroop($Warden)
			$checkWPower = False
		EndIf
	EndIf

EndFunc   ;==>Algorithm_AttackCSV
