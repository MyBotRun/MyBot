; #FUNCTION# ====================================================================================================================
; Name ..........: isNoUpgradeLoot.au3
; Description ...: Test upgrade windows for the presence of Red in the last Zero of upgrade value
; Syntax ........: isNoUpgradeLoot($bNeedCaptureRegion), FALSE is default.
; Parameters ....: $bNeedCaptureRegion = True will make a new 2x2 screencapture to identify the pixels to test, False will assume there is a full screen capture to use.
; Return values .: True if Not enough loot, and clicks away to close the window
; Author ........: KnowJack (May-2015)
; Modified ......: Sardo 2015-08
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: Click
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func isNoUpgradeLoot($bNeedCaptureRegion = False)
	If _ColorCheck(_GetPixelColor(459, 490 + $midOffsetY, $bNeedCaptureRegion), Hex(0xE70A12, 6), 20) And _ ; Check regular upgrades window
			_ColorCheck(_GetPixelColor(459, 494 + $midOffsetY, $bNeedCaptureRegion), Hex(0xE70A12, 6), 20) And _
			_ColorCheck(_GetPixelColor(459, 498 + $midOffsetY, $bNeedCaptureRegion), Hex(0xE70A12, 6), 20) Then ; Check for Red Zero on norma Upgrades = means not enough loot!
		If $debugSetlog = 1 Then Setlog("isNoUpgradeLoot Red Zero found", $COLOR_PURPLE)
		PureClickP($aAway, 1, 0, "#0142") ; click away to close upgrade window
		Return True
	ElseIf _ColorCheck(_GetPixelColor(691, 523 + $midOffsetY, $bNeedCaptureRegion), Hex(0xE70A12, 6), 20) And _  ; Check Hero upgrades window
			_ColorCheck(_GetPixelColor(691, 527 + $midOffsetY, $bNeedCaptureRegion), Hex(0xE70A12, 6), 20) And _
			_ColorCheck(_GetPixelColor(691, 531 + $midOffsetY, $bNeedCaptureRegion), Hex(0xE70A12, 6), 20) Then ; Check for Red Zero = means not enough loot!
		If $debugSetlog = 1 Then Setlog("IsNoUpgradeLoot Hero Red Zero Found", $COLOR_PURPLE)
		PureClickP($aAway, 1, 0, "#0143") ; click away to close gem window
		Return True
	EndIf
	Return False
EndFunc   ;==>isNoUpgradeLoot
