; #FUNCTION# ====================================================================================================================
; Name ..........:Algorithm_MilkingAttack.au3
; Description ...:Attacks a base with the Milking Algorithm
; Syntax ........:Algorithm_MilkingAttack()
; Parameters ....:None
; Return values .:None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: Noo
; ===============================================================================================================================

Func Alogrithm_MilkingAttack()

	;--- TH snipe After Milking...
	If $THSnipeBeforeDBEnable = 1 and $searchTH = "-" Then FindTownHall(True) ; if no previous detect search townhall
	If $THSnipeBeforeDBEnable = 1 Then
		If $searchTH <> "-" Then
			If 	SearchTownHallLoc()  Then
				Setlog(_PadStringCenter(" TH snipe Before Milking ", 54,"="),$color_blue)
				$THusedKing = 0
				$THusedQueen = 0
				AttackTHParseCSV()
			Else
				Setlog("TH snipe Before Milking skip, TH inside village",$color_blue)
			EndIf
		Else
			Setlog("TH snipe Before Milking skip, no th detected",$color_blue)
		EndIf
	EndIf
	;---


	$duringMilkingAttack = 1
	;*** MAIN PROCEDURE ***
	Local $hTimerTOTAL = TimerInit()

	;villagesearch detect before with these functions
	;- MilkingDetectRedArea()
	;- MilkingDetectElixirExtractors()
	;- MilkingDetectMineMatch()
	;- MilkingDetectDarkExtractors()
	;fill $MilkFarmObjectivesSTR with objectives to attack.

	;06 - Make Debug Image...
	;MilkFarmDebugImage( $MilkFarmAtkPixelListMINESTR,$MilkFarmAtkPixelListSTR, $MilkFarmAtkPixelListDrillSTR)

	;If $MilkAttackAfterScriptedAtk = 1 Then SmartAttackStrategy($MA)

	Setlog(_PadStringCenter(" Milking Attack ", 54,"="),$color_blue)

	;07 - Attack  Resources -----------------------------------------------------------------------------------------------------------------------
	If StringLen($MilkFarmObjectivesSTR) > 0 Then
		Local $vect = StringSplit($MilkFarmObjectivesSTR, "|", 2)
		If $debugsetlog = 1 Then Setlog("MilkFarmObjectivesSTR = <" & $MilkFarmObjectivesSTR & ">.. UBOUND=" & UBound($vect))
		If UBound($vect) > 0 Then
			If StringLen($vect[0]) > 0 Then
				If $debugsetlog = 1 Then SetLog(">Structures to attack: (" & UBound($vect) & ")", $color_purple)
				For $i = 0 To UBound($vect) - 1
					If $debugsetlog = 1 Then Setlog("> " & $i & " " & $vect[$i], $color_purple)
				Next
				MilkFarmObjectivesDebugImage($MilkFarmObjectivesSTR, 0)
				Local $troopPosition = -1
				For $i = 0 To UBound($atkTroops) - 1
					If $atkTroops[$i][1] <> -1 Then ;if not empty
						If $atkTroops[$i][0] = $eGobl Then
							If $debugsetlog = 1 Then SetLog("-*-" & $atkTroops[$i][0] & " " & NameOfTroop($atkTroops[$i][0]) & " " & $atkTroops[$i][1] & " <<---" & $eGobl, $COLOR_GREEN)
							$troopPosition = $i
						Else
							If $debugsetlog = 1 Then SetLog("-*-" & $atkTroops[$i][0] & " " & NameOfTroop($atkTroops[$i][0]) & " " & $atkTroops[$i][1] & "", $COLOR_GRAY)
						EndIf
					EndIf
				Next
				If $troopPosition >= 0 Then
					SelectDropTroop($troopPosition) ; select the troop...

					If UBound($vect) > 2 Then
						Switch $MilkingAttackStructureOrder
							Case 1 ;RANDOM
								Local $rnd = _RandomUnique(UBound($vect) - 1, 0, UBound($vect) - 2, 1) ;make a random list of structure to attack
								For $i = 0 To UBound($rnd) - 1
									If $debugsetlog = 1 Then Setlog("random vect pos " & $i & " value " & $rnd[$i],$color_purple)
								Next
							Case 2 ; ORDERED BY SIDE
								Local $rnd = _OrderBySideObjectives($vect)
								For $i = 0 To UBound($rnd) - 1
									If $debugsetlog = 1 Then Setlog("order by side vect pos " & $i & " value " & $rnd[$i],$color_purple)
								Next
							Case else ; AS FOUND
								Local $tmpstr = ""
								For $k=0 To UBound($vect) -1
									$tmpstr &= $k &"-"
								Next
								$tmpstr=StringLeft($tmpStr,StringLen($tmpstr)-1)
								Local $rnd = StringSplit($tmpStr,"-",2)
								For $i = 0 To UBound($rnd) - 1
									If $debugsetlog = 1 Then Setlog("as found vect pos " & $i & " value " & $rnd[$i],$color_purple)
								Next
						EndSwitch

						;Msgbox("","","start attack (" &  UBound($rnd) & ")")
						For $i = 0 To UBound($rnd) - 1
							;Msgbox("","", "attack structure n. " &$i)
							Local $vect2 = StringSplit($vect[$i], ".", 2)
							If UBound($vect2) > 1 Then
								If $debugsetlog = 1 Then Setlog($i & "- Attack structure n. " & $rnd[$i] +1 & "/" & UBound($vect) & " - " & $vect2[0], $color_purple)
								If UBound($vect) > $rnd[$i] Then
									MilkingAttackStructure($vect[$rnd[$i]])
								Else
									If $debugsetlog = 1 Then Setlog($i & " range exceeded of $vect!")
								EndIf
							Else
								If $debugsetlog = 1 Then Setlog("Error @18")
							EndIf
						Next
					EndIf

					If UBound($vect) = 2 Then
						For $i = 0 To 1
							;Msgbox("","", "attack structure n. " &$i)
							If $debugsetlog = 1 Then Setlog($i & "- Attack structure n. " & $i & "/1 ", $color_purple)
							MilkingAttackStructure($vect[$i])
						Next
					EndIf

					If UBound($vect) = 1 Then
						If $debugsetlog = 1 Then Setlog($i & "- Attack structure n. 0/0 ", $color_purple)
						MilkingAttackStructure($vect[0])
					EndIf
				Else
					If $debugsetlog = 1 Then Setlog("No Goblins left ")
				EndIf
			Else
				If $debugsetlog = 1 Then Setlog("No structures to attack...")
			EndIf
		Else
			If $debugsetlog = 1 Then Setlog("No structures to attack..")
		EndIf
	Else
		Setlog("No structures to attack, skip attack structures!")
	EndIf

	; at end of milking attack check if bot continue to attack TH snipe and/or standard attack
	If $MilkAttackAfterTHSnipe = 1 Then
			; TH snipe attack selected, if no th found before, search enemy TH location
			;a check th position
			FindTownHall(True) ;force search townhall bacause we have possibility to allready destroyed

			;b check th outside
			If $searchTH <>"-" Then
				If SearchTownHallLoc() Then  ;check if townhall position it is outside
					$iMatchMode = $TS
					Setlog(_PadStringCenter(" Attack TH snipe after Milking Attack ", 54,"="),$color_blue)
					;if, after TH snipe, we have standard attack, need to detect the positions of special troops (king, queen, warden)
					If $MilkAttackAfterScriptedAtk = 0 Then
						PrepareAttack($iMatchMode, True)
						algorithm_AllTroops() ;algorithm alltroops with $iMatchMode = $TS launch TH Snipe
					Else
						SetSlotSpecialTroops()
						$THusedKing = 0
						$THusedQueen = 0
						AttackTHParseCSV()
					EndIf
				Else
					Setlog("TH it is not outside, skip attack", $color_blue)
				EndIf

			Else
				Setlog("Cannot detect Townhall, skip THsnipe after Milking", $color_blue)
			EndIf
	EndIf
	If $MilkAttackAfterScriptedAtk = 1 Then
		Setlog(_PadStringCenter("Scripted Attack after Miliking ", 54,"="),$color_blue)
		Algorithm_AttackCSV(False,False) ;launch algorithm without launch redarea (allready calculated)
;~ 		$iMatchMode = $MA
;~ 		PrepareAttack($iMatchMode, True)
;~ 		algorithm_AllTroops()
;~ 		$iMatchMode = $DB
	EndIf

	$duringMilkingAttack = 0


EndFunc   ;==>Alogrithm_MilkingAttack

Func _OrderBySideObjectives($vect)

	Local $slice1 = ""
	Local $slice2 = ""
	Local $slice3 = ""
	Local $slice4 = ""
	Local $slice5 = ""
	Local $slice6 = ""
	Local $slice7 = ""
	Local $slice8 = ""

	;found min for each side...
	For $j = 0 To Ubound($vect) -1
		Local $structure = StringSplit($vect[$j],".",2)  ; elixir.8.346-181
		Local $pixel = StringSplit($structure[2],"-",2)  ; 346-181
		Switch StringLeft(Slice8($pixel),1)
			Case 1
				$slice1 &= $j & "-"
			Case 2
				$slice2 &= $j & "-"
			Case 3
				$slice3 &= $j & "-"
			Case 4
				$slice4 &= $j & "-"
			Case 5
				$slice5 &= $j & "-"
			Case 6
				$slice6 &= $j & "-"
			Case 7
				$slice7 &= $j & "-"
			Case else
				$slice8 &= $j & "-"
		EndSwitch
	Next
	Local $result
	If $slice7 <>"" Then $result &=$slice7
	If $slice8 <>"" Then $result &=$slice8
	If $slice1 <>"" Then $result &=$slice1
	If $slice2 <>"" Then $result &=$slice2
	If $slice3 <>"" Then $result &=$slice3
	If $slice4 <>"" Then $result &=$slice4
	If $slice5 <>"" Then $result &=$slice5
	If $slice6 <>"" Then $result &=$slice6
	$result = StringLeft($result,StringLen($result)-1)
	Return StringSplit($result,"-",2)

EndFunc


