; #FUNCTION# ====================================================================================================================
; Name ..........: OpenArmyOverview
; Description ...: Opens and waits for Army Overview window and verifies success
; Syntax ........: OpenArmyOverview()
; Parameters ....:
; Return values .: None
; Author ........: MonkeyHunter (01-2016)
; Modified ......: GrumpyHog (11/2022)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func OpenArmyOverview($bCheckMain = True, $sWhereFrom = "Undefined")

	If $bCheckMain Then
		If Not IsMainPage() Then ; check for main page, avoid random troop drop
			SetLog("Cannot open Army Overview window", $COLOR_ERROR)
			SetError(1)
			Return False
		EndIf
	EndIf

	If WaitforPixel(23, 505 + $g_iBottomOffsetY, 53, 507 + $g_iBottomOffsetY, Hex(0xEEB344, 6), 20, 10) Then
		If $g_bDebugSetLogTrain Then SetLog("Click $aArmyTrainButton" & " (Called from " & $sWhereFrom & ")", $COLOR_SUCCESS)
		ClickP($aArmyTrainButton, 1, 120, "#0293") ; Button Army Overview
	EndIf

	If _Sleep($DELAYRUNBOT6) Then Return ; wait for window to open
	If Not IsTrainPage() Then
		SetError(1)
		Return False ; exit if I'm not in train page
	Else
		CheckHeroOrder()
	EndIf
	Return True

EndFunc   ;==>OpenArmyOverview

Func OpenArmyTab($bSetLog = True, $sWhereFrom = "Undefined")
	Return OpenTrainTab("Army Tab", $bSetLog, $sWhereFrom)
EndFunc   ;==>OpenArmyTab

Func OpenTroopsTab($bSetLog = True, $sWhereFrom = "Undefined")
	Click(Random(590, 750, 1), Random(250 + $g_iMidOffsetY, 280 + $g_iMidOffsetY, 1), 1, 120)
	If _Sleep(250) Then Return
	Return True
EndFunc   ;==>OpenTroopsTab

Func OpenSpellsTab($bSetLog = True, $sWhereFrom = "Undefined")
	Click(Random(450, 610, 1), Random(360 + $g_iMidOffsetY, 380 + $g_iMidOffsetY, 1), 1, 120)
	If _Sleep(250) Then Return
	Return True
EndFunc   ;==>OpenSpellsTab

Func OpenSiegeMachinesTab($bSetLog = True, $sWhereFrom = "Undefined")
	Click(Random(680, 790, 1), Random(360 + $g_iMidOffsetY, 380 + $g_iMidOffsetY, 1), 1, 120)
	If _Sleep(250) Then Return
	Return True
EndFunc   ;==>OpenSiegeMachinesTab

Func OpenQuickTrainTab($bSetLog = True, $sWhereFrom = "Undefined")
	Return OpenTrainTab("Quick Train Tab", $bSetLog, $sWhereFrom)
EndFunc   ;==>OpenQuickTrainTab

Func OpenTrainTab($sTab, $bSetLog = True, $sWhereFrom = "Undefined")
	FuncEnter(OpenTrainTab, $g_bDebugSetLogTrain)

	WaitForClanMessage("Tabs")

	If Not IsTrainPage() Then
		SetDebugLog("Error in OpenTrainTab: Cannot find the Army Overview Window", $COLOR_ERROR)
		Return FuncReturn(SetError(1, 0, False), $g_bDebugSetLogTrain)
	EndIf

	Local $bIsCleanArea = False
	For $i = 0 To 9
		WaitForClanMessage("Tabs")
		Local $aTabButton = findButton(StringStripWS($sTab, 8), Default, 1, True)
		If IsArray($aTabButton) And UBound($aTabButton, 1) = 2 Then
			$bIsCleanArea = True
			ExitLoop
		EndIf
		If _Sleep($DELAYRUNBOT3) Then Return
	Next
	If $bIsCleanArea Then
		Switch $aTabButton[0]
			Case 75 To 200
				$aIsTabOpen[0] = 175
			Case 210 To 330
				$aIsTabOpen[0] = 315
			Case 345 To 470
				$aIsTabOpen[0] = 460
			Case 480 To 600
				$aIsTabOpen[0] = 590
			Case 615 To 740
				$aIsTabOpen[0] = 730
		EndSwitch
		If Not _CheckPixel($aIsTabOpen, True) Then
			If $bSetLog Or $g_bDebugSetLogTrain Then SetLog("Open " & $sTab & ($g_bDebugSetLogTrain ? " (Called from " & $sWhereFrom & ")" : ""), $COLOR_INFO)
			ClickP($aTabButton)
			If Not _WaitForCheckPixel($aIsTabOpen, True) Then
				SetLog("Error in OpenTrainTab: Cannot open " & $sTab & ". Pixel to check did not appear", $COLOR_ERROR)
				Return FuncReturn(SetError(1, 0, False), $g_bDebugSetLogTrain)
			EndIf
		EndIf
	Else
		SetDebugLog("Error in OpenTrainTab: $aTabButton is no valid Array", $COLOR_ERROR)
		Return FuncReturn(SetError(1, 0, False), $g_bDebugSetLogTrain)
	EndIf

	If _Sleep(200) Then Return
	Return FuncReturn(True, $g_bDebugSetLogTrain)
EndFunc   ;==>OpenTrainTab

Func UpdateNextPageTroop()
	Local $aSlot1[4] = [585, 545, 667, 465]
	Local $aSlot2[4] = [670, 460, 752, 375]
	Local $aSlot3[4] = [670, 545, 752, 465]
	Local $aSlot4[4] = [585, 460, 667, 375]

	Local $sEDragTile = @ScriptDir & "\imgxml\Train\Train_Train\EDrag*"
	Local $sMinerTile = @ScriptDir & "\imgxml\Train\Train_Train\Mine*"
	Local $sSMinerTile = @ScriptDir & "\imgxml\Train\Train_Train\SMine*"
	Local $sBabyDragonTile = @ScriptDir & "\imgxml\Train\Train_Train\BabyD*"
	Local $sPekkaTile = @ScriptDir & "\imgxml\Train\Train_Train\Pekk*"
	Local $sDragonTile = @ScriptDir & "\imgxml\Train\Train_Train\Drag*"
	Local $sSuperDragonTile = @ScriptDir & "\imgxml\Train\Train_Train\SDrag*"

	If _Sleep(500) Then Return

	Local $aiTileCoord = decodeSingleCoord(findImage("UpdateNextPageTroop", $sEDragTile, GetDiamondFromRect("75,375,780,550"), 1, True))

	If IsArray($aiTileCoord) And UBound($aiTileCoord, 1) = 2 And _ColorCheck(_GetPixelColor(75, 385 + $g_iMidOffsetY, True), Hex(0xD3D3CB, 6), 5) And $aiTileCoord[0] > 580 Then
		SetDebugLog("Found EDrag at " & $aiTileCoord[0] & ", " & $aiTileCoord[1])

		$g_iNextPageTroop = $eETitan

		If PointInRect($aSlot1[0], $aSlot1[1], $aSlot1[2], $aSlot1[3], $aiTileCoord[0], $aiTileCoord[1]) Then
			$g_iNextPageTroop = $eRDrag
			SetDebugLog("Found Edrag moved 1 Slot")
			If _Sleep(200) Then Return
			Return
		EndIf

		If PointInRect($aSlot2[0], $aSlot2[1], $aSlot2[2], $aSlot2[3], $aiTileCoord[0], $aiTileCoord[1]) Then
			$g_iNextPageTroop = $eYeti
			SetDebugLog("Found Edrag moved 2 Slots")
			If _Sleep(200) Then Return
			Return
		EndIf

		If PointInRect($aSlot3[0], $aSlot3[1], $aSlot3[2], $aSlot3[3], $aiTileCoord[0], $aiTileCoord[1]) Then ; Support 2 Super Troops + 1 Event Troop Or 1 Super Troop + 2 Event Troops (Moebius14)
			$g_iNextPageTroop = $eEDrag
			SetDebugLog("Found Edrag moved 3 Slots")
		EndIf

	Else ; Support 2 Super Troops + 2+ Event Troops (Moebius14)

		$aiTileCoord = decodeSingleCoord(findImage("UpdateNextPageTroop", $sMinerTile, GetDiamondFromRect("75,375,780,550"), 1, True))
		If IsArray($aiTileCoord) And UBound($aiTileCoord, 1) = 2 And _ColorCheck(_GetPixelColor(75, 385 + $g_iMidOffsetY, True), Hex(0xD3D3CB, 6), 5) And $aiTileCoord[0] > 580 Then

			If PointInRect($aSlot2[0], $aSlot2[1], $aSlot2[2], $aSlot2[3], $aiTileCoord[0], $aiTileCoord[1]) Then
				Local $aiTileCoord2 = decodeSingleCoord(findImage("UpdateNextPageTroop", $sSMinerTile, GetDiamondFromRect("75,375,780,550"), 1, True))
				If IsArray($aiTileCoord2) And UBound($aiTileCoord2, 1) = 2 Then
					$g_iNextPageTroop = $eSMine
					SetDebugLog("Found Miner moved 3 Slots and SuperMiner Detected")
					If _Sleep(200) Then Return
					Return
				EndIf
			EndIf

			If PointInRect($aSlot3[0], $aSlot3[1], $aSlot3[2], $aSlot3[3], $aiTileCoord[0], $aiTileCoord[1]) Then
				$g_iNextPageTroop = $eMine
				SetDebugLog("Found Miner moved 4 Slots")
			EndIf

		Else ; No Miner Tile Found

			Local $aiTileCoord3 = decodeSingleCoord(findImage("UpdateNextPageTroop", $sBabyDragonTile, GetDiamondFromRect("75,375,780,550"), 1, True))
			If IsArray($aiTileCoord3) And UBound($aiTileCoord3, 1) = 2 And _ColorCheck(_GetPixelColor(75, 385 + $g_iMidOffsetY, True), Hex(0xD3D3CB, 6), 5) And $aiTileCoord3[0] > 668 Then

				If PointInRect($aSlot3[0], $aSlot3[1], $aSlot3[2], $aSlot3[3], $aiTileCoord3[0], $aiTileCoord3[1]) Then
					$g_iNextPageTroop = $eBabyD
					SetDebugLog("Found Baby Dragon moved 5 Slots")
				EndIf

			Else ; No Baby Drag Tile Found

				Local $aiTileCoord4 = decodeSingleCoord(findImage("UpdateNextPageTroop", $sPekkaTile, GetDiamondFromRect("75,375,780,550"), 1, True))
				If IsArray($aiTileCoord4) And UBound($aiTileCoord4, 1) = 2 And _ColorCheck(_GetPixelColor(75, 385 + $g_iMidOffsetY, True), Hex(0xD3D3CB, 6), 5) And $aiTileCoord4[0] > 668 Then

					If PointInRect($aSlot3[0], $aSlot3[1], $aSlot3[2], $aSlot3[3], $aiTileCoord4[0], $aiTileCoord4[1]) Then
						$g_iNextPageTroop = $ePekk
						SetDebugLog("Found Pekka moved 6 Slots")
					EndIf

				Else ; No Pekka Tile Found

					Local $aiTileCoord5 = decodeSingleCoord(findImage("UpdateNextPageTroop", $sDragonTile, GetDiamondFromRect("75,375,780,550"), 1, True))
					If IsArray($aiTileCoord5) And UBound($aiTileCoord5, 1) = 2 And _ColorCheck(_GetPixelColor(75, 385 + $g_iMidOffsetY, True), Hex(0xD3D3CB, 6), 5) And $aiTileCoord5[0] > 580 Then

						If PointInRect($aSlot4[0], $aSlot4[1], $aSlot4[2], $aSlot4[3], $aiTileCoord5[0], $aiTileCoord5[1]) Then
							$g_iNextPageTroop = $eMine
							SetDebugLog("Found 4 Slots Offset For low TH Level")
							If _Sleep(200) Then Return
							Return
						EndIf

						If PointInRect($aSlot1[0], $aSlot1[1], $aSlot1[2], $aSlot1[3], $aiTileCoord5[0], $aiTileCoord5[1]) Then
							$g_iNextPageTroop = $eBabyD
							SetDebugLog("Found 5 Slots Offset For low TH Level")
							If _Sleep(200) Then Return
							Return
						EndIf

						If PointInRect($aSlot2[0], $aSlot2[1], $aSlot2[2], $aSlot2[3], $aiTileCoord5[0], $aiTileCoord5[1]) Then
							Local $aiTileCoord6 = decodeSingleCoord(findImage("UpdateNextPageTroop", $sSuperDragonTile, GetDiamondFromRect("75,375,780,550"), 1, True))
							If IsArray($aiTileCoord6) And UBound($aiTileCoord6, 1) = 2 Then
								$g_iNextPageTroop = $eSDrag
								SetDebugLog("Found Dragon moved 6 Slots and SuperDragon Detected")
							Else
								$g_iNextPageTroop = $ePekk
								SetDebugLog("Found 6 Slots Offset For low TH Level")
							EndIf
							If _Sleep(200) Then Return
							Return
						EndIf

						If PointInRect($aSlot3[0], $aSlot3[1], $aSlot3[2], $aSlot3[3], $aiTileCoord5[0], $aiTileCoord5[1]) Then
							$g_iNextPageTroop = $eDrag
							SetDebugLog("Found Dragon moved 7 Slots") ; 2 Super Troops + 5 Event Troops (October 24)
							If _Sleep(200) Then Return
							Return
						EndIf

					EndIf

				EndIf

			EndIf

		EndIf

	EndIf

	If _Sleep(200) Then Return

EndFunc   ;==>UpdateNextPageTroop

Func PointInRect($iBLx, $iBLy, $iTRx, $iTRy, $iPTx, $iPTy)
	If $iPTx > $iBLx And $iPTx < $iTRx And $iPTy < $iBLy And $iPTy > $iTRy Then Return True

	Return False
EndFunc   ;==>PointInRect

Func IsDarkTroopOffset()

	If $g_iNextPageTroop > $eRDrag Then
		$g_iDarkTroopOffset = False
		Return
	EndIf

	If _DateIsValid($g_iDarkTroopOffsetCheckTimer) Then
		Local $iLastCheck = _DateDiff('s', $g_iDarkTroopOffsetCheckTimer, _NowCalc())
		SetDebugLog("Dark Troops Positions LastCheck: " & $g_iDarkTroopOffsetCheckTimer & ", Check DateCalc: " & $iLastCheck)
		If $iLastCheck < 60 Then Return ; Check every 60 seconds.
	EndIf

	$g_iDarkTroopOffset = False
	$g_iDarkTroopOffsetCheckTimer = _NowCalc()

	Local $aSlot1[4] = [523, 545, 606, 465] ; Ice Golem Pos 1
	Local $aSlot2[4] = [523, 460, 606, 375] ; Ice Golem Pos 2
	Local $aSlot3[4] = [270, 460, 353, 375] ; Minion Pos 1
	Local $aSlot4[4] = [185, 460, 268, 375] ; Minion Pos 1

	Local $sIceGolemTile = @ScriptDir & "\imgxml\Train\Train_Train\IceG*"
	Local $sMinionTile = @ScriptDir & "\imgxml\Train\Train_Train\Mini*"

	Local $aiTileCoord = decodeSingleCoord(findImage("UpdateNextPageDarkTroop", $sIceGolemTile, GetDiamondFromRect("520,375,692,550"), 1, True))

	If IsArray($aiTileCoord) And UBound($aiTileCoord, 1) = 2 And _ColorCheck(_GetPixelColor(777, 385 + $g_iMidOffsetY, True), Hex(0xD3D3CB, 6), 5) Then
		SetDebugLog("Found Ice Golem at " & $aiTileCoord[0] & ", " & $aiTileCoord[1])

		If PointInRect($aSlot1[0], $aSlot1[1], $aSlot1[2], $aSlot1[3], $aiTileCoord[0], $aiTileCoord[1]) Then
			Local $aiTileCoord2 = decodeSingleCoord(findImage("UpdateNextPageDarkTroop", $sMinionTile, GetDiamondFromRect("185,375,350,460"), 1, True))
			If IsArray($aiTileCoord2) And UBound($aiTileCoord2, 1) = 2 Then
				SetDebugLog("Found Minion at " & $aiTileCoord2[0] & ", " & $aiTileCoord2[1])
				If PointInRect($aSlot3[0], $aSlot3[1], $aSlot3[2], $aSlot3[3], $aiTileCoord2[0], $aiTileCoord2[1]) Then
					$g_iDarkTroopOffset = False
					SetDebugLog("Found Ice Golem at original position")
				ElseIf PointInRect($aSlot4[0], $aSlot4[1], $aSlot4[2], $aSlot4[3], $aiTileCoord2[0], $aiTileCoord2[1]) Then ; 2 Super Dark Troops -> MicroDrag Left For $eRDrag and $eETitan
					$g_iDarkTroopOffset = True
					SetDebugLog("Found Ice Golem moved 2 Slots")
				EndIf
			EndIf
			If _Sleep(100) Then Return
			Return
		EndIf

		If PointInRect($aSlot2[0], $aSlot2[1], $aSlot2[2], $aSlot2[3], $aiTileCoord[0], $aiTileCoord[1]) Then ; 1 Super Dark Troop
			$g_iDarkTroopOffset = True
			SetDebugLog("Found Ice Golem moved 1 Slots")
			If _Sleep(100) Then Return
			Return
		EndIf

	EndIf

	If _Sleep(100) Then Return

EndFunc   ;==>IsDarkTroopOffset
