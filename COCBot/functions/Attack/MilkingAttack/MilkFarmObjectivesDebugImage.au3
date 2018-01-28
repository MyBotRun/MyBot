; #FUNCTION# ====================================================================================================================
; Name ..........:MilkFarmObjectivesDebugImage
; Description ...:Save file with locations of red area, buildings, and boundaries.
; Syntax ........:MilkFarmObjectivesDebugImage($vector, $maxtiles = 0)
; Parameters ....:$vector-list of objectives
;				  $maxtiles-tiles used to draw
; Return values .:None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: Noo
; ===============================================================================================================================

Func MilkFarmObjectivesDebugImage($vector, $maxtiles = 0)
	If $g_bDebugMilkingIMGmake Then
		_CaptureRegion()
		Local $EditedImage
		$EditedImage = $g_hBitmap
		Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($EditedImage)
		Local $hBrush = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)

		;-- DRAW REDAREA PATH
		Local $pixel
		Local $hPen = _GDIPlus_PenCreate(0xFFFF0000, 2)
		For $i = 0 To UBound($g_aiPixelTopLeft) - 1
			$pixel = $g_aiPixelTopLeft[$i]
			_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPen)
		Next
		For $i = 0 To UBound($g_aiPixelTopRight) - 1
			$pixel = $g_aiPixelTopRight[$i]
			_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPen)
		Next
		For $i = 0 To UBound($g_aiPixelBottomLeft) - 1
			$pixel = $g_aiPixelBottomLeft[$i]
			_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPen)
		Next
		For $i = 0 To UBound($g_aiPixelBottomRight) - 1
			$pixel = $g_aiPixelBottomRight[$i]
			_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPen)
		Next

		;DRAW
		Local $testx = StringSplit($vector, "|", 2)

		For $i = 0 To UBound($testx) - 1
			Local $pixel1 = StringSplit($testx[$i], ".", 2)
			If UBound($pixel1) >= 2 Then
				Local $level = $pixel1[1]
			Else
				Local $level = 0
			EndIf

			Local $resourceoffsetx = 0
			Local $resourceoffsety = 0

			Switch $pixel1[0]
				Case "gomine"
					Local $px = StringSplit($g_asMilkFarmOffsetMine[$level], "-", 2)
				Case "elixir"
					Local $px = StringSplit($g_asMilkFarmOffsetElixir[$level], "-", 2)
				Case "ddrill"
					Local $px = StringSplit($g_asMilkFarmOffsetDark[$level], "-", 2)
				Case Else
					Local $px = StringSplit("0-0", "-", 2)
			EndSwitch
			$resourceoffsetx = $px[0]
			$resourceoffsety = $px[1]

			If UBound($pixel1) >= 2 Then
				$pixel = StringSplit($pixel1[2], "-", 2)
				If UBound($pixel) = 2 Then
					_GDIPlus_PenDispose($hPen)
					Local $hPen = _GDIPlus_PenCreate(0xFFFF0000, 1)
					Local $x = 20
					_GDIPlus_GraphicsDrawLine($hGraphic, $pixel[0] + $resourceoffsetx, $pixel[1] + $resourceoffsety - $x, $pixel[0] + $resourceoffsetx, $pixel[1] + $resourceoffsety - 10, $hPen)
					_GDIPlus_GraphicsDrawLine($hGraphic, $pixel[0] + $resourceoffsetx, $pixel[1] + $resourceoffsety + 10, $pixel[0] + $resourceoffsetx, $pixel[1] + $resourceoffsety + $x, $hPen)
					_GDIPlus_GraphicsDrawLine($hGraphic, $pixel[0] + $resourceoffsetx - $x, $pixel[1] + $resourceoffsety, $pixel[0] + $resourceoffsetx - 10, $pixel[1] + $resourceoffsety, $hPen)
					_GDIPlus_GraphicsDrawLine($hGraphic, $pixel[0] + $resourceoffsetx + 10, $pixel[1] + $resourceoffsety, $pixel[0] + $resourceoffsetx + $x, $pixel[1] + $resourceoffsety, $hPen)

					;rectangle dist 0
					If $maxtiles >= 0 Then
						_GDIPlus_PenDispose($hPen)
						Local $hPen = _GDIPlus_PenCreate(0xFF0026FF, 1)
						Local $multiplier = 0
						_GDIPlus_GraphicsDrawLine($hGraphic, $pixel[0] + $resourceoffsetx - $g_iMilkFarmOffsetX - $g_iMilkFarmOffsetXStep * $multiplier, $pixel[1] + $resourceoffsety, $pixel[0] + $resourceoffsetx, $pixel[1] + $resourceoffsety - $g_iMilkFarmOffsetY - $g_iMilkFarmOffsetYStep * $multiplier, $hPen)
						_GDIPlus_GraphicsDrawLine($hGraphic, $pixel[0] + $resourceoffsetx - $g_iMilkFarmOffsetX - $g_iMilkFarmOffsetXStep * $multiplier, $pixel[1] + $resourceoffsety, $pixel[0] + $resourceoffsetx, $pixel[1] + $resourceoffsety + $g_iMilkFarmOffsetY + $g_iMilkFarmOffsetYStep * $multiplier, $hPen)
						_GDIPlus_GraphicsDrawLine($hGraphic, $pixel[0] + $resourceoffsetx, $pixel[1] + $resourceoffsety - $g_iMilkFarmOffsetY - $g_iMilkFarmOffsetYStep * $multiplier, $pixel[0] + $resourceoffsetx + $g_iMilkFarmOffsetX + $g_iMilkFarmOffsetXStep * $multiplier, $pixel[1] + $resourceoffsety, $hPen)
						_GDIPlus_GraphicsDrawLine($hGraphic, $pixel[0] + $resourceoffsetx, $pixel[1] + $resourceoffsety + $g_iMilkFarmOffsetY + $g_iMilkFarmOffsetYStep * $multiplier, $pixel[0] + $resourceoffsetx + $g_iMilkFarmOffsetX + $g_iMilkFarmOffsetXStep * $multiplier, $pixel[1] + $resourceoffsety, $hPen)
					EndIf
					If $maxtiles >= 1 Then ;rectangle dist 1
						_GDIPlus_PenDispose($hPen)
						Local $hPen = _GDIPlus_PenCreate(0xFF00FFFF, 1)
						Local $multiplier = 1
						_GDIPlus_GraphicsDrawLine($hGraphic, $pixel[0] + $resourceoffsetx - $g_iMilkFarmOffsetX - $g_iMilkFarmOffsetXStep * $multiplier, $pixel[1] + $resourceoffsety, $pixel[0] + $resourceoffsetx, $pixel[1] + $resourceoffsety - $g_iMilkFarmOffsetY - $g_iMilkFarmOffsetYStep * $multiplier, $hPen)
						_GDIPlus_GraphicsDrawLine($hGraphic, $pixel[0] + $resourceoffsetx - $g_iMilkFarmOffsetX - $g_iMilkFarmOffsetXStep * $multiplier, $pixel[1] + $resourceoffsety, $pixel[0] + $resourceoffsetx, $pixel[1] + $resourceoffsety + $g_iMilkFarmOffsetY + $g_iMilkFarmOffsetYStep * $multiplier, $hPen)
						_GDIPlus_GraphicsDrawLine($hGraphic, $pixel[0] + $resourceoffsetx, $pixel[1] + $resourceoffsety - $g_iMilkFarmOffsetY - $g_iMilkFarmOffsetYStep * $multiplier, $pixel[0] + $resourceoffsetx + $g_iMilkFarmOffsetX + $g_iMilkFarmOffsetXStep * $multiplier, $pixel[1] + $resourceoffsety, $hPen)
						_GDIPlus_GraphicsDrawLine($hGraphic, $pixel[0] + $resourceoffsetx, $pixel[1] + $resourceoffsety + $g_iMilkFarmOffsetY + $g_iMilkFarmOffsetYStep * $multiplier, $pixel[0] + $resourceoffsetx + $g_iMilkFarmOffsetX + $g_iMilkFarmOffsetXStep * $multiplier, $pixel[1] + $resourceoffsety, $hPen)
					EndIf
					If $maxtiles >= 2 Then ;rectangle dist 2
						_GDIPlus_PenDispose($hPen)
						Local $hPen = _GDIPlus_PenCreate(0xFFFFD800, 1)
						Local $multiplier = 2
						_GDIPlus_GraphicsDrawLine($hGraphic, $pixel[0] + $resourceoffsetx - $g_iMilkFarmOffsetX - $g_iMilkFarmOffsetXStep * $multiplier, $pixel[1] + $resourceoffsety, $pixel[0] + $resourceoffsetx, $pixel[1] + $resourceoffsety - $g_iMilkFarmOffsetY - $g_iMilkFarmOffsetYStep * $multiplier, $hPen)
						_GDIPlus_GraphicsDrawLine($hGraphic, $pixel[0] + $resourceoffsetx - $g_iMilkFarmOffsetX - $g_iMilkFarmOffsetXStep * $multiplier, $pixel[1] + $resourceoffsety, $pixel[0] + $resourceoffsetx, $pixel[1] + $resourceoffsety + $g_iMilkFarmOffsetY + $g_iMilkFarmOffsetYStep * $multiplier, $hPen)
						_GDIPlus_GraphicsDrawLine($hGraphic, $pixel[0] + $resourceoffsetx, $pixel[1] + $resourceoffsety - $g_iMilkFarmOffsetY - $g_iMilkFarmOffsetYStep * $multiplier, $pixel[0] + $resourceoffsetx + $g_iMilkFarmOffsetX + $g_iMilkFarmOffsetXStep * $multiplier, $pixel[1] + $resourceoffsety, $hPen)
						_GDIPlus_GraphicsDrawLine($hGraphic, $pixel[0] + $resourceoffsetx, $pixel[1] + $resourceoffsety + $g_iMilkFarmOffsetY + $g_iMilkFarmOffsetYStep * $multiplier, $pixel[0] + $resourceoffsetx + $g_iMilkFarmOffsetX + $g_iMilkFarmOffsetXStep * $multiplier, $pixel[1] + $resourceoffsety, $hPen)
					EndIf
				Else
					If $g_bDebugSetlog Then SetDebugLog("MilkFarmObjectivesDebugImage #1", $COLOR_DEBUG)
				EndIf
			Else
				If $g_bDebugSetlog Then SetDebugLog("MilkFarmObjectivesDebugImage #2", $COLOR_DEBUG)
			EndIf

		Next

		Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
		Local $Time = @HOUR & "." & @MIN & "." & @SEC
		Local $savefolder = $g_sProfileTempDebugPath & "MilkFarmDebug_" & "\"
		DirCreate($savefolder)

		Local $filename = String("MilkFarmDebug_" & $Date & "_" & $Time)
		_GDIPlus_ImageSaveToFile($EditedImage, $savefolder & $filename & ".jpg")

		; Clean up resources
		_GDIPlus_PenDispose($hPen)
		_GDIPlus_BrushDispose($hBrush)
		_GDIPlus_GraphicsDispose($hGraphic)
	EndIf
EndFunc   ;==>MilkFarmObjectivesDebugImage
