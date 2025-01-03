; #FUNCTION# ====================================================================================================================
; Name ..........: Train Siege 2018
; Description ...:
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: ProMac(07-2018)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func WhichSiegeToTrain($bTrainFullSiege = False)
	Local $ToReturnTemp[1][2] = [["WallW", 0]] ; 2 element dynamic list [Siege, quantity]
	Local $ToReturn[2] = ["WallW", 0] ; 2 elements Only
	Local $bDoubleSiege = False
	If ($g_bDoubleTrain Or $bTrainFullSiege) And $g_iTotalTrainSpaceSiege <= 3 Then $bDoubleSiege = True
	; Sieges
	For $i = 0 To $eSiegeMachineCount - 1
		If $g_aiArmyCompSiegeMachines[$i] > 0 Then
			$ToReturnTemp[UBound($ToReturnTemp) - 1][0] = $g_asSiegeMachineShortNames[$i]
			$ToReturnTemp[UBound($ToReturnTemp) - 1][1] = $g_aiArmyCompSiegeMachines[$i] * ($bDoubleSiege ? 2 : 1)
			ReDim $ToReturnTemp[UBound($ToReturnTemp) + 1][2]
		EndIf
	Next
	$ToReturn[0] = $ToReturnTemp[0][0]
	$ToReturn[1] = Number($ToReturnTemp[0][1])
	Return $ToReturn
EndFunc   ;==>WhichSiegeToTrain

Func RemoveSieges($bHowToRemoveSieges)
	Local $bReturn[3] = [False, -1, -1]
	If Not $bHowToRemoveSieges[0] And Not $bHowToRemoveSieges[1] Then Return $bReturn
	If $bHowToRemoveSieges[1] Then $bReturn[2] = RemoveSiegesQueue()
	If _Sleep(1000) Then Return
	If $bHowToRemoveSieges[0] Then
		If Not OpenArmyTab(False, "Removesieges") Then Return
		If _Sleep(300) Then Return
		Local $sSiegeInfo = getSiegeCampCap(707, 168 + $g_iMidOffsetY, True) ; OCR read Siege built and total
		If $g_bDebugSetLogTrain Then SetLog("OCR $sSiegeInfo = " & $sSiegeInfo, $COLOR_DEBUG)
		Local $aGetSiegeCap = StringSplit($sSiegeInfo, "#", $STR_NOCOUNT) ; split the built Siege number from the total Siege number
		If UBound($aGetSiegeCap) = 2 Then
			Click(775, 175 + $g_iMidOffsetY)
			If _Sleep(1000) Then Return
			Local $aiOkayButton = findButton("Okay", Default, 1, True)
			If IsArray($aiOkayButton) And UBound($aiOkayButton, 1) = 2 Then
				Click($aiOkayButton[0], $aiOkayButton[1])     ; Click Okay Button
				$bReturn[1] = 0
			Else
				Click(325, 415 + $g_iMidOffsetY)     ; Click Cancel Button
			EndIf
			If _Sleep(500) Then Return
			If Not OpenSiegeMachinesTab(True, "TrainSiege()") Then Return
		Else
			If _Sleep(500) Then Return
			If Not OpenSiegeMachinesTab(True, "TrainSiege()") Then Return
		EndIf
	EndIf
	If $bReturn[1] > -1 Or $bReturn[2] > -1 Then $bReturn[0] = True
	Return $bReturn
EndFunc   ;==>RemoveSieges

Func RemoveSiegesQueue() ; Will remove All Sieges in queue
	Local Const $x = 766
	Local Const $y = 202 + $g_iMidOffsetY ; Red pixel check Y location
	Local Const $yRemoveBtn = 198 + $g_iMidOffsetY ; Troop remove button Y location
	Local $bColorCheck = False
	Local $bLoop = 0
	If Not $g_bRunState Then Return FuncReturn(False, $g_bDebugSetLogTrain)
	$bColorCheck = _ColorCheck(_GetPixelColor($x, $y, True, $g_bDebugSetLogTrain ? "RemoveSiegesQueue:E70D0F" : Default), Hex(0xE70D0F, 6), 20)
	While $bColorCheck
		Click($x, $yRemoveBtn)  ; click remove button
		If _Sleep(200) Then Return
		$bColorCheck = _ColorCheck(_GetPixelColor($x, $y, True, $g_bDebugSetLogTrain ? "RemoveSiegesQueue:E70D0F" : Default), Hex(0xE70D0F, 6), 20)
		$bLoop += 1
		If $bLoop = 7 Then ExitLoop
	WEnd
	Return 0
EndFunc   ;==>RemoveSiegesQueue

Func TrainSiege($bTrainFullSiege = False, $bDebugSetLog = $g_bDebugSetLog, $bSetLog = False)

	Local $rWhichSiegeToTrain = WhichSiegeToTrain($bTrainFullSiege)
	Local $iPage = 0 ;
	Local $sImgSieges = @ScriptDir & "\imgxml\Train\Siege_Train\"
	Local $sSearchArea = GetDiamondFromRect2(75, 345 + $g_iMidOffsetY, 780, 520 + $g_iMidOffsetY)

	; Check if is necessary run the routine
	If Not $g_bRunState Then Return

	If $g_bDebugSetLogTrain Then SetLog("-- TrainSiege --", $COLOR_DEBUG)

	If Not OpenSiegeMachinesTab(True, "TrainSiege()") Then Return
	If _Sleep(500) Then Return

	Local $aCheckIsOccupied[4] = [766, 202 + $g_iMidOffsetY, 0xE70D0F, 15]
	Local $aCheckIsFilled[4] = [765, 185 + $g_iMidOffsetY, 0xD7AFA9, 15]
	Local $aiQueueSiegeMachine[$eSiegeMachineCount] = [0, 0, 0, 0, 0, 0, 0]
	Local $aiTotalSiegeMachine = $g_aiCurrentSiegeMachines

	WaitForClanMessage("TrainTabs")

	; check queueing siege
	If _CheckPixel($aCheckIsFilled, True, Default, "Siege is Filled") Or _CheckPixel($aCheckIsOccupied, True, Default, "Siege is Queued") Then
		Local $Dir = @ScriptDir & "\imgxml\ArmyOverview\SiegeMachinesQueued"
		Local $aSearchResult = SearchArmy($Dir, 75, 188 + $g_iMidOffsetY, 777, 245 + $g_iMidOffsetY, "Queue")
		If $aSearchResult[0][0] <> "" Then
			For $i = 0 To UBound($aSearchResult) - 1
				Local $iSiegeIndex = TroopIndexLookup($aSearchResult[$i][0]) - $eWallW
				$aiQueueSiegeMachine[$iSiegeIndex] += $aSearchResult[$i][3]
				$aiTotalSiegeMachine[$iSiegeIndex] += $aSearchResult[$i][3]
				SetLog("- " & $g_asSiegeMachineNames[$iSiegeIndex] & " x" & $aSearchResult[$i][3] & " Queued.")
			Next
		EndIf
	EndIf

	If $g_bDebugSetLogTrain Or $bDebugSetLog Then
		For $iSiegeIndex = $eSiegeWallWrecker To $eSiegeMachineCount - 1
			SetLog("-- " & $g_asSiegeMachineNames[$iSiegeIndex] & " --", $COLOR_DEBUG)
			SetLog(@TAB & "To Build: " & $g_aiArmyCompSiegeMachines[$iSiegeIndex], $COLOR_DEBUG)
			SetLog(@TAB & "Current Army: " & $g_aiCurrentSiegeMachines[$iSiegeIndex], $COLOR_DEBUG)
			SetLog(@TAB & "In queue: " & $aiQueueSiegeMachine[$iSiegeIndex], $COLOR_DEBUG)
			SetLog(@TAB & "Total: " & $aiTotalSiegeMachine[$iSiegeIndex], $COLOR_DEBUG)
		Next
	EndIf

	Local $bMultiSieges = 0
	For $i = 0 To $eSiegeMachineCount - 1
		If $g_aiArmyCompSiegeMachines[$i] > 0 Then $bMultiSieges += 1
	Next
	If $bMultiSieges = 1 Then
		Local $bHowToRemoveSieges[2] = [False, False]
		For $i = 0 To $eSiegeMachineCount - 1
			;Main
			If $g_aiCurrentSiegeMachines[$i] > 0 Then
				If $g_asSiegeMachineShortNames[$i] <> $rWhichSiegeToTrain[0] Then $bHowToRemoveSieges[0] = True
			EndIf
			;Queue
			If $g_aiArmyCompSiegeMachines[$i] > 0 Then
				If $aiQueueSiegeMachine[$i] = 0 Then $bHowToRemoveSieges[1] = True
			EndIf
			If $aiQueueSiegeMachine[$i] > 0 Then
				If $g_asSiegeMachineShortNames[$i] <> $rWhichSiegeToTrain[0] Then $bHowToRemoveSieges[1] = True
			EndIf
		Next
		Local $bNewCount = RemoveSieges($bHowToRemoveSieges)
		If $bNewCount[0] Then
			For $i = 0 To $eSiegeMachineCount - 1
				If $g_aiArmyCompSiegeMachines[$i] > 0 Then
					If $bNewCount[1] > -1 Then $g_aiCurrentSiegeMachines[$i] = $bNewCount[1]
					If $bNewCount[2] > -1 Then $aiQueueSiegeMachine[$i] = $bNewCount[2]
					$aiTotalSiegeMachine[$i] = $g_aiCurrentSiegeMachines[$i] + $aiQueueSiegeMachine[$i]
				EndIf
			Next
		EndIf
	EndIf

	; Refill
	For $iSiegeIndex = $eSiegeWallWrecker To $eSiegeMachineCount - 1
		Local $HowMany = $g_aiArmyCompSiegeMachines[$iSiegeIndex] - $g_aiCurrentSiegeMachines[$iSiegeIndex] - $aiQueueSiegeMachine[$iSiegeIndex]

		If $HowMany > 0 Then
			DragSiegeIfNeeded($iSiegeIndex, $iPage)

			Local $sFilename = $sImgSieges & $g_asSiegeMachineShortNames[$iSiegeIndex] & "*"
			Local $aiSiegeCoord = decodeSingleCoord(findImage("TrainSiege", $sFilename, $sSearchArea, 1, True))

			If IsArray($aiSiegeCoord) And UBound($aiSiegeCoord, 1) = 2 Then
				For $i = 1 To $HowMany
					PureClickTrain($aiSiegeCoord[0], $aiSiegeCoord[1])
				Next
				If $iSiegeIndex = 3 Then
					Local $sSiegeName = $g_asSiegeMachineNames[$iSiegeIndex]
				Else
					Local $sSiegeName = $HowMany >= 2 ? $g_asSiegeMachineNames[$iSiegeIndex] & "s" : $g_asSiegeMachineNames[$iSiegeIndex] & ""
				EndIf
				SetLog("Build " & $HowMany & " " & $sSiegeName, $COLOR_SUCCESS)
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
					For $i = 1 To $HowMany
						PureClickTrain($aiSiegeCoord[0], $aiSiegeCoord[1])
					Next
					If $iSiegeIndex = 3 Then
						Local $sSiegeName = $g_asSiegeMachineNames[$iSiegeIndex]
					Else
						Local $sSiegeName = $HowMany >= 2 ? $g_asSiegeMachineNames[$iSiegeIndex] & "s" : $g_asSiegeMachineNames[$iSiegeIndex] & ""
					EndIf
					SetLog("Build " & $HowMany & " " & $sSiegeName, $COLOR_SUCCESS)
					If _Sleep(250) Then Return
				Else
					SetLog("Can't train siege :" & $g_asSiegeMachineNames[$iSiegeIndex], $COLOR_ERROR)
				EndIf
			EndIf

			If Not $g_bRunState Then Return
		Next
	EndIf
	If _Sleep(500) Then Return

	; OCR to get remain time
	Local $sSiegeTime = getRemainTHero(723, 233 + $g_iMidOffsetY) ; Get time via OCR.
	If $sSiegeTime <> "" Then $g_aiTimeTrain[3] = ConvertOCRTime("Remaining Siege build", $sSiegeTime, $bSetLog) ; Update global array

EndFunc   ;==>TrainSiege

Func DragSiegeIfNeeded($iSiegeIndex, ByRef $iPage)

	SetLog("Siege Needed: " & $g_asSiegeMachineNames[$iSiegeIndex])

	Local $iY1 = Random(400 + $g_iMidOffsetY, 440 + $g_iMidOffsetY, 1)
	Local $iY2 = Random(400 + $g_iMidOffsetY, 440 + $g_iMidOffsetY, 1)

	If $iPage = 0 Then
		If $iSiegeIndex >= $eSiegeWallWrecker And $iSiegeIndex <= $eSiegeLogLauncher Then
			Return True
		Else
			; Drag right to left
			ClickDrag(725, $iY1, 490 - 175, $iY2, 250) ; to expose Flame Flinger
			If _Sleep(Random(1500, 2000, 1)) Then Return
			$iPage = 1
			Return True
		EndIf
	EndIf

	If $iPage = 1 Then
		If $iSiegeIndex >= $eSiegeBattleBlimp And $iSiegeIndex <= $eSiegeBattleDrill Then
			Return True
		Else
			; Drag left to right
			ClickDrag(312 - 175, $iY1, 560, $iY2, 250) ; to expose Wall Wrecker
			If _Sleep(Random(1500, 2000, 1)) Then Return
			$iPage = 0
			Return True
		EndIf
	EndIf

	Return False
EndFunc   ;==>DragSiegeIfNeeded
