; #FUNCTION# ==========================================================
; Name ..........: algorithmTH
; Description ...: This file contens the attack algorithm TH and Lspell
; Syntax ........: algorithmTH() , AttackTHGrid() , AttackTHNormal() , AttackTHXtreme() , LLDropheroes() , SpellTHGrid() , CastSpell()
; Parameters ....: None
; Return values .: None
; Author ........: AtoZ (2015)
; Modified ......: Barracoda (July 2015), TheMaster 2015-10
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ================================================================


Func AttackTHGrid($troopKind, $iNbOfSpots = 1, $iAtEachSpot = 1, $Sleep = Random(800, 900, 1), $waveNb = 0)
	#cs ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		$troopKind : The Type of Troop
		$iNbOfSpots : The Number of spots troops are deployed in , $iAtEachSpot : The Number of troops to deploy at each spot , $troopNb ( Troop number ) = $iNbOfSpots * $iAtEachSpot
		$Sleep : delay in ms => 1000ms = 1 sec
		$waveNb : 0 => "Only"  , 1 => "First" , 2 => "Second"  , 3 => "Third"  , 4 => "Last"
	#ce ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	Local $aThx, $aThy, $num
	Local $TroopCountBeg
	Local $THtroop = -1
	Local $troopNb = 0
	Local $name = ""
	Local $plural = 0
	Local $waveName = "first"
	Local $NumTroopDeployed = 0

	If _Sleep(5) Then Return
	If $Restart = True Then Return
	If CheckOneStar(0, False, True) Then Return

	For $i = 0 To UBound($atkTroops) - 1
		If $atkTroops[$i][0] = $troopKind Then
			$THtroop = $i
		EndIf
	Next

	If ($THtroop = -1) And $debugSetlog = 1 Then SetLog("No " & $name & " Found!!!")
	If ($THtroop = -1) Then Return False

	;Heroes And CC
	If $troopKind >= $eKing And $troopKind <= $eCastle Then
		$iNbOfSpots = 1
		$iAtEachSpot = 1
		$troopNb = 1

		;King
		If $troopKind = $eKing Then
			If $ichkUseKingTH = 0 Then Return
			$checkKPower = True
			SetLog("Dropping King", $COLOR_GREEN)
			$THusedKing=1
		EndIf

		;Queen
		If $troopKind = $eQueen Then
			If $ichkUseQueenTH = 0 Then Return
			$checkQPower = True
			SetLog("Dropping Queen", $COLOR_GREEN)
			$THusedQueen=1
		EndIf

		;Warden
		If $troopKind = $eWarden Then
			If $ichkUseWardenTH = 0 Then Return
			$checkWPower = True
			SetLog("Dropping Grand Warden", $COLOR_GREEN)
			$THusedWarden=1
		EndIf

		;CC
		If $troopKind = $eCastle Then
			If $ichkUseClastleTH = 0 Then Return

			If $iPlannedDropCCHoursEnable = 1 Then
				Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
				If $iPlannedDropCCHours[$hour[0]] = 0 Then
					SetLog("Drop Clan Castle not Planned, Skipped..", $COLOR_GREEN)
					Return ; exit func if no planned donate checkmarks
				EndIf
			EndIf

			If $iChkUseCCBalanced = 1 Then
				If Number($TroopsReceived) <> 0 Then
					If Number(Number($TroopsDonated) / Number($TroopsReceived)) >= (Number($iCmbCCDonated) / Number($iCmbCCReceived)) Then
						SetLog("Dropping Clan Castle, donated (" & $TroopsDonated & ") / received (" & $TroopsReceived & ") >= " & $iCmbCCDonated & "/" & $iCmbCCReceived, $COLOR_BLUE)
					Else
						SetLog("Not Dropping Clan Castle, donated  (" & $TroopsDonated & ") / received (" & $TroopsReceived & ") < " & $iCmbCCDonated & "/" & $iCmbCCReceived, $COLOR_BLUE)
						Return
					EndIf
				Else
					If Number(Number($TroopsDonated) / 1) >= (Number($iCmbCCDonated) / Number($iCmbCCReceived)) Then
						SetLog("Dropping Clan Castle, donated (" & $TroopsDonated & ") / received (" & $TroopsReceived & ") >= " & $iCmbCCDonated & "/" & $iCmbCCReceived, $COLOR_BLUE)
					Else
						SetLog("Not Dropping Clan Castle, donated  (" & $TroopsDonated & ") / received (" & $TroopsReceived & ") < " & $iCmbCCDonated & "/" & $iCmbCCReceived, $COLOR_BLUE)
						Return
					EndIf
				EndIf
			EndIf
		EndIf
		;End CC

	EndIf

	; All Barracks Troops
	If $troopKind >= $eBarb And $troopKind <= $eLava Then
		$troopNb = $iNbOfSpots * $iAtEachSpot
		If $troopNb > 1 Then $plural = 1
		$name = NameOfTroop($troopKind, $plural)

		$TroopCountBeg = Number(ReadTroopQuantity($THtroop))
		If ($TroopCountBeg = 0) And $debugSetlog = 1 Then SetLog("No " & $name & " Remaining!!!")
		If ($TroopCountBeg = 0) Then Return False

		If $waveNb = 0 Then $waveName = "Only"
		If $waveNb = 1 Then $waveName = "First"
		If $waveNb = 2 Then $waveName = "Second"
		If $waveNb = 3 Then $waveName = "Third"
		If $waveNb = 4 Then $waveName = "Last"
		SetLog("Dropping " & $waveName & " wave of " & $troopNb & " " & $name, $COLOR_GREEN)
	EndIf
	;End All Barracks Troops

	SelectDropTroop($THtroop) ;Select Troop to be Droped

	If _Sleep($iDelayAttackTHGrid1) Then Return

	DeployTHNormal($iAtEachSpot, $iNbOfSpots)

	If $troopKind >= $eBarb And $troopKind <= $eLava Then
		If $TroopCountBeg <> Number(ReadTroopQuantity($THtroop)) Then
			$NumTroopDeployed = $TroopCountBeg - Number(ReadTroopQuantity($THtroop))
			SetLog("Deployment of " & $NumTroopDeployed & " " & $name & " was Successful!")
			If _Sleep($Sleep) Then Return
		Else
			SetLog("Deployment of " & $name & " wasn't Successful!")
		EndIf
	EndIf

	If $troopKind >= $eKing And $troopKind <= $eCastle Then
		SelectDropTroop(0)
		If _Sleep($Sleep) Then Return
	EndIf


EndFunc   ;==>AttackTHGrid

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;; TH Deploy Types ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


Func DeployTHNormal($iAtEachSpot, $iNbOfSpots)

	Switch $THside
		Case 0 ;UL
			For $num = 0 To $iAtEachSpot - 1
				For $i = $THi - 1 To $THi - 1 + Ceiling(($iNbOfSpots - 1) / 2)
					$aThx = 25 - $i * 19
					$aThy = 314 + $i * 14
				Next

				For $ii = $THi - 1 To $THi - 1 + ($iNbOfSpots - 1)
					$aThx = 25 + $ii * 19
					$aThy = 314 - $ii * 14
					If CheckOneStar(0, False, False) Then Return
					If IsAttackPage() Then Click(Random($aThx - 5, $aThx + 5, 1), Random($aThy - 5, $aThy + 5, 1), 1, 0, "#0019")
					If _Sleep(Random(20, 40,1)) Then Return
				Next
			Next
		Case 1 ;LL
			For $num = 0 To $iAtEachSpot - 1
				For $i = $THi To $THi + Ceiling(($iNbOfSpots - 1) / 2)
					$aThx = 25 - $i * 19
					$aThy = 314 - $i * 14
				Next

				For $ii = $THi To $THi + ($iNbOfSpots - 1)
					$aThx = 25 + $ii * 19
					$aThy = 314 + $ii * 14
					If CheckOneStar(0, False, False) Then Return
					If IsAttackPage() Then Click(Random($aThx - 5, $aThx + 5, 1), Random($aThy - 5, $aThy + 5, 1), 1, 0, "#0020")
					If _Sleep(Random(20, 40,1)) Then Return
				Next
			Next
		Case 2 ;UR
			For $num = 0 To $iAtEachSpot - 1
				For $i = $THi To $THi + Ceiling(($iNbOfSpots - 1) / 2)
					$aThx = 830 + $i * 19
					$aThy = 314 + $i * 14
				Next

				For $ii = $THi To $THi + ($iNbOfSpots - 1)
					$aThx = 830 - $ii * 19
					$aThy = 314 - $ii * 14
					If CheckOneStar(0, False, False) Then Return
					If IsAttackPage() Then Click(Random($aThx - 5, $aThx + 5, 1), Random($aThy - 5, $aThy + 5, 1), 1, 0, "#0021")
					If _Sleep(Random(20, 40,1)) Then Return
				Next
			Next
		Case 3 ;LR
			For $num = 0 To $iAtEachSpot - 1
				For $i = $THi + 1 To $THi + 1 + Ceiling(($iNbOfSpots - 1) / 2)
					$aThx = 830 + $i * 19
					$aThy = 314 - $i * 14
				Next

				For $ii = $THi + 1 To $THi + 1 + ($iNbOfSpots - 1)
					$aThx = 830 - $ii * 19
					$aThy = 314 + $ii * 14
					If CheckOneStar(0, False, False) Then Return
					If IsAttackPage() Then Click(Random($aThx - 5, $aThx + 5, 1), Random($aThy - 5, $aThy + 5, 1), 1, 0, "#0022")
					If _Sleep(Random(20, 40,1)) Then Return
				Next
			Next
	EndSwitch

EndFunc   ;==>DeployTHNormal

;~ Func SwitchDeployBtmTH($iAtEachSpot, $iNbOfSpots)

;~ 	Switch ($icmbDeployBtmTHType + 1)
;~ 		Case 1
;~ 			DeployBtmTHFewZooms($iAtEachSpot, $iNbOfSpots)
;~ 		Case 2
;~ 			DeployBtmTHOnSides($iAtEachSpot, $iNbOfSpots)
;~ 	EndSwitch

;~ EndFunc   ;==>SwitchDeployBtmTH

;~ Func DeployBtmTHFewZooms($iAtEachSpot, $iNbOfSpots)
;~ 	Opt("SendKeyDownDelay", 50)

;~ 	;;;;;;;;;;;;; Few zooming and Scrolling to The Bottom ;;;;;;;;;;;;;;;;;;;;;;;
;~ 	If ($THside = 1 Or $THside = 3) And $zoomedin = False Then
;~ 		SetLog("Zooming in a little and scrolling to bottom ...")

;~ 		While $zCount < 2 And $sCount < 2
;~ 			ControlSend($Title, "", "", "{UP}")
;~ 			If _Sleep(300) Then Return
;~ 			ControlSend($Title, "", "", "{CTRLDOWN}{UP}{CTRLUP}")
;~ 			If _Sleep(400) Then Return
;~ 			$zCount += 1
;~ 			$sCount += 1
;~ 		WEnd

;~ 		ControlSend($Title, "", "", "{CTRLDOWN}{UP}{CTRLUP}")


;~ 		If $debugSetlog = 1 Then SetLog("Done zooming and Scrolling.")
;~ 		If _Sleep(5000) Then Return
;~ 		$zoomedin = True
;~ 	EndIf
;~ 	;;;;;;;;;;;;; End zooming and scrolling to The Bottom ;;;;;;;;;;;;;;;;;;;;;;;

;~ 	;;;;;;;;;;;;; Deploying Troops ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;~ 	If $THi = 17 And $Thx > 400 And $Thx < 455 And $Thy > 450 And $Thy < 580 Then

;~ 		If $debugSetlog = 1 Then Setlog("Center Bottom deployment THi = " & $THi & " ,x = " & $Thx & " ,y = " & $Thy)
;~ 		For $count = 1 To $iAtEachSpot * $iNbOfSpots
;~ 			If CheckOneStar(0, False, False) Then Return
;~ 			If IsAttackPage() Then Click(Random(480, 540, 1), Random(564, 566, 1))
;~ 			If _Sleep(Random(20, 40,1)) Then Return
;~ 		Next

;~ 	Else
;~ 		If $THside = 1 Then
;~ 			If $debugSetlog = 1 Then Setlog("Left Bottom deployment THi = " & $THi & " ,x = " & $Thx & " ,y = " & $Thy)
;~ 			For $count = 1 To $iAtEachSpot * $iNbOfSpots
;~ 				If CheckOneStar(0, False, False) Then Return
;~ 				If IsAttackPage() Then Click(Random(310, 340, 1), Random(564, 566, 1), 1, 0, "#0022")
;~ 				If _Sleep(Random(20, 40,1)) Then Return
;~ 			Next
;~ 		EndIf

;~ 		If $THside = 3 Then
;~ 			If $debugSetlog = 1 Then Setlog("Right Bottom deployment THi = " & $THi & " ,x = " & $Thx & " ,y = " & $Thy)
;~ 			For $count = 1 To $iAtEachSpot * $iNbOfSpots
;~ 				If CheckOneStar(0, False, False) Then Return
;~ 				If IsAttackPage() Then Click(Random(510, 580, 1), Random(564, 566, 1), 1, 0, "#0022")
;~ 				If _Sleep(Random(20, 40,1)) Then Return
;~ 			Next

;~ 		EndIf

;~ 	EndIf
;~  Opt("SendKeyDownDelay", 5)
;~ EndFunc   ;==>DeployBtmTHFewZooms

;~ Func DeployBtmTHOnSides($iAtEachSpot, $iNbOfSpots)

;~ 	; No Zoom used in this attack
;~ 	Local $i = 0

;~ 	If $THi = 17 And $Thx > 400 And $Thx < 455 And $Thy > 450 And $Thy < 580 Then

;~ 		If $debugSetlog = 1 Then Setlog("Center Bottom deployment THi = " & $THi & " ,x = " & $Thx & " ,y = " & $Thy)
;~ 		For $count = 1 To $iAtEachSpot * $iNbOfSpots
;~ 			If $i = 0 Then
;~ 				If CheckOneStar(0, False, False) Then Return
;~ 				If IsAttackPage() Then Click(Random(355, 365, 1), Random(564, 566, 1))
;~ 				$i = 1
;~ 			Else
;~ 				If CheckOneStar(0, False, False) Then Return
;~ 				If IsAttackPage() Then Click(Random(488, 500, 1), Random(564, 566, 1))
;~ 				$i = 0
;~ 			EndIf
;~ 			If _Sleep(Random(20, 40,1)) Then Return
;~ 		Next

;~ 	Else

;~ 		If $THside = 1 Then
;~ 			If $debugSetlog = 1 Then Setlog("Left Bottom deployment THi = " & $THi & " ,x = " & $Thx & " ,y = " & $Thy)
;~ 			For $count = 1 To $iAtEachSpot * $iNbOfSpots
;~ 				If CheckOneStar(0, False, False) Then Return
;~ 				If IsAttackPage() Then Click(Random(310, 340, 1), Random(564, 566, 1), 1, 0, "#0022")
;~ 				If _Sleep(Random(20, 40,1)) Then Return
;~ 			Next
;~ 		EndIf

;~ 		If $THside = 3 Then
;~ 			If $debugSetlog = 1 Then Setlog("Right Bottom deployment THi = " & $THi & " ,x = " & $Thx & " ,y = " & $Thy)
;~ 			For $count = 1 To $iAtEachSpot * $iNbOfSpots
;~ 				If CheckOneStar(0, False, False) Then Return
;~ 				If IsAttackPage() Then Click(Random(510, 540, 1), Random(564, 566, 1), 1, 0, "#0022")
;~ 				If _Sleep(Random(20, 40,1)) Then Return
;~ 			Next
;~ 		EndIf

;~ 	EndIf

;~ EndFunc   ;==>DeployBtmTHOnSides

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Func SpellTHGrid($S)

	If ($S = $eHSpell And $ichkUseHSpellsTH = 1) Or ($S = $eLSpell And $ichkUseLSpellsTH = 1) Or ($S = $eRSpell And $ichkUseRSpellsTH = 1) Then

		If _Sleep(10) Then Return
		If $Restart = True Then Return
		If CheckOneStar(0, False, True) Then Return

		If $THi <= 15 Or $THside = 0 Or $THside = 2 Then
			Switch $THside
				Case 0
					CastSpell($S, 114 + $THi * 19 + Ceiling(-2 * 19), 359 - $THi * 14 + Ceiling(-2 * 14))
				Case 1
					CastSpell($S, 117 + $THi * 19 + Ceiling(-2 * 19), 268 + $THi * 14 - Floor(-2 * 14))
				Case 2
					CastSpell($S, 743 - $THi * 19 - Floor(-2 * 19), 358 - $THi * 14 + Ceiling(-2 * 14))
				Case 3
					CastSpell($S, 742 - $THi * 19 - Floor(-2 * 19), 268 + $THi * 14 - Floor(-2 * 14))
			EndSwitch
		EndIf

		If $THi > 15 And ($THside = 1 Or $THside = 3) Then
			CastSpell($S, $THx, $THy)
		EndIf

	EndIf

EndFunc   ;==>SpellTHGrid

Func CastSpell($THSpell, $x, $y)

	Local $Spell = -1
	Local $name = ""

	If ($THSpell = $eHSpell And $ichkUseHSpellsTH = 1) Or ($THSpell = $eLSpell And $ichkUseLSpellsTH = 1) Or ($THSpell = $eRSpell And $ichkUseRSpellsTH = 1) Then

		If _Sleep(10) Then Return
		If $Restart = True Then Return
		If CheckOneStar(0, False, True) Then Return

		For $i = 0 To UBound($atkTroops) - 1
			If $atkTroops[$i][0] = $THSpell Then
				$Spell = $i
				$name = NameOfTroop($THSpell, 0)
			EndIf
		Next

		;If ($Spell = -1) Then Return False
		If $Spell > -1 Then
			SetLog("Dropping " & $name)
			SelectDropTroop($Spell)
			If _Sleep($iDelayCastSpell1) Then Return
			If IsAttackPage() Then Click($x, $y, 1, 0, "#0029")
		Else
			If $debugSetlog = 1 Then SetLog("No " & $name & " Found")
		EndIf

	EndIf

EndFunc   ;==>CastSpell

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Func CheckOneStar($DelayInSec = 0, $Log = True, $CheckHeroes = True)

	For $i = 0 To $DelayInSec

		If _Sleep(5) Then Return True
		If $Restart = True Then Return True
		If $CheckHeroes = True And ($checkQPower = True Or $checkKPower = True) Then CheckHeroesHealth() ;Check Heroes Health and activate their abilities if health is not green
		;check for one star
		If _ColorCheck(_GetPixelColor($aWonOneStar[0], $aWonOneStar[1], True), Hex($aWonOneStar[2], 6), $aWonOneStar[3]) Then ;exit if 1 star
			If $Log = True Then SetLog("Townhall has been destroyed!", $COLOR_ORANGE)
			If $Restart = True Then Return True

			;Activate King and Queen powers to restore health before exit if they are deployed

			If $checkQPower = True Then
				SetLog("Activating Queen's power to restore some health before EndBattle", $COLOR_BLUE)
				SelectDropTroop($Queen)
				$checkQPower = False
			EndIf

			If _Sleep(500) Then Return True
			If $Restart = True Then Return True

			If $checkKPower = True Then
				SetLog("Activating King's power to restore some health before EndBattle", $COLOR_BLUE)
				SelectDropTroop($King)
				$checkKPower = False
			EndIf

			If $Log = True Then
				If _Sleep(1000) Then Return ;wait 1 seconds... antiban purpose...
			EndIf

			Return True ;exit if you get a star

		Else

			If $i <> 0 Then
				If _Sleep(1000) Then Return True
				If $Restart = True Then Return True
			EndIf

		EndIf
		;end check for one star

	Next

	Return False ; Continue

EndFunc   ;==>CheckOneStar

