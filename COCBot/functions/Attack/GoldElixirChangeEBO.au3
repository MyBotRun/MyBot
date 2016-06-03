; #FUNCTION# ====================================================================================================================
; Name ..........: GoldElixirChangeEBO  (End Battle Options)
; Description ...: Checks if the gold/elixir changes , Returns True if changed.
; Syntax ........: GoldElixirChangeEBO()
; Parameters ....:
; Return values .: None
; Author ........: Samota
; Modified ......: Sardo (2015-06) : add exit for minimum resource left
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:v
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func GoldElixirChangeEBO()
	Local $Gold1, $Gold2
	Local $GoldChange, $ElixirChange
	Local $Elixir1, $Elixir2
	Local $DarkElixir1, $DarkElixir2
	Local $DarkElixirChange
	Local $Trophies
	Local $txtDiff
	Local $exitOneStar = 0, $exitTwoStars = 0
	$DarkLow = 0
	;READ RESOURCES n.1
	$Gold1 = getGoldVillageSearch(48, 69)
	$Elixir1 = getElixirVillageSearch(48, 69 + 29)
	$Trophies = getTrophyVillageSearch(48, 69 + 99)
	If $Trophies <> "" Then ; If trophy value found, then base has Dark Elixir
		If _Sleep($iDelayGoldElixirChangeEBO1) Then Return
		$DarkElixir1 = getDarkElixirVillageSearch(48, 69 + 57)
	Else
		$DarkElixir1 = ""
		$Trophies = getTrophyVillageSearch(48, 69 + 69)
	EndIf

	;CALCULATE WHICH TIMER TO USE
	Local $iBegin = TimerInit(), $x = $sTimeStopAtk[$iMatchMode] * 1000, $y = $sTimeStopAtk2[$iMatchMode] * 1000, $z
	If Number($Gold1) < Number($stxtMinGoldStopAtk2[$iMatchMode]) And Number($Elixir1) < Number($stxtMinElixirStopAtk2[$iMatchMode]) And Number($DarkElixir1) < Number($stxtMinDarkElixirStopAtk2[$iMatchMode]) And $iChkTimeStopAtk2[$iMatchMode] = 1 Then
		$z = $y
	Else
		If $ichkTimeStopAtk[$iMatchMode] = 1 Then
			$z = $x
		Else
			$z = 60 * 3 * 1000
		EndIf
	EndIf


	;CALCULATE TWO STARS REACH
	If $ichkEndTwoStars[$iMatchMode] = 1 And _CheckPixel($aWonTwoStar, True) Then
		SetLog("Two Star Reach, exit", $COLOR_GREEN)
		$exitTwoStars = 1
		$z = 0
	EndIf

	;CALCULATE ONE STARS REACH
	If $ichkEndOneStar[$iMatchMode] = 1 And _CheckPixel($aWonOneStar, True) Then
		SetLog("One Star Reach, exit", $COLOR_GREEN)
		$exitOneStar = 1
		$z = 0
	EndIf



	;MAIN LOOP
	While TimerDiff($iBegin) < $z
		;HEALTH HEROES
		CheckHeroesHealth()

		;DE SPECIAL END EARLY
		If $iMatchMode = $LB And $iChkDeploySettings[$LB] = 4 And $DESideEB Then
			If $dropQueen Or $dropKing Then DELow()
			If $DarkLow = 1 Then ExitLoop
		EndIf
		If $checkKPower Or $checkQPower Or $DarkLow = 2 Then
			If _Sleep($iDelayGoldElixirChangeEBO1) Then Return
		Else
			If _Sleep($iDelayGoldElixirChangeEBO2) Then Return
		EndIf

		;READ RESOURCE n.2
		$Gold2 = getGoldVillageSearch(48, 69)
		If $Gold2 = "" Then
			If _Sleep($iDelayGoldElixirChangeEBO1) Then Return
			$Gold2 = getGoldVillageSearch(48, 69)
		EndIf
		$Elixir2 = getElixirVillageSearch(48, 69 + 29)
		$Trophies = getTrophyVillageSearch(48, 69 + 99)
		If $Trophies <> "" Then ; If trophy value found, then base has Dark Elixir
			If _Sleep($iDelayGoldElixirChangeEBO1) Then Return
			$DarkElixir2 = getDarkElixirVillageSearch(48, 69 + 57)
		Else
			$DarkElixir2 = ""
			$Trophies = getTrophyVillageSearch(48, 69 + 69)
		EndIf

		;WRITE LOG
		$txtDiff = Round(($z - TimerDiff($iBegin)) / 1000, 1)
		If Number($txtDiff) < 0 Then $txtDiff = 0
		If $Gold2 = "" And $Elixir2 = "" And $DarkElixir2 = "" Then
			SetLog("detected [G]: " & $Gold2 & " [E]: " & $Elixir2 & " [DE]: " & $DarkElixir2 & " |  Exit now ", $COLOR_BLUE)
		Else
			SetLog("detected [G]: " & $Gold2 & " [E]: " & $Elixir2 & " [DE]: " & $DarkElixir2 & " |  Exit in " & StringReplace(StringFormat("%2i", $txtDiff), "-", "") & " sec.", $COLOR_BLUE)
		EndIf

		;CALCULATE RESOURCE CHANGES
		If $Gold2 <> "" Or $Elixir2 <> "" Or $DarkElixir2 <> "" Then
			$GoldChange = $Gold2
			$ElixirChange = $Elixir2
			$DarkElixirChange = $DarkElixir2
		EndIf

		;EXIT IF RESOURCES = 0
		If $ichkEndNoResources[$iMatchMode] = 1 And Number($Gold2) = 0 And Number($Elixir2) = 0 And Number($DarkElixir2) = 0 Then
			SetLog("Gold & Elixir & DE = 0, end battle ", $COLOR_GREEN)
			If _Sleep($iDelayGoldElixirChangeEBO2) Then Return
			ExitLoop
		EndIf

		;EXIT IF TWO STARS REACH
		If $ichkEndTwoStars[$iMatchMode] = 1 And _CheckPixel($aWonTwoStar, True) Then
			SetLog("Two Star Reach, exit", $COLOR_GREEN)
			$exitTwoStars = 1
			ExitLoop
		EndIf

		;EXIT IF ONE STARS REACH
		If $ichkEndOneStar[$iMatchMode] = 1 And _CheckPixel($aWonOneStar, True) Then
			SetLog("One Star Reach, exit", $COLOR_GREEN)
			$exitOneStar = 1
			ExitLoop
		EndIf

		;EXIT LOOP IF RESOURCES = "" ... battle end
		If getGoldVillageSearch(48, 69) = "" And getElixirVillageSearch(48, 69 + 29) = "" And $DarkElixir2 = "" Then
			ExitLoop
		EndIf

		;EXIT IF RESOURCES CHANGE DETECTEC
		If ($Gold1 <> $Gold2 Or $Elixir1 <> $Elixir2 Or $DarkElixir1 <> $DarkElixir2) Then
			;SetLog("Gold & Elixir & DE change detected, waiting... .", $COLOR_GREEN)
			ExitLoop
		EndIf

	WEnd ; END MAIN LOOP

	;Priority Check... Exit To protect Hero Health
	If $iMatchMode = $LB And $iChkDeploySettings[$LB] = 4 And $DESideEB And $DarkLow = 1 Then
		SetLog("Returning Now -DE-", $COLOR_GREEN)
		Return False
	EndIf

	;FIRST CHECK... EXIT FOR ONE STAR REACH
	If $ichkEndOneStar[$iMatchMode] = 1 And $exitOneStar = 1 Then
		If _Sleep($iDelayGoldElixirChangeEBO2) Then Return
		Return False
	EndIf

	;SECOND CHECK... EXIT FOR TWO STARS REACH
	If $ichkEndTwoStars[$iMatchMode] = 1 And $exitTwoStars = 1 Then
		If _Sleep($iDelayGoldElixirChangeEBO2) Then Return
		Return False
	EndIf

	;THIRD CHECK... IF VALUES= "" REREAD AND RETURN FALSE IF = ""
	If ($Gold2 = "" And $Elixir2 = "" And $DarkElixir2 = "") Then
		SetLog("Battle has finished", $COLOR_GREEN)
		Return False ;end battle
	EndIf

	;FOURTH CHECK... IF RESOURCES = 0 THEN EXIT
	If $ichkEndNoResources[$iMatchMode] = 1 And Number($Gold2) = 0 And Number($Elixir2) = 0 And Number($DarkElixir2) = 0 Then
		SetLog("Gold & Elixir & DE = 0, end battle ", $COLOR_GREEN)
		If _Sleep($iDelayGoldElixirChangeEBO2) Then Return
		Return False
	EndIf

	;FIFTH CHECK... IF VALUES NOT CHANGED  RETURN FALSE ELSE RETURN TRUE
	If (Number($Gold1) = Number($Gold2) And Number($Elixir1) = Number($Elixir2) And Number($DarkElixir1) = Number($DarkElixir2)) Then
		SetLog("Gold & Elixir & DE no change detected, exit", $COLOR_GREEN)
		Return False
	Else
		If $debugsetlog = 1 Then
			Setlog("Gold1: " & Number($Gold1) & "  Gold2: " & Number($Gold2), $COLOR_PURPLE)
			Setlog("Elixir1: " & Number($Elixir1) & "  Elixir2: " & Number($Elixir2), $COLOR_PURPLE)
			Setlog("Dark Elixir1: " & Number($DarkElixir1) & "  Dark Elixir2: " & Number($DarkElixir2), $COLOR_PURPLE)
		EndIf
		SetLog("Gold & Elixir & DE change detected, waiting...", $COLOR_GREEN)
		Return True
	EndIf

EndFunc   ;==>GoldElixirChangeEBO


Func OverallDamage($OverallDamage = 30, $SetLog = True)

	Local $Damage = Number(getOcrOverAllDamage(780, 527 + $bottomOffsetY))

	If $SetLog = True Then
		SetLog("Overall Damage: " & $Damage & "%")
	EndIf

	If $Damage >= $OverallDamage Then
		Return True
	Else
		Return False
	EndIf

EndFunc   ;==>OverallDamage
