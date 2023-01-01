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

Func TrainSiege($bTrainFullSiege = False, $bDebugSetLog = $g_bDebugSetLog)
	Local $iPage = 0;
	Local $sImgSieges = @ScriptDir & "\imgxml\Train\Siege_Train\" ; "25,410,840,515"
	Local $sSearchArea = GetDiamondFromRect2(25, 380 + $g_iMidOffsetY, 840, 485 + $g_iMidOffsetY)
	
	; Check if is necessary run the routine
	If Not $g_bRunState Then Return

	If $g_bDebugSetlogTrain Then SetLog("-- TrainSiege --", $COLOR_DEBUG)

	If Not OpenSiegeMachinesTab(True, "TrainSiege()") Then Return
	If _Sleep(500) Then Return

	Local $aCheckIsOccupied[4] = [822, 176 + $g_iMidOffsetY, 0xE00D0D, 15]
	Local $aCheckIsFilled[4] = [802, 156 + $g_iMidOffsetY, 0xD7AFA9, 15]
	Local $aiQueueSiegeMachine[$eSiegeMachineCount] = [0, 0, 0, 0, 0, 0, 0]
	Local $aiTotalSiegeMachine = $g_aiCurrentSiegeMachines

	; check queueing siege
	If _CheckPixel($aCheckIsFilled, True, Default, "Siege is Filled") Or _CheckPixel($aCheckIsOccupied, True, Default, "Siege is Queued") Then
		Local $Dir = @ScriptDir & "\imgxml\ArmyOverview\SiegeMachinesQueued"
		Local $aSearchResult = SearchArmy($Dir, 18, 152 + $g_iMidOffsetY, 840, 231 + $g_iMidOffsetY, "Queue")
		If $aSearchResult[0][0] <> "" Then
			For $i = 0 To UBound($aSearchResult) - 1
				Local $iSiegeIndex = TroopIndexLookup($aSearchResult[$i][0]) - $eWallW
				$aiQueueSiegeMachine[$iSiegeIndex] += $aSearchResult[$i][3]
				$aiTotalSiegeMachine[$iSiegeIndex] += $aSearchResult[$i][3]
				Setlog("- " & $g_asSiegeMachineNames[$iSiegeIndex] & " x" & $aSearchResult[$i][3] & " Queued.")
			Next
		EndIf
	EndIf

	If $g_bDebugSetlogTrain Or $bDebugSetLog Then
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

		If $HowMany > 0 Then
			DragSiegeIfNeeded($iSiegeIndex, $iPage)
			
			Local $sFilename = $sImgSieges & $g_asSiegeMachineShortNames[$iSiegeIndex] & "*"
			Local $aiSiegeCoord = decodeSingleCoord(findImage("TrainSiege", $sFilename, $sSearchArea, 1, True))

			If IsArray($aiSiegeCoord) And UBound($aiSiegeCoord, 1) = 2 Then
				PureClick($aiSiegeCoord[0], $aiSiegeCoord[1], $HowMany, $g_iTrainClickDelay)
				Local $sSiegeName = $HowMany >= 2 ? $g_asSiegeMachineNames[$iSiegeIndex] & "s" : $g_asSiegeMachineNames[$iSiegeIndex] & ""
				Setlog("Build " & $HowMany & " " & $sSiegeName, $COLOR_SUCCESS)
				$aiTotalSiegeMachine[$iSiegeIndex] += $HowMany
				If _Sleep(250) Then Return
			Else
				SetLog("Can't train siege :" & $g_asSiegeMachineNames[$iSiegeIndex], $COLOR_ERROR)
			EndIf
		EndIf

		If Not $g_bRunState Then Return
	Next

	; build 2nd army
	If ($g_bDoubleTrain Or $bTrainFullSiege) And $g_iTotalTrainSpaceSiege <= 3 Then
		For $iSiegeIndex = $eSiegeWallWrecker To $eSiegeMachineCount - 1
			Local $HowMany = $g_aiArmyCompSiegeMachines[$iSiegeIndex] * 2 - $aiTotalSiegeMachine[$iSiegeIndex]

			If $HowMany > 0 Then
				DragSiegeIfNeeded($iSiegeIndex, $iPage)

				Local $sFilename = $sImgSieges & $g_asSiegeMachineShortNames[$iSiegeIndex] & "*"
				Local $aiSiegeCoord = decodeSingleCoord(findImage("TrainSiege", $sFilename, $sSearchArea, 1, True))

				If IsArray($aiSiegeCoord) And UBound($aiSiegeCoord, 1) = 2 Then
					PureClick($aiSiegeCoord[0], $aiSiegeCoord[1], $HowMany, $g_iTrainClickDelay)
					Local $sSiegeName = $HowMany >= 2 ? $g_asSiegeMachineNames[$iSiegeIndex] & "s" : $g_asSiegeMachineNames[$iSiegeIndex] & ""
					Setlog("Build " & $HowMany & " " & $sSiegeName, $COLOR_SUCCESS)
					If _Sleep(250) Then Return
				Else
					SetLog("Can't train siege :" & $g_asSiegeMachineNames[$iSiegeIndex], $COLOR_ERROR)
				EndIf
			EndIf

			If Not $g_bRunState Then Return
		Next
	EndIf
	If _Sleep(500) Then Return

	; OCR to get remain time - coc-siegeremain
	Local $sSiegeTime = getRemainTrainTimer(742, 129 + $g_iMidOffsetY) ; Get time via OCR.
	If $sSiegeTime <> "" Then
		$g_aiTimeTrain[3] = ConvertOCRTime("Siege", $sSiegeTime, False) ; Update global array
		SetLog("Remaining Siege build time: " & StringFormat("%.2f", $g_aiTimeTrain[3]), $COLOR_INFO)
	EndIf
EndFunc   ;==>TrainSiege

Func CheckQueueSieges($bGetQuantity = True, $bSetLog = True, $x = 839, $bQtyWSlot = False)
	Local $aResult[1] = [""]
	If $bSetLog Then SetLog("Checking siege queue", $COLOR_INFO)

	Local $Dir = @ScriptDir & "\imgxml\ArmyOverview\SiegeMachinesQueued"

	Local $aSearchResult = SearchArmy($Dir, 18, 152 + $g_iMidOffsetY, $x, 231 + $g_iMidOffsetY, $bGetQuantity ? "queue" : "")
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

Func DragSiegeIfNeeded($iSiegeIndex, ByRef $iPage)

	SetLog("---- DragSiegeIfNeeded ----")
	SetLog("Current Page : " & $iPage)
	SetLog("Siege Needed: " & $g_asSiegeMachineNames[$iSiegeIndex])

	Local $iY1 = Random(400 + $g_iMidOffsetY, 440 + $g_iMidOffsetY, 1)
	Local $iY2 = Random(400 + $g_iMidOffsetY, 440 + $g_iMidOffsetY, 1)

	If $iPage = 0 Then
		If $iSiegeIndex >= $eSiegeWallWrecker And $iSiegeIndex <= $eSiegeLogLauncher Then 
			Return True
		Else
			; Drag right to left
			ClickDrag(725, $iY1, 490 - 175, $iY2, 250) ; to expose Flame Flinger 
			$iPage += 1
			Return True
		EndIf
	EndIf
	
	If $iPage = 1 Then
		If $iSiegeIndex >= $eSiegeBattleBlimp And $iSiegeIndex <= $eSiegeBattleDrill Then
			Return True
		Else
			; Drag left to right
			ClickDrag(312 - 175, $iY1, 547, $iY2, 250) ; to expose Wall Wrecker
			$iPage -= 1
			Return True
		EndIf
	EndIf

	Return False
EndFunc
