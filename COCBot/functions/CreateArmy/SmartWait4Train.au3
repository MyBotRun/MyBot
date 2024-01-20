; #FUNCTION# ====================================================================================================================
; Name ..........: SmartWait4Train
; Description ...: Will shutdown Android emulator & stop bot based on GUI configuration when waiting for troop training, spell cooking, or hero healing
; Syntax ........: SmartWait4Train()
; Parameters ....:
; Return values .: None
; Author ........: MonkeyHunter (05-2016)
; Modified ......: MR.ViPER (10-2016), TheRevenor (10-2016), MR.ViPER (12-2016), CodeSlinger69 (01-2018)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func SmartWait4Train($iTestSeconds = Default)
	If Not $g_bRunState Then Return

	Static $ichkCloseWaitSpell = 0, $ichkCloseWaitHero = 0
	Local $bTest = ($iTestSeconds <> Default)

	If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then SetLog("Begin SmartWait4Train:", $COLOR_DEBUG1)

	If Not $g_bCloseWhileTrainingEnable Then Return ; Skip if not enabled

	Local $iExitCount = 0
	If _Sleep($DELAYSMARTWAIT) Then Return ; first start 500ms so no false "**Main Window FAIL**" pops up
	While IsMainPage(2) = False ; check & wait for main page to ensure can read shield information properly
		If _Sleep($DELAYIDLE1) Then Return
		$iExitCount += 1
		If $iExitCount > 25 Then ; 5 seconds before have error?
			SetLog("SmartWait4Train not finding Main Page, skip function!", $COLOR_ERROR)
			Return
		EndIf
	WEnd

	If Not $g_bCloseWhileTrainingEnable And Not $g_bCloseWithoutShield Then Return ; skip if nothing selected in GUI

	Local $aResult, $iActiveHero
	Local $aHeroResult[$eHeroCount]
	Local Const $TRAINWAIT_NOWAIT = 0x00 ; default no waiting
	Local Const $TRAINWAIT_SHIELD = 0x01 ; Flag value used to simplify shield exists
	Local Const $TRAINWAIT_TROOP = 0x02 ; Value when wait for troop training and valid time exists
	Local Const $TRAINWAIT_SPELL = 0x04 ; Value when wait for spell cooking and valid time exists
	Local Const $TRAINWAIT_HERO = 0x08 ; Value when wait for hero healing, valid time exists, and Wait for Hero is enabled for active atttack modes

	Local $iTrainWaitCloseFlag = $TRAINWAIT_NOWAIT
	Local $sNowTime = "", $sTrainEndTime = ""
	Local $iShieldTime = 0, $iDiffDateTime = 0, $iDiffTime = 0
	Local $RandomAddPercent = Random(0, $g_iCloseRandomTimePercent / 100) ; generate random percentage between 0 and user set GUI value
	Local $MinimumTimeClose = Number($g_iCloseMinimumTime * 60) ; Minimum time required to close
	If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then SetLog("Random add percent = " & StringFormat("%.4f", $RandomAddPercent), $COLOR_DEBUG)
	If $g_bDebugSetlog Then SetDebugLog("$MinimumTimeClose = " & $MinimumTimeClose & "s", $COLOR_DEBUG)

	; Determine state of $StopEmulator flag
	Local $StopEmulator = False
	Local $bFullRestart = False
	Local $bSuspendComputer = False
	If $g_bCloseRandom Then $StopEmulator = "random"
	If $g_bCloseEmulator Then $StopEmulator = True
	If $g_bSuspendComputer Then $bSuspendComputer = True

	; Determine what wait mode(s) are enabled
	If IsArray($g_asShieldStatus) And (StringInStr($g_asShieldStatus[0], "shield", $STR_NOCASESENSEBASIC) Or StringInStr($g_asShieldStatus[0], "guard", $STR_NOCASESENSEBASIC)) Then
		If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then SetLog("Have shield till " & $g_asShieldStatus[2] & ", close game while wait for train)", $COLOR_DEBUG)
		$iTrainWaitCloseFlag = BitOR($iTrainWaitCloseFlag, $TRAINWAIT_SHIELD) ; close if we have a shield
	EndIf
	If _Sleep($DELAYRESPOND) Then Return

	; verify shield info & update if not already exist
	If IsArray($g_asShieldStatus) = 0 Or $g_asShieldStatus[0] = "" Or $g_asShieldStatus[0] = "none" Then
		$aResult = getShieldInfo()
		If @error Then
			SetLog("SmartWait4Train Shield OCR error = " & @error & "Extended = " & @extended, $COLOR_ERROR)
			Return False
		Else
			$g_asShieldStatus = $aResult ; Update new values
		EndIf
		If IsArray($g_asShieldStatus) And (StringInStr($g_asShieldStatus[0], "shield", $STR_NOCASESENSEBASIC) Or StringInStr($g_asShieldStatus[0], "guard", $STR_NOCASESENSEBASIC)) Then ; check shield after update
			If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then SetLog("Have shield till " & $g_asShieldStatus[2] & ", close game while wait for train)", $COLOR_DEBUG)
			$iTrainWaitCloseFlag = BitOR($iTrainWaitCloseFlag, $TRAINWAIT_SHIELD)
		EndIf
	EndIf
	If $g_bDebugSetlogTrain Or $g_bDebugSetlog And IsArray($g_asShieldStatus) Then SetLog("Shield Status:" & $g_asShieldStatus[0] & ", till " & $g_asShieldStatus[2], $COLOR_DEBUG)

	Local $result = OpenArmyOverview(True, "SmartWait4Train()") ; Open train overview
	If Not $result Then
		If $g_bDebugImageSave Or $g_bDebugSetlogTrain Then SaveDebugImage("SmartWait4Troop2_")
	EndIf
	If _Sleep($DELAYRESPOND) Then Return


	; Get troop training time remaining if enabled
	If $g_bCloseWithoutShield Or BitAND($iTrainWaitCloseFlag, $TRAINWAIT_SHIELD) = $TRAINWAIT_SHIELD Then
		If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then SetLog("$g_bCloseWithoutShield enabled", $COLOR_DEBUG)
		getArmyTroopTime() ; update for Oct 2016
		If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then SetLog("getArmyTroopTime returned: " & $g_aiTimeTrain[0], $COLOR_DEBUG)
		If _Sleep($DELAYRESPOND) Then Return
		If $g_aiTimeTrain[0] > 0 Then
			If $g_bCloseRandomTime Then
				$g_aiTimeTrain[0] += $g_aiTimeTrain[0] * $RandomAddPercent ; add some random percent
			EndIf
			$iTrainWaitCloseFlag = BitOR($iTrainWaitCloseFlag, $TRAINWAIT_TROOP)
		EndIf
		If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then SetLog("$iTrainWaitCloseFlag:" & $iTrainWaitCloseFlag & ", troop time = " & StringFormat("%.2f", $g_aiTimeTrain[0]), $COLOR_DEBUG)
	EndIf

	; get spell training time remaining if enabled
	If ($g_bCloseWithoutShield Or BitAND($iTrainWaitCloseFlag, $TRAINWAIT_SHIELD) = $TRAINWAIT_SHIELD) And IsWaitforSpellsActive() Then
		$ichkCloseWaitSpell = 1
		If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then SetLog("$ichkCloseWaitSpell enabled", $COLOR_DEBUG)
		getArmySpellTime()
		If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then SetLog("getArmySpellTime returned: " & $g_aiTimeTrain[1], $COLOR_DEBUG)
		If _Sleep($DELAYRESPOND) Then Return
		If $g_aiTimeTrain[1] > 0 Then
			If $g_bCloseRandomTime Then
				$g_aiTimeTrain[1] += $g_aiTimeTrain[1] * $RandomAddPercent ; add some random percent
			EndIf
			$iTrainWaitCloseFlag = BitOR($iTrainWaitCloseFlag, $TRAINWAIT_SPELL)
		EndIf
		If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then SetLog("$iTrainWaitCloseFlag:" & $iTrainWaitCloseFlag & ", spell time = " & StringFormat("%.2f", $g_aiTimeTrain[1]), $COLOR_DEBUG)
	Else
		$ichkCloseWaitSpell = 0
	EndIf

	; get hero regen time remaining if enabled
	If ($g_bCloseWithoutShield Or BitAND($iTrainWaitCloseFlag, $TRAINWAIT_SHIELD) = $TRAINWAIT_SHIELD) And IsWaitforHeroesActive() Then
		$ichkCloseWaitHero = 1
		If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then SetLog("$ichkCloseWaitHero enabled", $COLOR_DEBUG)
		For $j = 0 To UBound($aResult) - 1
			$aHeroResult[$j] = 0 ; reset old values
		Next
		If _Sleep($DELAYRESPOND) Then Return
		$aHeroResult = getArmyHeroTime("all")
		If @error Then
			SetLog("getArmyHeroTime return error: " & @error & ", exit SmartWait!", $COLOR_ERROR)
			Return ; if error, then quit smartwait
		EndIf
		If Not IsArray($aHeroResult) Then
			SetLog("getArmyHeroTime OCR fail, exit SmartWait!", $COLOR_ERROR)
			Return ; quit when ocr fai, stop trying to close while training this time
		EndIf
		If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then SetLog("getArmyHeroTime returned: " & $aHeroResult[0] & ":" & $aHeroResult[1] & ":" & $aHeroResult[2], $COLOR_DEBUG)
		If _Sleep($DELAYRESPOND) Then Return
		If $aHeroResult[0] > 0 Or $aHeroResult[1] > 0 Or $aHeroResult[2] > 0 Or $aHeroResult[3] > 0 Then ; check if hero is enabled to use/wait and set wait time
			For $pTroopType = $eKing To $eChampion ; check all 4 hero
				Local $iHeroIdx = $pTroopType - $eKing
				For $pMatchMode = $DB To $LB ; check only DB and LB (TS has no wait option!)
					If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then
						SetLog("$pTroopType: " & GetTroopName($pTroopType) & ", $pMatchMode: " & $g_asModeText[$pMatchMode], $COLOR_DEBUG)
						SetLog("TroopToBeUsed: " & IsUnitUsed($pMatchMode, $pTroopType) & ", Hero Wait Status= " & IsSearchModeActiveMini($pMatchMode) & " & " & IsUnitUsed($pMatchMode, $pTroopType) & " & " & ($g_iHeroUpgrading[$iHeroIdx] <> 1) & " & " & ($g_iHeroWaitAttackNoBit[$pMatchMode][$iHeroIdx] = 1), $COLOR_DEBUG)
						SetLog("$g_aiAttackUseHeroes[" & $pMatchMode & "]= " & $g_aiAttackUseHeroes[$pMatchMode] & ", $g_aiSearchHeroWaitEnable[" & $pMatchMode & "]= " & $g_aiSearchHeroWaitEnable[$pMatchMode] & ", $g_iHeroUpgradingBit=" & $g_iHeroUpgradingBit, $COLOR_DEBUG)
					EndIf
					$iActiveHero = -1
					If IsSearchModeActiveMini($pMatchMode) And IsUnitUsed($pMatchMode, $pTroopType) And $g_iHeroUpgrading[$iHeroIdx] <> 1 And $g_iHeroWaitAttackNoBit[$pMatchMode][$iHeroIdx] = 1 Then
						$iActiveHero = $iHeroIdx ; compute array offset to active hero
					EndIf
					If $iActiveHero <> -1 And $aHeroResult[$iActiveHero] > 0 Then ; valid time?
						; check exact time & existing time is less than new time
						If $g_bCloseRandomTime And $g_aiTimeTrain[2] < $aHeroResult[$iActiveHero] Then
							$g_aiTimeTrain[2] = $aHeroResult[$iActiveHero] + ($aHeroResult[$iActiveHero] * $RandomAddPercent) ; add some random percent
						ElseIf $g_bCloseExactTime And $g_aiTimeTrain[2] < $aHeroResult[$iActiveHero] Then
							$g_aiTimeTrain[2] = $aHeroResult[$iActiveHero] ; use exact time
						EndIf
						$iTrainWaitCloseFlag = BitOR($iTrainWaitCloseFlag, $TRAINWAIT_HERO)
						If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then
							SetLog("Wait enabled: " & GetTroopName($pTroopType) & ":" & $g_asModeText[$pMatchMode] & ", $iTrainWaitCloseFlag:" & $iTrainWaitCloseFlag & ", Hero Time:" & $aHeroResult[$iActiveHero] & ", Wait Time: " & StringFormat("%.2f", $g_aiTimeTrain[2]), $COLOR_DEBUG)
						EndIf
					EndIf
				Next
				If _Sleep($DELAYRESPOND) Then Return
			Next
		Else
			If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then SetLog("getArmyHeroTime return all zero hero wait times", $COLOR_DEBUG)
		EndIf
		If $g_aiTimeTrain[2] > 0 Then
			If $g_bCloseRandomTime Then
				$g_aiTimeTrain[2] += $g_aiTimeTrain[2] * $RandomAddPercent ; add some random percent
			EndIf
			$iTrainWaitCloseFlag = BitOR($iTrainWaitCloseFlag, $TRAINWAIT_HERO)
		EndIf
		If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then SetLog("$iTrainWaitCloseFlag:" & $iTrainWaitCloseFlag & ", hero time = " & StringFormat("%.2f", $g_aiTimeTrain[2]), $COLOR_DEBUG)
	Else
		$ichkCloseWaitHero = 0
		$g_aiTimeTrain[2] = 0 ; clear hero remain time if disabled during stop
	EndIf

	; update CC remaining time till next request if request made and CC not full
	If $g_iCCRemainTime = 0 And _ColorCheck(_GetPixelColor($aRequestTroopsAO[0], $aRequestTroopsAO[1] + 10, True), Hex($aRequestTroopsAO[3], 6), $aRequestTroopsAO[5]) And Not _ColorCheck(_GetPixelColor($aRequestTroopsAO[0], $aRequestTroopsAO[1], True), Hex($aRequestTroopsAO[4], 6), $aRequestTroopsAO[5]) Then
		getArmyCCStatus()
	EndIf

	ClickAway()
	If _Sleep($DELAYCHECKARMYCAMP4) Then Return

	If $iTrainWaitCloseFlag = $TRAINWAIT_NOWAIT Then Return ; Check close game flag enabled or return back without close

	; determine time to close CoC
	Local $iTrainWaitTime
	Switch $iTrainWaitCloseFlag
		Case 14 To 15 ; BitAND($iTrainWaitCloseFlag, $TRAINWAIT_HERO, $TRAINWAIT_SPELL, $TRAINWAIT_TROOP, $TRAINWAIT_SHIELD) = $iTrainWaitCloseFlag
			$iTrainWaitTime = _ArrayMax($g_aiTimeTrain, 1, 0, 2, 0) ; use larger of troop, spell, or hero time
		Case 12 To 13
			$iTrainWaitTime = _Max($g_aiTimeTrain[1], $g_aiTimeTrain[2]) ; use larger of spell or hero time
		Case 10 To 11
			$iTrainWaitTime = _Max($g_aiTimeTrain[0], $g_aiTimeTrain[2]) ; use larger of train or hero time
		Case 8 To 9
			$iTrainWaitTime = $g_aiTimeTrain[2] ; use hero time
		Case 6 To 7
			$iTrainWaitTime = _Max($g_aiTimeTrain[0], $g_aiTimeTrain[1]) ; use larger of troop or spell time
		Case 4 To 5
			$iTrainWaitTime = $g_aiTimeTrain[1] ; use shield time
		Case 2 To 3
			$iTrainWaitTime = $g_aiTimeTrain[0] ; use troop time
		Case 1 ; BitAND($iTrainWaitCloseFlag, $TRAINWAIT_SHIELD) = $iTrainWaitCloseFlag
			If $g_aiTimeTrain[0] <= 1 And Not $bTest Then
				ClickAway()
				If _Sleep($DELAYCHECKARMYCAMP4) Then Return
				SetLog("No smart troop wait needed", $COLOR_SUCCESS)
				Return
			Else
				$iTrainWaitTime = $g_aiTimeTrain[0] ; use troop time
			EndIf
		Case Else
			SetLog("SmartWait cannot determine time to close CoC!", $COLOR_ERROR)
			Return ; stop trying to close while training this time
	EndSwitch

	If $g_bDebugSetlogTrain Or $g_bDebugSetlog Or $bTest Then
		SetLog("Training time values: " & StringFormat("%.2f", $g_aiTimeTrain[0]) & " : " & StringFormat("%.2f", $g_aiTimeTrain[1]) & " : " & StringFormat("%.2f", $g_aiTimeTrain[2]), $COLOR_DEBUG)
		SetLog("$iTrainWaitTime = " & StringFormat("%.2f", $iTrainWaitTime) & " minutes", $COLOR_DEBUG)
		SetLog("$iTrainWaitCloseFlag: " & $iTrainWaitCloseFlag)
	EndIf

	; Adjust train wait time if CC request is enabled to ensure CC is full before troops are done training
	If $g_bRequestTroopsEnable And $g_iCCRemainTime > 0 And $g_iCCRemainTime < $iTrainWaitTime And ($g_abSearchCastleWaitEnable[$DB] Or $g_abSearchCastleWaitEnable[$LB]) Then
		If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then SetLog("Wait time reduced for CC from: " & StringFormat("%.2f", $iTrainWaitTime) & " To " & StringFormat("%.2f", $g_iCCRemainTime), $COLOR_DEBUG)
		$iTrainWaitTime = $g_iCCRemainTime ; Set wait time based on time remaining in CC request to ensure CC is full
	EndIf

	$iTrainWaitTime = $iTrainWaitTime * 60 ; convert $iTrainWaitTime to seconds instead of minutes returned from OCR

	$sNowTime = _NowCalc() ; find/store time right now
	If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then SetLog("Train end time: " & _DateAdd("s", Int($iTrainWaitTime), $sNowTime), $COLOR_DEBUG)

	If IsArray($g_asShieldStatus) And _DateIsValid($g_asShieldStatus[2]) Then ;check for valid shield time
		$iShieldTime = _DateDiff("s", $sNowTime, $g_asShieldStatus[2]) ; find seconds until shield expires
		If @error Then _logErrorDateDiff(@error)
		If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then SetLog("Shield time remain: " & $iShieldTime & " seconds", $COLOR_DEBUG)
		; subtract 45 seconds from actual Shield to allow for misc emulator/App start & stop delays, to prevent being attacked
		; immediately after Guard shield expires when you have no grace time.  Feature required to avoid losing trophy when trophy pushing
		If $iShieldTime < 45 Then
			$iShieldTime = 0
		Else
			$iShieldTime -= 45
		EndIf
	EndIf

	$iDiffTime = $iShieldTime - ($iTrainWaitTime) ; Find difference between train and shield time.
	If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then SetLog("Time Train:Shield:Diff " & ($iTrainWaitTime) & ":" & $iShieldTime & ":" & $iDiffTime, $COLOR_DEBUG)

	If ($iTrainWaitTime >= $MinimumTimeClose) Or $bTest Then ; are close times above minumum close time in GUI?
		If $iShieldTime > 0 Then ; is shield time positive?
			If $iDiffTime <= 0 Then ; is shield time less than total train time?
				; close game = $iShieldTime because less than train time remaining
				SetLog("Smart wait while shield time = " & StringFormat("%.2f", $iShieldTime / 60) & " Minutes", $COLOR_INFO)
				If $g_bNotifyTGEnable And $g_bNotifyAlertSmartWaitTime Then NotifyPushToTelegram($g_sNotifyOrigin & " : " & "%0A" & GetTranslatedFileIni("MBR Func_Notify", "Smart-Wait-Time_Info_01", "Smart Wait While Shield Time = ") & StringFormat("%.2f", $iShieldTime / 60) & GetTranslatedFileIni("MBR Func_Notify", "Smart-Wait-Time_Info_02", " Minutes") & "%0A" & GetTranslatedFileIni("MBR Func_Notify", "Smart-Wait-Time_Info_03", "Wait For Troops Ready"))
				If $bTest Then $iShieldTime = $iTestSeconds
				UniversalCloseWaitOpenCoC($iShieldTime * 1000, "SmartWait4Train_", $StopEmulator, $bFullRestart, $bSuspendComputer)
				$g_bRestart = True ; Set flag to exit idle loop to deal with potential user changes to GUI
				ResetTrainTimeArray()
			Else ; close game  = $iTrainWaitTime because shield is larger than train time
				SetLog("Smart wait train time = " & StringFormat("%.2f", $iTrainWaitTime / 60) & " Minutes", $COLOR_INFO)
				If $g_bNotifyTGEnable And $g_bNotifyAlertSmartWaitTime Then NotifyPushToTelegram($g_sNotifyOrigin & " : " & "%0A" & GetTranslatedFileIni("MBR Func_Notify", "Smart-Wait-Time_Info_04", "Smart Wait Train Time = ") & StringFormat("%.2f", $iTrainWaitTime / 60) & GetTranslatedFileIni("MBR Func_Notify", "Smart-Wait-Time_Info_02", " Minutes") & "%0A" & GetTranslatedFileIni("MBR Func_Notify", "Smart-Wait-Time_Info_03", "Wait For Troops Ready"))
				If $bTest Then $iTrainWaitTime = $iTestSeconds
				UniversalCloseWaitOpenCoC($iTrainWaitTime * 1000, "SmartWait4Train_", $StopEmulator, $bFullRestart, $bSuspendComputer)
				$g_bRestart = True ; Set flag to exit idle loop to deal with potential user changes to GUI
				ResetTrainTimeArray()
			EndIf
			; if shield is zero, or not available, then check all 3 close without shield flags
		ElseIf ($g_bCloseWithoutShield And $g_aiTimeTrain[0] > 0) Or ($ichkCloseWaitSpell = 1 And $g_aiTimeTrain[1] > 0) Or ($ichkCloseWaitHero = 1 And $g_aiTimeTrain[2] > 0) Then
			;when no shield close game for $iTrainWaitTime time as determined above
			SetLog("Smart Wait time = " & StringFormat("%.2f", $iTrainWaitTime / 60) & " Minutes", $COLOR_INFO)
			If $g_bNotifyTGEnable And $g_bNotifyAlertSmartWaitTime Then NotifyPushToTelegram($g_sNotifyOrigin & " : " & "%0A" & GetTranslatedFileIni("MBR Func_Notify", "Smart-Wait-Time_Info_05", "Smart Wait Time = ") & StringFormat("%.2f", $iTrainWaitTime / 60) & GetTranslatedFileIni("MBR Func_Notify", "Smart-Wait-Time_Info_02", " Minutes") & "%0A" & GetTranslatedFileIni("MBR Func_Notify", "Smart-Wait-Time_Info_03", "Wait For Troops Ready"))
			If $bTest Then $iTrainWaitTime = $iTestSeconds
			UniversalCloseWaitOpenCoC($iTrainWaitTime * 1000, "SmartWait4TrainNoShield_", $StopEmulator, $bFullRestart, $bSuspendComputer)
			$g_bRestart = True ; Set flag to exit idle loop to deal with potential user changes to GUI
			ResetTrainTimeArray()
		Else
			If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then SetLog("$ichkCloseWaitSpell=" & $ichkCloseWaitSpell & ", $g_aiTimeTrain[1]=" & $g_aiTimeTrain[1], $COLOR_DEBUG)
			If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then SetLog("$ichkCloseWaitHero=" & $ichkCloseWaitHero & ", $g_aiTimeTrain[2]=" & $g_aiTimeTrain[2], $COLOR_DEBUG)
			If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then SetLog("Troop training with time remaining not enabled, skip SmartWait game exit", $COLOR_DEBUG)
		EndIf
	Else
		SetLog("Smart Wait Time < Minimum Time Required To Close [" & ($MinimumTimeClose / 60) & " Min]", $COLOR_INFO)
		SetLog("Wait Train Time = " & StringFormat("%.2f", $iTrainWaitTime / 60) & " Minutes", $COLOR_INFO)
		SetLog("Remain Shield Time = " & StringFormat("%.2f", $iShieldTime / 60) & " Minutes", $COLOR_INFO)
		SetLog("Not Close CoC Just Wait In The Main Screen", $COLOR_INFO)
		; Just wait without close the CoC
		If ($iShieldTime < $iTrainWaitTime) And ($g_bCloseWithoutShield = False) Then ; only wait for lessor of shield time or training time due risk of app timeout with longer wait times
			_SleepStatus($iShieldTime * 1000)
		Else
			_SleepStatus($iTrainWaitTime * 1000)
		EndIf
		ResetTrainTimeArray()
	EndIf

EndFunc   ;==>SmartWait4Train

Func ResetTrainTimeArray()
	For $i = 0 To UBound($g_aiTimeTrain) - 1 ; reset remaining time array values to zero
		$g_aiTimeTrain[$i] = 0
	Next
EndFunc   ;==>ResetTrainTimeArray
