#include-once

#include "DateTimeConstants.au3"
#include "Memory.au3"
#include "SendMessage.au3"
#include "StructureConstants.au3"
#include "UDFGlobalID.au3"
#include "WinAPI.au3"

; #INDEX# =======================================================================================================================
; Title .........: MonthCalendar
; AutoIt Version : 3.3.14.2
; Language ......: English
; Description ...: Functions that assist with MonthCalendar control management.
;                  A month calendar control implements a calendar-like user  interface.  This  provides  the  user  with  a  very
;                  intuitive and recognizable method of entering or selecting a date.  The control also provides the  application
;                  with the means to obtain and set the date information in the control using existing data types.
; Author(s) .....: Paul Campbell (PaulIA), Gary Frost (gafrost)
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
Global $__g_hMCLastWnd

; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $__MONTHCALCONSTANT_ClassName = "SysMonthCal32"
Global Const $__MONTHCALCONSTANT_SWP_NOZORDER = 0x0004
; ===============================================================================================================================$aArray[$i]

; #CURRENT# =====================================================================================================================
; _GUICtrlMonthCal_Create
; _GUICtrlMonthCal_Destroy
; _GUICtrlMonthCal_GetCalendarBorder
; _GUICtrlMonthCal_GetCalendarCount
; _GUICtrlMonthCal_GetColor
; _GUICtrlMonthCal_GetColorArray
; _GUICtrlMonthCal_GetCurSel
; _GUICtrlMonthCal_GetCurSelStr
; _GUICtrlMonthCal_GetFirstDOW
; _GUICtrlMonthCal_GetFirstDOWStr
; _GUICtrlMonthCal_GetMaxSelCount
; _GUICtrlMonthCal_GetMaxTodayWidth
; _GUICtrlMonthCal_GetMinReqHeight
; _GUICtrlMonthCal_GetMinReqRect
; _GUICtrlMonthCal_GetMinReqRectArray
; _GUICtrlMonthCal_GetMinReqWidth
; _GUICtrlMonthCal_GetMonthDelta
; _GUICtrlMonthCal_GetMonthRange
; _GUICtrlMonthCal_GetMonthRangeMax
; _GUICtrlMonthCal_GetMonthRangeMaxStr
; _GUICtrlMonthCal_GetMonthRangeMin
; _GUICtrlMonthCal_GetMonthRangeMinStr
; _GUICtrlMonthCal_GetMonthRangeSpan
; _GUICtrlMonthCal_GetRange
; _GUICtrlMonthCal_GetRangeMax
; _GUICtrlMonthCal_GetRangeMaxStr
; _GUICtrlMonthCal_GetRangeMin
; _GUICtrlMonthCal_GetRangeMinStr
; _GUICtrlMonthCal_GetSelRange
; _GUICtrlMonthCal_GetSelRangeMax
; _GUICtrlMonthCal_GetSelRangeMaxStr
; _GUICtrlMonthCal_GetSelRangeMin
; _GUICtrlMonthCal_GetSelRangeMinStr
; _GUICtrlMonthCal_GetToday
; _GUICtrlMonthCal_GetTodayStr
; _GUICtrlMonthCal_GetUnicodeFormat
; _GUICtrlMonthCal_HitTest
; _GUICtrlMonthCal_SetCalendarBorder
; _GUICtrlMonthCal_SetColor
; _GUICtrlMonthCal_SetCurSel
; _GUICtrlMonthCal_SetDayState
; _GUICtrlMonthCal_SetFirstDOW
; _GUICtrlMonthCal_SetMaxSelCount
; _GUICtrlMonthCal_SetMonthDelta
; _GUICtrlMonthCal_SetRange
; _GUICtrlMonthCal_SetSelRange
; _GUICtrlMonthCal_SetToday
; _GUICtrlMonthCal_SetUnicodeFormat
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; __GUICtrlMonthCal_Resize
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlMonthCal_Create($hWnd, $iX, $iY, $iStyle = 0x00000000, $iExStyle = 0x00000000)
	If Not IsHWnd($hWnd) Then
		; Invalid Window handle for _GUICtrlMonthCal_Create 1st parameter
		Return SetError(1, 0, 0)
	EndIf

	Local $hMonCal, $nCtrlID

	If $iStyle = -1 Then $iStyle = 0x00000000
	If $iExStyle = -1 Then $iExStyle = 0x00000000

	$iStyle = BitOR($iStyle, $__UDFGUICONSTANT_WS_CHILD, $__UDFGUICONSTANT_WS_VISIBLE)

	$nCtrlID = __UDF_GetNextGlobalID($hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	$hMonCal = _WinAPI_CreateWindowEx($iExStyle, $__MONTHCALCONSTANT_ClassName, "", $iStyle, $iX, $iY, 0, 0, $hWnd, $nCtrlID)
	__GUICtrlMonthCal_Resize($hMonCal, $iX, $iY)
	Return $hMonCal
EndFunc   ;==>_GUICtrlMonthCal_Create

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMonthCal_Destroy(ByRef $hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__MONTHCALCONSTANT_ClassName) Then Return SetError(2, 2, False)

	Local $iDestroyed = 0
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hMCLastWnd) Then
			Local $nCtrlID = _WinAPI_GetDlgCtrlID($hWnd)
			Local $hParent = _WinAPI_GetParent($hWnd)
			$iDestroyed = _WinAPI_DestroyWindow($hWnd)
			Local $iRet = __UDF_FreeGlobalID($hParent, $nCtrlID)
			If Not $iRet Then
				; can check for errors here if needed, for debug
			EndIf
		Else
			; Not Allowed to Delete Other Applications Month Calendar(s) Control(s)
			Return SetError(1, 1, False)
		EndIf
	Else
		$iDestroyed = GUICtrlDelete($hWnd)
	EndIf
	If $iDestroyed Then $hWnd = 0
	Return $iDestroyed <> 0
EndFunc   ;==>_GUICtrlMonthCal_Destroy

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMonthCal_GetCalendarBorder($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $MCM_GETCALENDARBORDER)
	Else
		Return GUICtrlSendMsg($hWnd, $MCM_GETCALENDARBORDER, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlMonthCal_GetCalendarBorder

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMonthCal_GetCalendarCount($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $MCM_GETCALENDARCOUNT)
	Else
		Return GUICtrlSendMsg($hWnd, $MCM_GETCALENDARCOUNT, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlMonthCal_GetCalendarCount

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlMonthCal_GetColor($hWnd, $iIndex)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $MCM_GETCOLOR, $iIndex)
	Else
		Return GUICtrlSendMsg($hWnd, $MCM_GETCOLOR, $iIndex, 0)
	EndIf
EndFunc   ;==>_GUICtrlMonthCal_GetColor

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMonthCal_GetColorArray($hWnd, $iColor)
	Local $iRet, $a_Result[4]
	$a_Result[0] = 3
	If IsHWnd($hWnd) Then
		$iRet = _SendMessage($hWnd, $MCM_GETCOLOR, $iColor)
	Else
		$iRet = GUICtrlSendMsg($hWnd, $MCM_GETCOLOR, $iColor, 0)
	EndIf
	If $iRet = -1 Then Return SetError(1, $iRet, 0)

	$a_Result[1] = Int($iRet) ; COLORREF rgbcolor
	$a_Result[2] = "0x" & Hex(String($iRet), 6) ; Hex BGR color
	$a_Result[3] = Hex(String($iRet), 6)
	$a_Result[3] = "0x" & StringMid($a_Result[3], 5, 2) & StringMid($a_Result[3], 3, 2) & StringMid($a_Result[3], 1, 2) ; Hex RGB Color
	Return $a_Result
EndFunc   ;==>_GUICtrlMonthCal_GetColorArray

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlMonthCal_GetCurSel($hWnd)
	Local $tBuffer = DllStructCreate($tagSYSTEMTIME)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hMCLastWnd) Then
			_SendMessage($hWnd, $MCM_GETCURSEL, 0, $tBuffer, 0, "wparam", "struct*")
		Else
			Local $iBuffer = DllStructGetSize($tBuffer)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iBuffer, $tMemMap)
			_SendMessage($hWnd, $MCM_GETCURSEL, 0, $pMemory, 0, "wparam", "ptr")
			_MemRead($tMemMap, $pMemory, $tBuffer, $iBuffer)
			_MemFree($tMemMap)
		EndIf
	Else
		GUICtrlSendMsg($hWnd, $MCM_GETCURSEL, 0, DllStructGetPtr($tBuffer))
	EndIf
	Return $tBuffer
EndFunc   ;==>_GUICtrlMonthCal_GetCurSel

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMonthCal_GetCurSelStr($hWnd, $sFormat = "%02d/%02d/%04d")
	Local $tBuffer = _GUICtrlMonthCal_GetCurSel($hWnd)
	Return StringFormat($sFormat, DllStructGetData($tBuffer, "Month"), DllStructGetData($tBuffer, "Day"), DllStructGetData($tBuffer, "Year"))
EndFunc   ;==>_GUICtrlMonthCal_GetCurSelStr

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlMonthCal_GetFirstDOW($hWnd)
	If IsHWnd($hWnd) Then
		Return _WinAPI_LoWord(_SendMessage($hWnd, $MCM_GETFIRSTDAYOFWEEK))
	Else
		Return _WinAPI_LoWord(GUICtrlSendMsg($hWnd, $MCM_GETFIRSTDAYOFWEEK, 0, 0))
	EndIf
EndFunc   ;==>_GUICtrlMonthCal_GetFirstDOW

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMonthCal_GetFirstDOWStr($hWnd)
	Local $aDays[7] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

	Return $aDays[_GUICtrlMonthCal_GetFirstDOW($hWnd)]
EndFunc   ;==>_GUICtrlMonthCal_GetFirstDOWStr

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMonthCal_GetMaxSelCount($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $MCM_GETMAXSELCOUNT)
	Else
		Return GUICtrlSendMsg($hWnd, $MCM_GETMAXSELCOUNT, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlMonthCal_GetMaxSelCount

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMonthCal_GetMaxTodayWidth($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $MCM_GETMAXTODAYWIDTH)
	Else
		Return GUICtrlSendMsg($hWnd, $MCM_GETMAXTODAYWIDTH, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlMonthCal_GetMaxTodayWidth

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMonthCal_GetMinReqHeight($hWnd)
	Local $tRECT = _GUICtrlMonthCal_GetMinReqRect($hWnd)
	Return DllStructGetData($tRECT, "Bottom")
EndFunc   ;==>_GUICtrlMonthCal_GetMinReqHeight

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlMonthCal_GetMinReqRect($hWnd)
	Local $tRECT = DllStructCreate($tagRECT)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hMCLastWnd) Then
			_SendMessage($hWnd, $MCM_GETMINREQRECT, 0, $tRECT, 0, "wparam", "struct*")
		Else
			Local $iRect = DllStructGetSize($tRECT)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iRect, $tMemMap)
			_SendMessage($hWnd, $MCM_GETMINREQRECT, 0, $pMemory, 0, "wparam", "ptr")
			_MemRead($tMemMap, $pMemory, $tRECT, $iRect)
			_MemFree($tMemMap)
		EndIf
	Else
		GUICtrlSendMsg($hWnd, $MCM_GETMINREQRECT, 0, DllStructGetPtr($tRECT))
	EndIf
	Return $tRECT
EndFunc   ;==>_GUICtrlMonthCal_GetMinReqRect

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMonthCal_GetMinReqRectArray($hWnd)
	Local $i_Ret
	Local $tRECT = DllStructCreate($tagRECT)
	If @error Then Return SetError(-1, -1, -1)
	If IsHWnd($hWnd) Then
		$i_Ret = _SendMessage($hWnd, $MCM_GETMINREQRECT, 0, $tRECT, 0, "wparam", "struct*")
	Else
		$i_Ret = GUICtrlSendMsg($hWnd, $MCM_GETMINREQRECT, 0, DllStructGetPtr($tRECT))
	EndIf
	If (Not $i_Ret) Then Return SetError(-2, -1, -1)
	Return StringSplit(DllStructGetData($tRECT, "Left") & "," & DllStructGetData($tRECT, "Top") & "," & DllStructGetData($tRECT, "Right") & "," & DllStructGetData($tRECT, "Bottom"), ",")
EndFunc   ;==>_GUICtrlMonthCal_GetMinReqRectArray

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMonthCal_GetMinReqWidth($hWnd)
	Local $tRECT = _GUICtrlMonthCal_GetMinReqRect($hWnd)
	Return DllStructGetData($tRECT, "Right")
EndFunc   ;==>_GUICtrlMonthCal_GetMinReqWidth

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMonthCal_GetMonthDelta($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $MCM_GETMONTHDELTA)
	Else
		Return GUICtrlSendMsg($hWnd, $MCM_GETMONTHDELTA, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlMonthCal_GetMonthDelta

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlMonthCal_GetMonthRange($hWnd, $bPartial = False)
	Local $tBuffer = DllStructCreate($tagMCMONTHRANGE)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hMCLastWnd) Then
			DllStructSetData($tBuffer, "Span", _SendMessage($hWnd, $MCM_GETMONTHRANGE, $bPartial, $tBuffer, 0, "wparam", "struct*"))
		Else
			Local $iBuffer = DllStructGetSize($tBuffer)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iBuffer, $tMemMap)
			DllStructSetData($tBuffer, "Span", _SendMessage($hWnd, $MCM_GETMONTHRANGE, $bPartial, $pMemory, 0, "wparam", "ptr"))
			_MemRead($tMemMap, $pMemory, $tBuffer, $iBuffer)
			_MemFree($tMemMap)
		EndIf
	Else
		DllStructSetData($tBuffer, "Span", GUICtrlSendMsg($hWnd, $MCM_GETMONTHRANGE, $bPartial, DllStructGetPtr($tBuffer)))
	EndIf
	Return $tBuffer
EndFunc   ;==>_GUICtrlMonthCal_GetMonthRange

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMonthCal_GetMonthRangeMax($hWnd, $bPartial = False)
	Local $tBuffer = _GUICtrlMonthCal_GetMonthRange($hWnd, $bPartial)
	Local $tRange = DllStructCreate($tagSYSTEMTIME)
	DllStructSetData($tRange, "Year", DllStructGetData($tBuffer, "MaxYear"))
	DllStructSetData($tRange, "Month", DllStructGetData($tBuffer, "MaxMonth"))
	DllStructSetData($tRange, "DOW", DllStructGetData($tBuffer, "MaxDOW"))
	DllStructSetData($tRange, "Day", DllStructGetData($tBuffer, "MaxDay"))
	Return $tRange
EndFunc   ;==>_GUICtrlMonthCal_GetMonthRangeMax

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMonthCal_GetMonthRangeMaxStr($hWnd, $sFormat = "%02d/%02d/%04d")
	Local $tBuffer = _GUICtrlMonthCal_GetMonthRangeMax($hWnd)
	Return StringFormat($sFormat, DllStructGetData($tBuffer, "Month"), DllStructGetData($tBuffer, "Day"), DllStructGetData($tBuffer, "Year"))
EndFunc   ;==>_GUICtrlMonthCal_GetMonthRangeMaxStr

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMonthCal_GetMonthRangeMin($hWnd, $bPartial = False)
	Local $tBuffer = _GUICtrlMonthCal_GetMonthRange($hWnd, $bPartial)
	Local $tRange = DllStructCreate($tagSYSTEMTIME)
	DllStructSetData($tRange, "Year", DllStructGetData($tBuffer, "MinYear"))
	DllStructSetData($tRange, "Month", DllStructGetData($tBuffer, "MinMonth"))
	DllStructSetData($tRange, "DOW", DllStructGetData($tBuffer, "MinDOW"))
	DllStructSetData($tRange, "Day", DllStructGetData($tBuffer, "MinDay"))
	Return $tRange
EndFunc   ;==>_GUICtrlMonthCal_GetMonthRangeMin

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMonthCal_GetMonthRangeMinStr($hWnd, $sFormat = "%02d/%02d/%04d")
	Local $tBuffer = _GUICtrlMonthCal_GetMonthRangeMin($hWnd)
	Return StringFormat($sFormat, DllStructGetData($tBuffer, "Month"), DllStructGetData($tBuffer, "Day"), DllStructGetData($tBuffer, "Year"))
EndFunc   ;==>_GUICtrlMonthCal_GetMonthRangeMinStr

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMonthCal_GetMonthRangeSpan($hWnd, $bPartial = False)
	Local $tBuffer = _GUICtrlMonthCal_GetMonthRange($hWnd, $bPartial)
	Return DllStructGetData($tBuffer, "Span")
EndFunc   ;==>_GUICtrlMonthCal_GetMonthRangeSpan

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlMonthCal_GetRange($hWnd)
	Local $iRet

	Local $tBuffer = DllStructCreate($tagMCRANGE)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hMCLastWnd) Then
			$iRet = _SendMessage($hWnd, $MCM_GETRANGE, 0, $tBuffer, 0, "wparam", "struct*")
		Else
			Local $iBuffer = DllStructGetSize($tBuffer)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iBuffer, $tMemMap)
			$iRet = _SendMessage($hWnd, $MCM_GETRANGE, 0, $pMemory, 0, "wparam", "ptr")
			_MemRead($tMemMap, $pMemory, $tBuffer, $iBuffer)
			_MemFree($tMemMap)
		EndIf
	Else
		$iRet = GUICtrlSendMsg($hWnd, $MCM_GETRANGE, 0, DllStructGetPtr($tBuffer))
	EndIf
	DllStructSetData($tBuffer, "MinSet", BitAND($iRet, $GDTR_MIN) <> 0)
	DllStructSetData($tBuffer, "MaxSet", BitAND($iRet, $GDTR_MAX) <> 0)
	Return $tBuffer
EndFunc   ;==>_GUICtrlMonthCal_GetRange

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMonthCal_GetRangeMax($hWnd)
	Local $tBuffer = _GUICtrlMonthCal_GetRange($hWnd)
	Local $tRange = DllStructCreate($tagSYSTEMTIME)
	DllStructSetData($tRange, "Year", DllStructGetData($tBuffer, "MaxYear"))
	DllStructSetData($tRange, "Month", DllStructGetData($tBuffer, "MaxMonth"))
	DllStructSetData($tRange, "DOW", DllStructGetData($tBuffer, "MaxDOW"))
	DllStructSetData($tRange, "Day", DllStructGetData($tBuffer, "MaxDay"))
	Return $tRange
EndFunc   ;==>_GUICtrlMonthCal_GetRangeMax

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMonthCal_GetRangeMaxStr($hWnd, $sFormat = "%02d/%02d/%04d")
	Local $tBuffer = _GUICtrlMonthCal_GetRangeMax($hWnd)
	Return StringFormat($sFormat, DllStructGetData($tBuffer, "Month"), DllStructGetData($tBuffer, "Day"), DllStructGetData($tBuffer, "Year"))
EndFunc   ;==>_GUICtrlMonthCal_GetRangeMaxStr

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMonthCal_GetRangeMin($hWnd)
	Local $tBuffer = _GUICtrlMonthCal_GetRange($hWnd)
	Local $tRange = DllStructCreate($tagSYSTEMTIME)
	DllStructSetData($tRange, "Year", DllStructGetData($tBuffer, "MinYear"))
	DllStructSetData($tRange, "Month", DllStructGetData($tBuffer, "MinMonth"))
	DllStructSetData($tRange, "DOW", DllStructGetData($tBuffer, "MinDOW"))
	DllStructSetData($tRange, "Day", DllStructGetData($tBuffer, "MinDay"))
	Return $tRange
EndFunc   ;==>_GUICtrlMonthCal_GetRangeMin

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMonthCal_GetRangeMinStr($hWnd, $sFormat = "%02d/%02d/%04d")
	Local $tBuffer = _GUICtrlMonthCal_GetRangeMin($hWnd)
	Return StringFormat($sFormat, DllStructGetData($tBuffer, "Month"), DllStructGetData($tBuffer, "Day"), DllStructGetData($tBuffer, "Year"))
EndFunc   ;==>_GUICtrlMonthCal_GetRangeMinStr

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlMonthCal_GetSelRange($hWnd)
	Local $iRet

	Local $tBuffer = DllStructCreate($tagMCSELRANGE)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hMCLastWnd) Then
			$iRet = _SendMessage($hWnd, $MCM_GETSELRANGE, 0, $tBuffer, 0, "wparam", "ptr")
		Else
			Local $iBuffer = DllStructGetSize($tBuffer)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iBuffer, $tMemMap)
			$iRet = _SendMessage($hWnd, $MCM_GETSELRANGE, 0, $pMemory, 0, "wparam", "ptr")
			_MemRead($tMemMap, $pMemory, $tBuffer, $iBuffer)
			_MemFree($tMemMap)
		EndIf
	Else
		$iRet = GUICtrlSendMsg($hWnd, $MCM_GETSELRANGE, 0, DllStructGetPtr($tBuffer))
	EndIf
	Return SetError($iRet = 0, 0, $tBuffer)
EndFunc   ;==>_GUICtrlMonthCal_GetSelRange

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMonthCal_GetSelRangeMax($hWnd)
	Local $tBuffer = _GUICtrlMonthCal_GetSelRange($hWnd)
	Local $tRange = DllStructCreate($tagSYSTEMTIME)
	DllStructSetData($tRange, "Year", DllStructGetData($tBuffer, "MaxYear"))
	DllStructSetData($tRange, "Month", DllStructGetData($tBuffer, "MaxMonth"))
	DllStructSetData($tRange, "DOW", DllStructGetData($tBuffer, "MaxDOW"))
	DllStructSetData($tRange, "Day", DllStructGetData($tBuffer, "MaxDay"))
	Return $tRange
EndFunc   ;==>_GUICtrlMonthCal_GetSelRangeMax

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMonthCal_GetSelRangeMaxStr($hWnd, $sFormat = "%02d/%02d/%04d")
	Local $tBuffer = _GUICtrlMonthCal_GetSelRangeMax($hWnd)
	Return StringFormat($sFormat, DllStructGetData($tBuffer, "Month"), DllStructGetData($tBuffer, "Day"), DllStructGetData($tBuffer, "Year"))
EndFunc   ;==>_GUICtrlMonthCal_GetSelRangeMaxStr

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMonthCal_GetSelRangeMin($hWnd)
	Local $tBuffer = _GUICtrlMonthCal_GetSelRange($hWnd)
	Local $tRange = DllStructCreate($tagSYSTEMTIME)
	DllStructSetData($tRange, "Year", DllStructGetData($tBuffer, "MinYear"))
	DllStructSetData($tRange, "Month", DllStructGetData($tBuffer, "MinMonth"))
	DllStructSetData($tRange, "DOW", DllStructGetData($tBuffer, "MinDOW"))
	DllStructSetData($tRange, "Day", DllStructGetData($tBuffer, "MinDay"))
	Return $tRange
EndFunc   ;==>_GUICtrlMonthCal_GetSelRangeMin

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMonthCal_GetSelRangeMinStr($hWnd, $sFormat = "%02d/%02d/%04d")
	Local $tBuffer = _GUICtrlMonthCal_GetSelRangeMin($hWnd)
	Return StringFormat($sFormat, DllStructGetData($tBuffer, "Month"), DllStructGetData($tBuffer, "Day"), DllStructGetData($tBuffer, "Year"))
EndFunc   ;==>_GUICtrlMonthCal_GetSelRangeMinStr

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlMonthCal_GetToday($hWnd)
	Local $iRet

	Local $tBuffer = DllStructCreate($tagSYSTEMTIME)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hMCLastWnd) Then
			$iRet = _SendMessage($hWnd, $MCM_GETTODAY, 0, $tBuffer, 0, "wparam", "ptr") <> 0
		Else
			Local $iBuffer = DllStructGetSize($tBuffer)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iBuffer, $tMemMap)
			$iRet = _SendMessage($hWnd, $MCM_GETTODAY, 0, $pMemory, 0, "wparam", "ptr") <> 0
			_MemRead($tMemMap, $pMemory, $tBuffer, $iBuffer)
			_MemFree($tMemMap)
		EndIf
	Else
		$iRet = GUICtrlSendMsg($hWnd, $MCM_GETTODAY, 0, DllStructGetPtr($tBuffer)) <> 0
	EndIf
	Return SetError($iRet = 0, 0, $tBuffer)
EndFunc   ;==>_GUICtrlMonthCal_GetToday

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMonthCal_GetTodayStr($hWnd, $sFormat = "%02d/%02d/%04d")
	Local $tBuffer = _GUICtrlMonthCal_GetToday($hWnd)
	Return StringFormat($sFormat, DllStructGetData($tBuffer, "Month"), DllStructGetData($tBuffer, "Day"), DllStructGetData($tBuffer, "Year"))
EndFunc   ;==>_GUICtrlMonthCal_GetTodayStr

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlMonthCal_GetUnicodeFormat($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $MCM_GETUNICODEFORMAT) <> 0
	Else
		Return GUICtrlSendMsg($hWnd, $MCM_GETUNICODEFORMAT, 0, 0) <> 0
	EndIf
EndFunc   ;==>_GUICtrlMonthCal_GetUnicodeFormat

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlMonthCal_HitTest($hWnd, $iX, $iY)
	Local $tTest = DllStructCreate($tagMCHITTESTINFO)
	Local $iTest = DllStructGetSize($tTest)
	DllStructSetData($tTest, "Size", $iTest)
	DllStructSetData($tTest, "X", $iX)
	DllStructSetData($tTest, "Y", $iY)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hMCLastWnd) Then
			_SendMessage($hWnd, $MCM_HITTEST, 0, $tTest, 0, "wparam", "struct*")
		Else
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iTest, $tMemMap)
			_SendMessage($hWnd, $MCM_HITTEST, 0, $pMemory, 0, "wparam", "ptr")
			_MemRead($tMemMap, $pMemory, $tTest, $iTest)
			_MemFree($tMemMap)
		EndIf
	Else
		GUICtrlSendMsg($hWnd, $MCM_HITTEST, 0, DllStructGetPtr($tTest))
	EndIf
	Return $tTest
EndFunc   ;==>_GUICtrlMonthCal_HitTest

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUICtrlMonthCal_Resize
; Description ...: Adjusts the control size so that it is fully shown
; Syntax.........: __GUICtrlMonthCal_Resize ( $hWnd [, $iX = -1 [, $iY = -1]] )
; Parameters ....: $hWnd        - Handle to control
;                  $iX          - Left position of calendar. If -1, the current position will be used
;                  $iY          - Top position of calendar. If -1, the current position will be used
; Return values .: None
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......: This function is called internally by _GUICtrlMonthCal_Create and should not normally be called by the end user.
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __GUICtrlMonthCal_Resize($hWnd, $iX = -1, $iY = -1)
	Local $iN = _GUICtrlMonthCal_GetMaxTodayWidth($hWnd)
	Local $iH = _GUICtrlMonthCal_GetMinReqHeight($hWnd)
	Local $iW = _GUICtrlMonthCal_GetMinReqWidth($hWnd)
	If $iN > $iW Then $iW = $iN
	If ($iX = -1) Or ($iY = -1) Then
		Local $tRECT = _WinAPI_GetWindowRect($hWnd)
		If $iX = -1 Then $iX = DllStructGetData($tRECT, "Left")
		If $iY = -1 Then $iY = DllStructGetData($tRECT, "Top")
	EndIf
	;_WinAPI_SetWindowPos($hWnd, 0, $iX, $iY, $iX + $iW, $iY + $iH, $__MONTHCALCONSTANT_SWP_NOZORDER)
	_WinAPI_SetWindowPos($hWnd, 0, $iX, $iY, $iW, $iH, $__MONTHCALCONSTANT_SWP_NOZORDER)
EndFunc   ;==>__GUICtrlMonthCal_Resize

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMonthCal_SetCalendarBorder($hWnd, $iBorderSize = 4, $bSetBorder = True)
	If IsHWnd($hWnd) Then
		_SendMessage($hWnd, $MCM_SETCALENDARBORDER, $bSetBorder, $iBorderSize)
	Else
		GUICtrlSendMsg($hWnd, $MCM_SETCALENDARBORDER, $bSetBorder, $iBorderSize)
	EndIf
EndFunc   ;==>_GUICtrlMonthCal_SetCalendarBorder

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlMonthCal_SetColor($hWnd, $iIndex, $iColor)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $MCM_SETCOLOR, $iIndex, $iColor)
	Else
		Return GUICtrlSendMsg($hWnd, $MCM_SETCOLOR, $iIndex, $iColor)
	EndIf
EndFunc   ;==>_GUICtrlMonthCal_SetColor

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlMonthCal_SetCurSel($hWnd, $iYear, $iMonth, $iDay)
	Local $iRet

	Local $tBuffer = DllStructCreate($tagSYSTEMTIME)
	DllStructSetData($tBuffer, "Month", $iMonth)
	DllStructSetData($tBuffer, "Day", $iDay)
	DllStructSetData($tBuffer, "Year", $iYear)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hMCLastWnd) Then
			$iRet = _SendMessage($hWnd, $MCM_SETCURSEL, 0, $tBuffer, 0, "wparam", "ptr")
		Else
			Local $iBuffer = DllStructGetSize($tBuffer)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iBuffer, $tMemMap)
			_MemWrite($tMemMap, $tBuffer)
			$iRet = _SendMessage($hWnd, $MCM_SETCURSEL, 0, $pMemory, 0, "wparam", "ptr")
			_MemFree($tMemMap)
		EndIf
	Else
		$iRet = GUICtrlSendMsg($hWnd, $MCM_SETCURSEL, 0, DllStructGetPtr($tBuffer))
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlMonthCal_SetCurSel

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlMonthCal_SetDayState($hWnd, $aMasks)
	Local $iRet

	Local $iMasks = _GUICtrlMonthCal_GetMonthRangeSpan($hWnd, True)
	Local $tBuffer = DllStructCreate("int;int;int")
	For $iI = 0 To $iMasks - 1
		DllStructSetData($tBuffer, $iI + 1, $aMasks[$iI])
	Next
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hMCLastWnd) Then
			$iRet = _SendMessage($hWnd, $MCM_SETDAYSTATE, $iMasks, $tBuffer, 0, "wparam", "struct*")
		Else
			Local $iBuffer = DllStructGetSize($tBuffer)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iBuffer, $tMemMap)
			_MemWrite($tMemMap, $tBuffer)
			$iRet = _SendMessage($hWnd, $MCM_SETDAYSTATE, $iMasks, $pMemory, 0, "wparam", "ptr")
			_MemFree($tMemMap)
		EndIf
	Else
		$iRet = GUICtrlSendMsg($hWnd, $MCM_SETDAYSTATE, $iMasks, DllStructGetPtr($tBuffer))
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlMonthCal_SetDayState

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMonthCal_SetFirstDOW($hWnd, $sDay)
	Local $i_Day
	If $sDay >= 0 Or $sDay <= 6 Then
		$i_Day = $sDay
	ElseIf StringInStr("MONDAY TUESDAY WEDNESDAY THURSDAY FRIDAY SATURDAY SUNDAY", $sDay) Then
		Switch StringUpper($sDay)
			Case "MONDAY"
				$i_Day = 0
			Case "TUESDAY"
				$i_Day = 1
			Case "WEDNESDAY"
				$i_Day = 2
			Case "THURSDAY"
				$i_Day = 3
			Case "FRIDAY"
				$i_Day = 4
			Case "SATURDAY"
				$i_Day = 5
			Case "SUNDAY"
				$i_Day = 6
		EndSwitch
	Else
		Return SetError(-1, -1, -1)
	EndIf
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $MCM_SETFIRSTDAYOFWEEK, 0, $i_Day)
	Else
		Return GUICtrlSendMsg($hWnd, $MCM_SETFIRSTDAYOFWEEK, 0, $i_Day)
	EndIf
EndFunc   ;==>_GUICtrlMonthCal_SetFirstDOW

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMonthCal_SetMaxSelCount($hWnd, $iMaxSel)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $MCM_SETMAXSELCOUNT, $iMaxSel) <> 0
	Else
		Return GUICtrlSendMsg($hWnd, $MCM_SETMAXSELCOUNT, $iMaxSel, 0) <> 0
	EndIf
EndFunc   ;==>_GUICtrlMonthCal_SetMaxSelCount

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlMonthCal_SetMonthDelta($hWnd, $iDelta)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $MCM_SETMONTHDELTA, $iDelta)
	Else
		Return GUICtrlSendMsg($hWnd, $MCM_SETMONTHDELTA, $iDelta, 0)
	EndIf
EndFunc   ;==>_GUICtrlMonthCal_SetMonthDelta

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlMonthCal_SetRange($hWnd, $iMinYear, $iMinMonth, $iMinDay, $iMaxYear, $iMaxMonth, $iMaxDay)
	Local $iRet

	Local $tRange = DllStructCreate($tagMCRANGE)
	Local $iFlags = BitOR($GDTR_MIN, $GDTR_MAX)
	DllStructSetData($tRange, "MinYear", $iMinYear)
	DllStructSetData($tRange, "MinMonth", $iMinMonth)
	DllStructSetData($tRange, "MinDay", $iMinDay)
	DllStructSetData($tRange, "MaxYear", $iMaxYear)
	DllStructSetData($tRange, "MaxMonth", $iMaxMonth)
	DllStructSetData($tRange, "MaxDay", $iMaxDay)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hMCLastWnd) Then
			$iRet = _SendMessage($hWnd, $MCM_SETRANGE, $iFlags, $tRange, 0, "wparam", "ptr")
		Else
			Local $iRange = DllStructGetSize($tRange)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iRange, $tMemMap)
			_MemWrite($tMemMap, $tRange)
			$iRet = _SendMessage($hWnd, $MCM_SETRANGE, $iFlags, $pMemory, 0, "wparam", "ptr")
			_MemFree($tMemMap)
		EndIf
	Else
		$iRet = GUICtrlSendMsg($hWnd, $MCM_SETRANGE, $iFlags, DllStructGetPtr($tRange))
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlMonthCal_SetRange

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlMonthCal_SetSelRange($hWnd, $iMinYear, $iMinMonth, $iMinDay, $iMaxYear, $iMaxMonth, $iMaxDay)
	Local $tBuffer = DllStructCreate($tagMCRANGE)
	DllStructSetData($tBuffer, "MinYear", $iMinYear)
	DllStructSetData($tBuffer, "MinMonth", $iMinMonth)
	DllStructSetData($tBuffer, "MinDay", $iMinDay)
	DllStructSetData($tBuffer, "MaxYear", $iMaxYear)
	DllStructSetData($tBuffer, "MaxMonth", $iMaxMonth)
	DllStructSetData($tBuffer, "MaxDay", $iMaxDay)
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hMCLastWnd) Then
			$iRet = _SendMessage($hWnd, $MCM_SETSELRANGE, 0, $tBuffer, 0, "wparam", "struct*")
		Else
			Local $iBuffer = DllStructGetSize($tBuffer)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iBuffer, $tMemMap)
			_MemWrite($tMemMap, $tBuffer)
			$iRet = _SendMessage($hWnd, $MCM_SETSELRANGE, 0, $pMemory, 0, "wparam", "ptr")
			_MemFree($tMemMap)
		EndIf
	Else
		$iRet = GUICtrlSendMsg($hWnd, $MCM_SETSELRANGE, 0, DllStructGetPtr($tBuffer))
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlMonthCal_SetSelRange

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlMonthCal_SetToday($hWnd, $iYear, $iMonth, $iDay)
	Local $tBuffer = DllStructCreate($tagSYSTEMTIME)
	DllStructSetData($tBuffer, "Month", $iMonth)
	DllStructSetData($tBuffer, "Day", $iDay)
	DllStructSetData($tBuffer, "Year", $iYear)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hMCLastWnd) Then
			_SendMessage($hWnd, $MCM_SETTODAY, 0, $tBuffer, 0, "wparam", "struct*")
		Else
			Local $iBuffer = DllStructGetSize($tBuffer)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iBuffer, $tMemMap)
			_MemWrite($tMemMap, $tBuffer)
			_SendMessage($hWnd, $MCM_SETTODAY, 0, $pMemory, 0, "wparam", "ptr")
			_MemFree($tMemMap)
		EndIf
	Else
		GUICtrlSendMsg($hWnd, $MCM_SETTODAY, 0, DllStructGetPtr($tBuffer))
	EndIf
EndFunc   ;==>_GUICtrlMonthCal_SetToday

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _GUICtrlMonthCal_SetUnicodeFormat($hWnd, $bUnicode = False)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $MCM_SETUNICODEFORMAT, $bUnicode) <> 0
	Else
		Return GUICtrlSendMsg($hWnd, $MCM_SETUNICODEFORMAT, $bUnicode, 0) <> 0
	EndIf
EndFunc   ;==>_GUICtrlMonthCal_SetUnicodeFormat
