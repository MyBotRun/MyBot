; #FUNCTION# ====================================================================================================================
; Name ..........: getBSPos
; Description ...: Gets the postiion of of the Bluestacks window, attempts to open BS if not available, or closes MBR if it can not to avoid AutoIt internal error
; Syntax ........: getBSPos()
; Parameters ....:
; Return values .: None
; Author ........: Code Monkey #59
; Modified ......: KnowJack(july 2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
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
	ControlGetPos($HWnD, $AppPaneName, $AppClassInstance)
	If Not $RunState Then Return
	If @error = 1 Then
		SetError (0,0,0)
		If $hWin = 0 Then
			OpenAndroid(True)
		Else
			RebootAndroid()
		EndIf
	    ControlGetPos($HWnD, $AppPaneName, $AppClassInstance)
		If Not $RunState Then Return
		If @error = 1 Then
			_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 600)
			$stext = @CRLF & "MyBot has experienced a serious error" & @CRLF & @CRLF & _
					"Unable to find or start up " & $Android & @CRLF & @CRLF & "Reboot PC and try again," & _
					"and search www.mybot.run forums for more help" & @CRLF
			$MsgBox = _ExtMsgBox(0, "Close MyBot!", "Okay - Must Exit Program", $stext, 15, $frmBot)
			If $MsgBox = 1 Then
				BotClose()
			EndIf
		EndIf
	EndIf
	If @error = 1 Then
		SetError (0,0,0)
		If $hWin = 0 Then
			OpenAndroid(True) ; Try to start Android if it is not running
		Else
			RebootAndroid()
		EndIf
		Return
	EndIf
	$aOldValues[0] = $BSpos[0]
	$aOldValues[1] = $BSpos[1]
	$aOldValues[2] = $BSrpos[0]
	$aOldValues[3] = $BSrpos[1]

	Local $aPos = getAndroidPos()
	If Not IsArray($aPos) Then
		If $hWin = 0 Then
			OpenAndroid(True) ; Try to start Android if it is not running
		Else
			RebootAndroid()
		EndIf
	  $aPos = ControlGetPos($HWnD, $AppPaneName, $AppClassInstance)
	  If Not $RunState Then Return
	  If @error = 1 Then
		  _ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 600)
		  $stext = @CRLF & "MyBot has experienced a serious error" & @CRLF & @CRLF & _
				  "Unable to find or start up " & $Android & @CRLF & @CRLF & "Reboot PC and try again," & _
				  "and search www.mybot.run forums for more help" & @CRLF
		  $MsgBox = _ExtMsgBox(0, "Close MyBot!", "Okay - Must Exit Program", $stext, 15, $frmBot)
		  If $MsgBox = 1 Then
			  BotClose()
		  EndIf
	   EndIf
	EndIf

	If IsArray($aPos) Then
		If Not $RunState Then Return
		Local $tPoint = DllStructCreate("int X;int Y")
		DllStructSetData($tPoint, "X", $aPos[0])
		If @error <> 0 Then Return SetError (0,0,0)
		DllStructSetData($tPoint, "Y", $aPos[1])
		If @error <> 0 Then Return SetError (0,0,0)
		_WinAPI_ClientToScreen($HWnD, $tPoint)
		If @error <> 0 Then Return SetError (0,0,0)
		$BSpos[0] = DllStructGetData($tPoint, "X")
		If @error <> 0 Then Return SetError (0,0,0)
		$BSpos[1] = DllStructGetData($tPoint, "Y") + $ClientOffsetY
		If @error <> 0 Then Return SetError (0,0,0)
		$BSrpos[0] = $aPos[0]
		$BSrpos[1] = $aPos[1] + $ClientOffsetY

		$Changed = Not ($aOldValues[0] = $BSpos[0] And $aOldValues[1] = $BSpos[1] And $aOldValues[2] = $BSrpos[0] And $aOldValues[3] = $BSrpos[1])
		If $debugClick = 1 Or $debugSetlog = 1 And $Changed Then Setlog("$BSpos X,Y = " & $BSpos[0] & "," & $BSpos[1] & "; BSrpos X,Y = " & $BSrpos[0] & "," & $BSrpos[1], $COLOR_RED, "Verdana", "7.5", 0)
	EndIf

    SuspendAndroid($SuspendMode, False)
EndFunc   ;==>getBSPos

Func getAndroidPos()
   Local $BSsize = ControlGetPos($HWnD, $AppPaneName, $AppClassInstance)
   If Not $RunState Then Return $BSsize
   If IsArray($BSsize) Then ; Is Android Client Control available?

	 Local $BSx = $BSsize[2] ; ($BSsize[2] > $BSsize[3]) ? $BSsize[2] : $BSsize[3]
	 Local $BSy = $BSsize[3] ; ($BSsize[2] > $BSsize[3]) ? $BSsize[3] : $BSsize[2]

	 If $BSx <> $AndroidClientWidth Or $BSy <> $AndroidClientHeight Then ; Is Client size correct?
		; ensure Android Window and Screen sizes are up-to-date
	    UpdateAndroidWindowState()
     EndIf

	 If $BSx <> $AndroidClientWidth Or $BSy <> $AndroidClientHeight Then ; Is Client size correct?
		;DisposeWindows()
		;WinActivate($HWnD)
	    SetDebugLog("Unsupported " & $Android & " screen size of " & $BSx & " x " & $BSy & " !", $COLOR_ORANGE)

	    ; check if emultor window only needs resizing (problem with BS or Droid4X in lower Screen Resolutions!)
		Local $AndroidWinPos = WinGetPos($HWnD)
		Local $WinWidth = $AndroidWinPos[2] ; ($AndroidWinPos[2] > $AndroidWinPos[3]) ? $AndroidWinPos[2] : $AndroidWinPos[3]
		Local $WinHeight = $AndroidWinPos[3] ; ($AndroidWinPos[2] > $AndroidWinPos[3]) ? $AndroidWinPos[3] : $AndroidWinPos[2]

		Local $aWindowClientDiff[2] = [0,0] ; Compensate any controls surrounding the Android Client Control
		Local $aAndroidWindow[2] = [$AndroidWindowWidth, $AndroidWindowHeight]
	    Local $tRECT = _WinAPI_GetClientRect($HWnD)
		If @error = 0 Then
			$aWindowClientDiff[0] = $WinWidth - (DllStructGetData($tRECT, "Right") - DllStructGetData($tRECT, "Left"))
			$aWindowClientDiff[1] = $WinHeight - (DllStructGetData($tRECT, "Bottom") - DllStructGetData($tRECT, "Top"))
			If $debugSetlog = 1 Then SetLog($title & " Window-Client-Diff: " & $aWindowClientDiff[0] & "," & $aWindowClientDiff[1], $COLOR_BLUE)
			$aAndroidWindow[0] = $AndroidWindowWidth + $aWindowClientDiff[0]
			$aAndroidWindow[1] = $AndroidWindowHeight + $aWindowClientDiff[1]
			If $debugSetlog = 1 Then SetLog($title & " Adjusted Window Size: " & $aAndroidWindow[0] & " x " & $aAndroidWindow[1], $COLOR_BLUE)
		 Else
			SetDebugLog("WARNING: Cannot determine " & $Android & " Window Client Area!", $COLOR_RED)
		EndIf

		If $AndroidWindowWidth > 0 And $AndroidWindowHeight > 0 And ($WinWidth <> $aAndroidWindow[0] Or $WinHeight <> $aAndroidWindow[1]) Then ; Check expected Window size

			WinMove2($HWnD, "", $AndroidWinPos[0], $AndroidWinPos[1], $aAndroidWindow[0], $aAndroidWindow[1])
			;WinMove($HWnD, "", $AndroidWinPos[0], $AndroidWinPos[1], $aAndroidWindow[0], $aAndroidWindow[1])
			;_WinAPI_SetWindowPos($HWnD, 0, 0, 0, $AndroidWindowWidth, $AndroidWindowHeight, BitOr($SWP_NOACTIVATE, $SWP_NOMOVE, $SWP_NOREPOSITION, $SWP_NOSENDCHANGING, $SWP_NOZORDER)) ; resize window without BS changing it back
			If @error = 0 Then
			   ;ControlMove($HWnD, $AppPaneName, $AppClassInstance, 0, 0, $AndroidClientWidth, $AndroidClientHeight)
			   SetDebugLog($Android & " window resized to " & $aAndroidWindow[0] & " x " & $aAndroidWindow[1], $COLOR_GREEN)

			   RedrawAndroidWindow()

			   If _Sleep(500) Then Return False ; Just wait, not really required...
			   ; wait 5 Sec. till window client content is resized also
			   Local $hTimer = TimerInit()
			   Do
				  If _Sleep(100) Then Return False
				  Local $new_BSsize = ControlGetPos($HWnD, $AppPaneName, $AppClassInstance)
			   Until TimerDiff($hTimer) > 5000 Or ($BSsize[2] = $AndroidClientWidth And $BSsize[3] <> $AndroidClientHeight)

			   ; reload size
			   $BSsize[2] = $new_BSsize[2]
			   $BSsize[3] = $new_BSsize[3]
			   $BSx = $BSsize[2] ; ($BSsize[2] > $BSsize[3]) ? $BSsize[2] : $BSsize[3]
			   $BSy = $BSsize[3] ; ($BSsize[2] > $BSsize[3]) ? $BSsize[3] : $BSsize[2]

			   If $BSx <> $AndroidClientWidth Or $BSy <> $AndroidClientHeight Then
				  SetLog($Android & " window resize didn't work, screen is " & $BSx & " x " & $BSy, $COLOR_RED)
			   Else
				  SetLog($Android & " window resized to work with MyBot", $COLOR_GREEN)
			   EndIf

			Else
			   SetDebugLog("WARNING: Cannot resize " & $Android & " window to " & $aAndroidWindow[0] & " x " & $aAndroidWindow[1], $COLOR_RED)
			EndIf

		EndIf

     EndIf

   EndIf

   Return $BSsize

EndFunc