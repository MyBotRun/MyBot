; #FUNCTION# ====================================================================================================================
; Name ..........: smartZap
; Description ...: This file Includes all functions to current GUI
; Syntax ........: smartZap()
; Parameters ....: None
; Return values .: None
; Author ........: LunaEclipse(March, 2016)
; Modified ......: TheRevenor(November, 2016), ProMac(Desember, 2016), TheRevenor(Desember, 2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func displayStealableLog($aDarkDrills)
	; Create the log entry string
	Local $drillStealableString = "Drills Lvl/Estimated Amount left: "
	; Loop through the array and add results to the log entry string
	For $i = 0 To UBound($aDarkDrills) - 1
		If $i = 0 Then
			If $aDarkDrills[$i][3] <> -1 Then $drillStealableString &= "Lv" & $aDarkDrills[$i][2] & "/" & $aDarkDrills[$i][3]
		Else
			If $aDarkDrills[$i][3] <> -1 Then $drillStealableString &= ", " & "Lv" & $aDarkDrills[$i][2] & "/" & $aDarkDrills[$i][3]
		EndIf
	Next
	; Display the drill string if it contains any information
	If $drillStealableString <> "Estimated stealable DE in Drills: " Then
		If $ichkNoobZap = 0 Then
			SetLog($drillStealableString, $COLOR_FUCHSIA)
		Else
			If $DebugSmartZap = 1 Then SetLog($drillStealableString, $COLOR_DEBUG)
		EndIf
	EndIf
EndFunc   ;==>displayStealableLog

Func getDarkElixir()
	Local $searchDark = "", $iCount = 0

	Setlog("Getting Dark Elixir Values.")
	If _ColorCheck(_GetPixelColor(31, 144, True), Hex(0x282020, 6), 10) Or _ColorCheck(_GetPixelColor(31, 144, True), Hex(0x0F0617, 6), 5) Then ; check if the village have a Dark Elixir Storage
		While $searchDark = ""
			$searchDark = getDarkElixirVillageSearch(48, 126) ; Get updated Dark Elixir value
			$oldSearchDark = $searchDark
			$iCount += 1
			;If $DebugSmartZap = 1 Then Setlog("$searchDark = " & Number($searchDark) & ", $oldSearchDark = " & Number($oldSearchDark), $COLOR_DEBUG)
			If $iCount > 15 Then ExitLoop ; Check a couple of times in case troops are blocking the image
			If _Sleep($DelaySmartZap1) Then Return
		WEnd
	Else
		$searchDark = False
		If $DebugSmartZap = 1 Then SetLog(" - No DE detected.", $COLOR_DEBUG)
	EndIf

	Return $searchDark
EndFunc   ;==>getDarkElixir

Func getDrillOffset()
	Local $result = -1

	; Checking our global variable holding the town hall level
	Switch $iTownHallLevel
		Case 0 To 7
			$result = 2
		Case 8
			$result = 1
		Case Else
			$result = 0
	EndSwitch

	Return $result
EndFunc   ;==>getDrillOffset

Func getSpellOffset()
	Local $result = -1

	; Checking our global variable holding the town hall level
	Switch $iTownHallLevel
		Case 0 To 4
			$result = -1
		Case 5, 6
			; Town hall 5 and 6 have lightning spells, but why would you want to zap?
			$result = -1
		Case 7, 8
			$result = 2
		Case 9
			$result = 1
		Case Else
			$result = 0
	EndSwitch

	Return $result
EndFunc   ;==>getSpellOffset

Func smartZap($minDE = -1)
	Local $searchDark, $oldSearchDark = 0, $skippedZap = True, $performedZap = False, $dropPoint

	; If smartZap is not checked, exit.
	If $DebugSmartZap = 1 Then SetLog("$ichkSmartZap = " & $ichkSmartZap & " | $ichkEarthQuakeZap = " & $ichkEarthQuakeZap & " | $ichkNoobZap = " & $ichkNoobZap, $COLOR_DEBUG)
	If $ichkSmartZap <> 1 Then Return $performedZap
	If $ichkSmartZap = 1 And $ichkNoobZap = 0 Then
		SetLog("====== You have activated SmartZap Mode ======", $COLOR_ERROR)
	ElseIf $ichkNoobZap = 1 Then
		SetLog("====== You have activated NoobZap Mode ======", $COLOR_ERROR)
	EndIf

	; Use UI Setting if no Min DE is specified
	If $minDE = -1 Then $minDE = Number($itxtMinDE)

	; Get Dark Elixir value, if no DE value exists, exit.
	$searchDark = getDarkElixirVillageSearch(48, 126)
	If Number($searchDark) = 0 Then
		SetLog("No Dark Elixir so lets just exit!", $COLOR_FUCHSIA)
		If $DebugSmartZap = 1 Then SetLog("$searchDark|Current DE value: " & Number($searchDark), $COLOR_DEBUG)
		Return $performedZap
	Else
		If $DebugSmartZap = 1 Then SetLog("$searchDark|Current DE value: " & Number($searchDark), $COLOR_DEBUG)
	EndIf

	; Check to see if the DE Storage is already full
	If isDarkElixirFull() Then
		SetLog("Your Dark Elixir Storage is full, no need to zap!", $COLOR_FUCHSIA)
		If $DebugSmartZap = 1 Then SetLog("isDarkElixirFull(): " & isDarkElixirFull(), $COLOR_DEBUG)
		Return $performedZap
	Else
		If $DebugSmartZap = 1 Then SetLog("isDarkElixirFull(): " & isDarkElixirFull(), $COLOR_DEBUG)
	EndIf

	; Check to make sure the account is high enough level to store DE.
	If $iTownHallLevel < 7 Then
		SetLog("You do not have the ability to store Dark Elixir, time to go home!", $COLOR_FUCHSIA)
		If $DebugSmartZap = 1 Then SetLog("Your Town Hall Lv: " & Number($iTownHallLevel), $COLOR_DEBUG)
		Return $performedZap
	Else
		If $DebugSmartZap = 1 Then SetLog("Your Town Hall Lv: " & Number($iTownHallLevel), $COLOR_DEBUG)
	EndIf

	; Check to ensure there is at least the minimum amount of DE available.
	If (Number($searchDark) < Number($minDE)) Then
		SetLog("Dark Elixir is below minimum value [" & Number($itxtMinDE) & "], Exiting Now!", $COLOR_FUCHSIA)
		If $DebugSmartZap = 1 Then SetLog("$searchDark|Current DE value: " & Number($searchDark), $COLOR_DEBUG)
		Return $performedZap
	Else
		If $DebugSmartZap = 1 Then SetLog("$searchDark = " & Number($searchDark) & " | $itxtMinDE = " & Number($itxtMinDE), $COLOR_DEBUG)
	EndIf

	If $DebugSmartZap = 1 Then
		SetLog("$itxtExpectedDE| Expected DE value:" & Number($itxtExpectedDE), $COLOR_DEBUG)
		SetLog("$ichkTimeStopAtk[$DB] = " & $ichkTimeStopAtk[$DB] & ", $txtDBTimeStopAtk = " & $sTimeStopAtk[$DB] & "s", $COLOR_DEBUG)
	EndIf

	; Check match mode
	If $ichkSmartZapDB = 1 And $iMatchMode <> $DB Then
		SetLog("Not a dead base so lets just go home!", $COLOR_FUCHSIA)
		SetDebugLog("$ichkSmartZapDB = " & $ichkSmartZapDB)
		Return $performedZap
	Else
		If $DebugSmartZap = 1 Then SetLog("$ichkSmartZapDB = " & $ichkSmartZapDB, $COLOR_DEBUG)
	EndIf

	; Reset the variables
	$numSpells = 0
	$EQSpellZap = 0

	Setlog( "Getting the spells Quantities!")
	; Get the number of lightning/EQ spells
	For $i = 0 To 11
		If $atkTroops[$i][0] = $eLSpell Then
			$numSpells = $atkTroops[$i][1]
			;Setlog( " - Lightning: " & $numSpells)
		EndIf
		If $atkTroops[$i][0] = $eESpell And IsSpecialTroopToBeUsed($DB, $eESpell) Then
			$EQSpellZap = $atkTroops[$i][1]
			;Setlog( " - Earth Quake: " & $EQSpellZap)
		EndIf
	Next

	If $numSpells = 0 Then
		SetLog("No lightning spells trained, time to go home!", $COLOR_FUCHSIA)
		Return $performedZap
	Else
		SetLog(" - Number of Lightning Spells: " & Number($numSpells), $COLOR_FUCHSIA)
	EndIf

	If $ichkEarthQuakeZap = 1 And $EQSpellZap > 0 And IsSpecialTroopToBeUsed($DB, $eESpell) Then
		SetLog(" - Number of Earth Quake Spells: " & Number($EQSpellZap), $COLOR_FUCHSIA)
    Else
		$EQSpellZap = 0 ; remove the EQ , is not to use it
	EndIf

	; Get Drill locations and info
	Local $listPixelByLevel = getDrillArray()
	Local $aDarkDrills = drillSearch($listPixelByLevel)

	Local $strikeOffsets = [7, 10]
	Local $drillLvlOffset, $spellAdjust, $numDrills, $testX, $testY, $tempTestX, $tempTestY, $strikeGain, $expectedDE
	Local $error = 5 ; 5 pixel error margin for DE drill search

	; Get the number of drills
	Local $iLoopCount = 0
	While 1
		$numDrills = getNumberOfDrills($listPixelByLevel)
		If $numDrills = 0 Then
			$iLoopCount += 1
			If _Sleep($DelaySmartZap1) Then Return
			If $iLoopCount >= 5 And $numDrills = 0 Then
				SetLog("No drills found, time to go home!", $COLOR_FUCHSIA)
				SetDebugLog("$numDrills = " & Number($numDrills))
				Return $performedZap
			EndIf
		Else
			SetLog(" - Number of Dark Elixir Drills: " & Number($numDrills), $COLOR_FUCHSIA)
			ExitLoop
		EndIf
	WEnd

	; Create the log entry string for amount stealable
	_ArraySort($aDarkDrills, 1, 0, 0, 3)
	displayStealableLog($aDarkDrills)

	; Offset the drill level based on town hall level
	$drillLvlOffset = getDrillOffset()
	If $DebugSmartZap = 1 Then SetLog("Drill Level Offset is: " & Number($drillLvlOffset), $COLOR_DEBUG)

	; Offset the number of spells based on town hall level
	$spellAdjust = getSpellOffset()
	If $DebugSmartZap = 1 Then SetLog("Spell Adjust is: " & Number($spellAdjust), $COLOR_DEBUG)

	Local $itotalStrikeGain = 0

	; Loop while you still have spells and the first drill in the array has Dark Elixir, if you are town hall 7 or higher
	While IsAttackPage() And $numSpells > 0 And $aDarkDrills[0][3] <> -1 And $spellAdjust <> -1
		Local $_EQSpellused = False
		; Store the DE value before any Zaps are done.
		Local $oldSearchDark = $searchDark
		If $iActivateKQCondition = "Auto" Then CheckHeroesHealth()

		If ($searchDark < Number($itxtMinDE)) Then
			SetLog("Dark Elixir is below minimum value [" & Number($itxtMinDE) & "], Exiting Now!", $COLOR_FUCHSIA)
			Return $performedZap
		EndIf

		; If you activate N00bZap, drop lightning on any DE drill
		If $ichkNoobZap = 1 Then
			SetLog("NoobZap is going to attack any drill.", $COLOR_ACTION)
			zapDrill($eLSpell, $aDarkDrills[0][0] + $strikeOffsets[0], $aDarkDrills[0][1] + $strikeOffsets[1])

			$performedZap = True
			$skippedZap = False

			If _Sleep($DelaySmartZap4) Then Return
		Else
			; If you have max lightning spells, drop lightning on any level DE drill
			If $numSpells + $EQSpellZap > (4 - $spellAdjust) Then
				If  $EQSpellZap > 0 And $aDarkDrills[0][2] > 4 Then
					EarthQuakeZapDrill($aDarkDrills[0][0] + $strikeOffsets[0], $aDarkDrills[0][1] + $strikeOffsets[1])
					$_EQSpellused = True
					If _Sleep($DelaySmartZap3) Then Return
				Else
					SetLog("First condition: " & 4 - $spellAdjust & "+ Spells so attack any drill.", $COLOR_FUCHSIA)
					zapDrill($eLSpell, $aDarkDrills[0][0] + $strikeOffsets[0], $aDarkDrills[0][1] + $strikeOffsets[1])
					If _Sleep($DelaySmartZap4) Then Return
				EndIf

				$performedZap = True
				$skippedZap = False

				; If you have one less then max, drop it on drills level (3 - drill offset)
			ElseIf $numSpells + $EQSpellZap > (3 - $spellAdjust) And $aDarkDrills[0][2] > (3 - $drillLvlOffset) Then
				If  $EQSpellZap > 0 And $aDarkDrills[0][2] > 4 Then
					EarthQuakeZapDrill($aDarkDrills[0][0] + $strikeOffsets[0], $aDarkDrills[0][1] + $strikeOffsets[1])
					$_EQSpellused = True
					If _Sleep($DelaySmartZap3) Then Return
				Else
					SetLog("Second condition: Attack Lvl " & 3 - Number($drillLvlOffset) & "+ drills if you have " & 3 - Number($spellAdjust) & "+ spells", $COLOR_FUCHSIA)
					zapDrill($eLSpell, $aDarkDrills[0][0] + $strikeOffsets[0], $aDarkDrills[0][1] + $strikeOffsets[1])
					If _Sleep($DelaySmartZap4) Then Return
				EndIf

				$performedZap = True
				$skippedZap = False

				; If the collector is higher than lvl (4 - drill offset) and collector is estimated more than 30% full
			ElseIf $aDarkDrills[0][2] > (4 - $drillLvlOffset) And ($aDarkDrills[0][3] / $DrillLevelHold[$aDarkDrills[0][2] - 1]) > 0.3 Then
				If  $EQSpellZap > 0 And $aDarkDrills[0][2] > 4 Then
					EarthQuakeZapDrill($aDarkDrills[0][0] + $strikeOffsets[0], $aDarkDrills[0][1] + $strikeOffsets[1])
					$_EQSpellused = True
					If _Sleep($DelaySmartZap3) Then Return
				Else
					SetLog("Third condition: Attack Lvl " & 4 - Number($drillLvlOffset) & "+ drills with more then 30% estimated DE if you have less than " & 4 - Number($spellAdjust) & " spells", $COLOR_FUCHSIA)
					zapDrill($eLSpell, $aDarkDrills[0][0] + $strikeOffsets[0], $aDarkDrills[0][1] + $strikeOffsets[1])
					If _Sleep($DelaySmartZap4) Then Return
				EndIf

				$performedZap = True
				$skippedZap = False

			Else
				$skippedZap = True
				SetLog("Drill did not match any attack conditions, so we will remove it from the list.", $COLOR_FUCHSIA)
				For $i = 0 To UBound($aDarkDrills, 2) - 1
					$aDarkDrills[0][$i] = -1
				Next
			EndIf
		EndIf

		; Get the DE Value after SmartZap has performed its actions.
		$searchDark = getDarkElixir()

		; No Dark Elixir Left
		If Not $searchDark Or $searchDark = 0 Then
			SetLog("No Dark Elixir so lets just exit!", $COLOR_FUCHSIA)
			SetDebugLog("$searchDark = " & Number($searchDark))
			Return $performedZap
		Else
			If $DebugSmartZap = 1 Then SetLog("$searchDark = " & Number($searchDark), $COLOR_DEBUG)
		EndIf

		; Check to make sure we actually zapped
		If $skippedZap = False Then
			If $DebugSmartZap = 1 Then Setlog("$oldSearchDark = [" & Number($oldSearchDark) & "] - $searchDark = [" & Number($searchDark) & "]", $COLOR_DEBUG)
			$strikeGain = Number($oldSearchDark - $searchDark)
			If $DebugSmartZap = 1 Then Setlog("$strikeGain = " & Number($strikeGain), $COLOR_DEBUG)
			If $aDarkDrills[0][2] <> -1 Then
				If $ichkNoobZap = 0 Then
					If $_EQSpellused = True  Then
						$numEQSpellsUsed += 1
						; Lv1:14%  | Lv2:17% | Lv3:21% | Lv4:25% (percentage)
						$expectedDE = Ceiling(Number($drillLevelSteal[($aDarkDrills[0][2] - 1)] * 0.20))  ; 20% damage | EarthQuake Spells
					Else
						$numLSpellsUsed += 1
						; Lv1:300 | Lv2:330 | Lv3:360 |Lv4:390 | Lv5:450 |Lv6:510 | Lv7:570 (points)
						$expectedDE = Ceiling(Number($drillLevelSteal[($aDarkDrills[0][2] - 1)] * 0.70))  ; 70% damage ! Lighting Spells
					EndIf
				Else
					$numLSpellsUsed += 1
					$expectedDE = $itxtExpectedDE
				EndIf
			Else
				$expectedDE = -1
			EndIf

			; If change in DE is less than expected, remove the Drill from list. else, subtract change from assumed total
			If $strikeGain < $expectedDE And $expectedDE <> -1 Then
				For $i = 0 To UBound($aDarkDrills, 2) - 1
					$aDarkDrills[0][$i] = -1
				Next
				SetLog("Gained: " & $strikeGain & ", Expected: " & $expectedDE, $COLOR_DEBUG)
				SetLog("Last zap gained less DE then expected, removing the drill from the list.", $COLOR_ACTION)
			Else
				$aDarkDrills[0][3] -= $strikeGain
				SetLog("Gained: " & Number($strikeGain) & ". Adjusting amount left in this drill.", $COLOR_DEBUG)
			EndIf

			$itotalStrikeGain += $strikeGain
			$smartZapGain += $strikeGain
			SetLog("DE from last zap: " & Number($strikeGain) & ", Total DE from SmartZap/NoobZap: " & Number($itotalStrikeGain), $COLOR_FUCHSIA)
		EndIf

		; Resort the array
		_ArraySort($aDarkDrills, 1, 0, 0, 3)

		; Test current drill locations to check if it still exists (within error)
		; AND get total theoretical amount in drills to compare against available amount

		If _Sleep($DelaySmartZap1) Then Return

		If $aDarkDrills[0][0] =  -1 Then
			Setlog("None valid Drill to check!", $COLOR_ACTION)
			Return $performedZap
		EndIf

		; Recheck will detect IF exist the drill or was destroyed
		If ReCheckDrillExist($aDarkDrills[0][0] + $strikeOffsets[0], $aDarkDrills[0][1] + $strikeOffsets[1]) Then
			ContinueLoop
		Else
			; Was destroyed let's remove the values from array
			For $i = 0 To UBound($aDarkDrills, 2) - 1
				$aDarkDrills[0][$i] = -1
			Next
			SetLog("Removing drill since it wasn't found, so it was probably destroyed.", $COLOR_FUCHSIA)

			; Resort the array
			_ArraySort($aDarkDrills, 1, 0, 0, 3)

			If $aDarkDrills[0][0] =  -1 Then
				Setlog("None valid Drill to check!", $COLOR_ACTION)
				Return $performedZap
			EndIf

			; Create the log entry string for amount stealable
			displayStealableLog($aDarkDrills)
		EndIf
	WEnd

	Return $performedZap
EndFunc   ;==>smartZap

; This function taken and modified by the CastSpell function to make Zapping works
Func zapDrill($THSpell, $x, $y)
	Local $Spell = -1
	Local $name = ""

	For $i = 0 To UBound($atkTroops) - 1
		If $atkTroops[$i][0] = $THSpell Then
			$Spell = $i
			$name = NameOfTroop($THSpell, 0)
		EndIf
	Next

	If $Spell > -1 Then
		SetLog("Dropping " & String($name))
		SelectDropTroop($Spell)
		If _Sleep($iDelayCastSpell1) Then Return
		If IsAttackPage() Then Click($x, $y, 1, 0, "#0029")
	Else
		If $DebugSmartZap = 1 Then SetLog("No " & String($name) & " Found")
	EndIf
	If $THSpell = $eLSpell Then $numSpells -= 1
	If $THSpell = $eESpell Then $EQSpellZap -= 1
EndFunc   ;==>zapDrill

Func EarthQuakeZapDrill($EQZapX, $EQZapY)
	; If you have EarthQuake spells, drop EarthQuake on any level DE drill
	If $ichkEarthQuakeZap = 1 And $EQSpellZap > 0 Then
		If $DebugSmartZap = 1 Then SetLog("$EQSpellZap: " & Number($EQSpellZap), $COLOR_DEBUG)
		If _Sleep($DelaySmartZap1) Then Return
		SetLog("EarthQuake condition: We will zap with EarthQuake spell", $COLOR_FUCHSIA)
		zapDrill($eESpell, $EQZapX, $EQZapY)
	EndIf
EndFunc   ;==>EarthQuakeZapDrill

Func ReCheckDrillExist($x, $y)
	Local $result
	If _Sleep($DelaySmartZap3) Then Return ; 3 seconds to disapear green bars
	_CaptureRegion2($x - 50, $y - 50, $x + 40, $y + 40)
	Local $directory = @ScriptDir & "\imgxml\Storages\Drills"
	Local $Maxpositions = 1

	Local $aResult = multiMatches($directory, $Maxpositions, "FV", "FV")
	$result = ConvertImgloc2MBR($aResult, $Maxpositions)

	If StringLen($result) > 3 Then
		If $DebugSmartZap = 1 Then SetLog("ReCheckDrillExist: Yes| " & $result, $COLOR_SUCCESS)
		Return True
	Else
		If $DebugSmartZap = 1 Then SetLog("ReCheckDrillExist: No| " & $result, $COLOR_ERROR)
		Return False
	EndIf
	Return False
EndFunc   ;==>ReCheckDrillExist
