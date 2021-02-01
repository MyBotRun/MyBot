#include-once

#include "APIDiagConstants.au3"
#include "StringConstants.au3"
#include "WinAPI.au3"
#include "WinAPIFiles.au3"
#include "WinAPIInternals.au3"
#include "WinAPIProc.au3"
#include "WinAPIShellEx.au3"
#include "WinAPITheme.au3"

; #INDEX# =======================================================================================================================
; Title .........: WinAPI Extended UDF Library for AutoIt3
; AutoIt Version : 3.3.14.2
; Description ...: Additional variables, constants and functions for the WinAPIDiag.au3
; Author(s) .....: Yashied, jpm
; ===============================================================================================================================

#Region Global Variables and Constants

; #VARIABLES# ===================================================================================================================
Global $__g_hFRDlg = 0, $__g_hFRDll = 0
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
; ===============================================================================================================================
#EndRegion Global Variables and Constants

#Region Functions list

; #CURRENT# =====================================================================================================================
; _WinAPI_DisplayStruct
; _WinAPI_EnumDllProc
; _WinAPI_FatalExit
; _WinAPI_GetApplicationRestartSettings
; _WinAPI_GetErrorMessage
; _WinAPI_GetErrorMode
; _WinAPI_IsInternetConnected
; _WinAPI_IsNetworkAlive
; _WinAPI_NtStatusToDosError
; _WinAPI_RegisterApplicationRestart
; _WinAPI_SetErrorMode
; _WinAPI_ShowLastError
; _WinAPI_UniqueHardwareID
; _WinAPI_UnregisterApplicationRestart
; ===============================================================================================================================
#EndRegion Functions list

#Region Public Functions

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DisplayStruct($tStruct, $sStruct = '', $sTitle = '', $iItem = 0, $iSubItem = 0, $iFlags = 0, $bTop = True, $hParent = 0)
	If Not StringStripWS($sTitle, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
		$sTitle = 'Structure: ListView Display'
	EndIf
	$sStruct = StringRegExpReplace(StringStripWS($sStruct, $STR_STRIPLEADING + $STR_STRIPTRAILING + $STR_STRIPSPACES), ';+\Z', '')
	Local $pData
	If IsDllStruct($tStruct) Then
		$pData = DllStructGetPtr($tStruct)
		If Not $sStruct Then
			$sStruct = 'byte[' & DllStructGetSize($tStruct) & ']'
			$iFlags = BitOR($iFlags, 64)
		EndIf
	Else
		$pData = $tStruct
		If Not $sStruct Then Return SetError(10, 0, 0)
	EndIf
	Local $tData = DllStructCreate($sStruct, $pData)

	Local $iData = DllStructGetSize($tData)
	If (Not BitAND($iFlags, 512)) And (_WinAPI_IsBadReadPtr($pData, $iData)) Then
		If Not BitAND($iFlags, 256) Then
			MsgBox($MB_SYSTEMMODAL, $sTitle, 'The memory range allocated to a given structure could not be read.' & _
					@CRLF & @CRLF & Ptr($pData) & ' - ' & Ptr($pData + $iData - 1) & _
					@CRLF & @CRLF & 'Press OK to exit.')
			Exit -1073741819
		EndIf
		Return SetError(15, 0, 0)
	EndIf

	Local $sOpt1 = Opt('GUIDataSeparatorChar', '|')
	Local $iOpt2 = Opt('GUIOnEventMode', 0)
	Local $iOpt3 = Opt('GUICloseOnESC', 1)

	If $hParent Then
		GUISetState(@SW_DISABLE, $hParent)
	EndIf
	Local $iStyle = 0x00000001
	If $bTop Then
		$iStyle = BitOR($iStyle, 0x00000008)
	EndIf
	$__g_hFRDlg = GUICreate($sTitle, 570, 620, -1, -1, 0x80C70000, $iStyle, $hParent)
	Local $idLV = GUICtrlCreateListView('#|Member|Offset|Type|Size|Value', 0, 0, 570, 620, 0x0000800D, __Iif($__WINVER < 0x0600, 0x00010031, 0x00010030))
	Local $hLV = GUICtrlGetHandle($idLV)
	If $__WINVER >= 0x0600 Then
		_WinAPI_SetWindowTheme($hLV, 'Explorer')
	EndIf
	GUICtrlSetResizing(-1, 0x0066)
	GUICtrlSetFont(-1, 8.5, 400, 0, 'Tahoma')
	GUICtrlSetState(-1, 0x0100)
	Local $aVal[101] = [0]
	If Not BitAND($iFlags, 1) Then
		__Inc($aVal)
		$aVal[$aVal[0]] = ''
		GUICtrlCreateListViewItem('-|-|' & $pData & '|<struct>|0|-', $idLV)
		GUICtrlSetColor(-1, 0x9C9C9C)
	EndIf
	Local $aData = StringSplit($sStruct, ';')
	Local $aItem, $vItem, $sItem, $iMode, $iIndex, $iCount = 0, $iPrev = 0
	Local $aSel[2] = [0, 0]
	Local $aType[28][2] = _
			[['BYTE', 1], _
			['BOOLEAN', 1], _
			['CHAR', 1], _
			['WCHAR', 2], _
			['short', 2], _
			['USHORT', 2], _
			['WORD', 2], _
			['int', 4], _
			['long', 4], _
			['BOOL', 4], _
			['UINT', 4], _
			['ULONG', 4], _
			['DWORD', 4], _
			['INT64', 8], _
			['UINT64', 8], _
			['ptr', __Iif(@AutoItX64, 8, 4)], _
			['HWND', __Iif(@AutoItX64, 8, 4)], _
			['HANDLE', __Iif(@AutoItX64, 8, 4)], _
			['float', 4], _
			['double', 8], _
			['INT_PTR', __Iif(@AutoItX64, 8, 4)], _
			['LONG_PTR', __Iif(@AutoItX64, 8, 4)], _
			['LRESULT', __Iif(@AutoItX64, 8, 4)], _
			['LPARAM', __Iif(@AutoItX64, 8, 4)], _
			['UINT_PTR', __Iif(@AutoItX64, 8, 4)], _
			['ULONG_PTR', __Iif(@AutoItX64, 8, 4)], _
			['DWORD_PTR', __Iif(@AutoItX64, 8, 4)], _
			['WPARAM', __Iif(@AutoItX64, 8, 4)]]

	For $i = 1 To $aData[0]
		$aItem = StringSplit(StringStripWS($aData[$i], $STR_STRIPLEADING + $STR_STRIPTRAILING), ' ')
		Switch $aItem[1]
			Case 'ALIGN', 'STRUCT', 'ENDSTRUCT'
				ContinueLoop
			Case Else

		EndSwitch
		$iCount += 1
		$iMode = 1
		$sItem = $iCount & '|'
		If $aItem[0] > 1 Then
			$vItem = StringRegExpReplace($aItem[2], '\[.*\Z', '')
			$sItem &= $vItem & '|'
			If (Not BitAND($iFlags, 16)) And (Not StringCompare(StringRegExpReplace($vItem, '[0-9]+\Z', ''), 'RESERVED')) Then
				$iMode = 0
			EndIf
			If Not IsString($iItem) Then
				$vItem = $iCount
			EndIf
			$iIndex = 2
		Else
			If Not BitAND($iFlags, 4) Then
				$sItem &= '<unnamed>|'
			Else
				$sItem &= '|'
			EndIf
			If Not IsString($iItem) Then
				$vItem = $iCount
			Else
				$vItem = 0
			EndIf
			$iIndex = 1
		EndIf
		If (Not $aSel[0]) And ($vItem) And ($iItem) And ($vItem = $iItem) Then
			$aSel[0] = $iCount
		EndIf
		Local $iOffset = Number(DllStructGetPtr($tData, $iCount) - $pData)
		$iIndex = StringRegExp($aItem[$iIndex], '\[(\d+)\]', $STR_REGEXPARRAYGLOBALMATCH)
		Local $iSize
		Do
			ReDim $aItem[3]
			$vItem = StringRegExpReplace($aItem[1], '\[.*\Z', '')
			For $j = 0 To UBound($aType) - 1
				If Not StringCompare($aType[$j][0], $vItem) Then
					$aItem[1] = $aType[$j][0]
					$aItem[2] = $aType[$j][1]
					$iSize = $aItem[2]
					ExitLoop 2
				EndIf
			Next
			$aItem[1] = '?'
			$aItem[2] = '?'
			$iSize = 0
		Until 1
		$sItem &= $iOffset & '|'
		If (IsArray($iIndex)) And ($iIndex[0] > '1') Then
			If $iSize Then
				$aItem[2] = $aItem[2] * $iIndex[0]
			EndIf
			Do
				Switch $aItem[1]
					Case 'BYTE', 'BOOLEAN'
						If Not BitAND($iFlags, 64) Then
							ContinueCase
						EndIf
					Case 'CHAR', 'WCHAR'
						$sItem &= $aItem[1] & '[' & $iIndex[0] & ']|' & $aItem[2] & '|'
						$iIndex = 0
						ExitLoop
					Case Else

				EndSwitch
				If ($iSize) And ($iMode) Then
					$sItem &= $aItem[1] & '[' & $iIndex[0] & ']|' & $aItem[2] & ' (' & $iSize & ')' & '|'
				Else
					$sItem &= $aItem[1] & '[' & $iIndex[0] & ']|' & $aItem[2] & '|'
				EndIf
				If $iMode Then
					$iIndex = $iIndex[0]
				Else
					$iIndex = 0
				EndIf
			Until 1
		Else
			$sItem &= $aItem[1] & '|' & $aItem[2] & '|'
			$iIndex = 0
		EndIf
		If (Not BitAND($iFlags, 2)) And ($iPrev) And ($iOffset > $iPrev) Then
			__Inc($aVal)
			$aVal[$aVal[0]] = ''
			GUICtrlCreateListViewItem('-|-|-|<alignment>|' & ($iOffset - $iPrev) & '|-', $idLV)
			GUICtrlSetColor(-1, 0xFF0000)
		EndIf
		If $iSize Then
			$iPrev = $iOffset + $aItem[2]
		Else
			$iPrev = 0
		EndIf
		Local $idLVItem, $idInit
		If $iIndex Then
			Local $sPattern = '[%0' & StringLen($iIndex) & 'd] '
			For $j = 1 To $iIndex
				__Inc($aVal)
				$aVal[$aVal[0]] = DllStructGetData($tData, $iCount, $j)
				If BitAND($iFlags, 128) Then
					$aVal[$aVal[0]] = __Hex($aVal[$aVal[0]], $aItem[1])
				EndIf
				$idLVItem = GUICtrlCreateListViewItem($sItem & StringFormat($sPattern, $j) & $aVal[$aVal[0]], $idLV)
				If ($aSel[0] = $iCount) And (Not $aSel[1]) Then
					If ($iSubItem < 1) Or ($iSubItem > $iIndex) Or ($iSubItem = $j) Then
						$aSel[1] = $idLVItem
					EndIf
				EndIf
				If (Not $idInit) And ($iCount = 1) Then
					$idInit = $idLVItem
				EndIf
				If Not BitAND($iFlags, 8) Then
					GUICtrlSetBkColor(-1, 0xF5F5F5)
				EndIf
				If $iSize Then
					$sItem = '-|-|' & ($iOffset + $j * $iSize) & '|-|-|'
				Else
					GUICtrlSetColor(-1, 0xFF8800)
					$sItem = '-|-|-|-|-|'
				EndIf
			Next
		Else
			__Inc($aVal)
			If $iMode Then
				$aVal[$aVal[0]] = DllStructGetData($tData, $iCount)
				If BitAND($iFlags, 128) Then
					$aVal[$aVal[0]] = __Hex($aVal[$aVal[0]], $aItem[1])
				EndIf
				$idLVItem = GUICtrlCreateListViewItem($sItem & $aVal[$aVal[0]], $idLV)
			Else
				$aVal[$aVal[0]] = ''
				$idLVItem = GUICtrlCreateListViewItem($sItem & '-', $idLV)
			EndIf
			If ($aSel[0] = $iCount) And (Not $aSel[1]) Then
				$aSel[1] = $idLVItem
			EndIf
			If (Not $idInit) And ($iCount = 1) Then
				$idInit = $idLVItem
			EndIf
			If Not $iSize Then
				GUICtrlSetColor(-1, 0xFF8800)
			EndIf
		EndIf
		If (Not BitAND($iFlags, 2)) And (Not $iSize) Then
			__Inc($aVal)
			$aVal[$aVal[0]] = ''
			GUICtrlCreateListViewItem('-|-|-|<alignment>|?|-', $idLV)
			GUICtrlSetColor(-1, 0xFF8800)
		EndIf
	Next
	If (Not BitAND($iFlags, 2)) And ($iPrev) And ($iData > $iPrev) Then
		__Inc($aVal)
		$aVal[$aVal[0]] = ''
		GUICtrlCreateListViewItem('-|-|-|<alignment>|' & ($iData - $iPrev) & '|-', $idLV)
		GUICtrlSetColor(-1, 0xFF0000)
	EndIf
	If Not BitAND($iFlags, 1) Then
		__Inc($aVal)
		$aVal[$aVal[0]] = ''
		GUICtrlCreateListViewItem('-|-|' & ($pData + $iData - 0) & '|<endstruct>|' & $iData & '|-', $idLV)
		GUICtrlSetColor(-1, 0x9C9C9C)
	EndIf
	If $aSel[1] Then
		GUICtrlSetState($aSel[1], 0x0100)
	Else
		GUICtrlSetState($idInit, 0x0100)
	EndIf
	Local $idDummy = GUICtrlCreateDummy()
	Local $aWidth[6] = [30, 130, 76, 100, 50, 167]
	For $i = 0 To UBound($aWidth) - 1
		GUICtrlSendMsg($idLV, 0x101E, $i, $aWidth[$i])
	Next
	Local $tParam = DllStructCreate('ptr;uint')
	DllStructSetData($tParam, 1, $hLV)
	If Not BitAND($iFlags, 32) Then
		DllStructSetData($tParam, 2, $idDummy)
	Else
		DllStructSetData($tParam, 2, 0)
	EndIf
	$__g_hFRDll = DllCallbackRegister('__DlgSubclassProc', 'lresult', 'hwnd;uint;wparam;lparam;uint;ptr')
	Local $pDll = DllCallbackGetPtr($__g_hFRDll)
	If _WinAPI_SetWindowSubclass($__g_hFRDlg, $pDll, 1000, DllStructGetPtr($tParam)) Then
		OnAutoItExitRegister('__Quit')
	Else
		DllCallbackFree($__g_hFRDll)
		$__g_hFRDll = 0
	EndIf
	GUISetState()
	While 1
		Switch GUIGetMsg()
			Case 0
				ContinueLoop
			Case -3
				ExitLoop
			Case $idDummy
				$iIndex = GUICtrlRead($idDummy)
				If ($iIndex >= 0) And ($iIndex < $aVal[0]) Then
					ClipPut($aVal[$iIndex + 1])
				EndIf
		EndSwitch
	WEnd
	If $__g_hFRDll Then
		OnAutoItExitUnRegister('__Quit')
	EndIf
	__Quit()
	If $hParent Then
		GUISetState(@SW_ENABLE, $hParent)
	EndIf
	GUIDelete($__g_hFRDlg)
	Opt('GUIDataSeparatorChar', $sOpt1)
	Opt('GUIOnEventMode', $iOpt2)
	Opt('GUICloseOnESC', $iOpt3)

	Return 1
EndFunc   ;==>_WinAPI_DisplayStruct

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EnumDllProc($sFilePath, $sMask = '', $iFlags = 0)
	If Not __DLL('dbghelp.dll') Then Return SetError(103, 0, 0)

	Local $vVer = __Ver('dbghelp.dll')
	If $vVer < 0x0501 Then Return SetError(2, 0, 0)

	$__g_vEnum = 0

	Local $iPE, $aRet, $iError = 0, $hLibrary = 0, $vWOW64 = Default
	If _WinAPI_IsWow64Process() Then
		$aRet = DllCall('kernel32.dll', 'bool', 'Wow64DisableWow64FsRedirection', 'ptr*', 0)
		If Not @error And $aRet[0] Then $vWOW64 = $aRet[1]
	EndIf
	Do
		$aRet = DllCall('kernel32.dll', 'dword', 'SearchPathW', 'ptr', 0, 'wstr', $sFilePath, 'ptr', 0, 'dword', 4096, 'wstr', '', 'ptr', 0)
		If @error Or Not $aRet[0] Then
			$iError = @error + 10
			ExitLoop
		EndIf
		$__g_vExt = $aRet[5]
		$iPE = _WinAPI_GetPEType($__g_vExt)
		Switch $iPE
			Case 0x014C
				; (x86): IMAGE_FILE_MACHINE_I386
			Case 0x0200, 0x8664
				; (x64): IMAGE_FILE_MACHINE_IA64, IMAGE_FILE_MACHINE_AMD64
			Case Else
				$iError = @error + 20
				ExitLoop
		EndSwitch
		$hLibrary = _WinAPI_LoadLibraryEx($__g_vExt, 0x00000003)
		If Not $hLibrary Then
			$iError = @error + 30
			ExitLoop
		EndIf
		If $vVer >= 0x0600 Then
			__EnumDllProcW($hLibrary, $sMask, $iFlags)
		Else
			__EnumDllProcA($hLibrary, $sMask, $iFlags)
		EndIf
		If @error Then
			$iError = @error + 40
			ExitLoop
		EndIf
	Until 1
	If $hLibrary Then
		_WinAPI_FreeLibrary($hLibrary)
	EndIf
	If Not ($vWOW64 = Default) Then
		DllCall('kernel32.dll', 'bool', 'Wow64RevertWow64FsRedirection', 'ptr*', $vWOW64)
	EndIf

	Return SetError($iError, $iPE, $__g_vEnum)
EndFunc   ;==>_WinAPI_EnumDllProc

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetApplicationRestartSettings($iPID = 0)
	If Not $iPID Then $iPID = @AutoItPID

	Local $hProcess = DllCall('kernel32.dll', 'handle', 'OpenProcess', 'dword', __Iif($__WINVER < 0x0600, 0x00000410, 0x00001010), _
			'bool', 0, 'dword', $iPID)
	If @error Or Not $hProcess[0] Then Return SetError(@error + 20, @extended, 0)

	Local $aRet = DllCall('kernel32.dll', 'uint', 'GetApplicationRestartSettings', 'handle', $hProcess[0], 'wstr', '', _
			'dword*', 4096, 'dword*', 0)
	Local $iError, $iExtended = @extended
	If @error Then
		$iError = @error
	ElseIf $aRet[0] Then
		$iError = 10
		$iExtended = $aRet[0]
	EndIf
	_WinAPI_CloseHandle($hProcess[0])
	If $iError Then Return SetError($iError, $iExtended, 0)

	Local $aResult[2]
	$aResult[0] = $aRet[2]
	$aResult[1] = $aRet[4]
	Return $aResult
EndFunc   ;==>_WinAPI_GetApplicationRestartSettings

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetErrorMessage($iCode, $iLanguage = 0)
	Local $aRet = DllCall('kernel32.dll', 'dword', 'FormatMessageW', 'dword', 0x1000, 'ptr', 0, 'dword', $iCode, _
			'dword', $iLanguage, 'wstr', '', 'dword', 4096, 'ptr', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, '')
	; If Not $aRet[0] Then Return SetError(1000, 0, '')

	Return StringRegExpReplace($aRet[5], '[' & @LF & ',' & @CR & ']*\Z', '')
EndFunc   ;==>_WinAPI_GetErrorMessage

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetErrorMode()
	Local $aRet = DllCall('kernel32.dll', 'uint', 'GetErrorMode')
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetErrorMode

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_IsInternetConnected()
	If Not __DLL('connect.dll') Then Return SetError(103, 0, 0)

	Local $aRet = DllCall('connect.dll', 'long', 'IsInternetConnected')
	If @error Then Return SetError(@error, @extended, 0)
	If Not ($aRet[0] = 0 Or $aRet[0] = 1) Then ; not S_OK nor S_FALSE
		Return SetError(10, $aRet[0], False)
	EndIf

	Return Not $aRet[0]
EndFunc   ;==>_WinAPI_IsInternetConnected

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_IsNetworkAlive()
	If Not __DLL('sensapi.dll') Then Return SetError(103, 0, 0)

	Local $aRet = DllCall('sensapi.dll', 'bool', 'IsNetworkAlive', 'int*', 0)
	Local $iLastError = _WinAPI_GetLastError()
	If $iLastError Then Return SetError(1, $iLastError, 0)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, $iLastError, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[1]
EndFunc   ;==>_WinAPI_IsNetworkAlive

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_NtStatusToDosError($iStatus)
	Local $aRet = DllCall('ntdll.dll', 'ulong', 'RtlNtStatusToDosError', 'long', $iStatus)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_NtStatusToDosError

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_RegisterApplicationRestart($iFlags = 0, $sCmd = '')
	Local $aRet = DllCall('kernel32.dll', 'long', 'RegisterApplicationRestart', 'wstr', $sCmd, 'dword', $iFlags)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_RegisterApplicationRestart

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_SetErrorMode($iMode)
	Local $aRet = DllCall('kernel32.dll', 'uint', 'SetErrorMode', 'uint', $iMode)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetErrorMode

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ShowLastError($sText = '', $bAbort = False, $iLanguage = 0, Const $_iCurrentError = @error, Const $_iCurrentExtended = @extended)
	Local $sError

	Local $iLastError = _WinAPI_GetLastError()
	While 1
		$sError = _WinAPI_GetErrorMessage($iLastError, $iLanguage)
		If @error And $iLanguage Then
			$iLanguage = 0
		Else
			ExitLoop
		EndIf
	WEnd
	If StringStripWS($sText, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
		$sText &= @CRLF & @CRLF
	Else
		$sText = ''
	EndIf
	_WinAPI_MsgBox(BitOR(0x00040000, BitShift(0x00000010, -2 * (Not $iLastError))), $iLastError, $sText & $sError)
	If $iLastError Then
		_WinAPI_SetLastError($iLastError)
		If $bAbort Then
			Exit $iLastError
		EndIf
	EndIf

	Return SetError($_iCurrentError, $_iCurrentExtended, 1)
EndFunc   ;==>_WinAPI_ShowLastError

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_UniqueHardwareID($iFlags = 0)
	Local $oService = ObjGet('winmgmts:\\.\root\cimv2')
	If Not IsObj($oService) Then Return SetError(1, 0, '')

	Local $oItems = $oService.ExecQuery('SELECT * FROM Win32_ComputerSystemProduct')
	If Not IsObj($oItems) Then Return SetError(2, 0, '')

	Local $sHw = '', $iExtended = 0
	For $oProperty In $oItems
		$sHw &= $oProperty.IdentifyingNumber
		$sHw &= $oProperty.Name
		$sHw &= $oProperty.SKUNumber
		$sHw &= $oProperty.UUID
		$sHw &= $oProperty.Vendor
		$sHw &= $oProperty.Version
	Next
	$sHw = StringStripWS($sHw, $STR_STRIPALL)
	If Not $sHw Then Return SetError(3, 0, '')

	Local $sText
	If BitAND($iFlags, 0x0001) Then
		$oItems = $oService.ExecQuery('SELECT * FROM Win32_BIOS')
		If Not IsObj($oItems) Then Return SetError(3, 0, '')

		$sText = ''
		For $oProperty In $oItems
			$sText &= $oProperty.IdentificationCode
			$sText &= $oProperty.Manufacturer
			$sText &= $oProperty.Name
			$sText &= $oProperty.SerialNumber
			$sText &= $oProperty.SMBIOSMajorVersion
			$sText &= $oProperty.SMBIOSMinorVersion
			;			$sText &= $oProperty.Version
		Next
		$sText = StringStripWS($sText, $STR_STRIPALL)
		If $sText Then
			$iExtended += 0x0001
			$sHw &= $sText
		EndIf
	EndIf
	If BitAND($iFlags, 0x0002) Then
		$oItems = $oService.ExecQuery('SELECT * FROM Win32_Processor')
		If Not IsObj($oItems) Then Return SetError(4, 0, '')

		$sText = ''
		For $oProperty In $oItems
			$sText &= $oProperty.Architecture
			$sText &= $oProperty.Family
			$sText &= $oProperty.Level
			$sText &= $oProperty.Manufacturer
			$sText &= $oProperty.Name
			$sText &= $oProperty.ProcessorId
			$sText &= $oProperty.Revision
			$sText &= $oProperty.Version
		Next
		$sText = StringStripWS($sText, $STR_STRIPALL)
		If $sText Then
			$iExtended += 0x0002
			$sHw &= $sText
		EndIf
	EndIf
	If BitAND($iFlags, 0x0004) Then
		$oItems = $oService.ExecQuery('SELECT * FROM Win32_PhysicalMedia')
		If Not IsObj($oItems) Then Return SetError(5, 0, '')

		$sText = ''
		For $oProperty In $oItems
			Switch _WinAPI_GetDriveBusType($oProperty.Tag)
				Case 0x03, 0x0B
					$sText &= $oProperty.SerialNumber
				Case Else

			EndSwitch
		Next
		$sText = StringStripWS($sText, $STR_STRIPALL)
		If $sText Then
			$iExtended += 0x0004
			$sHw &= $sText
		EndIf
	EndIf
	Local $sHash = __MD5($sHw)
	If Not $sHash Then Return SetError(6, 0, '')

	Return SetExtended($iExtended, '{' & StringMid($sHash, 1, 8) & '-' & StringMid($sHash, 9, 4) & '-' & StringMid($sHash, 13, 4) & '-' & StringMid($sHash, 17, 4) & '-' & StringMid($sHash, 21, 12) & '}')
EndFunc   ;==>_WinAPI_UniqueHardwareID

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_UnregisterApplicationRestart()
	Local $aRet = DllCall('kernel32.dll', 'long', 'UnregisterApplicationRestart')
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_UnregisterApplicationRestart

#EndRegion Public Functions

#Region Internal Functions

Func __DlgSubclassProc($sHwnd, $iMsg, $wParam, $lParam, $idLV, $pData)
	#forceref $idLV

	Switch $iMsg
		Case 0x004E ; WM_NOTIFY

			Local $tNMIA = DllStructCreate('hwnd;uint_ptr;' & __Iif(@AutoItX64, 'int;int', 'int') & ';int Item;int;uint;uint;uint;long;long;lparam;uint', $lParam)
			Local $hListView = DllStructGetData($tNMIA, 1)
			Local $nMsg = DllStructGetData($tNMIA, 3)
			Local $tParam = DllStructCreate('ptr;uint', $pData)
			Local $iDummy = DllStructGetData($tParam, 2)
			Local $hLV = DllStructGetData($tParam, 1)

			Switch $hListView
				Case $hLV
					Switch $nMsg
						Case -109 ; LVN_BEGINDRAG
							Return 0
						Case -114 ; LVN_ITEMACTIVATE
							If $iDummy Then
								GUICtrlSendToDummy($iDummy, DllStructGetData($tNMIA, 'Item'))
							EndIf
							Return 0
					EndSwitch
			EndSwitch
	EndSwitch
	Return _WinAPI_DefSubclassProc($sHwnd, $iMsg, $wParam, $lParam)
EndFunc   ;==>__DlgSubclassProc

Func __EnumDllProcA($hLibrary, $sMask, $iFlags)
	Local $hProcess, $pAddress = 0, $iInit = 0, $vOpts = Default, $iError = 0
	Local $sTypeOfMask = 'str'
	$__g_vEnum = 0
	Do
		Local $aRet = DllCall('dbghelp.dll', 'dword', 'SymGetOptions')
		If @error Then
			$iError = @error + 10
			ExitLoop
		EndIf
		$vOpts = $aRet[0]
		$aRet = DllCall('dbghelp.dll', 'dword', 'SymSetOptions', 'dword', BitOR(BitAND($iFlags, 0x00000003), 0x00000204))
		If @error Or Not $aRet[0] Then
			$iError = @error + 20
			ExitLoop
		EndIf
		$hProcess = _WinAPI_GetCurrentProcess()
		$aRet = DllCall('dbghelp.dll', 'int', 'SymInitialize', 'handle', $hProcess, 'ptr', 0, 'int', 1)
		If @error Or Not $aRet[0] Then
			$iError = @error + 30
			ExitLoop
		EndIf
		$iInit = 1
		$aRet = DllCall('dbghelp.dll', 'uint64', 'SymLoadModule64', 'handle', $hProcess, 'ptr', 0, 'str', $__g_vExt, 'ptr', 0, 'uint64', $hLibrary, 'dword', 0)
		If @error Or Not $aRet[0] Then
			$iError = @error + 40
			ExitLoop
		EndIf
		$pAddress = $aRet[0]
		Dim $__g_vEnum[501][2] = [[0]]
		Local $hEnumProc = DllCallbackRegister('__EnumSymbolsProcA', 'int', 'ptr;ulong;lparam')
		Local $pEnumProc = DllCallbackGetPtr($hEnumProc)
		If Not StringStripWS($sMask, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
			$sTypeOfMask = 'ptr'
			$sMask = 0
		EndIf
		$aRet = DllCall('dbghelp.dll', 'int', 'SymEnumSymbols', 'handle', $hProcess, 'uint64', $pAddress, $sTypeOfMask, $sMask, 'ptr', $pEnumProc, 'lparam', 0)
		If @error Or Not $aRet[0] Or (Not $__g_vEnum[0][0]) Then
			$iError = @error + 50
			$__g_vEnum = 0
		EndIf
		DllCallbackFree($hEnumProc)
		If IsArray($__g_vEnum) Then
			__Inc($__g_vEnum, -1)
		EndIf
	Until 1
	If $pAddress Then
		DllCall('dbghelp.dll', 'int', 'SymUnloadModule64', 'handle', $hProcess, 'uint64', $pAddress)
	EndIf
	If $iInit Then
		DllCall('dbghelp.dll', 'int', 'SymCleanup', 'handle', $hProcess)
	EndIf
	If Not ($vOpts = Default) Then
		DllCall('dbghelp.dll', 'dword', 'SymSetOptions', 'dword', $vOpts)
	EndIf
	If $iError Then Return SetError($iError, 0, 0)

	Return 1
EndFunc   ;==>__EnumDllProcA

Func __EnumDllProcW($hLibrary, $sMask, $iFlags)
	Local $hProcess, $pAddress = 0, $iInit = 0, $vOpts = Default, $iError = 0
	Local $sTypeOfMask = 'wstr'
	$__g_vEnum = 0
	Do
		Local $aRet = DllCall('dbghelp.dll', 'dword', 'SymGetOptions')
		If @error Then
			$iError = @error + 10
			ExitLoop
		EndIf
		$vOpts = $aRet[0]
		$aRet = DllCall('dbghelp.dll', 'dword', 'SymSetOptions', 'dword', BitOR(BitAND($iFlags, 0x00000003), 0x00000204))
		If @error Or Not $aRet[0] Then
			$iError = @error + 20
			ExitLoop
		EndIf
		$hProcess = _WinAPI_GetCurrentProcess()
		$aRet = DllCall('dbghelp.dll', 'int', 'SymInitializeW', 'handle', $hProcess, 'ptr', 0, 'int', 1)
		If @error Or Not $aRet[0] Then
			$iError = @error + 30
			ExitLoop
		EndIf
		$iInit = 1
		$aRet = DllCall('dbghelp.dll', 'uint64', 'SymLoadModuleExW', 'handle', $hProcess, 'ptr', 0, 'wstr', $__g_vExt, 'ptr', 0, 'uint64', $hLibrary, 'dword', 0, 'ptr', 0, 'dword', 0)
		If @error Or Not $aRet[0] Then
			$iError = @error + 40
			ExitLoop
		EndIf
		$pAddress = $aRet[0]
		Dim $__g_vEnum[501][2] = [[0]]
		Local $hEnumProc = DllCallbackRegister('__EnumSymbolsProcW', 'int', 'ptr;ulong;lparam')
		Local $pEnumProc = DllCallbackGetPtr($hEnumProc)
		If Not StringStripWS($sMask, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
			$sTypeOfMask = 'ptr'
			$sMask = 0
		EndIf
		$aRet = DllCall('dbghelp.dll', 'int', 'SymEnumSymbolsW', 'handle', $hProcess, 'uint64', $pAddress, $sTypeOfMask, $sMask, 'ptr', $pEnumProc, 'lparam', 0)
		If @error Or Not $aRet[0] Or Not $__g_vEnum[0][0] Then
			$iError = @error + 50
			$__g_vEnum = 0
		EndIf
		DllCallbackFree($hEnumProc)
		If IsArray($__g_vEnum) Then
			__Inc($__g_vEnum, -1)
		EndIf
	Until 1
	If $pAddress Then
		DllCall('dbghelp.dll', 'int', 'SymUnloadModule64', 'handle', $hProcess, 'uint64', $pAddress)
	EndIf
	If $iInit Then
		DllCall('dbghelp.dll', 'int', 'SymCleanup', 'handle', $hProcess)
	EndIf
	If Not ($vOpts = Default) Then
		DllCall('dbghelp.dll', 'dword', 'SymSetOptions', 'dword', $vOpts)
	EndIf
	If $iError Then Return SetError($iError, 0, 0)

	Return 1
EndFunc   ;==>__EnumDllProcW

Func __EnumSymbolsProcA($pSymInfo, $iSymSize, $lParam)
	#forceref $iSymSize, $lParam

	Local $tagSYMBOL_INFO = 'uint SizeOfStruct;uint TypeIndex;uint64 Reserved[2];uint Index;uint Size;uint64 ModBase;uint Flags;uint64 Value;uint64 Address;uint Register;uint Scope;uint Tag;uint NameLen;uint MaxNameLen;wchar Name[1]'
	Local $tSYMINFO = DllStructCreate($tagSYMBOL_INFO, $pSymInfo)
	Local $iLength = DllStructGetData($tSYMINFO, 'NameLen')

	If $iLength And BitAND(DllStructGetData($tSYMINFO, 'Flags'), 0x00000600) Then
		__Inc($__g_vEnum, 500)
		$__g_vEnum[$__g_vEnum[0][0]][0] = DllStructGetData($tSYMINFO, 'Address') - DllStructGetData($tSYMINFO, 'ModBase')
		$__g_vEnum[$__g_vEnum[0][0]][1] = DllStructGetData(DllStructCreate('char[' & ($iLength + 1) & ']', DllStructGetPtr($tSYMINFO, 'Name')), 1)
	EndIf
	Return 1
EndFunc   ;==>__EnumSymbolsProcA

Func __EnumSymbolsProcW($pSymInfo, $iSymSize, $lParam)
	#forceref $iSymSize, $lParam

	Local $tagSYMBOL_INFO = 'uint SizeOfStruct;uint TypeIndex;uint64 Reserved[2];uint Index;uint Size;uint64 ModBase;uint Flags;uint64 Value;uint64 Address;uint Register;uint Scope;uint Tag;uint NameLen;uint MaxNameLen;wchar Name[1]'
	Local $tSYMINFO = DllStructCreate($tagSYMBOL_INFO, $pSymInfo)
	Local $iLength = DllStructGetData($tSYMINFO, 'NameLen')

	If $iLength And BitAND(DllStructGetData($tSYMINFO, 'Flags'), 0x00000600) Then
		__Inc($__g_vEnum, 500)
		$__g_vEnum[$__g_vEnum[0][0]][0] = DllStructGetData($tSYMINFO, 'Address') - DllStructGetData($tSYMINFO, 'ModBase')
		$__g_vEnum[$__g_vEnum[0][0]][1] = DllStructGetData(DllStructCreate('wchar[' & ($iLength + 1) & ']', DllStructGetPtr($tSYMINFO, 'Name')), 1)
	EndIf
	Return 1
EndFunc   ;==>__EnumSymbolsProcW

Func __Hex($iValue, $sType)
	Local $iLength

	Switch $sType
		Case 'BYTE', 'BOOLEAN'
			$iLength = 2
		Case 'WORD', 'USHORT', 'short'
			$iLength = 4
		Case 'BOOL', 'UINT', 'ULONG', 'DWORD', 'int', 'long'
			$iLength = 8
		Case 'INT64', 'UINT64'
			$iLength = 16
		Case 'INT_PTR', 'UINT_PTR', 'LONG_PTR', 'ULONG_PTR', 'DWORD_PTR', 'WPARAM', 'LPARAM', 'LRESULT'
			$iLength = __Iif(@AutoItX64, 16, 8)
		Case Else
			$iLength = 0
	EndSwitch
	If $iLength Then
		Return '0x' & Hex($iValue, $iLength)
	Else
		Return $iValue
	EndIf
EndFunc   ;==>__Hex

Func __MD5($sData)
	Local $hHash, $iError = 0

	Local $hProv = DllCall('advapi32.dll', 'int', 'CryptAcquireContextW', 'ptr*', 0, 'ptr', 0, 'ptr', 0, 'dword', 3, 'dword', 0xF0000000)
	If @error Or Not $hProv[0] Then Return SetError(@error + 10, @extended, '')
	Do
		$hHash = DllCall('advapi32.dll', 'int', 'CryptCreateHash', 'handle', $hProv[1], 'uint', 0x00008003, 'ptr', 0, 'dword', 0, _
				'ptr*', 0)
		If @error Or Not $hHash[0] Then
			$iError = @error + 20
			$hHash = 0
			ExitLoop
		EndIf
		$hHash = $hHash[5]
		Local $tData = DllStructCreate('byte[' & BinaryLen($sData) & ']')
		DllStructSetData($tData, 1, $sData)
		Local $aRet = DllCall('advapi32.dll', 'int', 'CryptHashData', 'handle', $hHash, 'struct*', $tData, _
				'dword', DllStructGetSize($tData), 'dword', 1)
		If @error Or Not $aRet[0] Then
			$iError = @error + 30
			ExitLoop
		EndIf
		$tData = DllStructCreate('byte[16]')
		$aRet = DllCall('advapi32.dll', 'int', 'CryptGetHashParam', 'handle', $hHash, 'dword', 2, 'struct*', $tData, 'dword*', 16, _
				'dword', 0)
		If @error Or Not $aRet[0] Then
			$iError = @error + 40
			ExitLoop
		EndIf
	Until 1
	If $hHash Then
		DllCall('advapi32.dll', 'int', 'CryptDestroyHash', 'handle', $hHash)
	EndIf
	If $iError Then Return SetError($iError, 0, '')
	Return StringTrimLeft(DllStructGetData($tData, 1), 2)
EndFunc   ;==>__MD5

Func __Quit()
	Local $pDll = DllCallbackGetPtr($__g_hFRDll)
	If $pDll Then
		_WinAPI_RemoveWindowSubclass($__g_hFRDlg, $pDll, 1000)
		DllCallbackFree($__g_hFRDll)
	EndIf
	$__g_hFRDll = 0
EndFunc   ;==>__Quit

Func __Ver($sPath)
	Local $hLibrary = _WinAPI_GetModuleHandle($sPath)
	If Not $hLibrary Then Return SetError(@error + 10, @extended, 0)
	$sPath = _WinAPI_GetModuleFileNameEx(_WinAPI_GetCurrentProcess(), $hLibrary)
	If Not $sPath Then Return SetError(@error + 20, @extended, 0)
	Local $vVer = FileGetVersion($sPath)
	If @error Then Return SetError(1, 0, 0)
	$vVer = StringSplit($vVer, '.', $STR_NOCOUNT)
	If UBound($vVer) < 2 Then Return SetError(2, 0, 0)
	Return BitOR(BitShift(Number($vVer[0]), -8), Number($vVer[1]))
EndFunc   ;==>__Ver

#EndRegion Internal Functions
