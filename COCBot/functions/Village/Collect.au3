; #FUNCTION# ====================================================================================================================
; Name ..........: Collect
; Description ...:
; Syntax ........: Collect()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......: Sardo (08/2015), KnowJack(10/2015), kaganus (10/2015), ProMac (04/2016), Codeslinger69 (01/2017), Fliegerfaust (11/2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func Collect($bCheckTreasury = True)
	If Not $g_bChkCollect Or Not $g_bRunState Then Return

	ClearScreen()

	StartGainCost()

	If $g_bChkCollectCartFirst And ($g_iTxtCollectGold = 0 Or $g_aiCurrentLoot[$eLootGold] < Number($g_iTxtCollectGold) Or $g_iTxtCollectElixir = 0 Or $g_aiCurrentLoot[$eLootElixir] < Number($g_iTxtCollectElixir) Or $g_iTxtCollectDark = 0 Or $g_aiCurrentLoot[$eLootDarkElixir] < Number($g_iTxtCollectDark)) Then CollectLootCart()

	SetLog("Collecting Resources", $COLOR_INFO)
	If _Sleep($DELAYCOLLECT2) Then Return

	Local $aGoldFull = _FullResPixelSearch($aIsGoldFull[0], $aIsGoldFull[0] + 4, $aIsGoldFull[1], 1, Hex(0x0D0D0D, 6), $aIsGoldFull[2], $aIsGoldFull[3])
	Local $aElixirFull = _FullResPixelSearch($aIsElixirFull[0], $aIsElixirFull[0] + 4, $aIsElixirFull[1], 1, Hex(0x0D0D0D, 6), $aIsElixirFull[2], $aIsElixirFull[3])
	Local $aDarkElixirFull = _FullResPixelSearch($aIsDarkElixirFull[0], $aIsDarkElixirFull[0] + 4, $aIsDarkElixirFull[1], 1, Hex(0x0D0D0D, 6), $aIsDarkElixirFull[2], $aIsDarkElixirFull[3])

	; Setup arrays, including default return values for $return
	Local $sFileName = ""
	Local $aCollectXY, $t

	Local $aResult = returnMultipleMatchesOwnVillage($g_sImgCollectRessources)

	If UBound($aResult) > 1 Then ; we have an array with data of images found
		For $i = 1 To UBound($aResult) - 1 ; loop through array rows
			$sFileName = $aResult[$i][1] ; Filename
			$aCollectXY = $aResult[$i][5] ; Coords
			Switch StringLower($sFileName)
				Case "collectmines"
					If IsArray($aGoldFull) Then ContinueLoop
					If $g_iTxtCollectGold <> 0 And $g_aiCurrentLoot[$eLootGold] >= Number($g_iTxtCollectGold) Then
						SetLog("Gold is high enough, skip collecting", $COLOR_ACTION)
						ContinueLoop
					EndIf
				Case "collectelix"
					If IsArray($aElixirFull) Then ContinueLoop
					If $g_iTxtCollectElixir <> 0 And $g_aiCurrentLoot[$eLootElixir] >= Number($g_iTxtCollectElixir) Then
						SetLog("Elixir is high enough, skip collecting", $COLOR_ACTION)
						ContinueLoop
					EndIf
				Case "collectdelix"
					If IsArray($aDarkElixirFull) Then ContinueLoop
					If $g_iTxtCollectDark <> 0 And $g_aiCurrentLoot[$eLootDarkElixir] >= Number($g_iTxtCollectDark) Then
						SetLog("Dark Elixir is high enough, skip collecting", $COLOR_ACTION)
						ContinueLoop
					EndIf
			EndSwitch
			If IsArray($aCollectXY) Then ; found array of locations
				$t = Random(0, UBound($aCollectXY) - 1, 1) ; SC May 2017 update only need to pick one of each to collect all
				If $g_bDebugSetLog Then SetDebugLog($sFileName & " found, random pick(" & $aCollectXY[$t][0] & "," & $aCollectXY[$t][1] & ")", $COLOR_GREEN)
				If IsMainPage() Then Click($aCollectXY[$t][0], $aCollectXY[$t][1], 1, 120, "#0430")
				If _Sleep($DELAYCOLLECT2) Then Return
			EndIf
		Next
	EndIf

	If _Sleep($DELAYCOLLECT3) Then Return
	checkMainScreen(False) ; check if errors during function

	$aGoldFull = _FullResPixelSearch($aIsGoldFull[0], $aIsGoldFull[0] + 4, $aIsGoldFull[1], 1, Hex(0x0D0D0D, 6), $aIsGoldFull[2], $aIsGoldFull[3])
	$aElixirFull = _FullResPixelSearch($aIsElixirFull[0], $aIsElixirFull[0] + 4, $aIsElixirFull[1], 1, Hex(0x0D0D0D, 6), $aIsElixirFull[2], $aIsElixirFull[3])
	$aDarkElixirFull = _FullResPixelSearch($aIsDarkElixirFull[0], $aIsDarkElixirFull[0] + 4, $aIsDarkElixirFull[1], 1, Hex(0x0D0D0D, 6), $aIsDarkElixirFull[2], $aIsDarkElixirFull[3])
	Local $iAllResourcesFull = IsArray($aGoldFull) And IsArray($aElixirFull) And IsArray($aDarkElixirFull)

	If Not $g_bChkCollectCartFirst And ($g_iTxtCollectGold = 0 Or $g_aiCurrentLoot[$eLootGold] < Number($g_iTxtCollectGold) Or $g_iTxtCollectElixir = 0 Or _
			$g_aiCurrentLoot[$eLootElixir] < Number($g_iTxtCollectElixir) Or $g_iTxtCollectDark = 0 Or $g_aiCurrentLoot[$eLootDarkElixir] < Number($g_iTxtCollectDark)) And Not $iAllResourcesFull Then CollectLootCart()
	If $g_bChkTreasuryCollect > 0 And $bCheckTreasury And Not $iAllResourcesFull Then TreasuryCollect()
	EndGainCost("Collect")
EndFunc   ;==>Collect

Func CollectLootCart()
	If Not $g_abNotNeedAllTime[0] Then
		SetLog("Skipping loot cart check", $COLOR_INFO)
		Return
	EndIf

	SetLog("Searching for a Loot Cart", $COLOR_INFO)

	If $g_iTree = $eTreeEG Then
		If _ColorCheck(_GetPixelColor(54, 278 + $g_iMidOffsetY, True), Hex(0xE90914, 6), 20) Then ; If Egypt Scenery, Open/Close Chat To remove red warning.
			If ClickB("ClanChat") Then
				If _Sleep(2000) Then Return
				; check for "I Understand" button
				Local $aCoord = decodeSingleCoord(FindImageInPlace2("I Understand", $g_sImgChatIUnterstand, 50, 370 + $g_iMidOffsetY, 280, 520 + $g_iMidOffsetY, True))
				If UBound($aCoord) > 1 Then
					SetLog('Clicking "I Understand" button', $COLOR_ACTION)
					ClickP($aCoord)
					If _Sleep($DELAYDONATECC2) Then Return
				EndIf
				If Not ClickB("ClanChat") Then
					If _ColorCheck(_GetPixelColor(390, 340 + $g_iMidOffsetY, True), Hex(0xEA8A3B, 6), 20) Then ; close chat
						If Not ClickB("ClanChat") Then
							SetDebugLog("Error finding the Clan Tab Button", $COLOR_ERROR)
							Click(400, 312 + $g_iMidOffsetY)
						EndIf
						If _Sleep(2000) Then Return
					EndIf
				Else
					If _Sleep(2000) Then Return
				EndIf
			EndIf
		EndIf
	EndIf

	Local $Area[4] = [0, 180 + $g_iMidOffsetY, 120, 280 + $g_iMidOffsetY]
	If IsCustomScenery(True, "Upper") Then
		$Area[0] = 40
		$Area[1] = 220 + $g_iMidOffsetY
		$Area[2] = 150
		$Area[3] = 320 + $g_iMidOffsetY
	EndIf

	If QuickMIS("BC1", $g_sImgCollectLootCart, $Area[0], $Area[1], $Area[2], $Area[3]) Then
		Click($g_iQuickMISX, $g_iQuickMISY)
		If _Sleep(1000) Then Return

		If _ColorCheck(_GetPixelColor(390, 340 + $g_iMidOffsetY, True), Hex(0xEA8A3B, 6), 20) Then     ; close chat
			If Not ClickB("ClanChat") Then
				SetDebugLog("Error finding the Clan Tab Button", $COLOR_ERROR)
				Click(400, 312 + $g_iMidOffsetY)
			EndIf
			If _Sleep(2000) Then Return
			Return False
		EndIf

		Local $aiCollectButton = findButton("CollectLootCart", Default, 1, True)
		If IsArray($aiCollectButton) And UBound($aiCollectButton) = 2 Then
			SetLog("Clicking to collect loot cart.", $COLOR_SUCCESS)
			ClickP($aiCollectButton)
			If _Sleep(2000) Then Return
			$aiCollectButton = findButton("CollectLootCart", Default, 1, True)
			If IsArray($aiCollectButton) And UBound($aiCollectButton) = 2 Then
				Click($g_iQuickMISX, $g_iQuickMISY)
				If _Sleep(500) Then Return
			EndIf
			If _ColorCheck(_GetPixelColor(390, 340 + $g_iMidOffsetY, True), Hex(0xEA8A3B, 6), 20) Then     ; close chat
				If Not ClickB("ClanChat") Then
					SetDebugLog("Error finding the Clan Tab Button", $COLOR_ERROR)
					Click(400, 312 + $g_iMidOffsetY)
				EndIf
				If _Sleep(500) Then Return
				Return False
			EndIf
		Else
			SetLog("Cannot find Collect Button", $COLOR_ERROR)
			Return False
		EndIf
	Else
		SetLog("No Loot Cart found on your Village", $COLOR_SUCCESS)
	EndIf

	$g_abNotNeedAllTime[0] = False
EndFunc   ;==>CollectLootCart
