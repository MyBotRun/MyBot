#NoTrayIcon
#RequireAdmin
#pragma compile(Console, true)
#pragma compile(ProductName, My Bot Wmi)
#pragma compile(Out, MyBot.run.Wmi.exe) ; Required
#pragma compile(Icon, "Images\MyBot.ico")
#pragma compile(FileDescription, Clash of Clans Bot - A Free Clash of Clans bot - https://mybot.run)
#pragma compile(ProductVersion, 7.6)
#pragma compile(FileVersion, 7.6.4)
#pragma compile(LegalCopyright, © https://mybot.run)
#Au3Stripper_Off
#Au3Stripper_On
Opt("MustDeclareVars", 1)
Global Const $tagPOINT = "struct;long X;long Y;endstruct"
Global Const $tagRECT = "struct;long Left;long Top;long Right;long Bottom;endstruct"
Global Const $tagREBARBANDINFO = "uint cbSize;uint fMask;uint fStyle;dword clrFore;dword clrBack;ptr lpText;uint cch;" & "int iImage;hwnd hwndChild;uint cxMinChild;uint cyMinChild;uint cx;handle hbmBack;uint wID;uint cyChild;uint cyMaxChild;" & "uint cyIntegral;uint cxIdeal;lparam lParam;uint cxHeader" &((@OSVersion = "WIN_XP") ? "" : ";" & $tagRECT & ";uint uChevronState")
Global Const $tagGUID = "struct;ulong Data1;ushort Data2;ushort Data3;byte Data4[8];endstruct"
Global Const $tagTEXTMETRIC = "long tmHeight;long tmAscent;long tmDescent;long tmInternalLeading;long tmExternalLeading;" & "long tmAveCharWidth;long tmMaxCharWidth;long tmWeight;long tmOverhang;long tmDigitizedAspectX;long tmDigitizedAspectY;" & "wchar tmFirstChar;wchar tmLastChar;wchar tmDefaultChar;wchar tmBreakChar;byte tmItalic;byte tmUnderlined;byte tmStruckOut;" & "byte tmPitchAndFamily;byte tmCharSet"
Global Const $UBOUND_DIMENSIONS = 0
Global Const $UBOUND_ROWS = 1
Global Const $UBOUND_COLUMNS = 2
Global Const $HGDI_ERROR = Ptr(-1)
Global Const $INVALID_HANDLE_VALUE = Ptr(-1)
Global Const $KF_EXTENDED = 0x0100
Global Const $KF_ALTDOWN = 0x2000
Global Const $KF_UP = 0x8000
Global Const $LLKHF_EXTENDED = BitShift($KF_EXTENDED, 8)
Global Const $LLKHF_ALTDOWN = BitShift($KF_ALTDOWN, 8)
Global Const $LLKHF_UP = BitShift($KF_UP, 8)
Global Const $tagOSVERSIONINFO = 'struct;dword OSVersionInfoSize;dword MajorVersion;dword MinorVersion;dword BuildNumber;dword PlatformId;wchar CSDVersion[128];endstruct'
Global Const $__WINVER = __WINVER()
Func __WINVER()
Local $tOSVI = DllStructCreate($tagOSVERSIONINFO)
DllStructSetData($tOSVI, 1, DllStructGetSize($tOSVI))
Local $aRet = DllCall('kernel32.dll', 'bool', 'GetVersionExW', 'struct*', $tOSVI)
If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
Return BitOR(BitShift(DllStructGetData($tOSVI, 2), -8), DllStructGetData($tOSVI, 3))
EndFunc
Global Const $__DLG_WM_USER = 0x400
Global Const $tagNOTIFYICONDATA = 'struct;dword Size;hwnd hWnd;uint ID;uint Flags;uint CallbackMessage;ptr hIcon;wchar Tip[128];dword State;dword StateMask;wchar Info[256];uint Version;wchar InfoTitle[64];dword InfoFlags;endstruct'
Global $g_sWmiTestApi = ""
Global Const $_ARRAYCONSTANT_SORTINFOSIZE = 11
Global $__g_aArrayDisplay_SortInfo[$_ARRAYCONSTANT_SORTINFOSIZE]
Global Const $_ARRAYCONSTANT_tagLVITEM = "struct;uint Mask;int Item;int SubItem;uint State;uint StateMask;ptr Text;int TextMax;int Image;lparam Param;" & "int Indent;int GroupID;uint Columns;ptr pColumns;ptr piColFmt;int iGroup;endstruct"
#Au3Stripper_Ignore_Funcs=__ArrayDisplay_SortCallBack
Func __ArrayDisplay_SortCallBack($nItem1, $nItem2, $hWnd)
If $__g_aArrayDisplay_SortInfo[3] = $__g_aArrayDisplay_SortInfo[4] Then
If Not $__g_aArrayDisplay_SortInfo[7] Then
$__g_aArrayDisplay_SortInfo[5] *= -1
$__g_aArrayDisplay_SortInfo[7] = 1
EndIf
Else
$__g_aArrayDisplay_SortInfo[7] = 1
EndIf
$__g_aArrayDisplay_SortInfo[6] = $__g_aArrayDisplay_SortInfo[3]
Local $sVal1 = __ArrayDisplay_GetItemText($hWnd, $nItem1, $__g_aArrayDisplay_SortInfo[3])
Local $sVal2 = __ArrayDisplay_GetItemText($hWnd, $nItem2, $__g_aArrayDisplay_SortInfo[3])
If $__g_aArrayDisplay_SortInfo[8] = 1 Then
If(StringIsFloat($sVal1) Or StringIsInt($sVal1)) Then $sVal1 = Number($sVal1)
If(StringIsFloat($sVal2) Or StringIsInt($sVal2)) Then $sVal2 = Number($sVal2)
EndIf
Local $nResult
If $__g_aArrayDisplay_SortInfo[8] < 2 Then
$nResult = 0
If $sVal1 < $sVal2 Then
$nResult = -1
ElseIf $sVal1 > $sVal2 Then
$nResult = 1
EndIf
Else
$nResult = DllCall('shlwapi.dll', 'int', 'StrCmpLogicalW', 'wstr', $sVal1, 'wstr', $sVal2)[0]
EndIf
$nResult = $nResult * $__g_aArrayDisplay_SortInfo[5]
Return $nResult
EndFunc
Func __ArrayDisplay_GetItemText($hWnd, $iIndex, $iSubItem = 0)
Local $tBuffer = DllStructCreate("wchar Text[4096]")
Local $pBuffer = DllStructGetPtr($tBuffer)
Local $tItem = DllStructCreate($_ARRAYCONSTANT_tagLVITEM)
DllStructSetData($tItem, "SubItem", $iSubItem)
DllStructSetData($tItem, "TextMax", 4096)
DllStructSetData($tItem, "Text", $pBuffer)
If IsHWnd($hWnd) Then
DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $hWnd, "uint", 0x1073, "wparam", $iIndex, "struct*", $tItem)
Else
Local $pItem = DllStructGetPtr($tItem)
GUICtrlSendMsg($hWnd, 0x1073, $iIndex, $pItem)
EndIf
Return DllStructGetData($tBuffer, "Text")
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
Global $g_oWMI = 0
Global Static $g_WmiFields = ["Handle", "ExecutablePath", "CommandLine"]
Func GetWmiSelectFields()
Return _ArrayToString($g_WmiFields, ",")
EndFunc
Func GetWmiObject()
If $g_oWMI = 0 Then $g_oWMI = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
If @error Or Not IsObj($g_oWMI) Then Return -1
Return $g_oWMI
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
Global Const $WS_OVERLAPPED = 0
Global Const $WS_MAXIMIZEBOX = 0x00010000
Global Const $WS_MINIMIZEBOX = 0x00020000
Global Const $WS_SIZEBOX = 0x00040000
Global Const $WS_THICKFRAME = $WS_SIZEBOX
Global Const $WS_SYSMENU = 0x00080000
Global Const $WS_CAPTION = 0x00C00000
Local $g_oWMI = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
Local $query
If $CmdLine[0] = 1 Then
$query = $CmdLine[1]
Else
$query = "Select " & GetWmiSelectFields() & " from Win32_Process"
EndIf
Local $oProcessColl = GetWmiObject().ExecQuery($query, "WQL", 0x20 + 0x10)
OutputWmiData("<Processes>")
For $Process In $oProcessColl
OutputWmiData("  <Process>")
For $sField In $g_WmiFields
OutputWmiData("    <" & $sField & ">" & Execute("$Process." & $sField) & "</" & $sField & ">")
Next
OutputWmiData("  </Process>")
Next
OutputWmiData("</Processes>")
If $g_sWmiTestApi <> "" Then
Local $aProcesses = WmiOutputToArray($g_sWmiTestApi)
ConsoleWrite("Found " & UBound($aProcesses) & " processes" & @CRLF)
For $aProcess In $aProcesses
ConsoleWrite("Handle : " & $aProcess[0] & @CRLF)
ConsoleWrite("ExecutablePath : " & $aProcess[1] & @CRLF)
ConsoleWrite("CommandLine : " & $aProcess[2] & @CRLF)
Next
EndIf
If $CmdLine[0] <> 1 Then
ConsoleWrite(@CRLF & "Press enter to exit . . . ")
While Not ConsoleRead(True)
Sleep(10)
WEnd
EndIf
Exit 0
Func OutputWmiData($s)
If $g_sWmiTestApi <> "" Then
$g_sWmiTestApi &= $s & @CRLF
Return
EndIf
ConsoleWrite($s & @CRLF)
EndFunc
