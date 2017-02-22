; #FUNCTION# ====================================================================================================================
; Name ..........: VillageSearch
; Description ...: Searches for a village that until meets conditions
; Syntax ........: VillageSearch()
; Parameters ....:
; Return values .: None
; Author ........: Code Monkey #6
; Modified ......: kaganus (Jun/Aug 2015), Sardo 2015-07, KnowJack(Aug 2015) , The Master (2015), MonkeyHunter (02/08-2016),
;				   CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $iSkipped = 0

Func VillageSearch() ;Control for searching a village that meets conditions
	Local $Result
	Local $weakBaseValues
	Local $logwrited = False
	$iSkipped = 0

	If $g_iDebugDeadBaseImage = 1 Or $g_aiSearchEnableDebugDeadBaseImage > 0 Then
		DirCreate($g_sProfileTempDebugPath & "\SkippedZombies\")
		DirCreate($g_sProfileTempDebugPath & "\Zombies\")
		setZombie()
	EndIf

	If $Is_ClientSyncError = False Then
		For $i = 0 To $g_iModeCount - 1
			$iAimGold[$i] = $g_aiFilterMinGold[$i]
			$iAimElixir[$i] = $g_aiFilterMinElixir[$i]
			$iAimGoldPlusElixir[$i] = $g_aiFilterMinGoldPlusElixir[$i]
			$iAimDark[$i] = ($g_abFilterMeetDEEnable[$i] ? ($g_aiFilterMeetDEMin[$i]) : (0))
			$iAimTrophy[$i] = ($g_abFilterMeetTrophyEnable[$i] ? ($g_aiFilterMeetTrophyMin[$i]) : (0))
		Next
	EndIf

	If _Sleep($iDelayVillageSearch1) Then Return
	$Result = getAttackDisable(346, 182) ; Grab Ocr for TakeABreak check
	checkAttackDisable($iTaBChkAttack, $Result) ;last check to see If TakeABreak msg on screen for fast PC from PrepareSearch click
	If $g_bRestart = True Then Return ; exit func
	If Not ($Is_SearchLimit) Then
		SetLog(_StringRepeat("=", 50), $COLOR_INFO)
	EndIf
	For $x = 0 To $g_iModeCount - 1
		If IsSearchModeActive($x) Then WriteLogVillageSearch($x)
	Next

	If Not ($Is_SearchLimit) Then
		SetLog(_StringRepeat("=", 50), $COLOR_INFO)
	Else
		SetLog(_PadStringCenter(" Restart To Search ", 54, "="), $COLOR_INFO)
	EndIf

	If $g_bSearchAttackNowEnable Then
		GUICtrlSetState($g_hBtnAttackNowDB, $GUI_SHOW)
		GUICtrlSetState($g_hBtnAttackNowLB, $GUI_SHOW)
		GUICtrlSetState($g_hBtnAttackNowTS, $GUI_SHOW)
		GUICtrlSetState($g_hPicTwoArrowShield, $GUI_HIDE)
		GUICtrlSetState($g_hLblVersion, $GUI_HIDE)
	EndIf

	If $Is_ClientSyncError = False And $Is_SearchLimit = False Then
		$SearchCount = 0
	EndIf

	If $Is_SearchLimit = True Then $Is_SearchLimit = False

	While 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;### Main Search Loop ###;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		; cleanup some vars used by imgloc just in case. usend in TH and DeadBase ( imgloc functions)
		ResetTHsearch()

		If $g_iDebugVillageSearchImages = 1 Then DebugImageSave("villagesearch")
		$logwrited = False
		$g_bBtnAttackNowPressed = False
		$SearchTHLResult = - 1

		Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
		Local $Time = @HOUR & "." & @MIN & "." & @SEC

		If $g_bRestart = True Then Return ; exit func

		; ----------------- READ ENEMY VILLAGE RESOURCES  -----------------------------------
		WaitForClouds() ; Wait for clouds to disappear
		If $g_bRestart = True Then Return ; exit func

		GetResources(False) ;Reads Resource Values
		If $g_bRestart = True Then Return ; exit func

		SuspendAndroid()

		; ---------------- CHECK THE ACTIVE MODE  --------------------------------------------
		; $dbase = true if dead base found
		; $match[$i] = result of check between gui settings and target village resources
		; $isModeActive[$i] = the mode it is active or not (cups, research, army %)
		Local $noMatchTxt = ""
		Local $dbBase = False
		Local $match[$g_iModeCount]
		Global $isModeActive[$g_iModeCount]
		For $i = 0 To $g_iModeCount - 1
			$match[$i] = False
			$isModeActive[$i] = False
		Next

		If _Sleep($iDelayRespond) Then Return

		For $i = 0 To $g_iModeCount - 1
			$isModeActive[$i] = IsSearchModeActive($i)
			If $isModeActive[$i] Then
				$match[$i] = CompareResources($i)
			EndIf
		Next

		; only one capture here, very important for consistent debug images, zombies, redline calc etc.
		ForceCaptureRegion()
		_CaptureRegion2()

		; measure enemy village (only if resources match)
		For $i = 0 To $g_iModeCount - 1
			If $match[$i] Then
				If CheckZoomOut("VillageSearch", True, False) = False Then
					; check two more times, only required for snow theme (snow fall can make it easily fail), but don't hurt to keep it
					$i = 0
					Local $bMeasured
					Do
						$i += 1
						If _Sleep($iDelayPrepareSearch3) Then Return ; wait 500 ms
						ForceCaptureRegion()
						_CaptureRegion2()
						$bMeasured = CheckZoomOut("VillageSearch", $i < 2, False)
					Until $bMeasured = True Or $i >= 2
					If $bMeasured = False Then Return ; exit func
				EndIf
				ExitLoop
			EndIf
		Next
		; ----------------- FIND TARGET TOWNHALL -------------------------------------------
		; $searchTH name of level of townhall (return "-" if no th found)
		; $THx and $THy coordinates of townhall
		Local $THString = ""
		If $match[$DB] Or $match[$LB] Or $match[$TS] Then; make sure resource conditions are met
			$THString = FindTownhall(False, False);find TH, but only if TH condition is checked
		ElseIf ($g_abFilterMeetOneConditionEnable[$DB] Or $g_abFilterMeetOneConditionEnable[$LB]) Then ; meet one then attack, do not need correct resources
			$THString = FindTownhall(True, False)
		ElseIf $g_abAttackTypeEnable[$TB] = 1 And ($SearchCount >= $g_iAtkTBEnableCount) then
			; Check the TH for BullyMode
			$THString = FindTownhall(True, False)
		EndIf

		For $i = 0 To $g_iModeCount - 2
			If $isModeActive[$i] Then
				If $g_abFilterMeetOneConditionEnable[$i] Then
					If $g_abFilterMeetTH[$i] = False And $g_abFilterMeetTHOutsideEnable[$i] = False Then
						;ignore, conditions not checked
					Else
						If CompareTH($i) Then $match[$i] = True;have a match if meet one enabled & a TH condition is met. ; UPDATE THE VARIABLE $SearchTHLResult
					EndIf
				Else
					If Not CompareTH($i) Then $match[$i] = False;if TH condition not met, skip. if it is, match is determined based on resources ; UPDATE THE VARIABLE $SearchTHLResult
				EndIf
			EndIf
		Next

		; Check the TH Level for BullyMode conditional
		if $SearchTHLResult = -1 then CompareTH(0)  ; inside have a conditional to update $SearchTHLResult

		; ----------------- WRITE LOG OF ENEMY RESOURCES -----------------------------------
		$GetResourcesTXT = StringFormat("%3s", $SearchCount) & "> [G]:" & StringFormat("%7s", $searchGold) & " [E]:" & StringFormat("%7s", $searchElixir) & " [D]:" & StringFormat("%5s", $searchDark) & " [T]:" & StringFormat("%2s", $searchTrophy) & $THString

		; ----------------- CHECK DEAD BASE -------------------------------------------------
		If Not $g_bRunState Then Return
		; check deadbase if no milking attack or milking attack but low cpu settings  ($g_iMilkAttackType=1)
		Local $checkDeadBase = ($match[$DB] And $g_aiAttackAlgorithm[$DB] <> 2) Or $match[$LB] Or ($match[$DB] And $g_aiAttackAlgorithm[$DB] = 2 And $g_iMilkAttackType = 1)
		If $checkDeadBase Then
			$dbBase = checkDeadBase()
		EndIf

		; ----------------- CHECK WEAK BASE -------------------------------------------------
        If (IsWeakBaseActive($DB) And $dbBase And ($match[$DB] Or $g_abFilterMeetOneConditionEnable[$DB])) Or _
            (IsWeakBaseActive($LB) And ($match[$LB] Or $g_abFilterMeetOneConditionEnable[$LB])) Then

			;let try to reduce weekbase time
			If ( $searchTH <> "-" ) then
				$weakBaseValues = IsWeakBase($IMGLOCTHLEVEL, $IMGLOCREDLINE, False)
			Else
				$weakBaseValues = IsWeakBase(11, "", False)
			EndIf

			For $i = 0 To $g_iModeCount - 2
				If IsWeakBaseActive($i) And (($i = $DB And $dbBase) Or $i <> $DB) And ($match[$i] Or $g_abFilterMeetOneConditionEnable[$i]) Then
					If getIsWeak($weakBaseValues, $i) Then
						$match[$i] = True
					Else
						$match[$i] = False
						$noMatchTxt &= ", Not a Weak Base for " & $g_asModeText[$i]
					EndIf
				EndIf
			Next
		EndIf

		; ----------------- CHECK MILKING ----------------------------------------------------
		CheckMilkingBase($match[$DB], $dbBase) ;update  $milkingAttackOutside, $MilkFarmObjectivesSTR, $searchTH  etc.

		ResumeAndroid()

		; ----------------- WRITE LOG VILLAGE FOUND AND ASSIGN VALUE AT $g_iMatchMode and exitloop  IF CONTITIONS MEET ---------------------------
		If $match[$DB] And $g_aiAttackAlgorithm[$DB] = 2 And $milkingAttackOutside = 1 Then
			SetLog($GetResourcesTXT, $COLOR_SUCCESS, "Lucida Console", 7.5)
			SetLog("      " & "Milking Attack th outside Found!", $COLOR_SUCCESS, "Lucida Console", 7.5)
			$logwrited = True
			$g_iMatchMode = $DB
			ExitLoop
		ElseIf $match[$DB] And $g_aiAttackAlgorithm[$DB] = 2 And $g_iMilkAttackType = 0 And StringLen($MilkFarmObjectivesSTR) > 0 Then
			SetLog($GetResourcesTXT, $COLOR_SUCCESS, "Lucida Console", 7.5)
			SetLog("      " & "Milking Attack HIGH CPU SETTINGS Found!", $COLOR_SUCCESS, "Lucida Console", 7.5)
			$logwrited = True
			$g_iMatchMode = $DB
			ExitLoop
		ElseIf $match[$DB] And $g_aiAttackAlgorithm[$DB] = 2 And $g_iMilkAttackType = 1 And StringLen($MilkFarmObjectivesSTR) > 0 And $dbBase Then
			SetLog($GetResourcesTXT, $COLOR_SUCCESS, "Lucida Console", 7.5)
			SetLog("      " & "Milking Attack LOW CPU SETTINGS Found!", $COLOR_SUCCESS, "Lucida Console", 7.5)
			$logwrited = True
			$g_iMatchMode = $DB
			ExitLoop
		ElseIf $match[$DB] And $dbBase Then
			SetLog($GetResourcesTXT, $COLOR_SUCCESS, "Lucida Console", 7.5)
			SetLog("      " & "Dead Base Found!", $COLOR_SUCCESS, "Lucida Console", 7.5)
			$logwrited = True
			$g_iMatchMode = $DB
			ExitLoop
		ElseIf $match[$LB] And Not $dbBase Then
			SetLog($GetResourcesTXT, $COLOR_SUCCESS, "Lucida Console", 7.5)
			SetLog("      " & "Live Base Found!", $COLOR_SUCCESS, "Lucida Console", 7.5)
			$logwrited = True
			$g_iMatchMode = $LB
			ExitLoop
		ElseIf $match[$LB] And $g_bCollectorFilterDisable Then
			SetLog($GetResourcesTXT, $COLOR_SUCCESS, "Lucida Console", 7.5)
			SetLog("      " & "Live Base Found!*", $COLOR_SUCCESS, "Lucida Console", 7.5)
			$logwrited = True
			$g_iMatchMode = $LB
			ExitLoop
		ElseIf $g_abAttackTypeEnable[$TB] = 1 And ($SearchCount >= $g_iAtkTBEnableCount) Then  ; TH bully doesn't need the resources conditions
			If $SearchTHLResult = 1 Then
				SetLog($GetResourcesTXT, $COLOR_SUCCESS, "Lucida Console", 7.5)
				SetLog("      " & "Not a match, but TH Bully Level Found! ", $COLOR_SUCCESS, "Lucida Console", 7.5)
				$logwrited = True
				$g_iMatchMode = $g_iAtkTBMode
				ExitLoop
			EndIf
		EndIf

		If SearchTownHallLoc() And $match[$TS] Then ; attack this base anyway because outside TH found to snipe
			If CompareResources($TS) Then
				SetLog($GetResourcesTXT, $COLOR_SUCCESS, "Lucida Console", 7.5)
				SetLog("      " & "TH Outside Found! ", $COLOR_SUCCESS, "Lucida Console", 7.5)
				$logwrited = True
				$g_iMatchMode = $TS
				ExitLoop
			Else
				$noMatchTxt &= ", Not a " & $g_asModeText[$TS] & ", fails resource min"
			EndIf
		EndIf

		If $match[$DB] And Not $dbBase Then
			$noMatchTxt &= ", Not a " & $g_asModeText[$DB]
		ElseIf $match[$LB] And $dbBase Then
			$noMatchTxt &= ", Not a " & $g_asModeText[$LB]
		EndIf

		If $noMatchTxt <> "" Then
			;SetLog(_PadStringCenter(" " & StringMid($noMatchTxt, 3) & " ", 50, "~"), $COLOR_DEBUG)
			SetLog($GetResourcesTXT, $COLOR_BLACK, "Lucida Console", 7.5)
			SetLog("      " & StringMid($noMatchTxt, 3), $COLOR_BLACK, "Lucida Console", 7.5)
			$logwrited = True
		EndIf

		If Not ($logwrited) Then
			SetLog($GetResourcesTXT, $COLOR_BLACK, "Lucida Console", 7.5)
		EndIf

		; Return Home on Search limit
		If SearchLimit($iSkipped + 1) Then Return True

		If checkAndroidReboot() = True Then
			$g_bRestart = True
			$Is_ClientSyncError = True
			Return
		EndIf

		; ----------------- ADD RANDOM DELAY IF REQUESTED -----------------------------------
		If $g_iSearchDelayMin > 0 And $g_iSearchDelayMax > 0 Then ; Check if village delay values are set
			If $g_iSearchDelayMin <> $g_iSearchDelayMax Then ; Check if random delay requested
				If _Sleep(Round(1000 * Random($g_iSearchDelayMin, $g_iSearchDelayMax))) Then Return ;Delay time is random between min & max set by user
			Else
				If _Sleep(1000 * $g_iSearchDelayMin) Then Return ; Wait Village Serch delay set by user
			EndIf
		EndIf
		If _Sleep($iDelayRespond) Then Return

		; ------- Add attack not button delay and check button status
		If $g_bSearchAttackNowEnable And $g_iSearchAttackNowDelay > 0 Then
			If _Sleep(1000 * $g_iSearchAttackNowDelay) Then Return ; add human reaction time on AttackNow button function
		EndIf
		If $g_bBtnAttackNowPressed = True Then ExitLoop

		; ----------------- PRESS BUTTON NEXT  -------------------------------------------------
        If $checkDeadBase And $g_iDebugDeadBaseImage = 0 And $SearchCount > $g_aiSearchEnableDebugDeadBaseImage Then
			SetLog("Enabled collecting debug images of dead bases (zombies)", $COLOR_DEBUG)
			SetLog("- Save skipped dead base when available Elixir with empty storage > " & (($g_aZombie[8] > -1) ? ($g_aZombie[8] & "k") : ("is disabled")), $COLOR_DEBUG)
			SetLog("- Save skipped dead base when available Elixir > " & (($g_aZombie[9] > -1) ? ($g_aZombie[9] & "k") : ("is disabled")), $COLOR_DEBUG)
			SetLog("- Save dead base when available Elixir < " & (($g_aZombie[10] > -1) ? ($g_aZombie[10] & "k") : ("is disabled")), $COLOR_DEBUG)
			SetLog("- Save dead base when raided Elixir < " & (($g_aZombie[7] > -1) ? ($g_aZombie[7] & "%") : ("is disabled")), $COLOR_DEBUG)
			$g_iDebugDeadBaseImage = 1
		EndIf
		If $g_iDebugDeadBaseImage = 1 Then setZombie()
		Local $i = 0
		While $i < 100
			If _Sleep($iDelayVillageSearch2) Then Return
			$i += 1
			If ( _ColorCheck(_GetPixelColor($NextBtn[0], $NextBtn[1], True), Hex($NextBtn[2], 6), $NextBtn[3])) And IsAttackPage() Then
				If $iUseRandomClick = 0 Then
					ClickP($NextBtn, 1, 0, "#0155") ;Click Next
				Else
					ClickR($NextBtnRND, $NextBtn[0], $NextBtn[1], 1, 0)
				EndIf
				ExitLoop
			Else
				If $g_iDebugSetlog = 1 Then SetLog("Wait to see Next Button... " & $i, $COLOR_DEBUG)
			EndIf
			If $i >= 99 Or isProblemAffect(True) Then ; if we can't find the next button or there is an error, then restart
				$Is_ClientSyncError = True
				checkMainScreen()
				If $g_bRestart Then
					$iNbrOfOoS += 1
					UpdateStats()
					SetLog("Couldn't locate Next button", $COLOR_ERROR)
					PushMsg("OoSResources")
				Else
					SetLog("Have strange problem Couldn't locate Next button, Restarting CoC and Bot...", $COLOR_ERROR)
					$Is_ClientSyncError = False ; disable fast OOS restart if not simple error and try restarting CoC
					CloseCoC(True)
				EndIf
				Return
			EndIf
		WEnd

		If _Sleep($iDelayRespond) Then Return
		$Result = getAttackDisable(346, 182) ; Grab Ocr for TakeABreak check
		checkAttackDisable($iTaBChkAttack, $Result) ; check to see If TakeABreak msg on screen after next click
		If $g_bRestart = True Then Return ; exit func

		If isGemOpen(True) = True Then
			Setlog(" Not enough gold to keep searching.....", $COLOR_ERROR)
			Click(585, 252, 1, 0, "#0156") ; Click close gem window "X"
			If _Sleep($iDelayVillageSearch3) Then Return
			$OutOfGold = 1 ; Set flag for out of gold to search for attack
			ReturnHome(False, False)
			Return
		EndIf

		$iSkipped = $iSkipped + 1
		$iSkippedVillageCount += 1
		If $iTownHallLevel <> "" And $iTownHallLevel > 0 Then
			$iSearchCost += $aSearchCost[$iTownHallLevel - 1]
			$g_iStatsTotalGain[$eLootGold] -= $aSearchCost[$iTownHallLevel - 1]
		EndIf
		UpdateStats()

	WEnd ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;### Main Search Loop End ###;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; center village, also update global village coordinates (that overwrites home base data, but will reset when returning anyway)
	; centering disabled and village measuring moved to top
	;Local $aCenterVillage = SearchZoomOut($aCenterEnemyVillageClickDrag, True, "VillageSearch")
	;updateGlobalVillageOffset($aCenterVillage[3], $aCenterVillage[4]) ; update red line and TH location

	;--- show buttons attacknow ----
	If $g_bBtnAttackNowPressed = True Then
		Setlog(_PadStringCenter(" Attack Now Pressed! ", 50, "~"), $COLOR_SUCCESS)
	EndIf

	If $g_bSearchAttackNowEnable Then
		GUICtrlSetState($g_hBtnAttackNowDB, $GUI_HIDE)
		GUICtrlSetState($g_hBtnAttackNowLB, $GUI_HIDE)
		GUICtrlSetState($g_hBtnAttackNowTS, $GUI_HIDE)
		GUICtrlSetState($g_hPicTwoArrowShield, $GUI_SHOW)
		GUICtrlSetState($g_hLblVersion, $GUI_SHOW)
		$g_bBtnAttackNowPressed = False
	EndIf

	;--- write in log match found ----
	If $g_bSearchAlertMe Then
		TrayTip($g_asModeText[$g_iMatchMode] & " Match Found!", "Gold: " & $searchGold & "; Elixir: " & $searchElixir & "; Dark: " & $searchDark & "; Trophy: " & $searchTrophy, "", 0)
		If FileExists(@WindowsDir & "\media\Festival\Windows Exclamation.wav") Then
			SoundPlay(@WindowsDir & "\media\Festival\Windows Exclamation.wav", 1)
		ElseIf FileExists(@WindowsDir & "\media\Windows Exclamation.wav") Then
			SoundPlay(@WindowsDir & "\media\Windows Exclamation.wav", 1)
		EndIf
	EndIf

	SetLog(_PadStringCenter(" Search Complete ", 50, "="), $COLOR_INFO)
	PushMsg("MatchFound")

	$Is_ClientSyncError = False

EndFunc   ;==>VillageSearch

Func SearchLimit($iSkipped)
	If $g_bSearchRestartEnable And $iSkipped >= Number($g_iSearchRestartLimit) Then
		Local $Wcount = 0
		While _CheckPixel($aSurrenderButton, $g_bCapturePixel) = False
			If _Sleep($iDelaySWHTSearchLimit1) Then Return
			$Wcount += 1
			If $g_iDebugSetlog = 1 Then setlog("wait surrender button " & $Wcount, $COLOR_DEBUG)
			If $Wcount >= 50 Or isProblemAffect(True) Then
				checkMainScreen()
				$Is_ClientSyncError = False ; reset OOS flag for long restart
				$g_bRestart = True ; set force runbot restart flag
				Return True
			EndIf
		WEnd
		$Is_SearchLimit = True
		ReturnHome(False, False) ;If End battle is available
		getArmyCapacity(True, True)
		$g_bRestart = True ; set force runbot restart flag
		$Is_ClientSyncError = True ; set OOS flag for fast restart
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>SearchLimit


Func WriteLogVillageSearch($x)
	;this function write in BOT LOG the values setting for each attack mode ($DB,$LB, $TS)
	;example
	;[18.07.30] ============== Searching For Dead Base ===============
	;[18.07.30] Enable Dead Base search IF
	;[18.07.30] - Army Camps % >  70
	;[18.07.30] Match Dead Base  village IF
	;[18.07.30] - Meet: Gold and Elixir
	;[18.07.30] - Weak Base(Mortar: 5, WizTower: 5)

	Local $MeetGxEtext = "", $MeetGorEtext = "", $MeetGplusEtext = "", $MeetDEtext = "", $MeetTrophytext = "", $MeetTHtext = "", $MeetTHOtext = "", $MeetWeakBasetext = "", $EnabledAftertext = ""
	If $g_aiFilterMeetGE[$x] = 0 Then $MeetGxEtext = "- Meet: Gold and Elixir"
	If $g_aiFilterMeetGE[$x] = 1 Then $MeetGorEtext = "- Meet: Gold or Elixir"
	If $g_aiFilterMeetGE[$x] = 2 Then $MeetGplusEtext = "- Meet: Gold + Elixir"
	If $g_abFilterMeetDEEnable[$x] Then $MeetDEtext = "- Dark"
	If $g_abFilterMeetTrophyEnable[$x] Then $MeetTrophytext = "- Trophy"
	If $g_abFilterMeetTH[$x] Then $MeetTHtext = "- Max TH " & $iMaxTH[$x] ;$g_aiFilterMeetTHMin
	If $g_abFilterMeetTHOutsideEnable[$x] Then $MeetTHOtext = "- TH Outside"
	If IsWeakBaseActive($x) Then $MeetWeakBasetext = "- Weak Base"
	If Not ($Is_SearchLimit) And $g_iDebugSetlog = 1 Then
		SetLog(_PadStringCenter(" Searching For " & $g_asModeText[$x] & " ", 54, "="), $COLOR_INFO)
		Setlog("Enable " & $g_asModeText[$x] & " search IF ", $COLOR_INFO)
		If $g_abSearchSearchesEnable[$x] Then Setlog("- Numbers of searches range " & $g_aiSearchSearchesMin[$x] & " - " & $g_aiSearchSearchesMax[$x], $COLOR_INFO)
		If $g_abSearchTropiesEnable[$x] Then Setlog("- Search tropies range " & $g_aiSearchTrophiesMin[$x] & " - " & $g_aiSearchTrophiesMax[$x], $COLOR_INFO)
		If $g_abSearchCampsEnable[$x] Then Setlog("- Army Camps % >  " & $g_aiSearchCampsPct[$x], $COLOR_INFO)
		Setlog("Match " & $g_asModeText[$x] & "  village IF ", $COLOR_INFO)
		If $MeetGxEtext <> "" Then Setlog($MeetGxEtext, $COLOR_INFO)
		If $MeetGorEtext <> "" Then Setlog($MeetGorEtext, $COLOR_INFO)
		If $MeetGplusEtext <> "" Then Setlog($MeetGplusEtext, $COLOR_INFO)
		If $MeetDEtext <> "" Then Setlog($MeetDEtext, $COLOR_INFO)
		If $MeetTrophytext <> "" Then Setlog($MeetTrophytext, $COLOR_INFO)
		If $MeetTHtext <> "" Then Setlog($MeetTHtext, $COLOR_INFO)
		If $MeetTHOtext <> "" Then Setlog($MeetTHOtext, $COLOR_INFO)
		If $MeetWeakBasetext <> "" Then Setlog($MeetWeakBasetext, $COLOR_INFO)
		If $g_abFilterMeetOneConditionEnable[$x] Then SetLog("Meet One and Attack!")
		SetLog(_PadStringCenter(" RESOURCE CONDITIONS ", 50, "~"), $COLOR_INFO)
	EndIf
	If Not ($Is_SearchLimit) Then
		Local $txtTrophies = "", $txtTownhall = ""
		If $g_abFilterMeetTrophyEnable[$x] Then $txtTrophies = " [T]:" & StringFormat("%2s", $iAimTrophy[$x])
		If $g_abFilterMeetTH[$x] Then $txtTownhall = " [TH]:" & StringFormat("%2s", $iMaxTH[$x]) ;$g_aiFilterMeetTHMin
		If $g_abFilterMeetTHOutsideEnable[$x] Then $txtTownhall &= ", Out"
		If $g_aiFilterMeetGE[$x] = 2 Then
			SetLog("Aim:           [G+E]:" & StringFormat("%7s", $iAimGoldPlusElixir[$x]) & " [D]:" & StringFormat("%5s", $iAimDark[$x]) & $txtTrophies & $txtTownhall & " for: " & $g_asModeText[$x], $COLOR_SUCCESS, "Lucida Console", 7.5)
		Else
			SetLog("Aim: [G]:" & StringFormat("%7s", $iAimGold[$x]) & " [E]:" & StringFormat("%7s", $iAimElixir[$x]) & " [D]:" & StringFormat("%5s", $iAimDark[$x]) & $txtTrophies & $txtTownhall & " for: " & $g_asModeText[$x], $COLOR_SUCCESS, "Lucida Console", 7.5)
		EndIf
	EndIf

EndFunc   ;==>WriteLogVillageSearch
