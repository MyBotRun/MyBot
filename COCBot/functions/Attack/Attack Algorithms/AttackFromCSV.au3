; #FUNCTION# ====================================================================================================================
; Name ..........:
; Description ...: This file contens the attack algorithm SCRIPTED
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......: CodeSlinger69 (01-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
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


Global $g_aiPixelTopLeftDropLine
Global $g_aiPixelTopRightDropLine
Global $g_aiPixelBottomLeftDropLine
Global $g_aiPixelBottomRightDropLine
Global $g_aiPixelTopLeftUPDropLine
Global $g_aiPixelTopLeftDOWNDropLine
Global $g_aiPixelTopRightUPDropLine
Global $g_aiPixelTopRightDOWNDropLine
Global $g_aiPixelBottomLeftUPDropLine
Global $g_aiPixelBottomLeftDOWNDropLine
Global $g_aiPixelBottomRightUPDropLine
Global $g_aiPixelBottomRightDOWNDropLine

Local $DeployableLRTB = [0, $g_iGAME_WIDTH - 1, 0, 626]
Local $DiamandAdjX = -28
Local $DiamandAdjY = -24
Local $OuterDiamondLeft = -18 - $DiamandAdjX, $OuterDiamondRight = 857 + $DiamandAdjX, $OuterDiamondTop = 20 - $DiamandAdjY, $OuterDiamondBottom = 679 + $DiamandAdjY ; set the diamond shape based on reference village
Local $DiamondMiddleX = ($OuterDiamondLeft + $OuterDiamondRight) / 2
Local $DiamondMiddleY = ($OuterDiamondTop + $OuterDiamondBottom) / 2
Local $InnerDiamandDiffX = 55 + $DiamandAdjX ; set the diamond shape based on reference village
Local $InnerDiamandDiffY = 47 + $DiamandAdjY ; set the diamond shape based on reference village
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
	$CocDiamondDCD = $InternalArea[2][0] & "," & $InternalArea[2][1] & "|" & _
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
		$aPoints = $g_aiPixelTopLeft
		Else
		$aPoints = $g_aiPixelBottomLeft
		EndIf
		Else
		If $isTop = True Then
		$aPoints = $g_aiPixelTopRight
		Else
		$aPoints = $g_aiPixelBottomRight
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
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func Algorithm_AttackCSV($testattack = False, $captureredarea = True)

	Local $g_aiPixelNearCollectorTopLeft[0]
	Local $g_aiPixelNearCollectorBottomLeft[0]
	Local $g_aiPixelNearCollectorTopRight[0]
	Local $g_aiPixelNearCollectorBottomRight[0]
	Local $aResult

	;00 read attack file SIDE row and valorize variables
	ParseAttackCSV_Read_SIDE_variables()
	$g_iCSVLastTroopPositionDropTroopFromINI = -1
	If _Sleep($DELAYRESPOND) Then Return

	;01 - TROOPS ------------------------------------------------------------------------------------------------------------------------------------------
	debugAttackCSV("Troops to be used (purged from troops) ")
	For $i = 0 To UBound($g_avAttackTroops) - 1 ; identify the position of this kind of troop
		debugAttackCSV("SLOT n.: " & $i & " - Troop: " & NameOfTroop($g_avAttackTroops[$i][0]) & " (" & $g_avAttackTroops[$i][0] & ") - Quantity: " & $g_avAttackTroops[$i][1])
	Next

	Local $hTimerTOTAL = __timerinit()
	;02.01 - REDAREA -----------------------------------------------------------------------------------------------------------------------------------------
	Local $hTimer = __timerinit()

	SetDebugLog("Redline mode: " & $g_aiAttackScrRedlineRoutine[$g_iMatchMode])
	SetDebugLog("Dropline mode: " & $g_aiAttackScrDroplineEdge[$g_iMatchMode])

	_CaptureRegion2() ; ensure full screen is captured (not ideal for debugging as clean image was already saved, but...)
	If $captureredarea Then _GetRedArea($g_aiAttackScrRedlineRoutine[$g_iMatchMode])
	If _Sleep($DELAYRESPOND) Then Return

	Local $htimerREDAREA = Round(__timerdiff($hTimer) / 1000, 2)
	debugAttackCSV("Calculated  (in " & $htimerREDAREA & " seconds) :")
	debugAttackCSV("	[" & UBound($g_aiPixelTopLeft) & "] pixels TopLeft")
	debugAttackCSV("	[" & UBound($g_aiPixelTopRight) & "] pixels TopRight")
	debugAttackCSV("	[" & UBound($g_aiPixelBottomLeft) & "] pixels BottomLeft")
	debugAttackCSV("	[" & UBound($g_aiPixelBottomRight) & "] pixels BottomRight")

	If $g_aiAttackScrDroplineEdge[$g_iMatchMode] = $DROPLINE_DROPPOINTS_ONLY Then

		$g_aiPixelTopLeftDropLine = $g_aiPixelTopLeft
		$g_aiPixelTopRightDropLine = $g_aiPixelTopRight
		$g_aiPixelBottomLeftDropLine = $g_aiPixelBottomLeft
		$g_aiPixelBottomRightDropLine = $g_aiPixelBottomRight

	Else

		Local $coordLeft = [$ExternalArea[0][0], $ExternalArea[0][1]]
		Local $coordTop = [$ExternalArea[2][0], $ExternalArea[2][1]]
		Local $coordRight = [$ExternalArea[1][0], $ExternalArea[1][1]]
		Local $coordBottom = [$ExternalArea[3][0], $ExternalArea[3][1]]

		Local $StartEndTopLeft = [$coordLeft, $coordTop]
		If UBound($g_aiPixelTopLeft) > 2 Then Local $StartEndTopLeft = [$g_aiPixelTopLeft[0], $g_aiPixelTopLeft[UBound($g_aiPixelTopLeft) - 1]]
		Local $StartEndTopRight = [$coordTop, $coordRight]
		If UBound($g_aiPixelTopRight) > 2 Then Local $StartEndTopRight = [$g_aiPixelTopRight[0], $g_aiPixelTopRight[UBound($g_aiPixelTopRight) - 1]]
		Local $StartEndBottomLeft = [$coordLeft, $coordBottom]
		If UBound($g_aiPixelBottomLeft) > 2 Then Local $StartEndBottomLeft = [$g_aiPixelBottomLeft[0], $g_aiPixelBottomLeft[UBound($g_aiPixelBottomLeft) - 1]]
		Local $StartEndBottomRight = [$coordBottom, $coordRight]
		If UBound($g_aiPixelBottomRight) > 2 Then Local $StartEndBottomRight = [$g_aiPixelBottomRight[0], $g_aiPixelBottomRight[UBound($g_aiPixelBottomRight) - 1]]

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
				$g_aiPixelTopLeftDropLine = MakeDropLineOriginal($g_aiPixelTopLeft, $StartEndTopLeft[0], $StartEndTopLeft[1])
				$g_aiPixelTopRightDropLine = MakeDropLineOriginal($g_aiPixelTopRight, $StartEndTopRight[0], $StartEndTopRight[1])
				$g_aiPixelBottomLeftDropLine = MakeDropLineOriginal($g_aiPixelBottomLeft, $StartEndBottomLeft[0], $StartEndBottomLeft[1])
				$g_aiPixelBottomRightDropLine = MakeDropLineOriginal($g_aiPixelBottomRight, $StartEndBottomRight[0], $StartEndBottomRight[1])
			Case $DROPLINE_FULL_EDGE_FIXED, $DROPLINE_FULL_EDGE_FIRST ; full drop line
				Local $iLineDistanceThreshold = 75
				If $g_aiAttackScrRedlineRoutine[$g_iMatchMode] = $REDLINE_IMGLOC Then $iLineDistanceThreshold = 25
				$g_aiPixelTopLeftDropLine = MakeDropLine($g_aiPixelTopLeft, $StartEndTopLeft[0], $StartEndTopLeft[1], $iLineDistanceThreshold, $g_aiAttackScrDroplineEdge[$g_iMatchMode] = $DROPLINE_FULL_EDGE_FIXED)
				$g_aiPixelTopRightDropLine = MakeDropLine($g_aiPixelTopRight, $StartEndTopRight[0], $StartEndTopRight[1], $iLineDistanceThreshold, $g_aiAttackScrDroplineEdge[$g_iMatchMode] = $DROPLINE_FULL_EDGE_FIXED)
				$g_aiPixelBottomLeftDropLine = MakeDropLine($g_aiPixelBottomLeft, $StartEndBottomLeft[0], $StartEndBottomLeft[1], $iLineDistanceThreshold, $g_aiAttackScrDroplineEdge[$g_iMatchMode] = $DROPLINE_FULL_EDGE_FIXED)
				$g_aiPixelBottomRightDropLine = MakeDropLine($g_aiPixelBottomRight, $StartEndBottomRight[0], $StartEndBottomRight[1], $iLineDistanceThreshold, $g_aiAttackScrDroplineEdge[$g_iMatchMode] = $DROPLINE_FULL_EDGE_FIXED)
		EndSwitch
	EndIf

	;02.04 - MAKE DROP LINE SLICE ----------------------------------------------------------------------------------------------------------------------------
	;-- TOP LEFT
	Local $tempvectstr1 = ""
	Local $tempvectstr2 = ""
	For $i = 0 To UBound($g_aiPixelTopLeftDropLine) - 1
		Local $pixel = $g_aiPixelTopLeftDropLine[$i]
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
	$g_aiPixelTopLeftDOWNDropLine = GetListPixel($tempvectstr1, ",", "TL-DOWN")
	$g_aiPixelTopLeftUPDropLine = GetListPixel($tempvectstr2, ",", "TL-UP")

	;-- TOP RIGHT
	Local $tempvectstr1 = ""
	Local $tempvectstr2 = ""
	For $i = 0 To UBound($g_aiPixelTopRightDropLine) - 1
		Local $pixel = $g_aiPixelTopRightDropLine[$i]
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
	$g_aiPixelTopRightDOWNDropLine = GetListPixel($tempvectstr1, ",", "TR-DOWN")
	$g_aiPixelTopRightUPDropLine = GetListPixel($tempvectstr2, ",", "TR-UP")

	;-- BOTTOM LEFT
	Local $tempvectstr1 = ""
	Local $tempvectstr2 = ""
	For $i = 0 To UBound($g_aiPixelBottomLeftDropLine) - 1
		Local $pixel = $g_aiPixelBottomLeftDropLine[$i]
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
	$g_aiPixelBottomLeftDOWNDropLine = GetListPixel($tempvectstr1, ",", "BL-DOWN")
	$g_aiPixelBottomLeftUPDropLine = GetListPixel($tempvectstr2, ",", "BL-UP")

	;-- BOTTOM RIGHT
	Local $tempvectstr1 = ""
	Local $tempvectstr2 = ""
	For $i = 0 To UBound($g_aiPixelBottomRightDropLine) - 1
		Local $pixel = $g_aiPixelBottomRightDropLine[$i]
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
	$g_aiPixelBottomRightDOWNDropLine = GetListPixel($tempvectstr1, ",", "BR-DOWN")
	$g_aiPixelBottomRightUPDropLine = GetListPixel($tempvectstr2, ",", "BR-UP")
	SetLog("> Drop Lines located in  " & Round(__timerdiff($hTimer) / 1000, 2) & " seconds", $COLOR_INFO)
	If _Sleep($DELAYRESPOND) Then Return

	; 03 - TOWNHALL ------------------------------------------------------------------------

	If $g_bCSVLocateStorageTownHall = True Then
		If $g_iSearchTH = "-" Or $g_oBldgAttackInfo.Exists($eBldgTownHall & "_LOCATION") = False Then ; If TH is unknown, try again to find as it is needed by script
			imglocTHSearch(True, False, False)
		Else
			SetLog("> Townhall has already been located in while searching for an image", $COLOR_INFO)
		EndIf
	Else
		SetLog("> Townhall search not needed, skip")
	EndIf
	If _Sleep($DELAYRESPOND) Then Return

	;_CaptureRegion2() ;

	;04 - MINES, COLLECTORS, DRILLS -----------------------------------------------------------------------------------------------------------------------

	;_CaptureRegion()

	;reset variables
	Global $g_aiPixelMine[0]
	Global $g_aiPixelElixir[0]
	Global $g_aiPixelDarkElixir[0]
	Local $g_aiPixelNearCollectorTopLeftSTR = ""
	Local $g_aiPixelNearCollectorBottomLeftSTR = ""
	Local $g_aiPixelNearCollectorTopRightSTR = ""
	Local $g_aiPixelNearCollectorBottomRightSTR = ""


	;04.01 If drop troop near gold mine
	If $g_bCSVLocateMine = True Then
		;SetLog("Locating mines")
		$hTimer = __timerinit()
		SuspendAndroid()
		$g_aiPixelMine = GetLocationMine()
		ResumeAndroid()
		If _Sleep($DELAYRESPOND) Then Return
		CleanRedArea($g_aiPixelMine)
		Local $htimerMine = Round(__timerdiff($hTimer) / 1000, 2)
		If (IsArray($g_aiPixelMine)) Then
			For $i = 0 To UBound($g_aiPixelMine) - 1
				Local $pixel = $g_aiPixelMine[$i]
				Local $str = $pixel[0] & "-" & $pixel[1] & "-" & "MINE"
				If isInsideDiamond($pixel) Then
					If $pixel[0] <= $InternalArea[2][0] Then
						If $pixel[1] <= $InternalArea[0][1] Then
							;SetLog($str & " :  TOP LEFT SIDE")
							$g_aiPixelNearCollectorTopLeftSTR &= $str & "|"
						Else
							;SetLog($str & " :  BOTTOM LEFT SIDE")
							$g_aiPixelNearCollectorBottomLeftSTR &= $str & "|"
						EndIf
					Else
						If $pixel[1] <= $InternalArea[0][1] Then
							;SetLog($str & " :  TOP RIGHT SIDE")
							$g_aiPixelNearCollectorTopRightSTR &= $str & "|"
						Else
							;SetLog($str & " :  BOTTOM RIGHT SIDE")
							$g_aiPixelNearCollectorBottomRightSTR &= $str & "|"
						EndIf
					EndIf
				EndIf
			Next
		EndIf
		SetLog("> Mines located in " & Round(__timerdiff($hTimer) / 1000, 2) & " seconds", $COLOR_INFO)
	Else
		SetLog("> Mines detection not needed, skip", $COLOR_INFO)
	EndIf
	If _Sleep($DELAYRESPOND) Then Return

	;04.02  If drop troop near elisir
	If $g_bCSVLocateElixir = True Then
		;SetLog("Locating elixir")
		$hTimer = __timerinit()
		SuspendAndroid()
		$g_aiPixelElixir = GetLocationElixir()
		ResumeAndroid()
		If _Sleep($DELAYRESPOND) Then Return
		CleanRedArea($g_aiPixelElixir)
		Local $htimerMine = Round(__timerdiff($hTimer) / 1000, 2)
		If (IsArray($g_aiPixelElixir)) Then
			For $i = 0 To UBound($g_aiPixelElixir) - 1
				Local $pixel = $g_aiPixelElixir[$i]
				Local $str = $pixel[0] & "-" & $pixel[1] & "-" & "ELIXIR"
				If isInsideDiamond($pixel) Then
					If $pixel[0] <= $InternalArea[2][0] Then
						If $pixel[1] <= $InternalArea[0][1] Then
							;SetLog($str & " :  TOP LEFT SIDE")
							$g_aiPixelNearCollectorTopLeftSTR &= $str & "|"
						Else
							;SetLog($str & " :  BOTTOM LEFT SIDE")
							$g_aiPixelNearCollectorBottomLeftSTR &= $str & "|"
						EndIf
					Else
						If $pixel[1] <= $InternalArea[0][1] Then
							;SetLog($str & " :  TOP RIGHT SIDE")
							$g_aiPixelNearCollectorTopRightSTR &= $str & "|"
						Else
							;SetLog($str & " :  BOTTOM RIGHT SIDE")
							$g_aiPixelNearCollectorBottomRightSTR &= $str & "|"
						EndIf
					EndIf
				EndIf
			Next
		EndIf
		SetLog("> Elixir collectors located in " & Round(__timerdiff($hTimer) / 1000, 2) & " seconds", $COLOR_INFO)
	Else
		SetLog("> Elixir collectors detection not needed, skip", $COLOR_INFO)
	EndIf
	If _Sleep($DELAYRESPOND) Then Return

	;04.03 If drop troop near drill
	If $g_bCSVLocateDrill = True Then
		;SetLog("Locating drills")
		$hTimer = __timerinit()
		SuspendAndroid()
		$g_aiPixelDarkElixir = GetLocationDarkElixir()
		ResumeAndroid()
		If _Sleep($DELAYRESPOND) Then Return
		CleanRedArea($g_aiPixelDarkElixir)
		Local $htimerMine = Round(__timerdiff($hTimer) / 1000, 2)
		If (IsArray($g_aiPixelDarkElixir)) Then
			For $i = 0 To UBound($g_aiPixelDarkElixir) - 1
				Local $pixel = $g_aiPixelDarkElixir[$i]
				Local $str = $pixel[0] & "-" & $pixel[1] & "-" & "DRILL"
				If isInsideDiamond($pixel) Then
					If $pixel[0] <= $InternalArea[2][0] Then
						If $pixel[1] <= $InternalArea[0][1] Then
							;SetLog($str & " :  TOP LEFT SIDE")
							$g_aiPixelNearCollectorTopLeftSTR &= $str & "|"
						Else
							;SetLog($str & " :  BOTTOM LEFT SIDE")
							$g_aiPixelNearCollectorBottomLeftSTR &= $str & "|"
						EndIf
					Else
						If $pixel[1] <= $InternalArea[0][1] Then
							;SetLog($str & " :  TOP RIGHT SIDE")
							$g_aiPixelNearCollectorTopRightSTR &= $str & "|"
						Else
							;SetLog($str & " :  BOTTOM RIGHT SIDE")
							$g_aiPixelNearCollectorBottomRightSTR &= $str & "|"
						EndIf
					EndIf
				EndIf
			Next
		EndIf
		SetLog("> Drills located in " & Round(__timerdiff($hTimer) / 1000, 2) & " seconds", $COLOR_INFO)
	Else
		SetLog("> Drills detection not needed, skip", $COLOR_INFO)
	EndIf
	If _Sleep($DELAYRESPOND) Then Return

	If StringLen($g_aiPixelNearCollectorTopLeftSTR) > 0 Then $g_aiPixelNearCollectorTopLeftSTR = StringLeft($g_aiPixelNearCollectorTopLeftSTR, StringLen($g_aiPixelNearCollectorTopLeftSTR) - 1)
	If StringLen($g_aiPixelNearCollectorTopRightSTR) > 0 Then $g_aiPixelNearCollectorTopRightSTR = StringLeft($g_aiPixelNearCollectorTopRightSTR, StringLen($g_aiPixelNearCollectorTopRightSTR) - 1)
	If StringLen($g_aiPixelNearCollectorBottomLeftSTR) > 0 Then $g_aiPixelNearCollectorBottomLeftSTR = StringLeft($g_aiPixelNearCollectorBottomLeftSTR, StringLen($g_aiPixelNearCollectorBottomLeftSTR) - 1)
	If StringLen($g_aiPixelNearCollectorBottomRightSTR) > 0 Then $g_aiPixelNearCollectorBottomRightSTR = StringLeft($g_aiPixelNearCollectorBottomRightSTR, StringLen($g_aiPixelNearCollectorBottomRightSTR) - 1)
	$g_aiPixelNearCollectorTopLeft = GetListPixel3($g_aiPixelNearCollectorTopLeftSTR)
	$g_aiPixelNearCollectorTopRight = GetListPixel3($g_aiPixelNearCollectorTopRightSTR)
	$g_aiPixelNearCollectorBottomLeft = GetListPixel3($g_aiPixelNearCollectorBottomLeftSTR)
	$g_aiPixelNearCollectorBottomRight = GetListPixel3($g_aiPixelNearCollectorBottomRightSTR)


	; 05 - Gold, Elixir and Dark Elixir STORAGES ------------------------------------------------------------------------

	If $g_bCSVLocateStorageGold = True Then
		$aResult = GetLocationBuilding($eBldgGoldS, $g_iSearchTH, False)
		If $aResult <> -1 Then ; check if Monkey ate bad banana
			If $aResult = 1 Then
				SetLog("> " & $g_sBldgNames[$eBldgGoldS] & " Not found", $COLOR_WARNING)
			Else
				$aResult = _ObjGetValue($g_oBldgAttackInfo, $eBldgGoldS & "_LOCATION")
				If @error Then
					_ObjErrMsg("_ObjGetValue " & $g_sBldgNames[$eBldgGoldS] & " _LOCATION", @error) ; Log errors
					SetLog("> " & $g_sBldgNames[$eBldgGoldS] & " location not in dictionary", $COLOR_WARNING)
				Else
					If IsArray($aResult) Then $g_aiCSVGoldStoragePos = $aResult
				EndIf
			EndIf
		Else
			SetLog("Monkey ate bad banana: " & "GetLocationBuilding " & $g_sBldgNames[$eBldgGoldS], $COLOR_ERROR)
		EndIf
	EndIf

	If $g_bCSVLocateStorageElixir = True Then
		$aResult = GetLocationBuilding($eBldgElixirS, $g_iSearchTH, False)
		If @error And $g_bDebugSetlog Then _logErrorGetBuilding(@error)
		If $aResult <> -1 Then ; check if Monkey ate bad banana
			If $aResult = 1 Then
				SetLog("> " & $g_sBldgNames[$eBldgElixirS] & " Not found", $COLOR_WARNING)
			Else
				$aResult = _ObjGetValue($g_oBldgAttackInfo, $eBldgElixirS & "_LOCATION")
				If @error Then
					_ObjErrMsg("_ObjGetValue " & $g_sBldgNames[$eBldgElixirS] & " _LOCATION", @error) ; Log errors
					SetLog("> " & $g_sBldgNames[$eBldgElixirS] & " location not in dictionary", $COLOR_WARNING)
				Else
					If IsArray($aResult) Then $g_aiCSVElixirStoragePos = $aResult
				EndIf
			EndIf
		Else
			SetLog("Monkey ate bad banana: " & "GetLocationBuilding " & $g_sBldgNames[$eBldgElixirS], $COLOR_ERROR)
		EndIf
	EndIf

	If $g_bCSVLocateStorageDarkElixir = True Then
		$hTimer = __timerinit()
		SuspendAndroid()
		Local $g_aiPixelDarkElixirStorage = GetLocationDarkElixirStorageWithLevel()
		ResumeAndroid()
		If _Sleep($DELAYRESPOND) Then Return
		CleanRedArea($g_aiPixelDarkElixirStorage)
		Local $pixel = StringSplit($g_aiPixelDarkElixirStorage, "#", 2)
		If UBound($pixel) >= 2 Then
			Local $pixellevel = $pixel[0]
			Local $pixelpos = StringSplit($pixel[1], "-", 2)
			If UBound($pixelpos) >= 2 Then
				Local $temp = [Int($pixelpos[0]), Int($pixelpos[1])]
				$g_aiCSVDarkElixirStoragePos = $temp
			EndIf
		EndIf
		SetLog("> Dark Elixir Storage located in " & Round(__timerdiff($hTimer) / 1000, 2) & " seconds", $COLOR_INFO)
	Else
		SetLog("> Dark Elixir Storage detection not need, skip", $COLOR_INFO)
	EndIf

	; 06 - EAGLE ARTILLERY ------------------------------------------------------------------------

	$g_aiCSVEagleArtilleryPos = "" ; reset pixel position to null

	If $g_bCSVLocateEagle = True Then ; eagle find required?
		If $g_iSearchTH = "-" Or $g_iSearchTH > 10 Then ; TH level where eagle exists?
			If _ObjSearch($g_oBldgAttackInfo, $eBldgEagle & "_LOCATION") = False Then ; get data if not already exist?
				$aResult = GetLocationBuilding($eBldgEagle, $g_iSearchTH, False)
				If $aResult = -1 Then SetLog("Monkey ate bad banana: " & "GetLocationBuilding " & $g_sBldgNames[$eBldgEagle], $COLOR_ERROR)
			EndIf
			$aResult = _ObjGetValue($g_oBldgAttackInfo, $eBldgEagle & "_LOCATION")
			If @error Then
				_ObjErrMsg("_ObjGetValue " & $g_sBldgNames[$eBldgEagle] & " _LOCATION", @error) ; Log errors
				SetLog("> " & $g_sBldgNames[$eBldgEagle] & " location not in dictionary", $COLOR_WARNING)
			Else
				If IsArray($aResult[0]) Then $g_aiCSVEagleArtilleryPos = $aResult[0]
			EndIf
		Else
			SetLog("> TH Level to low for Eagle, skip detection", $COLOR_INFO)
		EndIf
	Else
		SetDebugLog("> Eagle Artillery detection not need, skipping", $COLOR_DEBUG)
	EndIf

	; 07 - Inferno ------------------------------------------------------------------------

	$g_aiCSVInfernoPos = "" ; reset location array?

	If $g_bCSVLocateInferno = True Then
		If $g_iSearchTH = "-" Or $g_iSearchTH > 9 Then
			If _ObjSearch($g_oBldgAttackInfo, $eBldgInferno & "_LOCATION") = False Then
				$aResult = GetLocationBuilding($eBldgInferno, $g_iSearchTH, False)
				If $aResult = -1 Then SetLog("Monkey ate bad banana: " & "GetLocationBuilding " & $g_sBldgNames[$eBldgInferno], $COLOR_ERROR)
			EndIf
			$aResult = _ObjGetValue($g_oBldgAttackInfo, $eBldgInferno & "_LOCATION")
			If @error Then
				_ObjErrMsg("_ObjGetValue " & $g_sBldgNames[$eBldgInferno] & " _LOCATION", @error) ; Log errors
				SetLog("> " & $g_sBldgNames[$eBldgInferno] & " location not in dictionary", $COLOR_WARNING)
			Else
				If IsArray($aResult) Then $g_aiCSVInfernoPos = $aResult
			EndIf
		Else
			SetLog("> TH Level to low for Inferno, ignore location", $COLOR_INFO)
		EndIf
	Else
		SetDebugLog("> Inferno detection not need, skipping", $COLOR_DEBUG)
	EndIf

	; 08 - X-Bow ------------------------------------------------------------------------

	$g_aiCSVXBowPos = "" ; reset location array?

	If $g_bCSVLocateXBow = True Then
		If $g_iSearchTH = "-" Or $g_iSearchTH > 8 Then
			If _ObjSearch($g_oBldgAttackInfo, $eBldgXBow & "_LOCATION") = False Then
				$aResult = GetLocationBuilding($eBldgXBow, $g_iSearchTH, False)
				If $aResult = -1 Then SetLog("Monkey ate bad banana: " & "GetLocationBuilding " & $g_sBldgNames[$eBldgXBow], $COLOR_ERROR)
			EndIf
			$aResult = _ObjGetValue($g_oBldgAttackInfo, $eBldgXBow & "_LOCATION")
			If @error Then
				_ObjErrMsg("_ObjGetValue " & $g_sBldgNames[$eBldgXBow] & " _LOCATION", @error) ; Log errors
				SetLog("> " & $g_sBldgNames[$eBldgXBow] & " location not in dictionary", $COLOR_WARNING)
			Else
				If IsArray($aResult) Then $g_aiCSVXBowPos = $aResult
			EndIf
		Else
			SetLog("> TH Level to low for " & $g_sBldgNames[$eBldgXBow] & " , ignore location", $COLOR_INFO)
		EndIf
	Else
		SetDebugLog("> " & $g_sBldgNames[$eBldgXBow] & " detection not need, skipping", $COLOR_DEBUG)
	EndIf


	; 09 - Wizard Tower -----------------------------------------------------------------

	$g_aiCSVWizTowerPos = "" ; reset location array?

	If $g_bCSVLocateWizTower = True Then
		If _ObjSearch($g_oBldgAttackInfo, $eBldgWizTower & "_LOCATION") = False Then
			$aResult = GetLocationBuilding($eBldgWizTower, $g_iSearchTH, False)
			If $aResult = -1 Then SetLog("Monkey ate bad banana: " & "GetLocationBuilding " & $g_sBldgNames[$eBldgWizTower], $COLOR_ERROR)
		EndIf
		$aResult = _ObjGetValue($g_oBldgAttackInfo, $eBldgWizTower & "_LOCATION")
		If @error Then
			_ObjErrMsg("_ObjGetValue " & $g_sBldgNames[$eBldgWizTower] & " _LOCATION", @error) ; Log errors
			SetLog("> " & $g_sBldgNames[$eBldgWizTower] & " location not in dictionary", $COLOR_WARNING)
		Else
			If IsArray($aResult) Then $g_aiCSVWizTowerPos = $aResult
		EndIf
	Else
		SetDebugLog("> " & $g_sBldgNames[$eBldgWizTower] & " detection not need, skipping", $COLOR_DEBUG)
	EndIf

	; 10 - Mortar ------------------------------------------------------------------------

	$g_aiCSVMortarPos = "" ; reset location array?

	If $g_bCSVLocateMortar = True Then
		If _ObjSearch($g_oBldgAttackInfo, $eBldgMortar & "_LOCATION") = False Then
			$aResult = GetLocationBuilding($eBldgMortar, $g_iSearchTH, False)
			If $aResult = -1 Then SetLog("Monkey ate bad banana: " & "GetLocationBuilding " & $g_sBldgNames[$eBldgMortar], $COLOR_ERROR)
		EndIf
		$aResult = _ObjGetValue($g_oBldgAttackInfo, $eBldgMortar & "_LOCATION")
		If @error Then
			_ObjErrMsg("_ObjGetValue " & $g_sBldgNames[$eBldgMortar] & " _LOCATION", @error) ; Log errors
			SetLog("> " & $g_sBldgNames[$eBldgMortar] & " location not in dictionary", $COLOR_WARNING)
		Else
			If IsArray($aResult) Then $g_aiCSVMortarPos = $aResult
		EndIf
	Else
		SetDebugLog("> " & $g_sBldgNames[$eBldgMortar] & " detection not need, skipping", $COLOR_DEBUG)
	EndIf

	; 11 - Air Defense ------------------------------------------------------------------------

	$g_aiCSVAirDefensePos = "" ; reset location array?

	If $g_bCSVLocateAirDefense = True Then
		If _ObjSearch($g_oBldgAttackInfo, $eBldgAirDefense & "_LOCATION") = False Then
			$aResult = GetLocationBuilding($eBldgAirDefense, $g_iSearchTH, False)
			If $aResult = -1 Then SetLog("Monkey ate bad banana: " & "GetLocationBuilding " & $g_sBldgNames[$eBldgAirDefense], $COLOR_ERROR)
		EndIf
		$aResult = _ObjGetValue($g_oBldgAttackInfo, $eBldgAirDefense & "_LOCATION")
		If @error Then
			_ObjErrMsg("_ObjGetValue " & $g_sBldgNames[$eBldgAirDefense] & " _LOCATION", @error) ; Log errors
			SetLog("> " & $g_sBldgNames[$eBldgAirDefense] & " location not in dictionary", $COLOR_WARNING)
		Else
			If IsArray($aResult) Then $g_aiCSVAirDefensePos = $aResult
		EndIf
	Else
		SetDebugLog("> " & $g_sBldgNames[$eBldgAirDefense] & " detection not need, skipping", $COLOR_DEBUG)
	EndIf

	; Log total CSV prep time
	SetLog(">> Total time: " & Round(__timerdiff($hTimerTOTAL) / 1000, 2) & " seconds", $COLOR_INFO)

	; 12 - DEBUGIMAGE ------------------------------------------------------------------------
	If $g_bDebugMakeIMGCSV Then AttackCSVDEBUGIMAGE() ;make IMG debug
	If $g_bDebugAttackCSV Then _LogObjList($g_oBldgAttackInfo) ; display dictionary for raw find image debug

	; 13 - START TH SNIPE BEFORE ATTACK CSV IF NEED ------------------------------------------
	If $g_bTHSnipeBeforeEnable[$DB] And $g_iSearchTH = "-" Then FindTownHall(True) ;search townhall if no previous detect
	If $g_bTHSnipeBeforeEnable[$DB] Then
		If $g_iSearchTH <> "-" Then
			If SearchTownHallLoc() Then
				SetLogCentered(" TH snipe Before Scripted Attack ", Default, $COLOR_INFO)
				$g_bTHSnipeUsedKing = False
				$g_bTHSnipeUsedQueen = False
				AttackTHParseCSV()
			Else
				If $g_bDebugSetlog Then SetDebugLog("TH snipe before scripted attack skip, th internal village", $COLOR_DEBUG)
			EndIf
		Else
			If $g_bDebugSetlog Then SetDebugLog("TH snipe before scripted attack skip, no th found", $COLOR_DEBUG)
		EndIf
	EndIf

	; 14 - LAUNCH PARSE FUNCTION -------------------------------------------------------------
	SetSlotSpecialTroops()
	If _Sleep($DELAYRESPOND) Then Return

;	If TestCapture() = True Then
;		; no launch when testing with image
;		Return
;	EndIf

	ParseAttackCSV($testattack)

	CheckHeroesHealth()

EndFunc   ;==>Algorithm_AttackCSV

