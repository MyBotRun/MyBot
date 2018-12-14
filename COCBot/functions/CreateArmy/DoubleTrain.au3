
; #FUNCTION# ====================================================================================================================
; Name ..........: Double Train
; Description ...:
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Demen
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func DoubleTrain($bQuickTrain = False, $bSetlog = True)

	If Not $g_bDoubleTrain Then Return
	Local $bDebug = $g_bDebugSetlogTrain Or $g_bDebugSetlog
	If $bDebug Then $bSetlog = True

	If $bDebug then SetLog($bQuickTrain ? " ==  Double Quick Train == " : " ==  Double Train == ", $COLOR_ACTION)

	StartGainCost()
	CheckIfArmyIsReady()

	Local $bNeedReCheckTroopTab = False, $bNeedReCheckSpellTab = False
	Local $bSavedFullArmyValue = $g_bIsFullArmywithHeroesAndSpells
	$g_bIsFullArmywithHeroesAndSpells = False ; this is to force RemoveExtraTroopsQueue()

	If $bQuickTrain Then
		DoubleQuickTrain($bSetlog, $bDebug)
		$g_bIsFullArmywithHeroesAndSpells = $bSavedFullArmyValue ; release
		EndGainCost("Train")
		Return
	EndIf

	; Troop
	If Not OpenTroopsTab(False, "DoubleTrain()") Then Return
	If _Sleep(250) Then Return

	Local $Step = 1
	While 1
		Local $TroopCamp = GetCurrentArmy(48, 160)
		If $bSetlog Then SetLog("Checking Troop tab: " & $TroopCamp[0] & "/" & $TroopCamp[1] * 2)
		If $TroopCamp[1] = 0 Then ExitLoop
		If $bSetlog And $TroopCamp[1] <> $g_iTotalCampSpace Then _
			SetLog("Incorrect Troop combo: " & $g_iTotalCampSpace & " vs Total camp: " & $TroopCamp[1] & @CRLF & "                 Double train may not work well", $COLOR_DEBUG)

		If $TroopCamp[0] < $TroopCamp[1] Then ; <280/280
			If $g_bDonationEnabled And $g_bChkDonate And MakingDonatedTroops("Troops") Then
				If $bDebug Then SetLog($Step & ". MakingDonatedTroops('Troops')", $COLOR_DEBUG)
				$Step += 1
				If $Step = 6 Then ExitLoop
				ContinueLoop
			EndIf
			If Not IsQueueEmpty("Troops", False, False) Then DeleteQueued("Troops")
			$bNeedReCheckTroopTab = True
			If $bDebug Then SetLog($Step & ". DeleteQueued('Troops'). $bNeedReCheckTroopTab: " & $bNeedReCheckTroopTab, $COLOR_DEBUG)

		ElseIf $TroopCamp[0] = $TroopCamp[1] Then ; 280/280
			TrainFullQueue()
			If $bDebug Then SetLog($Step & ". TrainFullQueue() done!", $COLOR_DEBUG)

		ElseIf $TroopCamp[0] <= $TroopCamp[1] * 2 Then ; 281-540/540
			If CheckQueueTroopAndTrainRemain($TroopCamp, $bDebug) Then
				If $bDebug Then SetLog($Step & ". CheckQueueAndTrainRemain() done!", $COLOR_DEBUG)
			Else
				RemoveExtraTroopsQueue()
				If _Sleep(500) Then Return
				If $bDebug Then SetLog($Step & ". RemoveExtraTroopsQueue()", $COLOR_DEBUG)
				$Step += 1
				If $Step = 6 Then ExitLoop
				ContinueLoop
			EndIf
		EndIf
		ExitLoop
	WEnd

	; Spell
	Local $TotalSpellsToBrewInGUI = Number(TotalSpellsToBrewInGUI())
	If $TotalSpellsToBrewInGUI = 0 Then
		If $bDebug Then SetLog("No spell is required, skip checking spell tab", $COLOR_DEBUG)
	Else
		If Not OpenSpellsTab(False, "DoubleTrain()") Then Return
		If _Sleep(250) Then Return
		$Step = 1
		While 1
			Local $SpellCamp = GetCurrentArmy(43, 160)
			If $bSetlog Then SetLog("Checking Spell tab: " & $SpellCamp[0] & "/" & $SpellCamp[1] * 2)
			If $SpellCamp[1] = 0 Then ExitLoop
			Local $TotalSpell = _Min(Number($TotalSpellsToBrewInGUI), Number($g_iTotalSpellValue))
			If $bDebug Then SetLog("$TotalSpellsToBrewInGUI = " & $TotalSpellsToBrewInGUI & ", $g_iTotalSpellValue = " & $g_iTotalSpellValue & ", _Min = " & $TotalSpell, $COLOR_DEBUG)
			If $SpellCamp[1] <> $TotalSpellsToBrewInGUI Or $SpellCamp[1] <> $g_iTotalSpellValue Then
				If $bSetlog And Not $g_bForceBrewSpells Then SetLog("Incorrect Spell combo: " & $TotalSpellsToBrewInGUI & "/" & $g_iTotalSpellValue & _
																	" vs Total camp: " & $SpellCamp[1] & @CRLF & "                 Double train may not work well", $COLOR_DEBUG)
				If $g_bForceBrewSpells And $SpellCamp[1] > $TotalSpell Then $SpellCamp[1] = $TotalSpell
			EndIf

			If $SpellCamp[0] < $SpellCamp[1] Then ; 0-10/11
				If $g_bDonationEnabled And $g_bChkDonate And MakingDonatedTroops("Spells") Then
					If $bDebug Then SetLog($Step & ". MakingDonatedTroops('Spells')", $COLOR_DEBUG)
					$Step += 1
					If $Step = 6 Then ExitLoop
					ContinueLoop
				EndIf
				If Not IsQueueEmpty("Spells", False, False) Then DeleteQueued("Spells")
				$bNeedReCheckSpellTab = True
				If $bDebug Then SetLog($Step & ". DeleteQueued('Spells'). $bNeedReCheckSpellTab: " & $bNeedReCheckSpellTab, $COLOR_DEBUG)

			ElseIf $SpellCamp[0] = $SpellCamp[1] Then ; 11/22
				TrainFullQueue(True) ;
				If $bDebug Then SetLog($Step & ". TrainFullQueue(True) done!", $COLOR_DEBUG)

			ElseIf $SpellCamp[0] <= $SpellCamp[1] * 2 Then ; 12-22/22
				If CheckQueueSpellAndTrainRemain($SpellCamp, $bDebug) Then
					If $bDebug Then SetLog($Step & ". CheckQueueSpellAndTrainRemain() done!", $COLOR_DEBUG)
				Else
					RemoveExtraTroopsQueue()
					If _Sleep(500) Then Return
					If $bDebug Then SetLog($Step & ". RemoveExtraTroopsQueue()", $COLOR_DEBUG)
					$Step += 1
					If $Step = 6 Then ExitLoop
					ContinueLoop
				EndIf
			EndIf
			ExitLoop
		WEnd
	EndIf

	If $bNeedReCheckTroopTab Or $bNeedReCheckSpellTab Then
		Local $aWhatToRemove = WhatToTrain(True)
		Local $rRemoveExtraTroops = RemoveExtraTroops($aWhatToRemove)
		If $bDebug Then SetLog("RemoveExtraTroops(): " & $rRemoveExtraTroops, $COLOR_DEBUG)

		If $rRemoveExtraTroops = 1 Or $rRemoveExtraTroops = 2 Then
			For $i = 0 To UBound($aWhatToRemove) - 1
				If _ArraySearch($g_asTroopShortNames, $aWhatToRemove[$i][0]) >= 0 Then $bNeedReCheckTroopTab = True
				If _ArraySearch($g_asSpellShortNames, $aWhatToRemove[$i][0]) >= 0 Then $bNeedReCheckSpellTab = True
				If $bNeedReCheckTroopTab And $bNeedReCheckSpellTab Then ExitLoop
			Next
			If $bDebug Then SetLog("$bNeedReCheckTroopTab: " & $bNeedReCheckTroopTab & "$bNeedReCheckSpellTab: " & $bNeedReCheckSpellTab, $COLOR_DEBUG)
		EndIf

		Local $aWhatToTrain = WhatToTrain()
		If $bNeedReCheckTroopTab Then
			TrainUsingWhatToTrain($aWhatToTrain) ; troop
			TrainFullQueue(False)
			If $bDebug Then SetLog("TrainFullQueue() done.", $COLOR_DEBUG)
		EndIf
		If $bNeedReCheckSpellTab Then
			TrainUsingWhatToTrain($aWhatToTrain, True) ; spell
			TrainFullQueue(True)
			If $bDebug Then SetLog("TrainFullQueue('True') done.", $COLOR_DEBUG)
		EndIf
	EndIf

	If _Sleep(250) Then Return
    DoubleTrainSiege($bDebug)

	ClickP($aAway, 2, 0, "#0346") ;Click Away
	If _Sleep(250) Then Return

	$g_bIsFullArmywithHeroesAndSpells = $bSavedFullArmyValue ; release

	If $g_bDonationEnabled And $g_bChkDonate Then ResetVariables("donated")
	EndGainCost("Train")
	checkAttackDisable($g_iTaBChkIdle) ; Check for Take-A-Break after opening train page

EndFunc   ;==>DoubleTrain

Func TrainFullQueue($bSpellOnly = False)
	Local $ToReturn[1][2] = [["Arch", 0]]
	; Troops
	For $i = 0 To $eTroopCount - 1
		Local $troopIndex = $g_aiTrainOrder[$i]
		If $g_aiArmyCompTroops[$troopIndex] > 0 Then
			$ToReturn[UBound($ToReturn) - 1][0] = $g_asTroopShortNames[$troopIndex]
			$ToReturn[UBound($ToReturn) - 1][1] = $g_aiArmyCompTroops[$troopIndex]
			ReDim $ToReturn[UBound($ToReturn) + 1][2]
		EndIf
	Next
	; Spells
	For $i = 0 To $eSpellCount - 1
		Local $BrewIndex = $g_aiBrewOrder[$i]
		If TotalSpellsToBrewInGUI() = 0 Then ExitLoop
		If $g_aiArmyCompSpells[$BrewIndex] > 0 Then
			$ToReturn[UBound($ToReturn) - 1][0] = $g_asSpellShortNames[$BrewIndex]
			$ToReturn[UBound($ToReturn) - 1][1] = $g_aiArmyCompSpells[$BrewIndex]
			ReDim $ToReturn[UBound($ToReturn) + 1][2]
		EndIf
	Next

	If $ToReturn[0][0] = "Arch" And $ToReturn[0][1] = 0 Then Return

	Local $bSavedFullArmyValue = $g_bIsFullArmywithHeroesAndSpells
	$g_bIsFullArmywithHeroesAndSpells = True

	TrainUsingWhatToTrain($ToReturn, $bSpellOnly)
	If _Sleep($bSpellOnly ? 1000 : 500) Then Return

	$g_bIsFullArmywithHeroesAndSpells = $bSavedFullArmyValue

	Local $CampOCR = GetCurrentArmy($bSpellOnly ? 43 : 48, 160)
	SetDebugLog("Checking " & ($bSpellOnly ? "spell tab: " : "troop tab: ") & $CampOCR[0] & "/" & $CampOCR[1] * 2)

EndFunc   ;==>TrainFullQueue

Func DoubleQuickTrain($bSetlog, $bDebug)

	Local $bDoubleTrainTroop = False, $bDoubleTrainSpell = False

	; Troop
	If Not OpenTroopsTab(False, "DoubleQuickTrain()") Then Return
	If _Sleep(250) Then Return
	Local $Step = 1
	While 1
		If $g_bDonationEnabled And $g_bChkDonate Then MakingDonatedTroops("Troops")
		Local $TroopCamp = GetCurrentArmy(48, 160)
		If $bSetlog Then SetLog("Checking Troop tab: " & $TroopCamp[0] & "/" & $TroopCamp[1] * 2)
		If $TroopCamp[0] > $TroopCamp[1] And $TroopCamp[0] < $TroopCamp[1] * 2 Then ; 500/520
			RemoveExtraTroopsQueue()
			If _Sleep(500) Then Return
			If $bDebug Then SetLog($Step & ". RemoveExtraTroopsQueue()", $COLOR_DEBUG)
			$Step += 1
			If $Step = 6 Then ExitLoop
			ContinueLoop
		ElseIf $TroopCamp[0] = $TroopCamp[1] * 2 Then
			$bDoubleTrainTroop = True
			If $bDebug Then SetLog($Step & ". $bDoubleTrainTroop: " & $bDoubleTrainTroop, $COLOR_DEBUG)
		EndIf
		ExitLoop
	WEnd

	; Spell
	If Not OpenSpellsTab(False, "DoubleQuickTrain()") Then Return
	If _Sleep(250) Then Return
	$Step = 1
	While 1
		If $g_bDonationEnabled And $g_bChkDonate Then MakingDonatedTroops("Spells")
		Local $SpellCamp = GetCurrentArmy(43, 160)
		If $bSetlog Then SetLog("Checking Spell tab: " & $SpellCamp[0] & "/" & $SpellCamp[1] * 2)
		If $SpellCamp[0] > $SpellCamp[1] And $SpellCamp[0] < $SpellCamp[1] * 2 Then ; 20/22
			RemoveExtraTroopsQueue()
			If _Sleep(500) Then Return
			If $bDebug Then SetLog($Step & ". RemoveExtraTroopsQueue()", $COLOR_DEBUG)
			$Step += 1
			If $Step = 6 Then ExitLoop
			ContinueLoop
		ElseIf $SpellCamp[0] = $SpellCamp[1] * 2 Then
			$bDoubleTrainSpell = True
			If $bDebug Then SetLog($Step & ". $bDoubleTrainSpell: " & $bDoubleTrainSpell, $COLOR_DEBUG)
		EndIf
		ExitLoop
	WEnd

	If Not $bDoubleTrainTroop Or Not $bDoubleTrainSpell Then
		If Not OpenQuickTrainTab(False, "DoubleQuickTrain()") Then Return
		If _Sleep(500) Then Return
		TrainArmyNumber($g_bQuickTrainArmy)
	Else
		If $bSetlog Then SetLog("Full queue, skip Double Quick Train")
	EndIf

	If _Sleep(250) Then Return
    DoubleTrainSiege($bDebug)

	ClickP($aAway, 2, 0, "#0346") ;Click Away
	If _Sleep(250) Then Return

	If $g_bDonationEnabled And $g_bChkDonate Then ResetVariables("donated")

EndFunc   ;==>DoubleQuickTrain

Func GetCurrentArmy($x_start, $y_start)

	Local $aResult[3] = [0, 0, 0]
	If Not $g_bRunState Then Return $aResult

	; [0] = Current Army  | [1] = Total Army Capacity  | [2] = Remain Space for the current Army
	Local $iOCRResult = getArmyCapacityOnTrainTroops($x_start, $y_start)

	If StringInStr($iOCRResult, "#") Then
		Local $aTempResult = StringSplit($iOCRResult, "#", $STR_NOCOUNT)
		$aResult[0] = Number($aTempResult[0])
		$aResult[1] = Number($aTempResult[1]) / 2
		$aResult[2] = $aResult[1] - $aResult[0]
	Else
		SetLog("DEBUG | ERROR on GetCurrentArmy", $COLOR_ERROR)
	EndIf

	Return $aResult

EndFunc   ;==>GetCurrentArmy

Func CheckQueueTroopAndTrainRemain($ArmyCamp, $bDebug)
	If $ArmyCamp[0] = $ArmyCamp[1] * 2 And ((ProfileSwitchAccountEnabled() And $g_abAccountNo[$g_iCurAccount] And $g_abDonateOnly[$g_iCurAccount]) Or $g_iCommandStop = 0) Then Return True ; bypass Donate account when full queue

	Local $iTotalQueue = 0
	If $bDebug Then SetLog("Checking troop queue: " & $ArmyCamp[0] & "/" & $ArmyCamp[1] * 2, $COLOR_DEBUG)

	Local $XQueueStart = 839
	For $i = 0 To 10
		If _ColorCheck(_GetPixelColor(825 - $i * 70, 186, True), Hex(0xD7AFA9, 6), 20) Then ; Pink background found
			$XQueueStart -= 70.5 * $i
			ExitLoop
		EndIf
	Next

	Local $aiQueueTroops = CheckQueueTroops(True, $bDebug, $XQueueStart)
	If Not IsArray($aiQueueTroops) Then Return False
	For $i = 0 To UBound($aiQueueTroops) - 1
		If $aiQueueTroops[$i] > 0 Then $iTotalQueue += $aiQueueTroops[$i] * $g_aiTroopSpace[$i]
	Next
	; Check block troop
	If $ArmyCamp[0] < $ArmyCamp[1] + $iTotalQueue Then
		SetLog("A big guy blocks our camp")
		Return False
	EndIf
	; check wrong queue
	For $i = 0 To UBound($aiQueueTroops) - 1
		If $aiQueueTroops[$i] - $g_aiArmyCompTroops[$i] > 0 Then
			SetLog("Some wrong troops in queue")
			Return False
		EndIf
	Next
	If $ArmyCamp[0] < $ArmyCamp[1] * 2 Then
		; Train remain
		SetLog("Checking troop queue:")
		Local $rWTT[1][2] = [["Arch", 0]] ; what to train
		For $i = 0 To UBound($aiQueueTroops) - 1
			Local $iIndex = $g_aiTrainOrder[$i]
			If $aiQueueTroops[$iIndex] > 0 Then SetLog("  - " & $g_asTroopNames[$iIndex] & ": " & $aiQueueTroops[$iIndex] & "x")
			If $g_aiArmyCompTroops[$iIndex] - $aiQueueTroops[$iIndex] > 0 Then
				$rWTT[UBound($rWTT) - 1][0] = $g_asTroopShortNames[$iIndex]
				$rWTT[UBound($rWTT) - 1][1] = Abs($g_aiArmyCompTroops[$iIndex] - $aiQueueTroops[$iIndex])
				SetLog("    missing: " & $g_asTroopNames[$iIndex] & " x" & $rWTT[UBound($rWTT) - 1][1])
				ReDim $rWTT[UBound($rWTT) + 1][2]
			EndIf
		Next
		Local $bIsFullArmywithHeroesAndSpells = $g_bIsFullArmywithHeroesAndSpells
		$g_bIsFullArmywithHeroesAndSpells = True
		TrainUsingWhatToTrain($rWTT)
		$g_bIsFullArmywithHeroesAndSpells = $bIsFullArmywithHeroesAndSpells ; release

		If _Sleep(1000) Then Return
		$ArmyCamp = GetCurrentArmy(48, 160)
		SetLog("Checking troop tab: " & $ArmyCamp[0] & "/" & $ArmyCamp[1] * 2 & ($ArmyCamp[0] < $ArmyCamp[1] * 2 ? ". Top-up queue failed!" : ""))
		If $ArmyCamp[0] < $ArmyCamp[1] * 2 Then Return False
	EndIf
	Return True
EndFunc   ;==>CheckQueueTroopAndTrainRemain

Func CheckQueueSpellAndTrainRemain($ArmyCamp, $bDebug)
	If $ArmyCamp[0] = $ArmyCamp[1] * 2 And ((ProfileSwitchAccountEnabled() And $g_abAccountNo[$g_iCurAccount] And $g_abDonateOnly[$g_iCurAccount]) Or $g_iCommandStop = 0) Then Return True ; bypass Donate account when full queue

	Local $iTotalQueue = 0
	If $bDebug Then SetLog("Checking spell queue: " & $ArmyCamp[0] & "/" & $ArmyCamp[1] * 2, $COLOR_DEBUG)

	Local $XQueueStart = 839
	For $i = 0 To 10
		If _ColorCheck(_GetPixelColor(825 - $i * 70, 186, True), Hex(0xD7AFA9, 6), 20) Then ; Pink background found
			$XQueueStart -= 70.5 * $i
			ExitLoop
		EndIf
	Next

	Local $aiQueueSpells = CheckQueueSpells(True, $bDebug, $XQueueStart)
	If Not IsArray($aiQueueSpells) Then Return False
	For $i = 0 To UBound($aiQueueSpells) - 1
		If $aiQueueSpells[$i] > 0 Then $iTotalQueue += $aiQueueSpells[$i] * $g_aiSpellSpace[$i]
	Next
	; Check block spell
	If $ArmyCamp[0] < $ArmyCamp[1] + $iTotalQueue And Not $g_bForceBrewSpells Then
		SetLog("A big guy blocks our camp")
		Return False
	EndIf
	; check wrong queue
	For $i = 0 To UBound($aiQueueSpells) - 1
		If $aiQueueSpells[$i] - $g_aiArmyCompSpells[$i] > 0 Then
			SetLog("Some wrong spells in queue")
			Return False
		EndIf
	Next
	If $ArmyCamp[0] < $ArmyCamp[1] * 2 Then
		; Train remain
		SetLog("Checking spells queue:")
		Local $rWTT[1][2] = [["Arch", 0]] ; what to train
		For $i = 0 To UBound($aiQueueSpells) - 1
			Local $iIndex = $g_aiBrewOrder[$i]
			If $aiQueueSpells[$iIndex] > 0 Then SetLog("  - " & $g_asSpellNames[$iIndex] & ": " & $aiQueueSpells[$iIndex] & "x")
			If $g_aiArmyCompSpells[$iIndex] - $aiQueueSpells[$iIndex] > 0 Then
				$rWTT[UBound($rWTT) - 1][0] = $g_asSpellShortNames[$iIndex]
				$rWTT[UBound($rWTT) - 1][1] = Abs($g_aiArmyCompSpells[$iIndex] - $aiQueueSpells[$iIndex])
				SetLog("    missing: " & $g_asSpellNames[$iIndex] & " x" & $rWTT[UBound($rWTT) - 1][1])
				ReDim $rWTT[UBound($rWTT) + 1][2]
			EndIf
		Next
		Local $bIsFullArmywithHeroesAndSpells = $g_bIsFullArmywithHeroesAndSpells
		$g_bIsFullArmywithHeroesAndSpells = True
		TrainUsingWhatToTrain($rWTT, True)
		$g_bIsFullArmywithHeroesAndSpells = $bIsFullArmywithHeroesAndSpells ; release

		If _Sleep(1000) Then Return
		Local $NewSpellCamp = GetCurrentArmy(43, 160)
		SetLog("Checking spell tab: " & $NewSpellCamp[0] & "/" & $NewSpellCamp[1] * 2 & ($NewSpellCamp[0] < $ArmyCamp[1] * 2 ? ". Top-up queue failed!" : ""))
		If $NewSpellCamp[0] < $ArmyCamp[1] * 2 Then Return False
	EndIf
	Return True
EndFunc   ;==>CheckQueueSpellAndTrainRemain

Func DoubleTrainSiege($bDebug)
    If $g_iTotalTrainSpaceSiege < 1 Then Return; train no siege

	If Not OpenSiegeMachinesTab(True, "DoubleTrainSiege()") Then Return
	If _Sleep(500) Then Return

	Local $checkPixel[4] = [58, 556, 0x47717E, 10] ; WallW = 58, BlimpB = 229, Slammer = 400
	; build 1st Army
	For $i = $eSiegeWallWrecker To $eSiegeMachineCount - 1
		$checkPixel[0] = 58 + $i * 171 ; 58 + 1 * 171 = 229, 58 + 2 * 171 = 400
		If _CheckPixel($checkPixel, True, Default, $g_asSiegeMachineNames[$i]) Then
			If $g_aiCurrentSiegeMachines[$i] < $g_aiArmyCompSiegeMachine[$i] Then
				Local $HowMany = $g_aiArmyCompSiegeMachine[$i] - $g_aiCurrentSiegeMachines[$i]
				PureClick($checkPixel[0], $checkPixel[1], $HowMany, $g_iTrainClickDelay)
				Setlog("Build " & $HowMany & " " & $g_asSiegeMachineNames[$i] & ($HowMany >= 2 ? "s" : ""), $COLOR_SUCCESS)
				If _Sleep(250) Then Return
			EndIf
		EndIf
	Next
	; build 2nd Army
	Local $iTotalSiegeTypeToBuild = 0, $iSiegeType = -1
	For $i = $eSiegeWallWrecker To $eSiegeMachineCount - 1
		If $g_aiArmyCompSiegeMachine[$i] > 0 Then
			$iTotalSiegeTypeToBuild += 1
			$iSiegeType = $i
		EndIf
		If $iTotalSiegeTypeToBuild >= 2 Then ExitLoop
	Next

    If $iTotalSiegeTypeToBuild >= 2 Then ; train more than 1 type of siege $eSiegeStoneSlammer
        If $bDebug Then SetLog("Army has more than 1 type of siege. Double train siege might cause unbalance.", $COLOR_DEBUG)
	ElseIf $iSiegeType >= $eSiegeWallWrecker And $iSiegeType <= $eSiegeMachineCount - 1 Then
		$checkPixel[0] = 58 + $iSiegeType * 171 ; 58 + 1 * 171 = 229, 58 + 2 * 171 = 400
		Local $iTotalMachineBuilt = 0
		For $i = 1 To _Min(Number($g_aiArmyCompSiegeMachine[$iSiegeType]), 3) ; Maximum workshop space is 3
			If _CheckPixel($checkPixel, True, Default, $g_asSiegeMachineNames[$iSiegeType]) Then
				PureClick($checkPixel[0], $checkPixel[1], 1, $g_iTrainClickDelay)
				$iTotalMachineBuilt += 1
				If _Sleep(250) Then Return
			EndIf
		Next
		If $iTotalMachineBuilt > 0 Then Setlog("Build " & $iTotalMachineBuilt & " " & $g_asSiegeMachineNames[$iSiegeType] & ($iTotalMachineBuilt >= 2 ? "s" : ""), $COLOR_SUCCESS)
	EndIf
	If _Sleep(250) Then Return
EndFunc   ;==>DoubleTrainSiege
