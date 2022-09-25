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
	;Sale pixel values
	Local $aCheckIsAvailableSiege5[5] = [58, 556, 0x64BA29, 10] ;There are blue when on "sale"
	Local $aCheckIsAvailableSiege6[6] = [229, 556, 0x64BA29, 10]
	Local $aCheckIsAvailableSiege7[7] = [400, 556, 0x64BA29, 10]
	Local $aCheckIsAvailableSiege8[8] = [576, 556, 0x64BA29, 10]
	Local $aCheckIsAvailableSiege9[9] = [750, 556, 0x64BA29, 10]
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

	; Refill.  Do twice as many.  Regular price is green, sale price is blue.
	Local $i
	For $iSiegeIndex = $eSiegeWallWrecker To ($eSiegeMachineCount * 2) - 1
		$i = $iSiegeIndex ;Don't index over the actual count of Sieges
		if $i >= $eSiegeMachineCount Then
			$i = $i - $eSiegeMachinecount
		EndIf
		SetDebugLog("HArchH: Refill", $COLOR_DEBUG)
		Local $HowMany = $g_aiArmyCompSiegeMachines[$i] - $g_aiCurrentSiegeMachines[$i] - $aiQueueSiegeMachine[$i]
		Local $checkPixel
		SetDebugLog("HArchH: $HowMany = " & $HowMany, $COLOR_DEBUG)
		If $HowMany > 0 And $iSiegeIndex = $eSiegeFlameFlinger Then
			DragSiege("Next", 1)
		EndIf
		;Regular price pixel colors
		If $iSiegeIndex = $eSiegeWallWrecker Then $checkPixel = $aCheckIsAvailableSiege
		If $iSiegeIndex = $eSiegeBattleBlimp Then $checkPixel = $aCheckIsAvailableSiege1
		If $iSiegeIndex = $eSiegeStoneSlammer Then $checkPixel = $aCheckIsAvailableSiege2
		If $iSiegeIndex = $eSiegeBarracks Then $checkPixel = $aCheckIsAvailableSiege3
		If $iSiegeIndex = $eSiegeLogLauncher Then $checkPixel = $aCheckIsAvailableSiege4
		;Sale price pixel colors
		If $iSiegeIndex = $eSiegeWallWrecker+$eSiegeMachineCount Then $checkPixel = $aCheckIsAvailableSiege5
		If $iSiegeIndex = $eSiegeBattleBlimp+$eSiegeMachineCount Then $checkPixel = $aCheckIsAvailableSiege6
		If $iSiegeIndex = $eSiegeStoneSlammer+$eSiegeMachineCount Then $checkPixel = $aCheckIsAvailableSiege7
		If $iSiegeIndex = $eSiegeBarracks+$eSiegeMachineCount Then $checkPixel = $aCheckIsAvailableSiege8
		If $iSiegeIndex = $eSiegeLogLauncher+$eSiegeMachineCount Then $checkPixel = $aCheckIsAvailableSiege9
		SetDebugLog("HArchH: $iSiegeIndex = " & $iSiegeIndex, $COLOR_DEBUG)
		If $HowMany > 0 And _CheckPixel($checkPixel, True, Default, $g_asSiegeMachineNames[$i]) Then
			SetDebugLog("HArchH: Clicking in Refill.", $COLOR_DEBUG)
			PureClick($checkPixel[0], $checkPixel[1], $HowMany, $g_iTrainClickDelay)
			Local $sSiegeName = $HowMany >= 2 ? $g_asSiegeMachineNames[$i] & "s" : $g_asSiegeMachineNames[$i] & ""
			Setlog("Build " & $HowMany & " " & $sSiegeName, $COLOR_SUCCESS)
			$aiTotalSiegeMachine[$i] += $HowMany
			If _Sleep(250) Then Return
		EndIf
		If $HowMany > 0 And $iSiegeIndex = $eSiegeFlameFlinger Then
			DragSiege("Prev", 1)
		EndIf
		If Not $g_bRunState Then Return
	Next

	; build 2nd army
	If ($g_bDoubleTrain Or $bTrainFullSiege) And $g_iTotalTrainSpaceSiege <= 3 Then
		For $iSiegeIndex = $eSiegeWallWrecker To ($eSiegeMachineCount * 2) - 1
		$i = $iSiegeIndex ;Don't index over the actual count of Sieges
			if $i >= $eSiegeMachineCount Then
				$i = $i - $eSiegeMachinecount
			EndIf
			SetDebugLog("HArchH: Refill2", $COLOR_DEBUG)
			Local $HowMany = $g_aiArmyCompSiegeMachines[$i] * 2 - $aiTotalSiegeMachine[$i]
			Local $checkPixel
			If $HowMany > 0 And $iSiegeIndex = $eSiegeFlameFlinger Then
				DragSiege("Next", 1)
			EndIf
			;Regular price pixel colors
			If $iSiegeIndex = $eSiegeWallWrecker Then $checkPixel = $aCheckIsAvailableSiege
			If $iSiegeIndex = $eSiegeBattleBlimp Then $checkPixel = $aCheckIsAvailableSiege1
			If $iSiegeIndex = $eSiegeStoneSlammer Then $checkPixel = $aCheckIsAvailableSiege2
			If $iSiegeIndex = $eSiegeBarracks Then $checkPixel = $aCheckIsAvailableSiege3
			If $iSiegeIndex = $eSiegeLogLauncher Then $checkPixel = $aCheckIsAvailableSiege4
			;Sale price pixel colors
			If $iSiegeIndex = $eSiegeWallWrecker+$eSiegeMachineCount Then $checkPixel = $aCheckIsAvailableSiege5
			If $iSiegeIndex = $eSiegeBattleBlimp+$eSiegeMachineCount Then $checkPixel = $aCheckIsAvailableSiege6
			If $iSiegeIndex = $eSiegeStoneSlammer+$eSiegeMachineCount Then $checkPixel = $aCheckIsAvailableSiege7
			If $iSiegeIndex = $eSiegeBarracks+$eSiegeMachineCount Then $checkPixel = $aCheckIsAvailableSiege8
			If $iSiegeIndex = $eSiegeLogLauncher+$eSiegeMachineCount Then $checkPixel = $aCheckIsAvailableSiege9
			SetDebugLog("HArchH: 2nd Army $iSiegeIndex = " & $iSiegeIndex, $COLOR_DEBUG)
			If $HowMany > 0 And _CheckPixel($checkPixel, True, Default, $g_asSiegeMachineNames[$i]) Then
				PureClick($checkPixel[0], $checkPixel[1], $HowMany, $g_iTrainClickDelay)
				Local $sSiegeName = $HowMany >= 2 ? $g_asSiegeMachineNames[$i] & "s" : $g_asSiegeMachineNames[$i] & ""
				Setlog("Build " & $HowMany & " " & $sSiegeName, $COLOR_SUCCESS)
				If _Sleep(250) Then Return
			EndIf
			If $HowMany > 0 And $iSiegeIndex = $eSiegeFlameFlinger Then
				DragSiege("Prev", 1)
			EndIf
			If Not $g_bRunState Then Return
		Next
	EndIf
	If _Sleep(500) Then Return

	; OCR to get remain time - coc-siegeremain
	Local $sSiegeTime = getRemainTrainTimer(742, 159) ; Get time via OCR.
	If $sSiegeTime <> "" Then
		$g_aiTimeTrain[3] = ConvertOCRTime("Siege", $sSiegeTime, False) ; Update global array
		SetLog("Remaining Siege build time: " & StringFormat("%.2f", $g_aiTimeTrain[3]), $COLOR_INFO)
	EndIf
EndFunc   ;==>TrainSiege

Func DragSiege($Direction = "Next", $HowMany = 1)
	Local $DragYPoint =  500
	For $i = 1 To $HowMany
		Switch $Direction
			Case "Next"
				ClickDrag(550, $DragYPoint, 378, $DragYPoint, 500)
			Case "Prev"
				ClickDrag(370, $DragYPoint, 542, $DragYPoint, 500)
		EndSwitch
		If _Sleep(1000) Then Return
	Next
EndFunc

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

