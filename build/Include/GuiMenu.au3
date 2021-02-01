#include-once

#include "MenuConstants.au3"
#include "StructureConstants.au3"
#include "WinAPI.au3"

; #INDEX# =======================================================================================================================
; Title .........: Menu
; AutoIt Version : 3.3.14.2
; Language ......: English
; Description ...: Functions that assist with Menu control management.
;                  A menu is a list of items that specify options or groups of options (a submenu) for an application. Clicking a
;                  menu item opens a submenu or causes the application to carry out a command.
; Author(s) .....: Paul Campbell (PaulIA)
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $__MENUCONSTANT_OBJID_CLIENT = 0xFFFFFFFC
; ===============================================================================================================================

; #NO_DOC_FUNCTION# =============================================================================================================
; Not working/documented/implemented at this time
;
; _GUICtrlMenu_EndMenu
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _GUICtrlMenu_AddMenuItem
; _GUICtrlMenu_AppendMenu
; _GUICtrlMenu_CalculatePopupWindowPosition
; _GUICtrlMenu_CheckMenuItem
; _GUICtrlMenu_CheckRadioItem
; _GUICtrlMenu_CreateMenu
; _GUICtrlMenu_CreatePopup
; _GUICtrlMenu_DeleteMenu
; _GUICtrlMenu_DestroyMenu
; _GUICtrlMenu_DrawMenuBar
; _GUICtrlMenu_EnableMenuItem
; _GUICtrlMenu_FindItem
; _GUICtrlMenu_FindParent
; _GUICtrlMenu_GetItemBmp
; _GUICtrlMenu_GetItemBmpChecked
; _GUICtrlMenu_GetItemBmpUnchecked
; _GUICtrlMenu_GetItemChecked
; _GUICtrlMenu_GetItemCount
; _GUICtrlMenu_GetItemData
; _GUICtrlMenu_GetItemDefault
; _GUICtrlMenu_GetItemDisabled
; _GUICtrlMenu_GetItemEnabled
; _GUICtrlMenu_GetItemGrayed
; _GUICtrlMenu_GetItemHighlighted
; _GUICtrlMenu_GetItemID
; _GUICtrlMenu_GetItemInfo
; _GUICtrlMenu_GetItemRect
; _GUICtrlMenu_GetItemRectEx
; _GUICtrlMenu_GetItemState
; _GUICtrlMenu_GetItemStateEx
; _GUICtrlMenu_GetItemSubMenu
; _GUICtrlMenu_GetItemText
; _GUICtrlMenu_GetItemType
; _GUICtrlMenu_GetMenu
; _GUICtrlMenu_GetMenuBackground
; _GUICtrlMenu_GetMenuBarInfo
; _GUICtrlMenu_GetMenuContextHelpID
; _GUICtrlMenu_GetMenuData
; _GUICtrlMenu_GetMenuDefaultItem
; _GUICtrlMenu_GetMenuHeight
; _GUICtrlMenu_GetMenuInfo
; _GUICtrlMenu_GetMenuStyle
; _GUICtrlMenu_GetSystemMenu
; _GUICtrlMenu_InsertMenuItem
; _GUICtrlMenu_InsertMenuItemEx
; _GUICtrlMenu_IsMenu
; _GUICtrlMenu_LoadMenu
; _GUICtrlMenu_MapAccelerator
; _GUICtrlMenu_MenuItemFromPoint
; _GUICtrlMenu_RemoveMenu
; _GUICtrlMenu_SetItemBitmaps
; _GUICtrlMenu_SetItemBmp
; _GUICtrlMenu_SetItemBmpChecked
; _GUICtrlMenu_SetItemBmpUnchecked
; _GUICtrlMenu_SetItemChecked
; _GUICtrlMenu_SetItemData
; _GUICtrlMenu_SetItemDefault
; _GUICtrlMenu_SetItemDisabled
; _GUICtrlMenu_SetItemEnabled
; _GUICtrlMenu_SetItemGrayed
; _GUICtrlMenu_SetItemHighlighted
; _GUICtrlMenu_SetItemID
; _GUICtrlMenu_SetItemInfo
; _GUICtrlMenu_SetItemState
; _GUICtrlMenu_SetItemSubMenu
; _GUICtrlMenu_SetItemText
; _GUICtrlMenu_SetItemType
; _GUICtrlMenu_SetMenu
; _GUICtrlMenu_SetMenuBackground
; _GUICtrlMenu_SetMenuContextHelpID
; _GUICtrlMenu_SetMenuData
; _GUICtrlMenu_SetMenuDefaultItem
; _GUICtrlMenu_SetMenuHeight
; _GUICtrlMenu_SetMenuInfo
; _GUICtrlMenu_SetMenuStyle
; _GUICtrlMenu_TrackPopupMenu
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; $tagMENUBARINFO
; $tagMDINEXTMENU
; $tagMENUGETOBJECTINFO
; $tagTPMPARAMS
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagMENUBARINFO
; Description ...: tagMENUBARINFO structure
; Fields ........: Size     - Specifies the size, in bytes, of the structure
;                  Left     - Specifies the x coordinate of the upper left corner of the rectangle
;                  Top      - Specifies the y coordinate of the upper left corner of the rectangle
;                  Right    - Specifies the x coordinate of the lower right corner of the rectangle
;                  Bottom   - Specifies the y coordinate of the lower right corner of the rectangle
;                  hMenu    - Handle to the menu bar or popup menu
;                  hWndMenu - Handle to the menu bar or popup menu
;                  Focused  - True if the item has focus
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagMENUBARINFO = "dword Size;" & $tagRECT & ";handle hMenu;handle hWndMenu;bool Focused"

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagMDINEXTMENU
; Description ...: tagMDINEXTMENU structure
; Fields ........: hMenuIn   - Receives a handle to the current menu
;                  hMenuNext - Specifies a handle to the menu to be activated
;                  hWndNext  - Specifies a handle to the window to receive the menu notification messages
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagMDINEXTMENU = "handle hMenuIn;handle hMenuNext;hwnd hWndNext"

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagMENUGETOBJECTINFO
; Description ...: tagMENUGETOBJECTINFO structure
; Fields ........: Flags - Position of the mouse cursor with respect to the item indicated by Pos. It can be one of the following
;                  +values.:
;                  |$MNGOF_BOTTOMGAP - Mouse is on the bottom of the item indicated by Pos
;                  |$MNGOF_TOPGAP    - Mouse is on the top of the item indicated by Pos
;                  Pos   - Position of the item the mouse cursor is on
;                  hMenu - Handle to the menu the mouse cursor is on
;                  RIID  - Identifier of the requested interface. Currently it can only be IDropTarget.
;                  Obj   - Pointer to the interface corresponding to the RIID member.  This pointer is  to  be  returned  by  the
;                  +application when processing the message.
; Author ........: Paul Campbell (PaulIA)
; Remarks .......: The tagMENUGETOBJECTINFO structure is used only in drag and drop menus.  When the $WM_MENUGETOBJECT message is
;                  sent, lParam is a pointer to  this  structure.  To  create  a  drag  and  drop  menu,  call  SetMenuInfo  with
;                  $MNS_DRAGDROP set
; ===============================================================================================================================
Global Const $tagMENUGETOBJECTINFO = "dword Flags;uint Pos;handle hMenu;ptr RIID;ptr Obj"

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagTPMPARAMS
; Description ...: tagTPMPARAMS structure
; Fields ........: Size   - Size of structure, in bytes
;                  Left   - X position of upper left corner to exclude when positioing the window
;                  Top    - Y position of upper left corner to exclude when positioing the window
;                  Right  - X position of lower right corner to exclude when positioing the window
;                  Bottom - Y position of lower right corner to exclude when positioing the window
; Author ........: Paul Campbell (PaulIA)
; Remarks .......: All coordinates are in screen coordinates
; ===============================================================================================================================
Global Const $tagTPMPARAMS = "uint Size;" & $tagRECT

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_AddMenuItem($hMenu, $sText, $iCmdID = 0, $hSubMenu = 0)
	Local $iIndex = _GUICtrlMenu_GetItemCount($hMenu)
	Local $tMenu = DllStructCreate($tagMENUITEMINFO)
	DllStructSetData($tMenu, "Size", DllStructGetSize($tMenu))
	DllStructSetData($tMenu, "ID", $iCmdID)
	DllStructSetData($tMenu, "SubMenu", $hSubMenu)
	If $sText = "" Then
		DllStructSetData($tMenu, "Mask", $MIIM_FTYPE)
		DllStructSetData($tMenu, "Type", $MFT_SEPARATOR)
	Else
		DllStructSetData($tMenu, "Mask", BitOR($MIIM_ID, $MIIM_STRING, $MIIM_SUBMENU))
		DllStructSetData($tMenu, "Type", $MFT_STRING)
		Local $tText = DllStructCreate("wchar Text[" & StringLen($sText) + 1 & "]")
		DllStructSetData($tText, "Text", $sText)
		DllStructSetData($tMenu, "TypeData", DllStructGetPtr($tText))
	EndIf
	Local $aResult = DllCall("user32.dll", "bool", "InsertMenuItemW", "handle", $hMenu, "uint", $iIndex, "bool", True, "struct*", $tMenu)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetExtended($aResult[0], $iIndex)
EndFunc   ;==>_GUICtrlMenu_AddMenuItem

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_AppendMenu($hMenu, $iFlags, $iNewItem, $vNewItem)
	Local $sType = "wstr"
	If BitAND($iFlags, $MF_BITMAP) Then $sType = "handle"
	If BitAND($iFlags, $MF_OWNERDRAW) Then $sType = "ulong_ptr"
	Local $aResult = DllCall("user32.dll", "bool", "AppendMenuW", "handle", $hMenu, "uint", $iFlags, "uint_ptr", $iNewItem, $sType, $vNewItem)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] = 0 Then Return SetError(10, 0, False)

	_GUICtrlMenu_DrawMenuBar(_GUICtrlMenu_FindParent($hMenu))
	Return True
EndFunc   ;==>_GUICtrlMenu_AppendMenu

; #FUNCTION# ====================================================================================================================
; Author.........: Yashied
; Modified.......: jpm
; ===============================================================================================================================
Func _GUICtrlMenu_CalculatePopupWindowPosition($iX, $iY, $iWidth, $iHeight, $iFlags = 0, $tExclude = 0)
	Local $tAnchor = DllStructCreate($tagPOINT)
	DllStructSetData($tAnchor, 1, $iX)
	DllStructSetData($tAnchor, 2, $iY)
	Local $tSIZE = DllStructCreate($tagSIZE)
	DllStructSetData($tSIZE, 1, $iWidth)
	DllStructSetData($tSIZE, 2, $iHeight)
	Local $tPos = DllStructCreate($tagRECT)
	Local $aRet = DllCall('user32.dll', 'bool', 'CalculatePopupWindowPosition', 'struct*', $tAnchor, 'struct*', $tSIZE, _
			'uint', $iFlags, 'struct*', $tExclude, 'struct*', $tPos)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)

	Return $tPos
EndFunc   ;==>_GUICtrlMenu_CalculatePopupWindowPosition

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_CheckMenuItem($hMenu, $iItem, $bCheck = True, $bByPos = True)
	Local $iByPos = 0

	If $bCheck Then $iByPos = BitOR($iByPos, $MF_CHECKED)
	If $bByPos Then $iByPos = BitOR($iByPos, $MF_BYPOSITION)
	Local $aResult = DllCall("user32.dll", "dword", "CheckMenuItem", "handle", $hMenu, "uint", $iItem, "uint", $iByPos)
	If @error Then Return SetError(@error, @extended, -1)
	Return $aResult[0]
EndFunc   ;==>_GUICtrlMenu_CheckMenuItem

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_CheckRadioItem($hMenu, $iFirst, $iLast, $iCheck, $bByPos = True)
	Local $iByPos = 0

	If $bByPos Then $iByPos = $MF_BYPOSITION
	Local $aResult = DllCall("user32.dll", "bool", "CheckMenuRadioItem", "handle", $hMenu, "uint", $iFirst, "uint", $iLast, "uint", $iCheck, "uint", $iByPos)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_GUICtrlMenu_CheckRadioItem

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_CreateMenu($iStyle = $MNS_CHECKORBMP)
	Local $aResult = DllCall("user32.dll", "handle", "CreateMenu")
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] = 0 Then Return SetError(10, 0, 0)
	_GUICtrlMenu_SetMenuStyle($aResult[0], $iStyle)
	Return $aResult[0]
EndFunc   ;==>_GUICtrlMenu_CreateMenu

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_CreatePopup($iStyle = $MNS_CHECKORBMP)
	Local $aResult = DllCall("user32.dll", "handle", "CreatePopupMenu")
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] = 0 Then Return SetError(10, 0, 0)
	_GUICtrlMenu_SetMenuStyle($aResult[0], $iStyle)
	Return $aResult[0]
EndFunc   ;==>_GUICtrlMenu_CreatePopup

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_DeleteMenu($hMenu, $iItem, $bByPos = True)
	Local $iByPos = 0

	If $bByPos Then $iByPos = $MF_BYPOSITION
	Local $aResult = DllCall("user32.dll", "bool", "DeleteMenu", "handle", $hMenu, "uint", $iItem, "uint", $iByPos)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] = 0 Then Return SetError(10, 0, False)

	_GUICtrlMenu_DrawMenuBar(_GUICtrlMenu_FindParent($hMenu))
	Return True
EndFunc   ;==>_GUICtrlMenu_DeleteMenu

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_DestroyMenu($hMenu)
	Local $aResult = DllCall("user32.dll", "bool", "DestroyMenu", "handle", $hMenu)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_GUICtrlMenu_DestroyMenu

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_DrawMenuBar($hWnd)
	Local $aResult = DllCall("user32.dll", "bool", "DrawMenuBar", "hwnd", $hWnd)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_GUICtrlMenu_DrawMenuBar

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_EnableMenuItem($hMenu, $iItem, $iState = 0, $bByPos = True)
	Local $iByPos = $iState
	If $bByPos Then $iByPos = BitOR($iByPos, $MF_BYPOSITION)
	Local $aResult = DllCall("user32.dll", "bool", "EnableMenuItem", "handle", $hMenu, "uint", $iItem, "uint", $iByPos)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] = 0 Then Return SetError(10, 0, False)

	_GUICtrlMenu_DrawMenuBar(_GUICtrlMenu_FindParent($hMenu))
	Return True
EndFunc   ;==>_GUICtrlMenu_EnableMenuItem

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _GUICtrlMenu_EndMenu
; Description ...: Ends the calling thread's active menu
; Syntax.........: _GUICtrlMenu_EndMenu ( )
; Parameters ....:
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......: Does not work on menus in external programs
; Related .......:
; Link ..........: @@MsdnLink@@ EndMenu
; Example .......:
; ===============================================================================================================================
Func _GUICtrlMenu_EndMenu()
	Local $aResult = DllCall("user32.dll", "bool", "EndMenu")
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_GUICtrlMenu_EndMenu

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_FindItem($hMenu, $sText, $bInStr = False, $iStart = 0)
	Local $sMenu

	For $iI = $iStart To _GUICtrlMenu_GetItemCount($hMenu)
		$sMenu = StringReplace(_GUICtrlMenu_GetItemText($hMenu, $iI), "&", "")
		Switch $bInStr
			Case False
				If $sMenu = $sText Then Return $iI
			Case True
				If StringInStr($sMenu, $sText) Then Return $iI
		EndSwitch
	Next
	Return -1
EndFunc   ;==>_GUICtrlMenu_FindItem

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_FindParent($hMenu)
	Local $hList = _WinAPI_EnumWindowsTop()
	For $iI = 1 To $hList[0][0]
		If _GUICtrlMenu_GetMenu($hList[$iI][0]) = $hMenu Then Return $hList[$iI][0]
	Next
EndFunc   ;==>_GUICtrlMenu_FindParent

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_GetItemBmp($hMenu, $iItem, $bByPos = True)
	Local $tInfo = _GUICtrlMenu_GetItemInfo($hMenu, $iItem, $bByPos)
	Return DllStructGetData($tInfo, "BmpItem")
EndFunc   ;==>_GUICtrlMenu_GetItemBmp

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_GetItemBmpChecked($hMenu, $iItem, $bByPos = True)
	Local $tInfo = _GUICtrlMenu_GetItemInfo($hMenu, $iItem, $bByPos)
	Return DllStructGetData($tInfo, "BmpChecked")
EndFunc   ;==>_GUICtrlMenu_GetItemBmpChecked

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_GetItemBmpUnchecked($hMenu, $iItem, $bByPos = True)
	Local $tInfo = _GUICtrlMenu_GetItemInfo($hMenu, $iItem, $bByPos)
	Return DllStructGetData($tInfo, "BmpUnchecked")
EndFunc   ;==>_GUICtrlMenu_GetItemBmpUnchecked

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_GetItemChecked($hMenu, $iItem, $bByPos = True)
	Return BitAND(_GUICtrlMenu_GetItemStateEx($hMenu, $iItem, $bByPos), $MF_CHECKED) <> 0
EndFunc   ;==>_GUICtrlMenu_GetItemChecked

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_GetItemCount($hMenu)
	Local $aResult = DllCall("user32.dll", "int", "GetMenuItemCount", "handle", $hMenu)
	If @error Then Return SetError(@error, @extended, -1)
	Return $aResult[0]
EndFunc   ;==>_GUICtrlMenu_GetItemCount

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_GetItemData($hMenu, $iItem, $bByPos = True)
	Local $tInfo = _GUICtrlMenu_GetItemInfo($hMenu, $iItem, $bByPos)
	Return DllStructGetData($tInfo, "ItemData")
EndFunc   ;==>_GUICtrlMenu_GetItemData

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_GetItemDefault($hMenu, $iItem, $bByPos = True)
	Return BitAND(_GUICtrlMenu_GetItemStateEx($hMenu, $iItem, $bByPos), $MF_DEFAULT) <> 0
EndFunc   ;==>_GUICtrlMenu_GetItemDefault

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_GetItemDisabled($hMenu, $iItem, $bByPos = True)
	Return BitAND(_GUICtrlMenu_GetItemStateEx($hMenu, $iItem, $bByPos), $MF_DISABLED) <> 0
EndFunc   ;==>_GUICtrlMenu_GetItemDisabled

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_GetItemEnabled($hMenu, $iItem, $bByPos = True)
	Return BitAND(_GUICtrlMenu_GetItemStateEx($hMenu, $iItem, $bByPos), $MF_DISABLED) = 0
EndFunc   ;==>_GUICtrlMenu_GetItemEnabled

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_GetItemGrayed($hMenu, $iItem, $bByPos = True)
	Return BitAND(_GUICtrlMenu_GetItemStateEx($hMenu, $iItem, $bByPos), $MF_GRAYED) <> 0
EndFunc   ;==>_GUICtrlMenu_GetItemGrayed

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_GetItemHighlighted($hMenu, $iItem, $bByPos = True)
	Return BitAND(_GUICtrlMenu_GetItemStateEx($hMenu, $iItem, $bByPos), $MF_HILITE) <> 0
EndFunc   ;==>_GUICtrlMenu_GetItemHighlighted

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_GetItemID($hMenu, $iItem, $bByPos = True)
	Local $tInfo = _GUICtrlMenu_GetItemInfo($hMenu, $iItem, $bByPos)
	Return DllStructGetData($tInfo, "ID")
EndFunc   ;==>_GUICtrlMenu_GetItemID

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_GetItemInfo($hMenu, $iItem, $bByPos = True)
	Local $tInfo = DllStructCreate($tagMENUITEMINFO)
	DllStructSetData($tInfo, "Size", DllStructGetSize($tInfo))
	DllStructSetData($tInfo, "Mask", $MIIM_DATAMASK)
	Local $aResult = DllCall("user32.dll", "bool", "GetMenuItemInfo", "handle", $hMenu, "uint", $iItem, "bool", $bByPos, "struct*", $tInfo)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $tInfo)
EndFunc   ;==>_GUICtrlMenu_GetItemInfo

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_GetItemRect($hWnd, $hMenu, $iItem)
	Local $tRECT = _GUICtrlMenu_GetItemRectEx($hWnd, $hMenu, $iItem)
	Local $aRect[4]
	$aRect[0] = DllStructGetData($tRECT, "Left")
	$aRect[1] = DllStructGetData($tRECT, "Top")
	$aRect[2] = DllStructGetData($tRECT, "Right")
	$aRect[3] = DllStructGetData($tRECT, "Bottom")
	Return $aRect
EndFunc   ;==>_GUICtrlMenu_GetItemRect

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_GetItemRectEx($hWnd, $hMenu, $iItem)
	Local $tRECT = DllStructCreate($tagRECT)
	Local $aResult = DllCall("user32.dll", "bool", "GetMenuItemRect", "hwnd", $hWnd, "handle", $hMenu, "uint", $iItem, "struct*", $tRECT)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $tRECT)
EndFunc   ;==>_GUICtrlMenu_GetItemRectEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_GetItemState($hMenu, $iItem, $bByPos = True)
	Local $iRet = 0

	Local $iState = _GUICtrlMenu_GetItemStateEx($hMenu, $iItem, $bByPos)
	If BitAND($iState, $MFS_CHECKED) <> 0 Then $iRet = BitOR($iRet, 1)
	If BitAND($iState, $MFS_DEFAULT) <> 0 Then $iRet = BitOR($iRet, 2)
	If BitAND($iState, $MFS_DISABLED) <> 0 Then $iRet = BitOR($iRet, 4)
	If BitAND($iState, $MFS_GRAYED) <> 0 Then $iRet = BitOR($iRet, 8)
	If BitAND($iState, $MFS_HILITE) <> 0 Then $iRet = BitOR($iRet, 16)
	Return $iRet
EndFunc   ;==>_GUICtrlMenu_GetItemState

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_GetItemStateEx($hMenu, $iItem, $bByPos = True)
	Local $tInfo = _GUICtrlMenu_GetItemInfo($hMenu, $iItem, $bByPos)
	Return DllStructGetData($tInfo, "State")
EndFunc   ;==>_GUICtrlMenu_GetItemStateEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_GetItemSubMenu($hMenu, $iItem)
	Local $aResult = DllCall("user32.dll", "handle", "GetSubMenu", "handle", $hMenu, "int", $iItem)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_GUICtrlMenu_GetItemSubMenu

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_GetItemText($hMenu, $iItem, $bByPos = True)
	Local $iByPos = 0

	If $bByPos Then $iByPos = $MF_BYPOSITION
	Local $aResult = DllCall("user32.dll", "int", "GetMenuStringW", "handle", $hMenu, "uint", $iItem, "wstr", "", "int", 4096, "uint", $iByPos)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $aResult[3])
EndFunc   ;==>_GUICtrlMenu_GetItemText

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_GetItemType($hMenu, $iItem, $bByPos = True)
	Local $tInfo = _GUICtrlMenu_GetItemInfo($hMenu, $iItem, $bByPos)
	Return DllStructGetData($tInfo, "Type")
EndFunc   ;==>_GUICtrlMenu_GetItemType

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_GetMenu($hWnd)
	Local $aResult = DllCall("user32.dll", "handle", "GetMenu", "hwnd", $hWnd)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_GUICtrlMenu_GetMenu

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_GetMenuBackground($hMenu)
	Local $tInfo = _GUICtrlMenu_GetMenuInfo($hMenu)
	Return DllStructGetData($tInfo, "hBack")
EndFunc   ;==>_GUICtrlMenu_GetMenuBackground

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_GetMenuBarInfo($hWnd, $iItem = 0, $iObject = 1)
	Local $aObject[3] = [$__MENUCONSTANT_OBJID_CLIENT, $OBJID_MENU, $OBJID_SYSMENU]

	Local $tInfo = DllStructCreate($tagMENUBARINFO)
	DllStructSetData($tInfo, "Size", DllStructGetSize($tInfo))
	Local $aResult = DllCall("user32.dll", "bool", "GetMenuBarInfo", "hwnd", $hWnd, "long", $aObject[$iObject], "long", $iItem, "struct*", $tInfo)
	If @error Then Return SetError(@error, @extended, 0)
	Local $aInfo[8]
	$aInfo[0] = DllStructGetData($tInfo, "Left")
	$aInfo[1] = DllStructGetData($tInfo, "Top")
	$aInfo[2] = DllStructGetData($tInfo, "Right")
	$aInfo[3] = DllStructGetData($tInfo, "Bottom")
	$aInfo[4] = DllStructGetData($tInfo, "hMenu")
	$aInfo[5] = DllStructGetData($tInfo, "hWndMenu")
	$aInfo[6] = BitAND(DllStructGetData($tInfo, "Focused"), 1) <> 0
	$aInfo[7] = BitAND(DllStructGetData($tInfo, "Focused"), 2) <> 0
	Return SetExtended($aResult[0], $aInfo)
EndFunc   ;==>_GUICtrlMenu_GetMenuBarInfo

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_GetMenuContextHelpID($hMenu)
	Local $tInfo = _GUICtrlMenu_GetMenuInfo($hMenu)
	Return DllStructGetData($tInfo, "ContextHelpID")
EndFunc   ;==>_GUICtrlMenu_GetMenuContextHelpID

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_GetMenuData($hMenu)
	Local $tInfo = _GUICtrlMenu_GetMenuInfo($hMenu)
	Return DllStructGetData($tInfo, "MenuData")
EndFunc   ;==>_GUICtrlMenu_GetMenuData

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_GetMenuDefaultItem($hMenu, $bByPos = True, $iFlags = 0)
	Local $aResult = DllCall("user32.dll", "INT", "GetMenuDefaultItem", "handle", $hMenu, "uint", $bByPos, "uint", $iFlags)
	If @error Then Return SetError(@error, @extended, -1)
	Return $aResult[0]
EndFunc   ;==>_GUICtrlMenu_GetMenuDefaultItem

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_GetMenuHeight($hMenu)
	Local $tInfo = _GUICtrlMenu_GetMenuInfo($hMenu)
	Return DllStructGetData($tInfo, "YMax")
EndFunc   ;==>_GUICtrlMenu_GetMenuHeight

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_GetMenuInfo($hMenu)
	Local $tInfo = DllStructCreate($tagMENUINFO)
	DllStructSetData($tInfo, "Size", DllStructGetSize($tInfo))
	DllStructSetData($tInfo, "Mask", BitOR($MIM_BACKGROUND, $MIM_HELPID, $MIM_MAXHEIGHT, $MIM_MENUDATA, $MIM_STYLE))
	Local $aResult = DllCall("user32.dll", "bool", "GetMenuInfo", "handle", $hMenu, "struct*", $tInfo)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $tInfo)
EndFunc   ;==>_GUICtrlMenu_GetMenuInfo

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_GetMenuStyle($hMenu)
	Local $tInfo = _GUICtrlMenu_GetMenuInfo($hMenu)
	Return DllStructGetData($tInfo, "Style")
EndFunc   ;==>_GUICtrlMenu_GetMenuStyle

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_GetSystemMenu($hWnd, $bRevert = False)
	Local $aResult = DllCall("user32.dll", "hwnd", "GetSystemMenu", "hwnd", $hWnd, "int", $bRevert)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_GUICtrlMenu_GetSystemMenu

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_InsertMenuItem($hMenu, $iIndex, $sText, $iCmdID = 0, $hSubMenu = 0)
	Local $tMenu = DllStructCreate($tagMENUITEMINFO)
	DllStructSetData($tMenu, "Size", DllStructGetSize($tMenu))
	DllStructSetData($tMenu, "ID", $iCmdID)
	DllStructSetData($tMenu, "SubMenu", $hSubMenu)
	If $sText = "" Then
		DllStructSetData($tMenu, "Mask", $MIIM_FTYPE)
		DllStructSetData($tMenu, "Type", $MFT_SEPARATOR)
	Else
		DllStructSetData($tMenu, "Mask", BitOR($MIIM_ID, $MIIM_STRING, $MIIM_SUBMENU))
		DllStructSetData($tMenu, "Type", $MFT_STRING)
		Local $tText = DllStructCreate("wchar Text[" & StringLen($sText) + 1 & "]")
		DllStructSetData($tText, "Text", $sText)
		DllStructSetData($tMenu, "TypeData", DllStructGetPtr($tText))
	EndIf
	Local $aResult = DllCall("user32.dll", "bool", "InsertMenuItemW", "handle", $hMenu, "uint", $iIndex, "bool", True, "struct*", $tMenu)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_GUICtrlMenu_InsertMenuItem

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_InsertMenuItemEx($hMenu, $iIndex, ByRef $tMenu, $bByPos = True)
	Local $aResult = DllCall("user32.dll", "bool", "InsertMenuItemW", "handle", $hMenu, "uint", $iIndex, "bool", $bByPos, "struct*", $tMenu)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_GUICtrlMenu_InsertMenuItemEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_IsMenu($hMenu)
	Local $aResult = DllCall("user32.dll", "bool", "IsMenu", "handle", $hMenu)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_GUICtrlMenu_IsMenu

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_LoadMenu($hInst, $sMenuName)
	Local $aResult = DllCall("user32.dll", "handle", "LoadMenuW", "handle", $hInst, "wstr", $sMenuName)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_GUICtrlMenu_LoadMenu

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_MapAccelerator($hMenu, $sAccelKey)
	Local $sText

	Local $iCount = _GUICtrlMenu_GetItemCount($hMenu)
	For $iI = 0 To $iCount - 1
		$sText = _GUICtrlMenu_GetItemText($hMenu, $iI)
		If StringInStr($sText, "&" & $sAccelKey) > 0 Then Return $iI
	Next
	Return -1
EndFunc   ;==>_GUICtrlMenu_MapAccelerator

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_MenuItemFromPoint($hWnd, $hMenu, $iX = -1, $iY = -1)
	If $iX = -1 Then $iX = _WinAPI_GetMousePosX()
	If $iY = -1 Then $iY = _WinAPI_GetMousePosY()
	Local $aResult = DllCall("user32.dll", "int", "MenuItemFromPoint", "hwnd", $hWnd, "handle", $hMenu, "int", $iX, "int", $iY)
	If @error Then Return SetError(@error, @extended, -1)
	Return $aResult[0]
EndFunc   ;==>_GUICtrlMenu_MenuItemFromPoint

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_RemoveMenu($hMenu, $iItem, $bByPos = True)
	Local $iByPos = 0

	If $bByPos Then $iByPos = $MF_BYPOSITION
	Local $aResult = DllCall("user32.dll", "bool", "RemoveMenu", "handle", $hMenu, "uint", $iItem, "uint", $iByPos)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] = 0 Then Return SetError(10, 0, False)

	_GUICtrlMenu_DrawMenuBar(_GUICtrlMenu_FindParent($hMenu))
	Return True
EndFunc   ;==>_GUICtrlMenu_RemoveMenu

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_SetItemBitmaps($hMenu, $iItem, $hChecked, $hUnChecked, $bByPos = True)
	Local $iByPos = 0

	If $bByPos Then $iByPos = $MF_BYPOSITION
	Local $aResult = DllCall("user32.dll", "bool", "SetMenuItemBitmaps", "handle", $hMenu, "uint", $iItem, "uint", $iByPos, "handle", $hUnChecked, "handle", $hChecked)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_GUICtrlMenu_SetItemBitmaps

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_SetItemBmp($hMenu, $iItem, $hBitmap, $bByPos = True)
	Local $tInfo = DllStructCreate($tagMENUITEMINFO)
	DllStructSetData($tInfo, "Size", DllStructGetSize($tInfo))
	DllStructSetData($tInfo, "Mask", $MIIM_BITMAP)
	DllStructSetData($tInfo, "BmpItem", $hBitmap)
	Return _GUICtrlMenu_SetItemInfo($hMenu, $iItem, $tInfo, $bByPos)
EndFunc   ;==>_GUICtrlMenu_SetItemBmp

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_SetItemBmpChecked($hMenu, $iItem, $hBitmap, $bByPos = True)
	Local $tInfo = _GUICtrlMenu_GetItemInfo($hMenu, $iItem, $bByPos)
	DllStructSetData($tInfo, "Mask", $MIIM_CHECKMARKS)
	DllStructSetData($tInfo, "BmpChecked", $hBitmap)
	Return _GUICtrlMenu_SetItemInfo($hMenu, $iItem, $tInfo, $bByPos)
EndFunc   ;==>_GUICtrlMenu_SetItemBmpChecked

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_SetItemBmpUnchecked($hMenu, $iItem, $hBitmap, $bByPos = True)
	Local $tInfo = _GUICtrlMenu_GetItemInfo($hMenu, $iItem, $bByPos)
	DllStructSetData($tInfo, "Mask", $MIIM_CHECKMARKS)
	DllStructSetData($tInfo, "BmpUnchecked", $hBitmap)
	Return _GUICtrlMenu_SetItemInfo($hMenu, $iItem, $tInfo, $bByPos)
EndFunc   ;==>_GUICtrlMenu_SetItemBmpUnchecked

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_SetItemChecked($hMenu, $iItem, $bState = True, $bByPos = True)
	Return _GUICtrlMenu_SetItemState($hMenu, $iItem, $MFS_CHECKED, $bState, $bByPos)
EndFunc   ;==>_GUICtrlMenu_SetItemChecked

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_SetItemData($hMenu, $iItem, $iData, $bByPos = True)
	Local $tInfo = DllStructCreate($tagMENUITEMINFO)
	DllStructSetData($tInfo, "Size", DllStructGetSize($tInfo))
	DllStructSetData($tInfo, "Mask", $MIIM_DATA)
	DllStructSetData($tInfo, "ItemData", $iData)
	Return _GUICtrlMenu_SetItemInfo($hMenu, $iItem, $tInfo, $bByPos)
EndFunc   ;==>_GUICtrlMenu_SetItemData

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_SetItemDefault($hMenu, $iItem, $bState = True, $bByPos = True)
	Return _GUICtrlMenu_SetItemState($hMenu, $iItem, $MFS_DEFAULT, $bState, $bByPos)
EndFunc   ;==>_GUICtrlMenu_SetItemDefault

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_SetItemDisabled($hMenu, $iItem, $bState = True, $bByPos = True)
	Return _GUICtrlMenu_SetItemState($hMenu, $iItem, BitOR($MFS_DISABLED, $MFS_GRAYED), $bState, $bByPos)
EndFunc   ;==>_GUICtrlMenu_SetItemDisabled

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_SetItemEnabled($hMenu, $iItem, $bState = True, $bByPos = True)
	Return _GUICtrlMenu_SetItemState($hMenu, $iItem, BitOR($MFS_DISABLED, $MFS_GRAYED), Not $bState, $bByPos)
EndFunc   ;==>_GUICtrlMenu_SetItemEnabled

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_SetItemGrayed($hMenu, $iItem, $bState = True, $bByPos = True)
	Return _GUICtrlMenu_SetItemState($hMenu, $iItem, $MFS_GRAYED, $bState, $bByPos)
EndFunc   ;==>_GUICtrlMenu_SetItemGrayed

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_SetItemHighlighted($hMenu, $iItem, $bState = True, $bByPos = True)
	Return _GUICtrlMenu_SetItemState($hMenu, $iItem, $MFS_HILITE, $bState, $bByPos)
EndFunc   ;==>_GUICtrlMenu_SetItemHighlighted

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_SetItemID($hMenu, $iItem, $iID, $bByPos = True)
	Local $tInfo = DllStructCreate($tagMENUITEMINFO)
	DllStructSetData($tInfo, "Size", DllStructGetSize($tInfo))
	DllStructSetData($tInfo, "Mask", $MIIM_ID)
	DllStructSetData($tInfo, "ID", $iID)
	Return _GUICtrlMenu_SetItemInfo($hMenu, $iItem, $tInfo, $bByPos)
EndFunc   ;==>_GUICtrlMenu_SetItemID

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_SetItemInfo($hMenu, $iItem, ByRef $tInfo, $bByPos = True)
	DllStructSetData($tInfo, "Size", DllStructGetSize($tInfo))
	Local $aResult = DllCall("user32.dll", "bool", "SetMenuItemInfoW", "handle", $hMenu, "uint", $iItem, "bool", $bByPos, "struct*", $tInfo)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_GUICtrlMenu_SetItemInfo

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_SetItemState($hMenu, $iItem, $iState, $bState = True, $bByPos = True)
	Local $iFlag = _GUICtrlMenu_GetItemStateEx($hMenu, $iItem, $bByPos)
	If $bState Then
		$iState = BitOR($iFlag, $iState)
	Else
		$iState = BitAND($iFlag, BitNOT($iState))
	EndIf
	Local $tInfo = DllStructCreate($tagMENUITEMINFO)
	DllStructSetData($tInfo, "Size", DllStructGetSize($tInfo))
	DllStructSetData($tInfo, "Mask", $MIIM_STATE)
	DllStructSetData($tInfo, "State", $iState)
	Return _GUICtrlMenu_SetItemInfo($hMenu, $iItem, $tInfo, $bByPos)
EndFunc   ;==>_GUICtrlMenu_SetItemState

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_SetItemSubMenu($hMenu, $iItem, $hSubMenu, $bByPos = True)
	Local $tInfo = DllStructCreate($tagMENUITEMINFO)
	DllStructSetData($tInfo, "Size", DllStructGetSize($tInfo))
	DllStructSetData($tInfo, "Mask", $MIIM_SUBMENU)
	DllStructSetData($tInfo, "SubMenu", $hSubMenu)
	Return _GUICtrlMenu_SetItemInfo($hMenu, $iItem, $tInfo, $bByPos)
EndFunc   ;==>_GUICtrlMenu_SetItemSubMenu

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_SetItemText($hMenu, $iItem, $sText, $bByPos = True)
	Local $tBuffer = DllStructCreate("wchar Text[" & StringLen($sText) + 1 & "]")
	DllStructSetData($tBuffer, "Text", $sText)
	Local $tInfo = DllStructCreate($tagMENUITEMINFO)
	DllStructSetData($tInfo, "Size", DllStructGetSize($tInfo))
	DllStructSetData($tInfo, "Mask", $MIIM_STRING)
	DllStructSetData($tInfo, "TypeData", DllStructGetPtr($tBuffer))
	Return _GUICtrlMenu_SetItemInfo($hMenu, $iItem, $tInfo, $bByPos)
EndFunc   ;==>_GUICtrlMenu_SetItemText

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_SetItemType($hMenu, $iItem, $iType, $bByPos = True)
	Local $tInfo = DllStructCreate($tagMENUITEMINFO)
	DllStructSetData($tInfo, "Size", DllStructGetSize($tInfo))
	DllStructSetData($tInfo, "Mask", $MIIM_FTYPE)
	DllStructSetData($tInfo, "Type", $iType)
	Return _GUICtrlMenu_SetItemInfo($hMenu, $iItem, $tInfo, $bByPos)
EndFunc   ;==>_GUICtrlMenu_SetItemType

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_SetMenu($hWnd, $hMenu)
	Local $aResult = DllCall("user32.dll", "bool", "SetMenu", "hwnd", $hWnd, "handle", $hMenu)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_GUICtrlMenu_SetMenu

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_SetMenuBackground($hMenu, $hBrush)
	Local $tInfo = DllStructCreate($tagMENUINFO)
	DllStructSetData($tInfo, "Mask", $MIM_BACKGROUND)
	DllStructSetData($tInfo, "hBack", $hBrush)
	Return _GUICtrlMenu_SetMenuInfo($hMenu, $tInfo)
EndFunc   ;==>_GUICtrlMenu_SetMenuBackground

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_SetMenuContextHelpID($hMenu, $iHelpID)
	Local $tInfo = DllStructCreate($tagMENUINFO)
	DllStructSetData($tInfo, "Mask", $MIM_HELPID)
	DllStructSetData($tInfo, "ContextHelpID", $iHelpID)
	Return _GUICtrlMenu_SetMenuInfo($hMenu, $tInfo)
EndFunc   ;==>_GUICtrlMenu_SetMenuContextHelpID

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_SetMenuData($hMenu, $iData)
	Local $tInfo = DllStructCreate($tagMENUINFO)
	DllStructSetData($tInfo, "Mask", $MIM_MENUDATA)
	DllStructSetData($tInfo, "MenuData", $iData)
	Return _GUICtrlMenu_SetMenuInfo($hMenu, $tInfo)
EndFunc   ;==>_GUICtrlMenu_SetMenuData

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_SetMenuDefaultItem($hMenu, $iItem, $bByPos = True)
	Local $aResult = DllCall("user32.dll", "bool", "SetMenuDefaultItem", "handle", $hMenu, "uint", $iItem, "uint", $bByPos)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_GUICtrlMenu_SetMenuDefaultItem

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_SetMenuHeight($hMenu, $iHeight)
	Local $tInfo = DllStructCreate($tagMENUINFO)
	DllStructSetData($tInfo, "Mask", $MIM_MAXHEIGHT)
	DllStructSetData($tInfo, "YMax", $iHeight)
	Return _GUICtrlMenu_SetMenuInfo($hMenu, $tInfo)
EndFunc   ;==>_GUICtrlMenu_SetMenuHeight

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_SetMenuInfo($hMenu, ByRef $tInfo)
	DllStructSetData($tInfo, "Size", DllStructGetSize($tInfo))
	Local $aResult = DllCall("user32.dll", "bool", "SetMenuInfo", "handle", $hMenu, "struct*", $tInfo)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_GUICtrlMenu_SetMenuInfo

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_SetMenuStyle($hMenu, $iStyle)
	Local $tInfo = DllStructCreate($tagMENUINFO)
	DllStructSetData($tInfo, "Mask", $MIM_STYLE)
	DllStructSetData($tInfo, "Style", $iStyle)
	Return _GUICtrlMenu_SetMenuInfo($hMenu, $tInfo)
EndFunc   ;==>_GUICtrlMenu_SetMenuStyle

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMenu_TrackPopupMenu($hMenu, $hWnd, $iX = -1, $iY = -1, $iAlignX = 1, $iAlignY = 1, $iNotify = 0, $iButtons = 0)
	If $iX = -1 Then $iX = _WinAPI_GetMousePosX()
	If $iY = -1 Then $iY = _WinAPI_GetMousePosY()

	Local $iFlags = 0
	Switch $iAlignX
		Case 1
			$iFlags = BitOR($iFlags, $TPM_LEFTALIGN)
		Case 2
			$iFlags = BitOR($iFlags, $TPM_RIGHTALIGN)
		Case Else
			$iFlags = BitOR($iFlags, $TPM_CENTERALIGN)
	EndSwitch
	Switch $iAlignY
		Case 1
			$iFlags = BitOR($iFlags, $TPM_TOPALIGN)
		Case 2
			$iFlags = BitOR($iFlags, $TPM_VCENTERALIGN)
		Case Else
			$iFlags = BitOR($iFlags, $TPM_BOTTOMALIGN)
	EndSwitch
	If BitAND($iNotify, 1) <> 0 Then $iFlags = BitOR($iFlags, $TPM_NONOTIFY)
	If BitAND($iNotify, 2) <> 0 Then $iFlags = BitOR($iFlags, $TPM_RETURNCMD)
	Switch $iButtons
		Case 1
			$iFlags = BitOR($iFlags, $TPM_RIGHTBUTTON)
		Case Else
			$iFlags = BitOR($iFlags, $TPM_LEFTBUTTON)
	EndSwitch
	Local $aResult = DllCall("user32.dll", "bool", "TrackPopupMenu", "handle", $hMenu, "uint", $iFlags, "int", $iX, "int", $iY, "int", 0, "hwnd", $hWnd, "ptr", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_GUICtrlMenu_TrackPopupMenu
