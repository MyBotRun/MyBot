; #FUNCTION# ====================================================================================================================
; Name ..........:MilkingDetectRedArea.au3
; Description ...:Detect the red area of map, used for milking
; Syntax ........:MilkingDetectRedArea()
; Parameters ....:None
; Return values .:None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: Noo
; ===============================================================================================================================

Func MilkingDetectRedArea()
	$g_sMilkFarmObjectivesSTR = ""
	;01 - REDAREA -----------------------------------------------------------------------------------------------------------------------------------------
	Local $hTimer = __TimerInit()
	_CaptureRegion2()
	_GetRedArea()
	Local $htimerREDAREA = Round(__TimerDiff($hTimer) / 1000, 2)
	If $g_bDebugSetlog Then SetDebugLog("> RedArea completed in " & $htimerREDAREA & " seconds", $COLOR_INFO)

	;02 - DEPURE REDAREA BAD POINTS -----------------------------------------------------------------------------------------------------------------------
	CleanRedArea($g_aiPixelTopLeft)
	CleanRedArea($g_aiPixelTopRight)
	CleanRedArea($g_aiPixelBottomLeft)
	CleanRedArea($g_aiPixelBottomRight)
EndFunc   ;==>MilkingDetectRedArea
