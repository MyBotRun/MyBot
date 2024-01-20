; #FUNCTION# ====================================================================================================================
; Name ..........: DropTrophy
; Description ...: Gets trophy count of village and compares to max trophy input. Will drop a troop and return home with no screenshot or gold wait.
; Syntax ........: DropTrophy()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......: Promac (2015-04), KnowJack(2015-08), Hervidero (2016-01), MonkeyHunter (2016-01,05)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func DropTrophy()

	If $g_bDropTrophyEnable Then
		SetDebugLog("Drop Trophy()", $COLOR_DEBUG)

		If $g_bDebugDeadBaseImage Then
			DirCreate($g_sProfileTempDebugPath & "\SkippedZombies\")
			DirCreate($g_sProfileTempDebugPath & "\Zombies\")
			setZombie()
		EndIf

		For $i = 0 To 5
			$g_aiCurrentLoot[$eLootTrophy] = getTrophyMainScreen($aTrophies[0], $aTrophies[1]) ; get OCR to read current Village Trophies
			SetDebugLog("Current Trophy Count: " & $g_aiCurrentLoot[$eLootTrophy], $COLOR_DEBUG)
			If $g_aiCurrentLoot[$eLootTrophy] <> "" Then ExitLoop
			If _Sleep(1000) Then Return
			ClickAway()
		Next

		If Number($g_aiCurrentLoot[$eLootTrophy]) <= Number($g_iDropTrophyMax) Then Return ; exit on trophy count to avoid other checks

		; Check if proper troop types avail during last checkarmycamp(), no need to call separately since droptrophy checked often
		Local $bHaveTroops = False
		For $i = 0 To UBound($g_avDTtroopsToBeUsed, 1) - 1
			If $g_avDTtroopsToBeUsed[$i][1] > 0 Then
				$bHaveTroops = True
				If $g_bDebugSetlog Then
					SetDebugLog("Drop Trophy Found " & StringFormat("%3s", $g_avDTtroopsToBeUsed[$i][1]) & " " & $g_avDTtroopsToBeUsed[$i][0], $COLOR_DEBUG)
					ContinueLoop ; display all troop counts if debug flag set
				Else
					ExitLoop ; Finding 1 troop type is enough to use trophy drop, stop checking rest when no debug flag
				EndIf
			EndIf
		Next
		; if heroes enabled, check them and reset drop trophy disable
		If $g_bDropTrophyUseHeroes And $g_iHeroAvailable > 0 Then
			SetDebugLog("Drop Trophy Found Hero BK|AQ|GW|RC: " & BitOR($g_iHeroAvailable, $eHeroKing) & "|" & BitOR($g_iHeroAvailable, $eHeroQueen) & "|" & BitOR($g_iHeroAvailable, $eHeroWarden) & "|" & BitOR($g_iHeroAvailable, $eHeroChampion), $COLOR_DEBUG)
			$bHaveTroops = True
		EndIf

		If Not $bHaveTroops Then ; troops available?
			SetLog("Drop Trophy temporarily disabled, missing proper troop type", $COLOR_ERROR)
			SetDebugLog("Drop Trophy(): No troops in $g_avDTtroopsToBeUsed array", $COLOR_DEBUG)
			Return
		EndIf

		Local $iCount, $aRandomEdge, $iRandomXY
		Local Const $DTArmyPercent = Round(Int($g_iDropTrophyArmyMinPct) / 100, 2)
		Local $g_iDropTrophyMaxNeedCheck = $g_iDropTrophyMax ; set trophy target to max trophy
		Local Const $iWaitTime = 3 ; wait time for base recheck during long drop times in minutes (3 minutes ~5-10 drop attacks)
		Local $iDateCalc, $sWaitToDate
		$sWaitToDate = _DateAdd('n', Int($iWaitTime), _NowCalc()) ; find delay time for checkbasequick
		SetDebugLog("ChkBaseQuick delay time= " & $sWaitToDate & " Now= " & _NowCalc() & " Diff= " & _DateDiff('s', _NowCalc(), $sWaitToDate), $COLOR_DEBUG)

		While Number($g_aiCurrentLoot[$eLootTrophy]) > Number($g_iDropTrophyMaxNeedCheck)
			$g_aiCurrentLoot[$eLootTrophy] = getTrophyMainScreen($aTrophies[0], $aTrophies[1])
			SetLog("Trophy Count : " & $g_aiCurrentLoot[$eLootTrophy], $COLOR_SUCCESS)
			If Number($g_aiCurrentLoot[$eLootTrophy]) > Number($g_iDropTrophyMaxNeedCheck) Then

				; Check for enough troops before starting base search to save search costs
				If $g_bDropTrophyAtkDead Then
					; If attack dead bases during trophy drop is enabled then make sure we have enough army troops
					If ($g_CurrentCampUtilization <= ($g_iTotalCampSpace * $DTArmyPercent)) Then ; check if current troops above setting
						SetLog("Drop Trophy is waiting for " & $g_iDropTrophyArmyMinPct & "% full army to also attack Deadbases.", $COLOR_ACTION)
						SetDebugLog("Drop Trophy(): Drop Trophy + Dead Base skipped, army < " & $g_iDropTrophyArmyMinPct & "%.", $COLOR_DEBUG)
						ExitLoop ; no troops then cycle again
					EndIf

					; no deadbase attacks enabled, then only 1 giant or hero needed to enable drop trophy to work
				Else
					If ($g_CurrentCampUtilization < 5) And ($g_bDropTrophyUseHeroes And $g_iHeroAvailable = $eHeroNone) Then
						SetLog("No troops available to use on Drop Trophy", $COLOR_ERROR)
						SetDebugLog("Drop Trophy(): Drop Trophy skipped, no army.", $COLOR_DEBUG)
						ExitLoop ; no troops then cycle again
					EndIf
				EndIf

				$g_iDropTrophyMaxNeedCheck = $g_iDropTrophyMin ; already checked above max trophy, so set target to min trophy value
				SetLog("Dropping Trophies to " & $g_iDropTrophyMin, $COLOR_INFO)
				If _Sleep($DELAYDROPTROPHY4) Then ExitLoop
				ZoomOut()
				PrepareSearch($DT)
				If $g_bOutOfGold Or $g_bRestart Then Return

				WaitForClouds() ; Wait for clouds to disappear

				If $g_bRestart Then Return ; exit func

				If _Sleep($DELAYDROPTROPHY4) Then ExitLoop

				$g_iSearchCount = 0
				GetResources(False, $DT) ; no log, use $DT matchmode (DropThrophy)
				If $g_bRestart Then Return ; exit func

				If $g_bDropTrophyAtkDead Then
					; Check for Dead Base on 1st search
					$g_iAimGold[$DB] = $g_aiFilterMinGold[$DB]
					$g_iAimElixir[$DB] = $g_aiFilterMinElixir[$DB]
					$g_iAimGoldPlusElixir[$DB] = $g_aiFilterMinGoldPlusElixir[$DB]

					Local $G = (Number($g_iSearchGold) >= Number($g_iAimGold[$DB]))
					Local $E = (Number($g_iSearchElixir) >= Number($g_iAimElixir[$DB]))
					Local $GPE = ((Number($g_iSearchElixir) + Number($g_iSearchGold)) >= Number($g_iAimGoldPlusElixir[$DB]))
					If $G = True And $E = True And $GPE = True Then
						SetLog("Found [G]:" & StringFormat("%7s", $g_iSearchGold) & " [E]:" & StringFormat("%7s", $g_iSearchElixir) & " [D]:" & StringFormat("%5s", $g_iSearchDark) & " [T]:" & StringFormat("%2s", $g_iSearchTrophy), $COLOR_BLACK, "Lucida Console", 7.5)
						If $g_bDebugDeadBaseImage Then setZombie()
						ForceCaptureRegion()
						_CaptureRegion2() ; take new capture for deadbase
						If checkDeadBase() Then

							SetLog("      " & "Dead Base Found while dropping Trophies!", $COLOR_SUCCESS, "Lucida Console", 7.5)
							SetLog("Identification of your troops:", $COLOR_INFO)
							PrepareAttack($DB) ; ==== Troops :checks for type, slot, and quantity ===
							If $g_bRestart Then Return
							Attack()
							ReturnHome($g_bTakeLootSnapShot)
							$g_bIsClientSyncError = False ; reset OOS flag to get new new army
							$g_bIsSearchLimit = False ; reset search limit flag to get new new army
							$g_bRestart = True ; Set restart flag after dead base attack to ensure troops are trained
							SetDebugLog("Drop Trophy END: Dead Base was attacked, reset army and return to Village.", $COLOR_DEBUG)
							ExitLoop ; or Return, Will end function, no troops left to drop Trophies, will need to Train new Troops first
						Else
							SetLog("      " & "Not a Dead Base, resuming Trophy Dropping.", $COLOR_BLACK, "Lucida Console", 7.5)
						EndIf
					EndIf
				EndIf

				; Normal Drop Trophy, no check for Dead Base
				SetLog("Identification of your troops:", $COLOR_INFO)
				PrepareAttack($DT) ; ==== Troops :checks for type, slot, and quantity ===
				If $g_bRestart Then Return

				If _Sleep($DELAYDROPTROPHY4) Then ExitLoop

				; Drop a Hero or Troop
				If $g_bDropTrophyUseHeroes Then
					;a) identify heroes avaiables...
					SetSlotSpecialTroops()

					;b) calculate random drop point...
					Local $IsBoostButton = False
					For $i = 1 To 5
						If _Sleep(300) Then Return
						If QuickMIS("BFI", $g_sImgImgLocButtons & "\BoostButtons\BoostButton*.xml", 130, 520 + $g_iBottomOffsetY, 390, 555 + $g_iBottomOffsetY) Then
							$IsBoostButton = True
							ExitLoop
						EndIf
					Next
					If $IsBoostButton Then
						$aRandomEdge = $g_aaiEdgeDropPoints2[Round(Random(0, 3))]
					Else
						$aRandomEdge = $g_aaiEdgeDropPoints[Round(Random(0, 3))]
					EndIf
					$iRandomXY = Round(Random(0, 4))
					SetDebugLog("Hero Loc = " & $iRandomXY & ", X:Y= " & $aRandomEdge[$iRandomXY][0] & "|" & $aRandomEdge[$iRandomXY][1], $COLOR_DEBUG)


					;c) check if hero avaiable and drop according to priority
					If ($g_iQueenSlot <> -1 Or $g_iKingSlot <> -1 Or $g_iWardenSlot <> -1 Or $g_iChampionSlot <> -1) Then
						Local $sHeroPriority
						Switch $g_iDropTrophyHeroesPriority
							Case 0
								$sHeroPriority = "QKWC"
							Case 1
								$sHeroPriority = "QWKC"
							Case 2
								$sHeroPriority = "KQWC"
							Case 3
								$sHeroPriority = "KWQC"
							Case 4
								$sHeroPriority = "WKQC"
							Case 5
								$sHeroPriority = "WQKC"
							Case 6
								$sHeroPriority = "CWQK"
							Case 7
								$sHeroPriority = "CQWK"
						EndSwitch

						Local $t
						For $i = 1 To 4
							$t = StringMid($sHeroPriority, $i, 1)
							Switch $t
								Case "Q"
									If $g_iQueenSlot <> -1 Then
										SetTrophyLoss()
										SetLog("Deploying Queen", $COLOR_INFO)
										SelectDropTroop($g_iQueenSlot)
										If _Sleep($DELAYDROPTROPHY1) Then ExitLoop
										Click($aRandomEdge[$iRandomXY][0], $aRandomEdge[$iRandomXY][1], 1, 0, "#0180") ;Drop Queen
										If _Sleep($DELAYDROPTROPHY4) Then ExitLoop
										SelectDropTroop($g_iQueenSlot) ;If Queen was not activated: Boost Queen before EndBattle to restore some health
										ReturnfromDropTrophies()
										If _Sleep($DELAYDROPTROPHY1) Then ExitLoop
										ExitLoop
									EndIf
								Case "K"
									If $g_iKingSlot <> -1 Then
										SetTrophyLoss()
										SetLog("Deploying King", $COLOR_INFO)
										SelectDropTroop($g_iKingSlot)
										If _Sleep($DELAYDROPTROPHY1) Then ExitLoop
										Click($aRandomEdge[$iRandomXY][0], $aRandomEdge[$iRandomXY][1], 1, 0, "#0178") ;Drop King
										If _Sleep($DELAYDROPTROPHY4) Then ExitLoop
										SelectDropTroop($g_iKingSlot) ;If King was not activated: Boost King before EndBattle to restore some health
										ReturnfromDropTrophies()
										If _Sleep($DELAYDROPTROPHY1) Then ExitLoop
										ExitLoop
									EndIf
								Case "W"
									If $g_iWardenSlot <> -1 Then
										SetTrophyLoss()
										SetLog("Deploying Warden", $COLOR_INFO)
										SelectDropTroop($g_iWardenSlot)
										If _Sleep($DELAYDROPTROPHY1) Then ExitLoop
										Click($aRandomEdge[$iRandomXY][0], $aRandomEdge[$iRandomXY][1], 1, 0, "#0000") ;Drop Warden
										If _Sleep($DELAYDROPTROPHY4) Then ExitLoop
										SelectDropTroop($g_iWardenSlot) ;If Warden was not activated: Boost Warden before EndBattle to restore some health
										ReturnfromDropTrophies()
										If _Sleep($DELAYDROPTROPHY1) Then ExitLoop
										ExitLoop
									EndIf
								Case "C"
									If $g_iChampionSlot <> -1 Then
										SetTrophyLoss()
										SetLog("Deploying Royal Champion", $COLOR_INFO)
										SelectDropTroop($g_iChampionSlot)
										If _Sleep($DELAYDROPTROPHY1) Then ExitLoop
										Click($aRandomEdge[$iRandomXY][0], $aRandomEdge[$iRandomXY][1], 1, 0, "#0000") ;Drop Champion
										If _Sleep($DELAYDROPTROPHY4) Then ExitLoop
										SelectDropTroop($g_iChampionSlot) ;If Champion was not activated: Boost Champion before EndBattle to restore some health
										ReturnfromDropTrophies()
										If _Sleep($DELAYDROPTROPHY1) Then ExitLoop
										ExitLoop
									EndIf
							EndSwitch
						Next
					EndIf
				EndIf
				If ($g_iQueenSlot = -1 And $g_iKingSlot = -1 And $g_iWardenSlot = -1 And $g_iChampionSlot = -1) Or Not $g_bDropTrophyUseHeroes Then
					$aRandomEdge = $g_aaiEdgeDropPoints[Round(Random(0, 3))]
					$iRandomXY = Round(Random(0, 4))
					SetDebugLog("Troop Loc = " & $iRandomXY & ", X:Y= " & $aRandomEdge[$iRandomXY][0] & "|" & $aRandomEdge[$iRandomXY][1], $COLOR_DEBUG)
					For $i = 0 To UBound($g_avAttackTroops) - 1
						If ($g_avAttackTroops[$i][0] >= $eBarb And $g_avAttackTroops[$i][0] <= $eWiza) Or $g_avAttackTroops[$i][0] = $eMini Then
							SelectDropTroop($i)
							If _Sleep($DELAYDROPTROPHY4) Then ExitLoop
							Click($aRandomEdge[$iRandomXY][0], $aRandomEdge[$iRandomXY][1], 1, 0, "#0181") ;Drop one troop
							SetLog("Deploying 1 " & $g_asTroopNames[$g_avAttackTroops[$i][0]], $COLOR_INFO)
							$g_aiCurrentTroops[$g_avAttackTroops[$i][0]] -= 1
							ExitLoop
						EndIf
						If $g_avAttackTroops[$i][0] = -1 Or $g_avAttackTroops[$i][0] >= $eTroopCount Then
							SetLog("You don't have Tier 1/2 Troops, Stop dropping trophies.", $COLOR_INFO) ; preventing of deploying Tier 2/3 expensive troops
							ExitLoop 2
						EndIf
					Next
					SetTrophyLoss()
					If _Sleep($DELAYDROPTROPHY1) Then ExitLoop
					ReturnHome(False, False) ;Return home no screenshot
					If _Sleep($DELAYDROPTROPHY1) Then ExitLoop
				EndIf
				$iDateCalc = _DateDiff('s', _NowCalc(), $sWaitToDate)
				SetDebugLog("ChkBaseQuick delay= " & $sWaitToDate & " Now= " & _NowCalc() & " Diff= " & $iDateCalc, $COLOR_DEBUG)
				If $iDateCalc <= 0 Then ; check length of time in drop trophy
					SetLog(" Checking base during long drop cycle", $COLOR_INFO)
					CheckBaseQuick() ; check base during long drop times
					$sWaitToDate = _DateAdd('n', Int($iWaitTime), _NowCalc()) ; create new delay date/time
					SetDebugLog("ChkBaseQuick new delay time= " & $sWaitToDate, $COLOR_DEBUG)
				EndIf
			Else
				SetLog("Trophy Drop Complete", $COLOR_INFO)
			EndIf
		WEnd
		SetDebugLog("DropTrophy(): End", $COLOR_DEBUG)
	Else
		SetDebugLog("Drop Trophy SKIP", $COLOR_DEBUG)
	EndIf

EndFunc   ;==>DropTrophy

Func SetTrophyLoss()
	Local $sTrophyLoss
	If _ColorCheck(_GetPixelColor(33, 148 + 7, True), Hex(0x000000, 6), 10) Or _CheckPixel($aAtkHasDarkElixir, $g_bCapturePixel, Default, "HasDarkElixir") Then ; check if the village have a Dark Elixir Storage
		$sTrophyLoss = getTrophyLossAttackScreen(48, 214 + 7)
	Else
		$sTrophyLoss = getTrophyLossAttackScreen(48, 184 + 7)
	EndIf
	SetLog(" Trophy loss = " & $sTrophyLoss, $COLOR_DEBUG) ; record trophy loss
	$g_iDroppedTrophyCount -= Number($sTrophyLoss)
	UpdateStats()
EndFunc   ;==>SetTrophyLoss