; #FUNCTION# ====================================================================================================================
; Name ..........: drillSearch
; Description ...: Searches for the DE Drills in the base, and returns; X, Y location, and Level
; Syntax ........: drillSearch()
; Parameters ....: None
; Return values .: Array with data on Dark Elixir Drills found in search
; Author ........: LunaEclipse(March, 2016)
; Modified ......: 
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func getNumberOfDrills($listPixelByLevel = -1)
	Local $aReturn
	Local $result = 0

	; Check to see if the function was passed an array with drill information
	If Not IsArray($listPixelByLevel) Then $listPixelByLevel = getDrillArray()

	If $listPixelByLevel[1] <> "" Then $result = $listPixelByLevel[0]
	If $DebugSmartZap = 1 Then SetLog("Total No. of Dark Elixir Drills = " & $result, $COLOR_DEBUG)

	Return $result
EndFunc   ;==>getNumberOfDrills

Func fillDrillArray($listPixelByLevel = -1)
	Local $result[4][5] = [	[-1, -1, -1, -1, -1], _
							[-1, -1, -1, -1, -1], _
							[-1, -1, -1, -1, -1], _
							[-1, -1, -1, -1, -1]]

	Local $pixel[2], $pixelWithLevel, $level, $pixelStr
	Local $numDrills = getNumberOfDrills($listPixelByLevel)

	If Not IsArray($listPixelByLevel) Then $listPixelByLevel = getDrillArray()

	If $numDrills > 0 Then
		For $i = 1 To $numDrills
			$pixelWithLevel = StringSplit($listPixelByLevel[$i], "#")
			; If the string delimiter is not found, then try next string.
			If @error Then ContinueLoop

			If $DebugSmartZap = 1 Then
				Setlog("Drill search UBound($pixelWithLevel) = " & UBound($pixelWithLevel) - 1, $COLOR_DEBUG)
				For $j = 0 To UBound($pixelWithLevel) - 1
					Setlog("Drill search $pixelWithLevel[" & $j & "] = " & $pixelWithLevel[$j], $COLOR_DEBUG)
				Next
			EndIf

			$level = $pixelWithLevel[1]
			$pixelStr = StringSplit($pixelWithLevel[2], "-")
			$pixel[0] = $pixelStr[1]
			$pixel[1] = $pixelStr[2]

			; Debug Drill Search
			If $DebugSmartZap = 1 Then
				Setlog("Drill search $level = " & $level, $COLOR_DEBUG)
				For $j = 0 To UBound($pixelStr) - 1
					Setlog("Drill search $pixelStr[" & $j & "] = " & $pixelStr[$j], $COLOR_PURPLE)
				Next
			EndIf

			; Check to make sure the found drill is actually inside the valid COC Area
			If isInsideDiamond($pixel) Then
				$result[$i][0] = Number($pixel[0])
				$result[$i][1] = Number($pixel[1])
				$result[$i][2] = Number($level)
				$result[$i][3] = $drillLevelHold[Number($level) - 1]
				$result[$i][4] = $drillLevelSteal[Number($level) - 1]

				If $DebugSmartZap = 1 Then SetLog("Dark Elixir Drill: [" & $result[$i][0] & "," & $result[$i][1] & "], Level: " & $result[$i][2] & ", Hold: " & $result[$i][3] & ", Steal: " & $result[$i][4], $COLOR_DEBUG)
			Else
				If $DebugSmartZap = 1 Then SetLog("Dark Elixir Drill: [" & $pixel[0] & "," & $pixel[1] & "], Level: " & $level, $COLOR_DEBUG)
				If $DebugSmartZap = 1 Then SetLog("Found Dark Elixir Drill with an invalid location.", $COLOR_ERROR)
			EndIf
		Next
	EndIf

	Return $result
EndFunc   ;==>fillDrillArray

Func getDrillArray()
	Local $result, $listPixelByLevel
	Local $numDrills = 0

	; Capture the screen
	_CaptureRegion2()

	; Get the results of a drill search
	$result = GetLocationDarkElixirWithLevel()
	; Split DLL return into an array
	$listPixelByLevel = StringSplit($result, "~")

	; Debugging purposes only
	If $DebugSmartZap = 1 Then
		Setlog("Drill search $result[0] = " & $result, $COLOR_DEBUG)

		; Get the number of drills for the loop
		$numDrills = getNumberOfDrills($listPixelByLevel)
		If $numDrills > 0 Then
			For $i = 1 To $numDrills
				; Debug the array entries.
				Setlog("Drill search $listPixelByLevel[" & $i & "] = " & $listPixelByLevel[$i], $COLOR_DEBUG)
			Next
		EndIf
	EndIf

	Return $listPixelByLevel
EndFunc   ;==>getDrillArray

Func drillSearch($listPixelByLevel = -1)
	; Not using SmartZap so lets just exit now
	If $ichkSmartZap <> 1 Then Return False

	If Not IsArray($listPixelByLevel) Then $listPixelByLevel = getDrillArray()

	Return fillDrillArray($listPixelByLevel)
EndFunc   ;==>drillSearch