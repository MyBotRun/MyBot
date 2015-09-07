
Func _ReduceMemory($PID)
	Local $dll = DllOpen("kernel32.dll")
	Local $ai_Handle = DllCall($dll, 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $PID)
	Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', $ai_Handle[0])
	DllCall($dll, 'int', 'CloseHandle', 'int', $ai_Handle[0])
	DllClose($dll)
	Return $ai_Return[0]
EndFunc   ;==>_ReduceMemory
