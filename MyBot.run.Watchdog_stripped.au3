#NoTrayIcon
#RequireAdmin
#pragma compile(ProductName, My Bot Watchdog)
#pragma compile(Out, MyBot.run.Watchdog.exe) ; Required
#pragma compile(Icon, "Images\MyBot.ico")
#pragma compile(FileDescription, Clash of Clans Bot - A Free Clash of Clans bot - https://mybot.run)
#pragma compile(ProductVersion, 7.5.2)
#pragma compile(FileVersion, 7.5.2)
#pragma compile(LegalCopyright, © https://mybot.run)
#Au3Stripper_Off
#Au3Stripper_On
Global $g_sBotVersion = "v7.5.3"
Opt("MustDeclareVars", 1)
Global Const $WAIT_TIMEOUT = 258
Global Const $STDERR_MERGED = 8
Global Const $UBOUND_DIMENSIONS = 0
Global Const $UBOUND_ROWS = 1
Global Const $UBOUND_COLUMNS = 2
Global Const $tagRECT = "struct;long Left;long Top;long Right;long Bottom;endstruct"
Global Const $tagSYSTEMTIME = "struct;word Year;word Month;word Dow;word Day;word Hour;word Minute;word Second;word MSeconds;endstruct"
Global Const $tagREBARBANDINFO = "uint cbSize;uint fMask;uint fStyle;dword clrFore;dword clrBack;ptr lpText;uint cch;" & "int iImage;hwnd hwndChild;uint cxMinChild;uint cyMinChild;uint cx;handle hbmBack;uint wID;uint cyChild;uint cyMaxChild;" & "uint cyIntegral;uint cxIdeal;lparam lParam;uint cxHeader" &((@OSVersion = "WIN_XP") ? "" : ";" & $tagRECT & ";uint uChevronState")
Global Const $tagPROCESS_INFORMATION = "handle hProcess;handle hThread;dword ProcessID;dword ThreadID"
Global Const $tagSTARTUPINFO = "dword Size;ptr Reserved1;ptr Desktop;ptr Title;dword X;dword Y;dword XSize;dword YSize;dword XCountChars;" & "dword YCountChars;dword FillAttribute;dword Flags;word ShowWindow;word Reserved2;ptr Reserved3;handle StdInput;" & "handle StdOutput;handle StdError"
Global Const $tagSECURITY_ATTRIBUTES = "dword Length;ptr Descriptor;bool InheritHandle"
Global Const $tagOSVERSIONINFO = 'struct;dword OSVersionInfoSize;dword MajorVersion;dword MinorVersion;dword BuildNumber;dword PlatformId;wchar CSDVersion[128];endstruct'
Global Const $__WINVER = __WINVER()
Func __WINVER()
Local $tOSVI = DllStructCreate($tagOSVERSIONINFO)
DllStructSetData($tOSVI, 1, DllStructGetSize($tOSVI))
Local $aRet = DllCall('kernel32.dll', 'bool', 'GetVersionExW', 'struct*', $tOSVI)
If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
Return BitOR(BitShift(DllStructGetData($tOSVI, 2), -8), DllStructGetData($tOSVI, 3))
EndFunc
Global Const $STR_STRIPLEADING = 1
Global Const $STR_STRIPTRAILING = 2
Func _WinAPI_CreateMutex($sMutex, $bInitial = True, $tSecurity = 0)
Local $aRet = DllCall('kernel32.dll', 'handle', 'CreateMutexW', 'struct*', $tSecurity, 'bool', $bInitial, 'wstr', $sMutex)
If @error Then Return SetError(@error, @extended, 0)
Return $aRet[0]
EndFunc
Func _WinAPI_CreateSemaphore($sSemaphore, $iInitial, $iMaximum, $tSecurity = 0)
Local $aRet = DllCall('kernel32.dll', 'handle', 'CreateSemaphoreW', 'struct*', $tSecurity, 'long', $iInitial, 'long', $iMaximum, 'wstr', $sSemaphore)
If @error Then Return SetError(@error, @extended, 0)
Return $aRet[0]
EndFunc
Func _WinAPI_ReleaseMutex($hMutex)
Local $aRet = DllCall('kernel32.dll', 'bool', 'ReleaseMutex', 'handle', $hMutex)
If @error Then Return SetError(@error, @extended, 0)
Return $aRet[0]
EndFunc
Func _WinAPI_ReleaseSemaphore($hSemaphore, $iIncrease = 1)
Local $aRet = DllCall('kernel32.dll', 'bool', 'ReleaseSemaphore', 'handle', $hSemaphore, 'long', $iIncrease, 'long*', 0)
If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)
Return $aRet[3]
EndFunc
Global Const $BSF_IGNORECURRENTTASK = 0x0002
Global Const $BSF_POSTMESSAGE = 0x0010
Global Const $BSM_APPLICATIONS = 0x10
Global Const $HANDLE_FLAG_INHERIT = 0x00000001
Func _SendMessage($hWnd, $iMsg, $wParam = 0, $lParam = 0, $iReturn = 0, $wParamType = "wparam", $lParamType = "lparam", $sReturnType = "lresult")
Local $aResult = DllCall("user32.dll", $sReturnType, "SendMessageW", "hwnd", $hWnd, "uint", $iMsg, $wParamType, $wParam, $lParamType, $lParam)
If @error Then Return SetError(@error, @extended, "")
If $iReturn >= 0 And $iReturn <= 4 Then Return $aResult[$iReturn]
Return $aResult
EndFunc
Global Const $HGDI_ERROR = Ptr(-1)
Global Const $INVALID_HANDLE_VALUE = Ptr(-1)
Global Const $KF_EXTENDED = 0x0100
Global Const $KF_ALTDOWN = 0x2000
Global Const $KF_UP = 0x8000
Global Const $LLKHF_EXTENDED = BitShift($KF_EXTENDED, 8)
Global Const $LLKHF_ALTDOWN = BitShift($KF_ALTDOWN, 8)
Global Const $LLKHF_UP = BitShift($KF_UP, 8)
Func _WinAPI_CloseHandle($hObject)
Local $aResult = DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hObject)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _WinAPI_GetStdHandle($iStdHandle)
If $iStdHandle < 0 Or $iStdHandle > 2 Then Return SetError(2, 0, -1)
Local Const $aHandle[3] = [-10, -11, -12]
Local $aResult = DllCall("kernel32.dll", "handle", "GetStdHandle", "dword", $aHandle[$iStdHandle])
If @error Then Return SetError(@error, @extended, -1)
Return $aResult[0]
EndFunc
Func _WinAPI_PostMessage($hWnd, $iMsg, $wParam, $lParam)
Local $aResult = DllCall("user32.dll", "bool", "PostMessage", "hwnd", $hWnd, "uint", $iMsg, "wparam", $wParam, "lparam", $lParam)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _WinAPI_ReadFile($hFile, $pBuffer, $iToRead, ByRef $iRead, $tOverlapped = 0)
Local $aResult = DllCall("kernel32.dll", "bool", "ReadFile", "handle", $hFile, "struct*", $pBuffer, "dword", $iToRead, "dword*", 0, "struct*", $tOverlapped)
If @error Then Return SetError(@error, @extended, False)
$iRead = $aResult[4]
Return $aResult[0]
EndFunc
Func _WinAPI_RegisterWindowMessage($sMessage)
Local $aResult = DllCall("user32.dll", "uint", "RegisterWindowMessageW", "wstr", $sMessage)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _WinAPI_SetHandleInformation($hObject, $iMask, $iFlags)
Local $aResult = DllCall("kernel32.dll", "bool", "SetHandleInformation", "handle", $hObject, "dword", $iMask, "dword", $iFlags)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _WinAPI_WaitForSingleObject($hHandle, $iTimeout = -1)
Local $aResult = DllCall("kernel32.dll", "INT", "WaitForSingleObject", "handle", $hHandle, "dword", $iTimeout)
If @error Then Return SetError(@error, @extended, -1)
Return $aResult[0]
EndFunc
Func _WinAPI_WriteFile($hFile, $pBuffer, $iToWrite, ByRef $iWritten, $tOverlapped = 0)
Local $aResult = DllCall("kernel32.dll", "bool", "WriteFile", "handle", $hFile, "struct*", $pBuffer, "dword", $iToWrite, "dword*", 0, "struct*", $tOverlapped)
If @error Then Return SetError(@error, @extended, False)
$iWritten = $aResult[4]
Return $aResult[0]
EndFunc
Func _WinAPI_BroadcastSystemMessage($iMsg, $wParam = 0, $lParam = 0, $iFlags = 0, $iRecipients = 0)
Local $aRet = DllCall('user32.dll', 'long', 'BroadcastSystemMessageW', 'dword', $iFlags, 'dword*', $iRecipients, 'uint', $iMsg, 'wparam', $wParam, 'lparam', $lParam)
If @error Or($aRet[0] = -1) Then Return SetError(@error, @extended, -1)
Return SetExtended($aRet[2], $aRet[0])
EndFunc
Global Const $COLOR_BLACK = 0x000000
Global Const $COLOR_PURPLE = 0x800080
Global Const $COLOR_RED = 0xFF0000
Global Const $DMW_SHORTNAME = 1
Global Const $DMW_LOCALE_LONGNAME = 2
Global Const $LOCALE_SDATE = 0x001D
Global Const $LOCALE_STIME = 0x001E
Global Const $LOCALE_SSHORTDATE = 0x001F
Global Const $LOCALE_SLONGDATE = 0x0020
Global Const $LOCALE_STIMEFORMAT = 0x1003
Global Const $LOCALE_S1159 = 0x0028
Global Const $LOCALE_S2359 = 0x0029
Global Const $LOCALE_INVARIANT = 0x007F
Global Const $LOCALE_USER_DEFAULT = 0x0400
Func _WinAPI_GetDateFormat($iLCID = 0, $tSYSTEMTIME = 0, $iFlags = 0, $sFormat = '')
If Not $iLCID Then $iLCID = 0x0400
Local $sTypeOfFormat = 'wstr'
If Not StringStripWS($sFormat, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
$sTypeOfFormat = 'ptr'
$sFormat = 0
EndIf
Local $aRet = DllCall('kernel32.dll', 'int', 'GetDateFormatW', 'dword', $iLCID, 'dword', $iFlags, 'struct*', $tSYSTEMTIME, $sTypeOfFormat, $sFormat, 'wstr', '', 'int', 2048)
If @error Or Not $aRet[0] Then Return SetError(@error, @extended, '')
Return $aRet[5]
EndFunc
Func _WinAPI_GetLocaleInfo($iLCID, $iType)
Local $aRet = DllCall('kernel32.dll', 'int', 'GetLocaleInfoW', 'dword', $iLCID, 'dword', $iType, 'wstr', '', 'int', 2048)
If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, '')
Return $aRet[3]
EndFunc
Func _DateDayOfWeek($iDayNum, $iFormat = Default)
Local Const $MONDAY_IS_NO1 = 128
If $iFormat = Default Then $iFormat = 0
$iDayNum = Int($iDayNum)
If $iDayNum < 1 Or $iDayNum > 7 Then Return SetError(1, 0, "")
Local $tSYSTEMTIME = DllStructCreate($tagSYSTEMTIME)
DllStructSetData($tSYSTEMTIME, "Year", BitAND($iFormat, $MONDAY_IS_NO1) ? 2007 : 2006)
DllStructSetData($tSYSTEMTIME, "Month", 1)
DllStructSetData($tSYSTEMTIME, "Day", $iDayNum)
Return _WinAPI_GetDateFormat(BitAND($iFormat, $DMW_LOCALE_LONGNAME) ? $LOCALE_USER_DEFAULT : $LOCALE_INVARIANT, $tSYSTEMTIME, 0, BitAND($iFormat, $DMW_SHORTNAME) ? "ddd" : "dddd")
EndFunc
Func _DateIsLeapYear($iYear)
If StringIsInt($iYear) Then
Select
Case Mod($iYear, 4) = 0 And Mod($iYear, 100) <> 0
Return 1
Case Mod($iYear, 400) = 0
Return 1
Case Else
Return 0
EndSelect
EndIf
Return SetError(1, 0, 0)
EndFunc
Func __DateIsMonth($iNumber)
$iNumber = Int($iNumber)
Return $iNumber >= 1 And $iNumber <= 12
EndFunc
Func _DateIsValid($sDate)
Local $asDatePart[4], $asTimePart[4]
_DateTimeSplit($sDate, $asDatePart, $asTimePart)
If Not StringIsInt($asDatePart[1]) Then Return 0
If Not StringIsInt($asDatePart[2]) Then Return 0
If Not StringIsInt($asDatePart[3]) Then Return 0
$asDatePart[1] = Int($asDatePart[1])
$asDatePart[2] = Int($asDatePart[2])
$asDatePart[3] = Int($asDatePart[3])
Local $iNumDays = _DaysInMonth($asDatePart[1])
If $asDatePart[1] < 1000 Or $asDatePart[1] > 2999 Then Return 0
If $asDatePart[2] < 1 Or $asDatePart[2] > 12 Then Return 0
If $asDatePart[3] < 1 Or $asDatePart[3] > $iNumDays[$asDatePart[2]] Then Return 0
If $asTimePart[0] < 1 Then Return 1
If $asTimePart[0] < 2 Then Return 0
If $asTimePart[0] = 2 Then $asTimePart[3] = "00"
If Not StringIsInt($asTimePart[1]) Then Return 0
If Not StringIsInt($asTimePart[2]) Then Return 0
If Not StringIsInt($asTimePart[3]) Then Return 0
$asTimePart[1] = Int($asTimePart[1])
$asTimePart[2] = Int($asTimePart[2])
$asTimePart[3] = Int($asTimePart[3])
If $asTimePart[1] < 0 Or $asTimePart[1] > 23 Then Return 0
If $asTimePart[2] < 0 Or $asTimePart[2] > 59 Then Return 0
If $asTimePart[3] < 0 Or $asTimePart[3] > 59 Then Return 0
Return 1
EndFunc
Func _DateTimeFormat($sDate, $sType)
Local $asDatePart[4], $asTimePart[4]
Local $sTempDate = "", $sTempTime = ""
Local $sAM, $sPM, $sTempString = ""
If Not _DateIsValid($sDate) Then
Return SetError(1, 0, "")
EndIf
If $sType < 0 Or $sType > 5 Or Not IsInt($sType) Then
Return SetError(2, 0, "")
EndIf
_DateTimeSplit($sDate, $asDatePart, $asTimePart)
Switch $sType
Case 0
$sTempString = _WinAPI_GetLocaleInfo($LOCALE_USER_DEFAULT, $LOCALE_SSHORTDATE)
If Not @error And Not($sTempString = '') Then
$sTempDate = $sTempString
Else
$sTempDate = "M/d/yyyy"
EndIf
If $asTimePart[0] > 1 Then
$sTempString = _WinAPI_GetLocaleInfo($LOCALE_USER_DEFAULT, $LOCALE_STIMEFORMAT)
If Not @error And Not($sTempString = '') Then
$sTempTime = $sTempString
Else
$sTempTime = "h:mm:ss tt"
EndIf
EndIf
Case 1
$sTempString = _WinAPI_GetLocaleInfo($LOCALE_USER_DEFAULT, $LOCALE_SLONGDATE)
If Not @error And Not($sTempString = '') Then
$sTempDate = $sTempString
Else
$sTempDate = "dddd, MMMM dd, yyyy"
EndIf
Case 2
$sTempString = _WinAPI_GetLocaleInfo($LOCALE_USER_DEFAULT, $LOCALE_SSHORTDATE)
If Not @error And Not($sTempString = '') Then
$sTempDate = $sTempString
Else
$sTempDate = "M/d/yyyy"
EndIf
Case 3
If $asTimePart[0] > 1 Then
$sTempString = _WinAPI_GetLocaleInfo($LOCALE_USER_DEFAULT, $LOCALE_STIMEFORMAT)
If Not @error And Not($sTempString = '') Then
$sTempTime = $sTempString
Else
$sTempTime = "h:mm:ss tt"
EndIf
EndIf
Case 4
If $asTimePart[0] > 1 Then
$sTempTime = "hh:mm"
EndIf
Case 5
If $asTimePart[0] > 1 Then
$sTempTime = "hh:mm:ss"
EndIf
EndSwitch
If $sTempDate <> "" Then
$sTempString = _WinAPI_GetLocaleInfo($LOCALE_USER_DEFAULT, $LOCALE_SDATE)
If Not @error And Not($sTempString = '') Then
$sTempDate = StringReplace($sTempDate, "/", $sTempString)
EndIf
Local $iWday = _DateToDayOfWeek($asDatePart[1], $asDatePart[2], $asDatePart[3])
$asDatePart[3] = StringRight("0" & $asDatePart[3], 2)
$asDatePart[2] = StringRight("0" & $asDatePart[2], 2)
$sTempDate = StringReplace($sTempDate, "d", "@")
$sTempDate = StringReplace($sTempDate, "m", "#")
$sTempDate = StringReplace($sTempDate, "y", "&")
$sTempDate = StringReplace($sTempDate, "@@@@", _DateDayOfWeek($iWday, 0))
$sTempDate = StringReplace($sTempDate, "@@@", _DateDayOfWeek($iWday, 1))
$sTempDate = StringReplace($sTempDate, "@@", $asDatePart[3])
$sTempDate = StringReplace($sTempDate, "@", StringReplace(StringLeft($asDatePart[3], 1), "0", "") & StringRight($asDatePart[3], 1))
$sTempDate = StringReplace($sTempDate, "####", _DateToMonth($asDatePart[2], 0))
$sTempDate = StringReplace($sTempDate, "###", _DateToMonth($asDatePart[2], 1))
$sTempDate = StringReplace($sTempDate, "##", $asDatePart[2])
$sTempDate = StringReplace($sTempDate, "#", StringReplace(StringLeft($asDatePart[2], 1), "0", "") & StringRight($asDatePart[2], 1))
$sTempDate = StringReplace($sTempDate, "&&&&", $asDatePart[1])
$sTempDate = StringReplace($sTempDate, "&&", StringRight($asDatePart[1], 2))
EndIf
If $sTempTime <> "" Then
$sTempString = _WinAPI_GetLocaleInfo($LOCALE_USER_DEFAULT, $LOCALE_S1159)
If Not @error And Not($sTempString = '') Then
$sAM = $sTempString
Else
$sAM = "AM"
EndIf
$sTempString = _WinAPI_GetLocaleInfo($LOCALE_USER_DEFAULT, $LOCALE_S2359)
If Not @error And Not($sTempString = '') Then
$sPM = $sTempString
Else
$sPM = "PM"
EndIf
$sTempString = _WinAPI_GetLocaleInfo($LOCALE_USER_DEFAULT, $LOCALE_STIME)
If Not @error And Not($sTempString = '') Then
$sTempTime = StringReplace($sTempTime, ":", $sTempString)
EndIf
If StringInStr($sTempTime, "tt") Then
If $asTimePart[1] < 12 Then
$sTempTime = StringReplace($sTempTime, "tt", $sAM)
If $asTimePart[1] = 0 Then $asTimePart[1] = 12
Else
$sTempTime = StringReplace($sTempTime, "tt", $sPM)
If $asTimePart[1] > 12 Then $asTimePart[1] = $asTimePart[1] - 12
EndIf
EndIf
$asTimePart[1] = StringRight("0" & $asTimePart[1], 2)
$asTimePart[2] = StringRight("0" & $asTimePart[2], 2)
$asTimePart[3] = StringRight("0" & $asTimePart[3], 2)
$sTempTime = StringReplace($sTempTime, "hh", StringFormat("%02d", $asTimePart[1]))
$sTempTime = StringReplace($sTempTime, "h", StringReplace(StringLeft($asTimePart[1], 1), "0", "") & StringRight($asTimePart[1], 1))
$sTempTime = StringReplace($sTempTime, "mm", StringFormat("%02d", $asTimePart[2]))
$sTempTime = StringReplace($sTempTime, "ss", StringFormat("%02d", $asTimePart[3]))
$sTempDate = StringStripWS($sTempDate & " " & $sTempTime, $STR_STRIPLEADING + $STR_STRIPTRAILING)
EndIf
Return $sTempDate
EndFunc
Func _DateTimeSplit($sDate, ByRef $aDatePart, ByRef $iTimePart)
Local $sDateTime = StringSplit($sDate, " T")
If $sDateTime[0] > 0 Then $aDatePart = StringSplit($sDateTime[1], "/-.")
If $sDateTime[0] > 1 Then
$iTimePart = StringSplit($sDateTime[2], ":")
If UBound($iTimePart) < 4 Then ReDim $iTimePart[4]
Else
Dim $iTimePart[4]
EndIf
If UBound($aDatePart) < 4 Then ReDim $aDatePart[4]
For $x = 1 To 3
If StringIsInt($aDatePart[$x]) Then
$aDatePart[$x] = Int($aDatePart[$x])
Else
$aDatePart[$x] = -1
EndIf
If StringIsInt($iTimePart[$x]) Then
$iTimePart[$x] = Int($iTimePart[$x])
Else
$iTimePart[$x] = 0
EndIf
Next
Return 1
EndFunc
Func _DateToDayOfWeek($iYear, $iMonth, $iDay)
If Not _DateIsValid($iYear & "/" & $iMonth & "/" & $iDay) Then
Return SetError(1, 0, "")
EndIf
Local $i_FactorA = Int((14 - $iMonth) / 12)
Local $i_FactorY = $iYear - $i_FactorA
Local $i_FactorM = $iMonth +(12 * $i_FactorA) - 2
Local $i_FactorD = Mod($iDay + $i_FactorY + Int($i_FactorY / 4) - Int($i_FactorY / 100) + Int($i_FactorY / 400) + Int((31 * $i_FactorM) / 12), 7)
Return $i_FactorD + 1
EndFunc
Func _DateToMonth($iMonNum, $iFormat = Default)
If $iFormat = Default Then $iFormat = 0
$iMonNum = Int($iMonNum)
If Not __DateIsMonth($iMonNum) Then Return SetError(1, 0, "")
Local $tSYSTEMTIME = DllStructCreate($tagSYSTEMTIME)
DllStructSetData($tSYSTEMTIME, "Year", @YEAR)
DllStructSetData($tSYSTEMTIME, "Month", $iMonNum)
DllStructSetData($tSYSTEMTIME, "Day", 1)
Return _WinAPI_GetDateFormat(BitAND($iFormat, $DMW_LOCALE_LONGNAME) ? $LOCALE_USER_DEFAULT : $LOCALE_INVARIANT, $tSYSTEMTIME, 0, BitAND($iFormat, $DMW_SHORTNAME) ? "MMM" : "MMMM")
EndFunc
Func _NowTime($sType = 3)
If $sType < 3 Or $sType > 5 Then $sType = 3
Return _DateTimeFormat(@YEAR & "/" & @MON & "/" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC, $sType)
EndFunc
Func _DaysInMonth($iYear)
Local $aDays = [12, 31,(_DateIsLeapYear($iYear) ? 29 : 28), 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
Return $aDays
EndFunc
Func _Date_Time_GetTickCount()
Local $aResult = DllCall("kernel32.dll", "dword", "GetTickCount")
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _ArrayDelete(ByRef $aArray, $vRange)
If Not IsArray($aArray) Then Return SetError(1, 0, -1)
Local $iDim_1 = UBound($aArray, $UBOUND_ROWS) - 1
If IsArray($vRange) Then
If UBound($vRange, $UBOUND_DIMENSIONS) <> 1 Or UBound($vRange, $UBOUND_ROWS) < 2 Then Return SetError(4, 0, -1)
Else
Local $iNumber, $aSplit_1, $aSplit_2
$vRange = StringStripWS($vRange, 8)
$aSplit_1 = StringSplit($vRange, ";")
$vRange = ""
For $i = 1 To $aSplit_1[0]
If Not StringRegExp($aSplit_1[$i], "^\d+(-\d+)?$") Then Return SetError(3, 0, -1)
$aSplit_2 = StringSplit($aSplit_1[$i], "-")
Switch $aSplit_2[0]
Case 1
$vRange &= $aSplit_2[1] & ";"
Case 2
If Number($aSplit_2[2]) >= Number($aSplit_2[1]) Then
$iNumber = $aSplit_2[1] - 1
Do
$iNumber += 1
$vRange &= $iNumber & ";"
Until $iNumber = $aSplit_2[2]
EndIf
EndSwitch
Next
$vRange = StringSplit(StringTrimRight($vRange, 1), ";")
EndIf
If $vRange[1] < 0 Or $vRange[$vRange[0]] > $iDim_1 Then Return SetError(5, 0, -1)
Local $iCopyTo_Index = 0
Switch UBound($aArray, $UBOUND_DIMENSIONS)
Case 1
For $i = 1 To $vRange[0]
$aArray[$vRange[$i]] = ChrW(0xFAB1)
Next
For $iReadFrom_Index = 0 To $iDim_1
If $aArray[$iReadFrom_Index] == ChrW(0xFAB1) Then
ContinueLoop
Else
If $iReadFrom_Index <> $iCopyTo_Index Then
$aArray[$iCopyTo_Index] = $aArray[$iReadFrom_Index]
EndIf
$iCopyTo_Index += 1
EndIf
Next
ReDim $aArray[$iDim_1 - $vRange[0] + 1]
Case 2
Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS) - 1
For $i = 1 To $vRange[0]
$aArray[$vRange[$i]][0] = ChrW(0xFAB1)
Next
For $iReadFrom_Index = 0 To $iDim_1
If $aArray[$iReadFrom_Index][0] == ChrW(0xFAB1) Then
ContinueLoop
Else
If $iReadFrom_Index <> $iCopyTo_Index Then
For $j = 0 To $iDim_2
$aArray[$iCopyTo_Index][$j] = $aArray[$iReadFrom_Index][$j]
Next
EndIf
$iCopyTo_Index += 1
EndIf
Next
ReDim $aArray[$iDim_1 - $vRange[0] + 1][$iDim_2 + 1]
Case Else
Return SetError(2, 0, False)
EndSwitch
Return UBound($aArray, $UBOUND_ROWS)
EndFunc
Func _ArrayToString(Const ByRef $aArray, $sDelim_Col = "|", $iStart_Row = -1, $iEnd_Row = -1, $sDelim_Row = @CRLF, $iStart_Col = -1, $iEnd_Col = -1)
If $sDelim_Col = Default Then $sDelim_Col = "|"
If $sDelim_Row = Default Then $sDelim_Row = @CRLF
If $iStart_Row = Default Then $iStart_Row = -1
If $iEnd_Row = Default Then $iEnd_Row = -1
If $iStart_Col = Default Then $iStart_Col = -1
If $iEnd_Col = Default Then $iEnd_Col = -1
If Not IsArray($aArray) Then Return SetError(1, 0, -1)
Local $iDim_1 = UBound($aArray, $UBOUND_ROWS) - 1
If $iStart_Row = -1 Then $iStart_Row = 0
If $iEnd_Row = -1 Then $iEnd_Row = $iDim_1
If $iStart_Row < -1 Or $iEnd_Row < -1 Then Return SetError(3, 0, -1)
If $iStart_Row > $iDim_1 Or $iEnd_Row > $iDim_1 Then Return SetError(3, 0, "")
If $iStart_Row > $iEnd_Row Then Return SetError(4, 0, -1)
Local $sRet = ""
Switch UBound($aArray, $UBOUND_DIMENSIONS)
Case 1
For $i = $iStart_Row To $iEnd_Row
$sRet &= $aArray[$i] & $sDelim_Col
Next
Return StringTrimRight($sRet, StringLen($sDelim_Col))
Case 2
Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS) - 1
If $iStart_Col = -1 Then $iStart_Col = 0
If $iEnd_Col = -1 Then $iEnd_Col = $iDim_2
If $iStart_Col < -1 Or $iEnd_Col < -1 Then Return SetError(5, 0, -1)
If $iStart_Col > $iDim_2 Or $iEnd_Col > $iDim_2 Then Return SetError(5, 0, -1)
If $iStart_Col > $iEnd_Col Then Return SetError(6, 0, -1)
For $i = $iStart_Row To $iEnd_Row
For $j = $iStart_Col To $iEnd_Col
$sRet &= $aArray[$i][$j] & $sDelim_Col
Next
$sRet = StringTrimRight($sRet, StringLen($sDelim_Col)) & $sDelim_Row
Next
Return StringTrimRight($sRet, StringLen($sDelim_Row))
Case Else
Return SetError(2, 0, -1)
EndSwitch
Return 1
EndFunc
Global $hNtDll = DllOpen("ntdll.dll")
Global Const $COLOR_ERROR = $COLOR_RED
Global Const $COLOR_DEBUG = $COLOR_PURPLE
Global Const $g_sLibPath = @ScriptDir & "\lib"
Global Const $g_sLibIconPath = $g_sLibPath & "\MBRBOT.dll"
Global Enum $eIcnArcher = 1, $eIcnDonArcher, $eIcnBalloon, $eIcnDonBalloon, $eIcnBarbarian, $eIcnDonBarbarian, $eBtnTest, $eIcnBuilder, $eIcnCC, $eIcnGUI
Global $g_WatchDogLogStatusBar = False
Global $g_WatchOnlyClientPID = Default
Global $g_bRunState = True
Global $g_hFrmBot = 0
Global $g_hStatusBar = 0
Global $hMutex_BotTitle = 0
Global $hStarted = 0
Global $bCloseWhenAllBotsUnregistered = True
Global $iTimeoutBroadcast = 15000
Global $iTimeoutCheckBot = 5000
Global $iTimeoutRestartBot = 180000
Global $iTimeoutAutoClose = 60000
Global $hTimeoutAutoClose = 0
Global $g_iDebugWindowMessages = 0
Global $hStruct_SleepMicro = DllStructCreate("int64 time;")
Global $pStruct_SleepMicro = DllStructGetPtr($hStruct_SleepMicro)
Global $DELAYSLEEP = 500
Global $g_bDebugSetlog = False
Global $g_bDebugAndroid = False
Global $g_asCmdLine = [0]
Global Enum $eLootGold, $eLootElixir, $eLootDarkElixir, $eLootTrophy, $eLootCount
Global $g_aiCurrentLoot[$eLootCount] = [0, 0, 0, 0]
Global $g_iStatsTotalGain[$eLootCount] = [0, 0, 0, 0]
Global $g_iStatsLastAttack[$eLootCount] = [0, 0, 0, 0]
Global $g_iStatsBonusLast[$eLootCount] = [0, 0, 0, 0]
Func _GUICtrlStatusBar_SetTextEx($a, $b)
EndFunc
Func SetLog($String, $Color = $COLOR_BLACK, $LogPrefix = "L ")
Local $log = $LogPrefix & TimeDebug() & $String
_ConsoleWrite($log & @CRLF)
EndFunc
Func SetDebugLog($String, $Color = $COLOR_DEBUG, $LogPrefix = "D ")
Return SetLog($String, $Color, $LogPrefix)
EndFunc
Func _Sleep($ms, $iSleep = True, $CheckRunState = True)
_SleepMilli($ms)
EndFunc
Func _SleepMicro($iMicroSec)
DllStructSetData($hStruct_SleepMicro, "time", $iMicroSec * -10)
DllCall($hNtDll, "dword", "ZwDelayExecution", "int", 0, "ptr", $pStruct_SleepMicro)
EndFunc
Func _SleepMilli($iMilliSec)
_SleepMicro(Int($iMilliSec * 1000))
EndFunc
Func UpdateManagedMyBot($aBotDetails)
Return True
EndFunc
Global $g_sBotTitle = "My Bot Watchdog " & $g_sBotVersion
Opt("WinTitleMatchMode", 3)
Global Enum $g_eBotDetailsBotForm = 0, $g_eBotDetailsTimer, $g_eBotDetailsProfile, $g_eBotDetailsCommandLine, $g_eBotDetailsTitle, $g_eBotDetailsRunState, $g_eBotDetailsPaused, $g_eBotDetailsLaunched, $g_eBotDetailsVerifyCount, $g_eBotDetailsBotStateStruct, $g_eBotDetailsOptionalStruct, $g_eBotDetailsArraySize
Global $tagSTRUCT_BOT_STATE = "struct" & ";hwnd BotHWnd" & ";hwnd AndroidHWnd" & ";boolean RunState" & ";boolean Paused" & ";boolean Launched" & ";uint64 g_hTimerSinceStarted" & ";uint g_iTimePassed" & ";char Profile[64]" & ";char AndroidEmulator[32]" & ";char AndroidInstance[32]" & ";int StructType" & ";ptr StructPtr" & ";boolean RegisterInHost" & ";endstruct"
Global Enum $g_eSTRUCT_NONE = 0, $g_eSTRUCT_STATUS_BAR, $g_eSTRUCT_UPDATE_STATS
Global $tagSTRUCT_STATUS_BAR = "struct;char Text[255];endstruct"
Global $tagSTRUCT_UPDATE_STATS = "struct" & ";long g_aiCurrentLoot[" & UBound($g_aiCurrentLoot) & "]" & ";long g_iFreeBuilderCount" & ";long g_iTotalBuilderCount" & ";long g_iGemAmount" & ";long g_iStatsTotalGain[" & UBound($g_iStatsTotalGain) & "]" & ";long g_iStatsLastAttack[" & UBound($g_iStatsLastAttack) & "]" & ";long g_iStatsBonusLast[" & UBound($g_iStatsBonusLast) & "]" & ";int g_iFirstAttack" & ";int g_aiAttackedCount" & ";int g_iSkippedVillageCount" & ";endstruct"
Global $tBotState = DllStructCreate($tagSTRUCT_BOT_STATE)
Global $tStatusBar = DllStructCreate($tagSTRUCT_STATUS_BAR)
Global $tUpdateStats = DllStructCreate($tagSTRUCT_UPDATE_STATS)
Global $API_VERSION = "1.1"
Global $sWatchdogMutex = "MyBot.run/ManageFarm/" & $API_VERSION
Global $WM_MYBOTRUN_API = _WinAPI_RegisterWindowMessage("MyBot.run/API/" & $API_VERSION)
SetDebugLog("MyBot.run/API/1.1 Message ID = " & $WM_MYBOTRUN_API)
Global $WM_MYBOTRUN_STATE = _WinAPI_RegisterWindowMessage("MyBot.run/STATE/" & $API_VERSION)
SetDebugLog("MyBot.run/STATE/1.1 Message ID = " & $WM_MYBOTRUN_STATE)
Func _MemoryOpen($iv_Pid, $iv_DesiredAccess = 0x1F0FFF, $if_InheritHandle = 1)
If Not ProcessExists($iv_Pid) Then
SetError(1)
Return 0
EndIf
Local $ah_Handle[2] = [DllOpen('kernel32.dll')]
If @Error Then
SetError(2)
Return 0
EndIf
Local $av_OpenProcess = DllCall($ah_Handle[0], 'int', 'OpenProcess', 'int', $iv_DesiredAccess, 'int', $if_InheritHandle, 'int', $iv_Pid)
If @Error Then
DllClose($ah_Handle[0])
SetError(3)
Return 0
EndIf
$ah_Handle[1] = $av_OpenProcess[0]
Return $ah_Handle
EndFunc
Func _MemoryClose($ah_Handle)
If Not IsArray($ah_Handle) Then
SetError(1)
Return 0
EndIf
DllCall($ah_Handle[0], 'int', 'CloseHandle', 'int', $ah_Handle[1])
If Not @Error Then
DllClose($ah_Handle[0])
Return 1
Else
DllClose($ah_Handle[0])
SetError(2)
Return 0
EndIf
EndFunc
Func _MemoryReadStruct($iv_Address, $ah_Handle, ByRef $tStruct)
If Not IsArray($ah_Handle) Then
SetError(1)
Return 0
EndIf
DllCall($ah_Handle[0], 'int', 'ReadProcessMemory', 'int', $ah_Handle[1], 'int', $iv_Address, 'ptr', DllStructGetPtr($tStruct), 'int', DllStructGetSize($tStruct), 'int', '')
If Not @Error Then
Return 1
Else
SetError(6)
Return 0
EndIf
EndFunc
Global $g_ahManagedMyBotDetails[0]
GUIRegisterMsg($WM_MYBOTRUN_API, "WM_MYBOTRUN_API_HOST")
GUIRegisterMsg($WM_MYBOTRUN_STATE, "WM_MYBOTRUN_STATE")
Func WM_MYBOTRUN_API_HOST($hWind, $iMsg, $wParam, $lParam)
If $g_iDebugWindowMessages Then SetDebugLog("API-HOST: $hWind=" & $hWind & ",$iMsg=" & $iMsg & ",$wParam=" & $wParam & ",$lParam=" & $lParam)
$hWind = HWnd($lParam)
Local $wParamHi = BitShift($wParam, 16)
Local $wParamLo = BitAND($wParam, 0xFFFF)
Switch $wParamLo
Case 0x00FF, 0x01FF
$hWind = 0
Case 0x1040 + 2
$hWind = 0
UnregisterManagedMyBotClient($lParam)
Case Else
Local $_RunState = BitAND($wParamHi, 1) > 0
Local $_TPaused = BitAND($wParamHi, 2) > 0
Local $_bLaunched = BitAND($wParamHi, 4) > 0
GetManagedMyBotDetails($hWind, $g_WatchOnlyClientPID, $_RunState, $_TPaused, $_bLaunched)
$hWind = 0
EndSwitch
If $hWind <> 0 Then
_WinAPI_PostMessage($hWind, $iMsg, $wParam, $lParam)
EndIf
EndFunc
Func WM_MYBOTRUN_STATE($hWind, $iMsg, $wParam, $lParam)
If $g_iDebugWindowMessages Then SetDebugLog("API-HOST-STATE: $hWind=" & $hWind & ",$iMsg=" & $iMsg & ",$wParam=" & $wParam & ",$lParam=" & $lParam)
Local $_frmBot = HWnd($lParam)
Local $pid = WinGetProcess($_frmBot)
If $pid Then
Local $hMem = _MemoryOpen($pid)
If _MemoryReadStruct($wParam, $hMem, $tBotState) = 1 Then
Local $_RunState = DllStructGetData($tBotState, "RunState")
Local $_TPaused = DllStructGetData($tBotState, "Paused")
Local $_bLaunched = DllStructGetData($tBotState, "Launched")
GetManagedMyBotDetails($_frmBot, $g_WatchOnlyClientPID, $_RunState, $_TPaused, $_bLaunched, Default, $tBotState, $hMem)
Else
SetDebugLog("API-HOST-STATE: Cannot read memory from process: " & $pid)
EndIf
_MemoryClose($hMem)
Else
SetDebugLog("API-HOST-STATE: Cannot access PID for Window Handle: " & $lParam)
EndIf
EndFunc
Func UpdateManagedMyBotArray(ByRef $a, ByRef $pid, ByRef $sTitle, ByRef $_RunState, ByRef $_TPaused, ByRef $_bLaunched, ByRef $iVerifyCount, ByRef $_tBotState, ByRef $hMem, $aLoaded = Default)
$a[$g_eBotDetailsTimer] = __TimerInit()
$a[$g_eBotDetailsTitle] = $sTitle
If $_RunState <> Default Then $a[$g_eBotDetailsRunState] = $_RunState
If $_TPaused <> Default Then $a[$g_eBotDetailsPaused] = $_TPaused
If $_bLaunched <> Default Then $a[$g_eBotDetailsLaunched] = $_bLaunched
$a[$g_eBotDetailsVerifyCount] = $iVerifyCount
Local $bRegisterInHost = True
If $_tBotState <> Default Then
$a[$g_eBotDetailsBotStateStruct] = $_tBotState
Local $tStruct = 0
If UBound($aLoaded) >= UBound($a) Then
$tStruct = $aLoaded[$g_eBotDetailsOptionalStruct]
Else
$a[$g_eBotDetailsProfile] = DllStructGetData($tBotState, "Profile")
$bRegisterInHost = DllStructGetData($tBotState, "RegisterInHost")
If $hMem <> Default Then
Local $eStructType = DllStructGetData($tBotState, "StructType")
Local $pStructPtr = DllStructGetData($tBotState, "StructPtr")
Switch $eStructType
Case $g_eSTRUCT_STATUS_BAR
If $g_iDebugWindowMessages Then SetDebugLog("UpdateManagedMyBotArray: Reading StatusBar Text")
If _MemoryReadStruct($pStructPtr, $hMem, $tStatusBar) = 1 Then
$tStruct = $tStatusBar
If $g_WatchDogLogStatusBar Then SetDebugLog("PID: " & $pid & ", StatusBar Text: " & DllStructGetData($tStatusBar, "Text"))
EndIf
Case $g_eSTRUCT_UPDATE_STATS
If $g_iDebugWindowMessages Then SetDebugLog("UpdateManagedMyBotArray: Reading Update Stats")
If _MemoryReadStruct($pStructPtr, $hMem, $tUpdateStats) = 1 Then
$tStruct = $tUpdateStats
If $g_iDebugWindowMessages Then SetDebugLog("UpdateManagedMyBotArray: Update Stats read")
EndIf
EndSwitch
EndIf
EndIf
$a[$g_eBotDetailsOptionalStruct] = $tStruct
EndIf
Return $bRegisterInHost
EndFunc
Func GetManagedMyBotDetails($hFrmBot = Default, $iFilterPID = Default, $_RunState = Default, $_TPaused = Default, $_bLaunched = Default, $iVerifyCount = Default, $_tBotState = Default, $hMem = Default)
If $hFrmBot = Default Then Return $g_ahManagedMyBotDetails
If $iVerifyCount = Default Then $iVerifyCount = 2
If IsHWnd($hFrmBot) = 0 Then Return -1
If $iFilterPID <> Default And WinGetProcess($hFrmBot) <> $iFilterPID Then Return -2
Local $pid = WinGetProcess($hFrmBot)
Local $sTitle = WinGetTitle($hFrmBot)
If $pid = -1 Then SetLog("Process not found for Window Handle: " & $hFrmBot)
Local $aNew[$g_eBotDetailsArraySize]
Local $bRegisterInHost = UpdateManagedMyBotArray($aNew, $pid, $sTitle, $_RunState, $_TPaused, $_bLaunched, $iVerifyCount, $_tBotState, $hMem)
Local $sProfile = $aNew[$g_eBotDetailsProfile]
For $i = 0 To UBound($g_ahManagedMyBotDetails) - 1
If $i > UBound($g_ahManagedMyBotDetails) - 1 Then ExitLoop
Local $a = $g_ahManagedMyBotDetails[$i]
If $a[$g_eBotDetailsBotForm] = $hFrmBot Then
UpdateManagedMyBotArray($a, $pid, $sTitle, $_RunState, $_TPaused, $_bLaunched, $iVerifyCount, $_tBotState, $hMem, $aNew)
$g_ahManagedMyBotDetails[$i] = $a
If $g_iDebugWindowMessages Then SetDebugLog("Bot Window state received: " & GetManagedMyBotInfoString($a))
Execute("UpdateManagedMyBot($a)")
Return $a
EndIf
If($sProfile And $a[$g_eBotDetailsProfile] = $sProfile) Or(Not $sProfile And $a[$g_eBotDetailsTitle] = $sTitle) Then
SetDebugLog("Remove registered Bot Window Handle " & $a[$g_eBotDetailsBotForm] & ", as new instance detected")
_ArrayDelete($g_ahManagedMyBotDetails, $i)
$i -= 1
EndIf
Next
$aNew[$g_eBotDetailsBotForm] = $hFrmBot
If Execute("UpdateManagedMyBot($aNew)") Then
$aNew[$g_eBotDetailsCommandLine] = ProcessGetCommandLine($pid)
Local $i = UBound($g_ahManagedMyBotDetails)
ReDim $g_ahManagedMyBotDetails[$i + 1]
If $aNew[$g_eBotDetailsCommandLine] = -1 Then SetLog("Command line not found for Window Handle/PID: " & $hFrmBot & "/" & $pid)
$g_ahManagedMyBotDetails[$i] = $aNew
SetDebugLog("New Bot Window Handle registered: " & GetManagedMyBotInfoString($aNew))
EndIf
Return $aNew
EndFunc
Func GetManagedMyBotInfoString(ByRef $a)
If UBound($a) < $g_eBotDetailsArraySize Then Return "unknown"
Return "HWnd=" & $a[$g_eBotDetailsBotForm] & ", PID=" & WinGetProcess($a[$g_eBotDetailsBotForm]) & ", " & $a[$g_eBotDetailsProfile] & ", " & $a[$g_eBotDetailsTitle] & ", " &($a[$g_eBotDetailsRunState] ? "running" : "not running") & ", " &($a[$g_eBotDetailsPaused] ? "paused" : "not paused") & ", " &($a[$g_eBotDetailsLaunched] ? "launched" : "launching") & ", " & $a[$g_eBotDetailsCommandLine]
EndFunc
Func UnregisterManagedMyBotClient($hFrmBot)
SetDebugLog("Try to un-register Bot Window Handle: " & $hFrmBot)
For $i = 0 To UBound($g_ahManagedMyBotDetails) - 1
Local $a = $g_ahManagedMyBotDetails[$i]
If $a[$g_eBotDetailsBotForm] = $hFrmBot Then
_ArrayDelete($g_ahManagedMyBotDetails, $i)
Local $Result = 1
If IsHWnd($hFrmBot) Then
SetDebugLog("Bot Window Handle un-registered: " & $hFrmBot)
Else
SetDebugLog("Inaccessible Bot Window Handle un-registered: " & $hFrmBot)
$Result = -1
EndIf
If $bCloseWhenAllBotsUnregistered = True And UBound($g_ahManagedMyBotDetails) = 0 Then
SetLog("Closing " & $g_sBotTitle & " as all bots closed")
Exit(1)
EndIf
Return $Result
EndIf
Next
SetDebugLog("Bot Window Handle not un-registered: " & $hFrmBot, $COLOR_RED)
Return 0
EndFunc
Func CheckManagedMyBot($iTimeout)
For $i = 0 To UBound($g_ahManagedMyBotDetails) - 1
Local $a = $g_ahManagedMyBotDetails[$i]
If __TimerDiff($a[$g_eBotDetailsTimer]) > $iTimeout Then
If $a[$g_eBotDetailsVerifyCount] > 0 Then
$a[$g_eBotDetailsVerifyCount] -= 1
$g_ahManagedMyBotDetails[$i] = $a
ContinueLoop
EndIf
_ArrayDelete($g_ahManagedMyBotDetails, $i)
Local $cmd = $a[$g_eBotDetailsCommandLine]
Local $g_sBotTitle = $a[$g_eBotDetailsTitle]
For $j = 0 To UBound($g_ahManagedMyBotDetails) - 1
$a = $g_ahManagedMyBotDetails[$j]
If $a[$g_eBotDetailsTitle] = $g_sBotTitle Then
SetDebugLog("Bot already restarted, window title: " & $g_sBotTitle)
Return WinGetProcess($a[$g_eBotDetailsBotForm])
EndIf
Next
If StringInStr($cmd, " /restart") = 0 Then $cmd &= " /restart"
If $a[$g_eBotDetailsRunState] Then
If StringInStr($cmd, " /autostart") = 0 Then $cmd &= " /autostart"
EndIf
SetDebugLog("Restarting bot: " & $cmd)
Return Run($cmd)
EndIf
Next
Return 0
EndFunc
Func GetActiveMyBotCount($iTimeout)
Local $iCount = 0
For $i = 0 To UBound($g_ahManagedMyBotDetails) - 1
Local $a = $g_ahManagedMyBotDetails[$i]
If __TimerDiff($a[$g_eBotDetailsTimer]) <= $iTimeout Then
$iCount += 1
Else
SetDebugLog("Bot not responding with Window Handle: " & $a[$g_eBotDetailsBotForm])
EndIf
Next
Return $iCount
EndFunc
Func CreateMutex($sMutex)
Local $hMutex = _WinAPI_CreateMutex($sMutex, False)
If $hMutex Then
Switch _WinAPI_WaitForSingleObject($hMutex, 0)
Case 0x80, 0
Return $hMutex
EndSwitch
_WinAPI_CloseHandle($hMutex)
EndIf
Return 0
EndFunc
Func ReleaseMutex($hMutex, $ReturnValue = Default)
If $hMutex Then
_WinAPI_ReleaseMutex($hMutex)
_WinAPI_CloseHandle($hMutex)
EndIf
If $ReturnValue = Default Then Return
Return $ReturnValue
EndFunc
Func LockSemaphore($Semaphore, $sWaitMessage = Default)
Local $bAquired = False
If $sWaitMessage = Default Then $sWaitMessage = "Waiting for slot to become available..."
Local $iDelay = $DELAYSLEEP
If $sWaitMessage Then $iDelay = 1000
Local $hSemaphore = $Semaphore
If IsString($Semaphore) = 1 Then $hSemaphore = _WinAPI_CreateSemaphore($Semaphore, 1, 1)
Local $bLogged = False
While $bAquired = False And $g_bRunState = True
$bAquired = _WinAPI_WaitForSingleObject($hSemaphore, $DELAYSLEEP) <> $WAIT_TIMEOUT
If $bAquired = True Then
Return $hSemaphore
EndIf
If $sWaitMessage Then
If $bLogged = False Then
$bLogged = True
SetLog($sWaitMessage)
EndIf
_GUICtrlStatusBar_SetTextEx($g_hStatusBar, $sWaitMessage)
EndIf
_Sleep($iDelay, True, False)
WEnd
If $Semaphore <> $hSemaphore Then _WinAPI_CloseHandle($hSemaphore)
Return 0
EndFunc
Func UnlockSemaphore(ByRef $hSemaphore, $bCloseHandle = False)
If $hSemaphore <> 0 And $hSemaphore <> -1 Then
Local $iPreviousCount = _WinAPI_ReleaseSemaphore($hSemaphore)
If $bCloseHandle = True Then
_WinAPI_CloseHandle($hSemaphore)
$hSemaphore = 0
EndIf
Return $iPreviousCount
EndIf
Return -1
EndFunc
Global $g_oWMI = 0
Global $g_WmiAPI_External = False
Global Static $g_WmiFields = ["Handle", "ExecutablePath", "CommandLine"]
Func GetWmiSelectFields()
Return _ArrayToString($g_WmiFields, ",")
EndFunc
Func GetWmiObject()
If $g_oWMI = 0 Then $g_oWMI = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
Return $g_oWMI
EndFunc
Func CloseWmiObject()
$g_oWMI = 0
EndFunc
Func WmiQuery($sQuery)
If $g_WmiAPI_External = True Then
Local $sAppFile = @ScriptDir & "\MyBot.run.Wmi." &((@Compiled) ?("exe") :("au3"))
If FileExists($sAppFile) Then
Local $process_killed
Local $cmd = """" & $sAppFile & """"
If @Compiled = 0 Then $cmd = """" & @AutoItExe & """ /AutoIt3ExecuteScript """ & $sAppFile & """"
Local $s = LaunchConsole($cmd, """" & $sQuery & """", $process_killed)
Return WmiOutputToArray($s)
EndIf
EndIf
Local $aProcesses[0]
SetDebugLog("WMI Query: " & $sQuery)
Local $oProcessColl = GetWmiObject().ExecQuery($sQuery, "WQL", 0x20 + 0x10)
For $Process In $oProcessColl
Local $aProcess[UBound($g_WmiFields)]
For $i = 0 To UBound($g_WmiFields) - 1
$aProcess[$i] = Execute("$Process." & $g_WmiFields[$i])
Next
ReDim $aProcesses[UBound($aProcesses) + 1]
$aProcesses[UBound($aProcesses) - 1] = $aProcess
Next
Return $aProcesses
EndFunc
Func WmiOutputToArray(ByRef $s)
Local $aProcesses[0]
Local $sProcesses = StringBetween($s, "<Processes>", "</Processes>")
If @error Then Return $aProcesses
Local $iPos = 1
While $iPos > 0
Local $sProcess = StringBetween($sProcesses, "<Process>", "</Process>", $iPos)
$iPos = @extended
If $iPos > 0 Then
Local $aProcess[UBound($g_WmiFields)]
Local $iPos2 = 1
For $i = 0 To UBound($g_WmiFields) - 1
$aProcess[$i] = StringBetween($sProcess, "<" & $g_WmiFields[$i] & ">", "</" & $g_WmiFields[$i] & ">", $iPos2)
$iPos2 = @extended
Next
ReDim $aProcesses[UBound($aProcesses) + 1]
$aProcesses[UBound($aProcesses) - 1] = $aProcess
EndIf
WEnd
Return $aProcesses
EndFunc
Func StringBetween(ByRef $s, $sStartTag, $sEndTag, $iStartPos = 1)
Local $iS = StringInStr($s, $sStartTag, 0, 1, $iStartPos)
If $iS > 0 Then
$iS += StringLen($sStartTag)
Local $iE = StringInStr($s, $sEndTag, 0, 1, $iS)
If $iE > 0 Then
Return SetError(0, $iE + StringLen($sEndTag), StringMid($s, $iS, $iE - $iS))
EndIf
EndIf
Return SetError(1, 0, "")
EndFunc
Global Const $WM_SETICON = 0x0080
Global Const $STARTF_USESHOWWINDOW = 0x1
Global Const $STARTF_USESTDHANDLES = 0x100
Func _NamedPipes_CreatePipe(ByRef $hReadPipe, ByRef $hWritePipe, $tSecurity = 0, $iSize = 0)
Local $aResult = DllCall("kernel32.dll", "bool", "CreatePipe", "handle*", 0, "handle*", 0, "struct*", $tSecurity, "dword", $iSize)
If @error Then Return SetError(@error, @extended, False)
$hReadPipe = $aResult[1]
$hWritePipe = $aResult[2]
Return $aResult[0]
EndFunc
Global $g_RunPipe_hProcess = 0
Global $g_RunPipe_hThread = 0
Func LaunchConsole($cmd, $param, ByRef $process_killed, $timeout = 10000, $bUseSemaphore = False)
Local $bDebug = $g_bDebugSetlog Or $g_bDebugAndroid
If $bUseSemaphore Then
Local $hSemaphore = LockSemaphore(StringReplace($cmd, "\", "/"), "Waiting to launch: " & $cmd)
EndIf
Local $data, $pid, $hStdIn[2], $hStdOut[2], $hTimer, $hProcess, $hThread
If StringLen($param) > 0 Then $cmd &= " " & $param
$hTimer = __TimerInit()
$process_killed = False
If $bDebug Then SetLog("Func LaunchConsole: " & $cmd, $COLOR_DEBUG)
$pid = RunPipe($cmd, "", @SW_HIDE, $STDERR_MERGED, $hStdIn, $hStdOut, $hProcess, $hThread)
If $bDebug Then SetLog("Func LaunchConsole: command launched", $COLOR_DEBUG)
If $pid = 0 Then
SetLog("Launch faild: " & $cmd, $COLOR_ERROR)
If $bUseSemaphore = True Then UnlockSemaphore($hSemaphore)
Return
EndIf
Local $timeout_sec = Round($timeout / 1000)
Local $iWaitResult
Do
$iWaitResult = _WinAPI_WaitForSingleObject($hProcess, $DELAYSLEEP)
$data &= ReadPipe($hStdOut[0])
Until($timeout > 0 And __TimerDiff($hTimer) > $timeout) Or $iWaitResult <> $WAIT_TIMEOUT
If ProcessExists($pid) Then
If ClosePipe($pid, $hStdIn, $hStdOut, $hProcess, $hThread) = 1 Then
If $bDebug Then SetLog("Process killed: " & $cmd, $COLOR_ERROR)
$process_killed = True
EndIf
Else
ClosePipe($pid, $hStdIn, $hStdOut, $hProcess, $hThread)
EndIf
$g_RunPipe_hProcess = 0
$g_RunPipe_hThread = 0
CleanLaunchOutput($data)
If $bDebug Then SetLog("Func LaunchConsole Output: " & $data, $COLOR_DEBUG)
If $bUseSemaphore Then UnlockSemaphore($hSemaphore)
Return $data
EndFunc
Func ProcessGetCommandLine($pid, $strComputer = ".")
If Not IsNumber($pid) Then Return SetError(2, 0, -1)
Local $query = "Select " & GetWmiSelectFields() & " from Win32_Process where Handle = " & $pid
For $Process In WmiQuery($query)
SetDebugLog($Process[0] & " = " & $Process[2])
SetError(0, 0, 0)
Local $sProcessCommandLine = $Process[2]
$Process = 0
CloseWmiObject()
Return $sProcessCommandLine
Next
SetDebugLog("Process not found with PID " & $pid)
$Process = 0
CloseWmiObject()
Return SetError(1, 0, -1)
EndFunc
Func CleanLaunchOutput(ByRef $output)
$output = StringReplace($output, @CR & @CR, "")
$output = StringReplace($output, @CRLF & @CRLF, "")
If StringRight($output, 1) = @LF Then $output = StringLeft($output, StringLen($output) - 1)
If StringRight($output, 1) = @CR Then $output = StringLeft($output, StringLen($output) - 1)
EndFunc
Func RunPipe($program, $workdir, $show_flag, $opt_flag, ByRef $hStdIn, ByRef $hStdOut, ByRef $hProcess, ByRef $hThread)
If UBound($hStdIn) < 2 Then
Local $a = [0, 0]
$hStdIn = $a
EndIf
If UBound($hStdOut) < 2 Then
Local $a = [0, 0]
$hStdOut = $a
EndIf
Local $tSecurity = DllStructCreate($tagSECURITY_ATTRIBUTES)
DllStructSetData($tSecurity, "Length", DllStructGetSize($tSecurity))
DllStructSetData($tSecurity, "InheritHandle", True)
_NamedPipes_CreatePipe($hStdIn[0], $hStdIn[1], $tSecurity)
_WinAPI_SetHandleInformation($hStdIn[1], $HANDLE_FLAG_INHERIT, 0)
_NamedPipes_CreatePipe($hStdOut[0], $hStdOut[1], $tSecurity)
_WinAPI_SetHandleInformation($hStdOut[0], $HANDLE_FLAG_INHERIT, 0)
Local $StartupInfo = DllStructCreate($tagSTARTUPINFO)
DllStructSetData($StartupInfo, "Size", DllStructGetSize($StartupInfo))
DllStructSetData($StartupInfo, "Flags", $STARTF_USESTDHANDLES + $STARTF_USESHOWWINDOW)
DllStructSetData($StartupInfo, "StdInput", $hStdIn[0])
DllStructSetData($StartupInfo, "StdOutput", $hStdOut[1])
DllStructSetData($StartupInfo, "StdError", $hStdOut[1])
DllStructSetData($StartupInfo, "ShowWindow", $show_flag)
Local $lpStartupInfo = DllStructGetPtr($StartupInfo)
Local $ProcessInformation = DllStructCreate($tagPROCESS_INFORMATION)
Local $lpProcessInformation = DllStructGetPtr($ProcessInformation)
If __WinAPI_CreateProcess("", $program, 0, 0, True, 0, 0, $workdir, $lpStartupInfo, $lpProcessInformation) Then
Local $pid = DllStructGetData($ProcessInformation, "ProcessID")
$hProcess = DllStructGetData($ProcessInformation, "hProcess")
$hThread = DllStructGetData($ProcessInformation, "hThread")
Return $pid
EndIf
SetDebugLog("RunPipe: Failed creating new process: " & $program)
ClosePipe(0, $hStdIn, $hStdOut, 0, 0)
EndFunc
Func ClosePipe($pid, $hStdIn, $hStdOut, $hProcess, $hThread)
_WinAPI_CloseHandle($hStdIn[0])
_WinAPI_CloseHandle($hStdIn[1])
_WinAPI_CloseHandle($hStdOut[0])
_WinAPI_CloseHandle($hStdOut[1])
If $hProcess Then _WinAPI_CloseHandle($hProcess)
If $hThread Then _WinAPI_CloseHandle($hThread)
Return ProcessClose($pid)
EndFunc
Func ReadPipe(ByRef $hPipe)
If DataInPipe($hPipe) = 0 Then Return SetError(@error, @extended, "")
Local $tBuffer = DllStructCreate("char Text[4096]")
Local $iRead
If _WinAPI_ReadFile($hPipe, DllStructGetPtr($tBuffer), 4096, $iRead) Then
Return SetError(0, 0, DllStructGetData($tBuffer, "Text"))
EndIf
Return SetError(@error, @extended, "")
EndFunc
Func DataInPipe(ByRef $hPipe)
Local $aResult = DllCall("kernel32.dll", "bool", "PeekNamedPipe", "handle", $hPipe, "ptr", 0, "int", 0, "dword*", 0, "dword*", 0, "dword*", 0)
If @error Then Return SetError(@error, @extended, 0)
Return SetError(0, 0, $aResult[5])
EndFunc
Func __WinAPI_CreateProcess($sAppName, $sCommand, $tSecurity, $tThread, $bInherit, $iFlags, $pEnviron, $sDir, $tStartupInfo, $tProcess)
Local $tCommand = 0
Local $sAppNameType = "wstr", $sDirType = "wstr"
If $sAppName = "" Then
$sAppNameType = "ptr"
$sAppName = 0
EndIf
If $sCommand <> "" Then
$tCommand = DllStructCreate("wchar Text[" & 4096 + 1 & "]")
DllStructSetData($tCommand, "Text", $sCommand)
EndIf
If $sDir = "" Then
$sDirType = "ptr"
$sDir = 0
EndIf
Local $aResult = DllCall("kernel32.dll", "bool", "CreateProcessW", $sAppNameType, $sAppName, "struct*", $tCommand, "struct*", $tSecurity, "struct*", $tThread, "bool", $bInherit, "dword", $iFlags, "struct*", $pEnviron, $sDirType, $sDir, "struct*", $tStartupInfo, "struct*", $tProcess)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _WinAPI_AllocConsole()
Local $aResult = DllCall("kernel32.dll", "bool", "AllocConsole")
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _WinAPI_SetConsoleIcon($g_sLibIconPath, $nIconID, $hWnD = Default)
Local $hIcon = DllStructCreate("int")
Local $Result = DllCall("shell32.dll", "int", "ExtractIconEx", "str", $g_sLibIconPath, "int", $nIconID - 1, "hwnd", 0, "ptr", DllStructGetPtr($hIcon), "int", 1)
If UBound($Result) > 0 Then
$Result = $Result[0]
If $Result > 0 Then
Local $error = 0, $extended = 0
If $hWnD = Default Then
$Result = DllCall("kernel32.dll", "bool", "SetConsoleIcon", "ptr", DllStructGetData($hIcon, 1))
$Result = DllCall("kernel32.dll", "hwnd", "GetConsoleWindow")
$error = @error
$extended = @extended
If UBound($Result) > 0 Then $hWnD = $Result[0]
EndIf
If IsHWnd($hWnD) Then
_SendMessage($hWnD, $WM_SETICON, 0, DllStructGetData($hIcon, 1))
_SendMessage($hWnD, $WM_SETICON, 1, DllStructGetData($hIcon, 1))
Sleep(50)
EndIf
DllCall("user32.dll", "int", "DestroyIcon", "hwnd", DllStructGetData($hIcon, 1))
If $error Then Return SetError($error, $extended, False)
Return True
EndIf
EndIf
If @error Then Return SetError(@error, @extended, False)
EndFunc
Func _ConsoleWrite($Text)
Local $hFile, $pBuffer, $iToWrite, $iWritten, $tBuffer = DllStructCreate("char[" & StringLen($Text) & "]")
DllStructSetData($tBuffer, 1, $Text)
$hFile = _WinAPI_GetStdHandle(1)
_WinAPI_WriteFile($hFile, $tBuffer, StringLen($Text), $iWritten)
Return $iWritten
EndFunc
Func TimeDebug()
Return "[" & @YEAR & "-" & @MON & "-" & @MDAY & " " & _NowTime(5) & "." & @MSEC & "] "
EndFunc
Func __TimerInit()
Local $iCurrentTimeMSec = _Date_Time_GetTickCount()
Return $iCurrentTimeMSec
EndFunc
Func __TimerDiff($iTimeMsec)
If $iTimeMsec <= 0 Then
SetError(1, 0, 0)
Return
EndIf
Local $iCurrentTimeMSec = _Date_Time_GetTickCount()
If $iCurrentTimeMSec < $iTimeMsec Then
$iTimeMsec = $iTimeMsec - 4294967296
EndIf
Return $iCurrentTimeMSec - $iTimeMsec
EndFunc
If $CmdLine[0] > 0 Then
For $i = 1 To $CmdLine[0]
Switch $CmdLine[$i]
Case "/console", "/c", "-console", "-c"
_WinAPI_AllocConsole()
_WinAPI_SetConsoleIcon($g_sLibIconPath, $eIcnGUI)
Case Else
$g_asCmdLine[0] += 1
ReDim $g_asCmdLine[$g_asCmdLine[0] + 1]
$g_asCmdLine[$g_asCmdLine[0]] = $CmdLine[$i]
EndSwitch
Next
EndIf
DllCall("kernel32.dll", "bool", "SetConsoleTitle", "str", "Console " & $g_sBotTitle)
$hMutex_BotTitle = CreateMutex($sWatchdogMutex)
If $hMutex_BotTitle = 0 Then
SetLog($g_sBotTitle & " is already running")
Exit 2
EndIf
$g_hFrmBot = GUICreate($g_sBotTitle, 32, 32)
$hStarted = __TimerInit()
$hTimeoutAutoClose = $hStarted
Local $iExitCode = 0
Local $iActiveBots = 0
While 1
$iActiveBots = UBound(GetManagedMyBotDetails())
SetDebugLog("Broadcast query bot state, registered bots: " & $iActiveBots)
_WinAPI_BroadcastSystemMessage($WM_MYBOTRUN_API, 0x0100 + $iActiveBots, $g_hFrmBot, $BSF_POSTMESSAGE + $BSF_IGNORECURRENTTASK, $BSM_APPLICATIONS)
Local $hLoopTimer = __TimerInit()
Local $hCheckTimer = __TimerInit()
While __TimerDiff($hLoopTimer) < $iTimeoutBroadcast
_Sleep($DELAYSLEEP)
If __TimerDiff($hCheckTimer) >= $iTimeoutCheckBot Then
CheckManagedMyBot($iTimeoutRestartBot)
$hCheckTimer = __TimerInit()
EndIf
WEnd
$iActiveBots = GetActiveMyBotCount($iTimeoutBroadcast * 2)
SetDebugLog("Active bots: " & $iActiveBots)
If $iTimeoutAutoClose > -1 And __TimerDiff($hTimeoutAutoClose) > $iTimeoutAutoClose Then
If UBound(GetManagedMyBotDetails()) = 0 Then
SetLog("Closing " & $g_sBotTitle & " as no running bot found")
$iExitCode = 1
ExitLoop
EndIf
$hTimeoutAutoClose = __TimerInit()
EndIf
WEnd
ReleaseMutex($hMutex_BotTitle)
DllClose("ntdll.dll")
Exit($iExitCode)
UpdateManagedMyBot(True)
