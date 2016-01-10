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

	If goHome() == False Then Return
	If goArmyOverview() == False Then Return			

	checkAttackDisable($iTaBChkIdle) ; Check for Take-A-Break after opening train page
	
	; Determine training
	; 1. Figure out what we've already trained. (This is done above in checkArmyCamp)
	; 2. Figure out what we have in training.
	;	a. figure out how much time is already in each barracks
	; 3. Figure out what is left to train for our desired comp.
	; 4. Assign troops to barracks.
	;;;;;

	; 1. Figure out what we've already trained. (This is done above in checkArmyCamp)

SetLog("Currently trained:")
	ZeroArray($ArmyTrained) ; Zero out the in-training array before we check the camp. checkArmyCamp populates this
	checkArmyCamp()

	; 2. Figure out what we have in training.
	;	a. figure out how much time is already in each barracks

SetLog("Currently in training:")
	Local $barracksTrainingTime[$numBarracksAvaiables + $numDarkBarracksAvaiables]
	Local $barracksTrainingSpace[$numBarracksAvaiables + $numDarkBarracksAvaiables]

	Local $barracksNumber = 0

	Local $blockedBarracks[$numBarracksAvaiables+$numDarkBarracksAvaiables]
	Local $numBlockedBarracks = 0

	If goHome() == False Then Return
	If goArmyOverview() == False Then Return	
	goToBarracks(0)

	ZeroArray($ArmyTraining)
	While isBarrack() Or isDarkBarrack()
		If $barracksNumber >= $numBarracksAvaiables + $numDarkBarracksAvaiables Then ExitLoop

		SetLog("Barracks " & $barracksNumber)

		Local $darkBarracks = isDarkBarrack()
		For $iUnit = 0 to $iArmyEnd-1
			Local $num = getNumTraining($iUnit, $darkBarracks)
			$ArmyTraining[$iUnit] += $num
			$barracksTrainingTime[$barracksNumber] += $num*$UnitTime[$iUnit]
			$barracksTrainingSpace[$barracksNumber] += $num*$UnitSize[$iUnit]

			If $num > 0 Then
				SetLog("  " & $num & " " & $UnitName[$iUnit])
			EndIf
		Next

		; SetLog("Checking barracks " & $barracksNumber)
		$blockedBarracks[$barracksNumber] = CheckFullBarrack()
		If $blockedBarracks[$barracksNumber] Then
			SetLog("Found blocked barracks: " & $barracksNumber)
			$numBlockedBarracks += 1
		EndIf

		; SetLog("Barracks " & $barracksNumber & ":" & $barracksTrainingTime[$barracksNumber])

		$barracksNumber += 1
		; SetLog("Moving to barracks " & $barracksNumber+1 & "/" & $numBarracksAvaiables + $numDarkBarracksAvaiables)
		_TrainMoveBtn(+1) ;click Next button
		If _Sleep($iDelayTrain2) Then Return
	WEnd

SetLog("Check for deadlocks:")
	; check for deadlock.
	; A deadlock is when 1 or more barracks is blocked and all other barracks are not training.
	; this is not a very aggressive check and could waste some time but it'll probably do for now.
	If $numBlockedBarracks > 0 And $CurCamp <> $TotalCamp Then	
		If $numBlockedBarracks == $numBarracksAvaiables Then ; Hard deadlock.
			SetLog("Hard deadlock")
			; Gotta stop training on something. Probably the barracks with the least training.
			Local $bestBarracks
			Local $bestBarracksSpace = 9999
			SetLog("Finding best barracks to clean out")
			For $barracksNumber = 0 To $numBarracksAvaiables-1
				Local $blockedTrainingSpace = 0
				; SetLog("Find blocked space in barracks " & $barracksNumber)
				$blockedTrainingSpace += $barracksTrainingSpace[$barracksNumber]
				; SetLog("Checking if this is the best one")
				If $blockedTrainingSpace < $bestBarracksSpace Then
					$bestBarracks = $barracksNumber
					$bestBarracksSpace = $blockedTrainingSpace
				EndIf
			Next
			; Stop training all troops in $bestBarracks

			If goHome() == False Then Return
			If goArmyOverview() == False Then Return			
			goToBarracks($bestBarracks)
			clearTroops()

			; Set capacity to what we need for a full army.
			SetLog("Train " & $TotalCamp - $CurCamp & " Archers")
			TrainIt($eArch, $TotalCamp - $CurCamp)
		Else ; Possible deadlock
			SetLog("Possible deadlock")

			; There's significant room for improvement here.
			; I think this will always either get us out of deadlock or let it escalate to a full deadlock
			; which we can get out of.

			Local $unblockedTrainingSpace = 0
			For $barracksNumber = 0 To $numBarracksAvaiables-1
				If $blockedBarracks[$barracksNumber] == False Then ; check for troops training in unblocked barracks
					; If there are we could leave it alone or we could check all of the barracks to
					; see if we'll get an attackable army...

					; ; Count up the space we have training in unblocked barracks
					; For $iUnit = 0 To $iArmyEnd-1
					; 	$unblockedTrainingSpace += $barracksTrainingSpace[$barracksNumber]
					; Next
					; Find out if there's a gap between what's training and a complete army
					; If there is... fill it (by making a limited size army comp and training). 
					; If there isn't ignore it.

					SetLog("Train " & $TotalCamp - $CurCamp & " Archers")

					If goHome() == False Then Return
					If goArmyOverview() == False Then Return			
					goToBarracks($barracksNumber)

					TrainIt($eArch, $TotalCamp - $CurCamp)
					ExitLoop
				EndIf	
			Next
		EndIf
	EndIf


	If _Sleep($iDelayTrain2) Then Return

	; 3. Figure out what is left to train for our desired comp.
	; Extra stuff will be in ArmyToTrain as a negative number as it's stuff that's trained or training that wasn't in my comp

	; Build what I was going to. It will build too much. Troop capacity will reach 200 with some leftover troops. Next pass through they'll either (likely since they'll probably be archers barbs or goblins) be absorbed into the proper composition or treated as "extras" but they're not "bad" since they're the tail end of a proper build.
	; I'll do this in the above loop.

SetLog("Get army composition:")
	; figure already trained troops and add the ones in training
	Local $currentArmy = $ArmyTrained
	For $i = 0 To $iArmyEnd-1
		$currentArmy[$i] += $ArmyTraining[$i]
	Next

	$ArmyToTrain = getArmyComposition($currentArmy)

	SetLog("Army to train: " & getArmySize($ArmyToTrain))
	dumpUnitArray($ArmyToTrain)

	$ArmyComposition = $ArmyToTrain
	For $i = 0 To $iArmyEnd-1
		$ArmyComposition[$i] += $currentArmy[$i]
	Next

	SetLog("Final army: " & getArmySize($ArmyComposition))
	dumpUnitArray($ArmyComposition)

SetLog("Assign to barracks:")
	; 4. Assign troops to barracks.

	; How about I find the barracks with the lowest train time and put the highest train time unit into it. Repeat until I'm out of units.

	Local $needTraining = False
	Local $barracksTraining[$numBarracksAvaiables + $numDarkBarracksAvaiables][$iArmyEnd]

	While findLongestUnit($ArmyToTrain) >= 0
		Local $needTraining = True
		Local $longestUnit = findLongestUnit($ArmyToTrain)
		Local $lowBarracks = getShortestBarracks($longestUnit, $barracksTrainingTime)
		$barracksTrainingTime[$lowBarracks] += $UnitTime[$longestUnit]
		$barracksTraining[$lowBarracks][$longestUnit] += 1
		$ArmyToTrain[$longestUnit] -= 1
	WEnd

	If $fullarmy = True Then SetLog("Build troops before attacking.")

SetLog("Train troops:")
	If $needTraining == True Then
		If goHome() == False Then Return
		If goArmyOverview() == False Then Return	
		goToBarracks(0)

		$barracksNumber = 0
		While isBarrack() Or isDarkBarrack()
			If $debugSetlog = 1 Then SetLog("====== Checking available Barrack: " & $barracksNumber & " ======", $COLOR_PURPLE)

			If Not (IsTrainPage()) Then Return
			If $barracksNumber >= $numBarracksAvaiables + $numDarkBarracksAvaiables Then ExitLoop

			SetLog("Barracks " & $barracksNumber)
			For $iUnit In $UnitTrainOrder
				If $barracksTraining[$barracksNumber][$iUnit] > 0 Then
					SetLog("  " & $UnitName[$iUnit] & ": " & $barracksTraining[$barracksNumber][$iUnit])
					TrainIt(Eval("e" & $UnitShortName[$iUnit]), $barracksTraining[$barracksNumber][$iUnit])
					If _Sleep($iDelayTrain1) Then ExitLoop
				EndIf
			Next

			$barracksNumber += 1
			; SetLog("Moving to barracks " & $barracksNumber+1 & "/" & $numBarracksAvaiables + $numDarkBarracksAvaiables)
			_TrainMoveBtn(+1) ;click Next button
			If _Sleep($iDelayTrain2) Then Return
		WEnd
	EndIf

SetLog("End train")

	If _Sleep($iDelayTrain4) Then Return
	BrewSpells() ; Create Spells


	If _Sleep($iDelayTrain4) Then Return
	ClickP($aAway, 2, $iDelayTrain5, "#0504"); Click away twice with 250ms delay
	$FirstStart = False

	;;;;;; Protect Army cost stats from being messed up by DC and other errors ;;;;;;;
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
Func getArmyComposition($currentArmy)
	Local $capacity = $TotalCamp
	; Resource based troop comp
	; Ok the code in here is pretty hacky and fragile.
	; The [troop]Comp variables hold how many of the thing we want

	; set up some variables to use for testing


	SetLog("Current army: "&getArmySize($currentArmy))
	dumpUnitArray($currentArmy)

	; army composition calculations

	Local $TankUnits[2] = [$iGolem, $iGiant]
	Local $MeleeUnits[3] = [$iPekka, $iValkyrie, $iBarbarian]
	Local $RangedUnits[2] = [$iWizard, $iArcher]
	Local $ResourceUnits[1] = [$iGoblin]

	Local $newArmyComp[$iArmyEnd]
	ZeroArray($newArmyComp)

	; resource calculations

	Local $totalElixir = 6000000
	Local $reserveElixir = 2000000
	Local $weightedElixir = (Number($iElixirCurrent) - $reserveElixir) / ($totalElixir - $reserveElixir)
	Local $totalDarkElixir = 80000
	Local $reserveDarkElixir = 40000
	Local $weightedDarkElixir = (Number($iDarkCurrent) - $reserveDarkElixir) / ($totalDarkElixir - $reserveDarkElixir)
	$weightedDarkElixir = $weightedDarkElixir / 3 ; This is an estimate of relative dark elixir value

	SetLog("  Weighted Elixir = " & $weightedElixir)
	SetLog("  Weighted Dark Elixir = " & $weightedDarkElixir)

	Local $elixirRatio = $weightedElixir / ($weightedElixir + $weightedDarkElixir)
	Local $darkElixirRatio = 1 - $elixirRatio

	SetLog("Elixir ratio = " & $elixirRatio)


	Local $tankPerc = .3
	Local $meleePerc = .2
	Local $rangedPerc = .4
	Local $resourcePerc = .1

	; Desired number of troops of each type for the army
	Local $troopCount = $capacity
	SetLog("Capacity: " & $troopCount)
	Local $tankCount = Round($tankPerc * $capacity) 	
	Local $meleeCount = Round($meleePerc * $capacity)
	Local $rangedCount = Round($rangedPerc * $capacity)
	Local $resourceCount = Round($resourcePerc * $capacity)

	; reduce these by the number of each we already have in our army

	For $iUnit = 0 To $iArmyEnd-1
		If $currentArmy[$iUnit] > 0 Then
			If _ArraySearch($TankUnits, $iUnit) <> -1 Then
				$tankCount -= $currentArmy[$iUnit]*$UnitSize[$iUnit]				
			ElseIf _ArraySearch($MeleeUnits, $iUnit) <> -1 Then
				$meleeCount -= $currentArmy[$iUnit]*$UnitSize[$iUnit]
			ElseIf _ArraySearch($RangedUnits, $iUnit) <> -1 Then
				$rangedCount -= $currentArmy[$iUnit]*$UnitSize[$iUnit]
			ElseIf _ArraySearch($ResourceUnits, $iUnit) <> -1 Then
				$resourceCount -= $currentArmy[$iUnit]*$UnitSize[$iUnit]
			EndIf
			$troopCount -= $currentArmy[$iUnit]*$UnitSize[$iUnit]
		EndIf
	Next

	If $tankCount < 0 Then $tankCount = 0
	If $meleeCount < 0 Then $meleeCount = 0
	If $rangedCount < 0 Then $rangedCount = 0
	If $resourceCount < 0 Then $resourceCount = 0
	If $troopCount < 0 Then $troopcount = 0

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
	
	SetLog("Type counts: [T]: " & $tankCount & " [M]: " & $meleeCount & " [R]: " & $rangedCount & " [r]:" & $resourceCount)

	$newArmyComp[$iGolem] = Floor($darkTankCount/$UnitSize[$iGolem])

	$darkTankCount -= $newArmyComp[$iGolem]*$UnitSize[$iGolem]
	$tankCount -= $newArmyComp[$iGolem]*$UnitSize[$iGolem]
	$troopCount -= $newArmyComp[$iGolem]*$UnitSize[$iGolem]

	$newArmyComp[$iGiant] = Floor($tankCount/$UnitSize[$iGiant])

	$tankCount -= $newArmyComp[$iGiant]*$UnitSize[$iGiant]
	$troopCount -= $newArmyComp[$iGiant]*$UnitSize[$iGiant]

	; Melee
	; Apply left over slots to melee counts
	SetLog("    Leftover tank slots: T:" & $tankCount & " DE:" & $darkMeleeCount)
	$darkMeleeCount += $darkTankCount
	$meleeCount += $tankCount

	; check valks	
	$newArmyComp[$iValkyrie] = Floor($darkMeleeCount/$UnitSize[$iValkyrie])

	$darkMeleeCount -= $newArmyComp[$iValkyrie]*$UnitSize[$iValkyrie]
	$meleeCount -= $newArmyComp[$iValkyrie]*$UnitSize[$iValkyrie]
	$troopCount -= $newArmyComp[$iValkyrie]*$UnitSize[$iValkyrie]

	; check pekkas
	Local $bigMeleeCount = Round($meleeCount * $weightedElixir)
	$newArmyComp[$iPekka] = Floor($bigMeleeCount/$UnitSize[$iPekka])

	$meleeCount -= $newArmyComp[$iPekka]*$UnitSize[$iPekka]
	$troopCount -= $newArmyComp[$iPekka]*$UnitSize[$iPekka]

	$newArmyComp[$iBarbarian] = $meleeCount

	$troopCount -= $newArmyComp[$iBarbarian]

	; Ranged
	Local $bigRangedCount = Round($rangedCount * $weightedElixir)	
	
	; check Wizards
	$newArmyComp[$iWizard] = Floor($bigRangedCount/$UnitSize[$iWizard])

	$rangedCount -= $newArmyComp[$iWizard]*$UnitSize[$iWizard]
	$troopCount -= $newArmyComp[$iWizard]*$UnitSize[$iWizard]

	$newArmyComp[$iArcher] = $rangedCount ; remainder goes to archers
	SetLog("  Archers: " & $newArmyComp[$iArcher])

	$troopCount -= $newArmyComp[$iArcher]

	; Gobbos ; I've done everything else so the rest goes into goblins.
	$newArmyComp[$iGoblin] = $troopCount

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
		SetLog("Error reading " & $UnitName[$iUnit])
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
	Else
		$bTime = _ArrayExtract($barracksTrainingTime, 0, $numBarracksAvaiables-1)
	EndIf

	Return _ArrayMinIndex($bTime) + $offset
EndFunc

Func dumpUnitArray($unitArray)
	For $iUnit = 0 To $iArmyEnd-1
		If $unitArray[$iUnit] <> 0 Then
			SetLog($UnitName[$iUnit] & " : " & $unitArray[$iUnit])
		EndIf
	Next
EndFunc

Func getArmySize($army)
	Local $size = 0
	For $iUnit = 0 To $iArmyEnd-1
		$size += $army[$iUnit]*$UnitSize[$iUnit]
	Next
	Return $size
EndFunc