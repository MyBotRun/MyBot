; #FUNCTION# ====================================================================================================================
; Name ..........: _GUICtrlCreatePic
; Description ...: Creates a Picture control for the GUI, PNG image can be used.
; Syntax ........: _GUICtrlCreatePic($sFilename_or_hBitmap, $iLeft, $iTop, $iWidth, $iHeight, $iStyle = -1 , $iExStyle = -1)
; Parameters ....: $sFilename_or_hBitmap - Path of image file or $g_hBitmap (then not disposed!)
; Return values .: Control ID
; Author ........: UEZ
; Modified ......: Melba23, guinness, jpm, cosote
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
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
	Local $hPrevImage = GUICtrlSendMsg($idPic, $STM_SETIMAGE, 0, $hHBMP) ; $STM_SETIMAGE = 0x0172
	_WinAPI_DeleteObject($hPrevImage) ; Delete Prev image if any
	If IsPtr($sFilename_or_hBitmap) = 0 Then _GDIPlus_BitmapDispose($hBMP)
	If $g_hBitmap_Resized Then _GDIPlus_BitmapDispose($g_hBitmap_Resized)
	If $hBMP_Ctxt Then _GDIPlus_GraphicsDispose($hBMP_Ctxt)
	_WinAPI_DeleteObject($hHBMP)
	Return $idPic
EndFunc   ;==>_GUICtrlCreatePic
