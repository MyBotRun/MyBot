#include-once

#include "ButtonConstants.au3"
#include "SendMessage.au3"
#include "UDFGlobalID.au3"
#include "WinAPI.au3"

; #INDEX# =======================================================================================================================
; Title .........: Button
; AutoIt Version : 3.3.14.2
; Language ......: English
; Description ...: Functions that assist with Button control management.
;                  A button is a control the user can click to provide input to an application.
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
Global $__g_hButtonLastWnd

; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $tagBUTTON_IMAGELIST = "ptr ImageList;" & $tagRECT & ";uint Align"
Global Const $tagBUTTON_SPLITINFO = "uint mask;handle himlGlyph;uint uSplitStyle;" & $tagSIZE
; mask
; A set of flags that specify which members of this structure contain data to be set or which members are being requested. Set this member to one or more of the following flags.
; BCSIF_GLYPH
; himlGlyph is valid.
; BCSIF_IMAGE
; himlGlyph is valid. Use when uSplitStyle is set to BCSS_IMAGE.
; BCSIF_SIZE
; size is valid.
; BCSIF_STYLE
; uSplitStyle is valid.
; himlGlyph
; A handle to the image list. The provider retains ownership of the image list and is ultimately responsible for its disposal.
; uSplitStyle
; The split button style. Value must be one or more of the following flags.
; BCSS_ALIGNLEFT
; Align the image or glyph horizontally with the left margin.
; BCSS_IMAGE
; Draw an icon image as the glyph.
; BCSS_NOSPLIT
; No split.
; BCSS_STRETCH
; Stretch glyph, but try to retain aspect ratio.
; size
; Fields ........: X - Width
;                  Y - Height

Global Const $__BUTTONCONSTANT_ClassName = "Button"

Global Const $__BUTTONCONSTANT_GWL_STYLE = 0xFFFFFFF0

Global Const $__BUTTONCONSTANT_WM_SETFONT = 0x0030
Global Const $__BUTTONCONSTANT_DEFAULT_GUI_FONT = 17
; ===============================================================================================================================

; #NO_DOC_FUNCTION# =============================================================================================================
; Not working/documented/implemented at this time
;
; _GUICtrlButton_SetDropDownState
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _GUICtrlButton_Click
; _GUICtrlButton_Create
; _GUICtrlButton_Destroy
; _GUICtrlButton_Enable
; _GUICtrlButton_GetCheck
; _GUICtrlButton_GetFocus
; _GUICtrlButton_GetIdealSize
; _GUICtrlButton_GetImage
; _GUICtrlButton_GetImageList
; _GUICtrlButton_GetNote
; _GUICtrlButton_GetNoteLength
; _GUICtrlButton_GetSplitInfo
; _GUICtrlButton_GetState
; _GUICtrlButton_GetText
; _GUICtrlButton_GetTextMargin
; _GUICtrlButton_SetCheck
; _GUICtrlButton_SetDontClick
; _GUICtrlButton_SetFocus
; _GUICtrlButton_SetImage
; _GUICtrlButton_SetImageList
; _GUICtrlButton_SetNote
; _GUICtrlButton_SetShield
; _GUICtrlButton_SetSize
; _GUICtrlButton_SetSplitInfo
; _GUICtrlButton_SetState
; _GUICtrlButton_SetStyle
; _GUICtrlButton_SetText
; _GUICtrlButton_SetTextMargin
; _GUICtrlButton_Show
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlButton_Click($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	_SendMessage($hWnd, $BM_CLICK)
EndFunc   ;==>_GUICtrlButton_Click

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlButton_Create($hWnd, $sText, $iX, $iY, $iWidth, $iHeight, $iStyle = -1, $iExStyle = -1)
	If Not IsHWnd($hWnd) Then
		; Invalid Window handle for _GUICtrlButton_Create 1st parameter
		Return SetError(1, 0, 0)
	EndIf
	If Not IsString($sText) Then
		; 2nd parameter not a string for _GUICtrlButton_Create
		Return SetError(2, 0, 0)
	EndIf

	Local $iForcedStyle = BitOR($__UDFGUICONSTANT_WS_TABSTOP, $__UDFGUICONSTANT_WS_VISIBLE, $__UDFGUICONSTANT_WS_CHILD, $BS_NOTIFY)

	If $iStyle = -1 Then
		$iStyle = $iForcedStyle
	Else
		$iStyle = BitOR($iStyle, $iForcedStyle)
	EndIf
	If $iExStyle = -1 Then $iExStyle = 0
	Local $nCtrlID = __UDF_GetNextGlobalID($hWnd)
	If @error Then Return SetError(@error, @extended, 0)
	Local $hButton = _WinAPI_CreateWindowEx($iExStyle, $__BUTTONCONSTANT_ClassName, $sText, $iStyle, $iX, $iY, $iWidth, $iHeight, $hWnd, $nCtrlID)
	_SendMessage($hButton, $__BUTTONCONSTANT_WM_SETFONT, _WinAPI_GetStockObject($__BUTTONCONSTANT_DEFAULT_GUI_FONT), True)
	Return $hButton
EndFunc   ;==>_GUICtrlButton_Create

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlButton_Destroy(ByRef $hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__BUTTONCONSTANT_ClassName) Then Return SetError(2, 2, False)

	Local $iDestroyed = 0
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hButtonLastWnd) Then
			Local $nCtrlID = _WinAPI_GetDlgCtrlID($hWnd)
			Local $hParent = _WinAPI_GetParent($hWnd)
			$iDestroyed = _WinAPI_DestroyWindow($hWnd)
			Local $iRet = __UDF_FreeGlobalID($hParent, $nCtrlID)
			If Not $iRet Then
				; can check for errors here if needed, for debug
			EndIf
		Else
			; Not Allowed to Destroy Other Applications Control(s)
			Return SetError(1, 1, False)
		EndIf
	Else
		$iDestroyed = GUICtrlDelete($hWnd)
	EndIf
	If $iDestroyed Then $hWnd = 0
	Return $iDestroyed <> 0
EndFunc   ;==>_GUICtrlButton_Destroy

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlButton_Enable($hWnd, $bEnable = True)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	If _WinAPI_IsClassName($hWnd, $__BUTTONCONSTANT_ClassName) Then Return _WinAPI_EnableWindow($hWnd, $bEnable) = $bEnable
EndFunc   ;==>_GUICtrlButton_Enable

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlButton_GetCheck($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	Return _SendMessage($hWnd, $BM_GETCHECK)
EndFunc   ;==>_GUICtrlButton_GetCheck

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlButton_GetFocus($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	If _WinAPI_IsClassName($hWnd, $__BUTTONCONSTANT_ClassName) Then Return _WinAPI_GetFocus() = $hWnd
EndFunc   ;==>_GUICtrlButton_GetFocus

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlButton_GetIdealSize($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $tSize = DllStructCreate($tagSIZE), $aSize[2]
	Local $iRet = _SendMessage($hWnd, $BCM_GETIDEALSIZE, 0, $tSize, 0, "wparam", "struct*")
	If Not $iRet Then Return SetError(-1, -1, $aSize)
	$aSize[0] = DllStructGetData($tSize, "X")
	$aSize[1] = DllStructGetData($tSize, "Y")
	Return $aSize
EndFunc   ;==>_GUICtrlButton_GetIdealSize

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlButton_GetImage($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	Local $iRet = _SendMessage($hWnd, $BM_GETIMAGE, 0, 0, 0, "wparam", "lparam", "hwnd") ; check IMAGE_BITMAP
	If $iRet <> 0x00000000 Then Return $iRet
	$iRet = _SendMessage($hWnd, $BM_GETIMAGE, 1, 0, 0, "wparam", "lparam", "hwnd") ; check IMAGE_ICON
	If $iRet = 0x00000000 Then Return 0
	Return $iRet
EndFunc   ;==>_GUICtrlButton_GetImage

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlButton_GetImageList($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	Local $tBUTTON_IMAGELIST = DllStructCreate($tagBUTTON_IMAGELIST), $aImageList[6]
	If Not _SendMessage($hWnd, $BCM_GETIMAGELIST, 0, $tBUTTON_IMAGELIST, 0, "wparam", "struct*") Then Return SetError(-1, -1, $aImageList)
	$aImageList[0] = DllStructGetData($tBUTTON_IMAGELIST, "ImageList")
	$aImageList[1] = DllStructGetData($tBUTTON_IMAGELIST, "Left")
	$aImageList[2] = DllStructGetData($tBUTTON_IMAGELIST, "Right")
	$aImageList[3] = DllStructGetData($tBUTTON_IMAGELIST, "Top")
	$aImageList[4] = DllStructGetData($tBUTTON_IMAGELIST, "Bottom")
	$aImageList[5] = DllStructGetData($tBUTTON_IMAGELIST, "Align")
	Return $aImageList
EndFunc   ;==>_GUICtrlButton_GetImageList

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlButton_GetNote($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $iLen = _GUICtrlButton_GetNoteLength($hWnd) + 1
	Local $tNote = DllStructCreate("wchar Note[" & $iLen & "]")
	Local $tLen = DllStructCreate("dword")
	DllStructSetData($tLen, 1, $iLen)
	If Not _SendMessage($hWnd, $BCM_GETNOTE, $tLen, $tNote, 0, "struct*", "struct*") Then Return SetError(-1, 0, "")
	Return _WinAPI_WideCharToMultiByte($tNote)
EndFunc   ;==>_GUICtrlButton_GetNote

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlButton_GetNoteLength($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	Return _SendMessage($hWnd, $BCM_GETNOTELENGTH)
EndFunc   ;==>_GUICtrlButton_GetNoteLength

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlButton_GetSplitInfo($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $tSplitInfo = DllStructCreate($tagBUTTON_SPLITINFO), $aInfo[4]
	DllStructSetData($tSplitInfo, "mask", BitOR($BCSIF_GLYPH, $BCSIF_IMAGE, $BCSIF_SIZE, $BCSIF_STYLE))
	If Not _SendMessage($hWnd, $BCM_GETSPLITINFO, 0, $tSplitInfo, 0, "wparam", "struct*") Then Return SetError(-1, 0, $aInfo)
	$aInfo[0] = DllStructGetData($tSplitInfo, "himlGlyph")
	$aInfo[1] = DllStructGetData($tSplitInfo, "uSplitStyle")
	$aInfo[2] = DllStructGetData($tSplitInfo, "X")
	$aInfo[3] = DllStructGetData($tSplitInfo, "Y")
	Return $aInfo
EndFunc   ;==>_GUICtrlButton_GetSplitInfo

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlButton_GetState($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	Return _SendMessage($hWnd, $BM_GETSTATE)
EndFunc   ;==>_GUICtrlButton_GetState

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlButton_GetText($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	If _WinAPI_IsClassName($hWnd, $__BUTTONCONSTANT_ClassName) Then Return _WinAPI_GetWindowText($hWnd)
	Return ""
EndFunc   ;==>_GUICtrlButton_GetText

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlButton_GetTextMargin($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	Local $tRECT = DllStructCreate($tagRECT), $aRect[4]
	If Not _SendMessage($hWnd, $BCM_GETTEXTMARGIN, 0, $tRECT, 0, "wparam", "struct*") Then Return SetError(-1, -1, $aRect)
	$aRect[0] = DllStructGetData($tRECT, "Left")
	$aRect[1] = DllStructGetData($tRECT, "Top")
	$aRect[2] = DllStructGetData($tRECT, "Right")
	$aRect[3] = DllStructGetData($tRECT, "Bottom")
	Return $aRect
EndFunc   ;==>_GUICtrlButton_GetTextMargin

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlButton_SetCheck($hWnd, $iState = $BST_CHECKED)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	_SendMessage($hWnd, $BM_SETCHECK, $iState)
EndFunc   ;==>_GUICtrlButton_SetCheck

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlButton_SetDontClick($hWnd, $bState = True)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	_SendMessage($hWnd, $BM_SETDONTCLICK, $bState)
EndFunc   ;==>_GUICtrlButton_SetDontClick

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _GUICtrlButton_SetDropDownState
; Description ...: Sets the drop down state for a button with style $TBSTYLE_DROPDOWN
; Syntax.........: _GUICtrlButton_SetDropDownState ( $hWnd [, $bState = True] )
; Parameters ....: $hWnd        - Handle to the control
;                  $iState      - Drop down state
;                  |  True  - For state of $BST_DROPDOWNPUSHED
;                  |  False - otherwise
; Return values .: Success - True
;                  Failure - False
; Author ........: Gary Frost
; Modified.......:
; Remarks .......: Minimum Operating Systems: Windows Vista
; Related .......:
; Link ..........: @@MsdnLink@@ BCM_SETDROPDOWNSTATE
; Example .......: Yes
; ===============================================================================================================================
Func _GUICtrlButton_SetDropDownState($hWnd, $bState = True)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	Return _SendMessage($hWnd, $BCM_SETDROPDOWNSTATE, $bState) <> 0
EndFunc   ;==>_GUICtrlButton_SetDropDownState

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlButton_SetFocus($hWnd, $bFocus = True)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	If _WinAPI_IsClassName($hWnd, $__BUTTONCONSTANT_ClassName) Then
		If $bFocus Then
			Return _WinAPI_SetFocus($hWnd) <> 0
		Else
			Return _WinAPI_SetFocus(_WinAPI_GetParent($hWnd)) <> 0
		EndIf
	EndIf
EndFunc   ;==>_GUICtrlButton_SetFocus

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlButton_SetImage($hWnd, $sImageFile, $iIconID = -1, $bLarge = False)
	Local $hImage, $hPrevImage
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	If StringUpper(StringMid($sImageFile, StringLen($sImageFile) - 2)) = "BMP" Then
		If BitAND(_WinAPI_GetWindowLong($hWnd, $__BUTTONCONSTANT_GWL_STYLE), $BS_BITMAP) = $BS_BITMAP Then
			$hImage = _WinAPI_LoadImage(0, $sImageFile, 0, 0, 0, BitOR($LR_LOADFROMFILE, $LR_CREATEDIBSECTION))
			If Not $hImage Then Return SetError(-1, -1, False)
			$hPrevImage = _SendMessage($hWnd, $BM_SETIMAGE, 0, $hImage)
			If $hPrevImage Then
				If Not _WinAPI_DeleteObject($hPrevImage) Then _WinAPI_DestroyIcon($hPrevImage)
			EndIf
			_WinAPI_UpdateWindow($hWnd) ; force a WM_PAINT
			Return True
		EndIf
	Else
		If $iIconID = -1 Then
			$hImage = _WinAPI_LoadImage(0, $sImageFile, 1, 0, 0, BitOR($LR_LOADFROMFILE, $LR_CREATEDIBSECTION))
			If Not $hImage Then Return SetError(-1, -1, False)
			$hPrevImage = _SendMessage($hWnd, $BM_SETIMAGE, 1, $hImage)
			If $hPrevImage Then
				If Not _WinAPI_DeleteObject($hPrevImage) Then _WinAPI_DestroyIcon($hPrevImage)
			EndIf
			_WinAPI_UpdateWindow($hWnd) ; force a WM_PAINT
			Return True
		Else
			Local $tIcon = DllStructCreate("handle Handle")
			Local $iRet
			If $bLarge Then
				$iRet = _WinAPI_ExtractIconEx($sImageFile, $iIconID, $tIcon, 0, 1)
			Else
				$iRet = _WinAPI_ExtractIconEx($sImageFile, $iIconID, 0, $tIcon, 1)
			EndIf
			If Not $iRet Then Return SetError(-1, -1, False)
			$hPrevImage = _SendMessage($hWnd, $BM_SETIMAGE, 1, DllStructGetData($tIcon, "Handle"))
			If $hPrevImage Then
				If Not _WinAPI_DeleteObject($hPrevImage) Then _WinAPI_DestroyIcon($hPrevImage)
			EndIf
			_WinAPI_UpdateWindow($hWnd) ; force a WM_PAINT
			Return True
		EndIf
	EndIf
	Return False
EndFunc   ;==>_GUICtrlButton_SetImage

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlButton_SetImageList($hWnd, $hImage, $iAlign = 0, $iLeft = 1, $iTop = 1, $iRight = 1, $iBottom = 1)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	If $iAlign < 0 Or $iAlign > 4 Then $iAlign = 0

	Local $tBUTTON_IMAGELIST = DllStructCreate($tagBUTTON_IMAGELIST)

	DllStructSetData($tBUTTON_IMAGELIST, "ImageList", $hImage)
	DllStructSetData($tBUTTON_IMAGELIST, "Left", $iLeft)
	DllStructSetData($tBUTTON_IMAGELIST, "Top", $iTop)
	DllStructSetData($tBUTTON_IMAGELIST, "Right", $iRight)
	DllStructSetData($tBUTTON_IMAGELIST, "Bottom", $iBottom)
	DllStructSetData($tBUTTON_IMAGELIST, "Align", $iAlign)

	Local $bEnabled = _GUICtrlButton_Enable($hWnd, False)
	Local $iRet = _SendMessage($hWnd, $BCM_SETIMAGELIST, 0, $tBUTTON_IMAGELIST, 0, "wparam", "struct*") <> 0
	_GUICtrlButton_Enable($hWnd)
	If Not $bEnabled Then _GUICtrlButton_Enable($hWnd, False)
	Return $iRet
EndFunc   ;==>_GUICtrlButton_SetImageList

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlButton_SetNote($hWnd, $sNote)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	Local $tNote = _WinAPI_MultiByteToWideChar($sNote)
	Return _SendMessage($hWnd, $BCM_SETNOTE, 0, $tNote, 0, "wparam", "struct*") <> 0
EndFunc   ;==>_GUICtrlButton_SetNote

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlButton_SetShield($hWnd, $bRequired = True)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	Return _SendMessage($hWnd, $BCM_SETSHIELD, 0, $bRequired) = 1
EndFunc   ;==>_GUICtrlButton_SetShield

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlButton_SetSize($hWnd, $iWidth, $iHeight)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	If Not _WinAPI_IsClassName($hWnd, $__BUTTONCONSTANT_ClassName) Then Return SetError(-1, -1, False)
	Local $hParent = _WinAPI_GetParent($hWnd)
	If Not $hParent Then Return SetError(-1, -1, False)
	Local $aPos = WinGetPos($hWnd)
	If Not IsArray($aPos) Then Return SetError(-1, -1, False)
	Local $tPoint = DllStructCreate($tagPOINT)
	DllStructSetData($tPoint, "X", $aPos[0])
	DllStructSetData($tPoint, "Y", $aPos[1])
	If Not _WinAPI_ScreenToClient($hParent, $tPoint) Then Return SetError(-1, -1, False)
	Local $iRet = WinMove($hWnd, "", DllStructGetData($tPoint, "X"), DllStructGetData($tPoint, "Y"), $iWidth, $iHeight)
	Return SetError($iRet - 1, $iRet - 1, $iRet <> 0)
EndFunc   ;==>_GUICtrlButton_SetSize

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlButton_SetSplitInfo($hWnd, $hImlGlyph = -1, $iSplitStyle = $BCSS_ALIGNLEFT, $iWidth = 0, $iHeight = 0)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	Local $tSplitInfo = DllStructCreate($tagBUTTON_SPLITINFO), $iMask = 0

	If $hImlGlyph <> -1 Then
		$iMask = BitOR($iMask, $BCSIF_GLYPH)
		DllStructSetData($tSplitInfo, "himlGlyph", $hImlGlyph)
	EndIf

	$iMask = BitOR($iMask, $BCSIF_STYLE)
	If BitAND($iSplitStyle, $BCSS_IMAGE) = $BCSS_IMAGE Then $iMask = BitOR($iMask, $BCSIF_IMAGE)
	DllStructSetData($tSplitInfo, "uSplitStyle", $iSplitStyle)

	If $iWidth > 0 Or $iHeight > 0 Then
		$iMask = BitOR($iMask, $BCSIF_SIZE)
		DllStructSetData($tSplitInfo, "X", $iWidth)
		DllStructSetData($tSplitInfo, "Y", $iHeight)
	EndIf

	DllStructSetData($tSplitInfo, "mask", $iMask)

	Return _SendMessage($hWnd, $BCM_SETSPLITINFO, 0, $tSplitInfo, 0, "wparam", "struct*") <> 0
EndFunc   ;==>_GUICtrlButton_SetSplitInfo

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlButton_SetState($hWnd, $bHighlighted = True)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	_SendMessage($hWnd, $BM_SETSTATE, $bHighlighted)
EndFunc   ;==>_GUICtrlButton_SetState

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlButton_SetStyle($hWnd, $iStyle)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	_SendMessage($hWnd, $BM_SETSTYLE, $iStyle, True)
	_WinAPI_UpdateWindow($hWnd) ; force a WM_PAINT
EndFunc   ;==>_GUICtrlButton_SetStyle

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlButton_SetText($hWnd, $sText)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	If _WinAPI_IsClassName($hWnd, $__BUTTONCONSTANT_ClassName) Then Return _WinAPI_SetWindowText($hWnd, $sText)
EndFunc   ;==>_GUICtrlButton_SetText

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlButton_SetTextMargin($hWnd, $iLeft = 1, $iTop = 1, $iRight = 1, $iBottom = 1)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	Local $tRECT = DllStructCreate($tagRECT)
	DllStructSetData($tRECT, "Left", $iLeft)
	DllStructSetData($tRECT, "Top", $iTop)
	DllStructSetData($tRECT, "Right", $iRight)
	DllStructSetData($tRECT, "Bottom", $iBottom)
	Return _SendMessage($hWnd, $BCM_SETTEXTMARGIN, 0, $tRECT, 0, "wparam", "struct*") <> 0
EndFunc   ;==>_GUICtrlButton_SetTextMargin

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlButton_Show($hWnd, $bShow = True)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	If _WinAPI_IsClassName($hWnd, $__BUTTONCONSTANT_ClassName) Then
		If $bShow Then
			Return _WinAPI_ShowWindow($hWnd, @SW_SHOW)
		Else
			Return _WinAPI_ShowWindow($hWnd, @SW_HIDE)
		EndIf
	EndIf
EndFunc   ;==>_GUICtrlButton_Show
