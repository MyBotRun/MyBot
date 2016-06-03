;Drops Clan Castle troops, given the slot and x, y coordinates.

; #FUNCTION# ====================================================================================================================
; Name ..........: dropCC
; Description ...: Drops Clan Castle troops, given the slot and x, y coordinates.
; Syntax ........: dropCC($x, $y, $slot)
; Parameters ....: $x                   - X location.
;                  $y                   - Y location.
;                  $slot                - CC location in troop menu
; Return values .: None
; Author ........:
; Modified ......: Sardo (2015-12) KnowJack (June2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func dropCC($x, $y, $slot) ;Drop clan castle
	;If $slot <> -1 And (($iMatchMode <> $DB And $iMatchMode <> $LB) Or $iDropCC[$iMatchMode] = 1 Or $iDropCCCSV[$iMatchMode] = 1) Then

	Local $test1 = false
	Local $test2 = false
	If $iMatchMode = $MA and $iDropCC[$DB] = 1  then $test1= True
	if $iMatchMode <>$MA Then
		If ($iMatchMode <> $DB And $iMatchMode <> $LB and $iMatchMode <> $MA) Or $iDropCC[$iMatchMode] = 1 Or $iDropCCCSV[$iMatchMode] = 1  Then $test2 = True
	EndIf

	If $slot <> -1 and ( $test1 or $test2 )	Then
		If $iPlannedDropCCHoursEnable = 1 Then
			Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
			If $iPlannedDropCCHours[$hour[0]] = 0 Then
				SetLog("Drop CC not Planned, Skipped..", $COLOR_GREEN)
				Return ; exit func if no planned donate checkmarks
			EndIf
		EndIf


		;standard attack
		If $iChkUseCCBalanced = 1 Then
			If Number($TroopsReceived) <> 0 Then
				If Number(Number($TroopsDonated) / Number($TroopsReceived)) >= (Number($iCmbCCDonated) / Number($iCmbCCReceived)) Then
					SetLog("Dropping Clan Castle, donated (" & $TroopsDonated & ") / received (" & $TroopsReceived & ") >= " & $iCmbCCDonated & "/" & $iCmbCCReceived, $COLOR_BLUE)
					Click(GetXPosOfArmySlot($slot, 68), 595 + $bottomOffsetY, 1, $iDelaydropCC2, "#0086")
					If _Sleep($iDelaydropCC1) Then Return
					Click($x, $y, 1, 0, "#0087")
				Else
					SetLog("No Dropping Clan Castle, donated  (" & $TroopsDonated & ") / received (" & $TroopsReceived & ") < " & $iCmbCCDonated & "/" & $iCmbCCReceived, $COLOR_BLUE)
				EndIf
			Else
				If Number(Number($TroopsDonated) / 1) >= (Number($iCmbCCDonated) / Number($iCmbCCReceived)) Then
					SetLog("Dropping Clan Castle, donated (" & $TroopsDonated & ") / received (" & $TroopsReceived & ") >= " & $iCmbCCDonated & "/" & $iCmbCCReceived, $COLOR_BLUE)
					Click(GetXPosOfArmySlot($slot, 68), 595 + $bottomOffsetY, 1, $iDelaydropCC2, "#0088")
					If _Sleep($iDelaydropCC1) Then Return
					Click($x, $y, 1, 0, "#0089")
				Else
					SetLog("No Dropping Clan Castle, donated  (" & $TroopsDonated & ") / received (" & $TroopsReceived & ") < " & $iCmbCCDonated & "/" & $iCmbCCReceived, $COLOR_BLUE)
				EndIf
			EndIf
		Else
			SetLog("Dropping Clan Castle", $COLOR_BLUE)
			Click(GetXPosOfArmySlot($slot, 68), 595 + $bottomOffsetY, 1, $iDelaydropCC2, "#0090")
			If _Sleep($iDelaydropCC1) Then Return
			Click($x, $y, 1, 0, "#0091")
		EndIf
	EndIf

EndFunc   ;==>dropCC
