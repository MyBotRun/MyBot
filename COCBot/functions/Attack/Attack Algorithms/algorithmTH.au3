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
			If $duringMilkingAttack = 0 and $KingAttack[$TS] = 0 Then Return
			If $duringMilkingAttack = 1 and $KingAttack[$DB] = 0 Then Return
			$checkKPower = True
			SetLog("Dropping King", $COLOR_GREEN)
			$THusedKing = 1
		EndIf

		;Queen
		If $troopKind = $eQueen Then
			If $duringMilkingAttack = 0 and $QueenAttack[$TS] = 0 Then Return
			If $duringMilkingAttack = 1 and $QueenAttack[$DB] = 0 Then Return
			$checkQPower = True
			SetLog("Dropping Queen", $COLOR_GREEN)
			$THusedQueen = 1
		EndIf

		;Warden
		If $troopKind = $eWarden Then
			If  $duringMilkingAttack = 0 and $WardenAttack[$TS] = 0 Then Return
			If $duringMilkingAttack = 1 and $WardenAttack[$DB] = 0 Then Return
			$checkWPower = True
			SetLog("Dropping Grand Warden", $COLOR_GREEN)
			$THusedWarden = 1
		EndIf

		;CC
		If $troopKind = $eCastle Then
			If $duringMilkingAttack = 0 and $iDropCC[$TS] = 0 Then Return
			If $duringMilkingAttack = 1 and $iDropCC[$DB] = 0 Then Return

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
					If _Sleep(Random(20, 40, 1)) Then Return
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
					If _Sleep(Random(20, 40, 1)) Then Return
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
					If _Sleep(Random(20, 40, 1)) Then Return
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
					If _Sleep(Random(20, 40, 1)) Then Return
				Next
			Next
	EndSwitch

EndFunc   ;==>DeployTHNormal

Func SpellTHGrid($S)


	If 	$duringMilkingAttack = 0 and ( ($S = $eHSpell And $ichkHealSpell[$TS] = 1) Or ($S = $eLSpell And $ichkLightSpell[$TS] = 1) Or ($S = $eRSpell And $ichkRageSpell[$TS] = 1) Or ($S = $eJSpell And $ichkJumpSpell[$TS] = 1) Or ($S = $eFSpell And $ichkFreezeSpell[$TS] = 1) Or ($S = $ePSpell And $ichkPoisonSpell[$TS] = 1) Or ($S = $eHaSpell And $ichkHasteSpell[$TS] = 1) Or ($S = $eESpell And $ichkEarthquakeSpell[$TS] = 1)) or _
		$duringMilkingAttack = 1 and ( ($S = $eHSpell And $ichkHealSpell[$DB] = 1) Or ($S = $eLSpell And $ichkLightSpell[$DB] = 1) Or ($S = $eRSpell And $ichkRageSpell[$DB] = 1) Or ($S = $eJSpell And $ichkJumpSpell[$DB] = 1) Or ($S = $eFSpell And $ichkFreezeSpell[$DB] = 1) Or ($S = $ePSpell And $ichkPoisonSpell[$DB] = 1) Or ($S = $eHaSpell And $ichkHasteSpell[$DB] = 1) Or ($S = $eESpell And $ichkEarthquakeSpell[$DB] = 1)) _
		Then

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

