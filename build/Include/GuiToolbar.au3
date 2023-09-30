#include-once

#include "Memory.au3"
#include "SendMessage.au3"
#include "StructureConstants.au3"
#include "ToolbarConstants.au3"
#include "UDFGlobalID.au3"
#include "WinAPI.au3"

; #INDEX# =======================================================================================================================
; Title .........: Toolbar
; AutoIt Version : 3.3.14.2
; Language ......: English
; Description ...: Functions that assist with Toolbar control management.
;                  A toolbar is a control window that contains one or more buttons.  Each button, when clicked by a user, sends a
;                  command message to the parent window.  Typically, the  buttons  in  a  toolbar  correspond  to  items  in  the
;                  application's menu, providing an additional and more direct way  for  the  user  to  access  an  application's
;                  commands.
; Author(s) .....: Paul Campbell (PaulIA)
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
Global $__g_hTBLastWnd

; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $__TOOLBARCONSTANT_ClassName = "ToolbarWindow32"
Global Const $__TOOLBARCONSTANT_WS_CLIPSIBLINGS = 0x04000000
Global Const $__TOOLBARCONSTANT_HINST_COMMCTRL = -1
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _GUICtrlToolbar_AddBitmap
; _GUICtrlToolbar_AddButton
; _GUICtrlToolbar_AddButtonSep
; _GUICtrlToolbar_AddString
; _GUICtrlToolbar_ButtonCount
; _GUICtrlToolbar_CheckButton
; _GUICtrlToolbar_ClickAccel
; _GUICtrlToolbar_ClickButton
; _GUICtrlToolbar_ClickIndex
; _GUICtrlToolbar_CommandToIndex
; _GUICtrlToolbar_Create
; _GUICtrlToolbar_Customize
; _GUICtrlToolbar_DeleteButton
; _GUICtrlToolbar_Destroy
; _GUICtrlToolbar_EnableButton
; _GUICtrlToolbar_FindToolbar
; _GUICtrlToolbar_GetAnchorHighlight
; _GUICtrlToolbar_GetBitmapFlags
; _GUICtrlToolbar_GetButtonBitmap
; _GUICtrlToolbar_GetButtonInfo
; _GUICtrlToolbar_GetButtonInfoEx
; _GUICtrlToolbar_GetButtonParam
; _GUICtrlToolbar_GetButtonRect
; _GUICtrlToolbar_GetButtonRectEx
; _GUICtrlToolbar_GetButtonSize
; _GUICtrlToolbar_GetButtonState
; _GUICtrlToolbar_GetButtonStyle
; _GUICtrlToolbar_GetButtonText
; _GUICtrlToolbar_GetColorScheme
; _GUICtrlToolbar_GetDisabledImageList
; _GUICtrlToolbar_GetExtendedStyle
; _GUICtrlToolbar_GetHotImageList
; _GUICtrlToolbar_GetHotItem
; _GUICtrlToolbar_GetImageList
; _GUICtrlToolbar_GetInsertMark
; _GUICtrlToolbar_GetInsertMarkColor
; _GUICtrlToolbar_GetMaxSize
; _GUICtrlToolbar_GetMetrics
; _GUICtrlToolbar_GetPadding
; _GUICtrlToolbar_GetRows
; _GUICtrlToolbar_GetString
; _GUICtrlToolbar_GetStyle
; _GUICtrlToolbar_GetStyleAltDrag
; _GUICtrlToolbar_GetStyleCustomErase
; _GUICtrlToolbar_GetStyleFlat
; _GUICtrlToolbar_GetStyleList
; _GUICtrlToolbar_GetStyleRegisterDrop
; _GUICtrlToolbar_GetStyleToolTips
; _GUICtrlToolbar_GetStyleTransparent
; _GUICtrlToolbar_GetStyleWrapable
; _GUICtrlToolbar_GetTextRows
; _GUICtrlToolbar_GetToolTips
; _GUICtrlToolbar_GetUnicodeFormat
; _GUICtrlToolbar_HideButton
; _GUICtrlToolbar_HighlightButton
; _GUICtrlToolbar_HitTest
; _GUICtrlToolbar_IndexToCommand
; _GUICtrlToolbar_InsertButton
; _GUICtrlToolbar_InsertMarkHitTest
; _GUICtrlToolbar_IsButtonChecked
; _GUICtrlToolbar_IsButtonEnabled
; _GUICtrlToolbar_IsButtonHidden
; _GUICtrlToolbar_IsButtonHighlighted
; _GUICtrlToolbar_IsButtonIndeterminate
; _GUICtrlToolbar_IsButtonPressed
; _GUICtrlToolbar_LoadBitmap
; _GUICtrlToolbar_LoadImages
; _GUICtrlToolbar_MapAccelerator
; _GUICtrlToolbar_MoveButton
; _GUICtrlToolbar_PressButton
; _GUICtrlToolbar_SetAnchorHighlight
; _GUICtrlToolbar_SetBitmapSize
; _GUICtrlToolbar_SetButtonBitMap
; _GUICtrlToolbar_SetButtonInfo
; _GUICtrlToolbar_SetButtonInfoEx
; _GUICtrlToolbar_SetButtonParam
; _GUICtrlToolbar_SetButtonSize
; _GUICtrlToolbar_SetButtonState
; _GUICtrlToolbar_SetButtonStyle
; _GUICtrlToolbar_SetButtonText
; _GUICtrlToolbar_SetButtonWidth
; _GUICtrlToolbar_SetCmdID
; _GUICtrlToolbar_SetColorScheme
; _GUICtrlToolbar_SetDisabledImageList
; _GUICtrlToolbar_SetDrawTextFlags
; _GUICtrlToolbar_SetExtendedStyle
; _GUICtrlToolbar_SetHotImageList
; _GUICtrlToolbar_SetHotItem
; _GUICtrlToolbar_SetImageList
; _GUICtrlToolbar_SetIndent
; _GUICtrlToolbar_SetIndeterminate
; _GUICtrlToolbar_SetInsertMark
; _GUICtrlToolbar_SetInsertMarkColor
; _GUICtrlToolbar_SetMaxTextRows
; _GUICtrlToolbar_SetMetrics
; _GUICtrlToolbar_SetPadding
; _GUICtrlToolbar_SetParent
; _GUICtrlToolbar_SetRows
; _GUICtrlToolbar_SetStyle
; _GUICtrlToolbar_SetStyleAltDrag
; _GUICtrlToolbar_SetStyleCustomErase
; _GUICtrlToolbar_SetStyleFlat
; _GUICtrlToolbar_SetStyleList
; _GUICtrlToolbar_SetStyleRegisterDrop
; _GUICtrlToolbar_SetStyleToolTips
; _GUICtrlToolbar_SetStyleTransparent
; _GUICtrlToolbar_SetStyleWrapable
; _GUICtrlToolbar_SetToolTips
; _GUICtrlToolbar_SetUnicodeFormat
; _GUICtrlToolbar_SetWindowTheme
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; $tagTBADDBITMAP
; $tagTBINSERTMARK
; $tagTBMETRICS
; __GUICtrlToolbar_AutoSize
; __GUICtrlToolbar_ButtonStructSize
; __GUICtrlToolbar_SetStyleEx
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagTBADDBITMAP
; Description ...: Adds a bitmap that contains button images to a toolbar
; Fields ........: hInst - Handle to the module instance with the executable file that contains a bitmap resource.  To use bitmap
;                  +handles instead of resource IDs, set this member to 0.  You can add the system-defined button bitmaps to  the
;                  +list by specifying $HINST_COMMCTRL as the hInst member and one of the following values as the ID member:
;                  |$IDB_STD_LARGE_COLOR  - Adds large, color standard bitmaps
;                  |$IDB_STD_SMALL_COLOR  - Adds small, color standard bitmaps
;                  |$IDB_VIEW_LARGE_COLOR - Adds large, color view bitmaps
;                  |$IDB_VIEW_SMALL_COLOR - Adds small, color view bitmaps
;                  ID    - If hInst is 0, set this member to the bitmap handle of the bitmap with the button  images.  Otherwise,
;                  +set it to the resource identifier of the bitmap with the button images.
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagTBADDBITMAP = "handle hInst;uint_ptr ID"

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagTBINSERTMARK
; Description ...: Contains information on the insertion mark in a toolbar control
; Fields ........: Button - Zero based index of the insertion mark. If this member is -1, there is no insertion mark
;                  Flags  - Defines where the insertion mark is in relation to Button. This can be one of the following values:
;                  |0                   - The insertion mark is to the left of the specified button
;                  |$TBIMHT_AFTER       - The insertion mark is to the right of the specified button
;                  |$TBIMHT_BACKGROUND  - The insertion mark is on the background of the toolbar.  This flag is  only  used  with
;                  +the $TB_INSERTMARKHITTEST message.
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagTBINSERTMARK = "int Button;dword Flags"

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagTBMETRICS
; Description ...: Defines the metrics of a toolbar that are used to shrink or expand toolbar items
; Fields ........: Size     - Size of this structure, in bytes
;                  Mask     - Mask that determines the metric to retrieve. It can be any combination of the following:
;                  |$TBMF_PAD           - Retrieve the XPad and YPad values
;                  |$TBMF_BARPAD        - Retrieve the XBarPad and YBarPad values
;                  |$TBMF_BUTTONSPACING - Retrieve the XSpacing and YSpacing values
;                  XPad     - Width of the padding inside the toolbar buttons
;                  YPad     - Height of the padding inside the toolbar buttons
;                  XBarPad  - Width of the toolbar. Not used.
;                  YBarPad  - Height of the toolbar. Not used.
;                  XSpacing - Width of the space between toolbar buttons
;                  YSpacing - Height of the space between toolbar buttons
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagTBMETRICS = "uint Size;dword Mask;int XPad;int YPad;int XBarPad;int YBarPad;int XSpacing;int YSpacing"

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlToolbar_AddBitmap($hWnd, $iButtons, $hInst, $iID)
	Local $tBitmap = DllStructCreate($tagTBADDBITMAP)
	DllStructSetData($tBitmap, "hInst", $hInst)
	DllStructSetData($tBitmap, "ID", $iID)
	Local $iRet
	If _WinAPI_InProcess($hWnd, $__g_hTBLastWnd) Then
		$iRet = _SendMessage($hWnd, $TB_ADDBITMAP, $iButtons, $tBitmap, 0, "wparam", "struct*")
	Else
		Local $iBitmap = DllStructGetSize($tBitmap)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iBitmap, $tMemMap)
		_MemWrite($tMemMap, $tBitmap, $pMemory, $iBitmap)
		$iRet = _SendMessage($hWnd, $TB_ADDBITMAP, $iButtons, $pMemory, 0, "wparam", "ptr")
		_MemFree($tMemMap)
	EndIf
	Return $iRet
EndFunc   ;==>_GUICtrlToolbar_AddBitmap

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlToolbar_AddButton($hWnd, $iID, $iImage, $iString = 0, $iStyle = 0, $iState = 4, $iParam = 0)
	Local $bUnicode = _GUICtrlToolbar_GetUnicodeFormat($hWnd)

	Local $tButton = DllStructCreate($tagTBBUTTON)
	DllStructSetData($tButton, "Bitmap", $iImage)
	DllStructSetData($tButton, "Command", $iID)
	DllStructSetData($tButton, "State", $iState)
	DllStructSetData($tButton, "Style", $iStyle)
	DllStructSetData($tButton, "Param", $iParam)
	DllStructSetData($tButton, "String", $iString)
	Local $iRet
	If _WinAPI_InProcess($hWnd, $__g_hTBLastWnd) Then
		$iRet = _SendMessage($hWnd, $TB_ADDBUTTONSW, 1, $tButton, 0, "wparam", "struct*")
	Else
		Local $iButton = DllStructGetSize($tButton)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iButton, $tMemMap)
		_MemWrite($tMemMap, $tButton, $pMemory, $iButton)
		If $bUnicode Then
			$iRet = _SendMessage($hWnd, $TB_ADDBUTTONSW, 1, $pMemory, 0, "wparam", "ptr")
		Else
			$iRet = _SendMessage($hWnd, $TB_ADDBUTTONSA, 1, $pMemory, 0, "wparam", "ptr")
		EndIf
		_MemFree($tMemMap)
	EndIf
	__GUICtrlToolbar_AutoSize($hWnd)
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlToolbar_AddButton

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_AddButtonSep($hWnd, $iWidth = 6)
	_GUICtrlToolbar_AddButton($hWnd, 0, $iWidth, 0, $BTNS_SEP)
EndFunc   ;==>_GUICtrlToolbar_AddButtonSep

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlToolbar_AddString($hWnd, $sString)
	Local $bUnicode = _GUICtrlToolbar_GetUnicodeFormat($hWnd)

	Local $iBuffer = StringLen($sString) + 2
	Local $tBuffer
	If $bUnicode Then
		$tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
		$iBuffer *= 2
	Else
		$tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
	EndIf
	DllStructSetData($tBuffer, "Text", $sString)
	Local $iRet
	If _WinAPI_InProcess($hWnd, $__g_hTBLastWnd) Then
		$iRet = _SendMessage($hWnd, $TB_ADDSTRINGW, 0, $tBuffer, 0, "wparam", "struct*")
	Else
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iBuffer, $tMemMap)
		_MemWrite($tMemMap, $tBuffer, $pMemory, $iBuffer)
		If $bUnicode Then
			$iRet = _SendMessage($hWnd, $TB_ADDSTRINGW, 0, $pMemory, 0, "wparam", "ptr")
		Else
			$iRet = _SendMessage($hWnd, $TB_ADDSTRINGA, 0, $pMemory, 0, "wparam", "ptr")
		EndIf
		_MemFree($tMemMap)
	EndIf
	Return $iRet
EndFunc   ;==>_GUICtrlToolbar_AddString

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUICtrlToolbar_AutoSize
; Description ...: Causes a toolbar to be resized
; Syntax.........: __GUICtrlToolbar_AutoSize ( $hWnd )
; Parameters ....: $hWnd        - Handle to the control
; Return values .:
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......: An application calls this function after causing the size of a toolbar to change  by  setting  the  button  or
;                  bitmap size or by adding strings for the first time.  Normally, you do not need to use this function as it  is
;                  called internally as needed.
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __GUICtrlToolbar_AutoSize($hWnd)
	_SendMessage($hWnd, $TB_AUTOSIZE)
EndFunc   ;==>__GUICtrlToolbar_AutoSize

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_ButtonCount($hWnd)
	Return _SendMessage($hWnd, $TB_BUTTONCOUNT)
EndFunc   ;==>_GUICtrlToolbar_ButtonCount

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUICtrlToolbar_ButtonStructSize
; Description ...: Specifies the size of the $tagTBBUTTON structure
; Syntax.........: __GUICtrlToolbar_ButtonStructSize ( $hWnd )
; Parameters ....: $hWnd        - Handle to the control
; Return values .:
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......: This function is used to tell the control the size of a $tagTBBUTTON structure.  Normally, you do not  need  to
;                  use this function as it is called internally when the control is created.
; Related .......: $tagTBBUTTON
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __GUICtrlToolbar_ButtonStructSize($hWnd)
	Local $tButton = DllStructCreate($tagTBBUTTON)
	_SendMessage($hWnd, $TB_BUTTONSTRUCTSIZE, DllStructGetSize($tButton), 0, 0, "wparam", "ptr")
EndFunc   ;==>__GUICtrlToolbar_ButtonStructSize

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_CheckButton($hWnd, $iCommandID, $bCheck = True)
	Return _SendMessage($hWnd, $TB_CHECKBUTTON, $iCommandID, $bCheck) <> 0
EndFunc   ;==>_GUICtrlToolbar_CheckButton

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_ClickAccel($hWnd, $sAccelKey, $sButton = "left", $bMove = False, $iClicks = 1, $iSpeed = 1)
	Local $iID = _GUICtrlToolbar_MapAccelerator($hWnd, $sAccelKey)
	_GUICtrlToolbar_ClickButton($hWnd, $iID, $sButton, $bMove, $iClicks, $iSpeed)
EndFunc   ;==>_GUICtrlToolbar_ClickAccel

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlToolbar_ClickButton($hWnd, $iCommandID, $sButton = "left", $bMove = False, $iClicks = 1, $iSpeed = 1)
	Local $tRECT = _GUICtrlToolbar_GetButtonRectEx($hWnd, $iCommandID)
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
EndFunc   ;==>_GUICtrlToolbar_ClickButton

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_ClickIndex($hWnd, $iIndex, $sButton = "left", $bMove = False, $iClicks = 1, $iSpeed = 1)
	Local $iCommandID = _GUICtrlToolbar_IndexToCommand($hWnd, $iIndex)
	_GUICtrlToolbar_ClickButton($hWnd, $iCommandID, $sButton, $bMove, $iClicks, $iSpeed)
EndFunc   ;==>_GUICtrlToolbar_ClickIndex

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_CommandToIndex($hWnd, $iCommandID)
	Return _SendMessage($hWnd, $TB_COMMANDTOINDEX, $iCommandID)
EndFunc   ;==>_GUICtrlToolbar_CommandToIndex

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlToolbar_Create($hWnd, $iStyle = 0x00000800, $iExStyle = 0x00000000)
	$iStyle = BitOR($iStyle, $__UDFGUICONSTANT_WS_CHILD, $__TOOLBARCONSTANT_WS_CLIPSIBLINGS, $__UDFGUICONSTANT_WS_VISIBLE)

	Local $nCtrlID = __UDF_GetNextGlobalID($hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Local $hTool = _WinAPI_CreateWindowEx($iExStyle, $__TOOLBARCONSTANT_ClassName, "", $iStyle, 0, 0, 0, 0, $hWnd, $nCtrlID)
	__GUICtrlToolbar_ButtonStructSize($hTool)
	Return $hTool
EndFunc   ;==>_GUICtrlToolbar_Create

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_Customize($hWnd)
	_SendMessage($hWnd, $TB_CUSTOMIZE)
EndFunc   ;==>_GUICtrlToolbar_Customize

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_DeleteButton($hWnd, $iCommandID)
	Local $iIndex = _GUICtrlToolbar_CommandToIndex($hWnd, $iCommandID)
	If $iIndex = -1 Then Return SetError(-1, 0, False)
	Return _SendMessage($hWnd, $TB_DELETEBUTTON, $iIndex) <> 0
EndFunc   ;==>_GUICtrlToolbar_DeleteButton

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_Destroy(ByRef $hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__TOOLBARCONSTANT_ClassName) Then Return SetError(2, 2, False)

	Local $iDestroyed = 0
	If _WinAPI_InProcess($hWnd, $__g_hTBLastWnd) Then
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
EndFunc   ;==>_GUICtrlToolbar_Destroy

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_EnableButton($hWnd, $iCommandID, $bEnable = True)
	Return _SendMessage($hWnd, $TB_ENABLEBUTTON, $iCommandID, $bEnable) <> 0
EndFunc   ;==>_GUICtrlToolbar_EnableButton

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_FindToolbar($hWnd, $sText)
	Local $iCommandID, $hToolbar

	If Not _WinAPI_IsWindow($hWnd) Then
		$hWnd = WinGetHandle($hWnd)
		If @error Then Return SetError(-1, -1, 0)
	EndIf
	Local $aWinList = _WinAPI_EnumWindows(True, $hWnd)
	For $iI = 1 To $aWinList[0][0]
		If $aWinList[$iI][1] = $__TOOLBARCONSTANT_ClassName Then
			$hToolbar = $aWinList[$iI][0]
			For $iJ = 0 To _GUICtrlToolbar_ButtonCount($hToolbar) - 1
				$iCommandID = _GUICtrlToolbar_IndexToCommand($hToolbar, $iJ)
				If _GUICtrlToolbar_GetButtonText($hToolbar, $iCommandID) = $sText Then Return $hToolbar
			Next
		EndIf
	Next
	Return SetError(-2, -2, 0)
EndFunc   ;==>_GUICtrlToolbar_FindToolbar

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_GetAnchorHighlight($hWnd)
	Return _SendMessage($hWnd, $TB_GETANCHORHIGHLIGHT) <> 0
EndFunc   ;==>_GUICtrlToolbar_GetAnchorHighlight

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_GetBitmapFlags($hWnd)
	Return _SendMessage($hWnd, $TB_GETBITMAPFLAGS)
EndFunc   ;==>_GUICtrlToolbar_GetBitmapFlags

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_GetButtonBitmap($hWnd, $iCommandID)
	Return _SendMessage($hWnd, $TB_GETBITMAP, $iCommandID)
EndFunc   ;==>_GUICtrlToolbar_GetButtonBitmap

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_GetButtonInfo($hWnd, $iCommandID)
	Local $aButton[5]

	Local $tButton = _GUICtrlToolbar_GetButtonInfoEx($hWnd, $iCommandID)
	$aButton[0] = DllStructGetData($tButton, "Image")
	$aButton[1] = DllStructGetData($tButton, "State")
	$aButton[2] = DllStructGetData($tButton, "Style")
	$aButton[3] = DllStructGetData($tButton, "CX")
	$aButton[4] = DllStructGetData($tButton, "Param")
	Return $aButton
EndFunc   ;==>_GUICtrlToolbar_GetButtonInfo

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlToolbar_GetButtonInfoEx($hWnd, $iCommandID)
	Local $bUnicode = _GUICtrlToolbar_GetUnicodeFormat($hWnd)

	Local $tButton = DllStructCreate($tagTBBUTTONINFO)
	Local $iButton = DllStructGetSize($tButton)
	Local $iMask = BitOR($TBIF_IMAGE, $TBIF_STATE, $TBIF_STYLE, $TBIF_LPARAM, $TBIF_SIZE)
	DllStructSetData($tButton, "Size", $iButton)
	DllStructSetData($tButton, "Mask", $iMask)
	Local $iRet
	If _WinAPI_InProcess($hWnd, $__g_hTBLastWnd) Then
		$iRet = _SendMessage($hWnd, $TB_GETBUTTONINFOW, $iCommandID, $tButton, 0, "wparam", "struct*")
	Else
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iButton, $tMemMap)
		_MemWrite($tMemMap, $tButton, $pMemory, $iButton)
		If $bUnicode Then
			$iRet = _SendMessage($hWnd, $TB_GETBUTTONINFOW, $iCommandID, $pMemory, 0, "wparam", "ptr")
		Else
			$iRet = _SendMessage($hWnd, $TB_GETBUTTONINFOA, $iCommandID, $pMemory, 0, "wparam", "ptr")
		EndIf
		_MemRead($tMemMap, $pMemory, $tButton, $iButton)
		_MemFree($tMemMap)
	EndIf
	Return SetError($iRet = -1, 0, $tButton)
EndFunc   ;==>_GUICtrlToolbar_GetButtonInfoEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_GetButtonParam($hWnd, $iCommandID)
	Local $tButton = _GUICtrlToolbar_GetButtonInfoEx($hWnd, $iCommandID)
	Return DllStructGetData($tButton, "Param")
EndFunc   ;==>_GUICtrlToolbar_GetButtonParam

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_GetButtonRect($hWnd, $iCommandID)
	Local $aRect[4]

	Local $tRECT = _GUICtrlToolbar_GetButtonRectEx($hWnd, $iCommandID)
	$aRect[0] = DllStructGetData($tRECT, "Left")
	$aRect[1] = DllStructGetData($tRECT, "Top")
	$aRect[2] = DllStructGetData($tRECT, "Right")
	$aRect[3] = DllStructGetData($tRECT, "Bottom")
	Return $aRect
EndFunc   ;==>_GUICtrlToolbar_GetButtonRect

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlToolbar_GetButtonRectEx($hWnd, $iCommandID)
	Local $tRECT = DllStructCreate($tagRECT)
	If _WinAPI_InProcess($hWnd, $__g_hTBLastWnd) Then
		_SendMessage($hWnd, $TB_GETRECT, $iCommandID, $tRECT, 0, "wparam", "struct*")
	Else
		Local $iRect = DllStructGetSize($tRECT)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iRect, $tMemMap)
		_SendMessage($hWnd, $TB_GETRECT, $iCommandID, $pMemory, 0, "wparam", "ptr")
		_MemRead($tMemMap, $pMemory, $tRECT, $iRect)
		_MemFree($tMemMap)
	EndIf
	Return $tRECT
EndFunc   ;==>_GUICtrlToolbar_GetButtonRectEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_GetButtonSize($hWnd)
	Local $aSize[2]

	Local $iRet = _SendMessage($hWnd, $TB_GETBUTTONSIZE)
	$aSize[0] = _WinAPI_HiWord($iRet)
	$aSize[1] = _WinAPI_LoWord($iRet)
	Return $aSize
EndFunc   ;==>_GUICtrlToolbar_GetButtonSize

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_GetButtonState($hWnd, $iCommandID)
	Return _SendMessage($hWnd, $TB_GETSTATE, $iCommandID)
EndFunc   ;==>_GUICtrlToolbar_GetButtonState

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_GetButtonStyle($hWnd, $iCommandID)
	Local $tButton = _GUICtrlToolbar_GetButtonInfoEx($hWnd, $iCommandID)
	Return DllStructGetData($tButton, "Style")
EndFunc   ;==>_GUICtrlToolbar_GetButtonStyle

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlToolbar_GetButtonText($hWnd, $iCommandID)
	Local $bUnicode = _GUICtrlToolbar_GetUnicodeFormat($hWnd)

	Local $iBuffer
	If $bUnicode Then
		$iBuffer = _SendMessage($hWnd, $TB_GETBUTTONTEXTW, $iCommandID)
	Else
		$iBuffer = _SendMessage($hWnd, $TB_GETBUTTONTEXTA, $iCommandID)
	EndIf
	If $iBuffer = 0 Then Return SetError(True, 0, "")
	If $iBuffer = 1 Then Return SetError(False, 0, "")
	If $iBuffer <= -1 Then Return SetError(False, -1, "")
	$iBuffer += 1
	Local $tBuffer
	If $bUnicode Then
		$tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
		$iBuffer *= 2
	Else
		$tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
	EndIf
	Local $iRet
	If _WinAPI_InProcess($hWnd, $__g_hTBLastWnd) Then
		$iRet = _SendMessage($hWnd, $TB_GETBUTTONTEXTW, $iCommandID, $tBuffer, 0, "wparam", "struct*")
	Else
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iBuffer, $tMemMap)
		If $bUnicode Then
			$iRet = _SendMessage($hWnd, $TB_GETBUTTONTEXTW, $iCommandID, $pMemory, 0, "wparam", "ptr")
		Else
			$iRet = _SendMessage($hWnd, $TB_GETBUTTONTEXTA, $iCommandID, $pMemory, 0, "wparam", "ptr")
		EndIf
		_MemRead($tMemMap, $pMemory, $tBuffer, $iBuffer)
		_MemFree($tMemMap)
	EndIf
	Return SetError($iRet > 0, 0, DllStructGetData($tBuffer, "Text"))
EndFunc   ;==>_GUICtrlToolbar_GetButtonText

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlToolbar_GetColorScheme($hWnd)
	Local $aColor[2], $iRet

	Local $tColor = DllStructCreate($tagCOLORSCHEME)
	Local $iColor = DllStructGetSize($tColor)
	DllStructSetData($tColor, "Size", $iColor)
	If _WinAPI_InProcess($hWnd, $__g_hTBLastWnd) Then
		$iRet = _SendMessage($hWnd, $TB_GETCOLORSCHEME, 0, $tColor, 0, "wparam", "struct*")
	Else
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iColor, $tMemMap)
		$iRet = _SendMessage($hWnd, $TB_GETCOLORSCHEME, 0, $pMemory, 0, "wparam", "ptr")
		_MemRead($tMemMap, $pMemory, $tColor, $iColor)
		_MemFree($tMemMap)
	EndIf
	$aColor[0] = DllStructGetData($tColor, "BtnHighlight")
	$aColor[1] = DllStructGetData($tColor, "BtnShadow")
	Return SetError($iRet = 0, 0, $aColor)
EndFunc   ;==>_GUICtrlToolbar_GetColorScheme

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_GetDisabledImageList($hWnd)
	Return Ptr(_SendMessage($hWnd, $TB_GETDISABLEDIMAGELIST))
EndFunc   ;==>_GUICtrlToolbar_GetDisabledImageList

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_GetExtendedStyle($hWnd)
	Return _SendMessage($hWnd, $TB_GETEXTENDEDSTYLE)
EndFunc   ;==>_GUICtrlToolbar_GetExtendedStyle

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_GetHotImageList($hWnd)
	Return Ptr(_SendMessage($hWnd, $TB_GETHOTIMAGELIST))
EndFunc   ;==>_GUICtrlToolbar_GetHotImageList

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_GetHotItem($hWnd)
	Return _SendMessage($hWnd, $TB_GETHOTITEM)
EndFunc   ;==>_GUICtrlToolbar_GetHotItem

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_GetImageList($hWnd)
	Return Ptr(_SendMessage($hWnd, $TB_GETIMAGELIST))
EndFunc   ;==>_GUICtrlToolbar_GetImageList

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlToolbar_GetInsertMark($hWnd)
	Local $aMark[2], $iRet

	Local $tMark = DllStructCreate($tagTBINSERTMARK)
	If _WinAPI_InProcess($hWnd, $__g_hTBLastWnd) Then
		$iRet = _SendMessage($hWnd, $TB_GETINSERTMARK, 0, $tMark, 0, "wparam", "struct*")
	Else
		Local $iMark = DllStructGetSize($tMark)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iMark, $tMemMap)
		$iRet = _SendMessage($hWnd, $TB_GETINSERTMARK, 0, $pMemory, 0, "wparam", "ptr")
		_MemRead($tMemMap, $pMemory, $tMark, $iMark)
		_MemFree($tMemMap)
	EndIf
	$aMark[0] = DllStructGetData($tMark, "Button")
	$aMark[1] = DllStructGetData($tMark, "Flags")
	Return SetError($iRet <> 0, 0, $aMark)
EndFunc   ;==>_GUICtrlToolbar_GetInsertMark

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_GetInsertMarkColor($hWnd)
	Return _SendMessage($hWnd, $TB_GETINSERTMARKCOLOR)
EndFunc   ;==>_GUICtrlToolbar_GetInsertMarkColor

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlToolbar_GetMaxSize($hWnd)
	Local $aSize[2], $iRet

	Local $tSize = DllStructCreate($tagSIZE)
	If _WinAPI_InProcess($hWnd, $__g_hTBLastWnd) Then
		$iRet = _SendMessage($hWnd, $TB_GETMAXSIZE, 0, $tSize, 0, "wparam", "struct*")
	Else
		Local $iSize = DllStructGetSize($tSize)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iSize, $tMemMap)
		$iRet = _SendMessage($hWnd, $TB_GETMAXSIZE, 0, $pMemory, 0, "wparam", "ptr")
		_MemRead($tMemMap, $pMemory, $tSize, $iSize)
		_MemFree($tMemMap)
	EndIf
	$aSize[0] = DllStructGetData($tSize, "X")
	$aSize[1] = DllStructGetData($tSize, "Y")
	Return SetError($iRet = 0, 0, $aSize)
EndFunc   ;==>_GUICtrlToolbar_GetMaxSize

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlToolbar_GetMetrics($hWnd)
	Local $aMetrics[4]

	Local $tMetrics = DllStructCreate($tagTBMETRICS)
	Local $iMetrics = DllStructGetSize($tMetrics)
	Local $iMask = BitOR($TBMF_PAD, $TBMF_BUTTONSPACING)
	DllStructSetData($tMetrics, "Size", $iMetrics)
	DllStructSetData($tMetrics, "Mask", $iMask)
	If _WinAPI_InProcess($hWnd, $__g_hTBLastWnd) Then
		_SendMessage($hWnd, $TB_GETMETRICS, 0, $tMetrics, 0, "wparam", "struct*")
	Else
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iMetrics, $tMemMap)
		_SendMessage($hWnd, $TB_GETMETRICS, 0, $pMemory, 0, "wparam", "ptr")
		_MemRead($tMemMap, $pMemory, $tMetrics, $iMetrics)
		_MemFree($tMemMap)
	EndIf
	$aMetrics[0] = DllStructGetData($tMetrics, "XPad")
	$aMetrics[1] = DllStructGetData($tMetrics, "YPad")
	$aMetrics[2] = DllStructGetData($tMetrics, "XSpacing")
	$aMetrics[3] = DllStructGetData($tMetrics, "YSpacing")
	Return $aMetrics
EndFunc   ;==>_GUICtrlToolbar_GetMetrics

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_GetPadding($hWnd)
	Local $aPad[2]

	Local $iPad = _SendMessage($hWnd, $TB_GETPADDING)
	$aPad[0] = _WinAPI_LoWord($iPad)
	$aPad[1] = _WinAPI_HiWord($iPad)
	Return $aPad
EndFunc   ;==>_GUICtrlToolbar_GetPadding

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_GetRows($hWnd)
	Return _SendMessage($hWnd, $TB_GETROWS)
EndFunc   ;==>_GUICtrlToolbar_GetRows

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlToolbar_GetString($hWnd, $iIndex)
	Local $bUnicode = _GUICtrlToolbar_GetUnicodeFormat($hWnd)

	Local $iBuffer
	If $bUnicode Then
		$iBuffer = _SendMessage($hWnd, $TB_GETSTRINGW, _WinAPI_MakeLong(0, $iIndex), 0, 0, "long") + 1
	Else
		$iBuffer = _SendMessage($hWnd, $TB_GETSTRINGA, _WinAPI_MakeLong(0, $iIndex), 0, 0, "long") + 1
	EndIf

	If $iBuffer = 0 Then Return SetError(-1, 0, "")
	If $iBuffer = 1 Then Return ""
	Local $tBuffer
	If $bUnicode Then
		$tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
		$iBuffer *= 2
	Else
		$tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
	EndIf
	Local $iRet
	If _WinAPI_InProcess($hWnd, $__g_hTBLastWnd) Then
		$iRet = _SendMessage($hWnd, $TB_GETSTRINGW, _WinAPI_MakeLong($iBuffer, $iIndex), $tBuffer, 0, "long", "struct*")
	Else
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iBuffer, $tMemMap)
		If $bUnicode Then
			$iRet = _SendMessage($hWnd, $TB_GETSTRINGW, _WinAPI_MakeLong($iBuffer, $iIndex), $pMemory, 0, "long", "ptr")
		Else
			$iRet = _SendMessage($hWnd, $TB_GETSTRINGA, _WinAPI_MakeLong($iBuffer, $iIndex), $pMemory, 0, "long", "ptr")
		EndIf
		_MemRead($tMemMap, $pMemory, $tBuffer, $iBuffer)
		_MemFree($tMemMap)
	EndIf
	Return SetError($iRet = -1, 0, DllStructGetData($tBuffer, "Text"))
EndFunc   ;==>_GUICtrlToolbar_GetString

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_GetStyle($hWnd)
	Return _SendMessage($hWnd, $TB_GETSTYLE)
EndFunc   ;==>_GUICtrlToolbar_GetStyle

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_GetStyleAltDrag($hWnd)
	Return BitAND(_GUICtrlToolbar_GetStyle($hWnd), $TBSTYLE_ALTDRAG) <> 0
EndFunc   ;==>_GUICtrlToolbar_GetStyleAltDrag

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_GetStyleCustomErase($hWnd)
	Return BitAND(_GUICtrlToolbar_GetStyle($hWnd), $TBSTYLE_CUSTOMERASE) <> 0
EndFunc   ;==>_GUICtrlToolbar_GetStyleCustomErase

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_GetStyleFlat($hWnd)
	Return BitAND(_GUICtrlToolbar_GetStyle($hWnd), $TBSTYLE_FLAT) <> 0
EndFunc   ;==>_GUICtrlToolbar_GetStyleFlat

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_GetStyleList($hWnd)
	Return BitAND(_GUICtrlToolbar_GetStyle($hWnd), $TBSTYLE_LIST) <> 0
EndFunc   ;==>_GUICtrlToolbar_GetStyleList

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_GetStyleRegisterDrop($hWnd)
	Return BitAND(_GUICtrlToolbar_GetStyle($hWnd), $TBSTYLE_REGISTERDROP) <> 0
EndFunc   ;==>_GUICtrlToolbar_GetStyleRegisterDrop

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_GetStyleToolTips($hWnd)
	Return BitAND(_GUICtrlToolbar_GetStyle($hWnd), $TBSTYLE_TOOLTIPS) <> 0
EndFunc   ;==>_GUICtrlToolbar_GetStyleToolTips

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_GetStyleTransparent($hWnd)
	Return BitAND(_GUICtrlToolbar_GetStyle($hWnd), $TBSTYLE_TRANSPARENT) <> 0
EndFunc   ;==>_GUICtrlToolbar_GetStyleTransparent

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_GetStyleWrapable($hWnd)
	Return BitAND(_GUICtrlToolbar_GetStyle($hWnd), $TBSTYLE_WRAPABLE) <> 0
EndFunc   ;==>_GUICtrlToolbar_GetStyleWrapable

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_GetTextRows($hWnd)
	Return _SendMessage($hWnd, $TB_GETTEXTROWS)
EndFunc   ;==>_GUICtrlToolbar_GetTextRows

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_GetToolTips($hWnd)
	Return HWnd(_SendMessage($hWnd, $TB_GETTOOLTIPS))
EndFunc   ;==>_GUICtrlToolbar_GetToolTips

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_GetUnicodeFormat($hWnd)
	Return _SendMessage($hWnd, $TB_GETUNICODEFORMAT) <> 0
EndFunc   ;==>_GUICtrlToolbar_GetUnicodeFormat

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_HideButton($hWnd, $iCommandID, $bHide = True)
	Return _SendMessage($hWnd, $TB_HIDEBUTTON, $iCommandID, $bHide) <> 0
EndFunc   ;==>_GUICtrlToolbar_HideButton

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_HighlightButton($hWnd, $iCommandID, $bHighlight = True)
	Return _SendMessage($hWnd, $TB_MARKBUTTON, $iCommandID, $bHighlight) <> 0
EndFunc   ;==>_GUICtrlToolbar_HighlightButton

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlToolbar_HitTest($hWnd, $iX, $iY)
	Local $tPoint = DllStructCreate($tagPOINT)
	DllStructSetData($tPoint, "X", $iX)
	DllStructSetData($tPoint, "Y", $iY)
	Local $iRet
	If _WinAPI_InProcess($hWnd, $__g_hTBLastWnd) Then
		$iRet = _SendMessage($hWnd, $TB_HITTEST, 0, $tPoint, 0, "wparam", "struct*")
	Else
		Local $iPoint = DllStructGetSize($tPoint)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iPoint, $tMemMap)
		_MemWrite($tMemMap, $tPoint, $pMemory, $iPoint)
		$iRet = _SendMessage($hWnd, $TB_HITTEST, 0, $pMemory, 0, "wparam", "ptr")
		_MemFree($tMemMap)
	EndIf
	Return $iRet
EndFunc   ;==>_GUICtrlToolbar_HitTest

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_IndexToCommand($hWnd, $iIndex)
	Local $tButton = DllStructCreate($tagTBBUTTON)
	If _WinAPI_InProcess($hWnd, $__g_hTBLastWnd) Then
		_SendMessage($hWnd, $TB_GETBUTTON, $iIndex, $tButton, 0, "wparam", "struct*")
	Else
		Local $iButton = DllStructGetSize($tButton)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iButton, $tMemMap)
		_MemWrite($tMemMap, $tButton, $pMemory, $iButton)
		_SendMessage($hWnd, $TB_GETBUTTON, $iIndex, $pMemory, 0, "wparam", "ptr")
		_MemRead($tMemMap, $pMemory, $tButton, $iButton)
		_MemFree($tMemMap)
	EndIf
	Return DllStructGetData($tButton, "Command")
EndFunc   ;==>_GUICtrlToolbar_IndexToCommand

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlToolbar_InsertButton($hWnd, $iIndex, $iID, $iImage, $sText = "", $iStyle = 0, $iState = 4, $iParam = 0)
	Local $bUnicode = _GUICtrlToolbar_GetUnicodeFormat($hWnd)

	Local $tBuffer, $iRet

	Local $tButton = DllStructCreate($tagTBBUTTON)
	Local $iBuffer = StringLen($sText) + 1
	If $iBuffer > 1 Then
		If $bUnicode Then
			$tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
			$iBuffer *= 2
		Else
			$tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
		EndIf
		DllStructSetData($tBuffer, "Text", $sText)
		DllStructSetData($tButton, "String", DllStructGetPtr($tBuffer))
	EndIf
	DllStructSetData($tButton, "Bitmap", $iImage)
	DllStructSetData($tButton, "Command", $iID)
	DllStructSetData($tButton, "State", $iState)
	DllStructSetData($tButton, "Style", $iStyle)
	DllStructSetData($tButton, "Param", $iParam)
	If _WinAPI_InProcess($hWnd, $__g_hTBLastWnd) Then
		$iRet = _SendMessage($hWnd, $TB_INSERTBUTTONW, $iIndex, $tButton, 0, "wparam", "struct*")
	Else
		Local $iButton = DllStructGetSize($tButton)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iButton + $iBuffer, $tMemMap)
		Local $pText = $pMemory + $iButton
		_MemWrite($tMemMap, $tButton, $pMemory, $iButton)
		If $iBuffer > 1 Then
			DllStructSetData($tButton, "String", $pText)
			_MemWrite($tMemMap, $tBuffer, $pText, $iBuffer)
		EndIf
		If $bUnicode Then
			$iRet = _SendMessage($hWnd, $TB_INSERTBUTTONW, $iIndex, $pMemory, 0, "wparam", "ptr")
		Else
			$iRet = _SendMessage($hWnd, $TB_INSERTBUTTONA, $iIndex, $pMemory, 0, "wparam", "ptr")
		EndIf
		_MemFree($tMemMap)
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlToolbar_InsertButton

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlToolbar_InsertMarkHitTest($hWnd, $iX, $iY)
	Local $aMark[2], $iRet

	Local $tPoint = DllStructCreate($tagPOINT)
	Local $tMark = DllStructCreate($tagTBINSERTMARK)
	DllStructSetData($tPoint, "X", $iX)
	DllStructSetData($tPoint, "Y", $iY)
	If _WinAPI_InProcess($hWnd, $__g_hTBLastWnd) Then
		$iRet = _SendMessage($hWnd, $TB_INSERTMARKHITTEST, $tPoint, $tMark, 0, "struct*", "struct*")
	Else
		Local $iPoint = DllStructGetSize($tPoint)
		Local $iMark = DllStructGetSize($tMark)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iPoint + $iMark, $tMemMap)
		Local $pMarkPtr = $pMemory + $iPoint
		_MemWrite($tMemMap, $tPoint, $pMemory, $iPoint)
		$iRet = _SendMessage($hWnd, $TB_INSERTMARKHITTEST, $pMemory, $pMarkPtr, 0, "wparam", "ptr")
		_MemRead($tMemMap, $pMarkPtr, $tMark, $iMark)
		_MemFree($tMemMap)
	EndIf
	$aMark[0] = DllStructGetData($tMark, "Button")
	$aMark[1] = DllStructGetData($tMark, "Flags")
	Return SetError($iRet <> 0, 0, $aMark)
EndFunc   ;==>_GUICtrlToolbar_InsertMarkHitTest

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_IsButtonChecked($hWnd, $iCommandID)
	Return _SendMessage($hWnd, $TB_ISBUTTONCHECKED, $iCommandID) <> 0
EndFunc   ;==>_GUICtrlToolbar_IsButtonChecked

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_IsButtonEnabled($hWnd, $iCommandID)
	Return _SendMessage($hWnd, $TB_ISBUTTONENABLED, $iCommandID) <> 0
EndFunc   ;==>_GUICtrlToolbar_IsButtonEnabled

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_IsButtonHidden($hWnd, $iCommandID)
	Return _SendMessage($hWnd, $TB_ISBUTTONHIDDEN, $iCommandID) <> 0
EndFunc   ;==>_GUICtrlToolbar_IsButtonHidden

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_IsButtonHighlighted($hWnd, $iCommandID)
	Return _SendMessage($hWnd, $TB_ISBUTTONHIGHLIGHTED, $iCommandID) <> 0
EndFunc   ;==>_GUICtrlToolbar_IsButtonHighlighted

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_IsButtonIndeterminate($hWnd, $iCommandID)
	Return _SendMessage($hWnd, $TB_ISBUTTONINDETERMINATE, $iCommandID) <> 0
EndFunc   ;==>_GUICtrlToolbar_IsButtonIndeterminate

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_IsButtonPressed($hWnd, $iCommandID)
	Return _SendMessage($hWnd, $TB_ISBUTTONPRESSED, $iCommandID) <> 0
EndFunc   ;==>_GUICtrlToolbar_IsButtonPressed

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_LoadBitmap($hWnd, $sFileName)
	Local $aSize = _GUICtrlToolbar_GetButtonSize($hWnd)
	Local $hBitmap = _WinAPI_LoadImage(0, $sFileName, 0, $aSize[1], $aSize[0], $LR_LOADFROMFILE)
	If $hBitmap = 0 Then Return SetError(-1, -1, -1)
	Return _GUICtrlToolbar_AddBitmap($hWnd, 1, 0, $hBitmap)
EndFunc   ;==>_GUICtrlToolbar_LoadBitmap

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_LoadImages($hWnd, $iBitMapID)
	Return _SendMessage($hWnd, $TB_LOADIMAGES, $iBitMapID, $__TOOLBARCONSTANT_HINST_COMMCTRL)
EndFunc   ;==>_GUICtrlToolbar_LoadImages

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlToolbar_MapAccelerator($hWnd, $sAccelKey)
	Local $tCommand = DllStructCreate("int Data")
	If _WinAPI_InProcess($hWnd, $__g_hTBLastWnd) Then
		_SendMessage($hWnd, $TB_MAPACCELERATORW, Asc($sAccelKey), $tCommand, 0, "wparam", "struct*")
	Else
		Local $iCommand = DllStructGetSize($tCommand)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iCommand, $tMemMap)
		_SendMessage($hWnd, $TB_MAPACCELERATORW, Asc($sAccelKey), $pMemory, 0, "wparam", "ptr")
		_MemRead($tMemMap, $pMemory, $tCommand, $iCommand)
		_MemFree($tMemMap)
	EndIf
	Return DllStructGetData($tCommand, "Data")
EndFunc   ;==>_GUICtrlToolbar_MapAccelerator

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_MoveButton($hWnd, $iOldPos, $iNewPos)
	Return _SendMessage($hWnd, $TB_MOVEBUTTON, $iOldPos, $iNewPos) <> 0
EndFunc   ;==>_GUICtrlToolbar_MoveButton

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_PressButton($hWnd, $iCommandID, $bPress = True)
	Return _SendMessage($hWnd, $TB_PRESSBUTTON, $iCommandID, $bPress) <> 0
EndFunc   ;==>_GUICtrlToolbar_PressButton

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_SetAnchorHighlight($hWnd, $bAnchor)
	Return _SendMessage($hWnd, $TB_SETANCHORHIGHLIGHT, $bAnchor)
EndFunc   ;==>_GUICtrlToolbar_SetAnchorHighlight

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlToolbar_SetBitmapSize($hWnd, $iWidth, $iHeight)
	Return _SendMessage($hWnd, $TB_SETBITMAPSIZE, 0, _WinAPI_MakeLong($iWidth, $iHeight), 0, "wparam", "long") <> 0
EndFunc   ;==>_GUICtrlToolbar_SetBitmapSize

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_SetButtonBitMap($hWnd, $iCommandID, $iIndex)
	Return _SendMessage($hWnd, $TB_CHANGEBITMAP, $iCommandID, $iIndex) <> 0
EndFunc   ;==>_GUICtrlToolbar_SetButtonBitMap

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_SetButtonInfo($hWnd, $iCommandID, $iImage = -3, $iState = -1, $iStyle = -1, $iWidth = -1, $iParam = -1)
	Local $iMask = 0

	Local $tButton = DllStructCreate($tagTBBUTTONINFO)
	If $iImage <> -3 Then
		$iMask = $TBIF_IMAGE
		DllStructSetData($tButton, "Image", $iImage)
	EndIf
	If $iState <> -1 Then
		$iMask = BitOR($iMask, $TBIF_STATE)
		DllStructSetData($tButton, "State", $iState)
	EndIf
	If $iStyle <> -1 Then
		$iMask = BitOR($iMask, $TBIF_STYLE)
		DllStructSetData($tButton, "Style", $iStyle)
	EndIf
	If $iWidth <> -1 Then
		$iMask = BitOR($iMask, $TBIF_SIZE)
		DllStructSetData($tButton, "CX", $iWidth)
	EndIf
	If $iParam <> -1 Then
		$iMask = BitOR($iMask, $TBIF_LPARAM)
		DllStructSetData($tButton, "Param", $iParam)
	EndIf
	DllStructSetData($tButton, "Mask", $iMask)
	Return _GUICtrlToolbar_SetButtonInfoEx($hWnd, $iCommandID, $tButton)
EndFunc   ;==>_GUICtrlToolbar_SetButtonInfo

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlToolbar_SetButtonInfoEx($hWnd, $iCommandID, $tButton)
	Local $iButton = DllStructGetSize($tButton)
	DllStructSetData($tButton, "Size", $iButton)
	Local $iRet
	If _WinAPI_InProcess($hWnd, $__g_hTBLastWnd) Then
		$iRet = _SendMessage($hWnd, $TB_SETBUTTONINFOW, $iCommandID, $tButton, 0, "wparam", "struct*")
	Else
		Local $iBuffer = DllStructGetData($tButton, "TextMax")
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iButton + $iBuffer, $tMemMap)
		Local $pBuffer = $pMemory + $iButton
		DllStructSetData($tButton, "Text", $pBuffer)
		_MemWrite($tMemMap, $tButton, $pMemory, $iButton)
		_MemWrite($tMemMap, $pBuffer, $pBuffer, $iBuffer)
		$iRet = _SendMessage($hWnd, $TB_SETBUTTONINFOW, $iCommandID, $pMemory, 0, "wparam", "ptr")
		_MemFree($tMemMap)
	EndIf

	Return $iRet <> 0
EndFunc   ;==>_GUICtrlToolbar_SetButtonInfoEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_SetButtonParam($hWnd, $iCommandID, $iParam)
	Local $tButton = DllStructCreate($tagTBBUTTONINFO)
	DllStructSetData($tButton, "Mask", $TBIF_LPARAM)
	DllStructSetData($tButton, "Param", $iParam)
	Return _GUICtrlToolbar_SetButtonInfoEx($hWnd, $iCommandID, $tButton)
EndFunc   ;==>_GUICtrlToolbar_SetButtonParam

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlToolbar_SetButtonSize($hWnd, $iHeight, $iWidth)
	Return _SendMessage($hWnd, $TB_SETBUTTONSIZE, 0, _WinAPI_MakeLong($iWidth, $iHeight), 0, "wparam", "long") <> 0
EndFunc   ;==>_GUICtrlToolbar_SetButtonSize

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_SetButtonState($hWnd, $iCommandID, $iState)
	Return _SendMessage($hWnd, $TB_SETSTATE, $iCommandID, $iState) <> 0
EndFunc   ;==>_GUICtrlToolbar_SetButtonState

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_SetButtonStyle($hWnd, $iCommandID, $iStyle)
	Local $tButton = DllStructCreate($tagTBBUTTONINFO)
	DllStructSetData($tButton, "Mask", $TBIF_STYLE)
	DllStructSetData($tButton, "Style", $iStyle)
	Return _GUICtrlToolbar_SetButtonInfoEx($hWnd, $iCommandID, $tButton)
EndFunc   ;==>_GUICtrlToolbar_SetButtonStyle

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_SetButtonText($hWnd, $iCommandID, $sText)
	Local $iBuffer = StringLen($sText) + 1
	Local $tBuffer = DllStructCreate("wchar Text[" & $iBuffer * 2 & "]")
	$iBuffer *= 2
	Local $pBuffer = DllStructGetPtr($tBuffer)
	Local $tButton = DllStructCreate($tagTBBUTTONINFO)
	DllStructSetData($tBuffer, "Text", $sText)
	DllStructSetData($tButton, "Mask", $TBIF_TEXT)
	DllStructSetData($tButton, "Text", $pBuffer)
	DllStructSetData($tButton, "TextMax", $iBuffer)
	Return _GUICtrlToolbar_SetButtonInfoEx($hWnd, $iCommandID, $tButton)
EndFunc   ;==>_GUICtrlToolbar_SetButtonText

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlToolbar_SetButtonWidth($hWnd, $iMin, $iMax)
	Return _SendMessage($hWnd, $TB_SETBUTTONWIDTH, 0, _WinAPI_MakeLong($iMin, $iMax), 0, "wparam", "long") <> 0
EndFunc   ;==>_GUICtrlToolbar_SetButtonWidth

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_SetCmdID($hWnd, $iIndex, $iCommandID)
	Return _SendMessage($hWnd, $TB_SETCMDID, $iIndex, $iCommandID) <> 0
EndFunc   ;==>_GUICtrlToolbar_SetCmdID

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlToolbar_SetColorScheme($hWnd, $iHighlight, $iShadow)
	Local $tColor = DllStructCreate($tagCOLORSCHEME)
	Local $iColor = DllStructGetSize($tColor)
	DllStructSetData($tColor, "Size", $iColor)
	DllStructSetData($tColor, "BtnHighlight", $iHighlight)
	DllStructSetData($tColor, "BtnShadow", $iShadow)
	If _WinAPI_InProcess($hWnd, $__g_hTBLastWnd) Then
		_SendMessage($hWnd, $TB_SETCOLORSCHEME, 0, $tColor, 0, "wparam", "struct*")
	Else
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iColor, $tMemMap)
		_MemWrite($tMemMap, $tColor, $pMemory, $iColor)
		_SendMessage($hWnd, $TB_SETCOLORSCHEME, 0, $pMemory, 0, "wparam", "ptr")
		_MemFree($tMemMap)
	EndIf
EndFunc   ;==>_GUICtrlToolbar_SetColorScheme

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlToolbar_SetDisabledImageList($hWnd, $hImageList)
	Return _SendMessage($hWnd, $TB_SETDISABLEDIMAGELIST, 0, $hImageList, 0, "wparam", "handle", "handle")
EndFunc   ;==>_GUICtrlToolbar_SetDisabledImageList

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_SetDrawTextFlags($hWnd, $iMask, $iDTFlags)
	Return _SendMessage($hWnd, $TB_SETDRAWTEXTFLAGS, $iMask, $iDTFlags)
EndFunc   ;==>_GUICtrlToolbar_SetDrawTextFlags

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_SetExtendedStyle($hWnd, $iStyle)
	Return _SendMessage($hWnd, $TB_SETEXTENDEDSTYLE, 0, $iStyle)
EndFunc   ;==>_GUICtrlToolbar_SetExtendedStyle

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlToolbar_SetHotImageList($hWnd, $hImageList)
	Return _SendMessage($hWnd, $TB_SETHOTIMAGELIST, 0, $hImageList, 0, "wparam", "handle", "handle")
EndFunc   ;==>_GUICtrlToolbar_SetHotImageList

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_SetHotItem($hWnd, $iIndex)
	Return _SendMessage($hWnd, $TB_SETHOTITEM, $iIndex)
EndFunc   ;==>_GUICtrlToolbar_SetHotItem

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlToolbar_SetImageList($hWnd, $hImageList)
	Return _SendMessage($hWnd, $TB_SETIMAGELIST, 0, $hImageList, 0, "wparam", "handle", "handle")
EndFunc   ;==>_GUICtrlToolbar_SetImageList

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_SetIndent($hWnd, $iIndent)
	Return _SendMessage($hWnd, $TB_SETINDENT, $iIndent) <> 0
EndFunc   ;==>_GUICtrlToolbar_SetIndent

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_SetIndeterminate($hWnd, $iCommandID, $bState = True)
	Return _SendMessage($hWnd, $TB_INDETERMINATE, $iCommandID, $bState) <> 0
EndFunc   ;==>_GUICtrlToolbar_SetIndeterminate

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlToolbar_SetInsertMark($hWnd, $iButton, $iFlags = 0)
	Local $tMark = DllStructCreate($tagTBINSERTMARK)
	DllStructSetData($tMark, "Button", $iButton)
	DllStructSetData($tMark, "Flags", $iFlags)
	If _WinAPI_InProcess($hWnd, $__g_hTBLastWnd) Then
		_SendMessage($hWnd, $TB_SETINSERTMARK, 0, $tMark, 0, "wparam", "struct*")
	Else
		Local $iMark = DllStructGetSize($tMark)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iMark, $tMemMap)
		_MemWrite($tMemMap, $tMark, $pMemory, $iMark)
		_SendMessage($hWnd, $TB_SETINSERTMARK, 0, $pMemory, 0, "wparam", "ptr")
		_MemFree($tMemMap)
	EndIf
EndFunc   ;==>_GUICtrlToolbar_SetInsertMark

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_SetInsertMarkColor($hWnd, $iColor)
	Return _SendMessage($hWnd, $TB_SETINSERTMARKCOLOR, 0, $iColor)
EndFunc   ;==>_GUICtrlToolbar_SetInsertMarkColor

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_SetMaxTextRows($hWnd, $iMaxRows)
	Return _SendMessage($hWnd, $TB_SETMAXTEXTROWS, $iMaxRows) <> 0
EndFunc   ;==>_GUICtrlToolbar_SetMaxTextRows

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlToolbar_SetMetrics($hWnd, $iXPad, $iYPad, $iXSpacing, $iYSpacing)
	Local $tMetrics = DllStructCreate($tagTBMETRICS)
	Local $iMetrics = DllStructGetSize($tMetrics)
	Local $iMask = BitOR($TBMF_PAD, $TBMF_BUTTONSPACING)
	DllStructSetData($tMetrics, "Size", $iMetrics)
	DllStructSetData($tMetrics, "Mask", $iMask)
	DllStructSetData($tMetrics, "XPad", $iXPad)
	DllStructSetData($tMetrics, "YPad", $iYPad)
	DllStructSetData($tMetrics, "XSpacing", $iXSpacing)
	DllStructSetData($tMetrics, "YSpacing", $iYSpacing)
	If _WinAPI_InProcess($hWnd, $__g_hTBLastWnd) Then
		_SendMessage($hWnd, $TB_SETMETRICS, 0, $tMetrics, 0, "wparam", "struct*")
	Else
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iMetrics, $tMemMap)
		_MemWrite($tMemMap, $tMetrics, $pMemory, $iMetrics)
		_SendMessage($hWnd, $TB_SETMETRICS, 0, $pMemory, 0, "wparam", "ptr")
		_MemFree($tMemMap)
	EndIf
EndFunc   ;==>_GUICtrlToolbar_SetMetrics

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlToolbar_SetPadding($hWnd, $iCX, $iCY)
	Return _SendMessage($hWnd, $TB_SETPADDING, 0, _WinAPI_MakeLong($iCX, $iCY), 0, "wparam", "long")
EndFunc   ;==>_GUICtrlToolbar_SetPadding

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_SetParent($hWnd, $hParent)
	Return HWnd(_SendMessage($hWnd, $TB_SETPARENT, $hParent))
EndFunc   ;==>_GUICtrlToolbar_SetParent

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlToolbar_SetRows($hWnd, $iRows, $bLarger = True)
	Local $tRECT = DllStructCreate($tagRECT)
	If _WinAPI_InProcess($hWnd, $__g_hTBLastWnd) Then
		_SendMessage($hWnd, $TB_SETROWS, _WinAPI_MakeLong($iRows, $bLarger), $tRECT, 0, "long", "struct*")
	Else
		Local $iRect = DllStructGetSize($tRECT)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iRect, $tMemMap)
		_SendMessage($hWnd, $TB_SETROWS, _WinAPI_MakeLong($iRows, $bLarger), $pMemory, 0, "long", "ptr")
		_MemRead($tMemMap, $pMemory, $tRECT, $iRect)
		_MemFree($tMemMap)
	EndIf
	Local $aRect[4]
	$aRect[0] = DllStructGetData($tRECT, "Left")
	$aRect[1] = DllStructGetData($tRECT, "Top")
	$aRect[2] = DllStructGetData($tRECT, "Right")
	$aRect[3] = DllStructGetData($tRECT, "Bottom")
	Return $aRect
EndFunc   ;==>_GUICtrlToolbar_SetRows

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_SetStyle($hWnd, $iStyle)
	$iStyle = BitOR($iStyle, $__UDFGUICONSTANT_WS_CHILD, $__TOOLBARCONSTANT_WS_CLIPSIBLINGS, $__UDFGUICONSTANT_WS_VISIBLE)
	_SendMessage($hWnd, $TB_SETSTYLE, 0, $iStyle)
EndFunc   ;==>_GUICtrlToolbar_SetStyle

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_SetStyleAltDrag($hWnd, $bState = True)
	Return __GUICtrlToolbar_SetStyleEx($hWnd, $TBSTYLE_ALTDRAG, $bState)
EndFunc   ;==>_GUICtrlToolbar_SetStyleAltDrag

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_SetStyleCustomErase($hWnd, $bState = True)
	Return __GUICtrlToolbar_SetStyleEx($hWnd, $TBSTYLE_CUSTOMERASE, $bState)
EndFunc   ;==>_GUICtrlToolbar_SetStyleCustomErase

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUICtrlToolbar_SetStyleEx
; Description ...: Changes a style for the toolbar
; Syntax.........: __GUICtrlToolbar_SetStyleEx ( $hWnd, $iStyle, $bStyle )
; Parameters ....: $hWnd        - Handle to the control
;                  $iStyle      - Style to be changed
;                  $bStyle      - True to set, false to unset
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......: This function is used internally to implement the SetStylex functions
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __GUICtrlToolbar_SetStyleEx($hWnd, $iStyle, $bStyle)
	Local $iN = _GUICtrlToolbar_GetStyle($hWnd)
	If $bStyle Then
		$iN = BitOR($iN, $iStyle)
	Else
		$iN = BitAND($iN, BitNOT($iStyle))
	EndIf
	Return _GUICtrlToolbar_SetStyle($hWnd, $iN)
EndFunc   ;==>__GUICtrlToolbar_SetStyleEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_SetStyleFlat($hWnd, $bState)
	Return __GUICtrlToolbar_SetStyleEx($hWnd, $TBSTYLE_FLAT, $bState)
EndFunc   ;==>_GUICtrlToolbar_SetStyleFlat

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_SetStyleList($hWnd, $bState)
	Return __GUICtrlToolbar_SetStyleEx($hWnd, $TBSTYLE_LIST, $bState)
EndFunc   ;==>_GUICtrlToolbar_SetStyleList

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_SetStyleRegisterDrop($hWnd, $bState)
	Return __GUICtrlToolbar_SetStyleEx($hWnd, $TBSTYLE_REGISTERDROP, $bState)
EndFunc   ;==>_GUICtrlToolbar_SetStyleRegisterDrop

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_SetStyleToolTips($hWnd, $bState)
	Return __GUICtrlToolbar_SetStyleEx($hWnd, $TBSTYLE_TOOLTIPS, $bState)
EndFunc   ;==>_GUICtrlToolbar_SetStyleToolTips

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_SetStyleTransparent($hWnd, $bState)
	Return __GUICtrlToolbar_SetStyleEx($hWnd, $TBSTYLE_TRANSPARENT, $bState)
EndFunc   ;==>_GUICtrlToolbar_SetStyleTransparent

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_SetStyleWrapable($hWnd, $bState)
	Return __GUICtrlToolbar_SetStyleEx($hWnd, $TBSTYLE_WRAPABLE, $bState)
EndFunc   ;==>_GUICtrlToolbar_SetStyleWrapable

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlToolbar_SetToolTips($hWnd, $hToolTip)
	_SendMessage($hWnd, $TB_SETTOOLTIPS, $hToolTip, 0, 0, "hwnd")
EndFunc   ;==>_GUICtrlToolbar_SetToolTips

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlToolbar_SetUnicodeFormat($hWnd, $bUnicode = False)
	Return _SendMessage($hWnd, $TB_SETUNICODEFORMAT, $bUnicode)
EndFunc   ;==>_GUICtrlToolbar_SetUnicodeFormat

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlToolbar_SetWindowTheme($hWnd, $sTheme)
	Local $tTheme = _WinAPI_MultiByteToWideChar($sTheme)
	If _WinAPI_InProcess($hWnd, $__g_hTBLastWnd) Then
		_SendMessage($hWnd, $TB_SETWINDOWTHEME, 0, $tTheme, 0, "wparam", "struct*")
	Else
		Local $iTheme = DllStructGetSize($tTheme)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iTheme, $tMemMap)
		_MemWrite($tMemMap, $tTheme, $pMemory, $iTheme)
		_SendMessage($hWnd, $TB_SETWINDOWTHEME, 0, $pMemory, 0, "wparam", "ptr")
		_MemFree($tMemMap)
	EndIf
EndFunc   ;==>_GUICtrlToolbar_SetWindowTheme
