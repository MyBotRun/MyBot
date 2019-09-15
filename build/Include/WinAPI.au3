#include-once

#include "AutoItConstants.au3"
#include "FileConstants.au3"
#include "MsgBoxConstants.au3"
#include "Security.au3"
#include "SendMessage.au3"
#include "StringConstants.au3"
#include "StructureConstants.au3"
#include "WinAPIConstants.au3"
#include "WinAPIError.au3"

; #INDEX# =======================================================================================================================
; Title .........: Windows API
; AutoIt Version : 3.3.14.2
; Description ...: Windows API calls that have been translated to AutoIt functions.
; Author(s) .....: Paul Campbell (PaulIA), gafrost, Siao, Zedna, arcker, Prog@ndy, PsaltyDS, Raik, jpm
; Dll ...........: kernel32.dll, user32.dll, gdi32.dll, comdlg32.dll, shell32.dll, ole32.dll, winspool.drv
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
Global $__g_aInProcess_WinAPI[64][2] = [[0, 0]]
Global $__g_aWinList_WinAPI[64][2] = [[0, 0]]
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $__WINAPICONSTANT_WM_SETFONT = 0x0030
Global Const $__WINAPICONSTANT_FW_NORMAL = 400
Global Const $__WINAPICONSTANT_DEFAULT_CHARSET = 1
Global Const $__WINAPICONSTANT_OUT_DEFAULT_PRECIS = 0
Global Const $__WINAPICONSTANT_CLIP_DEFAULT_PRECIS = 0
Global Const $__WINAPICONSTANT_DEFAULT_QUALITY = 0

Global Const $__WINAPICONSTANT_LOGPIXELSX = 88
Global Const $__WINAPICONSTANT_LOGPIXELSY = 90
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _WinAPI_AttachConsole
; _WinAPI_AttachThreadInput
; _WinAPI_Beep
; _WinAPI_BitBlt
; _WinAPI_CallNextHookEx
; _WinAPI_CallWindowProc
; _WinAPI_ClientToScreen
; _WinAPI_CloseHandle
; _WinAPI_CombineRgn
; _WinAPI_CommDlgExtendedError
; _WinAPI_CopyIcon
; _WinAPI_CreateBitmap
; _WinAPI_CreateCompatibleBitmap
; _WinAPI_CreateCompatibleDC
; _WinAPI_CreateEvent
; _WinAPI_CreateFile
; _WinAPI_CreateFont
; _WinAPI_CreateFontIndirect
; _WinAPI_CreatePen
; _WinAPI_CreateProcess
; _WinAPI_CreateRectRgn
; _WinAPI_CreateRoundRectRgn
; _WinAPI_CreateSolidBitmap
; _WinAPI_CreateSolidBrush
; _WinAPI_CreateWindowEx
; _WinAPI_DefWindowProc
; _WinAPI_DeleteDC
; _WinAPI_DeleteObject
; _WinAPI_DestroyIcon
; _WinAPI_DestroyWindow
; _WinAPI_DrawEdge
; _WinAPI_DrawFrameControl
; _WinAPI_DrawIcon
; _WinAPI_DrawIconEx
; _WinAPI_DrawLine
; _WinAPI_DrawText
; _WinAPI_DuplicateHandle
; _WinAPI_EnableWindow
; _WinAPI_EnumDisplayDevices
; _WinAPI_EnumWindows
; _WinAPI_EnumWindowsPopup
; _WinAPI_EnumWindowsTop
; _WinAPI_ExpandEnvironmentStrings
; _WinAPI_ExtractIconEx
; _WinAPI_FatalAppExit
; _WinAPI_FillRect
; _WinAPI_FindExecutable
; _WinAPI_FindWindow
; _WinAPI_FlashWindow
; _WinAPI_FlashWindowEx
; _WinAPI_FloatToInt
; _WinAPI_FlushFileBuffers
; _WinAPI_FormatMessage
; _WinAPI_FrameRect
; _WinAPI_FreeLibrary
; _WinAPI_GetAncestor
; _WinAPI_GetAsyncKeyState
; _WinAPI_GetBkMode
; _WinAPI_GetClassName
; _WinAPI_GetClientHeight
; _WinAPI_GetClientWidth
; _WinAPI_GetClientRect
; _WinAPI_GetCurrentProcess
; _WinAPI_GetCurrentProcessID
; _WinAPI_GetCurrentThread
; _WinAPI_GetCurrentThreadId
; _WinAPI_GetCursorInfo
; _WinAPI_GetDC
; _WinAPI_GetDesktopWindow
; _WinAPI_GetDeviceCaps
; _WinAPI_GetDIBits
; _WinAPI_GetDlgCtrlID
; _WinAPI_GetDlgItem
; _WinAPI_GetFocus
; _WinAPI_GetForegroundWindow
; _WinAPI_GetGuiResources
; _WinAPI_GetIconInfo
; _WinAPI_GetFileSizeEx
; _WinAPI_GetLastErrorMessage
; _WinAPI_GetLayeredWindowAttributes
; _WinAPI_GetModuleHandle
; _WinAPI_GetMousePos
; _WinAPI_GetMousePosX
; _WinAPI_GetMousePosY
; _WinAPI_GetObject
; _WinAPI_GetOpenFileName
; _WinAPI_GetOverlappedResult
; _WinAPI_GetParent
; _WinAPI_GetProcAddress
; _WinAPI_GetProcessAffinityMask
; _WinAPI_GetSaveFileName
; _WinAPI_GetStockObject
; _WinAPI_GetStdHandle
; _WinAPI_GetSysColor
; _WinAPI_GetSysColorBrush
; _WinAPI_GetSystemMetrics
; _WinAPI_GetTextExtentPoint32
; _WinAPI_GetTextMetrics
; _WinAPI_GetWindow
; _WinAPI_GetWindowDC
; _WinAPI_GetWindowHeight
; _WinAPI_GetWindowLong
; _WinAPI_GetWindowPlacement
; _WinAPI_GetWindowRect
; _WinAPI_GetWindowRgn
; _WinAPI_GetWindowText
; _WinAPI_GetWindowThreadProcessId
; _WinAPI_GetWindowWidth
; _WinAPI_GetXYFromPoint
; _WinAPI_GlobalMemStatus
; _WinAPI_GUIDFromString
; _WinAPI_GUIDFromStringEx
; _WinAPI_HiWord
; _WinAPI_InProcess
; _WinAPI_IntToFloat
; _WinAPI_IsClassName
; _WinAPI_IsWindow
; _WinAPI_IsWindowVisible
; _WinAPI_InvalidateRect
; _WinAPI_LineTo
; _WinAPI_LoadBitmap
; _WinAPI_LoadImage
; _WinAPI_LoadLibrary
; _WinAPI_LoadLibraryEx
; _WinAPI_LoadShell32Icon
; _WinAPI_LoadString
; _WinAPI_LocalFree
; _WinAPI_LoWord
; _WinAPI_MAKELANGID
; _WinAPI_MAKELCID
; _WinAPI_MakeLong
; _WinAPI_MakeQWord
; _WinAPI_MessageBeep
; _WinAPI_Mouse_Event
; _WinAPI_MoveTo
; _WinAPI_MoveWindow
; _WinAPI_MsgBox
; _WinAPI_MulDiv
; _WinAPI_MultiByteToWideChar
; _WinAPI_MultiByteToWideCharEx
; _WinAPI_OpenProcess
; _WinAPI_PathFindOnPath
; _WinAPI_PointFromRect
; _WinAPI_PostMessage
; _WinAPI_PrimaryLangId
; _WinAPI_PtInRect
; _WinAPI_ReadFile
; _WinAPI_ReadProcessMemory
; _WinAPI_RectIsEmpty
; _WinAPI_RedrawWindow
; _WinAPI_RegisterWindowMessage
; _WinAPI_ReleaseCapture
; _WinAPI_ReleaseDC
; _WinAPI_ScreenToClient
; _WinAPI_SelectObject
; _WinAPI_SetBkColor
; _WinAPI_SetBkMode
; _WinAPI_SetCapture
; _WinAPI_SetCursor
; _WinAPI_SetDefaultPrinter
; _WinAPI_SetDIBits
; _WinAPI_SetEndOfFile
; _WinAPI_SetEvent
; _WinAPI_SetFilePointer
; _WinAPI_SetFocus
; _WinAPI_SetFont
; _WinAPI_SetHandleInformation
; _WinAPI_SetLayeredWindowAttributes
; _WinAPI_SetParent
; _WinAPI_SetProcessAffinityMask
; _WinAPI_SetSysColors
; _WinAPI_SetTextColor
; _WinAPI_SetWindowLong
; _WinAPI_SetWindowPlacement
; _WinAPI_SetWindowPos
; _WinAPI_SetWindowRgn
; _WinAPI_SetWindowsHookEx
; _WinAPI_SetWindowText
; _WinAPI_ShowCursor
; _WinAPI_ShowError
; _WinAPI_ShowMsg
; _WinAPI_ShowWindow
; _WinAPI_StringFromGUID
; _WinAPI_StringLenA
; _WinAPI_StringLenW
; _WinAPI_SubLangId
; _WinAPI_SystemParametersInfo
; _WinAPI_TwipsPerPixelX
; _WinAPI_TwipsPerPixelY
; _WinAPI_UnhookWindowsHookEx
; _WinAPI_UpdateLayeredWindow
; _WinAPI_UpdateWindow
; _WinAPI_WaitForInputIdle
; _WinAPI_WaitForMultipleObjects
; _WinAPI_WaitForSingleObject
; _WinAPI_WideCharToMultiByte
; _WinAPI_WindowFromPoint
; _WinAPI_WriteConsole
; _WinAPI_WriteFile
; _WinAPI_WriteProcessMemory
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; $tagCURSORINFO
; $tagDISPLAY_DEVICE
; $tagFLASHWINFO
; $tagICONINFO
; $tagMEMORYSTATUSEX
; __WinAPI_EnumWindowsAdd
; __WinAPI_EnumWindowsChild
; __WinAPI_EnumWindowsInit
; __WinAPI_ParseFileDialogPath
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagCURSORINFO
; Description ...: Contains global cursor information
; Fields ........: Size    - Specifies the size, in bytes, of the structure
;                  Flags   - Specifies the cursor state. This parameter can be one of the following values:
;                  |0               - The cursor is hidden
;                  |$CURSOR_SHOWING - The cursor is showing
;                  hCursor - Handle to the cursor
;                  X       - X position of the cursor, in screen coordinates
;                  Y       - Y position of the cursor, in screen coordinates
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagCURSORINFO = "dword Size;dword Flags;handle hCursor;" & $tagPOINT

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagDISPLAY_DEVICE
; Description ...: Receives information about the display device
; Fields ........: Size   - Specifies the size, in bytes, of the structure
;                  Name   - Either the adapter device or the monitor device
;                  String - Either a description of the display adapter or of the display monitor
;                  Flags  - Device state flags:
;                  |$DISPLAY_DEVICE_ATTACHED_TO_DESKTOP - The device is part of the desktop
;                  |$DISPLAY_DEVICE_MIRRORING_DRIVER    - Represents a pseudo device used to mirror drawing for remoting or other
;                  +purposes. An invisible pseudo monitor is associated with this device.
;                  |$DISPLAY_DEVICE_MODESPRUNED         - The device has more display modes than its output devices support
;                  |$DISPLAY_DEVICE_PRIMARY_DEVICE      - The primary desktop is on the device
;                  |$DISPLAY_DEVICE_REMOVABLE           - The device is removable; it cannot be the primary display
;                  |$DISPLAY_DEVICE_VGA_COMPATIBLE      - The device is VGA compatible.
;                  ID     - This is the Plug and Play identifier
;                  Key    - Reserved
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagDISPLAY_DEVICE = "dword Size;wchar Name[32];wchar String[128];dword Flags;wchar ID[128];wchar Key[128]"

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagFLASHWINFO
; Description ...: Contains the flash status for a window and the number of times the system should flash the window
; Fields ........: Size    - The size of the structure, in bytes
;                  hWnd    - A handle to the window to be flashed. The window can be either opened or minimized.
;                  Flags   - The flash status. This parameter can be one or more of the following values:
;                  |$FLASHW_ALL       - Flash both the window caption and taskbar button
;                  |$FLASHW_CAPTION   - Flash the window caption
;                  |$FLASHW_STOP      - Stop flashing
;                  |$FLASHW_TIMER     - Flash continuously, until the $FLASHW_STOP flag is set
;                  |$FLASHW_TIMERNOFG - Flash continuously until the window comes to the foreground
;                  |$FLASHW_TRAY      - Flash the taskbar button
;                  Count   - The number of times to flash the window
;                  Timeout - The rate at which the window is to be flashed, in milliseconds
; Author ........: Paul Campbell (PaulIA)
; Remarks .......: Needs Constants.au3 for pre-defined constants
; ===============================================================================================================================
Global Const $tagFLASHWINFO = "uint Size;hwnd hWnd;dword Flags;uint Count;dword TimeOut"

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagICONINFO
; Description ...: Contains information about an icon or a cursor
; Fields ........: Icon     - Specifies the contents of the structure:
;                  |True  - Icon
;                  |False - Cursor
;                  XHotSpot - Specifies the x-coordinate of a cursor's hot spot
;                  YHotSpot - Specifies the y-coordinate of the cursor's hot spot
;                  hMask    - Specifies the icon bitmask bitmap
;                  hColor   - Handle to the icon color bitmap
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagICONINFO = "bool Icon;dword XHotSpot;dword YHotSpot;handle hMask;handle hColor"

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagMEMORYSTATUSEX
; Description ...: Contains information memory usage
; Fields ........: Length         - size of the structure, must be set before calling GlobalMemoryStatusEx
;                  MemoryLoad     -
;                  TotalPhys      -
;                  AvailPhys      -
;                  TotalPageFile  -
;                  AvailPageFile  -
;                  TotalVirtual   -
;                  AvailVirtual   -
;                  AvailExtendedVirtual   - Reserved
; Author ........: jpm
; Remarks .......:
; ===============================================================================================================================
Global Const $tagMEMORYSTATUSEX = "dword Length;dword MemoryLoad;" & _
		"uint64 TotalPhys;uint64 AvailPhys;uint64 TotalPageFile;uint64 AvailPageFile;" & _
		"uint64 TotalVirtual;uint64 AvailVirtual;uint64 AvailExtendedVirtual"

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_AttachConsole($iPID = -1)
	Local $aResult = DllCall("kernel32.dll", "bool", "AttachConsole", "dword", $iPID)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_WinAPI_AttachConsole

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_AttachThreadInput($iAttach, $iAttachTo, $bAttach)
	Local $aResult = DllCall("user32.dll", "bool", "AttachThreadInput", "dword", $iAttach, "dword", $iAttachTo, "bool", $bAttach)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_AttachThreadInput

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_Beep($iFreq = 500, $iDuration = 1000)
	Local $aResult = DllCall("kernel32.dll", "bool", "Beep", "dword", $iFreq, "dword", $iDuration)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_Beep

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_BitBlt($hDestDC, $iXDest, $iYDest, $iWidth, $iHeight, $hSrcDC, $iXSrc, $iYSrc, $iROP)
	Local $aResult = DllCall("gdi32.dll", "bool", "BitBlt", "handle", $hDestDC, "int", $iXDest, "int", $iYDest, "int", $iWidth, _
			"int", $iHeight, "handle", $hSrcDC, "int", $iXSrc, "int", $iYSrc, "dword", $iROP)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_BitBlt

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_CallNextHookEx($hHook, $iCode, $wParam, $lParam)
	Local $aResult = DllCall("user32.dll", "lresult", "CallNextHookEx", "handle", $hHook, "int", $iCode, "wparam", $wParam, "lparam", $lParam)
	If @error Then Return SetError(@error, @extended, -1)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_CallNextHookEx

; #FUNCTION# ====================================================================================================================
; Author ........: Siao
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_CallWindowProc($pPrevWndFunc, $hWnd, $iMsg, $wParam, $lParam)
	Local $aResult = DllCall("user32.dll", "lresult", "CallWindowProc", "ptr", $pPrevWndFunc, "hwnd", $hWnd, "uint", $iMsg, _
			"wparam", $wParam, "lparam", $lParam)
	If @error Then Return SetError(@error, @extended, -1)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_CallWindowProc

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_ClientToScreen($hWnd, ByRef $tPoint)
	Local $aRet = DllCall("user32.dll", "bool", "ClientToScreen", "hwnd", $hWnd, "struct*", $tPoint)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $tPoint
EndFunc   ;==>_WinAPI_ClientToScreen

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_CloseHandle($hObject)
	Local $aResult = DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hObject)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_CloseHandle

; #FUNCTION# ====================================================================================================================
; Author ........: Zedna
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_CombineRgn($hRgnDest, $hRgnSrc1, $hRgnSrc2, $iCombineMode)
	Local $aResult = DllCall("gdi32.dll", "int", "CombineRgn", "handle", $hRgnDest, "handle", $hRgnSrc1, "handle", $hRgnSrc2, _
			"int", $iCombineMode)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_CombineRgn

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_CommDlgExtendedError()
	Local Const $CDERR_DIALOGFAILURE = 0xFFFF
	Local Const $CDERR_FINDRESFAILURE = 0x06
	Local Const $CDERR_INITIALIZATION = 0x02
	Local Const $CDERR_LOADRESFAILURE = 0x07
	Local Const $CDERR_LOADSTRFAILURE = 0x05
	Local Const $CDERR_LOCKRESFAILURE = 0x08
	Local Const $CDERR_MEMALLOCFAILURE = 0x09
	Local Const $CDERR_MEMLOCKFAILURE = 0x0A
	Local Const $CDERR_NOHINSTANCE = 0x04
	Local Const $CDERR_NOHOOK = 0x0B
	Local Const $CDERR_NOTEMPLATE = 0x03
	Local Const $CDERR_REGISTERMSGFAIL = 0x0C
	Local Const $CDERR_STRUCTSIZE = 0x01
	Local Const $FNERR_BUFFERTOOSMALL = 0x3003
	Local Const $FNERR_INVALIDFILENAME = 0x3002
	Local Const $FNERR_SUBCLASSFAILURE = 0x3001
	Local $aResult = DllCall("comdlg32.dll", "dword", "CommDlgExtendedError")
	If Not @error Then
		Switch $aResult[0]
			Case $CDERR_DIALOGFAILURE
				Return SetError($aResult[0], 0, "The dialog box could not be created." & @LF & _
						"The common dialog box function's call to the DialogBox function failed." & @LF & _
						"For example, this error occurs if the common dialog box call specifies an invalid window handle.")
			Case $CDERR_FINDRESFAILURE
				Return SetError($aResult[0], 0, "The common dialog box function failed to find a specified resource.")
			Case $CDERR_INITIALIZATION
				Return SetError($aResult[0], 0, "The common dialog box function failed during initialization." & @LF & "This error often occurs when sufficient memory is not available.")
			Case $CDERR_LOADRESFAILURE
				Return SetError($aResult[0], 0, "The common dialog box function failed to load a specified resource.")
			Case $CDERR_LOADSTRFAILURE
				Return SetError($aResult[0], 0, "The common dialog box function failed to load a specified string.")
			Case $CDERR_LOCKRESFAILURE
				Return SetError($aResult[0], 0, "The common dialog box function failed to lock a specified resource.")
			Case $CDERR_MEMALLOCFAILURE
				Return SetError($aResult[0], 0, "The common dialog box function was unable to allocate memory for internal structures.")
			Case $CDERR_MEMLOCKFAILURE
				Return SetError($aResult[0], 0, "The common dialog box function was unable to lock the memory associated with a handle.")
			Case $CDERR_NOHINSTANCE
				Return SetError($aResult[0], 0, "The ENABLETEMPLATE flag was set in the Flags member of the initialization structure for the corresponding common dialog box," & @LF & _
						"but you failed to provide a corresponding instance handle.")
			Case $CDERR_NOHOOK
				Return SetError($aResult[0], 0, "The ENABLEHOOK flag was set in the Flags member of the initialization structure for the corresponding common dialog box," & @LF & _
						"but you failed to provide a pointer to a corresponding hook procedure.")
			Case $CDERR_NOTEMPLATE
				Return SetError($aResult[0], 0, "The ENABLETEMPLATE flag was set in the Flags member of the initialization structure for the corresponding common dialog box," & @LF & _
						"but you failed to provide a corresponding template.")
			Case $CDERR_REGISTERMSGFAIL
				Return SetError($aResult[0], 0, "The RegisterWindowMessage function returned an error code when it was called by the common dialog box function.")
			Case $CDERR_STRUCTSIZE
				Return SetError($aResult[0], 0, "The lStructSize member of the initialization structure for the corresponding common dialog box is invalid")
			Case $FNERR_BUFFERTOOSMALL
				Return SetError($aResult[0], 0, "The buffer pointed to by the lpstrFile member of the OPENFILENAME structure is too small for the file name specified by the user." & @LF & _
						"The first two bytes of the lpstrFile buffer contain an integer value specifying the size, in TCHARs, required to receive the full name.")
			Case $FNERR_INVALIDFILENAME
				Return SetError($aResult[0], 0, "A file name is invalid.")
			Case $FNERR_SUBCLASSFAILURE
				Return SetError($aResult[0], 0, "An attempt to subclass a list box failed because sufficient memory was not available.")
		EndSwitch
	EndIf
	Return SetError(@error, @extended, '0x' & Hex($aResult[0]))
EndFunc   ;==>_WinAPI_CommDlgExtendedError

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_CopyIcon($hIcon)
	Local $aResult = DllCall("user32.dll", "handle", "CopyIcon", "handle", $hIcon)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_CopyIcon

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_CreateBitmap($iWidth, $iHeight, $iPlanes = 1, $iBitsPerPel = 1, $pBits = 0)
	Local $aResult = DllCall("gdi32.dll", "handle", "CreateBitmap", "int", $iWidth, "int", $iHeight, "uint", $iPlanes, _
			"uint", $iBitsPerPel, "struct*", $pBits)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_CreateBitmap

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_CreateCompatibleBitmap($hDC, $iWidth, $iHeight)
	Local $aResult = DllCall("gdi32.dll", "handle", "CreateCompatibleBitmap", "handle", $hDC, "int", $iWidth, "int", $iHeight)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_CreateCompatibleBitmap

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_CreateCompatibleDC($hDC)
	Local $aResult = DllCall("gdi32.dll", "handle", "CreateCompatibleDC", "handle", $hDC)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_CreateCompatibleDC

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CreateEvent($tAttributes = 0, $bManualReset = True, $bInitialState = True, $sName = "")
	Local $sNameType = "wstr"
	If $sName = "" Then
		$sName = 0
		$sNameType = "ptr"
	EndIf

	Local $aResult = DllCall("kernel32.dll", "handle", "CreateEventW", "struct*", $tAttributes, "bool", $bManualReset, _
			"bool", $bInitialState, $sNameType, $sName)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_CreateEvent

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CreateFile($sFileName, $iCreation, $iAccess = 4, $iShare = 0, $iAttributes = 0, $tSecurity = 0)
	Local $iDA = 0, $iSM = 0, $iCD = 0, $iFA = 0

	If BitAND($iAccess, 1) <> 0 Then $iDA = BitOR($iDA, $GENERIC_EXECUTE)
	If BitAND($iAccess, 2) <> 0 Then $iDA = BitOR($iDA, $GENERIC_READ)
	If BitAND($iAccess, 4) <> 0 Then $iDA = BitOR($iDA, $GENERIC_WRITE)

	If BitAND($iShare, 1) <> 0 Then $iSM = BitOR($iSM, $FILE_SHARE_DELETE)
	If BitAND($iShare, 2) <> 0 Then $iSM = BitOR($iSM, $FILE_SHARE_READ)
	If BitAND($iShare, 4) <> 0 Then $iSM = BitOR($iSM, $FILE_SHARE_WRITE)

	Switch $iCreation
		Case 0
			$iCD = $CREATE_NEW
		Case 1
			$iCD = $CREATE_ALWAYS
		Case 2
			$iCD = $OPEN_EXISTING
		Case 3
			$iCD = $OPEN_ALWAYS
		Case 4
			$iCD = $TRUNCATE_EXISTING
	EndSwitch

	If BitAND($iAttributes, 1) <> 0 Then $iFA = BitOR($iFA, $FILE_ATTRIBUTE_ARCHIVE)
	If BitAND($iAttributes, 2) <> 0 Then $iFA = BitOR($iFA, $FILE_ATTRIBUTE_HIDDEN)
	If BitAND($iAttributes, 4) <> 0 Then $iFA = BitOR($iFA, $FILE_ATTRIBUTE_READONLY)
	If BitAND($iAttributes, 8) <> 0 Then $iFA = BitOR($iFA, $FILE_ATTRIBUTE_SYSTEM)

	Local $aResult = DllCall("kernel32.dll", "handle", "CreateFileW", "wstr", $sFileName, "dword", $iDA, "dword", $iSM, _
			"struct*", $tSecurity, "dword", $iCD, "dword", $iFA, "ptr", 0)
	If @error Or ($aResult[0] = $INVALID_HANDLE_VALUE) Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_CreateFile

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CreateFont($iHeight, $iWidth, $iEscape = 0, $iOrientn = 0, $iWeight = $__WINAPICONSTANT_FW_NORMAL, $bItalic = False, $bUnderline = False, $bStrikeout = False, $iCharset = $__WINAPICONSTANT_DEFAULT_CHARSET, $iOutputPrec = $__WINAPICONSTANT_OUT_DEFAULT_PRECIS, $iClipPrec = $__WINAPICONSTANT_CLIP_DEFAULT_PRECIS, $iQuality = $__WINAPICONSTANT_DEFAULT_QUALITY, $iPitch = 0, $sFace = 'Arial')
	Local $aResult = DllCall("gdi32.dll", "handle", "CreateFontW", "int", $iHeight, "int", $iWidth, "int", $iEscape, _
			"int", $iOrientn, "int", $iWeight, "dword", $bItalic, "dword", $bUnderline, "dword", $bStrikeout, _
			"dword", $iCharset, "dword", $iOutputPrec, "dword", $iClipPrec, "dword", $iQuality, "dword", $iPitch, "wstr", $sFace)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_CreateFont

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_CreateFontIndirect($tLogFont)
	Local $aResult = DllCall("gdi32.dll", "handle", "CreateFontIndirectW", "struct*", $tLogFont)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_CreateFontIndirect

; #FUNCTION# ====================================================================================================================
; Author ........: Zedna
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_CreatePen($iPenStyle, $iWidth, $iColor)
	Local $aResult = DllCall("gdi32.dll", "handle", "CreatePen", "int", $iPenStyle, "int", $iWidth, "INT", $iColor)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_CreatePen

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CreateProcess($sAppName, $sCommand, $tSecurity, $tThread, $bInherit, $iFlags, $pEnviron, $sDir, $tStartupInfo, $tProcess)
	Local $tCommand = 0
	Local $sAppNameType = "wstr", $sDirType = "wstr"
	If $sAppName = "" Then
		$sAppNameType = "ptr"
		$sAppName = 0
	EndIf
	If $sCommand <> "" Then
		; must be MAX_PATH characters, can be updated by CreateProcessW
		$tCommand = DllStructCreate("wchar Text[" & 260 + 1 & "]")
		DllStructSetData($tCommand, "Text", $sCommand)
	EndIf
	If $sDir = "" Then
		$sDirType = "ptr"
		$sDir = 0
	EndIf

	Local $aResult = DllCall("kernel32.dll", "bool", "CreateProcessW", $sAppNameType, $sAppName, "struct*", $tCommand, _
			"struct*", $tSecurity, "struct*", $tThread, "bool", $bInherit, "dword", $iFlags, "struct*", $pEnviron, $sDirType, $sDir, _
			"struct*", $tStartupInfo, "struct*", $tProcess)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_CreateProcess

; #FUNCTION# ====================================================================================================================
; Author ........: Zedna
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_CreateRectRgn($iLeftRect, $iTopRect, $iRightRect, $iBottomRect)
	Local $aResult = DllCall("gdi32.dll", "handle", "CreateRectRgn", "int", $iLeftRect, "int", $iTopRect, "int", $iRightRect, _
			"int", $iBottomRect)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_CreateRectRgn

; #FUNCTION# ====================================================================================================================
; Author ........: Zedna
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_CreateRoundRectRgn($iLeftRect, $iTopRect, $iRightRect, $iBottomRect, $iWidthEllipse, $iHeightEllipse)
	Local $aResult = DllCall("gdi32.dll", "handle", "CreateRoundRectRgn", "int", $iLeftRect, "int", $iTopRect, _
			"int", $iRightRect, "int", $iBottomRect, "int", $iWidthEllipse, "int", $iHeightEllipse)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_CreateRoundRectRgn

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (Release DC), Yashied (rewritten)
; ===============================================================================================================================
Func _WinAPI_CreateSolidBitmap($hWnd, $iColor, $iWidth, $iHeight, $bRGB = 1)
	Local $hDC = _WinAPI_GetDC($hWnd)
	Local $hDestDC = _WinAPI_CreateCompatibleDC($hDC)
	Local $hBitmap = _WinAPI_CreateCompatibleBitmap($hDC, $iWidth, $iHeight)
	Local $hOld = _WinAPI_SelectObject($hDestDC, $hBitmap)
	Local $tRECT = DllStructCreate($tagRECT)
	DllStructSetData($tRECT, 1, 0)
	DllStructSetData($tRECT, 2, 0)
	DllStructSetData($tRECT, 3, $iWidth)
	DllStructSetData($tRECT, 4, $iHeight)
	If $bRGB Then
		$iColor = BitOR(BitAND($iColor, 0x00FF00), BitShift(BitAND($iColor, 0x0000FF), -16), BitShift(BitAND($iColor, 0xFF0000), 16))
	EndIf
	Local $hBrush = _WinAPI_CreateSolidBrush($iColor)
	If Not _WinAPI_FillRect($hDestDC, $tRECT, $hBrush) Then
		_WinAPI_DeleteObject($hBitmap)
		$hBitmap = 0
	EndIf
	_WinAPI_DeleteObject($hBrush)
	_WinAPI_ReleaseDC($hWnd, $hDC)
	_WinAPI_SelectObject($hDestDC, $hOld)
	_WinAPI_DeleteDC($hDestDC)
	If Not $hBitmap Then Return SetError(1, 0, 0)
	Return $hBitmap
EndFunc   ;==>_WinAPI_CreateSolidBitmap

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_CreateSolidBrush($iColor)
	Local $aResult = DllCall("gdi32.dll", "handle", "CreateSolidBrush", "INT", $iColor)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_CreateSolidBrush

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CreateWindowEx($iExStyle, $sClass, $sName, $iStyle, $iX, $iY, $iWidth, $iHeight, $hParent, $hMenu = 0, $hInstance = 0, $pParam = 0)
	If $hInstance = 0 Then $hInstance = _WinAPI_GetModuleHandle("")
	Local $aResult = DllCall("user32.dll", "hwnd", "CreateWindowExW", "dword", $iExStyle, "wstr", $sClass, "wstr", $sName, _
			"dword", $iStyle, "int", $iX, "int", $iY, "int", $iWidth, "int", $iHeight, "hwnd", $hParent, "handle", $hMenu, _
			"handle", $hInstance, "struct*", $pParam)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_CreateWindowEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_DefWindowProc($hWnd, $iMsg, $wParam, $lParam)
	Local $aResult = DllCall("user32.dll", "lresult", "DefWindowProc", "hwnd", $hWnd, "uint", $iMsg, "wparam", $wParam, _
			"lparam", $lParam)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_DefWindowProc

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_DeleteDC($hDC)
	Local $aResult = DllCall("gdi32.dll", "bool", "DeleteDC", "handle", $hDC)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_DeleteDC

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_DeleteObject($hObject)
	Local $aResult = DllCall("gdi32.dll", "bool", "DeleteObject", "handle", $hObject)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_DeleteObject

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_DestroyIcon($hIcon)
	Local $aResult = DllCall("user32.dll", "bool", "DestroyIcon", "handle", $hIcon)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_DestroyIcon

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_DestroyWindow($hWnd)
	Local $aResult = DllCall("user32.dll", "bool", "DestroyWindow", "hwnd", $hWnd)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_DestroyWindow

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DrawEdge($hDC, $tRECT, $iEdgeType, $iFlags)
	Local $aResult = DllCall("user32.dll", "bool", "DrawEdge", "handle", $hDC, "struct*", $tRECT, "uint", $iEdgeType, _
			"uint", $iFlags)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_DrawEdge

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DrawFrameControl($hDC, $tRECT, $iType, $iState)
	Local $aResult = DllCall("user32.dll", "bool", "DrawFrameControl", "handle", $hDC, "struct*", $tRECT, "uint", $iType, _
			"uint", $iState)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_DrawFrameControl

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_DrawIcon($hDC, $iX, $iY, $hIcon)
	Local $aResult = DllCall("user32.dll", "bool", "DrawIcon", "handle", $hDC, "int", $iX, "int", $iY, "handle", $hIcon)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_DrawIcon

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_DrawIconEx($hDC, $iX, $iY, $hIcon, $iWidth = 0, $iHeight = 0, $iStep = 0, $hBrush = 0, $iFlags = 3)
	Local $iOptions
	Switch $iFlags
		Case 1
			$iOptions = $DI_MASK
		Case 2
			$iOptions = $DI_IMAGE
		Case 3
			$iOptions = $DI_NORMAL
		Case 4
			$iOptions = $DI_COMPAT
		Case 5
			$iOptions = $DI_DEFAULTSIZE
		Case Else
			$iOptions = $DI_NOMIRROR
	EndSwitch

	Local $aResult = DllCall("user32.dll", "bool", "DrawIconEx", "handle", $hDC, "int", $iX, "int", $iY, "handle", $hIcon, _
			"int", $iWidth, "int", $iHeight, "uint", $iStep, "handle", $hBrush, "uint", $iOptions)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_DrawIconEx

; #FUNCTION# ====================================================================================================================
; Author ........: Zedna
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_DrawLine($hDC, $iX1, $iY1, $iX2, $iY2)
	_WinAPI_MoveTo($hDC, $iX1, $iY1)
	If @error Then Return SetError(@error, @extended, False)
	_WinAPI_LineTo($hDC, $iX2, $iY2)
	If @error Then Return SetError(@error + 10, @extended, False)
	Return True
EndFunc   ;==>_WinAPI_DrawLine

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DrawText($hDC, $sText, ByRef $tRECT, $iFlags)
	Local $aResult = DllCall("user32.dll", "int", "DrawTextW", "handle", $hDC, "wstr", $sText, "int", -1, "struct*", $tRECT, _
			"uint", $iFlags)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_DrawText

; #FUNCTION# ====================================================================================================================
; Author ........: trancexx
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_DuplicateHandle($hSourceProcessHandle, $hSourceHandle, $hTargetProcessHandle, $iDesiredAccess, $iInheritHandle, $iOptions)
	Local $aResult = DllCall("kernel32.dll", "bool", "DuplicateHandle", _
			"handle", $hSourceProcessHandle, _
			"handle", $hSourceHandle, _
			"handle", $hTargetProcessHandle, _
			"handle*", 0, _
			"dword", $iDesiredAccess, _
			"bool", $iInheritHandle, _
			"dword", $iOptions)
	If @error Or Not $aResult[0] Then Return SetError(@error, @extended, 0)

	Return $aResult[4]
EndFunc   ;==>_WinAPI_DuplicateHandle

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_EnableWindow($hWnd, $bEnable = True)
	Local $aResult = DllCall("user32.dll", "bool", "EnableWindow", "hwnd", $hWnd, "bool", $bEnable)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_EnableWindow

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_EnumDisplayDevices($sDevice, $iDevNum)
	Local $tName = 0, $iFlags = 0, $aDevice[5]

	If $sDevice <> "" Then
		$tName = DllStructCreate("wchar Text[" & StringLen($sDevice) + 1 & "]")
		DllStructSetData($tName, "Text", $sDevice)
	EndIf
	Local $tDevice = DllStructCreate($tagDISPLAY_DEVICE)
	Local $iDevice = DllStructGetSize($tDevice)
	DllStructSetData($tDevice, "Size", $iDevice)
	Local $aRet = DllCall("user32.dll", "bool", "EnumDisplayDevicesW", "struct*", $tName, "dword", $iDevNum, "struct*", $tDevice, "dword", 1)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Local $iN = DllStructGetData($tDevice, "Flags")
	If BitAND($iN, $DISPLAY_DEVICE_ATTACHED_TO_DESKTOP) <> 0 Then $iFlags = BitOR($iFlags, 1)
	If BitAND($iN, $DISPLAY_DEVICE_PRIMARY_DEVICE) <> 0 Then $iFlags = BitOR($iFlags, 2)
	If BitAND($iN, $DISPLAY_DEVICE_MIRRORING_DRIVER) <> 0 Then $iFlags = BitOR($iFlags, 4)
	If BitAND($iN, $DISPLAY_DEVICE_VGA_COMPATIBLE) <> 0 Then $iFlags = BitOR($iFlags, 8)
	If BitAND($iN, $DISPLAY_DEVICE_REMOVABLE) <> 0 Then $iFlags = BitOR($iFlags, 16)
	If BitAND($iN, $DISPLAY_DEVICE_MODESPRUNED) <> 0 Then $iFlags = BitOR($iFlags, 32)
	$aDevice[0] = True
	$aDevice[1] = DllStructGetData($tDevice, "Name")
	$aDevice[2] = DllStructGetData($tDevice, "String")
	$aDevice[3] = $iFlags
	$aDevice[4] = DllStructGetData($tDevice, "ID")
	Return $aDevice
EndFunc   ;==>_WinAPI_EnumDisplayDevices

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EnumWindows($bVisible = True, $hWnd = Default)
	__WinAPI_EnumWindowsInit()
	If $hWnd = Default Then $hWnd = _WinAPI_GetDesktopWindow()
	__WinAPI_EnumWindowsChild($hWnd, $bVisible)
	Return $__g_aWinList_WinAPI
EndFunc   ;==>_WinAPI_EnumWindows

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __WinAPI_EnumWindowsAdd
; Description ...: Adds window information to the windows enumeration list
; Syntax.........: __WinAPI_EnumWindowsAdd ( $hWnd [, $sClass = ""] )
; Parameters ....: $hWnd        - Handle to the window
;                  $sClass      - Window class name
; Return values .:
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......: This function is used internally by the windows enumeration functions
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __WinAPI_EnumWindowsAdd($hWnd, $sClass = "")
	If $sClass = "" Then $sClass = _WinAPI_GetClassName($hWnd)
	$__g_aWinList_WinAPI[0][0] += 1
	Local $iCount = $__g_aWinList_WinAPI[0][0]
	If $iCount >= $__g_aWinList_WinAPI[0][1] Then
		ReDim $__g_aWinList_WinAPI[$iCount + 64][2]
		$__g_aWinList_WinAPI[0][1] += 64
	EndIf
	$__g_aWinList_WinAPI[$iCount][0] = $hWnd
	$__g_aWinList_WinAPI[$iCount][1] = $sClass
EndFunc   ;==>__WinAPI_EnumWindowsAdd

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __WinAPI_EnumWindowsChild
; Description ...: Enumerates child windows of a specific window
; Syntax.........: __WinAPI_EnumWindowsChild ( $hWnd [, $bVisible = True] )
; Parameters ....: $hWnd        - Handle of parent window
;                  $bVisible    - Window selection flag:
;                  | True - Returns only visible windows
;                  |False - Returns all windows
; Return values .:
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; Remarks .......: This function is used internally by the windows enumeration functions
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __WinAPI_EnumWindowsChild($hWnd, $bVisible = True)
	$hWnd = _WinAPI_GetWindow($hWnd, $GW_CHILD)
	While $hWnd <> 0
		If (Not $bVisible) Or _WinAPI_IsWindowVisible($hWnd) Then
			__WinAPI_EnumWindowsAdd($hWnd)
			__WinAPI_EnumWindowsChild($hWnd, $bVisible)
		EndIf
		$hWnd = _WinAPI_GetWindow($hWnd, $GW_HWNDNEXT)
	WEnd
EndFunc   ;==>__WinAPI_EnumWindowsChild

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __WinAPI_EnumWindowsInit
; Description ...: Initializes the windows enumeration list
; Syntax.........: __WinAPI_EnumWindowsInit ( )
; Parameters ....:
; Return values .:
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......: This function is used internally by the windows enumeration functions
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __WinAPI_EnumWindowsInit()
	ReDim $__g_aWinList_WinAPI[64][2]
	$__g_aWinList_WinAPI[0][0] = 0
	$__g_aWinList_WinAPI[0][1] = 64
EndFunc   ;==>__WinAPI_EnumWindowsInit

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_EnumWindowsPopup()
	__WinAPI_EnumWindowsInit()
	Local $hWnd = _WinAPI_GetWindow(_WinAPI_GetDesktopWindow(), $GW_CHILD)
	Local $sClass
	While $hWnd <> 0
		If _WinAPI_IsWindowVisible($hWnd) Then
			$sClass = _WinAPI_GetClassName($hWnd)
			If $sClass = "#32768" Then
				__WinAPI_EnumWindowsAdd($hWnd)
			ElseIf $sClass = "ToolbarWindow32" Then
				__WinAPI_EnumWindowsAdd($hWnd)
			ElseIf $sClass = "ToolTips_Class32" Then
				__WinAPI_EnumWindowsAdd($hWnd)
			ElseIf $sClass = "BaseBar" Then
				__WinAPI_EnumWindowsChild($hWnd)
			EndIf
		EndIf
		$hWnd = _WinAPI_GetWindow($hWnd, $GW_HWNDNEXT)
	WEnd
	Return $__g_aWinList_WinAPI
EndFunc   ;==>_WinAPI_EnumWindowsPopup

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_EnumWindowsTop()
	__WinAPI_EnumWindowsInit()
	Local $hWnd = _WinAPI_GetWindow(_WinAPI_GetDesktopWindow(), $GW_CHILD)
	While $hWnd <> 0
		If _WinAPI_IsWindowVisible($hWnd) Then __WinAPI_EnumWindowsAdd($hWnd)
		$hWnd = _WinAPI_GetWindow($hWnd, $GW_HWNDNEXT)
	WEnd
	Return $__g_aWinList_WinAPI
EndFunc   ;==>_WinAPI_EnumWindowsTop

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_ExpandEnvironmentStrings($sString)
	Local $aResult = DllCall("kernel32.dll", "dword", "ExpandEnvironmentStringsW", "wstr", $sString, "wstr", "", "dword", 4096)
	If @error Or Not $aResult[0] Then Return SetError(@error + 10, @extended, "")

	Return $aResult[2]
EndFunc   ;==>_WinAPI_ExpandEnvironmentStrings

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ExtractIconEx($sFilePath, $iIndex, $paLarge, $paSmall, $iIcons)
	Local $aResult = DllCall("shell32.dll", "uint", "ExtractIconExW", "wstr", $sFilePath, "int", $iIndex, "struct*", $paLarge, _
			"struct*", $paSmall, "uint", $iIcons)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_ExtractIconEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_FatalAppExit($sMessage)
	DllCall("kernel32.dll", "none", "FatalAppExitW", "uint", 0, "wstr", $sMessage)
	If @error Then Return SetError(@error, @extended)
EndFunc   ;==>_WinAPI_FatalAppExit

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_FillRect($hDC, $tRECT, $hBrush)
	Local $aResult
	If IsPtr($hBrush) Then
		$aResult = DllCall("user32.dll", "int", "FillRect", "handle", $hDC, "struct*", $tRECT, "handle", $hBrush)
	Else
		$aResult = DllCall("user32.dll", "int", "FillRect", "handle", $hDC, "struct*", $tRECT, "dword_ptr", $hBrush)
	EndIf
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_FillRect

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_FindExecutable($sFileName, $sDirectory = "")
	Local $aResult = DllCall("shell32.dll", "INT", "FindExecutableW", "wstr", $sFileName, "wstr", $sDirectory, "wstr", "")
	If @error Then Return SetError(@error, @extended, '')
	If $aResult[0] <= 32 Then Return SetError(10, $aResult[0], '')

	Return SetExtended($aResult[0], $aResult[3])
EndFunc   ;==>_WinAPI_FindExecutable

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_FindWindow($sClassName, $sWindowName)
	Local $aResult = DllCall("user32.dll", "hwnd", "FindWindowW", "wstr", $sClassName, "wstr", $sWindowName)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_FindWindow

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_FlashWindow($hWnd, $bInvert = True)
	Local $aResult = DllCall("user32.dll", "bool", "FlashWindow", "hwnd", $hWnd, "bool", $bInvert)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_FlashWindow

; #FUNCTION# ====================================================================================================================
; Author ........: Yoan Roblet (arcker)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_FlashWindowEx($hWnd, $iFlags = 3, $iCount = 3, $iTimeout = 0)
	Local $tFlash = DllStructCreate($tagFLASHWINFO)
	Local $iFlash = DllStructGetSize($tFlash)
	Local $iMode = 0
	If BitAND($iFlags, 1) <> 0 Then $iMode = BitOR($iMode, $FLASHW_CAPTION)
	If BitAND($iFlags, 2) <> 0 Then $iMode = BitOR($iMode, $FLASHW_TRAY)
	If BitAND($iFlags, 4) <> 0 Then $iMode = BitOR($iMode, $FLASHW_TIMER)
	If BitAND($iFlags, 8) <> 0 Then $iMode = BitOR($iMode, $FLASHW_TIMERNOFG)
	DllStructSetData($tFlash, "Size", $iFlash)
	DllStructSetData($tFlash, "hWnd", $hWnd)
	DllStructSetData($tFlash, "Flags", $iMode)
	DllStructSetData($tFlash, "Count", $iCount)
	DllStructSetData($tFlash, "Timeout", $iTimeout)
	Local $aResult = DllCall("user32.dll", "bool", "FlashWindowEx", "struct*", $tFlash)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_FlashWindowEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_FloatToInt($nFloat)
	Local $tFloat = DllStructCreate("float")
	Local $tInt = DllStructCreate("int", DllStructGetPtr($tFloat))
	DllStructSetData($tFloat, 1, $nFloat)

	Return DllStructGetData($tInt, 1)
EndFunc   ;==>_WinAPI_FloatToInt

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_FlushFileBuffers($hFile)
	Local $aResult = DllCall("kernel32.dll", "bool", "FlushFileBuffers", "handle", $hFile)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_FlushFileBuffers

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_FormatMessage($iFlags, $pSource, $iMessageID, $iLanguageID, ByRef $pBuffer, $iSize, $vArguments)
	Local $sBufferType = "struct*"
	If IsString($pBuffer) Then $sBufferType = "wstr"
	Local $aResult = DllCall("kernel32.dll", "dword", "FormatMessageW", "dword", $iFlags, "struct*", $pSource, "dword", $iMessageID, _
			"dword", $iLanguageID, $sBufferType, $pBuffer, "dword", $iSize, "ptr", $vArguments)
	If @error Or Not $aResult[0] Then Return SetError(@error + 10, @extended, 0)

	If $sBufferType = "wstr" Then $pBuffer = $aResult[5]
	Return $aResult[0]
EndFunc   ;==>_WinAPI_FormatMessage

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_FrameRect($hDC, $tRECT, $hBrush)
	Local $aResult = DllCall("user32.dll", "int", "FrameRect", "handle", $hDC, "struct*", $tRECT, "handle", $hBrush)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_FrameRect

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_FreeLibrary($hModule)
	Local $aResult = DllCall("kernel32.dll", "bool", "FreeLibrary", "handle", $hModule)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_FreeLibrary

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetAncestor($hWnd, $iFlags = 1)
	Local $aResult = DllCall("user32.dll", "hwnd", "GetAncestor", "hwnd", $hWnd, "uint", $iFlags)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetAncestor

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetAsyncKeyState($iKey)
	Local $aResult = DllCall("user32.dll", "short", "GetAsyncKeyState", "int", $iKey)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetAsyncKeyState

; #FUNCTION# ====================================================================================================================
; Author ........: Zedna
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetBkMode($hDC)
	Local $aResult = DllCall("gdi32.dll", "int", "GetBkMode", "handle", $hDC)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetBkMode

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_GetClassName($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	Local $aResult = DllCall("user32.dll", "int", "GetClassNameW", "hwnd", $hWnd, "wstr", "", "int", 4096)
	If @error Or Not $aResult[0] Then Return SetError(@error, @extended, '')

	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_WinAPI_GetClassName

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetClientHeight($hWnd)
	Local $tRECT = _WinAPI_GetClientRect($hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Return DllStructGetData($tRECT, "Bottom") - DllStructGetData($tRECT, "Top")
EndFunc   ;==>_WinAPI_GetClientHeight

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetClientWidth($hWnd)
	Local $tRECT = _WinAPI_GetClientRect($hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Return DllStructGetData($tRECT, "Right") - DllStructGetData($tRECT, "Left")
EndFunc   ;==>_WinAPI_GetClientWidth

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_GetClientRect($hWnd)
	Local $tRECT = DllStructCreate($tagRECT)
	Local $aRet = DllCall("user32.dll", "bool", "GetClientRect", "hwnd", $hWnd, "struct*", $tRECT)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $tRECT
EndFunc   ;==>_WinAPI_GetClientRect

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetCurrentProcess()
	Local $aResult = DllCall("kernel32.dll", "handle", "GetCurrentProcess")
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetCurrentProcess

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetCurrentProcessID()
	Local $aResult = DllCall("kernel32.dll", "dword", "GetCurrentProcessId")
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetCurrentProcessID

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetCurrentThread()
	Local $aResult = DllCall("kernel32.dll", "handle", "GetCurrentThread")
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetCurrentThread

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetCurrentThreadId()
	Local $aResult = DllCall("kernel32.dll", "dword", "GetCurrentThreadId")
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetCurrentThreadId

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_GetCursorInfo()
	Local $tCursor = DllStructCreate($tagCURSORINFO)
	Local $iCursor = DllStructGetSize($tCursor)
	DllStructSetData($tCursor, "Size", $iCursor)
	Local $aRet = DllCall("user32.dll", "bool", "GetCursorInfo", "struct*", $tCursor)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Local $aCursor[5]
	$aCursor[0] = True
	$aCursor[1] = DllStructGetData($tCursor, "Flags") <> 0
	$aCursor[2] = DllStructGetData($tCursor, "hCursor")
	$aCursor[3] = DllStructGetData($tCursor, "X")
	$aCursor[4] = DllStructGetData($tCursor, "Y")
	Return $aCursor
EndFunc   ;==>_WinAPI_GetCursorInfo

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetDC($hWnd)
	Local $aResult = DllCall("user32.dll", "handle", "GetDC", "hwnd", $hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetDC

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetDesktopWindow()
	Local $aResult = DllCall("user32.dll", "hwnd", "GetDesktopWindow")
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetDesktopWindow

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetDeviceCaps($hDC, $iIndex)
	Local $aResult = DllCall("gdi32.dll", "int", "GetDeviceCaps", "handle", $hDC, "int", $iIndex)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetDeviceCaps

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetDIBits($hDC, $hBitmap, $iStartScan, $iScanLines, $pBits, $tBI, $iUsage)
	Local $aResult = DllCall("gdi32.dll", "int", "GetDIBits", "handle", $hDC, "handle", $hBitmap, "uint", $iStartScan, _
			"uint", $iScanLines, "struct*", $pBits, "struct*", $tBI, "uint", $iUsage)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetDIBits

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetDlgCtrlID($hWnd)
	Local $aResult = DllCall("user32.dll", "int", "GetDlgCtrlID", "hwnd", $hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetDlgCtrlID

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetDlgItem($hWnd, $iItemID)
	Local $aResult = DllCall("user32.dll", "hwnd", "GetDlgItem", "hwnd", $hWnd, "int", $iItemID)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetDlgItem

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_GetFileSizeEx($hFile)
	Local $aResult = DllCall("kernel32.dll", "bool", "GetFileSizeEx", "handle", $hFile, "int64*", 0)
	If @error Or Not $aResult[0] Then Return SetError(@error, @extended, -1)

	Return $aResult[2]
EndFunc   ;==>_WinAPI_GetFileSizeEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetFocus()
	Local $aResult = DllCall("user32.dll", "hwnd", "GetFocus")
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetFocus

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetForegroundWindow()
	Local $aResult = DllCall("user32.dll", "hwnd", "GetForegroundWindow")
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetForegroundWindow

; #FUNCTION# ====================================================================================================================
; Author ........: jpm
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetGuiResources($iFlag = 0, $hProcess = -1)
	If $hProcess = -1 Then $hProcess = _WinAPI_GetCurrentProcess()
	Local $aResult = DllCall("user32.dll", "dword", "GetGuiResources", "handle", $hProcess, "dword", $iFlag)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetGuiResources

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_GetIconInfo($hIcon)
	Local $tInfo = DllStructCreate($tagICONINFO)
	Local $aRet = DllCall("user32.dll", "bool", "GetIconInfo", "handle", $hIcon, "struct*", $tInfo)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Local $aIcon[6]
	$aIcon[0] = True
	$aIcon[1] = DllStructGetData($tInfo, "Icon") <> 0
	$aIcon[2] = DllStructGetData($tInfo, "XHotSpot")
	$aIcon[3] = DllStructGetData($tInfo, "YHotSpot")
	$aIcon[4] = DllStructGetData($tInfo, "hMask")
	$aIcon[5] = DllStructGetData($tInfo, "hColor")
	Return $aIcon
EndFunc   ;==>_WinAPI_GetIconInfo

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm, danielkza, Valik
; ===============================================================================================================================
Func _WinAPI_GetLastErrorMessage()
	Local $iLastError = _WinAPI_GetLastError()
	Local $tBufferPtr = DllStructCreate("ptr")

	Local $nCount = _WinAPI_FormatMessage(BitOR($FORMAT_MESSAGE_ALLOCATE_BUFFER, $FORMAT_MESSAGE_FROM_SYSTEM), _
			0, $iLastError, 0, $tBufferPtr, 0, 0)
	If @error Then Return SetError(@error, 0, "")

	Local $sText = ""
	Local $pBuffer = DllStructGetData($tBufferPtr, 1)
	If $pBuffer Then
		If $nCount > 0 Then
			Local $tBuffer = DllStructCreate("wchar[" & ($nCount + 1) & "]", $pBuffer)
			$sText = DllStructGetData($tBuffer, 1)
			If StringRight($sText, 2) = @CRLF Then $sText = StringTrimRight($sText, 2)
		EndIf
		_WinAPI_LocalFree($pBuffer)
	EndIf

	Return $sText
EndFunc   ;==>_WinAPI_GetLastErrorMessage

; #FUNCTION# ====================================================================================================================
; Author ........: Prog@ndy
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_GetLayeredWindowAttributes($hWnd, ByRef $iTransColor, ByRef $iTransGUI, $bColorRef = False)
	$iTransColor = -1
	$iTransGUI = -1
	Local $aResult = DllCall("user32.dll", "bool", "GetLayeredWindowAttributes", "hwnd", $hWnd, "INT*", $iTransColor, _
			"byte*", $iTransGUI, "dword*", 0)
	If @error Or Not $aResult[0] Then Return SetError(@error, @extended, 0)

	If Not $bColorRef Then
		$aResult[2] = Int(BinaryMid($aResult[2], 3, 1) & BinaryMid($aResult[2], 2, 1) & BinaryMid($aResult[2], 1, 1))
	EndIf
	$iTransColor = $aResult[2]
	$iTransGUI = $aResult[3]
	Return $aResult[4]
EndFunc   ;==>_WinAPI_GetLayeredWindowAttributes

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetModuleHandle($sModuleName)
	Local $sModuleNameType = "wstr"
	If $sModuleName = "" Then
		$sModuleName = 0
		$sModuleNameType = "ptr"
	EndIf

	Local $aResult = DllCall("kernel32.dll", "handle", "GetModuleHandleW", $sModuleNameType, $sModuleName)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetModuleHandle

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_GetMousePos($bToClient = False, $hWnd = 0)
	Local $iMode = Opt("MouseCoordMode", 1)
	Local $aPos = MouseGetPos()
	Opt("MouseCoordMode", $iMode)

	Local $tPoint = DllStructCreate($tagPOINT)
	DllStructSetData($tPoint, "X", $aPos[0])
	DllStructSetData($tPoint, "Y", $aPos[1])
	If $bToClient And Not _WinAPI_ScreenToClient($hWnd, $tPoint) Then Return SetError(@error + 20, @extended, 0)

	Return $tPoint
EndFunc   ;==>_WinAPI_GetMousePos

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetMousePosX($bToClient = False, $hWnd = 0)
	Local $tPoint = _WinAPI_GetMousePos($bToClient, $hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Return DllStructGetData($tPoint, "X")
EndFunc   ;==>_WinAPI_GetMousePosX

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetMousePosY($bToClient = False, $hWnd = 0)
	Local $tPoint = _WinAPI_GetMousePos($bToClient, $hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Return DllStructGetData($tPoint, "Y")
EndFunc   ;==>_WinAPI_GetMousePosY

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetObject($hObject, $iSize, $pObject)
	Local $aResult = DllCall("gdi32.dll", "int", "GetObjectW", "handle", $hObject, "int", $iSize, "struct*", $pObject)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetObject

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetOpenFileName($sTitle = "", $sFilter = "All files (*.*)", $sInitalDir = ".", $sDefaultFile = "", $sDefaultExt = "", $iFilterIndex = 1, $iFlags = 0, $iFlagsEx = 0, $hWndOwner = 0)
	Local $iPathLen = 4096 ; Max chars in returned string
	Local $iNulls = 0
	Local $tOFN = DllStructCreate($tagOPENFILENAME)
	Local $aFiles[1] = [0]

	Local $iFlag = $iFlags

	; Filter string to array conversion
	Local $asFLines = StringSplit($sFilter, "|")
	Local $asFilter[$asFLines[0] * 2 + 1]
	Local $iStart, $iFinal, $tagFilter
	$asFilter[0] = $asFLines[0] * 2
	For $i = 1 To $asFLines[0]
		$iStart = StringInStr($asFLines[$i], "(", 0, 1)
		$iFinal = StringInStr($asFLines[$i], ")", 0, -1)
		$asFilter[$i * 2 - 1] = StringStripWS(StringLeft($asFLines[$i], $iStart - 1), $STR_STRIPLEADING + $STR_STRIPTRAILING)
		$asFilter[$i * 2] = StringStripWS(StringTrimRight(StringTrimLeft($asFLines[$i], $iStart), StringLen($asFLines[$i]) - $iFinal + 1), $STR_STRIPLEADING + $STR_STRIPTRAILING)
		$tagFilter &= "wchar[" & StringLen($asFilter[$i * 2 - 1]) + 1 & "];wchar[" & StringLen($asFilter[$i * 2]) + 1 & "];"
	Next

	Local $tTitle = DllStructCreate("wchar Title[" & StringLen($sTitle) + 1 & "]")
	Local $tInitialDir = DllStructCreate("wchar InitDir[" & StringLen($sInitalDir) + 1 & "]")
	Local $tFilter = DllStructCreate($tagFilter & "wchar")
	Local $tPath = DllStructCreate("wchar Path[" & $iPathLen & "]")
	Local $tExtn = DllStructCreate("wchar Extension[" & StringLen($sDefaultExt) + 1 & "]")
	For $i = 1 To $asFilter[0]
		DllStructSetData($tFilter, $i, $asFilter[$i])
	Next

	; Set Data of API structures
	DllStructSetData($tTitle, "Title", $sTitle)
	DllStructSetData($tInitialDir, "InitDir", $sInitalDir)
	DllStructSetData($tPath, "Path", $sDefaultFile)
	DllStructSetData($tExtn, "Extension", $sDefaultExt)

	DllStructSetData($tOFN, "StructSize", DllStructGetSize($tOFN))
	DllStructSetData($tOFN, "hwndOwner", $hWndOwner)
	DllStructSetData($tOFN, "lpstrFilter", DllStructGetPtr($tFilter))
	DllStructSetData($tOFN, "nFilterIndex", $iFilterIndex)
	DllStructSetData($tOFN, "lpstrFile", DllStructGetPtr($tPath))
	DllStructSetData($tOFN, "nMaxFile", $iPathLen)
	DllStructSetData($tOFN, "lpstrInitialDir", DllStructGetPtr($tInitialDir))
	DllStructSetData($tOFN, "lpstrTitle", DllStructGetPtr($tTitle))
	DllStructSetData($tOFN, "Flags", $iFlag)
	DllStructSetData($tOFN, "lpstrDefExt", DllStructGetPtr($tExtn))
	DllStructSetData($tOFN, "FlagsEx", $iFlagsEx)
	Local $aRes = DllCall("comdlg32.dll", "bool", "GetOpenFileNameW", "struct*", $tOFN)
	If @error Or Not $aRes[0] Then Return SetError(@error + 10, @extended, $aFiles)

	If BitAND($iFlags, $OFN_ALLOWMULTISELECT) = $OFN_ALLOWMULTISELECT And BitAND($iFlags, $OFN_EXPLORER) = $OFN_EXPLORER Then
		For $x = 1 To $iPathLen
			If DllStructGetData($tPath, "Path", $x) = Chr(0) Then
				DllStructSetData($tPath, "Path", "|", $x)
				$iNulls += 1
			Else
				$iNulls = 0
			EndIf
			If $iNulls = 2 Then ExitLoop
		Next
		DllStructSetData($tPath, "Path", Chr(0), $x - 1)
		$aFiles = StringSplit(DllStructGetData($tPath, "Path"), "|")
		If $aFiles[0] = 1 Then Return __WinAPI_ParseFileDialogPath(DllStructGetData($tPath, "Path"))
		Return StringSplit(DllStructGetData($tPath, "Path"), "|")
	ElseIf BitAND($iFlags, $OFN_ALLOWMULTISELECT) = $OFN_ALLOWMULTISELECT Then
		$aFiles = StringSplit(DllStructGetData($tPath, "Path"), " ")
		If $aFiles[0] = 1 Then Return __WinAPI_ParseFileDialogPath(DllStructGetData($tPath, "Path"))
		Return StringSplit(StringReplace(DllStructGetData($tPath, "Path"), " ", "|"), "|")
	Else
		Return __WinAPI_ParseFileDialogPath(DllStructGetData($tPath, "Path"))
	EndIf
EndFunc   ;==>_WinAPI_GetOpenFileName

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_GetOverlappedResult($hFile, $tOverlapped, ByRef $iBytes, $bWait = False)
	Local $aResult = DllCall("kernel32.dll", "bool", "GetOverlappedResult", "handle", $hFile, "struct*", $tOverlapped, "dword*", 0, _
			"bool", $bWait)
	If @error Or Not $aResult[0] Then Return SetError(@error, @extended, False)

	$iBytes = $aResult[3]
	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetOverlappedResult

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetParent($hWnd)
	Local $aResult = DllCall("user32.dll", "hwnd", "GetParent", "hwnd", $hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetParent

; #FUNCTION# ====================================================================================================================
; Author ........: trancexx
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_GetProcAddress($hModule, $vName)
	Local $sType = "str"
	If IsNumber($vName) Then $sType = "word" ; if ordinal value passed
	Local $aResult = DllCall("kernel32.dll", "ptr", "GetProcAddress", "handle", $hModule, $sType, $vName)
	If @error Or Not $aResult[0] Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetProcAddress

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_GetProcessAffinityMask($hProcess)
	Local $aResult = DllCall("kernel32.dll", "bool", "GetProcessAffinityMask", "handle", $hProcess, "dword_ptr*", 0, "dword_ptr*", 0)
	If @error Or Not $aResult[0] Then Return SetError(@error + 10, @extended, 0)

	Local $aMask[3]
	$aMask[0] = True
	$aMask[1] = $aResult[2]
	$aMask[2] = $aResult[3]
	Return $aMask
EndFunc   ;==>_WinAPI_GetProcessAffinityMask

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetSaveFileName($sTitle = "", $sFilter = "All files (*.*)", $sInitalDir = ".", $sDefaultFile = "", $sDefaultExt = "", $iFilterIndex = 1, $iFlags = 0, $iFlagsEx = 0, $hWndOwner = 0)
	Local $iPathLen = 4096 ; Max chars in returned string
	Local $tOFN = DllStructCreate($tagOPENFILENAME)
	Local $aFiles[1] = [0]

	Local $iFlag = $iFlags

	; Filter string to array conversion
	Local $asFLines = StringSplit($sFilter, "|")
	Local $asFilter[$asFLines[0] * 2 + 1]
	Local $iStart, $iFinal, $tagFilter
	$asFilter[0] = $asFLines[0] * 2
	For $i = 1 To $asFLines[0]
		$iStart = StringInStr($asFLines[$i], "(", 0, 1)
		$iFinal = StringInStr($asFLines[$i], ")", 0, -1)
		$asFilter[$i * 2 - 1] = StringStripWS(StringLeft($asFLines[$i], $iStart - 1), $STR_STRIPLEADING + $STR_STRIPTRAILING)
		$asFilter[$i * 2] = StringStripWS(StringTrimRight(StringTrimLeft($asFLines[$i], $iStart), StringLen($asFLines[$i]) - $iFinal + 1), $STR_STRIPLEADING + $STR_STRIPTRAILING)
		$tagFilter &= "wchar[" & StringLen($asFilter[$i * 2 - 1]) + 1 & "];wchar[" & StringLen($asFilter[$i * 2]) + 1 & "];"
	Next

	Local $tTitle = DllStructCreate("wchar Title[" & StringLen($sTitle) + 1 & "]")
	Local $tInitialDir = DllStructCreate("wchar InitDir[" & StringLen($sInitalDir) + 1 & "]")
	Local $tFilter = DllStructCreate($tagFilter & "wchar")
	Local $tPath = DllStructCreate("wchar Path[" & $iPathLen & "]")
	Local $tExtn = DllStructCreate("wchar Extension[" & StringLen($sDefaultExt) + 1 & "]")
	For $i = 1 To $asFilter[0]
		DllStructSetData($tFilter, $i, $asFilter[$i])
	Next

	; Set Data of API structures
	DllStructSetData($tTitle, "Title", $sTitle)
	DllStructSetData($tInitialDir, "InitDir", $sInitalDir)
	DllStructSetData($tPath, "Path", $sDefaultFile)
	DllStructSetData($tExtn, "Extension", $sDefaultExt)

	DllStructSetData($tOFN, "StructSize", DllStructGetSize($tOFN))
	DllStructSetData($tOFN, "hwndOwner", $hWndOwner)
	DllStructSetData($tOFN, "lpstrFilter", DllStructGetPtr($tFilter))
	DllStructSetData($tOFN, "nFilterIndex", $iFilterIndex)
	DllStructSetData($tOFN, "lpstrFile", DllStructGetPtr($tPath))
	DllStructSetData($tOFN, "nMaxFile", $iPathLen)
	DllStructSetData($tOFN, "lpstrInitialDir", DllStructGetPtr($tInitialDir))
	DllStructSetData($tOFN, "lpstrTitle", DllStructGetPtr($tTitle))
	DllStructSetData($tOFN, "Flags", $iFlag)
	DllStructSetData($tOFN, "lpstrDefExt", DllStructGetPtr($tExtn))
	DllStructSetData($tOFN, "FlagsEx", $iFlagsEx)
	Local $aRes = DllCall("comdlg32.dll", "bool", "GetSaveFileNameW", "struct*", $tOFN)
	If @error Or Not $aRes[0] Then Return SetError(@error + 10, @extended, $aFiles)

	Return __WinAPI_ParseFileDialogPath(DllStructGetData($tPath, "Path"))
EndFunc   ;==>_WinAPI_GetSaveFileName

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetStockObject($iObject)
	Local $aResult = DllCall("gdi32.dll", "handle", "GetStockObject", "int", $iObject)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetStockObject

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetStdHandle($iStdHandle)
	If $iStdHandle < 0 Or $iStdHandle > 2 Then Return SetError(2, 0, -1)
	Local Const $aHandle[3] = [-10, -11, -12]

	Local $aResult = DllCall("kernel32.dll", "handle", "GetStdHandle", "dword", $aHandle[$iStdHandle])
	If @error Then Return SetError(@error, @extended, -1)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetStdHandle

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetSysColor($iIndex)
	Local $aResult = DllCall("user32.dll", "INT", "GetSysColor", "int", $iIndex)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetSysColor

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetSysColorBrush($iIndex)
	Local $aResult = DllCall("user32.dll", "handle", "GetSysColorBrush", "int", $iIndex)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetSysColorBrush

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetSystemMetrics($iIndex)
	Local $aResult = DllCall("user32.dll", "int", "GetSystemMetrics", "int", $iIndex)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetSystemMetrics

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_GetTextExtentPoint32($hDC, $sText)
	Local $tSize = DllStructCreate($tagSIZE)
	Local $iSize = StringLen($sText)
	Local $aRet = DllCall("gdi32.dll", "bool", "GetTextExtentPoint32W", "handle", $hDC, "wstr", $sText, "int", $iSize, "struct*", $tSize)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $tSize
EndFunc   ;==>_WinAPI_GetTextExtentPoint32

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetTextMetrics($hDC)
	Local $tTEXTMETRIC = DllStructCreate($tagTEXTMETRIC)
	Local $aRet = DllCall('gdi32.dll', 'bool', 'GetTextMetricsW', 'handle', $hDC, 'struct*', $tTEXTMETRIC)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $tTEXTMETRIC
EndFunc   ;==>_WinAPI_GetTextMetrics

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetWindow($hWnd, $iCmd)
	Local $aResult = DllCall("user32.dll", "hwnd", "GetWindow", "hwnd", $hWnd, "uint", $iCmd)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetWindow

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetWindowDC($hWnd)
	Local $aResult = DllCall("user32.dll", "handle", "GetWindowDC", "hwnd", $hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetWindowDC

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetWindowHeight($hWnd)
	Local $tRECT = _WinAPI_GetWindowRect($hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Return DllStructGetData($tRECT, "Bottom") - DllStructGetData($tRECT, "Top")
EndFunc   ;==>_WinAPI_GetWindowHeight

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_GetWindowLong($hWnd, $iIndex)
	Local $sFuncName = "GetWindowLongW"
	If @AutoItX64 Then $sFuncName = "GetWindowLongPtrW"
	Local $aResult = DllCall("user32.dll", "long_ptr", $sFuncName, "hwnd", $hWnd, "int", $iIndex)
	If @error Or Not $aResult[0] Then Return SetError(@error + 10, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetWindowLong

; #FUNCTION# ====================================================================================================================
; Author ........: PsaltyDS, with help from Siao and SmOke_N, at www.autoitscript.com/forum
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_GetWindowPlacement($hWnd)
	; Create struct to receive data
	Local $tWindowPlacement = DllStructCreate($tagWINDOWPLACEMENT)
	DllStructSetData($tWindowPlacement, "length", DllStructGetSize($tWindowPlacement))
	Local $aRet = DllCall("user32.dll", "bool", "GetWindowPlacement", "hwnd", $hWnd, "struct*", $tWindowPlacement)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $tWindowPlacement
EndFunc   ;==>_WinAPI_GetWindowPlacement

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_GetWindowRect($hWnd)
	Local $tRECT = DllStructCreate($tagRECT)
	Local $aRet = DllCall("user32.dll", "bool", "GetWindowRect", "hwnd", $hWnd, "struct*", $tRECT)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $tRECT
EndFunc   ;==>_WinAPI_GetWindowRect

; #FUNCTION# ====================================================================================================================
; Author ........: Zedna
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetWindowRgn($hWnd, $hRgn)
	Local $aResult = DllCall("user32.dll", "int", "GetWindowRgn", "hwnd", $hWnd, "handle", $hRgn)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetWindowRgn

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_GetWindowText($hWnd)
	Local $aResult = DllCall("user32.dll", "int", "GetWindowTextW", "hwnd", $hWnd, "wstr", "", "int", 4096)
	If @error Or Not $aResult[0] Then Return SetError(@error + 10, @extended, "")

	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_WinAPI_GetWindowText

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetWindowThreadProcessId($hWnd, ByRef $iPID)
	Local $aResult = DllCall("user32.dll", "dword", "GetWindowThreadProcessId", "hwnd", $hWnd, "dword*", 0)
	If @error Then Return SetError(@error, @extended, 0)

	$iPID = $aResult[2]
	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetWindowThreadProcessId

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetWindowWidth($hWnd)
	Local $tRECT = _WinAPI_GetWindowRect($hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Return DllStructGetData($tRECT, "Right") - DllStructGetData($tRECT, "Left")
EndFunc   ;==>_WinAPI_GetWindowWidth

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_GetXYFromPoint(ByRef $tPoint, ByRef $iX, ByRef $iY)
	$iX = DllStructGetData($tPoint, "X")
	$iY = DllStructGetData($tPoint, "Y")
EndFunc   ;==>_WinAPI_GetXYFromPoint

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_GlobalMemoryStatus()
	Local $tMem = DllStructCreate($tagMEMORYSTATUSEX)
	DllStructSetData($tMem, 1, DllStructGetSize($tMem))
	Local $aRet = DllCall("kernel32.dll", "bool", "GlobalMemoryStatusEx", "struct*", $tMem)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Local $aMem[7]
	$aMem[0] = DllStructGetData($tMem, 2)
	$aMem[1] = DllStructGetData($tMem, 3)
	$aMem[2] = DllStructGetData($tMem, 4)
	$aMem[3] = DllStructGetData($tMem, 5)
	$aMem[4] = DllStructGetData($tMem, 6)
	$aMem[5] = DllStructGetData($tMem, 7)
	$aMem[6] = DllStructGetData($tMem, 8)
	Return $aMem
EndFunc   ;==>_WinAPI_GlobalMemoryStatus

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM, guinness
; ===============================================================================================================================
Func _WinAPI_GUIDFromString($sGUID)
	Local $tGUID = DllStructCreate($tagGUID)
	_WinAPI_GUIDFromStringEx($sGUID, $tGUID)
	If @error Then Return SetError(@error + 10, @extended, 0)
	; If Not _WinAPI_GUIDFromStringEx($sGUID, $tGUID) Then Return SetError(@error + 10, @extended, 0)

	Return $tGUID
EndFunc   ;==>_WinAPI_GUIDFromString

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GUIDFromStringEx($sGUID, $tGUID)
	Local $aResult = DllCall("ole32.dll", "long", "CLSIDFromString", "wstr", $sGUID, "struct*", $tGUID)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_GUIDFromStringEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_HiWord($iLong)
	Return BitShift($iLong, 16)
EndFunc   ;==>_WinAPI_HiWord

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_InProcess($hWnd, ByRef $hLastWnd)
	If $hWnd = $hLastWnd Then Return True
	For $iI = $__g_aInProcess_WinAPI[0][0] To 1 Step -1
		If $hWnd = $__g_aInProcess_WinAPI[$iI][0] Then
			If $__g_aInProcess_WinAPI[$iI][1] Then
				$hLastWnd = $hWnd
				Return True
			Else
				Return False
			EndIf
		EndIf
	Next
	Local $iPID
	_WinAPI_GetWindowThreadProcessId($hWnd, $iPID)
	Local $iCount = $__g_aInProcess_WinAPI[0][0] + 1
	If $iCount >= 64 Then $iCount = 1
	$__g_aInProcess_WinAPI[0][0] = $iCount
	$__g_aInProcess_WinAPI[$iCount][0] = $hWnd
	$__g_aInProcess_WinAPI[$iCount][1] = ($iPID = @AutoItPID)
	Return $__g_aInProcess_WinAPI[$iCount][1]
EndFunc   ;==>_WinAPI_InProcess

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_IntToFloat($iInt)
	Local $tInt = DllStructCreate("int")
	Local $tFloat = DllStructCreate("float", DllStructGetPtr($tInt))
	DllStructSetData($tInt, 1, $iInt)

	Return DllStructGetData($tFloat, 1)
EndFunc   ;==>_WinAPI_IntToFloat

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_IsClassName($hWnd, $sClassName)
	Local $sSeparator = Opt("GUIDataSeparatorChar")
	Local $aClassName = StringSplit($sClassName, $sSeparator)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	Local $sClassCheck = _WinAPI_GetClassName($hWnd) ; ClassName from Handle
	; check array of ClassNames against ClassName Returned
	For $x = 1 To UBound($aClassName) - 1
		If StringUpper(StringMid($sClassCheck, 1, StringLen($aClassName[$x]))) = StringUpper($aClassName[$x]) Then Return True
	Next
	Return False
EndFunc   ;==>_WinAPI_IsClassName

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_IsWindow($hWnd)
	Local $aResult = DllCall("user32.dll", "bool", "IsWindow", "hwnd", $hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_IsWindow

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_IsWindowVisible($hWnd)
	Local $aResult = DllCall("user32.dll", "bool", "IsWindowVisible", "hwnd", $hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_IsWindowVisible

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_InvalidateRect($hWnd, $tRECT = 0, $bErase = True)
	Local $aResult = DllCall("user32.dll", "bool", "InvalidateRect", "hwnd", $hWnd, "struct*", $tRECT, "bool", $bErase)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_InvalidateRect

; #FUNCTION# ====================================================================================================================
; Author ........: Zedna
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_LineTo($hDC, $iX, $iY)
	Local $aResult = DllCall("gdi32.dll", "bool", "LineTo", "handle", $hDC, "int", $iX, "int", $iY)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_LineTo

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_LoadBitmap($hInstance, $sBitmap)
	Local $sBitmapType = "int"
	If IsString($sBitmap) Then $sBitmapType = "wstr"
	Local $aResult = DllCall("user32.dll", "handle", "LoadBitmapW", "handle", $hInstance, $sBitmapType, $sBitmap)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_LoadBitmap

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_LoadImage($hInstance, $sImage, $iType, $iXDesired, $iYDesired, $iLoad)
	Local $aResult, $sImageType = "int"
	If IsString($sImage) Then $sImageType = "wstr"
	$aResult = DllCall("user32.dll", "handle", "LoadImageW", "handle", $hInstance, $sImageType, $sImage, "uint", $iType, _
			"int", $iXDesired, "int", $iYDesired, "uint", $iLoad)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_LoadImage

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_LoadLibrary($sFileName)
	Local $aResult = DllCall("kernel32.dll", "handle", "LoadLibraryW", "wstr", $sFileName)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_LoadLibrary

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_LoadLibraryEx($sFileName, $iFlags = 0)
	Local $aResult = DllCall("kernel32.dll", "handle", "LoadLibraryExW", "wstr", $sFileName, "ptr", 0, "dword", $iFlags)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_LoadLibraryEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_LoadShell32Icon($iIconID)
	Local $tIcons = DllStructCreate("ptr Data")
	Local $iIcons = _WinAPI_ExtractIconEx("shell32.dll", $iIconID, 0, $tIcons, 1)
	If @error Then Return SetError(@error, @extended, 0)
	If $iIcons <= 0 Then Return SetError(10, 0, 0)

	Return DllStructGetData($tIcons, "Data")
EndFunc   ;==>_WinAPI_LoadShell32Icon

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost used correct syntax, Original concept Raik
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_LoadString($hInstance, $iStringID)
	Local $aResult = DllCall("user32.dll", "int", "LoadStringW", "handle", $hInstance, "uint", $iStringID, "wstr", "", "int", 4096)
	If @error Or Not $aResult[0] Then Return SetError(@error + 10, @extended, "")

	Return SetExtended($aResult[0], $aResult[3])
EndFunc   ;==>_WinAPI_LoadString

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_LocalFree($hMemory)
	Local $aResult = DllCall("kernel32.dll", "handle", "LocalFree", "handle", $hMemory)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_LocalFree

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_LoWord($iLong)
	Return BitAND($iLong, 0xFFFF)
EndFunc   ;==>_WinAPI_LoWord

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_MAKELANGID($iLngIDPrimary, $iLngIDSub)
	Return BitOR(BitShift($iLngIDSub, -10), $iLngIDPrimary)
EndFunc   ;==>_WinAPI_MAKELANGID

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_MAKELCID($iLngID, $iSortID)
	Return BitOR(BitShift($iSortID, -16), $iLngID)
EndFunc   ;==>_WinAPI_MAKELCID

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_MakeLong($iLo, $iHi)
	Return BitOR(BitShift($iHi, -16), BitAND($iLo, 0xFFFF))
EndFunc   ;==>_WinAPI_MakeLong

; #FUNCTION# ====================================================================================================================
; Author ........: jpm
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_MakeQWord($iLoDWORD, $iHiDWORD)
	Local $tInt64 = DllStructCreate("uint64")
	Local $tDwords = DllStructCreate("dword;dword", DllStructGetPtr($tInt64))
	DllStructSetData($tDwords, 1, $iLoDWORD)
	DllStructSetData($tDwords, 2, $iHiDWORD)

	Return DllStructGetData($tInt64, 1)
EndFunc   ;==>_WinAPI_MakeQWord

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_MessageBeep($iType = 1)
	Local $iSound
	Switch $iType
		Case 1
			$iSound = 0
		Case 2
			$iSound = 16
		Case 3
			$iSound = 32
		Case 4
			$iSound = 48
		Case 5
			$iSound = 64
		Case Else
			$iSound = -1
	EndSwitch

	Local $aResult = DllCall("user32.dll", "bool", "MessageBeep", "uint", $iSound)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_MessageBeep

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_MsgBox($iFlags, $sTitle, $sText)
	BlockInput(0)
	MsgBox($iFlags, $sTitle, $sText & "      ")
EndFunc   ;==>_WinAPI_MsgBox

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_Mouse_Event($iFlags, $iX = 0, $iY = 0, $iData = 0, $iExtraInfo = 0)
	DllCall("user32.dll", "none", "mouse_event", "dword", $iFlags, "dword", $iX, "dword", $iY, "dword", $iData, _
			"ulong_ptr", $iExtraInfo)
	If @error Then Return SetError(@error, @extended)
EndFunc   ;==>_WinAPI_Mouse_Event

; #FUNCTION# ====================================================================================================================
; Author ........: Zedna
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_MoveTo($hDC, $iX, $iY)
	Local $aResult = DllCall("gdi32.dll", "bool", "MoveToEx", "handle", $hDC, "int", $iX, "int", $iY, "ptr", 0)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_MoveTo

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_MoveWindow($hWnd, $iX, $iY, $iWidth, $iHeight, $bRepaint = True)
	Local $aResult = DllCall("user32.dll", "bool", "MoveWindow", "hwnd", $hWnd, "int", $iX, "int", $iY, "int", $iWidth, _
			"int", $iHeight, "bool", $bRepaint)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_MoveWindow

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_MulDiv($iNumber, $iNumerator, $iDenominator)
	Local $aResult = DllCall("kernel32.dll", "int", "MulDiv", "int", $iNumber, "int", $iNumerator, "int", $iDenominator)
	If @error Then Return SetError(@error, @extended, -1)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_MulDiv

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM, Alexander Samuelsson (AdmiralAlkex)
; ===============================================================================================================================
Func _WinAPI_MultiByteToWideChar($vText, $iCodePage = 0, $iFlags = 0, $bRetString = False)
	Local $sTextType = "str"
	If Not IsString($vText) Then $sTextType = "struct*"

	; compute size for the output WideChar
	Local $aResult = DllCall("kernel32.dll", "int", "MultiByteToWideChar", "uint", $iCodePage, "dword", $iFlags, _
			$sTextType, $vText, "int", -1, "ptr", 0, "int", 0)
	If @error Or Not $aResult[0] Then Return SetError(@error + 10, @extended, 0)

	; allocate space for output WideChar
	Local $iOut = $aResult[0]
	Local $tOut = DllStructCreate("wchar[" & $iOut & "]")

	$aResult = DllCall("kernel32.dll", "int", "MultiByteToWideChar", "uint", $iCodePage, "dword", $iFlags, $sTextType, $vText, _
			"int", -1, "struct*", $tOut, "int", $iOut)
	If @error Or Not $aResult[0] Then Return SetError(@error + 20, @extended, 0)

	If $bRetString Then Return DllStructGetData($tOut, 1)
	Return $tOut
EndFunc   ;==>_WinAPI_MultiByteToWideChar

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_MultiByteToWideCharEx($sText, $pText, $iCodePage = 0, $iFlags = 0)
	Local $aResult = DllCall("kernel32.dll", "int", "MultiByteToWideChar", "uint", $iCodePage, "dword", $iFlags, "STR", $sText, _
			"int", -1, "struct*", $pText, "int", (StringLen($sText) + 1) * 2)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_MultiByteToWideCharEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_OpenProcess($iAccess, $bInherit, $iPID, $bDebugPriv = False)
	; Attempt to open process with standard security priviliges
	Local $aResult = DllCall("kernel32.dll", "handle", "OpenProcess", "dword", $iAccess, "bool", $bInherit, "dword", $iPID)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return $aResult[0]
	If Not $bDebugPriv Then Return SetError(100, 0, 0)

	; Enable debug privileged mode
	Local $hToken = _Security__OpenThreadTokenEx(BitOR($TOKEN_ADJUST_PRIVILEGES, $TOKEN_QUERY))
	If @error Then Return SetError(@error + 10, @extended, 0)
	_Security__SetPrivilege($hToken, "SeDebugPrivilege", True)
	Local $iError = @error
	Local $iExtended = @extended
	Local $iRet = 0
	If Not @error Then
		; Attempt to open process with debug privileges
		$aResult = DllCall("kernel32.dll", "handle", "OpenProcess", "dword", $iAccess, "bool", $bInherit, "dword", $iPID)
		$iError = @error
		$iExtended = @extended
		If $aResult[0] Then $iRet = $aResult[0]

		; Disable debug privileged mode
		_Security__SetPrivilege($hToken, "SeDebugPrivilege", False)
		If @error Then
			$iError = @error + 20
			$iExtended = @extended
		EndIf
	Else
		$iError = @error + 30 ; SeDebugPrivilege=True error
	EndIf
	_WinAPI_CloseHandle($hToken)

	Return SetError($iError, $iExtended, $iRet)
EndFunc   ;==>_WinAPI_OpenProcess

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __WinAPI_ParseFileDialogPath
; Description ...: Returns array from the path string
; Syntax.........: __WinAPI_ParseFileDialogPath ( $sPath )
; Parameters ....: $sPath       - string conataining the path and file(s)
; Return values .: Success      - array containing path and file(s)
; Author ........: Gary Frost
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __WinAPI_ParseFileDialogPath($sPath)
	Local $aFiles[3]
	$aFiles[0] = 2
	Local $sTemp = StringMid($sPath, 1, StringInStr($sPath, "\", 0, -1) - 1)
	$aFiles[1] = $sTemp
	$aFiles[2] = StringMid($sPath, StringInStr($sPath, "\", 0, -1) + 1)
	Return $aFiles
EndFunc   ;==>__WinAPI_ParseFileDialogPath

; #FUNCTION# ====================================================================================================================
; Author ........: Daniel Miranda (danielkza)
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_PathFindOnPath(Const $sFilePath, $aExtraPaths = "", Const $sPathDelimiter = @LF)
	Local $iExtraCount = 0
	If IsString($aExtraPaths) Then
		If StringLen($aExtraPaths) Then
			$aExtraPaths = StringSplit($aExtraPaths, $sPathDelimiter, $STR_ENTIRESPLIT + $STR_NOCOUNT)
			$iExtraCount = UBound($aExtraPaths, $UBOUND_ROWS)
		EndIf
	ElseIf IsArray($aExtraPaths) Then
		$iExtraCount = UBound($aExtraPaths)
	EndIf

	Local $tPaths, $tPathPtrs
	If $iExtraCount Then
		Local $tagStruct = ""
		For $path In $aExtraPaths
			$tagStruct &= "wchar[" & StringLen($path) + 1 & "];"
		Next

		$tPaths = DllStructCreate($tagStruct)
		$tPathPtrs = DllStructCreate("ptr[" & $iExtraCount + 1 & "]")

		For $i = 1 To $iExtraCount
			DllStructSetData($tPaths, $i, $aExtraPaths[$i - 1])
			DllStructSetData($tPathPtrs, 1, DllStructGetPtr($tPaths, $i), $i)
		Next
		DllStructSetData($tPathPtrs, 1, Ptr(0), $iExtraCount + 1)
	EndIf

	Local $aResult = DllCall("shlwapi.dll", "bool", "PathFindOnPathW", "wstr", $sFilePath, "struct*", $tPathPtrs)
	If @error Or Not $aResult[0] Then Return SetError(@error + 10, @extended, $sFilePath)

	Return $aResult[1]
EndFunc   ;==>_WinAPI_PathFindOnPath

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_PointFromRect(ByRef $tRECT, $bCenter = True)
	Local $iX1 = DllStructGetData($tRECT, "Left")
	Local $iY1 = DllStructGetData($tRECT, "Top")
	Local $iX2 = DllStructGetData($tRECT, "Right")
	Local $iY2 = DllStructGetData($tRECT, "Bottom")
	If $bCenter Then
		$iX1 = $iX1 + (($iX2 - $iX1) / 2)
		$iY1 = $iY1 + (($iY2 - $iY1) / 2)
	EndIf
	Local $tPoint = DllStructCreate($tagPOINT)
	DllStructSetData($tPoint, "X", $iX1)
	DllStructSetData($tPoint, "Y", $iY1)
	Return $tPoint
EndFunc   ;==>_WinAPI_PointFromRect

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_PostMessage($hWnd, $iMsg, $wParam, $lParam)
	Local $aResult = DllCall("user32.dll", "bool", "PostMessage", "hwnd", $hWnd, "uint", $iMsg, "wparam", $wParam, _
			"lparam", $lParam)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_WinAPI_PostMessage

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_PrimaryLangId($iLngID)
	Return BitAND($iLngID, 0x3FF)
EndFunc   ;==>_WinAPI_PrimaryLangId

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: trancexx
; ===============================================================================================================================
Func _WinAPI_PtInRect(ByRef $tRECT, ByRef $tPoint)
	Local $aResult = DllCall("user32.dll", "bool", "PtInRect", "struct*", $tRECT, "struct", $tPoint)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_PtInRect

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ReadFile($hFile, $pBuffer, $iToRead, ByRef $iRead, $tOverlapped = 0)
	Local $aResult = DllCall("kernel32.dll", "bool", "ReadFile", "handle", $hFile, "struct*", $pBuffer, "dword", $iToRead, _
			"dword*", 0, "struct*", $tOverlapped)
	If @error Then Return SetError(@error, @extended, False)

	$iRead = $aResult[4]
	Return $aResult[0]
EndFunc   ;==>_WinAPI_ReadFile

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_ReadProcessMemory($hProcess, $pBaseAddress, $pBuffer, $iSize, ByRef $iRead)
	Local $aResult = DllCall("kernel32.dll", "bool", "ReadProcessMemory", "handle", $hProcess, _
			"ptr", $pBaseAddress, "struct*", $pBuffer, "ulong_ptr", $iSize, "ulong_ptr*", 0)
	If @error Then Return SetError(@error, @extended, False)

	$iRead = $aResult[5]
	Return $aResult[0]
EndFunc   ;==>_WinAPI_ReadProcessMemory

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_RectIsEmpty(ByRef $tRECT)
	Return (DllStructGetData($tRECT, "Left") = 0) And (DllStructGetData($tRECT, "Top") = 0) And _
			(DllStructGetData($tRECT, "Right") = 0) And (DllStructGetData($tRECT, "Bottom") = 0)
EndFunc   ;==>_WinAPI_RectIsEmpty

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_RedrawWindow($hWnd, $tRECT = 0, $hRegion = 0, $iFlags = 5)
	Local $aResult = DllCall("user32.dll", "bool", "RedrawWindow", "hwnd", $hWnd, "struct*", $tRECT, "handle", $hRegion, _
			"uint", $iFlags)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_RedrawWindow

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_RegisterWindowMessage($sMessage)
	Local $aResult = DllCall("user32.dll", "uint", "RegisterWindowMessageW", "wstr", $sMessage)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_RegisterWindowMessage

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_ReleaseCapture()
	Local $aResult = DllCall("user32.dll", "bool", "ReleaseCapture")
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_ReleaseCapture

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_ReleaseDC($hWnd, $hDC)
	Local $aResult = DllCall("user32.dll", "int", "ReleaseDC", "hwnd", $hWnd, "handle", $hDC)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_ReleaseDC

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_ScreenToClient($hWnd, ByRef $tPoint)
	Local $aResult = DllCall("user32.dll", "bool", "ScreenToClient", "hwnd", $hWnd, "struct*", $tPoint)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_ScreenToClient

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_SelectObject($hDC, $hGDIObj)
	Local $aResult = DllCall("gdi32.dll", "handle", "SelectObject", "handle", $hDC, "handle", $hGDIObj)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SelectObject

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_SetBkColor($hDC, $iColor)
	Local $aResult = DllCall("gdi32.dll", "INT", "SetBkColor", "handle", $hDC, "INT", $iColor)
	If @error Then Return SetError(@error, @extended, -1)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetBkColor

; #FUNCTION# ====================================================================================================================
; Author ........: Zedna
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_SetBkMode($hDC, $iBkMode)
	Local $aResult = DllCall("gdi32.dll", "int", "SetBkMode", "handle", $hDC, "int", $iBkMode)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetBkMode

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_SetCapture($hWnd)
	Local $aResult = DllCall("user32.dll", "hwnd", "SetCapture", "hwnd", $hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetCapture

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_SetCursor($hCursor)
	Local $aResult = DllCall("user32.dll", "handle", "SetCursor", "handle", $hCursor)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetCursor

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_SetDefaultPrinter($sPrinter)
	Local $aResult = DllCall("winspool.drv", "bool", "SetDefaultPrinterW", "wstr", $sPrinter)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetDefaultPrinter

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_SetDIBits($hDC, $hBitmap, $iStartScan, $iScanLines, $pBits, $tBMI, $iColorUse = 0)
	Local $aResult = DllCall("gdi32.dll", "int", "SetDIBits", "handle", $hDC, "handle", $hBitmap, "uint", $iStartScan, _
			"uint", $iScanLines, "struct*", $pBits, "struct*", $tBMI, "INT", $iColorUse)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetDIBits

; #FUNCTION# ====================================================================================================================
; Author ........: Zedna
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_SetEndOfFile($hFile)
	Local $aResult = DllCall("kernel32.dll", "bool", "SetEndOfFile", "handle", $hFile)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetEndOfFile

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_SetEvent($hEvent)
	Local $aResult = DllCall("kernel32.dll", "bool", "SetEvent", "handle", $hEvent)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetEvent

; #FUNCTION# ====================================================================================================================
; Author ........: Zedna
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_SetFilePointer($hFile, $iPos, $iMethod = 0)
	Local $aResult = DllCall("kernel32.dll", "INT", "SetFilePointer", "handle", $hFile, "long", $iPos, "ptr", 0, "long", $iMethod)
	If @error Then Return SetError(@error, @extended, -1)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetFilePointer

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_SetFocus($hWnd)
	Local $aResult = DllCall("user32.dll", "hwnd", "SetFocus", "hwnd", $hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetFocus

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_SetFont($hWnd, $hFont, $bRedraw = True)
	_SendMessage($hWnd, $__WINAPICONSTANT_WM_SETFONT, $hFont, $bRedraw, 0, "hwnd")
EndFunc   ;==>_WinAPI_SetFont

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_SetHandleInformation($hObject, $iMask, $iFlags)
	Local $aResult = DllCall("kernel32.dll", "bool", "SetHandleInformation", "handle", $hObject, "dword", $iMask, "dword", $iFlags)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetHandleInformation

; #FUNCTION# ====================================================================================================================
; Author ........: Prog@ndy
; Modified.......: PsaltyDS
; ===============================================================================================================================
Func _WinAPI_SetLayeredWindowAttributes($hWnd, $iTransColor, $iTransGUI = 255, $iFlags = 0x03, $bColorRef = False)
	If $iFlags = Default Or $iFlags = "" Or $iFlags < 0 Then $iFlags = 0x03
	If Not $bColorRef Then
		$iTransColor = Int(BinaryMid($iTransColor, 3, 1) & BinaryMid($iTransColor, 2, 1) & BinaryMid($iTransColor, 1, 1))
	EndIf
	Local $aResult = DllCall("user32.dll", "bool", "SetLayeredWindowAttributes", "hwnd", $hWnd, "INT", $iTransColor, _
			"byte", $iTransGUI, "dword", $iFlags)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetLayeredWindowAttributes

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_SetParent($hWndChild, $hWndParent)
	Local $aResult = DllCall("user32.dll", "hwnd", "SetParent", "hwnd", $hWndChild, "hwnd", $hWndParent)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetParent

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_SetProcessAffinityMask($hProcess, $iMask)
	Local $aResult = DllCall("kernel32.dll", "bool", "SetProcessAffinityMask", "handle", $hProcess, "ulong_ptr", $iMask)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetProcessAffinityMask

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_SetSysColors($vElements, $vColors)
	Local $bIsEArray = IsArray($vElements), $bIsCArray = IsArray($vColors)
	Local $iElementNum

	If Not $bIsCArray And Not $bIsEArray Then
		$iElementNum = 1
	ElseIf $bIsCArray Or $bIsEArray Then
		If Not $bIsCArray Or Not $bIsEArray Then Return SetError(-1, -1, False)
		If UBound($vElements) <> UBound($vColors) Then Return SetError(-1, -1, False)
		$iElementNum = UBound($vElements)
	EndIf

	Local $tElements = DllStructCreate("int Element[" & $iElementNum & "]")
	Local $tColors = DllStructCreate("INT NewColor[" & $iElementNum & "]")

	If Not $bIsEArray Then
		DllStructSetData($tElements, "Element", $vElements, 1)
	Else
		For $x = 0 To $iElementNum - 1
			DllStructSetData($tElements, "Element", $vElements[$x], $x + 1)
		Next
	EndIf

	If Not $bIsCArray Then
		DllStructSetData($tColors, "NewColor", $vColors, 1)
	Else
		For $x = 0 To $iElementNum - 1
			DllStructSetData($tColors, "NewColor", $vColors[$x], $x + 1)
		Next
	EndIf
	Local $aResult = DllCall("user32.dll", "bool", "SetSysColors", "int", $iElementNum, "struct*", $tElements, "struct*", $tColors)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetSysColors

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_SetTextColor($hDC, $iColor)
	Local $aResult = DllCall("gdi32.dll", "INT", "SetTextColor", "handle", $hDC, "INT", $iColor)
	If @error Then Return SetError(@error, @extended, -1)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetTextColor

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_SetWindowLong($hWnd, $iIndex, $iValue)
	_WinAPI_SetLastError(0) ; as suggested in MSDN
	Local $sFuncName = "SetWindowLongW"
	If @AutoItX64 Then $sFuncName = "SetWindowLongPtrW"
	Local $aResult = DllCall("user32.dll", "long_ptr", $sFuncName, "hwnd", $hWnd, "int", $iIndex, "long_ptr", $iValue)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetWindowLong

; #FUNCTION# ====================================================================================================================
; Author ........: PsaltyDS
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_SetWindowPlacement($hWnd, $tWindowPlacement)
	Local $aResult = DllCall("user32.dll", "bool", "SetWindowPlacement", "hwnd", $hWnd, "struct*", $tWindowPlacement)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetWindowPlacement

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_SetWindowPos($hWnd, $hAfter, $iX, $iY, $iCX, $iCY, $iFlags)
	Local $aResult = DllCall("user32.dll", "bool", "SetWindowPos", "hwnd", $hWnd, "hwnd", $hAfter, "int", $iX, "int", $iY, _
			"int", $iCX, "int", $iCY, "uint", $iFlags)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetWindowPos

; #FUNCTION# ====================================================================================================================
; Author ........: Zedna
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_SetWindowRgn($hWnd, $hRgn, $bRedraw = True)
	Local $aResult = DllCall("user32.dll", "int", "SetWindowRgn", "hwnd", $hWnd, "handle", $hRgn, "bool", $bRedraw)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetWindowRgn

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_SetWindowsHookEx($iHook, $pProc, $hDll, $iThreadId = 0)
	Local $aResult = DllCall("user32.dll", "handle", "SetWindowsHookEx", "int", $iHook, "ptr", $pProc, "handle", $hDll, _
			"dword", $iThreadId)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetWindowsHookEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_SetWindowText($hWnd, $sText)
	Local $aResult = DllCall("user32.dll", "bool", "SetWindowTextW", "hwnd", $hWnd, "wstr", $sText)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetWindowText

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_ShowCursor($bShow)
	Local $aResult = DllCall("user32.dll", "int", "ShowCursor", "bool", $bShow)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_ShowCursor

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_ShowError($sText, $bExit = True)
	_WinAPI_MsgBox($MB_SYSTEMMODAL, "Error", $sText)
	If $bExit Then Exit
EndFunc   ;==>_WinAPI_ShowError

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_ShowMsg($sText)
	_WinAPI_MsgBox($MB_SYSTEMMODAL, "Information", $sText)
EndFunc   ;==>_WinAPI_ShowMsg

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_ShowWindow($hWnd, $iCmdShow = 5)
	Local $aResult = DllCall("user32.dll", "bool", "ShowWindow", "hwnd", $hWnd, "int", $iCmdShow)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_ShowWindow

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM
; ===============================================================================================================================
Func _WinAPI_StringFromGUID($tGUID)
	Local $aResult = DllCall("ole32.dll", "int", "StringFromGUID2", "struct*", $tGUID, "wstr", "", "int", 40)
	If @error Or Not $aResult[0] Then Return SetError(@error, @extended, "")

	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_WinAPI_StringFromGUID

; #FUNCTION# ====================================================================================================================
; Author ........: trancexx
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_StringLenA(Const ByRef $tString)
	Local $aResult = DllCall("kernel32.dll", "int", "lstrlenA", "struct*", $tString)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_StringLenA

; #FUNCTION# ====================================================================================================================
; Author ........: trancexx
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_StringLenW(Const ByRef $tString)
	Local $aResult = DllCall("kernel32.dll", "int", "lstrlenW", "struct*", $tString)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_StringLenW

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_SubLangId($iLngID)
	Return BitShift($iLngID, 10)
EndFunc   ;==>_WinAPI_SubLangId

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_SystemParametersInfo($iAction, $iParam = 0, $vParam = 0, $iWinIni = 0)
	Local $aResult = DllCall("user32.dll", "bool", "SystemParametersInfoW", "uint", $iAction, "uint", $iParam, "struct*", $vParam, _
			"uint", $iWinIni)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_SystemParametersInfo

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_TwipsPerPixelX()
	Local $hDC, $iTwipsPerPixelX
	$hDC = _WinAPI_GetDC(0)
	$iTwipsPerPixelX = 1440 / _WinAPI_GetDeviceCaps($hDC, $__WINAPICONSTANT_LOGPIXELSX)
	_WinAPI_ReleaseDC(0, $hDC)
	Return $iTwipsPerPixelX
EndFunc   ;==>_WinAPI_TwipsPerPixelX

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_TwipsPerPixelY()
	Local $hDC, $iTwipsPerPixelY
	$hDC = _WinAPI_GetDC(0)
	$iTwipsPerPixelY = 1440 / _WinAPI_GetDeviceCaps($hDC, $__WINAPICONSTANT_LOGPIXELSY)
	_WinAPI_ReleaseDC(0, $hDC)
	Return $iTwipsPerPixelY
EndFunc   ;==>_WinAPI_TwipsPerPixelY

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_UnhookWindowsHookEx($hHook)
	Local $aResult = DllCall("user32.dll", "bool", "UnhookWindowsHookEx", "handle", $hHook)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_UnhookWindowsHookEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_UpdateLayeredWindow($hWnd, $hDestDC, $tPTDest, $tSize, $hSrcDC, $tPTSrce, $iRGB, $tBlend, $iFlags)
	Local $aResult = DllCall("user32.dll", "bool", "UpdateLayeredWindow", "hwnd", $hWnd, "handle", $hDestDC, "struct*", $tPTDest, _
			"struct*", $tSize, "handle", $hSrcDC, "struct*", $tPTSrce, "dword", $iRGB, "struct*", $tBlend, "dword", $iFlags)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_UpdateLayeredWindow

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_UpdateWindow($hWnd)
	Local $aResult = DllCall("user32.dll", "bool", "UpdateWindow", "hwnd", $hWnd)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_UpdateWindow

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_WaitForInputIdle($hProcess, $iTimeout = -1)
	Local $aResult = DllCall("user32.dll", "dword", "WaitForInputIdle", "handle", $hProcess, "dword", $iTimeout)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_WaitForInputIdle

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_WaitForMultipleObjects($iCount, $paHandles, $bWaitAll = False, $iTimeout = -1)
	Local $aResult = DllCall("kernel32.dll", "INT", "WaitForMultipleObjects", "dword", $iCount, "struct*", $paHandles, "bool", $bWaitAll, "dword", $iTimeout)
	If @error Then Return SetError(@error, @extended, -1)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_WaitForMultipleObjects

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_WaitForSingleObject($hHandle, $iTimeout = -1)
	Local $aResult = DllCall("kernel32.dll", "INT", "WaitForSingleObject", "handle", $hHandle, "dword", $iTimeout)
	If @error Then Return SetError(@error, @extended, -1)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_WaitForSingleObject

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: JPM, Alexander Samuelsson (AdmiralAlkex)
; ===============================================================================================================================
Func _WinAPI_WideCharToMultiByte($vUnicode, $iCodePage = 0, $bRetString = True)
	Local $sUnicodeType = "wstr"
	If Not IsString($vUnicode) Then $sUnicodeType = "struct*"
	Local $aResult = DllCall("kernel32.dll", "int", "WideCharToMultiByte", "uint", $iCodePage, "dword", 0, $sUnicodeType, $vUnicode, "int", -1, _
			"ptr", 0, "int", 0, "ptr", 0, "ptr", 0)
	If @error Or Not $aResult[0] Then Return SetError(@error + 20, @extended, "")

	Local $tMultiByte = DllStructCreate("char[" & $aResult[0] & "]")

	$aResult = DllCall("kernel32.dll", "int", "WideCharToMultiByte", "uint", $iCodePage, "dword", 0, $sUnicodeType, $vUnicode, _
			"int", -1, "struct*", $tMultiByte, "int", $aResult[0], "ptr", 0, "ptr", 0)
	If @error Or Not $aResult[0] Then Return SetError(@error + 10, @extended, "")

	If $bRetString Then Return DllStructGetData($tMultiByte, 1)
	Return $tMultiByte
EndFunc   ;==>_WinAPI_WideCharToMultiByte

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost, trancexx
; ===============================================================================================================================
Func _WinAPI_WindowFromPoint(ByRef $tPoint)
	Local $aResult = DllCall("user32.dll", "hwnd", "WindowFromPoint", "struct", $tPoint)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_WindowFromPoint

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _WinAPI_WriteConsole($hConsole, $sText)
	Local $aResult = DllCall("kernel32.dll", "bool", "WriteConsoleW", "handle", $hConsole, "wstr", $sText, _
			"dword", StringLen($sText), "dword*", 0, "ptr", 0)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>_WinAPI_WriteConsole

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_WriteFile($hFile, $pBuffer, $iToWrite, ByRef $iWritten, $tOverlapped = 0)
	Local $aResult = DllCall("kernel32.dll", "bool", "WriteFile", "handle", $hFile, "struct*", $pBuffer, "dword", $iToWrite, _
			"dword*", 0, "struct*", $tOverlapped)
	If @error Then Return SetError(@error, @extended, False)

	$iWritten = $aResult[4]
	Return $aResult[0]
EndFunc   ;==>_WinAPI_WriteFile

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_WriteProcessMemory($hProcess, $pBaseAddress, $pBuffer, $iSize, ByRef $iWritten, $sBuffer = "ptr")
	Local $aResult = DllCall("kernel32.dll", "bool", "WriteProcessMemory", "handle", $hProcess, "ptr", $pBaseAddress, _
			$sBuffer, $pBuffer, "ulong_ptr", $iSize, "ulong_ptr*", 0)
	If @error Then Return SetError(@error, @extended, False)

	$iWritten = $aResult[5]
	Return $aResult[0]
EndFunc   ;==>_WinAPI_WriteProcessMemory
