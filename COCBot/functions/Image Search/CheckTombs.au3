; #FUNCTION# ====================================================================================================================
; Name ..........: CheckTombs.au3
; Description ...: This file Includes function to perform defense farming.
; Syntax ........:
; Parameters ....: None
; Return values .: False if regular farming is needed to refill storage
; Author ........: barracoda/KnowJack (2015)
; Modified ......: sardo 2015-06 2015-08 , ProMac (04-2016), MonkeyHuner (06-2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CheckTombs()
	If $ichkTombstones <> 1 Then Return False

	; Timer
	Local $hTimer = TimerInit()

	; tombs function to Parallel Search
	Local $directory = @ScriptDir & "\images\Resources\Tombs"

	; Setup arrays, including default return values for $return
	Local $return[7] = ["None", "None", 0, 0, 0, "", ""]
	Local $TombsXY[2] = [0, 0]

	; Perform a parallel search with all images inside the directory
	Local $aResult = returnSingleMatchOwnVillage($directory)

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

		If $DebugSetLog = 1 Then SetLog("Filename :" & $return[0])
		If $DebugSetLog = 1 Then SetLog("Type :" & $return[1])
		If $DebugSetLog = 1 Then SetLog("Total Objects :" & $return[4])

		If IsArray($TombsXY) Then
			; Loop through all found points for the item and click them to clear them, there should only be one
			For $j = 0 To UBound($TombsXY) - 1
				If $DebugSetLog = 1 Then Setlog("Coords :" & $TombsXY[$j][0] & "," & $TombsXY[$j][1])
				If IsMainPage() Then Click($TombsXY[$j][0], $TombsXY[$j][1], 1, 0, "#0430")
			Next
		EndIf
		Setlog("Tombs removed!", $COLOR_TEAL)
	Else
		Setlog("No Tombs Found!", $COLOR_GREEN)
	EndIf

	checkMainScreen(False) ; check for screen errors while function was running
EndFunc   ;==>CheckTombs

Func CleanYard()


	;Boju Only clear GemBox
	;If $ichkCleanYard = 0 Then Return
	If $ichkCleanYard = 0 And $ichkGemsBox = 0 Then Return
	;Only clear GemBox

	; Timer
	Local $hObstaclesTimer = TimerInit()

	; Get Builders available
	If getBuilderCount() = False Then Return  ; update builder data, return if problem
	If _Sleep($iDelayRespond) Then Return

	; Obstacles function to Parallel Search , will run all pictures inside the directory
	Local $directory = @ScriptDir & "\images\Resources\Obstacles"

	; Setup arrays, including default return values for $return
	Local $Filename = ""
	Local $Locate = 0
	Local $CleanYardXY
	Local $maxReturnPoints = $iFreeBuilderCount

	If $iFreeBuilderCount > 0 And $ichkCleanYard = 1 Then
		Local $aResult = returnMultipleMatchesOwnVillage($directory, $maxReturnPoints)
		If UBound($aResult) > 1 Then
			For $i = 1 To UBound($aResult) - 1
				$Filename = $aResult[$i][1] ; Filename
				$CleanYardXY = $aResult[$i][5] ; Coords
				If IsArray($CleanYardXY) Then
					For $t = 0 To UBound($CleanYardXY) - 1 ; each filename can have several positions
						If isInsideDiamondXY($CleanYardXY[$t][0], $CleanYardXY[$t][1]) Then ; secure x because of clan chat tab
							If $DebugSetLog = 1 Then SetLog($Filename & " found (" & $CleanYardXY[$t][0] & "," & $CleanYardXY[$t][1] & ")", $COLOR_GREEN)
							If IsMainPage() Then Click($CleanYardXY[$t][0], $CleanYardXY[$t][1], 1, 0, "#0430")
							$Locate = 1
							If _Sleep($iDelayCollect3) Then Return
							If IsMainPage() Then GemClick($aCleanYard[0], $aCleanYard[1], 1, 0, "#0431") ; Click Obstacles button to clean
							If _Sleep($iDelayCheckTombs2) Then Return
							ClickP($aAway, 2, 300, "#0329") ;Click Away
							If _Sleep($iDelayCheckTombs1) Then Return
							If getBuilderCount() = False Then Return  ; update builder data, return if problem
							If _Sleep($iDelayRespond) Then Return
							If $iFreeBuilderCount = 0 Then
								Setlog("No More Builders available")
								If _Sleep(2000) Then Return
								ExitLoop (2)
							EndIf
						EndIf
					Next
				EndIf
			Next
		EndIf
	EndIf

	; GemBox function to Parallel Search , will run all pictures inside the directory
	Local $directoryGemBox = @ScriptDir & "\images\Resources\GemBox"

	; Setup arrays, including default return values for $return
	Local $return[7] = ["None", "None", 0, 0, 0, "", ""]
	Local $GemBoxXY[2] = [0, 0]

	; Perform a parallel search with all images inside the directory
	If $iFreeBuilderCount > 0 And $ichkGemsBox = 1 Then
		Local $aResult = returnSingleMatchOwnVillage($directoryGemBox)
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

			If $DebugSetLog = 1 Then SetLog("Filename :" & $return[0])
			If $DebugSetLog = 1 Then SetLog("Type :" & $return[1])
			If $DebugSetLog = 1 Then SetLog("Total Objects :" & $return[4])

			If IsArray($GemBoxXY) Then
				; Loop through all found points for the item and click them to remove it, there should only be one
				For $j = 0 To UBound($GemBoxXY) - 1
					If $DebugSetLog = 1 Then Setlog("Coords :" & $GemBoxXY[$j][0] & "," & $GemBoxXY[$j][1])
					If Number($GemBoxXY[$j][0]) > 80 Then
						If IsMainPage() Then Click($GemBoxXY[$j][0], $GemBoxXY[$j][1], 1, 0, "#0430")
						If _Sleep($iDelayCheckTombs2) Then Return
						$Locate = 1
						If _Sleep($iDelayCollect3) Then Return
						If IsMainPage() Then Click($aCleanYard[0], $aCleanYard[1], 1, 0, "#0431") ; Click GemBox button to remove item
						If _Sleep($iDelayCheckTombs2) Then Return
						ClickP($aAway, 2, 300, "#0329") ;Click Away
						If _Sleep($iDelayCheckTombs1) Then Return
						If getBuilderCount() = False Then Return  ; update builder data, return if problem
						If _Sleep($iDelayRespond) Then Return
						If $iFreeBuilderCount = 0 Then
							Setlog("No More Builders available")
							If _Sleep(2000) Then Return
							ExitLoop
						EndIf
					EndIf
				Next
			EndIf
			Setlog("GemBox removed!", $COLOR_TEAL)
		Else
			Setlog("No GemBox Found!", $COLOR_GREEN)
		EndIf
	EndIf

	If $Locate = 0 Then SetLog("No Obstacles found, Yard is clean!", $COLOR_GREEN)
	If $DebugSetLog = 1 Then SetLog("Time: " & Round(TimerDiff($hObstaclesTimer) / 1000, 2) & "'s", $COLOR_GREEN)
	UpdateStats()
	ClickP($aAway, 1, 300, "#0329") ;Click Away

EndFunc   ;==>CleanYard


