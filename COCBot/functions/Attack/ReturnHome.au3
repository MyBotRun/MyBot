; #FUNCTION# ====================================================================================================================
; Name ..........: ReturnHome
; Description ...: Returns home when in battle, will take screenshot and check for gold/elixir change unless specified not to.
; Syntax ........: ReturnHome([$TakeSS = 1[, $GoldChangeCheck = True]])
; Parameters ....: $TakeSS              - [optional] flag for saving a snapshot of the winning loot. Default is 1.
;                  $GoldChangeCheck     - [optional] an unknown value. Default is True.
; Return values .: None
; Author ........:
; Modified ......: KnowJack (Jun/Aug2015), MonkeyHunter (2106-01)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func ReturnHome($TakeSS = 1, $GoldChangeCheck = True) ;Return main screen
	If $DebugSetLog = 1 Then Setlog("ReturnHome function... (from matchmode=" & $iMatchMode & " - " & $sModeText[$iMatchMode] & ")", $COLOR_PURPLE)
	Local $counter = 0
	Local $hBitmap_Scaled
	Local $i, $j

	If $DisableOtherEBO And $iMatchMode = $LB And $iChkDeploySettings[$LB] = 4 And $DESideEB And ($dropQueen Or $dropKing) Then
		SaveandDisableEBO()
		SetLog("Disabling Normal End Battle Options", $COLOR_GREEN)
	EndIf

	If $GoldChangeCheck = True Then
		If Not (IsReturnHomeBattlePage(True, False)) Then ; if already in return home battle page do not wait and try to activate Hero Ability and close battle
			SetLog("Checking if the battle has finished", $COLOR_BLUE)
			While GoldElixirChangeEBO()
				If _Sleep($iDelayReturnHome1) Then Return
			WEnd
			;If Heroes were not activated: Hero Ability activation before End of Battle to restore health
			If ($checkKPower = True Or $checkQPower = True) And $iActivateKQCondition = "Auto" Then
				;_CaptureRegion()
				If _ColorCheck(_GetPixelColor($aRtnHomeCheck1[0], $aRtnHomeCheck1[1], True), Hex($aRtnHomeCheck1[2], 6), $aRtnHomeCheck1[3]) = False And _ColorCheck(_GetPixelColor($aRtnHomeCheck2[0], $aRtnHomeCheck2[1], True), Hex($aRtnHomeCheck2[2], 6), $aRtnHomeCheck2[3]) = False Then ; If not already at Return Homescreen
					If $checkKPower = True Then
						SetLog("Activating King's power to restore some health before EndBattle", $COLOR_BLUE)
						If IsAttackPage() Then SelectDropTroop($King) ;If King was not activated: Boost King before EndBattle to restore some health
					EndIf
					If $checkQPower = True Then
						SetLog("Activating Queen's power to restore some health before EndBattle", $COLOR_BLUE)
						If IsAttackPage() Then SelectDropTroop($Queen) ;If Queen was not activated: Boost Queen before EndBattle to restore some health
					EndIf
				EndIf
			EndIf
		Else
			If $DebugSetLog = 1 Then Setlog("Battle already over", $COLOR_PURPLE)
		EndIf
	EndIf

	If $DisableOtherEBO And $iMatchMode = $LB And $iChkDeploySettings[$LB] = 4 And $DESideEB And ($dropQueen Or $dropKing) Then
		RevertEBO()
	EndIf

	$checkKPower = False
	$checkQPower = False
	$checkWPower = False

	If $iMatchMode = $TS And $icmbTroopComp <> 8 Then $FirstStart = True ;reset barracks upon return when TH sniping w/custom army

	SetLog("Returning Home", $COLOR_BLUE)
	If $RunState = False Then Return

	; ---- CLICK SURRENDER BUTTON ----
	If Not (IsReturnHomeBattlePage(True, False)) Then  ; check if battle is already over
		$i = 0 ; Reset Loop counter
		While 1 ; dynamic wait loop for surrender button to appear
			If _CheckPixel($aSurrenderButton, $bCapturePixel) Then  ;is surrender button is visible?
				If IsAttackPage() Then  ; verify still on attack page, and battle has not ended magically before clicking
					ClickP($aSurrenderButton, 1, 0, "#0099") ;Click Surrender
					$j = 0
					While 1 ; dynamic wait for Okay button
						If IsEndBattlePage(False) Then
							ClickOkay("SurrenderOkay") ; Click Okay to Confirm surrender
							ExitLoop 2
						Else
							$j += 1
						EndIf
						If $j > 10 Then ExitLoop ; if Okay button not found in 10*(200)ms or 2 seconds, then give up.
						If _Sleep($iDelayReturnHome5) Then Return
					WEnd
				Else
					$i += 1
				EndIf
			Else
				$i += 1
			EndIf
			If $i > 5 Then ExitLoop ; if end battle or surrender button are not found in 5*(200)ms + 10*(200)ms or 3 seconds, then give up.
			If _Sleep($iDelayReturnHome5) Then Return
		WEnd
	Else
		If $DebugSetLog = 1 Then Setlog("Battle already over.", $COLOR_PURPLE)
	EndIf
	If _Sleep($iDelayReturnHome2) Then Return ; short wait for return to main

	TrayTip($sBotTitle, "", BitOR($TIP_ICONASTERISK, $TIP_NOSOUND)) ; clear village search match found message

	checkAndroidTimeLag(False)

	If $GoldChangeCheck = True Then
		If IsAttackPage() Then
			$counter = 0
			While _ColorCheck(_GetPixelColor($aRtnHomeCheck1[0], $aRtnHomeCheck1[1], True), Hex($aRtnHomeCheck1[2], 6), $aRtnHomeCheck1[3]) = False And _ColorCheck(_GetPixelColor($aRtnHomeCheck2[0], $aRtnHomeCheck2[1], True), Hex($aRtnHomeCheck2[2], 6), $aRtnHomeCheck2[3]) = False ; test for Return Home Button
				If _Sleep($iDelayReturnHome2) Then ExitLoop
				$counter += 1
				If $counter > 40 Then ExitLoop
			WEnd
		EndIf
		If _Sleep($iDelayReturnHome3) Then Return ; wait for all report details
		_CaptureRegion(0, 0, $DEFAULT_WIDTH, $DEFAULT_HEIGHT - 45)
		AttackReport()
	EndIf
	If $TakeSS = 1 And $GoldChangeCheck = True Then
		SetLog("Taking snapshot of your loot", $COLOR_GREEN)
		Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
		Local $Time = @HOUR & "." & @MIN
		_CaptureRegion(0, 0, $DEFAULT_WIDTH, $DEFAULT_HEIGHT - 45)
		$hBitmap_Scaled = _GDIPlus_ImageResize($hBitmap, _GDIPlus_ImageGetWidth($hBitmap) / 2, _GDIPlus_ImageGetHeight($hBitmap) / 2) ;resize image
		; screenshot filename according with new options around filenames
		If $ScreenshotLootInfo = 1 Then
			$LootFileName = $Date & "_" & $Time & " G" & $iGoldLast & " E" & $iElixirLast & " DE" & $iDarkLast & " T" & $iTrophyLast & " S" & StringFormat("%3s", $SearchCount) & ".jpg"
		Else
			$LootFileName = $Date & "_" & $Time & ".jpg"
		EndIf
		_GDIPlus_ImageSaveToFile($hBitmap_Scaled, $dirLoots & $LootFileName)
		_GDIPlus_ImageDispose($hBitmap_Scaled)
	EndIf

	;push images if requested..
	If $GoldChangeCheck = True Then
		PushMsg("LastRaid")
	EndIf

	$i = 0 ; Reset Loop counter
	While 1
		If _CheckPixel($aEndFightSceneAvl, $bCapturePixel) Then ; check for the gold ribbon in the end of battle data screen
			If IsReturnHomeBattlePage() Then ClickP($aReturnHomeButton, 1, 0, "#0101") ;Click Return Home Button
			ExitLoop
		Else
			$i += 1
		EndIf
		If $i > 10 Then ExitLoop ; if end battle window is not found in 10*200mms or 2 seconds, then give up.
		If _Sleep($iDelayReturnHome5) Then Return
	WEnd
	If _Sleep($iDelayReturnHome2) Then Return ; short wait for screen to close

	$counter = 0
	While 1
		If _Sleep($iDelayReturnHome4) Then Return
		If StarBonus() = True Then Setlog("Star Bonus window closed chief!", $COLOR_BLUE) ; Check for Star Bonus window to fill treasury (2016-01) update
		If IsMainPage() Then
			_GUICtrlEdit_SetText($txtLog, _PadStringCenter(" BOT LOG ", 71, "="))
			_GUICtrlRichEdit_SetFont($txtLog, 6, "Lucida Console")
			_GUICtrlRichEdit_AppendTextColor($txtLog, "" & @CRLF, _ColorConvert($Color_Black))
			Return
		EndIf
		$counter += 1
		If $counter >= 50 Or isProblemAffect(True) Then
			SetLog("Cannot return home.", $COLOR_RED)
			checkMainScreen()
			Return
		EndIf
	WEnd
EndFunc   ;==>ReturnHome


