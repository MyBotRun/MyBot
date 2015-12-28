; #FUNCTION# ====================================================================================================================
; Name ..........: DonateCC
; Description ...: This file includes functions to Donate troops
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Zax (2015)
; Modified ......: Safar46 (2015), Hervidero (2015-04), HungLe (2015-04), Sardo 2015-08
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $DonationWindowY

Func DonateCC($Check = False)

	Local $DonateTroop = BitOR($iChkDonateBarbarians, $iChkDonateArchers, $iChkDonateGiants, $iChkDonateGoblins, _
			$iChkDonateWallBreakers, $iChkDonateBalloons, $iChkDonateWizards, $iChkDonateHealers, _
			$iChkDonateDragons, $iChkDonatePekkas, $iChkDonateMinions, $iChkDonateHogRiders, _
			$iChkDonateValkyries, $iChkDonateGolems, $iChkDonateWitches, $iChkDonateLavaHounds, $iChkDonateCustom)

	Local $DonateAllTroop = BitOR($iChkDonateAllBarbarians, $iChkDonateAllArchers, $iChkDonateAllGiants, $iChkDonateAllGoblins, _
			$iChkDonateAllWallBreakers, $iChkDonateAllBalloons, $iChkDonateAllWizards, $iChkDonateAllHealers, _
			$iChkDonateAllDragons, $iChkDonateAllPekkas, $iChkDonateAllMinions, $iChkDonateAllHogRiders, _
			$iChkDonateAllValkyries, $iChkDonateAllGolems, $iChkDonateAllWitches, $iChkDonateAllLavaHounds, $iChkDonateAllCustom)

	Global $Donate = BitOR($DonateTroop, $DonateAllTroop)
	Global $aTotalDonateCapacity


	If $Donate = False Or $bDonationEnabled = False Then Return ; exit func if no donate checkmarks

	If $iPlannedDonateHoursEnable = 1 Then
		Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
		If $iPlannedDonateHours[$hour[0]] = 0 Then
			SetLog("Donation not Planned, Skipped..", $COLOR_GREEN)
			Return ; exit func if no planned donate checkmarks
		EndIf
	EndIf

	Local $y = 119

	;check for new chats first
	If $Check = True Then
		_CaptureRegion()
		If _ColorCheck(_GetPixelColor(26, 312 + $midOffsetY), Hex(0xf00810, 6), 20) = False And $CommandStop <> 3 Then
			Return ;exit if no new chats
		EndIf
	EndIf

	ClickP($aAway, 1, 0, "#0167") ;Click Away
	;_CaptureRegion()
	If _CheckPixel($aChatTab, $bCapturePixel) = False Then ClickP($aOpenChat, 1, 0, "#0168") ; Clicks chat tab
	If _Sleep($iDelayDonateCC1) Then Return

	ClickP($aClanTab, 1, 0, "#0169") ; clicking clan tab
	If _Sleep($iDelayDonateCC2) Then Return

	checkAttackDisable($iTaBChkIdle) ; Early Take-A-Break detection

	Local $Scroll, $offColors[3][3] = [[0x010101, 0 , -4], [0xb8e050, 0, 13], [0xb0da49, 0, 16]]; $offColors[3][3] = [[0x000000, 0, -2], [0x262926, 0, 1], [0xF8FCF0, 0, 11]]
	While $Donate
		$debugOcr = 1
		If _Sleep($iDelayDonateCC2) Then ExitLoop
		$DonatePixel = _MultiPixelSearch(202, $y, 203, 620 + $bottomOffsetY, 1, 1, Hex(0xc0e460, 6), $offColors, 15)
		If IsArray($DonatePixel) Then
			$Donate = False
			If $DonateTroop Then
				If $ichkExtraAlphabets = 1 Then
					; Chast Request , Latin + Turkish + Extra latin + Cyrillic Alphabets / three paragraphs.
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
					; Chast Request , Latin + Turkish + Extra / three paragraphs.
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
					$Donate = True
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

				RemainingCCcapacity() ; Remaining CC capacity of requested troops from your ClanMates

				;;; Custom Combination Donate by ChiefM3
				If $iChkDonateCustom = 1 Then
					If CheckDonateTroop($eLava + 1, $aDonCustom, $aBlkCustom, $aBlackList, $ClanString) Then
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
							DonateTroopType($varDonateCustom[$i][0], $varDonateCustom[$i][1], True) ;;; Donate Custom Troop using DonateTroopType2
						Next
					EndIf
					If $Donate Then
						$y = $DonatePixel[1] + 30
						ContinueLoop
					EndIf
				EndIf

				If $iChkDonateBarbarians = 1 Then
					If CheckDonateTroop($eBarb, $aDonBarbarians, $aBlkBarbarians, $aBlackList, $ClanString) Then
						DonateTroopType($eBarb)
					EndIf
					If $Donate Then
						$y = $DonatePixel[1] + 30
						ContinueLoop
					EndIf
				EndIf

				If $iChkDonateArchers = 1 Then
					If CheckDonateTroop($eArch, $aDonArchers, $aBlkArchers, $aBlackList, $ClanString) Then
						DonateTroopType($eArch)
					EndIf
					If $Donate Then
						$y = $DonatePixel[1] + 30
						ContinueLoop
					EndIf
				EndIf

				If $iChkDonateGiants = 1 Then
					If CheckDonateTroop($eGiant, $aDonGiants, $aBlkGiants, $aBlackList, $ClanString) Then
						DonateTroopType($eGiant)
					EndIf
					If $Donate Then
						$y = $DonatePixel[1] + 30
						ContinueLoop
					EndIf
				EndIf

				If $iChkDonateGoblins = 1 Then
					If CheckDonateTroop($eGobl, $aDonGoblins, $aBlkGoblins, $aBlackList, $ClanString) Then
						DonateTroopType($eGobl)
					EndIf
					If $Donate Then
						$y = $DonatePixel[1] + 30
						ContinueLoop
					EndIf
				EndIf

				If $iChkDonateWallBreakers = 1 Then
					If CheckDonateTroop($eWall, $aDonWallBreakers, $aBlkWallBreakers, $aBlackList, $ClanString) Then
						DonateTroopType($eWall)
					EndIf
					If $Donate Then
						$y = $DonatePixel[1] + 30
						ContinueLoop
					EndIf
				EndIf

				If $iChkDonateBalloons = 1 Then
					If CheckDonateTroop($eBall, $aDonBalloons, $aBlkBalloons, $aBlackList, $ClanString) Then
						DonateTroopType($eBall)
					EndIf
					If $Donate Then
						$y = $DonatePixel[1] + 30
						ContinueLoop
					EndIf
				EndIf

				If $iChkDonateWizards = 1 Then
					If CheckDonateTroop($eWiza, $aDonWizards, $aBlkWizards, $aBlackList, $ClanString) Then
						DonateTroopType($eWiza)
					EndIf
					If $Donate Then
						$y = $DonatePixel[1] + 30
						ContinueLoop
					EndIf
				EndIf

				If $iChkDonateHealers = 1 Then
					If CheckDonateTroop($eHeal, $aDonHealers, $aBlkHealers, $aBlackList, $ClanString) Then
						DonateTroopType($eHeal)
					EndIf
					If $Donate Then
						$y = $DonatePixel[1] + 30
						ContinueLoop
					EndIf
				EndIf

				If $iChkDonateDragons = 1 Then
					If CheckDonateTroop($eDrag, $aDonDragons, $aBlkDragons, $aBlackList, $ClanString) Then
						DonateTroopType($eDrag)
					EndIf
					If $Donate Then
						$y = $DonatePixel[1] + 30
						ContinueLoop
					EndIf
				EndIf

				If $iChkDonatePekkas = 1 Then
					If CheckDonateTroop($ePekk, $aDonPekkas, $aBlkPekkas, $aBlackList, $ClanString) Then
						DonateTroopType($ePekk)
					EndIf
					If $Donate Then
						$y = $DonatePixel[1] + 30
						ContinueLoop
					EndIf
				EndIf

				If $iChkDonateMinions = 1 Then
					If CheckDonateTroop($eMini, $aDonMinions, $aBlkMinions, $aBlackList, $ClanString) Then
						DonateTroopType($eMini)
					EndIf
					If $Donate Then
						$y = $DonatePixel[1] + 30
						ContinueLoop
					EndIf
				EndIf

				If $iChkDonateHogRiders = 1 Then
					If CheckDonateTroop($eHogs, $aDonHogRiders, $aBlkHogRiders, $aBlackList, $ClanString) Then
						DonateTroopType($eHogs)
					EndIf
					If $Donate Then
						$y = $DonatePixel[1] + 30
						ContinueLoop
					EndIf
				EndIf

				If $iChkDonateValkyries = 1 Then
					If CheckDonateTroop($eValk, $aDonValkyries, $aBlkValkyries, $aBlackList, $ClanString) Then
						DonateTroopType($eValk)
					EndIf
					If $Donate Then
						$y = $DonatePixel[1] + 30
						ContinueLoop
					EndIf
				EndIf

				If $iChkDonateGolems = 1 Then
					If CheckDonateTroop($eGole, $aDonGolems, $aBlkGolems, $aBlackList, $ClanString) Then
						DonateTroopType($eGole)
					EndIf
					If $Donate Then
						$y = $DonatePixel[1] + 30
						ContinueLoop
					EndIf
				EndIf

				If $iChkDonateWitches = 1 Then
					If CheckDonateTroop($eWitc, $aDonWitches, $aBlkWitches, $aBlackList, $ClanString) Then
						DonateTroopType($eWitc)
					EndIf
					If $Donate Then
						$y = $DonatePixel[1] + 30
						ContinueLoop
					EndIf
				EndIf

				If $iChkDonateLavaHounds = 1 Then
					If CheckDonateTroop($eLava, $aDonLavaHounds, $aBlkLavaHounds, $aBlackList, $ClanString) Then
						DonateTroopType($eLava)
					EndIf
					If $Donate Then
						$y = $DonatePixel[1] + 30
						ContinueLoop
					EndIf
				EndIf

			EndIf

			If $DonateAllTroop Then
				RemainingCCcapacity() ; Remaining CC capacity of requested troops from your ClanMates
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
							DonateTroopType($varDonateCustom[$i][0], $varDonateCustom[$i][1], True) ;;; Donate Custom Troop using DonateTroopType2
						Next
						ClickP($aAway, 1, 0, "#0170")
					Case $iChkDonateAllBarbarians = 1
						DonateTroopType($eBarb)
					Case $iChkDonateAllArchers = 1
						DonateTroopType($eArch)
					Case $iChkDonateAllGiants = 1
						DonateTroopType($eGiant)
					Case $iChkDonateAllGoblins = 1
						DonateTroopType($eGobl)
					Case $iChkDonateAllWallBreakers = 1
						DonateTroopType($eWall)
					Case $iChkDonateAllBalloons = 1
						DonateTroopType($eBall)
					Case $iChkDonateAllWizards = 1
						DonateTroopType($eWiza)
					Case $iChkDonateAllHealers = 1
						DonateTroopType($eHeal)
					Case $iChkDonateAllDragons = 1
						DonateTroopType($eDrag)
					Case $iChkDonateAllPekkas = 1
						DonateTroopType($ePekk)
					Case $iChkDonateAllMinions = 1
						DonateTroopType($eMini)
					Case $iChkDonateAllHogRiders = 1
						DonateTroopType($eHogs)
					Case $iChkDonateAllValkyries = 1
						DonateTroopType($eValk)
					Case $iChkDonateAllGolems = 1
						DonateTroopType($eGole)
					Case $iChkDonateAllWitches = 1
						DonateTroopType($eWitc)
					Case $iChkDonateAllLavaHounds = 1
						DonateTroopType($eLava)
				EndSelect
			EndIf

			$Donate = True
			$y = $DonatePixel[1] + 30
			ClickP($aAway, 1, 0, "#0171")
			If _Sleep($iDelayDonateCC2) Then ExitLoop
		EndIf
		$DonatePixel = _MultiPixelSearch(202, $y, 203, 620 + $bottomOffsetY, 1, 1, Hex(0xc0e460, 6), $offColors, 15)
		If IsArray($DonatePixel) Then ContinueLoop

		$Scroll = _PixelSearch(288, 640 + $bottomOffsetY, 290, 655 + $bottomOffsetY, Hex(0x588800, 6), 20)
		$Donate = True
		If IsArray($Scroll) Then
			Click($Scroll[0], $Scroll[1], 1, 0, "#0172")
			$y = 119
			If _Sleep($iDelayDonateCC2) Then ExitLoop
			ContinueLoop
		EndIf
		$debugOcr = 0
		$Donate = False
	WEnd

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
			SetLog(NameOfTroop($Type) & " Blacklist Keyword found: " & $aBlkTroop[$i], $COLOR_RED)
			Return False
		EndIf
	Next

	For $i = 1 To UBound($aDonTroop) - 1
		If CheckDonateString($aDonTroop[$i], $ClanString) Then
			If $Type > $eLava Then
				Setlog("Custom Donation Keyword found: " & $aDonTroop[$i], $COLOR_GREEN)
			Else
				Setlog(NameOfTroop($Type) & " Keyword found: " & $aDonTroop[$i], $COLOR_GREEN)
			EndIf
			Return True
		EndIf
	Next

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

Func DonateTroopType($Type, $quant = 8, $custom = False)

	Local $Slot, $YComp, $aDonationLimit
	Local $sDonateQuantityAvaible = 0
	Local $sDonateQuantity = 0

	If $aTotalDonateCapacity = 0 Then Return

	; New Windows Donation Slot System , using the ArmyOverView Troops slot
	; Determinate the quantity to donate / Clan level capacity vs Quantity avaiable to donate

	$Slot = -1

	If $iClanLevel < 4 Then
		$aDonationLimit = 5
	ElseIf $iClanLevel >= 4 And $iClanLevel < 8 Then
		$aDonationLimit = 6
	Else
		$aDonationLimit = 8
	EndIf

	For $i = 0 To UBound($TroopName) - 1
		If Eval("e" & $TroopName[$i]) = $Type Then
			$sDonateQuantityAvaible = Floor($aTotalDonateCapacity / $TroopHeight[$i])
			If $sDonateQuantityAvaible < 1 Then
				Setlog("Sorry Chief!" & NameOfTroop($Type) & " don't fit in the remaining space!")
				Return
			EndIf
			If $sDonateQuantityAvaible >= $aDonationLimit Then
				$sDonateQuantity = $aDonationLimit
			Else
				$sDonateQuantity = $sDonateQuantityAvaible
			EndIf
		EndIf
	Next

	For $i = 0 To UBound($TroopDarkName) - 1
		If Eval("e" & $TroopDarkName[$i]) = $Type Then
			$sDonateQuantityAvaible = Floor($aTotalDonateCapacity / $TroopDarkHeight[$i])
			If $sDonateQuantityAvaible < 1 Then
				Setlog("Sorry Chief!" & NameOfTroop($Type) & " don't fit in the remaining space!")
				Return
			EndIf
			If $sDonateQuantityAvaible >= $aDonationLimit Then
				$sDonateQuantity = $aDonationLimit
			Else
				$sDonateQuantity = $sDonateQuantityAvaible
			EndIf
		EndIf
	Next

	; End

	; Click on Donate Button and wait for the windows
	Click($DonatePixel[0] - 30, $DonatePixel[1] + 10, 1, 0, "#0174")
	If _Sleep($iDelayDonateTroopType1) Then Return

	_CaptureRegion(0, 0, 320 + $midOffsetY, $DonatePixel[1] + 30 + $YComp)
	$icount = 0
	While Not (_ColorCheck(_GetPixelColor(331, $DonatePixel[1]), Hex(0xffffff, 6), 0))
		If _Sleep($iDelayDonateTroopType1) Then Return
		_CaptureRegion(0, 0, 320 + $midOffsetY, $DonatePixel[1] + 30 + $YComp)
		$icount += 1
		If $icount = 20 Then ExitLoop
	WEnd

	; Determinate the right position from new Donation Windows
	; Will search in $Y column = 400 for the first pure white color and determinate that position the $DonationWindowTemp
	$DonationWindowY = 0

	Local $DonationWindowTemp = _PixelSearch(400, 0, 401, $DonatePixel[1], Hex(0xFFFFFF, 6), 0)

	If IsArray($DonationWindowTemp) Then
		$DonationWindowY = $DonationWindowTemp[1]
		If _Sleep($iDelayDonateTroopType1) Then Return
		If $debugSetlog = 1 Then Setlog ("$DonationWindowY: " & $DonationWindowY)
	Else
		SetLog ("Could not Find the Donation Window!!", $COLOR_RED)
		Return
	EndIF

	; Detect the Troops Slot

	$Slot = DetectSlotTroop($Type)
	IF $Slot = -1 then Return

	If $Slot > 7 then
		$Slot = $Slot - 7
		$YComp = 98  ; correct
	EndIf

	; Verify if existe the type troop to donate
	If _ColorCheck(_GetPixelColor(350 + ($Slot * 68), $DonationWindowY + 105 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
			_ColorCheck(_GetPixelColor(355 + ($Slot * 68), $DonationWindowY + 106 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
			_ColorCheck(_GetPixelColor(360 + ($Slot * 68), $DonationWindowY + 107 + $YComp, True), Hex(0x306ca8, 6), 20) Then

		If $custom Then
			SetLog("Donating " & $quant & " " & NameOfTroop($Type), $COLOR_GREEN)
			Click(365 + ($Slot * 68), $DonationWindowY + 100 + $YComp, $quant, $iDelayDonateCC3, "#0175")
		Else
			SetLog("Donating " & $sDonateQuantity & " " & NameOfTroop($Type), $COLOR_GREEN)
			Click(365 + ($Slot * 68), $DonationWindowY + 100 + $YComp, $sDonateQuantity, $iDelayDonateCC3, "#0175")
		EndIf

		$Donate = True

		; Assign the donated quantity troops to train : $Don $TroopName
		If $custom Then
			For $i = 0 To UBound($TroopName) - 1
				If Eval("e" & $TroopName[$i]) = $Type Then
					Assign("Don" & $TroopName[$i], Eval("Don" & $TroopName[$i]) + $quant)
				EndIf
			Next
			For $i = 0 To UBound($TroopDarkName) - 1
				If Eval("e" & $TroopDarkName[$i]) = $Type Then
					Assign("Don" & $TroopDarkName[$i], Eval("Don" & $TroopDarkName[$i]) + $quant)
				EndIf
			Next
		Else
			For $i = 0 To UBound($TroopName) - 1
				If Eval("e" & $TroopName[$i]) = $Type Then
					Assign("Don" & $TroopName[$i], Eval("Don" & $TroopName[$i]) + $sDonateQuantity)
				EndIf
			Next
			For $i = 0 To UBound($TroopDarkName) - 1
				If Eval("e" & $TroopDarkName[$i]) = $Type Then
					Assign("Don" & $TroopDarkName[$i], Eval("Don" & $TroopDarkName[$i]) + $sDonateQuantity)
				EndIf
			Next
		EndIf
		; End

	ElseIf $DonatePixel[1] - 5 + $YComp > 675 Then
		Setlog("Unable to donate " & NameOfTroop($Type) & ". Donate screen not visible, will retry next run.", $COLOR_RED)
	Else
		SetLog("No " & NameOfTroop($Type) & " available to donate..", $COLOR_RED)
	EndIf

	ClickP($aAway, 1, 0, "#0176")
	If _Sleep($iDelayDonateTroopType1) Then Return
EndFunc   ;==>DonateTroopType

Func RemainingCCcapacity()
	; Remaining CC capacity of requested troops from your ClanMates
	; Will return the $aTotalDonateCapacity with that capacity for use in donation logic.

	Local $aTempTotalDonate = ""
	Local $aDonatedTroops = 0
	Local $aCastleTotalCapacity = 0
	$aTempTotalDonate = getOcrSpaceCastleDonate(110, $DonatePixel[1] - 33) ; when the request is troops+spell

	; Verify with OCR the Donation Clan Castle capacity
	$aTotalDonateCapacity = 0
	If $debugSetlog = 1 Then Setlog("Started getOcrSpaceCastleDonate",$COLOR_PURPLE)
	Local $aTempTotalDonate2 = ""
	If $debugSetlog = 1 Then Setlog("$aTempTotalDonate :" & $aTempTotalDonate,$COLOR_PURPLE)

	Local $iRequestSpellExist = StringInStr($aTempTotalDonate, "#") ; verify if the string is valid or it is just a number from request without spell
	If $aTempTotalDonate = "" Or $iRequestSpellExist = 0 then
		$aTempTotalDonate = getOcrSpaceCastleDonate(139, $DonatePixel[1] - 33) ; when the Request don�t have Spell
		; Verify with OCR the Donation Clan Castle capacity
		$aTotalDonateCapacity = 0
		If $debugSetlog = 1 Then Setlog("Started getOcrSpaceCastleDonate",$COLOR_PURPLE)
		$aTempTotalDonate2 = ""
		If $debugSetlog = 1 Then Setlog("$aTempTotalDonate :" & $aTempTotalDonate,$COLOR_PURPLE)
	EndIf

	If Not $aTempTotalDonate = "" Then
		; Splitting the XX/XX
		$aTempTotalDonate2 = StringSplit($aTempTotalDonate, "#")

		; Local Variables to use
		If $aTempTotalDonate2[0] >= 2 Then
		; If IsArray($aTempTotalDonate2) Then  ;  Note - stringsplit always returns an array even if no values split!
		If $debugSetlog = 1 Then Setlog("$aTempTotalDonate2 splitted :" & $aTempTotalDonate2[1] & "/" & $aTempTotalDonate2[2], $COLOR_PURPLE)
			If $aTempTotalDonate2[2] > 0 Then
				$aDonatedTroops = $aTempTotalDonate2[1]
				$aCastleTotalCapacity = $aTempTotalDonate2[2]
			EndIf
		Else
			Setlog("Error reading the Castle Capacity...", $COLOR_RED) ; log if there is read error
			$aDonatedTroops = 0
			$aCastleTotalCapacity = 0
		EndIf

	Else
		Setlog("Error reading the Castle Capacity...", $COLOR_RED) ; log if there is read error
		$aDonatedTroops = 0
		$aCastleTotalCapacity = 0
	EndIf

	; $aTotalDonateCapacity it will be use to determinate the quantity of kind troop to donate
	$aTotalDonateCapacity = ($aCastleTotalCapacity - $aDonatedTroops)

	If $aTotalDonateCapacity < 0 Then
		SetLog("Unable to read Castle Capacity!", $COLOR_RED)
	Else
		SetLog("Castle Capacity : " & $aDonatedTroops & "/" & $aCastleTotalCapacity)
	EndIf

	Return $aTotalDonateCapacity

EndFunc   ;==>RemainingCCcapacity

Func DetectSlotTroop($Type)

		For $Slot = 0 To 6
			If $debugSetlog = 1 Then Setlog(" Slot : " & $i + 1, $COLOR_PURPLE)
			Local $FullTemp = getOcrDonationTroopsDetection(358 + (68 * $Slot), $DonationWindowY + 38 )
			If $debugSetlog = 1 Then Setlog(" getOcrDonationTroopsDetection: " & $FullTemp, $COLOR_PURPLE)
			If $Type = $eBarb and $FullTemp = "barbarian"  Then
				Return $Slot
			EndIf
			If $Type = $eArch And $FullTemp = "archer" Then
				Return $Slot
			EndIf
			If $Type = $eGiant And $FullTemp = "giant" Then
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
			If $Type = $eMini And $FullTemp = "minions" Then
				Return $Slot
			EndIf
		Next
		If $FullTemp = ""  Then
		Return -1
		EndIf

EndFunc

