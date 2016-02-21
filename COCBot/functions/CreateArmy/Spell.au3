
; #FUNCTION# ====================================================================================================================
; Name ..........: BrewSpells
; Description ...: Create Normal Spells and Dark Spells
; Syntax ........: BrewSpells()
; Parameters ....:
; Return values .: None
; Author ........: ProMac ( 08-2015)
; Modified ......: Monkeyhunter (01-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func BrewSpells()

	; ATTENTION : This function only works if the ArmyOverView Windows is open
	; Spell Creation
	; Dark Spell Factory

	If $iTotalCountSpell = 0 Then Return

	If $CurSFactory < $TotalSFactory Then ;  If not full the Spell Factory then try to make spells

		; Spell Creation
		; Normal Spell Factory

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
					Local $iLightningSpell = $iLightningSpellComp - ($CurLightningSpell + $iTempLightningSpell)
					If $debugSetlog = 1 Then SetLog("Making Lightning Spell: " & $iLightningSpell)
					If _sleep($iDelayTrain2) Then Return
					If $iTempLightningSpell = 0 Then
						If _ColorCheck(_GetPixelColor(239 + 107 * 0, 375 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) = False Then ; White into number 0
							setlog("Not enough Elixir to create Spell", $COLOR_RED)
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
					Local $iHealSpell = $iHealSpellComp - ($CurHealSpell + $iTempHealSpell)
					If $debugSetlog = 1 Then SetLog("Making Heal Spell: " & $iHealSpell)
					If _sleep($iDelayTrain2) Then Return
					If $iTempHealSpell = 0 Then
						If _ColorCheck(_GetPixelColor(239 + 107 * 1, 375 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) = False Then
							setlog("Not enough Elixir to create Spell", $COLOR_RED)
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
					Local $iRageSpell = $iRageSpellComp - ($CurRageSpell + $iTempRageSpell)
					If $debugSetlog = 1 Then SetLog("Making Rage Spell: " & $iRageSpell)
					If _sleep($iDelayTrain2) Then Return
					If $iTempRageSpell = 0 Then
						If _ColorCheck(_GetPixelColor(220 + 107 * 2, 375 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) = False Then
							setlog("Not enough Elixir to create Spell", $COLOR_RED)
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
					Local $iJumpSpell = $iJumpSpellComp - ($CurJumpSpell + $iTempJumpSpell)
					If $debugSetlog = 1 Then SetLog("Making Jump Spell: " & $iJumpSpell)
					If _sleep($iDelayTrain2) Then Return
					If $iTempJumpSpell = 0 Then
						If _ColorCheck(_GetPixelColor(239 + 107 * 3, 375 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) = False Then ; White into number 0
							setlog("Not enough Elixir to create Spell", $COLOR_RED)
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
					Local $iFreezeSpell = $iFreezeSpellComp - ($CurFreezeSpell + $iTempFreezeSpell)
					If $debugSetlog = 1 Then SetLog("Making Freeze Spell: " & $iFreezeSpell)
					If _sleep($iDelayTrain2) Then Return
					If $iTempFreezeSpell = 0 Then
						If _ColorCheck(_GetPixelColor(239 + 107 * 4, 375 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) = False Then ; White into number 0
							setlog("Not enough Elixir to create Spell", $COLOR_RED)
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
					Local $iPoisonSpell = $iPoisonSpellComp - ($CurPoisonSpell + $iTempPoisonSpell)
					If $debugSetlog = 1 Then SetLog("Making Poision Spell: " & $iPoisonSpell)
					If _sleep($iDelayTrain2) Then Return
					If $iTempPoisonSpell = 0 Then
						If _sleep($iDelayTrain2) Then Return
						If _ColorCheck(_GetPixelColor(239, 375 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) = False Then
							setlog("Not enough Elixir to create Spell", $COLOR_RED)
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
					Local $iEarthSpell = $iEarthSpellComp - ($CurEarthSpell + $iTempEarthSpell)
					If $debugSetlog = 1 Then SetLog("Making EarthQuake Spell: " & $iEarthSpell)
					If _sleep($iDelayTrain2) Then Return
					If $iTempEarthSpell = 0 Then
						If _sleep($iDelayTrain2) Then Return
						If _ColorCheck(_GetPixelColor(346, 375 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) = False Then ; black pixel in number 5
							setlog("Not enough Elixir to create Spell", $COLOR_RED)
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
					Local $iHasteSpell = $iHasteSpellComp - ($CurHasteSpell + $iTempHasteSpell)
					If $debugSetlog = 1 Then SetLog("Making Haste Spell: " & $iHasteSpell)
					If _sleep($iDelayTrain2) Then Return
					If $iTempHasteSpell = 0 Then
						If _sleep($iDelayTrain2) Then Return
						If _ColorCheck(_GetPixelColor(453, 375 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) = False Then ; black pixel in number 5
							setlog("Not enough Elixir to create Spell", $COLOR_RED)
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
	Else
		SetLog("Spell Factory is full ...", $COLOR_BLUE)
	EndIf
EndFunc   ;==>BrewSpells
