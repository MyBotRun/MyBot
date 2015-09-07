; #FUNCTION# ====================================================================================================================
; Name ..........: getBSPos
; Description ...: Gets the postiion of of the Bluestacks window, attempts to open BS if not available, or closes CGB if it can not to avoid AutoIt internal error
; Syntax ........: getBSPos()
; Parameters ....:
; Return values .: None
; Author ........: Code Monkey #59
; Modified ......: KnowJack(july 2015)
; Remarks .......: This file is part of ClashGameBot. Copyright 2015
;                  ClashGameBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func getBSPos()
	$aPos = ControlGetPos($Title, "", "[CLASS:BlueStacksApp; INSTANCE:1]")
	If @error Then
		OpenBS(True) ; Try to start BS if it is not running
		If @error = 1 Then
			_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 600)
			$stext = @CRLF & "Clash Game Bot has experienced a serious error" & @CRLF & @CRLF & _
					"Unable to find or start up BlueSatcks" & @CRLF & @CRLF & "Reboot PC and try again," & _
					"and search www.gamebot.org forums for more help" & @CRLF
			$MsgBox = _ExtMsgBox(0, "Close ClashGameBot!", "Okay - Must Exit Program", $stext, 15, $frmBot)
			If $MsgBox = 1 Then
				Exit
			EndIf
		EndIf
		$aPos = ControlGetPos($Title, "", "[CLASS:BlueStacksApp; INSTANCE:1]")
	EndIf
	$tPoint = DllStructCreate("int X;int Y")
	DllStructSetData($tPoint, "X", $aPos[0])
	DllStructSetData($tPoint, "Y", $aPos[1])
	_WinAPI_ClientToScreen(WinGetHandle(WinGetTitle($Title)), $tPoint)

	$BSpos[0] = DllStructGetData($tPoint, "X")
	$BSpos[1] = DllStructGetData($tPoint, "Y")
EndFunc   ;==>getBSPos
