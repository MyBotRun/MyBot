; #FUNCTION# ====================================================================================================================
; Name ..........: IsWeakBase()
; Description ...: Checks to see if the base can be classified a weak base
; Syntax ........:
; Parameters ....: None
; Return values .: An array of values of detected defense levels and information
; Author ........: LunaEclipse(April 2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

; Enum for Weak Base Defense Types
Global Enum $eWeakEagle = 1, $eWeakInferno, $eWeakXBow, $eWeakWizard, $eWeakMortar

; Weak Base Defense Building Information
Global $weakDefenseNames[6] = ["None", "Eagle Artillery", "Inferno Tower", "XBow", "Wizard Tower", "Mortar"]
Global $weakDefenseMaxLevels[6] = [0, 2, 4, 4, 9, 9]

Func createWeakBaseStats()
	; Get the directory file contents as keys for the stats file
	Local $aKeys = _FileListToArrayRec(@ScriptDir & "\images\WeakBase", "*.png", $FLTAR_FILES, $FLTAR_RECUR, $FLTAR_SORT, $FLTAR_NOPATH)
	; Create our return array
	Local $return[UBound($aKeys) - 1][2]

	; If the stats file doesn't exist, create it
	If Not FileExists($statChkWeakBase) Then _FileCreate($statChkWeakBase)

	; Loop through the keys
	For $i = 1 To UBound($aKeys) - 1
		; Set the return array values
		$return[$i - 1][0] = $aKeys[$i] ; Filename
		$return[$i - 1][1] = 0 ; Number

		; Write the entry to the stats file
		IniWrite($statChkWeakBase, "WeakBase", $aKeys[$i], "0")
	Next

	Return $return
EndFunc   ;==>createWeakBaseStats

Func readWeakBaseStats()
	; Get the directory file contents as keys for the stats file
	Local $aKeys = _FileListToArrayRec(@ScriptDir & "\images\WeakBase", "*.png", $FLTAR_FILES, $FLTAR_RECUR, $FLTAR_SORT, $FLTAR_NOPATH)
	; Create our return array
	Local $return[UBound($aKeys) - 1][2]

	; Check to see if the stats file exists
	If FileExists($statChkWeakBase) Then
		; Loop through the keys
		For $i = 1 To UBound($aKeys) - 1
			; Set the return array values
			$return[$i - 1][0] = $aKeys[$i] ; Filename
			$return[$i - 1][1] = IniRead($statChkWeakBase, "WeakBase", $aKeys[$i], "0") ; Current value
		Next
	Else
		; File doesn't exist so create it and return the values from creation
		$return = createWeakBaseStats()
	EndIf

	Return $return
EndFunc   ;==>readWeakBaseStats

Func saveWeakBaseStats()
	; Handle to hold the file handle
	Local $hFile = FileOpen($statChkWeakBase, $FO_OVERWRITE)

	; Loop through the current stats
	For $j = 0 To UBound($aWeakBaseStats) - 1
		; Write the new value to the stats file
		IniWrite($statChkWeakBase, "WeakBase", $aWeakBaseStats[$j][0], $aWeakBaseStats[$j][1])
	Next

	; Don't forget to close the file handle now that we are finished with it
	FileClose($hFile)
EndFunc   ;==>saveWeakBaseStats

Func updateWeakBaseStats($aResult)
	If IsArray($aResult) Then
		; Loop through the found tiles
		For $i = 1 To UBound($aResult) - 1
			; Loop through the current stats
			For $j = 0 To UBound($aWeakBaseStats) - 1
				; Check to see if the current stat is for the found tile
				If $aWeakBaseStats[$j][0] = $aResult[$i][0] Then
					; Update the counter
					$aWeakBaseStats[$j][1] = Number($aWeakBaseStats[$j][1]) + 1
				EndIf
			Next
		Next
	EndIf
EndFunc   ;==>updateWeakBaseStats

Func displayWeakBaseLog($aResult, $showLog = False)
	; Display the various statistical displays
	If $showLog And IsArray($aResult) Then
		SetLog("================ Weak Base Detection Start ================", $COLOR_BLUE)
		SetLog("Highest Eagle Artillery: " & $aResult[1][0] & " - Level: " & $aResult[1][2], $COLOR_BLUE)
		SetLog("Highest Inferno Tower: " & $aResult[2][0] & " - Level: " & $aResult[2][2], $COLOR_BLUE)
		SetLog("Highest X-Bow: " & $aResult[3][0] & " - Level: " & $aResult[3][2], $COLOR_BLUE)
		SetLog("Highest Wizard Tower: " & $aResult[4][0] & " - Level: " & $aResult[4][2], $COLOR_BLUE)
		SetLog("Highest Mortar: " & $aResult[5][0] & " - Level: " & $aResult[5][2], $COLOR_BLUE)
		SetLog("Time taken: " & $aResult[0][2] & " " & $aResult[0][3], $COLOR_BLUE)
		SetLog("================ Weak Base Detection Stop =================", $COLOR_BLUE)
	EndIf
EndFunc   ;==>displayWeakBaseLog

Func getTHDefenseMax($levelTownHall, $defenseType)
	Local $maxTH = 11

	; Setup Arrays with the max level per town hall level
	Local $eagleLevels[$maxTH] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2]
	Local $infernoLevels[$maxTH] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 4]
	Local $mortarLevels[$maxTH] = [0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
	Local $wizardLevels[$maxTH] = [0, 0, 0, 0, 2, 3, 4, 6, 7, 8, 9]
	Local $xbowLevels[$maxTH] = [0, 0, 0, 0, 0, 0, 0, 0, 3, 4, 4]

	; If something went wrong with TH search and returned 0, set to max TH level
	If $levelTownHall = 0 Then $levelTownHall = $maxTH
	; Setup the default return value if no match is found
	Local $result = 100

	If $levelTownHall <= $maxTH Then
		Switch $defenseType
			Case $eWeakEagle
				$result = $eagleLevels[$levelTownHall - 1]
			Case $eWeakInferno
				$result = $infernoLevels[$levelTownHall - 1]
			Case $eWeakXBow
				$result = $xbowLevels[$levelTownHall - 1]
			Case $eWeakWizard
				$result = $wizardLevels[$levelTownHall - 1]
			Case $eWeakMortar
				$result = $mortarLevels[$levelTownHall - 1]
			Case Else
				; Should never reach here unless there is a problem with the code
		EndSwitch
	EndIf

	Return $result
EndFunc   ;==>getTHDefenseMax

Func getMaxUISetting($settingArray, $defenseType)
	; Setup the default return value
	Local $result = 0, $maxDB = 0, $maxLB = 0

	If IsArray($settingArray) Then
		; Check if dead base search is active and dead base weak base detection is active, use setting if active, 0 if not active
		$maxDB = ($iDBcheck = 1 And IsWeakBaseActive($DB)) ? $settingArray[$DB] : 0
		; Check if live base search is active and live base weak base detection is active, use setting if active, 0 if not active
		$maxLB = ($iABcheck = 1 And IsWeakBaseActive($LB)) ? $settingArray[$LB] : 0

		; Get the value that is highest
		$result = _Max(Number($maxDB), Number($maxLB))
	EndIf

	If $debugSetLog = 1 Then SetLog("Max " & $weakDefenseNames[$defenseType] & " Level: " & $result, $COLOR_BLUE)
	Return $result
EndFunc   ;==>getMaxUISetting

Func getMinUISetting($settingArray, $defenseType)
	; Setup the default return value
	Local $result = 0, $minDB = 0, $minLB = 0

	If IsArray($settingArray) Then
		; Check if dead base search is active and dead base weak base detection is active, use setting if active, 0 if not active
		$minDB = ($iDBcheck = 1 And IsWeakBaseActive($DB)) ? $settingArray[$DB] : 0
		; Check if live base search is active and live base weak base detection is active, use setting if active, 0 if not active
		$minLB = ($iABcheck = 1 And IsWeakBaseActive($LB)) ? $settingArray[$LB] : 0

		; Get the value that is highest
		$result = _Min(Number($minDB), Number($minLB))
	EndIf

	If $debugSetLog = 1 Then SetLog("Min " & $weakDefenseNames[$defenseType] & " Level: " & $result, $COLOR_BLUE)
	Return $result
EndFunc   ;==>getMinUISetting

Func getIsWeak($aResults, $searchType)
	Return $aResults[$eWeakEagle][2] <= Number($iCmbWeakEagle[$searchType]) _
			And $aResults[$eWeakInferno][2] <= Number($iCmbWeakInferno[$searchType]) _
			And $aResults[$eWeakXBow][2] <= Number($iCmbWeakXBow[$searchType]) _
			And $aResults[$eWeakWizard][2] <= Number($iCmbWeakWizTower[$searchType]) _
			And $aResults[$eWeakMortar][2] <= Number($iCmbWeakMortar[$searchType])
EndFunc   ;==>getIsWeak

Func IsWeakBaseActive($type)
	Return $iChkMaxEagle[$type] Or $iChkMaxInferno[$type] Or $iChkMaxXBow[$type] Or $iChkMaxWizTower[$type] Or $iChkMaxMortar[$type]
EndFunc   ;==>IsWeakBaseActive

Func defenseSearch(ByRef $aResult, $directory, $townHallLevel, $settingArray, $defenseType, ByRef $performSearch, $guiEnabledArray)
	; Setup default return coords of 0,0
	Local $defaultCoords[1][2] = [[0, 0]]

	; Setup Empty Results in case to avoid errors, levels are set to max level of each type
	Local $aDefenseResult[7] = ["Skipped", "Skipped", $weakDefenseMaxLevels[$defenseType], 0, 0, $defaultCoords, ""]
	; Results when search is not necessary because of levels
	Local $aNotNecessary[7] = ["None", "None", 0, 0, 0, $defaultCoords, ""]

	; Setup search limitations
	Local $minSearchLevel = getMinUISetting($settingArray, $defenseType) + 1
	Local $maxSearchLevel = getTHDefenseMax($townHallLevel, $defenseType)
	Local $guiCheckDefense = IsArray($guiEnabledArray) And (Number($guiEnabledArray[$DB]) = 1 Or Number($guiEnabledArray[$LB] = 1))

	; Only do the search if its required
	If $performSearch Then
		; Start the timer for individual defense searches
		Local $defenseTimer = TimerInit()

		If $guiCheckDefense And $maxSearchLevel >= $minSearchLevel Then
			; Check the defense.
			$aDefenseResult = returnHighestLevelSingleMatch($directory, $aResult[0][0], $statChkWeakBase, $minSearchLevel, $maxSearchLevel)
			; Store the redlines retrieved for use in the later searches, if you don't currently have redlines saved.
			If $aResult[0][0] = "" Then $aResult[0][0] = $aDefenseResult[6]
			; Check to see if further searches are required, $performSearch is passed ByRef, so this will update the value in the calling function
			If Number($aDefenseResult[2]) > getMaxUISetting($settingArray, $defenseType) Then $performSearch = False
			If $debugSetLog = 1 Then SetLog("checkDefense: " & $weakDefenseNames[$defenseType] & " - " & Round(TimerDiff($defenseTimer) / 1000, 2) & " seconds")
		Else
			$aDefenseResult = $aNotNecessary
			If $debugSetLog = 1 Then SetLog("checkDefense: " & $weakDefenseNames[$defenseType] & " not necessary!")
		EndIf
	EndIf

	Return $aDefenseResult
EndFunc   ;==>defenseSearch

Func weakBaseCheck($townHallLevel = 11, $redlines = "")
	; Setup default return coords of 0,0
	Local $defaultCoords[1][2] = [[0, 0]]
	; Setup Empty Results in case to avoid errors, levels are set to max level of each type
	Local $aResult[6][6] = [[$redlines, 0, 0, "Seconds", "", ""], _
			["Skipped", "Skipped", 2, 0, 0, $defaultCoords], _
			["Skipped", "Skipped", 4, 0, 0, $defaultCoords], _
			["Skipped", "Skipped", 4, 0, 0, $defaultCoords], _
			["Skipped", "Skipped", 9, 0, 0, $defaultCoords], _
			["Skipped", "Skipped", 9, 0, 0, $defaultCoords]]

	Local $aEagleResults, $aInfernoResults, $aMortarResults, $aWizardTowerResults, $aXBowResults
	Local $performSearch = True
	; Start the timer for overall weak base search
	Local $hWeakTimer = TimerInit()

	; Check Eagle Artillery first as there is less images to process, mortars may not be needed.
	$aEagleResults = defenseSearch($aResult, @ScriptDir & "\images\WeakBase\Eagle", $townHallLevel, $iCmbWeakEagle, $eWeakEagle, $performSearch, $iChkMaxEagle)
	$aInfernoResults = defenseSearch($aResult, @ScriptDir & "\images\WeakBase\Infernos", $townHallLevel, $iCmbWeakInferno, $eWeakInferno, $performSearch, $iChkMaxInferno)
	$aXBowResults = defenseSearch($aResult, @ScriptDir & "\images\WeakBase\Xbow", $townHallLevel, $iCmbWeakXBow, $eWeakXBow, $performSearch, $iChkMaxXBow)
	$aWizardTowerResults = defenseSearch($aResult, @ScriptDir & "\images\WeakBase\WTower", $townHallLevel, $iCmbWeakWizTower, $eWeakWizard, $performSearch, $iChkMaxWizTower)
	$aMortarResults = defenseSearch($aResult, @ScriptDir & "\images\WeakBase\Mortars", $townHallLevel, $iCmbWeakMortar, $eWeakMortar, $performSearch, $iChkMaxMortar)

	; Fill the array that will be returned with the various results, only store the results if its a valid array
	For $i = 1 To UBound($aResult) - 1
		For $j = 0 To UBound($aResult, 2) - 1
			Switch $i
				Case $eWeakEagle
					If IsArray($aEagleResults) Then $aResult[$i][$j] = $aEagleResults[$j]
				Case $eWeakInferno
					If IsArray($aInfernoResults) Then $aResult[$i][$j] = $aInfernoResults[$j]
				Case $eWeakXBow
					If IsArray($aXBowResults) Then $aResult[$i][$j] = $aXBowResults[$j]
				Case $eWeakWizard
					If IsArray($aWizardTowerResults) Then $aResult[$i][$j] = $aWizardTowerResults[$j]
				Case $eWeakMortar
					If IsArray($aMortarResults) Then $aResult[$i][$j] = $aMortarResults[$j]
				Case Else
					; This should never happen unless there is a problem with the code.
			EndSwitch
		Next
	Next

	; Extra return results
	$aResult[0][2] = Round(TimerDiff($hWeakTimer) / 1000, 2) ; Time taken
	$aResult[0][3] = "Seconds" ; Measurement unit

	Return $aResult
EndFunc   ;==>weakBaseCheck

Func IsWeakBase($townHallLevel = 11, $redlines = "")
	Local $aResult = weakBaseCheck($townHallLevel, $redlines)

	; Forces the display of the various statistical displays, if set to true
	; displayWeakBaseLog($aResult, true)
	; Displays the various statistical displays, if debug logging is enabled
	displayWeakBaseLog($aResult, $debugSetLog = 1)

	; Take Debug Pictures
	If Number($aResult[0][2]) > 10 Then
		; Search took longer than 10 seconds so take a debug picture no matter what the debug option is
		captureDebugImage($aResult, "WeakBase_Detection_TooSlow")
	ElseIf $debugImageSave = 1 And Number($aResult[1][4]) = 0 Then
		; Eagle Artillery not detected, so lets log the picture for manual inspection
		captureDebugImage($aResult, "WeakBase_Detection_Eagle_NotDetected")
	ElseIf $debugImageSave = 1 And Number($aResult[2][4]) = 0 Then
		; Inferno Towers not detected, so lets log the picture for manual inspection
		captureDebugImage($aResult, "WeakBase_Detection_Inferno_NotDetected")
	ElseIf $debugImageSave = 1 And Number($aResult[3][4]) = 0 Then
		; X-bows not detected, so lets log the picture for manual inspection
		captureDebugImage($aResult, "WeakBase_Detection_Xbow_NotDetected")
	ElseIf $debugImageSave = 1 And Number($aResult[4][4]) = 0 Then
		; Wizard Towers not detected, so lets log the picture for manual inspection
		captureDebugImage($aResult, "WeakBase_Detection_WTower_NotDetected")
	ElseIf $debugImageSave = 1 And Number($aResult[5][4]) = 0 Then
		; Mortars not detected, so lets log the picture for manual inspection
		captureDebugImage($aResult, "WeakBase_Detection_Mortar_NotDetected")
	ElseIf $debugImageSave = 1 Then
		; Debug option is set, so take a debug picture
		captureDebugImage($aResult, "WeakBase_Detection")
	EndIf

	Return $aResult
EndFunc   ;==>IsWeakBase
