; #FUNCTION# ====================================================================================================================
; Name ..........: Train Siege 2018
; Description ...:
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: ProMac(07-2018)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once


Func TrainSiege()

	; Check if is necessary run the routine
	If $g_iTotalTrainSpaceSiege < 1 Then Return
	If Not $g_bRunState Then Return

	If $g_bDebugSetlogTrain Then SetLog("-- TrainSiege --", $COLOR_DEBUG)

	If Not OpenSiegeMachinesTab(True, "TrainSiege()") Then Return

	Local $aCheckIsOccupied[4] = [822, 206, 0xE00D0D, 10]
	Local $aCheckIsFilled[4] = [802, 186, 0xD7AFA9, 10]
	Local $aCheckIsAvailableSiege[4] = [58, 556, 0x47717E, 10]
	Local $aCheckIsAvailableSiege1[4] = [229, 556, 0x47717E, 10]
	Local $aCheckIsAvailableSiege2[4] = [400, 556, 0x47717E, 10]

	Local $ToMake[3], $g_aiQueuedSiege[3]

	; $ToMake[$eSiegeWallWrecker] = $g_aiArmyCompSiegeMachine[$eSiegeWallWrecker] - ($g_aiCurrentSiegeMachines[$eSiegeWallWrecker] + $g_aiCurrentCCSiegeMachines[$eSiegeWallWrecker] + $g_aiQueuedSiege[$eSiegeWallWrecker])
	; $ToMake[$eSiegeBattleBlimp] = $g_aiArmyCompSiegeMachine[$eSiegeBattleBlimp] - ($g_aiCurrentSiegeMachines[$eSiegeBattleBlimp] + $g_aiCurrentCCSiegeMachines[$eSiegeBattleBlimp]+ $g_aiQueuedSiege[$eSiegeBattleBlimp])
	; If $g_abChkDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeWallWrecker] ; Donate WallWrecker
	; If $g_abChkDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeBattleBlimp] ; Donate BattleBlimp

	Local $TextToUse = ["Clan Castle", $g_asSiegeMachineNames[0], $g_asSiegeMachineNames[1], $g_asSiegeMachineNames[2]]

	If $g_bDebugSetlogTrain Then
		For $iSiegeIndex = $eSiegeWallWrecker To $eSiegeMachineCount - 1
			SetDebugLog("-- " & $g_asSiegeMachineNames[$iSiegeIndex] & " --")
			SetDebugLog(@TAB & "To Build: " & $g_aiArmyCompSiegeMachine[$iSiegeIndex])
			SetDebugLog(@TAB & "Current Army: " & $g_aiCurrentSiegeMachines[$iSiegeIndex])
			SetDebugLog(@TAB & "Current CC: " & $g_aiCurrentCCSiegeMachines[$iSiegeIndex])
			SetDebugLog(@TAB & "To Use at " & $g_asModeText[$iSiegeIndex] & " " & $TextToUse[$g_aiAttackUseSiege[$iSiegeIndex]])
		Next
	EndIf

	If $g_bIsFullArmywithHeroesAndSpells And ($g_iCommandStop = 3 Or $g_iCommandStop = 0) Then Return

	; Refill
	If $g_bIsFullArmywithHeroesAndSpells And Not _CheckPixel($aCheckIsFilled, True, Default, "Siege is Filled") And Not _CheckPixel($aCheckIsOccupied, True, Default, "Siege is Queued") Then
		For $iSiegeIndex = $eSiegeWallWrecker To $eSiegeMachineCount - 1
			If $g_aiArmyCompSiegeMachine[$iSiegeIndex] = 0 Then ContinueLoop
			; Check if is available to make
			Local $checkPixel
            If $iSiegeIndex = $eSiegeWallWrecker Then $checkPixel = $aCheckIsAvailableSiege
            If $iSiegeIndex = $eSiegeBattleBlimp Then $checkPixel = $aCheckIsAvailableSiege1
            If $iSiegeIndex = $eSiegeStoneSlammer Then $checkPixel = $aCheckIsAvailableSiege2
			If _CheckPixel($checkPixel, True, Default, $g_asSiegeMachineNames[$iSiegeIndex]) Then
				; ::: Just making the Siege to use :::
				If ($g_aiAttackUseSiege[$DB] = $iSiegeIndex + 1 Or $g_aiAttackUseSiege[$LB] = $iSiegeIndex + 1) And $g_aiCurrentCCSiegeMachines[$iSiegeIndex] = 0 Then
					PureClick($checkPixel[0], $checkPixel[1], $g_aiArmyCompSiegeMachine[$iSiegeIndex], $g_iTrainClickDelay)
					Local $sSiegeName = $g_aiArmyCompSiegeMachine[$iSiegeIndex] >= 2 ? $g_asSiegeMachineNames[$iSiegeIndex] & "s" : $g_asSiegeMachineNames[$iSiegeIndex] & ""
					Setlog("Build " & $g_aiArmyCompSiegeMachine[$iSiegeIndex] & " " & $sSiegeName, $COLOR_SUCCESS)
				EndIf
			EndIf
			If Not $g_bRunState Then Return
		Next
	Else
		If _CheckPixel($aCheckIsFilled, True, Default, "Siege is Filled") Or _CheckPixel($aCheckIsOccupied, True, Default, "Siege is Queued") Then
			Local $aSearchResult = SearchArmy("trainwindow-SiegesInQueue-bundle", 520, 210, 840, 220)

			If $aSearchResult[0][0] <> "" Then
				For $i = 0 To UBound($aSearchResult) - 1
					Local $tempSiege = TroopIndexLookup($aSearchResult[$i][0])
					Setlog("- " & NameOfTroop($tempSiege) & " Queued.", $COLOR_INFO)
				Next
			EndIf

			; OCR to get remain time - coc-siegeremain
			Local $sResultSpells = getRemainBuildTimer(780, 244, True) ; Get time via OCR.
			If $sResultSpells <> "" Then
				$g_aiTimeTrain[3] = ConvertOCRTime("Siege", $sResultSpells, False) ; Update global array
				SetLog("Remaining Siege build time: " & StringFormat("%.2f", $g_aiTimeTrain[3]), $COLOR_INFO)
			EndIf
			Return
		EndIf
		If Not OpenArmyTab(False, "TrainSiege()") Then Return
		If _sleep(500) Then Return
		getArmySiegeMachines(False, False, False, False) ; Last parameter is to check the Army Window
		If _sleep(500) Then Return
		If Not OpenSiegeMachinesTab(False, "TrainSiege()") Then Return
		If _sleep(500) Then Return
		For $iSiegeIndex = $eSiegeWallWrecker To $eSiegeMachineCount - 1
			If $g_aiArmyCompSiegeMachine[$iSiegeIndex] = 0 Then ContinueLoop
			If $g_aiCurrentSiegeMachines[$iSiegeIndex] < $g_aiArmyCompSiegeMachine[$iSiegeIndex] Then
				Local $HowMany = $g_aiArmyCompSiegeMachine[$iSiegeIndex] - $g_aiCurrentSiegeMachines[$iSiegeIndex]
				Local $checkPixel
                If $iSiegeIndex = $eSiegeWallWrecker Then $checkPixel = $aCheckIsAvailableSiege
                If $iSiegeIndex = $eSiegeBattleBlimp Then $checkPixel = $aCheckIsAvailableSiege1
                If $iSiegeIndex = $eSiegeStoneSlammer Then $checkPixel = $aCheckIsAvailableSiege2
				If _CheckPixel($checkPixel, True, Default, $g_asSiegeMachineNames[$iSiegeIndex]) Then
					PureClick($checkPixel[0], $checkPixel[1], $HowMany, $g_iTrainClickDelay)
					Local $sSiegeName = $HowMany >= 2 ? $g_asSiegeMachineNames[$iSiegeIndex] & "s" : $g_asSiegeMachineNames[$iSiegeIndex] & ""
					Setlog("Build " & $HowMany & " " & $sSiegeName, $COLOR_SUCCESS)
				EndIf
			EndIf
			If Not $g_bRunState Then Return
		Next
	EndIf
EndFunc   ;==>TrainSiege
