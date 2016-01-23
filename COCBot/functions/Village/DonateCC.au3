; #FUNCTION# ====================================================================================================================
; Name ..........: DonateCC
; Description ...: This file includes functions to Donate troops
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Zax (2015)
; Modified ......: Safar46 (2015), Hervidero (2015-04), HungLe (2015-04), Sardo (2015-08), Promac (2015-12), Hervidero (2016-01)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $DonationWindowY

Func DonateCC($Check = False)

	Local $bDonateTroop = BitOR($iChkDonateBarbarians, $iChkDonateArchers, $iChkDonateGiants, $iChkDonateGoblins, _
			$iChkDonateWallBreakers, $iChkDonateBalloons, $iChkDonateWizards, $iChkDonateHealers, _
			$iChkDonateDragons, $iChkDonatePekkas, $iChkDonateMinions, $iChkDonateHogRiders, _
			$iChkDonateValkyries, $iChkDonateGolems, $iChkDonateWitches, $iChkDonateLavaHounds, $iChkDonateCustom)

	Local $bDonateAllTroop = BitOR($iChkDonateAllBarbarians, $iChkDonateAllArchers, $iChkDonateAllGiants, $iChkDonateAllGoblins, _
			$iChkDonateAllWallBreakers, $iChkDonateAllBalloons, $iChkDonateAllWizards, $iChkDonateAllHealers, _
			$iChkDonateAllDragons, $iChkDonateAllPekkas, $iChkDonateAllMinions, $iChkDonateAllHogRiders, _
			$iChkDonateAllValkyries, $iChkDonateAllGolems, $iChkDonateAllWitches, $iChkDonateAllLavaHounds, $iChkDonateAllCustom)

	Local $bDonateSpell = BitOR($iChkDonatePoisonSpells, $iChkDonateEarthQuakeSpells, $iChkDonateHasteSpells)
	Local $bDonateAllSpell = BitOR($iChkDonateAllPoisonSpells, $iChkDonateAllEarthQuakeSpells, $iChkDonateAllHasteSpells)
	Local $bOpen = True, $bClose = False

	Global $bDonate = BitOR($bDonateTroop, $bDonateAllTroop, $bDonateSpell, $bDonateAllSpell)
	Global $iTotalDonateCapacity, $iTotalDonateSpellCapacity

	Global $iDonTroopsLimit = 5, $iDonSpellsLimit = 1, $iDonTroopsAv = 0, $iDonSpellsAv = 0
	Global $iDonTroopsQuantityAv = 0, $iDonTroopsQuantity = 0, $iDonSpellsQuantityAv = 0, $iDonSpellsQuantity = 0

	Global $bSkipDonTroops = False, $bSkipDonSpells = False

	If $bDonate = False Or $bDonationEnabled = False Then Return ; exit func if no donate checkmarks

	If $iPlannedDonateHoursEnable = 1 Then
		Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
		If $iPlannedDonateHours[$hour[0]] = 0 Then
			SetLog("Donate Clan Castle troops not planned, Skipped..", $COLOR_ORANGE)
			Return ; exit func if no planned donate checkmarks
		EndIf
	EndIf

	Local $y = 119

	;check for new chats first
	If $Check = True Then
		If _ColorCheck(_GetPixelColor(26, 312 + $midOffsetY, True), Hex(0xf00810, 6), 20) = False And $CommandStop <> 3 Then
			Return ;exit if no new chats
		EndIf
	EndIf

	ClickP($aAway, 1, 0, "#0167") ;Click Away
	Setlog("Checking for Donate Requests in Clan Chat", $COLOR_BLUE)

	If _CheckPixel($aChatTab, $bCapturePixel) = False Then ClickP($aOpenChat, 1, 0, "#0168") ; Clicks chat tab
	If _Sleep($iDelayDonateCC1) Then Return

	ClickP($aClanTab, 1, 0, "#0169") ; clicking clan tab
	If _Sleep($iDelayDonateCC2) Then Return

	Local $Scroll, $offColors[3][3] = [[0x010101, 0, -4], [0xb8e050, 0, 13], [0xb0da49, 0, 16]]; $offColors[3][3] = [[0x000000, 0, -2], [0x262926, 0, 1], [0xF8FCF0, 0, 11]]
	While $bDonate
		checkAttackDisable($iTaBChkIdle) ; Early Take-A-Break detection

		If _Sleep($iDelayDonateCC2) Then ExitLoop
		$DonatePixel = _MultiPixelSearch(202, $y, 203, 660 + $bottomOffsetY, 1, 1, Hex(0xc0e460, 6), $offColors, 15)
		If IsArray($DonatePixel) Then ; if Donate Button found
			If $debugSetlog = 1 Then Setlog("$DonatePixel: (" & $DonatePixel[0] & "," & $DonatePixel[1] & ")", $COLOR_PURPLE)

			;reset every run
			$bDonate = False
			$bSkipDonTroops = False
			$bSkipDonSpells = False

			;Read chat request for DonateTroop and DonateSpell
			If $bDonateTroop Or $bDonateSpell Then
				If $ichkExtraAlphabets = 1 Then
					; Chat Request , Latin + Turkish + Extra latin + Cyrillic Alphabets / three paragraphs.
					Local $ClanString = ""
					$ClanString = getChatString(30, $DonatePixel[1] - 78, "coc-latin-cyr")
					If $ClanString = "" Then
						$ClanString = getChatString(30, $DonatePixel[1] - 64, "coc-latin-cyr")
					Else
						$ClanString &= " " & getChatString(30, $DonatePixel[1] - 64, "coc-latin-cyr")
					EndIf
					If $ClanString = "" Or $ClanString = " " Then
						$ClanString = getChatString(30, $DonatePixel[1] - 53, "coc-latin-cyr")
					Else
						$ClanString &= " " & getChatString(30, $DonatePixel[1] - 53, "coc-latin-cyr")
					EndIf
					If _Sleep($iDelayDonateCC2) Then ExitLoop
				Else
					; Chat Request , Latin + Turkish + Extra / three paragraphs.
					Local $ClanString = ""
					$ClanString = getChatString(30, $DonatePixel[1] - 78, "coc-latinA")
					If $ClanString = "" Then
						$ClanString = getChatString(30, $DonatePixel[1] - 64, "coc-latinA")
					Else
						$ClanString &= " " & getChatString(30, $DonatePixel[1] - 64, "coc-latinA")
					EndIf
					If $ClanString = "" Or $ClanString = " " Then
						$ClanString = getChatString(30, $DonatePixel[1] - 53, "coc-latinA")
					Else
						$ClanString &= " " & getChatString(30, $DonatePixel[1] - 53, "coc-latinA")
					EndIf
					If _Sleep($iDelayDonateCC2) Then ExitLoop
				EndIf

				If $ClanString = "" Or $ClanString = " " Then
					SetLog("Unable to read Chat Request!", $COLOR_RED)
					$bDonate = True
					$y = $DonatePixel[1] + 30
					ContinueLoop
				Else
					If $ichkExtraAlphabets = 1 Then
						ClipPut($ClanString)
						Local $tempClip = ClipGet()
						SetLog("Chat Request: " & $tempClip)
					Else
						SetLog("Chat Request: " & $ClanString)
					EndIf
				EndIf
			EndIf

			; Get remaining CC capacity of requested troops from your ClanMates
			RemainingCCcapacity()

			If $iTotalDonateCapacity <= 0 Then
				Setlog("Clan Castle troops are full, skip troop donation...", $COLOR_ORANGE)
				$bSkipDonTroops = True
			EndIf
			If $iTotalDonateSpellCapacity = 0 Then
				Setlog("Clan Castle spells are full, skip spell donation...", $COLOR_ORANGE)
				$bSkipDonSpells = True
			ElseIf $iTotalDonateSpellCapacity = -1 Then
				; no message, this CC has no Spell capability
				If $debugSetlog = 1 Then Setlog("This CC cannot accept spells, skip spell donation...", $COLOR_PURPLE)
				$bSkipDonSpells = True
			EndIf

			; open Donate Window
			If DonateWindow($bOpen) = False Then
				$bDonate = True
				$y = $DonatePixel[1] + 30
				ContinueLoop ; go to next button if donate window did not open
			EndIf

			If $bDonateTroop Or $bDonateSpell Then
				If $debugSetlog = 1 Then Setlog("Troop/Spell checkpoint.", $COLOR_PURPLE)

				; read available donate cap, and ByRef set the $bSkipDonTroops and $bSkipDonSpells flags
				DonateWindowCap($bSkipDonTroops, $bSkipDonSpells)
				If $bSkipDonTroops And $bSkipDonSpells Then
					$bDonate = True
					$y = $DonatePixel[1] + 30
					ContinueLoop ; go to next button if already donated, maybe this is an impossible case..
				EndIf

				If $bDonateTroop = 1 And $bSkipDonTroops = False Then
					If $debugSetlog = 1 Then Setlog("Troop checkpoint.", $COLOR_PURPLE)

					;;; Custom Combination Donate by ChiefM3
					If $iChkDonateCustom = 1 And CheckDonateTroop(19, $aDonCustom, $aBlkCustom, $aBlackList, $ClanString) Then
						For $i = 0 To 2
							If $varDonateCustom[$i][0] < $eBarb Then
								$varDonateCustom[$i][0] = $eArch ; Change strange small numbers to archer
							ElseIf $varDonateCustom[$i][0] > $eLava Then
								ContinueLoop ; If "Nothing" is selected then continue
							EndIf
							If $varDonateCustom[$i][1] < 1 Then
								ContinueLoop ; If donate number is smaller than 1 then continue
							ElseIf $varDonateCustom[$i][1] > 8 Then
								$varDonateCustom[$i][1] = 8 ; Number larger than 8 is unnecessary
							EndIf
							DonateTroopType($varDonateCustom[$i][0], $varDonateCustom[$i][1], $iChkDonateCustom) ;;; Donate Custom Troop using DonateTroopType2
						Next
					EndIf

					If $iChkDonateBarbarians = 1 And $bSkipDonTroops = False And CheckDonateTroop($eBarb, $aDonBarbarians, $aBlkBarbarians, $aBlackList, $ClanString) Then DonateTroopType($eBarb)
					If $iChkDonateArchers = 1 And $bSkipDonTroops = False And CheckDonateTroop($eArch, $aDonArchers, $aBlkArchers, $aBlackList, $ClanString) Then DonateTroopType($eArch)
					If $iChkDonateGiants = 1 And $bSkipDonTroops = False And CheckDonateTroop($eGiant, $aDonGiants, $aBlkGiants, $aBlackList, $ClanString) Then DonateTroopType($eGiant)
					If $iChkDonateGoblins = 1 And $bSkipDonTroops = False And CheckDonateTroop($eGobl, $aDonGoblins, $aBlkGoblins, $aBlackList, $ClanString) Then DonateTroopType($eGobl)
					If $iChkDonateWallBreakers = 1 And $bSkipDonTroops = False And CheckDonateTroop($eWall, $aDonWallBreakers, $aBlkWallBreakers, $aBlackList, $ClanString) Then DonateTroopType($eWall)
					If $iChkDonateBalloons = 1 And $bSkipDonTroops = False And CheckDonateTroop($eBall, $aDonBalloons, $aBlkBalloons, $aBlackList, $ClanString) Then DonateTroopType($eBall)
					If $iChkDonateWizards = 1 And $bSkipDonTroops = False And CheckDonateTroop($eWiza, $aDonWizards, $aBlkWizards, $aBlackList, $ClanString) Then DonateTroopType($eWiza)
					If $iChkDonateHealers = 1 And $bSkipDonTroops = False And CheckDonateTroop($eHeal, $aDonHealers, $aBlkHealers, $aBlackList, $ClanString) Then DonateTroopType($eHeal)
					If $iChkDonateDragons = 1 And $bSkipDonTroops = False And CheckDonateTroop($eDrag, $aDonDragons, $aBlkDragons, $aBlackList, $ClanString) Then DonateTroopType($eDrag)
					If $iChkDonatePekkas = 1 And $bSkipDonTroops = False And CheckDonateTroop($ePekk, $aDonPekkas, $aBlkPekkas, $aBlackList, $ClanString) Then DonateTroopType($ePekk)
					If $iChkDonateMinions = 1 And $bSkipDonTroops = False And CheckDonateTroop($eMini, $aDonMinions, $aBlkMinions, $aBlackList, $ClanString) Then DonateTroopType($eMini)
					If $iChkDonateHogRiders = 1 And $bSkipDonTroops = False And CheckDonateTroop($eHogs, $aDonHogRiders, $aBlkHogRiders, $aBlackList, $ClanString) Then DonateTroopType($eHogs)
					If $iChkDonateValkyries = 1 And $bSkipDonTroops = False And CheckDonateTroop($eValk, $aDonValkyries, $aBlkValkyries, $aBlackList, $ClanString) Then DonateTroopType($eValk)
					If $iChkDonateGolems = 1 And $bSkipDonTroops = False And CheckDonateTroop($eGole, $aDonGolems, $aBlkGolems, $aBlackList, $ClanString) Then DonateTroopType($eGole)
					If $iChkDonateWitches = 1 And $bSkipDonTroops = False And CheckDonateTroop($eWitc, $aDonWitches, $aBlkWitches, $aBlackList, $ClanString) Then DonateTroopType($eWitc)
					If $iChkDonateLavaHounds = 1 And $bSkipDonTroops = False And CheckDonateTroop($eLava, $aDonLavaHounds, $aBlkLavaHounds, $aBlackList, $ClanString) Then DonateTroopType($eLava)

				EndIf

				If $bDonateSpell = 1 And $bSkipDonSpells = False Then
					If $debugSetlog = 1 Then Setlog("Spell checkpoint.", $COLOR_PURPLE)
					If $iChkDonatePoisonSpells = 1 And $bSkipDonSpells = False And CheckDonateTroop($ePSpell, $aDonPoisonSpells, $aBlkPoisonSpells, $aBlackList, $ClanString) Then DonateTroopType($ePSpell)
					If $iChkDonateEarthQuakeSpells = 1 And $bSkipDonSpells = False And CheckDonateTroop($eESpell, $aDonEarthQuakeSpells, $aBlkEarthQuakeSpells, $aBlackList, $ClanString) Then DonateTroopType($eESpell)
					If $iChkDonateHasteSpells = 1 And $bSkipDonSpells = False And CheckDonateTroop($eHaSpell, $aDonHasteSpells, $aBlkHasteSpells, $aBlackList, $ClanString) Then DonateTroopType($eHaSpell)
				EndIf
			EndIf

			If $bDonateAllTroop Or $bDonateAllSpell Then
				If $debugSetlog = 1 Then Setlog("Troop/Spell All checkpoint.", $COLOR_PURPLE)

				; read available donate cap again, and ByRef set the $bSkipDonTroops and $bSkipDonSpells flags
				DonateWindowCap($bSkipDonTroops, $bSkipDonSpells)
				If $bSkipDonTroops And $bSkipDonSpells Then
					$bDonate = True
					$y = $DonatePixel[1] + 30
					ContinueLoop ; go to next button if already donated max, maybe this is an impossible case..
				EndIf

				If $bDonateAllTroop And $bSkipDonTroops = False Then
					If $debugSetlog = 1 Then Setlog("Troop All checkpoint.", $COLOR_PURPLE)
					Select
						Case $iChkDonateAllCustom = 1
							For $i = 0 To 2
								If $varDonateCustom[$i][0] < $eBarb Then
									$varDonateCustom[$i][0] = $eArch ; Change strange small numbers to archer
								ElseIf $varDonateCustom[$i][0] > $eLava Then
									ContinueLoop ; If "Nothing" is selected then continue
								EndIf
								If $varDonateCustom[$i][1] < 1 Then
									ContinueLoop ; If donate number is smaller than 1 then continue
								ElseIf $varDonateCustom[$i][1] > 8 Then
									$varDonateCustom[$i][1] = 8 ; Number larger than 8 is unnecessary
								EndIf
								DonateTroopType($varDonateCustom[$i][0], $varDonateCustom[$i][1], $iChkDonateAllCustom, $bDonateAllTroop) ;;; Donate Custom Troop using DonateTroopType2
							Next
						Case $iChkDonateAllBarbarians = 1
							DonateTroopType($eBarb, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllArchers = 1
							DonateTroopType($eArch, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllGiants = 1
							DonateTroopType($eGiant, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllGoblins = 1
							DonateTroopType($eGobl, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllWallBreakers = 1
							DonateTroopType($eWall, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllBalloons = 1
							DonateTroopType($eBall, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllWizards = 1
							DonateTroopType($eWiza, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllHealers = 1
							DonateTroopType($eHeal, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllDragons = 1
							DonateTroopType($eDrag, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllPekkas = 1
							DonateTroopType($ePekk, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllMinions = 1
							DonateTroopType($eMini, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllHogRiders = 1
							DonateTroopType($eHogs, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllValkyries = 1
							DonateTroopType($eValk, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllGolems = 1
							DonateTroopType($eGole, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllWitches = 1
							DonateTroopType($eWitc, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllLavaHounds = 1
							DonateTroopType($eLava, 0, False, $bDonateAllTroop)
					EndSelect
				EndIf

				If $bDonateAllSpell And $bSkipDonSpells = False Then
					If $debugSetlog = 1 Then Setlog("Spell All checkpoint.", $COLOR_PURPLE)

					Select
						Case $iChkDonateAllPoisonSpells = 1
							DonateTroopType($ePSpell, 0, False, $bDonateAllSpell)
						Case $iChkDonateAllEarthQuakeSpells = 1
							DonateTroopType($eESpell, 0, False, $bDonateAllSpell)
						Case $iChkDonateAllHasteSpells = 1
							DonateTroopType($eHaSpell, 0, False, $bDonateAllSpell)
					EndSelect
				EndIf

			EndIf

			;close Donate Window
			DonateWindow($bClose)

			$bDonate = True
			$y = $DonatePixel[1] + 30
			ClickP($aAway, 1, 0, "#0171")
			If _Sleep($iDelayDonateCC2) Then ExitLoop
		EndIf
		$DonatePixel = _MultiPixelSearch(202, $y, 203, 620 + $bottomOffsetY, 1, 1, Hex(0xc0e460, 6), $offColors, 15)
		If IsArray($DonatePixel) Then
			If $debugSetlog = 1 Then Setlog("More Donate buttons found, new $DonatePixel: (" & $DonatePixel[0] & "," & $DonatePixel[1] & ")", $COLOR_PURPLE)
			ContinueLoop
		EndIf

		$Scroll = _PixelSearch(288, 640 + $bottomOffsetY, 290, 655 + $bottomOffsetY, Hex(0x588800, 6), 20)
		If IsArray($Scroll) Then
			$bDonate = True
			Click($Scroll[0], $Scroll[1], 1, 0, "#0172")
			$y = 119
			If _Sleep($iDelayDonateCC2) Then ExitLoop
			ContinueLoop
		EndIf
		$bDonate = False
	WEnd

	ClickP($aAway, 1, 0, "#0176") ; click away any possible open window
	If _Sleep($iDelayDonateCC2) Then Return

	$i = 0
	While 1
		If _Sleep(100) Then Return
		If _ColorCheck(_GetPixelColor($aCloseChat[0], $aCloseChat[1], True), Hex($aCloseChat[2], 6), $aCloseChat[3]) Then
			; Clicks chat thing
			Click($aCloseChat[0], $aCloseChat[1], 1, 0, "#0173") ;Clicks chat thing
			ExitLoop
		Else
			If _Sleep(100) Then Return
			$i += 1
			If $i > 30 Then
				SetLog("Error finding Clan Tab to close...", $COLOR_RED)
				ExitLoop
			EndIf
		EndIf
	WEnd

	If _Sleep($iDelayDonateCC2) Then Return

EndFunc   ;==>DonateCC

Func CheckDonateTroop($Type, $aDonTroop, $aBlkTroop, $aBlackList, $ClanString)

	For $i = 1 To UBound($aBlackList) - 1
		If CheckDonateString($aBlackList[$i], $ClanString) Then
			SetLog("General Blacklist Keyword found: " & $aBlackList[$i], $COLOR_RED)
			Return False
		EndIf
	Next

	For $i = 1 To UBound($aBlkTroop) - 1
		If CheckDonateString($aBlkTroop[$i], $ClanString) Then
			If $Type = 19 Then
				Setlog("Custom Blacklist Keyword found: " & $aBlkTroop[$i], $COLOR_RED)
			Else
				SetLog(NameOfTroop($Type) & " Blacklist Keyword found: " & $aBlkTroop[$i], $COLOR_RED)
			EndIf
			Return False
		EndIf
	Next

	For $i = 1 To UBound($aDonTroop) - 1
		If CheckDonateString($aDonTroop[$i], $ClanString) Then
			If $Type = 19 Then
				Setlog("Custom Donation Keyword found: " & $aDonTroop[$i], $COLOR_GREEN)
			Else
				Setlog(NameOfTroop($Type) & " Keyword found: " & $aDonTroop[$i], $COLOR_GREEN)
			EndIf
			Return True
		EndIf
	Next

	If $debugSetlog = 1 Then Setlog("Bad call of CheckDonateTroop:" & $Type & "=" & NameOfTroop($Type), $COLOR_PURPLE)
	Return False
EndFunc   ;==>CheckDonateTroop

Func CheckDonateString($String, $ClanString) ;Checks if exact
	Local $Contains = StringMid($String, 1, 1) & StringMid($String, StringLen($String), 1)

	If $Contains = "[]" Then
		If $ClanString = StringMid($String, 2, StringLen($String) - 2) Then
			Return True
		Else
			Return False
		EndIf
	Else
		If StringInStr($ClanString, $String, 2) Then
			Return True
		Else
			Return False
		EndIf
	EndIf
EndFunc   ;==>CheckDonateString

Func DonateTroopType($Type, $Quant = 0, $Custom = False, $bDonateAll = False)
	If $debugSetlog = 1 Then Setlog("$DonateTroopType Start: " & NameOfTroop($Type), $COLOR_PURPLE)

	Local $Slot = -1, $YComp = 0, $sTextToAll = ""

	If $iTotalDonateCapacity = 0 And $iTotalDonateSpellCapacity = 0 Then Return

	If $Type >= $eBarb And $Type <= $eLava Then
		;troops
		For $i = 0 To UBound($TroopName) - 1
			If Eval("e" & $TroopName[$i]) = $Type Then
				$iDonTroopsQuantityAv = Floor($iTotalDonateCapacity / $TroopHeight[$i])
				If $iDonTroopsQuantityAv < 1 Then
					Setlog("Sorry Chief! " & NameOfTroop($Type, 1) & " don't fit in the remaining space!")
					Return
				EndIf
				If $iDonTroopsQuantityAv >= $iDonTroopsLimit Then
					$iDonTroopsQuantity = $iDonTroopsLimit
				Else
					$iDonTroopsQuantity = $iDonTroopsQuantityAv
				EndIf
			EndIf
		Next

		For $i = 0 To UBound($TroopDarkName) - 1
			If Eval("e" & $TroopDarkName[$i]) = $Type Then
				$iDonTroopsQuantityAv = Floor($iTotalDonateCapacity / $TroopDarkHeight[$i])
				If $iDonTroopsQuantityAv < 1 Then
					Setlog("Sorry Chief! " & NameOfTroop($Type, 1) & " don't fit in the remaining space!")
					Return
				EndIf
				If $iDonTroopsQuantityAv >= $iDonTroopsLimit Then
					$iDonTroopsQuantity = $iDonTroopsLimit
				Else
					$iDonTroopsQuantity = $iDonTroopsQuantityAv
				EndIf
			EndIf
		Next
	EndIf

	If $Type >= $ePSpell And $Type <= $eHaSpell Then
		;spells
		For $i = 0 To UBound($SpellName) - 1
			If Eval("e" & $SpellName[$i]) = $Type Then
				$iDonSpellsQuantityAv = Floor($iTotalDonateSpellCapacity / $SpellHeight[$i])
				If $iDonSpellsQuantityAv < 1 Then
					Setlog("Sorry Chief! " & NameOfTroop($Type, 1) & " don't fit in the remaining space!")
					Return
				EndIf
				If $iDonSpellsQuantityAv >= $iDonSpellsLimit Then
					$iDonSpellsQuantity = $iDonSpellsLimit
				Else
					$iDonSpellsQuantity = $iDonSpellsQuantityAv
				EndIf
			EndIf
		Next
	EndIf

	; Detect the Troops Slot
	$Slot = DetectSlotTroop($Type)

	If $Slot = -1 Then Return

	If $Slot >= 7 And $Slot <= 13 Then
		$Slot = $Slot - 7
		$YComp = 88 ; correct 860x780
	EndIf

	If $Slot >= 14 And $Slot <= 16 Then
		$Slot = $Slot - 14
		$YComp = 203 ; correct 860x780
	EndIf

	If $YComp <> 203 Then ; troops
		; Verify if the type of troop to donate exists
		If _ColorCheck(_GetPixelColor(350 + ($Slot * 68), $DonationWindowY + 105 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
				_ColorCheck(_GetPixelColor(355 + ($Slot * 68), $DonationWindowY + 106 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
				_ColorCheck(_GetPixelColor(360 + ($Slot * 68), $DonationWindowY + 107 + $YComp, True), Hex(0x306ca8, 6), 20) Then ; check for 'blue'
			Local $plural = 0
			If $Custom Then
				If $Quant > 1 Then $plural = 1
				If $bDonateAll Then $sTextToAll = " (to all requests)"
				SetLog("Donating " & $Quant & " " & NameOfTroop($Type, $plural) & $sTextToAll, $COLOR_GREEN)
				Click(365 + ($Slot * 68), $DonationWindowY + 100 + $YComp, $Quant, $iDelayDonateCC3, "#0175")
			Else
				If $iDonTroopsQuantity > 1 Then $plural = 1
				If $bDonateAll Then $sTextToAll = " (to all requests)"
				SetLog("Donating " & $iDonTroopsQuantity & " " & NameOfTroop($Type, $plural) & $sTextToAll, $COLOR_GREEN)
				Click(365 + ($Slot * 68), $DonationWindowY + 100 + $YComp, $iDonTroopsQuantity, $iDelayDonateCC3, "#0175")
			EndIf

			$bDonate = True

			; Assign the donated quantity troops to train : $Don $TroopName
			If $Custom Then
				For $i = 0 To UBound($TroopName) - 1
					If Eval("e" & $TroopName[$i]) = $Type Then
						Assign("Don" & $TroopName[$i], Eval("Don" & $TroopName[$i]) + $Quant)
					EndIf
				Next
				For $i = 0 To UBound($TroopDarkName) - 1
					If Eval("e" & $TroopDarkName[$i]) = $Type Then
						Assign("Don" & $TroopDarkName[$i], Eval("Don" & $TroopDarkName[$i]) + $Quant)
					EndIf
				Next
			Else
				For $i = 0 To UBound($TroopName) - 1
					If Eval("e" & $TroopName[$i]) = $Type Then
						Assign("Don" & $TroopName[$i], Eval("Don" & $TroopName[$i]) + $iDonTroopsQuantity)
					EndIf
				Next
				For $i = 0 To UBound($TroopDarkName) - 1
					If Eval("e" & $TroopDarkName[$i]) = $Type Then
						Assign("Don" & $TroopDarkName[$i], Eval("Don" & $TroopDarkName[$i]) + $iDonTroopsQuantity)
					EndIf
				Next
			EndIf
			; End

		ElseIf $DonatePixel[1] - 5 + $YComp > 675 Then
			Setlog("Unable to donate " & NameOfTroop($Type) & ". Donate screen not visible, will retry next run.", $COLOR_RED)
		Else
			SetLog("No " & NameOfTroop($Type) & " available to donate..", $COLOR_RED)
		EndIf
	Else ; spells
		If _ColorCheck(_GetPixelColor(350 + ($Slot * 68), $DonationWindowY + 105 + $YComp, True), Hex(0x6038B0, 6), 20) Or _
				_ColorCheck(_GetPixelColor(355 + ($Slot * 68), $DonationWindowY + 106 + $YComp, True), Hex(0x6038B0, 6), 20) Or _
				_ColorCheck(_GetPixelColor(360 + ($Slot * 68), $DonationWindowY + 107 + $YComp, True), Hex(0x6038B0, 6), 20) Then ; check for 'purple'
			If $bDonateAll Then $sTextToAll = " (to all requests)"
			SetLog("Donating " & $iDonSpellsQuantity & " " & NameOfTroop($Type) & $sTextToAll, $COLOR_GREEN)
			Click(365 + ($Slot * 68), $DonationWindowY + 100 + $YComp, $iDonSpellsQuantity, $iDelayDonateCC3, "#0175")

			$bDonate = True

			; Assign the donated quantity Spells to train : $Don $SpellName
			; need to implement assign $DonPoison etc later

		ElseIf $DonatePixel[1] - 5 + $YComp > 675 Then
			Setlog("Unable to donate " & NameOfTroop($Type) & ". Donate screen not visible, will retry next run.", $COLOR_RED)
		Else
			SetLog("No " & NameOfTroop($Type) & " available to donate..", $COLOR_RED)
		EndIf
	EndIf

EndFunc   ;==>DonateTroopType

Func DonateWindow($Open = True)
	If $debugSetlog = 1 And $Open = True Then Setlog("DonateWindow Open Start", $COLOR_PURPLE)
	If $debugSetlog = 1 And $Open = False Then Setlog("DonateWindow Close Start", $COLOR_PURPLE)

	If $Open = False Then ; close window and exit
		ClickP($aAway, 1, 0, "#0176")
		If _Sleep($iDelayDonateWindow1) Then Return
		If $debugSetlog = 1 Then Setlog("DonateWindow Close Exit", $COLOR_PURPLE)
		Return
	EndIf

	; Click on Donate Button and wait for the window
	If _ColorCheck(_GetPixelColor($DonatePixel[0], $DonatePixel[1], True), Hex(0xc0e460, 6), 20) Then
		Click($DonatePixel[0] - 30, $DonatePixel[1] + 10, 1, 0, "#0174")
	Else
		If $debugSetlog = 1 Then SetLog("Could not find the Donate Button!", $COLOR_PURPLE)
		Return False
	EndIf
	If _Sleep($iDelayDonateWindow1) Then Return

	;_CaptureRegion(0, 0, 320 + $midOffsetY, $DonatePixel[1] + 30 + $YComp)
	$icount = 0
	While Not (_ColorCheck(_GetPixelColor(331, $DonatePixel[1], True), Hex(0xffffff, 6), 0))
		If _Sleep($iDelayDonateWindow1) Then Return
		;_CaptureRegion(0, 0, 320 + $midOffsetY, $DonatePixel[1] + 30 + $YComp)
		$icount += 1
		If $icount = 20 Then ExitLoop
	WEnd

	; Determinate the right position of the new Donation Window
	; Will search in $Y column = 410 for the first pure white color and determinate that position the $DonationWindowTemp
	$DonationWindowY = 0

	Local $aDonWinOffColors[2][3] = [[0xFFFFFF, 0, 2], [0xD7D5CB, 0, 37]]
	Local $aDonationWindow = _MultiPixelSearch(409, 0, 410, $DEFAULT_HEIGHT, 1, 1, Hex(0xFFFFFF, 6), $aDonWinOffColors, 30)

	If IsArray($aDonationWindow) Then
		$DonationWindowY = $aDonationWindow[1]
		If _Sleep($iDelayDonateWindow1) Then Return
		If $debugSetlog = 1 Then Setlog("$DonationWindowY: " & $DonationWindowY, $COLOR_PURPLE)
	Else
		SetLog("Could not find the Donate Window!", $COLOR_RED)
		Return False
	EndIf

	If $debugSetlog = 1 Then Setlog("DonateWindow Open Exit", $COLOR_PURPLE)
	Return True
EndFunc   ;==>DonateWindow

Func DonateWindowCap(ByRef $bSkipDonTroops, ByRef $bSkipDonSpells)
	If $debugSetlog = 1 Then Setlog("DonateCapWindow Start", $COLOR_PURPLE)
	;read troops capacity
	If $bSkipDonTroops = False Then
		Local $sReadCCTroopsCap = getCastleDonateCap(768, $DonationWindowY + 14) ; use OCR to get donated/total capacity
		If $debugSetlog = 1 Then Setlog("$sReadCCTroopsCap: " & $sReadCCTroopsCap, $COLOR_PURPLE)

		Local $aTempReadCCTroopsCap = StringSplit($sReadCCTroopsCap, "#")
		If $aTempReadCCTroopsCap[0] >= 2 Then
			;  Note - stringsplit always returns an array even if no values split!
			If $debugSetlog = 1 Then Setlog("$aTempReadCCTroopsCap splitted :" & $aTempReadCCTroopsCap[1] & "/" & $aTempReadCCTroopsCap[2], $COLOR_PURPLE)
			If $aTempReadCCTroopsCap[2] > 0 Then
				$iDonTroopsAv = $aTempReadCCTroopsCap[1]
				$iDonTroopsLimit = $aTempReadCCTroopsCap[2]
				;Setlog("Donate Troops: " & $iDonTroopsAv & "/" & $iDonTroopsLimit)
			EndIf
		Else
			Setlog("Error reading the Castle Troop Capacity...", $COLOR_RED) ; log if there is read error
			$iDonTroopsAv = 0
			$iDonTroopsLimit = 0
		EndIf
	EndIf

	If $bSkipDonSpells = False Then
		Local $sReadCCSpellsCap = getCastleDonateCap(524, $DonationWindowY + 218) ; use OCR to get donated/total capacity
		If $debugSetlog = 1 Then Setlog("$sReadCCSpellsCap: " & $sReadCCSpellsCap, $COLOR_PURPLE)
		Local $aTempReadCCSpellsCap = StringSplit($sReadCCSpellsCap, "#")
		If $aTempReadCCSpellsCap[0] >= 2 Then
			;  Note - stringsplit always returns an array even if no values split!
			If $debugSetlog = 1 Then Setlog("$aTempReadCCSpellsCap splitted :" & $aTempReadCCSpellsCap[1] & "/" & $aTempReadCCSpellsCap[2], $COLOR_PURPLE)
			If $aTempReadCCSpellsCap[2] > 0 Then
				$iDonSpellsAv = $aTempReadCCSpellsCap[1]
				$iDonSpellsLimit = $aTempReadCCSpellsCap[2]
				;Setlog("Donate Spells: " & $iDonSpellsAv & "/" & $iDonSpellsLimit)
			EndIf
		Else
			Setlog("Error reading the Castle Spells Capacity...", $COLOR_RED) ; log if there is read error
			$iDonSpellsAv = 0
			$iDonSpellsLimit = 0
		EndIf
	EndIf

	If $iDonTroopsAv = $iDonTroopsLimit Then $bSkipDonTroops = True
	If $iDonSpellsAv = $iDonSpellsLimit Then $bSkipDonSpells = True

	If $bSkipDonTroops = True And $bSkipDonSpells = True And $iDonTroopsAv < $iDonTroopsLimit And $iDonSpellsAv < $iDonSpellsLimit Then
		Setlog("Donate Troops: " & $iDonTroopsAv & "/" & $iDonTroopsLimit & ", Spells: " & $iDonSpellsAv & "/" & $iDonSpellsLimit)
	EndIf
	If $bSkipDonSpells = False And $iDonTroopsAv < $iDonTroopsLimit And $iDonSpellsAv = $iDonSpellsLimit Then Setlog("Donate Troops: " & $iDonTroopsAv & "/" & $iDonTroopsLimit)
	If $bSkipDonTroops = False And $iDonTroopsAv = $iDonTroopsLimit And $iDonSpellsAv < $iDonSpellsLimit Then Setlog("Donate Spells: " & $iDonSpellsAv & "/" & $iDonSpellsLimit)

	If $debugSetlog = 1 Then Setlog("$bSkipDonTroops: " & $bSkipDonTroops, $COLOR_PURPLE)
	If $debugSetlog = 1 Then Setlog("$bSkipDonSpells: " & $bSkipDonSpells, $COLOR_PURPLE)
	If $debugSetlog = 1 Then Setlog("DonateCapWindow End", $COLOR_PURPLE)
EndFunc   ;==>DonateWindowCap

Func RemainingCCcapacity()
	; Remaining CC capacity of requested troops from your ClanMates
	; Will return the $iTotalDonateCapacity with that capacity for use in donation logic.

	Local $aCapTroops = "", $aTempCapTroops = "", $aCapSpells = "", $aTempCapSpells
	Local $iDonatedTroops = 0, $iDonatedSpells = 0
	Local $iCapTroopsTotal = 0, $iCapSpellsTotal = 0

	$iTotalDonateCapacity = -1
	$iTotalDonateSpellCapacity = -1

	; Verify with OCR the Donation Clan Castle capacity
	If $debugSetlog = 1 Then Setlog("Started dual getOcrSpaceCastleDonate", $COLOR_PURPLE)
	$aCapTroops = getOcrSpaceCastleDonate(110, $DonatePixel[1] - 33) ; when the request is troops+spell
	$aCapSpells = getOcrSpaceCastleDonate(235, $DonatePixel[1] - 33) ; when the request is troops+spell

	If $debugSetlog = 1 Then Setlog("$aCapTroops :" & $aCapTroops, $COLOR_PURPLE)
	If $debugSetlog = 1 Then Setlog("$aCapSpells :" & $aCapSpells, $COLOR_PURPLE)

	If Not (StringInStr($aCapTroops, "#") Or StringInStr($aCapSpells, "#")) Then; verify if the string is valid or it is just a number from request without spell
		If $debugSetlog = 1 Then Setlog("Started single getOcrSpaceCastleDonate", $COLOR_PURPLE)
		$aCapTroops = getOcrSpaceCastleDonate(139, $DonatePixel[1] - 33) ; when the Request don�t have Spell

		If $debugSetlog = 1 Then Setlog("$aCapTroops :" & $aCapTroops, $COLOR_PURPLE)
		$aCapSpells = -1
	EndIf

	If $aCapTroops <> "" Then
		; Splitting the XX/XX
		$aTempCapTroops = StringSplit($aCapTroops, "#")

		; Local Variables to use
		If $aTempCapTroops[0] >= 2 Then
			;  Note - stringsplit always returns an array even if no values split!
			If $debugSetlog = 1 Then Setlog("$aTempCapTroops splitted :" & $aTempCapTroops[1] & "/" & $aTempCapTroops[2], $COLOR_PURPLE)
			If $aTempCapTroops[2] > 0 Then
				$iDonatedTroops = $aTempCapTroops[1]
				$iCapTroopsTotal = $aTempCapTroops[2]
			EndIf
		Else
			Setlog("Error reading the Castle Troop Capacity...", $COLOR_RED) ; log if there is read error
			$iDonatedTroops = 0
			$iCapTroopsTotal = 0
		EndIf
	Else
		Setlog("Error reading the Castle Troop Capacity...", $COLOR_RED) ; log if there is read error
		$iDonatedTroops = 0
		$iCapTroopsTotal = 0
	EndIf

	If $aCapSpells <> -1 Then
		If $aCapSpells <> "" Then
			; Splitting the XX/XX
			$aTempCapSpells = StringSplit($aCapSpells, "#")

			; Local Variables to use
			If $aTempCapSpells[0] >= 2 Then
				; Note - stringsplit always returns an array even if no values split!
				If $debugSetlog = 1 Then Setlog("$aTempCapSpells splitted :" & $aTempCapSpells[1] & "/" & $aTempCapSpells[2], $COLOR_PURPLE)
				If $aTempCapSpells[2] > 0 Then
					$iDonatedSpells = $aTempCapSpells[1]
					$iCapSpellsTotal = $aTempCapSpells[2]
				EndIf
			Else
				Setlog("Error reading the Castle Spell Capacity...", $COLOR_RED) ; log if there is read error
				$iDonatedSpells = 0
				$iCapSpellsTotal = 0
			EndIf
		Else
			Setlog("Error reading the Castle Spell Capacity...", $COLOR_RED) ; log if there is read error
			$iDonatedSpells = 0
			$iCapSpellsTotal = 0
		EndIf
	EndIf


	; $iTotalDonateCapacity it will be use to determinate the quantity of kind troop to donate
	$iTotalDonateCapacity = ($iCapTroopsTotal - $iDonatedTroops)
	If $aCapSpells <> -1 Then $iTotalDonateSpellCapacity = ($iCapSpellsTotal - $iDonatedSpells)

	If $iTotalDonateCapacity < 0 Then
		SetLog("Unable to read Castle Capacity!", $COLOR_RED)
	Else
		If $aCapSpells <> -1 Then
			SetLog("Chat Troops: " & $iDonatedTroops & "/" & $iCapTroopsTotal & ", Spells: " & $iDonatedSpells & "/" & $iCapSpellsTotal)
		Else
			SetLog("Chat Troops: " & $iDonatedTroops & "/" & $iCapTroopsTotal)
		EndIf
	EndIf

	;;Return $iTotalDonateCapacity

EndFunc   ;==>RemainingCCcapacity

Func DetectSlotTroop($Type)

	If $Type >= $eBarb And $Type <= $eLava Then
		For $Slot = 0 To 6
			If $debugSetlog = 1 Then Setlog(" Slot : " & $Slot, $COLOR_PURPLE)
			Local $FullTemp = getOcrDonationTroopsDetection(358 + (68 * $Slot), $DonationWindowY + 38)
			If $debugSetlog = 1 Then Setlog(" getOcrDonationTroopsDetection: " & $FullTemp, $COLOR_PURPLE)
			If $FullTemp <> "" Then
				If $Type = $eBarb And $FullTemp = "barbarian" Then
					Return $Slot
				EndIf
				If $Type = $eArch And $FullTemp = "archer" Then
					Return $Slot
				EndIf
				If $Type = $eGiant And ($FullTemp = "giant" Or $FullTemp = "giant1") Then
					Return $Slot
				EndIf
				If $Type = $eGobl And $FullTemp = "goblin" Then
					Return $Slot
				EndIf
				If $Type = $eWall And $FullTemp = "wb" Then
					Return $Slot
				EndIf
				If $Type = $eBall And $FullTemp = "balloon" Then
					Return $Slot
				EndIf
				If $Type = $eWiza And $FullTemp = "wizard" Then
					Return $Slot
				EndIf
				If $Type = $eHeal And $FullTemp = "healer" Then
					Return $Slot
				EndIf
				If $Type = $eDrag And $FullTemp = "dragon" Then
					Return $Slot
				EndIf
				If $Type = $ePekk And $FullTemp = "pekka" Then
					Return $Slot
				EndIf
				If $Type = $eMini And $FullTemp = "minions" Then
					Return $Slot
				EndIf
				If $Type = $eHogs And $FullTemp = "hogs" Then
					Return $Slot
				EndIf
				If $Type = $eValk And $FullTemp = "valk" Then
					Return $Slot
				EndIf
				If $Type = $eWitc And $FullTemp = "witch" Then
					Return $Slot
				EndIf
				If $Type = $eGole And $FullTemp = "golem" Then
					Return $Slot
				EndIf
			EndIf
		Next

		For $Slot = 7 To 13
			If $debugSetlog = 1 Then Setlog(" Slot : " & $Slot, $COLOR_PURPLE)
			Local $FullTemp = getOcrDonationTroopsDetection(358 + (68 * ($Slot - 7)), $DonationWindowY + 127)
			If $debugSetlog = 1 Then Setlog(" getOcrDonationTroopsDetection: " & $FullTemp, $COLOR_PURPLE)
			If $FullTemp <> "" Then
				If $Type = $eBarb And $FullTemp = "barbarian" Then
					Return $Slot
				EndIf
				If $Type = $eArch And $FullTemp = "archer" Then
					Return $Slot
				EndIf
				If $Type = $eGiant And ($FullTemp = "giant" Or $FullTemp = "giant1") Then
					Return $Slot
				EndIf
				If $Type = $eGobl And $FullTemp = "goblin" Then
					Return $Slot
				EndIf
				If $Type = $eWall And $FullTemp = "wb" Then
					Return $Slot
				EndIf
				If $Type = $eBall And $FullTemp = "balloon" Then
					Return $Slot
				EndIf
				If $Type = $eWiza And $FullTemp = "wizard" Then
					Return $Slot
				EndIf
				If $Type = $eHeal And $FullTemp = "healer" Then
					Return $Slot
				EndIf
				If $Type = $eDrag And $FullTemp = "dragon" Then
					Return $Slot
				EndIf
				If $Type = $ePekk And $FullTemp = "pekka" Then
					Return $Slot
				EndIf
				If $Type = $eMini And $FullTemp = "minions" Then
					Return $Slot
				EndIf
				If $Type = $eHogs And $FullTemp = "hogs" Then
					Return $Slot
				EndIf
				If $Type = $eValk And $FullTemp = "valk" Then
					Return $Slot
				EndIf
				If $Type = $eWitc And $FullTemp = "witch" Then
					Return $Slot
				EndIf
				If $Type = $eGole And $FullTemp = "golem" Then
					Return $Slot
				EndIf
			EndIf
		Next
	EndIf

	If $Type >= $ePSpell And $Type <= $eHaSpell Then
		For $Slot = 14 To 16
			If $debugSetlog = 1 Then Setlog(" Slot : " & $Slot, $COLOR_PURPLE)
			Local $FullTemp = getOcrDonationTroopsDetection(358 + (68 * ($Slot - 14)), $DonationWindowY + 241 + 20)
			If $debugSetlog = 1 Then Setlog(" getOcrDonationSpells: " & $FullTemp, $COLOR_PURPLE)
			If $Type = $ePSpell And $FullTemp = "poison" Then
				Return $Slot
			EndIf
			If $Type = $eESpell And $FullTemp = "eq" Then
				Return $Slot
			EndIf
			If $Type = $eHaSpell And $FullTemp = "haste" Then
				Return $Slot
			EndIf
		Next
	EndIf

	If $FullTemp = "" Then
		Return -1
	EndIf

EndFunc   ;==>DetectSlotTroop

