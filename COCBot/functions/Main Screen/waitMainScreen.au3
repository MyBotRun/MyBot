
; #FUNCTION# ====================================================================================================================
; Name ..........: waitMainScreen
; Description ...: Waits 5 minutes for the pixel of mainscreen to be located, checks for obstacles every 2 seconds.  After five minutes, will try to restart bluestacks.
; Syntax ........: waitMainScreen()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......: KnowJack (July/Aug 2015)
; Remarks .......: This file is part of ClashGameBot. Copyright 2015
;                  ClashGameBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func waitMainScreen() ;Waits for main screen to popup
	Local $iCount
	SetLog("Waiting for Main Screen")
	$iCount = 0
	For $i = 0 To 105 ;105*2000 = 3.5 Minutes
		If $debugsetlog = 1 Then Setlog("ChkObstl Loop = " & $i & "ExitLoop = " & $iCount, $COLOR_PURPLE) ; Debug stuck loop
		$iCount += 1
		_CaptureRegion()
		If _CheckPixel($aIsMain, $bNoCapturepixel) = False Then ;Checks for Main Screen
			If _Sleep($iDelaywaitMainScreen1) Then Return
			If checkObstacles() Then $i = 0 ;See if there is anything in the way of mainscreen
		Else
			If $debugsetlog = 1 Then Setlog("Screen cleared, WaitMainScreen exit", $COLOR_PURPLE)
			Return
		EndIf
		If ($i > 105) Or ($iCount > 180) Then ExitLoop  ; If CheckObstacles forces reset, limit total time to 6 minute before Force restart BS
	Next
	; If mainscreen is not found, then fix it
	$iCount = 0
	While 1
		SetLog("Unable to load CoC, attempt to fix it...", $COLOR_RED)
		If $debugsetlog = 1 Then Setlog("Restart Loop = " & $iCount, $COLOR_PURPLE) ; Debug stuck loop data
		CloseBS() 	 ; BS must die!
		If _Sleep(1000) Then Return
		OpenBS(True) ; Open BS and restart CoC
		If _CheckPixel($aIsMain, $bCapturepixel) = True Then ExitLoop
		CheckObstacles()  ; Check for random error windows and close them
		$iCount += 1
		If $iCount > 2 Then ; If we can't restart BS after 2 tries, exit the loop
			SetLog("Stuck trying to Restart BS...", $COLOR_RED)
			SetError(1, @extended, 0)
			Return
		EndIf
		If _CheckPixel($aIsMain, $bCapturepixel) = True Then ExitLoop
	WEnd
EndFunc   ;==>waitMainScreen
