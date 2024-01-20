; #FUNCTION# ====================================================================================================================
; Name ..........: CheckBaseQuick
; Description ...: Performs a quick check of base; requestCC, DonateCC, Train if required, collect resources, and pick up healed heroes.
;                : Used for prep during long trophy drops
; Syntax ........: CheckBaseQuick([$sReturnHome = ""])
; Parameters ....: $sReturnHome - [optional] a string value to support return home button press when needed. Default is "".
; Return values .: None
; Author ........: MonkeyHunter (12-2015, 09-2016)
; Modified ......: Moebius14 (07-2023)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CheckBaseQuick($sReturnHome = "")

	Switch $sReturnHome
		Case "cloud" ; PB found while in clouds searching for base, must press return home and wait for main base
			If _CheckPixel($aRtnHomeCloud1, $g_bCapturePixel, Default, "Return Home Btn chk1", $COLOR_DEBUG) And _
					_CheckPixel($aRtnHomeCloud2, $g_bCapturePixel, Default, "Return Home Btn chk2", $COLOR_DEBUG) Then ; verify return home button
				ClickP($aRtnHomeCloud1, 1, 0, "#0513") ; click return home button, return to main screen for base check before log off
				Local $wCount = 0
				While IsMainPage() = False ; wait for main screen
					If _Sleep($DELAYGETRESOURCES1) Then Return ; wait 250ms
					$wCount += 1
					If $wCount > 40 Then ; wait up to 40*250ms = 10 seconds for main page then exit
						SetLog("Warning, Main page not found", $COLOR_WARNING)
						ExitLoop
					EndIf
				WEnd
			EndIf
	EndSwitch

	If IsMainPage() Then ; check for main page

		If $g_bDebugSetlog Then SetDebugLog("CheckBaseQuick now", $COLOR_DEBUG)

		RequestCC() ; fill CC
		If _Sleep($DELAYRUNBOT1) Then Return
		checkMainScreen(False) ; required here due to many possible exits
		If $g_bRestart Then Return

		DonateCC() ; donate troops
		If _Sleep($DELAYRUNBOT1) Then Return
		checkMainScreen(False) ; required here due to many possible function exits
		If $g_bRestart Then Return

		CheckOverviewFullArmy(True) ; Check if army needs to be trained due donations
		If Not ($g_bFullArmy) And $g_bTrainEnabled Then
			If $g_iActualTrainSkip < $g_iMaxTrainSkip Then
				; Train()
				TrainSystem()
				If $g_bRestart Then Return
			Else
				If $g_bDebugSetlogTrain Then SetLog("skip train. " & $g_iActualTrainSkip + 1 & "/" & $g_iMaxTrainSkip, $color_purple)
				$g_iActualTrainSkip = $g_iActualTrainSkip + 1
				CheckOverviewFullArmy(True, False) ; use true parameter to open train overview window
				getArmySpells()
				getArmyHeroCount(False, True) ; true to close the window
				If $g_iActualTrainSkip >= $g_iMaxTrainSkip Then
					$g_iActualTrainSkip = 0
				EndIf
				Return
			EndIf
		EndIf

		Collect() ; Empty Collectors
		If _Sleep($DELAYRUNBOT1) Then Return

	Else
		If $g_bDebugSetlog Then SetDebugLog("Not on main page, CheckBaseQuick skipped", $COLOR_WARNING)
	EndIf

EndFunc   ;==>CheckBaseQuick
