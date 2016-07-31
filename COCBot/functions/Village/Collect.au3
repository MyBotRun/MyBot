
; #FUNCTION# ====================================================================================================================
; Name ..........: Collect
; Description ...:
; Syntax ........: Collect()
; Parameters ....:
; Return values .: None
; Author ........: Code Gorilla #3
; Modified ......: Sardo 2015-08, KnowJack(Aug 2015), kaganus (August 2015), ProMac (04-2016)
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

	; Collect function to Parallel Search , will run all pictures inside the directory
	Local $directory = @ScriptDir & "\images\Resources\Collect"
	; Setup arrays, including default return values for $return
	Local $Filename = ""
	Local $CollectXY

	Local $aResult = returnMultipleMatchesOwnVillage($directory)
	If UBound($aResult) > 1 Then
		For $i = 1 To UBound($aResult) - 1
			$Filename = $aResult[$i][1] ; Filename
			$CollectXY = $aResult[$i][5] ; Coords
			If IsMainPage() Then
				If IsArray($CollectXY) Then
					For $t = 0 To UBound($CollectXY) - 1 ; each filename can have several positions
						If $DebugSetLog = 1 Then SetLog($Filename & " found (" & $CollectXY[$t][0] & "," & $CollectXY[$t][1] & ")", $COLOR_GREEN)
						If $iUseRandomClick = 0 then
							Click($CollectXY[$t][0], $CollectXY[$t][1], 1, 0, "#0430")
							If _Sleep($iDelayCollect2) Then Return
						Else
							ClickZone($CollectXY[$t][0], $CollectXY[$t][1], 20, "#0430")
							_Sleep(Random($iDelayCollect2, $iDelayCollect2 * 4, 1))
						EndIF
					Next
				EndIf
			EndIf
		Next
	EndIf

	If _Sleep($iDelayCollect3) Then Return
	checkMainScreen(False) ; check if errors during function
		; Loot Cart Collect Function

		Setlog("Searching for a Loot Cart..", $COLOR_BLUE)

		Local $LootCart = @ScriptDir & "\images\Resources\LootCart\loot_cart.png"
		Local $LootCartX, $LootCartY

		$ToleranceImgLoc = 0.850
		Local $fullCocAreas = "ECD"
		Local $MaxReturnPoints = 1

		_CaptureRegion2()
		;Local $res = DllCall($pImgLib, "str", "SearchTile", "handle", $hHBitmap2, "str", $LootCart, "float", $ToleranceImgLoc, "str", $fullCocAreas, "Int", $MaxReturnPoints)
		Local $res = DllCall($hImgLib, "str", "SearchTile", "handle", $hHBitmap2, "str", $LootCart, "float", $ToleranceImgLoc, "str", $fullCocAreas, "Int", $MaxReturnPoints)
		If @error Then _logErrorDLLCall($pImgLib, @error)
		If IsArray($res) Then
			If $DebugSetlog = 1 Then SetLog("DLL Call succeeded " & $res[0], $COLOR_RED)
			If $res[0] = "0" Or $res[0] = "" Then
				SetLog("No Loot Cart found, Yard is clean!", $COLOR_GREEN)
			ElseIf StringLeft($res[0], 2) = "-1" Then
				SetLog("DLL Error: " & $res[0], $COLOR_RED)
			Else
				$expRet = StringSplit($res[0], "|", $STR_NOCOUNT)
				;$expret contains 2 positions; 0 is the total objects; 1 is the point in X,Y format
				$posPoint = StringSplit($expRet[1], ",", $STR_NOCOUNT)
				$LootCartX = Int($posPoint[0])
				$LootCartY = Int($posPoint[1])
				If $LootCartX > 80 Then  ; secure x because of clan chat tab
					If $DebugSetlog Then SetLog("LootCart found (" & $LootCartX & "," & $LootCartY & ")", $COLOR_GREEN)
					If IsMainPage() Then Click($LootCartX, $LootCartY, 1, 0, "#0330")
					If _Sleep($iDelayCollect1) Then Return

					;Get LootCart info confirming the name
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
					If $DebugSetlog Then SetLog(_ArrayToString($sInfo, " "), $COLOR_PURPLE)
					If @error Then Return SetError(0, 0, 0)
					If $sInfo[0] > 1 Or $sInfo[0] = "" Then
						If StringInStr($sInfo[1], "Loot") = 0 Then
							If $DebugSetlog Then SetLog("Bad Loot Cart location", $COLOR_ORANGE)
						Else
							If IsMainPage() Then Click($aLootCartBtn[0], $aLootCartBtn[1], 1, 0, "#0331") ;Click loot cart button
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf

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
