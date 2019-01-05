
; #FUNCTION# ====================================================================================================================
; Name ..........: DebugImageSave
; Description ...: Saves a copy of the current BS image to the Temp Folder for later review
; Syntax ........: DebugImageSave([$TxtName = "Unknown"])
; Parameters ....: $TxtName             - [optional] text string to use as part of saved filename. Default is "Unknown".
; Return values .: None
; Author ........: KnowJack (Aug 2015)
; Modified ......: Sardo (2016-01)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func DebugImageSave($TxtName = "Unknown", $capturenew = Default, $extensionpng = Default, $makesubfolder = Default, $sTag = "")
	If $capturenew = Default Then $capturenew = True
	If $extensionpng = Default Then $extensionpng = "png"
	If $makesubfolder = Default Then $makesubfolder = True
	; Debug Code to save images before zapping for later review, time stamped to align with logfile!
	;SetLog("Taking snapshot for later review", $COLOR_SUCCESS) ;Debug purposes only :)
	Local $Date = @MDAY & "." & @MON & "." & @YEAR
	Local $Time = @HOUR & "." & @MIN & "." & @SEC
	Local $savefolder = $g_sProfileTempDebugPath
	If $makesubfolder = True Then
		$savefolder = $g_sProfileTempDebugPath & $TxtName & "\"
		DirCreate($savefolder)
	EndIf

	Local $extension
	If $extensionpng = "png" then
		$extension = "png"
	Else
		$extension = "jpg"
	EndIf

	Local $exist = true
	local $i = 1
	Local $first = True
	Local $filename = ""
	While $exist
		If $first Then
			$first = False
			$filename = $savefolder & $TxtName & $sTag & $Date & " at " & $Time & "." & $extension
			If FileExists($filename) = 1 Then
				$exist = True
			Else
				$exist = False

			EndIf
		Else
			$filename = $savefolder & $TxtName & $sTag & $Date & " at " & $Time & " (" & $i & ")." & $extension
			If FileExists($filename) = 1 Then
				$i +=1
			Else
				$exist = False
			EndIf
		EndIf
	WEnd

	If IsBool($capturenew) And $capturenew Then
		_CaptureRegion2()
	EndIf
	If IsPtr($capturenew) Then
		_GDIPlus_ImageSaveToFile($capturenew, $filename)
		If $g_bDebugSetlog Then SetDebugLog("DebugImageSave(" & $capturenew & ") " & $filename, $COLOR_DEBUG)
	Else
		Local $EditedImage = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
		_GDIPlus_ImageSaveToFile($EditedImage, $filename)
		_GDIPlus_BitmapDispose($EditedImage)
		If $g_bDebugSetlog Then SetDebugLog("DebugImageSave " & $filename, $COLOR_DEBUG)
	EndIf

	If _Sleep($DELAYDEBUGIMAGESAVE1) Then Return

EndFunc   ;==>DebugImageSave
