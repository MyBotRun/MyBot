#include-once

#include "Date.au3"
#include "FileConstants.au3"
#include "StructureConstants.au3"
#include "WinAPIError.au3"

; #INDEX# =======================================================================================================================
; Title .........: FTP
; AutoIt Version : 3.3.14.2
; Language ......: English
; Description ...: Functions that assist with FTP.
; Author(s) .....: Wouter, Prog@ndy, jpm, Beege
; Notes .........: based on FTP_Ex.au3 16/02/2009 http://www.autoit.de/index.php?page=Thread&postID=48393
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
Global $__g_hWinInet_FTP = -1
Global $__g_hCallback_FTP, $__g_bCallback_FTP = False
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $INTERNET_OPEN_TYPE_DIRECT = 1
Global Const $INTERNET_OPEN_TYPE_PRECONFIG = 0
Global Const $INTERNET_OPEN_TYPE_PRECONFIG_WITH_NO_AUTOPROXY = 4
Global Const $INTERNET_OPEN_TYPE_PROXY = 3

Global Const $FTP_TRANSFER_TYPE_UNKNOWN = 0 ;Defaults to FTP_TRANSFER_TYPE_BINARY.
Global Const $FTP_TRANSFER_TYPE_ASCII = 1 ;Type A transfer method. Control and formatting information is converted to local equivalents.
Global Const $FTP_TRANSFER_TYPE_BINARY = 2 ;Type I transfer method. The file is transferred exactly as it exists with no changes.

Global Const $INTERNET_FLAG_PASSIVE = 0x08000000
Global Const $INTERNET_FLAG_TRANSFER_ASCII = $FTP_TRANSFER_TYPE_ASCII
Global Const $INTERNET_FLAG_TRANSFER_BINARY = $FTP_TRANSFER_TYPE_BINARY

Global Const $INTERNET_DEFAULT_FTP_PORT = 21
Global Const $INTERNET_SERVICE_FTP = 1

; _FTP_FindFileFirst flags
Global Const $INTERNET_FLAG_HYPERLINK = 0x00000400
Global Const $INTERNET_FLAG_NEED_FILE = 0x00000010
Global Const $INTERNET_FLAG_NO_CACHE_WRITE = 0x04000000
Global Const $INTERNET_FLAG_RELOAD = 0x80000000
Global Const $INTERNET_FLAG_RESYNCHRONIZE = 0x00000800

; _FTP_Open flags
Global Const $INTERNET_FLAG_ASYNC = 0x10000000
Global Const $INTERNET_FLAG_FROM_CACHE = 0x01000000
Global Const $INTERNET_FLAG_OFFLINE = $INTERNET_FLAG_FROM_CACHE

; _FTP_...() Status
Global Const $INTERNET_STATUS_CLOSING_CONNECTION = 50
Global Const $INTERNET_STATUS_CONNECTION_CLOSED = 51
Global Const $INTERNET_STATUS_CONNECTING_TO_SERVER = 20
Global Const $INTERNET_STATUS_CONNECTED_TO_SERVER = 21
Global Const $INTERNET_STATUS_CTL_RESPONSE_RECEIVED = 42
Global Const $INTERNET_STATUS_INTERMEDIATE_RESPONSE = 120
Global Const $INTERNET_STATUS_PREFETCH = 43
Global Const $INTERNET_STATUS_REDIRECT = 110
Global Const $INTERNET_STATUS_REQUEST_COMPLETE = 100
Global Const $INTERNET_STATUS_HANDLE_CREATED = 60
Global Const $INTERNET_STATUS_HANDLE_CLOSING = 70
Global Const $INTERNET_STATUS_SENDING_REQUEST = 30
Global Const $INTERNET_STATUS_REQUEST_SENT = 31
Global Const $INTERNET_STATUS_RECEIVING_RESPONSE = 40
Global Const $INTERNET_STATUS_RESPONSE_RECEIVED = 41
Global Const $INTERNET_STATUS_STATE_CHANGE = 200
Global Const $INTERNET_STATUS_RESOLVING_NAME = 10
Global Const $INTERNET_STATUS_NAME_RESOLVED = 11
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _FTP_Close
; _FTP_Command
; _FTP_Connect
; _FTP_DecodeInternetStatus
; _FTP_DirCreate
; _FTP_DirDelete
; _FTP_DirGetCurrent
; _FTP_DirPutContents
; _FTP_DirSetCurrent
; _FTP_FileClose
; _FTP_FileDelete
; _FTP_FileGet
; _FTP_FileGetSize
; _FTP_FileOpen
; _FTP_FilePut
; _FTP_FileRead
; _FTP_FileRename
; _FTP_FileTimeLoHiToStr
; _FTP_FindFileClose
; _FTP_FindFileFirst
; _FTP_FindFileNext
; _FTP_GetLastResponseInfo
; _FTP_ListToArray
; _FTP_ListToArray2D
; _FTP_ListToArrayEx
; _FTP_Open
; _FTP_ProgressDownload
; _FTP_ProgressUpload
; _FTP_SetStatusCallback
; ===============================================================================================================================

; #INTERNAL_USE_ONLY#============================================================================================================
; __FTP_ListToArray
; __FTP_Init
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Author ........: Wouter van Kesteren
; Modified.......: Beege
; ===============================================================================================================================
Func _FTP_Close($hSession)
	If $__g_hWinInet_FTP = -1 Then Return SetError(-2, 0, 0)
	Local $aDone = DllCall($__g_hWinInet_FTP, 'bool', 'InternetCloseHandle', 'handle', $hSession)
	If @error Or $aDone[0] = 0 Then Return SetError(-1, _WinAPI_GetLastError(), 0)

	If $__g_bCallback_FTP = True Then DllCallbackFree($__g_hCallback_FTP)

	Return $aDone[0]
EndFunc   ;==>_FTP_Close

; #FUNCTION# ====================================================================================================================
; Author ........: Bill Mezian
; Modified.......:
; ===============================================================================================================================
Func _FTP_Command($hFTPSession, $sFTPCommand, $iFlags = $FTP_TRANSFER_TYPE_ASCII, $iExpectResponse = 0, $iContext = 0)
	If $__g_hWinInet_FTP = -1 Then Return SetError(-2, 0, 0)
	Local $ai_FTPCommand = DllCall($__g_hWinInet_FTP, 'bool', 'FtpCommandW', 'handle', $hFTPSession, 'bool', $iExpectResponse, 'dword', $iFlags, 'wstr', $sFTPCommand, 'dword_ptr', $iContext, 'ptr*', 0)
	If @error Or $ai_FTPCommand[0] = 0 Then Return SetError(-1, _WinAPI_GetLastError(), 0)

	Return SetError(0, $ai_FTPCommand[6], $ai_FTPCommand[0])
EndFunc   ;==>_FTP_Command

; #FUNCTION# ====================================================================================================================
; Author ........: Wouter van Kesteren
; Modified.......:
; ===============================================================================================================================
Func _FTP_Connect($hInternetSession, $sServerName, $sUsername, $sPassword, $iPassive = 0, $iServerPort = 0, $iService = $INTERNET_SERVICE_FTP, $iFlags = 0, $fuContext = 0)
	If $__g_hWinInet_FTP = -1 Then Return SetError(-2, 0, 0)
	If $iPassive == 1 Then $iFlags = BitOR($iFlags, $INTERNET_FLAG_PASSIVE)
	Local $ai_InternetConnect = DllCall($__g_hWinInet_FTP, 'hwnd', 'InternetConnectW', 'handle', $hInternetSession, 'wstr', $sServerName, 'ushort', $iServerPort, 'wstr', $sUsername, 'wstr', $sPassword, 'dword', $iService, 'dword', $iFlags, 'dword_ptr', $fuContext)
	If @error Or $ai_InternetConnect[0] = 0 Then Return SetError(-1, _WinAPI_GetLastError(), 0)

	Return $ai_InternetConnect[0]
EndFunc   ;==>_FTP_Connect

; #FUNCTION# ====================================================================================================================
; Author ........: Beege
; Modified.......: jpm
; ===============================================================================================================================
Func _FTP_DecodeInternetStatus($iInternetStatus)
	Switch $iInternetStatus
		Case $INTERNET_STATUS_CLOSING_CONNECTION
			Return 'Closing connection ...'

		Case $INTERNET_STATUS_CONNECTION_CLOSED
			Return 'Connection closed'

		Case $INTERNET_STATUS_CONNECTING_TO_SERVER
			Return 'Connecting to server ...'

		Case $INTERNET_STATUS_CONNECTED_TO_SERVER
			Return 'Connected to server'

		Case $INTERNET_STATUS_CTL_RESPONSE_RECEIVED
			Return 'CTL esponse received'

		Case $INTERNET_STATUS_INTERMEDIATE_RESPONSE
			Return 'Intermediate response'

		Case $INTERNET_STATUS_PREFETCH
			Return 'Prefetch'

		Case $INTERNET_STATUS_REDIRECT
			Return 'Redirect'

		Case $INTERNET_STATUS_REQUEST_COMPLETE
			Return 'Request complete'

		Case $INTERNET_STATUS_HANDLE_CREATED
			Return 'Handle created'

		Case $INTERNET_STATUS_HANDLE_CLOSING
			Return 'Handle closing ...'

		Case $INTERNET_STATUS_SENDING_REQUEST
			Return 'Sending request ...'

		Case $INTERNET_STATUS_REQUEST_SENT
			Return 'Request sent'

		Case $INTERNET_STATUS_RECEIVING_RESPONSE
			Return 'Receiving response ...'

		Case $INTERNET_STATUS_RESPONSE_RECEIVED
			Return 'Response received'

		Case $INTERNET_STATUS_STATE_CHANGE
			Return 'State change'

		Case $INTERNET_STATUS_RESOLVING_NAME
			Return 'Resolving name ...'

		Case $INTERNET_STATUS_NAME_RESOLVED
			Return 'Name resolved'
		Case Else
			Return 'UNKNOWN status = ' & $iInternetStatus
	EndSwitch
EndFunc   ;==>_FTP_DecodeInternetStatus

; #FUNCTION# ====================================================================================================================
; Author ........: Wouter van Kesteren
; Modified.......:
; ===============================================================================================================================
Func _FTP_DirCreate($hFTPSession, $sRemote)
	If $__g_hWinInet_FTP = -1 Then Return SetError(-2, 0, 0)
	Local $ai_FTPMakeDir = DllCall($__g_hWinInet_FTP, 'bool', 'FtpCreateDirectoryW', 'handle', $hFTPSession, 'wstr', $sRemote)
	If @error Or $ai_FTPMakeDir[0] = 0 Then Return SetError(-1, _WinAPI_GetLastError(), 0)

	Return $ai_FTPMakeDir[0]
EndFunc   ;==>_FTP_DirCreate

; #FUNCTION# ====================================================================================================================
; Author ........: Wouter van Kesteren
; Modified.......:
; ===============================================================================================================================
Func _FTP_DirDelete($hFTPSession, $sRemote)
	If $__g_hWinInet_FTP = -1 Then Return SetError(-2, 0, 0)
	Local $ai_FTPDelDir = DllCall($__g_hWinInet_FTP, 'bool', 'FtpRemoveDirectoryW', 'handle', $hFTPSession, 'wstr', $sRemote)
	If @error Or $ai_FTPDelDir[0] = 0 Then Return SetError(-1, _WinAPI_GetLastError(), 0)

	Return $ai_FTPDelDir[0]
EndFunc   ;==>_FTP_DirDelete

; #FUNCTION# ====================================================================================================================
; Author ........: Beast
; Modified.......:
; ===============================================================================================================================
Func _FTP_DirGetCurrent($hFTPSession)
	If $__g_hWinInet_FTP = -1 Then Return SetError(-2, 0, 0)
	Local $ai_FTPGetCurrentDir = DllCall($__g_hWinInet_FTP, 'bool', 'FtpGetCurrentDirectoryW', 'handle', $hFTPSession, 'wstr', "", 'dword*', 260)
	If @error Or $ai_FTPGetCurrentDir[0] = 0 Then Return SetError(-1, _WinAPI_GetLastError(), 0)

	Return $ai_FTPGetCurrentDir[2]
EndFunc   ;==>_FTP_DirGetCurrent

; #FUNCTION# ====================================================================================================================
; Author ........: Stumpii
; Modified.......:
; ===============================================================================================================================
Func _FTP_DirPutContents($hFTPSession, $sLocalFolder, $sRemoteFolder, $bRecursivePut, $iContext = 0)
	If StringRight($sLocalFolder, 1) == "\" Then $sLocalFolder = StringTrimRight($sLocalFolder, 1)
	; Shows the filenames of all files in the current directory.
	Local $hSearch = FileFindFirstFile($sLocalFolder & "\*.*")

	; Check if the search was successful
	If $hSearch = -1 Then Return SetError(1, 0, 0)

	Local $sFile
	While 1
		$sFile = FileFindNextFile($hSearch)
		If @error Then ExitLoop
		If StringInStr(FileGetAttrib($sLocalFolder & "\" & $sFile), "D") Then
			_FTP_DirCreate($hFTPSession, $sRemoteFolder & "/" & $sFile)
			If $bRecursivePut Then
				_FTP_DirPutContents($hFTPSession, $sLocalFolder & "\" & $sFile, $sRemoteFolder & "/" & $sFile, $bRecursivePut, $iContext)
			EndIf
		Else
			_FTP_FilePut($hFTPSession, $sLocalFolder & "\" & $sFile, $sRemoteFolder & "/" & $sFile, 0, $iContext)
		EndIf
	WEnd

	; Close the search handle
	FileClose($hSearch)
	Return 1
EndFunc   ;==>_FTP_DirPutContents

; #FUNCTION# ====================================================================================================================
; Author ........: Beast
; Modified.......:
; ===============================================================================================================================
Func _FTP_DirSetCurrent($hFTPSession, $sRemote)
	If $__g_hWinInet_FTP = -1 Then Return SetError(-2, 0, 0)
	Local $ai_FTPSetCurrentDir = DllCall($__g_hWinInet_FTP, 'bool', 'FtpSetCurrentDirectoryW', 'handle', $hFTPSession, 'wstr', $sRemote)
	If @error Or $ai_FTPSetCurrentDir[0] = 0 Then Return SetError(-1, _WinAPI_GetLastError(), 0)

	Return $ai_FTPSetCurrentDir[0]
EndFunc   ;==>_FTP_DirSetCurrent

; #FUNCTION# ====================================================================================================================
; Author ........: joeyb1275
; Modified.......: Prog@ndy
; ===============================================================================================================================
Func _FTP_FileClose($hFTPFile)
	If $__g_hWinInet_FTP = -1 Then Return SetError(-2, 0, 0)
	Local $aDone = DllCall($__g_hWinInet_FTP, 'bool', 'InternetCloseHandle', 'handle', $hFTPFile)
	If @error Or $aDone[0] = 0 Then Return SetError(-1, _WinAPI_GetLastError(), 0)

	Return $aDone[0]
EndFunc   ;==>_FTP_FileClose

; #FUNCTION# ====================================================================================================================
; Author ........: Wouter van Kesteren
; Modified.......:
; ===============================================================================================================================
Func _FTP_FileDelete($hFTPSession, $sRemoteFile)
	If $__g_hWinInet_FTP = -1 Then Return SetError(-2, 0, 0)
	Local $ai_FTPPutFile = DllCall($__g_hWinInet_FTP, 'bool', 'FtpDeleteFileW', 'handle', $hFTPSession, 'wstr', $sRemoteFile)
	If @error Or $ai_FTPPutFile[0] = 0 Then Return SetError(-1, _WinAPI_GetLastError(), 0)

	Return $ai_FTPPutFile[0]
EndFunc   ;==>_FTP_FileDelete

; #FUNCTION# ====================================================================================================================
; Author ........: Wouter van Kesteren
; Modified.......:
; ===============================================================================================================================
Func _FTP_FileGet($hFTPSession, $sRemoteFile, $sLocalFile, $bFailIfExists = False, $iFlagsAndAttributes = 0, $iFlags = $FTP_TRANSFER_TYPE_UNKNOWN, $iContext = 0)
	If $__g_hWinInet_FTP = -1 Then Return SetError(-2, 0, 0)
	Local $ai_FTPGetFile = DllCall($__g_hWinInet_FTP, 'bool', 'FtpGetFileW', 'handle', $hFTPSession, 'wstr', $sRemoteFile, 'wstr', $sLocalFile, 'bool', $bFailIfExists, 'dword', $iFlagsAndAttributes, 'dword', $iFlags, 'dword_ptr', $iContext)
	If @error Or $ai_FTPGetFile[0] = 0 Then Return SetError(-1, _WinAPI_GetLastError(), 0)

	Return $ai_FTPGetFile[0]
EndFunc   ;==>_FTP_FileGet

; #FUNCTION# ====================================================================================================================
; Author ........: Joachim de Koning
; Modified.......: jpm
; ===============================================================================================================================
Func _FTP_FileGetSize($hFTPSession, $sFileName)
	If $__g_hWinInet_FTP = -1 Then Return SetError(-2, 0, 0)
	Local $ai_FTPGetSizeHandle = DllCall($__g_hWinInet_FTP, 'handle', 'FtpOpenFileW', 'handle', $hFTPSession, 'wstr', $sFileName, 'dword', $GENERIC_READ, 'dword', $INTERNET_FLAG_NO_CACHE_WRITE + $INTERNET_FLAG_TRANSFER_BINARY, 'dword_ptr', 0)
	If @error Or $ai_FTPGetSizeHandle[0] = 0 Then Return SetError(-1, _WinAPI_GetLastError(), 0)

	Local $ai_FTPGetFileSize = DllCall($__g_hWinInet_FTP, 'dword', 'FtpGetFileSize', 'handle', $ai_FTPGetSizeHandle[0], 'dword*', 0)
	If @error Or $ai_FTPGetFileSize[0] = 0 Then
		Local $iLasterror = _WinAPI_GetLastError()
		DllCall($__g_hWinInet_FTP, 'bool', 'InternetCloseHandle', 'handle', $ai_FTPGetSizeHandle[0])
		; No need to test @error.

		Return SetError(-1, $iLasterror, 0)
	EndIf

	DllCall($__g_hWinInet_FTP, 'bool', 'InternetCloseHandle', 'handle', $ai_FTPGetSizeHandle[0])
	; No need to test @error.

	Return _WinAPI_MakeQWord($ai_FTPGetFileSize[0], $ai_FTPGetFileSize[2])
EndFunc   ;==>_FTP_FileGetSize

; #FUNCTION# ====================================================================================================================
; Author ........: joeyb1275
; Modified.......: Prog@ndy
; ===============================================================================================================================
Func _FTP_FileOpen($hConnect, $sFileName, $iAccess = $GENERIC_READ, $iFlags = $INTERNET_FLAG_TRANSFER_BINARY, $iContext = 0)
	If $__g_hWinInet_FTP = -1 Then Return SetError(-2, 0, 0)
	Local $ai_FtpOpenfile = DllCall($__g_hWinInet_FTP, 'handle', 'FtpOpenFileW', 'handle', $hConnect, 'wstr', $sFileName, 'dword', $iAccess, 'dword', $iFlags, 'dword_ptr', $iContext)
	If @error Or $ai_FtpOpenfile[0] == 0 Then Return SetError(-1, _WinAPI_GetLastError(), 0)

	Return $ai_FtpOpenfile[0]
EndFunc   ;==>_FTP_FileOpen

; #FUNCTION# ====================================================================================================================
; Author ........: Wouter van Kesteren
; Modified.......:
; ===============================================================================================================================
Func _FTP_FilePut($hFTPSession, $sLocalFile, $sRemoteFile, $iFlags = 0, $iContext = 0)
	If $__g_hWinInet_FTP = -1 Then Return SetError(-2, 0, 0)
	Local $ai_FTPPutFile = DllCall($__g_hWinInet_FTP, 'bool', 'FtpPutFileW', 'handle', $hFTPSession, 'wstr', $sLocalFile, 'wstr', $sRemoteFile, 'dword', $iFlags, 'dword_ptr', $iContext)
	If @error Or $ai_FTPPutFile[0] = 0 Then Return SetError(-1, _WinAPI_GetLastError(), 0)

	Return $ai_FTPPutFile[0]
EndFunc   ;==>_FTP_FilePut

; #FUNCTION# ====================================================================================================================
; Author ........: joeyb1275
; Modified.......: Prog@ndy
; ===============================================================================================================================
Func _FTP_FileRead($hFTPFile, $iNumberOfBytesToRead)
	If $__g_hWinInet_FTP = -1 Then Return SetError(-2, 0, 0)
	Local $tBuffer = DllStructCreate("byte[" & $iNumberOfBytesToRead & "]")

	Local $ai_FTPReadFile = DllCall($__g_hWinInet_FTP, 'bool', 'InternetReadFile', 'handle', $hFTPFile, 'struct*', $tBuffer, 'dword', $iNumberOfBytesToRead, 'dword*', 0) ;LPDWORD lpdwNumberOfBytesRead
	If @error Then Return SetError(1, _WinAPI_GetLastError(), 0)

	Local $iNumberOfBytesRead = $ai_FTPReadFile[4]
	If $iNumberOfBytesRead == 0 And $ai_FTPReadFile[0] == 1 Then
		Return SetError(-1, 0, 0)
	ElseIf $ai_FTPReadFile[0] == 0 Then
		Return SetError(2, _WinAPI_GetLastError(), 0)
	EndIf

	Local $s_FileRead
	If $iNumberOfBytesToRead > $iNumberOfBytesRead Then
		$s_FileRead = BinaryMid(DllStructGetData($tBuffer, 1), 1, $iNumberOfBytesRead) ;index is omitted so the entire array is written into $s_FileRead as a BinaryString
	Else
		$s_FileRead = DllStructGetData($tBuffer, 1) ;index is omitted so the entire array is written into $s_FileRead as a BinaryString
	EndIf

	Return SetError(0, $iNumberOfBytesRead, $s_FileRead)
EndFunc   ;==>_FTP_FileRead

; #FUNCTION# ====================================================================================================================
; Author ........: Wouter van Kesteren
; Modified.......:
; ===============================================================================================================================
Func _FTP_FileRename($hFTPSession, $sExisting, $sNew)
	If $__g_hWinInet_FTP = -1 Then Return SetError(-2, 0, 0)
	Local $ai_FTPRenameFile = DllCall($__g_hWinInet_FTP, 'bool', 'FtpRenameFileW', 'handle', $hFTPSession, 'wstr', $sExisting, 'wstr', $sNew)
	If @error Or $ai_FTPRenameFile[0] = 0 Then Return SetError(-1, _WinAPI_GetLastError(), 0)

	Return $ai_FTPRenameFile[0]
EndFunc   ;==>_FTP_FileRename

; #FUNCTION# ====================================================================================================================
; Author ........: Prog@ndy
; Modified.......:
; ===============================================================================================================================
Func _FTP_FileTimeLoHiToStr($iLoDWORD, $iHiDWORD, $bFmt = 0)
	Local $tFileTime = DllStructCreate($tagFILETIME)
	If Not $iLoDWORD And Not $iHiDWORD Then Return SetError(1, 0, "")
	DllStructSetData($tFileTime, 1, $iLoDWORD)
	DllStructSetData($tFileTime, 2, $iHiDWORD)
	Local $sDate = _Date_Time_FileTimeToStr($tFileTime, $bFmt)
	Return SetError(@error, @extended, $sDate)
EndFunc   ;==>_FTP_FileTimeLoHiToStr

; #FUNCTION# ====================================================================================================================
; Author ........: Dick Bronsdijk
; Modified.......: Prog@ndy, jpm
; ===============================================================================================================================
Func _FTP_FindFileClose($hFTPFind)
	If $__g_hWinInet_FTP = -1 Then Return SetError(-2, 0, 0)
	Local $ai_FTPPutFile = DllCall($__g_hWinInet_FTP, 'bool', 'InternetCloseHandle', 'handle', $hFTPFind)
	If @error Or $ai_FTPPutFile[0] = 0 Then Return SetError(-1, _WinAPI_GetLastError(), "")

	Return $ai_FTPPutFile[0]
EndFunc   ;==>_FTP_FindFileClose

; #FUNCTION# ====================================================================================================================
; Author ........: Dick Bronsdijk
; Modified.......: Prog@ndy, jpm
; ===============================================================================================================================
Func _FTP_FindFileFirst($hFTPSession, $sRemotePath, ByRef $hFTPFind, $iFlags = 0, $iContext = 0)
	;flags = 0 changed to $INTERNET_FLAG_TRANSFER_BINARY to see if stops hanging
	If $__g_hWinInet_FTP = -1 Then Return SetError(-2, 0, 0)
	Local $t_DllStruct = DllStructCreate($tagWIN32_FIND_DATA)
	If @error Then Return SetError(-3, 0, "")

	Local $a_FTPFileList[1]
	$a_FTPFileList[0] = 0

	Local $ai_FTPFirstFile = DllCall($__g_hWinInet_FTP, 'handle', 'FtpFindFirstFileW', 'handle', $hFTPSession, 'wstr', $sRemotePath, 'struct*', $t_DllStruct, 'dword', $iFlags, 'dword_ptr', $iContext)
	If @error Or $ai_FTPFirstFile[0] = 0 Then Return SetError(-1, _WinAPI_GetLastError(), $ai_FTPFirstFile)

	$hFTPFind = $ai_FTPFirstFile[0]

	Local $a_FTPFileList[12]
	$a_FTPFileList[0] = 11
	$a_FTPFileList[1] = DllStructGetData($t_DllStruct, "dwFileAttributes")
	$a_FTPFileList[2] = DllStructGetData($t_DllStruct, "ftCreationTime", 1)
	$a_FTPFileList[3] = DllStructGetData($t_DllStruct, "ftCreationTime", 2)
	$a_FTPFileList[4] = DllStructGetData($t_DllStruct, "ftLastAccessTime", 1)
	$a_FTPFileList[5] = DllStructGetData($t_DllStruct, "ftLastAccessTime", 2)
	$a_FTPFileList[6] = DllStructGetData($t_DllStruct, "ftLastWriteTime", 1)
	$a_FTPFileList[7] = DllStructGetData($t_DllStruct, "ftLastWriteTime", 2)
	$a_FTPFileList[8] = DllStructGetData($t_DllStruct, "nFileSizeHigh")
	$a_FTPFileList[9] = DllStructGetData($t_DllStruct, "nFileSizeLow")
	$a_FTPFileList[10] = DllStructGetData($t_DllStruct, "cFileName")
	$a_FTPFileList[11] = DllStructGetData($t_DllStruct, "cAlternateFileName")

	Return $a_FTPFileList
EndFunc   ;==>_FTP_FindFileFirst

; #FUNCTION# ====================================================================================================================
; Author ........: Dick Bronsdijk
; Modified.......: Prog@ndy, jpm
; ===============================================================================================================================
Func _FTP_FindFileNext($hFTPFind)
	Local $t_DllStruct = DllStructCreate($tagWIN32_FIND_DATA)

	Local $a_FTPFileList[1]
	$a_FTPFileList[0] = 0

	Local $ai_FTPPutFile = DllCall($__g_hWinInet_FTP, 'bool', 'InternetFindNextFileW', 'handle', $hFTPFind, 'struct*', $t_DllStruct)
	If @error Or $ai_FTPPutFile[0] = 0 Then Return SetError(-1, _WinAPI_GetLastError(), $a_FTPFileList)

	Local $a_FTPFileList[12]
	$a_FTPFileList[0] = 11
	$a_FTPFileList[1] = DllStructGetData($t_DllStruct, "dwFileAttributes")
	$a_FTPFileList[2] = DllStructGetData($t_DllStruct, "ftCreationTime", 1)
	$a_FTPFileList[3] = DllStructGetData($t_DllStruct, "ftCreationTime", 2)
	$a_FTPFileList[4] = DllStructGetData($t_DllStruct, "ftLastAccessTime", 1)
	$a_FTPFileList[5] = DllStructGetData($t_DllStruct, "ftLastAccessTime", 2)
	$a_FTPFileList[6] = DllStructGetData($t_DllStruct, "ftLastWriteTime", 1)
	$a_FTPFileList[7] = DllStructGetData($t_DllStruct, "ftLastWriteTime", 2)
	$a_FTPFileList[8] = DllStructGetData($t_DllStruct, "nFileSizeHigh")
	$a_FTPFileList[9] = DllStructGetData($t_DllStruct, "nFileSizeLow")
	$a_FTPFileList[10] = DllStructGetData($t_DllStruct, "cFileName")
	$a_FTPFileList[11] = DllStructGetData($t_DllStruct, "cAlternateFileName")

	Return $a_FTPFileList
EndFunc   ;==>_FTP_FindFileNext

; #FUNCTION# ====================================================================================================================
; Author ........: jpm
; Modified.......:
; ===============================================================================================================================
Func _FTP_GetLastResponseInfo(ByRef $iError, ByRef $sMessage)
	Local $ai_LastResponseInfo = DllCall($__g_hWinInet_FTP, 'bool', 'InternetGetLastResponseInfoW', 'dword*', 0, 'wstr', "", 'dword*', 4096)
	If @error Or $ai_LastResponseInfo[0] = 0 Then Return SetError(-1, _WinAPI_GetLastError(), 0)
	$iError = $ai_LastResponseInfo[1]
	$sMessage = $ai_LastResponseInfo[2]
	Return $ai_LastResponseInfo[0]
EndFunc   ;==>_FTP_GetLastResponseInfo

; #FUNCTION# ====================================================================================================================
; Author ........: Beast, Prog@ndy
; Modified.......:
; ===============================================================================================================================
Func _FTP_ListToArray($hFTPSession, $iReturnType = 0, $iFlags = $INTERNET_FLAG_NO_CACHE_WRITE, $iContext = 0)
	Local $aArray[1]
	$aArray[0] = 0
	If $__g_hWinInet_FTP = -1 Then Return SetError(-2, 0, $aArray)
	$aArray = __FTP_ListToArray($hFTPSession, $iReturnType, $iFlags, 0, 1, $iContext)
	Return SetError(@error, @extended, $aArray)
EndFunc   ;==>_FTP_ListToArray

; #FUNCTION# ====================================================================================================================
; Author ........: Prog@ndy
; Modified.......: jpm
; ===============================================================================================================================
Func _FTP_ListToArray2D($hFTPSession, $iReturnType = 0, $iFlags = $INTERNET_FLAG_NO_CACHE_WRITE, $iContext = 0)
	Local $aArray[1][1]
	$aArray[0][0] = 0
	If $__g_hWinInet_FTP = -1 Then Return SetError(-2, 0, $aArray)
	$aArray = __FTP_ListToArray($hFTPSession, $iReturnType, $iFlags, 0, 2, $iContext)
	Return SetError(@error, @extended, $aArray)
EndFunc   ;==>_FTP_ListToArray2D

; #FUNCTION# ====================================================================================================================
; Author ........: Beast, Prog@ndy
; Modified.......: jpm
; ===============================================================================================================================
Func _FTP_ListToArrayEx($hFTPSession, $iReturnType = 0, $iFlags = $INTERNET_FLAG_NO_CACHE_WRITE, $iFmt = 1, $iContext = 0)
	Local $aArray[1][1]
	$aArray[0][0] = 0
	If $__g_hWinInet_FTP = -1 Then Return SetError(-2, 0, $aArray)
	$aArray = __FTP_ListToArray($hFTPSession, $iReturnType, $iFlags, $iFmt, 6, $iContext)
	Return SetError(@error, @extended, $aArray)
EndFunc   ;==>_FTP_ListToArrayEx

; #FUNCTION# ====================================================================================================================
; Author ........: Wouter van Kesteren
; Modified.......:
; ===============================================================================================================================
Func _FTP_Open($sAgent, $iAccessType = $INTERNET_OPEN_TYPE_DIRECT, $sProxyName = '', $sProxyBypass = '', $iFlags = 0)
	If $__g_hWinInet_FTP = -1 Then __FTP_Init()
	Local $ai_InternetOpen = DllCall($__g_hWinInet_FTP, 'handle', 'InternetOpenW', 'wstr', $sAgent, 'dword', $iAccessType, _
			'wstr', $sProxyName, 'wstr', $sProxyBypass, 'dword', $iFlags)
	If @error Or $ai_InternetOpen[0] = 0 Then Return SetError(-1, _WinAPI_GetLastError(), 0)

	Return $ai_InternetOpen[0]
EndFunc   ;==>_FTP_Open

; #FUNCTION# ====================================================================================================================
; Author ........: limette, Prog@ndy
; Modified.......: jchd
; ===============================================================================================================================
Func _FTP_ProgressDownload($hFTPSession, $sLocalFile, $sRemoteFile, $hFunctionToCall = 0)
	If $__g_hWinInet_FTP = -1 Then Return SetError(-2, 0, 0)

	Local $hFile = FileOpen($sLocalFile, $FO_OVERWRITE + $FO_BINARY)
	If $hFile < 0 Then Return SetError(-1, 0, 0)

	Local $ai_FtpOpenfile = DllCall($__g_hWinInet_FTP, 'handle', 'FtpOpenFileW', 'handle', $hFTPSession, 'wstr', $sRemoteFile, 'dword', $GENERIC_READ, 'dword', $FTP_TRANSFER_TYPE_BINARY, 'dword_ptr', 0)
	If @error Or $ai_FtpOpenfile[0] = 0 Then Return SetError(-3, _WinAPI_GetLastError(), 0)

	Local $ai_FTPGetFileSize = DllCall($__g_hWinInet_FTP, 'dword', 'FtpGetFileSize', 'handle', $ai_FtpOpenfile[0], 'dword*', 0)
	If @error Then Return SetError(-2, _WinAPI_GetLastError(), 0)

	If Not IsFunc($hFunctionToCall) Then ProgressOn("FTP Download", "Downloading " & $sLocalFile)

	Local $iLen = _WinAPI_MakeQWord($ai_FTPGetFileSize[0], $ai_FTPGetFileSize[2]) ;FileGetSize($sRemoteFile)
	Local Const $iChunkSize = 256 * 1024
	Local $iLast = Mod($iLen, $iChunkSize)

	Local $iParts = Ceiling($iLen / $iChunkSize)
	Local $tBuffer = DllStructCreate("byte[" & $iChunkSize & "]")

	Local $aDone, $ai_FTPread, $iOut, $iRet, $iLasterror
	Local $x = $iChunkSize
	Local $iDone = 0
	For $i = 1 To $iParts
		If $i = $iParts And $iLast > 0 Then
			$x = $iLast
		EndIf

		$ai_FTPread = DllCall($__g_hWinInet_FTP, 'bool', 'InternetReadFile', 'handle', $ai_FtpOpenfile[0], 'struct*', $tBuffer, 'dword', $x, 'dword*', $iOut)
		If @error Or $ai_FTPread[0] = 0 Then
			$iLasterror = _WinAPI_GetLastError()
			$aDone = DllCall($__g_hWinInet_FTP, 'bool', 'InternetCloseHandle', 'handle', $ai_FtpOpenfile[0])
			; No need to test @error.
			FileClose($hFile)
			If Not IsFunc($hFunctionToCall) Then ProgressOff()
			Return SetError(-4, $iLasterror, 0)
		EndIf
		$iRet = FileWrite($hFile, BinaryMid(DllStructGetData($tBuffer, 1), 1, $ai_FTPread[4]))
		If Not $iRet Then
			$iLasterror = _WinAPI_GetLastError()
			$aDone = DllCall($__g_hWinInet_FTP, 'bool', 'InternetCloseHandle', 'handle', $ai_FtpOpenfile[0])
			; No need to test @error.
			FileClose($hFile)
			FileDelete($sLocalFile)
			If Not IsFunc($hFunctionToCall) Then ProgressOff()
			Return SetError(-7, $iLasterror, 0)
		EndIf
		$iDone += $ai_FTPread[4]

		If Not IsFunc($hFunctionToCall) Then
			ProgressSet(($iDone / $iLen) * 100)
		Else
			$iRet = $hFunctionToCall(($iDone / $iLen) * 100)
			If $iRet <= 0 Then
				$iLasterror = @error
				$aDone = DllCall($__g_hWinInet_FTP, 'bool', 'InternetCloseHandle', 'handle', $ai_FtpOpenfile[0])
				; No need to test @error.
				FileClose($hFile)
				FileDelete($sLocalFile)
				If Not IsFunc($hFunctionToCall) Then ProgressOff()
				Return SetError(-6, $iLasterror, $iRet)
			EndIf
		EndIf
		Sleep(10)
	Next

	FileClose($hFile)

	If Not IsFunc($hFunctionToCall) Then ProgressOff()

	$aDone = DllCall($__g_hWinInet_FTP, 'bool', 'InternetCloseHandle', 'handle', $ai_FtpOpenfile[0])
	If @error Or $aDone[0] = 0 Then
		Return SetError(-5, _WinAPI_GetLastError(), 0)
	EndIf

	Return 1
EndFunc   ;==>_FTP_ProgressDownload

; #FUNCTION# ====================================================================================================================
; Author ........: limette, Prog@ndy
; Modified.......: jchd
; ===============================================================================================================================
Func _FTP_ProgressUpload($hFTPSession, $sLocalFile, $sRemoteFile, $hFunctionToCall = 0)
	If $__g_hWinInet_FTP = -1 Then Return SetError(-2, 0, 0)

	Local $hFile = FileOpen($sLocalFile, $FO_BINARY)
	If @error Then Return SetError(-1, _WinAPI_GetLastError(), 0)

	Local $ai_FtpOpenfile = DllCall($__g_hWinInet_FTP, 'handle', 'FtpOpenFileW', 'handle', $hFTPSession, 'wstr', $sRemoteFile, 'dword', $GENERIC_WRITE, 'dword', $FTP_TRANSFER_TYPE_BINARY, 'dword_ptr', 0)
	If @error Or $ai_FtpOpenfile[0] = 0 Then Return SetError(-3, _WinAPI_GetLastError(), 0)

	If Not IsFunc($hFunctionToCall) Then ProgressOn("FTP Upload", "Uploading " & $sLocalFile)

	Local $iLen = FileGetSize($sLocalFile)
	Local Const $iChunkSize = 256 * 1024
	Local $iLast = Mod($iLen, $iChunkSize)

	Local $iParts = Ceiling($iLen / $iChunkSize)
	Local $tBuffer = DllStructCreate("byte[" & $iChunkSize & "]")

	Local $aDone, $ai_FtpWrite, $iOut, $iRet, $iLasterror
	Local $x = $iChunkSize
	Local $iDone = 0
	For $i = 1 To $iParts
		If $i = $iParts And $iLast > 0 Then
			$x = $iLast
		EndIf
		DllStructSetData($tBuffer, 1, FileRead($hFile, $x))

		$ai_FtpWrite = DllCall($__g_hWinInet_FTP, 'bool', 'InternetWriteFile', 'handle', $ai_FtpOpenfile[0], 'struct*', $tBuffer, 'dword', $x, 'dword*', $iOut)
		If @error Or $ai_FtpWrite[0] = 0 Then
			$iLasterror = _WinAPI_GetLastError()
			$aDone = DllCall($__g_hWinInet_FTP, 'bool', 'InternetCloseHandle', 'handle', $ai_FtpOpenfile[0])
			; No need to test @error.
			FileClose($hFile)

			If Not IsFunc($hFunctionToCall) Then ProgressOff()
			Return SetError(-4, $iLasterror, 0)
		EndIf
		$iDone += $x

		If Not IsFunc($hFunctionToCall) Then
			ProgressSet(($iDone / $iLen) * 100)
		Else
			$iRet = $hFunctionToCall(($iDone / $iLen) * 100)
			If $iRet <= 0 Then
				$iLasterror = @error
				$aDone = DllCall($__g_hWinInet_FTP, 'bool', 'InternetCloseHandle', 'handle', $ai_FtpOpenfile[0])
				; No need to test @error.
				DllCall($__g_hWinInet_FTP, 'bool', 'FtpDeleteFileW', 'handle', $hFTPSession, 'wstr', $sRemoteFile)
				; No need to test @error.
				FileClose($hFile)
				If Not IsFunc($hFunctionToCall) Then ProgressOff()
				Return SetError(-6, $iLasterror, $iRet)
			EndIf
		EndIf
		Sleep(10)
	Next

	FileClose($hFile)

	If Not IsFunc($hFunctionToCall) Then ProgressOff()

	$aDone = DllCall($__g_hWinInet_FTP, 'bool', 'InternetCloseHandle', 'handle', $ai_FtpOpenfile[0])
	; No need to test @error.
	If @error Or $aDone[0] = 0 Then Return SetError(-5, _WinAPI_GetLastError(), 0)

	Return 1
EndFunc   ;==>_FTP_ProgressUpload

; FUNCTION# ====================================================================================================================
; Name...........: _FTP_SetStatusCallback
; Description ...: Registers callback function that WinINet functions can call as progress is made during an operation.
; Syntax.........: _InternetSetStatusCallback ($hInternetSession, $sFunctionName )
; Parameters ....: $hInternetSession   - as returned by _FTP_Open().
;                  $sFunctionName       - The name of the User Defined Function to call
; Return values .: Success      - Pointer to callback function
;                  Failure      - 0 and Set @error
; Author ........: Beege
; Modified.......: jpm
; Remarks .......:
; Related .......: _FTP_DecodeInternetStatus
; Link ..........: @@MsdnLink@@ InternetSetStatusCallback
; Example .......: Yes
; ===============================================================================================================================
Func _FTP_SetStatusCallback($hInternetSession, $sFunctionName)
	If $__g_hWinInet_FTP = -1 Then Return SetError(-2, 0, 0)

	Local $hCallBack_Register = DllCallbackRegister($sFunctionName, "none", "ptr;ptr;dword;ptr;dword")
	If Not $hCallBack_Register Then Return SetError(-1, 0, 0)

	Local $ah_CallBackFunction = DllCall('wininet.dll', "ptr", "InternetSetStatusCallback", "ptr", $hInternetSession, "ulong_ptr", DllCallbackGetPtr($hCallBack_Register))
	If @error Then Return SetError(-3, 0, 0)
	If $ah_CallBackFunction[0] = Ptr(-1) Then Return SetError(-4, 0, 0) ; INTERNET_INVALID_STATUS_CALLBACK

	$__g_bCallback_FTP = True
	$__g_hCallback_FTP = $hCallBack_Register
	Return $ah_CallBackFunction[1]
EndFunc   ;==>_FTP_SetStatusCallback

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __FTP_ListToArray
; Description ...:
; Syntax.........: __FTP_ListToArray ( $hFTPSession [, $iReturnType = 0 [, $iFlags = 0 [, $iFmt = 1 [, $iArrayCount = 6 [, $iContext = 0 ]]]]] )
; Parameters ....:
; Return values .: an 2D array with the requested info defined by $iArrayCount
;                  [0] Filename
;                  [1] Filesize
;                  [2] FileAttribute
;                  [3] File Modification time
;                  [4] File Creation time
;                  [5] File Access time
; Author ........: Beast, Prog@ndy
; Modified.......: jpm (to be use by external UDFs)
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __FTP_ListToArray($hFTPSession, $iReturnType, $iFlags, $iFmt, $iArrayCount, $iContext)
	If $iArrayCount = 1 Then
		Local $asFileArray[1], $aDirectoryArray[1]
		$asFileArray[0] = 0
	Else
		Local $asFileArray[1][$iArrayCount], $aDirectoryArray[1][$iArrayCount]
		$asFileArray[0][0] = 0
	EndIf

	If $iReturnType < 0 Or $iReturnType > 2 Then Return SetError(3, 0, $asFileArray)

	; Global Const $tagWIN32_FIND_DATA = "DWORD dwFileAttributes; dword ftCreationTime[2]; dword ftLastAccessTime[2]; dword ftLastWriteTime[2]; DWORD nFileSizeHigh; DWORD nFileSizeLow; dword dwReserved0; dword dwReserved1; WCHAR cFileName[260]; WCHAR cAlternateFileName[14];"
	Local $tWIN32_FIND_DATA = DllStructCreate($tagWIN32_FIND_DATA)
	Local $iLasterror
	Local $aCallFindFirst = DllCall($__g_hWinInet_FTP, 'handle', 'FtpFindFirstFileW', 'handle', $hFTPSession, 'wstr', "", 'struct*', $tWIN32_FIND_DATA, 'dword', $iFlags, 'dword_ptr', $iContext)
	If @error Or Not $aCallFindFirst[0] Then
		$iLasterror = _WinAPI_GetLastError()
		If $iLasterror = 12003 Then ; ERROR_INTERNET_EXTENDED_ERROR
			Local $iError, $sMessage
			_FTP_GetLastResponseInfo($iError, $sMessage)
			$iLasterror = $iError
		EndIf
		Return SetError(1, $iLasterror, $asFileArray)
	EndIf

	Local $iDirectoryIndex = 0, $sFileIndex = 0
	Local $tFileTime, $bIsDir, $aCallFindNext
	Do
		$bIsDir = BitAND(DllStructGetData($tWIN32_FIND_DATA, "dwFileAttributes"), $FILE_ATTRIBUTE_DIRECTORY) = $FILE_ATTRIBUTE_DIRECTORY
		If $bIsDir And ($iReturnType <> 2) Then
			$iDirectoryIndex += 1
			If $iArrayCount = 1 Then
				If UBound($aDirectoryArray) < $iDirectoryIndex + 1 Then ReDim $aDirectoryArray[$iDirectoryIndex * 2]
				$aDirectoryArray[$iDirectoryIndex] = DllStructGetData($tWIN32_FIND_DATA, "cFileName")
			Else
				If UBound($aDirectoryArray) < $iDirectoryIndex + 1 Then ReDim $aDirectoryArray[$iDirectoryIndex * 2][$iArrayCount]
				$aDirectoryArray[$iDirectoryIndex][0] = DllStructGetData($tWIN32_FIND_DATA, "cFileName")

				$aDirectoryArray[$iDirectoryIndex][1] = _WinAPI_MakeQWord(DllStructGetData($tWIN32_FIND_DATA, "nFileSizeLow"), DllStructGetData($tWIN32_FIND_DATA, "nFileSizeHigh"))
				If $iArrayCount = 6 Then
					$aDirectoryArray[$iDirectoryIndex][2] = DllStructGetData($tWIN32_FIND_DATA, "dwFileAttributes")

					$tFileTime = DllStructCreate($tagFILETIME, DllStructGetPtr($tWIN32_FIND_DATA, "ftLastWriteTime"))
					$aDirectoryArray[$iDirectoryIndex][3] = _Date_Time_FileTimeToStr($tFileTime, $iFmt)
					$tFileTime = DllStructCreate($tagFILETIME, DllStructGetPtr($tWIN32_FIND_DATA, "ftCreationTime"))
					$aDirectoryArray[$iDirectoryIndex][4] = _Date_Time_FileTimeToStr($tFileTime, $iFmt)
					$tFileTime = DllStructCreate($tagFILETIME, DllStructGetPtr($tWIN32_FIND_DATA, "ftLastAccessTime"))
					$aDirectoryArray[$iDirectoryIndex][5] = _Date_Time_FileTimeToStr($tFileTime, $iFmt)
				EndIf
			EndIf
		ElseIf Not $bIsDir And $iReturnType <> 1 Then
			$sFileIndex += 1
			If $iArrayCount = 1 Then
				If UBound($asFileArray) < $sFileIndex + 1 Then ReDim $asFileArray[$sFileIndex * 2]
				$asFileArray[$sFileIndex] = DllStructGetData($tWIN32_FIND_DATA, "cFileName")
			Else
				If UBound($asFileArray) < $sFileIndex + 1 Then ReDim $asFileArray[$sFileIndex * 2][$iArrayCount]
				$asFileArray[$sFileIndex][0] = DllStructGetData($tWIN32_FIND_DATA, "cFileName")

				$asFileArray[$sFileIndex][1] = _WinAPI_MakeQWord(DllStructGetData($tWIN32_FIND_DATA, "nFileSizeLow"), DllStructGetData($tWIN32_FIND_DATA, "nFileSizeHigh"))
				If $iArrayCount = 6 Then
					$asFileArray[$sFileIndex][2] = DllStructGetData($tWIN32_FIND_DATA, "dwFileAttributes")

					$tFileTime = DllStructCreate($tagFILETIME, DllStructGetPtr($tWIN32_FIND_DATA, "ftLastWriteTime"))
					$asFileArray[$sFileIndex][3] = _Date_Time_FileTimeToStr($tFileTime, $iFmt)
					$tFileTime = DllStructCreate($tagFILETIME, DllStructGetPtr($tWIN32_FIND_DATA, "ftCreationTime"))
					$asFileArray[$sFileIndex][4] = _Date_Time_FileTimeToStr($tFileTime, $iFmt)
					$tFileTime = DllStructCreate($tagFILETIME, DllStructGetPtr($tWIN32_FIND_DATA, "ftLastAccessTime"))
					$asFileArray[$sFileIndex][5] = _Date_Time_FileTimeToStr($tFileTime, $iFmt)
				EndIf
			EndIf
		EndIf

		$aCallFindNext = DllCall($__g_hWinInet_FTP, 'bool', 'InternetFindNextFileW', 'handle', $aCallFindFirst[0], 'struct*', $tWIN32_FIND_DATA)
		If @error Then
			$iLasterror = _WinAPI_GetLastError()
			DllCall($__g_hWinInet_FTP, 'bool', 'InternetCloseHandle', 'handle', $aCallFindFirst[0])
			Return SetError(2, $iLasterror, $asFileArray)
		EndIf
	Until Not $aCallFindNext[0]

	DllCall($__g_hWinInet_FTP, 'bool', 'InternetCloseHandle', 'handle', $aCallFindFirst[0])
	; No need to test @error.

	If $iArrayCount = 1 Then
		$aDirectoryArray[0] = $iDirectoryIndex
		$asFileArray[0] = $sFileIndex
	Else
		$aDirectoryArray[0][0] = $iDirectoryIndex
		$asFileArray[0][0] = $sFileIndex
	EndIf

	Switch $iReturnType
		Case 0
			If $iArrayCount = 1 Then
				ReDim $aDirectoryArray[$aDirectoryArray[0] + $asFileArray[0] + 1]
				For $i = 1 To $sFileIndex
					$aDirectoryArray[$aDirectoryArray[0] + $i] = $asFileArray[$i]
				Next
				$aDirectoryArray[0] += $asFileArray[0]
			Else
				ReDim $aDirectoryArray[$aDirectoryArray[0][0] + $asFileArray[0][0] + 1][$iArrayCount]
				For $i = 1 To $sFileIndex
					For $j = 0 To $iArrayCount - 1
						$aDirectoryArray[$aDirectoryArray[0][0] + $i][$j] = $asFileArray[$i][$j]
					Next
				Next
				$aDirectoryArray[0][0] += $asFileArray[0][0]
			EndIf
			Return $aDirectoryArray
		Case 1
			If $iArrayCount = 1 Then
				ReDim $aDirectoryArray[$iDirectoryIndex + 1]
			Else
				ReDim $aDirectoryArray[$iDirectoryIndex + 1][$iArrayCount]
			EndIf
			Return $aDirectoryArray
		Case 2
			If $iArrayCount = 1 Then
				ReDim $asFileArray[$sFileIndex + 1]
			Else
				ReDim $asFileArray[$sFileIndex + 1][$iArrayCount]
			EndIf
			Return $asFileArray
	EndSwitch
EndFunc   ;==>__FTP_ListToArray

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __FTP_Init
; Description ...: DllOpen wininet.dll
; Syntax.........: __FTP_Init ( )
; Parameters ....:
; Return values .:
; Author ........:
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __FTP_Init()
	$__g_hWinInet_FTP = DllOpen('wininet.dll')
EndFunc   ;==>__FTP_Init
