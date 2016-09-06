; #FUNCTION# ====================================================================================================================
; Name ..........: ZoomOut
; Description ...: Tries to zoom out of the screen until the borders, located at the top of the game (usually black), is located.
; Syntax ........: ZoomOut()
; Parameters ....:
; Return values .: None
; Author ........: Code Gorilla #94
; Modified ......: KnowJack (July 2015) stop endless loop
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func ZoomOut() ;Zooms out
    ResumeAndroid()
    WinGetAndroidHandle()
	getBSPos() ; Update $HWnd and Android Window Positions
	If Not $RunState Then Return
	Local $Result
	If $AndroidEmbedded = False Then
		; default zoomout
		$Result = Execute("ZoomOut" & $Android & "()")
		If $Result = "" And @error <> 0 Then
			; Not implemented or other error
			$Result = AndroidOnlyZoomOut()
		EndIf
		Return $Result
	EndIf

	; Android embedded, only use Android zoomout
	AndroidOnlyZoomOut()
EndFunc   ;==>ZoomOut

Func ZoomOutBlueStacks() ;Zooms out
	Return ZoomOutCtrlClick(True, False, False, False)
   ;Return DefaultZoomOut("{DOWN}", 0)
   ; ZoomOutCtrlClick doesn't cause moving buildings, but uses global Ctrl-Key and has taking focus problems
   ;Return ZoomOutCtrlClick(True, False, False, False)
EndFunc

Func ZoomOutBlueStacks2()
	Return ZoomOutCtrlClick(True, False, False, False)
   ;Return DefaultZoomOut("{DOWN}", 0)
   ; ZoomOutCtrlClick doesn't cause moving buildings, but uses global Ctrl-Key and has taking focus problems
   ;Return ZoomOutCtrlClick(True, False, False, False)
EndFunc

Func ZoomOutMEmu()
   ;ClickP($aAway) ; activate window first with Click Away (when not clicked zoom might not work)
   Return DefaultZoomOut("{F3}", 0)
EndFunc

#cs
Func ZoomOutLeapDroid()
	Local $hCtrl = ControlGetHandle($HWnD, $AppPaneName, $AppClassInstance)
	Return ZoomOutCtrlWheelScroll(True, True, True, False, $hCtrl)
EndFunc
#ce

Func ZoomOutDroid4X()
   Return ZoomOutCtrlWheelScroll(True, True, True)
EndFunc

Func ZoomOutNox()
   Return ZoomOutCtrlWheelScroll(True, True, True)
   ;Return DefaultZoomOut("{CTRLDOWN}{DOWN}{CTRLUP}", 0)
EndFunc

Func DefaultZoomOut($ZoomOutKey = "{DOWN}", $tryCtrlWheelScrollAfterCycles = 40, $AndroidZoomOut = True) ;Zooms out
	Local $result0, $result1, $i = 0
	Local $exitCount = 80
	Local $delayCount = 20
	ForceCaptureRegion()
	_CaptureRegion(0, 0, $DEFAULT_WIDTH, 2)
	If _GetPixelColor($aTopLeftClient[0], $aTopLeftClient[1]) <> Hex($aTopLeftClient[2], 6) Or _
	_GetPixelColor($aTopMiddleClient[0], $aTopMiddleClient[1]) <> Hex($aTopMiddleClient[2], 6) Or _
	_GetPixelColor($aTopRightClient[0], $aTopRightClient[1]) <> Hex($aTopRightClient[2], 6) Then
		SetLog("Zooming Out", $COLOR_BLUE)
		If _Sleep($iDelayZoomOut1) Then Return
		If $AndroidZoomOut = True Then
			AndroidZoomOut(True) ; use new ADB zoom-out
			ForceCaptureRegion()
			_CaptureRegion(0, 0, $DEFAULT_WIDTH, 2)
		EndIf
	    Local $tryCtrlWheelScroll = False
		While (_GetPixelColor($aTopLeftClient[0], $aTopLeftClient[1]) <> Hex($aTopLeftClient[2], 6) Or _
		_GetPixelColor($aTopMiddleClient[0], $aTopMiddleClient[1]) <> Hex($aTopMiddleClient[2], 6) Or _
		_GetPixelColor($aTopRightClient[0], $aTopRightClient[1]) <> Hex($aTopRightClient[2], 6)) And Not $tryCtrlWheelScroll

			AndroidShield("DefaultZoomOut") ; Update shield status
			If $AndroidZoomOut = True Then
			   AndroidZoomOut(False, $i) ; use new ADB zoom-out
			   If @error <> 0 Then $AndroidZoomOut = False
			EndIf
			If $AndroidZoomOut = False Then
			   ; original windows based zoom-out
			   If $debugsetlog = 1 Then Setlog("Index = "&$i, $COLOR_PURPLE) ; Index=2X loop count if success, will be increment by 1 if controlsend fail
			   If _Sleep($iDelayZoomOut2) Then Return
			   If $ichkBackground = 0 And $NoFocusTampering = False Then
				  $Result0 = ControlFocus($HWnD, "", "")
			   Else
				  $Result0 = 1
			   EndIf
			   $Result1 = ControlSend($HWnD, "", "", $ZoomOutKey)
			   If $debugsetlog = 1 Then Setlog("ControlFocus Result = "&$Result0 & ", ControlSend Result = "&$Result1& "|" & "@error= " & @error, $COLOR_PURPLE)
			   If $Result1 = 1 Then
				   $i += 1
			   Else
				   Setlog("Warning ControlSend $Result = "&$Result1, $COLOR_PURPLE)
			   EndIf
			EndIF

			If $i > $delayCount Then
				If _Sleep($iDelayZoomOut3) Then Return
			EndIf
			If $tryCtrlWheelScrollAfterCycles > 0 And $i > $tryCtrlWheelScrollAfterCycles Then $tryCtrlWheelScroll = True
			If $i > $exitCount Then Return
			If $RunState = False Then ExitLoop
			If IsProblemAffect(True) Then  ; added to catch errors during Zoomout
				Setlog($Android & " Error window detected", $COLOR_RED)
				If checkObstacles() = True Then Setlog("Error window cleared, continue Zoom out", $COLOR_BLUE)  ; call to clear normal errors
			EndIf
			$i += 1  ; add one to index value to prevent endless loop if controlsend fails
			ForceCaptureRegion()
			_CaptureRegion(0, 0, $DEFAULT_WIDTH, 2)
		WEnd
		If $tryCtrlWheelScroll Then
		    Setlog($Android & " zoom-out with key " & $ZoomOutKey & " didn't work, try now Ctrl+MouseWheel...", $COLOR_BLUE)
			Return ZoomOutCtrlWheelScroll(False, False, False, False)
	    EndIf
		Return True
	EndIf
	Return False
EndFunc   ;==>ZoomOut

Func ZoomOutCtrlWheelScroll($CenterMouseWhileZooming = True, $GlobalMouseWheel = True, $AlwaysControlFocus = False, $AndroidZoomOut = True, $hWin = $HWnD, $ScrollSteps = -5, $ClickDelay = 250)
   ;AutoItSetOption ( "SendKeyDownDelay", 3000)
	Local $exitCount = 80
	Local $delayCount = 20
	Local $result[4], $i = 0, $j
	Local $ZoomActions[4] = ["ControlFocus", "Ctrl Down", "Mouse Wheel Scroll Down", "Ctrl Up"]
	ForceCaptureRegion()
	_CaptureRegion(0, 0, $DEFAULT_WIDTH, 2)

	If _GetPixelColor($aTopLeftClient[0], $aTopLeftClient[1]) <> Hex($aTopLeftClient[2], 6) Or _
	_GetPixelColor($aTopMiddleClient[0], $aTopMiddleClient[1]) <> Hex($aTopMiddleClient[2], 6) Or _
	_GetPixelColor($aTopRightClient[0], $aTopRightClient[1]) <> Hex($aTopRightClient[2], 6) Then

	    SetLog("Zooming Out", $COLOR_BLUE)

		AndroidShield("ZoomOutCtrlWheelScroll") ; Update shield status
		If _Sleep($iDelayZoomOut1) Then Return
		If $AndroidZoomOut = True Then
			AndroidZoomOut(True) ; use new ADB zoom-out
			ForceCaptureRegion()
			_CaptureRegion(0, 0, $DEFAULT_WIDTH, 2)
		EndIf
		Local $aMousePos = MouseGetPos()

		While _GetPixelColor($aTopLeftClient[0], $aTopLeftClient[1]) <> Hex($aTopLeftClient[2], 6) Or _
			_GetPixelColor($aTopMiddleClient[0], $aTopMiddleClient[1]) <> Hex($aTopMiddleClient[2], 6) Or _
			_GetPixelColor($aTopRightClient[0], $aTopRightClient[1]) <> Hex($aTopRightClient[2], 6)

			If $AndroidZoomOut = True Then
			   AndroidZoomOut(False, $i) ; use new ADB zoom-out
			   If @error <> 0 Then $AndroidZoomOut = False
			EndIf
			If $AndroidZoomOut = False Then
			   ; original windows based zoom-out
			   If $debugsetlog = 1 Then Setlog("Index = " & $i, $COLOR_PURPLE) ; Index=2X loop count if success, will be increment by 1 if controlsend fail
			   If _Sleep($iDelayZoomOut2) Then ExitLoop
			   If ($ichkBackground = 0 And $NoFocusTampering = False) Or $AlwaysControlFocus Then
				  $Result[0] = ControlFocus($HWnD, "", "")
			   Else
				  $Result[0] = 1
			   EndIf

			   $Result[1] = ControlSend($hWin, "", "", "{CTRLDOWN}")
			   If $CenterMouseWhileZooming Then MouseMove($BSpos[0] + Int($DEFAULT_WIDTH / 2), $BSpos[1] + Int($DEFAULT_HEIGHT / 2), 0)
			   If $GlobalMouseWheel Then
                  $Result[2] = MouseWheel(($ScrollSteps < 0 ? "down" : "up"), Abs($ScrollSteps)) ; can't find $MOUSE_WHEEL_DOWN constant, couldn't include AutoItConstants.au3 either
			   Else
				  Local $WM_WHEELMOUSE = 0x020A, $MK_CONTROL = 0x0008
				  Local $wParam = BitOR($ScrollSteps * 0x10000, BitAND($MK_CONTROL, 0xFFFF)) ; HiWord = -120 WheelScrollDown, LoWord = $MK_CONTROL
				  Local $lParam =  BitOR(($BSpos[1] + Int($DEFAULT_HEIGHT / 2)) * 0x10000, BitAND(($BSpos[0] + Int($DEFAULT_WIDTH / 2)), 0xFFFF)) ; ; HiWord = y-coordinate, LoWord = x-coordinate
				  _SendMessage($HWnD, $WM_WHEELMOUSE, $wParam, $lParam)
				  $Result[2] = (@error = 0 ? 1 : 0)
			   EndIf
			   If _Sleep($ClickDelay) Then ExitLoop
			   $Result[3] = ControlSend($hWin, "", "", "{CTRLUP}{SPACE}")

			   If $debugsetlog = 1 Then Setlog("ControlFocus Result = " & $Result[0] & _
					  ", " & $ZoomActions[1] & " = " & $Result[1] & _
					  ", " & $ZoomActions[2] & " = " & $Result[2] & _
					  ", " & $ZoomActions[3] & " = " & $Result[3] & _
					  " | " & "@error= " & @error, $COLOR_PURPLE)
			   For $j = 1 To 3
				  If $Result[$j] = 1 Then
					  $i += 1
					  ExitLoop
				  EndIf
			   Next
			   For $j = 1 To 3
				  If $Result[$j] = 0 Then
					  Setlog("Warning " & $ZoomActions[$j] & " = " & $Result[1], $COLOR_PURPLE)
				  EndIf
			   Next
			EndIf

			If $i > $delayCount Then
				If _Sleep($iDelayZoomOut3) Then ExitLoop
			EndIf
			If $i > $exitCount Then ExitLoop
			If $RunState = False Then ExitLoop
			If IsProblemAffect(True) Then  ; added to catch errors during Zoomout
				Setlog($Android & " Error window detected", $COLOR_RED)
				If checkObstacles() = True Then Setlog("Error window cleared, continue Zoom out", $COLOR_BLUE)  ; call to clear normal errors
			EndIf
			$i += 1  ; add one to index value to prevent endless loop if controlsend fails
			ForceCaptureRegion()
			_CaptureRegion(0, 0, $DEFAULT_WIDTH, 2)
		 WEnd

		 If $CenterMouseWhileZooming And $AndroidZoomOut = False Then MouseMove($aMousePos[0], $aMousePos[1], 0)
		Return True

	EndIf
	Return False
 EndFunc

Func ZoomOutCtrlClick($ZoomOutOverWaters = True, $CenterMouseWhileZooming = False, $AlwaysControlFocus = False, $AndroidZoomOut = True, $ClickDelay = 250)
   ;AutoItSetOption ( "SendKeyDownDelay", 3000)
	Local $exitCount = 80
	Local $delayCount = 20
	Local $result[4], $i, $j
	Local $SendCtrlUp = False
	Local $ZoomActions[4] = ["ControlFocus", "Ctrl Down", "Click", "Ctrl Up"]
	ForceCaptureRegion()
	_CaptureRegion(0, 0, $DEFAULT_WIDTH, 2)

	If _GetPixelColor($aTopLeftClient[0], $aTopLeftClient[1]) <> Hex($aTopLeftClient[2], 6) Or _
	_GetPixelColor($aTopMiddleClient[0], $aTopMiddleClient[1]) <> Hex($aTopMiddleClient[2], 6) Or _
	_GetPixelColor($aTopRightClient[0], $aTopRightClient[1]) <> Hex($aTopRightClient[2], 6) Then

	    SetLog("Zooming Out", $COLOR_BLUE)

		AndroidShield("ZoomOutCtrlClick") ; Update shield status

		If $ZoomOutOverWaters = True Then
			; zoom out over waters
			If $AndroidZoomOut = True Then
				AndroidZoomOut(True) ; use new ADB zoom-out
				ForceCaptureRegion()
				_CaptureRegion(0, 0, $DEFAULT_WIDTH, 2)
			Else
				For $i = 1 To 3
				   ; scroll to waters
				   _PostMessage_ClickDrag(100, 600, 600, 100, "left")
				Next
			EndIf
		EndIf

		If _Sleep($iDelayZoomOut1) Then Return
		Local $aMousePos = MouseGetPos()

		$i = 0
		While _GetPixelColor($aTopLeftClient[0], $aTopLeftClient[1]) <> Hex($aTopLeftClient[2], 6) Or _
			_GetPixelColor($aTopMiddleClient[0], $aTopMiddleClient[1]) <> Hex($aTopMiddleClient[2], 6) Or _
			_GetPixelColor($aTopRightClient[0], $aTopRightClient[1]) <> Hex($aTopRightClient[2], 6)

			If $AndroidZoomOut = True Then
			   AndroidZoomOut(False, $i) ; use new ADB zoom-out
			   If @error <> 0 Then $AndroidZoomOut = False
			EndIf
			If $AndroidZoomOut = False Then
			   ; original windows based zoom-out
			   If $debugsetlog = 1 Then Setlog("Index = " & $i, $COLOR_PURPLE) ; Index=2X loop count if success, will be increment by 1 if controlsend fail
			   If _Sleep($iDelayZoomOut2) Then ExitLoop
			   If ($ichkBackground = 0 And $NoFocusTampering = False) Or $AlwaysControlFocus Then
				  $Result[0] = ControlFocus($HWnD, "", "")
			   Else
				  $Result[0] = 1
			   EndIf

			   $Result[1] = ControlSend($HWnD, "", "", "{CTRLDOWN}")
			   $SendCtrlUp = True
			   If $CenterMouseWhileZooming Then MouseMove($BSpos[0] + Int($DEFAULT_WIDTH / 2), $BSpos[1] + Int($DEFAULT_HEIGHT / 2), 0)
			   $Result[2] = ControlClick($HWnD, "", "", "left", "1", $BSrpos[0] + Int($DEFAULT_WIDTH / 2), $BSrpos[1] + 600)
			   If _Sleep($ClickDelay) Then ExitLoop
			   $Result[3] = ControlSend($HWnD, "", "", "{CTRLUP}{SPACE}")
			   $SendCtrlUp = False

			   If $debugsetlog = 1 Then Setlog("ControlFocus Result = " & $Result[0] & _
					  ", " & $ZoomActions[1] & " = " & $Result[1] & _
					  ", " & $ZoomActions[2] & " = " & $Result[2] & _
					  ", " & $ZoomActions[3] & " = " & $Result[3] & _
					  " | " & "@error= " & @error, $COLOR_PURPLE)
			   For $j = 1 To 3
				  If $Result[$j] = 1 Then
					  ExitLoop
				  EndIf
			   Next
			   For $j = 1 To 3
				  If $Result[$j] = 0 Then
					  Setlog("Warning " & $ZoomActions[$j] & " = " & $Result[1], $COLOR_PURPLE)
				  EndIf
			   Next
			EndIf

			If $i > $delayCount Then
				If _Sleep($iDelayZoomOut3) Then ExitLoop
			EndIf
			If $i > $exitCount Then ExitLoop
			If $RunState = False Then ExitLoop
			If IsProblemAffect(True) Then  ; added to catch errors during Zoomout
				Setlog($Android & " Error window detected", $COLOR_RED)
				If checkObstacles() = True Then Setlog("Error window cleared, continue Zoom out", $COLOR_BLUE)  ; call to clear normal errors
			EndIf
			$i += 1  ; add one to index value to prevent endless loop if controlsend fails
			ForceCaptureRegion()
			_CaptureRegion(0, 0, $DEFAULT_WIDTH, 2)
		 WEnd

		 If $SendCtrlUp Then ControlSend($HWnD, "", "", "{CTRLUP}{SPACE}")

		 If $CenterMouseWhileZooming Then MouseMove($aMousePos[0], $aMousePos[1], 0)

		Return True
	EndIf
	Return False
 EndFunc

Func AndroidOnlyZoomOut() ;Zooms out
	Local $i = 0
	Local $exitCount = 80
	ForceCaptureRegion()
	_CaptureRegion(0, 0, $DEFAULT_WIDTH, 2)
	If _GetPixelColor($aTopLeftClient[0], $aTopLeftClient[1]) <> Hex($aTopLeftClient[2], 6) Or _
	_GetPixelColor($aTopMiddleClient[0], $aTopMiddleClient[1]) <> Hex($aTopMiddleClient[2], 6) Or _
	_GetPixelColor($aTopRightClient[0], $aTopRightClient[1]) <> Hex($aTopRightClient[2], 6) Then
		SetLog("Zooming Out", $COLOR_BLUE)
		AndroidZoomOut(True) ; use new ADB zoom-out
		ForceCaptureRegion()
		_CaptureRegion(0, 0, $DEFAULT_WIDTH, 2)
		While (_GetPixelColor($aTopLeftClient[0], $aTopLeftClient[1]) <> Hex($aTopLeftClient[2], 6) Or _
		_GetPixelColor($aTopMiddleClient[0], $aTopMiddleClient[1]) <> Hex($aTopMiddleClient[2], 6) Or _
		_GetPixelColor($aTopRightClient[0], $aTopRightClient[1]) <> Hex($aTopRightClient[2], 6))

			AndroidShield("AndroidOnlyZoomOut") ; Update shield status
			AndroidZoomOut(False, $i) ; use new ADB zoom-out
			If $i > $exitCount Then Return
			If $RunState = False Then ExitLoop
			If IsProblemAffect(True) Then  ; added to catch errors during Zoomout
				Setlog($Android & " Error window detected", $COLOR_RED)
				If checkObstacles() = True Then Setlog("Error window cleared, continue Zoom out", $COLOR_BLUE)  ; call to clear normal errors
			EndIf
			$i += 1  ; add one to index value to prevent endless loop if controlsend fails
			ForceCaptureRegion()
			_CaptureRegion(0, 0, $DEFAULT_WIDTH, 2)
		WEnd
		Return True
	EndIf
	Return False
EndFunc   ;==>AndroidOnlyZoomOut
