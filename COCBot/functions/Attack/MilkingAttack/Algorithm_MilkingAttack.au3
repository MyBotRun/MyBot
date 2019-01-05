; #FUNCTION# ====================================================================================================================
; Name ..........:Algorithm_MilkingAttack.au3
; Description ...:Attacks a base with the Milking Algorithm
; Syntax ........:Algorithm_MilkingAttack()
; Parameters ....:None
; Return values .:None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: Noo
; ===============================================================================================================================

Func Alogrithm_MilkingAttack()

	;--- TH snipe After Milking...
	If $g_bTHSnipeBeforeEnable[$DB] And $g_iSearchTH = "-" Then FindTownHall(True) ; if no previous detect search townhall
	If $g_bTHSnipeBeforeEnable[$DB] Then
		If $g_iSearchTH <> "-" Then
			If SearchTownHallLoc() Then
				SetLogCentered(" TH snipe Before Milking ", Default, $COLOR_INFO)
				$g_bTHSnipeUsedKing = False
				$g_bTHSnipeUsedQueen = False
				AttackTHParseCSV()
			Else
				SetLog("TH snipe Before Milking skip, TH inside village", $COLOR_INFO)
			EndIf
		Else
			SetLog("TH snipe Before Milking skip, no th detected", $COLOR_INFO)
		EndIf
	EndIf
	;---


	$g_bDuringMilkingAttack = True
	;*** MAIN PROCEDURE ***
	Local $hTimerTOTAL = __TimerInit()

	;villagesearch detect before with these functions
	;- MilkingDetectRedArea()
	;- MilkingDetectElixirExtractors()
	;- MilkingDetectMineMatch()
	;- MilkingDetectDarkExtractors()
	;fill $g_sMilkFarmObjectivesSTR with objectives to attack.

	;06 - Make Debug Image...
	;MilkFarmDebugImage( $MilkFarmAtkPixelListMINESTR,$MilkFarmAtkPixelListSTR, $MilkFarmAtkPixelListDrillSTR)

	;If $g_bMilkAttackAfterScriptedAtkEnable Then SmartAttackStrategy($MA)

	SetLogCentered(" Milking Attack ", Default, $COLOR_INFO)

	;07 - Attack  Resources -----------------------------------------------------------------------------------------------------------------------
	If StringLen($g_sMilkFarmObjectivesSTR) > 0 Then
		Local $vect = StringSplit($g_sMilkFarmObjectivesSTR, "|", 2)
		If $g_bDebugSetlog Then SetDebugLog("MilkFarmObjectivesSTR = <" & $g_sMilkFarmObjectivesSTR & ">.. UBOUND=" & UBound($vect))
		If UBound($vect) > 0 Then
			If StringLen($vect[0]) > 0 Then
				If $g_bDebugSetlog Then SetDebugLog(">Structures to attack: (" & UBound($vect) & ")", $COLOR_DEBUG)
				For $i = 0 To UBound($vect) - 1
					If $g_bDebugSetlog Then SetDebugLog("> " & $i & " " & $vect[$i], $COLOR_DEBUG)
				Next
				MilkFarmObjectivesDebugImage($g_sMilkFarmObjectivesSTR, 0)
				Local $troopPosition = -1
				For $i = 0 To UBound($g_avAttackTroops) - 1
					If $g_avAttackTroops[$i][1] <> -1 Then ;if not empty
						If $g_avAttackTroops[$i][0] = $eGobl Then
							If $g_bDebugSetlog Then SetDebugLog("-*-" & $g_avAttackTroops[$i][0] & " " & GetTroopName($g_avAttackTroops[$i][0]) & " " & $g_avAttackTroops[$i][1] & " <<---" & $eGobl, $COLOR_SUCCESS)
							$troopPosition = $i
						Else
							If $g_bDebugSetlog Then SetDebugLog("-*-" & $g_avAttackTroops[$i][0] & " " & GetTroopName($g_avAttackTroops[$i][0]) & " " & $g_avAttackTroops[$i][1] & "", $COLOR_GRAY)
						EndIf
					EndIf
				Next
				If $troopPosition >= 0 Then
					SelectDropTroop($troopPosition) ; select the troop...

					If UBound($vect) > 2 Then
						Switch $g_iMilkingAttackStructureOrder
							Case 1 ;RANDOM
								Local $rnd = _RandomUnique(UBound($vect) - 1, 0, UBound($vect) - 2, 1) ;make a random list of structure to attack
								For $i = 0 To UBound($rnd) - 1
									If $g_bDebugSetlog Then SetDebugLog("random vect pos " & $i & " value " & $rnd[$i], $COLOR_DEBUG)
								Next
							Case 2 ; ORDERED BY SIDE
								Local $rnd = _OrderBySideObjectives($vect)
								For $i = 0 To UBound($rnd) - 1
									If $g_bDebugSetlog Then SetDebugLog("order by side vect pos " & $i & " value " & $rnd[$i], $COLOR_DEBUG)
								Next
							Case Else ; AS FOUND
								Local $tmpstr = ""
								For $k = 0 To UBound($vect) - 1
									$tmpstr &= $k & "-"
								Next
								$tmpstr = StringLeft($tmpstr, StringLen($tmpstr) - 1)
								Local $rnd = StringSplit($tmpstr, "-", 2)
								For $i = 0 To UBound($rnd) - 1
									If $g_bDebugSetlog Then SetDebugLog("as found vect pos " & $i & " value " & $rnd[$i], $COLOR_DEBUG)
								Next
						EndSwitch

						;Msgbox("","","start attack (" &  UBound($rnd) & ")")
						For $i = 0 To UBound($rnd) - 1
							;Msgbox("","", "attack structure n. " &$i)
							Local $vect2 = StringSplit($vect[$i], ".", 2)
							If UBound($vect2) > 1 Then
								If $g_bDebugSetlog Then SetDebugLog($i & "- Attack structure n. " & $rnd[$i] + 1 & "/" & UBound($vect) & " - " & $vect2[0], $COLOR_DEBUG)
								If UBound($vect) > $rnd[$i] Then
									MilkingAttackStructure($vect[$rnd[$i]])
								Else
									If $g_bDebugSetlog Then SetDebugLog($i & " range exceeded of $vect!")
								EndIf
							Else
								If $g_bDebugSetlog Then SetDebugLog("Error @18")
							EndIf
						Next
					EndIf

					If UBound($vect) = 2 Then
						For $i = 0 To 1
							;Msgbox("","", "attack structure n. " &$i)
							If $g_bDebugSetlog Then SetDebugLog($i & "- Attack structure n. " & $i & "/1 ", $COLOR_DEBUG)
							MilkingAttackStructure($vect[$i])
						Next
					EndIf

					If UBound($vect) = 1 Then
						If $g_bDebugSetlog Then SetDebugLog($i & "- Attack structure n. 0/0 ", $COLOR_DEBUG)
						MilkingAttackStructure($vect[0])
					EndIf
				Else
					If $g_bDebugSetlog Then SetDebugLog("No Goblins left ")
				EndIf
			Else
				If $g_bDebugSetlog Then SetDebugLog("No structures to attack...")
			EndIf
		Else
			If $g_bDebugSetlog Then SetDebugLog("No structures to attack..")
		EndIf
	Else
		SetLog("No structures to attack, skip attack structures!")
	EndIf

	; at end of milking attack check if bot continue to attack TH snipe and/or standard attack
	If $g_bMilkAttackAfterTHSnipeEnable Then
		; TH snipe attack selected, if no th found before, search enemy TH location
		;a check th position
		FindTownHall(True) ;force search townhall bacause we have possibility to already destroyed

		;b check th outside
		If $g_iSearchTH <> "-" Then
			If SearchTownHallLoc() Then ;check if townhall position it is outside
				$g_iMatchMode = $TS
				SetLogCentered(" Attack TH snipe after Milking Attack ", Default, $COLOR_INFO)
				;if, after TH snipe, we have standard attack, need to detect the positions of special troops (king, queen, warden)
				If $g_bMilkAttackAfterScriptedAtkEnable = False Then
					PrepareAttack($g_iMatchMode, True)
					algorithm_AllTroops() ;algorithm alltroops with $g_iMatchMode = $TS launch TH Snipe
				Else
					SetSlotSpecialTroops()
					$g_bTHSnipeUsedKing = False
					$g_bTHSnipeUsedQueen = False
					AttackTHParseCSV()
				EndIf
			Else
				SetLog("TH it is not outside, skip attack", $COLOR_INFO)
			EndIf

		Else
			SetLog("Cannot detect Townhall, skip THsnipe after Milking", $COLOR_INFO)
		EndIf
	EndIf
	If $g_bMilkAttackAfterScriptedAtkEnable Then
		SetLogCentered("Scripted Attack after Miliking ", Default, $COLOR_INFO)
		Algorithm_AttackCSV(False, False) ;launch algorithm without launch redarea (already calculated)
;~ 		$g_iMatchMode = $MA
;~ 		PrepareAttack($g_iMatchMode, True)
;~ 		algorithm_AllTroops()
;~ 		$g_iMatchMode = $DB
	EndIf

	$g_bDuringMilkingAttack = False


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
	For $j = 0 To UBound($vect) - 1
		Local $structure = StringSplit($vect[$j], ".", 2) ; elixir.8.346-181
		Local $pixel = StringSplit($structure[2], "-", 2) ; 346-181
		Switch StringLeft(Slice8($pixel), 1)
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
			Case Else
				$slice8 &= $j & "-"
		EndSwitch
	Next
	Local $result
	If $slice7 <> "" Then $result &= $slice7
	If $slice8 <> "" Then $result &= $slice8
	If $slice1 <> "" Then $result &= $slice1
	If $slice2 <> "" Then $result &= $slice2
	If $slice3 <> "" Then $result &= $slice3
	If $slice4 <> "" Then $result &= $slice4
	If $slice5 <> "" Then $result &= $slice5
	If $slice6 <> "" Then $result &= $slice6
	$result = StringLeft($result, StringLen($result) - 1)
	Return StringSplit($result, "-", 2)

EndFunc   ;==>_OrderBySideObjectives


