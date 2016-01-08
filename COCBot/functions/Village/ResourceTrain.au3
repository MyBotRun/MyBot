Func ResourceTrain()

;	If $icmbTroopComp <> 10 Then Return


	Local $tempCounter = 0			; for looping on village check


	If $debugSetlog = 1 Then SetLog("Func Train ", $COLOR_PURPLE)
	If $bTrainEnabled = False Then Return

	; Read Resource Values For army cost Stats
	Local $tempElixir = ""	
	Local $tempDElixir = ""
	Local $tempElixirSpent = 0
	Local $tempDElixirSpent = 0

	VillageReport(True, True)

	$tempCounter = 0
	While ($iElixirCurrent = "" Or ($iDarkCurrent = "" And $iDarkStart <> "")) And $tempCounter < 5
		$tempCounter += 1
		If _Sleep(100) Then Return
		VillageReport(True, True)
	WEnd
	$tempElixir = $iElixirCurrent
	$tempDElixir = $iDarkCurrent
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; in halt attack mode Make sure army reach 100% regardless of user Percentage of full army
	If ($CommandStop = 3 Or $CommandStop = 0) Then
		CheckOverviewFullArmy(True)
		If $fullarmy Then
			If $debugSetlog = 1 Then SetLog("FullArmy & TotalTrained = skip training", $COLOR_PURPLE)
			Return
		EndIf
	EndIf

	SetLog("Training Troops & Spells", $COLOR_BLUE)
	If _Sleep($iDelayTrain1) Then Return
	ClickP($aAway, 1, 0, "#0268") ;Click Away to clear open windows in case user interupted
	If _Sleep($iDelayTrain4) Then Return

	;OPEN ARMY OVERVIEW WITH NEW BUTTON
	; WaitforPixel($iLeft, $iTop, $iRight, $iBottom, $firstColor, $iColorVariation, $maxDelay = 10)
	If WaitforPixel(28, 505 + $bottomOffsetY, 30, 507 + $bottomOffsetY, Hex(0xE4A438, 6), 5, 10) Then
		If $debugSetlog = 1 Then SetLog("Click $aArmyTrainButton", $COLOR_GREEN)
		If IsMainPage() Then Click($aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0, "#0293") ; Button Army Overview
	EndIf

	If _Sleep($iDelayRunBot6) Then Return ; wait for window to open
	If Not (IsTrainPage()) Then Return ; exit if I'm not in train page

	checkAttackDisable($iTaBChkIdle) ; Check for Take-A-Break after opening train page
	
	; Determine training
	; 1. Figure out what we've already trained. (This is done above in checkArmyCamp)
	; 2. Figure out what we have in training.
	;	a. figure out how much time is already in each barracks
	; 3. Figure out what is left to train for our desired comp.
	; 4. Assign troops to barracks.



	; 1. Figure out what we've already trained. (This is done above in checkArmyCamp)

	ZeroArray($ArmyTrained) ; Zero out the in-training array before we check the camp. checkArmyCamp populates this
	checkArmyCamp()

SetLog("Done checkArmyCamp")

	; GO TO First NORMAL BARRACK
	; Find First barrack $i
	; This actually finds the last barracks
	Local $Firstbarrack = 0, $i = 1
	While $Firstbarrack = 0 And $i <= 4
		If $Trainavailable[$i] = 1 Then $Firstbarrack = $i
		$i += 1
	WEnd

	If $Firstbarrack = 0 Then
		Setlog("No barrack available, cannot start train")
		Return ;exit from train
	EndIf
	If $debugSetlog = 1 Then Setlog("First BARRACK = " & $Firstbarrack, $COLOR_PURPLE)

	Local $j = 0
	While Not _ColorCheck(_GetPixelColor($btnpos[0][0], $btnpos[0][1], True), Hex(0xE8E8E0, 6), 20)
		If $debugSetlog = 1 Then Setlog("OverView TabColor=" & _GetPixelColor($btnpos[0][0], $btnpos[0][1], True), $COLOR_PURPLE)
		If _Sleep($iDelayTrain1) Then Return ; wait for Train Window to be ready.
		$j += 1
		If $j > 15 Then ExitLoop
	WEnd
	If $j > 15 Then
		SetLog("Training Overview Window didn't open", $COLOR_RED)
		Return
	EndIf
	If Not (IsTrainPage()) Then Return ;exit if no train page

	Click($btnpos[$Firstbarrack][0], $btnpos[$Firstbarrack][1], 1, $iDelayTrain5, "#0336") ; Select first tab
	Local $j = 0
	While Not _ColorCheck(_GetPixelColor($btnpos[$Firstbarrack][0], $btnpos[$Firstbarrack][1], True), Hex(0xE8E8E0, 6), 20)
		If $debugSetlog = 1 Then Setlog("First Barrack TabColor=" & _GetPixelColor($btnpos[$Firstbarrack][0], $btnpos[$Firstbarrack][1], True), $COLOR_PURPLE)
		If _Sleep($iDelayTrain1) Then Return
		$j += 1
		If $j > 15 Then ExitLoop
	WEnd
	If $j > 15 Then
		SetLog("some error occurred, cannot open barrack", $COLOR_RED)
	EndIf


	If $debugSetlog = 1 Then SetLog("Total ArmyCamp :" & $TotalCamp, $COLOR_PURPLE)



	$ArmyComposition = getArmyComposition()


	; 2. Figure out what we have in training.
	;	a. figure out how much time is already in each barracks

	Local $barracksTrainingTime[$numBarracksAvaiables + $numDarkBarracksAvaiables]

	Click($btnpos[$Firstbarrack][0], $btnpos[$Firstbarrack][1], 1, $iDelayTrain5, "#0336") ; Click on tab 
	Local $barracksNumber = 0

	ZeroArray($ArmyTraining)
	While isBarrack() Or isDarkBarrack()
		If Not (IsTrainPage()) Then Return
		If _Sleep($iDelayTrain2) Then Return
		If $barracksNumber >= $numBarracksAvaiables + $numDarkBarracksAvaiables Then ExitLoop

		Local $darkBarracks = isDarkBarrack()
		For $iUnit = 0 to $iArmyEnd-1
			Local $num = getNumTraining($iUnit, $darkBarracks)
			$ArmyTraining[$iUnit] += $num
			$barracksTrainingTime[$barracksNumber] += $num*$UnitTime[$iUnit]

			; If $ArmyTraining[$iUnit] > 0 Then
			; 	SetLog("In training " & $ArmyTraining[$iUnit] & " " & $UnitName[$iUnit])
			; EndIf
		Next

		; SetLog("Barracks " & $barracksNumber & ":" & $barracksTrainingTime[$barracksNumber])

		$barracksNumber += 1
		; SetLog("Moving to barracks " & $barracksNumber+1 & "/" & numBarracksAvaiables + $numDarkBarracksAvaiables)
		_TrainMoveBtn(+1) ;click Next button
	WEnd

	If _Sleep($iDelayTrain2) Then Return

	; 3. Figure out what is left to train for our desired comp.
	; Extra stuff will be in ArmyToTrain as a negative number as it's stuff that's trained or training that wasn't in my comp

	; Build what I was going to. It will build too much. Troop capacity will reach 200 with some leftover troops. Next pass through they'll either (likely since they'll probably be archers barbs or goblins) be absorbed into the proper composition or treated as "extras" but they're not "bad" since they're the tail end of a proper build.
	; I'll do this in the above loop.

	; remove already trained troops and troops in training
	Local $ArmyToTrain = $ArmyComposition

	For $i = 0 To $iArmyEnd-1
		$ArmyToTrain[$i] -= $ArmyTraining[$i]
		$ArmyToTrain[$i] -= $ArmyTrained[$i]
		If $ArmyToTrain[$i] < 0 Then
			SetLog("Found " & -$ArmyToTrain[$i] & " extra " & $UnitName[$i] &"(s)")
		EndIf
		If $ArmyToTrain[$i] > 0 Then
			SetLog("+" & $ArmyToTrain[$i] & " " & $UnitName[$i])
		EndIf
	Next

	; 4. Assign troops to barracks.

	; How about I find the barracks with the lowest train time and put the highest train time unit into it. Repeat until I'm out of units.

	Local $barracksTraining[$numBarracksAvaiables + $numDarkBarracksAvaiables][$iArmyEnd]

	While findLongestUnit($ArmyToTrain) >= 0
		Local $longestUnit = findLongestUnit($ArmyToTrain)
		Local $lowBarracks = getShortestBarracks($longestUnit, $barracksTrainingTime)
		$barracksTrainingTime[$lowBarracks] += $UnitTime[$longestUnit]
		$barracksTraining[$lowBarracks][$longestUnit] += 1
		$ArmyToTrain[$longestUnit] -= 1
	WEnd

	If $fullarmy = True Then SetLog("Build troops before attacking.")

	$barracksNumber = 0
	Click($btnpos[$Firstbarrack][0], $btnpos[$Firstbarrack][1], 1, $iDelayTrain5, "#0336") ; Click on tab 
	If _Sleep($iDelayTrain3) Then Return
	While isBarrack() Or isDarkBarrack()
		If $debugSetlog = 1 Then SetLog("====== Checking available Barrack: " & $barracksNumber & " ======", $COLOR_PURPLE)

		If Not (IsTrainPage()) Then Return
		If $barracksNumber >= $numBarracksAvaiables + $numDarkBarracksAvaiables Then ExitLoop

		SetLog("Barracks " & $barracksNumber)
		For $iUnit In $UnitTrainOrder
			If $barracksTraining[$barracksNumber][$iUnit] > 0 Then
				SetLog("  " & $UnitName[$iUnit] & ": " & $barracksTraining[$barracksNumber][$iUnit])
				TrainIt(Eval("e" & $UnitShortName[$iUnit]), $barracksTraining[$barracksNumber][$iUnit])
			EndIf
			If _Sleep($iDelayTrain1) Then ExitLoop
		Next

		$barracksNumber += 1
		; SetLog("Moving to barracks " & $barracksNumber+1 & "/" & $numBarracksAvaiables + $numDarkBarracksAvaiables)
		_TrainMoveBtn(+1) ;click Next button
		If _Sleep($iDelayTrain2) Then Return
	WEnd


	If _Sleep($iDelayTrain4) Then Return
	BrewSpells() ; Create Spells


	If _Sleep($iDelayTrain4) Then Return
	ClickP($aAway, 2, $iDelayTrain5, "#0504"); Click away twice with 250ms delay
	$FirstStart = False

	;;;;;; Protect Army cost stats from being missed up by DC and other errors ;;;;;;;
	If _Sleep($iDelayTrain4) Then Return
	VillageReport(True, True)

	$tempCounter = 0
	While ($iElixirCurrent = "" Or ($iDarkCurrent = "" And $iDarkStart <> "")) And $tempCounter < 30
		$tempCounter += 1
		If _Sleep(100) Then Return
		VillageReport(True, True)
	WEnd

	If $tempElixir <> "" And $iElixirCurrent <> "" Then
		$tempElixirSpent = ($tempElixir - $iElixirCurrent)
		$iTrainCostElixir += $tempElixirSpent
		$iElixirTotal -= $tempElixirSpent
	EndIf

	If $tempDElixir <> "" And $iDarkCurrent <> "" Then
		$tempDElixirSpent = ($tempDElixir - $iDarkCurrent)
		$iTrainCostDElixir += $tempDElixirSpent
		$iDarkTotal -= $tempDElixirSpent
	EndIf

	UpdateStats()

EndFunc

; this will figure out my target army based on 
Func getArmyComposition($capacity = $TotalCamp)
	; Resource based troop comp
	; Ok the code in here is pretty hacky and fragile.
	; The [troop]Comp variables hold how many of the thing we want

	; set up some variables to use for testing


	; army composition calculations

	; tanks: Golem, Giant
	; melee: Pekka, Valk, Barbs
	; ranged: Wizard, Archer
	; resource: Goblin


SetLog("Composition calculations")

	Local $newArmyComp[$iArmyEnd]
	ZeroArray($newArmyComp)

	; resource calculations

	Local $totalElixir = 6000000
	Local $reserveElixir = 4000000
	Local $weightedElixir = (Number($iElixirCurrent) - $reserveElixir) / ($totalElixir - $reserveElixir)
	Local $totalDarkElixir = 80000
	Local $reserveDarkElixir = 40000
	Local $weightedDarkElixir = (Number($iDarkCurrent) - $reserveDarkElixir) / ($totalDarkElixir - $reserveDarkElixir)
	$weightedDarkElixir = $weightedDarkElixir / 3 ; This is an estimate of relative dark elixir value

	SetLog("Weighted Elixir = " & $weightedElixir)
	SetLog("Weighted Dark Elixir = " & $weightedDarkElixir)

	Local $elixirRatio = $weightedElixir / ($weightedElixir + $weightedDarkElixir)
	Local $darkElixirRatio = 1 - $elixirRatio

	SetLog("Elixir ratio = " & $elixirRatio)


	Local $tankPerc = .3
	Local $meleePerc = .2
	Local $rangedPerc = .4
	Local $resourcePerc = .1

	Local $tankCount = Round($tankPerc * $capacity)
	Local $meleeCount = Round($meleePerc * $capacity)
	Local $rangedCount = Round($rangedPerc * $capacity)
	Local $resourceCount = Round($resourcePerc * $capacity)

	Local $troopCount = $capacity

	Local $darkTankCount = Round($tankCount * $darkElixirRatio)	
	Local $darkMeleeCount = Round($meleeCount * $darkElixirRatio)

	; I don't have a good solution for how to pick which troops but given that it's a closed set a semi-hard coded solution will do to start
	; 1. Figure dark elixir troops
	;	a. apply dark elixir ratio to each category with a dark elixir option to figure the dark elixir availability for the slot
	;   b. build some dark elixir troops to fill that space.
	;   c. subtract from the slot count
	; 2. Figure elixir troops
	;	a. After accounting for the dark elixir troops there's no more than 2 options for each category. Use the weightedElixir to figure how many slots for expensive troops vs cheap troops.
	;	b. Build the expensive troops to fill the available slots then finish with cheap ones.

	; Tank	
	
	$newArmyComp[$iGolem] = Floor($darkTankCount/$UnitSize[$iGolem])
	SetLog("Golems: " & $newArmyComp[$iGolem])

	$darkTankCount -= $newArmyComp[$iGolem]*$UnitSize[$iGolem]
	$tankCount -= $newArmyComp[$iGolem]*$UnitSize[$iGolem]
	$troopCount -= $newArmyComp[$iGolem]*$UnitSize[$iGolem]

	$newArmyComp[$iGiant] = Floor($tankCount/$UnitSize[$iGiant])
	SetLog("Giants: " & $newArmyComp[$iGiant])

	$tankCount -= $newArmyComp[$iGiant]*$UnitSize[$iGiant]
	$troopCount -= $newArmyComp[$iGiant]*$UnitSize[$iGiant]

	; Melee
	; Apply left over slots to melee counts
	SetLog("Leftover tank slots: T:" & $tankCount & " DE:" & $darkMeleeCount)
	$darkMeleeCount += $darkTankCount
	$meleeCount += $tankCount

	; check valks	
	$newArmyComp[$iValkyrie] = Floor($darkMeleeCount/$UnitSize[$iValkyrie])
	SetLog("Valks: " & $newArmyComp[$iValkyrie])

	$darkMeleeCount -= $newArmyComp[$iValkyrie]*$UnitSize[$iValkyrie]
	$meleeCount -= $newArmyComp[$iValkyrie]*$UnitSize[$iValkyrie]
	$troopCount -= $newArmyComp[$iValkyrie]*$UnitSize[$iValkyrie]

	; check pekkas
	Local $bigMeleeCount = Round($meleeCount * $weightedElixir)
	$newArmyComp[$iPekka] = Floor($bigMeleeCount/$UnitSize[$iPekka])
	SetLog("Pekkas: " & $newArmyComp[$iPekka])

	$meleeCount -= $newArmyComp[$iPekka]*$UnitSize[$iPekka]
	$troopCount -= $newArmyComp[$iPekka]*$UnitSize[$iPekka]

	$newArmyComp[$iBarbarian] = $meleeCount
	SetLog("Barbs: " & $newArmyComp[$iBarbarian])

	$troopCount -= $newArmyComp[$iBarbarian]

	; Ranged
	Local $bigRangedCount = Round($rangedCount * $weightedElixir)	
	
	; check Wizards
	$newArmyComp[$iWizard] = Floor($bigRangedCount/$UnitSize[$iWizard])
	SetLog("Wizards: " & $newArmyComp[$iWizard])

	$rangedCount -= $newArmyComp[$iWizard]*$UnitSize[$iWizard]
	$troopCount -= $newArmyComp[$iWizard]*$UnitSize[$iWizard]

	$newArmyComp[$iArcher] = $rangedCount ; remainder goes to archers
	SetLog("Archers: " & $newArmyComp[$iArcher])

	$troopCount -= $newArmyComp[$iArcher]

	; Gobbos ; I've done everything else so the rest goes into goblins.
	$newArmyComp[$iGoblin] = $troopCount
	SetLog("Gobbos: " & $newArmyComp[$iGoblin])

	Return $newArmyComp
EndFunc



Func findLongestUnit($units)
	Local $max = 0, $maxi = -1

	For $i = 0 to $iArmyEnd-1
		If $units[$i] > 0 Then
			If $UnitTime[$i] > $max Then
				$max = $UnitTime[$i]
				$maxi = $i
			EndIf
		EndIf
	Next
	return $maxi
EndFunc

Func getNumTraining($iUnit, $darkBarracks = False)
	If $UnitIsDark[$iUnit] <> $darkBarracks Then Return 0

	Local $posArray = $TroopNamePosition
	If $darkBarracks Then
		$posArray = $TroopDarkNamePosition
	EndIf

	Local $i = getBotIndex($iUnit)
	$heightTroop = 296 + $midOffsetY
	$positionTroop = $posArray[$i]
	If $posArray[$i] > 4 Then
		$heightTroop = 403 + $midOffsetY
		$positionTroop = $posArray[$i] - 5
	EndIf

	Local $num = Number(getBarracksTroopQuantity(175 + 107 * $positionTroop, $heightTroop))			
	
	; There's a bug in the bot code resulting in reporting 222 healers being trained if the camp is full.
	; Since the max capacity of a barracks is 75 we'll consider any reports higher than that as a misread.
	; If they add support for larger barracks at some point this will have to be readdressed.
	If $num > 75 Then
		$num = 0
	EndIf

	Return $num
EndFunc

Func getShortestBarracks($iUnit, $barracksTrainingTime)
	Local $bTime
	Local $offset = 0
	If $UnitIsDark[$iUnit] Then
		$bTime = _ArrayExtract($barracksTrainingTime, $numBarracksAvaiables, UBound($barracksTrainingTime)-1)
		$offset = $numBarracksAvaiables 
		SetLog("Offset " & $offset)
	Else
		$bTime = _ArrayExtract($barracksTrainingTime, 0, $numBarracksAvaiables-1)
	EndIf

	Return _ArrayMinIndex($bTime) + $offset
EndFunc

Func dumpUnitArray($unitArray)
	For $iUnit = 0 To $iArmyEnd-1
		SetLog($UnitName[$iUnit] & " : " & $unitArray[$iUnit])
	Next
EndFunc