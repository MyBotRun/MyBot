#include-once

#include "APIMiscConstants.au3"
#include "StringConstants.au3"
#include "WinAPIInternals.au3"

; #INDEX# =======================================================================================================================
; Title .........: WinAPI Extended UDF Library for AutoIt3
; AutoIt Version : 3.3.14.2
; Description ...: Additional variables, constants and functions for the WinAPIMisc.au3
; Author(s) .....: Yashied, jpm
; ===============================================================================================================================

#Region Global Variables and Constants

; #VARIABLES# ===================================================================================================================
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
; ===============================================================================================================================
#EndRegion Global Variables and Constants

#Region Functions list

; #CURRENT# =====================================================================================================================
; _WinAPI_ArrayToStruct
; _WinAPI_CharToOem
; _WinAPI_CopyStruct
; _WinAPI_CreateMargins
; _WinAPI_CreatePoint
; _WinAPI_CreateRect
; _WinAPI_CreateRectEx
; _WinAPI_CreateSize
; _WinAPI_DWordToFloat
; _WinAPI_DWordToInt
; _WinAPI_FloatToDWord
; _WinAPI_GetExtended
; _WinAPI_GetString
; _WinAPI_GetUDFVersion
; _WinAPI_HashData
; _WinAPI_HashString
; _WinAPI_HiByte
; _WinAPI_HiDWord
; _WinAPI_IntToDWord
; _WinAPI_LoByte
; _WinAPI_LoDWord
; _WinAPI_LongMid
; _WinAPI_MakeWord
; _WinAPI_OemToChar
; _WinAPI_PlaySound
; _WinAPI_ShortToWord
; _WinAPI_StrFormatByteSize
; _WinAPI_StrFormatByteSizeEx
; _WinAPI_StrFormatKBSize
; _WinAPI_StrFromTimeInterval
; _WinAPI_StrLen
; _WinAPI_StructToArray
; _WinAPI_SwapDWord
; _WinAPI_SwapQWord
; _WinAPI_SwapWord
; _WinAPI_UnionStruct
; _WinAPI_WordToShort
; ===============================================================================================================================
#EndRegion Functions list

#Region Public Functions

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_CharToOem($sStr)
	Local $aRet = DllCall('user32.dll', 'bool', 'CharToOemW', 'wstr', $sStr, 'wstr', '')
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, '')

	Return $aRet[2]
EndFunc   ;==>_WinAPI_CharToOem

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CopyStruct($tStruct, $sStruct = '')
	Local $iSize = DllStructGetSize($tStruct)
	If Not $iSize Then Return SetError(1, 0, 0)

	Local $tResult
	If Not StringStripWS($sStruct, $STR_STRIPLEADING + $STR_STRIPTRAILING + $STR_STRIPSPACES) Then
		$tResult = DllStructCreate('byte[' & $iSize & ']')
	Else
		$tResult = DllStructCreate($sStruct)
	EndIf
	If DllStructGetSize($tResult) < $iSize Then Return SetError(2, 0, 0)

	_WinAPI_MoveMemory($tResult, $tStruct, $iSize)
	; Return SetError(3, 0, 0) ; cannot really occur
	; EndIf
	Return $tResult
EndFunc   ;==>_WinAPI_CopyStruct

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_DWordToFloat($iValue)
	Local $tDWord = DllStructCreate('dword')
	Local $tFloat = DllStructCreate('float', DllStructGetPtr($tDWord))
	DllStructSetData($tDWord, 1, $iValue)

	Return DllStructGetData($tFloat, 1)
EndFunc   ;==>_WinAPI_DWordToFloat

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_DWordToInt($iValue)
	Local $tData = DllStructCreate('int')
	DllStructSetData($tData, 1, $iValue)

	Return DllStructGetData($tData, 1)
EndFunc   ;==>_WinAPI_DWordToInt

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_FloatToDWord($iValue)
	Local $tFloat = DllStructCreate('float')
	Local $tDWord = DllStructCreate('dword', DllStructGetPtr($tFloat))
	DllStructSetData($tFloat, 1, $iValue)

	Return DllStructGetData($tDWord, 1)
EndFunc   ;==>_WinAPI_FloatToDWord

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetExtended()
	Return $__g_vExt
EndFunc   ;==>_WinAPI_GetExtended

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_HashData($pMemory, $iSize, $iLength = 32)
	If ($iLength <= 0) Or ($iLength > 256) Then Return SetError(11, 0, 0)

	Local $tData = DllStructCreate('byte[' & $iLength & ']')

	Local $aRet = DllCall('shlwapi.dll', 'uint', 'HashData', 'struct*', $pMemory, 'dword', $iSize, 'struct*', $tData, 'dword', $iLength)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return DllStructGetData($tData, 1)
EndFunc   ;==>_WinAPI_HashData

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_HashString($sString, $bCaseSensitive = True, $iLength = 32)
	Local $iLengthS = StringLen($sString)
	If Not $iLengthS Or ($iLength > 256) Then Return SetError(12, 0, 0)

	Local $tString = DllStructCreate('wchar[' & ($iLengthS + 1) & ']')
	If Not $bCaseSensitive Then
		$sString = StringLower($sString)
	EndIf
	DllStructSetData($tString, 1, $sString)
	Local $sHash = _WinAPI_HashData($tString, 2 * $iLengthS, $iLength)
	If @error Then Return SetError(@error, @extended, 0)

	Return $sHash
EndFunc   ;==>_WinAPI_HashString

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_HiByte($iValue)
	Return BitAND(BitShift($iValue, 8), 0xFF)
EndFunc   ;==>_WinAPI_HiByte

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_HiDWord($iValue)
	Local $tInt64 = DllStructCreate('int64')
	Local $tQWord = DllStructCreate('dword;dword', DllStructGetPtr($tInt64))
	DllStructSetData($tInt64, 1, $iValue)

	Return DllStructGetData($tQWord, 2)
EndFunc   ;==>_WinAPI_HiDWord

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_IntToDWord($iValue)
	Local $tData = DllStructCreate('dword')
	DllStructSetData($tData, 1, $iValue)

	Return DllStructGetData($tData, 1)
EndFunc   ;==>_WinAPI_IntToDWord

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_LoByte($iValue)
	Return BitAND($iValue, 0xFF)
EndFunc   ;==>_WinAPI_LoByte

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_LoDWord($iValue)
	Local $tInt64 = DllStructCreate('int64')
	Local $tQWord = DllStructCreate('dword;dword', DllStructGetPtr($tInt64))
	DllStructSetData($tInt64, 1, $iValue)

	Return DllStructGetData($tQWord, 1)
EndFunc   ;==>_WinAPI_LoDWord

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_LongMid($iValue, $iStart, $iCount)
	Return BitAND(BitShift($iValue, $iStart), BitOR(BitShift(BitShift(0x7FFFFFFF, 32 - ($iCount + 1)), 1), BitShift(1, -($iCount - 1))))
EndFunc   ;==>_WinAPI_LongMid

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_MakeWord($iLo, $iHi)
	Local $tWord = DllStructCreate('ushort')
	Local $tByte = DllStructCreate('byte;byte', DllStructGetPtr($tWord))
	DllStructSetData($tByte, 1, $iHi)
	DllStructSetData($tByte, 2, $iLo)

	Return DllStructGetData($tWord, 1)
EndFunc   ;==>_WinAPI_MakeWord

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_OemToChar($sStr)
	Local $aRet = DllCall('user32.dll', 'bool', 'OemToChar', 'str', $sStr, 'str', '')
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, '')

	Return $aRet[2]
EndFunc   ;==>_WinAPI_OemToChar

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_PlaySound($sSound, $iFlags = $SND_SYSTEM_NOSTOP, $hInstance = 0)
	Local $sTypeOfSound = 'ptr'
	If $sSound Then
		If IsString($sSound) Then
			$sTypeOfSound = 'wstr'
		EndIf
	Else
		$sSound = 0
		$iFlags = 0
	EndIf

	Local $aRet = DllCall('winmm.dll', 'bool', 'PlaySoundW', $sTypeOfSound, $sSound, 'handle', $hInstance, 'dword', $iFlags)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_PlaySound

; #FUNCTION# ====================================================================================================================
; Author.........: Progandy
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_ShortToWord($iValue)
	Return BitAND($iValue, 0x0000FFFF)
EndFunc   ;==>_WinAPI_ShortToWord

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_StrFormatByteSize($iSize)
	Local $aRet = DllCall('shlwapi.dll', 'ptr', 'StrFormatByteSizeW', 'int64', $iSize, 'wstr', '', 'uint', 1024)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, '')

	Return $aRet[2]
EndFunc   ;==>_WinAPI_StrFormatByteSize

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_StrFormatByteSizeEx($iSize)
	Local $aSymbol = DllCall('kernel32.dll', 'int', 'GetLocaleInfoW', 'dword', 0x0400, 'dword', 0x000F, 'wstr', '', 'int', 2048)
	If @error Then Return SetError(@error + 10, @extended, '')

	Local $sSize = _WinAPI_StrFormatByteSize(0)
	If @error Then Return SetError(@error, @extended, '')

	Return StringReplace($sSize, '0', StringRegExpReplace(Number($iSize), '(?<=\d)(?=(\d{3})+\z)', $aSymbol[3]))
EndFunc   ;==>_WinAPI_StrFormatByteSizeEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_StrFormatKBSize($iSize)
	Local $aRet = DllCall('shlwapi.dll', 'ptr', 'StrFormatKBSizeW', 'int64', $iSize, 'wstr', '', 'uint', 1024)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, '')

	Return $aRet[2]
EndFunc   ;==>_WinAPI_StrFormatKBSize

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_StrFromTimeInterval($iTime, $iDigits = 7)
	Local $aRet = DllCall('shlwapi.dll', 'int', 'StrFromTimeIntervalW', 'wstr', '', 'uint', 1024, 'dword', $iTime, _
			'int', $iDigits)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, '')

	Return StringStripWS($aRet[1], $STR_STRIPLEADING + $STR_STRIPTRAILING)
EndFunc   ;==>_WinAPI_StrFromTimeInterval

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_UnionStruct($tStruct1, $tStruct2, $sStruct = '')
	Local $aSize[2] = [DllStructGetSize($tStruct1), DllStructGetSize($tStruct2)]

	If Not $aSize[0] Or Not $aSize[1] Then Return SetError(1, 0, 0)

	Local $tResult
	If Not StringStripWS($sStruct, $STR_STRIPLEADING + $STR_STRIPTRAILING + $STR_STRIPSPACES) Then
		$tResult = DllStructCreate('byte[' & ($aSize[0] + $aSize[1]) & ']')
	Else
		$tResult = DllStructCreate($sStruct)
	EndIf
	If DllStructGetSize($tResult) < ($aSize[0] + $aSize[1]) Then Return SetError(2, 0, 0)

	_WinAPI_MoveMemory($tResult, $tStruct1, $aSize[0])
	_WinAPI_MoveMemory(DllStructGetPtr($tResult) + $aSize[0], $tStruct2, $aSize[1])
	; If (Not _WinAPI_MoveMemory($tResult, $tStruct1, $aSize[0])) Or (Not _WinAPI_MoveMemory($pResult + $aSize[0], $tStruct2, $aSize[1])) Then
	; Return SetError(3, 0, 0) ; cannot really occur
	; EndIf

	Return $tResult
EndFunc   ;==>_WinAPI_UnionStruct

; #FUNCTION# ====================================================================================================================
; Author.........: Progandy
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_WordToShort($iValue)
	If BitAND($iValue, 0x00008000) Then
		Return BitOR($iValue, 0xFFFF8000)
	EndIf
	Return BitAND($iValue, 0x00007FFF)
EndFunc   ;==>_WinAPI_WordToShort

#EndRegion Public Functions
