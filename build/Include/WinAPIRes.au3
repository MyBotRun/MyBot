#include-once

#include "APILocaleConstants.au3"
#include "APIResConstants.au3"
#include "WinAPI.au3"
#include "WinAPIGdi.au3"
#include "WinAPIInternals.au3"

; #INDEX# =======================================================================================================================
; Title .........: WinAPI Extended UDF Library for AutoIt3
; AutoIt Version : 3.3.14.2
; Description ...: Additional variables, constants and functions for the WinAPIRes.au3
; Author(s) .....: Yashied, jpm
; ===============================================================================================================================

#Region Global Variables and Constants

; #VARIABLES# ===================================================================================================================
Global $__g_vVal
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $tagVS_FIXEDFILEINFO = 'dword Signature;dword StrucVersion;dword FileVersionMS;dword FileVersionLS;dword ProductVersionMS;dword ProductVersionLS;dword FileFlagsMask;dword FileFlags;dword FileOS;dword FileType;dword FileSubtype;dword FileDateMS;dword FileDateLS'
; ===============================================================================================================================
#EndRegion Global Variables and Constants

#Region Functions list

; #CURRENT# =====================================================================================================================
; _WinAPI_AddIconTransparency
; _WinAPI_BeginUpdateResource
; _WinAPI_ClipCursor
; _WinAPI_CopyCursor
; _WinAPI_CreateCaret
; _WinAPI_CreateIcon
; _WinAPI_CreateIconFromResourceEx
; _WinAPI_DestroyCaret
; _WinAPI_DestroyCursor
; _WinAPI_EndUpdateResource
; _WinAPI_EnumResourceLanguages
; _WinAPI_EnumResourceNames
; _WinAPI_EnumResourceTypes
; _WinAPI_ExtractIcon
; _WinAPI_FileIconInit
; _WinAPI_FindResource
; _WinAPI_FindResourceEx
; _WinAPI_FreeResource
; _WinAPI_GetCaretBlinkTime
; _WinAPI_GetCaretPos
; _WinAPI_GetClipCursor
; _WinAPI_GetCursor
; _WinAPI_GetFileVersionInfo
; _WinAPI_GetIconInfoEx
; _WinAPI_HideCaret
; _WinAPI_LoadCursor
; _WinAPI_LoadCursorFromFile
; _WinAPI_LoadIcon
; _WinAPI_LoadIndirectString
; _WinAPI_LoadResource
; _WinAPI_LoadStringEx
; _WinAPI_LockResource
; _WinAPI_LookupIconIdFromDirectoryEx
; _WinAPI_SetCaretBlinkTime
; _WinAPI_SetCaretPos
; _WinAPI_SetSystemCursor
; _WinAPI_ShowCaret
; _WinAPI_SizeOfResource
; _WinAPI_UpdateResource
; _WinAPI_VerQueryRoot
; _WinAPI_VerQueryValue
; _WinAPI_VerQueryValueEx
; ===============================================================================================================================
#EndRegion Functions list

#Region Public Functions

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_AddIconTransparency($hIcon, $iPercent = 50, $bDelete = False)
	Local $tBITMAP, $hDib = 0, $hResult = 0
	Local $ahBitmap[2]

	Local $tICONINFO = DllStructCreate($tagICONINFO)
	Local $aRet = DllCall('user32.dll', 'bool', 'GetIconInfo', 'handle', $hIcon, 'struct*', $tICONINFO)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	For $i = 0 To 1
		$ahBitmap[$i] = DllStructGetData($tICONINFO, $i + 4)
	Next
	Local $iError = 0
	Do
		$hDib = _WinAPI_CopyBitmap($ahBitmap[1])
		If Not $hDib Then
			$iError = 20
			ExitLoop
		EndIf
		$tBITMAP = DllStructCreate($tagBITMAP)
		If (Not _WinAPI_GetObject($hDib, DllStructGetSize($tBITMAP), $tBITMAP)) Or (DllStructGetData($tBITMAP, 'bmBitsPixel') <> 32) Then
			$iError = 21
			ExitLoop
		EndIf
		$aRet = DllCall('user32.dll', 'lresult', 'CallWindowProc', 'PTR', __TransparencyProc(), 'hwnd', 0, _
				'uint', $iPercent, 'wparam', DllStructGetPtr($tBITMAP), 'lparam', 0)
		If @error Or Not $aRet[0] Then
			$iError = @error + 30
			ExitLoop
		EndIf
		If $aRet[0] = -1 Then
			$hResult = _WinAPI_CreateEmptyIcon(DllStructGetData($tBITMAP, 'bmWidth'), DllStructGetData($tBITMAP, 'bmHeight'))
		Else
			$hResult = _WinAPI_CreateIconIndirect($hDib, $ahBitmap[0])
		EndIf
		If Not $hResult Then $iError = 22
	Until 1
	If $hDib Then
		_WinAPI_DeleteObject($hDib)
	EndIf
	For $i = 0 To 1
		If $ahBitmap[$i] Then
			_WinAPI_DeleteObject($ahBitmap[$i])
		EndIf
	Next
	If $iError Then Return SetError($iError, 0, 0)

	If $bDelete Then
		_WinAPI_DestroyIcon($hIcon)
	EndIf

	Return $hResult
EndFunc   ;==>_WinAPI_AddIconTransparency

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_BeginUpdateResource($sFilePath, $bDelete = False)
	Local $aRet = DllCall('kernel32.dll', 'handle', 'BeginUpdateResourceW', 'wstr', $sFilePath, 'bool', $bDelete)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_BeginUpdateResource

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_ClipCursor($tRECT)
	Local $aRet = DllCall('user32.dll', 'bool', 'ClipCursor', 'struct*', $tRECT)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_ClipCursor

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_CopyCursor($hCursor)
	Return _WinAPI_CopyIcon($hCursor)
EndFunc   ;==>_WinAPI_CopyCursor

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CreateCaret($hWnd, $hBitmap, $iWidth = 0, $iHeight = 0)
	Local $aRet = DllCall('user32.dll', 'bool', 'CreateCaret', 'hwnd', $hWnd, 'handle', $hBitmap, 'int', $iWidth, 'int', $iHeight)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CreateCaret

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CreateIcon($hInstance, $iWidth, $iHeight, $iPlanes, $iBitsPixel, $pANDBits, $pXORBits)
	Local $aRet = DllCall('user32.dll', 'handle', 'CreateIcon', 'handle', $hInstance, 'int', $iWidth, 'int', $iHeight, _
			'byte', $iPlanes, 'byte', $iBitsPixel, 'struct*', $pANDBits, 'struct*', $pXORBits)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CreateIcon

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CreateIconFromResourceEx($pData, $iSize, $bIcon = True, $iXDesiredPixels = 0, $iYDesiredPixels = 0, $iFlags = 0)
	Local $aRet = DllCall('user32.dll', 'handle', 'CreateIconFromResourceEx', 'ptr', $pData, 'dword', $iSize, 'bool', $bIcon, _
			'dword', 0x00030000, 'int', $iXDesiredPixels, 'int', $iYDesiredPixels, 'uint', $iFlags)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CreateIconFromResourceEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_DestroyCaret()
	Local $aRet = DllCall('user32.dll', 'bool', 'DestroyCaret')
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_DestroyCaret

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_DestroyCursor($hCursor)
	Local $aRet = DllCall('user32.dll', 'bool', 'DestroyCursor', 'handle', $hCursor)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_DestroyCursor

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_EndUpdateResource($hUpdate, $bDiscard = False)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'EndUpdateResourceW', 'handle', $hUpdate, 'bool', $bDiscard)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_EndUpdateResource

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EnumResourceLanguages($hModule, $sType, $sName)
	Local $iLibrary = 0, $sTypeOfType = 'int', $sTypeOfName = 'int'

	If IsString($hModule) Then
		If StringStripWS($hModule, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
			$hModule = _WinAPI_LoadLibraryEx($hModule, 0x00000003)
			If Not $hModule Then Return SetError(1, 0, 0)
			$iLibrary = 1
		Else
			$hModule = 0
		EndIf
	EndIf
	If IsString($sType) Then
		$sTypeOfType = 'wstr'
	EndIf
	If IsString($sName) Then
		$sTypeOfName = 'wstr'
	EndIf
	Dim $__g_vEnum[101] = [0]
	Local $hEnumProc = DllCallbackRegister('__EnumResLanguagesProc', 'bool', 'handle;ptr;ptr;word;long_ptr')
	Local $aRet = DllCall('kernel32.dll', 'bool', 'EnumResourceLanguagesW', 'handle', $hModule, $sTypeOfType, $sType, _
			$sTypeOfName, $sName, 'ptr', DllCallbackGetPtr($hEnumProc), 'long_ptr', 0)
	If @error Or Not $aRet[0] Or Not $__g_vEnum[0] Then
		$__g_vEnum = @error + 10
	EndIf
	If $iLibrary Then
		_WinAPI_FreeLibrary($hModule)
	EndIf
	DllCallbackFree($hEnumProc)
	If $__g_vEnum Then Return SetError($__g_vEnum, 0, 0)

	__Inc($__g_vEnum, -1)
	Return $__g_vEnum
EndFunc   ;==>_WinAPI_EnumResourceLanguages

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EnumResourceNames($hModule, $sType)
	Local $aRet, $hEnumProc, $iLibrary = 0, $sTypeOfType = 'int'

	If IsString($hModule) Then
		If StringStripWS($hModule, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
			$hModule = _WinAPI_LoadLibraryEx($hModule, 0x00000003)
			If Not $hModule Then Return SetError(1, 0, 0)
			$iLibrary = 1
		Else
			$hModule = 0
		EndIf
	EndIf
	If IsString($sType) Then
		$sTypeOfType = 'wstr'
	EndIf
	Dim $__g_vEnum[101] = [0]
	$hEnumProc = DllCallbackRegister('__EnumResNamesProc', 'bool', 'handle;ptr;ptr;long_ptr')
	$aRet = DllCall('kernel32.dll', 'bool', 'EnumResourceNamesW', 'handle', $hModule, $sTypeOfType, $sType, _
			'ptr', DllCallbackGetPtr($hEnumProc), 'long_ptr', 0)
	If @error Or Not $aRet[0] Or (Not $__g_vEnum[0]) Then
		$__g_vEnum = @error + 10
	EndIf
	If $iLibrary Then
		_WinAPI_FreeLibrary($hModule)
	EndIf
	DllCallbackFree($hEnumProc)
	If $__g_vEnum Then Return SetError($__g_vEnum, 0, 0)

	__Inc($__g_vEnum, -1)
	Return $__g_vEnum
EndFunc   ;==>_WinAPI_EnumResourceNames

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EnumResourceTypes($hModule)
	Local $iLibrary = 0
	If IsString($hModule) Then
		If StringStripWS($hModule, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
			$hModule = _WinAPI_LoadLibraryEx($hModule, 0x00000003)
			If Not $hModule Then Return SetError(1, 0, 0)
			$iLibrary = 1
		Else
			$hModule = 0
		EndIf
	EndIf
	Dim $__g_vEnum[101] = [0]
	Local $hEnumProc = DllCallbackRegister('__EnumResTypesProc', 'bool', 'handle;ptr;long_ptr')
	Local $aRet = DllCall('kernel32.dll', 'bool', 'EnumResourceTypesW', 'handle', $hModule, _
			'ptr', DllCallbackGetPtr($hEnumProc), 'long_ptr', 0)
	If @error Or Not $aRet[0] Or (Not $__g_vEnum[0]) Then
		$__g_vEnum = @error + 10
	EndIf
	If $iLibrary Then
		_WinAPI_FreeLibrary($hModule)
	EndIf
	DllCallbackFree($hEnumProc)
	If $__g_vEnum Then Return SetError($__g_vEnum, 0, 0)

	__Inc($__g_vEnum, -1)
	Return $__g_vEnum
EndFunc   ;==>_WinAPI_EnumResourceTypes

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_ExtractIcon($sIcon, $iIndex, $bSmall = False)
	Local $pLarge, $pSmall, $tPtr = DllStructCreate('ptr')
	If $bSmall Then
		$pLarge = 0
		$pSmall = DllStructGetPtr($tPtr)
	Else
		$pLarge = DllStructGetPtr($tPtr)
		$pSmall = 0
	EndIf

	DllCall('shell32.dll', 'uint', 'ExtractIconExW', 'wstr', $sIcon, 'int', $iIndex, 'ptr', $pLarge, 'ptr', $pSmall, 'uint', 1)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return DllStructGetData($tPtr, 1)
EndFunc   ;==>_WinAPI_ExtractIcon

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_FileIconInit($bRestore = True)
	Local $aRet = DllCall('shell32.dll', 'int', 660, 'int', $bRestore)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return 1
EndFunc   ;==>_WinAPI_FileIconInit

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_FindResource($hInstance, $sType, $sName)
	Local $sTypeOfType = 'int', $sTypeOfName = 'int'
	If IsString($sType) Then
		$sTypeOfType = 'wstr'
	EndIf
	If IsString($sName) Then
		$sTypeOfName = 'wstr'
	EndIf

	Local $aRet = DllCall('kernel32.dll', 'handle', 'FindResourceW', 'handle', $hInstance, $sTypeOfName, $sName, $sTypeOfType, $sType)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_FindResource

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_FindResourceEx($hInstance, $sType, $sName, $iLanguage)
	Local $sTypeOfType = 'int', $sTypeOfName = 'int'
	If IsString($sType) Then
		$sTypeOfType = 'wstr'
	EndIf
	If IsString($sName) Then
		$sTypeOfName = 'wstr'
	EndIf

	Local $aRet = DllCall('kernel32.dll', 'handle', 'FindResourceExW', 'handle', $hInstance, $sTypeOfType, $sType, _
			$sTypeOfName, $sName, 'ushort', $iLanguage)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_FindResourceEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_FreeResource($hData)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'FreeResource', 'handle', $hData)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_FreeResource

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetCaretBlinkTime()
	Local $aRet = DllCall('user32.dll', 'uint', 'GetCaretBlinkTime')
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetCaretBlinkTime

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetCaretPos()
	Local $tPOINT = DllStructCreate($tagPOINT)
	Local $aRet = DllCall('user32.dll', 'bool', 'GetCaretPos', 'struct*', $tagPOINT)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Local $aResult[2]
	For $i = 0 To 1
		$aResult[$i] = DllStructGetData($tPOINT, $i + 1)
	Next
	Return $aResult
EndFunc   ;==>_WinAPI_GetCaretPos

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetClipCursor()
	Local $tRECT = DllStructCreate($tagRECT)
	Local $aRet = DllCall('user32.dll', 'bool', 'GetClipCursor', 'struct*', $tRECT)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $tRECT
EndFunc   ;==>_WinAPI_GetClipCursor

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetCursor()
	Local $aRet = DllCall('user32.dll', 'handle', 'GetCursor')
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetCursor

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetFileVersionInfo($sFilePath, ByRef $pBuffer, $iFlags = 0)
	Local $aRet
	If $__WINVER >= 0x0600 Then
		$aRet = DllCall('version.dll', 'dword', 'GetFileVersionInfoSizeExW', 'dword', BitAND($iFlags, 0x03), 'wstr', $sFilePath, _
				'ptr', 0)
	Else
		$aRet = DllCall('version.dll', 'dword', 'GetFileVersionInfoSizeW', 'wstr', $sFilePath, 'ptr', 0)
	EndIf
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)
	$pBuffer = __HeapReAlloc($pBuffer, $aRet[0], 1)
	If @error Then Return SetError(@error + 100, @extended, 0)
	Local $iNbByte = $aRet[0]
	If $__WINVER >= 0x0600 Then
		$aRet = DllCall('version.dll', 'bool', 'GetFileVersionInfoExW', 'dword', BitAND($iFlags, 0x07), 'wstr', $sFilePath, _
				'dword', 0, 'dword', $iNbByte, 'ptr', $pBuffer)
	Else
		$aRet = DllCall('version.dll', 'bool', 'GetFileVersionInfoW', 'wstr', $sFilePath, _
				'dword', 0, 'dword', $iNbByte, 'ptr', $pBuffer)
	EndIf
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $iNbByte
EndFunc   ;==>_WinAPI_GetFileVersionInfo

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetIconInfoEx($hIcon)
	Local $tIIEX = DllStructCreate('dword;int;dword;dword;ptr;ptr;ushort;wchar[260];wchar[260]')
	;	Local $tIIEX = DllStructCreate($tagICONINFOEX)
	DllStructSetData($tIIEX, 1, DllStructGetSize($tIIEX))

	Local $aRet = DllCall('user32.dll', 'bool', 'GetIconInfoExW', 'handle', $hIcon, 'struct*', $tIIEX)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Local $aResult[8]
	For $i = 0 To 7
		$aResult[$i] = DllStructGetData($tIIEX, $i + 2)
	Next
	Return $aResult
EndFunc   ;==>_WinAPI_GetIconInfoEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_HideCaret($hWnd)
	Local $aRet = DllCall('user32.dll', 'int', 'HideCaret', 'hwnd', $hWnd)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_HideCaret

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_LoadCursor($hInstance, $sName)
	Local $sTypeOfName = 'int'
	If IsString($sName) Then
		$sTypeOfName = 'wstr'
	EndIf

	Local $aRet = DllCall('user32.dll', 'handle', 'LoadCursorW', 'handle', $hInstance, $sTypeOfName, $sName)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_LoadCursor

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_LoadCursorFromFile($sFilePath)
	Local $aRet = DllCall('user32.dll', 'handle', 'LoadCursorFromFileW', 'wstr', $sFilePath)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_LoadCursorFromFile

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_LoadIcon($hInstance, $sName)
	Local $sTypeOfName = 'int'
	If IsString($sName) Then
		$sTypeOfName = 'wstr'
	EndIf

	Local $aRet = DllCall('user32.dll', 'handle', 'LoadIconW', 'handle', $hInstance, $sTypeOfName, $sName)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_LoadIcon

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_LoadIndirectString($sStrIn)
	Local $aRet = DllCall('shlwapi.dll', 'uint', 'SHLoadIndirectString', 'wstr', $sStrIn, 'wstr', '', 'uint', 4096, 'ptr*', 0)
	If @error Then Return SetError(@error, @extended, '')
	If $aRet[0] Then Return SetError(10, $aRet[0], '')

	Return $aRet[2]
EndFunc   ;==>_WinAPI_LoadIndirectString

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_LoadResource($hInstance, $hResource)
	Local $aRet = DllCall('kernel32.dll', 'handle', 'LoadResource', 'handle', $hInstance, 'handle', $hResource)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_LoadResource

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_LoadStringEx($hModule, $iID, $iLanguage = $LOCALE_USER_DEFAULT)
	Local $iLibrary = 0
	If IsString($hModule) Then
		If StringStripWS($hModule, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
			$hModule = _WinAPI_LoadLibraryEx($hModule, 0x00000003)
			If Not $hModule Then Return SetError(@error + 20, @extended, '')
			$iLibrary = 1
		Else
			$hModule = 0
		EndIf
	EndIf
	Local $sResult = ''
	Local $pData = __ResLoad($hModule, 6, Floor($iID / 16) + 1, $iLanguage)
	If Not @error Then
		Local $iOffset = 0
		For $i = 0 To Mod($iID, 16) - 1
			$iOffset += 2 * (DllStructGetData(DllStructCreate('ushort', $pData + $iOffset), 1) + 1)
		Next
		$sResult = DllStructGetData(DllStructCreate('ushort;wchar[' & DllStructGetData(DllStructCreate('ushort', $pData + $iOffset), 1) & ']', $pData + $iOffset), 2)
		If @error Then $sResult = ''
	Else
		Return SetError(10, 0, '')
	EndIf
	If $iLibrary Then
		_WinAPI_FreeLibrary($hModule)
	EndIf

	Return SetError(Number(Not $sResult), 0, $sResult)
EndFunc   ;==>_WinAPI_LoadStringEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_LockResource($hData)
	Local $aRet = DllCall('kernel32.dll', 'ptr', 'LockResource', 'handle', $hData)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_LockResource

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_LookupIconIdFromDirectoryEx($pData, $bIcon = True, $iXDesiredPixels = 0, $iYDesiredPixels = 0, $iFlags = 0)
	Local $aRet = DllCall('user32.dll', 'int', 'LookupIconIdFromDirectoryEx', 'ptr', $pData, 'bool', $bIcon, _
			'int', $iXDesiredPixels, 'int', $iYDesiredPixels, 'uint', $iFlags)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_LookupIconIdFromDirectoryEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_SetCaretBlinkTime($iDuration)
	Local $iPrev = _WinAPI_GetCaretBlinkTime()
	If Not $iPrev Then Return SetError(@error + 20, @extended, 0)

	Local $aRet = DllCall('user32.dll', 'bool', 'SetCaretBlinkTime', 'uint', $iDuration)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $iPrev
EndFunc   ;==>_WinAPI_SetCaretBlinkTime

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetCaretPos($iX, $iY)
	Local $aRet = DllCall('user32.dll', 'int', 'SetCaretPos', 'int', $iX, 'int', $iY)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetCaretPos

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetSystemCursor($hCursor, $iID, $bCopy = False)
	If $bCopy Then
		$hCursor = _WinAPI_CopyCursor($hCursor)
	EndIf

	Local $aRet = DllCall('user32.dll', 'bool', 'SetSystemCursor', 'handle', $hCursor, 'dword', $iID)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetSystemCursor

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_ShowCaret($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'ShowCaret', 'hwnd', $hWnd)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_ShowCaret

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SizeOfResource($hInstance, $hResource)
	Local $aRet = DllCall('kernel32.dll', 'dword', 'SizeofResource', 'handle', $hInstance, 'handle', $hResource)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SizeOfResource

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_UpdateResource($hUpdate, $sType, $sName, $iLanguage, $pData, $iSize)
	Local $sTypeOfType = 'int', $sTypeOfName = 'int'
	If IsString($sType) Then
		$sTypeOfType = 'wstr'
	EndIf
	If IsString($sName) Then
		$sTypeOfName = 'wstr'
	EndIf

	Local $aRet = DllCall('kernel32.dll', 'bool', 'UpdateResourceW', 'handle', $hUpdate, $sTypeOfType, $sType, $sTypeOfName, $sName, _
			'word', $iLanguage, 'ptr', $pData, 'dword', $iSize)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_UpdateResource

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_VerQueryRoot($pData)
	Local $aRet = DllCall('version.dll', 'bool', 'VerQueryValueW', 'ptr', $pData, 'wstr', '\', 'ptr*', 0, 'uint*', 0)
	If @error Or Not $aRet[0] Or Not $aRet[4] Then Return SetError(@error + 10, @extended, 0)

	Local $tVFFI = DllStructCreate($tagVS_FIXEDFILEINFO)
	If Not _WinAPI_MoveMemory($tVFFI, $aRet[3], $aRet[4]) Then Return SetError(@error + 20, @extended, 0)

	Return $tVFFI
EndFunc   ;==>_WinAPI_VerQueryRoot

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_VerQueryValue($pData, $sValues = '')
	$sValues = StringRegExpReplace($sValues, '\A[\s\|]*|[\s\|]*\Z', '')
	If Not $sValues Then
		$sValues = 'Comments|CompanyName|FileDescription|FileVersion|InternalName|LegalCopyright|LegalTrademarks|OriginalFilename|ProductName|ProductVersion|PrivateBuild|SpecialBuild'
	EndIf
	$sValues = StringSplit($sValues, '|', $STR_NOCOUNT)
	Local $aRet = DllCall('version.dll', 'bool', 'VerQueryValueW', 'ptr', $pData, 'wstr', '\VarFileInfo\Translation', 'ptr*', 0, _
			'uint*', 0)
	If @error Or Not $aRet[0] Or Not $aRet[4] Then Return SetError(@error + 10, 0, 0)

	Local $iLength = Floor($aRet[4] / 4)
	Local $tLang = DllStructCreate('dword[' & $iLength & ']', $aRet[3])
	If @error Then Return SetError(@error + 20, 0, 0)

	Local $sCP, $aInfo[101][UBound($sValues) + 1] = [[0]]
	For $i = 1 To $iLength
		__Inc($aInfo)
		$aInfo[$aInfo[0][0]][0] = _WinAPI_LoWord(DllStructGetData($tLang, 1, $i))
		$sCP = Hex(_WinAPI_MakeLong(_WinAPI_HiWord(DllStructGetData($tLang, 1, $i)), _WinAPI_LoWord(DllStructGetData($tLang, 1, $i))), 8)
		For $j = 0 To UBound($sValues) - 1
			$aRet = DllCall('version.dll', 'bool', 'VerQueryValueW', 'ptr', $pData, 'wstr', '\StringFileInfo\' & $sCP & '\' & $sValues[$j], _
					'ptr*', 0, 'uint*', 0)
			If Not @error And $aRet[0] And $aRet[4] Then
				$aInfo[$aInfo[0][0]][$j + 1] = DllStructGetData(DllStructCreate('wchar[' & $aRet[4] & ']', $aRet[3]), 1)
			Else
				$aInfo[$aInfo[0][0]][$j + 1] = ''
			EndIf
		Next
	Next
	__Inc($aInfo, -1)
	Return $aInfo
EndFunc   ;==>_WinAPI_VerQueryValue

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_VerQueryValueEx($hModule, $sValues = '', $iLanguage = 0x0400)
	$__g_vVal = StringRegExpReplace($sValues, '\A[\s\|]*|[\s\|]*\Z', '')
	If Not $__g_vVal Then
		$__g_vVal = 'Comments|CompanyName|FileDescription|FileVersion|InternalName|LegalCopyright|LegalTrademarks|OriginalFilename|ProductName|ProductVersion|PrivateBuild|SpecialBuild'
	EndIf
	$__g_vVal = StringSplit($__g_vVal, '|')
	If Not IsArray($__g_vVal) Then Return SetError(1, 0, 0)
	Local $iLibrary = 0
	If IsString($hModule) Then
		If StringStripWS($hModule, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
			$hModule = _WinAPI_LoadLibraryEx($hModule, 0x00000003)
			If Not $hModule Then
				Return SetError(@error + 10, @extended, 0)
			EndIf
			$iLibrary = 1
		Else
			$hModule = 0
		EndIf
	EndIf
	Dim $__g_vEnum[101][$__g_vVal[0] + 1] = [[0]]
	Local $hEnumProc = DllCallbackRegister('__EnumVerValuesProc', 'bool', 'ptr;ptr;ptr;word;long_ptr')
	Local $aRet = DllCall('kernel32.dll', 'bool', 'EnumResourceLanguagesW', 'handle', $hModule, 'int', 16, 'int', 1, _
			'ptr', DllCallbackGetPtr($hEnumProc), 'long_ptr', $iLanguage)
	Do
		If @error Then
			$__g_vEnum = @error + 20
		Else
			If Not $aRet[0] Then
				Switch _WinAPI_GetLastError()
					Case 0, 15106 ; ERROR_SUCCESS, ERROR_RESOURCE_ENUM_USER_STOP
						ExitLoop
					Case Else
						$__g_vEnum = 20
				EndSwitch
			Else
				ExitLoop
			EndIf
		EndIf
	Until 1
	If $iLibrary Then
		_WinAPI_FreeLibrary($hModule)
	EndIf
	DllCallbackFree($hEnumProc)
	If Not $__g_vEnum[0][0] Then $__g_vEnum = 230
	If $__g_vEnum Then Return SetError($__g_vEnum, 0, 0)

	__Inc($__g_vEnum, -1)
	Return $__g_vEnum
EndFunc   ;==>_WinAPI_VerQueryValueEx

#EndRegion Public Functions

#Region Embedded DLL Functions

Func __TransparencyProc()
	Static $pProc = 0

	If Not $pProc Then
		If @AutoItX64 Then
			$pProc = __Init(Binary( _
					'0x48894C240848895424104C894424184C894C24205541574831C0505050505050' & _
					'4883EC284883BC24800000000074054831C0EB0748C7C0010000004821C07522' & _
					'488BAC248000000048837D180074054831C0EB0748C7C0010000004821C07502' & _
					'EB0948C7C001000000EB034831C04821C0740B4831C04863C0E93C0100004C63' & _
					'7C24784983FF647E0F48C7C0010000004863C0E9220100004C637C24784D21FF' & _
					'7D08C74424780000000048C74424280100000048C74424300000000048C74424' & _
					'3800000000488BAC24800000004C637D04488BAC2480000000486345084C0FAF' & _
					'F849C1E7024983C7FC4C3B7C24380F8C88000000488BAC24800000004C8B7D18' & _
					'4C037C24384983C7034C897C2440488B6C2440480FB64500505888442448807C' & _
					'244800744B4C0FB67C244848634424784C0FAFF84C89F848C7C1640000004899' & _
					'48F7F94989C74C89F850488B6C244858884500488B6C2440807D0000740948C7' & _
					'4424280000000048C7442430010000004883442438040F8149FFFFFF48837C24' & _
					'3000741148837C242800740948C7C001000000EB034831C04821C0740E48C7C0' & _
					'FFFFFFFF4863C0EB11EB0C48C7C0010000004863C0EB034831C04883C458415F' & _
					'5DC3'))
		Else
			$pProc = __Init(Binary( _
					'0x555331C05050505050837C242800740431C0EB05B80100000021C075198B6C24' & _
					'28837D1400740431C0EB05B80100000021C07502EB07B801000000EB0231C021' & _
					'C0740731C0E9E50000008B5C242483FB647E0AB801000000E9D20000008B5C24' & _
					'2421DB7D08C744242400000000C7042401000000C744240400000000C7442408' & _
					'000000008B6C24288B5D048B6C24280FAF5D08C1E30283C3FC3B5C24087C648B' & _
					'6C24288B5D14035C240883C303895C240C8B6C240C0FB6450088442410807C24' & _
					'100074380FB65C24100FAF5C242489D8B96400000099F7F989C3538B6C241058' & _
					'8845008B6C240C807D00007407C7042400000000C74424040100000083442408' & _
					'047181837C240400740D833C24007407B801000000EB0231C021C07409B8FFFF' & _
					'FFFFEB0BEB07B801000000EB0231C083C4145B5DC21000'))
		EndIf
	EndIf
	Return $pProc
EndFunc   ;==>__TransparencyProc

#EndRegion Embedded DLL Functions

#Region Internal Functions

Func __EnumResLanguagesProc($hModule, $iType, $iName, $iLanguage, $lParam)
	#forceref $hModule, $iType, $iName, $lParam

	__Inc($__g_vEnum)
	$__g_vEnum[$__g_vEnum[0]] = $iLanguage
	Return 1
EndFunc   ;==>__EnumResLanguagesProc

Func __EnumResNamesProc($hModule, $iType, $iName, $lParam)
	#forceref $hModule, $iType, $lParam

	Local $iLength = _WinAPI_StrLen($iName)
	__Inc($__g_vEnum)
	If $iLength Then
		$__g_vEnum[$__g_vEnum[0]] = DllStructGetData(DllStructCreate('wchar[' & ($iLength + 1) & ']', $iName), 1)
	Else
		$__g_vEnum[$__g_vEnum[0]] = Number($iName)
	EndIf
	Return 1
EndFunc   ;==>__EnumResNamesProc

Func __EnumResTypesProc($hModule, $iType, $lParam)
	#forceref $hModule, $lParam

	Local $iLength = _WinAPI_StrLen($iType)
	__Inc($__g_vEnum)
	If $iLength Then
		$__g_vEnum[$__g_vEnum[0]] = DllStructGetData(DllStructCreate('wchar[' & ($iLength + 1) & ']', $iType), 1)
	Else
		$__g_vEnum[$__g_vEnum[0]] = Number($iType)
	EndIf
	Return 1
EndFunc   ;==>__EnumResTypesProc

Func __EnumVerValuesProc($hModule, $iType, $iName, $iLanguage, $iDefault)
	Local $aRet, $iEnum = 1, $iError = 0

	Switch $iDefault
		Case -1

		Case 0x0400
			$iLanguage = 0x0400
			$iEnum = 0
		Case Else
			If $iLanguage <> $iDefault Then
				Return 1
			EndIf
			$iEnum = 0
	EndSwitch
	Do
		Local $pData = __ResLoad($hModule, $iType, $iName, $iLanguage)
		If @error Then
			$iError = @error + 10
			ExitLoop
		EndIf
		$aRet = DllCall('version.dll', 'bool', 'VerQueryValueW', 'ptr', $pData, 'wstr', '\VarFileInfo\Translation', 'ptr*', 0, 'uint*', 0)
		If @error Or Not $aRet[0] Or Not $aRet[4] Then
			$iError = @error + 20
			ExitLoop
		EndIf
		Local $tData = DllStructCreate('ushort;ushort', $aRet[3])
		If @error Then
			$iError = @error + 30
			ExitLoop
		EndIf
	Until 1
	If Not $iError Then
		__Inc($__g_vEnum)
		$__g_vEnum[$__g_vEnum[0][0]][0] = DllStructGetData($tData, 1)
		Local $sCP = Hex(_WinAPI_MakeLong(DllStructGetData($tData, 2), DllStructGetData($tData, 1)), 8)
		For $i = 1 To $__g_vVal[0]
			$aRet = DllCall('version.dll', 'bool', 'VerQueryValueW', 'ptr', $pData, 'wstr', '\StringFileInfo\' & $sCP & '\' & $__g_vVal[$i], _
					'ptr*', 0, 'uint*', 0)
			If Not @error And $aRet[0] And $aRet[4] Then
				$__g_vEnum[$__g_vEnum[0][0]][$i] = DllStructGetData(DllStructCreate('wchar[' & $aRet[4] & ']', $aRet[3]), 1)
			Else
				$__g_vEnum[$__g_vEnum[0][0]][$i] = ''
			EndIf
		Next
	Else
		$__g_vEnum = @error + 40
	EndIf
	If $__g_vEnum Then Return SetError($iError, 0, 0)

	Return $iEnum
EndFunc   ;==>__EnumVerValuesProc

Func __ResLoad($hInstance, $sType, $sName, $iLanguage)
	Local $hInfo = _WinAPI_FindResourceEx($hInstance, $sType, $sName, $iLanguage)
	If Not $hInfo Then Return SetError(@error + 10, @extended, 0)

	Local $iSize = _WinAPI_SizeOfResource($hInstance, $hInfo)
	If Not $iSize Then Return SetError(@error + 20, @extended, 0)

	Local $hData = _WinAPI_LoadResource($hInstance, $hInfo)
	If Not $hData Then Return SetError(@error + 30, @extended, 0)

	Local $pData = _WinAPI_LockResource($hData)
	If Not $pData Then Return SetError(@error + 40, @extended, 0)

	Return SetExtended($iSize, $pData)
EndFunc   ;==>__ResLoad

#EndRegion Internal Functions
