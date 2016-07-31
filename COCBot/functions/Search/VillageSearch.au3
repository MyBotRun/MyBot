
; #FUNCTION# ====================================================================================================================
; Name ..........: VillageSearch
; Description ...: Searches for a village that until meets conditions
; Syntax ........: VillageSearch()
; Parameters ....:
; Return values .: None
; Author ........: Code Monkey #6
; Modified ......: kaganus (Jun/Aug 2015), Sardo 2015-07, KnowJack(Aug 2015) , The Master (2015), MonkeyHunter (2016-2)
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

	If $debugDeadBaseImage = 1 Then
		If DirGetSize(@ScriptDir & "\SkippedZombies\") = -1 Then DirCreate(@ScriptDir & "\SkippedZombies\")
		If DirGetSize(@ScriptDir & "\Zombies\") = -1 Then DirCreate(@ScriptDir & "\Zombies\")
	EndIf

	If $Is_ClientSyncError = False Then
		For $i = 0 To $iModeCount - 1
			$iAimGold[$i] = $iMinGold[$i]
			$iAimElixir[$i] = $iMinElixir[$i]
			$iAimGoldPlusElixir[$i] = $iMinGoldPlusElixir[$i]
			$iAimDark[$i] = $iMinDark[$i]
			$iAimTrophy[$i] = $iMinTrophy[$i]
		Next
	EndIf

	_WinAPI_EmptyWorkingSet(GetAndroidPid()) ; Reduce Working Set of Android Process
	_WinAPI_EmptyWorkingSet(@AutoItPID) ; Reduce Working Set of Bot

	If _Sleep($iDelayVillageSearch1) Then Return
	$Result = getAttackDisable(346, 182) ; Grab Ocr for TakeABreak check
	checkAttackDisable($iTaBChkAttack, $Result) ;last check to see If TakeABreak msg on screen for fast PC from PrepareSearch click
	If $Restart = True Then Return ; exit func
	If Not ($Is_SearchLimit) Then
		SetLog(_StringRepeat("=", 50), $COLOR_BLUE)
	EndIf
	For $x = 0 To $iModeCount - 1
		If  IsSearchModeActive($x) then WriteLogVillageSearch($x)
	Next

	If Not ($Is_SearchLimit) Then
		SetLog(_StringRepeat("=", 50), $COLOR_BLUE)
	Else
		SetLog(_PadStringCenter(" Restart To Search ", 54, "="), $COLOR_BLUE)
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

#comments-start
	;mikemikemikecoc - Wait For Spells
	For $i = 0 To $iModeCount - 2 ;check if DB and LB are active or not
		If IsSearchModeActive($i) = False Then
			Setlog("Search conditions not satisfied for " & $sModeText[$i] & ", skipping mode:", $COLOR_BLUE)
			Setlog(" - wait troops, heroes and/or spells according to search settings", $COLOR_BLUE)
		EndIf
	Next
#comments-end

	While 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;### Main Search Loop ###;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		If $debugVillageSearchImages = 1 Then DebugImageSave("villagesearch")
		$logwrited = False
		$bBtnAttackNowPressed = False
		$hAttackCountDown = TimerInit()

		; ----------------- ADD RANDOM DELAY IF REQUESTED -----------------------------------
		If $iVSDelay > 0 And $iMaxVSDelay > 0 Then ; Check if village delay values are set
			If $iVSDelay <> $iMaxVSDelay Then ; Check if random delay requested
				If _Sleep(Round(1000 * Random($iVSDelay, $iMaxVSDelay))) Then Return ;Delay time is random between min & max set by user
			Else
				If _Sleep(1000 * $iVSDelay) Then Return ; Wait Village Serch delay set by user
			EndIf
		EndIf

		Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
		Local $Time = @HOUR & "." & @MIN & "." & @SEC

		If $Restart = True Then Return ; exit func

		; ----------------- READ ENEMY VILLAGE RESOURCES  -----------------------------------
		GetResources(False) ;Reads Resource Values
		If $Restart = True Then Return ; exit func

		If Mod(($iSkipped + 1), 100) = 0 Then
			_WinAPI_EmptyWorkingSet(WinGetProcess($HWnD)) ; reduce Android memory
			If _Sleep($iDelayRespond) Then Return
			If CheckZoomOut() = False Then Return
		EndIf

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

		;If _Sleep($iDelayRespond) Then Return

		; ----------------- FIND TARGET TOWNHALL -------------------------------------------
		; $searchTH name of level of townhall (return "-" if no th found)
		; $THx and $THy coordinates of townhall
		Local $THString = ""
		$searchTH = "-"
		$THx=0
		$THy=0

		If $match[$DB] Or $match[$LB] Or $match[$TS] Then; make sure resource conditions are met
			$THString = FindTownhall(False);find TH, but only if TH condition is checked
		ElseIf ($iChkMeetOne[$DB] = 1 Or $iChkMeetOne[$LB] = 1) Then;meet one then attack, do not need correct resources
			$THString = FindTownhall(True)
		EndIf

		For $i = 0 To $iModeCount - 2
		   If $isModeActive[$i] Then
			  If $iChkMeetOne[$i] = 1 Then
				  If $iChkMeetTH[$i] <> 1 And $iChkMeetTHO[$i] <> 1 Then
					  ;ignore, conditions not checked
				  Else
					  If CompareTH($i) Then $match[$i] = True;have a match if meet one enabled & a TH condition is met.
				  EndIf
			  Else
				  If Not CompareTH($i) Then $match[$i] = False;if TH condition not met, skip. if it is, match is determined based on resources
			  EndIf
		   EndIf
		Next

		; ----------------- WRITE LOG OF ENEMY RESOURCES -----------------------------------
		$GetResourcesTXT = StringFormat("%3s", $SearchCount) & "> [G]:" & StringFormat("%7s", $searchGold) & " [E]:" & StringFormat("%7s", $searchElixir) & " [D]:" & StringFormat("%5s", $searchDark) & " [T]:" & StringFormat("%2s", $searchTrophy) & $THString
		;If _Sleep($iDelayRespond) Then Return


		; ----------------- CHECK DEAD BASE -------------------------------------------------
		;If _Sleep($iDelayRespond) Then Return

		; check deadbase if no milking attack or milking attack but low cpu settings  ($MilkAttackType=1)
		If ($match[$DB] and $iAtkAlgorithm[$DB] <>2 ) or $match[$LB] or ($match[$DB] and $iAtkAlgorithm[$DB]=2 and $MilkAttackType = 1 ) Then
			$dbBase = checkDeadBase()
		EndIf

		; ----------------- CHECK WEAK BASE -------------------------------------------------
		If ($isModeActive[$DB] And IsWeakBaseActive($DB) And $dbBase And ($match[$DB] Or $iChkMeetOne[$DB] = 1)) Or _
			($isModeActive[$LB] And IsWeakBaseActive($LB) And ($match[$LB] Or $iChkMeetOne[$LB] = 1)) Then
			$weakBaseValues = IsWeakBase()
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
		 CheckMilkingBase($match[$DB],$dbBase) ;update  $milkingAttackOutside, $MilkFarmObjectivesSTR, $searchTH  etc.

		ResumeAndroid()

		; ----------------- WRITE LOG VILLAGE FOUND AND ASSIGN VALUE AT $imatchmode and exitloop  IF CONTITIONS MEET ---------------------------
		;If _Sleep($iDelayRespond) Then Return


		If $match[$DB] And $iAtkAlgorithm[$DB] = 2 And $milkingAttackOutside = 1  Then
			SetLog($GetResourcesTXT, $COLOR_GREEN, "Lucida Console", 7.5)
			SetLog("      " & "Milking Attack th outside Found!", $COLOR_GREEN, "Lucida Console", 7.5)
			$logwrited = True
			$iMatchMode = $DB
			ExitLoop
		ElseIf $match[$DB] And $iAtkAlgorithm[$DB] = 2 And $MilkAttackType = 0 and StringLen($MilkFarmObjectivesSTR) >0 then
			SetLog($GetResourcesTXT, $COLOR_GREEN, "Lucida Console", 7.5)
			SetLog("      " & "Milking Attack HIGH CPU SETTINGS Found!", $COLOR_GREEN, "Lucida Console", 7.5)
			$logwrited = True
			$iMatchMode = $DB
			ExitLoop
		ElseIf $match[$DB] And $iAtkAlgorithm[$DB] = 2 And $MilkAttackType = 1 and StringLen($MilkFarmObjectivesSTR) >0  and $dbBase then
			SetLog($GetResourcesTXT, $COLOR_GREEN, "Lucida Console", 7.5)
			SetLog("      " & "Milking Attack LOW CPU SETTINGS Found!", $COLOR_GREEN, "Lucida Console", 7.5)
			$logwrited = True
			$iMatchMode = $DB
			ExitLoop
		ElseIf $match[$DB] And $dbBase Then
			SetLog($GetResourcesTXT, $COLOR_GREEN, "Lucida Console", 7.5)
			SetLog("      " & "Dead Base Found!", $COLOR_GREEN, "Lucida Console", 7.5)
			$logwrited = True
			$iMatchMode = $DB
			If $debugDeadBaseImage = 1 Then
				_CaptureRegion()
				_GDIPlus_ImageSaveToFile($hBitmap, @ScriptDir & "\Zombies\" & $Date & " at " & $Time & ".png")
				_WinAPI_DeleteObject($hBitmap)
			EndIf
			ExitLoop
		ElseIf $match[$LB] And Not $dbBase  Then
			SetLog($GetResourcesTXT, $COLOR_GREEN, "Lucida Console", 7.5)
			SetLog("      " & "Live Base Found!", $COLOR_GREEN, "Lucida Console", 7.5)
			$logwrited = True
			$iMatchMode = $LB
			ExitLoop
		ElseIf $match[$LB] Or $match[$DB]  Then
			If $OptBullyMode = 1 And ($SearchCount >= $ATBullyMode) Then
				If $SearchTHLResult = 1 Then
					SetLog($GetResourcesTXT, $COLOR_GREEN, "Lucida Console", 7.5)
					SetLog("      " & "Not a match, but TH Bully Level Found! ", $COLOR_GREEN, "Lucida Console", 7.5)
					$logwrited = True
					$iMatchMode = $iTHBullyAttackMode
					ExitLoop
				EndIf
			 EndIf
		EndIf

		;If _Sleep($iDelayRespond) Then Return
		If SearchTownHallLoc() And $match[$TS] Then ; attack this base anyway because outside TH found to snipe
			If CompareResources($TS) Then
				SetLog($GetResourcesTXT, $COLOR_GREEN, "Lucida Console", 7.5)
				SetLog("      " & "TH Outside Found! ", $COLOR_GREEN, "Lucida Console", 7.5)
				$logwrited = True
				$iMatchMode = $TS
				ExitLoop
			Else
				$noMatchTxt &= ", Not a " & $sModeText[$TS] & ", fails resource min"
			EndIf
		EndIf

		;If _Sleep($iDelayRespond) Then Return
		If $match[$DB] And Not $dbBase Then
			$noMatchTxt &= ", Not a " & $sModeText[$DB]
			If $debugDeadBaseImage = 1 Then
				_CaptureRegion()
				_GDIPlus_ImageSaveToFile($hBitmap, @ScriptDir & "\SkippedZombies\" & $Date & " at " & $Time & ".png")
				_WinAPI_DeleteObject($hBitmap)
			EndIf
		ElseIf $match[$LB] And $dbBase Then
			$noMatchTxt &= ", Not a " & $sModeText[$LB]
		EndIf

		If $noMatchTxt <> "" Then
			;SetLog(_PadStringCenter(" " & StringMid($noMatchTxt, 3) & " ", 50, "~"), $COLOR_PURPLE)
			SetLog($GetResourcesTXT, $COLOR_BLACK, "Lucida Console", 7.5)
			SetLog("      " & StringMid($noMatchTxt, 3), $COLOR_BLACK, "Lucida Console", 7.5)
			$logwrited = True
		EndIf

		If $iChkAttackNow = 1 And $iAttackNowDelay > 0 Then
			If _Sleep(1000 * $iAttackNowDelay) Then Return ; add human reaction time on AttackNow button function
		EndIf

		If Not ($logwrited) Then
			SetLog($GetResourcesTXT, $COLOR_BLACK, "Lucida Console", 7.5)
		EndIf


		If $bBtnAttackNowPressed = True Then ExitLoop

		; th snipe stop condition
		;If SWHTSearchLimit($iSkipped + 1) Then Return True
		; Return Home on Search limit
		If SearchLimit($iSkipped + 1) Then Return True

		If checkAndroidTimeLag() = True Then
		   $Restart = True
		   $Is_ClientSyncError = True
		   Return
	    EndIF


		; ----------------- PRESS BUTTON NEXT  -------------------------------------------------
		Local $i = 0
		While $i < 100
			If _Sleep($iDelayVillageSearch2) Then Return
			$i += 1
			If ( _ColorCheck(_GetPixelColor($NextBtn[0], $NextBtn[1], True), Hex($NextBtn[2], 6), $NextBtn[3])) And IsAttackPage() Then
				If $iUseRandomClick = 0 then
					ClickP($NextBtn, 1, 0, "#0155") ;Click Next
				Else
					ClickR($NextBtnRND, $NextBtn[0], $NextBtn[1], 1, 0)
				EndIF
				ExitLoop
			Else
				If $debugsetlog = 1 Then SetLog("Wait to see Next Button... " & $i, $COLOR_PURPLE)
			EndIf
			If $i >= 99 Or isProblemAffect(True) Then ; if we can't find the next button or there is an error, then restart
				$Is_ClientSyncError = True
				checkMainScreen()
				If $Restart Then
					$iNbrOfOoS += 1
					UpdateStats()
					SetLog("Couldn't locate Next button", $COLOR_RED)
					PushMsg("OoSResources")
				Else
					SetLog("Have strange problem Couldn't locate Next button, Restarting CoC and Bot...", $COLOR_RED)
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
			Setlog(" Not enough gold to keep searching.....", $COLOR_RED)
			Click(585, 252, 1, 0, "#0156") ; Click close gem window "X"
			If _Sleep($iDelayVillageSearch3) Then Return
			$OutOfGold = 1 ; Set flag for out of gold to search for attack
			ReturnHome(False, False)
			Return
		EndIf

		$iSkipped = $iSkipped + 1
		$iSkippedVillageCount += 1
		If $iTownHallLevel <> "" Then
			$iSearchCost += $aSearchCost[$iTownHallLevel - 1]
			$iGoldTotal -= $aSearchCost[$iTownHallLevel - 1]
		EndIf
		UpdateStats()

	WEnd ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;### Main Search Loop End ###;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	;--- show buttons attacknow ----
	If $bBtnAttackNowPressed = True Then
		Setlog(_PadStringCenter(" Attack Now Pressed! ", 50, "~"), $COLOR_GREEN)
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

	SetLog(_PadStringCenter(" Search Complete ", 50, "="), $COLOR_BLUE)
	PushMsg("MatchFound")


;~ 	; --- TH Detection Check Once Conditions ---
;~ 	; if TownHall no previous detect and we need to TH snipe before attack DB or LB, locate TH and determine if it is placed inside or outside the village; log result in main log
;~ 	If  $iChkMeetTH[$iMatchMode] = 0 And $iChkMeetTHO[$iMatchMode] = 0 And  ($iMatchMode = $DB and $THSnipeBeforeDBEnable = 1 ) or ($iMatchMode = $LB and $THSnipeBeforeDBEnable = 1 ) Then
;~ 		$searchTH = checkTownHallADV2()

;~ 		If $searchTH = "-" Then ; retry with autoit search after $iDelayVillageSearch5 seconds
;~ 			If _Sleep($iDelayVillageSearch5) Then Return
;~ 			If $debugsetlog = 1 Then SetLog("2nd attempt to detect the TownHall!", $COLOR_RED)
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
			If $debugsetlog = 1 Then setlog("wait surrender button " & $Wcount, $COLOR_PURPLE)
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


Func WriteLogVillageSearch ($x)
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
		SetLog(_PadStringCenter(" Searching For " & $sModeText[$x] & " ", 54, "="), $COLOR_BLUE)
		Setlog("Enable " & $sModeText[$x] & " search IF ", $COLOR_BLUE)
		If $iEnableSearchSearches[$x] = 1 Then Setlog("- Numbers of searches range " & $iEnableAfterCount[$x] & " - " & $iEnableBeforeCount[$x], $COLOR_BLUE)
		If $iEnableSearchTropies[$x] = 1 Then Setlog("- Search tropies range " & $iEnableAfterTropies[$x] & " - " & $iEnableBeforeTropies[$x], $COLOR_BLUE)
		If $iEnableSearchCamps[$x] = 1 Then Setlog("- Army Camps % >  " & $iEnableAfterArmyCamps[$x], $COLOR_BLUE)
		Setlog("Match " & $sModeText[$x] & "  village IF ", $COLOR_BLUE)
		If $MeetGxEtext <> "" Then Setlog($MeetGxEtext, $COLOR_BLUE)
		If $MeetGorEtext <> "" Then Setlog($MeetGorEtext, $COLOR_BLUE)
		If $MeetGplusEtext <> "" Then Setlog($MeetGplusEtext, $COLOR_BLUE)
		If $MeetDEtext <> "" Then Setlog($MeetDEtext, $COLOR_BLUE)
		If $MeetTrophytext <> "" Then Setlog($MeetTrophytext, $COLOR_BLUE)
		If $MeetTHtext <> "" Then Setlog($MeetTHtext, $COLOR_BLUE)
		If $MeetTHOtext <> "" Then Setlog($MeetTHOtext, $COLOR_BLUE)
		If $MeetWeakBasetext <> "" Then Setlog($MeetWeakBasetext, $COLOR_BLUE)
		If $iChkMeetOne[$x] = 1 Then SetLog("Meet One and Attack!")
		SetLog(_PadStringCenter(" RESOURCE CONDITIONS ", 50, "~"), $COLOR_BLUE)
		If $iChkMeetTH[$x] = 1 Then $iAimTHtext[$x] = " [TH]:" & StringFormat("%2s", $iMaxTH[$x]) ;$icmbTH
		If $iChkMeetTHO[$x] = 1 Then $iAimTHtext[$x] &= ", Out"
	EndIf
	If Not ($Is_SearchLimit)  Then
		If $iCmbMeetGE[$x] = 2 Then
			SetLog("Aim:           [G+E]:" & StringFormat("%7s", $iAimGoldPlusElixir[$x]) & " [D]:" & StringFormat("%5s", $iAimDark[$x]) & " [T]:" & StringFormat("%2s", $iAimTrophy[$x]) & $iAimTHtext[$x] & " for: " & $sModeText[$x], $COLOR_GREEN, "Lucida Console", 7.5)
		Else
			SetLog("Aim: [G]:" & StringFormat("%7s", $iAimGold[$x]) & " [E]:" & StringFormat("%7s", $iAimElixir[$x]) & " [D]:" & StringFormat("%5s", $iAimDark[$x]) & " [T]:" & StringFormat("%2s", $iAimTrophy[$x]) & $iAimTHtext[$x] & " for: " & $sModeText[$x], $COLOR_GREEN, "Lucida Console", 7.5)
		EndIf
	EndIf

EndFunc
