; #FUNCTION# ====================================================================================================================
; Name ..........: MBR Bot
; Description ...: Uses the ColorCheck until the screen is clear from Clouds to Get Resources values.
; Author ........: HungLe (2015)
; Modified ......: ProMac (2015), Hervidero (2015), MonkeyHunter (08-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Global $GetResourcesTXT

Func GetResources($bLog = True, $pMatchMode = -1) ;Reads resources
    Static $iStuck = 0

	If _Sleep($iDelayRespond) Then Return
	$searchGold = ""
	$searchElixir = ""
	$searchDark = ""
	$searchTrophy = ""

	SuspendAndroid()

	Local $iCount = 0
	While (getGoldVillageSearch(48, 69) = "") Or (getElixirVillageSearch(48, 69 + 29) = "")
		$iCount += 1
		If _Sleep($iDelayGetResources3) Then Return
		If $iCount >= 50 Or isProblemAffect(True) Then ExitLoop ; Wait 50*150ms=7.5 seconds max to read resources
	WEnd

	If _Sleep($iDelayRespond) Then Return
	$searchGold = getGoldVillageSearch(48, 69)
	If _Sleep($iDelayRespond) Then Return
	$searchElixir = getElixirVillageSearch(48, 69 + 29)
	If _Sleep($iDelayRespond) Then Return
	If $g_iDebugSetlog Then SetLog("Village dark elixir available chk color: " & _GetPixelColor(31, 144, True) & " : 0x0F0617 expected", $COLOR_DEBUG) ; 0F0617(15,6,23) / 06000E(6,0,14) / 000003(0,0,3) / 000000(0,0,0)
	If _ColorCheck(_GetPixelColor(31, 144, True), Hex(0x282020, 6), 10) Or _ColorCheck(_GetPixelColor(31, 144, True), Hex(0x0F0617, 6), 5) Then ; check if the village have a Dark Elixir Storage
		$searchDark = getDarkElixirVillageSearch(48, 126)
		$searchTrophy = getTrophyVillageSearch(45, 168)
	Else
		$searchDark = "N/A"
		$searchTrophy = getTrophyVillageSearch(48, 69 + 69)
	EndIf

	If $searchGold = $searchGold2 And $searchElixir = $searchElixir2 Then $iStuck += 1
	If $searchGold <> $searchGold2 Or $searchElixir <> $searchElixir2 Then $iStuck = 0

	$searchGold2 = $searchGold
	$searchElixir2 = $searchElixir

	If $iStuck >= 5 Or isProblemAffect(True) Then
		$iStuck = 0
		resetAttackSearch(True)
		Return
	EndIf

	$SearchCount += 1 ; Counter for number of searches

	ResumeAndroid()

EndFunc   ;==>GetResources

Func resetAttackSearch($bStuck = False)
	; function to check main screen and restart search and display why as needed
	$Is_ClientSyncError = True
	checkMainScreen()
	If $g_bRestart Then
		$iNbrOfOoS += 1
		UpdateStats()
		If $bStuck Then
			SetLog("Connection Lost While Searching", $COLOR_ERROR)
		Else
			SetLog("Disconnected At Search Clouds", $COLOR_ERROR)
		EndIf
		PushMsg("OoSResources")
	Else
		If $bStuck Then
			SetLog("Attack Is Disabled Or Slow connection issues, Restarting CoC and Bot...", $COLOR_ERROR)
		Else
			SetLog("Stuck At Search Clouds, Restarting CoC and Bot...", $COLOR_ERROR)
		EndIf
		$Is_ClientSyncError = False ; disable fast OOS restart if not simple error and restarting CoC
		CloseCoC(True)
	EndIf
	Return
EndFunc   ;==>resetAttackSearch