; #FUNCTION# ====================================================================================================================
; Name ..........:MilkingDetectRedArea.au3
; Description ...:Detect the red area of map, used for milking
; Syntax ........:MilkingDetectRedArea()
; Parameters ....:None
; Return values .:None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: Noo
; ===============================================================================================================================

Func MilkingDetectRedArea()
	$MilkFarmObjectivesSTR = ""
	;01 - REDAREA -----------------------------------------------------------------------------------------------------------------------------------------
	Local $hTimer = TimerInit()
	_CaptureRegion2()
	_GetRedArea()
	Local $htimerREDAREA = Round(TimerDiff($hTimer) / 1000, 2)
	If $debugsetlog = 1 Then SetLog("> RedArea completed in " & $htimerREDAREA & " seconds", $color_blue)

	;02 - DEPURE REDAREA BAD POINTS -----------------------------------------------------------------------------------------------------------------------
	CleanRedArea($PixelTopLeft)
	CleanRedArea($PixelTopRight)
	CleanRedArea($PixelBottomLeft)
	CleanRedArea($PixelBottomRight)
EndFunc   ;==>MilkingDetectRedArea
