#include-once

#include "GDIPlusConstants.au3"
#include "StructureConstants.au3"
#include "WinAPI.au3"
#include "WinAPIGdi.au3"

; #INDEX# =======================================================================================================================
; Title .........: GDIPlus
; AutoIt Version : 3.3.14.2
; Language ......: English
; Description ...: Functions that assist with Microsoft Windows GDI+ management.
;                  It enables applications to use graphics and formatted text on both the video display and the printer.
;                  Applications based on the Microsoft Win32 API do not access graphics hardware directly.
;                  Instead, GDI+ interacts with device drivers on behalf of applications.
;                  GDI+ can be used in all Windows-based applications.
;                  GDI+ is new technology that is included in Windows XP and the Windows Server 2003.
; Author ........: Paul Campbell (PaulIA), rover, smashly, monoceres, Malkey, Authenticity
; Modified ......: Gary Frost, UEZ, Eukalyptus, jpm
; Dll ...........: GDIPlus.dll
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
Global $__g_hGDIPBrush = 0
Global $__g_hGDIPDll = 0
Global $__g_hGDIPPen = 0
Global $__g_iGDIPRef = 0
Global $__g_iGDIPToken = 0
Global $__g_bGDIP_V1_0 = True
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _GDIPlus_ArrowCapCreate
; _GDIPlus_ArrowCapDispose
; _GDIPlus_ArrowCapGetFillState
; _GDIPlus_ArrowCapGetHeight
; _GDIPlus_ArrowCapGetMiddleInset
; _GDIPlus_ArrowCapGetWidth
; _GDIPlus_ArrowCapSetFillState
; _GDIPlus_ArrowCapSetHeight
; _GDIPlus_ArrowCapSetMiddleInset
; _GDIPlus_ArrowCapSetWidth
; _GDIPlus_BitmapCloneArea
; _GDIPlus_BitmapCreateDIBFromBitmap
; _GDIPlus_BitmapCreateFromFile
; _GDIPlus_BitmapCreateFromGraphics
; _GDIPlus_BitmapCreateFromHBITMAP
; _GDIPlus_BitmapCreateFromHICON
; _GDIPlus_BitmapCreateFromHICON32
; _GDIPlus_BitmapCreateFromMemory
; _GDIPlus_BitmapCreateFromResource
; _GDIPlus_BitmapCreateFromScan0
; _GDIPlus_BitmapCreateFromStream
; _GDIPlus_BitmapCreateHBITMAPFromBitmap
; _GDIPlus_BitmapDispose
; _GDIPlus_BitmapGetPixel
; _GDIPlus_BitmapLockBits
; _GDIPlus_BitmapSetPixel
; _GDIPlus_BitmapUnlockBits
; _GDIPlus_BrushClone
; _GDIPlus_BrushCreateSolid
; _GDIPlus_BrushDispose
; _GDIPlus_BrushGetSolidColor
; _GDIPlus_BrushGetType
; _GDIPlus_BrushSetSolidColor
; _GDIPlus_ColorMatrixCreate
; _GDIPlus_ColorMatrixCreateGrayScale
; _GDIPlus_ColorMatrixCreateNegative
; _GDIPlus_ColorMatrixCreateSaturation
; _GDIPlus_ColorMatrixCreateScale
; _GDIPlus_ColorMatrixCreateTranslate
; _GDIPlus_CustomLineCapClone
; _GDIPlus_CustomLineCapCreate
; _GDIPlus_CustomLineCapDispose
; _GDIPlus_CustomLineCapGetStrokeCaps
; _GDIPlus_CustomLineCapSetStrokeCaps
; _GDIPlus_Decoders
; _GDIPlus_DecodersGetCount
; _GDIPlus_DecodersGetSize
; _GDIPlus_DrawImagePoints
; _GDIPlus_Encoders
; _GDIPlus_EncodersGetCLSID
; _GDIPlus_EncodersGetCount
; _GDIPlus_EncodersGetParamList
; _GDIPlus_EncodersGetParamListSize
; _GDIPlus_EncodersGetSize
; _GDIPlus_FontCreate
; _GDIPlus_FontDispose
; _GDIPlus_FontFamilyCreate
; _GDIPlus_FontFamilyCreateFromCollection
; _GDIPlus_FontFamilyDispose
; _GDIPlus_FontFamilyGetCellAscent
; _GDIPlus_FontFamilyGetCellDescent
; _GDIPlus_FontFamilyGetEmHeight
; _GDIPlus_FontFamilyGetLineSpacing
; _GDIPlus_FontPrivateAddFont
; _GDIPlus_FontPrivateAddMemoryFont
; _GDIPlus_FontPrivateCollectionDispose
; _GDIPlus_FontPrivateCreateCollection
; _GDIPlus_FontGetHeight
; _GDIPlus_GraphicsClear
; _GDIPlus_GraphicsCreateFromHDC
; _GDIPlus_GraphicsCreateFromHWND
; _GDIPlus_GraphicsDispose
; _GDIPlus_GraphicsDrawArc
; _GDIPlus_GraphicsDrawBezier
; _GDIPlus_GraphicsDrawClosedCurve
; _GDIPlus_GraphicsDrawClosedCurve2
; _GDIPlus_GraphicsDrawCurve
; _GDIPlus_GraphicsDrawCurve2
; _GDIPlus_GraphicsDrawEllipse
; _GDIPlus_GraphicsDrawImage
; _GDIPlus_GraphicsDrawImagePointsRect
; _GDIPlus_GraphicsDrawImageRect
; _GDIPlus_GraphicsDrawImageRectRect
; _GDIPlus_GraphicsDrawLine
; _GDIPlus_GraphicsDrawPath
; _GDIPlus_GraphicsDrawPie
; _GDIPlus_GraphicsDrawPolygon
; _GDIPlus_GraphicsDrawRect
; _GDIPlus_GraphicsDrawString
; _GDIPlus_GraphicsDrawStringEx
; _GDIPlus_GraphicsFillClosedCurve
; _GDIPlus_GraphicsFillClosedCurve2
; _GDIPlus_GraphicsFillEllipse
; _GDIPlus_GraphicsFillPath
; _GDIPlus_GraphicsFillPie
; _GDIPlus_GraphicsFillPolygon
; _GDIPlus_GraphicsFillRect
; _GDIPlus_GraphicsFillRegion
; _GDIPlus_GraphicsGetCompositingMode
; _GDIPlus_GraphicsGetCompositingQuality
; _GDIPlus_GraphicsGetDC
; _GDIPlus_GraphicsGetInterpolationMode
; _GDIPlus_GraphicsGetSmoothingMode
; _GDIPlus_GraphicsGetTransform
; _GDIPlus_GraphicsMeasureCharacterRanges
; _GDIPlus_GraphicsMeasureString
; _GDIPlus_GraphicsReleaseDC
; _GDIPlus_GraphicsResetClip
; _GDIPlus_GraphicsResetTransform
; _GDIPlus_GraphicsRestore
; _GDIPlus_GraphicsRotateTransform
; _GDIPlus_GraphicsSave
; _GDIPlus_GraphicsScaleTransform
; _GDIPlus_GraphicsSetClipPath
; _GDIPlus_GraphicsSetClipRect
; _GDIPlus_GraphicsSetClipRegion
; _GDIPlus_GraphicsSetCompositingMode
; _GDIPlus_GraphicsSetCompositingQuality
; _GDIPlus_GraphicsSetInterpolationMode
; _GDIPlus_GraphicsSetPixelOffsetMode
; _GDIPlus_GraphicsSetSmoothingMode
; _GDIPlus_GraphicsSetTextRenderingHint
; _GDIPlus_GraphicsSetTransform
; _GDIPlus_GraphicsTransformPoints
; _GDIPlus_GraphicsTranslateTransform
; _GDIPlus_HatchBrushCreate
; _GDIPlus_HICONCreateFromBitmap
; _GDIPlus_ImageAttributesCreate
; _GDIPlus_ImageAttributesDispose
; _GDIPlus_ImageAttributesSetColorKeys
; _GDIPlus_ImageAttributesSetColorMatrix
; _GDIPlus_ImageDispose
; _GDIPlus_ImageGetFlags
; _GDIPlus_ImageGetGraphicsContext
; _GDIPlus_ImageGetHeight
; _GDIPlus_ImageGetHorizontalResolution
; _GDIPlus_ImageGetPixelFormat
; _GDIPlus_ImageGetRawFormat
; _GDIPlus_ImageGetThumbnail
; _GDIPlus_ImageGetType
; _GDIPlus_ImageGetVerticalResolution
; _GDIPlus_ImageGetWidth
; _GDIPlus_ImageLoadFromFile
; _GDIPlus_ImageLoadFromStream
; _GDIPlus_ImageRotateFlip
; _GDIPlus_ImageSaveToFile
; _GDIPlus_ImageSaveToFileEx
; _GDIPlus_ImageSaveToStream
; _GDIPlus_ImageScale
; _GDIPlus_ImageResize
; _GDIPlus_LineBrushCreate
; _GDIPlus_LineBrushCreateFromRect
; _GDIPlus_LineBrushCreateFromRectWithAngle
; _GDIPlus_LineBrushGetColors
; _GDIPlus_LineBrushGetRect
; _GDIPlus_LineBrushMultiplyTransform
; _GDIPlus_LineBrushResetTransform
; _GDIPlus_LineBrushSetBlend
; _GDIPlus_LineBrushSetColors
; _GDIPlus_LineBrushSetGammaCorrection
; _GDIPlus_LineBrushSetLinearBlend
; _GDIPlus_LineBrushSetPresetBlend
; _GDIPlus_LineBrushSetSigmaBlend
; _GDIPlus_LineBrushSetTransform
; _GDIPlus_MatrixCreate
; _GDIPlus_MatrixClone
; _GDIPlus_MatrixDispose
; _GDIPlus_MatrixGetElements
; _GDIPlus_MatrixInvert
; _GDIPlus_MatrixMultiply
; _GDIPlus_MatrixRotate
; _GDIPlus_MatrixScale
; _GDIPlus_MatrixSetElements
; _GDIPlus_MatrixShear
; _GDIPlus_MatrixTransformPoints
; _GDIPlus_MatrixTranslate
; _GDIPlus_ParamAdd
; _GDIPlus_ParamInit
; _GDIPlus_ParamSize
; _GDIPlus_PathAddArc
; _GDIPlus_PathAddBezier
; _GDIPlus_PathAddClosedCurve
; _GDIPlus_PathAddClosedCurve2
; _GDIPlus_PathAddCurve
; _GDIPlus_PathAddCurve2
; _GDIPlus_PathAddCurve3
; _GDIPlus_PathAddEllipse
; _GDIPlus_PathAddLine
; _GDIPlus_PathAddLine2
; _GDIPlus_PathAddPath
; _GDIPlus_PathAddPie
; _GDIPlus_PathAddPolygon
; _GDIPlus_PathAddRectangle
; _GDIPlus_PathAddString
; _GDIPlus_PathBrushCreate
; _GDIPlus_PathBrushCreateFromPath
; _GDIPlus_PathBrushGetCenterPoint
; _GDIPlus_PathBrushGetFocusScales
; _GDIPlus_PathBrushGetPointCount
; _GDIPlus_PathBrushGetRect
; _GDIPlus_PathBrushGetWrapMode
; _GDIPlus_PathBrushMultiplyTransform
; _GDIPlus_PathBrushResetTransform
; _GDIPlus_PathBrushSetBlend
; _GDIPlus_PathBrushSetCenterColor
; _GDIPlus_PathBrushSetCenterPoint
; _GDIPlus_PathBrushSetFocusScales
; _GDIPlus_PathBrushSetGammaCorrection
; _GDIPlus_PathBrushSetLinearBlend
; _GDIPlus_PathBrushSetPresetBlend
; _GDIPlus_PathBrushSetSigmaBlend
; _GDIPlus_PathBrushSetSurroundColor
; _GDIPlus_PathBrushSetSurroundColorsWithCount
; _GDIPlus_PathBrushSetTransform
; _GDIPlus_PathBrushSetWrapMode
; _GDIPlus_PathClone
; _GDIPlus_PathCloseFigure
; _GDIPlus_PathCreate
; _GDIPlus_PathCreate2
; _GDIPlus_PathDispose
; _GDIPlus_PathFlatten
; _GDIPlus_PathGetData
; _GDIPlus_PathGetFillMode
; _GDIPlus_PathGetLastPoint
; _GDIPlus_PathGetPointCount
; _GDIPlus_PathGetPoints
; _GDIPlus_PathGetWorldBounds
; _GDIPlus_PathIsOutlineVisiblePoint
; _GDIPlus_PathIsVisiblePoint
; _GDIPlus_PathIterCreate
; _GDIPlus_PathIterDispose
; _GDIPlus_PathIterGetSubpathCount
; _GDIPlus_PathIterNextMarkerPath
; _GDIPlus_PathIterNextSubpathPath
; _GDIPlus_PathIterRewind
; _GDIPlus_PathReset
; _GDIPlus_PathReverse
; _GDIPlus_PathSetFillMode
; _GDIPlus_PathSetMarker
; _GDIPlus_PathStartFigure
; _GDIPlus_PathTransform
; _GDIPlus_PathWarp
; _GDIPlus_PathWiden
; _GDIPlus_PathWindingModeOutline
; _GDIPlus_PenCreate
; _GDIPlus_PenCreate2
; _GDIPlus_PenDispose
; _GDIPlus_PenGetAlignment
; _GDIPlus_PenGetColor
; _GDIPlus_PenGetCustomEndCap
; _GDIPlus_PenGetDashCap
; _GDIPlus_PenGetDashStyle
; _GDIPlus_PenGetEndCap
; _GDIPlus_PenGetMiterLimit
; _GDIPlus_PenGetWidth
; _GDIPlus_PenSetAlignment
; _GDIPlus_PenSetColor
; _GDIPlus_PenSetCustomEndCap
; _GDIPlus_PenSetDashCap
; _GDIPlus_PenSetDashStyle
; _GDIPlus_PenSetEndCap
; _GDIPlus_PenSetLineCap
; _GDIPlus_PenSetLineJoin
; _GDIPlus_PenSetMiterLimit
; _GDIPlus_PenSetStartCap
; _GDIPlus_PenSetWidth
; _GDIPlus_RectFCreate
; _GDIPlus_RegionClone
; _GDIPlus_RegionCombinePath
; _GDIPlus_RegionCombineRect
; _GDIPlus_RegionCombineRegion
; _GDIPlus_RegionCreate
; _GDIPlus_RegionCreateFromPath
; _GDIPlus_RegionCreateFromRect
; _GDIPlus_RegionDispose
; _GDIPlus_RegionGetBounds
; _GDIPlus_RegionGetHRgn
; _GDIPlus_RegionTransform
; _GDIPlus_RegionTranslate
; _GDIPlus_Shutdown
; _GDIPlus_Startup
; _GDIPlus_StringFormatCreate
; _GDIPlus_StringFormatDispose
; _GDIPlus_StringFormatGetMeasurableCharacterRangeCount
; _GDIPlus_StringFormatSetAlign
; _GDIPlus_StringFormatSetLineAlign
; _GDIPlus_StringFormatSetMeasurableCharacterRanges
; _GDIPlus_TextureCreate
; _GDIPlus_TextureCreate2
; _GDIPlus_TextureCreateIA
;
;	GDIPlus version 1.1. functions
;
;					Bitmap APIs
; _GDIPlus_BitmapApplyEffect
; _GDIPlus_BitmapApplyEffectEx
; _GDIPlus_BitmapConvertFormat
; _GDIPlus_BitmapCreateApplyEffect
; _GDIPlus_BitmapCreateApplyEffectEx
; _GDIPlus_BitmapGetHistogram
; _GDIPlus_BitmapGetHistogramEx
; _GDIPlus_BitmapGetHistogramSize
; _GDIPlus_DrawImageFX
; _GDIPlus_DrawImageFXEx
; _GDIPlus_PaletteInitialize

; _GDIPlus_EffectCreate
; _GDIPlus_EffectCreateBlur
; _GDIPlus_EffectCreateBrightnessContrast
; _GDIPlus_EffectCreateColorBalance
; _GDIPlus_EffectCreateColorCurve
; _GDIPlus_EffectCreateColorLUT
; _GDIPlus_EffectCreateColorMatrix
; _GDIPlus_EffectCreateHueSaturationLightness
; _GDIPlus_EffectCreateLevels
; _GDIPlus_EffectCreateRedEyeCorrection
; _GDIPlus_EffectCreateSharpen
; _GDIPlus_EffectCreateTint
; _GDIPlus_EffectDispose
; _GDIPlus_EffectGetParameters
; _GDIPlus_EffectSetParameters
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; __GDIPlus_BrushDefCreate
; __GDIPlus_BrushDefDispose
; __GDIPlus_EffectGetParameterSize
; __GDIPlus_ExtractFileExt
; __GDIPlus_LastDelimiter
; __GDIPlus_PenDefCreate
; __GDIPlus_PenDefDispose
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_ArrowCapCreate($fHeight, $fWidth, $bFilled = True)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateAdjustableArrowCap", "float", $fHeight, "float", $fWidth, "bool", $bFilled, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[4]
EndFunc   ;==>_GDIPlus_ArrowCapCreate

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_ArrowCapDispose($hCap)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDeleteCustomLineCap", "handle", $hCap)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_ArrowCapDispose

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_ArrowCapGetFillState($hArrowCap)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetAdjustableArrowCapFillState", "handle", $hArrowCap, "bool*", 0)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_ArrowCapGetFillState

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_ArrowCapGetHeight($hArrowCap)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetAdjustableArrowCapHeight", "handle", $hArrowCap, "float*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_ArrowCapGetHeight

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_ArrowCapGetMiddleInset($hArrowCap)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetAdjustableArrowCapMiddleInset", "handle", $hArrowCap, "float*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_ArrowCapGetMiddleInset

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_ArrowCapGetWidth($hArrowCap)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetAdjustableArrowCapWidth", "handle", $hArrowCap, "float*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_ArrowCapGetWidth

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_ArrowCapSetFillState($hArrowCap, $bFilled = True)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetAdjustableArrowCapFillState", "handle", $hArrowCap, "bool", $bFilled)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_ArrowCapSetFillState

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_ArrowCapSetHeight($hArrowCap, $fHeight)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetAdjustableArrowCapHeight", "handle", $hArrowCap, "float", $fHeight)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_ArrowCapSetHeight

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_ArrowCapSetMiddleInset($hArrowCap, $fInset)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetAdjustableArrowCapMiddleInset", "handle", $hArrowCap, "float", $fInset)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_ArrowCapSetMiddleInset

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_ArrowCapSetWidth($hArrowCap, $fWidth)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetAdjustableArrowCapWidth", "handle", $hArrowCap, "float", $fWidth)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_ArrowCapSetWidth

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_BitmapCloneArea($hBitmap, $nLeft, $nTop, $nWidth, $nHeight, $iFormat = 0x00021808)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCloneBitmapArea", "float", $nLeft, "float", $nTop, "float", $nWidth, "float", $nHeight, _
			"int", $iFormat, "handle", $hBitmap, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[7]
EndFunc   ;==>_GDIPlus_BitmapCloneArea

; #FUNCTION# ====================================================================================================================
; Author ........: UEZ
; Modified ......: jpm
; ===============================================================================================================================
Func _GDIPlus_BitmapCreateDIBFromBitmap($hBitmap)
	Local $aRet = DllCall($__g_hGDIPDll, "uint", "GdipGetImageDimension", "handle", $hBitmap, "float*", 0, "float*", 0)
	If @error Or $aRet[0] Then Return SetError(@error + 10, $aRet[0], 0)
	Local $tData = _GDIPlus_BitmapLockBits($hBitmap, 0, 0, $aRet[2], $aRet[3], $GDIP_ILMREAD, $GDIP_PXF32ARGB)
	Local $pBits = DllStructGetData($tData, "Scan0")
	If Not $pBits Then Return 0
	Local $tBIHDR = DllStructCreate($tagBITMAPV5HEADER)
	DllStructSetData($tBIHDR, "bV5Size", DllStructGetSize($tBIHDR))
	DllStructSetData($tBIHDR, "bV5Width", $aRet[2])
	DllStructSetData($tBIHDR, "bV5Height", $aRet[3])
	DllStructSetData($tBIHDR, "bV5Planes", 1)
	DllStructSetData($tBIHDR, "bV5BitCount", 32)
	DllStructSetData($tBIHDR, "bV5Compression", 0) ; $BI_BITFIELDS = 3, $BI_RGB = 0, $BI_RLE8 = 1, $BI_RLE4 = 2, $RGBA = 0x41424752
	DllStructSetData($tBIHDR, "bV5SizeImage", $aRet[3] * DllStructGetData($tData, "Stride"))
	DllStructSetData($tBIHDR, "bV5AlphaMask", 0xFF000000)
	DllStructSetData($tBIHDR, "bV5RedMask", 0x00FF0000)
	DllStructSetData($tBIHDR, "bV5GreenMask", 0x0000FF00)
	DllStructSetData($tBIHDR, "bV5BlueMask", 0x000000FF)
	DllStructSetData($tBIHDR, "bV5CSType", 2) ; $LCS_WINDOWS_COLOR_SPACE = 2
	DllStructSetData($tBIHDR, "bV5Intent", 4) ; $LCS_GM_IMA = 4
	Local $hHBitmapv5 = DllCall("gdi32.dll", "ptr", "CreateDIBSection", "hwnd", 0, "struct*", $tBIHDR, "uint", 0, "ptr*", 0, "ptr", 0, "dword", 0)
	If Not @error And $hHBitmapv5[0] Then
		DllCall("gdi32.dll", "dword", "SetBitmapBits", "ptr", $hHBitmapv5[0], "dword", $aRet[2] * $aRet[3] * 4, "ptr", DllStructGetData($tData, "Scan0"))
		$hHBitmapv5 = $hHBitmapv5[0]
	Else
		$hHBitmapv5 = 0
	EndIf
	_GDIPlus_BitmapUnlockBits($hBitmap, $tData)
	$tData = 0
	$tBIHDR = 0
	Return $hHBitmapv5
EndFunc   ;==>_GDIPlus_BitmapCreateDIBFromBitmap

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_BitmapCreateFromFile($sFileName)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateBitmapFromFile", "wstr", $sFileName, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_BitmapCreateFromFile

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_BitmapCreateFromGraphics($iWidth, $iHeight, $hGraphics)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateBitmapFromGraphics", "int", $iWidth, "int", $iHeight, "handle", $hGraphics, _
			"handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[4]
EndFunc   ;==>_GDIPlus_BitmapCreateFromGraphics

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_BitmapCreateFromHBITMAP($hBitmap, $hPal = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateBitmapFromHBITMAP", "handle", $hBitmap, "handle", $hPal, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[3]
EndFunc   ;==>_GDIPlus_BitmapCreateFromHBITMAP

;==================================================================================================================================
; Author ........: UEZ
; Modified.......: progandy
;===================================================================================================================================
Func _GDIPlus_BitmapCreateFromMemory($dImage, $bHBITMAP = False)
	If Not IsBinary($dImage) Then Return SetError(1, 0, 0)
	Local $aResult = 0
	Local Const $dMemBitmap = Binary($dImage) ;load image saved in variable (memory) and convert it to binary
	Local Const $iLen = BinaryLen($dMemBitmap) ;get binary length of the image
	Local Const $GMEM_MOVEABLE = 0x0002
	$aResult = DllCall("kernel32.dll", "handle", "GlobalAlloc", "uint", $GMEM_MOVEABLE, "ulong_ptr", $iLen) ;allocates movable memory ($GMEM_MOVEABLE = 0x0002)
	If @error Then Return SetError(4, 0, 0)
	Local Const $hData = $aResult[0]
	$aResult = DllCall("kernel32.dll", "ptr", "GlobalLock", "handle", $hData)
	If @error Then Return SetError(5, 0, 0)
	Local $tMem = DllStructCreate("byte[" & $iLen & "]", $aResult[0]) ;create struct
	DllStructSetData($tMem, 1, $dMemBitmap) ;fill struct with image data
	DllCall("kernel32.dll", "bool", "GlobalUnlock", "handle", $hData) ;decrements the lock count associated with a memory object that was allocated with GMEM_MOVEABLE
	If @error Then Return SetError(6, 0, 0)
	Local Const $hStream = _WinAPI_CreateStreamOnHGlobal($hData) ;creates a stream object that uses an HGLOBAL memory handle to store the stream contents
	If @error Then Return SetError(2, 0, 0)
	Local Const $hBitmap = _GDIPlus_BitmapCreateFromStream($hStream) ;creates a Bitmap object based on an IStream COM interface
	If @error Then Return SetError(3, 0, 0)
	DllCall("oleaut32.dll", "long", "DispCallFunc", "ptr", $hStream, "ulong_ptr", 8 * (1 + @AutoItX64), "uint", 4, "ushort", 23, "uint", 0, "ptr", 0, "ptr", 0, "str", "") ;release memory from $hStream to avoid memory leak
	If $bHBITMAP Then
		Local Const $hHBmp = _GDIPlus_BitmapCreateDIBFromBitmap($hBitmap) ;supports GDI transparent color format
		_GDIPlus_BitmapDispose($hBitmap)
		Return $hHBmp
	EndIf
	Return $hBitmap
EndFunc   ;==>_GDIPlus_BitmapCreateFromMemory

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: UEZ
; ===============================================================================================================================
Func _GDIPlus_BitmapCreateFromResource($hInst, $vResourceName)
	Local $sType = "int"
	If IsString($vResourceName) Then $sType = "wstr"
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateBitmapFromResource", "handle", $hInst, $sType, $vResourceName, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[3]
EndFunc   ;==>_GDIPlus_BitmapCreateFromResource

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: UEZ
; ===============================================================================================================================
Func _GDIPlus_BitmapCreateFromScan0($iWidth, $iHeight, $iPixelFormat = $GDIP_PXF32ARGB, $iStride = 0, $pScan0 = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "uint", "GdipCreateBitmapFromScan0", "int", $iWidth, "int", $iHeight, "int", $iStride, "int", $iPixelFormat, "struct*", $pScan0, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[6]
EndFunc   ;==>_GDIPlus_BitmapCreateFromScan0

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: UEZ
; ===============================================================================================================================
Func _GDIPlus_BitmapCreateFromStream($pStream)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateBitmapFromStream", "ptr", $pStream, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_BitmapCreateFromStream

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap, $iARGB = 0xFF000000)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateHBITMAPFromBitmap", "handle", $hBitmap, "handle*", 0, "dword", $iARGB)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_BitmapCreateHBITMAPFromBitmap

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_BitmapDispose($hBitmap)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDisposeImage", "handle", $hBitmap)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_BitmapDispose

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; Example .......: No
; ===============================================================================================================================
Func _GDIPlus_BitmapCreateFromHICON($hIcon)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateBitmapFromHICON", "handle", $hIcon, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_BitmapCreateFromHICON

; #FUNCTION# ====================================================================================================================
; Author ........: Eukalyptus
; Modified.......:
; Example .......; No
; ===============================================================================================================================
Func _GDIPlus_BitmapCreateFromHICON32($hIcon)
	Local $tSIZE = _WinAPI_GetIconDimension($hIcon)
	Local $iWidth = DllStructGetData($tSIZE, 'X')
	Local $iHeight = DllStructGetData($tSIZE, 'Y')
	If $iWidth <= 0 Or $iHeight <= 0 Then Return SetError(10, -1, 0)
	Local $tBITMAPINFO = DllStructCreate("dword Size;long Width;long Height;word Planes;word BitCount;dword Compression;dword SizeImage;long XPelsPerMeter;long YPelsPerMeter;dword ClrUsed;dword ClrImportant;dword RGBQuad")
	DllStructSetData($tBITMAPINFO, 'Size', DllStructGetSize($tBITMAPINFO) - 4)
	DllStructSetData($tBITMAPINFO, 'Width', $iWidth)
	DllStructSetData($tBITMAPINFO, 'Height', -$iHeight)
	DllStructSetData($tBITMAPINFO, 'Planes', 1)
	DllStructSetData($tBITMAPINFO, 'BitCount', 32)
	DllStructSetData($tBITMAPINFO, 'Compression', 0)
	DllStructSetData($tBITMAPINFO, 'SizeImage', 0)
	Local $hDC = _WinAPI_CreateCompatibleDC(0)
	Local $pBits
	Local $hBmp = _WinAPI_CreateDIBSection(0, $tBITMAPINFO, 0, $pBits)
	Local $hOrig = _WinAPI_SelectObject($hDC, $hBmp)
	_WinAPI_DrawIconEx($hDC, 0, 0, $hIcon, $iWidth, $iHeight)
	Local $hBitmapIcon = _GDIPlus_BitmapCreateFromScan0($iWidth, $iHeight, $GDIP_PXF32ARGB, $iWidth * 4, $pBits)
	Local $hBitmap = _GDIPlus_BitmapCreateFromScan0($iWidth, $iHeight)
	Local $hContext = _GDIPlus_ImageGetGraphicsContext($hBitmap)
	_GDIPlus_GraphicsDrawImage($hContext, $hBitmapIcon, 0, 0)
	_GDIPlus_GraphicsDispose($hContext)
	_GDIPlus_BitmapDispose($hBitmapIcon)
	_WinAPI_SelectObject($hDC, $hOrig)
	_WinAPI_DeleteDC($hDC)
	_WinAPI_DeleteObject($hBmp)
	Return $hBitmap
EndFunc   ;==>_GDIPlus_BitmapCreateFromHICON32

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: UEZ
; ===============================================================================================================================
Func _GDIPlus_BitmapGetPixel($hBitmap, $iX, $iY)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipBitmapGetPixel", "handle", $hBitmap, "int", $iX, "int", $iY, "uint*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[4]
EndFunc   ;==>_GDIPlus_BitmapGetPixel

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_BitmapLockBits($hBitmap, $iLeft, $iTop, $iWidth, $iHeight, $iFlags = $GDIP_ILMREAD, $iFormat = $GDIP_PXF32RGB)
	Local $tData = DllStructCreate($tagGDIPBITMAPDATA)
	Local $tRECT = DllStructCreate($tagRECT)

	; The RECT is initialized strange for this function. It wants the Left and
	; Top members set as usual but instead of Right and Bottom also being
	; coordinates they are expected to be the Width and Height sizes
	; respectively.
	DllStructSetData($tRECT, "Left", $iLeft)
	DllStructSetData($tRECT, "Top", $iTop)
	DllStructSetData($tRECT, "Right", $iWidth)
	DllStructSetData($tRECT, "Bottom", $iHeight)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipBitmapLockBits", "handle", $hBitmap, "struct*", $tRECT, "uint", $iFlags, "int", $iFormat, "struct*", $tData)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $tData
EndFunc   ;==>_GDIPlus_BitmapLockBits

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: UEZ
; ===============================================================================================================================
Func _GDIPlus_BitmapSetPixel($hBitmap, $iX, $iY, $iARGB)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipBitmapSetPixel", "handle", $hBitmap, "int", $iX, "int", $iY, "uint", $iARGB)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_BitmapSetPixel

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_BitmapUnlockBits($hBitmap, $tBitmapData)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipBitmapUnlockBits", "handle", $hBitmap, "struct*", $tBitmapData)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_BitmapUnlockBits

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_BrushClone($hBrush)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCloneBrush", "handle", $hBrush, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_BrushClone

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_BrushCreateSolid($iARGB = 0xFF000000)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateSolidFill", "int", $iARGB, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_BrushCreateSolid

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_BrushDispose($hBrush)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDeleteBrush", "handle", $hBrush)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_BrushDispose

; #FUNCTION# ====================================================================================================================
; Author ........:
; Modified.......: smashly
; ===============================================================================================================================
Func _GDIPlus_BrushGetSolidColor($hBrush)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetSolidFillColor", "handle", $hBrush, "dword*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	If $aResult[0] Then Return SetError(10, $aResult[0], -1)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_BrushGetSolidColor

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_BrushGetType($hBrush)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetBrushType", "handle", $hBrush, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	If $aResult[0] Then Return SetError(10, $aResult[0], -1)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_BrushGetType

; #FUNCTION# ====================================================================================================================
; Author ........:
; Modified.......: smashly
; ===============================================================================================================================
Func _GDIPlus_BrushSetSolidColor($hBrush, $iARGB = 0xFF000000)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetSolidFillColor", "handle", $hBrush, "dword", $iARGB)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_BrushSetSolidColor

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: UEZ
; ===============================================================================================================================
Func _GDIPlus_ColorMatrixCreate()
	Return _GDIPlus_ColorMatrixCreateScale(1, 1, 1, 1)
EndFunc   ;==>_GDIPlus_ColorMatrixCreate

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: UEZ
; ===============================================================================================================================
Func _GDIPlus_ColorMatrixCreateGrayScale()
	Local $iI, $iJ, $tCM, $aLums[4] = [$GDIP_RLUM, $GDIP_GLUM, $GDIP_BLUM, 0]
	$tCM = DllStructCreate($tagGDIPCOLORMATRIX)
	For $iI = 0 To 3
		For $iJ = 1 To 3
			DllStructSetData($tCM, "m", $aLums[$iI], $iI * 5 + $iJ)
		Next
	Next
	DllStructSetData($tCM, "m", 1, 19)
	DllStructSetData($tCM, "m", 1, 25)
	Return $tCM
EndFunc   ;==>_GDIPlus_ColorMatrixCreateGrayScale

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: UEZ
; ===============================================================================================================================
Func _GDIPlus_ColorMatrixCreateNegative()
	Local $iI, $tCM
	$tCM = _GDIPlus_ColorMatrixCreateScale(-1, -1, -1, 1)
	For $iI = 1 To 4
		DllStructSetData($tCM, "m", 1, 20 + $iI)
	Next
	Return $tCM
EndFunc   ;==>_GDIPlus_ColorMatrixCreateNegative

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: UEZ
; ===============================================================================================================================
Func _GDIPlus_ColorMatrixCreateSaturation($fSat)
	Local $fSatComp, $tCM
	$tCM = DllStructCreate($tagGDIPCOLORMATRIX)
	$fSatComp = (1 - $fSat)
	DllStructSetData($tCM, "m", $fSatComp * $GDIP_RLUM + $fSat, 1)
	DllStructSetData($tCM, "m", $fSatComp * $GDIP_RLUM, 2)
	DllStructSetData($tCM, "m", $fSatComp * $GDIP_RLUM, 3)
	DllStructSetData($tCM, "m", $fSatComp * $GDIP_GLUM, 6)
	DllStructSetData($tCM, "m", $fSatComp * $GDIP_GLUM + $fSat, 7)
	DllStructSetData($tCM, "m", $fSatComp * $GDIP_GLUM, 8)
	DllStructSetData($tCM, "m", $fSatComp * $GDIP_BLUM, 11)
	DllStructSetData($tCM, "m", $fSatComp * $GDIP_BLUM, 12)
	DllStructSetData($tCM, "m", $fSatComp * $GDIP_BLUM + $fSat, 13)
	DllStructSetData($tCM, "m", 1, 19)
	DllStructSetData($tCM, "m", 1, 25)
	Return $tCM
EndFunc   ;==>_GDIPlus_ColorMatrixCreateSaturation

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: UEZ
; ===============================================================================================================================
Func _GDIPlus_ColorMatrixCreateScale($fRed, $fGreen, $fBlue, $fAlpha = 1)
	Local $tCM
	$tCM = DllStructCreate($tagGDIPCOLORMATRIX)
	DllStructSetData($tCM, "m", $fRed, 1)
	DllStructSetData($tCM, "m", $fGreen, 7)
	DllStructSetData($tCM, "m", $fBlue, 13)
	DllStructSetData($tCM, "m", $fAlpha, 19)
	DllStructSetData($tCM, "m", 1, 25)
	Return $tCM
EndFunc   ;==>_GDIPlus_ColorMatrixCreateScale

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: UEZ
; ===============================================================================================================================
Func _GDIPlus_ColorMatrixCreateTranslate($fRed, $fGreen, $fBlue, $fAlpha = 0)
	Local $iI, $tCM, $aFactors[4] = [$fRed, $fGreen, $fBlue, $fAlpha]
	$tCM = _GDIPlus_ColorMatrixCreate()
	For $iI = 0 To 3
		DllStructSetData($tCM, "m", $aFactors[$iI], 21 + $iI)
	Next
	Return $tCM
EndFunc   ;==>_GDIPlus_ColorMatrixCreateTranslate

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: UEZ
; ===============================================================================================================================
Func _GDIPlus_CustomLineCapClone($hCustomLineCap)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCloneCustomLineCap", "handle", $hCustomLineCap, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then SetError(10, $aResult[0], 0)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_CustomLineCapClone

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: UEZ
; ===============================================================================================================================
Func _GDIPlus_CustomLineCapCreate($hPathFill, $hPathStroke, $iLineCap = 0, $nBaseInset = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateCustomLineCap", "handle", $hPathFill, "handle", $hPathStroke, "int", $iLineCap, "float", $nBaseInset, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[5]
EndFunc   ;==>_GDIPlus_CustomLineCapCreate

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_CustomLineCapDispose($hCap)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDeleteCustomLineCap", "handle", $hCap)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_CustomLineCapDispose

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: UEZ
; Example .......; No
; ===============================================================================================================================
Func _GDIPlus_CustomLineCapGetStrokeCaps($hCustomLineCap)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetCustomLineCapStrokeCaps", "hwnd", $hCustomLineCap, "ptr*", 0, "ptr*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then SetError(10, $aResult[0], 0)

	Local $aCaps[2]
	$aCaps[0] = $aResult[2]
	$aCaps[1] = $aResult[3]
	Return $aCaps
EndFunc   ;==>_GDIPlus_CustomLineCapGetStrokeCaps

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: UEZ
; Example .......; No
; ===============================================================================================================================
Func _GDIPlus_CustomLineCapSetStrokeCaps($hCustomLineCap, $iStartCap, $iEndCap)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetCustomLineCapStrokeCaps", "handle", $hCustomLineCap, "int", $iStartCap, "int", $iEndCap)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_CustomLineCapSetStrokeCaps

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_Decoders()
	Local $iCount = _GDIPlus_DecodersGetCount()
	Local $iSize = _GDIPlus_DecodersGetSize()
	Local $tBuffer = DllStructCreate("byte[" & $iSize & "]")
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetImageDecoders", "uint", $iCount, "uint", $iSize, "struct*", $tBuffer)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Local $pBuffer = DllStructGetPtr($tBuffer)
	Local $tCodec, $aInfo[$iCount + 1][14]
	$aInfo[0][0] = $iCount
	For $iI = 1 To $iCount
		$tCodec = DllStructCreate($tagGDIPIMAGECODECINFO, $pBuffer)
		$aInfo[$iI][1] = _WinAPI_StringFromGUID(DllStructGetPtr($tCodec, "CLSID"))
		$aInfo[$iI][2] = _WinAPI_StringFromGUID(DllStructGetPtr($tCodec, "FormatID"))
		$aInfo[$iI][3] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "CodecName"))
		$aInfo[$iI][4] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "DllName"))
		$aInfo[$iI][5] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "FormatDesc"))
		$aInfo[$iI][6] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "FileExt"))
		$aInfo[$iI][7] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "MimeType"))
		$aInfo[$iI][8] = DllStructGetData($tCodec, "Flags")
		$aInfo[$iI][9] = DllStructGetData($tCodec, "Version")
		$aInfo[$iI][10] = DllStructGetData($tCodec, "SigCount")
		$aInfo[$iI][11] = DllStructGetData($tCodec, "SigSize")
		$aInfo[$iI][12] = DllStructGetData($tCodec, "SigPattern")
		$aInfo[$iI][13] = DllStructGetData($tCodec, "SigMask")
		$pBuffer += DllStructGetSize($tCodec)
	Next
	Return $aInfo
EndFunc   ;==>_GDIPlus_Decoders

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_DecodersGetCount()
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetImageDecodersSize", "uint*", 0, "uint*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	If $aResult[0] Then Return SetError(10, $aResult[0], -1)

	Return $aResult[1]
EndFunc   ;==>_GDIPlus_DecodersGetCount

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_DecodersGetSize()
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetImageDecodersSize", "uint*", 0, "uint*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	If $aResult[0] Then Return SetError(10, $aResult[0], -1)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_DecodersGetSize

; #FUNCTION# ====================================================================================================================
; Author ........: Malkey
; Modified.......:
; ===============================================================================================================================
Func _GDIPlus_DrawImagePoints($hGraphic, $hImage, $nULX, $nULY, $nURX, $nURY, $nLLX, $nLLY, $iCount = 3)
	Local $tPoint = DllStructCreate("float X;float Y;float X2;float Y2;float X3;float Y3")
	DllStructSetData($tPoint, "X", $nULX)
	DllStructSetData($tPoint, "Y", $nULY)
	DllStructSetData($tPoint, "X2", $nURX)
	DllStructSetData($tPoint, "Y2", $nURY)
	DllStructSetData($tPoint, "X3", $nLLX)
	DllStructSetData($tPoint, "Y3", $nLLY)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDrawImagePoints", "handle", $hGraphic, "handle", $hImage, "struct*", $tPoint, "int", $iCount)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_DrawImagePoints

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_Encoders()
	Local $iCount = _GDIPlus_EncodersGetCount()
	Local $iSize = _GDIPlus_EncodersGetSize()
	Local $tBuffer = DllStructCreate("byte[" & $iSize & "]")
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetImageEncoders", "uint", $iCount, "uint", $iSize, "struct*", $tBuffer)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Local $pBuffer = DllStructGetPtr($tBuffer)
	Local $tCodec, $aInfo[$iCount + 1][14]
	$aInfo[0][0] = $iCount
	For $iI = 1 To $iCount
		$tCodec = DllStructCreate($tagGDIPIMAGECODECINFO, $pBuffer)
		$aInfo[$iI][1] = _WinAPI_StringFromGUID(DllStructGetPtr($tCodec, "CLSID"))
		$aInfo[$iI][2] = _WinAPI_StringFromGUID(DllStructGetPtr($tCodec, "FormatID"))
		$aInfo[$iI][3] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "CodecName"))
		$aInfo[$iI][4] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "DllName"))
		$aInfo[$iI][5] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "FormatDesc"))
		$aInfo[$iI][6] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "FileExt"))
		$aInfo[$iI][7] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "MimeType"))
		$aInfo[$iI][8] = DllStructGetData($tCodec, "Flags")
		$aInfo[$iI][9] = DllStructGetData($tCodec, "Version")
		$aInfo[$iI][10] = DllStructGetData($tCodec, "SigCount")
		$aInfo[$iI][11] = DllStructGetData($tCodec, "SigSize")
		$aInfo[$iI][12] = DllStructGetData($tCodec, "SigPattern")
		$aInfo[$iI][13] = DllStructGetData($tCodec, "SigMask")
		$pBuffer += DllStructGetSize($tCodec)
	Next
	Return $aInfo
EndFunc   ;==>_GDIPlus_Encoders

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GDIPlus_EncodersGetCLSID($sFileExtension)
	Local $aEncoders = _GDIPlus_Encoders()
	If @error Then Return SetError(@error, 0, "")
	For $iI = 1 To $aEncoders[0][0]
		If StringInStr($aEncoders[$iI][6], "*." & $sFileExtension) > 0 Then Return $aEncoders[$iI][1]
	Next
	Return SetError(-1, -1, "")
EndFunc   ;==>_GDIPlus_EncodersGetCLSID

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_EncodersGetCount()
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetImageEncodersSize", "uint*", 0, "uint*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	If $aResult[0] Then Return SetError(10, $aResult[0], -1)

	Return $aResult[1]
EndFunc   ;==>_GDIPlus_EncodersGetCount

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost, jpm
; ===============================================================================================================================
Func _GDIPlus_EncodersGetParamList($hImage, $sEncoder)
	Local $iSize = _GDIPlus_EncodersGetParamListSize($hImage, $sEncoder)
	If @error Then Return SetError(@error + 10, @extended, 0)
	Local $tGUID = _WinAPI_GUIDFromString($sEncoder)
	Local $iRemainingSize = $iSize - 4 - _GDIPlus_ParamSize()
	Local $tBuffer
	If $iRemainingSize Then
		$tBuffer = DllStructCreate("dword Count;" & $tagGDIPENCODERPARAM & ";byte [" & $iRemainingSize & "]")
	Else
		$tBuffer = DllStructCreate("dword Count;" & $tagGDIPENCODERPARAM)
	EndIf
;~ 	Local $tBuffer = DllStructCreate("dword Count;byte GUID[" & $iSize - 4 & "]")
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetEncoderParameterList", "handle", $hImage, "struct*", $tGUID, "uint", $iSize, "struct*", $tBuffer)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $tBuffer
EndFunc   ;==>_GDIPlus_EncodersGetParamList

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_EncodersGetParamListSize($hImage, $sEncoder)
	Local $tGUID = _WinAPI_GUIDFromString($sEncoder)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetEncoderParameterListSize", "handle", $hImage, "struct*", $tGUID, "uint*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[3]
EndFunc   ;==>_GDIPlus_EncodersGetParamListSize

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_EncodersGetSize()
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetImageEncodersSize", "uint*", 0, "uint*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	If $aResult[0] Then Return SetError(10, $aResult[0], -1)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_EncodersGetSize

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_FontCreate($hFamily, $fSize, $iStyle = 0, $iUnit = 3)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateFont", "handle", $hFamily, "float", $fSize, "int", $iStyle, "int", $iUnit, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[5]
EndFunc   ;==>_GDIPlus_FontCreate

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_FontDispose($hFont)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDeleteFont", "handle", $hFont)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_FontDispose

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost, Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_FontFamilyCreate($sFamily, $pCollection = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateFontFamilyFromName", "wstr", $sFamily, "ptr", $pCollection, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[3]
EndFunc   ;==>_GDIPlus_FontFamilyCreate

; #FUNCTION# ====================================================================================================================
; Author ........: UEZ
; Modified ......:
; ===============================================================================================================================
Func _GDIPlus_FontFamilyCreateFromCollection($sFontName, $hFontCollection)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateFontFamilyFromName", "wstr", $sFontName, "ptr", $hFontCollection, "ptr*", 0)
	If @error Then Return SetError(@error, @extended, "")
	If $aResult[0] Then Return SetError(10, $aResult[0], "")

	Return $aResult[3]
EndFunc   ;==>_GDIPlus_FontFamilyCreateFromCollection

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_FontFamilyDispose($hFamily)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDeleteFontFamily", "handle", $hFamily)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_FontFamilyDispose

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_FontFamilyGetCellAscent($hFontFamily, $iStyle = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetCellAscent", "handle", $hFontFamily, "int", $iStyle, "ushort*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[3]
EndFunc   ;==>_GDIPlus_FontFamilyGetCellAscent

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_FontFamilyGetCellDescent($hFontFamily, $iStyle = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetCellDescent", "handle", $hFontFamily, "int", $iStyle, "ushort*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[3]
EndFunc   ;==>_GDIPlus_FontFamilyGetCellDescent

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_FontFamilyGetEmHeight($hFontFamily, $iStyle = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetEmHeight", "handle", $hFontFamily, "int", $iStyle, "ushort*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[3]
EndFunc   ;==>_GDIPlus_FontFamilyGetEmHeight

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_FontFamilyGetLineSpacing($hFontFamily, $iStyle = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetLineSpacing", "handle", $hFontFamily, "int", $iStyle, "ushort*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[3]
EndFunc   ;==>_GDIPlus_FontFamilyGetLineSpacing

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_FontGetHeight($hFont, $hGraphics)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetFontHeight", "handle", $hFont, "handle", $hGraphics, "float*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[3]
EndFunc   ;==>_GDIPlus_FontGetHeight

; #FUNCTION# ====================================================================================================================
; Author ........: UEZ
; Modified ......:
; ===============================================================================================================================
Func _GDIPlus_FontPrivateAddFont($hFontCollection, $sFontFile)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipPrivateAddFontFile", "ptr", $hFontCollection, "wstr", $sFontFile)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_FontPrivateAddFont

; #FUNCTION# ====================================================================================================================
; Author ........: UEZ
; Modified ......:
; ===============================================================================================================================
Func _GDIPlus_FontPrivateAddMemoryFont($hFontCollection, $tFont)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipPrivateAddMemoryFont", "handle", $hFontCollection, "struct*", $tFont, "int", DllStructGetSize($tFont))
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_FontPrivateAddMemoryFont

; #FUNCTION# ====================================================================================================================
; Author ........: UEZ
; Modified ......:
; ===============================================================================================================================
Func _GDIPlus_FontPrivateCollectionDispose($hFontCollection)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDeletePrivateFontCollection", "handle*", $hFontCollection)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_FontPrivateCollectionDispose

; #FUNCTION# ====================================================================================================================
; Author ........: UEZ
; Modified ......:
; ===============================================================================================================================
Func _GDIPlus_FontPrivateCreateCollection()
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipNewPrivateFontCollection", "ptr*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[1]
EndFunc   ;==>_GDIPlus_FontPrivateCreateCollection

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_GraphicsClear($hGraphics, $iARGB = 0xFF000000)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGraphicsClear", "handle", $hGraphics, "dword", $iARGB)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsClear

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_GraphicsCreateFromHDC($hDC)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateFromHDC", "handle", $hDC, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_GraphicsCreateFromHDC

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_GraphicsCreateFromHWND($hWnd)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateFromHWND", "hwnd", $hWnd, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_GraphicsCreateFromHWND

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_GraphicsDispose($hGraphics)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDeleteGraphics", "handle", $hGraphics)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsDispose

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost, UEZ, jpm
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawArc($hGraphics, $nX, $nY, $nWidth, $nHeight, $fStartAngle, $fSweepAngle, $hPen = 0)
	__GDIPlus_PenDefCreate($hPen)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDrawArc", "handle", $hGraphics, "handle", $hPen, "float", $nX, "float", $nY, _
			"float", $nWidth, "float", $nHeight, "float", $fStartAngle, "float", $fSweepAngle)
	__GDIPlus_PenDefDispose() ; does destroyed @error, @extended
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsDrawArc

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost, UEZ, jpm
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawBezier($hGraphics, $nX1, $nY1, $nX2, $nY2, $nX3, $nY3, $nX4, $nY4, $hPen = 0)
	__GDIPlus_PenDefCreate($hPen)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDrawBezier", "handle", $hGraphics, "handle", $hPen, "float", $nX1, "float", $nY1, _
			"float", $nX2, "float", $nY2, "float", $nX3, "float", $nY3, "float", $nX4, "float", $nY4)
	__GDIPlus_PenDefDispose() ; does destroyed @error, @extended
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsDrawBezier

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost, UEZ, jpm
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawClosedCurve($hGraphics, $aPoints, $hPen = 0)
	Local $iCount = $aPoints[0][0]
	Local $tPoints = DllStructCreate("float[" & $iCount * 2 & "]")
	For $iI = 1 To $iCount
		DllStructSetData($tPoints, 1, $aPoints[$iI][0], (($iI - 1) * 2) + 1)
		DllStructSetData($tPoints, 1, $aPoints[$iI][1], (($iI - 1) * 2) + 2)
	Next

	__GDIPlus_PenDefCreate($hPen)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDrawClosedCurve", "handle", $hGraphics, "handle", $hPen, "struct*", $tPoints, "int", $iCount)
	__GDIPlus_PenDefDispose() ; does destroyed @error, @extended
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsDrawClosedCurve

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: UEZ
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawClosedCurve2($hGraphics, $aPoints, $nTension, $hPen = 0)
	Local $iI, $iCount, $tPoints, $aResult
	__GDIPlus_PenDefCreate($hPen)
	$iCount = $aPoints[0][0]
	$tPoints = DllStructCreate("float[" & $iCount * 2 & "]")
	For $iI = 1 To $iCount
		DllStructSetData($tPoints, 1, $aPoints[$iI][0], (($iI - 1) * 2) + 1)
		DllStructSetData($tPoints, 1, $aPoints[$iI][1], (($iI - 1) * 2) + 2)
	Next
	$aResult = DllCall($__g_hGDIPDll, "int", "GdipDrawClosedCurve2", "handle", $hGraphics, "handle", $hPen, "struct*", $tPoints, "int", $iCount, "float", $nTension)
	__GDIPlus_PenDefDispose() ; does destroyed @error, @extended
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsDrawClosedCurve2

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost, UEZ, jpm
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawCurve($hGraphics, $aPoints, $hPen = 0)
	Local $iCount = $aPoints[0][0]
	Local $tPoints = DllStructCreate("float[" & $iCount * 2 & "]")
	For $iI = 1 To $iCount
		DllStructSetData($tPoints, 1, $aPoints[$iI][0], (($iI - 1) * 2) + 1)
		DllStructSetData($tPoints, 1, $aPoints[$iI][1], (($iI - 1) * 2) + 2)
	Next

	__GDIPlus_PenDefCreate($hPen)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDrawCurve", "handle", $hGraphics, "handle", $hPen, "struct*", $tPoints, "int", $iCount)
	__GDIPlus_PenDefDispose() ; does destroyed @error, @extended
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsDrawCurve

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: UEZ
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawCurve2($hGraphics, $aPoints, $nTension, $hPen = 0)
	Local $iI, $iCount, $tPoints, $aResult
	__GDIPlus_PenDefCreate($hPen)
	$iCount = $aPoints[0][0]
	$tPoints = DllStructCreate("float[" & $iCount * 2 & "]")
	For $iI = 1 To $iCount
		DllStructSetData($tPoints, 1, $aPoints[$iI][0], (($iI - 1) * 2) + 1)
		DllStructSetData($tPoints, 1, $aPoints[$iI][1], (($iI - 1) * 2) + 2)
	Next
	$aResult = DllCall($__g_hGDIPDll, "int", "GdipDrawCurve2", "handle", $hGraphics, "handle", $hPen, "struct*", $tPoints, "int", $iCount, "float", $nTension)
	__GDIPlus_PenDefDispose() ; does destroyed @error, @extended
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsDrawCurve2

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost, UEZ, jpm
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawEllipse($hGraphics, $nX, $nY, $nWidth, $nHeight, $hPen = 0)
	__GDIPlus_PenDefCreate($hPen)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDrawEllipse", "handle", $hGraphics, "handle", $hPen, "float", $nX, "float", $nY, _
			"float", $nWidth, "float", $nHeight)
	__GDIPlus_PenDefDispose() ; does destroyed @error, @extended
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsDrawEllipse

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost, UEZ, jpm
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawImage($hGraphics, $hImage, $nX, $nY)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDrawImage", "handle", $hGraphics, "handle", $hImage, "float", $nX, "float", $nY)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsDrawImage

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawImagePointsRect($hGraphics, $hImage, $nULX, $nULY, $nURX, $nURY, $nLLX, $nLLY, $nSrcX, $nSrcY, $nSrcWidth, $nSrcHeight, $hImageAttributes = 0, $iUnit = 2)
	Local $tPoints = DllStructCreate("float X; float Y; float X2; float Y2; float X3; float Y3;")
	DllStructSetData($tPoints, "X", $nULX)
	DllStructSetData($tPoints, "Y", $nULY)
	DllStructSetData($tPoints, "X2", $nURX)
	DllStructSetData($tPoints, "Y2", $nURY)
	DllStructSetData($tPoints, "X3", $nLLX)
	DllStructSetData($tPoints, "Y3", $nLLY)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDrawImagePointsRect", "handle", $hGraphics, "handle", $hImage, "struct*", $tPoints, "int", 3, "float", $nSrcX, "float", $nSrcY, "float", $nSrcWidth, "float", $nSrcHeight, "int", $iUnit, "handle", $hImageAttributes, "ptr", 0, "ptr", 0)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsDrawImagePointsRect

; #FUNCTION# ====================================================================================================================
; Author ........: smashly
; Modified.......: UEZ, jpm
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawImageRect($hGraphics, $hImage, $nX, $nY, $nW, $nH)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDrawImageRect", "handle", $hGraphics, "handle", $hImage, "float", $nX, "float", $nY, _
			"float", $nW, "float", $nH)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsDrawImageRect

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost, UEZ, jpm
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawImageRectRect($hGraphics, $hImage, $nSrcX, $nSrcY, $nSrcWidth, $nSrcHeight, $nDstX, $nDstY, $nDstWidth, $nDstHeight, $pAttributes = 0, $iUnit = 2)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDrawImageRectRect", "handle", $hGraphics, "handle", $hImage, _
			"float", $nDstX, "float", $nDstY, "float", $nDstWidth, "float", $nDstHeight, _
			"float", $nSrcX, "float", $nSrcY, "float", $nSrcWidth, "float", $nSrcHeight, _
			"int", $iUnit, "handle", $pAttributes, "ptr", 0, "ptr", 0)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsDrawImageRectRect

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost, UEZ, jpm
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawLine($hGraphics, $nX1, $nY1, $nX2, $nY2, $hPen = 0)
	__GDIPlus_PenDefCreate($hPen)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDrawLine", "handle", $hGraphics, "handle", $hPen, "float", $nX1, "float", $nY1, _
			"float", $nX2, "float", $nY2)
	__GDIPlus_PenDefDispose() ; does destroyed @error, @extended
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsDrawLine

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawPath($hGraphics, $hPath, $hPen = 0)
	__GDIPlus_PenDefCreate($hPen)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDrawPath", "handle", $hGraphics, "handle", $hPen, "handle", $hPath)
	__GDIPlus_PenDefDispose() ; does destroyed @error, @extended
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsDrawPath

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost, UEZ, jpm
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawPie($hGraphics, $nX, $nY, $nWidth, $nHeight, $fStartAngle, $fSweepAngle, $hPen = 0)
	__GDIPlus_PenDefCreate($hPen)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDrawPie", "handle", $hGraphics, "handle", $hPen, "float", $nX, "float", $nY, _
			"float", $nWidth, "float", $nHeight, "float", $fStartAngle, "float", $fSweepAngle)
	__GDIPlus_PenDefDispose() ; does destroyed @error, @extended
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsDrawPie

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost, UEZ, jpm
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawPolygon($hGraphics, $aPoints, $hPen = 0)
	Local $iCount = $aPoints[0][0]
	Local $tPoints = DllStructCreate("float[" & $iCount * 2 & "]")
	For $iI = 1 To $iCount
		DllStructSetData($tPoints, 1, $aPoints[$iI][0], (($iI - 1) * 2) + 1)
		DllStructSetData($tPoints, 1, $aPoints[$iI][1], (($iI - 1) * 2) + 2)
	Next

	__GDIPlus_PenDefCreate($hPen)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDrawPolygon", "handle", $hGraphics, "handle", $hPen, "struct*", $tPoints, "int", $iCount)
	__GDIPlus_PenDefDispose() ; does destroyed @error, @extended
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsDrawPolygon

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost, UEZ, jpm
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawRect($hGraphics, $nX, $nY, $nWidth, $nHeight, $hPen = 0)
	__GDIPlus_PenDefCreate($hPen)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDrawRectangle", "handle", $hGraphics, "handle", $hPen, "float", $nX, "float", $nY, _
			"float", $nWidth, "float", $nHeight)
	__GDIPlus_PenDefDispose() ; does destroyed @error, @extended
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsDrawRect

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawString($hGraphics, $sString, $nX, $nY, $sFont = "Arial", $fSize = 10, $iFormat = 0)
	Local $hBrush = _GDIPlus_BrushCreateSolid()
	Local $hFormat = _GDIPlus_StringFormatCreate($iFormat)
	Local $hFamily = _GDIPlus_FontFamilyCreate($sFont)
	Local $hFont = _GDIPlus_FontCreate($hFamily, $fSize)
	Local $tLayout = _GDIPlus_RectFCreate($nX, $nY, 0.0, 0.0)
	Local $aInfo = _GDIPlus_GraphicsMeasureString($hGraphics, $sString, $hFont, $tLayout, $hFormat)
	If @error Then Return SetError(@error, @extended, 0)
	Local $aResult = _GDIPlus_GraphicsDrawStringEx($hGraphics, $sString, $hFont, $aInfo[0], $hFormat, $hBrush)
	Local $iError = @error, $iExtended = @extended
	_GDIPlus_FontDispose($hFont)
	_GDIPlus_FontFamilyDispose($hFamily)
	_GDIPlus_StringFormatDispose($hFormat)
	_GDIPlus_BrushDispose($hBrush)
	Return SetError($iError, $iExtended, $aResult)
EndFunc   ;==>_GDIPlus_GraphicsDrawString

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawStringEx($hGraphics, $sString, $hFont, $tLayout, $hFormat, $hBrush)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDrawString", "handle", $hGraphics, "wstr", $sString, "int", -1, "handle", $hFont, _
			"struct*", $tLayout, "handle", $hFormat, "handle", $hBrush)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsDrawStringEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost, UEZ, jpm
; ===============================================================================================================================
Func _GDIPlus_GraphicsFillClosedCurve($hGraphics, $aPoints, $hBrush = 0)
	Local $iCount = $aPoints[0][0]
	Local $tPoints = DllStructCreate("float[" & $iCount * 2 & "]")
	For $iI = 1 To $iCount
		DllStructSetData($tPoints, 1, $aPoints[$iI][0], (($iI - 1) * 2) + 1)
		DllStructSetData($tPoints, 1, $aPoints[$iI][1], (($iI - 1) * 2) + 2)
	Next

	__GDIPlus_BrushDefCreate($hBrush)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipFillClosedCurve", "handle", $hGraphics, "handle", $hBrush, "struct*", $tPoints, "int", $iCount)
	__GDIPlus_BrushDefDispose()
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsFillClosedCurve

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: UEZ
; ===============================================================================================================================
Func _GDIPlus_GraphicsFillClosedCurve2($hGraphics, $aPoints, $nTension, $hBrush = 0, $iFillMode = 0)
	Local $iI, $iCount, $tPoints, $aResult
	__GDIPlus_BrushDefCreate($hBrush)
	$iCount = $aPoints[0][0]
	$tPoints = DllStructCreate("float[" & $iCount * 2 & "]")
	For $iI = 1 To $iCount
		DllStructSetData($tPoints, 1, $aPoints[$iI][0], (($iI - 1) * 2) + 1)
		DllStructSetData($tPoints, 1, $aPoints[$iI][1], (($iI - 1) * 2) + 2)
	Next
	$aResult = DllCall($__g_hGDIPDll, "int", "GdipFillClosedCurve2", "handle", $hGraphics, "handle", $hBrush, "struct*", $tPoints, "int", $iCount, "float", $nTension, "int", $iFillMode)
	__GDIPlus_BrushDefDispose()
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsFillClosedCurve2

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost, UEZ, jpm
; ===============================================================================================================================
Func _GDIPlus_GraphicsFillEllipse($hGraphics, $nX, $nY, $nWidth, $nHeight, $hBrush = 0)
	__GDIPlus_BrushDefCreate($hBrush)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipFillEllipse", "handle", $hGraphics, "handle", $hBrush, "float", $nX, "float", $nY, _
			"float", $nWidth, "float", $nHeight)
	__GDIPlus_BrushDefDispose()
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsFillEllipse

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_GraphicsFillPath($hGraphics, $hPath, $hBrush = 0)
	__GDIPlus_BrushDefCreate($hBrush)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipFillPath", "handle", $hGraphics, "handle", $hBrush, "handle", $hPath)
	__GDIPlus_BrushDefDispose()
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsFillPath

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost, UEZ, jpm
; ===============================================================================================================================
Func _GDIPlus_GraphicsFillPie($hGraphics, $nX, $nY, $nWidth, $nHeight, $fStartAngle, $fSweepAngle, $hBrush = 0)
	__GDIPlus_BrushDefCreate($hBrush)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipFillPie", "handle", $hGraphics, "handle", $hBrush, "float", $nX, "float", $nY, _
			"float", $nWidth, "float", $nHeight, "float", $fStartAngle, "float", $fSweepAngle)
	__GDIPlus_BrushDefDispose()
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsFillPie

; #FUNCTION# ====================================================================================================================
; Author ........:
; Modified.......: smashly, UEZ, jpm
; ===============================================================================================================================
Func _GDIPlus_GraphicsFillPolygon($hGraphics, $aPoints, $hBrush = 0)
	Local $iCount = $aPoints[0][0]
	Local $tPoints = DllStructCreate("float[" & $iCount * 2 & "]")
	For $iI = 1 To $iCount
		DllStructSetData($tPoints, 1, $aPoints[$iI][0], (($iI - 1) * 2) + 1)
		DllStructSetData($tPoints, 1, $aPoints[$iI][1], (($iI - 1) * 2) + 2)
	Next

	__GDIPlus_BrushDefCreate($hBrush)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipFillPolygon", "handle", $hGraphics, "handle", $hBrush, _
			"struct*", $tPoints, "int", $iCount, "int", "FillModeAlternate")
	__GDIPlus_BrushDefDispose()
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsFillPolygon

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost, UEZ, jpm
; ===============================================================================================================================
Func _GDIPlus_GraphicsFillRect($hGraphics, $nX, $nY, $nWidth, $nHeight, $hBrush = 0)
	__GDIPlus_BrushDefCreate($hBrush)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipFillRectangle", "handle", $hGraphics, "handle", $hBrush, "float", $nX, "float", $nY, _
			"float", $nWidth, "float", $nHeight)
	__GDIPlus_BrushDefDispose()
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsFillRect

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_GraphicsFillRegion($hGraphics, $hRegion, $hBrush = 0)
	__GDIPlus_BrushDefCreate($hBrush)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipFillRegion", "handle", $hGraphics, "handle", $hBrush, "handle", $hRegion)
	__GDIPlus_BrushDefDispose()
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsFillRegion

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_GraphicsGetCompositingMode($hGraphics)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetCompositingMode", "handle", $hGraphics, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	If $aResult[0] Then Return SetError(10, $aResult[0], -1)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_GraphicsGetCompositingMode

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_GraphicsGetCompositingQuality($hGraphics)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetCompositingQuality", "handle", $hGraphics, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	If $aResult[0] Then Return SetError(10, $aResult[0], -1)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_GraphicsGetCompositingQuality

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_GraphicsGetDC($hGraphics)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetDC", "handle", $hGraphics, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_GraphicsGetDC

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: UEZ
; ===============================================================================================================================
Func _GDIPlus_GraphicsGetInterpolationMode($hGraphics)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetInterpolationMode", "handle", $hGraphics, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	If $aResult[0] Then Return SetError(10, $aResult[0], -1)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_GraphicsGetInterpolationMode

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost, UEZ
; ===============================================================================================================================
Func _GDIPlus_GraphicsGetSmoothingMode($hGraphics)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetSmoothingMode", "handle", $hGraphics, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	If $aResult[0] Then Return SetError(10, $aResult[0], -1)

	Switch $aResult[2]
		Case $GDIP_SMOOTHINGMODE_NONE
			Return 0
		Case $GDIP_SMOOTHINGMODE_HIGHQUALITY, $GDIP_SMOOTHINGMODE_ANTIALIAS8X4
			Return 1
		Case $GDIP_SMOOTHINGMODE_ANTIALIAS8X8
			Return 2
		Case Else
			Return 0
	EndSwitch
EndFunc   ;==>_GDIPlus_GraphicsGetSmoothingMode

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_GraphicsGetTransform($hGraphics, $hMatrix)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetWorldTransform", "handle", $hGraphics, "handle", $hMatrix)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsGetTransform

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_GraphicsMeasureCharacterRanges($hGraphics, $sString, $hFont, $tLayout, $hStringFormat)
	Local $iCount = _GDIPlus_StringFormatGetMeasurableCharacterRangeCount($hStringFormat)
	If @error Then Return SetError(@error, @extended, 0)

	Local $tRegions = DllStructCreate("handle[" & $iCount & "]")
	Local $aRegions[$iCount + 1] = [$iCount]
	For $iI = 1 To $iCount
		$aRegions[$iI] = _GDIPlus_RegionCreate()
		DllStructSetData($tRegions, 1, $aRegions[$iI], $iI)
	Next

	DllCall($__g_hGDIPDll, "int", "GdipMeasureCharacterRanges", "handle", $hGraphics, "wstr", $sString, "int", -1, "hwnd", $hFont, "struct*", $tLayout, "handle", $hStringFormat, "int", $iCount, "struct*", $tRegions)
	Local $iError = @error, $iExtended = @extended
	If $iError Then
		For $iI = 1 To $iCount
			_GDIPlus_RegionDispose($aRegions[$iI])
		Next
		Return SetError($iError + 10, $iExtended, 0)
	EndIf

	Return $aRegions
EndFunc   ;==>_GDIPlus_GraphicsMeasureCharacterRanges

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_GraphicsMeasureString($hGraphics, $sString, $hFont, $tLayout, $hFormat)
	Local $tRECTF = DllStructCreate($tagGDIPRECTF)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipMeasureString", "handle", $hGraphics, "wstr", $sString, "int", -1, "handle", $hFont, _
			"struct*", $tLayout, "handle", $hFormat, "struct*", $tRECTF, "int*", 0, "int*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Local $aInfo[3]
	$aInfo[0] = $tRECTF
	$aInfo[1] = $aResult[8]
	$aInfo[2] = $aResult[9]
	Return $aInfo
EndFunc   ;==>_GDIPlus_GraphicsMeasureString

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_GraphicsReleaseDC($hGraphics, $hDC)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipReleaseDC", "handle", $hGraphics, "handle", $hDC)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_GraphicsReleaseDC

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_GraphicsResetClip($hGraphics)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipResetClip", "handle", $hGraphics)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsResetClip

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_GraphicsResetTransform($hGraphics)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipResetWorldTransform", "handle", $hGraphics)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsResetTransform

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_GraphicsRestore($hGraphics, $iState)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipRestoreGraphics", "handle", $hGraphics, "uint", $iState)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsRestore

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_GraphicsRotateTransform($hGraphics, $fAngle, $iOrder = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipRotateWorldTransform", "handle", $hGraphics, "float", $fAngle, "int", $iOrder)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsRotateTransform

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_GraphicsSave($hGraphics)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSaveGraphics", "handle", $hGraphics, "uint*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_GraphicsSave

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_GraphicsScaleTransform($hGraphics, $fScaleX, $fScaleY, $iOrder = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipScaleWorldTransform", "handle", $hGraphics, "float", $fScaleX, "float", $fScaleY, "int", $iOrder)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsScaleTransform

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_GraphicsSetClipPath($hGraphics, $hPath, $iCombineMode = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetClipPath", "handle", $hGraphics, "handle", $hPath, "int", $iCombineMode)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsSetClipPath

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus, jpm
; ===============================================================================================================================
Func _GDIPlus_GraphicsSetClipRect($hGraphics, $nX, $nY, $nWidth, $nHeight, $iCombineMode = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetClipRect", "handle", $hGraphics, "float", $nX, "float", $nY, "float", $nWidth, "float", $nHeight, "int", $iCombineMode)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsSetClipRect

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_GraphicsSetClipRegion($hGraphics, $hRegion, $iCombineMode = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetClipRegion", "handle", $hGraphics, "handle", $hRegion, "int", $iCombineMode)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsSetClipRegion

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_GraphicsSetCompositingMode($hGraphics, $iCompositionMode)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetCompositingMode", "handle", $hGraphics, "int", $iCompositionMode)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsSetCompositingMode

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_GraphicsSetCompositingQuality($hGraphics, $iCompositionQuality)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetCompositingQuality", "handle", $hGraphics, "int", $iCompositionQuality)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsSetCompositingQuality

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: UEZ
; ===============================================================================================================================
Func _GDIPlus_GraphicsSetInterpolationMode($hGraphics, $iInterpolationMode)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetInterpolationMode", "handle", $hGraphics, "int", $iInterpolationMode)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsSetInterpolationMode

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: UEZ
; ===============================================================================================================================
Func _GDIPlus_GraphicsSetPixelOffsetMode($hGraphics, $iPixelOffsetMode)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPixelOffsetMode", "handle", $hGraphics, "int", $iPixelOffsetMode)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsSetPixelOffsetMode

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost, UEZ
; ===============================================================================================================================
Func _GDIPlus_GraphicsSetSmoothingMode($hGraphics, $iSmooth)
	If $iSmooth < $GDIP_SMOOTHINGMODE_DEFAULT Or $iSmooth > $GDIP_SMOOTHINGMODE_ANTIALIAS8X8 Then $iSmooth = $GDIP_SMOOTHINGMODE_DEFAULT
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetSmoothingMode", "handle", $hGraphics, "int", $iSmooth)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsSetSmoothingMode

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: UEZ
; ===============================================================================================================================
Func _GDIPlus_GraphicsSetTextRenderingHint($hGraphics, $iTextRenderingHint)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetTextRenderingHint", "handle", $hGraphics, "int", $iTextRenderingHint)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsSetTextRenderingHint

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_GraphicsSetTransform($hGraphics, $hMatrix)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetWorldTransform", "handle", $hGraphics, "handle", $hMatrix)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsSetTransform

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_GraphicsTransformPoints($hGraphics, ByRef $aPoints, $iCoordSpaceTo = 0, $iCoordSpaceFrom = 1)
	Local $iCount = $aPoints[0][0]
	Local $tPoints = DllStructCreate("float[" & $iCount * 2 & "]")
	For $iI = 1 To $iCount
		DllStructSetData($tPoints, 1, $aPoints[$iI][0], ($iI - 1) * 2 + 1)
		DllStructSetData($tPoints, 1, $aPoints[$iI][1], ($iI - 1) * 2 + 2)
	Next

	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipTransformPoints", "handle", $hGraphics, "int", $iCoordSpaceTo, "int", $iCoordSpaceFrom, "struct*", $tPoints, "int", $iCount)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	For $iI = 1 To $iCount
		$aPoints[$iI][0] = DllStructGetData($tPoints, 1, ($iI - 1) * 2 + 1)
		$aPoints[$iI][1] = DllStructGetData($tPoints, 1, ($iI - 1) * 2 + 2)
	Next

	Return True
EndFunc   ;==>_GDIPlus_GraphicsTransformPoints

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_GraphicsTranslateTransform($hGraphics, $nDX, $nDY, $iOrder = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipTranslateWorldTransform", "handle", $hGraphics, "float", $nDX, "float", $nDY, "int", $iOrder)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_GraphicsTranslateTransform

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_HatchBrushCreate($iHatchStyle = 0, $iARGBForeground = 0xFFFFFFFF, $iARGBBackground = 0xFFFFFFFF)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateHatchBrush", "int", $iHatchStyle, "uint", $iARGBForeground, "uint", $iARGBBackground, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)
	Return $aResult[4]
EndFunc   ;==>_GDIPlus_HatchBrushCreate

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_HICONCreateFromBitmap($hBitmap)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateHICONFromBitmap", "handle", $hBitmap, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_HICONCreateFromBitmap

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: UEZ
; ===============================================================================================================================
Func _GDIPlus_ImageAttributesCreate()
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateImageAttributes", "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[1]
EndFunc   ;==>_GDIPlus_ImageAttributesCreate

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: UEZ
; ===============================================================================================================================
Func _GDIPlus_ImageAttributesDispose($hImageAttributes)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDisposeImageAttributes", "handle", $hImageAttributes)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_ImageAttributesDispose

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: UEZ
; ===============================================================================================================================
Func _GDIPlus_ImageAttributesSetColorKeys($hImageAttributes, $iColorAdjustType = 0, $bEnable = False, $iARGBLow = 0, $iARGBHigh = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetImageAttributesColorKeys", "handle", $hImageAttributes, "int", $iColorAdjustType, "int", $bEnable, "uint", $iARGBLow, "uint", $iARGBHigh)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_ImageAttributesSetColorKeys

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: UEZ
; ===============================================================================================================================
Func _GDIPlus_ImageAttributesSetColorMatrix($hImageAttributes, $iColorAdjustType = 0, $bEnable = False, $tClrMatrix = 0, $tGrayMatrix = 0, $iColorMatrixFlags = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetImageAttributesColorMatrix", "handle", $hImageAttributes, "int", $iColorAdjustType, "int", $bEnable, "struct*", $tClrMatrix, "struct*", $tGrayMatrix, "int", $iColorMatrixFlags)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_ImageAttributesSetColorMatrix

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_ImageDispose($hImage)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDisposeImage", "handle", $hImage)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_ImageDispose

; #FUNCTION# ====================================================================================================================
; Author ........: Yashied
; Modified.......: UEZ
; ===============================================================================================================================
Func _GDIPlus_ImageGetDimension($hImage)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetImageDimension", "handle", $hImage, "float*", 0, "float*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Local $aImgDim[2] = [$aResult[2], $aResult[3]]
	Return $aImgDim
EndFunc   ;==>_GDIPlus_ImageGetDimension

; #FUNCTION# ====================================================================================================================
; Author ........: rover
; Modified.......: jpm
; ===============================================================================================================================
Func _GDIPlus_ImageGetFlags($hImage)
	Local $aFlag[2] = [0, ""]
	If ($hImage = -1) Or (Not $hImage) Then Return SetError(11, 0, $aFlag)
	Local $aImageFlags[13][2] = _
			[["Pixel data Cacheable", $GDIP_IMAGEFLAGS_CACHING], _
			["Pixel data read-only", $GDIP_IMAGEFLAGS_READONLY], _
			["Pixel size in image", $GDIP_IMAGEFLAGS_HASREALPIXELSIZE], _
			["DPI info in image", $GDIP_IMAGEFLAGS_HASREALDPI], _
			["YCCK color space", $GDIP_IMAGEFLAGS_COLORSPACE_YCCK], _
			["YCBCR color space", $GDIP_IMAGEFLAGS_COLORSPACE_YCBCR], _
			["Grayscale image", $GDIP_IMAGEFLAGS_COLORSPACE_GRAY], _
			["CMYK color space", $GDIP_IMAGEFLAGS_COLORSPACE_CMYK], _
			["RGB color space", $GDIP_IMAGEFLAGS_COLORSPACE_RGB], _
			["Partially scalable", $GDIP_IMAGEFLAGS_PARTIALLYSCALABLE], _
			["Alpha values other than 0 (transparent) and 255 (opaque)", $GDIP_IMAGEFLAGS_HASTRANSLUCENT], _
			["Alpha values", $GDIP_IMAGEFLAGS_HASALPHA], _
			["Scalable", $GDIP_IMAGEFLAGS_SCALABLE]]
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetImageFlags", "handle", $hImage, "long*", 0)
	If @error Then Return SetError(@error, @extended, $aFlag)
	If $aResult[0] Then Return SetError(10, $aResult[0], $aFlag)
	If $aResult[2] = $GDIP_IMAGEFLAGS_NONE Then
		$aFlag[1] = "No pixel data"
		Return SetError(12, $aResult[2], $aFlag)
	EndIf

	$aFlag[0] = $aResult[2]
	For $i = 0 To 12
		If BitAND($aResult[2], $aImageFlags[$i][1]) = $aImageFlags[$i][1] Then
			If StringLen($aFlag[1]) Then $aFlag[1] &= "|"
			$aResult[2] -= $aImageFlags[$i][1]
			$aFlag[1] &= $aImageFlags[$i][0]
		EndIf
	Next
	Return $aFlag
EndFunc   ;==>_GDIPlus_ImageGetFlags

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_ImageGetGraphicsContext($hImage)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetImageGraphicsContext", "handle", $hImage, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_ImageGetGraphicsContext

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_ImageGetHeight($hImage)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetImageHeight", "handle", $hImage, "uint*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	If $aResult[0] Then Return SetError(10, $aResult[0], -1)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_ImageGetHeight

; #FUNCTION# ====================================================================================================================
; Author ........: rover
; Modified.......: jpm
; ===============================================================================================================================
Func _GDIPlus_ImageGetHorizontalResolution($hImage)
	If ($hImage = -1) Or (Not $hImage) Then Return SetError(11, 0, 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetImageHorizontalResolution", "handle", $hImage, "float*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return Round($aResult[2])
EndFunc   ;==>_GDIPlus_ImageGetHorizontalResolution

; #FUNCTION# ====================================================================================================================
; Author ........: rover
; Modified.......: jpm
; ===============================================================================================================================
Func _GDIPlus_ImageGetPixelFormat($hImage)
	Local $aFormat[2] = [0, ""]
	If ($hImage = -1) Or (Not $hImage) Then Return SetError(11, 0, $aFormat)
	Local $aPixelFormat[14][2] = _
			[["1 Bpp Indexed", $GDIP_PXF01INDEXED], _
			["4 Bpp Indexed", $GDIP_PXF04INDEXED], _
			["8 Bpp Indexed", $GDIP_PXF08INDEXED], _
			["16 Bpp Grayscale", $GDIP_PXF16GRAYSCALE], _
			["16 Bpp RGB 555", $GDIP_PXF16RGB555], _
			["16 Bpp RGB 565", $GDIP_PXF16RGB565], _
			["16 Bpp ARGB 1555", $GDIP_PXF16ARGB1555], _
			["24 Bpp RGB", $GDIP_PXF24RGB], _
			["32 Bpp RGB", $GDIP_PXF32RGB], _
			["32 Bpp ARGB", $GDIP_PXF32ARGB], _
			["32 Bpp PARGB", $GDIP_PXF32PARGB], _
			["48 Bpp RGB", $GDIP_PXF48RGB], _
			["64 Bpp ARGB", $GDIP_PXF64ARGB], _
			["64 Bpp PARGB", $GDIP_PXF64PARGB]]
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetImagePixelFormat", "handle", $hImage, "int*", 0)
	If @error Then Return SetError(@error, @extended, $aFormat)
	If $aResult[0] Then Return SetError(10, $aResult[0], $aFormat)

	For $i = 0 To 13
		If $aPixelFormat[$i][1] = $aResult[2] Then
			$aFormat[0] = $aPixelFormat[$i][1]
			$aFormat[1] = $aPixelFormat[$i][0]
			Return $aFormat
		EndIf
	Next

	Return SetError(12, 0, $aFormat)
EndFunc   ;==>_GDIPlus_ImageGetPixelFormat

; #FUNCTION# ====================================================================================================================
; Author ........: rover
; Modified.......: jpm
; ===============================================================================================================================
Func _GDIPlus_ImageGetRawFormat($hImage)
	Local $aGuid[2]
	If ($hImage = -1) Or (Not $hImage) Then Return SetError(11, 0, $aGuid)
	Local $aImageType[11][2] = _
			[["UNDEFINED", $GDIP_IMAGEFORMAT_UNDEFINED], _
			["MEMORYBMP", $GDIP_IMAGEFORMAT_MEMORYBMP], _
			["BMP", $GDIP_IMAGEFORMAT_BMP], _
			["EMF", $GDIP_IMAGEFORMAT_EMF], _
			["WMF", $GDIP_IMAGEFORMAT_WMF], _
			["JPEG", $GDIP_IMAGEFORMAT_JPEG], _
			["PNG", $GDIP_IMAGEFORMAT_PNG], _
			["GIF", $GDIP_IMAGEFORMAT_GIF], _
			["TIFF", $GDIP_IMAGEFORMAT_TIFF], _
			["EXIF", $GDIP_IMAGEFORMAT_EXIF], _
			["ICON", $GDIP_IMAGEFORMAT_ICON]]
	Local $tStruct = DllStructCreate("byte[16]")
	Local $aResult1 = DllCall($__g_hGDIPDll, "int", "GdipGetImageRawFormat", "handle", $hImage, "struct*", $tStruct)
	If @error Then Return SetError(@error, @extended, $aGuid)
	If $aResult1[0] Then Return SetError(10, $aResult1[0], $aGuid)
	Local $sResult2 = _WinAPI_StringFromGUID($aResult1[2])
	If @error Then Return SetError(@error + 20, @extended, $aGuid)
	If $sResult2 = "" Then Return SetError(12, 0, $aGuid)

	For $i = 0 To 10
		If $aImageType[$i][1] == $sResult2 Then
			$aGuid[0] = $aImageType[$i][1]
			$aGuid[1] = $aImageType[$i][0]
			Return $aGuid
		EndIf
	Next

	Return SetError(13, 0, $aGuid)
EndFunc   ;==>_GDIPlus_ImageGetRawFormat

; #FUNCTION# ====================================================================================================================
; Author ........: UEZ
; Modified.......: jpm
; ===============================================================================================================================
Func _GDIPlus_ImageGetThumbnail($hImage, $iWidth = 0, $iHeight = 0, $bKeepRatio = True, $hCallback = Null, $hCallbackData = Null)
	If $bKeepRatio Then
		Local $aImgDim = _GDIPlus_ImageGetDimension($hImage)
		If @error Then Return SetError(@error + 20, @extended, False)

		Local $f
		If $iWidth < 1 Or $iHeight < 1 Then
			$iWidth = 0
			$iHeight = 0
		Else
			If ($aImgDim[0] / $aImgDim[1]) > 1 Then
				$f = $aImgDim[0] / $iWidth
			Else
				$f = $aImgDim[1] / $iHeight
			EndIf
			$iWidth = Int($aImgDim[0] / $f)
			$iHeight = Int($aImgDim[1] / $f)
		EndIf
	EndIf

	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetImageThumbnail", "handle", $hImage, "uint", $iWidth, "uint", $iHeight, "ptr*", 0, "ptr", $hCallback, "ptr", $hCallbackData)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return $aResult[4]
EndFunc   ;==>_GDIPlus_ImageGetThumbnail

; #FUNCTION# ====================================================================================================================
; Author ........: rover
; Modified.......: jpm
; ===============================================================================================================================
Func _GDIPlus_ImageGetType($hImage)
	If ($hImage = -1) Or (Not $hImage) Then Return SetError(11, 0, -1)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetImageType", "handle", $hImage, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	If $aResult[0] Then Return SetError(10, $aResult[0], -1)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_ImageGetType

; #FUNCTION# ====================================================================================================================
; Author ........: rover
; Modified.......: jpm
; ===============================================================================================================================
Func _GDIPlus_ImageGetVerticalResolution($hImage)
	If ($hImage = -1) Or (Not $hImage) Then Return SetError(11, 0, 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetImageVerticalResolution", "handle", $hImage, "float*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return Round($aResult[2])
EndFunc   ;==>_GDIPlus_ImageGetVerticalResolution

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_ImageGetWidth($hImage)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetImageWidth", "handle", $hImage, "uint*", -1)
	If @error Then Return SetError(@error, @extended, -1)
	If $aResult[0] Then Return SetError(10, $aResult[0], -1)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_ImageGetWidth

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost/martin
; ===============================================================================================================================
Func _GDIPlus_ImageLoadFromFile($sFileName)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipLoadImageFromFile", "wstr", $sFileName, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_ImageLoadFromFile

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: UEZ
; ===============================================================================================================================
Func _GDIPlus_ImageLoadFromStream($pStream)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipLoadImageFromStream", "ptr", $pStream, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_ImageLoadFromStream

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: UEZ
; ===============================================================================================================================
Func _GDIPlus_ImageRotateFlip($hImage, $iRotateFlipType)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipImageRotateFlip", "handle", $hImage, "int", $iRotateFlipType)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_ImageRotateFlip

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_ImageSaveToFile($hImage, $sFileName)
	Local $sExt = __GDIPlus_ExtractFileExt($sFileName)
	Local $sCLSID = _GDIPlus_EncodersGetCLSID($sExt)
	If $sCLSID = "" Then Return SetError(-1, 0, False)

	Local $bRet = _GDIPlus_ImageSaveToFileEx($hImage, $sFileName, $sCLSID, 0)
	Return SetError(@error, @extended, $bRet)
EndFunc   ;==>_GDIPlus_ImageSaveToFile

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost, jpm
; ===============================================================================================================================
Func _GDIPlus_ImageSaveToFileEx($hImage, $sFileName, $sEncoder, $tParams = 0)
	Local $tGUID = _WinAPI_GUIDFromString($sEncoder)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSaveImageToFile", "handle", $hImage, "wstr", $sFileName, "struct*", $tGUID, "struct*", $tParams)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_ImageSaveToFileEx

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: UEZ, jpm
; ===============================================================================================================================
Func _GDIPlus_ImageSaveToStream($hImage, $pStream, $tEncoder, $tParams = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSaveImageToStream", "handle", $hImage, "ptr", $pStream, "struct*", $tEncoder, "struct*", $tParams)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_ImageSaveToStream

; #FUNCTION# ====================================================================================================================
; Author ........: UEZ
; Modified ......:
; ===============================================================================================================================
Func _GDIPlus_ImageScale($hImage, $iScaleW, $iScaleH, $iInterpolationMode = $GDIP_INTERPOLATIONMODE_HIGHQUALITYBICUBIC)
	Local $iWidth = _GDIPlus_ImageGetWidth($hImage) * $iScaleW
	If @error Then Return SetError(1, 0, 0)
	Local $iHeight = _GDIPlus_ImageGetHeight($hImage) * $iScaleH
	If @error Then Return SetError(2, 0, 0)
	Local $hBitmap = _GDIPlus_BitmapCreateFromScan0($iWidth, $iHeight)
	If @error Then Return SetError(3, 0, 0)
	Local $hBmpCtxt = _GDIPlus_ImageGetGraphicsContext($hBitmap)
	If @error Then
		_GDIPlus_BitmapDispose($hBitmap)
		Return SetError(4, 0, 0)
	EndIf
	_GDIPlus_GraphicsSetInterpolationMode($hBmpCtxt, $iInterpolationMode)
	If @error Then
		_GDIPlus_GraphicsDispose($hBmpCtxt)
		_GDIPlus_BitmapDispose($hBitmap)
		Return SetError(5, 0, 0)
	EndIf
	_GDIPlus_GraphicsDrawImageRect($hBmpCtxt, $hImage, 0, 0, $iWidth, $iHeight)
	If @error Then
		_GDIPlus_GraphicsDispose($hBmpCtxt)
		_GDIPlus_BitmapDispose($hBitmap)
		Return SetError(6, 0, 0)
	EndIf
	_GDIPlus_GraphicsDispose($hBmpCtxt)
	Return $hBitmap
EndFunc   ;==>_GDIPlus_ImageScale

; #FUNCTION# ====================================================================================================================
; Author ........: UEZ
; Modified ......:
; ===============================================================================================================================
Func _GDIPlus_ImageResize($hImage, $iNewWidth, $iNewHeight, $iInterpolationMode = $GDIP_INTERPOLATIONMODE_HIGHQUALITYBICUBIC)
	Local $hBitmap = _GDIPlus_BitmapCreateFromScan0($iNewWidth, $iNewHeight)
	If @error Then Return SetError(1, 0, 0)
	Local $hBmpCtxt = _GDIPlus_ImageGetGraphicsContext($hBitmap)
	If @error Then
		_GDIPlus_BitmapDispose($hBitmap)
		Return SetError(2, @extended, 0)
	EndIf
	_GDIPlus_GraphicsSetInterpolationMode($hBmpCtxt, $iInterpolationMode)
	If @error Then
		_GDIPlus_GraphicsDispose($hBmpCtxt)
		_GDIPlus_BitmapDispose($hBitmap)
		Return SetError(3, @extended, 0)
	EndIf
	_GDIPlus_GraphicsDrawImageRect($hBmpCtxt, $hImage, 0, 0, $iNewWidth, $iNewHeight)
	If @error Then
		_GDIPlus_GraphicsDispose($hBmpCtxt)
		_GDIPlus_BitmapDispose($hBitmap)
		Return SetError(4, @extended, 0)
	EndIf
	_GDIPlus_GraphicsDispose($hBmpCtxt)
	Return $hBitmap
EndFunc   ;==>_GDIPlus_ImageResize

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: UEZ
; ===============================================================================================================================
Func _GDIPlus_LineBrushCreate($nX1, $nY1, $nX2, $nY2, $iARGBClr1, $iARGBClr2, $iWrapMode = 0)
	Local $tPointF1, $tPointF2, $aResult
	$tPointF1 = DllStructCreate("float;float")
	$tPointF2 = DllStructCreate("float;float")
	DllStructSetData($tPointF1, 1, $nX1)
	DllStructSetData($tPointF1, 2, $nY1)
	DllStructSetData($tPointF2, 1, $nX2)
	DllStructSetData($tPointF2, 2, $nY2)
	$aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateLineBrush", "struct*", $tPointF1, "struct*", $tPointF2, "uint", $iARGBClr1, "uint", $iARGBClr2, "int", $iWrapMode, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[6]
EndFunc   ;==>_GDIPlus_LineBrushCreate

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_LineBrushCreateFromRect($tRECTF, $iARGBClr1, $iARGBClr2, $iGradientMode = 0, $iWrapMode = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateLineBrushFromRect", "struct*", $tRECTF, "uint", $iARGBClr1, "uint", $iARGBClr2, "int", $iGradientMode, "int", $iWrapMode, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[6]
EndFunc   ;==>_GDIPlus_LineBrushCreateFromRect

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_LineBrushCreateFromRectWithAngle($tRECTF, $iARGBClr1, $iARGBClr2, $fAngle, $bIsAngleScalable = True, $iWrapMode = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateLineBrushFromRectWithAngle", "struct*", $tRECTF, "uint", $iARGBClr1, "uint", $iARGBClr2, "float", $fAngle, "int", $bIsAngleScalable, "int", $iWrapMode, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[7]
EndFunc   ;==>_GDIPlus_LineBrushCreateFromRectWithAngle

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: UEZ
; ===============================================================================================================================
Func _GDIPlus_LineBrushGetColors($hLineGradientBrush)
	Local $tARGBs, $aARGBs[2], $aResult
	$tARGBs = DllStructCreate("uint;uint")
	$aResult = DllCall($__g_hGDIPDll, "uint", "GdipGetLineColors", "handle", $hLineGradientBrush, "struct*", $tARGBs)
	If @error Then Return SetError(@error, @extended, -1)
	If $aResult[0] Then Return SetError(10, $aResult[0], -1)

	$aARGBs[0] = DllStructGetData($tARGBs, 1)
	$aARGBs[1] = DllStructGetData($tARGBs, 2)
	Return $aARGBs
EndFunc   ;==>_GDIPlus_LineBrushGetColors

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus, jpm
; ===============================================================================================================================
Func _GDIPlus_LineBrushGetRect($hLineGradientBrush)
	Local $tRECTF = DllStructCreate($tagGDIPRECTF)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetLineRect", "handle", $hLineGradientBrush, "struct*", $tRECTF)
	If @error Then Return SetError(@error, @extended, -1)
	If $aResult[0] Then Return SetError(10, $aResult[0], -1)

	Local $aRectF[4]
	For $iI = 1 To 4
		$aRectF[$iI - 1] = DllStructGetData($tRECTF, $iI)
	Next
	Return $aRectF
EndFunc   ;==>_GDIPlus_LineBrushGetRect

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_LineBrushMultiplyTransform($hLineGradientBrush, $hMatrix, $iOrder = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipMultiplyLineTransform", "handle", $hLineGradientBrush, "handle", $hMatrix, "int", $iOrder)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_LineBrushMultiplyTransform

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_LineBrushResetTransform($hLineGradientBrush)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipResetLineTransform", "handle", $hLineGradientBrush)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_LineBrushResetTransform

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: UEZ
; ===============================================================================================================================
Func _GDIPlus_LineBrushSetBlend($hLineGradientBrush, $aBlends)
	Local $iI, $iCount, $tFactors, $tPositions, $aResult
	$iCount = $aBlends[0][0]
	$tFactors = DllStructCreate("float[" & $iCount & "]")
	$tPositions = DllStructCreate("float[" & $iCount & "]")
	For $iI = 1 To $iCount
		DllStructSetData($tFactors, 1, $aBlends[$iI][0], $iI)
		DllStructSetData($tPositions, 1, $aBlends[$iI][1], $iI)
	Next
	$aResult = DllCall($__g_hGDIPDll, "int", "GdipSetLineBlend", "handle", $hLineGradientBrush, "struct*", $tFactors, "struct*", $tPositions, "int", $iCount)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_LineBrushSetBlend

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: UEZ
; ===============================================================================================================================
Func _GDIPlus_LineBrushSetColors($hLineGradientBrush, $iARGBStart, $iARGBEnd)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetLineColors", "handle", $hLineGradientBrush, "uint", $iARGBStart, "uint", $iARGBEnd)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_LineBrushSetColors

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: UEZ
; ===============================================================================================================================
Func _GDIPlus_LineBrushSetGammaCorrection($hLineGradientBrush, $bUseGammaCorrection = True)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetLineGammaCorrection", "handle", $hLineGradientBrush, "int", $bUseGammaCorrection)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_LineBrushSetGammaCorrection

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_LineBrushSetLinearBlend($hLineGradientBrush, $fFocus, $fScale = 1)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetLineLinearBlend", "handle", $hLineGradientBrush, "float", $fFocus, "float", $fScale)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_LineBrushSetLinearBlend

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: UEZ
; ===============================================================================================================================
Func _GDIPlus_LineBrushSetPresetBlend($hLineGradientBrush, $aInterpolations)
	Local $iI, $iCount, $tColors, $tPositions, $aResult
	$iCount = $aInterpolations[0][0]
	$tColors = DllStructCreate("uint[" & $iCount & "]")
	$tPositions = DllStructCreate("float[" & $iCount & "]")
	For $iI = 1 To $iCount
		DllStructSetData($tColors, 1, $aInterpolations[$iI][0], $iI)
		DllStructSetData($tPositions, 1, $aInterpolations[$iI][1], $iI)
	Next
	$aResult = DllCall($__g_hGDIPDll, "int", "GdipSetLinePresetBlend", "handle", $hLineGradientBrush, "struct*", $tColors, "struct*", $tPositions, "int", $iCount)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_LineBrushSetPresetBlend

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: UEZ
; ===============================================================================================================================
Func _GDIPlus_LineBrushSetSigmaBlend($hLineGradientBrush, $fFocus, $fScale = 1)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetLineSigmaBlend", "handle", $hLineGradientBrush, "float", $fFocus, "float", $fScale)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_LineBrushSetSigmaBlend

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_LineBrushSetTransform($hLineGradientBrush, $hMatrix)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetLineTransform", "handle", $hLineGradientBrush, "handle", $hMatrix)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_LineBrushSetTransform

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_MatrixCreate()
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateMatrix", "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[1]
EndFunc   ;==>_GDIPlus_MatrixCreate

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus, jpm
; ===============================================================================================================================
Func _GDIPlus_MatrixClone($hMatrix)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCloneMatrix", "handle", $hMatrix, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_MatrixClone

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_MatrixDispose($hMatrix)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDeleteMatrix", "handle", $hMatrix)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_MatrixDispose

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_MatrixGetElements($hMatrix)
	Local $tElements = DllStructCreate("float[6]")
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetMatrixElements", "handle", $hMatrix, "struct*", $tElements)
	If @error Then Return SetError(@error, @extended, -1)
	If $aResult[0] Then Return SetError(10, $aResult[0], -1)

	Local $aElements[6]
	For $iI = 1 To 6
		$aElements[$iI - 1] = DllStructGetData($tElements, 1, $iI)
	Next
	Return $aElements
EndFunc   ;==>_GDIPlus_MatrixGetElements

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_MatrixInvert($hMatrix)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipInvertMatrix", "handle", $hMatrix)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_MatrixInvert

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_MatrixMultiply($hMatrix1, $hMatrix2, $iOrder = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipMultiplyMatrix", "handle", $hMatrix1, "handle", $hMatrix2, "int", $iOrder)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_MatrixMultiply

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_MatrixRotate($hMatrix, $fAngle, $bAppend = False)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipRotateMatrix", "handle", $hMatrix, "float", $fAngle, "int", $bAppend)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_MatrixRotate

; #FUNCTION# ====================================================================================================================
; Author ........: monoceres
; Modified.......:
; ===============================================================================================================================
Func _GDIPlus_MatrixScale($hMatrix, $fScaleX, $fScaleY, $bOrder = False)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipScaleMatrix", "handle", $hMatrix, "float", $fScaleX, "float", $fScaleY, "int", $bOrder)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_MatrixScale

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_MatrixSetElements($hMatrix, $nM11 = 1, $nM12 = 0, $nM21 = 0, $nM22 = 1, $nDX = 0, $nDY = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetMatrixElements", "handle", $hMatrix, "float", $nM11, "float", $nM12, _
			"float", $nM21, "float", $nM22, "float", $nDX, "float", $nDY)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_MatrixSetElements

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_MatrixShear($hMatrix, $fShearX, $fShearY, $iOrder = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipShearMatrix", "handle", $hMatrix, "float", $fShearX, "float", $fShearY, "int", $iOrder)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_MatrixShear

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_MatrixTransformPoints($hMatrix, ByRef $aPoints)
	Local $iCount = $aPoints[0][0]
	Local $tPoints = DllStructCreate("float[" & $iCount * 2 & "]")
	For $iI = 1 To $iCount
		DllStructSetData($tPoints, 1, $aPoints[$iI][0], ($iI - 1) * 2 + 1)
		DllStructSetData($tPoints, 1, $aPoints[$iI][1], ($iI - 1) * 2 + 2)
	Next

	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipTransformMatrixPoints", "handle", $hMatrix, "struct*", $tPoints, "int", $iCount)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	For $iI = 1 To $iCount
		$aPoints[$iI][0] = DllStructGetData($tPoints, 1, ($iI - 1) * 2 + 1)
		$aPoints[$iI][1] = DllStructGetData($tPoints, 1, ($iI - 1) * 2 + 2)
	Next

	Return True
EndFunc   ;==>_GDIPlus_MatrixTransformPoints

; #FUNCTION# ====================================================================================================================
; Author ........: monoceres
; Modified.......:
; ===============================================================================================================================
Func _GDIPlus_MatrixTranslate($hMatrix, $fOffsetX, $fOffsetY, $bAppend = False)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipTranslateMatrix", "handle", $hMatrix, "float", $fOffsetX, "float", $fOffsetY, "int", $bAppend)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_MatrixTranslate

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _GDIPlus_ParamAdd(ByRef $tParams, $sGUID, $iNbOfValues, $iType, $pValues)
	Local $iCount = DllStructGetData($tParams, "Count")
	Local $pGUID = DllStructGetPtr($tParams, "GUID") + ($iCount * _GDIPlus_ParamSize())
	Local $tParam = DllStructCreate($tagGDIPENCODERPARAM, $pGUID)
	_WinAPI_GUIDFromStringEx($sGUID, $pGUID)
	DllStructSetData($tParam, "Type", $iType)
	DllStructSetData($tParam, "NumberOfValues", $iNbOfValues)
	DllStructSetData($tParam, "Values", $pValues)

	DllStructSetData($tParams, "Count", $iCount + 1)
EndFunc   ;==>_GDIPlus_ParamAdd

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _GDIPlus_ParamInit($iCount)
	Local $sStruct = $tagGDIPENCODERPARAMS
	For $i = 2 To $iCount
		$sStruct &= ";struct;byte[16];ulong;ulong;ptr;endstruct"
	Next
	Return DllStructCreate($sStruct)
EndFunc   ;==>_GDIPlus_ParamInit

; #FUNCTION# ====================================================================================================================
; Author ........: jpm
; Modified.......:
; ===============================================================================================================================
Func _GDIPlus_ParamSize()
	Local $tParam = DllStructCreate($tagGDIPENCODERPARAM)

	Return DllStructGetSize($tParam)
EndFunc   ;==>_GDIPlus_ParamSize

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus, jpm
; ===============================================================================================================================
Func _GDIPlus_PathAddArc($hPath, $nX, $nY, $nWidth, $nHeight, $fStartAngle, $fSweepAngle)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipAddPathArc", "handle", $hPath, "float", $nX, "float", $nY, _
			"float", $nWidth, "float", $nHeight, "float", $fStartAngle, "float", $fSweepAngle)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathAddArc

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus, jpm
; ===============================================================================================================================
Func _GDIPlus_PathAddBezier($hPath, $nX1, $nY1, $nX2, $nY2, $nX3, $nY3, $nX4, $nY4)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipAddPathBezier", "handle", $hPath, "float", $nX1, "float", $nY1, "float", $nX2, "float", $nY2, "float", $nX3, "float", $nY3, "float", $nX4, "float", $nY4)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathAddBezier

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathAddClosedCurve($hPath, $aPoints)
	Local $iCount = $aPoints[0][0]
	Local $tPoints = DllStructCreate("float[" & $iCount * 2 & "]")
	For $iI = 1 To $iCount
		DllStructSetData($tPoints, 1, $aPoints[$iI][0], (($iI - 1) * 2) + 1)
		DllStructSetData($tPoints, 1, $aPoints[$iI][1], (($iI - 1) * 2) + 2)
	Next
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipAddPathClosedCurve", "handle", $hPath, "struct*", $tPoints, "int", $iCount)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathAddClosedCurve

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathAddClosedCurve2($hPath, $aPoints, $nTension = 0.5)
	Local $iCount = $aPoints[0][0]
	Local $tPoints = DllStructCreate("float[" & $iCount * 2 & "]")
	For $iI = 1 To $iCount
		DllStructSetData($tPoints, 1, $aPoints[$iI][0], (($iI - 1) * 2) + 1)
		DllStructSetData($tPoints, 1, $aPoints[$iI][1], (($iI - 1) * 2) + 2)
	Next
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipAddPathClosedCurve2", "handle", $hPath, "struct*", $tPoints, "int", $iCount, "float", $nTension)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathAddClosedCurve2

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathAddCurve($hPath, $aPoints)
	Local $iCount = $aPoints[0][0]
	Local $tPoints = DllStructCreate("float[" & $iCount * 2 & "]")
	For $iI = 1 To $iCount
		DllStructSetData($tPoints, 1, $aPoints[$iI][0], (($iI - 1) * 2) + 1)
		DllStructSetData($tPoints, 1, $aPoints[$iI][1], (($iI - 1) * 2) + 2)
	Next
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipAddPathCurve", "handle", $hPath, "struct*", $tPoints, "int", $iCount)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathAddCurve

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathAddCurve2($hPath, $aPoints, $nTension = 0.5)
	Local $iCount = $aPoints[0][0]
	Local $tPoints = DllStructCreate("float[" & $iCount * 2 & "]")
	For $iI = 1 To $iCount
		DllStructSetData($tPoints, 1, $aPoints[$iI][0], (($iI - 1) * 2) + 1)
		DllStructSetData($tPoints, 1, $aPoints[$iI][1], (($iI - 1) * 2) + 2)
	Next
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipAddPathCurve2", "handle", $hPath, "struct*", $tPoints, "int", $iCount, "float", $nTension)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathAddCurve2

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathAddCurve3($hPath, $aPoints, $iOffset, $iNumOfSegments, $nTension = 0.5)
	Local $iCount = $aPoints[0][0]
	Local $tPoints = DllStructCreate("float[" & $iCount * 2 & "]")
	For $iI = 1 To $iCount
		DllStructSetData($tPoints, 1, $aPoints[$iI][0], (($iI - 1) * 2) + 1)
		DllStructSetData($tPoints, 1, $aPoints[$iI][1], (($iI - 1) * 2) + 2)
	Next
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipAddPathCurve3", "handle", $hPath, "struct*", $tPoints, "int", $iCount, "int", $iOffset, "int", $iNumOfSegments, "float", $nTension)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathAddCurve3

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus, jpm
; ===============================================================================================================================
Func _GDIPlus_PathAddEllipse($hPath, $nX, $nY, $nWidth, $nHeight)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipAddPathEllipse", "handle", $hPath, "float", $nX, "float", $nY, "float", $nWidth, "float", $nHeight)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathAddEllipse

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus, jpm
; ===============================================================================================================================
Func _GDIPlus_PathAddLine($hPath, $nX1, $nY1, $nX2, $nY2)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipAddPathLine", "handle", $hPath, "float", $nX1, "float", $nY1, "float", $nX2, "float", $nY2)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathAddLine

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: UEZ
; ===============================================================================================================================
Func _GDIPlus_PathAddLine2($hPath, $aPoints)
	Local $iCount = $aPoints[0][0]
	Local $tPoints = DllStructCreate("float[" & $iCount * 2 & "]")
	For $iI = 1 To $iCount
		DllStructSetData($tPoints, 1, $aPoints[$iI][0], (($iI - 1) * 2) + 1)
		DllStructSetData($tPoints, 1, $aPoints[$iI][1], (($iI - 1) * 2) + 2)
	Next
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipAddPathLine2", "handle", $hPath, "struct*", $tPoints, "int", $iCount)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathAddLine2

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathAddPath($hPath1, $hPath2, $bConnect = True)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipAddPathPath", "handle", $hPath1, "handle", $hPath2, "int", $bConnect)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathAddPath

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus, jpm
; ===============================================================================================================================
Func _GDIPlus_PathAddPie($hPath, $nX, $nY, $nWidth, $nHeight, $fStartAngle, $fSweepAngle)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipAddPathPie", "handle", $hPath, "float", $nX, "float", $nY, _
			"float", $nWidth, "float", $nHeight, "float", $fStartAngle, "float", $fSweepAngle)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathAddPie

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathAddPolygon($hPath, $aPoints)
	Local $iCount = $aPoints[0][0]
	Local $tPoints = DllStructCreate("float[" & $iCount * 2 & "]")
	For $iI = 1 To $iCount
		DllStructSetData($tPoints, 1, $aPoints[$iI][0], (($iI - 1) * 2) + 1)
		DllStructSetData($tPoints, 1, $aPoints[$iI][1], (($iI - 1) * 2) + 2)
	Next
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipAddPathPolygon", "handle", $hPath, "struct*", $tPoints, "int", $iCount)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathAddPolygon

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus, jpm
; ===============================================================================================================================
Func _GDIPlus_PathAddRectangle($hPath, $nX, $nY, $nWidth, $nHeight)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipAddPathRectangle", "handle", $hPath, "float", $nX, "float", $nY, "float", $nWidth, "float", $nHeight)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathAddRectangle

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathAddString($hPath, $sString, $tLayout, $hFamily, $iStyle = 0, $fSize = 8.5, $hFormat = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipAddPathString", "handle", $hPath, "wstr", $sString, "int", -1, _
			"handle", $hFamily, "int", $iStyle, "float", $fSize, "struct*", $tLayout, "handle", $hFormat)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathAddString

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathBrushCreate($aPoints, $iWrapMode = 0)
	Local $iCount = $aPoints[0][0]
	Local $tPoints = DllStructCreate("float[" & $iCount * 2 & "]")
	For $iI = 1 To $iCount
		DllStructSetData($tPoints, 1, $aPoints[$iI][0], (($iI - 1) * 2) + 1)
		DllStructSetData($tPoints, 1, $aPoints[$iI][1], (($iI - 1) * 2) + 2)
	Next
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreatePathGradient", "struct*", $tPoints, "int", $iCount, "int", $iWrapMode, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[4]
EndFunc   ;==>_GDIPlus_PathBrushCreate

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathBrushCreateFromPath($hPath)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreatePathGradientFromPath", "handle", $hPath, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_PathBrushCreateFromPath

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathBrushGetCenterPoint($hPathGradientBrush)
	Local $tPointF = DllStructCreate("float;float")
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPathGradientCenterPoint", "handle", $hPathGradientBrush, "struct*", $tPointF)
	If @error Then Return SetError(@error, @extended, -1)
	If $aResult[0] Then Return SetError(10, $aResult[0], -1)

	Local $aPointF[2]
	$aPointF[0] = DllStructGetData($tPointF, 1)
	$aPointF[1] = DllStructGetData($tPointF, 2)
	Return $aPointF
EndFunc   ;==>_GDIPlus_PathBrushGetCenterPoint

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathBrushGetFocusScales($hPathGradientBrush)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPathGradientFocusScales", "handle", $hPathGradientBrush, "float*", 0, "float*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	If $aResult[0] Then Return SetError(10, $aResult[0], -1)

	Local $aScales[2]
	$aScales[0] = $aResult[2]
	$aScales[1] = $aResult[3]
	Return $aScales
EndFunc   ;==>_GDIPlus_PathBrushGetFocusScales

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathBrushGetPointCount($hPathGradientBrush)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPathGradientPointCount", "handle", $hPathGradientBrush, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	If $aResult[0] Then Return SetError(10, $aResult[0], -1)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_PathBrushGetPointCount

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathBrushGetRect($hPathGradientBrush)
	Local $tRECTF = DllStructCreate($tagGDIPRECTF)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPathGradientRect", "handle", $hPathGradientBrush, "struct*", $tRECTF)
	If @error Then Return SetError(@error, @extended, -1)
	If $aResult[0] Then Return SetError(10, $aResult[0], -1)

	Local $aRectF[4]
	For $iI = 1 To 4
		$aRectF[$iI - 1] = DllStructGetData($tRECTF, $iI)
	Next
	Return $aRectF
EndFunc   ;==>_GDIPlus_PathBrushGetRect

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathBrushGetWrapMode($hPathGradientBrush)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPathGradientWrapMode", "handle", $hPathGradientBrush, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	If $aResult[0] Then Return SetError(10, $aResult[0], -1)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_PathBrushGetWrapMode

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathBrushMultiplyTransform($hPathGradientBrush, $hMatrix, $iOrder = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipMultiplyPathGradientTransform", "handle", $hPathGradientBrush, "handle", $hMatrix, "int", $iOrder)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathBrushMultiplyTransform

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathBrushResetTransform($hPathGradientBrush)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipResetPathGradientTransform", "handle", $hPathGradientBrush)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathBrushResetTransform

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathBrushSetBlend($hPathGradientBrush, $aBlends)
	Local $iCount = $aBlends[0][0]
	Local $tFactors = DllStructCreate("float[" & $iCount & "]")
	Local $tPositions = DllStructCreate("float[" & $iCount & "]")
	For $iI = 1 To $iCount
		DllStructSetData($tFactors, 1, $aBlends[$iI][0], $iI)
		DllStructSetData($tPositions, 1, $aBlends[$iI][1], $iI)
	Next
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPathGradientBlend", "handle", $hPathGradientBrush, "struct*", $tFactors, "struct*", $tPositions, "int", $iCount)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathBrushSetBlend

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathBrushSetCenterColor($hPathGradientBrush, $iARGB)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPathGradientCenterColor", "handle", $hPathGradientBrush, "uint", $iARGB)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathBrushSetCenterColor

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathBrushSetCenterPoint($hPathGradientBrush, $nX, $nY)
	Local $tPointF = DllStructCreate("float;float")
	DllStructSetData($tPointF, 1, $nX)
	DllStructSetData($tPointF, 2, $nY)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPathGradientCenterPoint", "handle", $hPathGradientBrush, "struct*", $tPointF)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathBrushSetCenterPoint

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathBrushSetFocusScales($hPathGradientBrush, $fScaleX, $fScaleY)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPathGradientFocusScales", "handle", $hPathGradientBrush, "float", $fScaleX, "float", $fScaleY)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathBrushSetFocusScales

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathBrushSetGammaCorrection($hPathGradientBrush, $bUseGammaCorrection)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPathGradientGammaCorrection", "handle", $hPathGradientBrush, "int", $bUseGammaCorrection)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathBrushSetGammaCorrection

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathBrushSetLinearBlend($hPathGradientBrush, $fFocus, $fScale = 1)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPathGradientLinearBlend", "handle", $hPathGradientBrush, "float", $fFocus, "float", $fScale)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathBrushSetLinearBlend

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathBrushSetPresetBlend($hPathGradientBrush, $aInterpolations)
	Local $iCount = $aInterpolations[0][0]
	Local $tColors = DllStructCreate("uint[" & $iCount & "]")
	Local $tPositions = DllStructCreate("float[" & $iCount & "]")
	For $iI = 1 To $iCount
		DllStructSetData($tColors, 1, $aInterpolations[$iI][0], $iI)
		DllStructSetData($tPositions, 1, $aInterpolations[$iI][1], $iI)
	Next
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPathGradientPresetBlend", "handle", $hPathGradientBrush, "struct*", $tColors, "struct*", $tPositions, "int", $iCount)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathBrushSetPresetBlend

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathBrushSetSigmaBlend($hPathGradientBrush, $fFocus, $fScale = 1)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPathGradientSigmaBlend", "handle", $hPathGradientBrush, "float", $fFocus, "float", $fScale)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathBrushSetSigmaBlend

; #FUNCTION# ====================================================================================================================
; Author ........: Eukalyptus
; Modified.......:
; ===============================================================================================================================
Func _GDIPlus_PathBrushSetSurroundColor($hPathGradientBrush, $iARGB)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPathGradientSurroundColorsWithCount", "handle", $hPathGradientBrush, "uint*", $iARGB, "int*", 1)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathBrushSetSurroundColor

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathBrushSetSurroundColorsWithCount($hPathGradientBrush, $aColors)
	Local $iCount = $aColors[0]
	Local $iColors = _GDIPlus_PathBrushGetPointCount($hPathGradientBrush)
	If $iColors < $iCount Then $iCount = $iColors
	Local $tColors = DllStructCreate("uint[" & $iCount & "]")
	For $iI = 1 To $iCount
		DllStructSetData($tColors, 1, $aColors[$iI], $iI)
	Next
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPathGradientSurroundColorsWithCount", "handle", $hPathGradientBrush, "struct*", $tColors, "int*", $iCount)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[3]
EndFunc   ;==>_GDIPlus_PathBrushSetSurroundColorsWithCount

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathBrushSetTransform($hPathGradientBrush, $hMatrix)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPathGradientTransform", "handle", $hPathGradientBrush, "handle", $hMatrix)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathBrushSetTransform

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathBrushSetWrapMode($hPathGradientBrush, $iWrapMode)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPathGradientWrapMode", "handle", $hPathGradientBrush, "int", $iWrapMode)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathBrushSetWrapMode

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathClone($hPath)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipClonePath", "handle", $hPath, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_PathClone

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathCloseFigure($hPath)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipClosePathFigure", "handle", $hPath)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathCloseFigure

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathCreate($iFillMode = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreatePath", "int", $iFillMode, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_PathCreate

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathCreate2($aPathData, $iFillMode = 0)
	Local $iCount = $aPathData[0][0]
	Local $tPoints = DllStructCreate("float[" & $iCount * 2 & "]")
	Local $tTypes = DllStructCreate("byte[" & $iCount & "]")
	For $iI = 1 To $iCount
		DllStructSetData($tPoints, 1, $aPathData[$iI][0], (($iI - 1) * 2) + 1)
		DllStructSetData($tPoints, 1, $aPathData[$iI][1], (($iI - 1) * 2) + 2)
		DllStructSetData($tTypes, 1, $aPathData[$iI][2], $iI)
	Next
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreatePath2", "struct*", $tPoints, "struct*", $tTypes, "int", $iCount, "int", $iFillMode, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[5]
EndFunc   ;==>_GDIPlus_PathCreate2

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathDispose($hPath)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDeletePath", "handle", $hPath)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathDispose

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathFlatten($hPath, $fFlatness = 0.25, $hMatrix = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipFlattenPath", "handle", $hPath, "handle", $hMatrix, "float", $fFlatness)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathFlatten

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathGetData($hPath)
	Local $iCount = _GDIPlus_PathGetPointCount($hPath)
	Local $tPathData = DllStructCreate("int Count; ptr Points; ptr Types;")
	Local $tPoints = DllStructCreate("float[" & $iCount * 2 & "]")
	Local $tTypes = DllStructCreate("byte[" & $iCount & "]")
	DllStructSetData($tPathData, "Count", $iCount)
	DllStructSetData($tPathData, "Points", DllStructGetPtr($tPoints))
	DllStructSetData($tPathData, "Types", DllStructGetPtr($tTypes))

	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPathData", "handle", $hPath, "struct*", $tPathData)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError($aResult[0], $aResult[0], -1)

	Local $aData[$iCount + 1][3]
	$aData[0][0] = $iCount
	For $iI = 1 To $iCount
		$aData[$iI][0] = DllStructGetData($tPoints, 1, (($iI - 1) * 2) + 1)
		$aData[$iI][1] = DllStructGetData($tPoints, 1, (($iI - 1) * 2) + 2)
		$aData[$iI][2] = DllStructGetData($tTypes, 1, $iI)
	Next
	Return $aData
EndFunc   ;==>_GDIPlus_PathGetData

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathGetFillMode($hPath)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPathFillMode", "handle", $hPath, "int*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_PathGetFillMode

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathGetLastPoint($hPath)
	Local $tPointF = DllStructCreate("float;float")
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPathLastPoint", "handle", $hPath, "struct*", $tPointF)
	If @error Then Return SetError(@error, @extended, -1)
	If $aResult[0] Then Return SetError(10, $aResult[0], -1)

	Local $aPointF[2]
	$aPointF[0] = DllStructGetData($tPointF, 1)
	$aPointF[1] = DllStructGetData($tPointF, 2)
	Return $aPointF
EndFunc   ;==>_GDIPlus_PathGetLastPoint

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathGetPointCount($hPath)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPointCount", "handle", $hPath, "int*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_PathGetPointCount

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathGetPoints($hPath)
	Local $iI, $iCount, $tPoints, $aPoints[1][1], $aResult
	$iCount = _GDIPlus_PathGetPointCount($hPath)
	If @error Then Return SetError(@error + 10, @extended, -1)

	$tPoints = DllStructCreate("float[" & $iCount * 2 & "]")
	$aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPathPoints", "handle", $hPath, "struct*", $tPoints, "int", $iCount)
	If @error Then Return SetError(@error, @extended, -1)
	If $aResult[0] Then Return SetError(10, $aResult[0], -1)

	Local $aPoints[$iCount + 1][2]
	$aPoints[0][0] = $iCount
	For $iI = 1 To $iCount
		$aPoints[$iI][0] = DllStructGetData($tPoints, 1, (($iI - 1) * 2) + 1)
		$aPoints[$iI][1] = DllStructGetData($tPoints, 1, (($iI - 1) * 2) + 2)
	Next
	Return $aPoints
EndFunc   ;==>_GDIPlus_PathGetPoints

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathGetWorldBounds($hPath, $hMatrix = 0, $hPen = 0)
	Local $tRECTF = DllStructCreate($tagGDIPRECTF)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPathWorldBounds", "handle", $hPath, "struct*", $tRECTF, "handle", $hMatrix, "handle", $hPen)
	If @error Then Return SetError(@error, @extended, -1)
	If $aResult[0] Then Return SetError(10, $aResult[0], -1)

	Local $aRectF[4]
	For $iI = 1 To 4
		$aRectF[$iI - 1] = DllStructGetData($tRECTF, $iI)
	Next
	Return $aRectF
EndFunc   ;==>_GDIPlus_PathGetWorldBounds

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathIsOutlineVisiblePoint($hPath, $nX, $nY, $hPen = 0, $hGraphics = 0)
	__GDIPlus_PenDefCreate($hPen)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipIsOutlineVisiblePathPoint", "handle", $hPath, "float", $nX, "float", $nY, "handle", $hPen, "handle", $hGraphics, "int*", 0)
	__GDIPlus_PenDefDispose() ; does destroyed @error, @extended
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return $aResult[6] <> 0
EndFunc   ;==>_GDIPlus_PathIsOutlineVisiblePoint

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus, jpm
; ===============================================================================================================================
Func _GDIPlus_PathIsVisiblePoint($hPath, $nX, $nY, $hGraphics = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipIsVisiblePathPoint", "handle", $hPath, "float", $nX, "float", $nY, "handle", $hGraphics, "int*", 0)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return $aResult[5] <> 0
EndFunc   ;==>_GDIPlus_PathIsVisiblePoint

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathIterCreate($hPath)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreatePathIter", "handle*", 0, "handle", $hPath)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[1]
EndFunc   ;==>_GDIPlus_PathIterCreate

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathIterDispose($hPathIter)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDeletePathIter", "handle", $hPathIter)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathIterDispose

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathIterGetSubpathCount($hPathIter)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipPathIterGetSubpathCount", "handle", $hPathIter, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	If $aResult[0] Then Return SetError(10, $aResult[0], -1)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_PathIterGetSubpathCount

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathIterNextMarkerPath($hPathIter, $hPath)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipPathIterNextMarkerPath", "handle", $hPathIter, "int*", 0, "handle", $hPath)
	If @error Then Return SetError(@error, @extended, -1)
	If $aResult[0] Then Return SetError(10, $aResult[0], -1)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_PathIterNextMarkerPath

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathIterNextSubpathPath($hPathIter, $hPath)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipPathIterNextSubpathPath", "handle", $hPathIter, "int*", 0, "handle", $hPath, "bool*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	If $aResult[0] Then Return SetError(10, $aResult[0], -1)

	Local $aReturn[2]
	$aReturn[0] = $aResult[2]
	$aReturn[1] = $aResult[4]
	Return $aReturn
EndFunc   ;==>_GDIPlus_PathIterNextSubpathPath

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathIterRewind($hPathIter)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipPathIterRewind", "handle", $hPathIter)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathIterRewind

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathReset($hPath)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipResetPath", "handle", $hPath)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathReset

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathReverse($hPath)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipReversePath", "handle", $hPath)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathReverse

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathSetFillMode($hPath, $iFillMode)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPathFillMode", "handle", $hPath, "int", $iFillMode)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathSetFillMode

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; Example .......: No
; ===============================================================================================================================
Func _GDIPlus_PathSetMarker($hPath)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPathMarker", "handle", $hPath)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathSetMarker

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathStartFigure($hPath)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipStartPathFigure", "handle", $hPath)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathStartFigure

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathTransform($hPath, $hMatrix)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipTransformPath", "handle", $hPath, "handle", $hMatrix)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathTransform

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathWarp($hPath, $hMatrix, $aPoints, $nX, $nY, $nWidth, $nHeight, $iWarpMode = 0, $fFlatness = 0.25)
	Local $iCount = $aPoints[0][0]
	If $iCount <> 3 And $iCount <> 4 Then Return SetError(11, 0, False)

	Local $tPoints = DllStructCreate("float[" & $iCount * 2 & "]")
	For $iI = 1 To $iCount
		DllStructSetData($tPoints, 1, $aPoints[$iI][0], ($iI - 1) * 2 + 1)
		DllStructSetData($tPoints, 1, $aPoints[$iI][1], ($iI - 1) * 2 + 2)
	Next

	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipWarpPath", "handle", $hPath, "handle", $hMatrix, "struct*", $tPoints, "int", $iCount, _
			"float", $nX, "float", $nY, "float", $nWidth, "float", $nHeight, "int", $iWarpMode, "float", $fFlatness)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathWarp

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathWiden($hPath, $hPen, $hMatrix = 0, $fFlatness = 0.25)
	__GDIPlus_PenDefCreate($hPen)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipWidenPath", "handle", $hPath, "handle", $hPen, "handle", $hMatrix, "float", $fFlatness)
	__GDIPlus_PenDefDispose() ; does destroyed @error, @extended
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathWiden

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PathWindingModeOutline($hPath, $hMatrix = 0, $fFlatness = 0.25)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipWindingModeOutline", "handle", $hPath, "handle", $hMatrix, "float", $fFlatness)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PathWindingModeOutline

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_PenCreate($iARGB = 0xFF000000, $nWidth = 1, $iUnit = 2)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreatePen1", "dword", $iARGB, "float", $nWidth, "int", $iUnit, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[4]
EndFunc   ;==>_GDIPlus_PenCreate

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PenCreate2($hBrush, $nWidth = 1, $iUnit = 2)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreatePen2", "handle", $hBrush, "float", $nWidth, "int", $iUnit, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[4]
EndFunc   ;==>_GDIPlus_PenCreate2

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_PenDispose($hPen)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDeletePen", "handle", $hPen)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PenDispose

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_PenGetAlignment($hPen)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPenMode", "handle", $hPen, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	If $aResult[0] Then Return SetError(10, $aResult[0], -1)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_PenGetAlignment

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_PenGetColor($hPen)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPenColor", "handle", $hPen, "dword*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	If $aResult[0] Then Return SetError(10, $aResult[0], -1)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_PenGetColor

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_PenGetCustomEndCap($hPen)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPenCustomEndCap", "handle", $hPen, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_PenGetCustomEndCap

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_PenGetDashCap($hPen)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPenDashCap197819", "handle", $hPen, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	If $aResult[0] Then Return SetError(10, $aResult[0], -1)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_PenGetDashCap

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_PenGetDashStyle($hPen)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPenDashStyle", "handle", $hPen, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	If $aResult[0] Then Return SetError(10, $aResult[0], -1)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_PenGetDashStyle

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_PenGetEndCap($hPen)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPenEndCap", "handle", $hPen, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	If $aResult[0] Then Return SetError(10, $aResult[0], -1)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_PenGetEndCap

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PenGetMiterLimit($hPen)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPenMiterLimit", "handle", $hPen, "float*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	If $aResult[0] Then Return SetError(10, $aResult[0], -1)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_PenGetMiterLimit

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_PenGetWidth($hPen)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPenWidth", "handle", $hPen, "float*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	If $aResult[0] Then Return SetError(10, $aResult[0], -1)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_PenGetWidth

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_PenSetAlignment($hPen, $iAlignment = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPenMode", "handle", $hPen, "int", $iAlignment)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PenSetAlignment

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_PenSetColor($hPen, $iARGB)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPenColor", "handle", $hPen, "dword", $iARGB)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PenSetColor

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_PenSetCustomEndCap($hPen, $hEndCap)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPenCustomEndCap", "handle", $hPen, "handle", $hEndCap)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PenSetCustomEndCap

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_PenSetDashCap($hPen, $iDash = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPenDashCap197819", "handle", $hPen, "int", $iDash)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PenSetDashCap

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_PenSetDashStyle($hPen, $iStyle = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPenDashStyle", "handle", $hPen, "int", $iStyle)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PenSetDashStyle

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_PenSetEndCap($hPen, $iEndCap)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPenEndCap", "handle", $hPen, "int", $iEndCap)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PenSetEndCap

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; Example .......; No
; ===============================================================================================================================
Func _GDIPlus_PenSetLineCap($hPen, $iStartCap, $iEndCap, $iDashCap)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPenLineCap197819", "handle", $hPen, "int", $iStartCap, "int", $iEndCap, "int", $iDashCap)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PenSetLineCap

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PenSetLineJoin($hPen, $iLineJoin)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPenLineJoin", "handle", $hPen, "int", $iLineJoin)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PenSetLineJoin

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PenSetMiterLimit($hPen, $fMiterLimit)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPenMiterLimit", "handle", $hPen, "float", $fMiterLimit)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PenSetMiterLimit

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_PenSetStartCap($hPen, $iLineCap)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPenStartCap", "handle", $hPen, "int", $iLineCap)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PenSetStartCap

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_PenSetWidth($hPen, $fWidth)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPenWidth", "handle", $hPen, "float", $fWidth)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_PenSetWidth

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GDIPlus_RectFCreate($nX = 0, $nY = 0, $nWidth = 0, $nHeight = 0)
	Local $tRECTF = DllStructCreate($tagGDIPRECTF)
	DllStructSetData($tRECTF, "X", $nX)
	DllStructSetData($tRECTF, "Y", $nY)
	DllStructSetData($tRECTF, "Width", $nWidth)
	DllStructSetData($tRECTF, "Height", $nHeight)
	Return $tRECTF
EndFunc   ;==>_GDIPlus_RectFCreate

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_RegionClone($hRegion)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCloneRegion", "handle", $hRegion, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_RegionClone

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_RegionCombinePath($hRegion, $hPath, $iCombineMode = 2)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCombineRegionPath", "handle", $hRegion, "handle", $hPath, "int", $iCombineMode)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_RegionCombinePath

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_RegionCombineRect($hRegion, $nX, $nY, $nWidth, $nHeight, $iCombineMode = 2)
	Local $tRECTF = _GDIPlus_RectFCreate($nX, $nY, $nWidth, $nHeight)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCombineRegionRect", "handle", $hRegion, "struct*", $tRECTF, "int", $iCombineMode)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_RegionCombineRect

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_RegionCombineRegion($hRegionDst, $hRegionSrc, $iCombineMode = 2)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCombineRegionRegion", "handle", $hRegionDst, "handle", $hRegionSrc, "int", $iCombineMode)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_RegionCombineRegion

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_RegionCreate()
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateRegion", "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[1]
EndFunc   ;==>_GDIPlus_RegionCreate

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_RegionCreateFromPath($hPath)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateRegionPath", "handle", $hPath, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_RegionCreateFromPath

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_RegionCreateFromRect($nX, $nY, $nWidth, $nHeight)
	Local $tRECTF = _GDIPlus_RectFCreate($nX, $nY, $nWidth, $nHeight)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateRegionRect", "struct*", $tRECTF, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_RegionCreateFromRect

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_RegionDispose($hRegion)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDeleteRegion", "handle", $hRegion)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_RegionDispose

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_RegionGetBounds($hRegion, $hGraphics)
	Local $tRECTF = DllStructCreate($tagGDIPRECTF)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetRegionBounds", "handle", $hRegion, "handle", $hGraphics, "struct*", $tRECTF)
	If @error Then Return SetError(@error, @extended, -1)
	If $aResult[0] Then Return SetError(10, $aResult[0], -1)

	Local $aBounds[4]
	For $iI = 1 To 4
		$aBounds[$iI - 1] = DllStructGetData($tRECTF, $iI)
	Next
	Return $aBounds
EndFunc   ;==>_GDIPlus_RegionGetBounds

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_RegionGetHRgn($hRegion, $hGraphics = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetRegionHRgn", "handle", $hRegion, "handle", $hGraphics, "handle*", 0)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return $aResult[3]
EndFunc   ;==>_GDIPlus_RegionGetHRgn

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_RegionTransform($hRegion, $hMatrix)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipTransformRegion", "handle", $hRegion, "handle", $hMatrix)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_RegionTransform

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_RegionTranslate($hRegion, $nDX, $nDY)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipTranslateRegion", "handle", $hRegion, "float", $nDX, "float", $nDY)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_RegionTranslate

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GDIPlus_Shutdown()
	If $__g_hGDIPDll = 0 Then Return SetError(-1, -1, False)

	$__g_iGDIPRef -= 1
	If $__g_iGDIPRef = 0 Then
		DllCall($__g_hGDIPDll, "none", "GdiplusShutdown", "ulong_ptr", $__g_iGDIPToken)
		DllClose($__g_hGDIPDll)
		$__g_hGDIPDll = 0
	EndIf
	Return True
EndFunc   ;==>_GDIPlus_Shutdown

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost, jpm, UEZ
; ===============================================================================================================================
Func _GDIPlus_Startup($sGDIPDLL = Default, $bRetDllHandle = False)
	$__g_iGDIPRef += 1
	If $__g_iGDIPRef > 1 Then Return True

	If $sGDIPDLL = Default Then $sGDIPDLL = "gdiplus.dll"

	$__g_hGDIPDll = DllOpen($sGDIPDLL)
	If $__g_hGDIPDll = -1 Then
		$__g_iGDIPRef = 0
		Return SetError(1, 2, False)
	EndIf

	Local $sVer = FileGetVersion($sGDIPDLL)
	$sVer = StringSplit($sVer, ".")
	If $sVer[1] > 5 Then $__g_bGDIP_V1_0 = False

	Local $tInput = DllStructCreate($tagGDIPSTARTUPINPUT)
	Local $tToken = DllStructCreate("ulong_ptr Data")
	DllStructSetData($tInput, "Version", 1)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdiplusStartup", "struct*", $tToken, "struct*", $tInput, "ptr", 0)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	$__g_iGDIPToken = DllStructGetData($tToken, "Data")
	If $bRetDllHandle Then Return $__g_hGDIPDll
	Return SetExtended($sVer[1], True)
EndFunc   ;==>_GDIPlus_Startup

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_StringFormatCreate($iFormat = 0, $iLangID = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateStringFormat", "int", $iFormat, "word", $iLangID, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[3]
EndFunc   ;==>_GDIPlus_StringFormatCreate

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GDIPlus_StringFormatDispose($hFormat)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDeleteStringFormat", "handle", $hFormat)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_StringFormatDispose

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_StringFormatGetMeasurableCharacterRangeCount($hStringFormat)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetStringFormatMeasurableCharacterRangeCount", "handle", $hStringFormat, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	If $aResult[0] Then Return SetError(10, $aResult[0], -1)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_StringFormatGetMeasurableCharacterRangeCount

; #FUNCTION# ====================================================================================================================
; Author ........: Andreas Karlsson (monoceres)
; Modified.......:
; ===============================================================================================================================
Func _GDIPlus_StringFormatSetAlign($hStringFormat, $iFlag)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetStringFormatAlign", "handle", $hStringFormat, "int", $iFlag)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_StringFormatSetAlign

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_StringFormatSetLineAlign($hStringFormat, $iStringAlign)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetStringFormatLineAlign", "handle", $hStringFormat, "int", $iStringAlign)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_StringFormatSetLineAlign

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_StringFormatSetMeasurableCharacterRanges($hStringFormat, $aRanges)
	Local $iCount = $aRanges[0][0]
	Local $tCharacterRanges = DllStructCreate("int[" & $iCount * 2 & "]")
	For $iI = 1 To $iCount
		DllStructSetData($tCharacterRanges, 1, $aRanges[$iI][0], (($iI - 1) * 2) + 1)
		DllStructSetData($tCharacterRanges, 1, $aRanges[$iI][1], (($iI - 1) * 2) + 2)
	Next
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetStringFormatMeasurableCharacterRanges", "handle", $hStringFormat, "int", $iCount, "struct*", $tCharacterRanges)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_StringFormatSetMeasurableCharacterRanges

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: UEZ
; ===============================================================================================================================
Func _GDIPlus_TextureCreate($hImage, $iWrapMode = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateTexture", "handle", $hImage, "int", $iWrapMode, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[3]
EndFunc   ;==>_GDIPlus_TextureCreate

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: UEZ
; ===============================================================================================================================
Func _GDIPlus_TextureCreate2($hImage, $nX, $nY, $nWidth, $nHeight, $iWrapMode = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateTexture2", "handle", $hImage, "int", $iWrapMode, "float", $nX, "float", $nY, "float", $nWidth, "float", $nHeight, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[7]
EndFunc   ;==>_GDIPlus_TextureCreate2

; #FUNCTION# ====================================================================================================================
; Author ........: Authenticity
; Modified.......: Eukalyptus
; ===============================================================================================================================
Func _GDIPlus_TextureCreateIA($hImage, $nX, $nY, $nWidth, $nHeight, $pImageAttributes = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateTextureIA", "handle", $hImage, "handle", $pImageAttributes, "float", $nX, "float", $nY, "float", $nWidth, "float", $nHeight, "ptr*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[7]
EndFunc   ;==>_GDIPlus_TextureCreateIA

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GDIPlus_BrushDefCreate
; Description ...: Create a default Brush object if needed
; Syntax.........: __GDIPlus_BrushDefCreate ( ByRef $hBrush )
; Parameters ....: $hBrush      - Handle to a Brush object
; Return values .: Success      - $hBrush or a default Brush object
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; ===============================================================================================================================
Func __GDIPlus_BrushDefCreate(ByRef $hBrush)
	If $hBrush = 0 Then
		$__g_hGDIPBrush = _GDIPlus_BrushCreateSolid()
		$hBrush = $__g_hGDIPBrush
	EndIf
EndFunc   ;==>__GDIPlus_BrushDefCreate

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GDIPlus_BrushDefDispose
; Description ...: Free default Brush object
; Syntax.........: __GDIPlus_BrushDefDispose ( )
; Parameters ....:
; Return values .:
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; ===============================================================================================================================
Func __GDIPlus_BrushDefDispose($iCurError = @error, $iCurExtended = @extended)
	If $__g_hGDIPBrush <> 0 Then
		_GDIPlus_BrushDispose($__g_hGDIPBrush)
		$__g_hGDIPBrush = 0
	EndIf
	Return SetError($iCurError, $iCurExtended) ; restore caller @error and @extended
EndFunc   ;==>__GDIPlus_BrushDefDispose

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GDIPlus_ExtractFileExt
; Description ...: Extracts the extension part of the given filename
; Syntax.........: __GDIPlus_ExtractFileExt ( $sFileName [, $bNoDot = True] )
; Parameters ....: $sFileName   - Filename
;                  $bNoDot      - Determines whether the filename/extension separator is returned
;                  |True  - The separator is returned with the extension
;                  |False - The separator is not returned with the extension
; Return values .: Success      - Extension part
;                  Failure      - Empty string
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; ===============================================================================================================================
Func __GDIPlus_ExtractFileExt($sFileName, $bNoDot = True)
	Local $iIndex = __GDIPlus_LastDelimiter(".\:", $sFileName)
	If ($iIndex > 0) And (StringMid($sFileName, $iIndex, 1) = '.') Then
		If $bNoDot Then
			Return StringMid($sFileName, $iIndex + 1)
		Else
			Return StringMid($sFileName, $iIndex)
		EndIf
	Else
		Return ""
	EndIf
EndFunc   ;==>__GDIPlus_ExtractFileExt

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GDIPlus_LastDelimiter
; Description ...: Returns the index of the right most whole character that matches any character in a delimiter string
; Syntax.........: __GDIPlus_LastDelimiter ( $sDelimiters, $sString )
; Parameters ....: $sDelimiters - Delimiters
;                  $String      - String to be searched
; Return values .: Success      - Right most whole character that matches one of the delimiters
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; ===============================================================================================================================
Func __GDIPlus_LastDelimiter($sDelimiters, $sString)
	Local $sDelimiter, $iN

	For $iI = 1 To StringLen($sDelimiters)
		$sDelimiter = StringMid($sDelimiters, $iI, 1)
		$iN = StringInStr($sString, $sDelimiter, 0, -1)
		If $iN > 0 Then Return $iN
	Next
EndFunc   ;==>__GDIPlus_LastDelimiter

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GDIPlus_PenDefCreate
; Description ...: Create a default Pen object if needed
; Syntax.........: __GDIPlus_PenDefCreate ( ByRef $hPen )
; Parameters ....: $hPen        - Handle to a pen object
; Return values .: Success      - $hPen or a default pen object
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; ===============================================================================================================================
Func __GDIPlus_PenDefCreate(ByRef $hPen)
	If $hPen = 0 Then
		$__g_hGDIPPen = _GDIPlus_PenCreate()
		$hPen = $__g_hGDIPPen
	EndIf
EndFunc   ;==>__GDIPlus_PenDefCreate

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GDIPlus_PenDefDispose
; Description ...: Free default Pen object
; Syntax.........: __GDIPlus_PenDefDispose ( )
; Parameters ....:
; Return values .:
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; ===============================================================================================================================
Func __GDIPlus_PenDefDispose($iCurError = @error, $iCurExtended = @extended)
	If $__g_hGDIPPen <> 0 Then
		_GDIPlus_PenDispose($__g_hGDIPPen)
		$__g_hGDIPPen = 0
	EndIf
	Return SetError($iCurError, $iCurExtended) ; restore caller @error and @extended
EndFunc   ;==>__GDIPlus_PenDefDispose


; #FUNCTION# ====================================================================================================================
; Author ........: Eukalyptus
; Modified ......: jpm
; ===============================================================================================================================
Func _GDIPlus_BitmapApplyEffect($hBitmap, $hEffect, $tRECT = Null)
	If $__g_bGDIP_V1_0 Then Return SetError(-1, 0, False)
	If Not IsPtr($hEffect) Then Return SetError(10, 0, False)

	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipBitmapApplyEffect", "handle", $hBitmap, "handle", $hEffect, "struct*", $tRECT, "int", 0, "ptr*", 0, "int*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_BitmapApplyEffect

; #FUNCTION# ====================================================================================================================
; Author ........: Eukalyptus
; Modified ......: jpm
; ===============================================================================================================================
Func _GDIPlus_BitmapApplyEffectEx($hBitmap, $hEffect, $iX = 0, $iY = 0, $iW = 0, $iH = 0)
	If $__g_bGDIP_V1_0 Then Return SetError(-1, 0, False)

	Local $tRECT = 0
	If BitOR($iX, $iY, $iW, $iH) Then
		$tRECT = DllStructCreate("int Left; int Top; int Right; int Bottom;")
		DllStructSetData($tRECT, "Right", $iW + DllStructSetData($tRECT, "Left", $iX))
		DllStructSetData($tRECT, "Bottom", $iH + DllStructSetData($tRECT, "Top", $iY))
	EndIf

	Local $iStatus = _GDIPlus_BitmapApplyEffect($hBitmap, $hEffect, $tRECT)
	If Not $iStatus Then Return SetError(@error, @extended, False)

	Return True
EndFunc   ;==>_GDIPlus_BitmapApplyEffectEx

; #FUNCTION# ====================================================================================================================
; Author ........: Eukalyptus
; Modified ......: jpm
; ===============================================================================================================================
Func _GDIPlus_BitmapConvertFormat($hBitmap, $iPixelFormat, $iDitherType, $iPaletteType, $tPalette, $fAlphaThresholdPercent = 0.0)
	If $__g_bGDIP_V1_0 Then Return SetError(-1, 0, False)

	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipBitmapConvertFormat", "handle", $hBitmap, "uint", $iPixelFormat, "uint", $iDitherType, "uint", $iPaletteType, "struct*", $tPalette, "float", $fAlphaThresholdPercent)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_BitmapConvertFormat

; #FUNCTION# ====================================================================================================================
; Author ........: Eukalyptus
; Modified ......: jpm
; ===============================================================================================================================
Func _GDIPlus_BitmapCreateApplyEffect($hBitmap, $hEffect, $tRECT = Null, $tOutRECT = Null)
	If $__g_bGDIP_V1_0 Then Return SetError(-1, 0, 0)

	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipBitmapCreateApplyEffect", "handle*", $hBitmap, "int", 1, "handle", $hEffect, "struct*", $tRECT, "struct*", $tOutRECT, "handle*", 0, "int", 0, "ptr*", 0, "int*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[6]
EndFunc   ;==>_GDIPlus_BitmapCreateApplyEffect

; #FUNCTION# ====================================================================================================================
; Author ........: Eukalyptus
; Modified ......: jpm
; ===============================================================================================================================
Func _GDIPlus_BitmapCreateApplyEffectEx($hBitmap, $hEffect, $iX = 0, $iY = 0, $iW = 0, $iH = 0)
	If $__g_bGDIP_V1_0 Then Return SetError(-1, 0, 0)

	Local $tRECT = 0
	If BitOR($iX, $iY, $iW, $iH) Then
		$tRECT = DllStructCreate("int Left; int Top; int Right; int Bottom;")
		DllStructSetData($tRECT, "Right", $iW + DllStructSetData($tRECT, "Left", $iX))
		DllStructSetData($tRECT, "Bottom", $iH + DllStructSetData($tRECT, "Top", $iY))
	EndIf

	Local $hBitmap_FX = _GDIPlus_BitmapCreateApplyEffect($hBitmap, $hEffect, $tRECT, Null)

	Return SetError(@error, @extended, $hBitmap_FX)
EndFunc   ;==>_GDIPlus_BitmapCreateApplyEffectEx

; #FUNCTION# ====================================================================================================================
; Author ........: UEZ
; Modified ......: jpm
; ===============================================================================================================================
Func _GDIPlus_BitmapGetHistogram($hBitmap, $iHistogramFormat, $iHistogramSize, $tChannel_0, $tChannel_1 = 0, $tChannel_2 = 0, $tChannel_3 = 0)
	If $__g_bGDIP_V1_0 Then Return SetError(-1, 0, False)

	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipBitmapGetHistogram", "handle", $hBitmap, "uint", $iHistogramFormat, "uint", $iHistogramSize, "struct*", $tChannel_0, "struct*", $tChannel_1, "struct*", $tChannel_2, "struct*", $tChannel_3)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_BitmapGetHistogram

; #FUNCTION# ====================================================================================================================
; Author ........: Eukalyptus
; Modified ......: jpm
; ===============================================================================================================================
Func _GDIPlus_BitmapGetHistogramEx($hBitmap)
	If $__g_bGDIP_V1_0 Then Return SetError(-1, 0, 0)

	Local $iSize = _GDIPlus_BitmapGetHistogramSize($GDIP_HistogramFormatARGB)

	Local $tHistogram = DllStructCreate("int Size; uint Red[" & $iSize & "]; uint MaxRed; uint Green[" & $iSize & "]; uint MaxGreen; uint Blue[" & $iSize & "]; uint MaxBlue; uint Alpha[" & $iSize & "]; uint MaxAlpha; uint Grey[" & $iSize & "]; uint MaxGrey;")
	DllStructSetData($tHistogram, "Size", $iSize)

	Local $iStatus = _GDIPlus_BitmapGetHistogram($hBitmap, $GDIP_HistogramFormatARGB, $iSize, DllStructGetPtr($tHistogram, "Alpha"), DllStructGetPtr($tHistogram, "Red"), DllStructGetPtr($tHistogram, "Green"), DllStructGetPtr($tHistogram, "Blue"))
	If Not $iStatus Then Return SetError(@error, @extended, 0)
	$iStatus = _GDIPlus_BitmapGetHistogram($hBitmap, $GDIP_HistogramFormatGray, $iSize, DllStructGetPtr($tHistogram, "Grey"))
	If Not $iStatus Then Return SetError(@error + 10, @extended, 0)

	Local $iMaxRed = 0, $iMaxGreen = 0, $iMaxBlue = 0, $iMaxAlpha = 0, $iMaxGrey = 0
	For $i = 1 To $iSize
		If DllStructGetData($tHistogram, "Red", $i) > $iMaxRed Then $iMaxRed = DllStructGetData($tHistogram, "Red", $i)
		If DllStructGetData($tHistogram, "Green", $i) > $iMaxGreen Then $iMaxGreen = DllStructGetData($tHistogram, "Green", $i)
		If DllStructGetData($tHistogram, "Blue", $i) > $iMaxBlue Then $iMaxBlue = DllStructGetData($tHistogram, "Blue", $i)
		If DllStructGetData($tHistogram, "Alpha", $i) > $iMaxAlpha Then $iMaxAlpha = DllStructGetData($tHistogram, "Alpha", $i)
		If DllStructGetData($tHistogram, "Grey", $i) > $iMaxGrey Then $iMaxGrey = DllStructGetData($tHistogram, "Grey", $i)
	Next
	DllStructSetData($tHistogram, "MaxRed", $iMaxRed)
	DllStructSetData($tHistogram, "MaxGreen", $iMaxGreen)
	DllStructSetData($tHistogram, "MaxBlue", $iMaxBlue)
	DllStructSetData($tHistogram, "MaxAlpha", $iMaxAlpha)
	DllStructSetData($tHistogram, "MaxGrey", $iMaxGrey)

	Return $tHistogram
EndFunc   ;==>_GDIPlus_BitmapGetHistogramEx

; #FUNCTION# ====================================================================================================================
; Author ........: UEZ
; Modified ......: jpm
; ===============================================================================================================================
Func _GDIPlus_BitmapGetHistogramSize($iFormat)
	If $__g_bGDIP_V1_0 Then Return SetError(-1, 0, 0)

	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipBitmapGetHistogramSize", "uint", $iFormat, "uint*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[2]
EndFunc   ;==>_GDIPlus_BitmapGetHistogramSize

; #FUNCTION# ====================================================================================================================
; Author ........: UEZ
; Modified ......: jpm
; ===============================================================================================================================
Func _GDIPlus_DrawImageFX($hGraphics, $hImage, $hEffect, $tRECTF = 0, $hMatrix = 0, $hImgAttributes = 0, $iUnit = 2)
	If $__g_bGDIP_V1_0 Then Return SetError(-1, 0, False)

	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDrawImageFX", "handle", $hGraphics, "handle", $hImage, "struct*", $tRECTF, "handle", $hMatrix, "handle", $hEffect, "handle", $hImgAttributes, "uint", $iUnit)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_DrawImageFX

; #FUNCTION# ====================================================================================================================
; Author ........: Eukalyptus
; Modified ......: jpm
; ===============================================================================================================================
Func _GDIPlus_DrawImageFXEx($hGraphics, $hImage, $hEffect, $nX = 0, $nY = 0, $nW = 0, $nH = 0, $hMatrix = 0, $hImgAttributes = 0, $iUnit = 2)
	If $__g_bGDIP_V1_0 Then Return SetError(-1, 0, False)

	Local $tRECTF = 0
	If BitOR($nX, $nY, $nW, $nH) Then $tRECTF = _GDIPlus_RectFCreate($nX, $nY, $nW, $nH)

	Local $iStatus = _GDIPlus_DrawImageFX($hGraphics, $hImage, $hEffect, $tRECTF, $hMatrix, $hImgAttributes, $iUnit)

	Return SetError(@error, @extended, $iStatus)
EndFunc   ;==>_GDIPlus_DrawImageFXEx

; #FUNCTION# ====================================================================================================================
; Author ........: UEZ
; Modified ......: jpm
; ===============================================================================================================================
Func _GDIPlus_EffectCreate($sEffectGUID)
	If $__g_bGDIP_V1_0 Then Return SetError(-1, 0, 0)

	Local $tGUID = _WinAPI_GUIDFromString($sEffectGUID)
	Local $tElem = DllStructCreate("uint64[2];", DllStructGetPtr($tGUID))

	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateEffect", "uint64", DllStructGetData($tElem, 1, 1), "uint64", DllStructGetData($tElem, 1, 2), "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[3]
EndFunc   ;==>_GDIPlus_EffectCreate

; #FUNCTION# ====================================================================================================================
; Author ........: UEZ
; Modified ......: jpm
; ===============================================================================================================================
Func _GDIPlus_EffectCreateBlur($fRadius = 10.0, $bExpandEdge = False)
	If $__g_bGDIP_V1_0 Then Return SetError(-1, 0, 0)

	Local $tEffectParameters = DllStructCreate($tagGDIP_EFFECTPARAMS_Blur)
	DllStructSetData($tEffectParameters, "Radius", $fRadius)
	DllStructSetData($tEffectParameters, "ExpandEdge", $bExpandEdge)

	Local $hEffect = _GDIPlus_EffectCreate($GDIP_BlurEffectGuid)
	If @error Then Return SetError(@error, @extended, 0)
	_GDIPlus_EffectSetParameters($hEffect, $tEffectParameters)
	If @error Then Return SetError(@error + 10, @extended, 0)

	Return $hEffect
EndFunc   ;==>_GDIPlus_EffectCreateBlur

; #FUNCTION# ====================================================================================================================
; Author ........: UEZ
; Modified ......: jpm
; ===============================================================================================================================
Func _GDIPlus_EffectCreateBrightnessContrast($iBrightnessLevel = 0, $iContrastLevel = 0)
	If $__g_bGDIP_V1_0 Then Return SetError(-1, 0, 0)

	Local $tEffectParameters = DllStructCreate($tagGDIP_EFFECTPARAMS_BrightnessContrast)
	DllStructSetData($tEffectParameters, "BrightnessLevel", $iBrightnessLevel)
	DllStructSetData($tEffectParameters, "ContrastLevel", $iContrastLevel)

	Local $hEffect = _GDIPlus_EffectCreate($GDIP_BrightnessContrastEffectGuid)
	If @error Then Return SetError(@error, @extended, 0)
	_GDIPlus_EffectSetParameters($hEffect, $tEffectParameters)
	If @error Then Return SetError(@error + 10, @extended, 0)

	Return $hEffect
EndFunc   ;==>_GDIPlus_EffectCreateBrightnessContrast

; #FUNCTION# ====================================================================================================================
; Author ........: UEZ
; Modified ......: jpm
; ===============================================================================================================================
Func _GDIPlus_EffectCreateColorBalance($iCyanRed = 0, $iMagentaGreen = 0, $iYellowBlue = 0)
	If $__g_bGDIP_V1_0 Then Return SetError(-1, 0, 0)

	Local $tEffectParameters = DllStructCreate($tagGDIP_EFFECTPARAMS_ColorBalance)
	DllStructSetData($tEffectParameters, "CyanRed", $iCyanRed)
	DllStructSetData($tEffectParameters, "MagentaGreen", $iMagentaGreen)
	DllStructSetData($tEffectParameters, "YellowBlue", $iYellowBlue)

	Local $hEffect = _GDIPlus_EffectCreate($GDIP_ColorBalanceEffectGuid)
	If @error Then Return SetError(@error, @extended, 0)
	_GDIPlus_EffectSetParameters($hEffect, $tEffectParameters)
	If @error Then Return SetError(@error + 10, @extended, 0)

	Return $hEffect
EndFunc   ;==>_GDIPlus_EffectCreateColorBalance

; #FUNCTION# ====================================================================================================================
; Author ........: UEZ
; Modified ......: jpm
; ===============================================================================================================================
Func _GDIPlus_EffectCreateColorCurve($iAdjustment, $iChannel, $iAdjustValue)
	If $__g_bGDIP_V1_0 Then Return SetError(-1, 0, 0)

	Local $tEffectParameters = DllStructCreate($tagGDIP_EFFECTPARAMS_ColorCurve)
	DllStructSetData($tEffectParameters, "Adjustment", $iAdjustment)
	DllStructSetData($tEffectParameters, "Channel", $iChannel)
	DllStructSetData($tEffectParameters, "AdjustValue", $iAdjustValue)

	Local $hEffect = _GDIPlus_EffectCreate($GDIP_ColorCurveEffectGuid)
	If @error Then Return SetError(@error, @extended, 0)
	_GDIPlus_EffectSetParameters($hEffect, $tEffectParameters)
	If @error Then Return SetError(@error + 10, @extended, 0)

	Return $hEffect
EndFunc   ;==>_GDIPlus_EffectCreateColorCurve

; #FUNCTION# ====================================================================================================================
; Author ........: UEZ
; Modified ......: jpm
; ===============================================================================================================================
Func _GDIPlus_EffectCreateColorLUT($aColorLUT)
	If $__g_bGDIP_V1_0 Then Return SetError(-1, 0, 0)

	Local $tEffectParameters = DllStructCreate($tagGDIP_EFFECTPARAMS_ColorLUT)
	For $iI = 0 To 255
		DllStructSetData($tEffectParameters, "LutA", $aColorLUT[$iI][0], $iI + 1)
		DllStructSetData($tEffectParameters, "LutR", $aColorLUT[$iI][1], $iI + 1)
		DllStructSetData($tEffectParameters, "LutG", $aColorLUT[$iI][2], $iI + 1)
		DllStructSetData($tEffectParameters, "LutB", $aColorLUT[$iI][3], $iI + 1)
	Next

	Local $hEffect = _GDIPlus_EffectCreate($GDIP_ColorLUTEffectGuid)
	If @error Then Return SetError(@error, @extended, 0)
	_GDIPlus_EffectSetParameters($hEffect, $tEffectParameters)
	If @error Then Return SetError(@error + 10, @extended, 0)

	Return $hEffect
EndFunc   ;==>_GDIPlus_EffectCreateColorLUT

; #FUNCTION# ====================================================================================================================
; Author ........: UEZ
; Modified ......: jpm
; ===============================================================================================================================
Func _GDIPlus_EffectCreateColorMatrix($tColorMatrix)
	If $__g_bGDIP_V1_0 Then Return SetError(-1, 0, 0)

	Local $hEffect = _GDIPlus_EffectCreate($GDIP_ColorMatrixEffectGuid)
	If @error Then Return SetError(@error, @extended, 0)
	_GDIPlus_EffectSetParameters($hEffect, $tColorMatrix)
	If @error Then Return SetError(@error + 10, @extended, 0)

	Return $hEffect
EndFunc   ;==>_GDIPlus_EffectCreateColorMatrix

; #FUNCTION# ====================================================================================================================
; Author ........: UEZ
; Modified ......: jpm
; ===============================================================================================================================
Func _GDIPlus_EffectCreateHueSaturationLightness($iHueLevel = 0, $iSaturationLevel = 0, $iLightnessLevel = 0)
	If $__g_bGDIP_V1_0 Then Return SetError(-1, 0, 0)

	Local $tEffectParameters = DllStructCreate($tagGDIP_EFFECTPARAMS_HueSaturationLightness)
	DllStructSetData($tEffectParameters, "HueLevel", $iHueLevel)
	DllStructSetData($tEffectParameters, "SaturationLevel", $iSaturationLevel)
	DllStructSetData($tEffectParameters, "LightnessLevel", $iLightnessLevel)

	Local $hEffect = _GDIPlus_EffectCreate($GDIP_HueSaturationLightnessEffectGuid)
	If @error Then Return SetError(@error, @extended, 0)
	_GDIPlus_EffectSetParameters($hEffect, $tEffectParameters)
	If @error Then Return SetError(@error + 10, @extended, 0)

	Return $hEffect
EndFunc   ;==>_GDIPlus_EffectCreateHueSaturationLightness

; #FUNCTION# ====================================================================================================================
; Author ........: UEZ
; Modified ......: jpm
; ===============================================================================================================================
Func _GDIPlus_EffectCreateLevels($iHighlight = 100, $iMidtone = 0, $iShadow = 0)
	If $__g_bGDIP_V1_0 Then Return SetError(-1, 0, 0)

	Local $tEffectParameters = DllStructCreate($tagGDIP_EFFECTPARAMS_Levels)
	DllStructSetData($tEffectParameters, "Highlight", $iHighlight)
	DllStructSetData($tEffectParameters, "Midtone", $iMidtone)
	DllStructSetData($tEffectParameters, "Shadow", $iShadow)

	Local $hEffect = _GDIPlus_EffectCreate($GDIP_LevelsEffectGuid)
	If @error Then Return SetError(@error, @extended, 0)
	_GDIPlus_EffectSetParameters($hEffect, $tEffectParameters)
	If @error Then Return SetError(@error + 10, @extended, 0)

	Return $hEffect
EndFunc   ;==>_GDIPlus_EffectCreateLevels

; #FUNCTION# ====================================================================================================================
; Author ........: UEZ
; Modified ......: jpm
; ===============================================================================================================================
Func _GDIPlus_EffectCreateRedEyeCorrection($aAreas)
	If $__g_bGDIP_V1_0 Then Return SetError(-1, 0, 0)

	Local $iCount = $aAreas[0][0]
	Local $tAreas = DllStructCreate("long[" & $iCount * 4 & "]")
	For $iI = 1 To $iCount
		DllStructSetData($tAreas, 1, DllStructSetData($tAreas, 1, $aAreas[$iI][0], (($iI - 1) * 4) + 1) + $aAreas[$iI][2], (($iI - 1) * 4) + 3)
		DllStructSetData($tAreas, 1, DllStructSetData($tAreas, 1, $aAreas[$iI][1], (($iI - 1) * 4) + 2) + $aAreas[$iI][3], (($iI - 1) * 4) + 4)
	Next

	Local $tEffectParameters = DllStructCreate($tagGDIP_EFFECTPARAMS_RedEyeCorrection)
	DllStructSetData($tEffectParameters, "NumberOfAreas", $iCount)
	DllStructSetData($tEffectParameters, "Areas", DllStructGetPtr($tAreas))

	Local $hEffect = _GDIPlus_EffectCreate($GDIP_RedEyeCorrectionEffectGuid)
	If @error Then Return SetError(@error, @extended, 0)
	_GDIPlus_EffectSetParameters($hEffect, $tEffectParameters, (DllStructGetSize($tAreas) + DllStructGetSize($tEffectParameters)) / DllStructGetSize($tEffectParameters))
	If @error Then Return SetError(@error + 10, @extended, 0)

	Return $hEffect
EndFunc   ;==>_GDIPlus_EffectCreateRedEyeCorrection

; #FUNCTION# ====================================================================================================================
; Author ........: UEZ
; Modified ......: jpm
; ===============================================================================================================================
Func _GDIPlus_EffectCreateSharpen($fRadius = 10.0, $fAmount = 50.0)
	If $__g_bGDIP_V1_0 Then Return SetError(-1, 0, 0)

	Local $tEffectParameters = DllStructCreate($tagGDIP_EFFECTPARAMS_Sharpen)
	DllStructSetData($tEffectParameters, "Radius", $fRadius)
	DllStructSetData($tEffectParameters, "Amount", $fAmount)

	Local $hEffect = _GDIPlus_EffectCreate($GDIP_SharpenEffectGuid)
	If @error Then Return SetError(@error, @extended, 0)
	_GDIPlus_EffectSetParameters($hEffect, $tEffectParameters)
	If @error Then Return SetError(@error + 10, @extended, 0)

	Return $hEffect
EndFunc   ;==>_GDIPlus_EffectCreateSharpen

; #FUNCTION# ====================================================================================================================
; Author ........: UEZ
; Modified ......: jpm
; ===============================================================================================================================
Func _GDIPlus_EffectCreateTint($iHue = 0, $iAmount = 0)
	If $__g_bGDIP_V1_0 Then Return SetError(-1, 0, 0)

	Local $tEffectParameters = DllStructCreate($tagGDIP_EFFECTPARAMS_Tint)
	DllStructSetData($tEffectParameters, "Hue", $iHue)
	DllStructSetData($tEffectParameters, "Amount", $iAmount)

	Local $hEffect = _GDIPlus_EffectCreate($GDIP_TintEffectGuid)
	If @error Then Return SetError(@error, @extended, 0)
	_GDIPlus_EffectSetParameters($hEffect, $tEffectParameters)
	If @error Then Return SetError(@error + 10, @extended, 0)

	Return $hEffect
EndFunc   ;==>_GDIPlus_EffectCreateTint

; #FUNCTION# ====================================================================================================================
; Author ........: UEZ
; Modified ......: jpm
; ===============================================================================================================================
Func _GDIPlus_EffectDispose($hEffect)
	If $__g_bGDIP_V1_0 Then Return SetError(-1, 0, False)

	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDeleteEffect", "handle", $hEffect)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_EffectDispose

; #FUNCTION# ====================================================================================================================
; Author ........: Eukalyptus
; Modified ......: jpm
; ===============================================================================================================================
Func _GDIPlus_EffectGetParameters($hEffect, $tEffectParameters)
	If $__g_bGDIP_V1_0 Then Return SetError(-1, 0, False)

	If DllStructGetSize($tEffectParameters) < __GDIPlus_EffectGetParameterSize($hEffect) Then Return SetError(2, 5, False)

	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetEffectParameters", "handle", $hEffect, "uint*", DllStructGetSize($tEffectParameters), "struct*", $tEffectParameters)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_EffectGetParameters

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __GDIPlus_EffectGetParameterSize
; Description ...: Gets the total size, in bytes, of the parameters currently set for the specified effect
; Syntax ........: __GDIPlus_EffectGetParameterSize($hEffect)
; Parameters ....: $hEffect             - Handle to an Effect object
; Return values .: Success      - the size in Bytes.
;                  Failure      - -1 and sets the @error flag to non-zero, @extended may contain GPSTATUS error code ($GPID_ERR*).
; Author ........: Eukalyptus
; Modified ......:
; Remarks .......:
; Related .......: _GDIPlus_EffectCreate, _GDIPlus_EffectGetParameters
; Link ..........: @@MsdnLink@@ GdipGetEffectParameterSize
; Example .......: No
; ===============================================================================================================================
Func __GDIPlus_EffectGetParameterSize($hEffect)
	If $__g_bGDIP_V1_0 Then Return SetError(-1, 0, -1)

	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetEffectParameterSize", "handle", $hEffect, "uint*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	If $aResult[0] Then Return SetError(10, $aResult[0], -1)

	Return $aResult[2]
EndFunc   ;==>__GDIPlus_EffectGetParameterSize

; #FUNCTION# ====================================================================================================================
; Author ........: UEZ
; Modified ......: jpm
; ===============================================================================================================================
Func _GDIPlus_EffectSetParameters($hEffect, $tEffectParameters, $iSizeAdjust = 1)
	If $__g_bGDIP_V1_0 Then Return SetError(-1, 0, False)

	Local $iSize = __GDIPlus_EffectGetParameterSize($hEffect)
	If @error Then Return SetError(@error, @extended, False)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetEffectParameters", "handle", $hEffect, "struct*", $tEffectParameters, "uint", $iSize * $iSizeAdjust)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)

	Return True
EndFunc   ;==>_GDIPlus_EffectSetParameters

; #FUNCTION# ====================================================================================================================
; Author ........: Eukalyptus
; Modified ......: jpm
; ===============================================================================================================================
Func _GDIPlus_PaletteInitialize($iEntries, $iPaletteType = $GDIP_PaletteTypeOptimal, $iOptimalColors = 0, $bUseTransparentColor = True, $hBitmap = Null)
	If $__g_bGDIP_V1_0 Then Return SetError(-1, 0, 0)

	If $iOptimalColors > 0 Then $iPaletteType = $GDIP_PaletteTypeOptimal
	Local $tPalette = DllStructCreate("uint Flags; uint Count; uint ARGB[" & $iEntries & "];")
	DllStructSetData($tPalette, "Flags", $iPaletteType)
	DllStructSetData($tPalette, "Count", $iEntries)

	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipInitializePalette", "struct*", $tPalette, "uint", $iPaletteType, "uint", $iOptimalColors, "bool", $bUseTransparentColor, "handle", $hBitmap)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $tPalette
EndFunc   ;==>_GDIPlus_PaletteInitialize
