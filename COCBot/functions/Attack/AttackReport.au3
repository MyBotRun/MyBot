; #FUNCTION# ====================================================================================================================
; Name ..........: AttackReport
; Description ...: This function will report the loot from the last Attack: gold, elixir, dark elixir and trophies.
;                  It will also update the statistics to the GUI (Last Attack).
; Syntax ........: AttackReport()
; Parameters ....: None
; Return values .: None
; Author ........: Hervidero (2015-feb-10), Sardo (may-2015), Hervidero (2015-12)
; Modified ......: Sardo (may-2015), Hervidero (may-2015), Knowjack (July 2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func AttackReport()

	Local $iCount

	$lootGold = "" ; reset previous loot won values
	$lootElixir = ""
	$lootDarkElixir = ""
	$lootTrophies = ""

	$iCount = 0 ; Reset loop counter
	While _CheckPixel($aEndFightSceneAvl, True) = False ; check for light gold pixle in the Gold ribbon in End of Attack Scene before reading values
		$iCount += 1
		If _Sleep($iDelayAttackReport1) Then Return
		If $debugSetlog = 1 Then Setlog("Waiting Attack Report Ready, " & ($iCount / 2) & " Seconds.", $COLOR_PURPLE)
		If $iCount > 30 Then ExitLoop ; wait 30*500ms = 15 seconds max for the window to render
	WEnd
	If $iCount > 30 Then Setlog("End of Attack scene slow to appear, attack values my not be correct", $COLOR_BLUE)

	$iCount = 0 ; reset loop counter
	While getResourcesLoot(333, 289 + $midOffsetY) = "" ; check for gold value to be non-zero before reading other values as a secondary timer to make sure all values are available
		$iCount += 1
		If _Sleep($iDelayAttackReport1) Then Return
		If $debugSetlog = 1 Then Setlog("Waiting Attack Report Ready, " & ($iCount / 2) & " Seconds.", $COLOR_PURPLE)
		If $iCount > 20 Then ExitLoop ; wait 20*500ms = 10 seconds max before we have call the OCR read an error
	WEnd
	If $iCount > 20 Then Setlog("End of Attack scene read gold error, attack values my not be correct", $COLOR_BLUE)

	If _ColorCheck(_GetPixelColor($aAtkRprtDECheck[0], $aAtkRprtDECheck[1], True), Hex($aAtkRprtDECheck[2], 6), $aAtkRprtDECheck[3]) Then ; if the color of the DE drop detected
		$iGoldLast = getResourcesLoot(333, 289 + $midOffsetY)
		If _Sleep($iDelayAttackReport2) Then Return
		$iElixirLast = getResourcesLoot(333, 328 + $midOffsetY)
		If _Sleep($iDelayAttackReport2) Then Return
		$iDarkLast = getResourcesLootDE(365, 365 + $midOffsetY)
		If _Sleep($iDelayAttackReport2) Then Return
		$iTrophyLast = getResourcesLootT(403, 402 + $midOffsetY)
		If _ColorCheck(_GetPixelColor($aAtkRprtTrophyCheck[0], $aAtkRprtTrophyCheck[1], True), Hex($aAtkRprtTrophyCheck[2], 6), $aAtkRprtTrophyCheck[3]) Then
			$iTrophyLast = -$iTrophyLast
		EndIf
		SetLog("Loot: [G]: " & _NumberFormat($iGoldLast) & " [E]: " & _NumberFormat($iElixirLast) & " [DE]: " & _NumberFormat($iDarkLast) & " [T]: " & $iTrophyLast, $COLOR_GREEN)
	Else
		$iGoldLast = getResourcesLoot(333, 289 + $midOffsetY)
		If _Sleep($iDelayAttackReport2) Then Return
		$iElixirLast = getResourcesLoot(333, 328 + $midOffsetY)
		If _Sleep($iDelayAttackReport2) Then Return
		$iTrophyLast = getResourcesLootT(403, 365 + $midOffsetY)
		If _ColorCheck(_GetPixelColor($aAtkRprtTrophyCheck[0], $aAtkRprtTrophyCheck[1], True), Hex($aAtkRprtTrophyCheck[2], 6), $aAtkRprtTrophyCheck[3]) Then
			$iTrophyLast = -$iTrophyLast
		EndIf
		$iDarkLast = ""
		SetLog("Loot: [G]: " & _NumberFormat($iGoldLast) & " [E]: " & _NumberFormat($iElixirLast) & " [T]: " & $iTrophyLast, $COLOR_GREEN)
	EndIf

	If $iTrophyLast >= 0 Then
		$iBonusLast = Number(getResourcesBonusPerc(570, 309 + $midOffsetY))
		If $iBonusLast > 0 Then
			SetLog("Bonus Percentage: " & $iBonusLast & "%")
			Local $iCalcMaxBonus = 0, $iCalcMaxBonusDark = 0

			If _ColorCheck(_GetPixelColor($aAtkRprtDECheck2[0], $aAtkRprtDECheck2[1], True), Hex($aAtkRprtDECheck2[2], 6), $aAtkRprtDECheck2[3]) Then
				If _Sleep($iDelayAttackReport2) Then Return
				$iGoldLastBonus = getResourcesBonus(590, 340 + $midOffsetY)
				$iGoldLastBonus = StringReplace($iGoldLastBonus, "+", "")
				If _Sleep($iDelayAttackReport2) Then Return
				$iElixirLastBonus = getResourcesBonus(590, 371 + $midOffsetY)
				$iElixirLastBonus = StringReplace($iElixirLastBonus, "+", "")
				If _Sleep($iDelayAttackReport2) Then Return
				$iDarkLastBonus = getResourcesBonus(621, 402 + $midOffsetY)
				$iDarkLastBonus = StringReplace($iDarkLastBonus, "+", "")

				If $iBonusLast = 100 Then
					$iCalcMaxBonus = $iGoldLastBonus
					SetLog("Bonus [G]: " & _NumberFormat($iGoldLastBonus) & " [E]: " & _NumberFormat($iElixirLastBonus) & " [DE]: " & _NumberFormat($iDarkLastBonus), $COLOR_GREEN)
				Else
					$iCalcMaxBonus = Number($iGoldLastBonus / ($iBonusLast / 100))
					$iCalcMaxBonusDark = Number($iDarkLastBonus / ($iBonusLast / 100))

					SetLog("Bonus [G]: " & _NumberFormat($iGoldLastBonus) & " out of " & _NumberFormat($iCalcMaxBonus) & " [E]: " & _NumberFormat($iElixirLastBonus) & " out of " & _NumberFormat($iCalcMaxBonus) & " [DE]: " & _NumberFormat($iDarkLastBonus) & " out of " & _NumberFormat($iCalcMaxBonusDark), $COLOR_GREEN)
				EndIf
			Else
				If _Sleep($iDelayAttackReport2) Then Return
				$iGoldLastBonus = getResourcesBonus(590, 340 + $midOffsetY)
				$iGoldLastBonus = StringReplace($iGoldLastBonus, "+", "")
				If _Sleep($iDelayAttackReport2) Then Return
				$iElixirLastBonus = getResourcesBonus(590, 371 + $midOffsetY)
				$iElixirLastBonus = StringReplace($iElixirLastBonus, "+", "")
				$iDarkLastBonus = 0

				If $iBonusLast = 100 Then
					$iCalcMaxBonus = $iGoldLastBonus
					SetLog("Bonus [G]: " & _NumberFormat($iGoldLastBonus) & " [E]: " & _NumberFormat($iElixirLastBonus), $COLOR_GREEN)
				Else
					$iCalcMaxBonus = Number($iGoldLastBonus / ($iBonusLast / 100))
					SetLog("Bonus [G]: " & _NumberFormat($iGoldLastBonus) & " out of " & _NumberFormat($iCalcMaxBonus) & " [E]: " & _NumberFormat($iElixirLastBonus) & " out of " & _NumberFormat($iCalcMaxBonus), $COLOR_GREEN)
				EndIf
			EndIf

			$LeagueShort = "--"
			For $i = 1 To 21 ; skip 0 = Bronze III, see "No Bonus" else section below
				If _Sleep($iDelayAttackReport2) Then Return
				If $League[$i][0] = $iCalcMaxBonus Then
					SetLog("Your league level is: " & $League[$i][1])
					$LeagueShort = $League[$i][3]
					ExitLoop
				EndIf
			Next
		Else
			SetLog("No Bonus")

			$LeagueShort = "--"
			If $iTrophyCurrent + $iTrophyLast >= 400 And $iTrophyCurrent + $iTrophyLast < 500 Then ; Bronze III has no League bonus
				SetLog("Your league level is: " & $League[0][1])
				$LeagueShort = $League[0][3]
			EndIf
		EndIf
		;Display League in Stats ==>
		GUICtrlSetData($lblLeague, "")
		
		If StringInStr($LeagueShort, "1") > 1 Then
			GUICtrlSetData($lblLeague, "1")
		ElseIf StringInStr($LeagueShort, "2") > 1 Then
			GUICtrlSetData($lblLeague, "2")
		ElseIf StringInStr($LeagueShort, "3") > 1 Then
			GUICtrlSetData($lblLeague, "3")
		EndIf
		_GUI_Value_STATE("HIDE",$groupLeague)
		If StringInStr($LeagueShort, "B") > 0 Then
			GUICtrlSetState($BronzeLeague,$GUI_SHOW)
		ElseIf StringInStr($LeagueShort, "S") > 0 Then
			GUICtrlSetState($SilverLeague,$GUI_SHOW)
		ElseIf StringInStr($LeagueShort, "G") > 0 Then
			GUICtrlSetState($GoldLeague,$GUI_SHOW)
		ElseIf StringInStr($LeagueShort, "c") > 0 Then
			GUICtrlSetState($CrystalLeague,$GUI_SHOW)
		ElseIf StringInStr($LeagueShort, "M") > 0 Then
			GUICtrlSetState($MasterLeague,$GUI_SHOW)
		ElseIf StringInStr($LeagueShort, "C") > 0 Then
			GUICtrlSetState($ChampionLeague,$GUI_SHOW)
		ElseIf StringInStr($LeagueShort, "T") > 0 Then
			GUICtrlSetState($TitanLeague,$GUI_SHOW)
		ElseIf StringInStr($LeagueShort, "LE") > 0 Then
			GUICtrlSetState($LegendLeague,$GUI_SHOW)
		Else
			GUICtrlSetState($UnrankedLeague,$GUI_SHOW)
		EndIf
		;==> Display League in Stats
	Else
		$iGoldLastBonus = 0
		$iElixirLastBonus = 0
		$iDarkLastBonus = 0
		$LeagueShort = "--"
	EndIf

	; check stars earned
	Local $starsearned = 0
	If _ColorCheck(_GetPixelColor($aWonOneStarAtkRprt[0], $aWonOneStarAtkRprt[1], True), Hex($aWonOneStarAtkRprt[2], 6), $aWonOneStarAtkRprt[3]) Then $starsearned += 1
	If _ColorCheck(_GetPixelColor($aWonTwoStarAtkRprt[0], $aWonTwoStarAtkRprt[1], True), Hex($aWonTwoStarAtkRprt[2], 6), $aWonTwoStarAtkRprt[3]) Then $starsearned += 1
	If _ColorCheck(_GetPixelColor($aWonThreeStarAtkRprt[0], $aWonThreeStarAtkRprt[1], True), Hex($aWonThreeStarAtkRprt[2], 6), $aWonThreeStarAtkRprt[3]) Then $starsearned += 1
	SetLog("Stars earned: " & $starsearned)

	Local $AtkLogTxt
	$AtkLogTxt = "" & _NowTime(4) & "|"
	$AtkLogTxt &= StringFormat("%5d", $iTrophyCurrent) & "|"
	$AtkLogTxt &= StringFormat("%6d", $SearchCount) & "|"
	$AtkLogTxt &= StringFormat("%7d", $iGoldLast) & "|"
	$AtkLogTxt &= StringFormat("%7d", $iElixirLast) & "|"
	$AtkLogTxt &= StringFormat("%7d", $iDarkLast) & "|"
	$AtkLogTxt &= StringFormat("%3d", $iTrophyLast) & "|"
	$AtkLogTxt &= StringFormat("%1d", $starsearned) & "|"
	$AtkLogTxt &= StringFormat("%6d", $iGoldLastBonus) & "|"
	$AtkLogTxt &= StringFormat("%6d", $iElixirLastBonus) & "|"
	$AtkLogTxt &= StringFormat("%4d", $iDarkLastBonus) & "|"
	$AtkLogTxt &= $LeagueShort & "|"

	Local $AtkLogTxtExtend
	$AtkLogTxtExtend = "|"
	$AtkLogTxtExtend &= $CurCamp & "/" & $TotalCamp & "|"
	If Int($iTrophyLast) >= 0 Then
		SetAtkLog($AtkLogTxt, $AtkLogTxtExtend, $COLOR_BLACK)
	Else
		SetAtkLog($AtkLogTxt, $AtkLogTxtExtend, $COLOR_RED)
	EndIf

	; Share Replay
	If $iShareAttack = 1 Then
		If (Number($iGoldLast) >= Number($iShareminGold)) And (Number($iElixirLast) >= Number($iShareminElixir)) And (Number($iDarkLast) >= Number($iSharemindark)) Then
			SetLog("Reached miminum Loot values... Share Replay")
			$iShareAttackNow = 1
		Else
			SetLog("Below miminum Loot values... No Share Replay")
			$iShareAttackNow = 0
		EndIf
	EndIf

	If $FirstAttack = 0 Then $FirstAttack = 1
	$iGoldTotal += $iGoldLast + $iGoldLastBonus
	$iTotalGoldGain[$iMatchMode] += $iGoldLast + $iGoldLastBonus
	$iElixirTotal += $iElixirLast + $iElixirLastBonus
	$iTotalElixirGain[$iMatchMode] += $iElixirLast + $iElixirLastBonus
	If $iDarkStart <> "" Then
		$iDarkTotal += $iDarkLast + $iDarkLastBonus
		$iTotalDarkGain[$iMatchMode] += $iDarkLast + $iDarkLastBonus
	EndIf
	$iTrophyTotal += $iTrophyLast
	$iTotalTrophyGain[$iMatchMode] += $iTrophyLast
	If $iMatchMode = $TS Then
		If $starsearned > 0 Then
			$iNbrOfTHSnipeSuccess += 1
		Else
			$iNbrOfTHSnipeFails += 1
		EndIf
	EndIf
	$iAttackedVillageCount[$iMatchMode] += 1
	UpdateStats()

EndFunc   ;==>AttackReport
