
; #FUNCTION# ====================================================================================================================
; Name ..........: TrainClick
; Description ...: Clicks in troop training window with special checks for Barracks Full, and If not enough elxir to train troops or to close the gem window if opened.
; Syntax ........: TrainClick($x, $y, $iTimes, $iSpeed, $aWatchSpot, $aLootSpot, $debugtxt = "")
; Parameters ....: $x                   - X location to click
;                  $y                   - Y location to click
;                  $iTimes              - Number fo times to cliok
;                  $iSpeed              - Wait time after click
;                  $aWatchSpot          - [in/out] an array of [X location, Y location, Hex Color, Tolerance] to check after click if full
;                  $aLootSpot           - [in/out] an array of [X location, Y location, Hex Color, Tolerance] to check after click, color used to see if out of Elixir for more troops
;						 $sdebugtxt				 - String with click debug text
; Return values .: None
; Author ........: KnowJack (July 2015)
; Modified ......: Sardo 2015-08
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func TrainClick($x, $y, $iTimes, $iSpeed, $aWatchSpot, $aLootSpot, $sdebugtxt = "")
	If IsTrainPage() Then
		If $debugClick = 1 Then
			Local $txt = _DecodeDebug($sdebugtxt)
			SetLog("TrainClick " & $x & "," & $y & "," & $iTimes & "," & $iSpeed & " " & $sdebugtxt & $txt, $COLOR_ORANGE, "Verdana", "7.5", 0)
		EndIf

		If $iTimes <> 1 Then
			If FastCaptureRegion() = True Then
				For $i = 0 To ($iTimes - 1)
					If isProblemAffect(True) Then checkMainScreen(False) ; Check for BS/CoC errors
					;If $DebugSetlog = 1 Then SetLog("Full Check=" & _GetPixelColor($aWatchSpot[0], $aWatchSpot[1], True), $COLOR_PURPLE)
					If _CheckPixel($aWatchSpot, True) = True Then ExitLoop ; Check to see if barrack full
					If _CheckPixel($aLootSpot, True) = True Then ; Check to see if out of Elixir
						SetLog("Elixir Check Fail: Color = " & _GetPixelColor($aLootSpot[0], $aLootSpot[1], False), $COLOR_PURPLE)
						$OutOfElixir = 1
						If _Sleep($iDelayTrainClick1) Then Return
						If IsGemOpen(True) = True Then ClickP($aAway) ;Click Away
						ExitLoop
					EndIf
					PureClick($x, $y) ;Click once.
					If _Sleep($iSpeed, False) Then ExitLoop
				Next
			Else
				If isProblemAffect(True) Then checkMainScreen(False) ; Check for BS/CoC errors
				;If $DebugSetlog = 1 Then SetLog("Full Check=" & _GetPixelColor($aWatchSpot[0], $aWatchSpot[1], True), $COLOR_PURPLE)
				If _CheckPixel($aWatchSpot, False) = True Then Return ; Check to see if barrack full
				If _CheckPixel($aLootSpot, False) = True Then ; Check to see if out of Elixir
					SetLog("Elixir Check Fail: Color = " & _GetPixelColor($aLootSpot[0], $aLootSpot[1], False), $COLOR_PURPLE)
					$OutOfElixir = 1
					If _Sleep($iDelayTrainClick1) Then Return
					If IsGemOpen(False) = True Then ClickP($aAway) ;Click Away
					Return
				EndIf
				PureClick($x, $y, $iTimes) ;Click $iTimes.
				If _Sleep($iSpeed, False) Then Return
			EndIf
		Else
			If isProblemAffect(True) Then checkMainScreen(False) ; Check for BS/CoC errors
			If _CheckPixel($aWatchSpot, True) = True Then Return ; Check to see if barrack full
			;If $DebugSetlog = 1 Then SetLog("Full Check=" & _GetPixelColor($aWatchSpot[0], $aWatchSpot[1], False), $COLOR_PURPLE)
			If _CheckPixel($aLootSpot, False) = True Then ; Check to see if out of Elixir
				SetLog("Elixir Check Fail: Color = " & _GetPixelColor($aLootSpot[0], $aLootSpot[1], False), $COLOR_PURPLE)
				$OutOfElixir = 1
				If _Sleep($iDelayTrainClick1) Then Return
				If IsGemOpen(False) = True Then ClickP($aAway) ;Click Away
				Return
			EndIf

			PureClick($x, $y)

			If _Sleep($iSpeed, False) Then Return
			If _CheckPixel($aLootSpot, True) = True Then ; Check to see if out of Elixir
				SetLog("Elixir Check Fail: Color = " & _GetPixelColor($aLootSpot[0], $aLootSpot[1], True), $COLOR_PURPLE)
				$OutOfElixir = 1
				If _Sleep($iDelayTrainClick1) Then Return
				If IsGemOpen(True) = True Then ClickP($aAway) ;Click Away
				Return
			EndIf
		EndIf
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>TrainClick

; TrainClickP : takes an array[2] (or array[4]) as a parameter [x,y]
Func TrainClickP($point, $howMany, $speed, $aWatchSpot, $aLootSpot, $debugtxt = "")
	Return TrainClick($point[0], $point[1], $howMany, $speed, $aWatchSpot, $aLootSpot, $debugtxt)
EndFunc   ;==>TrainClickP
