#include-once

; #INDEX# =======================================================================================================================
; Title .........: Windows API
; AutoIt Version : 3.3.14.2
; Description ...: Windows API calls that have been translated to AutoIt functions.
; Author(s) .....: Paul Campbell (PaulIA)
; Dll ...........: kernel32.dll
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _WinAPI_GetLastError
; _WinAPI_SetLastError
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetLastError(Const $_iCurrentError = @error, Const $_iCurrentExtended = @extended)
	Local $aResult = DllCall("kernel32.dll", "dword", "GetLastError")
	Return SetError($_iCurrentError, $_iCurrentExtended, $aResult[0])
EndFunc   ;==>_WinAPI_GetLastError

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_SetLastError($iErrorCode, Const $_iCurrentError = @error, Const $_iCurrentExtended = @extended)
	DllCall("kernel32.dll", "none", "SetLastError", "dword", $iErrorCode)
	Return SetError($_iCurrentError, $_iCurrentExtended, Null)
EndFunc   ;==>_WinAPI_SetLastError

; #INTERNAL_USE_ONLY#============================================================================================================
; Name ..........: __COMErrorFormating
; Description ...: Called when a COM error occurs and writes the error message with _DebugOut().
; Syntax.........: __COMErrorFormating ( $oCOMError, $sLeading )
; Parameters ....: $oCOMError - Error object
;                  $sPrefix - string to prefix each line
; Return values .: None
; Author ........: water
; Modified ......: jpm
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __COMErrorFormating($oCOMError, $sPrefix = @TAB)
	Local Const $STR_STRIPTRAILING = 2 ; to avoid include just for one constant
	Local $sError = "COM Error encountered in " & @ScriptName & " (" & $oCOMError.Scriptline & ") :" & @CRLF & _
			$sPrefix & "Number        " & @TAB & "= 0x" & Hex($oCOMError.Number, 8) & " (" & $oCOMError.Number & ")" & @CRLF & _
			$sPrefix & "WinDescription" & @TAB & "= " & StringStripWS($oCOMError.WinDescription, $STR_STRIPTRAILING) & @CRLF & _
			$sPrefix & "Description   " & @TAB & "= " & StringStripWS($oCOMError.Description, $STR_STRIPTRAILING) & @CRLF & _
			$sPrefix & "Source        " & @TAB & "= " & $oCOMError.Source & @CRLF & _
			$sPrefix & "HelpFile      " & @TAB & "= " & $oCOMError.HelpFile & @CRLF & _
			$sPrefix & "HelpContext   " & @TAB & "= " & $oCOMError.HelpContext & @CRLF & _
			$sPrefix & "LastDllError  " & @TAB & "= " & $oCOMError.LastDllError & @CRLF & _
			$sPrefix & "Retcode       " & @TAB & "= 0x" & Hex($oCOMError.retcode)

	Return $sError
EndFunc   ;==>__COMErrorFormating
