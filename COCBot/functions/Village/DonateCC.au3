; #FUNCTION# ====================================================================================================================
; Name ..........: DonateCC
; Description ...: This file includes functions to Donate troops
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Zax (2015)
; Modified ......: Safar46 (2015), Hervidero (2015-04), HungLe (2015-04), Sardo (2015-08), Promac (2015-12), Hervidero (2016-01), MonkeyHunter (2016-07),
;				   CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $g_aiPrepDon[6] = [0, 0, 0, 0, 0, 0]
Global $g_iTotalDonateTroopCapacity, $g_iTotalDonateSpellCapacity, $g_iTotalDonateSiegeMachineCapacity
Global $g_iDonTroopsLimit = 8, $iDonSpellsLimit = 1, $g_iDonTroopsAv = 0, $g_iDonSpellsAv = 0
Global $g_iDonTroopsQuantityAv = 0, $g_iDonTroopsQuantity = 0, $g_iDonSpellsQuantityAv = 0, $g_iDonSpellsQuantity = 0
Global $g_bSkipDonTroops = False, $g_bSkipDonSpells = False, $g_bSkipDonSiege = False
Global $g_bDonateAllRespectBlk = False ; is turned on off durning donate all section, must be false all other times
Global $g_aiAvailQueuedTroop[$eTroopCount], $g_aiAvailQueuedSpell[$eSpellCount]

Func PrepareDonateCC()
	;Troops
	$g_aiPrepDon[0] = 0
	$g_aiPrepDon[1] = 0
	For $i = 0 To $eTroopCount - 1 + $g_iCustomDonateConfigs
		$g_aiPrepDon[0] = BitOR($g_aiPrepDon[0], ($g_abChkDonateTroop[$i] ? 1 : 0))
		$g_aiPrepDon[1] = BitOR($g_aiPrepDon[1], ($g_abChkDonateAllTroop[$i] ? 1 : 0))
	Next

	; Spells
	$g_aiPrepDon[2] = 0
	$g_aiPrepDon[3] = 0
	For $i = 0 To $eSpellCount - 1
		$g_aiPrepDon[2] = BitOR($g_aiPrepDon[2], ($g_abChkDonateSpell[$i] ? 1 : 0))
		$g_aiPrepDon[3] = BitOR($g_aiPrepDon[3], ($g_abChkDonateAllSpell[$i] ? 1 : 0))
	Next

	; Siege
	$g_aiPrepDon[4] = 0
	$g_aiPrepDon[5] = 0
	For $i = $eSiegeWallWrecker To $eSiegeMachineCount - 1
		$g_aiPrepDon[4] = BitOR($g_aiPrepDon[4], ($g_abChkDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $i] ? 1 : 0))
		$g_aiPrepDon[5] = BitOR($g_aiPrepDon[5], ($g_abChkDonateAllTroop[$eTroopCount + $g_iCustomDonateConfigs + $i] ? 1 : 0))
	Next

	$g_iActiveDonate = BitOR($g_aiPrepDon[0], $g_aiPrepDon[1], $g_aiPrepDon[2], $g_aiPrepDon[3], $g_aiPrepDon[4], $g_aiPrepDon[5])
EndFunc   ;==>PrepareDonateCC

Func IsDonateQueueOnly(ByRef $abDonateQueueOnly)
	If Not $abDonateQueueOnly[0] And Not $abDonateQueueOnly[1] Then Return

	For $i = 0 To $eTroopCount - 1
		$g_aiAvailQueuedTroop[$i] = 0
		If $i < $eSpellCount Then $g_aiAvailQueuedSpell[$i] = 0
	Next
	If Not OpenArmyOverview(True, "IsDonateQueueOnly()") Then Return
	For $i = 0 To 1
		If Not $g_aiPrepDon[$i * 2] And Not $g_aiPrepDon[$i * 2 + 1] Then $abDonateQueueOnly[$i] = False
		If $abDonateQueueOnly[$i] Then
			SetLog("Checking queued " & ($i = 0 ? "troops" : "spells") & " for donation", $COLOR_ACTION)

			If IsQueueEmpty($i = 0 ? "Troops" : "Spells", False, False) Then
				SetLog("2nd army is not prepared. Donate whatever exists in 1st army.")
				$abDonateQueueOnly[$i] = False
				ContinueLoop
			EndIf

			If Not OpenTrainTab($i = 0 ? "Train Troops Tab" : "Brew Spells Tab", True, "IsDonateQueueOnly()") Then ContinueLoop

			Local $xQueue = 775
			For $j = 0 To 10
				If _Sleep(100) Then Return
				$xQueue -= 60.5 * $j
				If _ColorCheck(_GetPixelColor($xQueue, 185 + $g_iMidOffsetY, True), Hex(0xD7AFA9, 6), 20) Then ; Pink background found at $xQueue
					ExitLoop
				ElseIf _ColorCheck(_GetPixelColor($xQueue, 195 + $g_iMidOffsetY, True), Hex(0xCFCFC8, 6), 20) Then ; Gray background
					SetLog("2nd army is not prepared. Donate whatever exists in 1st army!!")
					$abDonateQueueOnly[$i] = False
					ContinueLoop 2
				EndIf
			Next

			If $i = 0 Then
				Local $aSearchResult = CheckQueueTroops(True, False, $xQueue + 10, True) ; $aResult[$Slots][2]: [0] = Name, [1] = Qty
			Else
				Local $aSearchResult = CheckQueueSpells(True, False, $xQueue + 6, True)
			EndIf
			If Not IsArray($aSearchResult) Then ContinueLoop

			For $j = 0 To (UBound($aSearchResult) - 1)
				Local $TroopIndex = TroopIndexLookup($aSearchResult[$j][0], "IsDonateQueueOnly()")
				If $TroopIndex < 0 Then ContinueLoop
				If IsArray(_PixelSearch(($xQueue - 9) - $j * 60.5, 234 + $g_iMidOffsetY, ($xQueue - 5) - $j * 60.5, 234 + $g_iMidOffsetY, Hex(0x96A724, 6), 20, True)) Then ; the green check symbol
					If $i = 0 Then
						If _ArrayIndexValid($g_aiAvailQueuedTroop, $TroopIndex) Then
							$g_aiAvailQueuedTroop[$TroopIndex] += $aSearchResult[$j][1]
							SetLog("  - " & $g_asTroopNames[$TroopIndex] & " x" & $aSearchResult[$j][1])
						EndIf
					Else
						If _ArrayIndexValid($g_aiAvailQueuedSpell, $TroopIndex - $eLSpell) Then
							$g_aiAvailQueuedSpell[$TroopIndex - $eLSpell] += $aSearchResult[$j][1]
							SetLog("  - " & $g_asSpellNames[$TroopIndex - $eLSpell] & " x" & $aSearchResult[$j][1])
						EndIf
					EndIf
				ElseIf $j = 0 Or ($j = 1 And $aSearchResult[1][0] = $aSearchResult[0][0]) Then
					If $i = 0 Then
						If _ArrayIndexValid($g_aiAvailQueuedTroop, $TroopIndex) Then
							$g_aiAvailQueuedTroop[$TroopIndex] += $aSearchResult[$j][1]
							SetLog("  - " & $g_asTroopNames[$TroopIndex] & " x" & $aSearchResult[$j][1] & " (training)")
						EndIf
					Else
						If _ArrayIndexValid($g_aiAvailQueuedSpell, $TroopIndex - $eLSpell) Then
							$g_aiAvailQueuedSpell[$TroopIndex - $eLSpell] += $aSearchResult[$j][1]
							SetLog("  - " & $g_asSpellNames[$TroopIndex - $eLSpell] & " x" & $aSearchResult[$j][1] & " (training)")
						EndIf
					EndIf
					ExitLoop
				ElseIf $j >= 2 Then
					ExitLoop
				EndIf
			Next
			If _Sleep(250) Then ContinueLoop
		EndIf
	Next
	ClickAway()
	If _Sleep($DELAYDONATECC2) Then Return

EndFunc   ;==>IsDonateQueueOnly

Func getArmyRequest($aiDonateCoords, $bNeedCapture = True)
	; Contains iXStart, $iYStart, $iXEnd, $iYEnd
	Local $aiSearchArray[4] = [35, $aiDonateCoords[1] - 90, 350, $aiDonateCoords[1] - 40]
	Local $sRequestDiamond = GetDiamondFromRect($aiSearchArray)
	; Returns $aCurrentRequests[index] = $aArray[2] = ["TroopShortName", CordX,CordY]
	Local $aCurrentArmyRequest = findMultiple(@ScriptDir & "\imgxml\DonateCC\Army", $sRequestDiamond, $sRequestDiamond, 0, 1000, 0, "objectname,objectpoints", $bNeedCapture)

	Local $aTempRequestArray, $iArmyIndex = -1, $sClanText = ""
	If UBound($aCurrentArmyRequest, 1) >= 1 Then
		For $i = 0 To UBound($aCurrentArmyRequest, 1) - 1 ; Loop through found CC Requests
			$aTempRequestArray = $aCurrentArmyRequest[$i] ; Declare Array to Temp Array
			$iArmyIndex = TroopIndexLookup($aTempRequestArray[0], "getArmyRequest()") ; Get the Index of the Troop from the ShortName
			; Troops
			If $iArmyIndex >= $eBarb And $iArmyIndex <= $eAppWard Then
				$sClanText &= ", " & $g_asTroopNames[$iArmyIndex]
				; Spells
			ElseIf $iArmyIndex >= $eLSpell And $iArmyIndex <= $eOgSpell Then
				$sClanText &= ", " & $g_asSpellNames[$iArmyIndex - $eLSpell]
				; Sieges
			ElseIf $iArmyIndex >= $eWallW And $iArmyIndex <= $eBattleD Then
				$sClanText &= ", " & $g_asSiegeMachineNames[$iArmyIndex - $eWallW]
			ElseIf $iArmyIndex = -1 Then
				ContinueLoop
			EndIf
		Next
	EndIf
	Return StringTrimLeft($sClanText, 2)
EndFunc   ;==>getArmyRequest

Func DonateCC($bCheckForNewMsg = False)

	Local $bDonateTroop = ($g_aiPrepDon[0] = 1)
	Local $bDonateAllTroop = ($g_aiPrepDon[1] = 1)

	Local $bDonateSpell = ($g_aiPrepDon[2] = 1)
	Local $bDonateAllSpell = ($g_aiPrepDon[3] = 1)

	Local $bDonateSiege = ($g_aiPrepDon[4] = 1)
	Local $bDonateAllSiege = ($g_aiPrepDon[5] = 1)

	Local $bDonate = ($g_iActiveDonate = 1)

	Local $bOpen = True, $bClose = False

	Local $ReturnT = ($g_CurrentCampUtilization >= ($g_iTotalCampSpace * $g_iTrainArmyFullTroopPct / 100) * .95) ? (True) : (False)

	Local $ClanString = ""

	Local $sNewClanString = ""
	Local $bNewSystemToDonate = False

	If Not $g_bChkDonate Or Not $bDonate Or Not $g_bDonationEnabled Then
		If $g_bDebugSetlog Then SetDebugLog("Donate Clan Castle troops skip", $COLOR_DEBUG)
		Return ; exit func if no donate checkmarks
	EndIf

	Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)

	If Not $g_abDonateHours[$hour[0]] And $g_bDonateHoursEnable Then
		If $g_bDebugSetlog Then SetDebugLog("Donate Clan Castle troops not planned, Skipped..", $COLOR_DEBUG)
		Return ; exit func if no planned donate checkmarks
	EndIf

	;check for new chats first, Every fith time skip this to just check a little bit more frequent
	If ($bCheckForNewMsg And Random(0, 3, 1) < 3) Then
		If Not _ColorCheck(_GetPixelColor(26, 312 + $g_iMidOffsetY, True), Hex(0xf00810, 6), 20) Then Return ;exit if no new chats
	EndIf

	; check if donate queued troops & spells only
	Local $abDonateQueueOnly = $g_abChkDonateQueueOnly
	IsDonateQueueOnly($abDonateQueueOnly)
	If $abDonateQueueOnly[0] And _ArrayMax($g_aiAvailQueuedTroop) = 0 Then
		SetLog("Failed to read queue, skip donating troops")
		$bDonateTroop = False
		$bDonateAllTroop = False
	EndIf
	If $abDonateQueueOnly[1] And _ArrayMax($g_aiAvailQueuedSpell) = 0 Then
		SetLog("Failed to read queue, skip donating spells")
		$bDonateSpell = False
		$bDonateAllSpell = False
	EndIf
	$bDonate = BitOR($bDonateTroop, $bDonateAllTroop, $bDonateSpell, $bDonateAllSpell, $bDonateSiege, $bDonateAllSiege)
	If Not $bDonate Then Return

	;Opens clan tab and verbose in log
	ClickAway()

	If _Sleep(1000) Then Return

	If Not ClickB("ClanChat") Then
		SetLog("Error finding the Clan Tab Button", $COLOR_ERROR)
		Return
	EndIf

	If _Sleep($DELAYDONATECC4) Then Return

	If _ColorCheck(_GetPixelColor(400, 90 + $g_iMidOffsetY, True), Hex(0x4D4B4A, 6), 20) Then
		Click(400, 60 + $g_iMidOffsetY)
		If _Sleep(500) Then Return
	EndIf

	; check for "I Understand" button
	Local $aCoord = decodeSingleCoord(findImage("I Understand", $g_sImgChatIUnterstand, GetDiamondFromRect("50,400,280,550")))
	If UBound($aCoord) > 1 Then
		SetLog('Clicking "I Understand" button', $COLOR_ACTION)
		ClickP($aCoord)
		If _Sleep($DELAYDONATECC2) Then Return
	EndIf

	Local $Scroll
	; add scroll here
	While 1
		ForceCaptureRegion()
		$Scroll = _PixelSearch(348, 64, 352, 78, Hex(0xFFFFFF, 6), 20)
		If IsArray($Scroll) And _ColorCheck(_GetPixelColor(355, 77, True), Hex(0x60A618, 6), 20) Then ; a second pixel for the green
			$bDonate = True
			ClickP($Scroll, 1, 0, "#0172")
			If _Sleep($DELAYDONATECC2 + 100) Then ExitLoop
			ContinueLoop
		EndIf
		ExitLoop
	WEnd

	If $g_iCommandStop <> 0 And $g_iCommandStop <> 3 Then SetLog("Checking for Donate Requests in Clan Chat", $COLOR_INFO)

	Local $iTimer
	Local $sSearchArea, $aiSearchArray[4] = [250, 90, 350, 680], $aiSearchArrayBackUp = $aiSearchArray
	Local $aiDonateButton

	While $bDonate
		$ClanString = ""
		$sNewClanString = ""
		If _Sleep($DELAYDONATECC2) Then ExitLoop

		$iTimer = TimerInit()
		$sSearchArea = GetDiamondFromArray($aiSearchArray)
		$aiDonateButton = decodeSingleCoord(findImage("Donate Button", $g_sImgDonateCC & "DonateButton*", $sSearchArea, 1, True, Default))

		If $g_bDebugSetlog Then SetDebugLog("Get all Buttons in " & StringFormat("%.2f", TimerDiff($iTimer)) & "'ms", $COLOR_DEBUG)
		$iTimer = TimerInit()

		If IsArray($aiDonateButton) And UBound($aiDonateButton, 1) >= 2 Then ; if Donate Button found

			; Collect Donate users images
			If Not donateCCWBLUserImageCollect($aiDonateButton[0], $aiDonateButton[1]) Then
				SetLog("Skip Donation at this Clan Mate", $COLOR_ACTION)
				$aiSearchArray[1] = $aiDonateButton[1] + 20
				ContinueLoop ; go to next button if cant read Castle Troops and Spells before the donate window opens
			EndIf

			;;reset every run
			$bDonate = False
			$g_bSkipDonTroops = False
			$g_bSkipDonSpells = False
			$g_bSkipDonSiege = False

			; Read chat request for DonateTroop and DonateSpell
			If $bDonateTroop Or $bDonateSpell Or $bDonateSiege Then
				; New Donation System
				$sNewClanString = getArmyRequest($aiDonateButton)
				; Reset Var
				$bNewSystemToDonate = False

				If $sNewClanString <> "" Then
					$ClanString = $sNewClanString
					$bNewSystemToDonate = True
				Else
					Local $Alphabets[4] = [$g_bChkExtraAlphabets, $g_bChkExtraChinese, $g_bChkExtraKorean, $g_bChkExtraPersian]
					Local $TextAlphabetsNames[4] = ["Cyrillic and Latin", "Chinese", "Korean", "Persian"]
					Local $AlphabetFunctions[4] = ["getChatString", "getChatStringChinese", "getChatStringKorean", "getChatStringPersian"]
					Local $BlankSpaces = ""
					For $i = 0 To UBound($Alphabets) - 1
						If $i = 0 Then
							; Line 3 to 1
							Local $aCoordinates[3] = [75, 58, 41] ; Extra coordinates for Latin (3 Lines)
							Local $OcrName = ($Alphabets[$i] = True) ? ("coc-latin-cyr") : ("coc-latinA")
							Local $log = "Latin"
							If $Alphabets[$i] Then $log = $TextAlphabetsNames[$i]
							$ClanString = ""
							SetLog("Using OCR to read " & $log & " derived alphabets.", $COLOR_ACTION)
							For $j = 0 To 2
								If $ClanString = "" Or $ClanString = " " Or $BlankSpaces = " " Then
									$ClanString &= $BlankSpaces & getChatString(32, $aiDonateButton[1] - $aCoordinates[$j], $OcrName)
									If $g_bDebugSetlog Then SetDebugLog("$OcrName: " & $OcrName)
									If $g_bDebugSetlog Then SetDebugLog("$aCoordinates: " & $aCoordinates[$j])
									If $g_bDebugSetlog Then SetDebugLog("$ClanString: " & $ClanString)
									; If $ClanString <> "" And $ClanString <> " " Then ExitLoop
								EndIf
								If $ClanString <> "" Then $BlankSpaces = " "
							Next
						Else
							Local $Yaxis[3] = [48, 47, 51] ; "Chinese", "Korean", "Persian"
							If $Alphabets[$i] Then
								If $ClanString = "" Or $ClanString = " " Then
									SetLog("Using OCR to read " & $TextAlphabetsNames[$i] & " alphabets.", $COLOR_ACTION)
									; Ensure used functions are references in "MBR References.au3"
									#Au3Stripper_Off
									$ClanString &= $BlankSpaces & Call($AlphabetFunctions[$i], 32, $aiDonateButton[1] - $Yaxis[$i - 1])
									#Au3Stripper_On
									If @error = 0xDEAD And @extended = 0xBEEF Then SetLog("[DonatCC] Function " & $AlphabetFunctions[$i] & "() had a problem.")
									If $g_bDebugSetlog Then SetDebugLog("$OcrName: " & $OcrName)
									If $g_bDebugSetlog Then SetDebugLog("$Yaxis: " & $Yaxis[$i - 1])
									If $g_bDebugSetlog Then SetDebugLog("$ClanString: " & $ClanString)
									If $ClanString <> "" And $ClanString <> " " Then ExitLoop
								EndIf
							EndIf
						EndIf
					Next

					If $g_bDebugSetlog Then SetDebugLog("Get Request OCR in " & StringFormat("%.2f", TimerDiff($iTimer)) & "'ms", $COLOR_DEBUG)
				EndIf

				$iTimer = TimerInit()

				If $ClanString = "" Or $ClanString = " " Then
					SetLog("Unable to read Chat Request!", $COLOR_ERROR)
					$bDonate = True
					$aiSearchArray[1] = $aiDonateButton[1] + 20
					ContinueLoop
				Else
					If $g_bChkExtraAlphabets Then
						ClipPut($ClanString)
						Local $tempClip = ClipGet()
						SetLog("Chat Request: " & $tempClip)
					Else
						SetLog("Chat Request: " & $ClanString)
					EndIf

					; checking if Chat Request matches any donate keyword. If match, proceed with further steps.
					If Not $bDonateAllTroop And Not $bDonateAllSpell And Not $bDonateAllSiege Then
						Local $Checked = False
						For $i = 0 To UBound($g_abChkDonateTroop) - 1 ; $eTroopCount (20) + $g_iCustomDonateConfigs (4) + $eSiegeMachineCount (2) - 1 = 26 - 1 = 25
							If $g_abChkDonateTroop[$i] Then ; checking Troops, Custom & SiegeMachine
								If $i < $eTroopCount + $g_iCustomDonateConfigs Then ; 0 - 23 (20 troops + 4 combos of custom donate)
									If $g_bDebugSetlog Then SetDebugLog("Troop: [" & $i & "] checking!", $COLOR_DEBUG)
									If CheckDonateTroop($i >= $eTroopCount ? 99 : $i, $g_asTxtDonateTroop[$i], $g_asTxtBlacklistTroop[$i], $ClanString, $bNewSystemToDonate) Then $Checked = True
								Else
									If $g_bDebugSetlog Then SetDebugLog("Siege: [" & $i - $eTroopCount - $g_iCustomDonateConfigs & "] checking!", $COLOR_DEBUG)
									If CheckDonateSiege($i - $eTroopCount - $g_iCustomDonateConfigs, $g_asTxtDonateTroop[$i], $g_asTxtBlacklistTroop[$i], $ClanString, $bNewSystemToDonate) Then $Checked = True
								EndIf
							EndIf
							If Not $Checked And $i < UBound($g_abChkDonateSpell) And $g_abChkDonateSpell[$i] And CheckDonateSpell($i, $g_asTxtDonateSpell[$i], $g_asTxtBlacklistSpell[$i], $ClanString, $bNewSystemToDonate) Then $Checked = True
							If $Checked Then ExitLoop
						Next
						If Not $Checked Then
							SetDebugLog("Chat Request does not match any donate keyword, go to next request")
							$bDonate = True
							$aiSearchArray[1] = $aiDonateButton[1] + 20
							ContinueLoop
						EndIf
						SetDebugLog("Chat Request matches a donate keyword, proceed with donating")
					EndIf
				EndIf
			ElseIf $bDonateAllTroop Or $bDonateAllSpell Or $bDonateAllSiege Then
				SetLog("Skip reading chat requests. Donate all is enabled!", $COLOR_ACTION)
			EndIf

			;;; Get remaining CC capacity of requested troops from your ClanMates
			RemainingCCcapacity($aiDonateButton)
			If $g_bDebugSetlog Then SetDebugLog("Get remaining CC capacity in " & StringFormat("%.2f", TimerDiff($iTimer)) & "'ms", $COLOR_DEBUG)
			$iTimer = TimerInit()

			;;; Donate Filter
			If $g_iTotalDonateTroopCapacity <= 0 Then
				SetLog("Clan Castle troops are full, skip troop donation", $COLOR_ACTION)
				$g_bSkipDonTroops = True
			EndIf
			If $g_iCurrentSpells = 0 And $g_iCurrentSpells <> "" Then
				SetLog("No spells available, skip spell donation...", $COLOR_OLIVE)
				$g_bSkipDonSpells = True
			ElseIf $g_iTotalDonateSpellCapacity = 0 Then
				SetLog("Clan Castle spells are full, skip spell donation...", $COLOR_ACTION)
				$g_bSkipDonSpells = True
			ElseIf $g_iTotalDonateSpellCapacity = -1 Then
				; no message, this CC has no Spell capability
				If $g_bDebugSetlog Then SetDebugLog("This CC cannot accept spells, skip spell donation", $COLOR_DEBUG)
				$g_bSkipDonSpells = True
			EndIf

			If Not $bDonateSiege And Not $bDonateAllSiege Then
				SetLog("Siege donation is not enabled, skip siege donation", $COLOR_ACTION)
				$g_bSkipDonSiege = True
			ElseIf $g_aiCurrentSiegeMachines[$eSiegeWallWrecker] = 0 And $g_aiCurrentSiegeMachines[$eSiegeBattleBlimp] = 0 And $g_aiCurrentSiegeMachines[$eSiegeStoneSlammer] = 0 And $g_aiCurrentSiegeMachines[$eSiegeBarracks] = 0 And $g_aiCurrentSiegeMachines[$eSiegeLogLauncher] = 0 And $g_aiCurrentSiegeMachines[$eSiegeFlameFlinger] = 0 And $g_aiCurrentSiegeMachines[$eSiegeBattleDrill] = 0 Then
				SetLog("No siege machines available, skip siege donation", $COLOR_OLIVE)
				$g_bSkipDonSiege = True
			ElseIf $g_iTotalDonateSiegeMachineCapacity = -1 Then
				SetLog("This CC cannot accept Siege, skip Siege donation", $COLOR_ACTION)
				$g_bSkipDonSiege = True
			ElseIf $g_iTotalDonateSiegeMachineCapacity = 0 Then
				SetLog("Clan Castle Siege is full, skip Siege donation", $COLOR_ACTION)
				$g_bSkipDonSiege = True
			EndIf

			;;; Flagged to Skip Check
			If $g_bSkipDonTroops And $g_bSkipDonSpells And $g_bSkipDonSiege Then
				$bDonate = True
				$aiSearchArray[1] += 50
				ContinueLoop ; go to next button if cant read Castle Troops and Spells before the donate window opens
			EndIf

			;;; Open Donate Window
			If _Sleep($DELAYDONATECC3) Then Return
			If Not DonateWindow($aiDonateButton, $bOpen) Then
				$bDonate = True
				$aiSearchArray[1] = $aiDonateButton[1] + 20
				SetLog("Donate Window did not open - Exiting Donate", $COLOR_ERROR)
				ExitLoop ; Leave donate to prevent a bot hang condition
			EndIf

			;;; Variables to use in Loops for Custom.A to Custom.B
			Local $eCustom[2] = [$eCustomA, $eCustomB]
			Local $eDonateCustom[2] = [$g_aiDonateCustomTrpNumA, $g_aiDonateCustomTrpNumB]

			;;; Typical Donation
			If $bDonateTroop Or $bDonateSpell Or $bDonateSiege Then
				If $g_bDebugSetlog Then SetDebugLog("Troop/Spell/Siege checkpoint.", $COLOR_DEBUG)

				; read available donate cap, and ByRef set the $g_bSkipDonTroops and $g_bSkipDonSpells flags
				DonateWindowCap($g_bSkipDonTroops, $g_bSkipDonSpells)
				If $g_bDebugSetlog Then SetDebugLog("Get available donate cap in " & StringFormat("%.2f", TimerDiff($iTimer)) & "'ms", $COLOR_DEBUG)
				$iTimer = TimerInit()
				If $g_bSkipDonTroops And $g_bSkipDonSpells And $g_bSkipDonSiege Then
					DonateWindow($aiDonateButton, $bClose)
					$bDonate = True
					$aiSearchArray[1] = $aiDonateButton[1] + 20
					If _Sleep($DELAYDONATECC2) Then ExitLoop
					ContinueLoop ; go to next button if already donated, maybe this is an impossible case..
				EndIf

				;;;  DONATION TROOPS
				If $bDonateTroop And Not $g_bSkipDonTroops Then
					If $g_bDebugSetlog Then SetDebugLog("Troop checkpoint.", $COLOR_DEBUG)

					;;;  Custom Combination Troops
					For $x = 0 To UBound($eDonateCustom) - 1
						If $g_abChkDonateTroop[$eCustom[$x]] And CheckDonateTroop(99, $g_asTxtDonateTroop[$eCustom[$x]], $g_asTxtBlacklistTroop[$eCustom[$x]], $ClanString, $bNewSystemToDonate) Then
							Local $CorrectDonateCustom = $eDonateCustom[$x]

							For $i = 0 To 2
								If $CorrectDonateCustom[$i][0] < $eBarb Then
									$CorrectDonateCustom[$i][0] = $eArch ; Change strange small numbers to archer
								ElseIf $CorrectDonateCustom[$i][0] > $eAppWard Then
									ContinueLoop ; If "Nothing" is selected then continue
								EndIf
								If $CorrectDonateCustom[$i][1] < 1 Then
									ContinueLoop ; If donate number is smaller than 1 then continue
								ElseIf $CorrectDonateCustom[$i][1] > 8 Then
									$CorrectDonateCustom[$i][1] = 8 ; Number larger than 8 is unnecessary
								EndIf
								DonateTroopType($CorrectDonateCustom[$i][0], $CorrectDonateCustom[$i][1], $abDonateQueueOnly[0])
								If _Sleep($DELAYDONATECC3) Then ExitLoop
							Next
						EndIf
					Next

					;;;  Typical Donate troops
					If Not $g_bSkipDonTroops Then
						For $i = 0 To UBound($g_aiDonateTroopPriority) - 1
							Local $iTroopIndex = $g_aiDonateTroopPriority[$i]
							If $g_abChkDonateTroop[$iTroopIndex] Then
								If CheckDonateTroop($iTroopIndex, $g_asTxtDonateTroop[$iTroopIndex], $g_asTxtBlacklistTroop[$iTroopIndex], $ClanString, $bNewSystemToDonate) Then
									DonateTroopType($iTroopIndex, 0, $abDonateQueueOnly[0])
									If _Sleep($DELAYDONATECC3) Then ExitLoop
								EndIf
							EndIf
						Next
					EndIf
					If $g_bDebugSetlog Then SetDebugLog("Get Donated troops in " & StringFormat("%.2f", TimerDiff($iTimer)) & "'ms", $COLOR_DEBUG)
					$iTimer = TimerInit()

				EndIf

				;;; DONATE SIEGE
				If Not $g_bSkipDonSiege And $bDonateSiege Then
					If $g_bDebugSetlog Then SetDebugLog("Siege checkpoint.", $COLOR_DEBUG)
					For $SiegeIndex = $eSiegeWallWrecker To $eSiegeMachineCount - 1
						; $eTroopCount - 1 + $g_iCustomDonateConfigs + $i
						Local $index = $eTroopCount + $g_iCustomDonateConfigs + $SiegeIndex
						If $g_abChkDonateTroop[$index] Then
							If CheckDonateSiege($SiegeIndex, $g_asTxtDonateTroop[$index], $g_asTxtBlacklistTroop[$index], $ClanString, $bNewSystemToDonate) Then
								DonateSiegeType($SiegeIndex)
							EndIf
						EndIf
					Next

				EndIf

				;;; DONATION SPELLS
				If $bDonateSpell And Not $g_bSkipDonSpells Then
					SetDebugLog("Spell checkpoint.", $COLOR_DEBUG)

					For $i = 0 To UBound($g_aiDonateSpellPriority) - 1
						Local $iSpellIndex = $g_aiDonateSpellPriority[$i]
						If $g_abChkDonateSpell[$iSpellIndex] Then
							If CheckDonateSpell($iSpellIndex, $g_asTxtDonateSpell[$iSpellIndex], $g_asTxtBlacklistSpell[$iSpellIndex], $ClanString, $bNewSystemToDonate) Then
								DonateSpellType($iSpellIndex, $abDonateQueueOnly[1])
								If _Sleep($DELAYDONATECC3) Then ExitLoop
							EndIf
						EndIf
					Next
					If $g_bDebugSetlog Then SetDebugLog("Get Donated Spells in " & StringFormat("%.2f", TimerDiff($iTimer)) & "'ms", $COLOR_DEBUG)
					$iTimer = TimerInit()
				EndIf
			EndIf

			;;; Donate to All Zone
			If $bDonateAllTroop Or $bDonateAllSpell Or $bDonateAllSiege Then
				If $g_bDebugSetlog Then SetDebugLog("Troop/Spell/Siege All checkpoint.", $COLOR_DEBUG) ;Debug
				$g_bDonateAllRespectBlk = True

				If $bDonateAllTroop And Not $g_bSkipDonTroops Then
					; read available donate cap, and ByRef set the $g_bSkipDonTroops and $g_bSkipDonSpells flags
					DonateWindowCap($g_bSkipDonTroops, $g_bSkipDonSpells)
					Setlog("Get available donate cap (to all) in " & StringFormat("%.2f", TimerDiff($iTimer)) & "'ms", $COLOR_DEBUG)
					$iTimer = TimerInit()
					If $g_bSkipDonTroops And $g_bSkipDonSpells Then
						DonateWindow($aiDonateButton, $bClose)
						$bDonate = True
						$aiSearchArray[1] = $aiDonateButton[1] + 20
						If _Sleep($DELAYDONATECC2) Then ExitLoop
						ContinueLoop ; go to next button if already donated, maybe this is an impossible case..
					EndIf
					If $g_bDebugSetlog Then SetDebugLog("Troop All checkpoint.", $COLOR_DEBUG)

					;;; DONATE TO ALL for Custom And Typical Donation
					; 0 to 1 is Custom [A to B] and the 2 is the 'Typical'
					For $x = 0 To 2
						If $x <> 2 Then
							If $g_abChkDonateAllTroop[$eCustom[$x]] Then
								Local $CorrectDonateCustom = $eDonateCustom[$x]
								For $i = 0 To 2
									If $CorrectDonateCustom[$i][0] < $eBarb Then
										$CorrectDonateCustom[$i][0] = $eArch ; Change strange small numbers to archer
									ElseIf $CorrectDonateCustom[$i][0] > $eAppWard Then
										DonateWindow($aiDonateButton, $bClose)
										$bDonate = True
										$aiSearchArray[1] = $aiDonateButton[1] + 20
										If _Sleep($DELAYDONATECC2) Then ExitLoop
										ContinueLoop ; If "Nothing" is selected then continue
									EndIf
									If $CorrectDonateCustom[$i][1] < 1 Then
										DonateWindow($aiDonateButton, $bClose)
										$bDonate = True
										$aiSearchArray[1] = $aiDonateButton[1] + 20
										If _Sleep($DELAYDONATECC2) Then ExitLoop
										ContinueLoop ; If donate number is smaller than 1 then continue
									ElseIf $CorrectDonateCustom[$i][1] > 8 Then
										$CorrectDonateCustom[$i][1] = 8 ; Number larger than 8 is unnecessary
									EndIf
									DonateTroopType($CorrectDonateCustom[$i][0], $CorrectDonateCustom[$i][1], $abDonateQueueOnly[0], $bDonateAllTroop) ;;; Donate Custom Troop using DonateTroopType2
								Next
							EndIf
						Else ; this is the $x = 2 [Typical Donation]
							For $i = 0 To UBound($g_aiDonateTroopPriority) - 1
								Local $iTroopIndex = $g_aiDonateTroopPriority[$i]
								If $g_abChkDonateAllTroop[$iTroopIndex] Then
									If CheckDonateTroop($iTroopIndex, $g_asTxtDonateTroop[$iTroopIndex], $g_asTxtBlacklistTroop[$iTroopIndex], $ClanString, $bNewSystemToDonate) Then
										DonateTroopType($iTroopIndex, 0, $abDonateQueueOnly[0], $bDonateAllTroop)
									EndIf
									ExitLoop
								EndIf
							Next
						EndIf
					Next
					If $g_bDebugSetlog Then SetDebugLog("Get Donated troops (to all) in " & StringFormat("%.2f", TimerDiff($iTimer)) & "'ms", $COLOR_DEBUG)
					$iTimer = TimerInit()
				EndIf

				If $bDonateAllSpell And Not $g_bSkipDonSpells Then
					If $g_bDebugSetlog Then SetDebugLog("Spell All checkpoint.", $COLOR_DEBUG)

					For $i = 0 To UBound($g_aiDonateSpellPriority) - 1
						Local $iSpellIndex = $g_aiDonateSpellPriority[$i]
						If $g_abChkDonateAllSpell[$iSpellIndex] Then
							If CheckDonateSpell($iSpellIndex, $g_asTxtDonateSpell[$iSpellIndex], $g_asTxtBlacklistSpell[$iSpellIndex], $ClanString, $bNewSystemToDonate) Then
								DonateSpellType($iSpellIndex, $abDonateQueueOnly[1], $bDonateAllSpell)
							EndIf
							ExitLoop
						EndIf
					Next
					If $g_bDebugSetlog Then SetDebugLog("Get Donated Spells (to all)  in " & StringFormat("%.2f", TimerDiff($iTimer)) & "'ms", $COLOR_DEBUG)
					$iTimer = TimerInit()
				EndIf

				;Siege
				If $bDonateAllSiege And Not $g_bSkipDonSiege Then
					If $g_bDebugSetlog Then SetDebugLog("Siege All checkpoint.", $COLOR_DEBUG)

					For $SiegeIndex = $eSiegeWallWrecker To $eSiegeMachineCount - 1
						Local $index = $eTroopCount + $g_iCustomDonateConfigs + $SiegeIndex
						If $g_abChkDonateAllTroop[$index] Then
							If CheckDonateSiege($SiegeIndex, $g_asTxtDonateTroop[$index], $g_asTxtBlacklistTroop[$index], $ClanString, $bNewSystemToDonate) Then
								DonateSiegeType($SiegeIndex, True)
							EndIf
							ExitLoop
						EndIf
					Next
					If $g_bDebugSetlog Then SetDebugLog("Get Donated Sieges (to all)  in " & StringFormat("%.2f", TimerDiff($iTimer)) & "'ms", $COLOR_DEBUG)
					$iTimer = TimerInit()
				EndIf

				$g_bDonateAllRespectBlk = False
			EndIf

			$bDonate = True
			$aiSearchArray[1] = $aiDonateButton[1] + 20

			If _Sleep($DELAYDONATEWINDOW1) Then ExitLoop
			If _ColorCheck(_GetPixelColor($aiDonateButton[0] + 82, $aiDonateButton[1], True), Hex(0xFFFFFF, 6), 10) Then CloseWindow2()
			If _Sleep($DELAYDONATEWINDOW1) Then ExitLoop

		EndIf

		$sSearchArea = GetDiamondFromArray($aiSearchArray)
		$aiDonateButton = decodeSingleCoord(findImage("Donate Button", $g_sImgDonateCC & "DonateButton*", $sSearchArea, 1, True, Default))

		If $g_bDebugSetlog Then SetDebugLog("Get more donate buttons in " & StringFormat("%.2f", TimerDiff($iTimer)) & "'ms", $COLOR_DEBUG)

		If IsArray($aiDonateButton) And UBound($aiDonateButton, 1) >= 2 Then
			If $g_bDebugSetlog Then SetDebugLog("More Donate buttons found, new $aiDonateButton: (" & $aiDonateButton[0] & "," & $aiDonateButton[1] & ")", $COLOR_DEBUG)
			If _Sleep($DELAYDONATECC2) Then ExitLoop
			ContinueLoop
		Else
			If $g_bDebugSetlog Then SetDebugLog("No more Donate buttons found, closing chat", $COLOR_DEBUG)
		EndIf

		;;; Scroll Down
		ForceCaptureRegion()
		$Scroll = _PixelSearch(348, 587 + $g_iBottomOffsetY, 352, 601 + $g_iBottomOffsetY, Hex(0xFFFFFF, 6), 20)
		If IsArray($Scroll) Then
			$bDonate = True
			ClickP($Scroll, 1, 0, "#0172")
			$aiSearchArray = $aiSearchArrayBackUp
			If _Sleep($DELAYDONATECC2) Then ExitLoop
			ContinueLoop
		EndIf
		$bDonate = False
	WEnd

	ClickAway("Right")
	If _Sleep(1000) Then Return

	If Not ClickB("ClanChat") Then
		SetLog("Error finding the Clan Tab Button", $COLOR_ERROR)
		AndroidPageError("DonateCC")
	EndIf

	UpdateStats()
	If _Sleep($DELAYDONATECC2) Then Return
EndFunc   ;==>DonateCC

Func CheckDonateTroop(Const $iTroopIndex, Const $sDonateTroopString, Const $sBlacklistTroopString, Const $sClanString, $bNewSystemDonate = False)
	Local $sName = ($iTroopIndex = 99 ? "Custom" : $g_asTroopNames[$iTroopIndex])
	Return CheckDonate($sName, $bNewSystemDonate = True ? $sName : $sDonateTroopString, $sBlacklistTroopString, $sClanString)
EndFunc   ;==>CheckDonateTroop

Func CheckDonateSpell(Const $iSpellIndex, Const $sDonateSpellString, Const $sBlacklistSpellString, Const $sClanString, $bNewSystemDonate = False)
	Local $sName = $g_asSpellNames[$iSpellIndex]
	Return CheckDonate($sName, $bNewSystemDonate = True ? $sName : $sDonateSpellString, $sBlacklistSpellString, $sClanString)
EndFunc   ;==>CheckDonateSpell

Func CheckDonateSiege(Const $iSiegeIndex, Const $sDonateSpellString, Const $sBlacklistSpellString, Const $sClanString, $bNewSystemDonate = False)
	Local $sName = $g_asSiegeMachineNames[$iSiegeIndex]
	Return CheckDonate($sName, $bNewSystemDonate = True ? $sName : $sDonateSpellString, $sBlacklistSpellString, $sClanString)
EndFunc   ;==>CheckDonateSiege

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

	If Not $g_bDonateAllRespectBlk Then
		For $i = 1 To UBound($asSplitDonate) - 1
			If CheckDonateString($asSplitDonate[$i], $sClanString) Then
				SetLog($sName & " Keyword found: " & $asSplitDonate[$i], $COLOR_SUCCESS)
				Return True
			EndIf
		Next
	EndIf

	If $g_bDonateAllRespectBlk Then Return True

	If $g_bDebugSetlog Then SetDebugLog("Bad call of CheckDonateTroop: " & $sName, $COLOR_DEBUG)
	Return False
EndFunc   ;==>CheckDonate

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

Func DonateTroopType(Const $iTroopIndex, $Quant = 0, Const $bDonateQueueOnly = False, Const $bDonateAll = False)
	Local $DonatedTroopCount = 0
	Local $Slot = -1, $detectedSlot = -1
	Local $YComp = 0, $donaterow = -1
	Local $donateposinrow = -1
	Local $sTextToAll = ""
	Local $XWindowOffset = 0

	If $g_iTotalDonateTroopCapacity = 0 Then Return
	If $g_bDebugSetlog Then SetDebugLog("$DonateTroopType Start: " & $g_asTroopNames[$iTroopIndex], $COLOR_DEBUG)

	; Space to donate troop?
	$g_iDonTroopsQuantityAv = Floor($g_iTotalDonateTroopCapacity / $g_aiTroopSpace[$iTroopIndex])
	If $g_iDonTroopsQuantityAv < 1 Then
		SetLog("Sorry Chief! " & $g_asTroopNamesPlural[$iTroopIndex] & " don't fit in the remaining space!")
		Return
	EndIf

	Local $g_iDonTroopsLimitClan = getOcrAndCapture("coc-t-lim", 470, $g_iDonationWindowY + 15, 16, 14, True)
	If $g_iDonTroopsLimitClan = "" Then
		$XWindowOffset = 37
		getOcrAndCapture("coc-t-lim", 470 + $XWindowOffset, $g_iDonationWindowY + 15, 16, 14, True)
	EndIf
	If $g_iDonTroopsLimitClan <> "" And Number($g_iDonTroopsLimitClan) <> Number($g_iDonTroopsLimit) Then $g_iDonTroopsLimit = $g_iDonTroopsLimitClan

	If $Quant = 0 Or $Quant > _Min(Number($g_iDonTroopsQuantityAv), Number($g_iDonTroopsLimit)) Then $Quant = _Min(Number($g_iDonTroopsQuantityAv), Number($g_iDonTroopsLimit))
	If $bDonateQueueOnly Then
		If $g_aiAvailQueuedTroop[$iTroopIndex] <= 0 Then
			SetLog("Sorry Chief! " & $g_asTroopNames[$iTroopIndex] & " is not ready in queue for donation!")
			Return
		ElseIf $g_aiAvailQueuedTroop[$iTroopIndex] < $Quant Then
			SetLog("Queue available for donation: " & $g_aiAvailQueuedTroop[$iTroopIndex] & "x " & $g_asTroopNames[$iTroopIndex])
			$Quant = $g_aiAvailQueuedTroop[$iTroopIndex]
		EndIf
	EndIf

	; Detect the Troops Slot
	If $g_bDebugOCRdonate Then
		Local $oldDebugOcr = $g_bDebugOcr
		$g_bDebugOcr = True
	EndIf

	$Slot = DetectSlotTroop($iTroopIndex, $XWindowOffset)
	$detectedSlot = $Slot
	If $g_bDebugOCRdonate Then $g_bDebugOcr = $oldDebugOcr

	; figure out row/position
	If $Slot < 0 Or $Slot > 13 Then
		SetLog("Invalid slot # found = " & $Slot & " for " & $g_asTroopNames[$iTroopIndex], $COLOR_ERROR)
		Return
	EndIf
	If $g_bDebugSetlog Then SetDebugLog("slot found = " & $Slot & ", " & $g_asTroopNames[$iTroopIndex], $COLOR_DEBUG)
	$donaterow = 1 ;first row of troops
	$donateposinrow = $Slot
	If $Slot >= 7 And $Slot <= 13 Then
		$donaterow = 2 ;second row of troops
		$Slot = $Slot - 7
		$donateposinrow = $Slot
		$YComp = 88 ; correct 860x780
	EndIf

	; Verify if the type of troop to donate exists
	SetLog("Troops Condition Matched", $COLOR_OLIVE)
	If _ColorCheck(_GetPixelColor(370 + $XWindowOffset + ($Slot * 68), $g_iDonationWindowY + 105 + $YComp, True), Hex(0x4079B8, 6), 20) Or _
			_ColorCheck(_GetPixelColor(375 + $XWindowOffset + ($Slot * 68), $g_iDonationWindowY + 106 + $YComp, True), Hex(0x4079B8, 6), 20) Or _
			_ColorCheck(_GetPixelColor(380 + $XWindowOffset + ($Slot * 68), $g_iDonationWindowY + 107 + $YComp, True), Hex(0x4079B8, 6), 20) Or _ ; check for 'blue'
			_ColorCheck(_GetPixelColor(370 + $XWindowOffset + ($Slot * 68), $g_iDonationWindowY + 105 + $YComp, True), Hex(0x810D0E, 6), 20) Or _
			_ColorCheck(_GetPixelColor(375 + $XWindowOffset + ($Slot * 68), $g_iDonationWindowY + 106 + $YComp, True), Hex(0x810D0E, 6), 20) Or _
			_ColorCheck(_GetPixelColor(380 + $XWindowOffset + ($Slot * 68), $g_iDonationWindowY + 107 + $YComp, True), Hex(0x810D0E, 6), 20) Then ; check for 'STroups Red'

		Local $RemainingTroopsToDonate = getOcrAndCapture("coc-t-d", 381 + $XWindowOffset + ($Slot * 68), $g_iDonationWindowY + 98 + $YComp, 35, 14, True)
		If Number($RemainingTroopsToDonate) < $Quant Then $Quant = Number($RemainingTroopsToDonate)

		If $bDonateAll Then $sTextToAll = " (to all requests)"
		SetLog("Donating " & $Quant & " " & ($Quant > 1 ? $g_asTroopNamesPlural[$iTroopIndex] : $g_asTroopNames[$iTroopIndex]) & $sTextToAll, $COLOR_SUCCESS)

		If $g_bDebugOCRdonate Then
			SetLog("donate", $COLOR_ERROR)
			SetLog("row: " & $donaterow, $COLOR_ERROR)
			SetLog("pos in row: " & $donateposinrow, $COLOR_ERROR)
			SetLog("coordinate: " & 385 + $XWindowOffset + ($Slot * 68) & "," & $g_iDonationWindowY + 70 + $YComp, $COLOR_ERROR)
			SaveDebugImage("LiveDonateCC-r" & $donaterow & "-c" & $donateposinrow & "-" & $g_asTroopNames[$iTroopIndex] & "_")
		EndIf

		If _ColorCheck(_GetPixelColor(370 + $XWindowOffset + ($Slot * 68), $g_iDonationWindowY + 105 + $YComp, True), Hex(0x4079B8, 6), 20) Or _
				_ColorCheck(_GetPixelColor(375 + $XWindowOffset + ($Slot * 68), $g_iDonationWindowY + 106 + $YComp, True), Hex(0x4079B8, 6), 20) Or _
				_ColorCheck(_GetPixelColor(380 + $XWindowOffset + ($Slot * 68), $g_iDonationWindowY + 107 + $YComp, True), Hex(0x4079B8, 6), 20) Or _ ; check for 'blue'
				_ColorCheck(_GetPixelColor(370 + $XWindowOffset + ($Slot * 68), $g_iDonationWindowY + 105 + $YComp, True), Hex(0x810D0E, 6), 20) Or _
				_ColorCheck(_GetPixelColor(375 + $XWindowOffset + ($Slot * 68), $g_iDonationWindowY + 106 + $YComp, True), Hex(0x810D0E, 6), 20) Or _
				_ColorCheck(_GetPixelColor(380 + $XWindowOffset + ($Slot * 68), $g_iDonationWindowY + 107 + $YComp, True), Hex(0x810D0E, 6), 20) Then ; check for 'STroups Red'
			Click(398 + $XWindowOffset + ($Slot * 68), $g_iDonationWindowY + 70 + $YComp, $Quant, $DELAYDONATECC1, "#0175")
			$DonatedTroopCount += 1
			$g_aiDonateStatsTroops[$iTroopIndex][0] += $Quant
			If $g_iCommandStop = 3 Then
				$g_iCommandStop = 0
				$g_bFullArmy = False
			EndIf
		EndIf

		; Adjust Values for donated troops to prevent a Double ghost donate to stats and train
		If $iTroopIndex >= $eTroopBarbarian And $iTroopIndex <= $eTroopAppWard Then
			;Reduce iTotalDonateCapacity by troops donated
			$g_iTotalDonateTroopCapacity -= ($Quant * $g_aiTroopSpace[$iTroopIndex])
			;If donated max allowed troop qty set $g_bSkipDonTroops = True
			If $g_iDonTroopsLimit = $Quant Then
				$g_bSkipDonTroops = True
			EndIf
		EndIf

		; Assign the donated quantity troops to train : $Don $g_asTroopName
		$g_aiDonateTroops[$iTroopIndex] += $Quant
		If $bDonateQueueOnly Then $g_aiAvailQueuedTroop[$iTroopIndex] -= $Quant
	Else
		Local $Text = "Unable to donate " & ($g_iDonTroopsQuantity > 1 ? $g_asTroopNamesPlural[$iTroopIndex] : $g_asTroopNames[$iTroopIndex]) & ".Donate screen not visible, will retry next run.", $LocalColor = $COLOR_ERROR
		If _ColorCheck(_GetPixelColor(375 + $XWindowOffset + ($Slot * 68), $g_iDonationWindowY + 105 + $YComp, True), Hex(0x606060, 6), 10) Or _       ; Dark Gray from Queued Spells
				_ColorCheck(_GetPixelColor(375 + $XWindowOffset + ($Slot * 68), $g_iDonationWindowY + 105 + $YComp, True), Hex(0xDADAD5, 6), 10) Then ; Light Gray from Empty Slots
			$Text = "No " & ($g_iDonTroopsQuantity > 1 ? $g_asTroopNamesPlural[$iTroopIndex] : $g_asTroopNames[$iTroopIndex]) & " available to donate.."
			$LocalColor = $COLOR_INFO
		EndIf
		SetLog($Text, $LocalColor)
	EndIf

EndFunc   ;==>DonateTroopType

Func DonateSpellType(Const $iSpellIndex, Const $bDonateQueueOnly = False, Const $bDonateAll = False)
	Local $DonatedSpell = 0
	Local $Slot = -1, $detectedSlot = -1
	Local $YComp = 0, $donaterow = -1
	Local $donateposinrow = -1
	;Local $sTextToAll = ""

	If $g_iTotalDonateSpellCapacity = 0 Then Return
	If $g_bDebugSetlog Then SetDebugLog("DonateSpellType Start: " & $g_asSpellNames[$iSpellIndex], $COLOR_DEBUG)

	; Space to donate spell?
	$g_iDonSpellsQuantityAv = Floor($g_iTotalDonateSpellCapacity / $g_aiSpellSpace[$iSpellIndex])
	If $g_iDonSpellsQuantityAv < 1 Then
		SetLog("Sorry Chief! " & $g_asSpellNames[$iSpellIndex] & " spells don't fit in the remaining space!")
		Return
	EndIf

	If $g_iDonSpellsQuantityAv >= $iDonSpellsLimit Then
		$g_iDonSpellsQuantity = $iDonSpellsLimit
	Else
		$g_iDonSpellsQuantity = $g_iDonSpellsQuantityAv
	EndIf

	If $bDonateQueueOnly And $g_aiAvailQueuedSpell[$iSpellIndex] = 0 Then
		SetLog("Sorry Chief! " & $g_asSpellNames[$iSpellIndex] & " is not ready in queue for donation!")
		Return
	EndIf

	; Detect the Spells Slot
	If $g_bDebugOCRdonate Then
		Local $oldDebugOcr = $g_bDebugOcr
		$g_bDebugOcr = True
	EndIf

	$Slot = DetectSlotSpell($iSpellIndex)
	$detectedSlot = $Slot
	If $g_bDebugSetlog Then SetDebugLog("slot found = " & $Slot, $COLOR_DEBUG)
	If $g_bDebugOCRdonate Then $g_bDebugOcr = $oldDebugOcr

	If $Slot = -1 Then Return

	; figure out row/position
	If $Slot < 14 Or $Slot > 20 Then
		SetLog("Invalid slot # found = " & $Slot & " for " & $g_asSpellNames[$iSpellIndex], $COLOR_ERROR)
		Return
	EndIf
	$donaterow = 3 ;row of spells
	$Slot = $Slot - 14
	$donateposinrow = $Slot
	$YComp = 203 ; correct 860x780

	SetLog("Spells Condition Matched", $COLOR_OLIVE)
	If _ColorCheck(_GetPixelColor(370 + ($Slot * 68), $g_iDonationWindowY + 105 + $YComp, True), Hex(0x6F47C1, 6), 20) Or _
			_ColorCheck(_GetPixelColor(375 + ($Slot * 68), $g_iDonationWindowY + 106 + $YComp, True), Hex(0x6F47C1, 6), 20) Or _
			_ColorCheck(_GetPixelColor(380 + ($Slot * 68), $g_iDonationWindowY + 107 + $YComp, True), Hex(0x6F47C1, 6), 20) Then ; check for 'purple'

		If $g_bDebugOCRdonate Then
			SetLog("donate", $COLOR_ERROR)
			SetLog("row: " & $donaterow, $COLOR_ERROR)
			SetLog("pos in row: " & $donateposinrow, $COLOR_ERROR)
			SetLog("coordinate: " & 385 + ($Slot * 68) & "," & $g_iDonationWindowY + 100 + $YComp, $COLOR_ERROR)
			SaveDebugImage("LiveDonateCC-r" & $donaterow & "-c" & $donateposinrow & "-" & $g_asSpellNames[$iSpellIndex] & "_")
		EndIf
		If Not $g_bDebugOCRdonate Then
			Click(398 + ($Slot * 68), $g_iDonationWindowY + 70 + $YComp, $g_iDonSpellsQuantity, $DELAYDONATECC3, "#0600")
			$DonatedSpell += 1

			$g_bFullArmySpells = False
			$g_bFullArmy = False
			$g_aiDonateSpells[$iSpellIndex] += 1
			If $bDonateQueueOnly Then $g_aiAvailQueuedTroop[$iSpellIndex] -= 1
			If $g_iCommandStop = 3 Then
				$g_iCommandStop = 0
				$g_bFullArmySpells = False
			EndIf
			$g_aiDonateStatsSpells[$iSpellIndex][0] += $g_iDonSpellsQuantity
		EndIf

		SetLog("Donating " & $g_iDonSpellsQuantity & " " & $g_asSpellNames[$iSpellIndex] & " Spell.", $COLOR_GREEN)

		; Assign the donated quantity Spells to train : $Don $g_asSpellName
		; need to implement assign $DonPoison etc later
	Else
		Local $Text = "Unable to donate " & $g_asSpellNames[$iSpellIndex] & ".Donate screen not visible, will retry next run.", $LocalColor = $COLOR_ERROR
		If _ColorCheck(_GetPixelColor(375 + ($Slot * 68), $g_iDonationWindowY + 105 + $YComp, True), Hex(0x606060, 6), 10) Or _       ; Dark Gray from Queued Spells
				_ColorCheck(_GetPixelColor(375 + ($Slot * 68), $g_iDonationWindowY + 105 + $YComp, True), Hex(0XDADAD5, 6), 10) Then ; Light Gray from Empty Slots
			$Text = "No " & $g_asSpellNames[$iSpellIndex] & " available to donate.."
			$LocalColor = $COLOR_INFO
		EndIf
		SetLog($Text, $LocalColor)
	EndIf

EndFunc   ;==>DonateSpellType

Func DonateSiegeType(Const $iSiegeIndex, $bDonateAll = False)
	Local $DonatedSiege = 0
	Local $Slot = -1, $detectedSlot = -1
	Local $YComp = 0, $donaterow = -1
	Local $donateposinrow = -1
	Local $sTextToAll = ""

	If $g_iTotalDonateSiegeMachineCapacity < 1 Then Return
	If $g_bDebugSetlog Then SetDebugLog("DonateSiegeType Start: " & $g_asSiegeMachineNames[$iSiegeIndex], $COLOR_DEBUG)

	$Slot = DetectSlotSiege($iSiegeIndex)
	If $Slot = -1 Then
		SetLog("No " & $g_asSiegeMachineNames[$iSiegeIndex] & " available to donate..", $COLOR_ERROR)
		Return
	EndIf

	; figure out row/position
	If $Slot < 0 Or $Slot > 13 Then
		SetLog("Invalid slot # found = " & $Slot & " for " & $g_asSiegeMachineNames[$iSiegeIndex], $COLOR_ERROR)
		Return
	EndIf

	If $g_bDebugSetlog Then SetDebugLog("slot found = " & $Slot & ", " & $g_asSiegeMachineNames[$iSiegeIndex], $COLOR_DEBUG)
	$donaterow = 1 ;first row of troops
	$donateposinrow = $Slot
	If $Slot >= 7 And $Slot <= 13 Then
		$donaterow = 2 ;second row of troops
		$Slot = $Slot - 7
		$donateposinrow = $Slot
		$YComp = 88 ; correct 860x780
	EndIf

	If $g_bDebugOCRdonate Then
		SetLog("donate", $COLOR_ERROR)
		SetLog("row: " & $donaterow, $COLOR_ERROR)
		SetLog("pos in row: " & $donateposinrow, $COLOR_ERROR)
		SetLog("coordinate: " & 385 + ($Slot * 68) & "," & $g_iDonationWindowY + 100 + $YComp, $COLOR_ERROR)
		SaveDebugImage("LiveDonateCC-r" & $donaterow & "-c" & $donateposinrow & "-" & $g_asSiegeMachineNames[$iSiegeIndex] & "_")
	EndIf

	If _ColorCheck(_GetPixelColor(370 + ($Slot * 68), $g_iDonationWindowY + 105 + $YComp, True), Hex(0x4079B8, 6), 20) Or _
			_ColorCheck(_GetPixelColor(375 + ($Slot * 68), $g_iDonationWindowY + 106 + $YComp, True), Hex(0x4079B8, 6), 20) Or _
			_ColorCheck(_GetPixelColor(380 + ($Slot * 68), $g_iDonationWindowY + 107 + $YComp, True), Hex(0x4079B8, 6), 20) Then ; check for 'blue'

		Click(398 + ($Slot * 68), $g_iDonationWindowY + 70 + $YComp, 1, $DELAYDONATECC3, "#0175")
		$DonatedSiege += 1
		If $g_iCommandStop = 3 Then
			$g_iCommandStop = 0
			$g_bFullArmy = False
		EndIf
		SetLog("Donating 1 " & ($g_asSiegeMachineNames[$iSiegeIndex]) & ($bDonateAll ? " (to all requests)" : ""), $COLOR_GREEN)
		$g_aiDonateSiegeMachines[$iSiegeIndex] += 1
		$g_aiDonateStatsSieges[$iSiegeIndex][0] += 1
	Else
		SetLog("No " & $g_asSiegeMachineNames[$iSiegeIndex] & " available to donate..", $COLOR_ERROR)
	EndIf

EndFunc   ;==>DonateSiegeType

Func DonateWindow($aiDonateButton, $bOpen = True)
	If $g_bDebugSetlog And $bOpen Then SetLog("DonateWindow Open Start", $COLOR_DEBUG)
	If $g_bDebugSetlog And Not $bOpen Then SetLog("DonateWindow Close Start", $COLOR_DEBUG)

	If Not $bOpen Then ; close window and exit
		ClickAway()
		If _Sleep($DELAYDONATEWINDOW1) Then Return
		If $g_bDebugSetlog Then SetDebugLog("DonateWindow Close Exit", $COLOR_DEBUG)
		Return
	EndIf

	Local $aiSearchArray[4] = [$aiDonateButton[0] - 20, $aiDonateButton[1] - 20, $aiDonateButton[0] + 20, $aiDonateButton[1] + 20]
	Local $aiDonateButtonCheck = decodeSingleCoord(findImage("Donate Button", $g_sImgDonateCC & "DonateButton*", GetDiamondFromArray($aiSearchArray), 1, True, Default))

	If IsArray($aiDonateButtonCheck) And UBound($aiDonateButtonCheck, 1) > 1 Then
		ClickP($aiDonateButton)
	Else
		If $g_bDebugSetlog Then SetDebugLog("Could not find the Donate Button!", $COLOR_DEBUG)
		Return False
	EndIf

	If _Sleep($DELAYDONATEWINDOW1) Then Return

	Local $icount = 0
	While Not (_ColorCheck(_GetPixelColor(355, $aiDonateButton[1], True, "DonateWindow"), Hex(0xffffff, 6), 0))
		If _Sleep($DELAYDONATEWINDOW2) Then Return
		ForceCaptureRegion()
		$icount += 1
		If $icount = 20 Then ExitLoop
	WEnd

	; Determinate the right position of the new Donation Window
	; Will search in $Y column = 410 for the first pure white color and determinate that position the $DonationWindowTemp
	$g_iDonationWindowY = 0

	ForceCaptureRegion()
	Local $aDonWinOffColors[1][3] = [[0xFFFFFF, 0, 2]]
	Local $aDonationWindow = _MultiPixelSearch(628, 0, 630, $g_iDEFAULT_HEIGHT, 1, 1, Hex(0xFFFFFF, 6), $aDonWinOffColors, 10)

	If IsArray($aDonationWindow) Then
		$g_iDonationWindowY = $aDonationWindow[1]
		If $g_bDebugSetlog Then SetDebugLog("$g_iDonationWindowY: " & $g_iDonationWindowY, $COLOR_DEBUG)
	Else
		SetLog("Could not find the Donate Window!", $COLOR_ERROR)
		Return False
	EndIf

	If $g_bDebugSetlog Then SetDebugLog("DonateWindow Open Exit", $COLOR_DEBUG)
	Return True
EndFunc   ;==>DonateWindow

Func DonateWindowCap(ByRef $g_bSkipDonTroops, ByRef $g_bSkipDonSpells)
	If $g_bDebugSetlog Then SetDebugLog("DonateCapWindow Start", $COLOR_DEBUG)
	;read troops capacity
	If Not $g_bSkipDonTroops Then
		Local $sReadCCTroopsCap = getCastleDonateCap(454, $g_iDonationWindowY + 15) ; use OCR to get donated/total capacity
		SetDebugLog("$sReadCCTroopsCap: " & $sReadCCTroopsCap, $COLOR_DEBUG)

		Local $aTempReadCCTroopsCap = StringSplit($sReadCCTroopsCap, "#")
		If $aTempReadCCTroopsCap[0] >= 2 Then
			;  Note - stringsplit always returns an array even if no values split!
			SetDebugLog("$aTempReadCCTroopsCap splitted :" & $aTempReadCCTroopsCap[1] & "/" & $aTempReadCCTroopsCap[2], $COLOR_DEBUG)
			If $aTempReadCCTroopsCap[2] > 0 Then
				$g_iDonTroopsAv = $aTempReadCCTroopsCap[1]
				$g_iDonTroopsLimit = $aTempReadCCTroopsCap[2]
				;SetLog("Donate Troops: " & $g_iDonTroopsAv & "/" & $g_iDonTroopsLimit)
			EndIf
		Else
			Local $sReadCCTroopsCap = getCastleDonateCap(492, $g_iDonationWindowY + 15) ; use OCR to get donated/total capacity -> No spell to donate in window
			SetDebugLog("$sReadCCTroopsCap: " & $sReadCCTroopsCap, $COLOR_DEBUG)

			Local $aTempReadCCTroopsCap = StringSplit($sReadCCTroopsCap, "#")
			If $aTempReadCCTroopsCap[0] >= 2 Then
				;  Note - stringsplit always returns an array even if no values split!
				SetDebugLog("$aTempReadCCTroopsCap splitted :" & $aTempReadCCTroopsCap[1] & "/" & $aTempReadCCTroopsCap[2], $COLOR_DEBUG)
				If $aTempReadCCTroopsCap[2] > 0 Then
					$g_iDonTroopsAv = $aTempReadCCTroopsCap[1]
					$g_iDonTroopsLimit = $aTempReadCCTroopsCap[2]
					;SetLog("Donate Troops: " & $g_iDonTroopsAv & "/" & $g_iDonTroopsLimit)
				EndIf
			Else
				SetLog("Error reading the Castle Troop Capacity", $COLOR_ERROR) ; log if there is read error
				$g_iDonTroopsAv = 0
				$g_iDonTroopsLimit = 0
			EndIf
		EndIf
	EndIf

	If Not $g_bSkipDonSpells Then
		Local $sReadCCSpellsCap = getCastleDonateCap(448, $g_iDonationWindowY + 221) ; use OCR to get donated/total capacity
		SetDebugLog("$sReadCCSpellsCap: " & $sReadCCSpellsCap, $COLOR_DEBUG)
		Local $aTempReadCCSpellsCap = StringSplit($sReadCCSpellsCap, "#")
		If $aTempReadCCSpellsCap[0] >= 2 Then
			;  Note - stringsplit always returns an array even if no values split!
			If $g_bDebugSetlog Then SetDebugLog("$aTempReadCCSpellsCap splitted :" & $aTempReadCCSpellsCap[1] & "/" & $aTempReadCCSpellsCap[2], $COLOR_DEBUG)
			If $aTempReadCCSpellsCap[2] > 0 Then
				$g_iDonSpellsAv = $aTempReadCCSpellsCap[1]
				$iDonSpellsLimit = $aTempReadCCSpellsCap[2]
			EndIf
		Else
			SetLog("Are you able to donate Spells? ", $COLOR_ERROR) ; log if there is read error
			$g_iDonSpellsAv = 0
			$iDonSpellsLimit = 0
		EndIf
	EndIf

	If $g_iDonTroopsAv = $g_iDonTroopsLimit Then
		$g_bSkipDonTroops = True
		SetLog("Donate Troop Limit Reached")
	EndIf
	If $g_iDonSpellsAv = $iDonSpellsLimit Then
		$g_bSkipDonSpells = True
		SetLog("Donate Spell Limit Reached")
	EndIf

	If $g_bSkipDonTroops = True And $g_bSkipDonSpells = True And $g_iDonTroopsAv < $g_iDonTroopsLimit And $g_iDonSpellsAv < $iDonSpellsLimit Then
		SetLog("Donate Troops: " & $g_iDonTroopsAv & "/" & $g_iDonTroopsLimit & ", Spells: " & $g_iDonSpellsAv & "/" & $iDonSpellsLimit)
	EndIf
	If Not $g_bSkipDonSpells And $g_iDonTroopsAv < $g_iDonTroopsLimit And $g_iDonSpellsAv = $iDonSpellsLimit Then SetLog("Donate Troops: " & $g_iDonTroopsAv & "/" & $g_iDonTroopsLimit)
	If Not $g_bSkipDonTroops And $g_iDonTroopsAv = $g_iDonTroopsLimit And $g_iDonSpellsAv < $iDonSpellsLimit Then SetLog("Donate Spells: " & $g_iDonSpellsAv & "/" & $iDonSpellsLimit)

	If $g_bDebugSetlog Then
		SetDebugLog("$g_bSkipDonTroops: " & $g_bSkipDonTroops, $COLOR_DEBUG)
		SetDebugLog("$g_bSkipDonSpells: " & $g_bSkipDonSpells, $COLOR_DEBUG)
		SetDebugLog("DonateCapWindow End", $COLOR_DEBUG)
	EndIf

EndFunc   ;==>DonateWindowCap

Func RemainingCCcapacity($aiDonateButton)
	; Remaining CC capacity of requested troops from your ClanMates
	; Will return the $g_iTotalDonateTroopCapacity with that capacity for use in donation logic.

	Local $sCapTroops = "", $aTempCapTroops, $sCapSpells = "", $aTempCapSpells, $sCapSiegeMachine = "", $aTempCapSiegeMachine
	Local $iDonatedTroops = 0, $iDonatedSpells = 0, $iDonatedSiegeMachine = 0
	Local $iCapTroopsTotal = 0, $iCapSpellsTotal = 0, $iCapSiegeMachineTotal = 0

	$g_iTotalDonateTroopCapacity = -1
	$g_iTotalDonateSpellCapacity = -1
	$g_iTotalDonateSiegeMachineCapacity = -1

	; Skip reading unnecessary items
	Local $bDonateSpell = ($g_aiPrepDon[2] = 1 Or $g_aiPrepDon[3] = 1) And ($g_iCurrentSpells > 0 Or $g_iCurrentSpells = "")
	Local $bDonateSiege = ($g_aiPrepDon[4] = 1 Or $g_aiPrepDon[5] = 1) And ($g_aiCurrentSiegeMachines[$eSiegeWallWrecker] > 0 Or $g_aiCurrentSiegeMachines[$eSiegeBattleBlimp] > 0 Or $g_aiCurrentSiegeMachines[$eSiegeStoneSlammer] > 0 Or $g_aiCurrentSiegeMachines[$eSiegeBarracks] > 0 Or $g_aiCurrentSiegeMachines[$eSiegeLogLauncher] Or $g_aiCurrentSiegeMachines[$eSiegeFlameFlinger] Or $g_aiCurrentSiegeMachines[$eSiegeBattleDrill] > 0)
	SetDebugLog("$g_aiPrepDon[2]: " & $g_aiPrepDon[2] & ", $g_aiPrepDon[3]: " & $g_aiPrepDon[3] & ", $g_iCurrentSpells: " & $g_iCurrentSpells & ", $bDonateSpell: " & $bDonateSpell)
	SetDebugLog("$g_aiPrepDon[4]: " & $g_aiPrepDon[4] & "$g_aiPrepDon[5]: " & $g_aiPrepDon[5] & ", $bDonateSiege: " & $bDonateSiege)

	; Verify with OCR the Donation Clan Castle capacity
	If $g_bDebugSetLog Then SetDebugLog("Start dual getOcrSpaceCastleDonate", $COLOR_DEBUG)

	;Button Image is a little bit lower than the Capacity Numbers, adjusting for all here
	$aiDonateButton[1] -= 10

	$sCapTroops = getOcrSpaceCastleDonate(68, $aiDonateButton[1])
	Local $IsWoSiege = StringRight($sCapTroops, 1)
	If StringInStr($sCapTroops, "#") And $IsWoSiege <> "#" Then ;CC got Troops & Spells & Siege Machine
		$sCapSpells = $bDonateSpell ? getOcrSpaceCastleDonate(147, $aiDonateButton[1]) : -1
		$sCapSiegeMachine = $bDonateSiege ? getOcrSpaceCastleDonate(209, $aiDonateButton[1]) : -1
	Else
		$sCapTroops = getOcrSpaceCastleDonate(89, $aiDonateButton[1])
		If StringRegExp($sCapTroops, "#([0-9]{2})") = 1 Then ; CC got Troops & Spells
			$sCapSpells = $bDonateSpell ? getOcrSpaceCastleDonate(205, $aiDonateButton[1]) : -1
			$sCapSiegeMachine = -1
		Else
			$sCapTroops = getOcrSpaceCastleDonate(110, $aiDonateButton[1]) ; CC got Troops Only ?
			$sCapSpells = -1
			$sCapSiegeMachine = -1
		EndIf
	EndIf

	If $g_bDebugSetLog Then
		SetDebugLog("$sCapTroops :" & $sCapTroops, $COLOR_DEBUG)
		SetDebugLog("$sCapSpells :" & $sCapSpells, $COLOR_DEBUG)
		SetDebugLog("$sCapSiegeMachine :" & $sCapSiegeMachine, $COLOR_DEBUG)
	EndIf

	If $sCapTroops <> "" And StringInStr($sCapTroops, "#") Then
		; Splitting the XX/XX
		$aTempCapTroops = StringSplit($sCapTroops, "#")

		; Local Variables to use
		If $aTempCapTroops[0] >= 2 Then
			;  Note - stringsplit always returns an array even if no values split!
			If $g_bDebugSetlog Then SetDebugLog("$aTempCapTroops splitted :" & $aTempCapTroops[1] & "/" & $aTempCapTroops[2], $COLOR_DEBUG)
			If $aTempCapTroops[2] > 0 Then
				$iDonatedTroops = $aTempCapTroops[1]
				$iCapTroopsTotal = $aTempCapTroops[2]
			EndIf
		Else
			SetLog("Error reading the Castle Troop Capacity (1)", $COLOR_ERROR) ; log if there is read error
			$iDonatedTroops = 0
			$iCapTroopsTotal = 0
		EndIf
	Else
		SetLog("Error reading the Castle Troop Capacity (2)", $COLOR_ERROR) ; log if there is read error
		$iDonatedTroops = 0
		$iCapTroopsTotal = 0
	EndIf

	If $sCapSpells <> -1 Then
		If $sCapSpells <> "" Then
			; Splitting the XX/XX
			$aTempCapSpells = StringSplit($sCapSpells, "#")

			; Local Variables to use
			If $aTempCapSpells[0] >= 2 Then
				; Note - stringsplit always returns an array even if no values split!
				If $g_bDebugSetlog Then SetDebugLog("$aTempCapSpells splitted :" & $aTempCapSpells[1] & "/" & $aTempCapSpells[2], $COLOR_DEBUG)
				If $aTempCapSpells[2] > 0 Then
					$iDonatedSpells = $aTempCapSpells[1]
					$iCapSpellsTotal = $aTempCapSpells[2]
				EndIf
			Else
				SetLog("Error reading the Castle Spell Capacity (1)", $COLOR_ERROR) ; log if there is read error
				$iDonatedSpells = 0
				$iCapSpellsTotal = 0
			EndIf
		Else
			SetLog("Error reading the Castle Spell Capacity (2)", $COLOR_ERROR) ; log if there is read error
			$iDonatedSpells = 0
			$iCapSpellsTotal = 0
		EndIf
	EndIf

	If $sCapSiegeMachine <> -1 Then
		If $sCapSiegeMachine <> "" Then
			; Splitting the XX/XX
			$aTempCapSiegeMachine = StringSplit($sCapSiegeMachine, "#")

			; Local Variables to use
			If $aTempCapSiegeMachine[0] >= 2 Then
				; Note - stringsplit always returns an array even if no values split!
				If $g_bDebugSetlog Then SetDebugLog("$aTempCapSiegeMachine splitted :" & $aTempCapSiegeMachine[1] & "/" & $aTempCapSiegeMachine[2], $COLOR_DEBUG)
				If $aTempCapSiegeMachine[2] > 0 Then
					$iDonatedSiegeMachine = $aTempCapSiegeMachine[1]
					$iCapSiegeMachineTotal = $aTempCapSiegeMachine[2]
				EndIf
			Else
				SetLog("Error reading the Castle Siege Machine Capacity (1)", $COLOR_ERROR) ; log if there is read error
				$iDonatedSiegeMachine = 0
				$iCapSiegeMachineTotal = 0
			EndIf
		Else
			SetLog("Error reading the Castle Siege Machine Capacity (2)", $COLOR_ERROR) ; log if there is read error
			$iDonatedSiegeMachine = 0
			$iCapSiegeMachineTotal = 0
		EndIf
	EndIf

	; $g_iTotalDonateTroopCapacity it will be use to determinate the quantity of kind troop to donate
	$g_iTotalDonateTroopCapacity = ($iCapTroopsTotal - $iDonatedTroops)
	If $sCapSpells <> -1 Then $g_iTotalDonateSpellCapacity = ($iCapSpellsTotal - $iDonatedSpells)
	If $sCapSiegeMachine <> -1 Then $g_iTotalDonateSiegeMachineCapacity = ($iCapSiegeMachineTotal - $iDonatedSiegeMachine)

	If $g_iTotalDonateTroopCapacity < 0 Then
		SetLog("Unable to read Clan Castle Capacity!", $COLOR_ERROR)
	Else
		Local $sSpellText = $sCapSpells <> -1 ? ", Spells: " & $iDonatedSpells & "/" & $iCapSpellsTotal : ""
		Local $sSiegeMachineText = $sCapSiegeMachine <> -1 ? ", Siege Machine: " & $iDonatedSiegeMachine & "/" & $iCapSiegeMachineTotal : ""

		SetLog("Chat Troops: " & $iDonatedTroops & "/" & $iCapTroopsTotal & $sSpellText & $sSiegeMachineText)
	EndIf
	Return "OK"
EndFunc   ;==>RemainingCCcapacity

Func DetectSlotTroop(Const $iTroopIndex, $XWindowOffset = 0)
	Local $FullTemp

	For $Slot = 0 To 6
		Local $x = 367 + $XWindowOffset + (68 * $Slot)
		Local $y = $g_iDonationWindowY + 37
		Local $x1 = $x + 63
		Local $y1 = $y + 62

		$FullTemp = SearchImgloc($g_sImgDonateTroops, $x, $y, $x1, $y1)
		If $g_bDebugSetlog Then SetDebugLog("Troop Slot: " & $Slot & " SearchImgloc returned:" & $FullTemp[0] & ".", $COLOR_DEBUG)

		If StringInStr($FullTemp[0] & " ", "empty") > 0 Then ExitLoop

		If $FullTemp[0] <> "" Then
			Local $iFoundTroopIndex = TroopIndexLookup($FullTemp[0])
			For $i = $eTroopBarbarian To $eTroopCount - 1
				If $iFoundTroopIndex = $i Then
					If $g_bDebugSetlog Then SetDebugLog("Detected " & $g_asTroopNames[$i], $COLOR_DEBUG)
					If $iTroopIndex = $i Then Return $Slot
					ExitLoop
				EndIf
				If $i = $eTroopCount - 1 Then ; detection failed
					If $g_bDebugSetlog Then SetDebugLog("Slot: " & $Slot & "Troop Detection Failed", $COLOR_DEBUG)
				EndIf
			Next
		EndIf
	Next

	For $Slot = 7 To 13
		Local $x = 367 + $XWindowOffset + (68 * ($Slot - 7))
		Local $y = $g_iDonationWindowY + 124
		Local $x1 = $x + 63
		Local $y1 = $y + 62

		$FullTemp = SearchImgloc($g_sImgDonateTroops, $x, $y, $x1, $y1)
		If $g_bDebugSetlog Then SetDebugLog("Troop Slot: " & $Slot & " SearchImgloc returned:" & $FullTemp[0] & ".", $COLOR_DEBUG)

		If StringInStr($FullTemp[0] & " ", "empty") > 0 Then ExitLoop

		If $FullTemp[0] <> "" Then
			For $i = $eTroopBarbarian To $eTroopCount - 1
				Local $iFoundTroopIndex = TroopIndexLookup($FullTemp[0])
				If $iFoundTroopIndex = $i Then
					If $g_bDebugSetlog Then SetDebugLog("Detected " & $g_asTroopNames[$i], $COLOR_DEBUG)
					If $iTroopIndex = $i Then Return $Slot
					ExitLoop
				EndIf
				If $i = $eTroopCount - 1 Then ; detection failed
					If $g_bDebugSetlog Then SetDebugLog("Slot: " & $Slot & " Troop Detection Failed", $COLOR_DEBUG)
				EndIf
			Next
		EndIf
	Next

	Return -1

EndFunc   ;==>DetectSlotTroop

Func DetectSlotSpell(Const $iSpellIndex)
	Local $FullTemp

	For $Slot = 14 To 20
		Local $x = 367 + (68 * ($Slot - 14))
		Local $y = $g_iDonationWindowY + 242
		Local $x1 = $x + 63
		Local $y1 = $y + 62

		$FullTemp = SearchImgloc($g_sImgDonateSpells, $x, $y, $x1, $y1)
		SetDebugLog("Spell Slot: " & $Slot & " SearchImgloc returned:" & $FullTemp[0] & ".", $COLOR_DEBUG)

		If StringInStr($FullTemp[0] & " ", "empty") > 0 Then ExitLoop

		If $FullTemp[0] <> "" Then
			For $i = $eSpellLightning To $eSpellCount - 1
				Local $sTmp = StringLeft($g_asSpellNames[$i], 4)
				If StringInStr($FullTemp[0] & " ", $sTmp) > 0 Then
					If $g_bDebugSetlog Then SetDebugLog("Detected " & $g_asSpellNames[$i], $COLOR_DEBUG)
					If $iSpellIndex = $i Then Return $Slot
					ExitLoop
				EndIf
				If $i = $eSpellCount - 1 Then ; detection failed
					If $g_bDebugSetlog Then SetDebugLog("Slot: " & $Slot & "Spell Detection Failed", $COLOR_DEBUG)
				EndIf
			Next
		EndIf
	Next

	Return -1

EndFunc   ;==>DetectSlotSpell

Func DetectSlotSiege(Const $iSiegeIndex)
	Local $FullTemp

	For $Slot = 0 To 6
		Local $x = 367 + (68 * $Slot)
		Local $y = $g_iDonationWindowY + 37
		Local $x1 = $x + 63
		Local $y1 = $y + 62

		$FullTemp = SearchImgloc($g_sImgDonateSiege, $x, $y, $x1, $y1)
		SetDebugLog("Siege Slot: " & $Slot & " SearchImgloc returned:" & $FullTemp[0] & ".", $COLOR_DEBUG)

		If StringInStr($FullTemp[0] & " ", "empty") > 0 Then ExitLoop

		If $FullTemp[0] <> "" Then
			For $i = $eSiegeWallWrecker To $eSiegeMachineCount - 1
				If $FullTemp[0] = $g_asSiegeMachineShortNames[$i] Then
					SetDebugLog("Detected " & $g_asSiegeMachineNames[$i], $COLOR_DEBUG)
					If $iSiegeIndex = $i Then Return $Slot
					ExitLoop
				EndIf
				If $i = $eSiegeMachineCount - 1 Then ; detection failed
					SetDebugLog("Slot: " & $Slot & "Troop Detection Failed", $COLOR_DEBUG)
				EndIf
			Next
		EndIf
	Next

	For $Slot = 7 To 13
		Local $x = 367 + (68 * ($Slot - 7))
		Local $y = $g_iDonationWindowY + 124
		Local $x1 = $x + 63
		Local $y1 = $y + 62

		$FullTemp = SearchImgloc($g_sImgDonateSiege, $x, $y, $x1, $y1)
		SetDebugLog("Siege Slot: " & $Slot & " SearchImgloc returned:" & $FullTemp[0] & ".", $COLOR_DEBUG)

		If StringInStr($FullTemp[0] & " ", "empty") > 0 Then ExitLoop

		If $FullTemp[0] <> "" Then
			For $i = $eSiegeWallWrecker To $eSiegeMachineCount - 1
				If $FullTemp[0] = $g_asSiegeMachineShortNames[$i] Then
					SetDebugLog("Detected " & $g_asSiegeMachineNames[$i], $COLOR_DEBUG)
					If $iSiegeIndex = $i Then Return $Slot
					ExitLoop
				EndIf
				If $i = $eSiegeMachineCount - 1 Then ; detection failed
					SetDebugLog("Slot: " & $Slot & "Troop Detection Failed", $COLOR_DEBUG)
				EndIf
			Next
		EndIf
	Next

	Return -1
EndFunc   ;==>DetectSlotSiege

Func SkipDonateNearFullTroops($bSetLog = False, $aHeroResult = Default)

	If Not $g_bDonationEnabled Then Return True ; will disable the donation

	If Not $g_bDonateSkipNearFullEnable Then Return False ; will enable the donation

	If $g_iCommandStop = 0 And $g_bTrainEnabled Then Return False ; IF is halt Attack and Train/Donate ....Enable the donation

	Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)

	If Not $g_abDonateHours[$hour[0]] And $g_bDonateHoursEnable Then Return True ; will disable the donation

	If $g_bDonateSkipNearFullEnable Then
		If $g_iArmyCapacity > $g_iDonateSkipNearFullPercent Then
			Local $rIsWaitforHeroesActive = IsWaitforHeroesActive()
			If $rIsWaitforHeroesActive Then
				If $aHeroResult = Default Or Not IsArray($aHeroResult) Then
					$aHeroResult = getArmyHeroTime("all", True, True) ; including open & close army overview
				EndIf
				If @error Or UBound($aHeroResult) < $eHeroCount Then
					SetLog("getArmyHeroTime return error: #" & @error & "|IA:" & IsArray($aHeroResult) & "," & UBound($aHeroResult) & ", exit SkipDonateNearFullTroops!", $COLOR_ERROR)
					Return False ; if error, then quit SkipDonateNearFullTroops enable the donation
				EndIf
				If $g_bDebugSetlog Then SetDebugLog("getArmyHeroTime returned: " & $aHeroResult[0] & ":" & $aHeroResult[1] & ":" & $aHeroResult[2], $COLOR_DEBUG)
				Local $iActiveHero = 0
				Local $iHighestTime = -1
				For $pTroopType = $eKing To $eChampion ; check all 3 hero
					For $pMatchMode = $DB To $g_iModeCount - 1 ; check all attack modes
						$iActiveHero = -1
						If IsSearchModeActiveMini($pMatchMode) And IsUnitUsed($pMatchMode, $pTroopType) And $g_iHeroUpgrading[$pTroopType - $eKing] <> 1 And $g_iHeroWaitAttackNoBit[$pMatchMode][$pTroopType - $eKing] = 1 Then
							$iActiveHero = $pTroopType - $eKing ; compute array offset to active hero
						EndIf
						;SetLog("$iActiveHero = " & $iActiveHero, $COLOR_DEBUG)
						If $iActiveHero <> -1 And $aHeroResult[$iActiveHero] > 0 Then ; valid time?
							If $aHeroResult[$iActiveHero] > $iHighestTime Then ; Is the time higher than indexed time?
								$iHighestTime = $aHeroResult[$iActiveHero]
							EndIf
						EndIf
					Next
					If _Sleep($DELAYRESPOND) Then Return
				Next
				If $g_bDebugSetlog Then SetDebugLog("$iHighestTime = " & $iHighestTime & "|" & String($iHighestTime > 5), $COLOR_DEBUG)
				If $iHighestTime > 5 Then
					If $bSetLog Then SetLog("Donations enabled, Heroes recover time is long", $COLOR_INFO)
					Return False
				Else
					If $bSetLog Then SetLog("Donation disabled, available troops " & $g_iArmyCapacity & "%, limit " & $g_iDonateSkipNearFullPercent & "%", $COLOR_INFO)
					Return True ; troops camps% > limit
				EndIf
			Else
				If $bSetLog Then SetLog("Donation disabled, available troops " & $g_iArmyCapacity & "%, limit " & $g_iDonateSkipNearFullPercent & "%", $COLOR_INFO)
				Return True ; troops camps% > limit
			EndIf
		Else
			If $bSetLog Then SetLog("Donations enabled, available troops " & $g_iArmyCapacity & "%, limit " & $g_iDonateSkipNearFullPercent & "%", $COLOR_INFO)
			Return False ; troops camps% into limits
		EndIf
	Else
		Return False ; feature disabled
	EndIf
EndFunc   ;==>SkipDonateNearFullTroops

Func BalanceDonRec($bSetLog = False)

	If Not $g_bDonationEnabled Then Return False ; Will disable donation
	If Not $g_bUseCCBalanced Then Return True ; will enable the donation
	If $g_iCommandStop = 0 And $g_bTrainEnabled Then Return True ; IF is halt Attack and Train/Donate ....Enable the donation

	Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)

	If Not $g_abDonateHours[$hour[0]] And $g_bDonateHoursEnable Then Return False ; will disable the donation


	If $g_bUseCCBalanced Then
		If $g_iTroopsDonated = 0 And $g_iTroopsReceived = 0 Then ProfileReport()
		If Number($g_iTroopsReceived) <> 0 Then
			If Number(Number($g_iTroopsDonated) / Number($g_iTroopsReceived)) >= (Number($g_iCCDonated) / Number($g_iCCReceived)) Then
				;Stop Donating
				If $bSetLog Then SetLog("Skipping Donation because Donate/Recieve Ratio is wrong", $COLOR_INFO)
				Return False
			Else
				; Continue
				Return True
			EndIf
		EndIf
	Else
		Return True
	EndIf
EndFunc   ;==>BalanceDonRec

Func SearchImgloc($directory = "", $x = 0, $y = 0, $x1 = 0, $y1 = 0)

	; Setup arrays, including default return values for $return
	Local $aResult[1], $aCoordArray[1][2], $aCoords, $aCoordsSplit, $aValue
	Local $Redlines = "FV"
	; Capture the screen for comparison
	_CaptureRegion2($x, $y, $x1, $y1)
	Local $res = DllCallMyBot("SearchMultipleTilesBetweenLevels", "handle", $g_hHBitmap2, "str", $directory, "str", "FV", "Int", 0, "str", $Redlines, "Int", 0, "Int", 1000)

	If $res[0] <> "" Then
		; Get the keys for the dictionary item.
		Local $aKeys = StringSplit($res[0], "|", $STR_NOCOUNT)

		; Redimension the result array to allow for the new entries
		ReDim $aResult[UBound($aKeys)]

		; Loop through the array
		For $i = 0 To UBound($aKeys) - 1
			; Get the property values
			$aResult[$i] = RetrieveImglocProperty($aKeys[$i], "objectname")
		Next
		If _Sleep(100) Then Return
		Return $aResult
	EndIf
	If _Sleep(100) Then Return
	Return $aResult
EndFunc   ;==>SearchImgloc
