#include-once

#include "APISysConstants.au3"
#include "WinAPI.au3"
#include "WinAPIInternals.au3"

; #INDEX# =======================================================================================================================
; Title .........: WinAPI Extended UDF Library for AutoIt3
; AutoIt Version : 3.3.14.2
; Description ...: Additional variables, constants and functions for the WinAPISys.au3
; Author(s) .....: Yashied, jpm
; ===============================================================================================================================

#Region Global Variables and Constants

; #CONSTANTS# ===================================================================================================================
Global Const $tagOSVERSIONINFOEX = $tagOSVERSIONINFO & ';ushort ServicePackMajor;ushort ServicePackMinor;ushort SuiteMask;byte ProductType;byte Reserved'
Global Const $tagRAWINPUTDEVICE = 'struct;ushort UsagePage;ushort Usage;dword Flags;hwnd hTarget;endstruct'
Global Const $tagRAWINPUTHEADER = 'struct;dword Type;dword Size;handle hDevice;wparam wParam;endstruct'
Global Const $tagRAWMOUSE = 'ushort Flags;ushort Alignment;ushort ButtonFlags;ushort ButtonData;ulong RawButtons;long LastX;long LastY;ulong ExtraInformation;'
Global Const $tagRAWKEYBOARD = 'ushort MakeCode;ushort Flags;ushort Reserved;ushort VKey;uint Message;ulong ExtraInformation;'
Global Const $tagRAWHID = 'dword SizeHid;dword Count;' ; & 'byte RawData[n];'
Global Const $tagRAWINPUTMOUSE = $tagRAWINPUTHEADER & ';' & $tagRAWMOUSE
Global Const $tagRAWINPUTKEYBOARD = $tagRAWINPUTHEADER & ';' & $tagRAWKEYBOARD
Global Const $tagRAWINPUTHID = $tagRAWINPUTHEADER & ';' & $tagRAWHID
Global Const $tagRID_DEVICE_INFO_MOUSE = 'struct;dword Id;dword NumberOfButtons;dword SampleRate;int HasHorizontalWheel;endstruc'
Global Const $tagRID_DEVICE_INFO_KEYBOARD = 'struct;dword KbType;dword KbSubType;dword KeyboardMode;dword NumberOfFunctionKeys;dword NumberOfIndicators;dword NumberOfKeysTotal;endstruc'
Global Const $tagRID_DEVICE_INFO_HID = 'struct;dword VendorId;dword ProductId;dword VersionNumber;ushort UsagePage;ushort Usage;endstruc'
Global Const $tagRID_INFO_MOUSE = 'dword Size;dword Type;' & $tagRID_DEVICE_INFO_MOUSE & ';dword Unused[2];'
Global Const $tagRID_INFO_KEYBOARD = 'dword Size;dword Type;' & $tagRID_DEVICE_INFO_KEYBOARD
Global Const $tagRID_INFO_HID = 'dword Size;dword Type;' & $tagRID_DEVICE_INFO_HID & ';dword Unused[2]'
Global Const $tagSHELLHOOKINFO = 'hwnd hWnd;' & $tagRECT
Global Const $tagUPDATELAYEREDWINDOWINFO = 'dword Size;hwnd hDstDC;long DstX;long DstY;long cX;long cY;hwnd hSrcDC;long SrcX;long SrcY;dword crKey;byte BlendOp;byte BlendFlags;byte Alpha;byte AlphaFormat;dword Flags;long DirtyLeft;long DirtyTop;long DirtyRight;long DirtyBottom'
Global Const $tagUSEROBJECTFLAGS = 'int Inherit;int Reserved;dword Flags'
Global Const $tagWINDOWINFO = 'dword Size;struct;long rWindow[4];endstruct;struct;long rClient[4];endstruct;dword Style;dword ExStyle;dword WindowStatus;uint cxWindowBorders;uint cyWindowBorders;word atomWindowType;word CreatorVersion'
Global Const $tagWNDCLASS = 'uint Style;ptr hWndProc;int ClsExtra;int WndExtra;ptr hInstance;ptr hIcon;ptr hCursor;ptr hBackground;ptr MenuName;ptr ClassName'
Global Const $tagWNDCLASSEX = 'uint Size;uint Style;ptr hWndProc;int ClsExtra;int WndExtra;ptr hInstance;ptr hIcon;ptr hCursor;ptr hBackground;ptr MenuName;ptr ClassName;ptr hIconSm'
; ===============================================================================================================================
#EndRegion Global Variables and Constants

#Region Functions list

; #CURRENT# =====================================================================================================================
; _WinAPI_ActivateKeyboardLayout
; _WinAPI_AddClipboardFormatListener
; _WinAPI_AdjustWindowRectEx
; _WinAPI_AnimateWindow
; _WinAPI_BeginDeferWindowPos
; _WinAPI_BringWindowToTop
; _WinAPI_BroadcastSystemMessage
; _WinAPI_CallWindowProcW
; _WinAPI_CascadeWindows
; _WinAPI_ChangeWindowMessageFilterEx
; _WinAPI_ChildWindowFromPointEx
; _WinAPI_CloseDesktop
; _WinAPI_CloseWindow
; _WinAPI_CloseWindowStation
; _WinAPI_CompressBuffer
; _WinAPI_ComputeCrc32
; _WinAPI_CreateBuffer
; _WinAPI_CreateBufferFromStruct
; _WinAPI_CreateDesktop
; _WinAPI_CreateString
; _WinAPI_CreateWindowStation
; _WinAPI_DecompressBuffer
; _WinAPI_DeferWindowPos
; _WinAPI_DefRawInputProc
; _WinAPI_DefWindowProcW
; _WinAPI_DeregisterShellHookWindow
; _WinAPI_DragAcceptFiles
; _WinAPI_DragFinish
; _WinAPI_DragQueryFileEx
; _WinAPI_DragQueryPoint
; _WinAPI_EndDeferWindowPos
; _WinAPI_EnumChildWindows
; _WinAPI_EnumDesktops
; _WinAPI_EnumDesktopWindows
; _WinAPI_EnumPageFiles
; _WinAPI_EnumRawInputDevices
; _WinAPI_EnumWindowStations
; _WinAPI_EqualMemory
; _WinAPI_FillMemory
; _WinAPI_FreeMemory
; _WinAPI_GetActiveWindow
; _WinAPI_GetClassInfoEx
; _WinAPI_GetClassLongEx
; _WinAPI_GetClipboardSequenceNumber
; _WinAPI_GetCurrentHwProfile
; _WinAPI_GetDefaultPrinter
; _WinAPI_GetDllDirectory
; _WinAPI_GetEffectiveClientRect
; _WinAPI_GetGUIThreadInfo
; _WinAPI_GetHandleInformation
; _WinAPI_GetIdleTime
; _WinAPI_GetKeyboardLayout
; _WinAPI_GetKeyboardLayoutList
; _WinAPI_GetKeyboardState
; _WinAPI_GetKeyboardType
; _WinAPI_GetKeyNameText
; _WinAPI_GetKeyState
; _WinAPI_GetLastActivePopup
; _WinAPI_GetMemorySize
; _WinAPI_GetMessageExtraInfo
; _WinAPI_GetModuleHandleEx
; _WinAPI_GetMonitorInfo
; _WinAPI_GetMUILanguage
; _WinAPI_GetObjectInfoByHandle
; _WinAPI_GetObjectNameByHandle
; _WinAPI_GetPerformanceInfo
; _WinAPI_GetPhysicallyInstalledSystemMemory
; _WinAPI_GetProcessShutdownParameters
; _WinAPI_GetProcessWindowStation
; _WinAPI_GetPwrCapabilities
; _WinAPI_GetRawInputBuffer
; _WinAPI_GetRawInputBufferLength
; _WinAPI_GetRawInputData
; _WinAPI_GetRawInputDeviceInfo
; _WinAPI_GetRegisteredRawInputDevices
; _WinAPI_GetShellWindow
; _WinAPI_GetStartupInfo
; _WinAPI_GetSystemDEPPolicy
; _WinAPI_GetSystemInfo
; _WinAPI_GetSystemPowerStatus
; _WinAPI_GetSystemTimes
; _WinAPI_GetSystemWow64Directory
; _WinAPI_GetTickCount
; _WinAPI_GetTickCount64
; _WinAPI_GetTopWindow
; _WinAPI_GetUserObjectInformation
; _WinAPI_GetVersion
; _WinAPI_GetVersionEx
; _WinAPI_GetWindowDisplayAffinity
; _WinAPI_GetWindowInfo
; _WinAPI_GetWorkArea
; _WinAPI_InitMUILanguage
; _WinAPI_IsBadCodePtr
; _WinAPI_IsBadReadPtr
; _WinAPI_IsBadStringPtr
; _WinAPI_IsBadWritePtr
; _WinAPI_IsChild
; _WinAPI_IsHungAppWindow
; _WinAPI_IsIconic
; _WinAPI_IsLoadKBLayout
; _WinAPI_IsMemory
; _WinAPI_IsProcessorFeaturePresent
; _WinAPI_IsWindowEnabled
; _WinAPI_IsWindowUnicode
; _WinAPI_IsZoomed
; _WinAPI_Keybd_Event
; _WinAPI_KillTimer
; _WinAPI_LoadIconMetric
; _WinAPI_LoadIconWithScaleDown
; _WinAPI_LoadKeyboardLayout
; _WinAPI_LockWorkStation
; _WinAPI_MapVirtualKey
; _WinAPI_MirrorIcon
; _WinAPI_MoveMemory
; _WinAPI_OpenDesktop
; _WinAPI_OpenIcon
; _WinAPI_OpenInputDesktop
; _WinAPI_OpenWindowStation
; _WinAPI_QueryPerformanceCounter
; _WinAPI_QueryPerformanceFrequency
; _WinAPI_RegisterClass
; _WinAPI_RegisterClassEx
; _WinAPI_RegisterHotKey
; _WinAPI_RegisterPowerSettingNotification
; _WinAPI_RegisterRawInputDevices
; _WinAPI_RegisterShellHookWindow
; _WinAPI_RemoveClipboardFormatListener
; _WinAPI_SendMessageTimeout
; _WinAPI_SetActiveWindow
; _WinAPI_SetClassLongEx
; _WinAPI_SetDllDirectory
; _WinAPI_SetForegroundWindow
; _WinAPI_SetKeyboardLayout
; _WinAPI_SetKeyboardState
; _WinAPI_SetMessageExtraInfo
; _WinAPI_SetProcessWindowStation
; _WinAPI_SetProcessShutdownParameters
; _WinAPI_SetTimer
; _WinAPI_SetUserObjectInformation
; _WinAPI_SetWindowDisplayAffinity
; _WinAPI_SetWinEventHook
; _WinAPI_ShowOwnedPopups
; _WinAPI_ShutdownBlockReasonCreate
; _WinAPI_ShutdownBlockReasonDestroy
; _WinAPI_ShutdownBlockReasonQuery
; _WinAPI_SwitchDesktop
; _WinAPI_SwitchToThisWindow
; _WinAPI_TileWindows
; _WinAPI_TrackMouseEvent
; _WinAPI_UnhookWinEvent
; _WinAPI_UnloadKeyboardLayout
; _WinAPI_UnregisterClass
; _WinAPI_UnregisterHotKey
; _WinAPI_UnregisterPowerSettingNotification
; _WinAPI_UpdateLayeredWindowEx
; _WinAPI_UpdateLayeredWindowIndirect
; _WinAPI_ZeroMemory
; ===============================================================================================================================
#EndRegion Functions list

#Region Public Functions

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_ActivateKeyboardLayout($hLocale, $iFlag = 0)
	Local $aRet = DllCall('user32.dll', 'handle', 'ActivateKeyboardLayout', 'handle', $hLocale, 'uint', $iFlag)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_ActivateKeyboardLayout

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_AddClipboardFormatListener($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'AddClipboardFormatListener', 'hwnd', $hWnd)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_AddClipboardFormatListener

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_AdjustWindowRectEx(ByRef $tRECT, $iStyle, $iExStyle = 0, $bMenu = False)
	Local $aRet = DllCall('user32.dll', 'bool', 'AdjustWindowRectEx', 'struct*', $tRECT, 'dword', $iStyle, 'bool', $bMenu, _
			'dword', $iExStyle)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_AdjustWindowRectEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_AnimateWindow($hWnd, $iFlags, $iDuration = 1000)
	Local $aRet = DllCall('user32.dll', 'bool', 'AnimateWindow', 'hwnd', $hWnd, 'dword', $iDuration, 'dword', $iFlags)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_AnimateWindow

; #FUNCTION# ====================================================================================================================
; Author.........: KaFu
; Modified.......: Yashied, Jpm
; ===============================================================================================================================
Func _WinAPI_BeginDeferWindowPos($iAmount = 1)
	Local $aRet = DllCall('user32.dll', 'handle', 'BeginDeferWindowPos', 'int', $iAmount)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_BeginDeferWindowPos

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_BringWindowToTop($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'BringWindowToTop', 'hwnd', $hWnd)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_BringWindowToTop

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_BroadcastSystemMessage($iMsg, $wParam = 0, $lParam = 0, $iFlags = 0, $iRecipients = 0)
	Local $aRet = DllCall('user32.dll', 'long', 'BroadcastSystemMessageW', 'dword', $iFlags, 'dword*', $iRecipients, _
			'uint', $iMsg, 'wparam', $wParam, 'lparam', $lParam)
	If @error Or ($aRet[0] = -1) Then Return SetError(@error, @extended, -1)
	; If $aRet[0] = -1 Then Return SetError(1000, 0, 0)

	Return SetExtended($aRet[2], $aRet[0])
EndFunc   ;==>_WinAPI_BroadcastSystemMessage

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CallWindowProcW($pPrevWndProc, $hWnd, $iMsg, $wParam, $lParam)
	Local $aRet = DllCall('user32.dll', 'lresult', 'CallWindowProcW', 'ptr', $pPrevWndProc, 'hwnd', $hWnd, 'uint', $iMsg, _
			'wparam', $wParam, 'lparam', $lParam)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CallWindowProcW

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CascadeWindows($aWnds, $tRECT = 0, $hParent = 0, $iFlags = 0, $iStart = 0, $iEnd = -1)
	If __CheckErrorArrayBounds($aWnds, $iStart, $iEnd) Then Return SetError(@error + 10, @extended, 0)

	Local $iCount = $iEnd - $iStart + 1
	Local $tWnds = DllStructCreate('hwnd[' & $iCount & ']')

	$iCount = 1
	For $i = $iStart To $iEnd
		DllStructSetData($tWnds, 1, $aWnds[$i], $iCount)
		$iCount += 1
	Next

	Local $aRet = DllCall('user32.dll', 'word', 'CascadeWindows', 'hwnd', $hParent, 'uint', $iFlags, 'struct*', $tRECT, _
			'uint', $iCount - 1, 'struct*', $tWnds)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CascadeWindows

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ChangeWindowMessageFilterEx($hWnd, $iMsg, $iAction)
	Local $tCFS, $aRet

	If $hWnd And ($__WINVER > 0x0600) Then
		Local Const $tagCHANGEFILTERSTRUCT = 'dword cbSize; dword ExtStatus'
		$tCFS = DllStructCreate($tagCHANGEFILTERSTRUCT)
		DllStructSetData($tCFS, 1, DllStructGetSize($tCFS))
		$aRet = DllCall('user32.dll', 'bool', 'ChangeWindowMessageFilterEx', 'hwnd', $hWnd, 'uint', $iMsg, 'dword', $iAction, _
				'struct*', $tCFS)
	Else
		$tCFS = 0
		$aRet = DllCall('user32.dll', 'bool', 'ChangeWindowMessageFilter', 'uint', $iMsg, 'dword', $iAction)
	EndIf
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return SetExtended(DllStructGetData($tCFS, 2), 1)
EndFunc   ;==>_WinAPI_ChangeWindowMessageFilterEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_ChildWindowFromPointEx($hWnd, $tPOINT, $iFlags = 0)
	Local $aRet = DllCall('user32.dll', 'hwnd', 'ChildWindowFromPointEx', 'hwnd', $hWnd, 'struct', $tPOINT, 'uint', $iFlags)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_ChildWindowFromPointEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CloseDesktop($hDesktop)
	Local $aRet = DllCall('user32.dll', 'bool', 'CloseDesktop', 'handle', $hDesktop)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CloseDesktop

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CloseWindow($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'CloseWindow', 'hwnd', $hWnd)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CloseWindow

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CloseWindowStation($hStation)
	Local $aRet = DllCall('user32.dll', 'bool', 'CloseWindowStation', 'handle', $hStation)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CloseWindowStation

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CompressBuffer($pUncompressedBuffer, $iUncompressedSize, $pCompressedBuffer, $iCompressedSize, $iFormatAndEngine = 0x0002)
	Local $aRet, $pWorkSpace = 0, $iError = 0
	Do
		$aRet = DllCall('ntdll.dll', 'uint', 'RtlGetCompressionWorkSpaceSize', 'ushort', $iFormatAndEngine, 'ulong*', 0, 'ulong*', 0)
		If @error Or $aRet[0] Then
			$iError = @error + 20
			ExitLoop
		EndIf
		$pWorkSpace = __HeapAlloc($aRet[2])
		If @error Then
			$iError = @error + 100
			ExitLoop
		EndIf
		$aRet = DllCall('ntdll.dll', 'uint', 'RtlCompressBuffer', 'ushort', $iFormatAndEngine, 'struct*', $pUncompressedBuffer, _
				'ulong', $iUncompressedSize, 'struct*', $pCompressedBuffer, 'ulong', $iCompressedSize, 'ulong', 4096, _
				'ulong*', 0, 'ptr', $pWorkSpace)
		If @error Or $aRet[0] Or Not $aRet[7] Then
			$iError = @error + 30
			ExitLoop
		EndIf
	Until 1
	__HeapFree($pWorkSpace)
	If $iError Then
		If IsArray($aRet) Then
			Return SetError(10, $aRet[0], 0)
		Else
			Return SetError($iError, 0, 0)
		EndIf
	EndIf

	Return $aRet[7]
EndFunc   ;==>_WinAPI_CompressBuffer

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_ComputeCrc32($pMemory, $iLength)
	If _WinAPI_IsBadReadPtr($pMemory, $iLength) Then Return SetError(1, @extended, 0)

	Local $aRet = DllCall('ntdll.dll', 'dword', 'RtlComputeCrc32', 'dword', 0, 'struct*', $pMemory, 'int', $iLength)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_ComputeCrc32

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CreateBuffer($iLength, $pBuffer = 0, $bAbort = True)
	$pBuffer = __HeapReAlloc($pBuffer, $iLength, 0, $bAbort)
	If @error Then Return SetError(@error, @extended, 0)

	Return $pBuffer
EndFunc   ;==>_WinAPI_CreateBuffer

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CreateBufferFromStruct($tStruct, $pBuffer = 0, $bAbort = True)
	If Not IsDllStruct($tStruct) Then Return SetError(1, 0, 0)

	$pBuffer = __HeapReAlloc($pBuffer, DllStructGetSize($tStruct), 0, $bAbort)
	If @error Then Return SetError(@error + 100, @extended, 0)

	_WinAPI_MoveMemory($pBuffer, $tStruct, DllStructGetSize($tStruct))
	; Local $iError = @error	; cannot really occur
	; __HeapFree($pBuffer)
	; Return SetError($iError, 0, 0)
	; EndIf

	Return $pBuffer
EndFunc   ;==>_WinAPI_CreateBufferFromStruct

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CreateDesktop($sName, $iAccess = 0x0002, $iFlags = 0, $iHeap = 0, $tSecurity = 0)
	Local $aRet
	If $iHeap Then
		$aRet = DllCall('user32.dll', 'handle', 'CreateDesktopExW', 'wstr', $sName, 'ptr', 0, 'ptr', 0, 'dword', $iFlags, _
				'dword', $iAccess, 'struct*', $tSecurity, 'ulong', $iHeap, 'ptr', 0)
	Else
		$aRet = DllCall('user32.dll', 'handle', 'CreateDesktopW', 'wstr', $sName, 'ptr', 0, 'ptr', 0, 'dword', $iFlags, _
				'dword', $iAccess, 'struct*', $tSecurity)
	EndIf
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CreateDesktop

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CreateString($sString, $pString = 0, $iLength = -1, $bUnicode = True, $bAbort = True)
	$iLength = Number($iLength)
	If $iLength >= 0 Then
		$sString = StringLeft($sString, $iLength)
	Else
		$iLength = StringLen($sString)
	EndIf
	Local $iSize = $iLength + 1
	If $bUnicode Then
		$iSize *= 2
	EndIf
	$pString = __HeapReAlloc($pString, $iSize, 0, $bAbort)
	If @error Then Return SetError(@error, @extended, 0)

	DllStructSetData(DllStructCreate(__Iif($bUnicode, 'wchar', 'char') & '[' & ($iLength + 1) & ']', $pString), 1, $sString)
	Return SetExtended($iLength, $pString)
EndFunc   ;==>_WinAPI_CreateString

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_CreateWindowStation($sName = '', $iAccess = 0, $iFlags = 0, $tSecurity = 0)
	Local $aRet = DllCall('user32.dll', 'handle', 'CreateWindowStationW', 'wstr', $sName, 'dword', $iFlags, 'dword', $iAccess, _
			'struct*', $tSecurity)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_CreateWindowStation

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DecompressBuffer($pUncompressedBuffer, $iUncompressedSize, $pCompressedBuffer, $iCompressedSize, $iFormat = 0x0002)
	Local $aRet = DllCall('ntdll.dll', 'long', 'RtlDecompressBuffer', 'ushort', $iFormat, 'struct*', $pUncompressedBuffer, _
			'ulong', $iUncompressedSize, 'struct*', $pCompressedBuffer, 'ulong', $iCompressedSize, 'ulong*', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $aRet[6]
EndFunc   ;==>_WinAPI_DecompressBuffer

; #FUNCTION# ====================================================================================================================
; Author.........: KaFu
; Modified.......: Yashied, Jpm
; ===============================================================================================================================
Func _WinAPI_DeferWindowPos($hInfo, $hWnd, $hAfter, $iX, $iY, $iWidth, $iHeight, $iFlags)
	Local $aRet = DllCall('user32.dll', 'handle', 'DeferWindowPos', 'handle', $hInfo, 'hwnd', $hWnd, 'hwnd', $hAfter, _
			'int', $iX, 'int', $iY, 'int', $iWidth, 'int', $iHeight, 'uint', $iFlags)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_DeferWindowPos

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DefRawInputProc($paRawInput, $iInput)
	Local $aRet = DllCall('user32.dll', 'lresult', 'DefRawInputProc', 'ptr', $paRawInput, 'int', $iInput, _
			'uint', DllStructGetSize(DllStructCreate($tagRAWINPUTHEADER)))
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_DefRawInputProc

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DefWindowProcW($hWnd, $iMsg, $wParam, $lParam)
	Local $aRet = DllCall('user32.dll', 'lresult', 'DefWindowProcW', 'hwnd', $hWnd, 'uint', $iMsg, 'wparam', $wParam, _
			'lparam', $lParam)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_DefWindowProcW

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_DeregisterShellHookWindow($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'DeregisterShellHookWindow', 'hwnd', $hWnd)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_DeregisterShellHookWindow

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DragAcceptFiles($hWnd, $bAccept = True)
	DllCall('shell32.dll', 'none', 'DragAcceptFiles', 'hwnd', $hWnd, 'bool', $bAccept)
	If @error Then Return SetError(@error, @extended, 0)

	Return 1
EndFunc   ;==>_WinAPI_DragAcceptFiles

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DragFinish($hDrop)
	DllCall('shell32.dll', 'none', 'DragFinish', 'handle', $hDrop)
	If @error Then Return SetError(@error, @extended, 0)

	Return 1
EndFunc   ;==>_WinAPI_DragFinish

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DragQueryFileEx($hDrop, $iFlag = 0)
	Local $aRet = DllCall('shell32.dll', 'uint', 'DragQueryFileW', 'handle', $hDrop, 'uint', -1, 'ptr', 0, 'uint', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If Not $aRet[0] Then Return SetError(10, 0, 0)

	Local $iCount = $aRet[0]
	Local $aResult[$iCount + 1]
	For $i = 0 To $iCount - 1
		$aRet = DllCall('shell32.dll', 'uint', 'DragQueryFileW', 'handle', $hDrop, 'uint', $i, 'wstr', '', 'uint', 4096)
		If Not $aRet[0] Then Return SetError(11, 0, 0)
		If $iFlag Then
			Local $bDir = _WinAPI_PathIsDirectory($aRet[3])
			If (($iFlag = 1) And $bDir) Or (($iFlag = 2) And Not $bDir) Then
				ContinueLoop
			EndIf
		EndIf
		$aResult[$i + 1] = $aRet[3]
		$aResult[0] += 1
	Next
	If Not $aResult[0] Then Return SetError(12, 0, 0)

	__Inc($aResult, -1)
	Return $aResult
EndFunc   ;==>_WinAPI_DragQueryFileEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DragQueryPoint($hDrop)
	Local $tPOINT = DllStructCreate($tagPOINT)
	Local $aRet = DllCall('shell32.dll', 'bool', 'DragQueryPoint', 'handle', $hDrop, 'struct*', $tPOINT)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $tPOINT
EndFunc   ;==>_WinAPI_DragQueryPoint

; #FUNCTION# ====================================================================================================================
; Author.........: KaFu
; Modified.......: Yashied, Jpm
; ===============================================================================================================================
Func _WinAPI_EndDeferWindowPos($hInfo)
	Local $aRet = DllCall('user32.dll', 'bool', 'EndDeferWindowPos', 'handle', $hInfo)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_EndDeferWindowPos

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EnumChildWindows($hWnd, $bVisible = True)
	If Not _WinAPI_GetWindow($hWnd, 5) Then Return SetError(2, 0, 0) ; $GW_CHILD

	Local $hEnumProc = DllCallbackRegister('__EnumWindowsProc', 'bool', 'hwnd;lparam')

	Dim $__g_vEnum[101][2] = [[0]]
	DllCall('user32.dll', 'bool', 'EnumChildWindows', 'hwnd', $hWnd, 'ptr', DllCallbackGetPtr($hEnumProc), 'lparam', $bVisible)
	If @error Or Not $__g_vEnum[0][0] Then
		$__g_vEnum = @error + 10
	EndIf
	DllCallbackFree($hEnumProc)
	If $__g_vEnum Then Return SetError($__g_vEnum, 0, 0)

	__Inc($__g_vEnum, -1)
	Return $__g_vEnum
EndFunc   ;==>_WinAPI_EnumChildWindows

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EnumDesktops($hStation)
	If StringCompare(_WinAPI_GetUserObjectInformation($hStation, 3), 'WindowStation') Then Return SetError(1, 0, 0)

	Local $hEnumProc = DllCallbackRegister('__EnumDefaultProc', 'bool', 'ptr;lparam')

	Dim $__g_vEnum[101] = [0]
	Local $aRet = DllCall('user32.dll', 'bool', 'EnumDesktopsW', 'handle', $hStation, 'ptr', DllCallbackGetPtr($hEnumProc), _
			'lparam', 0)
	If @error Or Not $aRet[0] Or Not $__g_vEnum[0] Then
		$__g_vEnum = @error + 10
	EndIf
	DllCallbackFree($hEnumProc)
	If $__g_vEnum Then Return SetError($__g_vEnum, 0, 0)

	__Inc($__g_vEnum, -1)
	Return $__g_vEnum
EndFunc   ;==>_WinAPI_EnumDesktops

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EnumDesktopWindows($hDesktop, $bVisible = True)
	If StringCompare(_WinAPI_GetUserObjectInformation($hDesktop, 3), 'Desktop') Then Return SetError(1, 0, 0)

	Local $hEnumProc = DllCallbackRegister('__EnumWindowsProc', 'bool', 'hwnd;lparam')

	Dim $__g_vEnum[101][2] = [[0]]
	Local $aRet = DllCall('user32.dll', 'bool', 'EnumDesktopWindows', 'handle', $hDesktop, 'ptr', DllCallbackGetPtr($hEnumProc), _
			'lparam', $bVisible)
	If @error Or Not $aRet[0] Or Not $__g_vEnum[0][0] Then
		$__g_vEnum = @error + 10
	EndIf
	DllCallbackFree($hEnumProc)
	If $__g_vEnum Then Return SetError($__g_vEnum, 0, 0)

	__Inc($__g_vEnum, -1)
	Return $__g_vEnum
EndFunc   ;==>_WinAPI_EnumDesktopWindows

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EnumPageFiles()
	Local $aInfo = _WinAPI_GetSystemInfo()

	Local $hEnumProc = DllCallbackRegister('__EnumPageFilesProc', 'bool', 'lparam;ptr;ptr')

	Dim $__g_vEnum[101][4] = [[0]]
	Local $aRet = DllCall(@SystemDir & '\psapi.dll', 'bool', 'EnumPageFilesW', 'ptr', DllCallbackGetPtr($hEnumProc), 'lparam', $aInfo[1])
	If @error Or Not $aRet[0] Or Not $__g_vEnum[0][0] Then
		$__g_vEnum = @error + 10
	EndIf
	DllCallbackFree($hEnumProc)
	If $__g_vEnum Then Return SetError($__g_vEnum, 0, 0)

	__Inc($__g_vEnum, -1)
	Return $__g_vEnum
EndFunc   ;==>_WinAPI_EnumPageFiles

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EnumRawInputDevices()
	Local Const $tagRAWINPUTDEVICELIST = 'struct;handle hDevice;dword Type;endstruct'
	Local $tRIDL, $iLength = DllStructGetSize(DllStructCreate($tagRAWINPUTDEVICELIST))

	Local $aRet = DllCall('user32.dll', 'uint', 'GetRawInputDeviceList', 'ptr', 0, 'uint*', 0, 'uint', $iLength)
	If @error Then Return SetError(@error + 10, @extended, 0)
	If ($aRet[0] = 4294967295) Or (Not $aRet[2]) Then Return SetError(10, -1, 0)

	Local $tData = DllStructCreate('byte[' & ($aRet[2] * $iLength) & ']')
	Local $pData = DllStructGetPtr($tData)
	If @error Then Return SetError(@error + 20, 0, 0)

	$aRet = DllCall('user32.dll', 'uint', 'GetRawInputDeviceList', 'ptr', $pData, 'uint*', $aRet[2], 'uint', $iLength)
	If ($aRet[0] = 4294967295) Or (Not $aRet[0]) Then Return SetError(1, -1, 0)

	Local $aResult[$aRet[2] + 1][2] = [[$aRet[2]]]
	For $i = 1 To $aRet[2]
		$tRIDL = DllStructCreate('ptr;dword', $pData + $iLength * ($i - 1))
		For $j = 0 To 1
			$aResult[$i][$j] = DllStructGetData($tRIDL, $j + 1)
		Next
	Next
	Return $aResult
EndFunc   ;==>_WinAPI_EnumRawInputDevices

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EnumWindowStations()
	Local $hEnumProc = DllCallbackRegister('__EnumDefaultProc', 'bool', 'ptr;lparam')

	Dim $__g_vEnum[101] = [0]
	Local $aRet = DllCall('user32.dll', 'bool', 'EnumWindowStationsW', 'ptr', DllCallbackGetPtr($hEnumProc), 'lparam', 0)
	If @error Or Not $aRet[0] Or Not $__g_vEnum[0] Then
		$__g_vEnum = @error + 10
	EndIf
	DllCallbackFree($hEnumProc)
	If $__g_vEnum Then Return SetError($__g_vEnum, 0, 0)

	__Inc($__g_vEnum, -1)
	Return $__g_vEnum
EndFunc   ;==>_WinAPI_EnumWindowStations

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EqualMemory($pSource1, $pSource2, $iLength)
	If _WinAPI_IsBadReadPtr($pSource1, $iLength) Then Return SetError(11, @extended, 0)
	If _WinAPI_IsBadReadPtr($pSource2, $iLength) Then Return SetError(12, @extended, 0)

	Local $aRet = DllCall('ntdll.dll', 'ulong_ptr', 'RtlCompareMemory', 'struct*', $pSource1, 'struct*', $pSource2, 'ulong_ptr', $iLength)
	If @error Then Return SetError(@error, @extended, 0)

	Return Number($aRet[0] = $iLength)
EndFunc   ;==>_WinAPI_EqualMemory

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_FillMemory($pMemory, $iLength, $iValue = 0)
	If _WinAPI_IsBadWritePtr($pMemory, $iLength) Then Return SetError(11, @extended, 0)

	DllCall('ntdll.dll', 'none', 'RtlFillMemory', 'struct*', $pMemory, 'ulong_ptr', $iLength, 'byte', $iValue)
	If @error Then Return SetError(@error, @extended, 0)

	Return 1
EndFunc   ;==>_WinAPI_FillMemory

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_FreeMemory($pMemory)
	If Not __HeapFree($pMemory, 1) Then Return SetError(@error, @extended, 0)

	Return 1
EndFunc   ;==>_WinAPI_FreeMemory

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetActiveWindow()
	Local $aRet = DllCall('user32.dll', 'hwnd', 'GetActiveWindow')
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetActiveWindow

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetClassInfoEx($sClass, $hInstance = 0)
	Local $sTypeOfClass = 'ptr'
	If IsString($sClass) Then
		$sTypeOfClass = 'wstr'
	EndIf

	Local $tWNDCLASSEX = DllStructCreate($tagWNDCLASSEX)
	Local $aRet = DllCall('user32.dll', 'bool', 'GetClassInfoExW', 'handle', $hInstance, $sTypeOfClass, $sClass, _
			'struct*', $tWNDCLASSEX)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $tWNDCLASSEX
EndFunc   ;==>_WinAPI_GetClassInfoEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetClassLongEx($hWnd, $iIndex)
	Local $aRet
	If @AutoItX64 Then
		$aRet = DllCall('user32.dll', 'ulong_ptr', 'GetClassLongPtrW', 'hwnd', $hWnd, 'int', $iIndex)
	Else
		$aRet = DllCall('user32.dll', 'dword', 'GetClassLongW', 'hwnd', $hWnd, 'int', $iIndex)
	EndIf
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetClassLongEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetClipboardSequenceNumber()
	Local $aRet = DllCall('user32.dll', 'dword', 'GetClipboardSequenceNumber')
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetClipboardSequenceNumber

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetCurrentHwProfile()
	Local $tagHW_PROFILE_INFO = 'dword DockInfo;wchar szHwProfileGuid[39];wchar szHwProfileName[80]'
	Local $tHWPI = DllStructCreate($tagHW_PROFILE_INFO)
	Local $aRet = DllCall('advapi32.dll', 'bool', 'GetCurrentHwProfileW', 'struct*', $tHWPI)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Local $aResult[3]
	For $i = 0 To 2
		$aResult[$i] = DllStructGetData($tHWPI, $i + 1)
	Next
	Return $aResult
EndFunc   ;==>_WinAPI_GetCurrentHwProfile

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetDefaultPrinter()
	Local $aRet = DllCall('winspool.drv', 'bool', 'GetDefaultPrinterW', 'wstr', '', 'dword*', 2048)
	If @error Then Return SetError(@error, @extended, '')
	If Not $aRet[0] Then Return SetError(10, _WinAPI_GetLastError(), '')

	Return $aRet[1]
EndFunc   ;==>_WinAPI_GetDefaultPrinter

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetDllDirectory()
	Local $aRet = DllCall('kernel32.dll', 'dword', 'GetDllDirectoryW', 'dword', 4096, 'wstr', '')
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, '')
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[2]
EndFunc   ;==>_WinAPI_GetDllDirectory

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetEffectiveClientRect($hWnd, $aCtrl, $iStart = 0, $iEnd = -1)
	If Not IsArray($aCtrl) Then
		Local $iCtrl = $aCtrl
		Dim $aCtrl[1] = [$iCtrl]
		$iStart = 0
		$iEnd = 0
	EndIf
	If __CheckErrorArrayBounds($aCtrl, $iStart, $iEnd) Then Return SetError(@error + 10, @extended, 0)

	Local $iCount = $iEnd - $iStart + 1
	Local $tCtrl = DllStructCreate('uint64[' & ($iCount + 2) & ']')
	$iCount = 2
	For $i = $iStart To $iEnd
		If IsHWnd($aCtrl[$i]) Then
			$aCtrl[$i] = _WinAPI_GetDlgCtrlID($aCtrl[$i])
		EndIf
		DllStructSetData($tCtrl, 1, _WinAPI_MakeQWord(1, $aCtrl[$i]), $iCount)
		$iCount += 1
	Next
	Local $tRECT = DllStructCreate($tagRECT)
	DllCall('comctl32.dll', 'none', 'GetEffectiveClientRect', 'hwnd', $hWnd, 'struct*', $tRECT, 'struct*', $tCtrl)
	If @error Then Return SetError(@error, @extended, 0)

	Return $tRECT
EndFunc   ;==>_WinAPI_GetEffectiveClientRect

; #FUNCTION# ====================================================================================================================
; Author.........: KaFu
; Modified.......: Yashied, jpm
; ===============================================================================================================================
Func _WinAPI_GetGUIThreadInfo($iThreadId)
	Local Const $tagGUITHREADINFO = 'dword Size;dword Flags;hwnd hWndActive;hwnd hWndFocus;hwnd hWndCapture;hwnd hWndMenuOwner;hwnd hWndMoveSize;hwnd hWndCaret;long rcCaret[4]'
	Local $tGTI = DllStructCreate($tagGUITHREADINFO)
	DllStructSetData($tGTI, 1, DllStructGetSize($tGTI))

	Local $aRet = DllCall('user32.dll', 'bool', 'GetGUIThreadInfo', 'dword', $iThreadId, 'struct*', $tGTI)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Local $aResult[11]
	For $i = 0 To 6
		$aResult[$i] = DllStructGetData($tGTI, $i + 2)
	Next
	For $i = 1 To 4
		$aResult[6 + $i] = DllStructGetData($tGTI, 6 + 2, $i)
	Next
	For $i = 9 To 10
		$aResult[$i] -= $aResult[$i - 2]
	Next
	Return $aResult
EndFunc   ;==>_WinAPI_GetGUIThreadInfo

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetHandleInformation($hObject)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'GetHandleInformation', 'handle', $hObject, 'dword*', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[2]
EndFunc   ;==>_WinAPI_GetHandleInformation

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetIdleTime()
	Local $tLASTINPUTINFO = DllStructCreate('uint;dword')
	DllStructSetData($tLASTINPUTINFO, 1, DllStructGetSize($tLASTINPUTINFO))

	Local $aRet = DllCall('user32.dll', 'bool', 'GetLastInputInfo', 'struct*', $tLASTINPUTINFO)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return _WinAPI_GetTickCount() - DllStructGetData($tLASTINPUTINFO, 2)
EndFunc   ;==>_WinAPI_GetIdleTime

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetKeyboardLayout($hWnd)
	Local $aRet = DllCall('user32.dll', 'dword', 'GetWindowThreadProcessId', 'hwnd', $hWnd, 'ptr', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	$aRet = DllCall('user32.dll', 'handle', 'GetKeyboardLayout', 'dword', $aRet[0])
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetKeyboardLayout

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetKeyboardLayoutList()
	Local $aRet = DllCall('user32.dll', 'uint', 'GetKeyboardLayoutList', 'int', 0, 'ptr', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error + 20, @extended, 0)

	Local $tData = DllStructCreate('handle[' & $aRet[0] & ']')
	$aRet = DllCall('user32.dll', 'uint', 'GetKeyboardLayoutList', 'int', $aRet[0], 'struct*', $tData)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Local $aList[$aRet[0] + 1] = [$aRet[0]]
	For $i = 1 To $aList[0]
		$aList[$i] = DllStructGetData($tData, 1, $i)
	Next
	Return $aList
EndFunc   ;==>_WinAPI_GetKeyboardLayoutList

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetKeyboardState()
	Local $tData = DllStructCreate('byte[256]')
	Local $aRet = DllCall('user32.dll', 'bool', 'GetKeyboardState', 'struct*', $tData)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $tData
EndFunc   ;==>_WinAPI_GetKeyboardState

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetKeyboardType($iType)
	Local $aRet = DllCall('user32.dll', 'int', 'GetKeyboardType', 'int', $iType)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetKeyboardType

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetKeyNameText($lParam)
	Local $aRet = DllCall('user32.dll', 'int', 'GetKeyNameTextW', 'long', $lParam, 'wstr', '', 'int', 128)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, '')
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[2]
EndFunc   ;==>_WinAPI_GetKeyNameText

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_GetKeyState($vKey)
	Local $aRet = DllCall('user32.dll', 'short', 'GetKeyState', 'int', $vKey)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetKeyState

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetLastActivePopup($hWnd)
	Local $aRet = DllCall('user32.dll', 'hwnd', 'GetLastActivePopup', 'hwnd', $hWnd)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)
	If $aRet[0] = $hWnd Then Return SetError(1, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetLastActivePopup

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetMemorySize($pMemory)
	Local $iResult = __HeapSize($pMemory, 1)
	If @error Then Return SetError(@error, @extended, 0)

	Return $iResult
EndFunc   ;==>_WinAPI_GetMemorySize

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetMessageExtraInfo()
	Local $aRet = DllCall('user32.dll', 'lparam', 'GetMessageExtraInfo')
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetMessageExtraInfo

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetModuleHandleEx($sModule, $iFlags = 0)
	Local $sTypeOfModule = 'ptr'
	If IsString($sModule) Then
		If StringStripWS($sModule, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
			$sTypeOfModule = 'wstr'
		Else
			$sModule = 0
		EndIf
	EndIf

	Local $aRet = DllCall('kernel32.dll', 'bool', 'GetModuleHandleExW', 'dword', $iFlags, $sTypeOfModule, $sModule, 'ptr*', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[3]
EndFunc   ;==>_WinAPI_GetModuleHandleEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetMonitorInfo($hMonitor)
	Local $tMIEX = DllStructCreate('dword;long[4];long[4];dword;wchar[32]')
	DllStructSetData($tMIEX, 1, DllStructGetSize($tMIEX))

	Local $aRet = DllCall('user32.dll', 'bool', 'GetMonitorInfoW', 'handle', $hMonitor, 'struct*', $tMIEX)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Local $aResult[4]
	For $i = 0 To 1
		$aResult[$i] = DllStructCreate($tagRECT)
		_WinAPI_MoveMemory($aResult[$i], DllStructGetPtr($tMIEX, $i + 2), 16)
		; Return SetError(@error + 10, @extended, 0) ; cannot really occur
		; EndIf
	Next
	$aResult[3] = DllStructGetData($tMIEX, 5)
	Switch DllStructGetData($tMIEX, 4)
		Case 1 ; MONITORINFOF_PRIMARY
			$aResult[2] = 1
		Case Else
			$aResult[2] = 0
	EndSwitch
	Return $aResult
EndFunc   ;==>_WinAPI_GetMonitorInfo

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetMUILanguage()
	Local $aRet = DllCall('comctl32.dll', 'word', 'GetMUILanguage')
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetMUILanguage

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetObjectInfoByHandle($hObject)
	Local $tagPUBLIC_OBJECT_BASIC_INFORMATION = 'ulong Attributes;ulong GrantedAcess;ulong HandleCount;ulong PointerCount;ulong Reserved[10]'
	Local $tPOBI = DllStructCreate($tagPUBLIC_OBJECT_BASIC_INFORMATION)
	Local $aRet = DllCall('ntdll.dll', 'long', 'ZwQueryObject', 'handle', $hObject, 'uint', 0, 'struct*', $tPOBI, _
			'ulong', DllStructGetSize($tPOBI), 'ptr', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Local $aResult[4]
	For $i = 0 To 3
		$aResult[$i] = DllStructGetData($tPOBI, $i + 1)
	Next
	Return $aResult
EndFunc   ;==>_WinAPI_GetObjectInfoByHandle

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_GetObjectNameByHandle($hObject)
	Local $tagUNICODE_STRING = 'struct;ushort Length;ushort MaximumLength;ptr Buffer;endstruct'
	Local $tagPUBLIC_OBJECT_TYPE_INFORMATION = 'struct;' & $tagUNICODE_STRING & ';ulong Reserved[22];endstruct'
	Local $tPOTI = DllStructCreate($tagPUBLIC_OBJECT_TYPE_INFORMATION & ';byte[32]')
	Local $aRet = DllCall('ntdll.dll', 'long', 'ZwQueryObject', 'handle', $hObject, 'uint', 2, 'struct*', $tPOTI, _
			'ulong', DllStructGetSize($tPOTI), 'ulong*', 0)
	If @error Then Return SetError(@error, @extended, '')
	If $aRet[0] Then Return SetError(10, $aRet[0], '')
	Local $pData = DllStructGetData($tPOTI, 3)
	If Not $pData Then Return SetError(11, 0, '')

	Return _WinAPI_GetString($pData)
EndFunc   ;==>_WinAPI_GetObjectNameByHandle

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetPerformanceInfo()
	Local $tPI = DllStructCreate('dword;ulong_ptr;ulong_ptr;ulong_ptr;ulong_ptr;ulong_ptr;ulong_ptr;ulong_ptr;ulong_ptr;ulong_ptr;ulong_ptr;dword;dword;dword')
	Local $aRet = DllCall(@SystemDir & '\psapi.dll', 'bool', 'GetPerformanceInfo', 'struct*', $tPI, 'dword', DllStructGetSize($tPI))
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Local $aResult[13]
	For $i = 0 To 12
		$aResult[$i] = DllStructGetData($tPI, $i + 2)
	Next
	For $i = 0 To 8
		$aResult[$i] *= $aResult[9]
	Next
	Return $aResult
EndFunc   ;==>_WinAPI_GetPerformanceInfo

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetPhysicallyInstalledSystemMemory()
	Local $aRet = DllCall('kernel32.dll', 'bool', 'GetPhysicallyInstalledSystemMemory', 'uint64*', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[1]
EndFunc   ;==>_WinAPI_GetPhysicallyInstalledSystemMemory

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetProcessShutdownParameters()
	Local $aRet = DllCall('kernel32.dll', 'bool', 'GetProcessShutdownParameters', 'dword*', 0, 'dword*', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return SetExtended(Number(Not $aRet[2]), $aRet[1])
EndFunc   ;==>_WinAPI_GetProcessShutdownParameters

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetProcessWindowStation()
	Local $aRet = DllCall('user32.dll', 'handle', 'GetProcessWindowStation')
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetProcessWindowStation

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetPwrCapabilities()
	If Not __DLL('powrprof.dll') Then Return SetError(103, 0, 0)

	Local $tSPC = DllStructCreate('byte[18];byte[3];byte;byte[8];byte[2];ulong[6];ulong[5]')
	Local $aRet = DllCall('powrprof.dll', 'boolean', 'GetPwrCapabilities', 'struct*', $tSPC)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Local $aResult[25]
	For $i = 0 To 17
		$aResult[$i] = DllStructGetData($tSPC, 1, $i + 1)
	Next
	$aResult[18] = DllStructGetData($tSPC, 3)
	For $i = 19 To 20
		$aResult[$i] = DllStructGetData($tSPC, 5, $i - 18)
	Next
	For $i = 21 To 24
		$aResult[$i] = DllStructGetData($tSPC, 7, $i - 20)
	Next
	Return $aResult
EndFunc   ;==>_WinAPI_GetPwrCapabilities

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetRawInputBuffer($pBuffer, $iLength)
	Local $aRet = DllCall('user32.dll', 'uint', 'GetRawInputBuffer', 'struct*', $pBuffer, 'uint*', $iLength, _
			'uint', DllStructGetSize(DllStructCreate($tagRAWINPUTHEADER)))
	If @error Then Return SetError(@error, @extended, 0)
	If ($aRet[0] = 4294967295) Or (Not $aRet[1]) Then Return SetError(10, -1, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetRawInputBuffer

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetRawInputBufferLength()
	Local $aRet = DllCall('user32.dll', 'uint', 'GetRawInputBuffer', 'ptr', 0, 'uint*', 0, _
			'uint', DllStructGetSize(DllStructCreate($tagRAWINPUTHEADER)))
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] = 4294967295 Then Return SetError(10, -1, 0)

	Return $aRet[2] * 8
EndFunc   ;==>_WinAPI_GetRawInputBufferLength

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetRawInputData($hRawInput, $pBuffer, $iLength, $iFlag)
	Local $aRet = DllCall('user32.dll', 'uint', 'GetRawInputData', 'handle', $hRawInput, 'uint', $iFlag, 'struct*', $pBuffer, _
			'uint*', $iLength, 'uint', DllStructGetSize(DllStructCreate($tagRAWINPUTHEADER)))
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] = 4294967295 Then Return SetError(10, -1, 0)

	Return __Iif($aRet[3], $aRet[0], $aRet[4])
EndFunc   ;==>_WinAPI_GetRawInputData

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetRawInputDeviceInfo($hDevice, $pBuffer, $iLength, $iFlag)
	Local $aRet = DllCall('user32.dll', 'uint', 'GetRawInputDeviceInfoW', 'handle', $hDevice, 'uint', $iFlag, 'struct*', $pBuffer, _
			'uint*', $iLength)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] = 4294967295 Then Return SetError(10, -1, 0)

	Return __Iif($aRet[3], $aRet[0], $aRet[4])
EndFunc   ;==>_WinAPI_GetRawInputDeviceInfo

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetRegisteredRawInputDevices($pBuffer, $iLength)
	Local $iLengthRAW = DllStructGetSize(DllStructCreate($tagRAWINPUTDEVICE))
	Local $aRet = DllCall('user32.dll', 'uint', 'GetRegisteredRawInputDevices', 'struct*', $pBuffer, _
			'uint*', Floor($iLength / $iLengthRAW), 'uint', $iLengthRAW)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] = 4294967295 Then
		Local $iLastError = _WinAPI_GetLastError()
		If $iLastError = 122 Then Return SetExtended($iLastError, $aRet[2] * $iLengthRAW) ; ERROR_INSUFFICIENT_BUFFER
		Return SetError(10, $iLastError, 0)
	EndIf

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetRegisteredRawInputDevices

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetShellWindow()
	Local $aRet = DllCall('user32.dll', 'hwnd', 'GetShellWindow')
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetShellWindow

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetStartupInfo()
	Local $tSI = DllStructCreate($tagSTARTUPINFO)
	DllCall('kernel32.dll', 'none', 'GetStartupInfoW', 'struct*', $tSI)
	If @error Then Return SetError(@error, @extended, 0)

	Return $tSI
EndFunc   ;==>_WinAPI_GetStartupInfo

; #FUNCTION# ====================================================================================================================
; Author.........: KaFu
; Modified.......: Yashied, jpm
; ===============================================================================================================================
Func _WinAPI_GetSystemDEPPolicy()
	Local $aRet = DllCall('kernel32.dll', 'uint', 'GetSystemDEPPolicy')
	If @error Then Return SetError(@error, @extended, -1)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetSystemDEPPolicy

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetSystemInfo()
	Local $sProc
	If _WinAPI_IsWow64Process() Then
		$sProc = 'GetNativeSystemInfo'
	Else
		$sProc = 'GetSystemInfo'
	EndIf

	Local Const $tagSYSTEMINFO = 'struct;word ProcessorArchitecture;word Reserved; endstruct;dword PageSize;' & _
			'ptr MinimumApplicationAddress;ptr MaximumApplicationAddress;dword_ptr ActiveProcessorMask;dword NumberOfProcessors;' & _
			'dword ProcessorType;dword AllocationGranularity;word ProcessorLevel;word ProcessorRevision'
	Local $tSystemInfo = DllStructCreate($tagSYSTEMINFO)
	DllCall('kernel32.dll', 'none', $sProc, 'struct*', $tSystemInfo)
	If @error Then Return SetError(@error, @extended, 0)

	Local $aResult[10]
	$aResult[0] = DllStructGetData($tSystemInfo, 1)
	For $i = 1 To 9
		$aResult[$i] = DllStructGetData($tSystemInfo, $i + 2)
	Next
	Return $aResult
EndFunc   ;==>_WinAPI_GetSystemInfo

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetSystemPowerStatus()
	Local $tagSYSTEM_POWER_STATUS = 'byte ACLineStatus;byte BatteryFlag;byte BatteryLifePercent;byte Reserved1;' & _
			'int BatteryLifeTime;int BatteryFullLifeTime'
	Local $tSYSTEM_POWER_STATUS = DllStructCreate($tagSYSTEM_POWER_STATUS)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'GetSystemPowerStatus', 'struct*', $tSYSTEM_POWER_STATUS)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Local $aResult[5]
	$aResult[0] = DllStructGetData($tSYSTEM_POWER_STATUS, 1)
	$aResult[1] = DllStructGetData($tSYSTEM_POWER_STATUS, 2)
	$aResult[2] = DllStructGetData($tSYSTEM_POWER_STATUS, 3)
	$aResult[3] = DllStructGetData($tSYSTEM_POWER_STATUS, 5)
	$aResult[4] = DllStructGetData($tSYSTEM_POWER_STATUS, 6)
	Return $aResult
EndFunc   ;==>_WinAPI_GetSystemPowerStatus

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetSystemTimes()
	Local $aRet = DllCall('kernel32.dll', 'bool', 'GetSystemTimes', 'uint64*', 0, 'uint64*', 0, 'uint64*', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Local $aResult[3]
	For $i = 0 To 2
		$aResult[$i] = $aRet[$i + 1]
	Next
	Return $aResult
EndFunc   ;==>_WinAPI_GetSystemTimes

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetSystemWow64Directory()
	Local $aRet = DllCall('kernel32.dll', 'uint', 'GetSystemWow64DirectoryW', 'wstr', '', 'uint', 4096)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, _WinAPI_GetLastError(), '')

	Return $aRet[1]
EndFunc   ;==>_WinAPI_GetSystemWow64Directory

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetTickCount()
	Local $aRet = DllCall('kernel32.dll', 'dword', 'GetTickCount')
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetTickCount

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetTickCount64()
	Local $aRet = DllCall('kernel32.dll', 'uint64', 'GetTickCount64')
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetTickCount64

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetTopWindow($hWnd)
	Local $aRet = DllCall('user32.dll', 'hwnd', 'GetTopWindow', 'hwnd', $hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetTopWindow

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetUserObjectInformation($hObject, $iIndex)
	Local $aRet = DllCall('user32.dll', 'bool', 'GetUserObjectInformationW', 'handle', $hObject, 'int', $iIndex, 'ptr', 0, _
			'dword', 0, 'dword*', 0)
	If @error Or Not $aRet[5] Then Return SetError(@error + 10, @extended, 0)

	Local $tData
	Switch $iIndex
		Case 1
			$tData = DllStructCreate($tagUSEROBJECTFLAGS)
		Case 5, 6
			$tData = DllStructCreate('uint')
		Case 2, 3
			$tData = DllStructCreate('wchar[' & $aRet[5] & ']')
		Case 4
			$tData = DllStructCreate('byte[' & $aRet[5] & ']')
		Case Else
			Return SetError(20, 0, 0)
	EndSwitch
	$aRet = DllCall('user32.dll', 'bool', 'GetUserObjectInformationW', 'handle', $hObject, 'int', $iIndex, 'struct*', $tData, _
			'dword', DllStructGetSize($tData), 'dword*', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error + 30, @extended, 0)

	Switch $iIndex
		Case 1, 4
			Return $tData
		Case Else
			Return DllStructGetData($tData, 1)
	EndSwitch
EndFunc   ;==>_WinAPI_GetUserObjectInformation

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetVersion()
	; Return _WinAPI_HiByte($__WINVER) & '.' & _WinAPI_LoByte($__WINVER)
	Return BitAND(BitShift($__WINVER, 8), 0xFF) & '.' & BitAND($__WINVER, 0xFF)
EndFunc   ;==>_WinAPI_GetVersion

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetVersionEx()
	Local $tOSVERSIONINFOEX = DllStructCreate($tagOSVERSIONINFOEX)
	DllStructSetData($tOSVERSIONINFOEX, 'OSVersionInfoSize', DllStructGetSize($tOSVERSIONINFOEX))

	Local $aRet = DllCall('kernel32.dll', 'bool', 'GetVersionExW', 'struct*', $tOSVERSIONINFOEX)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $tOSVERSIONINFOEX
EndFunc   ;==>_WinAPI_GetVersionEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetWindowDisplayAffinity($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'GetWindowDisplayAffinity', 'hwnd', $hWnd, 'dword*', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $aRet[2]
EndFunc   ;==>_WinAPI_GetWindowDisplayAffinity

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetWindowInfo($hWnd)
	Local $tWINDOWINFO = DllStructCreate($tagWINDOWINFO)
	DllStructSetData($tWINDOWINFO, 'Size', DllStructGetSize($tWINDOWINFO))

	Local $aRet = DllCall('user32.dll', 'bool', 'GetWindowInfo', 'hwnd', $hWnd, 'struct*', $tWINDOWINFO)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $tWINDOWINFO
EndFunc   ;==>_WinAPI_GetWindowInfo

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetWorkArea()
	Local $tRECT = DllStructCreate($tagRECT)
	Local $aRet = DllCall('user32.dll', 'int', 'SystemParametersInfo', 'uint', 48, 'uint', 0, 'struct*', $tRECT, 'uint', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $tRECT
EndFunc   ;==>_WinAPI_GetWorkArea

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_InitMUILanguage($iLanguage)
	DllCall('comctl32.dll', 'none', 'InitMUILanguage', 'word', $iLanguage)
	If @error Then Return SetError(@error, @extended, 0)

	Return 1
EndFunc   ;==>_WinAPI_InitMUILanguage

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_IsBadCodePtr($pAddress)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'IsBadCodePtr', 'struct*', $pAddress)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_IsBadCodePtr

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_IsBadStringPtr($pAddress, $iLength)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'IsBadStringPtr', 'struct*', $pAddress, 'uint_ptr', $iLength)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_IsBadStringPtr

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_IsChild($hWnd, $hWndParent)
	Local $aRet = DllCall('user32.dll', 'bool', 'IsChild', 'hwnd', $hWndParent, 'hwnd', $hWnd)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_IsChild

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_IsHungAppWindow($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'IsHungAppWindow', 'hwnd', $hWnd)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_IsHungAppWindow

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_IsIconic($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'IsIconic', 'hwnd', $hWnd)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_IsIconic

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_IsLoadKBLayout($iLanguage)
	Local $aLayout = _WinAPI_GetKeyboardLayoutList()
	If @error Then Return SetError(@error, @extended, False)

	For $i = 1 To $aLayout[0]
		If $aLayout[$i] = $iLanguage Then Return True
	Next
	Return False
EndFunc   ;==>_WinAPI_IsLoadKBLayout

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_IsMemory($pMemory)
	Local $bResult = __HeapValidate($pMemory)

	Return SetError(@error, @extended, $bResult)
EndFunc   ;==>_WinAPI_IsMemory

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_IsProcessorFeaturePresent($iFeature)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'IsProcessorFeaturePresent', 'dword', $iFeature)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_IsProcessorFeaturePresent

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_IsWindowEnabled($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'IsWindowEnabled', 'hwnd', $hWnd)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_IsWindowEnabled

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_IsWindowUnicode($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'IsWindowUnicode', 'hwnd', $hWnd)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_IsWindowUnicode

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_IsZoomed($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'IsZoomed', 'hwnd', $hWnd)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_IsZoomed

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_Keybd_Event($vKey, $iFlags, $iScanCode = 0, $iExtraInfo = 0)
	DllCall('user32.dll', 'none', 'keybd_event', 'byte', $vKey, 'byte', $iScanCode, 'dword', $iFlags, 'ulong_ptr', $iExtraInfo)
	If @error Then Return SetError(@error, @extended, 0)

	Return 1
EndFunc   ;==>_WinAPI_Keybd_Event

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_KillTimer($hWnd, $iTimerID)
	Local $aRet = DllCall('user32.dll', 'bool', 'KillTimer', 'hwnd', $hWnd, 'uint_ptr', $iTimerID)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_KillTimer

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_LoadIconMetric($hInstance, $sName, $iMetric)
	Local $sTypeOfName = 'int'
	If IsString($sName) Then
		$sTypeOfName = 'wstr'
	EndIf

	Local $aRet = DllCall('comctl32.dll', 'long', 'LoadIconMetric', 'handle', $hInstance, $sTypeOfName, $sName, 'int', $iMetric, 'handle*', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $aRet[4]
EndFunc   ;==>_WinAPI_LoadIconMetric

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_LoadIconWithScaleDown($hInstance, $sName, $iWidth, $iHeight)
	Local $sTypeOfName = 'int'
	If IsString($sName) Then
		$sTypeOfName = 'wstr'
	EndIf

	Local $aRet = DllCall('comctl32.dll', 'long', 'LoadIconWithScaleDown', 'handle', $hInstance, $sTypeOfName, $sName, _
			'int', $iWidth, 'int', $iHeight, 'handle*', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $aRet[5]
EndFunc   ;==>_WinAPI_LoadIconWithScaleDown

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_LoadKeyboardLayout($iLanguage, $iFlag = 0)
	Local $aRet = DllCall('user32.dll', 'handle', 'LoadKeyboardLayoutW', 'wstr', Hex($iLanguage, 8), 'uint', $iFlag)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_LoadKeyboardLayout

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_LockWorkStation()
	Local $aRet = DllCall('user32.dll', 'bool', 'LockWorkStation')
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_LockWorkStation

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_MapVirtualKey($iCode, $iType, $hLocale = 0)
	Local $aRet = DllCall('user32.dll', 'INT', 'MapVirtualKeyExW', 'uint', $iCode, 'uint', $iType, 'uint_ptr', $hLocale)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_MapVirtualKey

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_MirrorIcon($hIcon, $bDelete = False)
	If Not $bDelete Then
		$hIcon = _WinAPI_CopyIcon($hIcon)
	EndIf

	Local $aRet = DllCall('comctl32.dll', 'int', 414, 'ptr', 0, 'ptr*', $hIcon)
	If @error Or Not $aRet[0] Then
		Local $iError = @error + 10
		If $hIcon And Not $bDelete Then
			_WinAPI_DestroyIcon($hIcon)
		EndIf
		Return SetError($iError, 0, 0)
	EndIf

	Return $aRet[2]
EndFunc   ;==>_WinAPI_MirrorIcon

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_OpenDesktop($sName, $iAccess = 0, $iFlags = 0, $bInherit = False)
	Local $aRet = DllCall('user32.dll', 'handle', 'OpenDesktopW', 'wstr', $sName, 'dword', $iFlags, 'bool', $bInherit, _
			'dword', $iAccess)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_OpenDesktop

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_OpenIcon($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'OpenIcon', 'hwnd', $hWnd)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_OpenIcon

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_OpenInputDesktop($iAccess = 0, $iFlags = 0, $bInherit = False)
	Local $aRet = DllCall('user32.dll', 'handle', 'OpenInputDesktop', 'dword', $iFlags, 'bool', $bInherit, 'dword', $iAccess)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_OpenInputDesktop

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_OpenWindowStation($sName, $iAccess = 0, $bInherit = False)
	Local $aRet = DllCall('user32.dll', 'handle', 'OpenWindowStationW', 'wstr', $sName, 'bool', $bInherit, 'dword', $iAccess)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_OpenWindowStation

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_QueryPerformanceCounter()
	Local $aRet = DllCall('kernel32.dll', 'bool', 'QueryPerformanceCounter', 'int64*', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[1]
EndFunc   ;==>_WinAPI_QueryPerformanceCounter

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_QueryPerformanceFrequency()
	Local $aRet = DllCall('kernel32.dll', 'bool', 'QueryPerformanceFrequency', 'int64*', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $aRet[1]
EndFunc   ;==>_WinAPI_QueryPerformanceFrequency

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_RegisterClass($tWNDCLASS)
	Local $aRet = DllCall('user32.dll', 'word', 'RegisterClassW', 'struct*', $tWNDCLASS)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_RegisterClass

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_RegisterClassEx($tWNDCLASSEX)
	Local $aRet = DllCall('user32.dll', 'word', 'RegisterClassExW', 'struct*', $tWNDCLASSEX)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_RegisterClassEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_RegisterHotKey($hWnd, $iID, $iModifiers, $vKey)
	Local $aRet = DllCall('user32.dll', 'bool', 'RegisterHotKey', 'hwnd', $hWnd, 'int', $iID, 'uint', $iModifiers, 'uint', $vKey)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_RegisterHotKey

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_RegisterPowerSettingNotification($hWnd, $sGUID)
	Local $tGUID = DllStructCreate($tagGUID)
	Local $aRet = DllCall('ole32.dll', 'long', 'CLSIDFromString', 'wstr', $sGUID, 'struct*', $tGUID)
	If @error Or $aRet[0] Then Return SetError(@error + 20, @extended, 0)

	$aRet = DllCall('user32.dll', 'handle', 'RegisterPowerSettingNotification', 'handle', $hWnd, 'struct*', $tGUID, 'dword', 0)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_RegisterPowerSettingNotification

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_RegisterRawInputDevices($paDevice, $iCount = 1)
	Local $aRet = DllCall('user32.dll', 'bool', 'RegisterRawInputDevices', 'struct*', $paDevice, 'uint', $iCount, _
			'uint', DllStructGetSize(DllStructCreate($tagRAWINPUTDEVICE)) * $iCount)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_RegisterRawInputDevices

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_RegisterShellHookWindow($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'RegisterShellHookWindow', 'hwnd', $hWnd)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_RegisterShellHookWindow

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_RemoveClipboardFormatListener($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'RemoveClipboardFormatListener', 'hwnd', $hWnd)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_RemoveClipboardFormatListener

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SendMessageTimeout($hWnd, $iMsg, $wParam = 0, $lParam = 0, $iTimeout = 1000, $iFlags = 0)
	Local $aRet = DllCall('user32.dll', 'lresult', 'SendMessageTimeoutW', 'hwnd', $hWnd, 'uint', $iMsg, 'wparam', $wParam, _
			'lparam', $lParam, 'uint', $iFlags, 'uint', $iTimeout, 'dword_ptr*', 0)
	If @error Then Return SetError(@error, @extended, -1)
	If Not $aRet[0] Then Return SetError(10, _WinAPI_GetLastError(), -1)

	Return $aRet[7]
EndFunc   ;==>_WinAPI_SendMessageTimeout

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetActiveWindow($hWnd)
	Local $aRet = DllCall('user32.dll', 'int', 'SetActiveWindow', 'hwnd', $hWnd)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetActiveWindow

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetClassLongEx($hWnd, $iIndex, $iNewLong)
	Local $aRet
	If @AutoItX64 Then
		$aRet = DllCall('user32.dll', 'ulong_ptr', 'SetClassLongPtrW', 'hwnd', $hWnd, 'int', $iIndex, 'long_ptr', $iNewLong)
	Else
		$aRet = DllCall('user32.dll', 'dword', 'SetClassLongW', 'hwnd', $hWnd, 'int', $iIndex, 'long', $iNewLong)
	EndIf
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetClassLongEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetDllDirectory($sDirPath = Default)
	Local $sTypeOfPath = 'wstr'
	If $sDirPath = Default Then
		$sTypeOfPath = 'ptr'
		$sDirPath = 0
	EndIf

	Local $aRet = DllCall('kernel32.dll', 'bool', 'SetDllDirectoryW', $sTypeOfPath, $sDirPath)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetDllDirectory

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetForegroundWindow($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'SetForegroundWindow', 'hwnd', $hWnd)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetForegroundWindow

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_SetKeyboardLayout($hWnd, $iLanguage, $iFlags = 0)
	If Not _WinAPI_IsWindow($hWnd) Then Return SetError(@error + 10, @extended, 0)

	Local $hLocale = 0
	If $iLanguage Then
		$hLocale = _WinAPI_LoadKeyboardLayout($iLanguage)
		If Not $hLocale Then Return SetError(10, 0, 0)
	EndIf

	Local Const $WM_INPUTLANGCHANGEREQUEST = 0x0050
	DllCall('user32.dll', 'none', 'SendMessage', 'hwnd', $hWnd, 'uint', $WM_INPUTLANGCHANGEREQUEST, 'uint', $iFlags, 'uint_ptr', $hLocale)
	If @error Then Return SetError(@error, @extended, 0)

	Return 1
EndFunc   ;==>_WinAPI_SetKeyboardLayout

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetKeyboardState(ByRef $tState)
	Local $aRet = DllCall('user32.dll', 'int', 'SetKeyboardState', 'struct*', $tState)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetKeyboardState

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_SetMessageExtraInfo($lParam)
	Local $aRet = DllCall('user32.dll', 'lparam', 'SetMessageExtraInfo', 'lparam', $lParam)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetMessageExtraInfo

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetProcessShutdownParameters($iLevel, $bDialog = False)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'SetProcessShutdownParameters', 'dword', $iLevel, 'dword', Not $bDialog)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetProcessShutdownParameters

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetProcessWindowStation($hStation)
	Local $aRet = DllCall('user32.dll', 'bool', 'SetProcessWindowStation', 'handle', $hStation)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetProcessWindowStation

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetTimer($hWnd, $iTimerID, $iElapse, $pTimerFunc)
	Local $aRet = DllCall('user32.dll', 'uint_ptr', 'SetTimer', 'hwnd', $hWnd, 'uint_ptr', $iTimerID, 'uint', $iElapse, _
			'ptr', $pTimerFunc)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetTimer

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetUserObjectInformation($hObject, $iIndex, ByRef $tData)
	If $iIndex <> 1 Then Return SetError(10, 0, False)

	Local $aRet = DllCall('user32.dll', 'bool', 'SetUserObjectInformationW', 'handle', $hObject, 'int', 1, 'struct*', $tData, _
			'dword', DllStructGetSize($tData))
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetUserObjectInformation

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SetWindowDisplayAffinity($hWnd, $iAffinity)
	Local $aRet = DllCall('user32.dll', 'bool', 'SetWindowDisplayAffinity', 'hwnd', $hWnd, 'dword', $iAffinity)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetWindowDisplayAffinity

; #FUNCTION# ====================================================================================================================
; Author.........: KaFu
; Modified.......: Yashied, Jpm
; ===============================================================================================================================
Func _WinAPI_SetWinEventHook($iEventMin, $iEventMax, $pEventProc, $iPID = 0, $iThreadId = 0, $iFlags = 0)
	Local $aRet = DllCall('user32.dll', 'handle', 'SetWinEventHook', 'uint', $iEventMin, 'uint', $iEventMax, 'ptr', 0, _
			'ptr', $pEventProc, 'dword', $iPID, 'dword', $iThreadId, 'uint', $iFlags)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SetWinEventHook

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_ShowOwnedPopups($hWnd, $bShow)
	Local $aRet = DllCall('user32.dll', 'bool', 'ShowOwnedPopups', 'hwnd', $hWnd, 'bool', $bShow)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_ShowOwnedPopups

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_ShutdownBlockReasonCreate($hWnd, $sText)
	Local $aRet = DllCall('user32.dll', 'bool', 'ShutdownBlockReasonCreate', 'hwnd', $hWnd, 'wstr', $sText)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_ShutdownBlockReasonCreate

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_ShutdownBlockReasonDestroy($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'ShutdownBlockReasonDestroy', 'hwnd', $hWnd)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_ShutdownBlockReasonDestroy

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ShutdownBlockReasonQuery($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'ShutdownBlockReasonQuery', 'hwnd', $hWnd, 'wstr', '', 'dword*', 4096)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, '')

	Return $aRet[2]
EndFunc   ;==>_WinAPI_ShutdownBlockReasonQuery

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_SwitchDesktop($hDesktop)
	Local $aRet = DllCall('user32.dll', 'bool', 'SwitchDesktop', 'handle', $hDesktop)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_SwitchDesktop

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_SwitchToThisWindow($hWnd, $bAltTab = False)
	DllCall('user32.dll', 'none', 'SwitchToThisWindow', 'hwnd', $hWnd, 'bool', $bAltTab)
	If @error Then Return SetError(@error, @extended, 0)

	Return 1
EndFunc   ;==>_WinAPI_SwitchToThisWindow

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_TileWindows($aWnds, $tRECT = 0, $hParent = 0, $iFlags = 0, $iStart = 0, $iEnd = -1)
	If __CheckErrorArrayBounds($aWnds, $iStart, $iEnd) Then Return SetError(@error + 10, @extended, 0)

	Local $iCount = $iEnd - $iStart + 1
	Local $tWnds = DllStructCreate('hwnd[' & $iCount & ']')
	$iCount = 1
	For $i = $iStart To $iEnd
		DllStructSetData($tWnds, 1, $aWnds[$i], $iCount)
		$iCount += 1
	Next

	Local $aRet = DllCall('user32.dll', 'word', 'TileWindows', 'hwnd', $hParent, 'uint', $iFlags, 'struct*', $tRECT, _
			'uint', $iCount - 1, 'struct*', $tWnds)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_TileWindows

; #FUNCTION# ====================================================================================================================
; Author.........: Matt Diesel (Mat)
; Modified.......: Yashied, Jpm
; ===============================================================================================================================
Func _WinAPI_TrackMouseEvent($hWnd, $iFlags, $iTime = -1)
	Local $tTME = DllStructCreate('dword;dword;hwnd;dword')
	DllStructSetData($tTME, 1, DllStructGetSize($tTME))
	DllStructSetData($tTME, 2, $iFlags)
	DllStructSetData($tTME, 3, $hWnd)
	DllStructSetData($tTME, 4, $iTime)

	Local $aRet = DllCall('user32.dll', 'bool', 'TrackMouseEvent', 'struct*', $tTME)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_TrackMouseEvent

; #FUNCTION# ====================================================================================================================
; Author.........: KaFu
; Modified.......: Yashied, Jpm
; ===============================================================================================================================
Func _WinAPI_UnhookWinEvent($hEventHook)
	Local $aRet = DllCall('user32.dll', 'bool', 'UnhookWinEvent', 'handle', $hEventHook)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_UnhookWinEvent

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_UnloadKeyboardLayout($hLocale)
	Local $aRet = DllCall('user32.dll', 'bool', 'UnloadKeyboardLayout', 'handle', $hLocale)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_UnloadKeyboardLayout

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_UnregisterClass($sClass, $hInstance = 0)
	Local $sTypeOfClass = 'ptr'
	If IsString($sClass) Then
		$sTypeOfClass = 'wstr'
	EndIf

	Local $aRet = DllCall('user32.dll', 'bool', 'UnregisterClassW', $sTypeOfClass, $sClass, 'handle', $hInstance)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_UnregisterClass

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_UnregisterHotKey($hWnd, $iID)
	Local $aRet = DllCall('user32.dll', 'bool', 'UnregisterHotKey', 'hwnd', $hWnd, 'int', $iID)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_UnregisterHotKey

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_UnregisterPowerSettingNotification($hNotify)
	Local $aRet = DllCall('user32.dll', 'bool', 'UnregisterPowerSettingNotification', 'handle', $hNotify)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_UnregisterPowerSettingNotification

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_UpdateLayeredWindowEx($hWnd, $iX, $iY, $hBitmap, $iOpacity = 255, $bDelete = False)
	Local $aRet = DllCall('user32.dll', 'handle', 'GetDC', 'hwnd', $hWnd)
	Local $hDC = $aRet[0]
	$aRet = DllCall('gdi32.dll', 'handle', 'CreateCompatibleDC', 'handle', $hDC)
	Local $hDestDC = $aRet[0]
	$aRet = DllCall('gdi32.dll', 'handle', 'SelectObject', 'handle', $hDestDC, 'handle', $hBitmap)
	Local $hDestSv = $aRet[0]
	Local $tPOINT
	If ($iX = -1) And ($iY = -1) Then
		$tPOINT = DllStructCreate('int;int')
	Else
		$tPOINT = DllStructCreate('int;int;int;int')
		DllStructSetData($tPOINT, 3, $iX)
		DllStructSetData($tPOINT, 4, $iY)
	EndIf
	DllStructSetData($tPOINT, 1, 0)
	DllStructSetData($tPOINT, 2, 0)
	Local $tBLENDFUNCTION = DllStructCreate($tagBLENDFUNCTION)
	DllStructSetData($tBLENDFUNCTION, 1, 0)
	DllStructSetData($tBLENDFUNCTION, 2, 0)
	DllStructSetData($tBLENDFUNCTION, 3, $iOpacity)
	DllStructSetData($tBLENDFUNCTION, 4, 1)
	Local $tSIZE = _WinAPI_GetBitmapDimension($hBitmap)
	$aRet = DllCall('user32.dll', 'bool', 'UpdateLayeredWindow', 'hwnd', $hWnd, 'handle', $hDC, 'ptr', DllStructGetPtr($tPOINT, 3), _
			'struct*', $tSIZE, 'handle', $hDestDC, 'struct*', $tPOINT, 'dword', 0, 'struct*', $tBLENDFUNCTION, 'dword', 0x02)
	Local $iError = @error
	DllCall('user32.dll', 'bool', 'ReleaseDC', 'hwnd', $hWnd, 'handle', $hDC)
	DllCall('gdi32.dll', 'handle', 'SelectObject', 'handle', $hDestDC, 'handle', $hDestSv)
	DllCall('gdi32.dll', 'bool', 'DeleteDC', 'handle', $hDestDC)
	If $iError Then Return SetError($iError, 0, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	If $bDelete Then
		_WinAPI_DeleteObject($hBitmap)
	EndIf
	Return $aRet[0]
EndFunc   ;==>_WinAPI_UpdateLayeredWindowEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_UpdateLayeredWindowIndirect($hWnd, $tULWINFO)
	Local $aRet = DllCall('user32.dll', 'bool', 'UpdateLayeredWindowIndirect', 'hwnd', $hWnd, 'struct*', $tULWINFO)
	If @error Then Return SetError(@error, @extended, False)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_UpdateLayeredWindowIndirect

#EndRegion Public Functions

#Region Embedded DLL Functions

#EndRegion Embedded DLL Functions

#Region Internal Functions

Func __EnumDefaultProc($pData, $lParam)
	#forceref $lParam

	Local $iLength = _WinAPI_StrLen($pData)
	__Inc($__g_vEnum)
	If $iLength Then
		$__g_vEnum[$__g_vEnum[0]] = DllStructGetData(DllStructCreate('wchar[' & ($iLength + 1) & ']', $pData), 1)
	Else
		$__g_vEnum[$__g_vEnum[0]] = ''
	EndIf
	Return 1
EndFunc   ;==>__EnumDefaultProc

Func __EnumPageFilesProc($iSize, $pInfo, $pFile)
	Local $tEPFI = DllStructCreate('dword;dword;ulong_ptr;ulong_ptr;ulong_ptr', $pInfo)

	__Inc($__g_vEnum)
	$__g_vEnum[$__g_vEnum[0][0]][0] = DllStructGetData(DllStructCreate('wchar[' & (_WinAPI_StrLen($pFile) + 1) & ']', $pFile), 1)
	For $i = 1 To 3
		$__g_vEnum[$__g_vEnum[0][0]][$i] = DllStructGetData($tEPFI, $i + 2) * $iSize
	Next
	Return 1
EndFunc   ;==>__EnumPageFilesProc

#EndRegion Internal Functions
