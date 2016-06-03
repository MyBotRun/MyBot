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

	If $bDonate = False Or $bDonationEnabled = False Then
		If $debugsetlog = 1 Then Setlog("Donate Clan Castle troops skip", $COLOR_PURPLE)
		Return ; exit func if no donate checkmarks
	EndIf

	Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)

	If $iPlannedDonateHours[$hour[0]] = 0 And $iPlannedDonateHoursEnable = 1 Then
		If $debugsetlog = 1 Then SetLog("Donate Clan Castle troops not planned, Skipped..", $COLOR_PURPLE)
		Return ; exit func if no planned donate checkmarks
	EndIf

	Local $y = 90

	;check for new chats first
	If $Check = True Then
		If _ColorCheck(_GetPixelColor(26, 312 + $midOffsetY, True), Hex(0xf00810, 6), 20) = False And $CommandStop <> 3 Then
			Return ;exit if no new chats
		EndIf
	EndIf

	ClickP($aAway, 1, 0, "#0167") ;Click Away
	Setlog("Checking for Donate Requests in Clan Chat", $COLOR_BLUE)

	ForceCaptureRegion()
	If _CheckPixel($aChatTab, $bCapturePixel) = False Then ClickP($aOpenChat, 1, 0, "#0168") ; Clicks chat tab
	If _Sleep($iDelayDonateCC1) Then Return

	ClickP($aClanTab, 1, 0, "#0169") ; clicking clan tab

	Local $Scroll
	While $bDonate
		checkAttackDisable($iTaBChkIdle) ; Early Take-A-Break detection

		If _Sleep($iDelayDonateCC2) Then ExitLoop
		ForceCaptureRegion()
		$DonatePixel = _MultiPixelSearch(202, $y, 224, 660 + $bottomOffsetY, 50, 1, Hex(0x98D057, 6), $aChatDonateBtnColors, 15)
		If IsArray($DonatePixel) Then ; if Donate Button found
			If $debugsetlog = 1 Then Setlog("$DonatePixel: (" & $DonatePixel[0] & "," & $DonatePixel[1] & ")", $COLOR_PURPLE)

			;reset every run
			$bDonate = False ; donate only for one request at a time
			$bSkipDonTroops = False
			;removed because we can launch donateCC previous to read TH level and status of dark spell factory
;~ 			If $iTownHallLevel < 8 Or $numFactoryDarkSpellAvaiables = 0 Then ; if you are a < TH8 you don't have a Dark Spells Factory OR Dark Spells Factory is Upgrading
;~ 				$bSkipDonSpells = True
;~ 			Else
			$bSkipDonSpells = False
;~ 			EndIf

			;Read chat request for DonateTroop and DonateSpell
			If $bDonateTroop Or $bDonateSpell Then
				If $ichkExtraAlphabets = 1 Then
					; Chat Request , Latin + Turkish + Extra latin + Cyrillic Alphabets / three paragraphs.
					Local $ClanString = ""
					$ClanString = getChatString(30, $DonatePixel[1] - 50, "coc-latin-cyr")
					If $ClanString = "" Then
						$ClanString = getChatString(30, $DonatePixel[1] - 36, "coc-latin-cyr")
					Else
						$ClanString &= " " & getChatString(30, $DonatePixel[1] - 36, "coc-latin-cyr")
					EndIf
					If $ClanString = "" Or $ClanString = " " Then
						$ClanString = getChatString(30, $DonatePixel[1] - 23, "coc-latin-cyr")
					Else
						$ClanString &= " " & getChatString(30, $DonatePixel[1] - 23, "coc-latin-cyr")
					EndIf
					If _Sleep($iDelayDonateCC2) Then ExitLoop
				Else
					; Chat Request , Latin + Turkish + Extra / three paragraphs.
					Local $ClanString = ""
					$ClanString = getChatString(30, $DonatePixel[1] - 50, "coc-latinA")
					If $ClanString = "" Then
						$ClanString = getChatString(30, $DonatePixel[1] - 36, "coc-latinA")
					Else
						$ClanString &= " " & getChatString(30, $DonatePixel[1] - 36, "coc-latinA")
					EndIf
					If $ClanString = "" Or $ClanString = " " Then
						$ClanString = getChatString(30, $DonatePixel[1] - 23, "coc-latinA")
					Else
						$ClanString &= " " & getChatString(30, $DonatePixel[1] - 23, "coc-latinA")
					EndIf
					If _Sleep($iDelayDonateCC2) Then ExitLoop
				EndIf

				If $ClanString = "" Or $ClanString = " " Then
					SetLog("Unable to read Chat Request!", $COLOR_RED)
					$bDonate = True
					$y = $DonatePixel[1] + 50
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
				If $debugsetlog = 1 Then Setlog("This CC cannot accept spells, skip spell donation...", $COLOR_PURPLE)
				$bSkipDonSpells = True
			ElseIf GetCurTotalSpell() = 0 Then
				If $debugsetlog = 1 Then Setlog("No spells available, skip spell donation...", $COLOR_PURPLE)
				$bSkipDonSpells = True
			EndIf

			; open Donate Window
			If ($bSkipDonTroops = True And $bSkipDonSpells = True) Or DonateWindow($bOpen) = False Then
				$bDonate = True
				$y = $DonatePixel[1] + 50
				ContinueLoop ; go to next button if donate window did not open
			EndIf

			If $bDonateTroop Or $bDonateSpell Then
				If $debugsetlog = 1 Then Setlog("Troop/Spell checkpoint.", $COLOR_PURPLE)

				; read available donate cap, and ByRef set the $bSkipDonTroops and $bSkipDonSpells flags
				DonateWindowCap($bSkipDonTroops, $bSkipDonSpells)
				If $bSkipDonTroops And $bSkipDonSpells Then
					DonateWindow($bClose)
					$bDonate = True
					$y = $DonatePixel[1] + 50
					If _Sleep($iDelayDonateCC2) Then ExitLoop
					ContinueLoop ; go to next button if already donated, maybe this is an impossible case..
				EndIf

				If $bDonateTroop = 1 And $bSkipDonTroops = False Then
					If $debugsetlog = 1 Then Setlog("Troop checkpoint.", $COLOR_PURPLE)

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

					If $iChkDonateLavaHounds = 1 And $bSkipDonTroops = False And CheckDonateTroop($eLava, $aDonLavaHounds, $aBlkLavaHounds, $aBlackList, $ClanString) Then DonateTroopType($eLava)
					If $iChkDonateGolems = 1 And $bSkipDonTroops = False And CheckDonateTroop($eGole, $aDonGolems, $aBlkGolems, $aBlackList, $ClanString) Then DonateTroopType($eGole)
					If $iChkDonatePekkas = 1 And $bSkipDonTroops = False And CheckDonateTroop($ePekk, $aDonPekkas, $aBlkPekkas, $aBlackList, $ClanString) Then DonateTroopType($ePekk)
					If $iChkDonateDragons = 1 And $bSkipDonTroops = False And CheckDonateTroop($eDrag, $aDonDragons, $aBlkDragons, $aBlackList, $ClanString) Then DonateTroopType($eDrag)
					If $iChkDonateWitches = 1 And $bSkipDonTroops = False And CheckDonateTroop($eWitc, $aDonWitches, $aBlkWitches, $aBlackList, $ClanString) Then DonateTroopType($eWitc)
					If $iChkDonateHealers = 1 And $bSkipDonTroops = False And CheckDonateTroop($eHeal, $aDonHealers, $aBlkHealers, $aBlackList, $ClanString) Then DonateTroopType($eHeal)
					If $iChkDonateValkyries = 1 And $bSkipDonTroops = False And CheckDonateTroop($eValk, $aDonValkyries, $aBlkValkyries, $aBlackList, $ClanString) Then DonateTroopType($eValk)
					If $iChkDonateGiants = 1 And $bSkipDonTroops = False And CheckDonateTroop($eGiant, $aDonGiants, $aBlkGiants, $aBlackList, $ClanString) Then DonateTroopType($eGiant)
					If $iChkDonateBalloons = 1 And $bSkipDonTroops = False And CheckDonateTroop($eBall, $aDonBalloons, $aBlkBalloons, $aBlackList, $ClanString) Then DonateTroopType($eBall)
					If $iChkDonateHogRiders = 1 And $bSkipDonTroops = False And CheckDonateTroop($eHogs, $aDonHogRiders, $aBlkHogRiders, $aBlackList, $ClanString) Then DonateTroopType($eHogs)
					If $iChkDonateWizards = 1 And $bSkipDonTroops = False And CheckDonateTroop($eWiza, $aDonWizards, $aBlkWizards, $aBlackList, $ClanString) Then DonateTroopType($eWiza)
					If $iChkDonateWallBreakers = 1 And $bSkipDonTroops = False And CheckDonateTroop($eWall, $aDonWallBreakers, $aBlkWallBreakers, $aBlackList, $ClanString) Then DonateTroopType($eWall)
					If $iChkDonateMinions = 1 And $bSkipDonTroops = False And CheckDonateTroop($eMini, $aDonMinions, $aBlkMinions, $aBlackList, $ClanString) Then DonateTroopType($eMini)
					If $iChkDonateBarbarians = 1 And $bSkipDonTroops = False And CheckDonateTroop($eBarb, $aDonBarbarians, $aBlkBarbarians, $aBlackList, $ClanString) Then DonateTroopType($eBarb)
					If $iChkDonateArchers = 1 And $bSkipDonTroops = False And CheckDonateTroop($eArch, $aDonArchers, $aBlkArchers, $aBlackList, $ClanString) Then DonateTroopType($eArch)
					If $iChkDonateGoblins = 1 And $bSkipDonTroops = False And CheckDonateTroop($eGobl, $aDonGoblins, $aBlkGoblins, $aBlackList, $ClanString) Then DonateTroopType($eGobl)

				EndIf

				If $bDonateSpell = 1 And $bSkipDonSpells = False Then
					If $debugsetlog = 1 Then Setlog("Spell checkpoint.", $COLOR_PURPLE)
					If $iChkDonatePoisonSpells = 1 And $bSkipDonSpells = False And CheckDonateTroop($ePSpell, $aDonPoisonSpells, $aBlkPoisonSpells, $aBlackList, $ClanString) Then DonateTroopType($ePSpell)
					If $iChkDonateEarthQuakeSpells = 1 And $bSkipDonSpells = False And CheckDonateTroop($eESpell, $aDonEarthQuakeSpells, $aBlkEarthQuakeSpells, $aBlackList, $ClanString) Then DonateTroopType($eESpell)
					If $iChkDonateHasteSpells = 1 And $bSkipDonSpells = False And CheckDonateTroop($eHaSpell, $aDonHasteSpells, $aBlkHasteSpells, $aBlackList, $ClanString) Then DonateTroopType($eHaSpell)
				EndIf
			EndIf

			If $bDonateAllTroop Or $bDonateAllSpell Then
				If $debugsetlog = 1 Then Setlog("Troop/Spell All checkpoint.", $COLOR_PURPLE)

				; read available donate cap again, and ByRef set the $bSkipDonTroops and $bSkipDonSpells flags
				DonateWindowCap($bSkipDonTroops, $bSkipDonSpells)
				If $bSkipDonTroops And $bSkipDonSpells Then
					DonateWindow($bClose)
					$bDonate = True
					$y = $DonatePixel[1] + 50
					If _Sleep($iDelayDonateCC2) Then ExitLoop
					ContinueLoop ; go to next button if already donated max, maybe this is an impossible case..
				EndIf

				If $bDonateAllTroop And $bSkipDonTroops = False Then
					If $debugsetlog = 1 Then Setlog("Troop All checkpoint.", $COLOR_PURPLE)
					Select
						Case $iChkDonateAllCustom = 1
							For $i = 0 To 2
								If $varDonateCustom[$i][0] < $eBarb Then
									$varDonateCustom[$i][0] = $eArch ; Change strange small numbers to archer
								ElseIf $varDonateCustom[$i][0] > $eLava Then
									DonateWindow($bClose)
									$bDonate = True
									$y = $DonatePixel[1] + 50
									If _Sleep($iDelayDonateCC2) Then ExitLoop
									ContinueLoop ; If "Nothing" is selected then continue
								EndIf
								If $varDonateCustom[$i][1] < 1 Then
									DonateWindow($bClose)
									$bDonate = True
									$y = $DonatePixel[1] + 50
									If _Sleep($iDelayDonateCC2) Then ExitLoop
									ContinueLoop ; If donate number is smaller than 1 then continue
								ElseIf $varDonateCustom[$i][1] > 8 Then
									$varDonateCustom[$i][1] = 8 ; Number larger than 8 is unnecessary
								EndIf
								DonateTroopType($varDonateCustom[$i][0], $varDonateCustom[$i][1], $iChkDonateAllCustom, $bDonateAllTroop) ;;; Donate Custom Troop using DonateTroopType2
							Next
						Case $iChkDonateAllLavaHounds = 1
							DonateTroopType($eLava, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllGolems = 1
							DonateTroopType($eGole, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllPekkas = 1
							DonateTroopType($ePekk, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllDragons = 1
							DonateTroopType($eDrag, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllWitches = 1
							DonateTroopType($eWitc, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllHealers = 1
							DonateTroopType($eHeal, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllValkyries = 1
							DonateTroopType($eValk, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllGiants = 1
							DonateTroopType($eGiant, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllBalloons = 1
							DonateTroopType($eBall, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllHogRiders = 1
							DonateTroopType($eHogs, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllWizards = 1
							DonateTroopType($eWiza, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllWallBreakers = 1
							DonateTroopType($eWall, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllMinions = 1
							DonateTroopType($eMini, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllBarbarians = 1
							DonateTroopType($eBarb, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllArchers = 1
							DonateTroopType($eArch, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllGoblins = 1
							DonateTroopType($eGobl, 0, False, $bDonateAllTroop)
					EndSelect
				EndIf

				If $bDonateAllSpell And $bSkipDonSpells = False Then
					If $debugsetlog = 1 Then Setlog("Spell All checkpoint.", $COLOR_PURPLE)

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
			$y = $DonatePixel[1] + 50
			ClickP($aAway, 1, 0, "#0171")
			If _Sleep($iDelayDonateCC2) Then ExitLoop
		EndIf
		ForceCaptureRegion()
		$DonatePixel = _MultiPixelSearch(202, $y, 224, 660 + $bottomOffsetY, 50, 1, Hex(0x98D057, 6), $aChatDonateBtnColors, 15)
		If IsArray($DonatePixel) Then
			If $debugSetlog = 1 Then Setlog("More Donate buttons found, new $DonatePixel: (" & $DonatePixel[0] & "," & $DonatePixel[1] & ")", $COLOR_PURPLE)
			ContinueLoop
		Else
			If $debugsetlog = 1 Then Setlog("No more Donate buttons found, closing chat ($y=" & $y & ")", $COLOR_PURPLE)
		EndIf

		ForceCaptureRegion()
		;$Scroll = _PixelSearch(288, 640 + $bottomOffsetY, 290, 655 + $bottomOffsetY, Hex(0x588800, 6), 20)
		$y = 90
		$Scroll = _PixelSearch(293, 8 + $y, 295, 23 + $y, Hex(0xFFFFFF, 6), 20)
		If IsArray($Scroll) Then
			$bDonate = True
			Click($Scroll[0], $Scroll[1], 1, 0, "#0172")
			$y = 90
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
Setlog ($debugOCRdonate,$color_aqua)

	If $debugSetlog = 1 Then Setlog("$DonateTroopType Start: " & NameOfTroop($Type), $COLOR_PURPLE)

	Local $Slot = -1, $YComp = 0, $sTextToAll = ""
	Local $detectedSlot = -1
	Local $donaterow = -1 ;( =3 for spells)
	Local $donateposinrow = -1

	If $iTotalDonateCapacity = 0 And $iTotalDonateSpellCapacity = 0 Then Return

	If $Type >= $eBarb And $Type <= $elava Then
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
	If $debugOCRdonate = 1 Then
		Local $oldDebugOcr = $debugOcr
		$debugOcr = 1
	EndIf
	$Slot = DetectSlotTroop($Type)
	$detectedSlot = $slot
	If $debugSetlog= 1 then setlog("slot found = " & $slot,$color_purple)
	If $debugOCRdonate = 1 Then $debugOcr = $oldDebugOcr

	If $Slot = -1 Then Return

	$donaterow = 1 ;first row of trrops
	$donateposinrow= $slot
	If $Slot >= 6 And $Slot <= 11 Then
		$donaterow = 2 ;second row of troops
		$Slot = $Slot - 6
		$donateposinrow= $slot
		$YComp = 88 ; correct 860x780
	EndIf

	If $Slot >= 12 And $Slot <= 14 Then
		$donaterow = 3 ;row of poisons
		$Slot = $Slot - 12
		$donateposinrow= $slot
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
				If $debugOCRdonate = 1 then
					Setlog("donate" , $color_RED)
					Setlog("row: " & $donaterow, $color_RED)
					Setlog("pos in row: " & $donateposinrow, $color_red)
					setlog("coordinate: " & 365 + ($Slot * 68) & "," &  $DonationWindowY + 100 + $YComp,$color_red )
					debugimagesave("LiveDonateCC-r" & $donaterow &"-c"& $donateposinrow&"-" & NameOfTroop($Type) & "_")
				EndIf
				If $debugOCRdonate = 0 Then Click(365 + ($Slot * 68), $DonationWindowY + 100 + $YComp, $Quant, $iDelayDonateCC3, "#0175")
			Else
				If $iDonTroopsQuantity > 1 Then $plural = 1
				If $bDonateAll Then $sTextToAll = " (to all requests)"
				SetLog("Donating " & $iDonTroopsQuantity & " " & NameOfTroop($Type, $plural) & $sTextToAll, $COLOR_GREEN)
				If $debugOCRdonate = 1 then
					Setlog("donate" , $color_RED)
					Setlog("row: " & $donaterow, $color_RED)
					Setlog("pos in row: " & $donateposinrow, $color_red)
					setlog("coordinate: " & 365 + ($Slot * 68) & "," &  $DonationWindowY + 100 + $YComp,$color_red )
					debugimagesave("LiveDonateCC-r" & $donaterow &"-c"& $donateposinrow&"-" & NameOfTroop($Type) & "_")
				EndIf
				If $debugOCRdonate = 0 Then Click(365 + ($Slot * 68), $DonationWindowY + 100 + $YComp, $iDonTroopsQuantity, $iDelayDonateCC3, "#0600")
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
			;Setlog("click donate")
				If $debugOCRdonate = 1 then
					Setlog("donate" , $color_RED)
					Setlog("row: " & $donaterow, $color_RED)
					Setlog("pos in row: " & $donateposinrow, $color_red)
					setlog("coordinate: " & 365 + ($Slot * 68) & "," &  $DonationWindowY + 100 + $YComp,$color_red )
					debugimagesave("LiveDonateCC-r" & $donaterow &"-c"& $donateposinrow&"-" & NameOfTroop($Type) & "_")
				EndIf
			If $debugOCRdonate = 0 Then Click(365 + ($Slot * 68), $DonationWindowY + 100 + $YComp, $iDonSpellsQuantity, $iDelayDonateCC3, "#0600")

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
	Local $iLeft = 0, $iTop = 0, $iRight = 0, $iBottom = 0, $i
	For $i = 0 To UBound($aChatDonateBtnColors) - 1
		If $aChatDonateBtnColors[$i][1] < $iLeft Then $iLeft = $aChatDonateBtnColors[$i][1]
		If $aChatDonateBtnColors[$i][1] > $iRight Then $iRight = $aChatDonateBtnColors[$i][1]
		If $aChatDonateBtnColors[$i][2] < $iTop Then $iTop = $aChatDonateBtnColors[$i][2]
		If $aChatDonateBtnColors[$i][2] > $iBottom Then $iBottom = $aChatDonateBtnColors[$i][2]
	Next
	$iLeft += $DonatePixel[0]
	$iTop += $DonatePixel[1]
	$iRight += $DonatePixel[0] + 1
	$iBottom += $DonatePixel[1] + 1
	ForceCaptureRegion()
	Local $DonatePixelCheck = _MultiPixelSearch($iLeft, $iTop, $iRight, $iBottom, 50, 1, Hex(0x98D057, 6), $aChatDonateBtnColors, 15)
	If IsArray($DonatePixelCheck) Then
		Click($DonatePixel[0] + 50, $DonatePixel[1] + 10, 1, 0, "#0174")
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

	Local $aDonWinOffColors[2][3] = [[0xFFFFFF, 0, 2], [0xc7c5bc, 0, 209]]
	Local $aDonationWindow = _MultiPixelSearch(409, 0, 410, $DEFAULT_HEIGHT, 1, 1, Hex(0xFFFFFF, 6), $aDonWinOffColors, 10)

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
		Local $sReadCCTroopsCap = getCastleDonateCap(427, $DonationWindowY + 15) ; use OCR to get donated/total capacity
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
		Local $sReadCCSpellsCap = getCastleDonateCap(420, $DonationWindowY + 220) ; use OCR to get donated/total capacity
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
	$aCapTroops = getOcrSpaceCastleDonate(49, $DonatePixel[1]) ; when the request is troops+spell
	$aCapSpells = getOcrSpaceCastleDonate(153, $DonatePixel[1]) ; when the request is troops+spell

	If $debugSetlog = 1 Then Setlog("$aCapTroops :" & $aCapTroops, $COLOR_PURPLE)
	If $debugSetlog = 1 Then Setlog("$aCapSpells :" & $aCapSpells, $COLOR_PURPLE)

	If Not (StringInStr($aCapTroops, "#") Or StringInStr($aCapSpells, "#")) Then ; verify if the string is valid or it is just a number from request without spell
		If $debugSetlog = 1 Then Setlog("Started single getOcrSpaceCastleDonate", $COLOR_PURPLE)
		$aCapTroops = getOcrSpaceCastleDonate(78, $DonatePixel[1]) ; when the Request don't have Spell

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
		For $Slot = 0 To 5
			If $debugSetlog = 1 Then Setlog(" Slot : " & $Slot, $COLOR_PURPLE)
			Local $FullTemp = getOcrDonationTroopsDetection(343 + (68 * $Slot), $DonationWindowY + 37)
			If $debugSetlog = 1 Then Setlog(" getOcrDonationTroopsDetection: " & $FullTemp, $COLOR_PURPLE)
			If $debugSetlog = 1 Then
				Switch $FullTemp
					Case "barbarian"
						setlog("Detected barbarian", $COLOR_GREEN)
					Case "archer"
						setlog("Detected archer", $COLOR_GREEN)
					Case "giant"
						setlog("Detected giant", $COLOR_GREEN)
					Case "goblin"
						setlog("Detected goblin", $COLOR_GREEN)
					Case "wb"
						setlog("Detected wall breaker", $COLOR_GREEN)
					Case "balloon"
						setlog("Detected balloon", $COLOR_GREEN)
					Case "balloonballoon"
						setlog("Detected balloon*", $COLOR_GREEN)
					Case "wizard"
						setlog("Detected wizard", $COLOR_GREEN)
					Case "healer"
						setlog("Detected healer", $COLOR_GREEN)
					Case "dragon"
						setlog("Detected dragon", $COLOR_GREEN)
					Case "pekka"
						setlog("Detected pekka", $COLOR_GREEN)
					Case "minions"
						setlog("Detected minion", $COLOR_GREEN)
					Case "hogs"
						setlog("Detected hog", $COLOR_GREEN)
					Case "valk"
						setlog("Detected valkiria", $COLOR_GREEN)
					Case "witch"
						setlog("Detected witch", $COLOR_GREEN)
					Case "golem"
						setlog("Detected golem", $COLOR_GREEN)
					Case "lava"
						setlog("Detected lava", $COLOR_GREEN)
					Case "bowler"
						setlog("Detected bowler", $COLOR_GREEN)
					Case "poison"
						setlog("Detected poison", $COLOR_GREEN)
					Case "earthquake"
						setlog("Detected earthquake", $COLOR_GREEN)
					Case "haste"
						setlog("Detected haste", $COLOR_GREEN)
					Case Else
						setlog("Detected <<<<" & $FullTemp & ">>>>", $COLOR_GREEN)
				EndSwitch
			EndIf
			If $FullTemp <> "" Then
				;If $FullTemp = "empty" Then ExitLoop

				If $Type = $eBarb And StringInStr($FullTemp & " " , "barbarian") >0  Then
					Return $Slot
				EndIf
				If $Type = $eArch And StringInStr($FullTemp & " " , "archer") >0  Then
					Return $Slot
				EndIf
				If $Type = $eGiant And StringInStr($FullTemp & " " , "giant") >0 Then
					Return $Slot
				EndIf
				If $Type = $eGobl And StringInStr($FullTemp & " " , "goblin") >0 Then
					Return $Slot
				EndIf
				If $Type = $eWall And StringInStr($FullTemp & " " , "wb") >0 Then
					Return $Slot
				EndIf
				If $Type = $eBall And StringInStr($FullTemp & " " , "balloon") >0 Then
					Return $Slot
				EndIf
				If $Type = $eWiza And StringInStr($FullTemp & " " , "wizard") >0 Then
					Return $Slot
				EndIf
				If $Type = $eHeal And StringInStr($FullTemp & " " , "healer") >0 Then
					Return $Slot
				EndIf
				If $Type = $eDrag And StringInStr($FullTemp & " " , "dragon") >0 Then
					Return $Slot
				EndIf
				If $Type = $ePekk And StringInStr($FullTemp & " " , "pekka") >0 Then
					Return $Slot
				EndIf
				If $Type = $eMini And StringInStr($FullTemp & " " , "minions") >0 Then
					Return $Slot
				EndIf
				If $Type = $eHogs And StringInStr($FullTemp & " " , "hogs") >0 Then
					Return $Slot
				EndIf
				If $Type = $eValk And StringInStr($FullTemp & " " , "valk") >0 Then
					Return $Slot
				EndIf
				If $Type = $eWitc And StringInStr($FullTemp & " " , "witch") >0 Then
					Return $Slot
				EndIf
				If $Type = $eGole And StringInStr($FullTemp & " " , "golem") >0 Then
					Return $Slot
				EndIf
				If $Type = $eLava And StringInStr($FullTemp & " " , "lava") >0 Then
					Return $Slot
				EndIf
				;If $Type = $eBowl And StringInStr($FullTemp & " " , "bowler") >0 Then
				;Return $Slot
				;EndIf
			EndIf
		Next
		For $Slot = 6 To 11
			If $debugSetlog = 1 Then Setlog(" Slot : " & $Slot, $COLOR_PURPLE)
			Local $FullTemp = getOcrDonationTroopsDetection(343 + (68 * ($Slot - 6)), $DonationWindowY + 124)
			If $debugSetlog = 1 Then Setlog(" getOcrDonationTroopsDetection: " & $FullTemp, $COLOR_PURPLE)
			If $debugSetlog = 1 Then
				Switch $FullTemp
					Case "barbarian"
						setlog("Detected barbarian", $COLOR_GREEN)
					Case "archer"
						setlog("Detected archer", $COLOR_GREEN)
					Case "giant"
						setlog("Detected giant", $COLOR_GREEN)
					Case "goblin"
						setlog("Detected goblin", $COLOR_GREEN)
					Case "wb"
						setlog("Detected wall breaker", $COLOR_GREEN)
					Case "balloon"
						setlog("Detected balloon*", $COLOR_GREEN)
						setlog("Detected balloon*", $COLOR_GREEN)
					Case "wizard"
						setlog("Detected wizard", $COLOR_GREEN)
					Case "healer"
						setlog("Detected healer", $COLOR_GREEN)
					Case "dragon"
						setlog("Detected dragon", $COLOR_GREEN)
					Case "pekka"
						setlog("Detected pekka", $COLOR_GREEN)
					Case "minions"
						setlog("Detected minion", $COLOR_GREEN)
					Case "hogs"
						setlog("Detected hog", $COLOR_GREEN)
					Case "valk"
						setlog("Detected valkiria", $COLOR_GREEN)
					Case "witch"
						setlog("Detected witch", $COLOR_GREEN)
					Case "golem"
						setlog("Detected golem", $COLOR_GREEN)
					Case "lava"
						setlog("Detected lava", $COLOR_GREEN)
					Case "bowler"
						setlog("Detected bowler", $COLOR_GREEN)
					Case "poison"
						setlog("Detected poison", $COLOR_GREEN)
					Case "earthquake"
						setlog("Detected earthquake", $COLOR_GREEN)
					Case "haste"
						setlog("Detected haste", $COLOR_GREEN)
					Case Else
						setlog("Detected <<<<" & $FullTemp & ">>>>", $COLOR_GREEN)
				EndSwitch
			EndIf
			If $FullTemp <> "" Then
				;If $FullTemp = "empty" Then ExitLoop

				If $Type = $eBarb And StringInStr($FullTemp & " " , "barbarian") >0  Then
					Return $Slot
				EndIf
				If $Type = $eArch And StringInStr($FullTemp & " " , "archer") >0  Then
					Return $Slot
				EndIf
				If $Type = $eGiant And StringInStr($FullTemp & " " , "giant") >0 Then
					Return $Slot
				EndIf
				If $Type = $eGobl And StringInStr($FullTemp & " " , "goblin") >0 Then
					Return $Slot
				EndIf
				If $Type = $eWall And StringInStr($FullTemp & " " , "wb") >0 Then
					Return $Slot
				EndIf
				If $Type = $eBall And StringInStr($FullTemp & " " , "balloon") >0 Then
					Return $Slot
				EndIf
				If $Type = $eWiza And StringInStr($FullTemp & " " , "wizard") >0 Then
					Return $Slot
				EndIf
				If $Type = $eHeal And StringInStr($FullTemp & " " , "healer") >0 Then
					Return $Slot
				EndIf
				If $Type = $eDrag And StringInStr($FullTemp & " " , "dragon") >0 Then
					Return $Slot
				EndIf
				If $Type = $ePekk And StringInStr($FullTemp & " " , "pekka") >0 Then
					Return $Slot
				EndIf
				If $Type = $eMini And StringInStr($FullTemp & " " , "minions") >0 Then
					Return $Slot
				EndIf
				If $Type = $eHogs And StringInStr($FullTemp & " " , "hogs") >0 Then
					Return $Slot
				EndIf
				If $Type = $eValk And StringInStr($FullTemp & " " , "valk") >0 Then
					Return $Slot
				EndIf
				If $Type = $eWitc And StringInStr($FullTemp & " " , "witch") >0 Then
					Return $Slot
				EndIf
				If $Type = $eGole And StringInStr($FullTemp & " " , "golem") >0 Then
					Return $Slot
				EndIf
				If $Type = $eLava And StringInStr($FullTemp & " " , "lava") >0 Then
					Return $Slot
				EndIf
				;If $Type = $eBowl And StringInStr($FullTemp & " " , "bowler") >0 Then
				;Return $Slot
				;EndIf
			EndIf
		Next
	EndIf
	If $Type >= $ePSpell And $Type <= $eHaSpell Then
		For $Slot = 12 To 14
			If $debugSetlog = 1 Then Setlog(" Slot : " & $Slot, $COLOR_PURPLE)
			Local $FullTemp = getOcrDonationTroopsDetection(342 + (68 * ($Slot - 12)), $DonationWindowY + 241)
			If $debugSetlog = 1 Then Setlog(" getOcrDonationSpells: " & $FullTemp, $COLOR_PURPLE)
			If $debugSetlog = 1 Then
				Switch $FullTemp
					Case "barbarian"
						setlog("Detected barbarian", $COLOR_GREEN)
					Case "archer"
						setlog("Detected archer", $COLOR_GREEN)
					Case "giant"
						setlog("Detected giant", $COLOR_GREEN)
					Case "goblin"
						setlog("Detected goblin", $COLOR_GREEN)
					Case "wb"
						setlog("Detected wall breaker", $COLOR_GREEN)
					Case "balloon"
						setlog("Detected balloon", $COLOR_GREEN)
					Case "wizard"
						setlog("Detected wizard", $COLOR_GREEN)
					Case "healer"
						setlog("Detected healer", $COLOR_GREEN)
					Case "dragon"
						setlog("Detected dragon", $COLOR_GREEN)
					Case "pekka"
						setlog("Detected pekka", $COLOR_GREEN)
					Case "minions"
						setlog("Detected minion", $COLOR_GREEN)
					Case "hogs"
						setlog("Detected hog", $COLOR_GREEN)
					Case "valk"
						setlog("Detected valkiria", $COLOR_GREEN)
					Case "witch"
						setlog("Detected witch", $COLOR_GREEN)
					Case "golem"
						setlog("Detected golem", $COLOR_GREEN)
					Case "lava"
						setlog("Detected lava", $COLOR_GREEN)
					Case "bowler"
						setlog("Detected bowler", $COLOR_GREEN)
					Case "poison"
						setlog("Detected poison", $COLOR_GREEN)
					Case "earthquake"
						setlog("Detected earthquake", $COLOR_GREEN)
					Case "haste"
						setlog("Detected haste", $COLOR_GREEN)
					Case Else
						setlog("Detected <<<<" & $FullTemp & ">>>>", $COLOR_GREEN)
				EndSwitch
			EndIf
			;If $FullTemp = "empty" Then exitloop
			If $Type = $ePSpell And $FullTemp = "poison" Then
				Return $Slot
			EndIf
			If $Type = $eESpell And $FullTemp = "earthquake" Then
				Return $Slot
			EndIf
			If $Type = $eHaSpell And $FullTemp = "haste" Then
				Return $Slot
			EndIf
		Next
	EndIf
;	If $FullTemp = "" Then
		Return -1
;	EndIf

EndFunc   ;==>DetectSlotTroop

