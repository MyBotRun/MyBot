; #FUNCTION# ====================================================================================================================
; Name ..........:MilkingAttackStructure
; Description ...:Attack structures
; Syntax ........:MilkingAttackStructure($vectstr)
; Parameters ....:$vectstr-buildings coordinates
; Return values .:None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: Noo
; ===============================================================================================================================

Func MilkingAttackStructure($vectstr)
	If $debugsetlog = 1 Then SetLog("###### Attack " & $vectstr & "######")
	Local $vect = StringSplit($vectstr, ".", 2)
	If UBound($vect) = 4 Then ; (only 1 point)
		Local $temp = $vect[3]
		Local $aRnd[1] = [$temp]
	Else

		Local $troopxwave
		If $MilkFarmTroopForWaveMin = $MilkFarmTroopForWaveMax Then
			$troopxwave = $MilkFarmTroopForWaveMin
		Else
			$troopxwave = Random($MilkFarmTroopForWaveMin, $MilkFarmTroopForWaveMax, 1)
		EndIf

		If $debugsetlog = 1 Then Setlog("drop n.: " & $troopxwave & " troops | structure:" & $vect[0])
		Local $skipdelay = False
		For $i = 1 To $MilkFarmTroopMaxWaves
			If $debugsetlog = 1 Then Setlog("Wave attack number " & $i)
			$skipdelay = False
			If IsAttackPage() Then

				If $MilkingAttackCheckStructureDestroyedBeforeAttack = 1 Then
					If MilkingAttackStructureDestroyed($vect[0], $vect[1], $vect[2]) Then
						$skipdelay = True
						ExitLoop ; exit if allready destroyed by other wave
					EndIf
				EndIf

				If $MilkingAttackDropGoblinAlgorithm = 1 Then
					;DROP EACH GOBLIN IN A DIFFERENT PLACE
					For $j = 1 To $troopxwave

						;select random drop point
						If UBound($vect) = 4 Then
							Local $rndpos = 3
						Else
							Local $rndpos = Random(3, UBound($vect) - 1, 1)
						EndIf

						;If $debugsetlog=1 Then Setlog(">drop using position " & $rndpos & ": " & $vect[$rndpos] )
						$pixel = StringSplit($vect[$rndpos], "-", 2)
						Local $delaypoint = 0

						If UBound($pixel) = 2 Then
							;If $debugsetlog=1 Then etlog("Click( " & $pixel[0] & ", " & $pixel[1] & " , 1, " & $delayPoint & ",#0777)")
							Click($pixel[0], $pixel[1], 1, $delaypoint, "#0777")
						Else
							If $debugsetlog = 1 Then Setlog("MilkingAttackStructure error #1")
						EndIf
					Next
				Else
					; DROP ALL GOBLINS IN A PLACE
					;select random drop point
					If UBound($vect) = 4 Then
						Local $rndpos = 3
					Else
						Local $rndpos = Random(3, UBound($vect) - 1, 1)
					EndIf
					$pixel = StringSplit($vect[$rndpos], "-", 2)

					If UBound($pixel) = 2 Then
						;If $debugsetlog=1 Then Setlog("Click( " & $pixel[0] & ", " & $pixel[1] & " ," &  $troopxwave& ", "0,#0778)")
						Click($pixel[0], $pixel[1], $troopxwave, Random(2, 7, 1), "#0778")
					Else
						If $debugsetlog = 1 Then Setlog("MilkingAttackStructure error #1")
					EndIf
				EndIf
			Else
				If $debugsetlog = 1 Then Setlog("You are not in Attack phase")
				Return
			EndIf

			If $skipdelay = False Then
				Local $delayfromwaves
				If $MilkFarmDelayFromWavesMin = $MilkFarmDelayFromWavesMax Then
					$delayfromwaves = $MilkFarmDelayFromWavesMin
				Else
					$delayfromwaves = Random($MilkFarmDelayFromWavesMin, $MilkFarmDelayFromWavesMax, 1)
				EndIf
				If $debugsetlog = 1 Then Setlog("wait " & $delayfromwaves)
				If _Sleep($delayfromwaves) Then Return ;wait before attack new structure.
			EndIf
		Next
		If $MilkingAttackCheckStructureDestroyedAfterAttack = 1 Then
			If MilkingAttackStructureDestroyed($vect[0], $vect[1], $vect[2]) Then Return ; only to make debug image
		EndIf
	EndIf

EndFunc   ;==>MilkingAttackStructure
