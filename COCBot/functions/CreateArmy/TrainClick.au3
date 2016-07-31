
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
; Modified ......: Sardo 2015-08, Boju 2016-06
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $TypeTroops[4] = [1, 10, 20, 0]
Func TrainClick($x, $y, $iTimes, $iSpeed, $aWatchSpot, $aLootSpot, $sdebugtxt, $TypeTroops)
	If IsTrainPage() Then
		If $debugClick = 1 Then
			Local $txt = _DecodeDebug($sdebugtxt)
			SetLog("TrainClick " & $x & "," & $y & "," & $iTimes & "," & $iSpeed & " " & $sdebugtxt & $txt, $COLOR_ORANGE, "Verdana", "7.5", 0)
		EndIf

		If $iTimes <> 1 Then
			If FastCaptureRegion() = True Then
				For $i = 0 To ($iTimes - 1)
					If isProblemAffect(True) Then checkMainScreen(False) ; Check for BS/CoC errors
					If $debugsetlogTrain = 1 Then SetLog("Full Check=" & _GetPixelColor($aWatchSpot[0], $aWatchSpot[1], True), $COLOR_PURPLE)
					If _CheckPixel($aWatchSpot, True) = True Then ExitLoop ; Check to see if barrack full
					If _CheckPixel($aLootSpot, True) = True Then ; Check to see if out of Elixir
						SetLog("Elixir Check Fail: Color = " & _GetPixelColor($aLootSpot[0], $aLootSpot[1], False), $COLOR_PURPLE)
						$OutOfElixir = 1
						If _Sleep($iDelayTrainClick1) Then Return
						If IsGemOpen(True) = True Then ClickP($aAway) ;Click Away
						ExitLoop
					EndIf
					If $iUseRandomClick = 0 then
						PureClick($x, $y) ;Click once.
					Else
						PureClickR($TypeTroops, $x, $y) ;Click once.
					EndIf
					If _Sleep($iSpeed, False) Then ExitLoop
				Next
			Else
				If isProblemAffect(True) Then checkMainScreen(False) ; Check for BS/CoC errors
				If $debugsetlogTrain = 1 Then SetLog("Full Check=" & _GetPixelColor($aWatchSpot[0], $aWatchSpot[1], True), $COLOR_PURPLE)
				If _CheckPixel($aWatchSpot, False) = True Then Return ; Check to see if barrack full
				If _CheckPixel($aLootSpot, False) = True Then ; Check to see if out of Elixir
					SetLog("Elixir Check Fail: Color = " & _GetPixelColor($aLootSpot[0], $aLootSpot[1], False), $COLOR_PURPLE)
					$OutOfElixir = 1
					If _Sleep($iDelayTrainClick1) Then Return
					If IsGemOpen(False) = True Then ClickP($aAway) ;Click Away
					Return
				EndIf
				If $iUseRandomClick = 0 then
					PureClick($x, $y, $iTimes) ;Click $iTimes.
				Else
					PureClickR($TypeTroops, $x, $y, $iTimes) ;Click $iTimes.
				EndIf
				If _Sleep($iSpeed, False) Then Return
			EndIf
		Else
			If isProblemAffect(True) Then checkMainScreen(False) ; Check for BS/CoC errors
			If $debugsetlogTrain = 1 Then SetLog("Full Check=" & _GetPixelColor($aWatchSpot[0], $aWatchSpot[1], False), $COLOR_PURPLE)
			If _CheckPixel($aWatchSpot, True) = True Then Return ; Check to see if barrack full
			If _CheckPixel($aLootSpot, False) = True Then ; Check to see if out of Elixir
				SetLog("Elixir Check Fail: Color = " & _GetPixelColor($aLootSpot[0], $aLootSpot[1], False), $COLOR_PURPLE)
				$OutOfElixir = 1
				If _Sleep($iDelayTrainClick1) Then Return
				If IsGemOpen(False) = True Then ClickP($aAway) ;Click Away
				Return
			EndIf

			If $iUseRandomClick = 0 then
				PureClick($x, $y)
			Else
				PureClickR($TypeTroops, $x, $y)
			EndIF

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

Func TrainClickP($point, $howMany, $speed, $aWatchSpot, $aLootSpot, $debugtxt, $TypeTroops)
	Return TrainClick($point[0], $point[1], $howMany, $speed, $aWatchSpot, $aLootSpot, $debugtxt, $TypeTroops)
EndFunc   ;==>TrainClickP