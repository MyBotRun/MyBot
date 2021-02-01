#include-once

#include "GuiImageList.au3"
#include "Memory.au3"
#include "SendMessage.au3"
#include "StructureConstants.au3"
#include "TreeViewConstants.au3"
#include "UDFGlobalID.au3"
#include "WinAPI.au3"

; #INDEX# =======================================================================================================================
; Title .........: TreeView
; AutoIt Version : 3.3.14.2
; Language ......: English
; Description ...: Functions that assist with TreeView control management.
;                  A TreeView control is a window that displays a hierarchical list of items, such as the headings in a document,
;                  the entries in an index, or the files and directories on a disk. Each item consists of a label and an optional
;                  bitmapped image, and each item can have a list of subitems associated with it.  By clicking an item, the  user
;                  can expand or collapse the associated list of subitems.
; Author(s) .....: Paul Campbell (PaulIA), Gary Frost (gafrost), Holger Kotsch
; ===============================================================================================================================

; Default treeview item extended structure
; http://msdn.microsoft.com/en-us/library/bb773459.aspx
; Min.OS: 2K, NT4 with IE 4.0, 98, 95 with IE 4.0

; #VARIABLES# ===================================================================================================================
Global $__g_hTVLastWnd

; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $__TREEVIEWCONSTANT_ClassName = "SysTreeView32"
Global Const $__TREEVIEWCONSTANT_WM_SETREDRAW = 0x000B
Global Const $__TREEVIEWCONSTANT_DEFAULT_GUI_FONT = 17
; ===============================================================================================================================

; #NO_DOC_FUNCTION# =============================================================================================================
; Not working/documented/implrmented at this time
;
; _GUICtrlTreeView_GetOverlayImageIndex
; _GUICtrlTreeView_MapAccIDToItem
; _GUICtrlTreeView_MapItemToAccID
; _GUICtrlTreeView_SetOverlayImageIndex
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _GUICtrlTreeView_Add
; _GUICtrlTreeView_AddChild
; _GUICtrlTreeView_AddChildFirst
; _GUICtrlTreeView_AddFirst
; _GUICtrlTreeView_BeginUpdate
; _GUICtrlTreeView_ClickItem
; _GUICtrlTreeView_Create
; _GUICtrlTreeView_CreateDragImage
; _GUICtrlTreeView_CreateSolidBitMap
; _GUICtrlTreeView_Delete
; _GUICtrlTreeView_DeleteAll
; _GUICtrlTreeView_DeleteChildren
; _GUICtrlTreeView_Destroy
; _GUICtrlTreeView_DisplayRect
; _GUICtrlTreeView_DisplayRectEx
; _GUICtrlTreeView_EditText
; _GUICtrlTreeView_EndEdit
; _GUICtrlTreeView_EndUpdate
; _GUICtrlTreeView_EnsureVisible
; _GUICtrlTreeView_Expand
; _GUICtrlTreeView_ExpandedOnce
; _GUICtrlTreeView_FindItem
; _GUICtrlTreeView_FindItemEx
; _GUICtrlTreeView_GetBkColor
; _GUICtrlTreeView_GetBold
; _GUICtrlTreeView_GetChecked
; _GUICtrlTreeView_GetChildCount
; _GUICtrlTreeView_GetChildren
; _GUICtrlTreeView_GetCount
; _GUICtrlTreeView_GetCut
; _GUICtrlTreeView_GetDropTarget
; _GUICtrlTreeView_GetEditControl
; _GUICtrlTreeView_GetExpanded
; _GUICtrlTreeView_GetFirstChild
; _GUICtrlTreeView_GetFirstItem
; _GUICtrlTreeView_GetFirstVisible
; _GUICtrlTreeView_GetFocused
; _GUICtrlTreeView_GetHeight
; _GUICtrlTreeView_GetImageIndex
; _GUICtrlTreeView_GetImageListIconHandle
; _GUICtrlTreeView_GetIndent
; _GUICtrlTreeView_GetInsertMarkColor
; _GUICtrlTreeView_GetISearchString
; _GUICtrlTreeView_GetItemByIndex
; _GUICtrlTreeView_GetItemHandle
; _GUICtrlTreeView_GetItemParam
; _GUICtrlTreeView_GetLastChild
; _GUICtrlTreeView_GetLineColor
; _GUICtrlTreeView_GetNext
; _GUICtrlTreeView_GetNextChild
; _GUICtrlTreeView_GetNextSibling
; _GUICtrlTreeView_GetNextVisible
; _GUICtrlTreeView_GetNormalImageList
; _GUICtrlTreeView_GetParentHandle
; _GUICtrlTreeView_GetParentParam
; _GUICtrlTreeView_GetPrev
; _GUICtrlTreeView_GetPrevChild
; _GUICtrlTreeView_GetPrevSibling
; _GUICtrlTreeView_GetPrevVisible
; _GUICtrlTreeView_GetScrollTime
; _GUICtrlTreeView_GetSelected
; _GUICtrlTreeView_GetSelectedImageIndex
; _GUICtrlTreeView_GetSelection
; _GUICtrlTreeView_GetSiblingCount
; _GUICtrlTreeView_GetState
; _GUICtrlTreeView_GetStateImageIndex
; _GUICtrlTreeView_GetStateImageList
; _GUICtrlTreeView_GetText
; _GUICtrlTreeView_GetTextColor
; _GUICtrlTreeView_GetToolTips
; _GUICtrlTreeView_GetTree
; _GUICtrlTreeView_GetUnicodeFormat
; _GUICtrlTreeView_GetVisible
; _GUICtrlTreeView_GetVisibleCount
; _GUICtrlTreeView_HitTest
; _GUICtrlTreeView_HitTestEx
; _GUICtrlTreeView_HitTestItem
; _GUICtrlTreeView_Index
; _GUICtrlTreeView_InsertItem
; _GUICtrlTreeView_IsFirstItem
; _GUICtrlTreeView_IsParent
; _GUICtrlTreeView_Level
; _GUICtrlTreeView_SelectItem
; _GUICtrlTreeView_SelectItemByIndex
; _GUICtrlTreeView_SetBkColor
; _GUICtrlTreeView_SetBold
; _GUICtrlTreeView_SetChecked
; _GUICtrlTreeView_SetCheckedByIndex
; _GUICtrlTreeView_SetChildren
; _GUICtrlTreeView_SetCut
; _GUICtrlTreeView_SetDropTarget
; _GUICtrlTreeView_SetFocused
; _GUICtrlTreeView_SetHeight
; _GUICtrlTreeView_SetIcon
; _GUICtrlTreeView_SetImageIndex
; _GUICtrlTreeView_SetIndent
; _GUICtrlTreeView_SetInsertMark
; _GUICtrlTreeView_SetInsertMarkColor
; _GUICtrlTreeView_SetItemHeight
; _GUICtrlTreeView_SetItemParam
; _GUICtrlTreeView_SetLineColor
; _GUICtrlTreeView_SetNormalImageList
; _GUICtrlTreeView_SetScrollTime
; _GUICtrlTreeView_SetSelected
; _GUICtrlTreeView_SetSelectedImageIndex
; _GUICtrlTreeView_SetState
; _GUICtrlTreeView_SetStateImageIndex
; _GUICtrlTreeView_SetStateImageList
; _GUICtrlTreeView_SetText
; _GUICtrlTreeView_SetTextColor
; _GUICtrlTreeView_SetToolTips
; _GUICtrlTreeView_SetUnicodeFormat
; _GUICtrlTreeView_Sort
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; $tagTVINSERTSTRUCT
; __GUICtrlTreeView_AddItem
; __GUICtrlTreeView_ExpandItem
; __GUICtrlTreeView_GetItem
; __GUICtrlTreeView_ReverseColorOrder
; __GUICtrlTreeView_SetItem
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagTVINSERTSTRUCT
; Description ...: Contains information used to add a new item to a tree-view control
; Fields ........: Parent        - Handle to the parent item. If this member is $TVI_ROOT, the item is inserted at the root
;                  InsertAfter   - Handle to the item after which the new item is to be inserted, or one of the following values:
;                  |$TVI_FIRST - Inserts the item at the beginning of the list
;                  |$TVI_LAST  - Inserts the item at the end of the list
;                  |$TVI_ROOT  - Add the item as a root item
;                  |$TVI_SORT  - Inserts the item into the list in alphabetical order
;                  Mask          - Flags that indicate which of the other structure members contain valid data:
;                  |$TVIF_CHILDREN      - The Children member is valid
;                  |$TVIF_DI_SETITEM    - The will retain the supplied information and will not request it again
;                  |$TVIF_HANDLE        - The hItem member is valid
;                  |$TVIF_IMAGE         - The Image member is valid
;                  |$TVIF_INTEGRAL      - The Integral member is valid
;                  |$TVIF_PARAM         - The Param member is valid
;                  |$TVIF_SELECTEDIMAGE - The SelectedImage member is valid
;                  |$TVIF_STATE         - The State and StateMask members are valid
;                  |$TVIF_TEXT          - The Text and TextMax members are valid
;                  hItem         - Item to which this structure refers
;                  State         - Set of bit flags and image list indexes that indicate the item's state. When setting the state
;                  +of an item, the StateMask member indicates the bits of this member that are valid.  When retrieving the state
;                  +of an item, this member returns the current state for the bits indicated in  the  StateMask  member.  Bits  0
;                  +through 7 of this member contain the item state flags. Bits 8 through 11 of this member specify the one based
;                  +overlay image index.
;                  StateMask     - Bits of the state member that are valid.  If you are retrieving an item's state, set the  bits
;                  +of the stateMask member to indicate the bits to be returned in the state member. If you are setting an item's
;                  +state, set the bits of the stateMask member to indicate the bits of the state member that you want to set.
;                  Text          - Pointer to a null-terminated string that contains the item text.
;                  TextMax       - Size of the buffer pointed to by the Text member, in characters
;                  Image         - Index in the image list of the icon image to use when the item is in the nonselected state
;                  SelectedImage - Index in the image list of the icon image to use when the item is in the selected state
;                  Children      - Flag that indicates whether the item has associated child items. This member can be one of the
;                  +following values:
;                  |0 - The item has no child items
;                  |1 - The item has one or more child items
;                  Param         - A value to associate with the item
;                  Integral      - Height of the item
; Author ........: Paul Campbell (PaulIA)
; Modified ......: jpm
; Remarks .......:
; ===============================================================================================================================
Global Const $tagTVINSERTSTRUCT = "handle Parent;handle InsertAfter;" & $tagTVITEMEX

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_Add($hWnd, $hSibling, $sText, $iImage = -1, $iSelImage = -1)
	Return __GUICtrlTreeView_AddItem($hWnd, $hSibling, $sText, $TVNA_ADD, $iImage, $iSelImage)
EndFunc   ;==>_GUICtrlTreeView_Add

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_AddChild($hWnd, $hParent, $sText, $iImage = -1, $iSelImage = -1)
	Return __GUICtrlTreeView_AddItem($hWnd, $hParent, $sText, $TVNA_ADDCHILD, $iImage, $iSelImage)
EndFunc   ;==>_GUICtrlTreeView_AddChild

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_AddChildFirst($hWnd, $hParent, $sText, $iImage = -1, $iSelImage = -1)
	Return __GUICtrlTreeView_AddItem($hWnd, $hParent, $sText, $TVNA_ADDCHILDFIRST, $iImage, $iSelImage)
EndFunc   ;==>_GUICtrlTreeView_AddChildFirst

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_AddFirst($hWnd, $hSibling, $sText, $iImage = -1, $iSelImage = -1)
	Return __GUICtrlTreeView_AddItem($hWnd, $hSibling, $sText, $TVNA_ADDFIRST, $iImage, $iSelImage)
EndFunc   ;==>_GUICtrlTreeView_AddFirst

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUICtrlTreeView_AddItem
; Description ...: Add a new item
; Syntax.........: __GUICtrlTreeView_AddItem ( $hWnd, $hRelative, $sText, $iMethod [, $iImage = -1 [, $iSelImage = -1]] )
; Parameters ....: $hWnd        - Handle to the control
;                  $hRelative   - Handle to an existing item that will be either parent or sibling to the new item
;                  $sText       - The text for the new item
;                  $iMethod     - The relationship between the new item and the $hRelative item
;                  |$TVNA_ADD           - The item becomes the last sibling of the other item
;                  |$TVNA_ADDFIRST      - The item becomes the first sibling of the other item
;                  |$TVNA_ADDCHILD      - The item becomes the sibling before the other item
;                  |$TVNA_ADDCHILDFIRST - The item becomes the last child of the other item
;                  |$TVNA_INSERT        - The item becomes the first child of the other item
;                  $iImage      - Zero based index of the item's icon in the control's image list
;                  $iSelImage   - Zero based index of the item's icon in the control's image list
;                  $iParam      - Application Defined Data
; Return values .: Success      - The handle to the new item
;                  Failure      - 0
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; Remarks .......: This function is for interall use only and should not normally be called by the end user
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __GUICtrlTreeView_AddItem($hWnd, $hRelative, $sText, $iMethod, $iImage = -1, $iSelImage = -1, $iParam = 0)
	Local $iAddMode
	Switch $iMethod
		Case $TVNA_ADD, $TVNA_ADDCHILD
			$iAddMode = $TVTA_ADD
		Case $TVNA_ADDFIRST, $TVNA_ADDCHILDFIRST
			$iAddMode = $TVTA_ADDFIRST
		Case Else
			$iAddMode = $TVTA_INSERT
	EndSwitch

	Local $hItem, $hItemID = 0
	If $hRelative <> 0x00000000 Then
		Switch $iMethod
			Case $TVNA_ADD, $TVNA_ADDFIRST
				$hItem = _GUICtrlTreeView_GetParentHandle($hWnd, $hRelative)
			Case $TVNA_ADDCHILD, $TVNA_ADDCHILDFIRST
				$hItem = $hRelative
			Case Else
				$hItem = _GUICtrlTreeView_GetParentHandle($hWnd, $hRelative)
				$hItemID = _GUICtrlTreeView_GetPrevSibling($hWnd, $hRelative)
				If $hItemID = 0x00000000 Then $iAddMode = $TVTA_ADDFIRST
		EndSwitch
	EndIf

	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $iBuffer = StringLen($sText) + 1
	Local $tBuffer
	Local $bUnicode = _GUICtrlTreeView_GetUnicodeFormat($hWnd)
	If $bUnicode Then
		$tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
		$iBuffer *= 2
	Else
		$tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
	EndIf
	Local $tInsert = DllStructCreate($tagTVINSERTSTRUCT)
	Switch $iAddMode
		Case $TVTA_ADDFIRST
			DllStructSetData($tInsert, "InsertAfter", $TVI_FIRST)
		Case $TVTA_ADD
			DllStructSetData($tInsert, "InsertAfter", $TVI_LAST)
		Case $TVTA_INSERT
			DllStructSetData($tInsert, "InsertAfter", $hItemID)
	EndSwitch
	Local $iMask = BitOR($TVIF_TEXT, $TVIF_PARAM)
	If $iImage >= 0 Then $iMask = BitOR($iMask, $TVIF_IMAGE)
	If $iSelImage >= 0 Then $iMask = BitOR($iMask, $TVIF_SELECTEDIMAGE)
	DllStructSetData($tBuffer, "Text", $sText)
	DllStructSetData($tInsert, "Parent", $hItem)
	DllStructSetData($tInsert, "Mask", $iMask)
	DllStructSetData($tInsert, "TextMax", $iBuffer)
	DllStructSetData($tInsert, "Image", $iImage)
	DllStructSetData($tInsert, "SelectedImage", $iSelImage)
	DllStructSetData($tInsert, "Param", $iParam)

	Local $hResult
	If _WinAPI_InProcess($hWnd, $__g_hTVLastWnd) Then
		DllStructSetData($tInsert, "Text", DllStructGetPtr($tBuffer))
		$hResult = _SendMessage($hWnd, $TVM_INSERTITEMW, 0, $tInsert, 0, "wparam", "struct*", "handle")
	Else
		Local $iInsert = DllStructGetSize($tInsert)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iInsert + $iBuffer, $tMemMap)
		Local $pText = $pMemory + $iInsert
		_MemWrite($tMemMap, $tInsert, $pMemory, $iInsert)
		_MemWrite($tMemMap, $tBuffer, $pText, $iBuffer)
		DllStructSetData($tInsert, "Text", $pText)
		If $bUnicode Then
			$hResult = _SendMessage($hWnd, $TVM_INSERTITEMW, 0, $pMemory, 0, "wparam", "ptr", "handle")
		Else
			$hResult = _SendMessage($hWnd, $TVM_INSERTITEMA, 0, $pMemory, 0, "wparam", "ptr", "handle")
		EndIf
		_MemFree($tMemMap)
	EndIf
	Return $hResult
EndFunc   ;==>__GUICtrlTreeView_AddItem

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_BeginUpdate($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $__TREEVIEWCONSTANT_WM_SETREDRAW, False) = 0
EndFunc   ;==>_GUICtrlTreeView_BeginUpdate

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlTreeView_ClickItem($hWnd, $hItem, $sButton = "left", $bMove = False, $iClicks = 1, $iSpeed = 0)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $tRECT = _GUICtrlTreeView_DisplayRectEx($hWnd, $hItem, True)
	If @error Then Return SetError(@error, @error, 0)
	; Always click on the left-most portion of the control, not the center.  A
	; very wide control may be off-screen which means clicking on it's center
	; will click outside the window.
	Local $tPoint = _WinAPI_PointFromRect($tRECT, False)
	_WinAPI_ClientToScreen($hWnd, $tPoint)
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
	Return 1
EndFunc   ;==>_GUICtrlTreeView_ClickItem

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlTreeView_Create($hWnd, $iX, $iY, $iWidth = 150, $iHeight = 150, $iStyle = 0x00000037, $iExStyle = 0x00000000)
	If Not IsHWnd($hWnd) Then
		; Invalid Window handle for _GUICtrlTreeView_Create 1st parameter
		Return SetError(1, 0, 0)
	EndIf

	If $iWidth = -1 Then $iWidth = 150
	If $iHeight = -1 Then $iHeight = 150
	If $iStyle = -1 Then $iStyle = BitOR($TVS_SHOWSELALWAYS, $TVS_DISABLEDRAGDROP, $TVS_LINESATROOT, $TVS_HASLINES, $TVS_HASBUTTONS)
	If $iExStyle = -1 Then $iExStyle = 0x00000000

	$iStyle = BitOR($iStyle, $__UDFGUICONSTANT_WS_CHILD, $__UDFGUICONSTANT_WS_VISIBLE)

	Local $nCtrlID = __UDF_GetNextGlobalID($hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Local $hTree = _WinAPI_CreateWindowEx($iExStyle, $__TREEVIEWCONSTANT_ClassName, "", $iStyle, $iX, $iY, $iWidth, $iHeight, $hWnd, $nCtrlID)
	_WinAPI_SetFont($hTree, _WinAPI_GetStockObject($__TREEVIEWCONSTANT_DEFAULT_GUI_FONT))
	Return $hTree
EndFunc   ;==>_GUICtrlTreeView_Create

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_CreateDragImage($hWnd, $hItem)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $TVM_CREATEDRAGIMAGE, 0, $hItem, 0, "wparam", "handle", "handle")
EndFunc   ;==>_GUICtrlTreeView_CreateDragImage

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_CreateSolidBitMap($hWnd, $iColor, $iWidth, $iHeight)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	Return _WinAPI_CreateSolidBitmap($hWnd, $iColor, $iWidth, $iHeight)
EndFunc   ;==>_GUICtrlTreeView_CreateSolidBitMap

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......: re-written by Holger Kotsch, re-written again by Gary Frost
; ===============================================================================================================================
Func _GUICtrlTreeView_Delete($hWnd, $hItem = 0)
	If $hItem = 0 Then $hItem = 0x00000000

	If IsHWnd($hWnd) Then
		If $hItem = 0x00000000 Then
			$hItem = _SendMessage($hWnd, $TVM_GETNEXTITEM, $TVGN_CARET, 0, 0, "wparam", "handle", "handle")
			If $hItem <> 0x00000000 Then Return _SendMessage($hWnd, $TVM_DELETEITEM, 0, $hItem, 0, "wparam", "handle", "hwnd") <> 0
			Return False
		Else
			If GUICtrlDelete($hItem) Then Return True
			Return _SendMessage($hWnd, $TVM_DELETEITEM, 0, $hItem, 0, "wparam", "handle", "hwnd") <> 0
		EndIf
	Else
		If $hItem = 0x00000000 Then
			$hItem = GUICtrlSendMsg($hWnd, $TVM_GETNEXTITEM, $TVGN_CARET, 0)
			If $hItem <> 0x00000000 Then Return GUICtrlSendMsg($hWnd, $TVM_DELETEITEM, 0, $hItem) <> 0
			Return False
		Else
			If GUICtrlDelete($hItem) Then Return True
			Return GUICtrlSendMsg($hWnd, $TVM_DELETEITEM, 0, $hItem) <> 0
		EndIf
	EndIf
EndFunc   ;==>_GUICtrlTreeView_Delete

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_DeleteAll($hWnd)
	Local $iCount = 0
	If IsHWnd($hWnd) Then
		_SendMessage($hWnd, $TVM_DELETEITEM, 0, $TVI_ROOT)
		$iCount = _GUICtrlTreeView_GetCount($hWnd) ; might be created with autoit create
		If $iCount Then Return GUICtrlSendMsg($hWnd, $TVM_DELETEITEM, 0, $TVI_ROOT) <> 0
		Return True
	Else
		GUICtrlSendMsg($hWnd, $TVM_DELETEITEM, 0, $TVI_ROOT)
		$iCount = _GUICtrlTreeView_GetCount($hWnd) ; might be created with udf
		If $iCount Then Return _SendMessage($hWnd, $TVM_DELETEITEM, 0, $TVI_ROOT) <> 0
		Return True
	EndIf
	Return False
EndFunc   ;==>_GUICtrlTreeView_DeleteAll

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_DeleteChildren($hWnd, $hItem)
	Local $bResult
	If IsHWnd($hWnd) Then
		$bResult = _SendMessage($hWnd, $TVM_EXPAND, BitOR($TVE_COLLAPSE, $TVE_COLLAPSERESET), $hItem, 0, "wparam", "handle")
	Else
		$bResult = GUICtrlSendMsg($hWnd, $TVM_EXPAND, BitOR($TVE_COLLAPSE, $TVE_COLLAPSERESET), $hItem)
	EndIf
	Return $bResult
EndFunc   ;==>_GUICtrlTreeView_DeleteChildren

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_Destroy(ByRef $hWnd)
	;If Not _WinAPI_IsClassName($hWnd, $__TREEVIEWCONSTANT_ClassName) Then Return SetError(2, 2, False)

	Local $iDestroyed = 0
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hTVLastWnd) Then
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
EndFunc   ;==>_GUICtrlTreeView_Destroy

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_DisplayRect($hWnd, $hItem, $bTextOnly = False)
	Local $tRECT = _GUICtrlTreeView_DisplayRectEx($hWnd, $hItem, $bTextOnly)
	If @error Then Return SetError(@error, @error, 0)
	Local $aRect[4]
	$aRect[0] = DllStructGetData($tRECT, "Left")
	$aRect[1] = DllStructGetData($tRECT, "Top")
	$aRect[2] = DllStructGetData($tRECT, "Right")
	$aRect[3] = DllStructGetData($tRECT, "Bottom")
	Return $aRect
EndFunc   ;==>_GUICtrlTreeView_DisplayRect

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_DisplayRectEx($hWnd, $hItem, $bTextOnly = False)
	Local $tRECT = DllStructCreate($tagRECT)
	Local $iRet
	If IsHWnd($hWnd) Then
		; RECT is expected to point to the item in its first member.
		DllStructSetData($tRECT, "Left", $hItem)
		If _WinAPI_InProcess($hWnd, $__g_hTVLastWnd) Then
			$iRet = _SendMessage($hWnd, $TVM_GETITEMRECT, $bTextOnly, $tRECT, 0, "wparam", "struct*")
		Else
			Local $iRect = DllStructGetSize($tRECT)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iRect, $tMemMap)
			_MemWrite($tMemMap, $tRECT)
			$iRet = _SendMessage($hWnd, $TVM_GETITEMRECT, $bTextOnly, $pMemory, 0, "wparam", "ptr")
			_MemRead($tMemMap, $pMemory, $tRECT, $iRect)
			_MemFree($tMemMap)
		EndIf
	Else
		If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
		; RECT is expected to point to the item in its first member.
		DllStructSetData($tRECT, "Left", $hItem)
		$iRet = GUICtrlSendMsg($hWnd, $TVM_GETITEMRECT, $bTextOnly, DllStructGetPtr($tRECT))
	EndIf

	; On failure ensure Left is set to 0 and not the item handle.
	If Not $iRet Then DllStructSetData($tRECT, "Left", 0)
	Return SetError($iRet = 0, $iRet, $tRECT)
EndFunc   ;==>_GUICtrlTreeView_DisplayRectEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_EditText($hWnd, $hItem)
	If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	_WinAPI_SetFocus($hWnd)
	Local $bUnicode = _GUICtrlTreeView_GetUnicodeFormat($hWnd)
	If $bUnicode Then
		Return _SendMessage($hWnd, $TVM_EDITLABELW, 0, $hItem, 0, "wparam", "handle", "handle")
	Else
		Return _SendMessage($hWnd, $TVM_EDITLABELA, 0, $hItem, 0, "wparam", "handle", "handle")
	EndIf
EndFunc   ;==>_GUICtrlTreeView_EditText

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_EndEdit($hWnd, $bCancel = False)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $TVM_ENDEDITLABELNOW, $bCancel) <> 0
EndFunc   ;==>_GUICtrlTreeView_EndEdit

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_EndUpdate($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $__TREEVIEWCONSTANT_WM_SETREDRAW, True) = 0
EndFunc   ;==>_GUICtrlTreeView_EndUpdate

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_EnsureVisible($hWnd, $hItem)
	If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $TVM_ENSUREVISIBLE, 0, $hItem, 0, "wparam", "handle") <> 0
EndFunc   ;==>_GUICtrlTreeView_EnsureVisible

; #FUNCTION# ====================================================================================================================
; Author ........: Holger Kotsch
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlTreeView_Expand($hWnd, $hItem = 0, $bExpand = True)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	If $hItem = 0 Then $hItem = 0x00000000

	If $hItem = 0x00000000 Then
		$hItem = $TVI_ROOT
	Else
		If Not IsHWnd($hItem) Then
			Local $hItem_tmp = GUICtrlGetHandle($hItem)
			If $hItem_tmp <> 0x00000000 Then $hItem = $hItem_tmp
		EndIf
	EndIf

	If $bExpand Then
		__GUICtrlTreeView_ExpandItem($hWnd, $TVE_EXPAND, $hItem)
	Else
		__GUICtrlTreeView_ExpandItem($hWnd, $TVE_COLLAPSE, $hItem)
	EndIf
EndFunc   ;==>_GUICtrlTreeView_Expand

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUICtrlTreeView_ExpandItem($hWnd, $iExpand, $hItem)
; Description ...: Expands/Collapes the item and child(ren), if any
; Syntax.........: __GUICtrlTreeView_ExpandItem ( $hWnd, $iExpand, $hItem )
; Parameters ....: $hWnd  - Handle to the control
; Return values .:
; Author ........: Holger Kotsch
; Modified.......: Gary Frost (gafrost)
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __GUICtrlTreeView_ExpandItem($hWnd, $iExpand, $hItem)
	If Not IsHWnd($hWnd) Then

		If $hItem = 0x00000000 Then
			$hItem = $TVI_ROOT
		Else
			$hItem = GUICtrlGetHandle($hItem)
			If $hItem = 0 Then Return
		EndIf
		$hWnd = GUICtrlGetHandle($hWnd)
	EndIf

	_SendMessage($hWnd, $TVM_EXPAND, $iExpand, $hItem, 0, "wparam", "handle")

	If $iExpand = $TVE_EXPAND And $hItem > 0 Then _SendMessage($hWnd, $TVM_ENSUREVISIBLE, 0, $hItem, 0, "wparam", "handle")

	$hItem = _SendMessage($hWnd, $TVM_GETNEXTITEM, $TVGN_CHILD, $hItem, 0, "wparam", "handle")

	While $hItem <> 0x00000000
		Local $hChild = _SendMessage($hWnd, $TVM_GETNEXTITEM, $TVGN_CHILD, $hItem, 0, "wparam", "handle")
		If $hChild <> 0x00000000 Then __GUICtrlTreeView_ExpandItem($hWnd, $iExpand, $hItem)
		$hItem = _SendMessage($hWnd, $TVM_GETNEXTITEM, $TVGN_NEXT, $hItem, 0, "wparam", "handle")
	WEnd
EndFunc   ;==>__GUICtrlTreeView_ExpandItem

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_ExpandedOnce($hWnd, $hItem)
	Return BitAND(_GUICtrlTreeView_GetState($hWnd, $hItem), $TVIS_EXPANDEDONCE) <> 0
EndFunc   ;==>_GUICtrlTreeView_ExpandedOnce

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_FindItem($hWnd, $sText, $bInStr = False, $hStart = 0)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	If $hStart = 0 Then $hStart = _GUICtrlTreeView_GetFirstItem($hWnd)
	While $hStart <> 0x00000000
		Local $sItem = _GUICtrlTreeView_GetText($hWnd, $hStart)
		Switch $bInStr
			Case False
				If $sItem = $sText Then Return $hStart
			Case True
				If StringInStr($sItem, $sText) Then Return $hStart
		EndSwitch
		$hStart = _GUICtrlTreeView_GetNext($hWnd, $hStart)
	WEnd
EndFunc   ;==>_GUICtrlTreeView_FindItem

; #FUNCTION# ====================================================================================================================
; Author ........: Miguel Pilar (luckyb), Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_FindItemEx($hWnd, $sTreePath, $hStart = 0)
	Local $sDelimiter = Opt("GUIDataSeparatorChar")

	Local $iIndex = 1
	Local $aParts = StringSplit($sTreePath, $sDelimiter)
	If $hStart = 0 Then $hStart = _GUICtrlTreeView_GetFirstItem($hWnd)
	While ($iIndex <= $aParts[0]) And ($hStart <> 0x00000000)
		If StringStripWS(_GUICtrlTreeView_GetText($hWnd, $hStart), $STR_STRIPLEADING + $STR_STRIPTRAILING) = StringStripWS($aParts[$iIndex], $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
			If $iIndex = $aParts[0] Then Return $hStart
			$iIndex += 1
			__GUICtrlTreeView_ExpandItem($hWnd, $TVE_EXPAND, $hStart)
			$hStart = _GUICtrlTreeView_GetFirstChild($hWnd, $hStart)
		Else
			$hStart = _GUICtrlTreeView_GetNextSibling($hWnd, $hStart)
			__GUICtrlTreeView_ExpandItem($hWnd, $TVE_COLLAPSE, $hStart)
		EndIf
	WEnd
	Return $hStart
EndFunc   ;==>_GUICtrlTreeView_FindItemEx

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_GetBkColor($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $sHex = Hex(String(_SendMessage($hWnd, $TVM_GETBKCOLOR)), 6)
	Return '0x' & StringMid($sHex, 5, 2) & StringMid($sHex, 3, 2) & StringMid($sHex, 1, 2)
EndFunc   ;==>_GUICtrlTreeView_GetBkColor

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_GetBold($hWnd, $hItem)
	Return BitAND(_GUICtrlTreeView_GetState($hWnd, $hItem), $TVIS_BOLD) <> 0
EndFunc   ;==>_GUICtrlTreeView_GetBold

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_GetChecked($hWnd, $hItem)
	If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $tItem = DllStructCreate($tagTVITEMEX)
	DllStructSetData($tItem, "Mask", $TVIF_STATE)
	DllStructSetData($tItem, "hItem", $hItem)
	__GUICtrlTreeView_GetItem($hWnd, $tItem)
	Return BitAND(DllStructGetData($tItem, "State"), $TVIS_CHECKED) = $TVIS_CHECKED
EndFunc   ;==>_GUICtrlTreeView_GetChecked

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_GetChildCount($hWnd, $hItem)
	If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $iRet = 0

	Local $hNext = _GUICtrlTreeView_GetFirstChild($hWnd, $hItem)
	If $hNext = 0x00000000 Then Return -1
	Do
		$iRet += 1
		$hNext = _GUICtrlTreeView_GetNextSibling($hWnd, $hNext)
	Until $hNext = 0x00000000
	Return $iRet
EndFunc   ;==>_GUICtrlTreeView_GetChildCount

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_GetChildren($hWnd, $hItem)
	If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $tItem = DllStructCreate($tagTVITEMEX)
	DllStructSetData($tItem, "Mask", $TVIF_CHILDREN)
	DllStructSetData($tItem, "hItem", $hItem)
	__GUICtrlTreeView_GetItem($hWnd, $tItem)
	Return DllStructGetData($tItem, "Children") <> 0
EndFunc   ;==>_GUICtrlTreeView_GetChildren

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_GetCount($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $TVM_GETCOUNT)
EndFunc   ;==>_GUICtrlTreeView_GetCount

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_GetCut($hWnd, $hItem)
	Return BitAND(_GUICtrlTreeView_GetState($hWnd, $hItem), $TVIS_CUT) <> 0
EndFunc   ;==>_GUICtrlTreeView_GetCut

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_GetDropTarget($hWnd, $hItem)
	Return BitAND(_GUICtrlTreeView_GetState($hWnd, $hItem), $TVIS_DROPHILITED) <> 0
EndFunc   ;==>_GUICtrlTreeView_GetDropTarget

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_GetEditControl($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $TVM_GETEDITCONTROL, 0, 0, 0, "wparam", "lparam", "handle")
EndFunc   ;==>_GUICtrlTreeView_GetEditControl

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_GetExpanded($hWnd, $hItem)
	Return BitAND(_GUICtrlTreeView_GetState($hWnd, $hItem), $TVIS_EXPANDED) <> 0
EndFunc   ;==>_GUICtrlTreeView_GetExpanded

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_GetFirstChild($hWnd, $hItem)
	If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $TVM_GETNEXTITEM, $TVGN_CHILD, $hItem, 0, "wparam", "handle", "handle")
EndFunc   ;==>_GUICtrlTreeView_GetFirstChild

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_GetFirstItem($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $TVM_GETNEXTITEM, $TVGN_ROOT, 0, 0, "wparam", "lparam", "handle")
EndFunc   ;==>_GUICtrlTreeView_GetFirstItem

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_GetFirstVisible($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $TVM_GETNEXTITEM, $TVGN_FIRSTVISIBLE, 0, 0, "wparam", "lparam", "handle")
EndFunc   ;==>_GUICtrlTreeView_GetFirstVisible

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_GetFocused($hWnd, $hItem)
	Return BitAND(_GUICtrlTreeView_GetState($hWnd, $hItem), $TVIS_FOCUSED) <> 0
EndFunc   ;==>_GUICtrlTreeView_GetFocused

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_GetHeight($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $TVM_GETITEMHEIGHT)
EndFunc   ;==>_GUICtrlTreeView_GetHeight

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_GetImageIndex($hWnd, $hItem)
	If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)

	Local $tItem = DllStructCreate($tagTVITEMEX)
	DllStructSetData($tItem, "Mask", $TVIF_IMAGE)
	DllStructSetData($tItem, "hItem", $hItem)
	__GUICtrlTreeView_GetItem($hWnd, $tItem)
	Return DllStructGetData($tItem, "Image")
EndFunc   ;==>_GUICtrlTreeView_GetImageIndex

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_GetImageListIconHandle($hWnd, $iIndex)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $hImageList = _SendMessage($hWnd, $TVM_GETIMAGELIST, 0, 0, 0, "wparam", "lparam", "handle")
	Local $hIcon = DllCall("comctl32.dll", "handle", "ImageList_GetIcon", "handle", $hImageList, "int", $iIndex, "uint", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return $hIcon[0]
EndFunc   ;==>_GUICtrlTreeView_GetImageListIconHandle

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_GetIndent($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $TVM_GETINDENT)
EndFunc   ;==>_GUICtrlTreeView_GetIndent

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_GetInsertMarkColor($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $TVM_GETINSERTMARKCOLOR)
EndFunc   ;==>_GUICtrlTreeView_GetInsertMarkColor

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_GetISearchString($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $bUnicode = _GUICtrlTreeView_GetUnicodeFormat($hWnd)
	Local $iBuffer
	If $bUnicode Then
		$iBuffer = _SendMessage($hWnd, $TVM_GETISEARCHSTRINGW) + 1
	Else
		$iBuffer = _SendMessage($hWnd, $TVM_GETISEARCHSTRINGA) + 1
	EndIf
	If $iBuffer = 1 Then Return ""

	Local $tBuffer
	If $bUnicode Then
		$tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
		$iBuffer *= 2
	Else
		$tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
	EndIf
	If _WinAPI_InProcess($hWnd, $__g_hTVLastWnd) Then
		_SendMessage($hWnd, $TVM_GETISEARCHSTRINGW, 0, $tBuffer, 0, "wparam", "struct*")
	Else
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iBuffer, $tMemMap)
		If $bUnicode Then
			_SendMessage($hWnd, $TVM_GETISEARCHSTRINGW, 0, $pMemory, 0, "wparam", "ptr")
		Else
			_SendMessage($hWnd, $TVM_GETISEARCHSTRINGA, 0, $pMemory, 0, "wparam", "ptr")
		EndIf
		_MemRead($tMemMap, $pMemory, $tBuffer, $iBuffer)
		_MemFree($tMemMap)
	EndIf

	Return DllStructGetData($tBuffer, "Text")
EndFunc   ;==>_GUICtrlTreeView_GetISearchString

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUICtrlTreeView_GetItem
; Description ...: Retrieves some or all of a item's attributes
; Syntax.........: __GUICtrlTreeView_GetItem ( $hWnd, ByRef $tItem )
; Parameters ....: $hWnd        - Handle to the control
;                  $tItem       - $tagTVITEMEX structure used to request/receive item information
;                  +the item
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; Remarks .......: This function is used internally and should not normally be called by the end user
; Related .......: __GUICtrlTreeView_SetItem
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __GUICtrlTreeView_GetItem($hWnd, ByRef $tItem)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $bUnicode = _GUICtrlTreeView_GetUnicodeFormat($hWnd)

	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hTVLastWnd) Then
			$iRet = _SendMessage($hWnd, $TVM_GETITEMW, 0, $tItem, 0, "wparam", "struct*")
		Else
			Local $iItem = DllStructGetSize($tItem)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iItem, $tMemMap)
			_MemWrite($tMemMap, $tItem)
			If $bUnicode Then
				$iRet = _SendMessage($hWnd, $TVM_GETITEMW, 0, $pMemory, 0, "wparam", "ptr")
			Else
				$iRet = _SendMessage($hWnd, $TVM_GETITEMA, 0, $pMemory, 0, "wparam", "ptr")
			EndIf
			_MemRead($tMemMap, $pMemory, $tItem, $iItem)
			_MemFree($tMemMap)
		EndIf
	Else
		Local $pItem = DllStructGetPtr($tItem)
		If $bUnicode Then
			$iRet = GUICtrlSendMsg($hWnd, $TVM_GETITEMW, 0, $pItem)
		Else
			$iRet = GUICtrlSendMsg($hWnd, $TVM_GETITEMA, 0, $pItem)
		EndIf
	EndIf
	Return $iRet <> 0
EndFunc   ;==>__GUICtrlTreeView_GetItem

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_GetItemByIndex($hWnd, $hItem, $iIndex)
	Local $hResult = _GUICtrlTreeView_GetFirstChild($hWnd, $hItem)
	While ($hResult <> 0x00000000) And ($iIndex > 0)
		$hResult = _GUICtrlTreeView_GetNextSibling($hWnd, $hResult)
		$iIndex -= 1
	WEnd
	Return $hResult
EndFunc   ;==>_GUICtrlTreeView_GetItemByIndex

; #FUNCTION# ====================================================================================================================
; Author ........: Holger Kotsch
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_GetItemHandle($hWnd, $hItem = 0)
	If $hItem = 0 Then $hItem = 0x00000000
	If IsHWnd($hWnd) Then
		If $hItem = 0x00000000 Then $hItem = _SendMessage($hWnd, $TVM_GETNEXTITEM, $TVGN_ROOT, 0, 0, "wparam", "lparam", "handle")
	Else
		If $hItem = 0x00000000 Then
			$hItem = Ptr(GUICtrlSendMsg($hWnd, $TVM_GETNEXTITEM, $TVGN_ROOT, 0))
		Else
			Local $hTempItem = GUICtrlGetHandle($hItem)
			If $hTempItem <> 0x00000000 Then $hItem = $hTempItem
		EndIf
	EndIf

	Return $hItem
EndFunc   ;==>_GUICtrlTreeView_GetItemHandle

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_GetItemParam($hWnd, $hItem = 0)
	Local $tItem = DllStructCreate($tagTVITEMEX)
	DllStructSetData($tItem, "Mask", $TVIF_PARAM)
	DllStructSetData($tItem, "Param", 0)
	Local $bUnicode = _GUICtrlTreeView_GetUnicodeFormat($hWnd)
	If IsHWnd($hWnd) Then
		; get the handle to item selected
		If $hItem = 0x00000000 Then $hItem = _SendMessage($hWnd, $TVM_GETNEXTITEM, $TVGN_CARET, 0, 0, "wparam", "lparam", "handle")
		If $hItem = 0x00000000 Then Return False
		DllStructSetData($tItem, "hItem", $hItem)
		; get the item properties
		If $bUnicode Then
			If _SendMessage($hWnd, $TVM_GETITEMW, 0, $tItem, 0, "wparam", "struct*") = 0 Then Return False
		Else
			If _SendMessage($hWnd, $TVM_GETITEMA, 0, $tItem, 0, "wparam", "struct*") = 0 Then Return False
		EndIf
	Else
		; get the handle to item selected
		If $hItem = 0x00000000 Then
			$hItem = Ptr(GUICtrlSendMsg($hWnd, $TVM_GETNEXTITEM, $TVGN_CARET, 0))
			If $hItem = 0x00000000 Then Return False
		Else
			Local $hTempItem = GUICtrlGetHandle($hItem)
			If $hTempItem <> 0x00000000 Then
				$hItem = $hTempItem
			Else
				Return False
			EndIf
		EndIf
		DllStructSetData($tItem, "hItem", $hItem)
		; get the item properties
		If $bUnicode Then
			If GUICtrlSendMsg($hWnd, $TVM_GETITEMW, 0, DllStructGetPtr($tItem)) = 0 Then Return False
		Else
			If GUICtrlSendMsg($hWnd, $TVM_GETITEMA, 0, DllStructGetPtr($tItem)) = 0 Then Return False
		EndIf
	EndIf

	Return DllStructGetData($tItem, "Param")
EndFunc   ;==>_GUICtrlTreeView_GetItemParam

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_GetLastChild($hWnd, $hItem)
	Local $hResult = _GUICtrlTreeView_GetFirstChild($hWnd, $hItem)
	If $hResult <> 0x00000000 Then
		Local $hNext = $hResult
		Do
			$hResult = $hNext
			$hNext = _GUICtrlTreeView_GetNextSibling($hWnd, $hNext)
		Until $hNext = 0x00000000
	EndIf
	Return $hResult
EndFunc   ;==>_GUICtrlTreeView_GetLastChild

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_GetLineColor($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $sHex = Hex(String(_SendMessage($hWnd, $TVM_GETLINECOLOR)), 6)
	Return '0x' & StringMid($sHex, 5, 2) & StringMid($sHex, 3, 2) & StringMid($sHex, 1, 2)
EndFunc   ;==>_GUICtrlTreeView_GetLineColor

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlTreeView_GetNext($hWnd, $hItem)
	If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $hResult = 0
	If $hItem <> 0x00000000 And $hItem <> 0 Then
		Local $hNext = _GUICtrlTreeView_GetFirstChild($hWnd, $hItem)
		If $hNext = 0x00000000 Then
			$hNext = _GUICtrlTreeView_GetNextSibling($hWnd, $hItem)
		EndIf
		Local $hParent = $hItem
		While ($hNext = 0x00000000) And ($hParent <> 0x00000000)
			$hParent = _GUICtrlTreeView_GetParentHandle($hWnd, $hParent)
			If $hParent = 0x00000000 Then
				$hNext = 0x00000000
				ExitLoop
			EndIf
			$hNext = _GUICtrlTreeView_GetNextSibling($hWnd, $hParent)
		WEnd
		If $hNext = 0x00000000 Then $hNext = 0
		$hResult = $hNext
	EndIf
	Return $hResult
EndFunc   ;==>_GUICtrlTreeView_GetNext

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_GetNextChild($hWnd, $hItem)
	Return _GUICtrlTreeView_GetNextSibling($hWnd, $hItem)
EndFunc   ;==>_GUICtrlTreeView_GetNextChild

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_GetNextSibling($hWnd, $hItem)
	If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $TVM_GETNEXTITEM, $TVGN_NEXT, $hItem, 0, "wparam", "handle", "handle")
EndFunc   ;==>_GUICtrlTreeView_GetNextSibling

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_GetNextVisible($hWnd, $hItem)
	If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $TVM_GETNEXTITEM, $TVGN_NEXTVISIBLE, $hItem, 0, "wparam", "handle", "handle")
EndFunc   ;==>_GUICtrlTreeView_GetNextVisible

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_GetNormalImageList($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $TVM_GETIMAGELIST, $TVSIL_NORMAL, 0, 0, "wparam", "lparam", "handle")
EndFunc   ;==>_GUICtrlTreeView_GetNormalImageList

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _GUICtrlTreeView_GetOverlayImageIndex
; Description ...: Returns the index of the image from the image list that is used as an overlay mask
; Syntax.........: _GUICtrlTreeView_GetOverlayImageIndex ( $hWnd, $hItem )
; Parameters ....: $hWnd        - Handle to the control
;                  $hItem       - Handle to the item
; Return values .: Success      - Overlay list index
;                  Failure      - 0
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......:
; Related .......: _GUICtrlTreeView_SetOverlayImageIndex
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _GUICtrlTreeView_GetOverlayImageIndex($hWnd, $hItem)
	Local $tItem = DllStructCreate($tagTVITEMEX)
	DllStructSetData($tItem, "Mask", $TVIF_STATE)
	DllStructSetData($tItem, "hItem", $hItem)
	DllStructSetData($tItem, "StateMask", $TVIS_OVERLAYMASK)
	__GUICtrlTreeView_GetItem($hWnd, $tItem)
	Return DllStructGetData($tItem, "Image")
EndFunc   ;==>_GUICtrlTreeView_GetOverlayImageIndex

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost), Holger Kotsch
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_GetParentHandle($hWnd, $hItem = 0)
	;If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	If $hItem = 0 Then $hItem = 0x00000000

	; get the handle to item selected
	If $hItem = 0x00000000 Then
		If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
		$hItem = _SendMessage($hWnd, $TVM_GETNEXTITEM, $TVGN_CARET, 0, 0, "wparam", "handle", "handle")
		If $hItem = 0x00000000 Then Return False
	Else
		If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
		If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	EndIf
	; get the handle of the parent item
	Local $hParent = _SendMessage($hWnd, $TVM_GETNEXTITEM, $TVGN_PARENT, $hItem, 0, "wparam", "handle", "handle")

	Return $hParent
EndFunc   ;==>_GUICtrlTreeView_GetParentHandle

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_GetParentParam($hWnd, $hItem = 0)
	If $hItem = 0 Then $hItem = 0x00000000

	Local $tTVITEM = DllStructCreate($tagTVITEMEX)
	DllStructSetData($tTVITEM, "Mask", $TVIF_PARAM)
	DllStructSetData($tTVITEM, "Param", 0)

	Local $hParent
	If IsHWnd($hWnd) Then
		; get the handle to item selected
		If $hItem = 0x00000000 Then $hItem = _SendMessage($hWnd, $TVM_GETNEXTITEM, $TVGN_CARET, 0, 0, "wparam", "handle", "handle")
		If $hItem = 0x00000000 Then Return False
		; get the handle of the parent item
		$hParent = _SendMessage($hWnd, $TVM_GETNEXTITEM, $TVGN_PARENT, $hItem, 0, "wparam", "handle", "handle")
		DllStructSetData($tTVITEM, "hItem", $hParent)
		; get the item properties
		If _SendMessage($hWnd, $TVM_GETITEMA, 0, $tTVITEM, 0, "wparam", "struct*") = 0 Then Return False
	Else
		; get the handle to item selected
		If $hItem = 0x00000000 Then
			$hItem = GUICtrlSendMsg($hWnd, $TVM_GETNEXTITEM, $TVGN_CARET, 0)
			If $hItem = 0x00000000 Then Return False
		Else
			Local $hTempItem = GUICtrlGetHandle($hItem)
			If $hTempItem <> 0x00000000 Then
				$hItem = $hTempItem
			Else
				Return False
			EndIf
		EndIf
		; get the handle of the parent item
		$hParent = GUICtrlSendMsg($hWnd, $TVM_GETNEXTITEM, $TVGN_PARENT, $hItem)
		DllStructSetData($tTVITEM, "hItem", $hParent)
		; get the item properties
		If GUICtrlSendMsg($hWnd, $TVM_GETITEMA, 0, DllStructGetPtr($tTVITEM)) = 0 Then Return False
	EndIf

	Return DllStructGetData($tTVITEM, "Param")
EndFunc   ;==>_GUICtrlTreeView_GetParentParam

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_GetPrev($hWnd, $hItem)
	If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $hResult = _GUICtrlTreeView_GetPrevChild($hWnd, $hItem)
	If $hResult <> 0x00000000 Then
		Local $hPrev = $hResult
		Do
			$hResult = $hPrev
			$hPrev = _GUICtrlTreeView_GetLastChild($hWnd, $hPrev)
		Until $hPrev = 0x00000000
	Else
		$hResult = _GUICtrlTreeView_GetParentHandle($hWnd, $hItem)
	EndIf
	Return $hResult
EndFunc   ;==>_GUICtrlTreeView_GetPrev

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_GetPrevChild($hWnd, $hItem)
	Return _GUICtrlTreeView_GetPrevSibling($hWnd, $hItem)
EndFunc   ;==>_GUICtrlTreeView_GetPrevChild

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_GetPrevSibling($hWnd, $hItem)
	If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $TVM_GETNEXTITEM, $TVGN_PREVIOUS, $hItem, 0, "wparam", "handle", "handle")
EndFunc   ;==>_GUICtrlTreeView_GetPrevSibling

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_GetPrevVisible($hWnd, $hItem)
	If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $TVM_GETNEXTITEM, $TVGN_PREVIOUSVISIBLE, $hItem, 0, "wparam", "handle", "handle")
EndFunc   ;==>_GUICtrlTreeView_GetPrevVisible

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_GetScrollTime($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $TVM_GETSCROLLTIME)
EndFunc   ;==>_GUICtrlTreeView_GetScrollTime

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_GetSelected($hWnd, $hItem)
	Return BitAND(_GUICtrlTreeView_GetState($hWnd, $hItem), $TVIS_SELECTED) <> 0
EndFunc   ;==>_GUICtrlTreeView_GetSelected

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_GetSelectedImageIndex($hWnd, $hItem)
	If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $tItem = DllStructCreate($tagTVITEMEX)
	DllStructSetData($tItem, "Mask", $TVIF_SELECTEDIMAGE)
	DllStructSetData($tItem, "hItem", $hItem)
	__GUICtrlTreeView_GetItem($hWnd, $tItem)
	Return DllStructGetData($tItem, "SelectedImage")
EndFunc   ;==>_GUICtrlTreeView_GetSelectedImageIndex

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_GetSelection($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $TVM_GETNEXTITEM, $TVGN_CARET, 0, 0, "wparam", "handle", "handle")
EndFunc   ;==>_GUICtrlTreeView_GetSelection

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_GetSiblingCount($hWnd, $hItem)
	If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $hNext, $iRet = 0

	Local $hParent = _GUICtrlTreeView_GetParentHandle($hWnd, $hItem)
	If $hParent <> 0x00000000 Then
		$hNext = _GUICtrlTreeView_GetFirstChild($hWnd, $hParent)
		If $hNext = 0x00000000 Then Return -1
		Do
			$iRet += 1
			$hNext = _GUICtrlTreeView_GetNextSibling($hWnd, $hNext)
		Until $hNext = 0x00000000
	Else
		$hNext = _GUICtrlTreeView_GetFirstItem($hWnd)
		If $hNext = 0x00000000 Then Return -1
		Do
			$iRet += 1
			$hNext = _GUICtrlTreeView_GetNextSibling($hWnd, $hNext)
		Until $hNext = 0x00000000
	EndIf
	Return $iRet
EndFunc   ;==>_GUICtrlTreeView_GetSiblingCount

; #FUNCTION# ====================================================================================================================
; Author ........: Holger Kotsch
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_GetState($hWnd, $hItem = 0)
	If $hItem = 0 Then $hItem = 0x00000000

	$hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
	If $hItem = 0x00000000 Then Return SetError(1, 1, 0)

	Local $tTVITEM = DllStructCreate($tagTVITEMEX)
	DllStructSetData($tTVITEM, "Mask", $TVIF_STATE)
	DllStructSetData($tTVITEM, "hItem", $hItem)

	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	If _WinAPI_InProcess($hWnd, $__g_hTVLastWnd) Then
		_SendMessage($hWnd, $TVM_GETITEMA, 0, $tTVITEM, 0, "wparam", "struct*")
	Else
		Local $iSize = DllStructGetSize($tTVITEM)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iSize, $tMemMap)
		_MemWrite($tMemMap, $tTVITEM)
		_SendMessage($hWnd, $TVM_GETITEMA, 0, $pMemory)
		_MemRead($tMemMap, $pMemory, $tTVITEM, $iSize)
		_MemFree($tMemMap)
	EndIf

	Return DllStructGetData($tTVITEM, "State")
EndFunc   ;==>_GUICtrlTreeView_GetState

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_GetStateImageIndex($hWnd, $hItem)
	$hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)

	Local $tItem = DllStructCreate($tagTVITEMEX)
	DllStructSetData($tItem, "Mask", $TVIF_STATE)
	DllStructSetData($tItem, "hItem", $hItem)
	__GUICtrlTreeView_GetItem($hWnd, $tItem)
	Return BitShift(BitAND(DllStructGetData($tItem, "State"), $TVIS_STATEIMAGEMASK), 12)
EndFunc   ;==>_GUICtrlTreeView_GetStateImageIndex

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_GetStateImageList($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $TVM_GETIMAGELIST, $TVSIL_STATE, 0, 0, "wparam", "handle", "handle")
EndFunc   ;==>_GUICtrlTreeView_GetStateImageList

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_GetText($hWnd, $hItem = 0)
	If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	If $hItem = 0x00000000 Then Return SetError(1, 1, "")

	Local $tTVITEM = DllStructCreate($tagTVITEMEX)
	Local $tText
	Local $bUnicode = _GUICtrlTreeView_GetUnicodeFormat($hWnd)
	If $bUnicode Then
		$tText = DllStructCreate("wchar Buffer[4096]"); create a text 'area' for receiving the text
	Else
		$tText = DllStructCreate("char Buffer[4096]"); create a text 'area' for receiving the text
	EndIf

	DllStructSetData($tTVITEM, "Mask", $TVIF_TEXT)
	DllStructSetData($tTVITEM, "hItem", $hItem)
	DllStructSetData($tTVITEM, "TextMax", 4096)

	If _WinAPI_InProcess($hWnd, $__g_hTVLastWnd) Then
		DllStructSetData($tTVITEM, "Text", DllStructGetPtr($tText))
		_SendMessage($hWnd, $TVM_GETITEMW, 0, $tTVITEM, 0, "wparam", "struct*")
	Else
		Local $iItem = DllStructGetSize($tTVITEM)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iItem + 4096, $tMemMap)
		Local $pText = $pMemory + $iItem
		DllStructSetData($tTVITEM, "Text", $pText)
		_MemWrite($tMemMap, $tTVITEM, $pMemory, $iItem)
		If $bUnicode Then
			_SendMessage($hWnd, $TVM_GETITEMW, 0, $pMemory, 0, "wparam", "ptr")
		Else
			_SendMessage($hWnd, $TVM_GETITEMA, 0, $pMemory, 0, "wparam", "ptr")
		EndIf
		_MemRead($tMemMap, $pText, $tText, 4096)
		_MemFree($tMemMap)
	EndIf

	Return DllStructGetData($tText, "Buffer")
EndFunc   ;==>_GUICtrlTreeView_GetText

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_GetTextColor($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $sHex = Hex(String(_SendMessage($hWnd, $TVM_GETTEXTCOLOR)), 6)
	Return '0x' & StringMid($sHex, 5, 2) & StringMid($sHex, 3, 2) & StringMid($sHex, 1, 2)
EndFunc   ;==>_GUICtrlTreeView_GetTextColor

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_GetToolTips($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $TVM_GETTOOLTIPS, 0, 0, 0, "wparam", "lparam", "hwnd")
EndFunc   ;==>_GUICtrlTreeView_GetToolTips

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost), Holger Kotsch
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_GetTree($hWnd, $hItem = 0)
	If $hItem = 0 Then
		$hItem = 0x00000000
	Else
		If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
	EndIf
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $sPath = ""

	If $hItem = 0x00000000 Then $hItem = _SendMessage($hWnd, $TVM_GETNEXTITEM, $TVGN_CARET, 0, 0, "wparam", "handle", "handle")
	If $hItem <> 0x00000000 Then
		$sPath = _GUICtrlTreeView_GetText($hWnd, $hItem)

		Local $hParent, $sSeparator = Opt("GUIDataSeparatorChar")
		Do; Get now the parent item handle if there is one
			$hParent = _SendMessage($hWnd, $TVM_GETNEXTITEM, $TVGN_PARENT, $hItem, 0, "wparam", "handle", "handle")
			If $hParent <> 0x00000000 Then $sPath = _GUICtrlTreeView_GetText($hWnd, $hParent) & $sSeparator & $sPath
			$hItem = $hParent
		Until $hItem = 0x00000000
	EndIf

	Return $sPath
EndFunc   ;==>_GUICtrlTreeView_GetTree

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_GetUnicodeFormat($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $TVM_GETUNICODEFORMAT) <> 0
EndFunc   ;==>_GUICtrlTreeView_GetUnicodeFormat

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_GetVisible($hWnd, $hItem)
	If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $tRECT = DllStructCreate($tagRECT)
	DllStructSetData($tRECT, "Left", $hItem)
	Local $iRet
	If _WinAPI_InProcess($hWnd, $__g_hTVLastWnd) Then
		$iRet = _SendMessage($hWnd, $TVM_GETITEMRECT, True, $tRECT, 0, "wparam", "struct*")
	Else
		Local $iRect = DllStructGetSize($tRECT)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iRect, $tMemMap)
		_MemWrite($tMemMap, $tRECT)
		$iRet = _SendMessage($hWnd, $TVM_GETITEMRECT, True, $pMemory, 0, "wparam", "ptr")
		_MemRead($tMemMap, $pMemory, $tRECT, $iRect)
		_MemFree($tMemMap)
	EndIf
	If $iRet = 0 Then Return False ; item is child item, collapsed and not visible

	; item may not be collapsed or may be at the root level the above will give a rect even it isn't in the view
	; check to see if it is visible to the eye
	Local $iControlHeight = _WinAPI_GetWindowHeight($hWnd)
	If DllStructGetData($tRECT, "Top") >= $iControlHeight Or _
			DllStructGetData($tRECT, "Bottom") <= 0 Then
		Return False
	Else
		Return True
	EndIf
EndFunc   ;==>_GUICtrlTreeView_GetVisible

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_GetVisibleCount($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $TVM_GETVISIBLECOUNT)
EndFunc   ;==>_GUICtrlTreeView_GetVisibleCount

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_HitTest($hWnd, $iX, $iY)
	Local $tHitTest = _GUICtrlTreeView_HitTestEx($hWnd, $iX, $iY)
	Local $iFlags = DllStructGetData($tHitTest, "Flags")
	Local $iRet = 0
	If BitAND($iFlags, $TVHT_NOWHERE) <> 0 Then $iRet = BitOR($iRet, 1)
	If BitAND($iFlags, $TVHT_ONITEMICON) <> 0 Then $iRet = BitOR($iRet, 2)
	If BitAND($iFlags, $TVHT_ONITEMLABEL) <> 0 Then $iRet = BitOR($iRet, 4)
	If BitAND($iFlags, $TVHT_ONITEMINDENT) <> 0 Then $iRet = BitOR($iRet, 8)
	If BitAND($iFlags, $TVHT_ONITEMBUTTON) <> 0 Then $iRet = BitOR($iRet, 16)
	If BitAND($iFlags, $TVHT_ONITEMRIGHT) <> 0 Then $iRet = BitOR($iRet, 32)
	If BitAND($iFlags, $TVHT_ONITEMSTATEICON) <> 0 Then $iRet = BitOR($iRet, 64)
	If BitAND($iFlags, $TVHT_ABOVE) <> 0 Then $iRet = BitOR($iRet, 128)
	If BitAND($iFlags, $TVHT_BELOW) <> 0 Then $iRet = BitOR($iRet, 256)
	If BitAND($iFlags, $TVHT_TORIGHT) <> 0 Then $iRet = BitOR($iRet, 512)
	If BitAND($iFlags, $TVHT_TOLEFT) <> 0 Then $iRet = BitOR($iRet, 1024)
	Return $iRet
EndFunc   ;==>_GUICtrlTreeView_HitTest

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_HitTestEx($hWnd, $iX, $iY)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $tHitTest = DllStructCreate($tagTVHITTESTINFO)
	DllStructSetData($tHitTest, "X", $iX)
	DllStructSetData($tHitTest, "Y", $iY)
	If _WinAPI_InProcess($hWnd, $__g_hTVLastWnd) Then
		_SendMessage($hWnd, $TVM_HITTEST, 0, $tHitTest, 0, "wparam", "struct*")
	Else
		Local $iHitTest = DllStructGetSize($tHitTest)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iHitTest, $tMemMap)
		_MemWrite($tMemMap, $tHitTest)
		_SendMessage($hWnd, $TVM_HITTEST, 0, $pMemory, 0, "wparam", "ptr")
		_MemRead($tMemMap, $pMemory, $tHitTest, $iHitTest)
		_MemFree($tMemMap)
	EndIf
	Return $tHitTest
EndFunc   ;==>_GUICtrlTreeView_HitTestEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_HitTestItem($hWnd, $iX, $iY)
	Local $tHitTest = _GUICtrlTreeView_HitTestEx($hWnd, $iX, $iY)
	Return DllStructGetData($tHitTest, "Item")
EndFunc   ;==>_GUICtrlTreeView_HitTestItem

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_Index($hWnd, $hItem)
	If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $iRet = -1
	Local $hParent = _GUICtrlTreeView_GetParentHandle($hWnd, $hItem)
	Local $hNext
	If $hParent <> 0x00000000 Then
		$hNext = _GUICtrlTreeView_GetFirstChild($hWnd, $hParent)
		While $hNext <> 0x00000000
			$iRet += 1
			If $hNext = $hItem Then ExitLoop
			$hNext = _GUICtrlTreeView_GetNextSibling($hWnd, $hNext)
		WEnd
	Else
		$hNext = _GUICtrlTreeView_GetFirstItem($hWnd)
		While $hNext <> 0x00000000
			$iRet += 1
			If $hNext = $hItem Then ExitLoop
			$hNext = _GUICtrlTreeView_GetNextSibling($hWnd, $hNext)
		WEnd
	EndIf
	If $hNext = 0x00000000 Then $iRet = -1
	Return $iRet
EndFunc   ;==>_GUICtrlTreeView_Index

; #FUNCTION# ====================================================================================================================
; Author ........: Holger Kotsch
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_InsertItem($hWnd, $sItem_Text, $hItem_Parent = 0, $hItem_After = 0, $iImage = -1, $iSelImage = -1)
	Local $tTVI = DllStructCreate($tagTVINSERTSTRUCT)

	Local $iBuffer, $pBuffer
	If $sItem_Text <> -1 Then
		$iBuffer = StringLen($sItem_Text) + 1
		Local $tText
		Local $bUnicode = _GUICtrlTreeView_GetUnicodeFormat($hWnd)
		If $bUnicode Then
			$tText = DllStructCreate("wchar Buffer[" & $iBuffer & "]")
			$iBuffer *= 2
		Else
			$tText = DllStructCreate("char Buffer[" & $iBuffer & "]")
		EndIf
		DllStructSetData($tText, "Buffer", $sItem_Text)
		$pBuffer = DllStructGetPtr($tText)
	Else
		$iBuffer = 0
		$pBuffer = -1 ; LPSTR_TEXTCALLBACK
	EndIf

	Local $hItem_tmp
	If $hItem_Parent = 0 Then ; setting to root level
		$hItem_Parent = $TVI_ROOT
	ElseIf Not IsHWnd($hItem_Parent) Then ; control created by autoit create
		$hItem_tmp = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem_Parent)
		If $hItem_tmp Then $hItem_Parent = $hItem_tmp
	EndIf

	If $hItem_After = 0 Then ; using default
		$hItem_After = $TVI_LAST
	ElseIf ($hItem_After <> $TVI_ROOT And _
			$hItem_After <> $TVI_FIRST And _
			$hItem_After <> $TVI_LAST And _
			$hItem_After <> $TVI_SORT) Then ; not using flag
		If Not IsHWnd($hItem_After) Then
			$hItem_tmp = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem_After)
			If Not $hItem_tmp Then ; item not found or invalid flag used
				$hItem_After = $TVI_LAST
			Else ; setting handle
				$hItem_After = $hItem_tmp
			EndIf
		EndIf
	EndIf

	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $hIcon
	Local $iMask = $TVIF_TEXT
	If $iImage >= 0 Then
		$iMask = BitOR($iMask, $TVIF_IMAGE)
		$iMask = BitOR($iMask, $TVIF_IMAGE)
		DllStructSetData($tTVI, "Image", $iImage)
	Else
		$hIcon = _GUICtrlTreeView_GetImageListIconHandle($hWnd, 0)
		If $hIcon <> 0x00000000 Then
			$iMask = BitOR($iMask, $TVIF_IMAGE)
			DllStructSetData($tTVI, "Image", 0)
			DllCall("user32.dll", "int", "DestroyIcon", "handle", $hIcon)
			; No @error test because results are unimportant.
		EndIf
	EndIf

	If $iSelImage >= 0 Then
		$iMask = BitOR($iMask, $TVIF_SELECTEDIMAGE)
		$iMask = BitOR($iMask, $TVIF_SELECTEDIMAGE)
		DllStructSetData($tTVI, "SelectedImage", $iSelImage)
	Else
		$hIcon = _GUICtrlTreeView_GetImageListIconHandle($hWnd, 1)
		If $hIcon <> 0x00000000 Then
			$iMask = BitOR($iMask, $TVIF_SELECTEDIMAGE)
			DllStructSetData($tTVI, "SelectedImage", 0)
			DllCall("user32.dll", "int", "DestroyIcon", "handle", $hIcon)
			; No @error test because results are unimportant.
		EndIf
	EndIf

	DllStructSetData($tTVI, "Parent", $hItem_Parent)
	DllStructSetData($tTVI, "InsertAfter", $hItem_After)
	DllStructSetData($tTVI, "Mask", $iMask)
	DllStructSetData($tTVI, "TextMax", $iBuffer)
	$iMask = BitOR($iMask, $TVIF_PARAM)
	DllStructSetData($tTVI, "Param", 0)

	Local $hItem
	If _WinAPI_InProcess($hWnd, $__g_hTVLastWnd) Then
		DllStructSetData($tTVI, "Text", $pBuffer)
		$hItem = _SendMessage($hWnd, $TVM_INSERTITEMW, 0, $tTVI, 0, "wparam", "struct*", "handle")

	Else
		Local $iInsert = DllStructGetSize($tTVI)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iInsert + $iBuffer, $tMemMap)
		If $sItem_Text <> -1 Then
			Local $pText = $pMemory + $iInsert
			DllStructSetData($tTVI, "Text", $pText)
			_MemWrite($tMemMap, $tText, $pText, $iBuffer)
		Else
			DllStructSetData($tTVI, "Text", -1) ; LPSTR_TEXTCALLBACK
		EndIf
		_MemWrite($tMemMap, $tTVI, $pMemory, $iInsert)
		If $bUnicode Then
			$hItem = _SendMessage($hWnd, $TVM_INSERTITEMW, 0, $pMemory, 0, "wparam", "ptr", "handle")
		Else
			$hItem = _SendMessage($hWnd, $TVM_INSERTITEMA, 0, $pMemory, 0, "wparam", "ptr", "handle")
		EndIf
		_MemFree($tMemMap)
	EndIf
	Return $hItem
EndFunc   ;==>_GUICtrlTreeView_InsertItem

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_IsFirstItem($hWnd, $hItem)
	If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _GUICtrlTreeView_GetFirstItem($hWnd) = $hItem
EndFunc   ;==>_GUICtrlTreeView_IsFirstItem

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_IsParent($hWnd, $hParent, $hItem)
	If Not IsHWnd($hParent) Then $hParent = _GUICtrlTreeView_GetItemHandle($hWnd, $hParent)
	If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _GUICtrlTreeView_GetParentHandle($hWnd, $hItem) = $hParent
EndFunc   ;==>_GUICtrlTreeView_IsParent

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_Level($hWnd, $hItem)
	Local $iRet = 0
	Local $hNext = _GUICtrlTreeView_GetParentHandle($hWnd, $hItem)
	While $hNext <> 0x00000000
		$iRet += 1
		$hNext = _GUICtrlTreeView_GetParentHandle($hWnd, $hNext)
	WEnd
	Return $iRet
EndFunc   ;==>_GUICtrlTreeView_Level

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _GUICtrlTreeView_MapAccIDToItem
; Description ...: Maps an accessibility ID to an HTREEITEM
; Syntax.........: _GUICtrlTreeView_MapAccIDToItem ( $hWnd, $iID )
; Parameters ....: $hWnd        - Handle to the control
;                  $iID         - Accessibility ID
; Return values .: Success      - The HTREEITEM that the specified accessibility ID is mapped to
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; Remarks .......: Minimum OS Windows XP.
; +
;                  When you add an item to a control an HTREEITEM returns, which uniquely identifies the item.
; Related .......: _GUICtrlTreeView_MapItemToAccID
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _GUICtrlTreeView_MapAccIDToItem($hWnd, $iID)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $TVM_MAPACCIDTOHTREEITEM, $iID, 0, 0, "wparam", "lparam", "handle")
EndFunc   ;==>_GUICtrlTreeView_MapAccIDToItem

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _GUICtrlTreeView_MapItemToAccID
; Description ...: Maps an HTREEITEM to an accessibility ID
; Syntax.........: _GUICtrlTreeView_MapItemToAccID ( $hWnd, $hTreeItem )
; Parameters ....: $hWnd        - Handle to the control
;                  $hTreeItem   - HTREEITEM that is mapped to an accessibility ID
; Return values .: Success      - Returns an accessibility ID
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; Remarks .......: Minimum OS Windows XP.
; +
;                  When you add an item to a control an HTREEITEM returns, which uniquely identifies the item.
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _GUICtrlTreeView_MapItemToAccID($hWnd, $hTreeItem)
	If Not IsHWnd($hTreeItem) Then $hTreeItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hTreeItem)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $TVM_MAPHTREEITEMTOACCID, $hTreeItem, 0, 0, "handle")
EndFunc   ;==>_GUICtrlTreeView_MapItemToAccID

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUICtrlTreeView_ReverseColorOrder
; Description ...: Convert Hex RGB or BGR Color to Hex RGB or BGR Color
; Syntax.........: __GUICtrlTreeView_ReverseColorOrder ( $vColor )
; Parameters ....: $vColor      - Hex Color
; Return values .: Success      - Hex RGB or BGR Color
; Author ........: Gary Frost (gafrost)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __GUICtrlTreeView_ReverseColorOrder($vColor)
	Local $sHex = Hex(String($vColor), 6)
	Return '0x' & StringMid($sHex, 5, 2) & StringMid($sHex, 3, 2) & StringMid($sHex, 1, 2)
EndFunc   ;==>__GUICtrlTreeView_ReverseColorOrder

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_SelectItem($hWnd, $hItem, $iFlag = 0)
	If Not IsHWnd($hItem) And $hItem <> 0 Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	If $iFlag = 0 Then $iFlag = $TVGN_CARET
	Return _SendMessage($hWnd, $TVM_SELECTITEM, $iFlag, $hItem, 0, "wparam", "handle") <> 0
EndFunc   ;==>_GUICtrlTreeView_SelectItem

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_SelectItemByIndex($hWnd, $hItem, $iIndex)
	Return _GUICtrlTreeView_SelectItem($hWnd, _GUICtrlTreeView_GetItemByIndex($hWnd, $hItem, $iIndex))
EndFunc   ;==>_GUICtrlTreeView_SelectItemByIndex

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_SetBkColor($hWnd, $vRGBColor)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return __GUICtrlTreeView_ReverseColorOrder(_SendMessage($hWnd, $TVM_SETBKCOLOR, 0, Int(__GUICtrlTreeView_ReverseColorOrder($vRGBColor))))
EndFunc   ;==>_GUICtrlTreeView_SetBkColor

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_SetBold($hWnd, $hItem, $bFlag = True)
	Return _GUICtrlTreeView_SetState($hWnd, $hItem, $TVIS_BOLD, $bFlag)
EndFunc   ;==>_GUICtrlTreeView_SetBold

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_SetChecked($hWnd, $hItem, $bCheck = True)
	If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $tItem = DllStructCreate($tagTVITEMEX)
	DllStructSetData($tItem, "Mask", $TVIF_STATE)
	DllStructSetData($tItem, "hItem", $hItem)
	If $bCheck Then
		DllStructSetData($tItem, "State", 0x2000)
	Else
		DllStructSetData($tItem, "State", 0x1000)
	EndIf
	DllStructSetData($tItem, "StateMask", 0xf000)
	Return __GUICtrlTreeView_SetItem($hWnd, $tItem)
EndFunc   ;==>_GUICtrlTreeView_SetChecked

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_SetCheckedByIndex($hWnd, $hItem, $iIndex, $bCheck = True)
	If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $hChild = _GUICtrlTreeView_GetItemByIndex($hWnd, $hItem, $iIndex)
	Return _GUICtrlTreeView_SetChecked($hWnd, $hChild, $bCheck)
EndFunc   ;==>_GUICtrlTreeView_SetCheckedByIndex

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_SetChildren($hWnd, $hItem, $bFlag = True)
	If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $tItem = DllStructCreate($tagTVITEMEX)
	DllStructSetData($tItem, "Mask", BitOR($TVIF_HANDLE, $TVIF_CHILDREN))
	DllStructSetData($tItem, "hItem", $hItem)
	DllStructSetData($tItem, "Children", $bFlag)
	Return __GUICtrlTreeView_SetItem($hWnd, $tItem)
EndFunc   ;==>_GUICtrlTreeView_SetChildren

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_SetCut($hWnd, $hItem, $bFlag = True)
	If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _GUICtrlTreeView_SetState($hWnd, $hItem, $TVIS_CUT, $bFlag)
EndFunc   ;==>_GUICtrlTreeView_SetCut

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_SetDropTarget($hWnd, $hItem, $bFlag = True)
	If $bFlag Then
		Return _GUICtrlTreeView_SelectItem($hWnd, $hItem, $TVGN_DROPHILITE)
	ElseIf _GUICtrlTreeView_GetDropTarget($hWnd, $hItem) Then
		Return _GUICtrlTreeView_SelectItem($hWnd, 0)
	EndIf
	Return False
EndFunc   ;==>_GUICtrlTreeView_SetDropTarget

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_SetFocused($hWnd, $hItem, $bFlag = True)
	Return _GUICtrlTreeView_SetState($hWnd, $hItem, $TVIS_FOCUSED, $bFlag)
EndFunc   ;==>_GUICtrlTreeView_SetFocused

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_SetHeight($hWnd, $iHeight)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $TVM_SETITEMHEIGHT, $iHeight)
EndFunc   ;==>_GUICtrlTreeView_SetHeight

; #FUNCTION# ====================================================================================================================
; Author ........: Holger Kotsch
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_SetIcon($hWnd, $hItem = 0, $sIconFile = "", $iIconID = 0, $iImageMode = 6)
	If $hItem = 0 Then $hItem = 0x00000000

	If $hItem <> 0x00000000 And Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
	If $hItem = 0x00000000 Or $sIconFile = "" Then Return SetError(1, 1, False)

	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $tTVITEM = DllStructCreate($tagTVITEMEX)

	Local $tIcon = DllStructCreate("handle")
	Local $aCount = DllCall("shell32.dll", "uint", "ExtractIconExW", "wstr", $sIconFile, "int", $iIconID, _
			"handle", 0, "struct*", $tIcon, "uint", 1)
	If @error Then Return SetError(@error, @extended, 0)
	If $aCount[0] = 0 Then Return 0

	Local $hImageList = _SendMessage($hWnd, $TVM_GETIMAGELIST, 0, 0, 0, "wparam", "lparam", "handle")
	If $hImageList = 0x00000000 Then
		$hImageList = DllCall("comctl32.dll", "handle", "ImageList_Create", "int", 16, "int", 16, "uint", 0x0021, "int", 0, "int", 1)
		If @error Then Return SetError(@error, @extended, 0)
		$hImageList = $hImageList[0]
		If $hImageList = 0 Then Return SetError(1, 1, False)

		_SendMessage($hWnd, $TVM_SETIMAGELIST, 0, $hImageList, 0, "wparam", "handle")
	EndIf

	Local $hIcon = DllStructGetData($tIcon, 1)
	Local $vIcon = DllCall("comctl32.dll", "int", "ImageList_AddIcon", "handle", $hImageList, "handle", $hIcon)
	$vIcon = $vIcon[0]
	If @error Then
		Local $iError = @error, $iExtended = @extended
		DllCall("user32.dll", "int", "DestroyIcon", "handle", $hIcon)
		; No @error test because results are unimportant.
		Return SetError($iError, $iExtended, 0)
	EndIf

	DllCall("user32.dll", "int", "DestroyIcon", "handle", $hIcon)
	; No @error test because results are unimportant.

	Local $iMask = BitOR($TVIF_IMAGE, $TVIF_SELECTEDIMAGE)

	If BitAND($iImageMode, 2) Then
		DllStructSetData($tTVITEM, "Image", $vIcon)
		If Not BitAND($iImageMode, 4) Then $iMask = $TVIF_IMAGE
	EndIf

	If BitAND($iImageMode, 4) Then
		DllStructSetData($tTVITEM, "SelectedImage", $vIcon)
		If Not BitAND($iImageMode, 2) Then
			$iMask = $TVIF_SELECTEDIMAGE
		Else
			$iMask = BitOR($TVIF_IMAGE, $TVIF_SELECTEDIMAGE)
		EndIf
	EndIf

	DllStructSetData($tTVITEM, "Mask", $iMask)
	DllStructSetData($tTVITEM, "hItem", $hItem)

	Return __GUICtrlTreeView_SetItem($hWnd, $tTVITEM)
EndFunc   ;==>_GUICtrlTreeView_SetIcon

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_SetImageIndex($hWnd, $hItem, $iIndex)
	If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $tItem = DllStructCreate($tagTVITEMEX)
	DllStructSetData($tItem, "Mask", BitOR($TVIF_HANDLE, $TVIF_IMAGE))
	DllStructSetData($tItem, "hItem", $hItem)
	DllStructSetData($tItem, "Image", $iIndex)
	Return __GUICtrlTreeView_SetItem($hWnd, $tItem)
EndFunc   ;==>_GUICtrlTreeView_SetImageIndex

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_SetIndent($hWnd, $iIndent)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	_SendMessage($hWnd, $TVM_SETINDENT, $iIndent)
EndFunc   ;==>_GUICtrlTreeView_SetIndent

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_SetInsertMark($hWnd, $hItem, $bAfter = True)
	If Not IsHWnd($hItem) And $hItem <> 0 Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $TVM_SETINSERTMARK, $bAfter, $hItem, 0, "wparam", "handle") <> 0
EndFunc   ;==>_GUICtrlTreeView_SetInsertMark

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_SetInsertMarkColor($hWnd, $iColor)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $TVM_SETINSERTMARKCOLOR, 0, $iColor)
EndFunc   ;==>_GUICtrlTreeView_SetInsertMarkColor

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUICtrlTreeView_SetItem
; Description ...: Sets some or all of a items attributes
; Syntax.........: __GUICtrlTreeView_SetItem ( $hWnd, ByRef $tItem )
; Parameters ....: $hWnd        - Handle to the control
;                  $tItem       - $tagTVITEMEX structure that contains the new item attributes
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; Remarks .......: This function is used internally and should not normally be called by the end user
; Related .......: __GUICtrlTreeView_GetItem
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __GUICtrlTreeView_SetItem($hWnd, ByRef $tItem)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $bUnicode = _GUICtrlTreeView_GetUnicodeFormat($hWnd)

	Local $iRet
	If _WinAPI_InProcess($hWnd, $__g_hTVLastWnd) Then
		$iRet = _SendMessage($hWnd, $TVM_SETITEMW, 0, $tItem, 0, "wparam", "struct*")
	Else
		Local $iItem = DllStructGetSize($tItem)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iItem, $tMemMap)
		_MemWrite($tMemMap, $tItem)
		If $bUnicode Then
			$iRet = _SendMessage($hWnd, $TVM_SETITEMW, 0, $pMemory, 0, "wparam", "ptr")
		Else
			$iRet = _SendMessage($hWnd, $TVM_SETITEMA, 0, $pMemory, 0, "wparam", "ptr")
		EndIf
		_MemFree($tMemMap)
	EndIf
	Return $iRet <> 0
EndFunc   ;==>__GUICtrlTreeView_SetItem

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_SetItemHeight($hWnd, $hItem, $iIntegral)
	If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)

	_GUICtrlTreeView_BeginUpdate($hWnd)
	Local $tItem = DllStructCreate($tagTVITEMEX)
	DllStructSetData($tItem, "Mask", BitOR($TVIF_HANDLE, $TVIF_INTEGRAL))
	DllStructSetData($tItem, "hItem", $hItem)
	DllStructSetData($tItem, "Integral", $iIntegral)
	Local $bResult = __GUICtrlTreeView_SetItem($hWnd, $tItem)
	_GUICtrlTreeView_EndUpdate($hWnd)
	Return $bResult
EndFunc   ;==>_GUICtrlTreeView_SetItemHeight

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_SetItemParam($hWnd, $hItem, $iParam)
	If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)

	Local $tItem = DllStructCreate($tagTVITEMEX)
	DllStructSetData($tItem, "Mask", BitOR($TVIF_HANDLE, $TVIF_PARAM))
	DllStructSetData($tItem, "hItem", $hItem)
	DllStructSetData($tItem, "Param", $iParam)
	Local $bResult = __GUICtrlTreeView_SetItem($hWnd, $tItem)
	Return $bResult
EndFunc   ;==>_GUICtrlTreeView_SetItemParam

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_SetLineColor($hWnd, $vRGBColor)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return __GUICtrlTreeView_ReverseColorOrder(_SendMessage($hWnd, $TVM_SETLINECOLOR, 0, Int(__GUICtrlTreeView_ReverseColorOrder($vRGBColor))))
EndFunc   ;==>_GUICtrlTreeView_SetLineColor

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_SetNormalImageList($hWnd, $hImageList)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $TVM_SETIMAGELIST, $TVSIL_NORMAL, $hImageList, 0, "wparam", "handle", "handle")
EndFunc   ;==>_GUICtrlTreeView_SetNormalImageList

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _GUICtrlTreeView_SetOverlayImageIndex
; Description ...: Sets the index into image list for the state image
; Syntax.........: _GUICtrlTreeView_SetOverlayImageIndex ( $hWnd, $hItem, $iIndex )
; Parameters ....: $hWnd        - Handle to the control
;                  $hItem       - Handle to the item
;                  $iIndex      - Image list index
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; Remarks .......:
; Related .......: _GUICtrlTreeView_GetOverlayImageIndex
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _GUICtrlTreeView_SetOverlayImageIndex($hWnd, $hItem, $iIndex)
	If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $tItem = DllStructCreate($tagTVITEMEX)
	DllStructSetData($tItem, "Mask", BitOR($TVIF_HANDLE, $TVIF_STATE))
	DllStructSetData($tItem, "hItem", $hItem)
	DllStructSetData($tItem, "State", BitShift($iIndex, -8))
	DllStructSetData($tItem, "StateMask", $TVIS_OVERLAYMASK)
	Return __GUICtrlTreeView_SetItem($hWnd, $tItem)
EndFunc   ;==>_GUICtrlTreeView_SetOverlayImageIndex

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_SetScrollTime($hWnd, $iTime)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $TVM_SETSCROLLTIME, $iTime)
EndFunc   ;==>_GUICtrlTreeView_SetScrollTime

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_SetSelected($hWnd, $hItem, $bFlag = True)
	Return _GUICtrlTreeView_SetState($hWnd, $hItem, $TVIS_SELECTED, $bFlag)
EndFunc   ;==>_GUICtrlTreeView_SetSelected

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_SetSelectedImageIndex($hWnd, $hItem, $iIndex)
	If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $tItem = DllStructCreate($tagTVITEMEX)
	DllStructSetData($tItem, "Mask", BitOR($TVIF_HANDLE, $TVIF_SELECTEDIMAGE))
	DllStructSetData($tItem, "hItem", $hItem)
	DllStructSetData($tItem, "SelectedImage", $iIndex)
	Return __GUICtrlTreeView_SetItem($hWnd, $tItem)
EndFunc   ;==>_GUICtrlTreeView_SetSelectedImageIndex

; #FUNCTION# ====================================================================================================================
; Author ........: Holger Kotsch
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_SetState($hWnd, $hItem, $iState = 0, $bSetState = True)
	If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
	If $hItem = 0x00000000 Or ($iState = 0 And $bSetState = False) Then Return False

	Local $tTVITEM = DllStructCreate($tagTVITEMEX)
	If @error Then Return SetError(1, 1, 0)
	DllStructSetData($tTVITEM, "Mask", $TVIF_STATE)
	DllStructSetData($tTVITEM, "hItem", $hItem)
	If $bSetState Then
		DllStructSetData($tTVITEM, "State", $iState)
	Else
		DllStructSetData($tTVITEM, "State", BitAND($bSetState, $iState))
	EndIf
	DllStructSetData($tTVITEM, "StateMask", $iState)
	If $bSetState Then DllStructSetData($tTVITEM, "StateMask", BitOR($bSetState, $iState))
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	Return __GUICtrlTreeView_SetItem($hWnd, $tTVITEM)
EndFunc   ;==>_GUICtrlTreeView_SetState

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_SetStateImageIndex($hWnd, $hItem, $iIndex)
	If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	If $iIndex < 0 Then
		; Invalid index for State Image" & @LF & "State Image List is One-based list
		Return SetError(1, 0, False)
	EndIf

	Local $tItem = DllStructCreate($tagTVITEMEX)
	DllStructSetData($tItem, "Mask", $TVIF_STATE)
	DllStructSetData($tItem, "hItem", $hItem)
	DllStructSetData($tItem, "State", BitShift($iIndex, -12))
	DllStructSetData($tItem, "StateMask", $TVIS_STATEIMAGEMASK)
	Return __GUICtrlTreeView_SetItem($hWnd, $tItem)
EndFunc   ;==>_GUICtrlTreeView_SetStateImageIndex

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_SetStateImageList($hWnd, $hImageList)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	; haven't figured out why but the state image list appears to use a 1 based index
	; add and icon
	_GUIImageList_AddIcon($hImageList, "shell32.dll", 0)
	Local $iCount = _GUIImageList_GetImageCount($hImageList)
	; shift it to the zero index, won't be used
	For $x = $iCount - 1 To 1 Step -1
		_GUIImageList_Swap($hImageList, $x, $x - 1)
	Next
	Return _SendMessage($hWnd, $TVM_SETIMAGELIST, $TVSIL_STATE, $hImageList, 0, "wparam", "handle", "handle")
EndFunc   ;==>_GUICtrlTreeView_SetStateImageList

; #FUNCTION# ====================================================================================================================
; Author ........: Holger Kotsch
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_SetText($hWnd, $hItem = 0, $sText = "")
	If Not IsHWnd($hItem) Then $hItem = _GUICtrlTreeView_GetItemHandle($hWnd, $hItem)
	If $hItem = 0x00000000 Or $sText = "" Then Return SetError(1, 1, 0)

	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $tTVITEM = DllStructCreate($tagTVITEMEX)
	Local $iBuffer = StringLen($sText) + 1
	Local $tBuffer
	Local $bUnicode = _GUICtrlTreeView_GetUnicodeFormat($hWnd)
	If $bUnicode Then
		$tBuffer = DllStructCreate("wchar Buffer[" & $iBuffer & "]")
		$iBuffer *= 2
	Else
		$tBuffer = DllStructCreate("char Buffer[" & $iBuffer & "]")
	EndIf
	DllStructSetData($tBuffer, "Buffer", $sText)
	DllStructSetData($tTVITEM, "Mask", BitOR($TVIF_HANDLE, $TVIF_TEXT))
	DllStructSetData($tTVITEM, "hItem", $hItem)
	DllStructSetData($tTVITEM, "TextMax", $iBuffer)
	Local $bResult
	If _WinAPI_InProcess($hWnd, $__g_hTVLastWnd) Then
		DllStructSetData($tTVITEM, "Text", DllStructGetPtr($tBuffer))
		$bResult = _SendMessage($hWnd, $TVM_SETITEMW, 0, $tTVITEM, 0, "wparam", "struct*")
	Else
		Local $iItem = DllStructGetSize($tTVITEM)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iItem + $iBuffer, $tMemMap)
		Local $pText = $pMemory + $iItem
		DllStructSetData($tTVITEM, "Text", $pText)
		_MemWrite($tMemMap, $tTVITEM, $pMemory, $iItem)
		_MemWrite($tMemMap, $tBuffer, $pText, $iBuffer)
		If $bUnicode Then
			$bResult = _SendMessage($hWnd, $TVM_SETITEMW, 0, $pMemory, 0, "wparam", "ptr")
		Else
			$bResult = _SendMessage($hWnd, $TVM_SETITEMA, 0, $pMemory, 0, "wparam", "ptr")
		EndIf
		_MemFree($tMemMap)
	EndIf

	Return $bResult <> 0
EndFunc   ;==>_GUICtrlTreeView_SetText

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlTreeView_SetTextColor($hWnd, $vRGBColor)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return __GUICtrlTreeView_ReverseColorOrder(_SendMessage($hWnd, $TVM_SETTEXTCOLOR, 0, Int(__GUICtrlTreeView_ReverseColorOrder($vRGBColor))))
EndFunc   ;==>_GUICtrlTreeView_SetTextColor

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_SetToolTips($hWnd, $hToolTip)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $TVM_SETTOOLTIPS, $hToolTip, 0, 0, "wparam", "int", "hwnd")
EndFunc   ;==>_GUICtrlTreeView_SetToolTips

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlTreeView_SetUnicodeFormat($hWnd, $bFormat = True)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $TVM_SETUNICODEFORMAT, $bFormat)
EndFunc   ;==>_GUICtrlTreeView_SetUnicodeFormat

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......: mlipok, guinness
; ===============================================================================================================================
Func _GUICtrlTreeView_Sort($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $iItemCount = _GUICtrlTreeView_GetCount($hWnd)
	If $iItemCount Then
		Local $aTreeView[$iItemCount], $hItem = 0
		For $i = 0 To $iItemCount - 1
			If $i Then
				$hItem = _SendMessage($hWnd, $TVM_GETNEXTITEM, $TVGN_NEXT, $hItem, 0, "wparam", "handle", "handle")
			Else
				$hItem = _SendMessage($hWnd, $TVM_GETNEXTITEM, $TVGN_CHILD, $TVI_ROOT, 0, "wparam", "handle", "handle")
			EndIf
			$aTreeView[$i] = $hItem
		Next
		Local $hChild = 0, $iRecursive = 1
		For $i = 0 To $iItemCount - 1
			_SendMessage($hWnd, $TVM_SORTCHILDREN, $iRecursive, $aTreeView[$i], 0, "wparam", "handle") ; Sort the items in root
			Do ; Sort all child items
				$hChild = _SendMessage($hWnd, $TVM_GETNEXTITEM, $TVGN_CHILD, $hItem, 0, "wparam", "handle", "handle")
				If $hChild Then
					_SendMessage($hWnd, $TVM_SORTCHILDREN, $iRecursive, $hChild, 0, "wparam", "handle")
				EndIf
				$hItem = $hChild
			Until $hItem = 0x00000000
		Next
	EndIf
EndFunc   ;==>_GUICtrlTreeView_Sort
