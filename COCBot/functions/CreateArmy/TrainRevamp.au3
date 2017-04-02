; #FUNCTION# ====================================================================================================================
; Name ..........: Train Revamp Oct 2016
; Description ...:
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Mr.Viper(10-2016), ProMac(10-2016), CodeSlinger69 (01-2017)
; Modified ......: ProMac (11-2016), Boju (11-2016), MR.ViPER (12-2016), CodeSlinger69 (01-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func TrainRevamp()

	If $g_bTrainEnabled = False Then ; check for training disabled in halt mode
		If $g_iDebugSetlogTrain = 1 Then Setlog("Halt mode - training disabled", $COLOR_DEBUG)
		Return
	EndIf

	$g_sTimeBeforeTrain = _NowCalc()
	StartGainCost()

	If $g_bQuickTrainEnable = False Then
		TrainRevampOldStyle()
		Return
	EndIf

	If $g_iDebugSetlogTrain = 1 Then Setlog(" - Initial Quick train Function")

	Local $timer

	If $g_iDebugSetlogTrain = 1 Then Setlog(" - Line Open Army Window")

	CheckArmySpellCastel()

	;Test for Train/Donate Only and Fullarmy
	If ($g_iCommandStop = 3 Or $g_iCommandStop = 0) And $g_bFullArmy Then
		SetLog("You are in halt attack mode and your Army is prepared!", $COLOR_DEBUG) ;Debug
		If $g_bFirstStart Then $g_bFirstStart = False
		Return
	EndIf

	;Load Troop and Spell counts in "Cur"
	;CheckExistentArmy("Troops") ; routine on checkArmyCamp
	;CheckExistentArmy("Spells") ; routine on checkArmyCamp

	If $g_bRunState = False Then Return

	If ($g_bIsFullArmywithHeroesAndSpells = True) Or ($g_CurrentCampUtilization = 0 And $g_bFirstStart) Then

		If $g_bIsFullArmywithHeroesAndSpells Then Setlog(" - Your Army is Full, let's make troops before Attack!", $COLOR_BLUE)
		If ($g_CurrentCampUtilization = 0 And $g_bFirstStart) Then
			Setlog(" - Your Army is Empty, let's make troops before Attack!", $COLOR_ACTION1)
			Setlog(" - Go to TrainRevamp Tab and select your Quick Army position!", $COLOR_ACTION1)
		EndIf

		DeleteQueued("Troops")
		If _Sleep(250) Then Return
		DeleteQueued("Spells")
		If _Sleep(500) Then Return

		CheckCamp()

		ResetVariables("donated")

		If $g_bFirstStart Then $g_bFirstStart = False

		If _Sleep(700) Then Return
	Else

		If $g_bDonationEnabled And $g_bChkDonate Then MakingDonatedTroops()

		CheckIsFullQueuedAndNotFullArmy()
		If $g_bRunState = False Then Return
		CheckIsEmptyQueuedAndNotFullArmy()
		If $g_bRunState = False Then Return
		If $g_bFirstStart Then $g_bFirstStart = False
	EndIf

	ClickP($aAway, 2, 0, "#0346") ;Click Away
	If _Sleep(1000) Then Return ; Delay AFTER the click Away Prevents lots of coc restarts
	SetLog(" - Army Window Closed!", $COLOR_ACTION1)

	EndGainCost("Train")

	checkAttackDisable($g_iTaBChkIdle) ; Check for Take-A-Break after opening train page

EndFunc   ;==>TrainRevamp

Func CheckCamp($NeedOpenArmy = False, $CloseCheckCamp = False)
	If $NeedOpenArmy Then
		OpenArmyWindow()
		If _Sleep(500) Then Return
	EndIf

	Local $ReturnCamp = TestMaxCamp()

	If $ReturnCamp = 1 Then
		OpenTrainTabNumber($QuickTrainTAB, "CheckCamp()")
		If _Sleep(1000) Then Return
		TrainArmyNumber($g_iQuickTrainArmyNum)
		If _Sleep(700) Then Return
	EndIf
	If $ReturnCamp = 0 Then
		; The number of troops is not correct
		; Just in case!!
		CheckIsFullQueuedAndNotFullArmy()
		CheckIsEmptyQueuedAndNotFullArmy()
	EndIf
	If $CloseCheckCamp Then
		ClickP($aAway, 2, 0, "#0346") ;Click Away
		If _Sleep(250) Then Return
	EndIf
EndFunc   ;==>CheckCamp

Func TestMaxCamp()
	Local $ToReturn = 0
	If ISArmyWindow(False, $TrainTroopsTAB) = False Then OpenTrainTabNumber($TrainTroopsTAB, "TestMaxCamp()")
	If _Sleep(250) Then Return
	Local $ArmyCamp = GetOCRCurrent(48, 160)
	If UBound($ArmyCamp) = 3 Then
		; [2] is the [0] - [1] | Or is empty or full
		If $ArmyCamp[2] = 0 Or $ArmyCamp[0] = 0 Then
			$ToReturn = 1
		Else
			; The number of troops is not correct
			If $ArmyCamp[1] > 240 Then Setlog(" Your CoC is outdated!!! ", $COLOR_RED)
			Setlog(" - Your army is: " & $ArmyCamp[1], $COLOR_RED)
			$ToReturn = 0
		EndIf
	EndIf

	Return $ToReturn
EndFunc   ;==>TestMaxCamp

Func TrainRevampOldStyle()
	If $g_iDebugSetlogTrain = 1 Then Setlog(" - Initial Custom train Function")

	;If $bDonateTrain = -1 Then SetbDonateTrain()
	If $g_iActiveDonate = -1 Then PrepareDonateCC()

	CheckArmySpellCastel()

	;Test for Train/Donate Only and Fullarmy
	If ($g_iCommandStop = 3 Or $g_iCommandStop = 0) And $g_bFullArmy Then
		SetLog("You are in halt attack mode and your Army is prepared!", $COLOR_DEBUG) ;Debug
		If $g_bFirstStart Then $g_bFirstStart = False
		Return
	EndIf

	If ThSnipesSkiptrain() Then Return

	If $g_bRunState = False Then Return
	Local $rWhatToTrain = WhatToTrain(True) ; r in First means Result! Result of What To Train Function
	Local $rRemoveExtraTroops = RemoveExtraTroops($rWhatToTrain)

	If $rRemoveExtraTroops = 1 Or $rRemoveExtraTroops = 2 Then
		CheckArmySpellCastel()

		;Test for Train/Donate Only and Fullarmy
		If ($g_iCommandStop = 3 Or $g_iCommandStop = 0) And $g_bFullArmy Then
			SetLog("You are in halt attack mode and your Army is prepared!", $COLOR_DEBUG) ;Debug
			If $g_bFirstStart Then $g_bFirstStart = False
			Return
		EndIf

	EndIf

	If $g_bRunState = False Then Return

	If $rRemoveExtraTroops = 2 Then
		$rWhatToTrain = WhatToTrain(False, False)
		If Not ISArmyWindow(False, $TrainTroopsTAB) Then OpenTrainTabNumber($TrainTroopsTAB, "TrainRevampOldStyle()")
		TrainUsingWhatToTrain($rWhatToTrain)
	EndIf

	;If Not $rRemoveExtraTroops = 2 Then OpenTrainTabNumber($TrainTroopsTAB)

	If IsQueueEmpty($TrainTroopsTAB) Then
		If $g_bRunState = False Then Return
		If Not ISArmyWindow(False, $ArmyTAB) Then OpenTrainTabNumber($ArmyTAB, "TrainRevampOldStyle()")
		$rWhatToTrain = WhatToTrain(False, False)
		If Not ISArmyWindow(False, $TrainTroopsTAB) Then OpenTrainTabNumber($TrainTroopsTAB, "TrainRevampOldStyle()")
		TrainUsingWhatToTrain($rWhatToTrain)
	Else
		If $g_bRunState = False Then Return
		If Not ISArmyWindow(False, $ArmyTAB) Then OpenTrainTabNumber($ArmyTAB, "TrainRevampOldStyle()")
		; Local $TimeRemainTroops =  getRemainTrainTimer(756, 169) ;Get time via OCR.
		; $g_aiTimeTrain[0]  = ConvertOCRTime("Troops", $TimeRemainTroops)  ; update global array
	EndIf

	$rWhatToTrain = WhatToTrain(False, False)
	If DoWhatToTrainContainSpell($rWhatToTrain) Then
		If IsQueueEmpty($BrewSpellsTAB) Then
			TrainUsingWhatToTrain($rWhatToTrain, True)
		Else
			If Not ISArmyWindow(False, $ArmyTAB) Then OpenTrainTabNumber($ArmyTAB, "TrainRevampOldStyle()")
			; Local $TimeRemainSpells = getRemainTrainTimer(495, 315) ;Get time via OCR.
			; $g_aiTimeTrain[1] = ConvertOCRTime("Spells", $TimeRemainSpells)  ; update global array
		EndIf
	EndIf

	If _Sleep(250) Then Return
	If $g_bRunState = False Then Return
	ClickP($aAway, 2, 0, "#0346") ;Click Away
	If _Sleep(250) Then Return

	EndGainCost("Train")

	checkAttackDisable($g_iTaBChkIdle) ; Check for Take-A-Break after opening train page
EndFunc   ;==>TrainRevampOldStyle

Func CheckArmySpellCastel()

	Local $fullcastlespells = False
	Local $fullcastletroops = False

	If OpenArmyWindow() = False Then Return
	If _Sleep(250) Then Return
	If ISArmyWindow(False, $ArmyTAB) = False Then OpenTrainTabNumber($ArmyTAB, "CheckArmySpellCastel()")
	SetLog(" - Army Window Opened!", $COLOR_ACTION1)
	If _Sleep(250) Then Return
	If $g_bRunState = False Then Return
	checkArmyCamp(False, False) ; CheckExistentArmy (troops and spells)

	If $g_iDebugSetlogTrain = 1 Then $g_iDebugOcr = 1
	Local $sSpells = getArmyCampCap(99, 313) ; OCR read Spells trained and total
	Local $aGetSpellsSize = StringSplit($sSpells, "#", $STR_NOCOUNT)
	If $g_iDebugSetlogTrain = 1 Then Setlog(" - $sSpells : " & $sSpells)

	Local $scastle = getArmyCampCap(300, 468) ; OCR read Castle Received and total
	Local $aGetCastleSize = StringSplit($scastle, "#", $STR_NOCOUNT)
	If $g_iDebugSetlogTrain = 1 Then Setlog(" - $scastle : " & $scastle)
	If $g_iDebugSetlogTrain = 1 Then $g_iDebugOcr = 0

	If $g_iDebugSetlogTrain = 1 Then Setlog(" - $g_CurrentCampUtilization : " & $g_CurrentCampUtilization)
	If $g_iDebugSetlogTrain = 1 Then Setlog(" - $g_iTotalCampSpace : " & $g_iTotalCampSpace)

	$g_bFullArmySpells = False
	; Local Variable to check the occupied space by the Spells to Brew ... can be different of the Spells Factory Capacity ( $g_iTotalSpellValue )
	Local $totalCapacitySpellsToBrew = 0
	For $i = 0 To $eSpellCount - 1
		$totalCapacitySpellsToBrew += $g_aiArmyCompSpells[$i] * $g_aiSpellSpace[$i]
	Next

	If UBound($aGetSpellsSize) = 2 Then
		If $aGetSpellsSize[0] = $aGetSpellsSize[1] Or $aGetSpellsSize[0] >= $g_iTotalSpellValue Or $aGetSpellsSize[0] >= $totalCapacitySpellsToBrew Then
			$g_bFullArmySpells = True
		EndIf
	Else
		If $g_iTownHallLevel > 4 And $g_iTotalSpellValue > 0 Then
			SetLog("Error reading spells size!", $COLOR_RED)
			Return
		Else
			$g_bFullArmySpells = True
		EndIf
	EndIf

	$g_bCheckSpells = checkspells()
	If $g_bRunState = False Then Return
	$fullcastlespells = IsFullCastleSpells()
	If $g_bRunState = False Then Return
	$fullcastletroops = IsFullCastleTroops()

	If UBound($aGetCastleSize) <> 2 Then
		SetLog("Error reading Castle size")
	Else
		;Setlog(" - Army Camp: " & $g_CurrentCampUtilization & "/" & $g_iTotalCampSpace, $COLOR_GREEN) ; coc-ms
		;If $aGetSpellsSize[0] <> "" And $aGetSpellsSize[1] <> "" Then Setlog(" - Spells: " & $aGetSpellsSize[0] & "/" & $aGetSpellsSize[1], $COLOR_GREEN) ; coc-ms
		If $aGetCastleSize[0] <> "" And $aGetCastleSize[1] <> "" Then Setlog("Total Clan Castle: " & $aGetCastleSize[0] & "/" & $aGetCastleSize[1]) ; coc-ms
	EndIf

	; If Drop Trophy with Heroes is checked and a Hero is Available or under the trophies range, then set $g_bFullArmyHero to True
	If IsWaitforHeroesActive() = False And $g_bDropTrophyUseHeroes = True Then $g_bFullArmyHero = True
	If IsWaitforHeroesActive() = False And $g_bDropTrophyUseHeroes = False And $g_bFullArmyHero = False Then
		If $g_iHeroAvailable > 0 Or Number($g_aiCurrentLoot[$eLootTrophy]) <= Number($g_iDropTrophyMax) Then
			$g_bFullArmyHero = True
		Else
			Setlog("Waiting for Heroes to drop trophies!", $COLOR_ACTION)
		EndIf
	EndIf

	If (IsSearchModeActive($DB) And checkCollectors(True, False)) Or IsSearchModeActive($LB) Or IsSearchModeActive($TS) Then
		If $g_bFullArmy And $g_bCheckSpells And $g_bFullArmyHero And $fullcastlespells And $fullcastletroops Then
			$g_bIsFullArmywithHeroesAndSpells = True
			If $g_bFirstStart Then $g_bFirstStart = False
		Else
			If $g_iDebugSetlog = 1 Then
				SetLog(" $g_bFullArmy: " & String($g_bFullArmy), $COLOR_DEBUG)
				SetLog(" $g_bCheckSpells: " & String($g_bCheckSpells), $COLOR_DEBUG)
				SetLog(" $g_bFullArmyHero: " & String($g_bFullArmyHero), $COLOR_DEBUG)
				SetLog(" $fullcastlespells: " & String($fullcastlespells), $COLOR_DEBUG)
				SetLog(" $fullcastletroops: " & String($fullcastletroops), $COLOR_DEBUG)
			EndIf
			$g_bIsFullArmywithHeroesAndSpells = False
		EndIf
	Else
		If $g_iDebugSetlog = 1 Then SetLog(" Army not ready: IsSearchModeActive($DB)=" & IsSearchModeActive($DB) & ", checkCollectors(True, False)=" & checkCollectors(True, False) & ", IsSearchModeActive($LB)=" & IsSearchModeActive($LB) & ", IsSearchModeActive($TS)=" & IsSearchModeActive($TS), $COLOR_DEBUG)
		$g_bIsFullArmywithHeroesAndSpells = False
	EndIf

	Local $text = ""
	If Not $g_bFullArmy Then $text &= " Troops,"
	If Not $g_bCheckSpells Then $text &= " Spells,"
	If Not $g_bFullArmyHero Then $text &= " Heroes,"
	If Not $fullcastlespells Then $text &= " CC Spells,"
	If Not $fullcastletroops Then $text &= " CC Troops,"
	If StringRight($text, 1) = "," Then $text = StringTrimRight($text, 1) ; Remove last "," as it is not needed

	If $g_bIsFullArmywithHeroesAndSpells = True Then
		If (($g_bNotifyPBEnable = True Or $g_bNotifyTGEnable = True) And $g_bNotifyAlertCampFull = True) Then PushMsg("CampFull")
		Setlog("Chief, is your Army ready for battle? Yes, it is!", $COLOR_GREEN)
	Else
		Setlog("Chief, is your Army ready for the battle? No, not yet!", $COLOR_ACTION)
		If $text <> "" Then Setlog(" -" & $text & " are not Ready!", $COLOR_ACTION)
	EndIf

	If $g_iDebugSetlog = 1 Then
		SetLog(" $g_bIsFullArmywithHeroesAndSpells: " & String($g_bIsFullArmywithHeroesAndSpells), $COLOR_DEBUG)
		SetLog(" $g_iTownHallLevel: " & Number($g_iTownHallLevel), $COLOR_DEBUG)
	EndIf

EndFunc   ;==>CheckArmySpellCastel

Func IsFullArmy($log = False) ;Go in Troop Tab
	If ISArmyWindow(False, $ArmyTAB) = False Then OpenTrainTabNumber($ArmyTAB, "IsFullArmy()")
	If $g_bRunState = False Then Return

	Local Const $rColorCheck = _ColorCheck(_GetPixelColor(28, 176, True), Hex(0xFFFFFF, 6), 20) And _ColorCheck(_GetPixelColor(24, 168, True), Hex(0x92C232, 6), 20)

	If $rColorCheck = True Then $g_bFullArmy = True

	Local $sArmyCamp = getArmyCampCap(110, 166) ; OCR read army trained and total
	Local $aGetArmySize = StringSplit($sArmyCamp, "#", $STR_NOCOUNT)
	If UBound($aGetArmySize) >= 2 Then
		If $log Then SetLog("Troops: " & $aGetArmySize[0] & "/" & $aGetArmySize[1], $COLOR_GREEN)
		;Test for Full Army
		$g_bFullArmy = False
		$g_CurrentCampUtilization = 0
		If $g_bTotalCampForced = False Then
			$g_CurrentCampUtilization = $aGetArmySize[0]
			$g_iTotalCampSpace = $aGetArmySize[1]
		Else
			$g_CurrentCampUtilization = $aGetArmySize[0]
			$g_iTotalCampSpace = Number($g_iTotalCampForcedValue)
		EndIf
		Local $thePercent = Number(($g_CurrentCampUtilization / $g_iTotalCampSpace) * 100, 1)
		If $thePercent >= $g_iTrainArmyFullTroopPct Then $g_bFullArmy = True
	EndIf
	Return $g_bFullArmy
EndFunc   ;==>IsFullArmy

Func IsFullSpells($log = False) ;Go in Spell Tab
	If ISArmyWindow(False, $ArmyTAB) = False Then OpenTrainTabNumber($ArmyTAB, "IsFullSpells()")
	If $g_bRunState = False Then Return

	Local $sSpells = getArmyCampCap(99, 313) ; OCR read Spells trained and total
	Local $aGetSpellsSize = StringSplit($sSpells, "#", $STR_NOCOUNT)

	$g_bFullArmySpells = False
	If UBound($aGetSpellsSize) = 2 Then
		If $log Then SetLog("Spells: " & $aGetSpellsSize[0] & "/" & $aGetSpellsSize[1], $COLOR_GREEN)
		If $aGetSpellsSize[0] = $aGetSpellsSize[1] Or $aGetSpellsSize[0] >= $g_iTotalSpellValue Or $aGetSpellsSize[0] >= TotalSpellsToBrewInGUI() Then
			$g_bFullArmySpells = True
			Return True
		EndIf
	Else
		SetLog("Error reading Spells size")
		Return
	EndIf

	If $aGetSpellsSize[0] = $g_iTotalSpellValue Then
		$g_bFullArmySpells = True
		Return True
	EndIf

	Return $g_bFullArmySpells
EndFunc   ;==>IsFullSpells

Func checkspells()
	Local $ToReturn = False
	If $g_bRunState = False Then Return

	If ($g_abSearchSpellsWaitEnable[$DB] = False And $g_abSearchSpellsWaitEnable[$LB] = False) Or ($g_bFullArmySpells And ($g_abSearchSpellsWaitEnable[$DB] Or $g_abSearchSpellsWaitEnable[$LB])) Then
		$ToReturn = True
		Return $ToReturn
	EndIf

	$ToReturn = (IIf($g_abAttackTypeEnable[$DB], IIf($g_abSearchSpellsWaitEnable[$DB], $g_bFullArmySpells, True), 1) And IIf($g_abAttackTypeEnable[$LB], IIf($g_abSearchSpellsWaitEnable[$LB], $g_bFullArmySpells, True), 1))

	Return $ToReturn
EndFunc   ;==>checkspells

Func IsFullCastleSpells($returnOnly = False)
	Local $CCSpellFull = False
	Local $ToReturn = False
	If $g_bRunState = False Then Return
	If $g_abSearchCastleSpellsWaitEnable[$DB] = False And $g_abSearchCastleSpellsWaitEnable[$LB] = False Then
		$ToReturn = True
		If $returnOnly = False Then
			Return $ToReturn
		Else
			Return ""
		EndIf
	EndIf

	Local $sTempCCSpells = getArmyCampCap(527, 438 + $g_iMidOffsetY)
	Local $iCurCCSpell, $iMaxCCSpell
	If $g_iDebugSetlogTrain Then setlog("CCSpells OCR string: " & $sTempCCSpells)
	If $sTempCCSpells <> "" Then
		Local $aTempCCSpells = StringSplit($sTempCCSpells, "#", $STR_NOCOUNT)
		$iCurCCSpell = $aTempCCSpells[0]
		$iMaxCCSpell = $aTempCCSpells[1]
		Setlog("Total Clan Castle Spells: " & $aTempCCSpells[0] & "/" & $aTempCCSpells[1])
	Else
		Setlog("Castle Spells unavailable!", $COLOR_INFO)
		$iMaxCCSpell = 0
		$iCurCCSpell = 0
		$CCSpellFull = True
		Return True
	EndIf


	If $iCurCCSpell = $iMaxCCSpell Then $CCSpellFull = True
	Local $rColCheckFullCCTroops = False


	; Verifying if was checked 'wait for' Castle Spells on Dead Base and Alive Bases only when the previous capacity OCR was Full
	$ToReturn = (IIf($g_abAttackTypeEnable[$DB], IIf($g_abSearchCastleSpellsWaitEnable[$DB], $CCSpellFull, True), 1) And IIf($g_abAttackTypeEnable[$LB], IIf($g_abSearchCastleSpellsWaitEnable[$LB], $CCSpellFull, True), 1))
	If $g_iDebugSetlogTrain Then Setlog("Is necessary proceed with Castle Spells detection? " & $ToReturn, $COLOR_DEBUG)

	If $ToReturn = True Then
		If $g_iDebugSetlogTrain Then Setlog("Getting current available spell in clan castle.")
		; Imgloc Detection
		Local $CurCCSpell1 = "", $CurCCSpell2 = ""
		If $iMaxCCSpell < 3 Then $CurCCSpell1 = GetCurCCSpell(1)
		If $iMaxCCSpell > 1 Then $CurCCSpell2 = GetCurCCSpell(2)

		; If the OCR gives > 0 and the Imgloc empty will proceeds with an error!
		If $CurCCSpell1 = "" And $iCurCCSpell > 0 Then
			If $returnOnly = False Then
				SetLog("Failed to get current available spell in clan castle", $COLOR_ERROR)
				$ToReturn = False
				Return $ToReturn
			Else
				Return ""
			EndIf
		EndIf

		; Compare the detection with the GUI selection
		; Local $aShouldRemove will store in an array [0]=slot 1 and [1]=slot 2 the spells to remove
		Local $aShouldRemove[2] = [0, 0]
		$aShouldRemove = CompareCCSpellWithGUI($CurCCSpell1, $CurCCSpell2, $iMaxCCSpell)

		; Debug
		If $iMaxCCSpell > 1 Then
			If $g_iDebugSetlogTrain Then Setlog(" ?? Slot 1 to remove: " & $aShouldRemove[0])
			If $g_iDebugSetlogTrain Then Setlog(" ?? Slot 2 to remove: " & $aShouldRemove[1])
		Else
			If $g_iDebugSetlogTrain Then Setlog(" ?? Slot 1 to remove: " & $aShouldRemove[0])
		EndIf

		If $aShouldRemove[0] > 0 Or $aShouldRemove[1] > 0 Then
			SetLog("Removing Useless Castle Spells!", $COLOR_BLUE)
			RemoveCastleSpell($aShouldRemove)
			If _Sleep(1000) Then Return
			; Check the Request Clan troops & Spells buttom
			$g_bCanRequestCC = _ColorCheck(_GetPixelColor($aRequestTroopsAO[0], $aRequestTroopsAO[1], True), Hex($aRequestTroopsAO[2], 6), $aRequestTroopsAO[5])
			; Debug
			If $g_iDebugSetlogTrain Then Setlog(" ?? Clans Castle button available? " & $g_bCanRequestCC)
			; Let??s request Troops & Spells
			If $g_bCanRequestCC = True Then
				$rColCheckFullCCTroops = _ColorCheck(_GetPixelColor(24, 470, True), Hex(0x93C230, 6), 30)
				If $rColCheckFullCCTroops = True Then SetLog("Clan Castle Spell is empty, Requesting for...")
				If $returnOnly = False Then
					RequestCC(False, IIf($rColCheckFullCCTroops = True Or ($g_abSearchCastleTroopsWaitEnable[$DB] = False And $g_abSearchCastleTroopsWaitEnable[$LB] = False), IIf($g_abSearchCastleSpellsWaitEnable[$LB], IIf(String(GUICtrlRead($g_hCmbABWaitForCastleSpell)) = "Any", "", String(GUICtrlRead($g_hCmbABWaitForCastleSpell) & " Spell")), IIf($g_abSearchCastleSpellsWaitEnable[$DB], IIf(String(GUICtrlRead($g_hCmbDBWaitForCastleSpell)) = "Any", "", String(GUICtrlRead($g_hCmbDBWaitForCastleSpell) & " Spell")), "")), ""))
				Else
					$ToReturn = IIf($rColCheckFullCCTroops = True Or ($g_abSearchCastleTroopsWaitEnable[$DB] = False And $g_abSearchCastleTroopsWaitEnable[$LB] = False), IIf($g_abSearchCastleSpellsWaitEnable[$LB], IIf(String(GUICtrlRead($g_hCmbABWaitForCastleSpell)) = "Any", "", String(GUICtrlRead($g_hCmbABWaitForCastleSpell) & " Spell")), IIf($g_abSearchCastleSpellsWaitEnable[$DB], IIf(String(GUICtrlRead($g_hCmbDBWaitForCastleSpell)) = "Any", "", String(GUICtrlRead($g_hCmbDBWaitForCastleSpell) & " Spell")), "")), "")
					Return $ToReturn
				EndIf
			EndIf
			$ToReturn = False
		EndIf
	Else
		$g_bCanRequestCC = _ColorCheck(_GetPixelColor($aRequestTroopsAO[0], $aRequestTroopsAO[1], True), Hex($aRequestTroopsAO[2], 6), $aRequestTroopsAO[5])
		If $g_bCanRequestCC = True Then
			$rColCheckFullCCTroops = _ColorCheck(_GetPixelColor(24, 470, True), Hex(0x93C230, 6), 30)
			If $rColCheckFullCCTroops = True Then SetLog("Clan Castle Spell is empty, Requesting for...")
			If $returnOnly = False Then
				RequestCC(False, IIf($rColCheckFullCCTroops = True Or ($g_abSearchCastleTroopsWaitEnable[$DB] = False And $g_abSearchCastleTroopsWaitEnable[$LB] = False), IIf($g_abSearchCastleSpellsWaitEnable[$LB], IIf(String(GUICtrlRead($g_hCmbABWaitForCastleSpell)) = "Any", "", String(GUICtrlRead($g_hCmbABWaitForCastleSpell) & " Spell")), IIf($g_abSearchCastleSpellsWaitEnable[$DB], IIf(String(GUICtrlRead($g_hCmbDBWaitForCastleSpell)) = "Any", "", String(GUICtrlRead($g_hCmbDBWaitForCastleSpell) & " Spell")), "")), ""))
			Else
				$ToReturn = IIf($rColCheckFullCCTroops = True Or ($g_abSearchCastleTroopsWaitEnable[$DB] = False And $g_abSearchCastleTroopsWaitEnable[$LB] = False), IIf($g_abSearchCastleSpellsWaitEnable[$LB], IIf(String(GUICtrlRead($g_hCmbABWaitForCastleSpell)) = "Any", "", String(GUICtrlRead($g_hCmbABWaitForCastleSpell) & " Spell")), IIf($g_abSearchCastleSpellsWaitEnable[$DB], IIf(String(GUICtrlRead($g_hCmbDBWaitForCastleSpell)) = "Any", "", String(GUICtrlRead($g_hCmbDBWaitForCastleSpell) & " Spell")), "")), "")
				Return $ToReturn
			EndIf
		EndIf
	EndIf
	If $returnOnly = False Then
		Return $ToReturn
	Else
		Return ""
	EndIf
EndFunc   ;==>IsFullCastleSpells

Func RemoveCastleSpell($Slots)

	If $Slots[0] = 0 And $Slots[1] = 0 Then Return

	If _ColorCheck(_GetPixelColor(806, 472, True), Hex(0xD0E878, 6), 25) = False Then ; If no 'Edit Army' Button found in army tab to edit troops
		SetLog("Cannot find/verify 'Edit Army' Button in Army tab", $COLOR_ORANGE)
		Return False ; Exit function
	EndIf

	Click(Random(723, 812, 1), Random(469, 513, 1)) ; Click on Edit Army Button
	If $g_bRunState = False Then Return

	If _Sleep(500) Then Return

	Local $pos[2] = [575, 575], $pos2[2] = [645, 575]

	If $Slots[0] > 0 Then
		ClickRemoveTroop($pos, $Slots[0], $g_iTrainClickDelay) ; Click on Remove button as much as needed
	EndIf
	If $Slots[1] > 0 Then
		ClickRemoveTroop($pos2, $Slots[1], $g_iTrainClickDelay)
	EndIf

	If _Sleep(400) Then Return

	If _ColorCheck(_GetPixelColor(806, 561, True), Hex(0xD0E878, 6), 25) = False Then ; If no 'Okay' button found in army tab to save changes
		SetLog("Cannot find/verify 'Okay' Button in Army tab", $COLOR_ORANGE)
		ClickP($aAway, 2, 0, "#0346") ; Click Away, Necessary! due to possible errors/changes
		If _Sleep(400) Then OpenArmyWindow() ; Open Army Window AGAIN
		Return False ; Exit Function
	EndIf

	If _Sleep(700) Then Return

	Click(Random(720, 815, 1), Random(558, 589, 1)) ; Click on 'Okay' button to save changes

	If _Sleep(1200) Then Return

	If _ColorCheck(_GetPixelColor(508, 428, True), Hex(0xFFFFFF, 6), 30) = False Then ; If no 'Okay' button found to verify that we accept the changes
		SetLog("Cannot find/verify 'Okay #2' Button in Army tab", $COLOR_ORANGE)
		ClickP($aAway, 2, 0, "#0346") ;Click Away
		Return False ; Exit function
	EndIf

	Click(Random(445, 585, 1), Random(400, 455, 1)) ; Click on 'Okay' button to Save changes... Last button

	SetLog("Clan Castle Spell Removed", $COLOR_GREEN)
	If _Sleep(200) Then Return
	Return True
EndFunc   ;==>RemoveCastleSpell

Func CompareCCSpellWithGUI($CCSpell1, $CCSpell2, $CastleCapacity)

	; $CCSpells are an array with the Detected Spell :
	; $CCSpell1[0][0] = Name , [0][1] = X , [0][2] = Y , [0][3] = Quantities
	; $CCSpell2[0][0] = Name , [0][1] = X , [0][2] = Y , [0][3] = Quantities , IS "" if was not detected or is not necessary

	If $g_iDebugSetlogTrain Then ; Just For debug
		For $i = 0 To UBound($CCSpell1, $UBOUND_COLUMNS) - 1
			Setlog("$CCSpell1[0][" & $i & "]: " & $CCSpell1[0][$i])
		Next
		If $CCSpell2 <> "" And $CastleCapacity = 2 And $CCSpell1[0][3] < 2 Then ; IF the Castle is = 2 and the previous Spell quantity was only 1
			For $i = 0 To UBound($CCSpell2, $UBOUND_COLUMNS) - 1
				Setlog("$CCSpell2[0][" & $i & "]: " & $CCSpell2[0][$i])
			Next
		EndIf
	EndIf

	; Check if Button STOP was Clicked
	If Not $g_bRunState Then Return

	; Check if Button Pause was clicked
	If _Sleep(100) Then Return

	; Variables to Fill with Spell's names
	Local $sCCSpell, $sCCSpell2, $bCheckDBCCSpell = False, $bCheckABCCSpell = False

	; Variable will be true if is necessary check the slot2 ( when the capacity is 2 and the first slot is a Dark Spell )
	Local $bCheckCCSpell2 = False

	; Variable to fill with Spell quantities to delete , 0 , 1 or 2
	Local $aShouldRemove[2] = [0, 0]

	; IF exist any error on parameter: Castle Capacity!!
	If $CastleCapacity = 0 Or $CastleCapacity = "" Then Return $aShouldRemove

	; Correct Set log and flag a Variable to use $bCheckDBCCSpell For dead bases
	If $g_abAttackTypeEnable[$DB] And $g_abSearchCastleSpellsWaitEnable[$DB] Then
		If $g_iDebugSetlogTrain Then Setlog("- Let's compare CC Spells on Dead Bases!", $COLOR_DEBUG)
		$bCheckDBCCSpell = True
	EndIf

	; Correct Set log and flag a Variable to use $bCheckABCCSpell For Alive Bases
	If $g_abAttackTypeEnable[$LB] And $g_abSearchCastleSpellsWaitEnable[$LB] Then
		If $g_iDebugSetlogTrain Then Setlog("- Let's compare CC Spells on live Bases", $COLOR_DEBUG)
		$bCheckABCCSpell = True
	EndIf

	; Just In case !!! how knows ...
	If $bCheckDBCCSpell = False And $bCheckABCCSpell = False Then Return $aShouldRemove

	For $Mode = $DB To $LB
		; Why check spells if is 'ANY' on Both , Will return [0,0]
		If BitOR($g_aiSearchCastleSpellsWaitRegular[$Mode], $g_aiSearchCastleSpellsWaitDark[$Mode]) > 0 Then
			Local $txt = "DB"
			$txt = ($Mode = $LB) ? ("LB") : ("DB")
			If $Mode = $DB And $bCheckDBCCSpell = False Then ContinueLoop ; If the DB is not selected let's go to next loop
			Switch $g_aiSearchCastleSpellsWaitRegular[$Mode]
				Case 0
					$sCCSpell = "Any"
				Case 1
					$sCCSpell = "LSpell"
				Case 2
					$sCCSpell = "HSpell"
				Case 3
					$sCCSpell = "RSpell"
				Case 4
					$sCCSpell = "JSpell"
				Case 5
					$sCCSpell = "FSpell"
				Case 6
					$sCCSpell = "PSpell"
				Case 7
					$sCCSpell = "ESpell"
				Case 8
					$sCCSpell = "HaSpell"
				Case 9
					$sCCSpell = "SkSpell"
			EndSwitch

			; Will only proceeds with 'second slot check' IF the Castle capacity is 2 and was selected a Dark Spell on Slot1
			If $g_aiSearchCastleSpellsWaitRegular[$Mode] > 5 And $CastleCapacity = 2 Then $bCheckCCSpell2 = True

			; Debug
			If $g_iDebugSetlogTrain Then Setlog("[1][" & $txt & "] GUI Spell is " & $sCCSpell, $COLOR_DEBUG)

			; If the Spell1 Match with ANY or with GUI Name than return 0 to remove
			If ($sCCSpell = $CCSpell1[0][0] Or $sCCSpell = "Any") And $CCSpell1[0][3] = 1 Then
				; Is not to remove [0,0] Slot 1
				$aShouldRemove[0] = 0
			ElseIf ($sCCSpell = $CCSpell1[0][0] Or $sCCSpell = "Any") And $CCSpell1[0][3] = 2 And ($CCSpell1[0][0] <> $CCSpell2[0][0] Or $CCSpell2[0][0] <> "Any") Then
				; Spell is the correct BUT exist 2 and doesn't match with Slot 2
				; Remove one Spell from Slot 1
				$aShouldRemove[0] = 1
			Else
				; Is to remove all coz doesn't match the name of the Spells on Slot 1
				$aShouldRemove[0] = $CCSpell1[0][3] ; $CCSpell1[0][3] is the quantity , 1 or 2
			EndIf

			If $bCheckCCSpell2 Then ; Castle Spells capacity is 2
				Switch $g_aiSearchCastleSpellsWaitDark[$Mode]
					Case 0
						$sCCSpell2 = "Any"
					Case 1
						$sCCSpell2 = "PSpell"
					Case 2
						$sCCSpell2 = "ESpell"
					Case 3
						$sCCSpell2 = "HaSpell"
					Case 4
						$sCCSpell2 = "SkSpell"
				EndSwitch

				; If exist 2 Spells on Slot1 , But Slot2 needs different Spell
				If $CCSpell1[0][3] = 2 And $sCCSpell2 <> $sCCSpell And $bCheckCCSpell2 = True Then
					Setlog("One more Dark Spell on Slot 1 than is needed!")
					$aShouldRemove[0] = 1 ; remove ONE Dark Spell of 2
				EndIf

				; Debug
				If $g_iDebugSetlogTrain Then Setlog("[2][" & $txt & "] GUI Spell is " & $sCCSpell2, $COLOR_DEBUG)

				; If the Spell2 Match with ANY or with GUI Name than return 0 to remove
				If $sCCSpell2 = $CCSpell2[0][0] Or $sCCSpell2 = "Any" Or ($sCCSpell2 = $sCCSpell And $CCSpell1[0][3] = $CastleCapacity) Then ; If the spell on Slot 1 is = and have 2
					$aShouldRemove[1] = 0 ; Is not to remove [0,0] Slot 2
				Else
					$aShouldRemove[1] = $CCSpell2[0][3] ; is to remove coz doesn't match the name of the Spells on Slot 1 ($aShouldRemove[0]) $CCSpell1[0][3] is the quantity , 1 or 2
				EndIf
			EndIf
			ExitLoop ; Is Only necessary loop once ...
		EndIf
	Next

	Return $aShouldRemove

EndFunc   ;==>CompareCCSpellWithGUI

Func GetCurCCSpell($SpellNr)
	If $g_bRunState = False Then Return
	Local $directory = @ScriptDir & "\imgxml\ArmySpells"
	Local $x1 = 0, $x2 = 0, $y1 = 0, $y2 = 0
	If $SpellNr = 1 Then
		$x1 = 508
		$x2 = 587
		$y1 = 500
		$y2 = 570
	ElseIf $SpellNr = 2 Then
		$x1 = 587
		$x2 = 660
		$y1 = 500
		$y2 = 570
	Else
		If $g_iDebugSetlog = 1 Then SetLog("GetCurCCSpell() called with the wrong argument!", $COLOR_ERROR)
		Return
	EndIf
	Local $res = SearchArmy($directory, $x1, $y1, $x2, $y2, "CCSpells", True)
	If ValidateSearchArmyResult($res) Then
		For $i = 0 To UBound($res) - 1
			Setlog(" - " & $g_asSpellNames[TroopIndexLookup($res[$i][0], "GetCurCCSpell") - $eLSpell], $COLOR_GREEN)
		Next
		Return $res
	EndIf
	Return ""
EndFunc   ;==>GetCurCCSpell

Func IsFullCastleTroops()
	Local $ToReturn = False
	If $g_bRunState = False Then Return
	If $g_abSearchCastleTroopsWaitEnable[$DB] = False And $g_abSearchCastleTroopsWaitEnable[$LB] = False Then
		$ToReturn = True
		Return $ToReturn
	EndIf

	Local Const $rColCheck = _ColorCheck(_GetPixelColor(24, 470, True), Hex(0x93C230, 6), 30)

	$ToReturn = (IIf($g_abAttackTypeEnable[$DB], IIf($g_abSearchCastleTroopsWaitEnable[$DB], $rColCheck, True), 1) And IIf($g_abAttackTypeEnable[$LB], IIf($g_abSearchCastleTroopsWaitEnable[$LB], $rColCheck, True), 1))

	Return $ToReturn
EndFunc   ;==>IsFullCastleTroops

Func TrainUsingWhatToTrain($rWTT, $SpellsOnly = False)
	If $g_bRunState = False Then Return

	If UBound($rWTT) = 1 And $rWTT[0][0] = "Arch" And $rWTT[0][1] = 0 Then ; If was default Result of WhatToTrain
		Return True
	EndIf

	If $SpellsOnly = False Then
		If ISArmyWindow(False, $TrainTroopsTAB) = False Then OpenTrainTabNumber($TrainTroopsTAB, "TrainUsingWhatToTrain()")
	Else
		If ISArmyWindow(False, $BrewSpellsTAB) = False Then OpenTrainTabNumber($BrewSpellsTAB, "TrainUsingWhatToTrain()")
	EndIf
	; Loop through needed troops to Train
	Select
		Case $g_bIsFullArmywithHeroesAndSpells = False
			For $i = 0 To (UBound($rWTT) - 1)
				If $g_bRunState = False Then Return
				If $rWTT[$i][1] > 0 Then ; If Count to Train Was Higher Than ZERO
					If IsSpellToBrew($rWTT[$i][0]) Then
						BrewUsingWhatToTrain($rWTT[$i][0], $rWTT[$i][1])
						ContinueLoop
					Else
						If $SpellsOnly = True Then ContinueLoop
					EndIf
					Local $NeededSpace = CalcNeededSpace($rWTT[$i][0], $rWTT[$i][1])
					Local $LeftSpace = LeftSpace()
					If $g_bRunState = False Then Return
					If $NeededSpace <= $LeftSpace Then ; If Needed Space was Equal Or Lower Than Left Space
						If DragIfNeeded($rWTT[$i][0]) = False Then
							Return False
						EndIf

						Local $iTroopIndex = TroopIndexLookup($rWTT[$i][0], "TrainUsingWhatToTrain#1")

						Local $sTroopName = ($rWTT[$i][1] > 1 ? $g_asTroopNamesPlural[$iTroopIndex] : $g_asTroopNames[$iTroopIndex])
						If CheckValuesCost($rWTT[$i][0], $rWTT[$i][1]) Then
							SetLog("Training " & $rWTT[$i][1] & "x " & $sTroopName, $COLOR_GREEN)
							TrainIt($iTroopIndex, $rWTT[$i][1], $g_iTrainClickDelay)
						Else
							SetLog("No resources to Train " & $rWTT[$i][1] & "x " & $sTroopName, $COLOR_ORANGE)
							$g_bOutOfElixir = True
						EndIf
					Else ; If Needed Space was Higher Than Left Space
						Local $CountToTrain = 0
						Local $CanAdd = True
						Do
							$NeededSpace = CalcNeededSpace($rWTT[$i][0], $CountToTrain)
							If $NeededSpace <= $LeftSpace Then
								$CountToTrain += 1
							Else
								$CanAdd = False
							EndIf
						Until $CanAdd = False
						If $CountToTrain > 0 Then
							If DragIfNeeded($rWTT[$i][0]) = False Then
								Return False
							EndIf
						EndIf

						Local $iTroopIndex = TroopIndexLookup($rWTT[$i][0], "TrainUsingWhatToTrain#2")

						Local $sTroopName = ($CountToTrain > 1 ? $g_asTroopNamesPlural[$iTroopIndex] : $g_asTroopNames[$iTroopIndex])
						If CheckValuesCost($rWTT[$i][0], $CountToTrain) Then
							SetLog("Training " & $CountToTrain & "x " & $sTroopName, $COLOR_GREEN)
							TrainIt($iTroopIndex, $CountToTrain, $g_iTrainClickDelay)
						Else
							SetLog("No resources to Train " & $CountToTrain & "x " & $sTroopName, $COLOR_ORANGE)
							$g_bOutOfElixir = True
						EndIf
					EndIf
				EndIf
			Next
		Case $g_bIsFullArmywithHeroesAndSpells = True
			For $i = 0 To (UBound($rWTT) - 1)
				If $g_bRunState = False Then Return
				If $rWTT[$i][1] > 0 Then ; If Count to Train Was Higher Than ZERO
					If IsSpellToBrew($rWTT[$i][0]) Then
						BrewUsingWhatToTrain($rWTT[$i][0], $rWTT[$i][1])
						ContinueLoop
					Else
						If $SpellsOnly = True Then ContinueLoop
					EndIf
					Local $NeededSpace = CalcNeededSpace($rWTT[$i][0], $rWTT[$i][1])
					Local $LeftSpace = LeftSpace(True)
					If $g_bRunState = False Then Return
					$LeftSpace = ($LeftSpace[1] * 2) - $LeftSpace[0]
					If $NeededSpace <= $LeftSpace Then ; If Needed Space was Equal Or Lower Than Left Space
						If DragIfNeeded($rWTT[$i][0]) = False Then
							Return False
						EndIf

						Local $iTroopIndex = TroopIndexLookup($rWTT[$i][0], "TrainUsingWhatToTrain#3")

						Local $sTroopName = ($rWTT[$i][1] > 1 ? $g_asTroopNamesPlural[$iTroopIndex] : $g_asTroopNames[$iTroopIndex])
						If CheckValuesCost($rWTT[$i][0], $rWTT[$i][1]) Then
							SetLog("Training " & $rWTT[$i][1] & "x " & $sTroopName, $COLOR_GREEN)
							TrainIt($iTroopIndex, $rWTT[$i][1], $g_iTrainClickDelay)
						Else
							SetLog("No resources to Train " & $rWTT[$i][1] & "x " & $sTroopName, $COLOR_ORANGE)
							$g_bOutOfElixir = True
						EndIf
					Else ; If Needed Space was Higher Than Left Space
						Local $CountToTrain = 0
						Local $CanAdd = True
						Do
							$NeededSpace = CalcNeededSpace($rWTT[$i][0], $CountToTrain)
							If $NeededSpace <= $LeftSpace Then
								$CountToTrain += 1
							Else
								$CanAdd = False
							EndIf
						Until $CanAdd = False
						If $CountToTrain > 0 Then
							If DragIfNeeded($rWTT[$i][0]) = False Then
								Return False
							EndIf
						EndIf

						Local $iTroopIndex = TroopIndexLookup($rWTT[$i][0], "TrainUsingWhatToTrain#4")

						Local $sTroopName = ($CountToTrain > 1 ? $g_asTroopNamesPlural[$iTroopIndex] : $g_asTroopNames[$iTroopIndex])
						If CheckValuesCost($rWTT[$i][0], $CountToTrain) Then
							SetLog("Training " & $CountToTrain & "x " & $sTroopName, $COLOR_GREEN)
							TrainIt($iTroopIndex, $CountToTrain, $g_iTrainClickDelay)
						Else
							SetLog("No resources to Train " & $CountToTrain & "x " & $sTroopName, $COLOR_ORANGE)
							$g_bOutOfElixir = True
						EndIf
					EndIf
				EndIf
			Next
	EndSelect

	Return True
EndFunc   ;==>TrainUsingWhatToTrain

Func BrewUsingWhatToTrain($Spell, $Quantity) ; it's job is a bit different with 'TrainUsingWhatToTrain' Function, It's being called by TrainusingWhatToTrain Func
	Local $iSpellIndex = TroopIndexLookup($Spell, "BrewUsingWhatToTrain")
	Local $sSpellName = $g_asSpellNames[$iSpellIndex - $eLSpell]

	If $Quantity <= 0 Then Return False
	If $Quantity = 9999 Then
		SetLog("Brewing " & $sSpellName & " Spell Cancelled " & @CRLF & _
				"                  Reason: Enough as set in GUI " & @CRLF & _
				"                               This Spell not used in Attack")
		Return True
	EndIf
	If $g_bRunState = False Then Return
	If ISArmyWindow(False, $BrewSpellsTAB) = False Then OpenTrainTabNumber($BrewSpellsTAB, "BrewUsingWhatToTrain()")

	;If IsQueueEmpty(-1, True) = False Then Return True
	Select
		Case $g_bIsFullArmywithHeroesAndSpells = False
			If _ColorCheck(_GetPixelColor(230, 208, True), Hex(0x677CB5, 6), 30) = False Then RemoveExtraTroopsQueue()
			Local $NeededSpace = CalcNeededSpace($Spell, $Quantity)
			Local $LeftSpace = LeftSpace()
			If $g_bRunState = False Then Return
			If $NeededSpace <= $LeftSpace Then ; If Needed Space was Equal Or Lower Than Left Space
				If CheckValuesCost($Spell, $Quantity) Then
					SetLog("Brewing " & $Quantity & "x " & $sSpellName & ($Quantity > 1 ? " Spells" : " Spell"), $COLOR_GREEN)
					TrainIt($iSpellIndex, $Quantity, $g_iTrainClickDelay)
				Else
					SetLog("No resources to Brew " & $Quantity & "x " & $sSpellName & ($Quantity > 1 ? " Spells" : " Spell"), $COLOR_ORANGE)
					$g_bOutOfElixir = True
				EndIf

			EndIf
		Case $g_bIsFullArmywithHeroesAndSpells = True
			Local $NeededSpace = CalcNeededSpace($Spell, $Quantity)
			Local $LeftSpace = LeftSpace(True)
			If $g_bRunState = False Then Return
			$LeftSpace = ($LeftSpace[1] * 2) - $LeftSpace[0]
			If $NeededSpace <= $LeftSpace Then ; If Needed Space was Equal Or Lower Than Left Space
				If CheckValuesCost($Spell, $Quantity) Then
					SetLog("Brewing " & $Quantity & "x " & $sSpellName & ($Quantity > 1 ? " Spells" : " Spell"), $COLOR_GREEN)
					TrainIt($iSpellIndex, $Quantity, $g_iTrainClickDelay)
				Else
					SetLog("No resources to Brew " & $Quantity & "x " & $sSpellName & ($Quantity > 1 ? " Spells" : " Spell"), $COLOR_ORANGE)
					$g_bOutOfElixir = True
				EndIf
			EndIf
	EndSelect
EndFunc   ;==>BrewUsingWhatToTrain

Func TotalSpellsToBrewInGUI()
	Local $ToReturn = 0
	If $g_iTotalSpellValue = 0 Then Return $ToReturn
	If $g_bRunState = False Then Return
	For $i = 0 To $eSpellCount - 1
		$ToReturn += $g_aiArmyCompSpells[$i] * $g_aiSpellSpace[$i]
	Next
	Return $ToReturn
EndFunc   ;==>TotalSpellsToBrewInGUI

Func HowManyTimesWillBeUsed($Spell) ;ONLY ONLY ONLY FOR SPELLS, TO SEE IF NEEDED TO BREW, DON'T USE IT TO GET EXACT COUNT
	Local $ToReturn = -1
	If $g_bRunState = False Then Return

	If $g_bForceBrewSpells = True Then ; If Force Brew Spells Before Attack Is Enabled
		$ToReturn = 2
		Return $ToReturn
	EndIf

	; Code For DeadBase
	If $g_abAttackTypeEnable[$DB] Then
		If $g_aiAttackAlgorithm[$DB] = 1 Then ; Scripted Attack is Selected
			If IsGUICheckedForSpell($Spell, $DB) Then
				$ToReturn = CountCommandsForSpell($Spell, $DB)
				If $ToReturn = 0 Then $ToReturn = -1
			Else ; Spell not selected to be used in GUI so bot will not use Spell
				$ToReturn = -1
			EndIf
		Else ; Scripted Attack is NOT selected, And Starndard attacks not using Spells YET So The spell will not be used in attack
			$ToReturn = -1
		EndIf
	EndIf

	; Code For ActiveBase
	If $g_abAttackTypeEnable[$LB] Then
		If $g_aiAttackAlgorithm[$LB] = 1 Then ; Scripted Attack is Selected
			If IsGUICheckedForSpell($Spell, $LB) Then
				$ToReturn = CountCommandsForSpell($Spell, $LB)
				If $ToReturn = 0 Then $ToReturn = -1
			EndIf
		EndIf
	EndIf

	Return $ToReturn
EndFunc   ;==>HowManyTimesWillBeUsed

Func CountCommandsForSpell($Spell, $Mode)
	Local $ToReturn = 0
	Local $filename = ""
	If $g_bRunState = False Then Return
	If $Mode = $DB Then
		$filename = $g_sAttackScrScriptName[$DB]
	Else
		$filename = $g_sAttackScrScriptName[$LB]
	EndIf

	Local $rownum = 0
	If FileExists($g_sCSVAttacksPath & "\" & $filename & ".csv") Then
		Local $f, $line, $acommand, $command
		Local $value1, $Troop
		$f = FileOpen($g_sCSVAttacksPath & "\" & $filename & ".csv", 0)
		; Read in lines of text until the EOF is reached
		While 1
			$line = FileReadLine($f)
			$rownum += 1
			If @error = -1 Then ExitLoop
			$acommand = StringSplit($line, "|")
			If $acommand[0] >= 8 Then
				$command = StringStripWS(StringUpper($acommand[1]), 2)
				$Troop = StringStripWS(StringUpper($acommand[5]), 2)
				If $Troop = $Spell Then $ToReturn += 1
			EndIf
		WEnd
		FileClose($f)
	Else
		$ToReturn = 0
	EndIf
	Return $ToReturn
EndFunc   ;==>CountCommandsForSpell

Func IsGUICheckedForSpell($Spell, $Mode)
	Local $sSpell = ""
	Local $aVal = 0

	If $g_bRunState = False Then Return
	Switch TroopIndexLookup($Spell, "IsGUICheckedForSpell")
		Case $eLSpell
			$sSpell = "Light"
			$aVal = $g_abAttackUseLightSpell
		Case $eHSpell
			$sSpell = "Heal"
			$aVal = $g_abAttackUseHealSpell
		Case $eRSpell
			$sSpell = "Rage"
			$aVal = $g_abAttackUseRageSpell
		Case $eJSpell
			$sSpell = "Jump"
			$aVal = $g_abAttackUseJumpSpell
		Case $eFSpell
			$sSpell = "Freeze"
			$aVal = $g_abAttackUseFreezeSpell
		Case $ePSpell
			$sSpell = "Poison"
			$aVal = $g_abAttackUsePoisonSpell
		Case $eESpell
			$sSpell = "Earthquake"
			$aVal = $g_abAttackUseEarthquakeSpell
		Case $eHaSpell
			$sSpell = "Haste"
			$aVal = $g_abAttackUseHasteSpell
	EndSwitch

	If IsArray($aVal) Then Return $aVal[$Mode]
	Return False
EndFunc   ;==>IsGUICheckedForSpell

Func DragIfNeeded($Troop)

	If $g_bRunState = False Then Return
	Local $rCheckPixel = False

	If IsDarkTroop($Troop) Then
		If _ColorCheck(_GetPixelColor(834, 403, True), Hex(0xD3D3CB, 6), 5) Then $rCheckPixel = True
		If $g_iDebugSetlogTrain Then Setlog("DragIfNeeded Dark Troops: " & $rCheckPixel)
		For $i = 1 To 3
			If $rCheckPixel = False Then
				ClickDrag(715, 445 + $g_iMidOffsetY, 220, 445 + $g_iMidOffsetY, 2000)
				If _Sleep(1500) Then Return
				If _ColorCheck(_GetPixelColor(834, 403, True), Hex(0xD3D3CB, 6), 5) Then $rCheckPixel = True
			Else
				Return True
			EndIf
		Next
	Else
		If _ColorCheck(_GetPixelColor(22, 403, True), Hex(0xD3D3CB, 6), 5) Then $rCheckPixel = True
		If $g_iDebugSetlogTrain Then Setlog("DragIfNeeded Normal Troops: " & $rCheckPixel)
		For $i = 1 To 3
			If $rCheckPixel = False Then
				ClickDrag(220, 445 + $g_iMidOffsetY, 725, 445 + $g_iMidOffsetY, 2000)
				If _Sleep(1500) Then Return
				If _ColorCheck(_GetPixelColor(22, 403, True), Hex(0xD3D3CB, 6), 5) Then $rCheckPixel = True
			Else
				Return True
			EndIf
		Next
	EndIf
	SetLog("Failed to Verify Troop " & $g_asTroopNames[TroopIndexLookup($Troop, "DragIfNeeded")] & " Position or Failed to Drag Successfully", $COLOR_RED)
	Return False
EndFunc   ;==>DragIfNeeded

Func DoWhatToTrainContainSpell($rWTT)
	For $i = 0 To (UBound($rWTT) - 1)
		If $g_bRunState = False Then Return
		If IsSpellToBrew($rWTT[$i][0]) Then
			If $rWTT[$i][1] > 0 Then Return True
		EndIf
	Next
	Return False
EndFunc   ;==>DoWhatToTrainContainSpell

Func IsElixirTroop($Troop)
	Local $iIndex = TroopIndexLookup($Troop, "IsElixirTroop")
	If $iIndex >= $eBarb And $iIndex <= $eMine Then Return True
	Return False
EndFunc   ;==>IsElixirTroop

Func IsDarkTroop($Troop)
	Local $iIndex = TroopIndexLookup($Troop, "IsDarkTroop")
	If $iIndex >= $eMini And $iIndex <= $eBowl Then Return True
	Return False
EndFunc   ;==>IsDarkTroop

Func IsElixirSpell($Spell)
	Local $iIndex = TroopIndexLookup($Spell, "IsElixirSpell")
	If $iIndex >= $eLSpell And $iIndex <= $eCSpell Then Return True
	Return False
EndFunc   ;==>IsElixirSpell

Func IsDarkSpell($Spell)
	Local $iIndex = TroopIndexLookup($Spell, "IsDarkSpell")
	If $iIndex >= $ePSpell And $iIndex <= $eSkSpell Then Return True
	Return False
EndFunc   ;==>IsDarkSpell

Func IsSpellToBrew($sName)
	Local $iIndex = TroopIndexLookup($sName, "IsSpellToBrew")
	If $iIndex >= $eLSpell And $iIndex <= $eSkSpell Then Return True
	Return False
EndFunc   ;==>IsSpellToBrew

Func CalcNeededSpace($Troop, $Quantity)
	If $g_bRunState = False Then Return -1

	Local $iIndex = TroopIndexLookup($Troop, "CalcNeededSpace")
	If $iIndex = -1 Then Return -1

	If $iIndex >= $eBarb And $iIndex <= $eBowl Then
		Return Number($g_aiTroopSpace[$iIndex] * $Quantity)
	EndIf

	If $iIndex >= $eLSpell And $iIndex <= $eSkSpell Then
		Return Number($g_aiSpellSpace[$iIndex - $eLSpell] * $Quantity)
	EndIf

	Return -1
EndFunc   ;==>CalcNeededSpace

Func RemoveExtraTroops($toRemove)
	Local $CounterToRemove = 0
	Local $ToReturn = 0
	; Army Window should be open and should be in Tab 'Army tab'

	; 1 Means Removed Troops without Deleting Troops Queued
	; 2 Means Removed Troops And Also Deleted Troops Queued
	; 3 Means Didn't removed troop... Everything was well

	If UBound($toRemove) = 1 And $toRemove[0][0] = "Arch" And $toRemove[0][1] = 0 Then ; If was default Result of WhatToTrain
		$ToReturn = 3
		Return $ToReturn
	EndIf

	;If $g_bIsFullArmywithHeroesAndSpells = True Or $g_bFullArmy = True Or ($g_iCommandStop = 3 Or $g_iCommandStop = 0) = True And Not $bDonateTrain Then
	If $g_bIsFullArmywithHeroesAndSpells = True Or $g_bFullArmy = True Or ($g_iCommandStop = 3 Or $g_iCommandStop = 0) = True And Not $g_iActiveDonate Then
		$ToReturn = 3
		Return $ToReturn
	EndIf

	If UBound($toRemove) > 0 Then ; If needed to remove troops
		Local $rGetSlotNumber = GetSlotNumber() ; Get all available Slot numbers with troops assigned on them
		Local $rGetSlotNumberSpells = GetSlotNumber(True) ; Get all available Slot numbers with Spells assigned on them

		; Check if Troops to remove are already in Train Tab Queue!! If was, Will Delete All Troops Queued Then Check Everything Again...
		If Not IsQueueEmpty($TrainTroopsTAB) Then
			OpenTrainTabNumber($TrainTroopsTAB, "RemoveExtraTroops()")
			For $i = 0 To (UBound($toRemove) - 1)
				If $g_bRunState = False Then Return
				If IsSpellToBrew($toRemove[$i][0]) Then ExitLoop
				$CounterToRemove += 1
				If IsAlreadyTraining($toRemove[$i][0]) Then
					SetLog($g_asTroopNames[TroopIndexLookup($toRemove[$i][0])] & " Is in Train Tab Queue By Mistake!", $COLOR_BLUE)
					DeleteQueued("Troops")
					$ToReturn = 2
				EndIf
			Next
		EndIf

		If Not IsQueueEmpty($BrewSpellsTAB) Then
			If TotalSpellsToBrewInGUI() > 0 Then
				OpenTrainTabNumber($BrewSpellsTAB, "RemoveExtraTroops()")
				For $i = $CounterToRemove To (UBound($toRemove) - 1)
					If $g_bRunState = False Then Return
					If IsAlreadyTraining($toRemove[$i][0], True) Then
						SetLog($g_asSpellNames[TroopIndexLookup($toRemove[$i][0]) - $eLSpell] & " Is in Spells Tab Queue By Mistake!", $COLOR_BLUE)
						DeleteQueued("Spells")
						$ToReturn = 2
					EndIf
				Next
			EndIf
		EndIf

		OpenTrainTabNumber($ArmyTAB, "RemoveExtraTroops()")
		$toRemove = WhatToTrain(True, False)

		$rGetSlotNumber = GetSlotNumber() ; Get all available Slot numbers with troops assigned on them
		$rGetSlotNumberSpells = GetSlotNumber(True)

		SetLog("Troops To Remove: ", $COLOR_GREEN)
		$CounterToRemove = 0
		; Loop through Troops needed to get removed Just to write some Logs
		For $i = 0 To (UBound($toRemove) - 1)
			If IsSpellToBrew($toRemove[$i][0]) Then ExitLoop
			$CounterToRemove += 1
			SetLog("  " & $g_asTroopNames[TroopIndexLookup($toRemove[$i][0])] & ": " & $toRemove[$i][1] & "x", $COLOR_GREEN)
		Next

		If TotalSpellsToBrewInGUI() > 0 Then
			If $CounterToRemove <= UBound($toRemove) Then
				SetLog("Spells To Remove: ", $COLOR_GREEN)
				For $i = $CounterToRemove To (UBound($toRemove) - 1)
					SetLog("  " & $g_asSpellNames[TroopIndexLookup($toRemove[$i][0]) - $eLSpell] & ": " & $toRemove[$i][1] & "x", $COLOR_GREEN)
				Next
			EndIf
		EndIf

		If _ColorCheck(_GetPixelColor(806, 472, True), Hex(0xD0E878, 6), 25) = False Then ; If no 'Edit Army' Button found in army tab to edit troops
			SetLog("Cannot find/verify 'Edit Army' Button in Army tab", $COLOR_ORANGE)
			Return False ; Exit function
		EndIf

		Click(Random(723, 812, 1), Random(469, 513, 1)) ; Click on Edit Army Button

		; Loop through troops needed to get removed
		$CounterToRemove = 0
		For $j = 0 To (UBound($toRemove) - 1)
			If IsSpellToBrew($toRemove[$j][0]) Then ExitLoop
			$CounterToRemove += 1
			For $i = 0 To (UBound($rGetSlotNumber) - 1) ; Loop through All available slots
				; $toRemove[$j][0] = Troop name, E.g: Barb, $toRemove[$j][1] = Quantity to remove
				If $toRemove[$j][0] = $rGetSlotNumber[$i] Then ; If $toRemove Troop Was the same as The Slot Troop
					Local $pos = GetSlotRemoveBtnPosition($i + 1) ; Get positions of - Button to remove troop
					ClickRemoveTroop($pos, $toRemove[$j][1], $g_iTrainClickDelay) ; Click on Remove button as much as needed
				EndIf
			Next
		Next

		If TotalSpellsToBrewInGUI() > 0 Then
			For $j = $CounterToRemove To (UBound($toRemove) - 1)
				For $i = 0 To (UBound($rGetSlotNumberSpells) - 1) ; Loop through All available slots
					; $toRemove[$j][0] = Troop name, E.g: Barb, $toRemove[$j][1] = Quantity to remove
					If $toRemove[$j][0] = $rGetSlotNumberSpells[$i] Then ; If $toRemove Troop Was the same as The Slot Troop
						Local $pos = GetSlotRemoveBtnPosition($i + 1, True) ; Get positions of - Button to remove troop
						ClickRemoveTroop($pos, $toRemove[$j][1], $g_iTrainClickDelay) ; Click on Remove button as much as needed
					EndIf
				Next
			Next
		EndIf

		If _Sleep(150) Then Return

		If _ColorCheck(_GetPixelColor(806, 561, True), Hex(0xD0E878, 6), 25) = False Then ; If no 'Okay' button found in army tab to save changes
			SetLog("Cannot find/verify 'Okay' Button in Army tab", $COLOR_ORANGE)
			ClickP($aAway, 2, 0, "#0346") ; Click Away, Necessary! due to possible errors/changes
			If _Sleep(400) Then OpenArmyWindow() ; Open Army Window AGAIN
			Return False ; Exit Function
		EndIf

		If _Sleep(700) Then Return
		If $g_bRunState = False Then Return
		Click(Random(720, 815, 1), Random(558, 589, 1)) ; Click on 'Okay' button to save changes

		If _Sleep(1200) Then Return

		If _ColorCheck(_GetPixelColor(508, 428, True), Hex(0xFFFFFF, 6), 30) = False Then ; If no 'Okay' button found to verify that we accept the changes
			SetLog("Cannot find/verify 'Okay #2' Button in Army tab", $COLOR_ORANGE)
			ClickP($aAway, 2, 0, "#0346") ;Click Away
			Return False ; Exit function
		EndIf

		Click(Random(445, 585, 1), Random(400, 455, 1)) ; Click on 'Okay' button to Save changes... Last button

		SetLog("All Extra troops removed", $COLOR_GREEN)
		If _Sleep(200) Then Return
		If $ToReturn = 0 Then $ToReturn = 1
	Else ; If No extra troop found
		SetLog("No extra troop to remove, Great", $COLOR_GREEN)
		$ToReturn = 3
	EndIf
	Return $ToReturn
EndFunc   ;==>RemoveExtraTroops

Func DeleteInvalidTroopInArray(ByRef $Array)
	Switch (UBound($Array, 2) > 0) ; If Array Is 2D Array
		Case True
			Local $canKeep = True
			Local $2DBound = UBound($Array, 2)
			Local $Counter = 0
			For $i = 0 To (UBound($Array) - 1)
				If $Array[$i][0] Then
					If TroopIndexLookup($Array[$i][0], "DeleteInvalidTroopInArray#1") = -1 Or $Array[$i][0] = "" Then
						$canKeep = False
					Else
						$canKeep = True
					EndIf
					If $canKeep = True Then
						For $j = 0 To (UBound($Array, 2) - 1)
							$Array[$Counter][$j] = $Array[$i][$j]
						Next
						$Counter += 1
					EndIf
				EndIf
			Next
			ReDim $Array[$Counter][$2DBound]
		Case Else
			Local $Counter = 0
			For $i = 0 To (UBound($Array) - 1)
				If TroopIndexLookup($Array[$i], "DeleteInvalidTroopInArray#2") = -1 Or $Array[$i] = "" Then
					$Array[$Counter] = $Array[$i]
					$Counter += 1
				EndIf
			Next
			ReDim $Array[$Counter]
	EndSwitch
EndFunc   ;==>DeleteInvalidTroopInArray

Func RemoveExtraTroopsQueue() ; Will remove All Extra troops in queue If there's a Low Opacity red color on them
	;Local Const $DecreaseBy = 70
	;Local $x = 834
	If $g_bIsFullArmywithHeroesAndSpells = True Then Return True

	Local Const $y = 259, $yRemoveBtn = 200, $xDecreaseRemoveBtn = 10
	Local $rColCheck = ""
	Local $Removed = False
	For $x = 834 To 58 Step -70
		If $g_bRunState = False Then Return
		$rColCheck = _ColorCheck(_GetPixelColor($x, $y, True), Hex(0xD7AFA9, 6), 20)
		If $rColCheck = True Then
			$Removed = True
			Do
				Click($x - $xDecreaseRemoveBtn, $yRemoveBtn, 2, $g_iTrainClickDelay)
				If _Sleep(20) Then Return
				$rColCheck = _ColorCheck(_GetPixelColor($x, $y, True), Hex(0xD7AFA9, 6), 20)
			Until $rColCheck = False
		ElseIf $rColCheck = False And $Removed Then
			ExitLoop
		EndIf
	Next
	Return True
EndFunc   ;==>RemoveExtraTroopsQueue

Func IsAlreadyTraining($Troop, $Spells = False)
	If $g_bRunState = False Then Return
	Select
		Case $Spells = False
			If IsQueueEmpty($TrainTroopsTAB) Then Return False ; If No troops were in Queue

			Local $QueueTroops = CheckQueueTroops(False, False) ; Get Troops that they're currently training...
			For $i = 0 To (UBound($QueueTroops) - 1)
				If $QueueTroops[$i] = $Troop Then Return True
			Next

			Return False
		Case $Spells = True
			If IsQueueEmpty($BrewSpellsTAB, False, IIf($g_bForceBrewSpells = True, False, True)) Then Return False ; If No Spells were in Queue

			Local $QueueSpells = CheckQueueSpells(False, False) ; Get Troops that they're currently training...
			For $i = 0 To (UBound($QueueSpells) - 1)
				If $QueueSpells[$i] = $Troop Then Return True
			Next

			Return False
	EndSelect

EndFunc   ;==>IsAlreadyTraining

Func IsQueueEmpty($Tab = -1, $bSkipTabCheck = False, $removeExtraTroopsQueue = True)
	Local $iArrowX, $iArrowY

	If $g_bRunState = False Then Return

	If $Tab = $TrainTroopsTAB Or $Tab = -1 Then
		$iArrowX = $aGreenArrowTrainTroops[0] ; aada82  170 218 130    | y + 3 = 6ab320 106 179 32
		$iArrowY = $aGreenArrowTrainTroops[1]
	ElseIf $Tab = $BrewSpellsTAB Then
		$iArrowX = $aGreenArrowBrewSpells[0] ; a0d077  160 208 119    | y + 3 = 74be2c 116 190 44
		$iArrowY = $aGreenArrowBrewSpells[1]
	EndIf

	If Not _ColorCheck(_GetPixelColor($iArrowX, $iArrowY, True), Hex(0xAADA82, 6), 30) And Not _ColorCheck(_GetPixelColor($iArrowX, $iArrowY + 3, True), Hex(0x6ab320, 6), 30) Then
		Return True ; Check Green Arrows at top first, if not there -> Return
	ElseIf _ColorCheck(_GetPixelColor($iArrowX, $iArrowY, True), Hex(0xAADA82, 6), 30) And _ColorCheck(_GetPixelColor($iArrowX, $iArrowY + 3, True), Hex(0x74be2c, 6), 30) And Not $removeExtraTroopsQueue Then
		Return False
	EndIf

	If $bSkipTabCheck = False Then
		If $Tab = -1 Then $Tab = $TrainTroopsTAB
		If ISArmyWindow(False, $Tab) = False Then OpenTrainTabNumber($Tab, "IsQueueEmpty()")
	EndIf

	If $g_bIsFullArmywithHeroesAndSpells = False Then
		If $removeExtraTroopsQueue Then
			If _ColorCheck(_GetPixelColor(230, 208, True), Hex(0x677CB5, 6), 30) = False Then RemoveExtraTroopsQueue()
		EndIf
	EndIf

	If _ColorCheck(_GetPixelColor(230, 208, True), Hex(0x677CB5, 6), 20) Then Return True ; If No troops were in Queue Return True
	Return False
EndFunc   ;==>IsQueueEmpty

Func ClickRemoveTroop($pos, $iTimes, $iSpeed)
	$pos[0] = Random($pos[0] - 3, $pos[0] + 10, 1)
	$pos[1] = Random($pos[1] - 5, $pos[1] + 5, 1)
	If $g_bRunState = False Then Return
	If _Sleep(400) Then Return
	If $iTimes <> 1 Then
		If FastCaptureRegion() = True Then
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

Func GetSlotRemoveBtnPosition($iSlot, $Spells = False)
	Local Const $aResult[2] = [Number((74 * $iSlot) - 4), IIf($Spells = False, 270, 417)]
	Return $aResult
EndFunc   ;==>GetSlotRemoveBtnPosition

Func GetSlotNumber($Spells = False)
	Select
		Case $Spells = False
			Local Const $Orders[19] = [$eBarb, $eArch, $eGiant, $eGobl, $eWall, $eBall, $eWiza, $eHeal, $eDrag, $ePekk, $eBabyD, $eMine, _
					$eMini, $eHogs, $eValk, $eGole, $eWitc, $eLava, $eBowl] ; Set Order of troop display in Army Tab

			Local $allCurTroops[UBound($Orders)]

			; Code for Elixir Troops to Put Current Troops into an array by Order
			For $i = 0 To $eTroopCount - 1
				If $g_bRunState = False Then Return
				If $g_aiCurrentTroops[$i] > 0 Then
					For $j = 0 To (UBound($Orders) - 1)
						If TroopIndexLookup($g_asTroopShortNames[$i], "GetSlotNumber#1") = $Orders[$j] Then
							$allCurTroops[$j] = $g_asTroopShortNames[$i]
						EndIf
					Next
				EndIf
			Next

			_ArryRemoveBlanks($allCurTroops)

			Return $allCurTroops
		Case $Spells = True

			; Set Order of Spells display in Army Tab
			Local Const $SpellsOrders[10] = [$eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell]

			Local $allCurSpells[UBound($SpellsOrders)]

			; Code for Spells to Put Current Spells into an array by Order
			For $i = 0 To $eSpellCount - 1
				If $g_bRunState = False Then Return
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

Func WhatToTrain($ReturnExtraTroopsOnly = False, $showlog = True)
	If ISArmyWindow(False, $ArmyTAB) = False Then OpenTrainTabNumber($ArmyTAB, "WhatToTrain()")
	Local $ToReturn[1][2] = [["Arch", 0]]

	If $g_bIsFullArmywithHeroesAndSpells And $ReturnExtraTroopsOnly = False Then
		If $g_iCommandStop = 3 Or $g_iCommandStop = 0 Then
			If $g_bFirstStart Then $g_bFirstStart = False
			Return $ToReturn
		EndIf
		Setlog(" - Your Army is Full, let's make troops before Attack!")
		; Elixir Troops
		For $ii = 0 To $eTroopCount - 1
			Local $troopIndex = $g_aiTrainOrder[$ii]
			;SetDebugLog($ii & ": " & $troopIndex & " " & $g_aiCurrentTroops[$troopIndex] & " " & $g_asTroopShortNames[$troopIndex] & " " & $g_aiArmyCompTroops[$troopIndex])
			If $g_aiArmyCompTroops[$troopIndex] > 0 Then
				$ToReturn[UBound($ToReturn) - 1][0] = $g_asTroopShortNames[$troopIndex]
				$ToReturn[UBound($ToReturn) - 1][1] = $g_aiArmyCompTroops[$troopIndex]
				ReDim $ToReturn[UBound($ToReturn) + 1][2]
			EndIf
		Next

		; Spells
		For $i = 0 To $eSpellCount - 1
			If $g_bRunState = False Then Return
			If TotalSpellsToBrewInGUI() = 0 Then ExitLoop
			If $g_aiArmyCompSpells[$i] > 0 Then
				If HowManyTimesWillBeUsed($g_asSpellShortNames[$i]) > 0 Then
					$ToReturn[UBound($ToReturn) - 1][0] = $g_asSpellShortNames[$i]
					$ToReturn[UBound($ToReturn) - 1][1] = $g_aiArmyCompSpells[$i]
					ReDim $ToReturn[UBound($ToReturn) + 1][2]
				Else
					CheckExistentArmy("Spells", False)
					If $g_aiArmyCompSpells[$i] - $g_aiCurrentSpells[$i] > 0 Then
						$ToReturn[UBound($ToReturn) - 1][0] = $g_asSpellShortNames[$i]
						$ToReturn[UBound($ToReturn) - 1][1] = $g_aiArmyCompSpells[$i] - $g_aiCurrentSpells[$i]
						ReDim $ToReturn[UBound($ToReturn) + 1][2]
					Else
						$ToReturn[UBound($ToReturn) - 1][0] = $g_asSpellShortNames[$i]
						$ToReturn[UBound($ToReturn) - 1][1] = 9999
						ReDim $ToReturn[UBound($ToReturn) + 1][2]
					EndIf
				EndIf
			EndIf
		Next
		Return $ToReturn
	EndIf

	; Get Current available troops
	CheckExistentArmy("Troops", $showlog) ; Update the $Cur variables
	CheckExistentArmy("Spells", $showlog) ; Update the $Cur variables

	Switch $ReturnExtraTroopsOnly
		Case False
			; Check Elixir Troops needed quantity to Train
			For $ii = 0 To $eTroopCount - 1
				Local $troopIndex = $g_aiTrainOrder[$ii]
				;SetDebugLog($ii & ": " & $troopIndex & " " & $g_aiCurrentTroops[$troopIndex] & " " & $g_asTroopShortNames[$troopIndex] & " " & $g_aiArmyCompTroops[$troopIndex])
				If $g_bRunState = False Then Return
				If $g_aiArmyCompTroops[$troopIndex] > 0 Then
					$ToReturn[UBound($ToReturn) - 1][0] = $g_asTroopShortNames[$troopIndex]
					$ToReturn[UBound($ToReturn) - 1][1] = $g_aiArmyCompTroops[$troopIndex] - $g_aiCurrentTroops[$troopIndex]
					ReDim $ToReturn[UBound($ToReturn) + 1][2]
				EndIf
			Next

			; Check Spells needed quantity to Brew
			For $i = 0 To $eSpellCount - 1
				If $g_bRunState = False Then Return
				If TotalSpellsToBrewInGUI() = 0 Then ExitLoop
				If $g_aiArmyCompSpells[$i] > 0 Then
					$ToReturn[UBound($ToReturn) - 1][0] = $g_asSpellShortNames[$i]
					$ToReturn[UBound($ToReturn) - 1][1] = $g_aiArmyCompSpells[$i] - $g_aiCurrentSpells[$i]
					ReDim $ToReturn[UBound($ToReturn) + 1][2]
				EndIf
			Next
		Case Else
			; Check Elixir Troops Extra Quantity
			For $ii = 0 To $eTroopCount - 1
				Local $troopIndex = $g_aiTrainOrder[$ii]
				If $g_bRunState = False Then Return
				;SetDebugLog($ii & ": " & $troopIndex & " " & $g_aiCurrentTroops[$troopIndex] & " " & $g_asTroopShortNames[$troopIndex] & " " & $g_aiArmyCompTroops[$troopIndex])
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
				If $g_bRunState = False Then Return
				If TotalSpellsToBrewInGUI() = 0 Then ExitLoop
				If $g_aiCurrentSpells[$i] > 0 Then
					If $g_aiArmyCompSpells[$i] - $g_aiCurrentSpells[$i] < 0 Then
						$ToReturn[UBound($ToReturn) - 1][0] = $g_asSpellShortNames[$i]
						$ToReturn[UBound($ToReturn) - 1][1] = Abs($g_aiArmyCompSpells[$i] - $g_aiCurrentSpells[$i])
						ReDim $ToReturn[UBound($ToReturn) + 1][2]
					EndIf
				EndIf
			Next
	EndSwitch
	DeleteInvalidTroopInArray($ToReturn)
	Return $ToReturn
EndFunc   ;==>WhatToTrain

Func TestTroopsCoords()
	Local $iCount = 3
	$g_bRunState = True
	For $i = 0 To $eTroopCount - 1
		DragIfNeeded($g_asTroopShortNames[$i])
		TrainIt(TroopIndexLookup($g_asTroopShortNames[$i], "TestTroopsCoords"), $iCount, $g_iTrainClickDelay)
	Next
	#CS
		TrainIt($eDrag, $iCount, 300)
		TrainIt($eBarb, $iCount, 300)
		TrainIt($eArch, $iCount, 300)
		TrainIt($eGiant, $iCount, 300)
		TrainIt($eGobl, $iCount, 300)
		TrainIt($eWall, $iCount, 300)
		TrainIt($eBall, $iCount, 300)
		TrainIt($eWiza, $iCount, 300)
		TrainIt($eHeal, $iCount, 300)
		TrainIt($eDrag, $iCount, 300)
		TrainIt($ePekk, $iCount, 300)
		TrainIt($eBabyD, $iCount, 300)
		TrainIt($eMine, $iCount, 300)
		ClickDrag(616, 445 + $g_iMidOffsetY, 400, 445 + $g_iMidOffsetY, 2000)
		If _Sleep(1500) Then Return
		TrainIt($eMini, $iCount, 300)
		TrainIt($eHogs, $iCount, 300)
		TrainIt($eValk, $iCount, 300)
		TrainIt($eGole, $iCount, 300)
		TrainIt($eWitc, $iCount, 300)
		TrainIt($eLava, $iCount, 300)
		TrainIt($eBowl, $iCount, 300)
	#CE
	$g_bRunState = False
EndFunc   ;==>TestTroopsCoords

Func TestSpellsCoords()
	$g_bRunState = True

	Local $iCount = 1
	TrainIt($eLSpell, $iCount, 300)
	TrainIt($eHSpell, $iCount, 300)
	TrainIt($eRSpell, $iCount, 300)
	TrainIt($eJSpell, $iCount, 300)
	TrainIt($eFSpell, $iCount, 300)
	TrainIt($eCSpell, $iCount, 300)
	TrainIt($ePSpell, $iCount, 300)
	TrainIt($eESpell, $iCount, 300)
	TrainIt($eHaSpell, $iCount, 300)
	TrainIt($eSkSpell, $iCount, 300)

	$g_bRunState = False
EndFunc   ;==>TestSpellsCoords

Func LeftSpace($ReturnAll = False)
	; Need to be in 'Train Tab'
	Local $RemainTrainSpace = GetOCRCurrent(48, 160)
	If $g_bRunState = False Then Return
	;_ArrayDisplay($RemainTrainSpace, "$RemainTrainSpace")
	If $ReturnAll = False Then
		Return Number($RemainTrainSpace[2])
	Else
		Return $RemainTrainSpace
	EndIf
EndFunc   ;==>LeftSpace

Func OpenArmyWindow()

	ClickP($aAway, 2, 0, "#0346") ;Click Away
	If $g_bRunState = False Then Return
	If _Sleep($DELAYRUNBOT3) Then Return ; wait for window to open
	If IsMainPage() = False Then ; check for main page, avoid random troop drop
		SetLog("Can not open Army Overview window", $COLOR_RED)
		SetError(1)
		Return False
	EndIf

	If WaitforPixel(31, 515 + $g_iBottomOffsetY, 33, 517 + $g_iBottomOffsetY, Hex(0xF8F0E0, 6), 10, 20) Then
		If _Sleep($DELAYTRAIN4) Then Return ; wait before click
		If $g_iDebugSetlogTrain = 1 Then SetLog("Click $aArmyTrainButton", $COLOR_GREEN)
		If $g_bUseRandomClick = False Then
			Click($aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0, "#0293") ; Button Army Overview
		Else
			ClickR($aArmyTrainButtonRND, $aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0)
		EndIf
	EndIf

	If _Sleep($DELAYTRAIN4) Then Return ; wait for window to open

	Local $x = 0
	While ISArmyWindow(False, $ArmyTAB) = False
		If _sleep($DELAYTRAIN4) Then Return
		$x += 1
		If $x = 5 And IsMainPage() Then
			If _Sleep($DELAYTRAIN4) Then Return ; wait before click
			If $g_iDebugSetlogTrain = 1 Then SetLog("Click $aArmyTrainButton", $COLOR_GREEN)
			If $g_bUseRandomClick = False Then
				Click($aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0, "#0293") ; Button Army Overview
			Else
				ClickR($aArmyTrainButtonRND, $aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0)
			EndIf
		EndIf

		If $x = 10 Then
			SetError(1)
			AndroidPageError("OpenArmyWindow")
			Return False ; exit if I'm not in train page
		EndIf
	WEnd

	Return True

EndFunc   ;==>OpenArmyWindow

Func ISArmyWindow($writelogs = False, $TabNumber = 0)

	Local $i = 0
	Local $_aIsTrainPgChk1[4] = [816, 136, 0xc40608, 15]
	Local $_aIsTrainPgChk2[4] = [843, 183, 0xe8e8e0, 15]
	Local $_TabNumber[4][4] = [[147, 128, 0Xf8f8f7, 15], [366, 128, 0Xf8f8f7, 15], [555, 128, 0Xf8f8f7, 15], [758, 128, 0Xf8f8f7, 15]] ; Grey pixel on the tab name when is selected

	Local $CheckIT[4] = [$_TabNumber[$TabNumber][0], $_TabNumber[$TabNumber][1], $_TabNumber[$TabNumber][2], $_TabNumber[$TabNumber][3]]

	While $i < 30
		If $g_bRunState = False Then Return
		If _CheckPixel($_aIsTrainPgChk1, True) And _CheckPixel($_aIsTrainPgChk2, True) And _CheckPixel($CheckIT, True) Then ExitLoop
		If _Sleep($DELAYISTRAINPAGE1) Then ExitLoop
		$i += 1
	WEnd

	If $i <= 28 Then
		If ($g_iDebugSetlog = 1 Or $g_iDebugClick = 1) And $writelogs = True Then Setlog("**Train Window OK**", $COLOR_DEBUG) ;Debug
		Return True
	Else
		If $writelogs = True Then SetLog("Cannot find train Window | TAB " & $TabNumber, $COLOR_RED) ; in case of $i = 29 in while loop
		If $g_iDebugImageSave = 1 Then DebugImageSave("IsTrainPage_")
		Return False
	EndIf

EndFunc   ;==>ISArmyWindow

Func CheckExistentArmy($txt = "", $showlog = True)

	If ISArmyWindow(False, $ArmyTAB) = False Then
		OpenArmyWindow()
		If _Sleep(1500) Then Return
	EndIf

	;$g_iHeroAvailable = $eHeroNone ; Reset hero available data

	If $txt = "Troops" Then
		ResetVariables("Troops")
		ResetDropTrophiesVariable()
		Local $directory = @ScriptDir & "\imgxml\ArmyTroops" ; "armytroops-bundle"
		Local $x = 23, $y = 215, $x1 = 840, $y1 = 255
	EndIf
	If $txt = "Spells" Then
		ResetVariables("Spells")
		Local $directory = @ScriptDir & "\imgxml\ArmySpells"
		Local $x = 23, $y = 366, $x1 = 585, $y1 = 400
	EndIf
	If $txt = "Heroes" Then
		Local $directory = "armyheroes-bundle"
		Local $x = 610, $y = 366, $x1 = 830, $y1 = 400
	EndIf

	Local $result = SearchArmy($directory, $x, $y, $x1, $y1, $txt)

	If UBound($result) > 0 Then
		For $i = 0 To UBound($result) - 1
			If $g_bRunState = False Then Return
			Local $Plural = 0
			If $result[$i][0] <> "" Then
				If $result[$i][3] > 1 Then $Plural = 1
				If StringInStr($result[$i][0], "queued") Then
					$result[$i][0] = StringTrimRight($result[$i][0], 6)
					;[&i][0] = Troops name | [&i][1] = X coordinate | [&i][2] = Y coordinate | [&i][3] = Quantities
					If $txt = "Troops" Then
						Local $iTroopIndex = TroopIndexLookup($result[$i][0], "CheckExistentArmy#1")

						If $showlog = True Then
							Local $sTroopName = ($Plural ? $g_asTroopNamesPlural[$iTroopIndex] : $g_asTroopNames[$iTroopIndex])
							Setlog(" - " & $result[$i][3] & " " & $sTroopName & " Queued", $COLOR_BLUE)
						EndIf

						$g_aiCurrentTroops[$iTroopIndex] += $result[$i][3]
					EndIf

					If $txt = "Spells" Then
						If $result[$i][3] = 0 Then
							If $showlog = True Then SetLog(" - No Spells are Brewed", $COLOR_BLUE)
						Else
							Local $iSpellIndex = TroopIndexLookup($result[$i][0], "CheckExistentArmy#2")

							If $showlog = True Then Setlog(" - " & $result[$i][3] & " " & $g_asSpellNames[$iSpellIndex - $eLSpell] & ($Plural ? " Spells" : " Spell") & " Brewed", $COLOR_BLUE)
							$g_aiCurrentSpells[$iSpellIndex - $eLSpell] += $result[$i][3]
						EndIf
					EndIf

					If $txt = "Heroes" Then
						Local $iHeroIndex = TroopIndexLookup($result[$i][0], "CheckExistentArmy#3")
						If ArmyHeroStatus($iHeroIndex) = "heal" Then Setlog("  " & $g_asHeroNames[$iHeroIndex - $eKing] & " Recovering, Remain of " & $result[$i][3], $COLOR_BLUE)
					EndIf
				Else
					If $txt = "Heroes" Then
						If $showlog = True Then Setlog(" - " & $g_asHeroNames[TroopIndexLookup($result[$i][0], "CheckExistentArmy#4") - $eKing] & " Recovered", $COLOR_GREEN)

					ElseIf $txt = "Troops" Then
						;ResetDropTrophiesVariable()
						Local $iTroopIndex = TroopIndexLookup($result[$i][0], "CheckExistentArmy#5")

						If $showlog = True Then
							Local $sTroopName = ($Plural ? $g_asTroopNamesPlural[$iTroopIndex] : $g_asTroopNames[$iTroopIndex])
							Setlog(" - " & $result[$i][3] & " " & $sTroopName & " Available", $COLOR_GREEN)
						EndIf

						$g_aiCurrentTroops[$iTroopIndex] += $result[$i][3]
						CanBeUsedToDropTrophies($iTroopIndex, $g_aiCurrentTroops[$iTroopIndex])

					Else
						If $result[$i][3] = 0 Then
							If $showlog = True Then SetLog(" - No Spells are Brewed", $COLOR_GREEN)
						Else
							Local $iSpellIndex = TroopIndexLookup($result[$i][0], "CheckExistentArmy#6")

							If $showlog = True Then Setlog(" - " & $result[$i][3] & " " & $g_asSpellNames[$iSpellIndex - $eLSpell] & ($Plural ? " Spells" : " Spell") & " Brewed", $COLOR_GREEN)
							$g_aiCurrentSpells[$iSpellIndex - $eLSpell] += $result[$i][3]
						EndIf
					EndIf
				EndIf
			EndIf
		Next
	EndIf
EndFunc   ;==>CheckExistentArmy

Func CanBeUsedToDropTrophies($eTroop, $Quantity)
	;SetLog("CanBeUsedToDrop|$eTroop = " & $eTroop & @CRLF & "Quantity = " & $Quantity)
	If $eTroop = $eBarb Then
		$g_avDTtroopsToBeUsed[0][1] = $Quantity

	ElseIf $eTroop = $eArch Then
		$g_avDTtroopsToBeUsed[1][1] = $Quantity

	ElseIf $eTroop = $eGiant Then
		$g_avDTtroopsToBeUsed[2][1] = $Quantity

	ElseIf $eTroop = $eGobl Then
		$g_avDTtroopsToBeUsed[4][1] = $Quantity

	ElseIf $eTroop = $eWall Then
		$g_avDTtroopsToBeUsed[3][1] = $Quantity

	ElseIf $eTroop = $eMini Then
		$g_avDTtroopsToBeUsed[5][1] = $Quantity
	EndIf

EndFunc   ;==>CanBeUsedToDropTrophies

Func ResetDropTrophiesVariable()
	For $i = 0 To (UBound($g_avDTtroopsToBeUsed, 1) - 1) ; Reset the variables
		$g_avDTtroopsToBeUsed[$i][1] = 0
	Next
EndFunc   ;==>ResetDropTrophiesVariable

Func CheckQueueTroops($getQuantity = True, $showlog = True)
	Local $res[1] = [""]
	;$hTimer = __TimerInit()
	If $showlog Then SetLog("Checking Troops Queue...", $COLOR_BLUE)
	Local $directory = "trainwindow-TrainTroops-bundle"
	Local $result = SearchArmy($directory, 18, 182, 839, 261)
	ReDim $res[UBound($result)]
	;SetLog("btnGrayCheckc Done Within " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds.", $COLOR_BLUE)
	For $i = 0 To (UBound($result) - 1)
		If $g_bRunState = False Then Return
		$res[$i] = $result[$i][0]
	Next
	_ArrayReverse($res)
	If $getQuantity Then
		Local $Quantities = GetQueueQuantity($res)
		If $showlog Then
			For $i = 0 To (UBound($Quantities) - 1)
				SetLog("  - " & $g_asTroopNames[TroopIndexLookup($Quantities[$i][0], "CheckQueueTroops")] & ": " & $Quantities[$i][1] & "x", $COLOR_GREEN)
			Next
		EndIf
	EndIf
	;_ArrayDisplay($Quantities)
	Return $res
EndFunc   ;==>CheckQueueTroops

Func CheckQueueSpells($getQuantity = True, $showlog = True)
	Local $res[1] = [""]
	;$hTimer = __TimerInit()
	If $showlog Then SetLog("Checking Spells Queue...", $COLOR_BLUE)
	Local $directory = "trainwindow-SpellsInQueue-bundle"
	Local $result = SearchArmy($directory, 18, 182, 839, 261)
	ReDim $res[UBound($result)]
	;SetLog("btnGrayCheckc Done Within " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds.", $COLOR_BLUE)
	For $i = 0 To (UBound($result) - 1)
		If $g_bRunState = False Then Return
		$res[$i] = $result[$i][0]
	Next
	_ArrayReverse($res)
	If $getQuantity Then
		Local $Quantities = GetQueueQuantity($res)
		If $showlog Then
			For $i = 0 To (UBound($Quantities) - 1)
				If $g_bRunState = False Then Return
				SetLog("  - " & $g_asSpellNames[TroopIndexLookup($Quantities[$i][0], "CheckQueueSpells") - $eLSpell] & ": " & $Quantities[$i][1] & "x", $COLOR_GREEN)
			Next
		EndIf
	EndIf
	;_ArrayDisplay($Quantities)
	Return $res
EndFunc   ;==>CheckQueueSpells

Func GetQueueQuantity($AvailableTroops)
	If IsArray($AvailableTroops) Then
		If $AvailableTroops[0] = "" Or StringLen($AvailableTroops[0]) = 0 Then _ArrayDelete($AvailableTroops, 0)
		If $AvailableTroops[UBound($AvailableTroops) - 1] = "" Or StringLen($AvailableTroops[UBound($AvailableTroops) - 1]) = 0 Then _ArrayDelete($AvailableTroops, Number(UBound($AvailableTroops) - 1))
		;$hTimer = __TimerInit()
		Local $result[UBound($AvailableTroops)][2] = [["", 0]]
		Local $x = 770, $y = 189
		_CaptureRegion2()
		For $i = 0 To (UBound($AvailableTroops) - 1)
			If $g_bRunState = False Then Return
			Local $OCRResult = getQueueTroopsQuantity($x, $y)
			$result[$i][0] = $AvailableTroops[$i]
			$result[$i][1] = $OCRResult
			; At end, update Coords to next troop
			$x -= 70
		Next
		;SetLog("GetQueueQuantity Done Within " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds at #" & $i & " Loop.", $COLOR_BLUE)
		Return $result
	EndIf
	Return False
EndFunc   ;==>GetQueueQuantity

Func SearchArmy($directory = "", $x = 0, $y = 0, $x1 = 0, $y1 = 0, $txt = "", $skipReceivedTroopsCheck = False)
	; Setup arrays, including default return values for $return
	Local $aResult[1][4], $aCoordArray[1][2], $aCoords, $aCoordsSplit, $aValue
	Local $Redlines = "FV"
	; Capture the screen for comparison

	For $waiting = 0 To 10
		If $g_bRunState = False Then Return $aResult
		If getReceivedTroops(162, 200, $skipReceivedTroopsCheck) = False Then
			; Perform the search
			_CaptureRegion2($x, $y, $x1, $y1)
			Local $res = DllCall($g_hLibImgLoc, "str", "SearchMultipleTilesBetweenLevels", "handle", $g_hHBitmap2, "str", $directory, "str", "FV", "Int", 0, "str", $Redlines, "Int", 0, "Int", 1000)

			If $res[0] <> "" Then
				; Get the keys for the dictionary item.
				Local $aKeys = StringSplit($res[0], "|", $STR_NOCOUNT)

				; Redimension the result array to allow for the new entries
				ReDim $aResult[UBound($aKeys)][4]

				; Loop through the array
				For $i = 0 To UBound($aKeys) - 1
					; Get the property values
					$aResult[$i][0] = returnPropertyValue($aKeys[$i], "objectname")
					; Get the coords property
					$aValue = returnPropertyValue($aKeys[$i], "objectpoints")
					$aCoords = StringSplit($aValue, "|", $STR_NOCOUNT)
					$aCoordsSplit = StringSplit($aCoords[0], ",", $STR_NOCOUNT)
					If UBound($aCoordsSplit) = 2 Then
						; Store the coords into a two dimensional array
						$aCoordArray[0][0] = $aCoordsSplit[0] + $x ; X coord.
						$aCoordArray[0][1] = $aCoordsSplit[1] ; Y coord.
					Else
						$aCoordArray[0][0] = -1
						$aCoordArray[0][1] = -1
					EndIf
					; Store the coords array as a sub-array
					$aResult[$i][1] = Number($aCoordArray[0][0])
					$aResult[$i][2] = Number($aCoordArray[0][1])
				Next
			EndIf
			ExitLoop
		Else
			If $waiting = 1 Then Setlog("You have received castle troops! Wait 5's...")
			If _Sleep($DELAYTRAIN8) Then Return $aResult
		EndIf
	Next

	_ArraySort($aResult, 0, 0, 0, 1) ; Sort By X position , will be the Slot 0 to $i

	If $txt = "Troops" Then
		For $i = 0 To UBound($aResult) - 1
			$aResult[$i][3] = Number(getBarracksNewTroopQuantity(Slot($aResult[$i][1], "troop"), 196)) ; coc-newarmy
		Next
	EndIf
	If $txt = "Spells" Then
		For $i = 0 To UBound($aResult) - 1
			$aResult[$i][3] = Number(getBarracksNewTroopQuantity(Slot($aResult[$i][1], "spells"), 341)) ; coc-newarmy
			;Setlog("$aResult: " & $aResult[$i][0] & "|" & $aResult[$i][1] & "|" & $aResult[$i][2] & "|" & $aResult[$i][3])
		Next
	EndIf
	If $txt = "CCSpells" Then
		For $i = 0 To UBound($aResult) - 1
			$aResult[$i][3] = Number(getBarracksNewTroopQuantity(Slot($aResult[$i][1], "troop"), 498)) ; coc-newarmy
		Next
	EndIf
	If $txt = "Heroes" Then
		For $i = 0 To UBound($aResult) - 1
			If StringInStr($aResult[$i][0], "Kingqueued") Then
				$aResult[$i][3] = getRemainTHero(620, 414)
			ElseIf StringInStr($aResult[$i][0], "Queenqueued") Then
				$aResult[$i][3] = getRemainTHero(695, 414)
			ElseIf StringInStr($aResult[$i][0], "Wardenqueued") Then
				$aResult[$i][3] = getRemainTHero(775, 414)
			Else
				$aResult[$i][3] = 0
			EndIf
		Next
	EndIf

	Return $aResult
EndFunc   ;==>SearchArmy

Func ResetVariables($txt = "")

	If $txt = "troops" Or $txt = "all" Then
		For $i = 0 To $eTroopCount - 1
			If $g_bRunState = False Then Return
			$g_aiCurrentTroops[$i] = 0
			If _Sleep($DELAYTRAIN6) Then Return ; '20' just to Pause action
		Next
	EndIf
	If $txt = "Spells" Or $txt = "all" Then
		For $i = 0 To $eSpellCount - 1
			If $g_bRunState = False Then Return
			$g_aiCurrentSpells[$i] = 0
			If _Sleep($DELAYTRAIN6) Then Return ; '20' just to Pause action
		Next
	EndIf
	If $txt = "donated" Or $txt = "all" Then
		For $i = 0 To $eTroopCount - 1
			If $g_bRunState = False Then Return
			$g_aiDonateTroops[$i] = 0
			If _Sleep($DELAYTRAIN6) Then Return ; '20' just to Pause action
		Next
	EndIf

EndFunc   ;==>ResetVariables

Func OpenTrainTabNumber($Num, $WhereFrom)

	Local $CalledFrom = ""
	Local $Message[4] = ["Army Camp", _
			"Train Troops", _
			"Brew Spells", _
			"Quick Train"]
	Local $TabNumber[4][2] = [[90, 128], [245, 128], [440, 128], [650, 128]]
	If $g_bRunState = False Then Return

	If IsTrainPage() Then
		Click($TabNumber[$Num][0], $TabNumber[$Num][1], 2, 200)
		If _Sleep(1500) Then Return
		If ISArmyWindow(False, $Num) Then
			If $g_iDebugSetlogTrain = 1 Then $CalledFrom = " (Called from " & $WhereFrom & ")"
			Setlog(" - Opened the " & $Message[$Num] & $CalledFrom, $COLOR_ACTION1)
		EndIf
	Else
		Setlog(" - Error Clicking On " & ($Num >= 0 And $Num < UBound($Message)) ? ($Message[$Num]) : ("Not selectable") & " Tab!!!", $COLOR_RED)
	EndIf
EndFunc   ;==>OpenTrainTabNumber

Func TrainArmyNumber($Num)

	$Num = $Num - 1
	Local $a_TrainArmy[3][4] = [[817, 366, 0x6bb720, 10], [817, 484, 0x6bb720, 10], [817, 601, 0x6bb720, 10]]
	Setlog("Using Quick Train Tab.")
	If $g_bRunState = False Then Return

	If ISArmyWindow(False, $QuickTrainTAB) Then
		; _ColorCheck($nColor1, $nColor2, $sVari = 5, $Ignore = "")
		If _ColorCheck(_GetPixelColor($a_TrainArmy[$Num][0], $a_TrainArmy[$Num][1], True), Hex($a_TrainArmy[$Num][2], 6), $a_TrainArmy[$Num][3]) Then
			Click($a_TrainArmy[$Num][0], $a_TrainArmy[$Num][1], 1)
			SetLog("Making the Army " & $Num + 1, $COLOR_INFO)
			If _Sleep(1000) Then Return
		Else
			Setlog(" - Error Clicking On Army: " & $Num + 1 & "| Pixel was :" & _GetPixelColor($a_TrainArmy[$Num][0], $a_TrainArmy[$Num][1], True), $COLOR_ORANGE)
			Setlog(" - Please 'edit' the Army " & $Num + 1 & " before start the BOT!!!", $COLOR_RED)
			;BotStop()
		EndIf
	Else
		Setlog(" - Error Clicking On Army! You are not on Quick Train Window", $COLOR_RED)
	EndIf

EndFunc   ;==>TrainArmyNumber

Func DeleteQueued($TypeQueued, $OffsetQueued = 802)

	Local $Slot2Use = -1
	If $TypeQueued = "Troops" Then
		If ISArmyWindow(False, $TrainTroopsTAB) = False Then OpenTrainTabNumber($TrainTroopsTAB, "DeleteQueued()")
		If _Sleep(1500) Then Return
		If ISArmyWindow(True, $TrainTroopsTAB) = False Then Return
		$Slot2Use = $TrainTroopsTAB
	ElseIf $TypeQueued = "Spells" Then
		OpenTrainTabNumber($BrewSpellsTAB, "DeleteQueued()")
		If _Sleep(1500) Then Return
		If ISArmyWindow(True, $BrewSpellsTAB) = False Then Return
		$Slot2Use = $BrewSpellsTAB
	Else
		Return
	EndIf
	If _Sleep(500) Then Return
	Local $x = 0

	While Not IsQueueEmpty($Slot2Use, True, False)
		If $x = 0 Then SetLog(" - Delete " & $TypeQueued & " Queued!", $COLOR_ACTION)
		If _Sleep(20) Then Return
		If $g_bRunState = False Then Return
		Click($OffsetQueued + 24, 202, 2, 50)
		$x += 1
		If $x = 250 Then ExitLoop
	WEnd
EndFunc   ;==>DeleteQueued

Func Slot($x = 0, $txt = "")

	If $g_bRunState = False Then Return
	Switch $x
		Case $x < 94
			If $txt = "troop" Then Return 35
			If $txt = "spells" Then Return 40
		Case $x > 94 And $x < 171
			If $txt = "troop" Then Return 111
			If $txt = "spells" Then Return 120
		Case $x > 171 And $x < 244
			If $txt = "troop" Then Return 184
			If $txt = "spells" Then Return 195
		Case $x > 244 And $x < 308
			If $txt = "troop" Then Return 255
			If $txt = "spells" Then Return 272
		Case $x > 308 And $x < 393
			If $txt = "troop" Then Return 330
			If $txt = "spells" Then Return 341
		Case $x > 393 And $x < 465
			If $txt = "troop" Then Return 403
			If $txt = "spells" Then Return 415
		Case $x > 465 And $x < 538
			If $txt = "troop" Then Return 477
			If $txt = "spells" Then Return 485
		Case $x > 538 And $x < 611
			Return 551
		Case $x > 611 And $x < 683
			Return 625
		Case $x > 683 And $x < 753
			Return 694
		Case $x > 753 And $x < 825
			Return 764
	EndSwitch


EndFunc   ;==>Slot

Func MakingDonatedTroops()
	; notes $avDefaultTroopGroup[19][0] = TroopName | [1] = TroopNamePosition | [2] = TroopHeight | [3] = Times | [4] = qty | [5] = marker for DarkTroop or ElixerTroop]
	Local $avDefaultTroopGroup[19][6] = [ _
			["Arch", 1, 1, 25, 0, "e"], ["Giant", 2, 5, 120, 0, "e"], ["Wall", 4, 2, 60, 0, "e"], ["Barb", 0, 1, 20, 0, "e"], ["Gobl", 3, 1, 30, 0, "e"], ["Heal", 7, 14, 600, 0, "e"], _
			["Pekk", 9, 25, 900, 0, "e"], ["Ball", 5, 5, 300, 0, "e"], ["Wiza", 6, 4, 300, 0, "e"], ["Drag", 8, 20, 900, 0, "e"], ["BabyD", 10, 10, 600, 0, "e"], ["Mine", 11, 5, 300, 0, "e"], _
			["Mini", 0, 2, 45, 0, "d"], ["Hogs", 1, 5, 120, 0, "d"], ["Valk", 2, 8, 300, 0, "d"], ["Gole", 3, 30, 900, 0, "d"], ["Witc", 4, 12, 600, 0, "d"], ["Lava", 5, 30, 900, 0, "d"], _
			["Bowl", 6, 6, 300, 0, "d"]]

	; notes $avDefaultTroopGroup[19][5]
	; notes $avDefaultTroopGroup[19][0] = TroopName | [1] = TroopNamePosition | [2] = TroopHeight | [3] = Times | [4] = qty | [5] = marker for DarkTroop or ElixerTroop]
	; notes ClickDrag(616, 445 + $g_iMidOffsetY, 400, 445 + $g_iMidOffsetY, 2000) ; Click drag for dark Troops
	; notes	ClickDrag(400, 445 + $g_iMidOffsetY, 616, 445 + $g_iMidOffsetY, 2000) ; Click drag for Elixer Troops
	; notes $RemainTrainSpace[0] = Current Army  | [1] = Total Army Capacity  | [2] = Remain Space for the current Army



	Local $RemainTrainSpace
	Local $Plural = 0
	Local $areThereDonTroop = 0
	Local $areThereDonSpell = 0

	For $j = 0 To $eTroopCount - 1
		If $g_bRunState = False Then Return
		$areThereDonTroop += $g_aiDonateTroops[$j]
	Next

	For $j = 0 To $eSpellCount - 1
		If $g_bRunState = False Then Return
		$areThereDonSpell += $g_aiDonateSpells[$j]
	Next
	If $areThereDonSpell = 0 And $areThereDonTroop = 0 Then Return

	SetLog("  making donated troops", $COLOR_ACTION1)
	If $areThereDonTroop > 0 Then
		; Load $g_aiDonateTroops[$i] Values into $avDefaultTroopGroup[19][5]
		For $i = 0 To UBound($avDefaultTroopGroup) - 1
			For $j = 0 To $eTroopCount - 1
				If $g_asTroopShortNames[$j] = $avDefaultTroopGroup[$i][0] Then
					$avDefaultTroopGroup[$i][4] = $g_aiDonateTroops[$j]
					$g_aiDonateTroops[$j] = 0
				EndIf
			Next
		Next

		If IsTrainPage() And ISArmyWindow(False, $TrainTroopsTAB) = False Then OpenTrainTabNumber($TrainTroopsTAB, "MakingDonatedTroops()")
		If _Sleep(1500) Then Return
		If ISArmyWindow(True, $TrainTroopsTAB) = False Then Return

		For $i = 0 To UBound($avDefaultTroopGroup, 1) - 1
			If $g_bRunState = False Then Return
			$Plural = 0
			If $avDefaultTroopGroup[$i][4] > 0 Then
				$RemainTrainSpace = GetOCRCurrent(48, 160)
				If $RemainTrainSpace[0] = $RemainTrainSpace[1] Then ; army camps full
					;Camps Full All Donate Counters should be zero!!!!
					For $j = 0 To UBound($avDefaultTroopGroup, 1) - 1
						$avDefaultTroopGroup[$j][4] = 0
					Next
					ExitLoop
				EndIf

				Local $iTroopIndex = TroopIndexLookup($avDefaultTroopGroup[$i][0], "MakingDonatedTroops")

				If $avDefaultTroopGroup[$i][2] * $avDefaultTroopGroup[$i][4] <= $RemainTrainSpace[2] Then ; Troopheight x donate troop qty <= avaible train space
					;Local $pos = GetTrainPos(TroopIndexLookup($avDefaultTroopGroup[$i][0]))
					Local $howMuch = $avDefaultTroopGroup[$i][4]
					If $avDefaultTroopGroup[$i][5] = "e" Then
						TrainIt($iTroopIndex, $howMuch, $g_iTrainClickDelay)
						;PureClick($pos[0], $pos[1], $howMuch, 500)
					Else
						ClickDrag(715, 445 + $g_iMidOffsetY, 220, 445 + $g_iMidOffsetY, 2000) ; Click drag for dark Troops
						TrainIt($iTroopIndex, $howMuch, $g_iTrainClickDelay)
						;PureClick($pos[0], $pos[1], $howMuch, 500)
						ClickDrag(220, 445 + $g_iMidOffsetY, 725, 445 + $g_iMidOffsetY, 2000) ; Click drag for Elixer Troops
					EndIf
					Local $sTroopName = ($avDefaultTroopGroup[$i][4] > 1 ? $g_asTroopNamesPlural[$iTroopIndex] : $g_asTroopNames[$iTroopIndex])
					Setlog(" - Trained " & $avDefaultTroopGroup[$i][4] & " " & $sTroopName, $COLOR_ACTION)
					$avDefaultTroopGroup[$i][4] = 0
					If _Sleep(1000) Then Return ; Needed Delay, OCR was not picking up Troop Changes
				Else
					For $z = 0 To $RemainTrainSpace[2] - 1
						$RemainTrainSpace = GetOCRCurrent(48, 160)
						If $RemainTrainSpace[0] = $RemainTrainSpace[1] Then ; army camps full
							;Camps Full All Donate Counters should be zero!!!!
							For $j = 0 To UBound($avDefaultTroopGroup, 1) - 1
								$avDefaultTroopGroup[$j][4] = 0
							Next
							ExitLoop (2) ;
						EndIf
						If $avDefaultTroopGroup[$i][2] <= $RemainTrainSpace[2] And $avDefaultTroopGroup[$i][4] > 0 Then
							;TrainIt(TroopIndexLookup($g_asTroopShortNames[$i]), 1, $g_iTrainClickDelay)
							;Local $pos = GetTrainPos(TroopIndexLookup($avDefaultTroopGroup[$i][0]))
							Local $howMuch = 1
							If $iTroopIndex >= $eBarb And $iTroopIndex <= $eMine Then ; elixir troop
								TrainIt($iTroopIndex, $howMuch, $g_iTrainClickDelay)
								;PureClick($pos[0], $pos[1], $howMuch, 500)
							Else ; dark elixir troop
								ClickDrag(715, 445 + $g_iMidOffsetY, 220, 445 + $g_iMidOffsetY, 2000) ; Click drag for dark Troops
								TrainIt($iTroopIndex, $howMuch, $g_iTrainClickDelay)
								;PureClick($pos[0], $pos[1], $howMuch, 500)
								ClickDrag(220, 445 + $g_iMidOffsetY, 725, 445 + $g_iMidOffsetY, 2000) ; Click drag for Elixer Troops
							EndIf
							Local $sTroopName = ($avDefaultTroopGroup[$i][4] > 1 ? $g_asTroopNamesPlural[$iTroopIndex] : $g_asTroopNames[$iTroopIndex])
							Setlog(" - Trained " & $avDefaultTroopGroup[$i][4] & " " & $sTroopName, $COLOR_ACTION)
							$avDefaultTroopGroup[$i][4] -= 1
							If _Sleep(1000) Then Return ; Needed Delay, OCR was not picking up Troop Changes
						Else
							ExitLoop
						EndIf
					Next
				EndIf
			EndIf
		Next
		;Top Off any remianing space with archers
		$RemainTrainSpace = GetOCRCurrent(48, 160)
		If $RemainTrainSpace[0] < $RemainTrainSpace[1] Then ; army camps full
			Local $howMuch = $RemainTrainSpace[2]
			TrainIt($eTroopArcher, $howMuch, $g_iTrainClickDelay)
			;PureClick($TrainArch[0], $TrainArch[1], $howMuch, 500)
			If $RemainTrainSpace[2] > 0 Then $Plural = 1
			Setlog(" - Trained " & $howMuch & " archer(s)!", $COLOR_ACTION)
			If _Sleep(1000) Then Return ; Needed Delay, OCR was not picking up Troop Changes
		EndIf
		; Ensure all donate values are reset to zero
		For $j = 0 To UBound($avDefaultTroopGroup, 1) - 1
			$avDefaultTroopGroup[$j][4] = 0
		Next
	EndIf

	If $areThereDonSpell > 0 Then
		;Train Donated Spells
		If IsTrainPage() And ISArmyWindow(False, 2) = False Then OpenTrainTabNumber(2, "MakingDonatedTroops()")
		If _Sleep(1500) Then Return
		If ISArmyWindow(True, 2) = False Then Return

		For $i = 0 To $eSpellCount - 1
			If $g_bRunState = False Then Return
			If $g_aiDonateSpells[$i] > 0 Then
				Local $pos = GetTrainPos($i + $eLSpell)
				Local $howMuch = $g_aiDonateSpells[$i]
				TrainIt($eLSpell + $i, $howMuch, $g_iTrainClickDelay)
				;PureClick($pos[0], $pos[1], $howMuch, 500)
				Setlog(" - Brewed " & $howMuch & " " & $g_asSpellNames[$i] & ($howMuch > 1 ? " Spells" : " Spell"), $COLOR_ACTION)
				$g_aiDonateTroops[$i] -= $howMuch
			EndIf
		Next
	EndIf
	If _Sleep(1000) Then Return
	$RemainTrainSpace = GetOCRCurrent(48, 160)
	Setlog(" - Current Capacity: " & $RemainTrainSpace[0] & "/" & ($RemainTrainSpace[1]))
EndFunc   ;==>MakingDonatedTroops

Func GetOCRCurrent($x_start, $y_start)

	Local $FinalResult[3] = [0, 0, 0]
	If $g_bRunState = False Then Return $FinalResult

	; [0] = Current Army  | [1] = Total Army Capacity  | [2] = Remain Space for the current Army
	Local $result = getArmyCapacityOnTrainTroops($x_start, $y_start)

	If StringInStr($result, "#") Then
		Local $resultSplit = StringSplit($result, "#", $STR_NOCOUNT)
		$FinalResult[0] = Number($resultSplit[0])
		$FinalResult[1] = Number($resultSplit[1])
		$FinalResult[2] = $FinalResult[1] - $FinalResult[0]
	Else
		Setlog("DEBUG | ERROR on GetOCRCurrent", $COLOR_RED)
	EndIf

	Return $FinalResult

EndFunc   ;==>GetOCRCurrent

Func CheckIsFullQueuedAndNotFullArmy()

	SetLog(" - Checking: FULL Queue and Not Full Army", $COLOR_ACTION1)
	Local $CheckTroop[4] = [824, 243, 0x949522, 20] ; the green check symbol [bottom right] at slot 0 troop
	If $g_bRunState = False Then Return

	If IsTrainPage() And ISArmyWindow(False, $TrainTroopsTAB) = False Then OpenTrainTabNumber($TrainTroopsTAB, "CheckIsFullQueuedAndNotFullArmy()")
	If _Sleep(1500) Then Return
	If ISArmyWindow(True, $TrainTroopsTAB) = False Then Return

	Local $ArmyCamp = GetOCRCurrent(48, 160)
	If UBound($ArmyCamp) = 3 And $ArmyCamp[2] < 0 Then
		If _ColorCheck(_GetPixelColor($CheckTroop[0], $CheckTroop[1], True), Hex($CheckTroop[2], 6), $CheckTroop[3]) Then
			SetLog(" - Conditions met: FULL Queue and Not Full Army")
			DeleteQueued("Troops")
			If _Sleep(500) Then Return
			$ArmyCamp = GetOCRCurrent(48, 160)
			Local $ArchToMake = $ArmyCamp[2]
			If ISArmyWindow(False, $TrainTroopsTAB) Then TrainIt($eArch, $ArchToMake, $g_iTrainClickDelay) ; PureClick($TrainArch[0], $TrainArch[1], $ArchToMake, 500)
			Setlog("Trained " & $ArchToMake & " archer(s)!")
		Else
			SetLog(" - Conditions NOT met: FULL queue and Not Full Army")
		EndIf
	EndIf

EndFunc   ;==>CheckIsFullQueuedAndNotFullArmy

Func CheckIsEmptyQueuedAndNotFullArmy()

	SetLog(" - Checking: Empty Queue and Not Full Army", $COLOR_ACTION1)
	Local $CheckTroop[4] = [820, 220, 0xCFCFC8, 15] ; the gray background at slot 0 troop
	Local $CheckTroop1[4] = [390, 130, 0x78BE2B, 15] ; the Green Arrow on Troop Training tab
	If $g_bRunState = False Then Return

	If IsTrainPage() And ISArmyWindow(False, $TrainTroopsTAB) = False Then OpenTrainTabNumber($TrainTroopsTAB, "CheckIsEmptyQueuedAndNotFullArmy()")
	If _Sleep(1500) Then Return
	If ISArmyWindow(True, $TrainTroopsTAB) = False Then Return

	Local $ArmyCamp = GetOCRCurrent(48, 160)
	If UBound($ArmyCamp) = 3 And $ArmyCamp[2] > 0 Then
		If _ColorCheck(_GetPixelColor($CheckTroop[0], $CheckTroop[1], True), Hex($CheckTroop[2], 6), $CheckTroop[3]) Then
			If Not _ColorCheck(_GetPixelColor($CheckTroop1[0], $CheckTroop1[1], True), Hex($CheckTroop1[2], 6), $CheckTroop1[3]) Then
				SetLog(" - Conditions met: Empty Queue and Not Full Army")
				If _Sleep(500) Then Return
				$ArmyCamp = GetOCRCurrent(48, 160)
				Local $ArchToMake = $ArmyCamp[2]
				If ISArmyWindow(False, $TrainTroopsTAB) Then TrainIt($eArch, $ArchToMake, $g_iTrainClickDelay) ;PureClick($TrainArch[0], $TrainArch[1], $ArchToMake, 500)
				SetLog(" - Trained " & $ArchToMake & " archer(s)!")
			Else
				SetLog(" - Conditions NOT met: Empty queue and Not Full Army")
			EndIf
		EndIf
	EndIf
EndFunc   ;==>CheckIsEmptyQueuedAndNotFullArmy

Func getReceivedTroops($x_start, $y_start, $skip = False) ; Check if 'you received Castle Troops from' , will proceed with a Sleep until the message disappear
	If $skip = True Then Return False
	Local $result = ""
	If $g_bRunState = False Then Return

	$result = getOcrAndCapture("coc-DonTroops", $x_start, $y_start, 120, 27, True) ; X = 162  Y = 200

	If IsString($result) <> "" Or IsString($result) <> " " Then
		If StringInStr($result, "you") Then ; If exist Minutes or only Seconds
			Return True
		Else
			Return False
		EndIf
	Else
		Return False
	EndIf

EndFunc   ;==>getReceivedTroops

Func TestTrainRevamp2()
	$g_bRunState = True

	$g_iDebugOcr = 1
	Setlog("Start......OpenArmy Window.....")

	Local $timer = __TimerInit()

	CheckExistentArmy("Troops")

	Setlog("Imgloc Troops Time: " & Round(__TimerDiff($timer) / 1000, 2) & "'s")

	Setlog("End......OpenArmy Window.....")
	$g_iDebugOcr = 0
	$g_bRunState = False
EndFunc   ;==>TestTrainRevamp2

Func IIf($Condition, $IfTrue, $IfFalse)
	If $Condition = True Then
		Return $IfTrue
	Else
		Return $IfFalse
	EndIf
EndFunc   ;==>IIf

Func _ArryRemoveBlanks(ByRef $Array)
	Local $Counter = 0
	For $i = 0 To UBound($Array) - 1
		If $Array[$i] <> "" Then
			$Array[$Counter] = $Array[$i]
			$Counter += 1
		EndIf
	Next
	ReDim $Array[$Counter]
EndFunc   ;==>_ArryRemoveBlanks

Func ValidateSearchArmyResult($result, $index = 0)
	If IsArray($result) Then
		If UBound($result) > 0 Then
			If StringLen($result[$index][0]) > 0 Then Return True
		EndIf
	EndIf
	Return False
EndFunc   ;==>ValidateSearchArmyResult

Func CheckValuesCost($Troop = "Arch", $troopQuantity = 1, $DebugLogs = 0)

	; Local Variables
	Local $TempColorToCheck = ""
	Local $nElixirCurrent = 0, $nDarkCurrent = 0, $bLocalDebugOCR = 0

	If _sleep(1000) Then Return ; small delay
	If $g_bRunState = False Then Return

	; 	DEBUG
	If $g_iDebugSetlogTrain = 1 Or $DebugLogs Then
		$bLocalDebugOCR = $g_iDebugOcr
		$g_iDebugOcr = 1 ; enable the OCR debug
		$TempColorToCheck = _GetPixelColor(223, 594, True)
		Setlog("CheckValuesCost|ColorToCheck: " & $TempColorToCheck)
	EndIf

	; Let??s UPDATE the current Elixir and Dark elixir each Troop train on 'Bottom train Window Page'
	If _ColorCheck(_GetPixelColor(223, 594, True), Hex(0xE8E8E0, 6), 20) Then ; Gray background window color
		; Village without Dark Elixir
		If ISArmyWindow(False, $TrainTroopsTAB) Or ISArmyWindow(False, $BrewSpellsTAB) Then $nElixirCurrent = getResourcesValueTrainPage(315, 594) ; ELIXIR
	Else
		; Village with Elixir and Dark Elixir
		If ISArmyWindow(False, $TrainTroopsTAB) Or ISArmyWindow(False, $BrewSpellsTAB) Then $nElixirCurrent = getResourcesValueTrainPage(230, 594) ; ELIXIR
		If ISArmyWindow(False, $TrainTroopsTAB) Or ISArmyWindow(False, $BrewSpellsTAB) Then $nDarkCurrent = getResourcesValueTrainPage(382, 594) ; DARK ELIXIR
	EndIf

	; 	DEBUG
	If $g_iDebugSetlogTrain = 1 Or $DebugLogs Then
		Setlog(" ?? Current resources:")
		Setlog(" - Elixir: " & _NumberFormat($nElixirCurrent) & " / Dark Elixir: " & _NumberFormat($nDarkCurrent), $COLOR_INFO)
		$g_iDebugOcr = $bLocalDebugOCR ; disable the OCR debug
	EndIf

	Local $troopCost = 0
	Local $iTroopIndex = TroopIndexLookup($Troop, "CheckValuesCost")

	; Return the Cost of Troops or Spells
	If $iTroopIndex >= $eBarb And $iTroopIndex <= $eBowl Then
		$troopCost = $g_aiTroopCostPerLevel[$iTroopIndex][$g_aiTrainArmyTroopLevel[$iTroopIndex]]
	ElseIf $iTroopIndex >= $eLSpell And $iTroopIndex <= $eSkSpell Then
		$troopCost = $g_aiSpellCostPerLevel[$iTroopIndex - $eLSpell][$g_aiTrainArmySpellLevel[$iTroopIndex - $eLSpell]]
	EndIf

	;	DEBUG
	If $g_iDebugSetlogTrain = 1 Or $DebugLogs Then SetLog("Individual Cost " & $Troop & "= " & $troopCost)

	; Cost of the Troop&Spell x the quantities
	$troopCost *= $troopQuantity

	; 	DEBUG
	If $g_iDebugSetlogTrain = 1 Or $DebugLogs Then SetLog("Total Cost " & $Troop & "= " & $troopCost)

	If IsDarkTroop($Troop) Then
		; If is Dark Troop
		If $g_iDebugSetlogTrain = 1 Or $DebugLogs Then SetLog("Dark Troop " & $Troop & " Is Dark Troop")
		If $troopCost <= $nDarkCurrent Then
			Return True
		EndIf
		Return False
	ElseIf IsElixirSpell($Troop) Then
		; If is Elixir Spell
		If $g_iDebugSetlogTrain = 1 Or $DebugLogs Then SetLog("Spell " & $Troop & " Is Elixir Spell")
		If $troopCost <= $nElixirCurrent Then
			Return True
		EndIf
		Return False
	ElseIf IsDarkSpell($Troop) Then
		; If is Dark Spell
		If $g_iDebugSetlogTrain = 1 Or $DebugLogs Then SetLog("Dark Spell " & $Troop & " Is Dark Spell")
		If $troopCost <= $nDarkCurrent Then
			Return True
		EndIf
		Return False
	Else
		; If Isn't Dark Troop And Spells, Then is Elixir Troop : )
		If $troopCost <= $nElixirCurrent Then
			If $g_iDebugSetlogTrain = 1 Or $DebugLogs Then SetLog("Troop " & $Troop & " Is Elixir Troop")
			Return True
		EndIf
		Return False
	EndIf


EndFunc   ;==>CheckValuesCost

Func ThSnipesSkiptrain()
	Local $Temp = 0
	; Check if the User will use TH snipes

	If IsSearchModeActive($TS) And $g_bIsFullArmywithHeroesAndSpells Then
		For $i = 0 To $eTroopCount - 1
			If $g_aiArmyCompTroops[$i] > 0 Then $Temp += 1
		Next
		If $Temp = 1 Then Return False ; 	make troops before battle ( is using only one troop kind )
		If $Temp > 1 Then
			Setlog("Skipping Training before Attack due to THSnipes!", $COLOR_INFO)
			Return True ;	not making troops before battle
		EndIf
	Else
		Return False ; 	Proceeds as usual
	EndIf
EndFunc   ;==>ThSnipesSkiptrain

