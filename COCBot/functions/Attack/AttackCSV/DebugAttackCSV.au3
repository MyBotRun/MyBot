; #FUNCTION# ====================================================================================================================
; Name ..........: debugAttackCSV
; Description ...:
; Syntax ........: debugAttackCSV($string)
; Parameters ....: $string              - a string value.
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func debugAttackCSV($string)
	If $debugAttackCSV = 1 Then
		Local $hfile = FileOpen($dirLogs & "debugAttackCSV.log", $FO_APPEND)
		_FileWriteLog($hfile, $string)
		FileClose($hfile)
	EndIf
EndFunc   ;==>debugAttackCSV
