; #FUNCTION# ====================================================================================================================
; Name ..........: getBSPos
; Description ...: Gets the postiion of of the Bluestacks window, attempts to open BS if not available, or closes MBR if it can not to avoid AutoIt internal error
; Syntax ........: getBSPos()
; Parameters ....:
; Return values .: None
; Author ........: Code Monkey #59
; Modified ......: KnowJack(july 2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func getBSPos()
    Local $SuspendMode = ResumeAndroid()
    Local $Changed = False, $aOldValues[4]
	Local $hWin = $HWnD
	WinGetAndroidHandle()
    If $g_bAndroidBackgroundLaunched = False Then
        getAndroidPos(True)
    Else
        SetError($HWnd = 0 ? 1 : 0)
    EndIf

	If @error = 1 Then
		If Not $g_bRunState Then Return
		SetError (0,0,0)
		If $hWin = 0 Then
			OpenAndroid(True)
		Else
			RebootAndroid()
		EndIf
        If $g_bAndroidBackgroundLaunched = False Then
           getAndroidPos(True)
        Else
           SetError($HWnd = 0 ? 1 : 0)
        EndIf
		If Not $g_bRunState Then Return
		If @error = 1 Then
			_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 600)
            Local $stext = @CRLF & GetTranslated(640,17,"MyBot has experienced a serious error") & @CRLF & @CRLF & _
                    GetTranslated(640,18,"Unable to find or start up ") & $g_sAndroidEmulator & @CRLF & @CRLF & GetTranslated(640,22,"Reboot PC and try again,") & _
                    GetTranslated(640,19,"and search www.mybot.run forums for more help") & @CRLF
            Local $MsgBox = _ExtMsgBox(0, GetTranslated(640,20,"Close MyBot!"), GetTranslated(640,21,"Okay - Must Exit Program"), $stext, 15, $g_hFrmBot)
			If $MsgBox = 1 Then
				BotClose()
			EndIf
		EndIf
	EndIf
	If @error = 1 Then
		If Not $g_bRunState Then Return
		SetError (0,0,0)
		If $hWin = 0 Then
			OpenAndroid(True) ; Try to start Android if it is not running
		Else
			RebootAndroid()
		EndIf
		Return
    EndIf
    If $g_bAndroidBackgroundLaunched = True Then
		SuspendAndroid($SuspendMode, False)
		Return
	EndIf
	$aOldValues[0] = $g_aiBSpos[0]
	$aOldValues[1] = $g_aiBSpos[1]
	$aOldValues[2] = $g_aiBSrpos[0]
	$aOldValues[3] = $g_aiBSrpos[1]

	Local $aPos = getAndroidPos()
	If Not IsArray($aPos) Then
		If Not $g_bRunState Then Return
		If $hWin = 0 Then
			OpenAndroid(True) ; Try to start Android if it is not running
		Else
			RebootAndroid()
		EndIf
	  $aPos = getAndroidPos(True)
	  If Not $g_bRunState Then Return
	  If @error = 1 Then
		  _ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 600)
		  $stext = @CRLF & GetTranslated(640,17,"MyBot has experienced a serious error") & @CRLF & @CRLF & _
			  GetTranslated(640,18,"Unable to find or start up") & " " & $g_sAndroidEmulator & @CRLF & @CRLF & GetTranslated(640,22,"Reboot PC and try again,") & _
			  GetTranslated(640,19,"and search www.mybot.run forums for more help") & @CRLF
		  $MsgBox = _ExtMsgBox(0, GetTranslated(640,20,"Close MyBot!"), GetTranslated(640,21,"Okay - Must Exit Program"), $stext, 15, $g_hFrmBot)
		  If $MsgBox = 1 Then
			  BotClose()
			  Return
		  EndIf
	   EndIf
	EndIf

	If IsArray($aPos) Then
		Local $tPoint = DllStructCreate("int X;int Y")
		DllStructSetData($tPoint, "X", $aPos[0])
		If @error <> 0 Then
		   $tPoint = 0
		   Return SetError (0,0,0)
	    EndIf

		DllStructSetData($tPoint, "Y", $aPos[1])
		If @error <> 0 Then
		   $tPoint = 0
		   Return SetError (0,0,0)
	    EndIf

		_WinAPI_ClientToScreen(GetCurrentAndroidHWnD(), $tPoint)
		If @error <> 0 Then
		   $tPoint = 0
		   Return SetError (0,0,0)
	    EndIf

		$g_aiBSpos[0] = DllStructGetData($tPoint, "X")
		If @error <> 0 Then
		   $tPoint = 0
		   Return SetError (0,0,0)
	    EndIf

		$g_aiBSpos[1] = DllStructGetData($tPoint, "Y")
		If @error <> 0 Then
		   $tPoint = 0
		   Return SetError (0,0,0)
	    EndIf

		$g_aiBSrpos[0] = $aPos[0]
		$g_aiBSrpos[1] = $aPos[1]

	    $tPoint = 0

		$Changed = Not ($aOldValues[0] = $g_aiBSpos[0] And $aOldValues[1] = $g_aiBSpos[1] And $aOldValues[2] = $g_aiBSrpos[0] And $aOldValues[3] = $g_aiBSrpos[1])
		If $g_iDebugClick = 1 Or $g_iDebugSetlog = 1 And $Changed Then Setlog("$g_aiBSpos X,Y = " & $g_aiBSpos[0] & "," & $g_aiBSpos[1] & "; BSrpos X,Y = " & $g_aiBSrpos[0] & "," & $g_aiBSrpos[1], $COLOR_ERROR, "Verdana", "7.5", 0)
	EndIf

    SuspendAndroid($SuspendMode, False)
EndFunc   ;==>getBSPos

Func getAndroidPos($FastCheck = False, $RetryCount = 0)
   Local $BSsize = ControlGetPos(GetCurrentAndroidHWnD(), $g_sAppPaneName, $g_sAppClassInstance)

   ;If Not $g_bRunState Or $FastCheck Then Return $BSsize
   If $FastCheck Then Return $BSsize

   If IsArray($BSsize) Then ; Is Android Client Control available?

	 Local $BSx = $BSsize[2] ; ($BSsize[2] > $BSsize[3]) ? $BSsize[2] : $BSsize[3]
	 Local $BSy = $BSsize[3] ; ($BSsize[2] > $BSsize[3]) ? $BSsize[3] : $BSsize[2]

	 If $BSx <> $g_iAndroidClientWidth Or $BSy <> $g_iAndroidClientHeight Then ; Is Client size correct?
		; ensure Android Window and Screen sizes are up-to-date
	    UpdateAndroidWindowState()
     EndIf

	 If $BSx <> $g_iAndroidClientWidth Or $BSy <> $g_iAndroidClientHeight Then ; Is Client size correct?
		;DisposeWindows()
		;WinActivate($HWnD)
	    SetDebugLog("Unsupported " & $g_sAndroidEmulator & " screen size of " & $BSx & " x " & $BSy & " !", $COLOR_ACTION)

	    ; check if emultor window only needs resizing (problem with BS or Droid4X in lower Screen Resolutions!)
		Local $AndroidWinPos = WinGetPos($HWnD)
		Local $WinWidth = $AndroidWinPos[2] ; ($AndroidWinPos[2] > $AndroidWinPos[3]) ? $AndroidWinPos[2] : $AndroidWinPos[3]
		Local $WinHeight = $AndroidWinPos[3] ; ($AndroidWinPos[2] > $AndroidWinPos[3]) ? $AndroidWinPos[3] : $AndroidWinPos[2]

		Local $aWindowClientDiff[2] = [0,0] ; Compensate any controls surrounding the Android Client Control
		Local $aAndroidWindow[2] = [$g_iAndroidWindowWidth, $g_iAndroidWindowHeight]
	    Local $tRECT = _WinAPI_GetClientRect($HWnD)
		If @error = 0 Then
			$aWindowClientDiff[0] = $WinWidth - (DllStructGetData($tRECT, "Right") - DllStructGetData($tRECT, "Left"))
			$aWindowClientDiff[1] = $WinHeight - (DllStructGetData($tRECT, "Bottom") - DllStructGetData($tRECT, "Top"))
			If $g_iDebugSetlog = 1 Then SetLog($title & " Window-Client-Diff: " & $aWindowClientDiff[0] & "," & $aWindowClientDiff[1], $COLOR_INFO)
			$aAndroidWindow[0] = $g_iAndroidWindowWidth + $aWindowClientDiff[0]
			$aAndroidWindow[1] = $g_iAndroidWindowHeight + $aWindowClientDiff[1]
			If $g_iDebugSetlog = 1 Then SetLog($title & " Adjusted Window Size: " & $aAndroidWindow[0] & " x " & $aAndroidWindow[1], $COLOR_INFO)
		 Else
			SetDebugLog("WARNING: Cannot determine " & $g_sAndroidEmulator & " Window Client Area!", $COLOR_ERROR)
		EndIf

		WinMove($HWnD, "", $AndroidWinPos[0], $AndroidWinPos[1], $aAndroidWindow[0] - 4, $aAndroidWindow[1] - 4) ; force invalid resize (triggers Android rendering control resize)
		;Sleep($iDelaySleep)
		$AndroidWinPos = WinGetPos($HWnD)
		Local $WinWidth = $AndroidWinPos[2]
		Local $WinHeight = $AndroidWinPos[3]
		If $g_iAndroidWindowWidth > 0 And $g_iAndroidWindowHeight > 0 And ($WinWidth <> $aAndroidWindow[0] Or $WinHeight <> $aAndroidWindow[1]) Then ; Check expected Window size

			WinMove2($HWnD, "", $AndroidWinPos[0], $AndroidWinPos[1], $aAndroidWindow[0], $aAndroidWindow[1]) ; resized to expected window size
			;WinMove($HWnD, "", $AndroidWinPos[0], $AndroidWinPos[1], $aAndroidWindow[0], $aAndroidWindow[1])
			;_WinAPI_SetWindowPos($HWnD, 0, 0, 0, $g_iAndroidWindowWidth, $g_iAndroidWindowHeight, BitOr($SWP_NOACTIVATE, $SWP_NOMOVE, $SWP_NOREPOSITION, $SWP_NOSENDCHANGING, $SWP_NOZORDER)) ; resize window without BS changing it back
			If @error = 0 Then
			   ;ControlMove($HWnD, $g_sAppPaneName, $g_sAppClassInstance, 0, 0, $g_iAndroidClientWidth, $g_iAndroidClientHeight)
			   SetDebugLog($g_sAndroidEmulator & " window resized to " & $aAndroidWindow[0] & " x " & $aAndroidWindow[1], $COLOR_SUCCESS)

			   RedrawAndroidWindow()

			   ; wait 5 Sec. till window client content is resized also
			   Local $hTimer = TimerInit()
			   Do
				  Sleep($iDelaySleep)
				  Local $new_BSsize = getAndroidPos(True)
			   Until TimerDiff($hTimer) > 5000 Or ($BSsize[2] <> $new_BSsize[2] And $BSsize[3] <> $new_BSsize[3])

			   ; reload size
			   $BSsize[2] = $new_BSsize[2]
			   $BSsize[3] = $new_BSsize[3]
			   $BSx = $BSsize[2] ; ($BSsize[2] > $BSsize[3]) ? $BSsize[2] : $BSsize[3]
			   $BSy = $BSsize[3] ; ($BSsize[2] > $BSsize[3]) ? $BSsize[3] : $BSsize[2]

			   If $BSx <> $g_iAndroidClientWidth Or $BSy <> $g_iAndroidClientHeight Then
				  SetLog($g_sAndroidEmulator & " window resize didn't work, screen is " & $BSx & " x " & $BSy, $COLOR_ERROR)
			   Else
				  SetLog($g_sAndroidEmulator & " window resized to work with MyBot", $COLOR_SUCCESS)
			   EndIf

			Else
			   SetDebugLog("WARNING: Cannot resize " & $g_sAndroidEmulator & " window to " & $aAndroidWindow[0] & " x " & $aAndroidWindow[1], $COLOR_ERROR)
			EndIf

		Else

			; added for Nox that reports during launch a client size of 1x1
			If $RetryCount < 5 Then
				Sleep(250)
				Return getAndroidPos($FastCheck, $RetryCount + 1)
			EndIf

		EndIf

     EndIf

   EndIf

   Return $BSsize

EndFunc