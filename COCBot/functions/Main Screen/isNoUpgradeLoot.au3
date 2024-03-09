; #FUNCTION# ====================================================================================================================
; Name ..........: isNoUpgradeLoot.au3
; Description ...: Test upgrade windows for the presence of Red in the last Zero of upgrade value
; Syntax ........: isNoUpgradeLoot($bNeedCaptureRegion), FALSE is default.
; Parameters ....: $bNeedCaptureRegion = True will make a new 2x2 screencapture to identify the pixels to test, False will assume there is a full screen capture to use.
; Return values .: True if Not enough loot, and clicks away to close the window
; Author ........: KnowJack (05-2015)
; Modified ......: Sardo (08-2015), Moebius14 (02-2024)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: Click
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func isNoUpgradeLoot($bNeedCaptureRegion = False)
	Local $RedSearch = _PixelSearch(610, 548 + $g_iMidOffsetY, 650, 552 + $g_iMidOffsetY, Hex(0xFF887F, 6), 20, $bNeedCaptureRegion)
	Local $OrangeSearch = _PixelSearch(610, 539 + $g_iMidOffsetY, 650, 543 + $g_iMidOffsetY, Hex(0xFF7A0D, 6), 20, $bNeedCaptureRegion)
	If IsArray($RedSearch) Or IsArray($OrangeSearch) Then
		If $g_bDebugSetlog Then SetDebugLog("isNoUpgradeLoot Red Zero found", $COLOR_DEBUG)
		PureClickP($aAway, 1, 0, "#0142") ; click away to close upgrade window
		Return True
	EndIf
	Return False
EndFunc   ;==>isNoUpgradeLoot

