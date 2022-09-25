; #FUNCTION# ====================================================================================================================
; Name ..........: Clan Games
; Description ...: This file contains the Clan Games algorithm
; Syntax ........: ---
; Parameters ....: ---
; Return values .: ---
; Author ........: ViperZ And Uncle Xbenk 01-2018
; Modified ......: ProMac 02/2018 [v2 and v3] , ProMac 08/2018 v4 , GrumpyHog 08/2020
; Remarks .......: This file is part of MyBotRun. Copyright 2018
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......: ---
; Link ..........: https://www.mybot.run
; Example .......: ---
;================================================================================================================================
#include <Array.au3>
#include <MsgBoxConstants.au3>

Func _ClanGames($test = False)

	; Check If this Feature is Enable on GUI.
	If Not $g_bChkClanGamesEnabled Then Return

   ; Check if games has been completed
   If $g_bClanGamesCompleted Then
	  SetLog("Clan Games has already been completed")
	  Return
   EndIf

	Local $sINIPath = StringReplace($g_sProfileConfigPath, "config.ini", "ClanGames_config.ini")
	If Not FileExists($sINIPath) Then ClanGamesChallenges("", True, $sINIPath, $g_bChkClanGamesDebug)

	; A user Log and a Click away just in case
	ClickAway()
	SetLog("Entering Clan Games", $COLOR_INFO)
	If _Sleep(2000) Then Return

	; Local and Static Variables
	Local $TabChallengesPosition[2] = [820, 130]
	Local $sTimeRemain = "", $sEventName = "", $getCapture = True
	Local Static $YourAccScore[8][2] = [[-1, True], [-1, True], [-1, True], [-1, True], [-1, True], [-1, True], [-1, True], [-1, True]]

	; Check for BS/CoC errors just in case
	If isProblemAffect(True) Then checkMainScreen(False)

	; Initial Timer
	Local $hTimer = TimerInit()

	; Enter on Clan Games window
	If Not IsClanGamesWindow() Then Return

	If $g_bChkClanGamesDebug Then SetLog("_ClanGames IsClanGamesWindow (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds)", $COLOR_INFO)
	$hTimer = TimerInit()

	; Let's get some information , like Remain Timer, Score and limit
	Local $aiScoreLimit = GetTimesAndScores()
	If $aiScoreLimit = -1 Or UBound($aiScoreLimit) <> 2 Then
	   ; if no score then Return
	   ; assume games over - more checks would be better
	   ; disable clan from now on
	   SetLog("Can't find your score - going to assume clan games ended")
		$g_bClanGamesCompleted = True
		$g_sActiveEventName = ""

		If Not CollectClanGamesRewards() Then ClickAway()

		Return
	EndIf

	If $g_bChkClanGamesDebug Then Setlog("_ClanGames GetTimesAndScores (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds)", $COLOR_INFO)
	$hTimer = TimerInit()

	; Small delay
	If _Sleep(1500) Then Return

	SetLog("Your Score is: " & $aiScoreLimit[0], $COLOR_INFO)

	If $aiScoreLimit[0] = $aiScoreLimit[1] Then
		SetLog("Your score limit is reached! Congrats")
		ClickAway()
		; disable clan from now on
		$g_bClanGamesCompleted = True
		$g_sActiveEventName = ""
		Return
	ElseIf $aiScoreLimit[0] + 200 > $aiScoreLimit[1] Then
		SetLog("Your Score limit is almost reached")
		If $g_bChkClanGamesStopBeforeReachAndPurge Then
			If CooldownTime() Or IsEventRunning() Then Return
			SetLog("Stop before completing your limit and only Purge")
			$sEventName = "Builder Base Challenges to Purge"
			If PurgeEvent($g_sImgPurge, $sEventName, True) Then $g_iPurgeJobCount[$g_iCurAccount] += 1
			ClickAway()
			Return
		EndIf
	EndIf

	If $YourAccScore[$g_iCurAccount][0] = -1 Then $YourAccScore[$g_iCurAccount][0] = $aiScoreLimit[0]

	;check cooldown purge
	If CooldownTime() Then Return

	If $g_bChkClanGamesDebug Then Setlog("_ClanGames CooldownTime (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds)", $COLOR_INFO)
	$hTimer = TimerInit()

	If Not $g_bRunState Then Return

	;check if event is running and if there is any issues
	If IsEventRunning() Then Return

	If $g_bChkClanGamesDebug Then Setlog("_ClanGames IsEventRunning (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds)", $COLOR_INFO)
	$hTimer = TimerInit()

	If Not $g_bRunState Then Return

	If $g_bChkClanGamesDebug Then SetLog("Your TownHall Level is " & $g_iTownHallLevel)

	; Check for BS/CoC errors just in case
	If isProblemAffect(True) Then checkMainScreen(False)

	UpdateStats()

	If $g_bChkClanGamesDebugImages Then ClanGamesDebugImages()

	; Let's selected only the necessary images [Total=71]
	Local $sImagePath = @ScriptDir & "\imgxml\Resources\ClanGamesImages\Challenges"
	Local $sTempPath = @TempDir & "\" & $g_sProfileCurrentName & "\Challenges\"

	; copy challenege tiles to temp directory
	If $g_bChkClanGamesLoot Then FileCopy($sImagePath & "\L-*.*", $sTempPath, $FC_OVERWRITE + $FC_CREATEPATH)
	If $g_bChkClanGamesAirTroop Then FileCopy($sImagePath & "\A-*.*", $sTempPath, $FC_OVERWRITE + $FC_CREATEPATH)
	If $g_bChkClanGamesGroundTroop Then FileCopy($sImagePath & "\G-*.*", $sTempPath, $FC_OVERWRITE + $FC_CREATEPATH)
	If $g_bChkClanGamesBattle Then FileCopy($sImagePath & "\B-*.*", $sTempPath, $FC_OVERWRITE + $FC_CREATEPATH)
	If $g_bChkClanGamesDestruction Then FileCopy($sImagePath & "\D-*.*", $sTempPath, $FC_OVERWRITE + $FC_CREATEPATH)
	If $g_bChkClanGamesMiscellaneous Then FileCopy($sImagePath & "\M-*.*", $sTempPath, $FC_OVERWRITE + $FC_CREATEPATH)
	If $g_bChkClanGamesSpell Then FileCopy($sImagePath & "\S-*.*", $sTempPath, $FC_OVERWRITE + $FC_CREATEPATH) ; -grumpy

	Local $HowManyImages = _FileListToArray($sTempPath, "*", $FLTA_FILES)

	If IsArray($HowManyImages) Then
		Setlog($HowManyImages[0] & " Events to search")
	Else
		Setlog("ClanGames-Error on $HowManyImages: " & @error)
	EndIf

	; To store the detections
	; [0]=ChallengeName [1]=EventName [2]=Xaxis [3]=Yaxis
	Local $aAllDetectionsOnScreen[0][5]

	Local $sClanGamesWindow = GetDiamondFromRect("300,155,765,550")
	Local $aCurrentDetection = findMultiple($sTempPath, $sClanGamesWindow, $sClanGamesWindow, 0, 1000, 0, "objectname,objectpoints", True)
	Local $aEachDetection

	If $g_bChkClanGamesDebug Then Setlog("_ClanGames findMultiple (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds)", $COLOR_INFO)
	$hTimer = TimerInit()

	; Let's split Names and Coordinates and populate a new array
	If UBound($aCurrentDetection) > 0 Then

		; Temp Variables
		Local $FullImageName, $StringCoordinates, $sString, $tempObbj, $tempObbjs, $aNames

		For $i = 0 To UBound($aCurrentDetection) - 1
			If _Sleep(50) Then Return ; just in case of PAUSE
			If Not $g_bRunState Then Return ; Stop Button

			$aEachDetection = $aCurrentDetection[$i]
			; Justto debug
			;SetDebugLog(_ArrayToString($aEachDetection))
			SetLog(_ArrayToString($aEachDetection))

			;_ArrayDisplay($aEachDetection, "$aEachDetection")

			$FullImageName = String($aEachDetection[0])
			$StringCoordinates = $aEachDetection[1]

			If $FullImageName = "" Or $StringCoordinates = "" Then ContinueLoop

			; Exist more than One coordinate!?
			If StringInStr($StringCoordinates, "|") Then
				; Code to test the string if exist anomalies on string
				$StringCoordinates = StringReplace($StringCoordinates, "||", "|")
				$sString = StringRight($StringCoordinates, 1)
				If $sString = "|" Then $StringCoordinates = StringTrimRight($StringCoordinates, 1)
				; Split the coordinates
				$tempObbjs = StringSplit($StringCoordinates, "|", $STR_NOCOUNT)
				; Just get the first [0]
				$tempObbj = StringSplit($tempObbjs[0], ",", $STR_NOCOUNT) ;  will be a string : 708,360
				If UBound($tempObbj) <> 2 Then ContinueLoop
			Else
				$tempObbj = StringSplit($StringCoordinates, ",", $STR_NOCOUNT) ;  will be a string : 708,360
				If UBound($tempObbj) <> 2 Then ContinueLoop
			EndIf

			$aNames = StringSplit($FullImageName, "-", $STR_NOCOUNT)

			;SetLog("$FullImageName : " & $FullImageName)
			;SetLog("$aNames[0] : " & $aNames[0])
			;SetLog("$aNames[1] : " & $aNames[1])

			ReDim $aAllDetectionsOnScreen[UBound($aAllDetectionsOnScreen) + 1][5]
			$aAllDetectionsOnScreen[UBound($aAllDetectionsOnScreen) - 1][0] = $aNames[0] ; Challenge Name
			$aAllDetectionsOnScreen[UBound($aAllDetectionsOnScreen) - 1][1] = $aNames[1] ; Event Name
			$aAllDetectionsOnScreen[UBound($aAllDetectionsOnScreen) - 1][2] = $tempObbj[0] ; Xaxis
			$aAllDetectionsOnScreen[UBound($aAllDetectionsOnScreen) - 1][3] = $tempObbj[1] ; Yaxis
			$aAllDetectionsOnScreen[UBound($aAllDetectionsOnScreen) - 1][4] = $FullImageName ; full filename
		Next
	EndIf

	Local $aSelectChallenges[0][6]
	Local $aHomeVillageChallenges[0][3]

	If UBound($aAllDetectionsOnScreen) > 0 Then
		For $i = 0 To UBound($aAllDetectionsOnScreen) - 1
			If IsBBChallenge($aAllDetectionsOnScreen[$i][2], $aAllDetectionsOnScreen[$i][3]) Then ContinueLoop

			ReDim $aHomeVillageChallenges[UBound($aHomeVillageChallenges) + 1][3]
			$aHomeVillageChallenges[UBound($aHomeVillageChallenges) - 1][0]=$aAllDetectionsOnScreen[$i][4] ; full image name
			$aHomeVillageChallenges[UBound($aHomeVillageChallenges) - 1][1]=$aAllDetectionsOnScreen[$i][2] ; X axis
			$aHomeVillageChallenges[UBound($aHomeVillageChallenges) - 1][2]=$aAllDetectionsOnScreen[$i][3] ; Y axis

			SetLog("Challenge : " & $i)
			Switch $aAllDetectionsOnScreen[$i][0]
				Case "L"
					If Not $g_bChkClanGamesLoot Then ContinueLoop
					;[0] = Path Directory , [1] = Name , [2] = TH level , [3] = Difficulty Level , [4] = Time to do it
					Local $LootChallenges = ClanGamesChallenges("$LootChallenges", False, $sINIPath, $g_bChkClanGamesDebug)
					For $j = 0 To UBound($LootChallenges) - 1
						; Match the names
						If $aAllDetectionsOnScreen[$i][1] = $LootChallenges[$j][0] Then
							; Verify your TH level and Challenge kind
							If $g_iTownHallLevel < $LootChallenges[$j][2] Then ExitLoop
							; Disable this event from INI File
							If $LootChallenges[$j][3] = 0 Then ExitLoop
							; [0]Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] difficulty
							Local $aArray[5] = [$LootChallenges[$j][1], $aAllDetectionsOnScreen[$i][2], $aAllDetectionsOnScreen[$i][3], $LootChallenges[$j][3], $aAllDetectionsOnScreen[$i][4]]
						EndIf
					Next
				Case "A"
					If Not $g_bChkClanGamesAirTroop Then ContinueLoop
					;[0] = Path Directory , [1] = Event Name , [2] = TH level , [3] = Event Quantities
					Local $AirTroopChallenges = ClanGamesChallenges("$AirTroopChallenges", False, $sINIPath, $g_bChkClanGamesDebug)
					For $j = 0 To UBound($AirTroopChallenges) - 1
						; Match the names
						If $aAllDetectionsOnScreen[$i][1] = $AirTroopChallenges[$j][0] Then
							; Verify if the Troops exist in your Army Composition
							Local $TroopIndex = Int(Eval("eTroop" & $AirTroopChallenges[$j][1]))
							; If doesn't Exist the Troop on your Army
							If $g_aiCurrentTroops[$TroopIndex] < 1 Then
								If $g_bChkClanGamesDebug Then SetLog("[" & $AirTroopChallenges[$j][1] & "] No " & $g_asTroopNames[$TroopIndex] & " on your army composition.")
								ExitLoop
								; If Exist BUT not is required quantities
							ElseIf $g_aiCurrentTroops[$TroopIndex] > 0 And $g_aiCurrentTroops[$TroopIndex] < $AirTroopChallenges[$j][3] Then
								If $g_bChkClanGamesDebug Then SetLog("[" & $AirTroopChallenges[$j][1] & "] You need more " & $g_asTroopNames[$TroopIndex] & " [" & $g_aiCurrentTroops[$TroopIndex] & "/" & $AirTroopChallenges[$j][3] & "]")
								ExitLoop
							EndIf
							; [0]Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] difficulty
							Local $aArray[5] = [$AirTroopChallenges[$j][1], $aAllDetectionsOnScreen[$i][2], $aAllDetectionsOnScreen[$i][3], 1, $aAllDetectionsOnScreen[$i][4]]
						EndIf
					Next

				Case "S" ; - grumpy
					If Not $g_bChkClanGamesSpell Then ContinueLoop
					;[0] = Path Directory , [1] = Event Name , [2] = TH level , [3] = Event Quantities
					Local $SpellChallenges = ClanGamesChallenges("$SpellChallenges", False, $sINIPath, $g_bChkClanGamesDebug) ; load all spell challenges
					For $j = 0 To UBound($SpellChallenges) - 1 ; loop through all challenges
						; Match the names
						If $aAllDetectionsOnScreen[$i][1] = $SpellChallenges[$j][0] Then
							; Verify if the Spell exist in your Army Composition
							Local $SpellIndex = Int(Eval("eSpell" & $SpellChallenges[$j][1])) ; assign $SpellIndex enum second column of array is spell name line 740 in GlobalVariables
							SetLog("$SpellIndex : " & $SpellIndex);
							; If doesn't Exist the Troop on your Army
							If $g_aiCurrentSpells[$SpellIndex] < 1 Then
								If $g_bChkClanGamesDebug Then SetLog("[" & $SpellChallenges[$j][1] & "] No " & $g_asSpellNames[$SpellIndex] & " on your army composition.")
								SetLog("[" & $SpellChallenges[$j][1] & "] No " & $g_asSpellNames[$SpellIndex] & " on your army composition.")
								ExitLoop
								; If Exist BUT not is required quantities
							ElseIf $g_aiCurrentSpells[$SpellIndex] > 0 And $g_aiCurrentSpells[$SpellIndex] < $SpellChallenges[$j][3] Then
								If $g_bChkClanGamesDebug Then SetLog("[" & $SpellChallenges[$j][1] & "] You need more " & $g_asSpellNames[$SpellIndex] & " [" & $g_aiCurrentSpells[$SpellIndex] & "/" & $SpellChallenges[$j][3] & "]")
								SetLog("[" & $SpellChallenges[$j][1] & "] You need more " & $g_asSpellNames[$SpellIndex] & " [" & $g_aiCurrentSpells[$SpellIndex] & "/" & $SpellChallenges[$j][3] & "]")
								ExitLoop
							EndIf
							; [0]Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] difficulty
							Local $aArray[5] = [$SpellChallenges[$j][1], $aAllDetectionsOnScreen[$i][2], $aAllDetectionsOnScreen[$i][3], 1, $aAllDetectionsOnScreen[$i][4]]
						EndIf
					Next

			   Case "G"
					If Not $g_bChkClanGamesGroundTroop Then ContinueLoop
					;[0] = Path Directory , [1] = Event Name , [2] = TH level , [3] = Event Quantities
					Local $GroundTroopChallenges = ClanGamesChallenges("$GroundTroopChallenges", False, $sINIPath, $g_bChkClanGamesDebug)
					For $j = 0 To UBound($GroundTroopChallenges) - 1
						; Match the names
						If $aAllDetectionsOnScreen[$i][1] = $GroundTroopChallenges[$j][0] Then
							; Verify if the Troops exist in your Army Composition
							Local $TroopIndex = Int(Eval("eTroop" & $GroundTroopChallenges[$j][1]))
							; If doesn't Exist the Troop on your Army
							If $g_aiCurrentTroops[$TroopIndex] < 1 Then
								If $g_bChkClanGamesDebug Then SetLog("[" & $GroundTroopChallenges[$j][1] & "] No " & $g_asTroopNames[$TroopIndex] & " on your army composition.")
								ExitLoop
								; If Exist BUT not is required quantities
							ElseIf $g_aiCurrentTroops[$TroopIndex] > 0 And $g_aiCurrentTroops[$TroopIndex] < $GroundTroopChallenges[$j][3] Then
								If $g_bChkClanGamesDebug Then SetLog("[" & $GroundTroopChallenges[$j][1] & "] You need more " & $g_asTroopNames[$TroopIndex] & " [" & $g_aiCurrentTroops[$TroopIndex] & "/" & $GroundTroopChallenges[$j][3] & "]")
								ExitLoop
							EndIf
							; [0]Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] difficulty
							Local $aArray[5] = [$GroundTroopChallenges[$j][1], $aAllDetectionsOnScreen[$i][2], $aAllDetectionsOnScreen[$i][3], 1, $aAllDetectionsOnScreen[$i][4]]
						EndIf
					 Next

				Case "B"
					If Not $g_bChkClanGamesBattle Then ContinueLoop
					 SetLog("Battle Challenges - Townhall : " & $g_iTownHallLevel)
					;[0] = Path Directory , [1] = Event Name , [2] = TH level , [3] = Difficulty Level , [4] = Time to do it
					Local $BattleChallenges = ClanGamesChallenges("$BattleChallenges", False, $sINIPath, $g_bChkClanGamesDebug)
					For $j = 0 To UBound($BattleChallenges) - 1
						; Match the names
						If $aAllDetectionsOnScreen[$i][1] = $BattleChallenges[$j][0] Then
							; Verify the TH level and a few Challenge to destroy TH specific level
							If $BattleChallenges[$j][1] = "Scrappy 6s" And $g_iTownHallLevel <>6 Then ExitLoop        ; TH level 5-6-7
							If $BattleChallenges[$j][1] = "Super 7s" And $g_iTownHallLevel <> 7 Then ExitLoop            ; TH level 6-7-8
							If $BattleChallenges[$j][1] = "Exciting 8s" And $g_iTownHallLevel <> 8 Then ExitLoop        ; TH level 7-8-9
							If $BattleChallenges[$j][1] = "Noble 9s" And $g_iTownHallLevel <> 9 Then ExitLoop        ; TH level 8-9-10
							If $BattleChallenges[$j][1] = "Terrific 10s" And $g_iTownHallLevel <> 10 Then ExitLoop    ; TH level 9-10-11
							If $BattleChallenges[$j][1] = "Exotic 11s" And $g_iTownHallLevel <> 11 Then ExitLoop     ; TH level 10-11-12
							If $BattleChallenges[$j][1] = "Triumphant 12s" And $g_iTownHallLevel <> 12 Then ExitLoop  ; TH level 11-12-13
						    If $BattleChallenges[$j][1] = "Tremendous 13s" And $g_iTownHallLevel <> 13 Then ExitLoop  ; TH level 12-13
							If $BattleChallenges[$j][1] = "Formidable 14s" And $g_iTownHallLevel <> 14 Then ExitLoop  ; TH level 12-13

							; Verify your TH level and Challenge
							If $g_iTownHallLevel < $BattleChallenges[$j][2] Then ExitLoop
							; Disable this event from INI File
							If $BattleChallenges[$j][3] = 0 Then ExitLoop
							; If you are a TH13 , doesn't exist the TH14 yet
							If $BattleChallenges[$j][1] = "Attack Up" And $g_iTownHallLevel >= 13 Then ExitLoop
							; Check your Trophy Range
							If $BattleChallenges[$j][1] = "Slaying The Titans" And (Int($g_aiCurrentLoot[$eLootTrophy]) < 4100 or Int($g_aiCurrentLoot[$eLootTrophy]) > 5000) Then ExitLoop

						    If $BattleChallenges[$j][1] = "Clash of Legends" And Int($g_aiCurrentLoot[$eLootTrophy]) < 5000 Then ExitLoop

							; Check if exist a probability to use any Spell
							; If $BattleChallenges[$j][1] = "No-Magic Zone" And ($g_bSmartZapEnable = True Or ($g_iMatchMode = $DB And $g_aiAttackAlgorithm[$DB] = 1) Or ($g_iMatchMode = $LB And $g_aiAttackAlgorithm[$LB] = 1)) Then ExitLoop
							; same as above, but SmartZap as condition removed, cause SZ does not necessary triggers every attack
							If $BattleChallenges[$j][1] = "No-Magic Zone" And (($g_iMatchMode = $DB And $g_aiAttackAlgorithm[$DB] = 1) Or ($g_iMatchMode = $LB And $g_aiAttackAlgorithm[$LB] = 1)) Then ExitLoop
							; Check if you are using Heroes
							If $BattleChallenges[$j][1] = "No Heroics Allowed" And ((Int($g_aiAttackUseHeroes[$DB]) > $eHeroNone And $g_iMatchMode = $DB) Or (Int($g_aiAttackUseHeroes[$LB]) > $eHeroNone And $g_iMatchMode = $LB)) Then ExitLoop
							; [0]Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] difficulty
							Local $aArray[5] = [$BattleChallenges[$j][1], $aAllDetectionsOnScreen[$i][2], $aAllDetectionsOnScreen[$i][3], $BattleChallenges[$j][3], $aAllDetectionsOnScreen[$i][4]]
						EndIf
					Next
				Case "D"
					If Not $g_bChkClanGamesDestruction Then ContinueLoop
					;[0] = Path Directory , [1] = Event Name , [2] = TH level , [3] = Difficulty Level , [4] = Time to do it
					Local $DestructionChallenges = ClanGamesChallenges("$DestructionChallenges", False, $sINIPath, $g_bChkClanGamesDebug)
					For $j = 0 To UBound($DestructionChallenges) - 1
						; Match the names
						If $aAllDetectionsOnScreen[$i][1] = $DestructionChallenges[$j][0] Then
							; Verify your TH level and Challenge kind
							If $g_iTownHallLevel < $DestructionChallenges[$j][2] Then ExitLoop

							; Disable this event from INI File
							If $DestructionChallenges[$j][3] = 0 Then ExitLoop

							; Check if you are using Heroes
							If $DestructionChallenges[$j][1] = "Hero Level Hunter" Or _
									$DestructionChallenges[$j][1] = "King Level Hunter" Or _
									$DestructionChallenges[$j][1] = "Queen Level Hunter" Or _
									$DestructionChallenges[$j][1] = "Warden Level Hunter" And ((Int($g_aiAttackUseHeroes[$DB]) = $eHeroNone And $g_iMatchMode = $DB) Or (Int($g_aiAttackUseHeroes[$LB]) = $eHeroNone And $g_iMatchMode = $LB)) Then ExitLoop
							; [0]Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] difficulty
							Local $aArray[5] = [$DestructionChallenges[$j][1], $aAllDetectionsOnScreen[$i][2], $aAllDetectionsOnScreen[$i][3], $DestructionChallenges[$j][3], $aAllDetectionsOnScreen[$i][4]]
						EndIf
					Next
				Case "M"
					If Not $g_bChkClanGamesMiscellaneous Then ContinueLoop
					;[0] = Path Directory , [1] = Event Name , [2] = TH level , [3] = Difficulty Level , [4] = Time to do it
					Local $MiscChallenges = ClanGamesChallenges("$MiscChallenges", False, $sINIPath, $g_bChkClanGamesDebug)
					For $j = 0 To UBound($MiscChallenges) - 1
						; Match the names
						If $aAllDetectionsOnScreen[$i][1] = $MiscChallenges[$j][0] Then
							; Disable this event from INI File
							If $MiscChallenges[$j][3] = 0 Then ExitLoop

							; Exceptions :
							; 1 - "Gardening Exercise" needs at least a Free Builder and "Remove Obstacles" enabled
							If $MiscChallenges[$j][1] = "Gardening Exercise" And ($g_iFreeBuilderCount < 1 Or Not $g_bChkCleanYard) Then ExitLoop

							; 2 - Verify your TH level and Challenge kind
							If $g_iTownHallLevel < $MiscChallenges[$j][2] Then ExitLoop

							; 3 - If you don't Donate Troops
							If $MiscChallenges[$j][1] = "Helping Hand" And Not $g_iActiveDonate Then ExitLoop

							; 4 - If you don't Donate Spells , $g_aiPrepDon[2] = Donate Spells , $g_aiPrepDon[3] = Donate All Spells [PrepareDonateCC()]
							If $MiscChallenges[$j][1] = "Donate Spells" And ($g_aiPrepDon[2] = 0 And $g_aiPrepDon[3] = 0) Then ExitLoop

							; 5 - If you don't use Wrecker - $g_aiAttackUseSiege->attack ui, $g_aiArmyCompSiegeMachine->camps, so... if you have not selected it, it's not in camps, ..... forget it!
							If $MiscChallenges[$j][1] = "Wall Wrecker" And ($g_aiAttackUseSiege[$DB] = 1 Or $g_aiAttackUseSiege[$LB] = 1) And $g_aiCurrentCCSiegeMachines[$eSiegeWallWrecker] = 0 Then ExitLoop

							; 6 - If you don't use Blimp
							If $MiscChallenges[$j][1] = "Battle Blimp" And ($g_aiAttackUseSiege[$DB] = 2 Or $g_aiAttackUseSiege[$LB] = 2) And $g_aiCurrentCCSiegeMachines[$eSiegeBattleBlimp] = 0 Then ExitLoop

							If $MiscChallenges[$j][1] = "Stone Slammer" And ($g_aiAttackUseSiege[$DB] = 3 Or $g_aiAttackUseSiege[$LB] = 3) And $g_aiCurrentCCSiegeMachines[$eSiegeStoneSlammer] = 0 Then ExitLoop

							If $MiscChallenges[$j][1] = "Siege Barrack" And ($g_aiAttackUseSiege[$DB] = 4 Or $g_aiAttackUseSiege[$LB] = 4) And $g_aiCurrentCCSiegeMachines[$eSiegeBarracks] = 0 Then ExitLoop

							If $MiscChallenges[$j][1] = "Log Launcher" And ($g_aiAttackUseSiege[$DB] = 5 Or $g_aiAttackUseSiege[$LB] = 5) And $g_aiCurrentCCSiegeMachines[$eSiegeLogLauncher] = 0 Then ExitLoop

							If $MiscChallenges[$j][1] = "Flame Flinger" And ($g_aiAttackUseSiege[$DB] = 6 Or $g_aiAttackUseSiege[$LB] = 6) And $g_aiCurrentCCSiegeMachines[$eSiegeFlameFlinger] = 0 Then ExitLoop

							; [0]Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] difficulty
							Local $aArray[5] = [$MiscChallenges[$j][1], $aAllDetectionsOnScreen[$i][2], $aAllDetectionsOnScreen[$i][3], $MiscChallenges[$j][3], $aAllDetectionsOnScreen[$i][4]]
						EndIf
					Next
			EndSwitch
			If IsDeclared("aArray") And $aArray[0] <> "" Then
				ReDim $aSelectChallenges[UBound($aSelectChallenges) + 1][6]
				$aSelectChallenges[UBound($aSelectChallenges) - 1][0] = $aArray[0] ; Event Name Full Name
				$aSelectChallenges[UBound($aSelectChallenges) - 1][1] = $aArray[1] ; Xaxis
				$aSelectChallenges[UBound($aSelectChallenges) - 1][2] = $aArray[2] ; Yaxis
				$aSelectChallenges[UBound($aSelectChallenges) - 1][3] = $aArray[3] ; difficulty
				$aSelectChallenges[UBound($aSelectChallenges) - 1][4] = 0 ; timer minutes
				$aSelectChallenges[UBound($aSelectChallenges) - 1][5] = $aArray[4] ; full filename
				$aArray[0] = ""
			EndIf
		Next
	EndIf

	; Remove the temp  images Folder
	DirRemove($sTempPath, $DIR_REMOVE)

	If $g_bChkClanGamesDebug Then Setlog("_ClanGames aAllDetectionsOnScreen (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds)", $COLOR_INFO)
	$hTimer = TimerInit()

	; Sort by Yaxis , TOP to Bottom
	_ArraySort($aSelectChallenges, 0, 0, 0, 2)

	#cs
	If UBound($aSelectChallenges) > 0 Then
		; let's get the Event timing
		For $i = 0 To UBound($aSelectChallenges) - 1
			Setlog("Detected " & $aSelectChallenges[$i][0] & " difficulty of " & $aSelectChallenges[$i][3])
			Click($aSelectChallenges[$i][1], $aSelectChallenges[$i][2])
			If _Sleep(1500) Then Return
			Local $EventHours = GetEventInformation()
			Setlog("Time: " & $EventHours & " min", $COLOR_INFO)
			Click($aSelectChallenges[$i][1], $aSelectChallenges[$i][2])
			If _Sleep(250) Then Return
			$aSelectChallenges[$i][4] = Number($EventHours)
		Next

		; let's get the 60 minutes events and remove from array
		Local $aTempSelectChallenges[0][6]
		For $i = 0 To UBound($aSelectChallenges) - 1
			If $aSelectChallenges[$i][4] = 60 And $g_bChkClanGames60 Then
				Setlog($aSelectChallenges[$i][0] & " unselected, is a 60min event!", $COLOR_INFO)
				ContinueLoop
			EndIf
			ReDim $aTempSelectChallenges[UBound($aTempSelectChallenges) + 1][6]
			$aTempSelectChallenges[UBound($aTempSelectChallenges) - 1][0] = $aSelectChallenges[$i][0]
			$aTempSelectChallenges[UBound($aTempSelectChallenges) - 1][1] = $aSelectChallenges[$i][1]
			$aTempSelectChallenges[UBound($aTempSelectChallenges) - 1][2] = $aSelectChallenges[$i][2]
			$aTempSelectChallenges[UBound($aTempSelectChallenges) - 1][3] = $aSelectChallenges[$i][3]
			$aTempSelectChallenges[UBound($aTempSelectChallenges) - 1][4] = $aSelectChallenges[$i][4]
			$aTempSelectChallenges[UBound($aTempSelectChallenges) - 1][5] = $aSelectChallenges[$i][5]

			Setlog($aSelectChallenges[$i][0] & " selected!", $COLOR_INFO)
		Next

		; Drop to top again , because coordinates Xaxis and Yaxis
		ClickP($TabChallengesPosition, 2, 0, "#Tab")
		If _sleep(250) Then Return
		ClickDrag(807, 210, 807, 385, 500)
		If _Sleep(500) Then Return
	EndIf

	; After removing is necessary check Ubound
	If IsDeclared("aTempSelectChallenges") Then
		If UBound($aTempSelectChallenges) > 0 Then
			SetDebugLog("$aTempSelectChallenges: " & _ArrayToString($aTempSelectChallenges))
			; Sort by difficulties
			_ArraySort($aTempSelectChallenges, 0, 0, 0, 3)

			Setlog("Next Event will be " & $aTempSelectChallenges[0][0] & " to make in " & $aTempSelectChallenges[0][4] & " min.")
			; Select and Start EVENT
			$sEventName = $aTempSelectChallenges[0][0]
			Click($aTempSelectChallenges[0][1], $aTempSelectChallenges[0][2])
			If _Sleep(1750) Then Return
			If $test Then Return
			If ClickOnEvent($YourAccScore, $aiScoreLimit, $sEventName, $getCapture) Then
			   $g_sActiveEventName = $aTempSelectChallenges[0][5]
			   SetLog("$g_sActiveEventName : " & $g_sActiveEventName)
			   Return
			EndIf

			; Some error occurred let's click on Challenges Tab and proceeds
			ClickP($TabChallengesPosition, 2, 0, "#Tab")
			;ClickAway()
		EndIf
	EndIf
	#ce

		If UBound($aSelectChallenges) > 0 Then
			;SetDebugLog("$aSelectChallenges: " & _ArrayToString($aSelectChallenges))
			SetLog("$aSelectChallenges: " & _ArrayToString($aSelectChallenges))

			; Sort by difficulties
			_ArraySort($aSelectChallenges, 0, 0, 0, 3)

			Setlog("Next Event will be " & $aSelectChallenges[0][0] & " to make in " & $aSelectChallenges[0][4] & " min.")
			; Select and Start EVENT
			$sEventName = $aSelectChallenges[0][0]
			Click($aSelectChallenges[0][1], $aSelectChallenges[0][2])
			If _Sleep(1750) Then Return
			If $test Then Return
			If ClickOnEvent($YourAccScore, $aiScoreLimit, $sEventName, $getCapture) Then
			   $g_sActiveEventName = $aSelectChallenges[0][5]
			   SetLog("$g_sActiveEventName : " & $g_sActiveEventName)
			   If _Sleep(250) Then Return
			   Return
			EndIf

			; Some error occurred let's click on Challenges Tab and proceeds
			ClickP($TabChallengesPosition, 2, 0, "#Tab")
			;ClickAway()
		EndIf


	; Lets test the Builder Base Challenges
	If $g_bChkClanGamesPurgeHome Then

		SetLog("Purge Home Village Challenge", $COLOR_WARNING)
		PurgeVillageEvent($aHomeVillageChallenges, $g_sImgPurgeHomeVillage, "Purge Home Village Event")
#cs
		If $g_iPurgeJobCount[$g_iCurAccount] + 1 < $g_iPurgeMax Or $g_iPurgeMax = 0 Then
			Local $Txt = $g_iPurgeMax
			If $g_iPurgeMax = 0 Then $Txt = "Unlimited"
			SetLog("Current Purge Jobs " & $g_iPurgeJobCount[$g_iCurAccount] + 1 & " at max of " & $Txt, $COLOR_INFO)
			$sEventName = "Builder Base Challenges to Purge"
			If PurgeEvent($g_sImgPurge, $sEventName, True) Then
				$g_iPurgeJobCount[$g_iCurAccount] += 1
			Else
				SetLog("No Builder Base Event found to Purge", $COLOR_WARNING)
				PurgeRandomEvent()
			EndIf
#ce		EndIf
		Return
	EndIf

	SetLog("No Event found, Check your settings", $COLOR_WARNING)
	ClickAway()
	If _Sleep(2000) Then Return

EndFunc   ;==>_ClanGames

Func IsClanGamesWindow($getCapture = True)
	Local $aGameTime[4] = [384, 388, 0xFFFFFF, 10]

	SetLog("IsClanGamesWindow")

	If QuickMIS("BC1", $g_sImgCaravan, 200, 55, 300, 135, $getCapture, False) Then
		SetLog("Caravan available! Entering Clan Games", $COLOR_SUCCESS)
		Click($g_iQuickMISX, $g_iQuickMISY)
		; Just wait for window open
		If _Sleep(1500) Then Return
		If QuickMIS("BC1", $g_sImgReward, 760, 480, 830, 570, $getCapture, $g_bChkClanGamesDebug) Then
			SetLog("Your Reward is Ready", $COLOR_INFO)
			ClickAway()
			If _Sleep(1000) Then Return
			Return False
		EndIf
#cs
		If _CheckPixel($aGameTime, True) Then
			Local $sTimeRemain = getOcrTimeGameTime(380, 461) ; read Clan Games waiting time
			SetLog("Clan Games will start in " & $sTimeRemain, $COLOR_INFO)
			$g_sClanGamesTimeRemaining = $sTimeRemain
			ClickAway()
			If _Sleep(100) Then Return
			Return False
		EndIf
#ce
	Else
		SetLog("Caravan not available", $COLOR_WARNING)
		$g_sActiveEventName = "" ; clear saved challenge
		;ClickAway()
		Return False
	EndIf

	If _Sleep(1500) Then Return

	$g_IsClanGamesActive = True

	Return True
EndFunc   ;==>IsClanGamesWindow

Func GetTimesAndScores()
	Local $iRestScore = -1, $sYourGameScore = "", $aiScoreLimit, $sTimeRemain

	;Ocr for game time remaining
	$sTimeRemain = StringReplace(getOcrTimeGameTime(55, 470), " ", "") ; read Clan Games waiting time

	;Check if OCR returned a valid timer format
	If Not StringRegExp($sTimeRemain, "([0-2]?[0-9]?[DdHhSs]+)", $STR_REGEXPMATCH, 1) Then
		SetLog("getOcrTimeGameTime(): no valid return value (" & $sTimeRemain & ")", $COLOR_ERROR)
		Return -1
	EndIf

	SetLog("Clan Games time remaining: " & $sTimeRemain, $COLOR_INFO)

	; This Loop is just to check if the Score is changing , when you complete a previous events is necessary to take some time
	For $i = 0 To 10
		$sYourGameScore = getOcrYourScore(45, 530) ;  Read your Score
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

Func CooldownTime($getCapture = True)
	;check cooldown purge
	Local $aiCoolDown = decodeSingleCoord(findImage("Cooldown", $g_sImgCoolPurge & "*", GetDiamondFromRect("480,370,570,410"), 1, True, Default))
	If IsArray($aiCoolDown) And UBound($aiCoolDown, 1) >= 2 Then
		SetLog("Cooldown Purge Detected", $COLOR_INFO)
		ClickAway()
		Return True
	EndIf
	Return False
EndFunc   ;==>CooldownTime

; check if there is a current challenge
; Return - True or False
#cs
Func IsEventRunning()
	Local $aEventFailed[4] = [304, 255, 0xEA2B24, 20]

	; Check if any event is running or not
	If Not _ColorCheck(_GetPixelColor(304, 260, True), Hex(0x53E050, 6), 5) Then ; Green Bar from First Position
		;Check if Event failed
		If _CheckPixel($aEventFailed, True) Then
			SetLog("Couldn't finish last event! Lets trash it and look for a new one", $COLOR_INFO)
			If TrashFailedEvent() Then
				Return False
			Else
				SetLog("Error happend while trashing failed event", $COLOR_ERROR)
				ClickAway()
				Return True
			EndIf
		Else
			;Check if correct event
			If Not IsCorrectEvent() Then
				If TrashEvent() Then
					Local $sText = "Trashed incorrect event - " & $g_sActiveEventName
					SetLog($sText, $COLOR_ERROR)
					_FileWriteLog($g_sProfileLogsPath & "\ClanGames.log", " [" & $g_sProfileCurrentName & "] - " & $sText)

					Return False
				Else
					SetLog("Error happend while trashing failed event", $COLOR_ERROR)
					ClickAway()
					Return True
				EndIf
			Else
				SetLog("An event is already in progress!", $COLOR_SUCCESS)
				If $g_bChkClanGamesDebug Then SetLog("[0]: " & _GetPixelColor(304, 257, True))
				ClickAway()
				Return True
			EndIf
		EndIf
	Else
		SetLog("No event under progress. Lets look for one", $COLOR_INFO)
		$g_sActiveEventName = ""
		If _Sleep(2000) Then Return
		Return False
	EndIf
EndFunc   ;==>IsEventRunning
#ce


; if check there is a active challenge

Func IsEventRunning()
	Local $aEventFailed[4] = [304, 255, 0xEA2B24, 20]

	; green from first challenge - active challenge
	If _ColorCheck(_GetPixelColor(304, 260, True), Hex(0x53E050, 6), 5) Then
		$g_sActiveEventName = "" ; reset global $g_sActiveEventName
		Return False
	EndIf
	SetLog("Active challenge")

	; Check if Event failed
	If _CheckPixel($aEventFailed, True) Then
		SetLog("Couldn't finish last event! Lets trash it and look for a new one", $COLOR_INFO)
		If TrashFailedEvent() Then
			$g_sActiveEventName = ""
			Return False
		EndIf
	EndIf
	SetLog("Not failed challenge")

	; check if correct event
	; yes - active challenge return True
	; no - trashed challenge -> trip timer -> return True
	If IsCorrectEvent() Then SetLog("An event is already in progress!", $COLOR_SUCCESS)

	If $g_bChkClanGamesDebug Then SetLog("[0]: " & _GetPixelColor(304, 257, True))

	; clear clan game window
	ClickAway()
	Return True
EndFunc   ;==>IsEventRunning


; get saved of current event
; compare with current event
Func IsCorrectEvent()
	Local $sSearchArea = "295, 155, 390, 250"
	Local $sImagePath = @ScriptDir & "\imgxml\Resources\ClanGamesImages\Challenges"

	If $g_sActiveEventName <> "" Then
		SetLog("Verifying Challenge : " & $g_sActiveEventName)

		Local $asActiveEvent = _FileListToArray($sImagePath, $g_sActiveEventName & "*", $FLTA_FILES, True)

		;_ArrayDisplay($asActiveEvent, "$asActiveEvent")

		If IsArray($asActiveEvent) And UBound($asActiveEvent, $UBOUND_ROWS) > 1 Then

			; loop through all image files
			For $i = 1 to $asActiveEvent[0]
				Local $sActiveEventFileName = $asActiveEvent[$i]

				SetLog("$sActiveEventFileName : " & $sActiveEventFileName)
				If _Sleep(500) Then Return

				;Local $aiActiveEvent = decodeSingleCoord(findTile($sActiveEventFileName, GetDiamondFromRect($sSearchArea), 1, True))
				Local $aiActiveEvent = decodeSingleCoord(findImage("", $sActiveEventFileName, GetDiamondFromRect($sSearchArea), 1, True))

				If _Sleep(500) Then Return

				If UBound($aiActiveEvent, $UBOUND_ROWS) > 1 Then
					SetLog("Found Correct Active Event : " & $g_sActiveEventName & " at " & $aiActiveEvent[0] & "," & $aiActiveEvent[1])
					If _Sleep(500) Then Return
					Return True
				EndIf
			Next
		EndIf
	EndIf

	If _Sleep(1000) Then Return

	; trash incorrect event
	If Not TrashEvent() Then SetLog("Problem with trashing : " & $g_sActiveEventName)

	Return False
EndFunc

Func ClickOnEvent(ByRef $YourAccScore, $ScoreLimits, $sEventName, $getCapture)
	If Not $YourAccScore[$g_iCurAccount][1] Then
		Local $Text = "", $color = $COLOR_SUCCESS
		If $YourAccScore[$g_iCurAccount][0] <> $ScoreLimits[0] Then
			$Text = "You on " & $ScoreLimits[0] - $YourAccScore[$g_iCurAccount][0] & "points in last Event"
		Else
			$Text = "You could not complete the last event!"
			$color = $COLOR_WARNING
		EndIf
		SetLog($Text, $color)
		_FileWriteLog($g_sProfileLogsPath & "\ClanGames.log", " [" & $g_sProfileCurrentName & "] - " & $Text)
	EndIf
	$YourAccScore[$g_iCurAccount][1] = False
	$YourAccScore[$g_iCurAccount][0] = $ScoreLimits[0]
	If $g_bChkClanGamesDebug Then SetLog("ClickOnEvent $YourAccScore[" & $g_iCurAccount & "][1]: " & $YourAccScore[$g_iCurAccount][1])
	If $g_bChkClanGamesDebug Then SetLog("ClickOnEvent $YourAccScore[" & $g_iCurAccount & "][0]: " & $YourAccScore[$g_iCurAccount][0])
	If Not StartsEvent($sEventName, False, $getCapture, $g_bChkClanGamesDebug) Then Return False
	ClickAway()
	Return True
EndFunc   ;==>ClickOnEvent

Func StartsEvent($sEventName, $g_bPurgeJob = False, $getCapture = True, $g_bChkClanGamesDebug = False)
	If Not $g_bRunState Then Return

	If QuickMIS("BC1", $g_sImgStart, 220, 150, 830, 580, $getCapture, $g_bChkClanGamesDebug) Then
		Local $Timer = GetEventTimeInMinutes($g_iQuickMISX, $g_iQuickMISY)
		SetLog("Starting  Event" & " [" & $Timer & " min]", $COLOR_SUCCESS)
		Click($g_iQuickMISX, $g_iQuickMISY)
		$g_iEventTime = $Timer
		GUICtrlSetData($g_hTxtClanGamesLog, @CRLF & _NowDate() & " " & _NowTime() & " [" & $g_sProfileCurrentName & "] - Starting " & $sEventName & " for " & $Timer & " min", 1)
		_FileWriteLog($g_sProfileLogsPath & "\ClanGames.log", " [" & $g_sProfileCurrentName & "] - Starting " & $sEventName & " for " & $Timer & " min")
		If $g_bPurgeJob Then
			If _Sleep(2000) Then Return
			If QuickMIS("BC1", $g_sImgTrashPurge, 220, 150, 830, 580, $getCapture, $g_bChkClanGamesDebug) Then
				Click($g_iQuickMISX, $g_iQuickMISY)
				If _Sleep(1200) Then Return
				SetLog("Click Trash", $COLOR_INFO)
				SaveDebugImage("Click_Trash", False)
				If QuickMIS("BC1", $g_sImgOkayPurge, 440, 400, 580, 450, $getCapture, $g_bChkClanGamesDebug) Then
					SetLog("Click OK", $COLOR_INFO)
					Click($g_iQuickMISX, $g_iQuickMISY)
					SetLog("Purging a job on progress !", $COLOR_SUCCESS)
					GUICtrlSetData($g_hTxtClanGamesLog, @CRLF & _NowDate() & " " & _NowTime() & " [" & $g_sProfileCurrentName & "] - [" & $g_iPurgeJobCount[$g_iCurAccount] + 1 & "] - Purging Event ", 1)
					_FileWriteLog($g_sProfileLogsPath & "\ClanGames.log", " [" & $g_sProfileCurrentName & "] - [" & $g_iPurgeJobCount[$g_iCurAccount] + 1 & "] - Purging Event ")
					ClickAway()
				Else
					SetLog("$g_sImgOkayPurge Issue", $COLOR_ERROR)
					Return False
				EndIf
			Else
				SetLog("$g_sImgTrashPurge Issue", $COLOR_ERROR)
				Return False
			EndIf
		EndIf

		Return True
	Else
		SetLog("Didn't Get the Green Start Button Event", $COLOR_WARNING)
		If $g_bChkClanGamesDebug Then SetLog("[X: " & 220 & " Y:" & 150 & " X1: " & 830 & " Y1: " & 580 & "]", $COLOR_WARNING)
		ClickAway()
		Return False
	EndIf

EndFunc   ;==>StartsEvent

; PurgeEvent($g_sImgPurgeHomeVillage, "test")
Func PurgeEvent($directoryImage, $sEventName, $getCapture = True)
	SetLog("Checking Builder Base Challenges to Purge", $COLOR_DEBUG)
	; Screen coordinates for ScreenCapture
	Local $x = 281, $y = 150, $x1 = 775, $y1 = 545
	If QuickMIS("BC1", $directoryImage, $x, $y, $x1, $y1, $getCapture, $g_bChkClanGamesDebug) Then
		Click($g_iQuickMISX, $g_iQuickMISY)
		; Start and Purge at same time
		SetLog("Starting Impossible Job to purge", $COLOR_INFO)
		If _Sleep(1500) Then Return
		If StartsEvent($sEventName, True, $getCapture, $g_bChkClanGamesDebug) Then
			ClickAway()
			Return True
		EndIf
	EndIf
	Return False
EndFunc   ;==>PurgeEvent

Func PurgeRandomEvent()
	Local $eventColumns[4] = [343, 470, 595, 860]
	Local $eventRows[3] = [210, 374, 517]

	Local $c = Random(0, 3, 1)
	Local $r = Random(0, 2, 1)

	SetLog("Purge event on column : " & $c + 1 & " and row : " & $r + 1)

	ClickTile($eventColumns[$c], $eventRows[$r])

   If _Sleep(1500) Then Return

   If StartsEvent("PurgeRandomEvent", True, True, $g_bChkClanGamesDebug) Then
	  ClickAway()
	  Return True
   EndIf

   Return False
EndFunc

Func PurgeVillageEvent($aVillageChallenges, $directoryImage, $sEventName, $getCapture = True)
	Local $z = UBound($aVillageChallenges)

	if $z <= 0 Then
		SetLog("No CONFIRMED Challenges to Purge!")
		SetLog("Going to RANDOM " & $sEventName)
		If PurgeEvent($directoryImage, $sEventName, True) Then
			Return True
		Else
			SetLog("OMG Did not ANY Events to Purge!")
			ClickAway()
			Return False
		EndIf
	EndIf

	Local $i = random(0,  $z - 1, 1)

	Local $x = $aVillageChallenges[$i][1]
	Local $y = $aVillageChallenges[$i][2]

	SetLog("Purge event on column : " & $x & " and row : " & $y)

	Click($x, $y)

   If _Sleep(1500) Then Return

	If StartsEvent("PurgeMainVillageEvent", True, True, $g_bChkClanGamesDebug) Then
		_FileWriteLog($g_sProfileLogsPath & "\ClanGames.log", " [" & $g_sProfileCurrentName & "] - [" & $aVillageChallenges[$i][0] & "] - Purged ")

		ClickAway()
		Return True
   EndIf

   Return False
EndFunc

Func ClickTile($column, $row)
   local $c = $column + random(0,9,1)
   local $r = $row + random(0,9,1)

   Click($c, $r)
EndFunc

Func TrashFailedEvent()
	;Look for the red cross on failed event
	If Not ClickB("EventFailed") Then
		SetLog("Could not find the failed event icon!", $COLOR_ERROR)
		Return False
	EndIf

	If _Sleep(1300) Then Return

	;Look for the red trash event Button and press it
	If Not ClickB("TrashEvent") Then
		SetLog("Could not find the trash event button!", $COLOR_ERROR)
		Return False
	EndIf

	If _Sleep(1500) Then Return

	Return True
EndFunc   ;==>TrashFailedEvent

Func TrashEvent()
	Local $x = Random(315,370,1)
	Local $y = Random(170,230,1)

	; click on first tile
	Click($x, $y);

	If _Sleep(1000) Then Return

	;Look for the red trash event Button and press it
	If Not ClickB("TrashEvent") Then
		SetLog("Could not find the trash event button!", $COLOR_ERROR)
		Return False
	EndIf

	If _Sleep(1500) Then Return

	If QuickMIS("BC1", $g_sImgOkayPurge, 440, 400, 580, 450, True, False) Then
		SetLog("Click OK", $COLOR_INFO)
		Click($g_iQuickMISX, $g_iQuickMISY)
		SetLog("Trashed a incorrect challenge!", $COLOR_SUCCESS)
	Else
		SetLog("$g_sImgOkayPurge Issue", $COLOR_ERROR)
		Return False
	EndIf

	$g_sActiveEventName = ""
	; write in clangames log file
	GUICtrlSetData($g_hTxtClanGamesLog, @CRLF & _NowDate() & " " & _NowTime() & " [" & $g_sProfileCurrentName & "] - [" & $g_iPurgeJobCount[$g_iCurAccount] + 1 & "] - Trashing Event ", 1)
	_FileWriteLog($g_sProfileLogsPath & "\ClanGames.log", " [" & $g_sProfileCurrentName & "] - [" & $g_iPurgeJobCount[$g_iCurAccount] + 1 & "] - Trashing Event ")

	Return True
EndFunc   ;==>TrashEvent


Func GetEventTimeInMinutes($iXStartBtn, $iYStartBtn, $bIsStartBtn = True)

	Local $XAxis = $iXStartBtn - 163 ; Related to Start Button
	Local $YAxis = $iYStartBtn + 8 ; Related to Start Button

	If Not $bIsStartBtn Then
		$XAxis = $iXStartBtn - 163 ; Related to Trash Button
		$YAxis = $iYStartBtn + 8 ; Related to Trash Button
	EndIf

	Local $Ocr = getOcrEventTime($XAxis, $YAxis)
	SetLog("getOcrEventTime :" & $Ocr)
	Return ConvertOCRTime("ClanGames()", $Ocr, True)
EndFunc   ;==>GetEventTimeInMinutes

Func GetEventInformation()
	If QuickMIS("BC1", $g_sImgStart, 220, 150, 830, 580, True, $g_bChkClanGamesDebug) Then
		Return GetEventTimeInMinutes($g_iQuickMISX, $g_iQuickMISY)
	Else
		SetLog("Can't find start button")
		Return 0
	EndIf
EndFunc   ;==>GetEventInformation

Func IsBBChallenge($iX, $iY)
	Local $iXtoCheck = 299 + 126 * Int(($iX - 299) / 126)
	Local $iYtoCheck = 156 + 160 * Int(($iY - 156) / 160)
	Local $aPositionToCheck[4] = [$iXtoCheck, $iYtoCheck, 0x0D6687, 10]

	If $g_bChkClanGamesDebug Then SetLog("IsBBChallenge() x= " & $iXtoCheck & ", y= " & $iYtoCheck & ", color = " & _GetPixelColor($iXtoCheck, $iYtoCheck, True) , $COLOR_DEBUG)

	SetLog("IsBBChallenge() x= " & $iXtoCheck & ", y= " & $iYtoCheck & ", color = " & _GetPixelColor($iXtoCheck, $iYtoCheck, True) , $COLOR_DEBUG)

	If _CheckPixel($aPositionToCheck, True) Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>IsBBChallenge

; Just for any button test
Func ClanGames($bTest = False)
	Local $bWasRunState = $g_bRunState
	$g_bRunState = True
	Local $temp = $g_bChkClanGamesDebug
	Local $debug = $g_bDebugSetlog
	$g_bDebugSetlog = True
	$g_bChkClanGamesDebug = True
	Local $tempCurrentTroops = $g_aiCurrentTroops
	For $i = 0 To UBound($g_aiCurrentTroops) - 1
		$g_aiCurrentTroops[$i] = 50
	Next
	Local $Result = _ClanGames(True)
	$g_aiCurrentTroops = $tempCurrentTroops
	$g_bRunState = $bWasRunState
	$g_bChkClanGamesDebug = $temp
	$g_bDebugSetlog = $debug
	Return $Result
EndFunc   ;==>ClanGames

#Tidy_Off
Func ClanGamesChallenges($sReturnArray, $makeIni = False, $sINIPath = "", $bDebug = False)

	;[0]=ImageName 	 					[1]=Challenge Name		[3]=THlevel 	[4]=Priority/TroopsNeeded 	[5]=Extra/to use in future
	Local $LootChallenges[6][5] = [ _
			["GoldChallenge", 			"Gold Challenge", 				 7,  5, 8], _ ; Loot 150,000 Gold from a single Multiplayer Battle				|8h 	|50
			["ElixirChallenge", 		"Elixir Challenge", 			 7,  5, 8], _ ; Loot 150,000 Elixir from a single Multiplayer Battle 			|8h 	|50
			["DarkEChallenge", 			"Dark Elixir Challenge", 		 8,  5, 8], _ ; Loot 1,500 Dark elixir from a single Multiplayer Battle			|8h 	|50
			["GoldGrab", 				"Gold Grab", 					 3,  1, 1], _ ; Loot a total of 500,000 TO 1,500,000 from Multiplayer Battle 	|1h-2d 	|100-600
			["ElixirEmbezz", 			"Elixir Embezzlement", 			 3,  1, 1], _ ; Loot a total of 500,000 TO 1,500,000 from Multiplayer Battle 	|1h-2d 	|100-600
			["DarkEHeist", 				"Dark Elixir Heist", 			 9,  3, 1]]   ; Loot a total of 1,500 TO 12,500 from Multiplayer Battle 		|1h-2d 	|100-600


	Local $AirTroopChallenges[10][5] = [ _
			["Mini", 					"Minion", 						 7, 10, 1], _ ; Earn 2-5 Stars from Multiplayer Battles using 20 Minions		|3h-8h	|40-100
			["Ball", 					"Balloon", 						 4, 12, 1], _ ; Earn 2-5 Stars from Multiplayer Battles using 12 Balloons		|3h-8h	|40-100
			["Drag", 					"Dragon", 						 7,  6, 1], _ ; Earn 2-5 Stars from Multiplayer Battles using 6 Dragons			|3h-8h	|40-100
			["BabyD", 					"BabyDragon", 					 9,  2, 1], _ ; Earn 2-5 Stars from Multiplayer Battles using 4 Baby Dragons	|3h-8h	|40-100
			["Edrag", 					"ElectroDragon", 				10,  2, 1], _ ; Earn 2-4 Stars from Multiplayer Battles using 2 Electro Dragon	|3h-8h	|40-300
			["Rdrag", 					"DragonRider",	 				12,  1, 1], _
			["Lava", 					"Lavahound", 					 9,  1, 1], _ ; Earn 2-5 Stars from Multiplayer Battles using 3 Lava Hounds		|3h-8h	|40-100
			["Smini", 					"SuperMinion", 					12,  3, 1], _ ; check quantity missing xml
			["InfernoD",				"InfernoDrag", 					12,  1, 1], _ ; check quantity missing
			["IceH", 					"IceHound", 					13,  1, 1]]   ; check quantity missing xml


	Local $GroundTroopChallenges[25][5] = [ _
			["Arch", 					"Archer", 						 1, 10, 1], _ ; Earn 2-5 Stars from Multiplayer Battles using 30 Barbarians		|3h-8h	|40-100
			["Barb", 					"Barbarian", 					 1, 30, 1], _ ; Earn 2-5 Stars from Multiplayer Battles using 30 Archers		|3h-8h	|40-100
			["Giant", 					"Giant", 						 1, 10, 1], _ ; Earn 2-5 Stars from Multiplayer Battles using 10 Giants			|3h-8h	|40-100
			["Gobl", 					"Goblin", 						 2, 20, 1], _ ; Earn 2-5 Stars from Multiplayer Battles using 20 Goblins		|3h-8h	|40-100
			["Wall", 					"WallBreaker", 					 3,  2, 1], _ ; Earn 2-5 Stars from Multiplayer Battles using 6 Wall Breakers	|3h-8h	|40-100
			["Wiza", 					"Wizard", 						 5,  6, 1], _ ; Earn 2-5 Stars from Multiplayer Battles using 12 Wizards		|3h-8h	|40-100
			["Heal", 					"Healer", 						 6,  3, 1], _ ; Earn 2-5 Stars from Multiplayer Battles using 3 Healers			|3h-8h	|40-100
			["Hogs", 					"HogRider", 					 7, 10, 1], _ ; Earn 2-5 Stars from Multiplayer Battles using 10 Hog Riders		|3h-8h	|40-100
			["Mine", 					"Miner", 						10,  8, 1], _ ; Earn 2-5 Stars from Multiplayer Battles using 8 Miners			|3h-8h	|40-100
			["Pekk", 					"Pekka", 						 8,  1, 1], _ ; Earn 2-5 Stars from Multiplayer Battles using 2 P.E.K.K.As		|3h-8h	|40-100
			["Witc", 					"Witch", 						 9,  2, 1], _ ; Earn 2-5 Stars from Multiplayer Battles using 2 Witches			|3h-8h	|40-100
			["Bowl", 					"Bowler", 						10,  8, 1], _ ; Earn 2-5 Stars from Multiplayer Battles using 8 Bowlers			|3h-8h	|40-100
			["Valk", 					"Valkyrie", 					 8,  4, 1], _ ; Earn 2-5 Stars from Multiplayer Battles using 8 Valkyries		|3h-8h	|40-100
			["Gole", 					"Golem", 						 8,  2, 1], _ ; Earn 2-5 Stars from Multiplayer Battles using 2 Golems			|3h-8h	|40-100
			["Yeti", 					"Yeti", 						 12, 1, 1], _ ; check quantity
			["IceG", 					"IceGolem", 					 11, 2, 1], _ ; check quantity
			["Hunt", 					"HeadHunters", 					 12, 2, 1], _ ; check quantity
			["Sbarb", 					"SuperBarbarian", 				 11, 1, 1], _ ; check quantity
			["Sarch", 					"SuperArcher", 					 11, 1, 1], _ ; check quantity missing xml
			["Sgiant", 					"SuperGiant", 					 12, 1, 1], _ ; check quantity
			["Sgobl", 					"SneakyGoblin", 				 11, 1, 1], _ ; check quantity
			["Swall", 					"SuperWallBreaker", 			 11, 1, 1], _ ; check quantity
			["Swiza", 					"SuperWizard",					 12, 3, 1], _ ; check quantity missing xml
			["Svalk", 					"SuperValkyrie",				 12, 1, 1], _ ; check quantity missing xml
			["Switc", 					"SuperWitch", 					 12, 1, 1]]   ; check quantity


	Local $BattleChallenges[21][5] = [ _
			["StarC", 					"Star Collector", 				 3,  1, 8], _ ; Collect a total of 6-18 stars from Multiplayer Battles			|8h-2d	|100-600
			["Destruction", 			"Lord of Destruction", 			 3,  1, 8], _ ; Gather a total of 100%-500% destruction from Multi Battles		|8h-2d	|100-600
			["PileOfVictores", 			"Pile Of Victories", 			 3,  1, 8], _ ; Win 2-8 Multiplayer Battles										|8h-2d	|100-600
			["StarThree", 				"Hunt for Three Stars", 		10,  5, 8], _ ; Score a perfect 3 Stars in Multiplayer Battles					|8h 	|200
			["WinningStreak", 			"Winning Streak", 				 9,  5, 8], _ ; Win 2-8 Multiplayer Battles in a row							|8h-2d	|100-600
			["SlayingTitans", 			"Slaying The Titans", 			11,  2, 5], _ ; Win 5 Multiplayer Battles In Tital LEague						|5h		|300
			["NoHero", 					"No Heroics Allowed", 			 3,  5, 8], _ ; Win stars without using Heroes									|8h		|100
			["NoMagic", 				"No-Magic Zone", 				 3,  5, 8], _ ; Win stars without using Spells									|8h		|100
			["Scrappy6s", 				"Scrappy 6s", 					 6,  5, 8], _ ; Gain 3 Stars Against Town Hall level 6							|8h		|200
			["Super7s", 				"Super 7s", 					 7,  5, 8], _ ; Gain 3 Stars Against Town Hall level 7							|8h		|200
			["Exciting8s", 				"Exciting 8s", 					 8,  5, 8], _ ; Gain 3 Stars Against Town Hall level 8							|8h		|200
			["Noble9s", 				"Noble 9s", 					 9,  5, 8], _ ; Gain 3 Stars Against Town Hall level 9							|8h		|200
			["Terrific10s", 			"Terrific 10s", 				10,  5, 8], _ ; Gain 3 Stars Against Town Hall level 10							|8h		|200
			["Exotic11s", 			    "Exotic 11s", 					11,  5, 8], _ ; Gain 3 Stars Against Town Hall level 11							|8h		|200
			["Triumphant12s", 			"Triumphant 12s", 				12,  5, 8], _ ; Gain 3 Stars Against Town Hall level 12							|8h		|200
			["Tremendous13s", 			"Tremendous 13s", 				13,  5, 8], _ ;
			["AttackUp", 				"Attack Up", 					 3,  5, 8], _ ; Gain 3 Stars Against Town Hall a level higher					|8h		|200
			["ClashOfLegends", 			"Clash of Legends", 			11,  5, 5], _ ;
			["GainStarsFromClanWars",	"3 Stars From Clan War",		 6,  0, 5], _ ;
			["SpeedyStars", 			"3 Stars in 60 seconds",		 6,  2, 5], _
			["Formidable14s", 			"Formidable 14s",				13,  2, 5]]

	Local $DestructionChallenges[34][5] = [ _
			["Cannon", 					"Cannon Carnage", 				 3,  1, 1], _ ; Destroy 5-25 Cannons in Multiplayer Battles					|1h-8h	|75-350
			["ArcherT", 				"Archer Tower Assault", 		 3,  1, 1], _ ; Destroy 5-20 Archer Towers in Multiplayer Battles			|1h-8h	|75-350
			["Mortar", 					"Mortar Mauling", 				 3,  1, 1], _ ; Destroy 4-12 Mortars in Multiplayer Battles					|1h-8h	|40-350
			["AirD", 					"Destroy Air Defenses", 		 7,  1, 1], _ ; Destroy 3-12 Air Defenses in Multiplayer Battles			|1h-8h	|40-350
			["WizardT", 				"Wizard Tower Warfare", 		 3,  1, 1], _ ; Destroy 4-12 Wizard Towers in Multiplayer Battles			|1h-8h	|40-350
			["AirSweepers", 			"Destroy Air Sweepers", 		 8,  1, 1], _ ; Destroy 2-6 Air Sweepers in Multiplayer Battles				|1h-8h	|40-350
			["Tesla", 					"Destroy Tesla Towers", 		 7,  1, 1], _ ; Destroy 4-12 Hidden Teslas in Multiplayer Battles			|1h-8h	|50-350
			["BombT", 					"Destroy Bomb Towers", 			 8,  1, 1], _ ; Destroy 2 Bomb Towers in Multiplayer Battles				|1h-8h	|50-350
			["Xbow", 					"Destroy X-Bows", 				 9,  1, 1], _ ; Destroy 3-12 X-Bows in Multiplayer Battles					|1h-8h	|50-350
			["Inferno", 				"Destroy Inferno Towers", 		11,  1, 1], _ ; Destroy 2 Inferno Towers in Multiplayer Battles				|1h-2d	|50-600
			["EagleA", 					"Eagle Artillery Elimination", 	11,  1, 1], _ ; Destroy 1-7 Eagle Artillery in Multiplayer Battles			|1h-2d	|50-600
			["ClanC", 					"Clan Castle Charge", 			 5,  1, 1], _ ; Destroy 1-4 Clan Castle in Multiplayer Battles				|1h-8h	|40-350
			["GoldSRaid", 				"Gold Storage Raid", 			 3,  1, 1], _ ; Destroy 3-15 Gold Storages in Multiplayer Battles			|1h-8h	|40-350
			["ElixirSRaid", 			"Elixir Storage Raid", 			 3,  1, 1], _ ; Destroy 3-15 Elixir Storages in Multiplayer Battles			|1h-8h	|40-350
			["DarkEStorageRaid", 		"Dark Elixir Storage Raid", 	 8,  1, 1], _ ; Destroy 1-4 Dark Elixir Storage in Multiplayer Battles		|1h-8h	|40-350
			["GoldM", 					"Gold Mine Mayhem", 			 3,  1, 1], _ ; Destroy 6-20 Gold Mines in Multiplayer Battles				|1h-8h	|40-350
			["ElixirPump", 				"Elixir Pump Elimination", 		 3,  1, 1], _ ; Destroy 6-20 Elixir Collectors in Multiplayer Battles		|1h-8h	|40-350
			["DarkEPlumbers", 			"Dark Elixir Plumbers", 		 3,  1, 1], _ ; Destroy 2-8 Dark Elixir Drills in Multiplayer Battles		|1h-8h	|40-350
			["Laboratory", 				"Laboratory Strike", 			 3,  1, 1], _ ; Destroy 2-6 Laboratories in Multiplayer Battles				|1h-8h	|40-200
			["SFacto", 					"Spell Factory Sabotage", 		 3,  1, 1], _ ; Destroy 2-6 Spell Factories in Multiplayer Battles			|1h-8h	|40-200
			["DESpell", 				"Dark Spell Factory Sabotage", 	 8,  1, 1], _ ; Destroy 2-6 Dark Spell Factories in Multiplayer Battles		|1h-8h	|40-200
			["WallWhacker", 			"Wall Whacker", 				 3,  5, 1], _ ; Destroy 50-250 Walls in Multiplayer Battles					|
			["BBreakdown",	 			"Building Breakdown", 			 3,  1, 1], _ ; Destroy 50-250 Buildings in Multiplayer Battles					|
			["BKaltar", 				"Destroy Barbarian King Altars", 9,  4, 1], _ ; Destroy 2-5 Barbarian King Altars in Multiplayer Battles	|1h-8h	|50-150
			["AQaltar", 				"Destroy Archer Queen Altars", 	10,  5, 1], _ ; Destroy 2-5 Archer Queen Altars in Multiplayer Battles		|1h-8h	|50-150
			["GWaltar", 				"Destroy Grand Warden Altars", 	11,  5, 1], _ ; Destroy 2-5 Grand Warden Altars in Multiplayer Battles		|1h-8h	|50-150
			["HeroLevelHunter", 		"Hero Level Hunter", 			 9,  5, 8], _ ; Knockout 125 Level Heroes on Multiplayer Battles			|8h		|100
			["KingLevelHunter", 		"King Level Hunter", 			 9,  5, 8], _ ; Knockout 50 Level King on Multiplayer Battles				|8h		|100
			["QueenLevelHunt", 			"Queen Level Hunter", 			10,  5, 8], _ ; Knockout 50 Level Queen on Multiplayer Battles				|8h		|100
			["WardenLevelHunter", 		"Warden Level Hunter", 			11,  5, 8], _ ; Knockout 20 Level Warden on Multiplayer Battles				|8h		|100
			["ScatterShotSabotage",		"Destroy ScatterShot",			13,  1, 1], _
			["UnhappyCamper",			"Destroy Army Camps",			 6,  1, 1], _
			["BuilderBasher",			"Builder Basher",				 6,  1, 1], _
			["ChampionLevelHunter",		"Champion Level Hunter",		12,  1, 1]]


	Local $MiscChallenges[8][5] = [ _
			["Gard", 					"Gardening Exercise", 			 3,  0, 8], _ ; Clear 5 obstacles from your Home Village or Builder Base		|8h	|50
			["DonateSpell", 			"Donate Spells", 				 9,  5, 8], _ ; Donate a total of 10 housing space worth of spells				|8h	|50
			["DonateTroop", 			"Helping Hand", 				 6,  5, 8], _ ; Donate a total of 100 housing space worth of troops				|8h	|50
			["BattleBlimpBoogie", 		"Battle Blimp", 				10,  0, 1], _ ; Earn 2-4 Stars from Multiplayer Battles using 1 Battle Blimp	|3h-8h	|40-300
			["WallWreckerWallop", 		"Wall Wrecker", 				10,  0, 1], _ ; Earn 2-5 Stars from Multiplayer Battles using 1 Wall Wrecker 	|3h-8h	|40-100
			["SmashAndGrab",	 		"Stone Slammer", 				10,  0, 1], _ ;
			["FlyingFortress", 			"Siege Barrack", 				10,  0, 1], _
			["UnleashTheLog", 			"Log Launcher", 				10,  0, 1]]   ;

   Local $SpellChallenges[12][5] = [ _
			["LSpell", 					"Lightning", 					 6,  1, 1], _ ;
			["HSpell", 					"Heal",							 6,  2, 1], _ ;
			["RSpell", 					"Rage", 					 	 6,  2, 1], _ ;
			["JSpell", 					"Jump", 					 	 6,  1, 1], _ ; x
			["FSpell", 					"Freeze", 					 	 9,  2, 1], _ ;
			["CSpell", 					"Clone", 					 	11,  1, 1], _ ; x
			["ISpell", 					"Invisibility", 				12,  1, 1], _ ; x
			["PSpell", 					"Poison", 					 	 6,  1, 1], _ ; x
			["ESpell", 					"Earthquake", 					 6,  1, 1], _ ; x
			["HaSpell", 				"Haste", 					 	 6,  2, 1], _ ;
			["SkSpell",					"Skeleton", 					11,  2, 1], _ ;
			["BtSpell",					"Bat", 					 		10,  1, 1]]   ; x



	Local $NightChallenges[31][5] = [ _
		["ArcherTowerAvengers",			"Archer Tower Avengers",		 6,  1, 1], _
		["BattleStarMaster",			"Battle Star Master",			 6,  1, 1], _
		["BattleDestructor",			"Battle Destructor",			 6,  1, 1], _
		["BattleVictories",				"Battle Victories",				 6,  0, 1], _
		["SuddenStars",					"Sudden Stars",					 6,  1, 1], _
		["BuilderHallBlowUp",			"Builder Hall Blow Up",			 6,  1, 1], _
		["DoubleCannonTrouble",			"Double Cannon Trouble",		 6,  1, 1], _
		["FirecrackerTackle",			"Firecracker Tackle",			 6,  1, 1], _
		["CrushingtheCrushers",			"Crushing the Crushers",		 6,  1, 1], _
		["BombsAway",					"Bombs Away",					 6,  1, 1], _
		["UnguardingthePosts",			"Unguarding the Posts",			 6,  1, 1], _
		["FireAllBarrels",				"Fire All Barrels",				 6,  1, 1], _
		["FiremanonDuty",				"Fireman on Duty",				 6,  1, 1], _
		["GiantProblem",				"Giant Problem",				 6,  1, 1], _
		["ShockingTurnofEvents",		"Shocking Turn of Events",		 6,  1, 1], _
		["BreakingGlass",				"Breaking Glass",				 6,  1, 1], _
		["GemHeist",					"Gem Heist",					 6,  1, 1], _
		["UnwindingClockTowers",		"Unwinding Clock Towers",		 6,  1, 1], _
		["BuildingBoomBoom",			"Building Boom Boom",			 6,  1, 1], _
		["WallWipeOut",					"Wall Wipe Out",				 6,  1, 1], _
		["RagedBarbarianRampage",		"Raged Barbarian Rampage",		 6,  0, 1], _
		["SneakyArcherSnipehunt",		"Sneaky Archer Snipe hunt",		 6,  0, 1], _
		["BoxerGiantPunchUp",			"Boxer Giant Punch Up",			 6,  1, 1], _
		["BabyDragonBamboozle",			"Baby Dragon Bamboozle",		 6,  0, 1], _
		["CannonCartCruise",			"Cannon Cart Cruise",			 6,  0, 1], _
		["NightWitchBatocalypse",		"Night Witch Batocalypse",		 6,  0, 1], _
		["DropShipNightRide",			"Drop Ship Night Ride",			 6,  0, 1], _
		["MegaPekkaSmashEmUp",			"Mega Pekka Smash Em Up",		 6,  1, 1], _
		["BomberBlowEmUp",				"Bomber Blow Em Up",			 6,  1, 1], _
		["BetaMinionBrawl",				"Beta Minion Brawl",			 6,  0, 1], _
		["LauncherStomp",				"Launcher Stomp",				 6,  0, 1]]


	; Just in Case
	Local $LocalINI = $sINIPath
	If $LocalINI = "" Then $LocalINI = StringReplace($g_sProfileConfigPath, "config.ini", "ClanGames_config.ini")

	If $bDebug Then Setlog(" - Ini Path: " & $LocalINI)

	; Variables to use
	Local $section[5] = ["Loot Challenges", "Battle Challenges", "Destruction Challenges", "Misc Challenges", "Night Challenges"]
	Local $array[5] = [$LootChallenges, $BattleChallenges, $DestructionChallenges, $MiscChallenges, $NightChallenges]
	Local $ResultIni = "", $TempChallenge, $tempXSector

	; Store variables
	If Not $makeIni Then

		Switch $sReturnArray
			Case "$AirTroopChallenges"
				Return $AirTroopChallenges
			Case "$GroundTroopChallenges"
				Return $GroundTroopChallenges
			Case "$SpellChallenges"
				Return $SpellChallenges
			Case "$LootChallenges"
				$TempChallenge = $array[0]
				$tempXSector = $section[0]
			Case "$BattleChallenges"
				$TempChallenge = $array[1]
				$tempXSector = $section[1]
			Case "$DestructionChallenges"
				$TempChallenge = $array[2]
				$tempXSector = $section[2]
			Case "$MiscChallenges"
				$TempChallenge = $array[3]
				$tempXSector = $section[3]
			Case "$NightChallenges"
				$TempChallenge = $array[4]
				$tempXSector = $section[4]
		EndSwitch
		; Read INI File
		If $bDebug Then SetLog("[" & $tempXSector & "]")
		For $j = 0 To UBound($TempChallenge) - 1
			$ResultIni = Int(IniRead($LocalINI, $tempXSector, $TempChallenge[$j][1], $TempChallenge[$j][3]))
			$TempChallenge[$j][3] = IsNumber($ResultIni) = 1 ? Int($ResultIni) : 0
			If $TempChallenge[$j][3] > 5 Then $TempChallenge[$j][3] = 5
			If $TempChallenge[$j][3] < 0 Then $TempChallenge[$j][3] = 0
			If $bDebug Then SetLog(" - " & $TempChallenge[$j][1] & ": " & $TempChallenge[$j][3])
			$ResultIni = ""
		Next
		Return $TempChallenge
	Else

		; Write INI File
		Local $File = FileOpen($LocalINI, $FO_APPEND)
		Local $HelpText = "; - MyBotRun 2020 - " & @CRLF & _
				"; - 'Event name' = 'Priority' [1~5][easiest to the hardest] , '0' to disable the event" & @CRLF & _
				"; - Remember on GUI you can enable/disable an entire Section" & @CRLF & _
				"; - Do not change any event name" & @CRLF & _
				"; - Deleting this file will restore the defaults values." & @CRLF & @CRLF
		FileWrite($File, $HelpText)
		FileClose($File)
		For $i = 0 To UBound($array) - 1
			$TempChallenge = $array[$i]
			If $bDebug Then Setlog("[" & $section[$i] & "]")
			For $j = 0 To UBound($TempChallenge) - 1
				If IniWrite($LocalINI, $section[$i], $TempChallenge[$j][1], $TempChallenge[$j][3]) <> 1 Then SetLog("Error on :" & $section[$i] & "|" & $TempChallenge[$j][1], $COLOR_WARNING)
				If $bDebug Then SetLog(" - " & $TempChallenge[$j][1] & ": " & $TempChallenge[$j][3])
				If _sleep(100) Then Return
			Next
			$TempChallenge = Null
		Next
	EndIf
EndFunc   ;==>ClanGamesChallenges


; start new BB challenge or confirm a existing valid challenge - returns True
; all others Return False
Func _BBClanGames($bNewEvent = False)

	Local $test = False

	; Check If this Night Village is Enable on GUI.
	If Not $g_bChkClanGamesNightVillage Then Return

   ; Check if games has been completed
   If $g_bClanGamesCompleted Then
	  SetLog("Clan Games has already been completed")
	  Return
   EndIf

	Local $sINIPath = StringReplace($g_sProfileConfigPath, "config.ini", "ClanGames_config.ini")
	If Not FileExists($sINIPath) Then ClanGamesChallenges("", True, $sINIPath, $g_bChkClanGamesDebug)

	; A user Log and a Click away just in case
	ClickAway()
	SetLog("Entering Clan Games", $COLOR_INFO)
	If _Sleep(2000) Then Return

	; Local and Static Variables
	Local $TabChallengesPosition[2] = [820, 130]
	Local $sTimeRemain = "", $sEventName = "", $getCapture = True
	Local Static $YourAccScore[8][2] = [[-1, True], [-1, True], [-1, True], [-1, True], [-1, True], [-1, True], [-1, True], [-1, True]]

	; Check for BS/CoC errors just in case
	If isProblemAffect(True) Then checkMainScreen(False)

	; Initial Timer
	Local $hTimer = TimerInit()

	; Enter on Clan Games window
	If Not IsClanGamesWindow() Then Return

	If $g_bChkClanGamesDebug Then SetLog("_ClanGames IsClanGamesWindow (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds)", $COLOR_INFO)
	$hTimer = TimerInit()

	; Let's get some information , like Remain Timer, Score and limit
	Local $aiScoreLimit = GetTimesAndScores()
	If $aiScoreLimit = -1 Or UBound($aiScoreLimit) <> 2 Then
	   ; if no score then Return
	   ; assume games over - more checks would be better
	   ; disable clan from now on
	   SetLog("Can't find your score - going to assume clan games ended")
		$g_bClanGamesCompleted = True
		$g_sActiveEventName = ""

		If Not CollectClanGamesRewards() Then ClickAway()

		Return
	EndIf

	If $g_bChkClanGamesDebug Then Setlog("_ClanGames GetTimesAndScores (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds)", $COLOR_INFO)
	$hTimer = TimerInit()

	; Small delay
	If _Sleep(1500) Then Return

	SetLog("Your Score is: " & $aiScoreLimit[0], $COLOR_INFO)

	If $aiScoreLimit[0] = $aiScoreLimit[1] Then
		SetLog("Your score limit is reached! Congrats")
		ClickAway()
		; disable clan from now on
		$g_bClanGamesCompleted = True
		$g_sActiveEventName = ""
		Return
	ElseIf $aiScoreLimit[0] + 200 > $aiScoreLimit[1] Then
		SetLog("Your Score limit is almost reached")
		If $g_bChkClanGamesStopBeforeReachAndPurge Then
			If CooldownTime() Or IsEventRunning() Then Return
			SetLog("Stop before completing your limit and only Purge")
			$sEventName = "Builder Base Challenges to Purge"
			If PurgeEvent($g_sImgPurge, $sEventName, True) Then $g_iPurgeJobCount[$g_iCurAccount] += 1
			ClickAway()
			Return
		EndIf
	EndIf

	If $YourAccScore[$g_iCurAccount][0] = -1 Then $YourAccScore[$g_iCurAccount][0] = $aiScoreLimit[0]

	;check cooldown purge
	If CooldownTime() Then Return

	If $g_bChkClanGamesDebug Then Setlog("_ClanGames CooldownTime (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds)", $COLOR_INFO)
	$hTimer = TimerInit()

	If Not $g_bRunState Then Return

	;check if event is running and if there is any issues
	If IsEventRunning() Then Return False

;	If IsEventRunning() Then
;		; check if it is a BB challenge
;		If StringInStr($g_sActiveEventName, "BBB", $STR_CASESENSE) Then
;			SetLog("main village Challenge active")
;			Return True
;		EndIf
;	Else
;		SetLog("main village Challenge active")
;		Return False
;	EndIf

	If $g_bChkClanGamesDebug Then Setlog("_ClanGames IsEventRunning (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds)", $COLOR_INFO)
	$hTimer = TimerInit()

	; done checking only proceed if new event is needed
	;If Not $bNewEvent Then Return False
	If Not $bNewEvent Then
		SetLog("Challenge cleared")
		ClickAway()
		If _Sleep(1000) Then Return
		Return
	EndIf

	If Not $g_bRunState Then Return

	If $g_bChkClanGamesDebug Then SetLog("Your TownHall Level is " & $g_iTownHallLevel)

	; Check for BS/CoC errors just in case
	If isProblemAffect(True) Then checkMainScreen(False)

	UpdateStats()

	If $g_bChkClanGamesDebugImages Then ClanGamesDebugImages()

	; Let's selected only the necessary images [Total=71]
	Local $sImagePath = @ScriptDir & "\imgxml\Resources\ClanGamesImages\Challenges"
	Local $sTempPath = @TempDir & "\" & $g_sProfileCurrentName & "\Challenges\"

	FileCopy($sImagePath & "\N-*.*", $sTempPath, $FC_OVERWRITE + $FC_CREATEPATH)

	Local $HowManyImages = _FileListToArray($sTempPath, "*", $FLTA_FILES)

	If IsArray($HowManyImages) Then
		Setlog($HowManyImages[0] & " Events to search")
	Else
		Setlog("ClanGames-Error on $HowManyImages: " & @error)
	EndIf

	Setlog("Image Searching BB event and build array")

	; To store the detections
	; [0]=ChallengeName [1]=EventName [2]=Xaxis [3]=Yaxis
	Local $aAllDetectionsOnScreen[0][5]

	Local $sClanGamesWindow = GetDiamondFromRect("300,155,765,550")
	Local $aCurrentDetection = findMultiple($sTempPath, $sClanGamesWindow, $sClanGamesWindow, 0, 1000, 0, "objectname,objectpoints", True)
	Local $aEachDetection

	If $g_bChkClanGamesDebug Then Setlog("_ClanGames findMultiple (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds)", $COLOR_INFO)
	$hTimer = TimerInit()

	; Let's split Names and Coordinates and populate a new array
	If UBound($aCurrentDetection) > 0 Then

		; Temp Variables
		Local $FullImageName, $StringCoordinates, $sString, $tempObbj, $tempObbjs, $aNames

		For $i = 0 To UBound($aCurrentDetection) - 1
			If _Sleep(50) Then Return ; just in case of PAUSE
			If Not $g_bRunState Then Return ; Stop Button

			$aEachDetection = $aCurrentDetection[$i]
			; Justto debug
			;SetDebugLog(_ArrayToString($aEachDetection))
			SetLog(_ArrayToString($aEachDetection))

			;_ArrayDisplay($aEachDetection, "$aEachDetection")

			$FullImageName = String($aEachDetection[0])
			$StringCoordinates = $aEachDetection[1]

			If $FullImageName = "" Or $StringCoordinates = "" Then ContinueLoop

			; Exist more than One coordinate!?
			If StringInStr($StringCoordinates, "|") Then
				; Code to test the string if exist anomalies on string
				$StringCoordinates = StringReplace($StringCoordinates, "||", "|")
				$sString = StringRight($StringCoordinates, 1)
				If $sString = "|" Then $StringCoordinates = StringTrimRight($StringCoordinates, 1)
				; Split the coordinates
				$tempObbjs = StringSplit($StringCoordinates, "|", $STR_NOCOUNT)
				; Just get the first [0]
				$tempObbj = StringSplit($tempObbjs[0], ",", $STR_NOCOUNT) ;  will be a string : 708,360
				If UBound($tempObbj) <> 2 Then ContinueLoop
			Else
				$tempObbj = StringSplit($StringCoordinates, ",", $STR_NOCOUNT) ;  will be a string : 708,360
				If UBound($tempObbj) <> 2 Then ContinueLoop
			EndIf

			$aNames = StringSplit($FullImageName, "-", $STR_NOCOUNT)

			;SetLog("$FullImageName : " & $FullImageName)
			;SetLog("$aNames[0] : " & $aNames[0])
			;SetLog("$aNames[1] : " & $aNames[1])

			ReDim $aAllDetectionsOnScreen[UBound($aAllDetectionsOnScreen) + 1][5]
			$aAllDetectionsOnScreen[UBound($aAllDetectionsOnScreen) - 1][0] = $aNames[0] ; Challenge Name
			$aAllDetectionsOnScreen[UBound($aAllDetectionsOnScreen) - 1][1] = $aNames[1] ; Event Name
			$aAllDetectionsOnScreen[UBound($aAllDetectionsOnScreen) - 1][2] = $tempObbj[0] ; Xaxis
			$aAllDetectionsOnScreen[UBound($aAllDetectionsOnScreen) - 1][3] = $tempObbj[1] ; Yaxis
			$aAllDetectionsOnScreen[UBound($aAllDetectionsOnScreen) - 1][4] = $FullImageName ; full filename
		Next
	EndIf

	Setlog("Search Array")

	Local $aSelectChallenges[0][6]
	Local $aNightVillageChallenges[0][3]

	If UBound($aAllDetectionsOnScreen) > 0 Then
		For $i = 0 To UBound($aAllDetectionsOnScreen) - 1

			SetLog("Found Challenge: " & $aAllDetectionsOnScreen[$i][1], $COLOR_WARNING)

			If IsBBChallenge($aAllDetectionsOnScreen[$i][2], $aAllDetectionsOnScreen[$i][3]) Then

				SetLog("Night Village Challenge: " & $aAllDetectionsOnScreen[$i][1], $COLOR_WARNING)

				ReDim $aNightVillageChallenges[UBound($aNightVillageChallenges) + 1][3]
				$aNightVillageChallenges[UBound($aNightVillageChallenges) - 1][0]=$aAllDetectionsOnScreen[$i][4] ; full image name
				$aNightVillageChallenges[UBound($aNightVillageChallenges) - 1][1]=$aAllDetectionsOnScreen[$i][2] ; X axis
				$aNightVillageChallenges[UBound($aNightVillageChallenges) - 1][2]=$aAllDetectionsOnScreen[$i][3] ; Y axis

				If $aAllDetectionsOnScreen[$i][0] = "N" Then
					;If Not $g_bChkClanGamesDestruction Then ContinueLoop
					;[0] = Path Directory , [1] = Event Name , [2] = TH level , [3] = Difficulty Level , [4] = Time to do it
					Local $NightChallenges = ClanGamesChallenges("$NightChallenges", False, $sINIPath, $g_bChkClanGamesDebug)
					For $j = 0 To UBound($NightChallenges) - 1
						; Match the names
						If $aAllDetectionsOnScreen[$i][1] = $NightChallenges[$j][0] Then

							; Disable this event from INI File
							If $NightChallenges[$j][3] = 0 Then ExitLoop

							; [0]Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] difficulty
							Local $aArray[5] = [$NightChallenges[$j][1], $aAllDetectionsOnScreen[$i][2], $aAllDetectionsOnScreen[$i][3], $NightChallenges[$j][3], $aAllDetectionsOnScreen[$i][4]]
						EndIf
					Next
				EndIf
			EndIf

			If IsDeclared("aArray") And $aArray[0] <> "" Then
				ReDim $aSelectChallenges[UBound($aSelectChallenges) + 1][6]
				$aSelectChallenges[UBound($aSelectChallenges) - 1][0] = $aArray[0] ; Event Name Full Name
				$aSelectChallenges[UBound($aSelectChallenges) - 1][1] = $aArray[1] ; Xaxis
				$aSelectChallenges[UBound($aSelectChallenges) - 1][2] = $aArray[2] ; Yaxis
				$aSelectChallenges[UBound($aSelectChallenges) - 1][3] = $aArray[3] ; difficulty
				$aSelectChallenges[UBound($aSelectChallenges) - 1][4] = 0 ; timer minutes
				$aSelectChallenges[UBound($aSelectChallenges) - 1][5] = $aArray[4] ; full filename
				$aArray[0] = ""
			EndIf
		Next
	EndIf

	; Remove the temp  images Folder
	DirRemove($sTempPath, $DIR_REMOVE)

	If $g_bChkClanGamesDebug Then Setlog("_ClanGames aAllDetectionsOnScreen (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds)", $COLOR_INFO)
	$hTimer = TimerInit()

	; Sort by Yaxis , TOP to Bottom
	_ArraySort($aSelectChallenges, 0, 0, 0, 2)

	#cs
	If UBound($aSelectChallenges) > 0 Then
		; let's get the Event timing
		For $i = 0 To UBound($aSelectChallenges) - 1
			Setlog("Detected " & $aSelectChallenges[$i][0] & " difficulty of " & $aSelectChallenges[$i][3])
			Click($aSelectChallenges[$i][1], $aSelectChallenges[$i][2])
			If _Sleep(1500) Then Return
			Local $EventHours = GetEventInformation()
			Setlog("Time: " & $EventHours & " min", $COLOR_INFO)
			Click($aSelectChallenges[$i][1], $aSelectChallenges[$i][2])
			If _Sleep(250) Then Return
			$aSelectChallenges[$i][4] = Number($EventHours)
		Next

		; let's get the 60 minutes events and remove from array
		Local $aTempSelectChallenges[0][6]
		For $i = 0 To UBound($aSelectChallenges) - 1
			If $aSelectChallenges[$i][4] = 60 And $g_bChkClanGames60 Then
				Setlog($aSelectChallenges[$i][0] & " unselected, is a 60min event!", $COLOR_INFO)
				ContinueLoop
			EndIf
			ReDim $aTempSelectChallenges[UBound($aTempSelectChallenges) + 1][6]
			$aTempSelectChallenges[UBound($aTempSelectChallenges) - 1][0] = $aSelectChallenges[$i][0]
			$aTempSelectChallenges[UBound($aTempSelectChallenges) - 1][1] = $aSelectChallenges[$i][1]
			$aTempSelectChallenges[UBound($aTempSelectChallenges) - 1][2] = $aSelectChallenges[$i][2]
			$aTempSelectChallenges[UBound($aTempSelectChallenges) - 1][3] = $aSelectChallenges[$i][3]
			$aTempSelectChallenges[UBound($aTempSelectChallenges) - 1][4] = $aSelectChallenges[$i][4]
			$aTempSelectChallenges[UBound($aTempSelectChallenges) - 1][5] = $aSelectChallenges[$i][5]
		Next

		; Drop to top again , because coordinates Xaxis and Yaxis
		ClickP($TabChallengesPosition, 2, 0, "#Tab")
		If _sleep(250) Then Return
		ClickDrag(807, 210, 807, 385, 500)
		If _Sleep(500) Then Return
	EndIf

	; After removing is necessary check Ubound
	If IsDeclared("aTempSelectChallenges") Then
		If UBound($aTempSelectChallenges) > 0 Then
			SetDebugLog("$aTempSelectChallenges: " & _ArrayToString($aTempSelectChallenges))
			; Sort by difficulties
			_ArraySort($aTempSelectChallenges, 0, 0, 0, 3)

			Setlog("Next Event will be " & $aTempSelectChallenges[0][0] & " to make in " & $aTempSelectChallenges[0][4] & " min.")
			; Select and Start EVENT
			$sEventName = $aTempSelectChallenges[0][0]
			Click($aTempSelectChallenges[0][1], $aTempSelectChallenges[0][2])
			If _Sleep(1750) Then Return
			If $test Then Return
			If ClickOnEvent($YourAccScore, $aiScoreLimit, $sEventName, $getCapture) Then
			   $g_sActiveEventName = $aTempSelectChallenges[0][5]
			   SetLog("$g_sActiveEventName : " & $g_sActiveEventName)
			   Return True
			EndIf

			; Some error occurred let's click on Challenges Tab and proceeds
			ClickP($TabChallengesPosition, 2, 0, "#Tab")
			;ClickAway()
		EndIf
	EndIf
	#ce

	; After removing is necessary check Ubound
	If UBound($aSelectChallenges) > 0 Then
		SetDebugLog("$aSelectChallenges: " & _ArrayToString($aSelectChallenges))
		; Sort by difficulties
		_ArraySort($aSelectChallenges, 0, 0, 0, 3)

		Setlog("Next Event will be " & $aSelectChallenges[0][0] & " to make in " & $aSelectChallenges[0][4] & " min.")
		; Select and Start EVENT
		$sEventName = $aSelectChallenges[0][0]
		Click($aSelectChallenges[0][1], $aSelectChallenges[0][2])
		If _Sleep(1750) Then Return
		If $test Then Return
		If ClickOnEvent($YourAccScore, $aiScoreLimit, $sEventName, $getCapture) Then
			$g_sActiveEventName = $aSelectChallenges[0][5]
			SetLog("$g_sActiveEventName : " & $g_sActiveEventName)
			If _Sleep(250) Then Return
		   Return True
		EndIf

		; Some error occurred let's click on Challenges Tab and proceeds
		ClickP($TabChallengesPosition, 2, 0, "#Tab")
		;ClickAway()
	EndIf

	; Lets test the Builder Base Challenges
	If $g_bChkClanGamesPurgeNight Then

		SetLog("Purge Night Village Challenge", $COLOR_WARNING)
		PurgeVillageEvent($aNightVillageChallenges, $g_sImgPurge, "Purge Night Village Event")

		;If $g_iPurgeJobCount[$g_iCurAccount] + 1 < $g_iPurgeMax Or $g_iPurgeMax = 0 Then
		;	Local $Txt = $g_iPurgeMax
		;	If $g_iPurgeMax = 0 Then $Txt = "Unlimited"
		;	SetLog("Current Purge Jobs " & $g_iPurgeJobCount[$g_iCurAccount] + 1 & " at max of " & $Txt, $COLOR_INFO)
		;	$sEventName = "Builder Base Challenges to Purge"
		;	If PurgeEvent($g_sImgPurge, $sEventName, True) Then
		;		$g_iPurgeJobCount[$g_iCurAccount] += 1
		;	Else
		;		SetLog("No BB event found")
		;		ClickAway()
		;		If _Sleep(1000) Then Return
		;	EndIf
		;EndIf
		Return
	EndIf

	SetLog("No Event found, Check your settings", $COLOR_WARNING)
	ClickAway()
	If _Sleep(2000) Then Return

	Return False
EndFunc   ;==>_BBClanGames

; call clan games to select BB challenge
; while challenge is still active
;  run attack for x
;  if event complete exit - need to check from Main Village
Func BBClanGames()
	If Not $g_bChkClanGamesNightVillage Then Return

	Local $bResult = False


	SetLog("Let's do a BB challenge!")
	; search for a new challenege
	If Not _BBClanGames(True) Then
		SetLog("Cannot new select BB Challenge!")
		SetLog("Active challenge name : " & $g_sActiveEventName)

		If $g_sActiveEventName = "" Then
			SetLog("Some is not right!")
			Return
		ElseIf Not StringInStr($g_sActiveEventName, "N-", $STR_CASESENSE) Then
			SetLog("main village challenge active")
			Return
		Else
			SetLog("BB challenge active - let's finish it!")
		EndIf
	EndIf

	;$g_sActiveEventName="N-StarM"
	Local $bNewEvent = False
	Local $iMinAttacks = 0
	Local $iMaxAttacks = 0

	; number of attacks based on the time to complete the event 3h, 8h, or 1d
	If $g_iEventTime > 0 And $g_iEventTime < 181 Then
		$iMinAttacks = 1
		$iMaxAttacks = 2
	ElseIf $g_iEventTime > 180 And $g_iEventTime < 481 Then
		$iMinAttacks = 3
		$iMaxAttacks = 4
	ElseIf $g_iEventTime > 1440 Then
		$iMinAttacks = 5
		$iMaxAttacks = 6
	Else
		$iMinAttacks = 1
		$iMaxAttacks = 3
	EndIf

	Local $iN = Random($iMaxAttacks, $iMaxAttacks, 1)

	While 1 ; infinte loop - exit conditions failed to attack or completed challenge
		; switch to BB
		If SwitchBetweenBases() And IsOnBuilderBase() Then

			SetLog("Target number of BB attacks : " & $iN)
			If _Sleep(1500) Then Return
			; do 5 attacks
			If Not AttackBB($iN) Then
				; something has gone wrong reset the ActiveEventName so will be delete
				$g_sActiveEventName = ""
				$bResult = False
				ExitLoop
			EndIf

		EndIf

		SetLog("AttackBB ended check the state of Challenge")
		; switch to main village
		SwitchBetweenBases()
		If _Sleep(1500) Then Return

		; check if Challenge completed
		If Not _BBClanGames($bNewEvent) Then
			SetLog("$g_sActiveEventName : " & $g_sActiveEventName)
			If Not StringInStr($g_sActiveEventName, "N-", $STR_CASESENSE) Then
				$bResult = True
				ExitLoop
			EndIf
		EndIf

		If _Sleep(1500) Then Return

		SetLog("Challenge incomplete")
		; Challenge incomplete let's do a couple more attacks, 1-3
		$iN = Random(1,2,1)

	Wend

	Return $bResult
EndFunc

#Tidy_Off

Func ClanGamesDebugImages()
	;Local $subDirectory = @ScriptDir & "\SmartFarm\"
	Local $subDirectory = $g_sProfileTempDebugPath & "\DebugImageClanGames\"

	DirCreate($subDirectory)

	; Create the timestamp and filename
	Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
	Local $Time = @HOUR & "." & @MIN & "." & @SEC
	Local $fileName = "ClanGames" & "_" & $Date & "_" & $Time & ".png"

	; Let's selected only the necessary images [Total=71]
	Local $sImagePath = @ScriptDir & "\imgxml\Resources\ClanGamesImages\Challenges"

	; To store the detections
	; [0]=ChallengeName [1]=EventName [2]=Xaxis [3]=Yaxis
	;Local $aAllDetectionsOnScreen[0][5]

	Local $sClanGamesWindow = GetDiamondFromRect("300,155,765,550")
	Local $aCurrentDetection = findMultiple($sImagePath, $sClanGamesWindow, $sClanGamesWindow, 0, 1000, 0, "objectname,objectpoints", True)
	Local $aEachDetection

	_CaptureRegion()

	; Store a copy of the image handle
	Local $editedImage = $g_hBitmap
	; Needed for editing the picture
	Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($editedImage)
	Local $hPen = _GDIPlus_PenCreate(0xFFFF0000, 2) ; Create a pencil Color FF0000/RED
	Local $hPen2 = _GDIPlus_PenCreate(0xFF000000, 2) ; Create a pencil Color FFFFFF/BLACK

	; Let's split Names and Coordinates and populate a new array
	If UBound($aCurrentDetection) > 0 Then

		; Temp Variables
		Local $FullImageName, $StringCoordinates, $sString, $tempObbj, $tempObbjs, $aNames

		For $i = 0 To UBound($aCurrentDetection) - 1
			If _Sleep(50) Then Return ; just in case of PAUSE
			If Not $g_bRunState Then Return ; Stop Button

			$aEachDetection = $aCurrentDetection[$i]
			; Justto debug
			;SetDebugLog(_ArrayToString($aEachDetection))
			SetLog(_ArrayToString($aEachDetection))

			;_ArrayDisplay($aEachDetection, "$aEachDetection")

			$FullImageName = String($aEachDetection[0])
			$StringCoordinates = $aEachDetection[1]

			If $FullImageName = "" Or $StringCoordinates = "" Then ContinueLoop

			; Exist more than One coordinate!?
			If StringInStr($StringCoordinates, "|") Then
				; Code to test the string if exist anomalies on string
				$StringCoordinates = StringReplace($StringCoordinates, "||", "|")
				$sString = StringRight($StringCoordinates, 1)
				If $sString = "|" Then $StringCoordinates = StringTrimRight($StringCoordinates, 1)
				; Split the coordinates
				$tempObbjs = StringSplit($StringCoordinates, "|", $STR_NOCOUNT)
				; Just get the first [0]
				$tempObbj = StringSplit($tempObbjs[0], ",", $STR_NOCOUNT) ;  will be a string : 708,360
				If UBound($tempObbj) <> 2 Then ContinueLoop
			Else
				$tempObbj = StringSplit($StringCoordinates, ",", $STR_NOCOUNT) ;  will be a string : 708,360
				If UBound($tempObbj) <> 2 Then ContinueLoop
			EndIf

			;$aNames = StringSplit($FullImageName, "-", $STR_NOCOUNT)

			;ReDim $aAllDetectionsOnScreen[UBound($aAllDetectionsOnScreen) + 1][5]
			;$aAllDetectionsOnScreen[UBound($aAllDetectionsOnScreen) - 1][0] = $aNames[0] ; Challenge Name
			;$aAllDetectionsOnScreen[UBound($aAllDetectionsOnScreen) - 1][1] = $aNames[1] ; Event Name
			;$aAllDetectionsOnScreen[UBound($aAllDetectionsOnScreen) - 1][2] = $tempObbj[0] ; Xaxis
			;$aAllDetectionsOnScreen[UBound($aAllDetectionsOnScreen) - 1][3] = $tempObbj[1] ; Yaxis
			;$aAllDetectionsOnScreen[UBound($aAllDetectionsOnScreen) - 1][4] =  ; full filename

			_GDIPlus_GraphicsDrawString($hGraphic, $FullImageName, $tempObbj[0], $tempObbj[1], "Arial", 6)
		Next
	EndIf

	;_CaptureRegion()

	;Local $tempObbj, $tempObbjs
	;For $i = 0 To UBound($aAllDetectionsOnScreen) - 1
		;_GDIPlus_GraphicsDrawRect($hGraphic, $aAllDetectionsOnScreen[$i][2], $aAllDetectionsOnScreen[$i][3], 10, 10, $hPen2)

	;Next

	; Save the image and release any memory
	_GDIPlus_ImageSaveToFile($editedImage, $subDirectory & $fileName)
	_GDIPlus_PenDispose($hPen)
	_GDIPlus_PenDispose($hPen2)
	_GDIPlus_GraphicsDispose($hGraphic)
	Setlog("Debug Image saved!")

EndFunc   ;==>DebugImageClanGames


; check rewards window open
; for i = 0 to 4
; select column i
; select reward
; press collect

; Return False if failed

#cs
	Local $aCollectButton[4] = [685, 525, 0xB5E57D, 20]
	SetLog("CollectButton : 0x" & _GetPixelColor(685, 525, True))

	If Not _CheckPixel($aCollectButton, True, Default, "CollectClanGamesRewards") Then
		SetLog("Collect Button InActive!")
		Return False
	EndIf

	SetLog("Found the Collect Button!")

	;Click(685, 540)
#ce

Func CollectClanGamesRewards($bTest = False)
	If Not $g_bChkClanGamesCollectRewards Then
		SetLog("Clan Games collect rewards disable!", $COLOR_DEBUG)
		Return False
	EndIf

	Local $aRewardsList[41][2] = [ _  ; books-1, gems-2, runes-3, shovel-4,  50gems-5, wall rings-6, full wall - 7, all other Pots - 8, 10gems - 9
		["BookOfEverything",		10], _
		["BookOfHero",				10], _
		["BookOfFighting",			10], _
		["BookOfBuilding",			10], _
		["BookOfSpell",				10], _
		["Gems",					20], _
		["RuneOfGold",				30], _
		["RuneOfElixir",			30], _
		["RuneOfDarkElixir",		30], _
		["RuneOfBuilderGold",		30], _
		["RuneOfBuilderElixir",		30], _
		["Shovel",					40], _
		["FullBookOfEverything",	50], _ ; 50 gems
		["FullBookOfHero",			50], _ ; 50 gems
		["FullBookOfFighting",		50], _ ; 50 gems
		["FullBookOfBuilding",		50], _ ; 50 gems
		["FullBookOfSpell",			50], _ ; 50 gems
		["FullRuneOfGold",			60], _ ; 50 gems
		["FullRuneOfElixir",		60], _ ; 50 gems
		["FullRuneOfDarkElixir",	60], _ ; 50 gems
		["FullRuneOfBuilderGold",	60], _ ; 50 gems
		["FullRuneOfBuilderElixir",	60], _ ; 50 gems
		["FullShovel",				70], _ ; 50 gems
		["FullWallRing",			70], _ ; ? gem
		["WallRing",				70], _
		["PotBuilder",				80], _ 
		["PotResearch",				80], _ 
		["PotClock",				80], _ 
		["PotBoost",				80], _ 
		["PotHero",					80], _
		["PotResources",			80], _ 
		["PotPower",				80], _ 
		["PotSuper",				80], _ 
		["FullPotBuilder",			90], _ ; 10 gems
		["FullPotResearch",			90], _ ; 10 gems
		["FullPotClock",			90], _ ; 10 gems
		["FullPotBoost",			90], _ ; 10 gems
		["FullPotHero",				90], _ ; 10 gems
		["FullPotResources",		90], _ ; 10 gems 
		["FullPotPower",			90], _ ; 10 gems
		["FullPotSuper",			90]]   ; 10 gems

	Local $aiColumn[4] = [248, 190, 333, 494]
	Local $iColumnWidth = 108
	Local $sImgClanGamesReceivedWindow = 	@ScriptDir & "\imgxml\Windows\ClanGamesReceivedWindow*"
	Local $sImgClanGamesRewardsTab = 		@ScriptDir & "\imgxml\Windows\ClanGamesRewardsTab*"
	Local $sImgClanGamesExtraRewardWindow = @ScriptDir & "\imgxml\Windows\ClanGamesExtraRewardWindow*"

	If Not IsWindowOpen($sImgClanGamesRewardsTab, 30, 200, GetDiamondFromRect("190,45,830,185")) Then
		SetLog("Failed to verify Rewards Window!")
		Return False
	EndIf

	SaveDebugImage("ClanGamesRewardsWindow", False)
	
	Local $sIniPath = $g_sProfilePath & "\" & $g_sProfileCurrentName & "\ClanGamesRewards.ini"
	Local $ResultIni
	
	Setlog(" - Ini Path: " & $sIniPath)

	If Not FileExists($sIniPath) Then
		; Write INI File
		Local $File = FileOpen($sIniPath, $FO_APPEND)
		Local $HelpText = "; - MyBotRun - Clan Games Rewards Priority List 2022 - " & @CRLF & _
				"; - 'Reward' = 'Priority' [1 to 99][highest to lowest] , if grouped then random from group" & @CRLF & _
				"; - Do not change any Reward name" & @CRLF & _
				"; - Deleting this file will restore the default values." & @CRLF & @CRLF
		FileWrite($File, $HelpText)
		FileClose($File)	
	
		For $j = 0 To UBound($aRewardsList) - 1
			If IniWrite($sIniPath, "Rewards", $aRewardsList[$j][0], $aRewardsList[$j][1]) Then SetLog("Error on writing RewardList", $COLOR_WARNING)
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

		If $bTest Then SaveDebugRectImage("CGRewardSearch",$aiColumn[0] & "," & $aiColumn[1] & "," & $aiColumn[2] & "," & $aiColumn[3])

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
			If IsWindowOpen($sImgClanGamesExtraRewardWindow, 10, 200, GetDiamondFromRect("570,505,830,570")) Then

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
			If IsWindowOpen($sImgClanGamesReceivedWindow, 10, 200, GetDiamondFromRect("225,150,800,595")) Then
				SetLog("Found Rewards Received Summary Window")

				SaveDebugImage("ClanGamesReceivedWindow", False)

				; click close window
				Click(817,83)

				If _Sleep(500) Then Return

				Return True
			EndIf

		EndIf

		;If _Sleep(250) Then Return

		If $i < 4 Then
			$aiColumn[0] = ($aiColumn[0] + $iColumnWidth)
			$aiColumn[2] = ($aiColumn[2] + $iColumnWidth)
		Else
			$aiColumn[0] = 743
			$aiColumn[1] = 190
			$aiColumn[2] = 838
			$aiColumn[3] = 494
		EndIf

		$i += 1
		
		If $i = 10 Then 
			$bLoop = False
			SaveDebugImage("ClanGamesRewardsWindow", False)
		EndIf
	Wend

	SetLog("Failed to locate Collect Rewards Button")

	Return False
EndFunc

Func SearchColumn($aiColumn, $aRewardsList)
	;If $sSearchArea = "" Then Return False

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

	;
	For $j = 0 to UBound($avRewards, $UBOUND_ROWS) - 1

		Local $avTempReward = $avRewards[$j]

		;SetLog("$avTempReward : " & $avTempReward[0] & " found at " & $avTempReward[1])

		For $k = 0 to UBound($aRewardsList) - 1
			;SetLog("$aRewardsList: " & $aRewardsList[$k][0] & " Piority " & $aRewardsList[$k][1])
			If $avTempReward[0] = $aRewardsList[$k][0] Then
				;SetLog("Matched!")
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
EndFunc

Func SelectReward($iX, $iY)
	Local $sImgClanGamesStorageFullWindow =  @ScriptDir & "\imgxml\Windows\ClanGamesStorageFull*"
	Local $sSearchArea = "245,250,615,480"

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
EndFunc

Func DebugClanGamesRewards($avRewards, $sText = "")

	SetLog("Column " & $sText & " Valid Rewards :" & Ubound($avRewards))

	For $l = 0 to UBound($avRewards) - 1
		SetLog("$aSelectReward : " & $avRewards[$l][0])
	Next

EndFunc

Func DragRewardColumnIfNeeded($iColumn = 0)

	If $iColumn <= 4 Then Return

	If $iColumn = 5 Then
		ClickDrag(755, 220, 755 - 47, 220, 200)
	Else
		ClickDrag(755, 220, 755 - 108, 220, 200)
	EndIf

	If _Sleep(100) Then Return
	
	Return
EndFunc
