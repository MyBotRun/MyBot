
; #FUNCTION# ====================================================================================================================
; Name ..........: Double Train
; Description ...:
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Demen
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func DoubleTrain()

	If Not $g_bDoubleTrain Then Return
	Local $bDebug = $g_bDebugSetlogTrain Or $g_bDebugSetlog

	If $bDebug then SetLog(" == Double Train Army == ", $COLOR_ACTION)

	Local $bNeedReCheckTroopTab = False, $bNeedReCheckSpellTab = False

	; Troop
	If Not OpenTroopsTab(False, "DoubleTrain()") Then Return
	If _Sleep(250) Then Return

	Local $Step = 1
	While 1
		Local $TroopCamp = GetCurrentArmy(48, 160)
		SetLog("Checking Troop tab: " & $TroopCamp[0] & "/" & $TroopCamp[1] * 2)
		If $TroopCamp[1] = 0 Then ExitLoop
		If $TroopCamp[1] <> $g_iTotalCampSpace Then _
			SetLog("Incorrect Troop combo: " & $g_iTotalCampSpace & " vs Total camp: " & $TroopCamp[1] & @CRLF & @TAB & "Double train may not work well", $COLOR_DEBUG)

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
			TrainFullTroop(True)
			If $bDebug Then SetLog($Step & ". TrainFullTroop(True) done!", $COLOR_DEBUG)

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
	Local $iUnbalancedSpell = 0
	Local $TotalSpell = _Min(Number(TotalSpellsToBrewInGUI()), Number($g_iTotalSpellValue))
	If $TotalSpell = 0 Then
		If $bDebug Then SetLog("No spell is required, skip checking spell tab", $COLOR_DEBUG)
	Else
		If Not OpenSpellsTab(False, "DoubleTrain()") Then Return
		If _Sleep(250) Then Return
		$Step = 1
		While 1
			Local $SpellCamp = GetCurrentArmy(43, 160)
			SetLog("Checking Spell tab: " & $SpellCamp[0] & "/" & $SpellCamp[1] * 2)

			If $SpellCamp[1] > $TotalSpell Then
				SetLog("Unbalance Total spell setting vs actual spell capacity: " & $TotalSpell & "/" & $SpellCamp[1] & @CRLF & @TAB & "Double train may not work well", $COLOR_DEBUG)
				$iUnbalancedSpell = $SpellCamp[1] - $TotalSpell
				$SpellCamp[1] = $TotalSpell
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

			ElseIf $SpellCamp[0] = $SpellCamp[1] Or $SpellCamp[0] <= $SpellCamp[1] + $iUnbalancedSpell Then ; 11/22
				BrewFullSpell(True)
				If $iUnbalancedSpell > 0 Then TopUpUnbalancedSpell($iUnbalancedSpell)
				If $bDebug Then SetLog($Step & ". BrewFullSpell(True) done!", $COLOR_DEBUG)

			Else ; If $SpellCamp[0] <= $SpellCamp[1] * 2 Then ; 12-22/22
				If CheckQueueSpellAndTrainRemain($SpellCamp, $bDebug, $iUnbalancedSpell) Then
					If $SpellCamp[0] < ($SpellCamp[1] + $iUnbalancedSpell) * 2 Then TopUpUnbalancedSpell($iUnbalancedSpell)
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

		Local $aWhatToTrain = WhatToTrain(False, False)
		If DoWhatToTrainContainTroop($aWhatToTrain) Then
			TrainUsingWhatToTrain($aWhatToTrain)
			TrainFullTroop(True)
			If $bDebug Then SetLog("TrainFullTroop(True) done.", $COLOR_DEBUG)
		EndIf
		If DoWhatToTrainContainSpell($aWhatToTrain) Then
			BrewUsingWhatToTrain($aWhatToTrain)
			BrewFullSpell(True)
			If $iUnbalancedSpell > 0 Then TopUpUnbalancedSpell($iUnbalancedSpell)
			If $bDebug Then SetLog("BrewFullSpell(True) done.", $COLOR_DEBUG)
		EndIf
	EndIf

	If _Sleep(250) Then Return

EndFunc   ;==>DoubleTrain

Func TrainFullTroop($bQueue = False)
	SetLog("Training " & ($bQueue ? "2nd Army..." : "1st Army..."))

	Local $ToReturn[1][2] = [["Arch", 0]]
	For $i = 0 To $eTroopCount - 1
		Local $troopIndex = $g_aiTrainOrder[$i]
		If $g_aiArmyCompTroops[$troopIndex] > 0 Then
			$ToReturn[UBound($ToReturn) - 1][0] = $g_asTroopShortNames[$troopIndex]
			$ToReturn[UBound($ToReturn) - 1][1] = $g_aiArmyCompTroops[$troopIndex]
			ReDim $ToReturn[UBound($ToReturn) + 1][2]
		EndIf
	Next

	If $ToReturn[0][0] = "Arch" And $ToReturn[0][1] = 0 Then Return

	TrainUsingWhatToTrain($ToReturn, $bQueue)
	If _Sleep(500) Then Return

	Local $CampOCR = GetCurrentArmy(48, 160)
	SetDebugLog("Checking troop tab: " & $CampOCR[0] & "/" & $CampOCR[1] * 2)
EndFunc   ;==>TrainFullTroop

Func BrewFullSpell($bQueue = False)
	SetLog("Brewing " & ($bQueue ? "2nd Army..." : "1st Army..."))

	Local $ToReturn[1][2] = [["Arch", 0]]
	For $i = 0 To $eSpellCount - 1
		Local $BrewIndex = $g_aiBrewOrder[$i]
        If $g_aiArmyCompSpells[$BrewIndex] > 0 Then
			$ToReturn[UBound($ToReturn) - 1][0] = $g_asSpellShortNames[$BrewIndex]
			$ToReturn[UBound($ToReturn) - 1][1] = $g_aiArmyCompSpells[$BrewIndex]
			ReDim $ToReturn[UBound($ToReturn) + 1][2]
		EndIf
	Next

	If $ToReturn[0][0] = "Arch" And $ToReturn[0][1] = 0 Then Return

	BrewUsingWhatToTrain($ToReturn, $bQueue)
	If _Sleep(750) Then Return

	Local $CampOCR = GetCurrentArmy(43, 160)
	SetDebugLog("Checking spell tab: " & $CampOCR[0] & "/" & $CampOCR[1] * 2)
EndFunc   ;==>BrewFullSpell

Func TopUpUnbalancedSpell($iUnbalancedSpell = 0)

	If $iUnbalancedSpell = 0 Then Return
	Local $iTypeOfSpell = 0, $iSpellIndex
	For $i = 0 To UBound($g_aiArmyCompSpells) - 1
		If $g_aiArmyCompSpells[$i] > 0 Then
			$iSpellIndex = $i
			$iTypeOfSpell += 1
		EndIf
		If $iTypeOfSpell > 1 Then ExitLoop
	Next

	If $iTypeOfSpell = 1 Then
		Local $aSpell[1][2]
		$aSpell[0][0] = $g_asSpellShortNames[$iSpellIndex]
		$aSpell[0][1] = Int($iUnbalancedSpell * 2 / $g_aiSpellSpace[$iSpellIndex])

		If $aSpell[0][1] >= 1 Then
			SetLog("Topping up " & $g_asSpellNames[$iSpellIndex] & " Spell x" & $aSpell[0][1])
			BrewUsingWhatToTrain($aSpell, True)
		EndIf
	EndIf

	If _Sleep(750) Then Return

EndFunc   ;==>IsBrewOnlyOneType

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
		TrainUsingWhatToTrain($rWTT, True)

		If _Sleep(1000) Then Return
		$ArmyCamp = GetCurrentArmy(48, 160)
		SetLog("Checking troop tab: " & $ArmyCamp[0] & "/" & $ArmyCamp[1] * 2 & ($ArmyCamp[0] < $ArmyCamp[1] * 2 ? ". Top-up queue failed!" : ""))
		If $ArmyCamp[0] < $ArmyCamp[1] * 2 Then Return False
	EndIf
	Return True
EndFunc   ;==>CheckQueueTroopAndTrainRemain

Func CheckQueueSpellAndTrainRemain($ArmyCamp, $bDebug, $iUnbalancedSpell = 0)
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
	If $ArmyCamp[0] < $ArmyCamp[1] + $iTotalQueue Then
		SetLog("A big guy blocks our camp")
		Return False
	EndIf
	; check wrong queue
	Local $iUnbalancedSlot = 0, $iTypeOfSpell = 0
	For $i = 0 To UBound($aiQueueSpells) - 1
		If $aiQueueSpells[$i] > 0 Then $iTypeOfSpell += 1
		If $aiQueueSpells[$i] - $g_aiArmyCompSpells[$i] > 0 Then
			$iUnbalancedSlot += ($aiQueueSpells[$i] - $g_aiArmyCompSpells[$i]) * $g_aiSpellSpace[$i]
			If $iTypeOfSpell > 1 Or $iUnbalancedSlot > $iUnbalancedSpell * 2 Then ; more than 2 spell types
				SetLog("Some wrong spells in queue (" & $g_asSpellNames[$i] & " x" & $aiQueueSpells[$i] & "/" & $g_aiArmyCompSpells[$i] & ")")
				Return False
			EndIf
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
		BrewUsingWhatToTrain($rWTT, True)

		If _Sleep(1000) Then Return
		Local $NewSpellCamp = GetCurrentArmy(43, 160)
		SetLog("Checking spell tab: " & $NewSpellCamp[0] & "/" & $NewSpellCamp[1] * 2 & ($NewSpellCamp[0] < $ArmyCamp[1] * 2 ? ". Top-up queue failed!" : ""))
		If $NewSpellCamp[0] < $ArmyCamp[1] * 2 Then Return False
	EndIf
	Return True
EndFunc   ;==>CheckQueueSpellAndTrainRemain
