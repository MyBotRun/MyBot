; #FUNCTION# ====================================================================================================================
; Name ..........: WaitForClouds
; Description ...: Wait loop that checks for clouds to clear screen when searching for base to attack
;					  : Includes ability to extend search time beyond normal 5 minute idle time with randomization of max wait time base on trophy level
; Syntax ........: WaitForClouds()
; Parameters ....:
; Return values .: None
; Author ........: MonkeyHunter (08-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func WaitForClouds()

	If $g_iDebugSetlog = 1 Then Setlog("Begin WaitForClouds:", $COLOR_DEBUG1)

	Local $iCount = 0
	Local $bigCount = 0, $iLastTime = 0
	Local $hMinuteTimer, $iSearchTime
	Local $bEnabledGUI = False

	Local $maxSearchCount = 720 ; $maxSearchCount * 250ms ($iDelayGetResources1) = seconds wait time before reset in lower leagues: 720*250ms = 3 minutes
	Local $maxLongSearchCount = 7 ; $maxLongSearchCount * $maxSearchCount = seconds total wait time in higher leagues: ; 21 minutes, set a value here but is never used unless error

	Switch Int($iTrophyCurrent) ; add randomization to SearchCounters (long cloud keep alive time) for higher leagues
		Case 3700 To 4099 ; champion 1 league
			$maxSearchCount = Random(480, 840, 1) ; random range 2-3.5 minutes
			$maxLongSearchCount = Random(10, 12, 1) ; random range 20-40 minutes
		Case 4100 To 4399 ; Titan 3 league
			$maxSearchCount = Random(480, 840, 1) ; random range 2-3.5 minutes
			$maxLongSearchCount = Random(15, 25, 1) ; random range 30-87 minutes
		Case 4400 To 4699 ; Titan 2 league
			$maxSearchCount = Random(600, 840, 1) ; random range 2.5-3.5 minutes
			$maxLongSearchCount = Random(24, 42, 1) ; random range 60-147 minutes
		Case 4700 To 4999 ; Titan 1 league
			$maxSearchCount = Random(600, 840, 1) ; random range 2.5-3.5 minutes
			$maxLongSearchCount = Random(36, 50, 1) ; random range 90-175 minutes
		Case 5000 To 6500 ; Legend league
			$maxSearchCount = Random(600, 840, 1) ; random range 2.5-3.5 minutes
			$maxLongSearchCount = Random(80, 85, 1) ; random range 200-300 minutes
	EndSwitch
	If $g_iDebugSetlog Then ; display random values if debug log
		SetLog("RANDOM: $maxSearchCount= " & $maxSearchCount & "= " & Round($maxSearchCount / $iDelayGetResources1, 2) & " min between cloud chk", $COLOR_DEBUG)
		SetLog("RANDOM: $maxLongSearchCount= " & $maxLongSearchCount & "= " & Round(($maxSearchCount / $iDelayGetResources1) * $maxLongSearchCount, 2) & " min max search time", $COLOR_DEBUG)
	EndIf

	ForceCaptureRegion() ; ensure screenshots are not cached
	Local $hMinuteTimer = TimerInit() ; initialize timer for tracking search time

	While _CheckPixel($aNoCloudsAttack, $g_bCapturePixel) = False ; loop to wait for clouds to disappear
		If _Sleep($iDelayGetResources1) Then Return
		$iCount += 1
		If isProblemAffect(True) Then ; check for reload error messages and restart search if needed
			resetAttackSearch()
			Return
		EndIf
		If $iCount >= $maxSearchCount Then ; If clouds do not clear in alloted time do something
			If EnableLongSearch() = False Then ; Check if attacking in Champion 1 or higher league with long search that needs to be continued
				resetAttackSearch()
				Return
			Else
				$bigCount += 1 ; Increment long wait time fail safe timer
				If $bigCount > $maxLongSearchCount Then ; check maximum wait time
					$iSearchTime = TimerDiff($hMinuteTimer) / 60000 ;get time since minute timer start in minutes
					SetLog("Spent " & $iSearchTime & " minutes in Clouds searching, Restarting CoC and Bot...", $COLOR_ERROR)
					$Is_ClientSyncError = False ; disable fast OOS restart if not simple error and restarting CoC
					$g_bRestart = True
					CloseCoC(True)
					Return
				EndIf
				$iCount = 0 ; reset outer loop value
			EndIf
		EndIf
		If $g_iDebugSetlog = 1 Then _GUICtrlStatusBar_SetText($g_hStatusBar, " Status: Loop to clean screen without Clouds, # " & $iCount)
		$iSearchTime = TimerDiff($hMinuteTimer) / 60000 ;get time since minute timer start in minutes
		If $iSearchTime >= $iLastTime + 1 Then
			Setlog("Cloud wait time " & StringFormat("%.1f", $iSearchTime) & " minute(s)", $COLOR_INFO)
			$iLastTime += 1
			; once a minute safety checks for search fail/retry and Personal Break events
			If chkAttackSearchFail() = 2 Or chkAttackSearchPersonalBreak() = True Then
				resetAttackSearch()
				Return
			EndIf
			; attempt to enable GUI during long wait?
			If $iSearchTime > 2  And $bEnabledGUI = False Then
				AndroidShieldForceDown(True)
				EnableGuiControls() ; enable bot controls is more than 2 minutes wait
				SetLog("Enabled bot controls due to long wait time", $COLOR_SUCCESS)
				$bEnabledGUI = True
			EndIf
		EndIf

		ForceCaptureRegion() ; ensure screenshots are not cached
	WEnd

	If $bEnabledGUI = True Then
		SetLog("Disable bot controls after long wait time", $COLOR_SUCCESS)
		AndroidShieldForceDown(False)
		DisableGuiControls()
		SaveConfig()
		readConfig()
		applyConfig()
	EndIf

	; add delay as few clouds might be still on screen (better to check for remaining clouds at top right?)
	If _Sleep($iDelayCloudsCleared) Then Return

EndFunc   ;==>WaitForClouds

Func EnableLongSearch()
	; verifies that chat tab is active on cloud window due long search time, and open/closes chat window to avoid app closing while waiting for base to attack
	; Also checks for common error events, search fail/retry, and Personal Break that happen during long searches
	Local $result = ""
	Local $iCount, $jCount, $kCount, $wCount

	If $g_iDebugSetlog = 1 Then Setlog("Begin EnableLongSearch:", $COLOR_DEBUG1)

	If Int($iTrophyCurrent) < 3700 Then ; If not searching Champion 1 or higher, skip long waiting to return and restart due error
		If $g_iDebugSetlog = 1 Then Setlog("Long cloud search not enabled due trophy count: " & $iTrophyCurrent, $COLOR_DEBUG)
		Return False
	EndIf

	If chkSearchText() = True Then ;verify still in clouds by screen text and attempt to keep alive with chat tab
		$iCount = 0 ; initialize safety loop counter #1
		While 1
			If _CheckPixel($aOpenChatTab, $g_bCapturePixel, Default, "OpenChatTab check", $COLOR_DEBUG) Then ; check for open chat tab
				ClickP($aOpenChatTab, 1, 0, "#0510") ; Open chat tab
				If _Sleep($iDelayGetResources1) Then Return
				$jCount = 0 ; initialize safety loop counter #2
				While 1 ; wait for close chat tab to appear
					If _CheckPixel($aCloseChat, $g_bCapturePixel, Default, "CloseChatTab check", $COLOR_DEBUG) Then ; check for close chat tab
						ClickP($aCloseChat, 1, 0, "#0511") ; close chat tab
						$kCount = 0 ; initialize safety loop counter #3
						While 1 ; paranoid verification that chat window has closed
							If _Sleep($iDelaySleep) Then Return
							$result = getCloudTextShort(260, 349 + $g_iMidOffsetY, "Cloud Search Text: sea=", $COLOR_DEBUG, Default) ; OCR "Searching for oponents..." partially blocked text
							If _CheckPixel($aCloseChat, $g_bCapturePixel, Default, "CloseChatTab check", $COLOR_DEBUG) Then ; check for close chat tab is still there
								$kCount += 1
							ElseIf $result <> "" And StringInStr($result, "sea", $STR_NOCASESENSEBASIC) > 0 Then ; found "sea" characters in "Search" text?
								Return True ; success
							Else
								Return True ; success
							EndIf
							$kCount += 1 ; not needed, error prevention
							If $kCount > 30 Then ; wait up to 30 * (100ms delay + ~60ms OCR) = 4.8 seconds for chat window to close
								; verify that base has not been found?
								If chkSurrenderBtn() = True Then Return True ; check if clouds are gone.
								SetLog("Warning - Found CloseChat Btn still open during search extension", $COLOR_WARNING)
								Return False ; chat tab not closed, failed long search keep alive, need to restart
							EndIf
						WEnd
					EndIf
					If _Sleep($iDelaySleep) Then Return
					$jCount += 1
					If $jCount > 50 Then ; wait up to 50 * 100ms = 5 seconds for chat window to close
						If chkSurrenderBtn() = True Then Return True ; check if clouds are gone.
						SetLog("Warning - Not find CloseChat tab during search extension", $COLOR_WARNING)
						Return False ; chat tab not closed, failed long search keep alive, need to restart
					EndIf
				WEnd
			EndIf
			$iCount += 1
			If $iCount > 30 Then ; wait up to 30 * 100ms = 3 seconds for chat window to be found
				If chkSurrenderBtn() = True Then Return True ; check if clouds are gone.
				SetLog("Cloud Search Text found, but chat button not found, restart search..", $COLOR_ERROR)
				Return False ; chat tab not found, failed long search keep alive, need to restart
			EndIf
		WEnd
	Else ; OCR did not find cloud search messages
		If chkSurrenderBtn() = True Then Return True ; check if clouds are gone and stop waiting
		If chkAttackSearchPersonalBreak() = True Then Return False ; OCR check for Personal Break while in clouds, return after PB prep
		If chkAttackSearchFail() = 1 Then Return True ; OCR text for search fail message, and press rety if available, success continue searching
		If $g_iDebugSetlog = 1 Then SetLog("Cloud Search Text not found...", $COLOR_DEBUG)
		Return False
	EndIf

EndFunc   ;==>EnableLongSearch

Func chkSearchText()
	; boolean 50-60ms OCR check for yellow text "Searching for oponents..." message that appears during attack search with long cloud times
	Local $result
	$result = getCloudTextShort(388, 348 + $g_iMidOffsetY, "Cloud Search Text: for=", $COLOR_DEBUG, Default) ; OCR "Searching for oponents..." text
	If $result <> "" And StringInStr($result, "for", $STR_NOCASESENSEBASIC) <> 0 Then ; found "for" characters in text?
		Return True
	EndIf
	Return False
EndFunc   ;==>chkSearchText

Func chkAttackSearchFail()
	; boolean 50-60ms OCR check for pink text "unable to find villages to attack!" error message during search for base to attack
	Local $result
	$result = getCloudFailShort(271, 351 + $g_iMidOffsetY, "Cloud Search Fail Text: unable=", $COLOR_DEBUG, Default)
	If $result <> "" And StringInStr($result, "unable", $STR_NOCASESENSEBASIC) > 0 Then ; found "unable" characters in text
		If btnSearchFailRetry() = True Then ; if press retry button is success, then keep searching
			Setlog("Search Fail? Retry search button pushed, continue...", $COLOR_SUCCESS)
			Return 1
		Else
			SetLog("Warning, failed to find/press retry search button", $COLOR_WARNING)
			Return 2
		EndIf
	EndIf
EndFunc   ;==>chkAttackSearchFail

Func chkAttackSearchPersonalBreak()
	; Boolean 100ms OCR check for pink text "You must wait until after your Personal Break to start an attack." error message during search for base to attack
	Local $result
	$result = getCloudFailShort(499, 350 + $g_iMidOffsetY, "Cloud Search PB Text: Break=", $COLOR_DEBUG, Default)
	If $result <> "" And StringInStr($result, "break", $STR_NOCASESENSEBASIC) > 0 Then ; found "break" characters in text
		Setlog("Prepare base before Personal Break in clouds..", $COLOR_INFO)
		CheckBaseQuick(True, "cloud") ; check and restock base before exit.
		Return True
	EndIf
	If $ichkSinglePBTForced And _DateIsValid($sPBStartTime) Then  ; silly feature to use with long clouds, but check if single PB is enabled.
		Local $iTimeTillPBTstartSec = Int(_DateDiff('s', $sPBStartTime, _NowCalc())) ; time in seconds
		If $g_iDebugSetlog = 1 Then Setlog("PB starts in: " & $iTimeTillPBTstartSec & " Seconds", $COLOR_DEBUG)
		If $iTimeTillPBTstartSec >= 0 Then ; test if PBT date/time in past (positive value) or future (negative value
			Setlog("Prepare base before user forced Break..", $COLOR_INFO)
			CheckBaseQuick(True, "cloud") ; check and restock base before exit.
			Return True
		EndIf
	EndIf
	Return False
EndFunc   ;==>chkAttackSearchPersonalBreak

Func btnSearchFailRetry()
	; verify retry button exists, and press button, return false if button not found
	Local $offColors[3][3] = [[0x000000, 50, 8], [0x60B014, 55, 21], [0x020201, 90, 7]] ; 2nd=Black in "R", 3rd=green centered under text, 4th=black in v of letter "Y"
	Global $ButtonPixel = _MultiPixelSearch(364, 405 + $g_iMidOffsetY, 466, 430 + $g_iMidOffsetY, 1, 1, Hex(0x000000, 6), $offColors, 20) ; first vertical black pixel of Retry button edge
	If $g_iDebugSetlog = 1 Then Setlog("Retry btn clr chk-#1: " & _GetPixelColor(368, 347 + $g_iMidOffsetY, True) & ", #2: " & _
	   _GetPixelColor(368 + 50, 347 + 8 + $g_iMidOffsetY, True) & ", #3: " & _GetPixelColor(368 + 55, 347 + 21 + $g_iMidOffsetY, True) & ", #4: " & _
	   _GetPixelColor(368 + 90, 347 + 7 + $g_iMidOffsetY, True), $COLOR_DEBUG)
	If IsArray($ButtonPixel) Then
		If $g_iDebugSetlog = 1 Then
			Setlog("ButtonPixel = " & $ButtonPixel[0] & ", " & $ButtonPixel[1], $COLOR_DEBUG) ;Debug
			Setlog("Retry Btn Pixel color found #1: " & _GetPixelColor($ButtonPixel[0], $ButtonPixel[1], True) & ", #2: " & _GetPixelColor($ButtonPixel[0] + 144, _
			   $ButtonPixel[1], True) & ", #3: " & _GetPixelColor($ButtonPixel[0] + 54, $ButtonPixel[1] + 17, True) & ", #4: " & _GetPixelColor($ButtonPixel[0] + 54, _
			   $ButtonPixel[1] + 27, True), $COLOR_DEBUG)
		EndIf
		Click($ButtonPixel[0] + 75, $ButtonPixel[1] + 25, 1, 0, "#0512") ; Click Retry Button
		Return True
	EndIf
	Return False
EndFunc   ;==>btnSearchFailRetry

Func chkSurrenderBtn()
	; loop for a few seconds checking if surrender button exists and search is over
	Local $wCount = 0
	While 1
		If _CheckPixel($aSurrenderButton, $g_bCapturePixel, Default, "Surrender btn wait #" & $wCount, $COLOR_DEBUG) = True Then
			If $g_iDebugSetlog = 1 Then Setlog("Surrender button found, clouds gone, continue...", $COLOR_DEBUG)
			Return True
		EndIf
		If _Sleep($iDelaySleep) Then Return
		$wCount += 1
		If $wCount >= 30 Or isProblemAffect(True) Then ; exit loop in 30 * ~150ms = 4.5 seconds if surrender button not found or reload msg appears
			Return False
		EndIf
	WEnd
EndFunc   ;==>chkSurrenderBtn
