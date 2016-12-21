
; #FUNCTION# ====================================================================================================================
; Name ..........: IsSearchModeActive
; Description ...:
; Syntax ........: IsSearchModeActive($iMatchMode)
; Parameters ....:
; Return values .: None
; Author ........: Sardo (2016-01)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func IsSearchModeActive($iMatchMode, $nocheckHeroes = False)
	Local $currentSearch = $SearchCount + 1
	Local $currentTropies = $iTrophyCurrent
	Local $currentArmyCamps = Int($CurCamp / $TotalCamp * 100)

	Local $bMatchModeEnabled = False
	Local $checkSearches = Int($currentSearch) >= Int($iEnableAfterCount[$iMatchMode]) And Int($currentSearch) <= Int($iEnableBeforeCount[$iMatchMode]) And $iEnableSearchSearches[$iMatchMode] = 1
	Local $checkTropies = Int($currentTropies) >= Int($iEnableAfterTropies[$iMatchMode]) And Int($currentTropies) <= Int($iEnableBeforeTropies[$iMatchMode]) And $iEnableSearchTropies[$iMatchMode] = 1
	Local $checkArmyCamps = Int($currentArmyCamps) >= Int($iEnableAfterArmyCamps[$iMatchMode]) Or $fullarmy = True And $iEnableSearchCamps[$iMatchMode] = 1
	Local $checkHeroes = Not ($iHeroWait[$iMatchMode] > $HERO_NOHERO And (BitAND($iHeroAttack[$iMatchMode], $iHeroWait[$iMatchMode], $iHeroAvailable) = $iHeroWait[$iMatchMode]) = False) Or $nocheckHeroes

	If $checkHeroes = False Then
		If abs($iHeroWait[$iMatchMode] - $iHeroUpgradingBit) <= $HERO_NOHERO Then $checkHeroes = True
	EndIf

	Local $checkSpells = ($bFullArmySpells And $iEnableSpellsWait[$iMatchMode] = 1) Or $iEnableSpellsWait[$iMatchMode] = 0
	Local $totalSpellsToBrew = 0
	;--- To Brew
	$totalSpellsToBrew += $PSpellComp + $ESpellComp + $HaSpellComp + $SkSpellComp + _
	$LSpellComp + $RSpellComp + $HSpellComp + $JSpellComp + $FSpellComp + $CSpellComp

	;$iTotalCountSpell = $PSpellComp + $ESpellComp + $HaSpellComp + $SkSpellComp + _
		;($LSpellComp* 2) + ($RSpellComp* 2) + ($HSpellComp* 2) + ($JSpellComp* 2) + ($FSpellComp* 2) + ($CSpellComp* 2)
	;---
	If GetCurTotalSpell() = $totalSpellsToBrew And $iEnableSpellsWait[$iMatchMode] = 1 Then
		$checkSpells = True
	ElseIf $bFullArmySpells = True And $iEnableSpellsWait[$iMatchMode] = 1 Then
		$checkSpells = True
	ElseIf $iEnableSpellsWait[$iMatchMode] = 0 Then
		$checkSpells = True
	Else
		$checkSpells = False
	EndIf

	Switch $iMatchMode
		Case $DB
			$bMatchModeEnabled = ($iDBcheck = 1)
		Case $LB
			$bMatchModeEnabled = ($iABcheck = 1)
		Case $TS
			$bMatchModeEnabled = ($iTScheck = 1)
		Case Else
			$bMatchModeEnabled = False
	EndSwitch

	If $bMatchModeEnabled = False Then Return False ; exit if no DB, LB, TS mode enabled

#CS	If $debugsetlog = 1 Then
		Setlog("====== DEBUG IsSearchModeActive ======" )
		Setlog("$iHeroWait["& $iMatchMode &"]: " & $iHeroWait[$iMatchMode])
		Setlog("$iHeroAttack["& $iMatchMode &"]: " & $iHeroAttack[$iMatchMode])
		Setlog("$iHeroUpgradingBit: " & $iHeroUpgradingBit)
		Setlog("$iHeroAvailable: " & $iHeroAvailable)
		Setlog("$checkHeroes: " & $checkHeroes)
		Setlog("======================================" )
	EndIf
#CE

	If $checkHeroes And $checkSpells Then ;If $checkHeroes Then
		If $bMatchModeEnabled And ($checkSearches Or $iEnableSearchSearches[$iMatchMode] = 0) And ($checkTropies Or $iEnableSearchTropies[$iMatchMode] = 0) And ($checkArmyCamps Or $iEnableSearchCamps[$iMatchMode] = 0) Then
			If $debugsetlog = 1 Then Setlog($sModeText[$iMatchMode] & " active! ($checkSearches=" & $checkSearches & ",$checkTropies=" & $checkTropies & ",$checkArmyCamps=" & $checkArmyCamps & ",$checkHeroes=" & $checkHeroes & ",$checkSpells=" & $checkSpells & ")", $COLOR_INFO) ;If $debugsetlog = 1 Then Setlog($sModeText[$iMatchMode] & " active! ($checkSearches=" & $checkSearches & ",$checkTropies=" & $checkTropies &",$checkArmyCamps=" & $checkArmyCamps & ",$checkHeroes=" & $checkHeroes & ")" , $COLOR_INFO)
			Return True
		Else
			If $debugsetlog = 1 Then
				Setlog($sModeText[$iMatchMode] & " not active!", $COLOR_INFO)
				If $bMatchModeEnabled Then
					Local $txtsearches = "Fail"
					If $checkSearches Then $txtsearches = "Success"
					Local $txttropies = "Fail"
					If $checkTropies Then $txttropies = "Success"
					Local $txtArmyCamp = "Fail"
					If $checkArmyCamps Then $txtArmyCamp = "Success"
					Local $txtHeroes = "Fail"
					If $checkHeroes Then $txtHeroes = "Success"
					If $iEnableSearchSearches[$iMatchMode] = 1 Then Setlog("searches range: " & $iEnableAfterCount[$iMatchMode] & "-" & $iEnableBeforeCount[$iMatchMode] & "  actual value: " & $currentSearch & " - " & $txtsearches, $COLOR_INFO)
					If $iEnableSearchTropies[$iMatchMode] = 1 Then Setlog("tropies range: " & $iEnableAfterTropies[$iMatchMode] & "-" & $iEnableBeforeTropies[$iMatchMode] & "  actual value: " & $currentTropies & " | " & $txttropies, $COLOR_INFO)
					If $iEnableSearchCamps[$iMatchMode] = 1 Then Setlog("Army camps % range >=: " & $iEnableAfterArmyCamps[$iMatchMode] & " actual value: " & $currentArmyCamps & " | " & $txtArmyCamp, $COLOR_INFO)
					If $iHeroWait[$iMatchMode] > $HERO_NOHERO Then SetLog("Hero status " & BitAND($iHeroAttack[$iMatchMode], $iHeroWait[$iMatchMode], $iHeroAvailable) & " " & $iHeroAvailable & " | " & $txtHeroes, $COLOR_INFO)
					Local $txtSpells = "Fail"
					If $checkSpells Then $txtSpells = "Success"
					If $iEnableSpellsWait[$iMatchMode] = 1 Then SetLog("Full spell status: " & $bFullArmySpells & " | " & $txtSpells, $COLOR_INFO)
				EndIf
			EndIf
			Return False
		EndIf
	ElseIf $checkHeroes = 0 Then
		If $debugsetlog = 1 Then Setlog("Heroes not ready", $COLOR_DEBUG)
		Return False
	Else
		If $debugsetlog = 1 Then Setlog("Spells not ready", $COLOR_DEBUG)
		Return False
	EndIf
EndFunc   ;==>IsSearchModeActive

Func IsSearchModeActiveMini($iMatchMode)
	Switch $iMatchMode
		Case $DB
			Return ($iDBcheck = 1)
		Case $LB
			Return ($iABcheck = 1)
		Case $TS
			Return ($iTScheck = 1)
		Case Else
			Return False
	EndSwitch
EndFunc   ;==>IsSearchModeActiveMini

; #FUNCTION# ====================================================================================================================
; Name ..........: IsWaitforSpellsActive
; Description ...: Checks if Wait for Spells is enabled for all enabled attack modes
; Syntax ........: IsWaitforSpellsActive()
; Parameters ....: none
; Return values .: Returns True if Wait for spells is enabled for any enabled attack mode, false if not
; Author ........: MonkeyHunter (06-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func IsWaitforSpellsActive()
	Local $bMatchModeEnabled
	For $i = $DB To $iModeCount - 1
		$bMatchModeEnabled = False
		Switch $i
			Case $DB
				$bMatchModeEnabled = ($iDBcheck = 1)
			Case $LB
				$bMatchModeEnabled = ($iABcheck = 1)
			Case $TS
				$bMatchModeEnabled = ($iTScheck = 1)
		EndSwitch
		If $bMatchModeEnabled And $iEnableSpellsWait[$i] = 1 Then
			If $debugsetlogTrain = 1 Or $debugsetlog = 1 Then Setlog("IsWaitforSpellsActive = True", $COLOR_DEBUG)
			Return True
		EndIf
	Next
	If $debugsetlogTrain = 1 Or $debugsetlog = 1 Then Setlog("IsWaitforSpellsActive = False", $COLOR_DEBUG)
	Return False
EndFunc   ;==>IsWaitforSpellsActive

; #FUNCTION# ====================================================================================================================
; Name ..........: IsWaitforHeroesActive
; Description ...: Checks if Wait for Heroes is enabled for all enabled attack modes
; Syntax ........: IsWaitforHeroesActive()
; Parameters ....: none
; Return values .: Returns True if Wait for any Hero is enabled for any enabled attack mode, false if not
; Author ........: MonkeyHunter (06-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func IsWaitforHeroesActive()
	Local $bMatchModeEnabled
	For $i = $DB To $iModeCount - 1
		$bMatchModeEnabled = False
		Switch $i
			Case $DB
				$bMatchModeEnabled = ($iDBcheck = 1)
			Case $LB
				$bMatchModeEnabled = ($iABcheck = 1)
			Case $TS
				$bMatchModeEnabled = ($iTScheck = 1)
		EndSwitch
		If $bMatchModeEnabled And ($iHeroWait[$i] > $HERO_NOHERO And (BitAND($iHeroAttack[$i], $iHeroWait[$i]) = $iHeroWait[$i]) And (abs($iHeroWait[$i] - $iHeroUpgradingBit) > $HERO_NOHERO)) Then
			If $debugsetlogTrain = 1 Or $debugsetlog = 1 Then Setlog("IsWaitforHeroesActive = True", $COLOR_DEBUG)
			Return True
		EndIf
	Next
	If $debugsetlogTrain = 1 Or $debugsetlog = 1 Then Setlog("IsWaitforHeroesActive = False", $COLOR_DEBUG)
	Return False
EndFunc   ;==>IsWaitforHeroesActive
