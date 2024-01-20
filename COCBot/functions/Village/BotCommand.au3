
; #FUNCTION# ====================================================================================================================
; Name ..........: BotCommand
; Description ...: There are Commands to Shutdown, Sleep, Halt Attack and Halt Training mode
; Syntax ........: BotCommand()
; Parameters ....:
; Return values .: None
; Author ........: Code Monkey #17
; Modified ......: MonkeyHunter (2016-2), CodeSlinger69 (2017), MonkeyHunter (2017-3)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func BotCommand()

	Static $TimeToStop = -1

	Local $bChkBotStop, $iCmbBotCond, $iCmbBotCommand

	If $g_bOutOfElixir Or $g_bOutOfGold Then ; Check for out of loot conditions
		$bChkBotStop = True ; set halt attack mode
		$iCmbBotCond = 18 ; set stay online/collect only mode
		$iCmbBotCommand = 0 ; set stop mode to stay online
		Local $sOutOf = ($g_bOutOfGold ? "Gold" : "") & (($g_bOutOfGold And $g_bOutOfElixir) ? " and " : "") & ($g_bOutOfElixir ? "Elixir" : "")
		SetLog("Out of " & $sOutOf & " condition detected, force HALT mode!", $COLOR_WARNING)
	Else
		$bChkBotStop = $g_bChkBotStop ; Normal use GUI halt mode values
		$iCmbBotCond = $g_iCmbBotCond
		$iCmbBotCommand = $g_iCmbBotCommand
	EndIf

	$g_bMeetCondStop = False ; reset flags so bot can restart farming when conditions change.
	$g_bTrainEnabled = True
	$g_bDonationEnabled = True

	If $bChkBotStop Then

		If $iCmbBotCond = 15 And $g_iCmbHoursStop <> 0 Then $TimeToStop = $g_iCmbHoursStop * 3600000 ; 3600000 = 1 Hours

		Switch $iCmbBotCond
			Case 0
				If isGoldFull() And isElixirFull() And isTrophyMax() Then $g_bMeetCondStop = True
			Case 1
				If (isGoldFull() And isElixirFull()) Or isTrophyMax() Then $g_bMeetCondStop = True
			Case 2
				If (isGoldFull() Or isElixirFull()) And isTrophyMax() Then $g_bMeetCondStop = True
			Case 3
				If isGoldFull() Or isElixirFull() Or isTrophyMax() Then $g_bMeetCondStop = True
			Case 4
				If isGoldFull() And isElixirFull() Then $g_bMeetCondStop = True
			Case 5
				If isGoldFull() Or isElixirFull() Or isDarkElixirFull() Then $g_bMeetCondStop = True
			Case 6
				If isGoldFull() And isTrophyMax() Then $g_bMeetCondStop = True
			Case 7
				If isElixirFull() And isTrophyMax() Then $g_bMeetCondStop = True
			Case 8
				If isGoldFull() Or isTrophyMax() Then $g_bMeetCondStop = True
			Case 9
				If isElixirFull() Or isTrophyMax() Then $g_bMeetCondStop = True
			Case 10
				If isGoldFull() Then $g_bMeetCondStop = True
			Case 11
				If isElixirFull() Then $g_bMeetCondStop = True
			Case 12
				If isTrophyMax() Then $g_bMeetCondStop = True
			Case 13
				If isDarkElixirFull() Then $g_bMeetCondStop = True
			Case 14
				If isGoldFull() And isElixirFull() And isDarkElixirFull() Then $g_bMeetCondStop = True
			Case 15 ; Bot running for...
				If Round(__TimerDiff($g_hTimerSinceStarted)) > $TimeToStop Then $g_bMeetCondStop = True
			Case 16 ; Train/Donate Only
				$g_bMeetCondStop = True
			Case 17 ; Donate Only
				$g_bMeetCondStop = True
				$g_bTrainEnabled = False
			Case 18 ; Only stay online
				$g_bMeetCondStop = True
				$g_bTrainEnabled = False
				$g_bDonationEnabled = False
			Case 19 ; Have shield - Online/Train/Collect/Donate
				If $g_bWaitShield = True Then $g_bMeetCondStop = True
			Case 20 ; Have shield - Online/Collect/Donate
				If $g_bWaitShield = True Then
					$g_bMeetCondStop = True
					$g_bTrainEnabled = False
				EndIf
			Case 21 ; Have shield - Online/Collect
				If $g_bWaitShield = True Then
					$g_bMeetCondStop = True
					$g_bTrainEnabled = False
					$g_bDonationEnabled = False
				EndIf
			Case 22 ; At certain time in the day
				Local $bResume = ($iCmbBotCommand = 0)
				If StopAndResumeTimer($bResume) Then $g_bMeetCondStop = True
		EndSwitch

		If $g_bMeetCondStop Then
			Switch $iCmbBotCommand
				Case 0
					If $iCmbBotCond <= 14 And $g_bCollectStarBonus And StarBonusSearch() Then
						SetLog("Star bonus available. Continue attacking to collect them.")
						Return False
					EndIf
					If $g_bChkForceAttackOnClanGamesWhenHalt And Not $g_bClanGamesCompleted Then
						_ClanGames()
						If $IsCGEventRunning And Not $g_bIsBBevent Then
							SetLog("Clan Games Challenge Running, Don't Halt Attack.", $COLOR_SUCCESS)
							Return False
						EndIf
					EndIf
					If Not $g_bDonationEnabled Then
						SetLog("Halt Attack, Stay Online/Collect", $COLOR_INFO)
					ElseIf Not $g_bTrainEnabled Then
						SetLog("Halt Attack, Stay Online/Collect/Donate", $COLOR_INFO)
					Else
						SetLog("Halt Attack, Stay Online/Train/Collect/Donate", $COLOR_INFO)
					EndIf
					$g_iCommandStop = 0 ; Halt Attack
					If _Sleep($DELAYBOTCOMMAND1) Then Return
				Case 1
					If $g_bChkForceAttackOnClanGamesWhenHalt And Not $g_bClanGamesCompleted Then
						_ClanGames(False, True)
						If $IsCGEventRunning Then
							SetLog("Clan Games Challenge Running, Finish it First.", $COLOR_ACTION)
							Return False
						EndIf
					EndIf
					SetLog("MyBot.run Bot Stop as requested", $COLOR_INFO)
					If _Sleep($DELAYBOTCOMMAND1) Then Return
					Return True
				Case 2
					If $g_bChkForceAttackOnClanGamesWhenHalt And Not $g_bClanGamesCompleted Then
						_ClanGames(False, True)
						If $IsCGEventRunning Then
							SetLog("Clan Games Challenge Running, Finish it First.", $COLOR_ACTION)
							Return False
						EndIf
					EndIf
					SetLog("MyBot.run Close Bot as requested", $COLOR_INFO)
					If _Sleep($DELAYBOTCOMMAND1) Then Return
					BotClose()
					Return True ; HaHa - No Return possible!
				Case 3
					If $g_bChkForceAttackOnClanGamesWhenHalt And Not $g_bClanGamesCompleted Then
						_ClanGames(False, True)
						If $IsCGEventRunning Then
							SetLog("Clan Games Challenge Running, Finish it First.", $COLOR_ACTION)
							Return False
						EndIf
					EndIf
					SetLog("Close Android and Bot as requested", $COLOR_INFO)
					If _Sleep($DELAYBOTCOMMAND1) Then Return
					CloseAndroid("BotCommand")
					BotClose()
					Return True ; HaHa - No Return possible!
				Case 4
					If $g_bChkForceAttackOnClanGamesWhenHalt And Not $g_bClanGamesCompleted Then
						_ClanGames(False, True)
						If $IsCGEventRunning Then
							SetLog("Clan Games Challenge Running, Finish it First.", $COLOR_ACTION)
							Return False
						EndIf
					EndIf
					SetLog("Force Shutdown of Computer", $COLOR_INFO)
					If _Sleep($DELAYBOTCOMMAND1) Then Return
					Shutdown(BitOR($SD_SHUTDOWN, $SD_FORCE)) ; Force Shutdown
					Return True ; HaHa - No Return possible!
				Case 5
					If $g_bChkForceAttackOnClanGamesWhenHalt And Not $g_bClanGamesCompleted Then
						_ClanGames(False, True)
						If $IsCGEventRunning Then
							SetLog("Clan Games Challenge Running, Finish it First.", $COLOR_ACTION)
							Return False
						EndIf
					EndIf
					SetLog("Computer Sleep Mode Start now", $COLOR_INFO)
					If _Sleep($DELAYBOTCOMMAND1) Then Return
					Shutdown($SD_STANDBY) ; Sleep / Stand by
					Return True ; HaHa - No Return possible!
				Case 6
					If $g_bChkForceAttackOnClanGamesWhenHalt And Not $g_bClanGamesCompleted Then
						_ClanGames(False, True)
						If $IsCGEventRunning Then
							SetLog("Clan Games Challenge Running, Finish it First.", $COLOR_ACTION)
							Return False
						EndIf
					EndIf
					SetLog("Rebooting Computer", $COLOR_INFO)
					If _Sleep($DELAYBOTCOMMAND1) Then Return
					Shutdown(BitOR($SD_REBOOT, $SD_FORCE)) ; Reboot
					Return True ; HaHa - No Return possible!
				Case 7
					If $g_bChkForceAttackOnClanGamesWhenHalt And Not $g_bClanGamesCompleted Then
						_ClanGames(False, True)
						If $IsCGEventRunning Then
							SetLog("Clan Games Challenge Running, Finish it First.", $COLOR_ACTION)
							Return False
						EndIf
					EndIf
					If ProfileSwitchAccountEnabled() Then
						Local $aActiveAccount = _ArrayFindAll($g_abAccountNo, True)
						If UBound($aActiveAccount) >= 2 Then
							GUICtrlSetState($g_ahChkAccount[$g_iCurAccount], $GUI_UNCHECKED)
							$g_iCommandStop = 1 ; Turn Idle
							checkSwitchAcc()
						Else
							SetLog("This is the last account to turn off. Stop bot now. Adios!", $COLOR_INFO)
							If _Sleep($DELAYBOTCOMMAND1) Then Return
							CloseCoC()
							Return True
						EndIf
					EndIf
			EndSwitch
		EndIf
	EndIf
	Return False
EndFunc   ;==>BotCommand


; #FUNCTION# ====================================================================================================================
; Name ..........: isTrophyMax
; Description ...:
; Syntax ........: isTrophyMax()
; Parameters ....:
; Return values .: None
; Author ........: MonkeyHunter (2017-3)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func isTrophyMax()
	If Number($g_aiCurrentLoot[$eLootTrophy]) > Number($g_iDropTrophyMax) Then
		SetLog("Max. Trophy Reached!", $COLOR_SUCCESS)
		If _Sleep($DELAYBOTCOMMAND1) Then Return
		$g_abFullStorage[$eLootTrophy] = True
	ElseIf $g_abFullStorage[$eLootTrophy] Then
		If Number($g_aiCurrentLoot[$eLootTrophy]) >= Number($g_aiResumeAttackLoot[$eLootTrophy]) Then
			SetLog("Trophy is still relatively high: " & $g_aiCurrentLoot[$eLootTrophy], $COLOR_SUCCESS)
			$g_abFullStorage[$eLootTrophy] = True
		Else
			SetLog("Switching back to normal when Trophy drops below " & $g_aiResumeAttackLoot[$eLootTrophy], $COLOR_SUCCESS)
			$g_abFullStorage[$eLootTrophy] = False
		EndIf
	EndIf
	Return $g_abFullStorage[$eLootTrophy]
EndFunc   ;==>isTrophyMax

Func StopAndResumeTimer($bResume = False)

	Static $abStop[8] = [False, False, False, False, False, False, False, False]

	Local $iTimerStop, $iTimerResume = 25
	$iTimerStop = Number($g_iCmbTimeStop)
	If $bResume Then $iTimerResume = Number($g_iResumeAttackTime)
	Local $bCurrentStatus = $abStop[$g_iCurAccount]
	SetDebugLog("$iTimerStop: " & $iTimerStop & ", $iTimerResume: " & $iTimerResume & ", Max: " & _Max($iTimerStop, $iTimerResume) & ", Min: " & _Min($iTimerStop, $iTimerResume) & ", $bCurrentStatus: " & $bCurrentStatus)

	If @HOUR < _Min($iTimerStop, $iTimerResume) Then ; both timers are ahead.
		;Do nothing
	ElseIf @HOUR < _Max($iTimerStop, $iTimerResume) Then ; 1 timer has passed, 1 timer ahead
		If $iTimerStop < $iTimerResume Then ; reach Timer to Stop
			$abStop[$g_iCurAccount] = True
			If Not $bCurrentStatus Then SetLog("Timer to stop is set at: " & $iTimerStop & ":00hrs. It's time to stop!", $COLOR_SUCCESS)
		Else ; reach Timer to Resume
			$abStop[$g_iCurAccount] = False
			If $bCurrentStatus Then SetLog("Timer to resume attack is set at: " & $iTimerResume & ":00hrs. Resume attack now!", $COLOR_SUCCESS)
		EndIf
	Else ; passed both timers
		If $iTimerStop < $iTimerResume Then ; reach Timer to Stop
			$abStop[$g_iCurAccount] = False
			If $bCurrentStatus Then SetLog("Timer to resume attack is set at: " & $iTimerResume & ":00hrs. Resume attack now!", $COLOR_SUCCESS)
		Else
			$abStop[$g_iCurAccount] = True
			If Not $bCurrentStatus Then SetLog("Timer to stop is set at: " & $iTimerStop & ":00hrs. It's time to stop!", $COLOR_SUCCESS)
		EndIf
	EndIf
	SetDebugLog("@HOUR: " & @HOUR & ", $bCurrentStatus: " & $bCurrentStatus & ", $abStop[$g_iCurAccount]: " & $abStop[$g_iCurAccount])
	Return $abStop[$g_iCurAccount]
EndFunc   ;==>StopAndResumeTimer

Func StarBonusSearch()
	Local $bRet = False
	For $i = 1 To 10
		If WaitforPixel(84, 570 + $g_iBottomOffsetY, 97, 575 + $g_iBottomOffsetY, "AF5725", 20, 0.2) Then
			$bRet = True
			ExitLoop
		EndIf
		If _Sleep(400) Then Return
		If Not $g_bRunState Then Return
	Next
	Return $bRet
EndFunc   ;==>StarBonusSearch
