
; #FUNCTION# ====================================================================================================================
; Name ..........: _GetPixelColor
; Description ...: Returns color of pixel in the coordinations
; Syntax ........: _GetPixelColor($iX, $iY[, $bNeedCapture = False])
; Parameters ....: $iX                  - x location.
;                  $iY                  - y location.
;                  $bNeedCapture        - [optional] a boolean value. Default is False.
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _GetPixelColor($iX, $iY, $bNeedCapture = False)
	If $bNeedCapture = False Or $RunState = False Then
		$aPixelColor = _GDIPlus_BitmapGetPixel($hBitmap, $iX, $iY)
	Else
		_CaptureRegion($iX - 1, $iY - 1, $iX + 1, $iY + 1)
		$aPixelColor = _GDIPlus_BitmapGetPixel($hBitmap, 1, 1)
	EndIf
	Return Hex($aPixelColor, 6)
EndFunc   ;==>_GetPixelColor
