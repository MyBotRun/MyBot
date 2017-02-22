; #FUNCTION# ====================================================================================================================
; Name ..........: DonateCC
; Description ...: This file includes functions to Donate troops
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Zax (2015)
; Modified ......: Safar46 (2015), Hervidero (2015-04), HungLe (2015-04), Sardo (2015-08), Promac (2015-12), Hervidero (2016-01), MonkeyHunter (2016-07),
;				   CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $DonationWindowY
Global $PrepDon[4] = [False, False, False, False]
Global $iTotalDonateCapacity, $iTotalDonateSpellCapacity
Global $iDonTroopsLimit = 8, $iDonSpellsLimit = 1, $iDonTroopsAv = 0, $iDonSpellsAv = 0
Global $iDonTroopsQuantityAv = 0, $iDonTroopsQuantity = 0, $iDonSpellsQuantityAv = 0, $iDonSpellsQuantity = 0
Global $bSkipDonTroops = False, $bSkipDonSpells = False
Global $bDonateAllRespectBlk = False ; is turned on off durning donate all section, must be false all other times
Global $DonatePixel ; array holding x, y position of donate button in chat window

Func PrepareDonateCC()
	$PrepDon[0] = 0
	$PrepDon[1] = 0
	For $i = 0 To $eTroopCount-1 + $g_iCustomDonateConfigs
	   $PrepDon[0] = BitOR($PrepDon[0], ($g_abChkDonateTroop[$i] ? 1 : 0))
	   $PrepDon[1] = BitOR($PrepDon[1], ($g_abChkDonateAllTroop[$i] ? 1 : 0))
    Next

    $PrepDon[2] = 0
	$PrepDon[3] = 0
    For $i = 0 To $eSpellCount - 1
	   If $i <> $eSpellClone Then
		  $PrepDon[2] = BitOR($PrepDon[2], ($g_abChkDonateSpell[$i] ? 1 : 0))
		  $PrepDon[3] = BitOR($PrepDon[3], ($g_abChkDonateAllSpell[$i] ? 1 : 0))
	   EndIf
    Next

	$bActiveDonate = BitOR($PrepDon[0], $PrepDon[1], $PrepDon[2], $PrepDon[3])
	;$bDonate = BitOR($PrepDon[0], $PrepDon[1], $PrepDon[2], $PrepDon[3])
	;Setlog(" - Donate: $bDonate:" & $bDonate & " $bDonateTroop:" & $PrepDon[0] & " $bDonateAllTroop:" & $PrepDon[1] & " $bDonateSpell:" & $PrepDon[2] & " $bDonateAllSpell:" & $PrepDon[3], $COLOR_GREEN)
EndFunc   ;==>PrepareDonateCC

Func DonateCC($Check = False)

	Local $bDonateTroop = $PrepDon[0]

	Local $bDonateAllTroop = $PrepDon[1]

	Local $bDonateSpell = $PrepDon[2]
	Local $bDonateAllSpell = $PrepDon[3]

	Local $bDonate = $bActiveDonate

	Local $bOpen = True, $bClose = False

	Local $ReturnT = ($CurCamp >= ($TotalCamp * $g_iTrainArmyFullTroopPct / 100) * .95) ? (True) : (False)

	Local $ClanString = ""

	If $bDonate = False Or $bDonationEnabled = False Then
		If $g_iDebugSetlog = 1 Then Setlog("Donate Clan Castle troops skip", $COLOR_DEBUG)
		Return ; exit func if no donate checkmarks
	EndIf

	Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)

	If $g_abDonateHours[$hour[0]] = False And $g_bDonateHoursEnable = True Then
		If $g_iDebugSetlog = 1 Then SetLog("Donate Clan Castle troops not planned, Skipped..", $COLOR_DEBUG)
		Return ; exit func if no planned donate checkmarks
	EndIf

	;If SkipDonateNearFullTroops() = True Then Return

	Local $y = 90

	;check for new chats first
	If $Check = True Then
		If _ColorCheck(_GetPixelColor(26, 312 + $g_iMidOffsetY, True), Hex(0xf00810, 6), 20) = False And $g_iCommandStop <> 3 Then
			Return ;exit if no new chats
		EndIf
	EndIf

	;<---- opens clan tab and verbose in log
	ClickP($aAway, 1, 0, "#0167") ;Click Away
	Setlog("Checking for Donate Requests in Clan Chat", $COLOR_INFO)

	ForceCaptureRegion()
	If _CheckPixel($aChatTab, $g_bCapturePixel) = False Then ClickP($aOpenChat, 1, 0, "#0168") ; Clicks chat tab
	If _Sleep($iDelayDonateCC4) Then Return

	Local $icount = 0
	While 1
		;If Clan tab is selected.
		If _ColorCheck(_GetPixelColor(189, 24, True), Hex(0x706C50, 6), 20) = True Then ; color med gray
			;If _Sleep(200) Then Return ;small delay to allow tab to completely open
			;Clan tab already Selected no click needed
			;ClickP($aClanTab, 1, 0, "#0169") ; clicking clan tab
			ExitLoop
		EndIf
		;If Global tab is selected.
		If _ColorCheck(_GetPixelColor(189, 24, True), Hex(0x383828, 6), 20) = True Then ; Darker gray
			If _Sleep($iDelayDonateCC1) Then Return ;small delay to allow tab to completely open
			ClickP($aClanTab, 1, 0, "#0169") ; clicking clan tab
			ExitLoop
		EndIf
		;counter for time approx 3 sec max allowed for tab to open
		$icount += 1
		If $icount >= 15 Then ; allows for up to a sleep of 3000
			SetLog("Clan Chat Did Not Open - Abandon Donate")
			AndroidPageError("DonateCC")
			Return
		EndIf
		If _Sleep($iDelayDonateCC1) Then Return ; delay Allow 15x
	WEnd

	Local $Scroll
	Local $donateCCfilter = False
	; add scroll here
	While 1
		ForceCaptureRegion()
		;$Scroll = _PixelSearch(288, 640 + $g_iBottomOffsetY, 290, 655 + $g_iBottomOffsetY, Hex(0x588800, 6), 20)
		$y = 90
		$Scroll = _PixelSearch(293, 8 + $y, 295, 23 + $y, Hex(0xFFFFFF, 6), 20)
		If IsArray($Scroll) And _ColorCheck(_GetPixelColor(300, 110, True), Hex(0x509808, 6), 20) = True Then ; a second pixel for the green
			$bDonate = True
			Click($Scroll[0], $Scroll[1], 1, 0, "#0172")
			$y = 90
			If _Sleep($iDelayDonateCC2 + 100) Then ExitLoop
			ContinueLoop
		EndIf
		ExitLoop
	WEnd
	While $bDonate
		checkAttackDisable($iTaBChkIdle) ; Early Take-A-Break detection
		$ClanString = ""

		If _Sleep($iDelayDonateCC2) Then ExitLoop
		ForceCaptureRegion()
		$DonatePixel = _MultiPixelSearch(202, $y, 224, 660 + $g_iBottomOffsetY, 50, 1, Hex(0x98D057, 6), $aChatDonateBtnColors, 15)
		If IsArray($DonatePixel) Then ; if Donate Button found
			If $g_iDebugSetlog = 1 Then Setlog("$DonatePixel: (" & $DonatePixel[0] & "," & $DonatePixel[1] & ")", $COLOR_DEBUG)

			; collect donate users images
			$donateCCfilter= donateCCWBLUserImageCollect($DonatePixel[0],$DonatePixel[1])

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
			If ($bDonateTroop Or $bDonateSpell Or $bDonateAllTroop Or $bDonateAllSpell) And $donateCCfilter Then
				If $g_bChkExtraAlphabets Then
					; Chat Request using "coc-latin-cyr" xml: Latin + Cyrillic derived alphabets / three paragraphs
					Setlog("Using OCR to read Latin and Cyrillic derived alphabets..", $COLOR_ACTION)
					$ClanString = ""
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
				Else ; default
					; Chat Request using "coc-latinA" xml: only Latin derived alphabets / three paragraphs
					Setlog("Using OCR to read Latin derived alphabets..", $COLOR_ACTION)
					$ClanString = ""
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
					; Chat Request using IMGLOC: Chinese alphabet / one paragraph
				If $g_bChkExtraChinese Then
					Setlog("Using OCR to read the Chinese alphabet..", $COLOR_ACTION)
					If $ClanString = "" Then
						$ClanString = getChatStringChinese(30, $DonatePixel[1] - 24)
					Else
						$ClanString &= " " & getChatStringChinese(30, $DonatePixel[1] - 24)
					EndIf
					If _Sleep($iDelayDonateCC2) Then ExitLoop
				EndIf
					; Chat Request using IMGLOC: Korean alphabet / one paragraph
				If $g_bChkExtraKorean Then
					Setlog("Using OCR to read the Korean alphabet..", $COLOR_ACTION)
					If $ClanString = "" Then
						$ClanString = getChatStringKorean(30, $DonatePixel[1] - 24)
					Else
						$ClanString &= " " & getChatStringKorean(30, $DonatePixel[1] - 24)
					EndIf
					If _Sleep($iDelayDonateCC2) Then ExitLoop
				EndIf


				If $ClanString = "" Or $ClanString = " " Then
					SetLog("Unable to read Chat Request!", $COLOR_ERROR)
					$bDonate = True
					$y = $DonatePixel[1] + 50
					ContinueLoop
				Else
					If $g_bChkExtraAlphabets Then
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

			If $donateCCfilter = False Then
			   Setlog("Skip Donation at this Clan Mate...", $COLOR_ACTION)
			   $bSkipDonTroops = True
			   $bSkipDonSpells = True
			Else
				If $iTotalDonateCapacity <= 0 Then
					   Setlog("Clan Castle troops are full, skip troop donation...", $COLOR_ACTION)
					$bSkipDonTroops = True
				EndIf
				If $iTotalDonateSpellCapacity = 0 Then
					   Setlog("Clan Castle spells are full, skip spell donation...", $COLOR_ACTION)
					$bSkipDonSpells = True
				ElseIf $iTotalDonateSpellCapacity = -1 Then
					; no message, this CC has no Spell capability
					   If $g_iDebugSetlog = 1 Then Setlog("This CC cannot accept spells, skip spell donation...", $COLOR_DEBUG)
					$bSkipDonSpells = True
				ElseIf $CurSFactory = 0 Then
					If $g_iDebugSetlog = 1 Then Setlog("No spells available, skip spell donation...", $COLOR_DEBUG) ;Debug
					Setlog("No spells available, skip spell donation...", $COLOR_ORANGE)
					$bSkipDonSpells = True
				EndIf

			EndIf

			If $bSkipDonTroops And $bSkipDonSpells Then
				$bDonate = True
				$y = $DonatePixel[1] + 50
				ContinueLoop ; go to next button if cant read Castle Troops and Spells before the donate window opens
			EndIf

			; open Donate Window
			If _Sleep(1000) Then Return
			If ($bSkipDonTroops = True And $bSkipDonSpells = True) Or DonateWindow($bOpen) = False Then
				$bDonate = True
				$y = $DonatePixel[1] + 50
				SetLog("Donate Window did not open - Exiting Donate", $COLOR_RED)
				ExitLoop ; Leave donate to prevent a bot hang condition
			EndIf

			If $bDonateTroop Or $bDonateSpell Then
				If $g_iDebugSetlog = 1 Then Setlog("Troop/Spell checkpoint.", $COLOR_DEBUG)

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
					If $g_iDebugSetlog = 1 Then Setlog("Troop checkpoint.", $COLOR_DEBUG)

					;;; Custom Combination Donate by ChiefM3, edited by MonkeyHunter
					If $g_abChkDonateTroop[$eCustomA] And CheckDonateTroop(99, $g_asTxtDonateTroop[$eCustomA], $g_asTxtBlacklistTroop[$eCustomA], $ClanString) Then
						For $i = 0 To 2
							If $g_aiDonateCustomTrpNumA[$i][0] < $eBarb Then
								$g_aiDonateCustomTrpNumA[$i][0] = $eArch ; Change strange small numbers to archer
							ElseIf $g_aiDonateCustomTrpNumA[$i][0] > $eBowl Then
								ContinueLoop ; If "Nothing" is selected then continue
							EndIf
							If $g_aiDonateCustomTrpNumA[$i][1] < 1 Then
								ContinueLoop ; If donate number is smaller than 1 then continue
							ElseIf $g_aiDonateCustomTrpNumA[$i][1] > 8 Then
								$g_aiDonateCustomTrpNumA[$i][1] = 8 ; Number larger than 8 is unnecessary
							EndIf
							DonateTroopType($g_aiDonateCustomTrpNumA[$i][0], $g_aiDonateCustomTrpNumA[$i][1], $g_abChkDonateTroop[$eCustomA]) ;;; Donate Custom Troop using DonateTroopType2
						Next
					EndIf

					If $g_abChkDonateTroop[$eCustomB] And CheckDonateTroop(99, $g_asTxtDonateTroop[$eCustomB], $g_asTxtBlacklistTroop[$eCustomB], $ClanString) Then
						For $i = 0 To 2
							If $g_aiDonateCustomTrpNumB[$i][0] < $eBarb Then
								$g_aiDonateCustomTrpNumB[$i][0] = $eArch ; Change strange small numbers to archer
							ElseIf $g_aiDonateCustomTrpNumB[$i][0] > $eBowl Then
								ContinueLoop ; If "Nothing" is selected then continue
							EndIf
							If $g_aiDonateCustomTrpNumB[$i][1] < 1 Then
								ContinueLoop ; If donate number is smaller than 1 then continue
							ElseIf $g_aiDonateCustomTrpNumB[$i][1] > 8 Then
								$g_aiDonateCustomTrpNumB[$i][1] = 8 ; Number larger than 8 is unnecessary
							EndIf
							DonateTroopType($g_aiDonateCustomTrpNumB[$i][0], $g_aiDonateCustomTrpNumB[$i][1], $g_abChkDonateTroop[$eCustomB]) ;;; Donate Custom Troop using DonateTroopType2
						Next
				    EndIf

				    If $bSkipDonTroops = False Then
					   For $i = 0 To UBound($g_aiDonateTroopPriority) - 1
						  Local $iTroopIndex = $g_aiDonateTroopPriority[$i]
						  If $g_abChkDonateTroop[$iTroopIndex] Then
							 If CheckDonateTroop($iTroopIndex, $g_asTxtDonateTroop[$iTroopIndex], $g_asTxtBlacklistTroop[$iTroopIndex], $ClanString) Then
								DonateTroopType($iTroopIndex)
						     EndIf
						  EndIf
					   Next
				    EndIf

				EndIf

				If $bDonateSpell = 1 And $bSkipDonSpells = False Then
					If $g_iDebugSetlog = 1 Then Setlog("Spell checkpoint.", $COLOR_DEBUG)

					For $i = 0 To UBound($g_aiDonateSpellPriority) - 1
					   Local $iSpellIndex = $g_aiDonateSpellPriority[$i]
					   If $g_abChkDonateSpell[$iSpellIndex] Then
						  If CheckDonateSpell($iSpellIndex, $g_asTxtDonateSpell[$iSpellIndex], $g_asTxtBlacklistSpell[$iSpellIndex], $ClanString) Then
							 DonateSpellType($iSpellIndex)
						  EndIf
					   EndIf
					Next
				 EndIf

			EndIf

			If $bDonateAllTroop Or $bDonateAllSpell Then
				If $g_iDebugSetlog = 1 Then Setlog("Troop/Spell All checkpoint.", $COLOR_DEBUG) ;Debug
				$bDonateAllRespectBlk = True

				If $bDonateAllTroop And $bSkipDonTroops = False Then
					; read available donate cap, and ByRef set the $bSkipDonTroops and $bSkipDonSpells flags
					DonateWindowCap($bSkipDonTroops, $bSkipDonSpells)
					If $bSkipDonTroops And $bSkipDonSpells Then
						DonateWindow($bClose)
						$bDonate = True
						$y = $DonatePixel[1] + 50
						If _Sleep($iDelayDonateCC2) Then ExitLoop
						ContinueLoop ; go to next button if already donated, maybe this is an impossible case..
					EndIf
					If $g_iDebugSetlog = 1 Then Setlog("Troop All checkpoint.", $COLOR_DEBUG)
					Select
						Case $g_abChkDonateAllTroop[$eCustomA]
							For $i = 0 To 2
								If $g_aiDonateCustomTrpNumA[$i][0] < $eBarb Then
									$g_aiDonateCustomTrpNumA[$i][0] = $eArch ; Change strange small numbers to archer
								ElseIf $g_aiDonateCustomTrpNumA[$i][0] > $eBowl Then
									DonateWindow($bClose)
									$bDonate = True
									$y = $DonatePixel[1] + 50
									If _Sleep($iDelayDonateCC2) Then ExitLoop
									ContinueLoop ; If "Nothing" is selected then continue
								EndIf
								If $g_aiDonateCustomTrpNumA[$i][1] < 1 Then
									DonateWindow($bClose)
									$bDonate = True
									$y = $DonatePixel[1] + 50
									If _Sleep($iDelayDonateCC2) Then ExitLoop
									ContinueLoop ; If donate number is smaller than 1 then continue
								ElseIf $g_aiDonateCustomTrpNumA[$i][1] > 8 Then
									$g_aiDonateCustomTrpNumA[$i][1] = 8 ; Number larger than 8 is unnecessary
								EndIf
								DonateTroopType($g_aiDonateCustomTrpNumA[$i][0], $g_aiDonateCustomTrpNumA[$i][1], $g_abChkDonateAllTroop[$eCustomA], $bDonateAllTroop) ;;; Donate Custom Troop using DonateTroopType2
						    Next

						Case $g_abChkDonateAllTroop[$eCustomB]
							For $i = 0 To 2
								If $g_aiDonateCustomTrpNumB[$i][0] < $eBarb Then
									$g_aiDonateCustomTrpNumB[$i][0] = $eArch ; Change strange small numbers to archer
								ElseIf $g_aiDonateCustomTrpNumB[$i][0] > $eBowl Then
									DonateWindow($bClose)
									$bDonate = True
									$y = $DonatePixel[1] + 50
									If _Sleep($iDelayDonateCC2) Then ExitLoop
									ContinueLoop ; If "Nothing" is selected then continue
								EndIf
								If $g_aiDonateCustomTrpNumB[$i][1] < 1 Then
									DonateWindow($bClose)
									$bDonate = True
									$y = $DonatePixel[1] + 50
									If _Sleep($iDelayDonateCC2) Then ExitLoop
									ContinueLoop ; If donate number is smaller than 1 then continue
								ElseIf $g_aiDonateCustomTrpNumB[$i][1] > 8 Then
									$g_aiDonateCustomTrpNumB[$i][1] = 8 ; Number larger than 8 is unnecessary
								EndIf
								DonateTroopType($g_aiDonateCustomTrpNumB[$i][0], $g_aiDonateCustomTrpNumB[$i][1], $g_abChkDonateAllTroop[$eCustomB], $bDonateAllTroop) ;;; Donate Custom Troop using DonateTroopType2
						    Next

						Case Else
						  For $i = 0 To UBound($g_aiDonateTroopPriority) - 1
							 Local $iTroopIndex = $g_aiDonateTroopPriority[$i]
							 If $g_abChkDonateAllTroop[$iTroopIndex] Then
								If CheckDonateTroop($iTroopIndex, $g_asTxtDonateTroop[$iTroopIndex], $g_asTxtBlacklistTroop[$iTroopIndex], $ClanString) Then
								   DonateTroopType($iTroopIndex, 0, False, $bDonateAllTroop)
								EndIf
								ExitLoop
							 EndIf
						  Next

					EndSelect
				EndIf

				If $bDonateAllSpell And $bSkipDonSpells = False Then
					If $g_iDebugSetlog = 1 Then Setlog("Spell All checkpoint.", $COLOR_DEBUG)

					For $i = 0 To UBound($g_aiDonateSpellPriority) - 1
					   Local $iSpellIndex = $g_aiDonateSpellPriority[$i]
					   If $g_abChkDonateAllSpell[$iSpellIndex] Then
						  If CheckDonateSpell($iSpellIndex, $g_asTxtDonateSpell[$iSpellIndex], $g_asTxtBlacklistSpell[$iSpellIndex], $ClanString) Then
							 DonateSpellType($iSpellIndex, 0, False, $bDonateAllSpell)
						  EndIf
						  ExitLoop
					   EndIf
					Next
				EndIf
				$bDonateAllRespectBlk = False
			EndIf

			;close Donate Window
			DonateWindow($bClose)

			$bDonate = True
			$y = $DonatePixel[1] + 50
			ClickP($aAway, 1, 0, "#0171")
			If _Sleep($iDelayDonateCC2) Then ExitLoop
		EndIf
		;ck for more donate buttons
		ForceCaptureRegion()
		$DonatePixel = _MultiPixelSearch(202, $y, 224, 660 + $g_iBottomOffsetY, 50, 1, Hex(0x98D057, 6), $aChatDonateBtnColors, 15)
		If IsArray($DonatePixel) Then
			If $g_iDebugSetlog = 1 Then Setlog("More Donate buttons found, new $DonatePixel: (" & $DonatePixel[0] & "," & $DonatePixel[1] & ")", $COLOR_DEBUG)
			ContinueLoop
		Else
			If $g_iDebugSetlog = 1 Then Setlog("No more Donate buttons found, closing chat ($y=" & $y & ")", $COLOR_DEBUG)
		EndIf
		; Scroll Down

		ForceCaptureRegion()
		;$Scroll = _PixelSearch(288, 640 + $g_iBottomOffsetY, 290, 655 + $g_iBottomOffsetY, Hex(0x588800, 6), 20)
		;$y = 90
		;$Scroll = _PixelSearch(293, 8 + $y, 295, 23 + $y, Hex(0xFFFFFF, 6), 20)
		$Scroll = _PixelSearch(293, 687 - 30, 295, 693 - 30, Hex(0xFFFFFF, 6), 20)


		If IsArray($Scroll) Then
			$bDonate = True
			Click($Scroll[0], $Scroll[1], 1, 0, "#0172")
			$y = 600

			If _Sleep($iDelayDonateCC2) Then ExitLoop
			ContinueLoop
		EndIf
		$bDonate = False
	WEnd

	UpdateStats()

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
				SetLog("Error finding Clan Tab to close...", $COLOR_ERROR)
				AndroidPageError("DonateCC")
				ExitLoop
			EndIf
		EndIf
	WEnd

	If _Sleep($iDelayDonateCC2) Then Return

EndFunc   ;==>DonateCC

Func CheckDonateTroop(Const $iTroopIndex, Const $sDonateTroopString, Const $sBlacklistTroopString, Const $sClanString)
   Local $sName = ($iTroopIndex = 99 ? "Custom" : $g_asTroopNames[$iTroopIndex])
   Return CheckDonate($sName, $sDonateTroopString, $sBlacklistTroopString, $sClanString)
EndFunc

Func CheckDonateSpell(Const $iSpellIndex, Const $sDonateSpellString, Const $sBlacklistSpellString, Const $sClanString)
   Local $sName = $g_asSpellNames[$iSpellIndex]
   Return CheckDonate($sName, $sDonateSpellString, $sBlacklistSpellString, $sClanString)
EndFunc

Func CheckDonate(Const $sName, Const $sDonateString, Const $sBlacklistString, Const $sClanString)
    Local $asSplitDonate = StringSplit($sDonateString, @CRLF, $STR_ENTIRESPLIT)
    Local $asSplitBlacklist = StringSplit($sBlacklistString, @CRLF, $STR_ENTIRESPLIT)
	Local $asSplitGeneralBlacklist = StringSplit($g_sTxtGeneralBlacklist, @CRLF, $STR_ENTIRESPLIT)

	For $i = 1 To UBound($asSplitGeneralBlacklist) - 1
		If CheckDonateString($asSplitGeneralBlacklist[$i], $sClanString) Then
			SetLog("General Blacklist Keyword found: " & $asSplitGeneralBlacklist[$i], $COLOR_ERROR)
			Return False
		EndIf
	Next

	For $i = 1 To UBound($asSplitBlacklist) - 1
		If CheckDonateString($asSplitBlacklist[$i], $sClanString) Then
			SetLog($sName & " Blacklist Keyword found: " & $asSplitBlacklist[$i], $COLOR_ERROR)
			Return False
		EndIf
	Next

	If $bDonateAllRespectBlk = False Then
		For $i = 1 To UBound($asSplitDonate) - 1
			If CheckDonateString($asSplitDonate[$i], $sClanString) Then
				Setlog($sName & " Keyword found: " & $asSplitDonate[$i], $COLOR_SUCCESS)
				Return True
			EndIf
		Next
	EndIf

	If $bDonateAllRespectBlk = True Then Return True

	If $g_iDebugSetlog = 1 Then Setlog("Bad call of CheckDonateTroop: " & $sName, $COLOR_DEBUG)
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

Func DonateTroopType(Const $iTroopIndex, $Quant = 0, Const $Custom = False, Const $bDonateAll = False)
   Local $Slot = -1, $detectedSlot = -1
   Local $YComp = 0, $donaterow = -1
   Local $donateposinrow = -1
   Local $sTextToAll = ""

   If $iTotalDonateCapacity = 0 Then Return
   If $g_iDebugSetlog = 1 Then Setlog("$DonateTroopType Start: " & $g_asTroopNames[$iTroopIndex], $COLOR_DEBUG)

   ; Space to donate troop?
   $iDonTroopsQuantityAv = Floor($iTotalDonateCapacity / $g_aiTroopSpace[$iTroopIndex])
   If $iDonTroopsQuantityAv < 1 Then
	  Setlog("Sorry Chief! " & $g_asTroopNamesPlural[$iTroopIndex] & " don't fit in the remaining space!")
	  Return
   EndIf

   If $iDonTroopsQuantityAv >= $iDonTroopsLimit Then
	  $iDonTroopsQuantity = $iDonTroopsLimit
   Else
	  $iDonTroopsQuantity = $iDonTroopsQuantityAv
   EndIf


	; Detect the Troops Slot
	If $g_iDebugOCRdonate = 1 Then
		Local $oldDebugOcr = $g_iDebugOcr
		$g_iDebugOcr = 1
	EndIf

   $Slot = DetectSlotTroop($iTroopIndex)
	$detectedSlot = $Slot
	If $g_iDebugSetlog = 1 Then setlog("slot found = " & $Slot, $COLOR_DEBUG)
	If $g_iDebugOCRdonate = 1 Then $g_iDebugOcr = $oldDebugOcr

	If $Slot = -1 Then Return

   ; figure out row/position
   If $Slot < 0 Or $Slot > 11 Then
	  setlog("Invalid slot # found = " & $Slot & " for " & $g_asTroopNames[$iTroopIndex], $COLOR_ERROR)
	  Return
   EndIf
	$donaterow = 1 ;first row of troops
	$donateposinrow = $Slot
	If $Slot >= 6 And $Slot <= 11 Then
		$donaterow = 2 ;second row of troops
		$Slot = $Slot - 6
		$donateposinrow = $Slot
		$YComp = 88 ; correct 860x780
	EndIf

   ; Verify if the type of troop to donate exists
   SetLog("Troops Condition Matched", $COLOR_ORANGE)
   If _ColorCheck(_GetPixelColor(350 + ($Slot * 68), $DonationWindowY + 105 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
	  _ColorCheck(_GetPixelColor(355 + ($Slot * 68), $DonationWindowY + 106 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
	  _ColorCheck(_GetPixelColor(360 + ($Slot * 68), $DonationWindowY + 107 + $YComp, True), Hex(0x306ca8, 6), 20) Then ; check for 'blue'

	  If $Custom Then
		  If $bDonateAll Then $sTextToAll = " (to all requests)"
		  SetLog("Donating " & $Quant & " " & ($Quant > 1 ? $g_asTroopNamesPlural[$iTroopIndex] : $g_asTroopNames[$iTroopIndex]) & $sTextToAll, $COLOR_SUCCESS)

		  If $g_iDebugOCRdonate = 1 Then
			  Setlog("donate", $COLOR_ERROR)
			  Setlog("row: " & $donaterow, $COLOR_ERROR)
			  Setlog("pos in row: " & $donateposinrow, $COLOR_ERROR)
			  setlog("coordinate: " & 365 + ($Slot * 68) & "," & $DonationWindowY + 100 + $YComp, $COLOR_ERROR)
			  debugimagesave("LiveDonateCC-r" & $donaterow & "-c" & $donateposinrow & "-" & $g_asTroopNames[$iTroopIndex] & "_")
		  EndIf

		  If $g_iDebugOCRdonate = 0 Then
			  ; Use slow click when the Train system is Quicktrain
			  If $g_bQuickTrainEnable = True Then
				  Local $icount = 0
				  For $x = 0 To $Quant
					  If _ColorCheck(_GetPixelColor(350 + ($Slot * 68), $DonationWindowY + 105 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
						 _ColorCheck(_GetPixelColor(355 + ($Slot * 68), $DonationWindowY + 106 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
						 _ColorCheck(_GetPixelColor(360 + ($Slot * 68), $DonationWindowY + 107 + $YComp, True), Hex(0x306ca8, 6), 20) Then ; check for 'blue'

						  Click(365 + ($Slot * 68), $DonationWindowY + 100 + $YComp, 1, $iDelayDonateCC3, "#0175")
						  If $g_iCommandStop = 3 Then
							  $g_iCommandStop = 0
							  $fullArmy = False
						  EndIf
						  If _Sleep(1000) Then Return
						  $icount += 1
					  EndIf
				  Next
				  $Quant = $icount ; Count Troops Donated Clicks
				  $g_aiDonateStatsTroops[$iTroopIndex][0] += $Quant
			  Else
				  If _ColorCheck(_GetPixelColor(350 + ($Slot * 68), $DonationWindowY + 105 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
					 _ColorCheck(_GetPixelColor(355 + ($Slot * 68), $DonationWindowY + 106 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
					 _ColorCheck(_GetPixelColor(360 + ($Slot * 68), $DonationWindowY + 107 + $YComp, True), Hex(0x306ca8, 6), 20) Then ; check for 'blue'

					  Click(365 + ($Slot * 68), $DonationWindowY + 100 + $YComp, $Quant, $iDelayDonateCC3, "#0175")
					 $g_aiDonateStatsTroops[$iTroopIndex][0] += $Quant
					  If $g_iCommandStop = 3 Then
						  $g_iCommandStop = 0
						  $fullArmy = False
					  EndIf
				  EndIf
			  EndIf

			  ; Adjust Values for donated troops to prevent a Double ghost donate to stats and train
			  If $iTroopIndex >= $eTroopBarbarian And $iTroopIndex <= $eTroopBowler Then
				 ;Reduce iTotalDonateCapacity by troops donated
				 $iTotalDonateCapacity -= ($Quant * $g_aiTroopSpace[$iTroopIndex])
				 ;If donated max allowed troop qty set $bSkipDonTroops = True
				 If $iDonTroopsLimit = $Quant Then
					 $bSkipDonTroops = True
				 EndIf
			  EndIf
		  EndIf

	  Else
		  If $g_iDebugOCRdonate = 1 Then
			  Setlog("donate", $color_RED)
			  Setlog("row: " & $donaterow, $color_RED)
			  Setlog("pos in row: " & $donateposinrow, $color_red)
			  setlog("coordinate: " & 365 + ($Slot * 68) & "," & $DonationWindowY + 100 + $YComp, $color_red)
			  debugimagesave("LiveDonateCC-r" & $donaterow & "-c" & $donateposinrow & "-" & $g_asTroopNames[$iTroopIndex] & "_")
		  EndIf
		  If $g_iDebugOCRdonate = 0 Then
			  ; Use slow click when the Train system is Quicktrain
			  If $g_bQuickTrainEnable = True Then
				  Local $icount = 0
				  For $x = 0 To $iDonTroopsQuantity
					  If _ColorCheck(_GetPixelColor(350 + ($Slot * 68), $DonationWindowY + 105 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
						 _ColorCheck(_GetPixelColor(355 + ($Slot * 68), $DonationWindowY + 106 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
						 _ColorCheck(_GetPixelColor(360 + ($Slot * 68), $DonationWindowY + 107 + $YComp, True), Hex(0x306ca8, 6), 20) Then ; check for 'blue'

						  Click(365 + ($Slot * 68), $DonationWindowY + 100 + $YComp, 1, $iDelayDonateCC3, "#0175")
						  $icount += 1
						  If $g_iCommandStop = 3 Then
							  $g_iCommandStop = 0
							  $fullArmy = False
						  EndIf
						  If _Sleep(1000) Then Return
					  EndIf
				  Next
				  $iDonTroopsQuantity = $icount ; Count Troops Donated Clicks
				  $g_aiDonateStatsTroops[$iTroopIndex][0] += $iDonTroopsQuantity
			  Else
				  If _ColorCheck(_GetPixelColor(350 + ($Slot * 68), $DonationWindowY + 105 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
					 _ColorCheck(_GetPixelColor(355 + ($Slot * 68), $DonationWindowY + 106 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
					 _ColorCheck(_GetPixelColor(360 + ($Slot * 68), $DonationWindowY + 107 + $YComp, True), Hex(0x306ca8, 6), 20) Then ; check for 'blue'

					  Click(365 + ($Slot * 68), $DonationWindowY + 100 + $YComp, $iDonTroopsQuantity, $iDelayDonateCC3, "#0175")
					 $g_aiDonateStatsTroops[$iTroopIndex][0] += $iDonTroopsQuantity
					  If $g_iCommandStop = 3 Then
						  $g_iCommandStop = 0
						  $fullArmy = False
					  EndIf
				  EndIf
			  EndIf

			  If $bDonateAll Then $sTextToAll = " (to all requests)"
			  SetLog("Donating " & $iDonTroopsQuantity & " " & ($iDonTroopsQuantity > 1 ? $g_asTroopNamesPlural[$iTroopIndex] : $g_asTroopNames[$iTroopIndex]) & _
					 $sTextToAll, $COLOR_GREEN)

			  ; Adjust Values for donated troops to prevent a Double ghost donate to stats and train
			  If $iTroopIndex >= $eTroopBarbarian And $iTroopIndex <= $eTroopBowler Then
				 ;Reduce iTotalDonateCapacity by troops donated
				 $iTotalDonateCapacity -= ($iDonTroopsQuantity * $g_aiTroopSpace[$iTroopIndex])
				 ;If donated max allowed troop qty set $bSkipDonTroops = True
				 If $iDonTroopsLimit = $iDonTroopsQuantity Then
					 $bSkipDonTroops = True
				 EndIf

			  EndIf
		  EndIf
	  EndIf

	  ; Assign the donated quantity troops to train : $Don $g_asTroopName

	  If $Custom Then
		  $g_aiDonateTroops[$iTroopIndex] += $Quant
	  Else
		  $g_aiDonateTroops[$iTroopIndex] += $iDonTroopsQuantity
	  EndIf

   ElseIf $DonatePixel[1] - 5 + $YComp > 675 Then
	  Setlog("Unable to donate " & $g_asTroopNames[$iTroopIndex] & ". Donate screen not visible, will retry next run.", $COLOR_ERROR)
   Else
	  SetLog("No " & $g_asTroopNames[$iTroopIndex] & " available to donate..", $COLOR_ERROR)
   EndIf

EndFunc

Func DonateSpellType(Const $iSpellIndex, $Quant = 0, Const $Custom = False, Const $bDonateAll = False)
   Local $Slot = -1, $detectedSlot = -1
   Local $YComp = 0, $donaterow = -1
   Local $donateposinrow = -1
   ;Local $sTextToAll = ""

   If $iTotalDonateSpellCapacity = 0 Then Return
   If $g_iDebugSetlog = 1 Then Setlog("DonateSpellType Start: " & $g_asSpellNames[$iSpellIndex], $COLOR_DEBUG)

   ; Space to donate spell?
   $iDonSpellsQuantityAv = Floor($iTotalDonateSpellCapacity / $g_aiSpellSpace[$iSpellIndex])
   If $iDonSpellsQuantityAv < 1 Then
	  Setlog("Sorry Chief! " & $g_asSpellNames[$iSpellIndex] & " spells don't fit in the remaining space!")
	  Return
   EndIf

   If $iDonSpellsQuantityAv >= $iDonSpellsLimit Then
	  $iDonSpellsQuantity = $iDonSpellsLimit
   Else
	  $iDonSpellsQuantity = $iDonSpellsQuantityAv
   EndIf

	; Detect the Spells Slot
	If $g_iDebugOCRdonate = 1 Then
		Local $oldDebugOcr = $g_iDebugOcr
		$g_iDebugOcr = 1
	EndIf

  ; If $iSpellIndex > $eSpellHaste And $aCurTotalSpell[1] > 6 Then DragSpellDonWindow()

   $Slot = DetectSlotSpell($iSpellIndex)
	$detectedSlot = $Slot
	If $g_iDebugSetlog = 1 Then setlog("slot found = " & $Slot, $COLOR_DEBUG)
	If $g_iDebugOCRdonate = 1 Then $g_iDebugOcr = $oldDebugOcr

	If $Slot = -1 Then Return

   ; figure out row/position
   If $Slot < 12 Or $Slot > 17 Then
	  setlog("Invalid slot # found = " & $Slot & " for " & $g_asSpellNames[$iSpellIndex], $COLOR_ERROR)
	  Return
   EndIf
   $donaterow = 3 ;row of spells
   $Slot = $Slot - 12
   $donateposinrow = $Slot
   $YComp = 203 ; correct 860x780

   SetLog("Spells Condition Matched", $COLOR_ORANGE)
   If _ColorCheck(_GetPixelColor(350 + ($Slot * 68), $DonationWindowY + 105 + $YComp, True), Hex(0x6038B0, 6), 20) Or _
	  _ColorCheck(_GetPixelColor(355 + ($Slot * 68), $DonationWindowY + 106 + $YComp, True), Hex(0x6038B0, 6), 20) Or _
	  _ColorCheck(_GetPixelColor(360 + ($Slot * 68), $DonationWindowY + 107 + $YComp, True), Hex(0x6038B0, 6), 20) Then ; check for 'purple'

	  ;If $bDonateAll Then $sTextToAll = " (to all requests)"
	  ;SetLog("Else Spell Colors Conditions Matched ALSO", $COLOR_ORANGE)
	  ;SetLog("Donating " & $iDonSpellsQuantity & " " & $g_asSpellNames[$iSpellIndex] & $sTextToAll, $COLOR_GREEN)
	  ;Setlog("click donate")
	  If $g_iDebugOCRdonate = 1 Then
		  Setlog("donate", $COLOR_ERROR)
		  Setlog("row: " & $donaterow, $COLOR_ERROR)
		  Setlog("pos in row: " & $donateposinrow, $COLOR_ERROR)
		  setlog("coordinate: " & 365 + ($Slot * 68) & "," & $DonationWindowY + 100 + $YComp, $COLOR_ERROR)
		  debugimagesave("LiveDonateCC-r" & $donaterow & "-c" & $donateposinrow & "-" & $g_asSpellNames[$iSpellIndex] & "_")
	  EndIf
	  If $g_iDebugOCRdonate = 0 Then
		  Click(365 + ($Slot * 68), $DonationWindowY + 100 + $YComp, $iDonSpellsQuantity, $iDelayDonateCC3, "#0600")

		  $bFullArmySpells = False
		  $fullArmy = False
		  $g_aiDonateSpells[$iSpellIndex] += 1

		  If $g_iCommandStop = 3 Then
			  $g_iCommandStop = 0
			  $bFullArmySpells = False
		  EndIf
		 ; DonatedSpell($iSpellIndex, $iDonSpellsQuantity)
		 $g_aiDonateStatsSpells[$iSpellIndex][0] += $iDonSpellsQuantity
	  EndIf

	  ; Assign the donated quantity Spells to train : $Don $g_asSpellName
	  ; need to implement assign $DonPoison etc later

   ElseIf $DonatePixel[1] - 5 + $YComp > 675 Then
	  Setlog("Unable to donate " & $g_asSpellNames[$iSpellIndex] & ". Donate screen not visible, will retry next run.", $COLOR_ERROR)
   Else
	  SetLog("No " & $g_asSpellNames[$iSpellIndex] & " available to donate..", $COLOR_ERROR)
   EndIf

EndFunc
#cs
Func DragSpellDonWindow()
	If Not $g_bRunState Then Return
	If _ColorCheck(_GetPixelColor(350 ,$DonationWindowY, True), Hex(0xFFFFFF, 6), 20) Then
		ClickDrag(715, $DonationWindowY + 303, 580, $DonationWindowY + 303, 50)
		If $g_iDebugSetlog = 1 Then SetLog("Dragged Spell Window successfully", $COLOR_ACTION)
	Else
		If $g_iDebugSetlog = 1 Then SetLog("Couldn't drag the Spell Window because the Donation Window is not open!", $COLOR_ERROR)
		Return
	EndIf
	If _Sleep(800) Then Return
EndFunc
#ce
Func DonateWindow($Open = True)
	If $g_iDebugSetlog = 1 And $Open = True Then Setlog("DonateWindow Open Start", $COLOR_DEBUG)
	If $g_iDebugSetlog = 1 And $Open = False Then Setlog("DonateWindow Close Start", $COLOR_DEBUG)

	If $Open = False Then ; close window and exit
		ClickP($aAway, 1, 0, "#0176")
		If _Sleep($iDelayDonateWindow1) Then Return
		If $g_iDebugSetlog = 1 Then Setlog("DonateWindow Close Exit", $COLOR_DEBUG)
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
		If $g_iDebugSetlog = 1 Then SetLog("Could not find the Donate Button!", $COLOR_DEBUG)
		Return False
	EndIf
	If _Sleep($iDelayDonateWindow1) Then Return

	;_CaptureRegion(0, 0, 320 + $g_iMidOffsetY, $DonatePixel[1] + 30 + $YComp)
	Local $icount = 0
	While Not (_ColorCheck(_GetPixelColor(331, $DonatePixel[1], True), Hex(0xffffff, 6), 0))
		If _Sleep($iDelayDonateWindow1) Then Return
		;_CaptureRegion(0, 0, 320 + $g_iMidOffsetY, $DonatePixel[1] + 30 + $YComp)
		$icount += 1
		If $icount = 20 Then ExitLoop
	WEnd

	; Determinate the right position of the new Donation Window
	; Will search in $Y column = 410 for the first pure white color and determinate that position the $DonationWindowTemp
	$DonationWindowY = 0

	Local $aDonWinOffColors[2][3] = [[0xFFFFFF, 0, 2], [0xc7c5bc, 0, 209]]
	Local $aDonationWindow = _MultiPixelSearch(409, 0, 410, $g_iDEFAULT_HEIGHT, 1, 1, Hex(0xFFFFFF, 6), $aDonWinOffColors, 10)

	If IsArray($aDonationWindow) Then
		$DonationWindowY = $aDonationWindow[1]
		If _Sleep($iDelayDonateWindow1) Then Return
		If $g_iDebugSetlog = 1 Then Setlog("$DonationWindowY: " & $DonationWindowY, $COLOR_DEBUG)
	Else
		SetLog("Could not find the Donate Window!", $COLOR_ERROR)
		Return False
	EndIf

	If $g_iDebugSetlog = 1 Then Setlog("DonateWindow Open Exit", $COLOR_DEBUG)
	Return True
EndFunc   ;==>DonateWindow

Func DonateWindowCap(ByRef $bSkipDonTroops, ByRef $bSkipDonSpells)
	If $g_iDebugSetlog = 1 Then Setlog("DonateCapWindow Start", $COLOR_DEBUG)
	;read troops capacity
	If $bSkipDonTroops = False Then
		Local $sReadCCTroopsCap = getCastleDonateCap(427, $DonationWindowY + 15) ; use OCR to get donated/total capacity
		If $g_iDebugSetlog = 1 Then Setlog("$sReadCCTroopsCap: " & $sReadCCTroopsCap, $COLOR_DEBUG)

		Local $aTempReadCCTroopsCap = StringSplit($sReadCCTroopsCap, "#")
		If $aTempReadCCTroopsCap[0] >= 2 Then
			;  Note - stringsplit always returns an array even if no values split!
			If $g_iDebugSetlog = 1 Then Setlog("$aTempReadCCTroopsCap splitted :" & $aTempReadCCTroopsCap[1] & "/" & $aTempReadCCTroopsCap[2], $COLOR_DEBUG)
			If $aTempReadCCTroopsCap[2] > 0 Then
				$iDonTroopsAv = $aTempReadCCTroopsCap[1]
				$iDonTroopsLimit = $aTempReadCCTroopsCap[2]
				;Setlog("Donate Troops: " & $iDonTroopsAv & "/" & $iDonTroopsLimit)
			EndIf
		Else
			Setlog("Error reading the Castle Troop Capacity...", $COLOR_ERROR) ; log if there is read error
			$iDonTroopsAv = 0
			$iDonTroopsLimit = 0
		EndIf
	EndIf

	If $bSkipDonSpells = False Then
		Local $sReadCCSpellsCap = getCastleDonateCap(420, $DonationWindowY + 220) ; use OCR to get donated/total capacity
		If $g_iDebugSetlog = 1 Then Setlog("$sReadCCSpellsCap: " & $sReadCCSpellsCap, $COLOR_DEBUG)
		Local $aTempReadCCSpellsCap = StringSplit($sReadCCSpellsCap, "#")
		If $aTempReadCCSpellsCap[0] >= 2 Then
			;  Note - stringsplit always returns an array even if no values split!
			If $g_iDebugSetlog = 1 Then Setlog("$aTempReadCCSpellsCap splitted :" & $aTempReadCCSpellsCap[1] & "/" & $aTempReadCCSpellsCap[2], $COLOR_DEBUG)
			If $aTempReadCCSpellsCap[2] > 0 Then
				$iDonSpellsAv = $aTempReadCCSpellsCap[1]
				$iDonSpellsLimit = $aTempReadCCSpellsCap[2]
				;Setlog("Donate Spells: " & $iDonSpellsAv & "/" & $iDonSpellsLimit)
			EndIf
		Else
			Setlog("Error reading the Castle Spells Capacity...", $COLOR_ERROR) ; log if there is read error
			$iDonSpellsAv = 0
			$iDonSpellsLimit = 0
		EndIf
	EndIf

	If $iDonTroopsAv = $iDonTroopsLimit Then
		$bSkipDonTroops = True
		SetLog("Donate Troop Limit Reached")
	EndIf
	If $iDonSpellsAv = $iDonSpellsLimit Then
		$bSkipDonSpells = True
		SetLog("Donate Spell Limit Reached")
	EndIf

	If $bSkipDonTroops = True And $bSkipDonSpells = True And $iDonTroopsAv < $iDonTroopsLimit And $iDonSpellsAv < $iDonSpellsLimit Then
		Setlog("Donate Troops: " & $iDonTroopsAv & "/" & $iDonTroopsLimit & ", Spells: " & $iDonSpellsAv & "/" & $iDonSpellsLimit)
	EndIf
	If $bSkipDonSpells = False And $iDonTroopsAv < $iDonTroopsLimit And $iDonSpellsAv = $iDonSpellsLimit Then Setlog("Donate Troops: " & $iDonTroopsAv & "/" & $iDonTroopsLimit)
	If $bSkipDonTroops = False And $iDonTroopsAv = $iDonTroopsLimit And $iDonSpellsAv < $iDonSpellsLimit Then Setlog("Donate Spells: " & $iDonSpellsAv & "/" & $iDonSpellsLimit)

	If $g_iDebugSetlog = 1 Then Setlog("$bSkipDonTroops: " & $bSkipDonTroops, $COLOR_DEBUG)
	If $g_iDebugSetlog = 1 Then Setlog("$bSkipDonSpells: " & $bSkipDonSpells, $COLOR_DEBUG)
	If $g_iDebugSetlog = 1 Then Setlog("DonateCapWindow End", $COLOR_DEBUG)
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
	If $g_iDebugSetlog = 1 Then Setlog("Started dual getOcrSpaceCastleDonate", $COLOR_DEBUG)
	$aCapTroops = getOcrSpaceCastleDonate(49, $DonatePixel[1]) ; when the request is troops+spell
	$aCapSpells = getOcrSpaceCastleDonate(154, $DonatePixel[1]) ; when the request is troops+spell

	If $g_iDebugSetlog = 1 Then Setlog("$aCapTroops :" & $aCapTroops, $COLOR_DEBUG)
	If $g_iDebugSetlog = 1 Then Setlog("$aCapSpells :" & $aCapSpells, $COLOR_DEBUG)

	If Not (StringInStr($aCapTroops, "#") Or StringInStr($aCapSpells, "#")) Then ; verify if the string is valid or it is just a number from request without spell
		If $g_iDebugSetlog = 1 Then Setlog("Started single getOcrSpaceCastleDonate", $COLOR_DEBUG)
		$aCapTroops = getOcrSpaceCastleDonate(78, $DonatePixel[1]) ; when the Request don't have Spell

		If $g_iDebugSetlog = 1 Then Setlog("$aCapTroops :" & $aCapTroops, $COLOR_DEBUG)
		$aCapSpells = -1
	EndIf

	If $aCapTroops <> "" Then
		; Splitting the XX/XX
		$aTempCapTroops = StringSplit($aCapTroops, "#")

		; Local Variables to use
		If $aTempCapTroops[0] >= 2 Then
			;  Note - stringsplit always returns an array even if no values split!
			If $g_iDebugSetlog = 1 Then Setlog("$aTempCapTroops splitted :" & $aTempCapTroops[1] & "/" & $aTempCapTroops[2], $COLOR_DEBUG)
			If $aTempCapTroops[2] > 0 Then
				$iDonatedTroops = $aTempCapTroops[1]
				$iCapTroopsTotal = $aTempCapTroops[2]
				If $iCapTroopsTotal = 0 Then
					$iCapTroopsTotal = 30
				EndIf
				If $iCapTroopsTotal = 5 Then
					$iCapTroopsTotal = 35
				EndIf
			EndIf
		Else
			Setlog("Error reading the Castle Troop Capacity...", $COLOR_ERROR) ; log if there is read error
			$iDonatedTroops = 0
			$iCapTroopsTotal = 0
		EndIf
	Else
		Setlog("Error reading the Castle Troop Capacity...", $COLOR_ERROR) ; log if there is read error
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
				If $g_iDebugSetlog = 1 Then Setlog("$aTempCapSpells splitted :" & $aTempCapSpells[1] & "/" & $aTempCapSpells[2], $COLOR_DEBUG)
				If $aTempCapSpells[2] > 0 Then
					$iDonatedSpells = $aTempCapSpells[1]
					$iCapSpellsTotal = $aTempCapSpells[2]
				EndIf
			Else
				Setlog("Error reading the Castle Spell Capacity...", $COLOR_ERROR) ; log if there is read error
				$iDonatedSpells = 0
				$iCapSpellsTotal = 0
			EndIf
		Else
			Setlog("Error reading the Castle Spell Capacity...", $COLOR_ERROR) ; log if there is read error
			$iDonatedSpells = 0
			$iCapSpellsTotal = 0
		EndIf
	EndIf


	; $iTotalDonateCapacity it will be use to determinate the quantity of kind troop to donate
	$iTotalDonateCapacity = ($iCapTroopsTotal - $iDonatedTroops)
	If $aCapSpells <> -1 Then $iTotalDonateSpellCapacity = ($iCapSpellsTotal - $iDonatedSpells)

	If $iTotalDonateCapacity < 0 Then
		SetLog("Unable to read Castle Capacity!", $COLOR_ERROR)
	Else
		If $aCapSpells <> -1 Then
			SetLog("Chat Troops: " & $iDonatedTroops & "/" & $iCapTroopsTotal & ", Spells: " & $iDonatedSpells & "/" & $iCapSpellsTotal)
		Else
			SetLog("Chat Troops: " & $iDonatedTroops & "/" & $iCapTroopsTotal)
		EndIf
	EndIf

	;;Return $iTotalDonateCapacity

EndFunc   ;==>RemainingCCcapacity

Func DetectSlotTroop(Const $iTroopIndex)
	Local $FullTemp

	 For $Slot = 0 To 5
		 Local $x = 343 + (68 * $Slot)
		 Local $y = $DonationWindowY + 37
		 Local $x1 = $x + 75
		 Local $y1 = $y + 43

		 $FullTemp = SearchImgloc(@ScriptDir & "\imgxml\DonateCC", $x ,$y, $x1, $y1)
		 If $g_iDebugSetlog = 1 Then Setlog("Troop Slot: " & $Slot & " SearchImgloc returned >>" & $FullTemp[0] & "<<", $COLOR_DEBUG)

		 If StringInStr($FullTemp[0] & " ", "empty") > 0 Then ExitLoop

		 If $FullTemp[0] <> "" Then
			 For $i = $eTroopBarbarian To $eTroopBowler
				 Local $sTmp = StringStripWS(StringLeft($g_asTroopNames[$i], 4), $STR_STRIPTRAILING)
				 ;If $g_iDebugSetlog = 1 Then Setlog($g_asTroopNames[$i] & " = " & $sTmp, $COLOR_DEBUG)
				 If StringInStr($FullTemp[0] & " ", $sTmp) > 0 Then
					 If $g_iDebugSetlog = 1 Then Setlog("Detected " & $g_asTroopNames[$i], $COLOR_DEBUG)
					 If $iTroopIndex = $i Then Return $Slot
					 ExitLoop
				 EndIf
				 If $i = $eTroopBowler Then ; detection failed
					 If $g_iDebugSetlog = 1 Then Setlog("Slot: " & $Slot & "Troop Detection Failed", $COLOR_DEBUG)
				 EndIf
			 Next
		 EndIf
     Next

	 For $Slot = 6 To 11
		 Local $x = 343 + (68 * ($Slot - 6))
		 Local $y = $DonationWindowY + 124
		 Local $x1 = $x + 75
		 Local $y1 = $y + 43

		 $FullTemp = SearchImgloc(@ScriptDir & "\imgxml\DonateCC", $x, $y, $x1, $y1)
		 If $g_iDebugSetlog = 1 Then Setlog("Troop Slot: " & $Slot & " SearchImgloc returned >>" & $FullTemp[0] & "<<", $COLOR_DEBUG)

		 If StringInStr($FullTemp[0] & " ", "empty") > 0 Then ExitLoop

		 If $FullTemp[0] <> "" Then
			 For $i = $eTroopBalloon To $eTroopBowler
				 Local $sTmp = StringStripWS(StringLeft($g_asTroopNames[$i], 4), $STR_STRIPTRAILING)
				 ;If $g_iDebugSetlog = 1 Then Setlog($g_asTroopNames[$i] & " = " & $sTmp, $COLOR_DEBUG)
				 If StringInStr($FullTemp[0] & " ", $sTmp) > 0 Then
					 If $g_iDebugSetlog = 1 Then Setlog("Detected " & $g_asTroopNames[$i], $COLOR_DEBUG)
					 If $iTroopIndex = $i Then Return $Slot
					 ExitLoop
				 EndIf
				 If $i = $eTroopBowler Then ; detection failed
					 If $g_iDebugSetlog = 1 Then Setlog("Slot: " & $Slot & "Troop Detection Failed", $COLOR_DEBUG)
				 EndIf
			 Next
		 EndIf
	 Next

	Return -1

EndFunc   ;==>DetectSlotTroop

Func DetectSlotSpell(Const $iSpellIndex)
	Local $FullTemp

	 For $Slot = 12 To 17
		 Local $x = 343 + (68 * ($Slot - 12))
		 Local $y = $DonationWindowY + 241
		 Local $x1 = $x + 75
		 Local $y1 = $y + 43

		 $FullTemp = SearchImgloc(@ScriptDir & "\imgxml\DonateCCSpells", $x, $y, $x1, $y1)
		 If $g_iDebugSetlog = 1 Then Setlog("Spell Slot: " & $Slot & " SearchImgloc returned >>" & $FullTemp[0] & "<<", $COLOR_DEBUG)

		 If StringInStr($FullTemp[0] & " ", "empty") > 0 Then ExitLoop

		 If $FullTemp[0] <> "" Then
			 For $i = $eSpellLightning To $eSpellSkeleton
				 Local $sTmp = StringLeft($g_asSpellNames[$i], 4)
				 ;If $g_iDebugSetlog = 1 Then Setlog($g_asSpellNames[$i] & " = " & $sTmp, $COLOR_DEBUG)
				 If StringInStr($FullTemp[0] & " ", $sTmp) > 0 Then
					 If $g_iDebugSetlog = 1 Then Setlog("Detected " & $g_asSpellNames[$i], $COLOR_DEBUG)
					 If $iSpellIndex = $i Then Return $Slot
					 ExitLoop
				 EndIf
				 If $i = $eSpellSkeleton Then ; detection failed
					 If $g_iDebugSetlog = 1 Then Setlog("Slot: " & $Slot & "Spell Detection Failed", $COLOR_DEBUG)
				 EndIf
			 Next
		 EndIf
	 Next

	Return -1

EndFunc   ;==>DetectSlotSpell

Func SkipDonateNearFullTroops($setlog = False, $aHeroResult = Default)

	If $bDonationEnabled = False Then Return True ; will disable the donation

	If $g_bDonateSkipNearFullEnable = False Then Return False ; will enable the donation

	If $g_iCommandStop = 0 And $bTrainEnabled = True Then Return False ; IF is halt Attack and Train/Donate ....Enable the donation

	Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)

	If $g_abDonateHours[$hour[0]] = False And $g_bDonateHoursEnable = True Then Return True ; will disable the donation

	If $g_bDonateSkipNearFullEnable = True Then
		If (Number($ArmyCapacity) > Number($g_iDonateSkipNearFullPercent)) Then
			Local $rIsWaitforHeroesActive = IsWaitforHeroesActive()
			If $rIsWaitforHeroesActive = True Then
				If $aHeroResult = Default Or IsArray($aHeroResult) = False Then
					If OpenArmyWindow() = False Then Return False ; Return False if failed to Open Army Window
					$aHeroResult = getArmyHeroTime("all")
				EndIf
				If @error Or UBound($aHeroResult) < 3 Then
					Setlog("getArmyHeroTime return error: #" & @error & "|IA:" & IsArray($aHeroResult) & "," & UBound($aHeroResult) & ", exit SkipDonateNearFullTroops!", $COLOR_ERROR)
					Return False ; if error, then quit SkipDonateNearFullTroops enable the donation
				EndIf
				If $g_iDebugSetlog = 1 Then SetLog("getArmyHeroTime returned: " & $aHeroResult[0] & ":" & $aHeroResult[1] & ":" & $aHeroResult[2], $COLOR_DEBUG)
				Local $iActiveHero = 0
				Local $iHighestTime = -1
				For $pTroopType = $eKing To $eWarden ; check all 3 hero
					For $pMatchMode = $DB To $g_iModeCount - 1 ; check all attack modes
						$iActiveHero = -1
						If IsSearchModeActiveMini($pMatchMode) And IsSpecialTroopToBeUsed($pMatchMode, $pTroopType) And $iHeroUpgrading[$pTroopType - $eKing] <> 1 And $iHeroWaitAttackNoBit[$pMatchMode][$pTroopType - $eKing] = 1 Then
							$iActiveHero = $pTroopType - $eKing ; compute array offset to active hero
						EndIf
								;SetLog("$iActiveHero = " & $iActiveHero, $COLOR_DEBUG)
						If $iActiveHero <> -1 And $aHeroResult[$iActiveHero] > 0 Then ; valid time?
							If $aHeroResult[$iActiveHero] > $iHighestTime Then	; Is the time higher than indexed time?
								$iHighestTime = $aHeroResult[$iActiveHero]
							EndIf
						EndIf
					Next
					If _Sleep($iDelayRespond) Then Return
				Next
				If $g_iDebugSetlog = 1 Then SetLog("$iHighestTime = " & $iHighestTime & "|" & String($iHighestTime > 5), $COLOR_DEBUG)
				If $iHighestTime > 5 Then
					If $setlog Then Setlog("» Donations enabled, Heroes recover time is long", $COLOR_INFO)
					Return False
				Else
					If $setlog Then Setlog("» Donation disabled, available troops " & $ArmyCapacity & "%, limit " & $g_iDonateSkipNearFullPercent & "%", $COLOR_INFO)
					Return True ; troops camps% > limit
				EndIf
			Else
				If $setlog Then Setlog("» Donation disabled, available troops " & $ArmyCapacity & "%, limit " & $g_iDonateSkipNearFullPercent & "%", $COLOR_INFO)
				Return True ; troops camps% > limit
			EndIf
		Else
			If $setlog Then Setlog("» Donations enabled, available troops " & $ArmyCapacity & "%, limit " & $g_iDonateSkipNearFullPercent & "%", $COLOR_INFO)
			Return False ; troops camps% into limits
		EndIf
	Else
		;Setlog("ok, donate enabled (Skip Donate Near FulL Troops disabled option)")
		Return False ; feature disabled
	EndIf
EndFunc   ;==>SkipDonateNearFullTroops

Func BalanceDonRec($bSetlog = False)

	If $bDonationEnabled = False Then Return False ; Will disable donation
	If $iChkUseCCBalanced = 0 Then Return True ; will enable the donation
	If $g_iCommandStop = 0 And $bTrainEnabled = True Then Return True ; IF is halt Attack and Train/Donate ....Enable the donation

	Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)

	If $g_abDonateHours[$hour[0]] = False And $g_bDonateHoursEnable = True Then Return False ; will disable the donation


	If $iChkUseCCBalanced = 1 Then
		If $TroopsDonated = 0 And $TroopsReceived = 0 Then ProfileReport()
		If Number($TroopsReceived) <> 0 Then
			If Number(Number($TroopsDonated) / Number($TroopsReceived)) >= (Number($iCmbCCDonated) / Number($iCmbCCReceived)) Then
				;Stop Donating
				If $bSetlog Then SetLog("Skipping Donation because Donate/Recieve Ratio is wrong", $COLOR_INFO)
				Return False
			Else
				; Continue
				Return True
			EndIf
		EndIf
	Else
		Return True
	EndIf
EndFunc

Func SearchImgloc($directory = "", $x = 0, $y = 0, $x1 = 0, $y1 = 0)

	; Setup arrays, including default return values for $return
	Local $aResult[1], $aCoordArray[1][2], $aCoords, $aCoordsSplit, $aValue
	Local $Redlines = "FV"
	; Capture the screen for comparison
	_CaptureRegion2($x, $y, $x1, $y1)
	Local $res = DllCall($g_hLibImgLoc, "str", "SearchMultipleTilesBetweenLevels", "handle", $hHBitmap2, "str", $directory, "str", "FV", "Int", 0, "str", $Redlines, "Int", 0, "Int", 1000)

	If $res[0] <> "" Then
		; Get the keys for the dictionary item.
		Local $aKeys = StringSplit($res[0], "|", $STR_NOCOUNT)

		; Redimension the result array to allow for the new entries
		ReDim $aResult[UBound($aKeys)]

		; Loop through the array
		For $i = 0 To UBound($aKeys) - 1
			; Get the property values
			$aResult[$i] = returnPropertyValue($aKeys[$i], "objectname")
		Next
		Return $aResult
	EndIf
	$aResult[0] = "queued"
	Return $aResult
EndFunc