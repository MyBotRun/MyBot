
; #FUNCTION# ====================================================================================================================
; Name ..........: Collect
; Description ...:
; Syntax ........: Collect()
; Parameters ....:
; Return values .: None
; Author ........: Code Gorilla #3
; Modified ......: Sardo 2015-08, KnowJack(Aug 2015), kaganus (August 2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func Collect()
	If $RunState = False Then Return

	ClickP($aAway, 1, 0, "#0332") ;Click Away

	If $iChkCollect = 0 Then Return

	Local $collx, $colly, $i = 0

	VillageReport(True, True)
	$tempCounter = 0
	While ($iGoldCurrent = "" Or $iElixirCurrent = "" Or ($iDarkCurrent = "" And $iDarkStart <> "")) And $tempCounter < 3
		$tempCounter += 1
		VillageReport(True, True)
	WEnd
	Local $tempGold = $iGoldCurrent
	Local $tempElixir = $iElixirCurrent
	Local $tempDElixir = $iDarkCurrent

	checkAttackDisable($iTaBChkIdle) ; Early Take-A-Break detection

	SetLog("Collecting Resources", $COLOR_BLUE)
	If _Sleep($iDelayCollect2) Then Return

	If $listResourceLocation <> "" Then
		Local $ResourceLocations = StringSplit($listResourceLocation, "|")
		For $i = 1 To $ResourceLocations[0]
			If $ResourceLocations[$i] <> "" Then
				$pixel = StringSplit($ResourceLocations[$i], ";")
				If isInsideDiamondXY($pixel[1], $pixel[2]) Then
					If IsMainPage() Then click($pixel[1], $pixel[2], 1, 0, "#0331")
				Else
					SetLog("Error in Mines/Collector locations found, finding positions again", $COLOR_RED)
					IniDelete($building, "other", "listResource")
					If _Sleep($iDelayCollect2) Then Return
					$listResourceLocation = ""
					BotDetectFirstTime()
					IniWrite($building, "other", "listResource", $listResourceLocation)
					ExitLoop
				EndIf
				If _Sleep($iDelayCollect2) Then Return
			EndIf
		Next
	EndIf

	While 1
		If _Sleep($iDelayCollect1) Or $RunState = False Then ExitLoop
		_CaptureRegion()
		If _ImageSearch(@ScriptDir & "\images\Resources\collect.png", 1, $collx, $colly, 20) Then
			If isInsideDiamondXY($collx, $colly) Then
				If IsMainPage() Then Click($collx, $colly, 1, 0, "#0330") ;Click collector
				If _Sleep($iDelayCollect1) Then Return
			EndIf
			ClickP($aAway, 1, 0, "#0329") ;Click Away
		Else
			ExitLoop
		EndIf
		If $i >= 20 Then ExitLoop
		$i += 1
	WEnd
	If _Sleep($iDelayCollect3) Then Return
	checkMainScreen(False) ; check if errors during function

	; Loot Cart Collect Function

	Setlog("Searching for a Loot Cart..", $COLOR_BLUE)

	Local $LootCart = @ScriptDir & "\images\Resources\loot_cart.png"
	Local $LootCartX, $LootCartY

	$ToleranceImgLoc = 0.850

	_CaptureRegion2()
	Local $res = DllCall($pImgLib, "str", "SearchTile", "handle", $hHBitmap2, "str", $LootCart, "float", $ToleranceImgLoc, "str", $ExtendedCocSearchArea, "str", $ExtendedCocDiamond)
	If @error Then _logErrorDLLCall($pImgLib, @error)
	If IsArray($res) Then
		If $DebugSetlog = 1 Then SetLog("DLL Call succeeded " & $res[0], $COLOR_RED)
		If $res[0] = "0" Then
			; failed to find a loot cart on the field
			SetLog("No Loot Cart found, Yard is clean!", $COLOR_GREEN)
		ElseIf $res[0] = "-1" Then
			SetLog("DLL Error", $COLOR_RED)
		ElseIf $res[0] = "-2" Then
			SetLog("Invalid Resolution", $COLOR_RED)
		Else
			$expRet = StringSplit($res[0], "|", 2)
			For $j = 1 To UBound($expRet) - 1 Step 2
				$LootCartX = Int($expRet[$j])
				$LootCartY = Int($expRet[$j + 1])
				If $DebugSetlog then SetLog("LootCart found (" & $LootCartX & "," & $LootCartY & ")", $COLOR_GREEN)
				If IsMainPage() Then Click($LootCartX, $LootCartY, 1, 0, "#0330")
				If _Sleep($iDelayCollect1) Then Return

				;Get LootCard info confirming the name
				Local $sInfo = BuildingInfo(242, 520 + $bottomOffsetY); 860x780
				If @error Then SetError(0, 0, 0)
				Local $CountGetInfo = 0
				While IsArray($sInfo) = False
					$sInfo = BuildingInfo(242, 520 + $bottomOffsetY); 860x780
					If @error Then SetError(0, 0, 0)
					If _Sleep($iDelayCollect1) Then Return
					$CountGetInfo += 1
					If $CountGetInfo >= 5 Then Return
				WEnd
				If $DebugSetlog then SetLog(_ArrayToString($sInfo, " "), $COLOR_PURPLE)
				If @error Then Return SetError(0, 0, 0)
				If $sInfo[0] > 1 Or $sInfo[0] = "" Then
					If StringInStr($sInfo[1], "Loot") = 0 Then
						If $DebugSetlog then SetLog("Bad Loot Cart location", $COLOR_ORANGE)
					Else
						If IsMainPage() Then Click($aLootCartBtn[0], $aLootCartBtn[1], 1, 0, "#0331") ;Click loot cart button
					EndIf
				EndIf
			Next
		EndIf
	EndIf


#cs	_CaptureRegion()
	If _ImageSearch(@ScriptDir & "\images\lootcart.png", 1, $collx, $colly, 70) Then
		If isInsideDiamondXY($collx, $colly) Then
			If IsMainPage() Then Click($collx, $colly, 1, 0, "#0330") ;Click loot cart
			If _Sleep($iDelayCollect1) Then Return

			Local $aCartInfo = BuildingInfo(242, 520 + $bottomOffsetY)
			If $debugsetlog = 1 Then Setlog("$aCartInfo[0]=" & $aCartInfo[0] & ", $aCartInfo[1]=" & $aCartInfo[1] & ", $aCartInfo[2]=" & $aCartInfo[2], $COLOR_PURPLE)
			If $aCartInfo[0] > 1 Then
				If StringInStr($aCartInfo[1], "Cart") = 0 Then
					SetLog("Loot Cart not found! I detected a " & $aCartInfo[1] & "! Please try again!", $COLOR_Fuchsia)
				Else
					If IsMainPage() Then Click($aLootCartBtn[0], $aLootCartBtn[1], 1, 0, "#0331") ;Click loot cart button
				EndIf
			EndIf
			If _Sleep($iDelayCollect1) Then Return
		EndIf
		ClickP($aAway, 1, 0, "#0329") ;Click Away
#ce	EndIf

	VillageReport(True, True)
	$tempCounter = 0
	While ($iGoldCurrent = "" Or $iElixirCurrent = "" Or ($iDarkCurrent = "" And $iDarkStart <> "")) And $tempCounter < 3
		$tempCounter += 1
		VillageReport(True, True)
	WEnd

	If $tempGold <> "" And $iGoldCurrent <> "" Then
		$tempGoldCollected = $iGoldCurrent - $tempGold
		$iGoldFromMines += $tempGoldCollected
		$iGoldTotal += $tempGoldCollected
	EndIf

	If $tempElixir <> "" And $iElixirCurrent <> "" Then
		$tempElixirCollected = $iElixirCurrent - $tempElixir
		$iElixirFromCollectors += $tempElixirCollected
		$iElixirTotal += $tempElixirCollected
	EndIf

	If $tempDElixir <> "" And $iDarkCurrent <> "" Then
		$tempDElixirCollected = $iDarkCurrent - $tempDElixir
		$iDElixirFromDrills += $tempDElixirCollected
		$iDarkTotal += $tempDElixirCollected
	EndIf

	UpdateStats()
EndFunc   ;==>Collect
