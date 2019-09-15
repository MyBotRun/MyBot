#include-once

#include "Memory.au3"

; #INDEX# =======================================================================================================================
; Title .........: Clipboard
; AutoIt Version : 3.3.14.2
; Language ......: English
; Description ...: Functions that assist with Clipboard management.
;                  The clipboard is a set of functions and messages that enable applications to transfer data.
;                  Because  all applications have access to the clipboard, data can be easily transferred
;                  between applications  or  within  an application.
; Author(s) .....: Paul Campbell (PaulIA)
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $CF_TEXT = 1 ; Text format
Global Const $CF_BITMAP = 2 ; Handle to a bitmap (HBITMAP)
Global Const $CF_METAFILEPICT = 3 ; Handle to a metafile picture (METAFILEPICT)
Global Const $CF_SYLK = 4 ; Microsoft Symbolic Link (SYLK) format
Global Const $CF_DIF = 5 ; Software Arts' Data Interchange Format
Global Const $CF_TIFF = 6 ; Tagged image file format
Global Const $CF_OEMTEXT = 7 ; Text format containing characters in the OEM character set
Global Const $CF_DIB = 8 ; BITMAPINFO structure followed by the bitmap bits
Global Const $CF_PALETTE = 9 ; Handle to a color palette
Global Const $CF_PENDATA = 10 ; Data for the pen extensions to Pen Computing
Global Const $CF_RIFF = 11 ; Represents audio data in RIFF format
Global Const $CF_WAVE = 12 ; Represents audio data in WAVE format
Global Const $CF_UNICODETEXT = 13 ; Unicode text format
Global Const $CF_ENHMETAFILE = 14 ; Handle to an enhanced metafile (HENHMETAFILE)
Global Const $CF_HDROP = 15 ; Handle to type HDROP that identifies a list of files
Global Const $CF_LOCALE = 16 ; Handle to the locale identifier associated with text in the clipboard
Global Const $CF_DIBV5 = 17 ; BITMAPV5HEADER structure followed by bitmap color and the bitmap bits
Global Const $CF_OWNERDISPLAY = 0x0080 ; Owner display format
Global Const $CF_DSPTEXT = 0x0081 ; Text display format associated with a private format
Global Const $CF_DSPBITMAP = 0x0082 ; Bitmap display format associated with a private format
Global Const $CF_DSPMETAFILEPICT = 0x0083 ; Metafile picture display format associated with a private format
Global Const $CF_DSPENHMETAFILE = 0x008E ; Enhanced metafile display format associated with a private format
Global Const $CF_PRIVATEFIRST = 0x0200 ; Range of integer values for private clipboard formats
Global Const $CF_PRIVATELAST = 0x02FF ; Range of integer values for private clipboard formats
Global Const $CF_GDIOBJFIRST = 0x0300 ; Range for (GDI) object clipboard formats
Global Const $CF_GDIOBJLAST = 0x03FF ; Range for (GDI) object clipboard formats
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _ClipBoard_ChangeChain
; _ClipBoard_Close
; _ClipBoard_CountFormats
; _ClipBoard_Empty
; _ClipBoard_EnumFormats
; _ClipBoard_FormatStr
; _ClipBoard_GetData
; _ClipBoard_GetDataEx
; _ClipBoard_GetFormatName
; _ClipBoard_GetOpenWindow
; _ClipBoard_GetOwner
; _ClipBoard_GetPriorityFormat
; _ClipBoard_GetSequenceNumber
; _ClipBoard_GetViewer
; _ClipBoard_IsFormatAvailable
; _ClipBoard_Open
; _ClipBoard_RegisterFormat
; _ClipBoard_SetData
; _ClipBoard_SetDataEx
; _ClipBoard_SetViewer
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _ClipBoard_ChangeChain($hRemove, $hNewNext)
	DllCall("user32.dll", "bool", "ChangeClipboardChain", "hwnd", $hRemove, "hwnd", $hNewNext)
	If @error Then Return SetError(@error, @extended)
EndFunc   ;==>_ClipBoard_ChangeChain

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _ClipBoard_Close()
	Local $aResult = DllCall("user32.dll", "bool", "CloseClipboard")
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_ClipBoard_Close

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _ClipBoard_CountFormats()
	Local $aResult = DllCall("user32.dll", "int", "CountClipboardFormats")
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_ClipBoard_CountFormats

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _ClipBoard_Empty()
	Local $aResult = DllCall("user32.dll", "bool", "EmptyClipboard")
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_ClipBoard_Empty

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _ClipBoard_EnumFormats($iFormat)
	Local $aResult = DllCall("user32.dll", "uint", "EnumClipboardFormats", "uint", $iFormat)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_ClipBoard_EnumFormats

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; ===============================================================================================================================
Func _ClipBoard_FormatStr($iFormat)
	Local $aFormat[18] = [17, "Text", "Bitmap", "Metafile Picture", "SYLK", "DIF", "TIFF", "OEM Text", "DIB", "Palette", _
			"Pen Data", "RIFF", "WAVE", "Unicode Text", "Enhanced Metafile", "HDROP", "Locale", "DIB V5"]

	If $iFormat >= 1 And $iFormat <= 17 Then Return $aFormat[$iFormat]

	Switch $iFormat
		Case $CF_OWNERDISPLAY
			Return "Owner Display"
		Case $CF_DSPTEXT
			Return "Private Text"
		Case $CF_DSPBITMAP
			Return "Private Bitmap"
		Case $CF_DSPMETAFILEPICT
			Return "Private Metafile Picture"
		Case $CF_DSPENHMETAFILE
			Return "Private Enhanced Metafile"
		Case Else
			Return _ClipBoard_GetFormatName($iFormat)
	EndSwitch
EndFunc   ;==>_ClipBoard_FormatStr

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost,
; ===============================================================================================================================
Func _ClipBoard_GetData($iFormat = 1)
	If Not _ClipBoard_IsFormatAvailable($iFormat) Then Return SetError(-1, 0, 0)
	If Not _ClipBoard_Open(0) Then Return SetError(-2, 0, 0)
	Local $hMemory = _ClipBoard_GetDataEx($iFormat)

	;_ClipBoard_Close()		; moved to end: traditionally done *after* copying over the memory

	If $hMemory = 0 Then
		_ClipBoard_Close()
		Return SetError(-3, 0, 0)
	EndIf

	Local $pMemoryBlock = _MemGlobalLock($hMemory)

	If $pMemoryBlock = 0 Then
		_ClipBoard_Close()
		Return SetError(-4, 0, 0)
	EndIf

	; Get the actual memory size of the ClipBoard memory object (in bytes)
	Local $iDataSize = _MemGlobalSize($hMemory)

	If $iDataSize = 0 Then
		_MemGlobalUnlock($hMemory)
		_ClipBoard_Close()
		Return SetError(-5, 0, "")
	EndIf

	Local $tData
	Switch $iFormat
		Case $CF_TEXT, $CF_OEMTEXT
			$tData = DllStructCreate("char[" & $iDataSize & "]", $pMemoryBlock)
		Case $CF_UNICODETEXT
			; Round() shouldn't be necessary, as CF_UNICODETEXT should be 2-bytes wide & thus evenly-divisible
			$iDataSize = Round($iDataSize / 2)
			$tData = DllStructCreate("wchar[" & $iDataSize & "]", $pMemoryBlock)
		Case Else
			; Binary data return for all other formats
			$tData = DllStructCreate("byte[" & $iDataSize & "]", $pMemoryBlock)
	EndSwitch
	; Grab the data from the Structure so the Memory can be unlocked
	Local $vReturn = DllStructGetData($tData, 1)

	; Unlock the memory & Close the clipboard now that we have grabbed what we needed
	_MemGlobalUnlock($hMemory)
	_ClipBoard_Close()

	; Return the size of the string or binary object in @extended
	Return SetExtended($iDataSize, $vReturn)
EndFunc   ;==>_ClipBoard_GetData

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _ClipBoard_GetDataEx($iFormat = 1)
	Local $aResult = DllCall("user32.dll", "handle", "GetClipboardData", "uint", $iFormat)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_ClipBoard_GetDataEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Ascend4nt
; ===============================================================================================================================
Func _ClipBoard_GetFormatName($iFormat)
	Local $aResult = DllCall("user32.dll", "int", "GetClipboardFormatNameW", "uint", $iFormat, "wstr", "", "int", 4096)
	If @error Then Return SetError(@error, @extended, "")
	Return $aResult[2]
EndFunc   ;==>_ClipBoard_GetFormatName

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _ClipBoard_GetOpenWindow()
	Local $aResult = DllCall("user32.dll", "hwnd", "GetOpenClipboardWindow")
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_ClipBoard_GetOpenWindow

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _ClipBoard_GetOwner()
	Local $aResult = DllCall("user32.dll", "hwnd", "GetClipboardOwner")
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_ClipBoard_GetOwner

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _ClipBoard_GetPriorityFormat($aFormats)
	If Not IsArray($aFormats) Then Return SetError(-1, 0, 0)
	If $aFormats[0] <= 0 Then Return SetError(-2, 0, 0)

	Local $tData = DllStructCreate("uint[" & $aFormats[0] & "]")
	For $iI = 1 To $aFormats[0]
		DllStructSetData($tData, 1, $aFormats[$iI], $iI)
	Next

	Local $aResult = DllCall("user32.dll", "int", "GetPriorityClipboardFormat", "struct*", $tData, "int", $aFormats[0])
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_ClipBoard_GetPriorityFormat

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _ClipBoard_GetSequenceNumber()
	Local $aResult = DllCall("user32.dll", "dword", "GetClipboardSequenceNumber")
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_ClipBoard_GetSequenceNumber

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _ClipBoard_GetViewer()
	Local $aResult = DllCall("user32.dll", "hwnd", "GetClipboardViewer")
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_ClipBoard_GetViewer

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _ClipBoard_IsFormatAvailable($iFormat)
	Local $aResult = DllCall("user32.dll", "bool", "IsClipboardFormatAvailable", "uint", $iFormat)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_ClipBoard_IsFormatAvailable

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _ClipBoard_Open($hOwner)
	Local $aResult = DllCall("user32.dll", "bool", "OpenClipboard", "hwnd", $hOwner)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_ClipBoard_Open

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _ClipBoard_RegisterFormat($sFormat)
	Local $aResult = DllCall("user32.dll", "uint", "RegisterClipboardFormatW", "wstr", $sFormat)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_ClipBoard_RegisterFormat

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Ascend4nt
; ===============================================================================================================================
Func _ClipBoard_SetData($vData, $iFormat = 1)
	Local $tData, $hLock, $hMemory, $iSize

	; Special NULL case? (the option to provide clipboard formats upon request)
	If IsNumber($vData) And $vData = 0 Then
		; No need to allocate/set memory
		$hMemory = $vData
	Else
		; Test if the format is Binary or String format (only supported formats)
		If IsBinary($vData) Then
			$iSize = BinaryLen($vData)
		ElseIf IsString($vData) Then
			$iSize = StringLen($vData)
		Else
			; Unsupported data type
			Return SetError(2, 0, 0)
		EndIf
		$iSize += 1

		; Memory allocation is in bytes, yet Unicode text is 2-bytes wide
		If $iFormat = $CF_UNICODETEXT Then
			; Multiply $iSize (Character length for Unicode text) by 2 for Unicode
			$hMemory = _MemGlobalAlloc($iSize * 2, $GHND)
		Else
			$hMemory = _MemGlobalAlloc($iSize, $GHND)
		EndIf

		If $hMemory = 0 Then Return SetError(-1, 0, 0)
		$hLock = _MemGlobalLock($hMemory)
		If $hLock = 0 Then Return SetError(-2, 0, 0)

		Switch $iFormat
			Case $CF_TEXT, $CF_OEMTEXT
				$tData = DllStructCreate("char[" & $iSize & "]", $hLock)
			Case $CF_UNICODETEXT
				$tData = DllStructCreate("wchar[" & $iSize & "]", $hLock)
			Case Else
				; Every other type is treated as Binary, or ASCII Strings
				$tData = DllStructCreate("byte[" & $iSize & "]", $hLock)
		EndSwitch

		DllStructSetData($tData, 1, $vData)
		_MemGlobalUnlock($hMemory)
	EndIf

	If Not _ClipBoard_Open(0) Then Return SetError(-5, 0, 0)
	If Not _ClipBoard_Empty() Then
		_ClipBoard_Close()
		Return SetError(-6, 0, 0)
	EndIf
	If Not _ClipBoard_SetDataEx($hMemory, $iFormat) Then
		_ClipBoard_Close()
		Return SetError(-7, 0, 0)
	EndIf

	_ClipBoard_Close()
	Return $hMemory
EndFunc   ;==>_ClipBoard_SetData

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _ClipBoard_SetDataEx(ByRef $hMemory, $iFormat = 1)
	Local $aResult = DllCall("user32.dll", "handle", "SetClipboardData", "uint", $iFormat, "handle", $hMemory)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_ClipBoard_SetDataEx

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _ClipBoard_SetViewer($hViewer)
	Local $aResult = DllCall("user32.dll", "hwnd", "SetClipboardViewer", "hwnd", $hViewer)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_ClipBoard_SetViewer
