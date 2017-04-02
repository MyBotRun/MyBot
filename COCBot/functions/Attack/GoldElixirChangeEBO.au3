; #FUNCTION# ====================================================================================================================
; Name ..........: GoldElixirChangeEBO  (End Battle Options)
; Description ...: Checks if the gold/elixir changes , Returns True if changed.
; Syntax ........: GoldElixirChangeEBO()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......: Sardo (06-2015), Fliegerfaust (01-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
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
	Local $Damage, $CurDamage
	$g_iDarkLow = 0
	;READ RESOURCES n.1
	$Gold1 = getGoldVillageSearch(48, 69)
	$Elixir1 = getElixirVillageSearch(48, 69 + 29)
	$Trophies = getTrophyVillageSearch(48, 69 + 99)
	$Damage = getOcrOverAllDamage(780, 527 + $g_iBottomOffsetY)
	If $Trophies <> "" Then ; If trophy value found, then base has Dark Elixir
		If _Sleep($DELAYGOLDELIXIRCHANGEEBO1) Then Return
		$DarkElixir1 = getDarkElixirVillageSearch(48, 69 + 57)
	Else
		$DarkElixir1 = ""
		$Trophies = getTrophyVillageSearch(48, 69 + 69)
	EndIf

	;CALCULATE WHICH TIMER TO USE
	Local $x = $g_aiStopAtkNoLoot1Time[$g_iMatchMode] * 1000, $y = $g_aiStopAtkNoLoot2Time[$g_iMatchMode] * 1000, $z, $w = $g_aiStopAtkPctNoChangeTime[$g_iMatchMode] * 1000
	If Number($Gold1) < $g_aiStopAtkNoLoot2MinGold[$g_iMatchMode] And _
			Number($Elixir1) < $g_aiStopAtkNoLoot2MinElixir[$g_iMatchMode] And _
			Number($DarkElixir1) < $g_aiStopAtkNoLoot2MinDark[$g_iMatchMode] And _
			$g_abStopAtkNoLoot2Enable[$g_iMatchMode] Then

		$z = $y
	ElseIf $Damage <> "" And $g_abStopAtkPctNoChangeEnable[$g_iMatchMode] Then
		$z = $w
	Else
		If $g_abStopAtkNoLoot1Enable[$g_iMatchMode] Then
			$z = $x
		Else
			$z = 60 * 3 * 1000
		EndIf
	EndIf

	;CALCULATE TWO STARS REACH
	If $g_abStopAtkTwoStars[$g_iMatchMode] And _CheckPixel($aWonTwoStar, True) Then
		SetLog("Two Star Reach, exit", $COLOR_SUCCESS)
		$exitTwoStars = 1
		$z = 0
	EndIf

	;CALCULATE ONE STARS REACH
	If $g_abStopAtkOneStar[$g_iMatchMode] And _CheckPixel($aWonOneStar, True) Then
		SetLog("One Star Reach, exit", $COLOR_SUCCESS)
		$exitOneStar = 1
		$z = 0
	EndIf

	; Early Check if Percentage is alreay higher than set
	If $g_abStopAtkPctHigherEnable[$g_iMatchMode] And Number(getOcrOverAllDamage(780, 527 + $g_iBottomOffsetY)) > Number($g_aiStopAtkPctHigherAmt[$g_iMatchMode]) Then
		SetLog("Overall Damage above " & Number($g_aiStopAtkPctHigherAmt[$g_iMatchMode]), $COLOR_SUCCESS)
		$z = 0
	EndIf

	Local $NoResourceOCR = False
	Local $ExitNoLootChange = ($g_abStopAtkNoLoot1Enable[$g_iMatchMode] Or $g_abStopAtkNoLoot2Enable[$g_iMatchMode] Or $g_abStopAtkNoResources[$g_iMatchMode])

	;MAIN LOOP
	Local $iBegin = __TimerInit()
	While __TimerDiff($iBegin) < $z
		;HEALTH HEROES
		CheckHeroesHealth()

		;DE SPECIAL END EARLY
		If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 4 And $g_bDESideEndEnable Then
			If $g_bDropQueen Or $g_bDropKing Then DELow()
			If $g_iDarkLow = 1 Then ExitLoop
		EndIf
		If $g_bCheckKingPower Or $g_bCheckQueenPower Or $g_iDarkLow = 2 Then
			If _Sleep($DELAYGOLDELIXIRCHANGEEBO1) Then Return
		Else
			If _Sleep($DELAYGOLDELIXIRCHANGEEBO2) Then Return
		EndIf

		;--> Read Ressources #2
		$Gold2 = getGoldVillageSearch(48, 69)
		If $Gold2 = "" Then
			If _Sleep($DELAYGOLDELIXIRCHANGEEBO1) Then Return
			$Gold2 = getGoldVillageSearch(48, 69)
		EndIf
;		If $g_iActivateKQCondition = "Auto" Then CheckHeroesHealth()
		$Elixir2 = getElixirVillageSearch(48, 69 + 29)
		$Trophies = getTrophyVillageSearch(48, 69 + 99)
		CheckHeroesHealth()
		If $Trophies <> "" Then ; If trophy value found, then base has Dark Elixir
			If _Sleep($DELAYGOLDELIXIRCHANGEEBO1) Then Return
			$DarkElixir2 = getDarkElixirVillageSearch(48, 69 + 57)
		Else
			$DarkElixir2 = ""
			$Trophies = getTrophyVillageSearch(48, 69 + 69)
		EndIf
		$CurDamage = getOcrOverAllDamage(780, 527 + $g_iBottomOffsetY)
		;--> Read Ressources #2

		CheckHeroesHealth()

		;WRITE LOG
		$txtDiff = Round(($z - __TimerDiff($iBegin)) / 1000, 1)
		If Number($txtDiff) < 0 Then $txtDiff = 0
		$NoResourceOCR = StringLen($Gold2) = 0 And StringLen($Elixir2) = 0 And StringLen($DarkElixir2) = 0
		If $NoResourceOCR Then
			SetLog("detected [G]: " & $Gold2 & " [E]: " & $Elixir2 & " [DE]: " & $DarkElixir2 & " [%]: " & $CurDamage & " |  Exit now ", $COLOR_INFO)
		Else
			SetLog("detected [G]: " & $Gold2 & " [E]: " & $Elixir2 & " [DE]: " & $DarkElixir2 & " [%]: " & $CurDamage & " |  Exit in " & StringReplace(StringFormat("%2i", $txtDiff), "-", "") & " sec.", $COLOR_INFO)
		EndIf

		If Number($CurDamage) >= 92 Then
			If ($g_bCheckKingPower = True Or $g_bCheckQueenPower = True Or $g_bCheckWardenPower = True) And $g_iActivateKQCondition = "Auto" Then
				If $g_bCheckKingPower = True Then
					SetLog("Activating King's power to restore some health before leaving with a 3 Star", $COLOR_INFO)
					If IsAttackPage() Then SelectDropTroop($g_iKingSlot) ;If King was not activated: Boost King before Battle ends with a 3 Star
					$g_bCheckKingPower = False
				EndIf
				If $g_bCheckQueenPower = True Then
					SetLog("Activating Queen's power to restore some health before leaving with a 3 Star", $COLOR_INFO)
					If IsAttackPage() Then SelectDropTroop($g_iQueenSlot) ;If Queen was not activated: Boost Queen before Battle ends with a 3 Star
					$g_bCheckQueenPower = False
				EndIf
				If $g_bCheckWardenPower = True Then
					SetLog("Activating Warden's power to restore some health before leaving with a 3 Star", $COLOR_INFO)
					If IsAttackPage() Then SelectDropTroop($g_iWardenSlot) ;If Queen was not activated: Boost Queen before Battle ends with a 3 Star
					$g_bCheckWardenPower = False
				EndIf
			EndIf
		EndIf


		;CALCULATE RESOURCE CHANGES
		If $Gold2 <> "" Or $Elixir2 <> "" Or $DarkElixir2 <> "" Then
			$GoldChange = $Gold2
			$ElixirChange = $Elixir2
			$DarkElixirChange = $DarkElixir2
		EndIf

		;EXIT IF RESOURCES = 0
		If $g_abStopAtkNoResources[$g_iMatchMode] And Number($Gold2) = 0 And Number($Elixir2) = 0 And Number($DarkElixir2) = 0 Then
			SetLog("Gold & Elixir & DE = 0, end battle ", $COLOR_SUCCESS)
			If _Sleep($DELAYGOLDELIXIRCHANGEEBO2) Then Return
			ExitLoop
		EndIf

		;EXIT IF TWO STARS REACH
		If $g_abStopAtkTwoStars[$g_iMatchMode] And _CheckPixel($aWonTwoStar, True) Then
			SetLog("Two Star Reach, exit", $COLOR_SUCCESS)
			$exitTwoStars = 1
			ExitLoop
		EndIf

		;EXIT IF ONE STARS REACH
		If $g_abStopAtkOneStar[$g_iMatchMode] And _CheckPixel($aWonOneStar, True) Then
			SetLog("One Star Reach, exit", $COLOR_SUCCESS)
			$exitOneStar = 1
			ExitLoop
		EndIf

		;EXIT LOOP IF RESOURCES = "" ... battle end
		If getGoldVillageSearch(48, 69) = "" And getElixirVillageSearch(48, 69 + 29) = "" And $DarkElixir2 = "" Then
			ExitLoop
		EndIf

		If $g_abStopAtkPctHigherEnable[$g_iMatchMode] And Number(getOcrOverAllDamage(780, 527 + $g_iBottomOffsetY)) > Number($g_aiStopAtkPctHigherAmt[$g_iMatchMode]) Then
			SetLog("Overall Damage above " & Number($g_aiStopAtkPctHigherAmt[$g_iMatchMode]) & ", exit", $COLOR_SUCCESS)
			ExitLoop
		EndIf

		;RETURN IF RESOURCES CHANGE DETECTED
		If ($g_abStopAtkNoLoot1Enable[$g_iMatchMode] Or $g_abStopAtkNoLoot2Enable[$g_iMatchMode]) And ($Gold1 <> $Gold2 Or $Elixir1 <> $Elixir2 Or $DarkElixir1 <> $DarkElixir2) Then
			SetLog("Gold & Elixir & DE change detected, waiting...", $COLOR_SUCCESS)
			Return True
		EndIf

		;RETURN IF DAMAGE CHANGE DETECTED
		If $g_abStopAtkPctNoChangeEnable[$g_iMatchMode] And (Number($Damage) <> Number($CurDamage)) Then
			SetLog("Overall Damage Percentage change detected, waiting...", $COLOR_SUCCESS)
			Return True
		EndIf

	WEnd ; END MAIN LOOP

	;Priority Check... Exit To protect Hero Health
	If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 4 And $g_bDESideEndEnable And $g_iDarkLow = 1 Then
		SetLog("Returning Now -DE-", $COLOR_SUCCESS)
		Return False
	EndIf

	;FIRST CHECK... EXIT FOR ONE STAR REACH
	If $g_abStopAtkOneStar[$g_iMatchMode] And $exitOneStar = 1 Then
		If _Sleep($DELAYGOLDELIXIRCHANGEEBO2) Then Return
		Return False
	EndIf

	;SECOND CHECK... EXIT FOR TWO STARS REACH
	If $g_abStopAtkTwoStars[$g_iMatchMode] And $exitTwoStars = 1 Then
		If _Sleep($DELAYGOLDELIXIRCHANGEEBO2) Then Return
		Return False
	EndIf

	;THIRD CHECK... IF VALUES= "" REREAD AND RETURN FALSE IF = ""
	If ($NoResourceOCR = True) Then
		SetLog("Battle has finished", $COLOR_SUCCESS)
		Return False ;end battle
	EndIf

	If $g_abStopAtkPctHigherEnable[$g_iMatchMode] And Number(getOcrOverAllDamage(780, 527 + $g_iBottomOffsetY)) > Number($g_aiStopAtkPctHigherAmt[$g_iMatchMode]) Then
		Return False
	EndIf

	;FOURTH CHECK... IF RESOURCES = 0 THEN EXIT
	If $g_abStopAtkNoResources[$g_iMatchMode] And $NoResourceOCR = False And Number($Gold2) = 0 And Number($Elixir2) = 0 And Number($DarkElixir2) = 0 Then
		SetLog("Gold & Elixir & DE = 0, end battle ", $COLOR_SUCCESS)
		If _Sleep($DELAYGOLDELIXIRCHANGEEBO2) Then Return
		Return False
	EndIf

	If $g_abStopAtkPctNoChangeEnable[$g_iMatchMode] And Number($Damage) = Number($CurDamage) Then
		SetLog("No Overall Damage Percentage change detected, exit", $COLOR_SUCCESS)
		Return False
	EndIf


	;FIFTH CHECK... IF VALUES NOT CHANGED  RETURN FALSE ELSE RETURN TRUE
	If (Number($Gold1) = Number($Gold2) And Number($Elixir1) = Number($Elixir2) And Number($DarkElixir1) = Number($DarkElixir2)) Then
		If $g_abStopAtkNoLoot1Enable[$g_iMatchMode] Or $g_abStopAtkNoLoot2Enable[$g_iMatchMode] Then
			SetLog("Gold & Elixir & DE no change detected, exit", $COLOR_SUCCESS)
			Return False
		Else
			SetLog("Gold & Elixir & DE no change detected, waiting...", $COLOR_SUCCESS)
		EndIf
	Else
		If $g_iDebugSetlog = 1 Then
			Setlog("Gold1: " & Number($Gold1) & "  Gold2: " & Number($Gold2), $COLOR_DEBUG)
			Setlog("Elixir1: " & Number($Elixir1) & "  Elixir2: " & Number($Elixir2), $COLOR_DEBUG)
			Setlog("Dark Elixir1: " & Number($DarkElixir1) & "  Dark Elixir2: " & Number($DarkElixir2), $COLOR_DEBUG)
		EndIf
	EndIf

	Return True

EndFunc   ;==>GoldElixirChangeEBO


Func OverallDamage($OverallDamage = 30, $SetLog = True)

	Local $Damage = Number(getOcrOverAllDamage(780, 527 + $g_iBottomOffsetY))

	If $SetLog = True Then
		SetLog("Overall Damage: " & $Damage & "%")
	EndIf

	If $Damage >= $OverallDamage Then
		Return True
	Else
		Return False
	EndIf

EndFunc   ;==>OverallDamage
