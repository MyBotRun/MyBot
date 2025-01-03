; #FUNCTION# ====================================================================================================================
; Name ..........: ReturnHome
; Description ...: Returns home when in battle, will take screenshot and check for gold/elixir change unless specified not to.
; Syntax ........: ReturnHome([$TakeSS = 1[, $GoldChangeCheck = True]])
; Parameters ....: $TakeSS              - [optional] flag for saving a snapshot of the winning loot. Default is 1.
;                  $GoldChangeCheck     - [optional] an unknown value. Default is True.
; Return values .: None
; Author ........:
; Modified ......: KnowJack (07-2015), MonkeyHunter (01-2016), CodeSlinger69 (01-2017), MonkeyHunter (03-2017), Moebius14 (09-2024)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func ReturnHome($TakeSS = 1, $GoldChangeCheck = True) ;Return main screen
	SetDebugLog("ReturnHome function... (from matchmode=" & $g_iMatchMode & " - " & $g_asModeText[$g_iMatchMode] & ")", $COLOR_DEBUG)
	Local $counter = 0
	Local $hBitmap_Scaled
	Local $i, $j
	Local $aiSurrenderButton

	If $g_bDESideDisableOther And $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 4 And $g_bDESideEndEnable And ($g_bDropQueen Or $g_bDropKing) Then
		SaveandDisableEBO()
		SetLog("Disabling Normal End Battle Options", $COLOR_SUCCESS)
	EndIf

	If $GoldChangeCheck Then
		If Not (IsReturnHomeBattlePage(True, False)) Then ; if already in return home battle page do not wait and try to activate Hero Ability and close battle
			SetLog("Checking if the battle has finished", $COLOR_INFO)
			While GoldElixirChangeEBO()
				If _Sleep($DELAYRETURNHOME1) Then Return
			WEnd
			If IsAttackPage() Then smartZap() ; Check to see if we should zap the DE Drills
			;If Heroes were not activated: Hero Ability activation before End of Battle to restore health
			If ($g_bCheckKingPower Or $g_bCheckQueenPower Or $g_bCheckPrincePower Or $g_bCheckWardenPower Or $g_bCheckChampionPower) Then
				;_CaptureRegion()
				If _ColorCheck(_GetPixelColor($aRtnHomeCheck1[0], $aRtnHomeCheck1[1], True), Hex($aRtnHomeCheck1[2], 6), $aRtnHomeCheck1[3]) = False And _ColorCheck(_GetPixelColor($aRtnHomeCheck2[0], $aRtnHomeCheck2[1], True), Hex($aRtnHomeCheck2[2], 6), $aRtnHomeCheck2[3]) = False Then ; If not already at Return Homescreen
					If $g_bCheckKingPower Then
						SetLog("Activating King's power to restore some health before EndBattle", $COLOR_INFO)
						If IsAttackPage() Then SelectDropTroop($g_iKingSlot) ;If King was not activated: Boost King before EndBattle to restore some health
					EndIf
					If $g_bCheckQueenPower Then
						SetLog("Activating Queen's power to restore some health before EndBattle", $COLOR_INFO)
						If IsAttackPage() Then SelectDropTroop($g_iQueenSlot) ;If Queen was not activated: Boost Queen before EndBattle to restore some health
					EndIf
					If $g_bCheckPrincePower Then
						SetLog("Activating Prince's power to restore some health before EndBattle", $COLOR_INFO)
						If IsAttackPage() Then SelectDropTroop($g_iPrinceSlot) ;If Prince was not activated: Boost Queen before EndBattle to restore some health
					EndIf
					If $g_bCheckWardenPower Then
						SetLog("Activating Warden's power to restore some health before EndBattle", $COLOR_INFO)
						If IsAttackPage() Then SelectDropTroop($g_iWardenSlot) ;If Queen was not activated: Boost Queen before EndBattle to restore some health
					EndIf
					If $g_bCheckChampionPower Then
						SetLog("Activating Royal Champion's power to restore some health before EndBattle", $COLOR_INFO)
						If IsAttackPage() Then SelectDropTroop($g_iChampionSlot) ;If Champion was not activated: Boost Champion before EndBattle to restore some health
					EndIf
				EndIf
			EndIf
		Else
			SetDebugLog("Battle already over", $COLOR_DEBUG)
		EndIf
	EndIf

	If $g_bDESideDisableOther And $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 4 And $g_bDESideEndEnable And ($g_bDropQueen Or $g_bDropKing) Then
		RevertEBO()
	EndIf

	; Reset hero variables
	$g_bCheckKingPower = False
	$g_bCheckQueenPower = False
	$g_bCheckPrincePower = False
	$g_bCheckWardenPower = False
	$g_bCheckChampionPower = False
	$g_bDropKing = False
	$g_bDropQueen = False
	$g_bDropPrince = False
	$g_bDropWarden = False
	$g_bDropChampion = False
	$g_aHeroesTimerActivation[$eHeroBarbarianKing] = 0
	$g_aHeroesTimerActivation[$eHeroArcherQueen] = 0
	$g_aHeroesTimerActivation[$eHeroMinionPrince] = 0
	$g_aHeroesTimerActivation[$eHeroGrandWarden] = 0
	$g_aHeroesTimerActivation[$eHeroRoyalChampion] = 0

	; Reset building info used to attack base
	_ObjDeleteKey($g_oBldgAttackInfo, "") ; Remove all Keys from dictionary

	SetLog("Returning Home", $COLOR_INFO)
	If $g_bRunState = False Then Return

	; ---- CLICK SURRENDER BUTTON ----
	If Not (IsReturnHomeBattlePage(True, False)) Then ; check if battle is already over
		Local $bret = False
		For $i = 0 To 5 ; dynamic wait loop for surrender button to appear (if end battle or surrender button are not found in 5*(200)ms + 10*(200)ms or 3 seconds, then give up.)
			SetDebugLog("Wait for surrender button to appear #" & $i)
			$aiSurrenderButton = findButton("EndBattle", Default, 1, True)
			If IsArray($aiSurrenderButton) And UBound($aiSurrenderButton, 1) = 2 Then
				If IsAttackPage() Then ; verify still on attack page, and battle has not ended magically before clicking
					ClickP($aiSurrenderButton, 1, 120, "#0099") ;Click Surrender
					$j = 0
					While 1 ; dynamic wait for Okay button
						SetDebugLog("Wait for OK button to appear #" & $j)
						If IsEndBattlePage(False) Then
							ClickOkay("SurrenderOkay") ; Click Okay to Confirm surrender
							ExitLoop 2
						Else
							$j += 1
						EndIf
						If ReturnHomeMainPage() Then Return
						If $j > 10 Then
							Select
								Case $i < 5 ; if Okay button not found in 10*(200)ms or 2 seconds, then give up.
									ExitLoop
								Case $i = 5 ; if Okay button not found Then Restart COC.
									$bret = True
									ExitLoop 2
							EndSelect
						EndIf
						If _Sleep($DELAYRETURNHOME5) Then Return
					WEnd
				EndIf
			Else
				SetDebugLog("Cannot Find Surrender Button", $COLOR_ERROR)
			EndIf
			If ReturnHomeMainPage() Then Return
			If _Sleep($DELAYRETURNHOME5) Then Return
		Next
		If $bret Then
			SetLog("Have strange problem Couldn't Click Okay to Confirm surrender, Restarting CoC", $COLOR_ERROR)
			CloseCoC(True)
			Return
		EndIf
	Else
		SetDebugLog("Battle already over.", $COLOR_DEBUG)
	EndIf
	If _Sleep($DELAYRETURNHOME2) Then Return ; short wait for return to main

	TrayTip($g_sBotTitle, "", BitOR($TIP_ICONASTERISK, $TIP_NOSOUND)) ; clear village search match found message

	If CheckAndroidReboot() Then Return

	If $GoldChangeCheck Then
		If IsAttackPage() Then
			$counter = 0
			While _ColorCheck(_GetPixelColor($aRtnHomeCheck1[0], $aRtnHomeCheck1[1], True), Hex($aRtnHomeCheck1[2], 6), $aRtnHomeCheck1[3]) = False And _ColorCheck(_GetPixelColor($aRtnHomeCheck2[0], $aRtnHomeCheck2[1], True), Hex($aRtnHomeCheck2[2], 6), $aRtnHomeCheck2[3]) = False ; test for Return Home Button
				SetDebugLog("Wait for Return Home Button to appear #" & $counter)
				If _Sleep($DELAYRETURNHOME2) Then ExitLoop
				$counter += 1
				If $counter > 40 Then ExitLoop
			WEnd
		EndIf
		If _Sleep($DELAYRETURNHOME3) Then Return ; wait for all report details
		_CaptureRegion()
		AttackReport()
	EndIf
	If $TakeSS = 1 And $GoldChangeCheck Then
		SetLog("Taking snapshot of your loot", $COLOR_SUCCESS)
		Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
		Local $Time = @HOUR & "." & @MIN
		_CaptureRegion()
		$hBitmap_Scaled = _GDIPlus_ImageResize($g_hBitmap, _GDIPlus_ImageGetWidth($g_hBitmap) / 2, _GDIPlus_ImageGetHeight($g_hBitmap) / 2) ;resize image
		; screenshot filename according with new options around filenames
		If $g_bScreenshotLootInfo Then
			$g_sLootFileName = $Date & "_" & $Time & " G" & $g_iStatsLastAttack[$eLootGold] & " E" & $g_iStatsLastAttack[$eLootElixir] & " DE" & _
					$g_iStatsLastAttack[$eLootDarkElixir] & " T" & $g_iStatsLastAttack[$eLootTrophy] & " S" & StringFormat("%3s", $g_iSearchCount) & ".jpg"
		Else
			$g_sLootFileName = $Date & "_" & $Time & ".jpg"
		EndIf
		_GDIPlus_ImageSaveToFile($hBitmap_Scaled, $g_sProfileLootsPath & $g_sLootFileName)
		_GDIPlus_ImageDispose($hBitmap_Scaled)
	EndIf

	;push images if requested..
	If $GoldChangeCheck Then PushMsg("LastRaid")

	$i = 0 ; Reset Loop counter
	Local $iExitLoop = -1
	While 1
		SetDebugLog("Wait for End Fight Scene to appear #" & $i)
		If _CheckPixel($aEndFightSceneAvl, $g_bCapturePixel) Then ; check for the gold ribbon in the end of battle data screen
			If IsReturnHomeBattlePage(True) Then
				ClickP($aReturnHomeButton, 1, 120, "#0101") ;Click Return Home Button
				; sometimes 1st click is not closing, so try again
				$iExitLoop = $i
			EndIf
		EndIf
		If $i > 25 Or ($iExitLoop > -1 And $i > $iExitLoop) Then ExitLoop ; if end battle window is not found in 25*200mms or 5 seconds, then give up.
		If _Sleep($DELAYRETURNHOME5) Then Return
		$i += 1
	WEnd
	If _Sleep($DELAYRETURNHOME2) Then Return ; short wait for screen to close

	$counter = 0
	SetDebugLog("Wait for Special windows to appear")
	While 1
		If _Sleep($DELAYRETURNHOME4) Then Return
		Local $bIsMain = _CheckPixel($aIsMain, $g_bCapturePixel, Default, "IsMain")
		Local $bIsMainGrayed = IsMainGrayed()
		Select
			Case Not $bIsMain And Not $bIsMainGrayed
				If TreasureHunt($counter) Then
					SetLog("Treasury Hunt window closed chief!", $COLOR_INFO) ; Check for Treasury Hunt Event window to (2024-09) update
					ContinueLoop
				EndIf
			Case $bIsMainGrayed
				If StarBonus() Then
					SetLog("Star Bonus window closed chief!", $COLOR_INFO) ; Check for Star Bonus window to fill treasury (2016-01) update
					ContinueLoop
				EndIf
				If CheckStreakEvent() Then
					SetLog("Streak Event window closed chief!", $COLOR_INFO) ; Check for Streak Event window to (2024-06) update
					ContinueLoop
				EndIf
		EndSelect
		$g_bFullArmy = False ; forcing check the army
		$g_bIsFullArmywithHeroesAndSpells = False ; forcing check the army
		If ReturnHomeMainPage() Then Return
		$counter += 1
		SetDebugLog("Loop #" & $counter)
		If $counter >= 30 Or isProblemAffect(True) Then
			SetLog("Cannot return home.", $COLOR_ERROR)
			checkMainScreen()
			Return
		EndIf
	WEnd
EndFunc   ;==>ReturnHome

Func ReturnHomeMainPage()
	If IsMainPage(1) Then
		SetLogCentered(" BOT LOG ", Default, Default, True)
		Return True
	EndIf
	Return False
EndFunc   ;==>ReturnHomeMainPage

Func ReturnfromDropTrophies()
	Local $aiSurrenderButton
	SetDebugLog(" -- ReturnfromDropTrophies -- ")

	For $i = 0 To 5 ; dynamic wait loop for surrender button to appear (if end battle or surrender button are not found in 5*(200)ms + 10*(200)ms or 3 seconds, then give up.)
		$aiSurrenderButton = findButton("Surrender", Default, 1, True)
		If IsArray($aiSurrenderButton) And UBound($aiSurrenderButton, 1) = 2 Then
			ClickP($aiSurrenderButton, 1, 120, "#0099") ;Click Surrender
			If _Sleep(500) Then Return
			Local $j = 0
			While 1 ; dynamic wait for Okay button
				SetDebugLog("Wait for OK button to appear #" & $j)
				If IsEndBattlePage(True) Then
					ClickOkay("SurrenderOkay") ; Click Okay to Confirm surrender
					ExitLoop 2
				Else
					$j += 1
				EndIf
				If $j > 10 Then ExitLoop ; if Okay button not found in 10*(200)ms or 2 seconds, then give up.
				If _Sleep(100) Then Return
			WEnd
			If _Sleep(100) Then Return
		Else
			SetDebugLog("Cannot Find Surrender Button", $COLOR_ERROR)
		EndIf
	Next

	$i = 0 ; Reset Loop counter
	Local $iExitLoop = -1
	While 1
		SetDebugLog("Wait for End Fight Scene to appear #" & $i)
		If _CheckPixel($aEndFightSceneAvl, $g_bCapturePixel) Then ; check for the gold ribbon in the end of battle data screen
			If IsReturnHomeBattlePage(True) Then
				ClickP($aReturnHomeButton, 1, 120, "#0101") ;Click Return Home Button
				; sometimes 1st click is not closing, so try again
				$iExitLoop = $i
			EndIf
		EndIf
		If $i > 25 Or ($iExitLoop > -1 And $i > $iExitLoop) Then ExitLoop ; if end battle window is not found in 25*200mms or 5 seconds, then give up.
		If _Sleep($DELAYRETURNHOME5) Then Return
		$i += 1
	WEnd
	If _Sleep($DELAYRETURNHOME2) Then Return ; short wait for screen to close
	$g_bFullArmy = False ; forcing check the army
	$g_bIsFullArmywithHeroesAndSpells = False ; forcing check the army
	If ReturnHomeMainPage() Then Return
	checkMainScreen()
EndFunc   ;==>ReturnfromDropTrophies

Func CheckStreakEvent()
	SetDebugLog("Begin Steak Event window check", $COLOR_DEBUG1)
	If Not $g_bRunState Then Return
	Local $bRet = False
	Local $sAllCoordsString, $aAllCoordsTemp, $aTempCoords
	Local $aAllCoords[0][2]
	If _Sleep($DELAYSTARBONUS100) Then Return
	Local $aContinueButton = findButton("Continue", Default, 1, True)
	If IsArray($aContinueButton) And UBound($aContinueButton, 1) = 2 Then
		ClickP($aContinueButton, 1, 120, "#0433")
		If _Sleep(2500) Then Return
	EndIf
	If Not _ColorCheck(_GetPixelColor(290, 120 + $g_iMidOffsetY, $g_bCapturePixel), Hex(0x9B071A, 6), 20) And Not _ColorCheck(_GetPixelColor(560, 150 + $g_iMidOffsetY, $g_bCapturePixel), Hex(0x9B071A, 6), 20) Then
		SetDebugLog("Streak Event window not found?", $COLOR_DEBUG)
		Return $bRet
	EndIf
	$bRet = True
	Local $SearchArea = GetDiamondFromRect("20,260(820,140)")
	Local $aResult = findMultiple(@ScriptDir & "\imgxml\DailyChallenge\", $SearchArea, $SearchArea, 0, 1000, 10, "objectname,objectpoints", True)
	If $aResult <> "" And IsArray($aResult) Then
		For $t = 0 To UBound($aResult) - 1
			Local $aResultArray = $aResult[$t]     ; ["Button Name", "x1,y1", "x2,y2", ...]
			SetDebugLog("Find Claim buttons, $aResultArray[" & $t & "]: " & _ArrayToString($aResultArray))
			If IsArray($aResultArray) And $aResultArray[0] = "ClaimBtn" Then
				$sAllCoordsString = _ArrayToString($aResultArray, "|", 1)     ; "x1,y1|x2,y2|..."
				$aAllCoordsTemp = decodeMultipleCoords($sAllCoordsString, 50, 50)     ; [{coords1}, {coords2}, ...]
				For $k = 0 To UBound($aAllCoordsTemp, 1) - 1
					$aTempCoords = $aAllCoordsTemp[$k]
					_ArrayAdd($aAllCoords, Number($aTempCoords[0]) & "|" & Number($aTempCoords[1]))
				Next
			EndIf
		Next
		RemoveDupXY($aAllCoords)
		For $j = 0 To UBound($aAllCoords) - 1
			Click($aAllCoords[$j][0], $aAllCoords[$j][1], 1, 120, "Claim " & $j + 1)         ; Click Claim button
			If _Sleep(2000) Then Return
		Next
	EndIf
	CloseWindow2()
	Return $bRet
EndFunc   ;==>CheckStreakEvent

Func TreasureHunt($counter = 0)

	If Not $g_bRunState Then Return
	Local $bret = False
	Local $bHitDone = False

	If $counter > 0 Then
		Local $aContinueButton = findButton("Continue", Default, 1, True) ; In case all below failed in the ReturnHome loop, unlikely
		If IsArray($aContinueButton) And UBound($aContinueButton, 1) = 2 Then
			ClickP($aContinueButton, 1, 120, "#0433")
			SetLog("Reward Received", $COLOR_SUCCESS1)
			If _Sleep($DELAYTREASURY2) Then Return ; 1500ms
			Return True
		EndIf
	EndIf

	SetLog("Opening Chest", $COLOR_SUCCESS)
	Local $bLoop = 0
	While 1
		If Not $g_bRunState Then Return
		Local $aiHammerOnRock = decodeSingleCoord(FindImageInPlace2("HammerOnRock", $ImgHammerOnRock, 340, 470 + $g_iMidOffsetY, 430, 520 + $g_iMidOffsetY, True))
		If IsArray($aiHammerOnRock) And UBound($aiHammerOnRock) = 2 Then
			For $i = 0 To 20
				If Not $g_bRunState Then Return
				Local $aiLockOfChest = decodeSingleCoord(FindImageInPlace2("LockOfBox", $ImgLockOfChest, 400, 305 + $g_iMidOffsetY, 480, 390 + $g_iMidOffsetY, True))
				If IsArray($aiLockOfChest) And UBound($aiLockOfChest) = 2 Then
					Local $iHammers = QuickMIS("CNX", $ImgHammersOnRock, 340, 470 + $g_iMidOffsetY, 510, 520 + $g_iMidOffsetY)
					If IsArray($iHammers) And UBound($iHammers) > 1 And UBound($iHammers, $UBOUND_COLUMNS) > 1 Then
						SetLog("Detected Hammers : " & UBound($iHammers), $COLOR_INFO)
						For $t = 0 To UBound($iHammers) - 1
							If Not $g_bRunState Then Return
							Local $ButtonClickX = Random($aiLockOfChest[0] - 20, $aiLockOfChest[0] + 20, 1)
							Local $ButtonClickY = Random($aiLockOfChest[1] - 20, $aiLockOfChest[1] + 20, 1)
							SetLog(($t = 0 ? "Hit Number : #" : "#") & $t + 1 & ".. ", $COLOR_ACTION, Default, Default, Default, Default, ($t = 0 ? Default : False), ($t = UBound($iHammers) - 1 ? Default : False))
							Click($ButtonClickX, $ButtonClickY, 1, 130, "LockHit")
							If $t = UBound($iHammers) - 1 Then
								If _Sleep(Random(2000, 3000, 1)) Then Return
							Else
								If _Sleep(Random(700, 1200, 1)) Then Return
							EndIf
						Next
						$bHitDone = True
						ExitLoop 2
					EndIf
				EndIf
				If _Sleep(1000) Then Return
			Next
		EndIf
		If _Sleep(1000) Then Return
		$bLoop += 1
		If $bLoop > 10 Then Return $bret ; Exit if more than 10 loops
	WEnd

	If $bHitDone Then
		SetLog("Click on Continue...", $COLOR_INFO)
		For $i = 0 To 30
			If Not $g_bRunState Then Return
			Local $offColors[3][3] = [[0x8BD13A, 5, 0], [0x8BD13A, 9, 6], [0x0D0D0D, 12, 11]] ; 2nd pixel Green Color, 3rd pixel Green Color, 4th pixel Black bottom edge of Button
			Local $ContinueButtonEdge = _MultiPixelSearch(366, 535, 385, 550, 1, 1, Hex(0x0D0D0D, 6), $offColors, 15) ; first black pixel on side of Button
			SetDebugLog("Pixel Color #1: " & _GetPixelColor(368, 535, True) & ", #2: " & _GetPixelColor(373, 535, True) & ", #3: " & _GetPixelColor(377, 541, True) & ", #4: " & _GetPixelColor(380, 546, True), $COLOR_DEBUG)
			If IsArray($ContinueButtonEdge) Then
				If _Sleep(500) Then Return
				Local $aContinueButton = findButton("Continue", Default, 1, True)
				If IsArray($aContinueButton) And UBound($aContinueButton, 1) = 2 Then
					If _Sleep(500) Then Return
					ClickP($aContinueButton, 1, 120, "#0433")
					SetLog("Reward Received", $COLOR_SUCCESS1)
					$bret = True
					If _Sleep($DELAYTREASURY2) Then Return ; 1500ms
					ExitLoop
				EndIf
			EndIf
			If _Sleep(300) Then Return
			If $i = 30 Then
				SaveDebugImage("ChestRoomError")
				SetLog("Cannot find Continue button", $COLOR_ERROR)
				If _Sleep(200) Then Return
				Click(430, 495 + $g_iMidOffsetY)
			EndIf
		Next
	EndIf

	Return $bret

EndFunc   ;==>TreasureHunt
