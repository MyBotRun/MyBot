; #FUNCTION# ====================================================================================================================
; Name ..........: MakeScreenshot
; Description ...: This file creates a snapshot of the user base
; Syntax ........: MakeScreenshot($TargetDir[, $type = "jpg"])
; Parameters ....: $TargetDir           - required - location to save file
;                  $type                - [optional] string - type of image to save ("jpg", "png", "bmp"). Default is "jpg".
; Return values .: None
; Author ........: Sardo (2015-06)
; Modified ......: Hervidero, ProMac (2015-10), MonkeyHunter (2016-2)
; Remarks .......: This file is part of MyBot Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func MakeScreenshot($TargetDir, $type = "jpg")

	If WinGetAndroidHandle() <> 0 Then

		Local $SuspendMode
		Local $iLeft = 0, $iTop = 0, $iRight = $AndroidClientWidth, $iBottom = $AndroidClientHeight ; set size of ENTIRE screen to save
		Local $iW = Number($iRight) - Number($iLeft)
		Local $iH = Number($iBottom) - Number($iTop)
		Local $hBitmapScreenshot
		Local $hGraphic, $hBrush

		$hHBitmapScreenshot = _CaptureRegion($iLeft, $iTop, $iRight, $iBottom, False, True)
		$hBitmapScreenshot = _GDIPlus_BitmapCreateFromHBITMAP($hHBitmapScreenshot)

		$hGraphic = _GDIPlus_ImageGetGraphicsContext($hBitmapScreenshot) ; Get graphics content from bitmap image
		$hBrush = _GDIPlus_BrushCreateSolid(0xFF000029) ;create a brush AARRGGBB (using 0x000029 = Dark Blue)
		If $ichkScreenshotHideName = 1 Then
			If $aCCPos[0] = -1 Or $aCCPos[1] = -1 Then
				Setlog("Screenshot warning: Locate the Clan Castle to hide the clanname!", $COLOR_RED)
			EndIf
			_GDIPlus_GraphicsFillRect($hGraphic, 0, 0, 250, 50, $hBrush) ;draw filled rectangle on the image to hide the user IGN
			If $aCCPos[0] <> -1 Then _GDIPlus_GraphicsFillRect($hGraphic, $aCCPos[0] - 33, $aCCPos[1] - 2, 66, 18, $hBrush) ;draw filled rectangle on the image to hide the user CC if position is known
		EndIf
		Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
		Local $Time = @HOUR & "." & @MIN & "." & @SEC
		Local $filename = $Date & "_" & $Time & "." & $type  ; most systems support type = png, jpg, bmp, gif, tif
		_GDIPlus_ImageSaveToFile($hBitmapScreenshot, $TargetDir & $filename)
		If FileExists($TargetDir & $filename) = 1 Then
			If $dirTemp = $TargetDir Then
				SetLog("Screenshot saved: .\Profiles\" & $sCurrProfile & "\Temp\" & $filename)
			Else
				SetLog("Screenshot saved: " & $TargetDir & $filename)
			EndIf
		Else
			SetLog("Screenshot file not created!", $COLOR_RED)
		EndIf
		$iMakeScreenshotNow = False
		;reduce mem
		_GDIPlus_BrushDispose($hBrush)
		_GDIPlus_GraphicsDispose($hGraphic)
		_GDIPlus_BitmapDispose($hBitmapScreenshot)
		_WinAPI_DeleteObject($hHBitmapScreenshot)

	Else
		SetLog("Not in game", $COLOR_RED)
	EndIf

EndFunc   ;==>MakeScreenshot


