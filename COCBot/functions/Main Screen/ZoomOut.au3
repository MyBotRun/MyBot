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
Func ZoomOut() ;Zooms out
	Local $result0, $result1, $i = 0
	Local $Color_Diff_Top_Left, $Color_Diff_Top_Right ;for debug

	_CaptureRegion(0, 0, 860, 2)

	$Color_Diff_Top_Left = MaxColorDiff(_GetPixelColor($aTopLeftClient[0], $aTopLeftClient[1]), Hex($aTopLeftClient[2], 6)) ;for debug
	$Color_Diff_Top_Right = MaxColorDiff(_GetPixelColor($aTopRightClient[0], $aTopRightClient[1]), Hex($aTopRightClient[2], 6)) ;for debug

	If _CheckPixel($aTopLeftClient, $bNoCapturePixel) = False Or _
		_CheckPixel($aTopRightClient, $bNoCapturePixel) = False Then
		SetLog("Zooming Out", $COLOR_BLUE)
		If $debugSetlog = 1 Then SetLog("Color Diff: " & $Color_Diff_Top_Left & " , " & $Color_Diff_Top_Right,$COLOR_PURPLE) ;dor debug

		If _Sleep($iDelayZoomOut1) Then Return
		While _CheckPixel($aTopLeftClient, $bNoCapturePixel) = False Or _
			_CheckPixel($aTopRightClient, $bNoCapturePixel) = False ;changed and to or
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

			If $i > 80 Then
				$Color_Diff_Top_Left = MaxColorDiff(_GetPixelColor($aTopLeftClient[0], $aTopLeftClient[1]), Hex($aTopLeftClient[2], 6)) ;for debug
				$Color_Diff_Top_Right = MaxColorDiff(_GetPixelColor($aTopRightClient[0], $aTopRightClient[1]), Hex($aTopRightClient[2], 6)) ;for debug
				If $debugSetlog = 1 Then SetLog("Max Zoom Out! Color Diff: " & $Color_Diff_Top_Left & " , " & $Color_Diff_Top_Right,$COLOR_PURPLE) ;for debug
				Return
			EndIf

			If IsProblemAffect(True) Then  ; added to catch errors during Zoomout
				Setlog("BS Error window detected", $COLOR_RED)
				If checkObstacles() = True Then Setlog("Error window cleared, continue Zoom out", $COLOR_BLUE)  ; call to clear normal errors
			EndIf
			$i += 1  ; add one to index value to prevent endless loop if controlsend fails
			_CaptureRegion(0, 0, 860, 2)
		WEnd
	EndIf
EndFunc   ;==>ZoomOut

;function for debug
Func MaxColorDiff($nColor1, $nColor2)
	Local $Red1, $Red2, $Blue1, $Blue2, $Green1, $Green2, $MaxDiff

	$Red1 = Dec(StringMid(String($nColor1), 1, 2))
	$Blue1 = Dec(StringMid(String($nColor1), 3, 2))
	$Green1 = Dec(StringMid(String($nColor1), 5, 2))

	$Red2 = Dec(StringMid(String($nColor2), 1, 2))
	$Blue2 = Dec(StringMid(String($nColor2), 3, 2))
	$Green2 = Dec(StringMid(String($nColor2), 5, 2))

	$MaxDiff = Abs($Red1 - $Red2)
	if $MaxDiff < Abs($Blue1 - $Blue2) then $MaxDiff = Abs($Blue1 - $Blue2)
	if $MaxDiff < Abs($Green1 - $Green2) then $MaxDiff = Abs($Green1 - $Green2)

	Return $MaxDiff
EndFunc   ;==>_MaxColorDiff

;old if and loop
;if _GetPixelColor($aTopLeftClient[0], $aTopLeftClient[1]) <> Hex($aTopLeftClient[2], 6) Or _
;	_GetPixelColor($aTopMiddleClient[0], $aTopMiddleClient[1]) <> Hex($aTopMiddleClient[2], 6) Or _
;	_GetPixelColor($aTopRightClient[0], $aTopRightClient[1]) <> Hex($aTopRightClient[2], 6) 	Then

;While _GetPixelColor($aTopLeftClient[0], $aTopLeftClient[1]) <> Hex($aTopLeftClient[2], 6) And _
;			_GetPixelColor($aTopMiddleClient[0], $aTopMiddleClient[1]) <> Hex($aTopMiddleClient[2], 6) And _
;			_GetPixelColor($aTopRightClient[0], $aTopRightClient[1]) <> Hex($aTopRightClient[2], 6)
