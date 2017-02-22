; #FUNCTION# ====================================================================================================================
; Name ..........: SnipeWhileTrain
; Description ...: During the idle loop, if $chkSnipeWhileTrain is checked, the bot will go to pure TH snipe
;                  and return after limit searches to profit from idle time.
; Syntax ........:
; Parameters ....: None
; Return values .: False if not enough troops ($iminArmyCapacityTHSnipe%) True if Limit searches was successfully done.
; Author ........: ChiefM3
; Modified ......: The Master, Sardo (2015-10), CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func SnipeWhileTrain()
   Local $tempSnipeWhileTrain[8] = [0, 0, 0, 0, 0, 0, 0, 0]
   Local $isSnipeWhileTrain = False
   Local $SnipeChangedSettings = False

	If $g_iDebugSetlog = 1 Then Setlog("SnipeWhileTrain function ", $COLOR_DEBUG)
	If $iChkSnipeWhileTrain = 1 And $g_iCommandStop <> 0 And $g_iCommandStop <> 3 Then

		; Attempt only when $iminArmyCapacityTHSnipe % army full to prevent failure of TH snipe
		If ($CurCamp <= ($TotalCamp * $itxtminArmyCapacityTHSnipe / 100)) Then
			SetLog("army Capacity below " & $itxtminArmyCapacityTHSnipe & "%, not enough for Snipe While Train")
			Return False
		EndIf

		If $fullArmy = False And ($CurCamp / $TotalCamp >= ($itxtminArmyCapacityTHSnipe / 100)) = True Then

			; Swap variables to pure TH snipe mode
			$tempSnipeWhileTrain[0] = $g_abFilterMeetTrophyEnable[$DB]
			$tempSnipeWhileTrain[1] = $g_abFilterMeetTrophyEnable[$LB]
			$tempSnipeWhileTrain[2] = $g_aiFilterMeetTrophyMin[$DB]
			$tempSnipeWhileTrain[3] = $g_aiFilterMeetTrophyMin[$LB]
			$tempSnipeWhileTrain[4] = $g_abFilterMeetOneConditionEnable[$LB]
			$tempSnipeWhileTrain[5] = $g_abFilterMeetOneConditionEnable[$DB]
			$tempSnipeWhileTrain[7] = $g_iAtkTSAddTilesFullTroops


			;change values to snipe while train
			$g_abFilterMeetTrophyEnable[$DB] = True
			$g_abFilterMeetTrophyEnable[$LB] = True
			$g_aiFilterMeetTrophyMin[$DB] = 99
			$g_aiFilterMeetTrophyMin[$LB] = 99
			$g_abFilterMeetOneConditionEnable[$LB] = False
			$g_abFilterMeetOneConditionEnable[$DB] = False
			$g_iAtkTSAddTilesFullTroops = $g_iAtkTSAddTilesWhileTrain


			;used to Change back values
			$SnipeChangedSettings = True

			; go to search for Search Limit times
			SetLog("***[Trying TH snipe while training army]***", 0x808000)
			$isSnipeWhileTrain = True
			$Is_ClientSyncError = False
			AttackMain()
			$g_bRestart = False ; Sets $g_bRestart as True to end search after Limit Search is over so this return it to false so that the bot dont restart
			$Is_ClientSyncError = False
			$isSnipeWhileTrain = False
			SetLog("***[End trying TH snipe while training army]***", 0x808000)

			 ; Change settings back to Original
			 If $SnipeChangedSettings = True Then
				 $g_abFilterMeetTrophyEnable[$DB] = $tempSnipeWhileTrain[0]
				 $g_abFilterMeetTrophyEnable[$LB] = $tempSnipeWhileTrain[1]
				 $g_aiFilterMeetTrophyMin[$DB] = $tempSnipeWhileTrain[2]
				 $g_aiFilterMeetTrophyMin[$LB] = $tempSnipeWhileTrain[3]
				 $g_abFilterMeetOneConditionEnable[$LB] = $tempSnipeWhileTrain[4]
				 $g_abFilterMeetOneConditionEnable[$DB] = $tempSnipeWhileTrain[5]
				 ;$OptTrophyMode = $tempSnipeWhileTrain[6]
				 $g_iAtkTSAddTilesFullTroops = $tempSnipeWhileTrain[7]
				 ;		$g_aiFilterMinGold[$DB] = $tempSnipeWhileTrain[8]
				 ;		$g_aiFilterMinGold[$LB] = $tempSnipeWhileTrain[9]
				 ;		$g_aiFilterMeetGE[$DB] = $tempSnipeWhileTrain[10]
				 ;		$g_aiFilterMeetGE[$LB] = $tempSnipeWhileTrain[11]
				 $Is_ClientSyncError = False
			 EndIf
			 $SnipeChangedSettings = False
			 $isSnipeWhileTrain = False

			Return True
		EndIf
	EndIf
EndFunc   ;==>SnipeWhileTrain

