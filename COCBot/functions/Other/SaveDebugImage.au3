; #FUNCTION# ====================================================================================================================
; Name ..........: SaveDebugImage
; Description ...: Saves a copy of the current BS image to the Temp Folder for later review
; Syntax ........: SaveDebugImage()
; Parameters ....: $sImageName             - [optional] text string to use as part of saved filename. Default is "Unknown".
; Return values .: None
; Author ........: KnowJack (08/2015)
; Modified ......: Sardo (01/2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func SaveDebugImage($sImageName = "Unknown", $vCaptureNew = Default, $bCreateSubFolder = Default, $sTag = "")

	If $vCaptureNew = Default Then $vCaptureNew = True
	If $bCreateSubFolder = Default Then $bCreateSubFolder = True

	Local $sDate = @MDAY & "." & @MON & "." & @YEAR
	Local $sTime = @HOUR & "." & @MIN & "." & @SEC

	Local $sFolderPath = $g_sProfileTempDebugPath

	If $bCreateSubFolder Then
		$sFolderPath = $g_sProfileTempDebugPath & $sImageName & "\"
		DirCreate($sFolderPath)
	EndIf

	Local $bAlreadyExists = True, $bFirst = True
	local $iCount = 1
	Local $sFullFileName = ""

	While $bAlreadyExists
		If $bFirst Then
			$bFirst = False
			$sFullFileName = $sFolderPath & $sImageName & $sTag & $sDate & " at " & $sTime & ".png"
			If FileExists($sFullFileName) Then
				$bAlreadyExists = True
			Else
				$bAlreadyExists = False
			EndIf
		Else
			$sFullFileName = $sFolderPath & $sImageName & $sTag & $sDate & " at " & $sTime & " (" & $iCount & ").png"
			If FileExists($sFullFileName) Then
				$iCount +=1
			Else
				$bAlreadyExists = False
			EndIf
		EndIf
	WEnd

	If IsBool($vCaptureNew) And $vCaptureNew Then _CaptureRegion2()

	If IsPtr($vCaptureNew) Then
		_GDIPlus_ImageSaveToFile($vCaptureNew, $sFullFileName)
		SetDebugLog("DebugImageSave(" & $vCaptureNew & ") " & $sFullFileName, $COLOR_DEBUG)
	Else
		Local $EditedImage = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
		_GDIPlus_ImageSaveToFile($EditedImage, $sFullFileName)
		_GDIPlus_BitmapDispose($EditedImage)
		If $g_bDebugSetlog Then SetDebugLog("DebugImageSave " & $sFullFileName, $COLOR_DEBUG)
	EndIf

	If _Sleep($DELAYDEBUGIMAGESAVE1) Then Return
EndFunc   ;==>SaveDebugImage

Func SaveSCIDebugImage($sImageName = "Unknown", $vCaptureNew = Default, $bCreateSubFolder = Default, $sTag = "")

	If $vCaptureNew = Default Then $vCaptureNew = True
	If $bCreateSubFolder = Default Then $bCreateSubFolder = True

	Local $sDate = @MDAY & "." & @MON & "." & @YEAR
	Local $sTime = @HOUR & "." & @MIN & "." & @SEC

	Local $sFolderPath = $g_sProfileTempDebugPath

	If $bCreateSubFolder Then
		$sFolderPath = @ScriptDir & "\Profiles\" & $sImageName & "\"
		DirCreate($sFolderPath)
	EndIf

	Local $bAlreadyExists = True, $bFirst = True
	local $iCount = 1
	Local $sFullFileName = ""

	While $bAlreadyExists
		If $bFirst Then
			$bFirst = False
			$sFullFileName = $sFolderPath & $sImageName & $sTag & $sDate & " at " & $sTime & ".png"
			If FileExists($sFullFileName) Then
				$bAlreadyExists = True
			Else
				$bAlreadyExists = False
			EndIf
		Else
			$sFullFileName = $sFolderPath & $sImageName & $sTag & $sDate & " at " & $sTime & " (" & $iCount & ").png"
			If FileExists($sFullFileName) Then
				$iCount +=1
			Else
				$bAlreadyExists = False
			EndIf
		EndIf
	WEnd

	If IsBool($vCaptureNew) And $vCaptureNew Then _CaptureRegion2()

	If IsPtr($vCaptureNew) Then
		_GDIPlus_ImageSaveToFile($vCaptureNew, $sFullFileName)
		SetDebugLog("DebugImageSave(" & $vCaptureNew & ") " & $sFullFileName, $COLOR_DEBUG)
	Else
		Local $EditedImage = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
		_GDIPlus_ImageSaveToFile($EditedImage, $sFullFileName)
		_GDIPlus_BitmapDispose($EditedImage)
		If $g_bDebugSetlog Then SetDebugLog("DebugImageSave " & $sFullFileName, $COLOR_DEBUG)
	EndIf

	If _Sleep($DELAYDEBUGIMAGESAVE1) Then Return
EndFunc   ;==>SaveSCIDebugImage

Func SaveDebugRectImage($sImageName = "Unknown", $sArea = "" , $vCaptureNew = Default, $bCreateSubFolder = Default, $sTag = "")

	If $vCaptureNew = Default Then $vCaptureNew = True
	If $bCreateSubFolder = Default Then $bCreateSubFolder = True

	Local $aiArea = GetRectArray($sArea)

	Local $x1 = Number($aiArea[0])
	Local $y1 = Number($aiArea[1])
	Local $x2 = Number($aiArea[2])
	Local $y2 = Number($aiArea[3])

	Local $sDate = @MDAY & "." & @MON & "." & @YEAR
	Local $sTime = @HOUR & "." & @MIN & "." & @SEC

	Local $sFolderPath = $g_sProfileTempDebugPath

	If $bCreateSubFolder Then
		$sFolderPath = $g_sProfileTempDebugPath & $sImageName & "\"
		DirCreate($sFolderPath)
	EndIf

	Local $bAlreadyExists = True, $bFirst = True
	local $iCount = 1
	Local $sFullFileName = ""

	While $bAlreadyExists
		If $bFirst Then
			$bFirst = False
			$sFullFileName = $sFolderPath & $sImageName & $sTag & $sDate & " at " & $sTime & ".png"
			If FileExists($sFullFileName) Then
				$bAlreadyExists = True
			Else
				$bAlreadyExists = False
			EndIf
		Else
			$sFullFileName = $sFolderPath & $sImageName & $sTag & $sDate & " at " & $sTime & " (" & $iCount & ").png"
			If FileExists($sFullFileName) Then
				$iCount +=1
			Else
				$bAlreadyExists = False
			EndIf
		EndIf
	WEnd
	
	If IsBool($vCaptureNew) And $vCaptureNew Then _CaptureRegion2()

	If IsPtr($vCaptureNew) Then
		_GDIPlus_ImageSaveToFile($vCaptureNew, $sFullFileName)
		SetDebugLog("DebugImageSave(" & $vCaptureNew & ") " & $sFullFileName, $COLOR_DEBUG)
	Else
		; Store a copy of the image handle
		;Local $editedImage = $g_hBitmap
		Local $editedImage = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
		; Needed for editing the picture
		Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($editedImage)
		Local $hPen = _GDIPlus_PenCreate(0xFFFF0000, 2) ; Create a pencil Color FF0000/RED
		Local $hPen2 = _GDIPlus_PenCreate(0xFF000000, 2) ; Create a pencil Color FFFFFF/BLACK


		; crop image and put in $hClone
		;Local $oBitmap = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
		;Local $hClone = _GDIPlus_BitmapCloneArea($oBitmap, $x1, $y1, $x2 - $x1, $y2 - $y1, $GDIP_PXF24RGB)	

		_GDIPlus_GraphicsDrawRect($hGraphic, $x1, $y1, $x2 - $x1, $y2 - $y1, $hPen)
	
		_GDIPlus_ImageSaveToFile($editedImage, $sFullFileName)
		
		;_GDIPlus_BitmapDispose($hClone)
		;_GDIPlus_BitmapDispose($oBitmap)

		_GDIPlus_PenDispose($hPen)
		_GDIPlus_PenDispose($hPen2)
		_GDIPlus_GraphicsDispose($hGraphic)		
		_GDIPlus_BitmapDispose($editedImage)
		
		If $g_bDebugSetlog Then SetDebugLog("DebugImageSave " & $sFullFileName, $COLOR_DEBUG)
	EndIf

	If _Sleep($DELAYDEBUGIMAGESAVE1) Then Return
EndFunc   ;==>SaveDebugRectImage

Func SaveDebugPointImage($sImageName = "Unknown", $aiPoint = 0, $vCaptureNew = Default, $bCreateSubFolder = Default, $sTag = "")

	If $vCaptureNew = Default Then $vCaptureNew = True
	If $bCreateSubFolder = Default Then $bCreateSubFolder = True

	Local $x = $aiPoint[0]
	Local $y = $aiPoint[1]

	Local $sDate = @MDAY & "." & @MON & "." & @YEAR
	Local $sTime = @HOUR & "." & @MIN & "." & @SEC

	Local $sFolderPath = $g_sProfileTempDebugPath

	If $bCreateSubFolder Then
		$sFolderPath = $g_sProfileTempDebugPath & $sImageName & "\"
		DirCreate($sFolderPath)
	EndIf

	Local $bAlreadyExists = True, $bFirst = True
	local $iCount = 1
	Local $sFullFileName = ""

	While $bAlreadyExists
		If $bFirst Then
			$bFirst = False
			$sFullFileName = $sFolderPath & $sImageName & $sTag & $sDate & " at " & $sTime & ".png"
			If FileExists($sFullFileName) Then
				$bAlreadyExists = True
			Else
				$bAlreadyExists = False
			EndIf
		Else
			$sFullFileName = $sFolderPath & $sImageName & $sTag & $sDate & " at " & $sTime & " (" & $iCount & ").png"
			If FileExists($sFullFileName) Then
				$iCount +=1
			Else
				$bAlreadyExists = False
			EndIf
		EndIf
	WEnd
	
	If IsBool($vCaptureNew) And $vCaptureNew Then _CaptureRegion2()

	If IsPtr($vCaptureNew) Then
		_GDIPlus_ImageSaveToFile($vCaptureNew, $sFullFileName)
		SetDebugLog("DebugImageSave(" & $vCaptureNew & ") " & $sFullFileName, $COLOR_DEBUG)
	Else
		; Store a copy of the image handle
		;Local $editedImage = $g_hBitmap
		Local $editedImage = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
		; Needed for editing the picture
		Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($editedImage)
		Local $hPen = _GDIPlus_PenCreate(0xFFFF0000, 2) ; Create a pencil Color FF0000/RED
		Local $hPen2 = _GDIPlus_PenCreate(0xFF000000, 2) ; Create a pencil Color FFFFFF/BLACK


		; crop image and put in $hClone
		;Local $oBitmap = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
		;Local $hClone = _GDIPlus_BitmapCloneArea($oBitmap, $x1, $y1, $x2 - $x1, $y2 - $y1, $GDIP_PXF24RGB)	

		_GDIPlus_GraphicsDrawArc($hGraphic, $x, $y, 10, 10, 0, 360, $hPen)
	
		_GDIPlus_ImageSaveToFile($editedImage, $sFullFileName)
		
		;_GDIPlus_BitmapDispose($hClone)
		;_GDIPlus_BitmapDispose($oBitmap)

		_GDIPlus_PenDispose($hPen)
		_GDIPlus_PenDispose($hPen2)
		_GDIPlus_GraphicsDispose($hGraphic)		
		_GDIPlus_BitmapDispose($editedImage)
		
		If $g_bDebugSetlog Then SetDebugLog("DebugImageSave " & $sFullFileName, $COLOR_DEBUG)
	EndIf

	If _Sleep($DELAYDEBUGIMAGESAVE1) Then Return
EndFunc   ;==>SaveDebugPointImage

Func SaveDebugDiamondImage($sImageName = "Unknown", $sArea = "" , $vCaptureNew = Default, $bCreateSubFolder = Default, $sTag = "")

	If $vCaptureNew = Default Then $vCaptureNew = True
	If $bCreateSubFolder = Default Then $bCreateSubFolder = True

	Local $aiPoints = StringSplit($sArea, "|")
	Local $aiCoords[4][2]

	For $i = 1 to $aiPoints[0]
		;SetLog($aiPoints[$i])
		Local $aCoords = StringSplit($aiPoints[$i], ",")
		$aiCoords[$i - 1][0] = Number($aCoords[1])
		$aiCoords[$i - 1][1] = Number($aCoords[2])
		;SetLog("Coord X : " & $aiCoords[$i - 1][0])
		;SetLog("Coord Y : " & $aiCoords[$i - 1][1])
	Next

	Local $sDate = @MDAY & "." & @MON & "." & @YEAR
	Local $sTime = @HOUR & "." & @MIN & "." & @SEC

	Local $sFolderPath = $g_sProfileTempDebugPath

	If $bCreateSubFolder Then
		$sFolderPath = $g_sProfileTempDebugPath & $sImageName & "\"
		DirCreate($sFolderPath)
	EndIf

	Local $bAlreadyExists = True, $bFirst = True
	local $iCount = 1
	Local $sFullFileName = ""

	While $bAlreadyExists
		If $bFirst Then
			$bFirst = False
			$sFullFileName = $sFolderPath & $sImageName & $sTag & $sDate & " at " & $sTime & ".png"
			If FileExists($sFullFileName) Then
				$bAlreadyExists = True
			Else
				$bAlreadyExists = False
			EndIf
		Else
			$sFullFileName = $sFolderPath & $sImageName & $sTag & $sDate & " at " & $sTime & " (" & $iCount & ").png"
			If FileExists($sFullFileName) Then
				$iCount +=1
			Else
				$bAlreadyExists = False
			EndIf
		EndIf
	WEnd
	
	If IsBool($vCaptureNew) And $vCaptureNew Then _CaptureRegion2()

	If IsPtr($vCaptureNew) Then
		_GDIPlus_ImageSaveToFile($vCaptureNew, $sFullFileName)
		SetDebugLog("DebugImageSave(" & $vCaptureNew & ") " & $sFullFileName, $COLOR_DEBUG)
	Else
		; Store a copy of the image handle
		;Local $editedImage = $g_hBitmap
		Local $editedImage = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
		; Needed for editing the picture
		Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($editedImage)
		Local $hPen = _GDIPlus_PenCreate(0xFFFF0000, 2) ; Create a pencil Color FF0000/RED
		Local $hPen2 = _GDIPlus_PenCreate(0xFF000000, 2) ; Create a pencil Color FFFFFF/BLACK


		; crop image and put in $hClone
		;Local $oBitmap = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
		;Local $hClone = _GDIPlus_BitmapCloneArea($oBitmap, $x1, $y1, $x2 - $x1, $y2 - $y1, $GDIP_PXF24RGB)	

		;_GDIPlus_GraphicsDrawRect($hGraphic, $x1, $y1, $x2 - $x1, $y2 - $y1, $hPen)
	
		_GDIPlus_GraphicsDrawLine($hGraphic, $aiCoords[0][0], $aiCoords[0][1], $aiCoords[1][0], $aiCoords[1][1], $hPen) ;T -> R
		_GDIPlus_GraphicsDrawLine($hGraphic, $aiCoords[0][0], $aiCoords[0][1], $aiCoords[3][0], $aiCoords[3][1], $hPen) ;T -> L
		_GDIPlus_GraphicsDrawLine($hGraphic, $aiCoords[2][0], $aiCoords[2][1], $aiCoords[1][0], $aiCoords[1][1], $hPen) ;B -> R
		_GDIPlus_GraphicsDrawLine($hGraphic, $aiCoords[2][0], $aiCoords[2][1], $aiCoords[3][0], $aiCoords[3][1], $hPen) ;B -> L

	
		_GDIPlus_ImageSaveToFile($editedImage, $sFullFileName)
		
		;_GDIPlus_BitmapDispose($hClone)
		;_GDIPlus_BitmapDispose($oBitmap)

		_GDIPlus_PenDispose($hPen)
		_GDIPlus_PenDispose($hPen2)
		_GDIPlus_GraphicsDispose($hGraphic)		
		_GDIPlus_BitmapDispose($editedImage)
		
		If $g_bDebugSetlog Then SetDebugLog("DebugImageSave " & $sFullFileName, $COLOR_DEBUG)
	EndIf

	If _Sleep($DELAYDEBUGIMAGESAVE1) Then Return
EndFunc   ;==>SaveDebugRectImage
