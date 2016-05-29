
; #FUNCTION# ====================================================================================================================
; Name ..........: waitMainScreen
; Description ...: Waits 5 minutes for the pixel of mainscreen to be located, checks for obstacles every 2 seconds.  After five minutes, will try to restart bluestacks.
; Syntax ........: waitMainScreen()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......: KnowJack (July/Aug 2015), TheMaster (2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func waitMainScreen() ;Waits for main screen to popup
	If Not $RunState Then Return
	Local $iCount
	SetLog("Waiting for Main Screen")
	$iCount = 0
	For $i = 0 To 105 ;105*2000 = 3.5 Minutes
		If Not $RunState Then Return
		If $debugsetlog = 1 Then Setlog("ChkObstl Loop = " & $i & "ExitLoop = " & $iCount, $COLOR_PURPLE) ; Debug stuck loop
		$iCount += 1
		Local $hWin = $HWnD
		If WinGetAndroidHandle() = 0 Then
			If $hWin = 0 Then
				OpenAndroid(True)
			Else
				RebootAndroid()
			EndIf
			Return
		EndIf
		getBSPos() ; Update $HWnd and Android Window Positions
		_CaptureRegion()
		If _CheckPixel($aIsMain, $bNoCapturepixel) = True Then ;Checks for Main Screen
			If $debugsetlog = 1 Then Setlog("Screen cleared, WaitMainScreen exit", $COLOR_PURPLE)
			Return
		ElseIf _CheckPixel($aIsDPI125, $bNoCapturepixel) = True Then
			ShowDPIHelp(125)
		ElseIf _CheckPixel($aIsDPI150, $bNoCapturepixel) = True Then
			ShowDPIHelp(150)
		Else
			If _Sleep($iDelaywaitMainScreen1) Then Return
			If checkObstacles() Then $i = 0 ;See if there is anything in the way of mainscreen
		EndIf
		If Mod($i, 5) = 0 Then;every 10 seconds
			If $debugImageSave = 1 Then DebugImageSave("WaitMainScreen_", False)
		EndIf
		If ($i > 105) Or ($iCount > 120) Then ExitLoop ; If CheckObstacles forces reset, limit total time to 4 minutes
	Next

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	CloseCoC(True) ; Close then Open CoC
	If _CheckPixel($aIsMain, True) Then Return ; If its main screen return
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; If mainscreen is not found, then fix it
	$iCount = 0
	While 1
		If Not $RunState Then Return
		SetLog("Unable to load CoC, attempt to fix it...", $COLOR_RED)
		If $debugsetlog = 1 Then Setlog("Restart Loop = " & $iCount, $COLOR_PURPLE) ; Debug stuck loop data
		CloseAndroid() ; BS must die!
		If _Sleep(1000) Then Return
		OpenAndroid(True) ; Open BS and restart CoC
		If @extended Then
			SetError(1, 1, -1)
			Return
		EndIf
		If _CheckPixel($aIsMain, $bCapturepixel) = True Then ExitLoop
		CheckObstacles() ; Check for random error windows and close them
		$iCount += 1
		If $iCount > 2 Then ; If we can't restart BS after 2 tries, exit the loop
			SetLog("Stuck trying to Restart " & $Android & "...", $COLOR_RED)
			SetError(1, 0, 0)
			Return
		EndIf
		If _CheckPixel($aIsMain, $bCapturepixel) = True Then ExitLoop
	WEnd

EndFunc   ;==>waitMainScreen

Func waitMainScreenMini()
    If Not $RunState Then Return
	Local $iCount = 0
	Local $hTimer = TimerInit()
	SetDebugLog("waitMainScreenMini")
	getBSPos() ; Update Android Window Positions
	SetLog("Waiting for Main Screen after " & $Android & " restart", $COLOR_BLUE)
	For $i = 0 To 60 ;30*2000 = 1 Minutes
	    If Not $RunState Then Return
	    If WinGetAndroidHandle() = 0 Then ExitLoop ; sets @error to 1
		If $debugsetlog = 1 Then Setlog("ChkObstl Loop = " & $i & "ExitLoop = " & $iCount, $COLOR_PURPLE) ; Debug stuck loop
		$iCount += 1
		_CaptureRegion()
		If _CheckPixel($aIsMain, $bNoCapturepixel) = False Then ;Checks for Main Screen
			If _Sleep(1000) Then Return
			If CheckObstacles() Then $i = 0 ;See if there is anything in the way of mainscreen
		Else
			SetLog("CoC main window took " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds", $COLOR_GREEN)
			Return
		EndIf
		_StatusUpdateTime($hTimer, "Main Screen")
		If ($i > 60) Or ($iCount > 80) Then ExitLoop  ; If CheckObstacles forces reset, limit total time to 6 minute before Force restart BS
	Next
	Return SetError( 1, 0, -1)
EndFunc