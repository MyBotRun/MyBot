; #FUNCTION# ====================================================================================================================
; Name ..........: Recruit
; Description ...:
; Syntax ........: Recruit()
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

Func Recruit()

	Local $f , $line, $firstLine, $lineCount, $sRecruitMessage
	If FileExists($fileRecruitMessages) Then
		$lineCount = 0
		$selectedLine = ""
		$f = FileOpen($fileRecruitMessages, 0)
		; Read in lines of text until the EOF is reached
		While 1
			$line = FileReadLine($f)
			If @error = -1 Then ExitLoop
			;Setlog("line content: " & $line)
			If $lineCount = 0 Then $firstLine = $line
			$lineCount += 1
			If $lineCount = $iRecruitCount Then
				$sRecruitMessage = $line
				$iRecruitCount += 1
			EndIf
		WEnd
		If $sRecruitMessage = "" Then
			$sRecruitMessage = $firstLine
			$iRecruitCount = 0
		EndIf
		If $sRecruitMessage <> "" Then
			_sendRecruitMessage($sRecruitMessage)
		EndIf
		FileClose($f)
	Else
		SetLog("Recuitment disabled, file not found " & $fileRecruitMessages , $COLOR_ORANGE)
	EndIf

EndFunc   ;==>Recruit


Func _sendRecruitMessage($sTxtMessage)

	ControlFocus($Title,"", "")

	ClickP($aAway, 1, 0, "#0167") ;Click Away
	If _CheckPixel($aChatTab, $bCapturePixel) = False Then ClickP($aOpenChat, 1, 0, "#0168") ; Clicks chat tab
	If _Sleep($iDelayRecruit1) Then Return

	ClickP($aGlobalTab, 1, 0) ; clicking global tab
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

EndFunc   ;==>_sendRecruitMessage

