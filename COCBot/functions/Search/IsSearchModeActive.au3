
; #FUNCTION# ====================================================================================================================
; Name ..........: IsSearchModeActive
; Description ...:
; Syntax ........: IsSearchModeActive($g_iMatchMode)
; Parameters ....:
; Return values .: None
; Author ........: Sardo (2016-01)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func IsSearchModeActive($g_iMatchMode, $nocheckHeroes = False, $bNoLog = False)
	Local $currentSearch = $g_iSearchCount + 1
	Local $currentTropies = $g_aiCurrentLoot[$eLootTrophy]
	Local $currentArmyCamps = Int($g_CurrentCampUtilization / $g_iTotalCampSpace * 100)
	Local $bMatchModeEnabled = False

	Local $checkSearches = Int($currentSearch) >= Int($g_aiSearchSearchesMin[$g_iMatchMode]) And Int($currentSearch) <= Int($g_aiSearchSearchesMax[$g_iMatchMode]) And $g_abSearchSearchesEnable[$g_iMatchMode]
	Local $checkTropies = Int($currentTropies) >= Int($g_aiSearchTrophiesMin[$g_iMatchMode]) And Int($currentTropies) <= Int($g_aiSearchTrophiesMax[$g_iMatchMode]) And $g_abSearchTropiesEnable[$g_iMatchMode]
	Local $checkArmyCamps = Int($currentArmyCamps) >= Int($g_aiSearchCampsPct[$g_iMatchMode]) And $g_abSearchCampsEnable[$g_iMatchMode]
	Local $checkHeroes = Not ($g_aiSearchHeroWaitEnable[$g_iMatchMode] > $eHeroNone And (BitAND($g_aiAttackUseHeroes[$g_iMatchMode], $g_aiSearchHeroWaitEnable[$g_iMatchMode], $g_iHeroAvailable) = $g_aiSearchHeroWaitEnable[$g_iMatchMode]) = False) Or $nocheckHeroes

	If $checkHeroes = False Then
		If Abs($g_aiSearchHeroWaitEnable[$g_iMatchMode] - $g_iHeroUpgradingBit) <= $eHeroNone Then $checkHeroes = True
	EndIf

	Local $g_bCheckSpells = ($g_bFullArmySpells And $g_abSearchSpellsWaitEnable[$g_iMatchMode]) Or $g_abSearchSpellsWaitEnable[$g_iMatchMode] = False
	Local $totalSpellsToBrew = 0
	;--- To Brew
	For $i = 0 To $eSpellCount - 1
		$totalSpellsToBrew += $g_aiArmyCompSpells[$i]
	Next

	If GetCurTotalSpell() = $totalSpellsToBrew And $g_abSearchSpellsWaitEnable[$g_iMatchMode] Then
		$g_bCheckSpells = True
	ElseIf $g_bFullArmySpells And $g_abSearchSpellsWaitEnable[$g_iMatchMode] Then
		$g_bCheckSpells = True
	ElseIf $g_abSearchSpellsWaitEnable[$g_iMatchMode] = False Then
		$g_bCheckSpells = True
	Else
		$g_bCheckSpells = False
	EndIf

	Switch $g_iMatchMode
		Case $DB
			$bMatchModeEnabled = $g_abAttackTypeEnable[$DB]
		Case $LB
			$bMatchModeEnabled = $g_abAttackTypeEnable[$LB]
		Case $TS
			$bMatchModeEnabled = $g_abAttackTypeEnable[$TS]
		Case Else
			$bMatchModeEnabled = False
	EndSwitch

	If Not $bMatchModeEnabled Then Return False ; exit if no DB, LB, TS mode enabled

	If $checkHeroes And $g_bCheckSpells Then ;If $checkHeroes Then
		If ($checkSearches Or $g_abSearchSearchesEnable[$g_iMatchMode] = False) And ($checkTropies Or $g_abSearchTropiesEnable[$g_iMatchMode] = False) And ($checkArmyCamps Or $g_abSearchCampsEnable[$g_iMatchMode] = False) Then
			If $g_bDebugSetlog And Not $bNoLog Then SetLog($g_asModeText[$g_iMatchMode] & " active! ($checkSearches=" & $checkSearches & ",$checkTropies=" & $checkTropies & ",$checkArmyCamps=" & $checkArmyCamps & ",$checkHeroes=" & $checkHeroes & ",$g_bCheckSpells=" & $g_bCheckSpells & ")", $COLOR_INFO) ;If  = 1 Then SetLog($g_asModeText[$g_iMatchMode] & " active! ($checkSearches=" & $checkSearches & ",$checkTropies=" & $checkTropies &",$checkArmyCamps=" & $checkArmyCamps & ",$checkHeroes=" & $checkHeroes & ")" , $COLOR_INFO)
			Return True
		Else
			If $g_bDebugSetlog And Not $bNoLog Then
				SetLog($g_asModeText[$g_iMatchMode] & " not active!", $COLOR_INFO)
				Local $txtsearches = "Fail"
				If $checkSearches Then $txtsearches = "Success"
				Local $txttropies = "Fail"
				If $checkTropies Then $txttropies = "Success"
				Local $txtArmyCamp = "Fail"
				If $checkArmyCamps Then $txtArmyCamp = "Success"
				Local $txtHeroes = "Fail"
				If $checkHeroes Then $txtHeroes = "Success"
				If $g_abSearchSearchesEnable[$g_iMatchMode] Then SetLog("searches range: " & $g_aiSearchSearchesMin[$g_iMatchMode] & "-" & $g_aiSearchSearchesMax[$g_iMatchMode] & "  actual value: " & $currentSearch & " - " & $txtsearches, $COLOR_INFO)
				If $g_abSearchTropiesEnable[$g_iMatchMode] Then SetLog("tropies range: " & $g_aiSearchTrophiesMin[$g_iMatchMode] & "-" & $g_aiSearchTrophiesMax[$g_iMatchMode] & "  actual value: " & $currentTropies & " | " & $txttropies, $COLOR_INFO)
				If $g_abSearchCampsEnable[$g_iMatchMode] Then SetLog("Army camps % range >=: " & $g_aiSearchCampsPct[$g_iMatchMode] & " actual value: " & $currentArmyCamps & " | " & $txtArmyCamp, $COLOR_INFO)
				If $g_aiSearchHeroWaitEnable[$g_iMatchMode] > $eHeroNone Then SetLog("Hero status " & BitAND($g_aiAttackUseHeroes[$g_iMatchMode], $g_aiSearchHeroWaitEnable[$g_iMatchMode], $g_iHeroAvailable) & " " & $g_iHeroAvailable & " | " & $txtHeroes, $COLOR_INFO)
				Local $txtSpells = "Fail"
				If $g_bCheckSpells Then $txtSpells = "Success"
				If $g_abSearchSpellsWaitEnable[$g_iMatchMode] Then SetLog("Full spell status: " & $g_bFullArmySpells & " | " & $txtSpells, $COLOR_INFO)
			EndIf
			Return False
		EndIf
	ElseIf $checkHeroes = 0 Then
		If $g_bDebugSetlog And Not $bNoLog Then SetLog("Heroes not ready", $COLOR_DEBUG)
		Return False
	Else
		If $g_bDebugSetlog And Not $bNoLog Then SetLog("Spells not ready", $COLOR_DEBUG)
		Return False
	EndIf
EndFunc   ;==>IsSearchModeActive

Func IsSearchModeActiveMini(Const $iMatchMode)
	;Return $g_abAttackTypeEnable[$DB] Or $g_abAttackTypeEnable[$LB] Or $g_abAttackTypeEnable[$TS]
	Return $g_abAttackTypeEnable[$iMatchMode]
EndFunc   ;==>IsSearchModeActiveMini

; #FUNCTION# ====================================================================================================================
; Name ..........: IsWaitforSpellsActive
; Description ...: Checks if Wait for Spells is enabled for all enabled attack modes
; Syntax ........: IsWaitforSpellsActive()
; Parameters ....: none
; Return values .: Returns True if Wait for spells is enabled for any enabled attack mode, false if not
; Author ........: MonkeyHunter (06-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func IsWaitforSpellsActive()
	For $i = $DB To $g_iModeCount - 1
		If $g_abAttackTypeEnable[$i] And $g_abSearchSpellsWaitEnable[$i] Then
			If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then SetLog("IsWaitforSpellsActive = True", $COLOR_DEBUG)
			Return True
		EndIf
	Next
	If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then SetLog("IsWaitforSpellsActive = False", $COLOR_DEBUG)
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
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func IsWaitforHeroesActive()
	For $i = $DB To $g_iModeCount - 1
		If $g_abAttackTypeEnable[$i] And ($g_aiSearchHeroWaitEnable[$i] > $eHeroNone And (BitAND($g_aiAttackUseHeroes[$i], $g_aiSearchHeroWaitEnable[$i]) = $g_aiSearchHeroWaitEnable[$i]) And (Abs($g_aiSearchHeroWaitEnable[$i] - $g_iHeroUpgradingBit) > $eHeroNone)) Then
			If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then SetLog("IsWaitforHeroesActive = True", $COLOR_DEBUG)
			Return True
		EndIf
	Next
	If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then SetLog("IsWaitforHeroesActive = False", $COLOR_DEBUG)
	Return False
EndFunc   ;==>IsWaitforHeroesActive
