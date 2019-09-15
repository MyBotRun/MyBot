#include-once

#include "DirConstants.au3"
#include "ListBoxConstants.au3"
#include "SendMessage.au3"
#include "UDFGlobalID.au3"
#include "WinAPI.au3"

; #INDEX# =======================================================================================================================
; Title .........: ListBox
; AutoIt Version : 3.3.14.2
; Language ......: English
; Description ...: Functions that assist with ListBox control management.
; Author(s) .....: Paul Campbell (PaulIA)
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
Global $__g_hLBLastWnd

; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $__LISTBOXCONSTANT_ClassName = "ListBox"
Global Const $__LISTBOXCONSTANT_ClassNames = $__LISTBOXCONSTANT_ClassName & "|TListbox"
Global Const $__LISTBOXCONSTANT_DEFAULT_GUI_FONT = 17
Global Const $__LISTBOXCONSTANT_WM_SETREDRAW = 0x000B
Global Const $__LISTBOXCONSTANT_WM_GETFONT = 0x0031
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _GUICtrlListBox_AddFile
; _GUICtrlListBox_AddString
; _GUICtrlListBox_BeginUpdate
; _GUICtrlListBox_ClickItem
; _GUICtrlListBox_Create
; _GUICtrlListBox_DeleteString
; _GUICtrlListBox_Destroy
; _GUICtrlListBox_Dir
; _GUICtrlListBox_EndUpdate
; _GUICtrlListBox_FindString
; _GUICtrlListBox_FindInText
; _GUICtrlListBox_GetAnchorIndex
; _GUICtrlListBox_GetCaretIndex
; _GUICtrlListBox_GetCount
; _GUICtrlListBox_GetCurSel
; _GUICtrlListBox_GetHorizontalExtent
; _GUICtrlListBox_GetItemData
; _GUICtrlListBox_GetItemHeight
; _GUICtrlListBox_GetItemRect
; _GUICtrlListBox_GetItemRectEx
; _GUICtrlListBox_GetListBoxInfo
; _GUICtrlListBox_GetLocale
; _GUICtrlListBox_GetLocaleCountry
; _GUICtrlListBox_GetLocaleLang
; _GUICtrlListBox_GetLocalePrimLang
; _GUICtrlListBox_GetLocaleSubLang
; _GUICtrlListBox_GetSel
; _GUICtrlListBox_GetSelCount
; _GUICtrlListBox_GetSelItems
; _GUICtrlListBox_GetSelItemsText
; _GUICtrlListBox_GetText
; _GUICtrlListBox_GetTextLen
; _GUICtrlListBox_GetTopIndex
; _GUICtrlListBox_InitStorage
; _GUICtrlListBox_InsertString
; _GUICtrlListBox_ItemFromPoint
; _GUICtrlListBox_ReplaceString
; _GUICtrlListBox_ResetContent
; _GUICtrlListBox_SelectString
; _GUICtrlListBox_SelItemRange
; _GUICtrlListBox_SelItemRangeEx
; _GUICtrlListBox_SetAnchorIndex
; _GUICtrlListBox_SetCaretIndex
; _GUICtrlListBox_SetColumnWidth
; _GUICtrlListBox_SetCurSel
; _GUICtrlListBox_SetHorizontalExtent
; _GUICtrlListBox_SetItemData
; _GUICtrlListBox_SetItemHeight
; _GUICtrlListBox_SetLocale
; _GUICtrlListBox_SetSel
; _GUICtrlListBox_SetTabStops
; _GUICtrlListBox_SetTopIndex
; _GUICtrlListBox_Sort
; _GUICtrlListBox_SwapString
; _GUICtrlListBox_UpdateHScroll
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListBox_AddFile($hWnd, $sFilePath)
	If Not IsString($sFilePath) Then $sFilePath = String($sFilePath)

	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LB_ADDFILE, 0, $sFilePath, 0, "wparam", "wstr")
	Else
		Return GUICtrlSendMsg($hWnd, $LB_ADDFILE, 0, $sFilePath)
	EndIf
EndFunc   ;==>_GUICtrlListBox_AddFile

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListBox_AddString($hWnd, $sText)
	If Not IsString($sText) Then $sText = String($sText)

	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LB_ADDSTRING, 0, $sText, 0, "wparam", "wstr")
	Else
		Return GUICtrlSendMsg($hWnd, $LB_ADDSTRING, 0, $sText)
	EndIf
EndFunc   ;==>_GUICtrlListBox_AddString

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListBox_BeginUpdate($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $__LISTBOXCONSTANT_WM_SETREDRAW, False) = 0
EndFunc   ;==>_GUICtrlListBox_BeginUpdate

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListBox_ClickItem($hWnd, $iIndex, $sButton = "left", $bMove = False, $iClicks = 1, $iSpeed = 0)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $tRECT = _GUICtrlListBox_GetItemRectEx($hWnd, $iIndex)
	Local $tPoint = _WinAPI_PointFromRect($tRECT)
	$tPoint = _WinAPI_ClientToScreen($hWnd, $tPoint)
	Local $iX, $iY
	_WinAPI_GetXYFromPoint($tPoint, $iX, $iY)
	Local $iMode = Opt("MouseCoordMode", 1)
	If Not $bMove Then
		Local $aPos = MouseGetPos()
		_WinAPI_ShowCursor(False)
		MouseClick($sButton, $iX, $iY, $iClicks, $iSpeed)
		MouseMove($aPos[0], $aPos[1], 0)
		_WinAPI_ShowCursor(True)
	Else
		MouseClick($sButton, $iX, $iY, $iClicks, $iSpeed)
	EndIf
	Opt("MouseCoordMode", $iMode)
EndFunc   ;==>_GUICtrlListBox_ClickItem

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlListBox_Create($hWnd, $sText, $iX, $iY, $iWidth = 100, $iHeight = 200, $iStyle = 0x00B00002, $iExStyle = 0x00000200)
	If Not IsHWnd($hWnd) Then
		; Invalid Window handle for _GUICtrlListBox_Create 1st parameter
		Return SetError(1, 0, 0)
	EndIf
	If Not IsString($sText) Then
		; 2nd parameter not a string for _GUICtrlListBox_Create
		Return SetError(2, 0, 0)
	EndIf

	If $iWidth = -1 Then $iWidth = 100
	If $iHeight = -1 Then $iHeight = 200
	Local Const $WS_VSCROLL = 0x00200000, $WS_HSCROLL = 0x00100000, $WS_BORDER = 0x00800000
	If $iStyle = -1 Then $iStyle = BitOR($WS_BORDER, $WS_VSCROLL, $WS_HSCROLL, $LBS_SORT)
	If $iExStyle = -1 Then $iExStyle = 0x00000200

	$iStyle = BitOR($iStyle, $__UDFGUICONSTANT_WS_VISIBLE, $__UDFGUICONSTANT_WS_TABSTOP, $__UDFGUICONSTANT_WS_CHILD, $LBS_NOTIFY)

	Local $nCtrlID = __UDF_GetNextGlobalID($hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Local $hList = _WinAPI_CreateWindowEx($iExStyle, $__LISTBOXCONSTANT_ClassName, "", $iStyle, $iX, $iY, $iWidth, $iHeight, $hWnd, $nCtrlID)
	_WinAPI_SetFont($hList, _WinAPI_GetStockObject($__LISTBOXCONSTANT_DEFAULT_GUI_FONT))
	If StringLen($sText) Then _GUICtrlListBox_AddString($hList, $sText)
	Return $hList
EndFunc   ;==>_GUICtrlListBox_Create

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListBox_DeleteString($hWnd, $iIndex)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LB_DELETESTRING, $iIndex)
	Else
		Return GUICtrlSendMsg($hWnd, $LB_DELETESTRING, $iIndex, 0)
	EndIf
EndFunc   ;==>_GUICtrlListBox_DeleteString

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListBox_Destroy(ByRef $hWnd)
	;If Not _WinAPI_IsClassName($hWnd, $__LISTBOXCONSTANT_ClassNames) Then Return SetError(2, 2, False)

	Local $iDestroyed = 0
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLBLastWnd) Then
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
EndFunc   ;==>_GUICtrlListBox_Destroy

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost), CyberSlug
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListBox_Dir($hWnd, $sFilePath, $iAttributes = 0, $bBrackets = True)
	If Not IsString($sFilePath) Then $sFilePath = String($sFilePath)

	If BitAND($iAttributes, $DDL_DRIVES) = $DDL_DRIVES And Not $bBrackets Then
		Local $sText
		Local $hGui_no_brackets = GUICreate("no brackets")
		Local $idList_no_brackets = GUICtrlCreateList("", 240, 40, 120, 120)
		Local $iRet = GUICtrlSendMsg($idList_no_brackets, $LB_DIR, $iAttributes, $sFilePath)
		For $i = 0 To _GUICtrlListBox_GetCount($idList_no_brackets) - 1
			$sText = _GUICtrlListBox_GetText($idList_no_brackets, $i)
			$sText = StringReplace(StringReplace(StringReplace($sText, "[", ""), "]", ":"), "-", "")
			_GUICtrlListBox_InsertString($hWnd, $sText)
		Next
		GUIDelete($hGui_no_brackets)
		Return $iRet
	Else
		If IsHWnd($hWnd) Then
			Return _SendMessage($hWnd, $LB_DIR, $iAttributes, $sFilePath, 0, "wparam", "wstr")
		Else
			Return GUICtrlSendMsg($hWnd, $LB_DIR, $iAttributes, $sFilePath)
		EndIf
	EndIf
EndFunc   ;==>_GUICtrlListBox_Dir

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListBox_EndUpdate($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $__LISTBOXCONSTANT_WM_SETREDRAW, True) = 0
EndFunc   ;==>_GUICtrlListBox_EndUpdate

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListBox_FindString($hWnd, $sText, $bExact = False)
	If Not IsString($sText) Then $sText = String($sText)

	If IsHWnd($hWnd) Then
		If ($bExact) Then
			Return _SendMessage($hWnd, $LB_FINDSTRINGEXACT, -1, $sText, 0, "wparam", "wstr")
		Else
			Return _SendMessage($hWnd, $LB_FINDSTRING, -1, $sText, 0, "wparam", "wstr")
		EndIf
	Else
		If ($bExact) Then
			Return GUICtrlSendMsg($hWnd, $LB_FINDSTRINGEXACT, -1, $sText)
		Else
			Return GUICtrlSendMsg($hWnd, $LB_FINDSTRING, -1, $sText)
		EndIf
	EndIf
EndFunc   ;==>_GUICtrlListBox_FindString

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListBox_FindInText($hWnd, $sText, $iStart = -1, $bWrapOK = True)
	Local $sList

	Local $iCount = _GUICtrlListBox_GetCount($hWnd)
	For $iI = $iStart + 1 To $iCount - 1
		$sList = _GUICtrlListBox_GetText($hWnd, $iI)
		If StringInStr($sList, $sText) Then Return $iI
	Next

	If ($iStart = -1) Or Not $bWrapOK Then Return -1
	For $iI = 0 To $iStart - 1
		$sList = _GUICtrlListBox_GetText($hWnd, $iI)
		If StringInStr($sList, $sText) Then Return $iI
	Next

	Return -1
EndFunc   ;==>_GUICtrlListBox_FindInText

; #FUNCTION# ====================================================================================================================
; Author ........: CyberSlug
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListBox_GetAnchorIndex($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LB_GETANCHORINDEX)
	Else
		Return GUICtrlSendMsg($hWnd, $LB_GETANCHORINDEX, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListBox_GetAnchorIndex

; #FUNCTION# ====================================================================================================================
; Author ........: CyberSlug
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListBox_GetCaretIndex($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LB_GETCARETINDEX)
	Else
		Return GUICtrlSendMsg($hWnd, $LB_GETCARETINDEX, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListBox_GetCaretIndex

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListBox_GetCount($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LB_GETCOUNT)
	Else
		Return GUICtrlSendMsg($hWnd, $LB_GETCOUNT, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListBox_GetCount

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListBox_GetCurSel($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LB_GETCURSEL)
	Else
		Return GUICtrlSendMsg($hWnd, $LB_GETCURSEL, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListBox_GetCurSel

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListBox_GetHorizontalExtent($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LB_GETHORIZONTALEXTENT)
	Else
		Return GUICtrlSendMsg($hWnd, $LB_GETHORIZONTALEXTENT, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListBox_GetHorizontalExtent

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListBox_GetItemData($hWnd, $iIndex)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LB_GETITEMDATA, $iIndex)
	Else
		Return GUICtrlSendMsg($hWnd, $LB_GETITEMDATA, $iIndex, 0)
	EndIf
EndFunc   ;==>_GUICtrlListBox_GetItemData

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListBox_GetItemHeight($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LB_GETITEMHEIGHT)
	Else
		Return GUICtrlSendMsg($hWnd, $LB_GETITEMHEIGHT, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListBox_GetItemHeight

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListBox_GetItemRect($hWnd, $iIndex)
	Local $aRect[4]

	Local $tRECT = _GUICtrlListBox_GetItemRectEx($hWnd, $iIndex)
	$aRect[0] = DllStructGetData($tRECT, "Left")
	$aRect[1] = DllStructGetData($tRECT, "Top")
	$aRect[2] = DllStructGetData($tRECT, "Right")
	$aRect[3] = DllStructGetData($tRECT, "Bottom")
	Return $aRect
EndFunc   ;==>_GUICtrlListBox_GetItemRect

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListBox_GetItemRectEx($hWnd, $iIndex)
	Local $tRECT = DllStructCreate($tagRECT)
	If IsHWnd($hWnd) Then
		_SendMessage($hWnd, $LB_GETITEMRECT, $iIndex, $tRECT, 0, "wparam", "struct*")
	Else
		GUICtrlSendMsg($hWnd, $LB_GETITEMRECT, $iIndex, DllStructGetPtr($tRECT))
	EndIf
	Return $tRECT
EndFunc   ;==>_GUICtrlListBox_GetItemRectEx

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListBox_GetListBoxInfo($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LB_GETLISTBOXINFO)
	Else
		Return GUICtrlSendMsg($hWnd, $LB_GETLISTBOXINFO, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListBox_GetListBoxInfo

; #FUNCTION# ====================================================================================================================
; Author ........: CyberSlug
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListBox_GetLocale($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LB_GETLOCALE)
	Else
		Return GUICtrlSendMsg($hWnd, $LB_GETLOCALE, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListBox_GetLocale

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListBox_GetLocaleCountry($hWnd)
	Return _WinAPI_HiWord(_GUICtrlListBox_GetLocale($hWnd))
EndFunc   ;==>_GUICtrlListBox_GetLocaleCountry

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListBox_GetLocaleLang($hWnd)
	Return _WinAPI_LoWord(_GUICtrlListBox_GetLocale($hWnd))
EndFunc   ;==>_GUICtrlListBox_GetLocaleLang

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListBox_GetLocalePrimLang($hWnd)
	Return _WinAPI_PrimaryLangId(_GUICtrlListBox_GetLocaleLang($hWnd))
EndFunc   ;==>_GUICtrlListBox_GetLocalePrimLang

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListBox_GetLocaleSubLang($hWnd)
	Return _WinAPI_SubLangId(_GUICtrlListBox_GetLocaleLang($hWnd))
EndFunc   ;==>_GUICtrlListBox_GetLocaleSubLang

; #FUNCTION# ====================================================================================================================
; Author ........: CyberSlug
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListBox_GetSel($hWnd, $iIndex)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LB_GETSEL, $iIndex) <> 0
	Else
		Return GUICtrlSendMsg($hWnd, $LB_GETSEL, $iIndex, 0) <> 0
	EndIf
EndFunc   ;==>_GUICtrlListBox_GetSel

; #FUNCTION# ====================================================================================================================
; Author ........: CyberSlug
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListBox_GetSelCount($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LB_GETSELCOUNT)
	Else
		Return GUICtrlSendMsg($hWnd, $LB_GETSELCOUNT, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListBox_GetSelCount

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListBox_GetSelItems($hWnd)
	Local $aArray[1] = [0]

	Local $iCount = _GUICtrlListBox_GetSelCount($hWnd)
	If $iCount > 0 Then
		ReDim $aArray[$iCount + 1]
		Local $tArray = DllStructCreate("int[" & $iCount & "]")
		If IsHWnd($hWnd) Then
			_SendMessage($hWnd, $LB_GETSELITEMS, $iCount, $tArray, 0, "wparam", "struct*")
		Else
			GUICtrlSendMsg($hWnd, $LB_GETSELITEMS, $iCount, DllStructGetPtr($tArray))
		EndIf
		$aArray[0] = $iCount
		For $iI = 1 To $iCount
			$aArray[$iI] = DllStructGetData($tArray, 1, $iI)
		Next
	EndIf
	Return $aArray
EndFunc   ;==>_GUICtrlListBox_GetSelItems

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost), CyberSlug
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListBox_GetSelItemsText($hWnd)
	Local $aText[1] = [0], $iCount = _GUICtrlListBox_GetSelCount($hWnd)
	If $iCount > 0 Then
		Local $aIndices = _GUICtrlListBox_GetSelItems($hWnd)
		ReDim $aText[UBound($aIndices)]
		$aText[0] = $aIndices[0]
		For $i = 1 To $aIndices[0]
			$aText[$i] = _GUICtrlListBox_GetText($hWnd, $aIndices[$i])
		Next
	EndIf
	Return $aText
EndFunc   ;==>_GUICtrlListBox_GetSelItemsText

; #FUNCTION# ====================================================================================================================
; Author ........: CyberSlug
; Modified.......: Gary Frost (gafrost
; ===============================================================================================================================
Func _GUICtrlListBox_GetText($hWnd, $iIndex)
	Local $tText = DllStructCreate("wchar Text[" & _GUICtrlListBox_GetTextLen($hWnd, $iIndex) + 1 & "]")
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	_SendMessage($hWnd, $LB_GETTEXT, $iIndex, $tText, 0, "wparam", "struct*")
	Return DllStructGetData($tText, "Text")
EndFunc   ;==>_GUICtrlListBox_GetText

; #FUNCTION# ====================================================================================================================
; Author ........: CyberSlug
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListBox_GetTextLen($hWnd, $iIndex)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LB_GETTEXTLEN, $iIndex)
	Else
		Return GUICtrlSendMsg($hWnd, $LB_GETTEXTLEN, $iIndex, 0)
	EndIf
EndFunc   ;==>_GUICtrlListBox_GetTextLen

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost), CyberSlug
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListBox_GetTopIndex($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LB_GETTOPINDEX)
	Else
		Return GUICtrlSendMsg($hWnd, $LB_GETTOPINDEX, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListBox_GetTopIndex

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListBox_InitStorage($hWnd, $iItems, $iBytes)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LB_INITSTORAGE, $iItems, $iBytes)
	Else
		Return GUICtrlSendMsg($hWnd, $LB_INITSTORAGE, $iItems, $iBytes)
	EndIf
EndFunc   ;==>_GUICtrlListBox_InitStorage

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListBox_InsertString($hWnd, $sText, $iIndex = -1)
	If Not IsString($sText) Then $sText = String($sText)

	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LB_INSERTSTRING, $iIndex, $sText, 0, "wparam", "wstr")
	Else
		Return GUICtrlSendMsg($hWnd, $LB_INSERTSTRING, $iIndex, $sText)
	EndIf
EndFunc   ;==>_GUICtrlListBox_InsertString

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListBox_ItemFromPoint($hWnd, $iX, $iY)
	Local $iRet

	If IsHWnd($hWnd) Then
		$iRet = _SendMessage($hWnd, $LB_ITEMFROMPOINT, 0, _WinAPI_MakeLong($iX, $iY))
	Else
		$iRet = GUICtrlSendMsg($hWnd, $LB_ITEMFROMPOINT, 0, _WinAPI_MakeLong($iX, $iY))
	EndIf

	If _WinAPI_HiWord($iRet) <> 0 Then $iRet = -1
	Return $iRet
EndFunc   ;==>_GUICtrlListBox_ItemFromPoint

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost), CyberSlug
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListBox_ReplaceString($hWnd, $iIndex, $sText)
	If (_GUICtrlListBox_DeleteString($hWnd, $iIndex) == $LB_ERR) Then Return SetError($LB_ERR, $LB_ERR, False)
	If (_GUICtrlListBox_InsertString($hWnd, $sText, $iIndex) == $LB_ERR) Then Return SetError($LB_ERR, $LB_ERR, False)
	Return True
EndFunc   ;==>_GUICtrlListBox_ReplaceString

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListBox_ResetContent($hWnd)
	If IsHWnd($hWnd) Then
		_SendMessage($hWnd, $LB_RESETCONTENT)
	Else
		GUICtrlSendMsg($hWnd, $LB_RESETCONTENT, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListBox_ResetContent

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListBox_SelectString($hWnd, $sText, $iIndex = -1)
	If Not IsString($sText) Then $sText = String($sText)

	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LB_SELECTSTRING, $iIndex, $sText, 0, "wparam", "wstr")
	Else
		Return GUICtrlSendMsg($hWnd, $LB_SELECTSTRING, $iIndex, $sText)
	EndIf
EndFunc   ;==>_GUICtrlListBox_SelectString

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost), CyberSlug
; Modified.......: Gary Frost (gafrost, re-written
; ===============================================================================================================================
Func _GUICtrlListBox_SelItemRange($hWnd, $iFirst, $iLast, $bSelect = True)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LB_SELITEMRANGE, $bSelect, _WinAPI_MakeLong($iFirst, $iLast)) = 0
	Else
		Return GUICtrlSendMsg($hWnd, $LB_SELITEMRANGE, $bSelect, _WinAPI_MakeLong($iFirst, $iLast)) = 0
	EndIf
EndFunc   ;==>_GUICtrlListBox_SelItemRange

; #FUNCTION# ====================================================================================================================
; Author ........: CyberSlug
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListBox_SelItemRangeEx($hWnd, $iFirst, $iLast)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LB_SELITEMRANGEEX, $iFirst, $iLast) = 0
	Else
		Return GUICtrlSendMsg($hWnd, $LB_SELITEMRANGEEX, $iFirst, $iLast) = 0
	EndIf
EndFunc   ;==>_GUICtrlListBox_SelItemRangeEx

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListBox_SetAnchorIndex($hWnd, $iIndex)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LB_SETANCHORINDEX, $iIndex) = 0
	Else
		Return GUICtrlSendMsg($hWnd, $LB_SETANCHORINDEX, $iIndex, 0) = 0
	EndIf
EndFunc   ;==>_GUICtrlListBox_SetAnchorIndex

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListBox_SetCaretIndex($hWnd, $iIndex, $bPartial = False)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LB_SETCARETINDEX, $iIndex, $bPartial) = 0
	Else
		Return GUICtrlSendMsg($hWnd, $LB_SETCARETINDEX, $iIndex, $bPartial) = 0
	EndIf
EndFunc   ;==>_GUICtrlListBox_SetCaretIndex

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListBox_SetColumnWidth($hWnd, $iWidth)
	If IsHWnd($hWnd) Then
		_SendMessage($hWnd, $LB_SETCOLUMNWIDTH, $iWidth)
	Else
		GUICtrlSendMsg($hWnd, $LB_SETCOLUMNWIDTH, $iWidth, 0)
	EndIf
EndFunc   ;==>_GUICtrlListBox_SetColumnWidth

; #FUNCTION# ====================================================================================================================
; Author ........: Sokko
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListBox_SetCurSel($hWnd, $iIndex)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LB_SETCURSEL, $iIndex)
	Else
		Return GUICtrlSendMsg($hWnd, $LB_SETCURSEL, $iIndex, 0)
	EndIf
EndFunc   ;==>_GUICtrlListBox_SetCurSel

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListBox_SetHorizontalExtent($hWnd, $iWidth)
	If IsHWnd($hWnd) Then
		_SendMessage($hWnd, $LB_SETHORIZONTALEXTENT, $iWidth)
	Else
		GUICtrlSendMsg($hWnd, $LB_SETHORIZONTALEXTENT, $iWidth, 0)
	EndIf
EndFunc   ;==>_GUICtrlListBox_SetHorizontalExtent

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListBox_SetItemData($hWnd, $iIndex, $iValue)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LB_SETITEMDATA, $iIndex, $iValue) <> -1
	Else
		Return GUICtrlSendMsg($hWnd, $LB_SETITEMDATA, $iIndex, $iValue) <> -1
	EndIf
EndFunc   ;==>_GUICtrlListBox_SetItemData

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListBox_SetItemHeight($hWnd, $iHeight, $iIndex = 0)
	Local $iRet

	If IsHWnd($hWnd) Then
		$iRet = _SendMessage($hWnd, $LB_SETITEMHEIGHT, $iIndex, $iHeight)
		_WinAPI_InvalidateRect($hWnd)
	Else
		$iRet = GUICtrlSendMsg($hWnd, $LB_SETITEMHEIGHT, $iIndex, $iHeight)
		_WinAPI_InvalidateRect(GUICtrlGetHandle($hWnd))
	EndIf
	Return $iRet <> -1
EndFunc   ;==>_GUICtrlListBox_SetItemHeight

; #FUNCTION# ====================================================================================================================
; Author ........: CyberSlug
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListBox_SetLocale($hWnd, $iLocal)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LB_SETLOCALE, $iLocal)
	Else
		Return GUICtrlSendMsg($hWnd, $LB_SETLOCALE, $iLocal, 0)
	EndIf
EndFunc   ;==>_GUICtrlListBox_SetLocale

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost), CyberSlug
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListBox_SetSel($hWnd, $iIndex = -1, $iSelect = -1)
	Local $i_Ret = 1
	If IsHWnd($hWnd) Then
		If $iIndex == -1 Then ; toggle all
			For $iIndex = 0 To _GUICtrlListBox_GetCount($hWnd) - 1
				$i_Ret = _GUICtrlListBox_GetSel($hWnd, $iIndex)
				If ($i_Ret == $LB_ERR) Then Return SetError($LB_ERR, $LB_ERR, False)
				If ($i_Ret > 0) Then ;If Selected Then
					$i_Ret = _SendMessage($hWnd, $LB_SETSEL, False, $iIndex) <> -1
				Else
					$i_Ret = _SendMessage($hWnd, $LB_SETSEL, True, $iIndex) <> -1
				EndIf
				If ($i_Ret == False) Then Return SetError($LB_ERR, $LB_ERR, False)
			Next
		ElseIf $iSelect == -1 Then ; toggle state of index
			If _GUICtrlListBox_GetSel($hWnd, $iIndex) Then ;If Selected Then
				Return _SendMessage($hWnd, $LB_SETSEL, False, $iIndex) <> -1
			Else
				Return _SendMessage($hWnd, $LB_SETSEL, True, $iIndex) <> -1
			EndIf
		Else ; set state according to flag
			Return _SendMessage($hWnd, $LB_SETSEL, $iSelect, $iIndex) <> -1
		EndIf
	Else
		If $iIndex == -1 Then ; toggle all
			For $iIndex = 0 To _GUICtrlListBox_GetCount($hWnd) - 1
				$i_Ret = _GUICtrlListBox_GetSel($hWnd, $iIndex)
				If ($i_Ret == $LB_ERR) Then Return SetError($LB_ERR, $LB_ERR, False)
				If ($i_Ret > 0) Then ;If Selected Then
					$i_Ret = GUICtrlSendMsg($hWnd, $LB_SETSEL, False, $iIndex) <> -1
				Else
					$i_Ret = GUICtrlSendMsg($hWnd, $LB_SETSEL, True, $iIndex) <> -1
				EndIf
				If ($i_Ret == 0) Then Return SetError($LB_ERR, $LB_ERR, False)
			Next
		ElseIf $iSelect == -1 Then ; toggle state of index
			If _GUICtrlListBox_GetSel($hWnd, $iIndex) Then ;If Selected Then
				Return GUICtrlSendMsg($hWnd, $LB_SETSEL, False, $iIndex) <> -1
			Else
				Return GUICtrlSendMsg($hWnd, $LB_SETSEL, True, $iIndex) <> -1
			EndIf
		Else ; set state according to flag
			Return GUICtrlSendMsg($hWnd, $LB_SETSEL, $iSelect, $iIndex) <> -1
		EndIf
	EndIf
	Return $i_Ret <> 0
EndFunc   ;==>_GUICtrlListBox_SetSel

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListBox_SetTabStops($hWnd, $aTabStops)
	Local $iCount = $aTabStops[0]
	Local $tTabStops = DllStructCreate("int[" & $iCount & "]")
	For $iI = 1 To $iCount
		DllStructSetData($tTabStops, 1, $aTabStops[$iI], $iI)
	Next
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LB_SETTABSTOPS, $iCount, $tTabStops, 0, "wparam", "struct*") = 0
	Else
		Return GUICtrlSendMsg($hWnd, $LB_SETTABSTOPS, $iCount, DllStructGetPtr($tTabStops)) = 0
	EndIf
EndFunc   ;==>_GUICtrlListBox_SetTabStops

; #FUNCTION# ====================================================================================================================
; Author ........: CyberSlug
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListBox_SetTopIndex($hWnd, $iIndex)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LB_SETTOPINDEX, $iIndex) <> -1
	Else
		Return GUICtrlSendMsg($hWnd, $LB_SETTOPINDEX, $iIndex, 0) <> -1
	EndIf
EndFunc   ;==>_GUICtrlListBox_SetTopIndex

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost), CyberSlug
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListBox_Sort($hWnd)
	Local $sBak = _GUICtrlListBox_GetText($hWnd, 0)
	If ($sBak == -1) Then Return SetError($LB_ERR, $LB_ERR, False)
	If (_GUICtrlListBox_DeleteString($hWnd, 0) == -1) Then Return SetError($LB_ERR, $LB_ERR, False)
	Return _GUICtrlListBox_AddString($hWnd, $sBak) <> -1
EndFunc   ;==>_GUICtrlListBox_Sort

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost), Cyberslug
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlListBox_SwapString($hWnd, $iIndexA, $iIndexB)
	Local $sItemA = _GUICtrlListBox_GetText($hWnd, $iIndexA)
	Local $sItemB = _GUICtrlListBox_GetText($hWnd, $iIndexB)
	If (_GUICtrlListBox_DeleteString($hWnd, $iIndexA) == -1) Then Return SetError($LB_ERR, $LB_ERR, False)
	If (_GUICtrlListBox_InsertString($hWnd, $sItemB, $iIndexA) == -1) Then Return SetError($LB_ERR, $LB_ERR, False)

	If (_GUICtrlListBox_DeleteString($hWnd, $iIndexB) == -1) Then Return SetError($LB_ERR, $LB_ERR, False)
	If (_GUICtrlListBox_InsertString($hWnd, $sItemA, $iIndexB) == -1) Then Return SetError($LB_ERR, $LB_ERR, False)
	Return True
EndFunc   ;==>_GUICtrlListBox_SwapString

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlListBox_UpdateHScroll($hWnd)
	Local $hDC, $hFont, $tSize, $sText
	Local $iMax = 0
	If IsHWnd($hWnd) Then
		$hFont = _SendMessage($hWnd, $__LISTBOXCONSTANT_WM_GETFONT)
		$hDC = _WinAPI_GetDC($hWnd)
		_WinAPI_SelectObject($hDC, $hFont)
		For $iI = 0 To _GUICtrlListBox_GetCount($hWnd) - 1
			$sText = _GUICtrlListBox_GetText($hWnd, $iI)
			$tSize = _WinAPI_GetTextExtentPoint32($hDC, $sText & "W")
			If DllStructGetData($tSize, "X") > $iMax Then
				$iMax = DllStructGetData($tSize, "X")
			EndIf
		Next
		_GUICtrlListBox_SetHorizontalExtent($hWnd, $iMax)
		_WinAPI_SelectObject($hDC, $hFont)
		_WinAPI_ReleaseDC($hWnd, $hDC)
	Else
		$hFont = GUICtrlSendMsg($hWnd, $__LISTBOXCONSTANT_WM_GETFONT, 0, 0)
		Local $hWnd_t = GUICtrlGetHandle($hWnd)
		$hDC = _WinAPI_GetDC($hWnd_t)
		_WinAPI_SelectObject($hDC, $hFont)
		For $iI = 0 To _GUICtrlListBox_GetCount($hWnd) - 1
			$sText = _GUICtrlListBox_GetText($hWnd, $iI)
			$tSize = _WinAPI_GetTextExtentPoint32($hDC, $sText & "W")
			If DllStructGetData($tSize, "X") > $iMax Then
				$iMax = DllStructGetData($tSize, "X")
			EndIf
		Next
		_GUICtrlListBox_SetHorizontalExtent($hWnd, $iMax)
		_WinAPI_SelectObject($hDC, $hFont)
		_WinAPI_ReleaseDC($hWnd_t, $hDC)
	EndIf
EndFunc   ;==>_GUICtrlListBox_UpdateHScroll
