Func CleanBBYard()
	; Early exist if noting to do
	If Not $g_bChkCleanBBYard And Not TestCapture() Then Return

	; Timer
	Local $hObstaclesTimer = __TimerInit()

	; Get Builders available
	If Not getBuilderCount(True, True) Then Return ; update builder data, return if problem
	If _Sleep($DELAYRESPOND) Then Return

	; Obstacles function to Parallel Search , will run all pictures inside the directory

	; Setup arrays, including default return values for $return
	Local $Filename = ""
	Local $Locate = 0
	Local $CleanBBYardXY
	Local $sCocDiamond = $CocDiamondECD
	Local $redLines = $sCocDiamond
	Local $bBuilderBase = True
	Local $bNoBuilders = $g_iFreeBuilderCountBB < 1

	If $g_iFreeBuilderCountBB > 0 And Number($g_aiCurrentLootBB[$eLootElixirBB]) > 50000 Then
		Local $aResult = findMultiple($g_sImgCleanBBYard, $sCocDiamond, $redLines, 0, 1000, 10, "objectname,objectlevel,objectpoints", True)
		If IsArray($aResult) Then
			For $matchedValues In $aResult
				Local $aPoints = decodeMultipleCoords($matchedValues[2])
				$Filename = $matchedValues[0] ; Filename
				For $i = 0 To UBound($aPoints) - 1
					$CleanBBYardXY = $aPoints[$i] ; Coords
					If UBound($CleanBBYardXY) > 1 And isInsideDiamondXY($CleanBBYardXY[0], $CleanBBYardXY[1]) Then ; secure x because of clan chat tab
						If $g_bDebugSetlog Then SetDebugLog($Filename & " found (" & $CleanBBYardXY[0] & "," & $CleanBBYardXY[1] & ")", $COLOR_SUCCESS)
						If IsMainPageBuilderBase() Then Click($CleanBBYardXY[0], $CleanBBYardXY[1], 1, 0, "#0430")
						$Locate = 1
						If _Sleep($DELAYCOLLECT3) Then Return
						If IsMainPageBuilderBase() Then GemClick($aCleanYard[0], $aCleanYard[1], 1, 0, "#0431") ; Click Obstacles button to clean
						If _Sleep($DELAYCHECKTOMBS2) Then Return
						ClickP($aAway, 2, 300, "#0329") ;Click Away
						If _Sleep($DELAYCHECKTOMBS1) Then Return
						If getBuilderCount(True, True) = False Then Return ; update builder data, return if problem
						If _Sleep($DELAYRESPOND) Then Return
						If $g_iFreeBuilderCountBB = 0 Then
							SetLog("No More Builders available")
							If _Sleep(2000) Then Return
							ExitLoop (2)
						EndIf
					EndIf
				Next
			Next
		EndIf
	EndIf

	If $bNoBuilders Then
		SetLog("No Builders available to remove Obstacles!")
	Else
		If $Locate = 0 And $g_bChkCleanBBYard And Number($g_aiCurrentLootBB[$eLootElixirBB]) > 50000 Then SetLog("No Obstacles found, Yard is clean!", $COLOR_SUCCESS)
		If $g_bDebugSetlog Then SetDebugLog("Time: " & Round(__TimerDiff($hObstaclesTimer) / 1000, 2) & "'s", $COLOR_SUCCESS)
	EndIf
	UpdateStats()
	ClickP($aAway, 1, 300, "#0329") ;Click Away

EndFunc   ;==>CleanBBYard