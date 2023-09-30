#include-once

#include "Memory.au3"
#include "SendMessage.au3"
#include "StructureConstants.au3"
#include "ToolTipConstants.au3"
#include "WinAPI.au3"

; #INDEX# =======================================================================================================================
; Title .........: ToolTip
; AutoIt Version : 3.3.14.2
; Description ...: Functions that assist with ToolTip control management.
;                  ToolTip controls are pop-up windows that display text.  The text usually describes a tool, which is  either  a
;                  window, such as a child window or control, or an application-defined rectangular area within a window's client
;                  area.
; Author(s) .....: Paul Campbell (PaulIA)
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
Global $__g_hTTLastWnd
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $_TOOLTIPCONSTANTS_ClassName = "tooltips_class32"
Global Const $_TT_ghTTDefaultStyle = BitOR($TTS_ALWAYSTIP, $TTS_NOPREFIX)
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _GUIToolTip_Activate
; _GUIToolTip_AddTool
; _GUIToolTip_AdjustRect
; _GUIToolTip_BitsToTTF
; _GUIToolTip_Create
; _GUIToolTip_Deactivate
; _GUIToolTip_DelTool
; _GUIToolTip_Destroy
; _GUIToolTip_EnumTools
; _GUIToolTip_GetBubbleHeight
; _GUIToolTip_GetBubbleSize
; _GUIToolTip_GetBubbleWidth
; _GUIToolTip_GetCurrentTool
; _GUIToolTip_GetDelayTime
; _GUIToolTip_GetMargin
; _GUIToolTip_GetMarginEx
; _GUIToolTip_GetMaxTipWidth
; _GUIToolTip_GetText
; _GUIToolTip_GetTipBkColor
; _GUIToolTip_GetTipTextColor
; _GUIToolTip_GetTitleBitMap
; _GUIToolTip_GetTitleText
; _GUIToolTip_GetToolCount
; _GUIToolTip_GetToolInfo
; _GUIToolTip_HitTest
; _GUIToolTip_NewToolRect
; _GUIToolTip_Pop
; _GUIToolTip_PopUp
; _GUIToolTip_SetDelayTime
; _GUIToolTip_SetMargin
; _GUIToolTip_SetMaxTipWidth
; _GUIToolTip_SetTipBkColor
; _GUIToolTip_SetTipTextColor
; _GUIToolTip_SetTitle
; _GUIToolTip_SetToolInfo
; _GUIToolTip_SetWindowTheme
; _GUIToolTip_ToolExists
; _GUIToolTip_ToolToArray
; _GUIToolTip_TrackActivate
; _GUIToolTip_TrackPosition
; _GUIToolTip_Update
; _GUIToolTip_UpdateTipText
; ===============================================================================================================================

; #NEW_FUNCTIONS# ===============================================================================================================
; _GUIToolTip_Deactivate
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; $tagNMTTDISPINFO
; $tagTOOLINFO
; $tagTTGETTITLE
; $tagTTHITTESTINFO
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagNMTTDISPINFO
; Description ...: Contains information used in handling the $TTN_GETDISPINFOW notification message
; Fields ........: $tagNMHDR - Contains information about a notification message
;                  pText     - Pointer to a string that will be displayed as the ToolTip text.  If Instance specifies an instance
;                  +handle, this member must be the identifier of a string resource.
;                  aText     - Buffer that receives the ToolTip text.  An application can copy the text to this buffer instead of
;                  +specifying a string address or string resource.
;                  Instance  - Handle to the instance that contains a string resource to be used as the ToolTip text. If pText is
;                  +the address of the ToolTip text string, this member must be 0.
;                  Flags     - Flags that indicates how to interpret the IDFrom member:
;                  |$TTF_IDISHWND   - If this flag is set, IDFrom is the tool's handle. Otherwise, it is the tool's identifier.
;                  |$TTF_RTLREADING - Specifies right to left text
;                  |$TTF_DI_SETITEM - If you add this flag to Flags while processing the notification, the ToolTip  control  will
;                  +retain the supplied information and not request it again.
;                  Param     - Application-defined data associated with the tool
; Author ........: Paul Campbell (PaulIA)
; Remarks .......: You need to point the pText array to your own private buffer when the text used in the ToolTip text exceeds 80
;                  +characters in length.  The system automatically strips the accelerator from all strings passed to  a  ToolTip
;                  control, unless the control has the $TTS_NOPREFIX style.
; ===============================================================================================================================
Global Const $tagNMTTDISPINFO = $tagNMHDR & ";ptr pText;wchar aText[80];ptr Instance;uint Flags;lparam Param"

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagTOOLINFO
; Description ...: Contains information about a tool in a ToolTip contr
; Fields ........: Size    - Size of this structure, in bytes
;                  Flags    - Flags that control the ToolTip display. This member can be a combination of the following values:
;                  |$TTF_ABSOLUTE    - Positions the ToolTip at the same coordinates provided by $TTM_TRACKPOSITION
;                  |$TTF_CENTERTIP   - Centers the ToolTip below the tool specified by the ID member
;                  |$TTF_IDISHWND    - Indicates that the ID member is the window handle to the tool
;                  |$TTF_PARSELINKS  - Indicates that links in the tooltip text should be parsed
;                  |$TTF_RTLREADING  - Indicates that the ToolTip text will be displayed in the opposite direction
;                  |$TTF_SUBCLASS    - Indicates that the ToolTip control should subclass the tool's window to intercept messages
;                  |$TTF_TRACK       - Positions the ToolTip next to the tool to which it corresponds
;                  |$TTF_TRANSPARENT - Causes the ToolTip control to forward mouse event messages to the parent window
;                  hWnd     - Handle to the window that contains the tool
;                  ID       - Application-defined identifier of the tool
;                  Left     - X position of upper left corner of bounding rectangle
;                  Top      - Y position of upper left corner of bounding rectangle
;                  Right    - X position of lower right corner of bounding rectangle
;                  Bottom   - Y position of lower right corner of bounding rectangle
;                  hInst    - Handle to the instance that contains the string resource for the too
;                  Text     - Pointer to the buffer that contains the text for the tool
;                  Param    - A 32-bit application-defined value that is associated with the tool
;                  Reserved - Reserved
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagTOOLINFO = "uint Size;uint Flags;hwnd hWnd;uint_ptr ID;" & $tagRECT & ";handle hInst;ptr Text;lparam Param;ptr Reserved"

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagTTGETTITLE
; Description ...: Provides information about the title of a tooltip control
; Fields ........: Size     - Size of this structure, in bytes
;                  Bitmap   - The tooltip icon
;                  TitleMax - Specifies the number of characters in the title
;                  Title    - Pointer to a wide character string that contains the title
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagTTGETTITLE = "dword Size;uint Bitmap;uint TitleMax;ptr Title"

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagTTHITTESTINFO
; Description ...: Contains information that a ToolTip control uses to determine whether a point is in the bounding rectangle of the specified tool
; Fields ........: Tool     - Handle to the tool or window with the specified tool
;                  X        - X position to be tested, in client coordinates
;                  Y        - Y position to be tested, in client coordinates
;                  Size     - Size of a TOOLINFO structure
;                  Flags    - Flags that control the ToolTip display. This member can be a combination of the following values:
;                  |$TTF_ABSOLUTE    - Positions the ToolTip at the same coordinates provided by $TTM_TRACKPOSITION
;                  |$TTF_CENTERTIP   - Centers the ToolTip below the tool specified by the ID member
;                  |$TTF_IDISHWND    - Indicates that the ID member is the window handle to the tool
;                  |$TTF_PARSELINKS  - Indicates that links in the tooltip text should be parsed
;                  |$TTF_RTLREADING  - Indicates that the ToolTip text will be displayed in the opposite direction
;                  |$TTF_SUBCLASS    - Indicates that the ToolTip control should subclass the tool's window to intercept messages
;                  |$TTF_TRACK       - Positions the ToolTip next to the tool to which it corresponds
;                  |$TTF_TRANSPARENT - Causes the ToolTip control to forward mouse event messages to the parent window
;                  hWnd     - Handle to the window that contains the tool
;                  ID       - Application-defined identifier of the tool
;                  Left     - X position of upper left corner of bounding rectangle
;                  Top      - Y position of upper left corner of bounding rectangle
;                  Right    - X position of lower right corner of bounding rectangle
;                  Bottom   - Y position of lower right corner of bounding rectangle
;                  hInst    - Handle to the instance that contains the string resource for the too
;                  Text     - Pointer to the buffer that contains the text for the tool
;                  Param    - A 32-bit application-defined value that is associated with the tool
;                  Reserved - Reserved
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagTTHITTESTINFO = "hwnd Tool;" & $tagPOINT & ";" & $tagTOOLINFO

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Bob Marotte (BrewManNH)
; ===============================================================================================================================
Func _GUIToolTip_Activate($hWnd)
	_SendMessage($hWnd, $TTM_ACTIVATE, True)
EndFunc   ;==>_GUIToolTip_Activate

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Bob Marotte (BrewManNH)
; ===============================================================================================================================
Func _GUIToolTip_AddTool($hTool, $hWnd, $sText, $iID = 0, $iLeft = 0, $iTop = 0, $iRight = 0, $iBottom = 0, $iFlags = Default, $iParam = 0)
	Local $iBuffer, $tBuffer, $pBuffer
	If $iFlags = Default Then $iFlags = BitOR($TTF_SUBCLASS, $TTF_IDISHWND)
	If $sText <> -1 Then
		$iBuffer = StringLen($sText) + 1
		$tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
		$iBuffer *= 2
		$pBuffer = DllStructGetPtr($tBuffer)
		DllStructSetData($tBuffer, "Text", $sText)
	Else
		$iBuffer = 0
		$pBuffer = -1 ; LPSTR_TEXTCALLBACK
	EndIf
	Local $tToolInfo = DllStructCreate($tagTOOLINFO)
	Local $iToolInfo = DllStructGetSize($tToolInfo)
	DllStructSetData($tToolInfo, "Size", $iToolInfo)
	DllStructSetData($tToolInfo, "Flags", $iFlags)
	DllStructSetData($tToolInfo, "hWnd", $hWnd)
	DllStructSetData($tToolInfo, "ID", $iID)
	DllStructSetData($tToolInfo, "Left", $iLeft)
	DllStructSetData($tToolInfo, "Top", $iTop)
	DllStructSetData($tToolInfo, "Right", $iRight)
	DllStructSetData($tToolInfo, "Bottom", $iBottom)
	DllStructSetData($tToolInfo, "Param", $iParam)
	Local $iRet
	If _WinAPI_InProcess($hTool, $__g_hTTLastWnd) Then
		DllStructSetData($tToolInfo, "Text", $pBuffer)
		$iRet = _SendMessage($hTool, $TTM_ADDTOOLW, 0, $tToolInfo, 0, "wparam", "struct*")
	Else
		Local $tMemMap
		Local $pMemory = _MemInit($hTool, $iToolInfo + $iBuffer, $tMemMap)
		If $sText <> -1 Then
			Local $pText = $pMemory + $iToolInfo
			DllStructSetData($tToolInfo, "Text", $pText)
			_MemWrite($tMemMap, $tBuffer, $pText, $iBuffer)
		Else
			DllStructSetData($tToolInfo, "Text", -1) ; LPSTR_TEXTCALLBACK
		EndIf
		_MemWrite($tMemMap, $tToolInfo, $pMemory, $iToolInfo)
		$iRet = _SendMessage($hTool, $TTM_ADDTOOLW, 0, $pMemory, 0, "wparam", "ptr")
		_MemFree($tMemMap)
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUIToolTip_AddTool

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIToolTip_AdjustRect($hWnd, ByRef $tRECT, $bLarger = True)
	If _WinAPI_InProcess($hWnd, $__g_hTTLastWnd) Then
		_SendMessage($hWnd, $TTM_ADJUSTRECT, $bLarger, $tRECT, 0, "wparam", "struct*")
	Else
		Local $iRect = DllStructGetSize($tRECT)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iRect, $tMemMap)
		_MemWrite($tMemMap, $tRECT)
		_SendMessage($hWnd, $TTM_ADJUSTRECT, $bLarger, $pMemory, 0, "wparam", "ptr")
		_MemRead($tMemMap, $pMemory, $tRECT, $iRect)
		_MemFree($tMemMap)
	EndIf
	Return $tRECT
EndFunc   ;==>_GUIToolTip_AdjustRect

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Bob Marotte (BrewManNH)
; ===============================================================================================================================
Func _GUIToolTip_BitsToTTF($iFlags)
	Local $iN = ""
	If BitAND($iFlags, $TTF_IDISHWND) <> 0 Then $iN &= "TTF_IDISHWND,"
	If BitAND($iFlags, $TTF_CENTERTIP) <> 0 Then $iN &= "TTF_CENTERTIP,"
	If BitAND($iFlags, $TTF_RTLREADING) <> 0 Then $iN &= "TTF_RTLREADING,"
	If BitAND($iFlags, $TTF_SUBCLASS) <> 0 Then $iN &= "TTF_SUBCLASS,"
	If BitAND($iFlags, $TTF_TRACK) <> 0 Then $iN &= "TTF_TRACK,"
	If BitAND($iFlags, $TTF_ABSOLUTE) <> 0 Then $iN &= "TTF_ABSOLUTE,"
	If BitAND($iFlags, $TTF_TRANSPARENT) <> 0 Then $iN &= "TTF_TRANSPARENT,"
	If BitAND($iFlags, $TTF_PARSELINKS) <> 0 Then $iN &= "TTF_PARSELINKS,"
	Return StringTrimRight($iN, 1)
EndFunc   ;==>_GUIToolTip_BitsToTTF

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUIToolTip_Create($hWnd, $iStyle = $_TT_ghTTDefaultStyle)
	Return _WinAPI_CreateWindowEx(0, $_TOOLTIPCONSTANTS_ClassName, "", $iStyle, 0, 0, 0, 0, $hWnd)
EndFunc   ;==>_GUIToolTip_Create

; #FUNCTION# ====================================================================================================================
; Author ........: Bob Marotte (BrewManNH)
; Modified.......:
; ===============================================================================================================================
Func _GUIToolTip_Deactivate($hWnd)
	_SendMessage($hWnd, $TTM_ACTIVATE, False)
EndFunc   ;==>_GUIToolTip_Deactivate

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Bob Marotte (BrewManNH)
; ===============================================================================================================================
Func _GUIToolTip_DelTool($hWnd, $hTool, $iID = 0)
	Local $tToolInfo = DllStructCreate($tagTOOLINFO)
	Local $iToolInfo = DllStructGetSize($tToolInfo)
	DllStructSetData($tToolInfo, "Size", $iToolInfo)
	DllStructSetData($tToolInfo, "ID", $iID)
	DllStructSetData($tToolInfo, "hWnd", $hTool)
	If _WinAPI_InProcess($hWnd, $__g_hTTLastWnd) Then
		_SendMessage($hWnd, $TTM_DELTOOLW, 0, $tToolInfo, 0, "wparam", "struct*")
	Else
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iToolInfo, $tMemMap)
		_MemWrite($tMemMap, $tToolInfo)
		_SendMessage($hWnd, $TTM_DELTOOLW, 0, $pMemory, 0, "wparam", "ptr")
		_MemFree($tMemMap)
	EndIf
EndFunc   ;==>_GUIToolTip_DelTool

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUIToolTip_Destroy(ByRef $hWnd)
	If Not _WinAPI_IsClassName($hWnd, $_TOOLTIPCONSTANTS_ClassName) Then Return SetError(2, 2, False)

	Local $iDestroyed = 0
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hTTLastWnd) Then
			$iDestroyed = _WinAPI_DestroyWindow($hWnd)
		Else
			; Not Allowed to Destroy Other Applications Control(s)
			Return SetError(1, 1, False)
		EndIf
	EndIf
	If $iDestroyed Then $hWnd = 0
	Return $iDestroyed <> 0
EndFunc   ;==>_GUIToolTip_Destroy

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIToolTip_EnumTools($hWnd, $iIndex)
	Local $tToolInfo = DllStructCreate($tagTOOLINFO)
	Local $iToolInfo = DllStructGetSize($tToolInfo)
	DllStructSetData($tToolInfo, "Size", $iToolInfo)
	Local $bResult
	If _WinAPI_InProcess($hWnd, $__g_hTTLastWnd) Then
		$bResult = _SendMessage($hWnd, $TTM_ENUMTOOLSW, $iIndex, $tToolInfo, 0, "wparam", "struct*")
	Else
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iToolInfo, $tMemMap)
		_MemWrite($tMemMap, $tToolInfo, $pMemory, $iToolInfo)
		$bResult = _SendMessage($hWnd, $TTM_ENUMTOOLSW, $iIndex, $pMemory, 0, "wparam", "ptr")
		_MemRead($tMemMap, $pMemory, $tToolInfo, $iToolInfo)
		_MemFree($tMemMap)
	EndIf
	Return _GUIToolTip_ToolToArray($hWnd, $tToolInfo, $bResult = True)
EndFunc   ;==>_GUIToolTip_EnumTools

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Bob Marotte (BrewManNH)
; ===============================================================================================================================
Func _GUIToolTip_GetBubbleHeight($hWnd, $hTool, $iID, $iFlags = Default)
	If $iFlags = Default Then $iFlags = BitOR($TTF_IDISHWND, $TTF_SUBCLASS)
	Return _WinAPI_HiWord(_GUIToolTip_GetBubbleSize($hWnd, $hTool, $iID, $iFlags))
EndFunc   ;==>_GUIToolTip_GetBubbleHeight

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Bob Marotte (BrewManNH)
; ===============================================================================================================================
Func _GUIToolTip_GetBubbleSize($hWnd, $hTool, $iID, $iFlags = Default)
	If $iFlags = Default Then $iFlags = BitOR($TTF_IDISHWND, $TTF_SUBCLASS)
	Local $tToolInfo = DllStructCreate($tagTOOLINFO)
	Local $iToolInfo = DllStructGetSize($tToolInfo)
	DllStructSetData($tToolInfo, "Size", $iToolInfo)
	DllStructSetData($tToolInfo, "hWnd", $hTool)
	DllStructSetData($tToolInfo, "ID", $iID)
	DllStructSetData($tToolInfo, "Flags", $iFlags)
	Local $iRet
	If _WinAPI_InProcess($hWnd, $__g_hTTLastWnd) Then
		$iRet = _SendMessage($hWnd, $TTM_GETBUBBLESIZE, 0, $tToolInfo, 0, "wparam", "struct*")
	Else
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iToolInfo, $tMemMap)
		_MemWrite($tMemMap, $tToolInfo)
		$iRet = _SendMessage($hWnd, $TTM_GETBUBBLESIZE, 0, $pMemory, 0, "wparam", "ptr")
		_MemFree($tMemMap)
	EndIf
	Return $iRet
EndFunc   ;==>_GUIToolTip_GetBubbleSize

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Bob Marotte (BrewManNH)
; ===============================================================================================================================
Func _GUIToolTip_GetBubbleWidth($hWnd, $hTool, $iID, $iFlags = Default)
	If $iFlags = Default Then $iFlags = BitOR($TTF_IDISHWND, $TTF_SUBCLASS)
	Return _WinAPI_LoWord(_GUIToolTip_GetBubbleSize($hWnd, $hTool, $iID, $iFlags))
EndFunc   ;==>_GUIToolTip_GetBubbleWidth

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIToolTip_GetCurrentTool($hWnd)
	Local $tToolInfo = DllStructCreate($tagTOOLINFO)
	Local $iToolInfo = DllStructGetSize($tToolInfo)
	DllStructSetData($tToolInfo, "Size", $iToolInfo)
	Local $bResult
	If _WinAPI_InProcess($hWnd, $__g_hTTLastWnd) Then
		$bResult = _SendMessage($hWnd, $TTM_GETCURRENTTOOLW, 0, $tToolInfo, 0, "wparam", "struct*")
	Else
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iToolInfo, $tMemMap)
		_MemWrite($tMemMap, $tToolInfo, $pMemory, $iToolInfo)
		$bResult = _SendMessage($hWnd, $TTM_GETCURRENTTOOLW, 0, $pMemory, 0, "wparam", "ptr")
		_MemRead($tMemMap, $pMemory, $tToolInfo, $iToolInfo)
		_MemFree($tMemMap)
	EndIf
	Return _GUIToolTip_ToolToArray($hWnd, $tToolInfo, $bResult = True)
EndFunc   ;==>_GUIToolTip_GetCurrentTool

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Bob Marotte (BrewManNH)
; ===============================================================================================================================
Func _GUIToolTip_GetDelayTime($hWnd, $iDuration)
	Return _SendMessage($hWnd, $TTM_GETDELAYTIME, $iDuration)
EndFunc   ;==>_GUIToolTip_GetDelayTime

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIToolTip_GetMargin($hWnd)
	Local $aMargin[4]

	Local $tRECT = _GUIToolTip_GetMarginEx($hWnd)
	$aMargin[0] = DllStructGetData($tRECT, "Left")
	$aMargin[1] = DllStructGetData($tRECT, "Top")
	$aMargin[2] = DllStructGetData($tRECT, "Right")
	$aMargin[3] = DllStructGetData($tRECT, "Bottom")
	Return $aMargin
EndFunc   ;==>_GUIToolTip_GetMargin

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIToolTip_GetMarginEx($hWnd)
	Local $tRECT = DllStructCreate($tagRECT)
	If _WinAPI_InProcess($hWnd, $__g_hTTLastWnd) Then
		_SendMessage($hWnd, $TTM_GETMARGIN, 0, $tRECT, 0, "wparam", "struct*")
	Else
		Local $iRect = DllStructGetSize($tRECT)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iRect, $tMemMap)
		_SendMessage($hWnd, $TTM_GETMARGIN, 0, $pMemory, 0, "wparam", "ptr")
		_MemRead($tMemMap, $pMemory, $tRECT, $iRect)
		_MemFree($tMemMap)
	EndIf
	Return $tRECT
EndFunc   ;==>_GUIToolTip_GetMarginEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIToolTip_GetMaxTipWidth($hWnd)
	Return _SendMessage($hWnd, $TTM_GETMAXTIPWIDTH)
EndFunc   ;==>_GUIToolTip_GetMaxTipWidth

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIToolTip_GetText($hWnd, $hTool, $iID)
	Local $tBuffer = DllStructCreate("wchar Text[4096]")
	Local $tToolInfo = DllStructCreate($tagTOOLINFO)
	Local $iToolInfo = DllStructGetSize($tToolInfo)
	DllStructSetData($tToolInfo, "Size", $iToolInfo)
	DllStructSetData($tToolInfo, "hWnd", $hTool)
	DllStructSetData($tToolInfo, "ID", $iID)
	If _WinAPI_InProcess($hWnd, $__g_hTTLastWnd) Then
		DllStructSetData($tToolInfo, "Text", DllStructGetPtr($tBuffer))
		_SendMessage($hWnd, $TTM_GETTEXTW, 0, $tToolInfo, 0, "wparam", "struct*")
	Else
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iToolInfo + 4096, $tMemMap)
		Local $pText = $pMemory + $iToolInfo
		DllStructSetData($tToolInfo, "Text", $pText)
		_MemWrite($tMemMap, $tToolInfo, $pMemory, $iToolInfo)
		_SendMessage($hWnd, $TTM_GETTEXTW, 0, $pMemory, 0, "wparam", "ptr")
		_MemRead($tMemMap, $pText, $tBuffer, 81)
		_MemFree($tMemMap)
	EndIf
	Return DllStructGetData($tBuffer, "Text")
EndFunc   ;==>_GUIToolTip_GetText

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIToolTip_GetTipBkColor($hWnd)
	Return _SendMessage($hWnd, $TTM_GETTIPBKCOLOR)
EndFunc   ;==>_GUIToolTip_GetTipBkColor

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIToolTip_GetTipTextColor($hWnd)
	Return _SendMessage($hWnd, $TTM_GETTIPTEXTCOLOR)
EndFunc   ;==>_GUIToolTip_GetTipTextColor

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIToolTip_GetTitleBitMap($hWnd)
	Local $tBuffer = DllStructCreate("wchar Text[4096]")
	Local $tTitle = DllStructCreate($tagTTGETTITLE)
	Local $iTitle = DllStructGetSize($tTitle)
	DllStructSetData($tTitle, "TitleMax", DllStructGetSize($tBuffer))
	DllStructSetData($tTitle, "Size", $iTitle)
	If _WinAPI_InProcess($hWnd, $__g_hTTLastWnd) Then
		DllStructSetData($tTitle, "Title", DllStructGetPtr($tBuffer))
		_SendMessage($hWnd, $TTM_GETTITLE, 0, $tTitle, 0, "wparam", "struct*")
	Else
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iTitle + 4096, $tMemMap)
		Local $pText = $pMemory + $iTitle
		DllStructSetData($tTitle, "Title", $pText)
		_MemWrite($tMemMap, $tTitle, $pMemory, $iTitle)
		_SendMessage($hWnd, $TTM_GETTITLE, 0, $pMemory, 0, "wparam", "ptr")
		_MemRead($tMemMap, $pText, $tBuffer, 4096)
		_MemFree($tMemMap)
	EndIf
	Return DllStructGetData($tTitle, "Bitmap")
EndFunc   ;==>_GUIToolTip_GetTitleBitMap

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIToolTip_GetTitleText($hWnd)
	Local $tBuffer = DllStructCreate("wchar Text[4096]")
	Local $tTitle = DllStructCreate($tagTTGETTITLE)
	Local $iTitle = DllStructGetSize($tTitle)
	DllStructSetData($tTitle, "TitleMax", DllStructGetSize($tBuffer))
	DllStructSetData($tTitle, "Size", $iTitle)
	If _WinAPI_InProcess($hWnd, $__g_hTTLastWnd) Then
		DllStructSetData($tTitle, "Title", DllStructGetPtr($tBuffer))
		_SendMessage($hWnd, $TTM_GETTITLE, 0, $tTitle, 0, "wparam", "struct*")
	Else
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iTitle + 4096, $tMemMap)
		Local $pText = $pMemory + $iTitle
		DllStructSetData($tTitle, "Title", $pText)
		_MemWrite($tMemMap, $tTitle, $pMemory, $iTitle)
		_SendMessage($hWnd, $TTM_GETTITLE, 0, $pMemory, 0, "wparam", "ptr")
		_MemRead($tMemMap, $pText, $tBuffer, 4096)
		_MemFree($tMemMap)
	EndIf
	Return DllStructGetData($tBuffer, "Text")
EndFunc   ;==>_GUIToolTip_GetTitleText

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIToolTip_GetToolCount($hWnd)
	Return _SendMessage($hWnd, $TTM_GETTOOLCOUNT)
EndFunc   ;==>_GUIToolTip_GetToolCount

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIToolTip_GetToolInfo($hWnd, $hTool, $iID)
	Local $tToolInfo = DllStructCreate($tagTOOLINFO)
	Local $iToolInfo = DllStructGetSize($tToolInfo)
	DllStructSetData($tToolInfo, "Size", $iToolInfo)
	DllStructSetData($tToolInfo, "hWnd", $hTool)
	DllStructSetData($tToolInfo, "ID", $iID)
	Local $bResult
	If _WinAPI_InProcess($hWnd, $__g_hTTLastWnd) Then
		$bResult = _SendMessage($hWnd, $TTM_GETTOOLINFOW, 0, $tToolInfo, 0, "wparam", "struct*")
	Else
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iToolInfo, $tMemMap)
		_MemWrite($tMemMap, $tToolInfo, $pMemory, $iToolInfo)
		$bResult = _SendMessage($hWnd, $TTM_GETTOOLINFOW, 0, $pMemory, 0, "wparam", "ptr")
		_MemRead($tMemMap, $pMemory, $tToolInfo, $iToolInfo)
		_MemFree($tMemMap)
	EndIf
	Return _GUIToolTip_ToolToArray($hWnd, $tToolInfo, $bResult = True)
EndFunc   ;==>_GUIToolTip_GetToolInfo

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIToolTip_HitTest($hWnd, $hTool, $iX, $iY)
	Local $tHitTest = DllStructCreate($tagTTHITTESTINFO)
	Local $tToolInfo = DllStructCreate($tagTOOLINFO)
	Local $iToolInfo = DllStructGetSize($tToolInfo)
	DllStructSetData($tHitTest, "Tool", $hTool)
	DllStructSetData($tHitTest, "X", $iX)
	DllStructSetData($tHitTest, "Y", $iY)
	DllStructSetData($tHitTest, "Size", $iToolInfo)
	Local $bResult
	If _WinAPI_InProcess($hWnd, $__g_hTTLastWnd) Then
		$bResult = _SendMessage($hWnd, $TTM_HITTESTW, 0, $tHitTest, 0, "wparam", "struct*")
	Else
		Local $iHitTest = DllStructGetSize($tHitTest)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iHitTest, $tMemMap)
		_MemWrite($tMemMap, $tHitTest, $pMemory, $iHitTest)
		$bResult = _SendMessage($hWnd, $TTM_HITTESTW, 0, $pMemory, 0, "wparam", "ptr")
		_MemRead($tMemMap, $pMemory, $tHitTest, $iHitTest)
		_MemFree($tMemMap)
	EndIf
	DllStructSetData($tToolInfo, "Size", DllStructGetData($tHitTest, "Size"))
	DllStructSetData($tToolInfo, "Flags", DllStructGetData($tHitTest, "Flags"))
	DllStructSetData($tToolInfo, "hWnd", DllStructGetData($tHitTest, "hWnd"))
	DllStructSetData($tToolInfo, "ID", DllStructGetData($tHitTest, "ID"))
	DllStructSetData($tToolInfo, "Left", DllStructGetData($tHitTest, "Left"))
	DllStructSetData($tToolInfo, "Top", DllStructGetData($tHitTest, "Top"))
	DllStructSetData($tToolInfo, "Right", DllStructGetData($tHitTest, "Right"))
	DllStructSetData($tToolInfo, "Bottom", DllStructGetData($tHitTest, "Bottom"))
	DllStructSetData($tToolInfo, "hInst", DllStructGetData($tHitTest, "hInst"))
	DllStructSetData($tToolInfo, "Param", DllStructGetData($tHitTest, "Param"))
	Return _GUIToolTip_ToolToArray($hWnd, $tToolInfo, $bResult = True)
EndFunc   ;==>_GUIToolTip_HitTest

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIToolTip_NewToolRect($hWnd, $hTool, $iID, $iLeft, $iTop, $iRight, $iBottom)
	Local $tToolInfo = DllStructCreate($tagTOOLINFO)
	Local $iToolInfo = DllStructGetSize($tToolInfo)
	DllStructSetData($tToolInfo, "Size", $iToolInfo)
	DllStructSetData($tToolInfo, "hwnd", $hTool)
	DllStructSetData($tToolInfo, "ID", $iID)
	DllStructSetData($tToolInfo, "Left", $iLeft)
	DllStructSetData($tToolInfo, "Top", $iTop)
	DllStructSetData($tToolInfo, "Right", $iRight)
	DllStructSetData($tToolInfo, "Bottom", $iBottom)
	If _WinAPI_InProcess($hWnd, $__g_hTTLastWnd) Then
		_SendMessage($hWnd, $TTM_NEWTOOLRECTW, 0, $tToolInfo, 0, "wparam", "struct*")
	Else
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iToolInfo, $tMemMap)
		_MemWrite($tMemMap, $tToolInfo)
		_SendMessage($hWnd, $TTM_NEWTOOLRECTW, 0, $pMemory, 0, "wparam", "ptr")
		_MemFree($tMemMap)
	EndIf
EndFunc   ;==>_GUIToolTip_NewToolRect

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIToolTip_Pop($hWnd)
	_SendMessage($hWnd, $TTM_POP)
EndFunc   ;==>_GUIToolTip_Pop

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIToolTip_PopUp($hWnd)
	_SendMessage($hWnd, $TTM_POPUP)
EndFunc   ;==>_GUIToolTip_PopUp

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIToolTip_SetDelayTime($hWnd, $iDuration, $iTime)
	_SendMessage($hWnd, $TTM_SETDELAYTIME, $iDuration, $iTime)
EndFunc   ;==>_GUIToolTip_SetDelayTime

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIToolTip_SetMargin($hWnd, $iLeft, $iTop, $iRight, $iBottom)
	Local $tRECT = DllStructCreate($tagRECT)
	DllStructSetData($tRECT, "Left", $iLeft)
	DllStructSetData($tRECT, "Top", $iTop)
	DllStructSetData($tRECT, "Right", $iRight)
	DllStructSetData($tRECT, "Bottom", $iBottom)
	If _WinAPI_InProcess($hWnd, $__g_hTTLastWnd) Then
		_SendMessage($hWnd, $TTM_SETMARGIN, 0, $tRECT, 0, "wparam", "struct*")
	Else
		Local $iRect = DllStructGetSize($tRECT)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iRect, $tMemMap)
		_MemWrite($tMemMap, $tRECT)
		_SendMessage($hWnd, $TTM_SETMARGIN, 0, $pMemory, 0, "wparam", "ptr")
		_MemFree($tMemMap)
	EndIf
EndFunc   ;==>_GUIToolTip_SetMargin

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIToolTip_SetMaxTipWidth($hWnd, $iWidth)
	Return _SendMessage($hWnd, $TTM_SETMAXTIPWIDTH, 0, $iWidth)
EndFunc   ;==>_GUIToolTip_SetMaxTipWidth

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIToolTip_SetTipBkColor($hWnd, $iColor)
	_SendMessage($hWnd, $TTM_SETTIPBKCOLOR, $iColor)
EndFunc   ;==>_GUIToolTip_SetTipBkColor

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIToolTip_SetTipTextColor($hWnd, $iColor)
	_SendMessage($hWnd, $TTM_SETTIPTEXTCOLOR, $iColor)
EndFunc   ;==>_GUIToolTip_SetTipTextColor

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIToolTip_SetTitle($hWnd, $sTitle, $iIcon = 0)
	Local $iBuffer = StringLen($sTitle) + 1
	Local $tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
	$iBuffer *= 2
	DllStructSetData($tBuffer, "Text", $sTitle)
	Local $iRet
	If _WinAPI_InProcess($hWnd, $__g_hTTLastWnd) Then
		$iRet = _SendMessage($hWnd, $TTM_SETTITLEW, $iIcon, $tBuffer, 0, "wparam", "struct*")
	Else
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iBuffer, $tMemMap)
		_MemWrite($tMemMap, $tBuffer)
		$iRet = _SendMessage($hWnd, $TTM_SETTITLEW, $iIcon, $pMemory, 0, "wparam", "ptr")
		_MemFree($tMemMap)
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUIToolTip_SetTitle

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIToolTip_SetToolInfo($hWnd, $sText, $iID = 0, $iLeft = 0, $iTop = 0, $iRight = 0, $iBottom = 0, $iFlags = Default, $iParam = 0)
	If $iFlags = Default Then $iFlags = BitOR($TTF_SUBCLASS, $TTF_IDISHWND)
	Local $tBuffer = DllStructCreate("wchar Text[4096]")
	Local $tToolInfo = DllStructCreate($tagTOOLINFO)
	Local $iToolInfo = DllStructGetSize($tToolInfo)
	DllStructSetData($tBuffer, "Text", $sText)
	DllStructSetData($tToolInfo, "Size", $iToolInfo)
	DllStructSetData($tToolInfo, "Flags", $iFlags)
	DllStructSetData($tToolInfo, "hWnd", $hWnd)
	DllStructSetData($tToolInfo, "ID", $iID)
	DllStructSetData($tToolInfo, "Left", $iLeft)
	DllStructSetData($tToolInfo, "Top", $iTop)
	DllStructSetData($tToolInfo, "Right", $iRight)
	DllStructSetData($tToolInfo, "Bottom", $iBottom)
	DllStructSetData($tToolInfo, "Param", $iParam)
	If _WinAPI_InProcess($hWnd, $__g_hTTLastWnd) Then
		DllStructSetData($tToolInfo, "Text", DllStructGetPtr($tBuffer))
		_SendMessage($hWnd, $TTM_SETTOOLINFOW, 0, $tToolInfo, 0, "wparam", "struct*")
	Else
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iToolInfo + 4096, $tMemMap)
		Local $pText = $pMemory + $iToolInfo
		DllStructSetData($tToolInfo, "Text", $pText)
		_MemWrite($tMemMap, $tToolInfo, $pMemory, $iToolInfo)
		_MemWrite($tMemMap, $pText, $tBuffer, 4096)
		_SendMessage($hWnd, $TTM_SETTOOLINFOW, 0, $pMemory, 0, "wparam", "ptr")
		_MemFree($tMemMap)
	EndIf
EndFunc   ;==>_GUIToolTip_SetToolInfo

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIToolTip_SetWindowTheme($hWnd, $sStyle)
	Local $tBuffer = _WinAPI_MultiByteToWideChar($sStyle)
	If _WinAPI_InProcess($hWnd, $__g_hTTLastWnd) Then
		_SendMessage($hWnd, $TTM_SETWINDOWTHEME, 0, $tBuffer, 0, "wparam", "struct*")
	Else
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, 4096, $tMemMap)
		_MemWrite($tMemMap, $tBuffer)
		_SendMessage($hWnd, $TTM_SETWINDOWTHEME, 0, $pMemory, 0, "wparam", "ptr")
		_MemFree($tMemMap)
	EndIf
EndFunc   ;==>_GUIToolTip_SetWindowTheme

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIToolTip_ToolExists($hWnd)
	Return _SendMessage($hWnd, $TTM_GETCURRENTTOOL) <> 0
EndFunc   ;==>_GUIToolTip_ToolExists

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIToolTip_ToolToArray($hWnd, ByRef $tToolInfo, $iError)
	Local $aTool[10]

	$aTool[0] = DllStructGetData($tToolInfo, "Flags")
	$aTool[1] = DllStructGetData($tToolInfo, "hWnd")
	$aTool[2] = DllStructGetData($tToolInfo, "ID")
	$aTool[3] = DllStructGetData($tToolInfo, "Left")
	$aTool[4] = DllStructGetData($tToolInfo, "Top")
	$aTool[5] = DllStructGetData($tToolInfo, "Right")
	$aTool[6] = DllStructGetData($tToolInfo, "Bottom")
	$aTool[7] = DllStructGetData($tToolInfo, "hInst")
	$aTool[8] = _GUIToolTip_GetText($hWnd, $aTool[1], $aTool[2])
	$aTool[9] = DllStructGetData($tToolInfo, "Param")
	Return SetError($iError, 0, $aTool)
EndFunc   ;==>_GUIToolTip_ToolToArray

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIToolTip_TrackActivate($hWnd, $bActivate = True, $hTool = 0, $iID = 0)
	Local $tToolInfo = DllStructCreate($tagTOOLINFO)
	Local $iToolInfo = DllStructGetSize($tToolInfo)

	DllStructSetData($tToolInfo, "Size", $iToolInfo)
	DllStructSetData($tToolInfo, "hWnd", $hTool)
	DllStructSetData($tToolInfo, "ID", $iID)
	If _WinAPI_InProcess($hWnd, $__g_hTTLastWnd) Then
		_SendMessage($hWnd, $TTM_TRACKACTIVATE, $bActivate, $tToolInfo, 0, "wparam", "struct*")
	Else
		$iToolInfo = DllStructGetSize($tToolInfo)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iToolInfo, $tMemMap)
		_MemWrite($tMemMap, $tToolInfo)
		_SendMessage($hWnd, $TTM_TRACKACTIVATE, $bActivate, $pMemory, 0, "wparam", "ptr")
		_MemFree($tMemMap)
	EndIf
EndFunc   ;==>_GUIToolTip_TrackActivate

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIToolTip_TrackPosition($hWnd, $iX, $iY)
	_SendMessage($hWnd, $TTM_TRACKPOSITION, 0, _WinAPI_MakeLong($iX, $iY))
EndFunc   ;==>_GUIToolTip_TrackPosition

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIToolTip_Update($hWnd)
	_SendMessage($hWnd, $TTM_UPDATE)
EndFunc   ;==>_GUIToolTip_Update

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIToolTip_UpdateTipText($hWnd, $hTool, $iID, $sText)
	Local $iBuffer = StringLen($sText) + 1
	Local $tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
	$iBuffer *= 2
	Local $tToolInfo = DllStructCreate($tagTOOLINFO)
	Local $iToolInfo = DllStructGetSize($tToolInfo)
	DllStructSetData($tBuffer, "Text", $sText)
	DllStructSetData($tToolInfo, "Size", $iToolInfo)
	DllStructSetData($tToolInfo, "hWnd", $hTool)
	DllStructSetData($tToolInfo, "ID", $iID)
	If _WinAPI_InProcess($hWnd, $__g_hTTLastWnd) Then
		DllStructSetData($tToolInfo, "Text", DllStructGetPtr($tBuffer))
		_SendMessage($hWnd, $TTM_UPDATETIPTEXTW, 0, $tToolInfo, 0, "wparam", "struct*")
	Else
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iToolInfo + $iBuffer, $tMemMap)
		Local $pText = $pMemory + $iToolInfo
		DllStructSetData($tToolInfo, "Text", $pText)
		_MemWrite($tMemMap, $tToolInfo, $pMemory, $iToolInfo)
		_MemWrite($tMemMap, $tBuffer, $pText, $iBuffer)
		_SendMessage($hWnd, $TTM_UPDATETIPTEXTW, 0, $pMemory, 0, "wparam", "ptr")
		_MemFree($tMemMap)
	EndIf
EndFunc   ;==>_GUIToolTip_UpdateTipText
