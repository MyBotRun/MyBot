; #FUNCTION# ====================================================================================================================
; Name ..........: THSearch
; Description ...: Searches for the TH in base, and returns; X&Y location, Bldg Level
; Syntax ........: THSearch([$bReTest = False])
; Parameters ....: $bReTest             - [optional] a boolean value. Default is False.
; Return values .: None, or $aTownHall if $bReTest = True
; Author ........: KnowJack (May 2015)
; Modified ......: Hervidero (okt 2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $aTownHall[4] = [-1, -1, -1, -1] ; [LocX, LocY, BldgLvl, Quantity]

Func THSearch($bReTest = False)

	If $debugsetlog = 1 Then SetLog("TH search Start", $COLOR_PURPLE)
	Local $hTimer = TimerInit()

	Local $result, $listPixelByLevel, $pixelWithLevel, $level, $pixelStr
	Local $aTownHallLocal[4] = [-1, -1, -1, -1] ; [LocX, LocY, BldgLvl, Quantity]
	Local $NumTownHall = 1

	If $bReTest = False Then
		For $ii = 0 To 3
			$aTownHall[$ii] = -1 ; reset global values [LocX, LocY, BldgLvl, Quantity]
		Next
	EndIf

	_CaptureRegion2()
	$result = DllCall($hFuncLib, "str", "getLocationTownHallWithLevel", "ptr", $hHBitmap2)
	;$result = DllCall($hFuncLib, "str", "getLocationTownHallWithLevelDebug", "ptr", $hHBitmap2, "int", 1)
	If $debugsetlog = 1 Then SetLog("Calculated  (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds) :")
	If $debugsetlog = 1 Then Setlog("TownHall search $result[0] = " & $result[0], $COLOR_PURPLE) ;Debug


	$listPixelByLevel = StringSplit($result[0], "~") ; split each building into array
	If $listPixelByLevel[0] > 1 Then ; check for more than 1 bldg and proper split a part
		$NumTownHall = UBound($listPixelByLevel) - 1
		SetLog("Total No. of TownHalls = " & $NumTownHall, $COLOR_FUCHSIA)
		If $debugsetlog = 1 Then
			For $ii = 0 To $listPixelByLevel[0]
				Setlog("TownHall search $listPixelByLevel[" & $ii & "] = " & $listPixelByLevel[$ii], $COLOR_PURPLE) ;Debug
			Next
		EndIf
	EndIf


	For $i = 0 To $NumTownHall - 1
		If $NumTownHall > 1 Then
			$pixelWithLevel = StringSplit($listPixelByLevel[$i], "#")
			If @error Then ContinueLoop ; If the string delimiter is not found, then try next string.
		Else
			$pixelWithLevel = StringSplit($result[$i], "#")
			If @error Then ContinueLoop
		EndIf
		If $debugsetlog = 1 Then
			Setlog("TownHall search UBound($pixelWithLevel) = " & UBound($pixelWithLevel), $COLOR_PURPLE) ;Debug
			For $ii = 0 To UBound($pixelWithLevel) - 1
				Setlog("TownHall search $pixelWithLevel[" & $ii & "] = " & $pixelWithLevel[$ii], $COLOR_PURPLE) ;Debug
			Next
		EndIf
		$level = $pixelWithLevel[1]
		$pixelStr = StringSplit($pixelWithLevel[2], "-")
		If $debugsetlog = 1 Then
			Setlog("TownHall search $level = " & $level, $COLOR_PURPLE) ;Debug
			For $ii = 0 To UBound($pixelStr) - 1
				Setlog("TownHall search $pixelStr[" & $ii & "] = " & $pixelStr[$ii], $COLOR_PURPLE) ;Debug
			Next
		EndIf
		Local $pixel[2] = [$pixelStr[1], $pixelStr[2]]
		If isInsideDiamond($pixel) Then
			$aTownHallLocal[0] = Number($pixel[0])
			$aTownHallLocal[1] = Number($pixel[1])
			$aTownHallLocal[2] = Number($level)
			$THx = $aTownHallLocal[0]
			$THy = $aTownHallLocal[1]
			$ImageInfo = String("C# DLL_" & $aTownHallLocal[2])
			If $debugImageSave = 1 Then CaptureTHwithInfo($THx, $THy, $ImageInfo)
			If $debugsetlog = 1 Then SetLog("TownHall: [" & $aTownHallLocal[0] & "," & $aTownHallLocal[1] & "], Level: " & $aTownHallLocal[2], $COLOR_BLUE)
			Return $THText[($aTownHallLocal[2] < 6 ? 0 : $aTownHallLocal[2] - 6)]
		Else
			If $debugsetlog = 1 Then SetLog("TownHall: [" & $pixel[0] & "," & $pixel[1] & "], Level: " & $level, $COLOR_PURPLE)
			If $debugsetlog = 1 Then SetLog("Found TownHall with Invalid Location?", $COLOR_RED)
			If $debugImageSave = 1 Then DebugImageSave("checkTownhallADV2_NoTHFound_CSH_", True)
			Return "-"
		EndIf
	Next

	If $aTownHallLocal[0] = -1 Or $aTownHallLocal[1] = -1 Then
		If $debugImageSave = 1 Then DebugImageSave("checkTownhallADV2_NoTHFound_CSH_", True)
		If $debugsetlog = 1 Then SetLog(" == TownHall Not Found ==", $COLOR_RED)
		Return "-"
	EndIf

;~ 	If $bReTest = False Then
;~ 		$aTownHall = $aTownHallLocal
;~ 		Return
;~ 	Else
;~ 		Return $aTownHallLocal
;~ 	EndIf

EndFunc   ;==>THSearch
