; #FUNCTION# ====================================================================================================================
; Name ..........: getBSPos
; Description ...: Gets the postiion of of the Bluestacks window, attempts to open BS if not available, or closes MBR if it can not to avoid AutoIt internal error
; Syntax ........: getBSPos()
; Parameters ....:
; Return values .: None
; Author ........: Code Monkey #59
; Modified ......: KnowJack(july 2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func getBSPos()
	$aPos = ControlGetPos($Title, "", "[CLASS:BlueStacksApp; INSTANCE:1]")
	If @error Then
		SetError (0,0,0)
		OpenBS(True) ; Try to start BS if it is not running
		If @error = 1 Then
			_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 600)
			$stext = @CRLF & "MyBot has experienced a serious error" & @CRLF & @CRLF & _
					"Unable to find or start up BlueSatcks" & @CRLF & @CRLF & "Reboot PC and try again," & _
					"and search www.mybot.run forums for more help" & @CRLF
			$MsgBox = _ExtMsgBox(0, "Close MyBot!", "Okay - Must Exit Program", $stext, 0, $frmBot)
			If $MsgBox = 1 Then
				Exit
			EndIf
		EndIf
		$aPos = ControlGetPos($Title, "", "[CLASS:BlueStacksApp; INSTANCE:1]")
	EndIf
	$tPoint = DllStructCreate("int X;int Y")
	If @error <> 0 Then
		SetError (0,0,0)
		OpenBS(True) ; Try to start BS if it is not running
		Return
	Else
		DllStructSetData($tPoint, "X", $aPos[0])
		If @error <> 0 Then Return SetError (0,0,0)
    	DllStructSetData($tPoint, "Y", $aPos[1])
		If @error <> 0 Then Return SetError (0,0,0)
	    _WinAPI_ClientToScreen(WinGetHandle(WinGetTitle($Title)), $tPoint)
		If @error <> 0 Then Return SetError (0,0,0)
	    $BSpos[0] = DllStructGetData($tPoint, "X")
		If @error <> 0 Then Return SetError (0,0,0)
	    $BSpos[1] = DllStructGetData($tPoint, "Y")
		If @error <> 0 Then Return SetError (0,0,0)
	EndIf

EndFunc   ;==>getBSPos
