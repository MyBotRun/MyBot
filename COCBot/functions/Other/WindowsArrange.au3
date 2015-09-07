; #FUNCTION# ====================================================================================================================
; Name ..........: Windows Arrange
; Description ...: This function dispose the bot and bs adjacent
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Sardo (2015-06)
; Modified ......:
;
; Remarks .......: This file is part of ClashGameBot. Copyright 2015
;                  ClashGameBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================

Func WindowsArrange($position, $offsetX = 0, $offsetY = 0)
	Local $BSHandle, $BOTHandle
	;Local $BSsize = [ControlGetPos($Title, "_ctl.Window", "[CLASS:BlueStacksApp; INSTANCE:1]")[2], ControlGetPos($Title, "_ctl.Window", "[CLASS:BlueStacksApp; INSTANCE:1]")[3]]
	Local $BSPos = WinGetPos($Title)
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
					$BSHandle = WinMove($Title, "", 0 + Number($offsetX) , 0 + number($offsetY))
					If _Sleep($iDelayWindowsArrange1) Then Return
					$BOTHandle = WinMove($sBotTitle, "", Number($BSw) + Number($offsetX)*2, 0 + number($offsetY))
					If _Sleep($iDelayWindowsArrange1) Then Return
				Case "BOT-BS" ; position left BOT, right adjacent BS
					$BOTHandle = WinMove($sBotTitle, "", 0 + Number($offsetX) , 0 + number($offsetY))
					If _Sleep($iDelayWindowsArrange1) Then Return
					$BSHandle = WinMove($Title, "", Number($BOTw) + Number($offsetX)*2, 0 + number($offsetY))
					If _Sleep($iDelayWindowsArrange1) Then Return
				Case "SNAP-TR" ; position BOT top right of BS, do not move BS
					If $BSx + $BSw + number($offsetX) < @DesktopWidth Then $BOTHandle = WinMove($sBotTitle, "", $BSx + $BSw + Number($offsetX), $BSy )
					If _Sleep($iDelayWindowsArrange1) Then Return
				Case "SNAP-BR" ; position BOT botom right of BS, do not move BS
					If $BSx + $BSw + number($offsetY) < @DesktopWidth Then $BOTHandle = WinMove($sBotTitle, "", $BSx + $BSw + Number($offsetX), $BSy + ( $BSh- $BOTh )  )
					If _Sleep(500) Then Return
				Case "SNAP-TL" ; position BOT top left of BS, do not move BS
					If $BSx  >=100 Then $BOTHandle = WinMove($sBotTitle, "", $BSx - $BOTw - Number($offsetX), $BSy )
					If _Sleep($iDelayWindowsArrange1) Then Return
				Case "SNAP-BL" ; position BOT bottom left of BS, do not move BS
					If $BSx >= 100 Then $BOTHandle = WinMove($sBotTitle, "", $BSx - $BOTw - Number($offsetX), $BSy + ( $BSh- $BOTh ) )
					If _Sleep($iDelayWindowsArrange1) Then Return
			EndSwitch
		EndIf
	EndIf


EndFunc   ;==>WindowsArrange
