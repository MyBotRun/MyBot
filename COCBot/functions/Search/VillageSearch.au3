
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

	_WinAPI_EmptyWorkingSet(WinGetProcess($HWnD)) ; Reduce Working Set of Android Process
	_WinAPI_EmptyWorkingSet(@AutoItPID) ; Reduce Working Set of Bot

	If _Sleep($iDelayVillageSearch1) Then Return
	$Result = getAttackDisable(346, 182) ; Grab Ocr for TakeABreak check
	checkAttackDisable($iTaBChkAttack, $Result) ;last check to see If TakeABreak msg on screen for fast PC from PrepareSearch click
	If $Restart = True Then Return ; exit func
	For $x = 0 To $iModeCount - 1
		If $iHeroWait[$x] > $HERO_NOHERO And (BitAND($iHeroAttack[$x], $iHeroWait[$x], $iHeroAvailable) = $iHeroWait[$x]) = False Then
			SetLog(_PadStringCenter(" Skip " & $sModeText[$x] & " - Hero Not Ready " & BitAND($iHeroAttack[$x], $iHeroWait[$x], $iHeroAvailable) & "|" & $iHeroAvailable, 54, "="), $COLOR_RED)
			ContinueLoop ; check if herowait selected and hero available for each search mode
		EndIf
		; Fixed TS info displaying when snipe was not selected by LunaEclipse
		If (($x = $LB Or $x = $DB) And ($x = $iCmbSearchMode Or $iCmbSearchMode = 2)) Or ($x = $TS And ($OptTrophyMode = 1 Or $iChkSnipeWhileTrain = 1)) Then
			If Not ($Is_SearchLimit) Then SetLog(_PadStringCenter(" Searching For " & $sModeText[$x] & " ", 54, "="), $COLOR_BLUE)

			Local $MeetGxEtext = "", $MeetGorEtext = "", $MeetGplusEtext = "", $MeetDEtext = "", $MeetTrophytext = "", $MeetTHtext = "", $MeetTHOtext = "", $MeetWeakBasetext = "", $EnabledAftertext = ""

			If Not ($Is_SearchLimit) Then SetLog(_PadStringCenter(" SEARCH CONDITIONS ", 50, "~"), $COLOR_BLUE)

			If $iCmbMeetGE[$x] = 0 Then $MeetGxEtext = "Meet: Gold and Elixir"
			If $iCmbMeetGE[$x] = 1 Then $MeetGorEtext = "Meet: Gold or Elixir"
			If $iCmbMeetGE[$x] = 2 Then $MeetGplusEtext = "Meet: Gold + Elixir"
			If $iChkMeetDE[$x] = 1 Then $MeetDEtext = ", Dark"
			If $iChkMeetTrophy[$x] = 1 Then $MeetTrophytext = ", Trophy"
			If $iChkMeetTH[$x] = 1 Then $MeetTHtext = ", Max TH " & $iMaxTH[$x] ;$icmbTH
			If $iChkMeetTHO[$x] = 1 Then $MeetTHOtext = ", TH Outside"
			If $iChkWeakBase[$x] = 1 Then $MeetWeakBasetext = ", Weak Base(Mortar: " & $iCmbWeakMortar[$x] & ", WizTower: " & $iCmbWeakWizTower[$x] & ")"
			If $iChkEnableAfter[$x] = 1 Then $EnabledAftertext = ", Enabled after " & $iEnableAfterCount[$x] & " searches"

			If Not ($Is_SearchLimit) Then SetLog($MeetGxEtext & $MeetGorEtext & $MeetGplusEtext & $MeetDEtext & $MeetTrophytext & $MeetTHtext & $MeetTHOtext & $MeetWeakBasetext & $EnabledAftertext)

			If $iChkMeetOne[$x] = 1 And Not ($Is_SearchLimit) Then SetLog("Meet One and Attack!")

			If Not ($Is_SearchLimit) Then SetLog(_PadStringCenter(" RESOURCE CONDITIONS ", 50, "~"), $COLOR_BLUE)
			If $iChkMeetTH[$x] = 1 Then $iAimTHtext[$x] = " [TH]:" & StringFormat("%2s", $iMaxTH[$x]) ;$icmbTH
			If $iChkMeetTHO[$x] = 1 Then $iAimTHtext[$x] &= ", Out"


			If $iCmbMeetGE[$x] = 2 Then
				If Not ($Is_SearchLimit) Then SetLog("Aim: [G+E]:" & StringFormat("%7s", $iAimGoldPlusElixir[$x]) & " [D]:" & StringFormat("%5s", $iAimDark[$x]) & " [T]:" & StringFormat("%2s", $iAimTrophy[$x]) & $iAimTHtext[$x] & " for: " & $sModeText[$x], $COLOR_GREEN, "Lucida Console", 7.5)
			Else
				If Not ($Is_SearchLimit) Then SetLog("Aim: [G]:" & StringFormat("%7s", $iAimGold[$x]) & " [E]:" & StringFormat("%7s", $iAimElixir[$x]) & " [D]:" & StringFormat("%5s", $iAimDark[$x]) & " [T]:" & StringFormat("%2s", $iAimTrophy[$x]) & $iAimTHtext[$x] & " for: " & $sModeText[$x], $COLOR_GREEN, "Lucida Console", 7.5)
			EndIf

		EndIf
	Next

	If $OptBullyMode + $OptTrophyMode + $chkATH > 0 Then
		If Not ($Is_SearchLimit) Then SetLog(_PadStringCenter(" ADVANCED SETTINGS ", 50, "~"), $COLOR_BLUE)
		Local $YourTHText = "", $chkATHText = "", $OptTrophyModeText = ""

		If $OptBullyMode = 1 Then
			For $i = 0 To 4
				If $YourTH = $i Then $YourTHText = "TH" & $THText[$i]
			Next
		EndIf

		If $OptBullyMode = 1 And Not ($Is_SearchLimit) Then SetLog("THBully Combo @" & $ATBullyMode & " SearchCount, " & $YourTHText)

		If $chkATH = 1 Then $chkATHText = " Attack TH Outside "
		If $OptTrophyMode = 1 Then $OptTrophyModeText = "THSnipe Combo, " & $THaddtiles & " Tile(s), "
		If ($OptTrophyMode = 1 Or $chkATH = 1) And Not ($Is_SearchLimit) Then SetLog($OptTrophyModeText & $chkATHText & $txtAttackTHType)
	EndIf

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


	While 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;### Main Search Loop ###;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		If $debugVillageSearchImages = 1 Then DebugImageSave("villagesearch")
		$logwrited = False
		$bBtnAttackNowPressed = False
		$hAttackCountDown = TimerInit()
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

		GetResources(False) ;Reads Resource Values
		If $Restart = True Then Return ; exit func

		If Mod(($iSkipped + 1), 100) = 0 Then
			_WinAPI_EmptyWorkingSet(WinGetProcess($HWnD)) ; reduce Android memory
			If _Sleep($iDelayRespond) Then Return
			If CheckZoomOut() = False Then Return
		EndIf

		SuspendAndroid()

		Local $noMatchTxt = ""
		Local $dbBase = False
		Local $match[$iModeCount]
		Local $isModeActive[$iModeCount]
		For $i = 0 To $iModeCount - 1
			$match[$i] = False
			$isModeActive[$i] = False
		Next

		If _Sleep($iDelayRespond) Then Return
		Switch $iCmbSearchMode
			Case 0 ; check Dead Base only
				If $iHeroWait[$DB] = 0 Or ($iHeroWait[$DB] > 0 And BitAND($iHeroAttack[$DB], $iHeroWait[$DB], $iHeroAvailable) = $iHeroWait[$DB]) Then ; check hero wait/avail
					$isModeActive[$DB] = True
					$match[$DB] = CompareResources($DB)
					;$noMatchTxt &= ", DB compare " & BitAND($iHeroAttack[$DB], $iHeroWait[$DB], $iHeroAvailable)  ; use for debug
				Else
					$noMatchTxt &= ", DB Hero Not Ready, "
				EndIf
			Case 1 ; Check Live Base only
				If $iHeroWait[$LB] = 0 Or ($iHeroWait[$LB] > 0 And BitAND($iHeroAttack[$LB], $iHeroWait[$LB], $iHeroAvailable) = $iHeroWait[$LB]) Then ; check hero wait/avail
					$isModeActive[$LB] = True
					$match[$LB] = CompareResources($LB)
					;$noMatchTxt &= ", LB compare " & BitAND($iHeroAttack[$LB], $iHeroWait[$LB], $iHeroAvailable) ; use for debug
				Else
					$noMatchTxt &= ", LB Hero Not Ready, "
				EndIf
			Case 2
				For $i = 0 To $iModeCount - 2
					If $iHeroWait[$i] = 0 Or ($iHeroWait[$i] > 0 And BitAND($iHeroAttack[$i], $iHeroWait[$i], $iHeroAvailable) = $iHeroWait[$i]) Then ; check hero wait/avail
						$isModeActive[$i] = IsSearchModeActive($i)
						If $isModeActive[$i] Then
							$match[$i] = CompareResources($i)
							;$noMatchTxt &= ", " & $sModeText[$i] & " compare " & BitAND($iHeroAttack[$i], $iHeroWait[$i], $iHeroAvailable)  ; use for debug
						EndIf
					Else
						$noMatchTxt &= ", " & $sModeText[$i] & " Hero Not Ready:" & BitAND($iHeroAttack[$i], $iHeroWait[$i], $iHeroAvailable)
					EndIf
				Next
		EndSwitch
		; Fail safe Safety Check for rare error with Hero wait and Hero not available that will disable ALL CompareResources
		Local $bSearchSafe = False
		For $i = 0 To $iModeCount - 2
			If $isModeActive[$i] Then $bSearchSafe = True
		Next
		If $bSearchSafe = False And ($OptBullyMode = 0 And $OptTrophyMode = 0) Then ; no search modes are active.
			Setlog("ERROR - Check Hero Wait & Search Start Values!!", $COLOR_RED)
			If _Sleep($iDelayRespond) Then Return
			Setlog("Search Logic Error occured and will NEVER find base!!!", $COLOR_RED)
			If _Sleep($iDelayRespond) Then Return
			ReturnHome(False, False) ;If End battle is available
			$Restart = True ; set force runbot restart flag
			$Is_ClientSyncError = False ; reset OOS flag
			Setlog("Switching to Halt Attack, Stay Online/Collect mode ...", $COLOR_RED)
			If _Sleep($iDelayRespond) Then Return
			$ichkBotStop = 1 ; set halt attack variable
			$icmbBotCond = 18 ; set stay online/collect only mode
			Return
		EndIf

		If _Sleep($iDelayRespond) Then Return

		For $i = 0 To $iModeCount - 2
			If ($match[$i] And $iChkWeakBase[$i] = 1 And $iChkMeetOne[$i] <> 1) Or ($isModeActive[$i] And Not $match[$i] And $iChkWeakBase[$i] = 1 And $iChkMeetOne[$i] = 1) Then
				If IsWeakBase($i) Then
					$match[$i] = True
				Else
					$match[$i] = False
					$noMatchTxt &= ", Not a Weak Base for " & $sModeText[$i]
				EndIf
			EndIf
		Next

		If _Sleep($iDelayRespond) Then Return

		If $match[$DB] Or $match[$LB] Then
			$dbBase = checkDeadBase()
		EndIf

		Local $MilkingExtractorsMatch = 0
		$MilkFarmObjectivesSTR = ""
		If $match[$LB] And $iChkDeploySettings[$LB] = 6 Then ;MilkingAttack
			If $debugsetlog = 1 Then Setlog("Check Milking...", $COLOR_BLUE)
			MilkingDetectRedArea()
			$MilkingExtractorsMatch = MilkingDetectElixirExtractors()
			If $MilkingExtractorsMatch > 0 Then
				$MilkingExtractorsMatch += MilkingDetectMineExtractors() + MilkingDetectDarkExtractors()
			EndIf
			If StringLen($MilkFarmObjectivesSTR) > 0 And $debugsetlog = 1 Then
				Setlog("Match for Milking", $COLOR_BLUE)
			Else
				$noMatchTxt &= ", No match for Milking"
			EndIf
		EndIf

		ResumeAndroid()

		If _Sleep($iDelayRespond) Then Return

		If $match[$DB] And $dbBase Then
			SetLog($GetResourcesTXT, $COLOR_GREEN, "Lucida Console", 7.5)
			SetLog("      " & "Dead Base Found! ", $COLOR_GREEN, "Lucida Console", 7.5)
			$logwrited = True
			$iMatchMode = $DB
			If $debugDeadBaseImage = 1 Then
				_CaptureRegion()
				_GDIPlus_ImageSaveToFile($hBitmap, @ScriptDir & "\Zombies\" & $Date & " at " & $Time & ".png")
				_WinAPI_DeleteObject($hBitmap)
			EndIf
			ExitLoop
		ElseIf $match[$LB] And $iChkDeploySettings[$LB] = 6 And StringLen($MilkFarmObjectivesSTR) > 0 Then
			SetLog($GetResourcesTXT, $COLOR_GREEN, "Lucida Console", 7.5)
			SetLog("      " & "Milking on: " & $MilkingExtractorsMatch &" resources!", $COLOR_GREEN, "Lucida Console", 7.5)
			$logwrited = True
			$iMatchMode = $LB
			ExitLoop
		ElseIf $match[$LB] And Not $dbBase And $iChkDeploySettings[$LB] <> 6 Then
			SetLog($GetResourcesTXT, $COLOR_GREEN, "Lucida Console", 7.5)
			SetLog("      " & "Live Base Found!", $COLOR_GREEN, "Lucida Console", 7.5)
			$logwrited = True
			$iMatchMode = $LB
			ExitLoop
		ElseIf $match[$LB] Or $match[$DB] And $iChkDeploySettings[$LB] <> 6 Then
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

		If _Sleep($iDelayRespond) Then Return
		If $OptTrophyMode = 1 Then ;Enables Combo Mode Settings
			If SearchTownHallLoc() And IsSearchModeActive($TS) Then ; attack this base anyway because outside TH found to snipe
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
		EndIf


		If _Sleep($iDelayRespond) Then Return
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

		If $iChkAttackNow = 1 Then
			If _Sleep(1000 * $iAttackNowDelay) Then Return ; add human reaction time on AttackNow button function
		EndIf

		If Not ($logwrited) Then
			SetLog($GetResourcesTXT, $COLOR_BLACK, "Lucida Console", 7.5)
		EndIf


		If $bBtnAttackNowPressed = True Then ExitLoop

		; th snipe stop condition
		If SWHTSearchLimit($iSkipped + 1) Then Return True
		; Return Home on Search limit
		If SearchLimit($iSkipped + 1) Then Return True

		If checkAndroidTimeLag() = True Then
		   $Restart = True
		   $Is_ClientSyncError = True
		   Return
	    EndIF

		Local $i = 0
		While $i < 100
			If _Sleep($iDelayVillageSearch2) Then Return
			$i += 1
			If ( _ColorCheck(_GetPixelColor($NextBtn[0], $NextBtn[1], True), Hex($NextBtn[2], 6), $NextBtn[3])) And IsAttackPage() Then
				ClickP($NextBtn, 1, 0, "#0155") ;Click Next
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

	; TH Detection Check Once Conditions
	If $OptBullyMode = 0 And $OptTrophyMode = 0 And $iChkMeetTH[$iMatchMode] = 0 And $iChkMeetTHO[$iMatchMode] = 0 And $chkATH = 1 Then
		$searchTH = checkTownHallADV2()

		If $searchTH = "-" Then ; retry with autoit search after $iDelayVillageSearch5 seconds
			If _Sleep($iDelayVillageSearch5) Then Return
			If $debugsetlog = 1 Then SetLog("2nd attempt to detect the TownHall!", $COLOR_RED)
			$searchTH = THSearch()
		EndIf

		If SearchTownHallLoc() = False And $searchTH <> "-" Then
			SetLog("Checking Townhall location: TH is inside, skip Attack TH")
		ElseIf $searchTH <> "-" Then
			SetLog("Checking Townhall location: TH is outside, Attacking Townhall!")
		Else
			SetLog("Checking Townhall location: Could not locate TH, skipping attack TH...")
		EndIf
	EndIf

	$Is_ClientSyncError = False

EndFunc   ;==>VillageSearch

Func IsSearchModeActive($pMode)
	If $iChkEnableAfter[$pMode] = 0 Then Return True
	If $SearchCount = $iEnableAfterCount[$pMode] Then SetLog(_PadStringCenter(" " & $sModeText[$pMode] & " search conditions are activated! ", 50, "~"), $COLOR_BLUE)
	If $SearchCount >= $iEnableAfterCount[$pMode] Then Return True
	Return False
EndFunc   ;==>IsSearchModeActive

Func IsWeakBase($pMode)
	_CaptureRegion2()
	Local $resultHere = DllCall($hFuncLib, "str", "CheckConditionForWeakBase", "ptr", $hHBitmap2, "int", ($iCmbWeakMortar[$pMode] + 2), "int", ($iCmbWeakWizTower[$pMode] + 2), "int", 10)
	If @error Then ; detect if DLL error and return weakbase not found
		SetLog("Weakbase search DLL error", $COLOR_RED)
		Return False
	EndIf
	If $debugsetlog = 1 Then Setlog("Weakbase result= " & $resultHere[0], $COLOR_PURPLE) ;debug
	If $resultHere[0] = "Y" Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>IsWeakBase

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
		$Restart = True ; set force runbot restart flag
		$Is_ClientSyncError = True ; set OOS flag for fast restart
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>SearchLimit
