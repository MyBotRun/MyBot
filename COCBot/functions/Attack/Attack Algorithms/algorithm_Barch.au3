; #FUNCTION# ====================================================================================================================
; Name ..........: algorithm_Barch
; Description ...: This file contens the attack algorithm using Barbarians and Archers
; Syntax ........: Barch()
; Parameters ....: None
; Return values .: None
; Author ........:  (2014-Dec)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================


Func Barch() ;Attack Algorithm for Barch
	While 1
		Local $Barb = -1, $Arch = -1, $CC = -1
		Global $King = -1, $Queen = -1, $Warden = -1
		For $i = 0 To UBound($atkTroops) - 1
			If $atkTroops[$i][0] = "Barbarian" Then
				$Barb = $i
			ElseIf $atkTroops[$i][0] = "Archer" Then
				$Arch = $i
			ElseIf $atkTroops[$i][0] = "Clan Castle" Then
				$CC = $i
			ElseIf $atkTroops[$i][0] = "King" Then
				$King = $i
			ElseIf $atkTroops[$i][0] = "Queen" Then
				$Queen = $i
			ElseIf $atkTroops[$i][0] = "Warden" Then
				$Warden = $i
			EndIf
		Next

		If _Sleep($iDelayBarch2) Then ExitLoop
		Switch $iChkDeploySettings[$iMatchMode]
			Case 0 ;Two sides ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				SetLog("~Attacking from two sides...")
				If _Sleep($iDelayBarch3) Then ExitLoop
				Local $numBarbPerSpot = Ceiling((($atkTroops[$Barb][1] / 2) / 5) / 2)
				Local $numArchPerSpot = Ceiling((($atkTroops[$Arch][1] / 2) / 5) / 2)

				SetLog("Dropping first wave of Barbarians", $COLOR_BLUE)
				For $i = 0 To 4 ;Drop first round of Barbarians
					Click(GetXPosOfArmySlot($Barb, 68), 595 + $bottomOffsetY, 1, 0, "#0032") ;Select Troop
					If _Sleep($iDelayBarch1) Then ExitLoop (2)
					Click($TopLeft[$i][0], $TopLeft[$i][1], $numBarbPerSpot, 1, "#0033")
					Click($BottomRight[$i][0], $BottomRight[$i][1], $numBarbPerSpot, 1, "#0034")
				Next

				If _Sleep($iDelayBarch3) Then ExitLoop

				SetLog("Dropping first wave of Archers", $COLOR_BLUE)
				For $i = 0 To 4 ;Drop first round of Archers
					Click(GetXPosOfArmySlot($Arch, 68), 595 + $bottomOffsetY, 1, 0, "#0035") ;Select Troop
					If _Sleep($iDelayBarch1) Then ExitLoop (2)
					Click($TopLeft[$i][0], $TopLeft[$i][1], $numArchPerSpot, 1, "#0036")
					Click($BottomRight[$i][0], $BottomRight[$i][1], $numArchPerSpot, 1, "#0037")
				Next

				If _Sleep(2000) Then ExitLoop ;-------------------------------------------

				SetLog("Dropping second wave of Barbarians", $COLOR_BLUE)
				For $i = 0 To 4 ;Drop second round of Barbarians
					Click(GetXPosOfArmySlot($Barb, 68), 595 + $bottomOffsetY, 1, 0, "#0038") ;Select Troop
					If _Sleep($iDelayBarch1) Then ExitLoop (2)
					Click($TopLeft[$i][0], $TopLeft[$i][1], $numBarbPerSpot, 1, "#0039")
					Click($BottomRight[$i][0], $BottomRight[$i][1], $numBarbPerSpot, 1, "#0040")
				Next

				If _Sleep($iDelayBarch3) Then ExitLoop

				SetLog("Dropping second wave of Archers", $COLOR_BLUE)
				For $i = 0 To 4 ;Drop second round of Archers
					Click(GetXPosOfArmySlot($Arch, 68), 595 + $bottomOffsetY, 1, 0, "#0041") ;Select Troop
					If _Sleep($iDelayBarch1) Then ExitLoop (2)
					Click($TopLeft[$i][0], $TopLeft[$i][1], $numArchPerSpot, 1, "#0042")
					Click($BottomRight[$i][0], $BottomRight[$i][1], $numArchPerSpot, 1, "#0043")
				Next

				dropHeroes($TopLeft[3][0], $TopLeft[3][1], $King, $Queen, $Warden)
				If _Sleep($iDelayBarch3) Then ExitLoop
				dropCC($TopLeft[3][0], $TopLeft[3][1], $CC)
			Case 1 ;Three sides ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				SetLog("~Attacking from three sides...")
				If _Sleep($iDelayBarch3) Then ExitLoop
				Local $numBarbPerSpot = Ceiling((($atkTroops[$Barb][1] / 3) / 5) / 2)
				Local $numArchPerSpot = Ceiling((($atkTroops[$Arch][1] / 3) / 5) / 2)

				SetLog("Dropping first wave of Barbarians", $COLOR_BLUE)
				For $i = 0 To 4 ;Drop first round of Barbarians
					Click(GetXPosOfArmySlot($Barb, 68), 595 + $bottomOffsetY, 1, 0, "#0044") ;Select Troop
					If _Sleep($iDelayBarch1) Then ExitLoop (2)
					Click($TopLeft[$i][0], $TopLeft[$i][1], $numBarbPerSpot, 1, "#0045")
					Click($TopRight[$i][0], $TopRight[$i][1], $numBarbPerSpot, 1, "#0046")
					Click($BottomRight[$i][0], $BottomRight[$i][1], $numBarbPerSpot, 1, "#0047")
				Next

				If _Sleep($iDelayBarch3) Then ExitLoop

				SetLog("Dropping first wave of Archers", $COLOR_BLUE)
				For $i = 0 To 4 ;Drop first round of Archers
					Click(GetXPosOfArmySlot($Arch, 68), 595 + $bottomOffsetY, 1, 0, "#0048") ;Select Troop
					If _Sleep($iDelayBarch1) Then ExitLoop (2)
					Click($TopLeft[$i][0], $TopLeft[$i][1], $numArchPerSpot, 1, "#0049")
					Click($TopRight[$i][0], $TopRight[$i][1], $numArchPerSpot, 1, "#0050")
					Click($BottomRight[$i][0], $BottomRight[$i][1], $numArchPerSpot, 1, "#0051")
				Next

				If _Sleep(2000) Then ExitLoop ;-------------------------------------------

				SetLog("Dropping second wave of Barbarians", $COLOR_BLUE)
				For $i = 0 To 4 ;Drop second round of Barbarians
					Click(GetXPosOfArmySlot($Barb, 68), 595 + $bottomOffsetY, 1, 0, "#0052") ;Select Troop
					If _Sleep($iDelayBarch1) Then ExitLoop (2)
					Click($TopLeft[$i][0], $TopLeft[$i][1], $numBarbPerSpot, 1, "#0053")
					Click($TopRight[$i][0], $TopRight[$i][1], $numBarbPerSpot, 1, "#0054")
					Click($BottomRight[$i][0], $BottomRight[$i][1], $numBarbPerSpot, 1, "#0055")
				Next

				If _Sleep($iDelayBarch3) Then ExitLoop

				SetLog("Dropping second wave of Archers", $COLOR_BLUE)
				For $i = 0 To 4 ;Drop second round of Archers
					Click(GetXPosOfArmySlot($Arch, 68), 595 + $bottomOffsetY, 1, 0, "#0085") ;Select Troop
					If _Sleep($iDelayBarch1) Then ExitLoop (2)
					Click($TopLeft[$i][0], $TopLeft[$i][1], $numArchPerSpot, 1, "#0056")
					Click($TopRight[$i][0], $TopRight[$i][1], $numArchPerSpot, 1, "#0057")
					Click($BottomRight[$i][0], $BottomRight[$i][1], $numArchPerSpot, 1, "#0058")
				Next

				dropHeroes($TopRight[3][0], $TopRight[3][1], $King, $Queen, $Warden)
				If _Sleep($iDelayBarch3) Then ExitLoop
				dropCC($TopRight[3][0], $TopRight[3][1], $CC)
			Case 2 ;Four sides ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				SetLog("~Attacking from all sides...")
				If _Sleep($iDelayBarch3) Then ExitLoop
				Local $numBarbPerSpot = Ceiling((($atkTroops[$Barb][1] / 4) / 5) / 2)
				Local $numArchPerSpot = Ceiling((($atkTroops[$Arch][1] / 4) / 5) / 2)

				SetLog("Dropping first wave of Barbarians", $COLOR_BLUE)
				For $i = 0 To 4 ;Drop first round of Barbarians
					Click(GetXPosOfArmySlot($Barb, 68), 595 + $bottomOffsetY, 1, 0, "#0059") ;Select Troop
					If _Sleep($iDelayBarch1) Then ExitLoop (2)
					Click($TopLeft[$i][0], $TopLeft[$i][1], $numBarbPerSpot, 1, "#0060")
					Click($TopRight[$i][0], $TopRight[$i][1], $numBarbPerSpot, 1, "#0061")
					Click($BottomLeft[$i][0], $BottomLeft[$i][1], $numBarbPerSpot, 1, "#0062")
					Click($BottomRight[$i][0], $BottomRight[$i][1], $numBarbPerSpot, 1, "#0063")
				Next

				If _Sleep($iDelayBarch3) Then ExitLoop

				SetLog("Dropping first wave of Archers", $COLOR_BLUE)
				For $i = 0 To 4 ;Drop first round of Archers
					Click(GetXPosOfArmySlot($Arch, 68), 595 + $bottomOffsetY, 1, 0, "#0064") ;Select Troop
					If _Sleep($iDelayBarch1) Then ExitLoop (2)
					Click($TopLeft[$i][0], $TopLeft[$i][1], $numArchPerSpot, 1, "#0065")
					Click($TopRight[$i][0], $TopRight[$i][1], $numArchPerSpot, 1, "#0066")
					Click($BottomLeft[$i][0], $BottomLeft[$i][1], $numArchPerSpot, 1, "#0067")
					Click($BottomRight[$i][0], $BottomRight[$i][1], $numArchPerSpot, 1, "#0068")
				Next

				If _Sleep(2000) Then ExitLoop ;-------------------------------------------

				SetLog("Dropping second wave of Barbarians", $COLOR_BLUE)
				For $i = 0 To 4 ;Drop second round of Barbarians
					Click(GetXPosOfArmySlot($Barb, 68), 595 + $bottomOffsetY, 1, 0, "#0069") ;Select Troop
					If _Sleep($iDelayBarch1) Then ExitLoop (2)
					Click($TopLeft[$i][0], $TopLeft[$i][1], $numBarbPerSpot, 1, "#0070")
					Click($TopRight[$i][0], $TopRight[$i][1], $numBarbPerSpot, 1, "#0071")
					Click($BottomLeft[$i][0], $BottomLeft[$i][1], $numBarbPerSpot, 1, "#0072")
					Click($BottomRight[$i][0], $BottomRight[$i][1], $numBarbPerSpot, 1, "#0073")
				Next

				If _Sleep($iDelayBarch3) Then ExitLoop

				SetLog("Dropping second wave of Archers", $COLOR_BLUE)
				For $i = 0 To 4 ;Drop second round of Archers
					Click(GetXPosOfArmySlot($Arch, 68), 595 + $bottomOffsetY, 1, 0, "#0074") ;Select Troop
					If _Sleep($iDelayBarch1) Then ExitLoop (2)
					Click($TopLeft[$i][0], $TopLeft[$i][1], $numArchPerSpot, 1, "#0075")
					Click($TopRight[$i][0], $TopRight[$i][1], $numArchPerSpot, 1, "#0076")
					Click($BottomLeft[$i][0], $BottomLeft[$i][1], $numArchPerSpot, 1, "#0077")
					Click($BottomRight[$i][0], $BottomRight[$i][1], $numArchPerSpot, 1, "#0078")
				Next

				dropHeroes($BottomLeft[3][0], $BottomLeft[3][1], $King, $Queen, $Warden)
				If _Sleep($iDelayBarch3) Then ExitLoop
				dropCC($BottomLeft[3][0], $BottomLeft[3][1], $CC)
		EndSwitch

		If _Sleep($iDelayBarch1) Then ExitLoop
		SetLog("Dropping left over troops", $COLOR_BLUE)
		$atkTroops[$Barb][1] = Number(ReadTroopQuantity($Barb))
		$atkTroops[$Arch][1] = Number(ReadTroopQuantity($Arch))

		While $atkTroops[$Barb][1] <> 0
			Click(GetXPosOfArmySlot($Barb, 68), 595 + $bottomOffsetY, 1, 0, "#0079")
			Click($TopLeft[3][0], $TopLeft[3][1], $atkTroops[$Barb][1], 1, "#0080")

			$atkTroops[$Barb][1] = Number(ReadTroopQuantity($Barb))
		WEnd

		If _Sleep($iDelayBarch3) Then ExitLoop

		While $atkTroops[$Arch][1] <> 0
			Click(GetXPosOfArmySlot($Arch, 68), 595 + $bottomOffsetY, 1, 0, "#0081")
			Click($TopLeft[3][0], $TopLeft[3][1], $atkTroops[$Arch][1], 1, "#0082")

			$atkTroops[$Arch][1] = Number(ReadTroopQuantity($Arch))
		WEnd

		If _Sleep($iDelayBarch1) Then ExitLoop

		;Activate KQ's power
		If $checkKPower = True Or $checkQPower = True Then
			SetLog("Waiting " & $delayActivateKQ / 1000 & " seconds before activating Hero abilities", $COLOR_GREEN)
			If _Sleep($delayActivateKQ) Then Return
			If $checkKPower = True Then
				SetLog("Activate King's power", $COLOR_BLUE)
				Click(GetXPosOfArmySlot($King, 68), 595 + $bottomOffsetY, 1, 0, "#0083")
			EndIf
			If $checkQPower = True Then
				SetLog("Activate Queen's power", $COLOR_BLUE)
				Click(GetXPosOfArmySlot($Queen, 68), 595 + $bottomOffsetY, 1, 0, "#0084")
			EndIf
		EndIf

		SetLog("~Finished Attacking, waiting to finish")
		ExitLoop
	WEnd
EndFunc   ;==>Barch
