; #FUNCTION# ====================================================================================================================
; Name ..........: Clan Games
; Description ...: This file contains the Clan Games algorithm
; Syntax ........: ---
; Parameters ....: ---
; Return values .: ---
; Author ........: ViperZ And Uncle Xbenk 01-2018
; Modified ......: ProMac 02/2018 [v2 and v3] , ProMac 08/2018 v4 , GrumpyHog 08/2020, Moebius14 01/2024
; Remarks .......: This file is part of MyBotRun. Copyright 2015-2024
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......: ---
; Link ..........: https://www.mybot.run
; Example .......: ---
;================================================================================================================================

Func _ClanGames($test = False, $HaltMode = False)
	ClearTempCGFiles()

	$IsCGEventRunning = 0 ;just to be sure, reset to false @PriapusCranium
	$g_bIsBBevent = 0 ;just to be sure, reset to false

	If Not $g_bChkClanGamesEnabled Then Return

	Local $currentDate = Number(@MDAY)

	;Prevent checking clangames before date 20 (clangames should start on 22 and end on 28 or 29) depends on how many tiers/maxpoint
	If $currentDate < 21 Then
		SetDebugLog("Current date : " & $currentDate & " --> Skip Clan Games", $COLOR_INFO)
		Return
	EndIf

	If $currentDate = 21 Or $currentDate = 22 Then
		If Not UTCTimeCG() Then
			SetLog("Clan Games have not started yet")
			Return
		EndIf
	EndIf

	Local $sFound = False
	If $currentDate >= 28 Then
		For $i = 1 To 10
			If QuickMIS("BC1", $g_sImgCaravan, 180, 55, 300, 120 + $g_iMidOffsetY) Then
				$sFound = True
				ExitLoop
			EndIf
			If _Sleep(200) Then Return
		Next
		If Not $sFound Then
			SetDebugLog("Exit GD when no $sFound.", $COLOR_INFO)
			Return
		EndIf
	EndIf

	; Check if games has been completed
	If $g_bClanGamesCompleted Then
		$sFound = False
		SetLog("Clan Games has already been completed")
		For $i = 1 To 10
			If QuickMIS("BC1", $g_sImgCaravan, 180, 55, 300, 120 + $g_iMidOffsetY) Then
				$sFound = True
				ExitLoop
			EndIf
			If _Sleep(200) Then Return
		Next
		If Not $sFound Or Not $g_bChkClanGamesCollectRewards Then Return
	EndIf

	If IsCGCoolDownTime() Then Return

	; A user Log and a Click away just in case
	ClickAway()
	SetLog("Entering Clan Games", $COLOR_INFO)
	If _Sleep(1000) Then Return

	; Local and Static Variables
	Local $TabChallengesPosition[2] = [810, 170 + $g_iMidOffsetY]
	Local $sTimeRemain = "", $sEventName = "", $getCapture = True
	Local Static $YourAccScore[8][2] = [[-1, True], [-1, True], [-1, True], [-1, True], [-1, True], [-1, True], [-1, True], [-1, True]]

	; Initial Timer
	Local $hTimer = TimerInit()

	; Enter on Clan Games window
	If IsClanGamesWindow() Then
		; Let's selected only the necessary images
		Local $sImagePath = @ScriptDir & "\imgxml\Resources\ClanGamesImages\Challenges"
		Local $sTempChallengePath = @TempDir & "\" & $g_sProfileCurrentName & "\Challenges\"

		;Remove All previous file (in case setting changed)
		ClearTempCGFiles()

		If $g_bChkClanGamesLoot Then ClanGameImageCopy($sImagePath, $sTempChallengePath, "L") ;L for Loot
		If $g_bChkClanGamesBattle Then ClanGameImageCopy($sImagePath, $sTempChallengePath, "B") ;B for Battle
		If $g_bChkClanGamesDes Then ClanGameImageCopy($sImagePath, $sTempChallengePath, "D") ;D for Destruction
		If $g_bChkClanGamesAirTroop Then ClanGameImageCopy($sImagePath, $sTempChallengePath, "A") ;A for AirTroops
		If $g_bChkClanGamesGroundTroop Then ClanGameImageCopy($sImagePath, $sTempChallengePath, "G") ;G for GroundTroops

		If $g_bChkClanGamesMiscellaneous Then ClanGameImageCopy($sImagePath, $sTempChallengePath, "M") ;M for Misc
		If $g_bChkClanGamesSpell Then ClanGameImageCopy($sImagePath, $sTempChallengePath, "S") ;S for GroundTroops
		If $g_bChkClanGamesBBBattle Then ClanGameImageCopy($sImagePath, $sTempChallengePath, "BBB") ;BBB for BB Battle
		If $g_bChkClanGamesBBDes Then ClanGameImageCopy($sImagePath, $sTempChallengePath, "BBD") ;BBD for BB Destruction
		If $g_bChkClanGamesBBTroops Then ClanGameImageCopy($sImagePath, $sTempChallengePath, "BBT") ;BBT for BB Troops
		;now we need to copy selected challenge before checking current running event is not wrong event selected

		; Let's get some information , like Remain Timer, Score and limit
		If Not _ColorCheck(_GetPixelColor(295, 280 + $g_iMidOffsetY, True), Hex(0x53DE50, 6), 10) Then ;no greenbar = there is active event or completed event
			If _Sleep(3000) Then Return ; just wait few second, as completed event will need sometime to animate on score
		EndIf
		Local $aiScoreLimit = GetTimesAndScores()
		If $aiScoreLimit = -1 Or UBound($aiScoreLimit) <> 2 Then
			$g_bClanGamesCompleted = 1
			ClearTempCGFiles()
			Return
		Else
			SetLog("Your Score is: " & $aiScoreLimit[0], $COLOR_INFO)
			If _Sleep(500) Then Return
			If $g_bChkClanGamesDebug Then SaveDebugImage("ClanGames_Window", True)
			Local $sTimeCG
			If $aiScoreLimit[0] = $aiScoreLimit[1] Then
				SetLog("Your score limit is reached ! Congrats", $COLOR_SUCCESS1)
				$g_bClanGamesCompleted = 1
				ClearTempCGFiles()
				CloseWindow()
				UpdateStats()
				Return
			ElseIf $aiScoreLimit[0] + 300 >= $aiScoreLimit[1] Then
				SetLog("You have almost reached max point")
				$sTimeCG = ConvertOCRTime("ClanGames()", $g_sClanGamesTimeRemaining, False)
				SetDebuglog("Clan Games Minute Remain: " & $sTimeCG)
				If $g_bChkClanGamesStopBeforeReachAndPurge And $sTimeCG > 1440 Then ; purge, but not purge on last day of clangames
					If CooldownTime() Or IsEventRunning() Then Return
					SetLog("Stop before completing your limit and only Purge")
					SetLog("Lets only purge 1 random challenge", $COLOR_WARNING)
					PurgeEvent(False, True)
					ClearTempCGFiles()
					Return
				EndIf
			EndIf
			If $YourAccScore[$g_iCurAccount][0] = -1 Then $YourAccScore[$g_iCurAccount][0] = $aiScoreLimit[0]
		EndIf
	Else
		ClickAway()
		Return
	EndIf

	;check cooldown purge
	If CooldownTime() Then
		ClearTempCGFiles()
		Return
	EndIf
	If Not $g_bRunState Then Return ;trap pause or stop bot
	If IsEventRunning() Then
		ClearTempCGFiles()
		Return
	ElseIf $HaltMode Then
		CloseWindow()
		ClearTempCGFiles()
		Return
	EndIf
	If Not $g_bRunState Then Return ;trap pause or stop bot

	If $g_bCGDebugEvents Then
		SaveDebugImage("CG_All_Challenges", True, True, "P1")
		If _Sleep(1000) Then Return
	EndIf

	UpdateStats()

	Local $EventLoopOut = True
	Local $IsLooped = 0
	Local $IsSomethingWrong = False
	Local $iRow = 2

	While $EventLoopOut

		$EventLoopOut = False
		If $IsLooped > 0 Then $hTimer = TimerInit()

		Local $HowManyImages = _FileListToArray($sTempChallengePath, "*", $FLTA_FILES)
		If IsArray($HowManyImages) Then
			Local $HowManyEvents = 0
			For $i = 0 To UBound($g_abCGMainLootItem) - 1
				If Not $g_bChkClanGamesLoot Then ExitLoop
				If $g_abCGMainLootItem[$i] > 0 Then $HowManyEvents += 1
			Next
			For $i = 0 To UBound($g_abCGMainBattleItem) - 1
				If Not $g_bChkClanGamesBattle Then ExitLoop
				If $g_abCGMainBattleItem[$i] > 0 Then $HowManyEvents += 1
			Next
			For $i = 0 To UBound($g_abCGMainDestructionItem) - 1
				If Not $g_bChkClanGamesDes Then ExitLoop
				If $g_abCGMainDestructionItem[$i] > 0 Then $HowManyEvents += 1
			Next
			For $i = 0 To UBound($g_abCGMainAirItem) - 1
				If Not $g_bChkClanGamesAirTroop Then ExitLoop
				If $g_abCGMainAirItem[$i] > 0 Then $HowManyEvents += 1
			Next
			For $i = 0 To UBound($g_abCGMainGroundItem) - 1
				If Not $g_bChkClanGamesGroundTroop Then ExitLoop
				If $g_abCGMainGroundItem[$i] > 0 Then $HowManyEvents += 1
			Next
			For $i = 0 To UBound($g_abCGMainMiscItem) - 1
				If Not $g_bChkClanGamesMiscellaneous Then ExitLoop
				If $g_abCGMainMiscItem[$i] > 0 Then $HowManyEvents += 1
			Next
			For $i = 0 To UBound($g_abCGMainSpellItem) - 1
				If Not $g_bChkClanGamesSpell Then ExitLoop
				If $g_abCGMainSpellItem[$i] > 0 Then $HowManyEvents += 1
			Next
			For $i = 0 To UBound($g_abCGBBBattleItem) - 1
				If Not $g_bChkClanGamesBBBattle Then ExitLoop
				If $g_abCGBBBattleItem[$i] > 0 Then $HowManyEvents += 1
			Next
			For $i = 0 To UBound($g_abCGBBDestructionItem) - 1
				If Not $g_bChkClanGamesBBDes Then ExitLoop
				If $g_abCGBBDestructionItem[$i] > 0 Then $HowManyEvents += 1
			Next
			For $i = 0 To UBound($g_abCGBBTroopsItem) - 1
				If Not $g_bChkClanGamesBBTroops Then ExitLoop
				If $g_abCGBBTroopsItem[$i] > 0 Then $HowManyEvents += 1
			Next
			If $HowManyEvents = 1 Then
				Setlog($HowManyEvents & " Challenge to Search")
			Else
				Setlog($HowManyEvents & " Challenges to Search")
			EndIf
			If $HowManyImages[0] = 1 Then
				SetDebuglog($HowManyImages[0] & " Image to detect")
			Else
				SetDebuglog($HowManyImages[0] & " Images to detect")
			EndIf
		Else
			Setlog("ClanGames-Error on $HowManyImages: " & @error)
			Return
		EndIf

		Local $aAllDetectionsOnScreen = FindEvent()

		Local $aSelectChallenges[0][6]

		If UBound($aAllDetectionsOnScreen) > 0 Then
			For $i = 0 To UBound($aAllDetectionsOnScreen) - 1

				Switch $aAllDetectionsOnScreen[$i][0]
					Case "L"
						If Not $g_bChkClanGamesLoot Then ContinueLoop
						Local $LootChallenges = ClanGamesChallenges("$LootChallenges")
						For $j = 0 To UBound($LootChallenges) - 1
							; Match the names
							If $aAllDetectionsOnScreen[$i][1] = $LootChallenges[$j][0] Then
								; Verify your TH level and Challenge kind
								If $g_iTownHallLevel < $LootChallenges[$j][2] Then ExitLoop
								; [0] Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] Difficulty, [4] CGMAIN/CGBB
								Local $aArray[6] = [$LootChallenges[$j][1], $aAllDetectionsOnScreen[$i][2], $aAllDetectionsOnScreen[$i][3], $LootChallenges[$j][3], $aAllDetectionsOnScreen[$i][4], $aAllDetectionsOnScreen[$i][6]]
							EndIf
						Next
					Case "A"
						If Not $g_bChkClanGamesAirTroop Then ContinueLoop
						Local $AirTroopChallenges = ClanGamesChallenges("$AirTroopChallenges")
						For $j = 0 To UBound($AirTroopChallenges) - 1
							; Match the names
							If $aAllDetectionsOnScreen[$i][1] = $AirTroopChallenges[$j][0] Then
								; [0] Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] Difficulty, [4] CGMAIN/CGBB
								Local $aArray[6] = [$AirTroopChallenges[$j][1], $aAllDetectionsOnScreen[$i][2], $aAllDetectionsOnScreen[$i][3], $AirTroopChallenges[$j][3], $aAllDetectionsOnScreen[$i][4], $aAllDetectionsOnScreen[$i][6]]
							EndIf
						Next
					Case "S" ; - grumpy
						If Not $g_bChkClanGamesSpell Then ContinueLoop
						Local $SpellChallenges = ClanGamesChallenges("$SpellChallenges") ; load all spell challenges
						For $j = 0 To UBound($SpellChallenges) - 1 ; loop through all challenges
							; Match the names
							If $aAllDetectionsOnScreen[$i][1] = $SpellChallenges[$j][0] Then
								; [0] Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] Difficulty, [4] CGMAIN/CGBB
								Local $aArray[6] = [$SpellChallenges[$j][1], $aAllDetectionsOnScreen[$i][2], $aAllDetectionsOnScreen[$i][3], $SpellChallenges[$j][3], $aAllDetectionsOnScreen[$i][4], $aAllDetectionsOnScreen[$i][6]]
							EndIf
						Next
					Case "G"
						If Not $g_bChkClanGamesGroundTroop Then ContinueLoop
						Local $GroundTroopChallenges = ClanGamesChallenges("$GroundTroopChallenges")
						For $j = 0 To UBound($GroundTroopChallenges) - 1
							; Match the names
							If $aAllDetectionsOnScreen[$i][1] = $GroundTroopChallenges[$j][0] Then
								; [0] Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] Difficulty, [4] CGMAIN/CGBB
								Local $aArray[6] = [$GroundTroopChallenges[$j][1], $aAllDetectionsOnScreen[$i][2], $aAllDetectionsOnScreen[$i][3], $GroundTroopChallenges[$j][3], $aAllDetectionsOnScreen[$i][4], $aAllDetectionsOnScreen[$i][6]]
							EndIf
						Next
					Case "B"
						If Not $g_bChkClanGamesBattle Then ContinueLoop
						Local $BattleChallenges = ClanGamesChallenges("$BattleChallenges")
						For $j = 0 To UBound($BattleChallenges) - 1
							; Match the names
							If $aAllDetectionsOnScreen[$i][1] = $BattleChallenges[$j][0] Then
								; Verify the TH level and a few Challenge to destroy TH specific level
								If $BattleChallenges[$j][1] = "Scrappy 6s" And ($g_iTownHallLevel < 5 Or $g_iTownHallLevel > 7) Then ExitLoop        ; TH level 5-6-7
								If $BattleChallenges[$j][1] = "Super 7s" And ($g_iTownHallLevel < 6 Or $g_iTownHallLevel > 8) Then ExitLoop            ; TH level 6-7-8
								If $BattleChallenges[$j][1] = "Exciting 8s" And ($g_iTownHallLevel < 7 Or $g_iTownHallLevel > 9) Then ExitLoop        ; TH level 7-8-9
								If $BattleChallenges[$j][1] = "Noble 9s" And ($g_iTownHallLevel < 8 Or $g_iTownHallLevel > 10) Then ExitLoop        ; TH level 8-9-10
								If $BattleChallenges[$j][1] = "Terrific 10s" And ($g_iTownHallLevel < 9 Or $g_iTownHallLevel > 11) Then ExitLoop    ; TH level 9-10-11
								If $BattleChallenges[$j][1] = "Exotic 11s" And ($g_iTownHallLevel < 10 Or $g_iTownHallLevel > 12) Then ExitLoop     ; TH level 10-11-12
								If $BattleChallenges[$j][1] = "Triumphant 12s" And ($g_iTownHallLevel < 11 Or $g_iTownHallLevel > 13) Then ExitLoop  ; TH level 11-12-13
								If $BattleChallenges[$j][1] = "Tremendous 13s" And ($g_iTownHallLevel < 12 Or $g_iTownHallLevel > 14) Then ExitLoop  ; TH level 12-13-14
								If $BattleChallenges[$j][1] = "Formidable 14s" And $g_iTownHallLevel < 13 Then ExitLoop  ; TH level 13-14-15

								; Verify your TH level and Challenge
								If $g_iTownHallLevel < $BattleChallenges[$j][2] Then ExitLoop

								; If you are a TH16 , doesn't exist the TH17 yet
								If $BattleChallenges[$j][1] = "Attack Up" And $g_iTownHallLevel = 16 Then ExitLoop

								; Check your Trophy Range
								If $BattleChallenges[$j][1] = "Slaying The Titans" And (Int($g_aiCurrentLoot[$eLootTrophy]) < 4100 Or Int($g_aiCurrentLoot[$eLootTrophy]) > 5000) Then ExitLoop

								If $BattleChallenges[$j][1] = "Clash of Legends" And Int($g_aiCurrentLoot[$eLootTrophy]) < 5000 Then ExitLoop

								; Check if exist a probability to use any Spell
								If $BattleChallenges[$j][1] = "No-Magic Zone" And (($g_iMatchMode = $DB And $g_aiAttackAlgorithm[$DB] = 1) Or ($g_iMatchMode = $LB And $g_aiAttackAlgorithm[$LB] = 1)) Then ExitLoop

								; Check if you are using Heroes
								If $BattleChallenges[$j][1] = "No Heroics Allowed" And ((Int($g_aiAttackUseHeroes[$DB]) > $eHeroNone And $g_iMatchMode = $DB) Or (Int($g_aiAttackUseHeroes[$LB]) > $eHeroNone And $g_iMatchMode = $LB)) Then ExitLoop

								; [0] Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] Difficulty, [4] CGMAIN/CGBB
								Local $aArray[6] = [$BattleChallenges[$j][1], $aAllDetectionsOnScreen[$i][2], $aAllDetectionsOnScreen[$i][3], $BattleChallenges[$j][3], $aAllDetectionsOnScreen[$i][4], $aAllDetectionsOnScreen[$i][6]]
							EndIf
						Next
					Case "D"
						If Not $g_bChkClanGamesDes Then ContinueLoop
						Local $DestructionChallenges = ClanGamesChallenges("$DestructionChallenges")
						For $j = 0 To UBound($DestructionChallenges) - 1
							; Match the names
							If $aAllDetectionsOnScreen[$i][1] = $DestructionChallenges[$j][0] Then
								; Verify your TH level and Challenge kind
								If $g_iTownHallLevel < $DestructionChallenges[$j][2] Then ExitLoop

								; Check if you are using Heroes
								If $DestructionChallenges[$j][1] = "Hero Level Hunter" Or _
										$DestructionChallenges[$j][1] = "King Level Hunter" Or _
										$DestructionChallenges[$j][1] = "Queen Level Hunter" Or _
										$DestructionChallenges[$j][1] = "Warden Level Hunter" And _
										((Int($g_aiAttackUseHeroes[$DB]) = $eHeroNone And $g_iMatchMode = $DB) Or (Int($g_aiAttackUseHeroes[$LB]) = $eHeroNone And $g_iMatchMode = $LB)) Then ExitLoop

								If $aAllDetectionsOnScreen[$i][1] = "BBreakdown" And $aAllDetectionsOnScreen[$i][4] = "CGBB" Then ContinueLoop
								If $aAllDetectionsOnScreen[$i][1] = "WallWhacker" And $aAllDetectionsOnScreen[$i][4] = "CGBB" Then ContinueLoop

								; [0] Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] Difficulty, [4] CGMAIN/CGBB
								Local $aArray[6] = [$DestructionChallenges[$j][1], $aAllDetectionsOnScreen[$i][2], $aAllDetectionsOnScreen[$i][3], $DestructionChallenges[$j][3], $aAllDetectionsOnScreen[$i][4], $aAllDetectionsOnScreen[$i][6]]
							EndIf
						Next
					Case "M"
						If Not $g_bChkClanGamesMiscellaneous Then ContinueLoop
						Local $MiscChallenges = ClanGamesChallenges("$MiscChallenges")
						For $j = 0 To UBound($MiscChallenges) - 1
							; Match the names
							If $aAllDetectionsOnScreen[$i][1] = $MiscChallenges[$j][0] Then

								; Exceptions :
								; 1 - "Gardening Exercise" needs at least a Free Builder and "Remove Obstacles" enabled
								If $MiscChallenges[$j][1] = "Gardening Exercise" And ($g_iFreeBuilderCount < 1 Or Not $g_bChkCleanYard) Then ExitLoop

								; 2 - Verify your TH level and Challenge kind
								If $g_iTownHallLevel < $MiscChallenges[$j][2] Then ExitLoop

								; 3 - If you don't Donate Troops
								If $MiscChallenges[$j][1] = "Helping Hand" And Not $g_iActiveDonate Then ExitLoop

								; 4 - If you don't Donate Spells , $g_aiPrepDon[2] = Donate Spells , $g_aiPrepDon[3] = Donate All Spells [PrepareDonateCC()]
								If $MiscChallenges[$j][1] = "Donate Spells" And ($g_aiPrepDon[2] = 0 And $g_aiPrepDon[3] = 0) Then ExitLoop

								; [0] Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] Difficulty, [4] CGMAIN/CGBB
								Local $aArray[6] = [$MiscChallenges[$j][1], $aAllDetectionsOnScreen[$i][2], $aAllDetectionsOnScreen[$i][3], $MiscChallenges[$j][3], $aAllDetectionsOnScreen[$i][4], $aAllDetectionsOnScreen[$i][6]]
							EndIf
						Next
					Case "BBB" ; BB Battle challenges
						If Not $g_bChkClanGamesBBBattle Then ContinueLoop
						Local $BBBattleChallenges = ClanGamesChallenges("$BBBattleChallenges")
						For $j = 0 To UBound($BBBattleChallenges) - 1
							; Match the names
							If $aAllDetectionsOnScreen[$i][1] = $BBBattleChallenges[$j][0] Then
								; [0] Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] Difficulty, [4] CGMAIN/CGBB
								Local $aArray[6] = [$BBBattleChallenges[$j][1], $aAllDetectionsOnScreen[$i][2], $aAllDetectionsOnScreen[$i][3], $BBBattleChallenges[$j][3], $aAllDetectionsOnScreen[$i][4], $aAllDetectionsOnScreen[$i][6]]
							EndIf
						Next
					Case "BBD" ; BB Destruction challenges
						If Not $g_bChkClanGamesBBDes Then ContinueLoop
						Local $BBDestructionChallenges = ClanGamesChallenges("$BBDestructionChallenges")
						For $j = 0 To UBound($BBDestructionChallenges) - 1
							; Match the names
							If $aAllDetectionsOnScreen[$i][1] = $BBDestructionChallenges[$j][0] Then

								If $aAllDetectionsOnScreen[$i][1] = "BuildingDes" And $aAllDetectionsOnScreen[$i][4] = "CGMain" Then ContinueLoop
								If $aAllDetectionsOnScreen[$i][1] = "WallDes" And $aAllDetectionsOnScreen[$i][4] = "CGMain" Then ContinueLoop

								; [0] Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] Difficulty, [4] CGMAIN/CGBB
								Local $aArray[6] = [$BBDestructionChallenges[$j][1], $aAllDetectionsOnScreen[$i][2], $aAllDetectionsOnScreen[$i][3], $BBDestructionChallenges[$j][3], $aAllDetectionsOnScreen[$i][4], $aAllDetectionsOnScreen[$i][6]]
							EndIf
						Next
					Case "BBT" ; BB Troop challenges
						If Not $g_bChkClanGamesBBTroops Then ContinueLoop
						Local $BBTroopsChallenges = ClanGamesChallenges("$BBTroopsChallenges")
						For $j = 0 To UBound($BBTroopsChallenges) - 1
							; Match the names
							If $aAllDetectionsOnScreen[$i][1] = $BBTroopsChallenges[$j][0] Then
								; [0] Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] Difficulty, [4] CGMAIN/CGBB
								Local $aArray[6] = [$BBTroopsChallenges[$j][1], $aAllDetectionsOnScreen[$i][2], $aAllDetectionsOnScreen[$i][3], $BBTroopsChallenges[$j][3], $aAllDetectionsOnScreen[$i][4], $aAllDetectionsOnScreen[$i][6]]
							EndIf
						Next
				EndSwitch
				If IsDeclared("aArray") And $aArray[0] <> "" Then
					ReDim $aSelectChallenges[UBound($aSelectChallenges) + 1][8]
					$aSelectChallenges[UBound($aSelectChallenges) - 1][0] = $aArray[0] ; Event Name Full Name
					$aSelectChallenges[UBound($aSelectChallenges) - 1][1] = $aArray[1] ; Xaxis
					$aSelectChallenges[UBound($aSelectChallenges) - 1][2] = $aArray[2] ; Yaxis
					$aSelectChallenges[UBound($aSelectChallenges) - 1][3] = $aArray[3] ; difficulty
					$aSelectChallenges[UBound($aSelectChallenges) - 1][4] = 0          ; timer minutes
					$aSelectChallenges[UBound($aSelectChallenges) - 1][5] = $aArray[4] ; EventType: MainVillage/BuilderBase
					$aSelectChallenges[UBound($aSelectChallenges) - 1][6] = $aArray[5] ; Challenge Page
					$aSelectChallenges[UBound($aSelectChallenges) - 1][7] = 0            ; Event Points
					$aArray[0] = ""
				EndIf
			Next
		EndIf

		If $g_bChkClanGamesDebug Then Setlog("_ClanGames aAllDetectionsOnScreen (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds)", $COLOR_INFO)
		$hTimer = TimerInit()

		; Sort by Yaxis
		_ArraySort($aSelectChallenges, 1, 0, 0, 2)
		; Then Sort by Page
		_ArraySort($aSelectChallenges, 1, 0, 0, 6)

		If UBound($aSelectChallenges) > 0 Then
			; let's get the Event timing
			For $i = 0 To UBound($aSelectChallenges) - 1
				ChallengeNextPage($aSelectChallenges[$i][6], $iRow)
				Click($aSelectChallenges[$i][1], $aSelectChallenges[$i][2])
				If _Sleep(1500) Then Return
				Local $EventHours = GetEventInformation()
				Local $EventPoints = GetEventPoints()
				If $EventHours > 0 Then
					Setlog("Detected " & $aSelectChallenges[$i][0] & " difficulty of " & $aSelectChallenges[$i][3] & " Time: " & $EventHours & " min", $COLOR_INFO)
				Else
					Setlog("Detected " & $aSelectChallenges[$i][0] & " difficulty of " & $aSelectChallenges[$i][3] & " Time: Out Of Time", $COLOR_DEBUG1)
				EndIf
				Click($aSelectChallenges[$i][1], $aSelectChallenges[$i][2])
				If _Sleep(250) Then Return
				$aSelectChallenges[$i][4] = Number($EventHours)
				$aSelectChallenges[$i][7] = Number($EventPoints)
			Next

			Local $aTempSelectChallenges[0][7]
			For $i = 0 To UBound($aSelectChallenges) - 1
				; let's get the 1440 minutes events then remove from array
				If $aSelectChallenges[$i][4] = 1440 And $g_bChkClanGamesNoOneDay Then
					Setlog($aSelectChallenges[$i][0] & " unselected, this is a 1 Day challenge!", $COLOR_INFO)
					ContinueLoop
				EndIf
				; let's remove all events which lead to > max points from array when Stop before completing your limit
				If $g_bChkClanGamesStopBeforeReachAndPurge Then
					$sTimeCG = ConvertOCRTime("ClanGames()", $g_sClanGamesTimeRemaining, False)
					If $sTimeCG > 1440 Then
						If $aiScoreLimit[0] + $aSelectChallenges[$i][7] >= $aiScoreLimit[1] Then
							Setlog($aSelectChallenges[$i][0] & " unselected, Bot must stop before max points!", $COLOR_INFO)
							ContinueLoop
						EndIf
					EndIf
				EndIf
				ReDim $aTempSelectChallenges[UBound($aTempSelectChallenges) + 1][7]
				$aTempSelectChallenges[UBound($aTempSelectChallenges) - 1][0] = $aSelectChallenges[$i][0] ; Event Name Full Name
				$aTempSelectChallenges[UBound($aTempSelectChallenges) - 1][1] = $aSelectChallenges[$i][1] ; Xaxis
				$aTempSelectChallenges[UBound($aTempSelectChallenges) - 1][2] = $aSelectChallenges[$i][2] ; Yaxis
				$aTempSelectChallenges[UBound($aTempSelectChallenges) - 1][3] = Number($aSelectChallenges[$i][3]) ; difficulty
				$aTempSelectChallenges[UBound($aTempSelectChallenges) - 1][4] = Number($aSelectChallenges[$i][4]) ; timer minutes
				$aTempSelectChallenges[UBound($aTempSelectChallenges) - 1][5] = $aSelectChallenges[$i][5] ; EventType: MainVillage/BuilderBase
				$aTempSelectChallenges[UBound($aTempSelectChallenges) - 1][6] = $aSelectChallenges[$i][6] ; Challenge Page
			Next

			Local $aTmpBBChallenges[0][7]
			Local $aTmpMainChallenges[0][7]
			If $g_bChkForceBBAttackOnClanGames And $bSearchBBEventFirst Then
				Local $CGMAinCount = 0
				SetLog("Try To Do BB Challenge First", $COLOR_DEBUG1)
				For $i = 0 To UBound($aTempSelectChallenges) - 1
					If $aTempSelectChallenges[$i][5] = "CGMain" Then
						$CGMAinCount += 1
						ContinueLoop
					EndIf
					ReDim $aTmpBBChallenges[UBound($aTmpBBChallenges) + 1][7]
					$aTmpBBChallenges[UBound($aTmpBBChallenges) - 1][0] = $aTempSelectChallenges[$i][0] ; Event Name Full Name
					$aTmpBBChallenges[UBound($aTmpBBChallenges) - 1][1] = $aTempSelectChallenges[$i][1] ; Xaxis
					$aTmpBBChallenges[UBound($aTmpBBChallenges) - 1][2] = $aTempSelectChallenges[$i][2] ; Yaxis
					$aTmpBBChallenges[UBound($aTmpBBChallenges) - 1][3] = Number($aTempSelectChallenges[$i][3]) ; difficulty
					$aTmpBBChallenges[UBound($aTmpBBChallenges) - 1][4] = Number($aTempSelectChallenges[$i][4]) ; timer minutes
					$aTmpBBChallenges[UBound($aTmpBBChallenges) - 1][5] = $aTempSelectChallenges[$i][5] ; EventType: MainVillage/BuilderBase
					$aTmpBBChallenges[UBound($aTmpBBChallenges) - 1][6] = $aTempSelectChallenges[$i][6] ; Challenge Page
				Next

				If UBound($aTmpBBChallenges) > 0 Then
					If UBound($aTmpBBChallenges) = 1 Then
						SetLog("Found " & UBound($aTmpBBChallenges) & " BB Challenge", $COLOR_SUCCESS)
					Else
						SetLog("Found " & UBound($aTmpBBChallenges) & " BB Challenges", $COLOR_SUCCESS)
					EndIf
					$aTempSelectChallenges = $aTmpBBChallenges ;replace All Challenge array with BB Only Event Array
				Else
					If $CGMAinCount = 1 Then
						SetLog("No BB Challenge Found, using current detected Main Village Challenge", $COLOR_INFO)
					Else
						SetLog("No BB Challenge Found, using current detected Main Village Challenges", $COLOR_INFO)
					EndIf
				EndIf
			ElseIf $g_bChkForceBBAttackOnClanGames And $bSearchMainEventFirst Then
				Local $CGBBCount = 0
				SetLog("Try To Do Main Village Challenge First", $COLOR_DEBUG1)
				For $i = 0 To UBound($aTempSelectChallenges) - 1
					If $aTempSelectChallenges[$i][5] = "CGBB" Then
						$CGBBCount += 1
						ContinueLoop
					EndIf
					ReDim $aTmpMainChallenges[UBound($aTmpMainChallenges) + 1][7]
					$aTmpMainChallenges[UBound($aTmpMainChallenges) - 1][0] = $aTempSelectChallenges[$i][0] ; Event Name Full Name
					$aTmpMainChallenges[UBound($aTmpMainChallenges) - 1][1] = $aTempSelectChallenges[$i][1] ; Xaxis
					$aTmpMainChallenges[UBound($aTmpMainChallenges) - 1][2] = $aTempSelectChallenges[$i][2] ; Yaxis
					$aTmpMainChallenges[UBound($aTmpMainChallenges) - 1][3] = Number($aTempSelectChallenges[$i][3]) ; difficulty
					$aTmpMainChallenges[UBound($aTmpMainChallenges) - 1][4] = Number($aTempSelectChallenges[$i][4]) ; timer minutes
					$aTmpMainChallenges[UBound($aTmpMainChallenges) - 1][5] = $aTempSelectChallenges[$i][5] ; EventType: MainVillage/BuilderBase
					$aTmpMainChallenges[UBound($aTmpMainChallenges) - 1][6] = $aTempSelectChallenges[$i][6] ; Challenge Page
				Next

				If UBound($aTmpMainChallenges) > 0 Then
					If UBound($aTmpMainChallenges) = 1 Then
						SetLog("Found " & UBound($aTmpMainChallenges) & " Main Village Challenge", $COLOR_SUCCESS)
					Else
						SetLog("Found " & UBound($aTmpMainChallenges) & " Main Village Challenges", $COLOR_SUCCESS)
					EndIf
					$aTempSelectChallenges = $aTmpMainChallenges ;replace All Challenge array with Main Only Event Array
				Else
					If $CGBBCount = 1 Then
						SetLog("No Main Village Challenge Found, using current detected BB Challenge", $COLOR_INFO)
					Else
						SetLog("No Main Village Challenge Found, using current detected BB Challenges", $COLOR_INFO)
					EndIf
				EndIf
			ElseIf $g_bChkForceBBAttackOnClanGames And $bSearchBothVillages Then
				SetLog("Both Villages Equal Priority To Choose Challenges", $COLOR_DEBUG1)
			EndIf

			; Drop to top again , because coordinates Xaxis and Yaxis
			ClickP($TabChallengesPosition, 2, 0, "#Tab")
			If _Sleep(2000) Then Return
		EndIf

		; After removing is necessary check Ubound
		If IsDeclared("aTempSelectChallenges") Then
			If UBound($aTempSelectChallenges) > 0 Then
				If $g_bSortClanGames Then
					Switch $g_iSortClanGames
						Case 0 ;sort by Difficulty
							_ArraySort($aTempSelectChallenges, 0, 0, 0, 3) ;sort ascending, lower difficulty = easiest
							SetLog("Sort Challenges by Difficulty", $COLOR_ACTION)
						Case 1 ;sort by Time
							_ArraySort($aTempSelectChallenges, 0, 0, 0, 4) ;sort descending, shortest time first
							SetLog("Sort Challenges by Time, Shortest First", $COLOR_ACTION)
						Case 2 ;sort by Time
							_ArraySort($aTempSelectChallenges, 1, 0, 0, 4) ;sort descending, longest time first
							SetLog("Sort Challenges by Time, Longest First", $COLOR_ACTION)
					EndSwitch
				EndIf
				For $i = 0 To UBound($aTempSelectChallenges) - 1
					If Not $g_bRunState Then Return
					SetDebugLog("$aTempSelectChallenges: " & _ArrayToString($aTempSelectChallenges))
					Setlog("Next Challenge will be " & $aTempSelectChallenges[$i][0] & " to do in " & $aTempSelectChallenges[$i][4] & " min.")
					; Select and Start EVENT
					ChallengeNextPage($aTempSelectChallenges[$i][6], $iRow)
					$sEventName = $aTempSelectChallenges[$i][0]
					If Not QuickMIS("BC1", $sTempChallengePath & "Selected\", $aTempSelectChallenges[$i][1] - 60, $aTempSelectChallenges[$i][2] - 60, $aTempSelectChallenges[$i][1] + 60, $aTempSelectChallenges[$i][2] + 60, True) Then
						SetLog($sEventName & " not found on previous location detected", $COLOR_ERROR)
						SetLog("Maybe challenge tile changed, Restart Search...", $COLOR_INFO)
						If _Sleep(2000) Then Return
						$EventLoopOut = True
						$IsLooped += 1
						If $IsLooped > 4 Then
							SetLog("Something went wrong, Come Back Here Later", $COLOR_ACTION)
							$IsSomethingWrong = True
							ExitLoop 2
						EndIf
						; Clear
						$aAllDetectionsOnScreen = ""
						$aSelectChallenges = ""
						$aTempSelectChallenges = ""
						$sEventName = ""
						ChallengeNextPage(1, $iRow)
						ContinueLoop 2
					EndIf
					$CurrentActiveChallenge = $aTempSelectChallenges[$i][0]
					Click($aTempSelectChallenges[$i][1], $aTempSelectChallenges[$i][2])
					If _Sleep(1500) Then Return
					Return ClickOnEvent($YourAccScore, $aiScoreLimit, $sEventName, $getCapture)
				Next
			EndIf
		EndIf
	WEnd

	If $IsSomethingWrong Then
		CloseWindow()
		ClearTempCGFiles()
		If _Sleep(2000) Then Return
		Return
	EndIf

	If $g_bChkClanGamesPurgeAny Then ; still have to purge, because no enabled event on setting found
		SetLog("Purge needed, because no enabled challenge on setting found", $COLOR_WARNING)
		If Not PurgeUncheckedEvent($iRow) Then ; Purge an Unchecked Event from first list
			SetLog("No Challenge found, lets purge 1 random challenge", $COLOR_WARNING)
			PurgeEvent(False, True, True, $iRow, True) ; Or purge any event
		EndIf
		If _Sleep(1000) Then Return
	Else
		SetLog("No Challenge found, Check your settings", $COLOR_WARNING)
		If $g_bCGDebugEvents Then
			ChallengeNextPage(1, $iRow)
			If _Sleep(1000) Then Return
			SaveDebugImage("CG_No_Challenge", True, True, "_P1 ")
			If _Sleep(1000) Then Return
			ChallengeNextPage(2, $iRow)
			If _Sleep(1000) Then Return
			SaveDebugImage("CG_No_Challenge", True, True, "_P2 ")
			If _Sleep(1000) Then Return
		EndIf
		CloseWindow()
		If _Sleep(2000) Then Return
	EndIf

	ClearTempCGFiles()

EndFunc   ;==>_ClanGames

Func ClearTempCGFiles()
	Local $sTempChallengePath = @TempDir & "\" & $g_sProfileCurrentName
	If FileExists($sTempChallengePath) Then
		;Remove All files From Clan Games
		DirRemove($sTempChallengePath, $DIR_REMOVE)
	EndIf
	If _Sleep(500) Then Return
EndFunc   ;==>ClearTempCGFiles

Func ClanGameImageCopy($sImagePath, $sTempChallengePath, $sImageType = Default, $ImageName = Default)
	If $sImageType = Default Then Return
	Switch $sImageType
		Case "L"
			Local $CGMainLoot = ClanGamesChallenges("$LootChallenges")
			For $i = 0 To UBound($g_abCGMainLootItem) - 1
				If $g_abCGMainLootItem[$i] > 0 Then
					If $g_bChkClanGamesDebug Then SetLog("[" & $i & "]" & "LootChallenges: " & $CGMainLoot[$i][1], $COLOR_DEBUG)
					FileCopy($sImagePath & "\" & $sImageType & "-" & $CGMainLoot[$i][0] & "_*", $sTempChallengePath, $FC_OVERWRITE + $FC_CREATEPATH)
				Else
					FileCopy($sImagePath & "\" & $sImageType & "-" & $CGMainLoot[$i][0] & "_*", $sTempChallengePath & "\Purge\", $FC_OVERWRITE + $FC_CREATEPATH)
				EndIf
			Next
		Case "B"
			Local $CGMainBattle = ClanGamesChallenges("$BattleChallenges")
			For $i = 0 To UBound($g_abCGMainBattleItem) - 1
				If $g_abCGMainBattleItem[$i] > 0 Then
					If $g_bChkClanGamesDebug Then SetLog("[" & $i & "]" & "BattleChallenges: " & $CGMainBattle[$i][1], $COLOR_DEBUG)
					FileCopy($sImagePath & "\" & $sImageType & "-" & $CGMainBattle[$i][0] & "_*", $sTempChallengePath, $FC_OVERWRITE + $FC_CREATEPATH)
				Else
					FileCopy($sImagePath & "\" & $sImageType & "-" & $CGMainBattle[$i][0] & "_*", $sTempChallengePath & "\Purge\", $FC_OVERWRITE + $FC_CREATEPATH)
				EndIf
			Next
		Case "D"
			Local $CGMainDestruction = ClanGamesChallenges("$DestructionChallenges")
			For $i = 0 To UBound($g_abCGMainDestructionItem) - 1
				If $g_abCGMainDestructionItem[$i] > 0 Then
					If $g_bChkClanGamesDebug Then SetLog("[" & $i & "]" & "DestructionChallenges: " & $CGMainDestruction[$i][1], $COLOR_DEBUG)
					FileCopy($sImagePath & "\" & $sImageType & "-" & $CGMainDestruction[$i][0] & "_*", $sTempChallengePath, $FC_OVERWRITE + $FC_CREATEPATH)
				Else
					FileCopy($sImagePath & "\" & $sImageType & "-" & $CGMainDestruction[$i][0] & "_*", $sTempChallengePath & "\Purge\", $FC_OVERWRITE + $FC_CREATEPATH)
				EndIf
			Next
		Case "A"
			Local $CGMainAir = ClanGamesChallenges("$AirTroopChallenges")
			For $i = 0 To UBound($g_abCGMainAirItem) - 1
				If $g_abCGMainAirItem[$i] > 0 Then
					If $g_bChkClanGamesDebug Then SetLog("[" & $i & "]" & "AirTroopChallenges: " & $CGMainAir[$i][1], $COLOR_DEBUG)
					FileCopy($sImagePath & "\" & $sImageType & "-" & $CGMainAir[$i][0] & "_*", $sTempChallengePath, $FC_OVERWRITE + $FC_CREATEPATH)
				Else
					FileCopy($sImagePath & "\" & $sImageType & "-" & $CGMainAir[$i][0] & "_*", $sTempChallengePath & "\Purge\", $FC_OVERWRITE + $FC_CREATEPATH)
				EndIf
			Next
		Case "G"
			Local $CGMainGround = ClanGamesChallenges("$GroundTroopChallenges")
			For $i = 0 To UBound($g_abCGMainGroundItem) - 1
				If $g_abCGMainGroundItem[$i] > 0 Then
					If $g_bChkClanGamesDebug Then SetLog("[" & $i & "]" & "GroundTroopChallenges: " & $CGMainGround[$i][1], $COLOR_DEBUG)
					FileCopy($sImagePath & "\" & $sImageType & "-" & $CGMainGround[$i][0] & "_*", $sTempChallengePath, $FC_OVERWRITE + $FC_CREATEPATH)
				Else
					FileCopy($sImagePath & "\" & $sImageType & "-" & $CGMainGround[$i][0] & "_*", $sTempChallengePath & "\Purge\", $FC_OVERWRITE + $FC_CREATEPATH)
				EndIf
			Next
		Case "M"
			Local $CGMainMisc = ClanGamesChallenges("$MiscChallenges")
			For $i = 0 To UBound($g_abCGMainMiscItem) - 1
				If $g_abCGMainMiscItem[$i] > 0 Then
					If $g_bChkClanGamesDebug Then SetLog("[" & $i & "]" & "MiscChallenges: " & $CGMainMisc[$i][1], $COLOR_DEBUG)
					FileCopy($sImagePath & "\" & $sImageType & "-" & $CGMainMisc[$i][0] & "_*", $sTempChallengePath, $FC_OVERWRITE + $FC_CREATEPATH)
				Else
					FileCopy($sImagePath & "\" & $sImageType & "-" & $CGMainMisc[$i][0] & "_*", $sTempChallengePath & "\Purge\", $FC_OVERWRITE + $FC_CREATEPATH)
				EndIf
			Next
		Case "S"
			Local $CGMainSpell = ClanGamesChallenges("$SpellChallenges")
			For $i = 0 To UBound($g_abCGMainSpellItem) - 1
				If $g_abCGMainSpellItem[$i] > 0 Then
					If $g_bChkClanGamesDebug Then SetLog("[" & $i & "]" & "SpellChallenges: " & $CGMainSpell[$i][1], $COLOR_DEBUG)
					FileCopy($sImagePath & "\" & $sImageType & "-" & $CGMainSpell[$i][0] & "_*", $sTempChallengePath, $FC_OVERWRITE + $FC_CREATEPATH)
				Else
					FileCopy($sImagePath & "\" & $sImageType & "-" & $CGMainSpell[$i][0] & "_*", $sTempChallengePath & "\Purge\", $FC_OVERWRITE + $FC_CREATEPATH)
				EndIf
			Next
		Case "BBB"
			Local $CGBBBattle = ClanGamesChallenges("$BBBattleChallenges")
			For $i = 0 To UBound($g_abCGBBBattleItem) - 1
				If $g_abCGBBBattleItem[$i] > 0 Then
					If $g_bChkClanGamesDebug Then SetLog("[" & $i & "]" & "BBBattleChallenges: " & $CGBBBattle[$i][1], $COLOR_DEBUG)
					FileCopy($sImagePath & "\" & $sImageType & "-" & $CGBBBattle[$i][0] & "_*", $sTempChallengePath, $FC_OVERWRITE + $FC_CREATEPATH)
				Else
					FileCopy($sImagePath & "\" & $sImageType & "-" & $CGBBBattle[$i][0] & "_*", $sTempChallengePath & "\Purge\", $FC_OVERWRITE + $FC_CREATEPATH)
				EndIf
			Next
		Case "BBD"
			Local $CGBBDestruction = ClanGamesChallenges("$BBDestructionChallenges")
			For $i = 0 To UBound($g_abCGBBDestructionItem) - 1
				If $g_abCGBBDestructionItem[$i] > 0 Then
					If $g_bChkClanGamesDebug Then SetLog("[" & $i & "]" & "BBDestructionChallenges: " & $CGBBDestruction[$i][1], $COLOR_DEBUG)
					FileCopy($sImagePath & "\" & $sImageType & "-" & $CGBBDestruction[$i][0] & "_*", $sTempChallengePath, $FC_OVERWRITE + $FC_CREATEPATH)
				Else
					FileCopy($sImagePath & "\" & $sImageType & "-" & $CGBBDestruction[$i][0] & "_*", $sTempChallengePath & "\Purge\", $FC_OVERWRITE + $FC_CREATEPATH)
				EndIf
			Next
		Case "BBT"
			Local $CGBBTroops = ClanGamesChallenges("$BBTroopsChallenges")
			For $i = 0 To UBound($g_abCGBBTroopsItem) - 1
				If $g_abCGBBTroopsItem[$i] > 0 Then
					If $g_bChkClanGamesDebug Then SetLog("[" & $i & "]" & "BBTroopsChallenges: " & $CGBBTroops[$i][1], $COLOR_DEBUG)
					FileCopy($sImagePath & "\" & $sImageType & "-" & $CGBBTroops[$i][0] & "_*", $sTempChallengePath, $FC_OVERWRITE + $FC_CREATEPATH)
				Else
					FileCopy($sImagePath & "\" & $sImageType & "-" & $CGBBTroops[$i][0] & "_*", $sTempChallengePath & "\Purge\", $FC_OVERWRITE + $FC_CREATEPATH)
				EndIf
			Next
	EndSwitch
	If $sImageType = "Selected" Then
		If $g_bChkClanGamesDebug Then SetLog("[" & $ImageName & "] Selected", $COLOR_DEBUG)
		FileCopy($sImagePath & "\" & $ImageName & "_*", $sTempChallengePath & "\Selected\", $FC_OVERWRITE + $FC_CREATEPATH)
	ElseIf $sImageType = "UnSelected" Then
		If $g_bChkClanGamesDebug Then SetLog("[" & $ImageName & "] UnSelected", $COLOR_DEBUG)
		FileCopy($sImagePath & "\" & $ImageName & "_*", $sTempChallengePath & "\UnSelected\", $FC_OVERWRITE + $FC_CREATEPATH)
	EndIf
EndFunc   ;==>ClanGameImageCopy

Func ChallengeNextPage($iRowTarget, ByRef $iRow)
	Local $iXMidPoint

	While 1

		$iXMidPoint = Random(810, 840, 1)

		If $iRow < $iRowTarget Then
			ClickDrag($iXMidPoint, 470 + $g_iMidOffsetY, $iXMidPoint, 270 + $g_iMidOffsetY)
			$iRow += 1
			If _Sleep(2500) Then Return
		EndIf

		If $iRow > $iRowTarget Then
			ClickDrag($iXMidPoint, 250 + $g_iMidOffsetY, $iXMidPoint, 450 + $g_iMidOffsetY)
			$iRow -= 1
			If _Sleep(2500) Then Return
		EndIf

		If $iRow = $iRowTarget Then ExitLoop

		If _Sleep(1500) Then Return

	WEnd

EndFunc   ;==>ChallengeNextPage

Func FindEvent()
	Local $hStarttime = _Timer_Init()
	Local $sImagePath = @ScriptDir & "\imgxml\Resources\ClanGamesImages\Challenges"
	Local $sTempChallengePath = @TempDir & "\" & $g_sProfileCurrentName & "\Challenges\"
	Local $aEvent, $aReturn[0][7]
	Local $iRow = 1
	Local $aX[4] = [284, 418, 550, 685]
	Local $aY[3] = [155 + $g_iMidOffsetY, 325 + $g_iMidOffsetY, 305 + $g_iMidOffsetY]

	For $y = 0 To UBound($aY) - 1
		If $y = UBound($aY) - 1 Then
			ChallengeNextPage(2, $iRow)
			If $g_bCGDebugEvents Then
				If _Sleep(1000) Then Return
				SaveDebugImage("CG_All_Challenges", True, True, "_P2 ")
				If _Sleep(1000) Then Return
			EndIf
		EndIf
		For $x = 0 To UBound($aX) - 1
			$aEvent = QuickMIS("CNX", $sTempChallengePath, $aX[$x], $aY[$y], $aX[$x] + 114, $aY[$y] + 130)
			If IsArray($aEvent) And UBound($aEvent) > 0 Then
				Local $IsBBEvent = IsBBChallenge($aEvent[0][1], $aEvent[0][2])
				If $IsBBEvent Then
					$IsBBEvent = "CGBB"
				Else
					$IsBBEvent = "CGMain"
				EndIf

				Local $ChallengeEvent = StringSplit($aEvent[0][0], "-", $STR_NOCOUNT)

				If $ChallengeEvent[0] = "D" And $IsBBEvent = "CGBB" Then
					Switch $aEvent[0][0]
						Case "D-BBreakdown"
							$ChallengeEvent[0] = "BBD"
							$ChallengeEvent[1] = "BuildingDes"
							$aEvent[0][0] = "BBD-BuildingDes"
						Case "D-WallWhacker"
							$ChallengeEvent[0] = "BBD"
							$ChallengeEvent[1] = "WallDes"
							$aEvent[0][0] = "BBD-WallDes"
					EndSwitch
				EndIf

				If $ChallengeEvent[0] = "BBD" And $IsBBEvent = "CGMain" Then
					Switch $aEvent[0][0]
						Case "BBD-BuildingDes"
							$ChallengeEvent[0] = "D"
							$ChallengeEvent[1] = "BBreakdown"
							$aEvent[0][0] = "D-BBreakdown"
						Case "BBD-WallDes"
							$ChallengeEvent[0] = "D"
							$ChallengeEvent[1] = "WallWhacker"
							$aEvent[0][0] = "D-WallWhacker"
					EndSwitch
				EndIf

				If $ChallengeEvent[0] = "A" And $IsBBEvent = "CGBB" Then
					If $aEvent[0][0] = "A-BabyD" Then
						$ChallengeEvent[0] = "BBT"
						$ChallengeEvent[1] = "BabyD"
						$aEvent[0][0] = "BBT-BabyD"
					EndIf
				EndIf

				If $ChallengeEvent[0] = "BBT" And $IsBBEvent = "CGMain" Then
					If $aEvent[0][0] = "BBT-BabyD" Then
						$ChallengeEvent[0] = "A"
						$ChallengeEvent[1] = "BabyD"
						$aEvent[0][0] = "A-BabyD"
					EndIf
				EndIf

				If $ChallengeEvent[0] = "D" And $IsBBEvent = "CGMain" Then
					If $aEvent[0][0] = "D-BBreakdown" And $g_abCGMainDestructionItem[23] < 1 Then ContinueLoop
					If $aEvent[0][0] = "D-WallWhacker" And $g_abCGMainDestructionItem[22] < 1 Then ContinueLoop
				EndIf
				If $ChallengeEvent[0] = "BBD" And $IsBBEvent = "CGBB" Then
					If $aEvent[0][0] = "BBD-WallDes" And $g_abCGBBDestructionItem[14] < 1 Then ContinueLoop
					If $aEvent[0][0] = "BBD-BuildingDes" And $g_abCGBBDestructionItem[1] < 1 Then ContinueLoop
				EndIf
				If $ChallengeEvent[0] = "A" And $IsBBEvent = "CGMain" Then
					If $aEvent[0][0] = "A-BabyD" And $g_abCGMainAirItem[2] < 1 Then ContinueLoop
				EndIf
				If $ChallengeEvent[0] = "BBT" And $IsBBEvent = "CGBB" Then
					If $aEvent[0][0] = "BBT-BabyD" And $g_abCGBBTroopsItem[5] < 1 Then ContinueLoop
				EndIf

				ClanGameImageCopy($sImagePath, $sTempChallengePath, "Selected", $aEvent[0][0])
				;Return Case(L, A, S, etc...), Event File Name, X, Y, IsBBEvent, Full File Event Name, Challenge Page
				_ArrayAdd($aReturn, $ChallengeEvent[0] & "|" & $ChallengeEvent[1] & "|" & $aEvent[0][1] & "|" & $aEvent[0][2] & "|" & $IsBBEvent & "|" & $aEvent[0][0] & "|" & $iRow)
			EndIf
		Next
	Next
	SetDebugLog("Benchmark FindEvent selection: " & StringFormat("%.2f", _Timer_Diff($hStarttime)) & "'ms", $COLOR_DEBUG)
	Return $aReturn
EndFunc   ;==>FindEvent

Func IsClanGamesWindow()
	Local $sState, $bRet = False
	Local $Found = False
	Local $currentDate = Number(@MDAY)

	For $i = 1 To 10
		If QuickMIS("BC1", $g_sImgCaravan, 180, 55, 300, 120 + $g_iMidOffsetY) Then
			$Found = True
			SetLog("Caravan available! Entering Clan Games", $COLOR_SUCCESS)
			Click($g_iQuickMISX, $g_iQuickMISY)
			; Just wait for window open
			If _Sleep(2500) Then Return
			$sState = IsClanGamesRunning()
			Switch $sState
				Case "Prepare"
					$bRet = False
				Case "Running"
					$bRet = True
				Case "Ended"
					$bRet = False
			EndSwitch
			ExitLoop
		EndIf
		If $currentDate >= 28 And Not QuickMIS("BC1", $g_sImgCaravan, 180, 55, 300, 120 + $g_iMidOffsetY) Then
			$g_bClanGamesCompleted = 1
			$Found = False
			$bRet = False
			ExitLoop
		EndIf
		If _Sleep(1000) Then Return
	Next

	If $Found = False And ($currentDate = 21 Or $currentDate = 22) Then
		SetLog("Caravan not available", $COLOR_WARNING)
		SetLog("Clan Games is preparing")
		$sState = "Prepare"
		$bRet = False
	EndIf

	If $Found = False And $currentDate >= 28 Then
		SetLog("Caravan not available", $COLOR_WARNING)
		SetLog("Clan Games has already been completed")
		$sState = "Ended"
		$bRet = False
	EndIf

	SetLog("Clan Games State is : " & $sState, $COLOR_INFO)
	Return $bRet
EndFunc   ;==>IsClanGamesWindow

Func IsClanGamesRunning() ;to check whether clangames current state, return string of the state "prepare" "running" "end"
	Local $aGameTime[4] = [384, 428 + $g_iMidOffsetY, 0xFFFFFF, 10]
	Local $sState = "Running"
	If QuickMIS("BC1", $g_sImgWindow, 80, 70 + $g_iMidOffsetY, 160, 220 + $g_iMidOffsetY) Then
		SetLog("Window Opened", $COLOR_DEBUG)
		If QuickMIS("BC1", $g_sImgReward, 580, 440 + $g_iMidOffsetY, 830, 500 + $g_iMidOffsetY) Then
			SetLog("Your Reward is Ready", $COLOR_INFO)
			CollectClanGamesRewards()
			$sState = "Ended"
			If Not $g_bChkClanGamesCollectRewards Then $g_bClanGamesCompleted = 1
		EndIf
	Else
		If _CheckPixel($aGameTime, True) Then
			Local $sTimeRemain = getOcrTimeGameTime(370, 471 + $g_iMidOffsetY) ; read Clan Games waiting time
			SetLog("Clan Games will start in " & $sTimeRemain, $COLOR_INFO)
			$g_sClanGamesTimeRemaining = $sTimeRemain
			$sState = "Prepare"
		Else
			SetLog("Clan Games Window Not Opened", $COLOR_DEBUG)
			$sState = "Cannot open ClanGames"
		EndIf
	EndIf
	Return $sState
EndFunc   ;==>IsClanGamesRunning

Func GetTimesAndScores($SetLog = True)
	Local $iRestScore = -1, $sYourGameScore = "", $aiScoreLimit, $sTimeRemain = 0

	;Ocr for game time remaining
	$sTimeRemain = getOcrTimeGameTime(55, 495 + $g_iMidOffsetY) ; read Clan Games waiting time

	;Check if OCR returned a valid timer format
	If Not StringRegExp($sTimeRemain, "([0-2]?[0-9]?[DdHhSs]+)", $STR_REGEXPMATCH, 1) Then
		SetLog("getOcrTimeGameTime(): no valid return value (" & $sTimeRemain & ")", $COLOR_ERROR)
	EndIf

	If $SetLog Then SetLog("Clan Games time remaining: " & $sTimeRemain, $COLOR_INFO)

	; This Loop is just to check if the Score is changing , when you complete a previous events is necessary to take some time
	For $i = 0 To 10
		$sYourGameScore = getOcrYourScore(75, 560 + $g_iMidOffsetY) ;  Read your Score
		If $g_bChkClanGamesDebug Then SetLog("Your OCR score: " & $sYourGameScore)
		$sYourGameScore = StringReplace($sYourGameScore, "#", "/")
		$aiScoreLimit = StringSplit($sYourGameScore, "/", $STR_NOCOUNT)
		If UBound($aiScoreLimit, 1) > 1 Then
			If $iRestScore = Int($aiScoreLimit[0]) Then ExitLoop
			$iRestScore = Int($aiScoreLimit[0])
		Else
			Return -1
		EndIf
		If _Sleep(800) Then Return
		If $i = 10 Then Return -1
	Next

	;Update Values
	$g_sClanGamesScore = $sYourGameScore
	$g_sClanGamesTimeRemaining = $sTimeRemain

	$aiScoreLimit[0] = Int($aiScoreLimit[0])
	$aiScoreLimit[1] = Int($aiScoreLimit[1])
	Return $aiScoreLimit
EndFunc   ;==>GetTimesAndScores

Func IsEventRunning($bOpenWindow = False)
	Local $aEventFailed[4] = [295, 265 + $g_iMidOffsetY, 0xEA2B24, 20]
	Local $aEventPurged[4] = [295, 280 + $g_iMidOffsetY, 0x58C790, 20]
	Local $sTempChallengePath = @TempDir & "\" & $g_sProfileCurrentName & "\Challenges\"

	If $bOpenWindow Then
		ClickAway()
		SetLog("Entering Clan Games", $COLOR_INFO)
		If Not IsClanGamesWindow() Then Return
	EndIf

	; Check if any event is running or not
	If Not _ColorCheck(_GetPixelColor(295, 280 + $g_iMidOffsetY, True), Hex(0x53DE50, 6), 10) Then ; Green Bar from First Position
		;Check if Event failed
		If _CheckPixel($aEventFailed, True) Then
			SetLog("Couldn't finish last challenge! Lets trash it and look for a new one", $COLOR_INFO)
			If TrashFailedEvent() Then
				If _Sleep(3000) Then Return ;Add sleep here, to wait ClanGames Challenge Tile ordered again as 1 has been deleted
				Return False
			Else
				SetLog("Error happend while trashing failed challenge", $COLOR_ERROR)
				CloseWindow()
				Return True
			EndIf
		ElseIf _CheckPixel($aEventPurged, True) Then
			SetLog("A challenge purge cooldown in progress!", $COLOR_WARNING)
			CloseWindow()
			Return True
		Else
			SetLog("A challenge is already in progress!", $COLOR_SUCCESS)

			;check if its Enabled Challenge, if not = purge
			Local $bNeedPurge = False
			Local $aActiveEvent = QuickMIS("CNX", $sTempChallengePath, 284, 154 + $g_iMidOffsetY, 398, 267 + $g_iMidOffsetY, True)
			If IsArray($aActiveEvent) And UBound($aActiveEvent) > 0 Then
				SetDebugLog("Active Challenge " & $aActiveEvent[0][0] & " is Enabled on Setting, OK!!", $COLOR_DEBUG)

				Local $ActiveChallengeFullName = StringSplit($aActiveEvent[0][0], "-", $STR_NOCOUNT)

				Switch $ActiveChallengeFullName[0]
					Case "L"
						Local $LootChallenges = ClanGamesChallenges("$LootChallenges")
						For $j = 0 To UBound($LootChallenges) - 1
							; Match the names
							If $ActiveChallengeFullName[1] = $LootChallenges[$j][0] Then
								$CurrentActiveChallenge = $LootChallenges[$j][1]
							EndIf
						Next
					Case "A"
						Local $AirTroopChallenges = ClanGamesChallenges("$AirTroopChallenges")
						For $j = 0 To UBound($AirTroopChallenges) - 1
							; Match the names
							If $ActiveChallengeFullName[1] = $AirTroopChallenges[$j][0] Then
								$CurrentActiveChallenge = $AirTroopChallenges[$j][1]
							EndIf
						Next
					Case "S" ; - grumpy
						Local $SpellChallenges = ClanGamesChallenges("$SpellChallenges") ; load all spell challenges
						For $j = 0 To UBound($SpellChallenges) - 1 ; loop through all challenges
							; Match the names
							If $ActiveChallengeFullName[1] = $SpellChallenges[$j][0] Then
								$CurrentActiveChallenge = $SpellChallenges[$j][1]
							EndIf
						Next
					Case "G"
						Local $GroundTroopChallenges = ClanGamesChallenges("$GroundTroopChallenges")
						For $j = 0 To UBound($GroundTroopChallenges) - 1
							; Match the names
							If $ActiveChallengeFullName[1] = $GroundTroopChallenges[$j][0] Then
								$CurrentActiveChallenge = $GroundTroopChallenges[$j][1]
							EndIf
						Next
					Case "B"
						Local $BattleChallenges = ClanGamesChallenges("$BattleChallenges")
						For $j = 0 To UBound($BattleChallenges) - 1
							; Match the names
							If $ActiveChallengeFullName[1] = $BattleChallenges[$j][0] Then
								$CurrentActiveChallenge = $BattleChallenges[$j][1]
							EndIf
						Next
					Case "D"
						Local $DestructionChallenges = ClanGamesChallenges("$DestructionChallenges")
						For $j = 0 To UBound($DestructionChallenges) - 1
							; Match the names
							If $ActiveChallengeFullName[1] = $DestructionChallenges[$j][0] Then
								$CurrentActiveChallenge = $DestructionChallenges[$j][1]
							EndIf
						Next
					Case "M"
						Local $MiscChallenges = ClanGamesChallenges("$MiscChallenges")
						For $j = 0 To UBound($MiscChallenges) - 1
							; Match the names
							If $ActiveChallengeFullName[1] = $MiscChallenges[$j][0] Then
								$CurrentActiveChallenge = $MiscChallenges[$j][1]
							EndIf
						Next
					Case "BBB" ; BB Battle challenges
						Local $BBBattleChallenges = ClanGamesChallenges("$BBBattleChallenges")
						For $j = 0 To UBound($BBBattleChallenges) - 1
							; Match the names
							If $ActiveChallengeFullName[1] = $BBBattleChallenges[$j][0] Then
								$CurrentActiveChallenge = $BBBattleChallenges[$j][1]
							EndIf
						Next
					Case "BBD" ; BB Destruction challenges
						Local $BBDestructionChallenges = ClanGamesChallenges("$BBDestructionChallenges")
						For $j = 0 To UBound($BBDestructionChallenges) - 1
							; Match the names
							If $ActiveChallengeFullName[1] = $BBDestructionChallenges[$j][0] Then
								$CurrentActiveChallenge = $BBDestructionChallenges[$j][1]
							EndIf
						Next
					Case "BBT" ; BB Troop challenges
						Local $BBTroopsChallenges = ClanGamesChallenges("$BBTroopsChallenges")
						For $j = 0 To UBound($BBTroopsChallenges) - 1
							; Match the names
							If $ActiveChallengeFullName[1] = $BBTroopsChallenges[$j][0] Then
								$CurrentActiveChallenge = $BBTroopsChallenges[$j][1]
							EndIf
						Next
				EndSwitch

				$IsCGEventRunning = 1

				;check if Challenge is BB Challenge, enabling force BB attack

				Click(340, 210 + $g_iMidOffsetY)
				If _Sleep(2000) Then Return
				SetLog("Re-Check Event Type", $COLOR_DEBUG1)
				If QuickMIS("BC1", $g_sImgVersus, 425, 180 + $g_iMidOffsetY, 700, 245 + $g_iMidOffsetY) And $CurrentActiveChallenge <> "Builder Hut" Then
					If $aActiveEvent[0][0] = "D-BBreakdown" Or $aActiveEvent[0][0] = "BBD-BuildingDes" Then
						SetDebugLog("Challenge with shared Image", $COLOR_DEBUG2)
						If $g_abCGBBDestructionItem[1] = 0 Or $g_bChkClanGamesBBDes = 0 Then
							$bNeedPurge = True ;BuildingDes
						Else
							$CurrentActiveChallenge = "BB Building"
						EndIf
					EndIf
					If $aActiveEvent[0][0] = "BBD-WallDes" Or $aActiveEvent[0][0] = "D-WallWhacker" Then
						SetDebugLog("Challenge with shared Image", $COLOR_DEBUG2)
						If $g_abCGBBDestructionItem[14] = 0 Or $g_bChkClanGamesBBDes = 0 Then
							$bNeedPurge = True ;Wall Wipe Out
						Else
							$CurrentActiveChallenge = "Wall WipeOut"
						EndIf
					EndIf
					If $aActiveEvent[0][0] = "A-BabyD" Or $aActiveEvent[0][0] = "BBT-BabyD" Then
						SetDebugLog("Challenge with shared Image", $COLOR_DEBUG2)
						If $g_abCGBBTroopsItem[5] = 0 Or $g_bChkClanGamesBBTroops = 0 Then
							$bNeedPurge = True ;BabyDrag
						Else
							$CurrentActiveChallenge = "Baby Dragon"
						EndIf
					EndIf
					Setlog("Running Challenge is BB Challenge : " & $CurrentActiveChallenge, $COLOR_ACTION)
					If $g_bChkClanGamesStopBeforeReachAndPurge Then
						Local $sTimeCG = ConvertOCRTime("ClanGames()", $g_sClanGamesTimeRemaining, False)
						If $sTimeCG > 1440 Then
							Local $Ocr = getOcrEventPoints(464, 287 + $g_iMidOffsetY)
							$Ocr = StringReplace($Ocr, " ", "", 0)
							$Ocr = StringReplace($Ocr, "#", "", 0)
							If _Sleep(2000) Then Return
							Local $aiScoreLimit = GetTimesAndScores(False)
							If $aiScoreLimit[0] + Number($Ocr) >= $aiScoreLimit[1] Then
								Setlog("This Challenge must be purged or you will reach max points!", $COLOR_INFO)
								$bNeedPurge = True
							EndIf
						EndIf
					EndIf
					If $bNeedPurge Then ;Purge BB event, Not Wanted
						Click(340, 210 + $g_iMidOffsetY)
						If _Sleep(2000) Then Return
						Setlog("Event started by mistake?", $COLOR_ERROR)
						PurgeEvent(False, False, False)
					Else
						$g_bIsBBevent = 1
					EndIf
				Else
					If $aActiveEvent[0][0] = "BBD-WallDes" Or $aActiveEvent[0][0] = "D-WallWhacker" Then
						SetDebugLog("Challenge with shared Image", $COLOR_DEBUG2)
						If $g_abCGMainDestructionItem[22] = 0 Or $g_bChkClanGamesDes = 0 Then
							$bNeedPurge = True ;WallWhacker
						Else
							$CurrentActiveChallenge = "Wall Whacker"
						EndIf
					EndIf
					If $aActiveEvent[0][0] = "BBD-BuildingDes" Or $aActiveEvent[0][0] = "D-BBreakdown" Then
						SetDebugLog("Challenge with shared Image", $COLOR_DEBUG2)
						If $g_abCGMainDestructionItem[23] = 0 Or $g_bChkClanGamesDes = 0 Then
							$bNeedPurge = True ;BBreakdown
						Else
							$CurrentActiveChallenge = "Building Breakdown"
						EndIf
					EndIf
					If $aActiveEvent[0][0] = "BBT-BabyD" Or $aActiveEvent[0][0] = "A-BabyD" Then
						SetDebugLog("Challenge with shared Image", $COLOR_DEBUG2)
						If $g_abCGMainAirItem[2] = 0 Or $g_bChkClanGamesAirTroop = 0 Then
							$bNeedPurge = True ;BabyDrag
						Else
							$CurrentActiveChallenge = "Baby Dragon"
						EndIf
					EndIf
					Setlog("Running Challenge is MainVillage Challenge : " & $CurrentActiveChallenge, $COLOR_ACTION)
					If $g_bChkClanGamesStopBeforeReachAndPurge Then
						Local $sTimeCG = ConvertOCRTime("ClanGames()", $g_sClanGamesTimeRemaining, False)
						If $sTimeCG > 1440 Then
							Local $Ocr = getOcrEventPoints(464, 287 + $g_iMidOffsetY)
							$Ocr = StringReplace($Ocr, " ", "", 0)
							$Ocr = StringReplace($Ocr, "#", "", 0)
							If _Sleep(2000) Then Return
							Local $aiScoreLimit = GetTimesAndScores(False)
							If $aiScoreLimit[0] + Number($Ocr) >= $aiScoreLimit[1] Then
								Setlog("This Challenge must be purged or you will reach max points!", $COLOR_INFO)
								$bNeedPurge = True
							EndIf
						EndIf
					EndIf
					If $bNeedPurge Then ;Purge Event, Not Wanted
						Click(340, 210 + $g_iMidOffsetY)
						If _Sleep(2000) Then Return
						Setlog("Challenge started by mistake?", $COLOR_ERROR)
						PurgeEvent(False, False, False)
					Else
						$g_bIsBBevent = 0
					EndIf
				EndIf
			Else
				Setlog("Active Challenge Not Enabled on Setting! started by mistake?", $COLOR_ERROR)
				If $g_bCGDebugEvents Then
					If _Sleep(1000) Then Return
					SaveDebugImage("CG_Mistake", True, True)
					If _Sleep(1000) Then Return
				EndIf
				PurgeEvent(False, False, False)
				CloseWindow()
				ClearTempCGFiles()
				Return True
			EndIf
			CloseWindow()
			ClearTempCGFiles()
			Return True
		EndIf
	Else
		SetLog("No challenge under progress", $COLOR_INFO)
		$IsCGEventRunning = 0
		Return False
	EndIf
	Return False
EndFunc   ;==>IsEventRunning

Func ClickOnEvent(ByRef $YourAccScore, $ScoreLimits, $sEventName, $getCapture)
	If Not $YourAccScore[$g_iCurAccount][1] Then
		Local $text = "", $color = $COLOR_SUCCESS
		If $YourAccScore[$g_iCurAccount][0] <> $ScoreLimits[0] Then
			$text = "You got " & $ScoreLimits[0] - $YourAccScore[$g_iCurAccount][0] & " points in last Challenge"
		Else
			$text = "You could not complete the last challenge!"
			$color = $COLOR_WARNING
		EndIf
		SetLog($text, $color)
		_FileWriteLog($g_sProfileLogsPath & "\ClanGames.log", " [" & $g_sProfileCurrentName & "] - " & $text)
	EndIf
	$YourAccScore[$g_iCurAccount][1] = False
	$YourAccScore[$g_iCurAccount][0] = $ScoreLimits[0]
	If $g_bChkClanGamesDebug Then SetLog("ClickOnEvent $YourAccScore[" & $g_iCurAccount & "][1]: " & $YourAccScore[$g_iCurAccount][1])
	If $g_bChkClanGamesDebug Then SetLog("ClickOnEvent $YourAccScore[" & $g_iCurAccount & "][0]: " & $YourAccScore[$g_iCurAccount][0])
	If Not StartsEvent($sEventName, $getCapture, $g_bChkClanGamesDebug) Then Return False
	CloseWindow()
	Return True
EndFunc   ;==>ClickOnEvent

Func StartsEvent($sEventName, $getCapture = True, $g_bChkClanGamesDebug = False)
	If Not $g_bRunState Then Return

	If QuickMIS("BC1", $g_sImgStart, 230, 120 + $g_iMidOffsetY, 840, 520 + $g_iMidOffsetY) Then
		Local $Timer = GetEventTimeInMinutes($g_iQuickMISX, $g_iQuickMISY)
		Local $sTimeCG = ConvertOCRTime("ClanGames()", $g_sClanGamesTimeRemaining, False)
		If $Timer > 0 Then
			SetLog("Starting Challenge" & " [" & $Timer & " min]", $COLOR_SUCCESS)
			Click($g_iQuickMISX, $g_iQuickMISY)
			GUICtrlSetData($g_hTxtClanGamesLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] - Starting " & $sEventName & " for " & $Timer & " min", 1)
			_FileWriteLog($g_sProfileLogsPath & "\ClanGames.log", " [" & $g_sProfileCurrentName & "] - Starting " & $sEventName & " for " & $Timer & " min")
		Else
			SetLog("Starting Event" & " [" & $sTimeCG & " min]", $COLOR_SUCCESS)
			Click($g_iQuickMISX, $g_iQuickMISY)
			GUICtrlSetData($g_hTxtClanGamesLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] - Starting " & $sEventName & " for " & $sTimeCG & " min", 1)
			_FileWriteLog($g_sProfileLogsPath & "\ClanGames.log", " [" & $g_sProfileCurrentName & "] - Starting " & $sEventName & " for " & $sTimeCG & " min")
		EndIf

		;check if Challenge is BB Challenge, enabling force BB attack
		Click(450, 90 + $g_iMidOffsetY) ;Click Clan Tab
		If _Sleep(3000) Then Return
		Click(320, 90 + $g_iMidOffsetY) ;Click Challenge Tab
		If _Sleep(500) Then Return
		Click(340, 210 + $g_iMidOffsetY) ;Click Active Challenge
		If _Sleep(1000) Then Return
		SetLog("Re-Check Event Type", $COLOR_DEBUG1)
		If QuickMIS("BC1", $g_sImgVersus, 425, 180 + $g_iMidOffsetY, 700, 245 + $g_iMidOffsetY, True, False) Then
			If $sEventName = "Builder Hut" Then
				Setlog("Running Challenge is MainVillage Challenge : " & $sEventName, $COLOR_ACTION)
				$g_bIsBBevent = 0
			Else
				Setlog("Running Challenge is BB Challenge : " & $sEventName, $COLOR_ACTION)
				$g_bIsBBevent = 1
			EndIf
		Else
			Setlog("Running Challenge is MainVillage Challenge : " & $sEventName, $COLOR_ACTION)
			$g_bIsBBevent = 0
			Local $LootChallenges = ClanGamesChallenges("$LootChallenges")
		EndIf
		$IsCGEventRunning = 1
		ClearTempCGFiles()
		Return True
	Else
		SetLog("Didn't Get the Green Start Button Challenge", $COLOR_WARNING)
		If $g_bChkClanGamesDebug Then SetLog("[X: " & 230 & " Y:" & 150 & " X1: " & 840 & " Y1: " & 550 & "]", $COLOR_WARNING)
		CloseWindow()
		ClearTempCGFiles()
		Return False
	EndIf

EndFunc   ;==>StartsEvent

Func PurgeUncheckedEvent($iRow = 1)

	ChallengeNextPage(1, $iRow)

	ClearTempCGFiles()
	If _Sleep(2000) Then Return

	; Initial Timer
	Local $hTimer = TimerInit()
	Local $sImagePath = @ScriptDir & "\imgxml\Resources\ClanGamesImages\Challenges"
	Local $sTempChallengePath = @TempDir & "\" & $g_sProfileCurrentName & "\Challenges\"
	Local $EventLoopOut = True
	Local $IsLooped = 0
	Local $IsSomethingWrong = False

	If ($g_bChkClanGamesLoot Or $g_bChkClanGamesBattle Or $g_bChkClanGamesDes Or $g_bChkClanGamesAirTroop Or $g_bChkClanGamesGroundTroop Or $g_bChkClanGamesMiscellaneous Or $g_bChkClanGamesSpell) And _
			Not $g_bChkClanGamesBBBattle And Not $g_bChkClanGamesBBDes And Not $g_bChkClanGamesBBTroops Then
		ClanGameImageCopy($sImagePath, $sTempChallengePath, "L") ;L for Loot
		ClanGameImageCopy($sImagePath, $sTempChallengePath, "B") ;B for Battle
		ClanGameImageCopy($sImagePath, $sTempChallengePath, "D") ;D for Destruction
		ClanGameImageCopy($sImagePath, $sTempChallengePath, "A")  ;A for AirTroops
		ClanGameImageCopy($sImagePath, $sTempChallengePath, "G") ;G for GroundTroops
		ClanGameImageCopy($sImagePath, $sTempChallengePath, "M") ;M for Misc
		ClanGameImageCopy($sImagePath, $sTempChallengePath, "S") ;S for GroundTroops
	ElseIf Not $g_bChkClanGamesLoot And Not $g_bChkClanGamesBattle And Not $g_bChkClanGamesDes And Not $g_bChkClanGamesAirTroop And Not $g_bChkClanGamesGroundTroop And Not $g_bChkClanGamesMiscellaneous And Not $g_bChkClanGamesSpell And _
			($g_bChkClanGamesBBBattle Or $g_bChkClanGamesBBDes Or $g_bChkClanGamesBBTroops) Then
		ClanGameImageCopy($sImagePath, $sTempChallengePath, "BBB") ;BBB for BB Battle
		ClanGameImageCopy($sImagePath, $sTempChallengePath, "BBD")  ;BBD for BB Destruction
		ClanGameImageCopy($sImagePath, $sTempChallengePath, "BBT") ;BBT for BB Troops
	Else
		Return False ; Will purge any event !
	EndIf

	While $EventLoopOut

		$EventLoopOut = False
		If $IsLooped > 0 Then $hTimer = TimerInit()

		Local $aAllDetectionsOnScreen2 = FindEventToPurge()
		$iRow = 2

		Local $aSelectChallenges[0][6]

		If UBound($aAllDetectionsOnScreen2) > 0 Then
			For $i = 0 To UBound($aAllDetectionsOnScreen2) - 1

				Switch $aAllDetectionsOnScreen2[$i][0]
					Case "L"
						Local $LootChallenges = ClanGamesChallenges("$LootChallenges")
						For $j = 0 To UBound($LootChallenges) - 1
							; Match the names
							If $aAllDetectionsOnScreen2[$i][1] = $LootChallenges[$j][0] Then
								; [0] Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] Difficulty, [4] CGMAIN/CGBB
								Local $aArray[6] = [$LootChallenges[$j][1], $aAllDetectionsOnScreen2[$i][2], $aAllDetectionsOnScreen2[$i][3], $LootChallenges[$j][3], $aAllDetectionsOnScreen2[$i][4], $aAllDetectionsOnScreen2[$i][6]]
							EndIf
						Next
					Case "A"
						Local $AirTroopChallenges = ClanGamesChallenges("$AirTroopChallenges")
						For $j = 0 To UBound($AirTroopChallenges) - 1
							; Match the names
							If $aAllDetectionsOnScreen2[$i][1] = $AirTroopChallenges[$j][0] Then
								; [0] Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] Difficulty, [4] CGMAIN/CGBB
								Local $aArray[6] = [$AirTroopChallenges[$j][1], $aAllDetectionsOnScreen2[$i][2], $aAllDetectionsOnScreen2[$i][3], $AirTroopChallenges[$j][3], $aAllDetectionsOnScreen2[$i][4], $aAllDetectionsOnScreen2[$i][6]]
							EndIf
						Next
					Case "S" ; - grumpy
						Local $SpellChallenges = ClanGamesChallenges("$SpellChallenges") ; load all spell challenges
						For $j = 0 To UBound($SpellChallenges) - 1 ; loop through all challenges
							; Match the names
							If $aAllDetectionsOnScreen2[$i][1] = $SpellChallenges[$j][0] Then
								; [0] Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] Difficulty, [4] CGMAIN/CGBB
								Local $aArray[6] = [$SpellChallenges[$j][1], $aAllDetectionsOnScreen2[$i][2], $aAllDetectionsOnScreen2[$i][3], $SpellChallenges[$j][3], $aAllDetectionsOnScreen2[$i][4], $aAllDetectionsOnScreen2[$i][6]]
							EndIf
						Next
					Case "G"
						Local $GroundTroopChallenges = ClanGamesChallenges("$GroundTroopChallenges")
						For $j = 0 To UBound($GroundTroopChallenges) - 1
							; Match the names
							If $aAllDetectionsOnScreen2[$i][1] = $GroundTroopChallenges[$j][0] Then
								; [0] Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] Difficulty, [4] CGMAIN/CGBB
								Local $aArray[6] = [$GroundTroopChallenges[$j][1], $aAllDetectionsOnScreen2[$i][2], $aAllDetectionsOnScreen2[$i][3], $GroundTroopChallenges[$j][3], $aAllDetectionsOnScreen2[$i][4], $aAllDetectionsOnScreen2[$i][6]]
							EndIf
						Next
					Case "B"
						Local $BattleChallenges = ClanGamesChallenges("$BattleChallenges")
						For $j = 0 To UBound($BattleChallenges) - 1
							; Match the names
							If $aAllDetectionsOnScreen2[$i][1] = $BattleChallenges[$j][0] Then
								; [0] Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] Difficulty, [4] CGMAIN/CGBB
								Local $aArray[6] = [$BattleChallenges[$j][1], $aAllDetectionsOnScreen2[$i][2], $aAllDetectionsOnScreen2[$i][3], $BattleChallenges[$j][3], $aAllDetectionsOnScreen2[$i][4], $aAllDetectionsOnScreen2[$i][6]]
							EndIf
						Next
					Case "D"
						Local $DestructionChallenges = ClanGamesChallenges("$DestructionChallenges")
						For $j = 0 To UBound($DestructionChallenges) - 1
							; Match the names
							If $aAllDetectionsOnScreen2[$i][1] = $DestructionChallenges[$j][0] Then
								; [0] Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] Difficulty, [4] CGMAIN/CGBB
								Local $aArray[6] = [$DestructionChallenges[$j][1], $aAllDetectionsOnScreen2[$i][2], $aAllDetectionsOnScreen2[$i][3], $DestructionChallenges[$j][3], $aAllDetectionsOnScreen2[$i][4], $aAllDetectionsOnScreen2[$i][6]]
							EndIf
						Next
					Case "M"
						Local $MiscChallenges = ClanGamesChallenges("$MiscChallenges")
						For $j = 0 To UBound($MiscChallenges) - 1
							; Match the names
							If $aAllDetectionsOnScreen2[$i][1] = $MiscChallenges[$j][0] Then
								; [0] Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] Difficulty, [4] CGMAIN/CGBB
								Local $aArray[6] = [$MiscChallenges[$j][1], $aAllDetectionsOnScreen2[$i][2], $aAllDetectionsOnScreen2[$i][3], $MiscChallenges[$j][3], $aAllDetectionsOnScreen2[$i][4], $aAllDetectionsOnScreen2[$i][6]]
							EndIf
						Next
					Case "BBB" ; BB Battle challenges
						Local $BBBattleChallenges = ClanGamesChallenges("$BBBattleChallenges")
						For $j = 0 To UBound($BBBattleChallenges) - 1
							; Match the names
							If $aAllDetectionsOnScreen2[$i][1] = $BBBattleChallenges[$j][0] Then
								; [0] Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] Difficulty, [4] CGMAIN/CGBB
								Local $aArray[6] = [$BBBattleChallenges[$j][1], $aAllDetectionsOnScreen2[$i][2], $aAllDetectionsOnScreen2[$i][3], $BBBattleChallenges[$j][3], $aAllDetectionsOnScreen2[$i][4], $aAllDetectionsOnScreen2[$i][6]]
							EndIf
						Next
					Case "BBD" ; BB Destruction challenges
						Local $BBDestructionChallenges = ClanGamesChallenges("$BBDestructionChallenges")
						For $j = 0 To UBound($BBDestructionChallenges) - 1
							; Match the names
							If $aAllDetectionsOnScreen2[$i][1] = $BBDestructionChallenges[$j][0] Then
								; [0] Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] Difficulty, [4] CGMAIN/CGBB
								Local $aArray[6] = [$BBDestructionChallenges[$j][1], $aAllDetectionsOnScreen2[$i][2], $aAllDetectionsOnScreen2[$i][3], $BBDestructionChallenges[$j][3], $aAllDetectionsOnScreen2[$i][4], $aAllDetectionsOnScreen2[$i][6]]
							EndIf
						Next
					Case "BBT" ; BB Troop challenges
						Local $BBTroopsChallenges = ClanGamesChallenges("$BBTroopsChallenges")
						For $j = 0 To UBound($BBTroopsChallenges) - 1
							; Match the names
							If $aAllDetectionsOnScreen2[$i][1] = $BBTroopsChallenges[$j][0] Then
								; [0] Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] Difficulty, [4] CGMAIN/CGBB
								Local $aArray[6] = [$BBTroopsChallenges[$j][1], $aAllDetectionsOnScreen2[$i][2], $aAllDetectionsOnScreen2[$i][3], $BBTroopsChallenges[$j][3], $aAllDetectionsOnScreen2[$i][4], $aAllDetectionsOnScreen2[$i][6]]
							EndIf
						Next
				EndSwitch
				If IsDeclared("aArray") And $aArray[0] <> "" Then
					ReDim $aSelectChallenges[UBound($aSelectChallenges) + 1][7]
					$aSelectChallenges[UBound($aSelectChallenges) - 1][0] = $aArray[0] ; Event Name Full Name
					$aSelectChallenges[UBound($aSelectChallenges) - 1][1] = $aArray[1] ; Xaxis
					$aSelectChallenges[UBound($aSelectChallenges) - 1][2] = $aArray[2] ; Yaxis
					$aSelectChallenges[UBound($aSelectChallenges) - 1][3] = $aArray[3] ; difficulty
					$aSelectChallenges[UBound($aSelectChallenges) - 1][4] = 0          ; timer minutes
					$aSelectChallenges[UBound($aSelectChallenges) - 1][5] = $aArray[4] ; EventType: MainVillage/BuilderBase
					$aSelectChallenges[UBound($aSelectChallenges) - 1][6] = $aArray[5] ; Challenge Page
					$aArray[0] = ""
				EndIf
			Next
		Else
			ChallengeNextPage(1, $iRow)
			Return False
		EndIf

		If $g_bChkClanGamesDebug Then Setlog("_ClanGames aAllDetectionsOnScreen2 (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds)", $COLOR_INFO)
		$hTimer = TimerInit()

		; Sort by Yaxis
		_ArraySort($aSelectChallenges, 1, 0, 0, 2)
		; Then Sort by Page
		_ArraySort($aSelectChallenges, 1, 0, 0, 6)

		If IsDeclared("aSelectChallenges") Then
			If UBound($aSelectChallenges) > 0 Then
				For $i = 0 To UBound($aSelectChallenges) - 1
					If Not $g_bRunState Then Return
					SetDebugLog("$aSelectChallenges: " & _ArrayToString($aSelectChallenges))
					Setlog("Purged Challenge will be " & $aSelectChallenges[$i][0])
					; Select and Start EVENT
					ChallengeNextPage($aSelectChallenges[$i][6], $iRow)
					If Not QuickMIS("BC1", $sTempChallengePath & "Purge\UnSelected\", $aSelectChallenges[$i][1] - 60, $aSelectChallenges[$i][2] - 60, $aSelectChallenges[$i][1] + 60, $aSelectChallenges[$i][2] + 60, True) Then
						SetLog($aSelectChallenges[$i][0] & " not found on previous location detected", $COLOR_ERROR)
						SetLog("Maybe challenge tile changed, Restart Search...", $COLOR_INFO)
						If _Sleep(2000) Then Return
						$EventLoopOut = True
						$IsLooped += 1
						If $IsLooped > 4 Then
							SetLog("Something went wrong, Come Back Here Later", $COLOR_ACTION)
							$IsSomethingWrong = True
							ExitLoop 2
						EndIf
						; Clear
						$aAllDetectionsOnScreen2 = ""
						$aSelectChallenges = ""
						ChallengeNextPage(1, $iRow)
						ContinueLoop 2
					EndIf
					Click($aSelectChallenges[$i][1], $aSelectChallenges[$i][2])
					If _Sleep(1500) Then Return
					If StartAndPurgeEvent(False) Then SetCGCoolDownTime()
					If _Sleep(1000) Then Return
					CloseWindow()
					ClearTempCGFiles()
					Return True
				Next
			EndIf
		EndIf

	WEnd

	If $IsSomethingWrong Then
		CloseWindow()
		ClearTempCGFiles()
		If _Sleep(2000) Then Return
		Return False
	EndIf

EndFunc   ;==>PurgeUncheckedEvent

Func FindEventToPurge()
	Local $hStarttime = _Timer_Init()
	Local $sImagePath = @ScriptDir & "\imgxml\Resources\ClanGamesImages\Challenges"
	Local $sTempChallengePath = @TempDir & "\" & $g_sProfileCurrentName & "\Challenges\Purge\"
	Local $aEvent, $aReturn[0][7]
	Local $iRow = 1
	Local $aX[4] = [284, 418, 550, 685]
	Local $aY[3] = [155 + $g_iMidOffsetY, 325 + $g_iMidOffsetY, 305 + $g_iMidOffsetY]

	For $y = 0 To UBound($aY) - 1
		If $y = UBound($aY) - 1 Then
			ChallengeNextPage(2, $iRow)
			If $g_bCGDebugEvents Then
				If _Sleep(1000) Then Return
				SaveDebugImage("CG_All_Challenges", True, True, "_P2 ")
				If _Sleep(1000) Then Return
			EndIf
		EndIf
		For $x = 0 To UBound($aX) - 1
			$aEvent = QuickMIS("CNX", $sTempChallengePath, $aX[$x], $aY[$y], $aX[$x] + 114, $aY[$y] + 130)
			If IsArray($aEvent) And UBound($aEvent) > 0 Then
				Local $IsBBEvent = IsBBChallenge($aEvent[0][1], $aEvent[0][2])
				If $IsBBEvent Then
					$IsBBEvent = "CGBB"
				Else
					$IsBBEvent = "CGMain"
				EndIf

				Local $ChallengeEvent = StringSplit($aEvent[0][0], "-", $STR_NOCOUNT)

				If $ChallengeEvent[0] = "D" And $IsBBEvent = "CGBB" Then
					Switch $aEvent[0][0]
						Case "D-BBreakdown"
							$ChallengeEvent[0] = "BBD"
							$ChallengeEvent[1] = "BuildingDes"
							$aEvent[0][0] = "BBD-BuildingDes"
						Case "D-WallWhacker"
							$ChallengeEvent[0] = "BBD"
							$ChallengeEvent[1] = "WallDes"
							$aEvent[0][0] = "BBD-WallDes"
					EndSwitch
				EndIf

				If $ChallengeEvent[0] = "BBD" And $IsBBEvent = "CGMain" Then
					Switch $aEvent[0][0]
						Case "BBD-BuildingDes"
							$ChallengeEvent[0] = "D"
							$ChallengeEvent[1] = "BBreakdown"
							$aEvent[0][0] = "D-BBreakdown"
						Case "BBD-WallDes"
							$ChallengeEvent[0] = "D"
							$ChallengeEvent[1] = "WallWhacker"
							$aEvent[0][0] = "D-WallWhacker"
					EndSwitch
				EndIf

				If $ChallengeEvent[0] = "A" And $IsBBEvent = "CGBB" Then
					If $aEvent[0][0] = "A-BabyD" Then
						$ChallengeEvent[0] = "BBT"
						$ChallengeEvent[1] = "BabyD"
						$aEvent[0][0] = "BBT-BabyD"
					EndIf
				EndIf

				If $ChallengeEvent[0] = "BBT" And $IsBBEvent = "CGMain" Then
					If $aEvent[0][0] = "BBT-BabyD" Then
						$ChallengeEvent[0] = "A"
						$ChallengeEvent[1] = "BabyD"
						$aEvent[0][0] = "A-BabyD"
					EndIf
				EndIf

				If $ChallengeEvent[0] = "D" And $IsBBEvent = "CGMain" Then
					If $aEvent[0][0] = "D-BBreakdown" And $g_abCGMainDestructionItem[23] = 1 Then ContinueLoop
					If $aEvent[0][0] = "D-WallWhacker" And $g_abCGMainDestructionItem[22] = 1 Then ContinueLoop
				EndIf
				If $ChallengeEvent[0] = "BBD" And $IsBBEvent = "CGBB" Then
					If $aEvent[0][0] = "BBD-WallDes" And $g_abCGBBDestructionItem[14] = 1 Then ContinueLoop
					If $aEvent[0][0] = "BBD-BuildingDes" And $g_abCGBBDestructionItem[1] = 1 Then ContinueLoop
				EndIf
				If $ChallengeEvent[0] = "A" And $IsBBEvent = "CGMain" Then
					If $aEvent[0][0] = "A-BabyD" And $g_abCGMainAirItem[2] = 1 Then ContinueLoop
				EndIf
				If $ChallengeEvent[0] = "BBT" And $IsBBEvent = "CGBB" Then
					If $aEvent[0][0] = "BBT-BabyD" And $g_abCGBBTroopsItem[5] = 1 Then ContinueLoop
				EndIf

				ClanGameImageCopy($sImagePath, $sTempChallengePath, "UnSelected", $aEvent[0][0])
				;Return Case(L, A, S, etc...), Event File Name, X, Y, IsBBEvent, Full File Event Name, Challenge Page
				_ArrayAdd($aReturn, $ChallengeEvent[0] & "|" & $ChallengeEvent[1] & "|" & $aEvent[0][1] & "|" & $aEvent[0][2] & "|" & $IsBBEvent & "|" & $aEvent[0][0] & "|" & $iRow)
			EndIf
		Next
	Next
	SetDebugLog("Benchmark FindEvent selection: " & StringFormat("%.2f", _Timer_Diff($hStarttime)) & "'ms", $COLOR_DEBUG)
	Return $aReturn
EndFunc   ;==>FindEventToPurge

Func PurgeEvent($bTest = False, $startFirst = True, $NoMistake = True, $iRow = 1, $NoOneFound = False)

	If $g_bCGDebugEvents And $NoMistake Then
		If $NoOneFound Then
			ChallengeNextPage(1, $iRow)
			If _Sleep(1000) Then Return
			SaveDebugImage("CG_No_Challenge", True, True, "_P1 ")
			If _Sleep(1000) Then Return
			ChallengeNextPage(2, $iRow)
			If _Sleep(1000) Then Return
			SaveDebugImage("CG_No_Challenge", True, True, "_P2 ")
			If _Sleep(1000) Then Return
		Else
			SaveDebugImage("CG_All_Challenges", True, True, "_Purge ")
			If _Sleep(1000) Then Return
		EndIf
	EndIf

	Local $XPurgeEvents[4] = [340, 475, 605, 745]
	Local $XEventPurge = $XPurgeEvents[Random(0, 3, 1)]
	Local $YPurgeEvents[2] = [230, 390]
	Local $YEventPurge = $YPurgeEvents[Random(0, 1, 1)]

	If $startFirst Then
		ChallengeNextPage(1, $iRow)
		If _Sleep(1000) Then Return
		Click($XEventPurge, $YEventPurge + $g_iMidOffsetY) ;Any Challenge
	Else
		Click(344, 230 + $g_iMidOffsetY)
	EndIf

	If _Sleep(1000) Then Return
	If $startFirst Then
		Local $sTimeCG
		$sTimeCG = ConvertOCRTime("ClanGames()", $g_sClanGamesTimeRemaining, False)
		If $sTimeCG > 1440 And $g_bChkClanGamesStopBeforeReachAndPurge Then
			SetLog("Start and Purge a Challenge", $COLOR_INFO)
		Else
			SetLog("No challenge Found, Start and Purge a Challenge", $COLOR_INFO)
		EndIf
		If StartAndPurgeEvent($bTest) Then
			If _Sleep(1000) Then Return
			SetCGCoolDownTime()
			CloseWindow()
			Return True
		EndIf
	Else
		SetLog("Purge a Wrong Challenge", $COLOR_INFO)
		If QuickMIS("BC1", $g_sImgTrashPurge, 235, 140 + $g_iMidOffsetY, 825, 540 + $g_iMidOffsetY, True, False) Then
			Click($g_iQuickMISX, $g_iQuickMISY)
			If _Sleep(1200) Then Return
			SetLog("Click Trash", $COLOR_INFO)
			If QuickMIS("BC1", $g_sImgOkayPurge, 480, 370 + $g_iMidOffsetY, 600, 455 + $g_iMidOffsetY, True, False) Then
				SetLog("Click OK", $COLOR_INFO)
				If $bTest Then Return
				Click($g_iQuickMISX, $g_iQuickMISY)
				If _Sleep(1500) Then Return
				GUICtrlSetData($g_hTxtClanGamesLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] - PurgeEvent: Purge a Wrong Challenge ", 1)
				_FileWriteLog($g_sProfileLogsPath & "\ClanGames.log", " [" & $g_sProfileCurrentName & "] - PurgeEvent: Purge a Wrong Challenge ")
				SetCGCoolDownTime()
				If _Sleep(1500) Then Return
			Else
				SetLog("$g_sImgOkayPurge Issue", $COLOR_ERROR)
				Return False
			EndIf
		Else
			SetLog("$g_sImgTrashPurge Issue", $COLOR_ERROR)
			Return False
		EndIf
	EndIf
	Return False
EndFunc   ;==>PurgeEvent

Func StartAndPurgeEvent($bTest = False)

	If QuickMIS("BC1", $g_sImgStart, 230, 120 + $g_iMidOffsetY, 840, 520 + $g_iMidOffsetY) Then
		SetLog("Starting Challenge", $COLOR_SUCCESS)
		Click($g_iQuickMISX, $g_iQuickMISY)
		If _Sleep(3000) Then Return
		If QuickMIS("BC1", $g_sImgTrashPurge, 235, 140 + $g_iMidOffsetY, 825, 540 + $g_iMidOffsetY, True, False) Then
			Click($g_iQuickMISX, $g_iQuickMISY)
			If _Sleep(3000) Then Return
			SetLog("Click Trash", $COLOR_INFO)
			If QuickMIS("BC1", $g_sImgOkayPurge, 480, 370 + $g_iMidOffsetY, 600, 455 + $g_iMidOffsetY, True, False) Then
				SetLog("Click OK", $COLOR_INFO)
				If $bTest Then Return
				Click($g_iQuickMISX, $g_iQuickMISY)
				SetLog("Start And Purge Any Challenge!", $COLOR_SUCCESS)
				GUICtrlSetData($g_hTxtClanGamesLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] - Start And Purge Any Challenge", 1)
				_FileWriteLog($g_sProfileLogsPath & "\ClanGames.log", " [" & $g_sProfileCurrentName & "] - Start And Purge Any Challenge")
			Else
				SetLog("$g_sImgOkayPurge Issue", $COLOR_ERROR)
				Return False
			EndIf
		Else
			SetLog("$g_sImgTrashPurge Issue", $COLOR_ERROR)
			Return False
		EndIf
	Else
		SetLog("$g_sImgStart Issue", $COLOR_ERROR)
		Return False
	EndIf
	If _Sleep(1500) Then Return
	Return True
EndFunc   ;==>StartAndPurgeEvent

Func TrashFailedEvent()
	;Look for the red cross on failed event
	If Not ClickB("EventFailed") Then
		SetLog("Could not find the failed challenge icon!", $COLOR_ERROR)
		Return False
	EndIf

	If _Sleep(1000) Then Return

	;Look for the red trash event Button and press it
	If Not ClickB("TrashEvent") Then
		SetLog("Could not find the trash challenge button!", $COLOR_ERROR)
		Return False
	EndIf

	If _Sleep(500) Then Return
	Return True
EndFunc   ;==>TrashFailedEvent

Func GetEventTimeInMinutes($iXStartBtn, $iYStartBtn, $bIsStartBtn = True)

	Local $XAxis = $iXStartBtn - 173 ; Related to Start Button
	Local $YAxis = $iYStartBtn + 7 ; Related to Start Button

	If Not $bIsStartBtn Then
		$XAxis = $iXStartBtn - 173 ; Related to Trash Button
		$YAxis = $iYStartBtn + 7 ; Related to Trash Button
	EndIf

	Local $Ocr = getOcrEventTime($XAxis, $YAxis)
	$Ocr = StringReplace($Ocr, " ", "", 0)
	$Ocr = StringReplace($Ocr, "#", "", 0)
	If $Ocr = "1" Or $Ocr = "11" Or $Ocr = "111" Then $Ocr = "1d"
	If $Ocr = "2" Or $Ocr = "21" Or $Ocr = "211" Then $Ocr = "2d"
	Return ConvertOCRTime("ClanGames()", $Ocr, False)
EndFunc   ;==>GetEventTimeInMinutes

Func EventPoints($iXStartBtn, $iYStartBtn, $bIsStartBtn = True)

	Local $XAxis = $iXStartBtn - 177 ; Related to Start Button
	Local $YAxis = $iYStartBtn - 32 ; Related to Start Button

	If Not $bIsStartBtn Then
		$XAxis = $iXStartBtn - 177 ; Related to Trash Button
		$YAxis = $iYStartBtn - 32 ; Related to Trash Button
	EndIf

	Local $Ocr = getOcrEventPoints($XAxis, $YAxis)
	$Ocr = StringReplace($Ocr, " ", "", 0)
	$Ocr = StringReplace($Ocr, "#", "", 0)
	Return $Ocr
EndFunc   ;==>EventPoints

Func GetEventInformation()
	If QuickMIS("BC1", $g_sImgStart, 230, 120 + $g_iMidOffsetY, 840, 520 + $g_iMidOffsetY) Then
		Return GetEventTimeInMinutes($g_iQuickMISX, $g_iQuickMISY)
	Else
		Return 0
	EndIf
EndFunc   ;==>GetEventInformation

Func GetEventPoints()
	If QuickMIS("BC1", $g_sImgStart, 230, 120 + $g_iMidOffsetY, 840, 520 + $g_iMidOffsetY) Then
		Return EventPoints($g_iQuickMISX, $g_iQuickMISY)
	Else
		Return 0
	EndIf
EndFunc   ;==>GetEventPoints

Func IsBBChallenge($i = Default, $j = Default)

	Local $BorderX[4] = [284, 418, 552, 686]
	Local $BorderY[2] = [215 + $g_iMidOffsetY, 380 + $g_iMidOffsetY]
	Local $iColumn, $iRow, $bReturn

	Switch $i
		Case $BorderX[0] To $BorderX[1]
			$iColumn = 1
		Case $BorderX[1] To $BorderX[2]
			$iColumn = 2
		Case $BorderX[2] To $BorderX[3]
			$iColumn = 3
		Case Else
			$iColumn = 4
	EndSwitch

	Switch $j
		Case $BorderY[0] - 50 To $BorderY[1] - 70
			$iRow = 1
		Case Else
			$iRow = 2
	EndSwitch
	If $g_bChkClanGamesDebug Then SetLog("Row: " & $iRow & ", Column : " & $iColumn, $COLOR_DEBUG)
	For $y = 0 To 1
		For $x = 0 To 3
			If $iRow = ($y + 1) And $iColumn = ($x + 1) Then
				;Search image border, our image is MainVillage event border, so If found return False
				If QuickMIS("BC1", $g_sImgBorder, $BorderX[$x] - 15, $BorderY[$y] - 20, $BorderX[$x] + 15, $BorderY[$y] + 10, True, False) Then
					If $g_bChkClanGamesDebug Then SetLog("IsBBChallenge = False", $COLOR_ERROR)
					Return False
				Else
					If $g_bChkClanGamesDebug Then SetLog("IsBBChallenge = True", $COLOR_INFO)
					Return True
				EndIf
			EndIf
		Next
	Next

EndFunc   ;==>IsBBChallenge

Func ClanGamesChallenges($sReturnArray)

	;[0]=ImageName
	;[1]=Challenge Name
	;[2]=THlevel
	;[3]=Difficulty
	;[4]=Description

	Local $LootChallenges[6][5] = [ _
			["GoldChallenge", "Gold Challenge", 7, 6, "Loot certain amount of Gold from a single Multiplayer Battle"], _
			["ElixirChallenge", "Elixir Challenge", 7, 6, "Loot certain amount of Elixir from a single Multiplayer Battle"], _
			["DarkEChallenge", "Dark Elixir Challenge", 8, 6, "Loot certain amount of Dark elixir from a single Multiplayer Battle"], _
			["GoldGrab", "Gold Grab", 6, 1, "Loot a total amount of Gold (accumulated from many attacks) from Multiplayer Battle"], _
			["ElixirEmbezz", "Elixir Embezzlement", 6, 1, "Loot a total amount of Elixir (accumulated from many attacks) from Multiplayer Battle"], _
			["DarkEHeist", "Dark Elixir Heist", 9, 1, "Loot a total amount of Dark Elixir (accumulated from many attacks) from Multiplayer Battle"]]

	Local $BattleChallenges[22][5] = [ _
			["Start", "Star Collector", 6, 1, "Collect a total amount of Stars (accumulated from many attacks) from Multiplayer Battle"], _
			["Destruction", "Lord of Destruction", 6, 1, "Collect a total amount of percentage Destruction % (accumulated from many attacks) from Multiplayer Battle"], _
			["PileOfVictores", "Pile Of Victories", 6, 2, "Win 1-5 Multiplayer Battles"], _
			["StarThree", "Hunt for Three Stars", 10, 8, "Score a Perfect 3 Stars in Multiplayer Battles"], _
			["WinningStreak", "Winning Streak", 9, 8, "Win 1-5 Multiplayer Battles in a row"], _
			["SlayingTitans", "Slaying The Titans", 11, 1, "Win a Multiplayer Battles In Titan League"], _
			["NoHero", "No Heroics Allowed", 3, 5, "Win a stars without using Heroes"], _
			["NoMagic", "No-Magic Zone", 6, 5, "Win a stars without using Spells"], _
			["Scrappy6s", "Scrappy 6s", 6, 4, "Gain 3 Stars Against Town Hall level 6"], _
			["Super7s", "Super 7s", 7, 4, "Gain 3 Stars Against Town Hall level 7"], _
			["Exciting8s", "Exciting 8s", 8, 4, "Gain 3 Stars Against Town Hall level 8"], _
			["Noble9s", "Noble 9s", 9, 4, "Gain 3 Stars Against Town Hall level 9"], _
			["Terrific10s", "Terrific 10s", 10, 4, "Gain 3 Stars Against Town Hall level 10"], _
			["Exotic11s", "Exotic 11s", 11, 4, "Gain 3 Stars Against Town Hall level 11"], _
			["Triumphant12s", "Triumphant 12s", 12, 4, "Gain 3 Stars Against Town Hall level 12"], _
			["Tremendous13s", "Tremendous 13s", 13, 4, "Gain 3 Stars Against Town Hall level 13"], _
			["Formidable14s", "Formidable 14s", 14, 4, "Gain 3 Stars Against Town Hall level 14"], _
			["AttackUp", "Attack Up", 6, 8, "Gain 3 Stars Against Town Hall a level higher"], _
			["ClashOfLegends", "Clash of Legends", 11, 1, "Win a Multiplayer Battles In Legend League"], _
			["GainStarsFromClanWars", "3 Stars From Clan War", 6, 99, "Gain 3 Stars on Clan War"], _
			["SpeedyStars", "3 Stars in 60 seconds", 6, 2, "Gain 3 Stars (accumulated from many attacks) from Multiplayer Battle but only stars gained below a minute counted"], _
			["SuperCharge", "Deploy SuperTroops", 6, 0, "Deploy certain housing space of Any Super Troops"]]

	Local $DestructionChallenges[34][5] = [ _
			["Cannon", "Cannon", 6, 1, "Destroy 5-25 Cannons in Multiplayer Battles"], _
			["ArcherT", "Archer Tower", 6, 1, "Destroy 5-20 Archer Towers in Multiplayer Battles"], _
			["BuilderHut", "Builder Hut", 6, 1, "Destroy 4-12 BuilderHut in Multiplayer Battles"], _
			["Mortar", "Mortar", 6, 2, "Destroy 4-12 Mortars in Multiplayer Battles"], _
			["AirD", "Air Defenses", 7, 3, "Destroy 3-12 Air Defenses in Multiplayer Battles"], _
			["WizardT", "Wizard Tower", 6, 3, "Destroy 4-12 Wizard Towers in Multiplayer Battles"], _
			["AirSweepers", "Air Sweepers", 8, 3, "Destroy 2-6 Air Sweepers in Multiplayer Battles"], _
			["Tesla", "Tesla Towers", 7, 3, "Destroy 4-12 Hidden Teslas in Multiplayer Battles"], _
			["BombT", "Bomb Towers", 8, 3, "Destroy 2 Bomb Towers in Multiplayer Battles"], _
			["Xbow", "X-Bows", 9, 4, "Destroy 3-12 X-Bows in Multiplayer Battles"], _
			["Inferno", "Inferno Towers", 11, 4, "Destroy 2 Inferno Towers in Multiplayer Battles"], _
			["EagleA", "Eagle Artillery", 11, 5, "Destroy 1-7 Eagle Artillery in Multiplayer Battles"], _
			["ClanC", "Clan Castle", 5, 3, "Destroy 1-4 Clan Castle in Multiplayer Battles"], _
			["GoldSRaid", "Gold Storage", 6, 3, "Destroy 3-15 Gold Storages in Multiplayer Battles"], _
			["ElixirSRaid", "Elixir Storage", 6, 3, "Destroy 3-15 Elixir Storages in Multiplayer Battles"], _
			["DarkEStorageRaid", "Dark Elixir Storage", 8, 3, "Destroy 1-4 Dark Elixir Storage in Multiplayer Battles"], _
			["GoldM", "Gold Mine", 6, 1, "Destroy 6-20 Gold Mines in Multiplayer Battles"], _
			["ElixirPump", "Elixir Pump", 6, 1, "Destroy 6-20 Elixir Collectors in Multiplayer Battles"], _
			["DarkEPlumbers", "Dark Elixir Drill", 6, 1, "Destroy 2-8 Dark Elixir Drills in Multiplayer Battles"], _
			["Laboratory", "Laboratory", 6, 1, "Destroy 2-6 Laboratories in Multiplayer Battles"], _
			["SFacto", "Spell Factory", 6, 1, "Destroy 2-6 Spell Factories in Multiplayer Battles"], _
			["DESpell", "Dark Spell Factory", 8, 1, "Destroy 2-6 Dark Spell Factories in Multiplayer Battles"], _
			["WallWhacker", "Wall Whacker", 10, 8, "Destroy 50-250 Walls in Multiplayer Battles"], _
			["BBreakdown", "Building Breakdown", 6, 1, "Destroy 50-250 Buildings in Multiplayer Battles"], _
			["BKaltar", "Barbarian King Altars", 9, 3, "Destroy 2-5 Barbarian King Altars in Multiplayer Battles"], _
			["AQaltar", "Archer Queen Altars", 10, 3, "Destroy 2-5 Archer Queen Altars in Multiplayer Battles"], _
			["GWaltar", "Grand Warden Altars", 11, 3, "Destroy 2-5 Grand Warden Altars in Multiplayer Battles"], _
			["HeroLevelHunter", "Hero Level Hunter", 9, 4, "Knockout 125 Level Heroes on Multiplayer Battles"], _
			["KingLevelHunter", "King Level Hunter", 9, 3, "Knockout 50 Level King on Multiplayer Battles"], _
			["QueenLevelHunt", "Queen Level Hunter", 10, 3, "Knockout 50 Level Queen on Multiplayer Battles"], _
			["WardenLevelHunter", "Warden Level Hunter", 11, 3, "Knockout 20 Level Warden on Multiplayer Battles"], _
			["ArmyCamp", "Destroy ArmyCamp", 6, 1, "Destroy 3-16 Army Camp in Multiplayer Battles"], _
			["ScatterShotSabotage", "ScatterShot", 13, 5, "Destroy 1-4 ScatterShot in Multiplayer Battles"], _
			["ChampionLevelHunt", "Champion Level Hunter", 13, 3, "Knockout 20 Level Champion on Multiplayer Battles"]]

	Local $AirTroopChallenges[13][5] = [ _
			["Ball", "Balloon", 4, 1, "Earn 1-5 Stars (accumulated from many attacks) from Multiplayer Battles using certain count of Balloons"], _
			["Drag", "Dragon", 7, 1, "Earn 1-5 Stars (accumulated from many attacks) from Multiplayer Battles using certain count of Dragons"], _
			["BabyD", "Baby Dragon", 9, 1, "Earn 1-5 Stars (accumulated from many attacks) from Multiplayer Battles using certain count of Baby Dragons"], _
			["Edrag", "Electro Dragon", 10, 1, "Earn 1-5 Stars (accumulated from many attacks) from Multiplayer Battles using certain count of Electro Dragon"], _
			["RDrag", "Dragon Rider", 10, 1, "Earn 1-5 Stars (accumulated from many attacks) from Multiplayer Battles using certain count of Dragon Rider"], _
			["Mini", "Minion", 7, 1, "Earn 1-5 Stars (accumulated from many attacks) from Multiplayer Battles using certain count of Minions"], _
			["Lava", "Lavahound", 9, 1, "Earn 1-5 Stars (accumulated from many attacks) from Multiplayer Battles using certain count of Lava Hounds"], _
			["RBall", "Rocket Balloon", 12, 1, "Earn 1-5 Stars (accumulated from many attacks) from Multiplayer Battles using certain count of Rocket Balloon"], _
			["Smini", "Super Minion", 12, 1, "Earn 1-5 Stars (accumulated from many attacks) from Multiplayer Battles using certain count of Super Minion"], _
			["InfernoD", "Inferno Dragon", 12, 1, "Earn 1-5 Stars (accumulated from many attacks) from Multiplayer Battles using certain count of Inferno Dragon"], _
			["IceH", "Ice Hound", 12, 1, "Earn 1-5 Stars (accumulated from many attacks) from Multiplayer Battles using certain count of Ice Hound"], _
			["BattleB", "Battle Blimp", 10, 1, "Earn 1-5 Stars (accumulated from many attacks) from Multiplayer Battles using a of Battle Blimp"], _
			["StoneS", "Stone Slammer", 10, 1, "Earn 1-5 Stars (accumulated from many attacks) from Multiplayer Battles using a of Stone Slammer"]]

	Local $GroundTroopChallenges[29][5] = [ _
			["Arch", "Archer", 6, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Archers"], _
			["Barb", "Barbarian", 6, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Barbarians"], _
			["Giant", "Giant", 6, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Giants"], _
			["Gobl", "Goblin", 2, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Goblins"], _
			["Wall", "WallBreaker", 6, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Wall Breakers"], _
			["Wiza", "Wizard", 5, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Wizards"], _
			["Heal", "Healer", 4, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Healer"], _
			["Hogs", "HogRider", 7, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Hog Riders"], _
			["Mine", "Miner", 10, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Miners"], _
			["Pekk", "Pekka", 8, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Pekka"], _
			["Witc", "Witch", 9, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Witches"], _
			["Bowl", "Bowler", 10, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Bowlers"], _
			["Valk", "Valkyrie", 8, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Valkyries"], _
			["Gole", "Golem", 8, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Golems"], _
			["Yeti", "Yeti", 12, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Yeti"], _
			["IceG", "IceGolem", 11, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Ice Golem"], _
			["Hunt", "HeadHunters", 12, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Head Hunters"], _
			["Sbarb", "SuperBarbarian", 11, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Super Barbarian"], _
			["Sarch", "SuperArcher", 11, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Super Archer"], _
			["Sgiant", "SuperGiant", 12, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Super Giant"], _
			["Sgobl", "SneakyGoblin", 11, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Super Goblin"], _
			["Swall", "SuperWallBreaker", 11, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Super Wall Breaker"], _
			["Swiza", "SuperWizard", 12, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Super Wizard"], _
			["Svalk", "SuperValkyrie", 12, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Super Valkyrie"], _
			["Switc", "SuperWitch", 12, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Super Witch"], _
			["Sbowl", "SuperBowler", 12, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Super Bowler"], _
			["WallW", "Wall Wrecker", 10, 1, "Earn 1-5 Stars from Multiplayer Battles using a Wall Wrecker"], _
			["SiegeB", "Siege Barrack", 10, 1, "Earn 1-5 Stars from Multiplayer Battles using a Siege Barracks"], _
			["LogL", "Log Launcher", 10, 1, "Earn 1-5 Stars from Multiplayer Battles using a Log Launcher"]]

	Local $MiscChallenges[3][5] = [ _
			["Gard", "Gardening Exercise", 6, 8, "Clear 5 obstacles from your Home Village or Builder Base"], _
			["DonateSpell", "Donate Spells", 9, 8, "Donate a total of 3 spells"], _
			["DonateTroop", "Helping Hand", 6, 8, "Donate a total of 45 housing space worth of troops"]]

	Local $SpellChallenges[12][5] = [ _
			["LSpell", "Lightning", 6, 1, "Use certain amount of Lightning Spell to Win a Stars in Multiplayer Battles"], _
			["HSpell", "Heal", 6, 1, "Use certain amount of Heal Spell to Win a Stars in Multiplayer Battles"], _
			["RSpell", "Rage", 6, 1, "Use certain amount of Rage Spell to Win a Stars in Multiplayer Battles"], _
			["JSpell", "Jump", 6, 1, "Use certain amount of Jump Spell to Win a Stars in Multiplayer Battles"], _
			["FSpell", "Freeze", 9, 1, "Use certain amount of Freeze Spell to Win a Stars in Multiplayer Battles"], _
			["CSpell", "Clone", 11, 1, "Use certain amount of Clone Spell to Win a Stars in Multiplayer Battles"], _
			["ISpell", "Invisibility", 11, 1, "Use certain amount of Invisibility Spell to Win a Stars in Multiplayer Battles"], _
			["PSpell", "Poison", 6, 1, "Use certain amount of Poison Spell to Win a Stars in Multiplayer Battles"], _
			["ESpell", "Earthquake", 6, 1, "Use certain amount of Earthquake Spell to Win a Stars in Multiplayer Battles"], _
			["HaSpell", "Haste", 6, 1, "Use certain amount of Haste Spell to Win a Stars in Multiplayer Battles"], _
			["SkSpell", "Skeleton", 11, 1, "Use certain amount of Skeleton Spell to Win a Stars in Multiplayer Battles"], _
			["BtSpell", "Bat", 10, 1, "Use certain amount of Bat Spell to Win a Stars in Multiplayer Battles"]]

	Local $BBBattleChallenges[4][5] = [ _
			["StarM", "BB Star Master", 6, 1, "Collect certain amount of stars in Versus Battles"], _
			["Victories", "BB Victories", 6, 3, "Get certain count of Victories in Versus Battles"], _
			["StarTimed", "BB Star Timed", 6, 2, "Earn stars in Versus Battles, but only stars gained below a minute counted"], _
			["Destruction", "BB Destruction", 6, 1, "Earn certain amount of destruction percentage (%) in Versus Battles"]]

	Local $BBDestructionChallenges[21][5] = [ _
			["Airbomb", "Air Bomb", 6, 4, "Destroy certain number of Air Bomb in Versus Battles"], _
			["BuildingDes", "BB Building", 6, 4, "Destroy certain number of Building in Versus Battles"], _
			["BuilderHall", "BuilderHall", 6, 2, "Destroy certain number of Builder Hall in Versus Battles"], _
			["Cannon", "BB Cannon", 6, 1, "Destroy certain number of Cannon in Versus Battles"], _
			["ClockTower", "Clock Tower", 6, 1, "Destroy certain number of Clock Tower in Versus Battles"], _
			["DoubleCannon", "Double Cannon", 6, 1, "Destroy certain number of Double Cannon in Versus Battles"], _
			["FireCrackers", "Fire Crackers", 6, 2, "Destroy certain number of Fire Crackers in Versus Battles"], _
			["GemMine", "Gem Mine", 6, 1, "Destroy certain number of Gem Mine in Versus Battles"], _
			["GiantCannon", "Giant Cannon", 6, 5, "Destroy certain number of Giant Cannon in Versus Battles"], _
			["GuardPost", "Guard Post", 6, 3, "Destroy certain number of Guard Post in Versus Battles"], _
			["MegaTesla", "Mega Tesla", 6, 4, "Destroy certain number of Mega Tesla in Versus Battles"], _
			["MultiMortar", "Multi Mortar", 6, 2, "Destroy certain number of Multi Mortar in Versus Battles"], _
			["Roaster", "Roaster", 6, 4, "Destroy certain number of Roaster in Versus Battles"], _
			["StarLab", "Star Laboratory", 6, 1, "Destroy certain number of Star Laboratory in Versus Battles"], _
			["WallDes", "Wall WipeOut", 6, 5, "Destroy certain number of Wall in Versus Battles"], _
			["Crusher", "Crusher", 6, 2, "Destroy certain number of Crusher in Versus Battles"], _
			["ArcherTower", "Archer Tower", 6, 1, "Destroy certain number of Archer Tower in Versus Battles"], _
			["LavaLauncher", "Lava Launcher", 11, 5, "Destroy certain number of Lava Launcher in Versus Battles"], _
			["OttoOutpost", "Otto OutPost", 6, 7, "Destroy certain number of Otto OutPost in Builder Battle"], _
			["Xbow", "Xbow Explosion", 12, 7, "Destroy certain number of X-Bows in Builder Battle"], _
			["HealingHut", "Healing Hut", 6, 7, "Destroy certain number of Healing Hut in Builder Battle"]]

	Local $BBTroopsChallenges[12][5] = [ _
			["RBarb", "Raged Barbarian", 6, 1, "Win 1-5 Attacks using Raged Barbarians in Versus Battle"], _
			["SArch", "Sneaky Archer", 6, 1, "Win 1-5 Attacks using Sneaky Archer in Versus Battle"], _
			["BGiant", "Boxer Giant", 6, 1, "Win 1-5 Attacks using Boxer Giant in Versus Battle"], _
			["BMini", "Beta Minion", 6, 1, "Win 1-5 Attacks using Beta Minion in Versus Battle"], _
			["Bomber", "Bomber", 6, 1, "Win 1-5 Attacks using Bomber in Versus Battle"], _
			["BabyD", "Baby Dragon", 6, 1, "Win 1-5 Attacks using Baby Dragon in Versus Battle"], _
			["CannCart", "Cannon Cart", 6, 1, "Win 1-5 Attacks using Cannon Cart in Versus Battle"], _
			["NWitch", "Night Witch", 6, 1, "Win 1-5 Attacks using Night Witch in Versus Battle"], _
			["DShip", "Drop Ship", 6, 1, "Win 1-5 Attacks using Drop Ship in Versus Battle"], _
			["SPekka", "Super Pekka", 6, 1, "Win 1-5 Attacks using Super Pekka in Versus Battle"], _
			["HGlider", "Hog Glider", 10, 1, "Win 1-5 Attacks using Hog Glider in Versus Battle"], _
			["EFWiza", "ElectroFire Wizard", 12, 1, "Win 1-5 Attacks using ElectroFire Wizard in Versus Battle"]]

	Switch $sReturnArray
		Case "$LootChallenges"
			Return $LootChallenges
		Case "$BattleChallenges"
			Return $BattleChallenges
		Case "$DestructionChallenges"
			Return $DestructionChallenges
		Case "$AirTroopChallenges"
			Return $AirTroopChallenges
		Case "$GroundTroopChallenges"
			Return $GroundTroopChallenges
		Case "$MiscChallenges"
			Return $MiscChallenges
		Case "$SpellChallenges"
			Return $SpellChallenges
		Case "$BBBattleChallenges"
			Return $BBBattleChallenges
		Case "$BBDestructionChallenges"
			Return $BBDestructionChallenges
		Case "$BBTroopsChallenges"
			Return $BBTroopsChallenges
	EndSwitch

EndFunc   ;==>ClanGamesChallenges

Func CollectClanGamesRewards($bTest = False)
	If Not $g_bChkClanGamesCollectRewards Then
		SetLog("Clan Games collect rewards disable!", $COLOR_DEBUG)
		Return False
	EndIf

	Local $aRewardsList[41][2] = [ _  ; books-1, gems-2, runes-3, shovel-4,  50gems-5, wall rings-6, full wall - 7, all other Pots - 8, 10gems - 9
			["BookOfEverything", 10], _
			["BookOfHero", 10], _
			["BookOfFighting", 10], _
			["BookOfBuilding", 10], _
			["BookOfSpell", 10], _
			["Gems", 20], _
			["RuneOfGold", 30], _
			["RuneOfElixir", 30], _
			["RuneOfDarkElixir", 30], _
			["RuneOfBuilderGold", 30], _
			["RuneOfBuilderElixir", 30], _
			["Shovel", 40], _
			["FullBookOfEverything", 50], _ ; 50 gems
			["FullBookOfHero", 50], _        ; 50 gems
			["FullBookOfFighting", 50], _    ; 50 gems
			["FullBookOfBuilding", 50], _    ; 50 gems
			["FullBookOfSpell", 50], _        ; 50 gems
			["FullRuneOfGold", 60], _        ; 50 gems
			["FullRuneOfElixir", 60], _    ; 50 gems
			["FullRuneOfDarkElixir", 60], _ ; 50 gems
			["FullRuneOfBuilderGold", 60], _ ; 50 gems
			["FullRuneOfBuilderElixir", 60], _ ; 50 gems
			["FullShovel", 70], _            ; 50 gems
			["FullWallRing", 70], _        ; ? gem
			["WallRing", 70], _
			["PotBuilder", 80], _
			["PotResearch", 80], _
			["PotClock", 80], _
			["PotBoost", 80], _
			["PotHero", 80], _
			["PotResources", 80], _
			["PotPower", 80], _
			["PotSuper", 80], _
			["FullPotBuilder", 90], _        ; 10 gems
			["FullPotResearch", 90], _        ; 10 gems
			["FullPotClock", 90], _        ; 10 gems
			["FullPotBoost", 90], _        ; 10 gems
			["FullPotHero", 90], _            ; 10 gems
			["FullPotResources", 90], _    ; 10 gems
			["FullPotPower", 90], _        ; 10 gems
			["FullPotSuper", 90]]          ; 10 gems

	Local $aiColumn[4] = [276, 246, 348, 453]
	Local $aColWinOffColors[1][3] = [[0xD2D259, 2, 0]]
	Local $aFirstColumn = _MultiPixelSearch(260, 205 + $g_iMidOffsetY, 290, 205 + $g_iMidOffsetY, 1, 1, Hex(0xD2D259, 6), $aColWinOffColors, 10)
	If IsArray($aFirstColumn) And $aFirstColumn[0] < 270 Then
		$aiColumn[0] = $aFirstColumn[0] - 2
		$aiColumn[2] = $aiColumn[0] + 73
	EndIf
	Local $iColumnWidth = 92
	Local $sImgClanGamesReceivedWindow = @ScriptDir & "\imgxml\Windows\ClanGamesReceivedWindow*"
	Local $sImgClanGamesRewardsTab = @ScriptDir & "\imgxml\Windows\ClanGamesRewardsTab*"
	Local $sImgClanGamesExtraRewardWindow = @ScriptDir & "\imgxml\Windows\ClanGamesExtraRewardWindow*"

	If Not IsWindowOpen($sImgClanGamesRewardsTab, 30, 200, GetDiamondFromRect("400,140,700,200")) Then
		SetLog("Failed to verify Rewards Window!")
		Return False
	EndIf

	If $g_bDebugImageSave Then SaveDebugImage("ClanGamesRewardsWindow", False)

	Local $sIniPath = $g_sProfilePath & "\" & $g_sProfileCurrentName & "\ClanGamesRewards.ini"
	Local $ResultIni

	Setlog(" - Ini Path: " & $sIniPath)

	If Not FileExists($sIniPath) Then
		; Write INI File
		Local $File = FileOpen($sIniPath, $FO_APPEND)
		Local $HelpText = "; - MyBotRun - Clan Games Rewards Priority List 2023 - " & @CRLF & _
				"; - 'Reward' = 'Priority' [1 to 99][highest to lowest] , if grouped then random from group" & @CRLF & _
				"; - Do not change any Reward name" & @CRLF & _
				"; - Deleting this file will restore the default values." & @CRLF & @CRLF
		FileWrite($File, $HelpText)
		FileClose($File)

		For $j = 0 To UBound($aRewardsList) - 1
			IniWrite($sIniPath, "Rewards", $aRewardsList[$j][0], $aRewardsList[$j][1])
			SetLog($aRewardsList[$j][0] & " - " & $aRewardsList[$j][1])
			If _sleep(50) Then Return
		Next
	Else
		For $j = 0 To UBound($aRewardsList) - 1
			$ResultIni = Int(IniRead($sIniPath, "Rewards", $aRewardsList[$j][0], $aRewardsList[$j][1]))
			$aRewardsList[$j][1] = Number($ResultIni)
			SetLog($aRewardsList[$j][0] & " - " & $aRewardsList[$j][1] & " Result " & $ResultIni)
			If _sleep(50) Then Return
			$ResultIni = ""
		Next
	EndIf

	Local $i = 0
	Local $bLoop = True
	Local $aCollectRewardsButton

	While $bLoop
		SetLog("Column :" & $i)

		DragRewardColumnIfNeeded($i)

		If $bTest Then SaveDebugRectImage("CGRewardSearch", $aiColumn[0] & "," & $aiColumn[1] & "," & $aiColumn[2] & "," & $aiColumn[3])

		Local $avRewards = SearchColumn($aiColumn, $aRewardsList)

		If Not IsArray($avRewards) Or UBound($avRewards, $UBOUND_ROWS) < 1 Then
			SetLog("No rewards found in column :" & $i, $COLOR_WARNING)
		Else
			DebugClanGamesRewards($avRewards, $i)

			; get Coord of top reward
			Local $iX = $avRewards[0][1]
			Local $iY = $avRewards[0][2]

			If Not SelectReward($iX, $iY) Then Return
		EndIf

		If _Sleep(250) Then Return

		; look for collect reward button
		$aCollectRewardsButton = findButton("ClanGamesCollectRewards", Default, 1, True)

		If IsArray($aCollectRewardsButton) And UBound($aCollectRewardsButton, 1) = 2 Then
			If _Sleep(250) Then Return
			SetLog("Found Collect Rewards Button")

			If $bTest = True Then Return True

			ClickP($aCollectRewardsButton)

			; wait for animations
			If _Sleep(2500) Then Return

			; check for bonus rewards - grey claim reward
			If IsWindowOpen($sImgClanGamesExtraRewardWindow, 10, 200, GetDiamondFromRect("630,480,790,520")) Then

				Local $avRewards = SearchColumn($aiColumn, $aRewardsList)

				If Not IsArray($avRewards) Or UBound($avRewards, $UBOUND_ROWS) < 1 Then
					SetLog("No rewards found in BOUNS column :" & $i, $COLOR_WARNING)
				Else
					DebugClanGamesRewards($avRewards, "Bonus")

					Local $iX = $avRewards[0][1]
					Local $iY = $avRewards[0][2]

					If Not SelectReward($iX, $iY) Then Return
				EndIf

				If _Sleep(1000) Then Return

				; claim bonus reward
				Local $aClaimRewardButton = findButton("ClanGamesClaimReward", Default, 1, True)

				If IsArray($aClaimRewardButton) And UBound($aClaimRewardButton, 1) = 2 Then
					If _Sleep(250) Then Return
					SetLog("Found Claim Rewards Button")

					ClickP($aClaimRewardButton)

					If _Sleep(250) Then Return
				EndIf
			EndIf

			; check rewards received summary page
			If IsWindowOpen($sImgClanGamesReceivedWindow, 10, 200, GetDiamondFromRect("400,260,600,310")) Then
				SetLog("Found Rewards Received Summary Window")

				If $g_bDebugImageSave Then SaveDebugImage("ClanGamesReceivedWindow", False)

				; click close window
				CloseWindow()

				Return True
			EndIf

		EndIf

		If $i < 6 Then
			$aiColumn[0] = ($aiColumn[0] + $iColumnWidth)
			$aiColumn[2] = ($aiColumn[2] + $iColumnWidth)
		Else
			$aiColumn[0] = 745
			$aiColumn[1] = 246
			$aiColumn[2] = 818
			$aiColumn[3] = 453
		EndIf

		If ($i = 5 And _ColorCheck(_GetPixelColor(823, 200 + $g_iMidOffsetY, True), Hex(0xE8E8E0, 6), 20)) Or $i = 6 Then $bLoop = False

		$i += 1

		If $g_bDebugImageSave Then SaveDebugImage("ClanGamesRewardsWindow", False)
	WEnd

	Return False
EndFunc   ;==>CollectClanGamesRewards

Func SearchColumn($aiColumn, $aRewardsList)

	Local $sRewardsDir = @ScriptDir & "\imgxml\Resources\ClanGamesImages\Rewards"
	Local $aSelectReward[0][4]
	Local $sSearchArea
	Local $avRewards
	; normal templates should cover the area of the animation
	$sSearchArea = GetDiamondFromArray($aiColumn)

	; animations on full storage rewards requires repeated search to locate
	Local $i = 0
	Local $iMax = 30
	While 1
		$avRewards = findMultiple($sRewardsDir, $sSearchArea, $sSearchArea, 0, 1000, 3, "objectname,objectpoints", True)

		; Exit loop if rewards found
		If IsArray($avRewards) Or UBound($avRewards, $UBOUND_ROWS) > 0 Then ExitLoop

		SetLog("No Rewards found in column - loop :" & $i)

		If _Sleep(100) Then Return

		$i += 1

		If $i > $iMax Then Return False
	WEnd

	For $j = 0 To UBound($avRewards, $UBOUND_ROWS) - 1

		Local $avTempReward = $avRewards[$j]

		For $k = 0 To UBound($aRewardsList) - 1
			If $avTempReward[0] = $aRewardsList[$k][0] Then
				Local $aiTempCoords = decodeSingleCoord($avTempReward[1])
				; [0] reward, [1] X axis, [2] Y axis, [3] Piority
				Local $aArray[4] = [$avTempReward[0], $aiTempCoords[0], $aiTempCoords[1], $aRewardsList[$k][1]]
			EndIf
		Next

		If IsDeclared("aArray") And $aArray[0] <> "" Then
			;SetLog("Added!")
			ReDim $aSelectReward[UBound($aSelectReward) + 1][4]
			$aSelectReward[UBound($aSelectReward) - 1][0] = $aArray[0] ; Reward
			$aSelectReward[UBound($aSelectReward) - 1][1] = $aArray[1] ; Xaxis
			$aSelectReward[UBound($aSelectReward) - 1][2] = $aArray[2] ; Yaxis
			$aSelectReward[UBound($aSelectReward) - 1][3] = $aArray[3] ; Piority
			$aArray[0] = ""
		EndIf

	Next

	_ArraySort($aSelectReward, 0, 0, 0, 3)

	Return $aSelectReward
EndFunc   ;==>SearchColumn

Func SelectReward($iX, $iY)
	Local $sImgClanGamesStorageFullWindow = @ScriptDir & "\imgxml\Windows\ClanGamesStorageFull*"
	Local $sSearchArea = "420,200,560,300"

	; click reward
	Click($iX, $iY)

	If _Sleep(1000) Then Return

	; check for storage full window
	If IsWindowOpen($sImgClanGamesStorageFullWindow, 0, 0, GetDiamondFromRect($sSearchArea)) Then

		Local $aYesButton = findButton("ClanGamesStorageFullYes", Default, 1, True)

		If IsArray($aYesButton) And UBound($aYesButton, 1) = 2 Then
			If _Sleep(250) Then Return
			ClickP($aYesButton)
			If _Sleep(250) Then Return
		EndIf

	EndIf

	Return True
EndFunc   ;==>SelectReward

Func DebugClanGamesRewards($avRewards, $sText = "")

	SetLog("Column " & $sText & " Valid Rewards :" & UBound($avRewards))

	For $l = 0 To UBound($avRewards) - 1
		SetLog("$aSelectReward : " & $avRewards[$l][0])
	Next

EndFunc   ;==>DebugClanGamesRewards

Func DragRewardColumnIfNeeded($iColumn = 0)

	If $iColumn < 6 Then Return
	If $iColumn = 6 Then ClickDrag(755, 220, 755 - 108, 220, 200)
	If _Sleep(100) Then Return

	Return
EndFunc   ;==>DragRewardColumnIfNeeded

Func CooldownTime($getCapture = True)
	;check cooldown purge
	Local $aiCoolDown = decodeSingleCoord(findImage("Cooldown", $g_sImgCoolPurge & "\*.xml", GetDiamondFromRect("480,370,570,420"), 1, True, Default))
	If IsArray($aiCoolDown) And UBound($aiCoolDown, 1) >= 2 Then
		SetLog("Cooldown Purge Detected", $COLOR_INFO)
		If _Sleep(1500) Then Return
		CloseWindow()
		Return True
	EndIf
	Return False
EndFunc   ;==>CooldownTime

Func SetCGCoolDownTime($bTest = False)
	SetDebugLog("$g_hCoolDownTimer before: " & $g_hCoolDownTimer, $COLOR_DEBUG2)
	$g_hCoolDownTimer = TimerInit()
	If _Sleep(1500) Then Return

	SetDebugLog("$g_hCoolDownTimer after 1500 ms : " & Round(TimerDiff($g_hCoolDownTimer) / 1000 / 60, 2) & " Minutes", $COLOR_DEBUG2)

	If $bTest Then
		If _Sleep(1500) Then Return
		SetLog("Timer after 3000 ms : " & Round(TimerDiff($g_hCoolDownTimer) / 1000 / 60, 2) & " Minutes", $COLOR_DEBUG2)
		$g_hCoolDownTimer = 0
	EndIf
EndFunc   ;==>SetCGCoolDownTime

Func IsCGCoolDownTime($Setlog = True)
	If $g_hCoolDownTimer = 0 Then Return False

	Local $iTimer = Round(TimerDiff($g_hCoolDownTimer) / 1000 / 60, 2)
	Local $iSec = Round(TimerDiff($g_hCoolDownTimer) / 1000)
	SetDebugLog("CG Cooldown Timer : " & $iTimer)

	If $iTimer > 10 Then
		$g_hCoolDownTimer = 0
		Return False
	Else
		Local $sWaitTime = "", $iMin
		$iMin = Floor($iTimer)
		If $iTimer < 1 Then
			$iSec = Round($iTimer * 60)
		Else
			$iSec = $iSec - ($iMin * 60)
		EndIf
		If $iMin = 1 Then $sWaitTime &= $iMin & " minute "
		If $iMin > 1 Then $sWaitTime &= $iMin & " minutes "
		If $iSec > 1 Then $sWaitTime &= $iSec & " seconds"
		If $SetLog Then SetLog("Cooldown Time Detected: " & $sWaitTime, $COLOR_DEBUG2)
		Return True
	EndIf
EndFunc   ;==>IsCGCoolDownTime

Func UTCTimeCG()
	Local $Time, $DayUTC, $TimeHourUTC
	If _Sleep(100) Then Return
	Local $String = BinaryToString(InetRead("http://worldtimeapi.org/api/timezone/Etc/UTC.txt", 1))
	Local $ErrorCycle = 0
	While @error <> 0
		$String = BinaryToString(InetRead("http://worldtimeapi.org/api/timezone/Etc/UTC.txt", 1))
		If @error <> 0 Then
			$ErrorCycle += 1
		Else
			ExitLoop
		EndIf
		If _Sleep(150) Then Return
		If $ErrorCycle = 10 Then ExitLoop
	WEnd
	If $ErrorCycle = 10 Then
		If Number(@MDAY) >= 21 Then
			Return True
		Else
			Return False
		EndIf
	EndIf
	$Time = StringRegExp($String, 'datetime: (.+?)T(\d+:\d+:\d+)', $STR_REGEXPARRAYMATCH)
	If IsArray($Time) And UBound($Time) > 0 Then
		$DayUTC = StringSplit($Time[0], "-", $STR_NOCOUNT)
		$TimeHourUTC = StringSplit($Time[1], ":", $STR_NOCOUNT)
	Else
		If Number(@MDAY) >= 21 Then Return True
	EndIf
	If IsArray($TimeHourUTC) And UBound($TimeHourUTC) > 0 Then
		If $TimeHourUTC[0] > 6 And $DayUTC[2] = 22 Then
			If $TimeHourUTC[0] = 7 And $TimeHourUTC[1] > 50 Then Return True ; Clan Games begins the 22th at 8am utc. Check from 7:50am UTC.
			If $TimeHourUTC[0] > 7 Then Return True
		ElseIf $DayUTC[2] > 22 Then ; To be sure
			Return True
		EndIf
	Else
		If Number(@MDAY) >= 21 Then Return True
	EndIf
	Return False
EndFunc   ;==>UTCTimeCG

Func SwitchForCGEvent()
	If Not $g_bChkCollectBuilderBase And Not $g_bChkStartClockTowerBoost And Not $g_iChkBBSuggestedUpgrades And Not $g_bChkEnableBBAttack And Not $g_bChkCleanBBYard Then
		SetLog("Please Enable BB Attack To Complete Challenge !", $COLOR_ERROR)
		Return False
	EndIf
	If Not $g_bChkEnableBBAttack Then
		SetLog("Please Enable BB Attack To Complete Challenge !", $COLOR_ERROR)
		Return False
	EndIf
	Return True
EndFunc   ;==>SwitchForCGEvent
