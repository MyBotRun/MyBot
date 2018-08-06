; #FUNCTION# ====================================================================================================================
; Name ..........: dropCC
; Description ...: Drops Clan Castle troops, given the slot and x, y coordinates.
; Syntax ........: dropCC($x, $y, $slot)
; Parameters ....: $x                   - X location.
;                  $y                   - Y location.
;                  $slot                - CC location in troop menu
; Return values .: None
; Author ........:
; Modified ......: Sardo (12-2015) KnowJack (06-2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func dropCC($x, $y, $slot) ;Drop clan castle

	Local $test1 = False
	Local $test2 = False
	If $g_iMatchMode = $MA And $g_abAttackDropCC[$DB] Then $test1 = True
	If $g_iMatchMode <> $MA Then
		If ($g_iMatchMode <> $DB And $g_iMatchMode <> $LB And $g_iMatchMode <> $MA) Or $g_abAttackDropCC[$g_iMatchMode] Then $test2 = True
	EndIf

	If $slot <> -1 And ($test1 Or $test2) Then
		If $g_bPlannedDropCCHoursEnable = True Then
			Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
			If $g_abPlannedDropCCHours[$hour[0]] = False Then
				SetLog("Drop CC not Planned, Skipped..", $COLOR_SUCCESS)
				Return ; exit func if no planned donate checkmarks
			EndIf
		EndIf


		;standard attack
		If $g_bUseCCBalanced = True Then
			If Number($g_iTroopsReceived) <> 0 Then
				If Number(Number($g_iTroopsDonated) / Number($g_iTroopsReceived)) >= (Number($g_iCCDonated) / Number($g_iCCReceived)) Then
					SetLog("Dropping Siege/Clan Castle, donated (" & $g_iTroopsDonated & ") / received (" & $g_iTroopsReceived & ") >= " & $g_iCCDonated & "/" & $g_iCCReceived, $COLOR_INFO)
					Click(GetXPosOfArmySlot($slot, 68), 595 + $g_iBottomOffsetY, 1, $DELAYDROPCC2, "#0086")
					If _Sleep($DELAYDROPCC1) Then Return
					AttackClick($x, $y, 1, 0, 0, "#0087")
				Else
					SetLog("No Dropping Siege/Clan Castle, donated  (" & $g_iTroopsDonated & ") / received (" & $g_iTroopsReceived & ") < " & $g_iCCDonated & "/" & $g_iCCReceived, $COLOR_INFO)
				EndIf
			Else
				If Number(Number($g_iTroopsDonated) / 1) >= (Number($g_iCCDonated) / Number($g_iCCReceived)) Then
					SetLog("Dropping Siege/Clan Castle, donated (" & $g_iTroopsDonated & ") / received (" & $g_iTroopsReceived & ") >= " & $g_iCCDonated & "/" & $g_iCCReceived, $COLOR_INFO)
					Click(GetXPosOfArmySlot($slot, 68), 595 + $g_iBottomOffsetY, 1, $DELAYDROPCC2, "#0088")
					If _Sleep($DELAYDROPCC1) Then Return
					AttackClick($x, $y, 1, 0, 0, "#0089")
				Else
					SetLog("No Dropping Siege/Clan Castle, donated  (" & $g_iTroopsDonated & ") / received (" & $g_iTroopsReceived & ") < " & $g_iCCDonated & "/" & $g_iCCReceived, $COLOR_INFO)
				EndIf
			EndIf
		Else
			SetLog("Dropping Siege/Clan Castle", $COLOR_INFO)
			Click(GetXPosOfArmySlot($slot, 68), 595 + $g_iBottomOffsetY, 1, $DELAYDROPCC2, "#0090")
			If _Sleep($DELAYDROPCC1) Then Return
			AttackClick($x, $y, 1, 0, 0, "#0091")
		EndIf
	EndIf

EndFunc   ;==>dropCC
