; #FUNCTION# ====================================================================================================================
; Name ..........: AttackReport
; Description ...: This function will report the loot from the last Attack: gold, elixir, dark elixir and trophies.
;                  It will also update the statistics to the GUI (Last Attack).
; Syntax ........: AttackReport()
; Parameters ....: None
; Return values .: None
; Author ........: Hervidero (2015-feb-10), Sardo (may-2015)
; Modified ......: Sardo (may-2015), Hervidero (may-2015), Knowjack (July 2015)
; Remarks .......: This file is part of ClashGameBot. Copyright 2015
;                  ClashGameBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
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
	While getResourcesLoot(333, 289) = "" ; check for gold value to be non-zero before reading other values as a secondary timer to make sure all values are available
		$iCount += 1
		If _Sleep($iDelayAttackReport1) Then Return
		If $debugSetlog = 1 Then Setlog("Waiting Attack Report Ready, " & ($iCount / 2) & " Seconds.", $COLOR_PURPLE)
		If $iCount > 20 Then ExitLoop ; wait 20*500ms = 10 seconds max before we have call the OCR read an error
	WEnd
	If $iCount > 20 Then Setlog("End of Attack scene read gold error, attack values my not be correct", $COLOR_BLUE)

	If _ColorCheck(_GetPixelColor($aAtkRprtDECheck[0], $aAtkRprtDECheck[1], True), Hex($aAtkRprtDECheck[2], 6), $aAtkRprtDECheck[3]) Then ; if the color of the DE drop detected
		$lootGold = getResourcesLoot(333, 289)
		If _Sleep($iDelayAttackReport2) Then Return
		$lootElixir = getResourcesLoot(333, 328)
		If _Sleep($iDelayAttackReport2) Then Return
		$lootDarkElixir = getResourcesLootDE(365, 365)
		If _Sleep($iDelayAttackReport2) Then Return
		$lootTrophies = getResourcesLootT(403, 402)
		If _ColorCheck(_GetPixelColor($aAtkRprtTrophyCheck[0], $aAtkRprtTrophyCheck[1], True), Hex($aAtkRprtTrophyCheck[2], 6), $aAtkRprtTrophyCheck[3]) Then
			$lootTrophies = -$lootTrophies
		EndIf
		SetLog("Loot: [G]: " & _NumberFormat($lootGold) & " [E]: " & _NumberFormat($lootElixir) & " [DE]: " & _NumberFormat($lootDarkElixir) & " [T]: " & $lootTrophies, $COLOR_GREEN)

		If $FirstAttack = 1 Then GUICtrlSetState($lblLastAttackTemp, $GUI_HIDE)

		GUICtrlSetData($lblGoldLastAttack, _NumberFormat($lootGold))
		GUICtrlSetData($lblElixirLastAttack, _NumberFormat($lootElixir))
		GUICtrlSetData($lblDarkLastAttack, _NumberFormat($lootDarkElixir))
		GUICtrlSetData($lblTrophyLastAttack, _NumberFormat($lootTrophies))
	Else
		$lootGold = getResourcesLoot(333, 289)
		If _Sleep($iDelayAttackReport2) Then Return
		$lootElixir = getResourcesLoot(333, 328)
		If _Sleep($iDelayAttackReport2) Then Return
		$lootTrophies = getResourcesLootT(403, 365)
		If _ColorCheck(_GetPixelColor($aAtkRprtTrophyCheck[0], $aAtkRprtTrophyCheck[1], True), Hex($aAtkRprtTrophyCheck[2], 6), $aAtkRprtTrophyCheck[3]) Then
			$lootTrophies = -$lootTrophies
		EndIf
		$lootDarkElixir = 0
		SetLog("Loot: [G]: " & _NumberFormat($lootGold) & " [E]: " & _NumberFormat($lootElixir) & " [DE]: " & _NumberFormat($lootDarkElixir) & " [T]: " & $lootTrophies, $COLOR_GREEN)

		If $FirstAttack = 1 Then GUICtrlSetState($lblLastAttackTemp, $GUI_HIDE)

		GUICtrlSetData($lblGoldLastAttack, _NumberFormat($lootGold))
		GUICtrlSetData($lblElixirLastAttack, _NumberFormat($lootElixir))
		GUICtrlSetData($lblDarkLastAttack, "")
		GUICtrlSetData($lblTrophyLastAttack, _NumberFormat($lootTrophies))
	EndIf

	If $lootTrophies >= 0 Then
		If _ColorCheck(_GetPixelColor($aAtkRprtDECheck2[0], $aAtkRprtDECheck2[1], True), Hex($aAtkRprtDECheck2[2], 6), $aAtkRprtDECheck2[3]) Then
			If _Sleep($iDelayAttackReport2) Then Return
			$BonusLeagueG = getResourcesBonus(590, 340)
			$BonusLeagueG = StringReplace($BonusLeagueG, "+", "")
			If _Sleep($iDelayAttackReport2) Then Return
			$BonusLeagueE = getResourcesBonus(590, 371)
			$BonusLeagueE = StringReplace($BonusLeagueE, "+", "")
			If _Sleep($iDelayAttackReport2) Then Return
			$BonusLeagueD = getResourcesBonus(621, 402)
			$BonusLeagueD = StringReplace($BonusLeagueD, "+", "")
			SetLog("Bonus [G]: " & _NumberFormat($BonusLeagueG) & " [E]: " & _NumberFormat($BonusLeagueE) & " [DE]: " & _NumberFormat($BonusLeagueD), $COLOR_GREEN)
		Else
			If _Sleep($iDelayAttackReport2) Then Return
			$BonusLeagueG = getResourcesBonus(590, 340)
			$BonusLeagueG = StringReplace($BonusLeagueG, "+", "")
			If _Sleep($iDelayAttackReport2) Then Return
			$BonusLeagueE = getResourcesBonus(590, 371)
			$BonusLeagueE = StringReplace($BonusLeagueE, "+", "")
			SetLog("Bonus [G]: " & _NumberFormat($BonusLeagueG) & " [E]: " & _NumberFormat($BonusLeagueE), $COLOR_GREEN)
		EndIf
		$LeagueShort = "--"
		For $i = 0 To 15
			If _Sleep($iDelayAttackReport2) Then Return
			If $League[$i][0] = $BonusLeagueG Then
				SetLog("Your league level is: " & $League[$i][1])
				$LeagueShort = $League[$i][3]
				ExitLoop
			EndIf
		Next
	Else
		$BonusLeagueG = 0
		$BonusLeagueE = 0
		$BonusLeagueD = 0
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
	$AtkLogTxt &= StringFormat("%5d", $TrophyCount) & "|"
	$AtkLogTxt &= StringFormat("%6d", $SearchCount) & "|"
	$AtkLogTxt &= StringFormat("%7d", $lootGold) & "|"
	$AtkLogTxt &= StringFormat("%7d", $lootElixir) & "|"
	$AtkLogTxt &= StringFormat("%7d", $lootDarkElixir) & "|"
	$AtkLogTxt &= StringFormat("%3d", $lootTrophies) & "|"
	$AtkLogTxt &= StringFormat("%1d", $starsearned) & "|"
	$AtkLogTxt &= StringFormat("%6d", $BonusLeagueG) & "|"
	$AtkLogTxt &= StringFormat("%6d", $BonusLeagueE) & "|"
	$AtkLogTxt &= StringFormat("%4d", $BonusLeagueD) & "|"
	$AtkLogTxt &= $LeagueShort & "|"
	SetAtkLog($AtkLogTxt)

	; Share Replay
	If $iShareAttack = 1 Then
		If (Number($lootGold) >= Number($iShareminGold)) And (Number($lootElixir) >= Number($iShareminElixir)) And (Number($lootDarkElixir) >= Number($iSharemindark)) Then
			SetLog("reach miminum loots values... share Replay")
			$iShareAttackNow = 1
		Else
			SetLog("under miminum loots values... no share Replay")
			$iShareAttackNow = 0
		EndIf
	EndIf

EndFunc   ;==>AttackReport
