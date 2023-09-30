#include-once

#include "APILocaleConstants.au3"
#include "StringConstants.au3"
#include "WinAPIInternals.au3"

; #INDEX# =======================================================================================================================
; Title .........: WinAPI Extended UDF Library for AutoIt3
; AutoIt Version : 3.3.14.2
; Description ...: Additional variables, constants and functions for the WinAPILocale.au3
; Author(s) .....: Yashied, jpm
; ===============================================================================================================================

#Region Global Variables and Constants

; #VARIABLES# ===================================================================================================================
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $tagNUMBERFMT = 'uint NumDigits;uint LeadingZero;uint Grouping;ptr DecimalSep;ptr ThousandSep;uint NegativeOrder' ; & ';wchar DecimalSepChars[n];wchar ThousandSepChars[n]'
; ===============================================================================================================================
#EndRegion Global Variables and Constants

#Region Functions list

; #CURRENT# =====================================================================================================================
; _WinAPI_CompareString
; _WinAPI_CreateNumberFormatInfo
; _WinAPI_EnumSystemGeoID
; _WinAPI_EnumSystemLocales
; _WinAPI_EnumUILanguages
; _WinAPI_GetDateFormat
; _WinAPI_GetDurationFormat
; _WinAPI_GetGeoInfo
; _WinAPI_GetLocaleInfo
; _WinAPI_GetNumberFormat
; _WinAPI_GetSystemDefaultLangID
; _WinAPI_GetSystemDefaultLCID
; _WinAPI_GetSystemDefaultUILanguage
; _WinAPI_GetThreadLocale
; _WinAPI_GetThreadUILanguage
; _WinAPI_GetTimeFormat
; _WinAPI_GetUserDefaultLangID
; _WinAPI_GetUserDefaultLCID
; _WinAPI_GetUserDefaultUILanguage
; _WinAPI_GetUserGeoID
; _WinAPI_IsValidLocale
; _WinAPI_SetLocaleInfo
; _WinAPI_SetThreadLocale
; _WinAPI_SetThreadUILanguage
; _WinAPI_SetUserGeoID
; ===============================================================================================================================
#EndRegion Functions list

#Region Public Functions

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CompareString($iLCID, $sString1, $sString2, $iFlags = 0)
	Local $aRet = DllCall('kernel32.dll', 'int', 'CompareStringW', 'dword', $iLCID, 'dword', $iFlags, 'wstr', $sString1, _
			'int', -1, 'wstr', $sString2, 'int', -1)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CompareString

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_CreateNumberFormatInfo($iNumDigits, $iLeadingZero, $iGrouping, $sDecimalSep, $sThousandSep, $iNegativeOrder)
	Local $tFMT = DllStructCreate($tagNUMBERFMT & ';wchar[' & (StringLen($sDecimalSep) + 1) & '];wchar[' & (StringLen($sThousandSep) + 1) & ']')

	DllStructSetData($tFMT, 1, $iNumDigits)
	DllStructSetData($tFMT, 2, $iLeadingZero)
	DllStructSetData($tFMT, 3, $iGrouping)
	DllStructSetData($tFMT, 4, DllStructGetPtr($tFMT, 7))
	DllStructSetData($tFMT, 5, DllStructGetPtr($tFMT, 8))
	DllStructSetData($tFMT, 6, $iNegativeOrder)
	DllStructSetData($tFMT, 7, $sDecimalSep)
	DllStructSetData($tFMT, 8, $sThousandSep)

	Return $tFMT
EndFunc   ;==>_WinAPI_CreateNumberFormatInfo

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EnumSystemGeoID()
	Local $hEnumProc = DllCallbackRegister('__EnumGeoIDProc', 'bool', 'long')

	Dim $__g_vEnum[101] = [0]
	Local $aRet = DllCall('kernel32.dll', 'bool', 'EnumSystemGeoID', 'dword', 16, 'long', 0, 'ptr', DllCallbackGetPtr($hEnumProc))
	If @error Or Not $aRet[0] Or Not $__g_vEnum[0] Then
		$__g_vEnum = @error + 10
	EndIf
	DllCallbackFree($hEnumProc)
	If $__g_vEnum Then Return SetError($__g_vEnum, 0, 0)

	__Inc($__g_vEnum, -1)
	Return $__g_vEnum
EndFunc   ;==>_WinAPI_EnumSystemGeoID

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EnumSystemLocales($iFlag)
	Local $hEnumProc = DllCallbackRegister('__EnumLocalesProc', 'bool', 'ptr')

	Dim $__g_vEnum[101] = [0]
	Local $aRet = DllCall('kernel32.dll', 'bool', 'EnumSystemLocalesW', 'ptr', DllCallbackGetPtr($hEnumProc), 'dword', $iFlag)
	If @error Or Not $aRet[0] Or Not $__g_vEnum[0] Then
		$__g_vEnum = @error + 10
	EndIf
	DllCallbackFree($hEnumProc)
	If $__g_vEnum Then Return SetError($__g_vEnum, 0, 0)

	__Inc($__g_vEnum, -1)
	Return $__g_vEnum
EndFunc   ;==>_WinAPI_EnumSystemLocales

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EnumUILanguages($iFlag = 0)
	Local $hEnumProc = DllCallbackRegister('__EnumUILanguagesProc', 'bool', 'ptr;long_ptr')
	Local $iID = 1

	If $__WINVER >= 0x0600 Then
		If BitAND($iFlag, 0x0008) Then
			$iID = 0
		EndIf
	Else
		$iFlag = 0
	EndIf
	Dim $__g_vEnum[101] = [0]
	Local $aRet = DllCall('kernel32.dll', 'bool', 'EnumUILanguagesW', 'ptr', DllCallbackGetPtr($hEnumProc), 'dword', $iFlag, _
			'long_ptr', $iID)
	If @error Or Not $aRet[0] Or Not $__g_vEnum[0] Then
		$__g_vEnum = @error + 10
	EndIf
	DllCallbackFree($hEnumProc)
	If $__g_vEnum Then Return SetError($__g_vEnum, 0, 0)

	__Inc($__g_vEnum, -1)
	Return $__g_vEnum
EndFunc   ;==>_WinAPI_EnumUILanguages

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetDateFormat($iLCID = 0, $tSYSTEMTIME = 0, $iFlags = 0, $sFormat = '')
	If Not $iLCID Then $iLCID = 0x0400

	Local $sTypeOfFormat = 'wstr'
	If Not StringStripWS($sFormat, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
		$sTypeOfFormat = 'ptr'
		$sFormat = 0
	EndIf

	Local $aRet = DllCall('kernel32.dll', 'int', 'GetDateFormatW', 'dword', $iLCID, 'dword', $iFlags, 'struct*', $tSYSTEMTIME, _
			$sTypeOfFormat, $sFormat, 'wstr', '', 'int', 2048)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, '')
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[5]
EndFunc   ;==>_WinAPI_GetDateFormat

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetDurationFormat($iLCID, $iDuration, $sFormat = '')
	If Not $iLCID Then $iLCID = 0x0400

	Local $pST, $iVal
	If IsDllStruct($iDuration) Then
		$pST = DllStructGetPtr($iDuration)
		$iVal = 0
	Else
		$pST = 0
		$iVal = $iDuration
	EndIf
	Local $sTypeOfFormat = 'wstr'
	If Not StringStripWS($sFormat, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
		$sTypeOfFormat = 'ptr'
		$sFormat = 0
	EndIf

	Local $aRet = DllCall('kernel32.dll', 'int', 'GetDurationFormat', 'dword', $iLCID, 'dword', 0, 'ptr', $pST, 'uint64', $iVal, _
			$sTypeOfFormat, $sFormat, 'wstr', '', 'int', 2048)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, '')
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[6]
EndFunc   ;==>_WinAPI_GetDurationFormat

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetGeoInfo($iGEOID, $iType, $iLanguage = 0)
	Local $aRet = DllCall('kernel32.dll', 'int', 'GetGeoInfoW', 'long', $iGEOID, 'dword', $iType, 'wstr', '', 'int', 4096, _
			'word', $iLanguage)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[3]
EndFunc   ;==>_WinAPI_GetGeoInfo

; #FUNCTION# ====================================================================================================================
; Author.........: WideBoyDixon
; Modified.......: Yashied, Jpm
; ===============================================================================================================================
Func _WinAPI_GetLocaleInfo($iLCID, $iType)
	Local $aRet = DllCall('kernel32.dll', 'int', 'GetLocaleInfoW', 'dword', $iLCID, 'dword', $iType, 'wstr', '', 'int', 2048)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, '')

	Return $aRet[3]
EndFunc   ;==>_WinAPI_GetLocaleInfo

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetNumberFormat($iLCID, $sNumber, $tNUMBERFMT = 0)
	If Not $iLCID Then $iLCID = 0x0400 ; LOCALE_USER_DEFAULT

	Local $aRet = DllCall('kernel32.dll', 'int', 'GetNumberFormatW', 'dword', $iLCID, 'dword', 0, 'wstr', $sNumber, _
			'struct*', $tNUMBERFMT, 'wstr', '', 'int', 2048)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, '')
	; If Not $aRet[0] Then Return SetError(1000, 0,'')

	Return $aRet[5]
EndFunc   ;==>_WinAPI_GetNumberFormat

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetSystemDefaultLangID()
	Local $aRet = DllCall('kernel32.dll', 'word', 'GetSystemDefaultLangID')
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetSystemDefaultLangID

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetSystemDefaultLCID()
	Local $aRet = DllCall('kernel32.dll', 'dword', 'GetSystemDefaultLCID')
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetSystemDefaultLCID

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetSystemDefaultUILanguage()
	Local $aRet = DllCall('kernel32.dll', 'word', 'GetSystemDefaultUILanguage')
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetSystemDefaultUILanguage

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetThreadLocale()
	Local $aRet = DllCall('kernel32.dll', 'dword', 'GetThreadLocale')
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetThreadLocale

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetThreadUILanguage()
	Local $aRet = DllCall('kernel32.dll', 'word', 'GetThreadUILanguage')
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetThreadUILanguage

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetTimeFormat($iLCID = 0, $tSYSTEMTIME = 0, $iFlags = 0, $sFormat = '')
	If Not $iLCID Then $iLCID = 0x0400

	Local $sTypeOfFormat = 'wstr'
	If Not StringStripWS($sFormat, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
		$sTypeOfFormat = 'ptr'
		$sFormat = 0
	EndIf

	Local $aRet = DllCall('kernel32.dll', 'int', 'GetTimeFormatW', 'dword', $iLCID, 'dword', $iFlags, 'struct*', $tSYSTEMTIME, _
			$sTypeOfFormat, $sFormat, 'wstr', '', 'int', 2048)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, '')

	Return $aRet[5]
EndFunc   ;==>_WinAPI_GetTimeFormat

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetUserDefaultLangID()
	Local $aRet = DllCall('kernel32.dll', 'word', 'GetUserDefaultLangID')
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetUserDefaultLangID

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetUserDefaultLCID()
	Local $aRet = DllCall('kernel32.dll', 'dword', 'GetUserDefaultLCID')
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetUserDefaultLCID

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetUserDefaultUILanguage()
	Local $aRet = DllCall('kernel32.dll', 'word', 'GetUserDefaultUILanguage')
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetUserDefaultUILanguage

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetUserGeoID()
	Local $aRet = DllCall('kernel32.dll', 'long', 'GetUserGeoID', 'uint', 16)
	If @error Then Return SetError(@error, @extended, -1)
	; If $aRet[0] = -1 Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetUserGeoID

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_IsValidLocale($iLCID, $iFlag = 0)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'IsValidLocale', 'dword', $iLCID, 'dword', $iFlag)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_IsValidLocale

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetLocaleInfo($iLCID, $iType, $sData)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'SetLocaleInfoW', 'dword', $iLCID, 'dword', $iType, 'wstr', $sData)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetLocaleInfo

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetThreadLocale($iLCID)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'SetThreadLocale', 'dword', $iLCID)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetThreadLocale

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_SetThreadUILanguage($iLanguage)
	Local $aRet = DllCall('kernel32.dll', 'word', 'SetThreadUILanguage', 'word', $iLanguage)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return ($aRet[0] = $aRet[1])
EndFunc   ;==>_WinAPI_SetThreadUILanguage

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetUserGeoID($iGEOID)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'SetUserGeoID', 'long', $iGEOID)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetUserGeoID

#EndRegion Public Functions

#Region Internal Functions

Func __EnumGeoIDProc($iID)
	__Inc($__g_vEnum)
	$__g_vEnum[$__g_vEnum[0]] = $iID
	Return 1
EndFunc   ;==>__EnumGeoIDProc

Func __EnumLocalesProc($pLocale)
	__Inc($__g_vEnum)
	$__g_vEnum[$__g_vEnum[0]] = Dec(DllStructGetData(DllStructCreate('wchar[' & (_WinAPI_StrLen($pLocale) + 1) & ']', $pLocale), 1))
	Return 1
EndFunc   ;==>__EnumLocalesProc

Func __EnumUILanguagesProc($pLanguage, $iID)
	__Inc($__g_vEnum)
	$__g_vEnum[$__g_vEnum[0]] = DllStructGetData(DllStructCreate('wchar[' & (_WinAPI_StrLen($pLanguage) + 1) & ']', $pLanguage), 1)
	If $iID Then
		$__g_vEnum[$__g_vEnum[0]] = Dec($__g_vEnum[$__g_vEnum[0]])
	EndIf
	Return 1
EndFunc   ;==>__EnumUILanguagesProc

#EndRegion Internal Functions
