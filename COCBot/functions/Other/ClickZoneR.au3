; #FUNCTION# ====================================================================================================================
; Name ..........:
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .: None
; Author ........: Boju(2016
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: checkMainscreen, isProblemAffect
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $g_aiTempBot[4] = [1, 10, 20, 0]

Func ClickZone ($x, $y, $Offset = 7, $debugtxt = "", $times = 1, $speed = 0, $OutScreen = (680 + $g_iBottomOffsetY), $scale = 3, $density = 1, $centerX = 0, $centerY = 0)
	Local $BasY
	If $y-$Offset > $OutScreen Then
		$BasY = $y
	Else
		$BasY = $y-$Offset
	EndIf
	Dim $g_aiTempBot[4] = [$x-$Offset, $BasY, $x+$Offset, $y+$Offset]
	If $g_bDebugClick Then
		Local $txt = _DecodeDebug($debugtxt)
		SetLog("ClickZone " & $x & "," & $y & "," & $times & "," & $speed & " " & $debugtxt & $txt, $COLOR_ACTION, "Verdana", "7.5", 0)
	EndIf
	ClickR($g_aiTempBot,$x, $y, $times, $speed, $OutScreen, $scale, $density, $centerX, $centerY)
EndFunc

Func ClickR($boundingBox, $x, $y, $times = 1, $speed = 0, $OutScreen = (680 + $g_iBottomOffsetY), $scale = 3, $density = 1, $centerX = 0, $centerY = 0)
	Local $AncVal = " ValIn: X=" & $x & " Y=" & $y
	Local Const $PI = 3.141592653589793
	Local $boxWidth = $boundingBox[2] - $boundingBox[0]
	Local $boxHeight = $boundingBox[3] - $boundingBox[1]
	Local $boxCenterX = $boundingBox[0] + $boxWidth/2 + $centerX
	Local $boxCenterY = $boundingBox[1] + $boxHeight/2 + $centerY
	Local $loopStartTime = __TimerInit()
	Do
		Local $angle = Random() * 2 *$PI
		Local $xR = Random()
		If $xR = 0 Then $xR = 0.000001
			Local $distance = $scale * (($xR ^ (-1.0/$density)) - 1)
			Local $offsetX = $distance * Sin($angle)
			Local $offsetY = $distance * Cos($angle)
			$x = $boxCenterX + $boxWidth * $offsetX/4
			$y = $boxCenterY + $boxHeight * $offsetY/4
			If __TimerDiff($loopStartTime)>5000 Then
			$x = $boxCenterX
			$y = $boxCenterY
			ExitLoop
		EndIf
	Until $x >= $boundingBox[0] And $x <= $boundingBox[2] And _
	$y >= $boundingBox[1] And $y <= $boundingBox[3]
	If $y > $OutScreen Then
		$y = $OutScreen
	Else
		$y = $y
	EndIf
	$x = Round($x, 3)
	$y = Round($y, 3)
	If $times <> 1 Then
		For $i = 0 To ($times - 1)
			If $g_bDebugClick Then SetLog("_ControlClick " & "X=" & $x & " Y=" & $y & " ,t" & $times & ",s" & $speed & $AncVal, $COLOR_ACTION, "Verdana", "7.5", 0)
			Click($x, $y)
			If _Sleep($speed, False) Then ExitLoop
		Next
	Else
		If $g_bDebugClick Then SetLog("_ControlClick " & "X=" & $x & " Y=" & $y & $AncVal, $COLOR_ACTION, "Verdana", "7.5", 0)
		Click($x, $y)
	EndIf
EndFunc   ;==>ClickR

Func PureClickR($boundingBox, $x, $y, $times = 1, $speed = 0, $OutScreen = (680 + $g_iBottomOffsetY), $scale = 3, $density = 1, $centerX = 0, $centerY = 0)
	Local $AncVal = " ValIn: X=" & $x & " Y=" & $y
	Local Const $PI = 3.141592653589793
	Local $boxWidth = $boundingBox[2] - $boundingBox[0]
	Local $boxHeight = $boundingBox[3] - $boundingBox[1]
	Local $boxCenterX = $boundingBox[0] + $boxWidth/2 + $centerX
	Local $boxCenterY = $boundingBox[1] + $boxHeight/2 + $centerY
	Local $loopStartTime = __TimerInit()
	Do
		Local $angle = Random() * 2 *$PI
		Local $xR = Random()
		If $xR = 0 Then $xR = 0.000001
			Local $distance = $scale * (($xR ^ (-1.0/$density)) - 1)
			Local $offsetX = $distance * Sin($angle)
			Local $offsetY = $distance * Cos($angle)
			$x = $boxCenterX + $boxWidth * $offsetX/4
			$y = $boxCenterY + $boxHeight * $offsetY/4
			If __TimerDiff($loopStartTime)>5000 Then
			$x = $boxCenterX
			$y = $boxCenterY
			ExitLoop
		EndIf
	Until $x >= $boundingBox[0] And $x <= $boundingBox[2] And _
	$y >= $boundingBox[1] And $y <= $boundingBox[3]
	If $y > $OutScreen Then
		$y = $OutScreen
	Else
		$y = $y
	EndIf
	$x = Round($x, 3)
	$y = Round($y, 3)
	If $times <> 1 Then
		For $i = 0 To ($times - 1)
			If $g_bDebugClick Then SetLog("PureClick " & "X=" & $x & " Y=" & $y & " ,t" & $times & ",s" & $speed & $AncVal, $COLOR_ACTION, "Verdana", "7.5", 0)
			PureClick($x, $y)
			If _Sleep($speed, False) Then ExitLoop
		Next
	Else
		If $g_bDebugClick Then SetLog("PureClick " & "X=" & $x & " Y=" & $y & $AncVal, $COLOR_ACTION, "Verdana", "7.5", 0)
		PureClick($x, $y)
	EndIf
EndFunc   ;==>ClickR

Func GemClickR($boundingBox,$x, $y, $times = 1, $speed = 0, $debugtxt = "", $OutScreen = (680 + $g_iBottomOffsetY), $scale = 3, $density = 1, $centerX = 0, $centerY = 0)
	Local $AncVal = " ValIn: X=" & $x & " Y=" & $y
	Local Const $PI = 3.141592653589793
	Local $boxWidth = $boundingBox[2] - $boundingBox[0]
	Local $boxHeight = $boundingBox[3] - $boundingBox[1]
	Local $boxCenterX = $boundingBox[0] + $boxWidth/2 + $centerX
	Local $boxCenterY = $boundingBox[1] + $boxHeight/2 + $centerY
	Local $loopStartTime = __TimerInit()
	Do
		Local $angle = Random() * 2 *$PI
		Local $xR = Random()
		If $xR = 0 Then $xR = 0.000001
			Local $distance = $scale * (($xR ^ (-1.0/$density)) - 1)
			Local $offsetX = $distance * Sin($angle)
			Local $offsetY = $distance * Cos($angle)
			$x = $boxCenterX + $boxWidth * $offsetX/4
			$y = $boxCenterY + $boxHeight * $offsetY/4
			If __TimerDiff($loopStartTime)>5000 Then
			$x = $boxCenterX
			$y = $boxCenterY
			ExitLoop
		EndIf
	Until $x >= $boundingBox[0] And $x <= $boundingBox[2] And _
	$y >= $boundingBox[1] And $y <= $boundingBox[3]
	If $y > $OutScreen Then
		$y = $OutScreen
	Else
		$y = $y
	EndIf
	$x = Round($x, 3)
	$y = Round($y, 3)

	If $g_bDebugClick Then
		Local $txt = _DecodeDebug($debugtxt)
		SetLog("GemClickR " & $x & "," & $y & "," & $times & "," & $speed & " " & $debugtxt & $txt, $COLOR_ACTION, "Verdana", "7.5", 0)
	EndIf

    If $g_bAndroidAdbClick = True Then
	   If isGemOpen(True) Then
		  Return False
	   EndIf
	   AndroidClick($x, $y, $times, $speed)
	EndIf
	If $g_bAndroidAdbClick = True Then
	   Return
    EndIf

    Local $SuspendMode = ResumeAndroid()
	Local $i
	If $times <> 1 Then
		For $i = 0 To ($times - 1)
			If isGemOpen(True) Then
			   SuspendAndroid($SuspendMode)
			   Return False
			EndIf
			If isProblemAffectBeforeClick($i) Then
				If $g_bDebugClick Then SetLog("VOIDED GemClickR " & $x & "," & $y & "," & $times & "," & $speed & " " & $debugtxt & $txt, $COLOR_ERROR, "Verdana", "7.5", 0)
				checkMainScreen(False)
				SuspendAndroid($SuspendMode)
				Return  ; if need to clear screen do not click
			EndIf
			MoveMouseOutBS()
			_ControlClick($x, $y)
			If isGemOpen(True) Then
			   SuspendAndroid($SuspendMode)
			   Return False
			EndIf
			If _Sleep($speed, False) Then ExitLoop
		Next
	Else
		If isGemOpen(True) Then
			SuspendAndroid($SuspendMode)
			Return False
		EndIf
		If isProblemAffectBeforeClick() Then
			If $g_bDebugClick Then SetLog("VOIDED GemClickR " & $x & "," & $y & "," & $times & "," & $speed & " " & $debugtxt & $txt, $COLOR_ERROR, "Verdana", "7.5", 0)
			checkMainScreen(False)
			SuspendAndroid($SuspendMode)
			Return  ; if need to clear screen do not click
		EndIf
		MoveMouseOutBS()
		_ControlClick($x, $y)
		If isGemOpen(True) Then
		   SuspendAndroid($SuspendMode)
		   Return False
	    EndIf
	EndIf
	SuspendAndroid($SuspendMode)
EndFunc   ;==>GemClickR