; #FUNCTION# ====================================================================================================================
; Name ..........: Train Siege 2018
; Description ...:
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: ProMac(07-2018)
; Modified ......: Moebius14(03-2025)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func TrainSiege()

	Local $bContinueinFunc = False
	For $i = 0 To $eSiegeMachineCount - 1
		If $g_aiArmyCompSiegeMachines[$i] > 0 Then
			$bContinueinFunc = True
			ExitLoop
		EndIf
	Next

	If Not $bContinueinFunc Then Return

	Local $rWhatToTrain = WhichSiegeToTrain(True)     ; r in First means Result! Result of What To Train Function
	Local $Isremoved = True
	If RemoveExtraSieges($rWhatToTrain) = 3 Then $Isremoved = False

	If _Sleep($DELAYRESPOND) Then Return ; add 5ms delay to catch TrainIt errors, and force return to back to main loop

	If Not $g_bRunState Then Return

	If $Isremoved Or Not $g_bFullArmy Then
		Local $rWhatToTrain = WhichSiegeToTrain()
		If DoWhatToTrainContainSiege($rWhatToTrain) Then TrainSiegeUsingWhatToTrain($rWhatToTrain)
		CheckIfArmyIsReady()
	EndIf

	If _Sleep(250) Then Return
	If Not $g_bRunState Then Return

EndFunc   ;==>TrainSiege

Func DoWhatToTrainContainSiege($rWTT)
	If UBound($rWTT) = 1 And $rWTT[0][0] = "WallW" And $rWTT[0][1] = 0 Then Return False ; If was default Result of WhichSiegeToTrain
	For $i = 0 To (UBound($rWTT) - 1)
		If IsSiegeToTrain($rWTT[$i][0]) And $rWTT[$i][1] > 0 Then Return True
	Next
	Return False
EndFunc   ;==>DoWhatToTrainContainSiege

Func IsSiegeToTrain($sName)
	Local $iIndex = TroopIndexLookup($sName, "IsSiegeToTrain")
	If $iIndex >= $eWallW And $iIndex <= $eTroopL Then Return True
	Return False
EndFunc   ;==>IsSiegeToTrain

Func TrainSiegeUsingWhatToTrain($rWTT)
	If Not $g_bRunState Then Return

	If UBound($rWTT) = 1 And $rWTT[0][0] = "WallW" And $rWTT[0][1] = 0 Then Return True ; If was default Result of WhatToTrain

	Local $aLeftSpace = GetOCRCurrent(672, 320 + $g_iMidOffsetY, "sieges")
	Local $LeftSpace = $aLeftSpace[1] - $aLeftSpace[0]
	Local $iPage = 0

	; Loop through needed troops to Train
	For $i = 0 To (UBound($rWTT) - 1)
		If Not $g_bRunState Then Return
		If $rWTT[$i][1] > 0 Then ; If Count to Train Was Higher Than ZERO

			If Not IsTrainPageGrayed(False, 1) Then
				If Not OpenSiegeMachinesTab(True, "TrainSiegeUsingWhatToTrain()") Then Return
			EndIf

			Local $iSiegeIndex = TroopIndexLookup($rWTT[$i][0], "TrainSiegeUsingWhatToTrain()")
			Local $NeededSpace = $g_aiSiegeMachineSpace[$iSiegeIndex - $eWallW] * $rWTT[$i][1]

			If $NeededSpace > $LeftSpace Then $rWTT[$i][1] = Int($LeftSpace / $g_aiSiegeMachineSpace[$iSiegeIndex - $eWallW])

			If $rWTT[$i][1] > 0 Then
				Local $sSiegeName = $g_asSiegeMachineNames[$iSiegeIndex - $eWallW]
				If $iSiegeIndex - $eWallW = 3 Then
					SetLog("Training " & $rWTT[$i][1] & "x " & $sSiegeName, $COLOR_SUCCESS)
				Else
					SetLog("Training " & $rWTT[$i][1] & "x " & $sSiegeName & ($rWTT[$i][1] > 1 ? "s" : ""), $COLOR_SUCCESS)
				EndIf

				DragSiegeIfNeeded($iSiegeIndex - $eWallW, $iPage)

				TrainIt($iSiegeIndex, $rWTT[$i][1], $g_iTrainClickDelay)
				$LeftSpace -= $rWTT[$i][1] * $g_aiSiegeMachineSpace[$iSiegeIndex - $eWallW]
			EndIf
		EndIf
		If _Sleep($DELAYRESPOND) Then Return ; add 5ms delay to catch TrainIt errors, and force return to back to main loop
	Next

	If IsTrainPageGrayed(False, 3) Then
		Click(Random(240, 360, 1), Random(190 + $g_iMidOffsetY, 210 + $g_iMidOffsetY, 1), 1, 120)
		If _Sleep(250) Then Return
	EndIf

	Return True
EndFunc   ;==>TrainSiegeUsingWhatToTrain

Func WhichSiegeToTrain($bRemoveExtra = False)
	Local $ToReturn[1][2] = [["WallW", 0]] ; 2 element dynamic list [Siege, quantity]
	If Not $bRemoveExtra Then
		For $i = 0 To $eSiegeMachineCount - 1
			If $g_aiArmyCompSiegeMachines[$i] > 0 Then
				$ToReturn[UBound($ToReturn) - 1][0] = $g_asSiegeMachineShortNames[$i]
				$ToReturn[UBound($ToReturn) - 1][1] = $g_aiArmyCompSiegeMachines[$i]
				ReDim $ToReturn[UBound($ToReturn) + 1][2]
			EndIf
		Next
	Else
		For $i = 0 To $eSiegeMachineCount - 1
			If $g_aiCurrentSiegeMachines[$i] > 0 Then
				If $g_aiArmyCompSiegeMachines[$i] - $g_aiCurrentSiegeMachines[$i] < 0 Then
					$ToReturn[UBound($ToReturn) - 1][0] = $g_asSiegeMachineShortNames[$i]
					$ToReturn[UBound($ToReturn) - 1][1] = Abs($g_aiArmyCompSiegeMachines[$i] - $g_aiCurrentSiegeMachines[$i])
					ReDim $ToReturn[UBound($ToReturn) + 1][2]
				EndIf
			EndIf
		Next
	EndIf
	Return $ToReturn
EndFunc   ;==>WhichSiegeToTrain

Func RemoveExtraSieges($toRemove)
	Local $iResult = 0
	; Army Window should be open and should be in Tab 'Army tab'

	; 1 Means Removed Sieges without Deleting Sieges Queued
	; 2 Means Removed Sieges And Also Deleted Sieges Queued
	; 3 Means Didn't removed troop... Everything was well

	If UBound($toRemove) = 1 And $toRemove[0][0] = "WallW" And $toRemove[0][1] = 0 Then Return 3

	If ($g_iCommandStop = 3 Or $g_iCommandStop = 0) And Not $g_iActiveDonate Then Return 3

	If UBound($toRemove) > 0 Then ; If needed to remove Sieges

		; Loop through Sieges needed to get removed Just to write some Logs
		For $i = 0 To (UBound($toRemove) - 1)
			SetLog("Sieges Remove.", $COLOR_INFO)
			Click(793, 326 + $g_iMidOffsetY)
			If _Sleep(250) Then Return
			Local $aiOkayButton = findButton("Okay", Default, 1, True)
			If IsArray($aiOkayButton) And UBound($aiOkayButton, 1) = 2 Then
				Click($aiOkayButton[0], $aiOkayButton[1])     ; Click Okay Button
				If _Sleep(200) Then Return
				ExitLoop
			EndIf
		Next

		If _Sleep(200) Then Return

		If Not $g_bRunState Then Return

		SetLog("All Extra Sieges removed", $COLOR_SUCCESS)
		If _Sleep(200) Then Return
		If $iResult = 0 Then $iResult = 1
	Else ; If No extra troop found
		SetLog("No siege to remove, great", $COLOR_SUCCESS)
		$iResult = 3
	EndIf

	Return $iResult
EndFunc   ;==>RemoveExtraSieges

Func DragSiegeIfNeeded($iSiegeIndex, ByRef $iPage)

	SetLog("Siege Needed: " & $g_asSiegeMachineNames[$iSiegeIndex])

	Local $iY1 = Random(540 + $g_iBottomOffsetY, 580 + $g_iBottomOffsetY, 1)
	Local $iY2 = Random(540 + $g_iBottomOffsetY, 580 + $g_iBottomOffsetY, 1)

	If $iPage = 0 Then
		If $iSiegeIndex >= $eSiegeWallWrecker And $iSiegeIndex <= $eSiegeLogLauncher Then
			Return True
		Else
			; Drag right to left
			ClickDrag(660, $iY1, 260, $iY2, 250) ; to expose Flame Flinger
			If _Sleep(Random(1500, 2000, 1)) Then Return
			$iPage = 1
			Return True
		EndIf
	EndIf

	If $iPage = 1 Then
		If $iSiegeIndex >= $eSiegeBattleBlimp And $iSiegeIndex <= $eSiegeTroopLauncher Then
			Return True
		Else
			; Drag left to right
			ClickDrag(220, $iY1, 650, $iY2, 250) ; to expose Wall Wrecker
			If _Sleep(Random(1500, 2000, 1)) Then Return
			$iPage = 0
			Return True
		EndIf
	EndIf

	Return False
EndFunc   ;==>DragSiegeIfNeeded

