; #FUNCTION# ====================================================================================================================
; Name ..........: smartZap
; Description ...: This file Includes all functions to current GUI
; Syntax ........: smartZap()
; Parameters ....: None
; Return values .: None
; Author ........: LunaEclipse(March, 2016)
; Modified ......: NTS team (October, 2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func displayStealableLog($aDarkDrills)
	; Create the log entry string
	Local $drillStealableString = "Estimated stealable DE in Drills: "
	; Loop through the array and add results to the log entry string
	For $i = 0 To UBound($aDarkDrills) - 1
		If $i = 0 Then
			If $aDarkDrills[$i][3] <> -1 Then $drillStealableString &= $aDarkDrills[$i][3]
		Else
			If $aDarkDrills[$i][3] <> -1 Then $drillStealableString &= ", " & $aDarkDrills[$i][3]
		EndIf
	Next
	; Display the drill string if it contains any information
	If $drillStealableString <> "Estimated stealable DE in Drills: " Then SetLog($drillStealableString, $COLOR_FUCHSIA)
EndFunc   ;==>displayStealableLog

Func getDarkElixir()
	Local $searchDark = "", $iCount = 0

	If _ColorCheck(_GetPixelColor(31, 144, True), Hex(0x0a050a, 6), 10) Or _ColorCheck(_GetPixelColor(31, 144, True), Hex(0x0F0617, 6), 5) Then ; Check if the village have a Dark Elixir Storage
		While $searchDark = ""
			$oldSearchDark = $searchDark
			$searchDark = getDarkElixirVillageSearch(45, 125) ; Get updated Dark Elixir value
			$iCount += 1

			If $debugSetLog = 1 Then Setlog("$searchDark = " & $searchDark & ", $oldSearchDark = " & $oldSearchDark, $COLOR_PURPLE)
			If $iCount > 15 Then ExitLoop ; Check a couple of times in case troops are blocking the image
			If _Sleep(1000) Then Return
		WEnd
	Else
		$searchDark = False
		If $debugSetLog = 1 Then SetLog("No DE Detected.", $COLOR_PURPLE)
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
	Local $searchDark, $oldSearchDark = 0, $numSpells, $skippedZap = True, $performedZap = False, $dropPoint

	; If smartZap is not checked, exit.
	If $ichkSmartZap <> 1 Then Return $performedZap
	If $ichkNoobZap = 1 Then SetLog("====== Your Activate NoobZap Mode ======", $COLOR_RED)

	; Use UI Setting if no Min DE is specified
	If $minDE = -1 Then $minDE = Number($itxtMinDE)

	; Get Dark Elixir value, if no DE value exists, exit.
	$searchDark = getDarkElixirVillageSearch(45, 125)
	If Number($searchDark) = 0 Then
		SetLog("No Dark Elixir so lets just exit!", $COLOR_FUCHSIA)
		Return $performedZap
	; Check to see if the DE Storage is already full
	ElseIf isDarkElixirFull() Then
		SetLog("Your Dark Elixir Storage is full, no need to zap!", $COLOR_FUCHSIA)
		Return $performedZap
	; Check to make sure the account is high enough level to store DE.
	ElseIf $iTownHallLevel < 7 Then
		SetLog("You do not have the ability to store Dark Elixir, time to go home!", $COLOR_FUCHSIA)
		Return $performedZap
	; Check to ensure there is at least the minimum amount of DE available.
	ElseIf (Number($searchDark) < Number($minDE)) Then
		SetLog("Dark Elixir is below minimum value [" & $itxtMinDE & "], Exiting Now!", $COLOR_FUCHSIA)
		Return $performedZap
	EndIf

	; Check match mode
	If $ichkSmartZapDB = 1 And $iMatchMode <> $DB Then
		SetLog("Not a dead base so lets just go home!", $COLOR_FUCHSIA)
		Return $performedZap
	EndIf

	; Get the number of lightning spells
	$numSpells = $CurLSpell
	If $numSpells = 0 Then
		SetLog("No lightning spells trained, time to go home!", $COLOR_FUCHSIA)
		Return $performedZap
	Else
		SetLog("Number of Lightning Spells: " & $numSpells, $COLOR_FUCHSIA)
	EndIf

	Local $aDrills

	; Get Drill locations and info
	Local $listPixelByLevel = getDrillArray()
	Local $aDarkDrills = drillSearch($listPixelByLevel)

	Local $strikeOffsets = [7, 10]
	Local $drillLvlOffset, $spellAdjust, $numDrills, $testX, $testY, $tempTestX, $tempTestY, $strikeGain, $expectedDE
	Local $error = 5 ; 5 pixel error margin for DE drill search

	; Get the number of drills
	$numDrills = getNumberOfDrills($listPixelByLevel)
	If $numDrills = 0 Then
		SetLog("No drills found, time to go home!", $COLOR_FUCHSIA)
		Return $performedZap
	Else
		SetLog("Number of Dark Elixir Drills: " & $numDrills, $COLOR_FUCHSIA)
	EndIf

	_ArraySort($aDarkDrills, 1, 0, 0, 3)

	; Offset the drill level based on town hall level
	$drillLvlOffset = getDrillOffset()
	If $debugSetLog = 1 Then SetLog("Drill Level Offset is: " & $drillLvlOffset, $COLOR_PURPLE)

	; Offset the number of spells based on town hall level
	$spellAdjust = getSpellOffset()
	If $debugSetLog = 1 Then SetLog("Spell Adjust is: " & $spellAdjust, $COLOR_PURPLE)

	Local $itotalStrikeGain = 0

	; Loop while you still have spells and the first drill in the array has Dark Elixir, if you are town hall 7 or higher
	While IsAttackPage() And $numSpells > 0 And $aDarkDrills[0][3] <> -1 And $spellAdjust <> -1
		; Store the DE value before any Zaps are done.
		Local $oldSearchDark = $searchDark
		CheckHeroesHealth()

		If ($searchDark < Number($itxtMinDE)) Then
			SetLog("Dark Elixir is below minimum value [" & $itxtMinDE & "], Exiting Now!", $COLOR_ACTION)
			Return $performedZap
		EndIf

		If $ichkNoobZap = 1 Then
			SetLog("NoobZap will attack any drill.", $COLOR_ACTION)
			zapDrill($eLSpell, $aDarkDrills[0][0] + $strikeOffsets[0], $aDarkDrills[0][1] + $strikeOffsets[1])

			$performedZap = True
			$skippedZap = False

			If _Sleep(3500) Then Return
		Else
			; Create the log entry string for amount stealable
			displayStealableLog($aDarkDrills)

			; If you have max lightning spells, drop lightning on any level DE drill
			If $numSpells > (4 - $spellAdjust) Then
				SetLog("First condition: " & 4 - $spellAdjust & "+ Spells so attack any drill.", $COLOR_FUCHSIA)
				zapDrill($eLSpell, $aDarkDrills[0][0] + $strikeOffsets[0], $aDarkDrills[0][1] + $strikeOffsets[1])

				$performedZap = True
				$skippedZap = False

				If _Sleep(3500) Then Return
			; If you have one less then max, drop it on drills level (3 - drill offset)
			ElseIf $numSpells > (3 - $spellAdjust) And $aDarkDrills[0][2] > (3 - $drillLvlOffset) Then
				SetLog("Second condition: Attack Lvl " & 3 - $drillLvlOffset & "+ drills if you have " & 3 - $spellAdjust & "+ spells", $COLOR_FUCHSIA)
				zapDrill($eLSpell, $aDarkDrills[0][0] + $strikeOffsets[0], $aDarkDrills[0][1] + $strikeOffsets[1])

				$performedZap = True
				$skippedZap = False

				If _Sleep(3500) Then Return
			; If the collector is higher than lvl (4 - drill offset) and collector is estimated more than 30% full
			ElseIf $aDarkDrills[0][2] > (4 - $drillLvlOffset) And ($aDarkDrills[0][3] / $DrillLevelHold[$aDarkDrills[0][2] - 1]) > 0.3 Then
				SetLog("Third condition: Attack Lvl " & 4 - $drillLvlOffset & "+ drills with more then 30% estimated DE if you have less than " & 4 - $spellAdjust & " spells", $COLOR_FUCHSIA)
				zapDrill($eLSpell, $aDarkDrills[0][0] + $strikeOffsets[0], $aDarkDrills[0][1] + $strikeOffsets[1])

				$performedZap = True
				$skippedZap = False

				If _Sleep(3500) Then Return
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
			Return $performedZap
		EndIf

		; Check to make sure we actually zapped
		If $skippedZap = False Then
			$strikeGain = $oldSearchDark - $searchDark
			$numLSpellsUsed += 1
			$numSpells -= 1

			If $aDarkDrills[0][2] <> -1 Then
				If $ichkNoobZap = 0 Then
					$expectedDE = $drillLevelSteal[($aDarkDrills[0][2] - 1)] * 0.75
				Else 
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
				SetLog("Gained: " & $strikeGain & ", Expected: " & $expectedDE, $COLOR_PURPLE)
				SetLog("Last zap gained less DE then expected, removing the drill from the list.", $COLOR_ACTION)
			Else
				$aDarkDrills[0][3] -= $strikeGain
				SetLog("Gained: " & $strikeGain & ". Adjusting amount left in this drill.", $COLOR_PURPLE)
			EndIf

			$itotalStrikeGain += $strikeGain
			$smartZapGain += $strikeGain
			SetLog("DE from last zap: " & $strikeGain & ", Total DE from SmartZap/NoobZap: " & $itotalStrikeGain, $COLOR_FUCHSIA)
		EndIf

		; Resort the array
		_ArraySort($aDarkDrills, 1, 0, 0, 3)

		; Test current drill locations to check if it still exists (within error)
		; AND get total theoretical amount in drills to compare against available amount
;		ZoomOut()
		$aDrills = drillSearch()

		If $aDarkDrills[0][0] <> -1 Then
			;Initialize tests.
			$testX = -1
			$testY = -1

			For $i = 0 To UBound($aDrills) - 1
				If $aDrills[$i][0] <> -1 Then
					$tempTestX = Abs($aDrills[$i][0] - $aDarkDrills[0][0])
					$tempTestY = Abs($aDrills[$i][1] - $aDarkDrills[0][1])

					If $debugSetLog = 1 Then SetLog("tempX: " & $tempTestX & " tempY: " & $tempTestY, $COLOR_PURPLE)

					; If the tests are less than error, give pass onto test phase
					If $tempTestX < $error And $tempTestY < $error Then
						$testX = $tempTestX
						$testY = $tempTestY
						ExitLoop
					EndIf
				EndIf
			Next
			If $debugSetLog = 1 Then SetLog("testX: " & $testX & " testY: " & $testY, $COLOR_PURPLE)

			; Test Phase, if test error is greater than expected, or test error is default value.
			If ($testX > $error Or $testY > $error) And ($testX <> -1 Or $testY <> -1) Then
				For $i = 0 To UBound($aDarkDrills, 2) - 1
					$aDarkDrills[0][$i] = -1
				Next
				SetLog("Removing drill since it wasn't found, so it was probably destroyed.", $COLOR_FUCHSIA)
				; Resort the array
				_ArraySort($aDarkDrills, 1, 0, 0, 3)
			EndIf
		EndIf
	WEnd

	Return $performedZap
EndFunc   ;==>smartZap

; This function taken and modified by the CastSpell function to make Zapping works
Func zapDrill($THSpell, $x, $y)

	Local $Spell = -1
	Local $name = ""

	; If _Sleep(10) Then Return
	; If $Restart = True Then Return

	For $i = 0 To UBound($atkTroops) - 1
		If $atkTroops[$i][0] = $THSpell Then
			$Spell = $i
			$name = NameOfTroop($THSpell, 0)
		EndIf
	Next

	If $Spell > -1 Then
		SetLog("Dropping " & $name)
		SelectDropTroop($Spell)
		If _Sleep($iDelayCastSpell1) Then Return
		If IsAttackPage() Then Click($x, $y, 1, 0, "#0029")
	Else
		If $debugSetLog = 1 Then SetLog("No " & $name & " Found")
	EndIf

EndFunc   ;==>zapDrill
