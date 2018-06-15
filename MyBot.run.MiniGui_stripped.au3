#NoTrayIcon
#RequireAdmin
#pragma compile(ProductName, My Bot Mini Gui)
#pragma compile(Out, MyBot.run.MiniGui.exe) ; Required
#pragma compile(Icon, "Images\MyBot.ico")
#pragma compile(FileDescription, Clash of Clans Bot - A Free Clash of Clans bot - https://mybot.run)
#pragma compile(ProductVersion, 7.5.2)
#pragma compile(FileVersion, 7.5.2)
#pragma compile(LegalCopyright, © https://mybot.run)
#Au3Stripper_Off
#Au3Stripper_On
Global $g_sBotVersion = "v7.5.2"
Opt("MustDeclareVars", 1)
Global $g_sBotTitle = ""
Global $g_hFrmBot = 0
Global Const $WAIT_TIMEOUT = 258
Global Const $STDERR_MERGED = 8
Global Const $UBOUND_DIMENSIONS = 0
Global Const $UBOUND_ROWS = 1
Global Const $UBOUND_COLUMNS = 2
Global Const $HWND_TOP = 0
Global Const $SWP_NOSIZE = 0x0001
Global Const $SWP_NOMOVE = 0x0002
Global Const $SWP_NOZORDER = 0x0004
Global Const $SWP_NOACTIVATE = 0x0010
Global Const $SWP_SHOWWINDOW = 0x0040
Global Const $SWP_HIDEWINDOW = 0x0080
Global Const $SWP_NOOWNERZORDER = 0x0200
Global Const $SWP_NOREPOSITION = 0x0200
Global Const $SWP_NOSENDCHANGING = 0x0400
Global Const $MB_APPLMODAL = 0
Global Const $MB_SYSTEMMODAL = 4096
Global Const $MB_TOPMOST = 0x00040000
Global Const $tagPOINT = "struct;long X;long Y;endstruct"
Global Const $tagRECT = "struct;long Left;long Top;long Right;long Bottom;endstruct"
Global Const $tagSIZE = "struct;long X;long Y;endstruct"
Global Const $tagSYSTEMTIME = "struct;word Year;word Month;word Dow;word Day;word Hour;word Minute;word Second;word MSeconds;endstruct"
Global Const $tagGDIPBITMAPDATA = "uint Width;uint Height;int Stride;int Format;ptr Scan0;uint_ptr Reserved"
Global Const $tagGDIPSTARTUPINPUT = "uint Version;ptr Callback;bool NoThread;bool NoCodecs"
Global Const $tagREBARBANDINFO = "uint cbSize;uint fMask;uint fStyle;dword clrFore;dword clrBack;ptr lpText;uint cch;" & "int iImage;hwnd hwndChild;uint cxMinChild;uint cyMinChild;uint cx;handle hbmBack;uint wID;uint cyChild;uint cyMaxChild;" & "uint cyIntegral;uint cxIdeal;lparam lParam;uint cxHeader" &((@OSVersion = "WIN_XP") ? "" : ";" & $tagRECT & ";uint uChevronState")
Global Const $tagBITMAPINFOHEADER = "struct;dword biSize;long biWidth;long biHeight;word biPlanes;word biBitCount;" & "dword biCompression;dword biSizeImage;long biXPelsPerMeter;long biYPelsPerMeter;dword biClrUsed;dword biClrImportant;endstruct"
Global Const $tagGUID = "struct;ulong Data1;ushort Data2;ushort Data3;byte Data4[8];endstruct"
Global Const $tagPROCESS_INFORMATION = "handle hProcess;handle hThread;dword ProcessID;dword ThreadID"
Global Const $tagSTARTUPINFO = "dword Size;ptr Reserved1;ptr Desktop;ptr Title;dword X;dword Y;dword XSize;dword YSize;dword XCountChars;" & "dword YCountChars;dword FillAttribute;dword Flags;word ShowWindow;word Reserved2;ptr Reserved3;handle StdInput;" & "handle StdOutput;handle StdError"
Global Const $tagSECURITY_ATTRIBUTES = "dword Length;ptr Descriptor;bool InheritHandle"
Global Const $tagTEXTMETRIC = "long tmHeight;long tmAscent;long tmDescent;long tmInternalLeading;long tmExternalLeading;" & "long tmAveCharWidth;long tmMaxCharWidth;long tmWeight;long tmOverhang;long tmDigitizedAspectX;long tmDigitizedAspectY;" & "wchar tmFirstChar;wchar tmLastChar;wchar tmDefaultChar;wchar tmBreakChar;byte tmItalic;byte tmUnderlined;byte tmStruckOut;" & "byte tmPitchAndFamily;byte tmCharSet"
Func _WinAPI_GetLastError(Const $_iCurrentError = @error, Const $_iCurrentExtended = @extended)
Local $aResult = DllCall("kernel32.dll", "dword", "GetLastError")
Return SetError($_iCurrentError, $_iCurrentExtended, $aResult[0])
EndFunc
Func _WinAPI_SetLastError($iErrorCode, Const $_iCurrentError = @error, Const $_iCurrentExtended = @extended)
DllCall("kernel32.dll", "none", "SetLastError", "dword", $iErrorCode)
Return SetError($_iCurrentError, $_iCurrentExtended, Null)
EndFunc
Global $__g_vEnum, $__g_vExt = 0
Global $__g_hHeap = 0, $__g_iRGBMode = 1
Global Const $tagOSVERSIONINFO = 'struct;dword OSVersionInfoSize;dword MajorVersion;dword MinorVersion;dword BuildNumber;dword PlatformId;wchar CSDVersion[128];endstruct'
Global Const $__WINVER = __WINVER()
Func _WinAPI_CreateSize($iWidth, $iHeight)
Local $tSIZE = DllStructCreate($tagSIZE)
DllStructSetData($tSIZE, 1, $iWidth)
DllStructSetData($tSIZE, 2, $iHeight)
Return $tSIZE
EndFunc
Func _WinAPI_FatalExit($iCode)
DllCall('kernel32.dll', 'none', 'FatalExit', 'int', $iCode)
If @error Then Return SetError(@error, @extended)
EndFunc
Func _WinAPI_GetBitmapDimension($hBitmap)
Local Const $tagBITMAP = 'struct;long bmType;long bmWidth;long bmHeight;long bmWidthBytes;ushort bmPlanes;ushort bmBitsPixel;ptr bmBits;endstruct'
Local $tObj = DllStructCreate($tagBITMAP)
Local $aRet = DllCall('gdi32.dll', 'int', 'GetObject', 'handle', $hBitmap, 'int', DllStructGetSize($tObj), 'struct*', $tObj)
If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)
Return _WinAPI_CreateSize(DllStructGetData($tObj, 'bmWidth'), DllStructGetData($tObj, 'bmHeight'))
EndFunc
Func _WinAPI_IsBadReadPtr($pAddress, $iLength)
Local $aRet = DllCall('kernel32.dll', 'bool', 'IsBadReadPtr', 'struct*', $pAddress, 'uint_ptr', $iLength)
If @error Then Return SetError(@error, @extended, False)
Return $aRet[0]
EndFunc
Func _WinAPI_IsBadWritePtr($pAddress, $iLength)
Local $aRet = DllCall('kernel32.dll', 'bool', 'IsBadWritePtr', 'struct*', $pAddress, 'uint_ptr', $iLength)
If @error Then Return SetError(@error, @extended, False)
Return $aRet[0]
EndFunc
Func _WinAPI_MoveMemory($pDestination, $pSource, $iLength)
If _WinAPI_IsBadReadPtr($pSource, $iLength) Then Return SetError(10, @extended, 0)
If _WinAPI_IsBadWritePtr($pDestination, $iLength) Then Return SetError(11, @extended, 0)
DllCall('ntdll.dll', 'none', 'RtlMoveMemory', 'struct*', $pDestination, 'struct*', $pSource, 'ulong_ptr', $iLength)
If @error Then Return SetError(@error, @extended, 0)
Return 1
EndFunc
Func _WinAPI_SwitchColor($iColor)
If $iColor = -1 Then Return $iColor
Return BitOR(BitAND($iColor, 0x00FF00), BitShift(BitAND($iColor, 0x0000FF), -16), BitShift(BitAND($iColor, 0xFF0000), 16))
EndFunc
Func _WinAPI_ZeroMemory($pMemory, $iLength)
If _WinAPI_IsBadWritePtr($pMemory, $iLength) Then Return SetError(11, @extended, 0)
DllCall('ntdll.dll', 'none', 'RtlZeroMemory', 'struct*', $pMemory, 'ulong_ptr', $iLength)
If @error Then Return SetError(@error, @extended, 0)
Return 1
EndFunc
Func __CheckErrorArrayBounds(Const ByRef $aData, ByRef $iStart, ByRef $iEnd, $nDim = 1, $iDim = $UBOUND_DIMENSIONS)
If Not IsArray($aData) Then Return SetError(1, 0, 1)
If UBound($aData, $iDim) <> $nDim Then Return SetError(2, 0, 1)
If $iStart < 0 Then $iStart = 0
Local $iUBound = UBound($aData) - 1
If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
If $iStart > $iEnd Then Return SetError(4, 0, 1)
Return 0
EndFunc
Func __FatalExit($iCode, $sText = '')
If $sText Then MsgBox($MB_SYSTEMMODAL, 'AutoIt', $sText)
_WinAPI_FatalExit($iCode)
EndFunc
Func __HeapAlloc($iSize, $bAbort = False)
Local $aRet
If Not $__g_hHeap Then
$aRet = DllCall('kernel32.dll', 'handle', 'HeapCreate', 'dword', 0, 'ulong_ptr', 0, 'ulong_ptr', 0)
If @error Or Not $aRet[0] Then __FatalExit(1, 'Error allocating memory.')
$__g_hHeap = $aRet[0]
EndIf
$aRet = DllCall('kernel32.dll', 'ptr', 'HeapAlloc', 'handle', $__g_hHeap, 'dword', 0x00000008, 'ulong_ptr', $iSize)
If @error Or Not $aRet[0] Then
If $bAbort Then __FatalExit(1, 'Error allocating memory.')
Return SetError(@error + 30, @extended, 0)
EndIf
Return $aRet[0]
EndFunc
Func __HeapReAlloc($pMemory, $iSize, $bAmount = False, $bAbort = False)
Local $aRet, $pRet
If __HeapValidate($pMemory) Then
If $bAmount And(__HeapSize($pMemory) >= $iSize) Then Return SetExtended(1, Ptr($pMemory))
$aRet = DllCall('kernel32.dll', 'ptr', 'HeapReAlloc', 'handle', $__g_hHeap, 'dword', 0x00000008, 'ptr', $pMemory, 'ulong_ptr', $iSize)
If @error Or Not $aRet[0] Then
If $bAbort Then __FatalExit(1, 'Error allocating memory.')
Return SetError(@error + 20, @extended, Ptr($pMemory))
EndIf
$pRet = $aRet[0]
Else
$pRet = __HeapAlloc($iSize, $bAbort)
If @error Then Return SetError(@error, @extended, 0)
EndIf
Return $pRet
EndFunc
Func __HeapSize($pMemory, $bCheck = False)
If $bCheck And(Not __HeapValidate($pMemory)) Then Return SetError(@error, @extended, 0)
Local $aRet = DllCall('kernel32.dll', 'ulong_ptr', 'HeapSize', 'handle', $__g_hHeap, 'dword', 0, 'ptr', $pMemory)
If @error Or($aRet[0] = Ptr(-1)) Then Return SetError(@error + 50, @extended, 0)
Return $aRet[0]
EndFunc
Func __HeapValidate($pMemory)
If(Not $__g_hHeap) Or(Not Ptr($pMemory)) Then Return SetError(9, 0, False)
Local $aRet = DllCall('kernel32.dll', 'int', 'HeapValidate', 'handle', $__g_hHeap, 'dword', 0, 'ptr', $pMemory)
If @error Then Return SetError(@error, @extended, False)
Return $aRet[0]
EndFunc
Func __Inc(ByRef $aData, $iIncrement = 100)
Select
Case UBound($aData, $UBOUND_COLUMNS)
If $iIncrement < 0 Then
ReDim $aData[$aData[0][0] + 1][UBound($aData, $UBOUND_COLUMNS)]
Else
$aData[0][0] += 1
If $aData[0][0] > UBound($aData) - 1 Then
ReDim $aData[$aData[0][0] + $iIncrement][UBound($aData, $UBOUND_COLUMNS)]
EndIf
EndIf
Case UBound($aData, $UBOUND_ROWS)
If $iIncrement < 0 Then
ReDim $aData[$aData[0] + 1]
Else
$aData[0] += 1
If $aData[0] > UBound($aData) - 1 Then
ReDim $aData[$aData[0] + $iIncrement]
EndIf
EndIf
Case Else
Return 0
EndSelect
Return 1
EndFunc
Func __Init($dData)
Local $iLength = BinaryLen($dData)
Local $aRet = DllCall('kernel32.dll', 'ptr', 'VirtualAlloc', 'ptr', 0, 'ulong_ptr', $iLength, 'dword', 0x00001000, 'dword', 0x00000040)
If @error Or Not $aRet[0] Then __FatalExit(1, 'Error allocating memory.')
Local $tData = DllStructCreate('byte[' & $iLength & "]", $aRet[0])
DllStructSetData($tData, 1, $dData)
Return $aRet[0]
EndFunc
Func __RGB($iColor)
If $__g_iRGBMode Then
$iColor = _WinAPI_SwitchColor($iColor)
EndIf
Return $iColor
EndFunc
Func __WINVER()
Local $tOSVI = DllStructCreate($tagOSVERSIONINFO)
DllStructSetData($tOSVI, 1, DllStructGetSize($tOSVI))
Local $aRet = DllCall('kernel32.dll', 'bool', 'GetVersionExW', 'struct*', $tOSVI)
If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
Return BitOR(BitShift(DllStructGetData($tOSVI, 2), -8), DllStructGetData($tOSVI, 3))
EndFunc
Global Const $STR_STRIPLEADING = 1
Global Const $STR_STRIPTRAILING = 2
Global Const $STR_NOCOUNT = 2
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
Global Const $SE_PRIVILEGE_ENABLED = 0x00000002
Global Enum $SECURITYANONYMOUS = 0, $SECURITYIDENTIFICATION, $SECURITYIMPERSONATION, $SECURITYDELEGATION
Global Const $TOKEN_QUERY = 0x00000008
Global Const $TOKEN_ADJUST_PRIVILEGES = 0x00000020
Func _Security__AdjustTokenPrivileges($hToken, $bDisableAll, $tNewState, $iBufferLen, $tPrevState = 0, $pRequired = 0)
Local $aCall = DllCall("advapi32.dll", "bool", "AdjustTokenPrivileges", "handle", $hToken, "bool", $bDisableAll, "struct*", $tNewState, "dword", $iBufferLen, "struct*", $tPrevState, "struct*", $pRequired)
If @error Then Return SetError(@error, @extended, False)
Return Not($aCall[0] = 0)
EndFunc
Func _Security__ImpersonateSelf($iLevel = $SECURITYIMPERSONATION)
Local $aCall = DllCall("advapi32.dll", "bool", "ImpersonateSelf", "int", $iLevel)
If @error Then Return SetError(@error, @extended, False)
Return Not($aCall[0] = 0)
EndFunc
Func _Security__LookupPrivilegeValue($sSystem, $sName)
Local $aCall = DllCall("advapi32.dll", "bool", "LookupPrivilegeValueW", "wstr", $sSystem, "wstr", $sName, "int64*", 0)
If @error Or Not $aCall[0] Then Return SetError(@error, @extended, 0)
Return $aCall[3]
EndFunc
Func _Security__OpenThreadToken($iAccess, $hThread = 0, $bOpenAsSelf = False)
If $hThread = 0 Then
Local $aResult = DllCall("kernel32.dll", "handle", "GetCurrentThread")
If @error Then Return SetError(@error + 10, @extended, 0)
$hThread = $aResult[0]
EndIf
Local $aCall = DllCall("advapi32.dll", "bool", "OpenThreadToken", "handle", $hThread, "dword", $iAccess, "bool", $bOpenAsSelf, "handle*", 0)
If @error Or Not $aCall[0] Then Return SetError(@error, @extended, 0)
Return $aCall[4]
EndFunc
Func _Security__OpenThreadTokenEx($iAccess, $hThread = 0, $bOpenAsSelf = False)
Local $hToken = _Security__OpenThreadToken($iAccess, $hThread, $bOpenAsSelf)
If $hToken = 0 Then
Local Const $ERROR_NO_TOKEN = 1008
If _WinAPI_GetLastError() <> $ERROR_NO_TOKEN Then Return SetError(20, _WinAPI_GetLastError(), 0)
If Not _Security__ImpersonateSelf() Then Return SetError(@error + 10, _WinAPI_GetLastError(), 0)
$hToken = _Security__OpenThreadToken($iAccess, $hThread, $bOpenAsSelf)
If $hToken = 0 Then Return SetError(@error, _WinAPI_GetLastError(), 0)
EndIf
Return $hToken
EndFunc
Func _Security__SetPrivilege($hToken, $sPrivilege, $bEnable)
Local $iLUID = _Security__LookupPrivilegeValue("", $sPrivilege)
If $iLUID = 0 Then Return SetError(@error + 10, @extended, False)
Local Const $tagTOKEN_PRIVILEGES = "dword Count;align 4;int64 LUID;dword Attributes"
Local $tCurrState = DllStructCreate($tagTOKEN_PRIVILEGES)
Local $iCurrState = DllStructGetSize($tCurrState)
Local $tPrevState = DllStructCreate($tagTOKEN_PRIVILEGES)
Local $iPrevState = DllStructGetSize($tPrevState)
Local $tRequired = DllStructCreate("int Data")
DllStructSetData($tCurrState, "Count", 1)
DllStructSetData($tCurrState, "LUID", $iLUID)
If Not _Security__AdjustTokenPrivileges($hToken, False, $tCurrState, $iCurrState, $tPrevState, $tRequired) Then Return SetError(2, @error, False)
DllStructSetData($tPrevState, "Count", 1)
DllStructSetData($tPrevState, "LUID", $iLUID)
Local $iAttributes = DllStructGetData($tPrevState, "Attributes")
If $bEnable Then
$iAttributes = BitOR($iAttributes, $SE_PRIVILEGE_ENABLED)
Else
$iAttributes = BitAND($iAttributes, BitNOT($SE_PRIVILEGE_ENABLED))
EndIf
DllStructSetData($tPrevState, "Attributes", $iAttributes)
If Not _Security__AdjustTokenPrivileges($hToken, False, $tPrevState, $iPrevState, $tCurrState, $tRequired) Then Return SetError(3, @error, False)
Return True
EndFunc
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
Global Const $DI_MASK = 0x0001
Global Const $DI_IMAGE = 0x0002
Global Const $DI_NORMAL = 0x0003
Global Const $DI_COMPAT = 0x0004
Global Const $DI_DEFAULTSIZE = 0x0008
Global Const $DI_NOMIRROR = 0x0010
Global Const $GWL_EXSTYLE = 0xFFFFFFEC
Global Const $IMAGE_ICON = 1
Global Const $LOAD_LIBRARY_AS_DATAFILE = 0x02
Global Const $S_OK = 0x00000000
Global Const $LR_DEFAULTCOLOR = 0x0000
Global $__g_aInProcess_WinAPI[64][2] = [[0, 0]]
Global Const $tagICONINFO = "bool Icon;dword XHotSpot;dword YHotSpot;handle hMask;handle hColor"
Func _WinAPI_BitBlt($hDestDC, $iXDest, $iYDest, $iWidth, $iHeight, $hSrcDC, $iXSrc, $iYSrc, $iROP)
Local $aResult = DllCall("gdi32.dll", "bool", "BitBlt", "handle", $hDestDC, "int", $iXDest, "int", $iYDest, "int", $iWidth, "int", $iHeight, "handle", $hSrcDC, "int", $iXSrc, "int", $iYSrc, "dword", $iROP)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _WinAPI_ClientToScreen($hWnd, ByRef $tPoint)
Local $aRet = DllCall("user32.dll", "bool", "ClientToScreen", "hwnd", $hWnd, "struct*", $tPoint)
If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)
Return $tPoint
EndFunc
Func _WinAPI_CloseHandle($hObject)
Local $aResult = DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hObject)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _WinAPI_CreateCompatibleDC($hDC)
Local $aResult = DllCall("gdi32.dll", "handle", "CreateCompatibleDC", "handle", $hDC)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _WinAPI_CreateWindowEx($iExStyle, $sClass, $sName, $iStyle, $iX, $iY, $iWidth, $iHeight, $hParent, $hMenu = 0, $hInstance = 0, $pParam = 0)
If $hInstance = 0 Then $hInstance = _WinAPI_GetModuleHandle("")
Local $aResult = DllCall("user32.dll", "hwnd", "CreateWindowExW", "dword", $iExStyle, "wstr", $sClass, "wstr", $sName, "dword", $iStyle, "int", $iX, "int", $iY, "int", $iWidth, "int", $iHeight, "hwnd", $hParent, "handle", $hMenu, "handle", $hInstance, "struct*", $pParam)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _WinAPI_DeleteDC($hDC)
Local $aResult = DllCall("gdi32.dll", "bool", "DeleteDC", "handle", $hDC)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _WinAPI_DeleteObject($hObject)
Local $aResult = DllCall("gdi32.dll", "bool", "DeleteObject", "handle", $hObject)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _WinAPI_DestroyIcon($hIcon)
Local $aResult = DllCall("user32.dll", "bool", "DestroyIcon", "handle", $hIcon)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _WinAPI_DrawIconEx($hDC, $iX, $iY, $hIcon, $iWidth = 0, $iHeight = 0, $iStep = 0, $hBrush = 0, $iFlags = 3)
Local $iOptions
Switch $iFlags
Case 1
$iOptions = $DI_MASK
Case 2
$iOptions = $DI_IMAGE
Case 3
$iOptions = $DI_NORMAL
Case 4
$iOptions = $DI_COMPAT
Case 5
$iOptions = $DI_DEFAULTSIZE
Case Else
$iOptions = $DI_NOMIRROR
EndSwitch
Local $aResult = DllCall("user32.dll", "bool", "DrawIconEx", "handle", $hDC, "int", $iX, "int", $iY, "handle", $hIcon, "int", $iWidth, "int", $iHeight, "uint", $iStep, "handle", $hBrush, "uint", $iOptions)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _WinAPI_FreeLibrary($hModule)
Local $aResult = DllCall("kernel32.dll", "bool", "FreeLibrary", "handle", $hModule)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _WinAPI_GetClientHeight($hWnd)
Local $tRECT = _WinAPI_GetClientRect($hWnd)
If @error Then Return SetError(@error, @extended, 0)
Return DllStructGetData($tRECT, "Bottom") - DllStructGetData($tRECT, "Top")
EndFunc
Func _WinAPI_GetClientWidth($hWnd)
Local $tRECT = _WinAPI_GetClientRect($hWnd)
If @error Then Return SetError(@error, @extended, 0)
Return DllStructGetData($tRECT, "Right") - DllStructGetData($tRECT, "Left")
EndFunc
Func _WinAPI_GetClientRect($hWnd)
Local $tRECT = DllStructCreate($tagRECT)
Local $aRet = DllCall("user32.dll", "bool", "GetClientRect", "hwnd", $hWnd, "struct*", $tRECT)
If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)
Return $tRECT
EndFunc
Func _WinAPI_GetDeviceCaps($hDC, $iIndex)
Local $aResult = DllCall("gdi32.dll", "int", "GetDeviceCaps", "handle", $hDC, "int", $iIndex)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _WinAPI_GetModuleHandle($sModuleName)
Local $sModuleNameType = "wstr"
If $sModuleName = "" Then
$sModuleName = 0
$sModuleNameType = "ptr"
EndIf
Local $aResult = DllCall("kernel32.dll", "handle", "GetModuleHandleW", $sModuleNameType, $sModuleName)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _WinAPI_GetObject($hObject, $iSize, $pObject)
Local $aResult = DllCall("gdi32.dll", "int", "GetObjectW", "handle", $hObject, "int", $iSize, "struct*", $pObject)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _WinAPI_GetParent($hWnd)
Local $aResult = DllCall("user32.dll", "hwnd", "GetParent", "hwnd", $hWnd)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _WinAPI_GetStdHandle($iStdHandle)
If $iStdHandle < 0 Or $iStdHandle > 2 Then Return SetError(2, 0, -1)
Local Const $aHandle[3] = [-10, -11, -12]
Local $aResult = DllCall("kernel32.dll", "handle", "GetStdHandle", "dword", $aHandle[$iStdHandle])
If @error Then Return SetError(@error, @extended, -1)
Return $aResult[0]
EndFunc
Func _WinAPI_GetWindowLong($hWnd, $iIndex)
Local $sFuncName = "GetWindowLongW"
If @AutoItX64 Then $sFuncName = "GetWindowLongPtrW"
Local $aResult = DllCall("user32.dll", "long_ptr", $sFuncName, "hwnd", $hWnd, "int", $iIndex)
If @error Or Not $aResult[0] Then Return SetError(@error + 10, @extended, 0)
Return $aResult[0]
EndFunc
Func _WinAPI_GetWindowThreadProcessId($hWnd, ByRef $iPID)
Local $aResult = DllCall("user32.dll", "dword", "GetWindowThreadProcessId", "hwnd", $hWnd, "dword*", 0)
If @error Then Return SetError(@error, @extended, 0)
$iPID = $aResult[2]
Return $aResult[0]
EndFunc
Func _WinAPI_GUIDFromString($sGUID)
Local $tGUID = DllStructCreate($tagGUID)
_WinAPI_GUIDFromStringEx($sGUID, $tGUID)
If @error Then Return SetError(@error + 10, @extended, 0)
Return $tGUID
EndFunc
Func _WinAPI_GUIDFromStringEx($sGUID, $tGUID)
Local $aResult = DllCall("ole32.dll", "long", "CLSIDFromString", "wstr", $sGUID, "struct*", $tGUID)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _WinAPI_HiWord($iLong)
Return BitShift($iLong, 16)
EndFunc
Func _WinAPI_InProcess($hWnd, ByRef $hLastWnd)
If $hWnd = $hLastWnd Then Return True
For $iI = $__g_aInProcess_WinAPI[0][0] To 1 Step -1
If $hWnd = $__g_aInProcess_WinAPI[$iI][0] Then
If $__g_aInProcess_WinAPI[$iI][1] Then
$hLastWnd = $hWnd
Return True
Else
Return False
EndIf
EndIf
Next
Local $iPID
_WinAPI_GetWindowThreadProcessId($hWnd, $iPID)
Local $iCount = $__g_aInProcess_WinAPI[0][0] + 1
If $iCount >= 64 Then $iCount = 1
$__g_aInProcess_WinAPI[0][0] = $iCount
$__g_aInProcess_WinAPI[$iCount][0] = $hWnd
$__g_aInProcess_WinAPI[$iCount][1] =($iPID = @AutoItPID)
Return $__g_aInProcess_WinAPI[$iCount][1]
EndFunc
Func _WinAPI_LoadImage($hInstance, $sImage, $iType, $iXDesired, $iYDesired, $iLoad)
Local $aResult, $sImageType = "int"
If IsString($sImage) Then $sImageType = "wstr"
$aResult = DllCall("user32.dll", "handle", "LoadImageW", "handle", $hInstance, $sImageType, $sImage, "uint", $iType, "int", $iXDesired, "int", $iYDesired, "uint", $iLoad)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _WinAPI_LoadLibraryEx($sFileName, $iFlags = 0)
Local $aResult = DllCall("kernel32.dll", "handle", "LoadLibraryExW", "wstr", $sFileName, "ptr", 0, "dword", $iFlags)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _WinAPI_LoWord($iLong)
Return BitAND($iLong, 0xFFFF)
EndFunc
Func _WinAPI_MakeLong($iLo, $iHi)
Return BitOR(BitShift($iHi, -16), BitAND($iLo, 0xFFFF))
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
Func _WinAPI_SelectObject($hDC, $hGDIObj)
Local $aResult = DllCall("gdi32.dll", "handle", "SelectObject", "handle", $hDC, "handle", $hGDIObj)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _WinAPI_SetFocus($hWnd)
Local $aResult = DllCall("user32.dll", "hwnd", "SetFocus", "hwnd", $hWnd)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _WinAPI_SetHandleInformation($hObject, $iMask, $iFlags)
Local $aResult = DllCall("kernel32.dll", "bool", "SetHandleInformation", "handle", $hObject, "dword", $iMask, "dword", $iFlags)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _WinAPI_SetWindowLong($hWnd, $iIndex, $iValue)
_WinAPI_SetLastError(0)
Local $sFuncName = "SetWindowLongW"
If @AutoItX64 Then $sFuncName = "SetWindowLongPtrW"
Local $aResult = DllCall("user32.dll", "long_ptr", $sFuncName, "hwnd", $hWnd, "int", $iIndex, "long_ptr", $iValue)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _WinAPI_SetWindowPos($hWnd, $hAfter, $iX, $iY, $iCX, $iCY, $iFlags)
Local $aResult = DllCall("user32.dll", "bool", "SetWindowPos", "hwnd", $hWnd, "hwnd", $hAfter, "int", $iX, "int", $iY, "int", $iCX, "int", $iCY, "uint", $iFlags)
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
Func _WinAPI_GetVersion()
Return BitAND(BitShift($__WINVER, 8), 0xFF) & '.' & BitAND($__WINVER, 0xFF)
EndFunc
Func _WinAPI_IsIconic($hWnd)
Local $aRet = DllCall('user32.dll', 'bool', 'IsIconic', 'hwnd', $hWnd)
If @error Then Return SetError(@error, @extended, False)
Return $aRet[0]
EndFunc
Func _WinAPI_SetActiveWindow($hWnd)
Local $aRet = DllCall('user32.dll', 'int', 'SetActiveWindow', 'hwnd', $hWnd)
If @error Then Return SetError(@error, @extended, 0)
Return $aRet[0]
EndFunc
Global Const $FW_BOLD = 700
Global Const $COLOR_BLACK = 0x000000
Global Const $COLOR_MAROON = 0x8B1C62
Global Const $COLOR_MEDGRAY = 0xA0A0A4
Global Const $COLOR_PURPLE = 0x800080
Global Const $COLOR_RED = 0xFF0000
Global Const $COLOR_WHITE = 0xFFFFFF
Global Const $DMW_SHORTNAME = 1
Global Const $DMW_LOCALE_LONGNAME = 2
Global Const $MEM_COMMIT = 0x00001000
Global Const $MEM_RESERVE = 0x00002000
Global Const $PAGE_READWRITE = 0x00000004
Global Const $MEM_RELEASE = 0x00008000
Global Const $PROCESS_VM_OPERATION = 0x00000008
Global Const $PROCESS_VM_READ = 0x00000010
Global Const $PROCESS_VM_WRITE = 0x00000020
Global Const $tagMEMMAP = "handle hProc;ulong_ptr Size;ptr Mem"
Func _MemFree(ByRef $tMemMap)
Local $pMemory = DllStructGetData($tMemMap, "Mem")
Local $hProcess = DllStructGetData($tMemMap, "hProc")
Local $bResult = _MemVirtualFreeEx($hProcess, $pMemory, 0, $MEM_RELEASE)
DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hProcess)
If @error Then Return SetError(@error, @extended, False)
Return $bResult
EndFunc
Func _MemInit($hWnd, $iSize, ByRef $tMemMap)
Local $aResult = DllCall("user32.dll", "dword", "GetWindowThreadProcessId", "hwnd", $hWnd, "dword*", 0)
If @error Then Return SetError(@error + 10, @extended, 0)
Local $iProcessID = $aResult[2]
If $iProcessID = 0 Then Return SetError(1, 0, 0)
Local $iAccess = BitOR($PROCESS_VM_OPERATION, $PROCESS_VM_READ, $PROCESS_VM_WRITE)
Local $hProcess = __Mem_OpenProcess($iAccess, False, $iProcessID, True)
Local $iAlloc = BitOR($MEM_RESERVE, $MEM_COMMIT)
Local $pMemory = _MemVirtualAllocEx($hProcess, 0, $iSize, $iAlloc, $PAGE_READWRITE)
If $pMemory = 0 Then Return SetError(2, 0, 0)
$tMemMap = DllStructCreate($tagMEMMAP)
DllStructSetData($tMemMap, "hProc", $hProcess)
DllStructSetData($tMemMap, "Size", $iSize)
DllStructSetData($tMemMap, "Mem", $pMemory)
Return $pMemory
EndFunc
Func _MemRead(ByRef $tMemMap, $pSrce, $pDest, $iSize)
Local $aResult = DllCall("kernel32.dll", "bool", "ReadProcessMemory", "handle", DllStructGetData($tMemMap, "hProc"), "ptr", $pSrce, "struct*", $pDest, "ulong_ptr", $iSize, "ulong_ptr*", 0)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _MemWrite(ByRef $tMemMap, $pSrce, $pDest = 0, $iSize = 0, $sSrce = "struct*")
If $pDest = 0 Then $pDest = DllStructGetData($tMemMap, "Mem")
If $iSize = 0 Then $iSize = DllStructGetData($tMemMap, "Size")
Local $aResult = DllCall("kernel32.dll", "bool", "WriteProcessMemory", "handle", DllStructGetData($tMemMap, "hProc"), "ptr", $pDest, $sSrce, $pSrce, "ulong_ptr", $iSize, "ulong_ptr*", 0)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _MemVirtualAllocEx($hProcess, $pAddress, $iSize, $iAllocation, $iProtect)
Local $aResult = DllCall("kernel32.dll", "ptr", "VirtualAllocEx", "handle", $hProcess, "ptr", $pAddress, "ulong_ptr", $iSize, "dword", $iAllocation, "dword", $iProtect)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _MemVirtualFreeEx($hProcess, $pAddress, $iSize, $iFreeType)
Local $aResult = DllCall("kernel32.dll", "bool", "VirtualFreeEx", "handle", $hProcess, "ptr", $pAddress, "ulong_ptr", $iSize, "dword", $iFreeType)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func __Mem_OpenProcess($iAccess, $bInherit, $iProcessID, $bDebugPriv = False)
Local $aResult = DllCall("kernel32.dll", "handle", "OpenProcess", "dword", $iAccess, "bool", $bInherit, "dword", $iProcessID)
If @error Then Return SetError(@error + 10, @extended, 0)
If $aResult[0] Then Return $aResult[0]
If Not $bDebugPriv Then Return 0
Local $hToken = _Security__OpenThreadTokenEx(BitOR($TOKEN_ADJUST_PRIVILEGES, $TOKEN_QUERY))
If @error Then Return SetError(@error + 20, @extended, 0)
_Security__SetPrivilege($hToken, "SeDebugPrivilege", True)
Local $iError = @error
Local $iLastError = @extended
Local $iRet = 0
If Not @error Then
$aResult = DllCall("kernel32.dll", "handle", "OpenProcess", "dword", $iAccess, "bool", $bInherit, "dword", $iProcessID)
$iError = @error
$iLastError = @extended
If $aResult[0] Then $iRet = $aResult[0]
_Security__SetPrivilege($hToken, "SeDebugPrivilege", False)
If @error Then
$iError = @error + 30
$iLastError = @extended
EndIf
Else
$iError = @error + 40
EndIf
DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hToken)
Return SetError($iError, $iLastError, $iRet)
EndFunc
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
Func _TicksToTime($iTicks, ByRef $iHours, ByRef $iMins, ByRef $iSecs)
If Number($iTicks) > 0 Then
$iTicks = Int($iTicks / 1000)
$iHours = Int($iTicks / 3600)
$iTicks = Mod($iTicks, 3600)
$iMins = Int($iTicks / 60)
$iSecs = Mod($iTicks, 60)
Return 1
ElseIf Number($iTicks) = 0 Then
$iHours = 0
$iTicks = 0
$iMins = 0
$iSecs = 0
Return 1
Else
Return SetError(1, 0, 0)
EndIf
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
Func _ArrayReverse(ByRef $aArray, $iStart = 0, $iEnd = 0)
If $iStart = Default Then $iStart = 0
If $iEnd = Default Then $iEnd = 0
If Not IsArray($aArray) Then Return SetError(1, 0, 0)
If UBound($aArray, $UBOUND_DIMENSIONS) <> 1 Then Return SetError(3, 0, 0)
If Not UBound($aArray) Then Return SetError(4, 0, 0)
Local $vTmp, $iUBound = UBound($aArray) - 1
If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
If $iStart < 0 Then $iStart = 0
If $iStart > $iEnd Then Return SetError(2, 0, 0)
For $i = $iStart To Int(($iStart + $iEnd - 1) / 2)
$vTmp = $aArray[$i]
$aArray[$i] = $aArray[$iEnd]
$aArray[$iEnd] = $vTmp
$iEnd -= 1
Next
Return 1
EndFunc
Func _ArraySearch(Const ByRef $aArray, $vValue, $iStart = 0, $iEnd = 0, $iCase = 0, $iCompare = 0, $iForward = 1, $iSubItem = -1, $bRow = False)
If $iStart = Default Then $iStart = 0
If $iEnd = Default Then $iEnd = 0
If $iCase = Default Then $iCase = 0
If $iCompare = Default Then $iCompare = 0
If $iForward = Default Then $iForward = 1
If $iSubItem = Default Then $iSubItem = -1
If $bRow = Default Then $bRow = False
If Not IsArray($aArray) Then Return SetError(1, 0, -1)
Local $iDim_1 = UBound($aArray) - 1
If $iDim_1 = -1 Then Return SetError(3, 0, -1)
Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS) - 1
Local $bCompType = False
If $iCompare = 2 Then
$iCompare = 0
$bCompType = True
EndIf
If $bRow Then
If UBound($aArray, $UBOUND_DIMENSIONS) = 1 Then Return SetError(5, 0, -1)
If $iEnd < 1 Or $iEnd > $iDim_2 Then $iEnd = $iDim_2
If $iStart < 0 Then $iStart = 0
If $iStart > $iEnd Then Return SetError(4, 0, -1)
Else
If $iEnd < 1 Or $iEnd > $iDim_1 Then $iEnd = $iDim_1
If $iStart < 0 Then $iStart = 0
If $iStart > $iEnd Then Return SetError(4, 0, -1)
EndIf
Local $iStep = 1
If Not $iForward Then
Local $iTmp = $iStart
$iStart = $iEnd
$iEnd = $iTmp
$iStep = -1
EndIf
Switch UBound($aArray, $UBOUND_DIMENSIONS)
Case 1
If Not $iCompare Then
If Not $iCase Then
For $i = $iStart To $iEnd Step $iStep
If $bCompType And VarGetType($aArray[$i]) <> VarGetType($vValue) Then ContinueLoop
If $aArray[$i] = $vValue Then Return $i
Next
Else
For $i = $iStart To $iEnd Step $iStep
If $bCompType And VarGetType($aArray[$i]) <> VarGetType($vValue) Then ContinueLoop
If $aArray[$i] == $vValue Then Return $i
Next
EndIf
Else
For $i = $iStart To $iEnd Step $iStep
If $iCompare = 3 Then
If StringRegExp($aArray[$i], $vValue) Then Return $i
Else
If StringInStr($aArray[$i], $vValue, $iCase) > 0 Then Return $i
EndIf
Next
EndIf
Case 2
Local $iDim_Sub
If $bRow Then
$iDim_Sub = $iDim_1
If $iSubItem > $iDim_Sub Then $iSubItem = $iDim_Sub
If $iSubItem < 0 Then
$iSubItem = 0
Else
$iDim_Sub = $iSubItem
EndIf
Else
$iDim_Sub = $iDim_2
If $iSubItem > $iDim_Sub Then $iSubItem = $iDim_Sub
If $iSubItem < 0 Then
$iSubItem = 0
Else
$iDim_Sub = $iSubItem
EndIf
EndIf
For $j = $iSubItem To $iDim_Sub
If Not $iCompare Then
If Not $iCase Then
For $i = $iStart To $iEnd Step $iStep
If $bRow Then
If $bCompType And VarGetType($aArray[$j][$j]) <> VarGetType($vValue) Then ContinueLoop
If $aArray[$j][$i] = $vValue Then Return $i
Else
If $bCompType And VarGetType($aArray[$i][$j]) <> VarGetType($vValue) Then ContinueLoop
If $aArray[$i][$j] = $vValue Then Return $i
EndIf
Next
Else
For $i = $iStart To $iEnd Step $iStep
If $bRow Then
If $bCompType And VarGetType($aArray[$j][$i]) <> VarGetType($vValue) Then ContinueLoop
If $aArray[$j][$i] == $vValue Then Return $i
Else
If $bCompType And VarGetType($aArray[$i][$j]) <> VarGetType($vValue) Then ContinueLoop
If $aArray[$i][$j] == $vValue Then Return $i
EndIf
Next
EndIf
Else
For $i = $iStart To $iEnd Step $iStep
If $iCompare = 3 Then
If $bRow Then
If StringRegExp($aArray[$j][$i], $vValue) Then Return $i
Else
If StringRegExp($aArray[$i][$j], $vValue) Then Return $i
EndIf
Else
If $bRow Then
If StringInStr($aArray[$j][$i], $vValue, $iCase) > 0 Then Return $i
Else
If StringInStr($aArray[$i][$j], $vValue, $iCase) > 0 Then Return $i
EndIf
EndIf
Next
EndIf
Next
Case Else
Return SetError(2, 0, -1)
EndSwitch
Return SetError(6, 0, -1)
EndFunc
Func _ArraySort(ByRef $aArray, $iDescending = 0, $iStart = 0, $iEnd = 0, $iSubItem = 0, $iPivot = 0)
If $iDescending = Default Then $iDescending = 0
If $iStart = Default Then $iStart = 0
If $iEnd = Default Then $iEnd = 0
If $iSubItem = Default Then $iSubItem = 0
If $iPivot = Default Then $iPivot = 0
If Not IsArray($aArray) Then Return SetError(1, 0, 0)
Local $iUBound = UBound($aArray) - 1
If $iUBound = -1 Then Return SetError(5, 0, 0)
If $iEnd = Default Then $iEnd = 0
If $iEnd < 1 Or $iEnd > $iUBound Or $iEnd = Default Then $iEnd = $iUBound
If $iStart < 0 Or $iStart = Default Then $iStart = 0
If $iStart > $iEnd Then Return SetError(2, 0, 0)
If $iDescending = Default Then $iDescending = 0
If $iPivot = Default Then $iPivot = 0
If $iSubItem = Default Then $iSubItem = 0
Switch UBound($aArray, $UBOUND_DIMENSIONS)
Case 1
If $iPivot Then
__ArrayDualPivotSort($aArray, $iStart, $iEnd)
Else
__ArrayQuickSort1D($aArray, $iStart, $iEnd)
EndIf
If $iDescending Then _ArrayReverse($aArray, $iStart, $iEnd)
Case 2
If $iPivot Then Return SetError(6, 0, 0)
Local $iSubMax = UBound($aArray, $UBOUND_COLUMNS) - 1
If $iSubItem > $iSubMax Then Return SetError(3, 0, 0)
If $iDescending Then
$iDescending = -1
Else
$iDescending = 1
EndIf
__ArrayQuickSort2D($aArray, $iDescending, $iStart, $iEnd, $iSubItem, $iSubMax)
Case Else
Return SetError(4, 0, 0)
EndSwitch
Return 1
EndFunc
Func __ArrayQuickSort1D(ByRef $aArray, Const ByRef $iStart, Const ByRef $iEnd)
If $iEnd <= $iStart Then Return
Local $vTmp
If($iEnd - $iStart) < 15 Then
Local $vCur
For $i = $iStart + 1 To $iEnd
$vTmp = $aArray[$i]
If IsNumber($vTmp) Then
For $j = $i - 1 To $iStart Step -1
$vCur = $aArray[$j]
If($vTmp >= $vCur And IsNumber($vCur)) Or(Not IsNumber($vCur) And StringCompare($vTmp, $vCur) >= 0) Then ExitLoop
$aArray[$j + 1] = $vCur
Next
Else
For $j = $i - 1 To $iStart Step -1
If(StringCompare($vTmp, $aArray[$j]) >= 0) Then ExitLoop
$aArray[$j + 1] = $aArray[$j]
Next
EndIf
$aArray[$j + 1] = $vTmp
Next
Return
EndIf
Local $L = $iStart, $R = $iEnd, $vPivot = $aArray[Int(($iStart + $iEnd) / 2)], $bNum = IsNumber($vPivot)
Do
If $bNum Then
While($aArray[$L] < $vPivot And IsNumber($aArray[$L])) Or(Not IsNumber($aArray[$L]) And StringCompare($aArray[$L], $vPivot) < 0)
$L += 1
WEnd
While($aArray[$R] > $vPivot And IsNumber($aArray[$R])) Or(Not IsNumber($aArray[$R]) And StringCompare($aArray[$R], $vPivot) > 0)
$R -= 1
WEnd
Else
While(StringCompare($aArray[$L], $vPivot) < 0)
$L += 1
WEnd
While(StringCompare($aArray[$R], $vPivot) > 0)
$R -= 1
WEnd
EndIf
If $L <= $R Then
$vTmp = $aArray[$L]
$aArray[$L] = $aArray[$R]
$aArray[$R] = $vTmp
$L += 1
$R -= 1
EndIf
Until $L > $R
__ArrayQuickSort1D($aArray, $iStart, $R)
__ArrayQuickSort1D($aArray, $L, $iEnd)
EndFunc
Func __ArrayQuickSort2D(ByRef $aArray, Const ByRef $iStep, Const ByRef $iStart, Const ByRef $iEnd, Const ByRef $iSubItem, Const ByRef $iSubMax)
If $iEnd <= $iStart Then Return
Local $vTmp, $L = $iStart, $R = $iEnd, $vPivot = $aArray[Int(($iStart + $iEnd) / 2)][$iSubItem], $bNum = IsNumber($vPivot)
Do
If $bNum Then
While($iStep *($aArray[$L][$iSubItem] - $vPivot) < 0 And IsNumber($aArray[$L][$iSubItem])) Or(Not IsNumber($aArray[$L][$iSubItem]) And $iStep * StringCompare($aArray[$L][$iSubItem], $vPivot) < 0)
$L += 1
WEnd
While($iStep *($aArray[$R][$iSubItem] - $vPivot) > 0 And IsNumber($aArray[$R][$iSubItem])) Or(Not IsNumber($aArray[$R][$iSubItem]) And $iStep * StringCompare($aArray[$R][$iSubItem], $vPivot) > 0)
$R -= 1
WEnd
Else
While($iStep * StringCompare($aArray[$L][$iSubItem], $vPivot) < 0)
$L += 1
WEnd
While($iStep * StringCompare($aArray[$R][$iSubItem], $vPivot) > 0)
$R -= 1
WEnd
EndIf
If $L <= $R Then
For $i = 0 To $iSubMax
$vTmp = $aArray[$L][$i]
$aArray[$L][$i] = $aArray[$R][$i]
$aArray[$R][$i] = $vTmp
Next
$L += 1
$R -= 1
EndIf
Until $L > $R
__ArrayQuickSort2D($aArray, $iStep, $iStart, $R, $iSubItem, $iSubMax)
__ArrayQuickSort2D($aArray, $iStep, $L, $iEnd, $iSubItem, $iSubMax)
EndFunc
Func __ArrayDualPivotSort(ByRef $aArray, $iPivot_Left, $iPivot_Right, $bLeftMost = True)
If $iPivot_Left > $iPivot_Right Then Return
Local $iLength = $iPivot_Right - $iPivot_Left + 1
Local $i, $j, $k, $iAi, $iAk, $iA1, $iA2, $iLast
If $iLength < 45 Then
If $bLeftMost Then
$i = $iPivot_Left
While $i < $iPivot_Right
$j = $i
$iAi = $aArray[$i + 1]
While $iAi < $aArray[$j]
$aArray[$j + 1] = $aArray[$j]
$j -= 1
If $j + 1 = $iPivot_Left Then ExitLoop
WEnd
$aArray[$j + 1] = $iAi
$i += 1
WEnd
Else
While 1
If $iPivot_Left >= $iPivot_Right Then Return 1
$iPivot_Left += 1
If $aArray[$iPivot_Left] < $aArray[$iPivot_Left - 1] Then ExitLoop
WEnd
While 1
$k = $iPivot_Left
$iPivot_Left += 1
If $iPivot_Left > $iPivot_Right Then ExitLoop
$iA1 = $aArray[$k]
$iA2 = $aArray[$iPivot_Left]
If $iA1 < $iA2 Then
$iA2 = $iA1
$iA1 = $aArray[$iPivot_Left]
EndIf
$k -= 1
While $iA1 < $aArray[$k]
$aArray[$k + 2] = $aArray[$k]
$k -= 1
WEnd
$aArray[$k + 2] = $iA1
While $iA2 < $aArray[$k]
$aArray[$k + 1] = $aArray[$k]
$k -= 1
WEnd
$aArray[$k + 1] = $iA2
$iPivot_Left += 1
WEnd
$iLast = $aArray[$iPivot_Right]
$iPivot_Right -= 1
While $iLast < $aArray[$iPivot_Right]
$aArray[$iPivot_Right + 1] = $aArray[$iPivot_Right]
$iPivot_Right -= 1
WEnd
$aArray[$iPivot_Right + 1] = $iLast
EndIf
Return 1
EndIf
Local $iSeventh = BitShift($iLength, 3) + BitShift($iLength, 6) + 1
Local $iE1, $iE2, $iE3, $iE4, $iE5, $t
$iE3 = Ceiling(($iPivot_Left + $iPivot_Right) / 2)
$iE2 = $iE3 - $iSeventh
$iE1 = $iE2 - $iSeventh
$iE4 = $iE3 + $iSeventh
$iE5 = $iE4 + $iSeventh
If $aArray[$iE2] < $aArray[$iE1] Then
$t = $aArray[$iE2]
$aArray[$iE2] = $aArray[$iE1]
$aArray[$iE1] = $t
EndIf
If $aArray[$iE3] < $aArray[$iE2] Then
$t = $aArray[$iE3]
$aArray[$iE3] = $aArray[$iE2]
$aArray[$iE2] = $t
If $t < $aArray[$iE1] Then
$aArray[$iE2] = $aArray[$iE1]
$aArray[$iE1] = $t
EndIf
EndIf
If $aArray[$iE4] < $aArray[$iE3] Then
$t = $aArray[$iE4]
$aArray[$iE4] = $aArray[$iE3]
$aArray[$iE3] = $t
If $t < $aArray[$iE2] Then
$aArray[$iE3] = $aArray[$iE2]
$aArray[$iE2] = $t
If $t < $aArray[$iE1] Then
$aArray[$iE2] = $aArray[$iE1]
$aArray[$iE1] = $t
EndIf
EndIf
EndIf
If $aArray[$iE5] < $aArray[$iE4] Then
$t = $aArray[$iE5]
$aArray[$iE5] = $aArray[$iE4]
$aArray[$iE4] = $t
If $t < $aArray[$iE3] Then
$aArray[$iE4] = $aArray[$iE3]
$aArray[$iE3] = $t
If $t < $aArray[$iE2] Then
$aArray[$iE3] = $aArray[$iE2]
$aArray[$iE2] = $t
If $t < $aArray[$iE1] Then
$aArray[$iE2] = $aArray[$iE1]
$aArray[$iE1] = $t
EndIf
EndIf
EndIf
EndIf
Local $iLess = $iPivot_Left
Local $iGreater = $iPivot_Right
If(($aArray[$iE1] <> $aArray[$iE2]) And($aArray[$iE2] <> $aArray[$iE3]) And($aArray[$iE3] <> $aArray[$iE4]) And($aArray[$iE4] <> $aArray[$iE5])) Then
Local $iPivot_1 = $aArray[$iE2]
Local $iPivot_2 = $aArray[$iE4]
$aArray[$iE2] = $aArray[$iPivot_Left]
$aArray[$iE4] = $aArray[$iPivot_Right]
Do
$iLess += 1
Until $aArray[$iLess] >= $iPivot_1
Do
$iGreater -= 1
Until $aArray[$iGreater] <= $iPivot_2
$k = $iLess
While $k <= $iGreater
$iAk = $aArray[$k]
If $iAk < $iPivot_1 Then
$aArray[$k] = $aArray[$iLess]
$aArray[$iLess] = $iAk
$iLess += 1
ElseIf $iAk > $iPivot_2 Then
While $aArray[$iGreater] > $iPivot_2
$iGreater -= 1
If $iGreater + 1 = $k Then ExitLoop 2
WEnd
If $aArray[$iGreater] < $iPivot_1 Then
$aArray[$k] = $aArray[$iLess]
$aArray[$iLess] = $aArray[$iGreater]
$iLess += 1
Else
$aArray[$k] = $aArray[$iGreater]
EndIf
$aArray[$iGreater] = $iAk
$iGreater -= 1
EndIf
$k += 1
WEnd
$aArray[$iPivot_Left] = $aArray[$iLess - 1]
$aArray[$iLess - 1] = $iPivot_1
$aArray[$iPivot_Right] = $aArray[$iGreater + 1]
$aArray[$iGreater + 1] = $iPivot_2
__ArrayDualPivotSort($aArray, $iPivot_Left, $iLess - 2, True)
__ArrayDualPivotSort($aArray, $iGreater + 2, $iPivot_Right, False)
If($iLess < $iE1) And($iE5 < $iGreater) Then
While $aArray[$iLess] = $iPivot_1
$iLess += 1
WEnd
While $aArray[$iGreater] = $iPivot_2
$iGreater -= 1
WEnd
$k = $iLess
While $k <= $iGreater
$iAk = $aArray[$k]
If $iAk = $iPivot_1 Then
$aArray[$k] = $aArray[$iLess]
$aArray[$iLess] = $iAk
$iLess += 1
ElseIf $iAk = $iPivot_2 Then
While $aArray[$iGreater] = $iPivot_2
$iGreater -= 1
If $iGreater + 1 = $k Then ExitLoop 2
WEnd
If $aArray[$iGreater] = $iPivot_1 Then
$aArray[$k] = $aArray[$iLess]
$aArray[$iLess] = $iPivot_1
$iLess += 1
Else
$aArray[$k] = $aArray[$iGreater]
EndIf
$aArray[$iGreater] = $iAk
$iGreater -= 1
EndIf
$k += 1
WEnd
EndIf
__ArrayDualPivotSort($aArray, $iLess, $iGreater, False)
Else
Local $iPivot = $aArray[$iE3]
$k = $iLess
While $k <= $iGreater
If $aArray[$k] = $iPivot Then
$k += 1
ContinueLoop
EndIf
$iAk = $aArray[$k]
If $iAk < $iPivot Then
$aArray[$k] = $aArray[$iLess]
$aArray[$iLess] = $iAk
$iLess += 1
Else
While $aArray[$iGreater] > $iPivot
$iGreater -= 1
WEnd
If $aArray[$iGreater] < $iPivot Then
$aArray[$k] = $aArray[$iLess]
$aArray[$iLess] = $aArray[$iGreater]
$iLess += 1
Else
$aArray[$k] = $iPivot
EndIf
$aArray[$iGreater] = $iAk
$iGreater -= 1
EndIf
$k += 1
WEnd
__ArrayDualPivotSort($aArray, $iPivot_Left, $iLess - 1, True)
__ArrayDualPivotSort($aArray, $iGreater + 1, $iPivot_Right, False)
EndIf
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
Global Const $WS_OVERLAPPED = 0
Global Const $WS_MAXIMIZEBOX = 0x00010000
Global Const $WS_MINIMIZEBOX = 0x00020000
Global Const $WS_TABSTOP = 0x00010000
Global Const $WS_SIZEBOX = 0x00040000
Global Const $WS_THICKFRAME = $WS_SIZEBOX
Global Const $WS_SYSMENU = 0x00080000
Global Const $WS_BORDER = 0x00800000
Global Const $WS_CAPTION = 0x00C00000
Global Const $WS_CLIPCHILDREN = 0x02000000
Global Const $WS_CLIPSIBLINGS = 0x04000000
Global Const $WS_CHILD = 0x40000000
Global Const $WS_POPUP = 0x80000000
Global Const $WS_EX_LAYERED = 0x00080000
Global Const $WS_EX_NOACTIVATE = 0x08000000
Global Const $WS_EX_TOOLWINDOW = 0x00000080
Global Const $WM_MOVE = 0x0003
Global Const $WM_CLOSE = 0x0010
Global Const $WM_SETICON = 0x0080
Global Const $WM_COMMAND = 0x0111
Global Const $WM_SYSCOMMAND = 0x0112
Global Const $STARTF_USESHOWWINDOW = 0x1
Global Const $STARTF_USESTDHANDLES = 0x100
Global Const $SS_LEFT = 0x0
Global Const $SS_CENTER = 0x1
Global Const $SS_RIGHT = 0x2
Global Const $STM_SETIMAGE = 0x0172
Global Const $GUI_EVENT_CLOSE = -3
Global Const $GUI_EVENT_MINIMIZE = -4
Global Const $GUI_EVENT_RESTORE = -5
Global Const $GUI_RUNDEFMSG = 'GUI_RUNDEFMSG'
Global Const $GUI_CHECKED = 1
Global Const $GUI_UNCHECKED = 4
Global Const $GUI_SHOW = 16
Global Const $GUI_HIDE = 32
Global Const $GUI_ENABLE = 64
Global Const $GUI_DISABLE = 128
Global Const $GUI_DOCKALL = 0x0322
Global Const $GDIP_ILMREAD = 0x0001
Global Const $GDIP_PXF32RGB = 0x00022009
Global Const $GDIP_PXF32ARGB = 0x0026200A
Global Const $GDIP_INTERPOLATIONMODE_HIGHQUALITYBICUBIC = 7
Global Const $tagBITMAP = 'struct;long bmType;long bmWidth;long bmHeight;long bmWidthBytes;ushort bmPlanes;ushort bmBitsPixel;ptr bmBits;endstruct'
Global Const $tagBITMAPV5HEADER = 'struct;dword bV5Size;long bV5Width;long bV5Height;ushort bV5Planes;ushort bV5BitCount;dword bV5Compression;dword bV5SizeImage;long bV5XPelsPerMeter;long bV5YPelsPerMeter;dword bV5ClrUsed;dword bV5ClrImportant;dword bV5RedMask;dword bV5GreenMask;dword bV5BlueMask;dword bV5AlphaMask;dword bV5CSType;int bV5Endpoints[9];dword bV5GammaRed;dword bV5GammaGreen;dword bV5GammaBlue;dword bV5Intent;dword bV5ProfileData;dword bV5ProfileSize;dword bV5Reserved;endstruct'
Global Const $tagDIBSECTION = $tagBITMAP & ';' & $tagBITMAPINFOHEADER & ';dword dsBitfields[3];ptr dshSection;dword dsOffset'
Func _WinAPI_CopyBitmap($hBitmap)
$hBitmap = _WinAPI_CopyImage($hBitmap, 0, 0, 0, 0x2000)
Return SetError(@error, @extended, $hBitmap)
EndFunc
Func _WinAPI_CopyImage($hImage, $iType = 0, $iXDesiredPixels = 0, $iYDesiredPixels = 0, $iFlags = 0)
Local $aRet = DllCall('user32.dll', 'handle', 'CopyImage', 'handle', $hImage, 'uint', $iType, 'int', $iXDesiredPixels, 'int', $iYDesiredPixels, 'uint', $iFlags)
If @error Then Return SetError(@error, @extended, 0)
Return $aRet[0]
EndFunc
Func _WinAPI_Create32BitHBITMAP($hIcon, $bDib = False, $bDelete = False)
Local $hBitmap = 0
Local $aDIB[2] = [0, 0]
Local $hTemp = _WinAPI_Create32BitHICON($hIcon)
If @error Then Return SetError(@error, @extended, 0)
Local $iError = 0
Do
Local $tICONINFO = DllStructCreate($tagICONINFO)
Local $aRet = DllCall('user32.dll', 'bool', 'GetIconInfo', 'handle', $hTemp, 'struct*', $tICONINFO)
If @error Or Not $aRet[0] Then
$iError = @error + 10
ExitLoop
EndIf
For $i = 0 To 1
$aDIB[$i] = DllStructGetData($tICONINFO, $i + 4)
Next
Local $tBITMAP = DllStructCreate($tagBITMAP)
If Not _WinAPI_GetObject($aDIB[0], DllStructGetSize($tBITMAP), $tBITMAP) Then
$iError = @error + 20
ExitLoop
EndIf
If $bDib Then
$hBitmap = _WinAPI_CreateDIB(DllStructGetData($tBITMAP, 'bmWidth'), DllStructGetData($tBITMAP, 'bmHeight'))
Local $hDC = _WinAPI_CreateCompatibleDC(0)
Local $hSv = _WinAPI_SelectObject($hDC, $hBitmap)
_WinAPI_DrawIconEx($hDC, 0, 0, $hTemp)
_WinAPI_SelectObject($hDC, $hSv)
_WinAPI_DeleteDC($hDC)
Else
$hBitmap = $aDIB[1]
$aDIB[1] = 0
EndIf
Until 1
For $i = 0 To 1
If $aDIB[$i] Then
_WinAPI_DeleteObject($aDIB[$i])
EndIf
Next
_WinAPI_DestroyIcon($hTemp)
If $iError Then Return SetError($iError, 0, 0)
If Not $hBitmap Then Return SetError(12, 0, 0)
If $bDelete Then
_WinAPI_DestroyIcon($hIcon)
EndIf
Return $hBitmap
EndFunc
Func _WinAPI_Create32BitHICON($hIcon, $bDelete = False)
Local $ahBitmap[2], $hResult = 0
Local $aDIB[2][2] = [[0, 0], [0, 0]]
Local $tICONINFO = DllStructCreate($tagICONINFO)
Local $aRet = DllCall('user32.dll', 'bool', 'GetIconInfo', 'handle', $hIcon, 'struct*', $tICONINFO)
If @error Then Return SetError(@error, @extended, 0)
If Not $aRet[0] Then Return SetError(10, 0, 0)
For $i = 0 To 1
$ahBitmap[$i] = DllStructGetData($tICONINFO, $i + 4)
Next
If _WinAPI_IsAlphaBitmap($ahBitmap[1]) Then
$aDIB[0][0] = _WinAPI_CreateANDBitmap($ahBitmap[1])
If Not @error Then
$hResult = _WinAPI_CreateIconIndirect($ahBitmap[1], $aDIB[0][0])
EndIf
Else
Local $tSIZE = _WinAPI_GetBitmapDimension($ahBitmap[1])
Local $aSize[2]
For $i = 0 To 1
$aSize[$i] = DllStructGetData($tSIZE, $i + 1)
Next
Local $hSrcDC = _WinAPI_CreateCompatibleDC(0)
Local $hDstDC = _WinAPI_CreateCompatibleDC(0)
Local $hSrcSv, $hDstSv
For $i = 0 To 1
$aDIB[$i][0] = _WinAPI_CreateDIB($aSize[0], $aSize[1])
$aDIB[$i][1] = $__g_vExt
$hSrcSv = _WinAPI_SelectObject($hSrcDC, $ahBitmap[$i])
$hDstSv = _WinAPI_SelectObject($hDstDC, $aDIB[$i][0])
_WinAPI_BitBlt($hDstDC, 0, 0, $aSize[0], $aSize[1], $hSrcDC, 0, 0, 0x00C000CA)
_WinAPI_SelectObject($hSrcDC, $hSrcSv)
_WinAPI_SelectObject($hDstDC, $hDstSv)
Next
_WinAPI_DeleteDC($hSrcDC)
_WinAPI_DeleteDC($hDstDC)
$aRet = DllCall('user32.dll', 'lresult', 'CallWindowProc', 'ptr', __XORProc(), 'ptr', 0, 'uint', $aSize[0] * $aSize[1] * 4, 'wparam', $aDIB[0][1], 'lparam', $aDIB[1][1])
If Not @error And $aRet[0] Then
$hResult = _WinAPI_CreateIconIndirect($aDIB[1][0], $ahBitmap[0])
EndIf
EndIf
For $i = 0 To 1
_WinAPI_DeleteObject($ahBitmap[$i])
If $aDIB[$i][0] Then
_WinAPI_DeleteObject($aDIB[$i][0])
EndIf
Next
If Not $hResult Then Return SetError(11, 0, 0)
If $bDelete Then
_WinAPI_DestroyIcon($hIcon)
EndIf
Return $hResult
EndFunc
Func _WinAPI_CreateANDBitmap($hBitmap)
Local $iError = 0, $hDib = 0
$hBitmap = _WinAPI_CopyBitmap($hBitmap)
If Not $hBitmap Then Return SetError(@error + 20, @extended, 0)
Do
Local $atDIB[2]
$atDIB[0] = DllStructCreate($tagDIBSECTION)
If(Not _WinAPI_GetObject($hBitmap, DllStructGetSize($atDIB[0]), $atDIB[0])) Or(DllStructGetData($atDIB[0], 'bmBitsPixel') <> 32) Or(DllStructGetData($atDIB[0], 'biCompression')) Then
$iError = 10
ExitLoop
EndIf
$atDIB[1] = DllStructCreate($tagBITMAP)
$hDib = _WinAPI_CreateDIB(DllStructGetData($atDIB[0], 'bmWidth'), DllStructGetData($atDIB[0], 'bmHeight'), 1)
If Not _WinAPI_GetObject($hDib, DllStructGetSize($atDIB[1]), $atDIB[1]) Then
$iError = 11
ExitLoop
EndIf
Local $aRet = DllCall('user32.dll', 'lresult', 'CallWindowProc', 'ptr', __ANDProc(), 'ptr', 0, 'uint', 0, 'wparam', DllStructGetPtr($atDIB[0]), 'lparam', DllStructGetPtr($atDIB[1]))
If @error Then
$iError = @error
ExitLoop
EndIf
If Not $aRet[0] Then
$iError = 12
ExitLoop
EndIf
$iError = 0
Until 1
_WinAPI_DeleteObject($hBitmap)
If $iError Then
If $hDib Then
_WinAPI_DeleteObject($hDib)
EndIf
$hDib = 0
EndIf
Return SetError($iError, 0, $hDib)
EndFunc
Func _WinAPI_CreateDIB($iWidth, $iHeight, $iBitsPerPel = 32, $tColorTable = 0, $iColorCount = 0)
Local $aRGBQ[2], $iColors, $tagRGBQ
Switch $iBitsPerPel
Case 1
$iColors = 2
Case 4
$iColors = 16
Case 8
$iColors = 256
Case Else
$iColors = 0
EndSwitch
If $iColors Then
If Not IsDllStruct($tColorTable) Then
Switch $iBitsPerPel
Case 1
$aRGBQ[0] = 0
$aRGBQ[1] = 0xFFFFFF
$tColorTable = _WinAPI_CreateDIBColorTable($aRGBQ)
Case Else
EndSwitch
Else
If $iColors > $iColorCount Then
$iColors = $iColorCount
EndIf
If(Not $iColors) Or((4 * $iColors) > DllStructGetSize($tColorTable)) Then
Return SetError(20, 0, 0)
EndIf
EndIf
$tagRGBQ = ';dword aRGBQuad[' & $iColors & ']'
Else
$tagRGBQ = ''
EndIf
Local $tBITMAPINFO = DllStructCreate($tagBITMAPINFOHEADER & $tagRGBQ)
DllStructSetData($tBITMAPINFO, 'biSize', 40)
DllStructSetData($tBITMAPINFO, 'biWidth', $iWidth)
DllStructSetData($tBITMAPINFO, 'biHeight', $iHeight)
DllStructSetData($tBITMAPINFO, 'biPlanes', 1)
DllStructSetData($tBITMAPINFO, 'biBitCount', $iBitsPerPel)
DllStructSetData($tBITMAPINFO, 'biCompression', 0)
DllStructSetData($tBITMAPINFO, 'biSizeImage', 0)
DllStructSetData($tBITMAPINFO, 'biXPelsPerMeter', 0)
DllStructSetData($tBITMAPINFO, 'biYPelsPerMeter', 0)
DllStructSetData($tBITMAPINFO, 'biClrUsed', $iColors)
DllStructSetData($tBITMAPINFO, 'biClrImportant', 0)
If $iColors Then
If IsDllStruct($tColorTable) Then
_WinAPI_MoveMemory(DllStructGetPtr($tBITMAPINFO, 'aRGBQuad'), $tColorTable, 4 * $iColors)
Else
_WinAPI_ZeroMemory(DllStructGetPtr($tBITMAPINFO, 'aRGBQuad'), 4 * $iColors)
EndIf
EndIf
Local $hBitmap = _WinAPI_CreateDIBSection(0, $tBITMAPINFO, 0, $__g_vExt)
If Not $hBitmap Then Return SetError(@error, @extended, 0)
Return $hBitmap
EndFunc
Func _WinAPI_CreateDIBColorTable(Const ByRef $aColorTable, $iStart = 0, $iEnd = -1)
If __CheckErrorArrayBounds($aColorTable, $iStart, $iEnd) Then Return SetError(@error + 10, @extended, 0)
Local $tColorTable = DllStructCreate('dword[' &($iEnd - $iStart + 1) & ']')
Local $iCount = 1
For $i = $iStart To $iEnd
DllStructSetData($tColorTable, 1, _WinAPI_SwitchColor(__RGB($aColorTable[$i])), $iCount)
$iCount += 1
Next
Return $tColorTable
EndFunc
Func _WinAPI_CreateDIBSection($hDC, $tBITMAPINFO, $iUsage, ByRef $pBits, $hSection = 0, $iOffset = 0)
$pBits = 0
Local $aRet = DllCall('gdi32.dll', 'handle', 'CreateDIBSection', 'handle', $hDC, 'struct*', $tBITMAPINFO, 'uint', $iUsage, 'ptr*', 0, 'handle', $hSection, 'dword', $iOffset)
If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
$pBits = $aRet[4]
Return $aRet[0]
EndFunc
Func _WinAPI_CreateIconIndirect($hBitmap, $hMask, $iXHotspot = 0, $iYHotspot = 0, $bIcon = True)
Local $tICONINFO = DllStructCreate($tagICONINFO)
DllStructSetData($tICONINFO, 1, $bIcon)
DllStructSetData($tICONINFO, 2, $iXHotspot)
DllStructSetData($tICONINFO, 3, $iYHotspot)
DllStructSetData($tICONINFO, 4, $hMask)
DllStructSetData($tICONINFO, 5, $hBitmap)
Local $aRet = DllCall('user32.dll', 'handle', 'CreateIconIndirect', 'struct*', $tICONINFO)
If @error Then Return SetError(@error, @extended, 0)
Return $aRet[0]
EndFunc
Func _WinAPI_IsAlphaBitmap($hBitmap)
$hBitmap = _WinAPI_CopyBitmap($hBitmap)
If Not $hBitmap Then Return SetError(@error + 20, @extended, 0)
Local $aRet, $iError = 0
Do
Local $tDIB = DllStructCreate($tagDIBSECTION)
If(Not _WinAPI_GetObject($hBitmap, DllStructGetSize($tDIB), $tDIB)) Or(DllStructGetData($tDIB, 'bmBitsPixel') <> 32) Or(DllStructGetData($tDIB, 'biCompression')) Then
$iError = 1
ExitLoop
EndIf
$aRet = DllCall('user32.dll', 'int', 'CallWindowProc', 'ptr', __AlphaProc(), 'ptr', 0, 'uint', 0, 'struct*', $tDIB, 'ptr', 0)
If @error Or($aRet[0] = -1) Then
$iError = @error + 10
ExitLoop
EndIf
Until 1
_WinAPI_DeleteObject($hBitmap)
If $iError Then Return SetError($iError, 0, 0)
Return $aRet[0]
EndFunc
Func __AlphaProc()
Static $pProc = 0
If Not $pProc Then
If @AutoItX64 Then
$pProc = __Init(Binary( '0x48894C240848895424104C894424184C894C24205541574831C050504883EC28' & '48837C24600074054831C0EB0748C7C0010000004821C0751F488B6C24604883' & '7D180074054831C0EB0748C7C0010000004821C07502EB0948C7C001000000EB' & '034831C04821C0740C48C7C0FFFFFFFF4863C0EB6F48C744242800000000488B' & '6C24604C637D04488B6C2460486345084C0FAFF849C1E7024983C7FC4C3B7C24' & '287C36488B6C24604C8B7D184C037C24284983C7034C897C2430488B6C243080' & '7D0000740C48C7C0010000004863C0EB1348834424280471A54831C04863C0EB' & '034831C04883C438415F5DC3'))
Else
$pProc = __Init(Binary( '0x555331C05050837C241C00740431C0EB05B80100000021C075198B6C241C837D' & '1400740431C0EB05B80100000021C07502EB07B801000000EB0231C021C07407' & 'B8FFFFFFFFEB4FC70424000000008B6C241C8B5D048B6C241C0FAF5D08C1E302' & '83C3FC3B1C247C288B6C241C8B5D14031C2483C303895C24048B6C2404807D00' & '007407B801000000EB0C8304240471BE31C0EB0231C083C4085B5DC21000'))
EndIf
EndIf
Return $pProc
EndFunc
Func __ANDProc()
Static $pProc = 0
If Not $pProc Then
If @AutoItX64 Then
$pProc = __Init(Binary( '0x48894C240848895424104C894424184C894C2420554157415648C7C009000000' & '4883EC0848C704240000000048FFC875EF4883EC284883BC24A0000000007405' & '4831C0EB0748C7C0010000004821C00F85840000004883BC24A8000000007405' & '4831C0EB0748C7C0010000004821C07555488BAC24A000000048837D18007405' & '4831C0EB0748C7C0010000004821C07522488BAC24A800000048837D18007405' & '4831C0EB0748C7C0010000004821C07502EB0948C7C001000000EB034831C048' & '21C07502EB0948C7C001000000EB034831C04821C07502EB0948C7C001000000' & 'EB034831C04821C0740B4831C04863C0E9D701000048C74424280000000048C7' & '44243000000000488BAC24A00000004C637D0849FFCF4C3B7C24300F8C9C0100' & '0048C74424380000000048C74424400000000048C744244800000000488BAC24' & 'A00000004C637D0449FFCF4C3B7C24480F8CDB000000488BAC24A00000004C8B' & '7D184C037C24284983C7034C897C2450488B6C2450807D000074264C8B7C2440' & '4C8B74243849F7DE4983C61F4C89F148C7C00100000048D3E04909C74C897C24' & '4048FF4424384C8B7C24384983FF1F7E6F4C8B7C244049F7D74C897C244048C7' & '442458180000004831C0483B4424587F3D488BAC24A80000004C8B7D184C037C' & '24604C897C24504C8B7C2440488B4C245849D3FF4C89F850488B6C2458588845' & '0048FF4424604883442458F871B948C74424380000000048C744244000000000' & '48834424280448FF4424480F810BFFFFFF48837C24380074794C8B7C244049F7' & 'D74C8B74243849F7DE4983C6204C89F148C7C0FFFFFFFF48D3E04921C74C897C' & '244048C7442458180000004831C0483B4424587F3D488BAC24A80000004C8B7D' & '184C037C24604C897C24504C8B7C2440488B4C245849D3FF4C89F850488B6C24' & '585888450048FF4424604883442458F871B948FF4424300F814AFEFFFF48C7C0' & '010000004863C0EB034831C04883C470415E415F5DC3'))
Else
$pProc = __Init(Binary( '0x555357BA0800000083EC04C70424000000004A75F3837C243800740431C0EB05' & 'B80100000021C07562837C243C00740431C0EB05B80100000021C0753F8B6C24' & '38837D1400740431C0EB05B80100000021C075198B6C243C837D1400740431C0' & 'EB05B80100000021C07502EB07B801000000EB0231C021C07502EB07B8010000' & '00EB0231C021C07502EB07B801000000EB0231C021C0740731C0E969010000C7' & '042400000000C7442404000000008B6C24388B5D084B3B5C24040F8C3F010000' & 'C744240800000000C744240C00000000C7442410000000008B6C24388B5D044B' & '3B5C24100F8CA90000008B6C24388B5D14031C2483C303895C24148B6C241480' & '7D0000741C8B5C240C8B7C2408F7DF83C71F89F9B801000000D3E009C3895C24' & '0CFF4424088B5C240883FB1F7E578B5C240CF7D3895C240CC744241818000000' & '31C03B4424187F2D8B6C243C8B5D14035C241C895C24148B5C240C8B4C2418D3' & 'FB538B6C241858884500FF44241C83442418F871CBC744240800000000C74424' & '0C0000000083042404FF4424100F8145FFFFFF837C240800745B8B5C240CF7D3' & '8B7C2408F7DF83C72089F9B8FFFFFFFFD3E021C3895C240CC744241818000000' & '31C03B4424187F2D8B6C243C8B5D14035C241C895C24148B5C240C8B4C2418D3' & 'FB538B6C241858884500FF44241C83442418F871CBFF4424040F81AFFEFFFFB8' & '01000000EB0231C083C4205F5B5DC21000'))
EndIf
EndIf
Return $pProc
EndFunc
Func __XORProc()
Static $pProc = 0
If Not $pProc Then
If @AutoItX64 Then
$pProc = __Init(Binary( '0x48894C240848895424104C894424184C894C24205541574831C050504883EC28' & '48837C24600074054831C0EB0748C7C0010000004821C0751B48837C24680074' & '054831C0EB0748C7C0010000004821C07502EB0948C7C001000000EB034831C0' & '4821C074084831C04863C0EB7748C7442428000000004C637C24584983C7FC4C' & '3B7C24287C4F4C8B7C24604C037C24284C897C2430488B6C2430807D00007405' & '4831C0EB0748C7C0010000004821C0741C4C8B7C24684C037C24284983C7034C' & '897C2430488B6C2430C64500FF48834424280471A148C7C0010000004863C0EB' & '034831C04883C438415F5DC3'))
Else
$pProc = __Init(Binary( '0x555331C05050837C241C00740431C0EB05B80100000021C07516837C24200074' & '0431C0EB05B80100000021C07502EB07B801000000EB0231C021C0740431C0EB' & '5AC70424000000008B5C241883C3FC3B1C247C3E8B5C241C031C24895C24048B' & '6C2404807D0000740431C0EB05B80100000021C074168B5C2420031C2483C303' & '895C24048B6C2404C64500FF8304240471B6B801000000EB0231C083C4085B5D' & 'C21000'))
EndIf
EndIf
Return $pProc
EndFunc
Global $__g_hGDIPDll = 0
Global $__g_iGDIPRef = 0
Global $__g_iGDIPToken = 0
Global $__g_bGDIP_V1_0 = True
Func _GDIPlus_BitmapCreateDIBFromBitmap($hBitmap)
Local $aRet = DllCall($__g_hGDIPDll, "uint", "GdipGetImageDimension", "handle", $hBitmap, "float*", 0, "float*", 0)
If @error Or $aRet[0] Then Return SetError(@error + 10, $aRet[0], 0)
Local $tData = _GDIPlus_BitmapLockBits($hBitmap, 0, 0, $aRet[2], $aRet[3], $GDIP_ILMREAD, $GDIP_PXF32ARGB)
Local $pBits = DllStructGetData($tData, "Scan0")
If Not $pBits Then Return 0
Local $tBIHDR = DllStructCreate($tagBITMAPV5HEADER)
DllStructSetData($tBIHDR, "bV5Size", DllStructGetSize($tBIHDR))
DllStructSetData($tBIHDR, "bV5Width", $aRet[2])
DllStructSetData($tBIHDR, "bV5Height", $aRet[3])
DllStructSetData($tBIHDR, "bV5Planes", 1)
DllStructSetData($tBIHDR, "bV5BitCount", 32)
DllStructSetData($tBIHDR, "bV5Compression", 0)
DllStructSetData($tBIHDR, "bV5SizeImage", $aRet[3] * DllStructGetData($tData, "Stride"))
DllStructSetData($tBIHDR, "bV5AlphaMask", 0xFF000000)
DllStructSetData($tBIHDR, "bV5RedMask", 0x00FF0000)
DllStructSetData($tBIHDR, "bV5GreenMask", 0x0000FF00)
DllStructSetData($tBIHDR, "bV5BlueMask", 0x000000FF)
DllStructSetData($tBIHDR, "bV5CSType", 2)
DllStructSetData($tBIHDR, "bV5Intent", 4)
Local $hHBitmapv5 = DllCall("gdi32.dll", "ptr", "CreateDIBSection", "hwnd", 0, "struct*", $tBIHDR, "uint", 0, "ptr*", 0, "ptr", 0, "dword", 0)
If Not @error And $hHBitmapv5[0] Then
DllCall("gdi32.dll", "dword", "SetBitmapBits", "ptr", $hHBitmapv5[0], "dword", $aRet[2] * $aRet[3] * 4, "ptr", DllStructGetData($tData, "Scan0"))
$hHBitmapv5 = $hHBitmapv5[0]
Else
$hHBitmapv5 = 0
EndIf
_GDIPlus_BitmapUnlockBits($hBitmap, $tData)
$tData = 0
$tBIHDR = 0
Return $hHBitmapv5
EndFunc
Func _GDIPlus_BitmapCreateFromFile($sFileName)
Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateBitmapFromFile", "wstr", $sFileName, "handle*", 0)
If @error Then Return SetError(@error, @extended, 0)
If $aResult[0] Then Return SetError(10, $aResult[0], 0)
Return $aResult[2]
EndFunc
Func _GDIPlus_BitmapCreateFromScan0($iWidth, $iHeight, $iPixelFormat = $GDIP_PXF32ARGB, $iStride = 0, $pScan0 = 0)
Local $aResult = DllCall($__g_hGDIPDll, "uint", "GdipCreateBitmapFromScan0", "int", $iWidth, "int", $iHeight, "int", $iStride, "int", $iPixelFormat, "struct*", $pScan0, "handle*", 0)
If @error Then Return SetError(@error, @extended, 0)
If $aResult[0] Then Return SetError(10, $aResult[0], 0)
Return $aResult[6]
EndFunc
Func _GDIPlus_BitmapDispose($hBitmap)
Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDisposeImage", "handle", $hBitmap)
If @error Then Return SetError(@error, @extended, False)
If $aResult[0] Then Return SetError(10, $aResult[0], False)
Return True
EndFunc
Func _GDIPlus_BitmapLockBits($hBitmap, $iLeft, $iTop, $iWidth, $iHeight, $iFlags = $GDIP_ILMREAD, $iFormat = $GDIP_PXF32RGB)
Local $tData = DllStructCreate($tagGDIPBITMAPDATA)
Local $tRECT = DllStructCreate($tagRECT)
DllStructSetData($tRECT, "Left", $iLeft)
DllStructSetData($tRECT, "Top", $iTop)
DllStructSetData($tRECT, "Right", $iWidth)
DllStructSetData($tRECT, "Bottom", $iHeight)
Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipBitmapLockBits", "handle", $hBitmap, "struct*", $tRECT, "uint", $iFlags, "int", $iFormat, "struct*", $tData)
If @error Then Return SetError(@error, @extended, 0)
If $aResult[0] Then Return SetError(10, $aResult[0], 0)
Return $tData
EndFunc
Func _GDIPlus_BitmapUnlockBits($hBitmap, $tBitmapData)
Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipBitmapUnlockBits", "handle", $hBitmap, "struct*", $tBitmapData)
If @error Then Return SetError(@error, @extended, False)
If $aResult[0] Then Return SetError(10, $aResult[0], False)
Return True
EndFunc
Func _GDIPlus_GraphicsDispose($hGraphics)
Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDeleteGraphics", "handle", $hGraphics)
If @error Then Return SetError(@error, @extended, False)
If $aResult[0] Then Return SetError(10, $aResult[0], False)
Return True
EndFunc
Func _GDIPlus_GraphicsDrawImageRect($hGraphics, $hImage, $nX, $nY, $nW, $nH)
Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDrawImageRect", "handle", $hGraphics, "handle", $hImage, "float", $nX, "float", $nY, "float", $nW, "float", $nH)
If @error Then Return SetError(@error, @extended, False)
If $aResult[0] Then Return SetError(10, $aResult[0], False)
Return True
EndFunc
Func _GDIPlus_GraphicsSetInterpolationMode($hGraphics, $iInterpolationMode)
Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetInterpolationMode", "handle", $hGraphics, "int", $iInterpolationMode)
If @error Then Return SetError(@error, @extended, False)
If $aResult[0] Then Return SetError(10, $aResult[0], False)
Return True
EndFunc
Func _GDIPlus_ImageGetGraphicsContext($hImage)
Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetImageGraphicsContext", "handle", $hImage, "handle*", 0)
If @error Then Return SetError(@error, @extended, 0)
If $aResult[0] Then Return SetError(10, $aResult[0], 0)
Return $aResult[2]
EndFunc
Func _GDIPlus_ImageGetHeight($hImage)
Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetImageHeight", "handle", $hImage, "uint*", 0)
If @error Then Return SetError(@error, @extended, -1)
If $aResult[0] Then Return SetError(10, $aResult[0], -1)
Return $aResult[2]
EndFunc
Func _GDIPlus_ImageGetWidth($hImage)
Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetImageWidth", "handle", $hImage, "uint*", -1)
If @error Then Return SetError(@error, @extended, -1)
If $aResult[0] Then Return SetError(10, $aResult[0], -1)
Return $aResult[2]
EndFunc
Func _GDIPlus_Shutdown()
If $__g_hGDIPDll = 0 Then Return SetError(-1, -1, False)
$__g_iGDIPRef -= 1
If $__g_iGDIPRef = 0 Then
DllCall($__g_hGDIPDll, "none", "GdiplusShutdown", "ulong_ptr", $__g_iGDIPToken)
DllClose($__g_hGDIPDll)
$__g_hGDIPDll = 0
EndIf
Return True
EndFunc
Func _GDIPlus_Startup($sGDIPDLL = Default, $bRetDllHandle = False)
$__g_iGDIPRef += 1
If $__g_iGDIPRef > 1 Then Return True
If $sGDIPDLL = Default Then $sGDIPDLL = "gdiplus.dll"
$__g_hGDIPDll = DllOpen($sGDIPDLL)
If $__g_hGDIPDll = -1 Then
$__g_iGDIPRef = 0
Return SetError(1, 2, False)
EndIf
Local $sVer = FileGetVersion($sGDIPDLL)
$sVer = StringSplit($sVer, ".")
If $sVer[1] > 5 Then $__g_bGDIP_V1_0 = False
Local $tInput = DllStructCreate($tagGDIPSTARTUPINPUT)
Local $tToken = DllStructCreate("ulong_ptr Data")
DllStructSetData($tInput, "Version", 1)
Local $aResult = DllCall($__g_hGDIPDll, "int", "GdiplusStartup", "struct*", $tToken, "struct*", $tInput, "ptr", 0)
If @error Then Return SetError(@error, @extended, False)
If $aResult[0] Then Return SetError(10, $aResult[0], False)
$__g_iGDIPToken = DllStructGetData($tToken, "Data")
If $bRetDllHandle Then Return $__g_hGDIPDll
Return SetExtended($sVer[1], True)
EndFunc
Global Const $TTF_IDISHWND = 0x00000001
Global Const $TTF_SUBCLASS = 0x00000010
Global Const $__TOOLTIPCONSTANTS_WM_USER = 0X400
Global Const $TTM_SETMAXTIPWIDTH = $__TOOLTIPCONSTANTS_WM_USER + 24
Global Const $TTM_ADDTOOLW = $__TOOLTIPCONSTANTS_WM_USER + 50
Global Const $TTM_GETTEXTW = $__TOOLTIPCONSTANTS_WM_USER + 56
Global Const $TTS_ALWAYSTIP = 0x00000001
Global Const $TTS_NOPREFIX = 0x00000002
Global $__g_hTTLastWnd
Global Const $_TOOLTIPCONSTANTS_ClassName = "tooltips_class32"
Global Const $_TT_ghTTDefaultStyle = BitOR($TTS_ALWAYSTIP, $TTS_NOPREFIX)
Global Const $tagTOOLINFO = "uint Size;uint Flags;hwnd hWnd;uint_ptr ID;" & $tagRECT & ";handle hInst;ptr Text;lparam Param;ptr Reserved"
Func _GUIToolTip_AddTool($hTool, $hWnd, $sText, $iID = 0, $iLeft = 0, $iTop = 0, $iRight = 0, $iBottom = 0, $iFlags = Default, $iParam = 0)
Local $iBuffer, $tBuffer, $pBuffer
If $iFlags = Default Then $iFlags = BitOR($TTF_SUBCLASS, $TTF_IDISHWND)
If $sText <> -1 Then
$iBuffer = StringLen($sText) + 1
$tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
$iBuffer *= 2
$pBuffer = DllStructGetPtr($tBuffer)
DllStructSetData($tBuffer, "Text", $sText)
Else
$iBuffer = 0
$pBuffer = -1
EndIf
Local $tToolInfo = DllStructCreate($tagTOOLINFO)
Local $iToolInfo = DllStructGetSize($tToolInfo)
DllStructSetData($tToolInfo, "Size", $iToolInfo)
DllStructSetData($tToolInfo, "Flags", $iFlags)
DllStructSetData($tToolInfo, "hWnd", $hWnd)
DllStructSetData($tToolInfo, "ID", $iID)
DllStructSetData($tToolInfo, "Left", $iLeft)
DllStructSetData($tToolInfo, "Top", $iTop)
DllStructSetData($tToolInfo, "Right", $iRight)
DllStructSetData($tToolInfo, "Bottom", $iBottom)
DllStructSetData($tToolInfo, "Param", $iParam)
Local $iRet
If _WinAPI_InProcess($hTool, $__g_hTTLastWnd) Then
DllStructSetData($tToolInfo, "Text", $pBuffer)
$iRet = _SendMessage($hTool, $TTM_ADDTOOLW, 0, $tToolInfo, 0, "wparam", "struct*")
Else
Local $tMemMap
Local $pMemory = _MemInit($hTool, $iToolInfo + $iBuffer, $tMemMap)
If $sText <> -1 Then
Local $pText = $pMemory + $iToolInfo
DllStructSetData($tToolInfo, "Text", $pText)
_MemWrite($tMemMap, $tBuffer, $pText, $iBuffer)
Else
DllStructSetData($tToolInfo, "Text", -1)
EndIf
_MemWrite($tMemMap, $tToolInfo, $pMemory, $iToolInfo)
$iRet = _SendMessage($hTool, $TTM_ADDTOOLW, 0, $pMemory, 0, "wparam", "ptr")
_MemFree($tMemMap)
EndIf
Return $iRet <> 0
EndFunc
Func _GUIToolTip_Create($hWnd, $iStyle = $_TT_ghTTDefaultStyle)
Return _WinAPI_CreateWindowEx(0, $_TOOLTIPCONSTANTS_ClassName, "", $iStyle, 0, 0, 0, 0, $hWnd)
EndFunc
Func _GUIToolTip_GetText($hWnd, $hTool, $iID)
Local $tBuffer = DllStructCreate("wchar Text[4096]")
Local $tToolInfo = DllStructCreate($tagTOOLINFO)
Local $iToolInfo = DllStructGetSize($tToolInfo)
DllStructSetData($tToolInfo, "Size", $iToolInfo)
DllStructSetData($tToolInfo, "hWnd", $hTool)
DllStructSetData($tToolInfo, "ID", $iID)
If _WinAPI_InProcess($hWnd, $__g_hTTLastWnd) Then
DllStructSetData($tToolInfo, "Text", DllStructGetPtr($tBuffer))
_SendMessage($hWnd, $TTM_GETTEXTW, 0, $tToolInfo, 0, "wparam", "struct*")
Else
Local $tMemMap
Local $pMemory = _MemInit($hWnd, $iToolInfo + 4096, $tMemMap)
Local $pText = $pMemory + $iToolInfo
DllStructSetData($tToolInfo, "Text", $pText)
_MemWrite($tMemMap, $tToolInfo, $pMemory, $iToolInfo)
_SendMessage($hWnd, $TTM_GETTEXTW, 0, $pMemory, 0, "wparam", "ptr")
_MemRead($tMemMap, $pText, $tBuffer, 81)
_MemFree($tMemMap)
EndIf
Return DllStructGetData($tBuffer, "Text")
EndFunc
Func _GUIToolTip_SetMaxTipWidth($hWnd, $iWidth)
Return _SendMessage($hWnd, $TTM_SETMAXTIPWIDTH, 0, $iWidth)
EndFunc
Opt("GUIResizeMode", $GUI_DOCKALL)
Opt("GUIEventOptions", 1)
Opt("GUICloseOnESC", 0)
Opt("WinTitleMatchMode", 3)
Opt("GUIOnEventMode", 1)
Opt("MouseClickDelay", 10)
Opt("MouseClickDownDelay", 10)
Global $hNtDll = DllOpen("ntdll.dll")
Global $g_iGlobalActiveBotsAllowed = 0
Global $g_hMutextOrSemaphoreGlobalActiveBots = 0
Global $g_hStatusBar = 0
Global $hMutex_BotTitle = 0
Global $bCloseWhenAllBotsUnregistered = True
Global $iTimeoutBroadcast = 30000
Global $g_iMainLoopSleep = 50
Global $g_sBotTitle = "My Bot Mini " & $g_sBotVersion & " "
Global $g_hFrmBot = 0
Global $g_hFrmBotBackend = 0
Global $g_bBotLaunched = False
Global $g_iBotBackendFindTimeout = 3000
Global $hStruct_SleepMicro = DllStructCreate("int64 time;")
Global $pStruct_SleepMicro = DllStructGetPtr($hStruct_SleepMicro)
Global $DELAYSLEEP = 10
Global $g_iDebugSetlog = 0
Global $g_hFrmBotEmbeddedMouse = 0
Global Const $BS_MULTILINE = 0x2000
Global Const $_UDF_GlobalIDs_OFFSET = 2
Global Const $_UDF_GlobalID_MAX_WIN = 16
Global Const $_UDF_STARTID = 10000
Global Const $_UDF_GlobalID_MAX_IDS = 55535
Global Const $__UDFGUICONSTANT_WS_VISIBLE = 0x10000000
Global Const $__UDFGUICONSTANT_WS_CHILD = 0x40000000
Global $__g_aUDF_GlobalIDs_Used[$_UDF_GlobalID_MAX_WIN][$_UDF_GlobalID_MAX_IDS + $_UDF_GlobalIDs_OFFSET + 1]
Func __UDF_GetNextGlobalID($hWnd)
Local $nCtrlID, $iUsedIndex = -1, $bAllUsed = True
If Not WinExists($hWnd) Then Return SetError(-1, -1, 0)
For $iIndex = 0 To $_UDF_GlobalID_MAX_WIN - 1
If $__g_aUDF_GlobalIDs_Used[$iIndex][0] <> 0 Then
If Not WinExists($__g_aUDF_GlobalIDs_Used[$iIndex][0]) Then
For $x = 0 To UBound($__g_aUDF_GlobalIDs_Used, $UBOUND_COLUMNS) - 1
$__g_aUDF_GlobalIDs_Used[$iIndex][$x] = 0
Next
$__g_aUDF_GlobalIDs_Used[$iIndex][1] = $_UDF_STARTID
$bAllUsed = False
EndIf
EndIf
Next
For $iIndex = 0 To $_UDF_GlobalID_MAX_WIN - 1
If $__g_aUDF_GlobalIDs_Used[$iIndex][0] = $hWnd Then
$iUsedIndex = $iIndex
ExitLoop
EndIf
Next
If $iUsedIndex = -1 Then
For $iIndex = 0 To $_UDF_GlobalID_MAX_WIN - 1
If $__g_aUDF_GlobalIDs_Used[$iIndex][0] = 0 Then
$__g_aUDF_GlobalIDs_Used[$iIndex][0] = $hWnd
$__g_aUDF_GlobalIDs_Used[$iIndex][1] = $_UDF_STARTID
$bAllUsed = False
$iUsedIndex = $iIndex
ExitLoop
EndIf
Next
EndIf
If $iUsedIndex = -1 And $bAllUsed Then Return SetError(16, 0, 0)
If $__g_aUDF_GlobalIDs_Used[$iUsedIndex][1] = $_UDF_STARTID + $_UDF_GlobalID_MAX_IDS Then
For $iIDIndex = $_UDF_GlobalIDs_OFFSET To UBound($__g_aUDF_GlobalIDs_Used, $UBOUND_COLUMNS) - 1
If $__g_aUDF_GlobalIDs_Used[$iUsedIndex][$iIDIndex] = 0 Then
$nCtrlID =($iIDIndex - $_UDF_GlobalIDs_OFFSET) + 10000
$__g_aUDF_GlobalIDs_Used[$iUsedIndex][$iIDIndex] = $nCtrlID
Return $nCtrlID
EndIf
Next
Return SetError(-1, $_UDF_GlobalID_MAX_IDS, 0)
EndIf
$nCtrlID = $__g_aUDF_GlobalIDs_Used[$iUsedIndex][1]
$__g_aUDF_GlobalIDs_Used[$iUsedIndex][1] += 1
$__g_aUDF_GlobalIDs_Used[$iUsedIndex][($nCtrlID - 10000) + $_UDF_GlobalIDs_OFFSET] = $nCtrlID
Return $nCtrlID
EndFunc
Global Const $__STATUSBARCONSTANT_WM_USER = 0X400
Global Const $SB_GETUNICODEFORMAT = 0x2000 + 6
Global Const $SB_ISSIMPLE =($__STATUSBARCONSTANT_WM_USER + 14)
Global Const $SB_SETPARTS =($__STATUSBARCONSTANT_WM_USER + 4)
Global Const $SB_SETTEXTA =($__STATUSBARCONSTANT_WM_USER + 1)
Global Const $SB_SETTEXTW =($__STATUSBARCONSTANT_WM_USER + 11)
Global Const $SB_SETTEXT = $SB_SETTEXTA
Global Const $SB_SIMPLE =($__STATUSBARCONSTANT_WM_USER + 9)
Global Const $SB_SIMPLEID = 0xff
Global $__g_hSBLastWnd
Global Const $__STATUSBARCONSTANT_ClassName = "msctls_statusbar32"
Global Const $__STATUSBARCONSTANT_WM_SIZE = 0x05
Func _GUICtrlStatusBar_Create($hWnd, $vPartEdge = -1, $vPartText = "", $iStyles = -1, $iExStyles = 0x00000000)
If Not IsHWnd($hWnd) Then Return SetError(1, 0, 0)
Local $iStyle = BitOR($__UDFGUICONSTANT_WS_CHILD, $__UDFGUICONSTANT_WS_VISIBLE)
If $iStyles = -1 Then $iStyles = 0x00000000
If $iExStyles = -1 Then $iExStyles = 0x00000000
Local $aPartWidth[1], $aPartText[1]
If @NumParams > 1 Then
If IsArray($vPartEdge) Then
$aPartWidth = $vPartEdge
Else
$aPartWidth[0] = $vPartEdge
EndIf
If @NumParams = 2 Then
ReDim $aPartText[UBound($aPartWidth)]
Else
If IsArray($vPartText) Then
$aPartText = $vPartText
Else
$aPartText[0] = $vPartText
EndIf
If UBound($aPartWidth) <> UBound($aPartText) Then
Local $iLast
If UBound($aPartWidth) > UBound($aPartText) Then
$iLast = UBound($aPartText)
ReDim $aPartText[UBound($aPartWidth)]
Else
$iLast = UBound($aPartWidth)
ReDim $aPartWidth[UBound($aPartText)]
For $x = $iLast To UBound($aPartWidth) - 1
$aPartWidth[$x] = $aPartWidth[$x - 1] + 75
Next
$aPartWidth[UBound($aPartText) - 1] = -1
EndIf
EndIf
EndIf
If Not IsHWnd($hWnd) Then $hWnd = HWnd($hWnd)
If @NumParams > 3 Then $iStyle = BitOR($iStyle, $iStyles)
EndIf
Local $nCtrlID = __UDF_GetNextGlobalID($hWnd)
If @error Then Return SetError(@error, @extended, 0)
Local $hWndSBar = _WinAPI_CreateWindowEx($iExStyles, $__STATUSBARCONSTANT_ClassName, "", $iStyle, 0, 0, 0, 0, $hWnd, $nCtrlID)
If @error Then Return SetError(@error, @extended, 0)
If @NumParams > 1 Then
_GUICtrlStatusBar_SetParts($hWndSBar, UBound($aPartWidth), $aPartWidth)
For $x = 0 To UBound($aPartText) - 1
_GUICtrlStatusBar_SetText($hWndSBar, $aPartText[$x], $x)
Next
EndIf
Return $hWndSBar
EndFunc
Func _GUICtrlStatusBar_GetUnicodeFormat($hWnd)
Return _SendMessage($hWnd, $SB_GETUNICODEFORMAT) <> 0
EndFunc
Func _GUICtrlStatusBar_IsSimple($hWnd)
Return _SendMessage($hWnd, $SB_ISSIMPLE) <> 0
EndFunc
Func _GUICtrlStatusBar_Resize($hWnd)
_SendMessage($hWnd, $__STATUSBARCONSTANT_WM_SIZE)
EndFunc
Func _GUICtrlStatusBar_SetParts($hWnd, $aParts = -1, $aPartWidth = 25)
Local $tParts, $iParts = 1
If IsArray($aParts) <> 0 Then
$aParts[UBound($aParts) - 1] = -1
$iParts = UBound($aParts)
$tParts = DllStructCreate("int[" & $iParts & "]")
For $x = 0 To $iParts - 2
DllStructSetData($tParts, 1, $aParts[$x], $x + 1)
Next
DllStructSetData($tParts, 1, -1, $iParts)
ElseIf IsArray($aPartWidth) <> 0 Then
$iParts = UBound($aPartWidth)
$tParts = DllStructCreate("int[" & $iParts & "]")
For $x = 0 To $iParts - 2
DllStructSetData($tParts, 1, $aPartWidth[$x], $x + 1)
Next
DllStructSetData($tParts, 1, -1, $iParts)
ElseIf $aParts > 1 Then
$iParts = $aParts
$tParts = DllStructCreate("int[" & $iParts & "]")
For $x = 1 To $iParts - 1
DllStructSetData($tParts, 1, $aPartWidth * $x, $x)
Next
DllStructSetData($tParts, 1, -1, $iParts)
Else
$tParts = DllStructCreate("int")
DllStructSetData($tParts, $iParts, -1)
EndIf
If _WinAPI_InProcess($hWnd, $__g_hSBLastWnd) Then
_SendMessage($hWnd, $SB_SETPARTS, $iParts, $tParts, 0, "wparam", "struct*")
Else
Local $iSize = DllStructGetSize($tParts)
Local $tMemMap
Local $pMemory = _MemInit($hWnd, $iSize, $tMemMap)
_MemWrite($tMemMap, $tParts)
_SendMessage($hWnd, $SB_SETPARTS, $iParts, $pMemory, 0, "wparam", "ptr")
_MemFree($tMemMap)
EndIf
_GUICtrlStatusBar_Resize($hWnd)
Return True
EndFunc
Func _GUICtrlStatusBar_SetSimple($hWnd, $bSimple = True)
_SendMessage($hWnd, $SB_SIMPLE, $bSimple)
EndFunc
Func _GUICtrlStatusBar_SetText($hWnd, $sText = "", $iPart = 0, $iUFlag = 0)
Local $bUnicode = _GUICtrlStatusBar_GetUnicodeFormat($hWnd)
Local $iBuffer = StringLen($sText) + 1
Local $tText
If $bUnicode Then
$tText = DllStructCreate("wchar Text[" & $iBuffer & "]")
$iBuffer *= 2
Else
$tText = DllStructCreate("char Text[" & $iBuffer & "]")
EndIf
DllStructSetData($tText, "Text", $sText)
If _GUICtrlStatusBar_IsSimple($hWnd) Then $iPart = $SB_SIMPLEID
Local $iRet
If _WinAPI_InProcess($hWnd, $__g_hSBLastWnd) Then
$iRet = _SendMessage($hWnd, $SB_SETTEXTW, BitOR($iPart, $iUFlag), $tText, 0, "wparam", "struct*")
Else
Local $tMemMap
Local $pMemory = _MemInit($hWnd, $iBuffer, $tMemMap)
_MemWrite($tMemMap, $tText)
If $bUnicode Then
$iRet = _SendMessage($hWnd, $SB_SETTEXTW, BitOR($iPart, $iUFlag), $pMemory, 0, "wparam", "ptr")
Else
$iRet = _SendMessage($hWnd, $SB_SETTEXT, BitOR($iPart, $iUFlag), $pMemory, 0, "wparam", "ptr")
EndIf
_MemFree($tMemMap)
EndIf
Return $iRet <> 0
EndFunc
Global Const $TCCM_FIRST = 0X2000
Func _WinAPI_GetFileVersionInfo($sFilePath, ByRef $pBuffer, $iFlags = 0)
Local $aRet
If $__WINVER >= 0x0600 Then
$aRet = DllCall('version.dll', 'dword', 'GetFileVersionInfoSizeExW', 'dword', BitAND($iFlags, 0x03), 'wstr', $sFilePath, 'ptr', 0)
Else
$aRet = DllCall('version.dll', 'dword', 'GetFileVersionInfoSizeW', 'wstr', $sFilePath, 'ptr', 0)
EndIf
If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
$pBuffer = __HeapReAlloc($pBuffer, $aRet[0], 1)
If @error Then Return SetError(@error + 100, @extended, 0)
Local $iNbByte = $aRet[0]
If $__WINVER >= 0x0600 Then
$aRet = DllCall('version.dll', 'bool', 'GetFileVersionInfoExW', 'dword', BitAND($iFlags, 0x07), 'wstr', $sFilePath, 'dword', 0, 'dword', $iNbByte, 'ptr', $pBuffer)
Else
$aRet = DllCall('version.dll', 'bool', 'GetFileVersionInfoW', 'wstr', $sFilePath, 'dword', 0, 'dword', $iNbByte, 'ptr', $pBuffer)
EndIf
If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)
Return $iNbByte
EndFunc
Func _WinAPI_VerQueryValue($pData, $sValues = '')
$sValues = StringRegExpReplace($sValues, '\A[\s\|]*|[\s\|]*\Z', '')
If Not $sValues Then
$sValues = 'Comments|CompanyName|FileDescription|FileVersion|InternalName|LegalCopyright|LegalTrademarks|OriginalFilename|ProductName|ProductVersion|PrivateBuild|SpecialBuild'
EndIf
$sValues = StringSplit($sValues, '|', $STR_NOCOUNT)
Local $aRet = DllCall('version.dll', 'bool', 'VerQueryValueW', 'ptr', $pData, 'wstr', '\VarFileInfo\Translation', 'ptr*', 0, 'uint*', 0)
If @error Or Not $aRet[0] Or Not $aRet[4] Then Return SetError(@error + 10, 0, 0)
Local $iLength = Floor($aRet[4] / 4)
Local $tLang = DllStructCreate('dword[' & $iLength & ']', $aRet[3])
If @error Then Return SetError(@error + 20, 0, 0)
Local $sCP, $aInfo[101][UBound($sValues) + 1] = [[0]]
For $i = 1 To $iLength
__Inc($aInfo)
$aInfo[$aInfo[0][0]][0] = _WinAPI_LoWord(DllStructGetData($tLang, 1, $i))
$sCP = Hex(_WinAPI_MakeLong(_WinAPI_HiWord(DllStructGetData($tLang, 1, $i)), _WinAPI_LoWord(DllStructGetData($tLang, 1, $i))), 8)
For $j = 0 To UBound($sValues) - 1
$aRet = DllCall('version.dll', 'bool', 'VerQueryValueW', 'ptr', $pData, 'wstr', '\StringFileInfo\' & $sCP & '\' & $sValues[$j], 'ptr*', 0, 'uint*', 0)
If Not @error And $aRet[0] And $aRet[4] Then
$aInfo[$aInfo[0][0]][$j + 1] = DllStructGetData(DllStructCreate('wchar[' & $aRet[4] & ']', $aRet[3]), 1)
Else
$aInfo[$aInfo[0][0]][$j + 1] = ''
EndIf
Next
Next
__Inc($aInfo, -1)
Return $aInfo
EndFunc
Global Const $TRAY_CHECKED = 1
Global Const $TRAY_UNCHECKED = 4
Global Const $TRAY_ENABLE = 64
Global Const $TRAY_DISABLE = 128
Global Const $CFE_SUBSCRIPT = 0x00010000
Global Const $CFE_SUPERSCRIPT = 0x00020000
Global $__g_pGRC_StreamFromFileCallback = DllCallbackRegister("__GCR_StreamFromFileCallback", "dword", "long_ptr;ptr;long;ptr")
Global $__g_pGRC_StreamFromVarCallback = DllCallbackRegister("__GCR_StreamFromVarCallback", "dword", "long_ptr;ptr;long;ptr")
Global $__g_pGRC_StreamToFileCallback = DllCallbackRegister("__GCR_StreamToFileCallback", "dword", "long_ptr;ptr;long;ptr")
Global $__g_pGRC_StreamToVarCallback = DllCallbackRegister("__GCR_StreamToVarCallback", "dword", "long_ptr;ptr;long;ptr")
Global $__g_pGRC_sStreamVar
Global $__g_hLib_RichCom_OLE32 = DllOpen("OLE32.DLL")
Global $__g_pRichCom_Object_QueryInterface = DllCallbackRegister("__RichCom_Object_QueryInterface", "long", "ptr;dword;dword")
Global $__g_pRichCom_Object_AddRef = DllCallbackRegister("__RichCom_Object_AddRef", "long", "ptr")
Global $__g_pRichCom_Object_Release = DllCallbackRegister("__RichCom_Object_Release", "long", "ptr")
Global $__g_pRichCom_Object_GetNewStorage = DllCallbackRegister("__RichCom_Object_GetNewStorage", "long", "ptr;ptr")
Global $__g_pRichCom_Object_GetInPlaceContext = DllCallbackRegister("__RichCom_Object_GetInPlaceContext", "long", "ptr;dword;dword;dword")
Global $__g_pRichCom_Object_ShowContainerUI = DllCallbackRegister("__RichCom_Object_ShowContainerUI", "long", "ptr;long")
Global $__g_pRichCom_Object_QueryInsertObject = DllCallbackRegister("__RichCom_Object_QueryInsertObject", "long", "ptr;dword;ptr;long")
Global $__g_pRichCom_Object_DeleteObject = DllCallbackRegister("__RichCom_Object_DeleteObject", "long", "ptr;ptr")
Global $__g_pRichCom_Object_QueryAcceptData = DllCallbackRegister("__RichCom_Object_QueryAcceptData", "long", "ptr;ptr;dword;dword;dword;ptr")
Global $__g_pRichCom_Object_ContextSensitiveHelp = DllCallbackRegister("__RichCom_Object_ContextSensitiveHelp", "long", "ptr;long")
Global $__g_pRichCom_Object_GetClipboardData = DllCallbackRegister("__RichCom_Object_GetClipboardData", "long", "ptr;ptr;dword;ptr")
Global $__g_pRichCom_Object_GetDragDropEffect = DllCallbackRegister("__RichCom_Object_GetDragDropEffect", "long", "ptr;dword;dword;dword")
Global $__g_pRichCom_Object_GetContextMenu = DllCallbackRegister("__RichCom_Object_GetContextMenu", "long", "ptr;short;ptr;ptr;ptr")
Global Const $_GCR_S_OK = 0
Global Const $_GCR_E_NOTIMPL = 0x80004001
Func __GCR_StreamFromFileCallback($hFile, $pBuf, $iBuflen, $pQbytes)
Local $tQbytes = DllStructCreate("long", $pQbytes)
DllStructSetData($tQbytes, 1, 0)
Local $tBuf = DllStructCreate("char[" & $iBuflen & "]", $pBuf)
Local $sBuf = FileRead($hFile, $iBuflen - 1)
If @error Then Return 1
DllStructSetData($tBuf, 1, $sBuf)
DllStructSetData($tQbytes, 1, StringLen($sBuf))
Return 0
EndFunc
Func __GCR_StreamFromVarCallback($iCookie, $pBuf, $iBuflen, $pQbytes)
#forceref $iCookie
Local $tQbytes = DllStructCreate("long", $pQbytes)
DllStructSetData($tQbytes, 1, 0)
Local $tCtl = DllStructCreate("char[" & $iBuflen & "]", $pBuf)
Local $sCtl = StringLeft($__g_pGRC_sStreamVar, $iBuflen - 1)
If $sCtl = "" Then Return 1
DllStructSetData($tCtl, 1, $sCtl)
Local $iLen = StringLen($sCtl)
DllStructSetData($tQbytes, 1, $iLen)
$__g_pGRC_sStreamVar = StringMid($__g_pGRC_sStreamVar, $iLen + 1)
Return 0
EndFunc
Func __GCR_StreamToFileCallback($hFile, $pBuf, $iBuflen, $pQbytes)
Local $tQbytes = DllStructCreate("long", $pQbytes)
DllStructSetData($tQbytes, 1, 0)
Local $tBuf = DllStructCreate("char[" & $iBuflen & "]", $pBuf)
Local $s = DllStructGetData($tBuf, 1)
FileWrite($hFile, $s)
DllStructSetData($tQbytes, 1, StringLen($s))
Return 0
EndFunc
Func __GCR_StreamToVarCallback($iCookie, $pBuf, $iBuflen, $pQbytes)
#forceref $iCookie
Local $tQbytes = DllStructCreate("long", $pQbytes)
DllStructSetData($tQbytes, 1, 0)
Local $tBuf = DllStructCreate("char[" & $iBuflen & "]", $pBuf)
Local $s = DllStructGetData($tBuf, 1)
$__g_pGRC_sStreamVar &= $s
Return 0
EndFunc
Func __RichCom_Object_QueryInterface($pObject, $iREFIID, $pPvObj)
#forceref $pObject, $iREFIID, $pPvObj
Return $_GCR_S_OK
EndFunc
Func __RichCom_Object_AddRef($pObject)
Local $tData = DllStructCreate("ptr;dword", $pObject)
DllStructSetData($tData, 2, DllStructGetData($tData, 2) + 1)
Return DllStructGetData($tData, 2)
EndFunc
Func __RichCom_Object_Release($pObject)
Local $tData = DllStructCreate("ptr;dword", $pObject)
If DllStructGetData($tData, 2) > 0 Then
DllStructSetData($tData, 2, DllStructGetData($tData, 2) - 1)
Return DllStructGetData($tData, 2)
EndIf
EndFunc
Func __RichCom_Object_GetInPlaceContext($pObject, $pPFrame, $pPDoc, $pFrameInfo)
#forceref $pObject, $pPFrame, $pPDoc, $pFrameInfo
Return $_GCR_E_NOTIMPL
EndFunc
Func __RichCom_Object_ShowContainerUI($pObject, $bShow)
#forceref $pObject, $bShow
Return $_GCR_E_NOTIMPL
EndFunc
Func __RichCom_Object_QueryInsertObject($pObject, $pClsid, $tStg, $vCp)
#forceref $pObject, $pClsid, $tStg, $vCp
Return $_GCR_S_OK
EndFunc
Func __RichCom_Object_DeleteObject($pObject, $pOleobj)
#forceref $pObject, $pOleobj
Return $_GCR_E_NOTIMPL
EndFunc
Func __RichCom_Object_QueryAcceptData($pObject, $pDataobj, $pCfFormat, $vReco, $bReally, $hMetaPict)
#forceref $pObject, $pDataobj, $pCfFormat, $vReco, $bReally, $hMetaPict
Return $_GCR_S_OK
EndFunc
Func __RichCom_Object_ContextSensitiveHelp($pObject, $bEnterMode)
#forceref $pObject, $bEnterMode
Return $_GCR_E_NOTIMPL
EndFunc
Func __RichCom_Object_GetClipboardData($pObject, $pChrg, $vReco, $pPdataobj)
#forceref $pObject, $pChrg, $vReco, $pPdataobj
Return $_GCR_E_NOTIMPL
EndFunc
Func __RichCom_Object_GetDragDropEffect($pObject, $bDrag, $iGrfKeyState, $piEffect)
#forceref $pObject, $bDrag, $iGrfKeyState, $piEffect
Return $_GCR_E_NOTIMPL
EndFunc
Func __RichCom_Object_GetContextMenu($pObject, $iSeltype, $pOleobj, $pChrg, $pHmenu)
#forceref $pObject, $iSeltype, $pOleobj, $pChrg, $pHmenu
Return $_GCR_E_NOTIMPL
EndFunc
Func __RichCom_Object_GetNewStorage($pObject, $pPstg)
#forceref $pObject
Local $aSc = DllCall($__g_hLib_RichCom_OLE32, "dword", "CreateILockBytesOnHGlobal", "hwnd", 0, "int", 1, "ptr*", 0)
Local $pLockBytes = $aSc[3]
$aSc = $aSc[0]
If $aSc Then Return $aSc
$aSc = DllCall($__g_hLib_RichCom_OLE32, "dword", "StgCreateDocfileOnILockBytes", "ptr", $pLockBytes, "dword", BitOR(0x10, 2, 0x1000), "dword", 0, "ptr*", 0)
Local $tStg = DllStructCreate("ptr", $pPstg)
DllStructSetData($tStg, 1, $aSc[4])
$aSc = $aSc[0]
If $aSc Then
Local $tObj = DllStructCreate("ptr", $pLockBytes)
Local $tUnknownFuncTable = DllStructCreate("ptr[3]", DllStructGetData($tObj, 1))
Local $pReleaseFunc = DllStructGetData($tUnknownFuncTable, 3)
DllCallAddress("long", $pReleaseFunc, "ptr", $pLockBytes)
EndIf
Return $aSc
EndFunc
Func _StringRepeat($sString, $iRepeatCount)
$iRepeatCount = Int($iRepeatCount)
If $iRepeatCount = 0 Then Return ""
If StringLen($sString) < 1 Or $iRepeatCount < 0 Then Return SetError(1, 0, "")
Local $sResult = ""
While $iRepeatCount > 1
If BitAND($iRepeatCount, 1) Then $sResult &= $sString
$sString &= $sString
$iRepeatCount = BitShift($iRepeatCount, 1)
WEnd
Return $sString & $sResult
EndFunc
Global Const $LVM_FIRST = 0x1000
Global Const $LVN_FIRST = -100
Global Const $PROV_RSA_AES = 24
Global Const $CRYPT_VERIFYCONTEXT = 0xF0000000
Global $__g_aCryptInternalData[3]
Func _Crypt_Startup()
If __Crypt_RefCount() = 0 Then
Local $hAdvapi32 = DllOpen("Advapi32.dll")
If $hAdvapi32 = -1 Then Return SetError(1, 0, False)
__Crypt_DllHandleSet($hAdvapi32)
Local $iProviderID = $PROV_RSA_AES
Local $aRet = DllCall(__Crypt_DllHandle(), "bool", "CryptAcquireContext", "handle*", 0, "ptr", 0, "ptr", 0, "dword", $iProviderID, "dword", $CRYPT_VERIFYCONTEXT)
If @error Or Not $aRet[0] Then
Local $iError = @error + 10, $iExtended = @extended
DllClose(__Crypt_DllHandle())
Return SetError($iError, $iExtended, False)
Else
__Crypt_ContextSet($aRet[1])
EndIf
EndIf
__Crypt_RefCountInc()
Return True
EndFunc
Func _Crypt_Shutdown()
__Crypt_RefCountDec()
If __Crypt_RefCount() = 0 Then
DllCall(__Crypt_DllHandle(), "bool", "CryptReleaseContext", "handle", __Crypt_Context(), "dword", 0)
DllClose(__Crypt_DllHandle())
EndIf
EndFunc
Func __Crypt_RefCount()
Return $__g_aCryptInternalData[0]
EndFunc
Func __Crypt_RefCountInc()
$__g_aCryptInternalData[0] += 1
EndFunc
Func __Crypt_RefCountDec()
If $__g_aCryptInternalData[0] > 0 Then $__g_aCryptInternalData[0] -= 1
EndFunc
Func __Crypt_DllHandle()
Return $__g_aCryptInternalData[1]
EndFunc
Func __Crypt_DllHandleSet($hAdvapi32)
$__g_aCryptInternalData[1] = $hAdvapi32
EndFunc
Func __Crypt_Context()
Return $__g_aCryptInternalData[2]
EndFunc
Func __Crypt_ContextSet($hCryptContext)
$__g_aCryptInternalData[2] = $hCryptContext
EndFunc
Global Const $g_sLogoPath = @ScriptDir & "\Images\Logo.png"
Global Const $g_sLogoUrlPath = @ScriptDir & "\Images\LogoURL.png"
Global Const $g_sLogoUrlSmallPath = @ScriptDir & "\Images\LogoURLsmall.png"
Global Const $g_iDEFAULT_HEIGHT = 780
Global Const $g_iDEFAULT_WIDTH = 860
Global Const $g_iMidOffsetY = Int(($g_iDEFAULT_HEIGHT - 720) / 2)
Global $g_hBotLaunchTime = __TimerInit()
Global $g_bDebugSetlog = False
Global $g_bDebugAndroid = False
Global $g_bDebugClick = False
Global $g_bDebugFuncTime = False
Global $g_bDebugFuncCall = False
Global $g_bDebugOcr = False
Global $g_bDebugImageSave = False
Global $g_bDebugBuildingPos = False
Global $g_bDebugSetlogTrain = False
Global $g_iDebugWindowMessages = 0
Global $g_bDebugSmartZap = False
Global $g_bDebugAttackCSV = False
Global $g_bDebugMakeIMGCSV = False
Global $g_bDebugBetaVersion = StringInStr($g_sBotVersion, " b") > 0
Global $g_bDebugDeadBaseImage = False
Global $g_bDebugResourcesOffset = False
Global $g_bDebugMilkingIMGmake = False
Global $g_bDebugContinueSearchElixir = False
Global $g_bDebugOCRdonate = False
Global $g_bDebugDisableZoomout = False
Global $g_bDebugDisableVillageCentering = False
Global $g_oDebugGDIHandles = ObjCreate("Scripting.Dictionary")
Global Const $COLOR_ERROR = $COLOR_RED
Global Const $COLOR_WARNING = $COLOR_MAROON
Global Const $COLOR_DEBUG = $COLOR_PURPLE
Global Const $COLOR_ACTION = 0xFF8000
Global $g_bWinMove2_Compatible = True
Global $g_iGuiMode = 1
Global $g_bGuiRemote = False
Global $g_iGuiPID = @AutoItPID
Global Const $g_b64Bit = StringInStr(@OSArch, "64") > 0
Global Const $g_sHKLM = "HKLM" &($g_b64Bit ? "64" : "")
Global $g_sAndroidGameDistributor = "Google"
Global $g_sAndroidGamePackage = "com.supercell.clashofclans"
Global $g_sAndroidGameClass = ".GameApp"
Global $g_sUserGameDistributor = "Google"
Global $g_sUserGamePackage = "com.supercell.clashofclans"
Global $g_sUserGameClass = ".GameApp"
Global $g_iAndroidRebootHours = 24
Global Const $g_bAndroidShieldPreWin8 =(_WinAPI_GetVersion() < 6.2)
Global $g_iAndroidShieldColor = $COLOR_WHITE
Global $g_iAndroidShieldTransparency = 48
Global $g_iAndroidActiveColor = $COLOR_BLACK
Global $g_iAndroidActiveTransparency = 1
Global $g_iAndroidInactiveColor = $COLOR_WHITE
Global $g_iAndroidInactiveTransparency = 24
Global $g_bAndroidEmbedEnabled = True
Global $g_bAndroidEmbedded = False
Global Const $g_bAndroidBackgroundLaunchEnabled = False
Global $g_bAndroidCheckTimeLagEnabled = True
Global $g_bAndroidAdbScreencapEnabled = True
Global $g_bAndroidAdbClickDragEnabled = True
Global $g_bAndroidAdbInputEnabled = True
Global $g_bAndroidAdbClickEnabled = False
Global $g_bAndroidAdbClicksEnabled = False
Global $g_iAndroidAdbClicksTroopDeploySize = 0
Global $g_bAndroidAdbInstanceEnabled = True
Global $g_iAndroidSuspendModeFlags = 1
Global $g_bNoFocusTampering = False
Global $g_avAndroidAppConfig[8][16] = [ ["Nox", "nox", "No", "[CLASS:subWin; INSTANCE:1]", "", $g_iDEFAULT_WIDTH, $g_iDEFAULT_HEIGHT - 48,$g_iDEFAULT_WIDTH + 4, $g_iDEFAULT_HEIGHT - 10,0, "127.0.0.1:62001", 1 + 2 + 4 + 8 + 16 + 32 + 256,'# ', '(nox Virtual Input|Android Input|Android_Input)', 0, 2], ["MEmu", "MEmu", "MEmu ", "[CLASS:subWin; INSTANCE:1]", "", $g_iDEFAULT_WIDTH, $g_iDEFAULT_HEIGHT - 48,$g_iDEFAULT_WIDTH + 51,$g_iDEFAULT_HEIGHT - 12,0, "127.0.0.1:21503", 2 + 4 + 8 + 16 + 32, '# ', '(Microvirt Virtual Input|User Input)', 0, 2], ["BlueStacks2","Android", "BlueStacks ", "[CLASS:BlueStacksApp; INSTANCE:1]","_ctl.Window", $g_iDEFAULT_WIDTH, $g_iDEFAULT_HEIGHT - 48,$g_iDEFAULT_WIDTH, $g_iDEFAULT_HEIGHT - 48,0, "127.0.0.1:5555", 1 + 2 + 8 + 16 + 32 + 128,'$ ', 'BlueStacks Virtual Touch', 0, 1], ["BlueStacks", "Android", "BlueStacks App Player","[CLASS:BlueStacksApp; INSTANCE:1]","_ctl.Window", $g_iDEFAULT_WIDTH, $g_iDEFAULT_HEIGHT - 48,$g_iDEFAULT_WIDTH, $g_iDEFAULT_HEIGHT - 48,0, "127.0.0.1:5555", 1 + 8 + 16 + 32 + 128,'$ ', 'BlueStacks Virtual Touch', 0, 1], ["iTools", "iToolsVM","iTools ", "[CLASS:subWin; INSTANCE:1]", "", $g_iDEFAULT_WIDTH, $g_iDEFAULT_HEIGHT - 48,$g_iDEFAULT_WIDTH + 2, $g_iDEFAULT_HEIGHT - 13,0, "127.0.0.1:54001", 1 + 2 + 8 + 16 + 32 + 64, '# ', 'iTools Virtual PassThrough Input', 0, 1], ["KOPLAYER", "KOPLAYER","KOPLAYER", "[CLASS:subWin; INSTANCE:1]", "", $g_iDEFAULT_WIDTH, $g_iDEFAULT_HEIGHT - 48,$g_iDEFAULT_WIDTH + 64,$g_iDEFAULT_HEIGHT - 8, 0, "127.0.0.1:6555", 1 + 2 + 4 + 8 + 16 + 32, '# ', 'ttVM Virtual Input', 0, 2], ["Droid4X", "droid4x", "Droid4X ", "[CLASS:subWin; INSTANCE:1]", "", $g_iDEFAULT_WIDTH, $g_iDEFAULT_HEIGHT - 48,$g_iDEFAULT_WIDTH + 10,$g_iDEFAULT_HEIGHT + 50,0, "127.0.0.1:26944", 2 + 4 + 8 + 16 + 32, '# ', 'droid4x Virtual Input', 0, 2], ["LeapDroid", "vm1", "Leapd", "[CLASS:subWin; INSTANCE:1]", "", $g_iDEFAULT_WIDTH, $g_iDEFAULT_HEIGHT - 48,$g_iDEFAULT_WIDTH, $g_iDEFAULT_HEIGHT - 48,0, "emulator-5554", 1 + 8 + 16 + 32, '# ', 'qwerty2', 1, 1] ]
Global $__MEmu_Idx = _ArraySearch($g_avAndroidAppConfig, "MEmu", 0, 0, 0, 0, 1, 0)
Global $__BS2_Idx = _ArraySearch($g_avAndroidAppConfig, "BlueStacks2", 0, 0, 0, 0, 1, 0)
Global $__BS_Idx = _ArraySearch($g_avAndroidAppConfig, "BlueStacks", 0, 0, 0, 0, 1, 0)
Global $__KOPLAYER_Idx = _ArraySearch($g_avAndroidAppConfig, "KOPLAYER", 0, 0, 0, 0, 1, 0)
Global $__LeapDroid_Idx = _ArraySearch($g_avAndroidAppConfig, "LeapDroid", 0, 0, 0, 0, 1, 0)
Global $__iTools_Idx = _ArraySearch($g_avAndroidAppConfig, "iTools", 0, 0, 0, 0, 1, 0)
Global $__Droid4X_Idx = _ArraySearch($g_avAndroidAppConfig, "Droid4X", 0, 0, 0, 0, 1, 0)
Global $__Nox_Idx = _ArraySearch($g_avAndroidAppConfig, "Nox", 0, 0, 0, 0, 1, 0)
Global $g_iAndroidBackgroundMode = 0
Global $g_iAndroidBackgroundModeDefault = 1
Global $g_iAndroidConfig = 0
Global $g_sAndroidVersion
Global $g_sAndroidEmulator
Global $g_sAndroidInstance
Global $g_sAndroidTitle
Global $g_bUpdateAndroidWindowTitle = False
Global $g_sAppClassInstance
Global $g_sAppPaneName
Global $g_iAndroidClientWidth
Global $g_iAndroidClientHeight
Global $g_iAndroidWindowWidth
Global $g_iAndroidWindowHeight
Global $g_sAndroidAdbPath
Global $g_sAndroidAdbDevice
Global $g_iAndroidSupportFeature
Global $g_sAndroidShellPrompt
Global $g_sAndroidMouseDevice
Global $g_iAndroidAdbSuCommand
Global $g_bAndroidAdbScreencap
Global $g_bAndroidAdbClick
Global $g_bAndroidAdbInput
Global $g_bAndroidAdbInstance
Global $g_bAndroidAdbClickDrag
Global $g_bAndroidAdbClickDragScript = True
Global $g_bAndroidEmbed
Global $g_iAndroidEmbedMode
Global $g_bAndroidBackgroundLaunch
Global $g_bAndroidBackgroundLaunched
Global $g_bAndroidCloseWithBot = False
Global $g_iAndroidProcessAffinityMask = 0
Global $g_bInitAndroidActive = False
Global $g_sAndroidProgramPath = ""
Global $b_sAndroidProgramWerFaultExcluded = True
Global $g_avAndroidProgramFileVersionInfo = 0
Global $g_sAndroidPicturesPath = ""
Global $g_sAndroidPicturesHostPath = ""
Global Const $g_iAndroidSecureFlags = 3
Global $g_sAndroidPicturesHostFolder = ""
Global $g_aiAndroidAdbScreencapBuffer = DllStructCreate("byte[" &($g_iDEFAULT_WIDTH * $g_iDEFAULT_HEIGHT * 4) & "]")
Global $g_iAndroidAdbScreencapTimeoutMin = 200
Global $g_iAndroidAdbScreencapTimeoutMax = 1000
Global $g_iAndroidAdbScreencapTimeoutDynamic = 3
Global $g_iAndroidAdbClickGroup = 10
Global $g_hAndroidWindow = 0
Global $g_bInitAndroid = True
Global $__VBoxManage_Path
Global $__VBoxGuestProperties
Global $__VBoxExtraData
Global $g_iGlobalActiveBotsAllowed = EnvGet("NUMBER_OF_PROCESSORS")
If IsNumber($g_iGlobalActiveBotsAllowed) = 0 Or $g_iGlobalActiveBotsAllowed < 1 Then $g_iGlobalActiveBotsAllowed = 2
Global $g_hMutextOrSemaphoreGlobalActiveBots = 0
Global $g_iGlobalThreads = 0
Global $g_iThreads = 0
Global $g_sProfilePath = @ScriptDir & "\Profiles"
Global $g_sProfileCurrentName = ""
Global $g_sProfileConfigPath = ""
Global $g_sProfileBuildingStatsPath = ""
Global $g_sProfileBuildingPath = ""
Global $g_sProfileLogsPath = "", $g_sProfileLootsPath = "", $g_sProfileTempPath = "", $g_sProfileTempDebugPath = ""
Global $g_sProfileDonateCapturePath = "", $g_sProfileDonateCaptureWhitelistPath = "", $g_sProfileDonateCaptureBlacklistPath = ""
Global $g_sProfileSecondaryInputFileName = ""
Global $g_bReadConfigIsActive = False
Global $g_hTxtLogTimer = __TimerInit()
Global $g_hStruct_SleepMicro = DllStructCreate("int64 time;")
Global $g_pStruct_SleepMicro = DllStructGetPtr($g_hStruct_SleepMicro)
Global $g_bDevMode = False
Global $g_bBotLaunchOption_Restart = False
Global $g_bBotLaunchOption_Autostart = False
Global $g_bBotLaunchOption_NoWatchdog = False
Global $g_bBotLaunchOption_ForceDpiAware = False
Global $g_iBotLaunchOption_Dock = 0
Global $g_bBotLaunchOption_NoBotSlot = False
Global $g_asCmdLine[1] = [0]
Global $g_WatchOnlyClientPID = Default
Global $g_WatchDogLogStatusBar = False
Global $g_aiWeakBaseStats
Global Const $g_sLibPath = @ScriptDir & "\lib"
Global $g_hLibNTDLL = DllOpen("ntdll.dll")
Global $g_hLibUser32DLL = DllOpen("user32.dll")
Global Const $g_sLibIconPath = $g_sLibPath & "\MBRBOT.dll"
Global $g_iRedrawBotWindowMode = 2
Global Enum $eIcnArcher = 1, $eIcnDonArcher, $eIcnBalloon, $eIcnDonBalloon, $eIcnBarbarian, $eIcnDonBarbarian, $eBtnTest, $eIcnBuilder, $eIcnCC, $eIcnGUI, $eIcnDark, $eIcnDragon, $eIcnDonDragon, $eIcnDrill, $eIcnElixir, $eIcnCollector, $eIcnFreezeSpell, $eIcnGem, $eIcnGiant, $eIcnDonGiant, $eIcnTrap, $eIcnGoblin, $eIcnDonGoblin, $eIcnGold, $eIcnGolem, $eIcnDonGolem, $eIcnHealer, $eIcnDonHealer, $eIcnHogRider, $eIcnDonHogRider, $eIcnHealSpell, $eIcnInferno, $eIcnJumpSpell, $eIcnLavaHound, $eIcnDonLavaHound, $eIcnLightSpell, $eIcnMinion, $eIcnDonMinion, $eIcnPekka, $eIcnDonPekka, $eIcnTreasury, $eIcnRageSpell, $eIcnTroops, $eIcnHourGlass, $eIcnTH1, $eIcnTH10, $eIcnTrophy, $eIcnValkyrie, $eIcnDonValkyrie, $eIcnWall, $eIcnWallBreaker, $eIcnDonWallBreaker, $eIcnWitch, $eIcnDonWitch, $eIcnWizard, $eIcnDonWizard, $eIcnXbow, $eIcnBarrackBoost, $eIcnMine, $eIcnCamp, $eIcnBarrack, $eIcnSpellFactory, $eIcnDonBlacklist, $eIcnSpellFactoryBoost, $eIcnMortar, $eIcnWizTower, $eIcnPayPal, $eIcnNotify, $eIcnGreenLight, $eIcnLaboratory, $eIcnRedLight, $eIcnBlank, $eIcnYellowLight, $eIcnDonCustom, $eIcnTombstone, $eIcnSilverStar, $eIcnGoldStar, $eIcnDarkBarrack, $eIcnCollectorLocate, $eIcnDrillLocate, $eIcnMineLocate, $eIcnBarrackLocate, $eIcnDarkBarrackLocate, $eIcnDarkSpellFactoryLocate, $eIcnDarkSpellFactory, $eIcnEarthQuakeSpell, $eIcnHasteSpell, $eIcnPoisonSpell, $eIcnBldgTarget, $eIcnBldgX, $eIcnRecycle, $eIcnHeroes, $eIcnBldgElixir, $eIcnBldgGold, $eIcnMagnifier, $eIcnWallElixir, $eIcnWallGold, $eIcnKing, $eIcnQueen, $eIcnDarkSpellBoost, $eIcnQueenBoostLocate, $eIcnKingBoostLocate, $eIcnKingUpgr, $eIcnQueenUpgr, $eIcnWardenUpgr, $eIcnWarden, $eIcnWardenBoostLocate, $eIcnKingBoost, $eIcnQueenBoost, $eIcnWardenBoost, $eEmpty3, $eIcnReload, $eIcnCopy, $eIcnAddcvs, $eIcnEdit, $eIcnTreeSnow, $eIcnSleepingQueen, $eIcnSleepingKing, $eIcnGoldElixir, $eIcnBowler, $eIcnDonBowler, $eIcnCCDonate, $eIcnEagleArt, $eIcnGembox, $eIcnInferno4, $eIcnInfo, $eIcnMain, $eIcnTree, $eIcnProfile, $eIcnCCRequest, $eIcnTelegram, $eIcnTiles, $eIcnXbow3, $eIcnBark, $eIcnDailyProgram, $eIcnLootCart, $eIcnSleepMode, $eIcnTH11, $eIcnTrainMode, $eIcnSleepingWarden, $eIcnCloneSpell, $eIcnSkeletonSpell, $eIcnBabyDragon, $eIcnDonBabyDragon, $eIcnMiner, $eIcnDonMiner, $eIcnNoShield, $eIcnDonCustomB, $eIcnAirdefense, $eIcnDarkBarrackBoost, $eIcnDarkElixirStorage, $eIcnSpellsCost, $eIcnTroopsCost, $eIcnResetButton, $eIcnNewSmartZap, $eIcnTrain, $eIcnAttack, $eIcnDelay, $eIcnReOrder, $eIcn2Arrow, $eIcnArrowLeft, $eIcnArrowRight, $eIcnAndroid, $eHdV04, $eHdV05, $eHdV06, $eHdV07, $eHdV08, $eHdV09, $eHdV10, $eHdV11, $eUnranked, $eBronze, $eSilver, $eGold, $eCrystal, $eMaster, $eChampion, $eTitan, $eLegend, $eWall04, $eWall05, $eWall06, $eWall07, $eWall08, $eWall09, $eWall10, $eWall11, $eIcnPBNotify, $eIcnCCTroops, $eIcnCCSpells, $eIcnSpellsGroup, $eBahasaIND, $eChinese_S, $eChinese_T, $eEnglish, $eFrench, $eGerman, $eItalian, $ePersian, $eRussian, $eSpanish, $eTurkish, $eMissingLangIcon, $eWall12, $ePortuguese, $eIcnDonPoisonSpell, $eIcnDonEarthQuakeSpell, $eIcnDonHasteSpell, $eIcnDonSkeletonSpell, $eVietnamese, $eKorean, $eAzerbaijani, $eArabic, $eIcnBuilderHall, $eIcnClockTower, $eIcnElixirCollectorL5, $eIcnGemMine, $eIcnGoldMineL5, $eIcnElectroDragon, $eIcnTH12, $eHdV12, $eWall13, $eIcnGrayShield, $eIcnBlueShield, $eIcnGreenShield, $eIcnRedShield
Global Enum $eBotNoAction, $eBotStart, $eBotStop, $eBotSearchMode, $eBotClose
Global $g_iBotAction = $eBotNoAction
Global $g_bBotMoveRequested = False
Global $g_bBotShrinkExpandToggleRequested = False
Global $g_bRunState = False
Global $g_bRestarted =($g_bBotLaunchOption_Autostart ? True : False)
Global $g_iFirstRun = 1
Global $g_iFirstAttack = 0
Global $g_hTimerSinceStarted = 0
Global $g_iTimePassed = 0
Global $g_bBotPaused = False
Global $g_bTogglePauseAllowed = True
Global Const $REDLINE_IMGLOC_RAW = 0
Global Const $DROPLINE_EDGE_FIRST = 1
Global Enum $eBarb, $eArch, $eGiant, $eGobl, $eWall, $eBall, $eWiza, $eHeal, $eDrag, $ePekk, $eBabyD, $eMine, $eEDrag, $eMini, $eHogs, $eValk, $eGole, $eWitc, $eLava, $eBowl, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell, $eArmyCount
Global Enum $DB, $LB, $TS, $MA, $TB, $DT
Global Const $g_iModeCount = 3
Global Enum $eTroopBarbarian, $eTroopArcher, $eTroopGiant, $eTroopGoblin, $eTroopWallBreaker, $eTroopBalloon, $eTroopWizard, $eTroopHealer, $eTroopDragon, $eTroopPekka, $eTroopBabyDragon, $eTroopMiner, $eTroopElectroDragon, $eTroopMinion, $eTroopHogRider, $eTroopValkyrie, $eTroopGolem, $eTroopWitch, $eTroopLavaHound, $eTroopBowler, $eTroopCount
Global Const $g_asTroopNames[$eTroopCount] = [ "Barbarian", "Archer", "Giant", "Goblin", "Wall Breaker", "Balloon", "Wizard", "Healer", "Dragon", "Pekka", "Baby Dragon", "Miner", "Electro Dragon", "Minion", "Hog Rider", "Valkyrie", "Golem", "Witch", "Lava Hound", "Bowler"]
Global Const $g_asTroopNamesPlural[$eTroopCount] = [ "Barbarians", "Archers", "Giants", "Goblins", "Wall Breakers", "Balloons", "Wizards", "Healers", "Dragons", "Pekkas", "Baby Dragons", "Miners", "Electro Dragons", "Minions", "Hog Riders", "Valkyries", "Golems", "Witches", "Lava Hounds", "Bowlers"]
Global Const $g_asTroopShortNames[$eTroopCount] = [ "Barb", "Arch", "Giant", "Gobl", "Wall", "Ball", "Wiza", "Heal", "Drag", "Pekk", "BabyD", "Mine", "EDrag", "Mini", "Hogs", "Valk", "Gole", "Witc", "Lava", "Bowl"]
Global Enum $eSpellLightning, $eSpellHeal, $eSpellRage, $eSpellJump, $eSpellFreeze, $eSpellClone, $eSpellPoison, $eSpellEarthquake, $eSpellHaste, $eSpellSkeleton, $eSpellCount
Global Const $g_asSpellNames[$eSpellCount] = ["Lightning", "Heal", "Rage", "Jump", "Freeze", "Clone", "Poison", "Earthquake", "Haste", "Skeleton"]
Global Const $g_asSpellShortNames[$eSpellCount] = ["LSpell", "HSpell", "RSpell", "JSpell", "FSpell", "CSpell", "PSpell", "ESpell", "HaSpell", "SkSpell"]
Global Enum $eHeroNone = 0, $eHeroKing = 1, $eHeroQueen = 2, $eHeroWarden = 4
Global Enum $eHeroBarbarianKing, $eHeroArcherQueen, $eHeroGrandWarden, $eHeroCount
Global Const $g_asHeroNames[$eHeroCount] = ["Barbarian King", "Archer Queen", "Grand Warden"]
Global Enum $eLootGold, $eLootElixir, $eLootDarkElixir, $eLootTrophy, $eLootCount
Func GetTroopName(Const $iIndex)
If $iIndex >= $eBarb And $iIndex <= $eBowl Then
Return $g_asTroopNames[$iIndex]
ElseIf $iIndex >= $eLSpell And $iIndex <= $eSkSpell Then
Return $g_asSpellNames[$iIndex - $eLSpell]
ElseIf $iIndex >= $eKing And $iIndex <= $eWarden Then
Return $g_asHeroNames[$iIndex - $eKing]
ElseIf $iIndex = $eCastle Then
Return "Clan Castle"
EndIf
EndFunc
Global $g_iLogDividerY = 385
Global $g_iCmbLogDividerOption = 0
Global $g_bChkBackgroundMode
Global $g_bChkBotStop = False, $g_iCmbBotCommand = 0, $g_iCmbBotCond = 0, $g_iCmbHoursStop = 0
Global $g_iTxtRestartGold = 10000
Global $g_iTxtRestartElixir = 25000
Global $g_iTxtRestartDark = 500
Global $g_bChkTrap = True, $g_bChkCollect = True, $g_bChkTombstones = True, $g_bChkCleanYard = False, $g_bChkGemsBox = False
Global $g_bChkTreasuryCollect = False
Global $g_iTxtTreasuryGold = 0
Global $g_iTxtTreasuryElixir = 0
Global $g_iTxtTreasuryDark = 0
Global $g_bChkCollectBuilderBase = False, $g_bChkStartClockTowerBoost = False, $g_bChkCTBoostBlderBz = False
Global $g_bRequestTroopsEnable = False
Global $g_sRequestTroopsText = ""
Global $g_abRequestCCHours[24] = [False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False]
Global $g_bChkDonate = True
Global Enum $eCustomA = $eTroopCount, $eCustomB = $eTroopCount + 1
Global Enum $eCustomC = $eTroopCount + 2, $eCustomD = $eTroopCount + 3
Global Const $g_iCustomDonateConfigs = 4
Global $g_abChkDonateTroop[$eTroopCount + $g_iCustomDonateConfigs] = [False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False]
Global $g_abChkDonateAllTroop[$eTroopCount + $g_iCustomDonateConfigs] = [False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False]
Global $g_asTxtDonateTroop[$eTroopCount + $g_iCustomDonateConfigs] = ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
Global $g_asTxtBlacklistTroop[$eTroopCount + $g_iCustomDonateConfigs] = ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
Global $g_abChkDonateSpell[$eSpellCount] = [False, False, False, False, False, False, False, False, False, False]
Global $g_abChkDonateAllSpell[$eSpellCount] = [False, False, False, False, False, False, False, False, False, False]
Global $g_asTxtDonateSpell[$eSpellCount] = ["", "", "", "", "", "", "", "", "", ""]
Global $g_asTxtBlacklistSpell[$eSpellCount] = ["", "", "", "", "", "", "", "", "", ""]
Global $g_aiDonateCustomTrpNumA[3][2] = [[0, 0], [0, 0], [0, 0]], $g_aiDonateCustomTrpNumB[3][2] = [[0, 0], [0, 0], [0, 0]]
Global $g_aiDonateCustomTrpNumC[3][2] = [[0, 0], [0, 0], [0, 0]], $g_aiDonateCustomTrpNumD[3][2] = [[0, 0], [0, 0], [0, 0]]
Global $g_bChkExtraAlphabets = False
Global $g_bChkExtraChinese = False
Global $g_bChkExtraKorean = False
Global $g_bChkExtraPersian = False
Global $g_sTxtGeneralBlacklist = ""
Global $g_bDonateHoursEnable = False
Global $g_abDonateHours[24] = [False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False]
Global $g_iCmbDonateFilter = 0
Global $g_bDonateSkipNearFullEnable = 1
Global $g_iDonateSkipNearFullPercent = 90
Global $g_bAutoLabUpgradeEnable = False, $g_iCmbLaboratory = 0
Global $g_bUpgradeKingEnable = False, $g_bUpgradeQueenEnable = False, $g_bUpgradeWardenEnable = False
Global Const $g_iUpgradeSlots = 14
Global $g_aiPicUpgradeStatus[$g_iUpgradeSlots] = [$eIcnTroops, $eIcnTroops, $eIcnTroops, $eIcnTroops, $eIcnTroops, $eIcnTroops, $eIcnTroops, $eIcnTroops, $eIcnTroops, $eIcnTroops, $eIcnTroops, $eIcnTroops, $eIcnTroops, $eIcnTroops]
Global $g_abBuildingUpgradeEnable[$g_iUpgradeSlots] = [False, False, False, False, False, False, False, False, False, False, False, False, False, False]
Global $g_avBuildingUpgrades[$g_iUpgradeSlots][8]
For $i = 0 To $g_iUpgradeSlots - 1
$g_avBuildingUpgrades[$i][0] = -1
$g_avBuildingUpgrades[$i][1] = -1
$g_avBuildingUpgrades[$i][2] = -1
$g_avBuildingUpgrades[$i][3] = ""
$g_avBuildingUpgrades[$i][4] = ""
$g_avBuildingUpgrades[$i][5] = ""
$g_avBuildingUpgrades[$i][6] = ""
$g_avBuildingUpgrades[$i][7] = ""
Next
Global $g_iUpgradeMinGold = 100000, $g_iUpgradeMinElixir = 100000, $g_iUpgradeMinDark = 3000
Global $g_abUpgradeRepeatEnable[$g_iUpgradeSlots] = [False, False, False, False, False, False, False, False, False, False, False, False, False, False]
Global $g_bAutoUpgradeWallsEnable = 0
Global $g_iUpgradeWallMinGold = 0, $g_iUpgradeWallMinElixir = 0
Global $g_iUpgradeWallLootType = 0, $g_bUpgradeWallSaveBuilder = False
Global $g_iCmbUpgradeWallsLevel = 6
Global $g_aiWallsCurrentCount[14] = [-1, -1, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_aiLastGoodWallPos[2] = [-1, -1]
Global $g_iChkAutoUpgrade = 0
Global $g_iTxtSmartMinGold = 150000, $g_iTxtSmartMinElixir = 150000, $g_iTxtSmartMinDark = 1500
Global $g_iChkUpgradesToIgnore[13] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_iChkResourcesToIgnore[3] = [0, 0, 0]
Global $g_iChkBBSuggestedUpgrades = 0, $g_iChkBBSuggestedUpgradesIgnoreGold = 0, $g_iChkBBSuggestedUpgradesIgnoreElixir = 0, $g_iChkBBSuggestedUpgradesIgnoreHall = 0
Global $g_iChkPlacingNewBuildings = 0
Global $g_iUnbrkMode = 0, $g_iUnbrkWait = 5
Global $g_iUnbrkMinGold = 50000, $g_iUnbrkMinElixir = 50000, $g_iUnbrkMaxGold = 600000, $g_iUnbrkMaxElixir = 600000, $g_iUnbrkMinDark = 5000, $g_iUnbrkMaxDark = 6000
Global $g_bNotifyPBEnable = False, $g_sNotifyPBToken = ""
Global $g_bNotifyTGEnable = False, $g_sNotifyTGToken = ""
Global $g_bNotifyRemoteEnable = False, $g_sNotifyOrigin = "", $g_bNotifyDeleteAllPushesOnStart = False, $g_bNotifyDeletePushesOlderThan = False, $g_iNotifyDeletePushesOlderThanHours = 4
Global $g_bNotifyAlertMatchFound = False, $g_bNotifyAlerLastRaidIMG = False, $g_bNotifyAlerLastRaidTXT = False, $g_bNotifyAlertCampFull = False, $g_bNotifyAlertUpgradeWalls = False, $g_bNotifyAlertOutOfSync = False, $g_bNotifyAlertTakeBreak = False, $g_bNotifyAlertBulderIdle = False, $g_bNotifyAlertVillageReport = False, $g_bNotifyAlertLastAttack = False, $g_bNotifyAlertAnotherDevice = False, $g_bNotifyAlertMaintenance = False, $g_bNotifyAlertBAN = False, $g_bNotifyAlertBOTUpdate = False, $g_bNotifyAlertSmartWaitTime = False
Global $g_bNotifyScheduleHoursEnable = False, $g_bNotifyScheduleWeekDaysEnable = False
Global $g_abNotifyScheduleHours[24] = [False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False]
Global $g_abNotifyScheduleWeekDays[7] = [False, False, False, False, False, False, False]
Global $g_bQuickTrainEnable = False
Global $g_bQuickTrainArmy[3] = [True, False, False]
Global $g_aiArmyCompTroops[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_aiArmyCompSpells[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_aiTrainArmyTroopLevel[$eTroopCount] = [1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_aiTrainArmySpellLevel[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_iTrainArmyFullTroopPct = 100
Global $g_bTotalCampForced = False, $g_iTotalCampForcedValue = 200
Global $g_bForceBrewSpells = False
Global $g_iTotalSpellValue = 0
Global $g_abBoostBarracksHours[24] = [True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True]
Global $g_bCustomTrainOrderEnable = False, $g_aiCmbCustomTrainOrder[$eTroopCount] = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]
Global $g_bCustomBrewOrderEnable = False, $g_aiCmbCustomBrewOrder[$eSpellCount] = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1]
Global Enum $eTroopBarbarianS, $eTroopArcherS, $eTroopGiantS, $eTroopGoblinS, $eTroopWallBreakerS, $eTroopBalloonS, $eTroopWizardS, $eTroopHealerS, $eTroopDragonS, $eTroopPekkaS, $eTroopBabyDragonS, $eTroopMinerS, $eTroopElectroDragons, $eTroopMinionS, $eTroopHogRiderS, $eTroopValkyrieS, $eTroopGolemS, $eTroopWitchS, $eTroopLavaHoundS, $eTroopBowlerS, $eHeroeS, $eCCS, $eDropOrderCount
Global $g_bCustomDropOrderEnable = False, $g_aiCmbCustomDropOrder[$eDropOrderCount] = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]
Global $g_bCloseWhileTrainingEnable = True, $g_bCloseWithoutShield = False, $g_bCloseEmulator = False, $g_bSuspendComputer = False, $g_bCloseRandom = False, $g_bCloseExactTime = False, $g_bCloseRandomTime = True, $g_iCloseRandomTimePercent = 10, $g_iCloseMinimumTime = 2
Global $g_iTrainClickDelay = 40
Global $g_bTrainAddRandomDelayEnable = False, $g_iTrainAddRandomDelayMin = 5, $g_iTrainAddRandomDelayMax = 60
Global $g_abAttackTypeEnable[$g_iModeCount + 3] = [True, False, False, -1, False, -1]
Global $g_abSearchSearchesEnable[$g_iModeCount] = [True, False, False], $g_aiSearchSearchesMin[$g_iModeCount] = [0, 0, 0], $g_aiSearchSearchesMax[$g_iModeCount] = [0, 0, 0]
Global $g_abSearchTropiesEnable[$g_iModeCount] = [False, False, False], $g_aiSearchTrophiesMin[$g_iModeCount] = [0, 0, 0], $g_aiSearchTrophiesMax[$g_iModeCount] = [0, 0, 0]
Global $g_abSearchCampsEnable[$g_iModeCount] = [False, False, False], $g_aiSearchCampsPct[$g_iModeCount] = [0, 0, 0]
Global $g_aiSearchHeroWaitEnable[$g_iModeCount] = [0, 0, 0]
Global $g_abSearchSpellsWaitEnable[$g_iModeCount] = [False, False, False]
Global $g_abSearchCastleSpellsWaitEnable[$g_iModeCount] = [False, False, False], $g_aiSearchCastleSpellsWaitRegular[$g_iModeCount] = [0, 0, 0], $g_aiSearchCastleSpellsWaitDark[$g_iModeCount] = [0, 0, 0]
Global $g_abSearchCastleTroopsWaitEnable[$g_iModeCount] = [False, False, False]
Global $g_aiSearchNotWaitHeroesEnable[$g_iModeCount] = [0, 0, 0]
Global $g_aiFilterMeetGE[$g_iModeCount] = [0, 0, 0], $g_aiFilterMinGold[$g_iModeCount] = [0, 0, 0], $g_aiFilterMinElixir[$g_iModeCount] = [0, 0, 0], $g_aiFilterMinGoldPlusElixir[$g_iModeCount] = [0, 0, 0]
Global $g_abFilterMeetDEEnable[$g_iModeCount] = [False, False, False], $g_aiFilterMeetDEMin[$g_iModeCount] = [0, 0, 0]
Global $g_abFilterMeetTrophyEnable[$g_iModeCount] = [False, False, False], $g_aiFilterMeetTrophyMin[$g_iModeCount] = [0, 0, 0], $g_aiFilterMeetTrophyMax[$g_iModeCount] = [99, 99, 99]
Global $g_abFilterMeetTH[$g_iModeCount] = [False, False, False], $g_aiFilterMeetTHMin[$g_iModeCount] = [0, 0, 0]
Global $g_abFilterMeetTHOutsideEnable[$g_iModeCount] = [False, False, False]
Global $g_abFilterMaxMortarEnable[$g_iModeCount] = [False, False, False], $g_abFilterMaxWizTowerEnable[$g_iModeCount] = [False, False, False], $g_abFilterMaxAirDefenseEnable[$g_iModeCount] = [False, False, False], $g_abFilterMaxXBowEnable[$g_iModeCount] = [False, False, False], $g_abFilterMaxInfernoEnable[$g_iModeCount] = [False, False, False], $g_abFilterMaxEagleEnable[$g_iModeCount] = [False, False, False]
Global $g_aiFilterMaxMortarLevel[$g_iModeCount] = [5, 5, 0], $g_aiFilterMaxWizTowerLevel[$g_iModeCount] = [4, 4, 0], $g_aiFilterMaxAirDefenseLevel[$g_iModeCount] = [0, 0, 0], $g_aiFilterMaxXBowLevel[$g_iModeCount] = [0, 0, 0], $g_aiFilterMaxInfernoLevel[$g_iModeCount] = [0, 0, 0], $g_aiFilterMaxEagleLevel[$g_iModeCount] = [0, 0, 0]
Global $g_abFilterMeetOneConditionEnable[$g_iModeCount] = [False, False, False]
Global $g_aiAttackAlgorithm[$g_iModeCount] = [0, 0, 0], $g_aiAttackTroopSelection[$g_iModeCount + 3] = [0, 0, 0, 0, 0, 0], $g_aiAttackUseHeroes[$g_iModeCount] = [0, 0, 0], $g_abAttackDropCC[$g_iModeCount] = [0, 0, 0]
Global $g_abAttackUseLightSpell[$g_iModeCount] = [0, 0, 0], $g_abAttackUseHealSpell[$g_iModeCount] = [0, 0, 0], $g_abAttackUseRageSpell[$g_iModeCount] = [0, 0, 0], $g_abAttackUseJumpSpell[$g_iModeCount] = [0, 0, 0], $g_abAttackUseFreezeSpell[$g_iModeCount] = [0, 0, 0], $g_abAttackUseCloneSpell[$g_iModeCount] = [0, 0, 0], $g_abAttackUsePoisonSpell[$g_iModeCount] = [0, 0, 0], $g_abAttackUseEarthquakeSpell[$g_iModeCount] = [0, 0, 0], $g_abAttackUseHasteSpell[$g_iModeCount] = [0, 0, 0], $g_abAttackUseSkeletonSpell[$g_iModeCount] = [0, 0, 0]
Global $g_bTHSnipeBeforeEnable[$g_iModeCount] = [False, False, False], $g_iTHSnipeBeforeTiles[$g_iModeCount] = [0, 0, 0], $g_iTHSnipeBeforeScript[$g_iModeCount] = [0, 0, 0]
Global $g_aiAttackStdDropOrder[$g_iModeCount + 1] = [0, 0, 0, 0], $g_aiAttackStdDropSides[$g_iModeCount + 1] = [3, 3, 0, 1], $g_aiAttackStdUnitDelay[$g_iModeCount + 1] = [4, 4, 0, 4], $g_aiAttackStdWaveDelay[$g_iModeCount + 1] = [4, 4, 0, 4], $g_abAttackStdRandomizeDelay[$g_iModeCount + 1] = [True, True, False, True], $g_abAttackStdSmartAttack[$g_iModeCount + 3] = [True, True, False, True, False, False], $g_aiAttackStdSmartDeploy[$g_iModeCount + 3] = [0, 0, 0, 0, 0, 0]
Global $g_abAttackStdSmartNearCollectors[$g_iModeCount + 3][3] = [[False, False, False], [False, False, False], [False, False, False], [False, False, False], [False, False, False], [False, False, False]]
Global $g_aiAttackScrRedlineRoutine[$g_iModeCount + 3] = [$REDLINE_IMGLOC_RAW, $REDLINE_IMGLOC_RAW, 0, 0, 0, 0]
Global $g_aiAttackScrDroplineEdge[$g_iModeCount + 3] = [$DROPLINE_EDGE_FIRST, $DROPLINE_EDGE_FIRST, 0, 0, 0, 0]
Global $g_sAttackScrScriptName[$g_iModeCount] = ["Barch four fingers", "Barch four fingers", ""]
Global $g_abStopAtkNoLoot1Enable[$g_iModeCount] = [True, True, False], $g_aiStopAtkNoLoot1Time[$g_iModeCount] = [0, 0, 0], $g_abStopAtkNoLoot2Enable[$g_iModeCount] = [False, False, False], $g_aiStopAtkNoLoot2Time[$g_iModeCount] = [0, 0, 0]
Global $g_aiStopAtkNoLoot2MinGold[$g_iModeCount] = [0, 0, 0], $g_aiStopAtkNoLoot2MinElixir[$g_iModeCount] = [0, 0, 0], $g_aiStopAtkNoLoot2MinDark[$g_iModeCount] = [0, 0, 0]
Global $g_abStopAtkNoResources[$g_iModeCount] = [False, False, False], $g_abStopAtkOneStar[$g_iModeCount] = [False, False, False], $g_abStopAtkTwoStars[$g_iModeCount] = [False, False, False]
Global $g_abStopAtkPctHigherEnable[$g_iModeCount] = [False, False, False], $g_aiStopAtkPctHigherAmt[$g_iModeCount] = [0, 0, 0]
Global $g_abStopAtkPctNoChangeEnable[$g_iModeCount] = [False, False, False], $g_aiStopAtkPctNoChangeTime[$g_iModeCount] = [0, 0, 0]
Global $g_iMilkAttackType = 1, $g_aiMilkFarmElixirParam[9] = [-1, -1, -1, -1, -1, -1, 2, 2, 2]
Global $g_bMilkFarmLocateElixir = True, $g_bMilkFarmLocateMine = True, $g_bMilkFarmLocateDrill = True
Global $g_iMilkFarmMineParam = 5
Global $g_iMilkFarmDrillParam = 1
Global $g_iMilkFarmResMaxTilesFromBorder = 0, $g_bMilkFarmAttackGoldMines = True, $g_bMilkFarmAttackElixirExtractors = True, $g_bMilkFarmAttackDarkDrills = True, $g_iMilkFarmLimitGold = 9995000, $g_iMilkFarmLimitElixir = 9995000, $g_iMilkFarmLimitDark = 200000
Global $g_iMilkFarmTroopForWaveMin = 4, $g_iMilkFarmTroopForWaveMax = 6, $g_iMilkFarmTroopMaxWaves = 3, $g_iMilkFarmDelayFromWavesMin = 3000, $g_iMilkFarmDelayFromWavesMax = 5000
Global $g_iMilkingAttackDropGoblinAlgorithm = 1
Global $g_iMilkingAttackStructureOrder = 1, $g_bMilkingAttackCheckStructureDestroyedBeforeAttack = False, $g_bMilkingAttackCheckStructureDestroyedAfterAttack = False
Global $g_bMilkAttackAfterTHSnipeEnable = False, $g_iMilkFarmTHMaxTilesFromBorder = 1, $g_sMilkFarmAlgorithmTh = "Queen&GobTakeTH", $g_bMilkFarmSnipeEvenIfNoExtractorsFound = False, $g_bMilkAttackAfterScriptedAtkEnable = False, $g_sMilkAttackCSVscript = "Barch four fingers"
Global $g_bMilkFarmForceToleranceEnable = False, $g_iMilkFarmForceToleranceNormal = 31, $g_iMilkFarmForceToleranceBoosted = 31, $g_iMilkFarmForceToleranceDestroyed = 31
Global $g_abCollectorLevelEnabled[13] = [-1, -1, -1, -1, -1, -1, True, True, True, True, True, True, True]
Global $g_aiCollectorLevelFill[13] = [-1, -1, -1, -1, -1, -1, 1, 1, 1, 1, 1, 1, 1]
Global $g_bCollectorFilterDisable = False
Global $g_iCollectorMatchesMin = 3
Global $g_iCollectorToleranceOffset = 0
Global $g_bDESideEndEnable = False, $g_iDESideEndMin = 25, $g_bDESideDisableOther = False, $g_bDESideEndAQWeak = False, $g_bDESideEndBKWeak = False, $g_bDESideEndOneStar = False
Global $g_iAtkTSAddTilesWhileTrain = 1, $g_iAtkTSAddTilesFullTroops = 0
Global $g_sAtkTSType = "Bam"
Global $g_bEndTSCampsEnable = False, $g_iEndTSCampsPct = 0
Global $g_iAtkTBEnableCount = 150, $g_iAtkTBMaxTHLevel = 0, $g_iAtkTBMode = 0
Global $g_bSearchReductionEnable = False, $g_iSearchReductionCount = 20, $g_iSearchReductionGold = 2000, $g_iSearchReductionElixir = 2000, $g_iSearchReductionGoldPlusElixir = 4000, $g_iSearchReductionDark = 100, $g_iSearchReductionTrophy = 2
Global $g_iSearchDelayMin = 0, $g_iSearchDelayMax = 0
Global $g_bSearchAttackNowEnable = False, $g_iSearchAttackNowDelay = 0, $g_bSearchRestartEnable = False, $g_iSearchRestartLimit = 25, $g_bSearchAlertMe = True
Global $g_iActivateQueen = 0, $g_iActivateKing = 0, $g_iActivateWarden = 0
Global $g_iDelayActivateQueen = 9000, $g_iDelayActivateKing = 9000, $g_iDelayActivateWarden = 10000
Global $g_bAttackPlannerEnable = False, $g_bAttackPlannerCloseCoC = False, $g_bAttackPlannerCloseAll = False, $g_bAttackPlannerSuspendComputer = False, $g_bAttackPlannerRandomEnable = False, $g_iAttackPlannerRandomTime = 0, $g_iAttackPlannerRandomTime = 0, $g_bAttackPlannerDayLimit = False, $g_iAttackPlannerDayMin = 12, $g_iAttackPlannerDayMax = 15
Global $g_abPlannedAttackWeekDays[7] = [True, True, True, True, True, True, True]
Global $g_abPlannedattackHours[24] = [True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True]
Global $g_bPlannedDropCCHoursEnable = False, $g_bUseCCBalanced = False, $g_iCCDonated = 0, $g_iCCReceived = 0
Global $g_abPlannedDropCCHours[24] = [True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True]
Global $g_bSmartZapEnable = False, $g_bEarthQuakeZap = False, $g_bNoobZap = False, $g_bSmartZapDB = True, $g_bSmartZapSaveHeroes = True, $g_bSmartZapFTW = False, $g_iSmartZapMinDE = 350, $g_iSmartZapExpectedDE = 320, $g_bDebugSmartZap = False
Global $g_bShareAttackEnable = 0, $g_iShareMinGold = 300000, $g_iShareMinElixir = 300000, $g_iShareMinDark = 0, $g_sShareMessage = "Nice|Good|Thanks|Wowwww", $g_bTakeLootSnapShot = True, $g_bScreenshotLootInfo = False, $g_bShareAttackEnableNow = False
Global $g_bDropTrophyEnable = False, $g_iDropTrophyMax = 1200, $g_iDropTrophyMin = 800, $g_bDropTrophyUseHeroes = False, $g_iDropTrophyHeroesPriority = 0, $g_bDropTrophyAtkDead = 0, $g_iDropTrophyArmyMinPct = 70
Global $g_sLanguage = "English"
Global $g_bDisableSplash = False
Global $g_bCheckVersion = True
Global $g_bDeleteLogs = True, $g_iDeleteLogsDays = 2, $g_bDeleteTemp = True, $g_iDeleteTempDays = 2, $g_bDeleteLoots = True, $g_iDeleteLootsDays = 2
Global $g_bAutoStart = False, $g_iAutoStartDelay = 10
Global $g_bCheckGameLanguage = True
Global $g_bAutoAlignEnable = False, $g_iAutoAlignPosition = "EMBED", $g_iAutoAlignOffsetX = "", $g_iAutoAlignOffsetY = ""
Global $g_bUpdatingWhenMinimized = True
Global $g_bHideWhenMinimized = False
Global $g_bUseRandomClick = False
Global $g_bScreenshotPNGFormat = False, $g_bScreenshotHideName = True
Global $g_iAnotherDeviceWaitTime = 120
Global $g_bForceSinglePBLogoff = 0, $g_iSinglePBForcedLogoffTime = 18, $g_iSinglePBForcedEarlyExitTime = 15
Global $g_bAutoResumeEnable = 0, $g_iAutoResumeTime = 5
Global $g_bDisableNotifications = False
Global $g_bForceClanCastleDetection = 0
Global $g_iCmbSwitchAcc = 0
Global $g_bChkGooglePlay = True, $g_bChkSuperCellID = False, $g_bChkSharedPrefs = False
Global $g_bChkSwitchAcc = False, $g_bChkSmartSwitch = False, $g_bDonateLikeCrazy = False, $g_iTotalAcc = -1, $g_iTrainTimeToSkip = 0
Global $g_abAccountNo[8], $g_asProfileName[8], $g_abDonateOnly[8]
Global Const $g_WIN_POS_DEFAULT = 0xFFFFFFF
Global $g_iFrmBotPosX = $g_WIN_POS_DEFAULT
Global $g_iFrmBotPosY = $g_WIN_POS_DEFAULT
Global $g_iAndroidPosX = $g_WIN_POS_DEFAULT
Global $g_iAndroidPosY = $g_WIN_POS_DEFAULT
Global $g_iFrmBotDockedPosX = $g_WIN_POS_DEFAULT
Global $g_iFrmBotDockedPosY = $g_WIN_POS_DEFAULT
Global $g_bGUIControlDisabled = False
Global Const $g_sDirLanguages = @ScriptDir & "\Languages\"
Global Const $g_sDefaultLanguage = "English"
Global $g_iFreeBuilderCount = 0, $g_iTotalBuilderCount = 0, $g_iGemAmount = 0
Global $g_iStatsStartedWith[$eLootCount] = [0, 0, 0, 0]
Global $g_iStatsTotalGain[$eLootCount] = [0, 0, 0, 0]
Global $g_iStatsLastAttack[$eLootCount] = [0, 0, 0, 0]
Global $g_iStatsBonusLast[$eLootCount] = [0, 0, 0, 0]
Global $g_iSkippedVillageCount = 0, $g_iDroppedTrophyCount = 0
Global $g_aiAttackedCount = 0
Global $g_aiCurrentLoot[$eLootCount] = [0, 0, 0, 0]
Global $g_iTownHallLevel = 0
Global $g_aiTownHallPos[2] = [-1, -1]
Global $g_aiKingAltarPos[2] = [-1, -1]
Global $g_aiQueenAltarPos[2] = [-1, -1]
Global $g_aiWardenAltarPos[2] = [-1, -1]
Global $g_aiLaboratoryPos[2] = [-1, -1]
Global $g_aiClanCastlePos[2] = [-1, -1]
Global $g_CurrentCampUtilization = 0, $g_iTotalCampSpace = 0
Global $g_sLabUpgradeTime = ""
Global $g_iWallCost = 0
Global $g_iHeroWaitAttackNoBit[$g_iModeCount][3]
Global Enum $eBldgRedLine, $eBldgTownHall, $eBldgGoldM, $eBldgElixirC, $eBldgDrill, $eBldgGoldS, $eBldgElixirS, $eBldgDarkS, $eBldgEagle, $eBldgInferno, $eBldgXBow, $eBldgWizTower, $eBldgMortar, $eBldgAirDefense
Global $g_oBldgAttackInfo = ObjCreate("Scripting.Dictionary")
$g_oBldgAttackInfo.CompareMode = 1
Global $g_oBldgLevels = ObjCreate("Scripting.Dictionary")
Func _FilloBldgLevels()
Local Const $aBldgCollector[12] = [2, 4, 6, 8, 10, 10, 11, 12, 12, 12, 12, 12]
$g_oBldgLevels.add($eBldgGoldM, $aBldgCollector)
$g_oBldgLevels.add($eBldgElixirC, $aBldgCollector)
Local Const $aBldgDrill[12] = [0, 0, 0, 0, 0, 0, 3, 3, 6, 6, 6, 6]
$g_oBldgLevels.add($eBldgDrill, $aBldgDrill)
Local Const $aBldgStorage[12] = [1, 3, 6, 8, 9, 10, 11, 11, 11, 11, 12, 13]
$g_oBldgLevels.add($eBldgGoldS, $aBldgStorage)
$g_oBldgLevels.add($eBldgElixirS, $aBldgStorage)
Local Const $aBldgDarkStorage[12] = [0, 0, 0, 0, 0, 0, 2, 4, 6, 6, 6, 7]
$g_oBldgLevels.add($eBldgDarkS, $aBldgDarkStorage)
Local Const $aBldgEagle[12] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 3]
$g_oBldgLevels.add($eBldgEagle, $aBldgEagle)
Local Const $aBldgInferno[12] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 5, 6]
$g_oBldgLevels.add($eBldgInferno, $aBldgInferno)
Local Const $aBldgMortar[12] = [0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 10, 11]
$g_oBldgLevels.add($eBldgMortar, $aBldgMortar)
Local Const $aBldgWizTower[12] = [0, 0, 0, 0, 2, 3, 4, 6, 7, 9, 10, 11]
$g_oBldgLevels.add($eBldgWizTower, $aBldgWizTower)
Local Const $aBldgXBow[12] = [0, 0, 0, 0, 0, 0, 0, 0, 3, 4, 5, 6]
$g_oBldgLevels.add($eBldgXBow, $aBldgXBow)
Local Const $aBldgAirDefense[12] = [0, 0, 0, 2, 3, 4, 5, 6, 7, 8, 9, 10]
$g_oBldgLevels.add($eBldgAirDefense, $aBldgAirDefense)
EndFunc
_FilloBldgLevels()
Global $g_oBldgMaxQty = ObjCreate("Scripting.Dictionary")
Func _FilloBldgMaxQty()
Local Const $aBldgCollector[12] = [1, 2, 3, 4, 5, 6, 6, 6, 6, 7, 7, 7]
$g_oBldgMaxQty.add($eBldgGoldM, $aBldgCollector)
$g_oBldgMaxQty.add($eBldgElixirC, $aBldgCollector)
Local Const $aBldgDrill[12] = [0, 0, 0, 0, 0, 0, 1, 2, 2, 3, 3, 3]
$g_oBldgMaxQty.add($eBldgDrill, $aBldgDrill)
Local Const $aBldgStorage[12] = [1, 1, 2, 2, 2, 2, 2, 3, 4, 4, 4, 4]
$g_oBldgMaxQty.add($eBldgGoldS, $aBldgStorage)
$g_oBldgMaxQty.add($eBldgElixirS, $aBldgStorage)
Local Const $aBldgDarkStorage[12] = [0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1]
$g_oBldgMaxQty.add($eBldgDarkS, $aBldgDarkStorage)
Local Const $aBldgEagle[12] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1]
$g_oBldgMaxQty.add($eBldgEagle, $aBldgEagle)
Local Const $aBldgInferno[12] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2]
$g_oBldgMaxQty.add($eBldgInferno, $aBldgInferno)
Local Const $aBldgMortar[12] = [0, 0, 1, 1, 1, 2, 3, 4, 4, 4, 4, 4]
$g_oBldgMaxQty.add($eBldgMortar, $aBldgMortar)
Local Const $aBldgWizTower[12] = [0, 0, 0, 0, 1, 2, 2, 3, 4, 4, 5, 5]
$g_oBldgMaxQty.add($eBldgWizTower, $aBldgWizTower)
Local Const $aBldgXBow[12] = [0, 0, 0, 0, 0, 0, 0, 0, 2, 3, 4, 4]
$g_oBldgMaxQty.add($eBldgXBow, $aBldgXBow)
Local Const $aBldgAirDefense[12] = [0, 0, 0, 1, 1, 2, 3, 3, 4, 4, 4, 4]
$g_oBldgMaxQty.add($eBldgAirDefense, $aBldgAirDefense)
EndFunc
_FilloBldgMaxQty()
Global $g_oBldgImages = ObjCreate("Scripting.Dictionary")
$g_oBldgImages.add($eBldgTownHall & "_" & "0", "imglocth-bundle")
$g_oBldgImages.add($eBldgTownHall & "_" & "1", "snow-imglocth-bundle")
$g_oBldgImages.add($eBldgGoldM & "_" & "0", @ScriptDir & "\imgxml\Storages\Mines")
$g_oBldgImages.add($eBldgGoldM & "_" & "1", @ScriptDir & "\imgxml\Storages\Mines_Snow")
$g_oBldgImages.add($eBldgElixirC & "_" & "0", @ScriptDir & "\imgxml\Storages\Collectors")
$g_oBldgImages.add($eBldgElixirC & "_" & "1", @ScriptDir & "\imgxml\Storages\CollectorsSnow")
$g_oBldgImages.add($eBldgDrill & "_" & "0", @ScriptDir & "\imgxml\Storages\Drills")
$g_oBldgImages.add($eBldgGoldS & "_" & "0", @ScriptDir & "\imgxml\Storages\Gold")
$g_oBldgImages.add($eBldgElixirS & "_" & "0", @ScriptDir & "\imgxml\Storages\Elixir")
$g_oBldgImages.add($eBldgEagle & "_" & "0", @ScriptDir & "\imgxml\Buildings\Eagle")
$g_oBldgImages.add($eBldgInferno & "_" & "0", @ScriptDir & "\imgxml\Buildings\Infernos")
$g_oBldgImages.add($eBldgXBow & "_" & "0", @ScriptDir & "\imgxml\Buildings\Xbow")
$g_oBldgImages.add($eBldgWizTower & "_" & "0", @ScriptDir & "\imgxml\Buildings\WTower")
$g_oBldgImages.add($eBldgWizTower & "_" & "1", @ScriptDir & "\imgxml\Buildings\WTowerSnow")
$g_oBldgImages.add($eBldgMortar & "_" & "0", @ScriptDir & "\imgxml\Buildings\Mortars")
$g_oBldgImages.add($eBldgAirDefense & "_" & "0", @ScriptDir & "\imgxml\Buildings\ADefense")
Global $g_bChkClanGamesAir = 0, $g_bChkClanGamesGround = 0, $g_bChkClanGamesMisc = 0
Global $g_bChkClanGamesEnabled = 0
Global $g_bChkClanGamesOnly = 0
Global $g_bChkClanGamesLoot = 0
Global $g_bChkClanGamesBattle = 0
Global $g_bChkClanGamesDestruction = 0
Global $g_bChkClanGamesAirTroop = 0
Global $g_bChkClanGamesGroundTroop = 0
Global $g_bChkClanGamesMiscellaneous = 0
Global $g_bChkClanGamesPurge = 0
Global $g_bChkClanGamesStopBeforeReachAndPurge = 0
Global $g_bChkClanGamesDebug = 0
Global $g_iPurgeMax = 5
Global $g_bChkCollectFreeMagicItems = True
Func GetTranslatedParsedText($sText, $var1 = Default, $var2 = Default, $var3 = Default)
Local $s = StringReplace(StringReplace($sText, "\r\n", @CRLF), "\n", @CRLF)
If $var1 = Default Then Return $s
If $var2 = Default Then Return StringFormat($sText, $var1)
If $var3 = Default Then Return StringFormat($sText, $var1, $var2)
Return StringFormat($sText, $var1, $var2, $var3)
EndFunc
Func GetTranslatedFileIni($iSection = -1, $iKey = -1, $sText = "", $var1 = Default, $var2 = Default, $var3 = Default)
Static $aNewLanguage[1][2]
$sText = StringReplace($sText, @CRLF, "\r\n")
Local $sDefaultText, $g_sLanguageText
Local $SearchInLanguage = $iSection & "§" & $iKey
Local $result = _ArraySearch($aNewLanguage, $SearchInLanguage, 0, 0, 0, 0, 0)
If $result <> -1 Then
Return GetTranslatedParsedText($aNewLanguage[$result][1], $var1, $var2, $var3)
EndIf
If $g_sLanguage = $g_sDefaultLanguage Then
$sDefaultText = IniRead($g_sDirLanguages & $g_sDefaultLanguage & ".ini", $iSection, $iKey, "-3")
If $sText = "-1" Then
If $sDefaultText <> "-3" Then
$sDefaultText = GetTranslatedParsedText($sDefaultText, $var1, $var2, $var3)
Local $result = _ArraySearch($aNewLanguage, $SearchInLanguage, 0, 0, 0, 0, 0)
If $result <> -1 Then
$aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) - 1][0] = $SearchInLanguage
$aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) - 1][1] = $sDefaultText
ReDim $aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) + 1][2]
EndIf
Return $sDefaultText
Else
Return "-3"
EndIf
EndIf
If $sDefaultText <> $sText Then
Local $ini_file = $g_sDirLanguages & $g_sDefaultLanguage & ".ini"
Local $aSection[1][2] = [[$iKey, $sText]]
Local $Count = 1
Local $aKey = IniReadSection($ini_file, $iSection)
If IsArray($aKey) Then
For $i = 1 To $aKey[0][0]
If _ArraySearch($aSection, $aKey[$i][0], 0, 0, 0, 0, 1, 0) = -1 Then
$Count += 1
ReDim $aSection[$Count][2]
$aSection[$Count - 1][0] = $aKey[$i][0]
$aSection[$Count - 1][1] = $aKey[$i][1]
EndIf
Next
EndIf
_ArraySort($aSection, 0, 0, 0, 0)
IniWriteSection($ini_file, $iSection, $aSection, 0)
$sText = GetTranslatedParsedText($sText, $var1, $var2, $var3)
Local $result = _ArraySearch($aNewLanguage, $SearchInLanguage, 0, 0, 0, 0, 0)
If $result <> -1 Then
$aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) - 1][0] = $SearchInLanguage
$aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) - 1][1] = $sText
ReDim $aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) + 1][2]
Else
EndIf
Return $sText
Else
$sDefaultText = GetTranslatedParsedText($sDefaultText, $var1, $var2, $var3)
Local $result = _ArraySearch($aNewLanguage, $SearchInLanguage, 0, 0, 0, 0, 0)
If $result <> -1 Then
$aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) - 1][0] = $SearchInLanguage
$aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) - 1][1] = $sDefaultText
ReDim $aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) + 1][2]
Else
EndIf
Return $sDefaultText
EndIf
Else
$g_sLanguageText = IniRead($g_sDirLanguages & $g_sLanguage & ".ini", $iSection, $iKey, "-3")
If $sText = "-1" Then
If $g_sLanguageText = "-3" Then
$sDefaultText = IniRead($g_sDirLanguages & $g_sDefaultLanguage & ".ini", $iSection, $iKey, $sText)
$sDefaultText = GetTranslatedParsedText($sDefaultText, $var1, $var2, $var3)
Local $result = _ArraySearch($aNewLanguage, $SearchInLanguage, 0, 0, 0, 0, 0)
If $result <> -1 Then
$aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) - 1][0] = $SearchInLanguage
$aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) - 1][1] = $sDefaultText
ReDim $aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) + 1][2]
Else
EndIf
Return $sDefaultText
Else
$g_sLanguageText = GetTranslatedParsedText($g_sLanguageText, $var1, $var2, $var3)
Local $result = _ArraySearch($aNewLanguage, $SearchInLanguage, 0, 0, 0, 0, 0)
If $result <> -1 Then
$aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) - 1][0] = $SearchInLanguage
$aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) - 1][1] = $g_sLanguageText
ReDim $aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) + 1][2]
Else
EndIf
Return $g_sLanguageText
EndIf
EndIf
If $g_sLanguageText = "-3" Then
Local $ini_file = $g_sDirLanguages & $g_sLanguage & ".ini"
Local $aSection[1][2] = [[$iKey, $sText]]
Local $Count = 1
Local $aKey = IniReadSection($ini_file, $iSection)
If IsArray($aKey) Then
For $i = 1 To $aKey[0][0]
If _ArraySearch($aSection, $aKey[$i][0], 0, 0, 0, 0, 1, 0) = -1 Then
$Count += 1
ReDim $aSection[$Count][2]
$aSection[$Count - 1][0] = $aKey[$i][0]
$aSection[$Count - 1][1] = $aKey[$i][1]
EndIf
Next
EndIf
_ArraySort($aSection, 0, 0, 0, 0)
IniWriteSection($ini_file, $iSection, $aSection, 0)
$sText = GetTranslatedParsedText($sText, $var1, $var2, $var3)
Local $result = _ArraySearch($aNewLanguage, $SearchInLanguage, 0, 0, 0, 0, 0)
If $result <> -1 Then
$aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) - 1][0] = $SearchInLanguage
$aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) - 1][1] = $sText
ReDim $aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) + 1][2]
Else
EndIf
Return $sText
EndIf
$g_sLanguageText = GetTranslatedParsedText($g_sLanguageText, $var1, $var2, $var3)
Local $result = _ArraySearch($aNewLanguage, $SearchInLanguage, 0, 0, 0, 0, 0)
If $result <> -1 Then
$aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) - 1][0] = $SearchInLanguage
$aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) - 1][1] = $g_sLanguageText
ReDim $aNewLanguage[UBound($aNewLanguage, $UBOUND_ROWS) + 1][2]
Else
EndIf
Return $g_sLanguageText
EndIf
EndFunc
Global Enum $g_eBotDetailsBotForm = 0, $g_eBotDetailsTimer, $g_eBotDetailsProfile, $g_eBotDetailsCommandLine, $g_eBotDetailsTitle, $g_eBotDetailsRunState, $g_eBotDetailsPaused, $g_eBotDetailsLaunched, $g_eBotDetailsVerifyCount, $g_eBotDetailsBotStateStruct, $g_eBotDetailsOptionalStruct, $g_eBotDetailsArraySize
Global $tagSTRUCT_BOT_STATE = "struct" & ";hwnd BotHWnd" & ";hwnd AndroidHWnd" & ";boolean RunState" & ";boolean Paused" & ";boolean Launched" & ";uint64 g_hTimerSinceStarted" & ";uint g_iTimePassed" & ";char Profile[64]" & ";char AndroidEmulator[32]" & ";char AndroidInstance[32]" & ";int StructType" & ";ptr StructPtr" & ";boolean RegisterInHost" & ";endstruct"
Global Enum $g_eSTRUCT_NONE = 0, $g_eSTRUCT_STATUS_BAR, $g_eSTRUCT_UPDATE_STATS
Global $tagSTRUCT_STATUS_BAR = "struct;char Text[255];endstruct"
Global $tagSTRUCT_UPDATE_STATS = "struct" & ";long g_aiCurrentLoot[" & UBound($g_aiCurrentLoot) & "]" & ";long g_iFreeBuilderCount" & ";long g_iTotalBuilderCount" & ";long g_iGemAmount" & ";long g_iStatsTotalGain[" & UBound($g_iStatsTotalGain) & "]" & ";long g_iStatsLastAttack[" & UBound($g_iStatsLastAttack) & "]" & ";long g_iStatsBonusLast[" & UBound($g_iStatsBonusLast) & "]" & ";int g_iFirstAttack" & ";int g_aiAttackedCount" & ";int g_iSkippedVillageCount" & ";endstruct"
Global $tBotState = DllStructCreate($tagSTRUCT_BOT_STATE)
Global $tStatusBar = DllStructCreate($tagSTRUCT_STATUS_BAR)
Global $tUpdateStats = DllStructCreate($tagSTRUCT_UPDATE_STATS)
Global $API_VERSION = "1.1"
Global $WM_MYBOTRUN_API = _WinAPI_RegisterWindowMessage("MyBot.run/API/" & $API_VERSION)
SetDebugLog("MyBot.run/API/1.1 Message ID = " & $WM_MYBOTRUN_API)
Global $WM_MYBOTRUN_STATE = _WinAPI_RegisterWindowMessage("MyBot.run/STATE/" & $API_VERSION)
SetDebugLog("MyBot.run/STATE/1.1 Message ID = " & $WM_MYBOTRUN_STATE)
Func _DllStructLoadData(ByRef $Struct, $Element, ByRef $value)
If IsArray($value) Then
For $i = 0 To UBound($value) - 1
$value[$i] = DllStructGetData($Struct, $Element, $i + 1)
Next
Return 1
Else
$value = DllStructGetData($Struct, $Element)
Return 0
EndIf
EndFunc
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
Func ClearManagedMyBotDetails()
ReDim $g_ahManagedMyBotDetails[0]
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
Func AcquireMutex($mutexName, $scope = Default, $timeout = Default, $sWaitMessage = "", $bUse_Sleep = False)
Local $timer = __TimerInit()
If $sWaitMessage = Default Then $sWaitMessage = "Waiting for mutex " & $mutexName & " to become available..."
Local $iDelay = $DELAYSLEEP
If $sWaitMessage Then $iDelay = 1000
Local $g_hMutex_MyBot = 0
If $scope = Default Then
$scope = @AutoItPID & "/"
ElseIf $scope <> "" Then
$scope &= "/"
EndIf
If $timeout = Default Then $timeout = 30000
Local $bLogged = False
While $g_hMutex_MyBot = 0 And($timeout < 1 Or __TimerDiff($timer) < $timeout)
$g_hMutex_MyBot = CreateMutex("MyBot.run/" & $scope & $mutexName)
If $g_hMutex_MyBot <> 0 Then ExitLoop
If $timeout = 0 Then ExitLoop
If $sWaitMessage Then
If $bLogged = False Then
$bLogged = True
SetLog($sWaitMessage)
EndIf
_GUICtrlStatusBar_SetTextEx($g_hStatusBar, $sWaitMessage)
EndIf
If $bUse_Sleep Then
_Sleep($iDelay)
Else
Sleep($iDelay)
EndIf
WEnd
If $g_hMutex_MyBot Then
EndIf
Return $g_hMutex_MyBot
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
Func AcquireMutexTicket($sMutexName, $iMinTicketNo, $sWaitMessage = Default, $bCheckRunState = True)
Local $hTicketMutex = 0
Local $sTicketMutex = 0
Local $iTicket = 256
For $i = 1 To 255
If $bCheckRunState = True And $g_bRunState = False Then Return 0
$sTicketMutex = $sMutexName & "." & $i
$hTicketMutex = AcquireMutex($sTicketMutex, "Global", 0)
If $hTicketMutex Then
$iTicket = $i
ExitLoop
EndIf
Next
If $hTicketMutex = 0 Then
SetLog("Could not aquire mutex ticker for: " & $sMutexName, $COLOR_RED)
Return 0
EndIf
If $iTicket <= $iMinTicketNo Then
SetDebugLog("Aquired mutex ticket: " & $sTicketMutex & ", " & $hTicketMutex)
Return $hTicketMutex
EndIf
SetDebugLog("Wait mutex ticket: " & $sTicketMutex)
If $sWaitMessage = Default Then $sWaitMessage = "Waiting for slot to become available..."
Local $iDelay = $DELAYSLEEP
If $sWaitMessage Then $iDelay = 1000
Local $bLogged = False
While $bCheckRunState = False Or $g_bRunState = True
If $iTicket = $iMinTicketNo + 1 Then
For $i = 1 To $iMinTicketNo
$sTicketMutex = $sMutexName & "." & $i
Local $hFinalTicketMutex = AcquireMutex($sTicketMutex, "Global", 0)
If $hFinalTicketMutex Then
SetDebugLog("Aquired mutex ticket: " & $sTicketMutex & ", " & $hFinalTicketMutex)
Return ReleaseMutex($hTicketMutex, $hFinalTicketMutex)
EndIf
Next
Else
$sTicketMutex = $sMutexName & "." &($iTicket - 1)
Local $hNextTicketMutex = AcquireMutex($sTicketMutex, "Global", 0)
If $hNextTicketMutex Then
SetDebugLog("New mutex ticket: " & $sTicketMutex)
$iTicket -= 1
$hTicketMutex = ReleaseMutex($hTicketMutex, $hNextTicketMutex)
EndIf
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
Return ReleaseMutex($hTicketMutex, 0)
EndFunc
Func LockBotSlot($bLock = True)
If $g_bBotLaunchOption_NoBotSlot = True Then Return False
Static $bBotIsLocked = False
If $bLock = Default Then Return $bBotIsLocked
If $bLock = $bBotIsLocked Then Return $bBotIsLocked
Local $bWasLocked = $bBotIsLocked
If $bLock = True And $g_bRunState = True Then
If $g_hMutextOrSemaphoreGlobalActiveBots Then
SetDebugLog("LockBotSlot not released: " & $g_hMutextOrSemaphoreGlobalActiveBots)
ReleaseMutex($g_hMutextOrSemaphoreGlobalActiveBots)
$g_hMutextOrSemaphoreGlobalActiveBots = 0
EndIf
$g_hMutextOrSemaphoreGlobalActiveBots = AcquireMutexTicket("ActiveBot", $g_iGlobalActiveBotsAllowed, GetTranslatedFileIni("MBR GUI Design - Loading", "SplashStep_09", "Waiting for bot slot..."))
If $g_hMutextOrSemaphoreGlobalActiveBots Then $bBotIsLocked = $bLock
ElseIf $bLock = False Then
ReleaseMutex($g_hMutextOrSemaphoreGlobalActiveBots)
SetDebugLog("Released Bot slot mutex: " & $g_hMutextOrSemaphoreGlobalActiveBots)
$g_hMutextOrSemaphoreGlobalActiveBots = 0
$bBotIsLocked = $bLock
EndIf
Return $bWasLocked
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
Func WinMove2($WinTitle, $WinText, $x = -1, $y = -1, $w = -1, $h = -1, $hAfter = 0, $iFlags = 0, $bCheckAfterPos = True, $bIconCheck = True)
If $WinTitle = $g_hFrmBot And $g_iGuiMode = 0 Then Return $WinTitle
Local $hWin = WinGetHandle($WinTitle, $WinText)
If @error Then Return 0
If $bIconCheck And _WinAPI_IsIconic($hWin) Then
SetDebugLog("Window " & $WinTitle &(($WinTitle <> $hWin) ? "(" & $hWin & ")" : "") & " restored", $COLOR_ACTION)
WinSetState($hWin, "", @SW_RESTORE)
EndIf
Local $NoMove = $x = -1 And $y = -1
Local $NoResize = $w = -1 And $h = -1
Local $NOZORDER =($hAfter = 0 ? BitOR($SWP_NOZORDER, $SWP_NOOWNERZORDER) : 0)
$bCheckAfterPos = $bCheckAfterPos And(Not $NoMove Or Not $NoResize)
If Not $NoMove Or Not $NoResize Then
Local $aPos = WinGetPos($hWin)
If @error <> 0 Or Not IsArray($aPos) Then
SetError(1, @extended, -1)
Return 0
EndIf
Local $aPPos = WinGetClientPos(__WinAPI_GetParent($hWin))
If IsArray($aPPos) Then
$aPos[0] -= $aPPos[0]
$aPos[1] -= $aPPos[1]
EndIf
If $x = -1 Or $y = -1 Or $w = -1 Or $h = -1 Then
If $x = -1 Then $x = $aPos[0]
If $y = -1 Then $y = $aPos[1]
If $w = -1 Then $w = $aPos[2]
If $h = -1 Then $h = $aPos[3]
EndIf
$NoMove = $NoMove Or($x = $aPos[0] And $y = $aPos[1])
$NoResize = $NoResize Or($w = $aPos[2] And $h = $aPos[3])
EndIf
If $g_bWinMove2_Compatible And $NoResize = False Then
WinMove($WinTitle, $WinText, $x, $y, $w, $h)
_WinAPI_SetWindowPos($hWin, $hAfter, 0, 0, 0, 0, BitOR($SWP_NOSIZE, $SWP_NOMOVE, $SWP_NOREPOSITION, $SWP_NOACTIVATE, $SWP_NOSENDCHANGING, $NOZORDER, $iFlags))
Else
_WinAPI_SetWindowPos($hWin, $hAfter, $x, $y, $w, $h, BitOR(($NoMove ? BitOR($SWP_NOMOVE, $SWP_NOREPOSITION) : 0),($NoResize ? $SWP_NOSIZE : 0), $SWP_NOACTIVATE, $SWP_NOSENDCHANGING, $NOZORDER, $iFlags))
EndIf
If $bCheckAfterPos Then
$aPos = WinGetPos($hWin)
If @error <> 0 Or Not IsArray($aPos) Then
SetError(1, @extended, -1)
Return 0
EndIf
Local $aPPos = WinGetClientPos(__WinAPI_GetParent($hWin))
If IsArray($aPPos) Then
$aPos[0] -= $aPPos[0]
$aPos[1] -= $aPPos[1]
EndIf
If $x <> $aPos[0] Or $y <> $aPos[1] Or $w <> $aPos[2] Or $h <> $aPos[3] Then
SetDebugLog("Window " & $WinTitle &(($WinTitle <> $hWin) ? "(" & $hWin & ")" : "") & " got resized/moved again to " & $aPos[0] & "/" & $aPos[1] & " " & $aPos[2] & "x" & $aPos[3] & ", restore now " & $x & "/" & $y & " " & $w & "x" & $h, $COLOR_ACTION)
WinMove($hWin, "", $x, $y, $w, $h - 1)
If $g_bWinMove2_Compatible Then
WinMove($hWin, "", $x, $y, $w, $h)
_WinAPI_SetWindowPos($hWin, $hAfter, 0, 0, 0, 0, BitOR($SWP_NOSIZE, $SWP_NOMOVE, $SWP_NOREPOSITION, $SWP_NOACTIVATE, $SWP_NOSENDCHANGING, $NOZORDER, $iFlags))
Else
_WinAPI_SetWindowPos($hWin, $hAfter, $x, $y, $w, $h, BitOR($SWP_NOMOVE, $SWP_NOREPOSITION, $SWP_NOACTIVATE, $SWP_NOSENDCHANGING, $NOZORDER, $iFlags))
EndIf
EndIf
EndIf
Return $hWin
EndFunc
Func WinGetClientPos($hWin, $x = 0, $y = 0)
Local $tPoint = DllStructCreate("int x;int y")
DllStructSetData($tPoint, "x", $x)
DllStructSetData($tPoint, "y", $y)
_WinAPI_ClientToScreen($hWin, $tPoint)
If @error Then Return SetError(1, 0, 0)
Local $a[2] = [DllStructGetData($tPoint, "x"), DllStructGetData($tPoint, "y")]
$tPoint = 0
Return $a
EndFunc
Func __WinAPI_GetParent($hWin, $iMillis = 3000)
If $hWin = 0 Then Return 0
Local $hTimer = __TimerInit()
Local $bPostSomething = True
Local $hWinParent = 0
Do
$hWinParent = _WinAPI_GetParent($hWin)
If IsPtr($hWinParent) = 0 Then
If $bPostSomething And __TimerDiff($hTimer) > $iMillis / 2 Then
$bPostSomething = False
EndIf
Sleep(10)
EndIf
Until IsPtr($hWinParent) = 1 Or __TimerDiff($hTimer) > $iMillis
Return $hWinParent
EndFunc
Func _CheckWindowVisibility(Const $hWnd, ByRef $p)
If $p[0] < -30000 And $p[1] < -30000 Then Return False
Local $monitorHandle = _MonitorFromWindow($hWnd, 0)
If $monitorHandle <> 0 Then
Return False
EndIf
$monitorHandle = _MonitorFromWindow($hWnd, 2)
Local $monitorInfo = _MonitorGetInfo($monitorHandle)
If UBound($monitorInfo) > 1 Then
$p[0] = $monitorInfo[0]
$p[1] = $monitorInfo[1]
EndIf
Return True
EndFunc
Func _GraphicsCreateDC($sDriver="DISPLAY",$sDevice=0,$pInitData=0)
If Not IsString($sDriver) Then Return SetError(1,0,False)
Local $aRet,$sDeviceType
If $sDevice="" Or Not IsString($sDevice) Then
$sDeviceType="ptr"
$sDevice=0
Else
$sDeviceType="wstr"
EndIf
$aRet=DllCall('gdi32.dll',"handle","CreateDCW","wstr",$sDriver,$sDeviceType,$sDevice,"ptr",0,"ptr",$pInitData)
If @error Then Return SetError(2,@error,0)
If $aRet[0]=0 Then Return SetError(3,0,0)
Return $aRet[0]
EndFunc
Func _MonitorGetInfo($hMonitor,$hMonitorDC=0)
If Not IsPtr($hMonitor) Or $hMonitor=0 Then Return SetError(1,0,'')
Local $aRet, $stMonInfoEx=DllStructCreate('dword;long[8];dword;wchar[32]'), $bMonDCCreated=0
DllStructSetData($stMonInfoEx,1,DllStructGetSize($stMonInfoEx))
$aRet=DllCall('user32.dll','bool','GetMonitorInfoW','handle',$hMonitor,'ptr',DllStructGetPtr($stMonInfoEx))
If @error Then
$stMonInfoEx = 0
Return SetError(2,0,'')
EndIf
If Not $aRet[0] Then
$stMonInfoEx = 0
Return SetError(3,0,'')
EndIf
Dim $aRet[12]
For $i=0 To 7
$aRet[$i]=DllStructGetData($stMonInfoEx,2,$i+1)
Next
$aRet[8]=DllStructGetData($stMonInfoEx,3)
$aRet[9]=DllStructGetData($stMonInfoEx,4)
If $hMonitorDC=0 Then
$hMonitorDC=_GraphicsCreateDC($aRet[9],$aRet[9])
$bMonDCCreated=1
EndIf
$aRet[10]=_WinAPI_GetDeviceCaps($hMonitorDC,12)
$aRet[11]=_WinAPI_GetDeviceCaps($hMonitorDC,116)
If $bMonDCCreated Then _WinAPI_DeleteDC($hMonitorDC)
$stMonInfoEx = 0
Return $aRet
EndFunc
Func _MonitorFromWindow($hWnd, $iFlags=2)
If Not IsHWnd($hWnd) Or $iFlags<0 Or $iFlags>2 Then Return SetError(1,0,0)
Local $aRet=DllCall('user32.dll', 'handle', 'MonitorFromWindow', 'hwnd', $hWnd, 'dword', $iFlags)
If @error Then Return SetError(2,@error,0)
If $aRet[0]=0 Then Return SetError(3,0,0)
Return $aRet[0]
EndFunc
Global Const $tag_IShellLinkW = "GetPath hresult(long;long;long;long);" & "GetIDList hresult(long);" & "SetIDList hresult(long);" & "GetDescription hresult(long;long);" & "SetDescription hresult(wstr);" & "GetWorkingDirectory hresult(long;long);" & "SetWorkingDirectory hresult(long;long);" & "GetArguments hresult(long;long);" & "SetArguments hresult(ptr);" & "GetHotkey hresult(long);" & "SetHotkey hresult(word);" & "GetShowCmd hresult(long);" & "SetShowCmd hresult(int);" & "GetIconLocation hresult(long;long;long);" & "SetIconLocation hresult(wstr;int);" & "SetRelativePath hresult(long;long);" & "Resolve hresult(long;long);" & "SetPath hresult(wstr);"
Global Const $tag_IPersist = "GetClassID hresult(long);"
Global Const $tag_IPersistFile = $tag_IPersist & "IsDirty hresult();" & "Load hresult(wstr;dword);" & "Save hresult(wstr;bool);" & "SaveCompleted hresult(long);" & "GetCurFile hresult(long);"
Global Const $tagPROPERTYKEY = 'struct;ulong Data1;ushort Data2;ushort Data3;byte Data4[8];DWORD pid;endstruct'
Global $tagPROPVARIANT = 'USHORT vt;' & 'WORD wReserved1;' & 'WORD wReserved2;' & 'WORD wReserved3;' & 'LONG;PTR'
Global Const $sIID_IPropertyStore = '{886D8EEB-8CF2-4446-8D02-CDBA1DBDCF99}'
Global Const $VT_EMPTY = 0, $VT_LPWSTR = 31
Func _WindowAppId($hWnd, $appid = Default)
Local $tpIPropertyStore = DllStructCreate('ptr')
_WinAPI_SHGetPropertyStoreForWindow($hWnd, $sIID_IPropertyStore, $tpIPropertyStore)
Local $pPropertyStore = DllStructGetData($tpIPropertyStore, 1)
$tpIPropertyStore = 0
Local $oPropertyStore = ObjCreateInterface($pPropertyStore, $sIID_IPropertyStore, 'GetCount HRESULT(PTR);GetAt HRESULT(DWORD; PTR);GetValue HRESULT(PTR;PTR);' & 'SetValue HRESULT(PTR;PTR);Commit HRESULT()')
If Not IsObj($oPropertyStore) Then Return SetError(1, 0, '')
Local $tPKEY = _PKEY_AppUserModel_ID()
Local $tPROPVARIANT = DllStructCreate($tagPROPVARIANT)
Local $sAppId
If $appid = Default Then
$oPropertyStore.GetValue(DllStructGetPtr($tPKEY), DllStructGetPtr($tPROPVARIANT))
If DllStructGetData($tPROPVARIANT, 'vt') <> $VT_EMPTY Then
Local $buf = DllStructCreate('wchar[128]')
DllCall('Propsys.dll', 'long', 'PropVariantToString', 'ptr', DllStructGetPtr($tPROPVARIANT), 'ptr', DllStructGetPtr($buf), 'uint', DllStructGetSize($buf))
If Not @error Then
$sAppId = DllStructGetData($buf, 1)
EndIf
$buf = 0
EndIf
Else
_WinAPI_InitPropVariantFromString($appid, $tPROPVARIANT)
$oPropertyStore.SetValue(DllStructGetPtr($tPKEY), DllStructGetPtr($tPROPVARIANT))
$oPropertyStore.Commit()
$sAppId = $appid
EndIf
$tPROPVARIANT = 0
$tPKEY = 0
Return SetError(($sAppId == '') * 2, 0, $sAppId)
EndFunc
Func _WinAPI_InitPropVariantFromString($sUnicodeString, ByRef $tPROPVARIANT)
DllStructSetData($tPROPVARIANT, 'vt', $VT_LPWSTR)
Local $aRet = DllCall('Shlwapi.dll', 'LONG', 'SHStrDupW', 'WSTR', $sUnicodeString, 'PTR', DllStructGetPtr($tPROPVARIANT) + 8)
If @error Then Return SetError(@error, @extended, False)
Local $bSuccess = $aRet[0] == 0
If(Not $bSuccess) Then $tPROPVARIANT = DllStructCreate($tagPROPVARIANT)
Return SetExtended($aRet[0], $bSuccess)
EndFunc
Func _PKEY_AppUserModel_ID()
Local $tPKEY = DllStructCreate($tagPROPERTYKEY)
_WinAPI_GUIDFromStringEx('{9F4C2855-9F79-4B39-A8D0-E1D42DE1D5F3}', DllStructGetPtr($tPKEY))
DllStructSetData($tPKEY, 'pid', 5)
Return $tPKEY
EndFunc
Func _WinAPI_SHGetPropertyStoreForWindow($hWnd, $sIID, ByRef $tPointer)
Local $tIID = _WinAPI_GUIDFromString($sIID)
Local $pp = IsPtr($tPointer) ? $tPointer : DllStructGetPtr($tPointer)
Local $aRet = DllCall('Shell32.dll', 'LONG', 'SHGetPropertyStoreForWindow', 'HWND', $hWnd, 'STRUCT*', $tIID, 'PTR', $pp)
If @error Then Return SetError(@error, @extended, False)
Return SetExtended($aRet[0],($aRet[0] = 0))
EndFunc
Global $g_hToolTip = 0
Func _GUICtrlSetTip($controlID, $tiptext, $title = Default, $icon = Default, $options = Default, $useControlID = True)
If $g_hToolTip = 0 Then
SetDebugLog("_GUICtrlSetTip: Missing $hToolTip! $controlID=" & $controlID, $COLOR_ERROR)
Return False
EndIf
Local $hCtrl =($useControlID = True ? GUICtrlGetHandle($controlID) : $controlID)
Return _GUIToolTip_AddTool($g_hToolTip, 0, $tiptext, $hCtrl)
EndFunc
Func _GUICtrlCreatePic($sFilename_or_hBitmap, $iLeft, $iTop, $iWidth = -1, $iHeight = -1, $iStyle = -1, $iExStyle = -1)
Local $idPic = GUICtrlCreatePic("", $iLeft, $iTop, $iWidth, $iHeight, $iStyle, $iExStyle)
Local $hBMP
If IsPtr($sFilename_or_hBitmap) Then
$hBMP = $sFilename_or_hBitmap
Else
$hBMP = _GDIPlus_BitmapCreateFromFile($sFilename_or_hBitmap)
EndIf
Local $iBmpWidth = _GDIPlus_ImageGetWidth($hBMP)
Local $iBmpHeight = _GDIPlus_ImageGetHeight($hBMP)
Local $g_hBitmap_Resized = 0
Local $hBMP_Ctxt = 0
If $iWidth = -1 Then $iWidth = $iBmpWidth
If $iHeight = -1 Then $iHeight = $iBmpHeight
If $iWidth <> $iBmpWidth Or $iHeight <> $iBmpHeight Then
$g_hBitmap_Resized = _GDIPlus_BitmapCreateFromScan0($iWidth, $iHeight)
$hBMP_Ctxt = _GDIPlus_ImageGetGraphicsContext($g_hBitmap_Resized)
_GDIPlus_GraphicsSetInterpolationMode($hBMP_Ctxt, $GDIP_INTERPOLATIONMODE_HIGHQUALITYBICUBIC)
_GDIPlus_GraphicsDrawImageRect($hBMP_Ctxt, $hBMP, 0, 0, $iWidth, $iHeight)
EndIf
Local $hHBMP = _GDIPlus_BitmapCreateDIBFromBitmap(($g_hBitmap_Resized ? $g_hBitmap_Resized : $hBMP))
Local $hPrevImage = GUICtrlSendMsg($idPic, $STM_SETIMAGE, 0, $hHBMP)
_WinAPI_DeleteObject($hPrevImage)
If IsPtr($sFilename_or_hBitmap) = 0 Then _GDIPlus_BitmapDispose($hBMP)
If $g_hBitmap_Resized Then _GDIPlus_BitmapDispose($g_hBitmap_Resized)
If $hBMP_Ctxt Then _GDIPlus_GraphicsDispose($hBMP_Ctxt)
_WinAPI_DeleteObject($hHBMP)
Return $idPic
EndFunc
Global $_GUI_MAIN_WIDTH = 472
Global $_GUI_MAIN_HEIGHT = 692
Global Const $_MINIGUI_MAIN_WIDTH = 472
Global Const $_MINIGUI_MAIN_HEIGHT = 220
Global $_GUI_MAIN_TOP = 23
Global $_GUI_MAIN_BUTTON_SIZE = [25, 17]
Global $_GUI_MAIN_BUTTON_COUNT = 3
Global $_GUI_CHILD_TOP = 110 + $_GUI_MAIN_TOP
Global Const $_GUI_BOTTOM_HEIGHT = 135
Global Const $g_bBtnColor = False
Global $g_iBotDesignFlags = 3
Global $g_bCustomTitleBarActive = Default
Global $g_hFrmBotButtons, $g_hFrmBotLogoUrlSmall, $g_hFrmBotEx = 0, $g_hLblBotTitle, $g_hLblBotShrink = 0, $g_hLblBotExpand = 0, $g_hLblBotMinimize = 0, $g_hLblBotClose = 0, $g_hFrmBotBottom = 0
Global $g_hFrmBotEmbeddedShield = 0, $g_hFrmBotEmbeddedShieldInput = 0, $g_hFrmBotEmbeddedGraphics = 0
Global $g_hFrmBot_MAIN_PIC = 0, $g_hFrmBot_URL_PIC = 0, $g_hFrmBot_URL_PIC2 = 0
Global $g_hStatusBar = 0
Global $g_hTiShow = 0, $g_hTiHide = 0, $g_hTiDonate = 0, $g_hTiAbout = 0, $g_hTiStartStop = 0, $g_hTiPause = 0, $g_hTiExit = 0
Global $g_aFrmBotPosInit[8] = [0, 0, 0, 0, 0, 0, 0, 0]
Global $g_bFrmBotMinimized = False
Global $g_oCtrlIconData = ObjCreate("Scripting.Dictionary")
Global $g_hBtnStart = 0, $g_hBtnStop = 0, $g_hBtnPause = 0, $g_hBtnResume = 0, $g_hBtnSearchMode = 0, $g_hBtnMakeScreenshot = 0, $g_hBtnHide = 0, $g_hBtnEmbed = 0, $g_hChkBackgroundMode = 0, $g_hLblDonate = 0, $g_hBtnAttackNowDB = 0, $g_hBtnAttackNowLB = 0, $g_hBtnAttackNowTS = 0
Global $g_hPicTwoArrowShield = 0, $g_hLblVersion = 0, $g_hPicArrowLeft = 0, $g_hPicArrowRight = 0
Global $g_hGrpVillage = 0
Global $g_hLblResultGoldNow = 0, $g_hLblResultGoldHourNow = 0, $g_hPicResultGoldNow = 0, $g_hPicResultGoldTemp = 0
Global $g_hLblResultElixirNow = 0, $g_hLblResultElixirHourNow = 0, $g_hPicResultElixirNow = 0, $g_hPicResultElixirTemp = 0
Global $g_hLblResultDENow = 0, $g_hLblResultDEHourNow = 0, $g_hPicResultDENow = 0, $g_hPicResultDETemp = 0
Global $g_hLblResultTrophyNow = 0, $g_hPicResultTrophyNow = 0, $g_hLblResultRuntimeNow = 0, $g_hPicResultRuntimeNow = 0, $g_hLblResultBuilderNow = 0, $g_hPicResultBuilderNow = 0
Global $g_hLblResultAttackedHourNow = 0, $g_hPicResultAttackedHourNow = 0, $g_hLblResultGemNow = 0, $g_hPicResultGemNow = 0, $g_hLblResultSkippedHourNow = 0, $g_hPicResultSkippedHourNow = 0
Global $g_hLblVillageReportTemp = 0
Global $g_hlblKing = 0, $g_hPicKingGray = 0, $g_hPicKingBlue = 0, $g_hPicKingRed = 0, $g_hPicKingGreen = 0
Global $g_hlblQueen = 0, $g_hPicQueenGray = 0, $g_hPicQueenBlue = 0, $g_hPicQueenRed = 0, $g_hPicQueenGreen = 0
Global $g_hlblWarden = 0, $g_hPicWardenGray = 0, $g_hPicWardenBlue = 0, $g_hPicWardenRed = 0, $g_hPicWardenGreen = 0
Global $g_hlblLab = 0, $g_hPicLabGray = 0, $g_hPicLabRed = 0, $g_hPicLabGreen = 0
Func CreateBottomPanel()
Local $sTxtTip = ""
Local $y_bottom = 0
Local $x = 10, $y = $y_bottom + 10
GUICtrlCreateGroup("https://mybot.run " & GetTranslatedFileIni("MBR GUI Design Bottom", "Group_01", "- freeware bot -"), $x - 5, $y - 10, 190, 108)
$g_hBtnStart = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Bottom", "BtnStart", "Start Bot"), $x, $y + 2 +5, 90, 40-5)
_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Bottom", "BtnStart_Info_01", "Use this to START the bot."))
GUICtrlSetOnEvent(-1, "btnStart")
If $g_bBtnColor then GUICtrlSetBkColor(-1, 0x5CAD85)
GUICtrlSetState(-1, $GUI_DISABLE)
$g_hBtnStop = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Bottom", "BtnStop", "Stop Bot"), -1, -1, 90, 40-5)
_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Bottom", "BtnStop_Info_01", "Use this to STOP the bot (or ESC key)."))
If $g_bBtnColor then GUICtrlSetBkColor(-1, 0xDB4D4D)
GUICtrlSetState(-1, $GUI_HIDE)
$g_hBtnPause = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Bottom", "BtnPause", "Pause"), $x + 90, -1, 90, 40-5)
_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Bottom", "BtnPause_Info_01", "Use this to PAUSE all actions of the bot until you Resume (or Pause/Break key)."))
If $g_bBtnColor then GUICtrlSetBkColor(-1, 0xFFA500)
GUICtrlSetState(-1, $GUI_HIDE)
$g_hBtnResume = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Bottom", "BtnResume", "Resume"), -1, -1, 90, 40-5)
_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Bottom", "BtnResume_Info_01", "Use this to RESUME a paused Bot (or Pause/Break key)."))
If $g_bBtnColor then GUICtrlSetBkColor(-1, 0xFFA500)
GUICtrlSetState(-1, $GUI_HIDE)
$g_hBtnSearchMode = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Bottom", "BtnSearchMode", "Search Mode"), -1, -1, 90, 40-5)
_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Bottom", "BtnSearchMode_Info_01", "Does not attack. Searches for a Village that meets conditions."))
GUICtrlSetOnEvent(-1, "btnSearchMode")
If $g_bBtnColor then GUICtrlSetBkColor(-1, 0xFFA500)
GUICtrlSetState(-1, $GUI_DISABLE)
$g_hBtnMakeScreenshot = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Bottom", "BtnMakeScreenshot", "Photo"), $x , $y + 45, 40, -1)
_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Bottom", "BtnMakeScreenshot_Info_01", "Click here to take a snaphot of your village and save it to a file."))
If $g_bBtnColor then GUICtrlSetBkColor(-1, 0x5CAD85)
$g_hBtnHide = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Bottom", "BtnHide", "Hide"), $x + 40, $y + 45, 50, -1)
_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Bottom", "BtnHide_Info_01", "Use this to move the Android Window out of sight.") & @CRLF & GetTranslatedFileIni("MBR GUI Design Bottom", "BtnHide_Info_02", "(Not minimized, but hidden)"))
If $g_bBtnColor Then GUICtrlSetBkColor(-1, 0x22C4F5)
GUICtrlSetState(-1, $GUI_DISABLE)
$g_hBtnEmbed = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Bottom", "BtnEmbed", "Dock"), $x + 90, $y + 45, 90, -1)
_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Bottom", "BtnEmbed_Info_01", "Use this to embed the Android Window into Bot."))
If $g_bBtnColor Then GUICtrlSetBkColor(-1, 0x22C4F5)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetOnEvent(-1, "btnEmbed")
$g_hChkBackgroundMode = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Bottom", "ChkBackgroundMode", "Background Mode"), $x + 1, $y + 72, 115, 24)
GUICtrlSetFont(-1, 7)
_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Bottom", "ChkBackgroundMode_Info_01", "Check this to ENABLE the Background Mode of the Bot.") & @CRLF & GetTranslatedFileIni("MBR GUI Design Bottom", "ChkBackgroundMode_Info_02", "With this you can also hide the Android Emulator window out of sight."))
If $g_bGuiRemote Then GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetOnEvent(-1, "chkBackground")
GUICtrlSetState(-1,(($g_bAndroidAdbScreencap = True) ?($GUI_CHECKED) :($GUI_UNCHECKED)))
$g_hLblVersion = GUICtrlCreateLabel($g_sBotVersion, $x + 120, $y + 77, 60, 17, $SS_LEFT )
GUICtrlSetColor(-1, $COLOR_MEDGRAY)
$g_hBtnAttackNowDB = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Bottom", "BtnAttackNowDB", "DB Attack!"), $x + 190, $y - 4, 60, -1)
GUICtrlSetState(-1, $GUI_HIDE)
$g_hBtnAttackNowLB = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Bottom", "BtnAttackNowLB", "LB Attack!"), $x + 190, $y + 23, 60, -1)
GUICtrlSetState(-1, $GUI_HIDE)
$g_hBtnAttackNowTS = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Bottom", "BtnAttackNowTS", "TH Snipe!"), $x + 190, $y + 50, 60, -1)
GUICtrlSetState(-1, $GUI_HIDE)
$g_hLblDonate = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Bottom", "LblDonate", "Support the development"), $x + 224, $y + 80, 220, 24, $SS_RIGHT)
GUICtrlSetCursor(-1, 0)
GUICtrlSetFont(-1, 8.5, $FW_BOLD)
_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Bottom", "LblDonate_Info_01", "Paypal Donate?"))
GUICtrlCreateGroup("", -99, -99, 1, 1)
If $g_bAndroidAdbScreencap Then chkBackground()
$g_hPicArrowLeft = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnArrowLeft, $x + 269, $y + 30, 16, 16)
$sTxtTip = GetTranslatedFileIni("MBR GUI Design Bottom", "GrpVillage_Info_01", "Switch between village info and stats")
_GUICtrlSetTip(-1, $sTxtTip)
$g_hPicArrowRight = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnArrowRight, $x + 247 + 198, $y + 30, 16, 16)
_GUICtrlSetTip(-1, $sTxtTip)
GUICtrlSetState(-1, $GUI_SHOW)
Local $x = 202, $y = $y_bottom + 5
$sTxtTip = "Gray - Not Read, Green - Ready to Use, Blue - Healing, Red - Upgrading"
$g_hlblKing = GUICtrlCreateLabel("King", $x, $y, 50, 16, $SS_LEFT)
_GUICtrlSetTip(-1, $sTxtTip)
$g_hPicKingGray = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGrayShield, $x + 53, $y, 16, 16)
_GUICtrlSetTip(-1, $sTxtTip)
$g_hPicKingBlue = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBlueShield, $x + 53, $y, 16, 16)
_GUICtrlSetTip(-1, $sTxtTip)
GUICtrlSetState(-1, $GUI_HIDE)
$g_hPicKingGreen = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGreenShield, $x + 53, $y, 16, 16)
_GUICtrlSetTip(-1, $sTxtTip)
GUICtrlSetState(-1, $GUI_HIDE)
$g_hPicKingRed = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnRedShield, $x + 53, $y, 16, 16)
_GUICtrlSetTip(-1, $sTxtTip)
GUICtrlSetState(-1, $GUI_HIDE)
$y += 25
$g_hlblQueen = GUICtrlCreateLabel("Queen", $x, $y, 50, 16, $SS_LEFT)
_GUICtrlSetTip(-1, $sTxtTip)
$g_hPicQueenGray = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGrayShield, $x + 53, $y, 16, 16 )
_GUICtrlSetTip(-1, $sTxtTip)
$g_hPicQueenBlue = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBlueShield, $x + 53, $y, 16, 16 )
_GUICtrlSetTip(-1, $sTxtTip)
GUICtrlSetState(-1, $GUI_HIDE)
$g_hPicQueenGreen = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGreenShield, $x + 53, $y, 16, 16 )
_GUICtrlSetTip(-1, $sTxtTip)
GUICtrlSetState(-1, $GUI_HIDE)
$g_hPicQueenRed = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnRedShield, $x + 53, $y, 16, 16 )
_GUICtrlSetTip(-1, $sTxtTip)
GUICtrlSetState(-1, $GUI_HIDE)
$y += 25
$g_hlblWarden = GUICtrlCreateLabel("Warden", $x, $y, 50, 16, $SS_LEFT)
_GUICtrlSetTip(-1, $sTxtTip)
$g_hPicWardenGray = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGrayShield, $x + 53 , $y, 16, 16 )
_GUICtrlSetTip(-1, $sTxtTip)
$g_hPicWardenBlue = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBlueShield, $x + 53, $y, 16, 16 )
_GUICtrlSetTip(-1, $sTxtTip)
GUICtrlSetState(-1, $GUI_HIDE)
$g_hPicWardenGreen = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGreenShield, $x + 53, $y, 16, 16 )
_GUICtrlSetTip(-1, $sTxtTip)
GUICtrlSetState(-1, $GUI_HIDE)
$g_hPicWardenRed = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnRedShield, $x + 53, $y, 16, 16 )
_GUICtrlSetTip(-1, $sTxtTip)
GUICtrlSetState(-1, $GUI_HIDE)
$y += 25
$sTxtTip = "Green - Lab is Running, Red - Lab Has Stopped"
$g_hlblLab = GUICtrlCreateLabel("Lab", $x, $y, 50, 16, $SS_LEFT)
_GUICtrlSetTip(-1, $sTxtTip)
$g_hPicLabGray = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGrayShield, $x + 53 , $y, 16, 16 )
_GUICtrlSetTip(-1, $sTxtTip)
$g_hPicLabGreen = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGreenShield, $x + 53, $y, 16, 16 )
_GUICtrlSetTip(-1, $sTxtTip)
GUICtrlSetState(-1, $GUI_HIDE)
$g_hPicLabRed = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnRedShield, $x + 53, $y, 16, 16 )
_GUICtrlSetTip(-1, $sTxtTip)
GUICtrlSetState(-1, $GUI_HIDE)
Local $x = 295, $y = $y_bottom + 20
$g_hGrpVillage = GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Bottom", "GrpVillage", "Village"), $x - 0, $y - 20, 160, 85)
$g_hLblResultGoldNow = GUICtrlCreateLabel("", $x + 10, $y + 2, 60, 15, $SS_RIGHT)
$g_hLblResultGoldHourNow = GUICtrlCreateLabel("", $x + 10, $y + 2, 60, 15, $SS_RIGHT)
GUICtrlSetState(-1, $GUI_HIDE)
$g_hPicResultGoldNow = GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 71, $y, 16, 16)
GUICtrlSetState(-1, $GUI_HIDE)
$g_hPicResultGoldTemp = GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 15, $y, 16, 16)
$g_hLblResultElixirNow = GUICtrlCreateLabel("", $x + 10, $y + 22, 60, 15, $SS_RIGHT)
$g_hLblResultElixirHourNow = GUICtrlCreateLabel("", $x + 10, $y + 22, 60, 15, $SS_RIGHT)
GUICtrlSetState(-1, $GUI_HIDE)
$g_hPicResultElixirNow = GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 71, $y + 20, 16, 16)
GUICtrlSetState(-1, $GUI_HIDE)
$g_hPicResultElixirTemp = GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 15, $y + 20, 16, 16)
$g_hLblResultDENow = GUICtrlCreateLabel("", $x + 10, $y + 42, 60, 15, $SS_RIGHT)
$g_hLblResultDEHourNow = GUICtrlCreateLabel("", $x, $y + 42, 60, 15, $SS_RIGHT)
GUICtrlSetState(-1, $GUI_HIDE)
$g_hPicResultDENow = GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 71, $y + 40, 16, 16)
GUICtrlSetState(-1, $GUI_HIDE)
$g_hPicResultDETemp = GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 15, $y + 40, 16, 16)
$x += 75
$g_hLblResultTrophyNow = GUICtrlCreateLabel("", $x + 13, $y + 2, 43, 15, $SS_RIGHT)
$g_hPicResultTrophyNow = GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 59, $y , 16, 16)
$g_hLblResultRuntimeNow = GUICtrlCreateLabel("00:00:00", $x + 13, $y + 2, 43, 15, $SS_RIGHT)
GUICtrlSetState(-1, $GUI_HIDE)
$g_hPicResultRuntimeNow = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnHourGlass, $x +57, $y, 16, 16)
GUICtrlSetState(-1, $GUI_HIDE)
$g_hLblResultBuilderNow = GUICtrlCreateLabel("", $x + 13, $y + 22, 43, 15, $SS_RIGHT)
$g_hPicResultBuilderNow = GUICtrlCreateIcon($g_sLibIconPath, $eIcnBuilder, $x + 59, $y + 20, 16, 16)
$g_hLblResultAttackedHourNow = GUICtrlCreateLabel("0", $x + 13, $y + 22, 43, 15, $SS_RIGHT)
GUICtrlSetState(-1, $GUI_HIDE)
$g_hPicResultAttackedHourNow = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgTarget, $x +59, $y + 20, 16, 16)
GUICtrlSetState(-1, $GUI_HIDE)
$g_hLblResultGemNow = GUICtrlCreateLabel("", $x + 13, $y + 42, 43, 15, $SS_RIGHT)
$g_hPicResultGemNow = GUICtrlCreateIcon($g_sLibIconPath, $eIcnGem, $x + 59, $y + 40, 16, 16)
$g_hLblResultSkippedHourNow = GUICtrlCreateLabel("0", $x + 13, $y + 42, 43, 15, $SS_RIGHT)
GUICtrlSetState(-1, $GUI_HIDE)
$g_hPicResultSkippedHourNow = GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgX, $x + 59, $y + 40, 16, 16)
GUICtrlSetState(-1, $GUI_HIDE)
$x = 335
$g_hLblVillageReportTemp = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Bottom", "LblVillageReportTemp_01", "Village Report") & @CRLF & GetTranslatedFileIni("MBR GUI Design Bottom", "LblVillageReportTemp_02", "will appear here") & @CRLF & GetTranslatedFileIni("MBR GUI Design Bottom", "LblVillageReportTemp_03", "on first run."), $x , $y + 5, 80, 45, BITOR($SS_CENTER, $BS_MULTILINE))
GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc
Func CreateMainGUI()
Local $iStyle = $WS_BORDER
If BitAND($g_iBotDesignFlags, 1) = 0 Then
$g_bCustomTitleBarActive = False
$iStyle = $WS_CAPTION
$_GUI_MAIN_TOP = 5
$_GUI_CHILD_TOP = 110 + $_GUI_MAIN_TOP
Else
$g_bCustomTitleBarActive = True
EndIf
If $g_iGuiMode = 2 Then
$_GUI_MAIN_WIDTH = $_MINIGUI_MAIN_WIDTH
$_GUI_MAIN_HEIGHT = $_MINIGUI_MAIN_HEIGHT
EndIf
$g_hFrmBot = GUICreate($g_sBotTitle, $_GUI_MAIN_WIDTH, $_GUI_MAIN_HEIGHT + $_GUI_MAIN_TOP,($g_iFrmBotPosX = $g_WIN_POS_DEFAULT ? -1 : $g_iFrmBotPosX),($g_iFrmBotPosY = $g_WIN_POS_DEFAULT ? -1 : $g_iFrmBotPosY), BitOR($WS_MINIMIZEBOX, $WS_POPUP, $WS_SYSMENU, $WS_CLIPCHILDREN, $WS_CLIPSIBLINGS, $iStyle))
If $g_iFrmBotPosX = $g_WIN_POS_DEFAULT Or $g_iFrmBotPosY = $g_WIN_POS_DEFAULT Then
Local $a = WinGetPos($g_hFrmBot)
If UBound($a) > 1 Then
$g_iFrmBotPosX = $a[0]
$g_iFrmBotPosY = $a[1]
Else
$g_iFrmBotPosX = 100
$g_iFrmBotPosY = 100
EndIf
EndIf
GUISetIcon($g_sLibIconPath, $eIcnGUI)
TraySetIcon($g_sLibIconPath, $eIcnGUI)
Opt("TrayMenuMode", 3)
Opt("TrayOnEventMode", 1)
Opt("TrayIconHide", 0)
UpdateBotTitle()
_WindowAppId($g_hFrmBot, "MyBot.run")
$g_hTiShow = TrayCreateItem(GetTranslatedFileIni("MBR GUI Design - Loading", "StatusBar_Item_01", "Show bot"))
TrayItemSetOnEvent(-1, "tiShow")
$g_hTiStartStop = TrayCreateItem(GetTranslatedFileIni("MBR GUI Design - Loading", "StatusBar_Item_Start", "Start bot"))
GetTranslatedFileIni("MBR GUI Design - Loading", "StatusBar_Item_Stop", "Stop bot")
TrayItemSetOnEvent(-1, "tiStartStop")
$g_hTiPause = TrayCreateItem(GetTranslatedFileIni("MBR GUI Design - Loading", "StatusBar_Item_Pause", "Pause bot"))
GetTranslatedFileIni("MBR GUI Design - Loading", "StatusBar_Item_Resume", "Resume bot")
TrayItemSetState($g_hTiPause, $TRAY_DISABLE)
TrayItemSetOnEvent(-1, "btnPause")
TrayCreateItem("")
$g_hTiHide = TrayCreateItem(GetTranslatedFileIni("MBR GUI Design - Loading", "StatusBar_Item_02", "Hide when minimized"))
TrayItemSetOnEvent(-1, "tiHide")
TrayCreateItem("")
$g_hTiDonate = TrayCreateItem(GetTranslatedFileIni("MBR GUI Design - Loading", "StatusBar_Item_03", "Support Development"))
TrayItemSetOnEvent(-1, "tiDonate")
$g_hTiAbout = TrayCreateItem(GetTranslatedFileIni("MBR GUI Design - Loading", "StatusBar_Item_04", "About"))
TrayItemSetOnEvent(-1, "tiAbout")
TrayCreateItem("")
$g_hTiExit = TrayCreateItem(GetTranslatedFileIni("MBR GUI Design - Loading", "StatusBar_Item_05", "Exit"))
TrayItemSetOnEvent(-1, "tiExit")
EndFunc
Func CreateMainGUIControls()
Local $aBtnSize = $_GUI_MAIN_BUTTON_SIZE
GUISwitch($g_hFrmBot)
Switch $g_iGuiMode
Case 0
Return
Case 2
$_GUI_MAIN_BUTTON_COUNT = 2
EndSwitch
If $g_bCustomTitleBarActive Then
$g_hFrmBotButtons = GUICreate("My Bot Title Buttons", $_GUI_MAIN_BUTTON_COUNT * $aBtnSize[0], $aBtnSize[1], $_GUI_MAIN_WIDTH - $aBtnSize[0] * $_GUI_MAIN_BUTTON_COUNT, 0, BitOR($WS_CHILD, $WS_TABSTOP), BitOR($WS_EX_TOOLWINDOW, $WS_EX_NOACTIVATE,($g_bAndroidShieldPreWin8 ? 0 : $WS_EX_LAYERED)), $g_hFrmBot)
WinSetTrans($g_hFrmBotButtons, "", 254)
EndIf
$g_hFrmBotEx = GUICreate("My Bot Controls", $_GUI_MAIN_WIDTH, $_GUI_MAIN_HEIGHT - $_GUI_BOTTOM_HEIGHT + $_GUI_MAIN_TOP, 0, 0, BitOR($WS_CHILD, $WS_TABSTOP), 0, $g_hFrmBot)
$g_hToolTip = _GUIToolTip_Create($g_hFrmBot)
_GUIToolTip_SetMaxTipWidth($g_hToolTip, $_GUI_MAIN_WIDTH)
If $g_bCustomTitleBarActive = False Then
GUICtrlCreateLabel("", 0, 0, $_GUI_MAIN_WIDTH, $_GUI_MAIN_TOP)
GUICtrlSetOnEvent(-1, "BotMoveRequest")
GUICtrlSetBkColor(-1, $COLOR_WHITE)
Else
Local $iTitleX = 25
GUICtrlCreateLabel("", 0, 0, $iTitleX, $_GUI_MAIN_TOP)
GUICtrlSetOnEvent(-1, "BotMoveRequest")
GUICtrlSetBkColor(-1, $COLOR_WHITE)
$g_hLblBotTitle = GUICtrlCreateLabel($g_sBotTitle, $iTitleX, 0, $_GUI_MAIN_WIDTH - $_GUI_MAIN_BUTTON_COUNT * $aBtnSize[0] - 25, $_GUI_MAIN_TOP)
GUICtrlSetOnEvent(-1, "BotMoveRequest")
GUICtrlSetFont(-1, 11, 0, 0, "Segoe UI")
GUICtrlSetBkColor(-1, $COLOR_WHITE)
GUICtrlSetColor(-1, 0x171717)
GUISwitch($g_hFrmBotButtons)
If $g_iGuiMode = 1 Then
$g_hLblBotShrink = GUICtrlCreateLabel(ChrW(0x25C4), 0, 0, $aBtnSize[0], $aBtnSize[1], $SS_CENTER)
_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Title", "LblBotShrink", "Shrink when docked"))
GUICtrlSetFont(-1, 10)
GUICtrlSetBkColor(-1, 0xF0F0F0)
GUICtrlSetColor(-1, 0xB8B8B8)
$g_hLblBotExpand = GUICtrlCreateLabel(ChrW(0x25BA), 0, 0, $aBtnSize[0], $aBtnSize[1], $SS_CENTER)
_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Title", "LblBotExpand", "Expand when docked"))
GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlSetFont(-1, 10)
GUICtrlSetBkColor(-1, 0xF0F0F0)
GUICtrlSetColor(-1, 0xB8B8B8)
EndIf
$g_hLblBotMinimize = GUICtrlCreateLabel("̶", $aBtnSize[0] *($_GUI_MAIN_BUTTON_COUNT - 2), 0, $aBtnSize[0], $aBtnSize[1], $SS_CENTER)
_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Title", "LblBotMinimize", "Minimize"))
GUICtrlSetFont(-1, 10)
GUICtrlSetBkColor(-1, 0xF0F0F0)
GUICtrlSetColor(-1, 0xB8B8B8)
$g_hLblBotClose = GUICtrlCreateLabel("×", $aBtnSize[0] *($_GUI_MAIN_BUTTON_COUNT - 1), 0, $aBtnSize[0], $aBtnSize[1], $SS_CENTER)
_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Title", "LblBotClose", "Close"))
GUICtrlSetFont(-1, 10)
GUICtrlSetBkColor(-1, 0xFF4040)
GUICtrlSetColor(-1, 0xF8F8F8)
$g_hFrmBotLogoUrlSmall = GUICreate("My Bot URL", 290, 13, 0, 0, BitOR($WS_CHILD, $WS_TABSTOP), BitOR($WS_EX_TOOLWINDOW, $WS_EX_NOACTIVATE,($g_bAndroidShieldPreWin8 ? 0 : $WS_EX_LAYERED)), $g_hFrmBot)
$g_hFrmBot_URL_PIC2 = _GUICtrlCreatePic($g_sLogoUrlSmallPath, 0, 0, 290, 13)
GUICtrlSetCursor(-1, 0)
GUISwitch($g_hFrmBotEx)
GUICtrlCreateLabel("", $_GUI_MAIN_WIDTH - $_GUI_MAIN_BUTTON_COUNT * $aBtnSize[0], $aBtnSize[1], $_GUI_MAIN_BUTTON_COUNT * $aBtnSize[0], $_GUI_MAIN_TOP - $aBtnSize[1])
GUICtrlSetOnEvent(-1, "BotMoveRequest")
GUICtrlSetBkColor(-1, $COLOR_WHITE)
EndIf
$g_hFrmBot_MAIN_PIC = _GUICtrlCreatePic($g_sLogoPath, 0, $_GUI_MAIN_TOP, $_GUI_MAIN_WIDTH, 67)
GUICtrlSetOnEvent(-1, "BotMoveRequest")
$g_hFrmBot_URL_PIC = _GUICtrlCreatePic($g_sLogoUrlPath, 0, $_GUI_MAIN_TOP + 67, $_GUI_MAIN_WIDTH, 13)
GUICtrlSetCursor(-1, 0)
GUISwitch($g_hFrmBot)
$g_hFrmBotEmbeddedShieldInput = GUICtrlCreateInput("", 0, 0, -1, -1, $WS_TABSTOP)
GUICtrlSetState($g_hFrmBotEmbeddedShieldInput, $GUI_HIDE)
$g_hFrmBotBottom = GUICreate("My Bot Buttons", $_GUI_MAIN_WIDTH, $_GUI_BOTTOM_HEIGHT, 0, $_GUI_MAIN_HEIGHT - $_GUI_BOTTOM_HEIGHT + $_GUI_MAIN_TOP, BitOR($WS_CHILD, $WS_TABSTOP), 0, $g_hFrmBot)
GUISwitch($g_hFrmBot)
GUISwitch($g_hFrmBotBottom)
CreateBottomPanel()
GUISwitch($g_hFrmBotEx)
$g_hStatusBar = _GUICtrlStatusBar_Create($g_hFrmBotBottom)
_GUICtrlStatusBar_SetSimple($g_hStatusBar)
GUISetDefaultFont($g_hStatusBar)
_GUICtrlStatusBar_SetTextEx($g_hStatusBar, "Status : Idle")
EndFunc
Func ShowMainGUI()
If $g_iGuiMode = 0 Then Return
CheckDpiAwareness(False, $g_bBotLaunchOption_ForceDpiAware, True)
If Not $g_bNoFocusTampering Then
GUISetState(@SW_SHOW, $g_hFrmBot)
Else
GUISetState(@SW_SHOW, $g_hFrmBot)
EndIf
GUISetState(@SW_SHOWNOACTIVATE, $g_hFrmBotButtons)
If $g_hFrmBotEx Then GUISetState(@SW_SHOWNOACTIVATE, $g_hFrmBotEx)
GUISetState(@SW_SHOWNOACTIVATE, $g_hFrmBotBottom)
GUISwitch($g_hFrmBotEx)
$g_bFrmBotMinimized = False
Local $p = WinGetPos($g_hFrmBot)
$g_aFrmBotPosInit[0] = $p[0]
$g_aFrmBotPosInit[1] = $p[1]
$g_aFrmBotPosInit[2] = $p[2]
$g_aFrmBotPosInit[3] = $p[3]
$g_aFrmBotPosInit[4] = _WinAPI_GetClientWidth($g_hFrmBot)
$g_aFrmBotPosInit[5] = _WinAPI_GetClientHeight($g_hFrmBot)
$g_aFrmBotPosInit[6] = ControlGetPos($g_hFrmBot, "", $g_hFrmBotEx)[3]
EndFunc
Func CheckDpiAwareness($bCheckOnlyIfAlreadyAware = False, $bForceDpiAware = False, $bForceDpiAware2 = False)
Return False
EndFunc
Func GUISetDefaultFont($h)
EndFunc
Func _GUICtrlCreateIcon($filename, $iconName, $left, $top, $width = 32, $height = 32, $style = -1, $exStyle = -1)
Static $s_hLibIcon = 0
Local $hLib
If $filename = $g_sLibIconPath Then
If $s_hLibIcon = 0 Then
$s_hLibIcon = _WinAPI_LoadLibraryEx($filename, $LOAD_LIBRARY_AS_DATAFILE)
EndIf
$hLib = $s_hLibIcon
Else
$hLib = _WinAPI_LoadLibraryEx($filename, $LOAD_LIBRARY_AS_DATAFILE)
EndIf
Local $hIcon = _WinAPI_LoadImage($hLib, $iconName, $IMAGE_ICON, $width, $height, $LR_DEFAULTCOLOR)
If $hLib <> $s_hLibIcon Then
_WinAPI_FreeLibrary($hLib)
EndIf
Local $hBmp = _WinAPI_Create32BitHBITMAP($hIcon, False, True)
Local $controlID = GUICtrlCreatePic("", $left, $top, $width, $height, $style, $exStyle)
_WinAPI_DeleteObject(GUICtrlSendMsg($controlID, $STM_SETIMAGE, 0, $hBmp))
_WinAPI_DeleteObject($hBmp)
Local $aIconData = [$width, $height]
$g_oCtrlIconData("Icon:" & GUICtrlGetHandle($controlID)) = $aIconData
Return $controlID
EndFunc
Func readConfig($inputfile = $g_sProfileConfigPath)
Static $iReadConfigCount = 0
If $g_bReadConfigIsActive Then
SetDebugLog("readConfig(), already running, exit")
Return
EndIf
$g_bReadConfigIsActive = True
$iReadConfigCount += 1
SetDebugLog("readConfig(), call number " & $iReadConfigCount)
$g_aiWeakBaseStats = readWeakBaseStats()
ReadProfileConfig()
If FileExists($g_sProfileBuildingPath) Then ReadBuildingConfig()
If FileExists($g_sProfileConfigPath) Then ReadRegularConfig()
$g_bReadConfigIsActive = False
EndFunc
Func ReadProfileConfig($sIniFile = $g_sProfilePath & "\profile.ini")
If FileExists($sIniFile) = 0 Then Return False
Local $iValue, $sValue
$iValue = $g_iGlobalActiveBotsAllowed
$g_iGlobalActiveBotsAllowed = Int(IniRead($sIniFile, "general", "globalactivebotsallowed", $g_iGlobalActiveBotsAllowed))
If $g_iGlobalActiveBotsAllowed < 1 Then $g_iGlobalActiveBotsAllowed = 2
If $iValue <> $g_iGlobalActiveBotsAllowed Then
SetDebugLog("Maximum of " & $iValue & " bots running at same time changed to " & $g_iGlobalActiveBotsAllowed)
EndIf
$iValue = $g_iGlobalThreads
$g_iGlobalThreads = Int(IniRead($sIniFile, "general", "globalthreads", $g_iGlobalThreads))
If $iValue <> $g_iGlobalThreads Then
SetDebugLog("Threading: Using " & $g_iGlobalThreads & " threads shared across all bot instances changed to " & $iValue)
EndIf
$sValue = IniRead($sIniFile, "general", "adb.path", $g_sAndroidAdbPath)
If FileExists($sValue) Then $g_sAndroidAdbPath = $sValue
Return True
EndFunc
Func ReadBuildingConfig()
SetDebugLog("Read Building Config " & $g_sProfileBuildingPath)
Local $locationsInvalid = False
Local $buildingVersion = "0.0.0"
IniReadS($buildingVersion, $g_sProfileBuildingPath, "general", "version", $buildingVersion)
Local $_ver630 = GetVersionNormalized("6.3.0")
Local $_ver63u = GetVersionNormalized("6.3.u")
Local $_ver63u3 = GetVersionNormalized("6.3.u3")
If $buildingVersion < $_ver630 Or($buildingVersion >= $_ver63u And $buildingVersion <= $_ver63u3) Then
SetLog("New MyBot.run version! Re-locate all buildings!", $COLOR_WARNING)
$locationsInvalid = True
EndIf
IniReadS($g_iTownHallLevel, $g_sProfileBuildingPath, "other", "LevelTownHall", 0, "int")
If $locationsInvalid = False Then
IniReadS($g_aiTownHallPos[0], $g_sProfileBuildingPath, "other", "xTownHall", -1, "int")
IniReadS($g_aiTownHallPos[1], $g_sProfileBuildingPath, "other", "yTownHall", -1, "int")
IniReadS($g_aiClanCastlePos[0], $g_sProfileBuildingPath, "other", "xCCPos", -1, "int")
IniReadS($g_aiClanCastlePos[1], $g_sProfileBuildingPath, "other", "yCCPos", -1, "int")
IniReadS($g_aiKingAltarPos[0], $g_sProfileBuildingPath, "other", "xKingAltarPos", -1, "int")
IniReadS($g_aiKingAltarPos[1], $g_sProfileBuildingPath, "other", "yKingAltarPos", -1, "int")
IniReadS($g_aiQueenAltarPos[0], $g_sProfileBuildingPath, "other", "xQueenAltarPos", -1, "int")
IniReadS($g_aiQueenAltarPos[1], $g_sProfileBuildingPath, "other", "yQueenAltarPos", -1, "int")
IniReadS($g_aiWardenAltarPos[0], $g_sProfileBuildingPath, "other", "xWardenAltarPos", -1, "int")
IniReadS($g_aiWardenAltarPos[1], $g_sProfileBuildingPath, "other", "yWardenAltarPos", -1, "int")
IniReadS($g_aiLaboratoryPos[0], $g_sProfileBuildingPath, "upgrade", "LabPosX", -1, "int")
IniReadS($g_aiLaboratoryPos[1], $g_sProfileBuildingPath, "upgrade", "LabPosY", -1, "int")
EndIf
IniReadS($g_aiLastGoodWallPos[0], $g_sProfileBuildingPath, "upgrade", "xLastGoodWallPos", -1, "int")
IniReadS($g_aiLastGoodWallPos[1], $g_sProfileBuildingPath, "upgrade", "yLastGoodWallPos", -1, "int")
IniReadS($g_iTotalCampSpace, $g_sProfileBuildingPath, "other", "totalcamp", 0, "int")
For $iz = 0 To UBound($g_avBuildingUpgrades, 1) - 1
$g_avBuildingUpgrades[$iz][0] = IniRead($g_sProfileBuildingPath, "upgrade", "xupgrade" & $iz, "-1")
$g_avBuildingUpgrades[$iz][1] = IniRead($g_sProfileBuildingPath, "upgrade", "yupgrade" & $iz, "-1")
$g_avBuildingUpgrades[$iz][2] = IniRead($g_sProfileBuildingPath, "upgrade", "upgradevalue" & $iz, "-1")
$g_avBuildingUpgrades[$iz][3] = IniRead($g_sProfileBuildingPath, "upgrade", "upgradetype" & $iz, "")
$g_avBuildingUpgrades[$iz][4] = IniRead($g_sProfileBuildingPath, "upgrade", "upgradename" & $iz, "")
$g_avBuildingUpgrades[$iz][5] = IniRead($g_sProfileBuildingPath, "upgrade", "upgradelevel" & $iz, "")
$g_avBuildingUpgrades[$iz][6] = IniRead($g_sProfileBuildingPath, "upgrade", "upgradetime" & $iz, "")
$g_avBuildingUpgrades[$iz][7] = IniRead($g_sProfileBuildingPath, "upgrade", "upgradeend" & $iz, "-1")
$g_abBuildingUpgradeEnable[$iz] =(IniRead($g_sProfileBuildingPath, "upgrade", "upgradechk" & $iz, 0) = "1")
$g_abUpgradeRepeatEnable[$iz] =(IniRead($g_sProfileBuildingPath, "upgrade", "upgraderepeat" & $iz, 0) = "1")
$g_aiPicUpgradeStatus[$iz] = IniRead($g_sProfileBuildingPath, "upgrade", "upgradestatusicon" & $iz, $eIcnTroops)
If $locationsInvalid = True Then
$g_avBuildingUpgrades[$iz][0] = -1
$g_avBuildingUpgrades[$iz][1] = -1
$g_abBuildingUpgradeEnable[$iz] = False
$g_abUpgradeRepeatEnable[$iz] = False
EndIf
Next
EndFunc
Func ReadRegularConfig()
SetDebugLog("Read Config " & $g_sProfileConfigPath)
ReadConfig_Debug()
IniReadS($g_iThreads, $g_sProfileConfigPath, "general", "threads", $g_iThreads, "int")
If $g_iThreads < 0 Then $g_iThreads = 0
IniReadS($g_iBotDesignFlags, $g_sProfileConfigPath, "general", "botDesignFlags", 0, "int")
IniReadS($g_iFrmBotPosX, $g_sProfileConfigPath, "general", "frmBotPosX", $g_iFrmBotPosX, "int")
IniReadS($g_iFrmBotPosY, $g_sProfileConfigPath, "general", "frmBotPosY", $g_iFrmBotPosY, "int")
If $g_iFrmBotPosX < -30000 Or $g_iFrmBotPosY < -30000 Then
$g_iFrmBotPosX = $g_WIN_POS_DEFAULT
$g_iFrmBotPosY = $g_WIN_POS_DEFAULT
EndIf
IniReadS($g_iAndroidPosX, $g_sProfileConfigPath, "general", "AndroidPosX", $g_iAndroidPosX, "int")
IniReadS($g_iAndroidPosY, $g_sProfileConfigPath, "general", "AndroidPosY", $g_iAndroidPosY, "int")
If $g_iAndroidPosX < -30000 Or $g_iAndroidPosY < -30000 Then
$g_iAndroidPosX = $g_WIN_POS_DEFAULT
$g_iAndroidPosY = $g_WIN_POS_DEFAULT
EndIf
IniReadS($g_iFrmBotDockedPosX, $g_sProfileConfigPath, "general", "frmBotDockedPosX", $g_iFrmBotDockedPosX, "int")
IniReadS($g_iFrmBotDockedPosY, $g_sProfileConfigPath, "general", "frmBotDockedPosY", $g_iFrmBotDockedPosY, "int")
If $g_iFrmBotDockedPosX < -30000 Or $g_iFrmBotDockedPosY < -30000 Then
$g_iFrmBotDockedPosX = $g_WIN_POS_DEFAULT
$g_iFrmBotDockedPosY = $g_WIN_POS_DEFAULT
EndIf
IniReadS($g_iRedrawBotWindowMode, $g_sProfileConfigPath, "general", "RedrawBotWindowMode", 2, "int")
ReadConfig_Android()
ReadConfig_600_1()
ReadConfig_600_6()
ReadConfig_600_9()
ReadConfig_600_11()
ReadConfig_600_12()
ReadConfig_600_13()
ReadConfig_600_14()
ReadConfig_600_15()
ReadConfig_600_16()
ReadConfig_auto()
ReadConfig_600_17()
ReadConfig_600_18()
ReadConfig_600_19()
ReadConfig_600_22()
ReadConfig_600_26()
ReadConfig_600_28()
ReadConfig_600_28_DB()
ReadConfig_600_28_LB()
ReadConfig_600_28_TS()
ReadConfig_600_29()
ReadConfig_600_29_DB()
ReadConfig_600_29_LB()
ReadConfig_600_29_TS()
ReadConfig_600_30()
ReadConfig_600_30_DB()
ReadConfig_600_30_LB()
ReadConfig_600_30_TS()
ReadConfig_600_31()
ReadConfig_600_32()
ReadConfig_600_33()
ReadConfig_600_35_1()
ReadConfig_600_35_2()
ReadConfig_600_52_1()
ReadConfig_600_52_2()
ReadConfig_600_54()
ReadConfig_600_56()
ReadConfig_641_1()
EndFunc
Func ReadConfig_Debug()
$g_bDebugSetlog = IniRead($g_sProfileConfigPath, "debug", "debugsetlog", 0) = 1 ? True : False
$g_bDebugAndroid = IniRead($g_sProfileConfigPath, "debug", "debugAndroid", 0) = 1 ? True : False
$g_bDebugClick = IniRead($g_sProfileConfigPath, "debug", "debugsetclick", 0) = 1 ? True : False
If $g_bDevMode Then
Local $bDebugFunc = IniRead($g_sProfileConfigPath, "debug", "debugFunc", 0) = 1 ? True : False
$g_bDebugFuncTime = $bDebugFunc
$g_bDebugFuncCall = $bDebugFunc
$g_bDebugDisableZoomout = IniRead($g_sProfileConfigPath, "debug", "disablezoomout", 0) = 1 ? True : False
$g_bDebugDisableVillageCentering = IniRead($g_sProfileConfigPath, "debug", "disablevillagecentering", 0) = 1 ? True : False
$g_bDebugDeadBaseImage = IniRead($g_sProfileConfigPath, "debug", "debugdeadbaseimage", 0) = 1 ? True : False
$g_bDebugOcr = IniRead($g_sProfileConfigPath, "debug", "debugocr", 0) = 1 ? True : False
$g_bDebugImageSave = IniRead($g_sProfileConfigPath, "debug", "debugimagesave", 0) = 1 ? True : False
$g_bDebugBuildingPos = IniRead($g_sProfileConfigPath, "debug", "debugbuildingpos", 0) = 1 ? True : False
$g_bDebugSetlogTrain = IniRead($g_sProfileConfigPath, "debug", "debugtrain", 0) = 1 ? True : False
$g_bDebugResourcesOffset = IniRead($g_sProfileConfigPath, "debug", "debugresourcesoffset", 0) = 1 ? True : False
$g_bDebugContinueSearchElixir = IniRead($g_sProfileConfigPath, "debug", "continuesearchelixirdebug", 0) = 1 ? True : False
$g_bDebugMilkingIMGmake = IniRead($g_sProfileConfigPath, "debug", "debugMilkingIMGmake", 0) = 1 ? True : False
$g_bDebugOCRdonate = IniRead($g_sProfileConfigPath, "debug", "debugOCRDonate", 0) = 1 ? True : False
$g_bDebugAttackCSV = IniRead($g_sProfileConfigPath, "debug", "debugAttackCSV", 0) = 1 ? True : False
$g_bDebugMakeIMGCSV = IniRead($g_sProfileConfigPath, "debug", "debugmakeimgcsv", 0) = 1 ? True : False
$g_bDebugSmartZap = BitOR($g_bDebugSmartZap, Int(IniRead($g_sProfileConfigPath, "debug", "DebugSmartZap", 0)))
EndIf
EndFunc
Func ReadConfig_Android()
$g_sAndroidGameDistributor = IniRead($g_sProfileConfigPath, "android", "game.distributor", $g_sAndroidGameDistributor)
$g_sAndroidGamePackage = IniRead($g_sProfileConfigPath, "android", "game.package", $g_sAndroidGamePackage)
$g_sAndroidGameClass = IniRead($g_sProfileConfigPath, "android", "game.class", $g_sAndroidGameClass)
$g_sUserGameDistributor = IniRead($g_sProfileConfigPath, "android", "user.distributor", $g_sUserGameDistributor)
$g_sUserGamePackage = IniRead($g_sProfileConfigPath, "android", "user.package", $g_sUserGamePackage)
$g_sUserGameClass = IniRead($g_sProfileConfigPath, "android", "user.class", $g_sUserGameClass)
$g_iAndroidBackgroundMode = Int(IniRead($g_sProfileConfigPath, "android", "backgroundmode", $g_iAndroidBackgroundMode))
$g_bAndroidCheckTimeLagEnabled = Int(IniRead($g_sProfileConfigPath, "android", "check.time.lag.enabled",($g_bAndroidCheckTimeLagEnabled ? 1 : 0))) = 1
$g_iAndroidAdbScreencapTimeoutMin = Int(IniRead($g_sProfileConfigPath, "android", "adb.screencap.timeout.min", $g_iAndroidAdbScreencapTimeoutMin))
$g_iAndroidAdbScreencapTimeoutMax = Int(IniRead($g_sProfileConfigPath, "android", "adb.screencap.timeout.max", $g_iAndroidAdbScreencapTimeoutMax))
$g_iAndroidAdbScreencapTimeoutDynamic = Int(IniRead($g_sProfileConfigPath, "android", "adb.screencap.timeout.dynamic", $g_iAndroidAdbScreencapTimeoutDynamic))
$g_bAndroidAdbInputEnabled = Int(IniRead($g_sProfileConfigPath, "android", "adb.input.enabled",($g_bAndroidAdbInputEnabled ? 1 : 0))) = 1
$g_bAndroidAdbClickEnabled = Int(IniRead($g_sProfileConfigPath, "android", "adb.click.enabled",($g_bAndroidAdbClickEnabled ? 1 : 0))) = 1
$g_bAndroidAdbClickDragScript = Int(IniRead($g_sProfileConfigPath, "android", "adb.click.drag.script",(BitAND($g_iAndroidSupportFeature, 128) ? 0 : 1))) = 1
$g_iAndroidAdbClickGroup = Int(IniRead($g_sProfileConfigPath, "android", "adb.click.group", $g_iAndroidAdbClickGroup))
$g_bAndroidAdbClicksEnabled = Int(IniRead($g_sProfileConfigPath, "android", "adb.clicks.enabled",($g_bAndroidAdbClicksEnabled ? 1 : 0))) = 1
$g_iAndroidAdbClicksTroopDeploySize = Int(IniRead($g_sProfileConfigPath, "android", "adb.clicks.troop.deploy.size", $g_iAndroidAdbClicksTroopDeploySize))
$g_bNoFocusTampering = Int(IniRead($g_sProfileConfigPath, "android", "no.focus.tampering",($g_bNoFocusTampering ? 1 : 0))) = 1
$g_iAndroidShieldColor = Dec(IniRead($g_sProfileConfigPath, "android", "shield.color", Hex($g_iAndroidShieldColor, 6)))
$g_iAndroidShieldTransparency = Int(IniRead($g_sProfileConfigPath, "android", "shield.transparency", $g_iAndroidShieldTransparency))
$g_iAndroidActiveColor = Dec(IniRead($g_sProfileConfigPath, "android", "active.color", Hex($g_iAndroidActiveColor, 6)))
$g_iAndroidActiveTransparency = Int(IniRead($g_sProfileConfigPath, "android", "active.transparency", $g_iAndroidActiveTransparency))
$g_iAndroidInactiveColor = Dec(IniRead($g_sProfileConfigPath, "android", "inactive.color", Hex($g_iAndroidInactiveColor, 6)))
$g_iAndroidInactiveTransparency = Int(IniRead($g_sProfileConfigPath, "android", "inactive.transparency", $g_iAndroidInactiveTransparency))
$g_iAndroidSuspendModeFlags = Int(IniRead($g_sProfileConfigPath, "android", "suspend.mode", $g_iAndroidSuspendModeFlags))
$g_iAndroidRebootHours = Int(IniRead($g_sProfileConfigPath, "android", "reboot.hours", $g_iAndroidRebootHours))
$g_bAndroidCloseWithBot = Int(IniRead($g_sProfileConfigPath, "android", "close", $g_bAndroidCloseWithBot ? 1 : 0)) = 1
$g_iAndroidProcessAffinityMask = Int(IniRead($g_sProfileConfigPath, "android", "process.affinity.mask", $g_iAndroidProcessAffinityMask))
If $g_bBotLaunchOption_Restart = True Or $g_asCmdLine[0] < 2 Then
Local $sAndroidEmulator = IniRead($g_sProfileConfigPath, "android", "emulator", "")
Local $sAndroidInstance = IniRead($g_sProfileConfigPath, "android", "instance", "")
If $sAndroidEmulator <> "" Then
If $sAndroidEmulator <> $g_sAndroidEmulator Or $sAndroidInstance <> $g_sAndroidInstance Then
UpdateHWnD(0)
UpdateAndroidConfig($sAndroidInstance, $sAndroidEmulator)
EndIf
Else
$g_bBotLaunchOption_Restart = False
EndIf
EndIf
EndFunc
Func ReadConfig_600_1()
IniReadS($g_iCmbLogDividerOption, $g_sProfileConfigPath, "general", "logstyle", 0, "int")
IniReadS($g_iLogDividerY, $g_sProfileConfigPath, "general", "LogDividerY", 243, "int")
IniReadS($g_bChkBackgroundMode, $g_sProfileConfigPath, "general", "Background", True, "Bool")
EndFunc
Func ReadConfig_600_6()
IniReadS($g_bChkBotStop, $g_sProfileConfigPath, "general", "BotStop", False, "Bool")
IniReadS($g_iCmbBotCommand, $g_sProfileConfigPath, "general", "Command", 0, "int")
IniReadS($g_iCmbBotCond, $g_sProfileConfigPath, "general", "Cond", 0, "int")
IniReadS($g_iCmbHoursStop, $g_sProfileConfigPath, "general", "Hour", 0, "int")
IniReadS($g_iTxtRestartGold, $g_sProfileConfigPath, "other", "minrestartgold", 50000, "int")
IniReadS($g_iTxtRestartElixir, $g_sProfileConfigPath, "other", "minrestartelixir", 50000, "int")
IniReadS($g_iTxtRestartDark, $g_sProfileConfigPath, "other", "minrestartdark", 500, "int")
IniReadS($g_bChkTrap, $g_sProfileConfigPath, "other", "chkTrap", True, "Bool")
IniReadS($g_bChkCollect, $g_sProfileConfigPath, "other", "chkCollect", True, "Bool")
IniReadS($g_bChkTombstones, $g_sProfileConfigPath, "other", "chkTombstones", True, "Bool")
IniReadS($g_bChkCleanYard, $g_sProfileConfigPath, "other", "chkCleanYard", False, "Bool")
IniReadS($g_bChkGemsBox, $g_sProfileConfigPath, "other", "chkGemsBox", False, "Bool")
IniReadS($g_bChkCollectFreeMagicItems, $g_sProfileConfigPath, "other", "ChkCollectFreeMagicItems", False, "Bool")
IniReadS($g_bChkTreasuryCollect, $g_sProfileConfigPath, "other", "ChkTreasuryCollect", False, "Bool")
IniReadS($g_iTxtTreasuryGold, $g_sProfileConfigPath, "other", "minTreasurygold", 0, "int")
IniReadS($g_iTxtTreasuryElixir, $g_sProfileConfigPath, "other", "minTreasuryelixir", 0, "int")
IniReadS($g_iTxtTreasuryDark, $g_sProfileConfigPath, "other", "minTreasurydark", 0, "int")
IniReadS($g_bChkCollectBuilderBase, $g_sProfileConfigPath, "other", "ChkCollectBuildersBase", False, "Bool")
IniReadS($g_bChkStartClockTowerBoost, $g_sProfileConfigPath, "other", "ChkStartClockTowerBoost", False, "Bool")
IniReadS($g_bChkCTBoostBlderBz, $g_sProfileConfigPath, "other", "ChkCTBoostBlderBz", False, "Bool")
IniReadS($g_iChkBBSuggestedUpgrades, $g_sProfileConfigPath, "other", "ChkBBSuggestedUpgrades", $g_iChkBBSuggestedUpgrades, "Int")
IniReadS($g_iChkBBSuggestedUpgradesIgnoreGold, $g_sProfileConfigPath, "other", "ChkBBSuggestedUpgradesIgnoreGold", $g_iChkBBSuggestedUpgradesIgnoreGold, "Int")
IniReadS($g_iChkBBSuggestedUpgradesIgnoreElixir, $g_sProfileConfigPath, "other", "ChkBBSuggestedUpgradesIgnoreElixir", $g_iChkBBSuggestedUpgradesIgnoreElixir, "Int")
IniReadS($g_iChkBBSuggestedUpgradesIgnoreHall, $g_sProfileConfigPath, "other", "ChkBBSuggestedUpgradesIgnoreHall", $g_iChkBBSuggestedUpgradesIgnoreHall, "Int")
IniReadS($g_iChkPlacingNewBuildings, $g_sProfileConfigPath, "other", "ChkPlacingNewBuildings", $g_iChkPlacingNewBuildings, "Int")
IniReadS($g_bChkClanGamesAir, $g_sProfileConfigPath, "other", "ChkClanGamesAir", False, "Bool")
IniReadS($g_bChkClanGamesGround, $g_sProfileConfigPath, "other", "ChkClanGamesGround", False, "Bool")
IniReadS($g_bChkClanGamesMisc, $g_sProfileConfigPath, "other", "ChkClanGamesMisc", False, "Bool")
IniReadS($g_bChkClanGamesEnabled, $g_sProfileConfigPath, "other", "ChkClanGamesEnabled", False, "Bool")
IniReadS($g_bChkClanGamesOnly, $g_sProfileConfigPath, "other", "ChkClanGamesOnly", False, "Bool")
IniReadS($g_bChkClanGamesPurge, $g_sProfileConfigPath, "other", "ChkClanGamesPurge", False, "Bool")
IniReadS($g_bChkClanGamesStopBeforeReachAndPurge, $g_sProfileConfigPath, "other", "ChkClanGamesStopBeforeReachAndPurge", False, "Bool")
IniReadS($g_bChkClanGamesDebug, $g_sProfileConfigPath, "other", "ChkClanGamesDebug", False, "Bool")
IniReadS($g_bChkClanGamesLoot, $g_sProfileConfigPath, "other", "ChkClanGamesLoot", False, "Bool")
IniReadS($g_bChkClanGamesBattle, $g_sProfileConfigPath, "other", "ChkClanGamesBattle", False, "Bool")
IniReadS($g_bChkClanGamesDestruction, $g_sProfileConfigPath, "other", "ChkClanGamesDestruction", False, "Bool")
IniReadS($g_bChkClanGamesAirTroop, $g_sProfileConfigPath, "other", "ChkClanGamesAirTroop", False, "Bool")
IniReadS($g_bChkClanGamesGroundTroop, $g_sProfileConfigPath, "other", "ChkClanGamesGroundTroop", False, "Bool")
IniReadS($g_bChkClanGamesMiscellaneous, $g_sProfileConfigPath, "other", "ChkClanGamesMiscellaneous", False, "Bool")
IniReadS($g_iPurgeMax, $g_sProfileConfigPath, "other", "PurgeMax", 5, "int")
EndFunc
Func ReadConfig_600_9()
IniReadS($g_iUnbrkMode, $g_sProfileConfigPath, "Unbreakable", "chkUnbreakable", 0, "int")
IniReadS($g_iUnbrkWait, $g_sProfileConfigPath, "Unbreakable", "UnbreakableWait", 5, "int")
IniReadS($g_iUnbrkMinGold, $g_sProfileConfigPath, "Unbreakable", "minUnBrkgold", 50000, "int")
IniReadS($g_iUnbrkMaxGold, $g_sProfileConfigPath, "Unbreakable", "maxUnBrkgold", 600000, "int")
IniReadS($g_iUnbrkMinElixir, $g_sProfileConfigPath, "Unbreakable", "minUnBrkelixir", 50000, "int")
IniReadS($g_iUnbrkMaxElixir, $g_sProfileConfigPath, "Unbreakable", "maxUnBrkelixir", 600000, "int")
IniReadS($g_iUnbrkMinDark, $g_sProfileConfigPath, "Unbreakable", "minUnBrkdark", 5000, "int")
IniReadS($g_iUnbrkMaxDark, $g_sProfileConfigPath, "Unbreakable", "maxUnBrkdark", 10000, "int")
EndFunc
Func ReadConfig_600_11()
$g_bRequestTroopsEnable =(IniRead($g_sProfileConfigPath, "planned", "RequestHoursEnable", "0") = "1")
$g_sRequestTroopsText = IniRead($g_sProfileConfigPath, "donate", "txtRequest", "")
$g_abRequestCCHours = StringSplit(IniRead($g_sProfileConfigPath, "planned", "RequestHours", "1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1"), "|", $STR_NOCOUNT)
For $i = 0 To 23
$g_abRequestCCHours[$i] =($g_abRequestCCHours[$i] = "1")
Next
EndFunc
Func ReadConfig_600_12()
IniReadS($g_bChkDonate, $g_sProfileConfigPath, "donate", "Doncheck", True, "Bool")
For $i = 0 To $eTroopCount - 1 + $g_iCustomDonateConfigs
Local $sIniName = ""
If $i >= $eTroopBarbarian And $i <= $eTroopBowler Then
$sIniName = StringReplace($g_asTroopNamesPlural[$i], " ", "")
ElseIf $i = $eCustomA Then
$sIniName = "CustomA"
ElseIf $i = $eCustomB Then
$sIniName = "CustomB"
ElseIf $i = $eCustomC Then
$sIniName = "CustomC"
ElseIf $i = $eCustomD Then
$sIniName = "CustomD"
EndIf
$g_abChkDonateTroop[$i] =(IniRead($g_sProfileConfigPath, "donate", "chkDonate" & $sIniName, "0") = "1")
$g_abChkDonateAllTroop[$i] =(IniRead($g_sProfileConfigPath, "donate", "chkDonateAll" & $sIniName, "0") = "1")
Next
$g_asTxtDonateTroop[$eTroopBarbarian] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateBarbarians", "barbarians|barbarian|barb"), "|", @CRLF)
$g_asTxtBlacklistTroop[$eTroopBarbarian] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistBarbarians", "no barbarians|no barb|barbarian no|barb no"), "|", @CRLF)
$g_asTxtDonateTroop[$eTroopArcher] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateArchers", "archers|archer|arch"), "|", @CRLF)
$g_asTxtBlacklistTroop[$eTroopArcher] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistArchers", "no archers|no arch|archer no|arch no"), "|", @CRLF)
$g_asTxtDonateTroop[$eTroopGiant] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateGiants", "giants|giant|any"), "|", @CRLF)
$g_asTxtBlacklistTroop[$eTroopGiant] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistGiants", "no giants|giants no"), "|", @CRLF)
$g_asTxtDonateTroop[$eTroopGoblin] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateGoblins", "goblins|goblin"), "|", @CRLF)
$g_asTxtBlacklistTroop[$eTroopGoblin] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistGoblins", "no goblins|goblins no"), "|", @CRLF)
$g_asTxtDonateTroop[$eTroopWallBreaker] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateWallBreakers", "wall breakers|wb"), "|", @CRLF)
$g_asTxtBlacklistTroop[$eTroopWallBreaker] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistWallBreakers", "no wallbreakers|wb no"), "|", @CRLF)
$g_asTxtDonateTroop[$eTroopBalloon] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateBalloons", "balloons|balloon"), "|", @CRLF)
$g_asTxtBlacklistTroop[$eTroopBalloon] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistBalloons", "no balloon|balloons no"), "|", @CRLF)
$g_asTxtDonateTroop[$eTroopWizard] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateWizards", "wizards|wizard|wiz"), "|", @CRLF)
$g_asTxtBlacklistTroop[$eTroopWizard] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistWizards", "no wizards|wizards no|no wizard|wizard no"), "|", @CRLF)
$g_asTxtDonateTroop[$eTroopHealer] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateHealers", "healer"), "|", @CRLF)
$g_asTxtBlacklistTroop[$eTroopHealer] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistHealers", "no healer|healer no"), "|", @CRLF)
$g_asTxtDonateTroop[$eTroopDragon] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateDragons", "dragon"), "|", @CRLF)
$g_asTxtBlacklistTroop[$eTroopDragon] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistDragons", "no dragon|dragon no"), "|", @CRLF)
$g_asTxtDonateTroop[$eTroopPekka] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonatePekkas", "PEKKA|pekka"), "|", @CRLF)
$g_asTxtBlacklistTroop[$eTroopPekka] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistPekkas", "no PEKKA|pekka no"), "|", @CRLF)
$g_asTxtDonateTroop[$eTroopBabyDragon] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateBabyDragons", "baby dragon|baby"), "|", @CRLF)
$g_asTxtBlacklistTroop[$eTroopBabyDragon] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistBabyDragons", "no baby dragon|baby dragon no|no baby|baby no"), "|", @CRLF)
$g_asTxtDonateTroop[$eTroopMiner] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateMiners", "miner|mine"), "|", @CRLF)
$g_asTxtBlacklistTroop[$eTroopMiner] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistMiners", "no miner|miner no|no mine|mine no"), "|", @CRLF)
$g_asTxtDonateTroop[$eTroopElectroDragon] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateElectroDragons", "electro dragon|electrodrag|edrag"), "|", @CRLF)
$g_asTxtBlacklistTroop[$eTroopElectroDragon] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistElectroDragons", "no electro dragon|electrodrag no|edrag no"), "|", @CRLF)
$g_asTxtDonateTroop[$eTroopMinion] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateMinions", "minions|minion"), "|", @CRLF)
$g_asTxtBlacklistTroop[$eTroopMinion] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistMinions", "no minion|minions no"), "|", @CRLF)
$g_asTxtDonateTroop[$eTroopHogRider] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateHogRiders", "hogriders|hogs|hog"), "|", @CRLF)
$g_asTxtBlacklistTroop[$eTroopHogRider] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistHogRiders", "no hogriders|hogriders no|no hog|hogs no"), "|", @CRLF)
$g_asTxtDonateTroop[$eTroopValkyrie] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateValkyries", "valkyries|valkyrie|valk"), "|", @CRLF)
$g_asTxtBlacklistTroop[$eTroopValkyrie] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistValkyries", "no valkyrie|valkyries no|no valk|valk no"), "|", @CRLF)
$g_asTxtDonateTroop[$eTroopGolem] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateGolems", "golem"), "|", @CRLF)
$g_asTxtBlacklistTroop[$eTroopGolem] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistGolems", "no golem|golem no"), "|", @CRLF)
$g_asTxtDonateTroop[$eTroopWitch] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateWitches", "witches|witch"), "|", @CRLF)
$g_asTxtBlacklistTroop[$eTroopWitch] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistWitches", "no witches|witches no|no witch|witch no"), "|", @CRLF)
$g_asTxtDonateTroop[$eTroopLavaHound] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateLavaHounds", "lavahounds|lava|hound"), "|", @CRLF)
$g_asTxtBlacklistTroop[$eTroopLavaHound] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistLavaHounds", "no lavahound|lavahound no|no lava|lava no|nohound|hound no"), "|", @CRLF)
$g_asTxtDonateTroop[$eTroopBowler] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateBowlers", "bowler|bowl"), "|", @CRLF)
$g_asTxtBlacklistTroop[$eTroopBowler] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistBowlers", "no bowler|bowl no"), "|", @CRLF)
$g_asTxtDonateTroop[$eCustomA] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateCustomA", "ground support|ground"), "|", @CRLF)
$g_asTxtBlacklistTroop[$eCustomA] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistCustomA", "no ground|ground no|nonly"), "|", @CRLF)
$g_asTxtDonateTroop[$eCustomB] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateCustomB", "air support|any air"), "|", @CRLF)
$g_asTxtBlacklistTroop[$eCustomB] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistCustomB", "no air|air no|only|just"), "|", @CRLF)
$g_asTxtDonateTroop[$eCustomC] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateCustomC", "ground support|ground"), "|", @CRLF)
$g_asTxtBlacklistTroop[$eCustomC] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistCustomC", "no ground|ground no|nonly"), "|", @CRLF)
$g_asTxtDonateTroop[$eCustomD] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateCustomD", "air support|any air"), "|", @CRLF)
$g_asTxtBlacklistTroop[$eCustomD] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistCustomD", "no air|air no|only|just"), "|", @CRLF)
For $i = 0 To $eSpellCount - 1
If $i <> $eSpellClone Then
Local $sIniName = $g_asSpellNames[$i] & "Spells"
$g_abChkDonateSpell[$i] =(IniRead($g_sProfileConfigPath, "donate", "chkDonate" & $sIniName, "0") = "1")
$g_abChkDonateAllSpell[$i] =(IniRead($g_sProfileConfigPath, "donate", "chkDonateAll" & $sIniName, "0") = "1")
EndIf
Next
$g_asTxtDonateSpell[$eSpellLightning] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateLightningSpells", "lightning"), "|", @CRLF)
$g_asTxtBlacklistSpell[$eSpellLightning] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistLightningSpells", "no lightning|lightning no"), "|", @CRLF)
$g_asTxtDonateSpell[$eSpellHeal] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateHealSpells", "heal"), "|", @CRLF)
$g_asTxtBlacklistSpell[$eSpellHeal] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistHealSpells", "no heal|heal no"), "|", @CRLF)
$g_asTxtDonateSpell[$eSpellRage] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateRageSpells", "rage"), "|", @CRLF)
$g_asTxtBlacklistSpell[$eSpellRage] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistRageSpells", "no rage|rage no"), "|", @CRLF)
$g_asTxtDonateSpell[$eSpellJump] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateJumpSpells", "jump"), "|", @CRLF)
$g_asTxtBlacklistSpell[$eSpellJump] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistJumpSpells", "no jump|jump no"), "|", @CRLF)
$g_asTxtDonateSpell[$eSpellFreeze] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateFreezeSpells", "freeze"), "|", @CRLF)
$g_asTxtBlacklistSpell[$eSpellFreeze] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistFreezeSpells", "no freeze|freeze no"), "|", @CRLF)
$g_asTxtDonateSpell[$eSpellPoison] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonatePoisonSpells", "poison"), "|", @CRLF)
$g_asTxtBlacklistSpell[$eSpellPoison] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistPoisonSpells", "no poison|poison no"), "|", @CRLF)
$g_asTxtDonateSpell[$eSpellEarthquake] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateEarthQuakeSpells", "earthquake|quake"), "|", @CRLF)
$g_asTxtBlacklistSpell[$eSpellEarthquake] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistEarthQuakeSpells", "no earthquake|quake no"), "|", @CRLF)
$g_asTxtDonateSpell[$eSpellHaste] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateHasteSpells", "haste"), "|", @CRLF)
$g_asTxtBlacklistSpell[$eSpellHaste] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistHasteSpells", "no haste|haste no"), "|", @CRLF)
$g_asTxtDonateSpell[$eSpellSkeleton] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateSkeletonSpells", "skeleton"), "|", @CRLF)
$g_asTxtBlacklistSpell[$eSpellSkeleton] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistSkeletonSpells", "no skeleton|skeleton no"), "|", @CRLF)
$g_aiDonateCustomTrpNumA[0][0] = Int(IniRead($g_sProfileConfigPath, "donate", "cmbDonateCustomA1", 6))
$g_aiDonateCustomTrpNumA[1][0] = Int(IniRead($g_sProfileConfigPath, "donate", "cmbDonateCustomA2", 1))
$g_aiDonateCustomTrpNumA[2][0] = Int(IniRead($g_sProfileConfigPath, "donate", "cmbDonateCustomA3", 0))
$g_aiDonateCustomTrpNumA[0][1] = Int(IniRead($g_sProfileConfigPath, "donate", "txtDonateCustomA1", 2))
$g_aiDonateCustomTrpNumA[1][1] = Int(IniRead($g_sProfileConfigPath, "donate", "txtDonateCustomA2", 3))
$g_aiDonateCustomTrpNumA[2][1] = Int(IniRead($g_sProfileConfigPath, "donate", "txtDonateCustomA3", 1))
$g_aiDonateCustomTrpNumB[0][0] = Int(IniRead($g_sProfileConfigPath, "donate", "cmbDonateCustomB1", 11))
$g_aiDonateCustomTrpNumB[1][0] = Int(IniRead($g_sProfileConfigPath, "donate", "cmbDonateCustomB2", 1))
$g_aiDonateCustomTrpNumB[2][0] = Int(IniRead($g_sProfileConfigPath, "donate", "cmbDonateCustomB3", 6))
$g_aiDonateCustomTrpNumB[0][1] = Int(IniRead($g_sProfileConfigPath, "donate", "txtDonateCustomB1", 3))
$g_aiDonateCustomTrpNumB[1][1] = Int(IniRead($g_sProfileConfigPath, "donate", "txtDonateCustomB2", 13))
$g_aiDonateCustomTrpNumB[2][1] = Int(IniRead($g_sProfileConfigPath, "donate", "txtDonateCustomB3", 5))
$g_aiDonateCustomTrpNumC[0][0] = Int(IniRead($g_sProfileConfigPath, "donate", "cmbDonateCustomC1", 6))
$g_aiDonateCustomTrpNumC[1][0] = Int(IniRead($g_sProfileConfigPath, "donate", "cmbDonateCustomC2", 1))
$g_aiDonateCustomTrpNumC[2][0] = Int(IniRead($g_sProfileConfigPath, "donate", "cmbDonateCustomC3", 0))
$g_aiDonateCustomTrpNumC[0][1] = Int(IniRead($g_sProfileConfigPath, "donate", "txtDonateCustomC1", 2))
$g_aiDonateCustomTrpNumC[1][1] = Int(IniRead($g_sProfileConfigPath, "donate", "txtDonateCustomC2", 3))
$g_aiDonateCustomTrpNumC[2][1] = Int(IniRead($g_sProfileConfigPath, "donate", "txtDonateCustomC3", 1))
$g_aiDonateCustomTrpNumD[0][0] = Int(IniRead($g_sProfileConfigPath, "donate", "cmbDonateCustomD1", 11))
$g_aiDonateCustomTrpNumD[1][0] = Int(IniRead($g_sProfileConfigPath, "donate", "cmbDonateCustomD2", 1))
$g_aiDonateCustomTrpNumD[2][0] = Int(IniRead($g_sProfileConfigPath, "donate", "cmbDonateCustomD3", 6))
$g_aiDonateCustomTrpNumD[0][1] = Int(IniRead($g_sProfileConfigPath, "donate", "txtDonateCustomD1", 3))
$g_aiDonateCustomTrpNumD[1][1] = Int(IniRead($g_sProfileConfigPath, "donate", "txtDonateCustomD2", 13))
$g_aiDonateCustomTrpNumD[2][1] = Int(IniRead($g_sProfileConfigPath, "donate", "txtDonateCustomD3", 5))
$g_bChkExtraAlphabets =(IniRead($g_sProfileConfigPath, "donate", "chkExtraAlphabets", "0") = "1")
$g_bChkExtraChinese =(IniRead($g_sProfileConfigPath, "donate", "chkExtraChinese", "0") = "1")
$g_bChkExtraKorean =(IniRead($g_sProfileConfigPath, "donate", "chkExtraKorean", "0") = "1")
$g_bChkExtraPersian =(IniRead($g_sProfileConfigPath, "donate", "chkExtraPersian", "0") = "1")
$g_sTxtGeneralBlacklist = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklist", "clan war|war|cw"), "|", @CRLF)
EndFunc
Func ReadConfig_600_13()
$g_bDonateHoursEnable =(IniRead($g_sProfileConfigPath, "planned", "DonateHoursEnable", "0") = "1")
$g_abDonateHours = StringSplit(IniRead($g_sProfileConfigPath, "planned", "DonateHours", "1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1"), "|", $STR_NOCOUNT)
For $i = 0 To 23
$g_abDonateHours[$i] =($g_abDonateHours[$i] = "1")
Next
$g_iCmbDonateFilter = Int(IniRead($g_sProfileConfigPath, "donate", "cmbFilterDonationsCC", 0))
$g_iDonateSkipNearFullPercent = Int(IniRead($g_sProfileConfigPath, "donate", "SkipDonateNearFulLTroopsPercentual", 90))
$g_bDonateSkipNearFullEnable =(IniRead($g_sProfileConfigPath, "donate", "SkipDonateNearFulLTroopsEnable", "1") = "1")
EndFunc
Func ReadConfig_600_14()
IniReadS($g_bAutoLabUpgradeEnable, $g_sProfileBuildingPath, "upgrade", "upgradetroops", False, "Bool")
IniReadS($g_iCmbLaboratory, $g_sProfileBuildingPath, "upgrade", "upgradetroopname", 0, "int")
$g_sLabUpgradeTime = IniRead($g_sProfileBuildingPath, "upgrade", "upgradelabtime", "")
EndFunc
Func ReadConfig_600_15()
IniReadS($g_bUpgradeKingEnable, $g_sProfileConfigPath, "upgrade", "UpgradeKing", False, "Bool")
IniReadS($g_bUpgradeQueenEnable, $g_sProfileConfigPath, "upgrade", "UpgradeQueen", False, "Bool")
IniReadS($g_bUpgradeWardenEnable, $g_sProfileConfigPath, "upgrade", "UpgradeWarden", False, "Bool")
EndFunc
Func ReadConfig_600_16()
IniReadS($g_iUpgradeMinGold, $g_sProfileConfigPath, "upgrade", "minupgrgold", 100000, "int")
IniReadS($g_iUpgradeMinElixir, $g_sProfileConfigPath, "upgrade", "minupgrelixir", 100000, "int")
IniReadS($g_iUpgradeMinDark, $g_sProfileConfigPath, "upgrade", "minupgrdark", 2000, "int")
EndFunc
Func ReadConfig_auto()
IniReadS($g_iChkAutoUpgrade, $g_sProfileConfigPath, "Auto Upgrade", "ChkAutoUpgrade", 0, "int")
For $i = 0 To 12
IniReadS($g_iChkUpgradesToIgnore[$i], $g_sProfileConfigPath, "Auto Upgrade", "ChkUpgradesToIgnore[" & $i & "]", $g_iChkUpgradesToIgnore[$i], "int")
Next
For $i = 0 To 2
IniReadS($g_iChkResourcesToIgnore[$i], $g_sProfileConfigPath, "Auto Upgrade", "ChkResourcesToIgnore[" & $i & "]", $g_iChkResourcesToIgnore[$i], "int")
Next
IniReadS($g_iTxtSmartMinGold, $g_sProfileConfigPath, "Auto Upgrade", "SmartMinGold", 150000, "int")
IniReadS($g_iTxtSmartMinElixir, $g_sProfileConfigPath, "Auto Upgrade", "SmartMinElixir", 150000, "int")
IniReadS($g_iTxtSmartMinDark, $g_sProfileConfigPath, "Auto Upgrade", "SmartMinDark", 1500, "int")
EndFunc
Func ReadConfig_600_17()
IniReadS($g_bAutoUpgradeWallsEnable, $g_sProfileConfigPath, "upgrade", "auto-wall", False, "Bool")
IniReadS($g_iUpgradeWallMinGold, $g_sProfileConfigPath, "upgrade", "minwallgold", 0, "int")
IniReadS($g_iUpgradeWallMinElixir, $g_sProfileConfigPath, "upgrade", "minwallelixir", 0, "int")
IniReadS($g_iUpgradeWallLootType, $g_sProfileConfigPath, "upgrade", "use-storage", 0, "int")
IniReadS($g_bUpgradeWallSaveBuilder, $g_sProfileConfigPath, "upgrade", "savebldr", False, "Bool")
IniReadS($g_iCmbUpgradeWallsLevel, $g_sProfileConfigPath, "upgrade", "walllvl", 6, "int")
For $i = 4 To 13
IniReadS($g_aiWallsCurrentCount[$i], $g_sProfileConfigPath, "Walls", "Wall" & StringFormat("%02d", $i), 0, "int")
Next
IniReadS($g_iWallCost, $g_sProfileConfigPath, "upgrade", "WallCost", 0, "int")
EndFunc
Func ReadConfig_600_18()
IniReadS($g_bNotifyPBEnable, $g_sProfileConfigPath, "notify", "PBEnabled", False, "Bool")
IniReadS($g_bNotifyTGEnable, $g_sProfileConfigPath, "notify", "TGEnabled", False, "Bool")
IniReadS($g_sNotifyPBToken, $g_sProfileConfigPath, "notify", "PBToken", "")
IniReadS($g_sNotifyTGToken, $g_sProfileConfigPath, "notify", "TGToken", "")
IniReadS($g_bNotifyRemoteEnable, $g_sProfileConfigPath, "notify", "PBRemote", False, "Bool")
IniReadS($g_sNotifyOrigin, $g_sProfileConfigPath, "notify", "Origin", $g_sProfileCurrentName)
IniReadS($g_bNotifyDeleteAllPushesOnStart, $g_sProfileConfigPath, "notify", "DeleteAllPBPushes", False, "Bool")
IniReadS($g_bNotifyDeletePushesOlderThan, $g_sProfileConfigPath, "notify", "DeleteOldPBPushes", False, "Bool")
IniReadS($g_iNotifyDeletePushesOlderThanHours, $g_sProfileConfigPath, "notify", "HoursPushBullet", 4, "int")
IniReadS($g_bNotifyAlertMatchFound, $g_sProfileConfigPath, "notify", "AlertPBVMFound", False, "Bool")
IniReadS($g_bNotifyAlerLastRaidIMG, $g_sProfileConfigPath, "notify", "AlertPBLastRaid", False, "Bool")
IniReadS($g_bNotifyAlerLastRaidTXT, $g_sProfileConfigPath, "notify", "AlertPBLastRaidTxt", False, "Bool")
IniReadS($g_bNotifyAlertCampFull, $g_sProfileConfigPath, "notify", "AlertPBCampFull", False, "Bool")
IniReadS($g_bNotifyAlertUpgradeWalls, $g_sProfileConfigPath, "notify", "AlertPBWallUpgrade", False, "Bool")
IniReadS($g_bNotifyAlertOutOfSync, $g_sProfileConfigPath, "notify", "AlertPBOOS", False, "Bool")
IniReadS($g_bNotifyAlertTakeBreak, $g_sProfileConfigPath, "notify", "AlertPBVBreak", False, "Bool")
IniReadS($g_bNotifyAlertBulderIdle, $g_sProfileConfigPath, "notify", "AlertBuilderIdle", False, "Bool")
IniReadS($g_bNotifyAlertVillageReport, $g_sProfileConfigPath, "notify", "AlertPBVillage", False, "Bool")
IniReadS($g_bNotifyAlertLastAttack, $g_sProfileConfigPath, "notify", "AlertPBLastAttack", False, "Bool")
IniReadS($g_bNotifyAlertAnotherDevice, $g_sProfileConfigPath, "notify", "AlertPBOtherDevice", False, "Bool")
IniReadS($g_bNotifyAlertMaintenance, $g_sProfileConfigPath, "notify", "AlertPBMaintenance", False, "Bool")
IniReadS($g_bNotifyAlertBAN, $g_sProfileConfigPath, "notify", "AlertPBBAN", False, "Bool")
IniReadS($g_bNotifyAlertBOTUpdate, $g_sProfileConfigPath, "notify", "AlertPBUpdate", False, "Bool")
IniReadS($g_bNotifyAlertSmartWaitTime, $g_sProfileConfigPath, "notify", "AlertSmartWaitTime", False, "Bool")
EndFunc
Func ReadConfig_600_19()
$g_bNotifyScheduleHoursEnable =(IniRead($g_sProfileConfigPath, "notify", "NotifyHoursEnable", "0") = "1")
$g_abNotifyScheduleHours = StringSplit(IniRead($g_sProfileConfigPath, "notify", "NotifyHours", "1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1"), "|", $STR_NOCOUNT)
For $i = 0 To 23
$g_abNotifyScheduleHours[$i] =($g_abNotifyScheduleHours[$i] = "1")
Next
$g_bNotifyScheduleWeekDaysEnable =(IniRead($g_sProfileConfigPath, "notify", "NotifyWeekDaysEnable", "0") = "1")
$g_abNotifyScheduleWeekDays = StringSplit(IniRead($g_sProfileConfigPath, "notify", "NotifyWeekDays", "1|1|1|1|1|1|1"), "|", $STR_NOCOUNT)
For $i = 0 To 6
$g_abNotifyScheduleWeekDays[$i] =($g_abNotifyScheduleWeekDays[$i] = "1")
Next
EndFunc
Func ReadConfig_600_22()
$g_abBoostBarracksHours = StringSplit(IniRead($g_sProfileConfigPath, "planned", "BoostBarracksHours", "1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1"), "|", $STR_NOCOUNT)
For $i = 0 To 23
$g_abBoostBarracksHours[$i] =($g_abBoostBarracksHours[$i] = "1")
Next
EndFunc
Func ReadConfig_600_26()
IniReadS($g_abAttackTypeEnable[$TB], $g_sProfileConfigPath, "search", "BullyMode", False, "Bool")
IniReadS($g_iAtkTBEnableCount, $g_sProfileConfigPath, "search", "ATBullyMode", 0, "int")
IniReadS($g_iAtkTBMaxTHLevel, $g_sProfileConfigPath, "search", "YourTH", 0, "int")
IniReadS($g_iAtkTBMode, $g_sProfileConfigPath, "search", "THBullyAttackMode", 0, "int")
EndFunc
Func ReadConfig_600_28()
IniReadS($g_bSearchReductionEnable, $g_sProfileConfigPath, "search", "reduction", False, "Bool")
IniReadS($g_iSearchReductionCount, $g_sProfileConfigPath, "search", "reduceCount", 20, "int")
IniReadS($g_iSearchReductionGold, $g_sProfileConfigPath, "search", "reduceGold", 2000, "int")
IniReadS($g_iSearchReductionElixir, $g_sProfileConfigPath, "search", "reduceElixir", 2000, "int")
IniReadS($g_iSearchReductionGoldPlusElixir, $g_sProfileConfigPath, "search", "reduceGoldPlusElixir", 4000, "int")
IniReadS($g_iSearchReductionDark, $g_sProfileConfigPath, "search", "reduceDark", 100, "int")
IniReadS($g_iSearchReductionTrophy, $g_sProfileConfigPath, "search", "reduceTrophy", 2, "int")
IniReadS($g_iSearchDelayMin, $g_sProfileConfigPath, "other", "VSDelay", 0, "Int")
IniReadS($g_iSearchDelayMax, $g_sProfileConfigPath, "other", "MaxVSDelay", 4, "Int")
IniReadS($g_bSearchAttackNowEnable, $g_sProfileConfigPath, "general", "AttackNow", False, "Bool")
IniReadS($g_iSearchAttackNowDelay, $g_sProfileConfigPath, "general", "attacknowdelay", 3, "int")
IniReadS($g_bSearchRestartEnable, $g_sProfileConfigPath, "search", "ChkRestartSearchLimit", True, "Bool")
IniReadS($g_iSearchRestartLimit, $g_sProfileConfigPath, "search", "RestartSearchLimit", 50, "int")
IniReadS($g_bSearchAlertMe, $g_sProfileConfigPath, "general", "AlertSearch", False, "Bool")
EndFunc
Func ReadConfig_600_28_DB()
IniReadS($g_abAttackTypeEnable[$DB], $g_sProfileConfigPath, "search", "DBcheck", True, "Bool")
IniReadS($g_abSearchSearchesEnable[$DB], $g_sProfileConfigPath, "search", "ChkDBSearchSearches", True, "Bool")
IniReadS($g_aiSearchSearchesMin[$DB], $g_sProfileConfigPath, "search", "DBEnableAfterCount", 1, "int")
IniReadS($g_aiSearchSearchesMax[$DB], $g_sProfileConfigPath, "search", "DBEnableBeforeCount", 9999, "int")
IniReadS($g_abSearchTropiesEnable[$DB], $g_sProfileConfigPath, "search", "ChkDBSearchTropies", False, "Bool")
IniReadS($g_aiSearchTrophiesMin[$DB], $g_sProfileConfigPath, "search", "DBEnableAfterTropies", 100, "int")
IniReadS($g_aiSearchTrophiesMax[$DB], $g_sProfileConfigPath, "search", "DBEnableBeforeTropies", 6000, "int")
IniReadS($g_abSearchCampsEnable[$DB], $g_sProfileConfigPath, "search", "ChkDBSearchCamps", False, "Bool")
IniReadS($g_aiSearchCampsPct[$DB], $g_sProfileConfigPath, "search", "DBEnableAfterArmyCamps", 100, "int")
Local $temp1, $temp2, $temp3
IniReadS($temp1, $g_sProfileConfigPath, "attack", "DBKingWait", $eHeroNone)
IniReadS($temp2, $g_sProfileConfigPath, "attack", "DBQueenWait", $eHeroNone)
IniReadS($temp3, $g_sProfileConfigPath, "attack", "DBWardenWait", $eHeroNone)
$g_aiSearchHeroWaitEnable[$DB] = BitOR(Int($temp1 > $eHeroNone ? $eHeroKing : 0), Int($temp2 > $eHeroNone ? $eHeroQueen : 0), Int($temp3 > $eHeroNone ? $eHeroWarden : 0))
IniReadS($g_aiSearchNotWaitHeroesEnable[$DB], $g_sProfileConfigPath, "attack", "DBNotWaitHeroes", 0, "int")
$g_iHeroWaitAttackNoBit[$DB][0] =($temp1 > $eHeroNone) ? 1 : 0
$g_iHeroWaitAttackNoBit[$DB][1] =($temp2 > $eHeroNone) ? 1 : 0
$g_iHeroWaitAttackNoBit[$DB][2] =($temp3 > $eHeroNone) ? 1 : 0
IniReadS($g_abSearchSpellsWaitEnable[$DB], $g_sProfileConfigPath, "search", "ChkDBSpellsWait", False, "Bool")
IniReadS($g_abSearchCastleSpellsWaitEnable[$DB], $g_sProfileConfigPath, "search", "ChkDBCastleSpellWait", False, "Bool")
IniReadS($g_abSearchCastleTroopsWaitEnable[$DB], $g_sProfileConfigPath, "search", "ChkDBCastleTroopsWait", False, "Bool")
IniReadS($g_aiSearchCastleSpellsWaitRegular[$DB], $g_sProfileConfigPath, "search", "cmbDBWaitForCastleSpell", 0, "int")
IniReadS($g_aiSearchCastleSpellsWaitDark[$DB], $g_sProfileConfigPath, "search", "cmbDBWaitForCastleSpell2", 0, "int")
IniReadS($g_aiFilterMeetGE[$DB], $g_sProfileConfigPath, "search", "DBMeetGE", 1, "int")
IniReadS($g_aiFilterMinGold[$DB], $g_sProfileConfigPath, "search", "DBsearchGold", 80000, "int")
IniReadS($g_aiFilterMinElixir[$DB], $g_sProfileConfigPath, "search", "DBsearchElixir", 80000, "int")
IniReadS($g_aiFilterMinGoldPlusElixir[$DB], $g_sProfileConfigPath, "search", "DBsearchGoldPlusElixir", 160000, "int")
IniReadS($g_abFilterMeetDEEnable[$DB], $g_sProfileConfigPath, "search", "DBMeetDE", False, "Bool")
IniReadS($g_aiFilterMeetDEMin[$DB], $g_sProfileConfigPath, "search", "DBsearchDark", 0, "int")
IniReadS($g_abFilterMeetTrophyEnable[$DB], $g_sProfileConfigPath, "search", "DBMeetTrophy", False, "Bool")
IniReadS($g_aiFilterMeetTrophyMin[$DB], $g_sProfileConfigPath, "search", "DBsearchTrophy", 0, "int")
IniReadS($g_aiFilterMeetTrophyMax[$DB], $g_sProfileConfigPath, "search", "DBsearchTrophyMax", 99, "int")
IniReadS($g_abFilterMeetTH[$DB], $g_sProfileConfigPath, "search", "DBMeetTH", False, "Bool")
IniReadS($g_aiFilterMeetTHMin[$DB], $g_sProfileConfigPath, "search", "DBTHLevel", 0, "int")
IniReadS($g_abFilterMeetTHOutsideEnable[$DB], $g_sProfileConfigPath, "search", "DBMeetTHO", False, "Bool")
IniReadS($g_abFilterMaxMortarEnable[$DB], $g_sProfileConfigPath, "search", "DBCheckMortar", False, "Bool")
IniReadS($g_abFilterMaxWizTowerEnable[$DB], $g_sProfileConfigPath, "search", "DBCheckWizTower", False, "Bool")
IniReadS($g_abFilterMaxAirDefenseEnable[$DB], $g_sProfileConfigPath, "search", "DBCheckAirDefense", False, "Bool")
IniReadS($g_abFilterMaxXBowEnable[$DB], $g_sProfileConfigPath, "search", "DBCheckXBow", False, "Bool")
IniReadS($g_abFilterMaxInfernoEnable[$DB], $g_sProfileConfigPath, "search", "DBCheckInferno", False, "Bool")
IniReadS($g_abFilterMaxEagleEnable[$DB], $g_sProfileConfigPath, "search", "DBCheckEagle", False, "Bool")
IniReadS($g_aiFilterMaxMortarLevel[$DB], $g_sProfileConfigPath, "search", "DBWeakMortar", 5, "int")
IniReadS($g_aiFilterMaxWizTowerLevel[$DB], $g_sProfileConfigPath, "search", "DBWeakWizTower", 4, "int")
IniReadS($g_aiFilterMaxAirDefenseLevel[$DB], $g_sProfileConfigPath, "search", "DBWeakAirDefense", 7, "int")
IniReadS($g_aiFilterMaxXBowLevel[$DB], $g_sProfileConfigPath, "search", "DBWeakXBow", 4, "int")
IniReadS($g_aiFilterMaxInfernoLevel[$DB], $g_sProfileConfigPath, "search", "DBWeakInferno", 1, "int")
IniReadS($g_aiFilterMaxEagleLevel[$DB], $g_sProfileConfigPath, "search", "DBWeakEagle", 2, "int")
IniReadS($g_abFilterMeetOneConditionEnable[$DB], $g_sProfileConfigPath, "search", "DBMeetOne", False, "Bool")
EndFunc
Func ReadConfig_600_28_LB()
IniReadS($g_abAttackTypeEnable[$LB], $g_sProfileConfigPath, "search", "ABcheck", False, "Bool")
IniReadS($g_abSearchSearchesEnable[$LB], $g_sProfileConfigPath, "search", "ChkABSearchSearches", False, "Bool")
IniReadS($g_aiSearchSearchesMin[$LB], $g_sProfileConfigPath, "search", "ABEnableAfterCount", 1, "int")
IniReadS($g_aiSearchSearchesMax[$LB], $g_sProfileConfigPath, "search", "ABEnableBeforeCount", 9999, "int")
IniReadS($g_abSearchTropiesEnable[$LB], $g_sProfileConfigPath, "search", "ChkABSearchTropies", False, "Bool")
IniReadS($g_aiSearchTrophiesMin[$LB], $g_sProfileConfigPath, "search", "ABEnableAfterTropies", 100, "int")
IniReadS($g_aiSearchTrophiesMax[$LB], $g_sProfileConfigPath, "search", "ABEnableBeforeTropies", 6000, "int")
IniReadS($g_abSearchCampsEnable[$LB], $g_sProfileConfigPath, "search", "ChkABSearchCamps", False, "Bool")
IniReadS($g_aiSearchCampsPct[$LB], $g_sProfileConfigPath, "search", "ABEnableAfterArmyCamps", 100, "int")
Local $temp1, $temp2, $temp3
IniReadS($temp1, $g_sProfileConfigPath, "attack", "ABKingWait", $eHeroNone)
IniReadS($temp2, $g_sProfileConfigPath, "attack", "ABQueenWait", $eHeroNone)
IniReadS($temp3, $g_sProfileConfigPath, "attack", "ABWardenWait", $eHeroNone)
$g_aiSearchHeroWaitEnable[$LB] = BitOR(Int($temp1 > $eHeroNone ? $eHeroKing : 0), Int($temp2 > $eHeroNone ? $eHeroQueen : 0), Int($temp3 > $eHeroNone ? $eHeroWarden : 0))
IniReadS($g_aiSearchNotWaitHeroesEnable[$LB], $g_sProfileConfigPath, "attack", "ABNotWaitHeroes", 0, "int")
$g_iHeroWaitAttackNoBit[$LB][0] =($temp1 > $eHeroNone) ? 1 : 0
$g_iHeroWaitAttackNoBit[$LB][1] =($temp2 > $eHeroNone) ? 1 : 0
$g_iHeroWaitAttackNoBit[$LB][2] =($temp3 > $eHeroNone) ? 1 : 0
IniReadS($g_abSearchSpellsWaitEnable[$LB], $g_sProfileConfigPath, "search", "ChkABSpellsWait", False, "Bool")
IniReadS($g_abSearchCastleSpellsWaitEnable[$LB], $g_sProfileConfigPath, "search", "ChkABCastleSpellWait", False, "Bool")
IniReadS($g_abSearchCastleTroopsWaitEnable[$LB], $g_sProfileConfigPath, "search", "ChkABCastleTroopsWait", False, "Bool")
IniReadS($g_aiSearchCastleSpellsWaitRegular[$LB], $g_sProfileConfigPath, "search", "cmbABWaitForCastleSpell", 0, "int")
IniReadS($g_aiSearchCastleSpellsWaitDark[$LB], $g_sProfileConfigPath, "search", "cmbABWaitForCastleSpell2", 0, "int")
IniReadS($g_aiFilterMeetGE[$LB], $g_sProfileConfigPath, "search", "ABMeetGE", 2, "int")
IniReadS($g_aiFilterMinGold[$LB], $g_sProfileConfigPath, "search", "ABsearchGold", 80000, "int")
IniReadS($g_aiFilterMinElixir[$LB], $g_sProfileConfigPath, "search", "ABsearchElixir", 80000, "int")
IniReadS($g_aiFilterMinGoldPlusElixir[$LB], $g_sProfileConfigPath, "search", "ABsearchGoldPlusElixir", 160000, "int")
IniReadS($g_abFilterMeetDEEnable[$LB], $g_sProfileConfigPath, "search", "ABMeetDE", False, "Bool")
IniReadS($g_aiFilterMeetDEMin[$LB], $g_sProfileConfigPath, "search", "ABsearchDark", 0, "int")
IniReadS($g_abFilterMeetTrophyEnable[$LB], $g_sProfileConfigPath, "search", "ABMeetTrophy", False, "Bool")
IniReadS($g_aiFilterMeetTrophyMin[$LB], $g_sProfileConfigPath, "search", "ABsearchTrophy", 0, "int")
IniReadS($g_aiFilterMeetTrophyMax[$LB], $g_sProfileConfigPath, "search", "ABsearchTrophyMax", 99, "int")
IniReadS($g_abFilterMeetTH[$LB], $g_sProfileConfigPath, "search", "ABMeetTH", False, "Bool")
IniReadS($g_aiFilterMeetTHMin[$LB], $g_sProfileConfigPath, "search", "ABTHLevel", 0, "int")
IniReadS($g_abFilterMeetTHOutsideEnable[$LB], $g_sProfileConfigPath, "search", "ABMeetTHO", False, "Bool")
IniReadS($g_abFilterMaxMortarEnable[$LB], $g_sProfileConfigPath, "search", "ABCheckMortar", False, "Bool")
IniReadS($g_abFilterMaxWizTowerEnable[$LB], $g_sProfileConfigPath, "search", "ABCheckWizTower", False, "Bool")
IniReadS($g_abFilterMaxAirDefenseEnable[$LB], $g_sProfileConfigPath, "search", "ABCheckAirDefense", False, "Bool")
IniReadS($g_abFilterMaxXBowEnable[$LB], $g_sProfileConfigPath, "search", "ABCheckXBow", False, "Bool")
IniReadS($g_abFilterMaxInfernoEnable[$LB], $g_sProfileConfigPath, "search", "ABCheckInferno", False, "Bool")
IniReadS($g_abFilterMaxEagleEnable[$LB], $g_sProfileConfigPath, "search", "ABCheckEagle", False, "Bool")
IniReadS($g_aiFilterMaxMortarLevel[$LB], $g_sProfileConfigPath, "search", "ABWeakMortar", 5, "int")
IniReadS($g_aiFilterMaxWizTowerLevel[$LB], $g_sProfileConfigPath, "search", "ABWeakWizTower", 4, "int")
IniReadS($g_aiFilterMaxAirDefenseLevel[$LB], $g_sProfileConfigPath, "search", "ABWeakAirDefense", 7, "int")
IniReadS($g_aiFilterMaxXBowLevel[$LB], $g_sProfileConfigPath, "search", "ABWeakXBow", 4, "int")
IniReadS($g_aiFilterMaxInfernoLevel[$LB], $g_sProfileConfigPath, "search", "ABWeakInferno", 1, "int")
IniReadS($g_aiFilterMaxEagleLevel[$LB], $g_sProfileConfigPath, "search", "ABWeakEagle", 2, "int")
IniReadS($g_abFilterMeetOneConditionEnable[$LB], $g_sProfileConfigPath, "search", "ABMeetOne", False, "Bool")
EndFunc
Func ReadConfig_600_28_TS()
IniReadS($g_abAttackTypeEnable[$TS], $g_sProfileConfigPath, "search", "TScheck", False, "Bool")
IniReadS($g_abSearchSearchesEnable[$TS], $g_sProfileConfigPath, "search", "ChkTSSearchSearches", False, "Bool")
IniReadS($g_aiSearchSearchesMin[$TS], $g_sProfileConfigPath, "search", "TSEnableAfterCount", 1, "int")
IniReadS($g_aiSearchSearchesMax[$TS], $g_sProfileConfigPath, "search", "TSEnableBeforeCount", 9999, "int")
IniReadS($g_abSearchTropiesEnable[$TS], $g_sProfileConfigPath, "search", "ChkTSSearchTropies", False, "Bool")
IniReadS($g_aiSearchTrophiesMin[$TS], $g_sProfileConfigPath, "search", "TSEnableAfterTropies", 100, "int")
IniReadS($g_aiSearchTrophiesMax[$TS], $g_sProfileConfigPath, "search", "TSEnableBeforeTropies", 6000, "int")
IniReadS($g_abSearchCampsEnable[$TS], $g_sProfileConfigPath, "search", "ChkTSSearchCamps", False, "Bool")
IniReadS($g_aiSearchCampsPct[$TS], $g_sProfileConfigPath, "search", "TSEnableAfterArmyCamps", 100, "int")
IniReadS($g_aiFilterMeetGE[$TS], $g_sProfileConfigPath, "search", "TSMeetGE", 1, "int")
IniReadS($g_aiFilterMinGold[$TS], $g_sProfileConfigPath, "search", "TSsearchGold", 80000, "int")
IniReadS($g_aiFilterMinElixir[$TS], $g_sProfileConfigPath, "search", "TSsearchElixir", 80000, "int")
IniReadS($g_aiFilterMinGoldPlusElixir[$TS], $g_sProfileConfigPath, "search", "TSsearchGoldPlusElixir", 160000, "int")
IniReadS($g_abFilterMeetDEEnable[$TS], $g_sProfileConfigPath, "search", "TSMeetDE", False, "Bool")
IniReadS($g_aiFilterMeetDEMin[$TS], $g_sProfileConfigPath, "search", "TSsearchDark", 600, "int")
IniReadS($g_iAtkTSAddTilesWhileTrain, $g_sProfileConfigPath, "search", "SWTtiles", 1, "int")
IniReadS($g_iAtkTSAddTilesFullTroops, $g_sProfileConfigPath, "search", "THaddTiles", 2, "int")
EndFunc
Func ReadConfig_600_29()
IniReadS($g_iActivateQueen, $g_sProfileConfigPath, "attack", "ActivateQueen", 0, "int")
IniReadS($g_iActivateKing, $g_sProfileConfigPath, "attack", "ActivateKing", 0, "int")
IniReadS($g_iActivateWarden, $g_sProfileConfigPath, "attack", "ActivateWarden", 0, "int")
IniReadS($g_iDelayActivateQueen, $g_sProfileConfigPath, "attack", "delayActivateQueen", 9000, "int")
IniReadS($g_iDelayActivateKing, $g_sProfileConfigPath, "attack", "delayActivateKing", 9000, "int")
IniReadS($g_iDelayActivateWarden, $g_sProfileConfigPath, "attack", "delayActivateWarden", 10000, "int")
$g_bAttackPlannerEnable =(IniRead($g_sProfileConfigPath, "planned", "chkAttackPlannerEnable", "0") = "1")
$g_bAttackPlannerCloseCoC =(IniRead($g_sProfileConfigPath, "planned", "chkAttackPlannerCloseCoC", "0") = "1")
$g_bAttackPlannerCloseAll =(IniRead($g_sProfileConfigPath, "planned", "chkAttackPlannerCloseAll", "0") = "1")
$g_bAttackPlannerSuspendComputer =(IniRead($g_sProfileConfigPath, "planned", "chkAttackPlannerSuspendComputer", "0") = "1")
$g_bAttackPlannerRandomEnable =(IniRead($g_sProfileConfigPath, "planned", "chkAttackPlannerRandom", "0") = "1")
$g_iAttackPlannerRandomTime = Int(IniRead($g_sProfileConfigPath, "planned", "cmbAttackPlannerRandom", 4))
$g_bAttackPlannerDayLimit =(IniRead($g_sProfileConfigPath, "planned", "chkAttackPlannerDayLimit", "0") = "1")
$g_iAttackPlannerDayMin = Int(IniRead($g_sProfileConfigPath, "planned", "cmbAttackPlannerDayMin", 12))
$g_iAttackPlannerDayMax = Int(IniRead($g_sProfileConfigPath, "planned", "cmbAttackPlannerDayMax", 15))
$g_abPlannedAttackWeekDays = StringSplit(IniRead($g_sProfileConfigPath, "planned", "attackDays", "1|1|1|1|1|1|1"), "|", $STR_NOCOUNT)
For $i = 0 To 6
$g_abPlannedAttackWeekDays[$i] =($g_abPlannedAttackWeekDays[$i] = "1")
Next
$g_abPlannedattackHours = StringSplit(IniRead($g_sProfileConfigPath, "planned", "attackHours", "1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1"), "|", $STR_NOCOUNT)
For $i = 0 To 23
$g_abPlannedattackHours[$i] =($g_abPlannedattackHours[$i] = "1")
Next
$g_bPlannedDropCCHoursEnable =(IniRead($g_sProfileConfigPath, "planned", "DropCCEnable", "0") = "1")
$g_abPlannedDropCCHours = StringSplit(IniRead($g_sProfileConfigPath, "planned", "DropCCHours", "1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1"), "|", $STR_NOCOUNT)
For $i = 0 To 23
$g_abPlannedDropCCHours[$i] =($g_abPlannedDropCCHours[$i] = "1")
Next
IniReadS($g_bUseCCBalanced, $g_sProfileConfigPath, "ClanClastle", "BalanceCC", False, "Bool")
IniReadS($g_iCCDonated, $g_sProfileConfigPath, "ClanClastle", "BalanceCCDonated", 1, "int")
IniReadS($g_iCCReceived, $g_sProfileConfigPath, "ClanClastle", "BalanceCCReceived", 1, "int")
EndFunc
Func ReadConfig_600_29_DB()
IniReadS($g_aiAttackAlgorithm[$DB], $g_sProfileConfigPath, "attack", "DBAtkAlgorithm", 0, "int")
IniReadS($g_aiAttackTroopSelection[$DB], $g_sProfileConfigPath, "attack", "DBSelectTroop", 0, "int")
Local $temp1, $temp2, $temp3
IniReadS($temp1, $g_sProfileConfigPath, "attack", "DBKingAtk", $eHeroNone)
IniReadS($temp2, $g_sProfileConfigPath, "attack", "DBQueenAtk", $eHeroNone)
IniReadS($temp3, $g_sProfileConfigPath, "attack", "DBWardenAtk", $eHeroNone)
$g_aiAttackUseHeroes[$DB] = BitOR(Int($temp1), Int($temp2), Int($temp3))
IniReadS($g_abAttackDropCC[$DB], $g_sProfileConfigPath, "attack", "DBDropCC", False, "Bool")
IniReadS($g_abAttackUseLightSpell[$DB], $g_sProfileConfigPath, "attack", "DBLightSpell", False, "Bool")
IniReadS($g_abAttackUseHealSpell[$DB], $g_sProfileConfigPath, "attack", "DBHealSpell", False, "Bool")
IniReadS($g_abAttackUseRageSpell[$DB], $g_sProfileConfigPath, "attack", "DBRageSpell", False, "Bool")
IniReadS($g_abAttackUseJumpSpell[$DB], $g_sProfileConfigPath, "attack", "DBJumpSpell", False, "Bool")
IniReadS($g_abAttackUseFreezeSpell[$DB], $g_sProfileConfigPath, "attack", "DBFreezeSpell", False, "Bool")
IniReadS($g_abAttackUsePoisonSpell[$DB], $g_sProfileConfigPath, "attack", "DBPoisonSpell", False, "Bool")
IniReadS($g_abAttackUseEarthquakeSpell[$DB], $g_sProfileConfigPath, "attack", "DBEarthquakeSpell", False, "Bool")
IniReadS($g_abAttackUseHasteSpell[$DB], $g_sProfileConfigPath, "attack", "DBHasteSpell", False, "Bool")
IniReadS($g_abAttackUseCloneSpell[$DB], $g_sProfileConfigPath, "attack", "DBCloneSpell", False, "Bool")
IniReadS($g_abAttackUseSkeletonSpell[$DB], $g_sProfileConfigPath, "attack", "DBSkeletonSpell", False, "Bool")
IniReadS($g_bTHSnipeBeforeEnable[$DB], $g_sProfileConfigPath, "attack", "THSnipeBeforeDBEnable", False, "Bool")
IniReadS($g_iTHSnipeBeforeTiles[$DB], $g_sProfileConfigPath, "attack", "THSnipeBeforeDBTiles", 0, "int")
IniReadS($g_iTHSnipeBeforeScript[$DB], $g_sProfileConfigPath, "attack", "THSnipeBeforeDBScript", "bam")
IniReadS($g_aiAttackStdDropOrder[$DB], $g_sProfileConfigPath, "attack", "DBStandardAlgorithm", 0, "int")
IniReadS($g_aiAttackStdDropSides[$DB], $g_sProfileConfigPath, "attack", "DBDeploy", 3, "int")
IniReadS($g_aiAttackStdUnitDelay[$DB], $g_sProfileConfigPath, "attack", "DBUnitD", 4, "int")
IniReadS($g_aiAttackStdWaveDelay[$DB], $g_sProfileConfigPath, "attack", "DBWaveD", 4, "int")
IniReadS($g_abAttackStdRandomizeDelay[$DB], $g_sProfileConfigPath, "attack", "DBRandomSpeedAtk", True, "Bool")
IniReadS($g_abAttackStdSmartAttack[$DB], $g_sProfileConfigPath, "attack", "DBSmartAttackRedArea", True, "Bool")
IniReadS($g_aiAttackStdSmartDeploy[$DB], $g_sProfileConfigPath, "attack", "DBSmartAttackDeploy", 0, "int")
IniReadS($g_abAttackStdSmartNearCollectors[$DB][0], $g_sProfileConfigPath, "attack", "DBSmartAttackGoldMine", False, "Bool")
IniReadS($g_abAttackStdSmartNearCollectors[$DB][1], $g_sProfileConfigPath, "attack", "DBSmartAttackElixirCollector", False, "Bool")
IniReadS($g_abAttackStdSmartNearCollectors[$DB][2], $g_sProfileConfigPath, "attack", "DBSmartAttackDarkElixirDrill", False, "Bool")
IniReadS($g_aiAttackScrRedlineRoutine[$DB], $g_sProfileConfigPath, "attack", "RedlineRoutineDB", $g_aiAttackScrRedlineRoutine[$DB], "Int")
IniReadS($g_aiAttackScrDroplineEdge[$DB], $g_sProfileConfigPath, "attack", "DroplineEdgeDB", $g_aiAttackScrDroplineEdge[$DB], "Int")
IniReadS($g_sAttackScrScriptName[$DB], $g_sProfileConfigPath, "attack", "ScriptDB", "Barch four fingers")
IniReadS($g_iMilkAttackType, $g_sProfileConfigPath, "MilkingAttack", "MilkAttackType", 0, "int")
IniReadS($g_aiMilkFarmElixirParam, $g_sProfileConfigPath, "MilkingAttack", "LocateElixirLevel", "-1|-1|-1|-1|-1|-1|2|2|2")
$g_aiMilkFarmElixirParam = StringSplit($g_aiMilkFarmElixirParam, "|", 2)
IniReadS($g_bMilkFarmLocateElixir, $g_sProfileConfigPath, "MilkingAttack", "LocateElixir", True, "Bool")
IniReadS($g_bMilkFarmLocateMine, $g_sProfileConfigPath, "MilkingAttack", "LocateMine", True, "Bool")
IniReadS($g_bMilkFarmLocateDrill, $g_sProfileConfigPath, "MilkingAttack", "LocateDrill", True, "Bool")
IniReadS($g_iMilkFarmMineParam, $g_sProfileConfigPath, "MilkingAttack", "MineParam", 5, "int")
IniReadS($g_iMilkFarmDrillParam, $g_sProfileConfigPath, "MilkingAttack", "DrillParam", 1, "int")
IniReadS($g_iMilkFarmResMaxTilesFromBorder, $g_sProfileConfigPath, "MilkingAttack", "MaxTiles", 1, "int")
IniReadS($g_bMilkFarmAttackGoldMines, $g_sProfileConfigPath, "MilkingAttack", "AttackMine", True, "Bool")
IniReadS($g_bMilkFarmAttackElixirExtractors, $g_sProfileConfigPath, "MilkingAttack", "AttackElixir", True, "Bool")
IniReadS($g_bMilkFarmAttackDarkDrills, $g_sProfileConfigPath, "MilkingAttack", "AttackDrill", True, "Bool")
IniReadS($g_iMilkFarmLimitGold, $g_sProfileConfigPath, "MilkingAttack", "LimitGold", 9950000, "int")
IniReadS($g_iMilkFarmLimitElixir, $g_sProfileConfigPath, "MilkingAttack", "LimitElixir", 9950000, "int")
IniReadS($g_iMilkFarmLimitDark, $g_sProfileConfigPath, "MilkingAttack", "LimitDark", 200000, "int")
IniReadS($g_iMilkFarmTroopForWaveMin, $g_sProfileConfigPath, "MilkingAttack", "TroopForWaveMin", 4, "int")
IniReadS($g_iMilkFarmTroopForWaveMax, $g_sProfileConfigPath, "MilkingAttack", "TroopForWaveMax", 6, "int")
IniReadS($g_iMilkFarmTroopMaxWaves, $g_sProfileConfigPath, "MilkingAttack", "MaxWaves", 4, "int")
IniReadS($g_iMilkFarmDelayFromWavesMin, $g_sProfileConfigPath, "MilkingAttack", "DelayBetweenWavesMin", 3000, "int")
IniReadS($g_iMilkFarmDelayFromWavesMax, $g_sProfileConfigPath, "MilkingAttack", "DelayBetweenWavesMax", 5000, "int")
IniReadS($g_iMilkingAttackDropGoblinAlgorithm, $g_sProfileConfigPath, "MilkingAttack", "DropRandomPlace", 0, "int")
IniReadS($g_iMilkingAttackStructureOrder, $g_sProfileConfigPath, "MilkingAttack", "StructureOrder", 1, "int")
IniReadS($g_bMilkingAttackCheckStructureDestroyedBeforeAttack, $g_sProfileConfigPath, "MilkingAttack", "CheckStructureDestroyedBeforeAttack", False, "Bool")
IniReadS($g_bMilkingAttackCheckStructureDestroyedAfterAttack, $g_sProfileConfigPath, "MilkingAttack", "CheckStructureDestroyedAfterAttack", False, "Bool")
IniReadS($g_bMilkAttackAfterTHSnipeEnable, $g_sProfileConfigPath, "MilkingAttack", "MilkAttackAfterTHSnipe", False, "Bool")
IniReadS($g_iMilkFarmTHMaxTilesFromBorder, $g_sProfileConfigPath, "MilkingAttack", "TownhallTiles", 0, "int")
IniReadS($g_sMilkFarmAlgorithmTh, $g_sProfileConfigPath, "MilkingAttack", "TownHallAlgorithm", "Bam")
IniReadS($g_bMilkFarmSnipeEvenIfNoExtractorsFound, $g_sProfileConfigPath, "MilkingAttack", "TownHallHitAnyway", False, "Bool")
IniReadS($g_bMilkAttackAfterScriptedAtkEnable, $g_sProfileConfigPath, "MilkingAttack", "MilkAttackAfterScriptedAtk", False, "Bool")
IniReadS($g_sMilkAttackCSVscript, $g_sProfileConfigPath, "MilkingAttack", "MilkAttackCSVscript", "0")
IniReadS($g_bMilkFarmForceToleranceEnable, $g_sProfileConfigPath, "MilkingAttack", "MilkFarmForceTolerance", False, "Bool")
IniReadS($g_iMilkFarmForceToleranceNormal, $g_sProfileConfigPath, "MilkingAttack", "MilkFarmForcetolerancenormal", 60, "int")
IniReadS($g_iMilkFarmForceToleranceBoosted, $g_sProfileConfigPath, "MilkingAttack", "MilkFarmForcetoleranceboosted", 60, "int")
IniReadS($g_iMilkFarmForceToleranceDestroyed, $g_sProfileConfigPath, "MilkingAttack", "MilkFarmForcetolerancedestroyed", 60, "int")
EndFunc
Func ReadConfig_600_29_LB()
IniReadS($g_aiAttackAlgorithm[$LB], $g_sProfileConfigPath, "attack", "ABAtkAlgorithm", 0, "int")
IniReadS($g_aiAttackTroopSelection[$LB], $g_sProfileConfigPath, "attack", "ABSelectTroop", 0, "int")
Local $temp1, $temp2, $temp3
IniReadS($temp1, $g_sProfileConfigPath, "attack", "ABKingAtk", $eHeroNone)
IniReadS($temp2, $g_sProfileConfigPath, "attack", "ABQueenAtk", $eHeroNone)
IniReadS($temp3, $g_sProfileConfigPath, "attack", "ABWardenAtk", $eHeroNone)
$g_aiAttackUseHeroes[$LB] = BitOR(Int($temp1), Int($temp2), Int($temp3))
IniReadS($g_abAttackDropCC[$LB], $g_sProfileConfigPath, "attack", "ABDropCC", False, "Bool")
IniReadS($g_abAttackUseLightSpell[$LB], $g_sProfileConfigPath, "attack", "ABLightSpell", False, "Bool")
IniReadS($g_abAttackUseHealSpell[$LB], $g_sProfileConfigPath, "attack", "ABHealSpell", False, "Bool")
IniReadS($g_abAttackUseRageSpell[$LB], $g_sProfileConfigPath, "attack", "ABRageSpell", False, "Bool")
IniReadS($g_abAttackUseJumpSpell[$LB], $g_sProfileConfigPath, "attack", "ABJumpSpell", False, "Bool")
IniReadS($g_abAttackUseFreezeSpell[$LB], $g_sProfileConfigPath, "attack", "ABFreezeSpell", False, "Bool")
IniReadS($g_abAttackUsePoisonSpell[$LB], $g_sProfileConfigPath, "attack", "ABPoisonSpell", False, "Bool")
IniReadS($g_abAttackUseEarthquakeSpell[$LB], $g_sProfileConfigPath, "attack", "ABEarthquakeSpell", False, "Bool")
IniReadS($g_abAttackUseHasteSpell[$LB], $g_sProfileConfigPath, "attack", "ABHasteSpell", False, "Bool")
IniReadS($g_abAttackUseCloneSpell[$LB], $g_sProfileConfigPath, "attack", "ABCloneSpell", False, "Bool")
IniReadS($g_abAttackUseSkeletonSpell[$LB], $g_sProfileConfigPath, "attack", "ABSkeletonSpell", False, "Bool")
IniReadS($g_bTHSnipeBeforeEnable[$LB], $g_sProfileConfigPath, "attack", "THSnipeBeforeLBEnable", False, "Bool")
IniReadS($g_iTHSnipeBeforeTiles[$LB], $g_sProfileConfigPath, "attack", "THSnipeBeforeLBTiles", 0, "int")
IniReadS($g_iTHSnipeBeforeScript[$LB], $g_sProfileConfigPath, "attack", "THSnipeBeforeLBScript", "bam")
IniReadS($g_aiAttackStdDropOrder[$LB], $g_sProfileConfigPath, "attack", "LBStandardAlgorithm", 0, "int")
IniReadS($g_aiAttackStdDropSides[$LB], $g_sProfileConfigPath, "attack", "ABDeploy", 0, "int")
IniReadS($g_aiAttackStdUnitDelay[$LB], $g_sProfileConfigPath, "attack", "ABUnitD", 4, "int")
IniReadS($g_aiAttackStdWaveDelay[$LB], $g_sProfileConfigPath, "attack", "ABWaveD", 4, "int")
IniReadS($g_abAttackStdRandomizeDelay[$LB], $g_sProfileConfigPath, "attack", "ABRandomSpeedAtk", True, "Bool")
IniReadS($g_abAttackStdSmartAttack[$LB], $g_sProfileConfigPath, "attack", "ABSmartAttackRedArea", True, "Bool")
IniReadS($g_aiAttackStdSmartDeploy[$LB], $g_sProfileConfigPath, "attack", "ABSmartAttackDeploy", 1, "int")
IniReadS($g_abAttackStdSmartNearCollectors[$LB][0], $g_sProfileConfigPath, "attack", "ABSmartAttackGoldMine", False, "Bool")
IniReadS($g_abAttackStdSmartNearCollectors[$LB][1], $g_sProfileConfigPath, "attack", "ABSmartAttackElixirCollector", False, "Bool")
IniReadS($g_abAttackStdSmartNearCollectors[$LB][2], $g_sProfileConfigPath, "attack", "ABSmartAttackDarkElixirDrill", False, "Bool")
IniReadS($g_aiAttackScrRedlineRoutine[$LB], $g_sProfileConfigPath, "attack", "RedlineRoutineAB", $g_aiAttackScrRedlineRoutine[$LB], "Int")
IniReadS($g_aiAttackScrDroplineEdge[$LB], $g_sProfileConfigPath, "attack", "DroplineEdgeAB", $g_aiAttackScrDroplineEdge[$LB], "Int")
IniReadS($g_sAttackScrScriptName[$LB], $g_sProfileConfigPath, "attack", "ScriptAB", "Barch four fingers")
EndFunc
Func ReadConfig_600_29_TS()
IniReadS($g_aiAttackTroopSelection[$TS], $g_sProfileConfigPath, "attack", "TSSelectTroop", 0, "int")
Local $temp1, $temp2, $temp3
IniReadS($temp1, $g_sProfileConfigPath, "attack", "TSKingAtk", $eHeroNone)
IniReadS($temp2, $g_sProfileConfigPath, "attack", "TSQueenAtk", $eHeroNone)
IniReadS($temp3, $g_sProfileConfigPath, "attack", "TSWardenAtk", $eHeroNone)
$g_aiAttackUseHeroes[$TS] = BitOR(Int($temp1), Int($temp2), Int($temp3))
IniReadS($g_abAttackDropCC[$TS], $g_sProfileConfigPath, "attack", "TSDropCC", False, "Bool")
IniReadS($g_abAttackUseHealSpell[$TS], $g_sProfileConfigPath, "attack", "TSHealSpell", False, "Bool")
IniReadS($g_abAttackUseLightSpell[$TS], $g_sProfileConfigPath, "attack", "TSLightSpell", False, "Bool")
IniReadS($g_abAttackUseRageSpell[$TS], $g_sProfileConfigPath, "attack", "TSRageSpell", False, "Bool")
IniReadS($g_abAttackUseJumpSpell[$TS], $g_sProfileConfigPath, "attack", "TSJumpSpell", False, "Bool")
IniReadS($g_abAttackUseFreezeSpell[$TS], $g_sProfileConfigPath, "attack", "TSFreezeSpell", False, "Bool")
IniReadS($g_abAttackUsePoisonSpell[$TS], $g_sProfileConfigPath, "attack", "TSPoisonSpell", False, "Bool")
IniReadS($g_abAttackUseEarthquakeSpell[$TS], $g_sProfileConfigPath, "attack", "TSEarthquakeSpell", False, "Bool")
IniReadS($g_abAttackUseHasteSpell[$TS], $g_sProfileConfigPath, "attack", "TSHasteSpell", False, "Bool")
IniReadS($g_sAtkTSType, $g_sProfileConfigPath, "attack", "AttackTHType", "bam")
EndFunc
Func ReadConfig_600_30()
$g_bShareAttackEnable =(IniRead($g_sProfileConfigPath, "shareattack", "ShareAttack", "0") = "1")
$g_iShareMinGold = Int(IniRead($g_sProfileConfigPath, "shareattack", "minGold", 200000))
$g_iShareMinElixir = Int(IniRead($g_sProfileConfigPath, "shareattack", "minElixir", 200000))
$g_iShareMinDark = Int(IniRead($g_sProfileConfigPath, "shareattack", "minDark", 100))
$g_sShareMessage = IniRead($g_sProfileConfigPath, "shareattack", "Message", "Nice|Good|Thanks|Wowwww")
IniReadS($g_bTakeLootSnapShot, $g_sProfileConfigPath, "attack", "TakeLootSnapShot", False, "Bool")
IniReadS($g_bScreenshotLootInfo, $g_sProfileConfigPath, "attack", "ScreenshotLootInfo", False, "Bool")
EndFunc
Func ReadConfig_600_30_DB()
IniReadS($g_abStopAtkNoLoot1Enable[$DB], $g_sProfileConfigPath, "endbattle", "chkDBTimeStopAtk", True, "Bool")
IniReadS($g_aiStopAtkNoLoot1Time[$DB], $g_sProfileConfigPath, "endbattle", "txtDBTimeStopAtk", 15, "int")
IniReadS($g_abStopAtkNoLoot2Enable[$DB], $g_sProfileConfigPath, "endbattle", "chkDBTimeStopAtk2", False, "Bool")
IniReadS($g_aiStopAtkNoLoot2Time[$DB], $g_sProfileConfigPath, "endbattle", "txtDBTimeStopAtk2", 7, "int")
IniReadS($g_aiStopAtkNoLoot2MinGold[$DB], $g_sProfileConfigPath, "endbattle", "txtDBMinGoldStopAtk2", 1000, "int")
IniReadS($g_aiStopAtkNoLoot2MinElixir[$DB], $g_sProfileConfigPath, "endbattle", "txtDBMinElixirStopAtk2", 1000, "int")
IniReadS($g_aiStopAtkNoLoot2MinDark[$DB], $g_sProfileConfigPath, "endbattle", "txtDBMinDarkElixirStopAtk2", 50, "int")
IniReadS($g_abStopAtkNoResources[$DB], $g_sProfileConfigPath, "endbattle", "chkDBEndNoResources", False, "Bool")
IniReadS($g_abStopAtkOneStar[$DB], $g_sProfileConfigPath, "endbattle", "chkDBEndOneStar", False, "Bool")
IniReadS($g_abStopAtkTwoStars[$DB], $g_sProfileConfigPath, "endbattle", "chkDBEndTwoStars", False, "Bool")
IniReadS($g_abStopAtkPctHigherEnable[$DB], $g_sProfileConfigPath, "endbattle", "chkDBPercentageHigher", False, "Bool")
IniReadS($g_aiStopAtkPctHigherAmt[$DB], $g_sProfileConfigPath, "endbattle", "txtDBPercentageHigher", 50, "int")
IniReadS($g_abStopAtkPctNoChangeEnable[$DB], $g_sProfileConfigPath, "endbattle", "chkDBPercentageChange", False, "Bool")
IniReadS($g_aiStopAtkPctNoChangeTime[$DB], $g_sProfileConfigPath, "endbattle", "txtDBPercentageChange", 15, "int")
EndFunc
Func ReadConfig_600_30_LB()
IniReadS($g_abStopAtkNoLoot1Enable[$LB], $g_sProfileConfigPath, "endbattle", "chkABTimeStopAtk", True, "Bool")
IniReadS($g_aiStopAtkNoLoot1Time[$LB], $g_sProfileConfigPath, "endbattle", "txtABTimeStopAtk", 20, "int")
IniReadS($g_abStopAtkNoLoot2Enable[$LB], $g_sProfileConfigPath, "endbattle", "chkABTimeStopAtk2", False, "Bool")
IniReadS($g_aiStopAtkNoLoot2Time[$LB], $g_sProfileConfigPath, "endbattle", "txtABTimeStopAtk2", 7, "int")
IniReadS($g_aiStopAtkNoLoot2MinGold[$LB], $g_sProfileConfigPath, "endbattle", "txtABMinGoldStopAtk2", 1000, "int")
IniReadS($g_aiStopAtkNoLoot2MinElixir[$LB], $g_sProfileConfigPath, "endbattle", "txtABMinElixirStopAtk2", 1000, "int")
IniReadS($g_aiStopAtkNoLoot2MinDark[$LB], $g_sProfileConfigPath, "endbattle", "txtABMinDarkElixirStopAtk2", 50, "int")
IniReadS($g_abStopAtkNoResources[$LB], $g_sProfileConfigPath, "endbattle", "chkABEndNoResources", False, "Bool")
IniReadS($g_abStopAtkOneStar[$LB], $g_sProfileConfigPath, "endbattle", "chkABEndOneStar", False, "Bool")
IniReadS($g_abStopAtkTwoStars[$LB], $g_sProfileConfigPath, "endbattle", "chkABEndTwoStars", False, "Bool")
IniReadS($g_bDESideEndEnable, $g_sProfileConfigPath, "endbattle", "chkDESideEB", False, "Bool")
IniReadS($g_iDESideEndMin, $g_sProfileConfigPath, "endbattle", "txtDELowEndMin", 25, "int")
IniReadS($g_bDESideDisableOther, $g_sProfileConfigPath, "endbattle", "chkDisableOtherEBO", False, "Bool")
IniReadS($g_bDESideEndBKWeak, $g_sProfileConfigPath, "endbattle", "chkDEEndBk", False, "Bool")
IniReadS($g_bDESideEndAQWeak, $g_sProfileConfigPath, "endbattle", "chkDEEndAq", False, "Bool")
IniReadS($g_bDESideEndOneStar, $g_sProfileConfigPath, "endbattle", "chkDEEndOneStar", False, "Bool")
IniReadS($g_abStopAtkPctHigherEnable[$LB], $g_sProfileConfigPath, "endbattle", "chkABPercentageHigher", False, "Bool")
IniReadS($g_aiStopAtkPctHigherAmt[$LB], $g_sProfileConfigPath, "endbattle", "txtABPercentageHigher", 50, "int")
IniReadS($g_abStopAtkPctNoChangeEnable[$LB], $g_sProfileConfigPath, "endbattle", "chkABPercentageChange", False, "Bool")
IniReadS($g_aiStopAtkPctNoChangeTime[$LB], $g_sProfileConfigPath, "endbattle", "txtABPercentageChange", 15, "int")
EndFunc
Func ReadConfig_600_30_TS()
IniReadS($g_bEndTSCampsEnable, $g_sProfileConfigPath, "search", "ChkTSSearchCamps2", False, "Bool")
IniReadS($g_iEndTSCampsPct, $g_sProfileConfigPath, "search", "TSEnableAfterArmyCamps2", 100, "int")
EndFunc
Func ReadConfig_600_31()
$g_abCollectorLevelEnabled[6] = 0
For $i = 7 To 12
IniReadS($g_abCollectorLevelEnabled[$i], $g_sProfileConfigPath, "collectors", "lvl" & $i & "Enabled", True, "Bool")
Next
For $i = 6 To 12
IniReadS($g_aiCollectorLevelFill[$i], $g_sProfileConfigPath, "collectors", "lvl" & $i & "fill", 0, "int")
If $g_aiCollectorLevelFill[$i] > 1 Then $g_aiCollectorLevelFill[$i] = 1
Next
IniReadS($g_bCollectorFilterDisable, $g_sProfileConfigPath, "search", "chkDisableCollectorsFilter", False, "Bool")
IniReadS($g_iCollectorMatchesMin, $g_sProfileConfigPath, "collectors", "minmatches", $g_iCollectorMatchesMin)
If $g_iCollectorMatchesMin < 1 Or $g_iCollectorMatchesMin > 6 Then $g_iCollectorMatchesMin = 3
IniReadS($g_iCollectorToleranceOffset, $g_sProfileConfigPath, "collectors", "tolerance", 0, "int")
EndFunc
Func ReadConfig_600_32()
IniReadS($g_bDropTrophyEnable, $g_sProfileConfigPath, "search", "TrophyRange", False, "Bool")
IniReadS($g_iDropTrophyMin, $g_sProfileConfigPath, "search", "MinTrophy", 5000, "int")
IniReadS($g_iDropTrophyMax, $g_sProfileConfigPath, "search", "MaxTrophy", 5000, "int")
IniReadS($g_bDropTrophyUseHeroes, $g_sProfileConfigPath, "search", "chkTrophyHeroes", False, "Bool")
IniReadS($g_iDropTrophyHeroesPriority, $g_sProfileConfigPath, "search", "cmbTrophyHeroesPriority", 0, "int")
IniReadS($g_bDropTrophyAtkDead, $g_sProfileConfigPath, "search", "chkTrophyAtkDead", False, "Bool")
IniReadS($g_iDropTrophyArmyMinPct, $g_sProfileConfigPath, "search", "DTArmyMin", 70, "int")
EndFunc
Func ReadConfig_600_33()
IniReadS($g_bCustomDropOrderEnable, $g_sProfileConfigPath, "DropOrder", "chkDropOrder", False, "Bool")
For $p = 0 To UBound($g_aiCmbCustomDropOrder) - 1
IniReadS($g_aiCmbCustomDropOrder[$p], $g_sProfileConfigPath, "DropOrder", "cmbDropOrder" & $p, -1)
Next
EndFunc
Func ReadConfig_600_35_1()
$g_bDisableSplash =(IniRead($g_sProfileConfigPath, "General", "ChkDisableSplash", "0") = "1")
$g_bCheckVersion =(IniRead($g_sProfileConfigPath, "General", "ChkVersion", "1") = "1")
IniReadS($g_bDeleteLogs, $g_sProfileConfigPath, "deletefiles", "DeleteLogs", True, "Bool")
IniReadS($g_iDeleteLogsDays, $g_sProfileConfigPath, "deletefiles", "DeleteLogsDays", 2, "int")
IniReadS($g_bDeleteTemp, $g_sProfileConfigPath, "deletefiles", "DeleteTemp", True, "Bool")
IniReadS($g_iDeleteTempDays, $g_sProfileConfigPath, "deletefiles", "DeleteTempDays", 5, "int")
IniReadS($g_bDeleteLoots, $g_sProfileConfigPath, "deletefiles", "DeleteLoots", True, "Bool")
IniReadS($g_iDeleteLootsDays, $g_sProfileConfigPath, "deletefiles", "DeleteLootsDays", 2, "int")
IniReadS($g_bAutoStart, $g_sProfileConfigPath, "general", "AutoStart", False, "Bool")
IniReadS($g_iAutoStartDelay, $g_sProfileConfigPath, "general", "AutoStartDelay", 10, "int")
IniReadS($g_bRestarted, $g_sProfileConfigPath, "general", "Restarted", $g_bRestarted, "int")
If $g_bBotLaunchOption_Autostart = True Then $g_bRestarted = True
$g_bCheckGameLanguage =(IniRead($g_sProfileConfigPath, "General", "ChkLanguage", "1") = "1")
IniReadS($g_bAutoAlignEnable, $g_sProfileConfigPath, "general", "DisposeWindows", False, "Bool")
IniReadS($g_iAutoAlignPosition, $g_sProfileConfigPath, "general", "DisposeWindowsPos", "EMBED")
IniReadS($g_iAutoAlignOffsetX, $g_sProfileConfigPath, "other", "WAOffsetX", "")
IniReadS($g_iAutoAlignOffsetY, $g_sProfileConfigPath, "other", "WAOffsetY", "")
IniReadS($g_bHideWhenMinimized, $g_sProfileConfigPath, "general", "HideWhenMinimized", False, "Bool")
$g_bUseRandomClick =(IniRead($g_sProfileConfigPath, "other", "UseRandomClick", "0") = "1")
$g_bScreenshotPNGFormat =(IniRead($g_sProfileConfigPath, "other", "ScreenshotType", "0") = "1")
$g_bScreenshotHideName =(IniRead($g_sProfileConfigPath, "other", "ScreenshotHideName", "1") = "1")
IniReadS($g_iAnotherDeviceWaitTime, $g_sProfileConfigPath, "other", "txtTimeWakeUp", 0, "int")
$g_bForceSinglePBLogoff =(IniRead($g_sProfileConfigPath, "other", "chkSinglePBTForced", "0") = "1")
$g_iSinglePBForcedLogoffTime = Int(IniRead($g_sProfileConfigPath, "other", "ValueSinglePBTimeForced", 18))
$g_iSinglePBForcedEarlyExitTime = Int(IniRead($g_sProfileConfigPath, "other", "ValuePBTimeForcedExit", 15))
$g_bAutoResumeEnable =(IniRead($g_sProfileConfigPath, "other", "ChkAutoResume", "0") = "1")
$g_iAutoResumeTime = Int(IniRead($g_sProfileConfigPath, "other", "AutoResumeTime", 5))
IniReadS($g_bDisableNotifications, $g_sProfileConfigPath, "other", "ChkDisableNotifications", False, "Bool")
$g_bForceClanCastleDetection =(IniRead($g_sProfileConfigPath, "other", "ChkFixClanCastle", "0") = "1")
EndFunc
Func ReadConfig_600_35_2()
Local $sSwitchAccFile
$g_iCmbSwitchAcc = 0
$g_bChkSwitchAcc = False
For $g = 1 To 8
$sSwitchAccFile = $g_sProfilePath & "\SwitchAccount.0" & $g & ".ini"
If FileExists($sSwitchAccFile) = 0 Then ContinueLoop
Local $sProfile
Local $bEnabled
For $i = 1 To Int(IniRead($sSwitchAccFile, "SwitchAccount", "TotalCocAccount", 0)) + 1
$bEnabled = IniRead($sSwitchAccFile, "SwitchAccount", "Enable", "") = "1"
If $bEnabled Then
$bEnabled = IniRead($sSwitchAccFile, "SwitchAccount", "AccountNo." & $i, "") = "1"
If $bEnabled Then
$sProfile = IniRead($sSwitchAccFile, "SwitchAccount", "ProfileName." & $i, "")
If $sProfile = $g_sProfileCurrentName Then
$g_iCmbSwitchAcc = $g
ExitLoop
EndIf
EndIf
EndIf
Next
If $g_iCmbSwitchAcc Then
ReadConfig_SwitchAccounts()
ExitLoop
EndIf
Next
EndFunc
Func ReadConfig_SwitchAccounts()
If $g_iCmbSwitchAcc Then
Local $sSwitchAccFile = $g_sProfilePath & "\SwitchAccount.0" & $g_iCmbSwitchAcc & ".ini"
$g_bChkSwitchAcc = IniRead($sSwitchAccFile, "SwitchAccount", "Enable", "0") = "1"
$g_bChkGooglePlay = IniRead($sSwitchAccFile, "SwitchAccount", "GooglePlay", "0") = "1"
$g_bChkSuperCellID = IniRead($sSwitchAccFile, "SwitchAccount", "SuperCellID", "0") = "1"
$g_bChkSharedPrefs = IniRead($sSwitchAccFile, "SwitchAccount", "SharedPrefs", "0") = "1"
$g_bChkSmartSwitch = IniRead($sSwitchAccFile, "SwitchAccount", "SmartSwitch", "0") = "1"
$g_bDonateLikeCrazy = IniRead($sSwitchAccFile, "SwitchAccount", "DonateLikeCrazy", "0") = "1"
$g_iTotalAcc = Int(IniRead($sSwitchAccFile, "SwitchAccount", "TotalCocAccount", "-1"))
$g_iTrainTimeToSkip = Int(IniRead($sSwitchAccFile, "SwitchAccount", "TrainTimeToSkip", "1"))
For $i = 1 To 8
$g_abAccountNo[$i - 1] = IniRead($sSwitchAccFile, "SwitchAccount", "AccountNo." & $i, "") = "1"
$g_asProfileName[$i - 1] = IniRead($sSwitchAccFile, "SwitchAccount", "ProfileName." & $i, "")
$g_abDonateOnly[$i - 1] = IniRead($sSwitchAccFile, "SwitchAccount", "DonateOnly." & $i, "0") = "1"
Next
EndIf
EndFunc
Func ReadConfig_600_52_1()
$g_bQuickTrainEnable =(IniRead($g_sProfileConfigPath, "other", "ChkUseQTrain", "0") = "1")
$g_bQuickTrainArmy[0] =(IniRead($g_sProfileConfigPath, "troop", "QuickTrainArmy1", "0") = "1")
$g_bQuickTrainArmy[1] =(IniRead($g_sProfileConfigPath, "troop", "QuickTrainArmy2", "0") = "1")
$g_bQuickTrainArmy[2] =(IniRead($g_sProfileConfigPath, "troop", "QuickTrainArmy3", "0") = "1")
EndFunc
Func ReadConfig_600_52_2()
For $T = 0 To $eTroopCount - 1
Local $tempTroopCount, $tempTroopLevel
Switch $T
Case $eTroopBarbarian
IniReadS($tempTroopCount, $g_sProfileConfigPath, "troop", $g_asTroopShortNames[$T], 58, "int")
IniReadS($tempTroopLevel, $g_sProfileConfigPath, "LevelTroop", $g_asTroopShortNames[$T], 1, "int")
Case $eTroopArcher
IniReadS($tempTroopCount, $g_sProfileConfigPath, "troop", $g_asTroopShortNames[$T], 115, "int")
IniReadS($tempTroopLevel, $g_sProfileConfigPath, "LevelTroop", $g_asTroopShortNames[$T], 1, "int")
Case $eTroopGoblin
IniReadS($tempTroopCount, $g_sProfileConfigPath, "troop", $g_asTroopShortNames[$T], 19, "int")
IniReadS($tempTroopLevel, $g_sProfileConfigPath, "LevelTroop", $g_asTroopShortNames[$T], 1, "int")
Case $eTroopGiant
IniReadS($tempTroopCount, $g_sProfileConfigPath, "troop", $g_asTroopShortNames[$T], 4, "int")
IniReadS($tempTroopLevel, $g_sProfileConfigPath, "LevelTroop", $g_asTroopShortNames[$T], 1, "int")
Case $eTroopWallBreaker
IniReadS($tempTroopCount, $g_sProfileConfigPath, "troop", $g_asTroopShortNames[$T], 4, "int")
IniReadS($tempTroopLevel, $g_sProfileConfigPath, "LevelTroop", $g_asTroopShortNames[$T], 1, "int")
Case Else
IniReadS($tempTroopCount, $g_sProfileConfigPath, "troop", $g_asTroopShortNames[$T], 0, "int")
IniReadS($tempTroopLevel, $g_sProfileConfigPath, "LevelTroop", $g_asTroopShortNames[$T], 0, "int")
EndSwitch
$g_aiArmyCompTroops[$T] = $tempTroopCount
$g_aiTrainArmyTroopLevel[$T] = $tempTroopLevel
Next
For $S = 0 To $eSpellCount - 1
IniReadS($g_aiArmyCompSpells[$S], $g_sProfileConfigPath, "Spells", $g_asSpellShortNames[$S], 0, "int")
IniReadS($g_aiTrainArmySpellLevel[$S], $g_sProfileConfigPath, "LevelSpell", $g_asSpellShortNames[$S], 0, "int")
Next
IniReadS($g_iTrainArmyFullTroopPct, $g_sProfileConfigPath, "troop", "fullTroop", 100, "int")
$g_bTotalCampForced =(IniRead($g_sProfileConfigPath, "other", "ChkTotalCampForced", "1") = "1")
$g_iTotalCampForcedValue = Int(IniRead($g_sProfileConfigPath, "other", "ValueTotalCampForced", 220))
$g_bForceBrewSpells =(IniRead($g_sProfileConfigPath, "other", "ChkForceBrewBeforeAttack", "0") = "1")
IniReadS($g_iTotalSpellValue, $g_sProfileConfigPath, "Spells", "SpellFactory", 0, "int")
$g_iTotalSpellValue = Int($g_iTotalSpellValue)
EndFunc
Func ReadConfig_600_54()
IniReadS($g_bCustomTrainOrderEnable, $g_sProfileConfigPath, "troop", "chkTroopOrder", False, "Bool")
For $z = 0 To UBound($g_aiCmbCustomTrainOrder) - 1
IniReadS($g_aiCmbCustomTrainOrder[$z], $g_sProfileConfigPath, "troop", "cmbTroopOrder" & $z, -1)
Next
IniReadS($g_bCustomBrewOrderEnable, $g_sProfileConfigPath, "Spells", "chkSpellOrder", False, "Bool")
For $z = 0 To UBound($g_aiCmbCustomBrewOrder) - 1
IniReadS($g_aiCmbCustomBrewOrder[$z], $g_sProfileConfigPath, "Spells", "cmbSpellOrder" & $z, -1)
Next
EndFunc
Func ReadConfig_600_56()
$g_bSmartZapEnable =(IniRead($g_sProfileConfigPath, "SmartZap", "UseSmartZap", "0") = "1")
$g_bEarthQuakeZap =(IniRead($g_sProfileConfigPath, "SmartZap", "UseEarthQuakeZap", "0") = "1")
$g_bNoobZap =(IniRead($g_sProfileConfigPath, "SmartZap", "UseNoobZap", "0") = "1")
$g_bSmartZapDB =(IniRead($g_sProfileConfigPath, "SmartZap", "ZapDBOnly", "1") = "1")
$g_bSmartZapSaveHeroes =(IniRead($g_sProfileConfigPath, "SmartZap", "THSnipeSaveHeroes", "1") = "1")
$g_bSmartZapFTW =(IniRead($g_sProfileConfigPath, "SmartZap", "FTW", "0") = "1")
$g_iSmartZapMinDE = Int(IniRead($g_sProfileConfigPath, "SmartZap", "MinDE", 350))
$g_iSmartZapExpectedDE = Int(IniRead($g_sProfileConfigPath, "SmartZap", "ExpectedDE", 320))
EndFunc
Func ReadConfig_641_1()
IniReadS($g_bCloseWhileTrainingEnable, $g_sProfileConfigPath, "other", "chkCloseWaitEnable", True, "Bool")
IniReadS($g_bCloseWithoutShield, $g_sProfileConfigPath, "other", "chkCloseWaitTrain", False, "Bool")
IniReadS($g_bCloseEmulator, $g_sProfileConfigPath, "other", "btnCloseWaitStop", False, "Bool")
IniReadS($g_bSuspendComputer, $g_sProfileConfigPath, "other", "btnCloseWaitSuspendComputer", False, "Bool")
IniReadS($g_bCloseRandom, $g_sProfileConfigPath, "other", "btnCloseWaitStopRandom", False, "Bool")
IniReadS($g_bCloseExactTime, $g_sProfileConfigPath, "other", "btnCloseWaitExact", False, "Bool")
IniReadS($g_bCloseRandomTime, $g_sProfileConfigPath, "other", "btnCloseWaitRandom", True, "Bool")
IniReadS($g_iCloseRandomTimePercent, $g_sProfileConfigPath, "other", "CloseWaitRdmPercent", 10, "int")
IniReadS($g_iCloseMinimumTime, $g_sProfileConfigPath, "other", "MinimumTimeToClose", 2, "int")
IniReadS($g_iTrainClickDelay, $g_sProfileConfigPath, "other", "TrainITDelay", 40, "int")
IniReadS($g_bTrainAddRandomDelayEnable, $g_sProfileConfigPath, "other", "chkAddIdleTime", $g_bTrainAddRandomDelayEnable, "Bool")
IniReadS($g_iTrainAddRandomDelayMin, $g_sProfileConfigPath, "other", "txtAddDelayIdlePhaseTimeMin", $g_iTrainAddRandomDelayMin, "Int")
IniReadS($g_iTrainAddRandomDelayMax, $g_sProfileConfigPath, "other", "txtAddDelayIdlePhaseTimeMax", $g_iTrainAddRandomDelayMax, "Int")
EndFunc
Func IniReadS(ByRef $variable, $PrimaryInputFile, $section, $key, $defaultvalue, $valueType = Default)
Local $defaultvalueTest = "?"
Local $readValue = IniRead($g_sProfileSecondaryInputFileName, $section, $key, $defaultvalueTest)
If $readValue = $defaultvalueTest Then
$readValue = IniRead($PrimaryInputFile, $section, $key, $defaultvalue)
EndIf
Switch $valueType
Case Default
$variable = $readValue
Case "Int"
$variable = Int($readValue)
Case "Bool"
If $readValue = "True" Or $readValue = "1" Then
$variable = True
Else
$variable = False
EndIf
Case Else
$variable = $readValue
EndSwitch
EndFunc
Global $ResetStats = 0
Func UpdateStats()
Static $s_iOldSmartZapGain = 0, $s_iOldNumLSpellsUsed = 0, $s_iOldNumEQSpellsUsed = 0
Static $topgoldloot = 0, $topelixirloot = 0, $topdarkloot = 0, $topTrophyloot = 0
Static $bDonateTroopsStatsChanged = False, $bDonateSpellsStatsChanged = False
Static $iOldFreeBuilderCount, $iOldTotalBuilderCount, $iOldGemAmount
Static $iOldCurrentLoot[$eLootCount]
Static $iOldTotalLoot[$eLootCount]
Static $iOldLastLoot[$eLootCount]
Static $iOldLastBonus[$eLootCount]
Static $iOldSkippedVillageCount, $iOldDroppedTrophyCount
Static $iOldCostGoldWall, $iOldCostElixirWall, $iOldCostGoldBuilding, $iOldCostElixirBuilding, $iOldCostDElixirHero
Static $iOldNbrOfWallsUppedGold, $iOldNbrOfWallsUppedElixir, $iOldNbrOfBuildingsUppedGold, $iOldNbrOfBuildingsUppedElixir, $iOldNbrOfHeroesUpped
Static $iOldSearchCost, $iOldTrainCostElixir, $iOldTrainCostDElixir
Static $iOldNbrOfOoS
Static $iOldNbrOfTHSnipeFails, $iOldNbrOfTHSnipeSuccess
Static $iOldGoldFromMines, $iOldElixirFromCollectors, $iOldDElixirFromDrills
Static $iOldAttackedCount, $iOldAttackedVillageCount[$g_iModeCount + 1]
Static $iOldTotalGoldGain[$g_iModeCount + 1], $iOldTotalElixirGain[$g_iModeCount + 1], $iOldTotalDarkGain[$g_iModeCount + 1], $iOldTotalTrophyGain[$g_iModeCount + 1]
Static $iOldNbrOfDetectedMines[$g_iModeCount + 1], $iOldNbrOfDetectedCollectors[$g_iModeCount + 1], $iOldNbrOfDetectedDrills[$g_iModeCount + 1]
If $g_iFirstRun = 1 Then
GUICtrlSetState($g_hLblVillageReportTemp, $GUI_HIDE)
GUICtrlSetState($g_hPicResultGoldTemp, $GUI_HIDE)
GUICtrlSetState($g_hPicResultElixirTemp, $GUI_HIDE)
GUICtrlSetState($g_hPicResultDETemp, $GUI_HIDE)
GUICtrlSetState($g_hLblResultGoldNow, $GUI_SHOW)
GUICtrlSetState($g_hPicResultGoldNow, $GUI_SHOW)
GUICtrlSetState($g_hLblResultElixirNow, $GUI_SHOW)
GUICtrlSetState($g_hPicResultElixirNow, $GUI_SHOW)
If $g_aiCurrentLoot[$eLootDarkElixir] <> "" Then
GUICtrlSetState($g_hLblResultDeNow, $GUI_SHOW)
GUICtrlSetState($g_hPicResultDeNow, $GUI_SHOW)
Else
EndIf
GUICtrlSetState($g_hLblResultTrophyNow, $GUI_SHOW)
GUICtrlSetState($g_hLblResultBuilderNow, $GUI_SHOW)
GUICtrlSetState($g_hLblResultGemNow, $GUI_SHOW)
$g_iStatsStartedWith[$eLootGold] = $g_aiCurrentLoot[$eLootGold]
$g_iStatsStartedWith[$eLootElixir] = $g_aiCurrentLoot[$eLootElixir]
$g_iStatsStartedWith[$eLootDarkElixir] = $g_aiCurrentLoot[$eLootDarkElixir]
$g_iStatsStartedWith[$eLootTrophy] = $g_aiCurrentLoot[$eLootTrophy]
GUICtrlSetData($g_hLblResultGoldNow, _NumberFormat($g_aiCurrentLoot[$eLootGold], True))
$iOldCurrentLoot[$eLootGold] = $g_aiCurrentLoot[$eLootGold]
GUICtrlSetData($g_hLblResultElixirNow, _NumberFormat($g_aiCurrentLoot[$eLootElixir], True))
$iOldCurrentLoot[$eLootElixir] = $g_aiCurrentLoot[$eLootElixir]
If $g_iStatsStartedWith[$eLootDarkElixir] <> "" Then
GUICtrlSetData($g_hLblResultDeNow, _NumberFormat($g_aiCurrentLoot[$eLootDarkElixir], True))
$iOldCurrentLoot[$eLootDarkElixir] = $g_aiCurrentLoot[$eLootDarkElixir]
EndIf
GUICtrlSetData($g_hLblResultTrophyNow, _NumberFormat($g_aiCurrentLoot[$eLootTrophy], True))
$iOldCurrentLoot[$eLootTrophy] = $g_aiCurrentLoot[$eLootTrophy]
GUICtrlSetData($g_hLblResultGemNow, _NumberFormat($g_iGemAmount, True))
$iOldGemAmount = $g_iGemAmount
GUICtrlSetData($g_hLblResultBuilderNow, $g_iFreeBuilderCount & "/" & $g_iTotalBuilderCount)
$iOldFreeBuilderCount = $g_iFreeBuilderCount
$iOldTotalBuilderCount = $g_iTotalBuilderCount
$g_iFirstRun = 0
Return
EndIf
Local $bStatsUpdated = False
If $g_iFirstAttack = 1 Then
$g_iFirstAttack = 2
EndIf
If Number($g_iStatsLastAttack[$eLootGold]) > Number($topgoldloot) Then
$bStatsUpdated = True
$topgoldloot = $g_iStatsLastAttack[$eLootGold]
EndIf
If Number($g_iStatsLastAttack[$eLootElixir]) > Number($topelixirloot) Then
$bStatsUpdated = True
$topelixirloot = $g_iStatsLastAttack[$eLootElixir]
EndIf
If Number($g_iStatsLastAttack[$eLootDarkElixir]) > Number($topdarkloot) Then
$bStatsUpdated = True
$topdarkloot = $g_iStatsLastAttack[$eLootDarkElixir]
EndIf
If Number($g_iStatsLastAttack[$eLootTrophy]) > Number($topTrophyloot) Then
$bStatsUpdated = True
$topTrophyloot = $g_iStatsLastAttack[$eLootTrophy]
EndIf
If $ResetStats = 1 Then
$bStatsUpdated = True
If $g_iStatsStartedWith[$eLootDarkElixir] <> "" Then
EndIf
GUICtrlSetData($g_hLblResultGoldHourNow, "")
GUICtrlSetData($g_hLblResultElixirHourNow, "")
GUICtrlSetData($g_hLblResultDEHourNow, "")
EndIf
If $iOldFreeBuilderCount <> $g_iFreeBuilderCount Or $iOldTotalBuilderCount <> $g_iTotalBuilderCount Then
$bStatsUpdated = True
GUICtrlSetData($g_hLblResultBuilderNow, $g_iFreeBuilderCount & "/" & $g_iTotalBuilderCount)
$iOldFreeBuilderCount = $g_iFreeBuilderCount
$iOldTotalBuilderCount = $g_iTotalBuilderCount
EndIf
If $iOldGemAmount <> $g_iGemAmount Then
$bStatsUpdated = True
GUICtrlSetData($g_hLblResultGemNow, _NumberFormat($g_iGemAmount, True))
$iOldGemAmount = $g_iGemAmount
EndIf
If $iOldCurrentLoot[$eLootGold] <> $g_aiCurrentLoot[$eLootGold] Then
$bStatsUpdated = True
GUICtrlSetData($g_hLblResultGoldNow, _NumberFormat($g_aiCurrentLoot[$eLootGold], True))
$iOldCurrentLoot[$eLootGold] = $g_aiCurrentLoot[$eLootGold]
EndIf
If $iOldCurrentLoot[$eLootElixir] <> $g_aiCurrentLoot[$eLootElixir] Then
$bStatsUpdated = True
GUICtrlSetData($g_hLblResultElixirNow, _NumberFormat($g_aiCurrentLoot[$eLootElixir], True))
$iOldCurrentLoot[$eLootElixir] = $g_aiCurrentLoot[$eLootElixir]
EndIf
If $iOldCurrentLoot[$eLootDarkElixir] <> $g_aiCurrentLoot[$eLootDarkElixir] And $g_iStatsStartedWith[$eLootDarkElixir] <> "" Then
$bStatsUpdated = True
GUICtrlSetData($g_hLblResultDeNow, _NumberFormat($g_aiCurrentLoot[$eLootDarkElixir], True))
$iOldCurrentLoot[$eLootDarkElixir] = $g_aiCurrentLoot[$eLootDarkElixir]
EndIf
If $iOldCurrentLoot[$eLootTrophy] <> $g_aiCurrentLoot[$eLootTrophy] Then
$bStatsUpdated = True
GUICtrlSetData($g_hLblResultTrophyNow, _NumberFormat($g_aiCurrentLoot[$eLootTrophy], True))
$iOldCurrentLoot[$eLootTrophy] = $g_aiCurrentLoot[$eLootTrophy]
EndIf
If $iOldTotalLoot[$eLootGold] <> $g_iStatsTotalGain[$eLootGold] And($g_iFirstAttack = 2 Or $ResetStats = 1) Then
$bStatsUpdated = True
$iOldTotalLoot[$eLootGold] = $g_iStatsTotalGain[$eLootGold]
EndIf
If $iOldTotalLoot[$eLootElixir] <> $g_iStatsTotalGain[$eLootElixir] And($g_iFirstAttack = 2 Or $ResetStats = 1) Then
$bStatsUpdated = True
$iOldTotalLoot[$eLootElixir] = $g_iStatsTotalGain[$eLootElixir]
EndIf
If $iOldTotalLoot[$eLootDarkElixir] <> $g_iStatsTotalGain[$eLootDarkElixir] And(($g_iFirstAttack = 2 And $g_iStatsStartedWith[$eLootDarkElixir] <> "") Or $ResetStats = 1) Then
$bStatsUpdated = True
$iOldTotalLoot[$eLootDarkElixir] = $g_iStatsTotalGain[$eLootDarkElixir]
EndIf
If $iOldTotalLoot[$eLootTrophy] <> $g_iStatsTotalGain[$eLootTrophy] And($g_iFirstAttack = 2 Or $ResetStats = 1) Then
$bStatsUpdated = True
$iOldTotalLoot[$eLootTrophy] = $g_iStatsTotalGain[$eLootTrophy]
EndIf
If $iOldLastLoot[$eLootGold] <> $g_iStatsLastAttack[$eLootGold] Then
$bStatsUpdated = True
$iOldLastLoot[$eLootGold] = $g_iStatsLastAttack[$eLootGold]
EndIf
If $iOldLastLoot[$eLootElixir] <> $g_iStatsLastAttack[$eLootElixir] Then
$bStatsUpdated = True
$iOldLastLoot[$eLootElixir] = $g_iStatsLastAttack[$eLootElixir]
EndIf
If $iOldLastLoot[$eLootDarkElixir] <> $g_iStatsLastAttack[$eLootDarkElixir] Then
$bStatsUpdated = True
$iOldLastLoot[$eLootDarkElixir] = $g_iStatsLastAttack[$eLootDarkElixir]
EndIf
If $iOldLastLoot[$eLootTrophy] <> $g_iStatsLastAttack[$eLootTrophy] Then
$bStatsUpdated = True
$iOldLastLoot[$eLootTrophy] = $g_iStatsLastAttack[$eLootTrophy]
EndIf
If $iOldLastBonus[$eLootGold] <> $g_iStatsBonusLast[$eLootGold] Then
$bStatsUpdated = True
$iOldLastBonus[$eLootGold] = $g_iStatsBonusLast[$eLootGold]
EndIf
If $iOldLastBonus[$eLootElixir] <> $g_iStatsBonusLast[$eLootElixir] Then
$bStatsUpdated = True
$iOldLastBonus[$eLootElixir] = $g_iStatsBonusLast[$eLootElixir]
EndIf
If $iOldSkippedVillageCount <> $g_iSkippedVillageCount Then
$bStatsUpdated = True
GUICtrlSetData($g_hLblResultSkippedHourNow, _NumberFormat($g_iSkippedVillageCount, True))
$iOldSkippedVillageCount = $g_iSkippedVillageCount
EndIf
If $iOldAttackedCount <> $g_aiAttackedCount Then
$bStatsUpdated = True
GUICtrlSetData($g_hLblResultAttackedHourNow, _NumberFormat($g_aiAttackedCount, True))
$iOldAttackedCount = $g_aiAttackedCount
EndIf
If $g_iFirstAttack = 2 Then
$bStatsUpdated = True
If $g_iStatsStartedWith[$eLootDarkElixir] <> "" Then
EndIf
GUICtrlSetData($g_hLblResultGoldHourNow, _NumberFormat(Round($g_iStatsTotalGain[$eLootGold] /(Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "k / h")
GUICtrlSetData($g_hLblResultElixirHourNow, _NumberFormat(Round($g_iStatsTotalGain[$eLootElixir] /(Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "k / h")
If $g_iStatsStartedWith[$eLootDarkElixir] <> "" Then
GUICtrlSetData($g_hLblResultDEHourNow, _NumberFormat(Round($g_iStatsTotalGain[$eLootDarkElixir] /(Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600 * 1000)) & " / h")
EndIf
EndIf
If Number($g_iStatsLastAttack[$eLootGold]) > Number($topgoldloot) Then
$bStatsUpdated = True
$topgoldloot = $g_iStatsLastAttack[$eLootGold]
EndIf
If Number($g_iStatsLastAttack[$eLootElixir]) > Number($topelixirloot) Then
$bStatsUpdated = True
$topelixirloot = $g_iStatsLastAttack[$eLootElixir]
EndIf
If Number($g_iStatsLastAttack[$eLootDarkElixir]) > Number($topdarkloot) Then
$bStatsUpdated = True
$topdarkloot = $g_iStatsLastAttack[$eLootDarkElixir]
EndIf
If Number($g_iStatsLastAttack[$eLootTrophy]) > Number($topTrophyloot) Then
$bStatsUpdated = True
$topTrophyloot = $g_iStatsLastAttack[$eLootTrophy]
EndIf
If $ResetStats = 1 Then
$ResetStats = 0
EndIf
EndFunc
Func _NumberFormat($Number, $NullToZero = False)
If $Number = "" Then
If $NullToZero = False Then
Return ""
Else
Return "0"
EndIf
EndIf
If StringLeft($Number, 1) = "-" Then
Return "- " & StringRegExpReplace(StringTrimLeft($Number, 1), "(\A\d{1,3}(?=(\d{3})+\z)|\d{3}(?=\d))", "\1 ")
Else
Return StringRegExpReplace($Number, "(\A\d{1,3}(?=(\d{3})+\z)|\d{3}(?=\d))", "\1 ")
EndIf
EndFunc
Global Enum $eBotUpdateStats = $eBotClose + 1
Func SetLog($String, $Color = $COLOR_BLACK, $LogPrefix = "L ")
Local $log = $LogPrefix & TimeDebug() & $String
_ConsoleWrite($log & @CRLF)
EndFunc
Func SetDebugLog($String, $Color = $COLOR_DEBUG, $LogPrefix = "D ")
Return SetLog($String, $Color, $LogPrefix)
EndFunc
Func _Sleep($ms, $iSleep = True, $CheckRunState = True)
CheckBotRequests()
_SleepMilli($ms)
EndFunc
Func _SleepMicro($iMicroSec)
DllStructSetData($hStruct_SleepMicro, "time", $iMicroSec * -10)
DllCall($hNtDll, "dword", "ZwDelayExecution", "int", 0, "ptr", $pStruct_SleepMicro)
EndFunc
Func UpdateBotTitle($sTitle = "My Bot " & $g_sBotVersion)
$sTitle = StringReplace($sTitle, "My Bot", "My Bot Mini")
If $g_sBotTitle = $sTitle Then Return
$g_sBotTitle = $sTitle
If $g_hFrmBot <> 0 Then
WinSetTitle($g_hFrmBot, "", $g_sBotTitle)
GUICtrlSetData($g_hLblBotTitle, $g_sBotTitle)
EndIf
DllCall("kernel32.dll", "bool", "SetConsoleTitle", "str", "Console " & $g_sBotTitle)
TraySetToolTip($g_sBotTitle)
GUISetIcon($g_sLibIconPath, $eIcnGUI)
SetDebugLog("Bot title updated to: " & $g_sBotTitle)
EndFunc
Func _SleepMilli($iMilliSec)
_SleepMicro(Int($iMilliSec * 1000))
EndFunc
Func ProcessCommandLine()
If $CmdLine[0] > 0 Then
SetDebugLog("Full Command Line: " & _ArrayToString($CmdLine, " "))
For $i = 1 To $CmdLine[0]
Local $bOptionDetected = True
Switch $CmdLine[$i]
Case "/restart", "/r", "-restart", "-r"
$g_bBotLaunchOption_Restart = True
Case "/autostart", "/a", "-autostart", "-a"
$g_bBotLaunchOption_Autostart = True
Case "/nowatchdog", "/nwd", "-nowatchdog", "-nwd"
$g_bBotLaunchOption_NoWatchdog = True
Case "/dpiaware", "/da", "-dpiaware", "-da"
$g_bBotLaunchOption_ForceDpiAware = True
Case "/dock1", "/d1", "-dock1", "-d1", "/dock", "/d", "-dock", "-d"
$g_iBotLaunchOption_Dock = 1
Case "/dock2", "/d2", "-dock2", "-d2"
$g_iBotLaunchOption_Dock = 2
Case "/nobotslot", "/nbs", "-nobotslot", "-nbs"
$g_bBotLaunchOption_NoBotSlot = True
Case "/debug", "/debugmode", "/dev", "-debug", "-dev"
$g_bDevMode = True
Case "/minigui", "/mg", "-minigui", "-mg"
$g_iGuiMode = 2
Case "/nogui", "/ng", "-nogui", "-ng"
$g_iGuiMode = 0
Case "/console", "/c", "-console", "-c"
_WinAPI_AllocConsole()
_WinAPI_SetConsoleIcon($g_sLibIconPath, $eIcnGUI)
Case Else
If StringInStr($CmdLine[$i], "/guipid=") Then
Local $guidpid = Int(StringMid($CmdLine[$i], 9))
If ProcessExists($guidpid) Then
$g_iGuiPID = $guidpid
Else
SetDebugLog("GUI Process doesn't exist: " & $guidpid)
EndIf
Else
$bOptionDetected = False
$g_asCmdLine[0] += 1
ReDim $g_asCmdLine[$g_asCmdLine[0] + 1]
$g_asCmdLine[$g_asCmdLine[0]] = $CmdLine[$i]
EndIf
EndSwitch
If $bOptionDetected Then SetDebugLog("Command Line Option detected: " & $CmdLine[$i])
Next
EndIf
If $g_asCmdLine[0] > 0 Then
$g_sProfileCurrentName = StringRegExpReplace($g_asCmdLine[1], '[/:*?"<>|]', '_')
If $g_asCmdLine[0] >= 2 Then
If StringInStr($g_asCmdLine[2], "BlueStacks3") Then $g_asCmdLine[2] = "BlueStacks2"
EndIf
ElseIf FileExists($g_sProfilePath & "\profile.ini") Then
$g_sProfileCurrentName = StringRegExpReplace(IniRead($g_sProfilePath & "\profile.ini", "general", "defaultprofile", ""), '[/:*?"<>|]', '_')
If $g_sProfileCurrentName = "" Or Not FileExists($g_sProfilePath & "\" & $g_sProfileCurrentName) Then $g_sProfileCurrentName = "<No Profiles>"
Else
$g_sProfileCurrentName = "<No Profiles>"
EndIf
EndFunc
Func InitializeAndroid()
Local $s = GetTranslatedFileIni("MBR GUI Design - Loading", "StatusBar_Item_06", "Initializing Android...")
SplashStep($s)
If $g_bBotLaunchOption_Restart = False Then
InitAndroidConfig(True)
If $g_asCmdLine[0] > 1 Then
Local $i
For $i = 0 To UBound($g_avAndroidAppConfig) - 1
If StringCompare($g_avAndroidAppConfig[$i][0], $g_asCmdLine[2]) = 0 Then
$g_iAndroidConfig = $i
SplashStep($s & "(" & $g_avAndroidAppConfig[$i][0] & ")...", False)
If $g_avAndroidAppConfig[$i][1] <> "" And $g_asCmdLine[0] > 2 Then
UpdateAndroidConfig($g_asCmdLine[3])
Else
UpdateAndroidConfig()
EndIf
SplashStep($s & "(" & $g_avAndroidAppConfig[$i][0] & ")", False)
ExitLoop
EndIf
Next
EndIf
SplashStep(GetTranslatedFileIni("MBR GUI Design - Loading", "StatusBar_Item_07", "Detecting Android..."))
If $g_asCmdLine[0] < 2 Then
EndIf
Else
SplashStep($s)
EndIf
EndFunc
Func InitAndroidConfig($bRestart = False)
If $bRestart = False Then
$g_sAndroidEmulator = $g_avAndroidAppConfig[$g_iAndroidConfig][0]
$g_sAndroidInstance = $g_avAndroidAppConfig[$g_iAndroidConfig][1]
$g_sAndroidTitle = $g_avAndroidAppConfig[$g_iAndroidConfig][2]
EndIf
$g_sAppClassInstance = $g_avAndroidAppConfig[$g_iAndroidConfig][3]
$g_sAppPaneName = $g_avAndroidAppConfig[$g_iAndroidConfig][4]
$g_iAndroidClientWidth = $g_avAndroidAppConfig[$g_iAndroidConfig][5]
$g_iAndroidClientHeight = $g_avAndroidAppConfig[$g_iAndroidConfig][6]
$g_iAndroidWindowWidth = $g_avAndroidAppConfig[$g_iAndroidConfig][7]
$g_iAndroidWindowHeight = $g_avAndroidAppConfig[$g_iAndroidConfig][8]
$g_iAndroidAdbSuCommand = ""
$g_sAndroidAdbPath = ""
$g_sAndroidAdbDevice = $g_avAndroidAppConfig[$g_iAndroidConfig][10]
$g_iAndroidSupportFeature = $g_avAndroidAppConfig[$g_iAndroidConfig][11]
$g_sAndroidShellPrompt = $g_avAndroidAppConfig[$g_iAndroidConfig][12]
$g_sAndroidMouseDevice = $g_avAndroidAppConfig[$g_iAndroidConfig][13]
$g_iAndroidEmbedMode = $g_avAndroidAppConfig[$g_iAndroidConfig][14]
$g_iAndroidBackgroundModeDefault = $g_avAndroidAppConfig[$g_iAndroidConfig][15]
$g_bAndroidAdbScreencap = $g_bAndroidAdbScreencapEnabled = True And BitAND($g_iAndroidSupportFeature, 2) = 2
$g_bAndroidAdbClick = $g_bAndroidAdbClickEnabled = True And AndroidAdbClickSupported()
$g_bAndroidAdbInput = $g_bAndroidAdbInputEnabled = True And BitAND($g_iAndroidSupportFeature, 8) = 8
$g_bAndroidAdbInstance = $g_bAndroidAdbInstanceEnabled = True And BitAND($g_iAndroidSupportFeature, 16) = 16
$g_bAndroidAdbClickDrag = $g_bAndroidAdbClickDragEnabled = True And BitAND($g_iAndroidSupportFeature, 32) = 32
$g_bAndroidEmbed = $g_bAndroidEmbedEnabled = True And $g_iAndroidEmbedMode > -1
$g_bAndroidBackgroundLaunch = $g_bAndroidBackgroundLaunchEnabled = True
$g_bAndroidBackgroundLaunched = False
$g_bUpdateAndroidWindowTitle = False
If $g_bAndroidAdbScreencap And IsDeclared("g_hChkBackground") Then
chkBackground()
EndIf
UpdateHWnD($g_hAndroidWindow, False)
EndFunc
Func UpdateAndroidConfig($instance = Default, $emulator = Default)
If $emulator <> Default Then
For $i = 0 To UBound($g_avAndroidAppConfig) - 1
If $g_avAndroidAppConfig[$i][0] = $emulator Then
If $g_iAndroidConfig <> $i Then
$g_iAndroidConfig = $i
$g_sAndroidEmulator = $g_avAndroidAppConfig[$g_iAndroidConfig][0]
SetLog("Android Emulator " & $g_sAndroidEmulator)
EndIf
$emulator = Default
ExitLoop
EndIf
Next
EndIf
If $emulator <> Default Then SetLog("Unknown Android Emulator " & $emulator, $COLOR_RED)
If $instance = "" Then $instance = Default
If $instance = Default Then $instance = $g_avAndroidAppConfig[$g_iAndroidConfig][1]
SetDebugLog("UpdateAndroidConfig(""" & $instance & """)")
InitAndroidConfig(False)
$g_sAndroidInstance = $instance
If BitAND($g_iAndroidSecureFlags, 1) = 1 Then
$g_sAndroidPicturesHostFolder = ""
Else
$g_sAndroidPicturesHostFolder = "mybot.run\"
EndIf
Local $Result = InitAndroid(False, False)
SetDebugLog("UpdateAndroidConfig(""" & $instance & """) END")
Return $Result
EndFunc
Func AndroidAdbClickSupported()
Return BitAND($g_iAndroidSupportFeature, 4) = 4
EndFunc
Func InitAndroid($bCheckOnly = False, $bLogChangesOnly = True)
If $bCheckOnly = False And $g_bInitAndroid = False Then
Return True
EndIf
$g_bInitAndroidActive = True
Local $aPriorValues = [ $g_sAndroidEmulator , $g_iAndroidConfig , $g_sAndroidVersion , $g_sAndroidInstance , $g_sAndroidTitle , $g_sAndroidProgramPath , GetAndroidProgramParameter() ,((IsArray($g_avAndroidProgramFileVersionInfo) ? _ArrayToString($g_avAndroidProgramFileVersionInfo, ",", 1) : "not available")) , $g_iAndroidSecureFlags , $g_sAndroidAdbPath , $__VBoxManage_Path , $g_sAndroidAdbDevice , $g_sAndroidPicturesPath , $g_sAndroidPicturesHostPath , $g_sAndroidPicturesHostFolder , $g_sAndroidMouseDevice , $g_bAndroidAdbScreencap , $g_bAndroidAdbInput , $g_bAndroidAdbClick , $g_bAndroidAdbClickDrag ,($g_bChkBackgroundMode = True ? "enabled" : "disabled") , $g_bNoFocusTampering ]
SetDebugLog("InitAndroid(" & $bCheckOnly & "): " & $g_sAndroidEmulator)
If Not $bCheckOnly Then
If $g_sAndroidInstance = "" Then $g_sAndroidInstance = $g_avAndroidAppConfig[$g_iAndroidConfig][1]
$__VBoxGuestProperties = ""
$__VBoxExtraData = ""
EndIf
Local $Result = Execute("Init" & $g_sAndroidEmulator & "(" & $bCheckOnly & ")")
If $Result = "" And @error <> 0 Then
SetLog("Android support for " & $g_sAndroidEmulator & " is not available", $COLOR_ERROR)
EndIf
Local $successful = @error = 0, $process_killed
If Not $bCheckOnly And $Result Then
If $b_sAndroidProgramWerFaultExcluded = True Then
Local $sFileOnly = StringMid($g_sAndroidProgramPath, StringInStr($g_sAndroidProgramPath, "\", 0, -1) + 1)
Local $aResult = DllCall("Wer.dll", "int", "WerAddExcludedApplication", "wstr", $sFileOnly, "bool", True)
If(UBound($aResult) > 0 And $aResult[0] = $S_OK) Or RegWrite($g_sHKLM & "\Software\Microsoft\Windows\Windows Error Reporting\ExcludedApplications", $sFileOnly, "REG_DWORD", "1") = 1 Then
SetDebugLog("Disabled WerFault for " & $sFileOnly)
Else
SetDebugLog("Cannot disable WerFault for " & $sFileOnly)
EndIf
EndIf
If FileExists($__VBoxManage_Path) Then
If $__VBoxGuestProperties = "" Then $__VBoxGuestProperties = LaunchConsole($__VBoxManage_Path, "guestproperty enumerate " & $g_sAndroidInstance, $process_killed)
If $__VBoxExtraData = "" Then $__VBoxExtraData = LaunchConsole($__VBoxManage_Path, "getextradata " & $g_sAndroidInstance & " enumerate", $process_killed)
EndIf
UpdateAndroidBackgroundMode()
Local $pAndroidFileVersionInfo
If _WinAPI_GetFileVersionInfo($g_sAndroidProgramPath, $pAndroidFileVersionInfo) Then
$g_avAndroidProgramFileVersionInfo = _WinAPI_VerQueryValue($pAndroidFileVersionInfo)
Else
$g_avAndroidProgramFileVersionInfo = 0
EndIf
Local $i = 0
Local $sText = ""
If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_sAndroidEmulator) Or $bLogChangesOnly = False Then SetDebugLog("Android: " & $g_sAndroidEmulator)
If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_iAndroidConfig) Or $bLogChangesOnly = False Then SetDebugLog("Android Config: " & $g_iAndroidConfig)
If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_sAndroidVersion) Or $bLogChangesOnly = False Then SetDebugLog("Android Version: " & $g_sAndroidVersion)
If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_sAndroidInstance) Or $bLogChangesOnly = False Then SetDebugLog("Android Instance: " & $g_sAndroidInstance)
If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_sAndroidTitle) Or $bLogChangesOnly = False Then SetDebugLog("Android Window Title: " & $g_sAndroidTitle)
If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_sAndroidProgramPath) Or $bLogChangesOnly = False Then SetDebugLog("Android Program Path: " & $g_sAndroidProgramPath)
If CompareAndUpdate($aPriorValues[IncrUpdate($i)], GetAndroidProgramParameter()) Or $bLogChangesOnly = False Then SetDebugLog("Android Program Parameter: " & GetAndroidProgramParameter())
$sText =((IsArray($g_avAndroidProgramFileVersionInfo) ? _ArrayToString($g_avAndroidProgramFileVersionInfo, ",", 1) : "not available"))
If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $sText) Or $bLogChangesOnly = False Then SetDebugLog("Android Program FileVersionInfo: " & $sText)
If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_iAndroidSecureFlags) Or $bLogChangesOnly = False Then SetDebugLog("Android SecureME setting: " & $g_iAndroidSecureFlags)
If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_sAndroidAdbPath) Or $bLogChangesOnly = False Then SetDebugLog("Android ADB Path: " & $g_sAndroidAdbPath)
If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $__VBoxManage_Path) Or $bLogChangesOnly = False Then SetDebugLog("Android VBoxManage Path: " & $__VBoxManage_Path)
If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_sAndroidAdbDevice) Or $bLogChangesOnly = False Then SetDebugLog("Android ADB Device: " & $g_sAndroidAdbDevice)
If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_sAndroidPicturesPath) Or $bLogChangesOnly = False Then SetDebugLog("Android ADB Shared Folder: " & $g_sAndroidPicturesPath)
If FileExists($g_sAndroidPicturesHostPath) Then
If($g_sAndroidPicturesHostFolder <> "" Or BitAND($g_iAndroidSecureFlags, 1) = 1) Then
DirCreate($g_sAndroidPicturesHostPath & $g_sAndroidPicturesHostFolder)
EndIf
ElseIf $g_sAndroidPicturesHostPath <> "" Then
SetLog("Shared Folder doesn't exist, please fix:", $COLOR_ERROR)
SetLog($g_sAndroidPicturesHostPath, $COLOR_ERROR)
EndIf
If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_sAndroidPicturesHostPath) Or $bLogChangesOnly = False Then SetDebugLog("Android ADB Shared Folder on Host: " & $g_sAndroidPicturesHostPath)
If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_sAndroidPicturesHostFolder) Or $bLogChangesOnly = False Then SetDebugLog("Android ADB Shared SubFolder: " & $g_sAndroidPicturesHostFolder)
If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_sAndroidMouseDevice) Or $bLogChangesOnly = False Then SetDebugLog("Android Mouse Device: " & $g_sAndroidMouseDevice)
If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_bAndroidAdbScreencap) Or $bLogChangesOnly = False Then SetDebugLog("Android ADB screencap command enabled: " & $g_bAndroidAdbScreencap)
If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_bAndroidAdbInput) Or $bLogChangesOnly = False Then SetDebugLog("Android ADB input command enabled: " & $g_bAndroidAdbInput)
If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_bAndroidAdbClick) Or $bLogChangesOnly = False Then SetDebugLog("Android ADB Mouse Click enabled: " & $g_bAndroidAdbClick)
If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_bAndroidAdbClickDrag) Or $bLogChangesOnly = False Then SetDebugLog("Android ADB Click Drag enabled: " & $g_bAndroidAdbClickDrag)
If CompareAndUpdate($aPriorValues[IncrUpdate($i)],($g_bChkBackgroundMode = True ? "enabled" : "disabled")) Or $bLogChangesOnly = False Then SetDebugLog("Bot Background Mode for screen capture: " &($g_bChkBackgroundMode = True ? "enabled" : "disabled"))
If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_bNoFocusTampering) Or $bLogChangesOnly = False Then SetDebugLog("No Focus Tampering: " & $g_bNoFocusTampering)
WinGetAndroidHandle()
InitAndroidTimeLag()
InitAndroidPageError()
$g_bInitAndroid = Not $successful
Else
If $bCheckOnly = False Then $g_bInitAndroid = True
EndIf
SetDebugLog("InitAndroid(" & $bCheckOnly & "): " & $g_sAndroidEmulator & " END, initialization successful = " & $successful & ", result = " & $Result)
$g_bInitAndroidActive = False
Return $Result
EndFunc
Func IncrUpdate(ByRef $i, $ReturnInitial = True)
Local $i2 = $i
$i += 1
If $ReturnInitial Then Return $i2
Return $i
EndFunc
Func CompareAndUpdate(ByRef $UpdateWhenDifferent, Const $New)
Local $bDifferent = $UpdateWhenDifferent <> $New
If $bDifferent Then $UpdateWhenDifferent = $New
Return $bDifferent
EndFunc
Func GetVersionNormalized($VersionString, $Chars = 5)
If StringLeft($VersionString, 1) = "v" Then $VersionString = StringMid($VersionString, 2)
Local $a = StringSplit($VersionString, ".", 2)
Local $i
For $i = 0 To UBound($a) - 1
If StringLen($a[$i]) < $Chars Then $a[$i] = _StringRepeat("0", $Chars - StringLen($a[$i])) & $a[$i]
Next
Return _ArrayToString($a, ".")
EndFunc
Func InitAndroidTimeLag()
EndFunc
Func InitAndroidPageError()
EndFunc
Func UpdateHWnD($hWin, $bRestart = True)
EndFunc
Func GetAndroidProgramParameter()
Return ""
EndFunc
Func BotMoveRequest()
$g_bBotMoveRequested = True
EndFunc
Func BotMinimizeRequest()
BotMinimize("MinimizeButton", False, 500)
EndFunc
Func UpdateAndroidBackgroundMode()
EndFunc
Func readWeakBaseStats()
EndFunc
Func BotMinimizeRestore($bMinimize, $sCaller, $iForceUpdatingWhenMinimized = False, $iStayMinimizedMillis = 0)
Static $siStayMinimizedMillis = 0
Static $shStayMinimizedTimer = 0
If $bMinimize Then
If $iStayMinimizedMillis > 0 Then
$siStayMinimizedMillis = $iStayMinimizedMillis
$shStayMinimizedTimer = __TimerInit()
EndIf
If $g_bAndroidEmbedded = True And $g_bChkBackgroundMode = False Then
Return False
EndIf
SetDebugLog("Minimize bot window, caller: " & $sCaller, Default, True)
$g_bFrmBotMinimized = True
If $g_bUpdatingWhenMinimized Or $iForceUpdatingWhenMinimized = True Then
If $g_bHideWhenMinimized Then
WinMove2($g_hFrmBot, "", -32000, -32000, -1, -1, 0, $SWP_HIDEWINDOW, False)
_WinAPI_SetWindowLong($g_hFrmBot, $GWL_EXSTYLE, BitOR(_WinAPI_GetWindowLong($g_hFrmBot, $GWL_EXSTYLE), $WS_EX_TOOLWINDOW))
EndIf
If _WinAPI_IsIconic($g_hFrmBot) Then WinSetState($g_hFrmBot, "", @SW_RESTORE)
If _WinAPI_IsIconic($g_hAndroidWindow) Then WinSetState($g_hAndroidWindow, "", @SW_RESTORE)
WinMove2($g_hFrmBot, "", -32000, -32000, -1, -1, 0, $SWP_SHOWWINDOW, False)
Else
If $g_bHideWhenMinimized Then
WinMove2($g_hFrmBot, "", -1, -1, -1, -1, 0, $SWP_HIDEWINDOW, False)
_WinAPI_SetWindowLong($g_hFrmBot, $GWL_EXSTYLE, BitOR(_WinAPI_GetWindowLong($g_hFrmBot, $GWL_EXSTYLE), $WS_EX_TOOLWINDOW))
EndIf
WinSetState($g_hFrmBot, "", @SW_MINIMIZE)
EndIf
Return True
EndIf
If $siStayMinimizedMillis > 0 And __TimerDiff($shStayMinimizedTimer) < $siStayMinimizedMillis Then
SetDebugLog("Prevent Bot Window Restore")
Return False
Else
$siStayMinimizedMillis = 0
$shStayMinimizedTimer = 0
EndIf
$g_bFrmBotMinimized = False
Local $botPosX =($g_bAndroidEmbedded = False ? $g_iFrmBotPosX : $g_iFrmBotDockedPosX)
Local $botPosY =($g_bAndroidEmbedded = False ? $g_iFrmBotPosY : $g_iFrmBotDockedPosY)
Local $aPos = [$botPosX, $botPosY]
SetDebugLog("Restore bot window to " & $botPosX & ", " & $botPosY & ", caller: " & $sCaller, Default, True)
Local $iExStyle = _WinAPI_GetWindowLong($g_hFrmBot, $GWL_EXSTYLE)
If BitAND($iExStyle, $WS_EX_TOOLWINDOW) Then
WinMove2($g_hFrmBot, "", -1, -1, -1, -1, 0, $SWP_HIDEWINDOW, False)
_WinAPI_SetWindowLong($g_hFrmBot, $GWL_EXSTYLE, BitAND($iExStyle, BitNOT($WS_EX_TOOLWINDOW)))
EndIf
If _WinAPI_IsIconic($g_hFrmBot) Then WinSetState($g_hFrmBot, "", @SW_RESTORE)
If $g_bAndroidAdbScreencap = False And $g_bRunState = True And $g_bBotPaused = False And _WinAPI_IsIconic($g_hAndroidWindow) Then WinSetState($g_hAndroidWindow, "", @SW_RESTORE)
WinMove2($g_hFrmBot, "", $botPosX, $botPosY, -1, -1, $HWND_TOP, $SWP_SHOWWINDOW)
_WinAPI_SetActiveWindow($g_hFrmBot)
_WinAPI_SetFocus($g_hFrmBot)
If _CheckWindowVisibility($g_hFrmBot, $aPos) Then
SetDebugLog("Bot Window '" & $g_sAndroidTitle & "' not visible, moving to position: " & $aPos[0] & ", " & $aPos[1])
WinMove2($g_hFrmBot, "", $aPos[0], $aPos[1])
EndIf
WinSetTrans($g_hFrmBot, "", 255)
Return True
EndFunc
Func BotMinimize($sCaller, $iForceUpdatingWhenMinimized = False, $iStayMinimizedMillis = 0)
Return BotMinimizeRestore(True, $sCaller, $iForceUpdatingWhenMinimized, $iStayMinimizedMillis)
EndFunc
Func BotRestore($sCaller)
Return BotMinimizeRestore(False, $sCaller)
EndFunc
Func BotCloseRequest()
If $g_iBotAction = $eBotClose Then
BotClose()
Else
SetLog("Closing " & $g_sBotTitle & ", please wait ...")
EndIf
$g_bRunState = False
$g_bBotPaused = False
$g_iBotAction = $eBotClose
EndFunc
Func AndroidEmbedArrangeActive()
Return False
EndFunc
Func CheckBotShrinkExpandButton()
Return False
EndFunc
Func AndroidEmbedCheck($p1 = False, $p2 = Default, $iAction = Default)
Return False
EndFunc
Func BotWindowCheck()
Return True
EndFunc
Func CheckBotZOrder()
EndFunc
Func BotShrinkExpandToggleExecute()
EndFunc
Func WinGetAndroidHandle()
Return 0
EndFunc
Func SplashStep($s, $a = 0)
EndFunc
Func CheckBotRequests()
CheckBotZOrder()
If $g_bBotMoveRequested = True Then
$g_bBotMoveRequested = False
_WinAPI_PostMessage($g_hFrmBot, $WM_SYSCOMMAND, 0xF012, 0)
Else
If $g_bBotShrinkExpandToggleRequested Then BotShrinkExpandToggleExecute()
EndIf
EndFunc
Func SetCriticalMessageProcessing($bCritical = Default)
Return False
EndFunc
Func SetupProfileFolder()
$g_sProfileConfigPath = $g_sProfilePath & "\" & $g_sProfileCurrentName & "\config.ini"
$g_sProfileBuildingStatsPath = $g_sProfilePath & "\" & $g_sProfileCurrentName & "\stats_buildings.ini"
$g_sProfileBuildingPath = $g_sProfilePath & "\" & $g_sProfileCurrentName & "\building.ini"
$g_sProfileLogsPath = $g_sProfilePath & "\" & $g_sProfileCurrentName & "\Logs\"
$g_sProfileLootsPath = $g_sProfilePath & "\" & $g_sProfileCurrentName & "\Loots\"
$g_sProfileTempPath = $g_sProfilePath & "\" & $g_sProfileCurrentName & "\Temp\"
$g_sProfileTempDebugPath = $g_sProfilePath & "\" & $g_sProfileCurrentName & "\Temp\Debug\"
$g_sProfileDonateCapturePath = $g_sProfilePath & "\" & $g_sProfileCurrentName & '\Donate\'
$g_sProfileDonateCaptureWhitelistPath = $g_sProfilePath & "\" & $g_sProfileCurrentName & '\Donate\White List\'
$g_sProfileDonateCaptureBlacklistPath = $g_sProfilePath & "\" & $g_sProfileCurrentName & '\Donate\Black List\'
EndFunc
Func OpenURL_Label($LabelCtrlID)
Local $url = GUICtrlRead($LabelCtrlID)
If IsString($LabelCtrlID) Then $url = $LabelCtrlID
If StringInStr($url, "http") <> 1 Then
$url = _GUIToolTip_GetText($g_hToolTip, 0, GUICtrlGetHandle($LabelCtrlID))
EndIf
If StringInStr($url, "http") = 1 Then
SetDebugLog("Open URL: " & $url)
ShellExecute($url)
Else
SetDebugLog("Cannot open URL for Control ID " & $LabelCtrlID, $COLOR_ERROR)
EndIf
EndFunc
Func _GUICtrlStatusBar_SetTextEx($hWnd, $sText = "", $iPart = 0, $iUFlag = 0)
If $hWnd Then _GUICtrlStatusBar_SetText($hWnd, $sText, $iPart, $iUFlag)
EndFunc
Func GUIEvents()
Local $wasAllowed = $g_bTogglePauseAllowed
$g_bTogglePauseAllowed = False
Local $GUI_CtrlId = @GUI_CtrlId
SetDebugLog("GUIEvents: " & $GUI_CtrlId, Default, True)
If $g_bFrmBotMinimized And $GUI_CtrlId = $GUI_EVENT_MINIMIZE Then
If $g_iDebugWindowMessages Then SetDebugLog("$GUI_EVENT_MINIMIZE changed to $GUI_EVENT_RESTORE", Default, True)
$GUI_CtrlId = $GUI_EVENT_RESTORE
EndIf
Switch $GUI_CtrlId
Case $GUI_EVENT_CLOSE
If $g_iDebugWindowMessages Then SetDebugLog("$GUI_EVENT_CLOSE", Default, True)
BotCloseRequest()
Case $GUI_EVENT_MINIMIZE
If $g_iDebugWindowMessages Then SetDebugLog("$GUI_EVENT_MINIMIZE", Default, True)
BotMinimize("GUIEvents")
Case $GUI_EVENT_RESTORE
If $g_iDebugWindowMessages Then SetDebugLog("$GUI_EVENT_RESTORE", Default, True)
BotRestore("GUIEvents")
Case Else
If $g_iDebugWindowMessages Then SetDebugLog("$GUI_EVENT: " & @GUI_CtrlId, Default, True)
EndSwitch
$g_bTogglePauseAllowed = $wasAllowed
EndFunc
Func GUIControl_WM_CLOSE($hWind, $iMsg, $wParam, $lParam)
If $g_iDebugWindowMessages > 0 Then SetDebugLog("GUIControl_WM_CLOSE: $hWind=" & $hWind & ",$iMsg=" & $iMsg & ",$wParam=" & $wParam & ",$lParam=" & $lParam, Default, True)
If $hWind = $g_hFrmBot Then
BotCloseRequest()
EndIf
EndFunc
Func GUIControl_WM_COMMAND($hWind, $iMsg, $wParam, $lParam)
If $g_bGUIControlDisabled = True Then Return $GUI_RUNDEFMSG
Local $wasAllowed = $g_bTogglePauseAllowed
$g_bTogglePauseAllowed = False
If $g_iDebugWindowMessages > 1 Then SetDebugLog("GUIControl_WM_COMMAND: $hWind=" & $hWind & ",$iMsg=" & $iMsg & ",$wParam=" & $wParam & ",$lParam=" & $lParam, Default, True)
Local $nNotifyCode = BitShift($wParam, 16)
Local $nID = BitAND($wParam, 0x0000FFFF)
Switch $nID
Case $g_hLblBotMinimize
BotMinimizeRequest()
Case $GUI_EVENT_CLOSE, $g_hLblBotClose
BotCloseRequest()
Case $g_hFrmBot_URL_PIC, $g_hFrmBot_URL_PIC2
OpenURL_Label("https://mybot.run/forums")
Case $g_hLblDonate
ShellExecute("https://mybot.run/forums/index.php?/donate/make-donation/")
Case $g_hBtnStop
btnStop()
Case $g_hBtnPause
btnPause()
Case $g_hBtnResume
btnResume()
Case $g_hBtnHide
btnHide()
Case $g_hBtnMakeScreenshot
btnMakeScreenshot()
Case $g_hPicTwoArrowShield
btnVillageStat()
Case $g_hPicArrowLeft, $g_hPicArrowRight
btnVillageStat()
EndSwitch
$g_bTogglePauseAllowed = $wasAllowed
Return $GUI_RUNDEFMSG
EndFunc
Func GUIControl_WM_MOVE($hWind, $iMsg, $wParam, $lParam)
If $g_bBotShrinkExpandToggleRequested Then Return $GUI_RUNDEFMSG
Local $wasCritical = SetCriticalMessageProcessing(True)
Local $wasAllowed = $g_bTogglePauseAllowed
$g_bTogglePauseAllowed = False
If $g_iDebugWindowMessages Then SetDebugLog("GUIControl_WM_MOVE: $hWind=" & $hWind & ",$iMsg=" & $iMsg & ",$wParam=" & $wParam & ",$lParam=" & $lParam, Default, True)
If $hWind = $g_hFrmBot Then
If $g_bUpdatingWhenMinimized And BotWindowCheck() = False And _WinAPI_IsIconic($g_hFrmBot) Then
BotMinimize("GUIControl_WM_MOVE")
$g_bTogglePauseAllowed = $wasAllowed
SetCriticalMessageProcessing($wasCritical)
Return $GUI_RUNDEFMSG
EndIf
Local $g_iFrmBotPos = WinGetPos($g_hFrmBot)
If $g_bAndroidEmbedded = False Then
$g_iFrmBotPosX =($g_iFrmBotPos[0] > -30000 ? $g_iFrmBotPos[0] : $g_iFrmBotPosX)
$g_iFrmBotPosY =($g_iFrmBotPos[1] > -30000 ? $g_iFrmBotPos[1] : $g_iFrmBotPosY)
Else
$g_iFrmBotDockedPosX =($g_iFrmBotPos[0] > -30000 ? $g_iFrmBotPos[0] : $g_iFrmBotDockedPosX)
$g_iFrmBotDockedPosY =($g_iFrmBotPos[1] > -30000 ? $g_iFrmBotPos[1] : $g_iFrmBotDockedPosY)
EndIf
If $g_bAndroidEmbedded And AndroidEmbedArrangeActive() = False Then
CheckBotShrinkExpandButton()
Local $iAction = AndroidEmbedCheck(True)
If $iAction > 0 Then
AndroidEmbedCheck(False, Default, $iAction)
EndIf
If $g_iDebugWindowMessages Then
Local $a = $g_iFrmBotPos
SetDebugLog("Bot Position: " & $a[0] & "," & $a[1] & " " & $a[2] & "x" & $a[3])
$a = WinGetPos($g_hAndroidWindow)
SetDebugLog("Android Position: " & $a[0] & "," & $a[1] & " " & $a[2] & "x" & $a[3])
If $g_hFrmBotEmbeddedMouse <> 0 Then
$a = WinGetPos($g_hFrmBotEmbeddedMouse)
SetDebugLog("Mouse Window Position: " & $a[0] & "," & $a[1] & " " & $a[2] & "x" & $a[3])
EndIf
EndIf
EndIf
EndIf
$g_bTogglePauseAllowed = $wasAllowed
SetCriticalMessageProcessing($wasCritical)
Return $GUI_RUNDEFMSG
EndFunc
Func SetTime($bForceUpdate = False)
If $g_hTimerSinceStarted = 0 Then Return
Local $day = 0, $hour = 0, $min = 0, $sec = 0
If GUICtrlGetState($g_hLblResultGoldNow) <> $GUI_ENABLE + $GUI_SHOW Or $bForceUpdate = True Then
_TicksToTime(Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed), $hour, $min, $sec)
GUICtrlSetData($g_hLblResultRuntimeNow, StringFormat("%02i:%02i:%02i", $hour, $min, $sec))
EndIf
EndFunc
Func TogglePause()
TogglePauseImpl("Mini")
EndFunc
Func btnStart()
BotStart()
EndFunc
Func btnStop()
BotStop()
EndFunc
Func btnPause()
TogglePause()
EndFunc
Func btnResume()
TogglePause()
EndFunc
Func btnVillageStat($source = "")
If $g_iFirstRun = 0 And $g_bRunState And Not $g_bBotPaused Then SetTime(True)
If GUICtrlGetState($g_hLblResultGoldNow) = $GUI_ENABLE + $GUI_SHOW Then
GUICtrlSetState($g_hLblResultGoldNow, $GUI_ENABLE + $GUI_HIDE)
GUICtrlSetState($g_hLblResultElixirNow, $GUI_ENABLE + $GUI_HIDE)
GUICtrlSetState($g_hLblResultDENow, $GUI_ENABLE + $GUI_HIDE)
GUICtrlSetState($g_hLblResultTrophyNow, $GUI_ENABLE + $GUI_HIDE)
GUICtrlSetState($g_hLblResultBuilderNow, $GUI_ENABLE + $GUI_HIDE)
GUICtrlSetState($g_hLblResultGemNow, $GUI_ENABLE + $GUI_HIDE)
GUICtrlSetState($g_hLblResultGoldHourNow, $GUI_ENABLE + $GUI_SHOW)
GUICtrlSetState($g_hLblResultElixirHourNow, $GUI_ENABLE + $GUI_SHOW)
GUICtrlSetState($g_hLblResultDEHourNow, $GUI_ENABLE + $GUI_SHOW)
If $g_iFirstRun = 0 Or $source = "UpdateStats" Then
GUICtrlSetState($g_hLblResultRuntimeNow, $GUI_ENABLE + $GUI_SHOW)
GUICtrlSetState($g_hLblResultAttackedHourNow, $GUI_ENABLE + $GUI_SHOW)
GUICtrlSetState($g_hLblResultSkippedHourNow, $GUI_ENABLE + $GUI_SHOW)
EndIf
GUICtrlSetState($g_hPicResultTrophyNow, $GUI_ENABLE + $GUI_HIDE)
GUICtrlSetState($g_hPicResultBuilderNow, $GUI_ENABLE + $GUI_HIDE)
GUICtrlSetState($g_hPicResultGemNow, $GUI_ENABLE + $GUI_HIDE)
GUICtrlSetState($g_hPicResultRuntimeNow, $GUI_ENABLE + $GUI_SHOW)
GUICtrlSetState($g_hPicResultAttackedHourNow, $GUI_ENABLE + $GUI_SHOW)
GUICtrlSetState($g_hPicResultSkippedHourNow, $GUI_ENABLE + $GUI_SHOW)
Else
GUICtrlSetState($g_hLblResultGoldNow, $GUI_ENABLE + $GUI_SHOW)
GUICtrlSetState($g_hLblResultElixirNow, $GUI_ENABLE + $GUI_SHOW)
GUICtrlSetState($g_hLblResultDENow, $GUI_ENABLE + $GUI_SHOW)
GUICtrlSetState($g_hLblResultTrophyNow, $GUI_ENABLE + $GUI_SHOW)
GUICtrlSetState($g_hLblResultBuilderNow, $GUI_ENABLE + $GUI_SHOW)
GUICtrlSetState($g_hLblResultGemNow, $GUI_ENABLE + $GUI_SHOW)
GUICtrlSetState($g_hLblResultGoldHourNow, $GUI_ENABLE + $GUI_HIDE)
GUICtrlSetState($g_hLblResultElixirHourNow, $GUI_ENABLE + $GUI_HIDE)
GUICtrlSetState($g_hLblResultDEHourNow, $GUI_ENABLE + $GUI_HIDE)
GUICtrlSetState($g_hLblResultRuntimeNow, $GUI_ENABLE + $GUI_HIDE)
GUICtrlSetState($g_hLblResultAttackedHourNow, $GUI_ENABLE + $GUI_HIDE)
GUICtrlSetState($g_hLblResultSkippedHourNow, $GUI_ENABLE + $GUI_HIDE)
GUICtrlSetState($g_hPicResultTrophyNow, $GUI_ENABLE + $GUI_SHOW)
GUICtrlSetState($g_hPicResultBuilderNow, $GUI_ENABLE + $GUI_SHOW)
GUICtrlSetState($g_hPicResultGemNow, $GUI_ENABLE + $GUI_SHOW)
GUICtrlSetState($g_hPicResultRuntimeNow, $GUI_ENABLE + $GUI_HIDE)
GUICtrlSetState($g_hPicResultAttackedHourNow, $GUI_ENABLE + $GUI_HIDE)
GUICtrlSetState($g_hPicResultSkippedHourNow, $GUI_ENABLE + $GUI_HIDE)
EndIf
EndFunc
Func btnHide()
EndFunc
Func btnSearchMode()
EndFunc
Func btnEmbed()
EndFunc
Func chkBackground()
EndFunc
Func tiStartStop()
If $g_bRunState Then
btnStop()
Else
btnStart()
EndIf
EndFunc
Func tiShow()
BotRestore("tiShow")
EndFunc
Func tiHide()
$g_bHideWhenMinimized = Not $g_bHideWhenMinimized
TrayItemSetState($g_hTiHide,($g_bHideWhenMinimized ? $TRAY_CHECKED : $TRAY_UNCHECKED))
If $g_bFrmBotMinimized = True Then
If $g_bHideWhenMinimized = False Then
BotRestore("tiHide")
Else
BotMinimize("tiHide")
EndIf
EndIf
EndFunc
Func tiAbout()
Local $sMsg = "Clash of Clans Bot" & @CRLF & @CRLF & "Version: " & $g_sBotVersion & @CRLF & "Released under the GNU GPLv3 license." & @CRLF & "Visit www.MyBot.run"
MsgBox(64 + $MB_APPLMODAL + $MB_TOPMOST, $g_sBotTitle, $sMsg, 0, $g_hFrmBot)
EndFunc
Func tiDonate()
ShellExecute("https://mybot.run/forums/index.php?/donate/make-donation/")
EndFunc
Func tiExit()
BotCloseRequest()
EndFunc
Func BotStarted()
SetDebugLog("Bot started")
GUICtrlSetState($g_hBtnStart, $GUI_HIDE)
GUICtrlSetState($g_hBtnStop, $GUI_SHOW)
GUICtrlSetState($g_hBtnPause, $g_bBotPaused ? $GUI_HIDE : $GUI_SHOW)
GUICtrlSetState($g_hBtnResume, $g_bBotPaused ? $GUI_SHOW : $GUI_HIDE)
GUICtrlSetState($g_hBtnSearchMode, $GUI_HIDE)
GUICtrlSetState($g_hChkBackgroundMode, $GUI_DISABLE)
GUICtrlSetState($g_hBtnStart, $GUI_ENABLE)
GUICtrlSetState($g_hBtnStop, $GUI_ENABLE)
TrayItemSetText($g_hTiStartStop, GetTranslatedFileIni("MBR GUI Design - Loading", "StatusBar_Item_Stop", "Stop bot"))
TrayItemSetState($g_hTiPause, $TRAY_ENABLE)
TrayItemSetText($g_hTiPause, GetTranslatedFileIni("MBR GUI Design - Loading", "StatusBar_Item_Pause", "Pause bot"))
EndFunc
Func BotStopped()
SetDebugLog("Bot stopped")
GUICtrlSetState($g_hChkBackgroundMode, $GUI_ENABLE)
GUICtrlSetState($g_hBtnStart, $GUI_SHOW)
GUICtrlSetState($g_hBtnStop, $GUI_HIDE)
GUICtrlSetState($g_hBtnPause, $GUI_HIDE)
GUICtrlSetState($g_hBtnResume, $GUI_HIDE)
GUICtrlSetState($g_hBtnSearchMode, $GUI_SHOW)
GUICtrlSetState($g_hBtnStart, $GUI_ENABLE)
GUICtrlSetState($g_hBtnStop, $GUI_ENABLE)
TrayItemSetText($g_hTiStartStop, GetTranslatedFileIni("MBR GUI Design - Loading", "StatusBar_Item_Start", "Start bot"))
TrayItemSetState($g_hTiPause, $TRAY_DISABLE)
EndFunc
Func BotPaused()
SetDebugLog("Bot paused")
GUICtrlSetState($g_hBtnPause, $GUI_HIDE)
GUICtrlSetState($g_hBtnResume, $GUI_SHOW)
TrayItemSetText($g_hTiPause, GetTranslatedFileIni("MBR GUI Design - Loading", "StatusBar_Item_Resume", "Resume bot"))
EndFunc
Func BotResumed()
SetDebugLog("Bot resumed")
GUICtrlSetState($g_hBtnPause, $GUI_SHOW)
GUICtrlSetState($g_hBtnResume, $GUI_HIDE)
TrayItemSetText($g_hTiPause, GetTranslatedFileIni("MBR GUI Design - Loading", "StatusBar_Item_Pause", "Pause bot"))
EndFunc
Func UpdateManagedMyBot($aBotDetails)
If $g_iDebugWindowMessages Then SetDebugLog("UpdateManagedMyBot: " & $aBotDetails[$g_eBotDetailsBotForm])
Local $sTitle = $aBotDetails[$g_eBotDetailsTitle]
Local $bRunState = $aBotDetails[$g_eBotDetailsRunState]
Local $bPaused = $aBotDetails[$g_eBotDetailsPaused]
Local $bLaunched = $aBotDetails[$g_eBotDetailsLaunched]
Local $tBotState = $aBotDetails[$g_eBotDetailsBotStateStruct]
Local $tOptionalStruct = $aBotDetails[$g_eBotDetailsOptionalStruct]
Local $sProfile = ""
Local $sEmulator = ""
Local $sInstance = ""
Local $eStructType = $g_eSTRUCT_NONE
Local $pStructPtr = 0
Local $hTimerSinceStarted = 0
Local $iTimePassed = 0
If $tBotState <> 0 Then
If $g_iDebugWindowMessages Then SetDebugLog("UpdateManagedMyBot: Update Sate: " & $aBotDetails[$g_eBotDetailsBotForm])
$sProfile = DllStructGetData($tBotState, "Profile")
$sEmulator = DllStructGetData($tBotState, "AndroidEmulator")
$sInstance = DllStructGetData($tBotState, "AndroidInstance")
$eStructType = DllStructGetData($tBotState, "StructType")
$pStructPtr = DllStructGetData($tBotState, "StructPtr")
$hTimerSinceStarted = DllStructGetData($tBotState, "g_hTimerSinceStarted")
$iTimePassed = DllStructGetData($tBotState, "g_iTimePassed")
EndIf
Local $hFrmBotBackend = $g_hFrmBotBackend
Local $WatchOnlyClientPID = $g_WatchOnlyClientPID
If $hFrmBotBackend = 0 And $g_sAndroidEmulator = $sEmulator And $g_sAndroidInstance = $sInstance Then
$hFrmBotBackend = $aBotDetails[$g_eBotDetailsBotForm]
$WatchOnlyClientPID = WinGetProcess($hFrmBotBackend)
EndIf
If $hFrmBotBackend = 0 Or $hFrmBotBackend <> $aBotDetails[$g_eBotDetailsBotForm] Then
Return False
EndIf
$g_WatchOnlyClientPID = $WatchOnlyClientPID
$g_hFrmBotBackend = $hFrmBotBackend
Local $sStatusBar = Default
Local $AdditionalData
If $pStructPtr Then
Switch $eStructType
Case $g_eSTRUCT_STATUS_BAR
If $g_iDebugWindowMessages Then SetDebugLog("UpdateManagedMyBot: Update Status Bar: " & $aBotDetails[$g_eBotDetailsBotForm] & ", $pStructPtr=" & $pStructPtr)
$sStatusBar = DllStructGetData($tOptionalStruct, "Text")
_GUICtrlStatusBar_SetTextEx($g_hStatusBar, $sStatusBar)
$AdditionalData = $sStatusBar
Case $g_eSTRUCT_UPDATE_STATS
If $g_iDebugWindowMessages Then SetDebugLog("UpdateManagedMyBot: Receive Update Stats: " & $aBotDetails[$g_eBotDetailsBotForm] & ", $pStructPtr=" & $pStructPtr)
_DllStructLoadData($tOptionalStruct, "g_aiCurrentLoot", $g_aiCurrentLoot)
_DllStructLoadData($tOptionalStruct, "g_iFreeBuilderCount", $g_iFreeBuilderCount)
_DllStructLoadData($tOptionalStruct, "g_iTotalBuilderCount", $g_iTotalBuilderCount)
_DllStructLoadData($tOptionalStruct, "g_iGemAmount", $g_iGemAmount)
_DllStructLoadData($tOptionalStruct, "g_iStatsTotalGain", $g_iStatsTotalGain)
_DllStructLoadData($tOptionalStruct, "g_iStatsLastAttack", $g_iStatsLastAttack)
_DllStructLoadData($tOptionalStruct, "g_iStatsBonusLast", $g_iStatsBonusLast)
_DllStructLoadData($tOptionalStruct, "g_iFirstAttack", $g_iFirstAttack)
_DllStructLoadData($tOptionalStruct, "g_aiAttackedCount", $g_aiAttackedCount)
_DllStructLoadData($tOptionalStruct, "g_iSkippedVillageCount", $g_iSkippedVillageCount)
$g_iBotAction = $eBotUpdateStats
EndSwitch
EndIf
If $hTimerSinceStarted <> $g_hTimerSinceStarted Then
$g_hTimerSinceStarted = $hTimerSinceStarted
EndIf
If $iTimePassed <> $g_iTimePassed Then
$g_iTimePassed = $iTimePassed
EndIf
If $g_iDebugWindowMessages Then SetDebugLog("UpdateManagedMyBot: " & $aBotDetails[$g_eBotDetailsBotForm] & ", Profile: " & $sProfile & ", Android: " & $sEmulator & ", Instance: " & $sInstance & ", StructType: " & $eStructType & ", Ptr: " & $pStructPtr & ", Data:" & $AdditionalData)
If $g_sProfileCurrentName <> $sProfile Then
$g_sProfileCurrentName = $sProfile
GUICtrlSetData($g_hGrpVillage, GetTranslatedFileIni("MBR GUI Design Bottom", "GrpVillage", "Village") & ": " & $g_sProfileCurrentName)
EndIf
If $sEmulator <> "" Then $g_sAndroidEmulator = $sEmulator
If $sInstance <> "" Then $g_sAndroidInstance = $sInstance
UpdateBotTitle($sTitle)
Local $bStartStopInconsistent =(BitAND(GUICtrlGetState($g_hBtnStart), $GUI_SHOW) > 0 And $g_bRunState = True) Or(BitAND(GUICtrlGetState($g_hBtnStop), $GUI_SHOW) > 0 And $g_bRunState = False)
If $bRunState And(Not $g_bRunState Or $bStartStopInconsistent) Then
$g_bBotPaused = $bPaused
BotStarted()
ElseIf Not $bRunState And($g_bRunState = True Or $bStartStopInconsistent) Then
BotStopped()
Else
If $bPaused And Not $g_bBotPaused Then
BotPaused()
ElseIf Not $bPaused And $g_bBotPaused Then
BotResumed()
EndIf
EndIf
$g_bRunState = $bRunState
$g_bBotPaused = $bPaused
$g_bBotLaunched = $bLaunched
Return True
EndFunc
Func LaunchBotBackend($bNoGUI = True)
Local $sParam = ""
For $i = 1 To $CmdLine[0]
Switch $CmdLine[$i]
Case "/ng", "/mg"
Case "/restart"
Case Else
If $sParam = "" Then
$sParam = $CmdLine[$i]
Else
$sParam &= " " & $CmdLine[$i]
EndIf
EndSwitch
Next
$sParam = StringStripWS($sParam &($bNoGUI ? " /ng" : "") & " /guipid=" & @AutoItPID, 3)
Local $cmd = """" & @ScriptDir & "\MyBot.run.exe"""
If @Compiled = 0 Then $cmd = """" & @AutoItExe & """ /AutoIt3ExecuteScript """ & @ScriptDir & "\MyBot.run.au3" & """"
$cmd &= " " & $sParam
Local $hTimer = __TimerInit()
Local $pid = 0
Local $bCheck = True
$g_bBotLaunched = False
$g_hFrmBotBackend = 0
$g_WatchOnlyClientPID = Default
SetLog("Check if backend My Bot process is already running...")
While __TimerDiff($hTimer) < 5 * 60 * 1000
If $g_WatchOnlyClientPID = Default And __TimerDiff($hTimer) > $g_iBotBackendFindTimeout Then
$bCheck = False
SetLog("My Bot backend process not found, launching now...")
SetDebugLog("My Bot backend process launching: " & $cmd)
$pid = Run($cmd, @ScriptDir)
If $pid = 0 Then
SetLog("Cannot launch My Bot backend process", $COLOR_RED)
Return 0
EndIf
If $g_iDebugSetlog Then
SetDebugLog("My Bot backend process launched, PID = " & $pid)
Else
SetLog("My Bot backend process launched")
EndIf
$g_WatchOnlyClientPID = $pid
ClearManagedMyBotDetails()
EndIf
If $g_bBotLaunched Then
If ProcessExists($g_WatchOnlyClientPID) Then
$pid = $g_WatchOnlyClientPID
ExitLoop
Else
$g_WatchOnlyClientPID = Default
EndIf
Else
If $g_WatchOnlyClientPID <> Default And ProcessExists($g_WatchOnlyClientPID) = 0 Then
SetDebugLog("My Bot backend process not launched, PID = " & $g_WatchOnlyClientPID)
$g_WatchOnlyClientPID = Default
EndIf
EndIf
_WinAPI_BroadcastSystemMessage($WM_MYBOTRUN_API, 0x01FF, $g_hFrmBot, $BSF_POSTMESSAGE + $BSF_IGNORECURRENTTASK, $BSM_APPLICATIONS)
Sleep(2000)
WEnd
If Not $g_bBotLaunched Then SetLog("Bot didn't launch in 5 Minutes")
Return $pid
EndFunc
Func BotStart()
If $g_hFrmBotBackend = 0 Or $g_WatchOnlyClientPID = 0 Or WinGetProcess($g_hFrmBotBackend) <> $g_WatchOnlyClientPID Then
LaunchBotBackend()
If Not $g_bBotLaunched Then Return
EndIf
GUICtrlSetState($g_hBtnStart, $GUI_DISABLE)
_WinAPI_PostMessage($g_hFrmBotBackend, $WM_MYBOTRUN_API, 0x1000, $g_hFrmBot)
EndFunc
Func BotStop()
If $g_hFrmBotBackend = 0 Or $g_WatchOnlyClientPID = 0 Or WinGetProcess($g_hFrmBotBackend) <> $g_WatchOnlyClientPID Then
LaunchBotBackend()
If Not $g_bBotLaunched Then Return
EndIf
GUICtrlSetState($g_hBtnStop, $GUI_DISABLE)
_WinAPI_PostMessage($g_hFrmBotBackend, $WM_MYBOTRUN_API, 0x1010, $g_hFrmBot)
EndFunc
Func btnMakeScreenshot()
_WinAPI_PostMessage($g_hFrmBotBackend, $WM_MYBOTRUN_API, 0x1050, $g_hFrmBot)
EndFunc
Func TogglePauseImpl($source)
If $g_bBotPaused Then
_WinAPI_PostMessage($g_hFrmBotBackend, $WM_MYBOTRUN_API, 0x1020, $g_hFrmBot)
Else
_WinAPI_PostMessage($g_hFrmBotBackend, $WM_MYBOTRUN_API, 0x1030, $g_hFrmBot)
EndIf
EndFunc
Func BotClose($SaveConfig = Default, $bExit = True)
_WinAPI_PostMessage($g_hFrmBotBackend, $WM_MYBOTRUN_API, 0x1040, $g_hFrmBot)
$g_bRunState = False
$g_bBotPaused = False
SetLog("Closing " & $g_sBotTitle & " now ...")
LockBotSlot(False)
ReleaseMutex($hMutex_BotTitle)
DllClose("ntdll.dll")
_GDIPlus_Shutdown()
_Crypt_Shutdown()
GUIDelete($g_hFrmBot)
$g_aiAndroidAdbScreencapBuffer = 0
$g_hStruct_SleepMicro = 0
If $bExit = True Then Exit
EndFunc
Func ReferenceFunctions()
If True Then Return
UpdateManagedMyBot(0)
GetTroopName(0)
EndFunc
Func ReferenceGlobals()
If True Then Return
EndFunc
ProcessCommandLine()
_Crypt_Startup()
_GDIPlus_Startup()
$g_iGuiMode = 2
$g_bGuiRemote = True
$g_WatchDogLogStatusBar = True
$g_iDebugSetlog = 1
SetupProfileFolder()
InitAndroidConfig()
If FileExists($g_sProfileConfigPath) Or FileExists($g_sProfileBuildingPath) Then
readConfig()
EndIf
InitializeAndroid()
CreateMainGUI()
CreateMainGUIControls()
LaunchBotBackend()
If $g_bBotLaunched Then
_WinAPI_PostMessage($g_hFrmBotBackend, $WM_MYBOTRUN_API, 0x0200, $g_hFrmBot)
EndIf
GUICtrlSetState($g_hBtnStart, $GUI_ENABLE)
ShowMainGUI()
_WinAPI_PostMessage($g_hFrmBotBackend, $WM_MYBOTRUN_API, 0x1060, $g_hFrmBot)
GUISetOnEvent($GUI_EVENT_CLOSE, "GUIEvents", $g_hFrmBot)
GUISetOnEvent($GUI_EVENT_MINIMIZE, "GUIEvents", $g_hFrmBot)
GUISetOnEvent($GUI_EVENT_RESTORE, "GUIEvents", $g_hFrmBot)
GUIRegisterMsg($WM_COMMAND, "GUIControl_WM_COMMAND")
GUIRegisterMsg($WM_CLOSE, "GUIControl_WM_CLOSE")
GUIRegisterMsg($WM_MOVE, "GUIControl_WM_MOVE")
DllCall("user32.dll", "none", "DisableProcessWindowsGhosting")
Local $hStatusUpdateTimer = 0, $hTimeUpdateTimer = 0
Local $iMainLoop = 1
While 1
_Sleep($g_iMainLoopSleep, True, False)
Switch $g_iBotAction
Case $eBotClose
BotClose()
Case $eBotUpdateStats
UpdateStats()
$g_iBotAction = $eBotNoAction
Case Else
If $iMainLoop > 20 And($hStatusUpdateTimer = 0 Or __TimerDiff($hStatusUpdateTimer) > $iTimeoutBroadcast) Then
$iMainLoop = 0
$hStatusUpdateTimer = __TimerInit()
_WinAPI_PostMessage($g_hFrmBotBackend, $WM_MYBOTRUN_API, 0x0200, $g_hFrmBot)
EndIf
If $hTimeUpdateTimer = 0 Or __TimerDiff($hTimeUpdateTimer) > 750 Then
SetTime()
$hTimeUpdateTimer = __TimerInit()
EndIf
EndSwitch
$iMainLoop += 1
WEnd
ReferenceFunctions()
ReferenceGlobals()
