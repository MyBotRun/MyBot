; #FUNCTION# ====================================================================================================================
; Name ..........: Quick Train
; Description ...: New and a complete quick train system
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Demen
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func QuickTrain()
	Local $bDebug = $g_bDebugSetlogTrain Or $g_bDebugSetlog
	Local $bNeedRecheckTroop = False, $bNeedRecheckSpell = False
	Local $iTroopStatus = -1, $iSpellStatus = -1 ; 0 = empty, 1 = full camp, 2 = full queue

	If $bDebug Then SetLog(" == Quick Train == ", $COLOR_ACTION)

	; Troop
	If Not $g_bDonationEnabled Or Not $g_bChkDonate Or Not MakingDonatedTroops("Troops") Then ; No need OpenTroopsTab() if MakingDonatedTroops() returns true
		If Not OpenTroopsTab(False, "QuickTrain()") Then Return
		If _Sleep(250) Then Return
	EndIf

	Local $iStep = 1
	While 1
		Local $avTroopCamp = GetCurrentArmy(95, 163 + $g_iMidOffsetY)
		SetLog("Checking Troop tab: " & $avTroopCamp[0] & "/" & $avTroopCamp[1] * 2)
		If $avTroopCamp[1] = 0 Then ExitLoop

		If $avTroopCamp[0] <= 0 Then ; 0/280
			$iTroopStatus = 0
			If $bDebug Then SetLog("No troop", $COLOR_DEBUG)

		ElseIf $avTroopCamp[0] < $avTroopCamp[1] Then ; 1-279/280
			If Not IsQueueEmpty("Troops", True, False) Then DeleteQueued("Troops")
			$bNeedRecheckTroop = True
			If $bDebug Then SetLog("$bNeedRecheckTroop for at Army Tab: " & $bNeedRecheckTroop, $COLOR_DEBUG)

		ElseIf $avTroopCamp[0] = $avTroopCamp[1] Then ; 280/280
			$iTroopStatus = 1
			If $bDebug Then SetLog($g_bDoubleTrain ? "ready to make double troop training" : "troops are training perfectly", $COLOR_DEBUG)

		ElseIf $avTroopCamp[0] <= $avTroopCamp[1] * 1.5 Then ; 281-420/560
			RemoveExtraTroopsQueue()
			If $bDebug Then SetLog($iStep & ". RemoveExtraTroopsQueue()", $COLOR_DEBUG)
			If _Sleep(250) Then Return
			$iStep += 1
			If $iStep = 6 Then ExitLoop
			ContinueLoop

		ElseIf $avTroopCamp[0] <= $avTroopCamp[1] * 2 Then ; 421-560/560
			If CheckQueueTroopAndTrainRemain($avTroopCamp, $bDebug) Then
				$iTroopStatus = 2
				If $bDebug Then SetLog($iStep & ". CheckQueueTroopAndTrainRemain()", $COLOR_DEBUG)
			Else
				RemoveExtraTroopsQueue()
				If $bDebug Then SetLog($iStep & ". RemoveExtraTroopsQueue()", $COLOR_DEBUG)
				If _Sleep(250) Then Return
				$iStep += 1
				If $iStep = 6 Then ExitLoop
				ContinueLoop
			EndIf
		EndIf
		ExitLoop
	WEnd

	; Spell
	If $g_iTotalQuickSpells = 0 Then
		$iSpellStatus = 2
	Else
		If Not $g_bDonationEnabled Or Not $g_bChkDonate Or Not MakingDonatedTroops("Spells") Then ; No need OpenSpellsTab() if MakingDonatedTroops() returns true
			If Not OpenSpellsTab(False, "QuickTrain()") Then Return
			If _Sleep(250) Then Return
		EndIf

		Local $Step = 1, $iUnbalancedSpell = 0
		While 1
			Local $aiSpellCamp = GetCurrentArmy(95, 163 + $g_iMidOffsetY)
			SetLog("Checking Spell tab: " & $aiSpellCamp[0] & "/" & $aiSpellCamp[1] * 2)
			If $aiSpellCamp[1] > $g_iTotalQuickSpells Then
				SetLog("Unbalance total quick spell vs actual spell capacity: " & $g_iTotalQuickSpells & "/" & $aiSpellCamp[1])
				$iUnbalancedSpell = $aiSpellCamp[1] - $g_iTotalQuickSpells
				$aiSpellCamp[1] = $g_iTotalQuickSpells
			EndIf

			If $aiSpellCamp[0] <= 0 Then ; 0/22
				If $iTroopStatus >= 1 And $g_bQuickArmyMixed Then
					BrewFullSpell()
					$iSpellStatus = 1
					If $iTroopStatus = 2 And $g_bDoubleTrain Then
						BrewFullSpell(True)
						TopUpUnbalancedSpell($iUnbalancedSpell)
						$iSpellStatus = 2
					EndIf
				Else
					$iSpellStatus = 0
					If $bDebug Then SetLog("No Spell", $COLOR_DEBUG)
				EndIf

			ElseIf $aiSpellCamp[0] < $aiSpellCamp[1] Then ; 1-10/11
				If Not IsQueueEmpty("Spells", True, False) Then DeleteQueued("Spells")
				$bNeedRecheckSpell = True
				If $bDebug Then SetLog("$bNeedRecheckSpell at Army Tab: " & $bNeedRecheckSpell, $COLOR_DEBUG)

			ElseIf $aiSpellCamp[0] = $aiSpellCamp[1] Or $aiSpellCamp[0] <= $aiSpellCamp[1] + $iUnbalancedSpell Then  ; 11/22
				If $iTroopStatus = 2 And $g_bQuickArmyMixed And $g_bDoubleTrain Then
					BrewFullSpell(True)
					TopUpUnbalancedSpell($iUnbalancedSpell)
					If $bDebug Then SetLog("$iTroopStatus = " & $iTroopStatus & ". Brewed full queued spell", $COLOR_DEBUG)
					$iSpellStatus = 2
				Else
					$iSpellStatus = 1
					If $bDebug Then SetLog($g_bDoubleTrain ? "ready to make double spell brewing" : "spells are brewing perfectly", $COLOR_DEBUG)
				EndIf

			Else ; If $aiSpellCamp[0] <= $aiSpellCamp[1] * 2 Then ; 12-22/22
				If ($iTroopStatus = 2 Or Not $g_bQuickArmyMixed) And CheckQueueSpellAndTrainRemain($aiSpellCamp, $bDebug, $iUnbalancedSpell) Then
					If $aiSpellCamp[0] < ($aiSpellCamp[1] + $iUnbalancedSpell) * 2 Then TopUpUnbalancedSpell($iUnbalancedSpell)
					$iSpellStatus = 2
				Else
					RemoveExtraTroopsQueue()
					If _Sleep(500) Then Return
					$Step += 1
					If $Step = 6 Then ExitLoop
					ContinueLoop
				EndIf

			EndIf
			ExitLoop
		WEnd
	EndIf

	; check existing army then train missing troops, spells, sieges
	If $bNeedRecheckTroop Or $bNeedRecheckSpell Then

		Local $aWhatToRemove = WhatToTrain(True)

		RemoveExtraTroops($aWhatToRemove)

		Local $bEmptyTroop = _ColorCheck(_GetPixelColor(85, 203 + $g_iMidOffsetY, True), Hex(0xD1D0C9, 6), 20) ; remove all troops
		Local $bEmptySpell = _ColorCheck(_GetPixelColor(85, 328 + $g_iMidOffsetY, True), Hex(0xD1D0C9, 6), 20) ; remove all spells

		Local $aWhatToTrain = WhatToTrain(False, False) ; $g_bIsFullArmywithHeroesAndSpells = False

		If DoWhatToTrainContainTroop($aWhatToTrain) Then
			If $bEmptyTroop And $bEmptySpell Then
				$iTroopStatus = 0
			ElseIf $bEmptyTroop And ($iSpellStatus >= 1 And Not $g_bQuickArmyMixed) Then
				$iTroopStatus = 0
			Else
				If $bDebug Then SetLog("Topping up troops", $COLOR_DEBUG)
				TrainUsingWhatToTrain($aWhatToTrain) ; troop
				$iTroopStatus = 1
			EndIf
		EndIf

		If DoWhatToTrainContainSpell($aWhatToTrain) Then
			If $bEmptySpell And $bEmptyTroop Then
				$iSpellStatus = 0
			ElseIf $bEmptySpell And ($iTroopStatus >= 1 And Not $g_bQuickArmyMixed) Then
				$iSpellStatus = 0
			Else
				If $bDebug Then SetLog("Topping up spells", $COLOR_DEBUG)
				BrewUsingWhatToTrain($aWhatToTrain) ; spell
				$iSpellStatus = 1
			EndIf
		EndIf

		TrainSiege()
	EndIf

	If _Sleep(250) Then Return

	SetDebugLog("$iTroopStatus = " & $iTroopStatus & ", $iSpellStatus = " & $iSpellStatus)
	If $iTroopStatus = -1 And $iSpellStatus = -1 Then
		SetLog("Quick Train failed. Unable to detect training status.", $COLOR_ERROR)
		Return
	EndIf

	Switch _Min($iTroopStatus, $iSpellStatus)
		Case 0
			If Not OpenQuickTrainTab(False, "QuickTrain()") Then Return
			If _Sleep(750) Then Return
			TrainArmyNumber($g_bQuickTrainArmy)
			If $g_bDoubleTrain Then TrainArmyNumber($g_bQuickTrainArmy)
		Case 1
			If $g_bIsFullArmywithHeroesAndSpells Or $g_bDoubleTrain Then
				If $g_bIsFullArmywithHeroesAndSpells Then SetLog(" - Your Army is Full, let's make troops before Attack!", $COLOR_INFO)
				If Not OpenQuickTrainTab(False, "QuickTrain()") Then Return
				If _Sleep(750) Then Return
				TrainArmyNumber($g_bQuickTrainArmy)
			EndIf
	EndSwitch
	If _Sleep(500) Then Return

EndFunc   ;==>QuickTrain

Func CheckQuickTrainTroop()

	Local $bResult = True


	Local Static $asLastTimeChecked[8]
	If $g_bFirstStart Then $asLastTimeChecked[$g_iCurAccount] = ""

	If _DateIsValid($asLastTimeChecked[$g_iCurAccount]) Then
		Local $iLastCheck = _DateDiff('n', $asLastTimeChecked[$g_iCurAccount], _NowCalc()) ; elapse time from last check (minutes)
		SetDebugLog("Latest CheckQuickTrainTroop() at: " & $asLastTimeChecked[$g_iCurAccount] & ", Check DateCalc: " & $iLastCheck & " min" & @CRLF & _
				"_ArrayMax($g_aiArmyQuickTroops) = " & _ArrayMax($g_aiArmyQuickTroops))
		If $iLastCheck <= 360 And _ArrayMax($g_aiArmyQuickTroops) > 0 Then Return ; A check each 6 hours [6*60 = 360]
	EndIf

	If Not OpenArmyOverview(False, "CheckQuickTrainTroop()") Then Return
	If _Sleep(250) Then Return

	If Not OpenQuickTrainTab(False, "CheckQuickTrainTroop()") Then Return
	If _Sleep(500) Then Return

	SetLog("Reading troops and spells in quick train army")

	; reset troops/spells in quick army
	Local $aEmptyTroop[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	Local $aEmptySpell[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	$g_aiArmyQuickTroops = $aEmptyTroop
	$g_aiArmyQuickSpells = $aEmptySpell
	$g_iTotalQuickTroops = 0
	$g_iTotalQuickSpells = 0
	$g_iTotalQuickSiegeMachines = 0
	$g_bQuickArmyMixed = False

	Local $iTroopCamp = 0, $iSpellCamp = 0, $sLog = ""

	Local $aSaveButton[4] = [730, 286 + $g_iMidOffsetY, 0xD7F37F, 20] ; green
	Local $aCancelButton[4] = [614, 286 + $g_iMidOffsetY, 0xFF8489, 20] ; red

	Local $iDistanceBetweenArmies = 93 ; pixels
	Local $aArmy1Location = [680, 293] ; first area of quick train army buttons

	; findImage needs filename and path
	Local $avEditQuickTrainIcon = _FileListToArrayRec($g_sImgEditQuickTrain, "*", $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_NOSORT, $FLTAR_FULLPATH)

	If Not IsArray($avEditQuickTrainIcon) Or UBound($avEditQuickTrainIcon, $UBOUND_ROWS) <= 0 Then
		SetLog("Can't find EditQuickTrainIcon") ;
		Return False
	EndIf

	For $i = 0 To UBound($g_bQuickTrainArmy) - 1 ; check all 3 army combo
		If Not $g_bQuickTrainArmy[$i] Then ContinueLoop ; skip unchecked quick train army

		; calculate search area for EditQuickTrainIcon
		Local $sSearchArea = $aArmy1Location[0] & ", " & ($aArmy1Location[1] + ($iDistanceBetweenArmies * $i)) & ", 780, " & ($aArmy1Location[1] + ($iDistanceBetweenArmies * ($i + 1)))

		; search for EditQuickTrainIcon
		Local $aiEditButton = decodeSingleCoord(findImage("EditQuickTrain", $avEditQuickTrainIcon[1], GetDiamondFromRect($sSearchArea), 1, True, Default))

		If IsArray($aiEditButton) And UBound($aiEditButton, 1) >= 2 Then
			ClickP($aiEditButton)
			If _Sleep(1000) Then Return

			Local $TempTroopTotal = 0, $TempSpellTotal = 0, $TempSiegeTotal = 0

			Local $Step = 0
			While 1
				; read troops
				Local $aSearchResult = SearchArmy(@ScriptDir & "\imgxml\ArmyOverview\QuickTrain", 70, 182 + $g_iMidOffsetY, 785, 250 + $g_iMidOffsetY, "Quick Train") ; return Name, X, Y, Q'ty

				If $aSearchResult[0][0] = "" Then
					If Not $g_abUseInGameArmy[$i] Then
						$Step += 1
						SetLog("No troops/spells detected in Army " & $i + 1 & ", let's create quick train preset", $Step > 3 ? $COLOR_ERROR : $COLOR_BLACK)
						If $Step > 3 Then
							SetLog("Some problems creating army preset", $COLOR_ERROR)
							Click($aCancelButton[0], $aCancelButton[1]) ; Close editing
							ContinueLoop 2
						EndIf
						CreateQuickTrainPreset($i)
						ContinueLoop
					Else
						SetLog("No troops/spells detected in Quick Army " & $i + 1, $COLOR_ERROR)
						Click($aCancelButton[0], $aCancelButton[1]) ; Close editing
						If _Sleep(1000) Then Return
						ContinueLoop 2
					EndIf
				EndIf

				; get quantity
				Local $aiInGameTroop = $aEmptyTroop
				Local $aiInGameSpell = $aEmptySpell
				Local $aiGUITroop = $aEmptyTroop
				Local $aiGUISpell = $aEmptySpell

				SetLog("Quick Army " & $i + 1 & ":", $COLOR_SUCCESS)
				For $j = 0 To (UBound($aSearchResult) - 1)
					Local $iTroopIndex = TroopIndexLookup($aSearchResult[$j][0])
					If $iTroopIndex >= 0 And $iTroopIndex < $eTroopCount Then
						SetLog("  - " & $g_asTroopNames[$iTroopIndex] & ": " & $aSearchResult[$j][3] & "x", $COLOR_SUCCESS)
						$aiInGameTroop[$iTroopIndex] = $aSearchResult[$j][3]
					ElseIf $iTroopIndex >= $eLSpell And $iTroopIndex <= $eOgSpell Then
						SetLog("  - " & $g_asSpellNames[$iTroopIndex - $eLSpell] & ": " & $aSearchResult[$j][3] & "x", $COLOR_SUCCESS)
						$aiInGameSpell[$iTroopIndex - $eLSpell] = $aSearchResult[$j][3]
					ElseIf $iTroopIndex >= $eWallW And $iTroopIndex <= $eBattleD Then
						SetLog("  - " & $g_asSiegeMachineNames[$iTroopIndex - $eWallW] & ": " & $aSearchResult[$j][3] & "x", $COLOR_SUCCESS)
					Else
						SetLog("  - Unsupport troop/spell index: " & $iTroopIndex)
					EndIf
				Next

				; cross check with GUI qty
				If Not $g_abUseInGameArmy[$i] Then
					If $Step <= 3 Then
						For $j = 0 To 6
							If $g_aiQuickTroopType[$i][$j] >= 0 Then $aiGUITroop[$g_aiQuickTroopType[$i][$j]] = $g_aiQuickTroopQty[$i][$j]
							If $g_aiQuickSpellType[$i][$j] >= 0 Then $aiGUISpell[$g_aiQuickSpellType[$i][$j]] = $g_aiQuickSpellQty[$i][$j]
						Next
						For $j = 0 To $eTroopCount - 1
							If $aiGUITroop[$j] <> $aiInGameTroop[$j] Then
								Setlog("Wrong troop preset, let's create again. (" & $g_asTroopNames[$j] & ": " & $aiGUITroop[$j] & "/" & $aiInGameTroop[$j] & ")" & ($g_bDebugSetlog ? " - Retry: " & $Step : ""))
								$Step += 1
								CreateQuickTrainPreset($i)
								ContinueLoop 2
							EndIf
						Next
						For $j = 0 To $eSpellCount - 1
							If $aiGUISpell[$j] <> $aiInGameSpell[$j] Then
								Setlog("Wrong spell preset, let's create again (" & $g_asSpellNames[$j] & ": " & $aiGUISpell[$j] & "/" & $aiInGameSpell[$j] & ")" & ($g_bDebugSetlog ? " - Retry: " & $Step : ""))
								$Step += 1
								CreateQuickTrainPreset($i)
								ContinueLoop 2
							EndIf
						Next
					Else
						SetLog("Some problems creating troop preset", $COLOR_ERROR)
					EndIf
				EndIf

				; If all correct (or after 3 times trying to preset QT army), add result to $g_aiArmyQuickTroops & $g_aiArmyQuickSpells
				For $j = 0 To $eTroopCount - 1
					$g_aiArmyQuickTroops[$j] += $aiInGameTroop[$j]
					$TempTroopTotal += $aiInGameTroop[$j] * $g_aiTroopSpace[$j]              ; tally normal troops

					If $j > $eSpellCount - 1 Then ContinueLoop
					$g_aiArmyQuickSpells[$j] += $aiInGameSpell[$j]
					$TempSpellTotal += $aiInGameSpell[$j] * $g_aiSpellSpace[$j]              ; tally spells
				Next

				ExitLoop
			WEnd

			; check if an army has troops , spells
			If Not $g_bQuickArmyMixed And $TempTroopTotal > 0 And $TempSpellTotal > 0 Then $g_bQuickArmyMixed = True
			SetDebugLog("$g_bQuickArmyMixed: " & $g_bQuickArmyMixed)

			; cross check with army camp
			If _ArrayMax($g_aiArmyQuickTroops) > 0 Then
				Local $TroopCamp = GetCurrentArmy(95, 163 + $g_iMidOffsetY)
				$iTroopCamp = $TroopCamp[1] * 2
				If $TempTroopTotal <> $TroopCamp[0] Then
					SetLog("Error reading troops in army setting (" & $TempTroopTotal & " vs " & $TroopCamp[0] & ")", $COLOR_ERROR)
					$bResult = False
				Else
					$g_iTotalQuickTroops += $TempTroopTotal
					SetDebugLog("$g_iTotalQuickTroops: " & $g_iTotalQuickTroops)
				EndIf
			EndIf
			If _ArrayMax($g_aiArmyQuickSpells) > 0 Then
				Local $aiSpellCamp = GetCurrentArmy(185, 163 + $g_iMidOffsetY)
				$iSpellCamp = $aiSpellCamp[1] * 2
				If $TempSpellTotal <> $aiSpellCamp[0] Then
					SetLog("Error reading spells in army setting (" & $TempSpellTotal & " vs " & $aiSpellCamp[0] & ")", $COLOR_ERROR)
					$bResult = False
				Else
					$g_iTotalQuickSpells += $TempSpellTotal
					SetDebugLog("$g_iTotalQuickSpells: " & $g_iTotalQuickSpells)
				EndIf
			EndIf

			$sLog &= $i + 1 & " "

			ClickP($g_abUseInGameArmy[$i] ? $aCancelButton : $aSaveButton)

			If _Sleep(1000) Then Return

		Else
			SetLog('Cannot find "Edit" button for Army ' & $i + 1, $COLOR_ERROR)
			$bResult = False
		EndIf
	Next

	$g_aiArmyCompTroops = $g_aiArmyQuickTroops
	$g_aiArmyCompSpells = $g_aiArmyQuickSpells

	If $g_iTotalQuickTroops > $iTroopCamp Then SetLog("Total troops in combo army " & $sLog & "exceeds your camp capacity (" & $g_iTotalQuickTroops & " vs " & $iTroopCamp & ")", $COLOR_ERROR)
	If $g_iTotalQuickSpells > $iSpellCamp Then SetLog("Total spells in combo army " & $sLog & "exceeds your camp capacity (" & $g_iTotalQuickSpells & " vs " & $iSpellCamp & ")", $COLOR_ERROR)

	ClickP($aAway, 2, 0, "#0000") ;Click Away
	$asLastTimeChecked[$g_iCurAccount] = $bResult ? _NowCalc() : ""

EndFunc   ;==>CheckQuickTrainTroop

Func CreateQuickTrainPreset($i)
	SetLog("Creating troops/spells/siege machines preset for Army " & $i + 1)

	Local $aRemoveButton[4] = [518, 284 + $g_iMidOffsetY, 0xFF8C91, 20] ; red
	Local $iArmyPage = 0

	If _ColorCheck(_GetPixelColor($aRemoveButton[0], $aRemoveButton[1], True), Hex($aRemoveButton[2], 6), $aRemoveButton[2]) Then
		ClickP($aRemoveButton) ; click remove
		If _Sleep(750) Then Return

		UpdateNextPageQuickTroop()

		Local $TroopEndP1 = $eMini, $TroopEndP2 = $eHunt
		Switch $g_iNextPageQuickTroop
			Case $eDrag, $eHeal
				$TroopEndP1 = $eSMini
				$TroopEndP2 = $eAppWard
			Case $eSWiza
				$TroopEndP1 = $eRootR
				$TroopEndP2 = $eIceG
		EndSwitch

		For $j = 0 To 6
			Local $iIndex = $g_aiQuickTroopType[$i][$j]
			If _ArrayIndexValid($g_aiArmyQuickTroops, $iIndex) Then
				If $iIndex > $g_iNextPageQuickTroop And $iArmyPage = 0 Then
					If _Sleep(250) Then Return
					ClickDrag(770, 475, 75, 475, 2000)
					If _Sleep(1500) Then Return
					$iArmyPage = 1
				EndIf

				If $iIndex > $TroopEndP1 And $iArmyPage = 1 Then
					If _Sleep(250) Then Return
					ClickDrag(770, 475, 110, 475, 2000)
					If _Sleep(1500) Then Return
					$iArmyPage = 2
				EndIf

				If $g_iNextPageQuickTroop = $eSWiza Then
					If $iIndex > $TroopEndP2 And $iArmyPage = 2 Then
						If _Sleep(250) Then Return
						ClickDrag(750, 475, 650, 475, 2000)
						If _Sleep(1500) Then Return
						$iArmyPage = 3
					EndIf
				EndIf

				Local $aTrainPos = GetTrainPos($iIndex)
				If IsArray($aTrainPos) And $aTrainPos[0] <> -1 Then
					SetLog("Adding " & $g_aiQuickTroopQty[$i][$j] & "x " & $g_asTroopNames[$iIndex], $COLOR_SUCCESS)
					ClickP($aTrainPos, $g_aiQuickTroopQty[$i][$j], $g_iTrainClickDelay, "QTrain")
				EndIf
			EndIf
		Next

		For $j = 0 To 6
			Local $iIndex = $g_aiQuickSpellType[$i][$j]
			If _ArrayIndexValid($g_aiArmyQuickSpells, $iIndex) Then
				Switch $g_iNextPageQuickTroop
					Case $eDrag, $eHeal
						If $iArmyPage = 0 Then
							If _Sleep(250) Then Return
							ClickDrag(770, 475, 75, 475, 2000)
							If _Sleep(1500) Then Return
							ClickDrag(770, 475, 110, 475, 2000)
							If _Sleep(1500) Then Return
							ClickDrag(750, 475, 650, 475, 2000)
							If _Sleep(1500) Then Return
							ClickDrag(770, 475, 100, 475, 2000)
							If _Sleep(1500) Then Return
							$iArmyPage = 3
						ElseIf $iArmyPage = 1 Then
							If _Sleep(250) Then Return
							ClickDrag(770, 475, 110, 475, 2000)
							If _Sleep(1500) Then Return
							ClickDrag(750, 475, 650, 475, 2000)
							If _Sleep(1500) Then Return
							ClickDrag(770, 475, 100, 475, 2000)
							If _Sleep(1500) Then Return
							$iArmyPage = 3
						ElseIf $iArmyPage = 2 Then
							If _Sleep(250) Then Return
							ClickDrag(750, 475, 650, 475, 2000)
							If _Sleep(1500) Then Return
							ClickDrag(770, 475, 100, 475, 2000)
							If _Sleep(1500) Then Return
							$iArmyPage = 3
						EndIf
					Case $eSWiza
						If $iArmyPage = 0 Then
							If _Sleep(250) Then Return
							ClickDrag(770, 475, 75, 475, 2000)
							If _Sleep(1500) Then Return
							ClickDrag(770, 475, 110, 475, 2000)
							If _Sleep(1500) Then Return
							ClickDrag(750, 475, 650, 475, 2000)
							If _Sleep(1500) Then Return
							ClickDrag(750, 475, 650, 475, 2000)
							If _Sleep(1500) Then Return
							ClickDrag(770, 475, 75, 475, 2000)
							If _Sleep(1500) Then Return
							$iArmyPage = 4
						ElseIf $iArmyPage = 1 Then
							If _Sleep(250) Then Return
							ClickDrag(770, 475, 110, 475, 2000)
							If _Sleep(1500) Then Return
							ClickDrag(750, 475, 650, 475, 2000)
							If _Sleep(1500) Then Return
							ClickDrag(750, 475, 650, 475, 2000)
							If _Sleep(1500) Then Return
							ClickDrag(770, 475, 75, 475, 2000)
							If _Sleep(1500) Then Return
							$iArmyPage = 4
						ElseIf $iArmyPage = 2 Then
							If _Sleep(250) Then Return
							ClickDrag(750, 475, 650, 475, 2000)
							If _Sleep(1500) Then Return
							ClickDrag(750, 475, 650, 475, 2000)
							If _Sleep(1500) Then Return
							ClickDrag(770, 475, 75, 475, 2000)
							If _Sleep(1500) Then Return
							$iArmyPage = 4
						ElseIf $iArmyPage = 3 Then
							If _Sleep(250) Then Return
							ClickDrag(750, 475, 650, 475, 2000)
							If _Sleep(1500) Then Return
							ClickDrag(770, 475, 75, 475, 2000)
							If _Sleep(1500) Then Return
							$iArmyPage = 4
						EndIf
				EndSwitch
				Local $aTrainPos = GetTrainPos($iIndex + $eLSpell)
				If IsArray($aTrainPos) And $aTrainPos[0] <> -1 Then
					SetLog("Adding " & $g_aiQuickSpellQty[$i][$j] & "x " & $g_asSpellNames[$iIndex], $COLOR_SUCCESS)
					ClickP($aTrainPos, $g_aiQuickSpellQty[$i][$j], $g_iTrainClickDelay, "QTrain")
				EndIf
			EndIf
		Next

		If _Sleep(1000) Then Return
	EndIf
EndFunc   ;==>CreateQuickTrainPreset

Func UpdateNextPageQuickTroop()
	Local $aSlot1[4] = [585, 460, 667, 375]
	Local $aSlot2[4] = [585, 545, 667, 465]
	Local $aSlot3[4] = [670, 460, 752, 375]

	Local $sWizTile = @ScriptDir & "\imgxml\Train\Train_Train\Wiza*"

	If _Sleep(500) Then Return

	Local $aiTileCoord = decodeSingleCoord(findImage("UpdateNextPageQuickTroop", $sWizTile, GetDiamondFromRect("75,375,780,550"), 1, True))

	If IsArray($aiTileCoord) And UBound($aiTileCoord, 1) = 2 And _ColorCheck(_GetPixelColor(75, 385 + $g_iMidOffsetY, True), Hex(0xD3D3CB, 6), 5) And $aiTileCoord[0] > 580 Then
		SetDebugLog("Found Wizard at " & $aiTileCoord[0] & ", " & $aiTileCoord[1])

		If PointInRect($aSlot1[0], $aSlot1[1], $aSlot1[2], $aSlot1[3], $aiTileCoord[0], $aiTileCoord[1]) Then
			$g_iNextPageQuickTroop = $eDrag
			SetDebugLog("Found Wizard at normal place")
		EndIf

		If PointInRect($aSlot2[0], $aSlot2[1], $aSlot2[2], $aSlot2[3], $aiTileCoord[0], $aiTileCoord[1]) Then
			$g_iNextPageQuickTroop = $eHeal
			SetDebugLog("Found Wizard moved 1 Slot")
		EndIf

		If PointInRect($aSlot3[0], $aSlot3[1], $aSlot3[2], $aSlot3[3], $aiTileCoord[0], $aiTileCoord[1]) Then
			$g_iNextPageQuickTroop = $eSWiza
			SetDebugLog("Found Wizard moved 2 Slots")
		EndIf

	EndIf

	If _Sleep(200) Then Return

EndFunc   ;==>UpdateNextPageQuickTroop
