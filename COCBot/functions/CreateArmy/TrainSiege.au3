; #FUNCTION# ====================================================================================================================
; Name ..........: Train Siege 2018
; Description ...:
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: ProMac(07-2018)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func TrainSiege($bTrainFullSiege = False, $bDebugSetLog = $g_bDebugSetLog)
	Local $iPage = 0 ;
	Local $sImgSieges = @ScriptDir & "\imgxml\Train\Siege_Train\"
	Local $sSearchArea = GetDiamondFromRect2(75, 345 + $g_iMidOffsetY, 780, 520 + $g_iMidOffsetY)

	; Check if is necessary run the routine
	If Not $g_bRunState Then Return

	If $g_bDebugSetlogTrain Then SetLog("-- TrainSiege --", $COLOR_DEBUG)

	If Not OpenSiegeMachinesTab(True, "TrainSiege()") Then Return
	If _Sleep(500) Then Return

	Local $aCheckIsOccupied[4] = [766, 202 + $g_iMidOffsetY, 0xE21012, 15]
	Local $aCheckIsFilled[4] = [765, 185 + $g_iMidOffsetY, 0xD7AFA9, 15]
	Local $aiQueueSiegeMachine[$eSiegeMachineCount] = [0, 0, 0, 0, 0, 0, 0]
	Local $aiTotalSiegeMachine = $g_aiCurrentSiegeMachines

	If _CheckPixel($aReceivedTroopsDouble, True) Or _CheckPixel($aReceivedTroopsDoubleOCR, True) Then ; Found the "You have received" Message on Screen, wait till its gone.
		SetDebugLog("Detected Clan Castle Message Blocking Siege Count. Waiting until it's gone", $COLOR_INFO)
		_CaptureRegion2()
		While (_CheckPixel($aReceivedTroopsDouble, True) Or _CheckPixel($aReceivedTroopsDoubleOCR, True))
			If _Sleep($DELAYTRAIN1) Then Return
		WEnd
	EndIf

	; check queueing siege
	If _CheckPixel($aCheckIsFilled, True, Default, "Siege is Filled") Or _CheckPixel($aCheckIsOccupied, True, Default, "Siege is Queued") Then
		Local $Dir = @ScriptDir & "\imgxml\ArmyOverview\SiegeMachinesQueued"
		Local $aSearchResult = SearchArmy($Dir, 75, 188 + $g_iMidOffsetY, 777, 245 + $g_iMidOffsetY, "Queue")
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
	Local $sSiegeTime = getRemainTrainTimer(700, 162 + $g_iMidOffsetY) ; Get time via OCR.
	If $sSiegeTime <> "" Then $g_aiTimeTrain[3] = ConvertOCRTime("Remaining Siege build", $sSiegeTime, True) ; Update global array
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
EndFunc   ;==>DragSiegeIfNeeded
