; #FUNCTION# ====================================================================================================================
; Name ..........: ZoomOut
; Description ...: Tries to zoom out of the screen until the borders, located at the top of the game (usually black), is located.
; Syntax ........: ZoomOut()
; Parameters ....:
; Return values .: None
; Author ........: Code Gorilla #94
; Modified ......: KnowJack (July 2015) stop endless loop
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func ZoomOutBlueStacks() ;Zooms out
	Local $result0, $result1, $i = 0
	_CaptureRegion(0, 0, $DEFAULT_WIDTH, 2)
	If _GetPixelColor($aTopLeftClient[0], $aTopLeftClient[1]) <> Hex($aTopLeftClient[2], 6) Or _
	_GetPixelColor($aTopMiddleClient[0], $aTopMiddleClient[1]) <> Hex($aTopMiddleClient[2], 6) Or _
	_GetPixelColor($aTopRightClient[0], $aTopRightClient[1]) <> Hex($aTopRightClient[2], 6) 	Then
		SetLog("Zooming Out", $COLOR_BLUE)
		If _Sleep($iDelayZoomOut1) Then Return
		While _GetPixelColor($aTopLeftClient[0], $aTopLeftClient[1]) <> Hex($aTopLeftClient[2], 6) Or _
			_GetPixelColor($aTopMiddleClient[0], $aTopMiddleClient[1]) <> Hex($aTopMiddleClient[2], 6) Or _
			_GetPixelColor($aTopRightClient[0], $aTopRightClient[1]) <> Hex($aTopRightClient[2], 6)
			If $debugsetlog = 1 Then Setlog("Index = "&$i, $COLOR_PURPLE) ; Index=2X loop count if success, will be increment by 1 if controlsend fail
			If _Sleep($iDelayZoomOut2) Then Return
			$Result0 = ControlFocus($Title, "","")
			$Result1 = ControlSend($Title, "", "", "{DOWN}")
			If $debugsetlog = 1 Then Setlog("ControlFocus Result = "&$Result0 & ", ControlSend Result = "&$Result1& "|" & "@error= " & @error, $COLOR_PURPLE)
			If $Result1 = 1 Then
				$i += 1
			Else
				Setlog("Warning ControlSend $Result = "&$Result1, $COLOR_PURPLE)
			EndIf
			If $i > 20 Then
				If _Sleep($iDelayZoomOut3) Then Return
			EndIf
			If $i > 80 Then Return
			If IsProblemAffect(True) Then  ; added to catch errors during Zoomout
				Setlog("BS Error window detected", $COLOR_RED)
				If checkObstacles() = True Then Setlog("Error window cleared, continue Zoom out", $COLOR_BLUE)  ; call to clear normal errors
			EndIf
			$i += 1  ; add one to index value to prevent endless loop if controlsend fails
			_CaptureRegion(0, 0, $DEFAULT_WIDTH, 2)
		WEnd
	EndIf
EndFunc   ;==>ZoomOut

Func ZoomOutBlueStacks2()
   return ZoomOutBlueStacks()
EndFunc

Func ZoomOutDroid4X()
   ;AutoItSetOption ( "SendKeyDownDelay", 3000)
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

			If $debugsetlog = 1 Then Setlog("Index = " & $i, $COLOR_PURPLE) ; Index=2X loop count if success, will be increment by 1 if controlsend fail
			If _Sleep($iDelayZoomOut2) Then ExitLoop
			Local $app = "" ; $AppClassInstance
			$Result[0] = ControlFocus($Title, "", $app)
			$Result[1] = ControlSend($Title, "", $app, "{CTRLDOWN}")
			MouseMove($BSpos[0] + Int($DEFAULT_WIDTH / 2), $BSpos[1] + Int($DEFAULT_HEIGHT / 2), 0)
			$Result[2] = MouseWheel("down", 5) ; can't find $MOUSE_WHEEL_DOWN constant, couldn't include AutoItConstants.au3 either
			$Result[3] = ControlSend($Title, "", $app, "{CTRLUP}")

			If $debugsetlog = 1 Then Setlog("ControlFocus Result = " & $Result[0] & _
				   ", " & $ZoomActions[1] & " = " & $Result[1] & _
				   ", " & $ZoomActions[2] & " = " & $Result[2] & _
				   ", " & $ZoomActions[3] & " = " & $Result[3] & _
				   " | " & "@error= " & @error, $COLOR_PURPLE)
			For $j = 1 To 3
			   If $Result[$j] > 0 Then
				   $i += 1
				   ExitLoop
			   Else
				   If $Result[$j] = 0 Then Setlog("Warning " & $ZoomActions[$j] & " = " & $Result[1], $COLOR_PURPLE)
			   EndIf
			Next
			If $i > 20 Then
				If _Sleep($iDelayZoomOut3) Then ExitLoop
			EndIf
			If $i > 80 Then ExitLoop
			If IsProblemAffect(True) Then  ; added to catch errors during Zoomout
				Setlog("BS Error window detected", $COLOR_RED)
				If checkObstacles() = True Then Setlog("Error window cleared, continue Zoom out", $COLOR_BLUE)  ; call to clear normal errors
			EndIf
			$i += 1  ; add one to index value to prevent endless loop if controlsend fails
			_CaptureRegion(0, 0, $DEFAULT_WIDTH, 2)
		 WEnd

		 MouseMove($aMousePos[0], $aMousePos[1], 0)

	EndIf
 EndFunc
