#include-once

#include "APIRegConstants.au3"
#include "StringConstants.au3"
#include "StructureConstants.au3"
#include "WinAPICom.au3"
#include "WinAPIInternals.au3"

; #INDEX# =======================================================================================================================
; Title .........: WinAPI Extended UDF Library for AutoIt3
; AutoIt Version : 3.3.14.2
; Description ...: Additional variables, constants and functions for the WinAPIReg.au3
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
; _WinAPI_AddMRUString
; _WinAPI_AssocGetPerceivedType
; _WinAPI_AssocQueryString
; _WinAPI_CreateMRUList
; _WinAPI_DllInstall
; _WinAPI_DllUninstall
; _WinAPI_EnumMRUList
; _WinAPI_FreeMRUList
; _WinAPI_GetRegKeyNameByHandle
; _WinAPI_RegCloseKey
; _WinAPI_RegConnectRegistry
; _WinAPI_RegCopyTree
; _WinAPI_RegCopyTreeEx
; _WinAPI_RegCreateKey
; _WinAPI_RegDeleteEmptyKey
; _WinAPI_RegDeleteKey
; _WinAPI_RegDeleteKeyValue
; _WinAPI_RegDeleteTree
; _WinAPI_RegDeleteTreeEx
; _WinAPI_RegDeleteValue
; _WinAPI_RegDisableReflectionKey
; _WinAPI_RegDuplicateHKey
; _WinAPI_RegEnableReflectionKey
; _WinAPI_RegEnumKey
; _WinAPI_RegEnumValue
; _WinAPI_RegFlushKey
; _WinAPI_RegLoadMUIString
; _WinAPI_RegNotifyChangeKeyValue
; _WinAPI_RegOpenKey
; _WinAPI_RegQueryInfoKey
; _WinAPI_RegQueryLastWriteTime
; _WinAPI_RegQueryMultipleValues
; _WinAPI_RegQueryReflectionKey
; _WinAPI_RegQueryValue
; _WinAPI_RegRestoreKey
; _WinAPI_RegSaveKey
; _WinAPI_RegSetValue
; _WinAPI_SfcIsKeyProtected
; ===============================================================================================================================
#EndRegion Functions list

#Region Public Functions

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_AddMRUString($hMRU, $sStr)
	Local $aRet = DllCall('comctl32.dll', 'int', 'AddMRUStringW', 'handle', $hMRU, 'wstr', $sStr)
	If @error Then Return SetError(@error, @extended, -1)
	; If $aRet[0] = -1 Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_AddMRUString

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_AssocGetPerceivedType($sExt)
	Local $aRet = DllCall('shlwapi.dll', 'long', 'AssocGetPerceivedType', 'wstr', $sExt, 'int*', 0, 'dword*', 0, 'ptr*', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Local $aResult[3]
	$aResult[0] = $aRet[2]
	$aResult[1] = $aRet[3]
	$aResult[2] = _WinAPI_GetString($aRet[4])
	_WinAPI_CoTaskMemFree($aRet[4])
	Return $aResult
EndFunc   ;==>_WinAPI_AssocGetPerceivedType

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_AssocQueryString($sAssoc, $iType, $iFlags = 0, $sExtra = '')
	Local $sTypeOfExtra = 'wstr'
	If Not StringStripWS($sExtra, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
		$sTypeOfExtra = 'ptr'
		$sExtra = 0
	EndIf

	Local $aRet = DllCall('shlwapi.dll', 'long', 'AssocQueryStringW', 'dword', $iFlags, 'dword', $iType, 'wstr', $sAssoc, _
			$sTypeOfExtra, $sExtra, 'wstr', '', 'dword*', 4096)
	If @error Then Return SetError(@error, @extended, '')
	If $aRet[0] Then Return SetError(10, $aRet[0], '')

	Return $aRet[5]
EndFunc   ;==>_WinAPI_AssocQueryString

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CreateMRUList($hKey, $sSubKey, $iMax = 26)
	Local Const $tagMRUINFO = 'dword Size;uint Max;uint Flags;handle hKey;ptr szSubKey;ptr fnCompare'
	Local $tMRUINFO = DllStructCreate($tagMRUINFO & ';wchar[' & (StringLen($sSubKey) + 1) & ']')
	DllStructSetData($tMRUINFO, 1, DllStructGetPtr($tMRUINFO, 7) - DllStructGetPtr($tMRUINFO))
	DllStructSetData($tMRUINFO, 2, $iMax)
	DllStructSetData($tMRUINFO, 3, 0)
	DllStructSetData($tMRUINFO, 4, $hKey)
	DllStructSetData($tMRUINFO, 5, DllStructGetPtr($tMRUINFO, 7))
	DllStructSetData($tMRUINFO, 6, 0)
	DllStructSetData($tMRUINFO, 7, $sSubKey)

	Local $aRet = DllCall('comctl32.dll', 'HANDLE', 'CreateMRUListW', 'struct*', $tMRUINFO)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CreateMRUList

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_DllInstall($sFilePath)
	Local $iRet = RunWait(@SystemDir & '\regsvr32.exe /s ' & $sFilePath)
	If @error Or $iRet Then Return SetError(@error + ($iRet + 100), @extended, 0)

	Return 1
EndFunc   ;==>_WinAPI_DllInstall

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_DllUninstall($sFilePath)
	Local $iRet = RunWait(@SystemDir & '\regsvr32.exe /s /u ' & $sFilePath)
	If @error Or $iRet Then Return SetError(@error + ($iRet + 100), @extended, 0)

	Return 1
EndFunc   ;==>_WinAPI_DllUninstall

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EnumMRUList($hMRU, $iItem)
	Local $aRet = DllCall('comctl32.dll', 'int', 'EnumMRUListW', 'handle', $hMRU, 'int', $iItem, 'wstr', '', 'uint', 4096)
	If @error Or ($aRet[0] = -1) Then Return SetError(@error + 10, @extended, 0)

	If $iItem < 0 Then
		Return $aRet[0]
	Else
		If Not $aRet[0] Then Return SetError(1, 0, 0)
	EndIf

	Return $aRet[3]
EndFunc   ;==>_WinAPI_EnumMRUList

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_FreeMRUList($hMRU)
	Local $aRet = DllCall('comctl32.dll', 'int', 'FreeMRUList', 'handle', $hMRU)
	If @error Then Return SetError(@error, @extended, False)
	; If $aRet[0] = -1 Then Return SetError(1000, 0, 0)

	Return ($aRet[0] <> -1)
EndFunc   ;==>_WinAPI_FreeMRUList

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetRegKeyNameByHandle($hKey)
	Local $tagKEY_NAME_INFORMATION = 'ulong NameLength;wchar Name[4096]'
	Local $tKNI = DllStructCreate($tagKEY_NAME_INFORMATION)
	Local $aRet = DllCall('ntdll.dll', 'long', 'ZwQueryKey', 'handle', $hKey, 'uint', 3, 'struct*', $tKNI, _
			'ulong', DllStructGetSize($tKNI), 'ulong*', 0)
	If @error Then Return SetError(@error, @extended, '')
	If $aRet[0] Then Return SetError(10, $aRet[0], '')
	Local $iLength = DllStructGetData($tKNI, 1)
	If Not $iLength Then Return SetError(12, 0, '')

	Return DllStructGetData(DllStructCreate('wchar[' & ($iLength / 2) & ']', DllStructGetPtr($tKNI, 2)), 1)
EndFunc   ;==>_WinAPI_GetRegKeyNameByHandle

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_RegCloseKey($hKey, $bFlush = False)
	If $bFlush Then
		If Not _WinAPI_RegFlushKey($hKey) Then
			Return SetError(@error + 10, @extended, 0)
		EndIf
	EndIf

	Local $aRet = DllCall('advapi32.dll', 'long', 'RegCloseKey', 'handle', $hKey)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_RegCloseKey

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_RegConnectRegistry($sComputer, $hKey)
	Local $aRet = DllCall('advapi32.dll', 'long', 'RegConnectRegistryW', 'wstr', $sComputer, 'handle', $hKey, 'handle*', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $aRet[3]
EndFunc   ;==>_WinAPI_RegConnectRegistry

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_RegCopyTree($hSrcKey, $sSrcSubKey, $hDestKey)
	Local $aRet = DllCall('shlwapi.dll', 'long', 'SHCopyKeyW', 'handle', $hSrcKey, 'wstr', $sSrcSubKey, 'ulong_ptr', $hDestKey, _
			'dword', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_RegCopyTree

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_RegCopyTreeEx($hSrcKey, $sSrcSubKey, $hDestKey)
	Local $aRet = DllCall('advapi32.dll', 'long', 'RegCopyTreeW', 'handle', $hSrcKey, 'wstr', $sSrcSubKey, 'ulong_ptr', $hDestKey)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_RegCopyTreeEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_RegCreateKey($hKey, $sSubKey = '', $iAccess = $KEY_ALL_ACCESS, $iOptions = 0, $tSecurity = 0)
	Local $aRet = DllCall('advapi32.dll', 'long', 'RegCreateKeyExW', 'handle', $hKey, 'wstr', $sSubKey, 'dword', 0, 'ptr', 0, _
			'dword', $iOptions, 'dword', $iAccess, 'struct*', $tSecurity, 'ulong_ptr*', 0, 'dword*', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return SetExtended(Number($aRet[9] = 1), $aRet[8])
EndFunc   ;==>_WinAPI_RegCreateKey

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_RegDeleteEmptyKey($hKey, $sSubKey = '')
	Local $aRet = DllCall('shlwapi.dll', 'long', 'SHDeleteEmptyKeyW', 'handle', $hKey, 'wstr', $sSubKey)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_RegDeleteEmptyKey

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_RegDeleteKey($hKey, $sSubKey = '')
	Local $aRet = DllCall('advapi32.dll', 'long', 'RegDeleteKeyW', 'handle', $hKey, 'wstr', $sSubKey)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_RegDeleteKey

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_RegDeleteKeyValue($hKey, $sSubKey, $sValueName)
	Local $aRet = DllCall('advapi32.dll', 'long', 'RegDeleteKeyValueW', 'handle', $hKey, 'wstr', $sSubKey, 'wstr', $sValueName)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_RegDeleteKeyValue

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_RegDeleteTree($hKey, $sSubKey = '')
	Local $aRet = DllCall('shlwapi.dll', 'long', 'SHDeleteKeyW', 'ulong_ptr', $hKey, 'wstr', $sSubKey)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_RegDeleteTree

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_RegDeleteTreeEx($hKey, $sSubKey = 0)
	Local $sSubKeyType = 'wstr'
	If Not IsString($sSubKey) Then $sSubKeyType = 'ptr'

	Local $aRet = DllCall('advapi32.dll', 'long', 'RegDeleteTreeW', 'handle', $hKey, $sSubKeyType, $sSubKey)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_RegDeleteTreeEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_RegDeleteValue($hKey, $sValueName)
	Local $aRet = DllCall('advapi32.dll', 'long', 'RegDeleteValueW', 'handle', $hKey, 'wstr', $sValueName)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_RegDeleteValue

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_RegDisableReflectionKey($hKey)
	Local $aRet = DllCall('advapi32.dll', 'long', 'RegDisableReflectionKey', 'handle', $hKey)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_RegDisableReflectionKey

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_RegDuplicateHKey($hKey)
	Local $aRet = DllCall('shlwapi.dll', 'handle', 'SHRegDuplicateHKey', 'handle', $hKey)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_RegDuplicateHKey

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_RegEnableReflectionKey($hKey)
	Local $aRet = DllCall('advapi32.dll', 'long', 'RegEnableReflectionKey', 'handle', $hKey)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_RegEnableReflectionKey

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_RegEnumKey($hKey, $iIndex)
	Local $aRet = DllCall('advapi32.dll', 'long', 'RegEnumKeyExW', 'ulong_ptr', $hKey, 'dword', $iIndex, 'wstr', '', _
			'dword*', 256, 'dword', 0, 'ptr', 0, 'ptr', 0, 'ptr', 0)
	If @error Then Return SetError(@error, @extended, '')
	If $aRet[0] Then Return SetError(10, $aRet[0], '')

	Return $aRet[3]
EndFunc   ;==>_WinAPI_RegEnumKey

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_RegEnumValue($hKey, $iIndex)
	Local $aRet = DllCall('advapi32.dll', 'long', 'RegEnumValueW', 'handle', $hKey, 'dword', $iIndex, 'wstr', '', _
			'dword*', 16384, 'dword', 0, 'dword*', 0, 'ptr', 0, 'ptr', 0)
	If @error Then Return SetError(@error, @extended, '')
	If $aRet[0] Then Return SetError(10, $aRet[0], '')

	Return SetExtended($aRet[6], $aRet[3])
EndFunc   ;==>_WinAPI_RegEnumValue

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_RegFlushKey($hKey)
	Local $aRet = DllCall('advapi32.dll', 'long', 'RegFlushKey', 'handle', $hKey)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_RegFlushKey

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_RegLoadMUIString($hKey, $sValueName, $sDirectory = '')
	Local $sTypeOfDirectory = 'wstr'
	If Not StringStripWS($sDirectory, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
		$sTypeOfDirectory = 'ptr'
		$sDirectory = 0
	EndIf

	Local $aRet = DllCall('advapi32.dll', 'long', 'RegLoadMUIStringW', 'handle', $hKey, 'wstr', $sValueName, 'wstr', '', _
			'dword', 16384, 'dword*', 0, 'dword', 0, $sTypeOfDirectory, $sDirectory)
	If @error Then Return SetError(@error, @extended, '')
	If $aRet[0] Then Return SetError(10, $aRet[0], '')

	Return $aRet[3]
EndFunc   ;==>_WinAPI_RegLoadMUIString

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_RegNotifyChangeKeyValue($hKey, $iFilter, $bSubtree = False, $bAsync = False, $hEvent = 0)
	Local $aRet = DllCall('advapi32.dll', 'long', 'RegNotifyChangeKeyValue', 'handle', $hKey, 'bool', $bSubtree, _
			'dword', $iFilter, 'handle', $hEvent, 'bool', $bAsync)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_RegNotifyChangeKeyValue

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_RegOpenKey($hKey, $sSubKey = '', $iAccess = 0x000F003F)
	Local $sSubKeyType = 'wstr'
	If Not IsString($sSubKey) Then $sSubKeyType = 'ptr'

	Local $aRet = DllCall('advapi32.dll', 'long', 'RegOpenKeyExW', 'handle', $hKey, $sSubKeyType, $sSubKey, 'dword', 0, _
			'dword', $iAccess, 'ulong_ptr*', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $aRet[5]
EndFunc   ;==>_WinAPI_RegOpenKey

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_RegQueryInfoKey($hKey)
	Local $aRet = DllCall('advapi32.dll', 'long', 'RegQueryInfoKeyW', 'handle', $hKey, 'ptr', 0, 'ptr', 0, 'ptr', 0, _
			'dword*', 0, 'dword*', 0, 'ptr', 0, 'dword*', 0, 'dword*', 0, 'dword*', 0, 'ptr', 0, 'ptr', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Local $aResult[5]
	$aResult[0] = $aRet[5]
	$aResult[1] = $aRet[6]
	$aResult[2] = $aRet[8]
	$aResult[3] = $aRet[9]
	$aResult[4] = $aRet[10]
	Return $aResult
EndFunc   ;==>_WinAPI_RegQueryInfoKey

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_RegQueryLastWriteTime($hKey)
	Local $tFILETIME = DllStructCreate($tagFILETIME)
	Local $aRet = DllCall('advapi32.dll', 'long', 'RegQueryInfoKeyW', 'handle', $hKey, 'ptr', 0, 'ptr', 0, 'ptr', 0, 'ptr', 0, _
			'ptr', 0, 'ptr', 0, 'ptr', 0, 'ptr', 0, 'ptr', 0, 'ptr', 0, 'struct*', $tFILETIME)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $tFILETIME
EndFunc   ;==>_WinAPI_RegQueryLastWriteTime

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_RegQueryMultipleValues($hKey, ByRef $aValent, ByRef $pBuffer, $iStart = 0, $iEnd = -1)
	$pBuffer = 0
	If __CheckErrorArrayBounds($aValent, $iStart, $iEnd, 2) Then Return SetError(@error + 10, @extended, 0)
	If UBound($aValent, $UBOUND_COLUMNS) < 4 Then Return SetError(13, 0, 0)

	Local $iValues = $iEnd - $iStart + 1
	Local $tagStruct = ''
	For $i = 1 To $iValues
		$tagStruct &= 'ptr;dword;ptr;dword;'
	Next
	Local $tValent = DllStructCreate($tagStruct)

	Local $aItem[$iValues], $iCount = 0
	For $i = $iStart To $iEnd
		$aItem[$iCount] = DllStructCreate('wchar[' & (StringLen($aValent[$i][0]) + 1) & ']')
		DllStructSetData($tValent, 4 * $iCount + 1, DllStructGetPtr($aItem[$iCount]))
		DllStructSetData($aItem[$iCount], 1, $aValent[$i][0])
		$iCount += 1
	Next
	Local $aRet = DllCall('advapi32.dll', 'long', 'RegQueryMultipleValuesW', 'handle', $hKey, 'struct*', $tValent, 'dword', $iValues, _
			'ptr', 0, 'dword*', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] <> 234 Then Return SetError(10, $aRet[0], 0) ; not ERROR_MORE_DATA
	$pBuffer = __HeapAlloc($aRet[5])
	If @error Then Return SetError(@error + 100, @extended, 0)
	$aRet = DllCall('advapi32.dll', 'long', 'RegQueryMultipleValuesW', 'handle', $hKey, 'struct*', $tValent, 'dword', $iValues, _
			'ptr', $pBuffer, 'dword*', $aRet[5])
	If @error Or $aRet[0] Then
		Local $iError = @error
		__HeapFree($pBuffer)
		If IsArray($aRet) Then
			Return SetError(20, $aRet[0], 0)
		Else
			Return SetError($iError + 20, @extended, 0) ; should not occur as previously called
		EndIf
	EndIf

	$iCount = 0
	For $i = $iStart To $iEnd
		For $j = 1 To 3
			$aValent[$i][$j] = DllStructGetData($tValent, 4 * $iCount + $j + 1)
		Next
		$iCount += 1
	Next
	Return $aRet[5]
EndFunc   ;==>_WinAPI_RegQueryMultipleValues

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_RegQueryReflectionKey($hKey)
	Local $aRet = DllCall('advapi32.dll', 'long', 'RegQueryReflectionKey', 'handle', $hKey, 'bool*', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $aRet[2]
EndFunc   ;==>_WinAPI_RegQueryReflectionKey

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_RegQueryValue($hKey, $sValueName, ByRef $tValueData)
	Local $aRet = DllCall('advapi32.dll', 'long', 'RegQueryValueExW', 'handle', $hKey, 'wstr', $sValueName, 'dword', 0, _
			'dword*', 0, 'struct*', $tValueData, 'dword*', DllStructGetSize($tValueData))
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return SetExtended($aRet[4], $aRet[6])
EndFunc   ;==>_WinAPI_RegQueryValue

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_RegRestoreKey($hKey, $sFilePath)
	Local $aRet = DllCall('advapi32.dll', 'long', 'RegRestoreKeyW', 'handle', $hKey, 'wstr', $sFilePath, 'dword', 8)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_RegRestoreKey

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_RegSaveKey($hKey, $sFilePath, $bReplace = False, $tSecurity = 0)
	Local $aRet
	While 1
		$aRet = DllCall('advapi32.dll', 'long', 'RegSaveKeyW', 'handle', $hKey, 'wstr', $sFilePath, 'struct*', $tSecurity)
		If @error Then Return SetError(@error, @extended, 0)
		Switch $aRet[0]
			Case 0
				ExitLoop
			Case 183 ; ERROR_ALREADY_EXISTS
				If $bReplace Then
					; If Not _WinAPI_DeleteFile($sFilePath) Then
					If Not FileDelete($sFilePath) Then
						Return SetError(20, _WinAPI_GetLastError(), 0)
					Else
						ContinueLoop
					EndIf
				Else
					ContinueCase
				EndIf
			Case Else
				Return SetError(10, $aRet[0], 0)
		EndSwitch
	WEnd

	Return 1
EndFunc   ;==>_WinAPI_RegSaveKey

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_RegSetValue($hKey, $sValueName, $iType, $tValueData, $iBytes)
	Local $aRet = DllCall('advapi32.dll', 'long', 'RegSetValueExW', 'handle', $hKey, 'wstr', $sValueName, 'dword', 0, _
			'dword', $iType, 'struct*', $tValueData, 'dword', $iBytes)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_RegSetValue

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_SfcIsKeyProtected($hKey, $sSubKey = Default, $iFlag = 0)
	If Not __DLL('sfc.dll') Then Return SetError(103, 0, False)

	Local $sSubKeyType = 'wstr'
	If Not IsString($sSubKey) Then
		$sSubKeyType = 'ptr'
		$sSubKey = 0
	EndIf

	Local $aRet = DllCall('sfc.dll', 'int', 'SfcIsKeyProtected', 'handle', $hKey, $sSubKeyType, $sSubKey, 'dword', $iFlag)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SfcIsKeyProtected

#EndRegion Public Functions
