; #FUNCTION# ====================================================================================================================
; Name ..........: Messaging
; Description ...:
; Syntax ........: Messaging()
; Parameters ....:
; Return values .: None
; Author ........: paspiz85
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func Messaging()

	Local $aMessages, $sMessage = ""
	If $ichkGlobalChatEnable = 1 Then
		$aMessages = StringSplit($sTxtGlobalChatMessages, @CRLF, $STR_ENTIRESPLIT + $STR_NOCOUNT)
		If @error = 0 Then
			$iGlobalChatCounter = Mod($iGlobalChatCounter + 1, UBound($aMessages))
			$sMessage = $aMessages[$iGlobalChatCounter]
		EndIf
		If $sMessage <> "" Then
			SetLog("Sending Global chat message: " & $sMessage , $COLOR_BLUE)
			_sendChatMessage($sMessage, False)
		Else
			SetLog("Sending Global chat message failed", $COLOR_ORANGE)
		EndIf
	EndIf
	If $ichkClanChatEnable = 1 Then
		$aMessages = StringSplit($sTxtClanChatMessages, @CRLF, $STR_ENTIRESPLIT + $STR_NOCOUNT)
		If @error = 0 Then
			$iClanChatCounter = Mod($iClanChatCounter + 1, UBound($aMessages))
			$sMessage = $aMessages[$iClanChatCounter]
		EndIf
		If $sMessage <> "" Then
			SetLog("Sending Clan chat message: " & $sMessage , $COLOR_BLUE)
			_sendChatMessage($sMessage, True)
		Else
			SetLog("Sending Clan chat message failed", $COLOR_ORANGE)
		EndIf
	EndIf

EndFunc   ;==>Messaging


Func _sendChatMessage($sTxtMessage, $bClanMessage)

	ControlFocus($Title,"", "")

	ClickP($aAway, 1, 0, "#0167") ;Click Away
	If _CheckPixel($aChatTab, $bCapturePixel) = False Then ClickP($aOpenChat, 1, 0, "#0168") ; Clicks chat tab
	If _Sleep($iDelayRecruit1) Then Return

	If $bClanMessage Then
		ClickP($aClanTab, 1, 0) ; clicking clan tab
	Else
		ClickP($aGlobalTab, 1, 0) ; clicking global tab
	EndIf
	If _Sleep($iDelayRecruit2) Then Return

	ClickP($aGlobalChatBox, 1, 0) ; clicking chat box
	If _Sleep($iDelayRecruit2) Then Return

	If ControlSend($Title, "", "", $sTxtMessage, 0) = 0 Then
		Setlog(" Request text entry failed, try again", $COLOR_RED)
		Return
	EndIf
	If _Sleep($iDelayRecruit2) Then Return

	ClickP($aGlobalChatSend, 1, 0) ; clicking send button
	If _Sleep($iDelayRecruit2) Then Return

	$i = 0
	While 1
		If _Sleep(100) Then Return
		If _ColorCheck(_GetPixelColor($aCloseChat[0], $aCloseChat[1], True), Hex($aCloseChat[2], 6), $aCloseChat[3]) Then
			; Clicks chat thing
			Click($aCloseChat[0], $aCloseChat[1], 1, 0, "#0173") ;Clicks chat thing
			ExitLoop
		Else
			If _Sleep(100) Then Return
			$i += 1
			If $i > 30 Then
				SetLog("Error finding Chat Tab to close...", $COLOR_RED)
				ExitLoop
			EndIf
		EndIf
	WEnd

	If _Sleep($iDelayRecruit2) Then Return

EndFunc   ;==>_sendChatMessage

