
; #FUNCTION# ====================================================================================================================
; Name ..........: _ReduceMemory
; Description ...:
; Syntax ........: _ReduceMemory($PID)
; Parameters ....: $PID                 - an unknown value.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _ReduceMemory($PID)
	Local $dll = DllOpen("kernel32.dll")
	Local $ai_Handle = DllCall($dll, 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $PID)
	Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', $ai_Handle[0])
	DllCall($dll, 'int', 'CloseHandle', 'int', $ai_Handle[0])
	DllClose($dll)
	Return $ai_Return[0]
EndFunc   ;==>_ReduceMemory
