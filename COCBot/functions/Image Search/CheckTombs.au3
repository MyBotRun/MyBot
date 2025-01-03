; #FUNCTION# ====================================================================================================================
; Name ..........: CheckTombs.au3
; Description ...: This file Includes function to perform defense farming.
; Syntax ........:
; Parameters ....: None
; Return values .: False if regular farming is needed to refill storage
; Author ........: barracoda/KnowJack (2015)
; Modified ......: sardo (05-2015/06-2015) , ProMac (04-2016), MonkeyHuner (06-2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CheckTombs()
	If Not TestCapture() Then
		If Not $g_bChkTombstones Then Return False
		If Not $g_abNotNeedAllTime[1] Then Return
	EndIf
	; Timer
	Local $hTimer = __TimerInit()
	Local $bRemoved1 = False, $bRemoved2 = False

	; Setup arrays, including default return values for $return
	Local $return[7] = ["None", "None", 0, 0, 0, "", ""]
	Local $TombsXY[2] = [0, 0]

	; Perform a parallel search with all images inside the directory
	Local $aResult = returnSingleMatchOwnVillage($g_sImgClearTombs)

	If UBound($aResult) > 1 Then
		; Now loop through the array to modify values, select the highest entry to return
		For $i = 1 To UBound($aResult) - 1
			; Check to see if its a higher level then currently stored
			If Number($aResult[$i][2]) > Number($return[2]) Then
				; Store the data because its higher
				$return[0] = $aResult[$i][0] ; Filename
				$return[1] = $aResult[$i][1] ; Type
				$return[4] = $aResult[$i][4] ; Total Objects
				$return[5] = $aResult[$i][5] ; Coords
			EndIf
		Next
		$TombsXY = $return[5]

		If $g_bDebugSetLog Then SetDebugLog("Filename :" & $return[0])
		If $g_bDebugSetLog Then SetDebugLog("Type :" & $return[1])
		If $g_bDebugSetLog Then SetDebugLog("Total Objects :" & $return[4])

		If IsArray($TombsXY) Then
			; Loop through all found points for the item and click them to clear them, there should only be one
			For $j = 0 To UBound($TombsXY) - 1
				If IsCoordSafe($TombsXY[$j][0], $TombsXY[$j][1]) Then
					If $g_bDebugSetLog Then SetDebugLog("Coords :" & $TombsXY[$j][0] & "," & $TombsXY[$j][1])
					If IsMainPage() Then
						Click($TombsXY[$j][0], $TombsXY[$j][1], 1, 120, "#0430")
						If Not $bRemoved1 Then $bRemoved1 = True
					EndIf
				EndIf
			Next
		EndIf

		If $bRemoved1 Then
			If _Sleep($DELAYCHECKTOMBS2) Then Return
			;Second try if root tombs at first step
			Local $return2[7] = ["None", "None", 0, 0, 0, "", ""]
			Local $TombsXY2[2] = [0, 0]
			; Perform a parallel search with all images inside the directory
			Local $aResult2 = returnSingleMatchOwnVillage($g_sImgClearTombs)

			If UBound($aResult2) > 1 Then
				; Now loop through the array to modify values, select the highest entry to return2
				For $t = 1 To UBound($aResult2) - 1
					; Check to see if its a higher level then currently stored
					If Number($aResult2[$t][2]) > Number($return2[2]) Then
						; Store the data because its higher
						$return2[0] = $aResult2[$t][0] ; Filename
						$return2[1] = $aResult2[$t][1] ; Type
						$return2[4] = $aResult2[$t][4] ; Total Objects
						$return2[5] = $aResult2[$t][5] ; Coords
					EndIf
				Next
				$TombsXY2 = $return2[5]

				If $g_bDebugSetLog Then SetDebugLog("Filename :" & $return2[0])
				If $g_bDebugSetLog Then SetDebugLog("Type :" & $return2[1])
				If $g_bDebugSetLog Then SetDebugLog("Total Objects :" & $return2[4])

				If IsArray($TombsXY2) Then
					; Loop through all found points for the item and click them to clear them, there should only be one
					For $z = 0 To UBound($TombsXY2) - 1
						If IsCoordSafe($TombsXY2[$z][0], $TombsXY2[$z][1]) Then
							If $g_bDebugSetLog Then SetDebugLog("Coords :" & $TombsXY2[$z][0] & "," & $TombsXY2[$z][1])
							If IsMainPage() Then
								Click($TombsXY2[$z][0], $TombsXY2[$z][1], 1, 120, "#0430")
								If Not $bRemoved2 Then $bRemoved2 = True
							EndIf
						EndIf
					Next
				EndIf
			EndIf
		EndIf

		If BitOR($bRemoved1, $bRemoved2) Then
			SetLog("Tombs removed!", $COLOR_DEBUG1)
			$g_abNotNeedAllTime[1] = False
			If _Sleep(300) Then Return
			ClearScreen()
		Else
			SetLog("Tombs not removed, please do manually!", $COLOR_WARNING)
		EndIf
	Else
		SetLog("No Tombs Found!", $COLOR_SUCCESS)
		$g_abNotNeedAllTime[1] = False
	EndIf

	checkMainScreen(False) ; check for screen errors while function was running
EndFunc   ;==>CheckTombs

Func CleanYard()

	; Early exist if noting to do
	If Not $g_bChkCleanYard And Not $g_bChkGemsBox And Not TestCapture() Then Return

	; Timer
	Local $hObstaclesTimer = __TimerInit()

	; Get Builders available
	If Not getBuilderCount() Then Return ; update builder data, return if problem
	If _Sleep($DELAYRESPOND) Then Return

	; Obstacles function to Parallel Search , will run all pictures inside the directory

	; Setup arrays, including default return values for $return
	Local $bLocate = False
	Local $sCocDiamond = $CocDiamondECD
	Local $sRedLines = $CocDiamondECD
	Local $iElixir = 50000
	Local $bNoBuilders = $g_iFreeBuilderCount < 1
	Local $aTempArray, $aTempName, $aTempCoords, $aTempMultiCoords
	Local $aObstacles[0][3], $bFoundObstacles = False

	If $g_iFreeBuilderCount > 0 And $g_bChkCleanYard And Number($g_aiCurrentLoot[$eLootElixir]) > $iElixir Then
		Local $aResult = findMultiple($g_sImgCleanYard, $sCocDiamond, $sRedLines, 0, 1000, 0, "objectname,objectpoints", True)
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
					If IsCoordSafe($aObstacles[$i][1], $aObstacles[$i][2]) Then ; secure x because of clan chat tab
						If $g_bDebugSetLog Then SetDebugLog($aObstacles[$i][0] & " found (" & $aObstacles[$i][1] & "," & $aObstacles[$i][2] & ")", $COLOR_SUCCESS)
						If IsMainPage() Then Click($aObstacles[$i][1], $aObstacles[$i][2], 1, 120, "#0430")
						$bLocate = True
						If _Sleep($DELAYCOLLECT3) Then Return
						If Not ClickRemoveObstacle() Then ContinueLoop
						If _Sleep($DELAYCHECKTOMBS2) Then Return
						ClearScreen()
						If _Sleep($DELAYCHECKTOMBS1) Then Return
						If Not getBuilderCount() Then Return ; update builder data, return if problem
						If _Sleep($DELAYRESPOND) Then Return
						If $g_iFreeBuilderCount = 0 Then
							SetLog("No More Builders available")
							If _Sleep(2000) Then Return
							ExitLoop
						EndIf
					EndIf
				Next
			EndIf
		EndIf
	EndIf

	; Setup arrays, including default return values for $return
	Local $return[7] = ["None", "None", 0, 0, 0, "", ""]
	Local $GemBoxXY[2] = [0, 0]

	; Perform a parallel search with all images inside the directory
	If ($g_iFreeBuilderCount > 0 And $g_bChkGemsBox And Number($g_aiCurrentLoot[$eLootElixir]) > $iElixir) Or TestCapture() Then
		Local $aResult = multiMatches($g_sImgGemBox, 1, $sCocDiamond, $sCocDiamond)
		If UBound($aResult) > 1 Then
			; Now loop through the array to modify values, select the highest entry to return
			For $i = 1 To UBound($aResult) - 1
				; Check to see if its a higher level then currently stored
				If Number($aResult[$i][2]) > Number($return[2]) Then
					; Store the data because its higher
					$return[0] = $aResult[$i][0] ; Filename
					$return[1] = $aResult[$i][1] ; Type
					$return[4] = $aResult[$i][4] ; Total Objects
					$return[5] = $aResult[$i][5] ; Coords
				EndIf
			Next
			$GemBoxXY = $return[5]

			If $g_bDebugSetLog Then SetDebugLog("Filename :" & $return[0])
			If $g_bDebugSetLog Then SetDebugLog("Type :" & $return[1])
			If $g_bDebugSetLog Then SetDebugLog("Total Objects :" & $return[4])

			If IsArray($GemBoxXY) Then
				; Loop through all found points for the item and click them to remove it, there should only be one
				For $j = 0 To UBound($GemBoxXY) - 1
					If $g_bDebugSetLog Then SetDebugLog("Coords :" & $GemBoxXY[$j][0] & "," & $GemBoxXY[$j][1])
					If IsCoordSafe($GemBoxXY[$j][0], $GemBoxXY[$j][1]) Then
						If IsMainPage() Then Click($GemBoxXY[$j][0], $GemBoxXY[$j][1], 1, 120, "#0430")
						If _Sleep($DELAYCHECKTOMBS2) Then Return
						$bLocate = True
						If _Sleep($DELAYCOLLECT3) Then Return
						If Not ClickRemoveObstacle() Then ContinueLoop
						If _Sleep($DELAYCHECKTOMBS2) Then Return
						ClickP($aAway, 2, 300, "#0329") ;Click Away
						If _Sleep($DELAYCHECKTOMBS1) Then Return
						If Not getBuilderCount() Then Return ; update builder data, return if problem
						If _Sleep($DELAYRESPOND) Then Return
						If $g_iFreeBuilderCount = 0 Then
							SetLog("No More Builders available")
							If _Sleep(2000) Then Return
							ExitLoop
						EndIf
					EndIf
				Next
			EndIf
			SetLog("GemBox removed!", $COLOR_DEBUG1)
		Else
			SetLog("No GemBox Found!", $COLOR_SUCCESS)
		EndIf
	EndIf

	If $bNoBuilders Then
		SetLog("No Builders available to remove Obstacles!")
	Else
		If Not $bLocate And $g_bChkCleanYard And Number($g_aiCurrentLoot[$eLootElixir]) > $iElixir Then SetLog("No Obstacles found, Yard is clean!", $COLOR_SUCCESS)
		If $g_bDebugSetLog Then SetDebugLog("Time: " & Round(__TimerDiff($hObstaclesTimer) / 1000, 2) & "'s", $COLOR_SUCCESS)
	EndIf
	UpdateStats()
	ClearScreen()
EndFunc   ;==>CleanYard

Func ClickRemoveObstacle()
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

	If IsArray($aiButton) And UBound($aiButton) >= 2 Then
		SetDebugLog("Remove Button found! Clicking it at X: " & $aiButton[0] & ", Y: " & $aiButton[1], $COLOR_DEBUG1)
		ClickP($aiButton)
		If _Sleep(3000) Then Return
		Return True
	Else
		SetLog("Cannot find Remove Button", $COLOR_ERROR)
		Return False
	EndIf
EndFunc   ;==>ClickRemoveObstacle

Func RemoveDupXYObs(ByRef $arr)
	; Remove Dup X Sorted
	Local $atmparray[0][3]
	Local $tmpCoordX = 0
	Local $tmpCoordY = 0
	_ArraySort($arr, 0, 0, 0, 1) ;sort by x
	For $i = 0 To UBound($arr) - 1
		Local $a = $arr[$i][1] - $tmpCoordX
		Local $b = $arr[$i][2] - $tmpCoordY
		Local $c = Sqrt($a * $a + $b * $b)
		If $c < 25 Then
			SetDebugLog("Skip this dup : " & $arr[$i][0] & "," & $arr[$i][1] & "," & $arr[$i][2], $COLOR_INFO)
			ContinueLoop
		Else
			_ArrayAdd($atmparray, $arr[$i][0] & "|" & $arr[$i][1] & "|" & $arr[$i][2])
			$tmpCoordX = $arr[$i][1]
			$tmpCoordY = $arr[$i][2]
		EndIf
	Next
	; Remove Dup Y Sorted
	Local $atmparray2[0][3]
	$tmpCoordX = 0
	$tmpCoordY = 0
	_ArraySort($atmparray, 0, 0, 0, 2) ;sort by y
	For $i = 0 To UBound($atmparray) - 1
		Local $a = $atmparray[$i][1] - $tmpCoordX
		Local $b = $atmparray[$i][2] - $tmpCoordY
		Local $c = Sqrt($a * $a + $b * $b)
		If $c < 25 Then
			SetDebugLog("Skip this dup : " & $atmparray[$i][0] & "," & $atmparray[$i][1] & "," & $atmparray[$i][2], $COLOR_INFO)
			ContinueLoop
		Else
			_ArrayAdd($atmparray2, $atmparray[$i][0] & "|" & $atmparray[$i][1] & "|" & $atmparray[$i][2])
			$tmpCoordX = $atmparray[$i][1]
			$tmpCoordY = $atmparray[$i][2]
		EndIf
	Next
	_ArraySort($atmparray2, 0, 0, 0, 1) ;sort by x
	For $i = 0 To UBound($atmparray2) - 1
		$atmparray2[$i][1] = Number($atmparray2[$i][1])
		$atmparray2[$i][2] = Number($atmparray2[$i][2])
	Next
	$arr = $atmparray2
EndFunc   ;==>RemoveDupXYObs
