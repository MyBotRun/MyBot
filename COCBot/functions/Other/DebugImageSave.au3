
; #FUNCTION# ====================================================================================================================
; Name ..........: DebugImageSave
; Description ...: Saves a copy of the current BS image to the Temp Folder for later review
; Syntax ........: DebugImageSave([$TxtName = "Unknown"])
; Parameters ....: $TxtName             - [optional] text string to use as part of saved filename. Default is "Unknown".
; Return values .: None
; Author ........: KnowJack (Aug 2015)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func DebugImageSave($TxtName = "Unknown", $iLeft = 0, $iTop = 0, $iRight = $DEFAULT_WIDTH, $iBottom = $DEFAULT_HEIGHT)

	; Debug Code to save images before zapping for later review, time stamped to align with logfile!
	$Date = @MDAY & "." & @MON & "." & @YEAR
	$Time = @HOUR & "." & @MIN & "." & @SEC
	$fn = $dirtemp & $TxtName & $Date & " at " & $Time & ".png" ;jp
	SetLog("Taking snapshot for later review (" & $fn & ")", $COLOR_GREEN) ;Debug purposes only :)
	_CaptureRegion($iLeft, $iTop, $iRight, $iBottom) ;jp optionally specify size
	_GDIPlus_ImageSaveToFile($hBitmap, $fn) ;jp
	If _Sleep($iDelayDebugImageSave1) Then Return

EndFunc   ;==>DebugImageSave


Func DebugImageSaveWithZoom($TxtName = "Unknown", $iLeft = 0, $iTop = 0, $iRight = $DEFAULT_WIDTH, $iBottom = $DEFAULT_HEIGHT)
	; jp zoom in a little to get a better snapshot
	$Result0 = ControlFocus($Title, "","")
	$Result1 = ControlSend($Title, "", "", "{UP}")
	If _Sleep($iDelayZoomOut2) Then Return

	DebugImageSave($TxtName&"Zoom_", $iLeft, $iTop, $iRight, $iBottom)

	For $i = 1 To 3
		$Result0 = ControlFocus($Title, "","")
		$Result1 = ControlSend($Title, "", "", "{DOWN}")
		If _Sleep($iDelayZoomOut2) Then Return
	Next
	DebugImageSave($TxtName, $iLeft, $iTop, $iRight, $iBottom)
EndFunc   ;==>DebugImageSave
