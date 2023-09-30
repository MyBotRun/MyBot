#include-once

#include "IPAddressConstants.au3"
#include "Memory.au3"
#include "SendMessage.au3"
#include "StructureConstants.au3"
#include "UDFGlobalID.au3"
#include "WinAPI.au3"

; #INDEX# =======================================================================================================================
; Title .........: IPAddress
; AutoIt Version : 3.3.14.2
; Language ......: English
; Description ...: Functions that assist with IPAddress control management.
; Author(s) .....: Gary Frost (gafrost)
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
Global $__g_hIPLastWnd

; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $__IPADDRESSCONSTANT_ClassName = "SysIPAddress32"
Global Const $__IPADDRESSCONSTANT_DEFAULT_GUI_FONT = 17
Global Const $__IPADDRESSCONSTANT_LOGPIXELSX = 88
Global Const $__IPADDRESSCONSTANT_PROOF_QUALITY = 2
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _GUICtrlIpAddress_Create
; _GUICtrlIpAddress_ClearAddress
; _GUICtrlIpAddress_Destroy
; _GUICtrlIpAddress_Get
; _GUICtrlIpAddress_GetArray
; _GUICtrlIpAddress_GetEx
; _GUICtrlIpAddress_IsBlank
; _GUICtrlIpAddress_Set
; _GUICtrlIpAddress_SetArray
; _GUICtrlIpAddress_SetEx
; _GUICtrlIpAddress_SetFocus
; _GUICtrlIpAddress_SetFont
; _GUICtrlIpAddress_SetRange
; _GUICtrlIpAddress_ShowHide
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlIpAddress_Create($hWnd, $iX, $iY, $iWidth = 125, $iHeight = 25, $iStyles = 0x00000000, $iExstyles = 0x00000000)
	If Not IsHWnd($hWnd) Then Return SetError(1, 0, 0) ; Invalid Window handle for _GUICtrlIpAddress_Create 1st parameter

	If $iStyles = -1 Then $iStyles = 0x00000000
	If $iExstyles = -1 Then $iExstyles = 0x00000000

	Local $iStyle = BitOR($__UDFGUICONSTANT_WS_CHILD, $__UDFGUICONSTANT_WS_VISIBLE, $__UDFGUICONSTANT_WS_TABSTOP, $iStyles)

	Local Const $ICC_INTERNET_CLASSES = 0x0800
	Local $tICCE = DllStructCreate('dword dwSize;dword dwICC')
	DllStructSetData($tICCE, "dwSize", DllStructGetSize($tICCE))
	DllStructSetData($tICCE, "dwICC", $ICC_INTERNET_CLASSES)
	DllCall('comctl32.dll', 'bool', 'InitCommonControlsEx', 'struct*', $tICCE)
	If @error Then Return SetError(@error, @extended, 0)

	Local $nCtrlID = __UDF_GetNextGlobalID($hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Local $hIPAddress = _WinAPI_CreateWindowEx($iExstyles, $__IPADDRESSCONSTANT_ClassName, "", $iStyle, $iX, $iY, $iWidth, $iHeight, $hWnd, $nCtrlID)
	_WinAPI_SetFont($hIPAddress, _WinAPI_GetStockObject($__IPADDRESSCONSTANT_DEFAULT_GUI_FONT))

	Return $hIPAddress
EndFunc   ;==>_GUICtrlIpAddress_Create

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlIpAddress_ClearAddress($hWnd)
	_SendMessage($hWnd, $IPM_CLEARADDRESS)
EndFunc   ;==>_GUICtrlIpAddress_ClearAddress

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlIpAddress_Destroy($hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__IPADDRESSCONSTANT_ClassName) Then Return SetError(2, 2, False)

	Local $iDestroyed = 0
	If _WinAPI_InProcess($hWnd, $__g_hIPLastWnd) Then
		Local $nCtrlID = _WinAPI_GetDlgCtrlID($hWnd)
		Local $hParent = _WinAPI_GetParent($hWnd)
		$iDestroyed = _WinAPI_DestroyWindow($hWnd)
		Local $iRet = __UDF_FreeGlobalID($hParent, $nCtrlID)
		If Not $iRet Then
			; can check for errors here if needed, for debug
		EndIf
	Else
		; Not Allowed to Delete Other Applications IPAddress Control(s)
		Return SetError(1, 1, False)
	EndIf
	If $iDestroyed Then $hWnd = 0
	Return $iDestroyed <> 0
EndFunc   ;==>_GUICtrlIpAddress_Destroy

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlIpAddress_Get($hWnd)
	Local $tIP = _GUICtrlIpAddress_GetEx($hWnd)

	If @error Then Return SetError(2, 2, "")
	Return StringFormat("%d.%d.%d.%d", DllStructGetData($tIP, "Field1"), _
			DllStructGetData($tIP, "Field2"), _
			DllStructGetData($tIP, "Field3"), _
			DllStructGetData($tIP, "Field4"))
EndFunc   ;==>_GUICtrlIpAddress_Get

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlIpAddress_GetArray($hWnd)
	Local $tIP = _GUICtrlIpAddress_GetEx($hWnd)
	Local $aIP[4]
	$aIP[0] = DllStructGetData($tIP, "Field1")
	$aIP[1] = DllStructGetData($tIP, "Field2")
	$aIP[2] = DllStructGetData($tIP, "Field3")
	$aIP[3] = DllStructGetData($tIP, "Field4")
	Return $aIP
EndFunc   ;==>_GUICtrlIpAddress_GetArray

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlIpAddress_GetEx($hWnd)
	Local $tIP = DllStructCreate($tagGETIPAddress)
	If @error Then Return SetError(1, 1, "")
	If _WinAPI_InProcess($hWnd, $__g_hIPLastWnd) Then
		_SendMessage($hWnd, $IPM_GETADDRESS, 0, $tIP, 0, "wparam", "struct*")
	Else
		Local $iIP = DllStructGetSize($tIP)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iIP, $tMemMap)
		_SendMessage($hWnd, $IPM_GETADDRESS, 0, $pMemory, 0, "wparam", "ptr")
		_MemRead($tMemMap, $pMemory, $tIP, $iIP)
		_MemFree($tMemMap)
	EndIf
	Return $tIP
EndFunc   ;==>_GUICtrlIpAddress_GetEx

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlIpAddress_IsBlank($hWnd)
	Return _SendMessage($hWnd, $IPM_ISBLANK) <> 0
EndFunc   ;==>_GUICtrlIpAddress_IsBlank

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlIpAddress_Set($hWnd, $sAddress)
	Local $aAddress = StringSplit($sAddress, ".")
	If $aAddress[0] = 4 Then
		Local $tIP = DllStructCreate($tagGETIPAddress)
		For $x = 1 To 4
			DllStructSetData($tIP, "Field" & $x, $aAddress[$x])
		Next
		_GUICtrlIpAddress_SetEx($hWnd, $tIP)
	EndIf
EndFunc   ;==>_GUICtrlIpAddress_Set

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlIpAddress_SetArray($hWnd, $aAddress)
	If UBound($aAddress) = 4 Then
		Local $tIP = DllStructCreate($tagGETIPAddress)
		For $x = 0 To 3
			DllStructSetData($tIP, "Field" & $x + 1, $aAddress[$x])
		Next
		_GUICtrlIpAddress_SetEx($hWnd, $tIP)
	EndIf
EndFunc   ;==>_GUICtrlIpAddress_SetArray

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlIpAddress_SetEx($hWnd, $tIP)
	_SendMessage($hWnd, $IPM_SETADDRESS, 0, _
			_WinAPI_MakeLong(BitOR(DllStructGetData($tIP, "Field4"), 0x100 * DllStructGetData($tIP, "Field3")), _
			BitOR(DllStructGetData($tIP, "Field2"), 0x100 * DllStructGetData($tIP, "Field1"))))
EndFunc   ;==>_GUICtrlIpAddress_SetEx

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlIpAddress_SetFocus($hWnd, $iIndex)
	_SendMessage($hWnd, $IPM_SETFOCUS, $iIndex)
EndFunc   ;==>_GUICtrlIpAddress_SetFocus

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlIpAddress_SetFont($hWnd, $sFaceName = "Arial", $iFontSize = 12, $iFontWeight = 400, $bFontItalic = False)
	Local $hDC = _WinAPI_GetDC(0)
	Local $iHeight = Round(($iFontSize * _WinAPI_GetDeviceCaps($hDC, $__IPADDRESSCONSTANT_LOGPIXELSX)) / 72, 0)
	_WinAPI_ReleaseDC(0, $hDC)

	Local $tFont = DllStructCreate($tagLOGFONT)
	DllStructSetData($tFont, "Height", $iHeight)
	DllStructSetData($tFont, "Weight", $iFontWeight)
	DllStructSetData($tFont, "Italic", $bFontItalic)
	DllStructSetData($tFont, "Underline", False) ; font underline
	DllStructSetData($tFont, "Strikeout", False) ; font strikethru
	DllStructSetData($tFont, "Quality", $__IPADDRESSCONSTANT_PROOF_QUALITY)
	DllStructSetData($tFont, "FaceName", $sFaceName)

	Local $hFont = _WinAPI_CreateFontIndirect($tFont)
	_WinAPI_SetFont($hWnd, $hFont)
EndFunc   ;==>_GUICtrlIpAddress_SetFont

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlIpAddress_SetRange($hWnd, $iIndex, $iLowRange = 0, $iHighRange = 255)
	If ($iLowRange < 0 Or $iLowRange > $iHighRange) Or $iHighRange > 255 Or ($iIndex < 0 Or $iIndex > 3) Then Return SetError(-1, -1, False)

	Return _SendMessage($hWnd, $IPM_SETRANGE, $iIndex, BitOR($iLowRange, 0x100 * $iHighRange)) <> 0
EndFunc   ;==>_GUICtrlIpAddress_SetRange

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlIpAddress_ShowHide($hWnd, $iState)
	If $iState <> @SW_HIDE And $iState <> @SW_SHOW Then Return SetError(1, 1, 0)
	Return _WinAPI_ShowWindow($hWnd, $iState) <> 0
EndFunc   ;==>_GUICtrlIpAddress_ShowHide
