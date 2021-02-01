#include-once

#include "Memory.au3"
#include "SendMessage.au3"
#include "TabConstants.au3"
#include "UDFGlobalID.au3"
#include "WinAPI.au3"

; #INDEX# =======================================================================================================================
; Title .........: Tab_Control
; AutoIt Version : 3.3.14.2
; Language ......: English
; Description ...: Functions that assist with Tab control management.
;                  A tab control is analogous to the dividers in a notebook or the labels in a  file  cabinet.  By  using  a  tab
;                  control, an application can define multiple pages for the same area of a  window  or  dialog  box.  Each  page
;                  consists of a certain type of information or a group of controls that the application displays when  the  user
;                  selects the corresponding tab.
; Author(s) .....: Paul Campbell (PaulIA), Gary Frost (gafrost)
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
Global $__g_hTabLastWnd

; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $__TABCONSTANT_ClassName = "SysTabControl32"
Global Const $__TABCONSTANT_WS_CLIPSIBLINGS = 0x04000000
Global Const $__TABCONSTANT_WM_NOTIFY = 0x004E
Global Const $__TABCONSTANT_DEFAULT_GUI_FONT = 17
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _GUICtrlTab_ActivateTab
; _GUICtrlTab_ClickTab
; _GUICtrlTab_Create
; _GUICtrlTab_DeleteAllItems
; _GUICtrlTab_DeleteItem
; _GUICtrlTab_DeselectAll
; _GUICtrlTab_Destroy
; _GUICtrlTab_FindTab
; _GUICtrlTab_GetCurFocus
; _GUICtrlTab_GetCurSel
; _GUICtrlTab_GetDisplayRect
; _GUICtrlTab_GetDisplayRectEx
; _GUICtrlTab_GetExtendedStyle
; _GUICtrlTab_GetImageList
; _GUICtrlTab_GetItem
; _GUICtrlTab_GetItemCount
; _GUICtrlTab_GetItemImage
; _GUICtrlTab_GetItemParam
; _GUICtrlTab_GetItemRect
; _GUICtrlTab_GetItemRectEx
; _GUICtrlTab_GetItemState
; _GUICtrlTab_GetItemText
; _GUICtrlTab_GetRowCount
; _GUICtrlTab_GetToolTips
; _GUICtrlTab_GetUnicodeFormat
; _GUICtrlTab_HighlightItem
; _GUICtrlTab_HitTest
; _GUICtrlTab_InsertItem
; _GUICtrlTab_RemoveImage
; _GUICtrlTab_SetCurFocus
; _GUICtrlTab_SetCurSel
; _GUICtrlTab_SetExtendedStyle
; _GUICtrlTab_SetImageList
; _GUICtrlTab_SetItem
; _GUICtrlTab_SetItemImage
; _GUICtrlTab_SetItemParam
; _GUICtrlTab_SetItemSize
; _GUICtrlTab_SetItemState
; _GUICtrlTab_SetItemText
; _GUICtrlTab_SetMinTabWidth
; _GUICtrlTab_SetPadding
; _GUICtrlTab_SetToolTips
; _GUICtrlTab_SetUnicodeFormat
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; $tagTCITEM
; $tagTCHITTESTINFO
; __GUICtrlTab_AdjustRect
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagTCITEM
; Description ...: Specifies or receives the attributes of a tab item
; Fields ........: Mask      - Value that specifies which members to retrieve or set:
;                  |$TCIF_IMAGE      - The Image member is valid
;                  |$TCIF_PARAM      - The Param member is valid
;                  |$TCIF_RTLREADING - The string pointed to by Text will be displayed in the opposite direction
;                  |$TCIF_STATE      - The State member is valid
;                  |$TCIF_TEXT       - The Text member is valid
;                  State     - Specifies the item's current state if information is being retrieved. If item information is being
;                  +set this member contains the state value to be set for the item.
;                  StateMask - Specifies which bits of the dwState member contain valid information
;                  Text      - String that contains the tab text when item information is being set. If item information is being
;                  +retrieved, this member specifies the address of the buffer that receives the tab text.
;                  TextMax   - Size of the buffer pointed to by the Text member.  If the structure is not receiving  information,
;                  +this member is ignored.
;                  Image     - Index in the tab control's image list, or -1 if there is no image for the tab.
;                  Param     - Application-defined data associated with the tab control item
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagTCITEM = "uint Mask;dword State;dword StateMask;ptr Text;int TextMax;int Image;lparam Param"

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagTCHITTESTINFO
; Description ...: Contains information about a hit test
; Fields ........: X     - X position to hit test
;                  Y     - Y position to hit test
;                  Flags - Results of a hit test. The control sets this member to one of the following values:
;                  |$TCHT_NOWHERE     - The position is not over a tab
;                  |$TCHT_ONITEM      - The position is over a tab but not over its icon or its text
;                  |$TCHT_ONITEMICON  - The position is over a tab's icon
;                  |$TCHT_ONITEMLABEL - The position is over a tab's text
;                  |$TCHT_ONITEM      - Bitwise OR of $TCHT_ONITEMICON and $TCHT_ONITEMLABEL
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagTCHITTESTINFO = $tagPOINT & ";uint Flags"

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUICtrlTab_AdjustRect
; Description ...: Calculates a tab control's display area given a window rectangle
; Syntax.........: __GUICtrlTab_AdjustRect ( $hWnd, ByRef $tRECT [, $bLarger = False] )
; Parameters ....: $hWnd        - Handle to the control
;                  $tRECT       - $tagRECT structure that holds a window or text display rectangle
;                  $bLarger     - Value that specifies which operation to perform.  If True, $tRECT is used to specify a text
;                  +display rectangle and it receives the corresponding window rectangle.  If False, $tRECT is used to specify a
;                  +window rectangle and it receives the corresponding text display rectangle.
; Return values .: Success      - $tagRECT structure with requested coordinates
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; Remarks .......: This message applies only to tab controls that are at the top.  It does not apply to tab controls that are on
;                  the sides or bottom.
; Related .......: $tagRECT
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __GUICtrlTab_AdjustRect($hWnd, ByRef $tRECT, $bLarger = False)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hTabLastWnd) Then
			_SendMessage($hWnd, $TCM_ADJUSTRECT, $bLarger, $tRECT, 0, "wparam", "struct*")
		Else
			Local $iRect = DllStructGetSize($tRECT)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iRect, $tMemMap)
			_MemWrite($tMemMap, $tRECT)
			_SendMessage($hWnd, $TCM_ADJUSTRECT, $bLarger, $pMemory, 0, "wparam", "ptr")
			_MemRead($tMemMap, $pMemory, $tRECT, $iRect)
			_MemFree($tMemMap)
		EndIf
	EndIf
	Return $tRECT
EndFunc   ;==>__GUICtrlTab_AdjustRect

; #FUNCTION# ====================================================================================================================
; Author ........: Prog@ndy
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTab_ActivateTab($hWnd, $iIndex)
	Local $nIndX
	; first, get Handle and CtrlID of TabControl
	If $hWnd = -1 Then $hWnd = GUICtrlGetHandle(-1)
	If IsHWnd($hWnd) Then
		$nIndX = _WinAPI_GetDlgCtrlID($hWnd)
	Else
		$nIndX = $hWnd
		$hWnd = GUICtrlGetHandle($hWnd)
	EndIf
	Local $hParent = _WinAPI_GetParent($hWnd)
	If @error Then Return SetError(1, 0, -1)

	; create Struct for the Messages
	Local $tNmhdr = DllStructCreate($tagNMHDR)
	DllStructSetData($tNmhdr, 1, $hWnd)
	DllStructSetData($tNmhdr, 2, $nIndX)
	DllStructSetData($tNmhdr, 3, $TCN_SELCHANGING)

	_SendMessage($hParent, $__TABCONSTANT_WM_NOTIFY, $nIndX, $tNmhdr, 0, "wparam", "struct*")
	; select TabItem
	Local $iRet = _GUICtrlTab_SetCurSel($hWnd, $iIndex)

	DllStructSetData($tNmhdr, 3, $TCN_SELCHANGE)
	_SendMessage($hParent, $__TABCONSTANT_WM_NOTIFY, $nIndX, $tNmhdr, 0, "wparam", "struct*")
	Return $iRet
EndFunc   ;==>_GUICtrlTab_ActivateTab

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost), PsaltyDS
; ===============================================================================================================================
Func _GUICtrlTab_ClickTab($hWnd, $iIndex, $sButton = "left", $bMove = False, $iClicks = 1, $iSpeed = 1)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $iX, $iY
	If Not $bMove Then
		; Don't move mouse, use ControlClick()
		Local $hWinParent = _WinAPI_GetParent($hWnd)
		Local $avTabPos = _GUICtrlTab_GetItemRect($hWnd, $iIndex)
		$iX = $avTabPos[0] + (($avTabPos[2] - $avTabPos[0]) / 2)
		$iY = $avTabPos[1] + (($avTabPos[3] - $avTabPos[1]) / 2)
		ControlClick($hWinParent, "", $hWnd, $sButton, $iClicks, $iX, $iY)
	Else
		; Original code to move mouse and click (requires active window)
		Local $tRECT = _GUICtrlTab_GetItemRectEx($hWnd, $iIndex)
		Local $tPoint = _WinAPI_PointFromRect($tRECT, True)
		$tPoint = _WinAPI_ClientToScreen($hWnd, $tPoint)
		_WinAPI_GetXYFromPoint($tPoint, $iX, $iY)
		Local $iMode = Opt("MouseCoordMode", 1)
		MouseClick($sButton, $iX, $iY, $iClicks, $iSpeed)
		Opt("MouseCoordMode", $iMode)
	EndIf
EndFunc   ;==>_GUICtrlTab_ClickTab

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlTab_Create($hWnd, $iX, $iY, $iWidth = 150, $iHeight = 150, $iStyle = 0x00000040, $iExStyle = 0x00000000)
	If Not IsHWnd($hWnd) Then
		; Invalid Window handle for _GUICtrlTab_Create 1st parameter
		Return SetError(1, 0, 0)
	EndIf

	If $iWidth = -1 Then $iWidth = 150
	If $iHeight = -1 Then $iHeight = 150
	If $iStyle = -1 Then $iStyle = $TCS_HOTTRACK
	If $iExStyle = -1 Then $iExStyle = 0x00000000

	$iStyle = BitOR($iStyle, $__UDFGUICONSTANT_WS_CHILD, $__TABCONSTANT_WS_CLIPSIBLINGS, $__UDFGUICONSTANT_WS_VISIBLE)

	Local $nCtrlID = __UDF_GetNextGlobalID($hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Local $hTab = _WinAPI_CreateWindowEx($iExStyle, $__TABCONSTANT_ClassName, "", $iStyle, $iX, $iY, $iWidth, $iHeight, $hWnd, $nCtrlID)
	_WinAPI_SetFont($hTab, _WinAPI_GetStockObject($__TABCONSTANT_DEFAULT_GUI_FONT))
	Return $hTab
EndFunc   ;==>_GUICtrlTab_Create

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTab_DeleteAllItems($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $TCM_DELETEALLITEMS) <> 0
	Else
		Return GUICtrlSendMsg($hWnd, $TCM_DELETEALLITEMS, 0, 0) <> 0
	EndIf
EndFunc   ;==>_GUICtrlTab_DeleteAllItems

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTab_DeleteItem($hWnd, $iIndex)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $TCM_DELETEITEM, $iIndex) <> 0
	Else
		Return GUICtrlSendMsg($hWnd, $TCM_DELETEITEM, $iIndex, 0) <> 0
	EndIf
EndFunc   ;==>_GUICtrlTab_DeleteItem

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTab_DeselectAll($hWnd, $bExclude = True)
	If IsHWnd($hWnd) Then
		_SendMessage($hWnd, $TCM_DESELECTALL, $bExclude)
	Else
		GUICtrlSendMsg($hWnd, $TCM_DESELECTALL, $bExclude, 0)
	EndIf
EndFunc   ;==>_GUICtrlTab_DeselectAll

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTab_Destroy(ByRef $hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__TABCONSTANT_ClassName) Then Return SetError(2, 2, False)

	Local $iDestroyed = 0
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hTabLastWnd) Then
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
EndFunc   ;==>_GUICtrlTab_Destroy

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTab_FindTab($hWnd, $sText, $bInStr = False, $iStart = 0)
	Local $sTab

	For $iI = $iStart To _GUICtrlTab_GetItemCount($hWnd)
		$sTab = _GUICtrlTab_GetItemText($hWnd, $iI)
		Switch $bInStr
			Case False
				If $sTab = $sText Then Return $iI
			Case True
				If StringInStr($sTab, $sText) Then Return $iI
		EndSwitch
	Next
	Return -1
EndFunc   ;==>_GUICtrlTab_FindTab

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTab_GetCurFocus($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $TCM_GETCURFOCUS)
	Else
		Return GUICtrlSendMsg($hWnd, $TCM_GETCURFOCUS, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlTab_GetCurFocus

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTab_GetCurSel($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $TCM_GETCURSEL)
	Else
		Return GUICtrlSendMsg($hWnd, $TCM_GETCURSEL, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlTab_GetCurSel

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTab_GetDisplayRect($hWnd)
	Local $aRect[4]

	Local $tRECT = _GUICtrlTab_GetDisplayRectEx($hWnd)
	$aRect[0] = DllStructGetData($tRECT, "Left")
	$aRect[1] = DllStructGetData($tRECT, "Top")
	$aRect[2] = DllStructGetData($tRECT, "Right")
	$aRect[3] = DllStructGetData($tRECT, "Bottom")
	Return $aRect
EndFunc   ;==>_GUICtrlTab_GetDisplayRect

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTab_GetDisplayRectEx($hWnd)
	Local $tRECT = _WinAPI_GetClientRect($hWnd)
	Return __GUICtrlTab_AdjustRect($hWnd, $tRECT)
EndFunc   ;==>_GUICtrlTab_GetDisplayRectEx

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTab_GetExtendedStyle($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $TCM_GETEXTENDEDSTYLE)
	Else
		Return GUICtrlSendMsg($hWnd, $TCM_GETEXTENDEDSTYLE, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlTab_GetExtendedStyle

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTab_GetImageList($hWnd)
	If IsHWnd($hWnd) Then
		Return Ptr(_SendMessage($hWnd, $TCM_GETIMAGELIST))
	Else
		Return Ptr(GUICtrlSendMsg($hWnd, $TCM_GETIMAGELIST, 0, 0))
	EndIf
EndFunc   ;==>_GUICtrlTab_GetImageList

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTab_GetItem($hWnd, $iIndex)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	Local $bUnicode = _GUICtrlTab_GetUnicodeFormat($hWnd)

	Local $iBuffer = 4096
	Local $tagTCITEMEx = $tagTCITEM & ";ptr Filler" ; strange the Filler is erased by TCM_GETITEM : MS Bug!!!
	Local $tItem = DllStructCreate($tagTCITEMEx)
	DllStructSetData($tItem, "Mask", $TCIF_ALLDATA)
	DllStructSetData($tItem, "TextMax", $iBuffer)
	DllStructSetData($tItem, "StateMask", BitOR($TCIS_HIGHLIGHTED, $TCIS_BUTTONPRESSED))
	Local $iItem = DllStructGetSize($tItem)
	Local $tBuffer
	If $bUnicode Then
		$tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
		$iBuffer *= 2
	Else
		$tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
	EndIf
	Local $tMemMap
	Local $pMemory = _MemInit($hWnd, $iItem + $iBuffer, $tMemMap)
	Local $pText = $pMemory + $iItem
	DllStructSetData($tItem, "Text", $pText)
	_MemWrite($tMemMap, $tItem, $pMemory, $iItem)
	Local $iRet
	If $bUnicode Then
		$iRet = _SendMessage($hWnd, $TCM_GETITEMW, $iIndex, $pMemory)
	Else
		$iRet = _SendMessage($hWnd, $TCM_GETITEMA, $iIndex, $pMemory)
	EndIf
	_MemRead($tMemMap, $pMemory, $tItem, $iItem)
	_MemRead($tMemMap, $pText, $tBuffer, $iBuffer)
	_MemFree($tMemMap)
	Local $aItem[4]
	$aItem[0] = DllStructGetData($tItem, "State")
	$aItem[1] = DllStructGetData($tBuffer, "Text")
	$aItem[2] = DllStructGetData($tItem, "Image")
	$aItem[3] = DllStructGetData($tItem, "Param")
	Return SetError($iRet = 0, 0, $aItem)
EndFunc   ;==>_GUICtrlTab_GetItem

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTab_GetItemCount($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $TCM_GETITEMCOUNT)
	Else
		Return GUICtrlSendMsg($hWnd, $TCM_GETITEMCOUNT, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlTab_GetItemCount

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTab_GetItemImage($hWnd, $iIndex)
	Local $aItem = _GUICtrlTab_GetItem($hWnd, $iIndex)
	Return $aItem[2]
EndFunc   ;==>_GUICtrlTab_GetItemImage

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTab_GetItemParam($hWnd, $iIndex)
	Local $aItem = _GUICtrlTab_GetItem($hWnd, $iIndex)
	Return $aItem[3]
EndFunc   ;==>_GUICtrlTab_GetItemParam

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTab_GetItemRect($hWnd, $iIndex)
	Local $aRect[4]

	Local $tRECT = _GUICtrlTab_GetItemRectEx($hWnd, $iIndex)
	$aRect[0] = DllStructGetData($tRECT, "Left")
	$aRect[1] = DllStructGetData($tRECT, "Top")
	$aRect[2] = DllStructGetData($tRECT, "Right")
	$aRect[3] = DllStructGetData($tRECT, "Bottom")
	Return $aRect
EndFunc   ;==>_GUICtrlTab_GetItemRect

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTab_GetItemRectEx($hWnd, $iIndex)
	Local $tRECT = DllStructCreate($tagRECT)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hTabLastWnd) Then
			_SendMessage($hWnd, $TCM_GETITEMRECT, $iIndex, $tRECT, 0, "wparam", "struct*")
		Else
			Local $iRect = DllStructGetSize($tRECT)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iRect, $tMemMap)
			_SendMessage($hWnd, $TCM_GETITEMRECT, $iIndex, $pMemory, 0, "wparam", "ptr")
			_MemRead($tMemMap, $pMemory, $tRECT, $iRect)
			_MemFree($tMemMap)
		EndIf
	Else
		GUICtrlSendMsg($hWnd, $TCM_GETITEMRECT, $iIndex, DllStructGetPtr($tRECT))
	EndIf
	Return $tRECT
EndFunc   ;==>_GUICtrlTab_GetItemRectEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTab_GetItemState($hWnd, $iIndex)
	Local $aItem = _GUICtrlTab_GetItem($hWnd, $iIndex)
	Return $aItem[0]
EndFunc   ;==>_GUICtrlTab_GetItemState

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTab_GetItemText($hWnd, $iIndex)
	Local $aItem = _GUICtrlTab_GetItem($hWnd, $iIndex)
	Return $aItem[1]
EndFunc   ;==>_GUICtrlTab_GetItemText

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTab_GetRowCount($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $TCM_GETROWCOUNT)
	Else
		Return GUICtrlSendMsg($hWnd, $TCM_GETROWCOUNT, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlTab_GetRowCount

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTab_GetToolTips($hWnd)
	If IsHWnd($hWnd) Then
		Return HWnd(_SendMessage($hWnd, $TCM_GETTOOLTIPS))
	Else
		Return HWnd(GUICtrlSendMsg($hWnd, $TCM_GETTOOLTIPS, 0, 0))
	EndIf
EndFunc   ;==>_GUICtrlTab_GetToolTips

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTab_GetUnicodeFormat($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $TCM_GETUNICODEFORMAT) <> 0
	Else
		Return GUICtrlSendMsg($hWnd, $TCM_GETUNICODEFORMAT, 0, 0) <> 0
	EndIf
EndFunc   ;==>_GUICtrlTab_GetUnicodeFormat

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTab_HighlightItem($hWnd, $iIndex, $bHighlight = True)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $TCM_HIGHLIGHTITEM, $iIndex, $bHighlight) <> 0
	Else
		Return GUICtrlSendMsg($hWnd, $TCM_HIGHLIGHTITEM, $iIndex, $bHighlight) <> 0
	EndIf
EndFunc   ;==>_GUICtrlTab_HighlightItem

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTab_HitTest($hWnd, $iX, $iY)
	Local $aHit[2] = [-1, 1]

	Local $tHit = DllStructCreate($tagTCHITTESTINFO)
	DllStructSetData($tHit, "X", $iX)
	DllStructSetData($tHit, "Y", $iY)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hTabLastWnd) Then
			$aHit[0] = _SendMessage($hWnd, $TCM_HITTEST, 0, $tHit, 0, "wparam", "struct*")
		Else
			Local $iHit = DllStructGetSize($tHit)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iHit, $tMemMap)
			_MemWrite($tMemMap, $tHit)
			$aHit[0] = _SendMessage($hWnd, $TCM_HITTEST, 0, $pMemory, 0, "wparam", "ptr")
			_MemRead($tMemMap, $pMemory, $tHit, $iHit)
			_MemFree($tMemMap)
		EndIf
	Else
		$aHit[0] = GUICtrlSendMsg($hWnd, $TCM_HITTEST, 0, DllStructGetPtr($tHit))
	EndIf
	$aHit[1] = DllStructGetData($tHit, "Flags")
	Return $aHit
EndFunc   ;==>_GUICtrlTab_HitTest

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTab_InsertItem($hWnd, $iIndex, $sText, $iImage = -1, $iParam = 0)
	Local $bUnicode = _GUICtrlTab_GetUnicodeFormat($hWnd)

	Local $iBuffer = StringLen($sText) + 1
	Local $tBuffer
	If $bUnicode Then
		$tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
		$iBuffer *= 2
	Else
		$tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
	EndIf
	Local $pBuffer = DllStructGetPtr($tBuffer)
	Local $tItem = DllStructCreate($tagTCITEM)
	DllStructSetData($tBuffer, "Text", $sText)
	DllStructSetData($tItem, "Mask", BitOR($TCIF_TEXT, $TCIF_IMAGE, $TCIF_PARAM))
	DllStructSetData($tItem, "TextMax", $iBuffer)
	DllStructSetData($tItem, "Image", $iImage)
	DllStructSetData($tItem, "Param", $iParam)
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hTabLastWnd) Then
			DllStructSetData($tItem, "Text", $pBuffer)
			$iRet = _SendMessage($hWnd, $TCM_INSERTITEMW, $iIndex, $tItem, 0, "wparam", "struct*")
		Else
			Local $iItem = DllStructGetSize($tItem)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iItem + $iBuffer, $tMemMap)
			Local $pText = $pMemory + $iItem
			DllStructSetData($tItem, "Text", $pText)
			_MemWrite($tMemMap, $tItem, $pMemory, $iItem)
			_MemWrite($tMemMap, $tBuffer, $pText, $iBuffer)
			If $bUnicode Then
				$iRet = _SendMessage($hWnd, $TCM_INSERTITEMW, $iIndex, $pMemory, 0, "wparam", "ptr")
			Else
				$iRet = _SendMessage($hWnd, $TCM_INSERTITEMA, $iIndex, $pMemory, 0, "wparam", "ptr")
			EndIf
			_MemFree($tMemMap)
		EndIf
	Else
		Local $pItem = DllStructGetPtr($tItem)
		DllStructSetData($tItem, "Text", $pBuffer)
		If $bUnicode Then
			$iRet = GUICtrlSendMsg($hWnd, $TCM_INSERTITEMW, $iIndex, $pItem)
		Else
			$iRet = GUICtrlSendMsg($hWnd, $TCM_INSERTITEMA, $iIndex, $pItem)
		EndIf
	EndIf
	Return $iRet
EndFunc   ;==>_GUICtrlTab_InsertItem

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTab_RemoveImage($hWnd, $iIndex)
	If IsHWnd($hWnd) Then
		_SendMessage($hWnd, $TCM_REMOVEIMAGE, $iIndex)
		_WinAPI_InvalidateRect($hWnd)
	Else
		GUICtrlSendMsg($hWnd, $TCM_REMOVEIMAGE, $iIndex, 0)
	EndIf
EndFunc   ;==>_GUICtrlTab_RemoveImage

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTab_SetCurFocus($hWnd, $iIndex)
	If IsHWnd($hWnd) Then
		_SendMessage($hWnd, $TCM_SETCURFOCUS, $iIndex)
	Else
		GUICtrlSendMsg($hWnd, $TCM_SETCURFOCUS, $iIndex, 0)
	EndIf
EndFunc   ;==>_GUICtrlTab_SetCurFocus

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTab_SetCurSel($hWnd, $iIndex)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $TCM_SETCURSEL, $iIndex)
	Else
		Return GUICtrlSendMsg($hWnd, $TCM_SETCURSEL, $iIndex, 0)
	EndIf
EndFunc   ;==>_GUICtrlTab_SetCurSel

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTab_SetExtendedStyle($hWnd, $iStyle)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $TCM_SETEXTENDEDSTYLE, 0, $iStyle)
	Else
		Return GUICtrlSendMsg($hWnd, $TCM_SETEXTENDEDSTYLE, 0, $iStyle)
	EndIf
EndFunc   ;==>_GUICtrlTab_SetExtendedStyle

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTab_SetImageList($hWnd, $hImage)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $TCM_SETIMAGELIST, 0, $hImage, 0, "wparam", "handle", "handle")
	Else
		Return Ptr(GUICtrlSendMsg($hWnd, $TCM_SETIMAGELIST, 0, $hImage))
	EndIf
EndFunc   ;==>_GUICtrlTab_SetImageList

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTab_SetItem($hWnd, $iIndex, $sText = -1, $iState = -1, $iImage = -1, $iParam = -1)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $tItem = DllStructCreate($tagTCITEM)
	Local $iBuffer, $tBuffer, $iMask = 0, $iRet
	Local $bUnicode = _GUICtrlTab_GetUnicodeFormat($hWnd)
	If IsString($sText) Then
		$iBuffer = StringLen($sText) + 1
		If $bUnicode Then
			$tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
			$iBuffer *= 2
		Else
			$tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
		EndIf
		DllStructSetData($tBuffer, "Text", $sText)
		DllStructSetData($tItem, "Text", DllStructGetPtr($tBuffer))
		$iMask = $TCIF_TEXT
	EndIf
	If $iState <> -1 Then
		DllStructSetData($tItem, "State", $iState)
		DllStructSetData($tItem, "StateMask", $iState)
		$iMask = BitOR($iMask, $TCIF_STATE)
	EndIf
	If $iImage <> -1 Then
		DllStructSetData($tItem, "Image", $iImage)
		$iMask = BitOR($iMask, $TCIF_IMAGE)
	EndIf
	If $iParam <> -1 Then
		DllStructSetData($tItem, "Param", $iParam)
		$iMask = BitOR($iMask, $TCIF_PARAM)
	EndIf
	DllStructSetData($tItem, "Mask", $iMask)
	Local $iItem = DllStructGetSize($tItem)
	Local $tMemMap
	Local $pMemory = _MemInit($hWnd, $iItem + 8192, $tMemMap)
	Local $pText = $pMemory + 4096
	DllStructSetData($tItem, "Text", $pText)
	_MemWrite($tMemMap, $tItem, $pMemory, $iItem)
	If IsString($sText) Then _MemWrite($tMemMap, $tBuffer, $pText, $iBuffer)
	If $bUnicode Then
		$iRet = _SendMessage($hWnd, $TCM_SETITEMW, $iIndex, $pMemory) <> 0
	Else
		$iRet = _SendMessage($hWnd, $TCM_SETITEMA, $iIndex, $pMemory) <> 0
	EndIf
	_MemFree($tMemMap)
	Return $iRet
EndFunc   ;==>_GUICtrlTab_SetItem

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTab_SetItemImage($hWnd, $iIndex, $iImage)
	Return _GUICtrlTab_SetItem($hWnd, $iIndex, -1, -1, $iImage)
EndFunc   ;==>_GUICtrlTab_SetItemImage

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTab_SetItemParam($hWnd, $iIndex, $iParam)
	Return _GUICtrlTab_SetItem($hWnd, $iIndex, -1, -1, -1, $iParam)
EndFunc   ;==>_GUICtrlTab_SetItemParam

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTab_SetItemSize($hWnd, $iWidth, $iHeight)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $TCM_SETITEMSIZE, 0, _WinAPI_MakeLong($iWidth, $iHeight))
	Else
		Return GUICtrlSendMsg($hWnd, $TCM_SETITEMSIZE, 0, _WinAPI_MakeLong($iWidth, $iHeight))
	EndIf
EndFunc   ;==>_GUICtrlTab_SetItemSize

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTab_SetItemState($hWnd, $iIndex, $iState)
	Return _GUICtrlTab_SetItem($hWnd, $iIndex, -1, $iState)
EndFunc   ;==>_GUICtrlTab_SetItemState

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTab_SetItemText($hWnd, $iIndex, $sText)
	Return _GUICtrlTab_SetItem($hWnd, $iIndex, $sText)
EndFunc   ;==>_GUICtrlTab_SetItemText

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTab_SetMinTabWidth($hWnd, $iMinWidth)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $TCM_SETMINTABWIDTH, 0, $iMinWidth)
	Else
		Return GUICtrlSendMsg($hWnd, $TCM_SETMINTABWIDTH, 0, $iMinWidth)
	EndIf
EndFunc   ;==>_GUICtrlTab_SetMinTabWidth

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTab_SetPadding($hWnd, $iHorz, $iVert)
	If IsHWnd($hWnd) Then
		_SendMessage($hWnd, $TCM_SETPADDING, 0, _WinAPI_MakeLong($iHorz, $iVert))
	Else
		GUICtrlSendMsg($hWnd, $TCM_SETPADDING, 0, _WinAPI_MakeLong($iHorz, $iVert))
	EndIf
EndFunc   ;==>_GUICtrlTab_SetPadding

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTab_SetToolTips($hWnd, $hToolTip)
	If IsHWnd($hWnd) Then
		_SendMessage($hWnd, $TCM_SETTOOLTIPS, $hToolTip, 0, 0, "hwnd")
	Else
		GUICtrlSendMsg($hWnd, $TCM_SETTOOLTIPS, $hToolTip, 0)
	EndIf
EndFunc   ;==>_GUICtrlTab_SetToolTips

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTab_SetUnicodeFormat($hWnd, $bUnicode)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $TCM_SETUNICODEFORMAT, $bUnicode) <> 0
	Else
		Return GUICtrlSendMsg($hWnd, $TCM_SETUNICODEFORMAT, $bUnicode, 0) <> 0
	EndIf
EndFunc   ;==>_GUICtrlTab_SetUnicodeFormat
