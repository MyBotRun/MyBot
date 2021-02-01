#include-once

#include "GDIPlus.au3"
#include "WinAPI.au3"

; #INDEX# =======================================================================================================================
; Title .........: ScreenCapture
; AutoIt Version : 3.3.14.2
; Language ......: English
; Description ...: Functions that assist with Screen Capture management.
;                  This module allows you to copy the screen or a region of the screen and save it to file. Depending on the type
;                  of image, you can set various image parameters such as pixel format, quality and compression.
; Author(s) .....: Paul Campbell (PaulIA)
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
Global $__g_iBMPFormat = $GDIP_PXF24RGB
Global $__g_iJPGQuality = 100
Global $__g_iTIFColorDepth = 24
Global $__g_iTIFCompression = $GDIP_EVTCOMPRESSIONLZW
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $__SCREENCAPTURECONSTANT_SM_CXSCREEN = 0
Global Const $__SCREENCAPTURECONSTANT_SM_CYSCREEN = 1
Global Const $__SCREENCAPTURECONSTANT_SRCCOPY = 0x00CC0020
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _ScreenCapture_Capture
; _ScreenCapture_CaptureWnd
; _ScreenCapture_SaveImage
; _ScreenCapture_SetBMPFormat
; _ScreenCapture_SetJPGQuality
; _ScreenCapture_SetTIFColorDepth
; _ScreenCapture_SetTIFCompression
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _ScreenCapture_Capture($sFileName = "", $iLeft = 0, $iTop = 0, $iRight = -1, $iBottom = -1, $bCursor = True)
	Local $bRet = False
	If $iRight = -1 Then $iRight = _WinAPI_GetSystemMetrics($__SCREENCAPTURECONSTANT_SM_CXSCREEN) - 1
	If $iBottom = -1 Then $iBottom = _WinAPI_GetSystemMetrics($__SCREENCAPTURECONSTANT_SM_CYSCREEN) - 1
	If $iRight < $iLeft Then Return SetError(-1, 0, $bRet)
	If $iBottom < $iTop Then Return SetError(-2, 0, $bRet)

	Local $iW = ($iRight - $iLeft) + 1
	Local $iH = ($iBottom - $iTop) + 1
	Local $hWnd = _WinAPI_GetDesktopWindow()
	Local $hDDC = _WinAPI_GetDC($hWnd)
	Local $hCDC = _WinAPI_CreateCompatibleDC($hDDC)
	Local $hBMP = _WinAPI_CreateCompatibleBitmap($hDDC, $iW, $iH)
	_WinAPI_SelectObject($hCDC, $hBMP)
	_WinAPI_BitBlt($hCDC, 0, 0, $iW, $iH, $hDDC, $iLeft, $iTop, $__SCREENCAPTURECONSTANT_SRCCOPY)

	If $bCursor Then
		Local $aCursor = _WinAPI_GetCursorInfo()
		If Not @error And $aCursor[1] Then
			$bCursor = True ; Cursor info was found.
			Local $hIcon = _WinAPI_CopyIcon($aCursor[2])
			Local $aIcon = _WinAPI_GetIconInfo($hIcon)
			If Not @error Then
				_WinAPI_DeleteObject($aIcon[4]) ; delete bitmap mask return by _WinAPI_GetIconInfo()
				If $aIcon[5] <> 0 Then _WinAPI_DeleteObject($aIcon[5]); delete bitmap hbmColor return by _WinAPI_GetIconInfo()
				_WinAPI_DrawIcon($hCDC, $aCursor[3] - $aIcon[2] - $iLeft, $aCursor[4] - $aIcon[3] - $iTop, $hIcon)
			EndIf
			_WinAPI_DestroyIcon($hIcon)
		EndIf
	EndIf

	_WinAPI_ReleaseDC($hWnd, $hDDC)
	_WinAPI_DeleteDC($hCDC)
	If $sFileName = "" Then Return $hBMP

	$bRet = _ScreenCapture_SaveImage($sFileName, $hBMP, True)
	Return SetError(@error, @extended, $bRet)
EndFunc   ;==>_ScreenCapture_Capture

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm based on Kafu
; ===============================================================================================================================
Func _ScreenCapture_CaptureWnd($sFileName, $hWnd, $iLeft = 0, $iTop = 0, $iRight = -1, $iBottom = -1, $bCursor = True)
	If Not IsHWnd($hWnd) Then $hWnd = WinGetHandle($hWnd)
	Local $tRECT = DllStructCreate($tagRECT)
	; needed to get rect when Aero theme is active : Thanks Kafu, Zedna
	Local Const $DWMWA_EXTENDED_FRAME_BOUNDS = 9
	Local $bRet = DllCall("dwmapi.dll", "long", "DwmGetWindowAttribute", "hwnd", $hWnd, "dword", $DWMWA_EXTENDED_FRAME_BOUNDS, "struct*", $tRECT, "dword", DllStructGetSize($tRECT))
	If (@error Or $bRet[0] Or (Abs(DllStructGetData($tRECT, "Left")) + Abs(DllStructGetData($tRECT, "Top")) + _
			Abs(DllStructGetData($tRECT, "Right")) + Abs(DllStructGetData($tRECT, "Bottom"))) = 0) Then
		$tRECT = _WinAPI_GetWindowRect($hWnd)
		If @error Then Return SetError(@error + 10, @extended, False)
	EndIf

	$iLeft += DllStructGetData($tRECT, "Left")
	$iTop += DllStructGetData($tRECT, "Top")
	If $iRight = -1 Then $iRight = DllStructGetData($tRECT, "Right") - DllStructGetData($tRECT, "Left") - 1
	If $iBottom = -1 Then $iBottom = DllStructGetData($tRECT, "Bottom") - DllStructGetData($tRECT, "Top") - 1
	$iRight += DllStructGetData($tRECT, "Left")
	$iBottom += DllStructGetData($tRECT, "Top")
	If $iLeft > DllStructGetData($tRECT, "Right") Then $iLeft = DllStructGetData($tRECT, "Left")
	If $iTop > DllStructGetData($tRECT, "Bottom") Then $iTop = DllStructGetData($tRECT, "Top")
	If $iRight > DllStructGetData($tRECT, "Right") Then $iRight = DllStructGetData($tRECT, "Right") - 1
	If $iBottom > DllStructGetData($tRECT, "Bottom") Then $iBottom = DllStructGetData($tRECT, "Bottom") - 1
	$bRet = _ScreenCapture_Capture($sFileName, $iLeft, $iTop, $iRight, $iBottom, $bCursor)
	Return SetError(@error, @extended, $bRet)
EndFunc   ;==>_ScreenCapture_CaptureWnd

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _ScreenCapture_SaveImage($sFileName, $hBitmap, $bFreeBmp = True)
	_GDIPlus_Startup()
	If @error Then Return SetError(-1, -1, False)

	Local $sExt = StringUpper(__GDIPlus_ExtractFileExt($sFileName))
	Local $sCLSID = _GDIPlus_EncodersGetCLSID($sExt)
	If $sCLSID = "" Then Return SetError(-2, -2, False)
	Local $hImage = _GDIPlus_BitmapCreateFromHBITMAP($hBitmap)
	If @error Then Return SetError(-3, -3, False)

	Local $tData, $tParams
	Switch $sExt
		Case "BMP"
			Local $iX = _GDIPlus_ImageGetWidth($hImage)
			Local $iY = _GDIPlus_ImageGetHeight($hImage)
			Local $hClone = _GDIPlus_BitmapCloneArea($hImage, 0, 0, $iX, $iY, $__g_iBMPFormat)
			_GDIPlus_ImageDispose($hImage)
			$hImage = $hClone
		Case "JPG", "JPEG"
			$tParams = _GDIPlus_ParamInit(1)
			$tData = DllStructCreate("int Quality")
			DllStructSetData($tData, "Quality", $__g_iJPGQuality)
			_GDIPlus_ParamAdd($tParams, $GDIP_EPGQUALITY, 1, $GDIP_EPTLONG, DllStructGetPtr($tData))
		Case "TIF", "TIFF"
			$tParams = _GDIPlus_ParamInit(2)
			$tData = DllStructCreate("int ColorDepth;int Compression")
			DllStructSetData($tData, "ColorDepth", $__g_iTIFColorDepth)
			DllStructSetData($tData, "Compression", $__g_iTIFCompression)
			_GDIPlus_ParamAdd($tParams, $GDIP_EPGCOLORDEPTH, 1, $GDIP_EPTLONG, DllStructGetPtr($tData, "ColorDepth"))
			_GDIPlus_ParamAdd($tParams, $GDIP_EPGCOMPRESSION, 1, $GDIP_EPTLONG, DllStructGetPtr($tData, "Compression"))
	EndSwitch
	Local $pParams = 0
	If IsDllStruct($tParams) Then $pParams = $tParams

	Local $bRet = _GDIPlus_ImageSaveToFileEx($hImage, $sFileName, $sCLSID, $pParams)
	_GDIPlus_ImageDispose($hImage)
	If $bFreeBmp Then _WinAPI_DeleteObject($hBitmap)
	_GDIPlus_Shutdown()

	Return SetError($bRet = False, 0, $bRet)
EndFunc   ;==>_ScreenCapture_SaveImage

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _ScreenCapture_SetBMPFormat($iFormat)
	Switch $iFormat
		Case 0
			$__g_iBMPFormat = $GDIP_PXF16RGB555
		Case 1
			$__g_iBMPFormat = $GDIP_PXF16RGB565
		Case 2
			$__g_iBMPFormat = $GDIP_PXF24RGB
		Case 3
			$__g_iBMPFormat = $GDIP_PXF32RGB
		Case 4
			$__g_iBMPFormat = $GDIP_PXF32ARGB
		Case Else
			$__g_iBMPFormat = $GDIP_PXF24RGB
	EndSwitch
EndFunc   ;==>_ScreenCapture_SetBMPFormat

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _ScreenCapture_SetJPGQuality($iQuality)
	If $iQuality < 0 Then $iQuality = 0
	If $iQuality > 100 Then $iQuality = 100
	$__g_iJPGQuality = $iQuality
EndFunc   ;==>_ScreenCapture_SetJPGQuality

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _ScreenCapture_SetTIFColorDepth($iDepth)
	Switch $iDepth
		Case 24
			$__g_iTIFColorDepth = 24
		Case 32
			$__g_iTIFColorDepth = 32
		Case Else
			$__g_iTIFColorDepth = 0
	EndSwitch
EndFunc   ;==>_ScreenCapture_SetTIFColorDepth

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _ScreenCapture_SetTIFCompression($iCompress)
	Switch $iCompress
		Case 1
			$__g_iTIFCompression = $GDIP_EVTCOMPRESSIONNONE
		Case 2
			$__g_iTIFCompression = $GDIP_EVTCOMPRESSIONLZW
		Case Else
			$__g_iTIFCompression = 0
	EndSwitch
EndFunc   ;==>_ScreenCapture_SetTIFCompression
