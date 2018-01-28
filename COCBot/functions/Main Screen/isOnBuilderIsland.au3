; #FUNCTION# ====================================================================================================================
; Name ..........: isOnBuilderIsland.au3
; Description ...: Check if Bot is currently on Normal Village or on Builder Island
; Syntax ........: isOnBuilderIsland($bNeedCaptureRegion = False)
; Parameters ....: $bNeedCaptureRegion
; Return values .: True if is on Builder Island
; Author ........: Fliegerfaust (05-2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: Click
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func isOnBuilderIsland($bNeedCaptureRegion = False)
	_Sleep($DELAYISBUILDERISLAND)

	If _CheckPixel($aIsOnBuilderIsland, $bNeedCaptureRegion) Then
		If $g_bDebugSetlog Then SetDebugLog("Builder Island Builder detected", $COLOR_DEBUG)
		Return True
	Else
		Return False
	EndIf
EndFunc