Func debugRedArea($string)
	If $debugRedArea = 1 Then
		_FileWriteLog(FileOpen($dirLogs & "debugRedArea.log", $FO_APPEND), $string)
	EndIf
EndFunc   ;==>debugRedArea
