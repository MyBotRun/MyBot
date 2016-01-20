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
	If $slot <> -1 And (($iMatchMode <> $DB And $iMatchMode <> $LB) Or $iDropCC[$iMatchMode] = 1  or $iDropCCCSV[$iMatchMode]=1) Then

		If $iPlannedDropCCHoursEnable = 1 Then
			Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
			If $iPlannedDropCCHours[$hour[0]] = 0 Then
				SetLog("Drop CC not Planned, Skipped..", $COLOR_GREEN)
				Return ; exit func if no planned donate checkmarks
			EndIf
		EndIf

	    If $ichkUseAttackDBCSV = 1 or $ichkUseAttackABCSV = 1 Then
		   ;scripted attack
		   If $iChkUseCCBalancedCSV = 1 Then
			   If Number($TroopsReceived) <> 0 Then
				   If Number(Number($TroopsDonated) / Number($TroopsReceived)) >= (Number($iCmbCCDonatedCSV) / Number($iCmbCCReceivedCSV)) Then
					   SetLog("Dropping Clan Castle, donated (" & $TroopsDonated & ") / received (" & $TroopsReceived & ") >= " & $iCmbCCDonatedCSV & "/" & $iCmbCCReceivedCSV, $COLOR_BLUE)
					   Click(GetXPosOfArmySlot($slot, 68), 595 + $bottomOffsetY, 1, $iDelaydropCC2,"#9999")
					   If _Sleep($iDelaydropCC1) Then Return
					   Click($x, $y,1,0,"#9999")
				   Else
					   SetLog("No Dropping Clan Castle, donated  (" & $TroopsDonated & ") / received (" & $TroopsReceived & ") < " & $iCmbCCDonatedCSV & "/" & $iCmbCCReceivedCSV, $COLOR_BLUE)
				   EndIf
			   Else
				   If Number(Number($TroopsDonated) / 1) >= (Number($iCmbCCDonatedCSV) / Number($iCmbCCReceivedCSV)) Then
					   SetLog("Dropping Clan Castle, donated (" & $TroopsDonated & ") / received (" & $TroopsReceived & ") >= " & $iCmbCCDonatedCSV & "/" & $iCmbCCReceivedCSV, $COLOR_BLUE)
					   Click(GetXPosOfArmySlot($slot, 68), 595 + $bottomOffsetY, 1, $iDelaydropCC2,"#0088")
					   If _Sleep($iDelaydropCC1) Then Return
					   Click($x, $y,1,0,"#9999")
				   Else
					   SetLog("No Dropping Clan Castle, donated  (" & $TroopsDonated & ") / received (" & $TroopsReceived & ") < " & $iCmbCCDonatedCSV & "/" & $iCmbCCReceivedCSV, $COLOR_BLUE)
				   EndIf
			   EndIf
		   Else
			   SetLog("Dropping Clan Castle", $COLOR_BLUE)
			   Click(GetXPosOfArmySlot($slot, 68), 595 + $bottomOffsetY, 1, $iDelaydropCC2,"#9999")
			   If _Sleep($iDelaydropCC1) Then Return
			   Click($x, $y,1,0,"#9999")
		   EndIf
	    Else
		   ;standard attack
		   If $iChkUseCCBalanced = 1 Then
			   If Number($TroopsReceived) <> 0 Then
				   If Number(Number($TroopsDonated) / Number($TroopsReceived)) >= (Number($iCmbCCDonated) / Number($iCmbCCReceived)) Then
					   SetLog("Dropping Clan Castle, donated (" & $TroopsDonated & ") / received (" & $TroopsReceived & ") >= " & $iCmbCCDonated & "/" & $iCmbCCReceived, $COLOR_BLUE)
					   Click(GetXPosOfArmySlot($slot, 68), 595 + $bottomOffsetY, 1, $iDelaydropCC2,"#0086")
					   If _Sleep($iDelaydropCC1) Then Return
					   Click($x, $y,1,0,"#0087")
				   Else
					   SetLog("No Dropping Clan Castle, donated  (" & $TroopsDonated & ") / received (" & $TroopsReceived & ") < " & $iCmbCCDonated & "/" & $iCmbCCReceived, $COLOR_BLUE)
				   EndIf
			   Else
				   If Number(Number($TroopsDonated) / 1) >= (Number($iCmbCCDonated) / Number($iCmbCCReceived)) Then
					   SetLog("Dropping Clan Castle, donated (" & $TroopsDonated & ") / received (" & $TroopsReceived & ") >= " & $iCmbCCDonated & "/" & $iCmbCCReceived, $COLOR_BLUE)
					   Click(GetXPosOfArmySlot($slot, 68), 595 + $bottomOffsetY, 1, $iDelaydropCC2,"#0088")
					   If _Sleep($iDelaydropCC1) Then Return
					   Click($x, $y,1,0,"#0089")
				   Else
					   SetLog("No Dropping Clan Castle, donated  (" & $TroopsDonated & ") / received (" & $TroopsReceived & ") < " & $iCmbCCDonated & "/" & $iCmbCCReceived, $COLOR_BLUE)
				   EndIf
			   EndIf
		   Else
			   SetLog("Dropping Clan Castle", $COLOR_BLUE)
			   Click(GetXPosOfArmySlot($slot, 68), 595 + $bottomOffsetY, 1, $iDelaydropCC2,"#0090")
			   If _Sleep($iDelaydropCC1) Then Return
			   Click($x, $y,1,0,"#0091")
			EndIf
		 EndIf
	EndIf
EndFunc   ;==>dropCC
