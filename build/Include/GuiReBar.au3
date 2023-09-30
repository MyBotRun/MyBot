#include-once

#include "Memory.au3"
#include "RebarConstants.au3"
#include "SendMessage.au3"
#include "StructureConstants.au3"
#include "UDFGlobalID.au3"
#include "WinAPI.au3"

; #INDEX# =======================================================================================================================
; Title .........: Rebar
; AutoIt Version : 3.3.14.2
; Language ......: English
; Description ...: Functions that assist with Rebar control management.
;                  Rebar controls act as containers for child windows. An application assigns child windows,
;                  which are often other controls, to a rebar control band. Rebar controls contain one or more bands,
;                  and each band can have any combination of a gripper bar, a bitmap, a text label, and a child window.
;                  However, bands cannot contain more than one child window.
; Author(s) .....: Gary Frost
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================

Global $__g_hRBLastWnd
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $__REBARCONSTANT_ClassName = "ReBarWindow32"
Global Const $__REBARCONSTANT_TB_GETBUTTONSIZE = $__REBARCONSTANT_WM_USER + 58
Global Const $__REBARCONSTANT_TB_BUTTONCOUNT = $__REBARCONSTANT_WM_USER + 24
Global Const $__REBARCONSTANT_WS_CLIPCHILDREN = 0x02000000
Global Const $__REBARCONSTANT_WS_CLIPSIBLINGS = 0x04000000
Global Const $__REBARCONSTANT_CCS_TOP = 0x01
; ===============================================================================================================================

; #NO_DOC_FUNCTION# =============================================================================================================
; Not working/documented/implemented at this time
;
; _GUICtrlRebar_GetBandStyleNoVert
; _GUICtrlRebar_SetBandStyleNoVert
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _GUICtrlRebar_AddBand
; _GUICtrlRebar_AddToolBarBand
; _GUICtrlRebar_BeginDrag
; _GUICtrlRebar_Create
; _GUICtrlRebar_DeleteBand
; _GUICtrlRebar_Destroy
; _GUICtrlRebar_DragMove
; _GUICtrlRebar_EndDrag
; _GUICtrlRebar_GetBandBackColor
; _GUICtrlRebar_GetBandBorders
; _GUICtrlRebar_GetBandBordersEx
; _GUICtrlRebar_GetBandChildHandle
; _GUICtrlRebar_GetBandChildSize
; _GUICtrlRebar_GetBandCount
; _GUICtrlRebar_GetBandForeColor
; _GUICtrlRebar_GetBandHeaderSize
; _GUICtrlRebar_GetBandID
; _GUICtrlRebar_GetBandIdealSize
; _GUICtrlRebar_GetBandLParam
; _GUICtrlRebar_GetBandLength
; _GUICtrlRebar_GetBandMargins
; _GUICtrlRebar_GetBandMarginsEx
; _GUICtrlRebar_GetBandStyle
; _GUICtrlRebar_GetBandStyleBreak
; _GUICtrlRebar_GetBandStyleChildEdge
; _GUICtrlRebar_GetBandStyleFixedBMP
; _GUICtrlRebar_GetBandStyleFixedSize
; _GUICtrlRebar_GetBandStyleGripperAlways
; _GUICtrlRebar_GetBandStyleHidden
; _GUICtrlRebar_GetBandStyleHideTitle
; _GUICtrlRebar_GetBandStyleNoGripper
; _GUICtrlRebar_GetBandStyleTopAlign
; _GUICtrlRebar_GetBandStyleUseChevron
; _GUICtrlRebar_GetBandStyleVariableHeight
; _GUICtrlRebar_GetBandRect
; _GUICtrlRebar_GetBandRectEx
; _GUICtrlRebar_GetBandText
; _GUICtrlRebar_GetBarHeight
; _GUICtrlRebar_GetBarInfo
; _GUICtrlRebar_GetBKColor
; _GUICtrlRebar_GetColorScheme
; _GUICtrlRebar_GetRowCount
; _GUICtrlRebar_GetRowHeight
; _GUICtrlRebar_GetTextColor
; _GUICtrlRebar_GetToolTips
; _GUICtrlRebar_GetUnicodeFormat
; _GUICtrlRebar_HitTest
; _GUICtrlRebar_IDToIndex
; _GUICtrlRebar_MaximizeBand
; _GUICtrlRebar_MinimizeBand
; _GUICtrlRebar_MoveBand
; _GUICtrlRebar_SetBandBackColor
; _GUICtrlRebar_SetBandForeColor
; _GUICtrlRebar_SetBandHeaderSize
; _GUICtrlRebar_SetBandID
; _GUICtrlRebar_SetBandIdealSize
; _GUICtrlRebar_SetBandLength
; _GUICtrlRebar_SetBandLParam
; _GUICtrlRebar_SetBandStyle
; _GUICtrlRebar_SetBandStyleBreak
; _GUICtrlRebar_SetBandStyleChildEdge
; _GUICtrlRebar_SetBandStyleFixedBMP
; _GUICtrlRebar_SetBandStyleFixedSize
; _GUICtrlRebar_SetBandStyleGripperAlways
; _GUICtrlRebar_SetBandStyleHidden
; _GUICtrlRebar_SetBandStyleHideTitle
; _GUICtrlRebar_SetBandStyleNoGripper
; _GUICtrlRebar_SetBandStyleTopAlign
; _GUICtrlRebar_SetBandStyleUseChevron
; _GUICtrlRebar_SetBandStyleVariableHeight
; _GUICtrlRebar_SetBandText
; _GUICtrlRebar_SetBKColor
; _GUICtrlRebar_SetBarInfo
; _GUICtrlRebar_SetColorScheme
; _GUICtrlRebar_SetTextColor
; _GUICtrlRebar_SetToolTips
; _GUICtrlRebar_SetUnicodeFormat
; _GUICtrlRebar_ShowBand
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; $tagREBARINFO
; $tagRBHITTESTINFO
; __GUICtrlRebar_GetBandInfo
; __GUICtrlRebar_GetColorSchemeEx
; __GUICtrlRebar_SetBandInfo
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagREBARINFO
; Description ...: Contains information that describes rebar control characteristics
; Fields ........: cbSize         - Size of this structure, in bytes. Your application must fill this member before sending any messages that use the address of this structure as a parameter.
;                  fMask          - Flag values that describe characteristics of the rebar control. Currently, rebar controls support only one value:
;                  |$RBIM_IMAGELIST - The himl member is valid or must be filled
;                  himl           - Handle to an image list. The rebar control will use the specified image list to obtain images
; Author ........: Gary Frost
; Remarks .......:
; ===============================================================================================================================
Global Const $tagREBARINFO = "uint cbSize;uint fMask;handle himl"

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagRBHITTESTINFO
; Description ...: Contains information specific to a hit test operation
; Fields ........: X - Specifies the x-coordinate of the point
;                  Y - Specifies the y-coordinate of the point
;                  flags - Member that receives a flag value indicating the rebar band's component located at the point described by pt
;                  |This member will be one of the following:
;                  -
;                  |$RBHT_CAPTION - The point was in the rebar band's caption
;                  |$RBHT_CHEVRON - The point was in the rebar band's chevron (version 5.80 and greater)
;                  |$RBHT_CLIENT  - The point was in the rebar band's client area
;                  |$RBHT_GRABBER - The point was in the rebar band's gripper
;                  |$RBHT_NOWHERE - The point was not in a rebar band
;                  iBand - Member that receives the rebar band's index at the point described by pt
;                  |This value will be the zero-based index of the band, or -1 if no band was at the hit-tested point
; Author ........: Gary Frost
; Remarks .......:
; ===============================================================================================================================
Global Const $tagRBHITTESTINFO = $tagPOINT & ";uint flags;int iBand"

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_AddBand($hWndRebar, $hWndChild, $iMinWidth = 100, $iDefaultWidth = 100, $sText = "", $iIndex = -1, $iStyle = -1)
	Local $bUnicode = _GUICtrlRebar_GetUnicodeFormat($hWndRebar)

	If Not IsHWnd($hWndChild) Then $hWndChild = GUICtrlGetHandle($hWndChild)
	Local $tINFO = DllStructCreate($tagREBARBANDINFO)
	Local $iSize = DllStructGetSize($tINFO)

	If $iDefaultWidth < $iMinWidth Then $iDefaultWidth = $iMinWidth
	If $iStyle <> -1 Then
		$iStyle = BitOR($iStyle, $RBBS_CHILDEDGE, $RBBS_GRIPPERALWAYS)
	Else
		$iStyle = BitOR($RBBS_CHILDEDGE, $RBBS_GRIPPERALWAYS)
	EndIf
	;// Initialize band info used by the control
	DllStructSetData($tINFO, "cbSize", $iSize)
	DllStructSetData($tINFO, "fMask", BitOR($RBBIM_STYLE, $RBBIM_TEXT, $RBBIM_CHILD, $RBBIM_CHILDSIZE, $RBBIM_SIZE, $RBBIM_ID))
	DllStructSetData($tINFO, "fStyle", $iStyle)

	;// Set values unique to the band with the control
	Local $tRECT = _WinAPI_GetWindowRect($hWndChild)
	Local $iBottom = DllStructGetData($tRECT, "Bottom")
	Local $iTop = DllStructGetData($tRECT, "Top")
	Local $iBuffer = StringLen($sText) + 1
	Local $tBuffer
	If $bUnicode Then
		$tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
		$iBuffer *= 2
	Else
		$tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
	EndIf
	DllStructSetData($tBuffer, "Text", $sText)
	DllStructSetData($tINFO, "hwndChild", $hWndChild)
	DllStructSetData($tINFO, "cxMinChild", $iMinWidth)
	DllStructSetData($tINFO, "cyMinChild", $iBottom - $iTop)
	;// The default width should be set to some value wider than the text. The combo
	;// box itself will expand to fill the band.
	DllStructSetData($tINFO, "cx", $iDefaultWidth)
	DllStructSetData($tINFO, "wID", _GUICtrlRebar_GetBandCount($hWndRebar))

	Local $tMemMap
	Local $pMemory = _MemInit($hWndRebar, $iSize + $iBuffer, $tMemMap)
	Local $pText = $pMemory + $iSize
	DllStructSetData($tINFO, "lpText", $pText)
	_MemWrite($tMemMap, $tINFO, $pMemory, $iSize)
	_MemWrite($tMemMap, $tBuffer, $pText, $iBuffer)
	;// Add the band that has the combobox
	Local $iRet
	If $bUnicode Then
		$iRet = _SendMessage($hWndRebar, $RB_INSERTBANDW, $iIndex, $pMemory, 0, "wparam", "ptr") <> 0
	Else
		$iRet = _SendMessage($hWndRebar, $RB_INSERTBANDA, $iIndex, $pMemory, 0, "wparam", "ptr") <> 0
	EndIf
	_MemFree($tMemMap)
	Return $iRet
EndFunc   ;==>_GUICtrlRebar_AddBand

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_AddToolBarBand($hWndRebar, $hWndToolbar, $sText = "", $iIndex = -1, $iStyle = -1)
	Local $bUnicode = _GUICtrlRebar_GetUnicodeFormat($hWndRebar)

	Local $tINFO = DllStructCreate($tagREBARBANDINFO)
	Local $iSize = DllStructGetSize($tINFO)

	If $iStyle <> -1 Then
		$iStyle = BitOR($iStyle, $RBBS_CHILDEDGE, $RBBS_GRIPPERALWAYS)
	Else
		$iStyle = BitOR($RBBS_CHILDEDGE, $RBBS_GRIPPERALWAYS)
	EndIf

	;// Initialize band info used by the toolbar
	DllStructSetData($tINFO, "cbSize", $iSize)
	DllStructSetData($tINFO, "fMask", BitOR($RBBIM_STYLE, $RBBIM_TEXT, $RBBIM_CHILD, $RBBIM_CHILDSIZE, $RBBIM_SIZE, $RBBIM_ID))
	DllStructSetData($tINFO, "fStyle", $iStyle)

	;// Get the height of the toolbar.
	Local $iBtnSize = _SendMessage($hWndToolbar, $__REBARCONSTANT_TB_GETBUTTONSIZE)
	; Get the number of buttons contained in toolbar for calculation
	Local $iNumButtons = _SendMessage($hWndToolbar, $__REBARCONSTANT_TB_BUTTONCOUNT)
	Local $iDefaultWidth = $iNumButtons * _WinAPI_LoWord($iBtnSize)

	;// Set values unique to the band with the toolbar.
	Local $iBuffer = StringLen($sText) + 1
	Local $tBuffer
	If $bUnicode Then
		$tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
		$iBuffer *= 2
	Else
		$tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
	EndIf
	DllStructSetData($tBuffer, "Text", $sText)
	DllStructSetData($tINFO, "hwndChild", $hWndToolbar)
	DllStructSetData($tINFO, "cyChild", _WinAPI_HiWord($iBtnSize))
	DllStructSetData($tINFO, "cxMinChild", $iDefaultWidth)
	DllStructSetData($tINFO, "cyMinChild", _WinAPI_HiWord($iBtnSize))
	DllStructSetData($tINFO, "cx", $iDefaultWidth) ;// The default width is the width of the buttons.
	DllStructSetData($tINFO, "wID", _GUICtrlRebar_GetBandCount($hWndRebar))

	;// Add the band that has the toolbar.
	Local $tMemMap, $iRet
	Local $pMemory = _MemInit($hWndRebar, $iSize + $iBuffer, $tMemMap)
	Local $pText = $pMemory + $iSize
	DllStructSetData($tINFO, "lpText", $pText)
	_MemWrite($tMemMap, $tINFO, $pMemory, $iSize)
	_MemWrite($tMemMap, $tBuffer, $pText, $iBuffer)
	;// Add the band that has the combobox
	If $bUnicode Then
		$iRet = _SendMessage($hWndRebar, $RB_INSERTBANDW, $iIndex, $pMemory, 0, "wparam", "ptr") <> 0
	Else
		$iRet = _SendMessage($hWndRebar, $RB_INSERTBANDA, $iIndex, $pMemory, 0, "wparam", "ptr") <> 0
	EndIf
	_MemFree($tMemMap)
	Return $iRet
EndFunc   ;==>_GUICtrlRebar_AddToolBarBand

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_BeginDrag($hWnd, $iIndex, $iPos = -1)
	_SendMessage($hWnd, $RB_BEGINDRAG, $iIndex, $iPos, 0, "wparam", "dword")
EndFunc   ;==>_GUICtrlRebar_BeginDrag

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_Create($hWnd, $iStyles = 0x513)
	Local Const $ICC_BAR_CLASSES = 0x00000004; toolbar
	Local Const $ICC_COOL_CLASSES = 0x00000400; rebar

	Local $iStyle = BitOR($__UDFGUICONSTANT_WS_CHILD, $__UDFGUICONSTANT_WS_VISIBLE, $__REBARCONSTANT_WS_CLIPCHILDREN, $__REBARCONSTANT_WS_CLIPSIBLINGS)
	If $iStyles <> BitOR($__REBARCONSTANT_CCS_TOP, $RBS_VARHEIGHT) Then
		$iStyle = BitOR($iStyle, $iStyles)
	Else
		$iStyle = BitOR($iStyle, $__REBARCONSTANT_CCS_TOP, $RBS_VARHEIGHT)
	EndIf

	Local $tICCE = DllStructCreate('dword;dword')
	DllStructSetData($tICCE, 1, DllStructGetSize($tICCE))
	DllStructSetData($tICCE, 2, BitOR($ICC_BAR_CLASSES, $ICC_COOL_CLASSES))

	Local $aResult = DllCall('comctl32.dll', 'int', 'InitCommonControlsEx', 'struct*', $tICCE)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] = 0 Then Return SetError(-2, 0, 0)

	Local $nCtrlID = __UDF_GetNextGlobalID($hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Local $hReBar = _WinAPI_CreateWindowEx(0, $__REBARCONSTANT_ClassName, "", $iStyle, 0, 0, 0, 0, $hWnd, $nCtrlID)

	If @error Then Return SetError(-1, -1, 0)
	Return $hReBar
EndFunc   ;==>_GUICtrlRebar_Create

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_DeleteBand($hWnd, $iIndex)
	Return _SendMessage($hWnd, $RB_DELETEBAND, $iIndex) <> 0
EndFunc   ;==>_GUICtrlRebar_DeleteBand

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_Destroy(ByRef $hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__REBARCONSTANT_ClassName) Then Return SetError(2, 2, False)

	Local $iDestroyed = 0
	If _WinAPI_InProcess($hWnd, $__g_hRBLastWnd) Then
		Local $iRebarCount = _GUICtrlRebar_GetBandCount($hWnd)
		For $iIndex = $iRebarCount - 1 To 0 Step -1
			_GUICtrlRebar_DeleteBand($hWnd, $iIndex)
		Next
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
EndFunc   ;==>_GUICtrlRebar_Destroy

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_DragMove($hWnd, $iPos = -1)
	_SendMessage($hWnd, $RB_DRAGMOVE, 0, $iPos, 0, "wparam", "dword")
EndFunc   ;==>_GUICtrlRebar_DragMove

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_EndDrag($hWnd)
	_SendMessage($hWnd, $RB_ENDDRAG)
EndFunc   ;==>_GUICtrlRebar_EndDrag

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_GetBandBackColor($hWnd, $iIndex)
	Local $tINFO = __GUICtrlRebar_GetBandInfo($hWnd, $iIndex, $RBBIM_COLORS)
	If @error Then Return SetError(@error, @error, 0)
	Return DllStructGetData($tINFO, "clrBack")
EndFunc   ;==>_GUICtrlRebar_GetBandBackColor

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_GetBandBorders($hWnd, $iIndex)
	Local $tRECT = _GUICtrlRebar_GetBandBordersEx($hWnd, $iIndex)
	Local $aRect[4]
	$aRect[0] = DllStructGetData($tRECT, "Left")
	$aRect[1] = DllStructGetData($tRECT, "Top")
	$aRect[2] = DllStructGetData($tRECT, "Right")
	$aRect[3] = DllStructGetData($tRECT, "Bottom")
	Return $aRect
EndFunc   ;==>_GUICtrlRebar_GetBandBorders

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_GetBandBordersEx($hWnd, $iIndex)
	Local $tRECT = DllStructCreate($tagRECT)
	_SendMessage($hWnd, $RB_GETBANDBORDERS, $iIndex, $tRECT, 0, "uint", "struct*")
	Return $tRECT
EndFunc   ;==>_GUICtrlRebar_GetBandBordersEx

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_GetBandChildHandle($hWnd, $iIndex)
	Local $tINFO = __GUICtrlRebar_GetBandInfo($hWnd, $iIndex, $RBBIM_CHILD)
	If @error Then Return SetError(@error, @error, 0)
	Return DllStructGetData($tINFO, "hwndChild")
EndFunc   ;==>_GUICtrlRebar_GetBandChildHandle

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_GetBandChildSize($hWnd, $iIndex)
	Local $aSizes[5]
	Local $tINFO = __GUICtrlRebar_GetBandInfo($hWnd, $iIndex, $RBBIM_CHILDSIZE)
	If @error Then Return SetError(@error, @error, $aSizes)
	$aSizes[0] = DllStructGetData($tINFO, "cxMinChild")
	$aSizes[1] = DllStructGetData($tINFO, "cyMinChild")
	$aSizes[2] = DllStructGetData($tINFO, "cyChild")
	$aSizes[3] = DllStructGetData($tINFO, "cyMaxChild")
	$aSizes[4] = DllStructGetData($tINFO, "cyIntegral")

	Return $aSizes
EndFunc   ;==>_GUICtrlRebar_GetBandChildSize

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_GetBandCount($hWnd)
	Return _SendMessage($hWnd, $RB_GETBANDCOUNT)
EndFunc   ;==>_GUICtrlRebar_GetBandCount

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_GetBandForeColor($hWnd, $iIndex)
	Local $tINFO = __GUICtrlRebar_GetBandInfo($hWnd, $iIndex, $RBBIM_COLORS)
	If @error Then Return SetError(@error, @error, 0)
	Return DllStructGetData($tINFO, "clrFore")
EndFunc   ;==>_GUICtrlRebar_GetBandForeColor

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_GetBandHeaderSize($hWnd, $iIndex)
	Local $tINFO = __GUICtrlRebar_GetBandInfo($hWnd, $iIndex, $RBBIM_HEADERSIZE)
	If @error Then Return SetError(@error, @error, 0)
	Return DllStructGetData($tINFO, "cxHeader")
EndFunc   ;==>_GUICtrlRebar_GetBandHeaderSize

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_GetBandID($hWnd, $iIndex)
	Local $tINFO = __GUICtrlRebar_GetBandInfo($hWnd, $iIndex, $RBBIM_ID)
	If @error Then Return SetError(@error, @error, 0)
	Return DllStructGetData($tINFO, "wID")
EndFunc   ;==>_GUICtrlRebar_GetBandID

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_GetBandIdealSize($hWnd, $iIndex)
	Local $tINFO = __GUICtrlRebar_GetBandInfo($hWnd, $iIndex, $RBBIM_IDEALSIZE)
	If @error Then Return SetError(@error, @error, 0)
	Return DllStructGetData($tINFO, "cxIdeal")
EndFunc   ;==>_GUICtrlRebar_GetBandIdealSize

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUICtrlRebar_GetBandInfo
; Description ...: Get Ideal width of the band, in pixels.
; Syntax.........: __GUICtrlRebar_GetBandInfo ( $hWnd, $iIndex, $iMask )
; Parameters ....: $hWnd        - Handle to rebar control
;                  $iIndex      - Zero-based index of the band
;                  $iMask       - Flags that indicate which members of this structure are valid
; Return values .: Success      - $tagREBARBANDINFO structure
; Author ........: Gary Frost
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func __GUICtrlRebar_GetBandInfo($hWnd, $iIndex, $iMask)
	Local $tINFO = DllStructCreate($tagREBARBANDINFO)
	Local $iSize = DllStructGetSize($tINFO)
	DllStructSetData($tINFO, "cbSize", $iSize)
	DllStructSetData($tINFO, "fMask", $iMask)

	Local $iRet = _SendMessage($hWnd, $RB_GETBANDINFOW, $iIndex, $tINFO, 0, "wparam", "struct*")

	Return SetError($iRet = 0, 0, $tINFO)
EndFunc   ;==>__GUICtrlRebar_GetBandInfo

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_GetBandLParam($hWnd, $iIndex)
	Local $tINFO = __GUICtrlRebar_GetBandInfo($hWnd, $iIndex, $RBBIM_LPARAM)
	If @error Then Return SetError(@error, @error, 0)
	Return DllStructGetData($tINFO, "lParam")
EndFunc   ;==>_GUICtrlRebar_GetBandLParam

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_GetBandLength($hWnd, $iIndex)
	Local $tINFO = __GUICtrlRebar_GetBandInfo($hWnd, $iIndex, $RBBIM_SIZE)
	If @error Then Return SetError(@error, @error, 0)
	Return DllStructGetData($tINFO, "cx")
EndFunc   ;==>_GUICtrlRebar_GetBandLength

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_GetBandMargins($hWnd)
	Local $tMargins = _GUICtrlRebar_GetBandMarginsEx($hWnd)
	Local $aMargins[4]
	$aMargins[0] = DllStructGetData($tMargins, "cxLeftWidth")
	$aMargins[1] = DllStructGetData($tMargins, "cxRightWidth")
	$aMargins[2] = DllStructGetData($tMargins, "cyTopHeight")
	$aMargins[3] = DllStructGetData($tMargins, "cyBottomHeight")
	Return $aMargins
EndFunc   ;==>_GUICtrlRebar_GetBandMargins

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_GetBandMarginsEx($hWnd)
	Local $tMargins = DllStructCreate($tagMARGINS)

	_SendMessage($hWnd, $RB_GETBANDMARGINS, 0, $tMargins, 0, "wparam", "struct*")
	Return $tMargins
EndFunc   ;==>_GUICtrlRebar_GetBandMarginsEx

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_GetBandStyle($hWnd, $iIndex)
	Local $tINFO = __GUICtrlRebar_GetBandInfo($hWnd, $iIndex, $RBBIM_STYLE)
	If @error Then Return SetError(@error, @error, 0)
	Return DllStructGetData($tINFO, "fStyle")
EndFunc   ;==>_GUICtrlRebar_GetBandStyle

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_GetBandStyleBreak($hWnd, $iIndex)
	Return BitAND(_GUICtrlRebar_GetBandStyle($hWnd, $iIndex), $RBBS_BREAK) = $RBBS_BREAK
EndFunc   ;==>_GUICtrlRebar_GetBandStyleBreak

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_GetBandStyleChildEdge($hWnd, $iIndex)
	Return BitAND(_GUICtrlRebar_GetBandStyle($hWnd, $iIndex), $RBBS_CHILDEDGE) = $RBBS_CHILDEDGE
EndFunc   ;==>_GUICtrlRebar_GetBandStyleChildEdge

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_GetBandStyleFixedBMP($hWnd, $iIndex)
	Return BitAND(_GUICtrlRebar_GetBandStyle($hWnd, $iIndex), $RBBS_FIXEDBMP) = $RBBS_FIXEDBMP
EndFunc   ;==>_GUICtrlRebar_GetBandStyleFixedBMP

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_GetBandStyleFixedSize($hWnd, $iIndex)
	Return BitAND(_GUICtrlRebar_GetBandStyle($hWnd, $iIndex), $RBBS_FIXEDSIZE) = $RBBS_FIXEDSIZE
EndFunc   ;==>_GUICtrlRebar_GetBandStyleFixedSize

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_GetBandStyleGripperAlways($hWnd, $iIndex)
	Return BitAND(_GUICtrlRebar_GetBandStyle($hWnd, $iIndex), $RBBS_GRIPPERALWAYS) = $RBBS_GRIPPERALWAYS
EndFunc   ;==>_GUICtrlRebar_GetBandStyleGripperAlways

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_GetBandStyleHidden($hWnd, $iIndex)
	Return BitAND(_GUICtrlRebar_GetBandStyle($hWnd, $iIndex), $RBBS_HIDDEN) = $RBBS_HIDDEN
EndFunc   ;==>_GUICtrlRebar_GetBandStyleHidden

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_GetBandStyleHideTitle($hWnd, $iIndex)
	Return BitAND(_GUICtrlRebar_GetBandStyle($hWnd, $iIndex), $RBBS_HIDETITLE) = $RBBS_HIDETITLE
EndFunc   ;==>_GUICtrlRebar_GetBandStyleHideTitle

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_GetBandStyleNoGripper($hWnd, $iIndex)
	Return BitAND(_GUICtrlRebar_GetBandStyle($hWnd, $iIndex), $RBBS_NOGRIPPER) = $RBBS_NOGRIPPER
EndFunc   ;==>_GUICtrlRebar_GetBandStyleNoGripper

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _GUICtrlRebar_GetBandStyleNoVert
; Description ...: Determine if flag is set
; Syntax.........: _GUICtrlRebar_GetBandStyleNoVert ( $hWnd, $iIndex )
; Parameters ....: $hWnd        - Handle to rebar control
;                  $iIndex      - Zero-based index of the band
; Return values .:  True        - Flag is set (Don't show when vertical)
;                  False        - Flag not set
; Author ........: Gary Frost
; Modified.......:
; Remarks .......:
; Related .......: _GUICtrlRebar_SetBandStyleNoVert, _GUICtrlRebar_GetBandStyle
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _GUICtrlRebar_GetBandStyleNoVert($hWnd, $iIndex)
	Return BitAND(_GUICtrlRebar_GetBandStyle($hWnd, $iIndex), $RBBS_NOVERT) = $RBBS_NOVERT
EndFunc   ;==>_GUICtrlRebar_GetBandStyleNoVert

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_GetBandStyleTopAlign($hWnd, $iIndex)
	Return BitAND(_GUICtrlRebar_GetBandStyle($hWnd, $iIndex), $RBBS_TOPALIGN) = $RBBS_TOPALIGN
EndFunc   ;==>_GUICtrlRebar_GetBandStyleTopAlign

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_GetBandStyleUseChevron($hWnd, $iIndex)
	Return BitAND(_GUICtrlRebar_GetBandStyle($hWnd, $iIndex), $RBBS_USECHEVRON) = $RBBS_USECHEVRON
EndFunc   ;==>_GUICtrlRebar_GetBandStyleUseChevron

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_GetBandStyleVariableHeight($hWnd, $iIndex)
	Return BitAND(_GUICtrlRebar_GetBandStyle($hWnd, $iIndex), $RBBS_VARIABLEHEIGHT) = $RBBS_VARIABLEHEIGHT
EndFunc   ;==>_GUICtrlRebar_GetBandStyleVariableHeight

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_GetBandRect($hWnd, $iIndex)
	Local $tRECT = _GUICtrlRebar_GetBandRectEx($hWnd, $iIndex)
	Local $aRect[4]
	$aRect[0] = DllStructGetData($tRECT, "Left")
	$aRect[1] = DllStructGetData($tRECT, "Top")
	$aRect[2] = DllStructGetData($tRECT, "Right")
	$aRect[3] = DllStructGetData($tRECT, "Bottom")
	Return $aRect
EndFunc   ;==>_GUICtrlRebar_GetBandRect

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_GetBandRectEx($hWnd, $iIndex)
	Local $tRECT = DllStructCreate($tagRECT)
	_SendMessage($hWnd, $RB_GETRECT, $iIndex, $tRECT, 0, "uint", "struct*")
	Return $tRECT
EndFunc   ;==>_GUICtrlRebar_GetBandRectEx

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_GetBandText($hWnd, $iIndex)
	Local $bUnicode = _GUICtrlRebar_GetUnicodeFormat($hWnd)

	Local $tINFO = DllStructCreate($tagREBARBANDINFO)
	Local $iSize = DllStructGetSize($tINFO)
	Local $tBuffer
	Local $iBuffer = 4096
	If $bUnicode Then
		$tBuffer = DllStructCreate("wchar Buffer[4096]")
		$iBuffer *= 2
	Else
		$tBuffer = DllStructCreate("char Buffer[4096]")
	EndIf

	DllStructSetData($tINFO, "cbSize", $iSize)
	DllStructSetData($tINFO, "fMask", $RBBIM_TEXT)
	DllStructSetData($tINFO, "cch", $iBuffer)

	Local $tMemMap
	Local $pMemory = _MemInit($hWnd, $iSize + $iBuffer, $tMemMap)
	Local $pText = $pMemory + $iSize
	DllStructSetData($tINFO, "lpText", $pText)
	_MemWrite($tMemMap, $tINFO, $pMemory, $iSize)
	Local $iRet
	If $bUnicode Then
		$iRet = _SendMessage($hWnd, $RB_GETBANDINFOW, $iIndex, $pMemory, 0, "wparam", "ptr")
	Else
		$iRet = _SendMessage($hWnd, $RB_GETBANDINFOA, $iIndex, $pMemory, 0, "wparam", "ptr")
	EndIf
	_MemRead($tMemMap, $pText, $tBuffer, $iBuffer)
	_MemFree($tMemMap)

	Return SetError($iRet = 0, 0, DllStructGetData($tBuffer, "Buffer"))
EndFunc   ;==>_GUICtrlRebar_GetBandText

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_GetBarHeight($hWnd)
	Return _SendMessage($hWnd, $RB_GETBARHEIGHT)
EndFunc   ;==>_GUICtrlRebar_GetBarHeight

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_GetBarInfo($hWnd)
	Local $tINFO = DllStructCreate($tagREBARINFO)

	DllStructSetData($tINFO, "cbSize", DllStructGetSize($tINFO))
	DllStructSetData($tINFO, "fMask", $RBIM_IMAGELIST)
	Local $iRet = _SendMessage($hWnd, $RB_GETBARINFO, 0, $tINFO, 0, "wparam", "struct*")

	Return SetError($iRet = 0, 0, DllStructGetData($tINFO, "himl"))
EndFunc   ;==>_GUICtrlRebar_GetBarInfo

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_GetBKColor($hWnd)
	Return _SendMessage($hWnd, $RB_GETBKCOLOR)
EndFunc   ;==>_GUICtrlRebar_GetBKColor

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_GetColorScheme($hWnd)
	Local $aColors[2]
	Local $tColorScheme = __GUICtrlRebar_GetColorSchemeEx($hWnd)
	If @error Then Return SetError(@error, @error, $aColors)
	$aColors[0] = DllStructGetData($tColorScheme, "BtnHighlight")
	$aColors[1] = DllStructGetData($tColorScheme, "BtnShadow")
	Return $aColors
EndFunc   ;==>_GUICtrlRebar_GetColorScheme

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUICtrlRebar_GetColorSchemeEx
; Description ...: Retrieves the color scheme information from the rebar control
; Syntax.........: __GUICtrlRebar_GetColorSchemeEx ( $hWnd )
; Parameters ....: $hWnd       - Handle to rebar control
; Return values .: Success      -  $tagCOLORSCHEME structure
; Author ........: Gary Frost
; Modified.......:
; Remarks .......:
; Related .......: _GUICtrlRebar_GetColorScheme, $tagCOLORSCHEME
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func __GUICtrlRebar_GetColorSchemeEx($hWnd)
	Local $tColorScheme = DllStructCreate($tagCOLORSCHEME)
	DllStructSetData($tColorScheme, "Size", DllStructGetSize($tColorScheme))
	Local $iRet = _SendMessage($hWnd, $RB_GETCOLORSCHEME, 0, $tColorScheme, 0, "wparam", "struct*")
	Return SetError($iRet = 0, 0, $tColorScheme)
EndFunc   ;==>__GUICtrlRebar_GetColorSchemeEx

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_GetRowCount($hWnd)
	Return _SendMessage($hWnd, $RB_GETROWCOUNT)
EndFunc   ;==>_GUICtrlRebar_GetRowCount

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_GetRowHeight($hWnd, $iIndex)
	Return _SendMessage($hWnd, $RB_GETROWHEIGHT, $iIndex)
EndFunc   ;==>_GUICtrlRebar_GetRowHeight

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_GetTextColor($hWnd)
	Return _SendMessage($hWnd, $RB_GETTEXTCOLOR)
EndFunc   ;==>_GUICtrlRebar_GetTextColor

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_GetToolTips($hWnd)
	Return _SendMessage($hWnd, $RB_GETTOOLTIPS, 0, 0, 0, "wparam", "lparam", "hwnd")
EndFunc   ;==>_GUICtrlRebar_GetToolTips

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_GetUnicodeFormat($hWnd)
	Return _SendMessage($hWnd, $RB_GETUNICODEFORMAT) <> 0
EndFunc   ;==>_GUICtrlRebar_GetUnicodeFormat

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_HitTest($hWnd, $iX = -1, $iY = -1)
	Local $iMode = Opt("MouseCoordMode", 1)
	Local $aPos = MouseGetPos()
	Opt("MouseCoordMode", $iMode)
	Local $tPoint = DllStructCreate($tagPOINT)
	DllStructSetData($tPoint, "X", $aPos[0])
	DllStructSetData($tPoint, "Y", $aPos[1])
	DllCall("user32.dll", "bool", "ScreenToClient", "hwnd", $hWnd, "struct*", $tPoint)
	If @error Then Return SetError(@error, @extended, 0)

	If $iX = -1 Then $iX = DllStructGetData($tPoint, "X")
	If $iY = -1 Then $iY = DllStructGetData($tPoint, "Y")

	Local $tTest = DllStructCreate($tagRBHITTESTINFO)
	DllStructSetData($tTest, "X", $iX)
	DllStructSetData($tTest, "Y", $iY)
	Local $iTest = DllStructGetSize($tTest)
	Local $tMemMap, $aTest[6]
	Local $pMemory = _MemInit($hWnd, $iTest, $tMemMap)
	_MemWrite($tMemMap, $tTest, $pMemory, $iTest)
	$aTest[0] = _SendMessage($hWnd, $RB_HITTEST, 0, $pMemory, 0, "wparam", "ptr")
	_MemRead($tMemMap, $pMemory, $tTest, $iTest)
	_MemFree($tMemMap)
	Local $iFlags = DllStructGetData($tTest, "flags")
	$aTest[1] = BitAND($iFlags, $RBHT_NOWHERE) <> 0
	$aTest[2] = BitAND($iFlags, $RBHT_CLIENT) <> 0
	$aTest[3] = BitAND($iFlags, $RBHT_CAPTION) <> 0
	$aTest[4] = BitAND($iFlags, $RBHT_CHEVRON) <> 0
	$aTest[5] = BitAND($iFlags, $RBHT_GRABBER) <> 0
	Return $aTest
EndFunc   ;==>_GUICtrlRebar_HitTest

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_IDToIndex($hWnd, $iID)
	Return _SendMessage($hWnd, $RB_IDTOINDEX, $iID)
EndFunc   ;==>_GUICtrlRebar_IDToIndex

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_MaximizeBand($hWnd, $iIndex, $bIdeal = True)
	_SendMessage($hWnd, $RB_MAXIMIZEBAND, $iIndex, $bIdeal)
EndFunc   ;==>_GUICtrlRebar_MaximizeBand

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_MinimizeBand($hWnd, $iIndex)
	_SendMessage($hWnd, $RB_MINIMIZEBAND, $iIndex)
EndFunc   ;==>_GUICtrlRebar_MinimizeBand

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_MoveBand($hWnd, $iIndexFrom, $iIndexTo)
	If $iIndexTo > _GUICtrlRebar_GetBandCount($hWnd) - 1 Then Return False
	Return _SendMessage($hWnd, $RB_MOVEBAND, $iIndexFrom, $iIndexTo) <> 0
EndFunc   ;==>_GUICtrlRebar_MoveBand

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_SetBandBackColor($hWnd, $iIndex, $iColor)
	Local $tINFO = DllStructCreate($tagREBARBANDINFO)
	Local $iSize = DllStructGetSize($tINFO)

	DllStructSetData($tINFO, "cbSize", $iSize)
	DllStructSetData($tINFO, "fMask", $RBBIM_COLORS)
	DllStructSetData($tINFO, "clrBack", $iColor)
	DllStructGetData($tINFO, "clrFore", _GUICtrlRebar_GetBandForeColor($hWnd, $iIndex))

	Local $iRet, $tMemMap
	Local $pMemory = _MemInit($hWnd, $iSize, $tMemMap)
	_MemWrite($tMemMap, $tINFO, $pMemory, $iSize)
	If _GUICtrlRebar_GetUnicodeFormat($hWnd) Then
		$iRet = _SendMessage($hWnd, $RB_SETBANDINFOW, $iIndex, $pMemory, 0, "wparam", "ptr") <> 0
	Else
		$iRet = _SendMessage($hWnd, $RB_SETBANDINFOA, $iIndex, $pMemory, 0, "wparam", "ptr") <> 0
	EndIf
	_MemFree($tMemMap)
	Return $iRet
EndFunc   ;==>_GUICtrlRebar_SetBandBackColor

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_SetBandForeColor($hWnd, $iIndex, $iColor)
	Local $tINFO = DllStructCreate($tagREBARBANDINFO)
	Local $iSize = DllStructGetSize($tINFO)

	DllStructSetData($tINFO, "cbSize", $iSize)
	DllStructSetData($tINFO, "fMask", $RBBIM_COLORS)
	DllStructSetData($tINFO, "clrFore", $iColor)
	DllStructSetData($tINFO, "clrBack", _GUICtrlRebar_GetBandBackColor($hWnd, $iIndex))

	Local $iRet, $tMemMap
	Local $pMemory = _MemInit($hWnd, $iSize, $tMemMap)
	_MemWrite($tMemMap, $tINFO, $pMemory, $iSize)
	If _GUICtrlRebar_GetUnicodeFormat($hWnd) Then
		$iRet = _SendMessage($hWnd, $RB_SETBANDINFOW, $iIndex, $pMemory, 0, "wparam", "ptr") <> 0
	Else
		$iRet = _SendMessage($hWnd, $RB_SETBANDINFOA, $iIndex, $pMemory, 0, "wparam", "ptr") <> 0
	EndIf
	_MemFree($tMemMap)
	Return $iRet
EndFunc   ;==>_GUICtrlRebar_SetBandForeColor

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_SetBandHeaderSize($hWnd, $iIndex, $iNewSize)
	Return __GUICtrlRebar_SetBandInfo($hWnd, $iIndex, $RBBIM_HEADERSIZE, "cxHeader", $iNewSize)
EndFunc   ;==>_GUICtrlRebar_SetBandHeaderSize

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_SetBandID($hWnd, $iIndex, $iID)
	Return __GUICtrlRebar_SetBandInfo($hWnd, $iIndex, $RBBIM_ID, "wID", $iID)
EndFunc   ;==>_GUICtrlRebar_SetBandID

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_SetBandIdealSize($hWnd, $iIndex, $iNewSize)
	Return __GUICtrlRebar_SetBandInfo($hWnd, $iIndex, $RBBIM_IDEALSIZE, "cxIdeal", $iNewSize)
EndFunc   ;==>_GUICtrlRebar_SetBandIdealSize

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUICtrlRebar_SetBandInfo
; Description ...: Set Ideal width of the band, in pixels.
; Syntax.........: __GUICtrlRebar_SetBandInfo ( $hWnd, $iIndex, $iMask, $sName, $iData )
; Parameters ....: $hWnd     - Handle to rebar control
;                  $iIndex   - Zero-based index of the band
;                  $iMask    - Flags that indicate which members of this structure are valid or must be filled
;                  $sName    - Name of the member
;                  $iData    - Data for the member
; Return values .: Success   - True
;                  Failure   - False
; Author ........: Gary Frost
; Modified.......:
; Remarks .......:
; Related .......: __GUICtrlRebar_GetBandInfo
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func __GUICtrlRebar_SetBandInfo($hWnd, $iIndex, $iMask, $sName, $iData)
	Local $tINFO = DllStructCreate($tagREBARBANDINFO)
	Local $iSize = DllStructGetSize($tINFO)

	DllStructSetData($tINFO, "cbSize", $iSize)
	DllStructSetData($tINFO, "fMask", $iMask)
	DllStructSetData($tINFO, $sName, $iData)

	Local $iRet, $tMemMap
	Local $pMemory = _MemInit($hWnd, $iSize, $tMemMap)
	_MemWrite($tMemMap, $tINFO, $pMemory, $iSize)
	If _GUICtrlRebar_GetUnicodeFormat($hWnd) Then
		$iRet = _SendMessage($hWnd, $RB_SETBANDINFOW, $iIndex, $pMemory, 0, "wparam", "ptr") <> 0
	Else
		$iRet = _SendMessage($hWnd, $RB_SETBANDINFOA, $iIndex, $pMemory, 0, "wparam", "ptr") <> 0
	EndIf
	_MemFree($tMemMap)
	Return $iRet
EndFunc   ;==>__GUICtrlRebar_SetBandInfo

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_SetBandLength($hWnd, $iIndex, $iLength)
	Return __GUICtrlRebar_SetBandInfo($hWnd, $iIndex, $RBBIM_SIZE, "cx", $iLength)
EndFunc   ;==>_GUICtrlRebar_SetBandLength

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_SetBandLParam($hWnd, $iIndex, $lParam)
	Return __GUICtrlRebar_SetBandInfo($hWnd, $iIndex, $RBBIM_LPARAM, "lParam", $lParam)
EndFunc   ;==>_GUICtrlRebar_SetBandLParam

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_SetBandStyle($hWnd, $iIndex, $iStyle)
	Return __GUICtrlRebar_SetBandInfo($hWnd, $iIndex, $RBBIM_STYLE, "fStyle", $iStyle)
EndFunc   ;==>_GUICtrlRebar_SetBandStyle

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_SetBandStyleBreak($hWnd, $iIndex, $bEnabled = True)
	If $bEnabled Then
		Return __GUICtrlRebar_SetBandInfo($hWnd, $iIndex, $RBBIM_STYLE, "fStyle", BitOR(_GUICtrlRebar_GetBandStyle($hWnd, $iIndex), $RBBS_BREAK))
	Else
		Return __GUICtrlRebar_SetBandInfo($hWnd, $iIndex, $RBBIM_STYLE, "fStyle", BitXOR(_GUICtrlRebar_GetBandStyle($hWnd, $iIndex), $RBBS_BREAK))
	EndIf
EndFunc   ;==>_GUICtrlRebar_SetBandStyleBreak

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_SetBandStyleChildEdge($hWnd, $iIndex, $bEnabled = True)
	If $bEnabled Then
		Return __GUICtrlRebar_SetBandInfo($hWnd, $iIndex, $RBBIM_STYLE, "fStyle", BitOR(_GUICtrlRebar_GetBandStyle($hWnd, $iIndex), $RBBS_CHILDEDGE))
	Else
		Return __GUICtrlRebar_SetBandInfo($hWnd, $iIndex, $RBBIM_STYLE, "fStyle", BitXOR(_GUICtrlRebar_GetBandStyle($hWnd, $iIndex), $RBBS_CHILDEDGE))
	EndIf
EndFunc   ;==>_GUICtrlRebar_SetBandStyleChildEdge

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_SetBandStyleFixedBMP($hWnd, $iIndex, $bEnabled = True)
	If $bEnabled Then
		Return __GUICtrlRebar_SetBandInfo($hWnd, $iIndex, $RBBIM_STYLE, "fStyle", BitOR(_GUICtrlRebar_GetBandStyle($hWnd, $iIndex), $RBBS_FIXEDBMP))
	Else
		Return __GUICtrlRebar_SetBandInfo($hWnd, $iIndex, $RBBIM_STYLE, "fStyle", BitXOR(_GUICtrlRebar_GetBandStyle($hWnd, $iIndex), $RBBS_FIXEDBMP))
	EndIf
EndFunc   ;==>_GUICtrlRebar_SetBandStyleFixedBMP

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_SetBandStyleFixedSize($hWnd, $iIndex, $bEnabled = True)
	If $bEnabled Then
		Return __GUICtrlRebar_SetBandInfo($hWnd, $iIndex, $RBBIM_STYLE, "fStyle", BitOR(_GUICtrlRebar_GetBandStyle($hWnd, $iIndex), $RBBS_FIXEDSIZE))
	Else
		Return __GUICtrlRebar_SetBandInfo($hWnd, $iIndex, $RBBIM_STYLE, "fStyle", BitXOR(_GUICtrlRebar_GetBandStyle($hWnd, $iIndex), $RBBS_FIXEDSIZE))
	EndIf
EndFunc   ;==>_GUICtrlRebar_SetBandStyleFixedSize

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_SetBandStyleGripperAlways($hWnd, $iIndex, $bEnabled = True)
	If $bEnabled Then
		Return __GUICtrlRebar_SetBandInfo($hWnd, $iIndex, $RBBIM_STYLE, "fStyle", BitOR(_GUICtrlRebar_GetBandStyle($hWnd, $iIndex), $RBBS_GRIPPERALWAYS))
	Else
		Return __GUICtrlRebar_SetBandInfo($hWnd, $iIndex, $RBBIM_STYLE, "fStyle", BitXOR(_GUICtrlRebar_GetBandStyle($hWnd, $iIndex), $RBBS_GRIPPERALWAYS))
	EndIf
EndFunc   ;==>_GUICtrlRebar_SetBandStyleGripperAlways

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_SetBandStyleHidden($hWnd, $iIndex, $bEnabled = True)
	If $bEnabled Then
		Return __GUICtrlRebar_SetBandInfo($hWnd, $iIndex, $RBBIM_STYLE, "fStyle", BitOR(_GUICtrlRebar_GetBandStyle($hWnd, $iIndex), $RBBS_HIDDEN))
	Else
		Return __GUICtrlRebar_SetBandInfo($hWnd, $iIndex, $RBBIM_STYLE, "fStyle", BitXOR(_GUICtrlRebar_GetBandStyle($hWnd, $iIndex), $RBBS_HIDDEN))
	EndIf
EndFunc   ;==>_GUICtrlRebar_SetBandStyleHidden

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_SetBandStyleHideTitle($hWnd, $iIndex, $bEnabled = True)
	If $bEnabled Then
		Return __GUICtrlRebar_SetBandInfo($hWnd, $iIndex, $RBBIM_STYLE, "fStyle", BitOR(_GUICtrlRebar_GetBandStyle($hWnd, $iIndex), $RBBS_HIDETITLE))
	Else
		Return __GUICtrlRebar_SetBandInfo($hWnd, $iIndex, $RBBIM_STYLE, "fStyle", BitXOR(_GUICtrlRebar_GetBandStyle($hWnd, $iIndex), $RBBS_HIDETITLE))
	EndIf
EndFunc   ;==>_GUICtrlRebar_SetBandStyleHideTitle

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_SetBandStyleNoGripper($hWnd, $iIndex, $bEnabled = True)
	If $bEnabled Then
		Return __GUICtrlRebar_SetBandInfo($hWnd, $iIndex, $RBBIM_STYLE, "fStyle", BitOR(_GUICtrlRebar_GetBandStyle($hWnd, $iIndex), $RBBS_NOGRIPPER))
	Else
		Return __GUICtrlRebar_SetBandInfo($hWnd, $iIndex, $RBBIM_STYLE, "fStyle", BitXOR(_GUICtrlRebar_GetBandStyle($hWnd, $iIndex), $RBBS_NOGRIPPER))
	EndIf
EndFunc   ;==>_GUICtrlRebar_SetBandStyleNoGripper

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _GUICtrlRebar_SetBandStyleNoVert
; Description ...: Set whether to Don't show when vertical
; Syntax.........: _GUICtrlRebar_SetBandStyleNoVert ( $hWnd, $iIndex [, $bEnabled = True] )
; Parameters ....: $hWnd        - Handle to rebar control
;                  $iIndex      - Zero-based index of the band
;                  $bEnabled    - If True the item state is set, otherwise it is not set
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Gary Frost
; Modified.......:
; Remarks .......:
; Related .......: _GUICtrlRebar_GetBandStyleNoVert, _GUICtrlRebar_SetBandStyle
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _GUICtrlRebar_SetBandStyleNoVert($hWnd, $iIndex, $bEnabled = True)
	If $bEnabled Then
		Return __GUICtrlRebar_SetBandInfo($hWnd, $iIndex, $RBBIM_STYLE, "fStyle", BitOR(_GUICtrlRebar_GetBandStyle($hWnd, $iIndex), $RBBS_NOVERT))
	Else
		Return __GUICtrlRebar_SetBandInfo($hWnd, $iIndex, $RBBIM_STYLE, "fStyle", BitXOR(_GUICtrlRebar_GetBandStyle($hWnd, $iIndex), $RBBS_NOVERT))
	EndIf
EndFunc   ;==>_GUICtrlRebar_SetBandStyleNoVert

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_SetBandStyleTopAlign($hWnd, $iIndex, $bEnabled = True)
	If $bEnabled Then
		Return __GUICtrlRebar_SetBandInfo($hWnd, $iIndex, $RBBIM_STYLE, "fStyle", BitOR(_GUICtrlRebar_GetBandStyle($hWnd, $iIndex), $RBBS_TOPALIGN))
	Else
		Return __GUICtrlRebar_SetBandInfo($hWnd, $iIndex, $RBBIM_STYLE, "fStyle", BitXOR(_GUICtrlRebar_GetBandStyle($hWnd, $iIndex), $RBBS_TOPALIGN))
	EndIf
EndFunc   ;==>_GUICtrlRebar_SetBandStyleTopAlign

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_SetBandStyleUseChevron($hWnd, $iIndex, $bEnabled = True)
	If $bEnabled Then
		Return __GUICtrlRebar_SetBandInfo($hWnd, $iIndex, $RBBIM_STYLE, "fStyle", BitOR(_GUICtrlRebar_GetBandStyle($hWnd, $iIndex), $RBBS_USECHEVRON))
	Else
		Return __GUICtrlRebar_SetBandInfo($hWnd, $iIndex, $RBBIM_STYLE, "fStyle", BitXOR(_GUICtrlRebar_GetBandStyle($hWnd, $iIndex), $RBBS_USECHEVRON))
	EndIf
EndFunc   ;==>_GUICtrlRebar_SetBandStyleUseChevron

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_SetBandStyleVariableHeight($hWnd, $iIndex, $bEnabled = True)
	If $bEnabled Then
		Return __GUICtrlRebar_SetBandInfo($hWnd, $iIndex, $RBBIM_STYLE, "fStyle", BitOR(_GUICtrlRebar_GetBandStyle($hWnd, $iIndex), $RBBS_VARIABLEHEIGHT))
	Else
		Return __GUICtrlRebar_SetBandInfo($hWnd, $iIndex, $RBBIM_STYLE, "fStyle", BitXOR(_GUICtrlRebar_GetBandStyle($hWnd, $iIndex), $RBBS_VARIABLEHEIGHT))
	EndIf
EndFunc   ;==>_GUICtrlRebar_SetBandStyleVariableHeight

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_SetBandText($hWnd, $iIndex, $sText)
	Local $bUnicode = _GUICtrlRebar_GetUnicodeFormat($hWnd)

	Local $tINFO = DllStructCreate($tagREBARBANDINFO)
	Local $iSize = DllStructGetSize($tINFO)
	Local $iBuffer = StringLen($sText) + 1
	Local $tBuffer
	If $bUnicode Then
		$tBuffer = DllStructCreate("wchar Buffer[" & $iBuffer & "]")
		$iBuffer *= 2
	Else
		$tBuffer = DllStructCreate("char Buffer[" & $iBuffer & "]")
	EndIf

	DllStructSetData($tBuffer, "Buffer", $sText)
	DllStructSetData($tINFO, "cbSize", $iSize)
	DllStructSetData($tINFO, "fMask", $RBBIM_TEXT)
	DllStructSetData($tINFO, "cch", $iBuffer)

	Local $iRet, $tMemMap
	Local $pMemory = _MemInit($hWnd, $iSize + $iBuffer, $tMemMap)
	Local $pText = $pMemory + $iSize
	DllStructSetData($tINFO, "lpText", $pText)
	_MemWrite($tMemMap, $tINFO, $pMemory, $iSize)
	_MemWrite($tMemMap, $tBuffer, $pText, $iBuffer)
	If $bUnicode Then
		$iRet = _SendMessage($hWnd, $RB_SETBANDINFOW, $iIndex, $pMemory, 0, "wparam", "ptr")
	Else
		$iRet = _SendMessage($hWnd, $RB_SETBANDINFOA, $iIndex, $pMemory, 0, "wparam", "ptr")
	EndIf
	_MemFree($tMemMap)

	Return $iRet <> 0
EndFunc   ;==>_GUICtrlRebar_SetBandText

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_SetBKColor($hWnd, $iColor)
	Return _SendMessage($hWnd, $RB_SETBKCOLOR, 0, $iColor)
EndFunc   ;==>_GUICtrlRebar_SetBKColor

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_SetBarInfo($hWnd, $hIml)
	Local $tINFO = DllStructCreate($tagREBARINFO)

	DllStructSetData($tINFO, "cbSize", DllStructGetSize($tINFO))
	DllStructSetData($tINFO, "fMask", $RBIM_IMAGELIST)
	DllStructSetData($tINFO, "himl", $hIml)
	Return _SendMessage($hWnd, $RB_SETBARINFO, 0, $tINFO, 0, "wparam", "struct*") <> 0
EndFunc   ;==>_GUICtrlRebar_SetBarInfo

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_SetColorScheme($hWnd, $iBtnHighlight, $iBtnShadow)
	Local $tINFO = DllStructCreate($tagCOLORSCHEME)
	Local $iSize = DllStructGetSize($tINFO)

	DllStructSetData($tINFO, "Size", $iSize)
	DllStructSetData($tINFO, "BtnHighlight", $iBtnHighlight)
	DllStructSetData($tINFO, "BtnShadow", $iBtnShadow)

	Local $tMemMap
	Local $pMemory = _MemInit($hWnd, $iSize, $tMemMap)
	_MemWrite($tMemMap, $tINFO, $pMemory, $iSize)
	_SendMessage($hWnd, $RB_SETCOLORSCHEME, 0, $pMemory, 0, "wparam", "ptr")
	_MemFree($tMemMap)
EndFunc   ;==>_GUICtrlRebar_SetColorScheme

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_SetTextColor($hWnd, $iColor)
	Return _SendMessage($hWnd, $RB_SETTEXTCOLOR, 0, $iColor)
EndFunc   ;==>_GUICtrlRebar_SetTextColor

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_SetToolTips($hWnd, $hToolTip)
	_SendMessage($hWnd, $RB_SETTOOLTIPS, $hToolTip, 0, 0, "hwnd")
EndFunc   ;==>_GUICtrlRebar_SetToolTips

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_SetUnicodeFormat($hWnd, $bUnicode = True)
	Return _SendMessage($hWnd, $RB_SETUNICODEFORMAT, $bUnicode)
EndFunc   ;==>_GUICtrlRebar_SetUnicodeFormat

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRebar_ShowBand($hWnd, $iIndex, $bShow = True)
	Return _SendMessage($hWnd, $RB_SHOWBAND, $iIndex, $bShow) <> 0
EndFunc   ;==>_GUICtrlRebar_ShowBand
