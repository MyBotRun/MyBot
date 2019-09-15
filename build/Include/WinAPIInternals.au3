#include-once

#include "AutoItConstants.au3"
#include "MsgBoxConstants.au3"
#include "StructureConstants.au3"
#include "WinAPIError.au3"

; #INDEX# =======================================================================================================================
; Title .........: WinAPI Extended UDF Library for AutoIt3
; AutoIt Version : 3.3.14.2
; Description ...: Additional variables, constants and functions for the WinAPIxxx.au3
; Author(s) .....: Yashied, jpm
; ===============================================================================================================================

#Region Global Variables and Constants

; #VARIABLES# ===================================================================================================================
Global $__g_vEnum, $__g_vExt = 0
Global $__g_hHeap = 0, $__g_iRGBMode = 1
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $tagOSVERSIONINFO = 'struct;dword OSVersionInfoSize;dword MajorVersion;dword MinorVersion;dword BuildNumber;dword PlatformId;wchar CSDVersion[128];endstruct'

Global Const $__WINVER = __WINVER()
; ===============================================================================================================================

#EndRegion Global Variables and Constants

#Region Functions list

; #CURRENT# =====================================================================================================================
; Doc in WinAPIMisc
; _WinAPI_ArrayToStruct
; _WinAPI_CreateMargins
; _WinAPI_CreatePoint
; _WinAPI_CreateRect
; _WinAPI_CreateRectEx
; _WinAPI_CreateSize
; _WinAPI_GetString
; _WinAPI_StrLen
; _WinAPI_StructToArray
;
; Doc in WinAPIDiag
; _WinAPI_FatalExit
;
; Doc in WinAPIGdi
; _WinAPI_GetBitmapDimension
; _WinAPI_SwitchColor
;
; Doc in WinAPISys
; _WinAPI_IsBadReadPtr
; _WinAPI_IsBadWritePtr
; _WinAPI_MoveMemory
; _WinAPI_ZeroMemory
;
; Doc in WinAPIProc
; _WinAPI_IsWow64Process
; _WinAPI_PathIsDirectory

; Doc in WinAPIMisc
; _WinAPI_SwapDWord
; _WinAPI_SwapQWord
; _WinAPI_SwapWord
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; __CheckErrorArrayBounds
; __CheckErrorCloseHandle
; __DLL
; __EnumWindowsProc
; __FatalExit
; __HeapAlloc
; __HeapFree
; __HeapReAlloc
; __HeapSize
; __HeapValidate
; __Iif
; __Inc
; __Init
; __RGB
; __WINVER()
; ===============================================================================================================================

#EndRegion Functions list

#Region Public Functions

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ArrayToStruct(Const ByRef $aData, $iStart = 0, $iEnd = -1)
	If __CheckErrorArrayBounds($aData, $iStart, $iEnd) Then Return SetError(@error + 10, @extended, 0)

	Local $tagStruct = ''
	For $i = $iStart To $iEnd
		$tagStruct &= 'wchar[' & (StringLen($aData[$i]) + 1) & '];'
	Next
	Local $tData = DllStructCreate($tagStruct & 'wchar[1]')

	Local $iCount = 1
	For $i = $iStart To $iEnd
		DllStructSetData($tData, $iCount, $aData[$i])
		$iCount += 1
	Next
	DllStructSetData($tData, $iCount, ChrW(0))
	Return $tData
EndFunc   ;==>_WinAPI_ArrayToStruct

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CreateMargins($iLeftWidth, $iRightWidth, $iTopHeight, $iBottomHeight)
	Local $tMARGINS = DllStructCreate($tagMARGINS)

	DllStructSetData($tMARGINS, 1, $iLeftWidth)
	DllStructSetData($tMARGINS, 2, $iRightWidth)
	DllStructSetData($tMARGINS, 3, $iTopHeight)
	DllStructSetData($tMARGINS, 4, $iBottomHeight)

	Return $tMARGINS
EndFunc   ;==>_WinAPI_CreateMargins

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_CreatePoint($iX, $iY)
	Local $tPOINT = DllStructCreate($tagPOINT)
	DllStructSetData($tPOINT, 1, $iX)
	DllStructSetData($tPOINT, 2, $iY)

	Return $tPOINT
EndFunc   ;==>_WinAPI_CreatePoint

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_CreateRect($iLeft, $iTop, $iRight, $iBottom)
	Local $tRECT = DllStructCreate($tagRECT)
	DllStructSetData($tRECT, 1, $iLeft)
	DllStructSetData($tRECT, 2, $iTop)
	DllStructSetData($tRECT, 3, $iRight)
	DllStructSetData($tRECT, 4, $iBottom)

	Return $tRECT
EndFunc   ;==>_WinAPI_CreateRect

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_CreateRectEx($iX, $iY, $iWidth, $iHeight)
	Local $tRECT = DllStructCreate($tagRECT)
	DllStructSetData($tRECT, 1, $iX)
	DllStructSetData($tRECT, 2, $iY)
	DllStructSetData($tRECT, 3, $iX + $iWidth)
	DllStructSetData($tRECT, 4, $iY + $iHeight)

	Return $tRECT
EndFunc   ;==>_WinAPI_CreateRectEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_CreateSize($iWidth, $iHeight)
	Local $tSIZE = DllStructCreate($tagSIZE)
	DllStructSetData($tSIZE, 1, $iWidth)
	DllStructSetData($tSIZE, 2, $iHeight)

	Return $tSIZE
EndFunc   ;==>_WinAPI_CreateSize

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_FatalExit($iCode)
	DllCall('kernel32.dll', 'none', 'FatalExit', 'int', $iCode)
	If @error Then Return SetError(@error, @extended)
EndFunc   ;==>_WinAPI_FatalExit

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetBitmapDimension($hBitmap)
	Local Const $tagBITMAP = 'struct;long bmType;long bmWidth;long bmHeight;long bmWidthBytes;ushort bmPlanes;ushort bmBitsPixel;ptr bmBits;endstruct'
	Local $tObj = DllStructCreate($tagBITMAP)
	Local $aRet = DllCall('gdi32.dll', 'int', 'GetObject', 'handle', $hBitmap, 'int', DllStructGetSize($tObj), 'struct*', $tObj)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return _WinAPI_CreateSize(DllStructGetData($tObj, 'bmWidth'), DllStructGetData($tObj, 'bmHeight'))
EndFunc   ;==>_WinAPI_GetBitmapDimension

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetString($pString, $bUnicode = True)
	Local $iLength = _WinAPI_StrLen($pString, $bUnicode)
	If @error Or Not $iLength Then Return SetError(@error + 10, @extended, '')

	Local $tString = DllStructCreate(__Iif($bUnicode, 'wchar', 'char') & '[' & ($iLength + 1) & ']', $pString)
	If @error Then Return SetError(@error, @extended, '')

	Return SetExtended($iLength, DllStructGetData($tString, 1))
EndFunc   ;==>_WinAPI_GetString

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_IsBadReadPtr($pAddress, $iLength)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'IsBadReadPtr', 'struct*', $pAddress, 'uint_ptr', $iLength)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_IsBadReadPtr

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_IsBadWritePtr($pAddress, $iLength)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'IsBadWritePtr', 'struct*', $pAddress, 'uint_ptr', $iLength)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_IsBadWritePtr

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_IsWow64Process($iPID = 0)
	If Not $iPID Then $iPID = @AutoItPID

	Local $hProcess = DllCall('kernel32.dll', 'handle', 'OpenProcess', 'dword', __Iif($__WINVER < 0x0600, 0x00000400, 0x00001000), _
			'bool', 0, 'dword', $iPID)
	If @error Or Not $hProcess[0] Then Return SetError(@error + 20, @extended, False)

	Local $aRet = DllCall('kernel32.dll', 'bool', 'IsWow64Process', 'handle', $hProcess[0], 'bool*', 0)
	If __CheckErrorCloseHandle($aRet, $hProcess[0]) Then Return SetError(@error, @extended, False)

	Return $aRet[2]
EndFunc   ;==>_WinAPI_IsWow64Process

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_MoveMemory($pDestination, $pSource, $iLength)
	If _WinAPI_IsBadReadPtr($pSource, $iLength) Then Return SetError(10, @extended, 0)
	If _WinAPI_IsBadWritePtr($pDestination, $iLength) Then Return SetError(11, @extended, 0)

	DllCall('ntdll.dll', 'none', 'RtlMoveMemory', 'struct*', $pDestination, 'struct*', $pSource, 'ulong_ptr', $iLength)
	If @error Then Return SetError(@error, @extended, 0)

	Return 1
EndFunc   ;==>_WinAPI_MoveMemory

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_PathIsDirectory($sFilePath)
	Local $aRet = DllCall('shlwapi.dll', 'bool', 'PathIsDirectoryW', 'wstr', $sFilePath)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_PathIsDirectory

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_StrLen($pString, $bUnicode = True)
	Local $W = ''
	If $bUnicode Then $W = 'W'

	Local $aRet = DllCall('kernel32.dll', 'int', 'lstrlen' & $W, 'struct*', $pString)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_StrLen

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_StructToArray(ByRef $tStruct, $iItems = 0)
	Local $iSize = 2 * Floor(DllStructGetSize($tStruct) / 2)
	Local $pStruct = DllStructGetPtr($tStruct)

	If Not $iSize Or Not $pStruct Then Return SetError(1, 0, 0)

	Local $tData, $iLength, $iOffset = 0
	Local $aResult[101] = [0]

	While 1
		$iLength = _WinAPI_StrLen($pStruct + $iOffset)
		If Not $iLength Then
			ExitLoop
		EndIf
		If 2 * (1 + $iLength) + $iOffset > $iSize Then Return SetError(3, 0, 0)
		$tData = DllStructCreate('wchar[' & (1 + $iLength) & ']', $pStruct + $iOffset)
		If @error Then Return SetError(@error + 10, 0, 0)
		__Inc($aResult)
		$aResult[$aResult[0]] = DllStructGetData($tData, 1)
		If $aResult[0] = $iItems Then
			ExitLoop
		EndIf
		$iOffset += 2 * (1 + $iLength)
		If $iOffset >= $iSize Then Return SetError(3, 0, 0)
	WEnd
	If Not $aResult[0] Then Return SetError(2, 0, 0)

	__Inc($aResult, -1)
	Return $aResult
EndFunc   ;==>_WinAPI_StructToArray

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_SwapDWord($iValue)
	Local $tStruct1 = DllStructCreate('dword;dword')
	Local $tStruct2 = DllStructCreate('byte[4];byte[4]', DllStructGetPtr($tStruct1))
	DllStructSetData($tStruct1, 1, $iValue)
	For $i = 1 To 4
		DllStructSetData($tStruct2, 2, DllStructGetData($tStruct2, 1, 5 - $i), $i)
	Next

	Return DllStructGetData($tStruct1, 2)
EndFunc   ;==>_WinAPI_SwapDWord

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_SwapQWord($iValue)
	Local $tStruct1 = DllStructCreate('int64;int64')
	Local $tStruct2 = DllStructCreate('byte[8];byte[8]', DllStructGetPtr($tStruct1))
	DllStructSetData($tStruct1, 1, $iValue)
	For $i = 1 To 8
		DllStructSetData($tStruct2, 2, DllStructGetData($tStruct2, 1, 9 - $i), $i)
	Next

	Return DllStructGetData($tStruct1, 2)
EndFunc   ;==>_WinAPI_SwapQWord

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_SwapWord($iValue)
	Local $tStruct1 = DllStructCreate('word;word')
	Local $tStruct2 = DllStructCreate('byte[2];byte[2]', DllStructGetPtr($tStruct1))
	DllStructSetData($tStruct1, 1, $iValue)
	For $i = 1 To 2
		DllStructSetData($tStruct2, 2, DllStructGetData($tStruct2, 1, 3 - $i), $i)
	Next

	Return DllStructGetData($tStruct1, 2)
EndFunc   ;==>_WinAPI_SwapWord

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_SwitchColor($iColor)
	If $iColor = -1 Then Return $iColor
	Return BitOR(BitAND($iColor, 0x00FF00), BitShift(BitAND($iColor, 0x0000FF), -16), BitShift(BitAND($iColor, 0xFF0000), 16))
EndFunc   ;==>_WinAPI_SwitchColor

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_ZeroMemory($pMemory, $iLength)
	If _WinAPI_IsBadWritePtr($pMemory, $iLength) Then Return SetError(11, @extended, 0)

	DllCall('ntdll.dll', 'none', 'RtlZeroMemory', 'struct*', $pMemory, 'ulong_ptr', $iLength)
	If @error Then Return SetError(@error, @extended, 0)

	Return 1
EndFunc   ;==>_WinAPI_ZeroMemory

#EndRegion Public Functions

#Region Internal Functions

Func __CheckErrorArrayBounds(Const ByRef $aData, ByRef $iStart, ByRef $iEnd, $nDim = 1, $iDim = $UBOUND_DIMENSIONS)
	; Bounds checking
	If Not IsArray($aData) Then Return SetError(1, 0, 1)
	If UBound($aData, $iDim) <> $nDim Then Return SetError(2, 0, 1)

	If $iStart < 0 Then $iStart = 0

	Local $iUBound = UBound($aData) - 1
	If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound

	If $iStart > $iEnd Then Return SetError(4, 0, 1)

	Return 0
EndFunc   ;==>__CheckErrorArrayBounds

Func __CheckErrorCloseHandle($aRet, $hFile, $bLastError = 0, $iCurErr = @error, $iCurExt = @extended)
	If Not $iCurErr And Not $aRet[0] Then $iCurErr = 10
	Local $iLastError = _WinAPI_GetLastError()
	DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hFile)
	If $iCurErr Then _WinAPI_SetLastError($iLastError)
	If $bLastError Then $iCurExt = $iLastError
	Return SetError($iCurErr, $iCurExt, $iCurErr)
EndFunc   ;==>__CheckErrorCloseHandle

Func __DLL($sPath, $bPin = False)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'GetModuleHandleExW', 'dword', __Iif($bPin, 0x0001, 0x0002), "wstr", $sPath, 'ptr*', 0)
	If Not $aRet[3] Then
		Local $aResult = DllCall("kernel32.dll", "handle", "LoadLibraryW", "wstr", $sPath)
		If Not $aResult[0] Then Return 0
	EndIf
	Return 1
EndFunc   ;==>__DLL

Func __EnumWindowsProc($hWnd, $bVisible)
	Local $aResult
	If $bVisible Then
		$aResult = DllCall("user32.dll", "bool", "IsWindowVisible", "hwnd", $hWnd)
		If Not $aResult[0] Then
			Return 1
		EndIf
	EndIf
	__Inc($__g_vEnum)
	$__g_vEnum[$__g_vEnum[0][0]][0] = $hWnd
	$aResult = DllCall("user32.dll", "int", "GetClassNameW", "hwnd", $hWnd, "wstr", "", "int", 4096)
	$__g_vEnum[$__g_vEnum[0][0]][1] = $aResult[2]
	Return 1
EndFunc   ;==>__EnumWindowsProc

Func __FatalExit($iCode, $sText = '')
	If $sText Then MsgBox($MB_SYSTEMMODAL, 'AutoIt', $sText)
	_WinAPI_FatalExit($iCode)
EndFunc   ;==>__FatalExit

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __HeapAlloc
; Description ...:
; Syntax ........: __HeapAlloc($iSize[, $bAbort = False])
; Parameters ....: $iSize               - An integer value.
;                  $bAbort              - [optional] Abort the script if error. Default is False.
; Return values .: Success - a pointer to the allocated memory block
;                  Failure - Set the @error flag to 30+
; Author ........: Yashied
; Modified ......: jpm
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ HeapAlloc
; Example .......:
; ===============================================================================================================================
Func __HeapAlloc($iSize, $bAbort = False)
	Local $aRet
	If Not $__g_hHeap Then
		$aRet = DllCall('kernel32.dll', 'handle', 'HeapCreate', 'dword', 0, 'ulong_ptr', 0, 'ulong_ptr', 0)
		If @error Or Not $aRet[0] Then __FatalExit(1, 'Error allocating memory.')
		$__g_hHeap = $aRet[0]
	EndIf

	$aRet = DllCall('kernel32.dll', 'ptr', 'HeapAlloc', 'handle', $__g_hHeap, 'dword', 0x00000008, 'ulong_ptr', $iSize) ; HEAP_ZERO_MEMORY
	If @error Or Not $aRet[0] Then
		If $bAbort Then __FatalExit(1, 'Error allocating memory.')
		Return SetError(@error + 30, @extended, 0)
	EndIf
	Return $aRet[0]
EndFunc   ;==>__HeapAlloc

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __HeapFree
; Description ...:
; Syntax ........: __HeapFree(Byref $pMemory[, $bCheck = False])
; Parameters ....: $pMemory             - [in/out] A pointer value.
;                  $bCheck              - [optional] Check valid pointer. Default is False (see remarks).
; Return values .: Success - 1.
;                  Failure - Set the @error flag to 1 to 9 or 40+
; Author ........: Yashied
; Modified ......: jpm
; Remarks .......: @error and @extended are preserved when return if no error
; Related .......:
; Link ..........: @@MsdnLink@@ HeapFree
; Example .......: No
; ===============================================================================================================================
Func __HeapFree(ByRef $pMemory, $bCheck = False, $iCurErr = @error, $iCurExt = @extended)
	If $bCheck And (Not __HeapValidate($pMemory)) Then Return SetError(@error, @extended, 0)

	Local $aRet = DllCall('kernel32.dll', 'int', 'HeapFree', 'handle', $__g_hHeap, 'dword', 0, 'ptr', $pMemory)
	If @error Or Not $aRet[0] Then Return SetError(@error + 40, @extended, 0)

	$pMemory = 0
	Return SetError($iCurErr, $iCurExt, 1)
EndFunc   ;==>__HeapFree

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __HeapReAlloc
; Description ...:
; Syntax ........: __HeapReAlloc($pMemory, $iSize[, $bAmount = 0[, $bAbort = 0]])
; Parameters ....: $pMemory             - A pointer value.
;                  $iSize               - An integer value.
;                  $bAmount             - [optional] A boolean value. Default is False.
;                  $bAbort              - [optional] A boolean value. Default is False.
; Return values .: Success -  a pointer to the allocated memory bloc
;                  Failure - 0 and sets the @error flag to 1 to 20+ or 30+ if no previous allocation
; Author ........: Yashied
; Modified ......: jpm
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ HeapReAlloc
; Example .......: No
; ===============================================================================================================================
Func __HeapReAlloc($pMemory, $iSize, $bAmount = False, $bAbort = False)
	Local $aRet, $pRet
	If __HeapValidate($pMemory) Then
		If $bAmount And (__HeapSize($pMemory) >= $iSize) Then Return SetExtended(1, Ptr($pMemory))

		$aRet = DllCall('kernel32.dll', 'ptr', 'HeapReAlloc', 'handle', $__g_hHeap, 'dword', 0x00000008, 'ptr', $pMemory, _
				'ulong_ptr', $iSize) ; HEAP_ZERO_MEMORY
		If @error Or Not $aRet[0] Then
			If $bAbort Then __FatalExit(1, 'Error allocating memory.')
			Return SetError(@error + 20, @extended, Ptr($pMemory))
		EndIf
		$pRet = $aRet[0]
	Else
		$pRet = __HeapAlloc($iSize, $bAbort)
		If @error Then Return SetError(@error, @extended, 0)
	EndIf
	Return $pRet
EndFunc   ;==>__HeapReAlloc

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __HeapSize
; Description ...:
; Syntax ........: __HeapSize($pMemory[, $bCheck = False])
; Parameters ....: $pMemory             - A pointer value.
;                  $bCheck              - [optional] A boolean value. Default is False.
; Return values .: Success - the requested size of the allocated memory block, in bytes.
;                  Failure - 0 and sets the @error flag to 1 to 9 or 50+
; Modified ......: jpm
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ HeapSize
; Example .......:
; ===============================================================================================================================
Func __HeapSize($pMemory, $bCheck = False)
	If $bCheck And (Not __HeapValidate($pMemory)) Then Return SetError(@error, @extended, 0)

	Local $aRet = DllCall('kernel32.dll', 'ulong_ptr', 'HeapSize', 'handle', $__g_hHeap, 'dword', 0, 'ptr', $pMemory)
	If @error Or ($aRet[0] = Ptr(-1)) Then Return SetError(@error + 50, @extended, 0)
	Return $aRet[0]
EndFunc   ;==>__HeapSize

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __HeapValidate
; Description ...:
; Syntax ........: __HeapValidate($pMemory)
; Parameters ....: $pMemory             - A pointer value.
; Return values .: Success - True.
;                  Failure - False and sets the @error flag to 1 to 9.
; Author ........: Yashied
; Modified ......: jpm
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ HeapValidate
; Example .......:
; ===============================================================================================================================
Func __HeapValidate($pMemory)
	If (Not $__g_hHeap) Or (Not Ptr($pMemory)) Then Return SetError(9, 0, False)

	Local $aRet = DllCall('kernel32.dll', 'int', 'HeapValidate', 'handle', $__g_hHeap, 'dword', 0, 'ptr', $pMemory)
	If @error Then Return SetError(@error, @extended, False)
	Return $aRet[0]
EndFunc   ;==>__HeapValidate

Func __Inc(ByRef $aData, $iIncrement = 100)
	Select
		Case UBound($aData, $UBOUND_COLUMNS)
			If $iIncrement < 0 Then
				ReDim $aData[$aData[0][0] + 1][UBound($aData, $UBOUND_COLUMNS)]
			Else
				$aData[0][0] += 1
				If $aData[0][0] > UBound($aData) - 1 Then
					ReDim $aData[$aData[0][0] + $iIncrement][UBound($aData, $UBOUND_COLUMNS)]
				EndIf
			EndIf
		Case UBound($aData, $UBOUND_ROWS)
			If $iIncrement < 0 Then
				ReDim $aData[$aData[0] + 1]
			Else
				$aData[0] += 1
				If $aData[0] > UBound($aData) - 1 Then
					ReDim $aData[$aData[0] + $iIncrement]
				EndIf
			EndIf
		Case Else
			Return 0
	EndSelect
	Return 1
EndFunc   ;==>__Inc

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __Iif
; Description ...:
; Syntax ........: __Iif($bTest, $iTrue, $iFalse)
; Parameters ....: $bTest               - A boolean value.
;                  $vTrue               - An integer value.
;                  $vFalse              - An integer value.
; Return values .: depending $bTest : $vTrue if True  Or $vFalse is False
; Author ........: Yashied
; Modified ......: Jpm
; Remarks .......: For Internal Use Only
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __Iif($bTest, $vTrue, $vFalse)
	Return $bTest ? $vTrue : $vFalse
EndFunc   ;==>__Iif

Func __Init($dData)
	Local $iLength = BinaryLen($dData)
	Local $aRet = DllCall('kernel32.dll', 'ptr', 'VirtualAlloc', 'ptr', 0, 'ulong_ptr', $iLength, 'dword', 0x00001000, 'dword', 0x00000040)
	If @error Or Not $aRet[0] Then __FatalExit(1, 'Error allocating memory.')
	Local $tData = DllStructCreate('byte[' & $iLength & "]", $aRet[0])
	DllStructSetData($tData, 1, $dData)
	Return $aRet[0]
EndFunc   ;==>__Init

Func __RGB($iColor)
	If $__g_iRGBMode Then
		$iColor = _WinAPI_SwitchColor($iColor)
	EndIf
	Return $iColor
EndFunc   ;==>__RGB

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __WINVER
; Description ...: Retrieves version of the current operating system
; Syntax.........: __WINVER ( )
; Parameters ....: none
; Return values .: Returns the binary version of the current OS.
;                            0x0603 - Windows 8.1
;                            0x0602 - Windows 8 / Windows Server 2012
;                            0x0601 - Windows 7 / Windows Server 2008 R2
;                            0x0600 - Windows Vista / Windows Server 2008
;                            0x0502 - Windows XP 64-Bit Edition / Windows Server 2003 / Windows Server 2003 R2
;                            0x0501 - Windows XP
; Author ........: Yashield
; Modified.......:
; Remarks .......: For Internal Use Only
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __WINVER()
	Local $tOSVI = DllStructCreate($tagOSVERSIONINFO)
	DllStructSetData($tOSVI, 1, DllStructGetSize($tOSVI))

	Local $aRet = DllCall('kernel32.dll', 'bool', 'GetVersionExW', 'struct*', $tOSVI)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
	Return BitOR(BitShift(DllStructGetData($tOSVI, 2), -8), DllStructGetData($tOSVI, 3))
EndFunc   ;==>__WINVER

#EndRegion Internal Functions
