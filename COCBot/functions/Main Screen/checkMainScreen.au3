
; #FUNCTION# ====================================================================================================================
; Name ..........: checkMainScreen
; Description ...: Checks whether the pixel, located in the eyes of the builder in mainscreen, is available
;						If it is not available, it calls checkObstacles and also waitMainScreen.
; Syntax ........: checkMainScreen([$Check = True])
; Parameters ....: $Check               - [optional] an unknown value. Default is True.
; Return values .: None
; Author ........:
; Modified ......: KnowJack (July/Aug 2015) , TheMaster (2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: checkObstacles(), waitMainScreen()
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func checkMainScreen($Check = True) ;Checks if in main screen

	Local $iCount, $Result
	If $Check = True Then
		SetLog("Trying to locate Main Screen")
		_WinAPI_EmptyWorkingSet(WinGetProcess($Title)) ; Reduce BlueStacks Memory Usage
	Else
		If $debugsetlog = 1 Then SetLog("checkMainScreen start quiet mode", $COLOR_PURPLE)
	EndIf
	If WinExists($Title) = False Then
		OpenAndroid(True)
		Return
    EndIf
	getBSPos() ; Update $HWnd and Android Window Positions
	If $ichkBackground = 0 Then
	    WinActivate($HWnD)  	; ensure bot has window focus
    EndIf
	$iCount = 0
	While _CheckPixel($aIsMain, $bCapturePixel) = False
		$HWnD = WinGetHandle($Title)
		If _Sleep($iDelaycheckMainScreen1) Then Return
		$Result = checkObstacles()
		If $debugsetlog = 1 Then Setlog("CheckObstacles Result = "&$Result, $COLOR_PURPLE)

		If ($Result = False And $MinorObstacle = True) Then
			$MinorObstacle = False
		ElseIf ($Result = False And $MinorObstacle = False) Then
			 RestartAndroidCoC() ; Need to try to restart CoC
		Else
			$Restart = True
		EndIf
		waitMainScreen()  ; Due to differeneces in PC speed, let waitMainScreen test for CoC restart
		If @extended Then Return SetError(1, 1, -1)
		If @error Then $iCount += 1
		If $iCount > 2 Then
			SetLog("Unable to fix the window error", $COLOR_RED)
			CloseCoC(True)
			ExitLoop
		EndIf
	WEnd
	ZoomOut()

	If $Check = True Then
		SetLog("Main Screen Located", $COLOR_GREEN)
	Else
		If $debugsetlog = 1 Then SetLog("checkMainScreen exit quiet mode", $COLOR_PURPLE)
	EndIf

    ;After checkscreen dispose windows
	DisposeWindows()
EndFunc   ;==>checkMainScreen
