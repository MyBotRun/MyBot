
; #FUNCTION# ====================================================================================================================
; Name ..........: BotCommand
; Description ...: There are Commands to Shutdown, Sleep, Halt Attack and Halt Training mode
; Syntax ........: BotCommand()
; Parameters ....:
; Return values .: None
; Author ........: Code Monkey #17
; Modified ......: MonkeyHunter (2106-2)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func BotCommand()
	If $iChkBotStop = 1 Then

		$MeetCondStop = False ; reset flags so bot can restart farming when conditions change.
		$bTrainEnabled = True
		$bDonationEnabled = True

		If $icmbBotCond = 15 And $icmbHoursStop <> 0 Then $TimeToStop = $icmbHoursStop * 3600000 ; 3600000 = 1 Hours

		Local $iTrophyCurrent = getTrophyMainScreen($aTrophies[0], $aTrophies[1])
		Local $TrophyMax = Number($iTrophyCurrent) > Number($itxtMaxTrophy)
		If $TrophyMax Then
			$Trophy = "Max. Trophy Reached!"
		Else
			$Trophy = ""
		EndIf

		Switch $icmbBotCond
			Case 0
				If isGoldFull() And isElixirFull() And $TrophyMax Then $MeetCondStop = True
			Case 1
				If (isGoldFull() And isElixirFull()) Or $TrophyMax Then $MeetCondStop = True
			Case 2
				If (isGoldFull() Or isElixirFull()) And $TrophyMax Then $MeetCondStop = True
			Case 3
				If isGoldFull() Or isElixirFull() Or $TrophyMax Then $MeetCondStop = True
			Case 4
				If isGoldFull() And isElixirFull() Then $MeetCondStop = True
			Case 5
				If isGoldFull() Or isElixirFull() Then $MeetCondStop = True
			Case 6
				If isGoldFull() And $TrophyMax Then $MeetCondStop = True
			Case 7
				If isElixirFull() And $TrophyMax Then $MeetCondStop = True
			Case 8
				If isGoldFull() Or $TrophyMax Then $MeetCondStop = True
			Case 9
				If isElixirFull() Or $TrophyMax Then $MeetCondStop = True
			Case 10
				If isGoldFull() Then $MeetCondStop = True
			Case 11
				If isElixirFull() Then $MeetCondStop = True
			Case 12
				If $TrophyMax Then $MeetCondStop = True
			Case 13
				If isDarkElixirFull() Then $MeetCondStop = True
			Case 14
				If isGoldFull() And isElixirFull() And isDarkElixirFull() Then $MeetCondStop = True
			Case 15
				If $UseTimeStop = -1 Then
					$UseTimeStop = 1
				EndIf
				If Round(TimerDiff($sTimer)) > $TimeToStop Then $MeetCondStop = True
			Case 16
				$MeetCondStop = True
			Case 17
				$MeetCondStop = True
				$bTrainEnabled = False
			Case 18
				$MeetCondStop = True
				$bTrainEnabled = False
				$bDonationEnabled = False
			Case 19 ; Have shield - Online/Train/Collect/Donate
				If $bWaitShield = True Then $MeetCondStop = True
			Case 20 ; Have shield - Online/Collect/Donate
				If $bWaitShield = True Then
					$MeetCondStop = True
					$bTrainEnabled = False
				EndIf
			Case 21 ; Have shield - Online/Collect
				If $bWaitShield = True Then
					$MeetCondStop = True
					$bTrainEnabled = False
					$bDonationEnabled = False
				EndIf
		EndSwitch

		If $MeetCondStop Then
			If $icmbBotCond <> 4 And $icmbBotCond <> 5 And $icmbBotCond <> 10 And $icmbBotCond <> 11 Then
				If $Trophy <> "" Then SetLog($Trophy, $COLOR_GREEN)
				If _Sleep($iDelayBotCommand1) Then Return
			EndIf
			Switch $icmbBotCommand
				Case 0
					If $bDonationEnabled = False Then
						SetLog("Halt Attack, Stay Online/Collect...", $COLOR_BLUE)
					ElseIf $bTrainEnabled = False Then
						SetLog("Halt Attack, Stay Online/Collect/Donate...", $COLOR_BLUE)
					Else
						SetLog("Halt Attack, Stay Online/Train/Collect/Donate...", $COLOR_BLUE)
					EndIf
					$CommandStop = 0 ; Halt Attack
					If _Sleep($iDelayBotCommand1) Then Return
				Case 1
					SetLog("MyBot.run Bot Stop as requested!!", $COLOR_BLUE)
					If _Sleep($iDelayBotCommand1) Then Return
					Return True
				Case 2
					SetLog("MyBot.run Close Bot as requested!!", $COLOR_BLUE)
					If _Sleep($iDelayBotCommand1) Then Return
					BotClose()
					Return True ; HaHa - No Return possible!
				Case 3
					SetLog("Close Android and Bot as requested!!", $COLOR_BLUE)
					If _Sleep($iDelayBotCommand1) Then Return
					CloseAndroid()
					BotClose()
					Return True ; HaHa - No Return possible!
				Case 4
					SetLog("Force Shutdown of PC...", $COLOR_BLUE)
					If _Sleep($iDelayBotCommand1) Then Return
					Shutdown(BitOR($SD_SHUTDOWN, $SD_FORCE)) ; Force Shutdown
					Return True ; HaHa - No Return possible!
				Case 5
					SetLog("PC Sleep Mode Start now ...", $COLOR_BLUE)
					If _Sleep($iDelayBotCommand1) Then Return
					Shutdown($SD_STANDBY) ; Sleep / Stand by
					Return True ; HaHa - No Return possible!
				Case 6
					SetLog("Rebooting PC...", $COLOR_BLUE)
					If _Sleep($iDelayBotCommand1) Then Return
					Shutdown(BitOR($SD_REBOOT, $SD_FORCE)) ; Reboot
					Return True ; HaHa - No Return possible!
			EndSwitch
		EndIf
	EndIf
	Return False
EndFunc   ;==>BotCommand
