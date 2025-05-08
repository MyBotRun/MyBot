Func CleanBBYard()
	; Early exist if noting to do
	If Not $g_bChkCleanBBYard And Not TestCapture() Then Return

	; Timer
	Local $hObstaclesTimer = __TimerInit()
	If _Sleep($DELAYRESPOND) Then Return

	; Setup arrays, including default return values for $return
	Local $bLocate = False
	Local $sCocDiamond = $CocDiamondECD
	Local $redLines = $sCocDiamond
	Local $iBBElixir = 50000
	Local $aTempArray, $aTempName, $aTempCoords, $aTempMultiCoords
	Local $aObstacles[0][3], $bFoundObstacles = False

	If Number($g_aiCurrentLootBB[$eLootElixirBB]) > $iBBElixir Then
		Local $aResult = findMultiple($g_sImgCleanBBYard, $sCocDiamond, $redLines, 0, 1000, 0, "objectname,objectpoints", True)
		If $aResult <> "" And IsArray($aResult) Then
			SetLog("Yard Cleaning Process", $COLOR_OLIVE)
			;Add found results into our Arrays
			For $i = 0 To UBound($aResult, 1) - 1
				$aTempArray = $aResult[$i]
				$aTempName = $aTempArray[0] ; Filename
				$aTempMultiCoords = decodeMultipleCoords($aTempArray[1], 5, 5)
				For $j = 0 To UBound($aTempMultiCoords, 1) - 1
					$aTempCoords = $aTempMultiCoords[$j]
					_ArrayAdd($aObstacles, $aTempName & "|" & $aTempCoords[0] & "|" & $aTempCoords[1])
					$bFoundObstacles = True
				Next
			Next
			If $bFoundObstacles Then
				For $i = 0 To UBound($aObstacles) - 1
					$aObstacles[$i][1] = Number($aObstacles[$i][1])
					$aObstacles[$i][2] = Number($aObstacles[$i][2])
				Next
				RemoveDupXYObs($aObstacles)
				For $i = 0 To UBound($aObstacles, 1) - 1
					If isInsideDiamondXY($aObstacles[$i][1], $aObstacles[$i][2]) Then ; secure x because of clan chat tab
						If $g_bDebugSetLog Then SetDebugLog($aObstacles[$i][0] & " found (" & $aObstacles[$i][1] & "," & $aObstacles[$i][2] & ")", $COLOR_SUCCESS)
						If IsMainPageBuilderBase() Then Click($aObstacles[$i][1], $aObstacles[$i][2], 1, 120, "#0430")
						$bLocate = True
						If _Sleep($DELAYCOLLECT3) Then Return
						If Not ClickRemoveObstacleBB() Then ContinueLoop
						If _Sleep($DELAYCHECKTOMBS2) Then Return
						ClearScreen("Defaut", False)
						If _Sleep($DELAYCHECKTOMBS1) Then Return
					EndIf
				Next
			EndIf
		EndIf
	EndIf

	If Not $bLocate And $g_bChkCleanBBYard And Number($g_aiCurrentLootBB[$eLootElixirBB]) > 50000 Then SetLog("No Obstacles found, Yard is clean!", $COLOR_SUCCESS)
	SetDebugLog("Time: " & Round(__TimerDiff($hObstaclesTimer) / 1000, 2) & "'s", $COLOR_SUCCESS)
	UpdateStats()
	ClearScreen("Defaut", False)
EndFunc   ;==>CleanBBYard

Func ClickRemoveObstacleBB()
	If _ColorCheck(_GetPixelColor(400, 285 + $g_iMidOffsetY, True), Hex(0xF3AA28, 6), 20) Then  ; close chat
		If Not ClickB("ClanChat") Then
			SetLog("Error finding the Clan Tab Button", $COLOR_ERROR)
			Click(400, 312 + $g_iMidOffsetY)
			Return
		EndIf
		If _Sleep(500) Then Return
		Return False
	EndIf

	Local $bLoop = 0
	While 1
		Local $aiButton = findButton("RemoveObstacle", Default, 1, True)
		If (IsArray($aiButton) And UBound($aiButton) >= 2) Or $bLoop = 20 Then ExitLoop
		If _Sleep(200) Then Return
		$bLoop += 1
	WEnd

	Local $aiButton = findButton("RemoveObstacle", Default, 1, True)
	If IsArray($aiButton) And UBound($aiButton) >= 2 Then
		SetDebugLog("Remove Button found! Clicking it at X: " & $aiButton[0] & ", Y: " & $aiButton[1], $COLOR_DEBUG1)
		ClickP($aiButton)
		If _Sleep(1000) Then Return
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>ClickRemoveObstacleBB
