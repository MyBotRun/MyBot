
; #FUNCTION# ====================================================================================================================
; Name ..........: checkMainScreen
; Description ...: Checks whether the pixel, located in the eyes of the builder in mainscreen, is available
;						If it is not available, it calls checkObstacles and also waitMainScreen.
; Syntax ........: checkMainScreen([$bSetLog = True], [$bBuilderBase = False])
; Parameters ....: $bCheck: [optional] Sets a Message in Bot Log. Default is True  - $bBuilderBase: [optional] Use CheckMainScreen for Builder Base instead of normal Village. Default is False
; Return values .: None
; Author ........:
; Modified ......: KnowJack (07-2015) , TheMaster1st(2015), Fliegerfaust (06-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: checkObstacles(), waitMainScreen()
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func checkMainScreen($bSetLog = True, $bBuilderBase = False) ;Checks if in main screen

	Local $iCount, $bObstacleResult
	Local $aPixelToCheck = $aIsMain

	If $bSetLog Then
		SetLog("Trying to locate Main Screen")
	EndIf

	If Not TestCapture() Then
		If CheckAndroidRunning(False) = False Then Return
		getBSPos() ; Update $g_hAndroidWindow and Android Window Positions
		WinGetAndroidHandle()
		If Not $g_bChkBackgroundMode And $g_hAndroidWindow <> 0 Then
			; ensure android is top
			AndroidToFront()
		EndIf
		If $g_bAndroidAdbScreencap = False And _WinAPI_IsIconic($g_hAndroidWindow) Then WinSetState($g_hAndroidWindow, "", @SW_RESTORE)
	EndIf
	$iCount = 0

	If $bBuilderBase Then $aPixelToCheck = $aIsOnBuilderIsland

	While _CaptureRegions() And (Not _CheckPixel($aPixelToCheck, $g_bNoCapturePixel) Or checkObstacles_Network(False, False))
		If TestCapture() Then
			SetLog("Main Screen not Located", $COLOR_ERROR)
			ExitLoop
		EndIf
		WinGetAndroidHandle()
		If _Sleep($DELAYCHECKMAINSCREEN1) Then Return

		$bObstacleResult = checkObstacles($bBuilderBase)
		If $g_iDebugSetlog = 1 Then Setlog("CheckObstacles Result = " & $bObstacleResult, $COLOR_DEBUG)

		If (Not $bObstacleResult And $g_bMinorObstacle) Then
			$g_bMinorObstacle = False
		ElseIf (Not $bObstacleResult And Not $g_bMinorObstacle) Then
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

	If $bSetLog Then
		SetLog("Main Screen Located", $COLOR_SUCCESS)
	EndIf

	;After checkscreen dispose windows
	DisposeWindows()

	;Execute Notify Pending Actions
	NotifyPendingActions()
EndFunc   ;==>checkMainScreen
