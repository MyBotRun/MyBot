;=================================================================================================
; Function:			_PostMessage_ClickDrag($hWnd, $X1, $Y1, $X2, $Y2, $Button = "left")
; Description:		Sends a mouse click and drag command to a specified window.
; Parameter(s):		$hWnd - The handle or the title of the window.
;					$X1, $Y1 - The x/y position to start the drag operation from.
;					$X2, $Y2 - The x/y position to end the drag operation at.
;					$Button - (optional) The button to click, "left", "right", "middle". Default is the left button.
;					$Delay - (optional) Delay in milliseconds. Default is 50.
; Requirement(s):	A window handle/title.
; Return Value(s):	On Success - Returns true
;					On Failure - Returns false
;					@Error - 0 = No error.
;							 1 = Invalid window handle or title.
;							 2 = Invalid start position.
;							 3 = Invalid end position.
;							 4 = Failed to open the dll.
;							 5 = Failed to send a MouseDown command.
;							 5 = Failed to send a MouseMove command.
;							 7 = Failed to send a MouseUp command.
; Author(s):		KillerDeluxe
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
;=================================================================================================
Func _PostMessage_ClickDrag($X1, $Y1, $X2, $Y2, $Button = "left", $Delay = 50)

	; adjust coordinates based on Android control offset
    $X1 = Int($X1) + $BSrpos[0]
	$Y1 = Int($Y1) + $BSrpos[1]
    $X2 = Int($X2) + $BSrpos[0]
	$Y2 = Int($Y2) + $BSrpos[1]

	WinGetAndroidHandle()

	If Not IsHWnd($HWnD) Then
		Return SetError(1, "", False)
	EndIf

	If StringLower($Button) == "left" Then
		$Button = $WM_LBUTTONDOWN
		$Pressed = 1
	ElseIf StringLower($Button) == "right" Then
		$Button = $WM_RBUTTONDOWN
		$Pressed = 2
	ElseIf StringLower($Button) == "middle" Then
		$Button = $WM_MBUTTONDOWN
		$Pressed = 10
		If $Delay == 10 Then $Delay = 100
	EndIf

	$User32 = DllOpen("User32.dll")
	If @error Then Return SetError(4, "", False)

	MoveMouseOutBS()

	DllCall($User32, "bool", "PostMessage", "hwnd", $HWnD, "int", $Button, "int", "0", "long", _MakeLong($X1, $Y1))
	If @error Then
		DllClose($User32)
		Return SetError(5, "", False)
	EndIf

	If _Sleep($Delay / 2) Then Return SetError(-1, "", False)

	DllCall($User32, "bool", "PostMessage", "hwnd", $HWnD, "int", $WM_MOUSEMOVE, "int", $Pressed, "long", _MakeLong($X2, $Y2))
	If @error Then
		DllClose($User32)
		Return SetError(6, "", False)
	EndIf

	If _Sleep($Delay / 2) Then Return SetError(-1, "", False)

	DllCall($User32, "bool", "PostMessage", "hwnd", $HWnD, "int", $Button + 1, "int", "0", "long", _MakeLong($X2, $Y2))
	If @error Then
		DllClose($User32)
		Return SetError(7, "", False)
	EndIf

	DllClose($User32)
	Return SetError(0, 0, True)
EndFunc   ;==>_PostMessage_ClickDrag

Func _MakeLong($LowWORD, $HiWORD)
	Return BitOR($HiWORD * 0x10000, BitAND($LowWORD, 0xFFFF))
EndFunc   ;==>_MakeLong

Func ClickDrag($X1, $Y1, $X2, $Y2, $Delay = 50)
	;Return _PostMessage_ClickDrag($X1, $Y1, $X2, $Y2, "left", $Delay)
	Local $error = 0
	If $AndroidAdbClickDrag = True Then
		;AndroidSwipe($X1, $Y1, $X2, $Y2, $RunState)
		AndroidClickDrag($X1, $Y1, $X2, $Y2, $RunState)
		$error = @error
		If _Sleep($Delay / 5) Then Return SetError(-1, "", False)
	EndIf
	If $AndroidAdbClickDrag = False Or $error <> 0 Then
		Return _PostMessage_ClickDrag($X1, $Y1, $X2, $Y2, "left", $Delay)
	EndIf
	Return SetError(0, 0, ($error = 0 ? True : False))
EndFunc   ;==>ClickDrag


