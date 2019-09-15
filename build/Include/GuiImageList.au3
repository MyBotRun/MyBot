#include-once

#include "ColorConstants.au3"
#include "ImageListConstants.au3"
#include "StructureConstants.au3"
#include "WinAPI.au3"

; #INDEX# =======================================================================================================================
; Title .........: ImageList
; AutoIt Version : 3.3.14.2
; Description ...: Functions that assist with ImageList control management.
;                  An image list is a collection of images of the same size, each of which can be referred to by its index. Image
;                  lists are used to efficiently manage large sets of icons or bitmaps. All images in an image list are contained
;                  in a single, wide bitmap in screen device format.  An image list can also include  a  monochrome  bitmap  that
;                  contains masks used to draw images transparently (icon style).
; Author(s)......: Paul Campbell (PaulIA)
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $__IMAGELISTCONSTANT_IMAGE_BITMAP = 0
; ===============================================================================================================================

; #NO_DOC_FUNCTION# =============================================================================================================
; Not documented at this time
;
; _GUIImageList_DragShowNolock
; _GUIImageList_Merge
; _GUIImageList_Replace
; _GUIImageList_SetDragCursorImage
; _GUIImageList_SetOverlayImage
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _GUIImageList_Add
; _GUIImageList_AddMasked
; _GUIImageList_AddBitmap
; _GUIImageList_AddIcon
; _GUIImageList_BeginDrag
; _GUIImageList_Copy
; _GUIImageList_Create
; _GUIImageList_Destroy
; _GUIImageList_DestroyIcon
; _GUIImageList_DragEnter
; _GUIImageList_DragLeave
; _GUIImageList_DragMove
; _GUIImageList_Draw
; _GUIImageList_DrawEx
; _GUIImageList_Duplicate
; _GUIImageList_EndDrag
; _GUIImageList_GetBkColor
; _GUIImageList_GetIcon
; _GUIImageList_GetIconHeight
; _GUIImageList_GetIconSize
; _GUIImageList_GetIconSizeEx
; _GUIImageList_GetIconWidth
; _GUIImageList_GetImageCount
; _GUIImageList_GetImageInfoEx
; _GUIImageList_Remove
; _GUIImageList_ReplaceIcon
; _GUIImageList_SetBkColor
; _GUIImageList_SetIconSize
; _GUIImageList_SetImageCount
; _GUIImageList_Swap
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIImageList_Add($hWnd, $hImage, $hMask = 0)
	Local $aResult = DllCall("comctl32.dll", "int", "ImageList_Add", "handle", $hWnd, "handle", $hImage, "handle", $hMask)
	If @error Then Return SetError(@error, @extended, -1)
	Return $aResult[0]
EndFunc   ;==>_GUIImageList_Add

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIImageList_AddMasked($hWnd, $hImage, $iMask = 0)
	Local $aResult = DllCall("comctl32.dll", "int", "ImageList_AddMasked", "handle", $hWnd, "handle", $hImage, "dword", $iMask)
	If @error Then Return SetError(@error, @extended, -1)
	Return $aResult[0]
EndFunc   ;==>_GUIImageList_AddMasked

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIImageList_AddBitmap($hWnd, $sImage, $sMask = "")
	Local $aSize = _GUIImageList_GetIconSize($hWnd)
	Local $hImage = _WinAPI_LoadImage(0, $sImage, $__IMAGELISTCONSTANT_IMAGE_BITMAP, $aSize[0], $aSize[1], $LR_LOADFROMFILE)
	If $hImage = 0 Then Return SetError(_WinAPI_GetLastError(), 1, -1)
	Local $hMask = 0
	If $sMask <> "" Then
		$hMask = _WinAPI_LoadImage(0, $sMask, $__IMAGELISTCONSTANT_IMAGE_BITMAP, $aSize[0], $aSize[1], $LR_LOADFROMFILE)
		If $hMask = 0 Then Return SetError(_WinAPI_GetLastError(), 2, -1)
	EndIf

	Local $iRet = _GUIImageList_Add($hWnd, $hImage, $hMask)
	_WinAPI_DeleteObject($hImage)
	If $hMask <> 0 Then _WinAPI_DeleteObject($hMask)
	Return $iRet
EndFunc   ;==>_GUIImageList_AddBitmap

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIImageList_AddIcon($hWnd, $sFilePath, $iIndex = 0, $bLarge = False)
	Local $iRet, $tIcon = DllStructCreate("handle Handle")
	If $bLarge Then
		$iRet = _WinAPI_ExtractIconEx($sFilePath, $iIndex, $tIcon, 0, 1)
	Else
		$iRet = _WinAPI_ExtractIconEx($sFilePath, $iIndex, 0, $tIcon, 1)
	EndIf
	If $iRet <= 0 Then Return SetError(-1, $iRet, -1)

	Local $hIcon = DllStructGetData($tIcon, "Handle")
	$iRet = _GUIImageList_ReplaceIcon($hWnd, -1, $hIcon)
	_WinAPI_DestroyIcon($hIcon)
	If $iRet = -1 Then Return SetError(-2, $iRet, -1)
	Return $iRet
EndFunc   ;==>_GUIImageList_AddIcon

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIImageList_BeginDrag($hWnd, $iTrack, $iXHotSpot, $iYHotSpot)
	Local $aResult = DllCall("comctl32.dll", "bool", "ImageList_BeginDrag", "handle", $hWnd, "int", $iTrack, "int", $iXHotSpot, "int", $iYHotSpot)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] <> 0
EndFunc   ;==>_GUIImageList_BeginDrag

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUIImageList_Copy($hWnd, $iSource, $iDestination)
	Local $aResult = DllCall("comctl32.dll", "bool", "ImageList_Copy", "handle", $hWnd, "int", $iDestination, "handle", $hWnd, "int", $iSource, "uint", $ILCF_MOVE)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] <> 0
EndFunc   ;==>_GUIImageList_Copy

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIImageList_Create($iCX = 16, $iCY = 16, $iColor = 4, $iOptions = 0, $iInitial = 4, $iGrow = 4)
	Local Const $aColor[7] = [$ILC_COLOR, $ILC_COLOR4, $ILC_COLOR8, $ILC_COLOR16, $ILC_COLOR24, $ILC_COLOR32, $ILC_COLORDDB]
	Local $iFlags = 0

	If BitAND($iOptions, 1) <> 0 Then $iFlags = BitOR($iFlags, $ILC_MASK)
	If BitAND($iOptions, 2) <> 0 Then $iFlags = BitOR($iFlags, $ILC_MIRROR)
	If BitAND($iOptions, 4) <> 0 Then $iFlags = BitOR($iFlags, $ILC_PERITEMMIRROR)
	$iFlags = BitOR($iFlags, $aColor[$iColor])
	Local $aResult = DllCall("comctl32.dll", "handle", "ImageList_Create", "int", $iCX, "int", $iCY, "uint", $iFlags, "int", $iInitial, "int", $iGrow)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_GUIImageList_Create

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIImageList_Destroy($hWnd)
	Local $aResult = DllCall("comctl32.dll", "bool", "ImageList_Destroy", "handle", $hWnd)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] <> 0
EndFunc   ;==>_GUIImageList_Destroy

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUIImageList_DestroyIcon($hIcon)
	Return _WinAPI_DestroyIcon($hIcon)
EndFunc   ;==>_GUIImageList_DestroyIcon

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUIImageList_DragEnter($hWnd, $iX, $iY)
	Local $aResult = DllCall("comctl32.dll", "bool", "ImageList_DragEnter", "hwnd", $hWnd, "int", $iX, "int", $iY)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] <> 0
EndFunc   ;==>_GUIImageList_DragEnter

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUIImageList_DragLeave($hWnd)
	Local $aResult = DllCall("comctl32.dll", "bool", "ImageList_DragLeave", "hwnd", $hWnd)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] <> 0
EndFunc   ;==>_GUIImageList_DragLeave

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUIImageList_DragMove($iX, $iY)
	Local $aResult = DllCall("comctl32.dll", "bool", "ImageList_DragMove", "int", $iX, "int", $iY)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] <> 0
EndFunc   ;==>_GUIImageList_DragMove

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _GUIImageList_DragShowNolock
; Description ...: Shows or hides the image being dragged
; Syntax.........: _GUIImageList_DragShowNolock ( $bShow )
; Parameters ....: $bShow       - Show or hide the image being dragged
;                  | True       - Show
;                  |False       - Hide
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Gary Frost (gafrost)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _GUIImageList_DragShowNolock($bShow)
	Local $aResult = DllCall("comctl32.dll", "bool", "ImageList_DragShowNolock", "bool", $bShow)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] <> 0
EndFunc   ;==>_GUIImageList_DragShowNolock

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIImageList_Draw($hWnd, $iIndex, $hDC, $iX, $iY, $iStyle = 0)
	Local $iFlags = 0

	If BitAND($iStyle, 1) <> 0 Then $iFlags = BitOR($iFlags, $ILD_TRANSPARENT)
	If BitAND($iStyle, 2) <> 0 Then $iFlags = BitOR($iFlags, $ILD_BLEND25)
	If BitAND($iStyle, 4) <> 0 Then $iFlags = BitOR($iFlags, $ILD_BLEND50)
	If BitAND($iStyle, 8) <> 0 Then $iFlags = BitOR($iFlags, $ILD_MASK)
	Local $aResult = DllCall("comctl32.dll", "bool", "ImageList_Draw", "handle", $hWnd, "int", $iIndex, "handle", $hDC, "int", $iX, "int", $iY, "uint", $iFlags)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] <> 0
EndFunc   ;==>_GUIImageList_Draw

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUIImageList_DrawEx($hWnd, $iIndex, $hDC, $iX, $iY, $iDX = 0, $iDY = 0, $iRGBBk = 0xFFFFFFFF, $iRGBFg = 0xFFFFFFFF, $iStyle = 0)
	If $iDX = -1 Then $iDX = 0
	If $iDY = -1 Then $iDY = 0
	If $iRGBBk = -1 Then $iRGBBk = 0xFFFFFFFF
	If $iRGBFg = -1 Then $iRGBFg = 0xFFFFFFFF
	Local $iFlags = 0
	If BitAND($iStyle, 1) <> 0 Then $iFlags = BitOR($iFlags, $ILD_TRANSPARENT)
	If BitAND($iStyle, 2) <> 0 Then $iFlags = BitOR($iFlags, $ILD_BLEND25)
	If BitAND($iStyle, 4) <> 0 Then $iFlags = BitOR($iFlags, $ILD_BLEND50)
	If BitAND($iStyle, 8) <> 0 Then $iFlags = BitOR($iFlags, $ILD_MASK)
	Local $aResult = DllCall("comctl32.dll", "bool", "ImageList_DrawEx", "handle", $hWnd, "int", $iIndex, "handle", $hDC, "int", $iX, "int", $iY, _
			"int", $iDX, "int", $iDY, "dword", $iRGBBk, "dword", $iRGBFg, "uint", $iFlags)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] <> 0
EndFunc   ;==>_GUIImageList_DrawEx

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUIImageList_Duplicate($hWnd)
	Local $aResult = DllCall("comctl32.dll", "handle", "ImageList_Duplicate", "handle", $hWnd)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_GUIImageList_Duplicate

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIImageList_EndDrag()
	DllCall("comctl32.dll", "none", "ImageList_EndDrag")
	If @error Then Return SetError(@error, @extended)
EndFunc   ;==>_GUIImageList_EndDrag

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUIImageList_GetBkColor($hWnd)
	Local $aResult = DllCall("comctl32.dll", "dword", "ImageList_GetBkColor", "handle", $hWnd)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_GUIImageList_GetBkColor

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUIImageList_GetIcon($hWnd, $iIndex, $iStyle = 0)
	Local $iFlags = 0

	If BitAND($iStyle, 1) <> 0 Then $iFlags = BitOR($iFlags, $ILD_TRANSPARENT)
	If BitAND($iStyle, 2) <> 0 Then $iFlags = BitOR($iFlags, $ILD_BLEND25)
	If BitAND($iStyle, 4) <> 0 Then $iFlags = BitOR($iFlags, $ILD_BLEND50)
	If BitAND($iStyle, 8) <> 0 Then $iFlags = BitOR($iFlags, $ILD_MASK)

	Local $aResult = DllCall("comctl32.dll", "handle", "ImageList_GetIcon", "handle", $hWnd, "int", $iIndex, "uint", $iFlags)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_GUIImageList_GetIcon

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIImageList_GetIconHeight($hWnd)
	Local $aSize = _GUIImageList_GetIconSize($hWnd)
	Return $aSize[1]
EndFunc   ;==>_GUIImageList_GetIconHeight

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIImageList_GetIconSize($hWnd)
	Local $aSize[2]

	Local $tPoint = _GUIImageList_GetIconSizeEx($hWnd)
	$aSize[0] = DllStructGetData($tPoint, "X")
	$aSize[1] = DllStructGetData($tPoint, "Y")
	Return $aSize
EndFunc   ;==>_GUIImageList_GetIconSize

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIImageList_GetIconSizeEx($hWnd)
	Local $tPoint = DllStructCreate($tagPOINT)
	Local $pPointX = DllStructGetPtr($tPoint, "X")
	Local $pPointY = DllStructGetPtr($tPoint, "Y")
	Local $aResult = DllCall("comctl32.dll", "bool", "ImageList_GetIconSize", "hwnd", $hWnd, "struct*", $pPointX, "struct*", $pPointY)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $tPoint)
EndFunc   ;==>_GUIImageList_GetIconSizeEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIImageList_GetIconWidth($hWnd)
	Local $aSize = _GUIImageList_GetIconSize($hWnd)
	Return $aSize[0]
EndFunc   ;==>_GUIImageList_GetIconWidth

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUIImageList_GetImageCount($hWnd)
	Local $aResult = DllCall("comctl32.dll", "int", "ImageList_GetImageCount", "handle", $hWnd)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_GUIImageList_GetImageCount

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIImageList_GetImageInfoEx($hWnd, $iIndex)
	Local $tImage = DllStructCreate($tagIMAGEINFO)
	Local $aResult = DllCall("comctl32.dll", "bool", "ImageList_GetImageInfo", "handle", $hWnd, "int", $iIndex, "struct*", $tImage)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $tImage)
EndFunc   ;==>_GUIImageList_GetImageInfoEx

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _GUIImageList_Merge
; Description ...: Creates a new image by combining two existing images
; Syntax.........: _GUIImageList_Merge ( $hWnd1, $iIndex1, $hWnd2, $iIndex2, $iDX, $IDY )
; Parameters ....: $hWnd1       - Handle to the 1st image control
;                  $iIndex1     - Zero based of the first existing image
;                  $hWnd2       - Handle to the 2nd image control
;                  $iIndex2     - Zero based of the second existing image
;                  $iDX         - The x-offset of the second image relative to the first image
;                  $iDY         - The y-offset of the second image relative to the first image
; Return values .: Success      - The handle to the new image list
;                  Failure      - 0
; Author ........: Gary Frost (gafrost)
; Modified.......:
; Remarks .......: The new image consists of the second existing image drawn transparently over the first.
;                  The mask for the new image is the result of performing a logical OR operation on the masks
;                  of the two existing images.
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _GUIImageList_Merge($hWnd1, $iIndex1, $hWnd2, $iIndex2, $iDX, $iDY)
	Local $aResult = DllCall("comctl32.dll", "handle", "ImageList_Merge", "handle", $hWnd1, "int", $iIndex1, _
			"handle", $hWnd2, "int", $iIndex2, "int", $iDX, "int", $iDY)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_GUIImageList_Merge

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUIImageList_Remove($hWnd, $iIndex = -1)
	Local $aResult = DllCall("comctl32.dll", "bool", "ImageList_Remove", "handle", $hWnd, "int", $iIndex)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] <> 0
EndFunc   ;==>_GUIImageList_Remove

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _GUIImageList_Replace
; Description ...: Replaces an image with an icon or cursor
; Syntax.........: _GUIImageList_ReplaceIcon ( $hWnd, $iIndex, $hIcon )
; Parameters ....: $hWnd        - Handle to the control
;                  $iIndex      - Index of the image to replace.
;                  $hImage      - Handle to the bitmap that contains the image
;                  $hMask       - A handle to the bitmap that contains the mask.
;                  +If no mask is used with the image list, this parameter is ignored
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Gary Frost (gafrost)
; Modified.......:
; Remarks .......: The _GUIImageList_Replace function copies the bitmap to an internal data structure.
;                  Be sure to use the _WinAPI_DeleteObject function to delete $hImage and $hMask after the function returns.
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _GUIImageList_Replace($hWnd, $iIndex, $hImage, $hMask = 0)
	Local $aResult = DllCall("comctl32.dll", "bool", "ImageList_Replace", "handle", $hWnd, "int", $iIndex, "handle", $hImage, "handle", $hMask)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] <> 0
EndFunc   ;==>_GUIImageList_Replace

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (GaryFrost) changed return type from hwnd to int
; ===============================================================================================================================
Func _GUIImageList_ReplaceIcon($hWnd, $iIndex, $hIcon)
	Local $aResult = DllCall("comctl32.dll", "int", "ImageList_ReplaceIcon", "handle", $hWnd, "int", $iIndex, "handle", $hIcon)
	If @error Then Return SetError(@error, @extended, -1)
	Return $aResult[0]
EndFunc   ;==>_GUIImageList_ReplaceIcon

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUIImageList_SetBkColor($hWnd, $iClrBk)
	Local $aResult = DllCall("comctl32.dll", "dword", "ImageList_SetBkColor", "handle", $hWnd, "dword", $iClrBk)
	If @error Then Return SetError(@error, @extended, $CLR_NONE)
	Return $aResult[0]
EndFunc   ;==>_GUIImageList_SetBkColor

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _GUIImageList_SetDragCursorImage
; Description ...: Creates a new drag image
; Syntax.........: _GUIImageList_SetDragCursorImage ( $hWnd, $iDrag, $iDXHotSpot, $iDYHotSpot )
; Parameters ....: $hWnd        - A handle to the image list that contains the new image to combine with the drag image
;                  $iDrag       - The index of the new image to combine with the drag image
;                  $iDXHotSpot  - The x-position of the hot spot within the new image
;                  $iDYHotSpot  - The y-position of the hot spot within the new image
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Gary Frost (gafrost)
; Modified.......:
; Remarks .......: Creates a new drag image by combining the specified image (typically a mouse cursor image)
;                  with the current drag image
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _GUIImageList_SetDragCursorImage($hWnd, $iDrag, $iDXHotSpot, $iDYHotSpot)
	Local $aResult = DllCall("comctl32.dll", "bool", "ImageList_SetDragCursorImage", "handle", $hWnd, "int", $iDrag, "int", $iDXHotSpot, "int", $iDYHotSpot)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] <> 0
EndFunc   ;==>_GUIImageList_SetDragCursorImage

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUIImageList_SetIconSize($hWnd, $iCX, $iCY)
	Local $aResult = DllCall("comctl32.dll", "bool", "ImageList_SetIconSize", "handle", $hWnd, "int", $iCX, "int", $iCY)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] <> 0
EndFunc   ;==>_GUIImageList_SetIconSize

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUIImageList_SetImageCount($hWnd, $iNewCount)
	Local $aResult = DllCall("comctl32.dll", "bool", "ImageList_SetImageCount", "handle", $hWnd, "uint", $iNewCount)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] <> 0
EndFunc   ;==>_GUIImageList_SetImageCount

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _GUIImageList_SetOverlayImage
; Description ...: Adds a specified image to the list of images to be used as overlay masks
; Syntax.........: _GUIImageList_SetOverlayImage ( $hWnd, $iImage, $iOverlay )
; Parameters ....: $hWnd        - Handle to the control
;                  $iImage      - The zero-based index of an image in the himl image list
;                  +This index identifies the image to use as an overlay mask
;                  $iOverlay    - The one-based index of the overlay mask
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Gary Frost (gafrost)
; Modified.......:
; Remarks .......: An image list can have up to four overlay masks in (comctl32.dll) version 4.70 and earlier
;                  and up to 15 in version 4.71. The function assigns an overlay mask index to the specified image.
; +
;                  An overlay mask is an image drawn transparently over another image.
;                  To draw an overlay mask over an image, call the _GUIImageList_Draw or _GUIImageList_DrawEx function.
; +
;                  A call to this method fails and returns $E_INVALIDARG unless the image list is created using a mask.
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _GUIImageList_SetOverlayImage($hWnd, $iImage, $iOverlay)
	Local $aResult = DllCall("comctl32.dll", "bool", "ImageList_SetOverlayImage", "handle", $hWnd, "int", $iImage, "int", $iOverlay)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] <> 0
EndFunc   ;==>_GUIImageList_SetOverlayImage

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUIImageList_Swap($hWnd, $iSource, $iDestination)
	Local $aResult = DllCall("comctl32.dll", "bool", "ImageList_Copy", "handle", $hWnd, "int", $iDestination, "handle", $hWnd, "int", $iSource, "uint", $ILCF_SWAP)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] <> 0
EndFunc   ;==>_GUIImageList_Swap
