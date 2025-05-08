; #FUNCTION# ====================================================================================================================
; Name ..........: PrepareSearch
; Description ...: Goes into searching for a match, breaks shield if it has to
; Syntax ........: PrepareSearch()
; Parameters ....:
; Return values .: None
; Author ........: Code Monkey #4
; Modified ......: KnowJack (Aug 2015), MonkeyHunter(2015-12)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func PrepareSearch($Mode = $DB) ;Click attack button and find match button, will break shield

	SetLog("Going to Attack", $COLOR_INFO)

	; RestartSearchPickupHero - Check Remaining Heal Time
	If $g_bSearchRestartPickupHero And $Mode <> $DT Then
		Local $pTroopType[$eHeroCount] = [$eKing, $eQueen, $ePrince, $eWarden, $eChampion]
		For $i = 0 To $eHeroSlots - 1 ; check slots
			For $pMatchMode = $DB To $g_iModeCount - 1 ; check all attack modes
				If IsUnitUsed($pMatchMode, $pTroopType[$g_aiCmbCustomHeroOrder[$i]]) Then
					If Not _DateIsValid($g_asHeroHealTime[$i]) Then
						getArmyHeroTime("All", True, True)
						ExitLoop 2
					EndIf
				EndIf
			Next
		Next
	EndIf

	ChkAttackCSVConfig()

	If IsMainPage() Then
		If _Sleep($DELAYTREASURY4) Then Return
		If _CheckPixel($aAttackForTreasury, $g_bCapturePixel, Default, "Is attack for treasury:") Then
			SetLog("It isn't attack for Treasury :-(", $COLOR_SUCCESS)
			Return
		EndIf
		If _Sleep($DELAYTREASURY4) Then Return

		Local $aAttack = findButton("AttackButton", Default, 1, True)
		Local $AttackCoordsX[2] = [45, 85]
		Local $AttackCoordsY[2] = [590 + $g_iBottomOffsetY, 625 + $g_iBottomOffsetY]
		Local $AttackButtonClickXY[2] = [Random($AttackCoordsX[0], $AttackCoordsX[1], 1), Random($AttackCoordsY[0], $AttackCoordsY[1], 1)]
		If IsArray($aAttack) And UBound($aAttack, 1) = 2 Then
			ClickP($AttackButtonClickXY, 1, 130, "#0149")
		Else
			Local $aRescueAttack = findButton("RescueATKButton", Default, 1, True)
			If IsArray($aRescueAttack) And UBound($aRescueAttack, 1) = 2 Then
				ClickP($AttackButtonClickXY, 1, 130, "#0149")
			Else
				SetLog("Couldn't find the Attack Button!", $COLOR_ERROR)
				If $g_bDebugImageSave Then SaveDebugImage("AttackButtonNotFound")
				Return
			EndIf
		EndIf
	EndIf

	If _Sleep($DELAYPREPARESEARCH1) Then Return
	If Not IsWindowOpen($g_sImgGeneralCloseButton & "*", 10, 200, GetDiamondFromRect("716,1,860,179")) Then
		SetLog("Attack Window did not open!", $COLOR_ERROR)
		AndroidPageError("PrepareSearch")
		checkMainScreen()
		$g_bRestart = True
		$g_bIsClientSyncError = False
		Return
	EndIf

	$g_bCloudsActive = True ; early set of clouds to ensure no android suspend occurs that might cause infinite waits

	If Not IsMultiplayerTabOpen() Then
		SetLog("Error while checking if Multiplayer Tab is opened", $COLOR_ERROR)
		Return
	EndIf

	$g_bLeagueAttack = False
	Do
		Local $bAttackPictureFound = False
		Local $bSignedUpLegendLeague = False
		Local $sSearchDiamond = GetDiamondFromRect2(300, 165 + $g_iMidOffsetY, 815, 600 + $g_iMidOffsetY)
		For $z = 0 To 9
			Local $avAttackButton = findMultiple($g_sImgPrepareLegendLeagueSearch, $sSearchDiamond, $sSearchDiamond, 0, 1000, 1, "objectname,objectpoints", True)
			If IsArray($avAttackButton) And UBound($avAttackButton, 1) > 0 Then
				$bAttackPictureFound = True
				ExitLoop
			EndIf
			If _Sleep(200) Then ExitLoop
		Next
		If $bAttackPictureFound Then
			$g_bLeagueAttack = True
			$g_bLegendsAllMade = False
			Local $avAttackButtonSubResult = $avAttackButton[0]
			Local $sButtonState = $avAttackButtonSubResult[0]
			If StringInStr($sButtonState, "Ended", 0) > 0 Then
				SetLog("League Day ended already! Trying again later", $COLOR_INFO)
				$g_bRestart = True
				CloseWindow2()
				$g_bForceSwitch = True     ; set this switch accounts next check
				Return
			ElseIf StringInStr($sButtonState, "Made", 0) > 0 Then
				SetLog("All Attacks already made! Returning home", $COLOR_INFO)
				$g_bLegendsAllMade = True
				$g_bRestart = True
				CloseWindow2()
				$g_bForceSwitch = True     ; set this switch accounts next check
				Return
			ElseIf StringInStr($sButtonState, "FindMatchLegend", 0) > 0 Then
				Local $aCoordinates = StringSplit($avAttackButtonSubResult[1], ",", $STR_NOCOUNT)
				ClickP($aCoordinates, 1, 140, "#0149")
				If _Sleep(1500) Then Return
				If OkayLegend() Then
					If _Sleep(1500) Then Return
				EndIf
				Local $aReadyAttackButton = 0
				$aReadyAttackButton = decodeSingleCoord(FindImageInPlace2("Attack", $ImgArmyAttack, 685, 490 + $g_iMidOffsetY, 780, 520 + $g_iMidOffsetY, True))
				If IsArray($aReadyAttackButton) And UBound($aReadyAttackButton, 1) = 2 Then
					If $Mode <> $DT Or ($Mode = $DT And $g_bDropTrophyAtkDead) Then SuperchargeCheck()
					ClickP($aReadyAttackButton, 1, 120)
					If OkayLegend() Then
						If _Sleep(1500) Then Return
						$aReadyAttackButton = decodeSingleCoord(FindImageInPlace2("Attack", $ImgArmyAttack, 685, 490 + $g_iMidOffsetY, 780, 520 + $g_iMidOffsetY, True))
						If IsArray($aReadyAttackButton) And UBound($aReadyAttackButton, 1) = 2 Then
							ClickP($aReadyAttackButton, 1, 120)
						EndIf
					EndIf
					ExitLoop
				Else
					If _Sleep(200) Then Return
					SetLog("Couldn't find attack button!", $COLOR_ERROR)
					If $g_bDebugImageSave Then SaveDebugImage("AttackButtonNotFound")
					CloseWindow2()
					If _Sleep(1000) Then Return
					CloseWindow2()
					Return
				EndIf
			ElseIf StringInStr($sButtonState, "FindMatchNormal") > 0 Then
				Local $aCoordinates = StringSplit($avAttackButtonSubResult[1], ",", $STR_NOCOUNT)
				If IsArray($aCoordinates) And UBound($aCoordinates, 1) = 2 Then
					$g_bLeagueAttack = False
					If $Mode <> $DT Or ($Mode = $DT And $g_bDropTrophyAtkDead) Then SuperchargeCheck()
					ClickP($aCoordinates, 1, 120, "#0150")
					ExitLoop
				Else
					SetLog("Couldn't find the Find a Match Button!", $COLOR_ERROR)
					If $g_bDebugImageSave Then SaveDebugImage("FindAMatchButtonNotFound")
					CloseWindow2()
					Return
				EndIf
			ElseIf StringInStr($sButtonState, "Sign", 0) > 0 Then
				SetLog("Sign-up to Legend League", $COLOR_INFO)
				Local $aCoordinates = StringSplit($avAttackButtonSubResult[1], ",", $STR_NOCOUNT)
				ClickP($aCoordinates, 1, 120, "#0000")
				If _Sleep(2000) Then Return
				$aCoordinates = findButton("Okay", Default, 1, True)
				If IsArray($aCoordinates) And UBound($aCoordinates) > 1 Then
					ClickP($aCoordinates, 1, 120, "#0000")
					If _Sleep(2000) Then Return
				Else
					SetLog("Couldn't find the Okay Button!", $COLOR_ERROR)
					If $g_bDebugImageSave Then SaveDebugImage("OkayButtonNotFound")
					Click(323, 415 + $g_iMidOffsetY) ; Cancel Button Coordinates October 2024
					If _Sleep(1000) Then Return
					CloseWindow2()
					Return
				EndIf
				SetLog("Sign-up to Legend League done", $COLOR_INFO)
				If _Sleep(1000) Then Return
				SetLog("Finding opponents! Waiting 5 minutes and then try again to find a match", $COLOR_INFO)
				If _Sleep(300000) Then Return     ; Wait 5mins before searching again
				$bSignedUpLegendLeague = True
			ElseIf StringInStr($sButtonState, "Oppo", 0) > 0 Then
				SetLog("Finding opponents! Waiting 5 minutes and then try again to find a match", $COLOR_INFO)
				If _Sleep(300000) Then Return     ; Wait 5mins before searching again
				$bSignedUpLegendLeague = True
			Else
				$g_bLeagueAttack = False
				SetLog("Unknown Find a Match Button State: " & $sButtonState, $COLOR_WARNING)
				Return
			EndIf
		Else
			Local $g_iFindMatchButtonClassic = _PixelSearch(579, 439 + $g_iMidOffsetY, 581, 441 + $g_iMidOffsetY, Hex(0x838383, 6), 20)
			Local $g_iFindMatchButtonLegend = _PixelSearch(579, 489 + $g_iMidOffsetY, 581, 491 + $g_iMidOffsetY, Hex(0x838383, 6), 20)
			If IsArray($g_iFindMatchButtonClassic) Or IsArray($g_iFindMatchButtonLegend) Then
				SetLog("Couldn't find the Attack Button : Grey Button!", $COLOR_ERROR)
				$g_bRestart = True
				CloseWindow2()
				Return
			EndIf
			If Number($g_aiCurrentLoot[$eLootTrophy]) >= Number($g_asLeagueDetails[21][4]) Then
				SetLog("Couldn't find the Attack Button!", $COLOR_ERROR)
				$g_bRestart = True
				CloseWindow2()
				Return
			EndIf
		EndIf
	Until Not $bSignedUpLegendLeague

	If $g_iTownHallLevel <> "" And $g_iTownHallLevel > 0 Then
		$g_iSearchCost += $g_aiSearchCost[$g_iTownHallLevel - 1]
		$g_iStatsTotalGain[$eLootGold] -= $g_aiSearchCost[$g_iTownHallLevel - 1]
	EndIf
	UpdateStats()

	If _Sleep($DELAYPREPARESEARCH2) Then Return

	If isGemOpen(True) Then ; Check for gem window open)
		SetLog(" Not enough gold to start searching!", $COLOR_ERROR)
		If _Sleep($DELAYPREPARESEARCH1) Then Return
		CloseWindow() ; Click close attack window "X"
		If _Sleep($DELAYPREPARESEARCH1) Then Return
		$g_bOutOfGold = True ; Set flag for out of gold to search for attack
	EndIf

	SetDebugLog("PrepareSearch exit check $g_bRestart= " & $g_bRestart & ", $g_bOutOfGold= " & $g_bOutOfGold, $COLOR_DEBUG)

	If $g_bRestart Or $g_bOutOfGold Then ; If we have one or both errors, then return
		$g_bIsClientSyncError = False ; reset fast restart flag to stop OOS mode, collecting resources etc.
		Return
	EndIf
	If IsAttackWhileShieldPage(False) Then ; check for shield window and then button to lose time due attack and click okay
		Local $aiOkayButton = findButton("Okay", Default, 1, True)
		If IsArray($aiOkayButton) And UBound($aiOkayButton, 1) = 2 Then ClickP($aiOkayButton, 1, 120, "#0153") ; Click Okay Button
		If _Sleep($DELAYPREPARESEARCH3) Then Return
	EndIf

EndFunc   ;==>PrepareSearch

Func OkayLegend()

	Local $aOkayAttackButton
	$aOkayAttackButton = findButton("Okay", Default, 1, True)
	If IsArray($aOkayAttackButton) And UBound($aOkayAttackButton, 1) = 2 Then
		ClickP($aOkayAttackButton, 1, 120)
		Return True
	EndIf

	Return False

EndFunc   ;==>OkayLegend
