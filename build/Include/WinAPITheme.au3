#include-once

#include "APIThemeConstants.au3"
#include "WinAPIInternals.au3"

; #INDEX# =======================================================================================================================
; Title .........: WinAPI Extended UDF Library for AutoIt3
; AutoIt Version : 3.3.14.2
; Description ...: Additional variables, constants and functions for the WinAPITheme.au3
; Author(s) .....: Yashied, jpm
; ===============================================================================================================================

#Region Global Variables and Constants

; #VARIABLES# ===================================================================================================================
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $tagDTTOPTS = 'dword Size;dword Flags;dword clrText;dword clrBorder;dword clrShadow;int TextShadowType;' & $tagPOINT & ';int BorderSize;int FontPropId;int ColorPropId;int StateId;int ApplyOverlay;int GlowSize;ptr DrawTextCallback;lparam lParam'
; ===============================================================================================================================
#EndRegion Global Variables and Constants

#Region Functions list

; #CURRENT# =====================================================================================================================
; _WinAPI_BeginBufferedPaint
; _WinAPI_BufferedPaintClear
; _WinAPI_BufferedPaintInit
; _WinAPI_BufferedPaintSetAlpha
; _WinAPI_BufferedPaintUnInit
; _WinAPI_CloseThemeData
; _WinAPI_DrawThemeBackground
; _WinAPI_DrawThemeEdge
; _WinAPI_DrawThemeIcon
; _WinAPI_DrawThemeParentBackground
; _WinAPI_DrawThemeText
; _WinAPI_DrawThemeTextEx
; _WinAPI_EndBufferedPaint
; _WinAPI_GetBufferedPaintBits
; _WinAPI_GetBufferedPaintDC
; _WinAPI_GetBufferedPaintTargetDC
; _WinAPI_GetBufferedPaintTargetRect
; _WinAPI_GetCurrentThemeName
; _WinAPI_GetThemeAppProperties
; _WinAPI_GetThemeBackgroundContentRect
; _WinAPI_GetThemeBackgroundExtent
; _WinAPI_GetThemeBackgroundRegion
; _WinAPI_GetThemeBitmap
; _WinAPI_GetThemeBool
; _WinAPI_GetThemeColor
; _WinAPI_GetThemeDocumentationProperty
; _WinAPI_GetThemeEnumValue
; _WinAPI_GetThemeFilename
; _WinAPI_GetThemeFont
; _WinAPI_GetThemeInt
; _WinAPI_GetThemeMargins
; _WinAPI_GetThemeMetric
; _WinAPI_GetThemePartSize
; _WinAPI_GetThemePosition
; _WinAPI_GetThemePropertyOrigin
; _WinAPI_GetThemeRect
; _WinAPI_GetThemeString
; _WinAPI_GetThemeSysBool
; _WinAPI_GetThemeSysColor
; _WinAPI_GetThemeSysColorBrush
; _WinAPI_GetThemeSysFont
; _WinAPI_GetThemeSysInt
; _WinAPI_GetThemeSysSize
; _WinAPI_GetThemeSysString
; _WinAPI_GetThemeTextExtent
; _WinAPI_GetThemeTextMetrics
; _WinAPI_GetThemeTransitionDuration
; _WinAPI_GetWindowTheme
; _WinAPI_IsThemeActive
; _WinAPI_IsThemeBackgroundPartiallyTransparent
; _WinAPI_IsThemePartDefined
; _WinAPI_OpenThemeData
; _WinAPI_SetThemeAppProperties
; _WinAPI_SetWindowTheme
; ===============================================================================================================================
#EndRegion Functions list

#Region Public Functions

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_BeginBufferedPaint($hDC, $tTarget, ByRef $hNewDC, $iFormat = 0, $iFlags = 0, $tExclude = 0, $iAlpha = -1)
	Local Const $tagBP_PAINTPARAMS = 'dword cbSize;dword dwFlags;ptr prcExclude;ptr pBlendFunction'
	Local $tPP = DllStructCreate($tagBP_PAINTPARAMS)

	$hNewDC = 0

	Local $tBF = 0
	If $iAlpha <> -1 Then
		$tBF = DllStructCreate($tagBLENDFUNCTION)
		DllStructSetData($tBF, 1, 0)
		DllStructSetData($tBF, 2, 0)
		DllStructSetData($tBF, 3, $iAlpha)
		DllStructSetData($tBF, 4, 1)
	EndIf

	DllStructSetData($tPP, 1, DllStructGetSize($tPP))
	DllStructSetData($tPP, 2, $iFlags)
	DllStructSetData($tPP, 3, DllStructGetPtr($tExclude))
	DllStructSetData($tPP, 4, DllStructGetPtr($tBF))

	Local $aRet = DllCall('uxtheme.dll', 'handle', 'BeginBufferedPaint', 'handle', $hDC, 'struct*', $tTarget, 'dword', $iFormat, _
			'struct*', $tPP, 'handle*', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)

	$hNewDC = $aRet[5]
	Return $aRet[0]
EndFunc   ;==>_WinAPI_BeginBufferedPaint

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_BufferedPaintClear($hBP, $tRECT = 0)
	Local $aRet = DllCall('uxtheme.dll', 'long', 'BufferedPaintClear', 'handle', $hBP, 'struct*', $tRECT)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_BufferedPaintClear

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_BufferedPaintInit()
	Local $aRet = DllCall('uxtheme.dll', 'long', 'BufferedPaintInit')
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_BufferedPaintInit

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_BufferedPaintSetAlpha($hBP, $iAlpha = 255, $tRECT = 0)
	Local $aRet = DllCall('uxtheme.dll', 'long', 'BufferedPaintSetAlpha', 'handle', $hBP, 'struct*', $tRECT, 'byte', $iAlpha)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_BufferedPaintSetAlpha

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_BufferedPaintUnInit()
	Local $aRet = DllCall('uxtheme.dll', 'long', 'BufferedPaintUnInit')
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_BufferedPaintUnInit

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_CloseThemeData($hTheme)
	Local $aRet = DllCall('uxtheme.dll', 'long', 'CloseThemeData', 'handle', $hTheme)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_CloseThemeData

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DrawThemeBackground($hTheme, $iPartID, $iStateID, $hDC, $tRECT, $tCLIP = 0)
	Local $aRet = DllCall('uxtheme.dll', 'long', 'DrawThemeBackground', 'handle', $hTheme, 'handle', $hDC, 'int', $iPartID, _
			'int', $iStateID, 'struct*', $tRECT, 'struct*', $tCLIP)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_DrawThemeBackground

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DrawThemeEdge($hTheme, $iPartID, $iStateID, $hDC, $tRECT, $iEdge, $iFlags, $tAREA = 0)
	Local $aRet = DllCall('uxtheme.dll', 'long', 'DrawThemeEdge', 'handle', $hTheme, 'handle', $hDC, 'int', $iPartID, _
			'int', $iStateID, 'struct*', $tRECT, 'uint', $iEdge, 'uint', $iFlags, 'struct*', $tAREA)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_DrawThemeEdge

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DrawThemeIcon($hTheme, $iPartID, $iStateID, $hDC, $tRECT, $hIL, $iIndex)
	Local $aRet = DllCall('uxtheme.dll', 'long', 'DrawThemeIcon', 'handle', $hTheme, 'handle', $hDC, 'int', $iPartID, _
			'int', $iStateID, 'struct*', $tRECT, 'handle', $hIL, 'int', $iIndex)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_DrawThemeIcon

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DrawThemeParentBackground($hWnd, $hDC, $tRECT = 0)
	Local $aRet = DllCall('uxtheme.dll', 'long', 'DrawThemeParentBackground', 'hwnd', $hWnd, 'handle', $hDC, 'struct*', $tRECT)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_DrawThemeParentBackground

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DrawThemeText($hTheme, $iPartID, $iStateID, $hDC, $sText, $tRECT, $iFlags)
	Local $aRet = DllCall('uxtheme.dll', 'long', 'DrawThemeText', 'handle', $hTheme, 'handle', $hDC, 'int', $iPartID, _
			'int', $iStateID, 'wstr', $sText, 'int', -1, 'dword', $iFlags, 'dword', 0, 'struct*', $tRECT)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_DrawThemeText

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_DrawThemeTextEx($hTheme, $iPartID, $iStateID, $hDC, $sText, $tRECT, $iFlags, $tDTTOPTS)
	Local $aRet = DllCall('uxtheme.dll', 'long', 'DrawThemeTextEx', 'handle', $hTheme, 'handle', $hDC, 'int', $iPartID, _
			'int', $iStateID, 'wstr', $sText, 'int', -1, 'dword', $iFlags, 'struct*', $tRECT, 'struct*', $tDTTOPTS)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_DrawThemeTextEx

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_EndBufferedPaint($hBP, $bUpdate = True)
	Local $aRet = DllCall('uxtheme.dll', 'long', 'EndBufferedPaint', 'handle', $hBP, 'bool', $bUpdate)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_EndBufferedPaint

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetBufferedPaintBits($hBP)
	Local $aRet = DllCall('uxtheme.dll', 'long', 'GetBufferedPaintBits', 'handle', $hBP, 'ptr*', 0, 'int*', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return SetExtended($aRet[3], $aRet[2])
EndFunc   ;==>_WinAPI_GetBufferedPaintBits

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetBufferedPaintDC($hBP)
	Local $aRet = DllCall('uxtheme.dll', 'handle', 'GetBufferedPaintDC', 'handle', $hBP)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetBufferedPaintDC

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetBufferedPaintTargetDC($hBP)
	Local $aRet = DllCall('uxtheme.dll', 'handle', 'GetBufferedPaintTargetDC', 'handle', $hBP)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetBufferedPaintTargetDC

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetBufferedPaintTargetRect($hBP)
	Local $tRECT = DllStructCreate($tagRECT)
	Local $aRet = DllCall('uxtheme.dll', 'long', 'GetBufferedPaintTargetRect', 'handle', $hBP, 'struct*', $tRECT)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $tRECT
EndFunc   ;==>_WinAPI_GetBufferedPaintTargetRect

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetCurrentThemeName()
	Local $aRet = DllCall('uxtheme.dll', 'long', 'GetCurrentThemeName', 'wstr', '', 'int', 4096, 'wstr', '', 'int', 2048, _
			'wstr', '', 'int', 2048)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Local $aResult[3]
	For $i = 0 To 2
		$aResult[$i] = $aRet[$i * 2 + 1]
	Next
	Return $aResult
EndFunc   ;==>_WinAPI_GetCurrentThemeName

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetThemeAppProperties()
	Local $aRet = DllCall('uxtheme.dll', 'dword', 'GetThemeAppProperties')
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetThemeAppProperties

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetThemeBackgroundContentRect($hTheme, $iPartID, $iStateID, $hDC, $tRECT)
	Local $tAREA = DllStructCreate($tagRECT)
	Local $aRet = DllCall('uxtheme.dll', 'long', 'GetThemeBackgroundContentRect', 'handle', $hTheme, 'handle', $hDC, _
			'int', $iPartID, 'int', $iStateID, 'struct*', $tRECT, 'struct*', $tAREA)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $tAREA
EndFunc   ;==>_WinAPI_GetThemeBackgroundContentRect

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetThemeBackgroundExtent($hTheme, $iPartID, $iStateID, $hDC, $tRECT)
	Local $tAREA = DllStructCreate($tagRECT)
	Local $aRet = DllCall('uxtheme.dll', 'long', 'GetThemeBackgroundExtent', 'handle', $hTheme, 'handle', $hDC, 'int', $iPartID, _
			'int', $iStateID, 'struct*', $tRECT, 'struct*', $tAREA)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $tAREA
EndFunc   ;==>_WinAPI_GetThemeBackgroundExtent

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetThemeBackgroundRegion($hTheme, $iPartID, $iStateID, $hDC, $tRECT)
	Local $aRet = DllCall('uxtheme.dll', 'long', 'GetThemeBackgroundRegion', 'handle', $hTheme, 'handle', $hDC, 'int', $iPartID, _
			'int', $iStateID, 'struct*', $tRECT, 'handle*', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $aRet[6]
EndFunc   ;==>_WinAPI_GetThemeBackgroundRegion

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetThemeBitmap($hTheme, $iPartID, $iStateID, $iPropID, $iFlag = 0x01)
	Local $aRet = DllCall('uxtheme.dll', 'long', 'GetThemeBitmap', 'handle', $hTheme, 'int', $iPartID, 'int', $iStateID, _
			'int', $iPropID, 'ulong', $iFlag, 'handle*', 0)
	If @error Then Return SetError(@error, @extended, -1)
	If $aRet[0] Then Return SetError(10, $aRet[0], -1)

	Return $aRet[6]
EndFunc   ;==>_WinAPI_GetThemeBitmap

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetThemeBool($hTheme, $iPartID, $iStateID, $iPropID)
	Local $aRet = DllCall('uxtheme.dll', 'long', 'GetThemeBool', 'handle', $hTheme, 'int', $iPartID, 'int', $iStateID, _
			'int', $iPropID, 'bool*', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $aRet[5]
EndFunc   ;==>_WinAPI_GetThemeBool

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetThemeColor($hTheme, $iPartID, $iStateID, $iPropID)
	Local $aRet = DllCall('uxtheme.dll', 'long', 'GetThemeColor', 'handle', $hTheme, 'int', $iPartID, 'int', $iStateID, _
			'int', $iPropID, 'dword*', 0)
	If @error Then Return SetError(@error, @extended, -1)
	If $aRet[0] Then Return SetError(10, $aRet[0], -1)

	Return __RGB($aRet[5])
EndFunc   ;==>_WinAPI_GetThemeColor

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetThemeDocumentationProperty($sFilePath, $sProperty)
	Local $aRet = DllCall('uxtheme.dll', 'long', 'GetThemeDocumentationProperty', 'wstr', $sFilePath, 'wstr', $sProperty, _
			'wstr', '', 'int', 4096)
	If @error Then Return SetError(@error, @extended, '')
	If $aRet[0] Then Return SetError(10, $aRet[0], '')

	Return $aRet[3]
EndFunc   ;==>_WinAPI_GetThemeDocumentationProperty

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetThemeEnumValue($hTheme, $iPartID, $iStateID, $iPropID)
	Local $aRet = DllCall('uxtheme.dll', 'long', 'GetThemeEnumValue', 'handle', $hTheme, 'int', $iPartID, 'int', $iStateID, _
			'int', $iPropID, 'int*', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $aRet[5]
EndFunc   ;==>_WinAPI_GetThemeEnumValue

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetThemeFilename($hTheme, $iPartID, $iStateID, $iPropID)
	Local $aRet = DllCall('uxtheme.dll', 'uint', 'GetThemeFilename', 'handle', $hTheme, 'int', $iPartID, 'int', $iStateID, _
			'int', $iPropID, 'wstr', '', 'int', 4096)
	If @error Then Return SetError(@error, @extended, '')
	If $aRet[0] Then Return SetError(10, $aRet[0], '')

	Return $aRet[5]
EndFunc   ;==>_WinAPI_GetThemeFilename

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetThemeFont($hTheme, $iPartID, $iStateID, $iPropID, $hDC = 0)
	Local $tLOGFONT = DllStructCreate($tagLOGFONT)
	Local $aRet = DllCall('uxtheme.dll', 'long', 'GetThemeFont', 'handle', $hTheme, 'handle', $hDC, 'int', $iPartID, _
			'int', $iStateID, 'int', $iPropID, 'struct*', $tLOGFONT)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $tLOGFONT
EndFunc   ;==>_WinAPI_GetThemeFont

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetThemeInt($hTheme, $iPartID, $iStateID, $iPropID)
	Local $aRet = DllCall('uxtheme.dll', 'long', 'GetThemeInt', 'handle', $hTheme, 'int', $iPartID, 'int', $iStateID, _
			'int', $iPropID, 'int*', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $aRet[5]
EndFunc   ;==>_WinAPI_GetThemeInt

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetThemeMargins($hTheme, $iPartID, $iStateID, $iPropID, $hDC, $tRECT)
	Local $tMARGINS = DllStructCreate($tagMARGINS)
	Local $aRet = DllCall('uxtheme.dll', 'long', 'GetThemeMargins', 'handle', $hTheme, 'handle', $hDC, 'int', $iPartID, _
			'int', $iStateID, 'int', $iPropID, 'struct*', $tRECT, 'struct*', $tMARGINS)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $tMARGINS
EndFunc   ;==>_WinAPI_GetThemeMargins

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetThemeMetric($hTheme, $iPartID, $iStateID, $iPropID, $hDC = 0)
	Local $aRet = DllCall('uxtheme.dll', 'long', 'GetThemeMetric', 'handle', $hTheme, 'handle', $hDC, 'int', $iPartID, _
			'int', $iStateID, 'int', $iPropID, 'int*', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $aRet[6]
EndFunc   ;==>_WinAPI_GetThemeMetric

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetThemePartSize($hTheme, $iPartID, $iStateID, $hDC, $tRECT, $iType)
	Local $tSIZE = DllStructCreate($tagSIZE)
	Local $aRet = DllCall('uxtheme.dll', 'long', 'GetThemePartSize', 'handle', $hTheme, 'handle', $hDC, 'int', $iPartID, _
			'int', $iStateID, 'struct*', $tRECT, 'int', $iType, 'struct*', $tSIZE)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $tSIZE
EndFunc   ;==>_WinAPI_GetThemePartSize

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetThemePosition($hTheme, $iPartID, $iStateID, $iPropID)
	Local $tPOINT = DllStructCreate($tagPOINT)
	Local $aRet = DllCall('uxtheme.dll', 'long', 'GetThemePosition', 'handle', $hTheme, 'int', $iPartID, 'int', $iStateID, _
			'int', $iPropID, 'struct*', $tPOINT)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $tPOINT
EndFunc   ;==>_WinAPI_GetThemePosition

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetThemePropertyOrigin($hTheme, $iPartID, $iStateID, $iPropID)
	Local $aRet = DllCall('uxtheme.dll', 'long', 'GetThemePropertyOrigin', 'handle', $hTheme, 'int', $iPartID, 'int', $iStateID, _
			'int', $iPropID, 'uint*', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $aRet[5]
EndFunc   ;==>_WinAPI_GetThemePropertyOrigin

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetThemeRect($hTheme, $iPartID, $iStateID, $iPropID)
	Local $tRECT = DllStructCreate($tagRECT)
	Local $aRet = DllCall('uxtheme.dll', 'long', 'GetThemeRect', 'handle', $hTheme, 'int', $iPartID, 'int', $iStateID, _
			'int', $iPropID, 'struct*', $tRECT)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $tRECT
EndFunc   ;==>_WinAPI_GetThemeRect

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetThemeString($hTheme, $iPartID, $iStateID, $iPropID)
	Local $aRet = DllCall('uxtheme.dll', 'long', 'GetThemeString', 'handle', $hTheme, 'int', $iPartID, 'int', $iStateID, _
			'int', $iPropID, 'wstr', '', 'int', 4096)
	If @error Then Return SetError(@error, @extended, '')
	If $aRet[0] Then Return SetError(10, $aRet[0], '')

	Return $aRet[5]
EndFunc   ;==>_WinAPI_GetThemeString

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetThemeSysBool($hTheme, $iBoolID)
	Local $aRet = DllCall('uxtheme.dll', 'bool', 'GetThemeSysBool', 'handle', $hTheme, 'int', $iBoolID)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetThemeSysBool

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetThemeSysColor($hTheme, $iColorID)
	Local $aRet = DllCall('uxtheme.dll', 'dword', 'GetThemeSysColor', 'handle', $hTheme, 'int', $iColorID)
	If @error Then Return SetError(@error, @extended, -1)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetThemeSysColor

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetThemeSysColorBrush($hTheme, $iColorID)
	Local $aRet = DllCall('uxtheme.dll', 'handle', 'GetThemeSysColorBrush', 'handle', $hTheme, 'int', $iColorID)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetThemeSysColorBrush

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetThemeSysFont($hTheme, $iFontID)
	Local $tLOGFONT = DllStructCreate($tagLOGFONT)
	Local $aRet = DllCall('uxtheme.dll', 'long', 'GetThemeSysFont', 'handle', $hTheme, 'int', $iFontID, 'struct*', $tLOGFONT)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $tLOGFONT
EndFunc   ;==>_WinAPI_GetThemeSysFont

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetThemeSysInt($hTheme, $iIntID)
	Local $aRet = DllCall('uxtheme.dll', 'long', 'GetThemeSysInt', 'handle', $hTheme, 'int', $iIntID, 'int*', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $aRet[3]
EndFunc   ;==>_WinAPI_GetThemeSysInt

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetThemeSysSize($hTheme, $iSizeID)
	Local $aRet = DllCall('uxtheme.dll', 'int', 'GetThemeSysSize', 'handle', $hTheme, 'int', $iSizeID)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetThemeSysSize

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetThemeSysString($hTheme, $iStringID)
	Local $aRet = DllCall('uxtheme.dll', 'long', 'GetThemeSysString', 'handle', $hTheme, 'int', $iStringID, 'wstr', '', 'int', 4096)
	If @error Then Return SetError(@error, @extended, '')
	If $aRet[0] Then Return SetError(10, $aRet[0], '')

	Return $aRet[3]
EndFunc   ;==>_WinAPI_GetThemeSysString

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetThemeTextExtent($hTheme, $iPartID, $iStateID, $hDC, $sText, $tRECT, $iFlags)
	Local $tAREA = DllStructCreate($tagRECT)
	Local $aRet = DllCall('uxtheme.dll', 'long', 'GetThemeTextExtent', 'handle', $hTheme, 'handle', $hDC, 'int', $iPartID, _
			'int', $iStateID, 'wstr', $sText, 'int', -1, 'dword', $iFlags, 'struct*', $tRECT, 'struct*', $tAREA)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $tAREA
EndFunc   ;==>_WinAPI_GetThemeTextExtent

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_GetThemeTextMetrics($hTheme, $iPartID, $iStateID, $hDC = 0)
	Local $tTEXTMETRIC = DllStructCreate($tagTEXTMETRIC)
	Local $aRet = DllCall('uxtheme.dll', 'long', 'GetThemeTextMetrics', 'handle', $hTheme, 'handle', $hDC, 'int', $iPartID, _
			'int', $iStateID, 'struct*', $tTEXTMETRIC)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $tTEXTMETRIC
EndFunc   ;==>_WinAPI_GetThemeTextMetrics

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetThemeTransitionDuration($hTheme, $iPartID, $iStateIDFrom, $iStateIDTo, $iPropID)
	Local $aRet = DllCall('uxtheme.dll', 'long', 'GetThemeTransitionDuration', 'handle', $hTheme, 'int', $iPartID, _
			'int', $iStateIDFrom, 'int', $iStateIDTo, 'int', $iPropID, 'dword*', 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return $aRet[6]
EndFunc   ;==>_WinAPI_GetThemeTransitionDuration

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_GetWindowTheme($hWnd)
	Local $aRet = DllCall('uxtheme.dll', 'handle', 'GetWindowTheme', 'hwnd', $hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetWindowTheme

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_IsThemeActive()
	Local $aRet = DllCall('uxtheme.dll', 'bool', 'IsThemeActive')
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_IsThemeActive

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_IsThemeBackgroundPartiallyTransparent($hTheme, $iPartID, $iStateID)
	Local $aRet = DllCall('uxtheme.dll', 'bool', 'IsThemeBackgroundPartiallyTransparent', 'handle', $hTheme, 'int', $iPartID, _
			'int', $iStateID)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_IsThemeBackgroundPartiallyTransparent

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_IsThemePartDefined($hTheme, $iPartID)
	Local $aRet = DllCall('uxtheme.dll', 'int', 'IsThemePartDefined', 'handle', $hTheme, 'int', $iPartID, 'int', 0)
	If @error Then Return SetError(@error, @extended, False)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_IsThemePartDefined

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: Jpm
; ===============================================================================================================================
Func _WinAPI_OpenThemeData($hWnd, $sClass)
	Local $aRet = DllCall('uxtheme.dll', 'handle', 'OpenThemeData', 'hwnd', $hWnd, 'wstr', $sClass)
	If @error Then Return SetError(@error, @extended, 0)
	; If Not $aRet[0] Then Return SetError(1000, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_WinAPI_OpenThemeData

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_SetThemeAppProperties($iFlags)
	DllCall('uxtheme.dll', 'none', 'SetThemeAppProperties', 'dword', $iFlags)
	If @error Then Return SetError(@error, @extended, 0)

	Return 1
EndFunc   ;==>_WinAPI_SetThemeAppProperties

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _WinAPI_SetWindowTheme($hWnd, $sName = 0, $sList = 0)
	Local $sTypeOfName = 'wstr', $sTypeOfList = 'wstr'
	If Not IsString($sName) Then
		$sTypeOfName = 'ptr'
		$sName = 0
	EndIf
	If Not IsString($sList) Then
		$sTypeOfList = 'ptr'
		$sList = 0
	EndIf

	Local $aRet = DllCall('uxtheme.dll', 'long', 'SetWindowTheme', 'hwnd', $hWnd, $sTypeOfName, $sName, $sTypeOfList, $sList)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)

	Return 1
EndFunc   ;==>_WinAPI_SetWindowTheme

#EndRegion Public Functions
