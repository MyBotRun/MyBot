
; #FUNCTION# ====================================================================================================================
; Name ..........: _CaptureRegion
; Description ...: Saves a screenshot of the window into memory. Updates bitmap "$hBitmap" and bitmpa DC "$hHBitmap" Global handles
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

	If $RunState Then CheckAndroidRunning() ; Ensure Android is running

	If $ichkBackground = 1 Then
		Local $iW = Number($iRight) - Number($iLeft), $iH = Number($iBottom) - Number($iTop)

		If $AndroidAdbScreencap = True Then
			$hHBitmap = AndroidScreencap($iLeft, $iTop, $iW, $iH)
		Else
			$SuspendMode = ResumeAndroid(False)
			Local $hDC_Capture = _WinAPI_GetWindowDC(ControlGetHandle($HWnD, $AppPaneName, $AppClassInstance))
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

    $ForceCapture = False
	If $ReturnBMP Then Return $hBitmap
EndFunc   ;==>_CaptureRegion

; #FUNCTION# ====================================================================================================================
; Name ..........: _CaptureRegion2
; Description ...: Saves emulator screen shot into memory - updates global handle "$hHBitmap2" to bitmap new object
; Syntax ........: _CaptureRegion2([$iLeft = 0[, $iTop = 0[, $iRight = $DEFAULT_WIDTH[, $iBottom = $DEFAULT_HEIGHT]]]])
; Parameters ....: $iLeft               - [optional] an integer value. Default is 0.
;                  $iTop                - [optional] an integer value. Default is 0.
;                  $iRight              - [optional] an integer value. Default is $DEFAULT_WIDTH.
;                  $iBottom             - [optional] an integer value. Default is $DEFAULT_HEIGHT.
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _CaptureRegion2($iLeft = 0, $iTop = 0, $iRight = $DEFAULT_WIDTH, $iBottom = $DEFAULT_HEIGHT)

	Local $SuspendMode
	Local $iW = Number($iRight) - Number($iLeft)
	Local $iH = Number($iBottom) - Number($iTop)
	Local $hDC_Capture, $hMemDC, $hObjectOld

	_WinAPI_DeleteObject($hHBitmap2) ; delete previous DC object using global handle

	If $RunState Then CheckAndroidRunning() ; Ensure Android is running

	If $ichkBackground = 1 Then
		If $AndroidAdbScreencap = True Then ; do this when using screencap capture for background mode
			$hHBitmap2 = AndroidScreencap($iLeft, $iTop, $iW, $iH)
		Else
			$SuspendMode = ResumeAndroid(False)
			$hDC_Capture = _WinAPI_GetWindowDC(ControlGetHandle($HWnD, $AppPaneName, $AppClassInstance)) ; Get emulator DC information
			$hMemDC = _WinAPI_CreateCompatibleDC($hDC_Capture) ; create local compatible DC to emultor window
			$hHBitmap2 = _WinAPI_CreateCompatibleBitmap($hDC_Capture, $iW, $iH) ; create bitmap object with same DC as emulator
			$hObjectOld = _WinAPI_SelectObject($hMemDC, $hHBitmap2) ; Save previous graphics object, select new one

			DllCall("user32.dll", "int", "PrintWindow", "hwnd", $HWnD, "handle", $hMemDC, "int", 0)
			_WinAPI_SelectObject($hMemDC, $hHBitmap2)
			_WinAPI_BitBlt($hMemDC, 0, 0, $iW, $iH, $hDC_Capture, $iLeft, $iTop, $SRCCOPY) ; copy screen shot to DC

			_WinAPI_DeleteDC($hMemDC)
			_WinAPI_SelectObject($hMemDC, $hObjectOld)
			_WinAPI_ReleaseDC($HWnD, $hDC_Capture)
			SuspendAndroid($SuspendMode, False)
		EndIf
	Else  ; if not in background mode, do fast screen capture
		getBSPos()
		$SuspendMode = ResumeAndroid(False)
		$hHBitmap2 = _ScreenCapture_Capture("", $iLeft + $BSpos[0], $iTop + $BSpos[1], $iRight + $BSpos[0] - 1, $iBottom + $BSpos[1] - 1, False)
		SuspendAndroid($SuspendMode, False)
	EndIf

	$ForceCapture = False

EndFunc   ;==>_CaptureRegion2

Func FastCaptureRegion()
	Return $ichkBackground = 1 And $AndroidAdbScreencap = False
EndFunc   ;==>FastCaptureRegion

Func NeedCaptureRegion($iCount)
   Local $bNeedCaptureRegion = FastCaptureRegion() Or Mod($iCount, 10) = 0
   Return $bNeedCaptureRegion
EndFunc

Func ForceCaptureRegion($bForceCapture = True)
   $ForceCapture = $bForceCapture
EndFunc

