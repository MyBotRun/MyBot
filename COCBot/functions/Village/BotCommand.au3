
; #FUNCTION# ====================================================================================================================
; Name ..........: BotCommand
; Description ...: There are Commands to Shutdown, Sleep, Halt Attack and Halt Training mode
; Syntax ........: BotCommand()
; Parameters ....:
; Return values .: None
; Author ........: Code Monkey #17
; Modified ......: MonkeyHunter (2106-2), CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func BotCommand()
    Static $TimeToStop = -1

	If $g_bChkBotStop = True Then

		$g_bMeetCondStop = False ; reset flags so bot can restart farming when conditions change.
		$bTrainEnabled = True
		$bDonationEnabled = True

		If $g_iCmbBotCond = 15 And $g_iCmbHoursStop <> 0 Then $TimeToStop = $g_iCmbHoursStop * 3600000 ; 3600000 = 1 Hours

		Local $iTrophyCurrent = getTrophyMainScreen($aTrophies[0], $aTrophies[1])
		Local $TrophyMax = Number($iTrophyCurrent) > Number($itxtMaxTrophy)
		Local $Trophy = ($TrophyMax ? "Max. Trophy Reached!" : "")

		Switch $g_iCmbBotCond
			Case 0
				If isGoldFull() And isElixirFull() And $TrophyMax Then $g_bMeetCondStop = True
			Case 1
				If (isGoldFull() And isElixirFull()) Or $TrophyMax Then $g_bMeetCondStop = True
			Case 2
				If (isGoldFull() Or isElixirFull()) And $TrophyMax Then $g_bMeetCondStop = True
			Case 3
				If isGoldFull() Or isElixirFull() Or $TrophyMax Then $g_bMeetCondStop = True
			Case 4
				If isGoldFull() And isElixirFull() Then $g_bMeetCondStop = True
			Case 5
				If isGoldFull() Or isElixirFull() Then $g_bMeetCondStop = True
			Case 6
				If isGoldFull() And $TrophyMax Then $g_bMeetCondStop = True
			Case 7
				If isElixirFull() And $TrophyMax Then $g_bMeetCondStop = True
			Case 8
				If isGoldFull() Or $TrophyMax Then $g_bMeetCondStop = True
			Case 9
				If isElixirFull() Or $TrophyMax Then $g_bMeetCondStop = True
			Case 10
				If isGoldFull() Then $g_bMeetCondStop = True
			Case 11
				If isElixirFull() Then $g_bMeetCondStop = True
			Case 12
				If $TrophyMax Then $g_bMeetCondStop = True
			Case 13
				If isDarkElixirFull() Then $g_bMeetCondStop = True
			Case 14
				If isGoldFull() And isElixirFull() And isDarkElixirFull() Then $g_bMeetCondStop = True
			Case 15 ; Bot running for...
				If Round(TimerDiff($g_hTimerSinceStarted)) > $TimeToStop Then $g_bMeetCondStop = True
			Case 16 ; Train/Donate Only
				$g_bMeetCondStop = True
			Case 17 ; Donate Only
				$g_bMeetCondStop = True
				$bTrainEnabled = False
			Case 18 ; Only stay online
				$g_bMeetCondStop = True
				$bTrainEnabled = False
				$bDonationEnabled = False
			Case 19 ; Have shield - Online/Train/Collect/Donate
				If $g_bWaitShield = True Then $g_bMeetCondStop = True
			Case 20 ; Have shield - Online/Collect/Donate
				If $g_bWaitShield = True Then
					$g_bMeetCondStop = True
					$bTrainEnabled = False
				EndIf
			Case 21 ; Have shield - Online/Collect
				If $g_bWaitShield = True Then
					$g_bMeetCondStop = True
					$bTrainEnabled = False
					$bDonationEnabled = False
				EndIf
		EndSwitch

		If $g_bMeetCondStop Then
			If $g_iCmbBotCond <> 4 And $g_iCmbBotCond <> 5 And $g_iCmbBotCond <> 10 And $g_iCmbBotCond <> 11 Then
				If $Trophy <> "" Then SetLog($Trophy, $COLOR_SUCCESS)
				If _Sleep($iDelayBotCommand1) Then Return
			EndIf
			Switch $g_iCmbBotCommand
				Case 0
					If $bDonationEnabled = False Then
						SetLog("Halt Attack, Stay Online/Collect...", $COLOR_INFO)
					ElseIf $bTrainEnabled = False Then
						SetLog("Halt Attack, Stay Online/Collect/Donate...", $COLOR_INFO)
					Else
						SetLog("Halt Attack, Stay Online/Train/Collect/Donate...", $COLOR_INFO)
					EndIf
					$g_iCommandStop = 0 ; Halt Attack
					If _Sleep($iDelayBotCommand1) Then Return
				Case 1
					SetLog("MyBot.run Bot Stop as requested!!", $COLOR_INFO)
					If _Sleep($iDelayBotCommand1) Then Return
					Return True
				Case 2
					SetLog("MyBot.run Close Bot as requested!!", $COLOR_INFO)
					If _Sleep($iDelayBotCommand1) Then Return
					BotClose()
					Return True ; HaHa - No Return possible!
				Case 3
					SetLog("Close Android and Bot as requested!!", $COLOR_INFO)
					If _Sleep($iDelayBotCommand1) Then Return
					CloseAndroid("BotCommand")
					BotClose()
					Return True ; HaHa - No Return possible!
				Case 4
					SetLog("Force Shutdown of PC...", $COLOR_INFO)
					If _Sleep($iDelayBotCommand1) Then Return
					Shutdown(BitOR($SD_SHUTDOWN, $SD_FORCE)) ; Force Shutdown
					Return True ; HaHa - No Return possible!
				Case 5
					SetLog("PC Sleep Mode Start now ...", $COLOR_INFO)
					If _Sleep($iDelayBotCommand1) Then Return
					Shutdown($SD_STANDBY) ; Sleep / Stand by
					Return True ; HaHa - No Return possible!
				Case 6
					SetLog("Rebooting PC...", $COLOR_INFO)
					If _Sleep($iDelayBotCommand1) Then Return
					Shutdown(BitOR($SD_REBOOT, $SD_FORCE)) ; Reboot
					Return True ; HaHa - No Return possible!
			EndSwitch
		EndIf
	EndIf
	Return False
EndFunc   ;==>BotCommand
