
; #FUNCTION# ====================================================================================================================
; Name ..........: VillageSearch
; Description ...: Searches for a village that until meets conditions
; Syntax ........: VillageSearch()
; Parameters ....:
; Return values .: None
; Author ........: Code Monkey #6
; Modified ......: kaganus (Jun/Aug 2015), Sardo 2015-07, KnowJack(Aug 2015) , The Master (2015), MonkeyHunter (02/08-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func VillageSearch() ;Control for searching a village that meets conditions
	Local $Result
	Local $weakBaseValues
	Local $logwrited = False
	$iSkipped = 0

	If $debugDeadBaseImage = 1 Or $iSearchEnableDebugDeadBaseImage > 0 Then
		DirCreate($dirTempDebug & "\SkippedZombies\")
		DirCreate($dirTempDebug & "\Zombies\")
		setZombie()
	EndIf

	If $Is_ClientSyncError = False Then
		For $i = 0 To $iModeCount - 1
			$iAimGold[$i] = $iMinGold[$i]
			$iAimElixir[$i] = $iMinElixir[$i]
			$iAimGoldPlusElixir[$i] = $iMinGoldPlusElixir[$i]
			$iAimDark[$i] = ($iChkMeetDE[$i] = 1 ? ($iMinDark[$i]) : (0))
			$iAimTrophy[$i] = ($iChkMeetTrophy[$i] = 1 ? ($iMinTrophy[$i]) : (0))
		Next
	EndIf

	If _Sleep($iDelayVillageSearch1) Then Return
	$Result = getAttackDisable(346, 182) ; Grab Ocr for TakeABreak check
	checkAttackDisable($iTaBChkAttack, $Result) ;last check to see If TakeABreak msg on screen for fast PC from PrepareSearch click
	If $Restart = True Then Return ; exit func
	If Not ($Is_SearchLimit) Then
		SetLog(_StringRepeat("=", 50), $COLOR_INFO)
	EndIf
	For $x = 0 To $iModeCount - 1
		If IsSearchModeActive($x) Then WriteLogVillageSearch($x)
	Next

	If Not ($Is_SearchLimit) Then
		SetLog(_StringRepeat("=", 50), $COLOR_INFO)
	Else
		SetLog(_PadStringCenter(" Restart To Search ", 54, "="), $COLOR_INFO)
	EndIf

	If $iChkAttackNow = 1 Then
		GUICtrlSetState($btnAttackNowDB, $GUI_SHOW)
		GUICtrlSetState($btnAttackNowLB, $GUI_SHOW)
		GUICtrlSetState($btnAttackNowTS, $GUI_SHOW)
		GUICtrlSetState($pic2arrow, $GUI_HIDE)
		GUICtrlSetState($lblVersion, $GUI_HIDE)
	EndIf

	If $Is_ClientSyncError = False And $Is_SearchLimit = False Then
		$SearchCount = 0
	EndIf

	If $Is_SearchLimit = True Then $Is_SearchLimit = False

	While 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;### Main Search Loop ###;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		; cleanup some vars used by imgloc just in case. usend in TH and DeadBase ( imgloc functions)
		ResetTHsearch()

		If $debugVillageSearchImages = 1 Then DebugImageSave("villagesearch")
		$logwrited = False
		$bBtnAttackNowPressed = False
		$hAttackCountDown = TimerInit()
		$SearchTHLResult = - 1

		Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
		Local $Time = @HOUR & "." & @MIN & "." & @SEC

		If $Restart = True Then Return ; exit func

		; ----------------- READ ENEMY VILLAGE RESOURCES  -----------------------------------
		WaitForClouds() ; Wait for clouds to disappear
		If $Restart = True Then Return ; exit func

		GetResources(False) ;Reads Resource Values
		If $Restart = True Then Return ; exit func

		SuspendAndroid()

		; ---------------- CHECK THE ACTIVE MODE  --------------------------------------------
		; $dbase = true if dead base found
		; $match[$i] = result of check between gui settings and target village resources
		; $isModeActive[$i] = the mode it is active or not (cups, research, army %)
		Local $noMatchTxt = ""
		Local $dbBase = False
		Local $match[$iModeCount]
		Global $isModeActive[$iModeCount]
		For $i = 0 To $iModeCount - 1
			$match[$i] = False
			$isModeActive[$i] = False
		Next

		If _Sleep($iDelayRespond) Then Return

		For $i = 0 To $iModeCount - 1
			$isModeActive[$i] = IsSearchModeActive($i)
			If $isModeActive[$i] Then
				$match[$i] = CompareResources($i)
			EndIf
		Next

		; only one capture here, very important for consistent debug images, zombies, redline calc etc.
		ForceCaptureRegion()
		_CaptureRegion2()

		; measure enemy village (only if resources match)
		For $i = 0 To $iModeCount - 1
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
		ElseIf ($iChkMeetOne[$DB] = 1 Or $iChkMeetOne[$LB] = 1) Then;meet one then attack, do not need correct resources
			$THString = FindTownhall(True, False)
		ElseIf $OptBullyMode = 1 And ($SearchCount >= $ATBullyMode) then
			; Check the TH for BullyMode
			$THString = FindTownhall(True, False)
		EndIf

		For $i = 0 To $iModeCount - 2
			If $isModeActive[$i] Then
				If $iChkMeetOne[$i] = 1 Then
					If $iChkMeetTH[$i] <> 1 And $iChkMeetTHO[$i] <> 1 Then
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
		If Not $RunState Then Return
		; check deadbase if no milking attack or milking attack but low cpu settings  ($MilkAttackType=1)
		Local $checkDeadBase = ($match[$DB] And $iAtkAlgorithm[$DB] <> 2) Or $match[$LB] Or ($match[$DB] And $iAtkAlgorithm[$DB] = 2 And $MilkAttackType = 1)
		If $checkDeadBase Then
			$dbBase = checkDeadBase()
		EndIf

		; ----------------- CHECK WEAK BASE -------------------------------------------------
		If (IsWeakBaseActive($DB) And $dbBase And ($match[$DB] Or $iChkMeetOne[$DB] = 1)) Or _
			(IsWeakBaseActive($LB) And ($match[$LB] Or $iChkMeetOne[$LB] = 1)) Then

			;let try to reduce weekbase time
			If ( $searchTH <> "-" ) then
				$weakBaseValues = IsWeakBase($IMGLOCTHLEVEL, $IMGLOCREDLINE, False)
			Else
				$weakBaseValues = IsWeakBase(11, "", False)
			EndIf

			For $i = 0 To $iModeCount - 2
				If IsWeakBaseActive($i) And (($i = $DB And $dbBase) Or $i <> $DB) And ($match[$i] Or $iChkMeetOne[$i] = 1) Then
					If getIsWeak($weakBaseValues, $i) Then
						$match[$i] = True
					Else
						$match[$i] = False
						$noMatchTxt &= ", Not a Weak Base for " & $sModeText[$i]
					EndIf
				EndIf
			Next
		EndIf

		; ----------------- CHECK MILKING ----------------------------------------------------
		CheckMilkingBase($match[$DB], $dbBase) ;update  $milkingAttackOutside, $MilkFarmObjectivesSTR, $searchTH  etc.

		ResumeAndroid()

		; ----------------- WRITE LOG VILLAGE FOUND AND ASSIGN VALUE AT $imatchmode and exitloop  IF CONTITIONS MEET ---------------------------
		If $match[$DB] And $iAtkAlgorithm[$DB] = 2 And $milkingAttackOutside = 1 Then
			SetLog($GetResourcesTXT, $COLOR_SUCCESS, "Lucida Console", 7.5)
			SetLog("      " & "Milking Attack th outside Found!", $COLOR_SUCCESS, "Lucida Console", 7.5)
			$logwrited = True
			$iMatchMode = $DB
			ExitLoop
		ElseIf $match[$DB] And $iAtkAlgorithm[$DB] = 2 And $MilkAttackType = 0 And StringLen($MilkFarmObjectivesSTR) > 0 Then
			SetLog($GetResourcesTXT, $COLOR_SUCCESS, "Lucida Console", 7.5)
			SetLog("      " & "Milking Attack HIGH CPU SETTINGS Found!", $COLOR_SUCCESS, "Lucida Console", 7.5)
			$logwrited = True
			$iMatchMode = $DB
			ExitLoop
		ElseIf $match[$DB] And $iAtkAlgorithm[$DB] = 2 And $MilkAttackType = 1 And StringLen($MilkFarmObjectivesSTR) > 0 And $dbBase Then
			SetLog($GetResourcesTXT, $COLOR_SUCCESS, "Lucida Console", 7.5)
			SetLog("      " & "Milking Attack LOW CPU SETTINGS Found!", $COLOR_SUCCESS, "Lucida Console", 7.5)
			$logwrited = True
			$iMatchMode = $DB
			ExitLoop
		ElseIf $match[$DB] And $dbBase Then
			SetLog($GetResourcesTXT, $COLOR_SUCCESS, "Lucida Console", 7.5)
			SetLog("      " & "Dead Base Found!", $COLOR_SUCCESS, "Lucida Console", 7.5)
			$logwrited = True
			$iMatchMode = $DB
			ExitLoop
		ElseIf $match[$LB] And Not $dbBase Then
			SetLog($GetResourcesTXT, $COLOR_SUCCESS, "Lucida Console", 7.5)
			SetLog("      " & "Live Base Found!", $COLOR_SUCCESS, "Lucida Console", 7.5)
			$logwrited = True
			$iMatchMode = $LB
			ExitLoop
		ElseIf $match[$LB] And $iDeadBaseDisableCollectorsFilter = 1 Then
			SetLog($GetResourcesTXT, $COLOR_SUCCESS, "Lucida Console", 7.5)
			SetLog("      " & "Live Base Found!*", $COLOR_SUCCESS, "Lucida Console", 7.5)
			$logwrited = True
			$iMatchMode = $LB
			ExitLoop
		ElseIf $OptBullyMode = 1 And ($SearchCount >= $ATBullyMode) Then  ; TH bully doesn't need the resources conditions
			If $SearchTHLResult = 1 Then
				SetLog($GetResourcesTXT, $COLOR_SUCCESS, "Lucida Console", 7.5)
				SetLog("      " & "Not a match, but TH Bully Level Found! ", $COLOR_SUCCESS, "Lucida Console", 7.5)
				$logwrited = True
				$iMatchMode = $iTHBullyAttackMode
				ExitLoop
			EndIf
		EndIf

		If SearchTownHallLoc() And $match[$TS] Then ; attack this base anyway because outside TH found to snipe
			If CompareResources($TS) Then
				SetLog($GetResourcesTXT, $COLOR_SUCCESS, "Lucida Console", 7.5)
				SetLog("      " & "TH Outside Found! ", $COLOR_SUCCESS, "Lucida Console", 7.5)
				$logwrited = True
				$iMatchMode = $TS
				ExitLoop
			Else
				$noMatchTxt &= ", Not a " & $sModeText[$TS] & ", fails resource min"
			EndIf
		EndIf

		If $match[$DB] And Not $dbBase Then
			$noMatchTxt &= ", Not a " & $sModeText[$DB]
		ElseIf $match[$LB] And $dbBase Then
			$noMatchTxt &= ", Not a " & $sModeText[$LB]
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
			$Restart = True
			$Is_ClientSyncError = True
			Return
		EndIf

		; ----------------- ADD RANDOM DELAY IF REQUESTED -----------------------------------
		If $iVSDelay > 0 And $iMaxVSDelay > 0 Then ; Check if village delay values are set
			If $iVSDelay <> $iMaxVSDelay Then ; Check if random delay requested
				If _Sleep(Round(1000 * Random($iVSDelay, $iMaxVSDelay))) Then Return ;Delay time is random between min & max set by user
			Else
				If _Sleep(1000 * $iVSDelay) Then Return ; Wait Village Serch delay set by user
			EndIf
		EndIf
		If _Sleep($iDelayRespond) Then Return

		; ------- Add attack not button delay and check button status
		If $iChkAttackNow = 1 And $iAttackNowDelay > 0 Then
			If _Sleep(1000 * $iAttackNowDelay) Then Return ; add human reaction time on AttackNow button function
		EndIf
		If $bBtnAttackNowPressed = True Then ExitLoop

		; ----------------- PRESS BUTTON NEXT  -------------------------------------------------
		If $checkDeadBase And $debugDeadBaseImage = 0 And $SearchCount > $iSearchEnableDebugDeadBaseImage Then
			SetLog("Enabled collecting debug images of dead bases (zombies)", $COLOR_DEBUG)
			SetLog("- Save skipped dead base when available Elixir with empty storage > " & (($aZombie[8] > -1) ? ($aZombie[8] & "k") : ("is disabled")), $COLOR_DEBUG)
			SetLog("- Save skipped dead base when available Elixir > " & (($aZombie[9] > -1) ? ($aZombie[9] & "k") : ("is disabled")), $COLOR_DEBUG)
			SetLog("- Save dead base when available Elixir < " & (($aZombie[10] > -1) ? ($aZombie[10] & "k") : ("is disabled")), $COLOR_DEBUG)
			SetLog("- Save dead base when raided Elixir < " & (($aZombie[7] > -1) ? ($aZombie[7] & "%") : ("is disabled")), $COLOR_DEBUG)
			$debugDeadBaseImage = 1
		EndIf
		If $debugDeadBaseImage = 1 Then setZombie()
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
				If $debugsetlog = 1 Then SetLog("Wait to see Next Button... " & $i, $COLOR_DEBUG)
			EndIf
			If $i >= 99 Or isProblemAffect(True) Then ; if we can't find the next button or there is an error, then restart
				$Is_ClientSyncError = True
				checkMainScreen()
				If $Restart Then
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
		If $Restart = True Then Return ; exit func

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
			$iGoldTotal -= $aSearchCost[$iTownHallLevel - 1]
		EndIf
		UpdateStats()

	WEnd ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;### Main Search Loop End ###;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; center village, also update global village coordinates (that overwrites home base data, but will reset when returning anyway)
	; centering disabled and village measuring moved to top
	;Local $aCenterVillage = SearchZoomOut($aCenterEnemyVillageClickDrag, True, "VillageSearch")
	;updateGlobalVillageOffset($aCenterVillage[3], $aCenterVillage[4]) ; update red line and TH location

	;--- show buttons attacknow ----
	If $bBtnAttackNowPressed = True Then
		Setlog(_PadStringCenter(" Attack Now Pressed! ", 50, "~"), $COLOR_SUCCESS)
	EndIf

	If $iChkAttackNow = 1 Then
		GUICtrlSetState($btnAttackNowDB, $GUI_HIDE)
		GUICtrlSetState($btnAttackNowLB, $GUI_HIDE)
		GUICtrlSetState($btnAttackNowTS, $GUI_HIDE)
		GUICtrlSetState($pic2arrow, $GUI_SHOW)
		GUICtrlSetState($lblVersion, $GUI_SHOW)
		$bBtnAttackNowPressed = False
	EndIf

	;--- write in log match found ----
	If $AlertSearch = 1 Then
		TrayTip($sModeText[$iMatchMode] & " Match Found!", "Gold: " & $searchGold & "; Elixir: " & $searchElixir & "; Dark: " & $searchDark & "; Trophy: " & $searchTrophy, "", 0)
		If FileExists(@WindowsDir & "\media\Festival\Windows Exclamation.wav") Then
			SoundPlay(@WindowsDir & "\media\Festival\Windows Exclamation.wav", 1)
		ElseIf FileExists(@WindowsDir & "\media\Windows Exclamation.wav") Then
			SoundPlay(@WindowsDir & "\media\Windows Exclamation.wav", 1)
		EndIf
	EndIf

	SetLog(_PadStringCenter(" Search Complete ", 50, "="), $COLOR_INFO)
	PushMsg("MatchFound")


;~ 	; --- TH Detection Check Once Conditions ---
;~ 	; if TownHall no previous detect and we need to TH snipe before attack DB or LB, locate TH and determine if it is placed inside or outside the village; log result in main log
;~ 	If  $iChkMeetTH[$iMatchMode] = 0 And $iChkMeetTHO[$iMatchMode] = 0 And  ($iMatchMode = $DB and $THSnipeBeforeDBEnable = 1 ) or ($iMatchMode = $LB and $THSnipeBeforeDBEnable = 1 ) Then
;~ 		$searchTH = checkTownHallADV2()

;~ 		If $searchTH = "-" Then ; retry with autoit search after $iDelayVillageSearch5 seconds
;~ 			If _Sleep($iDelayVillageSearch5) Then Return
;~ 			If $debugsetlog = 1 Then SetLog("2nd attempt to detect the TownHall!", $COLOR_ERROR)
;~ 			$searchTH = THSearch()
;~ 		EndIf

;~ 		If SearchTownHallLoc() = False And $searchTH <> "-" Then
;~ 			SetLog("Checking Townhall location: TH is inside, skip Attack TH")
;~ 		ElseIf $searchTH <> "-" Then
;~ 			SetLog("Checking Townhall location: TH is outside, Attacking Townhall!")
;~ 		Else
;~ 			SetLog("Checking Townhall location: Could not locate TH, skipping attack TH...")
;~ 		EndIf
;~ 	EndIf

	$Is_ClientSyncError = False

EndFunc   ;==>VillageSearch

Func SearchLimit($iSkipped)
	If $iChkRestartSearchLimit = 1 And $iSkipped >= Number($iRestartSearchlimit) Then
		Local $Wcount = 0
		While _CheckPixel($aSurrenderButton, $bCapturePixel) = False
			If _Sleep($iDelaySWHTSearchLimit1) Then Return
			$Wcount += 1
			If $debugsetlog = 1 Then setlog("wait surrender button " & $Wcount, $COLOR_DEBUG)
			If $Wcount >= 50 Or isProblemAffect(True) Then
				checkMainScreen()
				$Is_ClientSyncError = False ; reset OOS flag for long restart
				$Restart = True ; set force runbot restart flag
				Return True
			EndIf
		WEnd
		$Is_SearchLimit = True
		ReturnHome(False, False) ;If End battle is available
		getArmyCapacity(True, True)
		$Restart = True ; set force runbot restart flag
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
	If $iCmbMeetGE[$x] = 0 Then $MeetGxEtext = "- Meet: Gold and Elixir"
	If $iCmbMeetGE[$x] = 1 Then $MeetGorEtext = "- Meet: Gold or Elixir"
	If $iCmbMeetGE[$x] = 2 Then $MeetGplusEtext = "- Meet: Gold + Elixir"
	If $iChkMeetDE[$x] = 1 Then $MeetDEtext = "- Dark"
	If $iChkMeetTrophy[$x] = 1 Then $MeetTrophytext = "- Trophy"
	If $iChkMeetTH[$x] = 1 Then $MeetTHtext = "- Max TH " & $iMaxTH[$x] ;$icmbTH
	If $iChkMeetTHO[$x] = 1 Then $MeetTHOtext = "- TH Outside"
	If IsWeakBaseActive($x) Then $MeetWeakBasetext = "- Weak Base"
	If Not ($Is_SearchLimit) And $debugsetlog = 1 Then
		SetLog(_PadStringCenter(" Searching For " & $sModeText[$x] & " ", 54, "="), $COLOR_INFO)
		Setlog("Enable " & $sModeText[$x] & " search IF ", $COLOR_INFO)
		If $iEnableSearchSearches[$x] = 1 Then Setlog("- Numbers of searches range " & $iEnableAfterCount[$x] & " - " & $iEnableBeforeCount[$x], $COLOR_INFO)
		If $iEnableSearchTropies[$x] = 1 Then Setlog("- Search tropies range " & $iEnableAfterTropies[$x] & " - " & $iEnableBeforeTropies[$x], $COLOR_INFO)
		If $iEnableSearchCamps[$x] = 1 Then Setlog("- Army Camps % >  " & $iEnableAfterArmyCamps[$x], $COLOR_INFO)
		Setlog("Match " & $sModeText[$x] & "  village IF ", $COLOR_INFO)
		If $MeetGxEtext <> "" Then Setlog($MeetGxEtext, $COLOR_INFO)
		If $MeetGorEtext <> "" Then Setlog($MeetGorEtext, $COLOR_INFO)
		If $MeetGplusEtext <> "" Then Setlog($MeetGplusEtext, $COLOR_INFO)
		If $MeetDEtext <> "" Then Setlog($MeetDEtext, $COLOR_INFO)
		If $MeetTrophytext <> "" Then Setlog($MeetTrophytext, $COLOR_INFO)
		If $MeetTHtext <> "" Then Setlog($MeetTHtext, $COLOR_INFO)
		If $MeetTHOtext <> "" Then Setlog($MeetTHOtext, $COLOR_INFO)
		If $MeetWeakBasetext <> "" Then Setlog($MeetWeakBasetext, $COLOR_INFO)
		If $iChkMeetOne[$x] = 1 Then SetLog("Meet One and Attack!")
		SetLog(_PadStringCenter(" RESOURCE CONDITIONS ", 50, "~"), $COLOR_INFO)
		If $iChkMeetTH[$x] = 1 Then $iAimTHtext[$x] = " [TH]:" & StringFormat("%2s", $iMaxTH[$x]) ;$icmbTH
		If $iChkMeetTHO[$x] = 1 Then $iAimTHtext[$x] &= ", Out"
	EndIf
	If Not ($Is_SearchLimit) Then
		Local $txtTrophies = ""
		If $iChkMeetTrophy[$x] = 1 Then $txtTrophies = " [T]:" & StringFormat("%2s", $iAimTrophy[$x]) & $iAimTHtext[$x]
		If $iCmbMeetGE[$x] = 2 Then
			SetLog("Aim:           [G+E]:" & StringFormat("%7s", $iAimGoldPlusElixir[$x]) & " [D]:" & StringFormat("%5s", $iAimDark[$x]) & $txtTrophies & " for: " & $sModeText[$x], $COLOR_SUCCESS, "Lucida Console", 7.5)
		Else
			SetLog("Aim: [G]:" & StringFormat("%7s", $iAimGold[$x]) & " [E]:" & StringFormat("%7s", $iAimElixir[$x]) & " [D]:" & StringFormat("%5s", $iAimDark[$x]) & $txtTrophies & " for: " & $sModeText[$x], $COLOR_SUCCESS, "Lucida Console", 7.5)
		EndIf
	EndIf

EndFunc   ;==>WriteLogVillageSearch
