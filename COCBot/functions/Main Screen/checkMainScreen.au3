
; #FUNCTION# ====================================================================================================================
; Name ..........: checkMainScreen
; Description ...: Checks whether the pixel, located in the eyes of the builder in mainscreen, is available
;						If it is not available, it calls checkObstacles and also waitMainScreen.
; Syntax ........: checkMainScreen([$Check = True])
; Parameters ....: $Check               - [optional] an unknown value. Default is True.
; Return values .: None
; Author ........:
; Modified ......: KnowJack (July/Aug 2015) , TheMaster (2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: checkObstacles(), waitMainScreen()
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func checkMainScreen($Check = True) ;Checks if in main screen

	Local $iCount, $Result
	If $Check = True Then
		SetLog("Trying to locate Main Screen")
	Else
		;If $g_iDebugSetlog = 1 Then SetLog("checkMainScreen start quiet mode", $COLOR_DEBUG)
    EndIf
	If TestCapture() = False Then
		If CheckAndroidRunning(False) = False Then Return
		getBSPos() ; Update $HWnd and Android Window Positions
		#cs
		If $g_bChkBackgroundMode = False And $NoFocusTampering = False And $g_bAndroidEmbedded = False Then
			Local $hTimer = TimerInit(), $hWndActive = -1
			Local $activeHWnD = WinGetHandle("")
			While TimerDiff($hTimer) < 1000 And $hWndActive <> $HWnD And Not _Sleep(100)
			   getBSPos() ; update $HWnD
			   $hWndActive = WinActivate($HWnD) ; ensure bot has window focus
			WEnd
			If $hWndActive <> $HWnD Then
			   ; something wrong with window, restart Android
			   RebootAndroid()
			   Return
			EndIf
			WinActivate($activeHWnD) ; restore current active window
		EndIf
		#ce
		WinGetAndroidHandle()
		If $g_bChkBackgroundMode = False And $HWnD <> 0 Then
			; ensure android is top
			AndroidToFront()
		EndIf
		If $g_bAndroidAdbScreencap = False And _WinAPI_IsIconic($HWnD) Then WinSetState($HWnD, "", @SW_RESTORE)
	EndIf
	$iCount = 0
	While _CheckPixel($aIsMain, $g_bCapturePixel) = False
		If TestCapture() Then
			SetLog("Main Screen not Located", $COLOR_ERROR)
			ExitLoop
		EndIf
		WinGetAndroidHandle()
		If _Sleep($iDelaycheckMainScreen1) Then Return
		$Result = checkObstacles()
		If $g_iDebugSetlog = 1 Then Setlog("CheckObstacles Result = "&$Result, $COLOR_DEBUG)

		If ($Result = False And $MinorObstacle = True) Then
			$MinorObstacle = False
		ElseIf ($Result = False And $MinorObstacle = False) Then
			 RestartAndroidCoC() ; Need to try to restart CoC
		Else
			$g_bRestart = True
		EndIf
		waitMainScreen()  ; Due to differeneces in PC speed, let waitMainScreen test for CoC restart
		If Not $g_bRunState Then Return
		If @extended Then Return SetError(1, 1, -1)
		If @error Then $iCount += 1
		If $iCount > 2 Then
			SetLog("Unable to fix the window error", $COLOR_ERROR)
			CloseCoC(True)
			ExitLoop
		EndIf
	WEnd
	ZoomOut()
	If Not $g_bRunState Then Return

	If $Check = True Then
		SetLog("Main Screen Located", $COLOR_SUCCESS)
	Else
		;If $g_iDebugSetlog = 1 Then SetLog("checkMainScreen exit quiet mode", $COLOR_DEBUG)
	EndIf

    ;After checkscreen dispose windows
	DisposeWindows()

	;Execute Notify Pending Actions
	NotifyPendingActions()
EndFunc   ;==>checkMainScreen
