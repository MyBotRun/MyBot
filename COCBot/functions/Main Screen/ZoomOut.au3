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
	Return Execute("ZoomOut" & $Android & "()")
EndFunc   ;==>ZoomOut

Func ZoomOutBlueStacks() ;Zooms out
   Return DefaultZoomOut()
EndFunc

Func DefaultZoomOut($ZoomOutKey = "{DOWN}", $tryCtrlWheelScrollAfterCycles = 40) ;Zooms out
	Local $result0, $result1, $i = 0
	Local $exitCount = 80
	Local $delayCount = 20
	Local $AndroidZoomOut = True
	_CaptureRegion(0, 0, $DEFAULT_WIDTH, 2)
	If _GetPixelColor($aTopLeftClient[0], $aTopLeftClient[1]) <> Hex($aTopLeftClient[2], 6) Or _
	_GetPixelColor($aTopMiddleClient[0], $aTopMiddleClient[1]) <> Hex($aTopMiddleClient[2], 6) Or _
	_GetPixelColor($aTopRightClient[0], $aTopRightClient[1]) <> Hex($aTopRightClient[2], 6) Then
		SetLog("Zooming Out", $COLOR_BLUE)
		If _Sleep($iDelayZoomOut1) Then Return
	    Local $tryCtrlWheelScroll = False
		While (_GetPixelColor($aTopLeftClient[0], $aTopLeftClient[1]) <> Hex($aTopLeftClient[2], 6) Or _
		_GetPixelColor($aTopMiddleClient[0], $aTopMiddleClient[1]) <> Hex($aTopMiddleClient[2], 6) Or _
		_GetPixelColor($aTopRightClient[0], $aTopRightClient[1]) <> Hex($aTopRightClient[2], 6)) And Not $tryCtrlWheelScroll

			If $AndroidZoomOut = True Then
			   AndroidZoomOut($i) ; use new ADB zoom-out
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
			_CaptureRegion(0, 0, $DEFAULT_WIDTH, 2)
		WEnd
		If $tryCtrlWheelScroll Then
		    Setlog($Android & " zoom-out with key " & $ZoomOutKey & " didn't work, try now Ctrl+MouseWheel...", $COLOR_BLUE)
			Return ZoomOutCtrlWheelScroll(False, False, False, False)
	    EndIf
	EndIf
EndFunc   ;==>ZoomOut

Func ZoomOutBlueStacks2()
   Return DefaultZoomOut()
EndFunc

Func ZoomOutMEmu()
   ClickP($aAway) ; activate window first with Click Away (when not clicked zoom might not work)
   Return DefaultZoomOut("{F3}", 0)
EndFunc

Func ZoomOutDroid4X()
   Return ZoomOutCtrlWheelScroll(True, True, True)
EndFunc

Func ZoomOutNox()
   Return ZoomOutCtrlWheelScroll(True, True, True)
   ;Return DefaultZoomOut("{CTRLDOWN}{DOWN}{CTRLUP}", 0)
EndFunc

Func ZoomOutCtrlWheelScroll($CenterMouseWhileZooming = True, $GlobalMouseWheel = True, $AlwaysControlFocus = False, $AndroidZoomOut = True)
   ;AutoItSetOption ( "SendKeyDownDelay", 3000)
	Local $exitCount = 80
	Local $delayCount = 20
	Local $result[4], $i = 0, $j
	Local $ZoomActions[4] = ["ControlFocus", "Ctrl Down", "Mouse Wheel Scroll Down", "Ctrl Up"]
	_CaptureRegion(0, 0, $DEFAULT_WIDTH, 2)

	If _GetPixelColor($aTopLeftClient[0], $aTopLeftClient[1]) <> Hex($aTopLeftClient[2], 6) Or _
	_GetPixelColor($aTopMiddleClient[0], $aTopMiddleClient[1]) <> Hex($aTopMiddleClient[2], 6) Or _
	_GetPixelColor($aTopRightClient[0], $aTopRightClient[1]) <> Hex($aTopRightClient[2], 6) Then

	    SetLog("Zooming Out", $COLOR_BLUE)

		If _Sleep($iDelayZoomOut1) Then Return
		Local $aMousePos = MouseGetPos()

		While _GetPixelColor($aTopLeftClient[0], $aTopLeftClient[1]) <> Hex($aTopLeftClient[2], 6) Or _
			_GetPixelColor($aTopMiddleClient[0], $aTopMiddleClient[1]) <> Hex($aTopMiddleClient[2], 6) Or _
			_GetPixelColor($aTopRightClient[0], $aTopRightClient[1]) <> Hex($aTopRightClient[2], 6)

			If $AndroidZoomOut = True Then
			   AndroidZoomOut($i) ; use new ADB zoom-out
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
			   If $CenterMouseWhileZooming Then MouseMove($BSpos[0] + Int($DEFAULT_WIDTH / 2), $BSpos[1] + Int($DEFAULT_HEIGHT / 2), 0)
			   If $GlobalMouseWheel Then
				  $Result[2] = MouseWheel("down", 5) ; can't find $MOUSE_WHEEL_DOWN constant, couldn't include AutoItConstants.au3 either
			   Else
				  Local $WM_WHEELMOUSE = 0x020A, $MK_CONTROL = 0x0008
				  Local $wParam = BitOR(-5 * 0x10000, BitAND($MK_CONTROL, 0xFFFF)) ; HiWord = -120 WheelScrollDown, LoWord = $MK_CONTROL
				  Local $lParam =  BitOR(($BSpos[1] + Int($DEFAULT_HEIGHT / 2)) * 0x10000, BitAND(($BSpos[0] + Int($DEFAULT_WIDTH / 2)), 0xFFFF)) ; ; HiWord = y-coordinate, LoWord = x-coordinate
				  _SendMessage($HWnD, $WM_WHEELMOUSE, $wParam, $lParam)
				  $Result[2] = (@error = 0 ? 1 : 0)
			   EndIf
			   $Result[3] = ControlSend($HWnD, "", "", "{CTRLUP}")

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
			_CaptureRegion(0, 0, $DEFAULT_WIDTH, 2)
		 WEnd

		 If $CenterMouseWhileZooming Then MouseMove($aMousePos[0], $aMousePos[1], 0)

	EndIf
 EndFunc
