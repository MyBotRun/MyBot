#include-once

#include "DateTimeConstants.au3"
#include "Memory.au3"
#include "SendMessage.au3"
#include "StructureConstants.au3"
#include "UDFGlobalID.au3"
#include "WinAPI.au3"

; #INDEX# =======================================================================================================================
; Title .........: Date_Time_Picker
; AutoIt Version : 3.3.14.2
; Description ...: Functions that assist with date and time picker (DTP) control management.
;                  A date and time picker (DTP) control provides a simple and intuitive interface through which to exchange date
;                  and time information with a user.  For example, with a DTP control you can ask the user to enter a date and
;                  then retrieve his or her selection with ease.
; Author(s) .....: Paul Campbell (PaulIA)
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
Global $__g_hDTLastWnd

; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $__DTPCONSTANT_ClassName = "SysDateTimePick32"
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _GUICtrlDTP_Create
; _GUICtrlDTP_Destroy
; _GUICtrlDTP_GetMCColor
; _GUICtrlDTP_GetMCFont
; _GUICtrlDTP_GetMonthCal
; _GUICtrlDTP_GetRange
; _GUICtrlDTP_GetRangeEx
; _GUICtrlDTP_GetSystemTime
; _GUICtrlDTP_GetSystemTimeEx
; _GUICtrlDTP_SetFormat
; _GUICtrlDTP_SetMCColor
; _GUICtrlDTP_SetMCFont
; _GUICtrlDTP_SetRange
; _GUICtrlDTP_SetRangeEx
; _GUICtrlDTP_SetSystemTime
; _GUICtrlDTP_SetSystemTimeEx
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlDTP_Create($hWnd, $iX, $iY, $iWidth = 120, $iHeight = 21, $iStyle = 0x00000000, $iExStyle = 0x00000000)
	$iStyle = BitOR($iStyle, $__UDFGUICONSTANT_WS_CHILD, $__UDFGUICONSTANT_WS_VISIBLE)
	Local $nCtrlID = __UDF_GetNextGlobalID($hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Return _WinAPI_CreateWindowEx($iExStyle, $__DTPCONSTANT_ClassName, "", $iStyle, $iX, $iY, $iWidth, $iHeight, $hWnd, $nCtrlID)
EndFunc   ;==>_GUICtrlDTP_Create

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlDTP_Destroy(ByRef $hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__DTPCONSTANT_ClassName) Then Return SetError(2, 2, False)

	Local $iDestroyed = 0
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hDTLastWnd) Then
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
EndFunc   ;==>_GUICtrlDTP_Destroy

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlDTP_GetMCColor($hWnd, $iIndex)
	Return _SendMessage($hWnd, $DTM_GETMCCOLOR, $iIndex)
EndFunc   ;==>_GUICtrlDTP_GetMCColor

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlDTP_GetMCFont($hWnd)
	Return Ptr(_SendMessage($hWnd, $DTM_GETMCFONT))
EndFunc   ;==>_GUICtrlDTP_GetMCFont

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlDTP_GetMonthCal($hWnd)
	Return HWnd(_SendMessage($hWnd, $DTM_GETMONTHCAL))
EndFunc   ;==>_GUICtrlDTP_GetMonthCal

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlDTP_GetRange($hWnd)
	Local $aRange[14]

	Local $tRange = _GUICtrlDTP_GetRangeEx($hWnd)
	$aRange[0] = DllStructGetData($tRange, "MinValid")
	$aRange[1] = DllStructGetData($tRange, "MinYear")
	$aRange[2] = DllStructGetData($tRange, "MinMonth")
	$aRange[3] = DllStructGetData($tRange, "MinDay")
	$aRange[4] = DllStructGetData($tRange, "MinHour")
	$aRange[5] = DllStructGetData($tRange, "MinMinute")
	$aRange[6] = DllStructGetData($tRange, "MinSecond")
	$aRange[7] = DllStructGetData($tRange, "MaxValid")
	$aRange[8] = DllStructGetData($tRange, "MaxYear")
	$aRange[9] = DllStructGetData($tRange, "MaxMonth")
	$aRange[10] = DllStructGetData($tRange, "MaxDay")
	$aRange[11] = DllStructGetData($tRange, "MaxHour")
	$aRange[12] = DllStructGetData($tRange, "MaxMinute")
	$aRange[13] = DllStructGetData($tRange, "MaxSecond")
	Return $aRange
EndFunc   ;==>_GUICtrlDTP_GetRange

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlDTP_GetRangeEx($hWnd)
	Local $tRange = DllStructCreate($tagDTPRANGE)
	Local $iRet
	If _WinAPI_InProcess($hWnd, $__g_hDTLastWnd) Then
		$iRet = _SendMessage($hWnd, $DTM_GETRANGE, 0, $tRange, 0, "wparam", "struct*")
	Else
		Local $iRange = DllStructGetSize($tRange)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iRange, $tMemMap)
		$iRet = _SendMessage($hWnd, $DTM_GETRANGE, 0, $pMemory, 0, "wparam", "ptr")
		_MemRead($tMemMap, $pMemory, $tRange, $iRange)
		_MemFree($tMemMap)
	EndIf
	DllStructSetData($tRange, "MinValid", BitAND($iRet, $GDTR_MIN) <> 0)
	DllStructSetData($tRange, "MaxValid", BitAND($iRet, $GDTR_MAX) <> 0)
	Return $tRange
EndFunc   ;==>_GUICtrlDTP_GetRangeEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlDTP_GetSystemTime($hWnd)
	Local $aDate[6]

	Local $tDate = _GUICtrlDTP_GetSystemTimeEx($hWnd)
	$aDate[0] = DllStructGetData($tDate, "Year")
	$aDate[1] = DllStructGetData($tDate, "Month")
	$aDate[2] = DllStructGetData($tDate, "Day")
	$aDate[3] = DllStructGetData($tDate, "Hour")
	$aDate[4] = DllStructGetData($tDate, "Minute")
	$aDate[5] = DllStructGetData($tDate, "Second")
	Return $aDate
EndFunc   ;==>_GUICtrlDTP_GetSystemTime

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlDTP_GetSystemTimeEx($hWnd)
	Local $tDate = DllStructCreate($tagSYSTEMTIME)
	Local $iRet
	If _WinAPI_InProcess($hWnd, $__g_hDTLastWnd) Then
		$iRet = _SendMessage($hWnd, $DTM_GETSYSTEMTIME, 0, $tDate, 0, "wparam", "struct*")
	Else
		Local $iDate = DllStructGetSize($tDate)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iDate, $tMemMap)
		$iRet = _SendMessage($hWnd, $DTM_GETSYSTEMTIME, 0, $pMemory, 0, "wparam", "ptr")
		_MemRead($tMemMap, $pMemory, $tDate, $iDate)
		_MemFree($tMemMap)
	EndIf
	Return SetError($iRet, $iRet, $tDate)
EndFunc   ;==>_GUICtrlDTP_GetSystemTimeEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlDTP_SetFormat($hWnd, $sFormat)
	Local $iRet
	If _WinAPI_InProcess($hWnd, $__g_hDTLastWnd) Then
		$iRet = _SendMessage($hWnd, $DTM_SETFORMATW, 0, $sFormat, 0, "wparam", "wstr")
	Else
		Local $iMemory = 2 * (StringLen($sFormat) + 1)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iMemory, $tMemMap)
		_MemWrite($tMemMap, $sFormat, $pMemory, $iMemory, "wstr")
		$iRet = _SendMessage($hWnd, $DTM_SETFORMATW, 0, $pMemory, 0, "wparam", "ptr")
		_MemFree($tMemMap)
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlDTP_SetFormat

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlDTP_SetMCColor($hWnd, $iIndex, $iColor)
	Return _SendMessage($hWnd, $DTM_SETMCCOLOR, $iIndex, $iColor)
EndFunc   ;==>_GUICtrlDTP_SetMCColor

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlDTP_SetMCFont($hWnd, $hFont, $bRedraw = True)
	_SendMessage($hWnd, $DTM_SETMCFONT, $hFont, $bRedraw, 0, "handle")
EndFunc   ;==>_GUICtrlDTP_SetMCFont

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlDTP_SetRange($hWnd, ByRef $aRange)
	Local $tRange = DllStructCreate($tagDTPRANGE)
	DllStructSetData($tRange, "MinValid", $aRange[0])
	DllStructSetData($tRange, "MinYear", $aRange[1])
	DllStructSetData($tRange, "MinMonth", $aRange[2])
	DllStructSetData($tRange, "MinDay", $aRange[3])
	DllStructSetData($tRange, "MinHour", $aRange[4])
	DllStructSetData($tRange, "MinMinute", $aRange[5])
	DllStructSetData($tRange, "MinSecond", $aRange[6])
	DllStructSetData($tRange, "MaxValid", $aRange[7])
	DllStructSetData($tRange, "MaxYear", $aRange[8])
	DllStructSetData($tRange, "MaxMonth", $aRange[9])
	DllStructSetData($tRange, "MaxDay", $aRange[10])
	DllStructSetData($tRange, "MaxHour", $aRange[11])
	DllStructSetData($tRange, "MaxMinute", $aRange[12])
	DllStructSetData($tRange, "MaxSecond", $aRange[13])
	Return _GUICtrlDTP_SetRangeEx($hWnd, $tRange)
EndFunc   ;==>_GUICtrlDTP_SetRange

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlDTP_SetRangeEx($hWnd, ByRef $tRange)
	Local $iFlags = 0, $iRet
	If DllStructGetData($tRange, "MinValid") Then $iFlags = BitOR($iFlags, $GDTR_MIN)
	If DllStructGetData($tRange, "MaxValid") Then $iFlags = BitOR($iFlags, $GDTR_MAX)
	If _WinAPI_InProcess($hWnd, $__g_hDTLastWnd) Then
		$iRet = _SendMessage($hWnd, $DTM_SETRANGE, $iFlags, $tRange, 0, "wparam", "struct*")
	Else
		Local $iRange = DllStructGetSize($tRange)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iRange, $tMemMap)
		_MemWrite($tMemMap, $tRange)
		$iRet = _SendMessage($hWnd, $DTM_SETRANGE, $iFlags, $pMemory, 0, "wparam", "ptr")
		_MemFree($tMemMap)
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlDTP_SetRangeEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlDTP_SetSystemTime($hWnd, ByRef $aDate)
	Local $tDate = DllStructCreate($tagSYSTEMTIME)
	DllStructSetData($tDate, "Year", $aDate[1])
	DllStructSetData($tDate, "Month", $aDate[2])
	DllStructSetData($tDate, "Day", $aDate[3])
	DllStructSetData($tDate, "Hour", $aDate[4])
	DllStructSetData($tDate, "Minute", $aDate[5])
	DllStructSetData($tDate, "Second", $aDate[6])
	Return _GUICtrlDTP_SetSystemTimeEx($hWnd, $tDate, $aDate[0])
EndFunc   ;==>_GUICtrlDTP_SetSystemTime

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlDTP_SetSystemTimeEx($hWnd, ByRef $tDate, $bFlag = False)
	Local $iFlag, $iRet

	If $bFlag Then
		$iFlag = $GDT_NONE
	Else
		$iFlag = $GDT_VALID
	EndIf
	If _WinAPI_InProcess($hWnd, $__g_hDTLastWnd) Then
		$iRet = _SendMessage($hWnd, $DTM_SETSYSTEMTIME, $iFlag, $tDate, 0, "wparam", "struct*")
	Else
		Local $iDate = DllStructGetSize($tDate)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iDate, $tMemMap)
		_MemWrite($tMemMap, $tDate)
		$iRet = _SendMessage($hWnd, $DTM_SETSYSTEMTIME, $iFlag, $pMemory, 0, "wparam", "ptr")
		_MemFree($tMemMap)
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlDTP_SetSystemTimeEx
