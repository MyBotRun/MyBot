
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

Func DoubleTrain($bQuickTrain = False)

	If Not $g_bDoubleTrain Then Return
	Local $bDebug = $g_bDebugSetlogTrain Or $g_bDebugSetlog
	Local $bSetlog = (Not $g_bDoubleTrainDone) Or $bDebug

	If $bDebug then SetLog($bQuickTrain ? " ==  Double Quick Train == " : " ==  Double Train == ", $COLOR_ACTION)
	StartGainCost()
	OpenArmyOverview(False, "DoubleTrain()")

	Local $bNeedReCheckTroopTab = False, $bNeedReCheckSpellTab = False
	Local $bDoubleTrainTroop = False, $bDoubleTrainSpell = False
	Local $bIsFullArmywithHeroesAndSpells = $g_bIsFullArmywithHeroesAndSpells
	$g_bIsFullArmywithHeroesAndSpells = False ; this is to force RemoveExtraTroopsQueue()

	If $bQuickTrain Then
		DoubleQuickTrain($bSetlog, $bDebug)
		$g_bIsFullArmywithHeroesAndSpells = $bIsFullArmywithHeroesAndSpells ; release
		Return
	EndIf

	; Troop
	OpenTroopsTab(False, "DoubleTrain()")
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
			$bDoubleTrainTroop = TrainFullQueue(False, $bSetlog)
			If $bDebug Then SetLog($Step & ". TrainFullQueue(). $bDoubleTrainTroop: " & $bDoubleTrainTroop, $COLOR_DEBUG)

		ElseIf $TroopCamp[0] <= $TroopCamp[1] * 2 Then ; 281-540/540
			If CheckQueueTroopAndTrainRemain($TroopCamp, $bDebug) Then
				$bDoubleTrainTroop = True
				If $bDebug Then SetLog($Step & ". CheckQueueAndTrainRemain(). $bDoubleTrainTroop: " & $bDoubleTrainTroop, $COLOR_DEBUG)
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
		$bDoubleTrainSpell = True
	Else
		OpenSpellsTab(False, "DoubleTrain()")
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
			EndIf ;

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
				$bDoubleTrainSpell = TrainFullQueue(True, $bSetlog) ;
				If $bDebug Then SetLog($Step & ". TrainFullQueue(True). $bDoubleTrainSpell: " & $bDoubleTrainSpell, $COLOR_DEBUG)

			ElseIf $SpellCamp[0] <= $SpellCamp[1] * 2 Then ; 12-22/22
				If CheckQueueSpellAndTrainRemain($SpellCamp, $bDebug) Then
					$bDoubleTrainSpell = True
					If $bDebug Then SetLog($Step & ". CheckQueueSpellAndTrainRemain(). $bDoubleTrainSpell: " & $bDoubleTrainSpell, $COLOR_DEBUG)
				Else
					RemoveExtraTroopsQueue()
					If _Sleep(500) Then Return
					If $bDebug Then SetLog($Step & ". RemoveExtraTroopsQueue()", $COLOR_DEBUG)
					$Step += 1
					If $Step = 6 Then ExitLoop
					ContinueLoop
				EndIf
			EndIf ;
			ExitLoop
		WEnd
	EndIf

	If $bNeedReCheckTroopTab Or $bNeedReCheckSpellTab Then
		OpenArmyTab(False, "DoubleTrain()")
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
			$bDoubleTrainTroop = TrainFullQueue(False, $bSetlog)
			If $bDebug Then SetLog("TrainFullQueue(). $bDoubleTrainTroop: " & $bDoubleTrainTroop, $COLOR_DEBUG)
		EndIf
		If $bNeedReCheckSpellTab Then
			TrainUsingWhatToTrain($aWhatToTrain, True) ; spell
			$bDoubleTrainSpell = TrainFullQueue(True, $bSetlog)
			If $bDebug Then SetLog("TrainFullQueue(). $bDoubleTrainSpell: " & $bDoubleTrainSpell, $COLOR_DEBUG)
		EndIf
	EndIf

	If _Sleep(250) Then Return
	ClickP($aAway, 2, 0, "#0346") ;Click Away
	If _Sleep(250) Then Return

	$g_bDoubleTrainDone = $bDoubleTrainTroop And $bDoubleTrainSpell
	If $bDebug Then SetLog("$g_bDoubleTrainDone: " & $g_bDoubleTrainDone, $COLOR_DEBUG)

	If ProfileSwitchAccountEnabled() Then $g_abDoubleTrainDone[$g_iCurAccount] = $g_bDoubleTrainDone
	$g_bIsFullArmywithHeroesAndSpells = $bIsFullArmywithHeroesAndSpells ; release

	If $g_bDonationEnabled And $g_bChkDonate Then ResetVariables("donated")
	EndGainCost("Double Train")
	checkAttackDisable($g_iTaBChkIdle) ; Check for Take-A-Break after opening train page

EndFunc   ;==>DoubleTrain

Func TrainFullQueue($bSpellOnly = False, $bSetlog = True)
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

	If $ToReturn[0][0] = "Arch" And $ToReturn[0][1] = 0 Then Return False; Error

	Local $bIsFullArmywithHeroesAndSpells = $g_bIsFullArmywithHeroesAndSpells
	$g_bIsFullArmywithHeroesAndSpells = True

	TrainUsingWhatToTrain($ToReturn, $bSpellOnly)
	If _Sleep($bSpellOnly ? 1000 : 500) Then Return

	$g_bIsFullArmywithHeroesAndSpells = $bIsFullArmywithHeroesAndSpells

	Local $CampOCR = GetCurrentArmy($bSpellOnly ? 43 : 48, 160)
	If $bSetlog Then SetLog("Checking " & ($bSpellOnly ? "spell tab: " : "troop tab: ") & $CampOCR[0] & "/" & $CampOCR[1] * 2)
	Local $FullQueue = ($CampOCR[0] = $CampOCR[1] * 2) Or ($bSpellOnly And $g_bForceBrewSpells)
	Return $FullQueue

EndFunc   ;==>TrainFullQueue

Func DoubleQuickTrain($bSetlog, $bDebug)

	Local $bDoubleTrainTroop = False, $bDoubleTrainSpell = False

	; Troop
	OpenTroopsTab(False, "DoubleQuickTrain()")
	If _Sleep(250) Then Return

	Local $Step = 1
	While 1
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
	OpenSpellsTab(False, "DoubleQuickTrain()")
	If _Sleep(250) Then Return
	$Step = 1
	While 1
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
		OpenQuickTrainTab(False, "DoubleQuickTrain()")
		If _Sleep(500) Then Return
		TrainArmyNumber($g_bQuickTrainArmy)
	Else
		If $bSetlog Then SetLog("Full queue, skip Double Quick Train")
	EndIf

	If _Sleep(250) Then Return

	ClickP($aAway, 2, 0, "#0346") ;Click Away

	If _Sleep(250) Then Return
	$g_bDoubleTrainDone = True
	If $bDebug Then SetLog("$g_bDoubleTrainDone: " & $g_bDoubleTrainDone, $COLOR_DEBUG)
	If ProfileSwitchAccountEnabled() Then $g_abDoubleTrainDone[$g_iCurAccount] = $g_bDoubleTrainDone

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
;~ 	If Not IsArray($ArmyCamp) Then $ArmyCamp = GetCurrentArmy(48, 160)
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
;~ 	If Not IsArray($ArmyCamp) Then $ArmyCamp = GetCurrentArmy(43, 160)
	If $ArmyCamp[0] = $ArmyCamp[1] * 2 And ((ProfileSwitchAccountEnabled() And $g_abAccountNo[$g_iCurAccount] And $g_abDonateOnly[$g_iCurAccount]) Or $g_iCommandStop = 0) Then Return True ; bypass Donate account when full queue

	Local $iTotalQueue = 0
	If $bDebug Then SetLog("Checking spell queue: " & $ArmyCamp[0] & "/" & $ArmyCamp[1] * 2, $COLOR_DEBUG)

	Local $XQueueStart = 835
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