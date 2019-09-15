#include-once

#include "AVIConstants.au3"
#include "Memory.au3"
#include "SendMessage.au3"
#include "UDFGlobalID.au3"

; #INDEX# =======================================================================================================================
; Title .........: Animation
; AutoIt Version : 3.3.14.2
; Language ......: English
; Description ...: Functions that assist with AVI control management.
;                  An animation control is a window that displays an Audio-Video Interleaved (AVI) clip.  An AVI clip is a series
;                  of bitmap frames like a movie. Animation controls can only display AVI clips that do not  contain  audio.  One
;                  common use for an animation control is to indicate  system  activity  during  a  lengthy  operation.  This  is
;                  possible because the operation thread continues executing while the AVI clip is displayed.  For  example,  the
;                  Find dialog box of Microsoft Windows Explorer displays a moving magnifying glass as the system searches for  a
;                  file.
;
;                  If you are using comctl32.dll version 6 the thread is not supported, therefore make sure that your application
;                  does not block the UI or the animation  will  not  occur.  An  animation  control  can  display  an  AVI  clip
;                  originating from either an uncompressed AVI file or from an AVI file that  was  compressed  using  run  length
;                  (BI_RLE8) encoding. You can add the AVI clip to your application as an AVI resource, or the clip can accompany
;                  your application as a separate AVI file.
;
;                  The AVI file, or resource, must not have a sound channel.  The capabilities of the animation control are  very
;                  limited and are subject to change.  If you need  a  control  to  provide  multimedia  playback  and  recording
;                  capabilities for your application, you can use the MCIWnd control.
; Author(s) .....: Paul Campbell (PaulIA)
; Dll(s .........: user32.dll
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================

Global $__g_hAVLastWnd
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $__AVICONSTANT_ClassName = "SysAnimate32"
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _GUICtrlAVI_Close
; _GUICtrlAVI_Create
; _GUICtrlAVI_Destroy
; _GUICtrlAVI_IsPlaying
; _GUICtrlAVI_Open
; _GUICtrlAVI_OpenEx
; _GUICtrlAVI_Play
; _GUICtrlAVI_Seek
; _GUICtrlAVI_Show
; _GUICtrlAVI_Stop
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlAVI_Close($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $iRet = _SendMessage($hWnd, $ACM_OPENA)
	Return SetError(@error, @extended, $iRet <> 0)
EndFunc   ;==>_GUICtrlAVI_Close

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (Added params, Added Open calls "sets the avi to 1st frame")
; ===============================================================================================================================
Func _GUICtrlAVI_Create($hWnd, $sFilePath = "", $iSubFileID = -1, $iX = 0, $iY = 0, $iWidth = 0, $iHeight = 0, $iStyle = 0x00000006, $iExStyle = 0x00000000)
	If Not IsHWnd($hWnd) Then Return SetError(1, 0, 0) ; Invalid Window handle for 1st parameter
	If Not IsString($sFilePath) Then Return SetError(2, 0, 0) ; 2nd parameter not a string for _GUICtrlAVI_Create

	$iStyle = BitOR($iStyle, $__UDFGUICONSTANT_WS_CHILD, $__UDFGUICONSTANT_WS_VISIBLE)

	Local $nCtrlID = __UDF_GetNextGlobalID($hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	Local $hAVI = _WinAPI_CreateWindowEx($iExStyle, $__AVICONSTANT_ClassName, "", $iStyle, $iX, $iY, $iWidth, $iHeight, $hWnd, $nCtrlID)
	If $iSubFileID <> -1 And $sFilePath <> "" Then
		_GUICtrlAVI_OpenEx($hAVI, $sFilePath, $iSubFileID)
	ElseIf $sFilePath <> "" Then
		_GUICtrlAVI_Open($hAVI, $sFilePath)
	EndIf
	Return $hAVI
EndFunc   ;==>_GUICtrlAVI_Create

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlAVI_Destroy(ByRef $hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__AVICONSTANT_ClassName) Then Return SetError(2, 2, False)

	Local $iDestroyed = 0
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hAVLastWnd) Then
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
EndFunc   ;==>_GUICtrlAVI_Destroy

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlAVI_IsPlaying($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $ACM_ISPLAYING) <> 0
EndFunc   ;==>_GUICtrlAVI_IsPlaying

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (Added seek "sets the avi to 1st frame")
; ===============================================================================================================================
Func _GUICtrlAVI_Open($hWnd, $sFileName)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $iRet
	If _WinAPI_InProcess($hWnd, $__g_hAVLastWnd) Then
		$iRet = _SendMessage($hWnd, $ACM_OPENW, 0, $sFileName, 0, "wparam", "wstr")
	Else
		Local $tBuffer = DllStructCreate("wchar Text[" & StringLen($sFileName) + 1 & "]")
		DllStructSetData($tBuffer, "Text", $sFileName)
		Local $tMemMap
		_MemInit($hWnd, DllStructGetSize($tBuffer), $tMemMap)
		_MemWrite($tMemMap, $tBuffer)
		$iRet = _SendMessage($hWnd, $ACM_OPENW, True, $tBuffer, 0, "wparam", "struct*")
		_MemFree($tMemMap)
	EndIf
	If $iRet <> 0 Then _GUICtrlAVI_Seek($hWnd, 0)
	Return SetError(@error, @extended, $iRet <> 0)
EndFunc   ;==>_GUICtrlAVI_Open

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (Added seek "sets the avi to 1st frame")
; ===============================================================================================================================
Func _GUICtrlAVI_OpenEx($hWnd, $sFileName, $iResourceID)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $hInst = _WinAPI_LoadLibrary($sFileName)
	If @error Then Return SetError(@error, @extended, False)
	Local $iRet = _SendMessage($hWnd, $ACM_OPENW, $hInst, $iResourceID)
	_WinAPI_FreeLibrary($hInst)
	If $iRet <> 0 Then _GUICtrlAVI_Seek($hWnd, 0)
	Return SetError(@error, @extended, $iRet <> 0)
EndFunc   ;==>_GUICtrlAVI_OpenEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlAVI_Play($hWnd, $iFrom = 0, $iTo = -1, $iRepeat = -1)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $iRet = _SendMessage($hWnd, $ACM_PLAY, $iRepeat, _WinAPI_MakeLong($iFrom, $iTo))
	Return SetError(@error, @extended, $iRet <> 0)
EndFunc   ;==>_GUICtrlAVI_Play

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlAVI_Seek($hWnd, $iFrame)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $iRet = _SendMessage($hWnd, $ACM_PLAY, 1, _WinAPI_MakeLong($iFrame, $iFrame))
	Return SetError(@error, @extended, $iRet <> 0)
EndFunc   ;==>_GUICtrlAVI_Seek

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlAVI_Show($hWnd, $iState)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	If $iState <> @SW_HIDE And $iState <> @SW_SHOW Then Return SetError(1, 1, 0)
	Return _WinAPI_ShowWindow($hWnd, $iState)
EndFunc   ;==>_GUICtrlAVI_Show

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _GUICtrlAVI_Stop($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $iRet = _SendMessage($hWnd, $ACM_STOP)
	Return SetError(@error, @extended, $iRet <> 0)
EndFunc   ;==>_GUICtrlAVI_Stop
