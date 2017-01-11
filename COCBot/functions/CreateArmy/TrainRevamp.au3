; #FUNCTION# ====================================================================================================================
; Name ..........: Train Revamp Oct 2016
; Description ...:
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Mr.Viper & ProMac OCT 2016
; Modified ......: ProMac (NOV 2016), Boju (11-2016), MR.ViPER (15-12-2016) , ProMac(01-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func TrainRevamp()
	StartGainCost()

	If $ichkUseQTrain = 0 Then
		TrainRevampOldStyle()
		Return
	EndIf

	If $debugsetlogTrain = 1 Then Setlog(" - Initial Quick train Function")

	Local $timer

	If $debugsetlogTrain = 1 Then Setlog(" - Line Open Army Window")

	CheckArmySpellCastel()

	;Test for Train/Donate Only and Fullarmy
	If ($CommandStop = 3 Or $CommandStop = 0) And $fullarmy Then
		SetLog("You are in halt attack mode and your Army is prepared!", $COLOR_DEBUG) ;Debug
		If $FirstStart Then $FirstStart = False
		Return
	EndIf

	;Load Troop and Spell counts in "Cur"
	;CheckExistentArmy("Troops") ; routine on checkArmyCamp
	;CheckExistentArmy("Spells") ; routine on checkArmyCamp
	CountNumberSpells() ; needed value for spell donate

	If $Runstate = False Then Return

	If ($IsFullArmywithHeroesAndSpells = True) Or ($CurCamp = 0 And $FirstStart) Then

		If $IsFullArmywithHeroesAndSpells Then Setlog(" - Your Army is Full, let's make troops before Attack!", $COLOR_BLUE)
		If ($CurCamp = 0 And $FirstStart) Then
			Setlog(" - Your Army is Empty, let's make troops before Attack!", $COLOR_ACTION1)
			Setlog(" - Go to TrainRevamp Tab and select your Quick Army position!", $COLOR_ACTION1)
		EndIf

		DeleteQueued("Troops")
		If _Sleep(250) Then Return
		DeleteQueued("Spells")
		If _Sleep(500) Then Return

		CheckCamp()

		ResetVariables("donated")

		If $FirstStart Then $FirstStart = False

		If _Sleep(700) Then Return
	Else

		If $bDonationEnabled = True Then MakingDonatedTroops()

		CheckIsFullQueuedAndNotFullArmy()
		If $Runstate = False Then Return
		CheckIsEmptyQueuedAndNotFullArmy()
		If $Runstate = False Then Return
		If $FirstStart Then $FirstStart = False
	EndIf

	ClickP($aAway, 2, 0, "#0346") ;Click Away
	If _Sleep(1000) Then Return ; Delay AFTER the click Away Prevents lots of coc restarts
	SetLog(" - Army Window Closed!", $COLOR_ACTION1)

	EndGainCost("Train")

	checkAttackDisable($iTaBChkIdle) ; Check for Take-A-Break after opening train page

EndFunc   ;==>TrainRevamp

Func CheckCamp($NeedOpenArmy = False, $CloseCheckCamp = False)
	If $NeedOpenArmy Then
		OpenArmyWindow()
		If _Sleep(500) Then Return
	EndIf
	Local $Num = 0
	If $iChkQuickArmy1 = 1 Then $Num = 1
	If $iChkQuickArmy2 = 1 Then $Num = 2
	If $iChkQuickArmy3 = 1 Then $Num = 3
	Local $ReturnCamp = TestMaxCamp()

	If $ReturnCamp = 1 Then
		OpenTrainTabNumber($QuickTrainTAB)
		If _Sleep(1000) Then Return
		TrainArmyNumber($Num)
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
	If ISArmyWindow(False, $TrainTroopsTAB) = False Then OpenTrainTabNumber($TrainTroopsTAB)
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
	If $debugsetlogTrain = 1 Then Setlog(" - Initial Custom train Function")

	;If $bDonateTrain = -1 Then SetbDonateTrain()
	If $bActiveDonate = -1 Then PrepareDonateCC()

	CheckArmySpellCastel()

	;Test for Train/Donate Only and Fullarmy
	If ($CommandStop = 3 Or $CommandStop = 0) And $fullarmy Then
		SetLog("You are in halt attack mode and your Army is prepared!", $COLOR_DEBUG) ;Debug
		If $FirstStart Then $FirstStart = False
		Return
	EndIf

	If ThSnipesSkiptrain() Then Return

	If $Runstate = False Then Return
	Local $rWhatToTrain = WhatToTrain(True) ; r in First means Result! Result of What To Train Function
	Local $rRemoveExtraTroops = RemoveExtraTroops($rWhatToTrain)

	If $rRemoveExtraTroops = 1 Or $rRemoveExtraTroops = 2 Then
		CheckArmySpellCastel()

		;Test for Train/Donate Only and Fullarmy
		If ($CommandStop = 3 Or $CommandStop = 0) And $fullarmy Then
			SetLog("You are in halt attack mode and your Army is prepared!", $COLOR_DEBUG) ;Debug
			If $FirstStart Then $FirstStart = False
			Return
		EndIf

	EndIf

	If $Runstate = False Then Return

	If $rRemoveExtraTroops = 2 Then
		$rWhatToTrain = WhatToTrain(False, False)
		OpenTrainTabNumber($TrainTroopsTAB)
		TrainUsingWhatToTrain($rWhatToTrain)
	EndIf

	;If Not $rRemoveExtraTroops = 2 Then OpenTrainTabNumber($TrainTroopsTAB)

	If IsQueueEmpty($TrainTroopsTAB) = True Then
		If $Runstate = False Then Return
		OpenTrainTabNumber($ArmyTAB)
		$rWhatToTrain = WhatToTrain(False, False)
		OpenTrainTabNumber($TrainTroopsTAB)
		TrainUsingWhatToTrain($rWhatToTrain)
	Else
		If $Runstate = False Then Return
		OpenTrainTabNumber($ArmyTAB)
		; Local $TimeRemainTroops =  getRemainTrainTimer(756, 169) ;Get time via OCR.
		; $aTimeTrain[0]  = ConvertOCRTime("Troops", $TimeRemainTroops)  ; update global array
	EndIf
	$rWhatToTrain = WhatToTrain(False, False)
	If DoWhatToTrainContainSpell($rWhatToTrain) Then
		If IsQueueEmpty($BrewSpellsTAB) = True Then
			TrainUsingWhatToTrain($rWhatToTrain, True)
		Else
			OpenTrainTabNumber($ArmyTAB)
			; Local $TimeRemainSpells = getRemainTrainTimer(495, 315) ;Get time via OCR.
			; $aTimeTrain[1] = ConvertOCRTime("Spells", $TimeRemainSpells)  ; update global array
		EndIf
	EndIf

	If _Sleep(250) Then Return
	If $Runstate = False Then Return
	ClickP($aAway, 2, 0, "#0346") ;Click Away
	If _Sleep(250) Then Return

	EndGainCost("Train")

	checkAttackDisable($iTaBChkIdle) ; Check for Take-A-Break after opening train page
EndFunc   ;==>TrainRevampOldStyle

Func CheckArmySpellCastel()

	If OpenArmyWindow() = False Then Return
	If _Sleep(250) Then Return
	If ISArmyWindow(False, $ArmyTAB) = False Then OpenTrainTabNumber($ArmyTAB)
	SetLog(" - Army Window Opened!", $COLOR_ACTION1)
	If _Sleep(250) Then Return
	If $Runstate = False Then Return
	checkArmyCamp(False, False)

	If $debugsetlogTrain = 1 Then $debugOcr = 1
	Local $sSpells = getArmyCampCap(99, 313) ; OCR read Spells trained and total
	Local $aGetSpellsSize = StringSplit($sSpells, "#", $STR_NOCOUNT)
	If $debugsetlogTrain = 1 Then Setlog(" - $sSpells : " & $sSpells)

	Local $scastle = getArmyCampCap(300, 468) ; OCR read Castle Received and total
	Local $aGetCastleSize = StringSplit($scastle, "#", $STR_NOCOUNT)
	If $debugsetlogTrain = 1 Then Setlog(" - $scastle : " & $scastle)
	If $debugsetlogTrain = 1 Then $debugOcr = 0

	If $debugsetlogTrain = 1 Then Setlog(" - $CurCamp : " & $CurCamp)
	If $debugsetlogTrain = 1 Then Setlog(" - $TotalCamp : " & $TotalCamp)

	$bFullArmySpells = False
	; Local Variable to check the occupied space by the Spells to Brew ... can be different of the Spells Factory Capacity ( $iTotalCountSpell )
	Local $totalCapacitySpellsToBrew = $PSpellComp + $ESpellComp + $HaSpellComp + $SkSpellComp + ($LSpellComp * 2) + ($RSpellComp * 2) + ($HSpellComp * 2) + ($JSpellComp * 2) + ($FSpellComp * 2) + ($CSpellComp * 2)

	$iTotalSpellSpace = 0
	If UBound($aGetSpellsSize) = 2 Then
		If $aGetSpellsSize[0] = $aGetSpellsSize[1] Or $aGetSpellsSize[0] >= $iTotalCountSpell Or $aGetSpellsSize[0] >= $totalCapacitySpellsToBrew Then
			$iTotalSpellSpace = $aGetSpellsSize[0]
			$bFullArmySpells = True
		EndIf
	Else
		If $iTownHallLevel > 4 And $iTotalCountSpell > 0 Then
			SetLog("Error reading Spells size!!", $COLOR_RED)
			Return
		Else
			$bFullArmySpells = True
		EndIf
	EndIf

	$checkSpells = checkspells()
	If $Runstate = False Then Return
	$fullcastlespells = IsFullCastleSpells()
	If $Runstate = False Then Return
	$fullcastletroops = IsFullCastleTroops()

	$bFullCastle = False
	If UBound($aGetCastleSize) = 2 Then
		If $aGetCastleSize[0] = $aGetCastleSize[1] Then
			$bFullCastle = True
		EndIf
	Else
		SetLog("Error reading Castle size")
		Return
	EndIf

	Setlog(" - Army Camp: " & $CurCamp & "/" & $TotalCamp, $COLOR_GREEN) ; coc-ms
	If $aGetSpellsSize[0] <> "" And $aGetSpellsSize[1] <> "" Then Setlog(" - Spells: " & $aGetSpellsSize[0] & "/" & $aGetSpellsSize[1], $COLOR_GREEN) ; coc-ms
	If $aGetCastleSize[0] <> "" And $aGetCastleSize[1] <> "" Then Setlog(" - Clan Castle: " & $aGetCastleSize[0] & "/" & $aGetCastleSize[1], $COLOR_GREEN) ; coc-ms

	; If Drop Trophy with Heroes is checked and a Hero is Available or under the trophies range, then set $bFullArmyHero to True
	If IsWaitforHeroesActive() = False And $iChkTrophyHeroes = 0 Then $bFullArmyHero = True
	If IsWaitforHeroesActive() = False And $iChkTrophyHeroes = 1 And $bFullArmyHero = False Then
		If $iHeroAvailable > 0 Or Number($iTrophyCurrent) <= Number($iTxtMaxTrophy) Then
			$bFullArmyHero = True
		Else
			Setlog("Waiting for Heroes to drop trophies!", $COLOR_ACTION)
		EndIf
	EndIf

	If (IsSearchModeActive($DB) And checkCollectors(True, False)) Or IsSearchModeActive($LB) Or IsSearchModeActive($TS) Then
		If $fullarmy And $checkSpells And $bFullArmyHero And $fullcastlespells And $fullcastletroops Then
			$IsFullArmywithHeroesAndSpells = True
			If $FirstStart Then $FirstStart = False
		Else
			$IsFullArmywithHeroesAndSpells = False
		EndIf
	Else
		$IsFullArmywithHeroesAndSpells = False
	EndIf

	Local $text = ""

	If $fullarmy = False Then
		$text &= " Troops,"
	EndIf
	If $checkSpells = False Then
		$text &= " Spells,"
	EndIf
	If $bFullArmyHero = False Then
		$text &= " Heroes,"
	EndIf
	If $fullcastlespells = False Then
		$text &= " CC Spell,"
	EndIf
	If $fullcastletroops = False Then
		$text &= " CC Troops,"
	EndIf

	If $IsFullArmywithHeroesAndSpells = True Then
		If (($NotifyPBEnabled = 1 Or $NotifyTGEnabled = 1) And $NotifyAlertCampFull = 1) Then PushMsg("CampFull")
		Setlog("Chief, is your Army ready for battle? Yes, it is!", $COLOR_GREEN)
	Else
		Setlog("Chief, is your Army ready for the battle? No, not yet!", $COLOR_ACTION)
		If $text <> "" Then Setlog(" -" & $text & " not Ready!", $COLOR_ACTION)
	EndIf

	If $debugSetlog = 1 Then
		SetLog(" $fullarmy: " & String($fullarmy), $COLOR_DEBUG)
		SetLog(" $bFullArmyHero: " & String($bFullArmyHero), $COLOR_DEBUG)
		SetLog(" $fullcastlespells: " & String($fullcastlespells), $COLOR_DEBUG)
		SetLog(" $fullcastletroops: " & String($fullcastletroops), $COLOR_DEBUG)
		SetLog(" $IsFullArmywithHeroesAndSpells: " & String($IsFullArmywithHeroesAndSpells), $COLOR_DEBUG)
		SetLog(" $iTownHallLevel: " & Number($iTownHallLevel), $COLOR_DEBUG)
	EndIf

EndFunc   ;==>CheckArmySpellCastel

Func IsFullArmy($log = False) ;Go in Troop Tab
	If ISArmyWindow(False, $ArmyTAB) = False Then OpenTrainTabNumber($ArmyTAB)
	If $Runstate = False Then Return

	Local Const $rColorCheck = _ColorCheck(_GetPixelColor(28, 176, True), Hex(0xFFFFFF, 6), 20) And _ColorCheck(_GetPixelColor(24, 168, True), Hex(0x92C232, 6), 20)

	If $rColorCheck = True Then $fullarmy = True

	Local $sArmyCamp = getArmyCampCap(110, 166) ; OCR read army trained and total
	Local $aGetArmySize = StringSplit($sArmyCamp, "#", $STR_NOCOUNT)
	If UBound($aGetArmySize) >= 2 Then
		If $log Then SetLog("Troops: " & $aGetArmySize[0] & "/" & $aGetArmySize[1], $COLOR_GREEN)
		;Test for Full Army
		$fullarmy = False
		$CurCamp = 0
		If $ichkTotalCampForced = 0 Then
			$CurCamp = $aGetArmySize[0]
			$TotalCamp = $aGetArmySize[1]
		Else
			$CurCamp = $aGetArmySize[0]
			$TotalCamp = Number($iValueTotalCampForced)
		EndIf
		Local $thePercent = Number(($CurCamp / $TotalCamp) * 100, 1)
		If $thePercent >= $fulltroop Then $fullarmy = True
	EndIf
	Return $fullarmy
EndFunc   ;==>IsFullArmy

Func IsFullSpells($log = False) ;Go in Spell Tab
	If ISArmyWindow(False, $ArmyTAB) = False Then OpenTrainTabNumber($ArmyTAB)
	If $Runstate = False Then Return

	Local $sSpells = getArmyCampCap(99, 313) ; OCR read Spells trained and total
	Local $aGetSpellsSize = StringSplit($sSpells, "#", $STR_NOCOUNT)

	$bFullArmySpells = False
	If UBound($aGetSpellsSize) = 2 Then
		If $log Then SetLog("Spells: " & $aGetSpellsSize[0] & "/" & $aGetSpellsSize[1], $COLOR_GREEN)
		If $aGetSpellsSize[0] = $aGetSpellsSize[1] Or $aGetSpellsSize[0] >= $iTotalCountSpell Or $aGetSpellsSize[0] >= TotalSpellsToBrewInGUI() Then
			$bFullArmySpells = True
			Return True
		EndIf
	Else
		SetLog("Error reading Spells size")
		Return
	EndIf

	If $aGetSpellsSize[0] = $iTotalCountSpell Then
		$bFullArmySpells = True
		Return True
	EndIf

	Return $bFullArmySpells
EndFunc   ;==>IsFullSpells

Func checkspells()
	Local $ToReturn = False
	If $Runstate = False Then Return

	If ($iEnableSpellsWait[$DB] = 0 And $iEnableSpellsWait[$LB] = 0) Or ($bFullArmySpells And ($iEnableSpellsWait[$DB] = 1 Or $iEnableSpellsWait[$LB] = 1)) Then
		$ToReturn = True
		Return $ToReturn
	EndIf

	$ToReturn = (IIf($iDBcheck = 1, IIf($iEnableSpellsWait[$DB] = 1, $bFullArmySpells, True), 1) And IIf($iABcheck = 1, IIf($iEnableSpellsWait[$LB] = 1, $bFullArmySpells, True), 1))

	Return $ToReturn
EndFunc   ;==>checkspells

Func IsFullCastleSpells($returnOnly = False)
	Local $CCSpellFull = False
	Local $ToReturn = False
	If $Runstate = False Then Return
	If $iChkWaitForCastleSpell[$DB] = 0 And $iChkWaitForCastleSpell[$LB] = 0 Then
		$ToReturn = True
		If $returnOnly = False Then
			Return $ToReturn
		Else
			Return ""
		EndIf
	EndIf

	$sTempCCSpells = getArmyCampCap(530, 435 + $midOffsetY)
	$aTempCCSpells = StringSplit($sTempCCSpells,"", $STR_NOCOUNT)
	$iCurCCSpell = $aTempCCSpells[0]
	$iMaxCCSpell = $aTempCCSpells[1]
	If $iCurCCSpell = $iMaxCCSpell Then $CCSpellFull = True
	Local $rColCheckFullCCTroops = False
	$ToReturn = (IIf($iDBcheck = 1, IIf($iChkWaitForCastleSpell[$DB] = 1, $CCSpellFull, True), 1) And IIf($iABcheck = 1, IIf($iChkWaitForCastleSpell[$LB] = 1, $CCSpellFull, True), 1))


	If $ToReturn = True Then
		Setlog("Getting current available spell in clan castle.")
		$CurCCSpell1 = GetCurCCSpell(1)
		$CurCCSpell2 = GetCurCCSpell(2)
		If $CurCCSpell1 = "" And $iCurCCSpell = 0 Then
			If $returnOnly = False Then SetLog("Failed to get current available spell in clan castle", $COLOR_ERROR)
			$ToReturn = False
			If $returnOnly = False Then
				Return $ToReturn
			Else
				Return ""
			EndIf
		EndIf
		Local $aShouldRemove
		$aShouldRemove = CompareCCSpellWithGUI($CurCCSpell1, $CurCCSpell2)

		If $aShouldRemove <> "" Then
			SetLog("Removing Useless Spell from Clan Castle", $COLOR_BLUE)
			RemoveCastleSpell($aShouldRemove)
			If _Sleep(1000) Then Return
			$canRequestCC = _ColorCheck(_GetPixelColor($aRequestTroopsAO[0], $aRequestTroopsAO[1], True), Hex($aRequestTroopsAO[2], 6), $aRequestTroopsAO[5])
			If $canRequestCC = True Then
				$rColCheckFullCCTroops = _ColorCheck(_GetPixelColor(24, 470, True), Hex(0x93C230, 6), 30)
				If $rColCheckFullCCTroops = True Then SetLog("Clan Castle Spell is empty, Requesting for...")
				If $returnOnly = False Then
					RequestCC(False, IIf($rColCheckFullCCTroops = True Or ($iChkWaitForCastleTroops[$DB] = 0 And $iChkWaitForCastleTroops[$LB] = 0), IIf($iChkWaitForCastleSpell[$LB] = 1, IIf(String(GUICtrlRead($cmbABWaitForCastleSpell)) = "Any", "", String(GUICtrlRead($cmbABWaitForCastleSpell) & " Spell")), IIf($iChkWaitForCastleSpell[$DB] = 1, IIf(String(GUICtrlRead($cmbDBWaitForCastleSpell)) = "Any", "", String(GUICtrlRead($cmbDBWaitForCastleSpell) & " Spell")), "")), ""))
				Else
					$ToReturn = IIf($rColCheckFullCCTroops = True Or ($iChkWaitForCastleTroops[$DB] = 0 And $iChkWaitForCastleTroops[$LB] = 0), IIf($iChkWaitForCastleSpell[$LB] = 1, IIf(String(GUICtrlRead($cmbABWaitForCastleSpell)) = "Any", "", String(GUICtrlRead($cmbABWaitForCastleSpell) & " Spell")), IIf($iChkWaitForCastleSpell[$DB] = 1, IIf(String(GUICtrlRead($cmbDBWaitForCastleSpell)) = "Any", "", String(GUICtrlRead($cmbDBWaitForCastleSpell) & " Spell")), "")), "")
					Return $ToReturn
				EndIf
			EndIf
			$ToReturn = False
		EndIf
	Else
		$canRequestCC = _ColorCheck(_GetPixelColor($aRequestTroopsAO[0], $aRequestTroopsAO[1], True), Hex($aRequestTroopsAO[2], 6), $aRequestTroopsAO[5])
		If $canRequestCC = True Then
			$rColCheckFullCCTroops = _ColorCheck(_GetPixelColor(24, 470, True), Hex(0x93C230, 6), 30)
			If $rColCheckFullCCTroops = True Then SetLog("Clan Castle Spell is empty, Requesting for...")
			If $returnOnly = False Then
				RequestCC(False, IIf($rColCheckFullCCTroops = True Or ($iChkWaitForCastleTroops[$DB] = 0 And $iChkWaitForCastleTroops[$LB] = 0), IIf($iChkWaitForCastleSpell[$LB] = 1, IIf(String(GUICtrlRead($cmbABWaitForCastleSpell)) = "Any", "", String(GUICtrlRead($cmbABWaitForCastleSpell) & " Spell")), IIf($iChkWaitForCastleSpell[$DB] = 1, IIf(String(GUICtrlRead($cmbDBWaitForCastleSpell)) = "Any", "", String(GUICtrlRead($cmbDBWaitForCastleSpell) & " Spell")), "")), ""))
			Else
				$ToReturn = IIf($rColCheckFullCCTroops = True Or ($iChkWaitForCastleTroops[$DB] = 0 And $iChkWaitForCastleTroops[$LB] = 0), IIf($iChkWaitForCastleSpell[$LB] = 1, IIf(String(GUICtrlRead($cmbABWaitForCastleSpell)) = "Any", "", String(GUICtrlRead($cmbABWaitForCastleSpell) & " Spell")), IIf($iChkWaitForCastleSpell[$DB] = 1, IIf(String(GUICtrlRead($cmbDBWaitForCastleSpell)) = "Any", "", String(GUICtrlRead($cmbDBWaitForCastleSpell) & " Spell")), "")), "")
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
	If _ColorCheck(_GetPixelColor(806, 472, True), Hex(0xD0E878, 6), 25) = False Then ; If no 'Edit Army' Button found in army tab to edit troops
		SetLog("Cannot find/verify 'Edit Army' Button in Army tab", $COLOR_ORANGE)
		Return False ; Exit function
	EndIf

	Click(Random(723, 812, 1), Random(469, 513, 1)) ; Click on Edit Army Button
	If $Runstate = False Then Return

	If _Sleep(500) Then Return

	Local $pos[2] = [575, 575], $pos2[2] = [645, 575]

		If $Slots[0] > 0 Then
			ClickRemoveTroop($pos, $Slots[0], $isldTrainITDelay) ; Click on Remove button as much as needed
		EndIf
		If $Slots[1] > 0 Then
			ClickRemoveTroop($pos2, $Slots[1], $isldTrainITDelay)
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

	If _Sleep(700) Then Return

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

Func CompareCCSpellWithGUI($CCSpell1, $CCSpell2)
	If Not $Runstate Then Return
	Local $sDBCCSpell, $sDBCCSpell2, $sABCCSpell, $sABCCSpell2
	Local $bCheckDBCCSpell, $bCheckDBCCSpell2, $bCheckABCCSpell, $bCheckABCCSpell2
	Local $aShouldRemove[2]

	$iDBCCSpell = $iCmbWaitForCastleSpell[$DB]
	$iDBCCSpell2 = $iCmbWaitForCastleSpell2[$DB]
	$iABCCSpell = $iCmbWaitForCastleSpell[$LB]
	$iABCCSpell2 = $iCmbWaitForCastleSpell2[$LB]


	If $iDBCCSpell = 0 And $iDBCCSpell2 = 0 And $iABCCSpell = 0 And $iABCCSpell2 = 0 Then Return

	If $iDBcheck = 1 And $iChkWaitForCastleSpell[$DB] = 1 Then
		$bCheckDBCCSpell = True
	EndIf
	If $iABcheck = 1 And $iChkWaitForCastleSpell[$LB] = 1 Then
		$bCheckABCCSpell = True
	EndIf


	If $bCheckDBCCSpell Then
		Switch $iDBCCSpell
			Case 0
				$bCheckDBCCSpell2 = True
			Case 1
				$sDBCCSpell = "LSpell"
				$iDBCCSpell2 = -1
			Case 2
				$sDBCCSpell = "HSpell"
				$iDBCCSpell2 = -1
			Case 3
				$sDBCCSpell = "RSpell"
				$iDBCCSpell2 = -1
			Case 4
				$sDBCCSpell = "JSpell"
				$iDBCCSpell2 = -1
			Case 5
				$sDBCCSpell = "Fpell"
				$iDBCCSpell2 = -1
			Case 6
				$sDBCCSpell = "PSpell"
				$bCheckDBCCSpell2 = True
			Case 7
				$sDBCCSpell = "ESpell"
				$bCheckDBCCSpell2 = True
			Case 8
				$sDBCCSpell = "HaSpell"
				$bCheckDBCCSpell2 = True
			Case 9
				$sDBCCSpell = "SkSpell"
				$bCheckDBCCSpell2 = True
		EndSwitch

		If $bCheckDBCCSpell2 Then
			Switch $iDBCCSpell2
				Case 1
					$sDBCCSpell2 = "PSpell"
				Case 2
					$sDBCCSpell2 = "ESpell"
				Case 3
					$sDBCCSpell2 = "HaSpell"
				Case 4
					$sDBCCSpell2 = "SkSpell"
			EndSwitch
		EndIf

		If $CCSpell2 = "" Then
			If $CCSpell1 = $sDBCCSpell And $iDBCCSpell < 6 And $iDBCCSpell > 0 Then
				Return
			Else
				$aShouldRemove[0] = 1
				Return $aShouldRemove
			EndIf
		ElseIf $CCSpell1[0][3] = 2 Then
			If ($CCSpell1[0][0] = $sDBCCSpell Or $iDBCCSpell = 0) And ($CCSpell1[0][0] = $sDBCCSpell2 Or $iDBCCSpell2 = 0) Then
				Return
			ElseIf $CCSpell1[0][0] =(( $sDBCCSpell Or $iDBCCSpell = 0) And ($CCSpell1[0][0] <> $sDBCCSpell2 And $iDBCCSpell2  <> 0)) Or (($CCSpell1[0][0] <> $sDBCCSpell And $iDBCCSpell <> 0) And ($CCSpell1[0][0] = $sDBCCSpell2 Or $iDBCCSpell2 = 0)) Then
				$aShouldRemove[0] = 1
				Return $aShouldRemove
			Else
				$aShouldRemove[0] = 2
				Return $aShouldRemove
			EndIf
		ElseIf $CCSpell1 <> "" And $CCSpell2 <> "" Then
			If ($CCSpell1[0][0] = $sDBCCSpell Or $iDBCCSpell = 0 Or ($CCSpell1[0][0] = $sDBCCSpell2 Or $iDBCCSpell2 = 0 And $CCSpell2[0][0] <> $sDBCCSpell2)) And (($CCSpell2[0][0] = $sDBCCSpell Or $iDBCCSpell = 0 And $CCSpell1[0][0] <> $sDBCCSpell) Or $CCSpell2[0][0] = $sDBCCSpell2 Or $iDBCCSpell2 = 0) Then
				Return
			ElseIf ($CCSpell1[0][0] <> $sDBCCSpell And $iDBCCSpell <> 0 And $CCSpell1[0][0] <> $sDBCCSpell2 And $iDBCCSpell2 <> 0) And ($CCSpell2[0][0] <> $sDBCCSpell And $iDBCCSpell <> 0 And $CCSpell2[0][0] <> $sDBCCSpell2 And $iDBCCSpell2 <> 0) Then
				$aShouldRemove[0] = 1
				$aShouldRemove[1] = 1
				Return $aShouldRemove
			ElseIf ($CCSpell1[0][0] <> $sDBCCSpell And $iDBCCSpell <> 0) And ($CCSpell1[0][0] <> $sDBCCSpell2 And $iDBCCSpell2 <> 0) Then
				$aShouldRemove[0] = 1
				Return $aShouldRemove
			ElseIf ($CCSpell2[0][0] <> $sDBCCSpell And $iDBCCSpell <> 0) And ($CCSpell2[0][0] <> $sDBCCSpell2 And $iDBCCSpell2 <> 0) Then
				$aShouldRemove[1] = 1
				Return $aShouldRemove
			EndIf
		EndIf

	EndIf

	If $bCheckABCCSpell Then
		Switch $iDBCCSpell
			Case 0
				$bCheckABCCSpell2 = True
			Case 1
				$sABCCSpell = "LSpell"
			Case 2
				$sABCCSpell = "HSpell"
			Case 3
				$sABCCSpell = "RSpell"
			Case 4
				$sABCCSpell = "JSpell"
			Case 5
				$sABCCSpell = "Fpell"
			Case 6
				$sABCCSpell = "PSpell"
				$bCheckABCCSpell2 = True
			Case 7
				$sABCCSpell = "ESpell"
				$bCheckABCCSpell2 = True
			Case 8
				$sABCCSpell = "HaSpell"
				$bCheckABCCSpell2 = True
			Case 9
				$sABCCSpell = "SkSpell"
				$bCheckABCCSpell2 = True
		EndSwitch

		If $bCheckABCCSpell2 Then
			Switch $iABCCSpell2
				Case 1
					$sABCCSpell2 = "PSpell"
				Case 2
					$sABCCSpell2 = "ESpell"
				Case 3
					$sABCCSpell2 = "HaSpell"
				Case 4
					$sABCCSpell2 = "SkSpell"
			EndSwitch
		EndIf

		If $CCSpell2 = "" Then
			If $CCSpell1 = $sABCCSpell And $iABCCSpell < 6 And $iABCCSpell > 0 Then
				Return
			Else
				$aShouldRemove[0] = 1
				Return $aShouldRemove
			EndIf
		ElseIf $CCSpell1[0][3] = 2 Then
			If ($CCSpell1[0][0] = $sABCCSpell Or $iABCCSpell = 0) And ($CCSpell1[0][0] = $sABCCSpell2 Or $iABCCSpell2 = 0) Then
				Return
			ElseIf $CCSpell1[0][0] =(( $sABCCSpell Or $iABCCSpell = 0) And ($CCSpell1[0][0] <> $sABCCSpell2 And $iABCCSpell2  <> 0)) Or (($CCSpell1[0][0] <> $sABCCSpell And $iABCCSpell <> 0) And ($CCSpell1[0][0] = $sABCCSpell2 Or $iABCCSpell2 = 0)) Then
				$aShouldRemove[0] = 1
				Return $aShouldRemove
			Else
				$aShouldRemove[0] = 2
				Return $aShouldRemove
			EndIf
		ElseIf $CCSpell1 <> "" And $CCSpell2 <> "" Then
			If ($CCSpell1[0][0] = $sABCCSpell Or $iABCCSpell = 0 Or ($CCSpell1[0][0] = $sABCCSpell2 Or $iABCCSpell2 = 0 And $CCSpell2[0][0] <> $sABCCSpell2)) And (($CCSpell2[0][0] = $sABCCSpell Or $iABCCSpell = 0 And $CCSpell1[0][0] <> $sABCCSpell) Or $CCSpell2[0][0] = $sABCCSpell2 Or $iABCCSpell2 = 0) Then
				Return
			ElseIf ($CCSpell1[0][0] <> $sABCCSpell And $iABCCSpell <> 0 And $CCSpell1[0][0] <> $sABCCSpell2 And $iABCCSpell2 <> 0) And ($CCSpell2[0][0] <> $sABCCSpell And $iABCCSpell <> 0 And $CCSpell2[0][0] <> $sABCCSpell2 And $iABCCSpell2 <> 0) Then
				$aShouldRemove[0] = 1
				$aShouldRemove[1] = 1
				Return $aShouldRemove
			ElseIf ($CCSpell1[0][0] <> $sABCCSpell And $iABCCSpell <> 0) And ($CCSpell1[0][0] <> $sABCCSpell2 And $iABCCSpell2 <> 0) Then
				$aShouldRemove[0] = 1
				Return $aShouldRemove
			ElseIf ($CCSpell2[0][0] <> $sABCCSpell And $iABCCSpell <> 0) And ($CCSpell2[0][0] <> $sABCCSpell2 And $iABCCSpell2 <> 0) Then
				$aShouldRemove[1] = 1
				Return $aShouldRemove
			EndIf
		EndIf
	EndIf


EndFunc   ;==>CompareCCSpellWithGUI

Func GetCurCCSpell($SpellNr)
	If $Runstate = False Then Return
	Local $directory = "armytspells-bundle"
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
		If $debugSetlog = 1 Then SetLog("GetCurCCSpell() called with the wrong argument!", $COLOR_ERROR)
		Return
	EndIf
	Local $res = SearchArmy($directory, $x1, $y1, $x2, $y2, "CCSpells", True)
	If ValidateSearchArmyResult($res) Then
		For $i = 0 To UBound($res) - 1
			Setlog(" - " & NameOfTroop(Eval("e" & $res[$i][0])), $COLOR_GREEN)
		Next
		Return $res
	EndIf
	Return ""
EndFunc   ;==>GetCurCCSpell

Func IsFullCastleTroops()
	Local $ToReturn = False
	If $Runstate = False Then Return
	If $iChkWaitForCastleTroops[$DB] = 0 And $iChkWaitForCastleTroops[$LB] = 0 Then
		$ToReturn = True
		Return $ToReturn
	EndIf

	Local Const $rColCheck = _ColorCheck(_GetPixelColor(24, 470, True), Hex(0x93C230, 6), 30)

	$ToReturn = (IIf($iDBcheck = 1, IIf($iChkWaitForCastleTroops[$DB] = 1, $rColCheck, True), 1) And IIf($iABcheck = 1, IIf($iChkWaitForCastleTroops[$LB] = 1, $rColCheck, True), 1))

	Return $ToReturn
EndFunc   ;==>IsFullCastleTroops

Func TrainUsingWhatToTrain($rWTT, $SpellsOnly = False)
	If $Runstate = False Then Return
	If $SpellsOnly = False Then
		If ISArmyWindow(False, $TrainTroopsTAB) = False Then OpenTrainTabNumber($TrainTroopsTAB)
	Else
		If ISArmyWindow(False, $BrewSpellsTAB) = False Then OpenTrainTabNumber($BrewSpellsTAB)
	EndIf
	; Loop through needed troops to Train
	Select
		Case $IsFullArmywithHeroesAndSpells = False
			For $i = 0 To (UBound($rWTT) - 1)
				If $Runstate = False Then Return
				If $rWTT[$i][1] > 0 Then ; If Count to Train Was Higher Than ZERO
					If IsSpellToBrew($rWTT[$i][0]) Then
						BrewUsingWhatToTrain($rWTT[$i][0], $rWTT[$i][1])
						ContinueLoop
					Else
						If $SpellsOnly = True Then ContinueLoop
					EndIf
					$NeededSpace = CalcNeededSpace($rWTT[$i][0], $rWTT[$i][1])
					$LeftSpace = LeftSpace()
					If $Runstate = False Then Return
					If $NeededSpace <= $LeftSpace Then ; If Needed Space was Equal Or Lower Than Left Space
						If DragIfNeeded($rWTT[$i][0]) = False Then
							Return False
						EndIf
						If CheckValuesCost("", $rWTT[$i][0], $rWTT[$i][1]) Then
							SetLog("Training " & $rWTT[$i][1] & "x " & NameOfTroop(Eval("e" & $rWTT[$i][0]), IIf($rWTT[$i][1] > 1, 1, 0)), $COLOR_GREEN)
							TrainIt(Eval("e" & $rWTT[$i][0]), $rWTT[$i][1], $isldTrainITDelay)
						Else
							SetLog("No resources to Train " & $rWTT[$i][1] & "x " & NameOfTroop(Eval("e" & $rWTT[$i][0]), IIf($rWTT[$i][1] > 1, 1, 0)), $COLOR_ORANGE)
						EndIf
					Else ; If Needed Space was Higher Than Left Space
						$CountToTrain = 0
						$CanAdd = True
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
						If CheckValuesCost("", $rWTT[$i][0], $CountToTrain) Then
							SetLog("Training " & $CountToTrain & "x " & NameOfTroop(Eval("e" & $rWTT[$i][0]), IIf($CountToTrain > 1, 1, 0)), $COLOR_GREEN)
							TrainIt(Eval("e" & $rWTT[$i][0]), $CountToTrain, $isldTrainITDelay)
						Else
							SetLog("No resources to Train " & $CountToTrain & "x " & NameOfTroop(Eval("e" & $rWTT[$i][0]), IIf($CountToTrain > 1, 1, 0)), $COLOR_ORANGE)
						EndIf
					EndIf
				EndIf
			Next
		Case $IsFullArmywithHeroesAndSpells = True
			For $i = 0 To (UBound($rWTT) - 1)
				If $Runstate = False Then Return
				If $rWTT[$i][1] > 0 Then ; If Count to Train Was Higher Than ZERO
					If IsSpellToBrew($rWTT[$i][0]) Then
						BrewUsingWhatToTrain($rWTT[$i][0], $rWTT[$i][1])
						ContinueLoop
					Else
						If $SpellsOnly = True Then ContinueLoop
					EndIf
					$NeededSpace = CalcNeededSpace($rWTT[$i][0], $rWTT[$i][1])
					$LeftSpace = LeftSpace(True)
					If $Runstate = False Then Return
					$LeftSpace = ($LeftSpace[1] * 2) - $LeftSpace[0]
					If $NeededSpace <= $LeftSpace Then ; If Needed Space was Equal Or Lower Than Left Space
						If DragIfNeeded($rWTT[$i][0]) = False Then
							Return False
						EndIf
						If CheckValuesCost("", $rWTT[$i][0], $rWTT[$i][1]) Then
							SetLog("Training " & $rWTT[$i][1] & "x " & NameOfTroop(Eval("e" & $rWTT[$i][0]), IIf($rWTT[$i][1] > 1, 1, 0)), $COLOR_GREEN)
							TrainIt(Eval("e" & $rWTT[$i][0]), $rWTT[$i][1], $isldTrainITDelay)
						Else
							SetLog("No resources to Train " & $rWTT[$i][1] & "x " & NameOfTroop(Eval("e" & $rWTT[$i][0]), IIf($rWTT[$i][1] > 1, 1, 0)), $COLOR_ORANGE)
						EndIf
					Else ; If Needed Space was Higher Than Left Space
						$CountToTrain = 0
						$CanAdd = True
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
						If CheckValuesCost("", $rWTT[$i][0], $CountToTrain) Then
							SetLog("Training " & $CountToTrain & "x " & NameOfTroop(Eval("e" & $rWTT[$i][0]), IIf($CountToTrain > 1, 1, 0)), $COLOR_GREEN)
							TrainIt(Eval("e" & $rWTT[$i][0]), $CountToTrain, $isldTrainITDelay)
						Else
							SetLog("No resources to Train " & $CountToTrain & "x " & NameOfTroop(Eval("e" & $rWTT[$i][0]), IIf($CountToTrain > 1, 1, 0)), $COLOR_ORANGE)
						EndIf
					EndIf
				EndIf
			Next
	EndSelect

	Return True
EndFunc   ;==>TrainUsingWhatToTrain

Func BrewUsingWhatToTrain($Spell, $Quantity) ; it's job is a bit different with 'TrainUsingWhatToTrain' Function, It's being called by TrainusingWhatToTrain Func
	If $Quantity <= 0 Then Return False
	If $Quantity = 9999 Then
		SetLog("Brewing " & NameOfTroop(Eval("e" & $Spell)) & " Cancelled " & @CRLF & _
				"                  Reason: Enough as set in GUI " & @CRLF & _
				"                               This Spell not used in Attack")
		Return True
	EndIf
	If $Runstate = False Then Return
	If ISArmyWindow(False, $BrewSpellsTAB) = False Then OpenTrainTabNumber($BrewSpellsTAB)

	;If IsQueueEmpty(-1, True) = False Then Return True
	Select
		Case $IsFullArmywithHeroesAndSpells = False
			If _ColorCheck(_GetPixelColor(230, 208, True), Hex(0x677CB5, 6), 30) = False Then RemoveExtraTroopsQueue()
			$NeededSpace = CalcNeededSpace($Spell, $Quantity)
			$LeftSpace = LeftSpace()
			If $Runstate = False Then Return
			If $NeededSpace <= $LeftSpace Then ; If Needed Space was Equal Or Lower Than Left Space
				If CheckValuesCost("", $Spell, $Quantity) Then
					SetLog("Brewing " & $Quantity & "x " & NameOfTroop(Eval("e" & $Spell), IIf($Quantity > 1, 1, 0)), $COLOR_GREEN)
					TrainIt(Eval("e" & $Spell), $Quantity, $isldTrainITDelay)
				Else
					SetLog("No resources to Brew " & $Quantity & "x " & NameOfTroop(Eval("e" & $Spell), IIf($Quantity > 1, 1, 0)), $COLOR_ORANGE)
				EndIf

				#CS Else ; If Needed Space was Higher Than Left Space
					$CountToBrew = 0
					$CanAdd = True
					Do
					$NeededSpace = CalcNeededSpace($Spell, $CountToBrew)
					If $NeededSpace <= $LeftSpace Then
					$CountToBrew += 1
					Else
					$CanAdd = False
					EndIf
					Until $CanAdd = False
					If $CountToBrew > 0 Then
					SetLog("Brewing " & $CountToBrew & "x " & NameOfTroop(Eval("e" & $Spell), IIf($CountToBrew > 1, 1, 0)), $COLOR_GREEN)
					TrainIt(Eval("e" & $Spell), $CountToBrew, $isldTrainITDelay)
					EndIf
				#CE
			EndIf
		Case $IsFullArmywithHeroesAndSpells = True
			$NeededSpace = CalcNeededSpace($Spell, $Quantity)
			$LeftSpace = LeftSpace(True)
			If $Runstate = False Then Return
			$LeftSpace = ($LeftSpace[1] * 2) - $LeftSpace[0]
			If $NeededSpace <= $LeftSpace Then ; If Needed Space was Equal Or Lower Than Left Space
				If CheckValuesCost("", $Spell, $Quantity) Then
					SetLog("Brewing " & $Quantity & "x " & NameOfTroop(Eval("e" & $Spell), IIf($Quantity > 1, 1, 0)), $COLOR_GREEN)
					TrainIt(Eval("e" & $Spell), $Quantity, $isldTrainITDelay)
				Else
					SetLog("No resources to Brew " & $Quantity & "x " & NameOfTroop(Eval("e" & $Spell), IIf($Quantity > 1, 1, 0)), $COLOR_ORANGE)
				EndIf
				#CS Else ; If Needed Space was Higher Than Left Space
					$CountToBrew = 0
					$CanAdd = True
					Do
					$NeededSpace = CalcNeededSpace($Spell, $CountToBrew)
					If $NeededSpace <= $LeftSpace Then
					$CountToBrew += 1
					Else
					$CanAdd = False
					EndIf
					Until $CanAdd = False
					If $CountToBrew > 0 Then
					SetLog("Brewing " & $CountToBrew & "x " & NameOfTroop(Eval("e" & $Spell), IIf($CountToBrew > 1, 1, 0)), $COLOR_GREEN)
					TrainIt(Eval("e" & $Spell), $CountToBrew, $isldTrainITDelay)
					EndIf
				#CE
			EndIf
	EndSelect
EndFunc   ;==>BrewUsingWhatToTrain

Func TotalSpellsToBrewInGUI()
	Local $ToReturn = 0
	If $iTotalCountSpell = 0 Then Return $ToReturn
	If $Runstate = False Then Return
	For $i = 0 To (UBound($SpellName) - 1)
		$ToReturn += Number(Number(Eval($SpellName[$i] & "Comp") * $SpellHeight[$i]))
	Next
	Return $ToReturn
EndFunc   ;==>TotalSpellsToBrewInGUI

Func HowManyTimesWillBeUsed($Spell) ;ONLY ONLY ONLY FOR SPELLS, TO SEE IF NEEDED TO BREW, DON'T USE IT TO GET EXACT COUNT
	Local $ToReturn = -1
	If $Runstate = False Then Return

	If $ichkForceBrewBeforeAttack = 1 Then ; If Force Brew Spells Before Attack Is Enabled
		$ToReturn = 2
		Return $ToReturn
	EndIf

	; Code For DeadBase
	If $iDBcheck = 1 Then
		If $iAtkAlgorithm[$DB] = 1 Then ; Scripted Attack is Selected
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
	If $iABcheck = 1 Then
		If $iAtkAlgorithm[$LB] = 1 Then ; Scripted Attack is Selected
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
	If $Runstate = False Then Return
	If $Mode = $DB Then
		$filename = $scmbDBScriptName
	Else
		$filename = $scmbABScriptName
	EndIf

	Local $rownum = 0
	If FileExists($dirAttacksCSV & "\" & $filename & ".csv") Then
		Local $f, $line, $acommand, $command
		Local $value1, $Troop
		$f = FileOpen($dirAttacksCSV & "\" & $filename & ".csv", 0)
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
	Else
		$ToReturn = 0
	EndIf
	Return $ToReturn
EndFunc   ;==>CountCommandsForSpell

Func IsGUICheckedForSpell($Spell, $Mode)
	Local $sSpell = "", $iVal

	If $Runstate = False Then Return
	Switch Eval("e" & $Spell)
		Case $eLSpell
			$sSpell = "Light"
		Case $eHSpell
			$sSpell = "Heal"
		Case $eRSpell
			$sSpell = "Rage"
		Case $eJSpell
			$sSpell = "Jump"
		Case $eFSpell
			$sSpell = "Freeze"
		Case $ePSpell
			$sSpell = "Poison"
		Case $eESpell
			$sSpell = "Earthquake"
		Case $eHaSpell
			$sSpell = "Haste"
	EndSwitch

	$iVal = Execute("$ichk" & $sSpell & "Spell")

	If IsArray($iVal) Then Return (($iVal[$Mode] = 1) ? True : False)
	Return False
EndFunc   ;==>IsGUICheckedForSpell

Func DragIfNeeded($Troop)

	If $Runstate = False Then Return
	Local $rCheckPixel = False

	If IsDarkTroop($Troop) Then
		If _ColorCheck(_GetPixelColor(834, 403, True), Hex(0xD3D3CB, 6), 5) then $rCheckPixel = True
		If $debugsetlogTrain then Setlog("DragIfNeeded Dark Troops: " & $rCheckPixel)
		For $i = 1 To 3
			If $rCheckPixel = False Then
				ClickDrag(715, 445 + $midOffsetY, 220, 445 + $midOffsetY, 2000)
				If _Sleep(1500) Then Return
				If _ColorCheck(_GetPixelColor(834, 403, True), Hex(0xD3D3CB, 6), 5) then $rCheckPixel = True
			Else
				Return True
			EndIf
		Next
	Else
		If _ColorCheck(_GetPixelColor(22, 403, True), Hex(0xD3D3CB, 6), 5) then $rCheckPixel = True
		If $debugsetlogTrain then Setlog("DragIfNeeded Normal Troops: " & $rCheckPixel)
		For $i = 1 To 3
			If $rCheckPixel = False Then
				ClickDrag(220, 445 + $midOffsetY, 725, 445 + $midOffsetY, 2000)
				If _Sleep(1500) Then Return
				If _ColorCheck(_GetPixelColor(22, 403, True), Hex(0xD3D3CB, 6), 5) then $rCheckPixel = True
			Else
				Return True
			EndIf
		Next
	EndIf
	SetLog("Failed to Verify Troop " & NameOfTroop(Eval("e" & $Troop)) & " Position or Failed to Drag Successfully", $COLOR_RED)
	Return False
EndFunc   ;==>DragIfNeeded

Func DoWhatToTrainContainSpell($rWTT)
	For $i = 0 To (UBound($rWTT) - 1)
		If $Runstate = False Then Return
		If IsSpellToBrew($rWTT[$i][0]) Then
			If $rWTT[$i][1] > 0 Then Return True
		EndIf
	Next
	Return False
EndFunc   ;==>DoWhatToTrainContainSpell

Func IsElixirTroop($Troop)
	For $i = 0 To (UBound($TroopName) - 1)
		If $Runstate = False Then Return
		If $Troop = $TroopName[$i] And $TroopType[$i] = "e" Then Return True
	Next
	Return False
EndFunc   ;==>IsElixirTroop

Func IsDarkTroop($Troop)
	For $i = 0 To (UBound($TroopName) - 1)
		If $Runstate = False Then Return
		If $Troop = $TroopName[$i] And $TroopType[$i] = "d" Then Return True
	Next
	Return False
EndFunc   ;==>IsDarkTroop

Func IsSpellToBrew($Spell)
	For $i = 0 To (UBound($SpellName) - 1)
		If $Runstate = False Then Return
		If $Spell = $SpellName[$i] Then Return True
	Next
	Return False
EndFunc   ;==>IsSpellToBrew

Func CalcNeededSpace($Troop, $Quantity)
	For $i = 0 To (UBound($TroopName) - 1)
		If $Runstate = False Then Return
		If $Troop = $TroopName[$i] Then
			$THeight = $TroopHeight[$i]
			Return Number($THeight * $Quantity)
		EndIf
	Next
	; For Spells Only, If didn't found as a troop
	For $i = 0 To (UBound($SpellName) - 1)
		If $Runstate = False Then Return
		If $Troop = $SpellName[$i] Then
			$THeight = $SpellHeight[$i]
			Return Number($THeight * $Quantity)
		EndIf
	Next
	Return -1
EndFunc   ;==>CalcNeededSpace

Func RemoveExtraTroops($toRemove)
	; Army Window should be open and should be in Tab 'Army tab'

	; 1 Means Removed Troops without Deleting Troops Queued
	; 2 Means Removed Troops And Also Deleted Troops Queued
	; 3 Means Didn't removed troop... Everything was well
	Local $ToReturn = 0

	If UBound($toRemove) = 1 And $toRemove[0][0] = "Arch" And $toRemove[0][1] = 0 Then ; If was default Result of WhatToTrain
		$ToReturn = 3
		Return $ToReturn
	EndIf

	;If $IsFullArmywithHeroesAndSpells = True Or $fullarmy = True Or ($CommandStop = 3 Or $CommandStop = 0) = True And Not $bDonateTrain Then
	If $IsFullArmywithHeroesAndSpells = True Or $fullarmy = True Or ($CommandStop = 3 Or $CommandStop = 0) = True And Not $bActiveDonate Then
		$ToReturn = 3
		Return $ToReturn
	EndIf

	If UBound($toRemove) > 0 Then ; If needed to remove troops
		Local $rGetSlotNumber = GetSlotNumber() ; Get all available Slot numbers with troops assigned on them
		Local $rGetSlotNumberSpells = GetSlotNumber(True) ; Get all available Slot numbers with Spells assigned on them

		; Check if Troops to remove are already in Train Tab Queue!! If was, Will Delete All Troops Queued Then Check Everything Again...
		OpenTrainTabNumber($TrainTroopsTAB)
		$CounterToRemove = 0
		For $i = 0 To (UBound($toRemove) - 1)
			If $Runstate = False Then Return
			If IsSpellToBrew($toRemove[$i][0]) Then ExitLoop
			$CounterToRemove += 1
			If IsAlreadyTraining($toRemove[$i][0]) Then
				SetLog(NameOfTroop(Eval("e" & $toRemove[$i][0])) & " Is in Train Tab Queue By Mistake!", $COLOR_BLUE)
				DeleteQueued("Troops")
				$ToReturn = 2
			EndIf
		Next

		If TotalSpellsToBrewInGUI() > 0 Then
			OpenTrainTabNumber($BrewSpellsTAB)
			For $i = $CounterToRemove To (UBound($toRemove) - 1)
				If $Runstate = False Then Return
				If IsAlreadyTraining($toRemove[$i][0], True) Then
					SetLog(NameOfTroop(Eval("e" & $toRemove[$i][0])) & " Is in Spells Tab Queue By Mistake!", $COLOR_BLUE)
					DeleteQueued("Spells")
					$ToReturn = 2
				EndIf
			Next
		EndIf

		OpenTrainTabNumber($ArmyTAB)
		$toRemove = WhatToTrain(True, False)

		$rGetSlotNumber = GetSlotNumber() ; Get all available Slot numbers with troops assigned on them
		$rGetSlotNumberSpells = GetSlotNumber(True)

		SetLog("Troops To Remove: ", $COLOR_GREEN)
		$CounterToRemove = 0
		; Loop through Troops needed to get removed Just to write some Logs
		For $i = 0 To (UBound($toRemove) - 1)
			If IsSpellToBrew($toRemove[$i][0]) Then ExitLoop
			$CounterToRemove += 1
			SetLog("  " & NameOfTroop(Eval("e" & $toRemove[$i][0])) & ": " & $toRemove[$i][1] & "x", $COLOR_GREEN)
		Next

		If TotalSpellsToBrewInGUI() > 0 Then
			If $CounterToRemove <= UBound($toRemove) Then
				SetLog("Spells To Remove: ", $COLOR_GREEN)
				For $i = $CounterToRemove To (UBound($toRemove) - 1)
					SetLog("  " & NameOfTroop(Eval("e" & $toRemove[$i][0])) & ": " & $toRemove[$i][1] & "x", $COLOR_GREEN)
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
					$pos = GetSlotRemoveBtnPosition($i + 1) ; Get positions of - Button to remove troop
					ClickRemoveTroop($pos, $toRemove[$j][1], $isldTrainITDelay) ; Click on Remove button as much as needed
				EndIf
			Next
		Next

		If TotalSpellsToBrewInGUI() > 0 Then
			For $j = $CounterToRemove To (UBound($toRemove) - 1)
				For $i = 0 To (UBound($rGetSlotNumberSpells) - 1) ; Loop through All available slots
					; $toRemove[$j][0] = Troop name, E.g: Barb, $toRemove[$j][1] = Quantity to remove
					If $toRemove[$j][0] = $rGetSlotNumberSpells[$i] Then ; If $toRemove Troop Was the same as The Slot Troop
						$pos = GetSlotRemoveBtnPosition($i + 1, True) ; Get positions of - Button to remove troop
						ClickRemoveTroop($pos, $toRemove[$j][1], $isldTrainITDelay) ; Click on Remove button as much as needed
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
		If $Runstate = False Then Return
		Click(Random(720, 815, 1), Random(558, 589, 1)) ; Click on 'Okay' button to save changes

		If _Sleep(700) Then Return

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
			$Counter = 0
			For $i = 0 To (UBound($Array) - 1)
				If (Eval("e" & $Array[$i][0]) = "" And Eval("e" & $Array[$i][0]) <> 0) Or $Array[$i][0] = "" Then
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
			Next
			ReDim $Array[$Counter][$2DBound]
		Case Else
			$Counter = 0
			For $i = 0 To (UBound($Array) - 1)
				If (Eval("e" & $Array[$i]) = "" And Eval("e" & $Array[$i]) <> 0) Or $Array[$i] = "" Then
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
	If $IsFullArmywithHeroesAndSpells = True Then Return True

	Local Const $y = 259, $yRemoveBtn = 200, $xDecreaseRemoveBtn = 10
	Local $rColCheck = ""
	Local $Removed = False
	For $x = 834 To 58 Step -70
		If $Runstate = False Then Return
		$rColCheck = _ColorCheck(_GetPixelColor($x, $y, True), Hex(0xD7AFA9, 6), 20)
		If $rColCheck = True Then
			$Removed = True
			Do
				Click($x - $xDecreaseRemoveBtn, $yRemoveBtn, 2, $isldTrainITDelay)
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
	If $Runstate = False Then Return
	Select
		Case $Spells = False
			If IsQueueEmpty($TrainTroopsTAB) Then Return False ; If No troops were in Queue

			Local $QueueTroops = CheckQueueTroops(False, False) ; Get Troops that they're currently training...
			For $i = 0 To (UBound($QueueTroops) - 1)
				If $QueueTroops[$i] = $Troop Then Return True
			Next

			Return False
		Case $Spells = True
			If IsQueueEmpty($BrewSpellsTAB, False, IIf($ichkForceBrewBeforeAttack = 1, False, True)) Then Return False ; If No Spells were in Queue

			Local $QueueSpells = CheckQueueSpells(False, False) ; Get Troops that they're currently training...
			For $i = 0 To (UBound($QueueSpells) - 1)
				If $QueueSpells[$i] = $Troop Then Return True
			Next

			Return False
	EndSelect

EndFunc   ;==>IsAlreadyTraining

Func IsQueueEmpty($Tab = -1, $bSkipTabCheck = False, $removeExtraTroopsQueue = True)
	If $Runstate = False Then Return
	If $bSkipTabCheck = False Then
		If $Tab = -1 Then $Tab = $TrainTroopsTAB
		If ISArmyWindow(False, $Tab) = False Then OpenTrainTabNumber($Tab)
	EndIf

	If $IsFullArmywithHeroesAndSpells = False Then
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
	If $Runstate = False Then Return
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
			For $i = 0 To (UBound($TroopName) - 1)
				If $Runstate = False Then Return
				If Number(Eval("Cur" & $TroopName[$i])) > 0 Then
					For $j = 0 To (UBound($Orders) - 1)
						If Eval("e" & $TroopName[$i]) = $Orders[$j] Then
							$allCurTroops[$j] = $TroopName[$i]
						EndIf
					Next
				EndIf
			Next

			#CS		This Codes Not Needed With New 'True' Train Order and new Training System ;)
				; Code for DARK Elixir Troops to Put Current Troops into an array by Order
				For $i = 0 To (UBound($TroopDarkName) - 1)
				If $Runstate = False Then Return
				If Number(Eval("Cur" & $TroopDarkName[$i])) > 0 Then
				For $j = 0 To (UBound($Orders) - 1)
				If Eval("e" & $TroopDarkName[$i]) = $Orders[$j] Then
				$allCurTroops[$j] = $TroopDarkName[$i]
				EndIf
				Next
				EndIf
				Next
			#CE

			_ArryRemoveBlanks($allCurTroops)

			Return $allCurTroops
		Case $Spells = True

			; Set Order of Spells display in Army Tab
			Local Const $SpellsOrders[10] = [$eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell]

			Local $allCurSpells[UBound($SpellsOrders)]

			; Code for Spells to Put Current Spells into an array by Order
			For $i = 0 To (UBound($SpellName) - 1)
				If $Runstate = False Then Return
				If Number(Eval("Cur" & $SpellName[$i])) > 0 Then
					For $j = 0 To (UBound($SpellsOrders) - 1)
						If Eval("e" & $SpellName[$i]) = $SpellsOrders[$j] Then
							$allCurSpells[$j] = $SpellName[$i]
						EndIf
					Next
				EndIf
			Next

			_ArryRemoveBlanks($allCurSpells)

			Return $allCurSpells
	EndSelect
EndFunc   ;==>GetSlotNumber

Func WhatToTrain($ReturnExtraTroopsOnly = False, $showlog = True)
	If ISArmyWindow(False, $ArmyTAB) = False Then OpenTrainTabNumber($ArmyTAB)
	Local $ToReturn[1][2] = [["Arch", 0]]

	; Get Current available troops
	CheckExistentArmy("Troops", False)
	CheckExistentArmy("Spells", False)

	If $IsFullArmywithHeroesAndSpells And $ReturnExtraTroopsOnly = False Then
		If $CommandStop = 3 Or $CommandStop = 0 Then
			If $FirstStart Then $FirstStart = False
			Return $ToReturn
		EndIf
		Setlog(" - Your Army is Full, let's make troops before Attack!")
		; Elixir Troops
		For $i = 0 To (UBound($TroopName) - 1)
			If Number(Eval($TroopName[$i] & "Comp")) > 0 Then
				$ToReturn[UBound($ToReturn) - 1][0] = $TroopName[$i]
				$ToReturn[UBound($ToReturn) - 1][1] = Number(Eval($TroopName[$i] & "Comp"))
				ReDim $ToReturn[UBound($ToReturn) + 1][2]
			EndIf
		Next
		#CS		This Codes Not Needed With New 'True' Train Order and new Training System ;)
			; Dark Troops
			For $i = 0 To (UBound($TroopDarkName) - 1)
			If Number(Eval($TroopDarkName[$i] & "Comp")) > 0 Then
			$ToReturn[UBound($ToReturn) - 1][0] = $TroopDarkName[$i]
			$ToReturn[UBound($ToReturn) - 1][1] = Number(Eval($TroopDarkName[$i] & "Comp"))
			ReDim $ToReturn[UBound($ToReturn) + 1][2]
			EndIf
			Next
		#CE
		; Spells
		For $i = 0 To (UBound($SpellName) - 1)
			If $Runstate = False Then Return
			If TotalSpellsToBrewInGUI() = 0 Then ExitLoop
			If Number(Eval($SpellName[$i] & "Comp")) > 0 Then
				If HowManyTimesWillBeUsed($SpellName[$i]) > 0 Then
					$ToReturn[UBound($ToReturn) - 1][0] = $SpellName[$i]
					$ToReturn[UBound($ToReturn) - 1][1] = Number(Eval($SpellName[$i] & "Comp"))
					ReDim $ToReturn[UBound($ToReturn) + 1][2]
				Else
					CheckExistentArmy("Spells", False)
					If Number(Number(Eval($SpellName[$i] & "Comp")) - Number(Eval("Cur" & $SpellName[$i]))) > 0 Then
						$ToReturn[UBound($ToReturn) - 1][0] = $SpellName[$i]
						$ToReturn[UBound($ToReturn) - 1][1] = Number(Number(Eval($SpellName[$i] & "Comp")) - Number(Eval("Cur" & $SpellName[$i])))
						ReDim $ToReturn[UBound($ToReturn) + 1][2]
					Else
						$ToReturn[UBound($ToReturn) - 1][0] = $SpellName[$i]
						$ToReturn[UBound($ToReturn) - 1][1] = 9999
						ReDim $ToReturn[UBound($ToReturn) + 1][2]
					EndIf
				EndIf
			EndIf
		Next
		Return $ToReturn
	EndIf

	Switch $ReturnExtraTroopsOnly
		Case False
			; Check Elixir Troops needed quantity to Train
			For $i = 0 To (UBound($TroopName) - 1)
				If $Runstate = False Then Return
				If Number(Eval($TroopName[$i] & "Comp")) > 0 Then
					$ToReturn[UBound($ToReturn) - 1][0] = $TroopName[$i]
					$ToReturn[UBound($ToReturn) - 1][1] = Number(Number(Eval($TroopName[$i] & "Comp")) - Number(Eval("Cur" & $TroopName[$i])))
					ReDim $ToReturn[UBound($ToReturn) + 1][2]
				EndIf
			Next

			#CS		This Codes Not Needed With New 'True' Train Order and new Training System ;)
				; Check DARK Elixir Troops needed quantity to Train
				For $i = 0 To (UBound($TroopDarkName) - 1)
				If $Runstate = False Then Return
				If Number(Eval($TroopDarkName[$i] & "Comp")) > 0 Then
				$ToReturn[UBound($ToReturn) - 1][0] = $TroopDarkName[$i]
				$ToReturn[UBound($ToReturn) - 1][1] = Number(Number(Eval($TroopDarkName[$i] & "Comp")) - Number(Eval("Cur" & $TroopDarkName[$i])))
				ReDim $ToReturn[UBound($ToReturn) + 1][2]
				EndIf
				Next
			#CE

			; Check Spells needed quantity to Brew
			For $i = 0 To (UBound($SpellName) - 1)
				If $Runstate = False Then Return
				If TotalSpellsToBrewInGUI() = 0 Then ExitLoop
				If Number(Eval($SpellName[$i] & "Comp")) > 0 Then
					$ToReturn[UBound($ToReturn) - 1][0] = $SpellName[$i]
					$ToReturn[UBound($ToReturn) - 1][1] = Number(Number(Eval($SpellName[$i] & "Comp")) - Number(Eval("Cur" & $SpellName[$i])))
					ReDim $ToReturn[UBound($ToReturn) + 1][2]
				EndIf
			Next
		Case Else
			; Check Elixir Troops Extra Quantity
			For $i = 0 To (UBound($TroopName) - 1)
				If $Runstate = False Then Return
				If Number(Eval("Cur" & $TroopName[$i])) > 0 Then
					If StringInStr(Number(Number(Eval($TroopName[$i] & "Comp")) - Number(Eval("Cur" & $TroopName[$i]))), "-") > 0 Then
						$ToReturn[UBound($ToReturn) - 1][0] = $TroopName[$i]
						$ToReturn[UBound($ToReturn) - 1][1] = StringReplace(Number(Number(Eval($TroopName[$i] & "Comp")) - Number(Eval("Cur" & $TroopName[$i]))), "-", "")
						ReDim $ToReturn[UBound($ToReturn) + 1][2]
					EndIf
				EndIf
			Next

			#CS		This Codes Not Needed With New 'True' Train Order and new Training System ;)
				; Check DARK Elixir Troops Extra Quantity
				For $i = 0 To (UBound($TroopDarkName) - 1)
				If $Runstate = False Then Return
				If Number(Eval("Cur" & $TroopDarkName[$i])) > 0 Then
				If StringInStr(Number(Number(Eval($TroopDarkName[$i] & "Comp")) - Number(Eval("Cur" & $TroopDarkName[$i]))), "-") > 0 Then
				$ToReturn[UBound($ToReturn) - 1][0] = $TroopDarkName[$i]
				$ToReturn[UBound($ToReturn) - 1][1] = StringReplace(Number(Number(Eval($TroopDarkName[$i] & "Comp")) - Number(Eval("Cur" & $TroopDarkName[$i]))), "-", "")
				ReDim $ToReturn[UBound($ToReturn) + 1][2]
				EndIf
				EndIf
				Next
			#CE

			; Check Spells Extra Quantity
			For $i = 0 To (UBound($SpellName) - 1)
				If $Runstate = False Then Return
				If TotalSpellsToBrewInGUI() = 0 Then ExitLoop
				If Number(Eval("Cur" & $SpellName[$i])) > 0 Then
					If StringInStr(Number(Number(Eval($SpellName[$i] & "Comp")) - Number(Eval("Cur" & $SpellName[$i]))), "-") > 0 Then
						$ToReturn[UBound($ToReturn) - 1][0] = $SpellName[$i]
						$ToReturn[UBound($ToReturn) - 1][1] = StringReplace(Number(Number(Eval($SpellName[$i] & "Comp")) - Number(Eval("Cur" & $SpellName[$i]))), "-", "")
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
	$Runstate = True
	For $i = 0 To UBound($TroopName) - 1
		DragIfNeeded($TroopName[$i])
		TrainIt(Eval("e" & $TroopName[$i]), $iCount, $isldTrainITDelay)
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
		ClickDrag(616, 445 + $midOffsetY, 400, 445 + $midOffsetY, 2000)
		If _Sleep(1500) Then Return
		TrainIt($eMini, $iCount, 300)
		TrainIt($eHogs, $iCount, 300)
		TrainIt($eValk, $iCount, 300)
		TrainIt($eGole, $iCount, 300)
		TrainIt($eWitc, $iCount, 300)
		TrainIt($eLava, $iCount, 300)
		TrainIt($eBowl, $iCount, 300)
	#CE
	$Runstate = False
EndFunc   ;==>TestTroopsCoords

Func TestSpellsCoords()
	$Runstate = True

	Local $iCount = 1
	;CheckForSantaSpell()
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

	$Runstate = False
EndFunc   ;==>TestSpellsCoords

Func LeftSpace($ReturnAll = False)
	; Need to be in 'Train Tab'
	$RemainTrainSpace = GetOCRCurrent(48, 160)
	If $Runstate = False Then Return
	;_ArrayDisplay($RemainTrainSpace, "$RemainTrainSpace")
	If $ReturnAll = False Then
		Return Number($RemainTrainSpace[2])
	Else
		Return $RemainTrainSpace
	EndIf
EndFunc   ;==>LeftSpace

Func OpenArmyWindow()

	ClickP($aAway, 2, 0, "#0346") ;Click Away
	If $Runstate = False Then Return
	If _Sleep($iDelayRunBot3) Then Return ; wait for window to open
	If IsMainPage() = False Then ; check for main page, avoid random troop drop
		SetLog("Can not open Army Overview window", $COLOR_RED)
		SetError(1)
		Return False
	EndIf

	If WaitforPixel(31, 515 + $bottomOffsetY, 33, 517 + $bottomOffsetY, Hex(0xF8F0E0, 6), 10, 20) Then
		If _Sleep($iDelayTrain4) Then Return ; wait before click
		If $debugsetlogTrain = 1 Then SetLog("Click $aArmyTrainButton", $COLOR_GREEN)
		If $iUseRandomClick = 0 Then
			Click($aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0, "#0293") ; Button Army Overview
		Else
			ClickR($aArmyTrainButtonRND, $aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0)
		EndIf
	EndIf

	If _Sleep($iDelayTrain4) Then Return ; wait for window to open

	Local $x = 0
	While ISArmyWindow(False, $ArmyTAB) = False
		If _sleep($iDelayTrain4) Then Return
		$x += 1
		If $x = 5 And IsMainPage() Then
			If _Sleep($iDelayTrain4) Then Return ; wait before click
			If $debugsetlogTrain = 1 Then SetLog("Click $aArmyTrainButton", $COLOR_GREEN)
			If $iUseRandomClick = 0 Then
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
		If $Runstate = False Then Return
		If _CheckPixel($_aIsTrainPgChk1, True) And _CheckPixel($_aIsTrainPgChk2, True) And _CheckPixel($CheckIT, True) Then ExitLoop
		If _Sleep($iDelayIsTrainPage1) Then ExitLoop
		$i += 1
	WEnd

	If $i <= 28 Then
		If ($debugSetlog = 1 Or $DebugClick = 1) And $writelogs = True Then Setlog("**Train Window OK**", $COLOR_DEBUG) ;Debug
		Return True
	Else
		If $writelogs = True Then SetLog("Cannot find train Window | TAB " & $TabNumber, $COLOR_RED) ; in case of $i = 29 in while loop
		If $debugImageSave = 1 Then DebugImageSave("IsTrainPage_")
		Return False
	EndIf

EndFunc   ;==>ISArmyWindow

Func CheckExistentArmy($txt = "", $showlog = True)

	If ISArmyWindow(False, $ArmyTAB) = False Then
		OpenArmyWindow()
		If _Sleep(1500) Then Return
	EndIf

	;$iHeroAvailable = $HERO_NOHERO ; Reset hero available data

	If $txt = "Troops" Then
		ResetVariables("Troops")
		ResetDropTrophiesVariable()
		Local $directory = @ScriptDir & "\imgxml\ArmyTroops" ; "armytroops-bundle"
		Local $x = 23, $y = 215, $x1 = 840, $y1 = 255
	EndIf
	If $txt = "Spells" Then
		ResetVariables("Spells")
		Local $directory = "armytspells-bundle"
		Local $x = 23, $y = 366, $x1 = 585, $y1 = 400
	EndIf
	If $txt = "Heroes" Then
		Local $directory = "armyheroes-bundle"
		Local $x = 610, $y = 366, $x1 = 830, $y1 = 400
	EndIf

	Local $result = SearchArmy($directory, $x, $y, $x1, $y1, $txt)

	If UBound($result) > 0 Then
		For $i = 0 To UBound($result) - 1
			If $Runstate = False Then Return
			Local $Plural = 0
			If $result[$i][0] <> "" Then
				If $result[$i][3] > 1 Then $Plural = 1
				If StringInStr($result[$i][0], "queued") Then
					$result[$i][0] = StringTrimRight($result[$i][0], 6)
					;[&i][0] = Troops name | [&i][1] = X coordinate | [&i][2] = Y coordinate | [&i][3] = Quantities
					If $txt = "Troops" Then
						If $showlog = True Then Setlog(" - " & $result[$i][3] & " " & NameOfTroop(Eval("e" & $result[$i][0]), $Plural) & " Queued", $COLOR_BLUE)
						Assign("Cur" & $result[$i][0], Eval("Cur" & $result[$i][0]) + $result[$i][3])
					EndIf
					If $txt = "Spells" Then
						If $result[$i][3] = 0 Then
							If $showlog = True Then SetLog(" - No Spells are Brewed", $COLOR_BLUE)
						Else
							If $showlog = True Then Setlog(" - " & $result[$i][3] & " " & NameOfTroop(Eval("e" & $result[$i][0]), $Plural) & " Brewed", $COLOR_BLUE)
							Assign("Cur" & $result[$i][0], Eval("Cur" & $result[$i][0]) + $result[$i][3])
						EndIf
					EndIf
					If $txt = "Heroes" Then
						If ArmyHeroStatus(Eval("e" & $result[$i][0])) = "heal" Then Setlog("  " & NameOfTroop(Eval("e" & $result[$i][0]), $Plural) & " Recovering, Remain of " & $result[$i][3], $COLOR_BLUE)
					EndIf
				Else
					If $txt = "Heroes" Then
						If $showlog = True Then Setlog(" - " & NameOfTroop(Eval("e" & $result[$i][0]), $Plural) & " Recovered", $COLOR_GREEN)
					ElseIf $txt = "Troops" Then
						;ResetDropTrophiesVariable()
						If $showlog = True Then Setlog(" - " & $result[$i][3] & " " & NameOfTroop(Eval("e" & $result[$i][0]), $Plural) & " Available", $COLOR_GREEN)
						Assign("Cur" & $result[$i][0], Eval("Cur" & $result[$i][0]) + $result[$i][3])
						CanBeUsedToDropTrophies(Eval("e" & $result[$i][0]), Eval("Cur" & $result[$i][0]))
					Else
						If $result[$i][3] = 0 Then
							If $showlog = True Then SetLog(" - No Spells are Brewed", $COLOR_GREEN)
						Else
							If $showlog = True Then Setlog(" - " & $result[$i][3] & " " & NameOfTroop(Eval("e" & $result[$i][0]), $Plural) & " Brewed", $COLOR_GREEN)
							Assign("Cur" & $result[$i][0], Eval("Cur" & $result[$i][0]) + $result[$i][3])
						EndIf
					EndIf
				EndIf
			EndIf
		Next
	EndIf

	If $txt = "Spells" Then
		CountNumberSpells()
	EndIf

EndFunc   ;==>CheckExistentArmy

Func CanBeUsedToDropTrophies($eTroop, $Quantity)
	;SetLog("CanBeUsedToDrop|$eTroop = " & $eTroop & @CRLF & "Quantity = " & $Quantity)
	If $eTroop = $eBarb Then
		$aDTtroopsToBeUsed[0][1] = $Quantity

	ElseIf $eTroop = $eArch Then
		$aDTtroopsToBeUsed[1][1] = $Quantity

	ElseIf $eTroop = $eGiant Then
		$aDTtroopsToBeUsed[2][1] = $Quantity

	ElseIf $eTroop = $eGobl Then
		$aDTtroopsToBeUsed[4][1] = $Quantity

	ElseIf $eTroop = $eWall Then
		$aDTtroopsToBeUsed[3][1] = $Quantity

	ElseIf $eTroop = $eMini Then
		$aDTtroopsToBeUsed[5][1] = $Quantity
	EndIf

EndFunc   ;==>CanBeUsedToDropTrophies

Func ResetDropTrophiesVariable()
	For $i = 0 To (UBound($aDTtroopsToBeUsed, 1) - 1) ; Reset the variables
		$aDTtroopsToBeUsed[$i][1] = 0
	Next
EndFunc   ;==>ResetDropTrophiesVariable

Func CheckQueueTroops($getQuantity = True, $showlog = True)
	Local $res[1] = [""]
	;$hTimer = TimerInit()
	If $showlog Then SetLog("Checking Troops Queue...", $COLOR_BLUE)
	Local $directory = "trainwindow-TrainTroops-bundle"
	Local $result = SearchArmy($directory, 18, 182, 839, 261)
	ReDim $res[UBound($result)]
	;SetLog("btnGrayCheckc Done Within " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds.", $COLOR_BLUE)
	For $i = 0 To (UBound($result) - 1)
		If $Runstate = False Then Return
		$res[$i] = $result[$i][0]
	Next
	_ArrayReverse($res)
	If $getQuantity Then
		Local $Quantities = GetQueueQuantity($res)
		If $showlog Then
			For $i = 0 To (UBound($Quantities) - 1)
				SetLog("  - " & NameOfTroop(Eval("e" & $Quantities[$i][0])) & ": " & $Quantities[$i][1] & "x", $COLOR_GREEN)
			Next
		EndIf
	EndIf
	;_ArrayDisplay($Quantities)
	Return $res
EndFunc   ;==>CheckQueueTroops

Func CheckQueueSpells($getQuantity = True, $showlog = True)
	Local $res[1] = [""]
	;$hTimer = TimerInit()
	If $showlog Then SetLog("Checking Spells Queue...", $COLOR_BLUE)
	Local $directory = "trainwindow-SpellsInQueue-bundle"
	Local $result = SearchArmy($directory, 18, 182, 839, 261)
	ReDim $res[UBound($result)]
	;SetLog("btnGrayCheckc Done Within " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds.", $COLOR_BLUE)
	For $i = 0 To (UBound($result) - 1)
		If $Runstate = False Then Return
		$res[$i] = $result[$i][0]
	Next
	_ArrayReverse($res)
	If $getQuantity Then
		Local $Quantities = GetQueueQuantity($res)
		If $showlog Then
			For $i = 0 To (UBound($Quantities) - 1)
				If $Runstate = False Then Return
				SetLog("  - " & NameOfTroop(Eval("e" & $Quantities[$i][0])) & ": " & $Quantities[$i][1] & "x", $COLOR_GREEN)
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
		;$hTimer = TimerInit()
		Local $result[UBound($AvailableTroops)][2] = [["", 0]]
		Local $x = 770, $y = 189
		_CaptureRegion2()
		For $i = 0 To (UBound($AvailableTroops) - 1)
			If $Runstate = False Then Return
			$OCRResult = getQueueTroopsQuantity($x, $y)
			$result[$i][0] = $AvailableTroops[$i]
			$result[$i][1] = $OCRResult
			; At end, update Coords to next troop
			$x -= 70
		Next
		;SetLog("GetQueueQuantity Done Within " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds at #" & $i & " Loop.", $COLOR_BLUE)
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
		If $Runstate = False Then Return $aResult
		If getReceivedTroops(162, 200, $skipReceivedTroopsCheck) = False Then
			; Perform the search
			_CaptureRegion2($x, $y, $x1, $y1)
			$res = DllCall($hImgLib, "str", "SearchMultipleTilesBetweenLevels", "handle", $hHBitmap2, "str", $directory, "str", "FV", "Int", 0, "str", $Redlines, "Int", 0, "Int", 1000)

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
			If _Sleep($iDelayTrain8) Then Return $aResult
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
		For $i = 0 To UBound($TroopName) - 1
			If $Runstate = False Then Return
			Assign("Cur" & $TroopName[$i], 0)
			If _Sleep($iDelayTrain6) Then Return ; '20' just to Pause action
		Next
		#CS
			For $i = 0 To UBound($TroopDarkName) - 1
			If $Runstate = False Then Return
			Assign("Cur" & $TroopDarkName[$i], 0)
			If _Sleep($iDelayTrain6) Then Return ; '20' just to Pause action
			Next

		#CE
	EndIf
	If $txt = "Spells" Or $txt = "all" Then
		For $i = 0 To UBound($SpellName) - 1
			If $Runstate = False Then Return
			Assign("Cur" & $SpellName[$i], 0)
			If _Sleep($iDelayTrain6) Then Return ; '20' just to Pause action
		Next
	EndIf
	If $txt = "donated" Or $txt = "all" Then
		For $i = 0 To UBound($TroopName) - 1
			If $Runstate = False Then Return
			Assign("Don" & $TroopName[$i], 0)
			If _Sleep($iDelayTrain6) Then Return ; '20' just to Pause action
		Next
		#CS
			For $i = 0 To UBound($TroopDarkName) - 1
			Assign("Don" & $TroopDarkName[$i], 0)
			If $Runstate = False Then Return
			If _Sleep($iDelayTrain6) Then Return ; '20' just to Pause action
			Next
		#CE
	EndIf

EndFunc   ;==>ResetVariables

Func OpenTrainTabNumber($Num)

	Local $Message[4] = ["Army Camp", _
			"Train Troops", _
			"Brew Spells", _
			"Quick Train"]
	Local $TabNumber[4][2] = [[90, 128], [245, 128], [440, 128], [650, 128]]
	If $Runstate = False Then Return

	If IsTrainPage() Then
		Click($TabNumber[$Num][0], $TabNumber[$Num][1], 2, 200)
		If _Sleep(1500) Then Return
		If ISArmyWindow(False, $Num) Then
			Setlog(" - Opened the " & $Message[$Num], $COLOR_ACTION1)
			;If $Num = $BrewSpellsTAB Then CheckForSantaSpell() ; Can be Deleted after DEC (in 2017 :P)
			;If $Num = $TrainTroopsTAB Then ICEWizardDetection() ; Can be Deleted after DEC (in 2017 :P)
		EndIf
	Else
		Setlog(" - Error Clicking On " & ($Num >= 0 And $Num < UBound($Message)) ? ($Message[$Num]) : ("Not selectable") & " Tab!!!", $COLOR_RED)
	EndIf
EndFunc   ;==>OpenTrainTabNumber

Func TrainArmyNumber($Num)

	$Num = $Num - 1
	Local $a_TrainArmy[3][4] = [[817, 366, 0x6bb720, 10], [817, 484, 0x6bb720, 10], [817, 601, 0x6bb720, 10]]
	Setlog("Using Quick Train Tab.")
	If $Runstate = False Then Return

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
	If $TypeQueued = "Troops" Then
		If ISArmyWindow(False, $TrainTroopsTAB) = False Then OpenTrainTabNumber($TrainTroopsTAB)
		If _Sleep(1500) Then Return
		If ISArmyWindow(True, $TrainTroopsTAB) = False Then Return
	ElseIf $TypeQueued = "Spells" Then
		OpenTrainTabNumber($BrewSpellsTAB)
		If _Sleep(1500) Then Return
		If ISArmyWindow(True, $BrewSpellsTAB) = False Then Return
	Else
		Return
	EndIf
	If _Sleep(500) Then Return
	Local $x = 0
	While Not IsQueueEmpty(-1, True, False)
		If $x = 0 Then SetLog(" - Delete " & $TypeQueued & " Queued!", $COLOR_ACTION)
		If _Sleep(20) Then Return
		If $Runstate = False Then Return
		Click($OffsetQueued + 24, 202, 2, 50)
		$x += 1
		If $x = 250 Then ExitLoop
	WEnd
EndFunc   ;==>DeleteQueued

Func Slot($x = 0, $txt = "")

	If $Runstate = False Then Return
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
	; notes $DefaultTroopGroup[19][5]
	; notes $DefaultTroopGroup[19][0] = $TroopName | [1] = $TroopNamePosition | [2] = $TroopHeight | [3] = Times | [4] = qty | [5] = marker for DarkTroop or ElixerTroop]
	; notes ClickDrag(616, 445 + $midOffsetY, 400, 445 + $midOffsetY, 2000) ; Click drag for dark Troops
	; notes	ClickDrag(400, 445 + $midOffsetY, 616, 445 + $midOffsetY, 2000) ; Click drag for Elixer Troops
	; notes $RemainTrainSpace[0] = Current Army  | [1] = Total Army Capacity  | [2] = Remain Space for the current Army



	Local $RemainTrainSpace
	Local $Plural = 0
	Local $areThereDonTroop = 0
	Local $areThereDonSpell = 0

	For $j = 0 To UBound($TroopName) - 1
		If $Runstate = False Then Return
		$areThereDonTroop += Eval("Don" & $TroopName[$j])
	Next

	For $j = 0 To UBound($SpellName) - 1
		If $Runstate = False Then Return
		$areThereDonSpell += Eval("Don" & $SpellName[$j])
	Next
	If $areThereDonSpell = 0 And $areThereDonTroop = 0 Then Return

	SetLog("  making donated troops", $COLOR_ACTION1)
	If $areThereDonTroop > 0 Then
		; Load Eval("Don" & $TroopName[$i]) Values into $DefaultTroopGroup[19][5]
		For $i = 0 To UBound($DefaultTroopGroup) - 1
			For $j = 0 To UBound($TroopName) - 1
				If $TroopName[$j] = $DefaultTroopGroup[$i][0] Then
					$DefaultTroopGroup[$i][4] = Eval("Don" & $TroopName[$j])
					Assign("Don" & $TroopName[$j], 0)
				EndIf
			Next
		Next

		If IsTrainPage() And ISArmyWindow(False, $TrainTroopsTAB) = False Then OpenTrainTabNumber($TrainTroopsTAB)
		If _Sleep(1500) Then Return
		If ISArmyWindow(True, $TrainTroopsTAB) = False Then Return

		For $i = 0 To UBound($DefaultTroopGroup, 1) - 1
			If $Runstate = False Then Return
			$Plural = 0
			If $DefaultTroopGroup[$i][4] > 0 Then
				$RemainTrainSpace = GetOCRCurrent(48, 160)
				If $RemainTrainSpace[0] = $RemainTrainSpace[1] Then ; army camps full
					;Camps Full All Donate Counters should be zero!!!!
					For $j = 0 To UBound($DefaultTroopGroup, 1) - 1
						$DefaultTroopGroup[$j][4] = 0
					Next
					ExitLoop
				EndIf

				If $DefaultTroopGroup[$i][2] * $DefaultTroopGroup[$i][4] <= $RemainTrainSpace[2] Then ; Troopheight x donate troop qty <= avaible train space
					Local $pos = GetTrainPos(Eval("e" & $DefaultTroopGroup[$i][0]))
					Local $howMuch = $DefaultTroopGroup[$i][4]
					If $DefaultTroopGroup[$i][5] = "e" Then
						;TrainIt(Eval("e" & $MergedTroopGroup[$i][0]), $howMuch, $isldTrainITDelay)
						PureClick($pos[0], $pos[1], $howMuch, 500)
					Else
						ClickDrag(616, 445 + $midOffsetY, 400, 445 + $midOffsetY, 2000) ; Click drag for dark Troops
						;TrainIt(Eval("e" & $MergedTroopGroup[$i][0]), $howMuch, $isldTrainITDelay)
						PureClick($pos[0], $pos[1], $howMuch, 500)
						ClickDrag(400, 445 + $midOffsetY, 616, 445 + $midOffsetY, 2000) ; Click drag for Elixer Troops
					EndIf
					If $DefaultTroopGroup[$i][4] > 1 Then $Plural = 1
					Setlog(" - Trained " & $DefaultTroopGroup[$i][4] & " " & NameOfTroop(Eval("e" & $DefaultTroopGroup[$i][0]), $Plural), $COLOR_ACTION)
					$DefaultTroopGroup[$i][4] = 0
					If _Sleep(1000) Then Return ; Needed Delay, OCR was not picking up Troop Changes
				Else
					For $z = 0 To $RemainTrainSpace[2] - 1
						$RemainTrainSpace = GetOCRCurrent(48, 160)
						If $RemainTrainSpace[0] = $RemainTrainSpace[1] Then ; army camps full
							;Camps Full All Donate Counters should be zero!!!!
							For $j = 0 To UBound($DefaultTroopGroup, 1) - 1
								$DefaultTroopGroup[$j][4] = 0
							Next
							ExitLoop (2) ;
						EndIf
						If $DefaultTroopGroup[$i][2] <= $RemainTrainSpace[2] And $DefaultTroopGroup[$i][4] > 0 Then
							;TrainIt(Eval("e" & $TroopName[$i]), 1, $isldTrainITDelay)
							Local $pos = GetTrainPos(Eval("e" & $DefaultTroopGroup[$i][0]))
							Local $howMuch = 1
							If $TroopType[$i] = "e" Then
								;TrainIt(Eval("e" & $MergedTroopGroup[$i][0]), 1, $isldTrainITDelay)
								PureClick($pos[0], $pos[1], $howMuch, 500)
							Else
								ClickDrag(616, 445 + $midOffsetY, 400, 445 + $midOffsetY, 2000) ; Click drag for dark Troops
								;TrainIt(Eval("e" & $MergedTroopGroup[$i][0]), 1, $isldTrainITDelay)
								PureClick($pos[0], $pos[1], $howMuch, 500)
								ClickDrag(400, 445 + $midOffsetY, 616, 445 + $midOffsetY, 2000) ; Click drag for Elixer Troops
							EndIf
							If $DefaultTroopGroup[$i][4] > 1 Then $Plural = 1
							Setlog(" - Trained " & $DefaultTroopGroup[$i][4] & " " & NameOfTroop(Eval("e" & $DefaultTroopGroup[$i][0]), $Plural), $COLOR_ACTION)
							$DefaultTroopGroup[$i][4] -= 1
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
			;TrainIt(Eval($eArch), 1, $isldTrainITDelay)
			PureClick($TrainArch[0], $TrainArch[1], $howMuch, 500)
			If $RemainTrainSpace[2] > 0 Then $Plural = 1
			Setlog(" - Trained " & $howMuch & " archer(s)!", $COLOR_ACTION)
			If _Sleep(1000) Then Return ; Needed Delay, OCR was not picking up Troop Changes
		EndIf
		; Ensure all donate values are reset to zero
		For $j = 0 To UBound($DefaultTroopGroup, 1) - 1
			$DefaultTroopGroup[$j][4] = 0
		Next
	EndIf

	If $areThereDonSpell > 0 Then
		;Train Donated Spells
		If IsTrainPage() And ISArmyWindow(False, 2) = False Then OpenTrainTabNumber(2)
		If _Sleep(1500) Then Return
		If ISArmyWindow(True, 2) = False Then Return

		For $i = 0 To UBound($SpellName) - 1
			If $Runstate = False Then Return
			If Eval("Don" & $SpellName[$i]) > 0 Then
				$Plural = 0
				Local $pos = GetTrainPos(Eval("e" & $SpellName[$i]))
				Local $howMuch = Eval("Don" & $SpellName[$i])
				If $howMuch > 1 Then $Plural = 1
				PureClick($pos[0], $pos[1], $howMuch, 500)
				Setlog(" - Brewed " & $howMuch & " " & NameOfTroop(Eval("e" & $SpellName[$i]), $Plural), $COLOR_ACTION)
				Assign("Don" & $SpellName[$i], Eval("Don" & $SpellName[$i]) - $howMuch)
			EndIf
		Next
	EndIf
	If _Sleep(1000) Then Return
	$RemainTrainSpace = GetOCRCurrent(48, 160)
	Setlog(" - Current Capacity: " & $RemainTrainSpace[0] & "/" & ($RemainTrainSpace[1]))
EndFunc   ;==>MakingDonatedTroops

Func GetOCRCurrent($x_start, $y_start)

	Local $FinalResult[3] = [0, 0, 0]
	If $Runstate = False Then Return $FinalResult

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
	If $Runstate = False Then Return

	If IsTrainPage() And ISArmyWindow(False, $TrainTroopsTAB) = False Then OpenTrainTabNumber($TrainTroopsTAB)
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
			If ISArmyWindow(False, $TrainTroopsTAB) Then PureClick($TrainArch[0], $TrainArch[1], $ArchToMake, 500)
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
	If $Runstate = False Then Return

	If IsTrainPage() And ISArmyWindow(False, $TrainTroopsTAB) = False Then OpenTrainTabNumber($TrainTroopsTAB)
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
				If ISArmyWindow(False, $TrainTroopsTAB) Then PureClick($TrainArch[0], $TrainArch[1], $ArchToMake, 500)
				SetLog(" - Trained " & $ArchToMake & " archer(s)!")
			Else
				SetLog(" - Conditions NOT met: Empty queue and Not Full Army")
			EndIf
		EndIf
	EndIf
EndFunc   ;==>CheckIsEmptyQueuedAndNotFullArmy

;New Function to count number of Spells - value needed for existing donate()
Func CountNumberSpells()
	;CurTotalDonSpell[0] needed for Spell Donations
	;CurTotalDonSpell[1] needed to see if more than 6 different Spells are trained, if so then drag donation window

	$CurTotalDonSpell[0] = $CurLSpell + $CurHSpell + $CurRSpell + $CurJSpell + $CurFSpell + $CurPSpell + $CurESpell + $CurHaSpell + $CurSkSpell
	If $CurLSpell > 0 Then $CurTotalDonSpell[1] += 1
	If $CurHSpell > 0 Then $CurTotalDonSpell[1] += 1
	If $CurRSpell > 0 Then $CurTotalDonSpell[1] += 1
	If $CurJSpell > 0 Then $CurTotalDonSpell[1] += 1
	If $CurFSpell > 0 Then $CurTotalDonSpell[1] += 1
	If $CurPSpell > 0 Then $CurTotalDonSpell[1] += 1
	If $CurESpell > 0 Then $CurTotalDonSpell[1] += 1
	If $CurHaSpell > 0 Then $CurTotalDonSpell[1] += 1
	If $CurSkSpell > 0 Then $CurTotalDonSpell[1] += 1

	Return $CurTotalDonSpell
EndFunc   ;==>CountNumberDarkSpells

Func getReceivedTroops($x_start, $y_start, $skip = False) ; Check if 'you received Castle Troops from' , will proceed with a Sleep until the message disappear
	If $skip = True Then Return False
	Local $result = ""
	If $Runstate = False Then Return

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
	$Runstate = True

	$debugOcr = 1
	Setlog("Start......OpenArmy Window.....")

	Local $timer = TimerInit()

	CheckExistentArmy("Troops")

	Setlog("Imgloc Troops Time: " & Round(TimerDiff($timer) / 1000, 2) & "'s")

	Setlog("End......OpenArmy Window.....")
	$debugOcr = 0
	$Runstate = False
EndFunc   ;==>TestTrainRevamp2

Func IIf($Condition, $IfTrue, $IfFalse)
	If $Condition = True Then
		Return $IfTrue
	Else
		Return $IfFalse
	EndIf
EndFunc   ;==>IIf

Func _ArryRemoveBlanks(ByRef $Array)
	$Counter = 0
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

Func CheckValuesCost($txt = "RegularTroops", $Troop = "Arch", $troopQuantity = 1, $decreaseTheCost = True, $DebugLogs = 0)
	Local $String = ""

	If $debugsetlogTrain = 1 Or $DebugLogs Then Setlog("$ElixirCostCamp: " & $ElixirCostCamp)
	If $debugsetlogTrain = 1 Or $DebugLogs Then Setlog("$iElixirCurrent: " & $iElixirCurrent)
	If $debugsetlogTrain = 1 Or $DebugLogs Then Setlog("$DarkCostCamp: " & $DarkCostCamp)
	If $debugsetlogTrain = 1 Or $DebugLogs Then Setlog("$iDarkCurrent: " & $iDarkCurrent)
	If $debugsetlogTrain = 1 Or $DebugLogs Then Setlog("$DarkCostSpell: " & $DarkCostSpell)
	If $debugsetlogTrain = 1 Or $DebugLogs Then Setlog("$ElixirCostSpell: " & $ElixirCostSpell)

	If $txt <> "" Then
		If $txt = "RegularTroops" Then
			If $ElixirCostCamp <= $iElixirCurrent Then Return True
		ElseIf $txt = "DarkTroops" Then
			If $DarkCostCamp <= $iDarkCurrent Then Return True
		ElseIf $txt = "RegularSpells" Then
			If $ElixirCostSpell <= $iElixirCurrent Then Return True
		ElseIf $txt = "DarkSpells" Then
			If $DarkCostSpell <= $iDarkCurrent Then Return True
		ElseIf $txt = "AllRegular" Then
			If $ElixirCostCamp + $ElixirCostSpell <= $iElixirCurrent Then Return True
		ElseIf $txt = "AllDark" Then
			If $DarkCostCamp + $DarkCostSpell <= $iDarkCurrent Then Return True
		EndIf

		Switch $txt
			Case "RegularTroops"
				$String = "Elixir"
			Case "DarkTroops"
				$String = "Dark Elixir"
			Case "RegularSpells"
				$String = "Elixir"
			Case "DarkSpells"
				$String = "Dark Elixir"
			Case "AllRegular"
				$String = "Elixir"
			Case "AllDark"
				$String = "Dark Elixir"
		EndSwitch

		Setlog("Chief, you don't have enough " & $String & "!!")
		Return False
	Else
		Local $troopCost = Int(Execute("$Lev" & $Troop & "Cost[" & GUICtrlRead(Eval("txtLev" & $Troop)) & "]"))
		If $DebugLogs Then SetLog("$troopCost " & $Troop & "= " & $troopCost)
		$troopCost *= $troopQuantity
		If $DebugLogs Then SetLog("$troopCost2 " & $Troop & "= " & $troopCost)
		If $DebugLogs Then SetLog("$iElixirCurrent " & $Troop & "= " & $iElixirCurrent)
		If IsDarkTroop($Troop) Then
			; If is Dark Troop
			If $DebugLogs Then SetLog("Troop " & $Troop & " Is Dark Troop")
			If $troopCost <= $iDarkCurrent Then
				If $decreaseTheCost Then $iDarkCurrent -= $troopCost
				Return True
			EndIf
			Return False
		ElseIf IsElixirSpell($Troop) Then
			; If is Elixir Spell
			If $DebugLogs Then SetLog("Troop " & $Troop & " Is Elixir Spell")
			If $troopCost <= $iElixirCurrent Then
				If $decreaseTheCost Then $iElixirCurrent -= $troopCost
				Return True
			EndIf
			Return False
		ElseIf IsDarkSpell($Troop) Then
			; If is Dark Spell
			If $DebugLogs Then SetLog("Troop " & $Troop & " Is Dark Spell")
			If $DarkCostSpell <= $iDarkCurrent Then
				If $decreaseTheCost Then $iDarkCurrent -= $troopCost
				Return True
			EndIf
			Return False
		Else
			; If Isn't Dark Troop And Spell, Then is Elixir Troop : )
			If $troopCost <= $iElixirCurrent Then
				If $DebugLogs Then SetLog("Troop " & $Troop & " Is Elixir Troop")
				If $decreaseTheCost Then $iElixirCurrent -= $troopCost
				Return True
			EndIf
			Return False
		EndIf

	EndIf
EndFunc   ;==>CheckValuesCost

Func IsDarkSpell($Spell)
	For $i = (UBound($SpellName) - 5) To (UBound($SpellName) - 1)
		If $Spell = $SpellName[$i] Then Return True
	Next
	Return False
EndFunc   ;==>IsDarkSpell

Func IsElixirSpell($Spell)
	For $i = 0 To (UBound($SpellName) - 5)
		If $Spell = $SpellName[$i] Then Return True
	Next
	Return False
EndFunc   ;==>IsElixirSpell

Func ThSnipesSkiptrain()
	Local $Temp = 0
	; Check if the User will use TH snipes

	If IsSearchModeActive($TS) And $IsFullArmywithHeroesAndSpells Then
		For $i = 0 To (UBound($TroopName) - 1)
			If Eval($TroopName[$i] & "Comp") > 0 Then $Temp += 1
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

