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
; Author ........: KnowJack (07-2015)
; Modified ......: Sardo (08-2015), Boju (06-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func TrainClick($iX, $iY, $iTimes, $iSpeed, $sdebugtxt)
	If IsTrainPageGrayed() Then
		If $g_bDebugClick Then
			Local $txt = _DecodeDebug($sdebugtxt)
			SetLog("TrainClick(" & $iX & "," & $iY & "," & $iTimes & "," & $iSpeed & "," & $sdebugtxt & $txt & ")", $COLOR_DEBUG)
		EndIf

		If $iTimes <> 1 Then
			KeepClicks()
			; Debug
			If $g_bDebugClick Or $g_bDebugSetLogTrain Then SetLog("KeepClicks: " & KeepClicks(), $COLOR_DEBUG)
			If IsKeepClicksActive() Then
				For $i = 0 To ($iTimes - 1)
					PureClick($iX, $iY) ;Click once.
				Next
				If isProblemAffect(True) Then checkMainScreen(False) ; Check for BS/CoC errors
				Local $sLogText = Default
				If $g_bDebugSetLogTrain Then $sLogText = "TrainClick " & $iX & "," & $iY & "," & $iTimes
			Else
				; FastCaptureRegion = True when is set to use WinAPI+ BackgroundMode
				If FastCaptureRegion() Then
					; Will make a LOOP for each troop will check a color position ( gray[i] )
					For $i = 0 To ($iTimes - 1)
						If isProblemAffect(True) Then checkMainScreen(False) ; Check for BS/CoC errors
						Local $sLogText = Default
						If $g_bDebugSetLogTrain Then $sLogText = "TrainClick " & $iX & "," & $iY & "," & $iTimes
						PureClick($iX, $iY, 1, $iSpeed) ;Click once.
						If _Sleep($iSpeed, False) Then ExitLoop
					Next
				Else
					If isProblemAffect(True) Then checkMainScreen(False) ; Check for BS/CoC errors
					Local $sLogText = Default
					If $g_bDebugSetLogTrain Then $sLogText = "TrainClick " & $iX & "," & $iY & "," & $iTimes
					For $i = 0 To ($iTimes - 1)
						PureClick($iX, $iY, 1, $iSpeed) ;Click $iTimes.
					Next
					If _Sleep($iSpeed, False) Then Return
				EndIf
			EndIf
			ReleaseClicks()
		Else
			Local $sLogText = Default
			If $g_bDebugSetLogTrain Then $sLogText = "TrainClick " & $iX & "," & $iY & "," & $iTimes
			If isProblemAffect(True) Then checkMainScreen(False) ; Check for BS/CoC errors
			PureClick($iX, $iY, 1, $iSpeed)
			If _Sleep($iSpeed, False) Then Return
		EndIf
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>TrainClick

Func TrainClickP($aPoint, $iHowOften, $iSpeed, $sdebugtxt)
	Return TrainClick($aPoint[0], $aPoint[1], $iHowOften, $iSpeed, $sdebugtxt)
EndFunc   ;==>TrainClickP
