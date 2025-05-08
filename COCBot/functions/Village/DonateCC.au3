; #FUNCTION# ====================================================================================================================
; Name ..........: DonateCC
; Description ...: This file includes functions to Donate troops
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Zax (2015)
; Modified ......: Safar46 (2015), Hervidero (2015-04), HungLe (2015-04), Sardo (2015-08), Promac (2015-12), Hervidero (2016-01), MonkeyHunter (2016-07),
;				   CodeSlinger69 (2017), Moebius14 (2024-09)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $g_aiPrepDon[6] = [0, 0, 0, 0, 0, 0]
Global $g_iTotalDonateTroopCapacity, $g_iTotalDonateSpellCapacity, $g_iTotalDonateSiegeMachineCapacity
Global $g_iDonTroopsLimit = 50, $iDonSpellsLimit = 3, $g_iDonTroopsAv = 0, $g_iDonSpellsAv = 0
Global $g_iDonTroopsQuantityAv = 0, $g_iDonSpellsQuantityAv = 0
Global $g_bSkipDonTroops = False, $g_bSkipDonSpells = False, $g_bSkipDonSiege = False
Global $g_bDonateAllRespectBlk = False ; is turned on off durning donate all section, must be false all other times
;Global $g_aiAvailQueuedTroop[$eTroopCount], $g_aiAvailQueuedSpell[$eSpellCount], $g_aiAvailSiege[$eSiegeMachineCount]

Func PrepareDonateCC()
	;Troops
	$g_aiPrepDon[0] = 0
	$g_aiPrepDon[1] = 0
	For $i = 0 To $eTroopCount + $g_iCustomDonateConfigs - 1
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

Func getArmyRequest($aiDonateCoords, $bNeedCapture = True)
	; Contains iXStart, $iYStart, $iXEnd, $iYEnd
	Local $aiSearchArray[4] = [25, $aiDonateCoords[1] - 88, 340, $aiDonateCoords[1] - 38]
	Local $sRequestDiamond = GetDiamondFromRect($aiSearchArray)
	; Returns $aCurrentRequests[index] = $aArray[2] = ["TroopShortName", CordX,CordY]
	Local $aCurrentArmyRequestTemp = findMultiple(@ScriptDir & "\imgxml\DonateCC\Army", $sRequestDiamond, $sRequestDiamond, 0, 1000, 0, "objectname,objectpoints", $bNeedCapture)

	If UBound($aCurrentArmyRequestTemp, 1) >= 1 Then
		Local $aTempRequestArray, $TempArray[0][3]
		For $i = 0 To UBound($aCurrentArmyRequestTemp, 1) - 1 ; Loop through found CC Requests
			$aTempRequestArray = $aCurrentArmyRequestTemp[$i] ; Declare Array to Temp Array
			Local $aCoords = decodeSingleCoord($aTempRequestArray[1])
			_ArrayAdd($TempArray, $aTempRequestArray[0] & "|" & $aCoords[0] & "|" & $aCoords[1])
		Next
		For $i = 0 To UBound($TempArray, 1) - 1
			$TempArray[$i][1] = Number($TempArray[$i][1])
			$TempArray[$i][2] = Number($TempArray[$i][2])
		Next
		_ArraySort($TempArray, 0, 0, 0, 1)
		Local $aCurrentArmyRequest[UBound($TempArray)][2]
		For $i = 0 To UBound($TempArray, 1) - 1
			$aCurrentArmyRequest[$i][0] = $TempArray[$i][0]
			$aCurrentArmyRequest[$i][1] = $TempArray[$i][1] & "," & $TempArray[$i][2]
		Next
	Else
		Local $bReturn = ""
		Return $bReturn
	EndIf

	Local $iArmyIndex = -1, $sClanText = "", $sReqArray[0][3], $HownManyTroop = 0, $HownManySpell = 0, $HownManySiege = 0, $eRequestCount = 0
	For $i = 0 To UBound($aCurrentArmyRequest) - 1     ; Loop through found CC Requests
		$iArmyIndex = TroopIndexLookup($aCurrentArmyRequest[$i][0], "getArmyRequest()")     ; Get the Index of the Troop from the ShortName
		Local $aCoords = decodeSingleCoord($aCurrentArmyRequest[$i][1])
		Local $bXCoordsOCR = 0
		Switch $aCoords[0]
			Case 35 To 85
				$bXCoordsOCR = 38
			Case 86 To 136
				$bXCoordsOCR = 89
			Case 137 To 187
				$bXCoordsOCR = 140
			Case 188 To 238
				$bXCoordsOCR = 191
			Case 239 To 289
				$bXCoordsOCR = 242
			Case 290 To 340
				$bXCoordsOCR = 293
		EndSwitch
		$eRequestCount = Number(getOcrAndCapture("coc-NewSysDonate", $bXCoordsOCR, $aiDonateCoords[1] - 86, 30, 14))
		Switch $iArmyIndex
			Case $eETitan, $eHeal
				If $eRequestCount > 50 Then $eRequestCount = StringReplace($eRequestCount, "7", "", 0) ; Healer And ETitan white hair could be detected as "7"
			Case $eThrower
				$eRequestCount = StringRegExpReplace($eRequestCount, "[47]", "") ; Thrower helmet white area could be detected as "4" or "7"
		EndSwitch
		_ArrayAdd($sReqArray, $iArmyIndex & "|" & $eRequestCount & "| 0")
		; Troops
		If $iArmyIndex >= $eBarb And $iArmyIndex <= $eFurn Then
			$sClanText &= ", " & $eRequestCount & " " & ($eRequestCount > 1 ? $g_asTroopNamesPlural[$iArmyIndex] : $g_asTroopNames[$iArmyIndex])
			$HownManyTroop += 1
			; Spells
		ElseIf $iArmyIndex >= $eLSpell And $iArmyIndex <= $eOgSpell Then
			$sClanText &= ", " & $eRequestCount & " " & $g_asSpellNames[$iArmyIndex - $eLSpell]
			$HownManySpell += 1
			; Sieges
		ElseIf $iArmyIndex >= $eWallW And $iArmyIndex <= $eTroopL Then
			If $iArmyIndex - $eWallW = 3 Then
				$sClanText &= ", " & $eRequestCount & " " & $g_asSiegeMachineNames[$iArmyIndex - $eWallW]
			Else
				$sClanText &= ", " & $eRequestCount & " " & $g_asSiegeMachineNames[$iArmyIndex - $eWallW] & ($eRequestCount > 1 ? "s" : "")
			EndIf
			$HownManySiege += 1
		ElseIf $iArmyIndex = -1 Then
			ContinueLoop
		EndIf
	Next

	For $i = 0 To UBound($sReqArray) - 1
		If $sReqArray[$i][0] >= $eBarb And $sReqArray[$i][0] <= $eFurn Then
			$sReqArray[$i][2] = $HownManyTroop
		ElseIf $sReqArray[$i][0] >= $eLSpell And $sReqArray[$i][0] <= $eOgSpell Then
			$sReqArray[$i][2] = $HownManySpell
		ElseIf $sReqArray[$i][0] >= $eWallW And $sReqArray[$i][0] <= $eTroopL Then
			$sReqArray[$i][2] = $HownManySiege
		EndIf
	Next

	For $i = 0 To UBound($sReqArray, 1) - 1
		$sReqArray[$i][1] = Number($sReqArray[$i][1])
		$sReqArray[$i][2] = Number($sReqArray[$i][2])
	Next

	Local $ReturnedArray[2] = [StringTrimLeft($sClanText, 2), $sReqArray]

	Return $ReturnedArray
EndFunc   ;==>getArmyRequest

Func DonateCC($bUpdateStats = True)

	Local $bDonateTroop = ($g_aiPrepDon[0] = 1)
	Local $bDonateAllTroop = ($g_aiPrepDon[1] = 1)

	Local $bDonateSpell = ($g_aiPrepDon[2] = 1)
	Local $bDonateAllSpell = ($g_aiPrepDon[3] = 1)

	Local $bDonateSiege = ($g_aiPrepDon[4] = 1)
	Local $bDonateAllSiege = ($g_aiPrepDon[5] = 1)

	Local $bDonate = ($g_iActiveDonate = 1)

	Local $bOpen = True, $bClose = False

	Local $sNewClanStringTemp[2]
	Local $ClanString = ""

	Local $sNewClanString = ""
	Local $sNewSystemRequestCountArray[0][3]
	Local $bNewSystemToDonate = False

	If Not $g_bChkDonate Or Not $bDonate Or Not $g_bDonationEnabled Then
		If $g_bDebugSetLog Then SetDebugLog("Donate Clan Castle troops skip", $COLOR_DEBUG)
		Return ; exit func if no donate checkmarks
	EndIf

	Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)

	If Not $g_abDonateHours[$hour[0]] And $g_bDonateHoursEnable Then
		If $g_bDebugSetLog Then SetDebugLog("Donate Clan Castle troops not planned, Skipped..", $COLOR_DEBUG)
		Return ; exit func if no planned donate checkmarks
	EndIf
	$bDonate = BitOR($bDonateTroop, $bDonateAllTroop, $bDonateSpell, $bDonateAllSpell, $bDonateSiege, $bDonateAllSiege)
	If Not $bDonate Then Return

	VillageReport(True, False)

	;Opens clan tab and verbose in log
	ClearScreen()

	If _Sleep(1000) Then Return

	If Not ClickB("ClanChat") Then
		SetLog("Error finding the Clan Tab Button", $COLOR_ERROR)
		Return
	EndIf

	If _ColorCheck(_GetPixelColor(400, 120 + $g_iMidOffsetY, True), Hex(0x4D4B4A, 6), 20) Then
		Click(390, 145 + $g_iMidOffsetY)
		If _Sleep(250) Then Return
	EndIf

	If _Sleep($DELAYDONATECC4) Then Return

	; check for "I Understand" button
	Local $aCoord = decodeSingleCoord(FindImageInPlace2("I Understand", $g_sImgChatIUnterstand, 50, 370 + $g_iMidOffsetY, 280, 520 + $g_iMidOffsetY, True))
	If UBound($aCoord) > 1 Then
		SetLog('Clicking "I Understand" button', $COLOR_ACTION)
		ClickP($aCoord)
		If _Sleep($DELAYDONATECC2) Then Return
	EndIf

	WaitForClanMessage("Donate", 0, 0, False)
	While 1
		ForceCaptureRegion()
		Local $offColors[3][3] = [[0xFFFFFF, 7, 0], [0x0D0D0D, 11, 0], [0x99D012, 14, 0]] ; 2nd pixel white Color, 3rd pixel black Bottom color, 4th pixel green edge of button
		Local $Scroll = _MultiPixelSearch(329, 68, 347, 70, 1, 1, Hex(0x8ECC26, 6), $offColors, 40) ; first green pixel on side of button
		SetDebugLog("Pixel Color #1: " & _GetPixelColor(332, 68, True) & ", #2: " & _GetPixelColor(339, 68, True) & ", #3: " & _GetPixelColor(343, 68, True) & ", #4: " & _GetPixelColor(346, 68, True), $COLOR_DEBUG)
		If IsArray($Scroll) Then
			$bDonate = True
			Click($Scroll[0] + 8, $Scroll[1])
			If _Sleep($DELAYDONATECC2 + 100) Then ExitLoop
			ContinueLoop
		EndIf
		ExitLoop
	WEnd

	If $g_iCommandStop <> 0 And $g_iCommandStop <> 3 Then SetLog("Checking for Donate Requests in Clan Chat", $COLOR_INFO)

	Local $iTimer
	Local $sSearchArea, $aiSearchArray[4] = [240, 90, 330, 670]
	Local $aiDonateButton

	While $bDonate
		$ClanString = ""
		$sNewClanString = ""
		If _Sleep($DELAYDONATECC2) Then ExitLoop

		WaitForClanMessage("Donate", $aiSearchArray[1], 0, False)
		$iTimer = __TimerInit()
		$sSearchArea = GetDiamondFromArray($aiSearchArray)
		$aiDonateButton = decodeSingleCoord(findImage("Donate Button", $g_sImgDonateCC & "DonateButton*", $sSearchArea, 1, True, Default))

		If $g_bDebugSetLog Then SetDebugLog("Get all Buttons in " & StringFormat("%.2f", __TimerDiff($iTimer)) & "'ms", $COLOR_DEBUG)

		If IsArray($aiDonateButton) And UBound($aiDonateButton, 1) >= 2 Then ; if Donate Button found

			; Collect Donate users images
			If Not donateCCWBLUserImageCollect($aiDonateButton[0], $aiDonateButton[1]) Then
				SetLog("Skip Donation at this Clan Mate", $COLOR_ACTION)
				$aiSearchArray[1] = $aiDonateButton[1] + 20
				ContinueLoop ; go to next button if cant read Castle Troops and Spells before the donate window opens
			EndIf

			;;; Get remaining CC capacity of requested troops from your ClanMates
			$iTimer = __TimerInit()
			RemainingCCcapacity($aiDonateButton)
			If $g_bDebugSetLog Then SetDebugLog("Get remaining CC capacity in " & StringFormat("%.2f", __TimerDiff($iTimer)) & "'ms", $COLOR_DEBUG)

			;;reset every run
			$bDonate = False
			$g_bSkipDonTroops = False
			$g_bSkipDonSpells = False
			$g_bSkipDonSiege = False

			; Read chat request for DonateTroop and DonateSpell
			If $bDonateTroop Or $bDonateSpell Or $bDonateSiege Then
				$iTimer = __TimerInit()
				; New Donation System
				$sNewClanStringTemp = getArmyRequest($aiDonateButton)
				If IsArray($sNewClanStringTemp) Then $sNewClanString = $sNewClanStringTemp[0]
				; Reset Var
				$bNewSystemToDonate = False

				If $sNewClanString <> "" Then
					$ClanString = $sNewClanString
					If IsArray($sNewClanStringTemp) Then $sNewSystemRequestCountArray = $sNewClanStringTemp[1]
					$bNewSystemToDonate = True
				Else
					Local $Alphabets[4] = [$g_bChkExtraAlphabets, $g_bChkExtraChinese, $g_bChkExtraKorean, $g_bChkExtraPersian]
					Local $TextAlphabetsNames[4] = ["Cyrillic and Latin", "Chinese", "Korean", "Persian"]
					Local $AlphabetFunctions[4] = ["getChatString", "getChatStringChinese", "getChatStringKorean", "getChatStringPersian"]
					Local $BlankSpaces = ""
					For $i = 0 To UBound($Alphabets) - 1
						If $i = 0 Then
							; Line 3 to 1
							Local $aCoordinates[3] = [80, 73, 46] ; Extra coordinates for Latin (3 Lines)
							Local $OcrName = ($Alphabets[$i] = True) ? ("coc-latin-cyr") : ("coc-latinA")
							Local $log = "Latin"
							If $Alphabets[$i] Then $log = $TextAlphabetsNames[$i]
							$ClanString = ""
							SetLog("Using OCR to read " & $log & " derived alphabets.", $COLOR_ACTION)
							For $j = 0 To 2
								If $ClanString = "" Or $ClanString = " " Or $BlankSpaces = " " Then
									$ClanString &= $BlankSpaces & getChatString(22, $aiDonateButton[1] - $aCoordinates[$j], $OcrName)
									If $g_bDebugSetLog Then SetDebugLog("$OcrName: " & $OcrName)
									If $g_bDebugSetLog Then SetDebugLog("$aCoordinates: " & $aCoordinates[$j])
									If $g_bDebugSetLog Then SetDebugLog("$ClanString: " & $ClanString)
									; If $ClanString <> "" And $ClanString <> " " Then ExitLoop
								EndIf
								If $ClanString <> "" Then $BlankSpaces = " "
							Next
						Else
							Local $Yaxis[3] = [53, 52, 56] ; "Chinese", "Korean", "Persian"
							If $Alphabets[$i] Then
								If $ClanString = "" Or $ClanString = " " Then
									SetLog("Using OCR to read " & $TextAlphabetsNames[$i] & " alphabets.", $COLOR_ACTION)
									; Ensure used functions are references in "MBR References.au3"
									#Au3Stripper_Off
									$ClanString &= $BlankSpaces & Call($AlphabetFunctions[$i], 22, $aiDonateButton[1] - $Yaxis[$i - 1])
									#Au3Stripper_On
									If @error = 0xDEAD And @extended = 0xBEEF Then SetLog("[DonatCC] Function " & $AlphabetFunctions[$i] & "() had a problem.")
									If $g_bDebugSetLog Then SetDebugLog("$OcrName: " & $OcrName)
									If $g_bDebugSetLog Then SetDebugLog("$Yaxis: " & $Yaxis[$i - 1])
									If $g_bDebugSetLog Then SetDebugLog("$ClanString: " & $ClanString)
									If $ClanString <> "" And $ClanString <> " " Then ExitLoop
								EndIf
							EndIf
						EndIf
					Next

					If $g_bDebugSetLog Then SetDebugLog("Get Request OCR in " & StringFormat("%.2f", __TimerDiff($iTimer)) & "'ms", $COLOR_DEBUG)
				EndIf

				$iTimer = __TimerInit()

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
					Local $bDonateTroopMatched = False, $bDonateSpellMatched = False, $bDonateSiegeMatched = False
					If Not $bDonateAllTroop And Not $bDonateAllSpell And Not $bDonateAllSiege Then
						Local $Checked = False
						For $i = 0 To $eTroopCount + $g_iCustomDonateConfigs - 1
							If $g_abChkDonateTroop[$i] Then ; checking Troops & Custom
								If $g_bDebugSetLog Then SetDebugLog("Troop: [" & $i & "] checking!", $COLOR_DEBUG)
								If CheckDonateTroop($i, $g_asTxtDonateTroop[$i], $g_asTxtBlacklistTroop[$i], $ClanString, $bNewSystemToDonate, True) Then
									If $bNewSystemToDonate Then
										$Checked = True
									Else
										; Space to donate troop?
										$g_iDonTroopsQuantityAv = Floor($g_iTotalDonateTroopCapacity / $g_aiTroopSpace[$i])
										If $g_iTotalDonateTroopCapacity > 0 And $g_iDonTroopsQuantityAv < 1 Then
											SetLog($g_asTroopNames[$i] & " doesn't fit in the remaining space!", $COLOR_ACTION)
										Else
											$bDonateTroopMatched = True
											$Checked = True
										EndIf
									EndIf
								EndIf
							EndIf
						Next
						For $i = 0 To $eSpellCount - 1
							If $g_abChkDonateSpell[$i] Then ; checking Spells
								If $g_bDebugSetLog Then SetDebugLog("Spell: [" & $i & "] checking!", $COLOR_DEBUG)
								If CheckDonateSpell($i, $g_asTxtDonateSpell[$i], $g_asTxtBlacklistSpell[$i], $ClanString, $bNewSystemToDonate, True) Then
									If $bNewSystemToDonate Then
										$Checked = True
									Else
										; Space to donate spell?
										$g_iDonSpellsQuantityAv = Floor($g_iTotalDonateSpellCapacity / $g_aiSpellSpace[$i])
										If $g_iTotalDonateSpellCapacity > 0 And $g_iDonSpellsQuantityAv < 1 Then
											SetLog($g_asSpellNames[$i] & " Spell doesn't fit in the remaining space!", $COLOR_ACTION)
										Else
											$bDonateSpellMatched = True
											$Checked = True
										EndIf
									EndIf
								EndIf
							EndIf
						Next
						For $i = ($eTroopCount + $g_iCustomDonateConfigs) To ($eTroopCount + $g_iCustomDonateConfigs + $eSiegeMachineCount) - 1
							If $g_abChkDonateTroop[$i] Then ; checking SiegeMachines
								If $g_bDebugSetLog Then SetDebugLog("Siege: [" & $i - $eTroopCount - $g_iCustomDonateConfigs & "] checking!", $COLOR_DEBUG)
								If CheckDonateSiege($i - $eTroopCount - $g_iCustomDonateConfigs, $g_asTxtDonateTroop[$i], $g_asTxtBlacklistTroop[$i], $ClanString, $bNewSystemToDonate, True) Then
									If Not $bNewSystemToDonate Then $bDonateSiegeMatched = True
									$Checked = True
								EndIf
							EndIf
						Next
						If Not $Checked Then
							SetDebugLog("Chat Request does not match any donate keyword, go to next request")
							$bDonate = True
							$aiSearchArray[1] = $aiDonateButton[1] + 20
							ContinueLoop
						EndIf
						SetDebugLog("Chat Request matches a donate keyword, proceed with donating")
					Else
						$bDonateTroopMatched = True
						$bDonateSpellMatched = True
						$bDonateSiegeMatched = True
					EndIf
				EndIf
			ElseIf $bDonateAllTroop Or $bDonateAllSpell Or $bDonateAllSiege Then
				$sNewClanStringTemp = getArmyRequest($aiDonateButton)
				If IsArray($sNewClanStringTemp) Then $sNewClanString = $sNewClanStringTemp[0]
				; Reset Var
				$bNewSystemToDonate = False
				If $sNewClanString <> "" Then
					$ClanString = $sNewClanString
					If IsArray($sNewClanStringTemp) Then $sNewSystemRequestCountArray = $sNewClanStringTemp[1]
					$bNewSystemToDonate = True
				EndIf
				SetLog("Skip reading chat requests. Donate all is enabled!", $COLOR_ACTION)
				Local $bDonateTroopMatched = True, $bDonateSpellMatched = True, $bDonateSiegeMatched = True
			EndIf

			;;; Donate Filter
			;;; Troops
			If $g_iTotalDonateTroopCapacity <= 0 Then
				SetLog("Clan Castle troops are full, skip troop donation", $COLOR_ACTION)
				$g_bSkipDonTroops = True
			ElseIf $g_iTotalDonateTroopCapacity > 0 Then
				If Not $bNewSystemToDonate And Not $bDonateTroopMatched Then $g_bSkipDonTroops = True
			EndIf
			;;; Spells
			If $g_iTotalDonateSpellCapacity = -1 Then
				; no message, this CC has no Spell capability
				If $g_bDebugSetLog Then SetDebugLog("This CC cannot accept spells, skip spell donation", $COLOR_DEBUG)
				$g_bSkipDonSpells = True
			ElseIf $g_iTotalDonateSpellCapacity = 0 Then
				SetLog("Clan Castle spells are full, skip spell donation...", $COLOR_ACTION)
				$g_bSkipDonSpells = True
			ElseIf $g_iTotalDonateSpellCapacity > 0 Then
				If Not $bNewSystemToDonate And Not $bDonateSpellMatched Then $g_bSkipDonSpells = True
			EndIf
			;;; Sieges
			If Not $bDonateSiege And Not $bDonateAllSiege Then
				SetLog("Siege donation is not enabled, skip siege donation", $COLOR_ACTION)
				$g_bSkipDonSiege = True
			ElseIf $g_iTotalDonateSiegeMachineCapacity = -1 Then
				; no message, this CC has no Siege capability
				If $g_bDebugSetLog Then SetDebugLog("This CC cannot accept siege, skip siege donation", $COLOR_ACTION)
				$g_bSkipDonSiege = True
			ElseIf $g_iTotalDonateSiegeMachineCapacity = 0 Then
				SetLog("Clan Castle Siege is full, skip siege donation", $COLOR_ACTION)
				$g_bSkipDonSiege = True
			ElseIf $g_iTotalDonateSiegeMachineCapacity > 0 Then
				If Not $bNewSystemToDonate And Not $bDonateSiegeMatched Then $g_bSkipDonSiege = True
			EndIf

			;;; Flagged to Skip Check
			If $g_bSkipDonTroops And $g_bSkipDonSpells And $g_bSkipDonSiege Then
				$bDonate = True
				$aiSearchArray[1] = $aiDonateButton[1] + 20
				ContinueLoop ; go to next button if cant read Castle Troops and Spells before the donate window opens
			EndIf

			;;; Open Donate Window
			If _Sleep($DELAYDONATECC3) Then Return
			If Not DonateWindow($aiDonateButton, $bOpen) Then
				SetLog("Donate Window did not open - Exiting Donate", $COLOR_ERROR)
				ExitLoop ; Leave donate to prevent a bot hang condition
			EndIf

			;;; Variables to use in Loops for Custom.A to Custom.B
			Local $eCustom[2] = [$eCustomA, $eCustomB]
			Local $eDonateCustom[2] = [$g_aiDonateCustomTrpNumA, $g_aiDonateCustomTrpNumB]

			;;; Typical Donation
			If $bDonateTroop Or $bDonateSpell Or $bDonateSiege Then
				If $g_bDebugSetLog Then SetDebugLog("Troop/Spell/Siege checkpoint.", $COLOR_DEBUG)

				; read available donate cap, and ByRef set the $g_bSkipDonTroops and $g_bSkipDonSpells flags
				DonateWindowCap($g_bSkipDonTroops, $g_bSkipDonSpells)
				If $g_bDebugSetLog Then SetDebugLog("Get available donate cap in " & StringFormat("%.2f", __TimerDiff($iTimer)) & "'ms", $COLOR_DEBUG)
				$iTimer = __TimerInit()
				If $g_bSkipDonTroops And $g_bSkipDonSpells And $g_bSkipDonSiege Then
					DonateWindow($aiDonateButton, $bClose)
					$bDonate = True
					$aiSearchArray[1] = $aiDonateButton[1] + 20
					ContinueLoop ; go to next button if already donated, maybe this is an impossible case..
				EndIf

				;;;  DONATION TROOPS
				If $bDonateTroop And Not $g_bSkipDonTroops Then
					If $g_bDebugSetLog Then SetDebugLog("Troop checkpoint.", $COLOR_DEBUG)

					;;;  Custom Combination Troops
					For $x = 0 To UBound($eDonateCustom) - 1
						If $g_abChkDonateTroop[$eCustom[$x]] And CheckDonateTroop(99, $g_asTxtDonateTroop[$eCustom[$x]], $g_asTxtBlacklistTroop[$eCustom[$x]], $ClanString, $bNewSystemToDonate) Then
							Local $CorrectDonateCustom = $eDonateCustom[$x]

							For $i = 0 To 2
								If $CorrectDonateCustom[$i][0] < $eBarb Then
									$CorrectDonateCustom[$i][0] = $eArch ; Change strange small numbers to archer
								ElseIf $CorrectDonateCustom[$i][0] > $eFurn Then
									ContinueLoop ; If "Nothing" is selected then continue
								EndIf
								If $CorrectDonateCustom[$i][1] < 1 Then
									ContinueLoop ; If donate number is smaller than 1 then continue
								ElseIf $CorrectDonateCustom[$i][1] > 8 Then
									$CorrectDonateCustom[$i][1] = 8 ; Number larger than 8 is unnecessary
								EndIf
								DonateTroopType($CorrectDonateCustom[$i][0], $CorrectDonateCustom[$i][1], False, $bNewSystemToDonate)
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
									Local $bCount = 0
									If $bNewSystemToDonate Then
										For $z = 0 To UBound($sNewSystemRequestCountArray) - 1
											If $sNewSystemRequestCountArray[$z][0] = $iTroopIndex And $sNewSystemRequestCountArray[$z][2] > 1 Then
												$bCount = $sNewSystemRequestCountArray[$z][1]
												If $bCount = "" Then $bCount = 0
											EndIf
										Next
									EndIf
									DonateTroopType($iTroopIndex, $bCount, False, $bNewSystemToDonate)
									If _Sleep($DELAYDONATECC3) Then ExitLoop
								EndIf
							EndIf
						Next
					EndIf
					If $g_bDebugSetLog Then SetDebugLog("Get Donated troops in " & StringFormat("%.2f", __TimerDiff($iTimer)) & "'ms", $COLOR_DEBUG)
					$iTimer = __TimerInit()

				EndIf

				;;; DONATE SIEGE
				If Not $g_bSkipDonSiege And $bDonateSiege Then
					If $g_bDebugSetLog Then SetDebugLog("Siege checkpoint.", $COLOR_DEBUG)
					For $SiegeIndex = $eSiegeWallWrecker To $eSiegeMachineCount - 1
						Local $index = $eTroopCount + $g_iCustomDonateConfigs + $SiegeIndex
						If $g_abChkDonateTroop[$index] Then
							If CheckDonateSiege($SiegeIndex, $g_asTxtDonateTroop[$index], $g_asTxtBlacklistTroop[$index], $ClanString, $bNewSystemToDonate) Then
								Local $bCount = 0
								If $bNewSystemToDonate Then
									For $z = 0 To UBound($sNewSystemRequestCountArray) - 1
										If $sNewSystemRequestCountArray[$z][0] - $eWallW = $index And $sNewSystemRequestCountArray[$z][2] > 1 Then
											$bCount = $sNewSystemRequestCountArray[$z][1]
											If $bCount = "" Then $bCount = 0
										EndIf
									Next
								EndIf
								DonateSiegeType($SiegeIndex, $bCount, False, $bNewSystemToDonate)
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
								Local $bCount = 0
								If $bNewSystemToDonate Then
									For $z = 0 To UBound($sNewSystemRequestCountArray) - 1
										If $sNewSystemRequestCountArray[$z][0] - $eLSpell = $iSpellIndex And $sNewSystemRequestCountArray[$z][2] > 1 Then
											$bCount = $sNewSystemRequestCountArray[$z][1]
											If $bCount = "" Then $bCount = 0
										EndIf
									Next
								EndIf
								DonateSpellType($iSpellIndex, $bCount, False, $bNewSystemToDonate)
								If _Sleep($DELAYDONATECC3) Then ExitLoop
							EndIf
						EndIf
					Next
					If $g_bDebugSetLog Then SetDebugLog("Get Donated Spells in " & StringFormat("%.2f", __TimerDiff($iTimer)) & "'ms", $COLOR_DEBUG)
					$iTimer = __TimerInit()
				EndIf

			EndIf

			;;; Donate to All Zone
			If $bDonateAllTroop Or $bDonateAllSpell Or $bDonateAllSiege Then
				If $g_bDebugSetLog Then SetDebugLog("Troop/Spell/Siege All checkpoint.", $COLOR_DEBUG) ;Debug
				$g_bDonateAllRespectBlk = True

				If $bDonateAllTroop And Not $g_bSkipDonTroops Then
					; read available donate cap, and ByRef set the $g_bSkipDonTroops and $g_bSkipDonSpells flags
					DonateWindowCap($g_bSkipDonTroops, $g_bSkipDonSpells)
					SetLog("Get available donate cap (to all) in " & StringFormat("%.2f", __TimerDiff($iTimer)) & "'ms", $COLOR_DEBUG)
					$iTimer = __TimerInit()
					If $g_bSkipDonTroops And $g_bSkipDonSpells Then
						DonateWindow($aiDonateButton, $bClose)
						$bDonate = True
						$aiSearchArray[1] = $aiDonateButton[1] + 20
						ContinueLoop ; go to next button if already donated, maybe this is an impossible case..
					EndIf
					If $g_bDebugSetLog Then SetDebugLog("Troop All checkpoint.", $COLOR_DEBUG)

					;;; DONATE TO ALL for Custom And Typical Donation
					; 0 to 1 is Custom [A to B] and the 2 is the 'Typical'
					For $x = 0 To 2
						If $x <> 2 Then
							If $g_abChkDonateAllTroop[$eCustom[$x]] Then
								Local $CorrectDonateCustom = $eDonateCustom[$x]
								For $i = 0 To 2
									If $CorrectDonateCustom[$i][0] < $eBarb Then
										$CorrectDonateCustom[$i][0] = $eArch ; Change strange small numbers to archer
									ElseIf $CorrectDonateCustom[$i][0] > $eFurn Then
										DonateWindow($aiDonateButton, $bClose)
										$bDonate = True
										$aiSearchArray[1] = $aiDonateButton[1] + 20
										ContinueLoop ; If "Nothing" is selected then continue
									EndIf
									If $CorrectDonateCustom[$i][1] < 1 Then
										DonateWindow($aiDonateButton, $bClose)
										$bDonate = True
										$aiSearchArray[1] = $aiDonateButton[1] + 20
										ContinueLoop ; If donate number is smaller than 1 then continue
									ElseIf $CorrectDonateCustom[$i][1] > 8 Then
										$CorrectDonateCustom[$i][1] = 8 ; Number larger than 8 is unnecessary
									EndIf
									DonateTroopType($CorrectDonateCustom[$i][0], $CorrectDonateCustom[$i][1], $bDonateAllTroop, $bNewSystemToDonate) ;;; Donate Custom Troop using DonateTroopType2
								Next
							EndIf
						Else ; this is the $x = 2 [Typical Donation]
							For $i = 0 To UBound($g_aiDonateTroopPriority) - 1
								Local $iTroopIndex = $g_aiDonateTroopPriority[$i]
								If $g_abChkDonateAllTroop[$iTroopIndex] Then
									If CheckDonateTroop($iTroopIndex, $g_asTxtDonateTroop[$iTroopIndex], $g_asTxtBlacklistTroop[$iTroopIndex], $ClanString, $bNewSystemToDonate) Then
										Local $bCount = 0
										If $bNewSystemToDonate Then
											For $z = 0 To UBound($sNewSystemRequestCountArray) - 1
												If $sNewSystemRequestCountArray[$z][0] = $iTroopIndex And $sNewSystemRequestCountArray[$z][2] > 1 Then
													$bCount = $sNewSystemRequestCountArray[$z][1]
													If $bCount = "" Then $bCount = 0
												EndIf
											Next
										EndIf
										DonateTroopType($iTroopIndex, $bCount, $bDonateAllTroop, $bNewSystemToDonate)
									EndIf
									ExitLoop
								EndIf
							Next
						EndIf
					Next
					If $g_bDebugSetLog Then SetDebugLog("Get Donated troops (to all) in " & StringFormat("%.2f", __TimerDiff($iTimer)) & "'ms", $COLOR_DEBUG)
					$iTimer = __TimerInit()
				EndIf

				;Siege
				If $bDonateAllSiege And Not $g_bSkipDonSiege Then
					If $g_bDebugSetLog Then SetDebugLog("Siege All checkpoint.", $COLOR_DEBUG)

					For $SiegeIndex = $eSiegeWallWrecker To $eSiegeMachineCount - 1
						Local $index = $eTroopCount + $g_iCustomDonateConfigs + $SiegeIndex
						If $g_abChkDonateAllTroop[$index] Then
							If CheckDonateSiege($SiegeIndex, $g_asTxtDonateTroop[$index], $g_asTxtBlacklistTroop[$index], $ClanString, $bNewSystemToDonate) Then
								Local $bCount = 0
								If $bNewSystemToDonate Then
									For $z = 0 To UBound($sNewSystemRequestCountArray) - 1
										If $sNewSystemRequestCountArray[$z][0] - $eWallW = $index And $sNewSystemRequestCountArray[$z][2] > 1 Then
											$bCount = $sNewSystemRequestCountArray[$z][1]
											If $bCount = "" Then $bCount = 0
										EndIf
									Next
								EndIf
								DonateSiegeType($SiegeIndex, $bCount, $bDonateAllSiege, $bNewSystemToDonate)
							EndIf
							ExitLoop
						EndIf
					Next
					If $g_bDebugSetLog Then SetDebugLog("Get Donated Sieges (to all)  in " & StringFormat("%.2f", __TimerDiff($iTimer)) & "'ms", $COLOR_DEBUG)
					$iTimer = __TimerInit()
				EndIf

				If $bDonateAllSpell And Not $g_bSkipDonSpells Then
					If $g_bDebugSetLog Then SetDebugLog("Spell All checkpoint.", $COLOR_DEBUG)

					For $i = 0 To UBound($g_aiDonateSpellPriority) - 1
						Local $iSpellIndex = $g_aiDonateSpellPriority[$i]
						If $g_abChkDonateAllSpell[$iSpellIndex] Then
							If CheckDonateSpell($iSpellIndex, $g_asTxtDonateSpell[$iSpellIndex], $g_asTxtBlacklistSpell[$iSpellIndex], $ClanString, $bNewSystemToDonate) Then
								Local $bCount = 0
								If $bNewSystemToDonate Then
									For $z = 0 To UBound($sNewSystemRequestCountArray) - 1
										If $sNewSystemRequestCountArray[$z][0] - $eLSpell = $iSpellIndex And $sNewSystemRequestCountArray[$z][2] > 1 Then
											$bCount = $sNewSystemRequestCountArray[$z][1]
											If $bCount = "" Then $bCount = 0
										EndIf
									Next
								EndIf
								DonateSpellType($iSpellIndex, $bCount, $bDonateAllSpell, $bNewSystemToDonate)
							EndIf
							ExitLoop
						EndIf
					Next
					If $g_bDebugSetLog Then SetDebugLog("Get Donated Spells (to all)  in " & StringFormat("%.2f", __TimerDiff($iTimer)) & "'ms", $COLOR_DEBUG)
					$iTimer = __TimerInit()
				EndIf

				$g_bDonateAllRespectBlk = False

			EndIf

			If _Sleep($DELAYDONATEWINDOW1) Then ExitLoop
			If _ColorCheck(_GetPixelColor($g_iDonationWindowX, $aiDonateButton[1], True), Hex(0xE7E7E7, 6), 10) Then
				ClickP($aiDonateButton)
				If _ColorCheck(_GetPixelColor($g_iDonationWindowX, $aiDonateButton[1], True), Hex(0xE7E7E7, 6), 10) Then ClickAway("Right")
			EndIf
			If _Sleep($DELAYDONATEWINDOW1) Then ExitLoop

			$bDonate = True
			$aiSearchArray[1] = $aiDonateButton[1] + 20

		EndIf

		WaitForClanMessage("Donate", $aiSearchArray[1], 0, False)
		$sSearchArea = GetDiamondFromArray($aiSearchArray)
		$aiDonateButton = decodeSingleCoord(findImage("Donate Button", $g_sImgDonateCC & "DonateButton*", $sSearchArea, 1, True, Default))

		If $g_bDebugSetLog Then SetDebugLog("Get more donate buttons in " & StringFormat("%.2f", __TimerDiff($iTimer)) & "'ms", $COLOR_DEBUG)

		If IsArray($aiDonateButton) And UBound($aiDonateButton, 1) >= 2 Then
			If $g_bDebugSetLog Then SetDebugLog("More Donate buttons found, new $aiDonateButton: (" & $aiDonateButton[0] & "," & $aiDonateButton[1] & ")", $COLOR_DEBUG)
			If _Sleep($DELAYDONATECC2) Then ExitLoop
			ContinueLoop
		Else
			If $g_bDebugSetLog Then SetDebugLog("No more Donate buttons found, closing chat", $COLOR_DEBUG)
		EndIf

		;;; Scroll Down
		Local $offColors[3][3] = [[0xFFFFFF, 7, 0], [0x0D0D0D, 11, 0], [0x99D012, 14, 0]] ; 2nd pixel white Color, 3rd pixel black Bottom color, 4th pixel green edge of button
		Local $Scroll = _MultiPixelSearch(329, 651, 347, 652, 1, 1, Hex(0x92D028, 6), $offColors, 40) ; first green pixel on side of button
		SetDebugLog("Pixel Color #1: " & _GetPixelColor(332, 651, True) & ", #2: " & _GetPixelColor(339, 651, True) & ", #3: " & _GetPixelColor(343, 651, True) & ", #4: " & _GetPixelColor(346, 651, True), $COLOR_DEBUG)
		If IsArray($Scroll) Then
			$bDonate = True
			Click($Scroll[0] + 8, $Scroll[1])
			$aiSearchArray[1] = 580
			If _Sleep($DELAYDONATECC2) Then ExitLoop
			ContinueLoop
		EndIf

		;;; Chat Down
		If ClickB("ChatDown") Then
			$aiSearchArray[1] = 580
			$sSearchArea = GetDiamondFromArray($aiSearchArray)
			$aiDonateButton = decodeSingleCoord(findImage("Donate Button", $g_sImgDonateCC & "DonateButton*", $sSearchArea, 1, True, Default))
			If IsArray($aiDonateButton) And UBound($aiDonateButton, 1) >= 2 Then
				$bDonate = True
				ContinueLoop
			EndIf
		EndIf
		$bDonate = False
	WEnd

	If Not ClickB("ClanChat") Then
		If _Sleep(1000) Then Return
		ClickAway("Right")
		If _Sleep(1000) Then Return
		If Not ClickB("ClanChat") Then
			SetLog("Error finding the Clan Tab Button", $COLOR_ERROR)
			AndroidPageError("DonateCC")
		EndIf
	EndIf

	If $bUpdateStats Then UpdateStats()
	If _Sleep($DELAYDONATECC2) Then Return
EndFunc   ;==>DonateCC

Func CheckDonateTroop(Const $iTroopIndex, Const $sDonateTroopString, Const $sBlacklistTroopString, Const $sClanString, $bNewSystemDonate = False, $bSetLog = False)
	Local $sName = ($iTroopIndex = 99 ? "Custom" : $g_asTroopNames[$iTroopIndex])
	Return CheckDonate($sName, $bNewSystemDonate = True ? $sName : $sDonateTroopString, $sBlacklistTroopString, $sClanString, $bSetLog)
EndFunc   ;==>CheckDonateTroop

Func CheckDonateSpell(Const $iSpellIndex, Const $sDonateSpellString, Const $sBlacklistSpellString, Const $sClanString, $bNewSystemDonate = False, $bSetLog = False)
	Local $sName = $g_asSpellNames[$iSpellIndex]
	Return CheckDonate($sName, $bNewSystemDonate = True ? $sName : $sDonateSpellString, $sBlacklistSpellString, $sClanString, $bSetLog)
EndFunc   ;==>CheckDonateSpell

Func CheckDonateSiege(Const $iSiegeIndex, Const $sDonateSiegeString, Const $sBlacklistSiegeString, Const $sClanString, $bNewSystemDonate = False, $bSetLog = False)
	Local $sName = $g_asSiegeMachineNames[$iSiegeIndex]
	Return CheckDonate($sName, $bNewSystemDonate = True ? $sName : $sDonateSiegeString, $sBlacklistSiegeString, $sClanString, $bSetLog)
EndFunc   ;==>CheckDonateSiege

Func CheckDonate(Const $sName, Const $sDonateString, Const $sBlacklistString, Const $sClanString, Const $bSetLog)
	Local $asSplitDonate = StringSplit($sDonateString, @CRLF, $STR_ENTIRESPLIT)
	Local $asSplitBlacklist = StringSplit($sBlacklistString, @CRLF, $STR_ENTIRESPLIT)
	Local $asSplitGeneralBlacklist = StringSplit($g_sTxtGeneralBlacklist, @CRLF, $STR_ENTIRESPLIT)

	For $i = 1 To UBound($asSplitGeneralBlacklist) - 1
		If CheckDonateString($asSplitGeneralBlacklist[$i], $sClanString) Then
			If $bSetLog Then SetLog("General Blacklist Keyword found: " & $asSplitGeneralBlacklist[$i], $COLOR_ERROR)
			Return False
		EndIf
	Next

	For $i = 1 To UBound($asSplitBlacklist) - 1
		If CheckDonateString($asSplitBlacklist[$i], $sClanString) Then
			If $bSetLog Then SetLog($sName & " Blacklist Keyword found: " & $asSplitBlacklist[$i], $COLOR_ERROR)
			Return False
		EndIf
	Next

	If Not $g_bDonateAllRespectBlk Then
		For $i = 1 To UBound($asSplitDonate) - 1
			If CheckDonateString($asSplitDonate[$i], $sClanString) Then
				If $bSetLog Then SetLog($sName & " Keyword found: " & $asSplitDonate[$i], $COLOR_SUCCESS)
				Return True
			EndIf
		Next
	EndIf

	If $g_bDonateAllRespectBlk Then Return True

	If $g_bDebugSetLog Then SetDebugLog("Bad call of CheckDonateTroop: " & $sName, $COLOR_DEBUG)
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

Func DonateTroopType(Const $iTroopIndex, $Quant = 0, Const $bDonateAll = False, $bNewSystemToDonate = True)
	Local $Slot = -1, $detectedSlot = -1
	Local $YComp = 0, $donaterow = -1
	Local $donateposinrow = -1
	Local $sTextToAll = ""
	Local $bUnityDonationCost = 0

	If $g_iTotalDonateTroopCapacity = 0 Then Return
	If $g_bDebugSetLog Then SetDebugLog("$DonateTroopType Start: " & $g_asTroopNames[$iTroopIndex], $COLOR_DEBUG)

	; Space to donate troop?
	$g_iDonTroopsQuantityAv = Floor($g_iTotalDonateTroopCapacity / $g_aiTroopSpace[$iTroopIndex])
	If $g_iDonTroopsQuantityAv < 1 Then
		SetLog("Sorry Chief! " & $g_asTroopNamesPlural[$iTroopIndex] & " don't fit in the remaining space!")
		Return
	EndIf

	Local $g_iDonTroopsLimitClan = 0
	WaitForClanMessage("Donate", $g_iDonationWindowY + 60, $g_iDonationWindowY + 76)
	Local $g_iDonTroopsLimitClanOCR = getOcrAndCapture("coc-t-lim", $g_iDonationWindowX + 99, $g_iDonationWindowY + 63, 40, 14, True)
	Local $aTempDonTroopsLimitClan = StringSplit($g_iDonTroopsLimitClanOCR, "#", $STR_NOCOUNT)
	If UBound($aTempDonTroopsLimitClan) >= 2 Then $g_iDonTroopsLimitClan = $aTempDonTroopsLimitClan[1] - $aTempDonTroopsLimitClan[0]
	If ($g_iDonTroopsLimitClan <> "" Or $g_iDonTroopsLimitClan = 0) And Number($g_iDonTroopsLimitClan) <> Number($g_iDonTroopsLimit) Then $g_iDonTroopsLimit = $g_iDonTroopsLimitClan

	If $Quant = 0 Or $Quant > _Min(Number($g_iDonTroopsQuantityAv), Number($g_iDonTroopsLimit)) Then $Quant = _Min(Number($g_iDonTroopsQuantityAv), Number($g_iDonTroopsLimit))

	Local $bIsDarkElixir = False
	If $iTroopIndex >= $eBarb And $iTroopIndex <= $eThrower Then
		$bUnityDonationCost = 1000 * $g_aiTroopsDonationCost[$iTroopIndex]
		If Number($Quant * $bUnityDonationCost) > $g_aiCurrentLoot[$eLootElixir] Then
			SetLog("Not enough Elixir to donate " & $Quant & " " & ($Quant > 1 ? $g_asTroopNamesPlural[$iTroopIndex] : $g_asTroopNames[$iTroopIndex]))
			If $g_aiCurrentLoot[$eLootElixir] / $bUnityDonationCost > 0 Then
				$Quant = Floor($g_aiCurrentLoot[$eLootElixir] / $bUnityDonationCost)
				SetLog("Reducing " & $g_asTroopNames[$iTroopIndex] & " donation to " & $Quant)
			EndIf
		EndIf
	ElseIf $iTroopIndex >= $eMini And $iTroopIndex <= $eFurn Then
		$bIsDarkElixir = True
		$bUnityDonationCost = $g_aiTroopsDonationCost[$iTroopIndex]
		If Number($Quant * $bUnityDonationCost) > $g_aiCurrentLoot[$eLootDarkElixir] Then
			SetLog("Not enough Elixir to donate " & $Quant & " " & ($Quant > 1 ? $g_asTroopNamesPlural[$iTroopIndex] : $g_asTroopNames[$iTroopIndex]))
			If $g_aiCurrentLoot[$eLootDarkElixir] / $bUnityDonationCost > 0 Then
				$Quant = Floor($g_aiCurrentLoot[$eLootDarkElixir] / $bUnityDonationCost)
				SetLog("Reducing " & $g_asTroopNames[$iTroopIndex] & " donation to " & $Quant)
			EndIf
		EndIf
	EndIf

	; Detect the Troops Slot
	If $g_bDebugOCRdonate Then
		Local $oldDebugOcr = $g_bDebugOcr
		$g_bDebugOcr = True
	EndIf

	$Slot = DetectSlotTroop($iTroopIndex, $bNewSystemToDonate)
	$detectedSlot = $Slot
	If $g_bDebugOCRdonate Then $g_bDebugOcr = $oldDebugOcr

	; figure out row/position
	If $Slot < 0 Or $Slot > 13 Then
		SetDebugLog("Invalid slot # found = " & $Slot & " for " & $g_asTroopNames[$iTroopIndex], $COLOR_ERROR)
		Return
	EndIf
	If $g_bDebugSetLog Then SetDebugLog("slot found = " & $Slot & ", " & $g_asTroopNames[$iTroopIndex], $COLOR_DEBUG)
	$donaterow = 1 ;first row of troops
	$donateposinrow = $Slot
	If $Slot >= 7 And $Slot <= 13 Then
		$donaterow = 2 ;second row of troops
		$Slot = $Slot - 7
		$donateposinrow = $Slot
		$YComp = 87 ; correct 860x780
	EndIf

	; Verify if the type of troop to donate exists
	SetLog("Troops Condition Matched", $COLOR_OLIVE)
	WaitForClanMessage("Donate", $g_iDonationWindowY + 158 + $YComp - 10, $g_iDonationWindowY + 158 + $YComp + 10)
	If _ColorCheck(_GetPixelColor($g_iDonationWindowX + 30 + ($Slot * 68), $g_iDonationWindowY + 158 + $YComp, True), Hex(0x4079B8, 6), 20) Or _
			_ColorCheck(_GetPixelColor($g_iDonationWindowX + 30 + 5 + ($Slot * 68), $g_iDonationWindowY + 159 + $YComp, True), Hex(0x4079B8, 6), 20) Or _
			_ColorCheck(_GetPixelColor($g_iDonationWindowX + 30 + 10 + ($Slot * 68), $g_iDonationWindowY + 160 + $YComp, True), Hex(0x4079B8, 6), 20) Or _ ; check for 'blue'
			_ColorCheck(_GetPixelColor($g_iDonationWindowX + 30 + ($Slot * 68), $g_iDonationWindowY + 158 + $YComp, True), Hex(0x810D0E, 6), 20) Or _
			_ColorCheck(_GetPixelColor($g_iDonationWindowX + 30 + 5 + ($Slot * 68), $g_iDonationWindowY + 159 + $YComp, True), Hex(0x810D0E, 6), 20) Or _
			_ColorCheck(_GetPixelColor($g_iDonationWindowX + 30 + 10 + ($Slot * 68), $g_iDonationWindowY + 160 + $YComp, True), Hex(0x810D0E, 6), 20) Then ; check for 'STroups Red'

		If $g_bDebugOCRdonate Then
			SetLog("donate", $COLOR_ERROR)
			SetLog("row: " & $donaterow, $COLOR_ERROR)
			SetLog("pos in row: " & $donateposinrow, $COLOR_ERROR)
			SetLog("coordinate: " & $g_iDonationWindowX + 43 + ($Slot * 68) & "," & $g_iDonationWindowY + 117 + $YComp, $COLOR_ERROR)
			SaveDebugImage("LiveDonateCC-r" & $donaterow & "-c" & $donateposinrow & "-" & $g_asTroopNames[$iTroopIndex] & "_")
		EndIf

		SetLog("Donating " & $Quant & " " & ($Quant > 1 ? $g_asTroopNamesPlural[$iTroopIndex] : $g_asTroopNames[$iTroopIndex]) & ($bDonateAll ? " (to all requests)" : ""), $COLOR_SUCCESS)
		SetLog("Cost : " & _NumberFormat($Quant * $bUnityDonationCost) & " " & ($bIsDarkElixir = True ? "Dark Elixir" : "Elixir"), $COLOR_SUCCESS)

		For $i = 0 To ($Quant - 1)
			If _ColorCheck(_GetPixelColor($g_iDonationWindowX + 30 + ($Slot * 68), $g_iDonationWindowY + 159 + $YComp, True), Hex(0x6F6F6F, 6), 20) Or _
					Not _ColorCheck(_GetPixelColor($g_iDonationWindowX, $g_iDonationWindowY + 100, True), Hex(0xE7E7E7, 6), 10) Then
				$Quant = $i + 1
				ExitLoop
			EndIf
			Local $g_iTrainClickDelayfinal = Random($DELAYDONATECC5 - 5, $DELAYDONATECC5 + 5, 1)     ; 15ms +/- 5 ms
			PureClickTrain($g_iDonationWindowX + 43 + ($Slot * 68), $g_iDonationWindowY + 117 + $YComp, 1, $g_iTrainClickDelayfinal)     ;Click once.
		Next
		$g_bFullArmy = False
		If $g_iCommandStop = 3 Then $g_iCommandStop = 0

		; Adjust Values for donated troops to prevent a Double ghost donate to stats and train
		If $iTroopIndex >= $eTroopBarbarian And $iTroopIndex <= $eTroopFurnace Then
			;Reduce iTotalDonateCapacity by troops donated
			$g_iTotalDonateTroopCapacity -= ($Quant * $g_aiTroopSpace[$iTroopIndex])
			;If donated max allowed troop qty set $g_bSkipDonTroops = True
			If $g_iDonTroopsLimit = $Quant Then
				$g_bSkipDonTroops = True
			EndIf
		EndIf

		; Assign the donated quantity troops to train : $Don $g_asTroopName
		$g_aiDonateTroops[$iTroopIndex] += $Quant
		$g_aiDonateStatsTroops[$iTroopIndex][0] += $Quant
		If $bIsDarkElixir Then
			$g_aiCurrentLoot[$eLootDarkElixir] -= $Quant * $bUnityDonationCost
		Else
			$g_aiCurrentLoot[$eLootElixir] -= $Quant * $bUnityDonationCost
		EndIf
		UpdateStats()

	Else
		Local $Text = "Unable to donate " & ($Quant > 1 ? $g_asTroopNamesPlural[$iTroopIndex] : $g_asTroopNames[$iTroopIndex]) & ".Donate screen not visible, will retry next run.", $LocalColor = $COLOR_ERROR
		If _ColorCheck(_GetPixelColor($g_iDonationWindowX + 30 + ($Slot * 68), $g_iDonationWindowY + 159 + $YComp, True), Hex(0x6F6F6F, 6), 20) Or _       ; Dark Gray from Queued Spells
				_ColorCheck(_GetPixelColor($g_iDonationWindowX + 30 + ($Slot * 68), $g_iDonationWindowY + 159 + $YComp, True), Hex(0xDADAD5, 6), 20) Then ; Light Gray from Empty Slots
			$Text = "No " & ($Quant > 1 ? $g_asTroopNamesPlural[$iTroopIndex] : $g_asTroopNames[$iTroopIndex]) & " available to donate.."
			$LocalColor = $COLOR_INFO
		EndIf
		SetLog($Text, $LocalColor)
	EndIf
EndFunc   ;==>DonateTroopType

Func DonateSpellType(Const $iSpellIndex, $Quant = 0, Const $bDonateAll = False, $bNewSystemToDonate = True)
	Local $Slot = -1, $detectedSlot = -1
	Local $YComp = 0, $donaterow = -1
	Local $donateposinrow = -1
	Local $bUnityDonationCost = 0

	If $g_iTotalDonateSpellCapacity = 0 Then Return
	If $g_bDebugSetLog Then SetDebugLog("DonateSpellType Start: " & $g_asSpellNames[$iSpellIndex], $COLOR_DEBUG)

	; Space to donate spell?
	$g_iDonSpellsQuantityAv = Floor($g_iTotalDonateSpellCapacity / $g_aiSpellSpace[$iSpellIndex])
	If $g_iDonSpellsQuantityAv < 1 Then
		SetLog("Sorry Chief! " & $g_asSpellNames[$iSpellIndex] & " spells don't fit in the remaining space!")
		Return
	EndIf

	Local $g_iDonSpellsLimitClan = 0
	WaitForClanMessage("Donate", $g_iDonationWindowY + 262, $g_iDonationWindowY + 278)
	Local $g_iDonSpellsLimitClanOCR = getOcrAndCapture("coc-t-lim", $g_iDonationWindowX + 92, $g_iDonationWindowY + 267, 30, 14, True)
	Local $aTempDonSpellsLimitClan = StringSplit($g_iDonSpellsLimitClanOCR, "#", $STR_NOCOUNT)
	If UBound($aTempDonSpellsLimitClan) = 2 Then $g_iDonSpellsLimitClan = $aTempDonSpellsLimitClan[1] - $aTempDonSpellsLimitClan[0]
	If ($g_iDonSpellsLimitClan <> "" Or $g_iDonSpellsLimitClan = 0) And Number($g_iDonSpellsLimitClan) <> Number($iDonSpellsLimit) Then $iDonSpellsLimit = $g_iDonSpellsLimitClan

	If $Quant = 0 Or $Quant > _Min(Number($g_iDonSpellsQuantityAv), Number($iDonSpellsLimit)) Then $Quant = _Min(Number($g_iDonSpellsQuantityAv), Number($iDonSpellsLimit))

	Local $bIsDarkElixir = False
	If $iSpellIndex >= $eSpellLightning And $iSpellIndex <= $eSpellRevive Then
		$bUnityDonationCost = 1000 * $g_aiSpellsDonationCost[$iSpellIndex]
		If Number($Quant * $bUnityDonationCost) > $g_aiCurrentLoot[$eLootElixir] Then
			SetLog("Not enough Elixir to donate " & $Quant & " " & $g_asSpellNames[$iSpellIndex])
			If $g_aiCurrentLoot[$eLootElixir] / $bUnityDonationCost > 0 Then
				$Quant = Floor($g_aiCurrentLoot[$eLootElixir] / $bUnityDonationCost)
				SetLog("Reducing " & $g_asSpellNames[$iSpellIndex] & " donation to " & $Quant)
			EndIf
		EndIf
	ElseIf $iSpellIndex >= $eSpellPoison And $iSpellIndex <= $eSpellOvergrowth Then
		$bIsDarkElixir = True
		$bUnityDonationCost = $g_aiSpellsDonationCost[$iSpellIndex]
		If Number($Quant * $bUnityDonationCost) > $g_aiCurrentLoot[$eLootDarkElixir] Then
			SetLog("Not enough Elixir to donate " & $Quant & " " & $g_asSpellNames[$iSpellIndex])
			If $g_aiCurrentLoot[$eLootDarkElixir] / $bUnityDonationCost > 0 Then
				$Quant = Floor($g_aiCurrentLoot[$eLootDarkElixir] / $bUnityDonationCost)
				SetLog("Reducing " & $g_asSpellNames[$iSpellIndex] & " donation to " & $Quant)
			EndIf
		EndIf
	EndIf

	; Detect the Spells Slot
	If $g_bDebugOCRdonate Then
		Local $oldDebugOcr = $g_bDebugOcr
		$g_bDebugOcr = True
	EndIf

	$Slot = DetectSlotSpell($iSpellIndex, $bNewSystemToDonate)
	$detectedSlot = $Slot
	If $g_bDebugSetLog Then SetDebugLog("slot found = " & $Slot, $COLOR_DEBUG)
	If $g_bDebugOCRdonate Then $g_bDebugOcr = $oldDebugOcr

	If $Slot = -1 Then Return

	; figure out row/position
	$donaterow = 1 ;first row of troops
	$donateposinrow = $Slot

	SetLog("Spells Condition Matched", $COLOR_OLIVE)
	WaitForClanMessage("Donate", $g_iDonationWindowY + 366 + $YComp - 10, $g_iDonationWindowY + 366 + $YComp + 10)
	If _ColorCheck(_GetPixelColor($g_iDonationWindowX + 30 + ($Slot * 68), $g_iDonationWindowY + 366, True), Hex(0x6F47C1, 6), 20) Or _ ;
			_ColorCheck(_GetPixelColor($g_iDonationWindowX + 30 + 5 + ($Slot * 68), $g_iDonationWindowY + 367, True), Hex(0x6F47C1, 6), 20) Or _
			_ColorCheck(_GetPixelColor($g_iDonationWindowX + 30 + 10 + ($Slot * 68), $g_iDonationWindowY + 367, True), Hex(0x6F47C1, 6), 20) Then ; check for 'purple'

		If $g_bDebugOCRdonate Then
			SetLog("donate", $COLOR_ERROR)
			SetLog("row: " & $donaterow, $COLOR_ERROR)
			SetLog("pos in row: " & $donateposinrow, $COLOR_ERROR)
			SetLog("coordinate: " & $g_iDonationWindowX + 43 + ($Slot * 68) & "," & $g_iDonationWindowY + 324, $COLOR_ERROR)
			SaveDebugImage("LiveDonateCC-r" & $donaterow & "-c" & $donateposinrow & "-" & $g_asSpellNames[$iSpellIndex] & "_")
		EndIf
		If Not $g_bDebugOCRdonate Then

			SetLog("Donating " & $Quant & " " & $g_asSpellNames[$iSpellIndex] & " Spell" & ($Quant > 1 ? "s" : "") & ($bDonateAll ? " (to all requests)" : ""), $COLOR_GREEN)
			SetLog("Cost : " & _NumberFormat($Quant * $bUnityDonationCost) & " " & ($bIsDarkElixir = True ? "Dark Elixir" : "Elixir"), $COLOR_SUCCESS)

			For $i = 0 To ($Quant - 1)
				If _ColorCheck(_GetPixelColor($g_iDonationWindowX + 30 + ($Slot * 68), $g_iDonationWindowY + 367, True), Hex(0x6F6F6F, 6), 20) Or _
						Not _ColorCheck(_GetPixelColor($g_iDonationWindowX, $g_iDonationWindowY + 100, True), Hex(0xE7E7E7, 6), 10) Then
					$Quant = $i + 1
					ExitLoop
				EndIf
				Click($g_iDonationWindowX + 43 + ($Slot * 68), $g_iDonationWindowY + 324, 1, $DELAYDONATECC6, "#0600")
			Next
			$g_bFullArmySpells = False
			$g_bFullArmy = False
			If $g_iCommandStop = 3 Then $g_iCommandStop = 0

		EndIf

		; Adjust Values for donated spells to prevent a Double ghost donate to stats and train
		If $iSpellIndex >= $eSpellLightning And $iSpellIndex <= $eSpellOvergrowth Then
			$g_iTotalDonateSpellCapacity -= ($Quant * $g_aiSpellSpace[$iSpellIndex])
			;If donated max allowed troop qty set $g_bSkipDonSpells = True
			If $iDonSpellsLimit = $Quant Then
				$g_bSkipDonSpells = True
			EndIf
		EndIf

		; Assign the donated quantity spells to brew : $Don $g_asSpellName
		$g_aiDonateSpells[$iSpellIndex] += $Quant
		$g_aiDonateStatsSpells[$iSpellIndex][0] += $Quant
		If $bIsDarkElixir Then
			$g_aiCurrentLoot[$eLootDarkElixir] -= $Quant * $bUnityDonationCost
		Else
			$g_aiCurrentLoot[$eLootElixir] -= $Quant * $bUnityDonationCost
		EndIf
		UpdateStats()

	Else
		Local $Text = "Unable to donate " & $g_asSpellNames[$iSpellIndex] & ".Donate screen not visible, will retry next run.", $LocalColor = $COLOR_ERROR
		If _ColorCheck(_GetPixelColor($g_iDonationWindowX + 30 + 5 + ($Slot * 68), $g_iDonationWindowY + 367 + $YComp, True), Hex(0x606060, 6), 20) Or _       ; Dark Gray from Queued Spells
				_ColorCheck(_GetPixelColor($g_iDonationWindowX + 30 + 5 + ($Slot * 68), $g_iDonationWindowY + 367 + $YComp, True), Hex(0xDADAD5, 6), 20) Then ; Light Gray from Empty Slots
			$Text = "No " & $g_asSpellNames[$iSpellIndex] & " available to donate.."
			$LocalColor = $COLOR_INFO
		EndIf
		SetLog($Text, $LocalColor)
	EndIf
EndFunc   ;==>DonateSpellType

Func DonateSiegeType(Const $iSiegeIndex, $Quant = 0, $bDonateAll = False, $bNewSystemToDonate = True)
	Local $Slot = -1, $detectedSlot = -1
	Local $YComp = 0, $donaterow = -1
	Local $donateposinrow = -1
	Local $sTextToAll = ""
	Local $bUnityDonationCost = 0

	If $g_iTotalDonateSiegeMachineCapacity < 1 Then Return
	If $g_bDebugSetLog Then SetDebugLog("DonateSiegeType Start: " & $g_asSiegeMachineNames[$iSiegeIndex], $COLOR_DEBUG)

	If $Quant = 0 Then $Quant = Number($g_iTotalDonateSiegeMachineCapacity)

	$bUnityDonationCost = 1000 * $g_aiSiegesDonationCost[$iSiegeIndex]
	If Number($Quant * $bUnityDonationCost) > $g_aiCurrentLoot[$eLootElixir] Then
		SetLog("Not enough Elixir to donate " & $Quant & " " & $g_asSiegeMachineNames[$iSiegeIndex])
		If $g_aiCurrentLoot[$eLootElixir] / $bUnityDonationCost > 0 Then
			$Quant = Floor($g_aiCurrentLoot[$eLootElixir] / $bUnityDonationCost)
			SetLog("Reducing " & $g_asSiegeMachineNames[$iSiegeIndex] & " donation to " & $Quant)
		EndIf
	EndIf

	$Slot = DetectSlotSiege($iSiegeIndex, $bNewSystemToDonate)
	If $Slot = -1 Then
		SetLog("No " & $g_asSiegeMachineNames[$iSiegeIndex] & " available to donate..", $COLOR_ERROR)
		Return
	EndIf

	; figure out row/position
	If $Slot < 0 Or $Slot > 13 Then
		SetLog("Invalid slot # found = " & $Slot & " for " & $g_asSiegeMachineNames[$iSiegeIndex], $COLOR_ERROR)
		Return
	EndIf

	If $g_bDebugSetLog Then SetDebugLog("slot found = " & $Slot & ", " & $g_asSiegeMachineNames[$iSiegeIndex], $COLOR_DEBUG)
	$donaterow = 1 ;first row of troops
	$donateposinrow = $Slot
	If $Slot >= 7 And $Slot <= 13 Then
		$donaterow = 2 ;second row of troops
		$Slot = $Slot - 7
		$donateposinrow = $Slot
		$YComp = 87 ; correct 860x780
	EndIf

	If $g_bDebugOCRdonate Then
		SetLog("donate", $COLOR_ERROR)
		SetLog("row: " & $donaterow, $COLOR_ERROR)
		SetLog("pos in row: " & $donateposinrow, $COLOR_ERROR)
		SetLog("coordinate: " & $g_iDonationWindowX + 43 + ($Slot * 68) & "," & $g_iDonationWindowY + 117 + $YComp, $COLOR_ERROR)
		SaveDebugImage("LiveDonateCC-r" & $donaterow & "-c" & $donateposinrow & "-" & $g_asSiegeMachineNames[$iSiegeIndex] & "_")
	EndIf

	SetLog("Sieges Condition Matched", $COLOR_OLIVE)
	WaitForClanMessage("Donate", $g_iDonationWindowY + 158 + $YComp - 10, $g_iDonationWindowY + 158 + $YComp + 10)
	If _ColorCheck(_GetPixelColor($g_iDonationWindowX + 30 + ($Slot * 68), $g_iDonationWindowY + 158 + $YComp, True), Hex(0x4079B8, 6), 20) Or _
			_ColorCheck(_GetPixelColor($g_iDonationWindowX + 30 + 5 + ($Slot * 68), $g_iDonationWindowY + 159 + $YComp, True), Hex(0x4079B8, 6), 20) Or _
			_ColorCheck(_GetPixelColor($g_iDonationWindowX + 30 + 10 + ($Slot * 68), $g_iDonationWindowY + 160 + $YComp, True), Hex(0x4079B8, 6), 20) Then ; check for 'blue'

		;	Local $RemainingSiegesToDonate = getOcrAndCapture("coc-t-d", $g_iDonationWindowX + 28 + ($Slot * 68), $g_iDonationWindowY + 98 + $YComp, 35, 14, True)
		;	If Number($RemainingSiegesToDonate) < $Quant Then $Quant = Number($RemainingSiegesToDonate)

		SetLog("Donating " & $Quant & " " & ($g_asSiegeMachineNames[$iSiegeIndex]) & ($bDonateAll ? " (to all requests)" : ""), $COLOR_GREEN)
		SetLog("Cost : " & _NumberFormat($Quant * $bUnityDonationCost) & " Elixir", $COLOR_SUCCESS)

		For $i = 0 To ($Quant - 1)
			Click($g_iDonationWindowX + 43 + ($Slot * 68), $g_iDonationWindowY + 117 + $YComp, 1, $DELAYDONATECC6, "#0600")
		Next
		$g_bFullArmy = False
		If $g_iCommandStop = 3 Then $g_iCommandStop = 0

		; Adjust Values for donated spells to prevent a Double ghost donate to stats and train
		If $iSiegeIndex >= $eSiegeWallWrecker And $iSiegeIndex <= $eSiegeTroopLauncher Then
			$g_iTotalDonateSiegeMachineCapacity -= ($Quant * $g_aiSiegeMachineSpace[$iSiegeIndex])
		EndIf

		; Assign the donated quantity sieges to train : $Don $g_asSiegeMachineShortNames
		$g_aiDonateSiegeMachines[$iSiegeIndex] += $Quant
		$g_aiDonateStatsSieges[$iSiegeIndex][0] += $Quant
		$g_aiCurrentLoot[$eLootElixir] -= $Quant * $bUnityDonationCost
		UpdateStats()

	Else
		SetLog("No " & $g_asSiegeMachineNames[$iSiegeIndex] & " available to donate..", $COLOR_ERROR)
	EndIf
EndFunc   ;==>DonateSiegeType

Func DonateWindow($aiDonateButton, $bOpen = True)
	If $g_bDebugSetLog And $bOpen Then SetLog("DonateWindow Open Start", $COLOR_DEBUG)
	If $g_bDebugSetLog And Not $bOpen Then SetLog("DonateWindow Close Start", $COLOR_DEBUG)

	If Not $bOpen Then ; close window and exit
		If _Sleep($DELAYDONATEWINDOW1) Then Return
		ClickP($aiDonateButton)
		If _Sleep(500) Then Return
		If $g_bDebugSetLog Then SetDebugLog("DonateWindow Close Exit", $COLOR_DEBUG)
		Return
	EndIf

	WaitForClanMessage("Donate", $aiDonateButton[1] - 20, $aiDonateButton[1] + 20, False)

	Local $aiSearchArray[4] = [$aiDonateButton[0] - 20, $aiDonateButton[1] - 20, $aiDonateButton[0] + 20, $aiDonateButton[1] + 20]
	Local $aiDonateButtonCheck = decodeSingleCoord(findImage("Donate Button", $g_sImgDonateCC & "DonateButton*", GetDiamondFromArray($aiSearchArray), 1, True, Default))

	If IsArray($aiDonateButtonCheck) And UBound($aiDonateButtonCheck, 1) > 1 Then
		ClickP($aiDonateButton)
	Else
		If $g_bDebugSetLog Then SetDebugLog("Could not find the Donate Button!", $COLOR_DEBUG)
		Return False
	EndIf

	If _Sleep($DELAYDONATEWINDOW1) Then Return

	WaitForClanMessage("Donate", $aiDonateButton[1] - 20, $aiDonateButton[1] + 20)

	;	Local $icount = 0
	;	While Not (_ColorCheck(_GetPixelColor(356, $aiDonateButton[1], True, "DonateWindow"), Hex(0xFFFFFF, 6), 0))
	;		If _Sleep($DELAYDONATEWINDOW2) Then Return
	;		ForceCaptureRegion()
	;		If _ColorCheck(_GetPixelColor(376, $aiDonateButton[1], True, "DonateWindow"), Hex(0xFFFFFF, 6), 0) Then ExitLoop
	;		$icount += 1
	;		If $icount = 20 Then ExitLoop
	;	WEnd

	; Determinate the right position of the new Donation Window
	; Will search the first pure white color at Top and Left of donate window.
	$g_iDonationWindowY = 0
	$g_iDonationWindowX = 0

	WaitForClanMessage("Donate")

	Local $aDonationWindowX = _MultiPixelSearch2(330, $aiDonateButton[1] - 12, 340, $aiDonateButton[1] - 8, 1, 1, Hex(0xE7E7E7, 6), 5)
	Local $aDonationWindowY = _MultiPixelSearch2(605, 0, 610, $g_iDEFAULT_HEIGHT, 1, 1, Hex(0x8B7868, 6), 5)
	If IsArray($aDonationWindowX) And IsArray($aDonationWindowY) Then
		$g_iDonationWindowX = $aDonationWindowX[0]
		$g_iDonationWindowY = $aDonationWindowY[1]
		If $g_bDebugSetLog Then SetDebugLog("$g_iDonationWindowX: " & $g_iDonationWindowX, $COLOR_DEBUG)
		If $g_bDebugSetLog Then SetDebugLog("$g_iDonationWindowY: " & $g_iDonationWindowY, $COLOR_DEBUG)
	Else
		SetLog("Could not find the Donate Window!", $COLOR_ERROR)
		Return False
	EndIf

	If $g_bDebugSetLog Then SetDebugLog("DonateWindow Open Exit", $COLOR_DEBUG)
	Return True
EndFunc   ;==>DonateWindow

Func DonateWindowCap(ByRef $g_bSkipDonTroops, ByRef $g_bSkipDonSpells)
	If $g_bDebugSetLog Then SetDebugLog("DonateCapWindow Start", $COLOR_DEBUG)
	;read troops capacity
	If Not $g_bSkipDonTroops Then
		Local $sReadCCTroopsCap = getCastleDonateCap($g_iDonationWindowX + 99, $g_iDonationWindowY + 63) ; use OCR to get donated/total capacity
		SetDebugLog("$sReadCCTroopsCap: " & $sReadCCTroopsCap, $COLOR_DEBUG)

		Local $aTempReadCCTroopsCap = StringSplit($sReadCCTroopsCap, "#", $STR_NOCOUNT)
		If UBound($aTempReadCCTroopsCap) = 2 Then
			;  Note - stringsplit always returns an array even if no values split!
			SetDebugLog("$aTempReadCCTroopsCap splitted :" & $aTempReadCCTroopsCap[0] & "/" & $aTempReadCCTroopsCap[1], $COLOR_DEBUG)
			If UBound($aTempReadCCTroopsCap) = 2 Then
				$g_iDonTroopsAv = $aTempReadCCTroopsCap[0]
				$g_iDonTroopsLimit = $aTempReadCCTroopsCap[1]
			EndIf
		Else
			SetLog("Error reading the Castle Troop Capacity", $COLOR_ERROR) ; log if there is read error
			$g_iDonTroopsAv = 0
			$g_iDonTroopsLimit = 0
		EndIf
	EndIf

	If Not $g_bSkipDonSpells Then
		Local $sReadCCSpellsCap = getCastleDonateCap($g_iDonationWindowX + 92, $g_iDonationWindowY + 267) ; use OCR to get donated/total capacity
		SetDebugLog("$sReadCCSpellsCap: " & $sReadCCSpellsCap, $COLOR_DEBUG)
		Local $aTempReadCCSpellsCap = StringSplit($sReadCCSpellsCap, "#", $STR_NOCOUNT)
		If UBound($aTempReadCCSpellsCap) = 2 Then
			;  Note - stringsplit always returns an array even if no values split!
			If $g_bDebugSetLog Then SetDebugLog("$aTempReadCCSpellsCap splitted :" & $aTempReadCCSpellsCap[0] & "/" & $aTempReadCCSpellsCap[1], $COLOR_DEBUG)
			If UBound($aTempReadCCSpellsCap) = 2 Then
				$g_iDonSpellsAv = $aTempReadCCSpellsCap[0]
				$iDonSpellsLimit = $aTempReadCCSpellsCap[1]
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

	If $g_bDebugSetLog Then
		SetDebugLog("$g_bSkipDonTroops: " & $g_bSkipDonTroops, $COLOR_DEBUG)
		SetDebugLog("$g_bSkipDonSpells: " & $g_bSkipDonSpells, $COLOR_DEBUG)
		Select
			Case $g_bSkipDonTroops And $g_bSkipDonSpells And $g_iDonTroopsAv < $g_iDonTroopsLimit And $g_iDonSpellsAv < $iDonSpellsLimit
				SetDebugLog("Donate Troops: " & $g_iDonTroopsAv & "/" & $g_iDonTroopsLimit & ", Spells: " & $g_iDonSpellsAv & "/" & $iDonSpellsLimit)
			Case Not $g_bSkipDonSpells And $g_iDonTroopsAv < $g_iDonTroopsLimit And $g_iDonSpellsAv = $iDonSpellsLimit
				SetDebugLog("Donate Troops: " & $g_iDonTroopsAv & "/" & $g_iDonTroopsLimit)
			Case Not $g_bSkipDonTroops And $g_iDonTroopsAv = $g_iDonTroopsLimit And $g_iDonSpellsAv < $iDonSpellsLimit
				SetDebugLog("Donate Spells: " & $g_iDonSpellsAv & "/" & $iDonSpellsLimit)
		EndSelect
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
	Local $bDonateSpell = ($g_aiPrepDon[2] = 1 Or $g_aiPrepDon[3] = 1)
	Local $bDonateSiege = ($g_aiPrepDon[4] = 1 Or $g_aiPrepDon[5] = 1)
	SetDebugLog("$g_aiPrepDon[2]: " & $g_aiPrepDon[2] & ", $g_aiPrepDon[3]: " & $g_aiPrepDon[3] & ", $g_iCurrentSpells: " & $g_iCurrentSpells & ", $bDonateSpell: " & $bDonateSpell)
	SetDebugLog("$g_aiPrepDon[4]: " & $g_aiPrepDon[4] & ", $g_aiPrepDon[5]: " & $g_aiPrepDon[5] & ", $bDonateSiege: " & $bDonateSiege)

	; Verify with OCR the Donation Clan Castle capacity
	If $g_bDebugSetLog Then SetDebugLog("Start dual getOcrSpaceCastleDonate", $COLOR_DEBUG)

	;Button Image is a little bit lower than the Capacity Numbers, adjusting for all here
	$aiDonateButton[1] -= 10

	$sCapTroops = getOcrSpaceCastleDonate(61, $aiDonateButton[1])
	Local $IsWoSiege = StringRight($sCapTroops, 1)
	If StringInStr($sCapTroops, "#") And $IsWoSiege <> "#" Then ;CC got Troops & Spells & Siege Machine
		$sCapSpells = $bDonateSpell ? getOcrSpaceCastleDonateShort(142, $aiDonateButton[1]) : -1
		$sCapSiegeMachine = $bDonateSiege ? getOcrSpaceCastleDonateShort(202, $aiDonateButton[1]) : -1
	Else
		$sCapTroops = getOcrSpaceCastleDonate(84, $aiDonateButton[1])
		If StringRegExp($sCapTroops, "#([0-9]{2})") = 1 Then ; CC got Troops
			$sCapSpells = $bDonateSpell ? getOcrSpaceCastleDonateShort(200, $aiDonateButton[1]) : -1 ; CC got Spells ?
			If $sCapSpells = "" Then $sCapSpells = -1 ; CC got Troops Only ?
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
			If $g_bDebugSetLog Then SetDebugLog("$aTempCapTroops splitted :" & $aTempCapTroops[1] & "/" & $aTempCapTroops[2], $COLOR_DEBUG)
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
				If $g_bDebugSetLog Then SetDebugLog("$aTempCapSpells splitted :" & $aTempCapSpells[1] & "/" & $aTempCapSpells[2], $COLOR_DEBUG)
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
				If $g_bDebugSetLog Then SetDebugLog("$aTempCapSiegeMachine splitted :" & $aTempCapSiegeMachine[1] & "/" & $aTempCapSiegeMachine[2], $COLOR_DEBUG)
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

Func DetectSlotTroop(Const $iTroopIndex, $bNewSystemToDonate = True)
	If _Sleep(500) Then Return
	Local $FullTemp, $bLoop = 0

	If Not $bNewSystemToDonate Then
		Local $sBarbTile = @ScriptDir & "\imgxml\DonateCC\Troops\Barb*"
		Local $aBarbTile = decodeSingleCoord(findImage("BarbTile", $sBarbTile, GetDiamondFromRect2(338, $g_iDonationWindowY + 83, 407, $g_iDonationWindowY + 254), 1, True))
		If IsArray($aBarbTile) And UBound($aBarbTile, 1) = 2 And _ColorCheck(_GetPixelColor(339, $g_iDonationWindowY + 116, True), Hex(0xD2D2CD, 6), 5) Then
			;Do nothing
		Else
			$bLoop = 0
			While 1
				ClickDrag(367, $g_iDonationWindowY + 167, 840, $g_iDonationWindowY + 167)
				If _Sleep(1000) Then Return
				$aBarbTile = decodeSingleCoord(findImage("BarbTile", $sBarbTile, GetDiamondFromRect2(338, $g_iDonationWindowY + 83, 407, $g_iDonationWindowY + 254), 1, True))
				If IsArray($aBarbTile) And UBound($aBarbTile, 1) = 2 And _ColorCheck(_GetPixelColor(339, $g_iDonationWindowY + 116, True), Hex(0xD2D2CD, 6), 5) Then ExitLoop
				$bLoop += 1
				If $bLoop = 5 Then ExitLoop
			WEnd
		EndIf

		$bLoop = 0
		While 1

			For $Slot = 0 To 6
				Local $x = $g_iDonationWindowX + 12 + (68 * $Slot)
				Local $y = $g_iDonationWindowY + 83
				Local $x1 = $x + 63
				Local $y1 = $y + 62

				$FullTemp = SearchImgloc($g_sImgDonateTroops, $x, $y, $x1, $y1)

				If IsArray($FullTemp) And UBound($FullTemp) > 0 Then

					If $g_bDebugSetLog Then SetDebugLog("Troop Slot: " & $Slot & " SearchImgloc returned:" & $FullTemp[0] & ".", $COLOR_DEBUG)

					If StringInStr($FullTemp[0], "empty") > 0 Then ExitLoop

					If $FullTemp[0] <> "" Then
						Local $iFoundTroopIndex = TroopIndexLookup($FullTemp[0])
						For $i = $eTroopBarbarian To $eTroopCount - 1
							If $iFoundTroopIndex = $i Then
								If $g_bDebugSetLog Then SetDebugLog("Detected " & $g_asTroopNames[$i], $COLOR_DEBUG)
								If $iTroopIndex = $i Then Return $Slot
								ExitLoop
							EndIf
							If $i = $eTroopCount - 1 Then ; detection failed
								If $g_bDebugSetLog Then SetDebugLog("Slot: " & $Slot & "Troop Detection Failed", $COLOR_DEBUG)
							EndIf
						Next
					EndIf

				EndIf

			Next

			For $Slot = 7 To 13
				Local $x = $g_iDonationWindowX + 12 + (68 * ($Slot - 7))
				Local $y = $g_iDonationWindowY + 169
				Local $x1 = $x + 63
				Local $y1 = $y + 62

				$FullTemp = SearchImgloc($g_sImgDonateTroops, $x, $y, $x1, $y1)

				If IsArray($FullTemp) And UBound($FullTemp) > 0 Then

					If $g_bDebugSetLog Then SetDebugLog("Troop Slot: " & $Slot & " SearchImgloc returned:" & $FullTemp[0] & ".", $COLOR_DEBUG)

					If StringInStr($FullTemp[0], "empty") > 0 Then ExitLoop

					If $FullTemp[0] <> "" Then
						For $i = $eTroopBarbarian To $eTroopCount - 1
							Local $iFoundTroopIndex = TroopIndexLookup($FullTemp[0])
							If $iFoundTroopIndex = $i Then
								If $g_bDebugSetLog Then SetDebugLog("Detected " & $g_asTroopNames[$i], $COLOR_DEBUG)
								If $iTroopIndex = $i Then Return $Slot
								ExitLoop
							EndIf
							If $i = $eTroopCount - 1 Then ; detection failed
								If $g_bDebugSetLog Then SetDebugLog("Slot: " & $Slot & " Troop Detection Failed", $COLOR_DEBUG)
							EndIf
						Next
					EndIf

				EndIf

			Next

			ClickDrag(800, $g_iDonationWindowY + 167, 327, $g_iDonationWindowY + 167)
			If _Sleep(Random(1500, 2000, 1)) Then Return
			$bLoop += 1
			If $bLoop = 5 Then ExitLoop

		WEnd

	Else

		For $Slot = 0 To 6
			Local $x = $g_iDonationWindowX + 12 + (68 * $Slot)
			Local $y = $g_iDonationWindowY + 83
			Local $x1 = $x + 63
			Local $y1 = $y + 62

			$FullTemp = SearchImgloc($g_sImgDonateTroops, $x, $y, $x1, $y1)

			If IsArray($FullTemp) And UBound($FullTemp) > 0 Then

				If $g_bDebugSetLog Then SetDebugLog("Troop Slot: " & $Slot & " SearchImgloc returned:" & $FullTemp[0] & ".", $COLOR_DEBUG)

				If StringInStr($FullTemp[0], "empty") > 0 Then ExitLoop

				If $FullTemp[0] <> "" Then
					Local $iFoundTroopIndex = TroopIndexLookup($FullTemp[0])
					For $i = $eTroopBarbarian To $eTroopCount - 1
						If $iFoundTroopIndex = $i Then
							If $g_bDebugSetLog Then SetDebugLog("Detected " & $g_asTroopNames[$i], $COLOR_DEBUG)
							If $iTroopIndex = $i Then Return $Slot
							ExitLoop
						EndIf
						If $i = $eTroopCount - 1 Then ; detection failed
							If $g_bDebugSetLog Then SetDebugLog("Slot: " & $Slot & "Troop Detection Failed", $COLOR_DEBUG)
						EndIf
					Next
				EndIf

			EndIf

		Next

		For $Slot = 7 To 13
			Local $x = $g_iDonationWindowX + 12 + (68 * ($Slot - 7))
			Local $y = $g_iDonationWindowY + 169
			Local $x1 = $x + 63
			Local $y1 = $y + 62

			$FullTemp = SearchImgloc($g_sImgDonateTroops, $x, $y, $x1, $y1)

			If IsArray($FullTemp) And UBound($FullTemp) > 0 Then

				If $g_bDebugSetLog Then SetDebugLog("Troop Slot: " & $Slot & " SearchImgloc returned:" & $FullTemp[0] & ".", $COLOR_DEBUG)

				If StringInStr($FullTemp[0], "empty") > 0 Then ExitLoop

				If $FullTemp[0] <> "" Then
					For $i = $eTroopBarbarian To $eTroopCount - 1
						Local $iFoundTroopIndex = TroopIndexLookup($FullTemp[0])
						If $iFoundTroopIndex = $i Then
							If $g_bDebugSetLog Then SetDebugLog("Detected " & $g_asTroopNames[$i], $COLOR_DEBUG)
							If $iTroopIndex = $i Then Return $Slot
							ExitLoop
						EndIf
						If $i = $eTroopCount - 1 Then ; detection failed
							If $g_bDebugSetLog Then SetDebugLog("Slot: " & $Slot & " Troop Detection Failed", $COLOR_DEBUG)
						EndIf
					Next
				EndIf

			EndIf

		Next

	EndIf

	Return -1

EndFunc   ;==>DetectSlotTroop

Func DetectSlotSpell(Const $iSpellIndex, $bNewSystemToDonate = True)
	If _Sleep(500) Then Return
	Local $FullTemp

	If Not $bNewSystemToDonate Then
		Local $sLightningTile = @ScriptDir & "\imgxml\DonateCC\Spells\Lightning*"
		Local $aLightningTile = decodeSingleCoord(findImage("LightningTile", $sLightningTile, GetDiamondFromRect2(338, $g_iDonationWindowY + 290, 407, $g_iDonationWindowY + 375), 1, True))
		If IsArray($aLightningTile) And UBound($aLightningTile, 1) = 2 And _ColorCheck(_GetPixelColor(339, $g_iDonationWindowY + 330, True), Hex(0xD2D2CD, 6), 5) Then $CCSpellsPage = 0

		DragCCSpellsBar($iSpellIndex, $CCSpellsPage)

		For $Slot = 0 To 6
			Local $x = $g_iDonationWindowX + 12 + (68 * $Slot)
			Local $y = $g_iDonationWindowY + 290
			Local $x1 = $x + 63
			Local $y1 = $y + 62

			$FullTemp = SearchImgloc($g_sImgDonateSpells, $x, $y, $x1, $y1)

			If IsArray($FullTemp) And UBound($FullTemp) > 0 Then

				SetDebugLog("Spell Slot: " & $Slot & " SearchImgloc returned:" & $FullTemp[0] & ".", $COLOR_DEBUG)

				If StringInStr($FullTemp[0], "empty") > 0 Then ExitLoop

				If $FullTemp[0] <> "" Then
					For $i = $eSpellLightning To $eSpellCount - 1
						Local $sTmp = StringLeft($g_asSpellNames[$i], 4)
						If StringInStr($FullTemp[0] & " ", $sTmp) > 0 Then
							If $g_bDebugSetLog Then SetDebugLog("Detected " & $g_asSpellNames[$i], $COLOR_DEBUG)
							If $iSpellIndex = $i Then Return $Slot
							ExitLoop
						EndIf
						If $i = $eSpellCount - 1 Then     ; detection failed
							If $g_bDebugSetLog Then SetDebugLog("Slot: " & $Slot & "Spell Detection Failed", $COLOR_DEBUG)
						EndIf
					Next
				EndIf

			EndIf

		Next

	Else

		For $Slot = 0 To 6
			Local $x = $g_iDonationWindowX + 12 + (68 * $Slot)
			Local $y = $g_iDonationWindowY + 290
			Local $x1 = $x + 63
			Local $y1 = $y + 62

			$FullTemp = SearchImgloc($g_sImgDonateSpells, $x, $y, $x1, $y1)

			If IsArray($FullTemp) And UBound($FullTemp) > 0 Then

				SetDebugLog("Spell Slot: " & $Slot & " SearchImgloc returned:" & $FullTemp[0] & ".", $COLOR_DEBUG)

				If StringInStr($FullTemp[0], "empty") > 0 Then ExitLoop

				If $FullTemp[0] <> "" Then
					For $i = $eSpellLightning To $eSpellCount - 1
						Local $sTmp = StringLeft($g_asSpellNames[$i], 4)
						If StringInStr($FullTemp[0] & " ", $sTmp) > 0 Then
							If $g_bDebugSetLog Then SetDebugLog("Detected " & $g_asSpellNames[$i], $COLOR_DEBUG)
							If $iSpellIndex = $i Then Return $Slot
							ExitLoop
						EndIf
						If $i = $eSpellCount - 1 Then ; detection failed
							If $g_bDebugSetLog Then SetDebugLog("Slot: " & $Slot & "Spell Detection Failed", $COLOR_DEBUG)
						EndIf
					Next
				EndIf

			EndIf

		Next

	EndIf

	Return -1

EndFunc   ;==>DetectSlotSpell

Func DragCCSpellsBar($iSpellIndex, ByRef $CCSpellsPage)
	Local $iY1
	Local $iY2
	Local $iPageTarget
	Local $bLoop = 0

	Switch $iSpellIndex
		Case $eSpellLightning To $eSpellInvisibility
			$iPageTarget = 0
		Case $eSpellRecall To $eSpellBat
			$iPageTarget = 1
		Case $eSpellOvergrowth
			$iPageTarget = 2
	EndSwitch

	While 1

		If $CCSpellsPage = $iPageTarget Then ExitLoop

		If $CCSpellsPage < $iPageTarget Then
			If $CCSpellsPage = 0 Then
				ClickDrag(800, $g_iDonationWindowY + 330, 327, $g_iDonationWindowY + 330)
				SetDebugLog("Moving from page 0 to 1")
			ElseIf $CCSpellsPage = 1 Then
				ClickDrag(600, $g_iDonationWindowY + 330, 500, $g_iDonationWindowY + 330)
				SetDebugLog("Moving from page 1 to 2")
			EndIf
			If _Sleep(Random(1500, 2000, 1)) Then Return
			If $CCSpellsPage = 1 Then
				If Not _ColorCheck(_GetPixelColor(820, 330 + $g_iMidOffsetY, True), Hex(0xD2D2CD, 6), 5) Then ContinueLoop
			EndIf
			$CCSpellsPage += 1
		EndIf

		If $CCSpellsPage > $iPageTarget Then
			If $CCSpellsPage = 2 Then
				ClickDrag(335 - 94, $g_iDonationWindowY + 330, 318, $g_iDonationWindowY + 330)
				SetDebugLog("Moving from page 2 to 1")
			Else
				ClickDrag(367, $g_iDonationWindowY + 330, 840, $g_iDonationWindowY + 330)
				SetDebugLog("Moving from page 1 to 0")
			EndIf
			If _Sleep(Random(1500, 2000, 1)) Then Return
			$CCSpellsPage -= 1
		EndIf

		$bLoop += 1
		If $bLoop = 10 Then ExitLoop

	WEnd

EndFunc   ;==>DragCCSpellsBar

Func DetectSlotSiege(Const $iSiegeIndex, $bNewSystemToDonate = True)
	If _Sleep(500) Then Return
	Local $FullTemp

	If Not $bNewSystemToDonate Then
		Local $bLoop = 0
		While 1
			If Not _ColorCheck(_GetPixelColor(820, $g_iDonationWindowY + 116, True), Hex(0xD2D2CD, 6), 5) Then
				ClickDrag(800, $g_iDonationWindowY + 167, 327, 376 + $g_iMidOffsetY)
				If _Sleep(Random(1500, 2000, 1)) Then Return
			Else
				ExitLoop
			EndIf
			$bLoop += 1
			If $bLoop > 5 Then ExitLoop
		WEnd

		For $Slot = 0 To 6
			Local $x = $g_iDonationWindowX + 12 + (68 * $Slot)
			Local $y = $g_iDonationWindowY + 83
			Local $x1 = $x + 63
			Local $y1 = $y + 62

			$FullTemp = SearchImgloc($g_sImgDonateSiege, $x, $y, $x1, $y1)

			If IsArray($FullTemp) And UBound($FullTemp) > 0 Then

				SetDebugLog("Siege Slot: " & $Slot & " SearchImgloc returned:" & $FullTemp[0] & ".", $COLOR_DEBUG)

				If StringInStr($FullTemp[0], "empty") > 0 Then ExitLoop

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

			EndIf

		Next

		For $Slot = 7 To 13
			Local $x = $g_iDonationWindowX + 12 + (68 * ($Slot - 7))
			Local $y = $g_iDonationWindowY + 169
			Local $x1 = $x + 63
			Local $y1 = $y + 62

			$FullTemp = SearchImgloc($g_sImgDonateSiege, $x, $y, $x1, $y1)
			SetDebugLog("Siege Slot: " & $Slot & " SearchImgloc returned:" & $FullTemp[0] & ".", $COLOR_DEBUG)

			If IsArray($FullTemp) And UBound($FullTemp) > 0 Then

				If StringInStr($FullTemp[0], "empty") > 0 Then ExitLoop

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

			EndIf

		Next

	Else

		For $Slot = 0 To 6
			Local $x = $g_iDonationWindowX + 12 + (68 * $Slot)
			Local $y = $g_iDonationWindowY + 83
			Local $x1 = $x + 63
			Local $y1 = $y + 62

			$FullTemp = SearchImgloc($g_sImgDonateSiege, $x, $y, $x1, $y1)

			If IsArray($FullTemp) And UBound($FullTemp) > 0 Then

				SetDebugLog("Siege Slot: " & $Slot & " SearchImgloc returned:" & $FullTemp[0] & ".", $COLOR_DEBUG)

				If StringInStr($FullTemp[0], "empty") > 0 Then ExitLoop

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

			EndIf

		Next

		For $Slot = 7 To 13
			Local $x = $g_iDonationWindowX + 12 + (68 * ($Slot - 7))
			Local $y = $g_iDonationWindowY + 169
			Local $x1 = $x + 63
			Local $y1 = $y + 62

			$FullTemp = SearchImgloc($g_sImgDonateSiege, $x, $y, $x1, $y1)
			SetDebugLog("Siege Slot: " & $Slot & " SearchImgloc returned:" & $FullTemp[0] & ".", $COLOR_DEBUG)

			If IsArray($FullTemp) And UBound($FullTemp) > 0 Then

				If StringInStr($FullTemp[0], "empty") > 0 Then ExitLoop

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

			EndIf

		Next

	EndIf

	Return -1
EndFunc   ;==>DetectSlotSiege

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
