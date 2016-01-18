; #FUNCTION# ====================================================================================================================
; Name ..........: AttackCSVDEBUGIMAGE
; Description ...:
; Syntax ........: AttackCSVDEBUGIMAGE()
; Parameters ....:
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func AttackCSVDEBUGIMAGE()
	;MAKE SCREENSHOT WITH INFO
	DebugImageSave("clean")
	_CaptureRegion()
	Local $EditedImage = $hBitmap
	Local $testx
	Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($EditedImage)
	Local $hBrush = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)

	; Open box of crayons :-)
	Local $hPenLtGreen = _GDIPlus_PenCreate(0xFF00DC00, 2)
	Local $hPenDkGreen = _GDIPlus_PenCreate(0xFF006E00, 2)
	Local $hPenMdGreen = _GDIPlus_PenCreate(0xFF4CFF00, 2)
	Local $hPenRed = _GDIPlus_PenCreate(0xFFFF0000, 2)
	Local $hPenDkRed = _GDIPlus_PenCreate(0xFF6A0000, 2)
	Local $hPenBlue = _GDIPlus_PenCreate(0xFF0026FF, 2)
	Local $hPenCyan = _GDIPlus_PenCreate(0xFF00FFFF, 2)
	Local $hPenYellow = _GDIPlus_PenCreate(0xFFFFD800, 2)
	Local $hPenLtGrey = _GDIPlus_PenCreate(0xFFCCCCCC, 2)

	;-- DRAW EXTERNAL PERIMETER LINES
	_GDIPlus_GraphicsDrawLine($hGraphic, $ExternalArea[0][0], $ExternalArea[0][1], $ExternalArea[2][0], $ExternalArea[2][1], $hPenLtGreen)
	_GDIPlus_GraphicsDrawLine($hGraphic, $ExternalArea[0][0], $ExternalArea[0][1], $ExternalArea[3][0], $ExternalArea[3][1], $hPenLtGreen)
	_GDIPlus_GraphicsDrawLine($hGraphic, $ExternalArea[1][0], $ExternalArea[1][1], $ExternalArea[2][0], $ExternalArea[2][1], $hPenLtGreen)
	_GDIPlus_GraphicsDrawLine($hGraphic, $ExternalArea[1][0], $ExternalArea[1][1], $ExternalArea[3][0], $ExternalArea[3][1], $hPenLtGreen)

	;-- DRAW EXTERNAL PERIMETER LINES
	_GDIPlus_GraphicsDrawLine($hGraphic, $InternalArea[0][0], $InternalArea[0][1], $InternalArea[2][0], $InternalArea[2][1], $hPenDkGreen)
	_GDIPlus_GraphicsDrawLine($hGraphic, $InternalArea[0][0], $InternalArea[0][1], $InternalArea[3][0], $InternalArea[3][1], $hPenDkGreen)
	_GDIPlus_GraphicsDrawLine($hGraphic, $InternalArea[1][0], $InternalArea[1][1], $InternalArea[2][0], $InternalArea[2][1], $hPenDkGreen)
	_GDIPlus_GraphicsDrawLine($hGraphic, $InternalArea[1][0], $InternalArea[1][1], $InternalArea[3][0], $InternalArea[3][1], $hPenDkGreen)

	;-- DRAW VERTICAL AND ORIZONTAL LINES
	_GDIPlus_GraphicsDrawLine($hGraphic, $InternalArea[2][0], 0, $InternalArea[2][0], $DEFAULT_HEIGHT, $hPenDkGreen)
	_GDIPlus_GraphicsDrawLine($hGraphic, 0, $InternalArea[0][1], $DEFAULT_WIDTH, $InternalArea[0][1], $hPenDkGreen)

	;-- DRAW DIAGONALS LINES
	_GDIPlus_GraphicsDrawLine($hGraphic, $ExternalArea[4][0], $ExternalArea[4][1], $ExternalArea[7][0], $ExternalArea[7][1], $hPenLtGreen)
	_GDIPlus_GraphicsDrawLine($hGraphic, $ExternalArea[5][0], $ExternalArea[5][1], $ExternalArea[6][0], $ExternalArea[6][1], $hPenLtGreen)


	;-- DRAW REDAREA PATH
	For $i = 0 To UBound($PixelTopLeft) - 1
		$pixel = $PixelTopLeft[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenRed)
	Next
	For $i = 0 To UBound($PixelTopRight) - 1
		$pixel = $PixelTopRight[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenRed)
	Next
	For $i = 0 To UBound($PixelBottomLeft) - 1
		$pixel = $PixelBottomLeft[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenRed)
	Next
	For $i = 0 To UBound($PixelBottomRight) - 1
		$pixel = $PixelBottomRight[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenRed)
	Next

	;DRAW FULL DROP LINES PATH

	For $i = 0 To UBound($PixelTopLeftDropLine) - 1
		$pixel = $PixelTopLeftDropLine[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenBlue)
	Next
	For $i = 0 To UBound($PixelTopRightDropLine) - 1
		$pixel = $PixelTopRightDropLine[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenCyan)
	Next
	For $i = 0 To UBound($PixelBottomLeftDropLine) - 1
		$pixel = $PixelBottomLeftDropLine[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenYellow)
	Next
	For $i = 0 To UBound($PixelBottomRightDropLine) - 1
		$pixel = $PixelBottomRightDropLine[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenLtGrey)
	Next

	;DRAW SLICES DROP PATH LINES
	For $i = 0 To UBound($PixelTopLeftDOWNDropLine) - 1
		$pixel = $PixelTopLeftDOWNDropLine[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenBlue)
	Next
	For $i = 0 To UBound($PixelTopLeftUPDropLine) - 1
		$pixel = $PixelTopLeftUPDropLine[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenCyan)
	Next
	For $i = 0 To UBound($PixelBottomLeftDOWNDropLine) - 1
		$pixel = $PixelBottomLeftDOWNDropLine[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenYellow)
	Next
	For $i = 0 To UBound($PixelBottomLeftUPDropLine) - 1
		$pixel = $PixelBottomLeftUPDropLine[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenLtGrey)
	Next
	For $i = 0 To UBound($PixelTopRightDOWNDropLine) - 1
		$pixel = $PixelTopRightDOWNDropLine[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenBlue)
	Next
	For $i = 0 To UBound($PixelTopRightUPDropLine) - 1
		$pixel = $PixelTopRightUPDropLine[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenCyan)
	Next
	For $i = 0 To UBound($PixelBottomRightDOWNDropLine) - 1
		$pixel = $PixelBottomRightDOWNDropLine[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenYellow)
	Next
	For $i = 0 To UBound($PixelBottomRightUPDropLine) - 1
		$pixel = $PixelBottomRightUPDropLine[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenLtGrey)
	Next

	;DRAW DROP POINTS EXAMPLES
	$testx = MakeDropPoints("TOP-LEFT-DOWN", 10, 2, "EXT-INT")
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0], $pixel[1], "Arial", 12)
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenRed)
	Next

	$testx = MakeDropPoints("TOP-LEFT-DOWN", 10, 4, "EXT-INT") ;
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0] - 10, $pixel[1] - 10, "Arial", 12)
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenMdGreen)
	Next

	$testx = MakeDropPoints("BOTTOM-LEFT-UP", 10, 2, "EXT-INT")
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0], $pixel[1], "Arial", 12)
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenRed)
	Next

	$testx = MakeDropPoints("BOTTOM-LEFT-UP", 10, 4, "EXT-INT") ;
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0] - 10, $pixel[1] - 10, "Arial", 12)
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenMdGreen)
	Next

	$testx = MakeDropPoints("TOP-RIGHT-DOWN", 10, 2, "EXT-INT")
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0], $pixel[1], "Arial", 12)
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenRed)
	Next

	$testx = MakeDropPoints("TOP-RIGHT-DOWN", 10, 4, "EXT-INT") ;
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0] - 10, $pixel[1] - 10, "Arial", 12)
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenMdGreen)
	Next

	$testx = MakeDropPoints("BOTTOM-RIGHT-UP", 10, 2, "EXT-INT")
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0], $pixel[1], "Arial", 12)
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenRed)
	Next

	$testx = MakeDropPoints("BOTTOM-RIGHT-UP", 10, 4, "EXT-INT") ;
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0] - 10, $pixel[1] - 10, "Arial", 12)
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenMdGreen)
	Next

	$testx = MakeDropPoints("TOP-LEFT-UP", 10, 2, "INT-EXT")
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0], $pixel[1], "Arial", 12)
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenRed)
	Next

	$testx = MakeDropPoints("TOP-LEFT-UP", 10, 4, "INT-EXT") ;
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0] - 10, $pixel[1] - 10, "Arial", 12)
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenMdGreen)
	Next

	$testx = MakeDropPoints("BOTTOM-LEFT-DOWN", 10, 2, "INT-EXT")
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0], $pixel[1], "Arial", 12)
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenRed)
	Next

	$testx = MakeDropPoints("BOTTOM-LEFT-DOWN", 10, 4, "INT-EXT") ;
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0] - 10, $pixel[1] - 10, "Arial", 12)
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenMdGreen)
	Next

	$testx = MakeDropPoints("TOP-RIGHT-UP", 10, 2, "INT-EXT")
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0], $pixel[1], "Arial", 12)
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenRed)
	Next

	$testx = MakeDropPoints("TOP-RIGHT-UP", 10, 4, "INT-EXT") ;
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0] - 10, $pixel[1] - 10, "Arial", 12)
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenMdGreen)
	Next

	$testx = MakeDropPoints("BOTTOM-RIGHT-DOWN", 10, 2, "INT-EXT")
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0], $pixel[1], "Arial", 12)
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenRed)
	Next

	$testx = MakeDropPoints("BOTTOM-RIGHT-DOWN", 10, 4, "INT-EXT") ;
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0] - 10, $pixel[1] - 10, "Arial", 12)
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenMdGreen)
	Next

	; 06 - DRAW MINES, ELIXIR, DRILLS ------------------------------------------------------------------------
	For $i = 0 To UBound($PixelMine) - 1
		$pixel = $PixelMine[$i]
		_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 10, $pixel[1] - 10, 20, 20, $hPenLtGreen)
	Next
	For $i = 0 To UBound($PixelElixir) - 1
		$pixel = $PixelElixir[$i]
		_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 10, $pixel[1] - 10, 20, 20, $hPenDkGreen)
	Next
	For $i = 0 To UBound($PixelDarkElixir) - 1
		$pixel = $PixelDarkElixir[$i]
		_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 10, $pixel[1] - 10, 20, 20, $hPenDkRed)
	Next

	; - DRAW TOWNHALL -------------------------------------------------------------------
	_GDIPlus_GraphicsDrawRect($hGraphic, $THX - 15, $THY - 15, 30, 30, $hPenRed)

	; 99 -  DRAW SLICE NUMBERS
	_GDIPlus_GraphicsDrawString($hGraphic, "1", 580, 580, "Arial", 20)
	_GDIPlus_GraphicsDrawString($hGraphic, "2", 750, 450, "Arial", 20)
	_GDIPlus_GraphicsDrawString($hGraphic, "3", 750, 200, "Arial", 20)
	_GDIPlus_GraphicsDrawString($hGraphic, "4", 580, 110, "Arial", 20)
	_GDIPlus_GraphicsDrawString($hGraphic, "5", 260, 110, "Arial", 20)
	_GDIPlus_GraphicsDrawString($hGraphic, "6", 110, 200, "Arial", 20)
	_GDIPlus_GraphicsDrawString($hGraphic, "7", 110, 450, "Arial", 20)
	_GDIPlus_GraphicsDrawString($hGraphic, "8", 310, 580, "Arial", 20)

	Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
	Local $Time = @HOUR & "." & @MIN & "." & @SEC
	Local $filename = String("AttackDebug_" & $Date & "_" & $Time)
	_GDIPlus_ImageSaveToFile($EditedImage, $dirTempDebug & $filename & ".jpg")

	; Clean up resources
	_GDIPlus_PenDispose($hPenLtGreen)
	_GDIPlus_PenDispose($hPenDkGreen)
	_GDIPlus_PenDispose($hPenMdGreen)
	_GDIPlus_PenDispose($hPenRed)
	_GDIPlus_PenDispose($hPenDkRed)
	_GDIPlus_PenDispose($hPenBlue)
	_GDIPlus_PenDispose($hPenCyan)
	_GDIPlus_PenDispose($hPenYellow)
	_GDIPlus_PenDispose($hPenLtGrey)
	_GDIPlus_BrushDispose($hBrush)
	_GDIPlus_GraphicsDispose($hGraphic)

EndFunc   ;==>AttackCSVDEBUGIMAGE
