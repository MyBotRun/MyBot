#include-once

#include "DirConstants.au3"
#include "GuiComboBox.au3"
#include "Memory.au3"
#include "UDFGlobalID.au3"

; #INDEX# =======================================================================================================================
; Title .........: ComboBoxEx
; AutoIt Version : 3.3.14.2
; Language ......: English
; Description ...: Functions that assist with ComboBoxEx control management.
;                  ComboBoxEx Controls are an extension of the combo box control that provides native support for item images.
;                  To make item images easily accessible, the control provides image list support. By using this control, you
;                  can provide the functionality of a combo box without having to manually draw item graphics.
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
Global $__g_hCBExLastWnd
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $__COMBOBOXEXCONSTANT_ClassName = "ComboBoxEx32"
Global Const $__COMBOBOXEXCONSTANT_WM_SIZE = 0x05
; ===============================================================================================================================

; #NO_DOC_FUNCTION# =============================================================================================================
; Not working/documented/implemented at this time
;
; _GUICtrlComboBoxEx_HasEditChanged
;
; Things to figure out for ComboBoxEx
; FindString
; AutoComplete
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _GUICtrlComboBoxEx_AddDir
; _GUICtrlComboBoxEx_AddString
; _GUICtrlComboBoxEx_BeginUpdate
; _GUICtrlComboBoxEx_Create
; _GUICtrlComboBoxEx_CreateSolidBitMap
; _GUICtrlComboBoxEx_DeleteString
; _GUICtrlComboBoxEx_Destroy
; _GUICtrlComboBoxEx_EndUpdate
; _GUICtrlComboBoxEx_FindStringExact
; _GUICtrlComboBoxEx_GetComboBoxInfo
; _GUICtrlComboBoxEx_GetComboControl
; _GUICtrlComboBoxEx_GetCount
; _GUICtrlComboBoxEx_GetCurSel
; _GUICtrlComboBoxEx_GetDroppedControlRect
; _GUICtrlComboBoxEx_GetDroppedControlRectEx
; _GUICtrlComboBoxEx_GetDroppedState
; _GUICtrlComboBoxEx_GetDroppedWidth
; _GUICtrlComboBoxEx_GetEditControl
; _GUICtrlComboBoxEx_GetEditSel
; _GUICtrlComboBoxEx_GetEditText
; _GUICtrlComboBoxEx_GetExtendedStyle
; _GUICtrlComboBoxEx_GetExtendedUI
; _GUICtrlComboBoxEx_GetImageList
; _GUICtrlComboBoxEx_GetItem
; _GUICtrlComboBoxEx_GetItemEx
; _GUICtrlComboBoxEx_GetItemHeight
; _GUICtrlComboBoxEx_GetItemImage
; _GUICtrlComboBoxEx_GetItemIndent
; _GUICtrlComboBoxEx_GetItemOverlayImage
; _GUICtrlComboBoxEx_GetItemParam
; _GUICtrlComboBoxEx_GetItemSelectedImage
; _GUICtrlComboBoxEx_GetItemText
; _GUICtrlComboBoxEx_GetItemTextLen
; _GUICtrlComboBoxEx_GetList
; _GUICtrlComboBoxEx_GetListArray
; _GUICtrlComboBoxEx_GetLocale
; _GUICtrlComboBoxEx_GetLocaleCountry
; _GUICtrlComboBoxEx_GetLocaleLang
; _GUICtrlComboBoxEx_GetLocalePrimLang
; _GUICtrlComboBoxEx_GetLocaleSubLang
; _GUICtrlComboBoxEx_GetMinVisible
; _GUICtrlComboBoxEx_GetTopIndex
; _GUICtrlComboBoxEx_GetUnicode
; _GUICtrlComboBoxEx_InitStorage
; _GUICtrlComboBoxEx_InsertString
; _GUICtrlComboBoxEx_LimitText
; _GUICtrlComboBoxEx_ReplaceEditSel
; _GUICtrlComboBoxEx_ResetContent
; _GUICtrlComboBoxEx_SetCurSel
; _GUICtrlComboBoxEx_SetDroppedWidth
; _GUICtrlComboBoxEx_SetEditSel
; _GUICtrlComboBoxEx_SetEditText
; _GUICtrlComboBoxEx_SetExtendedStyle
; _GUICtrlComboBoxEx_SetExtendedUI
; _GUICtrlComboBoxEx_SetImageList
; _GUICtrlComboBoxEx_SetItem
; _GUICtrlComboBoxEx_SetItemEx
; _GUICtrlComboBoxEx_SetItemHeight
; _GUICtrlComboBoxEx_SetItemImage
; _GUICtrlComboBoxEx_SetItemIndent
; _GUICtrlComboBoxEx_SetItemOverlayImage
; _GUICtrlComboBoxEx_SetItemParam
; _GUICtrlComboBoxEx_SetItemSelectedImage
; _GUICtrlComboBoxEx_SetMinVisible
; _GUICtrlComboBoxEx_SetTopIndex
; _GUICtrlComboBoxEx_SetUnicode
; _GUICtrlComboBoxEx_ShowDropDown
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_AddDir($hWnd, $sFilePath, $iAttributes = 0, $bBrackets = True)
	Local $hGui = GUICreate("combo gui")
	Local $idCombo = GUICtrlCreateCombo("", 240, 40, 120, 120)
	Local $iRet = GUICtrlSendMsg($idCombo, $CB_DIR, $iAttributes, $sFilePath)
	If $iRet = -1 Then
		GUIDelete($hGui)
		Return SetError(-1, -1, -1)
	EndIf
	Local $sText
	For $i = 0 To _GUICtrlComboBox_GetCount($idCombo) - 1
		_GUICtrlComboBox_GetLBText($idCombo, $i, $sText)
		If BitAND($iAttributes, $DDL_DRIVES) = $DDL_DRIVES And _
				Not $bBrackets Then $sText = StringReplace(StringReplace(StringReplace($sText, "[", ""), "]", ":"), "-", "")
		_GUICtrlComboBoxEx_InsertString($hWnd, $sText)
	Next
	GUIDelete($hGui)
	Return $iRet
EndFunc   ;==>_GUICtrlComboBoxEx_AddDir

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_AddString($hWnd, $sText, $iImage = -1, $iSelectedImage = -1, $iOverlayImage = -1, $iIndent = -1, $iParam = -1)
	Return _GUICtrlComboBoxEx_InsertString($hWnd, $sText, -1, $iImage, $iSelectedImage, $iOverlayImage, $iIndent, $iParam)
EndFunc   ;==>_GUICtrlComboBoxEx_AddString

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_BeginUpdate($hWnd)
	Return _SendMessage($hWnd, $__COMBOBOXCONSTANT_WM_SETREDRAW, False) = 0
EndFunc   ;==>_GUICtrlComboBoxEx_BeginUpdate

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_Create($hWnd, $sText, $iX, $iY, $iWidth = 100, $iHeight = 200, $iStyle = 0x00200002, $iExStyle = 0x00000000)
	If Not IsHWnd($hWnd) Then Return SetError(1, 0, 0) ; Invalid Window handle for _GUICtrlComboBoxEx_Create 1st parameter
	If Not IsString($sText) Then Return SetError(2, 0, 0) ; 2nd parameter not a string for _GUICtrlComboBoxEx_Create

	Local $sDelimiter = Opt("GUIDataSeparatorChar")

	If $iWidth = -1 Then $iWidth = 100
	If $iHeight = -1 Then $iHeight = 200
	Local Const $WS_VSCROLL = 0x00200000
	If $iStyle = -1 Then $iStyle = BitOR($WS_VSCROLL, $CBS_DROPDOWN)
	If $iExStyle = -1 Then $iExStyle = 0x00000000

	$iStyle = BitOR($iStyle, $__UDFGUICONSTANT_WS_CHILD, $__UDFGUICONSTANT_WS_TABSTOP, $__UDFGUICONSTANT_WS_VISIBLE)

	Local $nCtrlID = __UDF_GetNextGlobalID($hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Local $hCombo = _WinAPI_CreateWindowEx($iExStyle, $__COMBOBOXEXCONSTANT_ClassName, "", $iStyle, $iX, $iY, $iWidth, $iHeight, $hWnd, $nCtrlID)
	_WinAPI_SetFont($hCombo, _WinAPI_GetStockObject($__COMBOBOXCONSTANT_DEFAULT_GUI_FONT))
	If StringLen($sText) Then
		Local $aText = StringSplit($sText, $sDelimiter)
		For $x = 1 To $aText[0]
			_GUICtrlComboBoxEx_AddString($hCombo, $aText[$x])
		Next
	EndIf
	Return $hCombo
EndFunc   ;==>_GUICtrlComboBoxEx_Create

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_CreateSolidBitMap($hWnd, $iColor, $iWidth, $iHeight)
	Return _WinAPI_CreateSolidBitmap($hWnd, $iColor, $iWidth, $iHeight)
EndFunc   ;==>_GUICtrlComboBoxEx_CreateSolidBitMap

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_DeleteString($hWnd, $iIndex)
	Return _SendMessage($hWnd, $CBEM_DELETEITEM, $iIndex)
EndFunc   ;==>_GUICtrlComboBoxEx_DeleteString

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_Destroy(ByRef $hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__COMBOBOXEXCONSTANT_ClassName) Then Return SetError(2, 2, False)

	Local $iDestroyed = 0
	If _WinAPI_InProcess($hWnd, $__g_hCBExLastWnd) Then
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
	If $iDestroyed Then $hWnd = 0
	Return $iDestroyed <> 0
EndFunc   ;==>_GUICtrlComboBoxEx_Destroy

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_EndUpdate($hWnd)
	Return _SendMessage($hWnd, $__COMBOBOXCONSTANT_WM_SETREDRAW, True) = 0
EndFunc   ;==>_GUICtrlComboBoxEx_EndUpdate

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_FindStringExact($hWnd, $sText, $iIndex = -1)
	Return _SendMessage($hWnd, $CB_FINDSTRINGEXACT, $iIndex, $sText, 0, "wparam", "wstr")
EndFunc   ;==>_GUICtrlComboBoxEx_FindStringExact

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_GetComboBoxInfo($hWnd, ByRef $tInfo)
	Local $hCombo = _GUICtrlComboBoxEx_GetComboControl($hWnd)
	Return _GUICtrlComboBox_GetComboBoxInfo($hCombo, $tInfo)
EndFunc   ;==>_GUICtrlComboBoxEx_GetComboBoxInfo

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_GetComboControl($hWnd)
	Return HWnd(_SendMessage($hWnd, $CBEM_GETCOMBOCONTROL))
EndFunc   ;==>_GUICtrlComboBoxEx_GetComboControl

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_GetCount($hWnd)
	Return _SendMessage($hWnd, $CB_GETCOUNT)
EndFunc   ;==>_GUICtrlComboBoxEx_GetCount

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_GetCurSel($hWnd)
	Return _SendMessage($hWnd, $CB_GETCURSEL)
EndFunc   ;==>_GUICtrlComboBoxEx_GetCurSel

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_GetDroppedControlRect($hWnd)
	Local $tRECT = _GUICtrlComboBox_GetDroppedControlRectEx($hWnd)
	Local $aRect[4]
	$aRect[0] = DllStructGetData($tRECT, "Left")
	$aRect[1] = DllStructGetData($tRECT, "Top")
	$aRect[2] = DllStructGetData($tRECT, "Right")
	$aRect[3] = DllStructGetData($tRECT, "Bottom")

	Return $aRect
EndFunc   ;==>_GUICtrlComboBoxEx_GetDroppedControlRect

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_GetDroppedControlRectEx($hWnd)
	Local $tRECT = DllStructCreate($tagRECT)
	_SendMessage($hWnd, $CB_GETDROPPEDCONTROLRECT, 0, $tRECT, 0, "wparam", "struct*")
	Return $tRECT
EndFunc   ;==>_GUICtrlComboBoxEx_GetDroppedControlRectEx

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafro_GUICtrlComboBox_GetDroppedState
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_GetDroppedState($hWnd)
	Return _SendMessage($hWnd, $CB_GETDROPPEDSTATE) <> 0
EndFunc   ;==>_GUICtrlComboBoxEx_GetDroppedState

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_GetDroppedWidth($hWnd)
	Local $hCombo = _GUICtrlComboBoxEx_GetComboControl($hWnd)
	Return _GUICtrlComboBox_GetDroppedWidth($hCombo)
EndFunc   ;==>_GUICtrlComboBoxEx_GetDroppedWidth

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_GetEditControl($hWnd)
	Return HWnd(_SendMessage($hWnd, $CBEM_GETEDITCONTROL))
EndFunc   ;==>_GUICtrlComboBoxEx_GetEditControl

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_GetEditSel($hWnd)
	Local $hCombo = _GUICtrlComboBoxEx_GetComboControl($hWnd)
	Local $aResult = _GUICtrlComboBox_GetEditSel($hCombo)

	Return SetError(@error, @extended, $aResult)
EndFunc   ;==>_GUICtrlComboBoxEx_GetEditSel

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_GetEditText($hWnd)
	Local $hComboBox = _GUICtrlComboBoxEx_GetComboControl($hWnd)
	Return _GUICtrlComboBox_GetEditText($hComboBox)
EndFunc   ;==>_GUICtrlComboBoxEx_GetEditText

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_GetExtendedStyle($hWnd)
	Return _SendMessage($hWnd, $CBEM_GETEXTENDEDSTYLE)
EndFunc   ;==>_GUICtrlComboBoxEx_GetExtendedStyle

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_GetExtendedUI($hWnd)
	Return _GUICtrlComboBox_GetExtendedUI($hWnd)
EndFunc   ;==>_GUICtrlComboBoxEx_GetExtendedUI

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_GetImageList($hWnd)
	Return Ptr(_SendMessage($hWnd, $CBEM_GETIMAGELIST))
EndFunc   ;==>_GUICtrlComboBoxEx_GetImageList

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_GetItem($hWnd, $iIndex)
	Local $aItem[7], $sText

	Local $tItem = DllStructCreate($tagCOMBOBOXEXITEM)
	DllStructSetData($tItem, "Mask", BitOR($CBEIF_IMAGE, $CBEIF_INDENT, $CBEIF_LPARAM, $CBEIF_SELECTEDIMAGE, $CBEIF_OVERLAY))
	DllStructSetData($tItem, "Item", $iIndex)
	_GUICtrlComboBoxEx_GetItemEx($hWnd, $tItem)
	Local $iLen = _GUICtrlComboBoxEx_GetItemText($hWnd, $iIndex, $sText)
	$aItem[0] = $sText
	$aItem[1] = $iLen
	$aItem[2] = DllStructGetData($tItem, "Indent")
	$aItem[3] = DllStructGetData($tItem, "Image")
	$aItem[4] = DllStructGetData($tItem, "SelectedImage")
	$aItem[5] = DllStructGetData($tItem, "OverlayImage")
	$aItem[6] = DllStructGetData($tItem, "Param")
	Return $aItem
EndFunc   ;==>_GUICtrlComboBoxEx_GetItem

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_GetItemEx($hWnd, ByRef $tItem)
	Local $bUnicode = _GUICtrlComboBoxEx_GetUnicode($hWnd)

	Local $iRet
	If _WinAPI_InProcess($hWnd, $__g_hCBExLastWnd) Then
		$iRet = _SendMessage($hWnd, $CBEM_GETITEMW, 0, $tItem, 0, "wparam", "struct*")
	Else
		Local $iItem = DllStructGetSize($tItem)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iItem, $tMemMap)
		_MemWrite($tMemMap, $tItem)
		If $bUnicode Then
			$iRet = _SendMessage($hWnd, $CBEM_GETITEMW, 0, $pMemory, 0, "wparam", "ptr")
		Else
			$iRet = _SendMessage($hWnd, $CBEM_GETITEMA, 0, $pMemory, 0, "wparam", "ptr")
		EndIf
		_MemRead($tMemMap, $pMemory, $tItem, $iItem)
		_MemFree($tMemMap)
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlComboBoxEx_GetItemEx

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_GetItemHeight($hWnd, $iComponent = -1)
	Return _GUICtrlComboBox_GetItemHeight($hWnd, $iComponent)
EndFunc   ;==>_GUICtrlComboBoxEx_GetItemHeight

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_GetItemImage($hWnd, $iIndex)
	Local $tItem = DllStructCreate($tagCOMBOBOXEXITEM)
	DllStructSetData($tItem, "Mask", $CBEIF_IMAGE)
	DllStructSetData($tItem, "Item", $iIndex)
	_GUICtrlComboBoxEx_GetItemEx($hWnd, $tItem)
	Return DllStructGetData($tItem, "Image")
EndFunc   ;==>_GUICtrlComboBoxEx_GetItemImage

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_GetItemIndent($hWnd, $iIndex)
	Local $tItem = DllStructCreate($tagCOMBOBOXEXITEM)
	DllStructSetData($tItem, "Mask", $CBEIF_INDENT)
	DllStructSetData($tItem, "Item", $iIndex)
	_GUICtrlComboBoxEx_GetItemEx($hWnd, $tItem)
	Return DllStructGetData($tItem, "Indent")
EndFunc   ;==>_GUICtrlComboBoxEx_GetItemIndent

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_GetItemOverlayImage($hWnd, $iIndex)
	Local $tItem = DllStructCreate($tagCOMBOBOXEXITEM)
	DllStructSetData($tItem, "Mask", $CBEIF_OVERLAY)
	DllStructSetData($tItem, "Item", $iIndex)
	_GUICtrlComboBoxEx_GetItemEx($hWnd, $tItem)
	Return DllStructGetData($tItem, "OverlayImage")
EndFunc   ;==>_GUICtrlComboBoxEx_GetItemOverlayImage

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_GetItemParam($hWnd, $iIndex)
	Local $tItem = DllStructCreate($tagCOMBOBOXEXITEM)
	DllStructSetData($tItem, "Mask", $CBEIF_LPARAM)
	DllStructSetData($tItem, "Item", $iIndex)
	_GUICtrlComboBoxEx_GetItemEx($hWnd, $tItem)
	Return DllStructGetData($tItem, "Param")
EndFunc   ;==>_GUICtrlComboBoxEx_GetItemParam

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_GetItemSelectedImage($hWnd, $iIndex)
	Local $tItem = DllStructCreate($tagCOMBOBOXEXITEM)
	DllStructSetData($tItem, "Mask", $CBEIF_SELECTEDIMAGE)
	DllStructSetData($tItem, "Item", $iIndex)
	_GUICtrlComboBoxEx_GetItemEx($hWnd, $tItem)
	Return DllStructGetData($tItem, "SelectedImage")
EndFunc   ;==>_GUICtrlComboBoxEx_GetItemSelectedImage

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_GetItemText($hWnd, $iIndex, ByRef $sText)
	Return _GUICtrlComboBox_GetLBText($hWnd, $iIndex, $sText)
EndFunc   ;==>_GUICtrlComboBoxEx_GetItemText

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_GetItemTextLen($hWnd, $iIndex)
	Return _GUICtrlComboBox_GetLBTextLen($hWnd, $iIndex)
EndFunc   ;==>_GUICtrlComboBoxEx_GetItemTextLen

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_GetList($hWnd)
	Return _GUICtrlComboBox_GetList($hWnd)
EndFunc   ;==>_GUICtrlComboBoxEx_GetList

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_GetListArray($hWnd)
	Local $sDelimiter = Opt("GUIDataSeparatorChar")
	Return StringSplit(_GUICtrlComboBoxEx_GetList($hWnd), $sDelimiter)
EndFunc   ;==>_GUICtrlComboBoxEx_GetListArray

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_GetLocale($hWnd)
	Local $hCombo = _GUICtrlComboBoxEx_GetComboControl($hWnd)
	Return _GUICtrlComboBox_GetLocale($hCombo)
EndFunc   ;==>_GUICtrlComboBoxEx_GetLocale

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_GetLocaleCountry($hWnd)
	Return _WinAPI_HiWord(_GUICtrlComboBoxEx_GetLocale($hWnd))
EndFunc   ;==>_GUICtrlComboBoxEx_GetLocaleCountry

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_GetLocaleLang($hWnd)
	Return _WinAPI_LoWord(_GUICtrlComboBoxEx_GetLocale($hWnd))
EndFunc   ;==>_GUICtrlComboBoxEx_GetLocaleLang

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_GetLocalePrimLang($hWnd)
	Return _WinAPI_PrimaryLangId(_GUICtrlComboBoxEx_GetLocaleLang($hWnd))
EndFunc   ;==>_GUICtrlComboBoxEx_GetLocalePrimLang

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_GetLocaleSubLang($hWnd)
	Return _WinAPI_SubLangId(_GUICtrlComboBoxEx_GetLocaleLang($hWnd))
EndFunc   ;==>_GUICtrlComboBoxEx_GetLocaleSubLang

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_GetMinVisible($hWnd)
	Local $hCombo = _GUICtrlComboBoxEx_GetComboControl($hWnd)
	Return _GUICtrlComboBox_GetMinVisible($hCombo)
EndFunc   ;==>_GUICtrlComboBoxEx_GetMinVisible

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_GetTopIndex($hWnd)
	Local $hCombo = _GUICtrlComboBoxEx_GetComboControl($hWnd)
	Return _GUICtrlComboBox_GetTopIndex($hCombo)
EndFunc   ;==>_GUICtrlComboBoxEx_GetTopIndex

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_GetUnicode($hWnd)
	Return _SendMessage($hWnd, $CBEM_GETUNICODEFORMAT) <> 0
EndFunc   ;==>_GUICtrlComboBoxEx_GetUnicode

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _GUICtrlComboBoxEx_HasEditChanged
; Description ...: Determines whether the user has changed the text of a ComboBoxEx edit control
; Syntax.........: _GUICtrlComboBoxEx_HasEditChanged ( $hWnd )
; Parameters ....: $hWnd        - Handle to control
; Return values .: True         - Text in the control's edit box has changed
;                  False        - No change
; Author ........: Gary Frost (gafrost)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_HasEditChanged($hWnd)
	Local $tInfo
	If _GUICtrlComboBoxEx_GetComboBoxInfo($hWnd, $tInfo) Then
		Local $hEdit = DllStructGetData($tInfo, "hEdit")
		Return _SendMessage($hEdit, $CBEM_HASEDITCHANGED) <> 0
	Else
		Return False
	EndIf
EndFunc   ;==>_GUICtrlComboBoxEx_HasEditChanged

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_InitStorage($hWnd, $iNum, $iBytes)
	Local $hCombo = _GUICtrlComboBoxEx_GetComboControl($hWnd)
	Return _GUICtrlComboBox_InitStorage($hCombo, $iNum, $iBytes)
EndFunc   ;==>_GUICtrlComboBoxEx_InitStorage

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_InsertString($hWnd, $sText, $iIndex = -1, $iImage = -1, $iSelectedImage = -1, $iOverlayImage = -1, $iIndent = -1, $iParam = -1)
	Local $iBuffer = 0, $iMask, $iRet
	Local $bUnicode = _GUICtrlComboBoxEx_GetUnicode($hWnd)

	Local $tItem = DllStructCreate($tagCOMBOBOXEXITEM)
	If $sText <> -1 Then
		$iMask = BitOR($CBEIF_TEXT, $CBEIF_LPARAM)
		$iBuffer = StringLen($sText) + 1
		Local $tBuffer
		If $bUnicode Then
			$tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
			$iBuffer *= 2
		Else
			$tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
		EndIf
		DllStructSetData($tBuffer, "Text", $sText)
		DllStructSetData($tItem, "Text", DllStructGetPtr($tBuffer))
		DllStructSetData($tItem, "TextMax", $iBuffer)
	Else
		$iMask = BitOR($CBEIF_DI_SETITEM, $CBEIF_LPARAM)
	EndIf
	If $iImage >= 0 Then $iMask = BitOR($iMask, $CBEIF_IMAGE)
	If $iSelectedImage >= 0 Then $iMask = BitOR($iMask, $CBEIF_SELECTEDIMAGE)
	If $iOverlayImage >= 0 Then $iMask = BitOR($iMask, $CBEIF_OVERLAY)
	If $iIndent >= 1 Then $iMask = BitOR($iMask, $CBEIF_INDENT)
	If $iParam = -1 Then $iParam = _GUICtrlComboBoxEx_GetCount($hWnd)
	DllStructSetData($tItem, "Mask", $iMask)
	DllStructSetData($tItem, "Item", $iIndex)
	DllStructSetData($tItem, "Image", $iImage)
	DllStructSetData($tItem, "SelectedImage", $iSelectedImage)
	DllStructSetData($tItem, "OverlayImage", $iOverlayImage)
	DllStructSetData($tItem, "Indent", $iIndent)
	DllStructSetData($tItem, "Param", $iParam)
	If _WinAPI_InProcess($hWnd, $__g_hCBExLastWnd) Or ($sText = -1) Then
		$iRet = _SendMessage($hWnd, $CBEM_INSERTITEMW, 0, $tItem, 0, "wparam", "struct*")
	Else
		Local $iItem = DllStructGetSize($tItem)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iItem + $iBuffer, $tMemMap)
		Local $pText = $pMemory + $iItem
		DllStructSetData($tItem, "Text", $pText)
		_MemWrite($tMemMap, $tItem, $pMemory, $iItem)
		_MemWrite($tMemMap, $tBuffer, $pText, $iBuffer)
		If $bUnicode Then
			$iRet = _SendMessage($hWnd, $CBEM_INSERTITEMW, 0, $pMemory, 0, "wparam", "ptr")
		Else
			$iRet = _SendMessage($hWnd, $CBEM_INSERTITEMA, 0, $pMemory, 0, "wparam", "ptr")
		EndIf
		_MemFree($tMemMap)
	EndIf
	Return $iRet
EndFunc   ;==>_GUICtrlComboBoxEx_InsertString

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_LimitText($hWnd, $iLimit = 0)
	_SendMessage($hWnd, $CB_LIMITTEXT, $iLimit)
EndFunc   ;==>_GUICtrlComboBoxEx_LimitText

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_ReplaceEditSel($hWnd, $sText)
	Local $hCombo = _GUICtrlComboBoxEx_GetComboControl($hWnd)
	_GUICtrlComboBox_ReplaceEditSel($hCombo, $sText)
EndFunc   ;==>_GUICtrlComboBoxEx_ReplaceEditSel

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_ResetContent($hWnd)
	_SendMessage($hWnd, $CB_RESETCONTENT)
EndFunc   ;==>_GUICtrlComboBoxEx_ResetContent

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_SetCurSel($hWnd, $iIndex = -1)
	Return _SendMessage($hWnd, $CB_SETCURSEL, $iIndex)
EndFunc   ;==>_GUICtrlComboBoxEx_SetCurSel

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_SetDroppedWidth($hWnd, $iWidth)
	Local $hCombo = _GUICtrlComboBoxEx_GetComboControl($hWnd)
	Return _GUICtrlComboBox_SetDroppedWidth($hCombo, $iWidth)
EndFunc   ;==>_GUICtrlComboBoxEx_SetDroppedWidth

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_SetEditSel($hWnd, $iStart, $iStop)
	Local $hCombo = _GUICtrlComboBoxEx_GetComboControl($hWnd)
	Return _GUICtrlComboBox_SetEditSel($hCombo, $iStart, $iStop)
EndFunc   ;==>_GUICtrlComboBoxEx_SetEditSel

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_SetEditText($hWnd, $sText)
	Local $hComboBox = _GUICtrlComboBoxEx_GetComboControl($hWnd)
	_GUICtrlComboBox_SetEditSel($hComboBox, 0, -1)
	_GUICtrlComboBox_ReplaceEditSel($hComboBox, $sText)
EndFunc   ;==>_GUICtrlComboBoxEx_SetEditText

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_SetExtendedStyle($hWnd, $iExStyle, $iExMask = 0)
	Local $iRet = _SendMessage($hWnd, $CBEM_SETEXTENDEDSTYLE, $iExMask, $iExStyle)
	_WinAPI_InvalidateRect($hWnd)
	Return $iRet
EndFunc   ;==>_GUICtrlComboBoxEx_SetExtendedStyle

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_SetExtendedUI($hWnd, $bExtended = False)
	Local $hComboBox = _GUICtrlComboBoxEx_GetComboControl($hWnd)
	Return _SendMessage($hComboBox, $CB_SETEXTENDEDUI, $bExtended) = 0
EndFunc   ;==>_GUICtrlComboBoxEx_SetExtendedUI

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_SetImageList($hWnd, $hHandle)
	Local $hResult = _SendMessage($hWnd, $CBEM_SETIMAGELIST, 0, $hHandle, 0, "wparam", "handle", "handle")
	_SendMessage($hWnd, $__COMBOBOXEXCONSTANT_WM_SIZE)
	Return $hResult
EndFunc   ;==>_GUICtrlComboBoxEx_SetImageList

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_SetItem($hWnd, $sText, $iIndex = 0, $iImage = -1, $iSelectedImage = -1, $iOverlayImage = -1, $iIndent = -1, $iParam = -1)
	Local $iBuffer = StringLen($sText) + 1
	Local $tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
	Local $pBuffer = DllStructGetPtr($tBuffer)
	Local $tItem = DllStructCreate($tagCOMBOBOXEXITEM)
	Local $iMask = $CBEIF_TEXT
	If $iImage <> -1 Then $iMask = BitOR($iMask, $CBEIF_IMAGE)
	If $iSelectedImage <> -1 Then $iMask = BitOR($iMask, $CBEIF_SELECTEDIMAGE)
	If $iOverlayImage <> -1 Then $iMask = BitOR($iMask, $CBEIF_OVERLAY)
	If $iParam <> -1 Then $iMask = BitOR($iMask, $CBEIF_LPARAM)
	If $iIndent <> -1 Then $iMask = BitOR($iMask, $CBEIF_INDENT)
	DllStructSetData($tBuffer, "Text", $sText)
	DllStructSetData($tItem, "Mask", $iMask)
	DllStructSetData($tItem, "Item", $iIndex)
	DllStructSetData($tItem, "Text", $pBuffer)
	DllStructSetData($tItem, "TextMax", $iBuffer * 2)
	DllStructSetData($tItem, "Image", $iImage)
	DllStructSetData($tItem, "Param", $iParam)
	DllStructSetData($tItem, "Indent", $iIndent)
	DllStructSetData($tItem, "SelectedImage", $iSelectedImage)
	DllStructSetData($tItem, "OverlayImage", $iOverlayImage)
	Return _GUICtrlComboBoxEx_SetItemEx($hWnd, $tItem)
EndFunc   ;==>_GUICtrlComboBoxEx_SetItem

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_SetItemEx($hWnd, ByRef $tItem)
	Local $iItem = DllStructGetSize($tItem)
	Local $iBuffer = DllStructGetData($tItem, "TextMax")
	If $iBuffer = 0 Then $iBuffer = 1
	Local $pBuffer = DllStructGetData($tItem, "Text")
	Local $tMemMap
	Local $pMemory = _MemInit($hWnd, $iItem + $iBuffer, $tMemMap)
	Local $pText = $pMemory + $iItem
	DllStructSetData($tItem, "Text", $pText)
	_MemWrite($tMemMap, $tItem, $pMemory, $iItem)
	If $pBuffer <> 0 Then _MemWrite($tMemMap, $pBuffer, $pText, $iBuffer)
	Local $iRet = _SendMessage($hWnd, $CBEM_SETITEMW, 0, $pMemory, 0, "wparam", "ptr")
	_MemFree($tMemMap)

	Return $iRet <> 0
EndFunc   ;==>_GUICtrlComboBoxEx_SetItemEx

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_SetItemHeight($hWnd, $iComponent, $iHeight)
	Return _SendMessage($hWnd, $CB_SETITEMHEIGHT, $iComponent, $iHeight)
EndFunc   ;==>_GUICtrlComboBoxEx_SetItemHeight

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_SetItemImage($hWnd, $iIndex, $iImage)
	Local $tItem = DllStructCreate($tagCOMBOBOXEXITEM)
	DllStructSetData($tItem, "Mask", $CBEIF_IMAGE)
	DllStructSetData($tItem, "Item", $iIndex)
	DllStructSetData($tItem, "Image", $iImage)
	Return _GUICtrlComboBoxEx_SetItemEx($hWnd, $tItem)
EndFunc   ;==>_GUICtrlComboBoxEx_SetItemImage

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_SetItemIndent($hWnd, $iIndex, $iIndent)
	Local $tItem = DllStructCreate($tagCOMBOBOXEXITEM)
	DllStructSetData($tItem, "Mask", $CBEIF_INDENT)
	DllStructSetData($tItem, "Item", $iIndex)
	DllStructSetData($tItem, "Indent", $iIndent)
	Return _GUICtrlComboBoxEx_SetItemEx($hWnd, $tItem)
EndFunc   ;==>_GUICtrlComboBoxEx_SetItemIndent

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_SetItemOverlayImage($hWnd, $iIndex, $iImage)
	Local $tItem = DllStructCreate($tagCOMBOBOXEXITEM)
	DllStructSetData($tItem, "Mask", $CBEIF_OVERLAY)
	DllStructSetData($tItem, "Item", $iIndex)
	DllStructSetData($tItem, "OverlayImage", $iImage)
	Return _GUICtrlComboBoxEx_SetItemEx($hWnd, $tItem)
EndFunc   ;==>_GUICtrlComboBoxEx_SetItemOverlayImage

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_SetItemParam($hWnd, $iIndex, $iParam)
	Local $tItem = DllStructCreate($tagCOMBOBOXEXITEM)
	DllStructSetData($tItem, "Mask", $CBEIF_LPARAM)
	DllStructSetData($tItem, "Item", $iIndex)
	DllStructSetData($tItem, "Param", $iParam)
	Return _GUICtrlComboBoxEx_SetItemEx($hWnd, $tItem)
EndFunc   ;==>_GUICtrlComboBoxEx_SetItemParam

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_SetItemSelectedImage($hWnd, $iIndex, $iImage)
	Local $tItem = DllStructCreate($tagCOMBOBOXEXITEM)
	DllStructSetData($tItem, "Mask", $CBEIF_SELECTEDIMAGE)
	DllStructSetData($tItem, "Item", $iIndex)
	DllStructSetData($tItem, "SelectedImage", $iImage)
	Return _GUICtrlComboBoxEx_SetItemEx($hWnd, $tItem)
EndFunc   ;==>_GUICtrlComboBoxEx_SetItemSelectedImage

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_SetMinVisible($hWnd, $iMinimum)
	Local $hCombo = _GUICtrlComboBoxEx_GetComboControl($hWnd)
	Return _GUICtrlComboBox_SetMinVisible($hCombo, $iMinimum)
EndFunc   ;==>_GUICtrlComboBoxEx_SetMinVisible

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_SetTopIndex($hWnd, $iIndex)
	Local $hCombo = _GUICtrlComboBoxEx_GetComboControl($hWnd)
	Return _GUICtrlComboBox_SetTopIndex($hCombo, $iIndex)
EndFunc   ;==>_GUICtrlComboBoxEx_SetTopIndex

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_SetUnicode($hWnd, $bUnicode = True)
	Local $iUnicode = _SendMessage($hWnd, $CBEM_SETUNICODEFORMAT, $bUnicode) <> 0
	Return $iUnicode <> $bUnicode
EndFunc   ;==>_GUICtrlComboBoxEx_SetUnicode

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlComboBoxEx_ShowDropDown($hWnd, $bShow = False)
	_GUICtrlComboBox_ShowDropDown($hWnd, $bShow)
EndFunc   ;==>_GUICtrlComboBoxEx_ShowDropDown
