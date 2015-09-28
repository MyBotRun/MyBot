; #FUNCTION# ====================================================================================================================
; Name ..........: CheckTombs.au3
; Description ...: This file Includes function to perform defense farming.
; Syntax ........:
; Parameters ....: None
; Return values .: False if regular farming is needed to refill storage
; Author ........: barracoda/KnowJack (2015)
; Modified ......: sardo 2015-06 2015-08
; Remarks .......: This file is part of ClashGameBot. Copyright 2015
;                  ClashGameBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================

Func CheckTombs()

	Local $TombX, $TombY
	If $ichkTombstones <> 1 Then Return False
	$tomb = @ScriptDir & "\images\tomb.png"
	If Not FileExists($tomb) Then Return False
	$TombLoc = 0
	_CaptureRegion()
	If _Sleep($iDelayCheckTombs1) Then Return
	For $TombTol = 0 To 20
		If $TombLoc = 0 Then
			$TombX = 0
			$TombY = 0
			$TombLoc = _ImageSearch($tomb, 1, $TombX, $TombY, $TombTol) ; Getting Tree Location
;			If $TombLoc = 1 And $TombX > 35 And $TombY < 610 Then
			If $TombLoc = 1 And isInsideDiamondXY($TombX, $TombY) Then
				SetLog("Found tombstone ,  Removing...", $COLOR_GREEN)
				If $DebugSetLog = 1 Then SetLog("Tombstone found (" & $TombX & "," & $TombY & ") tolerance:" & $TombTol, $COLOR_PURPLE)
				Click($TombX, $TombY,1,0,"#0120")
				If _Sleep($iDelayCheckTombs2) Then Return
				ClickP($aAway,1,0,"#0121") ; click away
				If _Sleep($iDelayCheckTombs1) Then Return
				Return True
			EndIf
		EndIf
	Next
	If $DebugSetLog = 1 Then SetLog("Cannot find tombstones, Yard is clean!", $COLOR_PURPLE)
	If _Sleep($iDelayCheckTombs1) Then Return
	checkMainScreen(False) ; check for screen errors while function was running

EndFunc   ;==>CheckTombs
