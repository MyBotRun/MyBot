; #FUNCTION# ====================================================================================================================
; Name ..........: SaveDebugImage
; Description ...: Saves a copy of the current BS image to the Temp Folder for later review
; Syntax ........: SaveDebugImage()
; Parameters ....: $sImageName             - [optional] text string to use as part of saved filename. Default is "Unknown".
; Return values .: None
; Author ........: KnowJack (08/2015)
; Modified ......: Sardo (01/2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
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