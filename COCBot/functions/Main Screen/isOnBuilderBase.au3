; #FUNCTION# ====================================================================================================================
; Name ..........: isOnBuilderBase.au3
; Description ...: Check if Bot is currently on Normal Village or on Builder Base
; Syntax ........: isOnBuilderBase($bNeedCaptureRegion = False)
; Parameters ....: $bNeedCaptureRegion
; Return values .: True if is on Builder Base
; Author ........: Fliegerfaust (05-2017)
; Modified ......: Moebius14 (07-2023)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: Click
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func isOnBuilderBase($bNeedCaptureRegion = False)
	If _Sleep($DELAYISBUILDERBASE) Then Return

	Local $sArea = GetDiamondFromRect("445,0,500,54")
	Local $asSearchResult = findMultiple($g_sImgIsOnBB, $sArea, $sArea, 0, 1000, 1, "objectname", $bNeedCaptureRegion)

	If IsArray($asSearchResult) And UBound($asSearchResult) > 0 Then
		SetDebugLog("Builder Base detected", $COLOR_DEBUG)
		Return True
	Else
		Return False
	EndIf
EndFunc

Func isOnMainVillage($bNeedCaptureRegion = $g_bNoCapturePixel)
	If _Sleep(250) Then Return

	Local $sArea = GetDiamondFromRect("360,0,450,60")
	Local $asSearchResult = findMultiple($sImgIsOnMainVillage, $sArea, $sArea, 0, 1000, 1, "objectname", $bNeedCaptureRegion)

	If IsArray($asSearchResult) And UBound($asSearchResult) > 0 Then
		SetDebugLog("Main Village detected", $COLOR_DEBUG)
		Return True
	Else
		Return False
	EndIf
EndFunc

Func isOnBuilderBaseEnemyVillage($bNeedCaptureRegion = $g_bNoCapturePixel)
	If _Sleep(250) Then Return

	Local $sArea = GetDiamondFromRect("745,0,815,25")
	Local $asSearchResult = findMultiple($sImgIsOnBuilderBaseEnemyVillage, $sArea, $sArea, 0, 1000, 1, "objectname", $bNeedCaptureRegion)

	If IsArray($asSearchResult) And UBound($asSearchResult) > 0 Then
		SetDebugLog("Builder Enemy Village detected", $COLOR_DEBUG)
		Return True
	Else
		Return False
	EndIf
EndFunc
