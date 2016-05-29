
; #FUNCTION# ====================================================================================================================
; Name ..........: MoveMouseOutBS() & _WindowFromPoint($iX,$iY)
; Description ...: Moves Mouse out of BS if it is inside of BS window
; Author ........: The Master (2015)
; Modified ......:
; Remarks .......: This file is part of MyBot Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......:
; ===============================================================================================================================

Func MoveMouseOutBS()
	If $iMoveMouseOutBS = 0 Then Return
	Local $hWindow, $txtTitleW, $hControl, $aMousePos
	$aMousePos = MouseGetPos()
	If IsArray($aMousePos) Then
		$hControl = _WindowFromPoint($aMousePos[0], $aMousePos[1])
		If $hControl <> 0 Then
			; Since _WindowFromPoint() can return 'sub' windows, or control handles, we should seek the owner window
			$hWindow = _WinAPI_GetAncestor($hControl, 2)
			$txtTitleW = WinGetTitle($hWindow)
			If $hWindow = $HWnD And $txtTitleW == $Title Then
				MouseMove(@DesktopWidth + 100, Round(@DesktopHeight / 2), 0)
				SetLog("Keep Your Mouse Out of BlueStacks Window while bot is running", $COLOR_RED)
			EndIf
		EndIf
	EndIf
EndFunc   ;==>MoveMouseOutBS

Func _WindowFromPoint($iX, $iY)
	Local $stInt64, $aRet, $stPoint = DllStructCreate("long;long")
	DllStructSetData($stPoint, 1, $iX)
	DllStructSetData($stPoint, 2, $iY)
	$stInt64 = DllStructCreate("int64", DllStructGetPtr($stPoint))
	$aRet = DllCall("user32.dll", "hwnd", "WindowFromPoint", "int64", DllStructGetData($stInt64, 1))
	If @error Then Return SetError(0, 0, 0)
	If $aRet[0] = 0 Then Return SetError(0, 0, 0)
	Return $aRet[0]
EndFunc   ;==>_WindowFromPoint


