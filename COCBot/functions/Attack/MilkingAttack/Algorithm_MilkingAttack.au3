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
						Local $rnd = _RandomUnique(UBound($vect) - 1, 0, UBound($vect) - 2, 1) ;make a random list of structure to attack
						For $i = 0 To UBound($rnd) - 1
							If $debugsetlog = 1 Then Setlog("random vect pos " & $i & " value " & $rnd[$i])
						Next
						For $i = 0 To UBound($rnd) - 1
							Local $vect2 = StringSplit($vect[$i], ".", 2)
							If UBound($vect2) > 1 Then
								If $debugsetlog = 1 Then Setlog($i & "- Attack structure n. " & $rnd[$i] & "/" & UBound($vect) & " - " & $vect2[0], $color_purple)
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
		If $debugsetlog = 1 Then Setlog("No structures to attack, skip attack!")
	EndIf

EndFunc   ;==>Alogrithm_MilkingAttack
