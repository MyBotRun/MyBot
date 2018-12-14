; #FUNCTION# ==========================================================
; Name ..........: algorithmTH
; Description ...: This file contens the attack algorithm TH and Lspell
; Syntax ........: algorithmTH() , AttackTHGrid() , AttackTHNormal() , AttackTHXtreme() , LLDropheroes() , SpellTHGrid() , CastSpell()
; Parameters ....: None
; Return values .: None
; Author ........: AtoZ (2015)
; Modified ......: Barracoda (07-2015), TheMaster1st (10-2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
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

	$g_iSidesAttack = 1

	Local $aThx, $aThy, $num
	Local $TroopCountBeg
	Local $THtroop = -1
	Local $troopNb = 0
	Local $name = ""
	Local $plural = 0
	Local $waveName = "first"
	Local $NumTroopDeployed = 0

	If _Sleep(5) Then Return
	If $g_bRestart = True Then Return
	If CheckOneStar(0, False, True) Then Return

	For $i = 0 To UBound($g_avAttackTroops) - 1
		If $g_avAttackTroops[$i][0] = $troopKind Then
			$THtroop = $i
		EndIf
	Next

	If ($THtroop = -1) And $g_bDebugSetlog Then SetLog("No " & $name & " Found!!!")
	If ($THtroop = -1) Then Return False

	;Heroes And CC
	If $troopKind >= $eKing And $troopKind <= $eCastle Then
		$iNbOfSpots = 1
		$iAtEachSpot = 1
		$troopNb = 1

		;King
		If $troopKind = $eKing Then
			If $g_bDuringMilkingAttack = False And BitAND($g_aiAttackUseHeroes[$TS], $eHeroKing) <> $eHeroKing Then Return
			If $g_bDuringMilkingAttack = True And BitAND($g_aiAttackUseHeroes[$DB], $eHeroKing) <> $eHeroKing Then Return
			$g_bCheckKingPower = True
			SetLog("Dropping King", $COLOR_SUCCESS)
			$g_bTHSnipeUsedKing = True
		EndIf

		;Queen
		If $troopKind = $eQueen Then
			If $g_bDuringMilkingAttack = False And BitAND($g_aiAttackUseHeroes[$TS], $eHeroQueen) <> $eHeroQueen Then Return
			If $g_bDuringMilkingAttack = True And BitAND($g_aiAttackUseHeroes[$DB], $eHeroQueen) <> $eHeroQueen Then Return
			$g_bCheckQueenPower = True
			SetLog("Dropping Queen", $COLOR_SUCCESS)
			$g_bTHSnipeUsedQueen = True
		EndIf

		;Warden
		If $troopKind = $eWarden Then
			If $g_bDuringMilkingAttack = False And BitAND($g_aiAttackUseHeroes[$TS], $eHeroWarden) <> $eHeroWarden Then Return
			If $g_bDuringMilkingAttack = True And BitAND($g_aiAttackUseHeroes[$DB], $eHeroWarden) <> $eHeroWarden Then Return
			$g_bCheckWardenPower = True
			SetLog("Dropping Grand Warden", $COLOR_SUCCESS)
			$g_bTHSnipeUsedWarden = True
		EndIf

		;CC
		If $troopKind = $eCastle Then
			If $g_bDuringMilkingAttack = False And $g_abAttackDropCC[$TS] Then Return
			If $g_bDuringMilkingAttack = True And $g_abAttackDropCC[$DB] Then Return

			If $g_bPlannedDropCCHoursEnable = True Then
				Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
				If $g_abPlannedDropCCHours[$hour[0]] = False Then
					SetLog("Drop Clan Castle not Planned, Skipped..", $COLOR_SUCCESS)
					Return ; exit func if no planned donate checkmarks
				EndIf
			EndIf

			If $g_bUseCCBalanced = True Then
				If Number($g_iTroopsReceived) <> 0 Then
					If Number(Number($g_iTroopsDonated) / Number($g_iTroopsReceived)) >= (Number($g_iCCDonated) / Number($g_iCCReceived)) Then
						SetLog("Dropping Clan Castle, donated (" & $g_iTroopsDonated & ") / received (" & $g_iTroopsReceived & ") >= " & $g_iCCDonated & "/" & $g_iCCReceived, $COLOR_INFO)
					Else
						SetLog("Not Dropping Clan Castle, donated  (" & $g_iTroopsDonated & ") / received (" & $g_iTroopsReceived & ") < " & $g_iCCDonated & "/" & $g_iCCReceived, $COLOR_INFO)
						Return
					EndIf
				Else
					If Number(Number($g_iTroopsDonated) / 1) >= (Number($g_iCCDonated) / Number($g_iCCReceived)) Then
						SetLog("Dropping Clan Castle, donated (" & $g_iTroopsDonated & ") / received (" & $g_iTroopsReceived & ") >= " & $g_iCCDonated & "/" & $g_iCCReceived, $COLOR_INFO)
					Else
						SetLog("Not Dropping Clan Castle, donated  (" & $g_iTroopsDonated & ") / received (" & $g_iTroopsReceived & ") < " & $g_iCCDonated & "/" & $g_iCCReceived, $COLOR_INFO)
						Return
					EndIf
				EndIf
			EndIf
		EndIf
		;End CC

	EndIf

	; All Barracks Troops
	If $troopKind >= $eBarb And $troopKind <= $eIceG Then
		$troopNb = $iNbOfSpots * $iAtEachSpot
		If $troopNb > 1 Then $plural = 1
		$name = NameOfTroop($troopKind, $plural)

		$TroopCountBeg = Number(ReadTroopQuantity($THtroop))
		If ($TroopCountBeg = 0) And $g_bDebugSetlog Then SetLog("No " & $name & " Remaining!!!")
		If ($TroopCountBeg = 0) Then Return False

		If $waveNb = 0 Then $waveName = "Only"
		If $waveNb = 1 Then $waveName = "First"
		If $waveNb = 2 Then $waveName = "Second"
		If $waveNb = 3 Then $waveName = "Third"
		If $waveNb = 4 Then $waveName = "Last"
		SetLog("Dropping " & $waveName & " wave of " & $troopNb & " " & $name, $COLOR_SUCCESS)
	EndIf
	;End All Barracks Troops

	SelectDropTroop($THtroop) ;Select Troop to be Droped

	If _Sleep($DELAYCASTSPELL1) Then Return

	DeployTHNormal($iAtEachSpot, $iNbOfSpots)

	If $troopKind >= $eBarb And $troopKind <= $eIceG Then
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
	Local $aThx = 0, $aThy = 0
	Switch $g_iTHside
		Case 0 ;UL
			For $num = 0 To $iAtEachSpot - 1
				For $i = $g_iTHi - 1 To $g_iTHi - 1 + Ceiling(($iNbOfSpots - 1) / 2)
					$aThx = 25 - $i * 16
					$aThy = 314 + $i * 12
				Next

				For $ii = $g_iTHi - 1 To $g_iTHi - 1 + ($iNbOfSpots - 1)
					$aThx = 25 + $ii * 16
					$aThy = 314 - $ii * 12
					If CheckOneStar(0, False, False) Then Return
					If IsAttackPage() Then Click(Random($aThx - 5, $aThx + 5, 1), Random($aThy - 5, $aThy + 5, 1), 1, 0, "#0019")
					If _Sleep(Random(20, 40, 1)) Then Return
				Next
			Next
		Case 1 ;LL
			For $num = 0 To $iAtEachSpot - 1
				For $i = $g_iTHi To $g_iTHi + Ceiling(($iNbOfSpots - 1) / 2)
					$aThx = 25 - $i * 16
					$aThy = 314 - $i * 12
				Next

				For $ii = $g_iTHi To $g_iTHi + ($iNbOfSpots - 1)
					$aThx = 25 + $ii * 16
					$aThy = 314 + $ii * 12
					If CheckOneStar(0, False, False) Then Return
					If IsAttackPage() Then Click(Random($aThx - 5, $aThx + 5, 1), Random($aThy - 5, $aThy + 5, 1), 1, 0, "#0020")
					If _Sleep(Random(20, 40, 1)) Then Return
				Next
			Next
		Case 2 ;UR
			For $num = 0 To $iAtEachSpot - 1
				For $i = $g_iTHi To $g_iTHi + Ceiling(($iNbOfSpots - 1) / 2)
					$aThx = 830 + $i * 16
					$aThy = 314 + $i * 12
				Next

				For $ii = $g_iTHi To $g_iTHi + ($iNbOfSpots - 1)
					$aThx = 830 - $ii * 16
					$aThy = 314 - $ii * 12
					If CheckOneStar(0, False, False) Then Return
					If IsAttackPage() Then Click(Random($aThx - 5, $aThx + 5, 1), Random($aThy - 5, $aThy + 5, 1), 1, 0, "#0021")
					If _Sleep(Random(20, 40, 1)) Then Return
				Next
			Next
		Case 3 ;LR
			For $num = 0 To $iAtEachSpot - 1
				For $i = $g_iTHi + 1 To $g_iTHi + 1 + Ceiling(($iNbOfSpots - 1) / 2)
					$aThx = 830 + $i * 16
					$aThy = 314 - $i * 12
				Next

				For $ii = $g_iTHi + 1 To $g_iTHi + 1 + ($iNbOfSpots - 1)
					$aThx = 830 - $ii * 16
					$aThy = 314 + $ii * 12
					If CheckOneStar(0, False, False) Then Return
					If IsAttackPage() Then Click(Random($aThx - 5, $aThx + 5, 1), Random($aThy - 5, $aThy + 5, 1), 1, 0, "#0022")
					If _Sleep(Random(20, 40, 1)) Then Return
				Next
			Next
	EndSwitch

EndFunc   ;==>DeployTHNormal

Func SpellTHGrid($S)

	If $g_bDuringMilkingAttack = False And (($S = $eHSpell And $g_abAttackUseHealSpell[$TS]) Or _
			($S = $eLSpell And $g_abAttackUseLightSpell[$TS]) Or _
			($S = $eRSpell And $g_abAttackUseRageSpell[$TS]) Or _
			($S = $eJSpell And $g_abAttackUseJumpSpell[$TS]) Or _
			($S = $eFSpell And $g_abAttackUseFreezeSpell[$TS]) Or _
			($S = $ePSpell And $g_abAttackUsePoisonSpell[$TS]) Or _
			($S = $eHaSpell And $g_abAttackUseHasteSpell[$TS]) Or _
			($S = $eESpell And $g_abAttackUseEarthquakeSpell[$TS])) Or _
			$g_bDuringMilkingAttack = True And (($S = $eHSpell And $g_abAttackUseHealSpell[$DB]) Or _
			($S = $eLSpell And $g_abAttackUseLightSpell[$DB]) Or _
			($S = $eRSpell And $g_abAttackUseRageSpell[$DB]) Or _
			($S = $eJSpell And $g_abAttackUseJumpSpell[$DB]) Or _
			($S = $eFSpell And $g_abAttackUseFreezeSpell[$DB]) Or _
			($S = $ePSpell And $g_abAttackUsePoisonSpell[$DB]) Or _
			($S = $eHaSpell And $g_abAttackUseHasteSpell[$DB]) Or _
			($S = $eESpell And $g_abAttackUseEarthquakeSpell[$DB])) Then

		If _Sleep(10) Then Return
		If $g_bRestart = True Then Return
		If CheckOneStar(0, False, True) Then Return

		If $g_iTHi <= 15 Or $g_iTHside = 0 Or $g_iTHside = 2 Then
			Switch $g_iTHside
				Case 0
					CastSpell($S, 114 + $g_iTHi * 16 + Ceiling(-2 * 16), 359 - $g_iTHi * 12 + Ceiling(-2 * 12))
				Case 1
					CastSpell($S, 117 + $g_iTHi * 16 + Ceiling(-2 * 16), 268 + $g_iTHi * 12 - Floor(-2 * 12))
				Case 2
					CastSpell($S, 743 - $g_iTHi * 16 - Floor(-2 * 16), 358 - $g_iTHi * 12 + Ceiling(-2 * 12))
				Case 3
					CastSpell($S, 742 - $g_iTHi * 16 - Floor(-2 * 16), 268 + $g_iTHi * 12 - Floor(-2 * 12))
			EndSwitch
		EndIf

		If $g_iTHi > 15 And ($g_iTHside = 1 Or $g_iTHside = 3) Then
			CastSpell($S, $g_iTHx, $g_iTHy)
		EndIf

	EndIf

EndFunc   ;==>SpellTHGrid

Func CastSpell($THSpell, $x, $y)

	Local $Spell = -1
	Local $name = ""

	If _Sleep(10) Then Return
	If $g_bRestart = True Then Return
	If CheckOneStar(0, False, True) Then Return

	For $i = 0 To UBound($g_avAttackTroops) - 1
		If $g_avAttackTroops[$i][0] = $THSpell Then
			$Spell = $i
			$name = NameOfTroop($THSpell, 0)
		EndIf
	Next

	If $Spell > -1 Then
		SetLog("Dropping " & $name)
		SelectDropTroop($Spell)
		If _Sleep($DELAYATTCKTHGRID1) Then Return
		If IsAttackPage() Then Click($x, $y, 1, 0, "#0029")
	Else
		If $g_bDebugSetlog Then SetDebugLog("No " & $name & " Found")
	EndIf

EndFunc   ;==>CastSpell

Func CheckOneStar($DelayInSec = 0, $Log = True, $CheckHeroes = True)

	For $i = 0 To $DelayInSec

		If _Sleep(5) Then Return True
		If $g_bRestart = True Then Return True
		If $CheckHeroes = True And ($g_bCheckQueenPower = True Or $g_bCheckKingPower = True) Then CheckHeroesHealth() ;Check Heroes Health and activate their abilities if health is not green
		;check for one star
		If _ColorCheck(_GetPixelColor($aWonOneStar[0], $aWonOneStar[1], True), Hex($aWonOneStar[2], 6), $aWonOneStar[3]) Then ;exit if 1 star
			If $Log = True Then SetLog("Townhall has been destroyed!", $COLOR_ACTION)
			If $g_bRestart = True Then Return True

			;Activate King and Queen powers to restore health before exit if they are deployed

			If $g_bCheckQueenPower = True Then
				SetLog("Activating Queen's power to restore some health before EndBattle", $COLOR_INFO)
				SelectDropTroop($g_iQueenSlot)
				$g_bCheckQueenPower = False
			EndIf

			If _Sleep(500) Then Return True
			If $g_bRestart = True Then Return True

			If $g_bCheckKingPower = True Then
				SetLog("Activating King's power to restore some health before EndBattle", $COLOR_INFO)
				SelectDropTroop($g_iKingSlot)
				$g_bCheckKingPower = False
			EndIf

			If $Log = True Then
				If _Sleep(1000) Then Return ;wait 1 seconds... antiban purpose...
			EndIf

			Return True ;exit if you get a star

		Else

			If $i <> 0 Then
				If _Sleep(1000) Then Return True
				If $g_bRestart = True Then Return True
			EndIf

		EndIf
		;end check for one star

	Next

	Return False ; Continue

EndFunc   ;==>CheckOneStar

