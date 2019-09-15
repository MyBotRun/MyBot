#include-once

#include "StructureConstants.au3"

; #INDEX# =======================================================================================================================
; Title .........: Pipes
; AutoIt Version : 3.3.14.2
; Language ......: English
; Description ...: Functions that assist with Named Pipes.
;                  A named pipe is a named, one-way or duplex pipe for communication between the pipe server and one or more pipe
;                  clients.  All instances of a named pipe share the same pipe name, but each instance has its  own  buffers  and
;                  handles, and provides a separate conduit for  client  server  communication.  The  use  of  instances  enables
;                  multiple pipe clients to use the same named pipe simultaneously.  Any process can access named pipes,  subject
;                  to security checks, making named pipes an easy form of communication between related or  unrelated  processes.
;                  Any process can act as both a server and a client, making peer-to-peer communication possible.  As used  here,
;                  the term pipe server refers to a process that creates a named pipe, and the  term  pipe  client  refers  to  a
;                  process that connects to an instance of a named pipe. Named pipes can be used to provide communication between
;                  processes on the same computer or between processes on different computers across a  network.  If  the  server
;                  service is running, all named pipes are accessible remotely.
; Author(s) .....: Paul Campbell (PaulIA)
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $PIPE_FLAG_FIRST_PIPE_INSTANCE = 1
Global Const $PIPE_FLAG_OVERLAPPED = 2
Global Const $PIPE_FLAG_WRITE_THROUGH = 4

Global Const $__FILE_FLAG_FIRST_PIPE_INSTANCE = 0x00080000
Global Const $__FILE_FLAG_OVERLAPPED = 0x40000000
Global Const $__FILE_FLAG_WRITE_THROUGH = 0x80000000

Global Const $__PIPE_ACCESS_INBOUND = 0x00000001
Global Const $__PIPE_ACCESS_OUTBOUND = 0x00000002
Global Const $__PIPE_ACCESS_DUPLEX = 0x00000003

Global Const $__PIPE_WAIT = 0x00000000
Global Const $__PIPE_NOWAIT = 0x00000001

Global Const $__PIPE_READMODE_BYTE = 0x00000000
Global Const $__PIPE_READMODE_MESSAGE = 0x00000002

Global Const $__PIPE_TYPE_BYTE = 0x00000000
Global Const $__PIPE_TYPE_MESSAGE = 0x00000004

Global Const $__PIPE_CLIENT_END = 0x00000000
Global Const $__PIPE_SERVER_END = 0x00000001

Global Const $__WRITE_DAC = 0x00040000
Global Const $__WRITE_OWNER = 0x00080000
Global Const $__ACCESS_SYSTEM_SECURITY = 0x01000000
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _NamedPipes_CallNamedPipe
; _NamedPipes_ConnectNamedPipe
; _NamedPipes_CreateNamedPipe
; _NamedPipes_CreatePipe
; _NamedPipes_DisconnectNamedPipe
; _NamedPipes_GetNamedPipeHandleState
; _NamedPipes_GetNamedPipeInfo
; _NamedPipes_PeekNamedPipe
; _NamedPipes_SetNamedPipeHandleState
; _NamedPipes_TransactNamedPipe
; _NamedPipes_WaitNamedPipe
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _NamedPipes_CallNamedPipe($sPipeName, $pInpBuf, $iInpSize, $pOutBuf, $iOutSize, ByRef $iRead, $iTimeOut = 0)
	Local $aResult = DllCall("kernel32.dll", "bool", "CallNamedPipeW", "wstr", $sPipeName, "struct*", $pInpBuf, "dword", $iInpSize, "struct*", $pOutBuf, _
			"dword", $iOutSize, "dword*", 0, "dword", $iTimeOut)
	If @error Then Return SetError(@error, @extended, False)
	$iRead = $aResult[6]
	Return $aResult[0]
EndFunc   ;==>_NamedPipes_CallNamedPipe

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _NamedPipes_ConnectNamedPipe($hNamedPipe, $tOverlapped = 0)
	Local $aResult = DllCall("kernel32.dll", "bool", "ConnectNamedPipe", "handle", $hNamedPipe, "struct*", $tOverlapped)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_NamedPipes_ConnectNamedPipe

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _NamedPipes_CreateNamedPipe($sName, $iAccess = 2, $iFlags = 2, $iACL = 0, $iType = 1, $iRead = 1, $iWait = 0, $iMaxInst = 25, _
		$iOutBufSize = 4096, $iInpBufSize = 4096, $iDefaultTimeout = 5000, $tSecurity = 0)
	Local $iOpenMode, $iPipeMode

	Switch $iAccess
		Case 1
			$iOpenMode = $__PIPE_ACCESS_OUTBOUND
		Case 2
			$iOpenMode = $__PIPE_ACCESS_DUPLEX
		Case Else
			$iOpenMode = $__PIPE_ACCESS_INBOUND
	EndSwitch
	If BitAND($iFlags, 1) <> 0 Then $iOpenMode = BitOR($iOpenMode, $__FILE_FLAG_FIRST_PIPE_INSTANCE)
	If BitAND($iFlags, 2) <> 0 Then $iOpenMode = BitOR($iOpenMode, $__FILE_FLAG_OVERLAPPED)
	If BitAND($iFlags, 4) <> 0 Then $iOpenMode = BitOR($iOpenMode, $__FILE_FLAG_WRITE_THROUGH)

	If BitAND($iACL, 1) <> 0 Then $iOpenMode = BitOR($iOpenMode, $__WRITE_DAC)
	If BitAND($iACL, 2) <> 0 Then $iOpenMode = BitOR($iOpenMode, $__WRITE_OWNER)
	If BitAND($iACL, 4) <> 0 Then $iOpenMode = BitOR($iOpenMode, $__ACCESS_SYSTEM_SECURITY)

	Switch $iType
		Case 1
			$iPipeMode = $__PIPE_TYPE_MESSAGE
		Case Else
			$iPipeMode = $__PIPE_TYPE_BYTE
	EndSwitch

	Switch $iRead
		Case 1
			$iPipeMode = BitOR($iPipeMode, $__PIPE_READMODE_MESSAGE)
		Case Else
			$iPipeMode = BitOR($iPipeMode, $__PIPE_READMODE_BYTE)
	EndSwitch

	Switch $iWait
		Case 1
			$iPipeMode = BitOR($iPipeMode, $__PIPE_NOWAIT)
		Case Else
			$iPipeMode = BitOR($iPipeMode, $__PIPE_WAIT)
	EndSwitch

	Local $aResult = DllCall("kernel32.dll", "handle", "CreateNamedPipeW", "wstr", $sName, "dword", $iOpenMode, "dword", $iPipeMode, "dword", $iMaxInst, _
			"dword", $iOutBufSize, "dword", $iInpBufSize, "dword", $iDefaultTimeout, "struct*", $tSecurity)
	If @error Then Return SetError(@error, @extended, -1)
	Return $aResult[0]
EndFunc   ;==>_NamedPipes_CreateNamedPipe

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _NamedPipes_CreatePipe(ByRef $hReadPipe, ByRef $hWritePipe, $tSecurity = 0, $iSize = 0)
	Local $aResult = DllCall("kernel32.dll", "bool", "CreatePipe", "handle*", 0, "handle*", 0, "struct*", $tSecurity, "dword", $iSize)
	If @error Then Return SetError(@error, @extended, False)
	$hReadPipe = $aResult[1] ; read pipe handle
	$hWritePipe = $aResult[2] ; write pipe handle
	Return $aResult[0]
EndFunc   ;==>_NamedPipes_CreatePipe

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _NamedPipes_DisconnectNamedPipe($hNamedPipe)
	Local $aResult = DllCall("kernel32.dll", "bool", "DisconnectNamedPipe", "handle", $hNamedPipe)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_NamedPipes_DisconnectNamedPipe

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _NamedPipes_GetNamedPipeHandleState($hNamedPipe)
	Local $aResult = DllCall("kernel32.dll", "bool", "GetNamedPipeHandleStateW", "handle", $hNamedPipe, "dword*", 0, "dword*", 0, _
			"dword*", 0, "dword*", 0, "wstr", "", "dword", 4096)
	If @error Then Return SetError(@error, @extended, 0)
	Local $aState[6]
	$aState[0] = BitAND($aResult[2], $__PIPE_NOWAIT) <> 0 ;	State
	$aState[1] = BitAND($aResult[2], $__PIPE_READMODE_MESSAGE) <> 0 ;	State
	$aState[2] = $aResult[3] ;	CurInst
	$aState[3] = $aResult[4] ;	MaxCount
	$aState[4] = $aResult[5] ;	TimeOut
	$aState[5] = $aResult[6] ;	Username
	Return SetError(0, $aResult[0], $aState)
EndFunc   ;==>_NamedPipes_GetNamedPipeHandleState

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _NamedPipes_GetNamedPipeInfo($hNamedPipe)
	Local $aResult = DllCall("kernel32.dll", "bool", "GetNamedPipeInfo", "handle", $hNamedPipe, "dword*", 0, "dword*", 0, "dword*", 0, _
			"dword*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Local $aInfo[5]
	$aInfo[0] = BitAND($aResult[2], $__PIPE_SERVER_END) <> 0 ; Flags
	$aInfo[1] = BitAND($aResult[2], $__PIPE_TYPE_MESSAGE) <> 0 ; Flags
	$aInfo[2] = $aResult[3] ; OutSize
	$aInfo[3] = $aResult[4] ; InpSize
	$aInfo[4] = $aResult[5] ; MaxInst
	Return SetError(0, $aResult[0], $aInfo)
EndFunc   ;==>_NamedPipes_GetNamedPipeInfo

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _NamedPipes_PeekNamedPipe($hNamedPipe)
	Local $tBuffer = DllStructCreate("char Text[4096]")

	Local $aResult = DllCall("kernel32.dll", "bool", "PeekNamedPipe", "handle", $hNamedPipe, "struct*", $tBuffer, "int", 4096, "dword*", 0, _
			"dword*", 0, "dword*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Local $aInfo[4]
	$aInfo[0] = DllStructGetData($tBuffer, "Text")
	$aInfo[1] = $aResult[4] ; Read
	$aInfo[2] = $aResult[5] ; Total
	$aInfo[3] = $aResult[6] ; Left
	Return SetError(0, $aResult[0], $aInfo)
EndFunc   ;==>_NamedPipes_PeekNamedPipe

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _NamedPipes_SetNamedPipeHandleState($hNamedPipe, $iRead, $iWait, $iBytes = 0, $iTimeOut = 0)
	Local $iMode = 0, $pBytes = 0, $pTimeOut = 0

	Local $tInt = DllStructCreate("dword Bytes;dword Timeout")
	If $iRead = 1 Then $iMode = BitOR($iMode, $__PIPE_READMODE_MESSAGE)
	If $iWait = 1 Then $iMode = BitOR($iMode, $__PIPE_NOWAIT)

	If $iBytes <> 0 Then
		$pBytes = DllStructGetPtr($tInt, "Bytes")
		DllStructSetData($tInt, "Bytes", $iBytes)
	EndIf

	If $iTimeOut <> 0 Then
		$pTimeOut = DllStructGetPtr($tInt, "TimeOut")
		DllStructSetData($tInt, "TimeOut", $iTimeOut)
	EndIf

	Local $aResult = DllCall("kernel32.dll", "bool", "SetNamedPipeHandleState", "handle", $hNamedPipe, "dword*", $iMode, "ptr", $pBytes, "ptr", $pTimeOut)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_NamedPipes_SetNamedPipeHandleState

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _NamedPipes_TransactNamedPipe($hNamedPipe, $pInpBuf, $iInpSize, $pOutBuf, $iOutSize, $tOverlapped = 0)
	Local $aResult = DllCall("kernel32.dll", "bool", "TransactNamedPipe", "handle", $hNamedPipe, "struct*", $pInpBuf, "dword", $iInpSize, _
			"struct*", $pOutBuf, "dword", $iOutSize, "dword*", 0, "struct*", $tOverlapped)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetError(0, $aResult[0], $aResult[6])
EndFunc   ;==>_NamedPipes_TransactNamedPipe

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _NamedPipes_WaitNamedPipe($sPipeName, $iTimeOut = 0)
	Local $aResult = DllCall("kernel32.dll", "bool", "WaitNamedPipeW", "wstr", $sPipeName, "dword", $iTimeOut)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_NamedPipes_WaitNamedPipe
