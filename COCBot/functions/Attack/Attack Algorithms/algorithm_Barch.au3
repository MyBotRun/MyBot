; #FUNCTION# ====================================================================================================================
; Name ..........: algorithm_Barch
; Description ...: This file contens the attack algorithm using Barbarians and Archers
; Syntax ........: Barch()
; Parameters ....: None
; Return values .: None
; Author ........: MBR (12-2014)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================


Func Barch() ;Attack Algorithm for Barch
	While 1
		Local $iBarb = -1, $iArch = -1, $iCC = -1
		Local $iKing = -1, $iQueen = -1, $iWarden = -1
		For $i = 0 To UBound($g_avAttackTroops) - 1
			If $g_avAttackTroops[$i][0] = "Barbarian" Then
				$iBarb = $i
			ElseIf $g_avAttackTroops[$i][0] = "Archer" Then
				$iArch = $i
			ElseIf $g_avAttackTroops[$i][0] = "Clan Castle" Then
				$iCC = $i
			ElseIf $g_avAttackTroops[$i][0] = "King" Then
				$iKing = $i
			ElseIf $g_avAttackTroops[$i][0] = "Queen" Then
				$iQueen = $i
			ElseIf $g_avAttackTroops[$i][0] = "Warden" Then
				$iWarden = $i
			EndIf
		Next

		If _Sleep($DELAYBARCH2) Then ExitLoop
		Switch $g_aiAttackStdDropSides[$g_iMatchMode]
			Case 0 ;Two sides ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				SetLog("~Attacking from two sides...")
				If _Sleep($DELAYBARCH3) Then ExitLoop
				Local $numBarbPerSpot = Ceiling((($g_avAttackTroops[$iBarb][1] / 2) / 5) / 2)
				Local $numArchPerSpot = Ceiling((($g_avAttackTroops[$iArch][1] / 2) / 5) / 2)

				SetLog("Dropping first wave of Barbarians", $COLOR_INFO)
				For $i = 0 To 4 ;Drop first round of Barbarians
					Click(GetXPosOfArmySlot($iBarb, 68), 595 + $g_iBottomOffsetY, 1, 0, "#0032") ;Select Troop
					If _Sleep($DELAYBARCH1) Then ExitLoop (2)
					Click($g_aaiTopLeftDropPoints[$i][0], $g_aaiTopLeftDropPoints[$i][1], $numBarbPerSpot, 1, "#0033")
					Click($g_aaiBottomRightDropPoints[$i][0], $g_aaiBottomRightDropPoints[$i][1], $numBarbPerSpot, 1, "#0034")
				Next

				If _Sleep($DELAYBARCH3) Then ExitLoop

				SetLog("Dropping first wave of Archers", $COLOR_INFO)
				For $i = 0 To 4 ;Drop first round of Archers
					Click(GetXPosOfArmySlot($iArch, 68), 595 + $g_iBottomOffsetY, 1, 0, "#0035") ;Select Troop
					If _Sleep($DELAYBARCH1) Then ExitLoop (2)
					Click($g_aaiTopLeftDropPoints[$i][0], $g_aaiTopLeftDropPoints[$i][1], $numArchPerSpot, 1, "#0036")
					Click($g_aaiBottomRightDropPoints[$i][0], $g_aaiBottomRightDropPoints[$i][1], $numArchPerSpot, 1, "#0037")
				Next

				If _Sleep(2000) Then ExitLoop ;-------------------------------------------

				SetLog("Dropping second wave of Barbarians", $COLOR_INFO)
				For $i = 0 To 4 ;Drop second round of Barbarians
					Click(GetXPosOfArmySlot($iBarb, 68), 595 + $g_iBottomOffsetY, 1, 0, "#0038") ;Select Troop
					If _Sleep($DELAYBARCH1) Then ExitLoop (2)
					Click($g_aaiTopLeftDropPoints[$i][0], $g_aaiTopLeftDropPoints[$i][1], $numBarbPerSpot, 1, "#0039")
					Click($g_aaiBottomRightDropPoints[$i][0], $g_aaiBottomRightDropPoints[$i][1], $numBarbPerSpot, 1, "#0040")
				Next

				If _Sleep($DELAYBARCH3) Then ExitLoop

				SetLog("Dropping second wave of Archers", $COLOR_INFO)
				For $i = 0 To 4 ;Drop second round of Archers
					Click(GetXPosOfArmySlot($iArch, 68), 595 + $g_iBottomOffsetY, 1, 0, "#0041") ;Select Troop
					If _Sleep($DELAYBARCH1) Then ExitLoop (2)
					Click($g_aaiTopLeftDropPoints[$i][0], $g_aaiTopLeftDropPoints[$i][1], $numArchPerSpot, 1, "#0042")
					Click($g_aaiBottomRightDropPoints[$i][0], $g_aaiBottomRightDropPoints[$i][1], $numArchPerSpot, 1, "#0043")
				Next

				dropHeroes($g_aaiTopLeftDropPoints[3][0], $g_aaiTopLeftDropPoints[3][1], $iKing, $iQueen, $iWarden)
				If _Sleep($DELAYBARCH3) Then ExitLoop
				dropCC($g_aaiTopLeftDropPoints[3][0], $g_aaiTopLeftDropPoints[3][1], $iCC)
			Case 1 ;Three sides ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				SetLog("~Attacking from three sides...")
				If _Sleep($DELAYBARCH3) Then ExitLoop
				Local $numBarbPerSpot = Ceiling((($g_avAttackTroops[$iBarb][1] / 3) / 5) / 2)
				Local $numArchPerSpot = Ceiling((($g_avAttackTroops[$iArch][1] / 3) / 5) / 2)

				SetLog("Dropping first wave of Barbarians", $COLOR_INFO)
				For $i = 0 To 4 ;Drop first round of Barbarians
					Click(GetXPosOfArmySlot($iBarb, 68), 595 + $g_iBottomOffsetY, 1, 0, "#0044") ;Select Troop
					If _Sleep($DELAYBARCH1) Then ExitLoop (2)
					Click($g_aaiTopLeftDropPoints[$i][0], $g_aaiTopLeftDropPoints[$i][1], $numBarbPerSpot, 1, "#0045")
					Click($g_aaiTopRightDropPoints[$i][0], $g_aaiTopRightDropPoints[$i][1], $numBarbPerSpot, 1, "#0046")
					Click($g_aaiBottomRightDropPoints[$i][0], $g_aaiBottomRightDropPoints[$i][1], $numBarbPerSpot, 1, "#0047")
				Next

				If _Sleep($DELAYBARCH3) Then ExitLoop

				SetLog("Dropping first wave of Archers", $COLOR_INFO)
				For $i = 0 To 4 ;Drop first round of Archers
					Click(GetXPosOfArmySlot($iArch, 68), 595 + $g_iBottomOffsetY, 1, 0, "#0048") ;Select Troop
					If _Sleep($DELAYBARCH1) Then ExitLoop (2)
					Click($g_aaiTopLeftDropPoints[$i][0], $g_aaiTopLeftDropPoints[$i][1], $numArchPerSpot, 1, "#0049")
					Click($g_aaiTopRightDropPoints[$i][0], $g_aaiTopRightDropPoints[$i][1], $numArchPerSpot, 1, "#0050")
					Click($g_aaiBottomRightDropPoints[$i][0], $g_aaiBottomRightDropPoints[$i][1], $numArchPerSpot, 1, "#0051")
				Next

				If _Sleep(2000) Then ExitLoop ;-------------------------------------------

				SetLog("Dropping second wave of Barbarians", $COLOR_INFO)
				For $i = 0 To 4 ;Drop second round of Barbarians
					Click(GetXPosOfArmySlot($iBarb, 68), 595 + $g_iBottomOffsetY, 1, 0, "#0052") ;Select Troop
					If _Sleep($DELAYBARCH1) Then ExitLoop (2)
					Click($g_aaiTopLeftDropPoints[$i][0], $g_aaiTopLeftDropPoints[$i][1], $numBarbPerSpot, 1, "#0053")
					Click($g_aaiTopRightDropPoints[$i][0], $g_aaiTopRightDropPoints[$i][1], $numBarbPerSpot, 1, "#0054")
					Click($g_aaiBottomRightDropPoints[$i][0], $g_aaiBottomRightDropPoints[$i][1], $numBarbPerSpot, 1, "#0055")
				Next

				If _Sleep($DELAYBARCH3) Then ExitLoop

				SetLog("Dropping second wave of Archers", $COLOR_INFO)
				For $i = 0 To 4 ;Drop second round of Archers
					Click(GetXPosOfArmySlot($iArch, 68), 595 + $g_iBottomOffsetY, 1, 0, "#0085") ;Select Troop
					If _Sleep($DELAYBARCH1) Then ExitLoop (2)
					Click($g_aaiTopLeftDropPoints[$i][0], $g_aaiTopLeftDropPoints[$i][1], $numArchPerSpot, 1, "#0056")
					Click($g_aaiTopRightDropPoints[$i][0], $g_aaiTopRightDropPoints[$i][1], $numArchPerSpot, 1, "#0057")
					Click($g_aaiBottomRightDropPoints[$i][0], $g_aaiBottomRightDropPoints[$i][1], $numArchPerSpot, 1, "#0058")
				Next

				dropHeroes($g_aaiTopRightDropPoints[3][0], $g_aaiTopRightDropPoints[3][1], $iKing, $iQueen, $iWarden)
				If _Sleep($DELAYBARCH3) Then ExitLoop
				dropCC($g_aaiTopRightDropPoints[3][0], $g_aaiTopRightDropPoints[3][1], $iCC)
			Case 2 ;Four sides ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				SetLog("~Attacking from all sides...")
				If _Sleep($DELAYBARCH3) Then ExitLoop
				Local $numBarbPerSpot = Ceiling((($g_avAttackTroops[$iBarb][1] / 4) / 5) / 2)
				Local $numArchPerSpot = Ceiling((($g_avAttackTroops[$iArch][1] / 4) / 5) / 2)

				SetLog("Dropping first wave of Barbarians", $COLOR_INFO)
				For $i = 0 To 4 ;Drop first round of Barbarians
					Click(GetXPosOfArmySlot($iBarb, 68), 595 + $g_iBottomOffsetY, 1, 0, "#0059") ;Select Troop
					If _Sleep($DELAYBARCH1) Then ExitLoop (2)
					Click($g_aaiTopLeftDropPoints[$i][0], $g_aaiTopLeftDropPoints[$i][1], $numBarbPerSpot, 1, "#0060")
					Click($g_aaiTopRightDropPoints[$i][0], $g_aaiTopRightDropPoints[$i][1], $numBarbPerSpot, 1, "#0061")
					Click($g_aaiBottomLeftDropPoints[$i][0], $g_aaiBottomLeftDropPoints[$i][1], $numBarbPerSpot, 1, "#0062")
					Click($g_aaiBottomRightDropPoints[$i][0], $g_aaiBottomRightDropPoints[$i][1], $numBarbPerSpot, 1, "#0063")
				Next

				If _Sleep($DELAYBARCH3) Then ExitLoop

				SetLog("Dropping first wave of Archers", $COLOR_INFO)
				For $i = 0 To 4 ;Drop first round of Archers
					Click(GetXPosOfArmySlot($iArch, 68), 595 + $g_iBottomOffsetY, 1, 0, "#0064") ;Select Troop
					If _Sleep($DELAYBARCH1) Then ExitLoop (2)
					Click($g_aaiTopLeftDropPoints[$i][0], $g_aaiTopLeftDropPoints[$i][1], $numArchPerSpot, 1, "#0065")
					Click($g_aaiTopRightDropPoints[$i][0], $g_aaiTopRightDropPoints[$i][1], $numArchPerSpot, 1, "#0066")
					Click($g_aaiBottomLeftDropPoints[$i][0], $g_aaiBottomLeftDropPoints[$i][1], $numArchPerSpot, 1, "#0067")
					Click($g_aaiBottomRightDropPoints[$i][0], $g_aaiBottomRightDropPoints[$i][1], $numArchPerSpot, 1, "#0068")
				Next

				If _Sleep(2000) Then ExitLoop ;-------------------------------------------

				SetLog("Dropping second wave of Barbarians", $COLOR_INFO)
				For $i = 0 To 4 ;Drop second round of Barbarians
					Click(GetXPosOfArmySlot($iBarb, 68), 595 + $g_iBottomOffsetY, 1, 0, "#0069") ;Select Troop
					If _Sleep($DELAYBARCH1) Then ExitLoop (2)
					Click($g_aaiTopLeftDropPoints[$i][0], $g_aaiTopLeftDropPoints[$i][1], $numBarbPerSpot, 1, "#0070")
					Click($g_aaiTopRightDropPoints[$i][0], $g_aaiTopRightDropPoints[$i][1], $numBarbPerSpot, 1, "#0071")
					Click($g_aaiBottomLeftDropPoints[$i][0], $g_aaiBottomLeftDropPoints[$i][1], $numBarbPerSpot, 1, "#0072")
					Click($g_aaiBottomRightDropPoints[$i][0], $g_aaiBottomRightDropPoints[$i][1], $numBarbPerSpot, 1, "#0073")
				Next

				If _Sleep($DELAYBARCH3) Then ExitLoop

				SetLog("Dropping second wave of Archers", $COLOR_INFO)
				For $i = 0 To 4 ;Drop second round of Archers
					Click(GetXPosOfArmySlot($iArch, 68), 595 + $g_iBottomOffsetY, 1, 0, "#0074") ;Select Troop
					If _Sleep($DELAYBARCH1) Then ExitLoop (2)
					Click($g_aaiTopLeftDropPoints[$i][0], $g_aaiTopLeftDropPoints[$i][1], $numArchPerSpot, 1, "#0075")
					Click($g_aaiTopRightDropPoints[$i][0], $g_aaiTopRightDropPoints[$i][1], $numArchPerSpot, 1, "#0076")
					Click($g_aaiBottomLeftDropPoints[$i][0], $g_aaiBottomLeftDropPoints[$i][1], $numArchPerSpot, 1, "#0077")
					Click($g_aaiBottomRightDropPoints[$i][0], $g_aaiBottomRightDropPoints[$i][1], $numArchPerSpot, 1, "#0078")
				Next

				dropHeroes($g_aaiBottomLeftDropPoints[3][0], $g_aaiBottomLeftDropPoints[3][1], $iKing, $iQueen, $iWarden)
				If _Sleep($DELAYBARCH3) Then ExitLoop
				dropCC($g_aaiBottomLeftDropPoints[3][0], $g_aaiBottomLeftDropPoints[3][1], $iCC)
		EndSwitch

		If _Sleep($DELAYBARCH1) Then ExitLoop
		SetLog("Dropping left over troops", $COLOR_INFO)
		$g_avAttackTroops[$iBarb][1] = Number(ReadTroopQuantity($iBarb))
		$g_avAttackTroops[$iArch][1] = Number(ReadTroopQuantity($iArch))

		While $g_avAttackTroops[$iBarb][1] <> 0
			Click(GetXPosOfArmySlot($iBarb, 68), 595 + $g_iBottomOffsetY, 1, 0, "#0079")
			Click($g_aaiTopLeftDropPoints[3][0], $g_aaiTopLeftDropPoints[3][1], $g_avAttackTroops[$iBarb][1], 1, "#0080")

			$g_avAttackTroops[$iBarb][1] = Number(ReadTroopQuantity($iBarb))
		WEnd

		If _Sleep($DELAYBARCH3) Then ExitLoop

		While $g_avAttackTroops[$iArch][1] <> 0
			Click(GetXPosOfArmySlot($iArch, 68), 595 + $g_iBottomOffsetY, 1, 0, "#0081")
			Click($g_aaiTopLeftDropPoints[3][0], $g_aaiTopLeftDropPoints[3][1], $g_avAttackTroops[$iArch][1], 1, "#0082")

			$g_avAttackTroops[$iArch][1] = Number(ReadTroopQuantity($iArch))
		WEnd

		If _Sleep($DELAYBARCH1) Then ExitLoop

		;Activate KQ's power
		If $g_bCheckKingPower Or $g_bCheckQueenPower Then
			Local $iWaitTime = 0

			If Int($g_iDelayActivateKing) > Int($g_iDelayActivateQueen)  Then
				$iWaitTime = Int($g_iDelayActivateKing)
			ElseIf Int($g_iDelayActivateQueen) > Int($g_iDelayActivateKing) Then
				$iWaitTime = Int($g_iDelayActivateQueen)
			EndIf

			SetLog("Waiting " & $iWaitTime / 1000 & " seconds before activating Hero abilities", $COLOR_SUCCESS)
			If _Sleep($iWaitTime) Then Return
			If $g_bCheckKingPower Then
				SetLog("Activate King's power", $COLOR_INFO)
				Click(GetXPosOfArmySlot($iKing, 68), 595 + $g_iBottomOffsetY, 1, 0, "#0083")
			EndIf
			If $g_bCheckQueenPower Then
				SetLog("Activate Queen's power", $COLOR_INFO)
				Click(GetXPosOfArmySlot($iQueen, 68), 595 + $g_iBottomOffsetY, 1, 0, "#0084")
			EndIf
		EndIf

		SetLog("~Finished Attacking, waiting to finish")
		ExitLoop
	WEnd
EndFunc   ;==>Barch
