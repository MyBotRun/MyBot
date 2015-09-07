;~  @Sardo 2015-06 Make screenshot full screen
Func MakeScreenshot ( $TargetDir, $type ="jpg")
If IsArray(ControlGetPos($Title, "_ctl.Window", "[CLASS:BlueStacksApp; INSTANCE:1]")) Then
   _CaptureRegionScreenshot(0, 0, 860, 675)
	Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($hBitmapScreenshot)  ; Get graphics content from bitmap image
	Local $hBrush = _GDIPlus_BrushCreateSolid(0xFF000029) ;create a brush AARRGGBB (using 0x000029 = Dark Blue)
	If $ichkScreenshotHideName = 1 Then
		_GDIPlus_GraphicsFillRect($hGraphic, 0, 0, 250, 50, $hBrush) ;draw filled rectangle on the image to hide the user IGN
		If $aCCPos[0] <> -1 Then 	_GDIPlus_GraphicsFillRect($hGraphic, $aCCPos[0]-33, $aCCPos[1]-2, 66, 18, $hBrush) ;draw filled rectangle on the image to hide the user CC if position is known
	EndIf
   Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
   Local $Time = @HOUR & "." & @MIN & "." & @SEC
   Local $filename =  $Date & "_" & $Time & "." & $type
   _GDIPlus_ImageSaveToFile($hBitmapScreenshot, $TargetDir & $filename)
   If $dirTemp = $TargetDir Then
		SetLog ("Screenshot saved: .\Profiles\" & $sCurrProfile & "\Temp\" & $filename)
   Else
		SetLog ("Screenshot saved: " & $TargetDir & $filename)
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

EndFunc