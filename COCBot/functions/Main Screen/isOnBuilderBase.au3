; #FUNCTION# ====================================================================================================================
; Name ..........: isOnBuilderBase.au3
; Description ...: Check if Bot is currently on Normal Village or on Builder Base
; Syntax ........: isOnBuilderBase($bNeedCaptureRegion = False)
; Parameters ....: $bNeedCaptureRegion
; Return values .: True if is on Builder Base
; Author ........: Fliegerfaust (05-2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: Click
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func isOnBuilderBase($bNeedCaptureRegion = False)
	If _Sleep($DELAYISBUILDERBASE) Then Return
	Local $asSearchResult = findMultiple($g_sImgIsOnBB, GetDiamondFromRect("260,0,406,54"), GetDiamondFromRect("260,0,406,54"), 0, 1000, 1, "objectname", $bNeedCaptureRegion)

	If IsArray($asSearchResult) And UBound($asSearchResult) > 0 Then
		SetDebugLog("Builder Base Builder detected", $COLOR_DEBUG)
		Return True
	Else
		Return False
	EndIf
EndFunc
