; #FUNCTION# ====================================================================================================================
; Name ..........: _CheckPixel
; Description ...: _CheckPixel : takes an Screencode array[4] as a parameter, [x, y, color, tolerance], $bNeedCapture is used to make a 2x2 capture if needed in the _GetPixelColor function
; Syntax ........: _CheckPixel($tab, $bNeedCapture)
; Parameters ....: $aScreenCode, $bNeedCapture
; Return values .: True when the referenced pixel is found, False if not found
; Author ........: FastFrench (2015)
; Modified ......: Hervidero (2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func _CheckPixel($aScreenCode, $bNeedCapture = False, $Ignore = "")
	If _ColorCheck(_GetPixelColor($aScreenCode[0], $aScreenCode[1], $bNeedCapture), Hex($aScreenCode[2], 6), $aScreenCode[3], $Ignore) Then Return True
	Return False;
EndFunc   ;==>_CheckPixel
