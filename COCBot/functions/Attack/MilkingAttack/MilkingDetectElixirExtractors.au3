; #FUNCTION# ====================================================================================================================
; Name ..........:MilkingDetectElixirExtractors.au3
; Description ...:Find all elixr collectors that meet requirements
; Syntax ........:MilkingDetectElixirExtractors()
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

Func MilkingDetectElixirExtractors()
	;detect elixir extractors position according to settings: amount of resource and level.
	$MilkFarmObjectivesSTR = ""
	_CaptureRegion2(80, 70, 785, 530)
	Local $MilkFarmAtkPixelListSTR = ""

	Local $hTimer = TimerInit()
	;03.01 locate extractors
	Local $ElixirVect = StringSplit(GetLocationElixirWithLevel(), "~", 2) ; ["6#527-209" , "6#421-227" , "6#600-264" , "6#299-331" , "6#511-404" , "6#511-453"]
	Local $elixirfounds = UBound($ElixirVect)
	Local $elixirmatch = 0
	Local $elixirdiscard = 0
	For $i = 0 To UBound($ElixirVect) - 1
		;If $debugsetlog=1 Then Setlog($i & " : " & $ElixirVect[$i])    			;[15:51:30] 0 : 2#405-325 -> level 6
		;03.02 check isinsidediamond
		Local $temp = StringSplit($ElixirVect[$i], "#", 2) ;TEMP ["2", "404-325"]
		If UBound($temp) = 2 Then
			$pixel = StringSplit($temp[1], "-", 2) ;PIXEL ["404","325"]
			If UBound($pixel) = 2 Then
				Local $tempPixel[2] = [$pixel[0] + 80, $pixel[1] + 70]
				$pixel = $tempPixel
				$temp[1] = String($pixel[0]& "-" & $pixel[1])
				;A: check if resource it is inside village.........................................................................
				If isInsideDiamond($pixel) Then
					;B: check if amount ofr esource it is enough...................................................................
					If AmountOfResourcesInStructure("elixir", $pixel, $temp[0]) Then
						$MilkFarmAtkPixelListSTR &= $temp[1] & "|"
						;C: insert and add redarea points..........................................................................
						If $MilkFarmLocateElixir = 1 Then MilkFarmObjectivesSTR_INSERT("elixir", $temp[0], $temp[1])
						$elixirmatch += 1
					Else
						If $debugsetlog = 1 Then Setlog(" - discard #4 no match conditions", $color_purple)
						$elixirdiscard += 1
					EndIf
				Else
					If $debugsetlog = 1 Then Setlog(" - discard #3 out of insidediamond", $color_purple)
					$elixirdiscard += 1
				EndIf
			Else
				If $debugsetlog = 1 Then Setlog(" - discard #2 no pixel coordinate", $color_purple)
				$elixirdiscard += 1
			EndIf
		Else
			If $debugsetlog = 1 Then Setlog(" - discard #1 no valid point", $color_purple)
			$elixirdiscard += 1
		EndIf
	Next
	If StringLen($MilkFarmAtkPixelListSTR) > 1 Then
		$MilkFarmAtkPixelListSTR = StringLeft($MilkFarmAtkPixelListSTR, StringLen($MilkFarmAtkPixelListSTR) - 1)
	EndIf
	If $debugsetlog = 1 Then Setlog("> Elixir Extractors to attack list: " & $MilkFarmAtkPixelListSTR, $color_purple)
	Local $htimerLocateElixir = Round(TimerDiff($hTimer) / 1000, 2)
	If $debugsetlog = 1 Then Setlog("> Elixir Extractors found: " & $elixirfounds & " | match conditions: " & $elixirmatch & " | discard " & $elixirdiscard, $color_blue)
	If $debugsetlog = 1 Then SetLog("> Elixir Extractors position and %full detectecd in " & $htimerLocateElixir & " seconds", $color_blue)
	Return $elixirmatch
EndFunc   ;==>MilkingDetectElixirExtractors
