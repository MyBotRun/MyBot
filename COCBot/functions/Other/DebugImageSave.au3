
; #FUNCTION# ====================================================================================================================
; Name ..........: DebugImageSave
; Description ...: Saves a copy of the current BS image to the Temp Folder for later review
; Syntax ........: DebugImageSave([$TxtName = "Unknown"])
; Parameters ....: $TxtName             - [optional] text string to use as part of saved filename. Default is "Unknown".
; Return values .: None
; Author ........: KnowJack (Aug 2015)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func DebugImageSave($TxtName = "Unknown",$capturenew=True)

	; Debug Code to save images before zapping for later review, time stamped to align with logfile!
	;SetLog("Taking snapshot for later review", $COLOR_GREEN) ;Debug purposes only :)
	$Date = @MDAY & "." & @MON & "." & @YEAR
	$Time = @HOUR & "." & @MIN & "." & @SEC
	If $capturenew Then _CaptureRegion()
	_GDIPlus_ImageSaveToFile($hBitmap, $dirTempDebug & $TxtName & $Date & " at " & $Time & ".png")
	If $debugsetlog=1 Then Setlog( $TxtName & $Date & " at " & $Time & ".png", $COLOR_purple)
	If _Sleep($iDelayDebugImageSave1) Then Return

EndFunc   ;==>DebugImageSave