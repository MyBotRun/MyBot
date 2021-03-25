; #FUNCTION# ====================================================================================================================
; Name ..........: Train Siege 2018
; Description ...:
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: ProMac(07-2018)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func TrainSiege($bTrainFullSiege = False)

	; Check if is necessary run the routine

	If Not $g_bRunState Then Return

	If $g_bDebugSetlogTrain Then SetLog("-- TrainSiege --", $COLOR_DEBUG)

	If Not OpenSiegeMachinesTab(True, "TrainSiege()") Then Return
	If _Sleep(500) Then Return

	Local $aCheckIsOccupied[4] = [822, 206, 0xE00D0D, 10]
	Local $aCheckIsFilled[4] = [802, 186, 0xD7AFA9, 10]
	Local $aCheckIsAvailableSiege[4] = [58, 556, 0x47717E, 10]
	Local $aCheckIsAvailableSiege1[4] = [229, 556, 0x47717E, 10]
	Local $aCheckIsAvailableSiege2[4] = [400, 556, 0x47717E, 10]
	Local $aCheckIsAvailableSiege3[4] = [576, 556, 0x47717E, 10]
	Local $aCheckIsAvailableSiege4[4] = [750, 556, 0x47717E, 10]

	Local $aiQueueSiegeMachine[$eSiegeMachineCount] = [0, 0, 0, 0, 0]
	Local $aiTotalSiegeMachine = $g_aiCurrentSiegeMachines

	; check queueing siege
	If _CheckPixel($aCheckIsFilled, True, Default, "Siege is Filled") Or _CheckPixel($aCheckIsOccupied, True, Default, "Siege is Queued") Then
		Local $Dir = @ScriptDir & "\imgxml\ArmyOverview\SiegeMachinesQueued"
		Local $aSearchResult = SearchArmy($Dir, 18, 182, 840, 261, "Queue")
		If $aSearchResult[0][0] <> "" Then
			For $i = 0 To UBound($aSearchResult) - 1
				Local $iSiegeIndex = TroopIndexLookup($aSearchResult[$i][0]) - $eWallW
				$aiQueueSiegeMachine[$iSiegeIndex] += $aSearchResult[$i][3]
				$aiTotalSiegeMachine[$iSiegeIndex] += $aSearchResult[$i][3]
				Setlog("- " & $g_asSiegeMachineNames[$iSiegeIndex] & " x" & $aSearchResult[$i][3] & " Queued.")
			Next
		EndIf
	EndIf

	If $g_bDebugSetlogTrain Or $g_bDebugSetLog Then
		For $iSiegeIndex = $eSiegeWallWrecker To $eSiegeMachineCount - 1
			SetLog("-- " & $g_asSiegeMachineNames[$iSiegeIndex] & " --", $COLOR_DEBUG)
			SetLog(@TAB & "To Build: " & $g_aiArmyCompSiegeMachines[$iSiegeIndex], $COLOR_DEBUG)
			SetLog(@TAB & "Current Army: " & $g_aiCurrentSiegeMachines[$iSiegeIndex], $COLOR_DEBUG)
			SetLog(@TAB & "In queue: " & $aiQueueSiegeMachine[$iSiegeIndex], $COLOR_DEBUG)
		Next
	EndIf

	; Refill
	For $iSiegeIndex = $eSiegeWallWrecker To $eSiegeMachineCount - 1
		Local $HowMany = $g_aiArmyCompSiegeMachines[$iSiegeIndex] - $g_aiCurrentSiegeMachines[$iSiegeIndex] - $aiQueueSiegeMachine[$iSiegeIndex]
		Local $checkPixel
		If $iSiegeIndex = $eSiegeWallWrecker Then $checkPixel = $aCheckIsAvailableSiege
		If $iSiegeIndex = $eSiegeBattleBlimp Then $checkPixel = $aCheckIsAvailableSiege1
		If $iSiegeIndex = $eSiegeStoneSlammer Then $checkPixel = $aCheckIsAvailableSiege2
		If $iSiegeIndex = $eSiegeBarracks Then $checkPixel = $aCheckIsAvailableSiege3
		If $iSiegeIndex = $eSiegeLogLauncher Then $checkPixel = $aCheckIsAvailableSiege4
		If $HowMany > 0 And _CheckPixel($checkPixel, True, Default, $g_asSiegeMachineNames[$iSiegeIndex]) Then
			PureClick($checkPixel[0], $checkPixel[1], $HowMany, $g_iTrainClickDelay)
			Local $sSiegeName = $HowMany >= 2 ? $g_asSiegeMachineNames[$iSiegeIndex] & "s" : $g_asSiegeMachineNames[$iSiegeIndex] & ""
			Setlog("Build " & $HowMany & " " & $sSiegeName, $COLOR_SUCCESS)
			$aiTotalSiegeMachine[$iSiegeIndex] += $HowMany
			If _Sleep(250) Then Return
		EndIf
		If Not $g_bRunState Then Return
	Next

	; build 2nd army
	If ($g_bDoubleTrain Or $bTrainFullSiege) And $g_iTotalTrainSpaceSiege <= 3 Then
		For $iSiegeIndex = $eSiegeWallWrecker To $eSiegeMachineCount - 1
			Local $HowMany = $g_aiArmyCompSiegeMachines[$iSiegeIndex] * 2 - $aiTotalSiegeMachine[$iSiegeIndex]
			Local $checkPixel
			If $iSiegeIndex = $eSiegeWallWrecker Then $checkPixel = $aCheckIsAvailableSiege
			If $iSiegeIndex = $eSiegeBattleBlimp Then $checkPixel = $aCheckIsAvailableSiege1
			If $iSiegeIndex = $eSiegeStoneSlammer Then $checkPixel = $aCheckIsAvailableSiege2
			If $iSiegeIndex = $eSiegeBarracks Then $checkPixel = $aCheckIsAvailableSiege3
			If $iSiegeIndex = $eSiegeLogLauncher Then $checkPixel = $aCheckIsAvailableSiege4
			If $HowMany > 0 And _CheckPixel($checkPixel, True, Default, $g_asSiegeMachineNames[$iSiegeIndex]) Then
				PureClick($checkPixel[0], $checkPixel[1], $HowMany, $g_iTrainClickDelay)
				Local $sSiegeName = $HowMany >= 2 ? $g_asSiegeMachineNames[$iSiegeIndex] & "s" : $g_asSiegeMachineNames[$iSiegeIndex] & ""
				Setlog("Build " & $HowMany & " " & $sSiegeName, $COLOR_SUCCESS)
				If _Sleep(250) Then Return
			EndIf
			If Not $g_bRunState Then Return
		Next
	EndIf
	If _Sleep(500) Then Return

	; OCR to get remain time - coc-siegeremain
	Local $sSiegeTime = getRemainBuildTimer(780, 244) ; Get time via OCR.
	If $sSiegeTime <> "" Then
		$g_aiTimeTrain[3] = ConvertOCRTime("Siege", $sSiegeTime, False) ; Update global array
		SetLog("Remaining Siege build time: " & StringFormat("%.2f", $g_aiTimeTrain[3]), $COLOR_INFO)
	EndIf
EndFunc   ;==>TrainSiege

Func CheckQueueSieges($bGetQuantity = True, $bSetLog = True, $x = 839, $bQtyWSlot = False)
	Local $aResult[1] = [""]
	If $bSetLog Then SetLog("Checking siege queue", $COLOR_INFO)

	Local $Dir = @ScriptDir & "\imgxml\ArmyOverview\SiegeMachinesQueued"

	Local $aSearchResult = SearchArmy($Dir, 18, 182, $x, 261, $bGetQuantity ? "queue" : "")
	ReDim $aResult[UBound($aSearchResult)]

	If $aSearchResult[0][0] = "" Then
		Setlog("No siege detected!", $COLOR_ERROR)
		Return
	EndIf

	For $i = 0 To (UBound($aSearchResult) - 1)
		If Not $g_bRunState Then Return
		$aResult[$i] = $aSearchResult[$i][0]
	Next

	If $bGetQuantity Then
		Local $aQuantities[UBound($aResult)][2]
		Local $aQueueTroop[$eSiegeMachineCount]
		For $i = 0 To (UBound($aQuantities) - 1)
			$aQuantities[$i][0] = $aSearchResult[$i][0]
			$aQuantities[$i][1]	= $aSearchResult[$i][3]
			Local $iSiegeIndex = Int(TroopIndexLookup($aQuantities[$i][0]) - $eWallW)
			If $iSiegeIndex >= 0 And $iSiegeIndex < $eSiegeMachineCount Then
				If $bSetLog Then SetLog("  - " & $g_asSiegeMachineNames[TroopIndexLookup($aQuantities[$i][0], "CheckQueueSieges")] & ": " & $aQuantities[$i][1] & "x", $COLOR_SUCCESS)
				$aQueueTroop[$iSiegeIndex] += $aQuantities[$i][1]
			Else
				; TODO check what to do with others
				SetDebugLog("Unsupport siege index: " & $iSiegeIndex)
			EndIf
		Next
		If $bQtyWSlot Then Return $aQuantities
		Return $aQueueTroop
	EndIf

	_ArrayReverse($aResult)
	Return $aResult
EndFunc   ;==>CheckQueueTroops