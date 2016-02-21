
; #FUNCTION# ====================================================================================================================
; Name ..........: _CaptureRegion
; Description ...: Saves a screenshot of the window into memory.
; Syntax ........: _CaptureRegion([$iLeft = 0[, $iTop = 0[, $iRight = $DEFAULT_WIDTH[, $iBottom = $DEFAULT_HEIGHT[,
;                  $ReturnBMP = False]]]]])
; Parameters ....: $iLeft               - [optional] an integer value. Default is 0.
;                  $iTop                - [optional] an integer value. Default is 0.
;                  $iRight              - [optional] an integer value. Default is $DEFAULT_WIDTH.
;                  $iBottom             - [optional] an integer value. Default is $DEFAULT_HEIGHT.
;                  $ReturnBMP           - [optional] an unknown value. Default is False.
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _CaptureRegion($iLeft = 0, $iTop = 0, $iRight = $DEFAULT_WIDTH, $iBottom = $DEFAULT_HEIGHT, $ReturnBMP = False)
    Local $SuspendMode
	_GDIPlus_BitmapDispose($hBitmap)
	_WinAPI_DeleteObject($hHBitmap)

	If $ichkBackground = 1 Then
		Local $iW = Number($iRight) - Number($iLeft), $iH = Number($iBottom) - Number($iTop)

		If $AndroidAdbScreencap = True Then
		   $hHBitmap = AndroidScreencap($iLeft, $iTop, $iW, $iH)
	    Else
		   $SuspendMode = ResumeAndroid(False)
		   Local $hDC_Capture = _WinAPI_GetWindowDC(ControlGetHandle($Title, "", $AppClassInstance))
		   Local $hMemDC = _WinAPI_CreateCompatibleDC($hDC_Capture)
		   $hHBitmap = _WinAPI_CreateCompatibleBitmap($hDC_Capture, $iW, $iH)
		   Local $hObjectOld = _WinAPI_SelectObject($hMemDC, $hHBitmap)

		   DllCall("user32.dll", "int", "PrintWindow", "hwnd", $HWnD, "handle", $hMemDC, "int", 0)
		   _WinAPI_SelectObject($hMemDC, $hHBitmap)
		   _WinAPI_BitBlt($hMemDC, 0, 0, $iW, $iH, $hDC_Capture, $iLeft, $iTop, 0x00CC0020)

		   _WinAPI_DeleteDC($hMemDC)
		   _WinAPI_SelectObject($hMemDC, $hObjectOld)
		   _WinAPI_ReleaseDC($HWnD, $hDC_Capture)
		   SuspendAndroid($SuspendMode, False)
	    EndIf
	    Global $hBitmap = _GDIPlus_BitmapCreateFromHBITMAP($hHBitmap)
	Else
	    getBSPos()
		$SuspendMode = ResumeAndroid(False)
		$hHBitmap = _ScreenCapture_Capture("", $iLeft + $BSpos[0], $iTop + $BSpos[1], $iRight + $BSpos[0] - 1, $iBottom + $BSpos[1] - 1, False)
		Global $hBitmap = _GDIPlus_BitmapCreateFromHBITMAP($hHBitmap)
		SuspendAndroid($SuspendMode, False)
	EndIf

	If $ReturnBMP Then Return $hBitmap
EndFunc   ;==>_CaptureRegion

Func _CaptureRegion2($iLeft = 0, $iTop = 0, $iRight = $DEFAULT_WIDTH, $iBottom = $DEFAULT_HEIGHT)
    Local $SuspendMode
	Local $hHBitmap

	If $ichkBackground = 1 Then
		Local $iW = Number($iRight) - Number($iLeft), $iH = Number($iBottom) - Number($iTop)

		If $AndroidAdbScreencap = True Then
		   $hHBitmap = AndroidScreencap($iLeft, $iTop, $iW, $iH)
	    Else
		   $SuspendMode = ResumeAndroid(False)
		   Local $hDC_Capture = _WinAPI_GetWindowDC(ControlGetHandle($Title, "", $AppClassInstance))
		   Local $hMemDC = _WinAPI_CreateCompatibleDC($hDC_Capture)
		   $hHBitmap = _WinAPI_CreateCompatibleBitmap($hDC_Capture, $iW, $iH)
		   Local $hObjectOld = _WinAPI_SelectObject($hMemDC, $hHBitmap)

		   DllCall("user32.dll", "int", "PrintWindow", "hwnd", $HWnD, "handle", $hMemDC, "int", 0)
		   _WinAPI_SelectObject($hMemDC, $hHBitmap)
		   _WinAPI_BitBlt($hMemDC, 0, 0, $iW, $iH, $hDC_Capture, $iLeft, $iTop, 0x00CC0020)

		   ;Global $hBitmap = _GDIPlus_BitmapCreateFromHBITMAP($hHBitmap)

		   _WinAPI_DeleteDC($hMemDC)
		   _WinAPI_SelectObject($hMemDC, $hObjectOld)
		   _WinAPI_ReleaseDC($HWnD, $hDC_Capture)
		   SuspendAndroid($SuspendMode, False)
	    EndIf
	Else
	    getBSPos()
		$SuspendMode = ResumeAndroid(False)
		$hHBitmap = _ScreenCapture_Capture("", $iLeft + $BSpos[0], $iTop + $BSpos[1], $iRight + $BSpos[0] - 1, $iBottom + $BSpos[1] - 1, False)
		SuspendAndroid($SuspendMode, False)
	EndIf

	Return $hHBitmap
EndFunc   ;==>_CaptureRegion2

Func _CaptureRegionScreenshot($iLeft = 0, $iTop = 0, $iRight = $DEFAULT_WIDTH, $iBottom = $DEFAULT_HEIGHT, $ReturnBMP = False)
    Local $SuspendMode
	_GDIPlus_BitmapDispose($hBitmapScreenshot)
	_WinAPI_DeleteObject($hHBitmapScreenshot)

	If $ichkBackground = 1 Then
		Local $iW = Number($iRight) - Number($iLeft), $iH = Number($iBottom) - Number($iTop)

		If $AndroidAdbScreencap = True Then
		   $hHBitmapScreenshot = AndroidScreencap($iLeft, $iTop, $iW, $iH)
	    Else
		   $SuspendMode = ResumeAndroid(False)
		   Local $hDC_Capture = _WinAPI_GetWindowDC(ControlGetHandle($Title, "", $AppClassInstance))
		   Local $hMemDC = _WinAPI_CreateCompatibleDC($hDC_Capture)
		   $hHBitmapScreenshot = _WinAPI_CreateCompatibleBitmap($hDC_Capture, $iW, $iH)
		   Local $hObjectOld = _WinAPI_SelectObject($hMemDC, $hHBitmapScreenshot)

		   DllCall("user32.dll", "int", "PrintWindow", "hwnd", $HWnD, "handle", $hMemDC, "int", 0)
		   _WinAPI_SelectObject($hMemDC, $hHBitmapScreenshot)
		   _WinAPI_BitBlt($hMemDC, 0, 0, $iW, $iH, $hDC_Capture, $iLeft, $iTop, 0x00CC0020)

		   _WinAPI_DeleteDC($hMemDC)
		   _WinAPI_SelectObject($hMemDC, $hObjectOld)
		   _WinAPI_ReleaseDC($HWnD, $hDC_Capture)
		   SuspendAndroid($SuspendMode, False)
	    EndIF
	    Global $hBitmapScreenshot = _GDIPlus_BitmapCreateFromHBITMAP($hHBitmapScreenshot)
	Else
        getBSPos()
		$SuspendMode = ResumeAndroid(False)
		$hHBitmapScreenshot = _ScreenCapture_Capture("", $iLeft + $BSpos[0], $iTop + $BSpos[1], $iRight + $BSpos[0] - 1, $iBottom + $BSpos[1] - 1, False)
		Global $hBitmapScreenshot = _GDIPlus_BitmapCreateFromHBITMAP($hHBitmapScreenshot)
		SuspendAndroid($SuspendMode, False)
	EndIf

	If $ReturnBMP Then Return $hBitmapScreenshot
EndFunc   ;==>_CaptureRegionScreenshot

Func FastCaptureRegion()
   Return $ichkBackground = 1 And $AndroidAdbScreencap = False
EndFunc

Func NeedCaptureRegion($icount)
   Local $bNeedCaptureRegion = FastCaptureRegion() Or Mod($icount, 10) = 0
   Return $bNeedCaptureRegion
EndFunc