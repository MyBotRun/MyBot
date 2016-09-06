; #FUNCTION# ====================================================================================================================
; Name ..........: Windows Arrange
; Description ...: This function dispose the bot and bs adjacent
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Sardo (2015-06) (2015-09)
; Modified ......:
;
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func WindowsArrange($position, $offsetX = 0, $offsetY = 0)
	WinGetAndroidHandle()
	Local $AndroidPos = WinGetPos($HWnD)
	Local $BotPos = WinGetPos($frmBot)
	If IsArray($AndroidPos) And IsArray($BotPos) Then
		Local $hTimer = TimerInit()
		WinSetState($HWnD, "", @SW_RESTORE)
		While IsArray($AndroidPos) And TimerDiff($hTimer) < 3000 And $AndroidPos[0] < -30000 And $AndroidPos[1] < -30000
			$AndroidPos = WinGetPos($HWnD)
			If _Sleep($iDelaySleep) Then Return False
		WEnd
		Local $AndroidX = $AndroidPos[0]
		Local $AndroidY = $AndroidPos[1]
		Local $AndroidW = $AndroidPos[2]
		Local $AndroidH = $AndroidPos[3]
		Local $BotX = $BotPos[0]
		Local $BotY = $BotPos[1]
		Local $BotW = $BotPos[2]
		Local $BotH = $BotPos[3]
		If Number($AndroidX) > -30000 And Number($AndroidY) > -30000 Then
			Local $bAdjusted = False

			If $position = "EMBED" Then

				AndroidEmbed(True)
				If Not ($offsetX == "" Or $offsetY == "") Then
					$bAdjusted = $BotX <> $offsetX Or $BotY <> $offsetY
					If $bAdjusted = True Then WinMove2($frmBot, "", $offsetX, $offsetY)
				EndIf

			Else
				If $AndroidEmbedded = True Then
					; not supported!
					Return
				EndIf
				Local $x = $offsetX
				Local $y = $offsetY
				Switch $position
					Case "BS-BOT" ; position left Android, right adjacent BOT
						If $offsetX == "" Then
							$x = $AndroidX
							$offsetX = 0
						EndIf
						If $offsetY == "" Then
							$y = $AndroidY
							$offsetY = 0
						EndIf
						$bAdjusted = $AndroidX <> $x Or $AndroidY <> $y
						If $bAdjusted Then
							WinMove2($HWnD, "", $x, $y)
							_Sleep($iDelayWindowsArrange1, True, False)
						EndIf
						$bAdjusted = $bAdjusted = True Or $BotX <> $AndroidW + $offsetX * 2 Or $BotY <> $y
						If $bAdjusted Then WinMove2($frmBot, "", $x + $AndroidW + $offsetX, $y)
					Case "BOT-BS" ; position left BOT, right adjacent Android
						If $offsetX == "" Then
							$x = $BotX
							$offsetX = 0
						EndIf
						If $offsetY == "" Then
							$y = $BotY
							$offsetY = 0
						EndIf
						$bAdjusted = $BotX <> $x Or $BotY <> $y
						If $bAdjusted Then
							WinMove2($frmBot, "", $x, $y)
							_Sleep($iDelayWindowsArrange1, True, False)
						EndIf
						$bAdjusted = $bAdjusted Or $AndroidX <> $x + $BotW + $offsetX Or $AndroidY <> $y
						If $bAdjusted Then WinMove2($HWnD, "", $x + $BotW + $offsetX, $y)
					Case "SNAP-TR" ; position BOT top right of Android, do not move Android
						If $offsetX == "" Then $offsetX = 0
						If $offsetY == "" Then $offsetY = 0
						$bAdjusted = $BotX <> $AndroidX + $AndroidW + $offsetX Or $BotY <> $AndroidY + $offsetY
						If $bAdjusted Then WinMove2($frmBot, "", $AndroidX + $AndroidW + $offsetX, $AndroidY + $offsetY)
					Case "SNAP-BR" ; position BOT botom right of BS, do not move Android
						If $offsetX == "" Then $offsetX = 0
						If $offsetY == "" Then $offsetY = 0
						$bAdjusted = $AndroidX <> $AndroidX + $AndroidW + $offsetX Or $AndroidY <> $AndroidY + ($AndroidH - $BotH) + $offsetY
						If $bAdjusted Then WinMove2($frmBot, "", $AndroidX + $AndroidW + $offsetX, $AndroidY + ($AndroidH - $BotH) + $offsetY)
					Case "SNAP-TL" ; position BOT top left of Android, do not move Android
						If $offsetX == "" Then $offsetX = 0
						If $offsetY == "" Then $offsetY = 0
						$bAdjusted = $BotX <> $AndroidX - $BotW - $offsetX Or $BotY <> $AndroidY + $offsetY
						If $bAdjusted Then WinMove2($frmBot, "", $AndroidX - $BotW - $offsetX, $AndroidY + $offsetY)
					Case "SNAP-BL" ; position BOT bottom left of Android, do not move Android
						If $offsetX == "" Then $offsetX = 0
						If $offsetY == "" Then $offsetY = 0
						$bAdjusted = $BotX <> $AndroidX - $BotW - $offsetX Or $BotY <> $AndroidY + ($AndroidH - $BotH) + $offsetY
						If $bAdjusted Then WinMove2($frmBot, "", $AndroidX - $BotW - $offsetX, $AndroidY + ($AndroidH - $BotH) + $offsetY)
				EndSwitch
			EndIf
			If $bAdjusted = True Then
				SetDebugLog("WindowsArrange: " & $position & ", offsetX=" & $offsetX & ", offsetY=" & $offsetY & ", X=" & $x & ", Y=" & $y)
				_Sleep($iDelayWindowsArrange1, True, False)
			EndIf
		EndIf
	EndIf

EndFunc   ;==>WindowsArrange

Func DisposeWindows()
	updateBtnEmbed()
	If $iDisposeWindows = 1 Then
		Switch $icmbDisposeWindowsPos
			Case 0
				WindowsArrange("BS-BOT", $iWAOffsetX, $iWAOffsetY)
			Case 1
				WindowsArrange("BOT-BS", $iWAOffsetX, $iWAOffsetY)
			Case 2
				WindowsArrange("SNAP-TR", $iWAOffsetX, $iWAOffsetY)
			Case 3
				WindowsArrange("SNAP-TL", $iWAOffsetX, $iWAOffsetY)
			Case 4
				WindowsArrange("SNAP-BR", $iWAOffsetX, $iWAOffsetY)
			Case 5
				WindowsArrange("SNAP-BL", $iWAOffsetX, $iWAOffsetY)
			Case 6
				WindowsArrange("EMBED", $iWAOffsetX, $iWAOffsetY)
		EndSwitch
	EndIf
EndFunc   ;==>DisposeWindows

; WinMove2 resizes Window without triggering a change event in target process.
; Replacement for WinMove ( "title", "text", x, y [, width [, height [, speed]]] )
; Parameter [, speed] is not supported and is actually $hAfter!
Func WinMove2($WinTitle, $WinText, $x = -1, $y = -1, $w = -1, $h = -1, $hAfter = 0, $iFlags = 0, $bCheckAfterPos = True)
	;If $s <> 0 And $debugSetlog = 1 Then SetLog("WinMove2(" & $WinTitle & "," & $WinText & "," & $x & "," & $y & "," & $w & "," & $h & "," & $s & "): speed parameter '" & $s & "' is not supported!", $COLOR_RED);
	Local $hWin = WinGetHandle($WinTitle, $WinText)

	If _WinAPI_IsIconic($hWin) Then
		; Window minimized, restore first
		SetDebugLog("Window " & $WinTitle & (($WinTitle <> $hWin) ? "(" & $hWin & ")" : "") & " restored", $COLOR_ORANGE)
		WinSetState($hWin, "", @SW_RESTORE)
	EndIf

	Local $aPos = WinGetPos($hWin)

	If @error <> 0 Or Not IsArray($aPos) Then
		SetError(1, @extended, -1)
		Return 0
	EndIf
	Local $aPPos = WinGetClientPos(_WinAPI_GetParent($hWin))
	If IsArray($aPPos) Then
		; convert to relative
		$aPos[0] -= $aPPos[0]
		$aPos[1] -= $aPPos[1]
	EndIf

	Local $NoMove = $x = -1 And $y = -1
	Local $NoResize = $w = -1 And $h = -1
	Local $NOZORDER = ($hAfter = 0 ? $SWP_NOZORDER : 0)
	If $x = -1 Or $y = -1 Or $w = -1 Or $h = -1 Then
		If $x = -1 Then $x = $aPos[0]
		If $y = -1 Then $y = $aPos[1]
		If $w = -1 Then $w = $aPos[2]
		If $h = -1 Then $h = $aPos[3]
	EndIf
	$NoMove = $NoMove Or ($x = $aPos[0] And $y = $aPos[1])
	$NoResize = $NoResize Or ($w = $aPos[2] And $h = $aPos[3])

	;If $debugSetlog = 1 Then SetLog("Window " & $WinTitle & "(" & $hWin & "): " & ($NoResize ? "no resize" : "resize to " & $w & " x " & $h) & ($NoMove ? ", no move" : ", move to " & $x & "," & $y), $COLOR_BLUE);
	_WinAPI_SetWindowPos($hWin, $hAfter, $x, $y, $w, $h, BitOR(($NoMove ? BitOR($SWP_NOMOVE, $SWP_NOREPOSITION) : 0), $SWP_NOACTIVATE, $SWP_NOSENDCHANGING, $NOZORDER, $iFlags)) ; resize window without sending changing message to window

	; check width and height if it got changed...
	If $bCheckAfterPos Then
		$aPos = WinGetPos($hWin)
		If @error <> 0 Or Not IsArray($aPos) Then
			SetError(1, @extended, -1)
			Return 0
		EndIf
		Local $aPPos = WinGetClientPos(_WinAPI_GetParent($hWin))
		If IsArray($aPPos) Then
			; convert to relative
			$aPos[0] -= $aPPos[0]
			$aPos[1] -= $aPPos[1]
		EndIf
		If $x <> $aPos[0] Or $y <> $aPos[1] Or $w <> $aPos[2] Or $h <> $aPos[3] Then
			SetDebugLog("Window " & $WinTitle & (($WinTitle <> $hWin) ? "(" & $hWin & ")" : "") & " got resized/moved again to " & $aPos[0] & "/" & $aPos[1] & " " & $aPos[2] & "x" & $aPos[3] & ", restore now " & $x & "/" & $y & " " & $w & "x" & $h, $COLOR_ORANGE)
			WinMove($hWin, "", $x, $y, $w, $h - 1) ; resize window WITH sending changing message to window
			_WinAPI_SetWindowPos($hWin, $hAfter, $x, $y, $w, $h, BitOR($SWP_NOMOVE, $SWP_NOREPOSITION, $SWP_NOACTIVATE, $SWP_NOSENDCHANGING, $NOZORDER, $iFlags)) ; resize window without sending changing message to window
		EndIf
	EndIf

	Return $hWin
EndFunc   ;==>WinMove2

Func WinGetClientPos($hWin, $x = 0, $y = 0)
	Local $tPoint = DllStructCreate("int x;int y")
	DllStructSetData($tPoint, "x", $x)
	DllStructSetData($tPoint, "y", $y)
	_WinAPI_ClientToScreen($hWin, $tPoint)
	If @error Then Return SetError(1, 0, 0)
	Local $a[2] = [DllStructGetData($tPoint, "x"), DllStructGetData($tPoint, "y")]
	Return $a
EndFunc   ;==>WinGetClientPos

Func WinGetPos2($title, $text = "")
	Local $aPos = 0
	If IsHWnd($title) = 0 Then $title = WinGetHandle($title, $text)
	While IsHWnd($title) And (IsArray($aPos) = 0 Or $aPos[2] < 200)
		If _WinAPI_IsIconic($title) Then WinSetState($title, "", @SW_RESTORE)
		If _WinAPI_IsIconic($title) = False Then $aPos = WinGetPos($title)
	WEnd
	Return $aPos
EndFunc   ;==>WinGetPos2

Func ControlGetPos2($title, $text, $controlID)
	Local $aPos = 0
	If IsHWnd($title) = 0 Then $title = WinGetHandle($title, $text)
	While IsHWnd($title) And (IsArray($aPos) = 0 Or $aPos[2] < 200)
		If _WinAPI_IsIconic($title) Then WinSetState($title, "", @SW_RESTORE)
		If _WinAPI_IsIconic($title) = False Then $aPos = ControlGetPos($title, $text, $controlID)
	WEnd
	Return $aPos
EndFunc   ;==>ControlGetPos2
