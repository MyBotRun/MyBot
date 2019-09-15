#include-once

#include "Date.au3"
#include "Security.au3"
#include "StructureConstants.au3"
#include "WinAPI.au3"

; #INDEX# =======================================================================================================================
; Title .........: Event_Log
; AutoIt Version : 3.3.14.2
; Language ......: English
; Description ...: Functions that assist Windows System logs.
; Description ...: When an error occurs, the system administrator or support technicians must determine what  caused  the  error,
;                  attempt to recover any lost data, and prevent the error from recurring.  It is helpful  if  applications,  the
;                  operating system, and other system services record important events such as low-memory conditions or excessive
;                  attempts to access a disk.  Then the system administrator can  use  the  event  log  to  help  determine  what
;                  conditions caused the error and the context in which it occurred.  By periodically viewing the event log,  the
;                  system administrator may be able to identify problems (such as a failing hard drive) before they cause damage.
; Author(s) .....: Paul Campbell (PaulIA), Gary Frost
; Dll ...........: advapi32.dll
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
Global $__g_sSourceName_Event
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $EVENTLOG_SUCCESS = 0x00000000
Global Const $EVENTLOG_ERROR_TYPE = 0x00000001
Global Const $EVENTLOG_WARNING_TYPE = 0x00000002
Global Const $EVENTLOG_INFORMATION_TYPE = 0x00000004
Global Const $EVENTLOG_AUDIT_SUCCESS = 0x00000008
Global Const $EVENTLOG_AUDIT_FAILURE = 0x00000010
Global Const $EVENTLOG_SEQUENTIAL_READ = 0x00000001
Global Const $EVENTLOG_SEEK_READ = 0x00000002
Global Const $EVENTLOG_FORWARDS_READ = 0x00000004
Global Const $EVENTLOG_BACKWARDS_READ = 0x00000008

Global Const $__EVENTLOG_LOAD_LIBRARY_AS_DATAFILE = 0x00000002
Global Const $__EVENTLOG_FORMAT_MESSAGE_FROM_HMODULE = 0x00000800
Global Const $__EVENTLOG_FORMAT_MESSAGE_IGNORE_INSERTS = 0x00000200
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _EventLog__Backup
; _EventLog__Clear
; _EventLog__Close
; _EventLog__Count
; _EventLog__DeregisterSource
; _EventLog__Full
; _EventLog__Notify
; _EventLog__Oldest
; _EventLog__Open
; _EventLog__OpenBackup
; _EventLog__Read
; _EventLog__RegisterSource
; _EventLog__Report
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; __EventLog_DecodeCategory
; __EventLog_DecodeComputer
; __EventLog_DecodeData
; __EventLog_DecodeDate
; __EventLog_DecodeDesc
; __EventLog_DecodeEventID
; __EventLog_DecodeSource
; __EventLog_DecodeStrings
; __EventLog_DecodeTime
; __EventLog_DecodeTypeStr
; __EventLog_DecodeUserName
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _EventLog__Backup($hEventLog, $sFileName)
	Local $aResult = DllCall("advapi32.dll", "bool", "BackupEventLogW", "handle", $hEventLog, "wstr", $sFileName)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] <> 0
EndFunc   ;==>_EventLog__Backup

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _EventLog__Clear($hEventLog, $sFileName)
	Local $bTemp = False
	If StringLen($sFileName) = 0 Then
		$sFileName = @TempDir & "\_EventLog_tempbackup.bak"
		$bTemp = True
	EndIf
	Local $aResult = DllCall("advapi32.dll", "bool", "ClearEventLogW", "handle", $hEventLog, "wstr", $sFileName)
	If @error Then Return SetError(@error, @extended, False)
	If $bTemp Then FileDelete($sFileName)
	Return $aResult[0] <> 0
EndFunc   ;==>_EventLog__Clear

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _EventLog__Close($hEventLog)
	Local $aResult = DllCall("advapi32.dll", "bool", "CloseEventLog", "handle", $hEventLog)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] <> 0
EndFunc   ;==>_EventLog__Close

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _EventLog__Count($hEventLog)
	Local $aResult = DllCall("advapi32.dll", "bool", "GetNumberOfEventLogRecords", "handle", $hEventLog, "dword*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	If $aResult[0] = 0 Then Return -1
	Return $aResult[2]
EndFunc   ;==>_EventLog__Count

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __EventLog_DecodeCategory
; Description ...: Decodes an event category for an event record
; Syntax.........: __EventLog_DecodeCategory ( $tEventLog )
; Parameters ....: $tEventLog   - tagEVENTLOGRECORD structure
; Return values .: Success      - Event category
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; Remarks .......: This function is used internally
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __EventLog_DecodeCategory($tEventLog)
	Return DllStructGetData($tEventLog, "EventCategory")
EndFunc   ;==>__EventLog_DecodeCategory

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __EventLog_DecodeComputer
; Description ...: Decodes the computer name from an event log record
; Syntax.........: __EventLog_DecodeComputer ( $tEventLog )
; Parameters ....: $tEventLog   - tagEVENTLOGRECORD structure
; Return values .: Success      - Computer name
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; Remarks .......: This function is used internally
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __EventLog_DecodeComputer($tEventLog)
	Local $pEventLog = DllStructGetPtr($tEventLog)
	; The buffer length doesn't need to extend past UserSidOffset since
	; the string appears before that.
	Local $iLength = DllStructGetData($tEventLog, "UserSidOffset") - 1
	; This points to the start of the variable length data.
	Local $iOffset = DllStructGetSize($tEventLog)
	; Offset the buffer with the Source string length which appears right
	; before the Computer name.
	$iOffset += 2 * (StringLen(__EventLog_DecodeSource($tEventLog)) + 1)
	; Adjust the length to be a difference instead of absolute address.
	$iLength -= $iOffset
	; Adjust the buffer to point to the start of the Computer string.
	Local $tBuffer = DllStructCreate("wchar Text[" & $iLength & "]", $pEventLog + $iOffset)
	Return DllStructGetData($tBuffer, "Text")
EndFunc   ;==>__EventLog_DecodeComputer

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __EventLog_DecodeData
; Description ...: Decodes the event specific binary data from an event log record
; Syntax.........: __EventLog_DecodeData ( $tEventLog )
; Parameters ....: $tEventLog   - tagEVENTLOGRECORD structure
; Return values .: Success      - Array with the following format:
;                  |[0] - Number of bytes in array
;                  |[1] - Byte 1
;                  |[2] - Byte 2
;                  |[n] - Byte n
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; Remarks .......: This function is used internally
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __EventLog_DecodeData($tEventLog)
	Local $pEventLog = DllStructGetPtr($tEventLog)
	Local $iOffset = DllStructGetData($tEventLog, "DataOffset")
	Local $iLength = DllStructGetData($tEventLog, "DataLength")
	Local $tBuffer = DllStructCreate("byte[" & $iLength & "]", $pEventLog + $iOffset)
	Local $aData[$iLength + 1]
	$aData[0] = $iLength
	For $iI = 1 To $iLength
		$aData[$iI] = DllStructGetData($tBuffer, 1, $iI)
	Next
	Return $aData
EndFunc   ;==>__EventLog_DecodeData

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __EventLog_DecodeDate
; Description ...: Converts an event log time to a date string
; Syntax.........: __EventLog_DecodeDate ( $iEventTime )
; Parameters ....: $iEventTime  - Event log time to be converted
; Return values .: Success      - Date string in the format of mm/dd/yyyy
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; Remarks .......: This function is used internally
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __EventLog_DecodeDate($iEventTime)
	Local $tInt64 = DllStructCreate("int64")
	Local $pInt64 = DllStructGetPtr($tInt64)
	Local $tFileTime = DllStructCreate($tagFILETIME, $pInt64)
	DllStructSetData($tInt64, 1, ($iEventTime * 10000000) + 116444736000000000)
	Local $tLocalTime = _Date_Time_FileTimeToLocalFileTime($tFileTime)
	Local $tSystTime = _Date_Time_FileTimeToSystemTime($tLocalTime)
	Local $iMonth = DllStructGetData($tSystTime, "Month")
	Local $iDay = DllStructGetData($tSystTime, "Day")
	Local $iYear = DllStructGetData($tSystTime, "Year")
	Return StringFormat("%02d/%02d/%04d", $iMonth, $iDay, $iYear)
EndFunc   ;==>__EventLog_DecodeDate

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __EventLog_DecodeDesc
; Description ...: Decodes the description strings for an event record
; Syntax.........: __EventLog_DecodeDesc ( $tEventLog )
; Parameters ....: $tEventLog   - tagEVENTLOGRECORD structure
; Return values .: Success      - Description
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; Remarks .......: This function is used internally
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __EventLog_DecodeDesc($tEventLog)
	Local $aStrings = __EventLog_DecodeStrings($tEventLog)
	Local $sSource = __EventLog_DecodeSource($tEventLog)
	Local $iEventID = DllStructGetData($tEventLog, "EventID")
	Local $sKey = "HKLM\SYSTEM\CurrentControlSet\Services\Eventlog\" & $__g_sSourceName_Event & "\" & $sSource
	Local $aMsgDLL = StringSplit(_WinAPI_ExpandEnvironmentStrings(RegRead($sKey, "EventMessageFile")), ";")

	Local $iFlags = BitOR($__EVENTLOG_FORMAT_MESSAGE_FROM_HMODULE, $__EVENTLOG_FORMAT_MESSAGE_IGNORE_INSERTS)
	Local $sDesc = ""
	For $iI = 1 To $aMsgDLL[0]
		Local $hDLL = _WinAPI_LoadLibraryEx($aMsgDLL[$iI], $__EVENTLOG_LOAD_LIBRARY_AS_DATAFILE)
		If $hDLL = 0 Then ContinueLoop
		Local $tBuffer = DllStructCreate("wchar Text[4096]")
		_WinAPI_FormatMessage($iFlags, $hDLL, $iEventID, 0, $tBuffer, 4096, 0)
		_WinAPI_FreeLibrary($hDLL)
		$sDesc &= DllStructGetData($tBuffer, "Text")
	Next

	If $sDesc = "" Then
		For $iI = 1 To $aStrings[0]
			$sDesc &= $aStrings[$iI]
		Next
	Else
		For $iI = 1 To $aStrings[0]
			$sDesc = StringReplace($sDesc, "%" & $iI, $aStrings[$iI])
		Next
	EndIf
	Return StringStripWS($sDesc, $STR_STRIPLEADING + $STR_STRIPTRAILING)
EndFunc   ;==>__EventLog_DecodeDesc

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __EventLog_DecodeEventID
; Description ...: Decodes an event ID for an event record
; Syntax.........: __EventLog_DecodeEventID ( $tEventLog )
; Parameters ....: $tEventLog   - tagEVENTLOGRECORD structure
; Return values .: Success      - Event ID
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; Remarks .......: This function is used internally
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __EventLog_DecodeEventID($tEventLog)
	Return BitAND(DllStructGetData($tEventLog, "EventID"), 0x7FFF)
EndFunc   ;==>__EventLog_DecodeEventID

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __EventLog_DecodeSource
; Description ...: Decodes the event source from an event log record
; Syntax.........: __EventLog_DecodeSource ( $tEventLog )
; Parameters ....: $tEventLog   - tagEVENTLOGRECORD structure
; Return values .: Success      - Source name
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; Remarks .......: This function is used internally
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __EventLog_DecodeSource($tEventLog)
	Local $pEventLog = DllStructGetPtr($tEventLog)
	; The buffer length doesn't need to extend past UserSidOffset since
	; the string appears before that.
	Local $iLength = DllStructGetData($tEventLog, "UserSidOffset") - 1
	; This points to the start of the variable length data.
	Local $iOffset = DllStructGetSize($tEventLog)
	; Adjust the length to be a difference instead of absolute address.
	$iLength -= $iOffset
	; Initialize the buffer to the start of the variable length data
	Local $tBuffer = DllStructCreate("wchar Text[" & $iLength & "]", $pEventLog + $iOffset)
	Return DllStructGetData($tBuffer, "Text")
EndFunc   ;==>__EventLog_DecodeSource

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __EventLog_DecodeStrings
; Description ...: Decodes the insertion strings from an event log record
; Syntax.........: __EventLog_DecodeStrings ( $tEventLog )
; Parameters ....: $tEventLog   - tagEVENTLOGRECORD structure
; Return values .: Success      - Array with the following format:
;                  |[0] - Number of strings in array
;                  |[1] - String 1
;                  |[2] - String 2
;                  |[n] - String n
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; Remarks .......: This function is used internally
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __EventLog_DecodeStrings($tEventLog)
	Local $pEventLog = DllStructGetPtr($tEventLog)
	Local $iNumStrs = DllStructGetData($tEventLog, "NumStrings")
	Local $iOffset = DllStructGetData($tEventLog, "StringOffset")
	; The data offset is used to calculate buffer sizes.
	Local $iDataOffset = DllStructGetData($tEventLog, "DataOffset")
	Local $tBuffer = DllStructCreate("wchar Text[" & $iDataOffset - $iOffset & "]", $pEventLog + $iOffset)

	Local $aStrings[$iNumStrs + 1]
	$aStrings[0] = $iNumStrs
	For $iI = 1 To $iNumStrs
		$aStrings[$iI] = DllStructGetData($tBuffer, "Text")
		$iOffset += 2 * (StringLen($aStrings[$iI]) + 1)
		$tBuffer = DllStructCreate("wchar Text[" & $iDataOffset - $iOffset & "]", $pEventLog + $iOffset)
	Next
	Return $aStrings
EndFunc   ;==>__EventLog_DecodeStrings

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __EventLog_DecodeTime
; Description ...: Converts an event log time to a date time
; Syntax.........: __EventLog_DecodeTime ( $iEventTime )
; Parameters ....: $iEventTime  - Event log time to be converted
; Return values .: Success      - Time string in the format of hh:mm:ss am/pm
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; Remarks .......: This function is used internally
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __EventLog_DecodeTime($iEventTime)
	Local $tInt64 = DllStructCreate("int64")
	Local $pInt64 = DllStructGetPtr($tInt64)
	Local $tFileTime = DllStructCreate($tagFILETIME, $pInt64)
	DllStructSetData($tInt64, 1, ($iEventTime * 10000000) + 116444736000000000)
	Local $tLocalTime = _Date_Time_FileTimeToLocalFileTime($tFileTime)
	Local $tSystTime = _Date_Time_FileTimeToSystemTime($tLocalTime)
	Local $iHours = DllStructGetData($tSystTime, "Hour")
	Local $iMinutes = DllStructGetData($tSystTime, "Minute")
	Local $iSeconds = DllStructGetData($tSystTime, "Second")
	Local $sAMPM = "AM"
	If $iHours < 12 Then
		If $iHours = 0 Then
			$iHours = 12
		EndIf
	Else
		$sAMPM = "PM"
		If $iHours > 12 Then
			$iHours -= 12
		EndIf
	EndIf
	Return StringFormat("%02d:%02d:%02d %s", $iHours, $iMinutes, $iSeconds, $sAMPM)
EndFunc   ;==>__EventLog_DecodeTime

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __EventLog_DecodeTypeStr
; Description ...: Decodes an event type to an event string
; Syntax.........: __EventLog_DecodeTypeStr ( $iEventType )
; Parameters ....: $iEventType  - Event type
; Return values .: Success      - String indicating the event type
;                  Failure      - Unknown event type ID
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......: This function is used internally
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __EventLog_DecodeTypeStr($iEventType)
	Select
		Case $iEventType = $EVENTLOG_SUCCESS
			Return "Success"
		Case $iEventType = $EVENTLOG_ERROR_TYPE
			Return "Error"
		Case $iEventType = $EVENTLOG_WARNING_TYPE
			Return "Warning"
		Case $iEventType = $EVENTLOG_INFORMATION_TYPE
			Return "Information"
		Case $iEventType = $EVENTLOG_AUDIT_SUCCESS
			Return "Success audit"
		Case $iEventType = $EVENTLOG_AUDIT_FAILURE
			Return "Failure audit"
		Case Else
			Return $iEventType
	EndSelect
EndFunc   ;==>__EventLog_DecodeTypeStr

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __EventLog_DecodeUserName
; Description ...: Decodes the user name from an event log record
; Syntax.........: __EventLog_DecodeUserName ( $tEventLog )
; Parameters ....: $tEventLog   - tagEVENTLOGRECORD structure
; Return values .: Success      - User name
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; Remarks .......: This function is used internally
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __EventLog_DecodeUserName($tEventLog)
	Local $pEventLog = DllStructGetPtr($tEventLog)
	If DllStructGetData($tEventLog, "UserSidLength") = 0 Then Return ""
	Local $pAcctSID = $pEventLog + DllStructGetData($tEventLog, "UserSidOffset")
	Local $aAcctInfo = _Security__LookupAccountSid($pAcctSID)
	If IsArray($aAcctInfo) Then Return $aAcctInfo[1]
	Return ''
EndFunc   ;==>__EventLog_DecodeUserName

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _EventLog__DeregisterSource($hEventLog)
	Local $aResult = DllCall("advapi32.dll", "bool", "DeregisterEventSource", "handle", $hEventLog)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] <> 0
EndFunc   ;==>_EventLog__DeregisterSource

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _EventLog__Full($hEventLog)
	Local $aResult = DllCall("advapi32.dll", "bool", "GetEventLogInformation", "handle", $hEventLog, "dword", 0, "dword*", 0, "dword", 4, "dword*", 0)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[3] <> 0
EndFunc   ;==>_EventLog__Full

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _EventLog__Notify($hEventLog, $hEvent)
	Local $aResult = DllCall("advapi32.dll", "bool", "NotifyChangeEventLog", "handle", $hEventLog, "handle", $hEvent)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] <> 0
EndFunc   ;==>_EventLog__Notify

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _EventLog__Oldest($hEventLog)
	Local $aResult = DllCall("advapi32.dll", "bool", "GetOldestEventLogRecord", "handle", $hEventLog, "dword*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[2]
EndFunc   ;==>_EventLog__Oldest

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _EventLog__Open($sServerName, $sSourceName)
	$__g_sSourceName_Event = $sSourceName
	Local $aResult = DllCall("advapi32.dll", "handle", "OpenEventLogW", "wstr", $sServerName, "wstr", $sSourceName)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_EventLog__Open

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _EventLog__OpenBackup($sServerName, $sFileName)
	Local $aResult = DllCall("advapi32.dll", "handle", "OpenBackupEventLogW", "wstr", $sServerName, "wstr", $sFileName)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_EventLog__OpenBackup

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _EventLog__Read($hEventLog, $bRead = True, $bForward = True, $iOffset = 0)
	Local $iReadFlags, $aEvent[15]
	$aEvent[0] = False; in cas of error

	If $bRead Then
		$iReadFlags = $EVENTLOG_SEQUENTIAL_READ
	Else
		$iReadFlags = $EVENTLOG_SEEK_READ
	EndIf
	If $bForward Then
		$iReadFlags = BitOR($iReadFlags, $EVENTLOG_FORWARDS_READ)
	Else
		$iReadFlags = BitOR($iReadFlags, $EVENTLOG_BACKWARDS_READ)
	EndIf

	; First call gets the size for the buffer.  A fake buffer is passed because
	; the function demands the buffer be non-NULL even when requesting the size.
	Local $tBuffer = DllStructCreate("wchar[1]")
	Local $aResult = DllCall("advapi32.dll", "bool", "ReadEventLogW", "handle", $hEventLog, "dword", $iReadFlags, "dword", $iOffset, _
			"struct*", $tBuffer, "dword", 0, "dword*", 0, "dword*", 0)
	If @error Then Return SetError(@error, @extended, $aEvent)

	; Allocate the buffer and repeat the call obtaining the information.
	Local $iBytesMin = $aResult[7]
	$tBuffer = DllStructCreate("wchar[" & $iBytesMin + 1 & "]")
	$aResult = DllCall("advapi32.dll", "bool", "ReadEventLogW", "handle", $hEventLog, "dword", $iReadFlags, "dword", $iOffset, _
			"struct*", $tBuffer, "dword", $iBytesMin, "dword*", 0, "dword*", 0)
	If @error Or Not $aResult[0] Then Return SetError(@error, @extended, $aEvent)

	Local $tEventLog = DllStructCreate($tagEVENTLOGRECORD, DllStructGetPtr($tBuffer))
	$aEvent[0] = True
	$aEvent[1] = DllStructGetData($tEventLog, "RecordNumber")
	$aEvent[2] = __EventLog_DecodeDate(DllStructGetData($tEventLog, "TimeGenerated"))
	$aEvent[3] = __EventLog_DecodeTime(DllStructGetData($tEventLog, "TimeGenerated"))
	$aEvent[4] = __EventLog_DecodeDate(DllStructGetData($tEventLog, "TimeWritten"))
	$aEvent[5] = __EventLog_DecodeTime(DllStructGetData($tEventLog, "TimeWritten"))
	$aEvent[6] = __EventLog_DecodeEventID($tEventLog)
	$aEvent[7] = DllStructGetData($tEventLog, "EventType")
	$aEvent[8] = __EventLog_DecodeTypeStr(DllStructGetData($tEventLog, "EventType"))
	$aEvent[9] = __EventLog_DecodeCategory($tEventLog)
	$aEvent[10] = __EventLog_DecodeSource($tEventLog)
	$aEvent[11] = __EventLog_DecodeComputer($tEventLog)
	$aEvent[12] = __EventLog_DecodeUserName($tEventLog)
	$aEvent[13] = __EventLog_DecodeDesc($tEventLog)
	$aEvent[14] = __EventLog_DecodeData($tEventLog)
	Return $aEvent
EndFunc   ;==>_EventLog__Read

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _EventLog__RegisterSource($sServerName, $sSourceName)
	$__g_sSourceName_Event = $sSourceName
	Local $aResult = DllCall("advapi32.dll", "handle", "RegisterEventSourceW", "wstr", $sServerName, "wstr", $sSourceName)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_EventLog__RegisterSource

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _EventLog__Report($hEventLog, $iType, $iCategory, $iEventID, $sUserName, $sDesc, $aData)
	Local $tSID = 0

	If $sUserName <> "" Then
		$tSID = _Security__GetAccountSid($sUserName)
	EndIf

	Local $iData = $aData[0]
	Local $tData = DllStructCreate("byte[" & $iData & "]")
	Local $iDesc = StringLen($sDesc) + 1
	Local $tDesc = DllStructCreate("wchar[" & $iDesc & "]")
	Local $tPtr = DllStructCreate("ptr")
	DllStructSetData($tPtr, 1, DllStructGetPtr($tDesc))
	DllStructSetData($tDesc, 1, $sDesc)
	For $iI = 1 To $iData
		DllStructSetData($tData, 1, $aData[$iI], $iI)
	Next
	Local $aResult = DllCall("advapi32.dll", "bool", "ReportEventW", "handle", $hEventLog, "word", $iType, "word", $iCategory, _
			"dword", $iEventID, "struct*", $tSID, "word", 1, "dword", $iData, "struct*", $tPtr, "struct*", $tData)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] <> 0
EndFunc   ;==>_EventLog__Report
