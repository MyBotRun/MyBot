; #FUNCTION# ====================================================================================================================
; Name ..........: ZoomOut
; Description ...: Tries to zoom out of the screen until the borders, located at the top of the game (usually black), is located.
; Syntax ........: ZoomOut()
; Parameters ....:
; Return values .: None
; Author ........: Code Gorilla #94
; Modified ......: KnowJack (July 2015) stop endless loop
; Remarks .......: This file is part of ClashGameBot. Copyright 2015
;                  ClashGameBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func ZoomOut() ;Zooms out
	Local $result0, $result1, $i = 0
	_CaptureRegion(0, 0, 860, 2)
	If _GetPixelColor($aTopLeftClient[0], $aTopLeftClient[1]) <> Hex($aTopLeftClient[2], 6) Or _
	_GetPixelColor($aTopMiddleClient[0], $aTopMiddleClient[1]) <> Hex($aTopMiddleClient[2], 6) Or _
	_GetPixelColor($aTopRightClient[0], $aTopRightClient[1]) <> Hex($aTopRightClient[2], 6) 	Then
		SetLog("Zooming Out", $COLOR_BLUE)
		If _Sleep($iDelayZoomOut1) Then Return
		While _GetPixelColor($aTopLeftClient[0], $aTopLeftClient[1]) <> Hex($aTopLeftClient[2], 6) And _
			_GetPixelColor($aTopMiddleClient[0], $aTopMiddleClient[1]) <> Hex($aTopMiddleClient[2], 6) And _
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
			_CaptureRegion(0, 0, 860, 2)
		WEnd
	EndIf
EndFunc   ;==>ZoomOut
