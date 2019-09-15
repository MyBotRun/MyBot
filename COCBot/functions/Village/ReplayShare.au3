; #FUNCTION# ====================================================================================================================
; Name ..........: ReplayShare
; Description ...: This function will publish replay if mimimun loot reach
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Sardo (2015-06)
; Modified ......: Sardo (2015-08), MonkeyHunter(2016-01), CodeSlinger69 (2017-01), Fliegerfaust(2017-08)
; Modified ......: Sardo (2015-08), MonkeyHunter(2016-01), CodeSlinger69 (2018-01), Fliegerfaust(2018-08)
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func ReplayShare($bShareLastReplay)
	If Not $g_bShareAttackEnable Or Not $bShareLastReplay Then Return

	Local Static $sLastTimeShared = ""

	If $sLastTimeShared = "" Or _DateDiff("n", $sLastTimeShared, _NowCalc()) > 30  Then ; Go into here when Function got called the first time or Cooldown between shares is already over
		SetLog("Going to share the last Attack!")

		ClickP($aAway, 1, 0, "#0235") ;Click away any open Windows
		If _Sleep($DELAYREPLAYSHARE2) Then Return

		ClickP($aMessageButton, 1, 0, "#0236") ;Click the Attack Log Button on the left upper corner
		If Not _WaitForCheckPixel($aAttackLogPage, $g_bCapturePixel) Then ; Check if the Defense/Attack/Inbox Page loaded up, if not throw an error
			SetLog("Error while checking if the Attack Log Page opened up", $COLOR_ERROR)
			ClickP($aAway, 1, 0, "#0235")
			Return
		EndIf

		Click(380, 90 + $g_iMidOffsetY, 1, 0, "#0237") ; Switch from Defense Log Tab to Attack Log Tab
		If Not _WaitForCheckPixel($aAttackLogAttackTab, $g_bCapturePixel) Then ; Check the White on the Tab Name to make certain that we switched Tabs successfully
			SetLog("Error while trying to open Attacks Page", $COLOR_ERROR)
			ClickP($aAway, 1, 0, "#0235")
			Return
		EndIf

		Local $asReplayText = StringSplit($g_sShareMessage, "|") ; Split the String into an Array holding each seperat
		Local $sRndMessage ; Final Pick for the Random Message

		If @error Then
			$sRndMessage = $asReplayText[1] ; Select first Message of Array if an erro occured while splitting
		Else
			$sRndMessage = $asReplayText[Random(1, $asReplayText[0], 1)] ; Get Random String from Array
		EndIf

		If _CheckPixel($aBlueShareReplayButton, True) Then ; Is the Share Button for the Replay available?
			ClickP($aBlueShareReplayButton, 1, 0, "#0238") ; Click Share Button
			If _Sleep($DELAYREPLAYSHARE1) Then Return
			Click(300, 120, 1, 0, "#0239") ;Select Text Area to put in the Random Message from GUI
			If _Sleep($DELAYREPLAYSHARE1) Then Return

			If Not $g_bChkBackgroundMode And Not $g_bNoFocusTampering Then ControlFocus($g_hAndroidWindow, "", "") ; Fixes typos which could occur
			AndroidSendText($sRndMessage, True)
			If _Sleep($DELAYREPLAYSHARE1) Then Return
			If SendText($sRndMessage) = 0 Then ; Type in Text to share
				SetLog("Failed to insert Share Replay Text!", $COLOR_ERROR)
				Return
			EndIf

			If _Sleep($DELAYREPLAYSHARE1) Then Return
			Click(530, 210 + $g_iMidOffsetY, 1, 0, "#0240") ;Click the Send Button
			$sLastTimeShared = _NowCalc ; Update the Date where the last Replay got shared
		ElseIf _CheckPixel($aGrayShareReplayButton, True) Then ; Is the Share Button for the Replay not available?
			SetLog("Sharing latest Attack is not enabled right now, storing it and share later!") ; Cooldown is not over yet! Probably User shared a Replay and started Bot afterwards
			ClickP($aAway, 1, 0, "#0235")
		Else ; Neither of Blue or Gray Button State got found? Maybe Replay got deleted or Button was not found
			SetLog("Error checking Share Button State. Replay might be not available anymore or Bot made mistakes", $COLOR_ERROR)
			ClickP($aAway, 1, 0, "#0235")
		EndIf
	Else
		SetLog("Skip Replay Sharing because the 30 minutes cooldown is not over yet!")
	EndIf
	ClickP($aAway, 1, 0, "#0235") ;Click away any open Windows
EndFunc   ;==>ReplayShare