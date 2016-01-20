; #FUNCTION# ====================================================================================================================
; Name ..........: debugRedArea
; Description ...:
; Syntax ........: debugRedArea($string)
; Parameters ....: $string              - a string value.
; Return values .: None
; Author ........: didipe
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func debugRedArea($string)
	If $debugRedArea = 1 Then
		Local $hFile = FileOpen($dirLogs & "debugRedArea.log", $FO_APPEND)
		_FileWriteLog($hFile, $string)
		FileClose($hFile)
	EndIf
EndFunc   ;==>debugRedArea
