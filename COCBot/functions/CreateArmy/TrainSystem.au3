; #FUNCTION# ====================================================================================================================
; Name ..........: Train Revamp Oct 2016
; Description ...:
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Mr.Viper(10-2016), ProMac(10-2016), CodeSlinger69 (01-2018)
; Modified ......: ProMac (11-2016), Boju (11-2016), MR.ViPER (12-2016), CodeSlinger69 (01-2018)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once
#include <Array.au3>
#include <MsgBoxConstants.au3>

Func TrainSystem()
	If Not $g_bTrainEnabled Then ; check for training disabled in halt mode
		If $g_bDebugSetLogTrain Then SetLog("Halt mode - training disabled", $COLOR_DEBUG)
		Return
	EndIf

	$g_sTimeBeforeTrain = _NowCalc()
	StartGainCost()

	BoostSuperTroop()

	If $g_bQuickTrainEnable Then CheckQuickTrainTroop() ; update values of $g_aiArmyComTroops, $g_aiArmyComSpells

	CheckIfArmyIsReady()

	If $g_bQuickTrainEnable Then
		QuickTrain()
	Else
		TrainCustomArmy()
	EndIf

	TrainSiege()

	If $g_bDonationEnabled And $g_bChkDonate Then ResetVariables("donated")

	CloseWindow()
	If _Sleep(500) Then Return ; Delay AFTER the click Away Prevents lots of coc restarts

	EndGainCost("Train")

EndFunc   ;==>TrainSystem

Func TrainCustomArmy()
	If Not $g_bRunState Then Return
	If $g_bDebugSetLogTrain Then SetLog(" == Initial Custom Train == ", $COLOR_ACTION)

	If $g_iActiveDonate = -1 Then PrepareDonateCC()

	If Not $g_bRunState Then Return

	Local $rWhatToTrain = WhatToTrain(True)     ; r in First means Result! Result of What To Train Function
	Local $Isremoved = True
	If RemoveExtraTroops($rWhatToTrain) = 3 Then $Isremoved = False

	If _Sleep($DELAYRESPOND) Then Return ; add 5ms delay to catch TrainIt errors, and force return to back to main loop

	If Not $g_bRunState Then Return

	If $Isremoved Or Not $g_bFullArmy Or Not $g_bFullArmySpells Then
		Local $rWhatToTrain = WhatToTrain()
		If DoWhatToTrainContainTroop($rWhatToTrain) Then TrainUsingWhatToTrain($rWhatToTrain)
		If DoWhatToTrainContainSpell($rWhatToTrain) Then BrewUsingWhatToTrain($rWhatToTrain)
		CheckIfArmyIsReady(False)
	EndIf

	If _Sleep(250) Then Return
	If Not $g_bRunState Then Return
EndFunc   ;==>TrainCustomArmy

Func CheckIfArmyIsReady($IstoOpen = True)

	If Not $g_bRunState Then Return

	Local $bFullArmyCC = False
	Local $iTotalSpellsToBrew = 0
	Local $bFullArmyHero = False
	Local $g_bCheckSiege = False
	$g_bWaitForCCTroopSpell = False ; reset for waiting CC in SwitchAcc

	If $IstoOpen Then
		If Not OpenArmyOverview(False, "CheckIfArmyIsReady()") Then Return
		If _Sleep(250) Then Return
	Else
		If Not IsTrainPage() Then Return
	EndIf

	CheckArmyCamp(False, False, True, True)

	If $g_bDebugSetLogTrain Then
		SetLog(" - $g_CurrentCampUtilization : " & $g_CurrentCampUtilization)
		SetLog(" - $g_iTotalCampSpace : " & $g_iTotalCampSpace)
		SetLog(" - $g_bFullArmy : " & $g_bFullArmy)
		SetLog(" - $g_bPreciseArmy : " & $g_bPreciseArmy)
	EndIf

	$g_bFullArmySpells = False
	; Local Variable to check the occupied space by the Spells to Brew ... can be different of the Spells Factory Capacity ( $g_iTotalSpellValue )
	For $i = 0 To $eSpellCount - 1
		$iTotalSpellsToBrew += $g_aiArmyCompSpells[$i] * $g_aiSpellSpace[$i]
	Next

	If Number($g_iCurrentSpells) >= Number($g_iTotalSpellValue) Or Number($g_iCurrentSpells) >= Number($iTotalSpellsToBrew) Then $g_bFullArmySpells = True

	If (Not $g_bFullArmy And Not $g_bFullArmySpells) Or $g_bPreciseArmy Then
		Local $avWrongTroops = WhatToTrain(True)
		Local $rRemoveExtraTroops = RemoveExtraTroops($avWrongTroops)
		If $rRemoveExtraTroops = 1 Or $rRemoveExtraTroops = 2 Then
			CheckArmyCamp(False, False, False, False)
			$g_bFullArmySpells = Number($g_iCurrentSpells) >= Number($g_iTotalSpellValue) Or Number($g_iCurrentSpells) >= Number($iTotalSpellsToBrew)
		EndIf
	EndIf

	$g_bCheckSpells = CheckSpells()

	; add to the hereos available, the ones upgrading so that it ignores them... we need this logic or the bitwise math does not work out correctly
	$g_iHeroAvailable = BitOR($g_iHeroAvailable, $g_iHeroUpgradingBit)
	$bFullArmyHero = (BitAND($g_aiSearchHeroWaitEnable[$DB], $g_iHeroAvailable) = $g_aiSearchHeroWaitEnable[$DB] And $g_abAttackTypeEnable[$DB]) Or _
			(BitAND($g_aiSearchHeroWaitEnable[$LB], $g_iHeroAvailable) = $g_aiSearchHeroWaitEnable[$LB] And $g_abAttackTypeEnable[$LB]) Or _
			($g_aiSearchHeroWaitEnable[$DB] = $eHeroNone And $g_aiSearchHeroWaitEnable[$LB] = $eHeroNone)

	If $g_bDebugSetLogTrain Then
		SetLog("Heroes are Ready: " & String($bFullArmyHero))
		SetLog("Heroes Available Num: " & $g_iHeroAvailable) ;  	$eHeroNone = 0, $eHeroKing = 1, $eHeroQueen = 2, $eHeroPrince = 4, $eHeroWarden = 8, $eHeroChampion = 16
		SetLog("Search Hero Wait Enable [$DB] Num: " & $g_aiSearchHeroWaitEnable[$DB]) ; 	what you are waiting for : 1 is King , 3 is King + Queen , etc etc
		SetLog("Search Hero Wait Enable [$LB] Num: " & $g_aiSearchHeroWaitEnable[$LB])
		SetLog("Dead Base BitAND: " & BitAND($g_aiSearchHeroWaitEnable[$DB], $g_iHeroAvailable))
		SetLog("Live Base BitAND: " & BitAND($g_aiSearchHeroWaitEnable[$LB], $g_iHeroAvailable))
		SetLog("Are you 'not' waiting for Heroes: " & String($g_aiSearchHeroWaitEnable[$DB] = $eHeroNone And $g_aiSearchHeroWaitEnable[$LB] = $eHeroNone))
		SetLog("Is Wait for Heroes Active : " & IsWaitforHeroesActive())
	EndIf

	$bFullArmyCC = IsFullClanCastle()
	$g_bCheckSiege = CheckSiegeMachine()

	; If Drop Trophy with Heroes is checked and a Hero is Available or under the trophies range, then set $g_bFullArmyHero to True
	If Not IsWaitforHeroesActive() And $g_bDropTrophyUseHeroes Then $bFullArmyHero = True
	If Not IsWaitforHeroesActive() And Not $g_bDropTrophyUseHeroes And Not $bFullArmyHero Then
		If $g_iHeroAvailable > 0 Or Number($g_aiCurrentLoot[$eLootTrophy]) <= Number($g_iDropTrophyMax) Then
			$bFullArmyHero = True
		Else
			SetLog("Waiting for Heroes to drop trophies!", $COLOR_ACTION)
		EndIf
	EndIf

	If $g_bFullArmy And $g_bCheckSpells And $bFullArmyHero And $bFullArmyCC And $g_bCheckSiege Then
		$g_bIsFullArmywithHeroesAndSpells = True
	Else
		If $g_bDebugSetLog Then
			SetDebugLog(" $g_bFullArmy: " & String($g_bFullArmy), $COLOR_DEBUG)
			SetDebugLog(" $g_bCheckSpells: " & String($g_bCheckSpells), $COLOR_DEBUG)
			SetDebugLog(" $bFullArmyHero: " & String($bFullArmyHero), $COLOR_DEBUG)
			SetDebugLog(" $g_bCheckSiege: " & String($g_bCheckSiege), $COLOR_DEBUG)
			SetDebugLog(" $bFullArmyCC: " & String($bFullArmyCC), $COLOR_DEBUG)
		EndIf
		$g_bIsFullArmywithHeroesAndSpells = False
	EndIf
	If $g_bFullArmy And $g_bCheckSpells And $bFullArmyHero Then ; Force Switch while waiting for CC in SwitchAcc
		If Not $bFullArmyCC Then $g_bWaitForCCTroopSpell = True
	EndIf

	Local $sLogText = ""
	If Not $g_bFullArmy Then $sLogText &= " Troops,"
	If Not $g_bCheckSpells Then $sLogText &= " Spells,"
	If Not $bFullArmyHero Then $sLogText &= " Heroes,"
	If Not $g_bCheckSiege Then $sLogText &= " Siege Machine,"
	If Not $bFullArmyCC Then $sLogText &= " Clan Castle,"
	If StringRight($sLogText, 1) = "," Then $sLogText = StringTrimRight($sLogText, 1) ; Remove last "," as it is not needed

	If $g_bIsFullArmywithHeroesAndSpells Then
		If $g_bNotifyTGEnable And $g_bNotifyAlertCampFull Then PushMsg("CampFull")
		SetLog("Chief, is your Army ready? Yes, it is!", $COLOR_SUCCESS)
	Else
		SetLog("Chief, is your Army ready? No, not yet!", $COLOR_ACTION)
		If $sLogText <> "" Then SetLog(@TAB & "Waiting for " & $sLogText, $COLOR_ACTION)
	EndIf

	; Force to Request CC troops or Spells
	If Not $bFullArmyCC Then $g_bCanRequestCC = True
	If $g_bDebugSetLog Then
		SetDebugLog(" $g_bFullArmy: " & String($g_bFullArmy), $COLOR_DEBUG)
		SetDebugLog(" $bCheckCC: " & String($bFullArmyCC), $COLOR_DEBUG)
		SetDebugLog(" $g_bIsFullArmywithHeroesAndSpells: " & String($g_bIsFullArmywithHeroesAndSpells), $COLOR_DEBUG)
		SetDebugLog(" $g_iTownHallLevel: " & Number($g_iTownHallLevel), $COLOR_DEBUG)
	EndIf

EndFunc   ;==>CheckIfArmyIsReady

Func CheckSpells()
	If Not $g_bRunState Then Return

	Local $bToReturn = False

	If (Not $g_abSearchSpellsWaitEnable[$DB] And Not $g_abSearchSpellsWaitEnable[$LB]) Or ($g_bFullArmySpells And ($g_abSearchSpellsWaitEnable[$DB] Or $g_abSearchSpellsWaitEnable[$LB])) Then
		Return True
	EndIf

	If (($g_abAttackTypeEnable[$DB] And $g_abSearchSpellsWaitEnable[$DB]) Or ($g_abAttackTypeEnable[$LB] And $g_abSearchSpellsWaitEnable[$LB])) And $g_iTownHallLevel >= 5 Then
		$bToReturn = $g_bFullArmySpells
	Else
		$bToReturn = True
	EndIf

	Return $bToReturn
EndFunc   ;==>CheckSpells

Func CheckSiegeMachine()

	If Not $g_bRunState Then Return

	Local $bToReturn = False

	If IsWaitforSiegeMachine() Then
		For $i = $eSiegeWallWrecker To $eSiegeMachineCount - 1
			If $g_aiArmyCompSiegeMachines[$i] > 0 Then
				If $g_aiCurrentSiegeMachines[$i] > 0 Then $bToReturn = True
				If $g_bDebugSetLogTrain Then
					SetLog("$g_aiCurrentSiegeMachines[" & $g_asSiegeMachineNames[$i] & "]: " & $g_aiCurrentSiegeMachines[$i])
					SetLog("$g_aiArmyCompSiegeMachine[" & $g_asSiegeMachineNames[$i] & "]: " & $g_aiArmyCompSiegeMachines[$i])
				EndIf
			EndIf
		Next
	Else
		$bToReturn = True
	EndIf

	Return $bToReturn
EndFunc   ;==>CheckSiegeMachine

Func TrainUsingWhatToTrain($rWTT, $bQueue = $g_bIsFullArmywithHeroesAndSpells)
	If Not $g_bRunState Then Return

	If UBound($rWTT) = 1 And $rWTT[0][0] = "Arch" And $rWTT[0][1] = 0 Then Return True ; If was default Result of WhatToTrain

	Local $aLeftSpace = GetOCRCurrent(393, 212 + $g_iMidOffsetY, "troops")
	Local $LeftSpace = $aLeftSpace[1] - $aLeftSpace[0]

	; Loop through needed troops to Train
	For $i = 0 To (UBound($rWTT) - 1)
		If Not $g_bRunState Then Return
		If $rWTT[$i][1] > 0 Then ; If Count to Train Was Higher Than ZERO
			If IsSpellToBrew($rWTT[$i][0]) Then ContinueLoop

			Local $iTroopIndex = TroopIndexLookup($rWTT[$i][0], "TrainUsingWhatToTrain()")

			If $iTroopIndex >= $eBarb And $iTroopIndex <= $eFurn Then
				Local $NeededSpace = $g_aiTroopSpace[$iTroopIndex] * $rWTT[$i][1]
			EndIf

			If $NeededSpace > $LeftSpace Then
				If $iTroopIndex >= $eBarb And $iTroopIndex <= $eFurn Then
					$rWTT[$i][1] = Int($LeftSpace / $g_aiTroopSpace[$iTroopIndex])
				EndIf
			EndIf

			If $rWTT[$i][1] > 0 Then

				If Not IsTrainPageGrayed(False, 1) Then
					If Not OpenTroopsTab(True, "TrainUsingWhatToTrain()") Then Return
				EndIf

				If Not DragIfNeeded($rWTT[$i][0]) Then Return False

				If $iTroopIndex >= $eBarb And $iTroopIndex <= $eFurn Then
					Local $sTroopName = ($rWTT[$i][1] > 1 ? $g_asTroopNamesPlural[$iTroopIndex] : $g_asTroopNames[$iTroopIndex])
				EndIf

				SetLog("Training " & $rWTT[$i][1] & "x " & $sTroopName, $COLOR_SUCCESS)
				TrainIt($iTroopIndex, $rWTT[$i][1], $g_iTrainClickDelay)
				$LeftSpace -= $rWTT[$i][1] * $g_aiTroopSpace[$iTroopIndex]

			EndIf
		EndIf
		If _Sleep($DELAYRESPOND) Then Return ; add 5ms delay to catch TrainIt errors, and force return to back to main loop
	Next

	If IsTrainPageGrayed(False, 3) Then
		Click(Random(240, 360, 1), Random(190 + $g_iMidOffsetY, 210 + $g_iMidOffsetY, 1), 1, 120)
		If _Sleep(250) Then Return
	EndIf

	Return True
EndFunc   ;==>TrainUsingWhatToTrain

Func BrewUsingWhatToTrain($rWTT, $bQueue = $g_bIsFullArmywithHeroesAndSpells)
	If Not $g_bRunState Then Return
	If UBound($rWTT) = 1 And $rWTT[0][0] = "Arch" And $rWTT[0][1] = 0 Then Return True ; If was default Result of WhatToTrain

	Local $aLeftSpace = GetOCRCurrent(399, 321 + $g_iMidOffsetY, "spells")
	Local $LeftSpace = $aLeftSpace[1] - $aLeftSpace[0]

	; Loop through needed troops to Train
	For $i = 0 To (UBound($rWTT) - 1)
		If Not $g_bRunState Then Return
		If $rWTT[$i][1] > 0 Then ; If Count to Train Was Higher Than ZERO
			If Not IsSpellToBrew($rWTT[$i][0]) Then ContinueLoop

			Local $iSpellIndex = TroopIndexLookup($rWTT[$i][0], "BrewUsingWhatToTrain")
			Local $NeededSpace = $g_aiSpellSpace[$iSpellIndex - $eLSpell] * $rWTT[$i][1]

			If $NeededSpace > $LeftSpace Then $rWTT[$i][1] = Int($LeftSpace / $g_aiSpellSpace[$iSpellIndex - $eLSpell])

			If $rWTT[$i][1] > 0 Then

				If Not IsTrainPageGrayed(False, 1) Then
					If Not OpenSpellsTab(True, "BrewUsingWhatToTrain()") Then Return
				EndIf

				Local $sSpellName = $g_asSpellNames[$iSpellIndex - $eLSpell]
				SetLog("Brewing " & $rWTT[$i][1] & "x " & $sSpellName & ($rWTT[$i][1] > 1 ? " Spells" : " Spell"), $COLOR_SUCCESS)
				TrainIt($iSpellIndex, $rWTT[$i][1], $g_iTrainClickDelay)
				$LeftSpace -= $rWTT[$i][1] * $g_aiSpellSpace[$iSpellIndex - $eLSpell]
			EndIf
		EndIf
		If _Sleep($DELAYRESPOND) Then Return ; add 5ms delay to catch TrainIt errors, and force return to back to main loop
	Next

	If IsTrainPageGrayed(False, 3) Then
		Click(Random(240, 360, 1), Random(190 + $g_iMidOffsetY, 210 + $g_iMidOffsetY, 1), 1, 120)
		If _Sleep(250) Then Return
	EndIf

EndFunc   ;==>BrewUsingWhatToTrain

Func TotalSpellsToBrewInGUI()
	Local $iTotalSpellsInGUI = 0
	If $g_iTotalSpellValue = 0 Then Return $iTotalSpellsInGUI
	If Not $g_bRunState Then Return
	For $i = 0 To $eSpellCount - 1
		$iTotalSpellsInGUI += $g_aiArmyCompSpells[$i] * $g_aiSpellSpace[$i]
	Next
	Return $iTotalSpellsInGUI
EndFunc   ;==>TotalSpellsToBrewInGUI

Func DragTrainBar($iIndex, ByRef $iTrainPage, $iEventTroops = 0)
	Local $iY1
	Local $iY2
	Local $iPageTarget
	Local $bLoop = 0
	Local $ExtendedSlots = 0, $ColumnsOffset = 0

	Switch $iEventTroops
		Case 2, 3
			$ColumnsOffset = 1
		Case 4, 5
			$ColumnsOffset = 2
	EndSwitch

	Switch $iIndex
		Case 0 To (17 - $iEventTroops) ; Barb To Thrower - EventTroop slots
			$iPageTarget = 0
		Case (18 - $iEventTroops) To 29 ; Minion - EventTroop slots To Furn
			$iPageTarget = 1
		Case 30 To 45 ; Suba To SBowl
			$iPageTarget = 2
	EndSwitch

	While 1

		If $iTrainPage = $iPageTarget Then ExitLoop

		If $iTrainPage < $iPageTarget Then
			If $iTrainPage = 0 Then
				ClickDrag(755, 564 + $g_iBottomOffsetY, 305 - (88 * $ColumnsOffset), 564 + $g_iBottomOffsetY)
				SetDebugLog("Moving from page 0 to 1")
			ElseIf $iTrainPage = 1 Then
				ClickDrag(655, 564 + $g_iBottomOffsetY, 520, 564 + $g_iBottomOffsetY)
				SetDebugLog("Moving from page 1 to 2")
			EndIf
			If _Sleep(Random(1500, 2000, 1)) Then Return
			If $iTrainPage = 1 Then
				If Not _ColorCheck(_GetPixelColor(847, 530 + $g_iBottomOffsetY, True), Hex(0x302A29, 6), 5) Then ContinueLoop
			EndIf
			$iTrainPage += 1
			If $iTrainPage = 2 Then $ExtendedSlots = ExtendedSlots($iEventTroops)
		EndIf

		If $iTrainPage > $iPageTarget Then
			If $iTrainPage = 2 Then
				$ExtendedSlots = ExtendedSlots($iEventTroops)
				ClickDrag(335 - (94 * $ExtendedSlots), 564 + $g_iBottomOffsetY, 318, 564 + $g_iBottomOffsetY)
				SetDebugLog("Moving from page 2 to 1")
			Else
				ClickDrag(300 - (88 * $ColumnsOffset), 564 + $g_iBottomOffsetY, 755, 564 + $g_iBottomOffsetY)
				SetDebugLog("Moving from page 1 to 0")
			EndIf
			If _Sleep(Random(1500, 2000, 1)) Then Return
			If $iTrainPage = 1 Then
				If Not _ColorCheck(_GetPixelColor(20, 530 + $g_iBottomOffsetY, True), Hex(0x302A29, 6), 5) Then ContinueLoop
			EndIf
			$iTrainPage -= 1
		EndIf

		$bLoop += 1
		If $bLoop = 10 Then ExitLoop

	WEnd

EndFunc   ;==>DragTrainBar

Func DragIfNeeded($Troop)

	If Not $g_bRunState Then Return
	Local $iIndex = TroopIndexLookup($Troop, "DragIfNeeded")
	Local $sBarbTile = @ScriptDir & "\imgxml\Train\Train_Train\Barb*"

	Local $aBarbTile = decodeSingleCoord(findImage("BarbTile", $sBarbTile, GetDiamondFromRect2(20, 478 + $g_iBottomOffsetY, 285, 650 + $g_iBottomOffsetY), 1, True))
	If IsArray($aBarbTile) And UBound($aBarbTile, 1) = 2 Then
		$iTrainPage = 0
		$iEventTroops = IsEventTroops()
	EndIf

	DragTrainBar($iIndex, $iTrainPage, $iEventTroops)
	Return True

EndFunc   ;==>DragIfNeeded

Func IsEventTroops()

	If Not $g_bRunState Then Return

	Local $sBarbTile = @ScriptDir & "\imgxml\Train\Train_Train\Barb*"

	Local $aBarbTile = decodeSingleCoord(findImage("BarbTile", $sBarbTile, GetDiamondFromRect2(20, 478 + $g_iBottomOffsetY, 107, 550 + $g_iBottomOffsetY), 1, True))
	If IsArray($aBarbTile) And UBound($aBarbTile, 1) = 2 Then Return 0

	Local $aSlot1[4] = [20, 710, 107, 630] ; Barb Pos 2
	Local $aSlot2[4] = [110, 618, 193, 538] ; Barb Pos 3
	Local $aSlot3[4] = [110, 710, 193, 630] ; Barb Pos 4
	Local $aSlot4[4] = [200, 618, 282, 538] ; Barb Pos 5
	Local $aSlot5[4] = [200, 710, 282, 630] ; Barb Pos 6

	Local $aiTileCoord = decodeSingleCoord(findImage("IsEventTroops", $sBarbTile, GetDiamondFromRect2(20, 478 + $g_iBottomOffsetY, 285, 650 + $g_iBottomOffsetY), 1, True))

	If IsArray($aiTileCoord) And UBound($aiTileCoord, 1) = 2 Then
		SetDebugLog("Found barbarian at " & $aiTileCoord[0] & ", " & $aiTileCoord[1])

		If PointInRect($aSlot1[0], $aSlot1[1], $aSlot1[2], $aSlot1[3], $aiTileCoord[0], $aiTileCoord[1]) Then
			SetLog("Found Barbarian moved 1 slot")
			If _Sleep(100) Then Return
			Return 1
		ElseIf PointInRect($aSlot2[0], $aSlot2[1], $aSlot2[2], $aSlot2[3], $aiTileCoord[0], $aiTileCoord[1]) Then
			SetLog("Found Barbarian moved 2 slots")
			If _Sleep(100) Then Return
			Return 2
		ElseIf PointInRect($aSlot3[0], $aSlot3[1], $aSlot3[2], $aSlot3[3], $aiTileCoord[0], $aiTileCoord[1]) Then
			SetLog("Found Barbarian moved 3 slots")
			If _Sleep(100) Then Return
			Return 3
		ElseIf PointInRect($aSlot4[0], $aSlot4[1], $aSlot4[2], $aSlot4[3], $aiTileCoord[0], $aiTileCoord[1]) Then
			SetLog("Found Barbarian moved 4 slots")
			If _Sleep(100) Then Return
			Return 4
		ElseIf PointInRect($aSlot5[0], $aSlot5[1], $aSlot5[2], $aSlot5[3], $aiTileCoord[0], $aiTileCoord[1]) Then
			SetLog("Found Barbarian moved 5 slots")
			If _Sleep(100) Then Return
			Return 5
		EndIf

	EndIf

	If _Sleep(100) Then Return

EndFunc   ;==>IsEventTroops

Func ExtendedSlots($iEventTroops = 0)

	Local $sMinionTile = @ScriptDir & "\imgxml\Train\Train_Train\Mini*"

	If $iEventTroops = 0 Then

		Local $aSlot1[4] = [320, 618, 408, 538] ; Minion Pos 1 (Default)
		Local $aSlot2[4] = [235, 618, 316, 538] ; Minion Pos 2
		Local $aSlot3[4] = [146, 618, 230, 538] ; Minion Pos 3
		Local $aSlot4[4] = [58, 618, 142, 538] ; Minion Pos 3

		Local $aiTileCoord = decodeSingleCoord(findImage("ExtendedSlots", $sMinionTile, GetDiamondFromRect2(20, 478 + $g_iBottomOffsetY, 410, 550 + $g_iBottomOffsetY), 1, True))

		If IsArray($aiTileCoord) And UBound($aiTileCoord, 1) = 2 Then
			SetDebugLog("Found Minion at " & $aiTileCoord[0] & ", " & $aiTileCoord[1])

			If PointInRect($aSlot1[0], $aSlot1[1], $aSlot1[2], $aSlot1[3], $aiTileCoord[0], $aiTileCoord[1]) Then
				SetDebugLog("Found Minion at original position")
				If _Sleep(100) Then Return
				Return 0
			ElseIf PointInRect($aSlot2[0], $aSlot2[1], $aSlot2[2], $aSlot2[3], $aiTileCoord[0], $aiTileCoord[1]) Then
				SetLog("Found Minion moved 1 column")
				If _Sleep(100) Then Return
				Return 1
			ElseIf PointInRect($aSlot3[0], $aSlot3[1], $aSlot3[2], $aSlot3[3], $aiTileCoord[0], $aiTileCoord[1]) Then
				SetLog("Found Minion moved 2 columns")
				If _Sleep(100) Then Return
				Return 2
			ElseIf PointInRect($aSlot4[0], $aSlot4[1], $aSlot4[2], $aSlot4[3], $aiTileCoord[0], $aiTileCoord[1]) Then
				SetLog("Found Minion moved 3 columns")
				If _Sleep(100) Then Return
				Return 3
			EndIf

		EndIf

	Else

		Local $aSlot1[4] = [235, 710, 315, 630] ; Minion Pos 1
		Local $aSlot2[4] = [324, 618, 404, 538] ; Minion Pos 2
		Local $aSlot3[4] = [146, 710, 230, 630] ; Minion Pos 3
		Local $aSlot4[4] = [235, 618, 315, 538] ; Minion Pos 4

		Local $aiTileCoord = decodeSingleCoord(findImage("ExtendedSlots", $sMinionTile, GetDiamondFromRect2(55, 478 + $g_iBottomOffsetY, 410, 650 + $g_iBottomOffsetY), 1, True))

		If IsArray($aiTileCoord) And UBound($aiTileCoord, 1) = 2 Then
			SetDebugLog("Found Minion at " & $aiTileCoord[0] & ", " & $aiTileCoord[1])

			If PointInRect($aSlot1[0], $aSlot1[1], $aSlot1[2], $aSlot1[3], $aiTileCoord[0], $aiTileCoord[1]) Then
				SetLog("Found Minion moved 1 slot, same column")
				If _Sleep(100) Then Return
				Return 0
			ElseIf PointInRect($aSlot2[0], $aSlot2[1], $aSlot2[2], $aSlot2[3], $aiTileCoord[0], $aiTileCoord[1]) Then
				SetLog("Found Minion moved 2 slots, same column")
				If _Sleep(100) Then Return
				Return 0
			ElseIf PointInRect($aSlot3[0], $aSlot3[1], $aSlot3[2], $aSlot3[3], $aiTileCoord[0], $aiTileCoord[1]) Then
				SetLog("Found Minion moved 1 column")
				If _Sleep(100) Then Return
				Return 1
			ElseIf PointInRect($aSlot4[0], $aSlot4[1], $aSlot4[2], $aSlot4[3], $aiTileCoord[0], $aiTileCoord[1]) Then
				SetLog("Found Minion moved 1 column")
				If _Sleep(100) Then Return
				Return 1
			EndIf

		EndIf

	EndIf

	If _Sleep(100) Then Return

EndFunc   ;==>ExtendedSlots

#cs
Func DragIfNeeded($Troop)

	If Not $g_bRunState Then Return
	Local $bCheckPixel = False
	Local $iIndex = TroopIndexLookup($Troop, "DragIfNeeded")
	Local $bDrag = False, $ExtendedTroops = False, $ExtendedDragTroops = 0
	Local $bMoveCount = $eETitan - $g_iNextPageTroop
	Local $sBarbTile = @ScriptDir & "\imgxml\Train\Train_Train\Barb*"

	If $iIndex > $g_iNextPageTroop Then $bDrag = True ; Drag if Troops is on Right side from $g_iNextPageTroop
	If $iIndex > $eDruid Then $bDrag = False ; No Drag If Event Troops

	Switch $bMoveCount
		Case 0
			SetDebugLog("No Hidden Troop Slot To Manage")
		Case 1, 2
			If $g_iDarkTroopOffset Then $ExtendedTroops = True
		Case 3, 4
			$ExtendedTroops = True
		Case 5, 6
			$ExtendedDragTroops = 85
			$ExtendedTroops = True
		Case 7
			$ExtendedDragTroops = 170
			$ExtendedTroops = True
		Case Else
			SetDebugLog("Never seen such a gap before!")
	EndSwitch

	If $bDrag Then
		If _ColorCheck(_GetPixelColor(777, 380 + $g_iMidOffsetY, True), Hex(0xD3D3CB, 6), 5) Then $bCheckPixel = True
		If $g_bDebugSetLogTrain Then SetLog("DragIfNeeded : to the right")
		For $i = 1 To 4
			If Not $bCheckPixel Then
				ClickDrag(715, 433 + $g_iMidOffsetY, 230, 433 + $g_iMidOffsetY)
				If _Sleep(Random(1500, 2000, 1)) Then Return
				If _ColorCheck(_GetPixelColor(777, 380 + $g_iMidOffsetY, True), Hex(0xD3D3CB, 6), 5) Then
					$bCheckPixel = True
					IsDarkTroopOffset()
					If Not $ExtendedTroops Then ; First Look
						If $bMoveCount = 1 Or $bMoveCount = 2 Then
							If $g_iDarkTroopOffset Then $ExtendedTroops = True
						EndIf
					EndIf
					If ($ExtendedTroops And $iIndex > $g_iNextPageTroop And $iIndex <= $g_iNextPageTroop + $bMoveCount) Or _
							($g_iDarkTroopOffset And $iIndex > $eRDrag And $iIndex < $eThrower) Then
						If $g_bDebugSetLogTrain Then SetLog("DragIfNeeded : MicroDrag to the left")
						ClickDrag(250, 433 + $g_iMidOffsetY, 435 + $ExtendedDragTroops, 433 + $g_iMidOffsetY)
						If _Sleep(Random(1500, 2000, 1)) Then Return
						Return True
					EndIf
				EndIf
			Else
				IsDarkTroopOffset()
				If Not $ExtendedTroops Then ; First Look
					If $bMoveCount = 1 Or $bMoveCount = 2 Then
						If $g_iDarkTroopOffset Then $ExtendedTroops = True
					EndIf
				EndIf
				If $ExtendedTroops And $iIndex > $g_iNextPageTroop And $iIndex <= $g_iNextPageTroop + $bMoveCount Or _
						($g_iDarkTroopOffset And $iIndex > $eRDrag And $iIndex < $eThrower) Then
					If $g_bDebugSetLogTrain Then SetLog("DragIfNeeded : MicroDrag to the left")
					ClickDrag(250, 433 + $g_iMidOffsetY, 435 + $ExtendedDragTroops, 433 + $g_iMidOffsetY)
					If _Sleep(Random(1500, 2000, 1)) Then Return
				EndIf
				Return True
			EndIf
		Next
	Else
		If _ColorCheck(_GetPixelColor(77, 380 + $g_iMidOffsetY, True), Hex(0xD3D3CB, 6), 5) Then
			Local $aBarbTile = decodeSingleCoord(findImage("BarbTile", $sBarbTile, GetDiamondFromRect2(80, 350 + $g_iMidOffsetY, 160, 410 + $g_iMidOffsetY), 1, True))
			If IsArray($aBarbTile) And UBound($aBarbTile, 1) = 2 Then $bCheckPixel = True
		EndIf
		If $g_bDebugSetLogTrain Then SetLog("DragIfNeeded : to the left")
		For $i = 1 To 4
			If Not $bCheckPixel Then
				ClickDrag(200, 433 + $g_iMidOffsetY, 685, 433 + $g_iMidOffsetY)
				If _Sleep(Random(1500, 2000, 1)) Then Return
				If _ColorCheck(_GetPixelColor(77, 380 + $g_iMidOffsetY, True), Hex(0xD3D3CB, 6), 5) Then
					Local $aBarbTile = decodeSingleCoord(findImage("BarbTile", $sBarbTile, GetDiamondFromRect2(80, 350 + $g_iMidOffsetY, 160, 410 + $g_iMidOffsetY), 1, True))
					If IsArray($aBarbTile) And UBound($aBarbTile, 1) = 2 Then $bCheckPixel = True
				EndIf
			Else
				Return True
			EndIf
		Next
	EndIf
	Return False
EndFunc   ;==>DragIfNeeded
#ce
Func DoWhatToTrainContainTroop($rWTT)
	If UBound($rWTT) = 1 And $rWTT[0][0] = "Arch" And $rWTT[0][1] = 0 Then Return False ; If was default Result of WhatToTrain
	For $i = 0 To (UBound($rWTT) - 1)
		If (IsElixirTroop($rWTT[$i][0]) Or IsDarkTroop($rWTT[$i][0])) And $rWTT[$i][1] > 0 Then Return True
	Next
	Return False
EndFunc   ;==>DoWhatToTrainContainTroop

Func DoWhatToTrainContainSpell($rWTT)
	For $i = 0 To (UBound($rWTT) - 1)
		If Not $g_bRunState Then Return
		If IsSpellToBrew($rWTT[$i][0]) Then
			If $rWTT[$i][1] > 0 Then Return True
		EndIf
	Next
	Return False
EndFunc   ;==>DoWhatToTrainContainSpell

Func IsElixirTroop($Troop)
	Local $iIndex = TroopIndexLookup($Troop, "IsElixirTroop")
	If $iIndex >= $eBarb And $iIndex <= $eThrower Then Return True
	Return False
EndFunc   ;==>IsElixirTroop

Func IsDarkTroop($Troop)
	Local $iIndex = TroopIndexLookup($Troop, "IsDarkTroop")
	If $iIndex >= $eMini And $iIndex <= $eFurn Then Return True
	Return False
EndFunc   ;==>IsDarkTroop

Func IsElixirSpell($Spell)
	Local $iIndex = TroopIndexLookup($Spell, "IsElixirSpell")
	If $iIndex >= $eLSpell And $iIndex <= $eISpell Then Return True
	Return False
EndFunc   ;==>IsElixirSpell

Func IsDarkSpell($Spell)
	Local $iIndex = TroopIndexLookup($Spell, "IsDarkSpell")
	If $iIndex >= $ePSpell And $iIndex <= $eOgSpell Then Return True
	Return False
EndFunc   ;==>IsDarkSpell

Func IsSpellToBrew($sName)
	Local $iIndex = TroopIndexLookup($sName, "IsSpellToBrew")
	If $iIndex >= $eLSpell And $iIndex <= $eOgSpell Then Return True
	Return False
EndFunc   ;==>IsSpellToBrew

Func RemoveExtraTroops($toRemove)
	Local $TroopsToRemove = 0, $SpellsToRemove = 0, $iResult = 0
	; Army Window should be open and should be in Tab 'Army tab'

	; 1 Means Removed Troops without Deleting Troops Queued
	; 2 Means Removed Troops And Also Deleted Troops Queued
	; 3 Means Didn't removed troop... Everything was well

	If UBound($toRemove) = 1 And $toRemove[0][0] = "Arch" And $toRemove[0][1] = 0 Then Return 3

	If ($g_iCommandStop = 3 Or $g_iCommandStop = 0) And Not $g_iActiveDonate Then Return 3

	If UBound($toRemove) > 0 Then ; If needed to remove troops

		; Loop through Troops/Spells needed to get removed Just to write some Logs
		For $i = 0 To (UBound($toRemove) - 1)
			If IsElixirTroop($toRemove[$i][0]) Or IsDarkTroop($toRemove[$i][0]) Then $TroopsToRemove += 1
			If IsSpellToBrew($toRemove[$i][0]) Then $SpellsToRemove += 1
		Next

		If $TroopsToRemove > 0 Then
			SetLog("Troops Removing.", $COLOR_INFO)
			Click(793, 218 + $g_iMidOffsetY)
			If _Sleep(250) Then Return
			Local $aiOkayButton = findButton("Okay", Default, 1, True)
			If IsArray($aiOkayButton) And UBound($aiOkayButton, 1) = 2 Then
				Click($aiOkayButton[0], $aiOkayButton[1])     ; Click Okay Button
				If _Sleep(200) Then Return
			EndIf
		EndIf

		If $SpellsToRemove > 0 Then
			SetLog("Spells Removing.", $COLOR_INFO)
			Click(637, 326 + $g_iMidOffsetY)
			If _Sleep(250) Then Return
			Local $aiOkayButton = findButton("Okay", Default, 1, True)
			If IsArray($aiOkayButton) And UBound($aiOkayButton, 1) = 2 Then
				Click($aiOkayButton[0], $aiOkayButton[1]) ; Click Okay Button
				If _Sleep(200) Then Return
			EndIf
		EndIf

		If _Sleep(200) Then Return
		If Not $g_bRunState Then Return

		If $iResult = 0 Then $iResult = 1

	Else

		$iResult = 3

	EndIf

	Return $iResult
EndFunc   ;==>RemoveExtraTroops

Func DeleteInvalidTroopInArray(ByRef $aTroopArray)
	Local $iCounter = 0

	Switch (UBound($aTroopArray, 2) > 0) ; If Array Is 2D Array
		Case True
			Local $bIsValid = True, $i2DBound = UBound($aTroopArray, 2)
			For $i = 0 To (UBound($aTroopArray) - 1)
				If $aTroopArray[$i][0] Then
					If TroopIndexLookup($aTroopArray[$i][0], "DeleteInvalidTroopInArray#1") = -1 Or $aTroopArray[$i][0] = "" Then $bIsValid = False

					If $bIsValid Then
						For $j = 0 To (UBound($aTroopArray, 2) - 1)
							$aTroopArray[$iCounter][$j] = $aTroopArray[$i][$j]
						Next
						$iCounter += 1
					EndIf
				EndIf
			Next
			ReDim $aTroopArray[$iCounter][$i2DBound]
		Case Else
			For $i = 0 To (UBound($aTroopArray) - 1)
				If TroopIndexLookup($aTroopArray[$i], "DeleteInvalidTroopInArray#2") = -1 Or $aTroopArray[$i] = "" Then
					$aTroopArray[$iCounter] = $aTroopArray[$i]
					$iCounter += 1
				EndIf
			Next
			ReDim $aTroopArray[$iCounter]
	EndSwitch
EndFunc   ;==>DeleteInvalidTroopInArray

Func RemoveExtraTroopsQueue() ; Will remove All Extra troops in queue If there's a Low Opacity red color on them
	FuncEnter(RemoveExtraTroopsQueue, $g_bDebugSetLogTrain)
	;Local Const $DecreaseByStep = 69 ; spacing between troop icons
	;Local $x = 775  ; right most position moved Dec 2023 update window size change
	Local Const $y = 185 + $g_iMidOffsetY ; Pink pixel check Y location
	Local Const $yRemoveBtn = 198 + $g_iMidOffsetY ; Troop remove button Y location
	Local Const $xDecreaseRemoveBtn = 9 ; offset to remove button location
	Local $bColorCheck = False, $bGotRemoved = False
	For $x = 775 To 73 Step -61
		If Not $g_bRunState Then Return FuncReturn(False, $g_bDebugSetLogTrain)
		$bColorCheck = _ColorCheck(_GetPixelColor($x, $y, True, $g_bDebugSetLogTrain ? "RemoveExtraTroopsQueue_ExtraTroops:D7AFA9" : Default), Hex(0xD7AFA9, 6), 20)  ;check for pink right of troop icon
		If $bColorCheck Then
			$bGotRemoved = True
			Do
				Click($x - $xDecreaseRemoveBtn, $yRemoveBtn, 2, $g_iTrainClickDelay)  ;Offset click of remove button
				If _Sleep(20) Then Return FuncReturn($bGotRemoved, $g_bDebugSetLogTrain)
				$bColorCheck = _ColorCheck(_GetPixelColor($x, $y, True, $g_bDebugSetLogTrain ? "RemoveExtraTroopsQueue_RemoveButton:EA0F12" : Default), Hex(0xD7AFA9, 6), 20) ;check for pink right of troop icon
			Until $bColorCheck = False
		ElseIf Not $bColorCheck And $bGotRemoved Then
			ExitLoop
		EndIf
	Next
	Return FuncReturn($bGotRemoved, $g_bDebugSetLogTrain)
EndFunc   ;==>RemoveExtraTroopsQueue

Func IsQueueEmpty($sType = "Troops", $bSkipTabCheck = False, $removeExtraTroopsQueue = True)
	FuncEnter(IsQueueEmpty, $g_bDebugSetLogTrain)

	Local $iArrowX, $iArrowY
	If Not $g_bRunState Then Return

	If $sType = "Troops" Then
		$iArrowX = $aGreenArrowTrainTroops[0]
		$iArrowY = $aGreenArrowTrainTroops[1]
	ElseIf $sType = "Spells" Then
		$iArrowX = $aGreenArrowBrewSpells[0]
		$iArrowY = $aGreenArrowBrewSpells[1]
	ElseIf $sType = "SiegeMachines" Then
		$iArrowX = $aGreenArrowTrainSiegeMachines[0]
		$iArrowY = $aGreenArrowTrainSiegeMachines[1]
	Else
		Return FuncReturn(Default, $g_bDebugSetLogTrain)
	EndIf

	If _CheckPixel($aReceivedTroopsTab, True) Then
		SetLog("Detected Clan Castle Message. Waiting until it's gone", $COLOR_INFO)
		_CaptureRegion2()
		Local $Safetyexit = 0
		While _CheckPixel($aReceivedTroopsTab, True)
			If _Sleep($DELAYTRAIN1) Then Return
			$Safetyexit = $Safetyexit + 1
			If $Safetyexit > 120 Then ExitLoop  ;If waiting longer than 2 min, something is wrong
		WEnd
	EndIf

	WaitForClanMessage("Tabs")

	If Not IsArray(_PixelSearch($iArrowX, $iArrowY, $iArrowX + 4, $iArrowY, Hex(0xAFDC87, 6), 30, True)) And _
			Not IsArray(_PixelSearch($iArrowX, $iArrowY + 3, $iArrowX + 4, $iArrowY + 3, Hex(0x79BF30, 6), 30, True)) And _
			Not IsArray(_PixelSearch($iArrowX - 2, $iArrowY + 3, $iArrowX + 2, $iArrowY + 3, Hex(0xA5D27B, 6), 30, True)) And _
			Not IsArray(_PixelSearch($iArrowX - 2, $iArrowY + 6, $iArrowX + 2, $iArrowY + 6, Hex(0x6FB424, 6), 30, True)) Then

		If $g_bDebugSetLogTrain Then SetLog($sType & " Queue empty", $COLOR_DEBUG)
		Return True     ; Check Green Arrows at top first, if not there -> Return

	ElseIf ((IsArray(_PixelSearch($iArrowX, $iArrowY, $iArrowX + 4, $iArrowY, Hex(0xAFDC87, 6), 30, True)) And _
			IsArray(_PixelSearch($iArrowX, $iArrowY + 3, $iArrowX + 4, $iArrowY + 3, Hex(0x79BF30, 6), 30, True))) Or _
			(IsArray(_PixelSearch($iArrowX - 2, $iArrowY + 3, $iArrowX + 2, $iArrowY + 3, Hex(0xA5D27B, 6), 30, True)) And _
			IsArray(_PixelSearch($iArrowX - 2, $iArrowY + 6, $iArrowX + 2, $iArrowY + 6, Hex(0x6FB424, 6), 30, True)))) And Not $removeExtraTroopsQueue Then

		If Not WaitforPixel($iArrowX - 9, $iArrowY - 1, $iArrowX - 5, $iArrowY + 1, Hex(0xAFDC87, 6), 30, 2) And _
				Not WaitforPixel($iArrowX - 11, $iArrowY + 2, $iArrowX - 7, $iArrowY + 4, Hex(0xA5D27B, 6), 30, 2) Then Return False ; check if boost arrow

	EndIf
	If _Sleep($DELAYRESPOND) Then Return

	If Not $bSkipTabCheck Or $removeExtraTroopsQueue Then
		If $sType = "Troops" Then
			If Not OpenTroopsTab(True, "IsQueueEmpty()") Then Return FuncReturn(Default, $g_bDebugSetLogTrain)
		ElseIf $sType = "Spells" Then
			If Not OpenSpellsTab(True, "IsQueueEmpty()") Then Return FuncReturn(Default, $g_bDebugSetLogTrain)
		Else
			If Not OpenSiegeMachinesTab(True, "IsQueueEmpty()") Then Return FuncReturn(Default, $g_bDebugSetLogTrain)
		EndIf
	EndIf

	If Not $g_bIsFullArmywithHeroesAndSpells Then
		If $removeExtraTroopsQueue Then
			If Not _ColorCheck(_GetPixelColor(263, 215 + $g_iMidOffsetY, True, $g_bDebugSetLogTrain ? $sType & " Not $g_bIsFullArmywithHeroesAndSpells:0x677CB5" : Default), Hex(0x677CB5, 6), 30) Then RemoveExtraTroopsQueue() ; Check for Blue band in empty queue
		EndIf
	EndIf

	If $removeExtraTroopsQueue Then ; If No troops were in Queue Return True
		If _ColorCheck(_GetPixelColor(263, 215 + $g_iMidOffsetY, True, $g_bDebugSetLogTrain ? $sType & " IsQueueEmpty_QueueEmpty:0x677CB5" : Default), Hex(0x677CB5, 6), 20) Then Return FuncReturn(True, $g_bDebugSetLogTrain) ; Check for Blue band in empty queue
	Else
		If _ColorCheck(_GetPixelColor(773, 195 + $g_iMidOffsetY, True, $g_bDebugSetLogTrain ? $sType & " IsQueueEmpty_QueueBoosted:0xD0D0C8" : Default), Hex(0xD0D0C8, 6), 20) Then Return FuncReturn(True, $g_bDebugSetLogTrain) ; check gray background at 1st training slot
	EndIf

	Return FuncReturn(False, $g_bDebugSetLogTrain)
EndFunc   ;==>IsQueueEmpty

Func ClickRemoveTroop($pos, $iTimes, $iSpeed)
	$pos[0] = Random($pos[0] - 5, $pos[0] + 5, 1)
	$pos[1] = Random($pos[1] - 5, $pos[1] + 5, 1)
	If Not $g_bRunState Then Return
	If _Sleep(400) Then Return
	If $iTimes <> 1 Then
		If FastCaptureRegion() Then
			For $i = 0 To ($iTimes - 1)
				PureClick($pos[0], $pos[1], 1, $iSpeed) ;Click once.
				If _Sleep($iSpeed, False) Then ExitLoop
			Next
		Else
			PureClick($pos[0], $pos[1], $iTimes, $iSpeed) ;Click $iTimes.
			If _Sleep($iSpeed, False) Then Return
		EndIf
	Else
		PureClick($pos[0], $pos[1], 1, $iSpeed)

		If _Sleep($iSpeed, False) Then Return
	EndIf
EndFunc   ;==>ClickRemoveTroop

Func GetSlotRemoveBtnPosition($iSlot, $bSpells = False)
	Local $iRemoveY = Not $bSpells ? (243 + $g_iMidOffsetY) : (352 + $g_iMidOffsetY)
	Local $iRemoveX = Number(428 + (62.5 * $iSlot))

	Local Const $aResult[2] = [$iRemoveX, $iRemoveY]
	Return $aResult
EndFunc   ;==>GetSlotRemoveBtnPosition

Func GetSlotNumber($bSpells = False)
	Select
		Case $bSpells = False
			Local Const $Orders = [$eBarb, $eSBarb, $eArch, $eSArch, $eGiant, $eSGiant, $eGobl, $eSGobl, $eWall, $eSWall, $eBall, $eRBall, $eWiza, $eSWiza, $eHeal, $eDrag, $eSDrag, _
					$eYeti, $eRDrag, $ePekk, $eBabyD, $eInfernoD, $eMine, $eSMine, $eEDrag, $eETitan, $eRootR, $eThrower, _
					$eMini, $eSMini, $eHogs, $eSHogs, $eValk, $eSValk, $eGole, $eWitc, $eSWitc, $eLava, $eIceH, $eBowl, $eSBowl, $eIceG, $eHunt, $eAppWard, $eDruid, $eFurn] ; Set Order of troop display in Army Tab

			Local $allCurTroops[UBound($Orders)]

			; Code for Elixir Troops to Put Current Troops into an array by Order
			For $i = 0 To $eTroopCount - 1
				If Not $g_bRunState Then Return
				If $g_aiCurrentTroops[$i] > 0 Then
					For $j = 0 To (UBound($Orders) - 1)
						If TroopIndexLookup($g_asTroopShortNames[$i], "GetSlotNumber#1") = $Orders[$j] Then
							$allCurTroops[$j] = $g_asTroopShortNames[$i]
						EndIf
					Next
				EndIf
			Next

			;_ArrayDisplay($allCurTroops, "$allCurTroops")

			_ArryRemoveBlanks($allCurTroops)

			Return $allCurTroops
		Case $bSpells = True

			; Set Order of Spells display in Army Tab
			Local Const $SpellsOrders = [$eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $eISpell, $eReSpell, $eRvSpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell, $eBtSpell, $eOgSpell]

			Local $allCurSpells[UBound($SpellsOrders)]

			; Code for Spells to Put Current Spells into an array by Order
			For $i = 0 To $eSpellCount - 1
				If Not $g_bRunState Then Return
				If $g_aiCurrentSpells[$i] > 0 Then
					For $j = 0 To (UBound($SpellsOrders) - 1)
						If TroopIndexLookup($g_asSpellShortNames[$i], "GetSlotNumber#2") = $SpellsOrders[$j] Then
							$allCurSpells[$j] = $g_asSpellShortNames[$i]
						EndIf
					Next
				EndIf
			Next

			_ArryRemoveBlanks($allCurSpells)

			Return $allCurSpells
	EndSelect
EndFunc   ;==>GetSlotNumber

Func WhatToTrain($ReturnExtraTroopsOnly = False, $bFullArmy = $g_bIsFullArmywithHeroesAndSpells)
	Local $ToReturn[1][2] = [["Arch", 0]] ; 2 element dynamic list [troop, quantity]

	If $bFullArmy And Not $ReturnExtraTroopsOnly Then
		If Not $g_bFullArmySpells Then getArmySpells(False, False, False, False) ; in case $g_bIsFullArmywithHeroesAndSpells but not $g_bFullArmySpells

		Local $bHaltAttack = $g_iCommandStop = 3 Or $g_iCommandStop = 0 Or ($g_abDonateOnly[$g_iCurAccount] And ProfileSwitchAccountEnabled())
		If Not $bHaltAttack Then
			SetDebugLog(" - Your Army is Full", $COLOR_INFO)
			; Elixir Troops
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
				If $g_aiArmyCompSpells[$BrewIndex] > 0 Then
					$ToReturn[UBound($ToReturn) - 1][0] = $g_asSpellShortNames[$BrewIndex]
					$ToReturn[UBound($ToReturn) - 1][1] = $g_aiArmyCompSpells[$BrewIndex] - ($g_bFullArmySpells ? 0 : $g_aiCurrentSpells[$BrewIndex])
					ReDim $ToReturn[UBound($ToReturn) + 1][2]
				EndIf
			Next
		Else
			If $g_iCommandStop = 3 Or $g_iCommandStop = 0 Then
				SetLog("You are in halt attack mode and your Army is prepared!", $COLOR_INFO)
			Else
				SetLog("Donate Only mode and your Army is prepared!", $COLOR_INFO)
			EndIf
			If Not $g_bFullArmySpells Then
				For $i = 0 To $eSpellCount - 1
					Local $BrewIndex = $g_aiBrewOrder[$i]
					If $g_aiArmyCompSpells[$BrewIndex] > 0 Then
						$ToReturn[UBound($ToReturn) - 1][0] = $g_asSpellShortNames[$BrewIndex]
						$ToReturn[UBound($ToReturn) - 1][1] = $g_aiArmyCompSpells[$BrewIndex] - $g_aiCurrentSpells[$BrewIndex]
						ReDim $ToReturn[UBound($ToReturn) + 1][2]
					EndIf
				Next
			EndIf
		EndIf
		Return $ToReturn
	EndIf

	; Get Current available troops
	getArmyTroops(False, False, False, False)
	getArmySpells(False, False, False, False)

	Switch $ReturnExtraTroopsOnly
		Case False
			; Check Elixir Troops needed quantity to Train
			For $ii = 0 To $eTroopCount - 1
				Local $troopIndex = $g_aiTrainOrder[$ii]
				If $g_aiArmyCompTroops[$troopIndex] > 0 Then
					$ToReturn[UBound($ToReturn) - 1][0] = $g_asTroopShortNames[$troopIndex]
					$ToReturn[UBound($ToReturn) - 1][1] = $g_aiArmyCompTroops[$troopIndex] - $g_aiCurrentTroops[$troopIndex]
					ReDim $ToReturn[UBound($ToReturn) + 1][2]
				EndIf
			Next

			; Check Spells needed quantity to Brew
			For $i = 0 To $eSpellCount - 1
				Local $BrewIndex = $g_aiBrewOrder[$i]
				If $g_aiArmyCompSpells[$BrewIndex] > 0 Then
					$ToReturn[UBound($ToReturn) - 1][0] = $g_asSpellShortNames[$BrewIndex]
					$ToReturn[UBound($ToReturn) - 1][1] = $g_aiArmyCompSpells[$BrewIndex] - $g_aiCurrentSpells[$BrewIndex]
					ReDim $ToReturn[UBound($ToReturn) + 1][2]
				EndIf
			Next
		Case Else
			; Check Elixir Troops Extra Quantity
			For $ii = 0 To $eTroopCount - 1
				Local $troopIndex = $g_aiTrainOrder[$ii]
				If $g_aiCurrentTroops[$troopIndex] > 0 Then
					If $g_aiArmyCompTroops[$troopIndex] - $g_aiCurrentTroops[$troopIndex] < 0 Then
						$ToReturn[UBound($ToReturn) - 1][0] = $g_asTroopShortNames[$troopIndex]
						$ToReturn[UBound($ToReturn) - 1][1] = Abs($g_aiArmyCompTroops[$troopIndex] - $g_aiCurrentTroops[$troopIndex])
						ReDim $ToReturn[UBound($ToReturn) + 1][2]
					EndIf
				EndIf
			Next

			; Check Spells Extra Quantity
			For $i = 0 To $eSpellCount - 1
				Local $BrewIndex = $g_aiBrewOrder[$i]
				If $g_aiCurrentSpells[$BrewIndex] > 0 Then
					If $g_aiArmyCompSpells[$BrewIndex] - $g_aiCurrentSpells[$BrewIndex] < 0 Then
						$ToReturn[UBound($ToReturn) - 1][0] = $g_asSpellShortNames[$BrewIndex]
						$ToReturn[UBound($ToReturn) - 1][1] = Abs($g_aiArmyCompSpells[$BrewIndex] - $g_aiCurrentSpells[$BrewIndex])
						ReDim $ToReturn[UBound($ToReturn) + 1][2]
					EndIf
				EndIf
			Next
	EndSwitch
	DeleteInvalidTroopInArray($ToReturn)
	Return $ToReturn
EndFunc   ;==>WhatToTrain

Func CheckQueueTroops($bGetQuantity = True, $bSetLog = True, $x = 778, $bQtyWSlot = False)
	Local $aResult[1] = [""]
	If $bSetLog Then SetLog("Checking Troops Queue", $COLOR_INFO)

	Local $Dir = @ScriptDir & "\imgxml\ArmyOverview\TroopsQueued"

	Local $aSearchResult = SearchArmy($Dir, 73, 188 + $g_iMidOffsetY, $x, 243 + $g_iMidOffsetY, $bGetQuantity ? "Queue" : "")

	ReDim $aResult[UBound($aSearchResult)]

	If $aSearchResult[0][0] = "" Then
		SetLog("No Troops detected!", $COLOR_ERROR)
		Return
	EndIf

	For $i = 0 To (UBound($aSearchResult) - 1)
		If Not $g_bRunState Then Return
		$aResult[$i] = $aSearchResult[$i][0]
	Next

	If $bGetQuantity Then
		Local $aQuantities[UBound($aResult)][2]
		Local $aQueueTroop[$eTroopCount]
		For $i = 0 To (UBound($aQuantities) - 1)
			$aQuantities[$i][0] = $aSearchResult[$i][0]
			$aQuantities[$i][1] = $aSearchResult[$i][3]
			Local $iTroopIndex = TroopIndexLookup($aQuantities[$i][0])
			If $iTroopIndex >= 0 And $iTroopIndex < $eTroopCount Then
				If $bSetLog Then SetLog("  - " & $g_asTroopNames[TroopIndexLookup($aQuantities[$i][0], "CheckQueueTroops")] & ": " & $aQuantities[$i][1] & "x", $COLOR_SUCCESS)
				$aQueueTroop[$iTroopIndex] += $aQuantities[$i][1]
			Else
				; TODO check what to do with others
				SetDebugLog("Unsupport troop index: " & $iTroopIndex)
			EndIf
		Next
		If $bQtyWSlot Then Return $aQuantities
		Return $aQueueTroop
	EndIf

	_ArrayReverse($aResult)
	Return $aResult
EndFunc   ;==>CheckQueueTroops

Func CheckQueueSpells($bGetQuantity = True, $bSetLog = True, $x = 778, $bQtyWSlot = False)
	Local $avResult[$eSpellCount]
	Local $sImageDir = @ScriptDir & "\imgxml\ArmyOverview\SpellsQueued"

	If $bSetLog Then SetLog("Checking Spells Queue", $COLOR_INFO)
	Local $avSearchResult = SearchArmy($sImageDir, 73, 188 + $g_iMidOffsetY, $x, 243 + $g_iMidOffsetY, $bGetQuantity ? "Queue" : "")

	If $avSearchResult[0][0] = "" Then
		SetLog("No Spells detected!", $COLOR_ERROR)
		Return
	EndIf

	For $i = 0 To (UBound($avSearchResult) - 1)
		If Not $g_bRunState Then Return
		$avResult[$i] = $avSearchResult[$i][0]
	Next

	;Trim length to number of returned values
	ReDim $avResult[UBound($avSearchResult)][1]

	If $bGetQuantity Then
		Local $aiQuantities[UBound($avResult)][2]
		Local $aQueueSpell[$eSpellCount]
		For $i = 0 To (UBound($aiQuantities) - 1)
			If Not $g_bRunState Then Return
			$aiQuantities[$i][0] = $avSearchResult[$i][0]
			$aiQuantities[$i][1] = $avSearchResult[$i][3]
			If $bSetLog Then SetLog("  - " & $g_asSpellNames[TroopIndexLookup($aiQuantities[$i][0], "CheckQueueSpells") - $eLSpell] & ": " & $aiQuantities[$i][1] & "x", $COLOR_SUCCESS)
			$aQueueSpell[TroopIndexLookup($aiQuantities[$i][0]) - $eLSpell] += $aiQuantities[$i][1]
		Next
		If $bQtyWSlot Then Return $aiQuantities
		Return $aQueueSpell
	EndIf

	_ArrayReverse($avResult)
	Return $avResult
EndFunc   ;==>CheckQueueSpells

Func SearchArmy($sImageDir = "", $x = 0, $y = 0, $x1 = 0, $y1 = 0, $sArmyType = "", $bSkipReceivedTroopsCheck = False)
	; Setup arrays, including default return values for $return
	Local $aResult[1][4], $aCoordArray[1][2], $aCoords, $aCoordsSplit, $aValue

	For $iCount = 0 To 10  ;Why is this loop here?
		If Not $g_bRunState Then Return $aResult
		If Not getReceivedTroops(162, 170 + $g_iMidOffsetY, $bSkipReceivedTroopsCheck) Then
			; Perform the search
			_CaptureRegion2($x, $y, $x1, $y1)
			Local $res = DllCallMyBot("SearchMultipleTilesBetweenLevels", "handle", $g_hHBitmap2, "str", $sImageDir, "str", "FV", "Int", 0, "str", "FV", "Int", 0, "Int", 1000)

			If $res[0] <> "" Then
				; Get the keys for the dictionary item.
				Local $aKeys = StringSplit($res[0], "|", $STR_NOCOUNT)

				; Redimension the result array to allow for the new entries
				ReDim $aResult[UBound($aKeys)][4]
				Local $iResultAddDup = 0

				; Loop through the array
				For $i = 0 To UBound($aKeys) - 1
					; Get the property values
					$aResult[$i + $iResultAddDup][0] = RetrieveImglocProperty($aKeys[$i], "objectname")
					; Get the coords property
					$aValue = RetrieveImglocProperty($aKeys[$i], "objectpoints")
					$aCoords = decodeMultipleCoords($aValue, 50) ; dedup coords by x on 50 pixel
					$aCoordsSplit = $aCoords[0]
					If UBound($aCoordsSplit) = 2 Then
						; Store the coords into a two dimensional array
						$aCoordArray[0][0] = $aCoordsSplit[0] + $x ; X coord.
						$aCoordArray[0][1] = $aCoordsSplit[1] + $y ; Y coord.
					Else
						$aCoordArray[0][0] = -1
						$aCoordArray[0][1] = -1
					EndIf
					; Store the coords array as a sub-array
					$aResult[$i + $iResultAddDup][1] = Number($aCoordArray[0][0])
					$aResult[$i + $iResultAddDup][2] = Number($aCoordArray[0][1])
					SetDebugLog($aResult[$i + $iResultAddDup][0] & " | $aCoordArray: " & $aCoordArray[0][0] & "-" & $aCoordArray[0][1])
					; If 1 troop type appears at more than 1 slot
					Local $iMultipleCoords = UBound($aCoords)
					If $iMultipleCoords > 1 Then
						SetDebugLog($aResult[$i + $iResultAddDup][0] & " detected " & $iMultipleCoords & " times!")
						For $j = 1 To $iMultipleCoords - 1
							Local $aCoordsSplit2 = $aCoords[$j]
							If UBound($aCoordsSplit2) = 2 Then
								; add slot
								$iResultAddDup += 1
								ReDim $aResult[UBound($aKeys) + $iResultAddDup][4]
								$aResult[$i + $iResultAddDup][0] = $aResult[$i + $iResultAddDup - 1][0] ; same objectname
								$aResult[$i + $iResultAddDup][1] = $aCoordsSplit2[0] + $x
								$aResult[$i + $iResultAddDup][2] = $aCoordsSplit2[1] + $y
								SetDebugLog($aResult[$i + $iResultAddDup][0] & " | $aCoordArray: " & $aResult[$i + $iResultAddDup][1] & "-" & $aResult[$i + $iResultAddDup][2])
							EndIf
						Next
					EndIf
				Next
				ExitLoop
			EndIf
			ExitLoop
		Else
			If $iCount = 1 Then SetLog("You have received castle troops! Wait 5's...")
			If _Sleep($DELAYTRAIN8) Then Return $aResult
		EndIf
	Next

	_ArraySort($aResult, 0, 0, 0, 1) ; Sort By X position , will be the Slot 0 to $i

	While 1
		If UBound($aResult) < 2 Then ExitLoop
		For $i = 1 To UBound($aResult) - 1
			If $aResult[$i][0] = $aResult[$i - 1][0] And Abs($aResult[$i][1] - $aResult[$i - 1][1]) <= 50 Then
				SetDebugLog("Double detection " & $aResult[$i][0] & " at " & $i - 1 & ": " & $aResult[$i][1] & " & " & $aResult[$i - 1][1])
				_ArrayDelete($aResult, $i)
				ContinueLoop 2
			EndIf
		Next
		ExitLoop
	WEnd

	If $sArmyType = "Troops" Then
		For $i = 0 To UBound($aResult) - 1
			$aResult[$i][3] = Number(getBarracksNewTroopQuantity(Slot($aResult[$i][1], "troop"), 174 + $g_iMidOffsetY)) ; coc-newarmy
		Next
	EndIf
	If $sArmyType = "Spells" Then
		For $i = 0 To UBound($aResult) - 1
			$aResult[$i][3] = Number(getBarracksNewTroopQuantity(Slot($aResult[$i][1], "spells"), 314 + $g_iMidOffsetY)) ; coc-newarmy
		Next
	EndIf
	If $sArmyType = "CCSpells" Then
		For $i = 0 To UBound($aResult) - 1
			$aResult[$i][3] = Number(getBarracksNewTroopQuantity(Slot($aResult[$i][1], "troop"), 466 + $g_iMidOffsetY)) ; coc-newarmy
		Next
	EndIf
	If $sArmyType = "Heroes" Then
		For $i = 0 To UBound($aResult) - 1
			If StringInStr($aResult[$i][0], "Kingqueued") Then
				$aResult[$i][3] = getRemainTHero(530, 380 + $g_iMidOffsetY)
			ElseIf StringInStr($aResult[$i][0], "Queenqueued") Then
				$aResult[$i][3] = getRemainTHero(595, 380 + $g_iMidOffsetY)
			ElseIf StringInStr($aResult[$i][0], "Wardenqueued") Then
				$aResult[$i][3] = getRemainTHero(657, 380 + $g_iMidOffsetY)
			ElseIf StringInStr($aResult[$i][0], "Championqueued") Then
				$aResult[$i][3] = getRemainTHero(721, 380 + $g_iMidOffsetY)
			Else
				$aResult[$i][3] = 0
			EndIf
		Next
	EndIf

	If $sArmyType = "Queue" Then
		_ArraySort($aResult, 1, 0, 0, 1) ; reverse the queued slots from right to left
		Local $xSlot
		For $i = 0 To UBound($aResult) - 1
			$xSlot = Int(Number($aResult[$i][1]) / 60.5) * 60.5 - 6
			$aResult[$i][3] = Number(getQueueTroopsQuantity($xSlot, 189 + $g_iMidOffsetY))
			SetDebugLog($aResult[$i][0] & " (" & $xSlot & ") x" & $aResult[$i][3])
		Next
	EndIf

	If $sArmyType = "Quick Train" Then
		Local $xSlot
		For $i = 0 To UBound($aResult) - 1
			$xSlot = Int((Number($aResult[$i][1]) - 25) / 60.5)
			$aResult[$i][3] = Number(getQueueTroopsQuantity(25 + $xSlot * 60.5, 189 + $g_iMidOffsetY))
			SetDebugLog($aResult[$i][0] & " (" & $xSlot & ") x" & $aResult[$i][3])
		Next
	EndIf

	Return $aResult
EndFunc   ;==>SearchArmy

Func ResetVariables($sArmyType = "")

	If $sArmyType = "troops" Or $sArmyType = "all" Then
		For $i = 0 To $eTroopCount - 1
			If Not $g_bRunState Then Return
			$g_aiCurrentTroops[$i] = 0
			If _Sleep($DELAYTRAIN6) Then Return ; '20' just to Pause action
		Next
	EndIf
	If $sArmyType = "Spells" Or $sArmyType = "all" Then
		For $i = 0 To $eSpellCount - 1
			If Not $g_bRunState Then Return
			$g_aiCurrentSpells[$i] = 0
			If _Sleep($DELAYTRAIN6) Then Return ; '20' just to Pause action
		Next
	EndIf
	If $sArmyType = "SiegeMachines" Or $sArmyType = "all" Then
		For $i = 0 To $eSiegeMachineCount - 1
			If Not $g_bRunState Then Return
			$g_aiCurrentSiegeMachines[$i] = 0
			If _Sleep($DELAYTRAIN6) Then Return ; '20' just to Pause action
		Next
	EndIf
	If $sArmyType = "donated" Or $sArmyType = "all" Then
		For $i = 0 To $eTroopCount - 1
			If Not $g_bRunState Then Return
			$g_aiDonateTroops[$i] = 0
			If _Sleep($DELAYTRAIN6) Then Return ; '20' just to Pause action
		Next
		For $i = 0 To $eSpellCount - 1 ; fixed making wrong donated spells
			If Not $g_bRunState Then Return
			$g_aiDonateSpells[$i] = 0
			If _Sleep($DELAYTRAIN6) Then Return
		Next
		For $i = 0 To $eSiegeMachineCount - 1
			If Not $g_bRunState Then Return
			$g_aiDonateSiegeMachines[$i] = 0
			If _Sleep($DELAYTRAIN6) Then Return
		Next
	EndIf

EndFunc   ;==>ResetVariables

Func TrainArmyNumber($abQuickTrainArmy)
	Local $iDistanceBetweenArmies = 93
	Local $aiTrainButton, $aiSearchArea[4] = [680, 263 + $g_iMidOffsetY, 780, 356 + $g_iMidOffsetY]

	For $iArmyNumber = 0 To 2
		If $abQuickTrainArmy[$iArmyNumber] Then
			$aiTrainButton = decodeSingleCoord(findImage("QuickTrainButton", $g_sImgQuickTrain, GetDiamondFromArray($aiSearchArea), 1, True))
			If UBound($aiTrainButton, 1) = 2 Then
				ClickP($aiTrainButton)
				SetLog(" - Making the Army " & $iArmyNumber + 1, $COLOR_INFO)
				If _Sleep(1500) Then Return
				Local $aiOkayButton = findButton("Okay", Default, 1, True)
				If IsArray($aiOkayButton) And UBound($aiOkayButton, 1) = 2 Then
					SetLog("Confirm partial army training", $COLOR_INFO)
					PureClick($aiOkayButton[0], $aiOkayButton[1], 2, 50, "#0117") ; Click Okay Button
					If _Sleep(500) Then Return
				EndIf
			Else
				SetLog(" - Army: " & $iArmyNumber + 1 & " is already trained.")
			EndIf
		EndIf
		$aiSearchArea[1] = ($aiSearchArea[1] + $iDistanceBetweenArmies)
		$aiSearchArea[3] = ($aiSearchArea[3] + $iDistanceBetweenArmies)
	Next

EndFunc   ;==>TrainArmyNumber

Func DeleteQueued($sArmyTypeQueued, $iOffsetQueued = 742)

	If $sArmyTypeQueued = "Troops" Then
		If Not OpenTroopsTab(True, "DeleteQueued()") Then Return
	ElseIf $sArmyTypeQueued = "Spells" Then
		If Not OpenSpellsTab(True, "DeleteQueued()") Then Return
	ElseIf $sArmyTypeQueued = "SiegeMachines" Then
		If Not OpenSiegeMachinesTab(True, "DeletQueued()") Then Return
	Else
		Return
	EndIf
	If _Sleep(500) Then Return
	Local $x = 0

	While Not _ColorCheck(_GetPixelColor(773, 195 + $g_iMidOffsetY, True), Hex(0xCFCFC8, 6), 20) ; check gray background at 1st training slot
		If $x = 0 Then SetLog(" - Delete " & $sArmyTypeQueued & " Queued!", $COLOR_INFO)
		If Not $g_bRunState Then Return
		Click($iOffsetQueued + 24, 198 + $g_iMidOffsetY, 10, 50)
		$x += 1
		If $x = 270 Then ExitLoop
	WEnd
EndFunc   ;==>DeleteQueued

Func MakingDonatedTroops($sType = "All")
	Local $avDefaultTroopGroup[$eTroopCount][5]
	For $i = 0 To $eTroopCount - 1
		$avDefaultTroopGroup[$i][0] = $g_asTroopShortNames[$i]
		$avDefaultTroopGroup[$i][1] = $i
		$avDefaultTroopGroup[$i][2] = $g_aiTroopSpace[$i]
		$avDefaultTroopGroup[$i][3] = $g_aiTroopTrainTime[$i]
		$avDefaultTroopGroup[$i][4] = 0
	Next

	; notes $avDefaultTroopGroup[$i][5]
	; notes $avDefaultTroopGroup[$i][0] = TroopName | [1] = TroopNamePosition | [2] = TroopHeight | [3] = Times | [4] = qty]
	; notes We'll use now DragIfNeeded($avDefaultTroopGroup[$i][0]) ; Click drag if needed for Troops Type
	; notes $RemainTrainSpace[0] = Current Army  | [1] = Total Army Capacity  | [2] = Remain Space for the current Army

	Local $RemainTrainSpace
	Local $Plural = 0
	Local $areThereDonTroop = 0
	Local $areThereDonSpell = 0

	For $j = 0 To $eTroopCount - 1
		If $sType <> "Troops" And $sType <> "All" Then ExitLoop
		If Not $g_bRunState Then Return
		$areThereDonTroop += $g_aiDonateTroops[$j]
	Next

	For $j = 0 To $eSpellCount - 1
		If $sType <> "Spells" And $sType <> "All" Then ExitLoop
		If Not $g_bRunState Then Return
		$areThereDonSpell += $g_aiDonateSpells[$j]
	Next
	If $areThereDonSpell = 0 And $areThereDonTroop = 0 Then Return

	If $areThereDonTroop > 0 Then
		Local $howMany = 0
		; Load $g_aiDonateTroops[$i] Values into $avDefaultTroopGroup[$i][4]
		For $i = 0 To UBound($avDefaultTroopGroup) - 1
			For $j = 0 To $eTroopCount - 1
				If $g_asTroopShortNames[$j] = $avDefaultTroopGroup[$i][0] Then
					$avDefaultTroopGroup[$i][4] = $g_aiDonateTroops[$j]
					If $g_aiDonateTroops[$j] > 0 Then $howMany += $g_aiDonateTroops[$j]
					$g_aiDonateTroops[$j] = 0
				EndIf
			Next
		Next

		SetLog("  making donated troop" & ($howMany > 1 ? "s" : ""), $COLOR_ACTION1)

		If Not OpenTroopsTab(True, "MakingDonatedTroops()") Then Return

		WaitForClanMessage("TrainTabs")

		For $i = 0 To UBound($avDefaultTroopGroup, 1) - 1
			Local $bCheckPixel = False
			If Not $g_bRunState Then Return
			$Plural = 0
			If $avDefaultTroopGroup[$i][4] > 0 Then
				WaitForClanMessage("DonatedTroops")
				$RemainTrainSpace = GetOCRCurrent(95, 162 + $g_iMidOffsetY)
				If $RemainTrainSpace[2] < 0 Then $RemainTrainSpace[2] = $RemainTrainSpace[1] * 2 - $RemainTrainSpace[0] ; remain train space to full double army
				If $RemainTrainSpace[2] = 0 Then ExitLoop ; army camps full

				Local $iTroopIndex = TroopIndexLookup($avDefaultTroopGroup[$i][0], "MakingDonatedTroops")

				If $avDefaultTroopGroup[$i][2] * $avDefaultTroopGroup[$i][4] <= $RemainTrainSpace[2] Then ; Troopheight x donate troop qty <= avaible train space
					DragIfNeeded($avDefaultTroopGroup[$i][0])
					TrainIt($iTroopIndex, $avDefaultTroopGroup[$i][4], $g_iTrainClickDelay)
					If _Sleep($DELAYRESPOND) Then Return ; add 5ms delay to catch TrainIt errors, and force return to back to main loop
					Local $sTroopName = ($avDefaultTroopGroup[$i][4] > 1 ? $g_asTroopNamesPlural[$iTroopIndex] : $g_asTroopNames[$iTroopIndex])
					SetLog(" - Trained " & $avDefaultTroopGroup[$i][4] & " " & $sTroopName, $COLOR_ACTION)
					$avDefaultTroopGroup[$i][4] = 0
					If _Sleep(1000) Then Return ; Needed Delay, OCR was not picking up Troop Changes
				Else
					For $z = 0 To $RemainTrainSpace[2] - 1
						WaitForClanMessage("DonatedTroops")
						$RemainTrainSpace = GetOCRCurrent(95, 162 + $g_iMidOffsetY)
						If $RemainTrainSpace[0] = $RemainTrainSpace[1] Then ; army camps full
							;Camps Full All Donate Counters should be zero!!!!
							For $j = 0 To UBound($avDefaultTroopGroup, 1) - 1
								$avDefaultTroopGroup[$j][4] = 0
							Next
							ExitLoop 2
						EndIf
						If $avDefaultTroopGroup[$i][2] <= $RemainTrainSpace[2] And $avDefaultTroopGroup[$i][4] > 0 Then
							Local $AsExpected = IsInt(Number($RemainTrainSpace[2] / $avDefaultTroopGroup[$i][2]))
							Local $howMuch = Floor(Number($RemainTrainSpace[2] / $avDefaultTroopGroup[$i][2]))
							DragIfNeeded($avDefaultTroopGroup[$i][0])
							TrainIt($iTroopIndex, $howMuch, $g_iTrainClickDelay)
							If _Sleep($DELAYRESPOND) Then Return ; add 5ms delay to catch TrainIt errors, and force return to back to main loop
							Local $sTroopName = ($howMuch > 1 ? $g_asTroopNamesPlural[$iTroopIndex] : $g_asTroopNames[$iTroopIndex])
							If $AsExpected Then
								SetLog(" - Trained " & $howMuch & " " & $sTroopName, $COLOR_ACTION)
							Else
								Local $WasExpected = Ceiling(Number($RemainTrainSpace[2] / $avDefaultTroopGroup[$i][2]))
								SetLog(" - Trained Only " & $howMuch & " " & $sTroopName, $COLOR_ACTION)
								SetLog($WasExpected & " " & $sTroopName & " were expected", $COLOR_ACTION)
							EndIf
							$avDefaultTroopGroup[$i][4] -= $howMuch
							If _Sleep(1000) Then Return ; Needed Delay, OCR was not picking up Troop Changes
						Else
							ExitLoop
						EndIf
					Next
				EndIf
			EndIf
		Next
		;Top Off any remianing space with archers
		If $sType = "All" Then
			WaitForClanMessage("DonatedTroops")
			$RemainTrainSpace = GetOCRCurrent(95, 162 + $g_iMidOffsetY)
			If $RemainTrainSpace[0] < $RemainTrainSpace[1] Then ; army camps full
				Local $howMuch = $RemainTrainSpace[2]
				TrainIt($eTroopArcher, $howMuch, $g_iTrainClickDelay)
				If $RemainTrainSpace[2] > 0 Then $Plural = 1
				SetLog(" - Trained " & $howMuch & " archer(s)!", $COLOR_ACTION)
				If _Sleep(1000) Then Return ; Needed Delay, OCR was not picking up Troop Changes
			EndIf
		EndIf
	EndIf

	If $areThereDonSpell > 0 Then
		Local $howMany = 0
		For $i = 0 To $eSpellCount - 1
			If $g_aiDonateSpells[$i] > 0 Then $howMany += $g_aiDonateSpells[$i]
		Next
		SetLog("  making donated spell" & ($howMany > 1 ? "s" : ""), $COLOR_ACTION1)
		;Train Donated Spells
		If Not OpenSpellsTab(True, "MakingDonatedTroops()") Then Return

		WaitForClanMessage("TrainTabs")

		For $i = 0 To $eSpellCount - 1
			If Not $g_bRunState Then Return
			WaitForClanMessage("DonatedTroops")
			$RemainTrainSpace = GetOCRCurrent(95, 162 + $g_iMidOffsetY)
			If $g_aiDonateSpells[$i] > 0 And $RemainTrainSpace[0] < $RemainTrainSpace[1] Then
				Local $pos = GetTrainPos($i + $eLSpell)
				Local $howMuch = $g_aiDonateSpells[$i]
				TrainIt($eLSpell + $i, $howMuch, $g_iTrainClickDelay)
				If _Sleep($DELAYRESPOND) Then Return ; add 5ms delay to catch TrainIt errors, and force return to back to main loop
				SetLog(" - Brewed " & $howMuch & " " & $g_asSpellNames[$i] & ($howMuch > 1 ? " Spells" : " Spell"), $COLOR_ACTION)
				$g_aiDonateSpells[$i] -= $howMuch
				If _Sleep(1000) Then Return
			EndIf
		Next
	EndIf

	Return True

EndFunc   ;==>MakingDonatedTroops

Func GetOCRCurrent($x_start, $y_start, $Type = "troops")

	Local $aResult[3] = [0, 0, 0]
	If Not $g_bRunState Then Return $aResult

	; [0] = Current Army  | [1] = Total Army Capacity  | [2] = Remain Space for the current Army
	Switch $Type
		Case "troops"
			Local $iOCRResult = getArmyCampCap($x_start, $y_start)
		Case "spells"
			Local $iOCRResult = getSpellsCap($x_start, $y_start)
		Case Else
			Local $iOCRResult = getArmyCapacityOnTrainTroops($x_start, $y_start)
	EndSwitch

	If StringInStr($iOCRResult, "#") Then
		Local $aTempResult = StringSplit($iOCRResult, "#", $STR_NOCOUNT)
		$aResult[0] = Number($aTempResult[0])
		$aResult[1] = Number($aTempResult[1])
		$aResult[2] = $aResult[1] - $aResult[0]
	Else
		SetLog("DEBUG | ERROR on GetOCRCurrent", $COLOR_ERROR)
	EndIf

	Return $aResult

EndFunc   ;==>GetOCRCurrent

Func getReceivedTroops($x_start, $y_start, $bSkipCheck = False) ; Check if 'you received Castle Troops from' , will proceed with a Sleep until the message disappear
	If $bSkipCheck Or Not $g_bRunState Then Return False
	Local $iOCRResult = ""

	$iOCRResult = getOcrAndCapture("coc-DonTroops", $x_start, $y_start, 120, 27, True) ; X = 162  Y = 200

	If IsString($iOCRResult) <> "" Or IsString($iOCRResult) <> " " Then
		If StringInStr($iOCRResult, "you") Then ; If exist Minutes or only Seconds
			Return True
		Else
			Return False
		EndIf
	Else
		Return False
	EndIf

EndFunc   ;==>getReceivedTroops

Func _ArryRemoveBlanks(ByRef $aArray)
	Local $iCounter = 0
	For $i = 0 To UBound($aArray) - 1
		If $aArray[$i] <> "" Then
			$aArray[$iCounter] = $aArray[$i]
			$iCounter += 1
		EndIf
	Next
	ReDim $aArray[$iCounter]
EndFunc   ;==>_ArryRemoveBlanks

Func ValidateSearchArmyResult($aSearchResult, $iIndex = 0)
	If IsArray($aSearchResult) Then
		If UBound($aSearchResult) > 0 Then
			If StringLen($aSearchResult[$iIndex][0]) > 0 Then Return True
		EndIf
	EndIf
	Return False
EndFunc   ;==>ValidateSearchArmyResult

