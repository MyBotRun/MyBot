

; #FUNCTION# ====================================================================================================================
; Name ..........: BrewSpells
; Description ...: Create Normal Spells and Dark Spells
; Syntax ........: BrewSpells()
; Parameters ....:
; Return values .: None
; Author ........: ProMac ( 08-2015)
; Modified ......: Monkeyhunter (01/05-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func BrewSpells()

	; ATTENTION : This function only works if the ArmyOverView Windows is open
	Local $iLightningSpell, $iHealSpell, $iRageSpell, $iJumpSpell, $iFreezeSpell, $iPoisonSpell, $iEarthSpell, $iHasteSpell

	If $iTotalCountSpell = 0 Then Return

	If $numFactorySpellAvaiables = 1 And ($iLightningSpellComp > 0 Or $iRageSpellComp > 0 Or $iHealSpellComp > 0 Or $iJumpSpellComp > 0 Or $iFreezeSpellComp > 0) Then
		$iBarrHere = 0
		While Not (isSpellFactory())
			If Not (IsTrainPage()) Then Return
			_TrainMoveBtn(+1) ;click Next button
			$iBarrHere += 1
			If _Sleep($iDelayTrain3) Then ExitLoop
			If $iBarrHere = 8 Then ExitLoop
		WEnd
		If isSpellFactory() Then
			If $iLightningSpellComp > 0 Then ; Lightning Spells
				Local $iTempLightningSpell = Number(getBarracksTroopQuantity(175 + 107 * 0, 296 + $midOffsetY))
				If $bFullSpell = True Then ;if spell factory full
					If $iTempLightningSpell = $iLightningSpellComp Then ; check if replacement spells trained,
						$iLightningSpell = 0
					Else
						$iLightningSpell = $iLightningSpellComp - $iTempLightningSpell ; add spells to queue to match GUI
					EndIf
				Else
					$iLightningSpell = $iLightningSpellComp - ($CurLightningSpell + $iTempLightningSpell) ; not full, add more spell if needed
				EndIf
				If $debugsetlogTrain = 1 Then SetLog("Making Lightning Spell: " & $iLightningSpell)
				If _sleep($iDelayTrain2) Then Return
				If $iLightningSpell > 0 Then
					If _ColorCheck(_GetPixelColor(235 + 107 * 0, 375 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) = False Then ; White into number 0
						setlog("Not enough Elixir to create Lightning Spell", $COLOR_RED)
						Return
					ElseIf _ColorCheck(_GetPixelColor(200, 346 + $midOffsetY, True), Hex(0x414141, 6), 20) Then
						setlog("Spell Factory Full", $COLOR_RED)
						Return
					Else
						If $iLightningSpell > 0 Then
							GemClick(220 + 107 * 0, 354 + $midOffsetY, $iLightningSpell, $iDelayTrain7, "#0290")
							SetLog("Created " & $iLightningSpell & " Lightning Spell(s)", $COLOR_BLUE)
						EndIf
					EndIf
				Else
					Setlog("Already done Lightning Spell(s)")
				EndIf
			EndIf
			If $iHealSpellComp > 0 Then ; Heal Spells
				Local $iTempHealSpell = Number(getBarracksTroopQuantity(175 + 107 * 1, 296 + $midOffsetY))
				If $bFullSpell = True Then ;if spell factory full
					If $iTempHealSpell = $iHealSpellComp Then ; check if replacement spells trained,
						$iHealSpell = 0
					Else
						$iHealSpell = $iHealSpellComp - $iTempHealSpell ; add spells to queue to match GUI
					EndIf
				Else
					$iHealSpell = $iHealSpellComp - ($CurHealSpell + $iTempHealSpell) ; not full, add more spell if needed
				EndIf
				If $debugsetlogTrain = 1 Then SetLog("Making Heal Spell: " & $iHealSpell)
				If _sleep($iDelayTrain2) Then Return
				If $iHealSpell > 0 Then
					If _ColorCheck(_GetPixelColor(235 + 107 * 1, 375 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) = False Then
						setlog("Not enough Elixir to create Heal Spell", $COLOR_RED)
						Return
					ElseIf _ColorCheck(_GetPixelColor(200, 346 + $midOffsetY, True), Hex(0x414141, 6), 20) Then
						setlog("Spell Factory Full", $COLOR_RED)
						Return
					Else
						If $iHealSpell > 0 Then
							GemClick(220 + 107 * 1, 354 + $midOffsetY, $iHealSpell, $iDelayTrain7, "#0290")
							SetLog("Created " & $iHealSpell & " Heal Spell(s)", $COLOR_BLUE)
						EndIf
					EndIf
				Else
					Setlog("Already done Heal Spell(s)")
				EndIf
			EndIf
			If $iRageSpellComp > 0 Then ; Rage Spells
				Local $iTempRageSpell = Number(getBarracksTroopQuantity(175 + 107 * 2, 296 + $midOffsetY))
				If $bFullSpell = True Then ;if spell factory full
					If $iTempRageSpell = $iRageSpellComp Then ; check if replacement spells trained,
						$iRageSpell = 0
					Else
						$iRageSpell = $iRageSpellComp - $iTempRageSpell ; add spells to queue to match GUI
					EndIf
				Else
					$iRageSpell = $iRageSpellComp - ($CurRageSpell + $iTempRageSpell) ; not full, add more spell if needed
				EndIf
				If $debugsetlogTrain = 1 Then SetLog("Making Rage Spell: " & $iRageSpell)
				If _sleep($iDelayTrain2) Then Return
				If $iRageSpell > 0 Then
					If _ColorCheck(_GetPixelColor(235 + 107 * 2, 375 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) = False Then
						setlog("Not enough Elixir to create Rage Spell", $COLOR_RED)
						Return
					ElseIf _ColorCheck(_GetPixelColor(200, 346 + $midOffsetY, True), Hex(0x414141, 6), 20) Then
						setlog("Spell Factory Full", $COLOR_RED)
						Return
					Else
						If $iRageSpell > 0 Then
							GemClick(220 + 107 * 2, 354 + $midOffsetY, $iRageSpell, $iDelayTrain7, "#0290")
							SetLog("Created " & $iRageSpell & " Rage Spell(s)", $COLOR_BLUE)
						EndIf
					EndIf
				Else
					Setlog("Already done Rage Spell(s)")
				EndIf
			EndIf
			If $iJumpSpellComp > 0 Then ; Jump Spells
				Local $iTempJumpSpell = Number(getBarracksTroopQuantity(175 + 107 * 3, 296 + $midOffsetY))
				If $bFullSpell = True Then ;if spell factory full
					If $iTempJumpSpell = $iJumpSpellComp Then ; check if replacement spells trained,
						$iJumpSpell = 0
					Else
						$iJumpSpell = $iJumpSpellComp - $iTempJumpSpell ; add spells to queue to match GUI
					EndIf
				Else
					$iJumpSpell = $iJumpSpellComp - ($CurJumpSpell + $iTempJumpSpell) ; not full, add more spell if needed
				EndIf
				If $debugsetlogTrain = 1 Then SetLog("Making Jump Spell: " & $iJumpSpell)
				If _sleep($iDelayTrain2) Then Return
				If $iJumpSpell > 0 Then
					If _ColorCheck(_GetPixelColor(235 + 107 * 3, 375 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) = False Then ; White into number 0
						setlog("Not enough Elixir to create Jump Spell", $COLOR_RED)
						Return
					ElseIf _ColorCheck(_GetPixelColor(200, 346 + $midOffsetY, True), Hex(0x414141, 6), 20) Then
						setlog("Spell Factory Full", $COLOR_RED)
						Return
					Else
						If $iJumpSpell > 0 Then
							GemClick(220 + 107 * 3, 354 + $midOffsetY, $iJumpSpell, $iDelayTrain7, "#0290")
							SetLog("Created " & $iJumpSpell & " Jump Spell(s)", $COLOR_BLUE)
						EndIf
					EndIf
				Else
					Setlog("Already done Jump Spell(s)")
				EndIf
			EndIf
			If $iFreezeSpellComp > 0 Then ; Freeze Spells
				Local $iTempFreezeSpell = Number(getBarracksTroopQuantity(175 + 107 * 4, 296 + $midOffsetY))
				If $bFullSpell = True Then ;if spell factory full
					If $iTempFreezeSpell = $iFreezeSpellComp Then ; check if replacement spells trained,
						$iFreezeSpell = 0
					Else
						$iFreezeSpell = $iFreezeSpellComp - $iTempFreezeSpell ; add spells to queue to match GUI
					EndIf
				Else
					$iFreezeSpell = $iFreezeSpellComp - ($CurFreezeSpell + $iTempFreezeSpell) ; not full, add more spell if needed
				EndIf
				If $debugsetlogTrain = 1 Then SetLog("Making Freeze Spell: " & $iFreezeSpell)
				If _sleep($iDelayTrain2) Then Return
				If $iFreezeSpell > 0 Then
					If _ColorCheck(_GetPixelColor(235 + 107 * 4, 375 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) = False Then ; White into number 0
						setlog("Not enough Elixir to create Freeze Spell", $COLOR_RED)
						Return
					ElseIf _ColorCheck(_GetPixelColor(200, 346 + $midOffsetY, True), Hex(0x414141, 6), 20) Then
						setlog("Spell Factory Full", $COLOR_RED)
						Return
					Else
						If $iFreezeSpell > 0 Then
							GemClick(220 + 107 * 4, 354 + $midOffsetY, $iFreezeSpell, $iDelayTrain7, "#0290")
							SetLog("Created " & $iFreezeSpell & " Freeze Spell(s)", $COLOR_BLUE)
						EndIf
					EndIf
				Else
					Setlog("Already done Freeze Spell(s)")
				EndIf
			EndIf
		Else
			SetLog("Spell Factory not found...", $COLOR_BLUE)
		EndIf
	EndIf

	If $numFactoryDarkSpellAvaiables = 1 And ($iPoisonSpellComp > 0 Or $iEarthSpellComp > 0 Or $iHasteSpellComp > 0) Then
		$iBarrHere = 0
		While Not (isDarkSpellFactory())
			If Not (IsTrainPage()) Then Return
			_TrainMoveBtn(+1) ;click Next button
			$iBarrHere += 1
			If $iBarrHere = 8 Then ExitLoop
			If _Sleep($iDelayTrain3) Then Return
		WEnd
		If isDarkSpellFactory() Then
			If $iPoisonSpellComp > 0 Then ; Poison Spells
				Local $iTempPoisonSpell = Number(getBarracksTroopQuantity(175 + 107 * 0, 296 + $midOffsetY))
				If $bFullSpell = True Then ;if spell factory full
					If $iTempPoisonSpell = $iPoisonSpellComp Then ; check if replacement spells trained,
						$iPoisonSpell = 0
					Else
						$iPoisonSpell = $iPoisonSpellComp - $iTempPoisonSpell ; add spells to queue to match GUI
					EndIf
				Else
					$iPoisonSpell = $iPoisonSpellComp - ($CurPoisonSpell + $iTempPoisonSpell) ; not full, add more spell if needed
				EndIf
				If $debugsetlogTrain = 1 Then SetLog("Making Poison Spell: " & $iPoisonSpell)
				If _sleep($iDelayTrain2) Then Return
				If $iPoisonSpell > 0 Then
					If _sleep($iDelayTrain2) Then Return
						If _ColorCheck(_GetPixelColor(233 + 107 * 0, 375 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) = False And _; White into number 0
						   _ColorCheck(_GetPixelColor(235 + 107 * 0, 375 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) = False Then ; White into number 5
						setlog("Not enough Elixir to create Poison Spell", $COLOR_RED)
						If $debugsetlogTrain = 1 Then setlog("colorceck: " & 233 + 107 * 0& "," &  375 + $midOffsetY,$COLOR_RED)
						Return
					ElseIf _ColorCheck(_GetPixelColor(200, 346 + $midOffsetY, True), Hex(0x414141, 6), 20) Then
						setlog("Spell Factory Full", $COLOR_RED)
						Return
					Else
						If $iPoisonSpell > 0 Then
							GemClick(222, 354 + $midOffsetY, $iPoisonSpell, $iDelayTrain7, "#0290")
							SetLog("Created " & $iPoisonSpell & " Poison Spell(s)", $COLOR_BLUE)
						EndIf
					EndIf
				Else
					Setlog("Already done Poison Spell(s)")
				EndIf
			EndIf

			If $iEarthSpellComp > 0 Then ; EarthQuake Spells
				Local $iTempEarthSpell = Number(getBarracksTroopQuantity(175 + 107 * 1, 296 + $midOffsetY))
				If $bFullSpell = True Then ;if spell factory full
					If $iTempEarthSpell = $iEarthSpellComp Then ; check if replacement spells trained,
						$iEarthSpell = 0
					Else
						$iEarthSpell = $iEarthSpellComp - $iTempEarthSpell ; add spells to queue to match GUI
					EndIf
				Else
					$iEarthSpell = $iEarthSpellComp - ($CurEarthSpell + $iTempEarthSpell) ; not full, add more spell if needed
				EndIf
				If $debugsetlogTrain = 1 Then SetLog("Making Earthquake Spell: " & $iEarthSpell)
				If _sleep($iDelayTrain2) Then Return
				If $iEarthSpell > 0 Then
					If _sleep($iDelayTrain2) Then Return
						If _ColorCheck(_GetPixelColor(233 + 107 * 1, 375 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) = False And _; White into number 0
						   _ColorCheck(_GetPixelColor(235 + 107 * 1, 375 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) = False Then ; White into number 5
						setlog("Not enough Elixir to create Earthquake Spell", $COLOR_RED)
						Return
					ElseIf _ColorCheck(_GetPixelColor(200, 346 + $midOffsetY, True), Hex(0x414141, 6), 20) Then
						setlog("Spell Factory Full", $COLOR_RED)
						Return
					Else
						If $iEarthSpell > 0 Then
							GemClick(329, 354 + $midOffsetY, $iEarthSpell, $iDelayTrain7, "#0290")
							SetLog("Created " & $iEarthSpell & " EarthQuake Spell(s)", $COLOR_BLUE)
						EndIf
					EndIf
				Else
					Setlog("Already done EarthQuake Spell(s)")
				EndIf
			EndIf

			If $iHasteSpellComp > 0 Then ; Haste Spells
				Local $iTempHasteSpell = Number(getBarracksTroopQuantity(175 + 107 * 2, 296 + $midOffsetY))
				If $bFullSpell = True Then ;if spell factory full
					If $iTempHasteSpell = $iHasteSpellComp Then ; check if replacement spells trained,
						$iHasteSpell = 0
					Else
						$iHasteSpell = $iHasteSpellComp - $iTempHasteSpell ; add spells to queue to match GUI
					EndIf
				Else
					$iHasteSpell = $iHasteSpellComp - ($CurHasteSpell + $iTempHasteSpell) ; not full, add more spell if needed
				EndIf
				If $debugsetlogTrain = 1 Then SetLog("Making Haste Spell: " & $iHasteSpell)
				If _sleep($iDelayTrain2) Then Return
				If $iHasteSpell > 0 Then
					If _sleep($iDelayTrain2) Then Return
						If _ColorCheck(_GetPixelColor(233 + 107 * 2, 375 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) = False And _; White into number 0
						   _ColorCheck(_GetPixelColor(235 + 107 * 2, 375 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) = False Then ; White into number 5
						setlog("Not enough Elixir to create Haste Spell", $COLOR_RED)
						Return
					ElseIf _ColorCheck(_GetPixelColor(200, 346 + $midOffsetY, True), Hex(0x414141, 6), 20) Then
						setlog("Spell Factory Full", $COLOR_RED)
						Return
					Else
						If $iHasteSpell > 0 Then
							GemClick(430, 354 + $midOffsetY, $iHasteSpell, $iDelayTrain7, "#0290")
							SetLog("Created " & $iHasteSpell & " Haste Spell(s)", $COLOR_BLUE)
						EndIf
					EndIf
				Else
					Setlog("Already done Haste Spell(s)")
				EndIf
			EndIf
		Else
			SetLog("Dark Spell Factory not found...", $COLOR_BLUE)
		EndIf
	EndIf

EndFunc   ;==>BrewSpells
