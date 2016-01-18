; #FUNCTION# ====================================================================================================================
; Name ..........: getString()
; Description ...: This scripts reads the chat request, uses getChar to get the characters of the donation
;                  and gets all of the characters into a string.
; Syntax ........:
; Parameters ....: $y coordinate
; Return values .: $String containing the chat request
; Author ........: Zax (2015)
; Modified ......: Safar46 (2015), Hervidero (2015-04)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: getChar()
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func getString($y)
	Local $String_Temp = "", $String = "", $x = 35

	; test for readable clan request, if not increase $y until found.
	; exit func when still unreadable after 4 attempts
	For $i = 0 To 3
		If $i > 0 Then $y += 1
		$x = 35
		$String_Temp = getChar($x, $y) & getChar($x, $y)
		If $String_Temp = "  " Or $String_Temp = "||" Or $String_Temp = "| " Or $String_Temp = " |"  Then
			If $i = 3 Then
				Return "" ; exit func, line is still unreadable after 4 attempts
			Else
				ContinueLoop
			EndIf
		Else
			ExitLoop
		EndIf
	Next

	; reset $x and read whole line
	$x = 35
	While $x <= 310
		$String &= getChar($x, $y)
		$String = StringReplace($String, "|", Null)
		If StringRight($String, 10) = "          " Then ExitLoop ; read max 10 spaces/unknown chars at end of line
	WEnd

	$String = StringStripWS($String, $STR_STRIPLEADING + $STR_STRIPTRAILING + $STR_STRIPSPACES)
	Return $String
EndFunc   ;==>getString
