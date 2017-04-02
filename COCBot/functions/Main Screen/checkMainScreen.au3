
; #FUNCTION# ====================================================================================================================
; Name ..........: checkMainScreen
; Description ...: Checks whether the pixel, located in the eyes of the builder in mainscreen, is available
;						If it is not available, it calls checkObstacles and also waitMainScreen.
; Syntax ........: checkMainScreen([$Check = True])
; Parameters ....: $Check               - [optional] an unknown value. Default is True.
; Return values .: None
; Author ........:
; Modified ......: KnowJack (07-2015) , TheMaster1st(2015)
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
		getBSPos() ; Update $g_hAndroidWindow and Android Window Positions
		#cs
			If $g_bChkBackgroundMode = False And $NoFocusTampering = False And $g_bAndroidEmbedded = False Then
			Local $hTimer = __TimerInit(), $g_hAndroidWindowActive = -1
			Local $activeHWnD = WinGetHandle("")
			While __TimerDiff($hTimer) < 1000 And $g_hAndroidWindowActive <> $g_hAndroidWindow And Not _Sleep(100)
			getBSPos() ; update $g_hAndroidWindow
			$g_hAndroidWindowActive = WinActivate($g_hAndroidWindow) ; ensure bot has window focus
			WEnd
			If $g_hAndroidWindowActive <> $g_hAndroidWindow Then
			; something wrong with window, restart Android
			RebootAndroid()
			Return
			EndIf
			WinActivate($activeHWnD) ; restore current active window
			EndIf
		#ce
		WinGetAndroidHandle()
		If $g_bChkBackgroundMode = False And $g_hAndroidWindow <> 0 Then
			; ensure android is top
			AndroidToFront()
		EndIf
		If $g_bAndroidAdbScreencap = False And _WinAPI_IsIconic($g_hAndroidWindow) Then WinSetState($g_hAndroidWindow, "", @SW_RESTORE)
	EndIf
	$iCount = 0
	While _CheckPixel($aIsMain, $g_bCapturePixel) = False
		If TestCapture() Then
			SetLog("Main Screen not Located", $COLOR_ERROR)
			ExitLoop
		EndIf
		WinGetAndroidHandle()
		If _Sleep($DELAYCHECKMAINSCREEN1) Then Return
		$Result = checkObstacles()
		If $g_iDebugSetlog = 1 Then Setlog("CheckObstacles Result = " & $Result, $COLOR_DEBUG)

		If ($Result = False And $g_bMinorObstacle = True) Then
			$g_bMinorObstacle = False
		ElseIf ($Result = False And $g_bMinorObstacle = False) Then
			RestartAndroidCoC() ; Need to try to restart CoC
		Else
			$g_bRestart = True
		EndIf
		waitMainScreen() ; Due to differeneces in PC speed, let waitMainScreen test for CoC restart
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
