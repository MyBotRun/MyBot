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
	Local $BSHandle, $BOTHandle
	;Local $BSsize = [ControlGetPos($HWnD, "_ctl.Window", "[CLASS:BlueStacksApp; INSTANCE:1]")[2], ControlGetPos($HWnD, "_ctl.Window", "[CLASS:BlueStacksApp; INSTANCE:1]")[3]]
	Local $BSPos = WinGetPos($HWnD)
	Local $BOTPos = WinGetPos($sBotTitle)
	;SetLog("BS: " & $Title & " - BOT: " &  $sBotTitle)
	If IsArray($BSPos) And IsArray($BOTPos) Then
		Local $BSx = $BSPos[0]
		Local $BSy = $BSPos[1]
		Local $BSw = $BSPos[2]
		Local $BSh = $BSPos[3]
		;Setlog($title & " position found:" & $BSx & "," & $BSy & " w:" & $BSw & " h:" & $BSh)
		Local $BOTx = $BOTPos[0]
		Local $BOTy = $BOTPos[1]
		Local $BOTw = $BOTPos[2]
		Local $BOTh = $BOTPos[3]
		;Setlog($sBotTitle & " position found:" & $BOTx & "," & $BOTy & " w:" & $BOTw & " h:" & $BOTh)
		;Setlog(Number( $BSx) & " " & Number($BSy ) )
		;SetLog(@DesktopWidth)
		If Number( $BSx) > -30000 and Number($BSy ) > -30000 Then
			Switch $position
				Case "BS-BOT" ; position left bs, right adjacent BOT
					$BSHandle = WinMove2($HWnD, "", 0 + Number($offsetX) , 0 + number($offsetY))
					If _Sleep($iDelayWindowsArrange1) Then Return
					$BOTHandle = WinMove2($sBotTitle, "", Number($BSw) + Number($offsetX)*2, 0 + number($offsetY))
					If _Sleep($iDelayWindowsArrange1) Then Return
				Case "BOT-BS" ; position left BOT, right adjacent BS
					$BOTHandle = WinMove2($sBotTitle, "", 0 + Number($offsetX) , 0 + number($offsetY))
					If _Sleep($iDelayWindowsArrange1) Then Return
					$BSHandle = WinMove2($HWnD, "", Number($BOTw) + Number($offsetX)*2, 0 + number($offsetY))
					If _Sleep($iDelayWindowsArrange1) Then Return
				Case "SNAP-TR" ; position BOT top right of BS, do not move BS
					If $BSx + $BSw + number($offsetX) < @DesktopWidth Then $BOTHandle = WinMove2($sBotTitle, "", $BSx + $BSw + Number($offsetX), $BSy )
					If _Sleep($iDelayWindowsArrange1) Then Return
				Case "SNAP-BR" ; position BOT botom right of BS, do not move BS
					If $BSx + $BSw + number($offsetY) < @DesktopWidth Then $BOTHandle = WinMove2($sBotTitle, "", $BSx + $BSw + Number($offsetX), $BSy + ( $BSh- $BOTh )  )
					If _Sleep(500) Then Return
				Case "SNAP-TL" ; position BOT top left of BS, do not move BS
					If $BSx  >=100 Then $BOTHandle = WinMove2($sBotTitle, "", $BSx - $BOTw - Number($offsetX), $BSy )
					If _Sleep($iDelayWindowsArrange1) Then Return
				Case "SNAP-BL" ; position BOT bottom left of BS, do not move BS
					If $BSx >= 100 Then $BOTHandle = WinMove2($sBotTitle, "", $BSx - $BOTw - Number($offsetX), $BSy + ( $BSh- $BOTh ) )
					If _Sleep($iDelayWindowsArrange1) Then Return
			EndSwitch
		EndIf
	EndIf


EndFunc   ;==>WindowsArrange

Func DisposeWindows()
   ;If $debugSetlog = 1 Then SetLog("Func DisposeWindows ", $COLOR_PURPLE)
		If $iDisposeWindows = 1 Then
			Switch $icmbDisposeWindowsPos
				Case 0
					WindowsArrange("BS-BOT",  $iWAOffsetX, $iWAOffsetY)
				Case 1
					WindowsArrange("BOT-BS",  $iWAOffsetX, $iWAOffsetY)
				Case 2
					WindowsArrange("SNAP-TR", $iWAOffsetX, $iWAOffsetY)
				Case 3
					WindowsArrange("SNAP-TL", $iWAOffsetX, $iWAOffsetY)
				Case 4
					WindowsArrange("SNAP-BR", $iWAOffsetX, $iWAOffsetY)
				Case 5
					WindowsArrange("SNAP-BL", $iWAOffsetX, $iWAOffsetY)
			EndSwitch
		Else
			If $bMonitorHeight800orBelow Then
				WindowsArrange("BS-BOT", 10, 0)
			EndIf
		EndIf
EndFunc

; WinMove2 resizes Window without triggering a change event in target process.
; Replacement for WinMove ( "title", "text", x, y [, width [, height [, speed]]] )
; Parameter [, speed] is not supported!
Func WinMove2($WinTitle, $WinText, $x = -1, $y = -1, $w = -1, $h = -1, $s = 0)
   If $s <> 0 And $debugSetlog = 1 Then SetLog("WinMove2(" & $WinTitle & "," & $WinText & "," & $x & "," & $y & "," & $w & "," & $h & "," & $s & "): speed parameter '" & $s & "' is not supported!", $COLOR_RED);
   Local $hWnd = WinGetHandle($WinTitle, $WinText)
   Local $aPos = WinGetPos($hWnd)

   If @error <> 0 Or Not IsArray($aPos) Then
	  SetError(1, @extended, -1)
	  Return 0
   EndIF
   If $x = -1 Or $y = -1 Or $w = -1 Or $h = -1 Then
	  If $x = -1 Then $x = $aPos[0]
	  If $y = -1 Then $y = $aPos[1]
	  If $w = -1 Then $w = $aPos[2]
	  If $h = -1 Then $h = $aPos[3]
   EndIf

   Local $NoMove = $x = $aPos[0] And $y = $aPos[1]
   Local $NoResize = $w = $aPos[2] And $h = $aPos[3]

   ;If $debugSetlog = 1 Then SetLog("Window " & $WinTitle & "(" & $hWnd & "): " & ($NoResize ? "no resize" : "resize to " & $w & " x " & $h) & ($NoMove ? ", no move" : ", move to " & $x & "," & $y), $COLOR_BLUE);
   _WinAPI_SetWindowPos($hWnd, 0, $x, $y, $w, $h, BitOr(($NoMove ? BitOr($SWP_NOMOVE, $SWP_NOREPOSITION) : 0), $SWP_NOACTIVATE, $SWP_NOSENDCHANGING, $SWP_NOZORDER)) ; resize window without sending changing message to window

   ; check width and height if it got changed...
   $aPos = WinGetPos($hWnd)
   If @error <> 0 Or Not IsArray($aPos) Then
	  SetError(1, @extended, -1)
	  Return 0
   EndIf
   If $w <> $aPos[2] or $h <>$aPos[3] Then
	  If $debugSetlog = 1 Then SetLog("Window " & $WinTitle & "(" & $hWnd & ") got resized again to " & $aPos[2] & " x " & $aPos[3] & ", restore now " & $w & " x " & $y, $COLOR_ORANGE);
	  _WinAPI_SetWindowPos($hWnd, 0, $x, $y, $w, $h, BitOr($SWP_NOMOVE, $SWP_NOREPOSITION, $SWP_NOACTIVATE, $SWP_NOSENDCHANGING, $SWP_NOZORDER)) ; resize window without sending changing message to window
   EndIf

   Return $hWnd
EndFunc