; #FUNCTION# ====================================================================================================================
; Name ..........: checkObstacles
; Description ...: Checks whether something is blocking the pixel for mainscreen and tries to unblock
; Syntax ........: checkObstacles()
; Parameters ....:
; Return values .: Returns True when there is something blocking
; Author ........: Hungle (2014)
; Modified ......: KnowJack (2015), Sardo (08-2015), TheMaster1st(10-2015), MonkeyHunter (08-2016), MMHK (12-2016), Moebius (11-2024)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
;
Func checkObstacles($bBuilderBase = Default) ;Checks if something is in the way for mainscreen
	FuncEnter(checkObstacles)
	If $bBuilderBase = Default Then $bBuilderBase = $g_bStayOnBuilderBase
	Static $iRecursive = 0

	If UBound(decodeSingleCoord(FindImageInPlace2("Update", $g_sImgCOCUpdate, 220, 165 + $g_iMidOffsetY, 350, 260 + $g_iMidOffsetY, True))) > 1 Or _
			UBound(decodeSingleCoord(FindImageInPlace2("UpdateNew", $g_sImgCOCUpdate, 350, 370 + $g_iMidOffsetY, 510, 450 + $g_iMidOffsetY, True))) > 1 Then ; COC Minor Update
		SetLog("Chief, we have COC Update!", $COLOR_INFO)
		ClickAway()
		If _Sleep($DELAYCHECKOBSTACLES1) Then Return
	EndIf

	If Not TestCapture() And WinGetAndroidHandle() = 0 Then
		; Android not available
		Return FuncReturn(True)
	ElseIf TestCapture() = 0 And GetAndroidProcessPID() = 0 Then
		; CoC not running
		Return checkObstacles_ReloadCoC() ; just start CoC (but first close it!)
	EndIf
	Local $wasForce = OcrForceCaptureRegion(False)
	$iRecursive += 1
	Local $Result = _checkObstacles($bBuilderBase, $iRecursive > 5)
	OcrForceCaptureRegion($wasForce)
	$iRecursive -= 1
	Return FuncReturn($Result)
EndFunc   ;==>checkObstacles

Func _checkObstacles($bBuilderBase = False, $bRecursive = False) ;Checks if something is in the way for mainscreen
	Local $msg, $x, $y, $Result
	$g_bMinorObstacle = False
	Local $aMessage
	Local $b_Switch = False

	_CaptureRegions()

	If Not $bRecursive Then
		If checkObstacles_Network() Then Return True
		If checkObstacles_GfxError() Then Return True
	EndIf

	If UBound(decodeSingleCoord(FindImageInPlace2("Loading", $g_sImgLoading, 380, 570 + $g_iBottomOffsetY, 490, 620 + $g_iBottomOffsetY, False))) > 1 Then

		;  Add check for banned account :(
		$Result = getOcrReloadMessage(290, 320 + $g_iMidOffsetY, "Check Obstacles OCR 'policy at super'=") ; OCR text for "policy at super"
		If StringInStr($Result, "policy", $STR_NOCASESENSEBASIC) Then
			$msg = "Sorry but account has been banned, Bot must stop!"
			BanMsgBox()
			Return checkObstacles_StopBot($msg) ; stop bot
		EndIf
		$Result = getOcrReloadMessage(410, 276 + $g_iMidOffsetY, "Check Obstacles OCR 'prohibited 3rd'= ") ; OCR text for "prohibited 3rd party"
		If StringInStr($Result, "3rd", $STR_NOCASESENSEBASIC) Then
			$msg = "Sorry but account has been banned, Bot must stop!"
			BanMsgBox()
			Return checkObstacles_StopBot($msg) ; stop bot
		EndIf

	EndIf

	Local $aPixelSearchGrey = _PixelSearch(481, 490 + $g_iMidOffsetY, 483, 494 + $g_iMidOffsetY, Hex(0xCBCDD3, 6), 10, True)
	Local $aPixelSearchFlamme = _PixelSearch(277, 134 + $g_iMidOffsetY, 279, 136 + $g_iMidOffsetY, Hex(0xFFFFDB, 6), 15, True)
	If IsArray($aPixelSearchGrey) And IsArray($aPixelSearchFlamme) Then
		Local $aiLockOfChest = decodeSingleCoord(FindImageInPlace2("LockOfBox", $ImgLockOfChest, 400, 305 + $g_iMidOffsetY, 480, 410 + $g_iMidOffsetY, True))
		If IsArray($aiLockOfChest) And UBound($aiLockOfChest) = 2 Then
			TreasureHunt()
			If _Sleep($DELAYCHECKOBSTACLES1) Then Return
			$g_bMinorObstacle = True
			Return False
		EndIf
	Else
		Local $aPixelSearchLight = _PixelSearch(404, 11, 406, 13, Hex(0xFEFEED, 6), 10, True)
		Local $aPixelSearchGreenContinue = _PixelSearch(428, 506 + $g_iMidOffsetY, 432, 508 + $g_iMidOffsetY, Hex(0x88D039, 6), 10, True)
		If IsArray($aPixelSearchLight) And IsArray($aPixelSearchGreenContinue) Then
			Local $aContinueButton = findButton("Continue", Default, 1, True)
			If IsArray($aContinueButton) And UBound($aContinueButton, 1) = 2 Then
				ClickP($aContinueButton, 1, 120, "#0433")
				SetLog("Reward Received", $COLOR_SUCCESS1)
				If _Sleep($DELAYTREASURY2) Then Return ; 1500ms
				$g_bMinorObstacle = True
				Return False
			EndIf
		EndIf
	EndIf

	If UBound(decodeSingleCoord(FindImageInPlace2("InfoButton", $g_sImgInfoButton, 740, 0, 840, 90 + $g_iMidOffsetY, False))) > 1 Then
		Local $NoThanksButton = decodeSingleCoord(FindImageInPlace2("NoThanksButton", $g_sImgNoThanks, 100, 140 + $g_iMidOffsetY, 400, 235 + $g_iMidOffsetY, False))
		If IsArray($NoThanksButton) And UBound($NoThanksButton) = 2 Then
			SetLog("Detected Feedback Window!", $COLOR_INFO)
			ClickP($NoThanksButton)
			If _Sleep($DELAYCHECKOBSTACLES1) Then Return
			$g_bMinorObstacle = True
			Return False
		EndIf
	EndIf

	If UBound(decodeSingleCoord(FindImageInPlace2("Survey", $g_sImgSurvey, 370, 40, 520, 120, False))) > 1 Then
		Local $NoThanksButton = decodeSingleCoord(FindImageInPlace2("NoThanksButton", $g_sImgNoThanks, 190, 410 + $g_iMidOffsetY, 340, 465 + $g_iMidOffsetY, False))
		If IsArray($NoThanksButton) And UBound($NoThanksButton) = 2 Then
			SetLog("Detected Survey Window!", $COLOR_INFO)
			ClickP($NoThanksButton)
			If _Sleep($DELAYCHECKOBSTACLES1) Then Return
			$g_bMinorObstacle = True
			Return False
		Else
			Local $NoThanksButton = decodeSingleCoord(FindImageInPlace2("NoThanksButton", $g_sImgNoThanks, 230, 530 + $g_iMidOffsetY, 340, 585 + $g_iMidOffsetY, False))
			If IsArray($NoThanksButton) And UBound($NoThanksButton) = 2 Then
				SetLog("Detected Survey Window!", $COLOR_INFO)
				ClickP($NoThanksButton)
				If _Sleep($DELAYCHECKOBSTACLES1) Then Return
				$g_bMinorObstacle = True
				Return False
			EndIf
		EndIf
	EndIf

	If UBound(decodeSingleCoord(FindImageInPlace2("Maintenance", $g_sImgMaintenance, 250, 40, 500, 100 + $g_iMidOffsetY, False))) > 1 Then ; Maintenance Break
		$Result = getOcrMaintenanceTime(285, 581 + $g_iMidOffsetY, "Check Obstacles OCR Maintenance Break=") ; OCR text to find wait time
		Local $iMaintenanceWaitTime = 0
		Local $avTime = StringRegExp($Result, "([\d]+)[Mm]|(soon)|([\d]+[Hh])", $STR_REGEXPARRAYMATCH)
		If UBound($avTime, 1) = 1 And Not @error Then
			If UBound($avTime, 1) = 3 Then
				$iMaintenanceWaitTime = $DELAYCHECKOBSTACLES10
			Else
				$iMaintenanceWaitTime = Int($avTime[0]) * 60000
				If $iMaintenanceWaitTime > $DELAYCHECKOBSTACLES10 Then $iMaintenanceWaitTime = $DELAYCHECKOBSTACLES10
			EndIf
		Else
			$iMaintenanceWaitTime = $DELAYCHECKOBSTACLES4 ; Wait 2 min
			$Result = getOcrMaintenanceTime(82, 581 + $g_iMidOffsetY, "Check Obstacles OCR Maintenance Break=")
			If StringInStr($Result, "soon", $STR_NOCASESENSEBASIC) Then
				SetLog("End Of Maintenance Break : Soon!, Waiting 2 Minutes", $COLOR_SUCCESS1)
			Else
				If @error Then SetLog("Error reading Maintenance Break time?", $COLOR_ERROR)
			EndIf
		EndIf
		SetLog("Maintenance Break, waiting: " & $iMaintenanceWaitTime / 60000 & " minutes", $COLOR_ERROR)
		If $g_bNotifyTGEnable And $g_bNotifyAlertMaintenance = True Then NotifyPushToTelegram("Maintenance Break, waiting: " & $iMaintenanceWaitTime / 60000 & " minutes....")
		If _SleepStatus($iMaintenanceWaitTime) Then Return
		If ClickB("ReloadButton") Then SetLog("Trying to reload game after maintenance break", $COLOR_INFO)
		checkObstacles_ResetSearch()
	EndIf

	If UBound(decodeSingleCoord(FindImageInPlace2("Error", $g_sImgError, 630, 270 + $g_iMidOffsetY, 632, 290 + $g_iMidOffsetY, False))) > 1 Then

		If TestCapture() Then Return "Village is out of sync or inactivity or connection lost"

		;;;;;;;;;;;;;;;;;;;; Connection Lost & Error & OOS & Inactivity & Major Update ;;;;;;;;;;;;;;;;;;;;
		Return CheckAllObstacles($g_bDebugImageSave, 0, 4, $bRecursive)
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	EndIf

	;;;;;;;;;;;;;;;;;;;; Google Play & COC Error & Personnal Datas ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	If CheckAllObstacles($g_bDebugImageSave, 5, 8, $bRecursive) Then Return True
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	If _ColorCheck(_GetPixelColor(618, 150 + $g_iMidOffsetY, $g_bCapturePixel), Hex(0xFFFFFF, 6), 10) And _ColorCheck(_GetPixelColor(735, 510 + $g_iMidOffsetY, $g_bCapturePixel), Hex(0xE9E8E1, 6), 10) Then
		SetDebugLog("checkObstacles: Found Window to close")
		CloseWindow2() ;See if village was attacked with Revenge Option : Click close button x
		$g_abNotNeedAllTime[0] = True
		$g_abNotNeedAllTime[1] = True
		$g_bMinorObstacle = True
		If _Sleep($DELAYCHECKOBSTACLES1) Then Return
		Return False
	ElseIf _ColorCheck(_GetPixelColor(810, 185 + $g_iMidOffsetY, $g_bCapturePixel), Hex(0x892B1F, 6), 20) Then
		SetDebugLog("checkObstacles: Found Window to close")
		PureClick(440, 510 + $g_iMidOffsetY, 1, 120, "#0132") ;See if village was attacked or upgrades finished : Click Okay
		$g_abNotNeedAllTime[0] = True
		$g_abNotNeedAllTime[1] = True
		$g_bMinorObstacle = True
		If _Sleep($DELAYCHECKOBSTACLES1) Then Return
		Return False
	EndIf

	Local $bIsOnBuilderBase = isOnBuilderBase()
	Local $bIsOnMainVillage = isOnMainVillage()
	If $bIsOnBuilderBase Or $bIsOnMainVillage Then
		Select
			Case $bBuilderBase And Not $bIsOnBuilderBase And $bIsOnMainVillage
				SetLog("Detected Main Village, trying to switch back to Builder Base")
				$b_Switch = True
			Case Not $bBuilderBase And $bIsOnBuilderBase And Not $bIsOnMainVillage
				SetLog("Detected Builder Base, trying to switch back to Main Village")
				$b_Switch = True
		EndSelect
		If $b_Switch Then
			If SwitchBetweenBases(True, $bBuilderBase) Then
				$g_bMinorObstacle = True
				If _Sleep($DELAYCHECKOBSTACLES1) Then Return
				Return False
			EndIf
		EndIf
	EndIf

	Local $bHasTopBlackBar = _ColorCheck(_GetPixelColor(10, 3, $g_bCapturePixel), Hex(0x000000, 6), 1) And _ColorCheck(_GetPixelColor(300, 6, $g_bCapturePixel), Hex(0x000000, 6), 1) And _
			_ColorCheck(_GetPixelColor(600, 9, $g_bCapturePixel), Hex(0x000000, 6), 1)
	If Not $bHasTopBlackBar And IsMainGrayed() Then
		SetDebugLog("checkObstacles: Found gray Window to close")
		; Season End Start
		If EndStartSeason() Then
			SetLog("Ended/New Season window closed chief!", $COLOR_INFO) ; Check for Ended or Started Season Window
			$g_bMinorObstacle = True
			Return False
		EndIf
		; Voucher / Magic Snack Freebie
		If Freebie() Then
			SetLog("Freebie window closed chief!", $COLOR_INFO) ; Check for Freebie Event window (2025-03)
			$g_bMinorObstacle = True
			Return False
		EndIf
		; Streak Event
		If CheckStreakEvent() Then
			SetLog("Streak Event window closed chief!", $COLOR_INFO) ; Check for Streak Event window to (2024-06) update
			$g_bMinorObstacle = True
			Return False
		EndIf
		; Offers Received from SuperCell Store
		Local $aiSCOffer = decodeSingleCoord(FindImageInPlace2("SCOffers", $g_sImgOkayBlue, 360, 400 + $g_iMidOffsetY, 510, 500 + $g_iMidOffsetY, True))
		If IsArray($aiSCOffer) And UBound($aiSCOffer) = 2 Then
			ClickP($aiSCOffer)
			If _Sleep($DELAYCHECKOBSTACLES1) Then Return
			$g_bMinorObstacle = True
			Return False
		EndIf
		; Clan Capital Result
		If UBound(decodeSingleCoord(FindImageInPlace2("CCResults", $g_sImgClanCapitalResults, 210, 130 + $g_iMidOffsetY, 320, 240 + $g_iMidOffsetY, True))) > 1 Then
			If _ColorCheck(_GetPixelColor(247, 311 + $g_iMidOffsetY, $g_bCapturePixel), Hex(0xFFFFFF, 6), 10) And _ColorCheck(_GetPixelColor(669, 242 + $g_iMidOffsetY, $g_bCapturePixel), Hex(0xFFFFFF, 6), 10) Then
				$g_bMinorObstacle = True
				CloseWindow()
				If _Sleep($DELAYCHECKOBSTACLES1) Then Return
				Return False
			EndIf
		EndIf
		; Daily Reward Window
		Local $aPixelSearchLeftGold = _PixelSearch(126, 545 + $g_iMidOffsetY, 130, 545 + $g_iMidOffsetY, Hex(0xFBE000, 6), 10, True)
		Local $aPixelSearchRightGold = _PixelSearch(816, 555 + $g_iMidOffsetY, 820, 555 + $g_iMidOffsetY, Hex(0xFCE227, 6), 10, True)
		If IsArray($aPixelSearchLeftGold) And IsArray($aPixelSearchRightGold) Then
			CheckDailyRewardWindow()
			$g_bMinorObstacle = True
			If _Sleep($DELAYCHECKOBSTACLES1) Then Return
			Return False
		EndIf
		;
		Local $aOkayButton = findButton("Okay", Default, 1, True)
		If IsArray($aOkayButton) And UBound($aOkayButton) = 2 Then
			ClickP($aOkayButton)
			$g_bMinorObstacle = True
			If _Sleep($DELAYCHECKOBSTACLES1) Then Return
			Return False
		EndIf
		Local $aConfirmButton = findButton("ConfirmButton", Default, 1, True)
		If IsArray($aConfirmButton) And UBound($aConfirmButton) = 2 Then
			ClickP($aConfirmButton)
			If _Sleep($DELAYCHECKOBSTACLES1) Then Return
		Else
			ClickAway() ; Click away If things are open
			If _Sleep($DELAYCHECKOBSTACLES1) Then Return
		EndIf
		If _CheckPixel($aIsMain, $g_bCapturePixel) Then
			$g_bMinorObstacle = True
			If _Sleep($DELAYCHECKOBSTACLES1) Then Return
			Return False
		Else
			CloseWindow2()
			If _Sleep($DELAYCHECKOBSTACLES1) Then Return
			If IsMainGrayed() Then
				SetDebugLog("checkObstacles: Still found gray Window to close, trying to close again")
				Local $bLoop = 0
				While 1
					ClickAway() ; Click away If things are open
					If _Sleep($DELAYCHECKOBSTACLES1) Then ExitLoop
					If _CheckPixel($aIsMain, $g_bCapturePixel) Then ExitLoop
					$bLoop += 1
					If $bLoop = 10 Then ExitLoop
				WEnd
			EndIf
		EndIf
		$g_bMinorObstacle = True
		If _Sleep($DELAYCHECKOBSTACLES1) Then Return
		Return False
	EndIf
	If Not $bHasTopBlackBar And IsBuilderBaseGrayed() Then
		SetLog("checkObstacles: Found Builder Base gray Window to close")
		; Season End Start
		If EndStartSeason() Then
			SetLog("Ended/New Season window closed chief!", $COLOR_INFO) ; Check for Ended or Started Season Window
			$g_bMinorObstacle = True
			Return False
		EndIf
		; Voucher / Magic Snack Freebie
		If Freebie() Then
			SetLog("Freebie window closed chief!", $COLOR_INFO) ; Check for Freebie Event window (2025-03)
			$g_bMinorObstacle = True
			Return False
		EndIf
		; Offers Received from SuperCell Store
		Local $aiSCOffer = decodeSingleCoord(FindImageInPlace2("SCOffers", $g_sImgOkayBlue, 360, 400 + $g_iMidOffsetY, 510, 500 + $g_iMidOffsetY, True))
		If IsArray($aiSCOffer) And UBound($aiSCOffer) = 2 Then
			ClickP($aiSCOffer)
			If _Sleep($DELAYCHECKOBSTACLES1) Then Return
			$g_bMinorObstacle = True
			Return False
		EndIf
		; Clan Capital Result
		If UBound(decodeSingleCoord(FindImageInPlace2("CCResults", $g_sImgClanCapitalResults, 210, 130 + $g_iMidOffsetY, 320, 240 + $g_iMidOffsetY, True))) > 1 Then
			If _ColorCheck(_GetPixelColor(247, 311 + $g_iMidOffsetY, $g_bCapturePixel), Hex(0xFFFFFF, 6), 10) And _ColorCheck(_GetPixelColor(669, 242 + $g_iMidOffsetY, $g_bCapturePixel), Hex(0xFFFFFF, 6), 10) Then
				$g_bMinorObstacle = True
				CloseWindow()
				If _Sleep($DELAYCHECKOBSTACLES1) Then Return
				Return False
			EndIf
		EndIf
		; Star Bonus Window (After Restart)
		If QuickMIS("BC1", $g_sImgBBAttackBonus, 360, 450 + $g_iMidOffsetY, 500, 510 + $g_iMidOffsetY) Then
			SetLog("Congrats Chief, Stars Bonus Awarded", $COLOR_INFO)
			Click($g_iQuickMISX, $g_iQuickMISY)
			If _Sleep(2000) Then Return
			$g_bMinorObstacle = True
			Return False
		EndIf
		Local $aOkayButton = findButton("Okay", Default, 1, True)
		If IsArray($aOkayButton) And UBound($aOkayButton) = 2 Then
			ClickP($aOkayButton)
			$g_bMinorObstacle = True
			If _Sleep($DELAYCHECKOBSTACLES1) Then Return
			Return False
		EndIf
		CloseWindow2()
		If _Sleep($DELAYCHECKOBSTACLES1) Then Return
		If IsBuilderBaseGrayed() Then
			SetDebugLog("checkObstacles: Still found gray Window to close, trying to close again")
			Local $bLoop = 0
			While 1
				ClickAway("Left") ;Click away If things are open
				If _Sleep($DELAYCHECKOBSTACLES1) Then ExitLoop
				If _CheckPixel($aIsOnBuilderBase, $g_bCapturePixel) Then ExitLoop
				$bLoop += 1
				If $bLoop = 10 Then ExitLoop
			WEnd
		EndIf
		$g_bMinorObstacle = True
		If _Sleep($DELAYCHECKOBSTACLES1) Then Return
		Return False
	EndIf
	If _CheckPixel($aCancelFight, $g_bCapturePixel) Or _CheckPixel($aCancelFight2, $g_bCapturePixel) Then
		SetDebugLog("checkObstacles: Found Cancel Fight to close")
		PureClickP($aCancelFight, 1, 120, "#0135") ;Clicks X
		$g_bMinorObstacle = True
		If _Sleep($DELAYCHECKOBSTACLES1) Then Return
		Return False
	EndIf
	If _CheckPixel($aChatTab, $g_bCapturePixel) And _CheckPixel($aChatTab2, $g_bCapturePixel) And _CheckPixel($aChatTab3, $g_bCapturePixel) Then
		SetDebugLog("checkObstacles: Found Chat Tab to close")
		If ClickB("ClanChat") Then ; Clicks chat Button
			$g_bMinorObstacle = True
			If _Sleep($DELAYCHECKOBSTACLES1) Then Return
			Return False
		EndIf
	EndIf
	If _CheckPixel($aEndFightSceneBtn, $g_bCapturePixel) Then
		SetDebugLog("checkObstacles: Found End Fight Scene to close")
		PureClickP($aEndFightSceneBtn, 1, 120, "#0137") ;If in that victory or defeat scene
		If _Sleep($DELAYCHECKOBSTACLES1) Then Return
		Return True
	EndIf
	If _CheckPixel($aSurrenderButton, $g_bCapturePixel) Then
		SetDebugLog("checkObstacles: Found End Battle to close")
		ReturnHome(False, False) ;If End battle is available
		Return True
	EndIf
	If _CheckPixel($aNoCloudsAttack, $g_bCapturePixel) Then ; Prevent drop of troops while searching
		$aMessage = _PixelSearch(23, 566 + $g_iBottomOffsetY, 36, 580 + $g_iBottomOffsetY, Hex(0xDADDCC, 6), 10, True)
		If IsArray($aMessage) Then
			SetDebugLog("checkObstacles: Found Return Home button")
			PureClick(67, 602 + $g_iBottomOffsetY, 1, 120, "#0138") ;Check if Return Home button available
			If _Sleep($DELAYCHECKOBSTACLES2) Then Return
			Return True
		EndIf
	EndIf
	If IsPostDefenseSummaryPage() Then
		$aMessage = _PixelSearch(23, 566 + $g_iBottomOffsetY, 36, 580 + $g_iBottomOffsetY, Hex(0xDADDCC, 6), 10, True)
		If IsArray($aMessage) Then
			SetDebugLog("checkObstacles: Found Post Defense Summary to close")
			PureClick(62, 607 + $g_iBottomOffsetY, 1, 120, "#0138") ;Check if Return Home button available
			If _Sleep($DELAYCHECKOBSTACLES2) Then Return
			Return True
		EndIf
	EndIf

	Local $CSFoundCoords = decodeSingleCoord(FindImageInPlace2("CocStopped", $g_sImgCocStopped, 250, 328 + $g_iMidOffsetY, 618, 402 + $g_iMidOffsetY, True))
	If UBound($CSFoundCoords) > 1 Then
		SetLog("CoC Has Stopped Error .....", $COLOR_ERROR)
		If TestCapture() Then Return "CoC Has Stopped Error ....."
		PushMsg("CoCError")
		If _Sleep($DELAYCHECKOBSTACLES1) Then Return
		PureClick($CSFoundCoords[0], $CSFoundCoords[1], 1, 120, "#0129") ;Check for "CoC has stopped error, looking for OK message" on screen
		If _Sleep($DELAYCHECKOBSTACLES2) Then Return
		Return checkObstacles_ReloadCoC($bRecursive)
	EndIf

	If UBound(decodeSingleCoord(FindImageInPlace2("MaintClock", $g_sImgMaintClock, 760, 160 + $g_iMidOffsetY, 860, 230 + $g_iMidOffsetY, True))) > 1 Then ; Maintenance Clock
		If isOnMainVillage() Then
			SetLog("Maintenance Clock detected, bot will stop few minutes", $COLOR_ERROR)
			_RunFunction('DonateCC,Train')
			If _Sleep($DELAYRUNBOT3) Then Return
			_RunFunction('RequestCC')
			If _Sleep($DELAYRUNBOT3) Then Return
			Local $iWaitTime = Random(120, 240, 1) ; Close COC For 2-4 minutes
			UniversalCloseWaitOpenCoC($iWaitTime * 1000, "MaintenanceClock", False, True, False)
			$g_bRestart = True
			Return False
		EndIf
	EndIf

	If $bHasTopBlackBar Then
		; if black bar at top, e.g. in Android home screen, restart CoC
		SetDebugLog("checkObstacles: Found Black Android Screen")
	EndIf

	If CheckLoginWithSupercellIDScreen() Then Return True

	Return False
EndFunc   ;==>_checkObstacles

; It's more easy to restart CoC app than click the message restarting the game :/
Func checkObstacles_ReloadCoC($bRecursive = False)
	If TestCapture() Then Return "Reload CoC"
	ForceCaptureRegion(True)
	OcrForceCaptureRegion(True)

	If ProfileSwitchAccountEnabled() And $g_bChkSharedPrefs And HaveSharedPrefs() Then
		PushSharedPrefs()
		If Not $bRecursive Then OpenCoC()
		Return True
	EndIf

	If Not $bRecursive Then CloseCoC(True)

	If _Sleep($DELAYCHECKOBSTACLES3) Then Return
	Return True
EndFunc   ;==>checkObstacles_ReloadCoC

; It's more easy to restart Emu than click the message restarting the game :/
Func checkObstacles_RebootAndroid($IsGfx = True, $IsNetwork = False, $IsErrorWindow = False)
	If TestCapture() Then Return "Reboot Android"
	ForceCaptureRegion(True)
	OcrForceCaptureRegion(True)
	$g_bGfxError = $IsGfx
	$g_bNetworkError = $IsNetwork
	$g_bErrorWindow = $IsErrorWindow
	CheckAndroidReboot()
	Return True
EndFunc   ;==>checkObstacles_RebootAndroid

Func checkObstacles_StopBot($msg)
	SetLog($msg, $COLOR_ERROR)
	If TestCapture() Then Return $msg
	If $g_bNotifyTGEnable And $g_bNotifyAlertMaintenance Then NotifyPushToTelegram($msg)
	OcrForceCaptureRegion(True)
	Btnstop() ; stop bot
	Return True
EndFunc   ;==>checkObstacles_StopBot

Func checkObstacles_ResetSearch()
	; reset fast restart flags to ensure base is rearmed after error event that has base offline for long duration, like Maintenance
	$g_bIsClientSyncError = False
	$g_bIsSearchLimit = False
	$g_abNotNeedAllTime[0] = True
	$g_abNotNeedAllTime[1] = True
	$g_bRestart = True ; signal all calling functions to return to runbot
EndFunc   ;==>checkObstacles_ResetSearch

Func BanMsgBox()
	Local $MsgBox
	Local $stext = "Sorry, your account is banned!!" & @CRLF & "Bot will stop now..."
	If TestCapture() Then Return $stext
	While 1
		PushMsg("BAN")
		_ExtMsgBoxSet(4, 1, 0x004080, 0xFFFF00, 20, "Comic Sans MS", 600)
		$MsgBox = _ExtMsgBox(48, "Ok", "Banned", $stext, 1)
		If $MsgBox = 1 Then Return
		_ExtMsgBoxSet(4, 1, 0xFFFF00, 0x004080, 20, "Comic Sans MS", 600)
		$MsgBox = _ExtMsgBox(48, "Ok", "Banned", $stext, 1)
		If $MsgBox = 1 Then Return
	WEnd
EndFunc   ;==>BanMsgBox

Func checkObstacles_Network($bForceCapture = False, $bReloadCoC = True)
	Static $hCocReconnectingTimer = 0 ; TimerHandle of first CoC reconnecting animation

	If UBound(decodeSingleCoord(FindImageInPlace2("CocReconnecting", $g_sImgCocReconnecting, 420, 325 + $g_iMidOffsetY, 440, 345 + $g_iMidOffsetY, $bForceCapture))) > 1 Then
		If $hCocReconnectingTimer = 0 Then
			SetLog("Network Connection lost...", $COLOR_ERROR)
			$hCocReconnectingTimer = __TimerInit()
		ElseIf __TimerDiff($hCocReconnectingTimer) > $g_iCoCReconnectingTimeout Then
			SetLog("Network Connection really lost, Reloading Android...", $COLOR_ERROR)
			$hCocReconnectingTimer = 0
			If $bReloadCoC = True Then Return checkObstacles_RebootAndroid(False, True, False)
			Return True
		Else
			SetLog("Network Connection lost, waiting...", $COLOR_ERROR)
		EndIf
	Else
		$hCocReconnectingTimer = 0
	EndIf

	Return False
EndFunc   ;==>checkObstacles_Network

Func checkObstacles_GfxError($bForceCapture = False, $bRebootAndroid = True)
	Local $aResult = decodeMultipleCoords(FindImage("GfxError", $g_sImgGfxError, "ECD", 100, $bForceCapture), 100, 100)
	If UBound($aResult) >= 8 Then
		SetLog(UBound($aResult) & " Gfx Errors detected, Reloading Android...", $COLOR_ERROR)
		; Save debug image
		SaveDebugImage("GfxError", False)
		If $bRebootAndroid Then Return checkObstacles_RebootAndroid(True, False, False)
		Return True
	EndIf

	Return False
EndFunc   ;==>checkObstacles_GfxError

Func ClashOfMagicAdvert($bDebugImageSave = $g_bDebugImageSave)
	; Initial Timer
	Local $hTimer = __TimerInit()

	SetDebugLog("Searching for Clash Of Magic Advert ...", $COLOR_DEBUG)

	Local $aiClashOfMagicAdvert = decodeSingleCoord(FindImageInPlace2("ClashOfMagicAdvert", $sImgClashOfMagicAdvert, 820, 10, 850, 35, False))

	If $bDebugImageSave Then SaveDebugRectImage("ClashOfMagicAdvert", "820,10,850,35")

	If IsArray($aiClashOfMagicAdvert) And UBound($aiClashOfMagicAdvert, 1) = 2 Then
		SetLog("Detected Clash Of Magic Advert! (in " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds)", $COLOR_INFO)

		If _Sleep(500) Then Return

		ClickP($aiClashOfMagicAdvert)

		Return True
	EndIf

	SetDebugLog("No Clash Of Magic Advert found! (in " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds)", $COLOR_INFO)

	Return False
EndFunc   ;==>ClashOfMagicAdvert

Func CheckAllObstacles($bDebugImageSave = $g_bDebugImageSave, $MinType = 0, $MaxType = 8, $bRecursive = False)

	Local $bRet = False, $Ref
	Local $aiIsAnotherDevice = False

	;;;;;;;;;;;;;;;;;;;;;;;;; Obstacle Types ;;;;;;;;;;;;;;;;;;;;;;;;;
	;; 0 : Connection Lost, Error, Another Device, Inactivity Or Login Failed Then Click "Try Again" Or "Reload" Or "Reload Game"
	;; 1 : Error! (Out of Sync)/OOS Then Click on "Reload Game"
	;; 2 : Rate Clash Of Clans Then click On "Never"
	;; 3 : Important Notice Then Click On "OK" Or "Agree"
	;; 4 : Major Update, Stop bot
	;; 5 : Google Play Services Has Stopped Then Click on "OK"
	;; 6 : Clash Of Clan isn't responding Then Reboot Emulator
	;; 7 : Personnal Data sharing
	;; 8 : Analytics
	;; 9 : Another Device Connected Then Wait $g_iAnotherDeviceWaitTime Then Click on "Reload"

	Local $aiObstacleType[10][7] = [["", "Detected Connection Lost!", $sImgConnectionLost, 170, 260, 400, 320], _
			["", "Detected Out Of Sync!", $sImgOos, 330, 310, 460, 350], _
			["", "Detected Rate Game!", $sImgRateGame, 170, 260, 400, 320], _
			["", "Detected Important Notice!", $sImgNotice, 170, 250, 400, 320], _
			["", "Detected Major Update!", $sImgMajorUpdate, 210, 270, 350, 360], _
			["", "Detected Google Play Services Has Stopped!", $sImgGPServices, 280, 300, 410, 340], _
			["", "Detected COC isn't Responding!!", $sImgClashNotResponding, 210, 240, 360, 310], _
			["", "Personnal Datas Sharing!!", $sImgPersonnalDatas, 0, 230, 170, 330], _
			["", "Analytics!!", $sImgAnalytics, 110, 320, 235, 380], _
			["", "Detected Another Device Connected!!", $sImgDevice, 220, 300, 360, 360]]

	Local $aiButtonType[6][6] = [["", $sImgReloadBtn, 170, 365, 330, 420], _
			["", $sImgNeverBtn, 540, 365, 700, 420], _
			["", $sImgOKBtn, 170, 370, 270, 430], _
			["", $sImgOKBtn, 630, 355, 700, 385], _
			["", $sImgDenyBtn, 340, 510, 540, 610], _
			["", $sImgDenyLightBtn, 170, 605, 295, 655]]

	; Initial Timer
	Local $hTimer = __TimerInit()

	For $i = $MinType To $MaxType

		$aiObstacleType[$i][0] = decodeSingleCoord(FindImageInPlace2("ErrorType", $aiObstacleType[$i][2], $aiObstacleType[$i][3], $aiObstacleType[$i][4] + _
				$g_iMidOffsetY, $aiObstacleType[$i][5], $aiObstacleType[$i][6] + $g_iMidOffsetY, False))

		If IsArray($aiObstacleType[$i][0]) And UBound($aiObstacleType[$i][0]) = 2 Then

			SetLog($aiObstacleType[$i][1] & " (in " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds)", $COLOR_INFO)

			If $i = 0 Then
				$aiObstacleType[9][0] = decodeSingleCoord(FindImageInPlace2("Device", $aiObstacleType[9][2], $aiObstacleType[9][3], $aiObstacleType[9][4] + _
						$g_iMidOffsetY, $aiObstacleType[9][5], $aiObstacleType[9][6] + $g_iMidOffsetY, False))
				If IsArray($aiObstacleType[9][0]) And UBound($aiObstacleType[9][0]) = 2 Then
					SetLog($aiObstacleType[9][1] & " (in " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds)", $COLOR_INFO)
					If $g_iAnotherDeviceWaitTime > 3600 Then
						SetLog("Another Device has connected, waiting " & Floor(Floor($g_iAnotherDeviceWaitTime / 60) / 60) & " hours " & Floor(Mod(Floor($g_iAnotherDeviceWaitTime / 60), 60)) & " minutes " & Floor(Mod($g_iAnotherDeviceWaitTime, 60)) & " seconds", $COLOR_ERROR)
						PushMsg("AnotherDevice3600")
					ElseIf $g_iAnotherDeviceWaitTime > 60 Then
						SetLog("Another Device has connected, waiting " & Floor(Mod(Floor($g_iAnotherDeviceWaitTime / 60), 60)) & " minutes " & Floor(Mod($g_iAnotherDeviceWaitTime, 60)) & " seconds", $COLOR_ERROR)
						PushMsg("AnotherDevice60")
					Else
						SetLog("Another Device has connected, waiting " & Floor(Mod($g_iAnotherDeviceWaitTime, 60)) & " seconds", $COLOR_ERROR)
						PushMsg("AnotherDevice")
					EndIf

					If _SleepStatus($g_iAnotherDeviceWaitTime * 1000) Then Return ; Wait as long as user setting in GUI, default 120 seconds
					$aiIsAnotherDevice = True
				EndIf
			ElseIf $i = 4 Then ;Major Update, Stop bot
				SetLog("Stop Bot Due To COC Update Required", $COLOR_ERROR)
				BotStop()
				Return True
			ElseIf $i = 6 Then ;Clash Of Clan isn't responding Then Reboot Emulator
				checkObstacles_RebootAndroid(False, False, True)
				$bRet = True
				ExitLoop
			EndIf

			If _Sleep(100) Then Return

			SetDebugLog("Searching for Button ...", $COLOR_INFO)

			; Find OK, Reload, Try Again, Never, No Thanks buttons

			Switch $i
				;; 0 : Connection Lost, Error, Another Device, Inactivity Or Login Failed Then Click "Try Again" Or "Reload" Or "Reload Game"
				;; 1 : Error! (Out of Sync)/OOS Then Click on "Reload Game"
				Case 0 To 1
					$Ref = 0
					;; 2 : Rate Clash Of Clans Then click On "Never"
				Case 2
					$Ref = 1
					;; 3 : Important Notice Then Click On "OK"
				Case 3
					$Ref = 2
					;; 5 : Google Play Services Has Stopped Then Click on "OK"
				Case 5
					$Ref = 3
					;; 7 : Personnal Data sharing
				Case 7
					$Ref = 4
					;; 8 : Analytics
				Case 8
					$Ref = 5
			EndSwitch

			$aiButtonType[$Ref][0] = decodeSingleCoord(FindImageInPlace2("Button", $aiButtonType[$Ref][1], $aiButtonType[$Ref][2], $aiButtonType[$Ref][3] + _
					$g_iMidOffsetY, $aiButtonType[$Ref][4], $aiButtonType[$Ref][5] + $g_iMidOffsetY, False))

			If IsArray($aiButtonType[$Ref][0]) And UBound($aiButtonType[$Ref][0], 1) = 2 Then

				If _Sleep(100) Then Return
				SetDebugLog("Found button....", $COLOR_SUCCESS1)
				SetDebugLog("Click Coords : " & ($aiButtonType[$Ref][0])[0] & "," & ($aiButtonType[$Ref][0])[1], $COLOR_ERROR)
				PureClickP($aiButtonType[$Ref][0])
				If _Sleep($DELAYCHECKOBSTACLES1) Then Return

				If $i = 0 And $aiIsAnotherDevice Then
					checkObstacles_ResetSearch()
				ElseIf $i > 1 Then
					$g_bMinorObstacle = True
					ExitLoop
				EndIf

			Else
				If $bDebugImageSave Then SaveDebugImage("CheckObstacles")
				SetDebugLog("Failed to find Button", $COLOR_DEBUG)

				If $i = 5 Then ; 5 : Google Play Services Has Stopped And "OK" Button Not Found
					checkObstacles_RebootAndroid(False, False, True)
				Else
					checkObstacles_ReloadCoC($bRecursive)
				EndIf

			EndIf

			$bRet = True
			ExitLoop

		Else

			If $i = 3 Then
				SetLog("Warning: Cannot find type of Reload error message", $COLOR_ERROR)
				If $bDebugImageSave Then SaveDebugImage("CheckObstacles")
				checkObstacles_ReloadCoC($bRecursive)
				$bRet = True
			EndIf

		EndIf

	Next

	SetDebugLog("No Obstacle Window found! (in " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds)", $COLOR_DEBUG)

	Return $bRet

EndFunc   ;==>CheckAllObstacles

Func CheckDailyRewardWindow()
	If Not $g_bRunState Then Return
	Local $sAllCoordsString, $aAllCoordsTemp, $aTempCoords
	Local $aAllCoords[0][2]
	If _Sleep($DELAYSTARBONUS100) Then Return
	Local $SearchArea = GetDiamondFromRect("80,280(660,250)")
	Local $aResult = findMultiple(@ScriptDir & "\imgxml\DailyChallenge\", $SearchArea, $SearchArea, 0, 1000, 7, "objectname,objectpoints", True)
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
EndFunc   ;==>CheckDailyRewardWindow

Func IsMainGrayed()

	Local $offColors1[2][3] = [[0x3D5F72, 4, 0], [0x7B7B77, 9, 0]] ; 2nd light blue pixel, 3rd white pixel
	Local $IsMainGrayed1 = _MultiPixelSearch(370, 7, 390, 9, 1, 1, Hex(0x576F7B, 6), $offColors1, 15) ; first light blue pixel on left of button
	SetDebugLog("Main 1 Pixel Color #1: " & _GetPixelColor(374, 8, True) & ", #2: " & _GetPixelColor(378, 8, True) & ", #3: " & _GetPixelColor(383, 8, True), $COLOR_DEBUG)
	If IsArray($IsMainGrayed1) Then Return True

	Local $offColors2[2][3] = [[0x253944, 4, 0], [0x4A4A47, 9, 0]] ; 2nd light blue pixel, 3rd white pixel
	Local $IsMainGrayed2 = _MultiPixelSearch(370, 7, 390, 9, 1, 1, Hex(0x34434A, 6), $offColors2, 15) ; first light blue pixel on left of button
	SetDebugLog("Main 2 Pixel Color #1: " & _GetPixelColor(374, 8, True) & ", #2: " & _GetPixelColor(378, 8, True) & ", #3: " & _GetPixelColor(383, 8, True), $COLOR_DEBUG)
	If IsArray($IsMainGrayed2) Then Return True

	Local $offColors3[2][3] = [[0x497188, 4, 0], [0x93938E, 9, 0]] ; 2nd light blue pixel, 3rd white pixel
	Local $IsMainGrayed3 = _MultiPixelSearch(370, 7, 390, 9, 1, 1, Hex(0x688593, 6), $offColors3, 15) ; first light blue pixel on left of button
	SetDebugLog("Main 3 Pixel Color #1: " & _GetPixelColor(374, 8, True) & ", #2: " & _GetPixelColor(378, 8, True) & ", #3: " & _GetPixelColor(383, 8, True), $COLOR_DEBUG)
	If IsArray($IsMainGrayed3) Then Return True

	Return False

EndFunc   ;==>IsMainGrayed

Func IsBuilderBaseGrayed()

	Local $offColors1[3][3] = [[0x3D5F72, 4, 0], [0x070707, 6, 0], [0x7B7B77, 8, 0]] ; 2nd light blue pixel, 3rd pixel Black, 4th pixel White
	Local $IsBuilderBaseGrayed1 = _MultiPixelSearch(440, 7, 465, 9, 1, 1, Hex(0x576F7B, 6), $offColors1, 15) ; first light blue pixel on left of button
	SetDebugLog("BB 1 Pixel Color #1: " & _GetPixelColor(451, 8, True) & ", #2: " & _GetPixelColor(455, 8, True) & ", #3: " & _GetPixelColor(457, 8, True) & ", #4: " & _GetPixelColor(459, 8, True), $COLOR_DEBUG)
	If IsArray($IsBuilderBaseGrayed1) Then Return True

	Local $offColors2[3][3] = [[0x253944, 4, 0], [0x040404, 6, 0], [0x4A4A47, 8, 0]] ; 2nd light blue pixel, 3rd pixel Black, 4th pixel White
	Local $IsBuilderBaseGrayed2 = _MultiPixelSearch(440, 7, 465, 9, 1, 1, Hex(0x34434A, 6), $offColors2, 15) ; first light blue pixel on left of button
	SetDebugLog("BB 2 Pixel Color #1: " & _GetPixelColor(451, 8, True) & ", #2: " & _GetPixelColor(455, 8, True) & ", #3: " & _GetPixelColor(457, 8, True) & ", #4: " & _GetPixelColor(459, 8, True), $COLOR_DEBUG)
	If IsArray($IsBuilderBaseGrayed2) Then Return True

	Local $offColors3[3][3] = [[0x497188, 4, 0], [0x080808, 6, 0], [0x93938E, 8, 0]] ; 2nd light blue pixel, 3rd pixel Black, 4th pixel White
	Local $IsBuilderBaseGrayed3 = _MultiPixelSearch(440, 7, 465, 9, 1, 1, Hex(0x688593, 6), $offColors3, 15) ; first light blue pixel on left of button
	SetDebugLog("BB 3 Pixel Color #1: " & _GetPixelColor(451, 8, True) & ", #2: " & _GetPixelColor(455, 8, True) & ", #3: " & _GetPixelColor(457, 8, True) & ", #4: " & _GetPixelColor(459, 8, True), $COLOR_DEBUG)
	If IsArray($IsBuilderBaseGrayed3) Then Return True

	Return False

EndFunc   ;==>IsBuilderBaseGrayed

Func Freebie()
	Local $GoButton = decodeSingleCoord(FindImageInPlace2("GoButton", $g_sImgGoButton, 390, 540 + $g_iMidOffsetY, 460, 580 + $g_iMidOffsetY, True))
	Local $MainClaimButton = decodeSingleCoord(FindImageInPlace2("ClaimButton", $g_sImgClaimButton, 380, 480 + $g_iMidOffsetY, 480, 530 + $g_iMidOffsetY, True))
	If IsArray($GoButton) And UBound($GoButton) = 2 Then
		SetDebugLog("Detected Go! Button", $COLOR_INFO)
		ClickP($GoButton)
		If _Sleep(2000) Then Return
		Local $ClaimButton = decodeSingleCoord(FindImageInPlace2("ClaimButton", $g_sImgClaimButton, 475, 380 + $g_iMidOffsetY, 600, 445 + $g_iMidOffsetY, True))
		If IsArray($ClaimButton) And UBound($ClaimButton) = 2 Then
			SetDebugLog("Detected Claim Button", $COLOR_INFO)
			ClickP($ClaimButton)
			If _Sleep(1500) Then Return
			Local $aiOkayButton = findButton("Okay", Default, 1, True)
			If IsArray($aiOkayButton) And UBound($aiOkayButton, 1) = 2 Then
				ClickP($aiOkayButton)
				If _Sleep(1000) Then Return
				Return True
			EndIf
		EndIf
	ElseIf IsArray($MainClaimButton) And UBound($MainClaimButton) = 2 Then
		SetDebugLog("Detected Claim Button", $COLOR_INFO)
		ClickP($MainClaimButton)
		If _Sleep(2000) Then Return
		Local $ClaimButton = decodeSingleCoord(FindImageInPlace2("ClaimButton", $g_sImgClaimButton, 475, 380 + $g_iMidOffsetY, 600, 445 + $g_iMidOffsetY, True))
		If IsArray($ClaimButton) And UBound($ClaimButton) = 2 Then
			SetDebugLog("Detected Claim Button", $COLOR_INFO)
			ClickP($ClaimButton)
			If _Sleep(1500) Then Return
			Local $aiOkayButton = findButton("Okay", Default, 1, True)
			If IsArray($aiOkayButton) And UBound($aiOkayButton, 1) = 2 Then
				ClickP($aiOkayButton)
				If _Sleep(1000) Then Return
				Return True
			EndIf
		EndIf
	EndIf
	Return False
EndFunc   ;==>Freebie

Func EndStartSeason()
	;Season Ended
	Local $LockEnded = decodeSingleCoord(FindImageInPlace2("LockEnded", $g_sImgLockEnd, 530, 110 + $g_iMidOffsetY, 605, 200 + $g_iMidOffsetY, True))
	If IsArray($LockEnded) And UBound($LockEnded) = 2 Then
		Local $aiOkayButton = findButton("Okay", Default, 1, True)
		If IsArray($aiOkayButton) And UBound($aiOkayButton, 1) = 2 Then
			ClickP($aiOkayButton)
			If _Sleep(1000) Then Return
			Return True
		EndIf
	EndIf

	;New Season
	Local $Watch = decodeSingleCoord(FindImageInPlace2("WatchButton", $g_sImgWatch, 330, 520 + $g_iMidOffsetY, 520, 600 + $g_iMidOffsetY, True))
	If IsArray($Watch) And UBound($Watch) = 2 Then
		CloseWindow2()
		If _Sleep(750) Then Return
		Return True
	EndIf

	Return False

EndFunc   ;==>EndStartSeason
