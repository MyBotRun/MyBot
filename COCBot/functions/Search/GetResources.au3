; #FUNCTION# ====================================================================================================================
; Name ..........: MBR Bot
; Description ...: Uses the ColorCheck until the screen is clear from Clouds to Get Resources values.
; Author ........: HungLe (2015)
; Modified ......: ProMac (2015), Hervidero (2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Global $GetResourcesTXT

Func GetResources($bLog = True, $pMatchMode = -1) ;Reads resources

	If _Sleep($iDelayGetResources1) Then Return
	$searchGold = ""
	$searchElixir = ""
	$searchDark = ""
	$searchTrophy = ""
	Local $iResult = 0
	Local $i = 0

	While _CheckPixel($aNoCloudsAttack, $bCapturePixel) = False ; wait for clouds to be gone
		If _Sleep($iDelayGetResources1) Then Return
		$i += 1
		If $i >= 180 Or isProblemAffect(True) Then ; Wait 45 sec max then restart bot and CoC
			$Is_ClientSyncError = True
			checkMainScreen()
			If $Restart Then
				$iNbrOfOoS += 1
				UpdateStats()
				SetLog("Disconnected At Search Clouds", $COLOR_RED)
				PushMsg("OoSResources")
			Else
				SetLog("Stuck At Search Clouds, Restarting CoC and Bot...", $COLOR_RED)
				$Is_ClientSyncError = False ; disable fast OOS restart if not simple error and restarting CoC
				CloseCoC(True)
			EndIf
			Return
		EndIf
		If $debugSetlog = 1 Then SetLog("Loop to clean screen without Clouds , nº :" & $i, $COLOR_PURPLE)
	WEnd

    SuspendAndroid()

	$i = 0
	While (getGoldVillageSearch(48, 69) = "") Or (getElixirVillageSearch(48, 69 + 29) = "") ; Wait 7.5 seconds max to read resources
		$i += 1
		If _Sleep($iDelayGetResources3) Then Return
		If $i >= 50 Or isProblemAffect(True) Then ExitLoop
	WEnd

	If _Sleep($iDelayRespond) Then Return
	$searchGold = getGoldVillageSearch(48, 69)
	If _Sleep($iDelayRespond) Then Return
	$searchElixir = getElixirVillageSearch(48, 69 + 29)
	If _Sleep($iDelayRespond) Then Return
	If $debugSetlog then SetLog("_GetPixelColor: 31/144: " & _GetPixelColor(31, 144, True))  ; 0F0617(15,6,23) / 06000E(6,0,14) / 000003(0,0,3) / 000000(0,0,0) 
	If _ColorCheck(_GetPixelColor(31, 144, True), Hex(0x0a050a, 6), 10) or _ColorCheck(_GetPixelColor(31, 144, True), Hex(0x0F0617, 6), 5) Then ; check if the village have a Dark Elixir Storage
		$searchDark = getDarkElixirVillageSearch(45, 125)
		$searchTrophy = getTrophyVillageSearch(45, 167)
	Else
		$searchDark = "N/A"
		$searchTrophy = getTrophyVillageSearch(45, 69 + 69)
	EndIf

	If $searchGold = $searchGold2 And $searchElixir = $searchElixir2 Then $iStuck += 1
	If $searchGold <> $searchGold2 Or $searchElixir <> $searchElixir2 Then $iStuck = 0
	$searchGold2 = $searchGold
	$searchElixir2 = $searchElixir

	If $iStuck >= 5 Or isProblemAffect(True) Then
		$iStuck = 0
		$Is_ClientSyncError = True
		checkMainScreen()
		If $Restart Then
			$iNbrOfOoS += 1
			UpdateStats()
			SetLog("Connection Lost While Searching", $COLOR_RED)
			PushMsg("OoSResources")
		Else
			SetLog("Attack Is Disabled Or Slow connection issues, Restarting CoC and Bot...", $COLOR_RED)
			$Is_ClientSyncError = False ; disable fast OOS restart if not simple error and restarting CoC
			CloseCoC(True)
		EndIf
		Return
	EndIf

	Local $THString = ""
	$searchTH = "-"
	$THx=0
	$THy=0

	If $pMatchMode <> $DT Then ; skip TH search if $pMatchmode = $DT (DropThrophy)
		If $OptTrophyMode = 1 Or ($OptBullyMode = 1 And $SearchCount >= $ATBullyMode) Or ($iCmbSearchMode <> $LB And ($iChkMeetTH[$DB] = 1 Or $iChkMeetTHO[$DB] = 1)) Or ($iCmbSearchMode <> $DB And ($iChkMeetTH[$LB] = 1 Or $iChkMeetTHO[$LB] = 1)) Then
			;If $iChkMeetTH[$DB] = 1 or $iChkMeetTH[$LB]  = 1 or($OptBullyMode = 1 And $SearchCount >= $ATBullyMode) Or  ($iCmbSearchMode <> $LB And $iChkMeetTHO[$DB] = 1) Or ($iCmbSearchMode <> $DB And $iChkMeetTHO[$LB] = 1)  Then ;removed, search townhall it is fast, make no sense reduce images to check
			; CODE TO DETECT TOWNHALL ONLY WITH AUTOIT IMAGESEARCH

			$searchTH = checkTownHallADV2()

			;2nd attempt
			If $searchTH = "-" Then ; retry with autoit search after $iDelayVillageSearch5 seconds
				If _Sleep($iDelayGetResources5) Then Return
				If $debugsetlog=1 Then SetLog("2nd attempt to detect the TownHall!", $COLOR_RED)
				$searchTH = THSearch()
			EndIf

			If SearchTownHallLoc() = False And $searchTH <> "-" Then
				$THLoc = "In"
			ElseIf $searchTH <> "-" Then
				$THLoc = "Out"
			Else
				$THLoc = $searchTH
				$THx = 0
				$THy = 0
			EndIf
			;EndIf
			$THString = " [TH]:" & StringFormat("%2s", $searchTH) & ", " & $THLoc
		EndIf
	EndIf

	$SearchCount += 1 ; Counter for number of searches
	If $bLog = True Then SetLog(StringFormat("%3s", $SearchCount) & "> [G]:" & StringFormat("%7s", $searchGold) & " [E]:" & StringFormat("%7s", $searchElixir) & " [D]:" & StringFormat("%5s", $searchDark) & " [T]:" & StringFormat("%2s", $searchTrophy) & $THString, $COLOR_BLACK, "Lucida Console", 7.5)
	$GetResourcesTXT = StringFormat("%3s", $SearchCount) & "> [G]:" & StringFormat("%7s", $searchGold) & " [E]:" & StringFormat("%7s", $searchElixir) & " [D]:" & StringFormat("%5s", $searchDark) & " [T]:" & StringFormat("%2s", $searchTrophy) & $THString

    ResumeAndroid()

EndFunc   ;==>GetResources
