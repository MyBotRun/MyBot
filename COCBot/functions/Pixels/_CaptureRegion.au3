; #FUNCTION# ====================================================================================================================
; Name ..........: _CaptureRegion
; Description ...: Saves a screenshot of the window into memory. Updates bitmap "$hBitmap" and bitmpa DC "$hHBitmap" Global handles
; Syntax ........: _CaptureRegion([$iLeft = 0[, $iTop = 0[, $iRight = $GAME_WIDTH[, $iBottom = $GAME_HEIGHT[, $ReturnBMP[,
;                  $ReturnLocal_hHBitmap = False]]]]]])
; Parameters ....: $iLeft               - [optional] an integer value. Default is 0.
;                  $iTop                - [optional] an integer value. Default is 0.
;                  $iRight              - [optional] an integer value. Default is $GAME_WIDTH.
;                  $iBottom             - [optional] an integer value. Default is $GAME_HEIGHT.
;                  $ReturnBMP           - DEPRECATED! [optional] an boolean value. Default is False.
;                  $ReturnLocal_hHBitmap- [optional] an boolean value. Default is False, if True no global variables are changed
;                                         and Local $_hHBitmap is returned.
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _CaptureRegion($iLeft = 0, $iTop = 0, $iRight = $GAME_WIDTH, $iBottom = $GAME_HEIGHT, $ReturnBMP = False, $ReturnLocal_hHBitmap = False)
	Local $SuspendMode

	If $ReturnLocal_hHBitmap = False Then
		_GDIPlus_BitmapDispose($hBitmap)
		If $hHBitmap <> $hHBitmapTest And $hHBitmap2 <> $hHBitmap Then _WinAPI_DeleteObject($hHBitmap)
	EndIf

	Local $_hHBitmap = $hHBitmapTest
	If $hHBitmapTest = 0 Then
		If $RunState Then CheckAndroidRunning() ; Ensure Android is running
		If $ichkBackground = 1 Then
			Local $iW = Number($iRight) - Number($iLeft), $iH = Number($iBottom) - Number($iTop)

			If $AndroidAdbScreencap = True Then
				$_hHBitmap = AndroidScreencap($iLeft, $iTop, $iW, $iH)
			Else
				$SuspendMode = ResumeAndroid(False)
				;Local $hCtrl = ControlGetHandle($HWnD, $AppPaneName, $AppClassInstance)
				Local $hCtrl = ControlGetHandle(GetCurrentAndroidHWnD(), $AppPaneName, $AppClassInstance)
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
			$_hHBitmap = _ScreenCapture_Capture("", $iLeft + $BSpos[0], $iTop + $BSpos[1], $iRight + $BSpos[0] - 1, $iBottom + $BSpos[1] - 1, False)
			SuspendAndroid($SuspendMode, False)
		EndIf
	ElseIf $iLeft > 0 Or $iTop > 0 Or $iRight < $GAME_WIDTH Or $iBottom < $GAME_HEIGHT Then
		; resize test image
		$_hHBitmap = GetHHBitmapArea($hHBitmapTest, $iLeft, $iTop, $iRight, $iBottom)
	EndIf

    $ForceCapture = False

	If $ReturnLocal_hHBitmap = False Then
		$hHBitmap = $_hHBitmap
		$hBitmap = _GDIPlus_BitmapCreateFromHBITMAP($hHBitmap)
		If $ReturnBMP = True Then Return $hBitmap
	Else
		Return $_hHBitmap
	EndIf
EndFunc   ;==>_CaptureRegion

; #FUNCTION# ====================================================================================================================
; Name ..........: _CaptureRegion2
; Description ...: Saves emulator screen shot into memory - updates global handle "$hHBitmap2" to bitmap new object
; Syntax ........: _CaptureRegion2([$iLeft = 0[, $iTop = 0[, $iRight = $GAME_WIDTH[, $iBottom = $GAME_HEIGHT]]]])
; Parameters ....: $iLeft               - [optional] an integer value. Default is 0.
;                  $iTop                - [optional] an integer value. Default is 0.
;                  $iRight              - [optional] an integer value. Default is $GAME_WIDTH.
;                  $iBottom             - [optional] an integer value. Default is $GAME_HEIGHT.
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _CaptureRegion2($iLeft = 0, $iTop = 0, $iRight = $GAME_WIDTH, $iBottom = $GAME_HEIGHT)

	If $hHBitmap2 <> $hHBitmapTest And $hHBitmap2 <> $hHBitmap Then
		_WinAPI_DeleteObject($hHBitmap2) ; delete previous DC object using global handle
	EndIf
	$hHBitmap2 = _CaptureRegion($iLeft, $iTop, $iRight, $iBottom, False, True)

EndFunc   ;==>_CaptureRegion2

; #FUNCTION# ====================================================================================================================
; Name ..........: _CaptureRegion2Sync
; Description ...: Updates $hHBitmap2 from $hHBitmap
; Syntax ........: _CaptureRegion2Sync()
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _CaptureRegion2Sync()
	If $hHBitmap2 <> $hHBitmapTest And $hHBitmap2 <> $hHBitmap Then
		_WinAPI_DeleteObject($hHBitmap2) ; delete previous DC object using global handle
	EndIf
	$hHBitmap2 = $hHBitmap
EndFunc   ;==>_CaptureRegion2Sync

; #FUNCTION# ====================================================================================================================
; Name ..........: GetHHBitmapArea
; Description ...: Creates a new hHBitmap of given $_hHBitmap in requested size
; Syntax ........: GetHHBitmapArea($_hHBitmap, [$iLeft = 0[, $iTop = 0[, $iRight = $GAME_WIDTH[, $iBottom = $GAME_HEIGHT]]]])
; Parameters ....: $_hHBitmap           - hHBitmap of source
;                  $iLeft               - [optional] an integer value. Default is 0.
;                  $iTop                - [optional] an integer value. Default is 0.
;                  $iRight              - [optional] an integer value. Default is $GAME_WIDTH.
;                  $iBottom             - [optional] an integer value. Default is $GAME_HEIGHT.
; Return values .: new hHBitmap Object of requested size
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func GetHHBitmapArea($_hHBitmap, $iLeft = 0, $iTop = 0, $iRight = $GAME_WIDTH, $iBottom = $GAME_HEIGHT)
	Local $iW = Number($iRight) - Number($iLeft), $iH = Number($iBottom) - Number($iTop)
	Local $hDC = _WinAPI_GetDC($frmBot)
	Local $hMemDC_src = _WinAPI_CreateCompatibleDC($hDC)
	Local $hMemDC_dst = _WinAPI_CreateCompatibleDC($hDC)
	Local $_hHBitmapArea = _WinAPI_CreateCompatibleBitmap($hDC, $iW, $iH)
	Local $hObjectOld_src = _WinAPI_SelectObject($hMemDC_src, $_hHBitmap)
	Local $hObjectOld_dst = _WinAPI_SelectObject($hMemDC_dst, $_hHBitmapArea)

	_WinAPI_BitBlt($hMemDC_dst, 0, 0, $iW, $iH, $hMemDC_src, $iLeft, $iTop, $SRCCOPY)

	_WinAPI_SelectObject($hMemDC_src, $hObjectOld_src)
	_WinAPI_SelectObject($hMemDC_dst, $hObjectOld_dst)
	_WinAPI_ReleaseDC($frmBot, $hDC)
	_WinAPI_DeleteDC($hMemDC_src)
	_WinAPI_DeleteDC($hMemDC_dst)

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
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func FastCaptureRegion()
	Return $ichkBackground = 1 And $AndroidAdbScreencap = False
EndFunc   ;==>FastCaptureRegion

; #FUNCTION# ====================================================================================================================
; Name ..........: NeedCaptureRegion
; Description ...: Return True to tell routine a screen capture should be done in loops
; Syntax ........: NeedCaptureRegion($iCount)
; Parameters ....: $iCount              - An integer value. If FastCaptureRegion() is True or for every tenth count returns True.
; Return values .: Boolean
; Author ........: Cosote (2016-Aug)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func NeedCaptureRegion($iCount)
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
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func ForceCaptureRegion($bForceCapture = True)
   $ForceCapture = $bForceCapture
EndFunc   ;==>ForceCaptureRegion

; #FUNCTION# ====================================================================================================================
; Name ..........: TestCapture
; Description ...: Sets or checks for test image returned by _CaptureRegion functions
; Syntax ........: TestCapture([$hHBitmap = Default])
; Parameters ....: $hHBitmap       - [optional] When Default it returns True if test image is configures or sets test image
; Return values .: True/False when checking for test image or configured test image when updated
; Author ........: Cosote (2016-Aug)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func TestCapture($hHBitmap = Default)
	If $hHBitmap = Default Then Return $hHBitmapTest <> 0
	If $hHBitmapTest <> 0 Then _WinAPI_DeleteObject($hHBitmapTest)  ; delete previous DC object using global handle
	$hHBitmapTest = $hHBitmap
	Return $hHBitmap
EndFunc   ;==>TestCapture