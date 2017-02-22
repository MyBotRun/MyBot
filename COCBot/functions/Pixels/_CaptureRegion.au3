; #FUNCTION# ====================================================================================================================
; Name ..........: _CaptureRegion
; Description ...: Saves a screenshot of the window into memory. Updates bitmap "$hBitmap" and bitmpa DC "$hHBitmap" Global handles
; Syntax ........: _CaptureRegion([$iLeft = 0[, $iTop = 0[, $iRight = $g_iGAME_WIDTH[, $iBottom = $g_iGAME_HEIGHT[, $ReturnBMP[,
;                  $ReturnLocal_hHBitmap = False]]]]]])
; Parameters ....: $iLeft               - [optional] an integer value. Default is 0.
;                  $iTop                - [optional] an integer value. Default is 0.
;                  $iRight              - [optional] an integer value. Default is $g_iGAME_WIDTH.
;                  $iBottom             - [optional] an integer value. Default is $g_iGAME_HEIGHT.
;                  $ReturnBMP           - DEPRECATED! [optional] an boolean value. Default is False.
;                  $ReturnLocal_hHBitmap- [optional] an boolean value. Default is False, if True no global variables are changed
;                                         and Local $_hHBitmap is returned.
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _CaptureRegion(Const $iLeft = 0, Const $iTop = 0, Const $iRight = $g_iGAME_WIDTH, Const $iBottom = $g_iGAME_HEIGHT, Const $ReturnLocal_hHBitmap = False)

	If $ReturnLocal_hHBitmap Then
		Local $_hHBitmap
		_CaptureGameScreen($_hHBitmap, $iLeft, $iTop, $iRight, $iBottom)
		Return $_hHBitmap
	EndIf

	If $hHBitmap <> 0 And $hHBitmap <> $g_hHBitmapTest And $hHBitmap2 <> $hHBitmap Then
		GdiDeleteHBitmap($hHBitmap)
	EndIf
	_CaptureGameScreen($hHBitmap, $iLeft, $iTop, $iRight, $iBottom)

	If $hBitmap <> 0 Then
		GdiDeleteBitmap($hBitmap)
	EndIf
	$hBitmap = _GDIPlus_BitmapCreateFromHBITMAP($hHBitmap)
	GdiAddBitmap($hBitmap)

	Return $hHBitmap

EndFunc   ;==>_CaptureRegion

; #FUNCTION# ====================================================================================================================
; Name ..........: _CaptureRegion2
; Description ...: Saves emulator screen shot into memory - updates global handle "$hHBitmap2" to bitmap new object
; Syntax ........: _CaptureRegion2([$iLeft = 0[, $iTop = 0[, $iRight = $g_iGAME_WIDTH[, $iBottom = $g_iGAME_HEIGHT]]]])
; Parameters ....: $iLeft               - [optional] an integer value. Default is 0.
;                  $iTop                - [optional] an integer value. Default is 0.
;                  $iRight              - [optional] an integer value. Default is $g_iGAME_WIDTH.
;                  $iBottom             - [optional] an integer value. Default is $g_iGAME_HEIGHT.
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _CaptureRegion2(Const $iLeft = 0, Const $iTop = 0, Const $iRight = $g_iGAME_WIDTH, Const $iBottom = $g_iGAME_HEIGHT)

	If $hHBitmap2 <> 0 And $hHBitmap2 <> $g_hHBitmapTest And $hHBitmap2 <> $hHBitmap Then
		GdiDeleteHBitmap($hHBitmap2)
	EndIf
	_CaptureGameScreen($hHBitmap2, $iLeft, $iTop, $iRight, $iBottom)

EndFunc   ;==>_CaptureRegion2

; #FUNCTION# ====================================================================================================================
; Name ..........: _CaptureGameScreen
; Description ...: Saves a screenshot of the window into memory.
; Syntax ........: _CaptureGameScreen($_hHBitmap, [$iLeft = 0[, $iTop = 0[, $iRight = $g_iGAME_WIDTH[, $iBottom = $g_iGAME_HEIGHT]]]])
; Parameters ....: $_hHBitmap           - ByRef variable receiving the HBitmap
;                  $iLeft               - [optional] an integer value. Default is 0.
;                  $iTop                - [optional] an integer value. Default is 0.
;                  $iRight              - [optional] an integer value. Default is $g_iGAME_WIDTH.
;                  $iBottom             - [optional] an integer value. Default is $g_iGAME_HEIGHT.
; Return values .: None
; Author ........: cosote 2017-Feb
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _CaptureGameScreen(ByRef $_hHBitmap, Const $iLeft = 0, Const $iTop = 0, Const $iRight = $g_iGAME_WIDTH, Const $iBottom = $g_iGAME_HEIGHT)
	Local $SuspendMode

	If $g_hHBitmapTest = 0 Then
		If $g_bRunState Then CheckAndroidRunning() ; Ensure Android is running
		If $g_bChkBackgroundMode = True Then
			Local $iW = Number($iRight) - Number($iLeft), $iH = Number($iBottom) - Number($iTop)

			If $g_bAndroidAdbScreencap = True Then
				$_hHBitmap = AndroidScreencap($iLeft, $iTop, $iW, $iH)
			Else
				$SuspendMode = ResumeAndroid(False)
				;Local $hCtrl = ControlGetHandle($HWnD, $g_sAppPaneName, $g_sAppClassInstance)
				Local $hCtrl = ControlGetHandle(GetCurrentAndroidHWnD(), $g_sAppPaneName, $g_sAppClassInstance)
				If $hCtrl = 0 Then SetLog("AndroidHandle not found, contact support", $COLOR_ERROR)
				Local $hDC_Capture = _WinAPI_GetDC($hCtrl)
				Local $hMemDC = _WinAPI_CreateCompatibleDC($hDC_Capture)
				$_hHBitmap = _WinAPI_CreateCompatibleBitmap($hDC_Capture, $iW, $iH)
				Local $hObjectOld = _WinAPI_SelectObject($hMemDC, $_hHBitmap)

				Local $flags = 0
				; $PW_CLIENTONLY = 1 ; Only the client area of the window is copied to hdcBlt. By default, the entire window is copied.
				; $PW_RENDERFULLCONTENT = 2 ; New in Windows 8.1, can capture DirectX/OpenGL screens through DWM
				DllCall("user32.dll", "int", "PrintWindow", "hwnd", $hCtrl, "handle", $hMemDC, "int", $flags)
				_WinAPI_SelectObject($hMemDC, $_hHBitmap)
				_WinAPI_BitBlt($hMemDC, 0, 0, $iW, $iH, $hDC_Capture, $iLeft, $iTop, $SRCCOPY)

				_WinAPI_DeleteDC($hMemDC)
				_WinAPI_SelectObject($hMemDC, $hObjectOld)
				_WinAPI_ReleaseDC($hCtrl, $hDC_Capture)
				SuspendAndroid($SuspendMode, False)
			EndIf
		Else
			getBSPos()
			$SuspendMode = ResumeAndroid(False)
			$_hHBitmap = _ScreenCapture_Capture("", $iLeft + $g_aiBSpos[0], $iTop + $g_aiBSpos[1], $iRight + $g_aiBSpos[0] - 1, $iBottom + $g_aiBSpos[1] - 1, False)
			SuspendAndroid($SuspendMode, False)
		EndIf
	ElseIf $iLeft > 0 Or $iTop > 0 Or $iRight < $g_iGAME_WIDTH Or $iBottom < $g_iGAME_HEIGHT Then
		; resize test image
		$_hHBitmap = GetHHBitmapArea($g_hHBitmapTest, $iLeft, $iTop, $iRight, $iBottom)
	Else
		; use test image
		$_hHBitmap = $g_hHBitmapTest
	EndIf

	GdiAddHBitmap($_hHBitmap)

	$g_bForceCapture = False
EndFunc   ;==>_CaptureGameScreen

; #FUNCTION# ====================================================================================================================
; Name ..........: _CaptureDispose
; Description ...: Disposes all bitmaps created by _CaptureRegion functions
; Syntax ........: _CaptureDispose()
; Parameters ....: None
; Return values .: None
; Author ........: cosote (Feb-2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _CaptureDispose()
	If $hBitmap <> 0 Then GdiDeleteBitmap($hBitmap)
	If $hHBitmap <> 0 Then GdiDeleteHBitmap($hHBitmap)
	If $hHBitmap2 <> 0 Then GdiDeleteHBitmap($hHBitmap2)
	If $g_hHBitmapTest <> 0 Then GdiDeleteHBitmap($g_hHBitmapTest)
	$hBitmap = 0
	$hHBitmap = 0
	$hHBitmap2 = 0
	$g_hHBitmapTest = 0
EndFunc   ;==>_CaptureDispose

; #FUNCTION# ====================================================================================================================
; Name ..........: _CaptureRegion2Sync
; Description ...: Updates $hHBitmap2 from $hHBitmap
; Syntax ........: _CaptureRegion2Sync()
; Parameters ....: None
; Return values .: None
; Author ........: cosote
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _CaptureRegion2Sync()
	If $hHBitmap2 <> 0 And $hHBitmap2 <> $g_hHBitmapTest And $hHBitmap2 <> $hHBitmap Then
		GdiDeleteHBitmap($hHBitmap2)
	EndIf
	$hHBitmap2 = GetHHBitmapArea($hHBitmap)
EndFunc   ;==>_CaptureRegion2Sync

; #FUNCTION# ====================================================================================================================
; Name ..........: GetHHBitmapArea
; Description ...: Creates a new hHBitmap of given $_hHBitmap in requested size
; Syntax ........: GetHHBitmapArea($_hHBitmap, [$iLeft = 0[, $iTop = 0[, $iRight = $g_iGAME_WIDTH[, $iBottom = $g_iGAME_HEIGHT]]]])
; Parameters ....: $_hHBitmap           - hHBitmap of source
;                  $iLeft               - [optional] an integer value. Default is 0.
;                  $iTop                - [optional] an integer value. Default is 0.
;                  $iRight              - [optional] an integer value. Default is $g_iGAME_WIDTH.
;                  $iBottom             - [optional] an integer value. Default is $g_iGAME_HEIGHT.
; Return values .: new hHBitmap Object of requested size
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func GetHHBitmapArea(Const $_hHBitmap, Const $iLeft = 0, Const $iTop = 0, Const $iRight = $g_iGAME_WIDTH, Const $iBottom = $g_iGAME_HEIGHT)
	Local $iW = Number($iRight) - Number($iLeft), $iH = Number($iBottom) - Number($iTop)
	Local $hDC = _WinAPI_GetDC($g_hFrmBot)
	Local $hMemDC_src = _WinAPI_CreateCompatibleDC($hDC)
	Local $hMemDC_dst = _WinAPI_CreateCompatibleDC($hDC)
	Local $_hHBitmapArea = _WinAPI_CreateCompatibleBitmap($hDC, $iW, $iH)
	Local $hObjectOld_src = _WinAPI_SelectObject($hMemDC_src, $_hHBitmap)
	Local $hObjectOld_dst = _WinAPI_SelectObject($hMemDC_dst, $_hHBitmapArea)

	_WinAPI_BitBlt($hMemDC_dst, 0, 0, $iW, $iH, $hMemDC_src, $iLeft, $iTop, $SRCCOPY)

	_WinAPI_SelectObject($hMemDC_src, $hObjectOld_src)
	_WinAPI_SelectObject($hMemDC_dst, $hObjectOld_dst)
	_WinAPI_ReleaseDC($g_hFrmBot, $hDC)
	_WinAPI_DeleteDC($hMemDC_src)
	_WinAPI_DeleteDC($hMemDC_dst)

	GdiAddHBitmap($_hHBitmapArea)

	Return $_hHBitmapArea
EndFunc   ;==>GetHHBitmapArea

; #FUNCTION# ====================================================================================================================
; Name ..........: FastCaptureRegion
; Description ...: Returns True is screencapture is using fast PrintWindow way
; Syntax ........: FastCaptureRegion()
; Parameters ....: None
; Return values .: Boolean
; Author ........: Cosote (2016-Aug)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func FastCaptureRegion()
	Return $g_bChkBackgroundMode = True And $g_bAndroidAdbScreencap = False
EndFunc   ;==>FastCaptureRegion

; #FUNCTION# ====================================================================================================================
; Name ..........: NeedCaptureRegion
; Description ...: Return True to tell routine a screen capture should be done in loops
; Syntax ........: NeedCaptureRegion($iCount)
; Parameters ....: $iCount              - An integer value. If FastCaptureRegion() is True or for every tenth count returns True.
; Return values .: Boolean
; Author ........: Cosote (2016-Aug)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func NeedCaptureRegion(Const $iCount)
	Local $bNeedCaptureRegion = FastCaptureRegion() Or Mod($iCount, 10) = 0
	Return $bNeedCaptureRegion
EndFunc   ;==>NeedCaptureRegion

; #FUNCTION# ====================================================================================================================
; Name ..........: ForceCaptureRegion
; Description ...: Forces to take a screen capture on next call to _CaptureRegion or _CaptureRegion2
; Syntax ........: ForceCaptureRegion([$bForceCapture = True])
; Parameters ....: $bForceCapture       - [optional] an boolean value. Default is True.
; Return values .: None
; Author ........: Cosote (2016-Aug)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func ForceCaptureRegion(Const $bForceCapture = True)
	$g_bForceCapture = $bForceCapture
EndFunc   ;==>ForceCaptureRegion

; #FUNCTION# ====================================================================================================================
; Name ..........: TestCapture
; Description ...: Sets or checks for test image returned by _CaptureRegion functions
; Syntax ........: TestCapture([$hHBitmap = Default])
; Parameters ....: $hHBitmap       - [optional] When Default it returns True if test image is configures or sets test image
; Return values .: True/False when checking for test image or configured test image when updated
; Author ........: Cosote (2016-Aug)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func TestCapture(Const $hHBitmap = Default)
	If $hHBitmap = Default Then Return $g_hHBitmapTest <> 0
	If $g_hHBitmapTest <> 0 Then _WinAPI_DeleteObject($g_hHBitmapTest) ; delete previous DC object using global handle
	$g_hHBitmapTest = $hHBitmap
	Return $hHBitmap
EndFunc   ;==>TestCapture

; #FUNCTION# ====================================================================================================================
; Name ..........: debugGdiHandle
; Description ...: Tracks changes on GDI Handle
; Syntax ........: debugGdiHandle("FuncName" [,$bLogAlways])
; Parameters ....: $sSource       - [optional] Function name that calls debugGdiHandle
;                : $bLogAlways    - [optional] Boolean alway log GDI Handle count
; Return values .: True/False when checking for test image or configured test image when updated
; Author ........: Cosote (2017-Feb)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func debugGdiHandle(Const $sSource, Const $bLogAlways = False)
	; track GDI count
	If $g_iDebugGDICount <> 0 Then
		Local $iCount = _WinAPI_GetGuiResources()
		If $iCount <> $g_iDebugGDICount Or $bLogAlways Then
			Local $sMsg = "GDI Handle Count: " & $iCount & " / " & ($iCount - $g_iDebugGDICount) & ", active: " & $g_oDebugGDIHandles.Count & " (" & $sSource & ")"
			$g_iDebugGDICount = $iCount
			If $g_iDebugGDICount > $g_iDebugGDICountMax Then
				$g_iDebugGDICountMax = $g_iDebugGDICount
				$sMsg &= " NEW MAX!"
			EndIf
			SetDebugLog($sMsg)
		EndIf
	EndIf
EndFunc   ;==>debugGdiHandle

Func GdiAddBitmap(Const $_hBitmap)
	If $g_iDebugGDICount <> 0 Then
		$g_oDebugGDIHandles("Bitmap:" & $_hBitmap) = Time()
		SetDebugLog("GdiAddBitmap " & $_hBitmap)
	EndIf
EndFunc   ;==>GdiAddBitmap

Func GdiDeleteBitmap(ByRef $_hBitmap)
	Local $Result = _GDIPlus_BitmapDispose($_hBitmap)
	If $Result <> True Or @error Then SetDebugLog("GdiDeleteBitmap not deleted: " & $_hBitmap)
	If $g_iDebugGDICount <> 0 Then
		$g_oDebugGDIHandles.Remove("Bitmap:" & $_hBitmap)
		SetDebugLog("GdiDeleteBitmap " & $_hBitmap)
	EndIf
	$_hBitmap = 0
EndFunc   ;==>GdiDeleteBitmap

Func GdiAddHBitmap(Const $_hHBitmap)
	If $g_iDebugGDICount <> 0 Then
		$g_oDebugGDIHandles("HBitmap:" & $_hHBitmap) = Time()
		SetDebugLog("GdiAddHBitmap " & $_hHBitmap)
	EndIf
EndFunc   ;==>GdiAddHBitmap

Func GdiDeleteHBitmap(ByRef $_hHBitmap)
	Local $Result = _WinAPI_DeleteObject($_hHBitmap)
	If $Result <> True Then SetDebugLog("GdiDeleteHBitmap not deleted: " & $_hHBitmap)
	If $g_iDebugGDICount <> 0 Then
		$g_oDebugGDIHandles.Remove("HBitmap:" & $_hHBitmap)
		SetDebugLog("GdiDeleteHBitmap " & $_hHBitmap)
	EndIf
	$_hHBitmap = 0
EndFunc   ;==>GdiDeleteHBitmap

Func __GDIPlus_Startup()
	_GDIPlus_Startup()
	$g_iDebugGDICountMax = _WinAPI_GetGuiResources() ; reset count to current
	debugGdiHandle("__GDIPlus_Startup", True)
EndFunc   ;==>__GDIPlus_Startup

Func __GDIPlus_Shutdown()
	_CaptureDispose()
	_GDIPlus_Shutdown()
	debugGdiHandle("__GDIPlus_Shutdown", True)
EndFunc   ;==>__GDIPlus_Shutdown
